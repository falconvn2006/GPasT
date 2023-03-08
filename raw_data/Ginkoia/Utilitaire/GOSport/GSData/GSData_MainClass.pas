unit GSData_MainClass;

interface

uses DBClient, MidasLib, Db, Classes, SysUtils, Graphics, xmldom, XMLIntf, GSData_Types, Types,
     msxmldom, Variants, DateUtils, IBODataset, Forms, ComCtrls, Windows, StdCtrls;

const
    CTE_NONE            = 0 ;
    CTE_INTERSPORT      = 1 ;
    CTE_COURIR          = 6 ;
    CTE_GOSPORT         = 7 ;
    CTE_INTERNATIONAL   = 8 ;

type
  TMagType   = (mtNone, mtGoSport, mtCourir) ;
//CAF
  TMagMode   = (mtAutre, mtAffilie, mtCAF, mtMandat);
  TExportType = (etNone, etEveryStores, etSelectStores, etAuto);
//

  TMainClass = Class(TObject)
  private
    FFilesPath      : TStringDynArray;
    FTitle          : String;
    FLabel          : TLabel ;
    FProgressBar    : TProgressBar;
    FLabelError     : TLabel ;

  protected
    FCds            : TClientDataset;

    FIboQuery       : TIboQuery;
    FIBOStoredProc  : TIBOStoredProc;
    FISUPDATED      : Boolean;
    FIsCreated      : Boolean;
    FIsOnError      : Boolean;
    FInsertCount,
    FMajCount,
    FErrorCount,
    FErrorTotal     : Integer;

    FMAGID          : Integer;
    FMAGCODEADH     : String;
    FMagType        : TMagType ;
//CAF
    FMagMode        : TMagMode;
//
    FBaseVersion    : Integer ;

    FCount          : Integer;

    FIboQueryTmp : TIboQuery;
    FPrepare : Boolean;
    procedure IncError( AInc : Integer = 1 ) ;
  public
    function GetIDFromTable(ATableName, ASearchField, ASearchData, AFieldID : String) : Integer;overload;
    function GetIDFromTable(ATableName, ASearchField : String; ASearchData : Integer; AFieldID : String) : Integer;overload;
    function GetIDFromTable(ATableName : string; ASearchField : array of String; ASearchData : array of Integer; AFieldID : String) : Integer;overload;

    constructor Create;virtual;
    destructor Destroy;override;

    // Importe les données dans le cliendataset (Voir chaque enfant pour le code)
    procedure Import;virtual;
    // Permet de transferer les données dans la base de données (Voir chaque enfant pour code)
    function DoMajTable : Boolean;virtual;
    // Permet de récupérer le nombre d'enregistrement traiter
    function Count : Integer;virtual;

    // Permet de récupérer l'id d'un code
    function GetIdByCode(ACode : String ; ACenCode : Integer) : Integer;virtual;

    // procedure qui permet de récupérer les paramètres dans GenParam
    procedure GetGenParam(APRM_TYPE, APRM_CODE : Integer; var PRM_INTEGER : Integer;bZeroInError : Boolean = True);overload;
    procedure GetGenParam(APRM_TYPE, APRM_CODE, APRM_MAGID : Integer;var PRM_INTEGER : Integer;bZeroInError : Boolean = True);overload;
    procedure GetGenParam(APRM_TYPE, APRM_CODE, APRM_MAGID : Integer;var PRM_INTEGER : Integer; var PRM_FLOAT : Double; var PRM_STRING : String; bZeroInError : Boolean = True);overload;
    procedure GetGenParam(APRM_TYPE, APRM_CODE : Integer; var APRM_STRING : String);overload;
    // procedure qui permet de sauvegader les paramètres dans GenParam
    procedure SetGenParam(APRM_TYPE, APRM_CODE, APRM_INTEGER, APRM_MAGID : Integer);overload;
    procedure SetGenParam(APRM_TYPE, APRM_CODE, APRM_INTEGER : Integer; APRM_FLOAT : Double; APRM_MAGID : Integer);overload;

    // fonction de récupération du CODE_ARTICLE dans la table ARTRELATIONART
    function InitCodeArticle : Boolean;
    function GetCodeArticle (ACodeArticle : String;APrepare : Boolean = False) : TCodeArticle;

    // Converti les dates des fichiers en TDate
    function ConvertDate(ADate : String): TDate;

    // Converti un nombre en réel
    function ConvertFloat(ANombre : String): Double;

    // Procedure d'affichage pour les composants label et progressbar
    procedure LabCaption (AText : String);
    procedure BarPosition( APosition : Integer);

  published
    property IboQuery : TIboQuery read FIboQuery write FIboQuery;
    property IboQueryTmp : TIboQuery read FIboQueryTmp write FIboQueryTmp;

    property IBOStoredProc : TIBOStoredProc read FIBOStoredProc write FIBOStoredProc;

    property Insertcount : integer          read FInsertCount write FInsertCount;
    property Majcount    : integer          read FMajCount write FMajCount;
    property ErrorCount  : integer          read FErrorCount write FErrorCount;
    property ErrorTotal  : integer          read FErrorTotal write FErrorTotal;

    // Nom du module en train d'êter traiter
    property Title : String read FTitle write FTitle;
    // Liste des fichiers à traiter dans le module
    property FilesPath : TStringDynArray read FFilesPath Write FFilesPath;
    // Permet de renseigner le MAG_ID en cours
    property MAG_ID   : Integer read FMAGID write FMAGID;                       // ID Magasin
    property MAG_TYPE : TMagType read FmagType write FMagType ;                 // Type de Magasin (1: GoSport / 2: Courir)
//CAF
    property MAG_MODE : TMagMode read FMagMode write FMagMode ;                 // Mode de gestion Magasin (1: Affilié / 2= CAF)
//
    property MAG_CODEADH : String read FMAGCODEADH write FMAGCODEADH;
    property BASE_VER : Integer read FBaseVersion write FBaseVersion ;

    // Fonctions / procédures du CDS
    property ClientDataset : TClientDataSet read FCDs;

    function FieldByName(sFieldName : String) : TField;
    procedure Next;
    function EOF : Boolean;
    procedure First;
    procedure Append;
    procedure Post;
    procedure Edit;

    // Permet de créer les champs du FCDS
    function CreateField(AFieldNameArray : array of String; AFieldTypeArray : array of TFieldType) : Boolean;

    // Propriete permettant de connaitre le status d'un enfant
    property IsCreated : Boolean            read FIsCreated write FIsCreated;
    property IsUpdated : Boolean            read FISUPDATED write FISUPDATED;
    property IsOnError : Boolean            read FIsOnError write FIsOnError;

    // Propriétés permettant de gérer des composants Externes
    property LabProgress : TLabel read FLabel write FLabel ;
    property ProgressBar : TProgressBar read FProgressBar write FProgressBar;
    property LabError    : TLabel read FLabelError write FLabelError ;
  End;


implementation

{ TMainClass }

procedure TMainClass.Append;
begin
  FCds.Append;
end;

procedure TMainClass.BarPosition(APosition: Integer);
begin
  if FProgressBar <> Nil then
    FProgressBar.Position := APosition;
  Application.ProcessMessages;
end;

constructor TMainClass.Create;
begin
  inherited Create;
  FCds := TClientDataSet.Create(nil) ;

  FErrorCount := 0 ;
  FErrorTotal := 0 ;
  FCount := 0;
  FMagType := mtCourir ;                         // Default value
end;

function TMainClass.CreateField(AFieldNameArray: array of String;
  AFieldTypeArray: array of TFieldType): Boolean;
var
  i : Integer;
begin
  Result := False;
  if High(AFieldNameArray) <> High(AFieldTypeArray) then
    raise Exception.Create('Nombre incorrect de champ et de type');

  try
    FCds.FieldDefs.Clear;
    for i := Low(AFieldNameArray) to High(AFieldNameArray) do
    begin
      case AFieldTypeArray[i] of
        ftString: FCDs.FieldDefs.Add(AFieldNameArray[i],ftString,64);
        else begin
          FCDs.FieldDefs.Add(AFieldNameArray[i],AFieldTypeArray[i]);
        end;
      end; // case
    end; // for
    FCds.CreateDataSet;
    FCds.LogChanges := False;// Fix: Bug MDC
    FCds.Active := True;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('CreateField -> ' + E.Message);
  end;
end;

destructor TMainClass.Destroy;
begin
  if Assigned(FCds) then
    FCds.Free;
  inherited;
end;

function TMainClass.DoMajTable : Boolean;
begin
  FInsertCount := 0;
  FMajCount    := 0;
end;

procedure TMainClass.Edit;
begin
  FCds.Edit;
end;

function TMainClass.EOF: Boolean;
begin
  try
    Result := Fcds.Eof;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  end;
end;

function TMainClass.FieldByName(sFieldName: String): TField;
begin
  Try
    Result := FCds.FieldByName(sFieldName);
  Except on E:Exception do
    raise Exception.Create(E.Message);
  end;
end;

procedure TMainClass.First;
begin
  try
    FCds.First;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  end;
end;

procedure TMainClass.GetGenParam(APRM_TYPE, APRM_CODE, APRM_MAGID: Integer;
  var PRM_INTEGER: Integer; bZeroInError: Boolean);
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_INTEGER from GENPARAM');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_MAGID = :PPRMMAGID');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := APRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := APRM_CODE;
    ParamByName('PPRMMAGID').AsInteger := APRM_MAGID;
    Open;
    if RecordCount > 0 then
      PRM_INTEGER := FieldByName('PRM_INTEGER').AsInteger
    else
      PRM_INTEGER := -1;

    case PRM_INTEGER of
     -1: raise ENOTFIND.Create('Configuration incorrecte -> (' + IntToStr(APRM_TYPE) + '/' + IntToStr(APRM_CODE) + ') paramètre inéxistant');
      0: begin
        if bZeroInError then
          raise ECFGERROR.Create('Configuration incorrecte -> (' + IntToStr(APRM_TYPE) + '/' + IntToStr(APRM_CODE) + ') valeur 0 ');
      end;
    end;
  end;
end;

procedure TMainClass.GetGenParam(APRM_TYPE, APRM_CODE: Integer;
  var PRM_INTEGER: Integer; bZeroInError: Boolean);
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_INTEGER from GENPARAM');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := APRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := APRM_CODE;
    Open;
    if RecordCount > 0 then
      PRM_INTEGER := FieldByName('PRM_INTEGER').AsInteger
    else
      PRM_INTEGER := -1;

    case PRM_INTEGER of
     -1: raise ENOTFIND.Create('Configuration incorrecte -> (' + IntToStr(APRM_TYPE) + '/' + IntToStr(APRM_CODE) + ') paramètre inéxistant');
      0: begin
        if bZeroInError then
          raise ECFGERROR.Create('Configuration incorrecte -> (' + IntToStr(APRM_TYPE) + '/' + IntToStr(APRM_CODE) + ') valeur 0 ');
      end;
    end;
  end;
end;

function TMainClass.InitCodeArticle: Boolean;
begin
  With IboQueryTmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select ARA_ARTID, ARA_TGFID, ARA_COUID from ARTRELATIONART');
    SQL.Add('  Join K on K_ID = ARA_ID and K_Enabled = 1');
    SQL.Add('Where ARA_CODEART = :PCODEART');
    Prepared := True;
    ParamCheck := True;
  end;
end;

function TMainClass.GetCodeArticle(ACodeArticle: String;APrepare : Boolean = False): TCodeArticle;
begin
  try
    if APrepare then
    begin
      With FIboQueryTmp do
      begin
        Close;
        ParamByName('PCODEART').AsString := ACodeArticle;
        Open;

        if RecordCount > 0 then
        begin
          Result.ART_ID := FieldByName('ARA_ARTID').AsInteger;
          Result.TGF_ID := FieldByName('ARA_TGFID').AsInteger;
          Result.COU_ID := FieldByName('ARA_COUID').AsInteger;
        end
        else
          raise ENOTFIND.Create('GetCodeArticle -> Code Article non trouvé : ' + ACodeArticle);
      end;
    end
    else
      With FIboQuery do
      begin

        Close;
        SQL.Clear;
        SQL.Add('Select ARA_ARTID, ARA_TGFID, ARA_COUID from ARTRELATIONART');
        SQL.Add('  Join K on K_ID = ARA_ID and K_Enabled = 1');
        SQL.Add('Where ARA_CODEART = :PCODEART');
        ParamCheck := True;

        ParamByName('PCODEART').AsString := ACodeArticle;
        Open;

        if RecordCount > 0 then
        begin
          Result.ART_ID := FieldByName('ARA_ARTID').AsInteger;
          Result.TGF_ID := FieldByName('ARA_TGFID').AsInteger;
          Result.COU_ID := FieldByName('ARA_COUID').AsInteger;
        end
        else
          raise ENOTFIND.Create('GetCodeArticle -> Code Article non trouvé : ' + ACodeArticle);
      end;
  Except
    on E:ENOTFIND do
      raise ENOTFIND.Create(E.Message);
    on E:Exception do
      raise Exception.Create('GetCodeArticle -> ' + E.Message);
  end;
end;

procedure TMainClass.GetGenParam(APRM_TYPE, APRM_CODE: Integer;
  var APRM_STRING: String);
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_STRING from GENPARAM');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := APRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := APRM_CODE;
    Open;
    if RecordCount > 0 then
      APRM_STRING := FieldByName('PRM_STRING').AsString
    else
      APRM_STRING := '';
  end;
end;

procedure TMainClass.GetGenParam(APRM_TYPE, APRM_CODE, APRM_MAGID: Integer;
  var PRM_INTEGER: Integer; var PRM_FLOAT: Double; var PRM_STRING: String;
  bZeroInError: Boolean);
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_INTEGER, PRM_FLOAT, PRM_STRING from GENPARAM');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_MAGID = :PPRMMAGID');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := APRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := APRM_CODE;
    PAramByName('PPRMMAGID').AsInteger := APRM_MAGID;
    Open;
    if RecordCount > 0 then
    begin
      PRM_INTEGER := FieldByName('PRM_INTEGER').AsInteger;
      PRM_FLOAT   := FieldByName('PRM_FLOAT').AsFloat;
      PRM_STRING  := FieldByName('PRM_STRING').AsString;
    end
    else
      PRM_INTEGER := -1;

    case PRM_INTEGER of
     -1: raise ENOTFIND.Create('Configuration incorrecte -> (' + IntToStr(APRM_TYPE) + '/' + IntToStr(APRM_CODE) + ') paramètre inéxistant');
      0: begin
        if bZeroInError then
          raise ECFGERROR.Create('Configuration incorrecte -> (' + IntToStr(APRM_TYPE) + '/' + IntToStr(APRM_CODE) + ') valeur 0 ');
      end;
    end;
  end;

end;

function TMainClass.GetIdByCode(ACode: String ; ACenCode : Integer): Integer;
begin
  raise Exception.Create('Doit être dérivé pour fonctionner');
 // Ne pas effacer
end;

function TMainClass.GetIDFromTable(ATableName: string;
  ASearchField: array of String; ASearchData: array of Integer;
  AFieldID: String): Integer;
var
  i : Integer;
begin
  Result := -1;

  if High(ASearchField) <> High(ASearchData) then
    raise Exception.Create('ASearchField et ASearchData doivent avoir le même nombre d''éléments');

  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select ' + AFieldID + ' from ' + ATableName);
    SQL.Add('  join K on K_ID = ' + AFieldID + ' and K_Enabled = 1');
    SQL.Add(' Where ');

    for i := Low(ASearchField) to High(ASearchField) do
    begin
      SQL.Add(ASearchField[i] + ' = ' + IntToStr(ASearchData[i]));
      if i <> High(ASearchField) then
        SQL.Add(' and ');
    end;
    Open;

    if RecordCount > 0 then
      Result := FieldByName(AFieldID).AsInteger;
  end;
end;

function TMainClass.GetIDFromTable(ATableName, ASearchField: String;
  ASearchData: Integer; AFieldID: String): Integer;
begin
  Result := -1;
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select ' + AFieldID + ' from ' + ATableName);
    SQL.Add('  join K on K_ID = ' + AFieldID + ' and K_Enabled = 1');
    SQL.Add('Where ' + ASearchField + ' = ' + IntToStr(ASearchData));
    Open;

    if RecordCount > 0 then
      Result := FieldByName(AFieldID).AsInteger;
  end;

end;

function TMainClass.GetIDFromTable(ATableName, ASearchField, ASearchData,
  AFieldID: String): Integer;
begin
  Result := -1;
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select ' + AFieldID + ' from ' + ATableName);
    SQL.Add('  join K on K_ID = ' + AFieldID + ' and K_Enabled = 1');
    SQL.Add('Where ' + ASearchField + ' = ' + QuotedStr(ASearchData));
    Open;

    if RecordCount > 0 then
      Result := FieldByName(AFieldID).AsInteger;
  end;

end;

// Converti les dates des fichiers en TDate
function TMainClass.ConvertDate(ADate : String): TDate;
var
  FormatDate: TFormatSettings;
begin
  try
    if Pos('/', ADate) = 0 then
    begin
      Result := EncodeDate(
        StrToInt(Copy(ADate, 1, 4)),
        StrToInt(Copy(ADate, 5, 2)),
        StrToInt(Copy(ADate, 7, 2)));
    end
    else begin
      // Charge le format de date français
      // -> http://msdn.microsoft.com/library/bb964664
      GetLocaleFormatSettings($040C, FormatDate);
      FormatDate.ShortDateFormat := 'dd/MM/yyyy';
      Result := StrToDate(ADate, FormatDate);
    end;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

// Converti un nombre en réel
function TMainClass.ConvertFloat(ANombre : String): Double;
var
  FormatNombre: TFormatSettings;
begin
  try
    GetLocaleFormatSettings($040C, FormatNombre);

    // Si c'est un nombre avec une virgule
    if Pos(',', ANombre) > 0 then
      FormatNombre.DecimalSeparator := ','             
    else // Sinon : pour les nombres avec un point
      FormatNombre.DecimalSeparator := '.';
    
    Result := StrToFloat(ANombre, FormatNombre);
  except 
    on E: Exception do  
      raise Exception.Create(E.Message);
  end;
end;

function TMainClass.Count: Integer;
begin
  Result := FCount;
end;

procedure TMainClass.Import;
begin
  raise Exception.Create('Doit être dérivé pour fonctionner');
 // Ne pas effacer
end;

procedure TMainClass.IncError(AInc: Integer = 1);
begin
  try
    FErrorTotal := FErrorTotal + AInc ;
    FErrorCount := FErrorCount + AInc ;
    if FErrorCount < 0
      then FErrorCount := 0 ;
    if FErrorTotal < 0
      then FErrorTotal := 0 ;

    if Assigned(FLabelError) then
    begin
        if FErrorCount > 0 then
        begin
          if FErrorCount = 1
            then FLabelError.Caption := '1 Erreur'
            else FLabelError.Caption := IntToStr(FErrorCount) + ' Erreurs' ;

          if Assigned(FProgressBar) then
            FProgressBar.State := pbsError ;

        end else begin
          FLabelError.Caption := '' ;
          if Assigned(FProgressBar) then
            FProgressBar.State := pbsNormal ;
        end;
    end;
  except
  end ;

  Application.ProcessMessages ;
end;

procedure TMainClass.LabCaption(AText: String);
begin
  try
    FErrorCount := 0 ;                  // Reset Partial error count
    IncError(0) ;

    if FLabel <> nil then
      FLabel.Caption := AText;
  except
  end;
  Application.ProcessMessages;
end;

procedure TMainClass.Next;
begin
  Fcds.Next;
end;

procedure TMainClass.Post;
begin
  try
    FCds.Post;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  end;
end;

procedure TMainClass.SetGenParam(APRM_TYPE, APRM_CODE, APRM_INTEGER : Integer;
  APRM_FLOAT: Double; APRM_MAGID: Integer);
var
  PRM_ID : Integer;
begin
  PRM_ID := GetIDFromTable('GENPARAM',['PRM_TYPE','PRM_CODE','PRM_MAGID'],[APRM_TYPE,APRM_CODE,APRM_MAGID],'PRM_ID');

  if PRM_ID = -1 then
    raise Exception.Create(Format(' - GENPARAM inexistant veuillez configurer la base - Type/Code/Mag : %d %d %d',[APRM_TYPE,APRM_CODE,APRM_MAGID]));

  With FIboQuery do
  Try
    IB_Transaction.StartTransaction;
    Close;
    SQL.Clear;
    SQL.Add('UPDATE GENPARAM SET');
    SQL.Add('  PRM_INTEGER = :PINT,');
    SQL.Add('  PRM_FLOAT   = :PFLT');
    SQL.Add('Where PRM_ID = :PPRMID');
    ParamCheck := True;
    ParamByName('PINT').AsInteger := APRM_INTEGER;
    ParamByName('PFLT').AsFloat   := APRM_FLOAT;
    ParamByName('PPRMID').AsInteger := PRM_ID;
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PPRMID, 0)');
    ParamCheck := True;
    ParamByName('PPRMID').AsInteger := PRM_ID;
    ExecSQL;

    IB_Transaction.Commit;

  Except on E:Exception do
    begin
      IB_Transaction.Rollback;
      raise Exception.Create('SetGenParam -> ' + E.Message);
    end;
  end;

end;

procedure TMainClass.SetGenParam(APRM_TYPE, APRM_CODE, APRM_INTEGER,
  APRM_MAGID: Integer);
var
  PRM_ID : Integer;
begin

  PRM_ID := GetIDFromTable('GENPARAM',['PRM_TYPE','PRM_CODE','PRM_MAGID'],[APRM_TYPE,APRM_CODE,APRM_MAGID],'PRM_ID');

  if PRM_ID = -1 then
    raise Exception.Create(Format(' - GENPARAM inexistant veuillez configurer la base - Type/Code/Mag : %d %d %d',[APRM_TYPE,APRM_CODE,APRM_MAGID]));

  With FIboQuery do
  Try
    IB_Transaction.StartTransaction;
    Close;
    SQL.Clear;
    SQL.Add('UPDATE GENPARAM SET');
    SQL.Add('  PRM_INTEGER = :PINT');
    SQL.Add('Where PRM_ID = :PPRMID');
    ParamCheck := True;
    ParamByName('PINT').AsInteger := APRM_INTEGER;
    ParamByName('PPRMID').AsInteger := PRM_ID;
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PPRMID, 0)');
    ParamCheck := True;
    ParamByName('PPRMID').AsInteger := PRM_ID;
    ExecSQL;

    IB_Transaction.Commit;

  Except on E:Exception do
    begin
      IB_Transaction.Rollback;
      raise Exception.Create('SetGenParam -> ' + E.Message);
    end;
  end;
end;

end.
