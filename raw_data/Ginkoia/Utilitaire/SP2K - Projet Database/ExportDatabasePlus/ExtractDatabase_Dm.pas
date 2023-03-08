unit ExtractDatabase_Dm;

interface

uses
  SysUtils, Forms, Classes, IBSQL, DB, IBCustomDataSet, IBQuery, IBDatabase,
  ADODB, AdvProgr, RzLabel, DateUtils;

type
  stRecordMvt = record
    // Général
    iDosid, iMagId: integer;
    // Infos article
    iArtId, iArtPseudo, iMrkIdRef, iGtfId: integer;
    sArtNom, sArtRefMrk, sMrkNom, sArtFedas, sGtfNom, sDateCree: string;
    // Infos mouvement
    iMvtId, iTyp, iQte, iKEnabled: integer;
    dtDateMvt, dtDateLivr, dtModif: TDateTime;
    fPxBrutTTC, fPxBrutHT: double;
    fPxNetTTC, fPxNetHT: double;
    fPump, fTva: double;
    fArtPump: double;
    iCodeTypeVente, iFouId: integer;
    sTypeVente, sCollection: string;
    iTkeId: integer;

    // Tailles / couleurs
    iTgfId, iCouId: integer;
    sTgfNom, sCouNom, sCouCode: string;
  end;

type
  TDm_ExtractDatabase = class(TDataModule)
    Ginkoia: TIBDatabase;
    IbSql_MajProc: TIBSQL;
    IbT_Ginkoia: TIBTransaction;
    QMvt: TIBQuery;
    IBQue_InitDtb: TIBQuery;
    ADODatabase: TADOConnection;
    AdQue_GetListMags: TADOQuery;
    Ps_Article: TADOStoredProc;
    Ps_CbArt: TADOStoredProc;
    AdQue_GetListMagsmag_id: TAutoIncField;
    AdQue_GetListMagsmag_dtbdateactivation: TDateTimeField;
    AdQue_GetListMagsmag_code: TStringField;
    AdQue_GetListMagsmag_cheminbase: TStringField;
    AdQue_GetListMagsdos_id: TAutoIncField;
    AdQue_GetListMagsmag_nom: TStringField;
    AdQue_GetListMagsreplic: TDateTimeField;
    IBQue_InitDtbARTID: TIntegerField;
    IBQue_InitDtbARFID: TIntegerField;
    IBQue_InitDtbARTREFMRK: TIBStringField;
    IBQue_InitDtbARTNOM: TIBStringField;
    IBQue_InitDtbARTFEDAS: TIBStringField;
    IBQue_InitDtbARFPSEUDO: TIntegerField;
    IBQue_InitDtbARFCREE: TDateField;
    IBQue_InitDtbCOUID: TIntegerField;
    IBQue_InitDtbCOUNOM: TIBStringField;
    IBQue_InitDtbCOUCODE: TIBStringField;
    IBQue_InitDtbTGFID: TIntegerField;
    IBQue_InitDtbTGFNOM: TIBStringField;
    IBQue_InitDtbGTFID: TIntegerField;
    IBQue_InitDtbGTFNOM: TIBStringField;
    IBQue_InitDtbCBICB: TIBStringField;
    IBQue_InitDtbTYPECB: TIntegerField;
    IBQue_InitDtbMRKIDREF: TIntegerField;
    IBQue_InitDtbMRKNOM: TIBStringField;
    Ps_Mouvement: TADOStoredProc;
    IBQue_InitDtbSTCQTE: TIntegerField;
    IBQue_GetMvt: TIBQuery;
    IBQue_GetMvtRETOUR: TIntegerField;
    IBQue_GetMvtMOVIDORIGINE: TIntegerField;
    IBQue_GetMvtMOVQTE: TIntegerField;
    IBQue_GetMvtMOVPXBRUTHT: TIBBCDField;
    IBQue_GetMvtMOVPXBRUTTTC: TIBBCDField;
    IBQue_GetMvtMOVPXNETHT: TIBBCDField;
    IBQue_GetMvtMOVPXNETTTC: TIBBCDField;
    IBQue_GetMvtMOVDATE: TDateTimeField;
    IBQue_GetMvtMOVTVA: TIBBCDField;
    IBQue_GetMvtMOVPUMP: TIBBCDField;
    IBQue_GetMvtMOVDTLIV: TDateTimeField;
    IBQue_GetMvtMOVTYPEVTE: TIntegerField;
    IBQue_GetMvtMOVTYPEVTELIB: TIBStringField;
    IBQue_GetMvtMOVCOLLEC: TIBStringField;
    IBQue_GetMvtMOVKVERSION: TIntegerField;
    IBQue_GetMvtMOVKENABLED: TIntegerField;
    IBQue_GetMvtARTIDORIGINE: TIntegerField;
    IBQue_GetMvtCOUIDORIGINE: TIntegerField;
    IBQue_GetMvtTGFIDORIGINE: TIntegerField;
    IBQue_GetMvtARFID: TIntegerField;
    IBQue_GetMvtARTREFMRK: TIBStringField;
    IBQue_GetMvtARTNOM: TIBStringField;
    IBQue_GetMvtARTFEDAS: TIBStringField;
    IBQue_GetMvtARFPSEUDO: TIntegerField;
    IBQue_GetMvtARFCREE: TDateField;
    IBQue_GetMvtARTPA: TIBBCDField;
    IBQue_GetMvtARTPV: TIBBCDField;
    IBQue_GetMvtCOUNOM: TIBStringField;
    IBQue_GetMvtCOUCODE: TIBStringField;
    IBQue_GetMvtTGFNOM: TIBStringField;
    IBQue_GetMvtGTFID: TIntegerField;
    IBQue_GetMvtGTFNOM: TIBStringField;
    IBQue_GetMvtMRKIDREF: TIntegerField;
    IBQue_GetMvtMRKNOM: TIBStringField;
    AdQue_KMax: TADOQuery;
    AdQue_KMaxmhi_typ: TWordField;
    AdQue_KMaxkmax: TIntegerField;
    IbQue_CurVersion: TIBQuery;
    IbQue_CurVersionNEWKEY: TIntegerField;
    AdQue_Histo: TADOQuery;
    AdQue_MajDateActiv: TADOQuery;
    IBQue_GetMvtFOUIDORIGINE: TIntegerField;
    IBQue_GetCB: TIBQuery;
    IBQue_GetCBCBICB: TIBStringField;
    IBQue_GetCBTYPECB: TIntegerField;
    Ps_Fournisseur: TADOStoredProc;
    IBQue_GetFourn: TIBQuery;
    IBQue_GetFournFOU_IDREF: TIntegerField;
    IBQue_GetFournFOU_NOM: TIBStringField;
    IBQue_GetMvtARTPUMP: TIBBCDField;
    IBQue_InitDtbRETOUR: TIntegerField;
    IBQue_InitDtbARTPUMP: TFMTBCDField;
    Ps_Ticket: TADOStoredProc;
    IBQue_GetEnc: TIBQuery;
    IBQue_GetEncENC_ID: TIntegerField;
    IBQue_GetEncMEN_NOM: TIBStringField;
    IBQue_GetEncENC_MONTANT: TFloatField;
    IBQue_GetEncK_ENABLED: TIntegerField;
    Ps_Enc: TADOStoredProc;
    IBQue_GetVersionAtDate: TIBQuery;
    IBQue_GetVersionAtDateKVERSION: TIntegerField;
    IBQue_GetMvtMOVKUPDATED: TDateTimeField;
    IBQue_GetMvtMOVIDENTETE: TIntegerField;
    IBQue_GetMvtTKEDATE: TDateTimeField;
    IBQue_GetMvtTKEBRUT: TIBBCDField;
    IBQue_GetMvtTKENET: TIBBCDField;
    IBQue_GetMvtTKEBECOL: TIBStringField;
    IBQue_InitDtbHSTID: TIntegerField;
    IBQue_GetFouById: TIBQuery;
    IntegerField1: TIntegerField;
    IBStringField1: TIBStringField;
    IBQue_GetFouIdRef: TIBQuery;
    IBQue_GetFouIdRefFOU_IDREF: TIntegerField;
    IBQue_GetFournFOU_ID: TIntegerField;
    IBQue_GetEncENC_BA: TFloatField;
    AdQue_MagTraite: TADOQuery;
    AdQue_MajMagTraite: TADOQuery;
    AutoIncField3: TAutoIncField;
    DateTimeField3: TDateTimeField;
    StringField4: TStringField;
    StringField5: TStringField;
    AutoIncField4: TAutoIncField;
    StringField6: TStringField;
    DateTimeField4: TDateTimeField;
    AdQue_MagTraiteTMP_FLAG: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure ADODatabaseAfterConnect(Sender: TObject);
    procedure ADODatabaseAfterDisconnect(Sender: TObject);
    procedure GinkoiaAfterConnect(Sender: TObject);
    procedure GinkoiaAfterDisconnect(Sender: TObject);
  private
    FMainProgress         : TAdvProgress;
    FLab_ConnexionStateDtb: TRzLabel;
    FLab_ConnexionStateGin: TRzLabel;
    FLab_State            : TRzLabel;
    FURLSrv               : string;
    dHeureFin             : TTime;
    dDateInitial          : TDateTime;

    { Déclarations privées }
    procedure SupprProcedure(AProcName: string);
    procedure SupprIndex(AIdxName: string);
    procedure CreerProcedure(AProcName: string);
    procedure CreerIndex(AIdxName: string);

    //function InitBase(AChemin, AMagAdh: string; ADosid, AMagId: integer; ADateInit: TDateTime): boolean;
    function TraiteBase(AChemin, AMagAdh: string; ADosid, AMagId: integer; ADateInit, ADateDebut: TDateTime): boolean;

    function InsertMvt(AMvt: stRecordMvt): boolean;
    function InitRecordMvt: stRecordMvt;

    Function GetCurVer(): integer;
    //function GetVerDate(ADateInit: TDateTime): integer;

    procedure InsertHisto(AResult, AMagId, AKDeb, AKFin, AType, ANb: integer; ADtDeb, ADtFin: TDateTime; AComment: string);

    procedure InitProgress(AMessage: string; AMax: integer);
    procedure DoProgress();
    procedure CloseProgress();
  public
    IBQue_GetVerDate       : TIBQuery;
    IBQue_GetVerDateVERSION: TIntegerField;
    { Déclarations publiques }
    procedure SupprToutesProcedures;
    procedure MajToutesProcedures;

    procedure DoTraitement(ADoInit, ADoTraitementAfterInit: boolean);

    property MainProgress: TAdvProgress read FMainProgress write FMainProgress;
    property Lab_ConnexionStateDtb: TRzLabel read FLab_ConnexionStateDtb write FLab_ConnexionStateDtb;
    property Lab_ConnexionStateGin: TRzLabel read FLab_ConnexionStateGin write FLab_ConnexionStateGin;
    property Lab_State: TRzLabel read FLab_State write FLab_State;

  end;

var
  Dm_ExtractDatabase: TDm_ExtractDatabase;

implementation

uses UCommon, IniFiles;

{$R *.dfm}

procedure TDm_ExtractDatabase.DataModuleCreate(Sender: TObject);
var
  sPathIni      : string;   // Chemin vers l'ini
  iniConfigAppli: TIniFile; // Manipulation du Fichier Ini

  iNivLog       : integer;  // Niveau de log à inscrire dans le fichier
begin
  // Cloture des connexions au cas ou
  ADODatabase.Close;
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

procedure TDm_ExtractDatabase.DoProgress();
begin
  if FMainProgress <> Nil then
  begin
    FMainProgress.StepIt;
    Application.ProcessMessages;
  end;
end;

procedure TDm_ExtractDatabase.DoTraitement(ADoInit, ADoTraitementAfterInit: boolean);
var
  sPathIni              : string;     // Chemin vers l'ini
  iniConfigAppli        : TIniFile;   // Manipulation du Fichier Ini
  sURLSrv               : string;     // URL Du serveur sur lequel se connecter.
  // wsPathConnectCatman  : Widestring; // Chaine de connexion CatMan
  wsPathConnectDatabase : Widestring; // Chaine de connexion Database

  iDosid               : integer;    // Contient l'id du dossier à traiter.
begin
  sPathIni         := ChangeFileExt(Application.ExeName, '.ini');
  try
    iniConfigAppli  := TIniFile.Create(sPathIni);
    sURLSrv         := iniConfigAppli.ReadString('DATABASE', 'URL', '');
    dDateInitial    := iniConfigAppli.ReadDate('DATE','DEBUT',0);
    dHeureFin       := iniConfigAppli.ReadTime('HEURE','FIN',0);
  finally
    FURLSrv        := sURLSrv;
    iniConfigAppli.Free;
  end;

  if sURLSrv <> '' then
  begin
    // wsPathConnectCatman := 'Provider=SQLOLEDB.1;Password=ch@mon1x;Persist Security Info=True;User ID=DA_GINKOIA;Initial Catalog=DATABASE;Data Source=' +
    // 'lame5.no-ip.com' +
    // // 'sp2kcat.no-ip.org' +
    // ';Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=BRUNON_NB;Use Encryption for Data=False;Tag with column collation when possible=False';

    wsPathConnectDatabase := 'Provider=SQLOLEDB.1;Password=ch@mon1x;Persist Security Info=True;User ID=DA_GINKOIA;Initial Catalog=DATABASE;Data Source=' +
      sURLSrv + ';Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=BRUNON_NB;Use Encryption for Data=False;Tag with column collation when possible=False';

    // Connection à la database CATMAN
    ADODatabase.ConnectionString := wsPathConnectDatabase;

    InitProgress('Connexion à ' + sURLSrv, 1);
    try
      ADODatabase.Open;
      DoProgress();

      // Récup des dos_id à initialiser
      AdQue_GetListMags.Close;
      AdQue_GetListMags.Open;
      AdQue_GetListMags.First;

      while (not AdQue_GetListMags.Eof) AND (Time < dHeureFin) do
      begin
        if not AdQue_GetListMagsreplic.IsNull then
        begin
          AdQue_MagTraite.Close;
          AdQue_MagTraite.Parameters[0].Value := AdQue_GetListMagsmag_id.Value;
          AdQue_MagTraite.Open;

          if AdQue_MagTraite.IsEmpty then     //Si pas d'enregistrement le magasin n'a jamais été traité.
          begin
            TraiteBase(AdQue_GetListMagsmag_cheminbase.AsString, AdQue_GetListMagsmag_code.AsString, AdQue_GetListMagsdos_id.AsInteger,
              AdQue_GetListMagsmag_id.AsInteger, AdQue_GetListMagsmag_dtbdateactivation.AsDateTime, dDateInitial);
          end;
        end;
        AdQue_GetListMags.Next;
      end;
      AdQue_GetListMags.Close;

    finally
      // Fermeture des connections
      ADODatabase.Close;

      CloseProgress;
    end;
  end
  else
  begin
    LogAction('URL Serveur non renseignée dans l''INI', 0);
  end;
end;

function TDm_ExtractDatabase.GetCurVer: integer;
begin
  IbQue_CurVersion.Open;
  Result := IbQue_CurVersionNEWKEY.AsInteger;
  IbQue_CurVersion.Close;
end;

//function TDm_ExtractDatabase.GetVerDate(ADateInit: TDateTime): integer;
//begin
//  IBQue_GetVersionAtDate.Close;
//  IBQue_GetVersionAtDate.Params[0].AsDateTime := ADateInit;
//  IBQue_GetVersionAtDate.Open;
//  Result                                      := IBQue_GetVersionAtDate.Fields[0].AsInteger;
//  IBQue_GetVersionAtDate.Close;
//
//  // IBQue_GetVerDate.Close;
//  // IBQue_GetVerDate.ParamByName('DATEINIT').AsDateTime := ADate;
//  // IBQue_GetVerDate.Open;
//  // Result := IBQue_GetVerDateVersion.AsInteger;
//  // IBQue_GetVerDate.Close;
//end;

procedure TDm_ExtractDatabase.GinkoiaAfterConnect(Sender: TObject);
begin
  // Info connexion
  Lab_ConnexionStateGin.Caption := 'GINKOIA - Connecté à : ' + Ginkoia.DatabaseName;
  Application.ProcessMessages;
end;

procedure TDm_ExtractDatabase.GinkoiaAfterDisconnect(Sender: TObject);
begin
  // Info connexion
  Lab_ConnexionStateGin.Caption := 'GINKOIA - Déconnecté';
  Application.ProcessMessages;
end;

//function TDm_ExtractDatabase.InitBase(AChemin, AMagAdh: string; ADosid, AMagId: integer; ADateInit: TDateTime): boolean;
//var
//  stMvtInit : stRecordMvt; // Variable contenant le mouvemnet à insérer
//  iArtId    : integer;     // Variable de test pour savoir si on a changé d'article.
//  iCouId    : integer;     // Variable de test pour savoir si on a changé de couleur.
//  iTgfId    : integer;     // Variable de test pour savoir si on a changé de taille.
//  iNbArt    : integer;     // Nombre d'articles
//
//  dtDebut   : TDateTime;   // Timestamp de début de traitement
//
//  vDate     : variant;     // Variable tampon pour mettre la date sur 4 car.
//
//  vArtIdDtb : variant;     // Valeur retournée par la procédure de création d'article.
//  vGtfIdDtb : variant;     // Valeur retournée par la procédure de création d'article.
//
//  vCodeEAN  : variant;     // Tampon pour contacténer le dosid et le code barre.
//  vTypeEAN  : variant;     // Tampon pour type de CB
//  vFouIdRef : variant;     // tampon pour stocker l'id ref du fournisseur
//
//  i         : integer;
//
//  iVersion  : integer; // Version actuelle de la base
//
//  bErreurMvt: boolean; // Erreur de traitement du mouvemnet on sortira
//begin
//  LogAction('Initialisation ' + AChemin, 3);
//
//  Result := False;
//  if AChemin = '' then
//  begin
//    Exit;
//  end;
//
//  InitProgress('Connexion base Ginkoia ' + AChemin, 1);
//  LogAction('Connexion base Ginkoia ' + AChemin, 3);
//
//  Ginkoia.DatabaseName := AChemin;
//  Ginkoia.Close;
//  TRY
//    Ginkoia.Open;
//    DoProgress;
//  EXCEPT
//    // Chemin inccorect à voir si on log, ca peut être normal tant qu'on a pas renseigné le chemin
//    // InsertHisto(1, AMagId, 0, iVersion, 12, iNbArt, dtDebut, Now(), 'Initialisation');
//    LogAction(AMagAdh + ' : Connection Gin échouée - ' + AChemin, 0);
//  END;
//
//  if Ginkoia.Connected then
//  begin
//    LogAction('Connexion base Ginkoia réussie', 3);
//    InitProgress('Mise à jour des procédures', 1);
//
//    Dm_ExtractDatabase.MajToutesProcedures;
//    DoProgress;
//
//    IbT_Ginkoia.StartTransaction;
//    ADODatabase.BeginTrans;
//    TRY
//      // Init
//      iNbArt  := 0;
//      dtDebut := Now();
//
//      // Param de la requete
//      IBQue_InitDtb.ParamByName('MAGCODEADH').AsString := AMagAdh;
//      IBQue_InitDtb.ParamByName('DATEINIT').AsDateTime := ADateInit;
//
//      InitProgress('Préparation de la liste des articles', 1);
//      IBQue_InitDtb.Open;
//      IBQue_InitDtb.FetchAll;
//      DoProgress;
//
//      InitProgress('Initialisation des articles', IBQue_InitDtb.RecordCount);
//
//      while not IBQue_InitDtb.Eof do
//      begin
//        iArtId := IBQue_InitDtb.FieldByName('ARTID').AsInteger;
//        vDate  := FormatDateTime('yyyy', IBQue_InitDtb.FieldByName('ARFCREE').AsDateTime);
//
//        // Insertion Article
//        Ps_Article.Parameters[1].Value  := 0;                                                // Output ARTID
//        Ps_Article.Parameters[2].Value  := 0;                                                // Output GTFID
//        Ps_Article.Parameters[3].Value  := ADosid;                                           // P_DOSID
//        Ps_Article.Parameters[4].Value  := IBQue_InitDtb.FieldByName('ARTID').AsVariant;     // P_ARTIDORIGINE int
//        Ps_Article.Parameters[5].Value  := IBQue_InitDtb.FieldByName('ARTNOM').AsVariant;    // P_ARTNOM VARHCAR(64)
//        Ps_Article.Parameters[6].Value  := IBQue_InitDtb.FieldByName('ARTREFMRK').AsVariant; // P_ARTREFMRK VARHCAR(64)
//        Ps_Article.Parameters[7].Value  := IBQue_InitDtb.FieldByName('MRKNOM').AsVariant;    // P_MRKNOM VARHCAR(64)
//        Ps_Article.Parameters[8].Value  := IBQue_InitDtb.FieldByName('MRKIDREF').AsVariant;  // P_MRKIDREF INT
//        Ps_Article.Parameters[9].Value  := IBQue_InitDtb.FieldByName('ARTFEDAS').AsVariant;  // P_ARTFEDAS  CHAR(6)
//        Ps_Article.Parameters[10].Value := IBQue_InitDtb.FieldByName('ARFPSEUDO').AsVariant; // P_ARTPSEUDO INT
//        Ps_Article.Parameters[11].Value := IBQue_InitDtb.FieldByName('GTFID').AsVariant;     // P_GTFIDORIGINE int
//        Ps_Article.Parameters[12].Value := IBQue_InitDtb.FieldByName('GTFNOM').AsVariant;    // P_GTFNOM VARCHAR (64)
//        Ps_Article.Parameters[13].Value := vDate;                                            // P_DATECREE VARCHAR(4)
//
//        Ps_Article.ExecProc;
//
//        IBQue_GetFourn.Close;
//        IBQue_GetFourn.ParamByName('ARTID').AsInteger := IBQue_InitDtb.FieldByName('ARTID').AsInteger;
//        IBQue_GetFourn.Open;
//        while not IBQue_GetFourn.Eof do
//        begin
//          IF IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger = 1 THEN
//          BEGIN
//            IBQue_GetFouIdRef.ParamByName('FOUID').AsInteger := IBQue_GetFourn.FieldByName('FOU_ID').AsInteger;
//            IBQue_GetFouIdRef.Open;
//            if NOT IBQue_GetFouIdRef.Eof then
//            begin
//              vFouIdRef := IBQue_GetFouIdRefFOU_IDREF.AsInteger;
//            end
//            else
//            begin
//              // Pas d'idref
//              vFouIdRef := 0;
//            end;
//            IBQue_GetFouIdRef.Close;
//          END
//          else
//          begin
//            // Pas d'idref
//            vFouIdRef := 0;
//          end;
//
//          Ps_Fournisseur.Parameters[1].Value := 0;                                               // @R_FOUID (output)
//          Ps_Fournisseur.Parameters[2].Value := ADosid;                                          // @P_DOSID int,
//          Ps_Fournisseur.Parameters[3].Value := IBQue_InitDtb.FieldByName('ARTID').AsVariant;    // @P_ARTIDORIGINE int,
//          Ps_Fournisseur.Parameters[4].Value := vFouIdRef;                                       // @P_FOUIDREF int,
//          Ps_Fournisseur.Parameters[5].Value := IBQue_GetFourn.FieldByName('FOU_NOM').AsVariant; // @P_FOUNOM int
//
//          Ps_Fournisseur.ExecProc;
//
//          IBQue_GetFourn.Next;
//        end;
//        IBQue_GetFourn.Close;
//
//        vArtIdDtb  := Ps_Article.Parameters[1].Value;
//        vGtfIdDtb  := Ps_Article.Parameters[2].Value;
//
//        iCouId     := 0;
//        iTgfId     := 0;
//        bErreurMvt := False;
//
//        while (iArtId = IBQue_InitDtb.FieldByName('ARTID').AsInteger) and (not IBQue_InitDtb.Eof) and (not bErreurMvt) do
//        begin
//          if IBQue_InitDtb.FieldByName('CBICB').AsString = '' then // demande client, pseudo sans CB  -> Artid_dossier
//          begin
//            LogAction('Init, Pas de CB' + IntToStr(IBQue_GetCB.RecordCount), 3);
//            vCodeEAN := IBQue_InitDtb.FieldByName('ARTID').AsString + '_' + IntToStr(ADosid);
//            vTypeEAN := 3;
//          end
//          else
//          begin
//            vTypeEAN := IBQue_InitDtb.FieldByName('TYPECB').AsVariant;
//            if IBQue_InitDtb.FieldByName('TYPECB').AsInteger = 3 then
//            begin
//              vCodeEAN := IBQue_InitDtb.FieldByName('CBICB').AsVariant + '_' + IntToStr(ADosid);
//            end
//            else
//            begin
//              vCodeEAN := IBQue_InitDtb.FieldByName('CBICB').AsVariant
//            end;
//          end;
//
//          Ps_CbArt.Parameters[1].Value  := vCodeEAN;                                       // P_CBIEAN VARCHAR(20),
//          Ps_CbArt.Parameters[2].Value  := vArtIdDtb;                                      // P_ARTID int,
//          Ps_CbArt.Parameters[3].Value  := IBQue_InitDtb.FieldByName('COUID').AsVariant;   // P_COUIDORIGINE int,
//          Ps_CbArt.Parameters[4].Value  := IBQue_InitDtb.FieldByName('COUNOM').AsVariant;  // P_COUNOM VARCHAR(64),
//          Ps_CbArt.Parameters[5].Value  := IBQue_InitDtb.FieldByName('COUCODE').AsVariant; // P_COUCODE VARCHAR(64),
//          Ps_CbArt.Parameters[6].Value  := IBQue_InitDtb.FieldByName('TGFID').AsVariant;   // P_TGFIDORIGINE int,
//          Ps_CbArt.Parameters[7].Value  := IBQue_InitDtb.FieldByName('TGFNOM').AsVariant;  // P_TGFNOM VARCHAR(32),
//          Ps_CbArt.Parameters[8].Value  := vGtfIdDtb;                                      // P_GTFID int,
//          Ps_CbArt.Parameters[9].Value  := IBQue_InitDtb.FieldByName('TYPECB').AsVariant;  // P_TYPE int
//          Ps_CbArt.Parameters[10].Value := 0;
//          Ps_CbArt.Parameters[11].Value := 0;
//
//          Ps_CbArt.ExecProc;
//
//          if (iCouId <> IBQue_InitDtb.FieldByName('COUID').AsInteger) OR (iTgfId <> IBQue_InitDtb.FieldByName('TGFID').AsVariant) then
//          begin
//            // Svg taille / coul
//            iCouId := IBQue_InitDtb.FieldByName('COUID').AsInteger;
//            iTgfId := IBQue_InitDtb.FieldByName('TGFID').AsVariant;
//
//            // Insere le mouvment
//            stMvtInit            := InitRecordMvt;
//
//            stMvtInit.iDosid     := ADosid;                                           // @P_DOSID int,
//            stMvtInit.iMagId     := AMagId;                                           // @P_MAGID int,
//            stMvtInit.iMvtId     := IBQue_InitDtb.FieldByName('HSTID').AsInteger;     // @P_MVTIDORIGINE int,
//            stMvtInit.iTyp       := 12;                                               // @P_MVTTYPE tinyint,
//            stMvtInit.dtDateMvt  := ADateInit;                                        // @P_MVTDATE datetime,
//            stMvtInit.iArtId     := IBQue_InitDtb.FieldByName('ARTID').AsInteger;     // @P_ARTIDORIGINE int,
//            stMvtInit.sArtNom    := IBQue_InitDtb.FieldByName('ARTNOM').AsString;     // @P_ARTNOM VARCHAR (64),
//            stMvtInit.sArtRefMrk := IBQue_InitDtb.FieldByName('ARTREFMRK').AsVariant; // @P_ARTREFMRK VARCHAR (64),
//            stMvtInit.sMrkNom    := IBQue_InitDtb.FieldByName('MRKNOM').AsString;     // @P_MRKNOM VARCHAR (64),
//            stMvtInit.iMrkIdRef  := IBQue_InitDtb.FieldByName('MRKIDREF').AsInteger;  // @P_MRKIDREF int,
//            stMvtInit.sArtFedas  := IBQue_InitDtb.FieldByName('ARTFEDAS').AsString;   // @P_ARTFEDAS CHAR (6),
//            stMvtInit.iArtPseudo := IBQue_InitDtb.FieldByName('ARFPSEUDO').AsInteger; // @P_ARTPSEUDO INT,
//            stMvtInit.iGtfId     := IBQue_InitDtb.FieldByName('GTFID').AsInteger;     // @P_GTFIDORIGINE INT,
//            stMvtInit.sGtfNom    := IBQue_InitDtb.FieldByName('GTFNOM').AsString;     // @P_GTFNOM VARCHAR (64),
//            stMvtInit.sDateCree  := String(vDate);                                    // @P_DATECREE VARCHAR(4),
//            stMvtInit.iTgfId     := IBQue_InitDtb.FieldByName('TGFID').AsInteger;     // @P_TGFIDORIGINE int,
//            stMvtInit.sTgfNom    := IBQue_InitDtb.FieldByName('TGFNOM').AsString;     // @P_TGFNOM VARCHAR(32),
//            stMvtInit.iCouId     := IBQue_InitDtb.FieldByName('COUID').AsInteger;     // @P_COUIDORIGINE int,
//            stMvtInit.sCouNom    := IBQue_InitDtb.FieldByName('COUNOM').AsString;     // @P_COUNOM VARCHAR(64),
//            stMvtInit.sCouCode   := IBQue_InitDtb.FieldByName('COUCODE').AsString;    // @P_COUCODE VARCHAR(64),
//            stMvtInit.iQte       := IBQue_InitDtb.FieldByName('STCQTE').AsInteger;    // @P_MVTQTE int,
//            stMvtInit.iKEnabled  := 1;                                                // @K_ENABLED int
//            stMvtInit.fPump      := IBQue_InitDtb.FieldByName('ARTPUMP').AsFloat;
//            stMvtInit.fArtPump   := IBQue_InitDtb.FieldByName('ARTPUMP').AsFloat;
//            stMvtInit.dtModif    := ADateInit;
//
//            IF InsertMvt(stMvtInit) THEN
//            begin
//              Inc(iNbArt)
//            end
//            else
//            begin
//              // Traiter l'erreur
//              bErreurMvt := True;
//            end;
//          end;
//
//          IBQue_InitDtb.Next;
//
//          DoProgress;
//        end;
//      end;
//
//      if not bErreurMvt then
//      begin
//        LogAction('Mouvements OK, recup version' + IntToStr(iNbArt), 1);
//
//        // LogAction('Mouvements OK, recup version' + inttostr(iNbArt), 1);
//
//        iVersion := GetVerDate(ADateInit);
//        InsertHisto(1, AMagId, 0, iVersion, 12, iNbArt, dtDebut, Now(), 'Initialisation');
//        for i    := 1 to 11 do
//          InsertHisto(1, AMagId, 0, iVersion, i, 0, dtDebut, Now(), 'Initialisation');
//
//        LogAction('Histo OK', 1);
//
//        ADODatabase.CommitTrans;
//
//        Result := True;
//      end
//      else
//      begin
//        LogAction('Erreur sur mouvement ' + IntToStr(stMvtInit.iMvtId), 1);
//        ADODatabase.RollbackTrans;
//        ADODatabase.BeginTrans;
//        InsertHisto(0, AMagId, 0, iVersion, 12, iNbArt, dtDebut, Now(), 'Initialisation échouée');
//        ADODatabase.CommitTrans;
//
//        Result := False;
//      end;
//    EXCEPT
//      ON E: Exception DO
//      begin
//        LogAction('Erreur d''intégration dans SQLServeur ' + IntToStr(stMvtInit.iMvtId), 1);
//        LogAction(E.Message, 1);
//        ADODatabase.RollbackTrans;
//
//        ADODatabase.BeginTrans;
//        try
//          InsertHisto(0, AMagId, 0, 0, 12, 0, dtDebut, Now(), 'Erreur d''intégration dans SQLServeur');
//        finally
//          ADODatabase.CommitTrans;
//        end;
//      end;
//    END;
//    IbT_Ginkoia.Commit;
//
//    IBQue_InitDtb.Close;
//    Dm_ExtractDatabase.SupprToutesProcedures;
//    Ginkoia.Close;
//  end;
//end;

procedure TDm_ExtractDatabase.InitProgress(AMessage: string; AMax: integer);
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

function TDm_ExtractDatabase.InitRecordMvt: stRecordMvt;
begin
  Result.iDosid         := 0;
  Result.iMagId         := 0;
  Result.iMvtId         := 0;
  Result.iTyp           := 0;
  Result.dtDateMvt      := 0;
  Result.iArtId         := 0;
  Result.sArtNom        := '';
  Result.sArtRefMrk     := '';
  Result.sMrkNom        := '';
  Result.iMrkIdRef      := 0;
  Result.sArtFedas      := '';
  Result.iArtPseudo     := 0;
  Result.iGtfId         := 0;
  Result.sGtfNom        := '';
  Result.sDateCree      := '';
  Result.iTgfId         := 0;
  Result.sTgfNom        := '';
  Result.iCouId         := 0;
  Result.sCouNom        := '';
  Result.sCouCode       := '';
  Result.iQte           := 0;
  Result.iKEnabled      := 1;
  Result.dtDateLivr     := 0;
  Result.fPxBrutTTC     := 0;
  Result.fPxBrutHT      := 0;
  Result.fPxNetTTC      := 0;
  Result.fPxNetHT       := 0;
  Result.fPump          := 0;
  Result.fTva           := 0;
  Result.iCodeTypeVente := 0;
  Result.sTypeVente     := '';
  Result.iFouId         := 0;
  Result.sCollection    := '';
  Result.fArtPump       := 0;
  Result.iTkeId         := 0;
  Result.dtModif        := 0;
end;

procedure TDm_ExtractDatabase.InsertHisto(AResult, AMagId, AKDeb, AKFin, AType, ANb: integer; ADtDeb, ADtFin: TDateTime; AComment: string);
begin
//  AdQue_Histo.Close;
//  AdQue_Histo.Parameters[0].Value := AMagId;  // Magasin
//  AdQue_Histo.Parameters[1].Value := AKDeb;   // kdeb;
//  AdQue_Histo.Parameters[2].Value := AKFin;   // kfin;
//  AdQue_Histo.Parameters[3].Value := ADtFin;  // date fin
//  AdQue_Histo.Parameters[4].Value := ADtDeb;  // Date deb
//  AdQue_Histo.Parameters[5].Value := 'T' + IntToStr(AType) + ' ' + AComment;
//  AdQue_Histo.Parameters[6].Value := AResult; // Ok = 1, pas ok = 0
//  AdQue_Histo.Parameters[7].Value := AType;   // Type mvt
//  AdQue_Histo.Parameters[8].Value := ANb;     // Nb mouvments traités (quand ok)
//  AdQue_Histo.ExecSQL;
//
//  LogAction('Insert Histo ' + IntToStr(AMagId) + '-' + IntToStr(AKDeb) + '-' + IntToStr(AKFin) + '-' + IntToStr(ANb) + '-' + IntToStr(AResult), 3);
end;

function TDm_ExtractDatabase.InsertMvt(AMvt: stRecordMvt): boolean;
var
  vFouIdRef: variant; // tampon pour stocker l'id ref du fournisseur
  vFouIDDtb: variant;
begin
  LogAction('Debut insertion mouvement ' + IntToStr(AMvt.iMvtId), 3);
  if (AMvt.iFouId <> 0) then
  begin
    LogAction('Debut get founisseur', 3);
    IBQue_GetFouById.Close;
    IBQue_GetFouById.ParamByName('FOUID').AsInteger := AMvt.iFouId;
    IBQue_GetFouById.Open;
    IF not IBQue_GetFouById.Eof then
    begin
      LogAction('Debut insertion founisseur', 3);
      IF IBQue_GetFouById.FieldByName('FOU_IDREF').AsInteger = 1 THEN
      BEGIN
        IBQue_GetFouIdRef.ParamByName('FOUID').AsInteger := AMvt.iFouId;
        IBQue_GetFouIdRef.Open;
        if NOT IBQue_GetFouIdRef.Eof then
        begin
          vFouIdRef := IBQue_GetFouIdRefFOU_IDREF.AsInteger;
        end
        else
        begin
          // Pas d'idref
          vFouIdRef := 0;
        end;
        IBQue_GetFouIdRef.Close;
      END
      else
      begin
        // Pas d'idref
        vFouIdRef := 0;
      end;

      Ps_Fournisseur.Parameters[1].Value := 0;                                                // @R_FOUID (output)
      Ps_Fournisseur.Parameters[2].Value := AMvt.iDosid;                                      // @P_DOSID int,
      Ps_Fournisseur.Parameters[3].Value := 0;                                                // @P_ARTIDORIGINE int,
      Ps_Fournisseur.Parameters[4].Value := vFouIdRef;                                        // @P_FOUIDREF int,
      Ps_Fournisseur.Parameters[5].Value := IBQue_GetFouById.FieldByName('FOU_NOM').AsString; // @P_FOUNOM VARCHAR

      Ps_Fournisseur.ExecProc;
      LogAction('Fin insertion founisseur', 3);
      try
        vFouIDDtb := Ps_Fournisseur.Parameters[1].Value;
      except
        vFouIDDtb := 0;
      end;
    end;
    IBQue_GetFouById.Close;
  end
  else
  begin
    vFouIDDtb := AMvt.iFouId;
  end;

  try
    //Ps_Mouvement.Close;
    Ps_Mouvement.Parameters[1].Value  := AMvt.iDosid;         // @P_DOSID int,
    Ps_Mouvement.Parameters[2].Value  := AMvt.iMagId;         // @P_MAGID int,
    Ps_Mouvement.Parameters[3].Value  := AMvt.iMvtId;         // @P_MVTIDORIGINE int,
    Ps_Mouvement.Parameters[4].Value  := AMvt.iTyp;           // @P_MVTTYPE tinyint,
    Ps_Mouvement.Parameters[5].Value  := AMvt.dtDateMvt;      // @P_MVTDATE datetime,
    Ps_Mouvement.Parameters[6].Value  := AMvt.iArtId;         // @P_ARTIDORIGINE int,
    Ps_Mouvement.Parameters[7].Value  := AMvt.sArtNom;        // @P_ARTNOM VARCHAR (64),
    Ps_Mouvement.Parameters[8].Value  := AMvt.sArtRefMrk;     // @P_ARTREFMRK VARCHAR (64),
    Ps_Mouvement.Parameters[9].Value  := AMvt.sMrkNom;        // @P_MRKNOM VARCHAR (64),
    Ps_Mouvement.Parameters[10].Value := AMvt.iMrkIdRef;      // @P_MRKIDREF int,
    Ps_Mouvement.Parameters[11].Value := AMvt.sArtFedas;      // @P_ARTFEDAS CHAR (6),
    Ps_Mouvement.Parameters[12].Value := AMvt.iArtPseudo;     // @P_ARTPSEUDO INT,
    Ps_Mouvement.Parameters[13].Value := AMvt.iGtfId;         // @P_GTFIDORIGINE INT,
    Ps_Mouvement.Parameters[14].Value := AMvt.sGtfNom;        // @P_GTFNOM VARCHAR (64),
    Ps_Mouvement.Parameters[15].Value := AMvt.sDateCree;      // @P_DATECREE VARCHAR(4),
    Ps_Mouvement.Parameters[16].Value := AMvt.iTgfId;         // @P_TGFIDORIGINE int,
    Ps_Mouvement.Parameters[17].Value := AMvt.sTgfNom;        // @P_TGFNOM VARCHAR(32),
    Ps_Mouvement.Parameters[18].Value := AMvt.iCouId;         // @P_COUIDORIGINE int,
    Ps_Mouvement.Parameters[19].Value := AMvt.sCouNom;        // @P_COUNOM VARCHAR(64),
    Ps_Mouvement.Parameters[20].Value := AMvt.sCouCode;       // @P_COUCODE VARCHAR(64),
    Ps_Mouvement.Parameters[21].Value := AMvt.iQte;           // @P_MVTQTE int,
    Ps_Mouvement.Parameters[22].Value := AMvt.iKEnabled;      // @K_ENABLED int

    Ps_Mouvement.Parameters[23].Value := AMvt.fPxBrutTTC;     // @P_MVTPXBRUT_TTC float,
    Ps_Mouvement.Parameters[24].Value := AMvt.fPxBrutHT;      // @P_MVTPXBRUT_HT float,
    Ps_Mouvement.Parameters[25].Value := AMvt.fPxNetTTC;      // @P_MVTPXNET_TTC float,
    Ps_Mouvement.Parameters[26].Value := AMvt.fPxNetHT;       // @P_MVTPXNET_HT float,
    Ps_Mouvement.Parameters[27].Value := AMvt.fPump;          // @P_MVTPUMP float,
    Ps_Mouvement.Parameters[28].Value := AMvt.fTva;           // @P_MVTTVA float,
    Ps_Mouvement.Parameters[29].Value := AMvt.iCodeTypeVente; // @P_MVTTYPVTE int,
    Ps_Mouvement.Parameters[30].Value := AMvt.sTypeVente;     // @P_MVTTYPVTELIB VARCHAR(32),

    Ps_Mouvement.Parameters[31].Value := AMvt.dtDateLivr;     // @P_MVTDTLIV datetime,
    Ps_Mouvement.Parameters[32].Value := AMvt.sCollection;    // @P_MVTCOLLEC varchar(32),
    Ps_Mouvement.Parameters[33].Value := vFouIDDtb;           // @P_MVTFOUNOM int,
    Ps_Mouvement.Parameters[34].Value := AMvt.fArtPump;       // Pump
    Ps_Mouvement.Parameters[35].Value := AMvt.iTkeId;         // Id Ticket dans DTB
    Ps_Mouvement.Parameters[36].Value := AMvt.dtModif;        // Date de modif

    Ps_Mouvement.ExecProc;

    LogAction('Fin insertion mouvement' + IntToStr(AMvt.iMvtId), 3);
    Result := True;
  except
    ON E: Exception DO
    begin
      LogAction('Erreur d''intégration dans SQLServeur', 1);
      LogAction(E.Message, 1);
      Result := False;
    end;
  end;
end;

procedure TDm_ExtractDatabase.SupprToutesProcedures;
begin
  {$IFNDEF DEBUG}
  SupprProcedure('SP2K_DTB_MVT_PLUS');
  SupprProcedure('SP2K_DTB_GETMVT_PLUS');
  SupprProcedure('SP2K_DTB_INITARTICLE_PLUS');
  SupprProcedure('SP2K_DTB_ARTGETCB_PLUS');
  SupprProcedure('SP2K_DTB_ARTICLEINFO_PLUS');

  //SupprIndex('IDX_CSHTKEDATE');
  //SupprIndex('IDX_CSHTKLARTID');
  //SupprIndex('IDX_CSHTKLSSTOTAL');
  {$ENDIF}
end;

procedure TDm_ExtractDatabase.MajToutesProcedures;
begin
  {$IFNDEF DEBUG}
  // Suppression des procédures si existantes
  SupprToutesProcedures;

  // Recréation (dans l'ordre inverse)
  CreerProcedure('SP2K_DTB_ARTICLEINFO_PLUS');
  CreerProcedure('SP2K_DTB_ARTGETCB_PLUS');
  CreerProcedure('SP2K_DTB_INITARTICLE_PLUS');
  CreerProcedure('SP2K_DTB_GETMVT_PLUS');
  CreerProcedure('SP2K_DTB_MVT_PLUS');

  //CreerIndex('IDX_CSHTKEDATE');
  //CreerIndex('IDX_CSHTKLARTID');
  //CreerIndex('IDX_CSHTKLSSTOTAL');
  {$ENDIF}
end;

procedure TDm_ExtractDatabase.SupprIndex(AIdxName: string);
begin
  // Désactiver des indexs si existants
  try
    IbT_Ginkoia.StartTransaction;
    IbSql_MajProc.SQL.Text := 'ALTER INDEX ' + AIdxName + ' INACTIVE';
    IbSql_MajProc.ExecQuery;
    IbT_Ginkoia.Commit;
  except
    on E: Exception do
    begin
      if Pos('Index ' + AIdxName + ' not found', E.Message) <= 0 then
      begin
        LogAction('Erreur désactivation : ' + AIdxName, 0);
        LogAction(E.Message, 4);
      end;
      IbT_Ginkoia.RollBack;
    end;
  end;
  // Suppression des indexs si existants
  try
    IbT_Ginkoia.StartTransaction;
    IbSql_MajProc.SQL.Text := 'DROP INDEX ' + AIdxName;
    IbSql_MajProc.ExecQuery;
    IbT_Ginkoia.Commit;
  except
    on E: Exception do
    begin
      if Pos('Index ' + AIdxName + ' not found', E.Message) <= 0 then
      begin
        LogAction('Erreur suppression : ' + AIdxName, 0);
        LogAction(E.Message, 4);
      end;
      IbT_Ginkoia.RollBack;
    end;
  end;
end;

procedure TDm_ExtractDatabase.SupprProcedure(AProcName: string);
begin
  // Suppression des procédures si existantes
  try
    IbT_Ginkoia.StartTransaction;
    IbSql_MajProc.SQL.Text := 'DROP PROCEDURE ' + AProcName;
    IbSql_MajProc.ExecQuery;
    IbT_Ginkoia.Commit;
  except
    on E: Exception do
    begin
      if Pos('Procedure ' + AProcName + ' not found', E.Message) <= 0 then
      begin
        LogAction('Erreur suppression : ' + AProcName, 0);
        LogAction(E.Message, 4);
      end;
      IbT_Ginkoia.RollBack;
    end;
  end;
end;

function TDm_ExtractDatabase.TraiteBase(AChemin, AMagAdh: string; ADosid, AMagId: integer; ADateInit, ADateDebut: TDateTime): boolean;
var
  iTypeMvt   : integer;     // Type de mouvement (de 1 à 11)
  iLastK     : integer;     // Contient le dernier K Traité
  iCurVersion: integer;     // Current version de la base.
  iKDeb      : integer;     // Dernier K traité au traitement précédent
  iNbMvt     : integer;     // Nombre de mouvments traités
  iNbEnr     : integer;     // Nombre d'enregistrement a traiter
  iPassage   : integer;     // Nombre de paquet de 9999 traité
  iNbInsert  : integer;     // Variable Transac

  stMvt         : stRecordMvt; // Structure pour stocker le mouvmeent en cours et l'insérer
  sDate         : string;      // Tampon pour mettre date sur 4 car
  dtDebutTrt    : TDateTime;   // Timestamp de début de traitement
  dtTraitement  : TDateTime;
  dtPlusMois    : TDateTime;

  bFinBoucle : boolean;     // Flag de sortie de boucle en cas d'erreur

  vCodeEAN   : variant;     // Tampon pour contacténer le dosid et le code barre.
  vTypeEAN   : variant;     // Tampon pour garder le type de code barre.
  vFouIdRef  : variant;     // tampon pour stocker l'id ref du fournisseur

  iTkeId     : integer;     // Id (Ginkoia) du ticket en cours
  iTkeIdDtb  : integer;     // Id du Ticket dans la DATABASE
begin
  Result := False;
  if AChemin = '' then
  begin
    ADODatabase.BeginTrans;
    try
      InsertHisto(0, AMagId, 0, 0, 0, 0, Now(), Now(), 'Chemin la base Ginkoia non paramétré');
    finally
      ADODatabase.CommitTrans;
    end;


    Exit;
  end;

  //AChemin := 'C:\Users\Bureau\Desktop\Bondoux.ib';
  //AChemin := 'C:\Users\Bureau\Desktop\Michel.ib';

  LogAction('Traitement base Ginkoia' + AChemin, 3);

  InitProgress('Connexion base Ginkoia' + AChemin, 1);

  LogAction('Connexion base Ginkoia' + AChemin, 3);
  Ginkoia.DatabaseName := AChemin;
  Ginkoia.Close;
  TRY
    Ginkoia.Open;
    DoProgress;
  EXCEPT
    // Chemin inccorect à voir si on log, ca peut être normal tant qu'on a pas renseigné le chemin
    LogAction(AMagAdh + ' : Connection Ginkoia échouée - ' + AChemin, 0);

    ADODatabase.BeginTrans;
    try
      InsertHisto(0, AMagId, 0, 0, 0, 0, Now(), Now(), 'Connection Ginkoia échouée - ' + AChemin);
    finally
      ADODatabase.CommitTrans;
    end;
  END;

  if Ginkoia.Connected then
  begin
    LogAction('Connexion base Ginkoia réussie', 1);

    InitProgress('Mise à jour des procédures', 1);
    Dm_ExtractDatabase.MajToutesProcedures;

    IbT_Ginkoia.StartTransaction;
    TRY
      // Récup la Version en cours de la base
      iCurVersion := GetCurVer;

      AdQue_KMax.Close;
      AdQue_KMax.Parameters[0].Value := AMagId;
      AdQue_KMax.Open;
      bFinBoucle                     := False;
      iTypeMvt                       := 1;
      while (NOT bFinBoucle) AND (iTypeMvt <= 11) do
      begin
        if iTypeMvt in [2,4,10] then
        begin
          //dtDebutTrt := Now;
          //iLastK     := 0;

          InitProgress('Traitement des mouvements de type ' + IntToStr(iTypeMvt), 0);

          //if not AdQue_KMax.Locate('mhi_typ', iTypeMvt, []) then
          //begin
            // Pas trouvé, on flag l'erreur + SORTIE DE BOUCLE, on ne traite pas les autres mouvements
            //InsertHisto(0, AMagId, 0, iLastK, iTypeMvt, 0, dtDebutTrt, Now(), 'KVersion max non trouvé');
            //bFinBoucle := True;
          //end
          //else
          //begin
            //iKDeb := AdQue_KMaxkmax.AsInteger;
            //if iKDeb <= 0 then
            //begin
              // Pas trouvé, on flag l'erreur + SORTIE DE BOUCLE, on ne traite pas les autres mouvements
              //InsertHisto(0, AMagId, 0, iLastK, iTypeMvt, 0, dtDebutTrt, Now(), 'KVersion max à 0');
              //bFinBoucle := True;
            //end
            //else
            //begin
          iNbEnr   := 0;
          iPassage := 0;
          iLastK   := iKDeb;
          iNbMvt   := 0;
          iNbInsert := 0;
              //repeat
          dtDebutTrt := Now;
          //Inc(iPassage);

          //dtTraitement := ADateDebut;
          //dtPlusMois := ADateDebut;
          //dtPlusMois := IncMonth(ADateInit,-5);

          //while FormatDateTime('YYYYMMDD', dtTraitement) <> FormatDateTime('YYYYMMDD', ADateInit) do
          //begin
            Inc(iPassage);

            // Trouvé, on envoie
            IBQue_GetMvt.Close;
            IBQue_GetMvt.ParamByName('MAGCODEADH').AsString      := AMagAdh;
            IBQue_GetMvt.ParamByName('LASTVERSION').AsInteger    := iLastK;
            IBQue_GetMvt.ParamByName('TYP').AsInteger            := iTypeMvt;
            IBQue_GetMvt.ParamByName('CURRENTVERSION').AsInteger := iCurVersion;
            IBQue_GetMvt.ParamByName('DTMAX').AsDateTime         := ADateInit; //dtPlusMois;
            IBQue_GetMvt.ParamByName('DTMIN').AsDateTime         := ADateDebut; //dtTraitement;
            IBQue_GetMvt.Open;

            IBQue_GetMvt.FetchAll;

            iNbEnr := IBQue_GetMvt.RecordCount;

            ADODatabase.BeginTrans;
            if iNbEnr > 0 then                         // S'il y'a des enregistrement, sinon c'est qu'on a fini
            begin
              if IBQue_GetMvtRETOUR.AsInteger = 1 then // Retour = 0 indique un pb de code adhérant
              begin
                InitProgress('Traitement des mouvements de type ' + IntToStr(iTypeMvt) + ' (' + IntToStr(iPassage) + ')', iNbEnr);

                iTkeId    := 0;
                iTkeIdDtb := 0;
                while (not bFinBoucle) and (not IBQue_GetMvt.Eof) do
                begin
                  sDate := FormatDateTime('yyyy', IBQue_GetMvt.FieldByName('ARFCREE').AsDateTime);

                  // Ticket
                  {$REGION 'Ticket'}
                  if (iTypeMvt = 2) then
                  begin
                    if (iTkeId <> IBQue_GetMvt.FieldByName('MOVIDENTETE').AsInteger) then
                    begin
                      LogAction('Deb Tke - mvtid=' + IntToStr(stMvt.iMvtId), 3);
                      iTkeId                        := IBQue_GetMvt.FieldByName('MOVIDENTETE').AsInteger;
                      Ps_Ticket.Parameters[1].Value := 0;
                      Ps_Ticket.Parameters[2].Value := AMagId;
                      Ps_Ticket.Parameters[3].Value := iTkeId;
                      Ps_Ticket.Parameters[4].Value := IBQue_GetMvt.FieldByName('TKEDATE').AsVariant;
                      Ps_Ticket.Parameters[5].Value := IBQue_GetMvt.FieldByName('TKEBRUT').AsVariant;
                      Ps_Ticket.Parameters[6].Value := IBQue_GetMvt.FieldByName('TKENET').AsVariant;
                      Ps_Ticket.Parameters[7].Value := IBQue_GetMvt.FieldByName('TKEBECOL').AsVariant;

                      Ps_Ticket.ExecProc;
                      LogAction('OK Tke - mvtid=' + IntToStr(stMvt.iMvtId) + ' - iTkeId=' + IntToStr(iTkeId), 3);

                      iTkeIdDtb                                   := Ps_Ticket.Parameters[1].Value;

                      IBQue_GetEnc.ParamByName('TKEID').AsInteger := iTkeId;
                      IBQue_GetEnc.Open;
                      while not IBQue_GetEnc.Eof do
                      begin
                        LogAction('Deb Enc - mvtid=' + IntToStr(IBQue_GetEnc.FieldByName('ENC_ID').AsInteger), 3);
                        Ps_Enc.Parameters[1].Value := iTkeIdDtb;
                        Ps_Enc.Parameters[2].Value := IBQue_GetEnc.FieldByName('ENC_ID').AsInteger;
                        Ps_Enc.Parameters[3].Value := IBQue_GetEnc.FieldByName('MEN_NOM').AsString;

                        if (IBQue_GetEnc.FieldByName('ENC_MONTANT').AsFloat = 0) and (IBQue_GetEnc.FieldByName('ENC_BA').AsFloat <> 0) then
                        begin
                          // Cas des pseudos remises
                          Ps_Enc.Parameters[4].Value := IBQue_GetEnc.FieldByName('ENC_BA').AsFloat;
                        end
                        else
                        begin
                          // Cas général
                          Ps_Enc.Parameters[4].Value := IBQue_GetEnc.FieldByName('ENC_MONTANT').AsFloat;
                        end;

                        Ps_Enc.Parameters[5].Value := IBQue_GetEnc.FieldByName('K_ENABLED').AsInteger;

                        Ps_Enc.ExecProc;
                        LogAction('OK Enc - mvtid=' + IntToStr(IBQue_GetEnc.FieldByName('ENC_ID').AsInteger), 3);

                        IBQue_GetEnc.Next;
                      end;
                      IBQue_GetEnc.Close;
                    end
                  end
                  else
                  begin
                    iTkeIdDtb := 0;
                  end;
                  {$ENDREGION}

                  LogAction('Deb Mvt - mvtid=' + IntToStr(stMvt.iMvtId), 3);

                  // Maj des infos mouvement dans la structure pour insertion mouvement
                  {$REGION 'Renseigne stMvt'}
                  stMvt                := InitRecordMvt;

                  stMvt.iDosid         := ADosid;                                             // @P_DOSID int,
                  stMvt.iMagId         := AMagId;                                             // @P_MAGID int,
                  stMvt.iMvtId         := IBQue_GetMvt.FieldByName('MOVIDORIGINE').AsInteger; // @P_MVTIDORIGINE int,
                  stMvt.iTyp           := iTypeMvt;                                           // @P_MVTTYPE tinyint,
                  stMvt.dtDateMvt      := IBQue_GetMvt.FieldByName('MOVDATE').AsDateTime;     // @P_MVTDATE datetime,
                  stMvt.iArtId         := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsInteger; // @P_ARTIDORIGINE int,
                  stMvt.sArtNom        := IBQue_GetMvt.FieldByName('ARTNOM').AsString;        // @P_ARTNOM VARCHAR (64),
                  stMvt.sArtRefMrk     := IBQue_GetMvt.FieldByName('ARTREFMRK').AsString;     // @P_ARTREFMRK VARCHAR (64),
                  stMvt.sMrkNom        := IBQue_GetMvt.FieldByName('MRKNOM').AsString;        // @P_MRKNOM VARCHAR (64),
                  stMvt.iMrkIdRef      := IBQue_GetMvt.FieldByName('MRKIDREF').AsVariant;     // @P_MRKIDREF int,
                  stMvt.sArtFedas      := IBQue_GetMvt.FieldByName('ARTFEDAS').AsString;      // @P_ARTFEDAS CHAR (6),
                  stMvt.iArtPseudo     := IBQue_GetMvt.FieldByName('ARFPSEUDO').AsInteger;    // @P_ARTPSEUDO INT,
                  stMvt.iGtfId         := IBQue_GetMvt.FieldByName('GTFID').AsInteger;        // @P_GTFIDORIGINE INT,
                  stMvt.sGtfNom        := IBQue_GetMvt.FieldByName('GTFNOM').AsString;        // @P_GTFNOM VARCHAR (64),
                  stMvt.sDateCree      := sDate;                                              // @P_DATECREE VARCHAR(4),
                  stMvt.iTgfId         := IBQue_GetMvt.FieldByName('TGFIDORIGINE').AsInteger; // @P_TGFIDORIGINE int,
                  stMvt.sTgfNom        := IBQue_GetMvt.FieldByName('TGFNOM').AsString;        // @P_TGFNOM VARCHAR(32),
                  stMvt.iCouId         := IBQue_GetMvt.FieldByName('COUIDORIGINE').AsInteger; // @P_COUIDORIGINE int,
                  stMvt.sCouNom        := IBQue_GetMvt.FieldByName('COUNOM').AsString;        // @P_COUNOM VARCHAR(64),
                  stMvt.sCouCode       := IBQue_GetMvt.FieldByName('COUCODE').AsString;       // @P_COUCODE VARCHAR(64),
                  stMvt.iQte           := IBQue_GetMvt.FieldByName('MOVQTE').AsInteger;       // @P_MVTQTE int,
                  stMvt.iKEnabled      := IBQue_GetMvt.FieldByName('MOVKENABLED').AsInteger;  // @K_ENABLED int
                  stMvt.dtDateLivr     := IBQue_GetMvt.FieldByName('MOVDTLIV').AsDateTime;
                  stMvt.fPxBrutTTC     := IBQue_GetMvt.FieldByName('MOVPXBRUTTTC').AsFloat;
                  stMvt.fPxBrutHT      := IBQue_GetMvt.FieldByName('MOVPXBRUTHT').AsFloat;
                  stMvt.fPxNetTTC      := IBQue_GetMvt.FieldByName('MOVPXNETTTC').AsFloat;
                  stMvt.fPxNetHT       := IBQue_GetMvt.FieldByName('MOVPXNETHT').AsFloat;
                  stMvt.fPump          := IBQue_GetMvt.FieldByName('MOVPUMP').AsFloat;
                  stMvt.fTva           := IBQue_GetMvt.FieldByName('MOVTVA').AsFloat;
                  stMvt.iCodeTypeVente := IBQue_GetMvt.FieldByName('MOVTYPEVTE').AsInteger;
                  stMvt.sTypeVente     := IBQue_GetMvt.FieldByName('MOVTYPEVTELIB').AsString;
                  stMvt.iFouId         := IBQue_GetMvt.FieldByName('FOUIDORIGINE').AsInteger;
                  stMvt.sCollection    := IBQue_GetMvt.FieldByName('MOVCOLLEC').AsString;
                  stMvt.fArtPump       := IBQue_GetMvt.FieldByName('ARTPUMP').AsFloat;
                  stMvt.iTkeId         := iTkeIdDtb;
                  stMvt.dtModif        := IBQue_GetMvt.FieldByName('MOVKUPDATED').AsFloat;

                  {$ENDREGION}

                  if InsertMvt(stMvt) then
                  begin
                    LogAction('OK Mvt - mvtid=' + IntToStr(stMvt.iMvtId), 3);
                    // Vérif CB
                    {$REGION 'Vérif CB'}
                    IBQue_GetCB.ParamByName('ARFID').AsInteger := IBQue_GetMvt.FieldByName('ARFID').AsInteger;
                    IBQue_GetCB.ParamByName('COUID').AsInteger := IBQue_GetMvt.FieldByName('COUIDORIGINE').AsInteger;
                    IBQue_GetCB.ParamByName('TGFID').AsInteger := IBQue_GetMvt.FieldByName('TGFIDORIGINE').AsInteger;
                    IBQue_GetCB.Open;
                    LogAction('Ok Que CB' + IntToStr(IBQue_GetCB.RecordCount), 3);

                    repeat
                      if IBQue_GetCB.Eof then // demande client, pseudo sans CB  -> Artid_dossier
                      begin
                        LogAction('Ok Que EOF' + IntToStr(IBQue_GetCB.RecordCount), 3);
                        vCodeEAN := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsString + '_' + IntToStr(ADosid);
                        vTypeEAN := 3;
                      end
                      else
                      begin
                        LogAction('Ok Que PAS EOF' + IntToStr(IBQue_GetCB.RecordCount), 3);
                        vTypeEAN := IBQue_GetCB.FieldByName('TYPECB').AsVariant;
                        if IBQue_GetCB.FieldByName('TYPECB').AsInteger = 3 then
                        begin
                          LogAction('Ok Que 1' + IntToStr(IBQue_GetCB.RecordCount), 3);
                          vCodeEAN := IBQue_GetCB.FieldByName('CBICB').AsVariant + '_' + IntToStr(ADosid);
                        end
                        else
                        begin
                          LogAction('Ok Que 2' + IntToStr(IBQue_GetCB.RecordCount), 3);
                          vCodeEAN := IBQue_GetCB.FieldByName('CBICB').AsVariant
                        end;
                      end;

                      LogAction('Deb CB - ' + vCodeEAN, 3);
                      Ps_CbArt.Parameters[1].Value  := vCodeEAN;                                           // P_CBIEAN VARCHAR(20),
                      Ps_CbArt.Parameters[2].Value  := 0;                                                  // P_ARTID int,
                      Ps_CbArt.Parameters[3].Value  := IBQue_GetMvt.FieldByName('COUIDORIGINE').AsVariant; // P_COUIDORIGINE int,
                      Ps_CbArt.Parameters[4].Value  := IBQue_GetMvt.FieldByName('COUNOM').AsVariant;       // P_COUNOM VARCHAR(64),
                      Ps_CbArt.Parameters[5].Value  := IBQue_GetMvt.FieldByName('COUCODE').AsVariant;      // P_COUCODE VARCHAR(64),
                      Ps_CbArt.Parameters[6].Value  := IBQue_GetMvt.FieldByName('TGFIDORIGINE').AsVariant; // P_TGFIDORIGINE int,
                      Ps_CbArt.Parameters[7].Value  := IBQue_GetMvt.FieldByName('TGFNOM').AsVariant;       // P_TGFNOM VARCHAR(32),
                      Ps_CbArt.Parameters[8].Value  := 0;                                                  // P_GTFID int,
                      Ps_CbArt.Parameters[9].Value  := vTypeEAN;                                           // P_TYPE int
                      Ps_CbArt.Parameters[10].Value := ADosid;                                             // Dans ce cas utile pour récup GTFID et ARTID
                      Ps_CbArt.Parameters[11].Value := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsInteger; // pour récup ARTID
                      Ps_CbArt.Parameters[12].Value := IBQue_GetMvt.FieldByName('GTFID').AsInteger;        // Pour récup grille de taille
                      Ps_CbArt.Parameters[13].Value := IBQue_GetMvt.FieldByName('GTFNOM').AsString;        // Idem

                      Ps_CbArt.ExecProc;
                      LogAction('OK CB - ' + vCodeEAN, 3);

                      IBQue_GetCB.Next;
                    until (IBQue_GetCB.Eof);

                    IBQue_GetCB.Close;

                    {$ENDREGION}

                    // Fournisseurs
                    {$REGION 'Fournisseurs'}
                    IBQue_GetFourn.Close;
                    IBQue_GetFourn.ParamByName('ARTID').AsInteger := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsInteger;
                    IBQue_GetFourn.Open;
                    IBQue_GetFourn.First;
                    LogAction('Ok Que fou' + IntToStr(IBQue_GetFourn.RecordCount), 3);
                    while not IBQue_GetFourn.Eof do
                    begin
                      IF IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger = 1 THEN
                      BEGIN
                        IBQue_GetFouIdRef.ParamByName('FOUID').AsInteger := IBQue_GetFourn.FieldByName('FOU_ID').AsInteger;
                        IBQue_GetFouIdRef.Open;
                        if NOT IBQue_GetFouIdRef.Eof then
                        begin
                          vFouIdRef := IBQue_GetFouIdRefFOU_IDREF.AsInteger;
                        end
                        else
                        begin
                          // Pas d'idref
                          vFouIdRef := 0;
                        end;

                        IBQue_GetFouIdRef.Close;
                      END
                      else
                      begin
                        // Pas d'idref
                        vFouIdRef := 0;
                      end;

                      LogAction('Deb Fou mvtid=' + IntToStr(IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger), 3);
                      Ps_Fournisseur.Parameters[1].Value := 0;                                                  // @R_FOUID (output)
                      Ps_Fournisseur.Parameters[2].Value := ADosid;                                             // @P_DOSID int,
                      Ps_Fournisseur.Parameters[3].Value := IBQue_GetMvt.FieldByName('ARTIDORIGINE').AsInteger; // @P_ARTIDORIGINE int,
                      Ps_Fournisseur.Parameters[4].Value := vFouIdRef;                                          // @P_FOUIDREF int,
                      Ps_Fournisseur.Parameters[5].Value := IBQue_GetFourn.FieldByName('FOU_NOM').AsString;     // @P_FOUNOM int

                      Ps_Fournisseur.ExecProc;
                      LogAction('OK Fou - mvtid=' + IntToStr(IBQue_GetFourn.FieldByName('FOU_IDREF').AsInteger), 3);

                      IBQue_GetFourn.Next;
                    end;
                    IBQue_GetFourn.Close;
                    {$ENDREGION}

                    Inc(iNbMvt);

                    //iLastK := IBQue_GetMvt.FieldByName('MOVKVERSION').AsInteger;

                    DoProgress;

                    IBQue_GetMvt.Next;

                    inc(iNbInsert);
                    if iNbInsert = 1000 then
                    begin
                      LogAction('CommitTrans', 3);
                      ADODatabase.CommitTrans;
                      ADODatabase.BeginTrans;
                      iNbInsert := 0;
                    end;
                  end
                  else
                  begin
                    bFinBoucle := True;
                  end;
                end; // End While IBQue_GetMvt

                //if not bFinBoucle then
                //begin
                //  InsertHisto(1, AMagId, iKDeb, iLastK, iTypeMvt, iNbMvt, dtDebutTrt, Now(), 'OK');
                //end
                //else
                //begin
                //  InsertHisto(0, AMagId, iKDeb, iLastK, iTypeMvt, iNbMvt, dtDebutTrt, Now(), 'Erreur d''intrégration');
                //end;
              end
              else
              begin // Retour = 0
                InsertHisto(0, AMagId, iKDeb, iLastK, iTypeMvt, iNbMvt, dtDebutTrt, Now(), 'Code adhérent non renseigné');
                iNbEnr := 0;
              end; // End IF Retour = 1
            end   // End if iNbEnr > 0
            else
            begin
              if iPassage = 1 then // Premier passage et rien dans le dataset = paquet vide, on note le lastk
              begin
                InsertHisto(1, AMagId, iKDeb, iCurVersion, iTypeMvt, 0, dtDebutTrt, Now(), 'OK');
              end;
            end;
            ADODatabase.CommitTrans;
            IBQue_GetMvt.Close;

            //dtPlusMois := IncMonth(dtPlusMois,1);
            //dtTraitement := IncMonth(dtTraitement,1);
          //end;
              //until iNbEnr = 0; // End while paquet de 9999
            //end;                // End If
          //end;                  // End If
        end;
        // Next type
        Inc(iTypeMvt);
      end; // End While typemvt
    EXCEPT
      ON E: Exception DO
      begin
        if ADODatabase.InTransaction Then
        begin
          ADODatabase.RollbackTrans;
        end;

        LogAction('Erreur d''intégration dans SQLServeur', 1);
        LogAction(E.Message, 1);
        LogAction(IntToStr(stMvt.iMvtId) + ' - ' + IntToStr(iLastK) + ' - ' + IntToStr(iTypeMvt), 3);

        InsertHisto(0, AMagId, iKDeb, iLastK, iTypeMvt, iNbMvt, dtDebutTrt, Now(), 'Erreur d''intégration dans SQLServeur');
      end;
    END;
    IbT_Ginkoia.Commit;
    IBQue_InitDtb.Close;
    Dm_ExtractDatabase.SupprToutesProcedures;
    Ginkoia.Close;
  end;

  //Pour indiquer que le traitement est réalisé.
  AdQue_MajMagTraite.Parameters.ParamValues['MAGID'] := AMagId;
  AdQue_MajMagTraite.ExecSQL;

  LogAction('Fin traitement' + AChemin, 3);
end;

procedure TDm_ExtractDatabase.ADODatabaseAfterConnect(Sender: TObject);
begin
  // Info connexion
  Lab_ConnexionStateDtb.Caption := 'DATABASE - Connecté à : ' + FURLSrv;
  Application.ProcessMessages;
end;

procedure TDm_ExtractDatabase.ADODatabaseAfterDisconnect(Sender: TObject);
begin
  // Info connexion
  Lab_ConnexionStateDtb.Caption := 'DATABASE - Déconnecté';
  Application.ProcessMessages;
end;

procedure TDm_ExtractDatabase.CloseProgress();
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

procedure TDm_ExtractDatabase.CreerIndex(AIdxName: string);
var
  sPathFile: string; // Chemin vers le fichier à charger
begin
  // Les indexs à mettre à jour doivent se trouver dans le dossier de l'exe
  // nommées NomDeL'Index.sql
  sPathFile := ExtractFilePath(Application.ExeName) + AIdxName + '.sql';

  try
    IbT_Ginkoia.StartTransaction;
    IbSql_MajProc.SQL.LoadFromFile(sPathFile);
    IbSql_MajProc.ExecQuery();
    IbT_Ginkoia.Commit;
  except
    on E: Exception do
    begin
      LogAction('Création l''index impossible : ' + sPathFile, 0);
      LogAction(E.Message, 4);
      // Exception notée en info de débug
      IbT_Ginkoia.RollBack;
    end;
  end;
end;

procedure TDm_ExtractDatabase.CreerProcedure(AProcName: string);
var
  sPathFile: string; // Chemin vers le fichier à charger
begin
  // Les procédures à mettre à jour doivent se trouver dans le dossier de l'exe
  // nommées NomDeLaProc.sql
  sPathFile := ExtractFilePath(Application.ExeName) + AProcName + '.sql';

  try
    IbT_Ginkoia.StartTransaction;
    IbSql_MajProc.SQL.LoadFromFile(sPathFile);
    IbSql_MajProc.ExecQuery();
    IbT_Ginkoia.Commit;
  except
    on E: Exception do
    begin
      LogAction('Création procédure impossible : ' + sPathFile, 0);
      LogAction(E.Message, 4);
      // Exception notée en info de débug
      IbT_Ginkoia.RollBack;
    end;
  end;
end;

end.
