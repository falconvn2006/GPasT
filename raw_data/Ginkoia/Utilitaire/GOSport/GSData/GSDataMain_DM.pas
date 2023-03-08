unit GSDataMain_DM;

interface

uses
  SysUtils, Classes, DB, DBClient, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdIntercept, IdLogBase,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, StdCtrls, StrUtils, DateUtils,
  IB_Access, IBODataset, IB_Components, Types, IdLogFile,
  IdMessageClient, IdSMTPBase, IdSMTP, ComCtrls, Dialogs, Windows,
  GSData_MainClass,
  GSData_Types,
  GSDataDbCfg_DM,
  GSDataImport_DM,
  GSData_TOpeCom,
  GSData_ArticleClass,
  GSData_TMarque,
  GSData_TNomenclature,
  GSData_TMultiColis,
  GSData_RapportClass,
  GSData_TPackage,
  GSData_TPrixVente,
  GSData_PrePackClass,
  GSData_FournisseurClass,
  GSData_CommandeClass,
  GSData_ReceptionClass,
  GSDataExtract_DM,
  GSDataUserActionSelect_Frm,
  ZipMstr19, uLogFile, controls,
  uLog, Generics.Collections, IB_Session;

type
  TDM_GSDataMain = class(TDataModule)
    IboDbClient: TIBODatabase;
    Que_Magasins: TIBOQuery;
    Que_Class: TIBOQuery;
    IbC_MAJ: TIB_Cursor;
    IbT_MAJ: TIB_Transaction;
    Que_Marque: TIBOQuery;
    Que_Collections: TIBOQuery;
    Que_Tva: TIBOQuery;
    Que_OpeCom: TIBOQuery;
    Que_MultiColis: TIBOQuery;
    Que_Package: TIBOQuery;
    Que_PackageGroupe: TIBOQuery;
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IbStProc_SetLoop: TIB_StoredProc;
    IBOTransaction: TIBOTransaction;
    Que_Fournisseurs: TIBOQuery;
    Que_ArtRelationArt: TIBOQuery;
    IBOStoredProc: TIBOStoredProc;
    ZipMaster191: TZipMaster19;
    Que_OFRTETE: TIBOQuery;
    Que_OFRMAGASIN: TIBOQuery;
    Que_OFRLIGNEBR: TIBOQuery;
    Que_OFRIMPBR: TIBOQuery;
    Que_OFRPERIMETRE: TIBOQuery;
    Que_ExtractFourn: TIBOQuery;
    Que_Tmp: TIBOQuery;
    Que_OFRTYPCARTEFID: TIBOQuery;
    Que_tmp2: TIBOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FMemo        : TMemo;
    FRapport     : TRapportClass;
    FProgressBar : TProgressBar;
    FLabel       : TLabel ;
    FLabelError  : TLabel ;
    FInitMode    : Boolean;
    FrestartNeed : Boolean;
    FbypassInstance : Boolean;

    procedure DeplacerFichier(ADirFTP, ADirDossier : String; ALst : TStringList);
    function ConvertToDate(ADateStr : string) : TDateTime;
  private
    procedure LoadClientDataSet(const ClientDataSet: TClientDataSet;
      const IBODataset: TIBODataset);
  public
    { Déclarations publiques }
    procedure AddToMemo(AText : String);
    procedure AddToLog(const AText: String);
    procedure DisplayConnectionStatus(const Visible: Boolean;
      const Hint: String = '');

    procedure LoopAutoActive(iNbNew: Integer);
    procedure ExecuteProcessImport(const Manuel : Boolean = False; const All : boolean = true);
    procedure ExportFiles(AExportType: TExportType);
    procedure ExecuteProcessExport(AExportType: TExportType; AListOfMagsByCustomerFiles: TList<TCustomerFile>; AFicIDs: TList<Integer>);
    procedure ExecuteProcessExtract(Manuel : Boolean = False);
    procedure ExecuteProcessWebService(Manuel : Boolean = False);
    function  LoadCds(Qry: TIBOQuery; Cds: TClientDataSet;
      const OFE_CHRONO: string = ''): Boolean;
    function  LoadCdsMag(QryFourn, QrySelect: TIBOQuery; Cds: TClientDataSet;
      const OFE_CHRONO: string): Boolean;
    Procedure ClearCdsImport;
    procedure clearErrors ;

    procedure InitPxADate;

    property Memo : TMemo read FMemo write FMemo;
    property LabelMain : TLabel read FLabel write FLabel;
    property ProgressBMain : TProgressBar read FProgressBar write FProgressBar;
    property LabelError : TLabel read FLabelError write FLabelError ;
    property RestartNeed : Boolean read FrestartNeed write FrestartNeed;
    property BypassInstance : Boolean read FbypassInstance;
//    property InitMode : Boolean read
  private
    function GetMagType(out LogRef: String): TMagType; overload;
    function GetMagType: TMagType; overload;
//CAF
    function GetMagMode(out LogRef: String): TMagMode; overload;
    function GetMagMode: TMagMode; overload;
//
  private
    FLogFreq: Integer;
    FLogType: TLogType;
    FLogRef: String; // GUID Lame pour les imports
    procedure InitializeLog;
    function FillLogRefWithLameGUID : string;
    procedure LogLastTickets;
    function GetStreamForFileName(const FileName: TFileName): String;
    procedure ForEachFileNames(const FileNames: TStringDynArray;
      Proc: TProc<String>);

    // Gestion Easy
    function ISEasyIgnore : Boolean;
  public
    property LogFreq: Integer read FLogFreq;
    property LogType: TLogType read FLogType;
    property LogRef: String read FLogRef;
  end;

  EExtractNotPlanned = class( Exception );
  EAbortStoreImport = class( Exception );
  EAbortStoreExport = class( Exception );
  EWebServiceUnavailable = class( Exception );

var
  DM_GSDataMain: TDM_GSDataMain;

implementation

{$R *.dfm}

uses
  Forms,
  GSDataMain_Frm,
  GSDataExport_DM,
  GSDataWebService_DM,
  GSData_TBaseExport,
  GSData_TIntegration,
  GestionJetonLaunch,
  u_I_BaseClientNationale,
  uTool,
  IdReplyRFC,
  GSDataSelection_Frm;

{ TDM_GSDataMain }

procedure TDM_GSDataMain.AddToLog(const AText: String);
var
  FileStream : TFileStream;
  StreamWriter: TStreamWriter;
  LogLine: String;
begin
  if FileExists( GLOGSPATH + GLOGSNAME ) then
  begin
    FileStream := TFileStream.Create( GLOGSPATH + GLOGSNAME, fmOpenReadWrite );
    FileStream.Seek( 0, soFromEnd );
  end else
    FileStream := TFileStream.Create( GLOGSPATH + GLOGSNAME, fmCreate );
  try
    StreamWriter := TStreamWriter.Create( FileStream, TEncoding.Default );
    try
      LogLine := Format( '[%s] %s', [ FormatDateTime( 'DD/MM/YYYY hh:mm:ss', Now ), AText ] );
      StreamWriter.WriteLine( LogLine );
    finally
      StreamWriter.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TDM_GSDataMain.AddToMemo(AText: String);
var
  FFile : TFileStream;
  sLigne : String;
  Buffer : TBytes;
  Encoding : TEncoding;
begin
  Log.Log( 'Main', '', '', 'Log', aText, logInfo, FAlse, 0, ltLocal ) ;
  With FMemo do
  begin
    sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] ',Now) + AText;
    if Assigned(FMemo) then
    begin
      FMemo.Lines.Add(sLigne);
    end;

    if FileExists(GLOGSPATH + GLOGSNAME) then
    begin
      FFile := TFileStream.Create(GLOGSPATH + GLOGSNAME,fmOpenReadWrite);
      FFile.Seek(0,soFromEnd);
    end else
      FFile := TFileStream.Create(GLOGSPATH + GLOGSNAME,fmCreate);
    try
      // Ajoute un retour à la ligne pour le fichier text
      sLigne := sLigne + #13#10;

      Encoding := TEncoding.Default;
      Buffer := Encoding.GetBytes(sLigne);
      FFile.Write(Buffer[0],Length(Buffer));
    finally
      FFile.Free;
    end;
    Sleep(50);
  end;
end;

procedure TDM_GSDataMain.ExecuteProcessImport(const Manuel: Boolean; const All : boolean);
var
  SelDosId : integer;
  SelMagId : TResultList;

  lstFileTemoin, lstFileChrono, lstDecoupe : TStringList;

  ClassTmp                : TMainClass;
  ClassMarque             : TMainClass;
//CAF
  ClassOPECOM             : TOpeCom;
//  ClassOPECOM            : TMainClass;
  ClassArticle            : TMainClass;
  ClassMultiColis         : TMainClass;
  ClassPackage            : TMainClass;
  ClassPrepack            : TMainClass;
  ClassNomenclature       : TNomenclature;
  classPrixVente          : TPrixVente;
  ClassFournisseur        : TMainClass;
  ClassCommande           : TMainClass;
  ClassReceptionEXPCAF    : TMainClass;
  ClassReceptionCESMAG    : TMainClass;

  ClassIntegrationOffre   : TIntegration;

  sPrefixe, sMAGNUM, sNumChronologique : String;
  USR_ID : Integer;
  iTypeMag : Integer;
//CAF
  iModeMag : Integer;
//
  iReferentiel : Integer;
  fReferentiel : Double;
  dDateFichier : TDateTime;

  vTimeDeb, vTimeImport, vTimeFin    : TTime;
  i, j, k, ImportFileNbr, vCumulAjout  : Integer;

  ArticleFile, NomenclatureFile : TStringDynArray;
  OPECOMFile, MarqueFile        : TStringDynArray;
  MultiColisFile, PackageFile   : TStringDynArray;
  PrixDeVenteFile               : TStringDynArray;
  PrepackFile , FournisseurFile : TStringDynArray;
  CommandeFile                  : TStringDynArray;
  ReceptionFileEXPCAF           : TStringDynArray;
  ReceptionFileCESMAG           : TStringDynArray;

  iEmptyParam : Integer;
  fEmptyParam : Double;
  sEmptyParam : String;

  iTentative : integer;     // Numero de tentative de prise de jeton
  tpJeton    : TTokenParams;   // Record avec les paramètres pour les Jetons
  TokenManager : TTokenManager;
  sAdresse : String;
  bJeton     : Boolean;        // Vrai si on a le jeton sinon faux
  FMSetting  : TFormatSettings;

  //Import Offre de réduction
  LastDateIntegr             : TDateTime;
  MaxDateIntegr              : TDateTime;
  IntegrationDir, ExtractDir : String;
  LstExtractTemoin           : TStringList;
  DosIntegreInit             : Integer;
  DosIntegreInitDate         : TDateTime;

  DateFicTemoin, NomTableFic              : String;
  LstDateTemoin, LstFicFileTemoin, LstCut : TStringList;
  DateTemoin                              : TDateTime;
  DateTemoinInit                          : TDateTime;
  DOSID                                   : Integer;

  InitMode                                : Boolean; //True si on est en mode integration (initialisation)
  iError      : Integer ;
  iCentrale   : Integer ;
  iBaseVersion : Integer ;
  bFTPErrorEncountered: Boolean;
  bAborted: Boolean;

  vListeNumEXPCAF, vListeNumCESMAG: String;
begin
  Log.Log( '', 'Main', '', '', '', 'Status', Format( 'Import %s...', [ IfThen( Manuel, 'manuel', 'automatique' ) ] ), logNotice, true, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  try
    bAborted := False;
    bJeton := false;
    clearErrors ;

    vListeNumEXPCAF := '';
    vListeNumCESMAG := '';

    {$REGION 'Initialisation'}
    GLOGSPATH := GAPPPATH + 'Logs\' + FormatDateTime('YYYY\MM\DD\',Now);
    GLOGSNAME := FormatDateTime('YYYYMMDDHHmmsszzz',Now) + '.txt';
    DoDir(GLOGSPATH);

    vCumulAjout := 0;
    iError      := 0 ;
    {$ENDREGION}

    AddToMemo('------------------------------------------------------');
    AddToMemo('Début du traitement : Import');
    AddToMemo('------------------------------------------------------');

    if Manuel and not All then
      SelDosId := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_ID').AsInteger;

    // Fermeture et ouverture de la base de données locale
    LoadClientDataSet( DM_GsDataDbCfg.cds_Dossiers, DM_GsDataDbCfg.Que_Dossiers );
    // Filtrer la base données pour ne traiter que les base avec même ID
    DM_GsDataDbCfg.cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s and DOS_ACTIVE = 1', [ QuotedStr( IniStruct.Others.IdGsData ) ] );

    // recupération des magasin a traité

    ClassTmp := TMainClass.Create;
    ClassTmp.IboQuery := Que_Class;

    lstDecoupe := TStringList.Create;

    SelMagId := TResultList.Create;
    try
      while Not DM_GsDataDbCfg.cds_Dossiers.Eof do
      begin
        if (Manuel and not all and (DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_ID').AsInteger = SelDosId)) or // import manuel selectionné
           (Manuel and All) or                                                                                  // import manuel complet
           (not manuel) then                                                                                    // import automatique
        begin
          // Ouverture d'un base de données de la liste.
          IboDbClient.Close;
          IboDbClient.DatabaseName := AnsiString(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString);
          Try
            Try
              AddToMemo('--- Traitement de la base : ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString);

              {$REGION ' Prise du jeton '}
              if not IniStruct.Others.NoJeton then
              begin
                Try
                  AddToMemo('Tentative de prise de jeton');
                  tpJeton := GetParamsToken(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString,'ginkoia','ginkoia');    //Prise en compte des Jetons

                  sAdresse := StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]);
                  TokenManager :=  TTokenManager.Create;
                  bJeton := TokenManager.tryGetToken(sAdresse,tpJeton.sDatabaseWS,tpJeton.sSenderWS,20,30000);

                  if bJeton then
                    AddToMemo('Jeton Acquis !!')
                  else
                    raise Exception.Create('Problème lors de l''obtention du jeton');

                Except on E:Exception do
                  raise Exception.Create('Jeton -> ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString + ' - ' + E.Message);
                End;
              end;
              {$ENDREGION}

              Log.Log( '', 'Main', '', '', '', 'Status', 'Connexion à la base de données: ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString, logNotice, false, DM_GSDataMain.LogFreq, ltLocal );
              try
                IboDbClient.Open;
                Log.Log( '', 'Main', '', '', '', 'Status', 'Connecté', logInfo, false, DM_GSDataMain.LogFreq, ltLocal );
              except
                on E: Exception do
                begin
                  Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, ltLocal );
                  raise;
                end;
              end;

              if ISEasyIgnore then
              begin
                AddToMemo('Traitement ignoré car bascule du dossiers sur EASY');
              end
              else
              begin


    //          Que_Class.Close ;
    //          Que_Class.SQL.Text := 'SELECT COUNT(TVT_ID) NB FROM TARVENTE WHERE TVT_CENTRALE = 6 AND TVT_NOM=''GOSPORT'' ' ;
    //          Que_Class.Open ;
    //
    //          if (Que_Class.FieldByName('NB').AsInteger > 0) then
    //          begin
    //            AddTomemo('Database Version 1') ;
    //            iBaseVersion := 1 ;
    //          end else begin
    //            AddTomemo('Database Version 2') ;
    //            iBaseVersion := 2 ;
    //          end;
    //
    //          Que_Class.Close ;

                if Manuel then
                  AddTomemo('FORCAGE MANUEL') ;
                iBaseVersion := 2 ;

                {$REGION 'Recalcul des index'}
                // Ne fonctionne qu'en SYSDBA, en pause pour le moment
      //          With Que_Tmp do
      //          begin
      //            Close;
      //            SQL.Clear;
      //            SQL.Add('Select * from REBUILD_STATISTIC;');
      //            AddToMemo('');
      //            AddToMemo(' Recalcul des index');
      //            vTimeDeb := Time;
      //
      //            Open;
      //            vTimeFin := Time;
      //            Close;
      //            AddToMemo(Format(' Recalcul traités en : %s',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb)]));
      //            AddToMemo('');
      //          end;
                {$ENDREGION}

                {$REGION ' ouverture des query '}
                // Récupération de la liste des magasins de la base de données
                Que_Magasins.Close;
                Que_Magasins.Open;
                // Récupératon des collections
                Que_Collections.Close;
                Que_Collections.Open;
                // Récupération de la liste des TVA
                Que_Tva.Close;
                Que_Tva.Open;

                // Récupération de la liste des MultiColis
                Que_MultiColis.Close;
                Que_MultiColis.Open;
                // Récupération de la liste des Packages
                Que_Package.Close;
                Que_Package.Open;
                // Récupération de la liste des Groupes de Packages
                Que_PackageGroupe.Close;
                Que_PackageGroupe.Open;
                // Récupération de la liste des Fournisseurs
                Que_Fournisseurs.Close();
                Que_Fournisseurs.Open();
                // Récupération de la liste des codes articles
                Que_ArtRelationArt.Close();
                Que_ArtRelationArt.Open();
                {$ENDREGION ' ouverture des query '}

                // en cas de traitement manuel non complet, afficher la liste des magasins.
                if (Manuel and not all) then
                  if not SelectInListe(Application.MainForm, 'Liste des magasins', Que_Magasins, 'mag_id', ['mag_codeadh', 'mag_enseigne'], ['Code Magasin', 'Nom Magasin'], SelMagId) then
                    raise EAbortStoreImport.Create('annulé');

                while Not Que_Magasins.Eof do
                begin
                  if (Manuel and not all and (SelMagId.indexOf(Que_Magasins.FieldByName('mag_id').AsInteger) <> -1 )) or // import manuel selectionné
                     (Manuel and All) or                                                                   // import manuel complet
                     (not manuel) then                                                                     // import automatique
                  begin
                    bFTPErrorEncountered := False; // Supposons qu'il n'y a pas d'erreur (S)FTP { Monitoring }
                    try
                      if DM_GsDataDbCfg.cds_Magasin.Locate('mag_idginkoia', Que_Magasins.FieldByName('MAG_ID').AsInteger, []) and
                         DM_GsDataDbCfg.cds_Magasin.FieldByName('mag_doimp').AsBoolean then
                      begin
                        AddToMemo('MAGASIN : ' + Que_Magasins.FieldByName('MAG_ENSEIGNE').AsString);
                        AddToMemo('');
                        // Récupération du code de configuration du magasin + le User
                        ClassTmp.GetGenParam(16,6,Que_Magasins.FieldByName('MAG_ID').AsInteger,USR_ID,fEmptyParam,sMagNum,False);
                        // Récupération du type de magasin
                        ClassTmp.GetGenParam(16,7,Que_Magasins.FieldByName('MAG_ID').AsInteger,iTypeMag,fEmptyParam,sEmptyParam,False);
                        // récupération du Référentiel magasin
                        ClassTmp.GetGenParam(16,8,Que_Magasins.FieldByName('MAG_ID').AsInteger,iEmptyParam, fReferentiel, sEmptyParam, False);
//CAF
                        // récupération du mode Affilié ou CAF
                        ClassTmp.GetGenParam(16,32,Que_Magasins.FieldByName('MAG_ID').AsInteger,iModeMag, fEmptyParam, sEmptyParam, False);
//
                        case TMagType(iTypeMag) of
                          mtCourir  : iCentrale := CTE_COURIR ;
                          mtGoSport : iCentrale := CTE_GOSPORT ;
                        end;

                        // Récupération de la liste des Marques
                        Que_Marque.Close;
                        Que_Marque.ParamCheck := true ;
                        Que_Marque.ParamByName('CENCODE').AsInteger := iCentrale ;
                        Que_Marque.Open;

                        // Récupération de la liste des OpeCom
                        Que_OPECOM.Close;
                        Que_OPECOM.ParamCheck := true ;
                        Que_OPECOM.ParamByName('CENCODE').AsInteger := iCentrale ;
                        Que_OPECOM.Open;

                        if trim(sMAGNUM) = '' then
                        begin
                          // Si pas de numéro de magasin alors on passe au suivant
                          AddToMemo('  - Pas de numéro magasin disponible');
                          Que_Magasins.Next;
                          Continue;
                        end;

                        // Chemin d'archivage des fichiers du type : Répertoire Application\Archive\Numéro magasin\Annee\Mois\Jour\
                        GDIRDOSSIER := GAPPDOSSIER + Format('%s\%s\',[sMagNum, FormatDateTime('YYYY\MM\DD',Now)]);
                        Log.Log('', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                          'Status', 'Traitement...', logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

                        // Récupération des informations sur le FTP pour le magasin
                        With DM_GSDataImport do
                        begin
                          {$REGION 'Gestion FTP/SFTP'}
                          Log.Log( '', 'FTP', '', '', '', 'Status', 'Téléchargement...', logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                          try
                            if ( IniStruct.FTP.Actif and OpenFTP and GetFileFromFTP(sMAGNUM,iTypeMag,1,IniStruct.FTPDir.Referentiel) ) then
                              CloseFTP;

                            if ( IniStruct.SFTP.Actif and OpenSFTP and GetFileFromSFTP( sMAGNUM, iTypeMag, 1, IniStruct.SFTPDir.Referentiel )) then
                              CloseSFTP;

                            if GERREURS.Count = 0 then
                              Log.Log( '', 'FTP', '', '', '', 'Status', 'Ok', logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                            else
                              Log.Log( '', 'FTP', '', '', '', 'Status', Format( '%d erreurs', [ GERREURS.Count ] ), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                          except
                            on E: EIdReplyRFCError do
                              Log.Log( '', 'FTP', '', '', '', 'Status', 'Ok', logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                            on E: Exception do
                            begin
                              bFTPErrorEncountered := True;
                              Log.Log( '', 'FTP', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                            end;
                          end;
                          {$ENDREGION 'Gestion FTP/SFTP'}

                          {$REGION  'Chargement des Fichiers à traiter'}
                          try
                            lstFileTemoin := GetFileFromDir(GAPPFTP, 'TEMOIN' + sMAGNUM + '.*.*');
                            LstFileTemoin.Sort;

                            ImportFileNbr := lstFileTemoin.Count;
                            for i := 0 to ImportFileNbr -1 do
                            begin
                              sNumChronologique := Copy(lstFileTemoin[i],Pos('.',lstFileTemoin[i]) + 1,Length(lstFileTemoin[i]));
                              sNumChronologique := Copy(sNumChronologique,1,Pos('.',sNumChronologique) -1);

                              lstDecoupe.Text := StringReplace(lstFileTemoin[i],'.',#13#10,[rfReplaceAll]);

                              lstFileChrono := GetFileFromDir(GAPPFTP, '*' + sMAGNUM + '*.' + lstDecoupe[2]);
                              try
                                try
                                //Vérification que la date est bien supérieur à la date du dernier traitement
                                dDateFichier := ConvertToDate(lstDecoupe[2]);

                                if not (CompareDateTime(dDateFichier, fReferentiel) = greaterThanValue) then
                                  raise Exception.Create(Format(' - Traitement annulé, Numéro référentiel inférieur ou égal : En cours %s - En base %s ',[FormatDateTime('DD/MM/YYYY hh:mm:ss',dDateFichier),Formatdatetime('DD/MM/YYYY hh:mm:ss',fReferentiel)]));
                                Except on E: Exception do
                                  begin
                                    AddToMemo(e.Message);
                                    DeplacerFichier(GAPPFTP,GDIRDOSSIER,lstFileChrono);
                                    Continue;
                                  end;
                                end;

                                {$REGION 'Initialisation des tableaux & CDS'}
                                ClearCds;

                                SetLength(ArticleFile, 0);
                                SetLength(MarqueFile, 0);
                                SetLength(NomenclatureFile, 0);
                                SetLength(OPECOMFile, 0);
                                SetLength(MultiColisFile, 0);
                                SetLength(PackageFile, 0);
                                SetLength(PrixDeVenteFile, 0);
                                SetLength(PrepackFile, 0);
                                SetLength(FournisseurFile,0);
                                SetLength(CommandeFile,0);
                                SetLength(ReceptionFileEXPCAF,0);
                                SetLength(ReceptionFileCESMAG,0);
                                {$ENDREGION}

                                // Début de traitement des fichiers à intégrer
                                AddToMemo(' Traitement des fichiers :');
                                for j := 0 to lstFileChrono.Count -1 do
                                begin
                                  sPrefixe := Copy(lstFileChrono[j],1, 6);
                                  {$REGION 'Chargement des fichiers en mémoire'}
                                  try
                                    case AnsiIndexStr(UpperCase(sPrefixe),['GRPCAF','ARBCAF','MARQUE','MODELE',
                                                                           'ARTICL','MODSFA','OPECOM','PRXVTE',
                                                                           'MULTCO','PACKENT','PACKLIG','PACKAG',
                                                                           'ADRFRN','WCDEHA','EXPCAF','CESMAG',
                                                                           'CDEAFF']) of
                                      0:  begin   // GRPCAF- Nomenclature
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_GRPCAF);
                                            SetLength(NomenclatureFile,Length(NomenclatureFile) + 1);
                                            NomenclatureFile[Length(NomenclatureFile)-1] := lstFileChrono[j];
                                          end;
                                      // ARBCAF
                                      1:  LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_ARBCAF);
                                      2:  begin   // MARQUE - Marque
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_MARQUE);
                                            SetLength(MarqueFile,Length(MarqueFile) + 1);
                                            MarqueFile[Length(MarqueFile)-1] := lstFileChrono[j];
                                          end;
                                      3:  begin   // MODELE - Article
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_MODELE);
                                            SetLength(ArticleFile,Length(ArticleFile) + 1);
                                            ArticleFile[Length(ArticleFile)-1] := lstFileChrono[j];
                                          end;
                                      4:  begin   // ARTICL - Article
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_ARTICL);
                                            SetLength(ArticleFile,Length(ArticleFile) + 1);
                                            ArticleFile[Length(ArticleFile)-1] := lstFileChrono[j];
                                          end;
                                      5:  begin   // MODSFA - Article
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_MODSFA);
                                            SetLength(ArticleFile,Length(ArticleFile) + 1);
                                            ArticleFile[Length(ArticleFile)-1] := lstFileChrono[j];
                                          end;
                                      6:  begin   // OPECOM - OPECOM
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_OPECOM);
                                            SetLength(OPECOMFile,Length(OPECOMFile) + 1);
                                            OPECOMFile[Length(OPECOMFile)-1] := lstFileChrono[j];
                                          end;
                                      7:  begin   // PRXVTE - Prix de Vente
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_PRXVTE);
                                            SetLength(PrixDeVenteFile,Length(PrixDeVenteFile) + 1);
                                            PrixDeVenteFile[Length(PrixDeVenteFile)-1] := lstFileChrono[j];
                                          end;
                                      8:  begin   // MULTCO - MultiColis
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_MULTCO);
                                            SetLength(MultiColisFile,Length(MultiColisFile) + 1);
                                            MultiColisFile[Length(MultiColisFile)-1] := lstFileChrono[j];
                                          end;
                                      9:  begin   // PACKENT - Prépack
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_PACKENT);
                                            SetLength(PrepackFile,Length(PrepackFile) + 1);
                                            PrepackFile[Length(PrepackFile) -1] := lstFileChrono[j];
                                          end;
                                      10: begin   // PACKLIG - Prépack
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_PACKLIG);
                                            SetLength(PrepackFile,Length(PrepackFile) + 1);
                                            PrepackFile[Length(PrepackFile) -1] := lstFileChrono[j];
                                          end;
                                      11: begin   // PACKAG - Package
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_PACKAG);
                                            SetLength(PackageFile,Length(PackageFile) + 1);
                                            PackageFile[Length(PackageFile)-1] := lstFileChrono[j];
                                      end;
                                      12: begin // ADRFRN - Fournisseur
                                            LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_ADRFRN);
                                            SetLength(FournisseurFile,Length(FournisseurFile) + 1);
                                            FournisseurFile[Length(FournisseurFile) -1] := lstFileChrono[j];
                                      end;
                                      13: begin // WCDEHA - Commandes
                                          LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_WCDEHA, False);
                                          SetLength(CommandeFile, Length(CommandeFile) + 1);
                                          CommandeFile[Length(CommandeFile) -1] := lstFileChrono[j];
                                      end;
                                      14 : begin // EXPCAF - réception
                                          LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_EXPCAF, False);
                                          SetLength(ReceptionFileEXPCAF,Length(ReceptionFileEXPCAF) + 1);
                                          ReceptionFileEXPCAF[Length(ReceptionFileEXPCAF) -1] := lstFileChrono[j];
                                      end;
                                      15 : begin // CESMAG - réceptions
                                          LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_CESMAG, False);
                                          SetLength(ReceptionFileCESMAG,Length(ReceptionFileCESMAG) + 1);
                                          ReceptionFileCESMAG[Length(ReceptionFileCESMAG) -1] := lstFileChrono[j];
                                      end;
                                      16: begin // CDEAFF - Commandes
                                          LoadCsvToCDS(GAPPFTP + lstFileChrono[j],cds_CDEAFF, False);
                                          SetLength(CommandeFile, Length(CommandeFile) + 1);
                                          CommandeFile[Length(CommandeFile) -1] := lstFileChrono[j];
                                      end;
                                    end;
                                  Except on E:exception do
                                    begin
                                      AddToMemo(E.Message);
                                      DeplacerFichier(GAPPFTP,GDIRDOSSIER,lstFileChrono);
                                    end;
                                  end;
                                  AddToMemo('  - Fichier : ' + lstFileChrono[j]);
                                  {$ENDREGION}
                                end; // for

                                {$REGION ' Marques '}
                                ClassMarque := TMarque.Create;
                                with Tmarque(ClassMarque) do
                                begin
                                  MarqueTable := Que_Marque;
                                  MAG_TYPE    := TMagType(iTypeMag) ;
                                  BASE_VER    := iBaseVersion ;
                                  LabProgress := FLabel;
                                  ProgressBar := FProgressBar;
                                  LabError    := FLabelError ;
                                  IboQuery    := Que_Class;
                                end;

                                if Length(MarqueFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des Marques');
                                  ForEachFileNames(
                                    MarqueFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  //ClassMarque := TMarque.Create;
          //                        ClassMarque.IboQuery  := que_Class;
                                  ClassMarque.FilesPath := MarqueFile;
                                  //with TMarque(ClassMarque) do
                                  //begin
                                    //MarqueTable := Que_Marque;
                                    //LabProgress := FLabel;
                                    //ProgressBar := FProgressBar;
                                  //end;
                                  ClassMarque.Import;
                                  ClassMarque.DoMajTable;
                                  INC(vCumulAjout, ClassMarque.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassMarque.ErrorTotal ;
                                  AddToMemo(Format(' Marques traitées en : %s - Ajout : %d - Modif : %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassMarque.Insertcount,ClassMarque.Majcount,ClassMarque.ErrorTotal]));
                                  ForEachFileNames(
                                    MarqueFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassMarque.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassMarque.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION ' Marques'}

                                {$REGION 'Fournisseur'}
                                ClassFournisseur := TFournisseurClass.Create;
                                ClassFournisseur.IboQuery := Que_Class;
                                ClassFournisseur.MAG_TYPE := TMagType(iTypeMag) ;
                                ClassFournisseur.BASE_VER := iBaseVersion ;

                                if Length(FournisseurFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des fournisseurs');
                                  ForEachFileNames(
                                    FournisseurFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  //ClassFournisseur := TFournisseurClass.Create;
                                  //ClassFournisseur.IboQuery := Que_Class;
                                  ClassFournisseur.FilesPath := FournisseurFile;
                                  ClassFournisseur.Import;
                                  ClassFournisseur.DoMajTable;
                                  Inc(vCumulAjout, ClassFournisseur.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassFournisseur.ErrorTotal ;
                                  AddToMemo(Format(' Fournisseurs traités en : %s - Ajout : %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassFournisseur.Insertcount,ClassFournisseur.Majcount,ClassFournisseur.ErrorTotal]));
                                  ForEachFileNames(
                                    FournisseurFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassFournisseur.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassFournisseur.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION}

                                {$REGION ' OPECOM '}
                                ClassOPECOM           := TOpeCom.Create;
                                ClassOPECOM.IboQuery  := que_Class;
                                ClassOPECOM.MAG_TYPE  := TMagType(iTypeMag);
//CAF
                                ClassOPECOM.MAG_MODE  := TMagMode(iModeMag);
//
                                ClassOPECOM.BASE_VER  := iBaseVersion ;

                                with TOpeCom(ClassOPECOM) do
                                begin
                                  Que_OpeCom := DM_GSDataMain.Que_OpeCom;
                                  LabProgress := FLabel;
                                  ProgressBar := FProgressBar;
                                end;

                                if Length(OpeComFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des OC');
                                  ForEachFileNames(
                                    OpeComFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  //ClassOPECOM := TOpeCom.Create;
                                  //ClassOPECOM.IboQuery  := que_Class;
                                  ClassOPECOM.FilesPath := OpeComFile;
                                  ClassOPECOM.MAG_ID := Que_Magasins.FieldByName('MAG_ID').AsInteger;
          //                        with TOpeCom(ClassOPECOM) do
          //                        begin
          //                          Que_OpeCom := DM_GSDataMain.Que_OpeCom;
          //                          LabProgress := FLabel;
          //                          ProgressBar := FProgressBar;
          //                        end;
                                  ClassOPECOM.Import;
                                  ClassOPECOM.DoMajTable;
                                  INC(vCumulAjout, ClassOPECOM.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassOPECOM.ErrorTotal ;
                                  AddToMemo(Format(' OC traités en : %s - Ajout %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassOPECOM.Insertcount,ClassOPECOM.Majcount,ClassOPECOM.ErrorTotal]));
                                  ForEachFileNames(
                                    OpeComFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassOPECOM.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassOPECOM.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION ' OC'}

                                {$REGION ' Nomenclature '}
                                ClassNomenclature := TNomenclature.Create;
                                ClassNomenclature.MAG_TYPE := TMagType(iTypeMag) ;
                                ClassNomenclature.BASE_VER := iBaseVersion ;
                                with ClassNomenclature do
                                begin
                                  IboQuery    := que_Class;
                                  FilesPath   := NomenclatureFile;
                                  LabProgress := FLabel;
                                  ProgressBar := FProgressBar;
                                  LabError    := FLabelError ;
                                end;

                                if Length(NomenclatureFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement de la Nomenclature');
                                  ForEachFileNames(
                                    NomenclatureFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  //ClassNomenclature := TNomenclature.Create;
          //                        with ClassNomenclature do
          //                        begin
          //                          IboQuery    := que_Class;
          //                          FilesPath   := NomenclatureFile;
          //                          LabProgress := FLabel;
          //                          ProgressBar := FProgressBar;
          //                        end;
                                  ClassNomenclature.Import;
                                //  ClassNomenclature.AfficherArborescence(Frm_GSDataMain.trvNomenclature);   //Ne pas decommenter
                                  ClassNomenclature.DoMajTable;
                                  INC(vCumulAjout, ClassNomenclature.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassNomenclature.ErrorTotal ;
                                  AddToMemo(Format(' Nomenclature traitées en : %s - Ajout %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassNomenclature.Insertcount,ClassNomenclature.Majcount,ClassNomenclature.ErrorTotal]));
                                  ForEachFileNames(
                                    NomenclatureFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassNomenclature.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassNomenclature.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION ' Nomenclature'}

                                {$REGION ' Articles '}
                                ClassArticle := TArticleClass.Create;
                                ClassArticle.IboQuery  := Que_Class;
                                ClassArticle.MAG_TYPE  := TMagType(iTypeMag) ;
                                ClassArticle.BASE_VER  := iBaseVersion ;
                                With TArticleClass(ClassArticle) do
                                begin
                                  MAG_ID          := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                                  TVATable        := Que_Tva;
                                  CollectionTable := Que_Collections;
                                  Marque          := ClassMarque;
                                  Nomenclature    := ClassNomenclature;
                                  LabProgress     := FLabel;
                                  ProgressBar     := FProgressBar;
                                  LabError        := FLabelError ;
                                end;

                                if Length(ArticleFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des Articles');
                                  ForEachFileNames(
                                    ArticleFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  ClassArticle.FilesPath := ArticleFile;

                                  AddToMemo(' - Import des Articles');
                                  ClassArticle.Import;
                                  vTimeImport := Time ;
                                  AddToMemo(Format(' - Articles importés en %s', [FormatDateTime('[hh:mm:ss] ',vTimeImport - vTimeDeb)]));

                                  AddToMemo(' - Intégration des Articles');
                                  ClassArticle.DoMajTable;
                                  vTimeFin := Time;
                                  AddToMemo(Format(' - Articles intégrés en %s', [FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeImport)]));

                                  INC(vCumulAjout, ClassArticle.Insertcount);
                                  iError := iError + ClassArticle.ErrorTotal ;
                                  AddToMemo(Format(' Articles traités en : %s - Ajout %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassArticle.Insertcount,ClassArticle.Majcount, ClassArticle.ErrorTotal]));
                                  ForEachFileNames(
                                    ArticleFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassArticle.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassArticle.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION ' Articles'}

                                {$REGION ' Multi-colis '}
                                if Length(MultiColisFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des Multi-colis');
                                  ForEachFileNames(
                                    MultiColisFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  ClassMultiColis := TMultiColis.Create;
                                  ClassMultiColis.IboQuery  := que_Class;
                                  ClassMultiColis.FilesPath := MultiColisFile;
                                  ClassMultiColis.MAG_TYPE  := TMagType(iTypeMag) ;
                                  ClassMultiColis.BASE_VER  := iBaseVersion ;
                                  with TMultiColis(ClassMultiColis) do
                                  begin
                                    MAG_ID          := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                                    LabProgress := FLabel;
                                    ProgressBar := FProgressBar;
                                    LabError    := FLabelError ;
                                    RelationArticle := TArticleClass(ClassArticle).ArtRelationArt;
                                  end;
                                  ClassMultiColis.Import;
                                  ClassMultiColis.DoMajTable;
                                  INC(vCumulAjout, ClassMultiColis.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassMultiColis.ErrorTotal ;
                                  AddToMemo(Format(' Multi-colis traitées en : %s - Ajout %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassMultiColis.Insertcount,ClassMultiColis.Majcount, ClassMultiColis.ErrorTotal]));
                                  ForEachFileNames(
                                    MultiColisFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassMultiColis.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassMultiColis.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION ' Multi-colis'}

                                {$REGION ' Packages '}
                                if Length(PackageFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des Packages');
                                  ForEachFileNames(
                                    PackageFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  ClassPackage                := TPackage.Create();
                                  ClassPackage.IboQuery       := Que_Class;
                                  ClassPackage.MAG_TYPE       := TMagType(iTypeMag) ;
                                  ClassPackage.BASE_VER       := iBaseVersion ;
                                  ClassPackage.FilesPath      := PackageFile;
                                  ClassPackage.LabProgress    := FLabel;
                                  ClassPackage.ProgressBar    := FProgressBar;
                                  ClassPackage.LabError       := FLabelError ;
                                  ClassPackage.MAG_ID         := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                                  ClassPackage.MAG_CODEADH    := Que_Magasins.FieldByName('MAG_CODEADH').AsString;
                                  ClassPackage.Import();
                                  ClassPackage.DoMajTable();
                                  Inc(vCumulAjout, ClassPackage.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassPackage.ErrorTotal ;
                                  AddToMemo(Format(' Packages traités en : %s - Ajout %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassPackage.Insertcount,ClassPackage.Majcount, ClassPackage.ErrorTotal]));
                                  ForEachFileNames(
                                    PackageFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassPackage.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassPackage.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION ' Packages'}

                                {$REGION ' Prepack '}
                                if Length(PrepackFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des Prepack');
                                  ForEachFileNames(
                                    PrepackFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  ClassPrepack := TPrePackClass.Create;
                                  ClassPrepack.IboQuery := Que_Class;
                                  ClassPrepack.MAG_TYPE := TMagType(iTypeMag) ;
                                  ClassPrepack.FilesPath := PrepackFile;
                                  ClassPrepack.Import;
                                  ClassPrepack.DoMajTable;
                                  INC(vCumulAjout, ClassPrepack.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassPrepack.ErrorTotal ;
                                  AddToMemo(Format(' Articles traités en : %s - Ajout %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassPrepack.Insertcount,ClassPrepack.Majcount, ClassPrepack.ErrorTotal]));
                                  ForEachFileNames(
                                    PrepackFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassPrepack.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassPrepack.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION}

                                {$REGION ' Prix de vente '}
                                ClassPrixVente           := TPrixVente.Create;
                                ClassPrixVente.IboQuery  := que_Class;
                                ClassPrixVente.MAG_TYPE  := TMagType(iTypeMag) ;
//CAF
                                ClassPrixVente.MAG_MODE   := TMagMode(iModeMag);
//
                                ClassPrixVente.MAG_ID    := Que_Magasins.FieldByName('MAG_ID').AsInteger ;
                                ClassPrixVente.BASE_VER  := iBaseVersion ;

                                with TPrixVente(ClassPrixVente) do
                                begin
                                  ArticleFichier  := TArticleClass(ClassArticle).ArtArticle;
                                  RelationArticle := TArticleClass(ClassArticle).ArtRelationArt;
                                  OpeCom          := TOpecom(ClassOPECOM);
                                  LabProgress     := FLabel;
                                  ProgressBar     := FProgressBar;
                                  LabError        := FLabelError ;
                                end;

                                if Length(PrixDeVenteFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des Prix de Vente');
                                  ForEachFileNames(
                                    PrixDeVenteFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  ClassPrixVente.FilesPath := PrixDeVenteFile;
                                  ClassPrixVente.Import;
                                  ClassPrixVente.DoMajTable;
                                  INC(vCumulAjout, ClassPrixVente.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassPrixVente.ErrorTotal ;
                                  AddToMemo(Format(' Prix de Vente traités en : %s - Ajout %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassPrixVente.Insertcount,ClassPrixVente.Majcount, ClassPrixVente.ErrorTotal]));
                                  ForEachFileNames(
                                    PrixDeVenteFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassPrixVente.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassPrixVente.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION ' Prix de vente'}

                                {$REGION 'Commandes'}
                                if Length(CommandeFile) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des commandes');
                                  ForEachFileNames(
                                    CommandeFile,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                  vTimeDeb := Time;
                                  ClassCommande := TCommandeClass.Create;
                                  ClassCommande.IboQuery    := Que_Class;
                                  ClassCommande.IBOStoredProc := IBOStoredProc;
                                  ClassCommande.FilesPath   := CommandeFile;
                                  ClassCommande.MAG_CODEADH := sMAGNUM;
                                  ClassCommande.MAG_ID      := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                                  ClassCommande.MAG_TYPE    := TMagType(iTypeMag) ;
                                  ClassCommande.MAG_MODE    := TMagMode(iModeMag);
                                  ClassCommande.BASE_VER    := iBaseVersion ;
                                  ClassCommande.IboQueryTmp := Que_Tmp;
                                  With TCommandeClass(ClassCommande) do
                                  begin
                                    Fournisseur := ClassFournisseur;
                                    ArticleFichier := TArticleClass(ClassArticle).ArtArticle;
                                    ArtRelationArt := TArticleClass(ClassArticle).ArtRelationArt;
                                    Collections := Que_Collections;
                                    LabProgress     := FLabel;
                                    ProgressBar     := FProgressBar;
                                    LabError        := FLabelError ;
                                  end;
                                  ClassCommande.Import;
                                  ClassCommande.DoMajTable;
                                  Inc(vCumulAjout, ClassCommande.Insertcount);
                                  vTimeFin := Time;
                                  iError := iError + ClassCommande.ErrorTotal ;
                                  AddToMemo(Format(' Commandes traitées en : %s - Ajout %d - Modif %d - Erreur %d',[FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),ClassCommande.Insertcount,ClassCommande.Majcount, ClassCommande.ErrorTotal]));
                                  ForEachFileNames(
                                    CommandeFile,
                                    procedure(FileName: string)
                                    begin
                                      if ClassCommande.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassCommande.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                    end
                                  );
                                end;
                                {$ENDREGION}

                                {$REGION 'Réception EXPCAF'}
                                if Length(ReceptionFileEXPCAF) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des réceptions EXPCAF');
                                  ForEachFileNames(
                                    ReceptionFileEXPCAF,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );

                                  cds_EXPCAF.First;
                                  while not cds_EXPCAF.Eof do
                                  begin
                                    if not ContainsStr(vListeNumEXPCAF, cds_EXPCAF.FieldByName('02_NUM_BT').AsString) then
                                    begin
                                      if vListeNumEXPCAF <> '' then
                                        vListeNumEXPCAF := vListeNumEXPCAF + ', ';
                                      vListeNumEXPCAF := vListeNumEXPCAF + cds_EXPCAF.FieldByName('02_NUM_BT').AsString;
                                    end;
                                    cds_EXPCAF.Next;
                                  end;

                                  vTimeDeb                                                  := Time;
                                  ClassReceptionEXPCAF                                      := TReceptionClass.Create();
                                  ClassReceptionEXPCAF.IboQuery                             := Que_Class;
                                  ClassReceptionEXPCAF.MAG_TYPE                             := TMagType(iTypeMag) ;
                                  ClassReceptionEXPCAF.BASE_VER                             := iBaseVersion ;
                                  ClassReceptionEXPCAF.FilesPath                            := ReceptionFileEXPCAF;
                                  TReceptionClass(ClassReceptionEXPCAF).MAG_ID              := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                                  TReceptionClass(ClassReceptionEXPCAF).MAG_CODEADH         := Que_Magasins.FieldByName('MAG_CODEADH').AsString;
                                  TReceptionClass(ClassReceptionEXPCAF).LabProgress         := FLabel;
                                  TReceptionClass(ClassReceptionEXPCAF).LabError            := FLabelError ;
                                  TReceptionClass(ClassReceptionEXPCAF).ProgressBar         := FProgressBar;
                                  TReceptionClass(ClassReceptionEXPCAF).cds_ReceptionImport := cds_EXPCAF;
                                  if Assigned(ClassArticle) then
                                  begin
                                    TReceptionClass(ClassReceptionEXPCAF).ArtRelationArt    := TArticleClass(ClassArticle).ArtRelationArt;
                                    TReceptionClass(ClassReceptionEXPCAF).BArtRelationArt   := True;
                                  end else
                                  begin
                                    TReceptionClass(ClassReceptionEXPCAF).BArtRelationArt   := False;
                                  end;

                                  // Nécessaire pour faire un commit :  indispensable pour le recalcul.
                                  {TODO -oJO : Rollback des modifications de Ludwig NOESSER, trouver une autre solution (2016-04-07)}
//                                IboDbClient.Close;
//                                IboDbClient.Open;

                                  // Recalcul des stocks, des pump, et du RAL.
                                  if DM_GSDataExport.CalculStockDiff then
                                  begin
                                    ClassReceptionEXPCAF.Import();
                                    ClassReceptionEXPCAF.DoMajTable();
                                    Inc(vCumulAjout, ClassReceptionEXPCAF.Insertcount);
                                    vTimeFin                                                  := Time;
                                    iError := iError + ClassReceptionEXPCAF.ErrorTotal ;
                                    AddToMemo(Format(' Réceptions EXPCAF traitées en : %s - Ajout %d - Modif %d - Erreur %d',
                                      [FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),
                                      ClassReceptionEXPCAF.Insertcount, ClassReceptionEXPCAF.Majcount, ClassReceptionEXPCAF.ErrorTotal]));
                                    ForEachFileNames(
                                      ReceptionFileEXPCAF,
                                      procedure(FileName: string)
                                      begin
                                        if ClassReceptionEXPCAF.ErrorTotal = 0 then
                                          Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                            GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                        else
                                          Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                            GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassReceptionEXPCAF.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                      end
                                    );
                                  end
                                  else
                                  begin
                                    // Si le recalcul échoue, il ne faut pas traiter les fichiers EXPCAF.
                                    AddToMemo(' -> erreur lors du recalcul');
                                    ForEachFileNames(
                                      ReceptionFileEXPCAF,
                                      procedure(FileName: string)
                                      begin
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Avertissement', [FileName]), logWarning, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                      end
                                    );
                                    Exit;
                                  end;
                                end;
                                {$ENDREGION}

                                {$REGION 'Réception CESMAG'}
                                if Length(ReceptionFileCESMAG) > 0 then
                                begin
                                  AddToMemo('');
                                  AddToMemo(' Début traitement des réceptions CESMAG');
                                  ForEachFileNames(
                                    ReceptionFileCESMAG,
                                    procedure(FileName: string)
                                    begin
                                      Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        GetStreamForFileName(FileName), Format('%s : Traitement...', [FileName]), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );

                                  cds_CESMAG.First;
                                  while not cds_CESMAG.Eof do
                                  begin
                                    if not ContainsStr(vListeNumCESMAG, cds_CESMAG.FieldByName('02_NUM_BT').AsString) then
                                    begin
                                      if vListeNumCESMAG <> '' then
                                        vListeNumCESMAG := vListeNumCESMAG + ', ';
                                      vListeNumCESMAG := vListeNumCESMAG + cds_CESMAG.FieldByName('02_NUM_BT').AsString;
                                    end;
                                    cds_CESMAG.Next;
                                  end;

                                  vTimeDeb                                                  := Time;
                                  ClassReceptionCESMAG                                      := TReceptionClass.Create();
                                  ClassReceptionCESMAG.IboQuery                             := Que_Class;
                                  ClassReceptionCESMAG.FilesPath                            := ReceptionFileCESMAG;
                                  ClassReceptionCESMAG.MAG_TYPE                             := TMagType(iTypeMag) ;
                                  ClassReceptionCESMAG.BASE_VER                             := iBaseVersion ;
                                  TReceptionClass(ClassReceptionCESMAG).MAG_ID              := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                                  TReceptionClass(ClassReceptionCESMAG).MAG_CODEADH         := Que_Magasins.FieldByName('MAG_CODEADH').AsString;
                                  TReceptionClass(ClassReceptionCESMAG).LabProgress         := FLabel;
                                  TReceptionClass(ClassReceptionCESMAG).LabError            := FLabelError ;
                                  TReceptionClass(ClassReceptionCESMAG).ProgressBar         := FProgressBar;
                                  TReceptionClass(ClassReceptionCESMAG).cds_ReceptionImport := cds_CESMAG;
                                  if Assigned(ClassArticle) then
                                  begin
                                    TReceptionClass(ClassReceptionCESMAG).ArtRelationArt    := TArticleClass(ClassArticle).ArtRelationArt;
                                    TReceptionClass(ClassReceptionCESMAG).BArtRelationArt   := True;
                                  end else
                                  begin
                                    TReceptionClass(ClassReceptionCESMAG).BArtRelationArt   := False;
                                  end;
                                  ClassReceptionCESMAG.Import();
                                  ClassReceptionCESMAG.DoMajTable();
                                  Inc(vCumulAjout, ClassReceptionCESMAG.Insertcount);
                                  vTimeFin                                                  := Time;
                                  iError := iError + ClassReceptionCESMAG.ErrorTotal ;
                                  AddToMemo(Format(' Réceptions CESMAG traitées en : %s - Ajout %d - Modif %d - Erreur %d',
                                    [FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb),
                                    ClassReceptionCESMAG.Insertcount, ClassReceptionCESMAG.Majcount, ClassReceptionCESMAG.ErrorTotal]));
                                  ForEachFileNames(
                                    ReceptionFileCESMAG,
                                    procedure(FileName: string)
                                    begin
                                      if ClassReceptionCESMAG.ErrorTotal = 0 then
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : Ok', [FileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                                      else
                                        Log.Log( '', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          GetStreamForFileName(FileName), Format('%s : %d Erreur(s)', [FileName, ClassReceptionCESMAG.ErrorTotal]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end
                                  );
                                end;
                                {$ENDREGION}

                                {$REGION 'Déplacement des fichiers'}
                                DeplacerFichier(GAPPFTP,GDIRDOSSIER,lstFileChrono);
                                {$ENDREGION}

                                // Sauvegarde du nouveau numéro référentiel
                                ClassTmp.SetGenparam(16,8,0, dDateFichier, Que_Magasins.FieldByName('MAG_ID').AsInteger);
                                AddToMemo(' ');
                              finally
                                lstFileChrono.Free;

                                {$REGION 'Libération des différentes classes'}
                                if Assigned(ClassNomenclature) then
                                  FreeAndNil(ClassNomenclature);

                                if Assigned(ClassMarque) then
                                  FreeAndNil(ClassMarque);

                                if Assigned(ClassOpeCom) then
                                  FreeAndNil(ClassOpeCom);

                                if Assigned(ClassArticle) then
                                  FreeAndNil(ClassArticle);

                                if Assigned(ClassMultiColis) then
                                  FreeAndNil(ClassMultiColis);

                                if Assigned(ClassPackage) then
                                  FreeAndNil(ClassPackage);

                                if Assigned(ClassPrixVente) then
                                  FreeAndNil(ClassPrixVente);

                                if Assigned(ClassCommande) then
                                  FreeAndNil(ClassCommande);

                                if Assigned(ClassReceptionEXPCAF) then
                                  FreeAndNil(ClassReceptionEXPCAF);

                                if Assigned(ClassReceptionCESMAG) then
                                  FreeAndNil(ClassReceptionCESMAG);
                                {$ENDREGION 'Libération des différentes classes'}
                              end;
                            end;
                          finally
                            lstFileTemoin.Free;
                          end;
                          {$ENDREGION}

                        end; // with

                        if ( not bFTPErrorEncountered ) and ( GERREURS.Count = 0 ) then
                          Log.Log('', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                            'Status', 'Ok', logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                        else
                          Log.Log('', 'Import', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                            'Status', Format('%d Erreurs(s) : %s', [GERREURS.Count, GERREURS[GERREURS.Count-1].Text]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

                        {$REGION ' Rapport '}
                        if ImportFileNbr > 0 then
                        begin
                          AddToMemo('');
                          AddToMemo(' Début traitement du Rapport');
                          vTimeDeb := Time;
                          FRapport := TRapportClass.Create;
                          try
                            Try
                              FRapport.Erreurs := GERREURS;
                              FRapport.IdSMTP := IDSmtp1;
                              FRapport.MAG_CODEADH := sMagNum;
                              FRapport.ListeNumEXPCAF := vListeNumEXPCAF;
                              FRapport.ListeNumCESMAG := vListeNumCESMAG;
                              FRapport.CreateHtml;
                              FRapport.SendMail;
                            Except
                              on E:Exception do
                              begin
                                AddToMemo(E.Message);
                                //DeplacerFichier(GAPPFTP,GDIRDOSSIER,lstFileChrono);
                              end;
                            End;
                          finally
                            FRapport.Free;
                          end;
                          vTimeFin := Time;
                          AddToMemo(' Rapport traité en : ' + FormatDateTime('[hh:mm:ss] ',vTimeFin - vTimeDeb));
                          AddToMemo('');
                          {$ENDREGION ' Rapport'}

                        end;
                        // Suppression de toutes les erreurs générées
                        GERREURS.Clear;
                      end
                      else if manuel and not all then
                        AddToMemo('  --> ATTENTION : magasin non paramétré pour l''import');
                    except
                      on E: Exception do
                        AddToMemo( E.Message );
                    end;
                  end;
                  // Passage au magasin suivant
                  Que_Magasins.Next;
                end; // while Que_Mag


                {$REGION 'Offre de réduction'}

                {$REGION 'Initialisation'}
                // Offre de réduction , récupération du dossier de depose , d'integration et la date de derniere integration
                LastDateIntegr     := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_INTEGRELASTDATE').AsDateTime;
                IntegrationDir     := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_INTEGREDIR').AsString;
                ExtractDir         := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_EXTRACTDIR').AsString;

                DosIntegreInit     := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_INTEGREINIT').AsInteger; //Mode Initialisation
                DosIntegreInitDate := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_INTEGREINITDATE').AsDateTime;

                DOSID              := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_ID').AsInteger;

                InitMode           := DosIntegreInit = 1;

                //Je nettoie les Cds d'offre de réduction
                Dm_GSDataExtract.ClearCdsExtract;

                LstDateTemoin := TStringList.Create;

                //Création Class Offre de réduction
                ClassIntegrationOffre          := TIntegration.Create;
                ClassIntegrationOffre.IboQuery := Que_Class;
                ClassIntegrationOffre.CreateCds;

                {$ENDREGION}

                {$REGION 'Chargement des fichiers'}

                {$REGION 'Integration des offres'}
                with Dm_GSDataExtract do
                begin
                  {$REGION 'Clear Cds'}
                    ClearCdsExtract;
                  {$ENDREGION}

                  //Récupération de la liste des fichiers TEMOIN dans le dossier d'extraction
                  LstExtractTemoin := GetFileFromDir(IntegrationDir,'*TEMOIN*');
                  LstExtractTemoin.Sort;

                  for i := 0 to LstExtractTemoin.Count -1 do
                  begin
      //              LstTemp[i]       := LstExtractTemoin[i];
      //              LstDateTemoin[i] := ConvertToDate(Copy(LstTemp[3],Pos('-',lstFileTemoin[i]) + 2,Length(lstFileTemoin[i]) - 4));
                    DateFicTemoin := Copy(LstExtractTemoin[i],Pos('-',LstExtractTemoin[i]) + 10,Length(LstExtractTemoin[i]) - 4);
                    DateFicTemoin := LeftStr(DateFicTemoin, Pos('.',DateFicTemoin) - 1);

                    DateTemoin    := ConvertToDate(DateFicTemoin);
                    MaxDateIntegr := LastDateIntegr ;

                    //Vérification de la date du fichier TEMOIN
                    if CompareDateTime(DateTemoin,LastDateIntegr) = GreaterThanValue  then
                    begin
                      LstDateTemoin.Add(DateFicTemoin);
                    end;

                  end;

                  //Tri des fichiers TEMOIN par date
                  LstDateTemoin.Sort;

                  AddToMemo('--- Traitement des offres de réduction :');

                  if IntegrationDir = '' then
                  begin
                    AddToMemo('        -> Le dossier d''importation des offres n''est pas renseigné ');
                  end;

                  if ((IntegrationDir <> '') and (IntegrationDir[Length(IntegrationDir)] <> '\')) then
                  begin
                    AddToMemo('        -> Le dossier d''importation est incorrect ');
                  end;

                  AddToMemo('');

                  AddToMemo('   -> Dernier fichier traité précédement : ' + DateTimeToStr(LastDateIntegr));

                  //Parcours de la liste des fichiers TEMOIN
                  for I := 0 to LstDateTemoin.Count - 1 do
                  begin
                     DateTemoinInit := ConvertToDate(LstDateTemoin[i]);
                     if DateTemoinInit > MaxDateIntegr
                      then MaxDateIntegr := DateTemoinInit ;

                    //Vérification de la date pour savoir si on traite vraiment en initialisation
                    if InitMode then
                    begin
                      if DateTemoinInit <= DosIntegreInitDate  then
                      begin
                        InitMode := True;
                      end else
                      begin
                        InitMode := False;
                      end;
                    end;

                    //Charger les fichiers dans les Cds (Extract) par rapport au fichier TEMOIN
                    LstFicFileTemoin := GetFicFromTemoin(IntegrationDir, '*'+LstDateTemoin[i]+'*');
                    LstCut           := TStringList.Create;

                    ClearCdsExtract;

                    AddToMemo('   -> Chargement des fichiers d''offre de réduction datant du ' + DateTimeToStr(ConvertToDate(LstDateTemoin[i])));

                    Try
                      for k := 0 to LstFicFileTemoin.Count - 1 do
                      begin
                        LstCut.Text := StringReplace(LstFicFileTemoin[k],'-', #13#10, [rfReplaceAll]);
                        NomTableFic := LstCut[2];

                        {$REGION 'Chargement des Cds'}
                        try
                          case AnsiIndexStr(UpperCase(NomTableFic),['OFRIMPBR','OFRLIGNEBR','OFRMAGASIN','OFRPERIMETRE',
                                                                       'OFRTETE', 'OFRTYPCARTEFID']) of
                            0 : begin
                                  LoadCsvExtract(IntegrationDir+LstFicFileTemoin[k], cds_OFRIMPBR, False);
                            end;

                            1 : begin
                                  LoadCsvExtract(IntegrationDir+LstFicFileTemoin[k], cds_OFRLIGNEBR, False);
                            end;

                            2 : begin
                                  LoadCsvExtract(IntegrationDir+LstFicFileTemoin[k], cds_OFRMAGASIN, False);
                            end;

                            3 : begin
                                  LoadCsvExtract(IntegrationDir+LstFicFileTemoin[k], cds_OFRPERIMETRE, False);
                            end;

                            4 : begin
                                  LoadCsvExtract(IntegrationDir+LstFicFileTemoin[k], cds_OFRTETE, False);
                            end;

                            5 : begin
                                  LoadCsvExtract(IntegrationDir+LstFicFileTemoin[k], cds_OFRTYPCARTEFID, False);
                            end;

                          end;
                        Except on e:Exception do
                          begin
                            raise Exception.Create('Chargement des fichiers en mémoire -> '+E.Message);
                            AddToMemo(E.Message);
                          end;
                        end;

                        {$ENDREGION}
                      end;

                      {$REGION 'Integration des données dans la base'}
                      if LstFicFileTemoin.Count > 0 then
                      begin
                        ClassIntegrationOffre.ModeInitialisation := InitMode;
                        ClassIntegrationOffre.Import;
                        ClassIntegrationOffre.DoMajTable;
                      end;

                      {$ENDREGION}

                    Finally
                      LstCut.Free;
                    End;

                  end;

                  //Intégration des offres par magasin
                end;


                {$ENDREGION}

                {$REGION 'Importation des offres de réduction terminé'}
                if LstDateTemoin.Count > 0 then
                begin
                  if not DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Started then
                    DM_GsDataDbCfg.Que_MAJ.IB_Transaction.StartTransaction;

                    DM_GsDataDbCfg.Que_MAJ.SQL.Clear;
                    DM_GsDataDbCfg.Que_MAJ.Close;
                    DM_GsDataDbCfg.Que_MAJ.SQL.Text  := 'UPDATE DOSSIERS SET DOS_INTEGRELASTDATE = :INTEGRELASTDATE  ' +
                                                        'WHERE DOS_ID = :DOSID ';
                    DM_GsDataDbCfg.Que_MAJ.ParamCheck := True;
                    DM_GsDataDbCfg.Que_MAJ.ParamByName('INTEGRELASTDATE').AsDateTime := MaxDateIntegr ;
                    DM_GsDataDbCfg.Que_MAJ.ParamByName('DOSID').AsInteger            := DOSID;
                    DM_GsDataDbCfg.Que_MAJ.ExecSQL;
  
                    DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Commit;

                  if DosIntegreInit = 1 then
                  begin
                    if not DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Started then
                      DM_GsDataDbCfg.Que_MAJ.IB_Transaction.StartTransaction;

                    DM_GsDataDbCfg.Que_MAJ.SQL.Clear;
                    DM_GsDataDbCfg.Que_MAJ.Close;
                    DM_GsDataDbCfg.Que_MAJ.SQL.Text   := 'UPDATE DOSSIERS SET DOS_INTEGREINIT = 0  ' +
                                                         'WHERE DOS_ID = :DOSID ';
                    DM_GsDataDbCfg.Que_MAJ.ParamCheck                      := True;
                    DM_GsDataDbCfg.Que_MAJ.ParamByName('DOSID').AsInteger  := DOSID;
                    DM_GsDataDbCfg.Que_MAJ.ExecSQL;

                  end;

                  DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Commit;

                  AddToMemo('');

                  //Je renseigne le nb de mise à jour ou ajout dans la base
                  if GSData_TIntegration.NbOffreImport <> 0 then
                    AddToMemo('             --- Il y a '+IntToStr(GSData_TIntegration.NbOffreImport)+ ' offre(s) de réduction importée(s) dans la base ---');

                  if GSData_TIntegration.NbOffreDoMaj <> 0 then
                    AddToMemo('             --- Il y a '+IntToStr(GSData_TIntegration.NbOffreDoMaj)+ ' offre(s) de réduction qui ont été mises à jour dans la base ---');

                  AddToMemo('');
                  AddToMemo('--- Importation des offres de réduction terminée ');
                end else
                begin
                  AddToMemo('           Il y a aucune offre de réduction à importer ');
                end;
                {$ENDREGION}

                {$REGION 'Libération de la classe Offre'}
                if Assigned(ClassIntegrationOffre) then
                   FreeAndNil(ClassIntegrationOffre);
                {$ENDREGION}

                {$ENDREGION}

                {$ENDREGION}
              end;
            Finally
              IboDbClient.Close;

              LoopAutoActive(vCumulAjout);

              LstDateTemoin.Free;

              {$REGION ' Liberation du jeton '}
              if bJeton then
              begin
                Try
                    if Assigned(TokenManager) then
                    begin
                      TokenManager.releaseToken;
                      FreeAndNil(TokenManager);
                    end;
    //              StopTokenEnBoucle();      //Relache le jeton
                  bJeton := False;
                Except
                  on E:Exception do
                    raise Exception.Create('Jeton Liberation -> ' + E.Message);
                End;
              end;
              {$ENDREGION}
            End;
          Except
            on E: EAbortStoreImport do
            begin
              bAborted := True;
              AddToMemo('Annulé');
              Break;
            end;
            on E:Exception do
              AddToMemo(E.Message);
          End;
        end;
        DM_GsDataDbCfg.cds_Dossiers.Next;
      end; // while
    finally
      ClassTmp.Free;
      lstDecoupe.Free;
      SelMagId.Free;
    end;

  //  Memo.Lines.BeginUpdate;
  //  for i := 0 to (GERREURS.Count * 10 DIV 100) -1 do
  //    AddToMemo(Format('%s - %s - %s - %d',[GERREURS[i].NomFichier,GERREURS[i].RefErreur, GERREURS[i].Text,GERREURS[i].NumeroLigne]));
  //  Memo.Lines.EndUpdate;

    FLabel.Caption        := IfThen( bAborted, 'Importation annulée', 'Importation terminée' );
    FProgressBar.Position := 100 ;
    if (iError > 0) then
    begin
      Log.Log( '', 'Main', '', '', '', 'Status', 'Erreur', logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
      FprogressBar.State    := pbsError ;
      FLabelError.Caption   := IntToStr(iError) + ' Erreurs' ;
    end else begin
      Log.Log( '', 'Main', '', '', '', 'Status', IfThen( bAborted, 'Annulé', 'Ok' ), logInfo, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
      FprogressBar.State    := pbsNormal ;
      FLabelError.Caption   := '' ;
    end;
  except
    on E: Exception do
      Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  end;

  AddToMemo('------------------------------------------------------');
  AddToMemo('Fin du traitement : Import');
  AddToMemo('------------------------------------------------------');
end;

procedure TDM_GSDataMain.ClearCdsImport;
begin
  //Procedure qui nettoie les cds d'import
  with Dm_GSDataExtract do
  begin
    cds_OFRTETE.EmptyDataSet;
    cds_OFRMAGASIN.EmptyDataSet;
    cds_OFRIMPBR.EmptyDataSet;
    cds_OFRLIGNEBR.EmptyDataSet;
    cds_OFRPERIMETRE.EmptyDataSet;
  end;
end;

procedure TDM_GSDataMain.clearErrors;
begin
    FProgressBar.Position := 0;
    FProgressBar.State    := pbsNormal ;
    FLabelError.Caption   := '' ;
end;

function TDM_GSDataMain.ConvertToDate(ADateStr: string): TDateTime;
var
  iYear, iMonth, iDay, iHour, iMinute, iSecond : Integer;
begin
   Try
    // Format attendu YYYYMMDDhhmmss
    iYear   := StrToInt(Copy(ADateStr,1,4));
    iMonth  := StrToInt(Copy(ADateStr,5,2));
    iDay    := StrToInt(Copy(ADateStr,7,2));
    iHour   := StrToInt(Copy(ADateStr,9,2));
    iMinute := StrToInt(Copy(ADateStr,11,2));
    iSecond := StrToInt(Copy(ADateStr,13,2));
    Result  := EncodeDateTime(iYear,iMonth, iDay,iHour,iMinute,iSecond,0);
  Except on E:exception do
    begin
      raise Exception.Create('ConvertToDate -> ' + E.Message);
    end;
   End;
end;

procedure TDM_GSDataMain.DataModuleCreate(Sender: TObject);
var
  ia : integer ;
begin
  FbypassInstance := False;
  FrestartNeed := False;
  // Gestion monitoring
  InitializeLog; // Définition du LogFreq et du LogType par défaut pour l'app
  Log.App := 'GSDATA';
  Log.Inst := IniStruct.Others.IdGsData;
  Log.Open;
  Log.FileLogLevel := logInfo;

    for ia:=1 to paramcount do
    begin
      if uppercase(trim(paramstr(ia))) = '/DEBUG' then
        Log.FileLogLevel := logDebug;
      if uppercase(trim(paramstr(ia))) = '/RESTART' then
        FbypassInstance := True;
    end;

  // ajoute un delai pour laisser le temps à l'ancien exe de se fermer
  if FbypassInstance then Sleep(3500);
  Log.saveIni;
  Log.Log( '', 'Main', '', '', '', 'Status', 'Démarrage de GSDATA', logNotice, True, 0, LogType ) ;
end;

procedure TDM_GSDataMain.DataModuleDestroy(Sender: TObject);
begin
  Log.Log( '', 'Main', '', '', '', 'Status', 'Arrêt de GSDATA', logWarning, False, 0, LogType ) ;
end;

procedure TDM_GSDataMain.DeplacerFichier(ADirFTP, ADirDossier : String; ALst : TStringList);
var
  j : Integer;
begin
  DoDir(ADirDossier);
  for j := 0 to ALst.Count -1 do
  begin
    if FileExists(ADirFTP + ALst[j]) then
    begin
      if FileExists(ADirDossier + ALst[j]) then
        DeleteFile(PWidechar(ADirDossier + ALst[j]));
      MoveFile(PWideChar(ADirFTP + ALst[j]),PWideChar(ADirDossier + ALst[j]));
    end;
  end;
end;

procedure TDM_GSDataMain.DisplayConnectionStatus(const Visible: Boolean;
  const Hint: String);
begin
  if not( SameText( '', Trim( Hint ) )
  or SameText( Trim( Hint ), GSDataMain_Frm.frm_GSDataMain.Img_Connection.Hint ) ) then
    GSDataMain_Frm.frm_GSDataMain.Img_Connection.Hint := Trim( Hint );
  GSDataMain_Frm.frm_GSDataMain.Img_Connection.ShowHint := Visible;
  GSDataMain_Frm.frm_GSDataMain.Img_Connection.Visible := Visible;
  Application.ProcessMessages;
end;

procedure TDM_GSDataMain.ExecuteProcessExport(AExportType: TExportType; AListOfMagsByCustomerFiles: TList<TCustomerFile>; AFicIDs: TList<Integer>);
var
  SelDosId  : integer;
  LocMagId, GinMagId, FicId, HofId : integer;
  MagCodAdh, ExportPath : string;
  TypeMagasin : TMagType;
//CAF
  ModeMagasin : TMagMode;

  iTentative, // Numero de tentative de prise de jeton
  iLastVersion, iCurrentVersion, i, j, k : integer;
  tpJeton : TTokenParams;   // Record avec les paramètres pour les Jetons
  BaseExport: TBaseExport;
  bJeton  : Boolean;        // Vrai si on a le jeton sinon faux
  sAdresse : String;
  TokenManager : TTokenManager;
  iError, iErrorProcess: Cardinal;
  bAborted: Boolean;
  sFileName: string;
  vUserActionSelect: Tfrm_UserActionSelect;
  vGinMagFound, vLocMagFound: Boolean;
  vLogLevel: TLogLevel;
begin
  Log.Log( '', 'Main', '', '', '', 'Status', Format( 'Export %s...', [ IfThen(AExportType <> etAuto, 'manuel', 'automatique' ) ] ), logNotice, true, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  try
    bAborted := False;
    bJeton := false;
    clearErrors ;

    {$REGION 'Initialisation'}
    GLOGSPATH := GAPPPATH + 'Logs\' + FormatDateTime('YYYY\MM\DD\',Now);
    GLOGSNAME := FormatDateTime('YYYYMMDDHHmmsszzz',Now) + '.txt';
    DoDir(GLOGSPATH);
    ExportPath := GAPPPATH + 'Exports' + PathDelim + FormatDateTime('YYYY' + PathDelim + 'MM' + PathDelim + 'DD' + PathDelim + 'HHNN', GSTARTTIME) + PathDelim;
    iError := 0;
    {$ENDREGION}

    try
      for i := 0 to Pred(AListOfMagsByCustomerFiles.Count) do
      begin
        begin
          AddToMemo('Traitement du dossier : ' + AListOfMagsByCustomerFiles[i].FCustomerFileName);
          // Ouverture d'un base de données de la liste.
          IboDbClient.Close;
          IboDbClient.DatabaseName := AnsiString(AListOfMagsByCustomerFiles[i].FCustomerFilePath);
          Try
            Try
              {$REGION ' Prise du jeton '}
              if not IniStruct.Others.NoJeton then
              begin
                Try
                  AddToMemo('Tentative de prise de jeton');
                  tpJeton := GetParamsToken(AListOfMagsByCustomerFiles[i].FCustomerFilePath,'ginkoia','ginkoia');    //Prise en compte des Jetons

                  sAdresse := StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]);
                  TokenManager :=  TTokenManager.Create;
                  bJeton := TokenManager.tryGetToken(sAdresse,tpJeton.sDatabaseWS,tpJeton.sSenderWS,20,30000);

                  if bJeton then
                    AddToMemo('Jeton Acquis !!')
                  else
                    raise Exception.Create('Problème lors de l''obtention du jeton');
                Except on E:Exception do
                  raise Exception.Create('Jeton -> ' + AListOfMagsByCustomerFiles[i].FCustomerFilePath + ' - ' + E.Message);
                End;
              end;
              {$ENDREGION}

              Log.Log( '', 'Main', '', '', '', 'Status', 'Connexion à la base de données: ' + AListOfMagsByCustomerFiles[i].FCustomerFilePath, logNotice, false, DM_GSDataMain.LogFreq, ltLocal );
              try
                IboDbClient.Open;
                Log.Log( '', 'Main', '', '', '', 'Status', 'Connecté', logInfo, false, DM_GSDataMain.LogFreq, ltLocal );
              except
                on E: Exception do
                begin
                  Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, ltLocal );
                  raise;
                end;
              end;

              begin

                {$REGION ' ouverture des query '}
                // Récupération de la liste des magasins de la base de données
                Que_Magasins.Close();
                Que_Magasins.Open();
                {$ENDREGION ' ouverture des query '}

                AddToMemo('Recalcul du stock');
                if DM_GSDataExport.CalculStockDiff() then
                begin
                  for j := 0 to Pred(AListOfMagsByCustomerFiles[i].FMags.Count) do
                  begin
                    if AListOfMagsByCustomerFiles[i].FMags[j].FMagID = 0 then
                      Continue;

                    // Le locate ne fonctionnais pas.
                    Que_Magasins.First;
                    vGinMagFound := False;
                    while not Que_Magasins.Eof do
                    begin
                      if Que_Magasins.FieldByName('MAG_ID').AsInteger = AListOfMagsByCustomerFiles[i].FMags[j].FMagID then
                      begin
                        vGinMagFound := True;
                        break;
                      end;
                      Que_Magasins.Next;
                    end;

                    // Le locate ne fonctionnais pas.
                    DM_GsDataDbCfg.cds_Magasin.LoadFromDataSet( DM_GsDataDbCfg.Que_Magasin );
                    DM_GsDataDbCfg.cds_Magasin.First;
                    vLocMagFound := False;
                    while not DM_GsDataDbCfg.cds_Magasin.Eof do
                    begin
                      if (DM_GsDataDbCfg.cds_Magasin.FieldByName('MAG_DOSID').AsInteger = AListOfMagsByCustomerFiles[i].FCustomerFileID)
                        and (DM_GsDataDbCfg.cds_Magasin.FieldByName('MAG_IDGINKOIA').AsInteger = AListOfMagsByCustomerFiles[i].FMags[j].FMagID) then
                      begin
                        vLocMagFound := True;
                        break;
                      end;
                      DM_GsDataDbCfg.cds_Magasin.Next;
                    end;

                    if vGinMagFound and vLocMagFound then
                    begin
                      iErrorProcess := 0;
                      LocMagId := DM_GsDataDbCfg.cds_Magasin.FieldByName('MAG_ID').AsInteger;
                      GinMagId := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                      MagCodAdh := Que_Magasins.FieldByName('MAG_CODEADH').AsString;
                      AddToMemo('Traitement du magasin : ' + Que_Magasins.FieldByName('mag_enseigne').AsString);
                      iLastVersion := DM_GSDataExport.GetParamInteger(16, 23, GinMagId);
                      iCurrentVersion := DM_GSDataExport.GetCurrentVersion();
                      TypeMagasin := GetMagType();
//CAF
                      ModeMagasin := GetMagMode();

                      if TypeMagasin in [mtCourir, mtGoSport] then
                      begin
                        if DM_GsDataDbCfg.cds_Fichier.Active and not (DM_GsDataDbCfg.cds_Fichier.IsEmpty()) then
                        begin
                          if ModeMagasin <> mtMandat then
                            DM_GsDataDbCfg.cds_Fichier.ChangeFilter( 'fic_type in (%d, 0)', [ Ord( ModeMagasin ) ] )
                          else
                            DM_GsDataDbCfg.cds_Fichier.ChangeFilter( 'fic_type in (%d, 0, 1)', [ Ord( ModeMagasin ) ] );

                          Log.Log( '', 'Export', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                            'Status', 'Traitement...', logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

                          for k := 0 to Pred(AFicIDs.Count) do
                          begin
                            if DM_GsDataDbCfg.cds_Fichier.Locate('fic_id', AFicIDs[k], []) then
                            begin
                              FicId := DM_GsDataDbCfg.cds_Fichier.FieldByName('fic_id').AsInteger;
                              HofId := DM_GsDataDbCfg.cds_Fichier.FieldByName('hof_id').AsInteger;
                              AddToMemo('Traitement du fichier : ' + DM_GsDataDbCfg.cds_Fichier.FieldByName('fic_libelle').AsString);

                              // Création de la classe adaptée au traitement
                              BaseExport := DM_GSDataExport.GetClassForExport(DM_GsDataDbCfg.cds_Fichier.FieldByName('FIC_LIBELLE').AsString).Create(
                                MagCodAdh, LocMagId, GinMagId, HofId, FicId, ExportPath);
                              try
//CAF
                                if (TypeMagasin = mtGoSport) and (DM_GsDataDbCfg.cds_Fichier.FieldByName('FIC_TYPE').AsInteger = Ord(mtAffilie)) then
                                begin
                                  if BaseExport.InheritsFrom(TExportGoS) then
                                  begin
                                    TExportGoS(BaseExport).LastVersion    := iLastVersion;
                                    TExportGoS(BaseExport).CurrentVersion := iCurrentVersion;
                                  end;
                                end;

                                sFileName := BaseExport.Filename;

                                case BaseExport.Traitement((AExportType in [etSelectStores, etEveryStores])) of
                                  TBaseExportResultRec.Succeed:
                                    begin
                                      AddToMemo( IfThen( not SameText( BaseExport.Erreur, SysUtils.EmptyStr ), BaseExport.Erreur, 'Export terminé correctement' ) );
                                      Log.Log( '', 'Export', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        DM_GsDataDbCfg.cds_Fichier.FieldByName('fic_libelle').AsString, Format('%s : Ok', [sFileName]), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                    end;
                                  TBaseExportResultRec.Warning:
                                    begin
                                      AddToMemo('Export terminé (' + BaseExport.Erreur + ')');

                                      if UpperCase(DM_GsDataDbCfg.cds_Fichier.FieldByName('fic_libelle').AsString) = 'XICKET' then
                                      begin
                                        if BaseExport.Filename <> PAS_DONNEES_EXPORT then
                                          vLogLevel := logError
                                        else
                                          vLogLevel := logInfo;
                                        Log.Log( '', 'Export', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                          DM_GsDataDbCfg.cds_Fichier.FieldByName('fic_libelle').AsString, Format('%s : %S', [sFileName, BaseExport.Filename]), vLogLevel, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                      end;
                                    end;
                                  TBaseExportResultRec.Error:
                                    begin
                                      AddToMemo(BaseExport.Etape + ' : ' +  BaseExport.Erreur);
                                      Log.Log( '', 'Export', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                                        DM_GsDataDbCfg.cds_Fichier.FieldByName('fic_libelle').AsString, Format('%s : Erreur : %s', [sFileName, BaseExport.Erreur]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                                      Inc( iError );
                                      Inc( iErrorProcess );
                                    end;
                                end;
                              finally
                                BaseExport.Free();
                              end;
                            end
                            else
                            begin
                              if DM_GsDataDbCfg.cds_SelectedFiles.Locate('fic_id', AFicIDs[k], []) then
                                AddToMemo('Ce magasin ne peut pas faire de traitement sur le fichier '
                                  + DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('fic_libelle').AsString)
                              else
                                AddToMemo('Ce magasin ne peut pas faire de traitement sur un fichier [ID=' + IntToStr(AFicIDs[k]) + ']');
                            end;
                          end;
                          if iErrorProcess > 0 then
                            Log.Log( '', 'Export', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                              'Status', Format('%d Erreur(s)', [iErrorProcess]), logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                          else
                            Log.Log( '', 'Export', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                              'Status', 'Ok', logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                        end
                        else
                          AddToMemo('Pas de fichier d''export configuré pour cette plage horaire');
                      end
                      else
                      begin
                        AddToMemo('Type de magasin inconnu');
                      end;
                    end
                    else if (AExportType = etSelectStores) then
                      AddToMemo('  --> ATTENTION : magasin non paramétré pour l''export');
                  end;
                end
                else
                  AddToMemo(' -> erreur lors du recalcul');
              end;
            Finally
              IboDbClient.Close;
              if Assigned(vUserActionSelect) then
                FreeAndNil(vUserActionSelect);

              {$REGION ' Liberation du jeton '}
              if bJeton then
              begin
                Try
                  if Assigned(TokenManager) then
                  begin
                    TokenManager.releaseToken;
                    FreeAndNil(TokenManager);
                  end;
                  bJeton := False;
                Except
                  on E:Exception do
                    raise Exception.Create('Jeton Liberation -> ' + E.Message);
                End;
              end;
              {$ENDREGION}
            End;
          Except
            on E:EAbortStoreExport do
            begin
              bAborted := True;
              AddToMemo('Annulé');
              Break;
            end;
            on E:Exception do
              AddToMemo(' -> Exception : ' + E.ClassName + ' - ' + E.Message);
          end;
        end;
        // plage terminé ??
        // exit !!
        if not (AExportType in [etSelectStores, etEveryStores]) and (Frac(Now()) >= DM_GsDataDbCfg.cds_Horaire.FieldByName('hor_hfin').AsDateTime) then
          Break
        else
          DM_GsDataDbCfg.cds_Dossiers.Next;
      end;
      DM_GSDataExport.CloseFTP();
      DM_GSDataExport.CloseSFTP();
    finally
//      SelMagId.Free;
//      SelFicId.Free;

      DM_GsDataDbCfg.cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s', [ QuotedStr( IniStruct.Others.IdGsData ) ] );
      // rafraichissement des horaires ...
      LoadClientDataSet(DM_GsDataDbCfg.cds_Horaire, DM_GsDataDbCfg.Que_Horaire);
    end;

    FProgressBar.Position := 0;
    FLabel.Caption := IfThen( bAborted, 'Exportation annulée', 'Exportation terminée' );
    if ( iError = 0 ) then
      Log.Log( '', 'Main', '', '', '', 'Status', IfThen( bAborted, 'Annulé', 'Ok' ), logInfo, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
    else
      Log.Log( '', 'Main', '', '', '', 'Status', 'Erreur', logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  except
    on E: Exception do
      Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  end;

//  AddToMemo('------------------------------------------------------');
//  AddToMemo('Fin du traitement : Export');
//  AddToMemo('------------------------------------------------------');
end;

procedure TDM_GSDataMain.ExecuteProcessExtract(Manuel: Boolean);
const
  StreamNames: array[0..6] of String = ( 'OFRTETE', 'OFRMAGASIN', 'OFRLIGNEBR',
    'OFRIMPBR', 'OFRPERIMETRE', 'OFRTYPCARTEFID', 'TEMOIN' );
var
  StreamName: String;
  StreamFilename: TFileName;
  DOSID           : Integer;
  LastDateExtract : TDateTime;
  iTentative      : integer;        // Numero de tentative de prise de jeton
  tpJeton         : TTokenParams;   // Record avec les paramètres pour les Jetons
  bJeton          : Boolean;        // Vrai si on a le jeton sinon faux
  OFEID           : Integer;
  DateExtract     : String;         //Date qui sera inscrite dans la génération des fichiers csv d'extraction
  IdExtract       : Integer;        //Id d'extraction DOS_EXTRACTID
  DirExtract      : String;         //Chemin de dépose des fichiers DOS_EXTRACTDIR
  Temoin          : TextFile;       //Pour la création du fichier TEMOIN Lors de l'extraction
  OFE_CHRONO      : string;         {DONE -oJO : Modification de la clé: OFE_CODECENTRAL -> OFE_CHRONO (2016-04-07)}

  sAdresse : String;
  TokenManager : TTokenManager;
  iError: Integer;
  QueMagasinsActived: Boolean; // Etat (ouvert/fermé) du query Que_Magasins
begin
  Log.Log( '', 'Main', '', '', '', 'Status', Format( 'Extract %s...', [ IfThen( Manuel, 'manuel', 'automatique' ) ] ), logNotice, true, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  try
    clearErrors ;

    {$REGION 'Initialisation extraction'}
    GLOGSPATH := GAPPPATH + 'Logs\' + FormatDateTime('YYYY\MM\DD\',Now);
    GLOGSNAME := FormatDateTime('YYYYMMDDHHmmsszzz',Now) + '.txt';
    DoDir(GLOGSPATH);
    iError := 0;
    {$ENDREGION}

  //JB
  //  Le champ OFE_MARGECENTRALE a été rajouté dans le ClientDataSet cds_OFRTETE
  //  Pour faire, désactiver cds_OFRTETE, ckick droit -> Editeur de champs -> Nouveau champ
  //  Pour activer cds_OFRTE,TE ckick droit -> Créér un ensemble de données
    try
      Dm_GSDataExtract.ClearCdsExtract; //vidage de tous les clientdataset d'extraction
      // Fermeture et ouverture de la base de données locale
      LoadClientDataSet(
        DM_GsDataDbCfg.cds_Dossiers,
        DM_GsDataDbCfg.Que_Dossiers
      );

      //Afin de vérifier qu'on est sur la bonne plage horraire
      LoadClientDataSet(
        DM_GsDataDbCfg.cds_Horaire,
        DM_GsDataDbCfg.Que_Horaire
      );

      //vérification si on est sur la bonne plage horraire
      DM_GsDataDbCfg.cds_Horaire.ChangeFilter( 'hor_type = 3' );

      // Filtrer la base données pour ne traiter que les base avec même ID, Active et avec le mode extraction d'activer
      DM_GsDataDbCfg.cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s and DOS_ACTIVE = 1 and DOS_EXTRACT = 1', [ QuotedStr( IniStruct.Others.IdGsData ) ] );

      if Manuel then
      begin
        AddToMemo('Lancement manuel de l''extraction d''offres de réduction.');
      end else begin
        if ((Frac(Now()) >= DM_GsDataDbCfg.cds_Horaire.FieldByName('hor_hfin').AsDateTime) or
            (Frac(Now()) <= DM_GsDataDbCfg.cds_Horaire.FieldByName('hor_hdeb').AsDateTime)) then
        begin
          AddToMemo('  -> Aucune extraction d''offres de réduction prévue sur cette plage horaire');
          raise EExtractNotPlanned.Create('Rien à faire');
        end;
      end ;

      while Not DM_GsDataDbCfg.cds_Dossiers.Eof do
      begin

        AddToMemo('------------------------------------------------------');
        AddToMemo('Début de l''extraction');
        AddToMemo('------------------------------------------------------');

        DateExtract := FormatDateTime('YYYYMMDDHHmmssnn',Now);
        IdExtract   := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_EXTRACTID').AsInteger;
        DirExtract  := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_EXTRACTDIR').AsString;

        DOSID       := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_ID').AsInteger;
        AddToMemo('Traitement du dossier : ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_NOM').AsString);
        // Ouverture d'un base de données de la liste.
        IboDbClient.Close;
        IboDbClient.DatabaseName := AnsiString(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString);
        // Ouverture d'un base de données de la liste.
        try
          try
            {$REGION 'Prise du Jeton'}
            if not IniStruct.Others.NoJeton then
            begin
              Try
                AddToMemo('Tentative de prise de jeton');
                tpJeton := GetParamsToken(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString,'ginkoia','ginkoia');    //Prise en compte des Jetons

                sAdresse := StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]);
                TokenManager :=  TTokenManager.Create;
                bJeton := TokenManager.tryGetToken(sAdresse,tpJeton.sDatabaseWS,tpJeton.sSenderWS,20,30000);

                if bJeton then
                  AddToMemo('Jeton Acquis !!')
                else
                  raise Exception.Create('Problème lors de l''obtention du jeton');

  //              tpJeton := GetParamsToken(DM_GsDataDbCfg.Que_DOSSIERS.FieldByName('DOS_PATH').AsString, 'ginkoia', 'ginkoia');    //Prise en compte des Jetons
  //              bJeton := False;
  //              iTentative := 0;
  //              while not bJeton do
  //              begin
  //                AddToMemo('Tentative d''obtention d''un jeton');
  //                bJeton  := StartTokenEnBoucle(tpJeton,30000);             //On rafraichi toute les 30s
  //                Application.ProcessMessages;
  //                if (not bJeton) then
  //                begin
  //                  if iTentative <= 20  then
  //                  begin
  //                   DoWait(30000);
  //                   Inc(iTentative);
  //                  end
  //                  else
  //                    raise Exception.Create(DM_GsDataDbCfg.Que_DOSSIERS.FieldByName('DOS_PATH').AsString +  ' - Echec de l''obtention du Jeton : Trop de tentative');
  //                end ;
  //              end;
  //              if bJeton then
  //                AddToMemo('Jeton Acquis !!');

              Except on E:Exception do
                raise Exception.Create('Jeton -> ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString + ' - ' + E.Message);
              End;
            end;
            {$ENDREGION}

            Log.Log( '', 'Main', '', '', '', 'Status', 'Connexion à la base de données: ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString, logNotice, false, DM_GSDataMain.LogFreq, ltLocal );
            try
              IboDbClient.Open;
              Log.Log( '', 'Main', '', '', '', 'Status', 'Connecté', logInfo, false, DM_GSDataMain.LogFreq, ltLocal );
            except
              on E: Exception do
              begin
                Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, ltLocal );
                raise;
              end;
            end;

            if ISEasyIgnore then
            begin
              AddToMemo('Traitement ignoré car bascule du dossiers sur EASY');
            end
            else
            begin

              {$REGION ' ouverture des query '}
              //Je récupère la liste des en-tête des offres de réduction
              Que_OFRTETE.Close();
              Que_OFRTETE.ParamCheck                                := True;
              Que_OFRTETE.ParamByName('LASTDATEEXTRACT').AsDateTime := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_EXTRACTLASTDATE').AsDateTime;
              Que_OFRTETE.Open();

              //Je récupère la liste des fournisseurs de type 4
              Que_ExtractFourn.Close;
              Que_ExtractFourn.Open;
              {$ENDREGION}

              //Si il y a des offres à récuperer
              if Que_OFRTETE.RecordCount > 0 then
              begin
                LoadCds(Que_OFRTETE, Dm_GSDataExtract.cds_OFRTETE); //je remplie le cds_OFRTETE
                Que_OFRTETE.First;
                while not Que_OFRTETE.Eof do
                begin
                  //je récupere toutes les offres de réduction
                  OFEID       := Que_OFRTETE.FieldByName('OFE_ID').AsInteger;
                  OFE_CHRONO  := Que_OFRTETE.FieldByName('OFE_CHRONO').AsString;

                  {$REGION 'Load OFRMAGASIN'}
                  Que_OFRMAGASIN.Close;
                  Que_OFRMAGASIN.ParamCheck                     := True;
                  Que_OFRMAGASIN.ParamByName('OFEID').AsInteger := OFEID;
                  Que_OFRMAGASIN.Open;

                  LoadCdsMag(Que_ExtractFourn, Que_OFRMAGASIN, Dm_GSDataExtract.cds_OFRMAGASIN, OFE_CHRONO); //Je remplie le cds_OFRMAGASIN
                  {$ENDREGION}

                  {$REGION 'Load OFRLIGNEBR'}
                  Que_OFRLIGNEBR.Close;
                  Que_OFRLIGNEBR.ParamCheck                     := True;
                  Que_OFRLIGNEBR.ParamByName('OFEID').AsInteger := OFEID;
                  Que_OFRLIGNEBR.Open;

                  LoadCds(Que_OFRLIGNEBR, Dm_GSDataExtract.cds_OFRLIGNEBR, OFE_CHRONO); //Je remplie le cds_OFRLIGNEBR
                  {$ENDREGION}

                  {$REGION 'Load OFRIMPBR'}
                  Que_OFRIMPBR.Close;
                  Que_OFRIMPBR.ParamCheck                     := True;
                  Que_OFRIMPBR.ParamByName('OFEID').AsInteger := OFEID;
                  Que_OFRIMPBR.Open;

                  LoadCds(Que_OFRIMPBR, Dm_GSDataExtract.cds_OFRIMPBR, OFE_CHRONO); //Je remplie le cds_OFRLIGNEBR
                  {$ENDREGION}

                  {$REGION 'Load OFRPERIMETRE'}
                  Que_OFRPERIMETRE.Close;
                  Que_OFRPERIMETRE.ParamCheck                     := True;
                  Que_OFRPERIMETRE.ParamByName('OFEID').AsInteger := OFEID;
                  Que_OFRPERIMETRE.Open;

                  LoadCds(Que_OFRPERIMETRE, Dm_GSDataExtract.cds_OFRPERIMETRE, OFE_CHRONO); //Je remplie le cds_OFRPERIMETRE
                  {$ENDREGION}

                  {$REGION 'Load OFRTYPCARTEFID'}
                  Que_OFRTYPCARTEFID.Close;
                  Que_OFRTYPCARTEFID.ParamCheck                     := True;
                  Que_OFRTYPCARTEFID.ParamByName('OFEID').AsInteger := OFEID;
                  Que_OFRTYPCARTEFID.Open;

                  LoadCds(Que_OFRTYPCARTEFID, Dm_GSDataExtract.cds_OFRTYPCARTEFID, OFE_CHRONO); //Je remplie le cds_OFRTYPCARTEFID
                  {$ENDREGION}

                  Que_OFRTETE.Next;
                end; //Fin while OFRTETE

                AddToMemo('   '+IntToStr(Que_OFRTETE.RecordCount)+' offre(s) de réduction ont été exportées ');

                //Remplissage des clientDataSet terminé , je crais les fichier .csv

                {$REGION 'Export fichier extract csv'}
                with Dm_GSDataExtract do
                begin
                  AddToMemo('      -> Création des fichiers ');
                  QueMagasinsActived := Que_Magasins.Active;
                  try
                    if not QueMagasinsActived then
                      Que_Magasins.Open;
                    for StreamName in StreamNames do begin
                      StreamFilename := Format( '%sGSEXTRACT-%d-%s-%s.csv', [ ''{DirExtract}, IdExtract, StreamName, DateExtract ] );
                      Log.Log( 'Extraction', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString, StreamName, StreamFilename, logNotice, True, LogFreq, LogType );
                      try
                        case AnsiIndexText( StreamName, StreamNames ) of
                          0: CreateCsvExtract( cds_OFRTETE, DirExtract, DateExtract, StreamName, IdExtract ); { OFRTETE }
                          1: CreateCsvExtract( cds_OFRMAGASIN, DirExtract, DateExtract, StreamName, IdExtract ); { OFRMAGASIN }
                          2: CreateCsvExtract( cds_OFRLIGNEBR, DirExtract, DateExtract, StreamName, IdExtract ); { OFRLIGNEBR }
                          3: CreateCsvExtract( cds_OFRIMPBR, DirExtract, DateExtract, StreamName, IdExtract ); { OFRIMPBR }
                          4: CreateCsvExtract( cds_OFRPERIMETRE, DirExtract, DateExtract, StreamName, IdExtract ); { OFRPERIMETRE }
                          5: CreateCsvExtract( cds_OFRTYPCARTEFID, DirExtract, DateExtract, StreamName, IdExtract ); { OFRTYPCARTEFID + GENTYPCARTEFID }
                          6: CreateTemoin( DirExtract, DateExtract, IdExtract ); { TEMOIN }
                        end;
                        Log.Log( 'Extraction', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString, StreamName, StreamFilename, logInfo, True, LogFreq, LogType );
                      except
                        on E: Exception do
                        begin
                          Log.Log( 'Extraction', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString, StreamName, StreamFilename + ' : ' + E.Message, logError, False, LogFreq, LogType );
                        end;
                      end;
                    end;
                  finally
                    if not QueMagasinsActived then
                      Que_Magasins.Close;
                  end;
                end;
                {$ENDREGION}

                //J'ai parcouru tous les dossiers j'inscrit la date du jour (dernière extraction) dans DOS_EXTRACTLASTDATE
                Que_OFRTETE.Last;
                  DM_GsDataDbCfg.Que_MAJ.SQL.Clear;
                  DM_GsDataDbCfg.Que_MAJ.Close;
                  DM_GsDataDbCfg.Que_MAJ.SQL.Text  := 'UPDATE DOSSIERS SET DOS_EXTRACTLASTDATE = :EXTRACTLASTDATE  ' +
                                                    'WHERE DOS_ID = :DOSID ';
                  DM_GsDataDbCfg.Que_MAJ.ParamCheck := True;
                  DM_GsDataDbCfg.Que_MAJ.ParamByName('EXTRACTLASTDATE').AsDateTime   := Que_OFRTETE.FieldByName('OFE_DATE').AsDateTime;
                  DM_GsDataDbCfg.Que_MAJ.ParamByName('DOSID').AsInteger              := DOSID;
                  DM_GsDataDbCfg.Que_MAJ.ExecSQL;
                  DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Commit;

                AddToMemo('   Extraction réalisée avec succès');

              end else
              begin
                AddToMemo('   Il y a aucune offre de réduction à exporter');
              end;
            end;
          finally
            IboDbClient.Close;

            {$REGION 'Libération du Jeton'}
            if bJeton then
            begin
              Try
                if Assigned(TokenManager) then
                begin
                  TokenManager.releaseToken;
                  FreeAndNil(TokenManager);
                end;

  //              StopTokenEnBoucle();      //Relache le jeton
                bJeton := False;
              Except
                on E:Exception do
                  raise Exception.Create('Jeton Liberation -> ' + E.Message);
              End;
            end;
            {$ENDREGION}
          end;
        Except on e : Exception do
          begin
            AddToMemo(' -> Exception : ' + E.ClassName + ' - ' + E.Message);
            Inc( iError );
          end;
        end;

        //On passe au Dossiers suivant
        DM_GsDataDbCfg.cds_Dossiers.Next;
      end;

      if DM_GsDataDbCfg.cds_Dossiers.RecordCount > 0 then
      begin
        AddToMemo('------------------------------------------------------');
        AddToMemo('Fin de l''extraction');
        AddToMemo('------------------------------------------------------');
      end else
      begin
        AddToMemo('  Aucune extraction d''offres de réduction réalisée');
      end;

    finally
      DM_GsDataDbCfg.cds_Horaire.ChangeFilter();
      DM_GsDataDbCfg.cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s', [ QuotedStr( IniStruct.Others.IdGsData ) ] );
    end;

    FLabel.Caption        := 'Extraction des offres de réduction terminée';
    FProgressBar.Position := 0;
    if ( iError > 0 ) then
      Log.Log( '', 'Main', '', '', '', 'Status', 'Erreur', logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
    else
      Log.Log( '', 'Main', '', '', '', 'Status', 'Ok', logInfo, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  except
    on E: EExtractNotPlanned do
      Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logInfo, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
    on E: Exception do
      Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  end;
end;

procedure TDM_GSDataMain.ExecuteProcessWebService(Manuel : Boolean);
var
  DM_GSDataWebService: TDM_GSDataWebService;
  iTentative : integer;     // Numero de tentative de prise de jeton
  tpJeton : TTokenParams;   // Record avec les paramètres pour les Jetons
  bJeton  : Boolean;        // Vrai si on a le jeton sinon faux
  WebServiceOK : boolean;
  RetryCount, RetryTime : integer;
  MagId : integer;
  WsUrl, WsPassword : string;
  WsBaseClient : I_BaseClientNationale;
  wsr_id, wsr_type, wsr_idligne : integer;
  wsr_date: TDateTime;
  ErrorMsg : string;

  sAdresse : String;
  TokenManager : TTokenManager;
  dtProcess: TDateTime;
  iShopError: Integer; // Nombre d'erreurs lors du le traitement d'un magasin
begin
  try
    DM_GSDataWebService := TDM_GSDataWebService.Create(Self);

    Log.Log( '', 'Main', '', '', '', 'Status', Format( 'WebService %s...', [ IfThen( Manuel, 'manuel', 'automatique' ) ] ), logNotice, true, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
    try
      bJeton := false;
      WebServiceOK := false;
      RetryCount := 3;
      RetryTime := 60;
      clearErrors ;

      {$REGION 'Initialisation'}
      GLOGSPATH := GAPPPATH + 'Logs\' + FormatDateTime('YYYY\MM\DD\',Now);
      GLOGSNAME := FormatDateTime('YYYYMMDDHHmmsszzz',Now) + '.txt';
      DoDir(GLOGSPATH);
      {$ENDREGION}

      AddToMemo('------------------------------------------------------');
      AddToMemo('Début du traitement : WebService');
      AddToMemo('------------------------------------------------------');

      try
        // Fermeture et ouverture de la base de données locale
        LoadClientDataSet(
          DM_GsDataDbCfg.cds_Dossiers,
          DM_GsDataDbCfg.Que_Dossiers
        );

        // Filtrer la base données pour ne traiter que les base avec même ID
        DM_GsDataDbCfg.cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s and DOS_ACTIVE = 1', [ QuotedStr( IniStruct.Others.IdGsData ) ] );

        while Not DM_GsDataDbCfg.cds_Dossiers.Eof do
        begin
          AddToMemo('Traitement du dossier : ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('dos_nom').AsString);
          // Ouverture d'un base de données de la liste.
          IboDbClient.Close;
          IboDbClient.DatabaseName := AnsiString(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString);
          Try
            Try
              {$REGION ' Prise du jeton '}
              if not IniStruct.Others.NoJeton then
              begin
                Try
                  AddToMemo('Tentative de prise de jeton');
                  tpJeton := GetParamsToken(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString,'ginkoia','ginkoia');    //Prise en compte des Jetons

                  sAdresse := StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]);
                  TokenManager :=  TTokenManager.Create;
                  bJeton := TokenManager.tryGetToken(sAdresse,tpJeton.sDatabaseWS,tpJeton.sSenderWS,20,30000);

                  if bJeton then
                    AddToMemo('Jeton Acquis !!')
                  else
                    raise Exception.Create('Problème lors de l''obtention du jeton');

  //                tpJeton := GetParamsToken(DM_GsDataDbCfg.Que_DOSSIERS.FieldByName('DOS_PATH').AsString, 'ginkoia', 'ginkoia');    //Prise en compte des Jetons
  //                bJeton := False;
  //                iTentative := 0;
  //                while not bJeton do
  //                begin
  //                  AddToMemo('Tentative d''obtention d''un jeton');
  //                  bJeton  := StartTokenEnBoucle(tpJeton,30000);             //On rafraichi toute les 30s
  //                  Application.ProcessMessages;
  //                  if iTentative <= 20  then
  //                  begin
  //                   DoWait(30000);
  //                   Inc(iTentative);
  //                  end
  //                  else
  //                    raise Exception.Create(DM_GsDataDbCfg.Que_DOSSIERS.FieldByName('DOS_PATH').AsString +  ' - Echec de l''obtention du Jeton : Trop de tentative');
  //                end;
  //                if bJeton then
  //                  AddToMemo('Jeton Acquis !!');

                Except on E:Exception do
                  raise Exception.Create('Jeton -> ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString + ' - ' + E.Message);
                End;
              end;
              {$ENDREGION}

              Log.Log( '', 'Main', '', '', '', 'Status', 'Connexion à la base de données: ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString, logNotice, false, DM_GSDataMain.LogFreq, ltLocal );
              try
                IboDbClient.Open;
                Log.Log( '', 'Main', '', '', '', 'Status', 'Connecté', logInfo, false, DM_GSDataMain.LogFreq, ltLocal );
              except
                on E: Exception do
                begin
                  Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, ltLocal );
                  raise;
                end;
              end;

              if ISEasyIgnore then
              begin
                AddToMemo('Traitement ignoré car bascule du dossiers sur EASY');
              end
              else
              begin
                {$REGION ' ouverture des query '}
                // Récupération de la liste des magasins de la base de données
                Que_Magasins.Close();
                Que_Magasins.Open();
                {$ENDREGION ' ouverture des query '}

                while Not Que_Magasins.Eof do
                begin
                  MagId := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                  AddToMemo('Traitement du magasin : ' + Que_Magasins.FieldByName('mag_enseigne').AsString);
                  try
                    DM_GSDataWebService.Que_WsReprise.ParamByName('magid').AsInteger := MagId;
                    DM_GSDataWebService.Que_WsReprise.Open();
                    iShopError := 0;
                    if DM_GSDataWebService.Que_WsReprise.RecordCount > 0 then
                    begin
                      // recuperation de l'adresse du webservice !
                      WsUrl := DM_GSDataWebService.GetParamWSURL(MagId);
                      WsPassword := EncryptDecryptChaine(DM_GSDataWebService.GetParamWSPassword(MagId));
                      WsBaseClient := GetI_BaseClientNationale(true, WsUrl);

                      {$REGION ' connexion au webservice '}
                      Log.Log( '', 'WebService', '', '', '', 'Status', 'Connexion au WebService...', logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                      try
                        repeat
                          try
                            WsBaseClient.GetTime();
                            WebServiceOK := true;
                          except
                            on e : Exception do
                            begin
                              WebServiceOK := false;
                              RetryCount := RetryCount -1;
                              if RetryCount <= 0 then
                                raise EWebServiceUnavailable.Create(E.Message);
                              Sleep(RetryTime * 1000); // attente 1 minute
                              Log.Log( '', 'WebService', '', '', '', 'Status', 'Nouvelle tentative de connexion au WebService...', logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                            end;
                          end;
                        until WebServiceOK or (RetryCount <= 0);
                        Log.Log( '', 'WebService', '', '', '', 'Status', 'Ok', logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                      except
                        on E: Exception do
                          Log.Log( '', 'WebService', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                      end;
                      {$ENDREGION}

                      if WebServiceOK then
                      begin
                        dtProcess := Now;
                        while not DM_GSDataWebService.Que_WsReprise.Eof do
                        begin
                          wsr_id := DM_GSDataWebService.Que_WsReprise.FieldByName('wsr_id').AsInteger;
                          wsr_type := DM_GSDataWebService.Que_WsReprise.FieldByName('wsr_type').AsInteger;
                          wsr_idligne := DM_GSDataWebService.Que_WsReprise.FieldByName('wsr_idligne').AsInteger;
                          wsr_date := DM_GSDataWebService.Que_WsReprise.FieldByName('wsr_date').AsDateTime;

                          case wsr_type of
                            1 : // creation/modif client
                              if DM_GSDataWebService.TraiteCreatModifClient(WsBaseClient, WsPassword, MagId, wsr_id, wsr_idligne, wsr_date, ErrorMsg) then
                                DM_GSDataWebService.FlagAsSuppr(wsr_id)
                              else
                                AddToMemo('  Erreur sur ligne (ID ' + IntToStr(wsr_id) + ') : ' + ErrorMsg);
    //                        2 : // Enregistrement BR
    //                          if DM_GSDataWebService.TraiteEnregistrementBonReduc(WsBaseClient, WsPassword, MagId, wsr_id, wsr_idligne, ErrorMsg) then
    //                            DM_GSDataWebService.FlagAsSuppr(wsr_id)
    //                          else
    //                            AddToMemo('  Erreur sur ligne (ID ' + IntToStr(wsr_id) + ') : ' + ErrorMsg);
                            3 : // Utilisation Palier
                              if DM_GSDataWebService.TraiteUtilisationPalier(WsBaseClient, WsPassword, MagId, wsr_id, wsr_idligne, ErrorMsg) then
                                DM_GSDataWebService.FlagAsSuppr(wsr_id)
                              else begin
                                Inc( iShopError );
                                AddToMemo('  Erreur sur ligne (ID ' + IntToStr(wsr_id) + ') : ' + ErrorMsg);
                              end
                            else begin
                              Inc( iShopError );
                              AddToMemo('  Erreur sur ligne (ID ' + IntToStr(wsr_id) + ') : Type de traitement (' + IntToStr(wsr_type) + ') non pris en charge...');
                            end;
                          end;

                          DM_GSDataWebService.Que_WsReprise.Next();
                        end;
                        // Monitoring du nombre d'erreur
                        if iShopError > 0 then
                          Log.Log( '', 'WebService', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                            'Count', Format('%d/%d', [DM_GSDataWebService.Que_WsReprise.RecordCount - iShopError, DM_GSDataWebService.Que_WsReprise.RecordCount]),
                            logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType )
                        else
                          Log.Log( '', 'WebService', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                            'Count', Format('%d/%d', [DM_GSDataWebService.Que_WsReprise.RecordCount - iShopError, DM_GSDataWebService.Que_WsReprise.RecordCount]),
                            logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

                        AddToMemo('Fin de traitement...');
                        Log.Log( '', 'WebService', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                          'Status', 'Ok', logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                      end
                      else begin
                        Inc( iShopError );
                        AddToMemo('Web service non disponible...');
                        Log.Log( '', 'WebService', '', Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                          'Status', 'Non disponible', logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
                      end;
                    end
                    else begin
                      AddToMemo('Pas de données à traiter...');
                    end;
                  finally
                    DM_GSDataWebService.Que_WsReprise.Close();
                  end;

                  Que_Magasins.Next();
                end;
              end;
            Finally
              IboDbClient.Close;

              {$REGION ' Liberation du jeton '}
              if bJeton then
              begin
                Try
                  if Assigned(TokenManager) then
                  begin
                    TokenManager.releaseToken;
                    FreeAndNil(TokenManager);
                  end;

  //                StopTokenEnBoucle();      //Relache le jeton
                  bJeton := False;
                Except
                  on E:Exception do
                    raise Exception.Create('Jeton Liberation -> ' + E.Message);
                End;
              end;
              {$ENDREGION}
            End;
          Except
            on E:Exception do
              AddToMemo(' -> Exception : ' + E.ClassName + ' - ' + E.Message);
          End;

          // plage terminé ??
          // exit !!
          if Frac(Now()) >= DM_GsDataDbCfg.cds_Horaire.FieldByName('hor_hfin').AsDateTime then
            Break
          else
            DM_GsDataDbCfg.cds_Dossiers.Next;
        end;
        DM_GSDataExport.CloseFTP();
        DM_GSDataExport.CloseSFTP();
      finally
        DM_GsDataDbCfg.cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s', [ QuotedStr( IniStruct.Others.IdGsData ) ] );
        // rafraichissement des horaires ...
        LoadClientDataSet(
          DM_GsDataDbCfg.cds_Horaire,
          DM_GsDataDbCfg.Que_Horaire
        );
      end;

      FLabel.Caption        := 'Gestion du web service terminée';
      FProgressBar.Position := 0;
      Log.Log( '', 'Main', '', '', '', 'Status', 'Ok', logInfo, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
    except
      on E: Exception do
        Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
    end;

    AddToMemo('------------------------------------------------------');
    AddToMemo('Fin du traitement : WebService');
    AddToMemo('------------------------------------------------------');
  finally
    FreeAndNil(DM_GSDataWebService);
  end;
end;

procedure TDM_GSDataMain.ExportFiles(AExportType: TExportType);
var
  vListOfMagsByCustomerFiles, vUserChoices: TList<TCustomerFile>;
  vCustomerFile: TCustomerFile;
  vMags: TList<TMag>;
  vMag: TMag;
  vFicIDs: TList<Integer>;
  vUserActionSelect: Tfrm_UserActionSelect;
  vDebutTraitement, vSelectionHorairePrecedentExport: TDateTime;
  vCompareDebut, vCompareFin: TValueRelationship;
begin
  try
    Log.Log( '', 'Main', '', '', '', 'Status', Format( 'Export %s...', [ 'manuel' ] ), logNotice, true, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
    try
      clearErrors ;

      {$REGION 'Initialisation'}
      GLOGSPATH := GAPPPATH + 'Logs\' + FormatDateTime('YYYY\MM\DD\',Now);
      GLOGSNAME := FormatDateTime('YYYYMMDDHHmmsszzz',Now) + '.txt';
      DoDir(GLOGSPATH);
      {$ENDREGION}

      AddToMemo('------------------------------------------------------');
      AddToMemo('Début du traitement : Export de fichiers');
      AddToMemo('------------------------------------------------------');
      vDebutTraitement := Now;
      vSelectionHorairePrecedentExport := 0;

      try
        // Fermeture et ouverture de la base de données locale
        LoadClientDataSet(
          DM_GsDataDbCfg.cds_Dossiers,
          DM_GsDataDbCfg.Que_Dossiers
        );
        LoadClientDataSet(
          DM_GsDataDbCfg.cds_SelectedFiles,
          DM_GsDataDbCfg.Que_SelectedFiles
        );
        LoadClientDataSet(
          DM_GsDataDbCfg.cds_Magasin,
          DM_GsDataDbCfg.Que_Magasin
        );

        // Filtrer la base données pour ne traiter que les bases avec même ID
        DM_GsDataDbCfg.cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s and DOS_ACTIVE = 1', [ QuotedStr( IniStruct.Others.IdGsData ) ] );

        // Regroupement des magasins sur les dossiers.
        vListOfMagsByCustomerFiles := TList<TCustomerFile>.Create;
        while Not DM_GsDataDbCfg.cds_Dossiers.Eof do
        begin
          IboDbClient.Close;
          IboDbClient.DatabaseName := AnsiString(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString);
          IboDbClient.Open;

//          TestDataBaseConnexion(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString,'ginkoia','ginkoia');

          if Assigned(vMags) then
            vMags := nil;
          vMags := TList<TMag>.Create;

          if ISEasyIgnore then
          begin
            AddToMemo('Traitement ignoré car bascule du dossiers sur EASY');
          end
          else
          begin
            Que_Magasins.Close;
            Que_Magasins.Open;
            Que_Magasins.First;
            vMags.Clear;
            while Not Que_Magasins.Eof do
            begin
              if (Que_Magasins.FieldByName('MAG_ID').AsInteger <> 0)
                and DM_GsDataDbCfg.cds_Magasin.Locate('mag_idginkoia', Que_Magasins.FieldByName('MAG_ID').AsInteger, [])
                and DM_GsDataDbCfg.cds_Magasin.FieldByName('mag_doexp').AsBoolean then
              begin
                vMag.FMagID := Que_Magasins.FieldByName('MAG_ID').AsInteger;
                vMag.FMagEnseigne := Que_Magasins.FieldByName('MAG_ENSEIGNE').AsString;
                vMags.Add(vMag);
              end;
              Que_Magasins.Next;
            end;
          end;

          vCustomerFile.FCustomerFileID := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_ID').AsInteger;
          vCustomerFile.FCustomerFileName := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_NOM').AsString;
          vCustomerFile.FCustomerFilePath := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString;
          vCustomerFile.FMags := vMags;
          vListOfMagsByCustomerFiles.Add(vCustomerFile);
          DM_GsDataDbCfg.cds_Dossiers.Next;
        end;

        if not DM_GsDataDbCfg.cds_SelectedFiles.IsEmpty then
        begin
          if AExportType = etSelectStores then
          begin
            vUserActionSelect := Tfrm_UserActionSelect.Create(Application.MainForm, 'Export des fichiers', vListOfMagsByCustomerFiles, DM_GsDataDbCfg.cds_SelectedFiles);
            case vUserActionSelect.ShowModal of
              mrOk:
              begin
                vFicIDs := vUserActionSelect.FileIDs;
                vUserChoices := vUserActionSelect.UserChoices;
              end;

              mrCancel:
                raise EAbortStoreExport.Create('annulé');
            end;
          end
          else
          begin
            vUserChoices := vListOfMagsByCustomerFiles;
            vFicIDs := TList<Integer>.Create;

            DM_GsDataDbCfg.cds_SelectedFiles.First;
            while not DM_GsDataDbCfg.cds_SelectedFiles.Eof do
            begin
              vCompareDebut := CompareTime(vDebutTraitement, DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('HOR_HDEB').AsDateTime);
              vCompareFin := CompareTime(vDebutTraitement, DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('HOR_HFIN').AsDateTime);

              if AExportType = etAuto then
              begin
                if ((vCompareDebut = EqualsValue) or (vCompareDebut = GreaterThanValue))
                  and ((vCompareFin = LessThanValue) or (vCompareFin = EqualsValue)) then
                  vFicIDs.Add(DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('FIC_ID').AsInteger);
              end
              else // AExportType = etEveryStores
              begin
                // On va récupérer
                if (vSelectionHorairePrecedentExport = 0) or (vSelectionHorairePrecedentExport = DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('HOR_HDEB').AsDateTime) then
                begin
                  vCompareDebut := CompareTime(DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('HOR_HDEB').AsDateTime, vDebutTraitement);

                  if (vCompareDebut = EqualsValue) or (vCompareDebut = LessThanValue) then
                  begin
                    vFicIDs.Add(DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('FIC_ID').AsInteger);
                    vSelectionHorairePrecedentExport := DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('HOR_HDEB').AsDateTime;
                  end;
                end;
              end;

              DM_GsDataDbCfg.cds_SelectedFiles.Next;
            end;

            // Si on a pas récupérer l'horaire précédent, on récupère l'horaire le plus tard.
            if (vFicIDs.Count = 0) and (AExportType = etEveryStores) then
            begin
              // Il y a un ORDER BY HOR_HDEB dans la requête, le premier résultat sera donc l'horaire le plus élevé.
              DM_GsDataDbCfg.cds_SelectedFiles.First;
              vSelectionHorairePrecedentExport := DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('HOR_HDEB').AsDateTime;

              while not DM_GsDataDbCfg.cds_SelectedFiles.Eof do
              begin
                vCompareDebut := CompareTime(vSelectionHorairePrecedentExport, DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('HOR_HDEB').AsDateTime);
                if vCompareDebut = EqualsValue then
                  vFicIDs.Add(DM_GsDataDbCfg.cds_SelectedFiles.FieldByName('FIC_ID').AsInteger)
                else
                  Break;
                DM_GsDataDbCfg.cds_SelectedFiles.Next;
              end;
            end;
          end;
        end
        else
          raise EAbortStoreExport.Create('Aucun fichiers dans la liste de fichiers des horaires.');

        ExecuteProcessExport(AExportType, vUserChoices, vFicIDs);
      finally
        IboDbClient.Close;
        Que_Magasins.Close;
        DM_GsDataDbCfg.cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s', [ QuotedStr( IniStruct.Others.IdGsData ) ] );
        // rafraichissement des horaires ...
        LoadClientDataSet(
          DM_GsDataDbCfg.cds_Horaire,
          DM_GsDataDbCfg.Que_Horaire
        );
      end;

      FLabel.Caption        := 'Export terminé';
      FProgressBar.Position := 0;
      Log.Log( '', 'Main', '', '', '', 'Status', 'Ok', logInfo, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
    except
      on E: Exception do
      begin
        Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
        AddToMemo(E.Message);
      end;
    end;
  finally
    AddToMemo('------------------------------------------------------');
    AddToMemo('Fin du traitement : Export de fichiers');
    AddToMemo('------------------------------------------------------');
  end;
end;

function TDM_GSDataMain.FillLogRefWithLameGUID : string;
begin
  try
    try
      Que_Tmp.Close;
      Que_Tmp.SQL.Text := 'select genbases.bas_guid ' +
                          'from genbases ' +
                          'join k kbas on kbas.k_id = genbases.bas_id and kbas.k_enabled = 1 ' +
                          'where genbases.bas_ident = ''0'' ';
      Que_Tmp.Open;
      case Que_Tmp.RecordCount of
        1: Result := Que_Tmp.FieldByName( 'bas_guid' ).AsString;
        else Result := '';
      end;
    finally
      Que_Tmp.Close;
      Que_Tmp.SQL.Clear;
    end;
  except
    // Au pires on l'a pas récupéré ^^
  end;
end;

function TDM_GSDataMain.ISEasyIgnore: Boolean;
var
  vLogRef : string;
  vOldLogApp : string;
begin
  Result := False;

  vOldLogApp := Log.App;
  Log.App := 'Delos2Easy';

  try
    vLogRef := FillLogRefWithLameGUID();

    // Récupération des paramètres 80
    Que_Tmp.Close;
    Que_Tmp.SQL.Clear;
    Que_Tmp.SQL.Add('SELECT * FROM GENPARAM');
    Que_Tmp.SQL.Add('  Join K on K_ID = PRM_ID and K_Enabled = 1');
    Que_Tmp.SQL.Add('  JOIN genbases ON bas_id = prm_pos');
    Que_Tmp.SQL.Add('  JOIN genparambase ON bas_ident = par_string');
    Que_Tmp.SQL.Add('WHERE par_nom = ''IDGENERATEUR''');
    Que_Tmp.SQL.Add('  and PRM_TYPE = 80 and PRM_CODE = 2');
    Que_Tmp.Open;

    if not Que_Tmp.IsEmpty then
    BEGIN
      // Les paramètres existent donc on vérifie les actions à faire
      while not Que_Tmp.EOF do
      begin
        if (Que_Tmp.FieldByName('PRM_INTEGER').AsInteger = 200) and
           ((CompareDateTime(Now, IncHour(FloatToDateTime(Que_Tmp.FieldByName('PRM_FLOAT').AsFloat), -24) ) >= EqualsValue)) then
         begin
          Que_Tmp2.SQL.Clear;
          Que_Tmp2.SQL.Text := Format('UPDATE GENPARAM SET PRM_INTEGER = 300 WHERE PRM_ID = %d',[Que_Tmp.FieldByName('PRM_ID').AsInteger]);
          Que_tmp2.ExecSQL;
          Que_Tmp2.Close;

          Que_Tmp2.SQL.Clear;
          Que_Tmp2.SQL.Text := Format('EXECUTE PROCEDURE PR_UPDATEK(%d,0)',[Que_Tmp.FieldByName('PRM_ID').AsInteger]);
          Que_tmp2.ExecSQL;
          Que_Tmp2.Close;

          Log.Log( '', 'GSDATA', DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_NOM').AsString, vLogRef, '', 'DEREFERENCEMENT', 'En attente', logInfo, True, LogFreq, LogType);

          Result := True;
          Exit;
         end;

        if (Que_Tmp.FieldByName('PRM_INTEGER').AsInteger >= 300) and (Que_Tmp.FieldByName('PRM_INTEGER').AsInteger< 1000) and
           ((CompareDate(Now, FloatToDateTime(Que_Tmp.FieldByName('PRM_FLOAT').AsFloat) - 1) >= EqualsValue)) then
         begin
          Result := True;
          Exit;
         end;


        if (Que_Tmp.FieldByName('PRM_INTEGER').AsInteger = 1000) then
        begin
           Try
             // Désactivation du dossier
             DM_GsDataDbCfg.Que_MAJ.IB_Transaction.StartTransaction;
             DM_GsDataDbCfg.Que_MAJ.Close;
             DM_GsDataDbCfg.Que_MAJ.SQL.Clear;
             DM_GsDataDbCfg.Que_MAJ.SQL.Add('UPDATE DOSSIERS SET');
             DM_GsDataDbCfg.Que_MAJ.SQL.Add('DOS_ACTIVE = 0, DOS_ENABLED = 0');
             DM_GsDataDbCfg.Que_MAJ.SQL.Add('Where DOS_ID = :PDOSID');
             DM_GsDataDbCfg.Que_MAJ.ParamCheck := True;
             DM_GsDataDbCfg.Que_MAJ.ParamByName('PDOSID').AsInteger := DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_ID').AsInteger;
             DM_GsDataDbCfg.Que_MAJ.ExecSQL;
             DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Commit;
             Result := True;

             Log.Log( '', 'GSDATA', DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_NOM').AsString, vLogRef, '', 'DEREFERENCEMENT', 'OK', logInfo, True, LogFreq, LogType);

           Except on E:Exception do
             begin
               DM_GsDataDbCfg.Que_MAJ.IB_Transaction.Rollback;
               Log.Log( '', 'GSDATA', DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_NOM').AsString, vLogRef, '', 'DEREFERENCEMENT', 'Erreur : ' + E.Message, logInfo, True, LogFreq, LogType);
             end;
           End;
           Exit;
        end;
        Que_Tmp.Next;
      end;

    END;
  finally
    Log.App := vOldLogApp;
  end;
end;

procedure TDM_GSDataMain.ForEachFileNames(const FileNames: TStringDynArray;
  Proc: TProc<String>);
var
  FileName: TFileName;
begin
  for FileName in FileNames do
    Proc( FileName );
end;

function TDM_GSDataMain.GetMagType: TMagType;
var
  LogRef: String;
begin
  Result := GetMagType( LogRef );
end;

//CAF
function TDM_GSDataMain.GetMagMode: TMagMode;
var
  LogRef: String;
begin
  Result := GetMagMode( LogRef );
end;
//

function TDM_GSDataMain.GetStreamForFileName(const FileName: TFileName): String;
begin
  (* "<flux><mag_codeadh>.dddddd.yyyymmddhhmmss" (ex: "ARTICL1860.000222.20150316220119")*)
  Result := LeftStr( Filename, Pred( Pos( '.', Filename ) ) );
  (* Result = "<flux><mag_codeadh>" *)
  Result := StringReplace( Result, Que_Magasins.FieldByName('MAG_CODEADH').AsString, SysUtils.EmptyStr, [ rfIgnoreCase ] );
  (* Result = "<flux>" *)
end;

function TDM_GSDataMain.GetMagType(out LogRef: String): TMagType;
var
  PrmInteger, PrmMagid: Integer;
begin
  if Que_Magasins.Active then
  begin
    PrmMagid := Que_Magasins.FieldByName( 'MAG_ID' ).AsInteger;
    LogRef := Que_Magasins.FieldByName( 'MAG_ENSEIGNE' ).AsString;
  end
  else
  begin
    {$REGION 'Récupération du PrmMagid et du LogRef'}
    try
      Que_Magasins.Open;
      if Que_Magasins.Locate( 'MAG_ID', DM_GsDataDbCfg.cds_Magasin.FieldByName( 'mag_idginkoia' ).AsInteger, [] ) then begin
        PrmMagid := Que_Magasins.FieldByName( 'MAG_ID' ).AsInteger;
        LogRef := Que_Magasins.FieldByName( 'MAG_ENSEIGNE' ).AsString;
      end;
    finally
      Que_Magasins.Close;
    end;
    {$ENDREGION}
  end;
  PrmInteger := DM_GSDataExport.GetParamInteger( 16, 7, PrmMagid );
  case PrmInteger of
    Ord( TMagType.mtNone ):
      Exit( TMagType.mtNone );
    Ord( TMagType.mtGoSport ):
      Exit( TMagType.mtGoSport );
    Ord( TMagType.mtCourir ):
      Exit( TMagType.mtCourir );
    else
      Exit( TMagType( PrmInteger ) );
//      raise ENotImplemented.CreateFmt('GetMagType.DM_GSDataExport.GetParamInteger(16,7,%d)=%d', [ GinMagId, PrmInteger ] );
  end;
end;

//CAF
function TDM_GSDataMain.GetMagMode(out LogRef: String): TMagMode;
var
  PrmInteger, PrmMagid: Integer;
begin
  if Que_Magasins.Active then
  begin
    PrmMagid := Que_Magasins.FieldByName( 'MAG_ID' ).AsInteger;
    LogRef := Que_Magasins.FieldByName( 'MAG_ENSEIGNE' ).AsString;
  end
  else
  begin
    {$REGION 'Récupération du PrmMagid et du LogRef'}
    try
      Que_Magasins.Open;
      if Que_Magasins.Locate( 'MAG_ID', DM_GsDataDbCfg.cds_Magasin.FieldByName( 'mag_idginkoia' ).AsInteger, [] ) then begin
        PrmMagid := Que_Magasins.FieldByName( 'MAG_ID' ).AsInteger;
        LogRef := Que_Magasins.FieldByName( 'MAG_ENSEIGNE' ).AsString;
      end;
    finally
      Que_Magasins.Close;
    end;
    {$ENDREGION}
  end;
  PrmInteger := DM_GSDataExport.GetParamInteger( 16, 32, PrmMagid );
  case PrmInteger of
    Ord( TMagMode.mtAutre ):
      Exit( TMagMode.mtAutre );
    Ord( TMagMode.mtAffilie ):
      Exit( TMagMode.mtAffilie );
    Ord( TMagMode.mtCAF ):
      Exit( TMagMode.mtCAF );
    Ord( TMagMode.mtMandat ):
      Exit( TMagMode.mtMandat );
    else
      Exit( TMagMode( PrmInteger ) );
  end;
end;
//

procedure TDM_GSDataMain.InitializeLog;
begin
  FLogFreq := 86400;
  {$IFDEF DEBUG}
  FLogType := uLog.TLogType.ltLocal;  // ltLocal
//  Log.OnLog := OnLog;
  {$ELSE}
  FLogType := uLog.TLogType.ltBoth;
  {$ENDIF}
end;

procedure TDM_GSDataMain.InitPxADate;
begin
  if MessageDlg('Etes vous sûr de vouloir modifier les prix à date du dossier : ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_NOM').AsString,mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
//JB
    GLOGSPATH := GAPPPATH + 'Logs\' + FormatDateTime('YYYY\MM\DD\',Now);
    GLOGSNAME := FormatDateTime('YYYYMMDDHHmmsszzz',Now) + '.txt';
    DoDir(GLOGSPATH);
//
    try
      try
        AddToMemo('Début du traitement à date : ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_NOM').AsString);
        IboDbClient.Close;
        IboDbClient.DatabaseName := AnsiString(DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString);

        Log.Log( '', 'Main', '', '', '', 'Status', 'Connexion à la base de données: ' + DM_GsDataDbCfg.cds_Dossiers.FieldByName('DOS_PATH').AsString, logNotice, false, DM_GSDataMain.LogFreq, ltLocal );
        try
          IboDbClient.Open;
          Log.Log( '', 'Main', '', '', '', 'Status', 'Connecté', logInfo, false, DM_GSDataMain.LogFreq, ltLocal );
        except
          on E: Exception do
          begin
            Log.Log( '', 'Main', '', '', '', 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, ltLocal );
            raise;
          end;
        end;

        With Que_Tmp do 
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE TARVALID SET TVD_ETAT=1 WHERE TVD_DT<=CURRENT_TIMESTAMP;');
          ExecSQL;

          Close;
          SQL.Clear;
//JB
          SQL.Add('SELECT * FROM MAJ_PXVTE_ADATE(CURRENT_TIMESTAMP,-1);');
//          SQL.Add('SELECT * FROM MAJ_PXVTE_ADATE(CURRENT_TIMESTAMP);');
          Open;

          AddToMemo('Traitement terminé');
        end;
      finally
        IboDbClient.Close;
      end;
    Except on E:Exception do
      begin
        AddToMemo(E.Message);
      end;
    end;
  end;
end;

//----------------------------------------------------------> LoopAutoActive

function TDM_GSDataMain.LoadCds(Qry: TIBOQuery; Cds: TClientDataSet;
  const OFE_CHRONO: string): Boolean;
var
  i, FieldIndex : Integer;
  FieldName     : String;
begin
  //Function qui permet de remplir les clientdataset avec la query passer en parametre
  //Je parcours toutes les lignes de la Qry
  Qry.First;
  try
    while not Qry.Eof do
    begin
      I := 0;
      //je parcours tous les fields du cds
      Cds.Append;
      for I := 0 to Qry.FieldList.Count - 1 do
      begin
        FieldIndex := Cds.FieldList.IndexOf(Qry.FieldList.Fields[i].FieldName);
        FieldName  := Qry.FieldList.Fields[i].FieldName;
        if FieldIndex <> -1 then
        begin
          Cds.FieldList.Fields[FieldIndex].Value := Qry.FieldList.Fields[i].Value;
        end else
        begin
          if OFE_CHRONO <> '' then
          begin
            Cds.FieldList.Fields[0].Value := OFE_CHRONO;
          end else
          begin
            FieldIndex := -1;
          end;
        end;
      end;
      Cds.Post;
      Qry.Next;
    end;
  except on e : Exception do
    begin
      raise Exception.Create('Chargement des données en mémoire ->' + E.Message);
    end;
  end;

end;

function TDM_GSDataMain.LoadCdsMag(QryFourn, QrySelect: TIBOQuery;
  Cds: TClientDataSet; const OFE_CHRONO: string): Boolean;
var
  i, FieldIndex : Integer;
begin
  //Procedure qui rempli le cds_OFRMAGASIN
  //Je parcours toutes les lignes de la Qry
  QrySelect.First;
  try
    while not QrySelect.eof do
    begin
      if QryFourn.Locate('FOU_ID', QrySelect.FieldByName('OFM_MAGID').AsInteger, []) then
      begin
        Cds.Append;
        cds.FieldByName('OFM_OFECHRONO').AsString := OFE_CHRONO;
        Cds.FieldByName('OFM_FOUCODE').AsString   := QryFourn.FieldByName('FOU_CODE').AsString;
        Cds.FieldByName('OFM_FOUNOM').AsString    := QryFourn.FieldByName('FOU_NOM').AsString;
        Cds.Post;
      end;
      QrySelect.Next;
    end;
  except on e : Exception do
    begin
      raise Exception.Create('Chargement des données en mémoire ->' + E.Message);
    end;
  end;
end;

procedure TDM_GSDataMain.LoadClientDataSet(const ClientDataSet: TClientDataSet;
  const IBODataset: TIBODataset);
begin
  if not Assigned( ClientDataSet ) then
    Exit;

  try
    ClientDataSet.LoadFromDataSet( IBODataset );
    DisplayConnectionStatus( False );
  except
    on E: Exception do
    begin
      DisplayConnectionStatus( True );
      Log.Log( '', 'Main', '', '', '', 'Status', 'Perte de connexion local', logError, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
      RestartNeed := True;
      AddToLog( E.Message );
    end;
  end;
end;

procedure TDM_GSDataMain.LogLastTickets;
var
  QueMagasinsActived: Boolean;
  Bookmark: TBookmark;
begin
  try
    QueMagasinsActived := Que_Magasins.Active;
    try
      if not QueMagasinsActived then
        Que_Magasins.Open;
      try
        Que_Tmp.Close;
        Que_Tmp.SQL.Text := 'select max( cshticket.tke_date ) TKE_DATE ' +
                            'from genmagasin ' +
                            'join k kmag on kmag.k_id = genmagasin.mag_id and kmag.k_enabled = 1 ' +
                            'join genposte on genposte.pos_magid = genmagasin.mag_id ' +
                            'join k kpos on kpos.k_id = genposte.pos_id and kpos.k_enabled = 1 ' +
                            'join cshsession on cshsession.ses_posid = genposte.pos_id ' +
                            'join k kses on kses.k_id = cshsession.ses_id and kses.k_enabled = 1 ' +
                            'join cshticket on cshticket.tke_sesid = cshsession.ses_id ' +
                            'join k ktke on ktke.k_id = cshticket.tke_id and ktke.k_enabled = 1 ' +
                            'where genmagasin.mag_id != 0 ' +
                            '  and genmagasin.mag_id = :MAG_ID ';

        Bookmark := Que_Magasins.GetBookmark;
        try
          Que_Magasins.First;
          while not Que_Magasins.Eof do
          begin
            try
              try
                // Pour chacun des mag_id...
                try
                  Que_Tmp.ParamByName( 'MAG_ID' ).AsInteger := Que_Magasins.FieldByName( 'MAG_ID' ).AsInteger;
                  Que_Tmp.Open;
                  case Que_Tmp.RecordCount of
                    0  : raise Exception.Create('Aucun ticket trouvé');
                    1  : Log.Log( '', 'Ticket', '',
                           Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                           'Last', uLog.DateTimeToIso8601( Que_Tmp.FieldByName( 'TKE_DATE' ).AsDateTime ), logInfo, True, 0 );
                    else raise Exception.Create('Plusieurs tickets trouvés');
                  end;
                finally
                  Que_Tmp.Close;
                end;
              except
                on E: Exception do
                begin
                  Log.Log( '', 'Ticket', '',
                    Que_Magasins.FieldByName( 'BAS_GUID' ).AsString, Que_Magasins.FieldByName( 'MAG_ID' ).AsString,
                    'Last', E.Message, logError, True, 0 );
                end;
              end;
            finally
              Que_Magasins.Next;
            end;
          end;
        finally
          Que_Magasins.GotoBookmark( Bookmark );
          Que_Magasins.FreeBookmark( Bookmark );
        end;
      finally
        Que_Tmp.SQL.Clear;
      end;
    finally
      if not QueMagasinsActived then
        Que_Magasins.Close;
    end;
  except
    // Au pires on n'a pas récupéré le dernier ticket ^^'
  end;
end;

procedure TDM_GSDataMain.LoopAutoActive(iNbNew: Integer);
begin
 if iNbNew >= 700 then
  begin
    TRY
      // Activation du loop Article
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := '';
      IbStProc_SetLoop.ParamByName('NOM_SUBSCRIBER').AsString := 'ARTICLE_';
      IbStProc_SetLoop.ParamByName('FLAGACTIVE').AsInteger := 1;
      IbStProc_SetLoop.Prepare;
      IbStProc_SetLoop.Execute;
      IbStProc_SetLoop.Unprepare;
      IbStProc_SetLoop.IB_Transaction.Commit;
    EXCEPT
      ON E: Exception DO
      BEGIN
        IbStProc_SetLoop.IB_Transaction.Rollback;
        raise Exception.Create('LoopAutoActive ->' + E.Message);
      END;
    END;

    TRY
      // Activation du loop Dimension
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := '';
      IbStProc_SetLoop.ParamByName('NOM_SUBSCRIBER').AsString := 'DIMENSION_';
      IbStProc_SetLoop.ParamByName('FLAGACTIVE').AsInteger := 1;
      IbStProc_SetLoop.Prepare;
      IbStProc_SetLoop.Execute;
      IbStProc_SetLoop.Unprepare;
      IbStProc_SetLoop.IB_Transaction.Commit;
    EXCEPT
      ON E: Exception DO
      BEGIN
        IbStProc_SetLoop.IB_Transaction.Rollback;
        raise Exception.Create('LoopAutoActive ->' + E.Message);
      END;
    END;

    TRY
      // Activation du loop Commande
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := '';
      IbStProc_SetLoop.ParamByName('NOM_SUBSCRIBER').AsString := 'COMMANDE_';
      IbStProc_SetLoop.ParamByName('FLAGACTIVE').AsInteger := 1;
      IbStProc_SetLoop.Prepare;
      IbStProc_SetLoop.Execute;
      IbStProc_SetLoop.Unprepare;
      IbStProc_SetLoop.IB_Transaction.Commit;
    EXCEPT
      ON E: Exception DO
      BEGIN
        IbStProc_SetLoop.IB_Transaction.Rollback;
        raise Exception.Create('LoopAutoActive ->' + E.Message);
      END;
    END;
  end;
end;

end.

