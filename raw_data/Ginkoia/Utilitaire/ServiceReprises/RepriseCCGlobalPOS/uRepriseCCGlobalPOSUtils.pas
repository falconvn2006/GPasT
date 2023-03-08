unit uRepriseCCGlobalPOSUtils;

interface

uses
  Data.DB,
  uRepriseCCGlobalPOSDBUtils, WSCartesCadeauxGlobalPOS, ulog, System.Classes,
  IdSMTP, IdExplicitTLSClientServerBase, IdSSLOpenSSL, IdMessage, uRepriseCCGlobalPOSUtils_RS;

type
  TRCCCanContinueEvent = procedure(Sender: TObject; var ACanContinue: Boolean) of object;

  TRepriseCCGlobalPOSUtils = class
  private
    FRCCDBUtils: TRepriseCCGlobalPOSDBUtils;
    FwsGlobalPOS: TwsGetGlobalPOS;
    FOnLog: TLogEvent;
    FOnCanContinue: TRCCCanContinueEvent;

    procedure CancelCKD(ACKDO: TDataSet; AMagId: Integer);

    procedure AddLog(ALogMessage: string; ALogLevel: TLogLevel = logTrace; AMagId: integer = 0);
    function CanContinue: Boolean;
    procedure SetOnLog(const Value: TLogEvent);
    procedure SendMail(aMessage: string; AMagId: Integer);
    procedure MailFailedCKDO(ACKDO: TDataSet; AMagId: integer);
    procedure MailCKDOKO(ACKDO: TDataSet; AMagId: integer);
  public
    constructor Create(ADataBaseFile: string);
    destructor Destroy;

    procedure closeConnection;

    procedure RecoverBaseCKDOs;
    procedure RecoverMagCKDOs(AMagId: integer);
    procedure RecoverCKDO(ACKDO: TDataSet; ABasCodeTiers: string; AMagId: integer);

    property OnLog: TLogEvent read FOnLog write SetOnLog;
    property OnCanContinue: TRCCCanContinueEvent read FOnCanContinue write FOnCanContinue;
  end;

implementation

uses
  System.SysUtils;

{ TRepriseCCGlobalPOSUtils }

procedure TRepriseCCGlobalPOSUtils.AddLog(ALogMessage: string; ALogLevel: TLogLevel; AMagId: Integer);
var
  tmplog: TLogItem;
begin
  if Assigned(FOnLog) then
  begin
    tmplog.key := 'Status';
    tmplog.mag := '';
    tmplog.val := ALogMessage;
    tmplog.lvl := ALogLevel;
    if AMagId <> 0 then
    begin
      tmplog.key := 'nbWaiting';
      tmplog.mag := IntToStr(AMagId);
    end;
    FOnLog(self, tmplog);
  end;
end;

procedure TRepriseCCGlobalPOSUtils.CancelCKD(ACKDO: TDataSet; AMagId: integer);
var
  //wsAnnulTitre: TwsAnnulTitre;
  ACardDetail: TwsCardDetail;
  NewCKDO: TDataSet;
  vMessage: String;
begin

  AddLog('appel à SetOperationCarteCadeau', logInfo);

  // on met à jour la ligne courante avec appelws à 100 et on insère un nouvelle ligne pour le nouvel appel
  FRCCDBUtils.UpdateCKDO(ACKDO.FieldByName('KDO_ID').AsInteger, 100);

  // appel au webservice
  ACardDetail := FwsGlobalPOS.SetOperationCarteCadeau(GPAnnulation);

   if FwsGlobalPOS.GetStatusWS.status <> 1 then
   begin
     // si le webservice ne répond pas on créé la nouvelle ligne avec le code erreur -999
     FRCCDBUtils.CreateCKDO(ACKDO, -999);
     AddLog('Le serveur GlobalPOS ne répond pas', logWarning);
   end
   else
     // création de la nouvelle ligne avec les infos de l'ancienne, et le retour du WS
     FRCCDBUtils.CreateCKDO(ACKDO, ACardDetail.CodeRetour);

  if not ACardDetail.Error then // annulation effectué
    AddLog(Format('SetOperationCarteCadeau réussi : %s', [ACardDetail.sMessage]))
  else
  begin
    AddLog(Format('Erreur %d : %s', [ACardDetail.CodeRetour, ACardDetail.sMessage]), logError);

    // en cas d'erreur alors que le WS à répondu, on envoi un mail
    if ACardDetail.CodeRetour <> -999 then
    begin
      vMessage := Format(RS_RepriseAvecErreur, [ACKDO.FieldByName('KDO_NUMCARTE').AsString, IntToStr(ACardDetail.CodeRetour), ACardDetail.sMessage, ACKDO.FieldByName('MAG_ENSEIGNE').AsString, ACKDO.FieldByName('SES_NUMERO').AsString, ACKDO.FieldByName('TKE_SEQUENCE').AsString]);

      SendMail(vMessage, AMagId);
    end;
  end;
end;

procedure TRepriseCCGlobalPOSUtils.SendMail(aMessage: string; AMagId: Integer);
var
  vEmails: string;
  SMTP: TIdSMTP;
  IOHandler : TIdSSLIOHandlerSocketOpenSSL;
  idMsgSend: TIdMessage;
begin
  // on vérifie si le mail de contact est renseigné en base.
  vEmails := Trim(FRCCDBUtils.getGenParamValueString(13,26, AMagId));

  if vEmails = '' then
  begin
    // on sort et on log
    AddLog('Pas d''email renseigné pour l''envoi des erreurs de reprise (GENPARAM 13/26)', logError);
    Exit
  end;

  SMTP := TIdSMTP.Create();
  idMsgSend := TIdMessage.Create();
  Try
    SMTP.Host := 'pod51015.outlook.com';
    SMTP.Port := 587;
    SMTP.AuthType := satDefault;
    SMTP.Username := 'dev@ginkoia.fr';
    SMTP.Password := 'Toru682674';

    IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
    IOHandler.Destination := SMTP.Host + ':' + IntToStr(SMTP.Port);
    IOHandler.Host := SMTP.Host;
    IOHandler.Port := SMTP.Port;
    IOHandler.SSLOptions.Method := sslvTLSv1_2;

    SMTP.IOHandler := IOHandler;
    SMTP.UseTLS := utUseExplicitTLS;

    idMsgSend.Clear;
    idMsgSend.Body.Clear;
    //idMsgSend.From.Text := 'no-reply@ginkoia.fr';
    idMsgSend.From.Text := 'dev@ginkoia.fr';
    idMsgSend.Recipients.EMailAddresses := vEmails;
    idMsgSend.Subject := RS_EmailSubject;

    idMsgSend.Body.Add(aMessage);

    try
      SMTP.Connect();
    except
      on e: Exception do
      begin
        AddLog('Erreur de connection au serveur de messagerie, nouvelle tentative sur le port 25 : ' + E.Message, logError);

        SMTP.Port := 25;
        if Assigned(IOHandler) then
        begin
          IOHandler.Destination := SMTP.Host + ':25';
          IOHandler.Port := 25;
        end;

        TRY
          SMTP.Connect();
        EXCEPT
          on e : Exception do
          begin
            AddLog('Erreur de connection au serveur de messagerie sur le port 25 : ' + E.Message, logError);
            EXIT;
          end;
        END;
      end;
    end;

    TRY
      // === Tout est OK ===
      SMTP.Send(idMsgSend);
      //LogAction('Message envoyé à : ' + idMsgSend.Recipients.EMailAddresses, 2);
      AddLog('Message envoyé à : ' + idMsgSend.Recipients.EMailAddresses, logInfo);
    EXCEPT
      ON E: Exception DO
      BEGIN
        // === Ne devrait normalement pas se produire ===
        AddLog('Erreur lors de l''envoi de l''email : ' + E.Message, logError);

        SMTP.Disconnect();
        EXIT;
      END;
    END;

    SMTP.Disconnect();

  Finally
    SMTP.Free;
    idMsgSend.Free;
  End;

end;

procedure TRepriseCCGlobalPOSUtils.MailFailedCKDO(ACKDO: TDataSet; AMagId: integer);
var
  vMessage: String;
begin
  AddLog(Format('Envoi du mail pour le du KDO_ID : %d (CodeBarre : %s)', [ACKDO.FieldByName('KDO_ID').AsInteger, ACKDO.FieldByName('KDO_NUMCARTE').AsString]), logInfo);

  vMessage := Format(RS_RepriseEchec, [ACKDO.FieldByName('KDO_NUMCARTE').AsString, ACKDO.FieldByName('MAG_ENSEIGNE').AsString, ACKDO.FieldByName('SES_NUMERO').AsString, ACKDO.FieldByName('TKE_SEQUENCE').AsString]);

  SendMail(vMessage, AMagId);
end;

procedure TRepriseCCGlobalPOSUtils.MailCKDOKO(ACKDO: TDataSet; AMagId: integer);
var
  vMessage: String;
  MAGID: Integer;
begin
  AddLog(Format('Envoi du mail pour le du KDO_ID : %d (CodeBarre : %s)', [ACKDO.FieldByName('KDO_ID').AsInteger, ACKDO.FieldByName('KDO_NUMCARTE').AsString]), logInfo);

  vMessage := Format(RS_RepriseKO, [ACKDO.FieldByName('KDO_NUMCARTE').AsString]);

  SendMail(vMessage, AMagId);
end;

function TRepriseCCGlobalPOSUtils.CanContinue: Boolean;
begin
  Result := True;
  if Assigned(FOnCanContinue) then
  begin
    FOnCanContinue(Self, Result);
  end;

  if not Result then
    AddLog('La reprise de cartes cadeaux Global POS à reçu l''ordre de s''arreter', logWarning);
end;

procedure TRepriseCCGlobalPOSUtils.closeConnection;
begin
  FRCCDBUtils.closeConnection;
end;

constructor TRepriseCCGlobalPOSUtils.Create(ADataBaseFile: string);
begin
  FRCCDBUtils := TRepriseCCGlobalPOSDBUtils.Create(ADataBaseFile);
  FwsGlobalPOS := TwsGetGlobalPOS.Create;
  FwsGlobalPOS.CHEMINLOG := ExtractFilePath(ParamStr(0));
end;

destructor TRepriseCCGlobalPOSUtils.Destroy;
begin
  FreeAndNil(FRCCDBUtils);
  FreeAndNil(FwsGlobalPOS);
end;


procedure TRepriseCCGlobalPOSUtils.RecoverBaseCKDOs;
var
  i: integer;
  count: integer;
  FMagasins: TMagasinArray;
begin

  AddLog('Récupération des magasins');
  FMagasins := FRCCDBUtils.ListMagasins;

  AddLog(Format('  %d magasins trouvé(s)', [Length(FMagasins)]));

  try
    // on traite d'abord toutes les cartes cadeaux qui ont un tke_id qui ne correspond à rien (par ex plantage de caisse)
    FRCCDBUtils.UpdateCKDOWithoutTicket();

    for i := 0 to Length(FMagasins) - 1 do
    begin
      RecoverMagCKDOs(FMagasins[i].FId);
      if not CanContinue then
        Break;

      //A la fin du traitement du magasin on regarde s'il reste des enregistrements
      // a traiter
      count := FRCCDBUtils.getDisconnectCKDOQuery(FMagasins[i].FId).RecordCount;
      if Count > 0 then
        AddLog('Lignes restantes à traiter pour le magasin ' + FMagasins[i].FName + ' : ' + IntToStr(count), logWarning, FMagasins[i].FId)
      else
        AddLog('Lignes restantes à traiter pour le magasin ' + FMagasins[i].FName + ' : ' + IntToStr(count), logInfo, FMagasins[i].FId)
    end;
  except
    on E: Exception do
    begin
      AddLog('erreur lors du traitement : ' + E.Message, logError);
      Raise;
    end;
  end;
end;

procedure TRepriseCCGlobalPOSUtils.RecoverCKDO(ACKDO: TDataSet; ABasCodeTiers: string;
  AMagId: integer);
var
  vType: String;
begin
  AddLog(Format('Traitement du KDO_ID : %d (CodeBarre : %s)', [ACKDO.FieldByName('KDO_ID').AsInteger, ACKDO.FieldByName('KDO_NUMCARTE').AsString]), logInfo);

  //Mise à jour des infos  pour appel du ws
  FwsGlobalPOS.NUMTICKET := ACKDO.FieldByName('KDO_TKEID').AsString;
  FwsGlobalPOS.MAGCAISSE := Format('%s|%s', [ABasCodeTiers, ACKDO.FieldByName('POS_NOM').AsString]);
  FwsGlobalPOS.DATETICKET := ACKDO.FieldByName('KDO_DATE').AsDateTime;
  FwsGlobalPOS.NUMCARTE := ACKDO.FieldByName('KDO_NUMCARTE').AsString;
  FwsGlobalPOS.ID := ACKDO.FieldByName('KDO_NUMTRANS').AsString;;
  FwsGlobalPOS.MONTANT := Round(ACKDO.FieldByName('KDO_MONTANT').AsFloat * 100);

  vType := ACKDO.FieldByName('KDO_TYPE').AsString;

  CancelCKD(ACKDO, AMagId);
end;

procedure TRepriseCCGlobalPOSUtils.RecoverMagCKDOs(AMagId: integer);
var
  i: integer;
  FCKDOs, FKDOsFAIL, FKDOsKO: TDataSet;
begin
  AddLog(Format('Magasin : %d', [AMagId]));

  if not FRCCDBUtils.ModuleCCGlobalPOSEnabled(AMagId) then
  begin
    AddLog('Le module "CARTECADEAU_GLOBALPOS" n''est pas activé');
  end
  else
  begin
    FwsGlobalPOS.URL := FRCCDBUtils.getURL(AMagId);
    FwsGlobalPOS.GUID := FRCCDBUtils.getGUID(AMagId);

    AddLog(Format('  - url : %s', [FwsGlobalPOS.URL]));
    AddLog(Format('  - guid : %s', [FwsGlobalPOS.GUID]));


    // traitement des cartes à reprendre
    FCKDOs := FRCCDBUtils.getDisconnectCKDOQuery(AMagId);
    AddLog(Format('Nombres d''enregistrements à traiter : %d', [FCKDOs.RecordCount]), logInfo);
    while not FCKDOs.Eof do
    begin
      RecoverCKDO(FCKDOs, FRCCDBUtils.getGenBaseBasCodeTiersValue(AMagId), AMagId);
      FCKDOs.Next;
      if not CanContinue then
        Break;
    end;

    // traitement des mails à envoyer pour les cartes qui n'ont pas pu être reprises
    FKDOsFAIL := FRCCDBUtils.getDisconnectCKDOQuery(AMagId, True);
    AddLog(Format('Nombres de mails d''erreurs à envoyer : %d', [FKDOsFAIL.RecordCount]), logInfo);
    while not FKDOsFAIL.Eof do
    begin
      MailFailedCKDO(FKDOsFAIL, AMagId);

      FKDOsFAIL.Next;
      if not CanContinue then
        Break;
    end;

    // traitement des mails à envoyer pour les cartes qui ne peuvent être reprises car pas liées à un ticket
    FKDOsKO := FRCCDBUtils.getCKDOKO();
    AddLog(Format('Nombres de mails d''erreurs à envoyer pour les cartes non liées à un ticket : %d', [FKDOsKO.RecordCount]), logInfo);
    while not FKDOsKO.Eof do
    begin
      MailCKDOKO(FKDOsKO, AMagId);

      FKDOsKO.Next;
      if not CanContinue then
        Break;
    end;

  end;
end;

procedure TRepriseCCGlobalPOSUtils.SetOnLog(const Value: TLogEvent);
begin
  FOnLog := Value;
  if Assigned(FRCCDBUtils) then
    FRCCDBUtils.onlog := FOnLog;
end;

end.
