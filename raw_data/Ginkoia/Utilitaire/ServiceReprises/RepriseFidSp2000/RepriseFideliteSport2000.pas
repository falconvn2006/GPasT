unit RepriseFideliteSport2000;

interface

uses
  System.Classes, System.SysUtils, Data.DB, FireDAC.Stan.Param, System.Math, System.StrUtils, System.DateUtils,
  uLogs, uLog, uGestionBDD, Fidelite_Dm, Fidelite_Dm_RS;

const
  NB_LG_PAR_TRANSAC = 60;
  CST_LOCAL_ERROR = 'LOCAL_ERROR';

type
  TRepriseFideliteSport2000 = class(TThread)
  private
    FLogs: TLogs;
    FDelai: Integer;      // Délai en minutes.
    FTentatives: Integer;      // Nombre de tentatives en cas d'échec
    FFichierIB: String;
    FFideliteSport2000: TDm_Fidelite;

    procedure InitLogs;
    procedure AddLog(const sLogMessage: String; const ALogLevel: TLogLevel = logTrace; const aLogKey: String = ''); overload;
    procedure AddLog(ALogItem: TLogItem); overload;
    procedure RafraichirLogFileName;
    function GetConnection: TMyConnection;
    procedure InitParametres;
    procedure Traitement;
    procedure RepriseFideliteMagasin(Cnx: TMyConnection; QueryLigne, QueryMaj: TMyQuery; const nIDMagasin: Integer);
    procedure MajRepriseFidelite(QueryMaj: TMyQuery; const nID: Integer; const bRetour: Boolean; const sReponse: String);
  protected
    procedure Execute; override;
    procedure RepriseFideliteSport2000Log(Sender: TObject; ALogItem: TLogItem);

  public
    constructor Create(const sFichierIB: String);   overload;
    function CanExecute: Boolean;
    destructor Destroy;   override;
  end;

implementation

{ TRepriseFideliteSport2000 }

constructor TRepriseFideliteSport2000.Create(const sFichierIB: String);
begin
  FFichierIB := sFichierIB;
  FDelai := (30 * 60);
  FTentatives := 1;

  InitLogs;
  InitParametres;

  inherited Create(True);
  FreeOnTerminate := False;
end;

procedure TRepriseFideliteSport2000.InitLogs;
var
  sChemin: String;
begin
  sChemin := ExtractFilePath(ParamStr(0)) + '\logs\';
  if not DirectoryExists(sChemin) then
    ForceDirectories(sChemin);

  FLogs := TLogs.Create;
  FLogs.Path := sChemin;
  RafraichirLogFileName;
end;

procedure TRepriseFideliteSport2000.AddLog(const sLogMessage: String; const ALogLevel: TLogLevel = logTrace; const aLogKey: String = '');
var
  LogTmp: TLogItem;
begin
  if aLogKey <> '' then
    LogTmp.key := aLogKey
  else
    LogTmp.Key := 'Status';
  LogTmp.Mag := '';
  LogTmp.Val := ShortString(sLogMessage);
  LogTmp.Lvl := ALogLevel;

  AddLog(LogTmp);
end;

procedure TRepriseFideliteSport2000.AddLog(ALogItem: TLogItem);
begin
  Log.Log('FIDSPORT2000', Log.Ref, String(ALogItem.Mag), String(ALogItem.Key), String(ALogItem.Val), ALogItem.Lvl, True, FDelai * 2 + 10);
  FLogs.AddToLogs(String(ALogItem.Val));
end;

procedure TRepriseFideliteSport2000.RepriseFideliteSport2000Log(Sender: TObject; ALogItem: TLogItem);
begin
  AddLog(ALogItem);
end;

procedure TRepriseFideliteSport2000.RafraichirLogFileName;
var
  sDate: String;
begin
  DateTimeToString(sDate, 'yyyymmdd', Now);
  FLogs.FileName := Format('reprisefideliteSport2000logs_%s.txt', [sDate]);
end;

function TRepriseFideliteSport2000.CanExecute: Boolean;
var
  Cnx: TMyConnection;
  Query: TMyQuery;
begin
  Result := False;
  Cnx := GetConnection;
  Query := GetNewQuery(Cnx);
  try
    // Nombre de magasins.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select count(*)');
    Query.SQL.Add('from GENMAGASIN');
    Query.SQL.Add('join K on (K_ID = MAG_ID and K_ENABLED = 1)');
    Query.SQL.Add('where MAG_ID <> 0');
    Query.SQL.Add('and exists (select UGM_MAGID');
    Query.SQL.Add('            from UILGRPGINKOIAMAG');
    Query.SQL.Add('            join K on (K_ID = UGM_ID and K_ENABLED = 1)');
    Query.SQL.Add('            join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
    Query.SQL.Add('            where UGG_NOM = ''SPORT 2000'')');
    Query.SQL.Add('and exists (select UGM_MAGID');
    Query.SQL.Add('            from UILGRPGINKOIAMAG');
    Query.SQL.Add('            join K on (K_ID = UGM_ID and K_ENABLED = 1)');
    Query.SQL.Add('            join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
    Query.SQL.Add('            where UGG_NOM = ''FIDELITE SPORT2000'')');
    try
      Query.Open;
    except
      on E: Exception do
      begin
        AddLog('Erreur :  la recherche du nombre de magasins a échoué !' + #13#10 + E.Message, logError);
        Exit;
      end;
    end;

    Result := (Query.Fields[0].AsInteger > 0);
  finally
    FreeAndNil(Query);
    FreeAndNil(Cnx);
  end;
end;

function TRepriseFideliteSport2000.GetConnection: TMyConnection;
begin
  // Connexion.
  try
    Result := GetNewConnexion(FFichierIB, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, False);
    Result.Open;
  except
    on E: Exception do
    begin
      AddLog('Impossible de se connecter à la base [' + FFichierIB + '].');
      AddLog(E.Message);
      raise;
    end;
  end;
end;

procedure TRepriseFideliteSport2000.InitParametres;
var
  Cnx: TMyConnection;
  Query: TMyQuery;
  nMagID: Integer;
begin
  Cnx := GetConnection;
  Query := GetNewQuery(Cnx);
  try
    // Recherche du BAS_MAGID.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select BAS_MAGID');
    Query.SQL.Add('from GENBASES');
    Query.SQL.Add('join K on (K_ID = BAS_ID and K_ENABLED = 1)');
    Query.SQL.Add('where BAS_IDENT = (select PAR_STRING from GENPARAMBASE where PAR_NOM = ''IDGENERATEUR'')');
    try
      Query.Open;
    except
      on E: Exception do
      begin
        AddLog('Erreur :  la recherche du BAS_MAGID a échoué !' + #13#10 + E.Message, logError);
        Exit;
      end;
    end;
    if Query.IsEmpty then
      AddLog('Erreur :  pas de BAS_MAGID trouvé !', logError)
    else
    begin
      nMagID := Query.FieldByName('BAS_MAGID').AsInteger;

      // Recherche du délai.
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('select PRM_INTEGER');
      Query.SQL.Add('from GENPARAM');
      Query.SQL.Add('join K on (K_ID = PRM_ID and K_ENABLED = 1)');
      Query.SQL.Add('where PRM_TYPE = 0');
      Query.SQL.Add('and PRM_CODE = 50009');
      Query.SQL.Add('and PRM_MAGID = :MAGID');
      try
        Query.ParamByName('MAGID').AsInteger := nMagID;
        Query.Open;
      except
        on E: Exception do
        begin
          AddLog('Erreur :  la recherche du délai a échoué !' + #13#10 + E.Message, logError);
          Exit;
        end;
      end;
      if not Query.IsEmpty then
        FDelai := (Query.FieldByName('PRM_INTEGER').AsInteger * 60);

      // Recherche du nombre de tentatives.
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('select PRM_INTEGER');
      Query.SQL.Add('from GENPARAM');
      Query.SQL.Add('join K on (K_ID = PRM_ID and K_ENABLED = 1)');
      Query.SQL.Add('where PRM_TYPE = 0');
      Query.SQL.Add('and PRM_CODE = 50008');
      Query.SQL.Add('and PRM_MAGID = :MAGID');
      try
        Query.ParamByName('MAGID').AsInteger := nMagID;
        Query.Open;
      except
        on E: Exception do
        begin
          AddLog('Erreur :  la recherche du nombre de tentatives a échoué !' + #13#10 + E.Message, logError);
          Exit;
        end;
      end;
      if not Query.IsEmpty then
        FTentatives := (Query.FieldByName('PRM_INTEGER').AsInteger);
    end;
  finally
    Query.DisposeOf;
    Cnx.DisposeOf;
  end;
end;

procedure TRepriseFideliteSport2000.Execute;
var
  nCount: Integer;
begin
  nCount := FDelai;
  AddLog(Format('Démarrage du service "Reprise fidélité Sport 2000" (délai %d minutes)', [FDelai div 60]));
  AddLog('"Reprise fidélité Sport 2000" démarrée', logInfo);
  while not Terminated do
  begin
    try
      Inc(nCount);
      if nCount >= FDelai then
      begin
        nCount := 0;
        RafraichirLogFileName;
        Traitement;

        InitParametres;
      end;

      Sleep(1000);
    except
      on E: Exception do
      begin
        AddLog(Format('Erreur :  %s', [E.Message]), logError);
      end;
    end;
  end;

  AddLog('Arrêt du service "Reprise fidélité Sport 2000"');
  AddLog('Arrêté', logInfo);
end;

procedure TRepriseFideliteSport2000.Traitement;
var
  Cnx: TMyConnection;
  QueryMagasin, QueryLigne, QueryMaj: TMyQuery;
begin
  Cnx := GetConnection;
  QueryMagasin := GetNewQuery(Cnx);
  QueryLigne := GetNewQuery(Cnx);
  QueryMaj := GetNewQuery(Cnx);
  try
    // Recherche des magasins.
    QueryMagasin.Close;
    QueryMagasin.SQL.Clear;
    QueryMagasin.SQL.Add('select MAG_ID');
    QueryMagasin.SQL.Add('from GENMAGASIN');
    QueryMagasin.SQL.Add('join K on (K_ID = MAG_ID and K_ENABLED = 1)');
    QueryMagasin.SQL.Add('join GENBASES on (GENBASES.BAS_ID = GENMAGASIN.MAG_BASID) ');
    QueryMagasin.SQL.Add('join GENPARAMBASE on (GENPARAMBASE.PAR_STRING = GENBASES.BAS_IDENT and GENPARAMBASE.PAR_NOM = ''IDGENERATEUR'')');
    QueryMagasin.SQL.Add('where MAG_ID <> 0');
    QueryMagasin.SQL.Add('and exists (select UGM_MAGID');
    QueryMagasin.SQL.Add('            from UILGRPGINKOIAMAG');
    QueryMagasin.SQL.Add('            join K on (K_ID = UGM_ID and K_ENABLED = 1)');
    QueryMagasin.SQL.Add('            join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
    QueryMagasin.SQL.Add('            where UGG_NOM = ''SPORT 2000'')');
    QueryMagasin.SQL.Add('and exists (select UGM_MAGID');
    QueryMagasin.SQL.Add('            from UILGRPGINKOIAMAG');
    QueryMagasin.SQL.Add('            join K on (K_ID = UGM_ID and K_ENABLED = 1)');
    QueryMagasin.SQL.Add('            join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
    QueryMagasin.SQL.Add('            where UGG_NOM = ''FIDELITE SPORT2000'')');
    try
      QueryMagasin.Open;
    except
      on E: Exception do
      begin
        AddLog('Erreur :  la recherche des magasins a échoué !' + #13#10 + E.Message, logError);
        Exit;
      end;
    end;
    if not QueryMagasin.IsEmpty then
    begin
      QueryMagasin.First;
      while not QueryMagasin.Eof do
      begin
        if Terminated then
          Break;

        // reprise de la fidélité
        RepriseFideliteMagasin(Cnx, QueryLigne, QueryMaj, QueryMagasin.FieldByName('MAG_ID').AsInteger);

        QueryMagasin.Next;
      end;
    end;
  finally
    QueryMaj.DisposeOf;
    QueryLigne.DisposeOf;
    QueryMagasin.DisposeOf;
    Cnx.DisposeOf;
  end;
end;

procedure TRepriseFideliteSport2000.RepriseFideliteMagasin(Cnx: TMyConnection; QueryLigne, QueryMaj: TMyQuery; const nIDMagasin: Integer);
var
  nNb: Integer;
  ResWS: TResFunc;
  vTentatives: Integer;
  vActionName, vActionInfo, vLogKey, vErrorInfo: String;
  isRetour: Boolean;
  vIdKey, vIdOptin, vCodeMagasin: string; // paramètre pour lineup7 à passer en envoi
  SplitParam: TArray<string>;
  i: Integer;
begin
  // Recherche des actions clients
  QueryLigne.Close;
  QueryLigne.SQL.Clear;
  QueryLigne.SQL.Add('SELECT FIR_ID, FIR_CLTID, FIR_TYPE, FIR_TKEID, FIR_REQUETE');
  QueryLigne.SQL.Add('FROM FIDREPRISE');
  QueryLigne.SQL.Add('JOIN K ON (K_ID = FIR_ID AND K_ENABLED = 1)');
  QueryLigne.SQL.Add('WHERE FIR_ENVOYE = 0');
  QueryLigne.SQL.Add('AND FIR_MAGID = :MAGID');
  QueryLigne.SQL.Add('AND FIR_TYPE IN (0,1,2,3)'); // fir_type  : 0 tickets 1 création client 2 modif client 3 anonymisation client
  QueryLigne.SQL.Add('ORDER BY FIR_DATE');
  try
    QueryLigne.ParamByName('MAGID').AsInteger := nIDMagasin;
    QueryLigne.Open;
  except
    on E: Exception do
    begin
      AddLog('Erreur :  la recherche des lignes de reprise du magasin ' + IntToStr(nIDMagasin) + ' a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;

  if not QueryLigne.IsEmpty then
  begin
    nNb := 0;
    vTentatives := 1;

    Cnx.StartTransaction;
    FFideliteSport2000 := TDm_Fidelite.GetNewFideliteDM(nil, Cnx, nIDMagasin, etc_Batch);
    try
      QueryLigne.First;
      while not QueryLigne.Eof do
      begin
        if Terminated then
          Break;

        ResWS := nil;
        vIdKey := '';
        vIdOptin := ''; // paramètre pour lineup7 à passer en envoi dans le cas des clients

        SplitParam := QueryLigne.FieldByName('FIR_REQUETE').AsString.Split(['|']);

        for i := 0 to Length(SplitParam) - 1 do
        begin
          case i  of
            0:
             vIdKey := SplitParam[i];
            1:
             vIdOptin := SplitParam[i];
            2:
              vCodeMagasin := SplitParam[i];
          end;
        end;


        // en fonction du type on fait un appel différent
        case QueryLigne.FieldByName('FIR_TYPE').AsInteger of
          0: // envoi ticket
          begin
            vActionName := 'Envoi ticket';
            vActionInfo := 'le ticket ' + QueryLigne.FieldByName('FIR_TKEID').AsString;
            vErrorInfo := 'Error_ticket_envoi_';
            try
              ResWS := FFideliteSport2000.SendTicket(QueryLigne.FieldByName('FIR_TKEID').AsInteger, vIdKey);
            except
              on E: Exception do
              begin
                AddLog('Erreur : la reprise du ticket ' + QueryLigne.FieldByName('FIR_TKEID').AsString + ' a échoué !' + #13#10 + E.Message, logError);
              end;
            end;
          end;
          // Création client
          1:
          begin
            vActionName := 'création client';
            vActionInfo := 'le client ' + QueryLigne.FieldByName('FIR_CLTID').AsString;
            vErrorInfo := 'Error_client_create_';
            try
              ResWS := FFideliteSport2000.CreateClient(QueryLigne.FieldByName('FIR_CLTID').AsInteger);
            except
              on E: Exception do
              begin
                AddLog('Erreur :  la création du client ' + QueryLigne.FieldByName('FIR_CLTID').AsString + ' a échoué !' + #13#10 + E.Message, logError);
              end;
            end;
          end;
          // modification client
          2:
          begin
            vActionName := 'modification client';
            vActionInfo := 'le client ' + QueryLigne.FieldByName('FIR_CLTID').AsString;
            vErrorInfo := 'Error_client_update_';
            try
              ResWS := FFideliteSport2000.UpdateCLient(QueryLigne.FieldByName('FIR_CLTID').AsInteger, vIdKey, vIdOptin, vCodeMagasin);
            except
              on E: Exception do
              begin
                AddLog('Erreur :  la modification du client ' + QueryLigne.FieldByName('FIR_CLTID').AsString + ' a échoué !' + #13#10 + E.Message, logError);
              end;
            end;
          end;
          // anonymisation client
          3:
          begin
            vActionName := 'anonymisation client';
            vActionInfo := 'le client ' + QueryLigne.FieldByName('FIR_CLTID').AsString;
            vErrorInfo := 'Error_client_anonymise_';
            try
              ResWS := FFideliteSport2000.AnonymiseClient(QueryLigne.FieldByName('FIR_CLTID').AsInteger, vIdKey);
            except
              on E: Exception do
              begin
                AddLog('Erreur : l''anonymisation du client ' + QueryLigne.FieldByName('FIR_CLTID').AsString + ' a échoué !' + #13#10 + E.Message, logError);
              end;
            end;
          end;
        end;

        // Si pas d'erreur on met à jour la ligne, sinon on tente jusque au nombre définit
        // dans le paramétrage avec une pause de 10sec entre chaque
        if ResWS.ErrorCode <= CST_NOERROR then
        begin
          Inc(nNb);
          MajRepriseFidelite(QueryMaj, QueryLigne.FieldByName('FIR_ID').AsInteger, True, ResWS.ErrorMessage);      // Maj ligne.
          QueryLigne.Next;
          vTentatives := 0;
        end
        else
        begin
          // si on a atteint le nombre de tentatives, ou que le webservice ne peut traiter la ligne, on passe à l'enregistrement suivant
          if (vTentatives >= FTentatives) or (ResWS.ErrorCode IN [CST_ERROR_WEBSERVICE_NONE, CST_ERROR_NOTICKET, CST_ERROR_NOCLIENT]) then
          begin
            isRetour := False;
            vLogKey := '';

            // si le webservice à répondu avec une erreur de données (la ligne ne sera jamais traitée), on met le retour à true pour ne plus traiter la ligne en base
            // dans ce cas on fait un log spécifique car le retour doit être analysé manuellement
            if ResWS.ErrorCode IN [CST_ERROR_WEBSERVICE_NONE, CST_ERROR_NOTICKET, CST_ERROR_NOCLIENT] then
            begin
              isRetour := True;
              vLogKey := vErrorInfo + '_' + QueryLigne.FieldByName('FIR_ID').AsString;
            end;

            AddLog('Erreur : l''appel du webservice pour ' + vActionInfo + ' a échoué ' +
            IntToStr(vTentatives) + ' fois, le webservice à renvoyé "' + ResWS.ErrorMessage + '" pour l''action "' + vActionName + '"' +
            #13#10 + 'Impossible de mettre à jour le FIR_ID : ' + QueryLigne.FieldByName('FIR_ID').AsString, logError, vLogKey);

            // on met à jour la ligne
            Inc(nNb);
            MajRepriseFidelite(QueryMaj, QueryLigne.FieldByName('FIR_ID').AsInteger, isRetour, ResWS.ErrorMessage);      // Maj ligne.

            QueryLigne.Next;
            vTentatives := 0;
          end
          else
            Sleep(10000); // pause de 10 sec entre chaque tentative
        end;

        Inc(vTentatives);

        if nNb > NB_LG_PAR_TRANSAC then
        begin
          Cnx.Commit;
          nNb := 0;
          Cnx.StartTransaction;
        end;
      end;
    finally
      FreeAndNil(FFideliteSport2000);

      Cnx.Commit;
    end;
  end;
end;

procedure TRepriseFideliteSport2000.MajRepriseFidelite(QueryMaj: TMyQuery; const nID: Integer; const bRetour: Boolean; const sReponse: String);
begin
  // Maj ligne reprise.
  QueryMaj.Close;
  QueryMaj.SQL.Clear;
  QueryMaj.SQL.Add('update FIDREPRISE');
  QueryMaj.SQL.Add('set FIR_REPONSE = :REPONSE,');
  QueryMaj.SQL.Add('FIR_DATEREPLAY = current_timestamp,');
  QueryMaj.SQL.Add('FIR_ENVOYE = :ENVOYE');
  QueryMaj.SQL.Add('where FIR_ID = :FIRID');
  try
    QueryMaj.ParamByName('REPONSE').AsString := LeftStr(sReponse, 255);
    QueryMaj.ParamByName('ENVOYE').AsInteger := IfThen(bRetour, 1, 0);
    QueryMaj.ParamByName('FIRID').AsInteger := nID;
    QueryMaj.ExecSQL;
  except
    on E: Exception do
    begin
      AddLog('Erreur :  la maj de la ligne de reprise ' + IntToStr(nID) + ' a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;

  QueryMaj.Close;
  QueryMaj.SQL.Clear;
  QueryMaj.SQL.Add('execute procedure pr_updatek(:ID, 0)');
  try
    QueryMaj.ParamByName('ID').AsInteger := nID;
    QueryMaj.ExecSQL;
  except
    on E: Exception do
    begin
      AddLog('Erreur :  la maj (K) de la ligne de reprise ' + IntToStr(nID) + ' a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;
end;

destructor TRepriseFideliteSport2000.Destroy;
begin
  FreeAndNil(FLogs);

  inherited;
end;

end.
