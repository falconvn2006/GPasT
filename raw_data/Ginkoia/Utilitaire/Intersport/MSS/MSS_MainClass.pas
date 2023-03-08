unit MSS_MainClass;

interface

uses DBClient, MidasLib, Db, Classes, ZipMstr19, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, Windows, uSevenZip;

type

  TARTFUSION = record
    ART_ID,
    TGF_ID,
    COU_ID ,
    ART_FUSARTID : Integer;
    ART_CODE : String;
  end;

  TFieldCFG = record
    FieldName : String;
    FieldType : TFieldType;
  end;
  TProcess = function : Integer;

  TArrayFieldCFG = Array of TFieldCFG;

  TMainClass = Class(TObject)
  private
    FISUPDATED: Boolean;
    FIsCreated: Boolean;
    FIsOnError: Boolean;
    FTVTID: Integer;
    FFileDate: TDate;
    FCanUpdateGenParam: Boolean;

    function GetFieldByName(sFieldName: String): TField;
    procedure SetFieldByName(sFieldName: String; const Value: TField);
  protected
    FCds         : TClientDataset;
    FFieldNameID : String; // champs lié ginkoia pour le ClearIdField
    FTitle       : String;
    FPath        : String;
    FLogs,
    FActionLogs  : TStringList;
    FFile        : String;
    FIboQuery    : TIboQuery;
    FStpQuery    : TIBOStoredProc;
    FPRMCODE     : Integer;
    FPRMTYPE     : Integer;
    FKTBID       : Integer;
    FErrLogs     : TStringList;
    FProgressBar : TProgressBar;
    FInsertCount,
    FMajCount    : Integer;
    FMAGID       : integer;
    FCODEMAG     : String;

    FAutoCommit : Boolean;
  public

    // fonction sur les K_ID
    function GetNewKID (ATableName : String) : Integer;
    function UpdateKId (AK_ID : Integer; ASupprime : integer = 0) : Boolean;
    // Vérifie si IMP_REFSTR ou IMP_REF existe et retourne le IMP_GINKOIA
    function IsInGenImport(IMP_NUM : Integer;IMP_REFSTR : String) : Integer;overload;
    function IsInGenImport(IMP_NUM : Integer;IMP_REF : Integer) : Integer;overload;
    // Permet de créer une nouvelle entrée dans ginkoia
    function SetGenImport(IMP_GINKOIA, IMP_NUM, IMP_REF : Integer) : Integer;overload;
    function SetGenImport(IMP_GINKOIA, IMP_NUM : Integer; IMP_REFSTR : String) : Integer;overload;
    // permet de récupérer l'id d'un pays
    function GetPaysId(APayName : String) : Integer;
    // Permet de récupérer l'id d'une ville
    function GetVilleId(AVille, ACP : String;APayId : Integer) : Integer;
    // Permet de créer une adresse
    function GetAdrId(AVILID : integer;ADR_LIGNE, ADR_TEL, ADR_FAX, ADR_GSM, ADR_EMAIL : String) : Integer;
    // Permet de récupérer un ID (AFieldID) depuis une valeur (ASearchData) depuis un champs 'ASearchField)
    // dans une table (ATableName)
    function GetIDFromTable(ATableName, ASearchField, ASearchData, AFieldID : String) : Integer;overload;
    function GetIDFromTable(ATableName, ASearchField : String; ASearchData : Integer; AFieldID : String) : Integer;overload;

    constructor Create;virtual;
    destructor Destroy;override;

    // importe les données dans le cliendataset (Voir chaque enfant pour le code)
    procedure Import;virtual;
    // Permet de dézipper le fichier FPath + FFile
    function UnZipFile : Boolean;
    // Permet de créer les champs du FCDS
    function CreateField(AFieldArray : array of TFieldCFG) : Boolean;
    // Permet de mettre à zero les Id (Voir chaque enfant pour le code Sinon FFieldanameID sera remis à 0)
    function ClearIdField : Boolean;virtual;
    // Permet de vérifier si ftile est bien à jour dans la base en cours
    function CheckFileMaj : Boolean;
    // Permet de transferer les données dans la base de données (Voir chaque enfant pour code)
    function DoMajTable(ADoMaj : Boolean) : Boolean;virtual;
    // Met à jour GenParam
    function UpdateGenParam : Boolean;
    // procedure qui permet de récupérer les paramètres dans GenParam
    procedure GetGenParam(APRM_TYPE, APRM_CODE : Integer; var PRM_INTEGER : Integer;bZeroInError : Boolean = True);overload;
    procedure GetGenParam(APRM_TYPE, APRM_CODE, APRM_MAGID : Integer;var PRM_INTEGER : Integer;bZeroInError : Boolean = True);overload;
    // fonction qui permet récupérer les condition de vente(Retourne le TYP_ID)
    function GetGenTypCDV(ATYP_CATEG, ATYP_COD : Integer) : Integer;

    // Permet de créer un domaine
    function SetDomaine(AACT_NOM, AACT_CODE : String; ACentraleCode, AACT_MODIFIABLE : Integer) : Integer;

    // fonction permettant de récupérer les information d'un fusionné
    Function GetFusionArt(AARTID, ATGFID, ACOUID : Integer) : TARTFUSION;

    procedure DesarchiveArticle(AART_ID : Integer);

    // Vérifie que la date du fichier est supérieure à la date du jour - ANbJourEcart
    function CheckFileDate(ANbJourEcart : Integer = 7) : Boolean;
  published
    function FieldByName(sFieldName : String) : TField;
    procedure Next;
    function EOF : Boolean;
    procedure First;
    procedure Append;
    procedure Post;

    property Title : String                 read FTitle       write FTitle;
    property Filename : String              read FFile        write FFile;
    property FileDate : TDate               read FFileDate;
    property Path  : String                 read FPath        write FPath;
    property ClientDataSet : TClientDataSet read FCds;
    property IboQuery : TIboQuery           read FIboQuery    write FIboQuery;
    property StpQuery : TIBOStoredProc      read FStpQuery    write FStpQuery;
    property PRM_CODE : Integer             read FPRMCODE     write FPRMCODE;
    property PRM_TYPE : Integer             read FPRMTYPE     write FPRMTYPE;
    property KTB_ID   : Integer             read FKTBID       write FKTBID;
    property ErrLogs  : TStringList         read FErrLogs;
    property ActionLogs  : TStringList      read FActionLogs;
    property ProgressBar : TProgressBar     read FProgressBar write FProgressBar;
    property Insertcount : integer          read FInsertCount;
    property Majcount    : integer          read FMajCount;
    property FieldNameID : String           read FFieldNameID write FFieldNameID;

    property MAG_ID : integer               read FMAGID       write FMAGID;
    property TVT_ID : Integer               read FTVTID       write FTVTID;

    property CodeMag : String               read FCODEMAG;

    // Propriete permettant de connaitre le status d'un enfant
    property IsCreated : Boolean            read FIsCreated write FIsCreated;
    property IsUpdated : Boolean            read FISUPDATED write FISUPDATED;
    property IsOnError : Boolean            read FIsOnError write FIsOnError;

    // Permet d'indiquer que le composant gère lui même ses transactions
    property AutoCommit : Boolean read FAutoCommit write FAutoCommit;
    // Permet d'indiquer que l'on peut mettre à jour genparam
    property CanUpdateGenParam : Boolean read FCanUpdateGenParam write FCanUpdateGenParam;
  End;

function XmlStrToFloat(Value: OleVariant): Extended;
function XmlStrToDate(Value: OleVariant): TDateTime;
function XmlStrToInt(Value: OleVariant; DefaultInt : Integer = 0): Integer;
function XmlStrToStr(Value: OleVariant): string;

implementation

uses MSS_Type;


function XmlStrToFloat(Value: OleVariant): Extended;
var
  TpS: string;
begin
  try
    if VarIsNull(Value) or VarIsType(Value,varUnknown) then
    begin
      Result := 0;
      Exit;
    end;

    //test si les bons caractères sont mis au bon endroit
    //mechant mais, ils n'ont qu'à prendre ATIPIC
    TpS:=XmlStrToStr(Value);
    if Pos(',',TpS)>0 then  //il ne faut pas de virgule !
    begin
      raise Exception.Create(TpS + ' ne doit pas avoir de , comme séparateur décimal');
    end;
    if Pos('.',TpS) > 0 then
      TpS[Pos('.',TpS)] := DecimalSeparator;
    if not TryStrToFloat(TpS,Result) then
      raise Exception.Create(Format('XmlStrToFloat -> La valeur %s n''est pas une valeur numérique correcte',[Value]));

//    Result := StrToFloat(TpS);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function XmlStrToDate(Value: OleVariant): TDateTime;
var
  d, m, y : Word;
  TpS: string;
begin
  Result := 0.0;
  if not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
  Try
    y := StrToIntDef(Copy(Value, 1, 4), 1899);
    m := StrToIntDef(Copy(Value, 5, 2), 1);
    d := StrToIntDef(Copy(Value, 7, 2), 1);
    Result := EncodeDate(y, m, d);
  except on E:Exception do
    raise Exception.Create('XmlStrToDate -> ' + E.Message);
  end;
end;

function XmlStrToInt(Value: OleVariant; DefaultInt : Integer): Integer;
begin
  Try
    if Not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
      Result := StrToIntDef(Trim(Value),DefaultInt)
    else
      Result := DefaultInt;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  End;
end;

function XmlStrToStr(Value: OleVariant): string;
begin
  if not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
    Result := Trim(Value)
  else
    Result := '';
end;


{ TMainClass }

procedure TMainClass.Append;
begin
  FCds.Append;
end;

function TMainClass.CheckFileDate(ANbJourEcart: Integer): Boolean;
var
  iPosStart, iPosEnd : Integer;
  sTmp : String;
  dDate : TDate;
begin
  iPosStart := Pos('_v', LowerCase(FFile));
  iPosEnd := Pos('.zip',lowercase(FFile));

   sTmp := Copy(FFile,iPosStart + 2, iPosEnd - (iPosStart + 2));

   dDate := XmlStrToDate(sTmp);
   FFileDate := dDate;

   Result := IncDay(Now, -ANbJourEcart) < dDate;
end;

function TMainClass.CheckFileMaj: Boolean;
begin
  if Not Assigned(FIboQuery) then
    raise Exception.Create('CheckFileMaj -> IboQuery non assigné !');
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_STRING from GENPARAM');
    SQL.Add(' join K on K_Id = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add(' and PRM_CODE = :PPRMCODE');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := FPRMTYPE;
    ParamByName('PPRMCODE').AsInteger := FPRMCODE;
    Open;

    if RecordCount > 0 then
      Result := (FieldByName('PRM_STRING').AsString <> FFile)
    else
      raise Exception.Create('CheckFileMaj -> Paramètre inexistant (' + IntToStr(FPRMTYPE) + '/' + IntToStr(FPRMCODE) + ')');
  end;
end;

function TMainClass.ClearIdField: Boolean;
begin
  Result := False;
  try
    if FCds.Active and (FCds.RecordCount > 0) then
    begin
      Fcds.First;
      while not Fcds.Eof do
      begin
        if FCds.FieldByName(FFieldNameID).AsInteger <> -1 then
        begin
          FCds.Edit;
          FCds.FieldByName(FFieldNameID).AsInteger := -1;
          Fcds.Post;
        end;
        FCds.Next;
      end;
    end;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('ClearIdField ' + FTitle + ' -> ' + E.Message);
  end;
end;

constructor TMainClass.Create;
begin
  inherited Create;

  FCds := TClientDataSet.Create(nil);
  FErrLogs := TStringList.Create;
  FActionLogs := TStringList.Create;
  FISUPDATED := False;
  FAutoCommit := True;
  FCanUpdateGenPAram := True;
end;

function TMainClass.CreateField(AFieldArray : array of TFieldCFG): Boolean;
var
  i : integer;
begin
  Result := False;
  try
    FCds.FieldDefs.Clear;
    for i := Low(AFieldArray) to High(AFieldArray) do
    begin
      case AFieldArray[i].FieldType of
        ftString: FCDs.FieldDefs.Add(AFieldArray[i].FieldName,ftString,64);
        else begin
          FCDs.FieldDefs.Add(AFieldArray[i].FieldName,AFieldArray[i].FieldType);
        end;
      end; // case
    end; // for
    FCds.CreateDataSet;
    FCds.LogChanges := False;
    FCds.Active := True;

    Result := True;
  Except on E:Exception do
    raise Exception.Create('CreateField -> ' + E.Message);
  end;
end;

procedure TMainClass.DesarchiveArticle(AART_ID: Integer);
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_SETDESARCHIVE(:PARTID)');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AART_ID;
    Open;

    Inc(FMajCount,FieldByName('FMAJ').AsInteger);
  except on E:Exception do
    raise Exception.Create('DesarchiveArticle -> ' + E.Message);
  end;
end;

destructor TMainClass.Destroy;
begin
  FIboQuery := nil;
  FStpQuery := Nil;

  if FCds <> nil then
  begin
    FCds.Close;
    FCDS.FieldDefs.Clear;
    FCds.IndexDefs.Clear;
  end;
  FCDs.Free;
  FErrLogs.Free;
  FActionLogs.Free;
  inherited;
end;

function TMainClass.DoMajTable(ADoMaj : Boolean): Boolean;
begin
  if FCds.Active then
    Fcds.First;
  FErrLogs.Clear;
  FActionLogs.Clear;
  if Assigned(FProgressBar) then
    FProgressBar.Position := 0;
  FInsertCount := 0;
  FMajCount    := 0;
  FISUPDATED := True;
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

function TMainClass.GetAdrId(AVILID: Integer; ADR_LIGNE, ADR_TEL, ADR_FAX,
  ADR_GSM, ADR_EMAIL: String): Integer;
var
  ADR_ID : Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select ADR_ID from GENADRESSE');
    SQL.Add('  join K on K_ID = ADR_ID and K_Enabled = 1');
    SQL.Add('Where ADR_VILID = :PVILID');
    SQL.Add('  and Upper(ADR_LIGNE) = :PADRLIGNE');
    ParamCheck := True;
    ParamByName('PVILID').AsInteger := AVILID;
    ParamByName('PADRLIGNE').AsString := UpperCase(ADR_LIGNE);
    Open;

    if RecordCount <= 0 then
    begin
      ADR_ID := GetNewKID('GENADRESSE');

      Close;
      SQL.Clear;
      SQL.Add('Insert into GENADRESSE (ADR_ID, ADR_LIGNE, ADR_VILID, ADR_TEL, ADR_FAX, ADR_GSM, ADR_EMAIL)');
      SQL.Add('Values(:PADRID,:PADRLIGNE,:PVILID,:PADRTEL,:PADRFAX,:PADRGSM,:PADREMAIL)');
      ParamCheck := True;
      ParamByName('PADRID').AsInteger := ADR_ID;
      ParamByName('PADRLIGNE').AsString := ADR_LIGNE;
      ParamByName('PVILID').AsInteger := AVILID;
      ParamByName('PADRTEL').AsString := ADR_TEL;
      ParamByName('PADRFAX').AsString := ADR_FAX;
      ParamByName('PADRGSM').AsString := ADR_GSM;
      ParamByName('PADREMAIL').AsString := ADR_EMAIL;
      ExecSQL;
    end
    else
      ADR_ID := FieldByName('ADR_ID').AsInteger;
    Result := ADR_Id;
  Except on E:Exception do
    raise Exception.Create('GetAdrId -> ' + E.Message);
  end;
end;

function TMainClass.GetFieldByName(sFieldName: String): TField;
begin
  Try
    Result :=  Fcds.FieldByName(sFieldName)
  Except on E:Exception do
    raise Exception.Create(E.Message);
  End;
end;

function TMainClass.GetFusionArt(AARTID, ATGFID, ACOUID: Integer): TARTFUSION;
begin
   Result.ART_ID := -1;
   Result.TGF_ID := -1;
   Result.COU_ID := -1;
   Result.ART_CODE := '';
   Result.ART_FUSARTID := -1;

    With FIboQuery do
    begin
      while Result.ART_FUSARTID <> 0 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select AFL_NEWARTID, AFL_NEWTGFID, AFL_NEWCOUID, ART_FUSARTID, ART_CODE From ARTFUSIONLIGNE');
        SQL.Add('  Join K on K_ID = AFL_ID and K_Enabled = 1');
        SQL.Add('  Join ARTARTICLE on ART_ID = AFL_NEWARTID');
        SQL.Add('Where AFL_OLDARTID = :PARTID');
        SQL.add('  and AFL_OLDTGFID = :PTGFID');
        SQL.Add('  and AFL_OLDCOUID = :PCOUID');
        ParamCheck := True;
        ParamByName('PARTID').AsInteger := AARTID;
        ParamByName('PTGFID').AsInteger := ATGFID;
        ParamByName('PCOUID').AsInteger := ACOUID;
        Open;

        Result.ART_ID := FieldByName('AFL_NEWARTID').AsInteger;
        Result.TGF_ID := FieldByName('AFL_NEWTGFID').AsInteger;
        Result.COU_ID := FieldByName('AFL_NEWCOUID').AsInteger;
        Result.ART_CODE := FieldByName('ART_CODE').AsString;
        Result.ART_FUSARTID := FieldByName('ART_FUSARTID').AsInteger;
        AARTID := FieldByName('AFL_NEWARTID').AsInteger;
        ATGFID := FieldByName('AFL_NEWTGFID').AsInteger;
        ACOUID := FieldByName('AFL_NEWCOUID').AsInteger;
      end; // while
    end; // With
end;

procedure TMainClass.GetGenParam(APRM_TYPE, APRM_CODE, APRM_MAGID: Integer;
  var PRM_INTEGER : Integer; bZeroInError: Boolean);
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

function TMainClass.GetGenTypCDV(ATYP_CATEG, ATYP_COD: Integer): Integer;
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select TYP_ID from GENTYPCDV');
    SQL.Add('  join K on K_ID = TYP_ID and K_Enabled = 1');
    SQL.Add('Where TYP_CATEG = :PTYPCATEG');
    SQL.Add('  and TYP_COD = :PTYPCOD');
    ParamCheck := True;
    ParamByName('PTYPCATEG').AsInteger := ATYP_CATEG;
    ParamByName('PTYPCOD').AsInteger := ATYP_COD;
    Open;

    Result := FieldByName('TYP_ID').AsInteger;
  end;
end;

procedure TMainClass.GetGenParam(APRM_TYPE, APRM_CODE: Integer;
  var PRM_INTEGER: Integer;bZeroInError : Boolean);
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

function TMainClass.GetNewKID(ATableName: String): Integer;
begin
  With FStpQuery do
  Try
    Close;
    StoredProcName := 'PR_NEWK';
//    SQL.Clear;
//    SQL.Add('Select ID From PR_NEWK(:PTABLENAME)');
    ParamCheck := True;
    ParamByName('TABLENAME').AsString := ATableName;
    Open;

    Result := FieldByName('ID').AsInteger;
    Close;
  Except on E:Exception do
    raise Exception.Create('GetNewKID -> ' + E.Message);
  End;
end;

function TMainClass.GetPaysId(APayName: String): Integer;
var
  PAY_ID : Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select PAY_ID from GENPAYS');
    SQL.Add('  join K on K_Id = PAY_ID and K_enabled = 1');
    SQL.Add('Where Upper(PAY_NOM) = :PPAYNOM');
    ParamCheck := True;
    ParamByName('PPAYNOM').AsString := UpperCase(APayName);
    Open;

    if RecordCount <= 0 then
    begin
      // N'existe pas donc création du pays
      PAY_ID := GetNewKID('GENPAYS');
      Close;
      SQL.Clear;
      SQL.Add('Insert into GENPAYS(PAY_ID, PAY_NOM)');
      SQL.Add('Values(:PPAYID,:PPAYNOM)');
      ParamCheck := True;
      ParamByName('PPAYID').AsInteger := PAY_ID;
      ParamByName('PPAYNOM').AsString := UpperCase(APayName);
      ExecSQL;
    end else
      PAY_ID := FieldByName('PAY_ID').AsInteger;
    Result := PAY_ID;
  Except on E:Exception do
    raise Exception.Create('GetPaysId - > ' + E.Message);
  end;
end;

function TMainClass.GetVilleId(AVille, ACP: String; APayId: Integer): Integer;
var
  VIL_ID : Integer;
begin
  Result := -1;
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GENVILLE');
    SQL.Add(' Join K on K_ID = VIL_ID and K_Enabled = 1');
    SQL.Add('Where Upper(VIL_NOM) = :PVLNOM');
    SQL.Add('  and Upper(VIL_CP) = :PVILCP');
    SQL.Add('  and VIL_PAYID  = :PPAYID');
    ParamCheck := True;
    ParamByName('PVLNOM').AsString := UpperCase(AVille);
    ParamByName('PVILCP').AsString := UpperCase(ACP);
    ParamByName('PPAYID').AsInteger := APayId;
    Open;

    if RecordCount <= 0 then
    begin
      VIL_ID := GetNewKID('GENVILLE');
      Close;
      SQL.Clear;
      SQL.Add('Insert into GENVILLE(VIL_ID,VIL_NOM, VIL_CP,VIL_PAYID)');
      SQL.Add('Values(:PVILID,:PVILNOM,:PVILCP,:PPAYID)');
      ParamCheck := True;
      ParamByName('PVILID').AsInteger := VIL_ID;
      ParamByName('PVILNOM').AsString := UpperCase(AVille);
      ParamByName('PVILCP').AsString  := ACP;
      ParamByName('PPAYID').AsInteger := APayId;
      ExecSQL;
    end
    else
      VIL_ID := FieldByName('VIL_ID').AsInteger;
    Result := VIL_ID;
  Except on E:Exception do
    raise Exception.Create('GetVilleId -> ' + E.Message);
  end;
end;

procedure TMainClass.Import;
begin
// Ne pas effacer
end;

function TMainClass.IsInGenImport(IMP_NUM : Integer;IMP_REF: Integer): Integer;
begin
  Result := -1;
  try
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select IMP_GINKOIA from GENIMPORT');
      SQL.Add('  join K on K_ID = IMP_ID and K_Enabled = 1');
      SQL.Add('Where Upper(IMP_REF) = :PIMPREF');
      SQL.Add('  and IMP_KTBID = :PKTBID');
      SQL.Add('  and IMP_NUM = :PIMPNUM');
      ParamCheck := True;
      ParamByName('PIMPREF').AsInteger := IMP_REF;
      ParamByName('PKTBID').AsInteger    := FKTBID;
      ParamByName('PIMPNUM').AsInteger := IMP_NUM;
      Open;
      if RecordCount > 1 then
        Result := FieldByName('IMP_GINKOIA').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('IsInGenImport -> ' + E.Message);
  End;
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

function TMainClass.SetGenImport(IMP_GINKOIA, IMP_NUM,
  IMP_REF: Integer): Integer;
var
  K_ID : Integer;
begin
  Result := -1;
  With FIboQuery do
  Try
    K_ID := GetNewKId('GENIMPORT');

    Close;
    SQL.Clear;
    SQL.add('Insert Into GENIMPORT(IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_NUM,IMP_REF,IMP_REFSTR)');
    SQL.Add('Values(:PIMPID,:PIMPKTBID,:PIMPGINKOIA,:PIMPNUM,:PIMPREF,'''')');
    ParamCheck := True;
    ParamByName('PIMPID').AsInteger := K_ID;
    ParamByName('PIMPKTBID').AsInteger := FKTBID;
    ParamByName('PIMPGINKOIA').AsInteger := IMP_GINKOIA;
    ParamByName('PIMPNUM').AsInteger := IMP_NUM;
    ParamByName('PIMPREF').AsInteger := IMP_REF;
    ExecSQL;
  Except on E:Exception do
    raise Exception.Create('SetGenImport -> ' + E.Message);
  End;
end;

function TMainClass.SetDomaine(AACT_NOM, AACT_CODE: String; ACentraleCode,
  AACT_MODIFIABLE: Integer): Integer;
var
  ACT_ID, CEN_ID : Integer;
begin
  With FIboQuery do
  begin
    // récupération de l'id centrale
    Close;
    SQL.Clear;
    SQL.Add('Select CEN_ID from GENCENTRALE');
    SQL.Add('  join K on K_ID = CEN_ID and K_Enabled = 1');
    SQL.Add('Where CEN_CODE = :CENCODE');
    ParamCheck := True;
    ParamByName('CENCODE').AsInteger := ACentraleCode;
    Open;
    if RecordCount > 0 then
      CEN_ID := FieldByName('CEN_ID').AsInteger
    else
      raise Exception.Create('SetDomaine -> Code centrale inéxistant');
  end;

  ACT_ID := GetNewKID('NKLACTIVITE');

  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert into NKLACTIVITE(ACT_ID, ACT_NOM, ACT_CENID, ACT_MODIFIABLE)');
    SQL.Add('Values(:PACTID, :PACTNOM, :PACTCENID , :PACTMOD)');
    ParamCheck := True;
    ParamByName('PACTID').AsInteger := ACT_ID;
    ParamByName('PACTNOM').AsString := AACT_NOM;
    ParamByName('AACT_CODE').AsString   := AACT_CODE;
    ParamByName('PACTCENID').AsInteger := CEN_ID;
    ParamByName('PACTMOD').AsInteger := AACT_MODIFIABLE;
    ExecSQL;

    Result := ACT_ID;
  end;
end;

procedure TMainClass.SetFieldByName(sFieldName: String; const Value: TField);
begin
  Try
    Fcds.FieldByName(sFieldName).Assign(Value);
  Except on E:Exception do
   raise Exception.Create(E.Message);
  End;
end;

function TMainClass.SetGenImport(IMP_GINKOIA, IMP_NUM: Integer;
  IMP_REFSTR: String): Integer;
var
  K_ID : Integer;
begin
  Result := -1;
  With FIboQuery do
  Try
    K_ID := GetNewKID('GENIMPORT');

    Close;
    SQL.Clear;
    SQL.add('Insert Into GENIMPORT(IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_NUM,IMP_REF,IMP_REFSTR)');
    SQL.Add('Values(:PIMPID,:PIMPKTBID,:PIMPGINKOIA,:PIMPNUM,0,:PIMPREFSTR)');
    ParamCheck := True;
    ParamByName('PIMPID').AsInteger := K_ID;
    ParamByName('PIMPKTBID').AsInteger := FKTBID;
    ParamByName('PIMPGINKOIA').AsInteger := IMP_GINKOIA;
    ParamByName('PIMPNUM').AsInteger := IMP_NUM;
    ParamByName('PIMPREFSTR').AsString := UpperCase(IMP_REFSTR);
    ExecSQL;
    Result := K_ID;
  Except on E:Exception do
    raise Exception.Create('SetGenImport -> ' + E.Message);
  End;
end;

function TMainClass.IsInGenImport(IMP_NUM : Integer;IMP_REFSTR: String): Integer;
begin
  // Copie des paramètres
  Result := -1;
  try
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select IMP_GINKOIA from GENIMPORT');
      SQL.Add('  join K on K_ID = IMP_ID and K_Enabled = 1');
      SQL.Add('Where Upper(IMP_REFSTR) = :PIMPREFSTR');
      SQL.Add('  and IMP_KTBID = :PKTBID');
      SQL.Add('  and IMP_NUM = :PIMPNUM');
      ParamCheck := True;
      ParamByName('PIMPREFSTR').AsString := IMP_REFSTR;
      ParamByName('PKTBID').AsInteger    := FKTBID;
      ParamByName('PIMPNUM').AsInteger   := IMP_NUM;
      Open;

      if RecordCount > 0 then
        Result := FieldByName('IMP_GINKOIA').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('IsInGenImport -> ' + E.Message);
  End;
end;

function TMainClass.UnZipFile: Boolean;
var
//  Zip : TZipMaster19;
  Arch : I7zInArchive;
begin
  Result := False;
  try
    if FileExists(FPath + FFile) then
    begin
//      Zip := TZipMaster19.Create(nil);
//      try
//        Zip.ExtrOptions := [ExtrOverWrite];
//        Zip.ExtrBaseDir := FPath;
//        Zip.ZipFileName := FPath + FFile;
//        Zip.FSpecArgs.Add('*.*');
//        Zip.DLL_Load := True;
//        Zip.Extract;
//        Result := True;
//      finally
//        Zip.Free;
//      end;
       Arch := CreateInArchive(CLSID_CFormatZip);
       Arch.OpenFile(FPath + FFile {+ '.ZIP'});
       Arch.ExtractTo(extractfilepath(FPath));
       Result := True;
    end;
  Except on E:Exception do
    begin
      bDoRestart := True;
      raise Exception.Create('UnZipFile -> ' + E.Message);
    end;
  end;
end;

function TMainClass.UpdateGenParam: Boolean;
var
  PRM_ID : Integer;
begin
  Result := False;

  if not FCanUpdateGenParam then
    Exit;

  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_ID, PRM_STRING from GENPARAM');
    SQL.Add('  join K on K_ID = PRM_ID and  K_Enabled = 1');
    SQL.Add('Where PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_TYPE = :PPRMTYPE');
    ParamCheck := True;
    ParamByName('PPRMCODE').AsInteger := FPRMCODE;
    ParamByName('PPRMTYPE').AsInteger := FPRMTYPE;
    Open;

    if RecordCount > 0 then
    begin
      PRM_ID := FieldByName('PRM_ID').AsInteger;

      if not FAutoCommit then
        FIboQuery.IB_Transaction.StartTransaction;
      Close;
      SQL.Clear;
      SQL.Add('Update GENPARAM set');
      SQL.Add('  PRM_STRING = :PPRMSTRING');
      SQL.ADd('Where PRM_ID = :PPRMID');
      ParamCheck := True;
      ParamByName('PPRMSTRING').AsString := FFile;
      ParamByName('PPRMID').AsInteger    := PRM_ID;
      ExecSQL;
      Result := True;
      if not FAutoCommit then
        FIboQuery.IB_Transaction.Commit;
    end;
  Except on E:Exception do
    begin
      if FIboQuery.IB_Transaction.InTransaction then
        FIboQuery.IB_Transaction.Rollback;
      raise Exception.Create('UpdateGenParam -> ' + E.Message);
    end;
  end;
end;

function TMainClass.UpdateKId(AK_ID: Integer; ASupprime : integer): Boolean;
begin
  Result := False;
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Execute procedure PR_UPDATEK(:PKID,:PSUPP)');
    ParamCheck := True;
    ParamByName('PKID').AsInteger := AK_ID;
    ParamByName('PSUPP').AsInteger := ASupprime;
    ExecSQL;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('UpdateKId -> ' + E.Message);
  End;
end;

end.
