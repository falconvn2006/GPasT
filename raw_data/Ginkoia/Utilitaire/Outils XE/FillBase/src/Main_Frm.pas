unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TFrm_Main = class(TForm)
    Lab_Source: TLabel;
    Edt_Source: TEdit;
    Nbt_Source: TSpeedButton;
    Lab_Destination: TLabel;
    Edt_Destination: TEdit;
    Nbt_Destination: TSpeedButton;
    Lab_Plages: TLabel;
    Lbx_Plages: TListBox;
    Btn_Traitement: TButton;
    Btn_Quitter: TButton;
    Lab_ProgressID: TLabel;
    pb_ProgressPlage: TProgressBar;
    pb_ProgressID: TProgressBar;
    Lab_ProgressPlage: TLabel;
    Lab_ProgressSQL: TLabel;
    pb_ProgressSQL: TProgressBar;
    procedure Edt_SourceChange(Sender: TObject);
    procedure Nbt_SourceClick(Sender: TObject);
    procedure Edt_DestinationChange(Sender: TObject);
    procedure Nbt_DestinationClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
    procedure Btn_TraitementClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure DoTraitement();
    procedure EnableInterface(Active : boolean);
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

uses
  DB,
  IB_Components,
  IBODataset,
  uGestionBDD,
  Generics.Collections,
  FMTBcd,
  TypInfo,
  StrUtils;

type
  TBases = class
  protected
    FNom : string;
    FnbDeb : integer;
    FnbFin : integer;

    FSourceIdMax : integer;
    FSourceVerMax : integer;
    FDestIdMax : integer;
    FDestVerMax : integer;

    function GetPlage() : string;
    procedure SetPlage(Value : string);
  public
    constructor Create(Nom, Plage : string);

    property Nom : string read FNom write FNom;
    property Plage : string read GetPlage write SetPlage;
    property nbDeb : integer read FnbDeb write FnbDeb;
    property nbFin : integer read FnbFin write FnbFin;

    property SourceIdMax : integer read FSourceIdMax write FSourceIdMax;
    property SourceVerMax : integer read FSourceVerMax write FSourceVerMax;
    property DestIdMax : integer read FDestIdMax write FDestIdMax;
    property DestVerMax : integer read FDestVerMax write FDestVerMax;
  end;

{ TBases }

function TBases.GetPlage() : string;
begin
  Result := '[' + IntToStr(Trunc(FnbDeb / 1000000)) + 'M_' + IntToStr(Trunc((FnbFin +1) / 1000000)) + 'M]';
end;

procedure TBases.SetPlage(Value : string);

  procedure DecodePlage(S: string; var Deb, fin: integer);
  var
    S1: string;
  begin
    while not CharInSet(S[1], ['0'..'9']) do
      delete(s, 1, 1);
    S1 := '';
    while CharInSet(S[1], ['0'..'9']) do
    begin
      S1 := S1 + S[1];
      delete(s, 1, 1);
    end;
    deb := Strtoint(S1) * 1000000;
    while not CharInSet(S[1], ['0'..'9']) do
      delete(s, 1, 1);
    S1 := '';
    while CharInSet(S[1], ['0'..'9']) do
    begin
      S1 := S1 + S[1];
      delete(s, 1, 1);
    end;
    fin := Strtoint(S1) * 1000000 -1;
  end;

begin
  DecodePlage(Value, FnbDeb, FnbFin);
end;

constructor TBases.Create(Nom, Plage : string);
begin
  Inherited Create();
  FNom := Nom;
  SetPlage(Plage);
  FSourceIdMax := 0;
  FSourceVerMax := 0;
  FDestIdMax := 0;
  FDestVerMax := 0;
end;

{ TFrm_Main }

procedure TFrm_Main.Edt_SourceChange(Sender: TObject);
var
  Connex : TIB_Connection;
  Trans : TIB_Transaction;
  Query : TIBOQuery;
  tmp : TBases;
begin
  if FileExists(Edt_Source.Text) then
  begin
    Lbx_Plages.Items.Clear();
    try
      try
        Connex := GetNewConnexion(Edt_Source.Text, 'ginkoia', 'ginkoia');
        Trans := GetNewTransaction(Connex, false);
        Query := GetNewQuery(Trans);

        try
          Trans.StartTransaction();
          Query.SQL.Text := 'select bas_nom, bas_plage from genbases where bas_id != 0 order by bas_ident;';
          Query.Open();
          while not Query.Eof do
          begin
            tmp := TBases.Create(Query.FieldByName('bas_nom').AsString, Query.FieldByName('bas_plage').AsString);
            Lbx_Plages.AddItem(tmp.Nom + ' - [' + IntToStr(tmp.nbDeb) + ' à ' + IntToStr(tmp.nbFin) + ']', tmp);
            Query.Next();
          end;
        finally
          Trans.Rollback();
        end;

        Lbx_Plages.SelectAll();
      finally
        FreeAndNil(Query);
        FreeAndNil(Trans);
        FreeAndNil(Connex);
      end;
    except
      on e : Exception do
        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0); 
    end;
  end;

  // bouton ?
  Btn_Traitement.Enabled := FileExists(Edt_Source.Text) and FileExists(Edt_Destination.Text);
end;

procedure TFrm_Main.Nbt_SourceClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier Interbase (*.ib)|*.ib';
    Open.InitialDir := ExtractFilePath(Edt_Source.Text);
    Open.FileName := ExtractFileName(Edt_Source.Text);
    if Open.Execute() then
      Edt_Source.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure TFrm_Main.Edt_DestinationChange(Sender: TObject);
begin
  // arf

  // bouton ?
  Btn_Traitement.Enabled := FileExists(Edt_Source.Text) and FileExists(Edt_Destination.Text);
end;

procedure TFrm_Main.Nbt_DestinationClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier Interbase (*.ib)|*.ib';
    Open.InitialDir := ExtractFilePath(Edt_Destination.Text);
    Open.FileName := ExtractFileName(Edt_Destination.Text);
    if Open.Execute() then
      Edt_Destination.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure TFrm_Main.Btn_TraitementClick(Sender: TObject);
begin
  try
    EnableInterface(false);
    DoTraitement();
  Finally
    EnableInterface(true);
  End;
end;

procedure TFrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

Procedure TFrm_Main.DoTraitement();

  function FindPlage(ID : integer) : integer;
  var
    i : integer;
    tmp : TBases;
  begin
    result := -1;
    for i := 0 to Lbx_Plages.Items.Count -1 do
    begin
      tmp := TBases(Lbx_Plages.Items.Objects[i]);
      if (id >= tmp.nbDeb) and (ID <= tmp.nbFin) then
      begin
        Result := i;
        break;
      end;
    end;
  end;

  function GetMaxId(Trans : TIB_Transaction; tmp : TBases) : integer;
  var
    Query : TIBOQuery;
  begin
    Result := 0;
    try
      try
        Query := GetNewQuery(Trans);
        Query.SQL.Text := 'Select max(k_id) as maxid from k where k_id between ' + IntToStr(tmp.nbDeb) + ' and ' + IntToStr(tmp.nbFin) + ';';
        Query.Open();
        if not Query.Eof then
          Result := Query.FieldByName('maxid').AsInteger
        else
          Result := tmp.nbDeb;
        Query.Close();
      finally
        FreeAndNil(Query);
      end;
    except
      on e : Exception do
      begin
        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
        Raise
      end;
    end;
  end;

  function GetMaxVersion(Trans : TIB_Transaction; tmp : TBases) : integer;
  var
    Query : TIBOQuery;
  begin
    Result := 0;
    try
      try
        Query := GetNewQuery(Trans);
        Query.SQL.Text := 'Select max(k_version) as maxid from k where k_version between ' + IntToStr(tmp.nbDeb) + ' and ' + IntToStr(tmp.nbFin) + ';';
        Query.Open();
        if not Query.Eof then
          Result := Query.FieldByName('maxid').AsInteger
        else
          Result := tmp.nbDeb;
        Query.Close();
      finally
        FreeAndNil(Query);
      end;
    except
      on e : Exception do
      begin
        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
        Raise
      end;
    end;
  end;

  function GetTableName(Trans : TIB_Transaction; id : integer) : string;
  var
    Query : TIBOQuery;
  begin
    try
      try
        Query := GetNewQuery(Trans);
        Query.SQL.Text := 'Select ktb_name from ktb where ktb_id = ' + IntToStr(id) + ';';
        Query.Open();
        if not Query.Eof then
          Result := Query.FieldByName('ktb_name').AsString
        else
          Raise Exception.Create('Table non trouvé !!');
        Query.Close();
      finally
        FreeAndNil(Query);
      end;
    except
      on e : Exception do
      begin
        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
        Raise
      end;
    end;
  end;

  function GetTableIdx(Trans : TIB_Transaction; TableName : string) : string;
  var
    Query : TIBOQuery;
  begin
    try
      try
        Query := GetNewQuery(Trans);
        Query.SQL.Text := 'select rtrim(rdb$relation_fields.rdb$field_name) as fieldname '
                        + 'from rdb$indices join rdb$index_segments on rdb$indices.rdb$index_name = rdb$index_segments.rdb$index_name '
                        + 'join rdb$relation_fields on rdb$relation_fields.rdb$relation_name = rdb$indices.rdb$relation_name and rdb$relation_fields.rdb$field_name = rdb$index_segments.rdb$field_name '
                        + 'where rdb$relation_name = ''' + TableName + '''  and rdb$system_flag = 0 and rdb$indices.rdb$unique_flag = 1 and (rdb$relation_fields.rdb$field_source = ''ALGOL_KEY'' or rdb$relation_fields.rdb$null_flag = 1) '
                        + 'and ((rtrim(rdb$field_name) like ''%\_ID'' escape ''\'') or (rtrim(rdb$field_name) like ''%\_ID2'' escape ''\''));';
        Query.Open();
        if not Query.Eof then
          Result := Query.FieldByName('fieldname').AsString
        else
          Raise Exception.Create('Champs ID non trouvé');
        Query.Close();
      finally
        FreeAndNil(Query);
      end;
    except
      on e : Exception do
      begin
        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
        Raise
      end;
    end;
  end;

  function GetQuotedValue(Field : TField) : string;
  begin
    case Field.DataType of
      // chaine de caractère
      TFieldType.ftString, TFieldType.ftFixedChar, TFieldType.ftWideString, TFieldType.ftFixedWideChar, TFieldType.ftMemo :
        Result := QuotedStr(Field.AsString);
      // numeric entier
      TFieldType.ftSmallint, TFieldType.ftInteger, TFieldType.ftWord, TFieldType.ftLargeint, TFieldType.ftLongWord, TFieldType.ftShortint, TFieldType.ftByte :
        Result := IntToStr(Field.AsInteger);
      // numeric a virgule
      TFieldType.ftFloat, TFieldType.ftExtended, TFieldType.ftSingle :
        Result := StringReplace(FloatToStr(Field.AsExtended), ',', '.', [rfReplaceAll]);
      TFieldType.ftCurrency :
        Result := StringReplace(CurrToStr(Field.AsCurrency), ',', '.', [rfReplaceAll]);
      TFieldType.ftBCD, TFieldType.ftFMTBcd :
        Result := StringReplace(BcdToStr(Field.AsBCD), ',', '.', [rfReplaceAll]);
      // boolean
      TFieldType.ftBoolean :
        Result := BoolToStr(Field.AsBoolean, true);
      // date et time
      TFieldType.ftDate :
        Result := QuotedStr(FormatDateTime('yyyy-mm-dd', Field.AsDateTime));
      TFieldType.ftTime :
        Result := QuotedStr(FormatDateTime('hh:nn:ss.zzz', Field.AsDateTime));
      TFieldType.ftDateTime, TFieldType.ftTimeStamp, TFieldType.ftOraTimeStamp :
        Result := QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Field.AsDateTime));
      // autres
      else
        Raise Exception.Create('Format non supporté : ' + GetEnumName(TypeInfo(TFieldType), Ord(Field.DataType)) + ' pour le champs ' + Field.FieldName);
    end;
  end;

  function CreateRequeteInsert(Query : TDataSet; TableName : string) : string;
  var
    i : integer;
    FieldsName, FieldsValue : string;
  begin
    FieldsName := '';
    FieldsValue := '';

    for i := 0 to Query.Fields.Count -1 do
    begin
      if FieldsName = '' then
        FieldsName := Query.Fields[i].FieldName
      else
        FieldsName := FieldsName + ', ' + Query.Fields[i].FieldName;

      if FieldsValue = '' then
        FieldsValue := GetQuotedValue(Query.Fields[i])
      else
        FieldsValue := FieldsValue + ', ' + GetQuotedValue(Query.Fields[i]);
    end;
    Result := 'insert into ' + TableName + ' (' + FieldsName + ') values (' + FieldsValue + ');';
  end;

  function CreateRequeteUpdate(Query : TDataSet; TableName : string; TableID : array of string) : string;
  var
    i : integer;
    Values, Condition : string;
  begin
    Values := '';
    Condition := '';

    for i := 0 to Query.Fields.Count -1 do
    begin
      if AnsiIndexStr(Query.Fields[i].FieldName, TableID) >= 0 then
      begin
        if Condition = '' then
          Condition := Query.Fields[i].FieldName + ' = ' + GetQuotedValue(Query.Fields[i])
        else
          Condition := Condition + ' and ' + Query.Fields[i].FieldName + ' = ' + GetQuotedValue(Query.Fields[i])
      end
      else
      begin
        if Values = '' then
          Values := Query.Fields[i].FieldName + ' = ' + GetQuotedValue(Query.Fields[i])
        else
          Values := Values + ', ' + Query.Fields[i].FieldName + ' = ' + GetQuotedValue(Query.Fields[i])
      end
    end;
    Result := 'update ' + TableName + ' set ' + Values + ' where ' + Condition + ';';
  end;

var
  ConnexS : TIB_Connection;
  TransS : TIB_Transaction;
  QuerySid : TIBOQuery;
  QuerySdata : TIBOQuery;

  ConnexD : TIB_Connection;
  TransD : TIB_Transaction;
  QueryMAJ : TIBOQuery;

  BasePlage, tmpPlage : TBases;

  ListeTableName : TDictionary<integer, String>;
  ListeTableID : TDictionary<string, String>;

  TableName, TableID : string;

  FileOut : TStringList;

  i, j, idTable, idEnreg, idxPlage : integer;
begin
  if FileExists(Edt_Source.Text) and FileExists(Edt_Destination.Text) then
  begin
    FileOut := TStringList.Create();

    pb_ProgressPlage.Max := Lbx_Plages.Items.Count;
    pb_ProgressPlage.Position := 0;

    try
      try
        // creation des objets !
        ListeTableName := TDictionary<integer, String>.Create();
        ListeTableID := TDictionary<string, String>.Create();
        ConnexS := GetNewConnexion(Edt_Source.Text, 'ginkoia', 'ginkoia');
        TransS := GetNewTransaction(ConnexS, false);
        ConnexD := GetNewConnexion(Edt_Destination.Text, 'ginkoia', 'ginkoia');
        TransD := GetNewTransaction(ConnexD, false);

        // recherche des limites !
        try
          TransS.StartTransaction();
          TransD.StartTransaction();

          for i := 0 to Lbx_Plages.Items.Count -1 do
          begin
            if Lbx_Plages.Selected[i] then
            begin
              BasePlage := TBases(Lbx_Plages.Items.Objects[i]);
              BasePlage.SourceIdMax := GetMaxId(TransS, BasePlage);
              BasePlage.SourceVerMax := GetMaxVersion(TransS, BasePlage);
              BasePlage.DestIdMax := GetMaxId(TransD, BasePlage);
              BasePlage.DestVerMax := GetMaxVersion(TransD, BasePlage);
            end;
          end;
        finally
          TransS.Rollback();
          TransD.Rollback();
        end;

        // init des requete
        QuerySid := GetNewQuery(TransS);
        QuerySdata := GetNewQuery(TransS);

        try
          TransS.StartTransaction();

          for i := 0 to Lbx_Plages.Items.Count -1 do
          begin
            if Lbx_Plages.Selected[i] then
            begin
              BasePlage := TBases(Lbx_Plages.Items.Objects[i]);

              FileOut.Clear();

              if BasePlage.SourceVerMax > BasePlage.DestVerMax then
              begin
                // il y a des chose a faire !
                QuerySid.SQL.Text := 'select * from k where k_version between ' + IntToStr(BasePlage.DestVerMax +1) + ' and ' + IntToStr(BasePlage.nbFin) + ';';
                try
                  QuerySid.Open();

                  pb_ProgressID.Max := QuerySid.RecordCount -1;
                  pb_ProgressID.Position := 0;

                  while not QuerySid.Eof do
                  begin
                    idTable := QuerySid.FieldByName('KTB_ID').AsInteger;
                    idEnreg := QuerySid.FieldByName('K_ID').AsInteger;
                    TableName := '';
                    TableID := '';

                    // recherche du nom de table
                    if ListeTableName.ContainsKey(idTable) then
                      TableName := ListeTableName[idTable]
                    else
                    begin
                      TableName := GetTableName(TransS, idTable);
                      ListeTableName.Add(idTable, TableName);
                    end;
                    // recherche du nom de champ
                    if ListeTableID.ContainsKey(TableName) then
                      TableID := ListeTableID[TableName]
                    else
                    begin
                      TableID := GetTableIdx(TransS, TableName);
                      ListeTableID.Add(TableName, TableID)
                    end;

                    if not ((TableName = '') or (TableID = '')) then
                    begin
                      // recup des données
                      QuerySdata.SQL.Text := 'select * from ' + TableName + ' where ' + TableID + ' = ' + IntToStr(idEnreg) + ';';
                      try
                        QuerySdata.Open();
                        if not QuerySdata.Eof then
                        begin
                          // ici 2 cas :
                          // - idEnreg <= DestMaxId -> update
                          // - idEnreg >  DestMaxId -> insert
                          idxPlage := FindPlage(idEnreg);
                          if idxPlage >= 0 then
                          begin
                            tmpPlage := TBases(Lbx_Plages.Items.Objects[idxPlage]);

                            if idEnreg > tmpPlage.DestIdMax then
                            begin
                              FileOut.Add(CreateRequeteInsert(QuerySid, 'K'));
                              FileOut.Add(CreateRequeteInsert(QuerySdata, TableName));
                            end
                            else
                            begin
                              FileOut.Add(CreateRequeteUpdate(QuerySid, 'K', ['K_ID']));
                              FileOut.Add(CreateRequeteUpdate(QuerySdata, TableName, [TableID]));
                            end;
                          end
                          else
                            MessageDlg('Pas de plage pour k_id = ' + IntToStr(idEnreg), mtError, [mbOK], 0);
                        end
                        else
                          MessageDlg('Pas de données trouver pour l''enregistrement k_id = ' + IntToStr(idEnreg), mtError, [mbOK], 0);
                      finally
                        QuerySdata.Close();
                      end;
                    end
                    else
                      MessageDlg('Pas de table/id trouver pour l''enregistrement k_id = ' + IntToStr(idEnreg), mtError, [mbOK], 0);

                    QuerySid.Next();
                    pb_ProgressID.StepIt();
                    Application.ProcessMessages();
                  end;
                finally
                  QuerySid.Close();
                end;

                // insertion !!!

                pb_ProgressSQL.Max := FileOut.Count -1;
                pb_ProgressSQL.Position := 0;

                try
                  TransD.StartTransaction();
                  try
                    QueryMAJ := GetNewQuery(TransD);
                    for j := 0 to FileOut.Count -1 do
                    begin
                      QueryMAJ.SQl.Text := FileOut[j];
                      QueryMAJ.ExecSQL();

                      pb_ProgressSQL.StepIt();
                      Application.ProcessMessages();
                    end;
                  finally
                    FreeAndNil(QueryMAJ);
                  end;
                  TransD.Commit();
                except
                  TransD.Rollback();
                  raise;
                end;
              end;
            end;

            pb_ProgressPlage.StepIt();
            Application.ProcessMessages();
          end;
        finally
          TransS.Rollback();
        end;

      finally
        FreeAndNil(TransS);
        FreeAndNil(ConnexS);

        FreeAndNil(TransD);
        FreeAndNil(ConnexD);

        FreeAndNil(ListeTableName);
        FreeAndNil(ListeTableID);
      end;
    except
      on e : Exception do
        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0); 
    end;

//    FileOut.SaveToFile('C:\Test.sql');
  end;
end;

procedure TFrm_Main.EnableInterface(Active : boolean);
begin
  Edt_Source.Enabled := Active;
  Nbt_Source.Enabled := Active;
  Edt_Destination.Enabled := Active;
  Nbt_Destination.Enabled := Active;
  Lbx_Plages.Enabled := Active;

  Btn_Traitement.Enabled := Active and FileExists(Edt_Source.Text) and FileExists(Edt_Destination.Text);
  Btn_Quitter.Enabled := Active;
end;

end.
