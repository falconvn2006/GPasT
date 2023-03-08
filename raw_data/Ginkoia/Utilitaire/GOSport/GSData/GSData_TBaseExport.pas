unit GSData_TBaseExport;

interface

const
  PAS_DONNEES_EXPORT = 'Pas de données à exporter';

type
  TBaseExportResult = ( berIndeterminate, berSucceed, berWarning, berError );
  TBaseExportResultRec = record
  const
    Indeterminate = TBaseExportResult.berIndeterminate;
    Succeed = TBaseExportResult.berSucceed;
    Warning = TBaseExportResult.berWarning;
    Error = TBaseExportResult.berError;
  end;

  TBaseExport = class(TObject)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    FLocMagId, FGinMagId, FHofID, FFicID, FLastNum : integer;
    FMagCodAdh, FFilePath, FFileName, FProcName : string;
    FLastDate : TDateTime;

    FEtape, FErreur : string;

    function DoGenereFile(Entete : boolean = false) : TBaseExportResult; virtual;
    function DoSendFTP() : boolean; virtual;
    function DoSendSFTP: Boolean; virtual;
    function DoValidate() : boolean; virtual;

    function DoMAJLastNum() : boolean; virtual;
    function DoMAJLastTrt() : boolean; virtual;

    function GetParamInteger(prmType, prmCode : integer; UseMag : boolean = true) : integer;
  public
    { Déclarations publiques }
    constructor Create(MagCodAdh : string; LocMagId, GinMagId, HofId, FicId : integer; FilePath : string); reintroduce; virtual;
    destructor Destroy(); override;

    function Traitement(Manuel : boolean; Entete : boolean = false) : TBaseExportResult; virtual;

    property Etape : string read FEtape;
    property Erreur : string read FErreur;
    property Filename: String read FFileName;
  private
    function Indeterminate: TBaseExportResult; overload;
    function Succeed: TBaseExportResult; overload;
    function Warning: TBaseExportResult; overload;
    function Error: TBaseExportResult; overload;
    function Indeterminate(const Reason: String): TBaseExportResult; overload;
    function Succeed(const Reason: String): TBaseExportResult; overload;
    function Warning(const Reason: String): TBaseExportResult; overload;
    function Error(const Reason: String): TBaseExportResult; overload;
    function Indeterminate(const Format: String; const Args: array of const): TBaseExportResult; overload;
    function Succeed(const Format: String; const Args: array of const): TBaseExportResult; overload;
    function Warning(const Format: String; const Args: array of const): TBaseExportResult; overload;
    function Error(const Format: String; const Args: array of const): TBaseExportResult; overload;
  end;

type
  TExportTest1 = class(TBaseExport)
  public
    { Déclarations publiques }
    function Traitement(Manuel : boolean; Entete : boolean = true) : TBaseExportResult; override;
  end;

type
  TExportTest2 = class(TBaseExport)
  public
    { Déclarations publiques }
    function Traitement(Manuel : boolean; Entete : boolean = true) : TBaseExportResult; override;
  end;

type
  TExportXICKET = class(TBaseExport)
  protected
    { Déclarations protégées }
    function DoGenereFile(Entete : boolean = false): TBaseExportResult; override;
  end;

type
  TExportGoS = class(TBaseExport)
  protected
    { Déclarations protégées }
    FLastVersion    : Integer;
    FCurrentVersion : Integer;
    function DoMAJLastNum(): Boolean; override;
    function DoGenereFile(Entete: Boolean = False): TBaseExportResult; override;
  public
    { Déclarations publiques }
    property LastVersion    : Integer read FLastVersion     write FLastVersion;
    property CurrentVersion : Integer read FCurrentVersion  write FCurrentVersion;
  end;

type
  TBaseExportClass = class of TBaseExport;

implementation

uses
  Windows,
  SysUtils,
  Math,
  Dialogs,
  Classes,
  StrUtils,
  DateUtils,
  DB,
  GSDataDbCfg_DM,
  GSDataExport_DM,
  GSData_Types, uLog, GSDataMain_DM;

{ TBaseExport }

function TBaseExport.DoGenereFile(Entete : boolean) : TBaseExportResult;
var
  i : integer;
  Ligne : string;
  Fichier : TStringList;
begin
  FEtape := 'Génération du fichier "' + FFileName + '"';
  Result := Error( SysUtils.EmptyStr );
  Ligne := '';

  try
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.StartTransaction();
    DM_GSDataExport.Que_Generic_RecupData.SQL.Text := 'select * from ' + FProcName + '(:filename, :magginid);';
    DM_GSDataExport.Que_Generic_RecupData.ParamCheck := true;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('magginid').AsInteger := FGinMagId;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('filename').AsString := FFileName;
    try
      DM_GSDataExport.Que_Generic_RecupData.Open();
      if not DM_GSDataExport.Que_Generic_RecupData.Eof then
      begin
        if not DirectoryExists(FFilePath) then
          ForceDirectories(FFilePath);
        Fichier := TStringList.Create;
        try
          fichier.WriteBOM := False;
          // Gestion des entete ??
          if Entete then
          begin
            for i := 0 to DM_GSDataExport.Que_Generic_RecupData.Fields.Count -1 do
            begin
              if i = 0 then
                Ligne := DM_GSDataExport.Que_Generic_RecupData.Fields[i].FieldName
              else
                Ligne := Ligne + '|' + DM_GSDataExport.Que_Generic_RecupData.Fields[i].FieldName;
            end;
            fichier.Add(Ligne);
          end;
          // ecriture des données
          while not DM_GSDataExport.Que_Generic_RecupData.Eof do
          begin
            Ligne := '';
            for i := 0 to DM_GSDataExport.Que_Generic_RecupData.Fields.Count -1 do
            begin
              if i = 0 then
                Ligne := DM_GSDataExport.Que_Generic_RecupData.Fields[i].AsString
              else
                Ligne := Ligne + '|' + DM_GSDataExport.Que_Generic_RecupData.Fields[i].AsString;
            end;
            fichier.Add(Ligne);
            DM_GSDataExport.Que_Generic_RecupData.Next();
          end;
          fichier.SaveToFile(FFilePath + FFileName, TEncoding.UTF8);
        finally
          Fichier.Free;
        end;
        Result := Succeed;
      end
      else begin
        FFileName := PAS_DONNEES_EXPORT;
        Result := Warning( ' -> ' + PAS_DONNEES_EXPORT );
      end;
    finally
      DM_GSDataExport.Que_Generic_RecupData.Close();
    end;
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Commit();
  except
    on e : exception do
    begin
      DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Rollback();
      Exit( Error( ' -> Exception : %s - %s', [ e.ClassName, e.Message ] ) );
    end;
  end;
end;

function TBaseExport.DoSendFTP() : boolean;
var
  ModeMag : integer;
begin
  Result := False;
  FEtape := 'Envoi sur le FTP';
  FErreur := '';
  try
    ModeMag := GetParamInteger(16, 7, true);
    if ModeMag <= 0 then
      Exit;
    if not DM_GSDataExport.IsOpenFTP() then
      DM_GSDataExport.OpenFTP();
    result := DM_GSDataExport.PutFileOnFTP(FFilePath, FFileName, ModeMag, 0, '');
  except
    on E: Exception do
    begin
      FErreur := ' -> Exception : ' + e.ClassName + ' - ' + E.Message;
      raise;
    end;
  end;
end;

function TBaseExport.DoSendSFTP: Boolean;
var
  ModeMag : integer;
begin
  Result := False;
  FEtape := 'Envoi sur le SFTP';
  FErreur := '';
  try
    ModeMag := GetParamInteger(16, 7, true);
//    if ModeMag <= 0 then
//      Exit;
    if not DM_GSDataExport.IsOpenSFTP() then
      DM_GSDataExport.OpenSFTP();
    Result := DM_GSDataExport.PutFileOnSFTP(FFilePath, FFileName, ModeMag, 0, '');
  except
    on E: Exception do
    begin
      FErreur := ' -> Exception : ' + e.ClassName + ' - ' + E.Message;
      raise;
    end;
  end;
end;

function TBaseExport.DoValidate() : boolean;
begin
  FEtape := 'Validation';
  FErreur := '';

  result := false;
  try
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.StartTransaction();
    DM_GSDataExport.Que_Generic_RecupData.SQL.Text := 'execute procedure GOSBI_DOVALIDATE(:magginid, :datevalide, :filename);';
    DM_GSDataExport.Que_Generic_RecupData.ParamCheck := true;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('magginid').AsInteger := FGinMagId;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('datevalide').AsDateTime := Now();
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('filename').AsString := FFileName;
    DM_GSDataExport.Que_Generic_RecupData.ExecSQL();
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Commit();
    result := true;
  except
    on e : Exception do
    begin
      DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Rollback();
      FErreur := ' -> Exception : ' + e.ClassName + ' - ' + E.Message;
    end;
  end;
end;

function TBaseExport.Error(const Format: String;
  const Args: array of const): TBaseExportResult;
begin
  Exit( Error( SysUtils.Format( Format, Args ) ) );
end;

function TBaseExport.Error(const Reason: String): TBaseExportResult;
begin
  FErreur := Reason;
  Exit( Error );
end;

function TBaseExport.Error: TBaseExportResult;
begin
  Exit( TBaseExportResultRec.Error );
end;

function TBaseExport.DoMAJLastNum() : boolean;
begin
  FEtape := 'Mise-à-jour du numéro';
  FErreur := '';

  result := false;
  try
    DM_GsDataDbCfg.Que_MAJ.IB_Transaction.StartTransaction();
    if FLastNum = 1 then
      DM_GsDataDbCfg.Que_MAJ.SQL.Text := 'insert into histomagfic (hmf_ficid, hmf_magid, hmf_lastnum) '
                                       + 'values (:ficid, :magid, :lastnum);'
    else
      DM_GsDataDbCfg.Que_MAJ.SQL.Text := 'update histomagfic set hmf_lastnum = :lastnum '
                                       + 'where hmf_ficid = :ficid and hmf_magid = :magid;';
    DM_GsDataDbCfg.Que_MAJ.ParamCheck := true;
    DM_GsDataDbCfg.Que_MAJ.ParamByName('ficid').AsInteger := FFicID;
    DM_GsDataDbCfg.Que_MAJ.ParamByName('magid').AsInteger := FLocMagId;
    DM_GsDataDbCfg.Que_MAJ.ParamByName('lastnum').AsInteger := FLastNum;
    DM_GsDataDbCfg.Que_MAJ.ExecSQL();
    DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Commit();
    Result := True;
  except
    on e : Exception do
    begin
      DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Rollback();
      FErreur := ' -> Exception : ' + e.ClassName + ' - ' + E.Message;
    end;
  end;
end;

function TBaseExport.DoMAJLastTrt() : boolean;
begin
  FEtape := 'Mise-à-jour de la date de traitement';
  FErreur := '';

  result := false;
  try
    DM_GsDataDbCfg.Que_MAJ.IB_Transaction.StartTransaction();
    if FLastDate = 0 then
      DM_GsDataDbCfg.Que_MAJ.SQL.Text := 'insert into maghorfic (mhf_hofid, mhf_magid, mhf_datetrt) '
                                       + 'values (:hofid, :magid, :lastdate)'
    else
      DM_GsDataDbCfg.Que_MAJ.SQL.Text := 'update maghorfic set mhf_datetrt = :lastdate '
                                       + 'where mhf_hofid = :hofid and mhf_magid = :magid;';
    DM_GsDataDbCfg.Que_MAJ.ParamCheck := true;
    DM_GsDataDbCfg.Que_MAJ.ParamByName('hofid').AsInteger := FHofID;
    DM_GsDataDbCfg.Que_MAJ.ParamByName('magid').AsInteger := FLocMagId;
    DM_GsDataDbCfg.Que_MAJ.ParamByName('lastdate').AsDateTime := Trunc(Now());
    DM_GsDataDbCfg.Que_MAJ.ExecSQL();
    DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Commit();
    Result := True;
  except
    on e : Exception do
    begin
      DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Rollback();
      FErreur := ' -> Exception : ' + e.ClassName + ' - ' + E.Message;
    end;
  end;
end;

function TBaseExport.GetParamInteger(prmType, prmCode : integer; UseMag : boolean) : integer;
begin
  FEtape := 'Récupération de paramètre (Type = ' + IntToStr(prmType) + ' Code : ' + IntToStr(prmCode) + ')';
  FErreur := '';

  Result := -1;

  try
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.StartTransaction();
    DM_GSDataExport.Que_Generic_RecupData.SQL.Text := 'select prm_integer from genparam '
                                                    + 'join k on k_id = prm_id and k_enabled = 1 '
                                                    + 'where prm_type = :pprmtype '
                                                    + 'and prm_code = :pprmcode ';
    if UseMag then
      DM_GSDataExport.Que_Generic_RecupData.SQL.Text := DM_GSDataExport.Que_Generic_RecupData.SQL.Text
                                                      + 'and prm_magid = :pprmmagid';
    DM_GSDataExport.Que_Generic_RecupData.ParamCheck := true;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('pprmtype').AsInteger := prmType;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('pprmcode').AsInteger := prmCode;
    if UseMag then
      DM_GSDataExport.Que_Generic_RecupData.ParamByName('pprmmagid').AsInteger := FGinMagId;
    try
      DM_GSDataExport.Que_Generic_RecupData.Open();
      if DM_GSDataExport.Que_Generic_RecupData.Eof then
        raise Exception.Create('Configuration incorrecte -> (Type = ' + IntToStr(prmType) + ' Code : ' + IntToStr(prmCode) + ') paramètre inéxistant')
      else
        Result := DM_GSDataExport.Que_Generic_RecupData.FieldByName('prm_integer').AsInteger;
    finally
      DM_GSDataExport.Que_Generic_RecupData.Close();
    end;
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Rollback();
  except
    on e : exception do
    begin
      DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Rollback();
      FErreur := ' -> Exception : ' + e.ClassName + ' - ' + E.Message;
    end;
  end;
end;

function TBaseExport.Indeterminate(const Format: String;
  const Args: array of const): TBaseExportResult;
begin
  Exit( Indeterminate( SysUtils.Format( Format, Args ) ) );
end;

function TBaseExport.Indeterminate(const Reason: String): TBaseExportResult;
begin
  FErreur := Reason;
  Exit( Indeterminate );
end;

function TBaseExport.Indeterminate: TBaseExportResult;
begin
  Exit( TBaseExportResultRec.Indeterminate );
end;

function TBaseExport.Succeed(const Reason: String): TBaseExportResult;
begin
  FErreur := Reason;
  Exit( Succeed );
end;

function TBaseExport.Succeed: TBaseExportResult;
begin
  Exit( TBaseExportResultRec.Succeed );
end;

constructor TBaseExport.Create(MagCodAdh : string; LocMagId, GinMagId, HofId, FicId : integer; FilePath : string);
var
  BaseName : string;
begin
  inherited Create();

  FEtape := 'Création';
  FErreur := '';

  // init
  FLocMagId := LocMagId;
  FGinMagId := GinMagId;
  FHofID := HofId;
  FFicID := FicId;
  FLastNum := DM_GsDataDbCfg.GetLastNumFileMag(FLocMagId, FFicID) +1;
  FFilePath := IncludeTrailingPathDelimiter(FilePath);
  FMagCodAdh := MagCodAdh;
  try
    DM_GSDataExport.Que_InfoFichier.ParamByName('idfic').AsInteger := FicId;
    DM_GSDataExport.Que_InfoFichier.Open();
    BaseName := DM_GSDataExport.Que_InfoFichier.FieldByName('fic_nom').AsString;
    FProcName := DM_GSDataExport.Que_InfoFichier.FieldByName('fic_proc').AsString;
  finally
    DM_GSDataExport.Que_InfoFichier.Close();
  end;
  FLastDate := DM_GsDataDbCfg.GetDateLastTrtMag(FLocMagId, HofId);
  FFileName := StringReplace(StringReplace(BaseName, 'NNNNNN', Format('%.6d', [Max(FLastNum, 1)]), []), 'MMMM', FMagCodAdh, []);
end;

destructor TBaseExport.Destroy();
begin
  FEtape := 'Destruction';
  FErreur := '';

  inherited Destroy();
end;

function TBaseExport.Traitement(Manuel : boolean; Entete : boolean) : TBaseExportResult;
var
  iFTPSendErrorCount: Integer;
begin
  FEtape := 'Traitement';
  FErreur := '';

  Result := Indeterminate;

  if ( not Manuel ) and ( FLastDate = Trunc( Now ) ) then
  begin
    FFileName := 'Déjà traité';
    Exit( Succeed( 'Traitement -> Déjà traité' ) );
  end
  else begin
    // Gestion indépendante du log pour le FTP / SFTP:
    // L'indicateur sera ok si chacun des protocoles définis aura réussi.
    // Récupération du nombre d'envoi prévu d'après la configuration
    iFTPSendErrorCount := Integer( IniStruct.FTP.Actif ) + Integer( IniStruct.SFTP.Actif );

    // Si aucun des modes défini n'est activé => erreur
    if iFTPSendErrorCount = 0 then
      Exit( Error( 'Aucun mode d''envoi n''est actif' ) );

    Result := DoGenereFile( Entete );
    case Result of
      TBaseExportResultRec.Succeed: begin
        // Assertion: au moins l'un des modes d'envoi est actif...
        Log.Log( '', 'FTP', '', '', '', 'Status', 'Envoi...', logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
        {$REGION 'Gestion de l''envoi FTP'}
        try
          if IniStruct.FTP.Actif then
          begin
            DoSendFTP;
            // Envoi FTP réussi => décrément du nombre d'envoi restant
            Dec( iFTPSendErrorCount );
          end;
        except
          // Log de l'erreur "FTP"
          on E: Exception do
            Log.Log( '', 'FTP', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
        end;
        {$ENDREGION}
        {$REGION 'Gestion de l''envoi SFTP'}
        try
          if IniStruct.SFTP.Actif then
          begin
            DoSendSFTP;
            // Envoi FTP réussi => décrément du nombre d'envoi restant
            Dec( iFTPSendErrorCount );
          end;
        except
          // Log de l'erreur "SFTP"
          on E: Exception do
            Log.Log( '', 'FTP', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
        end;
        {$ENDREGION}

        // Si tous les envois actifs ont été effectué avec succés => ok
        // sinon, les erreurs ont été poussé auparavant
        if iFTPSendErrorCount = 0 then
          Log.Log( '', 'FTP', '', '', '', 'Status', 'Ok', logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

        // Si l'un des tests a échoué.. => erreur
        if not( ( iFTPSendErrorCount = 0 ) and DoMAJLastNum and DoValidate and
          ( Manuel or DoMAJLastTrt ) ) then
          Exit( TBaseExportResultRec.Error );
      end;
      TBaseExportResultRec.Warning:{Déjà traité} (*ne rien faire*);
      TBaseExportResultRec.Error:{Erreur rencontré} (*ne rien faire*);
      TBaseExportResultRec.Indeterminate:{Etat inconnu} (*ne rien faire*);
      else Exit( TBaseExportResultRec.Indeterminate );
    end;
  end;
end;

function TBaseExport.Warning(const Format: String;
  const Args: array of const): TBaseExportResult;
begin
  Exit( Warning( SysUtils.Format( Format, Args ) ) );
end;

function TBaseExport.Warning(const Reason: String): TBaseExportResult;
begin
  FErreur := Reason;
  Exit( Warning );
end;

function TBaseExport.Warning: TBaseExportResult;
begin
  Exit( TBaseExportResultRec.Warning );
end;

function TBaseExport.Succeed(const Format: String;
  const Args: array of const): TBaseExportResult;
begin
  Exit( Succeed( SysUtils.Format( Format, Args ) ) );
end;

{ TExportTest1 }

function TExportTest1.Traitement(Manuel : boolean; Entete : boolean) : TBaseExportResult;
begin
  Result := inherited Traitement(true, true);
end;

{ TExportTest2 }

function TExportTest2.Traitement(Manuel : boolean; Entete : boolean) : TBaseExportResult;
begin
  Result := inherited Traitement(true, true);
end;

{ TExportXICKET }

function TExportXICKET.DoGenereFile(Entete : boolean) : TBaseExportResult;
var
  i,j : integer;
  Ligne : string;
  Fichier : TStringList;

  slEntete ,              // Liste des entêtes        TRAN
  slTicket ,              // Liste des TKEID (necessaire pour les SP suivantes)
  slLignes ,              // Liste des lignes         VLOR
  slRegles ,              // Liste des règles         RGLM
  slInfos  ,              // Liste des informations   TIIN
  slReducs ,              // Liste des bons reduc     BRCA
  slUtilBRs: TStringList; // Liste des bons reduc     BRVL
  DateDuJour: string;
begin
  FEtape := 'Génération du fichier "' + FFileName + '"';
  Result := Error( SysUtils.EmptyStr );
  Ligne := '';

  try
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.StartTransaction();
    DM_GSDataExport.Que_Generic_RecupData.SQL.Text := 'select * from ' + FProcName + ' (:filename, :magginid);';
    DM_GSDataExport.Que_Generic_RecupData.ParamCheck := True;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('magginid').AsInteger := FGinMagId;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('filename').AsString  := FFileName;

    slEntete := TStringList.Create;
    slTicket := TStringList.Create;
    slLignes := TStringList.Create;
    slRegles := TStringList.Create;
    slInfos  := TStringList.Create;
    slReducs := TStringList.Create;
    slUtilBRs:= TStringList.Create();
    try
      DM_GSDataExport.Que_Generic_RecupData.Open();
      if not DM_GSDataExport.Que_Generic_RecupData.Eof then
      begin
        if not DirectoryExists(FFilePath) then
          ForceDirectories(FFilePath);
        Fichier := TStringList.Create;
        try
          // Récupération des entêtes
          while not DM_GSDataExport.Que_Generic_RecupData.Eof do
          begin
            Ligne := '';
            for i := 0 to DM_GSDataExport.Que_Generic_RecupData.Fields.Count -1 do
            begin
              Ligne := Ligne + DM_GSDataExport.Que_Generic_RecupData.Fields[i].AsString + '|';
              // Ajout du ticket s'il n'est pas déjà présent dans la stringlist
              if ( AnsiCompareText( 'ticket', DM_GSDataExport.Que_Generic_RecupData.Fields[i].FieldName ) = 0 ) and
                 ( slTicket.IndexOf( DM_GSDataExport.Que_Generic_RecupData.Fields[i].AsString ) < 0 ) then
              slTicket.Add( DM_GSDataExport.Que_Generic_RecupData.Fields[i].AsString );
            end;
            slEntete.Add( Ligne );
            DM_GSDataExport.Que_Generic_RecupData.Next();
          end;

          with DM_GSDataExport do
          begin
            {DONE -oJO-cExport :XICKET - Intégrer les lignes BRCA et BRVL (04/10/2013)}
            for i := 0 to slTicket.Count - 1 do
            begin (* Pour chaque ticket.*)
              QueryToStringList( Que_Generic_RecupData, 'select * from GOS_EXP_XICKET_LIGNES (:ticket);', [ slTicket[i] ], slLignes );
              QueryToStringList( Que_Generic_RecupData, 'select * from GOS_EXP_XICKET_RGLM   (:ticket);', [ slTicket[i] ], slRegles );
              QueryToStringList( Que_Generic_RecupData, 'select * from GOS_EXP_XICKET_INFOS  (:ticket);', [ slTicket[i] ], slInfos  );
              QueryToStringList( Que_Generic_RecupData, 'select * from GOS_EXP_XICKET_BRCA   (:ticket);', [ slTicket[i] ], slReducs );
              QueryToStringList( Que_Generic_RecupData, 'select * from GOS_EXP_XICKET_BRVL   (:ticket);', [ slTicket[i] ], slUtilBRs );
            end;
          end;

          // Ecriture du fichier
          DateTimeToString( DateDuJour, 'yyyymmdd', Now );
          fichier.Add(Format( 'AGNT|%s|GINKOIA|%s000001|%s235959|00.00|00.00|', [ FMagCodAdh, DateDuJour, DateDuJour ]));
          for i := 0 to slEntete.Count - 1 do
            fichier.Add(slEntete[i] );
          for i := 0 to slLignes.Count - 1 do
            fichier.Add(slLignes[i] );
          for i := 0 to slRegles.Count - 1 do
            fichier.Add(slRegles[i] );
          for i := 0 to slInfos .Count - 1 do
            fichier.Add(slInfos [i] );
          for i := 0 to slReducs.Count - 1 do
            fichier.Add(slReducs[i] );
          for i := 0 to slUtilBRs.Count - 1 do
            fichier.Add(slUtilBRs[i] );

          fichier.WriteBOM := False;
          fichier.SaveToFile(FFilePath + FFileName, TEncoding.UTF8);
        finally
          Fichier.Free;
        end;
        Result := Succeed;
      end
      else begin
        FFileName := PAS_DONNEES_EXPORT;
        Result := Warning( ' -> ' + PAS_DONNEES_EXPORT );
      end;
    finally
      DM_GSDataExport.Que_Generic_RecupData.Close();
      slEntete.Free;
      slTicket.Free;
      slLignes.Free;
      slRegles.Free;
      slInfos.Free;
      slReducs.Free;
      slUtilBRs.Free();
    end;
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Commit();
  except
    on e : exception do
    begin
      DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Rollback();
      Exit( Error( ' -> Exception : %s - %s', [ e.ClassName, e.Message ] ) );
    end;
  end;
end;

{ TExportGoS }

function TExportGoS.DoGenereFile(Entete: Boolean): TBaseExportResult;
const
  DELIMITEUR: Char = '|';
var
  i       : Integer;
  Ligne   : TStringList;
  Fichier : TTextWriter;
  Champ   : TField;
begin
  FEtape := Format('Génération du fichier "%s"', [FFileName]);
  Result := Error( SysUtils.EmptyStr );

  try
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.StartTransaction();
    DM_GSDataExport.Que_Generic_RecupData.SQL.Clear();
    DM_GSDataExport.Que_Generic_RecupData.SQL.Add('SELECT *');
    DM_GSDataExport.Que_Generic_RecupData.SQL.Add(Format('FROM %s(:MAGID, :LAST_VERSION, :CURRENT_VERSION)', [FProcName]));
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('MAGID').AsInteger            := FGinMagId;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('LAST_VERSION').AsInteger     := LastVersion;
    DM_GSDataExport.Que_Generic_RecupData.ParamByName('CURRENT_VERSION').AsInteger  := CurrentVersion;

    try
      DM_GSDataExport.Que_Generic_RecupData.Open();
      if not(DM_GSDataExport.Que_Generic_RecupData.IsEmpty) then
      begin
        if not(DirectoryExists(FFilePath)) then
          ForceDirectories(FFilePath);
        try
          Fichier               := TStreamWriter.Create(FFilePath + FFileName);
          Ligne                 := TStringList.Create();
          Ligne.Delimiter       := DELIMITEUR;
          Ligne.StrictDelimiter := True;

          // Gestion de l'en-tête
          if Entete then
          begin
            DM_GSDataExport.Que_Generic_RecupData.GetFieldNames(Ligne);
            Ligne.Delimiter       := DELIMITEUR;
            Ligne.StrictDelimiter := True;
            Fichier.Write(Ligne.DelimitedText);
          end;

          // Écriture des données
          DM_GSDataExport.Que_Generic_RecupData.First();
          while not(DM_GSDataExport.Que_Generic_RecupData.Eof) do
          begin
            Ligne.Clear();

            for Champ in DM_GSDataExport.Que_Generic_RecupData.Fields do
              Ligne.Add(StringReplace(Champ.Text, sLineBreak, ' ', [rfReplaceAll]));

            Fichier.WriteLine(Ligne.DelimitedText);

            DM_GSDataExport.Que_Generic_RecupData.Next();
          end;

          Result := Succeed;
        finally
          Ligne.Free();
          Fichier.Free();
        end;
      end
      else begin
        FFileName := PAS_DONNEES_EXPORT;
        Result := Warning( ' -> ' + PAS_DONNEES_EXPORT );
      end;
    finally
      DM_GSDataExport.Que_Generic_RecupData.Close();
    end;
    DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Commit();
    LastVersion := CurrentVersion;
  except
    on E: Exception do
    begin
      DM_GSDataExport.Que_Generic_RecupData.IB_Transaction.Rollback();
      Result := Error( ' -> Exception : %s - %s', [ E.ClassName, E.Message ] );
    end;
  end;
end;

function TExportGoS.DoMAJLastNum(): Boolean;
begin
inherited;
  Result := DM_GSDataExport.SetParamInteger(16, 23, FGinMagId, LastVersion);
end;

end.
