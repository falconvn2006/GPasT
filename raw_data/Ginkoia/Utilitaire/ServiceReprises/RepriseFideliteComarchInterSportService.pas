unit RepriseFideliteComarchInterSportService;

interface

uses
  System.Classes, System.SysUtils, Data.DB, FireDAC.Stan.Param, System.Math, System.StrUtils, System.DateUtils,
  uLogs, uLog, uGestionBDD, Fidelite_Dm, Fidelite_Dm_RS;

const
  NB_LG_PAR_TRANSAC = 60;

type
  TRepriseFideliteComarchInterSportService = class(TThread)
  private
    FLogs: TLogs;
    FDelai: Integer;      // Délai en minutes.
    FFichierIB: String;
    FFideliteComarch: TDm_Fidelite;

    procedure InitLogs;
    procedure AddLog(const sLogMessage: String; const ALogLevel: TLogLevel = logTrace);   overload;
    procedure AddLog(ALogItem: TLogItem);   overload;
    procedure RafraichirLogFileName;
    function GetConnection: TMyConnection;
    procedure InitParametres;
    procedure Traitement;
    procedure RepriseFideliteMagasin(Cnx: TMyConnection; QueryLigne, QueryMaj: TMyQuery; const nIDMagasin: Integer);
    procedure MajRepriseFidelite(QueryMaj: TMyQuery; const nID: Integer; const bRetour: Boolean; const sReponse: String);
    procedure MajTicket(QueryMaj: TMyQuery; const nTKE_ID, nTransactionId: Integer);
    procedure PurgeRepriseFideliteMagasin(QueryLigne, QueryMaj: TMyQuery; const nIDMagasin: Integer);

  protected
    procedure Execute; override;
    procedure RepriseFideliteInterSportLog(Sender: TObject; ALogItem: TLogItem);

  public
    constructor Create(const sFichierIB: String);   overload;
    function CanExecute: Boolean;
    destructor Destroy;   override;
  end;

implementation

{ TRepriseFideliteComarchInterSportService }

constructor TRepriseFideliteComarchInterSportService.Create(const sFichierIB: String);
begin
  FFichierIB := sFichierIB;
  FDelai := (30 * 60);

  InitLogs;
  InitParametres;

  inherited Create(True);
  FreeOnTerminate := False;
end;

procedure TRepriseFideliteComarchInterSportService.InitLogs;
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

procedure TRepriseFideliteComarchInterSportService.AddLog(const sLogMessage: String; const ALogLevel: TLogLevel);
var
  LogTmp: TLogItem;
begin
  LogTmp.Key := 'Status';
  LogTmp.Mag := '';
  LogTmp.Val := ShortString(sLogMessage);
  LogTmp.Lvl := ALogLevel;

  AddLog(LogTmp);
end;

procedure TRepriseFideliteComarchInterSportService.AddLog(ALogItem: TLogItem);
begin
  Log.Log('FIDISF', Log.Ref, String(ALogItem.Mag), String(ALogItem.Key), String(ALogItem.Val), ALogItem.Lvl, True, FDelai * 2 + 10);
  FLogs.AddToLogs(String(ALogItem.Val));
end;

procedure TRepriseFideliteComarchInterSportService.RepriseFideliteInterSportLog(Sender: TObject; ALogItem: TLogItem);
begin
  AddLog(ALogItem);
end;

procedure TRepriseFideliteComarchInterSportService.RafraichirLogFileName;
var
  sDate: String;
begin
  DateTimeToString(sDate, 'yyyymmdd', Now);
  FLogs.FileName := Format('reprisefideliteintersportlogs_%s.txt', [sDate]);
end;

function TRepriseFideliteComarchInterSportService.CanExecute: Boolean;
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
    Query.SQL.Add('join GENPARAM on (MAG_ID = PRM_MAGID)');
    Query.SQL.Add('where MAG_ID <> 0');
    Query.SQL.Add('and exists (select UGM_MAGID');
    Query.SQL.Add('            from UILGRPGINKOIAMAG');
    Query.SQL.Add('            join K on (K_ID = UGM_ID and K_ENABLED = 1)');
    Query.SQL.Add('            join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
    Query.SQL.Add('            where UGG_NOM = ''CENTRALE INTERSPORT'')');
    Query.SQL.Add('and exists (select UGM_MAGID');
    Query.SQL.Add('            from UILGRPGINKOIAMAG');
    Query.SQL.Add('            join K on (K_ID = UGM_ID and K_ENABLED = 1)');
    Query.SQL.Add('            join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
    Query.SQL.Add('            where UGG_NOM = ''FIDBOX'')');
    Query.SQL.Add('and PRM_TYPE = 3');
    Query.SQL.Add('and PRM_CODE = 89');
    Query.SQL.Add('and PRM_INTEGER = 2');      // 2 = Comarch.
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

function TRepriseFideliteComarchInterSportService.GetConnection: TMyConnection;
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

procedure TRepriseFideliteComarchInterSportService.InitParametres;
var
  Cnx: TMyConnection;
  Query: TMyQuery;
  nBasID: Integer;
begin
  Cnx := GetConnection;
  Query := GetNewQuery(Cnx);
  try
    // Recherche du BAS_ID.
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select BAS_ID');
    Query.SQL.Add('from GENBASES');
    Query.SQL.Add('join K on (K_ID = BAS_ID and K_ENABLED = 1)');
    Query.SQL.Add('where BAS_IDENT = (select PAR_STRING from GENPARAMBASE where PAR_NOM = ''IDGENERATEUR'')');
    try
      Query.Open;
    except
      on E: Exception do
      begin
        AddLog('Erreur :  la recherche du BAS_ID a échoué !' + #13#10 + E.Message, logError);
        Exit;
      end;
    end;
    if Query.IsEmpty then
      AddLog('Erreur :  pas de BAS_ID trouvé !', logError)
    else
    begin
      nBasID := Query.FieldByName('BAS_ID').AsInteger;

      // Recherche du délai.
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('select PRM_INTEGER');
      Query.SQL.Add('from GENPARAM');
      Query.SQL.Add('join K on (K_ID = PRM_ID and K_ENABLED = 1)');
      Query.SQL.Add('where PRM_TYPE = 3');
      Query.SQL.Add('and PRM_CODE = 99');
      Query.SQL.Add('and PRM_POS = :BASID');
      try
        Query.ParamByName('BASID').AsInteger := nBasID;
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
    end;
  finally
    Query.DisposeOf;
    Cnx.DisposeOf;
  end;
end;

procedure TRepriseFideliteComarchInterSportService.Execute;
var
  nCount: Integer;
begin
  nCount := FDelai;
  AddLog(Format('Démarrage du service "Reprise fidélité INTERSPORT Comarch" (délai %d minutes)', [FDelai div 60]));
  AddLog('"Reprise fidélité INTERSPORT Comarch" démarré', logInfo);
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

  AddLog('Arrêt du service "Reprise fidélité INTERSPORT Comarch"');
  AddLog('Arrêté', logInfo);
end;

procedure TRepriseFideliteComarchInterSportService.Traitement;
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
    QueryMagasin.SQL.Add('join GENPARAM on (MAG_ID = PRM_MAGID)');
    QueryMagasin.SQL.Add('where MAG_ID <> 0');
    QueryMagasin.SQL.Add('and exists (select UGM_MAGID');
    QueryMagasin.SQL.Add('            from UILGRPGINKOIAMAG');
    QueryMagasin.SQL.Add('            join K on (K_ID = UGM_ID and K_ENABLED = 1)');
    QueryMagasin.SQL.Add('            join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
    QueryMagasin.SQL.Add('            where UGG_NOM = ''CENTRALE INTERSPORT'')');
    QueryMagasin.SQL.Add('and exists (select UGM_MAGID');
    QueryMagasin.SQL.Add('            from UILGRPGINKOIAMAG');
    QueryMagasin.SQL.Add('            join K on (K_ID = UGM_ID and K_ENABLED = 1)');
    QueryMagasin.SQL.Add('            join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
    QueryMagasin.SQL.Add('            where UGG_NOM = ''FIDBOX'')');
    QueryMagasin.SQL.Add('and PRM_TYPE = 3');
    QueryMagasin.SQL.Add('and PRM_CODE = 89');
    QueryMagasin.SQL.Add('and PRM_INTEGER = 2');
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

        RepriseFideliteMagasin(Cnx, QueryLigne, QueryMaj, QueryMagasin.FieldByName('MAG_ID').AsInteger);
        PurgeRepriseFideliteMagasin(QueryLigne, QueryMaj, QueryMagasin.FieldByName('MAG_ID').AsInteger);

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

procedure TRepriseFideliteComarchInterSportService.RepriseFideliteMagasin(Cnx: TMyConnection; QueryLigne, QueryMaj: TMyQuery; const nIDMagasin: Integer);
var
  nNb: Integer;
  ResTicket: TResTicket;
begin
  // Recherche des tickets du magasin.
  QueryLigne.Close;
  QueryLigne.SQL.Clear;
  QueryLigne.SQL.Add('select FIR_ID, FIR_TKEID, FIR_TYPE');
  QueryLigne.SQL.Add('from FIDREPRISE');
  QueryLigne.SQL.Add('join K on (K_ID = FIR_ID and K_ENABLED = 1)');
  QueryLigne.SQL.Add('where FIR_ENVOYE = 0');
  QueryLigne.SQL.Add('and FIR_MAGID = :MAGID');
  QueryLigne.SQL.Add('order by FIR_DATE');
  try
    QueryLigne.ParamByName('MAGID').AsInteger := nIDMagasin;
    QueryLigne.Open;
  except
    on E: Exception do
    begin
      AddLog('Erreur :  la recherche des tickets du magasin ' + IntToStr(nIDMagasin) + ' a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;
  if not QueryLigne.IsEmpty then
  begin
    nNb := 0;
    Cnx.StartTransaction;
    FFideliteComarch := TDm_Fidelite.GetNewFideliteDM(nil, Cnx, nIDMagasin, etc_Batch);
    try
      QueryLigne.First;
      while not QueryLigne.Eof do
      begin
        if Terminated then
          Break;

        // Renvoi du ticket.
        ResTicket := nil;
        try
          // Si FIR_TYPE à 9, alors il s'agit d'une annulation de ticket
          if (QueryLigne.FieldByName('FIR_TYPE').AsInteger = 9) then
            ResTicket := FFideliteComarch.ReverseTicket(QueryLigne.FieldByName('FIR_TKEID').AsInteger)
          else
            ResTicket := FFideliteComarch.SendTicket(QueryLigne.FieldByName('FIR_TKEID').AsInteger);
        except
          on E: Exception do
          begin
            AddLog('Erreur :  le renvoi du ticket ' + QueryLigne.FieldByName('FIR_TKEID').AsString + ' a échoué !' + #13#10 + E.Message, logError);
          end;
        end;

        // Si problème web service.
        if ResTicket.ErrorCode >= CST_ERROR_WEBSERVICE_RETRY then
        begin
          // Si le web service ne répond pas.
          if ResTicket.ErrorCode = CST_ERROR_404 then
            Break
          else
          begin
            QueryLigne.Next;         // Traitement ligne suivante.
            Continue;
          end;
        end
        else
        begin
          MajRepriseFidelite(QueryMaj, QueryLigne.FieldByName('FIR_ID').AsInteger, True, ResTicket.ErrorMessage);      // Maj ligne.
          // Mettre à jour le ticket avec l'ID de transaction Comarch sauf dans le cas d'une annulation
          if (QueryLigne.FieldByName('FIR_TYPE').AsInteger <> 9) then
            MajTicket(QueryMaj, QueryLigne.FieldByName('FIR_TKEID').AsInteger, ResTicket.TransactionId);
        end;

        Inc(nNb);
        if nNb > NB_LG_PAR_TRANSAC then
        begin
          Cnx.Commit;
          nNb := 0;
          Cnx.StartTransaction;
        end;

        QueryLigne.Next;
      end;
    finally
      FreeAndNil(FFideliteComarch);

      Cnx.Commit;
    end;
  end;
end;

procedure TRepriseFideliteComarchInterSportService.MajRepriseFidelite(QueryMaj: TMyQuery; const nID: Integer; const bRetour: Boolean; const sReponse: String);
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

procedure TRepriseFideliteComarchInterSportService.MajTicket(QueryMaj: TMyQuery; const nTKE_ID, nTransactionId: Integer);
begin
  // Pour ne pas risquer d'écraer un ID en cas d'erreur du retour
  if (nTransactionId = 0) then
    Exit;

  // Maj ligne reprise.
  QueryMaj.Close;
  QueryMaj.SQL.Clear;
  QueryMaj.SQL.Add('update CSHTICKET set');
  QueryMaj.SQL.Add('  TKE_FIDTRANSID = :FIDTRANSID');
  QueryMaj.SQL.Add('where TKE_ID = :TKEID');
  try
    QueryMaj.ParamByName('FIDTRANSID').AsInteger := nTransactionId;
    QueryMaj.ParamByName('TKEID').AsInteger := nTKE_ID;
    QueryMaj.ExecSQL;
  except
    on E: Exception do
    begin
      AddLog('Erreur :  la maj du ticket avec l''ID de transaction ' + IntToStr(nTKE_ID) + ' a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;

  QueryMaj.Close;
  QueryMaj.SQL.Clear;
  QueryMaj.SQL.Add('execute procedure pr_updatek(:ID, 0)');
  try
    QueryMaj.ParamByName('ID').AsInteger := nTKE_ID;
    QueryMaj.ExecSQL;
  except
    on E: Exception do
    begin
      AddLog('Erreur :  la maj (K) du ticket ' + IntToStr(nTKE_ID) + ' a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;
end;

procedure TRepriseFideliteComarchInterSportService.PurgeRepriseFideliteMagasin(QueryLigne, QueryMaj: TMyQuery; const nIDMagasin: Integer);
var
  nRetention: Integer;      // Nombre de jours.
begin
  // Recherche du délai de rétention.
  QueryLigne.Close;
  QueryLigne.SQL.Clear;
  QueryLigne.SQL.Add('select PRM_INTEGER');
  QueryLigne.SQL.Add('from GENPARAM');
  QueryLigne.SQL.Add('join K on (K_ID = PRM_ID and K_ENABLED = 1)');
  QueryLigne.SQL.Add('where PRM_TYPE = 3');
  QueryLigne.SQL.Add('and PRM_CODE = 93');
  QueryLigne.SQL.Add('and PRM_MAGID = :MAGID');
  try
    QueryLigne.ParamByName('MAGID').AsInteger := nIDMagasin;
    QueryLigne.Open;
  except
    on E: Exception do
    begin
      AddLog('Erreur :  la recherche du délai de rétention du magasin [' + IntToStr(nIDMagasin) + '] a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;
  if QueryLigne.IsEmpty then
    AddLog('Erreur :  pas de délai de rétention trouvé pour le magasin [' + IntToStr(nIDMagasin) + '] !', logError)
  else
  begin
    nRetention := QueryLigne.FieldByName('PRM_INTEGER').AsInteger;

    // Recherche des tickets dépassés du magasin.
    QueryLigne.Close;
    QueryLigne.SQL.Clear;
    QueryLigne.SQL.Add('select FIR_ID');
    QueryLigne.SQL.Add('from FIDREPRISE');
    QueryLigne.SQL.Add('join K on (K_ID = FIR_ID and K_ENABLED = 1)');
    QueryLigne.SQL.Add('where FIR_ENVOYE = 1');
    QueryLigne.SQL.Add('and FIR_MAGID = :MAGID');
    QueryLigne.SQL.Add('and FIR_DATE < :DATE_RETENTION');
    QueryLigne.SQL.Add('order by FIR_DATE');
    try
      QueryLigne.ParamByName('MAGID').AsInteger := nIDMagasin;
      QueryLigne.ParamByName('DATE_RETENTION').AsDateTime := IncDay(Now, -nRetention);
      QueryLigne.Open;
    except
      on E: Exception do
      begin
        AddLog('Erreur :  la recherche des tickets dépassés du magasin ' + IntToStr(nIDMagasin) + ' a échoué !' + #13#10 + E.Message, logError);
        Exit;
      end;
    end;
    if not QueryLigne.IsEmpty then
    begin
      QueryLigne.First;
      while not QueryLigne.Eof do
      begin
        // Suppression de la ligne.
        QueryMaj.Close;
        QueryMaj.SQL.Clear;
        QueryMaj.SQL.Add('execute procedure pr_updatek(:ID, 1)');
        try
          QueryMaj.ParamByName('ID').AsInteger := QueryLigne.FieldByName('FIR_ID').AsInteger;
          QueryMaj.ExecSQL;
        except
          on E: Exception do
          begin
            AddLog('Erreur :  la suppression de la ligne [' + QueryLigne.FieldByName('FIR_ID').AsString + '] a échoué !' + #13#10 + E.Message, logError);
            Exit;
          end;
        end;

        QueryLigne.Next;
      end;
    end;
  end;
end;

destructor TRepriseFideliteComarchInterSportService.Destroy;
begin
  FreeAndNil(FLogs);

  inherited;
end;

end.

