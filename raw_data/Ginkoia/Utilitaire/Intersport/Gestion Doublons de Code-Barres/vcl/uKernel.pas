unit uKernel;

interface

uses
  System.Generics.Collections,

  System.Threading, System.Classes, System.SysUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.IBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt;

type
  TBarCodeManager = class
  strict private
    FFDConnection: TFDConnection;
    FFDQuery: TFDQuery;
  private
    FDatabase: string;
    FFileName: string;
    FShopsID: TArray<Integer>;
    FBarCodes: TList<string>;
  public type
    TShop = class(TObject)   
      ID: Integer;
      Name: string;
      constructor Create(const ID: Integer; const Name: string);
    end;
    TShops = TObjectList<TShop>;
    TDelayedStockState = (dssUnknown, dssEnabled, dssDisabled);
    TDelayedStock = class(TObject)
      State: TDelayedStockState;
      Count: Integer;
    end;
    TBarCodeInfo = class(TObject)
      &Type, Quantity: Integer;
    end;
  public
    constructor Create;
    destructor Destroy; override;
    
    // Vérifie si la connexion est possible
    class function CanConnect(const Database: string): Boolean; static;
    // Vérifie si le fichier peut être créé
    class function CanCreate(const FileName: string;
      const OverWrite: Boolean = False): Boolean; static;
    // Vérifie si le fichier peut être ouvert en lecture/écriture
    class function CanReadAndWrite(const FileName: string): Boolean; static;
    class function CanCreateOrReadAndWrite(const FileName: string): Boolean; static;

    // Connexion à la base de donnée
    procedure Connect(const Database: string);
    // Récupération de la liste des magasins (ID/Name)
    procedure ListShops(out List: TShops);
    // Récupération de l'état du générateur GENTRIGGER (State/Count)
    procedure DelayedStock(out DelayedStock: TDelayedStock);

    function Connected: Boolean;

    function SelectedShopsID: string;
    // Récupération de la liste des code barres...
    procedure ListBarCodes;
    // Récupération des quantités des codes barres...
    procedure ListBarCodesQuantity(out List: TDictionary<string, string>);
    // Récupération des informations des codes barres...
    procedure ListBarCodesInfos(out List: TObjectDictionary<string, TBarCodeInfo>);

    procedure ExecuteStockCalculation(const Step: Cardinal = 500);


    // Execute le traitement spécifié
    procedure ExecuteCreate;
    procedure ExecuteComplete(const Filtered: Boolean);

    { properties }
    property Database: string read FDatabase write FDatabase;
    property FileName: string read FFileName write FFileName;
    property ShopsID: TArray<Integer> read FShopsID write FShopsID;
    property BarCodes: TList<string> read FBarCodes write FBarCodes;
  end;

implementation

{ TBarCodeManager }

class function TBarCodeManager.CanConnect(const Database: string): Boolean;
var
  FDConnection: TFDConnection;
begin
  Result := False;
  try
    FDConnection := TFDConnection.Create(nil);
    try
      FDConnection.LoginPrompt := False;
      FDConnection.Params.Values['DriverID'] := 'IB';
      FDConnection.Params.Values['Database'] := Database;
      FDConnection.Open('sysdba', 'masterkey');
      FDConnection.Close;
      Result := True;
    finally
      FDConnection.Free;
    end;
  except
  end;
end;

class function TBarCodeManager.CanCreate(const FileName: string;
  const OverWrite: Boolean): Boolean;
var
  Exists: Boolean;
  FileStream: TFileStream;
begin
  Result := False;
  Exists := FileExists(FileName);
  if (not Exists) or OverWrite then
  begin
    try
      FileStream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
      try
        Result := True;
      finally
        FileStream.Free;
      end;
      DeleteFile(FileName);
    except
    end;
  end;
end;

class function TBarCodeManager.CanCreateOrReadAndWrite(
  const FileName: string): Boolean;
begin
  Result := CanCreate(FileName) or CanReadAndWrite(FileName);
end;

class function TBarCodeManager.CanReadAndWrite(const FileName: string): Boolean;
var
  FileStream: TFileStream;
begin
  Result := False;
  try
    FileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite);
    try
      Result := True;
    finally
      FileStream.Free;
    end;
  except
  end;
end;

procedure TBarCodeManager.Connect(const Database: string);
begin
  FDatabase := '';

  if FFDConnection.Connected then
    FFDConnection.Close;

  FFDConnection.LoginPrompt := False;
  FFDConnection.Params.Values['DriverID'] := 'IB';
  FFDConnection.Params.Values['Database'] := Database;
  FFDConnection.Open('sysdba', 'masterkey');

  FDatabase := Database;
end;

function TBarCodeManager.Connected: Boolean;
begin
  Result := Assigned(FFDConnection) and FFDConnection.Connected;
end;

constructor TBarCodeManager.Create;
begin
  inherited;

  FFDConnection := TFDConnection.Create(nil);
  FFDQuery := TFDQuery.Create(nil);
  FFDQuery.Connection := FFDConnection;

  FBarCodes := TList<string>.Create;
end;

procedure TBarCodeManager.DelayedStock(out DelayedStock: TDelayedStock);
begin
  DelayedStock := nil;
  if not FFDConnection.Connected then
    Exit;

  try
    // Récupération de la valeur du générateur GENTRIGGER
    FFDQuery.Open('select gen_id(gentrigger,0) as "Enabled" from rdb$database');
    DelayedStock := TDelayedStock.Create;
    case FFDQuery.FieldByName('Enabled').AsInteger of
      0: // Actif
        begin
          DelayedStock.State := dssEnabled;
          // Récupération du nombre de ligne dans la table GENTRIGGERDIFF
          FFDQuery.Open('select count(*) as "Count" ' +
                        'from gentriggerdiff ' +
                        'where tri_id != 0 ' +
                        '  and tri_maj != 0 ' +
                        '  and tri_magid != 0');
          DelayedStock.Count := FFDQuery.FieldByName('count').AsInteger;
        end;
      1: // Inactif
        begin
          DelayedStock.State := dssDisabled;
          DelayedStock.Count := -1;
        end
      else
        begin
          DelayedStock.State := dssUnknown;
          DelayedStock.Count := -1;
        end;
    end;
  finally
    FFDQuery.SQL.Clear;
    FFDQuery.Close;
  end;
end;

destructor TBarCodeManager.Destroy;
begin
  FFDQuery.Free;
  FFDConnection.Free;

  FBarCodes.Free;

  inherited;
end;

procedure TBarCodeManager.ExecuteComplete;

  procedure ForEachLines(const Lines: TStringList;
    Proc: TProc<TStringList, Integer, Integer>);
  var
    StringList: TStringList;
    Count, I: Integer;
  begin
    StringList := TStringList.Create;
    try
      StringList.StrictDelimiter := True;
      StringList.Delimiter := ';';
      Count := Pred(Lines.Count);
      for I := 0 to Count do
      begin
        StringList.DelimitedText := Lines[I];
        Proc(StringList, I, Count);
      end;
    finally
      StringList.Free;
    end;
  end;

var
  FileStream: TFileStream;
  StringList: TStringList;
  StreamWriter: TStreamWriter;
begin
  FileStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyWrite);
  try
    if FileStream.Size = 0 then
      Exit;

    StringList := TStringList.Create;
    try
      StringList.LoadFromStream(FileStream, TEncoding.ANSI);

      StreamWriter := TStreamWriter.Create(FileStream, TEncoding.ANSI);
      try
        FileStream.Size := 0;
        try
          ForEachLines(
            StringList,
            procedure(Items: TStringList; Index, Count: Integer)
            var
              State: string;
              &Type: string;
            begin
              if Index = 0 then
                // Gestion de l'entête
                StreamWriter.WriteLine(Items.DelimitedText)
              else
              begin
                try
                  if Filtered and (StrToInt64(Items[1]) = 0) then
                    Exit;

                  FFDQuery.Open('select cbi_type ' +
                                'from artcodebarre ' +
                                'join k kcbi on kcbi.k_id = cbi_id and kcbi.k_enabled = 1 ' +
                                'where cbi_cb = ' + QuotedStr(Items[0]));

                  if Filtered and (FFDQuery.FieldByName('cbi_type').AsInteger <> 1) then
                    Exit;

                  if FFDQuery.IsEmpty then
                  begin
                    State := 'OK';
                    &Type := '';
                  end
                  else
                  begin
                    State := 'KO';
                    &Type := FFDQuery.FieldByName('cbi_type').AsString;
                  end;

                  FFDQuery.Open('select sum(stc_qte) "Quantity" ' +
                                'from artcodebarre ' +
                                'join k kcbi on kcbi.k_id = cbi_id and kcbi.k_enabled = 1 ' +
                                'join artreference on arf_id = cbi_arfid ' +
                                'join k karf on karf.k_id = arf_id and karf.k_enabled = 1 ' +
                                'join k kart on kart.k_id = arf_artid and kart.k_enabled = 1 ' +
                                'join agrstockcour on stc_artid = arf_artid ' +
                                '                 and stc_tgfid = cbi_tgfid ' +
                                '                 and stc_couid = cbi_couid ' +
                                '                 and stc_magid in (' + SelectedShopsID + ') ' +
                                'where cbi_cb = ' + QuotedStr(Items[0]) + ' ' +
                                'group by cbi_cb ');

                  if Filtered and (FFDQuery.FieldByName('Quantity').AsInteger = 0) then
                    Exit;

                  if FFDQuery.IsEmpty then
                    StreamWriter.WriteLine('%s;%s;%s;%s;0', [
                      Items[0],
                      Items[1],
                      State,
                      &Type
                    ])
                   else
                    StreamWriter.WriteLine('%s;%s;%s;%s;%s', [
                      Items[0],
                      Items[1],
                      State,
                      &Type,
                      FFDQuery.FieldByName('Quantity').AsString
                    ]);
                except
                end;
              end;
            end
          );
        finally
          FFDQuery.SQL.Clear;
          FFDQuery.Close;
        end;

      finally
        StreamWriter.Free;
      end;

    finally
      StringList.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TBarCodeManager.ExecuteCreate;
var
  FileStream: TFileStream;
  BarCodesQuantity: TDictionary<string{BarCode}, string{Quantity}>;
  StreamWriter: TStreamWriter;
  BarCode: string;
  StringList: TStringList;
begin
  ListBarCodes;
  ListBarCodesQuantity(BarCodesQuantity);
  try
    FileStream := TFileStream.Create(FFileName, fmCreate or fmShareDenyWrite);
    try
      StreamWriter := TStreamWriter.Create(FileStream, TEncoding.ANSI);
      try
        StreamWriter.WriteLine('CODE_BARRE;QUANTITE_STOCK_ORIGINE;ETAT;TYPE_CB_DESTINATION;QUANTITY_STOCK_DESTINATION_CB');
        if (not Assigned(BarCodesQuantity)) 
        or (BarCodesQuantity.Count = 0) then {skip when there is no items}
          Exit;
        StringList := TStringList.Create;
        try
          StringList.StrictDelimiter := True;
          StringList.Delimiter := ';';
          for BarCode in BarCodesQuantity.Keys do
            StreamWriter.WriteLine('%s;%s;;;', [BarCode, BarCodesQuantity[BarCode]]);
        finally
          StringList.Free;
        end;
      finally
        StreamWriter.Free;
      end;
    finally
      FileStream.Free;
    end;
  finally
    BarCodesQuantity.Free;
  end;
end;

procedure TBarCodeManager.ExecuteStockCalculation(const Step: Cardinal);
var
  bStockCalculationIsDone: Boolean;
begin
  if not FFDConnection.Connected then
    Exit;
  try
    // Préparation
    FFDQuery.ExecSQL('execute procedure eai_trigger_pretraite');

    bStockCalculationIsDone := False;
    repeat
      FFDQuery.Open('select RETOUR from eai_trigger_differe(:STEP)', [Step]);
      bStockCalculationIsDone := FFDQuery.FieldByName('RETOUR').AsInteger = 0;
    until bStockCalculationIsDone;
  finally
    FFDQuery.SQL.Clear;
    FFDQuery.Close;
  end;
end;

procedure TBarCodeManager.ListBarCodes;
var
  Year, Month, Day: Word;
begin
  if not FFDConnection.Connected then
    Exit;
  try
    FBarCodes.Clear;
    {$REGION 'Récupération des codes-barres ayant du stock'}
    FFDQuery.Open('select distinct cbi_cb ' +
                  'from artcodebarre ' +
                  'join k kcbi on kcbi.k_id = cbi_id and kcbi.k_enabled = 1 ' +
                  'join artreference on arf_id = cbi_arfid ' +
                  'join k karf on karf.k_id = arf_id and karf.k_enabled = 1 ' +
                  'join k kart on kart.k_id = arf_artid and kart.k_enabled = 1 ' +
                  'join agrstockcour on stc_artid = arf_artid ' +
                  '  and stc_tgfid = cbi_tgfid ' +
                  '  and stc_couid = cbi_couid ' +
                  '  and stc_magid in (' + SelectedShopsID + ') ' +
                  'where cbi_id != 0 ' +
                  '  and cbi_type = 1 ' +
                  'group by cbi_cb ' +
                  'having sum(stc_qte) > 0 ');
    while not FFDQuery.Eof do
    begin
      if FBarCodes.IndexOf(FFDQuery.FieldByName('cbi_cb').AsString) < 0 then
        FBarCodes.Add(FFDQuery.FieldByName('cbi_cb').AsString);
      FFDQuery.Next;
    end;
    {$ENDREGION}

    {$REGION 'Récupération des codes-barres ayant du RAL'}
    FFDQuery.Open('select distinct cbi_cb ' +
                  'from artcodebarre ' +
                  'join k kcbi on kcbi.k_id = cbi_id and kcbi.k_enabled = 1 ' +
                  'join artreference on arf_id = cbi_arfid ' +
                  'join k karf on karf.k_id = arf_id and karf.k_enabled = 1 ' +
                  'join k kart on kart.k_id = arf_artid and kart.k_enabled = 1 ' +
                  'join combcdel on cdl_artid = arf_artid ' +
                  '             and cdl_tgfid = cbi_tgfid ' +
                  '             and cdl_couid = cbi_couid ' +
                  'join k kcdl on kcdl.k_id = cdl_id and kcdl.k_enabled = 1 ' +
                  'join combcde on cde_id = cdl_cdeid ' +
                  'join k kcde on kcde.k_id = cde_id and kcde.k_enabled = 1 ' +
                  '           and cde_magid in (' + SelectedShopsID + ') ' +
                  'join agrral on ral_cdlid = cdl_id ' +
                  'where cbi_id != 0 ' +
                  '  and cbi_type = 1 ' +
                  'group by cbi_cb ' +
                  'having sum(ral_qte) > 0 ');
    while not FFDQuery.Eof do
    begin
      if FBarCodes.IndexOf(FFDQuery.FieldByName('cbi_cb').AsString) < 0 then
        FBarCodes.Add(FFDQuery.FieldByName('cbi_cb').AsString);
      FFDQuery.Next;
    end;
    {$ENDREGION}

    {$REGION 'Récupération des codes-barres ayant du mouvement'}
    DecodeDate(Now, Year, Month, Day);
    FFDQuery.Open('select distinct cbi_cb ' +
                  'from artcodebarre ' +
                  'join k kcbi on kcbi.k_id = cbi_id and kcbi.k_enabled = 1 ' +
                  'join artreference on arf_id = cbi_arfid ' +
                  'join k karf on karf.k_id = arf_id and karf.k_enabled = 1 ' +
                  'join k kart on kart.k_id = arf_artid and kart.k_enabled = 1 ' +
                  'join agrmouvement on mvt_artid = arf_artid ' +
                  '                 and mvt_tgfid = cbi_tgfid ' +
                  '                 and mvt_couid = cbi_couid ' +
                  '                 and mvt_magidx in (' + SelectedShopsID + ') ' +
                  '                 and mvt_datex >= extract(year from f_addyear(current_date, -2)) || ''-01-01 ''' +
                  'where cbi_id != 0 ' +
                  '  and cbi_type = 1 ' +
                  'group by cbi_cb ' +
                  'having sum(mvt_qte) > 0 ');
    while not FFDQuery.Eof do
    begin
      if FBarCodes.IndexOf(FFDQuery.FieldByName('cbi_cb').AsString) < 0 then
        FBarCodes.Add(FFDQuery.FieldByName('cbi_cb').AsString);
      FFDQuery.Next;
    end;
    {$ENDREGION}
  finally
    FFDQuery.SQL.Clear;
    FFDQuery.Close;
  end;
end;

procedure TBarCodeManager.ListBarCodesInfos(
  out List: TObjectDictionary<string, TBarCodeInfo>);
var
  BarCode: string;
  BarCodeInfo: TBarCodeInfo;
begin
  List := nil;
  if (not FFDConnection.Connected) or (FBarCodes.Count = 0) then
    Exit;
  try
    FFDQuery.Open('select artcodebarre.cbi_cb, sum(stc_qte) "Quantity" ' +
                  'from artcodebarre ' +
                  'join k kcbi on kcbi.k_id = cbi_id and kcbi.k_enabled = 1 ' +
                  'join artreference on arf_id = cbi_arfid ' +
                  'join k karf on karf.k_id = arf_id and karf.k_enabled = 1 ' +
                  'join k kart on kart.k_id = arf_artid and kart.k_enabled = 1 ' +
                  'join agrstockcour on stc_artid = arf_artid ' +
                  '                 and stc_tgfid = cbi_tgfid ' +
                  '                 and stc_couid = cbi_couid ' +
                  '                 and stc_magid in (' + SelectedShopsID + ') ' +
                  'group by cbi_cb ');
    if FFDQuery.IsEmpty then
      Exit;

    List := TObjectDictionary<string, TBarCodeInfo>.Create([doOwnsValues]);
    while not FFDQuery.Eof do
    begin
      if FBarCodes.Contains(BarCode) then
      begin
        BarCode := FFDQuery.FieldByName('cbi_cb').AsString;
        BarCodeInfo := TBarCodeInfo.Create;
        BarCodeInfo.&Type := 0;
        BarCodeInfo.Quantity := FFDQuery.FieldByName('Quantity').AsInteger;

        List.Add(BarCode, BarCodeInfo);
      end;
      FFDQuery.Next;
    end;
  finally
    FFDQuery.SQL.Text;
    FFDQuery.Close;
  end;
end;

procedure TBarCodeManager.ListBarCodesQuantity(
  out List: TDictionary<string, string>);
var
  BarCode: string;
begin
  List := nil;
  if (not FFDConnection.Connected) or (FBarCodes.Count = 0) then
    Exit;
  try
    FFDQuery.Open('select artcodebarre.cbi_cb, sum(stc_qte) "Quantity" ' +
                  'from artcodebarre ' +
                  'join k kcbi on kcbi.k_id = cbi_id and kcbi.k_enabled = 1 ' +
                  'join artreference on arf_id = cbi_arfid ' +
                  'join k karf on karf.k_id = arf_id and karf.k_enabled = 1 ' +
                  'join k kart on kart.k_id = arf_artid and kart.k_enabled = 1 ' +
                  'join agrstockcour on stc_artid = arf_artid ' +
                  '                 and stc_tgfid = cbi_tgfid ' +
                  '                 and stc_couid = cbi_couid ' +
                  '                 and stc_magid in (' + SelectedShopsID + ') ' +
                  'where cbi_type = 1 ' +
                  'group by cbi_cb ');
    if FFDQuery.IsEmpty then
      Exit;

    List := TDictionary<string, string>.Create;
    while not FFDQuery.Eof do
    begin
      BarCode := FFDQuery.FieldByName('cbi_cb').AsString;
      if FBarCodes.Contains(BarCode) then
        List.Add(BarCode, FFDQuery.FieldByName('Quantity').AsString);
      FFDQuery.Next;
    end;
  finally
    FFDQuery.SQL.Text;
    FFDQuery.Close;
  end;
end;

procedure TBarCodeManager.ListShops(out List: TShops);
begin
  List := nil;
  if not FFDConnection.Connected then
    Exit;
  try
    FFDQuery.Open('select genmagasin.mag_id, genmagasin.mag_enseigne ' +
                  'from genmagasin ' +
                  'join k kmag on kmag.k_id = genmagasin.mag_id and kmag.k_enabled = 1 ' +
                  'where genmagasin.mag_id != 0 ' +
                  'order by genmagasin.mag_enseigne asc ');
    if FFDQuery.IsEmpty then
      Exit;
        
    List := TShops.Create;
    while not FFDQuery.Eof do
    begin
      List.Add(TShop.Create(
        FFDQuery.FieldByName('mag_id').AsInteger,
        FFDQuery.FieldByName('mag_enseigne').AsString
      ));
      FFDQuery.Next;
    end;
  finally
    FFDQuery.SQL.Clear;
    FFDQuery.Close;  
  end;
end;

function TBarCodeManager.SelectedShopsID: string;
var
  ShopID: Integer;
  StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
    StringList.StrictDelimiter := True;
    StringList.Delimiter := ',';
    for ShopID in FShopsID do
      StringList.Add(ShopID.ToString);
    Result := StringList.DelimitedText;
  finally
    StringList.Free;
  end;
end;

{ TBarCodeManager.TShop }

constructor TBarCodeManager.TShop.Create(const ID: Integer; const Name: string);
begin
  Self.ID := ID;
  Self.Name := Name;
end;

end.
