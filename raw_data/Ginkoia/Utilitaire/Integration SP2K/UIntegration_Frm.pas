UNIT UIntegration_Frm;

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
  Dialogs,
  //début de uses
  Inifiles,
  stdUtils,
  StdXML_TLB,
  XMLCursor,
  IntNikePrin_FRM,
  URapport,
  IdAttachmentFile,
  idText,
  dateUtils,
  //fin des uses
  DB,
  ADODB,
  LMDCustomComponent,
  LMDFileGrep,
  IdPOP3,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdExplicitTLSClientServerBase,
  IdMessageClient,
  IdSMTPBase,
  IdSMTP,
  IdBaseComponent,
  IdMessage,
  ExtCtrls,
  StdCtrls;

TYPE
  TFrm_Integration = CLASS(TForm)
    Lab_traitements: TLabel;
    Lab_Temps: TLabel;
    Mem_Traitements: TMemo;
    Tim_TraitementsAuto: TTimer;
    IdMessage: TIdMessage;
    idSMTP: TIdSMTP;
    IdPOP: TIdPOP3;
    GrepRecu: TLMDFileGrep;
    Grep_Commande: TLMDFileGrep;
    ADOConnection_CATMAN: TADOConnection;
    ADOQue_CATMANCheminBase: TADOQuery;
    ADOQue_CATMANCheminBasemag_cheminbase: TStringField;
    ADOQue_DOSSIERSCheminBase: TADOQuery;
    ADOConnection_DOSSIERS: TADOConnection;
    ADOQue_DOSSIERSCheminBasedos_chemin: TStringField;
    ADOQue_DOSSIERSCheminBasedos_Nom: TStringField;
    ADOQue_CATMANCheminBasedos_nom: TStringField;
    Grep_Traitement: TLMDFileGrep;
    PROCEDURE Tim_TraitementsAutoTimer(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
  PRIVATE
    { Déclarations privées }
    PROCEDURE recupererCommandes();
    PROCEDURE integrerCommande();
    FUNCTION verifierFichiers(FileName: STRING; VAR codeAdh: STRING; var iCollection: Integer): Boolean;
    PROCEDURE trouverBase(VAR chemin, codeAdh, nomDossier: STRING);
    PROCEDURE nettoyerRepTraitements(sendMessage : Boolean );
    PROCEDURE recupererMail(unNomDeFichier: STRING);
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_Integration: TFrm_Integration;

IMPLEMENTATION

{$R *.dfm}

PROCEDURE TFrm_Integration.Tim_TraitementsAutoTimer(Sender: TObject);
BEGIN
  Tim_TraitementsAuto.enabled := false;
  //vérifier s'il y a de nouveaux fichiers à récupèrer
  recupererCommandes();
  //intègrer les fichiers
  integrerCommande();
  //fermer l'application
  Mem_Traitements.lines.add(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09
    + 'Fermeture de l''application' + #13#10 + #13#10 + 'Un log de cette session est enregistrée dans le dossier \RAPPORTS\LOGS');
  Sleep(3000);
  Close;
END;

PROCEDURE TFrm_Integration.recupererCommandes();
VAR
  I, J, K, nbMail: integer;
  iniCtrl: TiniFile;
BEGIN
  nbMail := 0;
  iniCtrl := TInifile.create(ChangeFileExt(Application.exename, '.ini'));
  //lire l'adresse mail destinatrice des mails d'incidents
  URapport.from := iniCtrl.readString('MAILS', 'MAILSINCIDENTS', 'bruno.nicolafrancesco@ginkoia.fr'); // ;-)
  URapport.pswFrom := iniCtrl.readString('MAILS', 'MPFROM', '');
  URapport.debug := iniCtrl.ReadBool('EXE', 'DEBUG', FALSE);
  URapport.debugDb := iniCtrl.ReadString('EXE','DIR','D:\ControleReplication\CmdSp2k\DATA\GINKOIA.IB');
  // lire le paramétrage des boites mail dans l'ini
  nbMail := iniCtrl.readInteger('MAILS', 'NOMBRE', 0);
  TRY
    //Pour chaque boite mail
    FOR I := 1 TO nbMAil DO
    BEGIN
      IF idPop.connected THEN
        idPop.disconnect;
      //paramétrer le pop3
      idPop.username := iniCtrl.ReadString('MAILS', 'BOITE' + IntToStr(I), '');
      idPop.password := iniCtrl.ReadString('MAILS', 'MP' + IntToStr(I), '');
      idPop.host := 'pop.fr.oleane.com';
      TRY
        //récupèrer les messages et leur pièces jointes
        idPop.Connect;
        Mem_Traitements.lines.add(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09 + 'Récupèration des commandes de ' + idPop.username);
        FOR j := 1 TO idPop.CheckMessages DO
        BEGIN
          //vider l'objet message avant de récupèrer le prochain
          idMessage.Clear;
          idPop.retrieve(j, idMessage);
          // Si on a plusieurs parties dans le mail alors on a une pièce jointe
          TRY
            FOR K := 0 TO IdMessage.MessageParts.count - 1 DO
            BEGIN
              // Est-ce une pièce jointe ?
              IF IdMessage.MessageParts.Items[K] IS TiDAttachmentFile THEN
                WITH TIdAttachmentFile(IdMessage.MessageParts.Items[K]) DO
                BEGIN
                  // On sauvegarde le fichier
                  IF NOT fileExists(ExtractFilePAth(Application.exename) + 'RECU/' + Filename) THEN
                    SaveTofile(ExtractFilePAth(Application.exename) + 'RECU/' + Filename);
                END;
            END; // for K
          EXCEPT ON Stan: Exception DO
            BEGIN
              //initialise à vide les enregistrements du traitement
              initTraitement(unTraitement);
              signalerIncident('Sauvegarde de pièce jointe impossible : ' + TIdAttachmentFile(IdMessage.MessageParts.Items[K]).filename + ' ' + Stan.message, unTraitement);
            END;
          END;
          //archiver le mail
          TRY
            // changement de l'adresse de destinataire
            IdMessage.Recipients.EMailAddresses := 'archivage.commandeSp2K@ginkoia.fr';
            //IdMessage.Recipients.EMailAddresses := 'lionel.abry@ginkoia.fr';
            IdSMTP.Host := 'smtp.fr.oleane.com';
            IdSmtp.Port := 25;
            IdSmtp.Username := from;
            IdSmtp.password := pswFrom;
            IF NOT idSmtp.connected THEN
              IdSmtp.Connect;
            // transfert du mail
            IdSMTP.Send(IdMessage);
          EXCEPT ON Stan: Exception DO
            BEGIN
              //initialise à vide les enregistrements du traitement
              initTraitement(unTraitement);
              signalerIncident('Archivage du mail  : ' + idMessage.Subject + ' Erreur : ' + Stan.MEssage, unTraitement);
            END;
          END;
          //supprimer le mail dans la boite d'origine
          IF NOT IdPop.Delete(J) THEN
          BEGIN
            //initialise à vide les enregistrements du traitement
            initTraitement(unTraitement);
            signalerIncident('Suppression du mail récupèré impossible :' + idMessage.Subject, unTraitement);
          END;
        END; //for J
      EXCEPT ON Stan: Exception DO
        BEGIN
          //initialise à vide les enregistrements du traitement
          initTraitement(unTraitement);
          signalerIncident('Problème lors du traitement de : ' + idPop.username + ' : ' + Stan.message, unTraitement);
        END;
      END;
    END; //for I
  FINALLY
    iniCtrl.free;
    IF idPop.Connected THEN
      idPop.Disconnect;
  END;
END;

PROCEDURE TFrm_Integration.recupererMail(unNomDeFichier: STRING);
VAR
  j, k: integer;
BEGIN
  //parcourir le boite d'archive à la recherche du message contenant unNomDeFichier en pièce jointe
  //et l'envoyer vers la boite de traitement des commandes appropriée
  IF idPop.connected THEN
    idPop.disconnect;
  //paramétrer le pop3
  idPop.username := 'archivage.commandeSp2K@ginkoia.fr';
  idPop.password := '@rchComSp2k';
  idPop.host := 'pop.fr.oleane.com';
  TRY
    //récupèrer les messages et leur pièces jointes
    idPop.Connect;
    FOR j := 1 TO idPop.CheckMessages DO
    BEGIN
      //vider l'objet message avant de récupèrer le prochain
      idMessage.Clear;
      idPop.retrieve(j, idMessage);
      // vérifier la date pour ne pas rechercher dans les plus anciens , arbitrairement je ne regarde que les mails de ses 7 derniers jours
      IF DaysBetween(now, IdMessage.Date) < 7 THEN
      BEGIN
        // Si on a plusieurs parties dans le mail alors on a une pièce jointe
        FOR K := 0 TO IdMessage.MessageParts.count - 1 DO
        BEGIN
          // Est-ce une pièce jointe ?
          IF IdMessage.MessageParts.Items[K] IS TiDAttachmentFile THEN
            WITH TIdAttachmentFile(IdMessage.MessageParts.Items[K]) DO
            BEGIN
              // On compare le nom du fichier pour trouver le notre et si c'est le cas on transfère le mail vers la boite des traitements
              IF Filename = unNomDeFichier THEN
              BEGIN
                //transfèrer le mail
                TRY
                  IdMessage.Recipients.EMailAddresses := 'oxbow@ginkoia.fr';
                  // changement de l'adresse de destinataire
                  IF pos('napali', unNomDeFichier) <> 0 THEN
                    IdMessage.Recipients.EMailAddresses := 'napali@ginkoia.fr';

                  //IdMessage.Recipients.EMailAddresses := 'lionel.abry@ginkoia.fr';
                  IdSMTP.Host := 'smtp.fr.oleane.com';
                  IdSmtp.Port := 25;
                  IdSmtp.Username := from;
                  IdSmtp.password := pswFrom;
                  IF idSmtp.connected THEN
                    IdSmtp.disconnect;
                  IdSmtp.Connect;
                  // transfert du mail
                  IdSMTP.Send(IdMessage);
                EXCEPT ON Stan: Exception DO
                  BEGIN
                    signalerIncident('Récupèration d''un mail archivé non traité impossible : ' + idMessage.Subject + ' Erreur : ' + Stan.MEssage, unTraitement);
                  END;
                END;
                //supprimer le mail dans la boite d'origine
                IF NOT IdPop.Delete(J) THEN
                BEGIN
                  //initialise à vide les enregistrements du traitement
                  initTraitement(unTraitement);
                  signalerIncident('Suppression du mail récupèré impossible :' + idMessage.Subject, unTraitement);
                END;
              END;
            END;
        END; // for K
        IF idPop.Connected THEN
          idPop.Disconnect;
      END;
    END; //for I
  EXCEPT ON Stan: Exception DO
    BEGIN
      signalerIncident('Récupèration du mail archivé contenant : ' + unNomDeFichier + ' impossible :', unTraitement);
    END;
  END;
  IF idPop.Connected THEN
    idPop.Disconnect;
END;

PROCEDURE TFrm_Integration.FormCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
BEGIN
  Mem_Traitements.Lines.SaveToFile(ExtractFilePath(Application.exename) + 'RAPPORTS\LOGS\Log_'
    + FormatDateTime('YYYY_MM_DD_HH"H"NN', Now) + '.txt');
END;

PROCEDURE TFrm_Integration.FormShow(Sender: TObject);
BEGIN
  Tim_TraitementsAuto.enabled := True;
END;

PROCEDURE TFrm_Integration.integrerCommande;
VAR
  sCurFileName: STRING;
  sCodeAdh, sNomDossier: STRING;
  sPath: STRING;
  iSaison: Integer;
BEGIN
  //initialise à vide les enregistrements du traitement
  initTraitement(URapport.unTraitement);
  nettoyerRepTraitements(true);
  //tant qu'il y a des fichiers à traiter dans le répertoire 'recu'
  Mem_Traitements.lines.add(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09 + 'Intégration des commandes : début');
  WITH GrepRecu DO
  BEGIN
    //rechercher tous les fichiers
    Dirs := ExtractFilePath(Application.exename) + 'RECU\';
    FileMasks := '*.*';
    RecurseSubDirs := false;
    ReturnValues := [rvFilename];
    Grep;
    WHILE (Files.Count <> 0) DO
    BEGIN
      sCodeAdh := '';
      sPath := '';
      sNomDossier := '';
      //initialise à vide les enregistrements du traitement
      initTraitement(URapport.unTraitement);
      //traiter le premier fichier
      sCurFileName := StringReplace(Files[0], ';', '', [rfReplaceAll]);
      IF verifierFichiers(sCurFileName, sCodeAdh, iSaison) THEN
      BEGIN
        //recupèrer le chemin vers la base
        trouverBase(sPath, sCodeAdh, sNomDossier);
        //lancer le traitement
        IF (sPath <> '') THEN
        BEGIN
          Mem_Traitements.lines.add(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09 + 'Début du traitement pour : ' + sPath);
          Application.createform(TFrm_IntNikePrin, Frm_IntNikePrin);
          WITH Frm_IntNikePrin DO
          BEGIN
            repxml1 := ExtractFilePath(Application.exename) + 'TRAITEMENTS\';
            //repxml2 := ExtractFilePath(Application.exename) + 'TRAITEMENTS\';
            uRapport.unTraitement.RapportHtml := ExtractFilePath(Application.exename) + 'RAPPORTS\' + sCodeAdh + '_';
            Data.DatabaseName := sPath;
            saison := iSaison;
            unTraitement.CodeAdherent := sCodeAdh;
            unTraitement.NomDossier := sNomDossier;
            ShowModal;
            IF Frm_IntNikePrin.traite THEN
              Mem_Traitements.lines.add(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09 + 'Intégration terminée avec succès')
            ELSE
            BEGIN
              nettoyerRepTraitements(true);
              Mem_Traitements.lines.add(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09 + 'Echec de l''intégration');
            END;
            Free;
          END;
        END
        ELSE // enlever les fichiers du repertoire traitement, signaler l'incident, récupèrer le mail de la boite d'archivage et le remettre dans le boite de traitement
        BEGIN
          nettoyerRepTraitements(false);
          Mem_Traitements.lines.add(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09 + 'Echec de l''intégration : chemin vers la base vide');
          signalerIncident(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09
            + 'Traitement des fichiers impossible car le chemin vers la base n''a pas été trouvé pour l''adhérent : ' + sCodeAdh, unTraitement);
          recupererMail(sCurFileName);
        END;
      END;
      //Actualiser la liste des fichiers a traiter
      Grep;
    END;
  END;
  Mem_Traitements.lines.add(FormatDateTime('DD-MM-YYYY HH"H"NN', now) + ' : ' + #09 + 'Intégration des commandes : fin');
END;

PROCEDURE TFrm_Integration.nettoyerRepTraitements(sendMessage : Boolean );
VAR
  i: integer;
BEGIN
  //vérifier le répertoire des traitements : s'il reste des fichiers dedans c'est qu'il y a eu une erreur lors d'une traitement
  //enlever les fichiers et signaler le problème
  WITH Grep_Traitement DO
  BEGIN
    //rechercher tous les fichiers
    Dirs := ExtractFilePath(Application.exename) + 'TRAITEMENTS\';
    FileMasks := '*.*';
    RecurseSubDirs := false;
    ReturnValues := [rvFilename];
    Grep;
    //ne pas tenir compte des deux dossiers de base

    IF Files.count <> 2 THEN
    BEGIN
      Mem_Traitements.Lines.Add('Des fichiers non traités ont été trouvés dans le répertoire "traitements" : ');
      FOR i := 0 TO Files.Count - 1 DO
      BEGIN
        IF NOT ((StringReplace(Files[i], ';', '', [rfReplaceAll]) = 'PROBLEMES')
          OR (StringReplace(Files[i], ';', '', [rfReplaceAll]) = 'INTEGRES')) THEN
        BEGIN
          Mem_Traitements.Lines.Add(Files[i]);
          IF fileexists(Pchar(ExtractFilePath(Application.exename) + 'TRAITEMENTS\PROBLEMES\' + Files[i])) THEN
          BEGIN
            deleteFile(Pchar(ExtractFilePath(Application.exename) + 'TRAITEMENTS\PROBLEMES\' + Files[i]));
          END;
          MoveFile(Pchar(Dirs + StringReplace(Files[i], ';', '', [rfReplaceAll])), Pchar(ExtractFilePath(Application.exename) + 'TRAITEMENTS\PROBLEMES\' + StringReplace(Files[i], ';', '', [rfReplaceAll])));
          deleteFile(Pchar(Dirs + StringReplace(Files[i], ';', '', [rfReplaceAll])));
        END;
      END;
      if sendMessage then
      SignalerIncident('Des fichiers non traités ont été trouvés dans le répertoire "traitements" et déplacés dans le répertoire "Problemes"' + #13#10 +
        'Voir log dans le dossier Rapport pour obtenir la liste', Urapport.unTraitement);
    END;
  END;
END;

FUNCTION TFrm_Integration.verifierFichiers(FileName: STRING; VAR codeAdh: STRING; var iCollection: Integer): Boolean;
VAR
  retour: boolean;
  i, j: Integer;
  sCommun, sCurFileName, sTri: STRING;
  Document: IXMLCursor;
  PassXML: IXMLCursor;
BEGIN
  retour := true;
  //Vérifier que les fichiers reçus permettent l'intégration des commandes
  //on avoir 6 fichiers, 6 trigrammes différents même libellé ensuite
  // attention, l'extension peut être .xml ou .zip il faut alors dézipper ?
  //écarter dans le répertoire 'problème' ceux qui ne sont pas conformes
  WITH Grep_Commande DO
  BEGIN
    //récupèrer la partie commune :
    sCommun := substr(filename, 5, length(fileName) - 4);
    Dirs := ExtractFilePath(Application.exename) + 'RECU\';
    //rechercher tous les fichiers de la commande
    FileMasks := '*' + sCommun;
    RecurseSubDirs := false;
    ReturnValues := [rvFilename];
    Grep;
    //initialise à vide les enregistrements du traitement
    initTraitement(unTraitement);
    //si 6 fichiers au format xml
    IF (Files.count = 6) AND (upperCase(ExtractFileExt(StringReplace(Files[0], ';', '', [rfReplaceAll]))) = '.XML') THEN
    BEGIN
      //récupèrer le code adhérent et la collection dans le fichier ECD et vérifier les saisons
      FOR i := 0 TO Files.Count - 1 DO
      BEGIN
        iCollection := -1;
        sTri := substr(Files[i], 1, 3);
        sCurFileName := StringReplace(Files[i], ';', '', [rfReplaceAll]);
        //récupèrer la collection
        IF (iCollection = -1) THEN
        BEGIN
          IF (pos('PE', sCurFileName) <> 0) THEN
            iCollection := 0;
          IF (pos('AH', ScurFileName) <> 0) THEN
            iCollection := 1;
        END;
        IF (iCollection = -1) THEN
        BEGIN
          signalerIncident('Intégration de commande : Saison inconnue ' + #13#10 + sCurFileName, untraitement);
          //Déplacer dans le dossier des problemes
          FOR j := 0 TO Files.Count - 1 DO
          BEGIN
            sCurFileName := StringReplace(Files[j], ';', '', [rfReplaceAll]);
            IF fileexists(Pchar(ExtractFilePath(Application.exename) + '\TRAITEMENTS\PROBLEMES\' + sCurFileName)) THEN
            BEGIN
              deleteFile(Pchar(ExtractFilePath(Application.exename) + '\TRAITEMENTS\PROBLEMES\' + sCurFileName));
            END;
            MoveFile(Pchar(Dirs + sCurFileName), Pchar(ExtractFilePath(Application.exename) + '\TRAITEMENTS\PROBLEMES\' + sCurFileName));
          END;
          retour := False;
          exit;
        END;
        //localiser le fichier ECD pour extraire le code adhérent
        IF sTri = 'ECD' THEN
        BEGIN
          TRY
            //récupèrer le code adhérent dans le xml
            Document := TXMLCursor.Create;
            Document.Load(Dirs + sCurFileName);
            PassXML := Document.Select('ITEM');
            codeAdh := PassXML.GetValue('CMAG');
          EXCEPT
            codeAdh := '';
            retour := false;
          END;
        END;
        //déplacer dans le répertoire temporaire en vue du traitement
        sCurFileName := StringReplace(Files[i], ';', '', [rfReplaceAll]);
        MoveFile(Pchar(Dirs + sCurFileName), Pchar(ExtractFilePath(Application.exename) + '\TRAITEMENTS\' + sCurFileName));
      END;
    END
    ELSE
    BEGIN
      //Déplacer dans le dossier des problemes
      FOR i := 0 TO Files.Count - 1 DO
      BEGIN
        sCurFileName := StringReplace(Files[i], ';', '', [rfReplaceAll]);
        IF FileExists(Pchar(ExtractFilePath(Application.exename) + '\TRAITEMENTS\PROBLEMES\' + sCurFileName)) THEN
        BEGIN
          DeleteFile(Pchar(ExtractFilePath(Application.exename) + '\TRAITEMENTS\PROBLEMES\' + sCurFileName));
        END;
        MoveFile(Pchar(Dirs + sCurFileName), Pchar(ExtractFilePath(Application.exename) + '\TRAITEMENTS\PROBLEMES\' + sCurFileName));
      END;
      retour := False;
    END;
  END;
  result := retour;
END;

PROCEDURE TFrm_Integration.trouverBase(VAR chemin, codeAdh, nomDossier: STRING);
BEGIN
  //Faire une recherche sur Base CATMAN, si le code adhérent n’est pas trouvé faire une recherche sur la base DOSSIER.
  //Si le code n’est pas trouvé, envoyé un mail d’incident (7.3) avec un message spécifique.
  //« Le code adhérent n’est reconnu… »
  //base CATMAN
  TRY
    ADOConnection_CATMAN.Connected := true;
    ADOQue_CATMANCheminBase.Parameters.ParamByName('codeAdh').Value := codeAdh;
    ADOQue_CATMANCheminBase.Open;
    chemin := ADOQue_CATMANCheminBasemag_cheminbase.asString;
    nomDossier := ADOQue_CATMANCheminBasedos_nom.asString;
  FINALLY
    ADOQue_CATMANCheminBase.close;
    ADOConnection_CATMAN.connected := false;
  END;

  IF (chemin = '') THEN
  BEGIN
    //bas DOSSIERS
    TRY
      ADOConnection_DOSSIERS.Connected := true;
      ADOQue_DOSSIERSCheminBase.Parameters.ParamByName('codeAdh').Value := codeAdh;
      ADOQue_DOSSIERSCheminBase.Open;
      chemin := ADOQue_DOSSIERSCheminBasedos_chemin.asString;
      nomDossier := ADOQue_DOSSIERSCheminBasedos_Nom.asString;
    FINALLY
      ADOQue_DOSSIERSCheminBase.close;
      ADOConnection_DOSSIERS.connected := false;
    END;
  END;

  IF (chemin = '') THEN
  BEGIN
    //initialise à vide les enregistrements du traitement
    initTraitement(unTraitement);
    signalerIncident('Recherche de la base pour intégration : le code adhérent ' + codeAdh + ' ne correspond pas à une base connue', unTraitement);
  END;

  IF DEBUG THEN
    chemin := URapport.debugDb;

END;

END.

