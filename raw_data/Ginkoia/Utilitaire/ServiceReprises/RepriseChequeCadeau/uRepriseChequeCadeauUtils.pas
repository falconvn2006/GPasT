unit uRepriseChequeCadeauUtils;

interface

uses
  Data.DB,
  uRepriseChequeCadeauDBUtils, uwsGetEasy2Play, ulog;

type
  TRCCCanContinueEvent = procedure(Sender: TObject; var ACanContinue: Boolean) of object;

  TRepriseChequeCadeauUtils = class
  private
    FRCCDBUtils: TRepriseChequeCadeauDBUtils;
    FEasy2PlayUtils: TwsGetEasy2Play;
    FOnLog: TLogEvent;
    FOnCanContinue: TRCCCanContinueEvent;

    procedure CancelCKD(ACKT: TDataSet);
    procedure ForceCKD(ACKT: TDataSet; AMagId: integer);

    procedure AddLog(ALogMessage: string; ALogLevel: TLogLevel = logTrace; AMagId: integer = 0);
    function CanContinue: Boolean;
    procedure SetOnLog(const Value: TLogEvent);
  public
    constructor Create(ADataBaseFile: string);
    destructor Destroy;

    procedure closeConnection;

    procedure RecoverBaseCKDs;
    procedure RecoverMagCKDs(AMagId: integer);
    procedure RecoverCKT(ACKT: TDataSet; ABasCodeTiers: string; AMagId: integer);

    property OnLog: TLogEvent read FOnLog write SetOnLog;
    property OnCanContinue: TRCCCanContinueEvent read FOnCanContinue write FOnCanContinue;
  end;

implementation

uses
  System.SysUtils;

{ TRepriseChequeCadeauUtils }

procedure TRepriseChequeCadeauUtils.AddLog(ALogMessage: string; ALogLevel: TLogLevel; AMagId: Integer);
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

procedure TRepriseChequeCadeauUtils.CancelCKD(ACKT: TDataSet);
var
  wsAnnulTitre: TwsAnnulTitre;
  wsCallDateTime: TDateTime;
  vDoRetry: Boolean;
begin
  wsCallDateTime := Now();

  AddLog('appel à SetAnnulTitre');

  //TODO récupérer l'ID qui est dans l'enregistrement CKT d'appel
  if ACKT.FieldByName('CKTNUMTRANS').AsString = '' then
    FEasy2PlayUtils.ID := FRCCDBUtils.getNUMTRANS(ACKT.FieldByName('CKDID').AsInteger)
  else
    FEasy2PlayUtils.ID := ACKT.FieldByName('CKTNUMTRANS').AsString;
  wsAnnulTitre := FEasy2PlayUtils.SetAnnulTitre();

  if not wsAnnulTitre.Error then // annulation effectué
  begin
    //ajout d'un nouveau traitement dans "CKT"
    FRCCDBUtils.CreateCKT(wsctCancel, ACKT.FieldByName('CKDID').AsInteger,
      wsCallDateTime, ACKT.FieldByName('CKTNUMTRANS').AsString,
      wsAnnulTitre.CodeErreur, wsAnnulTitre.sMessage, 'Annulation par service de reprise', False);

    AddLog(Format('SetAnnulTitre réussi : %s', [wsAnnulTitre.sMessage]));
  end
  else
  begin
    case wsAnnulTitre.NumError of
      -7:
      begin
        // dans le cas de retour -7 (argument manquant), on essai au maximum 5 fois (donc à 4 essais déjà fait on ne fait plus de retry)
        if FRCCDBUtils.CountCKTTentative(ACKT.FieldByName('CKDID').AsInteger, -7) >= 4 then
          vDoRetry := False
        else
          vDoRetry := True;
      end;
      -5, -99:
      begin
        vDoRetry := True;
      end
      else
      begin
        vDoRetry := False;
      end;
    end;
    //ajout d'un nouveau traitement dans "CKT"
    FRCCDBUtils.CreateCKT(wsctCancel, ACKT.FieldByName('CKDID').AsInteger,
      wsCallDateTime, ACKT.FieldByName('CKTNUMTRANS').AsString,
      wsAnnulTitre.NumError, wsAnnulTitre.sMessage, 'Annulation par service de reprise', vDoRetry);

    AddLog(Format('Erreur %d : %s', [wsAnnulTitre.NumError, wsAnnulTitre.sMessage]));
  end;

  //Mise à jour du CKT_TRAITE dans la table "CKT"
  FRCCDBUtils.UpdateCKTTraite(ACKT.FieldByName('CKTID').AsInteger);
end;

function TRepriseChequeCadeauUtils.CanContinue: Boolean;
begin
  Result := True;
  if Assigned(FOnCanContinue) then
  begin
    FOnCanContinue(Self, Result);
  end;

  if not Result then
    AddLog('La reprise de chèques cadeaux à reçu l''ordre de s''arreter', logWarning);
end;

procedure TRepriseChequeCadeauUtils.closeConnection;
begin
  FRCCDBUtils.closeConnection;
end;

constructor TRepriseChequeCadeauUtils.Create(ADataBaseFile: string);
begin
  FRCCDBUtils := TRepriseChequeCadeauDBUtils.Create(ADataBaseFile);
  FEasy2PlayUtils := TwsGetEasy2Play.Create;
end;

destructor TRepriseChequeCadeauUtils.Destroy;
begin
  FreeAndNil(FRCCDBUtils);
  FreeAndNil(FEasy2PlayUtils);
end;

procedure TRepriseChequeCadeauUtils.ForceCKD(ACKT: TDataSet; AMagId: integer);
var
  wsDetail: TWSTitreDetail;
  wsCallDateTime: TDateTime;
begin
  wsCallDateTime := Now();

  AddLog('appel à SetTitreForce');

  FEasy2PlayUtils.DATETICKET := wsCallDateTime;
  FEasy2PlayUtils.CABTITRE := ACKT.FieldByName('CKDCB').AsString;
  wsDetail := FEasy2PlayUtils.SetTitreForce();

  if not wsDetail.Error then
  begin
    //ajout d'un nouveau traitement dans "CKT"
    FRCCDBUtils.CreateCKT(wsctForce, ACKT.FieldByName('CKDID').AsInteger,
      wsCallDateTime, wsDetail.ID, wsDetail.CodeErreur, wsDetail.sMessage, '', False);

    //Mise à jour du cheque cadeau avec les info retourné par le web service
    FRCCDBUtils.UpdateCKD(ACKT.FieldByName('CKDID').AsInteger, wsdetail.emetteur, wsDetail.titre, wsDetail.montant);

    //Modification CSHENCAISSEMENT (vérification si session ouvert faite dans "UpdateCSHEncaissement")
    FRCCDBUtils.UpdateCSHEncaissement(ACKT.FieldByName('CKDID').AsInteger,
      ACKT.FieldByName('ENCID').AsInteger, wsDetail.emetteur, AMagId);

    AddLog(Format('SetTitreForce réussi : Titre : %s | Emetteur : %s | Montant : %f',
      [wsdetail.titre, wsdetail.emetteur, wsDetail.montant]));
  end
  else
  begin
    case wsDetail.NumError of
      -5, -99:
      begin
      //ajout d'un nouveau traitement dans "CKT"
      FRCCDBUtils.CreateCKT(wsctForce, ACKT.FieldByName('CKDID').AsInteger,
        wsCallDateTime, wsDetail.ID, wsDetail.NumError, wsDetail.sMessage, '', True);

      AddLog(Format('Erreur %d : %s', [wsdetail.NumError, wsdetail.sMessage]));
      end
      else
      begin
        //ajout d'un nouveau traitement dans "CKT"
        FRCCDBUtils.CreateCKT(wsctForce, ACKT.FieldByName('CKDID').AsInteger,
          wsCallDateTime, wsDetail.ID, wsDetail.NumError, wsDetail.sMessage, '', False);

        AddLog(Format('Erreur %d : %s', [wsdetail.NumError, wsdetail.sMessage]));
      end;
    end;
  end;

  //Mise à jour du CKT_TRAITE dans la table "CKT"
  FRCCDBUtils.UpdateCKTTraite(ACKT.FieldByName('CKTID').AsInteger);
end;

procedure TRepriseChequeCadeauUtils.RecoverBaseCKDs;
var
  i: integer;
  count: integer;
  FMagasins: TMagasinArray;
begin

  AddLog('Récupération des magasins');
  FMagasins := FRCCDBUtils.ListMagasins;

  AddLog(Format('  %d magasins trouvé(s)', [Length(FMagasins)]));

  try
    for i := 0 to Length(FMagasins) - 1 do
    begin
      RecoverMagCKDs(FMagasins[i].FId);
      if not CanContinue then
        Break;

      //A la fin du traitement du magasin on regarde s'il reste des enregistrements
      // a traiter
      count := FRCCDBUtils.getDisconnectCKDQuery(FMagasins[i].FId).RecordCount;
      if Count > 0 then
        AddLog(IntToStr(count), logWarning, FMagasins[i].FId)
      else
        AddLog(IntToStr(count), logInfo, FMagasins[i].FId)
    end;
    except
      on E: Exception do
      begin
        AddLog(E.Message);
        Raise;
      end;
    end;
end;

procedure TRepriseChequeCadeauUtils.RecoverCKT(ACKT: TDataSet; ABasCodeTiers: string;
  AMagId: integer);
begin
  AddLog(Format('Traitement du CKT_ID : %d (CodeBarre : %s)',
    [ACKT.FieldByName('CKTID').AsInteger, ACKT.FieldByName('CKDCB').AsString]));

  //Mise à jour du NumTicket et CodeMagCaisse pour appel du ws
  FEasy2PlayUtils.NUMTICKET := ACKT.FieldByName('TKEID').AsString;
  FEasy2PlayUtils.MAGCAISSE := Format('%s|%s', [ABasCodeTiers, ACKT.FieldByName('POSNOM').AsString]);

  case ACKT.FieldByName('CKTTYPE').AsInteger of
    0: ForceCKD(ACKT, AMagId);
    1: CancelCKD(ACKT);
  end;
end;

procedure TRepriseChequeCadeauUtils.RecoverMagCKDs(AMagId: integer);
var
  i: integer;
  FCKTs: TDataSet;
begin
  AddLog(Format('Magasin : %d', [AMagId]));

  if not FRCCDBUtils.ModuleDematChequeCadeauEnabled(AMagId) then
  begin
    AddLog('Le module "DEMATCHEQUECADEAU" n''est pas activé');
  end
  else
  begin
    FEasy2PlayUtils.URL := FRCCDBUtils.getURL(AMagId);
    FEasy2PlayUtils.GUID := FRCCDBUtils.getGUID(AMagId);

    AddLog(Format('  - url : %s', [FEasy2PlayUtils.URL]));
    AddLog(Format('  - guid : %s', [FEasy2PlayUtils.GUID]));

    if FEasy2PlayUtils.GetStatusWS.status <> 1 then
    begin
      AddLog('Le serveur Easy2Play ne répond pas', logWarning);
    end
    else
    begin
      FCKTs := FRCCDBUtils.getDisconnectCKDQuery(AMagId);
      AddLog(Format('Nombres d''enregistrements à traiter : %d', [FCKTs.RecordCount]));

      while not FCKTs.Eof do
      begin
        RecoverCKT(FCKTs, FRCCDBUtils.getGenBaseBasCodeTiersValue(AMagId), AMagId);
        FCKTs.Next;
        if not CanContinue then
          Break;
      end;
    end;
  end;
end;

procedure TRepriseChequeCadeauUtils.SetOnLog(const Value: TLogEvent);
begin
  FOnLog := Value;
  if Assigned(FRCCDBUtils) then
    FRCCDBUtils.onlog := FOnLog;
end;

end.
