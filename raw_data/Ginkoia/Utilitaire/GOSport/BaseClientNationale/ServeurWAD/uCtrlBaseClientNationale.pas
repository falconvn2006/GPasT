unit uCtrlBaseClientNationale;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, SysUtils, Classes, Contnrs, SqlExpr, ADODB, Variants, DB, dmdGinkoia, uMdlBaseClientNationale, IniFiles, uConst, StrUtils;

Const
  cFileCodeExtGOSPORT = '8';
  cFileCodeExtCOURIR = '7';

  cFileExtINS = 'INS';
  cFileExtFRE = 'FRE';
  cFileExtBR = 'BR';
  cFileExtPTQ = 'PTQ';

  cRepLog = 'Log\';
  cSufixeExtLog = '.Log';
  cRepBak = 'Archives\';
//
  cArrow = ' --> ';
//JB
  cFormatMessLog = '%s ' + cArrow + ' %s';
//  cFormatMessLog = '%s' + cRC + cArrow + '%s' + cRC;
  cFormatFileName = 'yyyymmddhhnnss';
  cExtBak = 'bak';

Type
  TTypeEnseigne = (teGOSPORT, teCOURIR, teNone);
  TTypeEnseignes = Set of TTypeEnseigne;

  TTypeExtFile = (tefINS, tefFRE, tefBR, tefPQT, tefNone);

  TCodeErrRec = record
  const
    Succeed = 0;
    Failed = 1;
    Warned = 2;
  end;

  TResultCode = record
    ACodeErr: Integer;
    AMessage: String;
    AFilename: TFileName;
    constructor Create(ACodeErr: Integer; AMessage: String;
      AFilename: TFileName); overload;
    constructor Create(ACodeErr: Integer; Format: String;
      Args: array of const; AFilename: TFileName); overload;
    function IsSucceed: Boolean; overload; inline;
    function IsFailed: Boolean; overload; inline;
    function IsWarned: Boolean; overload; inline;
    class function IsSucceed(ResultCode: TResultCode): Boolean; overload; static; inline;
    class function IsFailed(ResultCode: TResultCode): Boolean; overload; static; inline;
    class function IsWarned(ResultCode: TResultCode): Boolean; overload; static; inline;
    class function Succeed(const Message: String = ''): TResultCode; overload; static;
    class function Succeed(const Format: String; const Args: array of const): TResultCode; overload; static;
    class function SucceedWithFilename(const Filename: TFileName; const Message: String = ''): TResultCode; overload; static;
    class function SucceedWithFilename(const Filename: TFileName; const Format: String; const Args: array of const): TResultCode; overload; static;
    class function Failed(const Message: String = ''): TResultCode; overload; static;
    class function Failed(const Format: String; const Args: array of const): TResultCode; overload; static;
    class function FailedWithFilename(const Filename: TFileName; const Message: String = ''): TResultCode; overload; static;
    class function FailedWithFilename(const Filename: TFileName; const Format: String; const Args: array of const): TResultCode; overload; static;
    class function Warned(const Message: String): TResultCode; overload; static;
    class function Warned(const Format: String; const Args: array of const): TResultCode; overload; static;
    class function WarnedWithFilename(const Filename: TFileName; const Message: String): TResultCode; overload; static;
    class function WarnedWithFilename(const Filename: TFileName; const Format: String; const Args: array of const): TResultCode; overload; static;
  end;


  TBaseClientNationaleCtrl = Class
  protected
    function FormatLigne(NLine : Integer) : String;
    procedure ControleFormatFichierCLI(NLine : Integer; aLine : String; var aSLLog : TStringList; aSeparateur, aMessage : String);
    function FileNameToLog(Const AFileName: String): String;
    function FileNameToBak(const AFileName: String): String;
    function GetCliOldCardsByNUMCARTE(Const ACLI_NUMCARTE: String; var AResultCode: TResultCode): TCliOldCards;

    function GetListFieldBySection(Const ASection: String; var AResultCode: TResultCode): TStringList;
  public
    procedure CheckSecurity(Const ADateHeure, APassword: String; var AResultCode: TResultCode);

    function GetDateTimeGMT: String;

    function GetClient(Const ACLI_NUMCARTE: String; var AResultCode: TResultCode;
                       Const AGetCliOldCards: Boolean = True): TClient;

    function GetListInfoClient(Const ACLI_ENSID: integer;
                           Const ACLI_NUMCARTE, ACLI_NOM, ACLI_PRENOM, ACLI_CP, ACLI_VILLE: String;
                           Const ACLI_DTNAISS: TDate; var AResultCode: TResultCode): TObjectList;

    function GetNbPointsClient(Const APTS_ENSID: integer; const APTS_NUMCARTE: String;
                               var AResultCode: TResultCode): TPoints;

    function GetBonReducUtilise(Const ABRP_ENSID, ABRP_NUMTCK: integer; Const ABRP_NUMCARTE,
                                ABRP_MAG, ABRP_DATE, ABRP_CODEBON: String;
                                var AResultCode: TResultCode): TBonRepris;

    { Import/Export }
    procedure ImportClients(Const AFileName: String; var AResultCode: TResultCode);
    procedure ImportPoints(Const AFileName: String; var AResultCode: TResultCode);
    procedure ExportClients(Const AExtension: String; Const APathDest: String; var AResultCode: TResultCode);
    procedure ExportBonRepris(Const AExtension: String; Const APathDest: String; var AResultCode: TResultCode);

    function GetListLogExport(var AResultCode: TResultCode): TObjectList;

    { TTypeEnseigne }
    function FileNameToTypeEnseigne(Const AFileName: String; var AResultCode: TResultCode): TTypeEnseigne;
    function TypeEnseigneToValue(Const ATypeEnseigne: TTypeEnseigne): integer;
    function ValueToTypeEnseigne(Const AENSID: integer): TTypeEnseigne;

    { TTypeExtFile }
    function TypeExtFileToValue(Const ATypeExtFile: TTypeExtFile): String;
    function ValueToTypeExtFile(Const AExtFile: String): TTypeExtFile;
  End;

var
  GBaseClientNationaleCtrl: TBaseClientNationaleCtrl;

implementation

uses uTool, uVar, MD5Api, Math, uLog;

{ TBaseClientNationaleCtrl }

procedure TBaseClientNationaleCtrl.CheckSecurity(Const ADateHeure,
  APassword: String; var AResultCode: TResultCode);
var
  vIntervalValidity: integer;
  Buffer, vPassword: String;
  vSL1, vSL2: TStringList;
begin
  Log.Log('CheckSecurity', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    AResultCode := TResultCode.Succeed;

    vPassword:= EncryptDecryptChaine(GWSConfig.Options.Values['PASSWORDTRANS']);
    vIntervalValidity:= StrToInt(GWSConfig.Options.Values['INTERVALVALIDITY']);

    Buffer:= MD5(Entrelacement(ADateHeure, vPassword));

    if CompareStr(Buffer, APassword) <> 0 then
      begin
        AResultCode := TResultCode.Failed( rs_PW_KeyMISMATCH );
        Log.Log('CheckSecurity', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
        Exit;
      end;

    vSL1:= TStringList.Create;
    vSL2:= TStringList.Create;
    try
      vSL1.Text:= StringReplace(ADateHeure, 'T', #13#10, []);
      vSL2.Text:= StringReplace(GetDateTimeGMT, 'T', #13#10, []);

      if (vSL1.Strings[0] <> vSL2.Strings[0]) or
        (Abs(StrToTime(vSL1.Strings[1]) - StrToTime(vSL2.Strings[1])) > vIntervalValidity) then
        begin
          AResultCode := TResultCode.Failed( rs_PW_DateTimeOudated );
        end;

    finally
      FreeAndNil(vSL1);
      FreeAndNil(vSL2);
    end;
    Log.Log('CheckSecurity', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('CheckSecurity', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function TBaseClientNationaleCtrl.GetListFieldBySection(
  const ASection: String; var AResultCode: TResultCode): TStringList;
var
  i: integer;
  vIniFile: TIniFile;
  vSL: TStringList;
begin
  Result:= TStringList.Create;
  vIniFile:= TIniFile.Create(GWSConfig.FileNameIni);
  vSL:= TStringList.Create;
  try
    vIniFile.ReadSection(ASection, vSL);

    if vSL.Count = 0 then
      begin
        AResultCode := TResultCode.Failed( rs_MESS_StructureFiledNotFound );
      end;

    for i:= 0 to vSL.Count -1 do
      Result.Append(vIniFile.ReadString(ASection, vSL.Strings[i], ''));
  finally
    FreeAndNil(vIniFile);
    FreeAndNil(vSL);
  end;
end;

function TBaseClientNationaleCtrl.GetListInfoClient(const ACLI_ENSID: integer;
  const ACLI_NUMCARTE, ACLI_NOM, ACLI_PRENOM, ACLI_CP, ACLI_VILLE: String;
  const ACLI_DTNAISS: TDate; var AResultCode: TResultCode): TObjectList;
var
  vMaxRecResult: integer;
  vQry: TADOQuery;
  vClient: TClient;
  vCliOldCards: TCliOldCards;
  vParam: TParameter;
begin
  Log.Log('GetListInfoClient', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    vCliOldCards:= nil;
    Result:= nil;
    AResultCode := TResultCode.Succeed;
    try
      vMaxRecResult:= StrToInt(GWSConfig.Options.Values['MAXRECRESULT']);
      vQry:= dmGinkoia.GetNewQry;

      vQry.SQL.Append('SELECT * FROM CLIENTS');
      vQry.SQL.Append('LEFT OUTER JOIN POINTS ON (CLI_NUMCARTE=PTS_NUMCARTE)');
      vQry.SQL.Append('WHERE CLI_ENSID=:PCLI_ENSID');

      if ACLI_NUMCARTE <> '' then
        begin
          vQry.SQL.Append('AND CLI_NUMCARTE=:PCLI_NUMCARTE');
          vQry.Parameters.ParamByName('PCLI_NUMCARTE').Value:= ACLI_NUMCARTE;
        end
      else
       begin
         if ACLI_NOM <> '' then
           vQry.SQL .Append('AND CLI_NOM=:PCLI_NOM');

         if ACLI_PRENOM <> '' then
           vQry.SQL.Append('AND CLI_PRENOM=:PCLI_PRENOM');

         if ACLI_CP <> '' then
           vQry.SQL.Append('AND CLI_CP=:PCLI_CP');

         if ACLI_VILLE <> '' then
           vQry.SQL.Append('AND CLI_VILLE=:PCLI_VILLE');

         if ACLI_DTNAISS <> 0 then
           vQry.SQL.Append('AND CLI_DTNAISS=:PCLI_DTNAISS');


         vParam:= vQry.Parameters.FindParam('PCLI_NOM');
         if vParam <> nil then
           vParam.Value:= ACLI_NOM;

         vParam:= vQry.Parameters.FindParam('PCLI_PRENOM');
         if vParam <> nil then
           vParam.Value:= ACLI_PRENOM;

         vParam:= vQry.Parameters.FindParam('PCLI_CP');
         if vParam <> nil then
           vParam.Value:= ACLI_CP;

         vParam:= vQry.Parameters.FindParam('PCLI_VILLE');
         if vParam <> nil then
           vParam.Value:= ACLI_VILLE;

         vParam:= vQry.Parameters.FindParam('PCLI_DTNAISS');
         if vParam <> nil then
           vParam.Value:= DateToStr(ACLI_DTNAISS);
       end;

      vQry.Parameters.ParamByName('PCLI_ENSID').Value:= ACLI_ENSID;
      vQry.Open;
      if not vQry.Eof then
        begin
          Result:= TObjectList.Create(True);
          while not vQry.Eof do
            begin
              vClient:= TClient.Create;
              vClient.SetValuesByDataSet(vQry);
              Result.Add(vClient);
              Dec(vMaxRecResult);
              if vMaxRecResult = 0 then
                begin
                  AResultCode := TResultCode.Failed( rs_QryResult_OverTake );
                  Break;
                end;
              vQry.Next;
            end;
        end
      else
        begin
          if ACLI_NUMCARTE <> '' then
            begin
              vCliOldCards:= GetCliOldCardsByNUMCARTE(ACLI_NUMCARTE, AResultCode);
              if Assigned( vCliOldCards ) and AResultCode.IsSucceed then
                begin
                  AResultCode := TResultCode.Failed( rs_MESS_ClientDisabled, [ ACLI_NUMCARTE ] );
                end
              else
                begin
                  AResultCode := TResultCode.Failed( rs_QryResult_NotFound );
                end;
            end
          else
            begin
              AResultCode := TResultCode.Failed( rs_QryResult_NotFound );
            end;
        end;
    finally
      FreeAndNil(vQry);
      if vCliOldCards <> nil then
        FreeAndNil(vCliOldCards);
    end;
    Log.Log('GetListInfoClient', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      AResultCode := TResultCode.Failed('GetListInfoClient : ' + E.Message);
      Log.Log('GetListInfoClient', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function TBaseClientNationaleCtrl.GetListLogExport(
  var AResultCode: TResultCode): TObjectList;
var
  vQry: TADOQuery;
  vExportLog: TExportLog;
begin     
  Log.Log('GetListLogExport', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= nil;
    AResultCode := TResultCode.Succeed;

    vQry:= dmGinkoia.GetNewQry;
    try
      vQry.SQL.Text:= 'SELECT * FROM EXPORTS ORDER BY EXP_HEURE DESC';
      vQry.Open;

      if not vQry.Eof then
        begin
          Result:= TObjectList.Create(True);
          while not vQry.Eof do
            begin
              vExportLog:= TExportLog.Create;
              vExportLog.SetValuesByDataSet(vQry);

              Result.Add(vExportLog);
              vQry.Next;
            end;
        end
      else
        begin
          AResultCode := TResultCode.Failed( rs_QryResult_NODATA );
        end;
    finally
      FreeAndNil(vQry);
    end;
    Log.Log('GetListLogExport', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      AResultCode := TResultCode.Failed( 'GetListInfoClient : ' + E.Message );
      Log.Log('GetListLogExport', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function TBaseClientNationaleCtrl.GetNbPointsClient(const APTS_ENSID: integer;
  const APTS_NUMCARTE: String; var AResultCode: TResultCode): TPoints;
var
  vQry: TADOQuery;
  vCliOldCards: TCliOldCards;
begin
  Log.Log('GetNbPointsClient', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    vCliOldCards:= nil;
    Result:= TPoints.Create;
    Result.PTS_ENSID:= APTS_ENSID;
    Result.PTS_NUMCARTE:= APTS_NUMCARTE;

    AResultCode := TResultCode.Succeed;

    vQry:= dmGinkoia.GetNewQry;
    try
      vQry.SQL.Text:= 'SELECT * FROM POINTS WHERE PTS_ENSID=:PPTS_ENSID AND PTS_NUMCARTE=:PPTS_NUMCARTE';
      vQry.Parameters.ParamByName('PPTS_ENSID').Value:= APTS_ENSID;
      vQry.Parameters.ParamByName('PPTS_NUMCARTE').Value:= APTS_NUMCARTE;

      vQry.Open;

      if not vQry.Eof then
        Result.SetValuesByDataSet(vQry)
      else
        begin
          vCliOldCards:= GetCliOldCardsByNUMCARTE(APTS_NUMCARTE, AResultCode);
          if Assigned( vCliOldCards ) and AResultCode.IsSucceed then
            begin
              AResultCode := TResultCode.Failed( rs_MESS_ClientDisabled, [ APTS_NUMCARTE ] );
            end;
        end;
    finally
      FreeAndNil(vQry);
      if vCliOldCards <> nil then
        FreeAndNil(vCliOldCards);
    end;
    Log.Log('GetNbPointsClient', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      AResultCode := TResultCode.Failed( 'GetNbPointsClient : ' + E.Message );
      Log.Log('GetNbPointsClient', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

procedure TBaseClientNationaleCtrl.ImportClients(const AFileName: String;
  var AResultCode: TResultCode);
var
  i: integer;
  aString, Buffer, vNUMCARTE: String;
  vClient: TClient;
  vCliOldCards: TCliOldCards;
  vSLFile, vSLLine, vSLFields: TStringList;
  vSLLog: TStringList;
  vUk: TUpdateKind;
  vTypeEnseigne: TTypeEnseigne;
  vYear, vMonth, vDay: Word;
  vDate: TDateTime;
  vT1, vT2: TDateTime;
  NbErrors, NbAlertes: Integer;
  IsOK : Boolean;
  IndexDelete: Integer;
  isValid : Boolean;

  function StringListFind(const StringList: TStringList; const S: string;
    var Index: Integer): Boolean;
  begin
    Assert(Assigned(StringList));
    Index := StringList.IndexOf(S);
    Result := Index > -1;
  end;

begin
  Log.Log('ImportClients', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  NbErrors := 0;   NbAlertes := 0;
  try
    vUk:= ukModify;
    AResultCode := TResultCode.Succeed( AFileName );

    vT1:= Now;

    if not FileExists(AFileName) then
      begin
        AResultCode := TResultCode.FailedWithFilename( AFileName, rs_MESS_FileNotFound, [ AFileName ] );
        Log.Log('ImportClients', '', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
        Exit;
      end;


    vTypeEnseigne:= FileNameToTypeEnseigne(AFileName, AResultCode);
    if AResultCode.IsFailed then
    begin
      Log.Log('ImportClients', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    vSLFile:= TStringList.Create;
    vSLLine:= TStringList.Create;
    vSLLog:= TStringList.Create;
    try
      vSLFields:= GetListFieldBySection('I_CLIENTS', AResultCode);
      if vSLFields.Count = 0 then
      begin
        Log.Log('ImportClients', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
        Exit;
      end;

      {$REGION 'Gestion des champs GOSPORT/COURIR uniquement'}
      case vTypeEnseigne of
        teGOSPORT:
          begin
            // Suppression de la prise en charge du champs CLI_CSTTEL
            while StringListFind(vSLFields, 'CLI_CSTTEL', IndexDelete) do
              vSLFields.Delete(IndexDelete);

            // Suppression de la prise en charge du champs CLI_CSTMAIL
            while StringListFind(vSLFields, 'CLI_CSTMAIL', IndexDelete) do
              vSLFields.Delete(IndexDelete);

            // Suppression de la prise en charge du champs CLI_CSTCGV
            while StringListFind(vSLFields, 'CLI_CSTCGV', IndexDelete) do
              vSLFields.Delete(IndexDelete);
          end;
        teCOURIR:
          begin
            // Suppression de la prise en charge du champs CLI_TYPEFID
            while StringListFind(vSLFields, 'CLI_TYPEFID', IndexDelete) do
              vSLFields.Delete(IndexDelete);
          end;
        teNone:;
        else;
      end;
      {$ENDREGION}

      vSLFile.DefaultEncoding:= TEncoding.UTF8;
      // vSLFile.DefaultEncoding:= TEncoding.ASCII;
      vSLFile.LoadFromFile(AFileName);

      NbErrors := 0;
      NbAlertes := 0;

      for i:= 0 to vSLFile.Count -1 do
        begin
          IsOK := True;
          try
            try
  //JB
              if i = 0 then
              begin //Supprimer la première ligne si entête de colonne
                if copy(vSLFile.Strings[i],1,length('ANCIEN_CODE_CARTE')) = 'ANCIEN_CODE_CARTE' then
                  Continue;
              end;
  //
              vSLLine.Text:= StringReplace(vSLFile.Strings[i], GWSConfig.Options.Values['CSVSEP'], #13#10, [rfReplaceAll]);


              case vTypeEnseigne of
                teGOSPORT: begin
                  // il est possible qu'il y ait 1 champ de moins dans le fichier
                  IsValid := (vSLFields.Count = vSLLine.Count) or (vSLFields.Count - 1 = vSLLine.Count);
                end;
                teCOURIR, teNone: begin
                    IsValid := (vSLFields.Count = vSLLine.Count);
                end;
              end;

              if not IsValid then
                begin
  //JB
                  vSLLog.Append('Ligne' + FormatLigne(i+1) + ' : ' + rs_MESS_ImportNbFieldFailed);
                  vSLLog.Append(vSLFile.Strings[i]);
                  Inc(NbErrors);
  //
                  Continue;
                end;

              vNUMCARTE:= vSLLine.Strings[0];
              if vNUMCARTE = '' then
                vNUMCARTE:= vSLLine.Strings[1];

              vClient:= GetClient(vNUMCARTE, AResultCode, False);

              { Creation (ou Update si existe) }
              if (vSLLine.Strings[0] = '') and (vSLLine.Strings[1] <> '') then
              begin
                if vClient <> nil then
                  vUk := ukModify
                else
                begin
                  vUk := ukInsert;
                  vClient := TClient.Create;
                  vClient.CLI_ENSID := TypeEnseigneToValue(vTypeEnseigne);
                end;
              end
              { Modification / Renouvellement de carte }
              else if (vSLLine.Strings[0] <> '') and (vSLLine.Strings[1] <> '') then
  //                    ( (vSLLine.Strings[0] =  vSLLine.Strings[1]) or
  //                      (vSLLine.Strings[0] <> vSLLine.Strings[1]) ) then
              begin
                if vClient <> nil then
                  vUk:= ukModify
                else
                begin
                  vUk:= ukInsert;
                  vClient:= TClient.Create;
                  vClient.CLI_ENSID:= TypeEnseigneToValue(vTypeEnseigne);
                end;

                { Renouvellement de carte }
                if vSLLine.Strings[0] <> vSLLine.Strings[1] then
                  vCliOldCards := TCliOldCards.Create;
              end
              { Suppression }
              else if (vSLLine.Strings[0] <> '') and (vSLLine.Strings[1] = '') then
              begin
                vUk:= ukDelete;

                if vClient = nil then
                begin
  //JB
                  vSLLog.Append('Ligne' + FormatLigne(i+1) + ' : ' + rs_MESS_undeletable);
                  vSLLog.Append(vSLFile.Strings[i]);
                  Inc( NbAlertes );
  //
                  Continue;
                end;

                Buffer:= vSLLine.Strings[vSLFields.IndexOf('CLI_DTSUP')];
                if Buffer <> '' then
                  vClient.CLI_DTSUP:= StrToDateDef(Buffer,0);
              end;

              vClient.CLI_NUMCARTE:= vNUMCARTE;
              vClient.CLI_CODECLUB:= vSLLine.Strings[vSLFields.IndexOf('CLI_CODECLUB')];
              vClient.CLI_CIV:= vSLLine.Strings[vSLFields.IndexOf('CLI_CIV')];
              vClient.CLI_NOM:= vSLLine.Strings[vSLFields.IndexOf('CLI_NOM')];
              vClient.CLI_PRENOM:= vSLLine.Strings[vSLFields.IndexOf('CLI_PRENOM')];
              vClient.CLI_ADR1:= vSLLine.Strings[vSLFields.IndexOf('CLI_ADR1')];
              vClient.CLI_ADR2:= vSLLine.Strings[vSLFields.IndexOf('CLI_ADR2')];
              vClient.CLI_ADR3:= vSLLine.Strings[vSLFields.IndexOf('CLI_ADR3')];
              vClient.CLI_ADR4:= vSLLine.Strings[vSLFields.IndexOf('CLI_ADR4')];
              vClient.CLI_CP:= vSLLine.Strings[vSLFields.IndexOf('CLI_CP')];
              vClient.CLI_VILLE:= vSLLine.Strings[vSLFields.IndexOf('CLI_VILLE')];
              vClient.CLI_CODEPAYS:= vSLLine.Strings[vSLFields.IndexOf('CLI_CODEPAYS')];
              vClient.CLI_TEL1:= vSLLine.Strings[vSLFields.IndexOf('CLI_TEL1')];
              vClient.CLI_TEL2:= vSLLine.Strings[vSLFields.IndexOf('CLI_TEL2')];
              vClient.CLI_DTNAISS:= StrToDateDef(vSLLine.Strings[vSLFields.IndexOf('CLI_DTNAISS')],0);
              vClient.CLI_CODEPROF:= vSLLine.Strings[vSLFields.IndexOf('CLI_CODEPROF')];

              {$REGION 'CDC - GOSPORT - Fidélité Multi-cartes'}
              case vTypeEnseigne of
                teGOSPORT:
                  begin
                    vClient.CLI_TYPEFID := StrToIntDef(vSLLine.Strings[vSLFields.IndexOf('CLI_TYPEFID')], 0);
                    vClient.CLI_CSTTEL := ''; // default, valeur ignorée
                    vClient.CLI_CSTMAIL := ''; // default, valeur ignorée
                    vClient.CLI_CSTCGV := ''; // default, valeur ignorée
                  end;
                else
                  begin
                    vClient.CLI_TYPEFID := -1; // default, valeur ignorée
                    vClient.CLI_CSTTEL := vSLLine.Strings[vSLFields.IndexOf('CLI_CSTTEL')];
                    vClient.CLI_CSTMAIL := vSLLine.Strings[vSLFields.IndexOf('CLI_CSTMAIL')];
                    vClient.CLI_CSTCGV := vSLLine.Strings[vSLFields.IndexOf('CLI_CSTCGV')];
                  end;
              end;
              {$ENDREGION}

              Buffer:= vSLLine.Strings[vSLFields.IndexOf('CLI_AUTRESP')];
              if (Buffer <> '') and (Length(Buffer) > 20) then
              begin
  //JB
  //              ControleFormatFichierCLI(i+1,vSLFile.Strings[i],vSLLog,'|',' --> Fiche intégrée mais la valeur a été tronquée !');
                vSLLog.Append('Ligne' + FormatLigne(i+1) + ' CLI_AUTRESP    : Autre sport : Fiche intégrée mais la valeur "' + Buffer + '" a été tronquée.');
                Buffer:= Copy(Buffer, 1, 20);
                Inc(NbAlertes);
                IsOK := False;
  //
              end;
              vClient.CLI_AUTRESP:= Buffer;

              vClient.CLI_BLACKLIST:= vSLLine.Strings[vSLFields.IndexOf('CLI_BLACKLIST')];
              vClient.CLI_EMAIL:= vSLLine.Strings[vSLFields.IndexOf('CLI_EMAIL')];
              vClient.CLI_DTCREATION:= StrToDateDef(vSLLine.Strings[vSLFields.IndexOf('CLI_DTCREATION')],0);
              vClient.CLI_IDETO:= vSLLine.Strings[vSLFields.IndexOf('CLI_IDETO')];
              vClient.CLI_TOPSAL:= vSLLine.Strings[vSLFields.IndexOf('CLI_TOPSAL')];
              vClient.CLI_CODERFM:= vSLLine.Strings[vSLFields.IndexOf('CLI_CODERFM')];
              vClient.CLI_OPTIN:= vSLLine.Strings[vSLFields.IndexOf('CLI_OPTIN')];

              vClient.CLI_DTVAL:= StrToDateDef(vSLLine.Strings[vSLFields.IndexOf('CLI_DTVAL')]);
              vClient.CLI_OPTINPART:= '0';

              if vTypeEnseigne = teCOURIR then
              begin
                vClient.CLI_DTVAL:= StrToDateDef(vSLLine.Strings[vSLFields.IndexOf('CLI_DTVAL')],0);

                { Règle de gestion cf. CDC Chp: 4.6.2 }
                DecodeDate(vClient.CLI_DTVAL, vYear, vMonth, vDay);
                // vDate:= EncodeDate(vYear, vMonth -1, vDay);
  //JB
  //              vSLLog.Append(vClient.CLI_NOM + ' '+FormatDateTime('yyyy-mm-dd',vDate));
  //
                vDate:= EncodeDate(vYear, vMonth , vDay);
                IncMonth(vDate,-1);
                if vDate >= Trunc(Now) then
                  vClient.CLI_DTVAL:= vDate;

                vClient.CLI_OPTINPART:= vSLLine.Strings[vSLFields.IndexOf('CLI_OPTINPART')];
                vClient.CLI_TOPVIB:= vSLLine.Strings[vSLFields.IndexOf('CLI_TOPVIB')];
                vClient.CLI_REMRENOUV:= StrToInt(vSLLine.Strings[vSLFields.IndexOf('CLI_REMRENOUV')]);
              end;

              vClient.CLI_MAGORIG:= vSLLine.Strings[vSLFields.IndexOf('CLI_MAGORIG')];
              vClient.CLI_TOPNPAI:= vSLLine.Strings[vSLFields.IndexOf('CLI_TOPNPAI')];

              vClient.CLI_DTRENOUV:= StrToDateDef(vSLLine.Strings[vSLFields.IndexOf('CLI_DTRENOUV')],0);


              vClient.CLI_DESACTIVE := 0;
              if vTypeEnseigne = teGOSPORT then
              begin
                if (vSLFields.IndexOf('CLI_DESACTIVE') <> -1) and (vSLFields.Count = vSLLine.Count) then
                  vClient.CLI_DESACTIVE := StrToIntDef(vSLLine.Strings[vSLFields.IndexOf('CLI_DESACTIVE')], 0);
              end;

    //          vClient.N:= vSLLine.Strings[vSLFields.IndexOf('')]; //--> ???

              vClient.MAJ(vUk, true);

              if vCliOldCards <> nil then { Dans le cas d'un renouvellement de carte }
              begin
                { Historisation de l'ancienne carte }
                vCliOldCards.COC_CLIID:= vClient.CLI_ID;
                vCliOldCards.COC_NUMCARTE:= vClient.CLI_NUMCARTE;
                vCliOldCards.MAJ;
              end;
            except
              on E: Exception do
              begin
  //JB
  //              if (E.Message = 'Cette opération n''est pas autorisée si l''objet est fermé') or
  //                 (E.Message = 'La connexion est occupée avec les résultats d''une autre commande') or
  //                 (E.Message = 'Impossible de créer une nouvelle transaction en raison d''un dépassement de capacité') then
                Inc(NbErrors);
                ControleFormatFichierCLI(i+1,vSLFile.Strings[i],vSLLog,'|','');
                vSLLog.Append('Ligne' + FormatLigne(i+1) + ' : Exception --> ' + E.Message);
  //              AResultCode.ACodeErr := 1;
  //              AResultCode.AMessage := Format(rs_MESS_LAnalyseDuFichierComporteDesErreurs, [AFileName + ' ', NbErrors, NbAlertes]);
                //vSLLog.Append(Format(cFormatMessLog, [vSLFile.Strings[i], E.Message]));
                IsOK := False;
  //
              end;
            end;
          finally
            if vClient <> nil then
              FreeAndNil(vClient);
            if vCliOldCards <> nil then
              FreeAndNil(vCliOldCards);
          end;
  //JB
          if IsOK = False then
          begin
            vSLLog.Append(vSLFile.Strings[i]);
            vSLLog.Append('');
          end;
  //
        end;
  //JB
      Buffer := FileNameToBak(AFileName);
      RenameFile(AFileName, Buffer);
      //RenameFile(AFileName, AFileName + cExtBak);
  //

    finally
      FreeAndNil(vSLLine);
      FreeAndNil(vSLFile);
      FreeAndNil(vSLFields);

  //JB
  //    if vSLLog.Count <> 0 then
  //      begin
  //        vT2:= Now;
  //        vSLLog.Append(FormatDateTime('hh:nn:ss:zzz', vT1 - vT2));
  //        vSLLog.SaveToFile(FileNameToLog(AFileName));
  //      end;

      // S'il y a des erreurs|avertissements...
      if NbErrors + NbAlertes > 0 then
      begin
        // S'il y a des erreurs => Failed
        if NbErrors > 0 then
          AResultCode := TResultCode.FailedWithFilename( AFileName, rs_MESS_LAnalyseDuFichierComporteDesErreurs, [ AFileName + ' ', NbErrors, NbAlertes ] )
        else
          // S'il y a seulement des avertissements => Warning
          AResultCode := TResultCode.WarnedWithFilename( AFileName, rs_MESS_LAnalyseDuFichierComporteDesErreurs, [ AFileName + ' ', NbErrors, NbAlertes ] );

        vSLLog.Insert(0,Format(rs_MESS_LAnalyseDuFichierComporteDesErreurs, [AFileName + ' ', NbErrors, NbAlertes]));
        vSLLog.Insert(1,rs_MESS_DateTraitement + FormatDateTime('dd/mm/yyyy a hh:nn:ss',vT1));
        vSLLog.Insert(2,'');
        vT2:= Now;
        aString :=  FormatDateTime('hh:nn:ss:zzz', vT2 - vT1);
        vSLLog.Append(rs_MESS_TempsTraitement + copy(aString,1,2) + 'h' + copy(aString,4,2) + 'm' + copy(aString,7,2) + '.' + copy(aString,10,3) + ' s');
        vSLLog.SaveToFile(FileNameToLog(AFileName));
      end;
      FreeAndNil(vSLLog);
    end;
    Log.Log('ImportClients', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      AResultCode := TResultCode.Failed(E.Message);
      Log.Log('ImportClients', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

procedure TBaseClientNationaleCtrl.ImportPoints(const AFileName: String;
  var AResultCode: TResultCode);
var
  i, vENSID, NbErrors, NbAlertes: integer;
  vPoint: TPoints;
  vSLFile, vSLLine, vSLFields: TStringList;
  vSLLog: TStringList;
  vT1, vT2: TDateTime;
  vQry: TADOQuery;
  vUk: TUpdateKind;
  Buffer, aString: String;
  IsOK : Boolean;
begin
  Log.Log('ImportPoints', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  NbErrors := 0;   NbAlertes := 0;
  try
    AResultCode := TResultCode.SucceedWithFilename( AFileName );

    vT1:= Now;

    if not FileExists(AFileName) then
      begin
        AResultCode := TResultCode.SucceedWithFilename( AFileName, rs_MESS_FileNotFound, [ AFileName ] );
        Log.Log('ImportPoints', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
//      AResultCode.ACodeErr:= 0;
//      AResultCode.AMessage:= Format(rs_MESS_FileNotFound, [AFileName]);
        Exit;
      end;


    vSLLog:= TStringList.Create;
    vSLFile:= TStringList.Create;
    try
      vSLFields:= GetListFieldBySection('I_POINTS', AResultCode);
      if vSLFields.Count = 0 then
        begin
          Log.Log('ImportPoints', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      vENSID:= TypeEnseigneToValue(teGOSPORT);

      vQry:= dmGinkoia.GetNewQry;

      vQry.SQL.Append('SELECT CLI_ID, CLI_NUMCARTE, PTS_NUMCARTE FROM CLIENTS');
      vQry.SQL.Append('LEFT OUTER JOIN POINTS ON (CLI_NUMCARTE=PTS_NUMCARTE)');
      vQry.SQL.Append('WHERE CLI_ENSID=:PCLI_ENSID');
      vQry.SQL.Append('ORDER BY CLI_NUMCARTE');

      vQry.Parameters.ParamByName('PCLI_ENSID').Value:= vENSID;

      vQry.Open;

      vSLFile.DefaultEncoding:= TEncoding.UTF8;
      vSLFile.LoadFromFile(AFileName);

      NbErrors := 0;
      NbAlertes := 0;
      for i:= 0 to vSLFile.Count -1 do
        begin
          IsOK := True;
          vSLLine:= TStringList.Create;
          try
            vSLLine.Text:= StringReplace(vSLFile.Strings[i], GWSConfig.Options.Values['CSVSEP'], #13#10, [rfReplaceAll]);

            if vQry.Locate('CLI_NUMCARTE', vSLLine.Strings[0], []) then
              begin
                vUk:= ukModify;
                if vQry.Fields[2].IsNull then
                  vUk:= ukInsert;

                vPoint:= TPoints.Create;
                try
                  vPoint.PTS_ENSID:= vENSID;
                  vPoint.PTS_NUMCARTE:= vSLLine.Strings[vSLFields.IndexOf('PTS_NUMCARTE')];
                  vPoint.PTS_NBPOINTS:= StrToFloatExt(vSLLine.Strings[vSLFields.IndexOf('PTS_NBPOINTS')]);
                  vPoint.PTS_DATE:= StrToDateDef(vSLLine.Strings[vSLFields.IndexOf('PTS_DATE')],0);
                  vPoint.MAJ(vUk);
                finally
                  FreeAndNil(vPoint);
                end;
              end
            else
            begin
              vSLLog.Append('Ligne' + FormatLigne(i+1) + ' : ' + rs_MESS_ClientNotfound);
              Inc( NbAlertes );
              IsOK := False;
            end;

          except
            on E: Exception do
              begin
  //JB
  //              AResultCode.ACodeErr := 1;
  //              AResultCode.AMessage := Format(rs_MESS_LAnalyseDuFichierComporteDesErreurs, [AFileName + ' ', NbError, NbAlertes]);
                Inc(NbErrors);
                vSLLog.Append('Ligne' + FormatLigne(i+1) + ' : Exception --> ' + E.Message);
                IsOK := False;
  //              vSLLog.Append(Format(cFormatMessLog, [vSLFile.Strings[i], E.Message]));
              end;
          end;
  //JB
          if IsOK = False then
          begin
            vSLLog.Append(vSLFile.Strings[i]);
            vSLLog.Append('');
          end;
        end;

      Buffer := FileNameToBak(AFileName);
      RenameFile(AFileName, Buffer);
  //    RenameFile(AFileName, AFileName + cExtBak);

    finally
      FreeAndNil(vSLFile);
      FreeAndNil(vSLFields);
  //JB
      if (NbErrors <> 0) or (NbAlertes <> 0) then
      begin
        AResultCode := TResultCode.FailedWithFilename( AFileName, rs_MESS_LAnalyseDuFichierComporteDesErreurs, [ AFileName + ' ', NbErrors, NbAlertes ] );
        vSLLog.Insert(0,Format(rs_MESS_LAnalyseDuFichierComporteDesErreurs, [AFileName + ' ', NbErrors, NbAlertes]));
        vSLLog.Insert(1,rs_MESS_DateTraitement + FormatDateTime('dd/mm/yyyy a hh:nn:ss',vT1));
        vSLLog.Insert(2,'');
        vT2:= Now;
        aString :=  FormatDateTime('hh:nn:ss:zzz', vT2 - vT1);
        vSLLog.Append(rs_MESS_TempsTraitement + copy(aString,1,2) + 'h' + copy(aString,4,2) + 'm' + copy(aString,7,2) + '.' + copy(aString,10,3) + ' s');
        vSLLog.SaveToFile(FileNameToLog(AFileName));
      end;

  //    if vSLLog.Count <> 0 then
  //      begin
  //        vT2:= Now;
  //        vSLLog.Append(FormatDateTime('hh:nn:ss:zzz', vT1 - vT2));
  //        vSLLog.SaveToFile(FileNameToLog(AFileName));
  //      end;

      FreeAndNil(vSLLog);
      FreeAndNil(vQry);
    end;
    Log.Log('ImportPoints', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('ImportPoints', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function TBaseClientNationaleCtrl.TypeEnseigneToValue(
  const ATypeEnseigne: TTypeEnseigne): integer;
begin
  Result:= 0;
  case ATypeEnseigne of
    teGOSPORT: Result:= 1;
    teCOURIR: Result:= 2;
  end;
end;

function TBaseClientNationaleCtrl.TypeExtFileToValue(
  const ATypeExtFile: TTypeExtFile): String;
begin
  Result:= '';
  case ATypeExtFile of
    tefINS: Result:= cFileExtINS;
    tefFRE: Result:= cFileExtFRE;
    tefBR: Result:= cFileExtBR;
    tefPQT: Result:= cFileExtPTQ;
  end;
end;

function TBaseClientNationaleCtrl.ValueToTypeEnseigne(
  const AENSID: integer): TTypeEnseigne;
begin
  Result:= teNone;
  case AENSID of
    1: Result:= teGOSPORT;
    2: Result:= teCOURIR;
  end;
end;

function TBaseClientNationaleCtrl.ValueToTypeExtFile(
  const AExtFile: String): TTypeExtFile;
begin
  Result:= tefNone;
  if Pos(cFileExtINS, UpperCase(AExtFile)) <> 0 then
    Result:= tefINS
  else if Pos(cFileExtFRE, UpperCase(AExtFile)) <> 0 then
    Result:= tefFRE
  else if Pos(cFileExtBR, UpperCase(AExtFile)) <> 0 then
    Result:= tefBR
  else if Pos(cFileExtPTQ, UpperCase(AExtFile)) <> 0 then
    Result:= tefPQT;
end;

procedure TBaseClientNationaleCtrl.ExportBonRepris(const AExtension,
  APathDest: String; var AResultCode: TResultCode);
var
  i: integer;
  vFileName, vExt: String;
  vSLFile, vSLLine, vSLFields: TStringList;
  vQry: TADOQuery;
  vField: TField;
  vTypeEnseignes: TTypeEnseignes;
  vTypeEnseigne: TTypeEnseigne;
  vExportLog: TExportLog;
begin
  Log.Log('ExportBonRepris', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    inherited;
    vFileName:= '';
    AResultCode := TResultCode.Succeed;

    vSLFile:= TStringList.Create;
    vSLLine:= TStringList.Create;
    vExportLog:= TExportLog.Create;
    vQry:= dmGinkoia.GetNewQry;
    try
      vExt:= Copy(AExtension, 1, Length(AExtension)-1);
      vSLFields:= GetListFieldBySection('E_BONREPRIS_' + UpperCase(vExt), AResultCode);
      if vSLFields.Count = 0 then
      begin
        Log.Log('ExportBonRepris', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
        Exit;
      end;

      vTypeEnseignes:= [teGOSPORT, teCOURIR];

      for vTypeEnseigne in vTypeEnseignes do
        begin
          vSLFile.Clear;

          { --------------- Construction de la chaine du fichier --------------- }
          case vTypeEnseigne of
            teGOSPORT: vFileName:= ExcludeTrailingBackslash(APathDest) + '\' + FormatDateTime(cFormatFileName, Now) + '.' + vExt + cFileCodeExtGOSPORT;
            teCOURIR: vFileName:= ExcludeTrailingBackslash(APathDest) + '\' + FormatDateTime(cFormatFileName, Now) + '.' + vExt + cFileCodeExtCOURIR;
          end;

          { ----------------------- Construction Sql --------------------------- }
          vQry.SQL.Clear;
          vQry.SQL.Append('SELECT BP.* FROM BONREPRIS BP, CLIENTS CL');
          vQry.SQL.Append('WHERE CL.CLI_NUMCARTE=BP.BRP_NUMCARTE');
          vQry.SQL.Append('AND (BP.BRP_TRAITE = 0 OR BP.BRP_TRAITE IS NULL)');
          vQry.SQL.Append('AND CL.CLI_ENSID =:PCLI_ENSID');

          vQry.Parameters.ParamByName('PCLI_ENSID').Value:= TypeEnseigneToValue(vTypeEnseigne);
          vQry.Open;

          { ------------------ Chargement des données d'export ----------------- }
          while not vQry.Eof do
            begin
              vSLLine.Clear;
              for i:= 0 to vSLFields.Count -1 do
                begin
                  vField:= vQry.FindField(vSLFields.Strings[i]);
                  if vField <> nil then
                    vSLLine.Append(vField.AsString)
                  else
                    vSLLine.Append('');
                end;

              if vSLLine.Count <> 0 then
                vSLFile.Append(StringReplace(vSLLine.Text, #13#10, GWSConfig.Options.Values['CSVSEP'], [rfReplaceAll]));

              vQry.Next;
            end;

          if vSLFile.Count <> 0 then
            begin
              { ------------------- Enregistrement du fichier ------------------ }
              vSLFile.SaveToFile(vFileName);

              { -------------------- Maj de base de données -------------------- }
              vQry.SQL.Clear;
              vQry.SQL.Append('UPDATE BONREPRIS SET BRP_TRAITE = 1 WHERE BRP_ID in (');
              vQry.SQL.Append('SELECT BP.BRP_ID FROM BONREPRIS BP, CLIENTS CL');
              vQry.SQL.Append('WHERE CL.CLI_NUMCARTE=BP.BRP_NUMCARTE');
              vQry.SQL.Append('AND BP.BRP_TRAITE = 0');
              vQry.SQL.Append('AND CL.CLI_ENSID =:PCLI_ENSID)');

              vQry.Parameters.ParamByName('PCLI_ENSID').Value:= TypeEnseigneToValue(vTypeEnseigne);
              vQry.ExecSQL;

              { ------------------ Journalisation de l'export ------------------ }
              vExportLog.EXP_HEURE:= Now;
              vExportLog.EXP_FICHIER:= ExtractFileName(vFileName);
              vExportLog.EXP_DATELASTEXPORT:= Trunc(Now);
              vExportLog.MAJ(ukInsert);
            end;
        end;
    finally
      FreeAndNil(vSLLine);
      FreeAndNil(vSLFile);
      FreeAndNil(vSLFields);
      FreeAndNil(vExportLog);
    end;
    Log.Log('ExportBonRepris', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('ExportBonRepris', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

procedure TBaseClientNationaleCtrl.ExportClients(Const AExtension: String;
  Const APathDest: String; var AResultCode: TResultCode);
var
  i, nCLI_TOPVIB, nCLI_TOPVIBUTIL: Integer;
  sCLI_TOPVIB, sCLI_TOPVIBUTIL, Buffer, vFileName, vExt: String;
  vSLFile, vSLLine, vSLFields: TStringList;
  vQry: TADOQuery;
  vField: TField;
  vTypeEnseignes: TTypeEnseignes;
  vTypeEnseigne: TTypeEnseigne;
  vTypeExtFile: TTypeExtFile;
  vExportLog: TExportLog;
  vCLI_TOPVIB, vCLI_TOPVIBUTIL: TField;
begin
  Log.Log('ExportClients', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    inherited;
    vFileName:= '';
    AResultCode := TResultCode.Succeed;

    vSLFile:= TStringList.Create;
    vSLLine:= TStringList.Create;
    vExportLog:= TExportLog.Create;
    vQry:= dmGinkoia.GetNewQry;
    try
      vExt:= Copy( AExtension, 1, Length( AExtension ) - 1 );
      vSLFields:= GetListFieldBySection('E_CLIENTS_' + UpperCase(vExt), AResultCode);
      if vSLFields.Count = 0 then
      begin
        Log.Log('ExportClients', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
        Exit;
      end;

      vTypeExtFile:= ValueToTypeExtFile(vExt);
      case vTypeExtFile of
        tefINS: vTypeEnseignes:= [teGOSPORT, teCOURIR];
        tefFRE: vTypeEnseignes:= [teCOURIR];
      end;

      for vTypeEnseigne in vTypeEnseignes do
        begin
          {$REGION 'guard clauses'}
          case vTypeEnseigne of
            teGOSPORT:
              if not SameText( AExtension, Concat( vExt, cFileCodeExtGOSPORT ) ) then
                Continue;
            teCOURIR:
              if not SameText( AExtension, Concat( vExt, cFileCodeExtCOURIR ) ) then
                Continue;
            teNone:
              if TypeEnseigneToValue( vTypeEnseigne ) <> TypeEnseigneToValue( TTypeEnseigne.teNone ) then
                Continue;
          end;
          {$ENDREGION 'guard clauses'}
          vSLFile.Clear;

          { ----------------------- Construction Sql --------------------------- }
          vQry.SQL.Clear;
          vQry.SQL.Append('SELECT * FROM CLIENTS WHERE CLI_ENSID =:PCLI_ENSID');

          case vTypeEnseigne of
            teGOSPORT:
              begin
                vQry.SQL.Append('AND (CLI_CREATION=1');
                vQry.SQL.Append('OR CLI_MODIF=1)');
                vFileName:= ExcludeTrailingBackslash(APathDest) + '\' + FormatDateTime(cFormatFileName, Now) + '.' + vExt + cFileCodeExtGOSPORT;
              end;
            teCOURIR:
              begin
                case vTypeExtFile of
                  tefINS: vQry.SQL.Append('AND CLI_CREATION=1');
                  tefFRE: vQry.SQL.Append('AND CLI_MODIF=1 AND CLI_CREATION=0');
                end;

                vFileName:= ExcludeTrailingBackslash(APathDest) + '\' + FormatDateTime(cFormatFileName, Now) + '.' + vExt + cFileCodeExtCOURIR;
              end;
          end;
          AResultCode.AFilename := vFileName;

          vQry.Parameters.ParamByName('PCLI_ENSID').Value:= TypeEnseigneToValue(vTypeEnseigne);
          vQry.Open;

          { ------------------ Chargement des données d'export ----------------- }
          while not vQry.Eof do
          begin
            try
              vSLLine.Clear;
              for i:= 0 to vSLFields.Count -1 do
              begin
                if SameText( vSLFields.Strings[ i ], 'CLI_TOPVIB' ) then
                begin
                  {$REGION 'Nouvelle règle du panier: PALIER = CLI_TOPVIB - CLI_TOPVIBUTIL'}
                  vCLI_TOPVIB := vQry.FieldByName('CLI_TOPVIB');
                  vCLI_TOPVIBUTIL := vQry.FieldByName('CLI_TOPVIBUTIL');

                  if((Assigned(vCLI_TOPVIB)) and (not vCLI_TOPVIB.IsNull)) then
                  begin
                    sCLI_TOPVIB := vCLI_TOPVIB.AsString;
                    if Length(sCLI_TOPVIB) = 0 then
                      nCLI_TOPVIB := 0
                    else
                      nCLI_TOPVIB := vCLI_TOPVIB.AsInteger;
                  end
                  else
                    nCLI_TOPVIB := 0;
                  if((Assigned(vCLI_TOPVIBUTIL)) and (not vCLI_TOPVIBUTIL.IsNull)) then
                  begin
                    sCLI_TOPVIBUTIL := vCLI_TOPVIBUTIL.AsString;
                    if Length(sCLI_TOPVIBUTIL) = 0 then
                      nCLI_TOPVIBUTIL := 0
                    else
                      nCLI_TOPVIBUTIL := vCLI_TOPVIBUTIL.AsInteger;
                  end
                  else
                    nCLI_TOPVIBUTIL := 0;

                  vSLLine.Add(IntToStr(nCLI_TOPVIB - nCLI_TOPVIBUTIL));
                  {$ENDREGION}
                end
                else if vSLFields.Strings[i] = 'CLI_MAGCREAMODIF' then
                begin
                  if vQry.FieldByName('CLI_CREATION').AsInteger = 1 then
                    Buffer:= vQry.FieldByName('CLI_MAGCREA').AsString
                  else if (vTypeEnseigne = teGOSPORT) or (vTypeExtFile = tefFRE) then
                    Buffer:= vQry.FieldByName('CLI_MAGMODIF').AsString;

                  vSLLine.Append(Buffer);
                end
                else if vSLFields.Strings[i] = 'N' then
                  vSLLine.Append('')
                else if vSLFields.Strings[i] = 'CODETYPEINFO' then
                begin
                  if vQry.FieldByName('CLI_CREATION').AsInteger = 1 then
                    vSLLine.Append('C')
                  else if vTypeEnseigne = teGOSPORT then
                  begin
                    if vQry.FieldByName('CLI_MODIF').AsInteger = 1 then
                      vSLLine.Append('M');
                  end;
                end
                // capadresse !!
                else if vSLFields.Strings[i] = 'QAADRESSE' then
                begin
                  // champ non ^pris en charge pour GoSport
                  if vTypeEnseigne = teCOURIR then
                  begin
                    if vQry.FieldByName('CLI_QAADRESSE').IsNull then
                      vSLLine.Append('9')
                    else if vQry.FieldByName('CLI_QAADRESSE').AsString = '00' then
                      vSLLine.Append('0')
                    else
                      vSLLine.Append('1');
                  end;
                end
                else if vSLFields.Strings[i] = 'QAMAIL' then
                begin
                  // champ non ^pris en charge pour GoSport
                  if vTypeEnseigne = teCOURIR then
                  begin
                    if vQry.FieldByName('CLI_QAMAIL').IsNull then
                      vSLLine.Append('9')
                    else if vQry.FieldByName('CLI_QAMAIL').AsString = '00000' then
                      vSLLine.Append('0')
                    else
                      vSLLine.Append('1');
                  end;
                end
                else if vSLFields.Strings[i] = 'QAPORTABLE' then
                begin
                  // champ non ^pris en charge pour GoSport
                  if vTypeEnseigne = teCOURIR then
                  begin
                    vSLLine.Append('9');
                  end;
                end
                // fin capadresse
                {$REGION 'CDC - GOSPORT - Fidélité Multi-cartes'}
                else if vSLFields[i] = 'CLI_TYPEFID' then
                begin
                  // champ non pris en charge pour Courir
                  if vTypeEnseigne = teGOSPORT then
                    vSLLine.Append(vQry.FieldByName('CLI_TYPEFID').AsString);
                end
                {$ENDREGION}
                {$REGION 'CDC - COURIR - consentements'}
                else if MatchText(vSLFields[i],['CLI_CSTTEL', 'CLI_CSTMAIL', 'CLI_CSTCGV']) then
                begin
                  // champs non pris en charge pour GoSport
                  if vTypeEnseigne = teCOURIR then
                  begin
                    vField:= vQry.FindField(vSLFields.Strings[i]);
                    if vField <> nil then
                      vSLLine.Append(vField.AsString)
                    else
                      vSLLine.Append('');
                  end
                end
                {$ENDREGION}
                else
                begin
                  vField:= vQry.FindField(vSLFields.Strings[i]);
                  if vField <> nil then
                    vSLLine.Append(vField.AsString)
                  else
                    vSLLine.Append('');
                end;
              end;

              if vSLLine.Count <> 0 then
                vSLFile.Append(StringReplace(vSLLine.Text, #13#10, GWSConfig.Options.Values['CSVSEP'], [rfReplaceAll]));
            except
              on E: Exception do
                raise Exception.CreateFmt('[%d/%d] CLI_ID=%d, %s : %s',
                  [vQry.RecNo, vQry.RecordCount, vQry.FieldByName('CLI_ID').AsInteger, vSLFields[i], E.Message]);
            end;
            vQry.Next;
          end;

          if vSLFile.Count <> 0 then
          begin
           { -------------------- Enregistrement du fichier ------------------ }
            vSLFile.SaveToFile(vFileName);


           { --------------------- Maj de base de données -------------------- }
            for i:= 0 to vSLFile.Count -1 do
            begin
              if vTypeExtFile = tefFRE then
                Buffer:= 'M'
              else
              begin
                vSLLine.Text:= StringReplace(vSLFile.Strings[i], GWSConfig.Options.Values['CSVSEP'], #13#10, [rfReplaceAll]);
                Buffer:= vSLLine.Strings[vSLFields.IndexOf('CODETYPEINFO')];
              end;

              case Buffer[1] of
                'C': Buffer:= 'UPDATE CLIENTS SET CLI_CREATION = 0, CLI_MODIF = 0 WHERE CLI_ENSID =:PCLI_ENSID AND CLI_CREATION = 1';
                'M':
                  begin
                    Buffer:= '';
                    if (vTypeEnseigne = teGOSPORT) or (vTypeExtFile = tefFRE) then
                      Buffer:= 'UPDATE CLIENTS SET CLI_MODIF = 0 WHERE CLI_ENSID =:PCLI_ENSID AND CLI_MODIF = 1'
                  end;
              end;

              if Buffer <> '' then
                begin
                  vQry.SQL.Text:= Buffer;
                  vQry.Parameters.ParamByName('PCLI_ENSID').Value:= TypeEnseigneToValue(vTypeEnseigne);
                  vQry.ExecSQL;
                end;
            end;

            { ------------------ Journalisation de l'export ------------------ }
            vExportLog.EXP_HEURE:= Now;
            vExportLog.EXP_FICHIER:= ExtractFileName(vFileName);
            vExportLog.EXP_DATELASTEXPORT:= Trunc(Now);
            vExportLog.MAJ(ukInsert);
          end;
        end;
    finally
      FreeAndNil(vSLLine);
      FreeAndNil(vSLFile);
      FreeAndNil(vSLFields);
      FreeAndNil(vExportLog);
    end;
    Log.Log('ExportClients', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('ExportClients', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

//JB
function TBaseClientNationaleCtrl.FormatLigne(NLine : Integer) : String;
begin
  Result := IntToStr(NLine);
  while length(Result) < 5  do
    Result := '.' + Result;
end;



procedure TBaseClientNationaleCtrl.ControleFormatFichierCLI(NLine : Integer; aLine : String; var aSLLog : TStringList; aSeparateur, aMessage : String);
const
	cCLI_NUMCARTE1 = 1;
	cCLI_NUMCARTE2 = 2;
	cCLI_DTVAL = 3;
	cCLI_CODECLUB = 4;
	cCLI_CIV = 5;
	cCLI_NOM = 6;
	cCLI_PRENOM = 7;
	cCLI_ADR1 = 8;
	cCLI_ADR2 = 9;
	cCLI_ADR3 = 10;
	cCLI_ADR4 = 11;
	cCLI_CP = 12;
	cCLI_VILLE = 13;
	cCLI_CODEPAYS = 14;
	cCLI_TEL1 = 15;
	cCLI_TEL2 = 16;
	cCLI_DTNAISS = 17;
	cCLI_CODEPROF = 18;
	cCLI_AUTRESP = 19;
	cCLI_BLACKLIST = 20;
	cCLI_EMAIL = 21;
	cCLI_DTCREATION = 22;
  cCLI_IDETO = 23;
	cCLI_TOPSAL = 24;
	cCLI_CODERFM = 25;
	cCLI_OPTIN = 26;
	cCLI_OPTINPART = 27;
	cCLI_MAGORIG = 28;
	cCLI_TOPNPAI = 29;
	cCLI_TOPVIB = 30;
	cCLI_REMRENOUV = 31;
	cCLI_DTSUP = 32;
	cCLI_DTRENOUV = 33;
	cCLI_TYPEINFO = 34;

var
  vSLLine, vValeur, vNumLine, aString, aString2, aString3, aString4 : String;
  i,j,k,Indice, Position : Integer;

function IsNotNumerique(pValeur : String) : Boolean;
var
  i : Integer;
begin
  result := False;
  if pValeur <> '' then
  begin
    for i := 1 to length(pValeur) do
    begin
      if (copy(pValeur,i,1) < '0') or (copy(pValeur,i,1) > '9') then result := True;
    end;
  end;
end;

function IsNotDate(pValeur : String) : Boolean;
//var
//  i : Integer;
//  vDate : TDate;
begin
  result := False;
  if pValeur <> '' then
  begin
    if (length(pValeur) > 10) or (Pos('/',pValeur) = 0) then
    begin
      result := True;
    end
    else begin
      try
        StrToDate(pValeur);
      except
        result := True;
      end;
    end;
  end;
end;

begin
  vNumLine := FormatLigne(NLine);
  if pos(aSeparateur,aLine) > 0 then
  begin
    aString := aLine;
    Indice := 1;
    while Indice < 35 do
    begin
      k := pos(aSeparateur,aString);
      if k = 0 then
      begin
        vValeur := trim(aString);
        aString := '';
      end else
      begin
        vValeur := trim(copy(aString,1,k-1));
        aString := copy(aString,k+length(aSeparateur),length(aString)-k-length(aSeparateur)+1);
      end;
      aString2 := '';
      case Indice of
        cCLI_NUMCARTE1  : if length(vValeur) > 15 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_NUMCARTE   : Ancien code carte -> longueur > 15 (' + vValeur + ')';
        cCLI_NUMCARTE2  : if length(vValeur) > 13 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_NUMCARTE   : Nouveau code carte -> longueur > 13 (' + vValeur + ')';
        cCLI_DTVAL      : if IsNotDate(vValeur) then
                            aString2 := 'Ligne' + vNumLine + ' CLI_DTVAL      : Date de validité -> date incorrecte (' + vValeur + ')';
        cCLI_CODECLUB   : if length(vValeur) > 12 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_CODECLUB   : Code club -> longueur > 12 (' + vValeur + ')';
        cCLI_CIV        : if length(vValeur) > 4 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_CIV        : Civilite -> longueur > 4 (' + vValeur + ')';
        cCLI_NOM        : if length(vValeur) > 50 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_NOM        : Nom -> longueur > 50 (' + vValeur + ')';
        cCLI_PRENOM     : if length(vValeur) > 30 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_PRENOM     : Prenom -> longueur > 30 (' + vValeur + ')';
        cCLI_ADR1       : if length(vValeur) > 50 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_ADR1       : Adresse ligne 1 -> longueur > 50 (' + vValeur + ')';
        cCLI_ADR2       : if length(vValeur) > 50 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_ADR2       : Adresse ligne 2 -> longueur > 50 (' + vValeur + ')';
        cCLI_ADR3       : if length(vValeur) > 50 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_ADR3       : Adresse ligne 3 -> longueur > 50 (' + vValeur + ')';
        cCLI_ADR4       : if length(vValeur) > 50 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_ADR4       : Adresse ligne 4 -> longueur > 50 (' + vValeur + ')';
        cCLI_CP         : if length(vValeur) > 15 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_CP         : Code postal -> longueur > 15 (' + vValeur + ')';
        cCLI_VILLE      : if length(vValeur) > 50 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_VILLE      : Ville -> longueur > 50 (' + vValeur + ')';
        cCLI_CODEPAYS   : if length(vValeur) > 2 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_CODEPAYS   : Code pays -> longueur > 2 (' + vValeur + ')';
        cCLI_TEL1       : if length(vValeur) > 20 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_TEL1       : Telephone 1 -> longueur > 20 (' + vValeur + ')';
        cCLI_TEL2       : if length(vValeur) > 20 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_TEL2       : Telephone 2 -> longueur > 20 (' + vValeur + ')';
        cCLI_DTNAISS    : if IsNotDate(vValeur) then
                            aString2 := 'Ligne' + vNumLine + ' CLI_DTNAISS    : Date de naissance -> date incorrect (' + vValeur + ')';
        cCLI_CODEPROF   : if length(vValeur) > 4 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_CODEPROF   : Code profession -> longueur > 4 (' + vValeur + ')';
        cCLI_AUTRESP    : if length(vValeur) > 20 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_AUTRESP    : Autre sport -> longueur > 20 (' + vValeur + ')';
        cCLI_BLACKLIST  : if length(vValeur) > 1 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_BLACKLIST  : Client en liste noire -> longueur > 1 (' + vValeur + ')';
        cCLI_EMAIL      : if length(vValeur) > 100 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_EMAIL      : Email -> longueur > 100 (' + vValeur + ')';
        cCLI_DTCREATION : if IsNotDate(vValeur) then
                            aString2 := 'Ligne' + vNumLine + ' CLI_DTCREATION : Date Création -> date incorrecte (' + vValeur + ')';
        cCLI_IDETO      : if length(vValeur) > 15 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_IDETO      : Code Pivot -> longueur > 15 (' + vValeur + ')';
        cCLI_TOPSAL     : if length(vValeur) > 1 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_TOPSAL     : Top Salarie -> longueur > 1 (' + vValeur + ')';
        cCLI_CODERFM    : if length(vValeur) > 2 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_CODERFM    : Code RFM -> longueur > 2 (' + vValeur + ')';
        cCLI_OPTIN      : if length(vValeur) > 1 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_OPTIN      : Top OPTIN -> trop long (' + vValeur + ')';
        cCLI_OPTINPART  : if length(vValeur) > 1 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_OPTINPART  : Top OPTIN partenaire -> longueur > 1 (' + vValeur + ')';
        cCLI_MAGORIG    : if length(vValeur) > 4 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_MAGORIG    : Code magasin origine -> longueur > 4 (' + vValeur + ')';
        cCLI_TOPNPAI    : if length(vValeur) > 1 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_TOPNPAI    : Top NPAI -> longueur > 1 (' + vValeur + ')';
        cCLI_TOPVIB     : if length(vValeur) > 1 then
                            aString2 := 'Ligne' + vNumLine + ' CLI_TOPVIB     : Top VIB -> longueur > 1 (' + vValeur + ')';
        cCLI_REMRENOUV  : if IsNotNumerique(vValeur) then
                            aString2 := 'Ligne' + vNumLine + ' CLI_REMRENOUV  : Remise sur renouvellement -> non numerique (' + vValeur + ')';
        cCLI_DTSUP      : if IsNotDate(vValeur) then
                            aString2 := 'Ligne' + vNumLine + ' CLI_DTSUP      : Date_suppression -> date incorrecte (' + vValeur + ')';
        cCLI_DTRENOUV   : if IsNotDate(vValeur) then
                            aString2 := 'Ligne' + vNumLine + ' CLI_DTRENOUV   : Date_Renouvellement -> date incorrecte (' + vValeur + ')';
        cCLI_TYPEINFO   : if (vValeur <> 'C') and (vValeur <> 'M') and (vValeur <> 'S') then
                            aString2 := 'Ligne' + vNumLine + ' CLI_TYPEINFO   : Code Type Infos -> Attendu (C,M,S) incorrect (' + vValeur + ')';
      end;
      Indice := Indice + 1;
      if aString2 <> '' then
      begin
//JB    Rechercher dans aSLLog si message déjà mémorisé
        I := aSLLog.Count;
        if I > 0 then
        begin
          aString3 := 'Ligne' + vNumLine;
          while I > 0 do
          begin
            I := I -1;
            aString4 := aSLLog[I];
            if Copy(aString4,1,length(aString3)) = aString3 then
            begin
              J := Pos(':',aString4);
              if copy(aString4,1,J) = copy(aString2,1,J) then
              begin
                I := 0;
              end
              else
              begin
                if I = 0 then
                  aSLLog.Append( aString2 + aMessage);
              end
            end
            else
            begin
              aSLLog.Append( aString2 + aMessage);
              I := 0;
            end;
          end;
        end
        else aSLLog.Append( aString2 + aMessage);
      end;
    end;
  end else
  begin
    aSLLog.Append('Pas de séparateur "' + aSeparateur + '" sur la première ligne');
  end;
end;
//


function TBaseClientNationaleCtrl.FileNameToLog(const AFileName: String): String;
var
  vBuffer, vString, vDateTime, vFilePath, vFileName, vExtension: String;
  Indice : Integer;
begin
//JB
  vFilePath:= ExtractFilePath(AFileName);
  vExtension := ExtractFileExt(AFileName);
  vFileName := ExtractFileName(AFileName);
  vFileName := copy(vFileName,1,length(vFileName)-length(vExtension));
  vDateTime := FormatDateTime('yyyy\mm\dd\',now);
  vString:= vFilePath + cRepLog + vDateTime + vFileName + vExtension + cSufixeExtLog;
  vBuffer := ExtractFilePath(vString);
  if not DirectoryExists(vBuffer) then
    ForceDirectories(vBuffer);
  Indice := 1;
  while FileExists(vString) do
  begin
    vString := vFilePath + cRepLog + vDateTime + vFileName + '_' + IntToStr(Indice) + vExtension + cSufixeExtLog;
    Inc(Indice);
  end;
  Result := vString;
//
end;

// Copie comme Archives
function TBaseClientNationaleCtrl.FileNameToBak(const AFileName: String): String;
var
  Buffer, aString, aExtension : String;
  Indice : Integer;
begin
  Buffer := FormatDateTime('yyyy\mm\dd\',now);
  aString:= ExtractFilePath(AFileName) + cRepBak + Buffer + ExtractFileName(AFileName);
  Buffer:= ExtractFilePath(aString);
  if not DirectoryExists(Buffer) then
    ForceDirectories(Buffer);
  Buffer := aString;
  aExtension := ExtractFileExt(Buffer);
  Indice := 1;
  aString := copy(Buffer,1,length(Buffer)-length(aExtension)) + '_';
  while FileExists(Buffer) do
  begin
    Buffer := aString + IntToStr(Indice) + aExtension;
    Inc(Indice);
  end;
  Result := Buffer;
end;



function TBaseClientNationaleCtrl.FileNameToTypeEnseigne(
  const AFileName: String; var AResultCode: TResultCode): TTypeEnseigne;
begin
  Result:= teNone;
  AResultCode := TResultCode.SucceedWithFilename( AFileName );

  if CharInSet(AFileName[Length(AFileName)], ['7', '8']) then
    begin
      case StrToInt(AFileName[Length(AFileName)]) of
        8: Result:= teGOSPORT;
        7: Result:= teCOURIR;
      end;
    end
  else
    begin
      AResultCode := TResultCode.FailedWithFilename( AFileName, rs_MESS_FileImportClientExtensionFailed, [ ExtractFileExt( AFileName ) ] );
    end;
end;

function TBaseClientNationaleCtrl.GetBonReducUtilise(Const ABRP_ENSID, ABRP_NUMTCK: integer;
  Const ABRP_NUMCARTE, ABRP_MAG, ABRP_DATE, ABRP_CODEBON: String;
  var AResultCode: TResultCode): TBonRepris;
var
  vQry: TADOQuery;
  vClient: TClient;
begin
  Log.Log('GetBonReducUtilise', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TBonRepris.Create;

    AResultCode := TResultCode.Succeed;
    try
      vClient:= GetClient(ABRP_NUMCARTE, AResultCode);
      if AResultCode.IsFailed then
      begin
        Log.Log('GetBonReducUtilise', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
        Exit;
      end;

      if not Assigned( vClient ) then
        begin
          AResultCode := TResultCode.Failed( rs_MESS_CardNotfound, [ ABRP_NUMCARTE ] );
          Log.Log('GetBonReducUtilise', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
          Exit;
        end
      else
        if vClient.CLI_DTSUP <> 0 then
          begin
            AResultCode := TResultCode.Failed( rs_MESS_ClientDelete );
            Log.Log('GetBonReducUtilise', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
            Exit;
          end

        else
          if vClient.CLI_DTVAL < Now then
            begin
              AResultCode := TResultCode.Failed( rs_MESS_ClientDisabled, [ ABRP_NUMCARTE ] );
              Log.Log('GetBonReducUtilise', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
              Exit;
            end;

      vQry:= dmGinkoia.GetNewQry;

      vQry.SQL.Append('SELECT * FROM BONREPRIS WHERE');
      vQry.SQL.Append('BRP_ENSID=:PBRP_ENSID');
      vQry.SQL.Append('AND BRP_NUMCARTE=:PBRP_NUMCARTE');
      vQry.SQL.Append('AND BRP_NUMTCK=:PBRP_NUMTCK');
      vQry.SQL.Append('AND BRP_MAG=:PBRP_MAG');
      vQry.SQL.Append('AND BRP_CODEBON=:PBRP_CODEBON');

      vQry.Parameters.ParamByName('PBRP_ENSID').Value:= ABRP_ENSID;
      vQry.Parameters.ParamByName('PBRP_NUMCARTE').Value:= ABRP_NUMCARTE;
      vQry.Parameters.ParamByName('PBRP_NUMTCK').Value:= ABRP_NUMTCK;
      vQry.Parameters.ParamByName('PBRP_MAG').Value:= ABRP_MAG;
      vQry.Parameters.ParamByName('PBRP_CODEBON').Value:= ABRP_CODEBON;

      vQry.Open;

      if not vQry.Eof then
        begin
          if vQry.FieldByName('BRP_TRAITE').AsInteger = 1 then
            begin
              AResultCode := TResultCode.Failed( rs_MESS_BonDejaUtilise );
            end

          else
            Result.SetValuesByDataSet(vQry);
        end;
    finally
      if vClient <> nil then
        FreeAndNil(vClient);
      if vQry <> nil then
        FreeAndNil(vQry);
    end;
    Log.Log('GetBonReducUtilise', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      AResultCode := TResultCode.Failed('GetBonReducUtilise : ' + E.Message);
      Log.Log('GetBonReducUtilise', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function TBaseClientNationaleCtrl.GetClient(const ACLI_NUMCARTE: String;
  var AResultCode: TResultCode; Const AGetCliOldCards: Boolean): TClient;
var
  vQry: TADOQuery;
  vCliOldCards: TCliOldCards;
begin
  Log.Log('GetClient', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    vCliOldCards:= nil;
    Result:= nil;
    AResultCode := TResultCode.Succeed;
    try
      vQry:= dmGinkoia.GetNewQry;

      vQry.SQL.Append('SELECT * FROM CLIENTS');
      vQry.SQL.Append('LEFT OUTER JOIN POINTS ON (CLI_NUMCARTE=PTS_NUMCARTE)');
      vQry.SQL.Append('WHERE CLI_NUMCARTE=:PCLI_NUMCARTE');

      vQry.Parameters.ParamByName('PCLI_NUMCARTE').Value:= ACLI_NUMCARTE;

      vQry.Open;
      if not vQry.Eof then
        begin
          Result:= TClient.Create;
          Result.SetValuesByDataSet(vQry);
        end
      else
        if AGetCliOldCards then
          begin
            vCliOldCards:= GetCliOldCardsByNUMCARTE(ACLI_NUMCARTE, AResultCode);
            if Assigned( vCliOldCards ) and AResultCode.IsSucceed then
              begin
                AResultcode.Failed( rs_MESS_ClientDisabled, [ ACLI_NUMCARTE ] );
              end;
          end;
    finally
      FreeAndNil(vQry);
      if vCliOldCards <> nil then
        FreeAndNil(vCliOldCards);
    end;
    Log.Log('GetClient', 'TBaseClientNationaleCtrl', '', 'exit', AResultCode.AMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      AResultCode := TResultCode.Failed('GetListInfoClient : ' + E.Message);
      Log.Log('GetClient', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function TBaseClientNationaleCtrl.GetCliOldCardsByNUMCARTE(const ACLI_NUMCARTE: String;
  var AResultCode: TResultCode): TCliOldCards;
var
  vQry: TADOQuery;
begin
  Result:= nil;
  AResultCode := TResultCode.Succeed;
  try
    try
      vQry:= dmGinkoia.GetNewQry;

      vQry.SQL.Text:= 'SELECT * FROM CLIOLDCARDS WHERE COC_NUMCARTE=:PCOC_NUMCARTE';
      vQry.Parameters.ParamByName('PCOC_NUMCARTE').Value:= ACLI_NUMCARTE;

      vQry.Open;
      if not vQry.Eof then
        begin
          Result:= TCliOldCards.Create;
          Result.SetValuesByDataSet(vQry);
        end;

    except
      on E: Exception do
        begin
          AResultCode := TResultCode.Failed( 'GetCliOldCardsByNUMCARTE : ' + E.Message );
          Raise;
        end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TBaseClientNationaleCtrl.GetDateTimeGMT: String;
begin
  Log.Log('GetDateTimeGMT', 'TBaseClientNationaleCtrl', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= StringReplace(FormatDateTime('YYYY-MM-DD|HH:NN:SS', GetGmtFromSystemTime), '|', 'T', []);
    Log.Log('GetDateTimeGMT', 'TBaseClientNationaleCtrl', '', 'exit', Result, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('GetDateTimeGMT', 'TBaseClientNationaleCtrl', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

{ TResultCode }

constructor TResultCode.Create(ACodeErr: Integer; AMessage: String;
  AFilename: TFileName);
begin
  Self.ACodeErr := ACodeErr;
  Self.AMessage := AMessage;
  Self.AFilename := AFilename;
end;

constructor TResultCode.Create(ACodeErr: Integer; Format: String;
  Args: array of const; AFilename: TFileName);
begin
  Create( ACodeErr, SysUtils.Format( Format, Args ), AFilename );
end;

class function TResultCode.Failed(const Format: String;
  const Args: array of const): TResultCode;
begin
  Exit( TResultCode.Failed( SysUtils.Format( Format, Args) ) );
end;

class function TResultCode.IsFailed(ResultCode: TResultCode): Boolean;
begin
  Exit( ResultCode.ACodeErr = TCodeErrRec.Failed );
end;

function TResultCode.IsFailed: Boolean;
begin
  Exit( TResultCode.IsFailed( Self ) );
end;

class function TResultCode.IsSucceed(ResultCode: TResultCode): Boolean;
begin
  Exit( ResultCode.ACodeErr = TCodeErrRec.Succeed )
end;

function TResultCode.IsSucceed: Boolean;
begin
  Exit( TResultCode.IsSucceed( Self ) );
end;

function TResultCode.IsWarned: Boolean;
begin
  Exit( TResultCode.IsWarned( Self ) );
end;

class function TResultCode.IsWarned(ResultCode: TResultCode): Boolean;
begin
  Exit( ResultCode.ACodeErr = TCodeErrRec.Warned );
end;

class function TResultCode.Failed(const Message: String): TResultCode;
begin
  Exit( TResultCode.FailedWithFilename( SysUtils.EmptyStr, Message ) );
end;

class function TResultCode.Succeed(const Message: String): TResultCode;
begin
  Exit( TResultCode.SucceedWithFilename( SysUtils.EmptyStr, Message ) );
end;

class function TResultCode.Warned(const Message: String): TResultCode;
begin
  Exit( TResultCode.WarnedWithFilename( SysUtils.EmptyStr, Message ) );
end;

class function TResultCode.Succeed(const Format: String;
  const Args: array of const): TResultCode;
begin
  Exit( TResultCode.Succeed( SysUtils.Format( Format, Args) ) );
end;

class function TResultCode.SucceedWithFilename(const Filename: TFileName;
  const Format: String; const Args: array of const): TResultCode;
begin
  Exit( TResultCode.SucceedWithFilename( Filename, SysUtils.Format( Format, Args ) ) );
end;

class function TResultCode.SucceedWithFilename(const Filename: TFileName;
  const Message: String): TResultCode;
begin
  Exit( TResultCode.Create( TCodeErrRec.Succeed , Message, Filename ) );
end;

class function TResultCode.WarnedWithFilename(const Filename: TFileName;
  const Message: String): TResultCode;
begin
  Exit( TResultCode.Create( TCodeErrRec.Warned, Message, Filename ) );
end;

class function TResultCode.WarnedWithFilename(const Filename: TFileName;
  const Format: String; const Args: array of const): TResultCode;
begin
  Exit( TResultCode.WarnedWithFilename( Filename, SysUtils.Format( Format, Args ) ) );
end;

class function TResultCode.Warned(const Format: String;
  const Args: array of const): TResultCode;
begin
  Exit( TResultCode.Warned( SysUtils.Format( Format, Args) ) );
end;

class function TResultCode.FailedWithFilename(const Filename: TFileName;
  const Format: String; const Args: array of const): TResultCode;
begin
  Exit( TResultCode.FailedWithFilename( Filename, SysUtils.Format( Format, Args ) ) );
end;

class function TResultCode.FailedWithFilename(const Filename: TFileName;
  const Message: String): TResultCode;
begin
  Exit( TResultCode.Create( TCodeErrRec.Failed, Message, Filename ) );
end;

end.

