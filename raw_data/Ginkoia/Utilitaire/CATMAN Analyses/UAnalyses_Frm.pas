UNIT UAnalyses_Frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  //début de uses
  Inifiles,
  UTraitements,
  dateUtils,
  //fin des uses
  Dialogs,
  Menus,
  ExtCtrls,
  RzPanel,
  RzPanelRv,
  DB,
  Grids,
  DBGrids,
  StdCtrls,
  LMDCustomComponent,
  LMDWndProcComponent,
  LMDTrayIcon,
  OleServer,
  ExcelXP,
  LMDOneInstance;

CONST
  // Définition d'un type de message personnalisé
  WM_CATMAN = 7112;

TYPE
  TFrm_AnalysesCatman = CLASS(TForm)
    Pan_Fond: TRzPanelRv;
    Pan_Traitee: TRzPanelRv;
    MainMenu: TMainMenu;
    mnu_Fichier: TMenuItem;
    mnu_Quitter: TMenuItem;
    Tim_Analyses: TTimer;
    Tim_Surveillance: TTimer;
    Ds_Traitees: TDataSource;
    Lab_NbTraitees: TLabel;
    Dbg_Traitees: TDBGrid;
    lab_horloge: TLabel;
    LMDOneInstance: TLMDOneInstance;
    Tim_MajDemande: TTimer;
    PROCEDURE mnu_QuitterClick(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE WM_MESSAGE(VAR msg: TMessage); MESSAGE WM_CATMAN;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Tray_LaunchDblClick(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE Tim_MajDemandeTimer(Sender: TObject);
  PRIVATE
    { Déclarations privées }
    iNotification: Integer; //fréquence d'émission d'un message signalant notre activité au lanceur en millisecondes
    PROCEDURE arreterApplication();
    PROCEDURE finirTraitements();
    PROCEDURE wait(dureeMs: integer); //durée d'attente en millisecondes
    PROCEDURE controlerEtatEnvois;
  PUBLIC
    { Déclarations publiques }
  END;

FUNCTION signalerActivite(): integer; stdcall;

VAR
  Frm_AnalysesCatman: TFrm_AnalysesCatman;
  idThreadStillActif: cardinal;
  idThreadSurveillance: Cardinal;
  bSignal: boolean; //émettre un signal
  handleLanceur: Thandle;
  threadStillActif: cardinal; //handle du thread signalant l'activité d'AnalyseCatman
  threadSurveillance: cardinal; //handle du thread

IMPLEMENTATION

{$R *.dfm}

PROCEDURE TFrm_AnalysesCatman.FormCreate(Sender: TObject);
VAR
  ini: TInifile;
BEGIN
  //créer l'unite des données
  dm_traitements := TDm_Traitements.create(Application); //l'unité de gestion des traitements
  //charger l'ini et renseigner les variables correspondantes
  dm_traitements.ADOConnectionCATMAN.Connected := False;

  IF FileExists(ChangeFileExt(Application.exename, '.ini')) THEN
  BEGIN
    TRY
      //lecture des différentes valeur stockées et renseignement des variables correspondantes
      ini := TInifile.create(ChangeFileExt(Application.exename, '.ini'));
      WITH dm_traitements DO
      BEGIN
        iMaxNbTraitements := ini.readInteger('ANALYSES', 'MAXTRAITEMENTS', 0); //le nombre max de traitements simultanés
        sCheminCopy := ini.readString('ANALYSES', 'CHEMIN', ''); //chemin ou seront déposés les résultats
        wsListeEmailIncidents := ini.readString('EXE', 'EMAIL_INCIDENTS', 'bruno.nicolafrancesco@ginkoia.fr'); //adresses email ou envoyer les rapports d’incident
        iDureeMaxAnalyse := ini.readInteger('ANALYSES', 'DUREEMAX', 0); //nombre max de minutes accordées au traitement avant de considèrer qu'il y a une anomalie
        iFrequenceCtrlAnalyse := ini.readInteger('ANALYSES', 'FREQUENCE', 0); //fréquence du controle de durée max des analyses
        bDebug := ini.ReadBool('EXE', 'DEBUG', FALSE);
        iFrequenceConsultationBase := ini.readInteger('ANALYSES', 'FREQUENCEAPPELBASE', 30000); //fréquence de consultation de la base pour récupèrer les nouveaux envois
        iDureeConservation := ini.readInteger('ANALYSES', 'DUREECONSERVATION', 7);
      END;
      iNotification := ini.readInteger('EXE', 'NOTIFICATION', 60000); //fréquence d'émission d'un message signalant notre activité au lanceur 1 minute par défaut

      // Database
      UserName := Ini.ReadString('DATABASE','USR','DA_GINKOIA');
      PassWord := ini.ReadString('DATABASE','PWD','ch@mon1x');
      Server   := ini.ReadString('DATABASE','SRV','sp2kcat.no-ip.org');

      // Mail
      MailDest := ini.ReadString('MAIL','DEST','Catman@Ginkoia.fr');
      MailHost := ini.ReadString('MAIL','HOST','smtp.fr.oleane.com');
      MailPort := ini.ReadInteger('MAIL','PORT',25);
      MailUSer := ini.ReadString('MAIL','USR','catman@algodefi.fr.fto');
      MailPass := ini.ReadString('MAIL','PWD','HAkDjKZS');

      // lien
      LienHttp := Ini.ReadString('HTTP','LIEN','http://backup.no-ip.com/sport2000/');

      With Dm_Traitements do
      begin
        ADOConnectionCATMAN.ConnectionString := Format( 'Provider=SQLOLEDB.1;Persist Security Info=False;' +
                 'User ID=%s;Password=%s;Data Source=%s;Use Procedure for Prepare=1;' +
                 'Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;' +
                 'Tag with column collation when possible=False',[username, PassWord, Server]);

        Try
          ADOConnectionCATMAN.Connected := True;
        Except on E:Exception do
          ShowMessage(E.Message);
        End;
      end;

    FINALLY
      ini.Free;
    END;
  END;
END;

PROCEDURE TFrm_AnalysesCatman.FormClose(Sender: TObject; VAR Action: TCloseAction);
VAR
  code: cardinal;
BEGIN
  TRY
    //dire au thread qui signal l'activite de s'arreter
    bsignal := false;
    //attendre la prochaine boucle que l'arrêt soit pris en compte
    //sleep(iFrequenceConsultationBase + 1000);
    //controler l'état des notification d'activité et tuer si toujours actif
    IF threadStillActif <> 0 THEN
    BEGIN
      IF GetExitCodeThread(threadStillActif, code) AND (code = STILL_ACTIVE) THEN
      BEGIN
        TerminateThread(threadStillActif, code);
      END;
      IF threadStillActif <> 0 THEN
      BEGIN
        closeHandle(threadStillActif);
      END;
    END;
    //controler l'état du thread de surveillance des traitements en cours et tuer si toujours actif
//    IF threadSurveillance <> 0 THEN
//    BEGIN
//      IF GetExitCodeThread(threadSurveillance, code) AND (code = STILL_ACTIVE) THEN
//      BEGIN
//        TerminateThread(threadSurveillance, code);
//      END;
//      IF threadStillActif <> 0 THEN
//      BEGIN
//        closeHandle(threadSurveillance);
//      END;
//    END;
  FINALLY
    dm_Traitements.ADOConnectionCATMAN.Connected := false;
    dm_traitements.free;
    IF handleLanceur <> 0 THEN
    BEGIN
      PostMessage(handleLanceur, WM_CATMAN, 5, 0); // 0 pour signaler arret
      TRY
        //closeHandle(handleLanceur);
      EXCEPT
        //interception erreur fermeture du handle
      END;
    END;
  END;
END;

PROCEDURE TFrm_AnalysesCatman.FormCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
BEGIN
  arreterApplication;
  CanClose := true;
END;

PROCEDURE TFrm_AnalysesCatman.FormShow(Sender: TObject);
BEGIN
  //vérifier si on a bien réussit à se connecter
//  IF dm_traitements.ADOConnectionCATMAN.Connected THEN
  BEGIN
    idThreadStillActif := 0;
    bSignal := true;
    dm_traitements.bfileTraitementOuverte := true;
    handleLanceur := FindWindow('TFrm_LanceurCatman', NIL);
    threadStillActif := createThread(NIL, 0, @signalerActivite, NIL, 0, idThreadStillActif);
    //vérifier s'il y a des traitements qui n'ont pas abouti à chaque démarrage de l'appli
    controlerEtatEnvois;
    Tim_MajDemande.Interval := Dm_Traitements.iFrequenceConsultationBase;
    Tim_MajDemande.Enabled := true;
  END;
//  ELSE
//    close();
END;

PROCEDURE TFrm_AnalysesCatman.arreterApplication;
VAR
  i: integer;
BEGIN
  FOR i := 0 TO MainMenu.items.Count - 1 DO
  BEGIN
    MainMenu.Items[i].Enabled := false;
  END;
  Repaint;
  pan_fond.enabled := false;
  finirTraitements();
END;

PROCEDURE TFrm_AnalysesCatman.finirTraitements;
BEGIN
  WITH dm_traitements DO
  BEGIN
    //stopper la surveillance
    bSurveillerDureeTraitement := false;
    //bloqueer la création de nouveaux traitements
    bfileTraitementOuverte := false;
    Screen.Cursor := crHourGlass;
    application.ProcessMessages;
    sleep(iFrequenceConsultationBase);
    //attendre que les traitements en cours soient finis
    WHILE (MemD_EnCours.recordCount > 0) DO
    BEGIN
      //rendre la main au system
      Application.ProcessMessages;
      nettoyerListeThread;
      sleep(500);
    END;
    Screen.Cursor := crDefault;
  END;
END;

PROCEDURE TFrm_AnalysesCatman.mnu_QuitterClick(Sender: TObject);
BEGIN
  arreterApplication;
  close();
END;

PROCEDURE TFrm_AnalysesCatman.Tim_MajDemandeTimer(Sender: TObject);
BEGIN
  //récupèrer la liste des envois en consultant la table envoi_analyse pour l'état=0
  //tim_MajDemande.Enabled := false;
  WITH Dm_Traitements, Frm_AnalysesCatman DO
  BEGIN
    ADOConnectionCATMAN.Connected := true;
    TRY
      EnterCriticalSection(LockFileAttente);
      //nettoyer la liste des threads : retirer ceux qui sont terminés
      dm_traitements.nettoyerListeThread;
      MemD_EnAttente.DisableControls;
      TRY
        ADOQue_Envois.close;
        ADOQue_Envois.Open;
        //parcourir les résultats : si les demandes envois récupèrés ne sont pas dans la liste d'attente,
        //les ajouter (tant qu'elle est modifiée par un autre thread ne rien faire, dès qu'elle est libre la mettre à jour)
        IF ADOQue_Envois.RecordCount > 0 THEN
        BEGIN
          IF NOT (ADOQue_Envois.State IN [dsEdit, DsInsert]) THEN
          BEGIN
            //parcourir la liste
            ADOQue_Envois.First;
            WHILE NOT ADOQue_Envois.eof DO
            BEGIN
              //si l'enregistrement ne s'y trouve pas, l'ajouter
              IF NOT (MemD_EnAttente.Locate('id_envoie', ADOQue_Envoisid_envoie.asInteger, [])) THEN
              BEGIN
                MemD_EnAttente.append;
                MemD_EnAttenteId_envoie.asinteger := ADOQue_Envoisid_envoie.asInteger;
                MemD_EnAttenteid_utilisateur.AsInteger := ADOQue_Envoisid_utilisateur.asInteger;
                MemD_EnAttentedatecreation.AsDateTime := ADOQue_Envoisdatecreation.asDateTime;
                MemD_EnAttenteresultat_global.asBoolean := ADOQue_Envoisresultat_global.asBoolean;
                MemD_EnAttenteresultat_detaille.asBoolean := ADOQue_Envoisresultat_detaille.asBoolean;
                MemD_EnAttentecol_id.AsInteger := ADOQue_Envoiscol_id.asInteger;
                MemD_EnAttentecat_id.AsInteger := ADOQue_Envoiscat_id.asInteger;
                MemD_EnAttentemrk_id.AsInteger := ADOQue_Envoismrk_id.asInteger;
                MemD_EnAttentedos_id.AsInteger := ADOQue_Envoisdos_id.asInteger;
                MemD_EnAttentedetail.AsInteger := ADOQue_Envoisdetail.asInteger;
                MemD_EnAttentetermine.asBoolean := ADOQue_Envoistermine.asBoolean;
                MemD_EnAttenteemail.AsWideString := ADOQue_Envoisemail.asWideString;
                MemD_EnAttentereg_id.AsInteger := ADOQue_Envoisreg_id.asInteger;
                MemD_EnAttentedetail_coul.AsInteger := ADOQue_Envoisdetail_coul.asInteger;
                MemD_EnAttenteetat.AsInteger := ADOQue_Envoisetat.asInteger;
                MemD_EnAttentedate_traitement.AsDateTime := ADOQue_Envoisdate_traitement.asDateTime;
                MemD_EnAttenteuni_id.AsInteger := ADOQue_Envoisuni_id.asInteger;
                MemD_EnAttenteFormat.AsInteger := ADOQue_EnvoisFormat.asInteger;
                MemD_EnAttenteCOL_NOM.asString := ADOQue_EnvoisCOL_NOM.asString;
                MemD_EnAttenteMRK_NOM.AsString := ADOQue_EnvoisMRK_NOM.asString;
                MemD_EnAttenteCAT_NOM.AsString := ADOQue_EnvoisCAT_NOM.AsString;
                MemD_EnAttenteDOS_NOM.asString := ADOQue_EnvoisDOS_NOM.AsString;
                MemD_EnAttenteUTI_NOM.AsString := ADOQue_EnvoisUTI_NOM.asString;
                MemD_EnAttenteUTI_PRENOM.asString := ADOQue_EnvoisUTI_PRENOM.asString;
                MemD_EnAttente.post;
                executerTraitement();
              END;
              ADOQue_Envois.Next;
            END;
          END;
        END;
      EXCEPT ON Stan: Exception DO
        BEGIN
          ADOQue_Envois.Close;
          //signaler pb
          signalerIncident('Etape : Mise à jour de la file d''attente des demandes, Erreur : ' + Stan.Message);
        END;
      END;
    FINALLY
      LeaveCriticalSection(LockFileAttente);
      ADOConnectionCATMAN.Connected := false;
      tim_MajDemande.Enabled := Dm_Traitements.bfileTraitementOuverte
    END;
  END;
END;

PROCEDURE TFrm_AnalysesCatman.controlerEtatEnvois;
VAR
  uneDemande: TDemandeAnalyse;
BEGIN
  WITH Dm_Traitements DO
  BEGIN
    TRY
      //ouvrir la connection
      ADOConnectionCATMAN.Connected := true;
      ADOQue_EchecEnvois.close;
      ADOQue_EchecEnvois.Open;
      IF ADOQue_EchecEnvois.RecordCount > 0 THEN
      BEGIN
        ADOQue_EchecEnvois.first;
        WHILE NOT ADOQue_EchecEnvois.eof DO
        BEGIN
          //renseigner la demande
          WITH uneDemande DO
          BEGIN
            dateDemande := ADOQue_EchecEnvoisdatecreation.asString;
            collection := ADOQue_EchecEnvoisCOL_NOM.asString;
            marque := ADOQue_EchecEnvoisMRK_NOM.asString;
            categorie := ADOQue_EchecEnvoisCAT_NOM.asstring;
            dossier := ADOQue_EchecEnvoisDOS_NOM.asString;
            utilisateur := ADOQue_EchecEnvoisUTI_NOM.AsString + ' ' + ADOQue_EchecEnvoisUTI_PRENOM.asString;
            IF (ADOQue_EchecEnvoisresultat_global.asBoolean = true) THEN
              resultat := 'Résultat réseau'
            ELSE
              resultat := 'Résultat dossier';
            email := ADOQue_EchecEnvoisemail.AsWideString;
            Id_envoie := ADOQue_EchecEnvoisid_envoie.asInteger;
          END;
          ADOQue_EchecEnvois.next;
          //mettre à jour l'état de l'envoi
          TRY
            ADOQue_MajEtat.Parameters.ParamByName('etat').Value := 4;
            ADOQue_MajEtat.Parameters.ParamByName('idEnvoi').Value := uneDemande.Id_envoie;
            ADOQue_MajEtat.ExecSQL;
          FINALLY
            //emettre l'email
            creerEtEnvoiEmail(uneDemande, 0);
          END;
        END
      END
        //parcourir les résultats
    EXCEPT ON Stan: Exception DO
      BEGIN
        ADOQue_EchecEnvois.Close;
        //signaler pb
        signalerIncident('Etape : Recherche / communication des traitements des demandes inachevées , Erreur : ' + Stan.Message);
      END;
    END;
    ADOConnectionCATMAN.Connected := false;
  END;
END;

PROCEDURE TFrm_AnalysesCatman.Tray_LaunchDblClick(Sender: TObject);
BEGIN
  show;
  FormStyle := FsStayOnTop;
  Application.processmessages;
  FormStyle := FsNormal;
END;

PROCEDURE TFrm_AnalysesCatman.wait(dureeMs: integer);
VAR
  debut: tDateTime;
BEGIN
  debut := now;
  WHILE (SecondsBetween(now, debut) < (dureeMs DIV 1000)) DO
  BEGIN
    application.ProcessMessages;
    //sleep(dureeMs);
  END;
END;

FUNCTION signalerActivite(): integer; STDCALL;
BEGIN
  //tant qu'il n'y a pas de  demande d'arret signaler mon activité
  WITH Frm_AnalysesCatman DO
  BEGIN
    WHILE bSignal DO
    BEGIN
      lab_horloge.Caption := DatetimeToStr(now);
      TRY
        IF handleLanceur <> 0 THEN
          PostMessage(handleLanceur, WM_CATMAN, 0, 1); //1 pour actif
        sleep(Frm_AnalysesCatman.iNotification);
      EXCEPT
        closeHandle(handleLanceur);
      END;
    END;
  END;
  result := 0;
END;

PROCEDURE TFrm_AnalysesCatman.WM_MESSAGE(VAR msg: TMessage);
BEGIN
  //si le lanceur nous donne l'ordre de finir les traitements en cours et de nous arrêter
  IF msg.LParam = -1 THEN
  BEGIN
    arreterApplication;
    close();
  END;
END;

END.

