unit RepriseMarketPlaceSport2000;

interface

uses System.Classes, System.SysUtils, Data.DB, FireDAC.Stan.Param, System.StrUtils,
  uGestionBDD, uLogs, uLog, PanierWebMarketPlace, uMarketPlace;

type
  TRepriseMarketPlaceSport2000Service = class(TThread)
    private
      FLogs: TLogs;
      FDelai: Integer;      // Délai en secondes.
      FFichierIB: String;
      FGestionPanierWeb: TGestionPanierWeb;

      procedure InitLogs;
      procedure RafraichirNomFichierLog;
      procedure AddLog(const sLogMessage: String; const ALogLevel: TLogLevel = logTrace);
      function GetConnection: TMyConnection;
      procedure InitParametres;
      procedure Traitement;
      procedure ReprisePanierWebMagasin(Cnx: TMyConnection; QueryLigne, QueryMaj: TMyQuery; const nIDMagasin: Integer);
      procedure MajReprisePanierWeb(Cnx: TMyConnection; QueryMaj: TMyQuery; const nTkeID: Integer; const sNumPanier: String);

    protected
      procedure Execute;   override;

    public
      constructor Create(const sFichierIB: String);   overload;
      function CanExecute: Boolean;
      destructor Destroy;   override;
  end;

implementation

{ TRepriseMarketPlaceSport2000Service }

constructor TRepriseMarketPlaceSport2000Service.Create(const sFichierIB: String);
begin
  FFichierIB := sFichierIB;
  FDelai := (15 * 60);      // 15 minutes.

  InitLogs;
  InitParametres;

  inherited Create(True);
  FreeOnTerminate := False;
end;

procedure TRepriseMarketPlaceSport2000Service.InitLogs;
var
  sChemin: String;
begin
  sChemin := ExtractFilePath(ParamStr(0)) + '\logs\';
  if not DirectoryExists(sChemin) then
    ForceDirectories(sChemin);

  FLogs := TLogs.Create;
  FLogs.Path := sChemin;
  RafraichirNomFichierLog;
end;

procedure TRepriseMarketPlaceSport2000Service.RafraichirNomFichierLog;
var
  sDate: String;
begin
  DateTimeToString(sDate, 'yyyy-mm-dd', Now);
  FLogs.FileName := Format('Reprise market place - Sport 2000 - %s.log', [sDate]);
end;

procedure TRepriseMarketPlaceSport2000Service.AddLog(const sLogMessage: String; const ALogLevel: TLogLevel);
var
  LogItem: TLogItem;
begin
  LogItem.Key := 'Status';
  LogItem.Mag := '';
  LogItem.Val := ShortString(sLogMessage);
  LogItem.Lvl := ALogLevel;

  Log.Log('MP-SP2K', Log.Ref, String(LogItem.Mag), String(LogItem.Key), String(LogItem.Val), LogItem.Lvl, True, FDelai * 2 + 10);
  FLogs.AddToLogs(String(LogItem.Val));
end;

function TRepriseMarketPlaceSport2000Service.GetConnection: TMyConnection;
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

procedure TRepriseMarketPlaceSport2000Service.InitParametres;
begin
end;

function TRepriseMarketPlaceSport2000Service.CanExecute: Boolean;
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
    Query.SQL.Add('            where UGG_NOM = ''MARKET PLACE SPORT2000'')');
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

procedure TRepriseMarketPlaceSport2000Service.Execute;
var
  nCount: Integer;
begin
  nCount := FDelai;
  AddLog(Format('Démarrage du service "Reprise market place - Sport 2000" (délai %d minutes)', [FDelai div 60]));
  AddLog('"Reprise market place - Sport 2000" démarré', logInfo);
  while not Terminated do
  begin
    try
      Inc(nCount);
      if nCount >= FDelai then
      begin
        nCount := 0;
        RafraichirNomFichierLog;
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

  AddLog('Arrêt du service "Reprise market place - Sport 2000"');
  AddLog('Arrêté', logInfo);
end;

procedure TRepriseMarketPlaceSport2000Service.Traitement;
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
    QueryMagasin.SQL.Add('select distinct MAG_ID');
    QueryMagasin.SQL.Add('from GENMAGASIN');
    QueryMagasin.SQL.Add('join K on (K_ID = MAG_ID and K_ENABLED = 1)');
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
    QueryMagasin.SQL.Add('            where UGG_NOM = ''MARKET PLACE SPORT2000'')');
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

        ReprisePanierWebMagasin(Cnx, QueryLigne, QueryMaj, QueryMagasin.FieldByName('MAG_ID').AsInteger);

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

procedure TRepriseMarketPlaceSport2000Service.ReprisePanierWebMagasin(Cnx: TMyConnection; QueryLigne, QueryMaj: TMyQuery; const nIDMagasin: Integer);
var
  sJson: String;
  nDebut, nFin: Integer;
  Retour: TRetourWS;
  CommandeFinale: TReponseCommandeWeb;
begin
  // Recherche des paniers web du magasin.
  QueryLigne.Close;
  QueryLigne.SQL.Clear;
  QueryLigne.SQL.Add('select TKR_TKEID, TKR_NUMCDEWEB, TKR_REQUEST');
  QueryLigne.SQL.Add('from CSHTICKETREPRISEMP');
  QueryLigne.SQL.Add('join CSHTICKET on (TKR_TKEID = TKE_ID)');
  QueryLigne.SQL.Add('join K on (TKE_ID = K_ID and K_ENABLED = 1)');
  QueryLigne.SQL.Add('join CSHSESSION on (TKE_SESID = SES_ID)');
  QueryLigne.SQL.Add('join GENPOSTE on (SES_POSID = POS_ID)');
  QueryLigne.SQL.Add('where TKR_ETAT = 3');
  QueryLigne.SQL.Add('and POS_MAGID = :MAGID');
  QueryLigne.SQL.Add('order by TKR_TKEID, TKR_NUMCDEWEB');
  try
    QueryLigne.ParamByName('MAGID').AsInteger := nIDMagasin;
    QueryLigne.Open;
  except
    on E: Exception do
    begin
      AddLog('Erreur :  la recherche des paniers web du magasin ' + IntToStr(nIDMagasin) + ' a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;
  if not QueryLigne.IsEmpty then
  begin
    FGestionPanierWeb := TGestionPanierWeb.Create(Cnx);
    try
      QueryLigne.First;
      while not QueryLigne.Eof do
      begin
        if Terminated then
          Break;

        // Annulation du panier web temporaire.
        FGestionPanierWeb.AnnulerPanier(QueryLigne.FieldByName('TKR_NUMCDEWEB').AsString);

        sJson := QueryLigne.FieldByName('TKR_REQUEST').AsString;
        nDebut := Pos('"token":"', sJson);
        if nDebut > 0 then
        begin
          nFin := Pos('"', sJson, nDebut + 9);
          if nFin > 0 then
          begin
            sJson := LeftStr(sJson, nDebut + 8) + FGestionPanierWeb.Jeton + Copy(sJson, nFin, Length(sJson));

            // Création de la commande.
            Retour := FGestionPanierWeb.CreerCommandeWebReprise(sJson, CommandeFinale);
            try
              if(Retour.nCode = 201) and (Assigned(CommandeFinale)) then
              begin
                AddLog('Commande web finale [' + CommandeFinale.id + '] créée pour le panier web [' + QueryLigne.FieldByName('TKR_NUMCDEWEB').AsString + '] du ticket [' + QueryLigne.FieldByName('TKR_TKEID').AsString + '].');

                Cnx.StartTransaction;
                try             
                  // Maj ligne reprise.
                  MajReprisePanierWeb(Cnx, QueryMaj, QueryLigne.FieldByName('TKR_TKEID').AsInteger, QueryLigne.FieldByName('TKR_NUMCDEWEB').AsString);
                finally
                  if Cnx.InTransaction then
                    Cnx.Commit;
                end;
              end
              else
                AddLog('Erreur :  échec de la création de la commande web [panier = ' + QueryLigne.FieldByName('TKR_NUMCDEWEB').AsString + '] du ticket [' + QueryLigne.FieldByName('TKR_TKEID').AsString + '] !');
            finally
              if Assigned(CommandeFinale) then
                FreeAndNil(CommandeFinale);
            end;
          end
          else
            AddLog('Erreur :  le JSON du panier web [' + QueryLigne.FieldByName('TKR_NUMCDEWEB').AsString + '] du ticket [' + QueryLigne.FieldByName('TKR_TKEID').AsString + '] est incorrect !');
        end
        else
          AddLog('Erreur :  le JSON du panier web [' + QueryLigne.FieldByName('TKR_NUMCDEWEB').AsString + '] du ticket [' + QueryLigne.FieldByName('TKR_TKEID').AsString + '] est incorrect !');

        QueryLigne.Next;
      end;
    finally
      FreeAndNil(FGestionPanierWeb);
    end;
  end;
end;

procedure TRepriseMarketPlaceSport2000Service.MajReprisePanierWeb(Cnx: TMyConnection; QueryMaj: TMyQuery; const nTkeID: Integer; const sNumPanier: String);
var
  nTKMID: Integer;
begin
  // Maj ligne reprise.
  QueryMaj.Close;
  QueryMaj.SQL.Clear;
  QueryMaj.SQL.Add('update CSHTICKETREPRISEMP');
  QueryMaj.SQL.Add('set TKR_ETAT = 2');
  QueryMaj.SQL.Add('where TKR_TKEID = :TKEID');
  QueryMaj.SQL.Add('and TKR_NUMCDEWEB = :NUMCDEWEB');
  try
    QueryMaj.ParamByName('TKEID').AsInteger := nTkeID;
    QueryMaj.ParamByName('NUMCDEWEB').AsString := sNumPanier;
    QueryMaj.ExecSQL;
  except
    on E: Exception do
    begin
      Cnx.Rollback;
      AddLog('Erreur :  la maj de la ligne de reprise [Ticket = ' + IntToStr(nTkeID) + ' - panier web = ' + sNumPanier + '] a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;

  // Recherche de la ligne de panier web du ticket.
  QueryMaj.Close;
  QueryMaj.SQL.Clear;
  QueryMaj.SQL.Add('select TKM_ID');
  QueryMaj.SQL.Add('from CSHTICKETLMP');
  QueryMaj.SQL.Add('where TKM_TKEID = :TKEID');
  QueryMaj.SQL.Add('and TKM_NUMCDEWEB = :NUMCDEWEB');
  try
    QueryMaj.ParamByName('TKEID').AsInteger := nTkeID;
    QueryMaj.ParamByName('NUMCDEWEB').AsString := sNumPanier;
    QueryMaj.Open;
  except
    on E: Exception do
    begin
      Cnx.Rollback;
      AddLog('Erreur :  la recherche de la ligne de panier web [' + sNumPanier + '] du ticket [' + IntToStr(nTkeID) + '] a échoué !' + #13#10 + E.Message, logError);
      Exit;
    end;
  end;
  if QueryMaj.IsEmpty then

  else
  begin
    nTKMID := QueryMaj.FieldByName('TKM_ID').AsInteger;
  
    // Maj ligne de panier web du ticket.
    QueryMaj.Close;
    QueryMaj.SQL.Clear;
    QueryMaj.SQL.Add('update CSHTICKETLMP');
    QueryMaj.SQL.Add('set TKM_ETAT = 2');
    QueryMaj.SQL.Add('where TKM_ID = :TKMID');
    try
      QueryMaj.ParamByName('TKMID').AsInteger := nTKMID;
      QueryMaj.ExecSQL;
    except
      on E: Exception do
      begin
        Cnx.Rollback;
        AddLog('Erreur :  la maj de la ligne de panier web [' + sNumPanier + '] du ticket [' + IntToStr(nTkeID) + '] a échoué !' + #13#10 + E.Message, logError);
        Exit;
      end;
    end;

    QueryMaj.Close;
    QueryMaj.SQL.Clear;
    QueryMaj.SQL.Add('execute procedure pr_updatek(:ID, 0)');
    try
      QueryMaj.ParamByName('ID').AsInteger := nTKMID;
      QueryMaj.ExecSQL;
    except
      on E: Exception do
      begin
        Cnx.Rollback;
        AddLog('Erreur :  la maj (K) de la ligne de panier web ' + IntToStr(nTKMID) + ' a échoué !' + #13#10 + E.Message, logError);
        Exit;
      end;
    end;
  end;
end;

destructor TRepriseMarketPlaceSport2000Service.Destroy;
begin
  FreeAndNil(FLogs);

  inherited;
end;

end.

