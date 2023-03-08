unit ExportBI_new_Dm;

interface

uses
  SysUtils,
  Classes,
  DB,
  IBCustomDataSet,
  IBQuery,
  wwDialog,
  wwidlg,
  wwLookupDialogRv,
  IBDatabase,
  dxmdaset,
  ZipMstr19,
  ComCtrls,
  StdCtrls,
  GestionEMail;

type
  TDm_ExportBI_new = class(TDataModule)
    DB_Config: TIBDatabase;
    IBT_Config: TIBTransaction;
    LK_Dossier: TwwLookupDialogRV;
    que_Dossiers: TIBQuery;

    DB_Ginkoia: TIBDatabase;
    IBT_Ginkoia: TIBTransaction;
    que_Magasins: TIBQuery;
    LK_Magasins: TwwLookupDialogRV;

    DB_Traitement: TIBDatabase;
    IBT_Traitement: TIBTransaction;
    que_InitiliseMag: TIBQuery;
    que_GetDateInit: TIBQuery;
    que_CreateParam: TIBQuery;
    que_Validation: TIBQuery;
    que_StockCalc: TIBQuery;
    que_StockPreTraite: TIBQuery;
    que_Mouvements: TIBQuery;

    MemD_Suivi: TdxMemData;
    MemD_SuiviCodMag: TStringField;
    MemD_SuiviDateTraite: TDateField;
    Zip_FicTrans: TZipMaster19;
    que_SetDateInit: TIBQuery;
    que_Correction: TIBQuery;
    DB_Correction: TIBDatabase;
    IBT_Correction: TIBTransaction;
    que_GetDateDernTrt: TIBQuery;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }

    // Date générique de validation
    FDateValide : TDate;
    // information FPT
    FServerFTP : string;
    FPortFTP : integer;
    FUserFTP : string;
    FPasswordFTP : string;
    FRepFTP : string;
    // information Mail
    FServerMail : string;
    FPortMail : integer;
    FUserMail : string;
    FPasswordMail : string;
    FSecuriteMail : SecuriteMail;
    FSenderMail : string;
    FDestMail : TStringList;

    // controls
    FProgress : TProgressbar;
    FState : TLabel;

    // memo
    FLogs : TMemo;

    // lecture/relecture du fichier de conf
    procedure ReadConf();

    // decryptage des password
    function DecryptPasswd(Value : string) : string;

    // selection
    function SelectDossier(out DossierPath, DossierGrp : string) : boolean;
    function SelectDossierMagasin(out DossierPath, DossierGrp, MagCodeAdh : string; out IdMag : integer) : boolean;
    // Barre de progression
    procedure InitProgress(AMessage: string; AMax: integer);
    procedure DoProgress(AMessage: String = '');
    procedure CloseProgress();
    // fichier de suivit
    function GetFTPFichierSuivit(FileName : string) : boolean;
    function FillDatasetSuivit(FileName : string) : boolean;
    // traitement effectif d'un magasin
    function DoInitUnMagasin(DossierPath, MagCodeAdh : string; IdMag : integer; UseJeton : boolean = false) : boolean;
    function DoTraiteUnMagasin(DossierPath, DossierGrp, MagCodeAdh : string; IdMag : integer; CalcStock, FTPSend : boolean; PathExp : string; UseJeton : boolean = false) : integer;
    function DoExportMvtsMagasin(AMagId: integer; ACodeAdh, APathDB, ACodeDossier, APathFics: String; tsResult: TStrings; AAvecEnvoiFTP, AEnInit: boolean) : integer;
  public
    { Déclarations publiques }

    // logs ??
    procedure DoLogAction(AMessage: STRING; ANiveau: integer);
    // init des controls
    procedure InitControl(Progress : TProgressbar; State : TLabel);

    // initialisation d'un magasin
    function InitialiseMagasin(UseJeton : boolean = false) : boolean;
    function InitialiseDossier(UseJeton : boolean = false) : boolean;
    // lancement des traitement
    function TraitementMagasin(CalcStock, FTPSend : boolean; UseJeton : boolean = false) : boolean;
    function TraitementDossier(CalcStock, FTPSend : boolean; UseJeton : boolean = false) : boolean;
    function TraitementComplet(CalcStock, FTPSend : boolean; UseJeton : boolean = false) : boolean;
    // Gestion de la correction temporelle d'un dossier
    function CorrigeDossier(DateTrt : TDate) : boolean;

    // envoi FTP
    procedure SendFileFTP(AFilePath: string);
  end;

implementation

{$R *.dfm}

uses
  Forms,
  IniFiles,
  UCommon,
  Dialogs,
  IdFTPCommon,
  IdFTP,
  windows,
  GestionJetonLaunch,
  uToolsXE,
  IdException,
  DateUtils;

{ TDm_ExportBI_new }

procedure TDm_ExportBI_new.DataModuleCreate(Sender: TObject);
begin
  // creation du log
  FLogs := TMemo.Create(Application.MainForm);
  FLogs.Parent := Application.MainForm;
  FLogs.Visible := false;
  // creation de la liste de destinataire
  FDestMail := TStringList.Create();
  FDestMail.Delimiter := ';';
  // lecture de la conf
  ReadConf();
  // On conserve 2 mois de log (arbitraire, voir pour rendre paramétrable ini ?)
  UCommon.PurgeOldLogs(True, 60);
end;

procedure TDm_ExportBI_new.DataModuleDestroy(Sender: TObject);
begin
  FProgress := nil;
  FState := nil;

  FreeAndNil(FLogs);
  FreeAndNil(FDestMail);
end;

// lecture du fichier de conf

procedure TDm_ExportBI_new.ReadConf();
var
  IniName : string;
  IniFile : TIniFile;
  NivLog : integer;
  FileDB : string;
begin
  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    IniFile := TIniFile.Create(IniName);
    // niveau de log
    NivLog := IniFile.ReadInteger('LOGS', 'NIVEAU', 0);
    // fichier database de conf
    FileDB := IniFile.ReadString('DATABASE', 'PATH', '');
    // infos ftp
    FServerFTP := IniFile.ReadString('FTP', 'URL', '');
    FPortFTP := IniFile.ReadInteger('FTP', 'PORT', 0);
    FUserFTP := IniFile.ReadString('FTP', 'USER', '');
    FPasswordFTP := IniFile.ReadString('FTP', 'PWD', '');
    FRepFTP := IniFile.ReadString('FTP', 'FOLDER', '');
    // infos mail
    FServerMail := IniFile.ReadString('MAIL', 'SERVER', '');
    FPortMail := IniFile.ReadInteger('MAIL', 'PORT', 0);
    FUserMail := IniFile.ReadString('MAIL', 'USER', '');
    FPasswordMail := IniFile.ReadString('MAIL', 'PWD', '');
    FSecuriteMail := SecuriteMail(IniFile.ReadInteger('MAIL', 'SECU', 0));
    FSenderMail := IniFile.ReadString('MAIL', 'SENDER', '');
    FDestMail.DelimitedText := IniFile.ReadString('MAIL', 'DEST', '');
  finally
    FreeAndNil(IniFile);
  end;

  // Init les logs (voir pr rendre paramétrable le niveau de log au besoin, pr l'instant les 5 premiers niveaux sont logés)
  UCommon.InitLogFileName(FLogs, Nil, NivLog, true);
  // init de la base de configuration
  if FileExists(FileDB) then
    DB_Config.DatabaseName := FileDB
  else
    Raise Exception.Create('Le fichier de la base de config (' + FileDB + ') n''éxiste pas !');
end;

function TDm_ExportBI_new.DecryptPasswd(Value : string) : string;
var
  i : integer;
begin
  Result := '';
  for i := (Length(Value) - 1) downto 1 do
    Result := Result + Value[i];
end;

// selection

function TDm_ExportBI_new.SelectDossier(out DossierPath, DossierGrp : string) : boolean;
var
  ErrMessage : string;
begin
  ErrMessage := '';
  Result := false;
  DossierPath := '';
  DossierGrp := '';

  LogAction('TDm_ExportBI_new.SelectDossier', 3);

  try
    try
      DB_Config.Open();
      if DB_Config.Connected then
      begin
        if LK_Dossier.Execute() then
        begin
          Result := true;
          DossierPath := que_Dossiers.FieldByName('DOS_BASEPATH').AsString;
          DossierGrp := que_Dossiers.FieldByName('DOS_CODEGROUPEBI').AsString;
        end;
      end
      else
      begin
        ErrMessage := 'Erreur de connexion a la base de config (' + DB_Config.DatabaseName + ') !';
        LogAction(ErrMessage);
        MessageDlg(ErrMessage, mtError, [mbOk], 0);
      end;
    finally
      DB_Config.Close();
    end;
  except
    on e : Exception do
    begin
      ErrMessage := 'Exception lors du traitement : ' + e.ClassName + ' - ' + e.Message;
      LogAction(ErrMessage);
      MessageDlg(ErrMessage, mtError, [mbOk], 0);
    end;
  end;
end;

function TDm_ExportBI_new.SelectDossierMagasin(out DossierPath, DossierGrp, MagCodeAdh : string; out IdMag : integer) : boolean;
var
  ErrMessage : string;
begin
  ErrMessage := '';
  Result := false;
  DossierPath := '';
  DossierGrp := '';
  MagCodeAdh := '';
  IdMag := 0;

  LogAction('TDm_ExportBI_new.SelectDossierMagasin', 3);

  try
    try
      DB_Config.Open();
      if DB_Config.Connected then
      begin
        if LK_Dossier.Execute() then
        begin
          try
            DB_Ginkoia.DatabaseName := que_Dossiers.FieldByName('DOS_BASEPATH').AsString;
            DB_Ginkoia.Open();
            if DB_Ginkoia.Connected then
            begin
              if LK_Magasins.Execute() then
              begin
                Result := true;
                DossierPath := que_Dossiers.FieldByName('DOS_BASEPATH').AsString;
                DossierGrp := que_Dossiers.FieldByName('DOS_CODEGROUPEBI').AsString;
                MagCodeAdh := que_Magasins.FieldByName('MAG_CODEADH').AsString;
                IdMag := que_Magasins.FieldByName('MAG_ID').AsInteger;
              end;
            end
            else
            begin
              ErrMessage := 'Erreur de connexion a la base de ginkoia (' + DB_Ginkoia.DatabaseName + ') !';
              LogAction(ErrMessage);
              MessageDlg(ErrMessage, mtError, [mbOk], 0);
            end;
          finally
            DB_Ginkoia.Close();
          end;
        end;
      end
      else
      begin
        ErrMessage := 'Erreur de connexion a la base de config (' + DB_Config.DatabaseName + ') !';
        LogAction(ErrMessage);
        MessageDlg(ErrMessage, mtError, [mbOk], 0);
      end;
    finally
      DB_Config.Close();
    end;
  except
    on e : Exception do
    begin
      ErrMessage := 'Exception lors du traitement : ' + e.ClassName + ' - ' + e.Message;
      LogAction(ErrMessage);
      MessageDlg(ErrMessage, mtError, [mbOk], 0);
    end;
  end;
end;

// Barre de progression

procedure TDm_ExportBI_new.InitProgress(AMessage: string; AMax: integer);
begin
  if Assigned(FProgress) then
  begin
    FProgress.Min := 0;
    FProgress.Max := AMax;
    FProgress.Position := 0;
    FProgress.Step := 1;
    FProgress.Visible := True;
  end;

  if Assigned(FState) then
  begin
    FState.Caption := AMessage;
    FState.Visible := True;
  end;

  Application.ProcessMessages();
end;

procedure TDm_ExportBI_new.DoProgress(AMessage: String = '');
begin
  if Assigned(FProgress) then
    FProgress.StepIt();
  if Assigned(FState) and (AMessage <> '') then
    FState.Caption := AMessage;
  Application.ProcessMessages();
end;

procedure TDm_ExportBI_new.CloseProgress();
begin
  if Assigned(FProgress) then
  begin
    FProgress.Min := 0;
    FProgress.Max := 1;
    FProgress.Position := 0;
    FProgress.Step := 1;
    FProgress.Visible := False;
  end;

  if Assigned(FState) then
  begin
    FState.Caption := '';
    FState.Visible := False;
  end;

  Application.ProcessMessages();
end;

// remplisage du dataset de suivit

function TDm_ExportBI_new.GetFTPFichierSuivit(FileName : string) : boolean;
var
  ftpSendFile : TIdFTP;
  FTPPasswd : string;
begin
  result := false;

  InitProgress('Récupération fichier suivi : connexion à ' + FServerFTP, 2);

  // Décryptage du password (on l'inverse juste et on ajoute un car pourri à la fin
  FTPPasswd := DecryptPasswd(FPasswordFTP);

  try
    ftpSendFile := TIdFTP.Create(Self);
    ftpSendFile.Host := FServerFTP;
    ftpSendFile.Port := FPortFTP;
    ftpSendFile.Username := FUserFTP;
    ftpSendFile.Password := FTPPasswd;
    ftpSendFile.TransferType := ftBinary;

    ftpSendFile.Connect();
    IF not ftpSendFile.Connected then
    begin
      LogAction('Erreur login FTP', 0);

      DoProgress();
      DoProgress();
    end
    else
    begin
      try
        ftpSendFile.Passive := True;
        if FRepFTP <> '' then
          ftpSendFile.ChangeDir(FRepFTP);

        DoProgress();

        ftpSendFile.Get('suivi_trans.csv', FileName, True, False);
        result := true;

        DoProgress();
      finally
        ftpSendFile.Disconnect();
      end;
    end;
  finally
    FreeAndNil(ftpSendFile);
  end;
end;

function TDm_ExportBI_new.FillDatasetSuivit(FileName : string) : boolean;
var
  tfSuivi : TextFile;
  sLigne : string;
  sCodeMag : string;    // Code du magasin
  dtDateTraite: TDateTime; // Date du dernier traitement
  sDateTraite : string;    // Pour conversion de la chaine en date
begin
  Result := false;

  MemD_Suivi.Close();
  MemD_Suivi.Open();

  if FileExists(FileName) then
  begin
    AssignFile(tfSuivi, FileName);
    try
      Reset(tfSuivi);

      while NOT Eof(tfSuivi) do
      begin
        Readln(tfSuivi, sLigne);
        if ((Trim(sLigne) <> '') and (sLigne[1] <> '#')) then
        begin
          if Copy(sLigne, 1, 5) = '99999' then
          begin
            // Donne la date du dernier traitement réussi
            sDateTraite := Copy(sLigne, 21, 2) + '/' + Copy(sLigne, 19, 2) + '/' + Copy(sLigne, 15, 4);
            FDateValide := StrToDate(sDateTraite);
          end
          else
          begin
            sCodeMag     := Copy(sLigne, 6, 9);
            sDateTraite  := Copy(sLigne, 21, 2) + '/' + Copy(sLigne, 19, 2) + '/' + Copy(sLigne, 15, 4);
            dtDateTraite := StrToDate(sDateTraite);

            // Insertion dans memdata
            MemD_Suivi.Append;
            MemD_SuiviCodMag.AsString       := sCodeMag;
            MemD_SuiviDateTraite.AsDateTime := dtDateTraite;
            MemD_Suivi.Post
          end;
        end;
      end;

      if FDateValide = trunc(Now()) then
        Result := true
      else
        Result := false;
    finally
      CloseFile(tfSuivi);
    end;
  end;
end;

// traitement effectif d'un magasin

function TDm_ExportBI_new.DoInitUnMagasin(DossierPath, MagCodeAdh : string; IdMag : integer; UseJeton : boolean = false) : boolean;
var
  {$REGION ' Gestion du jeton '}
  tpJeton : TTokenParams; // Record avec les paramètres pour les Jetons
  Token : TTokenManager;  // Classe de gestion du Jeton
  {$ENDREGION}
begin
  Result := false;
  Token := nil;

  try
    {$REGION ' Prise du jeton '}
    if UseJeton then
    begin
      tpJeton := GetParamsToken(DossierPath, 'ginkoia', 'ginkoia');
      Token := TTokenManager.Create();
      Token.tryGetToken(StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]), tpJeton.sDatabaseWS, tpJeton.sSenderWS, 20, 30000);
      if not Token.Acquired then // Jeton non acquis
      begin
        case Token.Reason of
          TOKEN_OK            : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Ok');
          TOKEN_OQP           : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Occupé');
          TOKEN_ERR_CNX       : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Erreur de connexion à la base');
          TOKEN_ERR_PRM       : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Erreur de paramètrage');
          TOKEN_ERR_HTTP      : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Erreur de connexion');
          TOKEN_ERR_INTERNAL  : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Erreur interne');
          TOKEN_ABORTED       : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Annulé');
          TOKEN_NEVER         : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : jamais demandé');
        end;
      end;
    end;
    {$ENDREGION}

    try
      InitProgress('Connexion à la base dossier :' + DossierPath, 1);

      try
        DB_Traitement.DatabaseName := DossierPath;
        DB_Traitement.Open();
        if DB_Traitement.Connected then
        begin
          try
            IBT_Traitement.StartTransaction();

            InitProgress('Init du magasin : ' + MagCodeAdh, 1);

            // initialisation proprement dite
            que_InitiliseMag.ParamByName('MAGID').AsInteger := IdMag;
            que_InitiliseMag.ExecSQL();

            // Creation du paramètre (s'il n'existe pas deja ...)
            que_CreateParam.ParamByName('MAGID').AsInteger   := IdMag;
            que_CreateParam.ParamByName('DATECOUR').AsString := '';
            que_CreateParam.ParamByName('INITIALIZED').AsInteger := 0;
            que_CreateParam.ExecSQL();

            DoProgress();

            IBT_Traitement.Commit();
            Result := true;
          except
            on e : Exception do
            begin
              IBT_Traitement.Rollback();
              Result := false;
              raise ExceptClass(e.ClassType).Create('Dossier : ' + DossierPath + #13#10
                                                  + 'Magasin : ' + MagCodeAdh + #13#10
                                                  + 'Récuperation de la date d''initialisation' + #13#10
                                                  + 'Exception : ' + e.ClassName + ' - ' + e.Message);
            end;
          end;
        end;
      finally
        DB_Traitement.Close();
      end;
    finally
      CloseProgress();
    end;
  finally
    {$REGION ' Liberation du jeton '}
    if Assigned(Token) then
      FreeAndNil(Token); // Libération du jeton
    {$ENDREGION}
  end;
end;

function TDm_ExportBI_new.DoTraiteUnMagasin(DossierPath, DossierGrp, MagCodeAdh : string; IdMag : integer; CalcStock, FTPSend : boolean; PathExp : string; UseJeton : boolean) : integer;
var
  IsInitMag, IsActivMag : boolean;
  DateDernTrt : TDate;
  DateValid : TDate;
  ResCalc : integer;
  Output : TStringList;
  {$REGION ' Gestion du jeton '}
  tpJeton : TTokenParams; // Record avec les paramètres pour les Jetons
  Token : TTokenManager;  // Classe de gestion du Jeton
  {$ENDREGION}
begin
  Result := -1;
  Token := nil;

  try
    {$REGION ' Prise du jeton '}
    if UseJeton then
    begin
      tpJeton := GetParamsToken(DossierPath, 'ginkoia', 'ginkoia');
      Token := TTokenManager.Create();
      Token.tryGetToken(StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]), tpJeton.sDatabaseWS, tpJeton.sSenderWS, 20, 30000);
      if not Token.Acquired then // Jeton non acquis
      begin
        case Token.Reason of
          TOKEN_OK            : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Ok');
          TOKEN_OQP           : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Occupé');
          TOKEN_ERR_CNX       : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Erreur de connexion à la base');
          TOKEN_ERR_PRM       : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Erreur de paramètrage');
          TOKEN_ERR_HTTP      : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Erreur de connexion');
          TOKEN_ERR_INTERNAL  : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Erreur interne');
          TOKEN_ABORTED       : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : Annulé');
          TOKEN_NEVER         : raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                                     + 'Magasin : ' + MagCodeAdh + #13#10
                                                     + 'Gestion du jeton - Echec de l''obtention du Jeton : jamais demandé');
        end;
      end;
    end;
    {$ENDREGION}

    try
      InitProgress('Connexion à la base dossier :' + DossierPath, 1);
      try
        DB_Traitement.DatabaseName := DossierPath;
        DB_Traitement.Open();
        if DB_Traitement.Connected then
        begin
          InitProgress('Traitement du magasin :' + MagCodeAdh, 1);

          // Recuperation de la date de dernier traitement
          try
            IBT_Traitement.StartTransaction();
            try
              que_GetDateDernTrt.ParamByName('MAGID').AsInteger := IdMag;
              que_GetDateDernTrt.Open();
              if que_GetDateDernTrt.Eof then
                DateDernTrt := 0 // pas de date ??
              else
                DateDernTrt := que_GetDateDernTrt.FieldByName('datederntrt').AsDateTime;
            finally
              que_GetDateDernTrt.Close();
            end;
            IBT_Traitement.Commit();
          except
            on e : Exception do
            begin
              Result := -2;
              IBT_Traitement.Rollback();
              raise ExceptClass(e.ClassType).Create('Dossier : ' + DossierPath + #13#10
                                                  + 'Magasin : ' + MagCodeAdh + #13#10
                                                  + 'Récuperation de la date de dernier traitement' + #13#10
                                                  + 'Exception : ' + e.ClassName + ' - ' + e.Message);
            end;
          end;

          // Date de validation
          // contenue dans le fichier de suivit
          if MemD_Suivi.Locate('CodMag', MagCodeAdh, []) then
            DateValid := MemD_SuiviDateTraite.AsDateTime
          else
            DateValid := FDateValide;

          // Comparaison date de validation/date de dernier traitement !!
          if DateValid <= DateDernTrt then
          begin
            Result := -42;
            raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                 + 'Magasin : ' + MagCodeAdh + #13#10
                                 + 'Date de validation du fichier de suivit invalide !');
          end;

          // recup du flag d'init
          try
            IBT_Traitement.StartTransaction();
            try
              que_GetDateInit.ParamByName('MAGID').AsInteger := IdMag;
              que_GetDateInit.Open();
              if que_GetDateInit.Eof then
              begin
                IsActivMag := false;
                IsInitMag := true // forcement une init, pas d'enreg !
              end
              else
              begin
                IsActivMag := que_GetDateInit.FieldByName('PRM_FLOAT').AsInteger = 0;
                IsInitMag := que_GetDateInit.FieldByName('PRM_INTEGER').AsInteger = 0;
              end;
            finally
              que_GetDateInit.Close();
            end;
            IBT_Traitement.Commit();
          except
            on e : Exception do
            begin
              Result := -2;
              IBT_Traitement.Rollback();
              raise ExceptClass(e.ClassType).Create('Dossier : ' + DossierPath + #13#10
                                                  + 'Magasin : ' + MagCodeAdh + #13#10
                                                  + 'Récuperation de la date d''initialisation' + #13#10
                                                  + 'Exception : ' + e.ClassName + ' - ' + e.Message);
            end;
          end;

          // Comparaison date de validation/date de dernier traitement !!
          if not IsActivMag then
          begin
            Result := -42;
            raise Exception.Create('Dossier : ' + DossierPath + #13#10
                                 + 'Magasin : ' + MagCodeAdh + #13#10
                                 + 'Magasin desactivé...');
          end;

          // Calcul du stock
          if CalcStock then
          begin
            try
              IBT_Traitement.StartTransaction();
              que_StockPreTraite.ExecSQL();
              ResCalc := 1;
              while ResCalc = 1 do
              begin
                que_StockCalc.Open();
                ResCalc := que_StockCalc.FieldByName('RETOUR').AsInteger;
                que_StockCalc.Close();
              end;
              IBT_Traitement.Commit();
            except
              on e : Exception do
              begin
                Result := -4;
                IBT_Traitement.Rollback();
                raise ExceptClass(e.ClassType).Create('Dossier : ' + DossierPath + #13#10
                                                    + 'Magasin : ' + MagCodeAdh + #13#10
                                                    + 'Calcul du stock' + #13#10
                                                    + 'Exception : ' + e.ClassName + ' - ' + e.Message);
              end;
            end;
          end;

          // exports
          try
            IBT_Traitement.StartTransaction();
            try
              Output := TStringList.Create();
              // generation de l'export
              Result := DoExportMvtsMagasin(IdMag,
                                            MagCodeAdh,
                                            DossierPath,
                                            DossierGrp,
                                            PathExp,
                                            Output,
                                            FTPSend,
                                            IsInitMag);
            finally
              FreeAndNil(Output);
            end;
            IBT_Traitement.Commit();
          except
            on e : Exception do
            begin
              Result := -5;
              IBT_Traitement.Rollback();
              raise ExceptClass(e.ClassType).Create('Dossier : ' + DossierPath + #13#10
                                                  + 'Magasin : ' + MagCodeAdh + #13#10
                                                  + 'Creation du fichier d''export' + #13#10
                                                  + 'Exception : ' + e.ClassName + ' - ' + e.Message);
            end;
          end;

          // validation
          try
            IBT_Traitement.StartTransaction();
            que_Validation.ParamByName('DATEVALIDE').AsDateTime := Trunc(IncDay(Now()));
            que_Validation.ParamByName('MAGCODE').AsString := MagCodeAdh;
            que_Validation.ExecSQL();
            IBT_Traitement.Commit();
          except
            on e : Exception do
            begin
              Result := -3;
              IBT_Traitement.Rollback();
              raise ExceptClass(e.ClassType).Create('Dossier : ' + DossierPath + #13#10
                                                  + 'Magasin : ' + MagCodeAdh + #13#10
                                                  + 'Validation' + #13#10
                                                  + 'Exception : ' + e.ClassName + ' - ' + e.Message);
            end;
          end;
        end;
      finally
        DB_Traitement.Close();
      end;
    finally
      CloseProgress();
    end;
  finally
    {$REGION ' Liberation du jeton '}
    if Assigned(Token) then
      FreeAndNil(Token); // Libération du jeton
    {$ENDREGION}
  end;
end;

function TDm_ExportBI_new.DoExportMvtsMagasin(AMagId: integer; ACodeAdh, APathDB, ACodeDossier, APathFics: String; tsResult: TStrings; AAvecEnvoiFTP, AEnInit: boolean) : integer;

  function Complete(ANbCar: integer; AValue: string; ACar: char = ' '): string;
  begin
    if Length(AValue) >= ANbCar then
    begin
      Result := Copy(AValue, 1, ANbCar);
    end
    else begin
      Result := AValue;
      while Length(Result) < ANbCar do
      begin
        Result := Result + ACar;
      end;
    end;
  end;

  function LComplete(ANbCar: integer; AValue: string; ACar: char = ' '): string;
  begin
    if Length(AValue) >= ANbCar then
    begin
      Result := Copy(AValue, 1, ANbCar);
    end
    else begin
      Result := AValue;
      while Length(Result) < ANbCar do
      begin
        Result := ACar + Result;
      end;
    end;
  end;

var
  sLigne         : string;
  sMagCour       : string;    // Code mag en cours

  sTicket        : string;

  sPathFicMvt    : string;    // Chemin vers le fichier mouvement à zipper
  sPathFicMvtSvg : string;    // Chemin vers le fichier mouvement à sauvegarder
  sPathFicSuiv   : string;    // Chemin vers le fichier suivi à zipper
  sPathFicSuivSvg: string;    // Chemin vers le fichier suivi à sauvegarder
  sZipFicName    : string;    // Nom du fichier Zip à envoyer

  dtMvtDateMin   : TDateTime; // Date du mouvement le plus ancien
  dtMvtDateMax   : TDateTime; // Date du mouvement le plus récent
  dtDateMax      : TDateTime; // Date d'extraction
  dtDateLast     : TDateTime; // Date de derniere intégration

//  iNbLigne       : integer;   // Nombre de lignes dans le fichier

  sStock         : string;    // Variabl de stockage du stock en string

  txtFicDest     : TextFile;  // Variable Fichier pour le fichier de sortie
begin
  Result := 0;
  InitProgress('Préparation des données par le serveur', 1);

  try
    que_Mouvements.ParamByName('CODEADH').AsString := ACodeAdh;
    que_Mouvements.Open();
    DoProgress();
    InitProgress('Traitement des données magasin', que_Mouvements.RecordCount);

    // Pas d'Entete
    if not que_Mouvements.Eof then
    begin
      sMagCour := que_Mouvements.FieldByName('CODMAG').AsString;
      sStock := LComplete(8, que_Mouvements.FieldByName('STOCKCOUR').AsString, '0');

      DoProgress('Traitement des données de ' + sMagCour);

      // Si avant 6h
      IF Frac(Now) < 0.25 THEN
        dtDateMax := Trunc(Now) - 1
      else
        dtDateMax := Trunc(Now);

      sPathFicMvt := APathFics + 'trans.csv';
      sPathFicMvtSvg := APathFics + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + StringReplace(sMagCour, '/', '_', [rfReplaceAll]) + '.trans.csv';

      try
        AssignFile(txtFicDest, sPathFicMvt);
        Rewrite(txtFicDest);

        dtMvtDateMin := que_Mouvements.FieldByName('DATEVAL').AsDateTime;
        dtMvtDateMax := que_Mouvements.FieldByName('DATEVAL').AsDateTime;
        while (not que_Mouvements.Eof) and (sMagCour = que_Mouvements.FieldByName('CODMAG').AsString) do
        begin
          // Un fichier par magasin
          sTicket := que_Mouvements.FieldByName('CODMAG').AsString
                   + FormatDateTime('HHMM', que_Mouvements.FieldByName('DATEVAL').AsDateTime)
                   + que_Mouvements.FieldByName('IDENTETE').AsString;

          sLigne := Complete(10, que_Mouvements.FieldByName('CODMAG').AsString) + ';'                                        // A    // 0
                  + Complete(36, sTicket) + ';'                                                          // Ticket           // B    // 1
                  + Complete(1, que_Mouvements.FieldByName('TRATYPE').AsString) + ';'                    // Type             // C    // 2
                  + Complete(1, 'N') + ';'                                                               // Service          // D    // 3
                  + Complete(3, 'GIN') + ';'                                                             // PROV             // E    // 4
                  + FormatDateTime('YYYYMMDD', que_Mouvements.FieldByName('DATEVAL').AsDateTime) + ';'   // Dateval          // F    // 5
                  + Complete(10, que_Mouvements.FieldByName('ARTCOL').AsString) + ';'                    // Col              // G    // 6
                  + Complete(20, que_Mouvements.FieldByName('ARTREFMRK').AsString) + ';'                 // Code modele      // H    // 7
                  + Complete(30, que_Mouvements.FieldByName('ARTNOM').AsString) + ';'                    // Lib modèle       // I    // 8
                  + Complete(20, que_Mouvements.FieldByName('ARTREFMRK').AsString) + ';'                 // Modèle fourn     // J    // 9
                  + Complete(3, que_Mouvements.FieldByName('COUCODE').AsString) + ';'                    // Code coul        // K    // 10
                  + Complete(30, que_Mouvements.FieldByName('COUNOM').AsString) + ';'                    // Lib coul         // L    // 11
                  + Complete(5, que_Mouvements.FieldByName('TGFNOM').AsString) + ';'                     // Taille Frn       // M    // 12
                  + Complete(5, '') + ';'                                                                // Index taille     // N    // 13
                  + Complete(5, que_Mouvements.FieldByName('TGSNOM').AsString) + ';'                     // Taille ref FR    // O    // 14
                  + Complete(15, que_Mouvements.FieldByName('SKU').AsString) + ';'                       // SKU              // P    // 15
                  + Complete(15, '') + ';'                                                               // Colis            // Q    // 16
                  + Complete(10, '') + ';'                                                               // Code fou         // R    // 17
                  + Complete(30, '') + ';'                                                               // Lib Fou          // S    // 18
                  + Complete(3, que_Mouvements.FieldByName('MRKCODE').AsString) + ';'                    // Code Mrk         // T    // 19
                  + Complete(30, que_Mouvements.FieldByName('MRKNOM').AsString) + ';'                    // Lib Mrk          // U    // 20
                  + Complete(6, que_Mouvements.FieldByName('ARTFEDAS').AsString) + ';'                   // Fedas            // V    // 21
                  + Complete(20, que_Mouvements.FieldByName('ARTCHRONO').AsString) + ';'                 // CategM           // W    // 22
                  + Complete(5, '') + ';'                                                                // Typpo            // X    // 23
                  + Complete(1, que_Mouvements.FieldByName('TDSC').AsString) + ';'                       // TDSC             // Y    // 24
                  + Complete(1, '') + ';'                                                                // Referencement    // Z    // 25
                  + Complete(8, que_Mouvements.FieldByName('QTETRANS').AsString) + ';'                                             // Qté              // AA   // 26
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPABHT').AsString, ',', '.', [rfReplaceAll])) + ';'  // PxAB             // AB   // 27
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPANHT').AsString, ',', '.', [rfReplaceAll])) + ';'  // PxAN             // AC   // 28
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPVBTTC').AsString, ',', '.', [rfReplaceAll])) + ';' // PxVB             // AD   // 29
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPVNTTC').AsString, ',', '.', [rfReplaceAll])) + ';' // PxVN             // AE   // 30
                  + LComplete(10, StringReplace(que_Mouvements.FieldByName('MVTPMP').AsString, ',', '.', [rfReplaceAll])) + ';'    // Pump             // AF   // 31
                  + LComplete(5, StringReplace(que_Mouvements.FieldByName('MVTTVA').AsString, ',', '.', [rfReplaceAll])) + ';'     // Tva              // AG   // 32
                  + Complete(3, 'EUR') + ';'                                                             // DEV              // AH   // 33
                  + Complete(6, '') + ';'                                                                // Surf tot         // AI   // 34
                  + Complete(6, '') + ';'                                                                // Surf vte         // AJ   // 35
                  + Complete(6, '') + ';'                                                                // Surf res         // AK   // 36
                  + LComplete(5, ACodeDossier) + ';'                                                     // Grp mag          // AL   // 37
                  + Complete(10, '') + ';'                                                               // Code mag Princ   // AM   // 38
                  + Complete(1, que_Mouvements.FieldByName('ARTTYPE').AsString) + ';'                    // Libre 1 (origine)// AN   // 39
                  + Complete(1, '') + ';'                                                                // Libre 2          // AO   // 40
                  + Complete(10, '') + ';'                                                               // Libre 3          // AP   // 41
                  + Complete(10, '') + ';'                                                               // Libre 4          // AQ   // 42
                  + Complete(1, '') + ';'                                                                // Statut           // AR   // 43
                  + FormatDateTime('YYYYMMDD', que_Mouvements.FieldByName('DATEVAL').AsDateTime) + ';'   // Date_trans       // AS   // 44
                  + FormatDateTime('YYYYMMDD', Now) + ';'                                                // Date remontée    // AT   // 45
                  + Complete(1, '') + ';'                                                                // Flag Trt         // AU   // 46
                  + Complete(8, '') + ';'                                                                // Date Trt         // AV   // 47
                  + LComplete(8, que_Mouvements.FieldByName('QTETRANS').AsString) + ';'                  // Qte BW           // AW   // 48
                  + Complete(8, '') + ';'                                                                // Date BW          // AY   // 49
                  + Complete(1, que_Mouvements.FieldByName('FLAG').AsString) + ';'                       // Flag             // AZ   // 50
                  + Complete(15, '') + ';';                                                              // Numéro carte fid         // 51

          Inc(Result);

          WriteLn(txtFicDest, sLigne);

          // Sauvegarde des date en cas d'init
          if AEnInit then
          begin
            if que_Mouvements.FieldByName('DATEVAL').AsDateTime < dtMvtDateMin then
              dtMvtDateMin := que_Mouvements.FieldByName('DATEVAL').AsDateTime;
            if que_Mouvements.FieldByName('DATEVAL').AsDateTime > dtMvtDateMax then
              dtMvtDateMax := que_Mouvements.FieldByName('DATEVAL').AsDateTime;
          end;

          DoProgress();

          que_Mouvements.Next();
        end;
      finally
        CloseFile(txtFicDest);
      end;

      tsResult.Clear;

      if AEnInit then
      begin
        tsResult.Add('[Groupe]=' + ACodeDossier);
        tsResult.Add('[ad_IP]=127.0.0.1');
        tsResult.Add('[Mag_P]=' + sMagCour);
        tsResult.Add('[debut_histo]=' + FormatDateTime('YYYYMMDD', dtMvtDateMin));
        tsResult.Add('[fin_histo]=' + FormatDateTime('YYYYMMDD', dtMvtDateMax));
        tsResult.Add('[Version]=BI_V2');
        tsResult.Add('[Nbr_ligne]=' + IntToStr(Result));
        tsResult.Add('[Magasin]=' + sMagCour);

        // Creation du paramètre (s'il n'existe pas deja ...)
        que_CreateParam.ParamByName('MAGID').AsInteger   := AMagId;
        que_CreateParam.ParamByName('DATECOUR').AsString := FormatDateTime('DD/MM/YYYY', Trunc(Now));
        que_CreateParam.ParamByName('INITIALIZED').AsInteger := 1;
        que_CreateParam.ExecSQL();

        // Mettre à jour le genparam
        que_SetDateInit.ParamByName('MAGID').AsInteger   := AMagId;
        que_SetDateInit.ParamByName('DATECOUR').AsString := FormatDateTime('DD/MM/YYYY', Trunc(Now));
        que_SetDateInit.ExecSQL();
      end
      else
      begin
        // Recherche dans le Controle de validation
        IF MemD_Suivi.Locate('CodMag', sMagCour, []) THEN
        begin
          // Erreur, on garde cette date
          dtDateLast := MemD_SuiviDateTraite.AsDateTime;
        end
        else
        begin
          // Pas d'erreur, on prend la date de 99999
          dtDateLast := FDateValide;
        end;

        tsResult.Add('[Groupe]=' + ACodeDossier);
        tsResult.Add('[ad_IP]=127.0.0.1');
        tsResult.Add('[Mag_P]=' + sMagCour);
        tsResult.Add('[Version]=BI_V2.1');
        tsResult.Add('[Date_suivi]=' + FormatDateTime('YYYYMMDD', dtDateLast));
        tsResult.Add('[Date_debut_extraction]=' + FormatDateTime('YYYYMMDD', dtDateLast));
        tsResult.Add('[Date_max_extraction]=' + FormatDateTime('YYYYMMDD', dtDateMax));
        tsResult.Add('[Type_connexion]=2');
        tsResult.Add('[Nbr_ligne]=' + IntToStr(Result));
        tsResult.Add('[comparaison]=' + sMagCour + ';' + sStock + ';' + sStock + ';000');
        tsResult.Add('[Magasin]=' + sMagCour);
      end;

      sPathFicSuiv := APathFics + 'trans_suivi.csv';
      sPathFicSuivSvg := APathFics + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + StringReplace(sMagCour, '/', '_', [rfReplaceAll]) + '.trans_suivi.csv';
      tsResult.SaveToFile(sPathFicSuiv);

      // Zipper les fichiers
      sZipFicName := APathFics + 'Trans_' + StringReplace(sMagCour, '/', '_', [rfReplaceAll]) + '_' + ACodeDossier + '.zip';
      Zip_FicTrans.ZipFileName := sZipFicName;
      Zip_FicTrans.FSpecArgs.Add(sPathFicMvt);
      Zip_FicTrans.FSpecArgs.Add(sPathFicSuiv);
      Zip_FicTrans.Add();

      RenameFile(sPathFicSuiv, sPathFicSuivSvg);
      RenameFile(sPathFicMvt, sPathFicMvtSvg);

      // Todo : Voir s'il est judicieux de faire un envoi FTP dans un second temps de tous les fichiers
      if AAvecEnvoiFTP then
        SendFileFTP(sZipFicName);
    end;
  finally
    que_Mouvements.Close();
  end;
end;

procedure TDm_ExportBI_new.SendFileFTP(AFilePath: string);
var
  ftpSendFile : TIdFTP;
  FTPPasswd : string;
  sFicTstFTP : string;
  tsFicTstFTP : TStringList;
begin
  if NOT FileExists(AFilePath) then
  begin
    LogAction('Fichier inexistant : ' + AFilePath, 0);
    EXIT;
  end;

  // Décryptage du password (on l'inverse juste et on ajoute un car pourri à la fin
  FTPPasswd := DecryptPasswd(FPasswordFTP);

  try
    ftpSendFile := TIdFTP.Create(Self);
    ftpSendFile.Host := FServerFTP;
    ftpSendFile.Port := FPortFTP;
    ftpSendFile.Username := FUserFTP;
    ftpSendFile.Password := FTPPasswd;
    ftpSendFile.TransferType := ftBinary;

    ftpSendFile.Connect();
    IF not ftpSendFile.Connected then
    begin
      LogAction('Erreur login FTP', 0);
    end
    else
    begin
      try
        // Ajout d'un fichier texte avec juste 1 dedans
        try
          tsFicTstFTP := TStringList.Create();
          tsFicTstFTP.Text := '1';
          sFicTstFTP := ChangeFileExt(AFilePath, '.txt');
          tsFicTstFTP.SaveToFile(sFicTstFTP);
        Finally
          FreeAndNil(tsFicTstFTP);
        End;

        ftpSendFile.Passive := True;
        if FRepFTP <> '' then
          ftpSendFile.ChangeDir(FRepFTP);

        ftpSendFile.Put(AFilePath);
        ftpSendFile.Put(sFicTstFTP);
      finally
        try
          ftpSendFile.Disconnect();
        except
          on e : EIdConnClosedGracefully do
            ;
          on e : Exception do
            Raise;
        end;
      end;
    end;
  finally
    FreeAndNil(ftpSendFile);
  end;
end;

// logs ??

procedure TDm_ExportBI_new.DoLogAction(AMessage: STRING; ANiveau: integer);
begin
  LogAction(AMessage, ANiveau);
end;

procedure TDm_ExportBI_new.InitControl(Progress : TProgressbar; State : TLabel);
begin
  FProgress := Progress;
  FState := State;
end;

// initialisation

function TDm_ExportBI_new.InitialiseMagasin(UseJeton : boolean) : boolean;
var
  DossierPath, DossierGrp, MagCodeAdh : string;
  IdMag : integer;
begin
  Result := false;

  if SelectDossierMagasin(DossierPath, DossierGrp, MagCodeAdh, IdMag) then
    Result := DoInitUnMagasin(DossierPath, MagCodeAdh, IdMag, UseJeton);

end;

function TDm_ExportBI_new.InitialiseDossier(UseJeton : boolean) : boolean;
var
  DossierPath, DossierGrp : string;
  ResMag : boolean;
begin
  Result := false;

  if SelectDossier(DossierPath, DossierGrp) then
  begin
    try
      DB_Ginkoia.DatabaseName := DossierPath;
      DB_Ginkoia.Open();
      if DB_Ginkoia.Connected then
      begin
        Result := true;
        DoProgress();
        try
          que_Magasins.Open();
          while not que_Magasins.Eof do
          begin
            ResMag := DoInitUnMagasin(DossierPath,
                                      que_Magasins.FieldByName('MAG_CODEADH').AsString,
                                      que_Magasins.FieldByName('MAG_ID').AsInteger,
                                      UseJeton);
            Result := Result and ResMag;
            que_Magasins.Next();
          end;
        finally
          que_Magasins.Close();
        end;
      end;
    finally
      DB_Ginkoia.Close();
    end;
  end;
end;

// lancement des traitements

function TDm_ExportBI_new.TraitementMagasin(CalcStock, FTPSend : boolean; UseJeton : boolean) : boolean;
var
  DossierPath, DossierGrp, MagCodeAdh : string;
  PathExp, FileSuiv : string;
  IdMag : integer;
begin
  Result := false;

  // repertoir de destination
  PathExp := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Extract\' + FormatDateTime('YYYY\MM\DD\', Now);
  ForceDirectories(PathExp);
  // gestion du suivit
  FileSuiv := PathExp + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + 'suivi_trans.csv';
  if GetFTPFichierSuivit(FileSuiv) then
  begin
    if FillDatasetSuivit(FileSuiv) then
    begin
      if SelectDossierMagasin(DossierPath, DossierGrp, MagCodeAdh, IdMag) then
        Result := DoTraiteUnMagasin(DossierPath, DossierGrp, MagCodeAdh, IdMag, CalcStock, FTPSend, PathExp, UseJeton) >= 0;
    end
    else if not (FDateValide = trunc(Now())) then
      raise Exception.Create('Mauvaise date dans le fichier de suivit : ' + FormatDateTime('yyyymmdd', FDateValide) + ' pour ' + FormatDateTime('yyyymmdd', Now()) + ' attendu')
    else
      raise Exception.Create('Fichier de suivit non traité !');
  end
  else
    raise Exception.Create('Fichier de suivit non trouvé !');
end;

function TDm_ExportBI_new.TraitementDossier(CalcStock, FTPSend : boolean; UseJeton : boolean) : boolean;
var
  DossierPath, DossierGrp : string;
  PathExp, FileSuiv : string;
  ResMag : boolean;
begin
  Result := false;

  // repertoir de destination
  PathExp := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Extract\' + FormatDateTime('YYYY\MM\DD\', Now);
  ForceDirectories(PathExp);
  // gestion du suivit
  FileSuiv := PathExp + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + 'suivi_trans.csv';
  if GetFTPFichierSuivit(FileSuiv) then
  begin
    if FillDatasetSuivit(FileSuiv) then
    begin
      if SelectDossier(DossierPath, DossierGrp) then
      begin
        try
          DB_Ginkoia.DatabaseName := DossierPath;
          DB_Ginkoia.Open();
          if DB_Ginkoia.Connected then
          begin
            Result := true;
            DoProgress();
            try
              que_Magasins.Open();
              while not que_Magasins.Eof do
              begin
                ResMag := DoTraiteUnMagasin(DossierPath,
                                            DossierGrp,
                                            que_Magasins.FieldByName('MAG_CODEADH').AsString,
                                            que_Magasins.FieldByName('MAG_ID').AsInteger,
                                            CalcStock, FTPSend, PathExp, UseJeton) >= 0;
                Result := Result and ResMag;
                que_Magasins.Next();
              end;
            finally
              que_Magasins.Close();
            end;
          end;
        finally
          DB_Ginkoia.Close();
        end;
      end;
    end
    else if not (FDateValide = trunc(Now())) then
      raise Exception.Create('Mauvaise date dans le fichier de suivit : ' + FormatDateTime('yyyymmdd', FDateValide) + ' pour ' + FormatDateTime('yyyymmdd', Now()) + ' attendu')
    else
      raise Exception.Create('Fichier de suivit non traité !');
  end
  else
    raise Exception.Create('Fichier de suivit non trouvé !');
end;

function TDm_ExportBI_new.TraitementComplet(CalcStock, FTPSend : boolean; UseJeton : boolean) : boolean;
var
  PathExp, FileSuiv : string;
  ResMag : integer;
begin
  Result := false;

  try
    // repertoir de destination
    PathExp := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Extract\' + FormatDateTime('YYYY\MM\DD\', Now);
    ForceDirectories(PathExp);
    // gestion du suivit
    FileSuiv := PathExp + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + 'suivi_trans.csv';
    DoLogAction('Téléchargement du fichier de suivit', 2);
    if GetFTPFichierSuivit(FileSuiv) then
    begin
      DoLogAction('Traitement du fichier de suivit', 2);
      if FillDatasetSuivit(FileSuiv) then
      begin
        try
          DB_Config.Open();
          if DB_Config.Connected then
          begin
            Result := true;
            try
              que_Dossiers.Open();
              while not que_Dossiers.Eof do
              begin
                DoLogAction('Traitement du dossier ' + que_Dossiers.FieldByName('DOS_CODEGROUPEBI').AsString + ' - ' + que_Dossiers.FieldByName('DOS_NOM').AsString, 2);
                if que_Dossiers.FieldByName('DOS_ACTIFBI').AsInteger = 1 then
                begin

                  // TODO -obpy : Recalcul de stock !

                  try
                    try
                      DB_Ginkoia.DatabaseName := que_Dossiers.FieldByName('DOS_BASEPATH').AsString;
                      DB_Ginkoia.Open();
                      if DB_Ginkoia.Connected then
                      begin
                        DoProgress();
                        try
                          que_Magasins.Open();
                          while not que_Magasins.Eof do
                          begin
                            DoLogAction('  Traitement du magasin ' + que_Magasins.FieldByName('MAG_CODEADH').AsString + ' - ' + que_Magasins.FieldByName('MAG_ENSEIGNE').AsString, 2);
                            if que_Magasins.FieldByName('PRM_FLOAT').AsInteger = 1 then
                            begin
                              ResMag := -6;
                              try
                                ResMag := DoTraiteUnMagasin(que_Dossiers.FieldByName('DOS_BASEPATH').AsString,
                                                            que_Dossiers.FieldByName('DOS_CODEGROUPEBI').AsString,
                                                            que_Magasins.FieldByName('MAG_CODEADH').AsString,
                                                            que_Magasins.FieldByName('MAG_ID').AsInteger,
                                                            CalcStock, FTPSend, PathExp, UseJeton);
                                Result := Result and (ResMag >= 0);
                              except
                                on e: Exception do
                                begin
                                  ResMag := -7;
                                  Result := false;
                                  LogAction(e.Message);
                                end;
                              end;
                              if ResMag >= 0 then
                                DoLogAction('    -> Reussite (' + IntToStr(ResMag) + ' lignes)', 2)
                              else
                                DoLogAction('    -> Echec (code ' + IntToStr(ResMag) + ')', 2);
                            end
                            else
                              DoLogAction('    -> inactif', 2);
                            que_Magasins.Next();
                          end;
                        finally
                          que_Magasins.Close();
                        end;
                      end;
                    finally
                      DB_Ginkoia.Close();
                    end;
                  except
                    on e: Exception do
                    begin
                      Result := false;
                      LogAction('Dossier : ' + que_Dossiers.FieldByName('DOS_BASEPATH').AsString + #13#10 +
                                'Exception : ' + e.ClassName + ' - ' + e.Message);
                    end;
                  end;
                end
                else
                  DoLogAction('    -> inactif', 2);
                que_Dossiers.Next;
              end;
            finally
              que_Dossiers.Close();
            end;
          end;
        finally
          DB_Config.Close();
        end;
      end
      else if not (FDateValide = trunc(Now())) then
        LogAction('Mauvaise date dans le fichier de suivit : ' + FormatDateTime('yyyymmdd', FDateValide) + ' pour ' + FormatDateTime('yyyymmdd', Now()) + ' attendu')
      else
        LogAction('Fichier de suivit non traité !');
    end
    else
      LogAction('Fichier de suivit non trouvé !');
  except
    on e: Exception do
    begin
      Result := false;
      LogAction('Exception : ' + e.ClassName + ' - ' + e.Message);
    end;
  end;

  if result then
    SendMail(FServerMail, FPortMail, FUserMail, DecryptPasswd(FPasswordMail), FSecuriteMail,
             FSenderMail, FDestMail, 'Suivi BI Intersport', 'Reussite' + #13#10 + #13#10 + FLogs.Lines.Text)
  else
    SendMail(FServerMail, FPortMail, FUserMail, DecryptPasswd(FPasswordMail), FSecuriteMail,
             FSenderMail, FDestMail, 'Suivi BI Intersport', 'Erreur' + #13#10 + #13#10 + FLogs.Lines.Text);
end;

// correction temporelle d'un dossier

function TDm_ExportBI_new.CorrigeDossier(DateTrt : TDate) : boolean;
var
  DossierPath, DossierGrp : string;
begin
  Result := false;

  if SelectDossier(DossierPath, DossierGrp) then
  begin
    try
      DB_Correction.DatabaseName := DossierPath;
      DB_Correction.Open();
      if DB_Correction.Connected then
      begin
        try
          // Transaction
          IBT_Correction.StartTransaction();

          // creation de la procedure stocké !
          que_Correction.SQL.Clear();
          que_Correction.ParamCheck := false;
          que_Correction.SQL.Add('create procedure ISFBI_RETRAITEMENT_BI(datetrt date)');
          que_Correction.SQL.Add('as');
          que_Correction.SQL.Add('declare variable mvtid integer;');
          que_Correction.SQL.Add('declare variable magid integer;');
          que_Correction.SQL.Add('declare variable artid integer;');
          que_Correction.SQL.Add('declare variable tgfid integer;');
          que_Correction.SQL.Add('declare variable couid integer;');
          que_Correction.SQL.Add('declare variable mvtdate date;');
          que_Correction.SQL.Add('begin');
          que_Correction.SQL.Add('/******************************************************************************/');
          que_Correction.SQL.Add('/* Date        | Nom | Commentaire                                            */');
          que_Correction.SQL.Add('/* 2014-08-11  | BP  | Procedure fait repassé dans le BI tous les mouvement   */');
          que_Correction.SQL.Add('/*                     depuis une certaine date                               */');
          que_Correction.SQL.Add('/*                     Correction suite a betise du prestataire               */');
          que_Correction.SQL.Add('/*                                                                            */');
          que_Correction.SQL.Add('/******************************************************************************/');
          que_Correction.SQL.Add('');
          que_Correction.SQL.Add('  for select imt_idmvt, mvt_magid, mvt_artid, mvt_tgfid, mvt_couid, cast(mvt_date as date)');
          que_Correction.SQL.Add('      from isfmvtbitraite join agrmouvement on mvt_idligne = imt_idmvt');
          que_Correction.SQL.Add('      where imt_datetraite >= :datetrt');
          que_Correction.SQL.Add('      into :mvtid, :magid, :artid, :tgfid, :couid, :mvtdate do');
          que_Correction.SQL.Add('  begin');
          que_Correction.SQL.Add('    if (mvtdate < (datetrt -1)) then');
          que_Correction.SQL.Add('      update isfmvtbitraite set imt_datetraite = (:datetrt -2), imt_datevalide = (:datetrt -1), imt_fichier = ''toexpt'' where imt_idmvt = :mvtid;');
          que_Correction.SQL.Add('    else');
          que_Correction.SQL.Add('      update isfmvtbitraite set imt_fichier = ''todell'' where imt_idmvt = :mvtid;');
          que_Correction.SQL.Add('    execute procedure isfbi_addmvt(:magid, :artid, :tgfid, :couid, :mvtdate);');
          que_Correction.SQL.Add('  end');
          que_Correction.SQL.Add('  delete from isfmvtbitraite where imt_fichier = ''todell'';');
          que_Correction.SQL.Add('  update isfmvtbitraite set imt_fichier = null where imt_fichier = ''toexpt'';');
          que_Correction.SQL.Add('end;');
          que_Correction.ExecSQL();

          // execution de la procedure
          que_Correction.SQL.Clear();
          que_Correction.ParamCheck := true;
          que_Correction.SQL.Text := 'execute procedure ISFBI_RETRAITEMENT_BI(:DateTrt);';
          que_Correction.ParamByName('DateTrt').AsDateTime := DateTrt;
          que_Correction.ExecSQL();

          // suppressiond e la procedure
          que_Correction.SQL.Clear();
          que_Correction.ParamCheck := false;
          que_Correction.SQL.Text := 'drop procedure ISFBI_RETRAITEMENT_BI;';
          que_Correction.ExecSQL();

          // Transaction !
          IBT_Correction.Commit();
        except
          on e : Exception do
          begin
            Result := false;
            IBT_Correction.Rollback();
            raise ExceptClass(e.ClassType).Create('Dossier : ' + DossierPath + #13#10
                                                + 'Procedure de correction' + #13#10
                                                + 'Exception : ' + e.ClassName + ' - ' + e.Message);
          end;
        end;
      end;
    finally
      DB_Correction.Close();
    end;
  end;
end;

end.
