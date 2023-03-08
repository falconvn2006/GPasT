unit RepriseReservationSkiset;

interface

uses
  System.Classes,
  System.SysUtils,
  uGestionBDD,
  ulog,
  ulogs;

type
  TRepriseReservationSkiset = class(TThread)
  protected
    FLogs: TLogs;
    FBaseLog, FBaseLogTrace : string;
    FDataBaseFile : string;
    FDelais : integer;

    procedure InitLogs();
    procedure InitDelais();
    procedure AddLog(ALogMessage : string; ALogLevel : TLogLevel);

    procedure TraiteReservation();

    procedure Execute(); override;
  public
    constructor Create(ADataBaseFile: string); overload;
    destructor Destroy(); override;

    function CanExecute() : boolean;
  end;

implementation

uses
  ActiveX,
  ReservationTypeSkiset_Defs;

{ TRepriseReservationSkiset }

procedure TRepriseReservationSkiset.InitLogs();
begin
  FBaseLog := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Logs')));
  //FBaseLogTrace := IncludeTrailingPathDelimiter(FBaseLog + 'Skiset');;
  if not DirectoryExists(FBaseLog) then
    ForceDirectories(FBaseLog);
//  if not DirectoryExists(FBaseLogTrace) then
//    ForceDirectories(FBaseLogTrace);

  FLogs := TLogs.Create;
  FLogs.Path := FBaseLog;
  FLogs.FileName := Format('reprisereservationskisetlogs_%s.txt', [FormatDateTime('yyyymmdd', Now())]);
end;

procedure TRepriseReservationSkiset.InitDelais();
var
  Connexion : TMyConnection;
  Query : TMyQuery;
  newDelais : integer;
begin
  Connexion := nil;
  Query := nil;
  newDelais := 15;

  try
    try
      Connexion := GetNewConnexion(FDataBaseFile, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, False);
      try
        // Recuperation du delai du service de reprise (prevu a l'origine pour la demat des cheques cadeaux)
        Query := GetNewQuery(Connexion);
        Query.SQL.Text := 'select prm_integer '
                        + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                        + 'join genmagasin join k on k_id = mag_id and k_enabled = 1 on mag_id = prm_magid '
                        + 'join genbases join k on k_id = bas_id and k_enabled= 1 on bas_id = mag_basid '
                        + 'join genparambase on par_string = bas_ident '
                        + 'where prm_type = 3 and prm_code = 134 and par_nom = ''IDGENERATEUR'';';
        try
          Query.Open();
          if not Query.Eof then
            newDelais := Query.FieldByName('prm_integer').AsInteger * 60;
        finally
          Query.Close();
        end;
      finally
        FreeAndNil(Query);
      end;
    finally
      FreeAndNil(Connexion);
    end;

    // valeur par defaut !
    if newDelais = 0 then
      newDelais := 900;

    // remplacement
    if not (FDelais = newDelais) then
    begin
      AddLog(Format('Chargement du délai = %d minutes', [Trunc(FDelais / 60)]), logTrace);
      FDelais := newDelais;
    end;
  except
    on e : Exception do
    begin
      AddLog(Format('InitDelais - Erreur : %s - %s', [e.className, e.Message]), logError);
    end;
  end;
end;

procedure TRepriseReservationSkiset.AddLog(ALogMessage: string; ALogLevel: TLogLevel);
begin
  log.Log('WSSKISET', log.Ref, '', 'Status', ALogMessage, ALogLevel, True, 0);
  FLogs.AddToLogs(ALogMessage);
end;

procedure TRepriseReservationSkiset.TraiteReservation();
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  QueryMag, QueryImp, QueryMaj : TMyQuery;
  BaseURL, User, Cle : string;
begin
  Connexion := nil;
  Transaction := nil;
  QueryMag := nil;
  QueryImp := nil;
  QueryMaj := nil;

  AddLog('Début de traitement', logTrace);

  try
    try
      Connexion := GetNewConnexion(FDataBaseFile, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, false);

      // Recuperation des paramètre
      if GetParamWebService(Connexion, 0, BaseURL, User, Cle) then
      begin
        try
          Transaction := GetNewTransaction(Connexion, false);
          try
            QueryMag := GetNewQuery(Connexion, Transaction);
            QueryImp := GetNewQuery(Connexion, Transaction);
            QueryMaj := GetNewQuery(Connexion, Transaction);

            try
              Transaction.StartTransaction();

              // Recuperation de tous les magasins, de ce site, qui sont paramétré avec Skiset
              QueryMag.SQl.Text := 'select mag_id, mag_enseigne, mty_id '
                                 + 'from gentypemail join k on k_id = mty_id and k_enabled = 1 '
                                 + 'join uilgrpginkoia join k on k_id = ugg_id and k_enabled = 1 on upper(mty_nom) = upper(ugg_nom) '
                                 + 'join uilgrpginkoiamag join k on k_id = ugm_id and k_enabled = 1 on ugm_uggid = ugg_id '
                                 + 'join genmagasin join k on k_id = mag_id and k_enabled = 1 on mag_id = ugm_magid '
                                 + 'join genbases join k on k_id = bas_id and k_enabled= 1 on bas_id = mag_basid '
                                 + 'join genparambase on par_string = bas_ident '
                                 + 'where mty_id != 0 and upper(ugg_nom) = ''RESERVATION SKISET'' and genparambase.par_nom = ''IDGENERATEUR'';';
              try
                QueryMag.Open();
                while not QueryMag.Eof do
                begin
                  AddLog('  Gestion du magasin ' + QueryMag.FieldByName('mag_enseigne').AsString, logTrace);

                  // Recuperation des enregistrement qui corresponde a des reservation a marquer !
                  //   et dont la date de modif est a plus de 30min
                  QueryImp.SQL.Text := 'select rsl_id, rsl_wsdone, '
                                     + '       rvs_idwebstring as webidentete, rsl_webid as webidligne '
                                     + 'from locreservation join k on k_id = rvs_id and k_enabled = 1 '
                                     + 'join locreservationligne join k klig on klig.k_id = rsl_id and klig.k_enabled = 1 on rsl_rvsid = rvs_id '
                                     + 'where rvs_magid = ' + QueryMag.FieldByName('mag_id').AsString
                                     + '  and rvs_mtyid = ' + QueryMag.FieldByName('mty_id').AsString
                                     + '  and rsl_wsdone = 0'
                                     + '  and (klig.k_updated + 0.021) < current_timestamp;';
                  try
                    QueryImp.Open();
                    while not QueryImp.Eof do
                    begin
                      AddLog('    traitement de reservation : ' + QueryImp.FieldByName('webidentete').AsString + ' - ' + QueryImp.FieldByName('webidligne').AsString, logTrace);

                      // Appel au webservice
                      try
                        if WebServiceMarqueReservationLignePrise(BaseURL, User, Cle, QueryImp.FieldByName('webidentete').AsString, QueryImp.FieldByName('webidligne').AsInteger, true, FBaseLogTrace) then
                        begin
                          // si reussit, mise a jour de la BDD
                          QueryMaj.SQl.Text := 'update locreservationligne set rsl_wsdone = 1 where rsl_id = ' + QueryImp.FieldByName('rsl_id').AsString + ';';
                          QueryMaj.ExecSQL();
                          QueryMaj.SQl.Text := 'execute procedure pr_updatek(' + QueryImp.FieldByName('rsl_id').AsString + ', 0);';
                          QueryMaj.ExecSQL();

                          AddLog('    -> OK', logTrace);
                        end
                        else
                          AddLog('    -> KO', logTrace);
                      except
                        on e : Exception do
                          AddLog('    -> KO (exception : ' + e.ClassName + ' - ' + e.Message + ')', logError);
                      end;

                      QueryImp.Next();
                    end;
                  finally
                    QueryImp.Close();
                  end;

                  QueryMag.Next();
                end;
              finally
                QueryMag.Close();
              end;

              Transaction.Commit();
            except
              Transaction.Rollback();
              raise;
            end;

          finally
            FreeAndNil(QueryMaj);
            FreeAndNil(QueryImp);
            FreeAndNil(QueryMag);
          end;
        finally
          FreeAndNil(Transaction);
        end;
      end;
    finally
      FreeAndNil(Connexion);
    end;

    AddLog('Fin de traitement', logTrace);

  except
    on e : Exception do
      AddLog(Format('TraiteReservation - Erreur : %s - %s', [e.className, e.Message]), logError);
  end;
end;

procedure TRepriseReservationSkiset.Execute();
var
  Count : integer;
begin
  CoInitialize(nil);
  Count := 0;

  // si le répertoire spécifique à SkiSet pour les appels webservice n'existe pas, on le créé
  FBaseLogTrace := IncludeTrailingPathDelimiter(FBaseLog + 'Skiset');;
  if not DirectoryExists(FBaseLogTrace) then
    ForceDirectories(FBaseLogTrace);

  try
    AddLog(Format('Demarrage du service "Reprise réservation SKISET" (délai %d minutes)', [Trunc(FDelais / 60)]), logInfo);
    AddLog('Demarré', logInfo);
    while not Terminated do
    begin
      try
        inc(Count);
        if Count >= FDelais then
        begin
          TraiteReservation();
          Count := 0;
        end;
        Sleep(1000);
      except
        on e : Exception do
          AddLog(Format('Erreur : %s - %s', [e.className, e.Message]), logError);
      end;
    end;
  finally
    AddLog('Arrêt du service "Reprise réservation SKISET"', logInfo);
    AddLog('Arrêté', logInfo);
    CoUninitialize;
  end;
end;

constructor TRepriseReservationSkiset.Create(ADataBaseFile: string);
begin
  inherited Create(True);
  FDataBaseFile := ADataBaseFile;
  FreeOnTerminate := False;
  FDelais := 900;
  InitLogs();
  InitDelais();
end;

destructor TRepriseReservationSkiset.Destroy();
begin
  FreeAndNil(FLogs);
  inherited Destroy();
end;

function TRepriseReservationSkiset.CanExecute() : boolean;
var
  Connexion : TMyConnection;
  Query : TMyQuery;
begin
  Result := false;
  Connexion := nil;
  Query := nil;

  try
    try
      Connexion := GetNewConnexion(FDataBaseFile, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, False);
      try
        Query := GetNewQuery(Connexion);
        Query.SQL.Text := 'select mty_id '
                        + 'from gentypemail join k on k_id = mty_id and k_enabled = 1 '
                        + 'join uilgrpginkoia join k on k_id = ugg_id and k_enabled = 1 on upper(mty_nom) = upper(ugg_nom) '
                        + 'join uilgrpginkoiamag join k on k_id = ugm_id and k_enabled = 1 on ugm_uggid = ugg_id '
                        + 'join genmagasin join k on k_id = mag_id and k_enabled = 1 on mag_id = ugm_magid '
                        + 'join genbases join k on k_id = bas_id and k_enabled= 1 on bas_id = mag_basid '
                        + 'join genparambase on par_string = bas_ident '
                        + 'where mty_id != 0 and upper(ugg_nom) = ''RESERVATION SKISET'' and genparambase.par_nom = ''IDGENERATEUR''';
        try
          Query.Open();
          if not Query.Eof then
          begin
            Result := true;
          end;
        finally
          Query.Close();
        end;
      finally
        FreeAndNil(Query);
      end;
    finally
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      Result := false;
      AddLog(Format('CanExecute - Erreur : %s - %s', [e.className, e.Message]), logError);
    end;
  end;
end;

end.
