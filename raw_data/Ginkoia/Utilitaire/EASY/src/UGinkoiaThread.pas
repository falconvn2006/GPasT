unit UGinkoiaThread;

interface

uses
  System.Classes,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  System.IniFiles,
  UBaseThread,
  uCreateProcess,
  uGestionBDD;

type
  TRecalculThread = class(TBaseIBThread)
  protected
    FVersion : string;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Version : string; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TBaseGinkoiaThread = class(TBaseIBThread)
  protected
    FIdentBase : integer;

    // Gestion de plage
    procedure DecodePlage(S: string; var Deb, fin: integer);
    // decoupage chaine pour recup des "identifiants" SQL
    procedure GetSQLInfo(Text : string; out Table, Champ, Cond : string);
    // Execution de requete et recup de la case en haut a gauche ;)
    procedure RecupMaxValeur(Query : TMyQuery; SQL, Cond : string; var Valeur : integer);
    // Recherche de la valeur max du GENERAL_ID (generateur principal)
    function GetGenId(Query : TMyQuery; Plage : string; ini : TInifile) : integer;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
  end;

  TRecupIDThread = class(TBaseGinkoiaThread)
  protected
    FPlageMagasin : string;

    function TraiteGenerateur(Query : TMyQuery; GenName : string; ini : TInifile) : integer;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TGenerateurThread = class(TRecupIDThread)
  protected
    FDoRecalc : boolean;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; IdentBase : integer; DoRecalc : boolean; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
  end;

implementation

uses
  System.Math,
  System.SysUtils,
  UFileUtils;

{ TRecalculThread }

procedure TRecalculThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Exception
// 2 - Autre erreur
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  Query : TMyQuery;
  nblig, Res : integer;
begin
  ReturnValue := 2;
  ProgressStyle(pbstMarquee);

  try
    try
      Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
      Transaction := GetNewTransaction(Connexion, false);
      Query := GetNewQuery(Connexion, Transaction);

      Connexion.Open();

      DoLog('/******************************************************************************/');
      ProgressStepLbl('Recuperation du nombre d''enregistrements');
      DoLog('');

      try
        Transaction.StartTransaction();

        // nombre d'enreg !
        try
          if FVersion < '12' then
            Query.SQL.Text := 'select count(*) as nb from gentrigger;'
          else
            Query.SQL.Text := 'select count(*) as nb from gentriggerdiff;';
          QUery.Open();
          if Query.Eof then
            nblig := 0
          else
            nblig := Query.Fields[0].AsInteger
        finally
          Query.Close();
        end;

        Transaction.Commit();
      except
        Transaction.Rollback();
        raise;
      end;

      // init progress bar !
      ProgressInit((nblig div 500) + Min(1, (nblig mod 500)));

      DoLog('nombre d''enregistrement : ' + IntToStr(nblig));
      DoLog('nombre de boucle prevu : ' + IntToStr(FMaxProgress));

      if FVersion < '12' then
      begin
        // ancien recalcul
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Traitement des lignes');
        DoLog('');

        res := 1;
        while res > 0 do
        begin
          try
            Transaction.StartTransaction();

            Query.SQL.Text := 'select retour from bn_triggerdiffere;';
            try
              Query.Open();
              if Query.Eof then
                Raise Exception.Create('Pas de retour de "bn_triggerdiffere"')
              else
                res := Query.FieldByName('retour').AsInteger;
            finally
              Query.Close();
            end;

            Transaction.Commit();
          except
            Transaction.Rollback();
            raise;
          end;
          ProgressStepIt();
        end;
      end
      else
      begin
        // nouveau recalcul
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Pre-Traitement');
        DoLog('');

        // Pre-traitement
        try
          Transaction.StartTransaction();

          QUery.SQL.Text := 'execute procedure eai_trigger_pretraite;';
          Query.ExecSQL();

          Transaction.Commit();
        except
          Transaction.Rollback();
          raise;
        end;

        DoLog('/******************************************************************************/');
        ProgressStepLbl('Traitement des lignes');
        DoLog('');

        // boucle de traitement
        res := 1;
        while res > 0 do
        begin
          try
            Transaction.StartTransaction();

            Query.SQL.Text := 'select retour from eai_trigger_differe(500);';
            try
              Query.Open();
              if Query.Eof then
                Raise Exception.Create('Pas de retour de "eai_trigger_differe"')
              else
                res := Query.FieldByName('retour').AsInteger;
            finally
              Query.Close();
            end;

            Transaction.Commit();
          except
            Transaction.Rollback();
            raise;
          end;
          ProgressStepIt();
        end;
      end;

      ReturnValue := 0;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      Connexion.Close();
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 1;
    end;
  end;
end;

constructor TRecalculThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Version : string; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Progress, StepLbl, CreateSuspended);
  FVersion := Version;
end;

function TRecalculThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TBaseGinkoiaThread }

procedure TBaseGinkoiaThread.DecodePlage(S: string; var Deb, fin: integer);
var
  S1: string;
begin
  while not CharInSet(S[1], ['0'..'9']) do
    delete(s, 1, 1);
  S1 := '';
  while CharInSet(S[1], ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    delete(s, 1, 1);
  end;
  deb := Strtoint(S1);
  while not CharInSet(S[1], ['0'..'9']) do
    delete(s, 1, 1);
  S1 := '';
  while CharInSet(S[1], ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    delete(s, 1, 1);
  end;
  fin := Strtoint(S1);
end;

procedure TBaseGinkoiaThread.GetSQLInfo(Text : string; out Table, Champ, Cond : string);
begin
  Table := copy(Text, 1, pos(';', Text) -1);
  delete(Text, 1, pos(';', Text));
  if pos(';', Text) > 0 then
  begin
    Champ := copy(Text, 1, pos(';', Text) -1);
    delete(Text, 1, pos(';', Text));
    Cond := Text;
  end
  else
  begin
    Champ := Text;
    Cond := '';
  end;
end;

procedure TBaseGinkoiaThread.RecupMaxValeur(Query : TMyQuery; SQL, Cond : string; var Valeur : integer);
begin
  try
    query.sql.text := SQL;
    if not (Trim(Cond) = '') then
    begin
      if Pos('WHERE', UpperCase(query.sql.text)) > 0 then
        query.sql.text := query.sql.text + ' and ' + Cond
      else
        query.sql.text := query.sql.text + ' where ' + Cond;
    end;
    query.Open();
    if (not query.eof) and (not query.fields[0].IsNull) and (query.fields[0].Asinteger > Valeur) then
      Valeur := query.fields[0].Asinteger;
    query.Close();
  except
  end;
end;

function TBaseGinkoiaThread.GetGenId(Query : TMyQuery; Plage : string; ini : TInifile) : integer;
var
  i : Integer;
  Deb, Fin : Integer;
  Table, Champ, Cond : string;
begin
  DecodePlage(Plage, Deb, Fin);
  Result := Max(Deb * 1000000, Max(ini.readinteger('GENERAL_ID', 'Min', -9999), 0));
  for i := 1 to ini.readinteger('GENERAL_ID', 'NbTable', 0) do
  begin
    GetSQLInfo(ini.readString('GENERAL_ID', 'Table' + Inttostr(i), ''), Table, Champ, Cond);
    RecupMaxValeur(Query, 'Select Max(' + Champ + ') from ' + table + ' where ' + Champ + ' between ' + Inttostr(Deb)
                        + '*1000000 and ' + Inttostr(Fin) + '*1000000;', Cond, Result);
  end;
end;

constructor TBaseGinkoiaThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Progress, StepLbl, CreateSuspended);
  FIdentBase := 0;
end;

{ TRecupIDThread }

function TRecupIDThread.TraiteGenerateur(Query : TMyQuery; GenName : string; ini : TInifile) : integer;
var
  i, j : Integer;
  Deb, Fin : Integer;
  Methode, Minimum, nbTables : Integer;
  Table, Champ, Cond, Tmp : string;
  Sufixes : TStringList;
  DoWithout : Boolean;
begin
  Methode := ini.readinteger(GenName, 'Def', 0);
  Minimum := ini.readinteger(GenName, 'Min', -9999);
  nbTables := ini.readinteger(GenName, 'NbTable', 0);
  Result := Max(minimum, 0);

  case Methode of
    1: // DEF=1 -> Valeur dans la plage
      begin
        decodeplage(FPlageMagasin, Deb, Fin);
        Result := Max(Deb * 1000000, Result);
        for i := 1 to nbTables do
        begin
          GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
          RecupMaxValeur(Query, 'Select Max(' + Champ + ') from ' + table + ' where ' + Champ + ' between ' + Inttostr(Deb)
                              + '*1000000 and ' + Inttostr(Fin) + '*1000000;', Cond, Result);
        end;
      end;
    2: // DEF=2 -> NumMagasin + '-' + Valeur [+ '*R'] [+ '*F']
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'Select Max( Cast(f_mid (' + champ + ',' + inttoStr(Length(Inttostr(FIdentBase)) + 1)
                            + ',f_bigstringlength(' + champ + ')-' + inttoStr(Length(Inttostr(FIdentBase)) + 3)
                            + ' ) as integer))'
                            + ' from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(FIdentBase) + '-%'''
                            + ' and ' + Champ + ' like ''%R'' ', Cond, Result);
        RecupMaxValeur(Query, 'select Max( Cast(f_mid (' + Champ + ',' + InttoStr(Length(Inttostr(FIdentBase)) + 1) + ',12) as integer)) '
                            + 'from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(FIdentBase) + '-%'' '
                            + 'and not (' + Champ + ' like ''%R'') and not (' + Champ + ' like ''%F'') ', Cond, Result);
      end;
    3: // DEF=3 -> Valeur
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'Select Max(' + Champ + ') from ' + table, Cond, Result);
      end;
    4: // DEF=4 -> Code Barre ('2' + NumMag sur 3 chiffre + generateur + chiffre de control)
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);

        try
          Tmp := Format('%.3d', [FIdentBase]);
          query.SQL.Text := 'Select Max(' + Champ + ') from ' + Table + ' Where (' + Champ + ' like ''2' + Tmp + '%'') ';
          if Cond <> '' then
            query.sql.Add('AND ' + Cond);
          query.Open();
          if not (query.fields[0].IsNull) then
          begin
            Tmp := query.fields[0].AsString;
            Delete(Tmp, 1, 4);
            Delete(Tmp, length(Tmp), 1);
            Result := Max(Result, StrToIntDef(Tmp, Result));
          end;
          query.Close();
        except
        end;
      end;
    5: // DEF=5 -> NumMagasin + '-' + 'M' + Valeur // Modèle de facture
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'select Max(Cast(f_mid (' + Champ + ',' + InttoStr(Length(Inttostr(FIdentBase)) + 2) + ',12) as integer)) '
                            + 'from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(FIdentBase) + '-%''', Cond, Result);
      end;
    6: // DEF=6 -> mettre a 0
      Result := 0;
    7: // DEF=7 -> Pas touche !!
      Result := -1;
    8: // DEF=8 -> NumMagasin + '-' + Valeur + '*F' // Facture de retro
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, ' Select Max( Cast(f_mid (' + Champ + ',' + inttoStr(Length(Inttostr(FIdentBase)) + 1)
                            + ',f_bigstringlength(' + Champ + ')-' + inttoStr(Length(Inttostr(FIdentBase)) + 3)
                            + ') as integer))'
                            + ' from ' + table + ' where ' + Champ + ' Like ''' + Inttostr(FIdentBase) + '-%'''
                            + ' and ' + Champ + ' like ''%F'' ', Cond, Result);
      end;
    9: // DEF=9 -> BP du web : site sur 4 caractères + '-' + NumMag + '-' + sequence
      for i := 1 to nbTables do
      begin
        GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
        RecupMaxValeur(Query, 'select max(cast(substr(' + Champ + ', ' + inttoStr(Length(Inttostr(FIdentBase)) + 7) + ', f_bigstringlength(' + Champ + ')) as integer)) '
                            + 'from ' + table + ' '
                            + 'where ' + Champ + ' like ''____-' + Inttostr(FIdentBase) + '-%'' ', Cond, Result);
      end;
    10: // DEF=10 -> Interclub : NumMagasin + '-' + Valeur + Terminaisons en paramètres
      begin
        try
          Sufixes := TStringList.Create();
          Sufixes.Delimiter := ';';
          Sufixes.DelimitedText := ini.ReadString(GenName, 'Sufixes', '');
          DoWithout := ini.ReadBool(GenName, 'DoWithout', true);

          for i := 1 to nbTables do
          begin
            GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);

            Tmp := 'select Max(Cast(' + #10#13;
            for j := 0 to Sufixes.Count - 1 do
              if j = 0 then
                Tmp := Tmp + '  case when ' + Champ + ' like ''%' + Sufixes[j] + ''' then SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(FIdentBase)) + 2)
                  + ', f_bigstringlength(' + Champ + ') - ' + IntToStr(Length(Sufixes[j])) + ')' + #10#13
              else
                Tmp := Tmp + '       when ' + Champ + ' like ''%' + Sufixes[j] + ''' then SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(FIdentBase)) + 2)
                  + ', f_bigstringlength(' + Champ + ') - ' + IntToStr(Length(Sufixes[j])) + ')' + #10#13;
            if DoWithout then
              Tmp := Tmp + '       else SubStr(' + Champ + ', ' + inttoStr(Length(Inttostr(FIdentBase)) + 2) + ', f_bigstringlength(' + Champ + '))' + #10#13;
            Tmp := Tmp + '  end as integer))' + #10#13
                       + 'from ' + table + #10#13;
            if DoWithout then
              Tmp := Tmp + 'where ' + Champ + ' like ''' + Inttostr(FIdentBase) + '-%'''
            else
            begin
              for j := 0 to Sufixes.Count - 1 do
                if j = 0 then
                  Tmp := Tmp + 'where (' + Champ + ' like ''' + Inttostr(FIdentBase) + '-%' + Sufixes[j] + '''' + #10#13
                else
                  Tmp := Tmp + '       or ' + Champ + ' like ''' + Inttostr(FIdentBase) + '-%' + Sufixes[j] + '''' + #10#13;
              Tmp := Tmp + '  )';
            end;

            RecupMaxValeur(Query, Tmp, Cond, Result);
          end;
        finally
          FreeAndNil(Sufixes);
        end;
      end;
    11: // DEF = 11 -> Acompte Web
      begin
        for i := 1 to nbTables do
        begin
          GetSQLInfo(ini.readString(GenName, 'Table' + Inttostr(i), ''), Table, Champ, Cond);
          RecupMaxValeur(Query, 'select max(cast(f_mid(' + Champ + ' ,10,7) as integer)) from ' + Table + ' where %0:s starting with ' + QuotedStr('AC :') + ';', Cond, Result);
        end;
      end;
    else
      Result := -2;
  end;
end;

procedure TRecupIDThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Erreur de Téléchargement du fichier
// 2 - IDGENERATEUR non trouver
// 3 - Plages non trouver
// 4 - Exception
// 5 - Autre erreur
var
  DestPath : string;
  ini : TIniFile;
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  QueryLst, QueryAsk, QueryMaj : TMyQuery;
  Res : integer;
begin
  ReturnValue := 5;
  ProgressStyle(pbstMarquee);

  try
    try
      DestPath := GetTempDirectory();
      ForceDirectories(DestPath);

      // recup du fichier de definition !
      if DownloadHTTP(URL_SERVEUR_MAJ + '/maj/GINKOIA/recupbase.ini', IncludeTrailingPathDelimiter(DestPath) + 'recupbase.ini') then
      begin
        try
          Ini := TIniFile.Create(IncludeTrailingPathDelimiter(DestPath) + 'recupbase.ini');

          // recalcup des geénérateur
          try
            Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
            Transaction := GetNewTransaction(Connexion, false);

            Connexion.Open();
            Transaction.StartTransaction();

            try
              QueryLst := GetNewQuery(Connexion, Transaction);
              QueryAsk := GetNewQuery(Connexion, Transaction);
              QueryMaj := GetNewQuery(Connexion, Transaction);

              DoLog('/******************************************************************************/');
              ProgressStepLbl('Recalcul des Générateurs');
              DoLog('');

              DoLog('Récupération du numero de base');

              // recupération du numero de base
              QueryLst.SQL.Text := 'select cast(par_string as integer) as nummagasin from genparambase where par_nom = ''IDGENERATEUR'';';
              try
                QueryLst.Open();
                if QueryLst.Eof then
                begin
                  ReturnValue := 2;
                  Exit;
                end
                else
                  FIdentBase := QueryLst.FieldByName('nummagasin').AsInteger;
              finally
                QueryLst.Close();
              end;

              DoLog('  -> ' + IntToStr(FIdentBase));
              DoLog('Récupération de la plage magasin');

              // recupération des plages
              QueryLst.SQL.Text := 'select cast(bas_ident as integer) as nummagasin, bas_plage from genbases join k on k_id = bas_id and k_enabled = 1 where bas_ident = ' + QuotedStr(IntToStr(FIdentBase)) + ';';
              try
                QueryLst.Open();
                if QueryLst.Eof then
                begin
                  ReturnValue := 3;
                  Exit;
                end
                else
                  FPlageMagasin := QueryLst.FieldByName('bas_plage').AsString;
              finally
                QueryLst.Close();
              end;

              DoLog('  -> ' + FPlageMagasin);
              DoLog('Listing des générateurs');

              // selection des génénrateur
              QueryLst.SQL.Text := 'select rdb$generator_name as name from rdb$generators where rdb$system_flag is null or rdb$system_flag = 0';
              try
                QueryLst.Open();
                QueryLst.FetchAll();

                // init progress bar !
                ProgressInit(QueryLst.RecordCount);

                while not QueryLst.Eof do
                begin
                  ProgressStepLbl('Traitement du générateur "' + QueryLst.FieldByName('name').AsString + '"...');
                  Res := TraiteGenerateur(QueryAsk, QueryLst.FieldByName('name').AsString, ini);
                  Case Res of
                    -2 : DoLog('  ' + QueryLst.FieldByName('name').AsString + ' : Non pris en charge');
                    -1 : DoLog('  ' + QueryLst.FieldByName('name').AsString + ' : Ne pas changer');
                    else
                      begin
                        DoLog('  ' + QueryLst.FieldByName('name').AsString + ' : ' + Inttostr(Res));
                        QueryMaj.SQL.Text := 'SET GENERATOR ' + QueryLst.FieldByName('name').AsString + ' to ' + Inttostr(res) + ';';
                        QueryMaj.ExecSQL();
                      end;
                  end;
                  QueryLst.Next();
                  ProgressStepIt();
                end;
              finally
                QueryLst.Close();
              end;

              Transaction.Commit();
              ReturnValue := 0;
            except
              Transaction.Rollback();
              raise;
            end;
          finally
            FreeAndNil(QueryLst);
            FreeAndNil(QueryAsk);
            FreeAndNil(QueryMaj);
            FreeAndNil(Transaction);
            Connexion.Close();
            FreeAndNil(Connexion);
          end;
        finally
          FreeAndNil(ini);
        end;
      end
      else
        ReturnValue := 1;
    finally
      // suppression du repertoire !
      DelTree(DestPath);
    end;
  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 4;
    end;
  end;
end;

constructor TRecupIDThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Progress, StepLbl, CreateSuspended);
  FIdentBase := 0;
  FPlageMagasin := '';
end;

function TRecupIDThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Erreur lors de la récupération du fichier des règles de recalcul';
    2 : Result := 'Numéro de générateur non trouvé';
    3 : Result := 'Plage d''ID non trouvé';
    4 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TGenerateurThread }

procedure TGenerateurThread.Execute();
// code de retour :
// 0 - reussite
// 4 - Exception
// 5 - Autre erreur
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  Query : TMyQuery;
begin
  ReturnValue := 5;
  ProgressStyle(pbstMarquee);

  try
    try
      Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
      Transaction := GetNewTransaction(Connexion, false);

      Connexion.Open();
      Transaction.StartTransaction();

      try
        Query := GetNewQuery(Connexion, Transaction);

        DoLog('/******************************************************************************/');
        DoLog('Gestion du Générateur');
        DoLog('');

        DoLog('Modification de l''IDENT : ' + IntToStr(FIdentBase));

        // modification du generateur
        Query.SQL.Text := 'update genparambase set par_string = ' + QuotedStr(IntToStr(FIdentBase)) + ' where par_nom = ''IDGENERATEUR''';
        Query.ExecSQL();

        DoLog('Activation/deactiovation des triggers différés');

        // activation ou non des triggers ! (base de pantin -> desactivation des trigger ; base magasin -> activation des trigger)
        Query.SQL.Text := 'execute procedure BN_ACTIVETRIGGER (' + IntToStr(Min(FIdentBase, 1)) + ');';
        Query.ExecSQL();

        Transaction.Commit();
        ReturnValue := 0;
      except
        Transaction.Rollback();
        raise;
      end;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      Connexion.Close();
      FreeAndNil(Connexion);
    end;

    // si on arrive ici ...
    // selo le cas on recalcul ou pas !
    if FDoRecalc then
      inherited Execute();

  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 4;
    end;
  end;
end;

constructor TGenerateurThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; IdentBase : integer; DoRecalc : boolean; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Progress, StepLbl, CreateSuspended);
  FIdentBase := IdentBase;
  FDoRecalc := DoRecalc;
end;

end.
