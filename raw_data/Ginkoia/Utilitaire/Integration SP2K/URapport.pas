UNIT URapport;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  IdAttachmentFile,
  idText,
  IdPOP3,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdExplicitTLSClientServerBase,
  IdMessageClient,
  IdSMTPBase,
  IdSMTP,
  IdBaseComponent,
  IdMessage;

TYPE
  TRecTraitement = RECORD
    CodeAdherent: STRING;
    NomDossier: STRING;
    NomMag: STRING;
    Ville: STRING;
    Telephone: STRING;
    AdrEmail: STRING;
    rapportHtml: STRING;
    descriptionIncident: STRING;
    resultat: STRING;
  END;

PROCEDURE signalerIncident(msg: STRING; traitement: TRecTraitement);
FUNCTION envoyerMailIntegration(traitement: TRecTraitement): Boolean;
PROCEDURE initTraitement(VAR traitement: TRecTraitement);

VAR
  IdMessage: TIdMessage;
  idSMTP: TIdSMTP;
  IdPOP: TIdPOP3;
  unTraitement: TRecTraitement;
  from, pswFrom: STRING;
  debug: boolean;
  debugDb : String;

IMPLEMENTATION

FUNCTION envoyerMailIntegration(traitement: TRecTraitement): Boolean;
VAR
  logoAttachmentGinkoia, rapportHtmlAttachment: TIdAttachmentFile;
  txtpart: TIdText;
  ts: TStrings;
BEGIN
  //vérifier la validité de l'adress e-mail
  IF (trim(traitement.AdrEmail) = '') OR (Pos('@', traitement.AdrEmail) = 0) THEN
  BEGIN
    traitement.descriptionIncident := 'l''adresse e-mail n''est pas valide';
    signalerIncident('Echec lors de l''envoi du rapport d''intégration au client :', traitement);
  END
  ELSE
  BEGIN
    TRY
      IdMessage := TIdMessage.Create(NIL);
      idSMTP := TIdSmtp.Create(NIL);
      IdSMTP.Host := 'smtp.fr.oleane.com';
      IdSmtp.Port := 25;
      IdSmtp.Username := from;
      IdSmtp.password := pswFrom;
      // signaler au client que tout s'est bien passé
      IdMessage.Clear;
      IdMessage.Body.Clear;
      IdMessage.From.Text := from;
      IdMessage.BccList.EMailAddresses := from;
      IF debug THEN
        IdMessage.Recipients.EMailAddresses := from
      ELSE
        IdMessage.Recipients.EMailAddresses := traitement.AdrEmail;
      IdMessage.Subject := 'Intégration automatique de commandes SPORT 2000 dans Ginkoia';
      tIdText(idMessage.MessageParts).ContentType := 'multipart/mixed';
      //créer le message
      ts := TStringList.Create;
      //charger le modèle
      ts.LoadFromFile(ExtractFilePath(traitement.rapportHtml) + 'MODELES\modeleIntegCmdSP2K.html');
      ts.text := StringReplace(ts.text, '~~INTEGRATION~~', unTraitement.resultat, [rfIgnoreCase]);
      txtpart := TIdText.Create(idMessage.MessageParts);
      txtpart.ContentType := 'text/html';
      txtpart.Body.Text := ts.Text;

      // Ajout en pièce jointe du rapport
      TIdAttachmentFile.Create(idMessage.MessageParts,ExtractFilePath(traitement.rapportHtml) + 'Rapport.html');

      // Gestion du logo
      logoAttachmentGinkoia := TIdAttachmentFile.Create(idMessage.MessageParts, ExtractFilePath(traitement.rapportHtml) + 'MODELES\logoGinkoia.png');
      logoAttachmentGinkoia.ContentType := 'image/png';
      logoAttachmentGinkoia.ContentDisposition := 'inline';
      logoAttachmentGinkoia.ExtraHeaders.Values['content-id'] := 'logoGinkoia.png';
      logoAttachmentGinkoia.DisplayName := 'logoGinkoia.png';
      IF NOT idsmtp.connected THEN
        IdSMTP.Connect();
      IdSMTP.Send(IdMessage);
    EXCEPT ON STAN: Exception DO
      BEGIN
        //Signaler le problème à l'envoi
        traitement.descriptionIncident := Stan.message;
        signalerIncident('Echec lors de l''envoi du rapport d''intégration au client :', traitement);
      END;
    END;
    IF idsmtp.connected THEN
      IdSMTP.Disconnect();
    txtpart.free;
    logoAttachmentGinkoia.free;
    idMessage.free;
    idSMTP.free;
  END;
END;

PROCEDURE signalerIncident(msg: STRING; traitement: TRecTraitement);
VAR
  rapportHtmlAttachment: TIdAttachmentFile;
BEGIN
  TRY
    IdMessage := TIdMessage.Create(NIL);
    idSMTP := TIdSmtp.Create(NIL);
    IdSMTP.Host := 'smtp.fr.oleane.com';
    IdSmtp.Port := 25;
    IdSmtp.Username := from;
    IdSmtp.password := pswFrom;
    //signale par e-mail que le programme à rencontré un problème
    IdMessage.Clear;
    IdMessage.Body.Clear;
    IdMessage.From.Text := from;
    IdMessage.Recipients.EMailAddresses := from;
    IdMessage.Subject := 'Notification Incident Intégration commandes Sport 2000';
    IdMessage.Body.Text := DateTimeToStr(now) + ' Incident de Traitement : ' + msg + ' ' + traitement.descriptionIncident;
    //joindre rapport html s'il existe
    IF FileExists(traitement.rapportHtml) THEN
    BEGIN
      rapportHtmlAttachment := TIdAttachmentFile.create(idMessage.MessageParts, traitement.rapportHtml);
      rapportHtmlAttachment.contentType := 'text';
      rapportHtmlAttachment.ContentDisposition := 'attachment';
    END;
    //description plus précise si les éléments sont renseignés
    IF traitement.CodeAdherent <> '' THEN
    BEGIN
      IdMessage.Body.Text := IdMessage.Body.Text + #13#10 + 'Code adhérent : ' + traitement.codeAdherent
        + #13#10 + 'Nom de dossier : ' + #09 + traitement.NomDossier
        + #13#10 + 'Nom du magasin : ' + #09 + traitement.NomMag
        + #13#10 + 'Ville : ' + #09 + traitement.Ville
        + #13#10 + 'Téléphone : ' + #09 + traitement.Telephone
        + #13#10 + 'Adresse E-mail : ' + #09 + traitement.AdrEmail;
    END;
    IdSMTP.Connect();
    IdSMTP.Send(IdMessage);
  EXCEPT
    EXIT;
  END;
  IF idsmtp.connected THEN
    IdSMTP.Disconnect();
//  IF rapportHtmlAttachment<>nil THEN
//    rapportHtmlAttachment.free;
  idMessage.free;
  idSMTP.free;
END;

PROCEDURE initTraitement(VAR traitement: TRecTraitement);
BEGIN
  //initialise à vide les enregistrements du traitement
  WITH traitement DO
  BEGIN
    CodeAdherent := '';
    NomDossier := '';
    NomMag := '';
    Ville := '';
    Telephone := '';
    AdrEmail := '';
    rapportHtml := '';
    descriptionIncident := '';
  END;
END;

END.

