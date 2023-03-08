UNIT UTraitements;

INTERFACE

USES
  SysUtils,
  Classes,
  DB,
  //début uses
  Forms,
  contnrs,
  windows,
  dialogs,
  dateUtils,
  IdAttachmentFile,
  idText,
  adoInt,
  VCLZip,
  //fin uses
  dxmdaset,
  ExtCtrls,
  ADODB,
  IdMessage,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdExplicitTLSClientServerBase,
  IdMessageClient,
  IdSMTPBase,
  IdSMTP,
  LMDCustomComponent,
  LMDFileGrep;
CONST
  PREFIX_FICHIER = 'Analyses_';

 // Varaible globale
var
  UserName : String = 'DA_GINKOIA';
  PassWord : String = 'ch@mon1x';
  Server : String = 'sp2kcat.no-ip.org';

  MailDest,
  MailHost,
  MailUSer,
  MailPass : String;
  MailPort : Integer;

  LienHttp : String;


TYPE
  TDemandeAnalyse = RECORD
    dateDemande: STRING;
    nom: STRING;
    prenom: STRING;
    utilisateur: STRING;
    collection: STRING;
    marque: STRING;
    categorie: STRING;
    dossier: STRING;
    nomFichier: STRING;
    lien: STRING;
    resultat: STRING;
    email: wideString;
    dateTraitement: STRING;
    Id_envoie: integer;
    id_utilisateur: Integer;
    col_id: Integer;
    cat_id: Integer;
    mrk_id: Integer;
    dos_id: Integer;
    detail: Integer;
    Format: Integer;
    reg_id: Integer;
    detail_coul: Integer;
    uni_id: Integer;
    uti_id: Integer;
    etat: Integer;
    ext: STRING;
  END;

TYPE
  TThread_Traitement = CLASS(TTHREAD) //thread de récupèration des demandes
  CONST
    { Connection string }
    ConnString =
      'Provider=SQLOLEDB.1;Persist Security Info=False;' +
      'User ID=%s;Password=%s;Data Source=%s;Use Procedure for Prepare=1;' +
      'Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;' +
      'Tag with column collation when possible=False';
    { User access }
    strSqlMajEtat = 'update envoie_analyse set etat = :etat where id_envoie = :idEnvoi;';
    strSqlTermine = 'update envoie_analyse set termine = :termine , etat = :etat where id_envoie = :idEnvoi;';
    PRIVATE
      { Déclarations privées }
    uneDemande: TDemandeAnalyse;
    Que_majEtat: TADOQuery;
    Que_termine: TADOQuery;
    StProc_Analyse: TADOStoredProc;
    ADOConn: TADOConnection;
    MemD_ResultatAnalyses: TdxMemData;
    PROTECTED
      { Déclarations publiques }
CONSTRUCTOR Create(ADemande: TDemandeAnalyse);
DESTRUCTOR Destroy; OVERRIDE;
PROCEDURE Execute; OVERRIDE;
PROCEDURE AdoQueryToCsv(AQuery: TAdoStoredProc; ColDelemiter, RowDelemiter, Filename: STRING);
PROCEDURE TestCsvFileStream(AQuery: TAdoStoredProc; Path: STRING);
  END;

TYPE
  TDm_Traitements = CLASS(TDataModule)
    MemD_Traitees: TdxMemData;
    MemD_EnAttente: TdxMemData;
    ADOConnectionCATMAN: TADOConnection;
    ADOQue_Envois: TADOQuery;
    ADOQue_Envoisid_envoie: TIntegerField;
    ADOQue_Envoisid_utilisateur: TIntegerField;
    ADOQue_Envoisdatecreation: TDateTimeField;
    ADOQue_Envoisresultat_global: TBooleanField;
    ADOQue_Envoisresultat_detaille: TBooleanField;
    ADOQue_Envoiscol_id: TIntegerField;
    ADOQue_Envoiscat_id: TIntegerField;
    ADOQue_Envoismrk_id: TIntegerField;
    ADOQue_Envoisdos_id: TIntegerField;
    ADOQue_Envoisdetail: TIntegerField;
    ADOQue_Envoistermine: TBooleanField;
    ADOQue_Envoisemail: TWideStringField;
    ADOQue_Envoisreg_id: TIntegerField;
    ADOQue_Envoisdetail_coul: TIntegerField;
    ADOQue_Envoisetat: TIntegerField;
    ADOQue_Envoisdate_traitement: TDateTimeField;
    ADOQue_Envoisuni_id: TIntegerField;
    ADOQue_EnvoisFormat: TIntegerField;
    MemD_EnAttenteid_envoie: TIntegerField;
    MemD_EnAttentedatecreation: TDateTimeField;
    MemD_EnAttentedos_id: TIntegerField;
    MemD_EnAttentedetail: TIntegerField;
    MemD_EnAttentetermine: TBooleanField;
    MemD_EnAttenteemail: TWideStringField;
    MemD_EnAttentereg_id: TIntegerField;
    MemD_EnAttentedetail_coul: TIntegerField;
    MemD_EnAttenteetat: TIntegerField;
    MemD_EnAttentedate_traitement: TDateTimeField;
    MemD_EnAttenteuni_id: TIntegerField;
    MemD_EnAttenteFormat: TIntegerField;
    MemD_EnCours: TdxMemData;
    MemD_EnCoursid_envoie: TIntegerField;
    MemD_EnCoursdatecreation: TDateTimeField;
    MemD_EnCoursemail: TWideStringField;
    MemD_EnCoursdate_traitement: TDateTimeField;
    ADOQue_MajEnvoi: TADOQuery;
    ADOStProc_VISU_TBARTICLE_LARS: TADOStoredProc;
    ADOQue_MajEtat: TADOQuery;
    MemD_Traiteesid_envoie: TIntegerField;
    MemD_Traiteesdate_traitement: TDateTimeField;
    MemD_Traiteesemail: TWideStringField;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    ADOQue_EnvoisCOL_NOM: TStringField;
    ADOQue_EnvoisMRK_NOM: TStringField;
    ADOQue_EnvoisCAT_NOM: TStringField;
    ADOQue_EnvoisDOS_NOM: TStringField;
    ADOQue_EnvoisUTI_NOM: TStringField;
    ADOQue_EnvoisUTI_PRENOM: TStringField;
    MemD_EnAttenteCOL_NOM: TStringField;
    MemD_EnAttenteMRK_NOM: TStringField;
    MemD_EnAttenteCAT_NOM: TStringField;
    MemD_EnAttenteDOS_NOM: TStringField;
    MemD_EnAttenteUTI_NOM: TStringField;
    MemD_EnCoursUTI_NOM: TStringField;
    MemD_EnCoursUTI_PRENOM: TStringField;
    MemD_EnAttenteUTI_PRENOM: TStringField;
    ADOQue_EchecEnvois: TADOQuery;
    ADOQue_EchecEnvoisid_envoie: TIntegerField;
    ADOQue_EchecEnvoisid_utilisateur: TIntegerField;
    ADOQue_EchecEnvoisdatecreation: TDateTimeField;
    ADOQue_EchecEnvoisresultat_global: TBooleanField;
    ADOQue_EchecEnvoisresultat_detaille: TBooleanField;
    ADOQue_EchecEnvoiscol_id: TIntegerField;
    ADOQue_EchecEnvoiscat_id: TIntegerField;
    ADOQue_EchecEnvoismrk_id: TIntegerField;
    ADOQue_EchecEnvoisdos_id: TIntegerField;
    ADOQue_EchecEnvoisdetail: TIntegerField;
    ADOQue_EchecEnvoistermine: TBooleanField;
    ADOQue_EchecEnvoisemail: TWideStringField;
    ADOQue_EchecEnvoisreg_id: TIntegerField;
    ADOQue_EchecEnvoisdetail_coul: TIntegerField;
    ADOQue_EchecEnvoisetat: TIntegerField;
    ADOQue_EchecEnvoisdate_traitement: TDateTimeField;
    ADOQue_EchecEnvoisuni_id: TIntegerField;
    ADOQue_EchecEnvoisFormat: TIntegerField;
    ADOQue_EchecEnvoisCOL_NOM: TStringField;
    ADOQue_EchecEnvoisMRK_NOM: TStringField;
    ADOQue_EchecEnvoisCAT_NOM: TStringField;
    ADOQue_EchecEnvoisDOS_NOM: TStringField;
    ADOQue_EchecEnvoisUTI_NOM: TStringField;
    ADOQue_EchecEnvoisUTI_PRENOM: TStringField;
    MemD_EnAttenteid_utilisateur: TIntegerField;
    MemD_EnAttentecat_id: TIntegerField;
    MemD_EnAttentemrk_id: TIntegerField;
    MemD_EnAttentecol_id: TIntegerField;
    MemD_Traiteesdatecreation: TDateTimeField;
    MemD_TraiteesUTI_NOM: TStringField;
    MemD_TraiteesUTI_PRENOM: TStringField;
    MemD_EnAttenteresultat_global: TBooleanField;
    MemD_EnAttenteresultat_detaille: TBooleanField;
    MemD_TraiteesBis: TdxMemData;
    IntegerField13: TIntegerField;
    DateTimeField3: TDateTimeField;
    WideStringField2: TWideStringField;
    DateTimeField4: TDateTimeField;
    StringField1: TStringField;
    StringField2: TStringField;
    MemD_Resultat: TdxMemData;
    GrepZip: TLMDFileGrep;
    MemD_Traiteesetat: TIntegerField;
    MemD_TraiteesBisetat: TIntegerField;
    PROCEDURE DataModuleCreate(Sender: TObject);
    PROCEDURE DataModuleDestroy(Sender: TObject);
    PROCEDURE MemD_EnCoursAfterDelete(DataSet: TDataSet);
    PROCEDURE MemD_EnAttenteAfterPost(DataSet: TDataSet);
  PRIVATE
    { Déclarations privées }
    objThreadListe: TObjectList;
    dtDernierNettoyageZip: TDateTime;
    //lstDemandes : Tlis
    PROCEDURE initSmtp(idSmtp: TidSmtp);
    PROCEDURE nettoyerDossierZip;
  PUBLIC
    { Déclarations publiques }
    bSurveillerDureeTraitement: boolean;
    LockFileAttente: _RTL_CRITICAL_SECTION; //section critique de la file d'attente
    bCreationFileEnCours: Boolean; //flag de gestion de la sauvegarde du résultat
    sCheminCopy: STRING; //chemin vers le dossier sur BackUp qui va recevoir l'analyse
    wsListeEmailIncidents: WideString; //chaine d'addresse à notifier en cas d'incidents
    iMaxNbTraitements: integer; //le nombre max de traitements simultanés
    bfileTraitementOuverte: boolean; //controle l'ajout de traitements dans la file de traitement : passer à false pour demander l'arrêt de l'ajout de traitement en vue de l'arrêt de l'application
    iDureeMaxAnalyse: Integer; //nombre max de minutes accordées au traitement avant de considèrer qu'il y a une anomalie
    iFrequenceCtrlAnalyse: Integer; //fréquence du controle de durée max des analyses
    bDebug: Boolean; //signale que le mode débugage est actif ou non
    iDureeConservation: Integer; //nb de jour pendant lesquels on conserve les zip des demandes
    iFrequenceConsultationBase: integer; //fréquence d'interrogation de la base sur les nouveaux envois à réaliser
    FUNCTION creerEtEnvoiEmail(ADemande: TDemandeAnalyse; mode: Integer): boolean;
    PROCEDURE signalerIncident(msg: STRING);
    PROCEDURE nettoyerListeThread();
    PROCEDURE executerTraitement();

  END;
PROCEDURE controlerTraitementsEncours(); stdcall;
VAR
  Dm_Traitements: TDm_Traitements;

IMPLEMENTATION

{$R *.dfm}

PROCEDURE TDm_Traitements.DataModuleCreate(Sender: TObject);
BEGIN
  TRY
    //initialiser les sections critiques pour synchroniser l'accès aux données
    InitializeCriticalSection(LockFileAttente);
    //ouvrir toutes les requetes
    MemD_EnCours.open;
    MemD_Traitees.open;
    MemD_EnAttente.Open;
    MemD_TraiteesBis.open; //clone des envois traités : sert à l'affiche uniquement en recopiant MemD_Traitees
    //    //ouvrir la connection
    //    ADOConnectionCATMAN.Connected := true;
    //    ADOQue_Envois.open;
    //flag autorisant la sauvegarde du résultat
    bCreationFileEnCours := false;
    //créer la liste de thread
    objThreadListe := TOBJECTLIST.Create;
    objThreadListe.OwnsObjects := true;
    //initialiser la date du dernier nettoyage du dossier des zip
    dtDernierNettoyageZip := now;
  EXCEPT ON Stan: Exception DO
    BEGIN
      //signaler pb
      signalerIncident('Etape : Création dm_Traitement, Erreur : ' + Stan.Message);
      MemD_EnCours.Close;
      MemD_Traitees.Close;
      MemD_EnAttente.Close;
      MemD_TraiteesBis.open;
      ADOQue_Envois.Close;
      ADOConnectionCATMAN.Connected := false;
    END;
  END;
END;

PROCEDURE TDm_Traitements.DataModuleDestroy(Sender: TObject);
BEGIN
  TRY
    DeleteCriticalSection(LockFileAttente);
    MemD_EnCours.Close;
    MemD_Traitees.Close;
    MemD_EnAttente.Close;
    MemD_TraiteesBis.Close;
  FINALLY
    IF (ADOConnectionCATMAN.Connected) THEN
      ADOConnectionCATMAN.Connected := false;
    objThreadListe.free;
  END;
END;

PROCEDURE TDm_Traitements.executerTraitement;
VAR
  thread_Traitement: TThread_Traitement;
  maintenant: TDateTime;
  demande: TDemandeAnalyse;
  sExt: STRING;
BEGIN
  TRY
    //EnterCriticalSection(LockFileAttente);
    //nettoyer la liste des threads : retirer ceux qui sont terminés
    //nettoyerListeThread;
    //si le nombre max de demandes n'est pas atteint, que la file d'attente est ouverte et pas vide créer un nouveau thread pour executer une nouvelle demande
    IF (MemD_EnCours.RecordCount < iMaxNbTraitements) AND (MemD_EnAttente.recordCount > 0) AND bfileTraitementOuverte THEN
    BEGIN
      TRY
        MemD_EnCours.DisableControls;
        MemD_EnAttente.DisableControls;
        maintenant := now;
        //se placer sur le premier de la liste
        MemD_EnAttente.first;
        WITH demande DO
        BEGIN
          dateDemande := MemD_EnAttentedatecreation.AsString;
          collection := MemD_EnAttenteCOL_NOM.asString;
          marque := MemD_EnAttenteMRK_NOM.asString;
          categorie := MemD_EnAttenteCAT_NOM.asstring;
          dossier := MemD_EnAttenteDOS_NOM.asString;
          nom := MemD_EnAttenteUTI_NOM.AsString;
          prenom := MemD_EnAttenteUTI_PRENOM.asString;
          utilisateur := MemD_EnAttenteUTI_NOM.AsString + ' ' + MemD_EnAttenteUTI_PRENOM.asString;
          IF (MemD_EnAttenteresultat_global.asBoolean = true) THEN
            resultat := 'Résultat réseau'
          ELSE
            resultat := 'Résultat dossier';
          email := MemD_EnAttenteemail.AsWideString;
          Id_envoie := MemD_EnAttenteid_envoie.asInteger;
          id_utilisateur := MemD_EnAttenteid_utilisateur.asInteger;
          col_id := MemD_EnAttentecol_id.asInteger;
          cat_id := MemD_EnAttentecat_id.asInteger;
          mrk_id := MemD_EnAttentemrk_id.asInteger;
          dos_id := MemD_EnAttentedos_id.asInteger;
          detail := MemD_EnAttentedetail.asInteger;
          Format := MemD_EnAttenteFormat.asInteger;
          reg_id := MemD_EnAttentereg_id.asInteger;
          detail_coul := MemD_EnAttentedetail_coul.asInteger;
          uni_id := MemD_EnAttenteuni_id.asInteger;
          uti_id := MemD_EnAttenteid_utilisateur.asInteger;
          dateTraitement := DatetimeToStr(maintenant);
          etat := 1;
          //remplir l'enregistrement pour les infos contenues dans l'e-mail si echec
          CASE MemD_EnAttenteFormat.AsInteger OF
            1: ext := '.txt';
            2: ext := '.csv';
            3: ext := '.xls';
          END;
        END;
        // modifier la valeur de la colonne Etat = 1 et la date de traitement = now
        ADOQue_MajEnvoi.Close;
        ADOQue_MajEnvoi.Parameters.ParamByName('etat').Value := 1;
        ADOQue_MajEnvoi.Parameters.ParamByName('dateTraitement').Value := maintenant;
        ADOQue_MajEnvoi.Parameters.ParamByName('idEnvoi').Value := MemD_EnAttenteid_envoie.asInteger;
        ADOQue_MajEnvoi.ExecSQL;
        //renseigner la liste des traitements démarrés
        MemD_EnCours.Append();
        MemD_EnCoursId_envoie.asinteger := MemD_EnAttenteid_envoie.asInteger;
        MemD_EnCoursdatecreation.AsDateTime := MemD_EnAttentedatecreation.asDateTime;
        MemD_EnCoursemail.AsWideString := MemD_EnAttenteemail.asWideString;
        MemD_EnCoursdate_traitement.AsDateTime := maintenant;
        MemD_EnCoursUTI_NOM.AsString := MemD_EnAttenteUTI_NOM.AsString;
        MemD_EnCoursUTI_PRENOM.asString := MemD_EnAttenteUTI_PRENOM.asString;
        MemD_EnCours.post;
        // mettre à jour la liste des traitements en attente
        MemD_EnAttente.Delete;
        thread_Traitement := TThread_Traitement.create(demande);
        //ajouter dans la liste des threads
        objThreadListe.Add(thread_Traitement);
      EXCEPT ON Stan: Exception DO
        BEGIN
          signalerIncident('Etape : Création du traitement d''une demande, Erreur : ' + Stan.Message);
          creerEtEnvoiEmail(demande, 0);
        END;
      END;
      ADOQue_MajEnvoi.close;
    END;
  FINALLY
    MemD_EnCours.EnableControls;
    //LeaveCriticalSection(LockFileAttente);
  END;
END;

PROCEDURE TDm_Traitements.initSmtp(idSmtp: TidSmtp);
BEGIN
  WITH IdSMTP DO
  BEGIN
    Host := MailHost; // 'smtp.fr.oleane.com';
    //paramétrage de test
    Port := MailPort; // 25;
    //IdSMTP.Port := 587;
    AuthType := atDefault;
    Username := MailUSer; // 'catman@algodefi.fr.fto';
    Password := MailPass; // 'HAkDjKZS';
  END;
END;

PROCEDURE TDm_Traitements.MemD_EnAttenteAfterPost(DataSet: TDataSet);
BEGIN
  //  executerTraitement();
END;

PROCEDURE TDm_Traitements.MemD_EnCoursAfterDelete(DataSet: TDataSet);
BEGIN
  //  executerTraitement();
END;

PROCEDURE TDm_Traitements.nettoyerListeThread;
VAR
  i: integer;
BEGIN
  TRY
    //EnterCriticalSection(LockFileAttente);
    //parcourir la liste et retirer les thread terminés
    FOR I := objThreadListe.Count - 1 DOWNTO 0 DO
    BEGIN
      IF TThread_Traitement(objThreadListe.Items[i]).Terminated THEN
      BEGIN
        MemD_Traitees.DisableControls;
        //signaler les demandes non satisfaites
//        IF bDebug THEN
//        BEGIN
        IF (TThread_Traitement(objThreadListe.Items[i]).uneDemande.etat = 4) THEN
          signalerIncident('Demande d''envoi : ' + intToStr(TThread_Traitement(objThreadListe.Items[i]).uneDemande.Id_envoie) + ' non satisfaite.');
        //        END;
                //enlever l'objet des traitements encours
        IF MemD_EnCours.Locate('id_envoie', TThread_Traitement(objThreadListe.Items[i]).uneDemande.Id_envoie, []) THEN
          MemD_Encours.Delete;
        MemD_Traitees.First;
        //si l'historique est déja trop gros, vider
        IF (DaysBetween(now, MemD_Traiteesdate_traitement.AsDateTime) > 1) AND (MemD_Traitees.recordCount > 0) THEN
        BEGIN
          MemD_Traitees.delete;
        END;
        //si le dernier nettoyage remonte à plus d'1 jour nettoyer le dossier des zip
          //si le date du dernier nettoyage du dossier contenant les zip à plus de 1 jour executer le nettoyage
        IF (DaysBetween(now, dtDernierNettoyageZip) >= 1) THEN
        BEGIN
          nettoyerDossierZip();
        END;
        MemD_Traitees.Append;
        MemD_Traiteesid_envoie.AsInteger := TThread_Traitement(objThreadListe.Items[i]).uneDemande.Id_envoie;
        MemD_Traiteesemail.AsWideString := TThread_Traitement(objThreadListe.Items[i]).uneDemande.email;
        MemD_Traiteesdate_traitement.asString := TThread_Traitement(objThreadListe.Items[i]).uneDemande.dateTraitement;
        MemD_Traiteesdatecreation.AsString := TThread_Traitement(objThreadListe.Items[i]).uneDemande.dateDemande;
        MemD_TraiteesUTI_NOM.asString := TThread_Traitement(objThreadListe.Items[i]).uneDemande.nom;
        MemD_TraiteesUTI_PRENOM.asString := TThread_Traitement(objThreadListe.Items[i]).uneDemande.prenom;
        MemD_Traiteesetat.AsInteger := TThread_Traitement(objThreadListe.Items[i]).uneDemande.etat;
        MemD_Traitees.Post;
        objThreadListe.Delete(i);
        executerTraitement();
      END;
    END
  FINALLY
    //LeaveCriticalSection(LockFileAttente);
    MemD_Traitees.EnableControls;
    IF (MemD_Traitees.recordCount > 0) THEN
    BEGIN
      MemD_TraiteesBis.DisableControls;
      MemD_TraiteesBis.Close;
      MemD_TraiteesBis.LoadFromDataSet(MemD_Traitees);
      MemD_TraiteesBis.EnableControls;
    END;
    Application.ProcessMessages;
  END;
END;

PROCEDURE TDm_Traitements.signalerIncident(msg: STRING);
BEGIN
  TRY
    EnterCriticalSection(LockFileAttente);
    //signale par e-mail que le programme à rencontré un problème
    IdMessage.Clear;
    IdMessage.Body.Clear;
    IdMessage.From.Text := MailDest; // 'Catman@Ginkoia.fr';
    //IdMessage.CCList.EMailAddresses := ; // Systématiquement une copie à l'adresse mail originale
    IdMessage.Recipients.EMailAddresses := wsListeEmailIncidents;
    IdMessage.Subject := 'Notification Incident AnalysesCatman.exe';
    IdMessage.Body.Text := DateTimeToStr(now) + ' AnalysesCatman.exe a rencontré un problème lors de son execution. ' + #13#10 + 'Description du problème : ' + msg;

    TRY
      IF NOT idsmtp.connected THEN
        IdSMTP.Connect();
      IdSMTP.Send(IdMessage);
    EXCEPT
      EXIT;
    END;
    IdSMTP.Disconnect();
  FINALLY

    LeaveCriticalSection(LockFileAttente);
  END;
END;

FUNCTION TDm_Traitements.creerEtEnvoiEmail(ADemande: TDemandeAnalyse; mode: Integer): boolean;
VAR
  retour: boolean;
  ts: TStrings;
  logoAttachmentCatman, logoAttachmentGinkoia: TIdAttachmentFile;
  htmpart, txtpart: TIdText;
  lien: STRING;
  indyMsg: TIdMessage;
  indySmtp: TIdSMTP;
BEGIN
  TRY
    //EnterCriticalSection(LockFileAttente);
    retour := false;
    indyMsg := TIdMessage.Create(Dm_Traitements);
    indySmtp := TIdSmtp.Create(Dm_Traitements);
    initSmtp(indySmtp);
    //fonction qui créer et envoi un e-mail au demandeur de l'analyse effectuée en fonction du mode fournit : 0 échec d'execution de la demande, 1 réussite
    indyMsg.Clear;
    indyMsg.Body.Clear;
    indyMsg.From.Text := MailDest; // 'Catman@Ginkoia.fr';
    //passer la bonne adresse selon le mode de fonctionnement
    IF bDebug THEN
    BEGIN
      indyMsg.Recipients.EMailAddresses := wsListeEmailIncidents;
    END
    ELSE
    BEGIN
      indyMsg.Recipients.EMailAddresses := Ademande.email;
    END;
    indyMsg.Subject := Ademande.resultat;
    tIdText(indyMsg.MessageParts).ContentType := 'multipart/mixed';
    //créer le message
    ts := TStringList.Create;
    //charger le modèle
    ts.LoadFromFile(ExtractFilePath(Application.ExeName) + 'modeleAnalyseCatman.html');
    //remplacer les variables par les valeurs
    ts.text := StringReplace(ts.Text, '~~dateDemande~~', ADemande.dateDemande, [rfIgnoreCase]);
    ts.text := StringReplace(ts.Text, '~~utilisateur~~', ADemande.utilisateur, [rfIgnoreCase]);
    ts.text := StringReplace(ts.Text, '~~collection~~', ADemande.collection, [rfIgnoreCase]);
    ts.text := StringReplace(ts.Text, '~~marque~~', ADemande.marque, [rfIgnoreCase]);
    ts.text := StringReplace(ts.Text, '~~categorie~~', ADemande.categorie, [rfIgnoreCase]);
    ts.text := StringReplace(ts.Text, '~~dossier~~', ADemande.dossier, [rfIgnoreCase]);
    //adapter le texte au cas de réussite ou de succès d'execution de la demande
    IF (mode = 1) THEN
    BEGIN
      lien := '<br/><a href="' + LienHttp + ADemande.nomFichier + '">'
        + '<span class="bouton">CLIQUER ICI</span></a><span class="lien"> pour t&eacute;l&eacute;charger votre fichier ('
        + ADemande.nomFichier + ' du ' + ADemande.dateTraitement + ') <!--taille:  Ko)//--></span><br />'
        //'<p>Cliquer ici pour télécharger votre fichier (' + ADemande.nomFichier + ' du ' + ADemande.dateTraitement + ').</p>';
    END
    ELSE
    BEGIN
      lien := '<p>Suite à un problème technique, votre demande d''analyse n''a pas été traitées.(' + intTosTr(Ademande.Id_envoie) + ')</p><p>Veuillez réessayer ultérieurement.</p>';
    END;
    ts.text := StringReplace(ts.Text, '~~lien~~', lien, [rfIgnoreCase]);
    indyMsg.Body := ts;
    //  ts.text := StringReplace(ts.Text, '~~nomFichier~~', ADemande.nomFichier, [rfIgnoreCase]);
    //  ts.text := StringReplace(ts.Text, '~~dateTraitement~~', ADemande.dateTraitement, [rfIgnoreCase]);
    txtpart := TIdText.Create(indyMsg.MessageParts);
    txtpart.ContentType := 'text/html';
    txtpart.Body.Text := ts.Text;

    logoAttachmentCatman := TIdAttachmentFile.Create(indyMsg.MessageParts, ExtractFilePath(Application.ExeName) + 'logoCatman.png');
    logoAttachmentCatman.ContentType := 'image/png';
    logoAttachmentCatman.FileIsTempFile := false;
    logoAttachmentCatman.ContentDisposition := 'inline';
    logoAttachmentCatman.ExtraHeaders.Values['content-id'] := 'logoCatman.png';
    logoAttachmentCatman.DisplayName := 'logoCatman.png';
    logoAttachmentGinkoia := TIdAttachmentFile.Create(indyMsg.MessageParts, ExtractFilePath(Application.ExeName) + 'logoGinkoia.png');
    logoAttachmentGinkoia.ContentType := 'image/png';
    logoAttachmentGinkoia.FileIsTempFile := false;
    logoAttachmentGinkoia.ContentDisposition := 'inline';
    logoAttachmentGinkoia.ExtraHeaders.Values['content-id'] := 'logoGinkoia.png';
    logoAttachmentGinkoia.DisplayName := 'logoGinkoia.png';

    IF NOT indySmtp.connected THEN
      indySmtp.Connect();
    indySmtp.Send(indyMsg);
    retour := true;
  FINALLY
    indySmtp.Disconnect();
    ts.free;
    logoAttachmentCatman.free;
    logoAttachmentGinkoia.free;
    indyMsg.free;
    indySmtp.free;
    //LeaveCriticalSection(LockFileAttente);
  END;
  result := retour;
END;

PROCEDURE TDm_Traitements.nettoyerDossierZip;
VAR
  dtDateFichier: TdateTime;
  i, iAgeCurFile: integer;
  sCurFile, sDir: STRING;
BEGIN
  WITH GrepZip DO
  BEGIN
    //rechercher tous les fichiers de plus de DUREECONSERVATION  et les effacer s'ils ont plus que DUREECONSERVATION
    Dirs := sCheminCopy;
    FileMasks := '*.zip';
    RecurseSubDirs := false;
    ReturnValues := [rvFilename];
    Grep;
    FOR i := 0 TO Files.Count - 1 DO
    BEGIN
      sCurFile := StringReplace(Files[i], ';', '', [rfReplaceAll]);
      iAgeCurFile := FileAge(IncludeTrailingBackslash(sCheminCopy) + sCurFile);
      dtDateFichier := FileDateToDateTime(iAgeCurFile);
      IF (DaysBetween(now, dtDateFichier) > iDureeConservation) THEN
      BEGIN
        DeleteFile(pchar(IncludeTrailingBackslash(sCheminCopy) + sCurFile ));
      END
    END;
    //actualiser la date du dernier nettoyage
    dtDernierNettoyageZip := now;
  END;
END;

{ TThread_Traitement }

CONSTRUCTOR TThread_Traitement.Create(ADemande: TDemandeAnalyse);
BEGIN
  FreeOnTerminate := false;
  WITH uneDemande DO
  BEGIN
    dateDemande := ADemande.dateDemande;
    collection := ADemande.collection;
    marque := ADemande.marque;
    categorie := ADemande.categorie;
    dossier := ADemande.dossier;
    utilisateur := ADemande.utilisateur;
    nom := ADemande.nom;
    prenom := ADemande.prenom;
    resultat := ADemande.resultat;
    email := ADemande.email;
    Id_envoie := ADemande.Id_envoie;
    id_utilisateur := ADemande.id_utilisateur;
    col_id := ADemande.col_id;
    cat_id := ADemande.cat_id;
    mrk_id := ADemande.mrk_id;
    dos_id := ADemande.dos_id;
    detail := ADemande.detail;
    Format := ADemande.Format;
    reg_id := ADemande.reg_id;
    detail_coul := ADemande.detail_coul;
    uni_id := ADemande.uni_id;
    uti_id := ADemande.uti_id;
    dateTraitement := ADemande.dateTraitement;
    etat := ADemande.etat;
    ext := ADemande.ext;
  END;
  INHERITED Create(false);
END;

DESTRUCTOR TThread_Traitement.Destroy;
BEGIN
  INHERITED;
END;

PROCEDURE TThread_Traitement.Execute;
VAR
  sExt: STRING;
  wsEmail: WideString;
  iId_Util, i: Integer;
  dateTraitement: TdateTime;
  Param: TParameter;
  //txtFic: textfile;
  sTemp, sPath: STRING;
  //lst: TstringList;
  j: integer;
  zip: TVCLZip;
BEGIN
  INHERITED;
  TRY
    TRY
      TRY
        //création de la connection
        ADOConn := TADOConnection.Create(dm_Traitements);
        ADOConn.ConnectionString := Format(ConnString, [username, PassWord, Server]);
        ADOConn.LoginPrompt := false;
        ADOConn.CommandTimeout := 600000;
        ADOConn.DefaultDatabase := 'SP2000CATMAN';
        TRY
          ADOConn.Connected := true;
        EXCEPT ON E: Exception DO
            RAISE EXception.Create('Connection  -> ' + E.MEssage);
        END;

        //création des requetes de mis à jours
        Que_majEtat := TADOQuery.create(dm_Traitements);
        Que_majEtat.Connection := ADOConn;
        Que_majEtat.sql.Add(strSqlMajEtat);
        Que_majEtat.Parameters.ParseSQL(strSqlMajEtat, true);
        Param := Que_majEtat.Parameters.ParamByName('etat');
        Param.DataType := ftInteger;
        Param := Que_majEtat.Parameters.ParamByName('IdEnvoi');
        Param.DataType := ftInteger;
        Que_majEtat.Prepared := true;

        Que_termine := TADOQuery.create(dm_Traitements);
        Que_termine.Connection := ADOConn;
        Que_termine.sql.add(strSqlTermine);
        Que_termine.Parameters.ParseSQL(strSqlTermine, true);
        Param := Que_termine.Parameters.ParamByName('etat');
        Param.DataType := ftInteger;
        Param := Que_termine.Parameters.ParamByName('termine');
        Param.DataType := ftInteger;
        Param := Que_termine.Parameters.ParamByName('IdEnvoi');
        Param.DataType := ftInteger;
        Que_termine.ParamCheck := true;
        Que_termine.Prepared := true;
        //création de la procédure stockée
        StProc_Analyse := TADOStoredProc.create(dm_Traitements);
        WITH StProc_Analyse DO
        BEGIN
          Connection := ADOConn;
          CommandTimeout := dm_traitements.iDureeMaxAnalyse;
          ProcedureName := 'VISU_TBARTICLE;1'; //VISU_TBARTICLE_LARS
          //StProc_Analyse.Refresh;
          //StProc_Analyse.Parameters.ParseSQL(strSqlProc_Lars, true);
          Parameters.clear;
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[0].Name := '@Col_id';
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[1].Name := '@cat_id';
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[2].Name := '@mrk_id';
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[3].Name := '@dos_id';
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[4].Name := '@detail';
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[5].Name := '@reg_id';
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[6].Name := '@uni_id';
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[7].Name := '@uti_id';
          Param := TParameter.create(StProc_Analyse.Parameters);
          Parameters[8].Name := '@detail_coul';

          Parameters.ParamByName('@Col_id').Value := uneDemande.col_id;
          Parameters.ParamByName('@cat_id').value := uneDemande.cat_id;
          Parameters.ParamByName('@mrk_id').value := uneDemande.mrk_id;
          Parameters.ParamByName('@dos_id').Value := uneDemande.dos_id;
          Parameters.ParamByName('@detail').Value := uneDemande.detail;
          Parameters.ParamByName('@reg_id').value := uneDemande.reg_id;
          Parameters.ParamByName('@uni_id').value := uneDemande.uni_id;
          Parameters.ParamByName('@uti_id').Value := uneDemande.id_utilisateur;
          Parameters.ParamByName('@detail_coul').Value := uneDemande.detail_coul;
          TRY
            open;
          EXCEPT ON E: Exception DO
              RAISE EXception.Create('Proc analyse -> ' + E.MEssage);
          END;

          //pour les xls crÃ©er un csv pour le moment
          IF (uneDemande.Format = 3) THEN
            sPath := IncludeTrailingBackslash(dm_traitements.sCheminCopy) + PREFIX_FICHIER + intToStr(uneDemande.id_envoie) + '.csv'
          ELSE
            sPath := IncludeTrailingBackslash(dm_traitements.sCheminCopy) + PREFIX_FICHIER + intToStr(uneDemande.id_envoie) + uneDemande.ext;

          //écrire le fichier
          TRY
            WITH Dm_Traitements DO
            BEGIN
              TRY
                EnterCriticalSection(LockFileAttente);
                MemD_Resultat.Close;
                MemD_Resultat.LoadFromDataSet(StProc_Analyse);
                MemD_Resultat.SaveToTextFile(sPath);
                MemD_Resultat.Close;
                //zipper
                zip := tvclZip.Create(Dm_Traitements);
                zip.FilesList.Clear;
                zip.FilesList.Add(sPath);
                uneDemande.nomFichier := PREFIX_FICHIER + intToStr(uneDemande.id_envoie) + '.zip';
                zip.ZipName := IncludeTrailingBackslash(dm_traitements.sCheminCopy) + uneDemande.nomFichier;
                Zip.Zip;
                //supprimer le zip
                DeleteFile(Pchar(sPath));
              FINALLY
                LeaveCriticalSection(LockFileAttente);
              END;
            END;
            //TestCsvFileStream(StProc_Analyse, sPath);

          EXCEPT ON E: Exception DO
              RAISE EXception.Create('Ecriture fichier résultat -> ' + E.MEssage);
          END;
          StProc_Analyse.close;
        END;
        // mettre à jour la liste des traitements démarrés et renseigner la liste des traitements effectués.
          // modifier Etat = 2
        ADOConn.BeginTrans;
        Que_MajEtat.Parameters.ParamByName('etat').Value := 2;
        Que_MajEtat.Parameters.ParamByName('idEnvoi').Value := uneDemande.Id_envoie;
        TRY
          Que_MajEtat.ExecSQL;
        EXCEPT ON E: Exception DO
            RAISE EXception.Create('etat 2  -> ' + E.MEssage);
        END;
        ADOConn.CommitTrans;
        uneDemande.etat := 2;
        //créer le mail et l'envoyer à l'utilisateur
        IF dm_traitements.creerEtEnvoiEmail(uneDemande, 1) THEN
        BEGIN
          //modifier Etat = 3
          ADOConn.BeginTrans;
          Que_termine.Parameters.ParamByName('etat').Value := 3;
          Que_termine.Parameters.ParamByName('termine').Value := 1;
          Que_termine.Parameters.ParamByName('idEnvoi').Value := uneDemande.Id_envoie;
          TRY
            Que_termine.ExecSQL;
          EXCEPT ON E: Exception DO
              RAISE EXception.Create('etat 3 -> ' + E.MEssage);
          END;

          uneDemande.etat := 3;
          ADOConn.CommitTrans;
        END
        ELSE
        BEGIN
          dm_traitements.signalerIncident('Etape : envoi de l''e-mail pour la demande : ' + intToStr(uneDemande.Id_envoie));
        END;
      EXCEPT ON Stan: Exception DO
        BEGIN
          //signaler le problème à l'admin
          dm_traitements.signalerIncident('Etape : Traitement d''une demande, Erreur : ' + Stan.Message);
          //signaler le problème à l'utilisateur
          dm_traitements.creerEtEnvoiEmail(uneDemande, 0);
          //tenter de mettre à jour l'état de la demande
          ADOConn.BeginTrans;
          Que_MajEtat.Parameters.ParamByName('etat').Value := 4;
          Que_MajEtat.Parameters.ParamByName('idEnvoi').Value := uneDemande.Id_envoie;
          TRY
            Que_MajEtat.ExecSQL;
          EXCEPT ON E: Exception DO
              RAISE EXception.Create('etat 4  -> ' + E.MEssage);
          END;
          Que_MajEtat.ExecSQL;
          ADOConn.CommitTrans;
          uneDemande.etat := 4;
        END;
      END;
    EXCEPT ON Stan: Exception DO
      BEGIN
        //signaler le problème à l'admin
        dm_traitements.signalerIncident('Etape : Traitement d''une demande, Erreur : ' + Stan.Message);
      END;
    END;
  FINALLY
    Que_MajEtat.close;
    Que_termine.close;
    ADOConn.Connected := false;
    Que_majEtat.free;
    Que_termine.free;
    StProc_Analyse.Free;
    ADOConn.Free;
    zip.free;
    Terminate;
  END;

END;

PROCEDURE TThread_Traitement.AdoQueryToCsv(AQuery: TAdoStoredProc; ColDelemiter, RowDelemiter, Filename: STRING);
VAR
  lst: TStringList;
  i: integer;
  sTemp: STRING;
BEGIN
  WITH AQuery DO
  BEGIN
    lst := TStringList.Create;
    TRY
      First; // obligatoire sinon la récupération des données ne se fera qu'a la position courante du curseur dans la base de données.
      lst.Text := Recordset.GetString(adClipString, RecordCount, ColDelemiter, RowDelemiter, '');
      //Ajout de la liste des champs
      FOR i := 0 TO FieldCount - 1 DO
        sTemp := sTemp + Fields.Fields[i].FieldName + ColDelemiter;
      lst.Insert(0, Copy(sTemp, 1, Length(sTemp) - Length(ColDelemiter)));
      lst.SaveToFile(Filename);
    FINALLY
      lst.Free;
    END;
  END;
END;

PROCEDURE TThread_Traitement.TestCsvFileStream(AQuery: TAdoStoredProc; Path: STRING);
VAR
  FFile: TFileStream;
  sTemp, sLigne: STRING;
  i, j: integer;
BEGIN
  FFile := TFileStream.Create(Path, fmCreate);
  WITH AQuery DO
  TRY
    sTemp := '';
    FOR i := 0 TO FieldCount - 1 DO
      sTemp := sTemp + Fields[i].FieldName + #9;
    sTemp := Copy(sTemp, 1, Length(sTemp) - 1) + #13#10;
    FFile.WriteBuffer(sTemp[1], Length(sTemp));

    WHILE NOT EOF DO
    BEGIN
      sLigne := '';
      j := 0;
      WHILE NOT EOF AND (j <= 1000) DO
      BEGIN
        sTemp := '';
        FOR i := 0 TO FieldCount - 1 DO
          sTemp := sTemp + FieldList.Fields[i].AsString + #9;
        sTemp := Copy(sTemp, 1, Length(sTemp) - 1) + #13#10;
        sLigne := sLigne + sTemp;
        Next;
        inc(j);
      END;
      FFile.WriteBuffer(sLigne[1], Length(sLigne));
    END;
  FINALLY
    FFile.Free;
  END;
END;

PROCEDURE controlerTraitementsEncours();
VAR
  i: integer;
  difDate: Tdatetime;
BEGIN

  WITH dm_traitements DO
  BEGIN
    //tant que le flag est sur surveillance
    WHILE bSurveillerDureeTraitement DO
    BEGIN
      TRY
        EnterCriticalSection(LockFileAttente);
        //parcourir la liste des traitements en cours et identifier ceux qui dépassent la durée max
        FOR I := objThreadListe.Count - 1 DOWNTO 0 DO
        BEGIN
          IF NOT TThread_Traitement(objThreadListe.Items[i]).Terminated THEN
          BEGIN
            //si la durée limite est atteinte
            difDate := now - strToDateTime(TThread_Traitement(objThreadListe.Items[i]).uneDemande.dateTraitement);
            IF (difDate > iDureeMaxAnalyse) THEN
            BEGIN
              //enlever l'objet des traitements encours
              TThread_Traitement(objThreadListe.Items[i]).unedemande.etat := 4;
            END;
          END;
        END;
      FINALLY
        LeaveCriticalSection(LockFileAttente);
      END;
      sleep(iFrequenceCtrlAnalyse);
    END;
  END;
END;

END.

