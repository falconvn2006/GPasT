unit ExportBI_Dm;

interface

uses
  SysUtils,
  // Uses perso
  AdvProgr,
  Forms,
  RzLabel,
  UCommon,
  IniFiles,
  Windows,
  // Fin uses perso
  Classes,
  IBDatabase,
  DB,
  IBCustomDataSet,
  IBQuery,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdExplicitTLSClientServerBase,
  IdFTP,
  IdFTPCommon,
  dxmdaset,
  ZipMstr19,
  wwDialog,
  wwidlg,
  wwLookupDialogRv;

type
  TDm_ExportBI = class(TDataModule)
    Ginkoia: TIBDatabase;
    DBMag: TIBDatabase;
    IbT_Ginkoia: TIBTransaction;
    IbT_DBMag: TIBTransaction;
    Que_GetMags: TIBQuery;
    Que_GetMagsDOS_BASEPATH: TIBStringField;
    QMvt: TIBQuery;
    IdFTP1: TIdFTP;
    QMvtCODMAG: TIBStringField;
    QMvtIDLIGNE: TIntegerField;
    QMvtDATEVAL: TDateTimeField;
    QMvtCOUNOM: TIBStringField;
    QMvtCOUCODE: TIBStringField;
    QMvtTDSC: TIBStringField;
    QMvtTGFNOM: TIBStringField;
    QMvtTGSNOM: TIBStringField;
    QMvtTGFCODE: TIBStringField;
    QMvtARTREFMRK: TIBStringField;
    QMvtMRKCODE: TIBStringField;
    QMvtMRKNOM: TIBStringField;
    QMvtARTNOM: TIBStringField;
    QMvtARTFEDAS: TIBStringField;
    QMvtARTCOL: TIBStringField;
    QMvtARTTYPE: TIntegerField;
    QMvtSKU: TIBStringField;
    QMvtFLAG: TIBStringField;
    QMvtMVTTVA: TIBBCDField;
    QMvtMVTPVBTTC: TIBBCDField;
    QMvtMVTPVNTTC: TIBBCDField;
    QMvtMVTPABHT: TIBBCDField;
    QMvtMVTPANHT: TIBBCDField;
    QMvtMVTPMP: TIBBCDField;
    QMvtQTETRANS: TIntegerField;
    QMvtTRATYPE: TIntegerField;
    MemD_Suivi: TdxMemData;
    MemD_SuiviCodMag: TStringField;
    MemD_SuiviDateTraite: TDateField;
    QValidate: TIBQuery;
    Que_GetMagsDOS_CODEGROUPEBI: TIBStringField;
    QMvtSTOCKCOUR: TIntegerField;
    QMvtMAGID: TIntegerField;
    Zip_FicTrans: TZipMaster19;
    QMags: TIBQuery;
    QMagsMAG_CODEADH: TIBStringField;
    QCalcStock: TIBQuery;
    QCalcStockRETOUR: TIntegerField;
    QStockPreTraite: TIBQuery;
    QDossier: TIBQuery;
    QMajDossier: TIBQuery;
    QDossierDOS_STRING: TIBStringField;
    QMvtIDENTETE: TIntegerField;
    QMagsATraiter: TIBQuery;
    QMagsATraiterMAG_CODEADH: TIBStringField;
    QGetDateInit: TIBQuery;
    QInsertDateInit: TIBQuery;
    QMagsATraiterMAG_ID: TIntegerField;
    QGetDateInitPRM_STRING: TIBStringField;
    QGetDateInitPRM_INTEGER: TIntegerField;
    LK_GetMagIFConfig: TwwLookupDialogRV;
    Que_GetMagsInit: TIBQuery;
    Que_GetMagsInitDOS_NOM: TIBStringField;
    Que_GetMagsInitDOS_BASEPATH: TIBStringField;
    Que_GetMagsInitDOS_CODEGROUPEBI: TIBStringField;
    QGetMagInit: TIBQuery;
    LK_GetMagInit: TwwLookupDialogRV;
    QDoInit: TIBQuery;
    QGetMagInitMAG_CODEADH: TIBStringField;
    QGetMagInitMAG_ENSEIGNE: TIBStringField;
    QGetMagInitMAG_ID: TIntegerField;
    QMvtARTCHRONO: TIBStringField;
    IbT_GinkoiaGetMag: TIBTransaction;
    QMagsATraiterPRM_STRING: TIBStringField;
    QMagsATraiterPRM_INTEGER: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
  private
    FMainProgress         : TAdvProgress;
    FLab_State            : TRzLabel;
    FLab_ConnexionStateGin: TRzLabel;

    FPathDB               : String;

    FDateLastOK           : TDateTime;

    Function Complete(ANbCar: integer; AValue: string; ACar: char = ' '): string;
    Function LComplete(ANbCar: integer; AValue: string; ACar: char = ' '): string;

    { Déclarations privées }
  public
    sTicket: string;

    // Barre de progression
    procedure InitProgress(AMessage: string; AMax: integer);
    procedure DoProgress(AMessage: String = '');
    procedure CloseProgress();

    { Déclarations publiques }
    procedure DoTraitement(AAvecEnvoiFTP: boolean = False);
    procedure DoCalcAllStock;
    procedure DoCalcStock(APathDB: String);
    procedure DoTraitementMag(APathDB, ACodeDossier, APathFics: String; tsResult: TStrings; AAvecEnvoiFTP: boolean);
    procedure DoTraitementCodeAdh(AMagId: integer; ACodeAdh, APathDB, ACodeDossier, APathFics: String; tsResult: TStrings; AAvecEnvoiFTP, AEnInit: boolean);
    function DoControleValidation() : boolean;
    procedure SendFileFTP(AFilePath: string);
    procedure GetFileFTP(AFilePath: string);
    procedure SuiviVersDataSet(AFilePath: string);
    procedure ChoixEtInitAMag();
    procedure ChoixEtTraiteAMag();

    procedure DoLogAction(AMessage: STRING; ANiveau: integer);

    property MainProgress: TAdvProgress read FMainProgress write FMainProgress;
    property Lab_ConnexionStateGin: TRzLabel read FLab_ConnexionStateGin write FLab_ConnexionStateGin;
    property Lab_State: TRzLabel read FLab_State write FLab_State;
  end;

var
  Dm_ExportBI: TDm_ExportBI;

implementation

{$R *.dfm}

{ TDm_ExportBI }
uses StrUtils,
  DateUtils,
  Controls,
  Dialogs;

procedure TDm_ExportBI.ChoixEtInitAMag;
var
  sPathIni      : string;   // Chemin vers l'ini
  iniConfigAppli: TIniFile; // Manipulation du Fichier Ini

begin
  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli := TIniFile.Create(sPathIni);
    FPathDB        := iniConfigAppli.ReadString('DATABASE', 'PATH', '');
  finally
    iniConfigAppli.Free;
  end;

  // Connexion à la base de données pour récupérer les mags
  if FileExists(FPathDB) then
  begin
    DBMag.DatabaseName := FPathDB;
    DBMag.Open;

    if DBMag.Connected then
    begin
      try
        IF LK_GetMagIFConfig.Execute THEN
        BEGIN
//          if FileExists(Que_GetMagsInitDOS_BASEPATH.AsString) then
//          begin
            InitProgress('Connexion à la base magasin :' + Que_GetMagsInitDOS_BASEPATH.AsString, 1);
            Ginkoia.DatabaseName := Que_GetMagsInitDOS_BASEPATH.AsString;
            Ginkoia.Open;
            if Ginkoia.Connected then
            begin
              IbT_Ginkoia.StartTransaction;
              try
                IF LK_GetMagInit.Execute THEN
                begin
                  InitProgress('Init du magasin :' + QGetMagInitMAG_CODEADH.AsString, 1);
                  QDoInit.ParamByName('MAGID').AsInteger := QGetMagInitMAG_ID.AsInteger;
                  QDoInit.ExecSQL;
                  DoProgress;
                end;
                IbT_Ginkoia.Commit;
              except
                IbT_Ginkoia.Rollback;
              end;
              Ginkoia.Close;
//            end;
          end;
          Que_GetMagsInit.Close;
        END;
      finally
        DBMag.Close;
        MemD_Suivi.Close;
      end;
    end
    else begin
      LogAction('Connexion impoosible à la nase DBMag : ' + FPathDB, 0);
    end;
  end
  else begin
    LogAction('Base DBMag inexistante : ' + FPathDB, 0);
  end;
  CloseProgress;
end;

procedure TDm_ExportBI.ChoixEtTraiteAMag();
var
  sPathIni      : string;   // Chemin vers l'ini
  iniConfigAppli: TIniFile; // Manipulation du Fichier Ini

  sPathFics     : string; // Chemin vers le dossier pour stock les extracts
  sPathGet      : string; // Controle suivi réplic

  tsResult      : TStrings; // Contient l'extraction

  bAvecEnvoiFTP: boolean;   // Envoi FTP ou non
begin
  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli := TIniFile.Create(sPathIni);
    FPathDB        := iniConfigAppli.ReadString('DATABASE', 'PATH', '');
  finally
    iniConfigAppli.Free;
  end;

  sPathFics := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Extract\';
  sPathFics := sPathFics + FormatDateTime('YYYY\MM\DD\', Now);
  ForceDirectories(sPathFics);

  // Récup sur FTP du fichier résultat de la précédente exécution pour controle d'intégration
  sPathGet := sPathFics + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + 'suivi_trans.csv';
  GetFileFTP(sPathGet);
  // Parsing du fichier reçu
  SuiviVersDataSet(sPathGet);


  // Connexion à la base de données pour récupérer les mags
  if FileExists(FPathDB) then
  begin
    DBMag.DatabaseName := FPathDB;
    DBMag.Open;

    if DBMag.Connected then
    begin
      try
        IF LK_GetMagIFConfig.Execute THEN
        BEGIN
//          if FileExists(Que_GetMagsInitDOS_BASEPATH.AsString) then
//          begin
            InitProgress('Connexion à la base magasin :' + Que_GetMagsInitDOS_BASEPATH.AsString, 1);
            Ginkoia.DatabaseName := Que_GetMagsInitDOS_BASEPATH.AsString;
            Ginkoia.Open;
            if Ginkoia.Connected then
            begin
              IbT_Ginkoia.StartTransaction;
              try
                IF LK_GetMagInit.Execute THEN
                begin
                  InitProgress('Traitement du magasin :' + QGetMagInitMAG_CODEADH.AsString, 1);

                  QGetDateInit.Close;
                  QGetDateInit.ParamByName('MAGID').AsInteger := QMagsATraiterMAG_ID.AsInteger;
                  QGetDateInit.Open;

                  bAvecEnvoiFTP := (MessageDlg('Effectuer l''envoi FTP une fois l''extraction terminée ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);

                  tsResult := TStringList.Create;
                  try
                    IF QGetDateInitPRM_INTEGER.AsInteger = 0 THEN
                    BEGIN
                      // On doit init, a voir donc
                      DoTraitementCodeAdh(QGetMagInitMAG_ID.AsInteger, QGetMagInitMAG_CODEADH.AsString, Que_GetMagsInitDOS_BASEPATH.AsString, Que_GetMagsInitDOS_CODEGROUPEBI.AsString, sPathFics, tsResult, bAvecEnvoiFTP, True);
                    END
                    else begin
                      DoTraitementCodeAdh(QGetMagInitMAG_ID.AsInteger, QGetMagInitMAG_CODEADH.AsString, Que_GetMagsInitDOS_BASEPATH.AsString, Que_GetMagsInitDOS_CODEGROUPEBI.AsString, sPathFics, tsResult, bAvecEnvoiFTP, False);
                    end;
                    QGetDateInit.Close;
                  finally
                    tsResult.Free;
                  end;

                  DoProgress;
                end;
                IbT_Ginkoia.Commit;
              except
                IbT_Ginkoia.Rollback;
              end;
              Ginkoia.Close;
            end;
          end;
          Que_GetMagsInit.Close;
//        END;
      finally
        DBMag.Close;
        MemD_Suivi.Close;
      end;
    end
    else begin
      LogAction('Connexion impoosible à la nase DBMag : ' + FPathDB, 0);
    end;
  end
  else begin
    LogAction('Base DBMag inexistante : ' + FPathDB, 0);
  end;
  CloseProgress;
end;

procedure TDm_ExportBI.CloseProgress;
begin
  if FMainProgress <> Nil then
  begin
    FMainProgress.Position := 0;
    FMainProgress.Visible  := False;
  end;

  if Lab_State <> Nil then
  begin
    Lab_State.Caption := '';
    Lab_State.Visible := False;
  end;

  Application.ProcessMessages;
end;

function TDm_ExportBI.Complete(ANbCar: integer; AValue: string; ACar: char): string;
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

function TDm_ExportBI.LComplete(ANbCar: integer; AValue: string; ACar: char): string;
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

procedure TDm_ExportBI.DataModuleCreate(Sender: TObject);
var
  sPathIni      : string;   // Chemin vers l'ini
  iniConfigAppli: TIniFile; // Manipulation du Fichier Ini

  iNivLog       : integer;  // Niveau de log à inscrire dans le fichier
begin
  // Cloture des connexions au cas ou
  DBMag.Close;
  Ginkoia.Close;

  iNivLog          := 0;

  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli := TIniFile.Create(sPathIni);
    iNivLog        := iniConfigAppli.ReadInteger('LOGS', 'NIVEAU', 0);
  finally
    iniConfigAppli.Free;
  end;

  // On conserve 2 mois de log (arbitraire, voir pour rendre paramétrable ini ?)
  UCommon.PurgeOldLogs(True, 60);

  // Init les logs (voir pr rendre paramétrable le niveau de log au besoin, pr l'instant les 5 premiers niveaux sont logés)
  UCommon.InitLogFileName(Nil, Nil, iNivLog);
end;

procedure TDm_ExportBI.DoCalcAllStock;
var
  sPathIni      : string;   // Chemin vers l'ini
  iniConfigAppli: TIniFile; // Manipulation du Fichier Ini
begin
  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli := TIniFile.Create(sPathIni);
    FPathDB        := iniConfigAppli.ReadString('DATABASE', 'PATH', '');
  finally
    iniConfigAppli.Free;
  end;

  // Connexion à la base de données pour récupérer les mags
  if FileExists(FPathDB) then
  begin
    DBMag.DatabaseName := FPathDB;
    DBMag.Open;

    if DBMag.Connected then
    begin
      Que_GetMags.Open;
      Que_GetMags.First;
      try
        // Que_GetMags.RecordCount;
        while NOT Que_GetMags.Eof do
        begin
          DoCalcStock(Que_GetMagsDOS_BASEPATH.AsString);

          Que_GetMags.Next;
        end;
        Que_GetMags.Close;
      finally
        DBMag.Close;
      end;
    end
    else begin
      LogAction('Connexion impoosible à la nase DBMag : ' + FPathDB, 0);
    end;
  end
  else begin
    LogAction('Base DBMag inexistante : ' + FPathDB, 0);
  end;
  CloseProgress;
end;

procedure TDm_ExportBI.DoCalcStock(APathDB: String);
var
  iResult: integer; // Résultat de la proc stockée
begin
//  if FileExists(APathDB) then
//  begin
    Ginkoia.Close;
    InitProgress('Connexion à la base magasin :' + APathDB, 1);
    Ginkoia.DatabaseName := APathDB;
    Ginkoia.Open;
    if Ginkoia.Connected then
    begin
      InitProgress('Calcul du stock pour :' + APathDB, 1);
      DoProgress;

      try
        IbT_Ginkoia.StartTransaction;
        QStockPreTraite.ExecSQL;
        QStockPreTraite.Close;
        iResult := 1;
        IbT_Ginkoia.Commit;
      except
        on e: Exception do
        begin
          IbT_Ginkoia.Rollback;
          iResult := 0;
          LogAction('Erreur prétraitement du calcul de stock sur ' + APathDB, 0);
          LogAction(e.Message, 0);
        end;
      end;

      while iResult = 1 do
      begin
        // Exécution de la procédure stockée
        IbT_Ginkoia.StartTransaction;
        try
          QCalcStock.Open;
          iResult := QCalcStockRETOUR.AsInteger;
          QCalcStock.Close;
          IbT_Ginkoia.Commit;
        except
          on e: Exception do
          begin
            IbT_Ginkoia.Rollback;
            iResult := 0;
            LogAction('Erreur calcul de stock sur ' + APathDB, 0);
            LogAction(e.Message, 0);
          end;
        end;
      end; // while

      // On en repasse un ptit parce que pb il en reste 1
      IbT_Ginkoia.StartTransaction;
      try
        QCalcStock.Open;
        iResult := QCalcStockRETOUR.AsInteger;
        QCalcStock.Close;
        IbT_Ginkoia.Commit;
      except
        on e: Exception do
        begin
          IbT_Ginkoia.Rollback;
          iResult := 0;
          LogAction('Erreur calcul de stock sur ' + APathDB, 0);
          LogAction(e.Message, 0);
        end;
      end;
    end;
    Ginkoia.Close;
//  end;
end;

function TDm_ExportBI.DoControleValidation() : boolean;
var
  sMagCour  : string;    // Code mag en cours
  dtDateLast: TDateTime; // Date de derniere intégration
begin
  Result := False;
  sMagCour := '';
  try
    IbT_Ginkoia.StartTransaction;

    try
      QMags.Open;
      InitProgress('Controle validation', QMags.RecordCount);
      while not QMags.Eof do
      begin
        sMagCour := QMagsMAG_CODEADH.AsString;
        if sMagCour <> '' then
        begin
          DoProgress('Controle validation ' + sMagCour);

          // Controle de validation
          if MemD_Suivi.Locate('CodMag', sMagCour, []) then
            dtDateLast := MemD_SuiviDateTraite.AsDateTime
          else
            dtDateLast := FDateLastOK;

          QValidate.ParamByName('DATEVALIDE').AsDateTime := dtDateLast;
          QValidate.ParamByName('MAGCODE').AsString      := sMagCour;
          QValidate.ExecSQL;
        end
        else
        begin
          DoProgress();
        end;
        QMags.Next;
      end;
    finally
      QMags.Close;
    end;

    IbT_Ginkoia.Commit;
    Result := True;
  except
    on e: Exception do
    begin
      IbT_Ginkoia.Rollback;
      LogAction('Traitement du magasin : ' + sMagCour, 0);
      LogAction('Exception : ' + e.ClassName + ' - ' + e.Message, 0);
    end;
  end;
end;

procedure TDm_ExportBI.DoLogAction(AMessage: STRING; ANiveau: integer);
begin
  try
    LogAction(AMessage, ANiveau);
  except

  end;
end;

procedure TDm_ExportBI.DoProgress(AMessage: string);
begin
  if FMainProgress <> Nil then
  begin
    if AMessage <> '' then
    begin
      Lab_State.Caption := AMessage;
    end;

    FMainProgress.StepIt;
    Application.ProcessMessages;

    if AMessage <> '' then
    begin
      Lab_State.Caption := AMessage;
    end;
  end;
end;

procedure TDm_ExportBI.DoTraitement(AAvecEnvoiFTP: boolean);
var
  sPathIni      : string;   // Chemin vers l'ini
  iniConfigAppli: TIniFile; // Manipulation du Fichier Ini

  sPath         : string;   // Chemin vers le fichier à sauvegarder
  sPathGet      : string;   // Chemin vers le fichier de résultat
  tsResult      : TStrings; // Contient l'extraction
begin
  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli := TIniFile.Create(sPathIni);
    FPathDB        := iniConfigAppli.ReadString('DATABASE', 'PATH', '');
  finally
    iniConfigAppli.Free;
  end;

  sPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Extract\';
  sPath := sPath + FormatDateTime('YYYY\MM\DD\', Now);
  ForceDirectories(sPath);

  // Récup sur FTP du fichier résultat de la précédente exécution pour controle d'intégration
  sPathGet := sPath + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + 'suivi_trans.csv';
  GetFileFTP(sPathGet);
  // Parsing du fichier reçu
  SuiviVersDataSet(sPathGet);

  // Connexion à la base de données pour récupérer les mags
  if FileExists(FPathDB) then
  begin
    DBMag.DatabaseName := FPathDB;
    DBMag.Open;

    if DBMag.Connected then
    begin
      Que_GetMags.Open;
      Que_GetMags.First;

      tsResult := TStringList.Create;
      try
        while NOT Que_GetMags.Eof do
        begin
          DoTraitementMag(Que_GetMagsDOS_BASEPATH.AsString, Que_GetMagsDOS_CODEGROUPEBI.AsString, sPath, tsResult, AAvecEnvoiFTP);

          Que_GetMags.Next;
        end;
        Que_GetMags.Close;
      finally
        DBMag.Close;
        tsResult.Free;
        MemD_Suivi.Close;
      end;
    end
    else begin
      LogAction('Connexion impoosible à la nase DBMag : ' + FPathDB, 0);
    end;
  end
  else begin
    LogAction('Base DBMag inexistante : ' + FPathDB, 0);
  end;
  CloseProgress;
end;

procedure TDm_ExportBI.DoTraitementCodeAdh(AMagId: integer; ACodeAdh, APathDB, ACodeDossier, APathFics: String; tsResult: TStrings;
  AAvecEnvoiFTP, AEnInit: boolean);
var
  sLigne         : string;
  sMagCour       : string;    // Code mag en cours

  sPathFicMvt    : string;    // Chemin vers le fichier mouvement à zipper
  sPathFicMvtSvg : string;    // Chemin vers le fichier mouvement à sauvegarder
  sPathFicSuiv   : string;    // Chemin vers le fichier suivi à zipper
  sPathFicSuivSvg: string;    // Chemin vers le fichier suivi à sauvegarder
  sZipFicName    : string;    // Nom du fichier Zip à envoyer

  dtMvtDateMin   : TDateTime; // Date du mouvement le plus ancien
  dtMvtDateMax   : TDateTime; // Date du mouvement le plus récent
  dtDateMax      : TDateTime; // Date d'extraction
  dtDateLast     : TDateTime; // Date de derniere intégration

  iNbLigne       : integer;   // Nombre de lignes dans le fichier

  sPathSend      : string;    // Chemin du fichier a envoyer
  sStock         : string;    // Variabl de stockage du stock en string

  txtFicDest     : TextFile;  // Variable Fichier pour le fichier de sortie
begin
  InitProgress('Préparation des données par le serveur', 1);
  QMvt.Close;
  QMvt.ParamByName('CODEADH').AsString := ACodeAdh;
  QMvt.Open;
  DoProgress();
  Sleep(100);
  InitProgress('Traitement des données magasin', QMvt.RecordCount);

  // Pas d'Entete
  if not QMvt.Eof then
  begin
    sMagCour          := QMvtCODMAG.AsString;
    sStock            := LComplete(8, QMvtSTOCKCOUR.AsString, '0');
    Lab_State.Caption := 'Traitement des données de ' + sMagCour;

    iNbLigne          := 0;

    // Si avant 6h
    IF Frac(Now) < 0.25 THEN
      dtDateMax    := Trunc(Now) - 1
    else
      dtDateMax    := Trunc(Now);

    sPathFicMvt    := APathFics + 'trans.csv';
    sPathFicMvtSvg := APathFics + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + StringReplace(sMagCour, '/', '_', [rfReplaceAll]) + '.trans.csv';

    AssignFile(txtFicDest, sPathFicMvt);
    Rewrite(txtFicDest);
    try
      dtMvtDateMin := QMvtDATEVAL.AsDateTime;
      dtMvtDateMax := QMvtDATEVAL.AsDateTime;
      while (not QMvt.Eof) and (sMagCour = QMvtCODMAG.AsString) do
      begin
        // Un fichier par magasin
        sTicket := QMvtCODMAG.AsString + FormatDateTime('HHMM', QMvtDATEVAL.AsDateTime) + QMvtIDENTETE.AsString;

        sLigne  := Complete(10, QMvtCODMAG.AsString) + ';';                                                                           // A    // 0
        sLigne  := sLigne + Complete(36, sTicket) + ';';                                                          // Ticket           // B    // 1
        sLigne  := sLigne + Complete(1, QMvtTRATYPE.AsString) + ';';                                              // Type             // C    // 2
        sLigne  := sLigne + Complete(1, 'N') + ';';                                                               // Service          // D    // 3
        sLigne  := sLigne + Complete(3, 'GIN') + ';';                                                             // PROV             // E    // 4
        sLigne  := sLigne + FormatDateTime('YYYYMMDD', QMvtDATEVAL.AsDateTime) + ';';                             // Dateval          // F    // 5
        sLigne  := sLigne + Complete(10, QMvtARTCOL.AsString) + ';';                                              // Col              // G    // 6
        sLigne  := sLigne + Complete(20, QMvtARTREFMRK.AsString) + ';';                                           // Code modele      // H    // 7
        sLigne  := sLigne + Complete(30, QMvtARTNOM.AsString) + ';';                                              // Lib modèle       // I    // 8
        sLigne  := sLigne + Complete(20, QMvtARTREFMRK.AsString) + ';';                                           // Modèle fourn     // J    // 9
        sLigne  := sLigne + Complete(3, QMvtCOUCODE.AsString) + ';';                                              // Code coul        // K    // 10
        sLigne  := sLigne + Complete(30, QMvtCOUNOM.AsString) + ';';                                              // Lib coul         // L    // 11
        sLigne  := sLigne + Complete(5, QMvtTGFNOM.AsString) + ';';                                               // Taille Frn       // M    // 12
        sLigne  := sLigne + Complete(5, '') + ';';                                                                // Index taille     // N    // 13
        sLigne  := sLigne + Complete(5, QMvtTGSNOM.AsString) + ';';                                               // Taille ref FR    // O    // 14
        sLigne  := sLigne + Complete(15, QMvtSKU.AsString) + ';';                                                 // SKU              // P    // 15
        sLigne  := sLigne + Complete(15, '') + ';';                                                               // Colis            // Q    // 16
        sLigne  := sLigne + Complete(10, '') + ';';                                                               // Code fou         // R    // 17
        sLigne  := sLigne + Complete(30, '') + ';';                                                               // Lib Fou          // S    // 18
        sLigne  := sLigne + Complete(3, QMvtMRKCODE.AsString) + ';';                                              // Code Mrk         // T    // 19
        sLigne  := sLigne + Complete(30, QMvtMRKNOM.AsString) + ';';                                              // Lib Mrk          // U    // 20
        sLigne  := sLigne + Complete(6, QMvtARTFEDAS.AsString) + ';';                                             // Fedas            // V    // 21
        sLigne  := sLigne + Complete(20, QMvt.FieldByName('ARTCHRONO').AsString) + ';';                           // CategM           // W    // 22
        sLigne  := sLigne + Complete(5, '') + ';';                                                                // Typpo            // X    // 23
        sLigne  := sLigne + Complete(1, QMvtTDSC.AsString) + ';';                                                 // TDSC             // Y    // 24
        sLigne  := sLigne + Complete(1, '') + ';';                                                                // Referencement    // Z    // 25
        sLigne  := sLigne + Complete(8, QMvtQTETRANS.AsString) + ';';                                             // Qté              // AA   // 26
        sLigne  := sLigne + LComplete(10, StringReplace(QMvtMVTPABHT.AsString, ',', '.', [rfReplaceAll])) + ';';  // PxAB             // AB   // 27
        sLigne  := sLigne + LComplete(10, StringReplace(QMvtMVTPANHT.AsString, ',', '.', [rfReplaceAll])) + ';';  // PxAN             // AC   // 28
        sLigne  := sLigne + LComplete(10, StringReplace(QMvtMVTPVBTTC.AsString, ',', '.', [rfReplaceAll])) + ';'; // PxVB             // AD   // 29
        sLigne  := sLigne + LComplete(10, StringReplace(QMvtMVTPVNTTC.AsString, ',', '.', [rfReplaceAll])) + ';'; // PxVN             // AE   // 30
        sLigne  := sLigne + LComplete(10, StringReplace(QMvtMVTPMP.AsString, ',', '.', [rfReplaceAll])) + ';';    // Pump             // AF   // 31
        sLigne  := sLigne + LComplete(5, StringReplace(QMvtMVTTVA.AsString, ',', '.', [rfReplaceAll])) + ';';     // Tva              // AG   // 32
        sLigne  := sLigne + Complete(3, 'EUR') + ';';                                                             // DEV              // AH   // 33
        sLigne  := sLigne + Complete(6, '') + ';';                                                                // Surf tot         // AI   // 34
        sLigne  := sLigne + Complete(6, '') + ';';                                                                // Surf vte         // AJ   // 35
        sLigne  := sLigne + Complete(6, '') + ';';                                                                // Surf res         // AK   // 36
        sLigne  := sLigne + LComplete(5, ACodeDossier) + ';';                                                     // Grp mag          // AL   // 37
        sLigne  := sLigne + Complete(10, '') + ';';                                                               // Code mag Princ   // AM   // 38
        sLigne  := sLigne + Complete(1, QMvtARTTYPE.AsString) + ';';                                              // Libre 1 (origine)// AN   // 39
        sLigne  := sLigne + Complete(1, '') + ';';                                                                // Libre 2          // AO   // 40
        sLigne  := sLigne + Complete(10, '') + ';';                                                               // Libre 3          // AP   // 41
        sLigne  := sLigne + Complete(10, '') + ';';                                                               // Libre 4          // AQ   // 42
        sLigne  := sLigne + Complete(1, '') + ';';                                                                // Statut           // AR   // 43
        sLigne  := sLigne + FormatDateTime('YYYYMMDD', QMvtDATEVAL.AsDateTime) + ';';                             // Date_trans       // AS   // 44
        sLigne  := sLigne + FormatDateTime('YYYYMMDD', Now) + ';';                                                // Date remontée    // AT   // 45
        sLigne  := sLigne + Complete(1, '') + ';';                                                                // Flag Trt         // AU   // 46
        sLigne  := sLigne + Complete(8, '') + ';';                                                                // Date Trt         // AV   // 47
        sLigne  := sLigne + LComplete(8, QMvtQTETRANS.AsString) + ';';                                            // Qte BW           // AW   // 48
        sLigne  := sLigne + Complete(8, '') + ';';                                                                // Date BW          // AY   // 49
        sLigne  := sLigne + Complete(1, QMvtFLAG.AsString) + ';';                                                 // Flag             // AZ   // 50
        sLigne  := sLigne + Complete(15, '') + ';';                                                               // Numéro carte fid         // 51

        Inc(iNbLigne);

        WriteLn(txtFicDest, sLigne);

        // Sauvegarde des date en cas d'init
        if AEnInit then
        begin
          if QMvtDATEVAL.AsDateTime < dtMvtDateMin then
          begin
            dtMvtDateMin := QMvtDATEVAL.AsDateTime;
          end;

          if QMvtDATEVAL.AsDateTime > dtMvtDateMax then
          begin
            dtMvtDateMax := QMvtDATEVAL.AsDateTime;
          end;
        end;

        DoProgress;

        QMvt.Next;
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
      tsResult.Add('[Nbr_ligne]=' + IntToStr(iNbLigne));
      tsResult.Add('[Magasin]=' + sMagCour);

      // Mettre à jour le genparam
      QInsertDateInit.Close;
      QInsertDateInit.ParamByName('MAGID').AsInteger   := AMagId;
      QInsertDateInit.ParamByName('DATECOUR').AsString := FormatDateTime('DD/MM/YYYY', Trunc(Now));
      QInsertDateInit.ExecSQL;
    end
    else
    begin
      // Recherche dans le Controle de validation
      IF MemD_Suivi.Locate('CodMag', sMagCour, []) THEN
      begin
        // Erreur, on garde cette date
        dtDateLast := MemD_SuiviDateTraite.AsDateTime;
      end
      else begin
        // Pas d'erreur, on prend la date de 99999
        dtDateLast := FDateLastOK;
      end;

      tsResult.Add('[Groupe]=' + ACodeDossier);
      tsResult.Add('[ad_IP]=127.0.0.1');
      tsResult.Add('[Mag_P]=' + sMagCour);
      tsResult.Add('[Version]=BI_V2.1');
      tsResult.Add('[Date_suivi]=' + FormatDateTime('YYYYMMDD', dtDateLast));
      tsResult.Add('[Date_debut_extraction]=' + FormatDateTime('YYYYMMDD', dtDateLast));
      tsResult.Add('[Date_max_extraction]=' + FormatDateTime('YYYYMMDD', dtDateMax));
      tsResult.Add('[Type_connexion]=2');
      tsResult.Add('[Nbr_ligne]=' + IntToStr(iNbLigne));
      tsResult.Add('[comparaison]=' + sMagCour + ';' + sStock + ';' + sStock + ';000');
      tsResult.Add('[Magasin]=' + sMagCour);
    end;

    sPathFicSuiv    := APathFics + 'trans_suivi.csv';
    sPathFicSuivSvg := APathFics + FormatDateTime('YYYYMMDD.HHNNSS.ZZZ.', Now) + StringReplace(sMagCour, '/', '_', [rfReplaceAll]) + '.trans_suivi.csv';
    tsResult.SaveToFile(sPathFicSuiv);

    // Zipper les fichiers
    sZipFicName              := APathFics + 'Trans_' + StringReplace(sMagCour, '/', '_', [rfReplaceAll]) + '_' + ACodeDossier + '.zip';
    Zip_FicTrans.ZipFileName := sZipFicName;
    Zip_FicTrans.FSpecArgs.Add(sPathFicMvt);
    Zip_FicTrans.FSpecArgs.Add(sPathFicSuiv);
    Zip_FicTrans.Add;

    RenameFile(sPathFicSuiv, sPathFicSuivSvg);
    RenameFile(sPathFicMvt, sPathFicMvtSvg);

    // Todo : Voir s'il est judicieux de faire un envoi FTP dans un second temps de tous les fichiers
    if AAvecEnvoiFTP then
      SendFileFTP(sZipFicName);
  end;
  QMvt.Close;
end;

procedure TDm_ExportBI.DoTraitementMag(APathDB, ACodeDossier, APathFics: String; tsResult: TStrings; AAvecEnvoiFTP: boolean);
var
  sCodeAdh: string;  // Code adh<érant du mag en cours
  bDoInit : boolean; // Permet de savoir si on est en mode init pour changer le fichier trans
  res : Boolean;
  retry : integer;
begin
  res := False;
  retry := 3;
  InitProgress('Connexion à la base magasin :' + APathDB, 1);
  Ginkoia.Close;
  Ginkoia.DatabaseName := APathDB;
  try
    Ginkoia.Open;
    if Ginkoia.Connected then
    begin
      DoProgress;

      try
        try
          QMagsATraiter.Open;

          while not res and (retry > 0) do
          begin
            // Exécution de la procédure stockée
            res := DoControleValidation();
            if not res then
            begin
              Ginkoia.Close();
              // attente
              Sleep(retry * 60 * 1000); // 3 minutes puis 2 puis ...
              Dec(retry);
              // reouverture de la connexion !
              Ginkoia.Open();
              QMagsATraiter.Open();
            end;
          end;

          if not res then
            raise Exception.Create('Erreur lors de la Validation');

          while not QMagsATraiter.Eof do
          begin
            try
              IbT_Ginkoia.StartTransaction;

              sTicket  := '';
              sCodeAdh := QMagsATraiterMAG_CODEADH.AsString;

              // Vérifie si init faite
              DoTraitementCodeAdh(QMagsATraiterMAG_ID.AsInteger, sCodeAdh, APathDB, ACodeDossier, APathFics, tsResult, AAvecEnvoiFTP, QMagsATraiterPRM_INTEGER.AsInteger = 0);

              IbT_Ginkoia.Commit;
            except
              On e: Exception do
              begin
                IbT_Ginkoia.Rollback;
                LogAction('Traitement du magasin : ' + sCodeAdh, 0);
                LogAction('Exception : ' + e.ClassName + ' - ' + e.Message, 0);
              end;
            end;

            QMagsATraiter.Next;
          end;
        finally
          QMagsATraiter.Close;
        end;
      except
        On e: Exception do
        begin
          LogAction('Exception : ' + sTicket + #13#10 + e.Message, 0);
        end;
      end;
      Ginkoia.Close;
    end
    else
    begin
      LogAction('Connexion impossible à la base Ginkoia : ' + APathDB, 0);
    end;
  except
    LogAction('Base Ginkoia inexistante : ' + APathDB, 0);
  end;
end;

procedure TDm_ExportBI.GetFileFTP(AFilePath: string);
var
  sPathIni      : string;   // Chemin vers l'ini
  iniConfigAppli: TIniFile; // Manipulation du Fichier Ini

  ftpSendFile   : TIdFTP;   // Composant FTP

  sURLFTP       : string;   // Infos FTP
  sUserFTP      : string;   // Infos FTP
  sCryptedPwdFTP: string;   // Infos FTP
  sPwdFTP       : string;   // Infos FTP
  iPortFTP      : integer;  // Infos FTP
  sFolderFTP    : string;   // Infos FTP
  i             : integer;
begin
  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli := TIniFile.Create(sPathIni);
    sURLFTP        := iniConfigAppli.ReadString('FTP', 'URL', '');
    sUserFTP       := iniConfigAppli.ReadString('FTP', 'USER', '');
    sCryptedPwdFTP := iniConfigAppli.ReadString('FTP', 'PWD', '');
    iPortFTP       := iniConfigAppli.ReadInteger('FTP', 'PORT', 0);
    sFolderFTP     := iniConfigAppli.ReadString('FTP', 'FOLDER', '');

    InitProgress('Récupération fichier suivi : connexion à ' + sURLFTP, 2);
    // Décryptage du password (on l'inverse juste et on ajoute un car pourri à la fin
    sPwdFTP                    := '';
    for i                      := (Length(sCryptedPwdFTP) - 1) downto 1 do
      sPwdFTP                  := sPwdFTP + sCryptedPwdFTP[i];

    ftpSendFile                := TIdFTP.Create(Self);
    try
      ftpSendFile.Host         := sURLFTP;
      ftpSendFile.Port         := iPortFTP;
      ftpSendFile.Username     := sUserFTP;
      ftpSendFile.Password     := sPwdFTP;
      ftpSendFile.TransferType := ftBinary;

      ftpSendFile.Connect;
      IF not ftpSendFile.Connected then
      begin
        LogAction('Erreur login FTP', 0);
        DoProgress;
        DoProgress;
      end
      else begin
        ftpSendFile.Passive := True;
        if sFolderFTP <> '' then
        begin
          ftpSendFile.ChangeDir(sFolderFTP);
        end;
        DoProgress;

        ftpSendFile.Get('suivi_trans.csv', AFilePath, True, False);
        DoProgress;

        ftpSendFile.Disconnect;
      end;
    finally
      ftpSendFile.Free;
    end;
  finally
    iniConfigAppli.Free;
  end;

end;

procedure TDm_ExportBI.InitProgress(AMessage: string; AMax: integer);
begin
  if FMainProgress <> Nil then
  begin
    FMainProgress.Position := 0;
    FMainProgress.Step     := 1;
    FMainProgress.Min      := 0;
    FMainProgress.Max      := AMax;
    FMainProgress.Visible  := True;
  end;

  if Lab_State <> Nil then
  begin
    Lab_State.Visible := True;
    Lab_State.Caption := AMessage;
    LogAction('InitProgress : ' + AMessage, 2)
  end;

  Application.ProcessMessages;
end;

procedure TDm_ExportBI.SendFileFTP(AFilePath: string);
var
  sPathIni      : string;      // Chemin vers l'ini
  iniConfigAppli: TIniFile;    // Manipulation du Fichier Ini

  ftpSendFile   : TIdFTP;      // Composant FTP

  sURLFTP       : string;      // Infos FTP
  sUserFTP      : string;      // Infos FTP
  sCryptedPwdFTP: string;      // Infos FTP
  sPwdFTP       : string;      // Infos FTP
  iPortFTP      : integer;     // Infos FTP
  sFolderFTP    : string;      // Infos FTP

  sFicTstFTP    : string;      // Fichier de test du FTP
  tsFicTstFTP   : TStringList; // Fichier de test du FTP

  i             : integer;
begin
  if NOT FileExists(AFilePath) then
  begin
    LogAction('Fichier inexistant : ' + AFilePath, 0);
    EXIT;
  end;

  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli := TIniFile.Create(sPathIni);
    sURLFTP        := iniConfigAppli.ReadString('FTP', 'URL', '');
    sUserFTP       := iniConfigAppli.ReadString('FTP', 'USER', '');
    sCryptedPwdFTP := iniConfigAppli.ReadString('FTP', 'PWD', '');
    iPortFTP       := iniConfigAppli.ReadInteger('FTP', 'PORT', 0);
    sFolderFTP     := iniConfigAppli.ReadString('FTP', 'FOLDER', '');

    // Décryptage du password (on l'inverse juste et on ajoute un car pourri à la fin
    sPwdFTP                    := '';
    for i                      := (Length(sCryptedPwdFTP) - 1) downto 1 do
      sPwdFTP                  := sPwdFTP + sCryptedPwdFTP[i];

    ftpSendFile                := TIdFTP.Create(Self);
    try
      ftpSendFile.Host         := sURLFTP;
      ftpSendFile.Port         := iPortFTP;
      ftpSendFile.Username     := sUserFTP;
      ftpSendFile.Password     := sPwdFTP;
      ftpSendFile.TransferType := ftBinary;

      ftpSendFile.Connect;
      IF not ftpSendFile.Connected then
      begin
        LogAction('Erreur login FTP', 0);
      end
      else
      begin
        // Ajout d'un fichier texte avec juste 1 dedans
        sFicTstFTP         := ChangeFileExt(AFilePath, '.txt');
        tsFicTstFTP        := TStringList.Create;
        try
          tsFicTstFTP.Text := '1';
          tsFicTstFTP.SaveToFile(sFicTstFTP);
        Finally
          tsFicTstFTP.Free;
        End;

        ftpSendFile.Passive := True;
        if sFolderFTP <> '' then
        begin
          ftpSendFile.ChangeDir(sFolderFTP);

          ftpSendFile.Put(AFilePath);
          ftpSendFile.Put(sFicTstFTP);
        end;

        ftpSendFile.Disconnect;
      end;
    finally
      ftpSendFile.Free;
    end;
  finally
    iniConfigAppli.Free;
  end;

end;

procedure TDm_ExportBI.SuiviVersDataSet(AFilePath: string);
var
  tfSuivi     : TextFile;
  sLigne      : string;

  sCodeMag    : string;    // Code du magasin
  dtDateTraite: TDateTime; // Date du dernier traitement
  sDateTraite : string;    // Pour conversion de la chaine en date
begin
  MemD_Suivi.Close;
  MemD_Suivi.Open;
  if FileExists(AFilePath) then
  begin
    AssignFile(tfSuivi, AFilePath);
    try
      Reset(tfSuivi);

      while NOT Eof(tfSuivi) do
      begin
        Readln(tfSuivi, sLigne);
        if sLigne <> '' then
        begin
          if Copy(sLigne, 1, 5) = '99999' then
          begin
            // Donne la date du dernier traitement réussi
            sDateTraite := Copy(sLigne, 21, 2) + '/' + Copy(sLigne, 19, 2) + '/' + Copy(sLigne, 15, 4);
            FDateLastOK := StrToDate(sDateTraite);
          end
          else begin
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
    finally
      CloseFile(tfSuivi);
    end;
  end;
end;

end.
