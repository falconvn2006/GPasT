unit UPatchThread;

interface

uses
  System.Classes,
  FireDAC.Comp.Client,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  UBaseThread,
  uCreateProcess,
  uGestionBDD;

type
  TBasePatchThread = class(TBaseIBThread)
  protected
    FGUID : string;
    FDoAll, FDoMaj : boolean;

    FMinPatch, FMaxPatch : integer;
    FSeparateur : string;
    FIdClient : integer;
    FBlockMaj : boolean;

    function GetNomFichier(numPatch : integer) : string; virtual;

    function GetNbPatch(out NbPatch : integer) : boolean; virtual; abstract;
    function DownloadPatch(DestPath : string) : boolean; virtual; abstract;

    procedure DoMajPatch(valeur : integer; Reussite : boolean); virtual;
    procedure DoMajVersion(Connexion : TMyConnection; Transaction : TMyTransaction; valeur : string; Reussite : boolean); virtual;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; GUID : string; DoAll, DoMaj : boolean; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TScriptVersionThread = class(TBasePatchThread)
  protected
    FOldVersion, FNewVersion : string;
    FIdOldVersion, FIdNewVersion : integer;

    function GetNbPatch(out NbPatch : integer) : boolean; override;
    function DownloadPatch(DestPath : string) : boolean; override;

    procedure DoMajVersion(Connexion : TMyConnection; Transaction : TMyTransaction; valeur : string; Reussite : boolean); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; GUID, OldVersion, NewVersion : string; DoMaj : boolean; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
  end;

  TPatchVersionThread = class(TBasePatchThread)
  protected
    FVersion : string;

    function GetNbPatch(out NbPatch : integer) : boolean; override;
    function DownloadPatch(DestPath : string) : boolean; override;

    procedure DoMajPatch(valeur : integer; Reussite : boolean); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; GUID, Version : string; DoAll, DoMaj : boolean; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
  end;

  TPatchSpecifiqueThread = class(TBasePatchThread)
  protected
    function GetNbPatch(out NbPatch : integer) : boolean; override;
    function DownloadPatch(DestPath : string) : boolean; override;

    procedure DoMajPatch(valeur : integer; Reussite : boolean); override;
  end;

  TDesPatchThread = class(TBasePatchThread)
  protected
    FFileNames : TSTringList;

    function GetNbPatch(out NbPatch : integer) : boolean; override;
    function DownloadPatch(DestPath : string) : boolean; override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; GUID : string; FileNames : TSTringList; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    Destructor Destroy(); override;
  end;

  TEnreg0Thread = class(TBaseIBThread)
  protected
    procedure Execute(); override;
  public
    function GetErrorLibelle(ret : integer) : string; override;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.SysUtils,
  System.StrUtils,
  uFileUtils,
  uYellis,
  uPatch,
  uVersionInfo;

{ TBasePatchThread }

function TBasePatchThread.GetNomFichier(numPatch : integer) : string;
begin
  Result := 'script' + IntToStr(numPatch) + '.sql'
end;

procedure TBasePatchThread.DoMajPatch(valeur : integer; Reussite : boolean);
begin
  // Do Nothing, Herited
end;

procedure TBasePatchThread.DoMajVersion(Connexion : TMyConnection; Transaction : TMyTransaction; valeur : string; Reussite : boolean);
begin
  // Do Nothing, Herited
end;

procedure TBasePatchThread.Execute();
// code de retour :
// 0 - reussite
// 1 - pas de BDD
// 2 - pas de GUID
// 3 - Erreur de recuperation du nombre de patch
// 4 - pas de patch a faire
// 5 - Erreur de telechargement des patch
// 6 - Erreur d'application d'un patch
// x - Erreur de gestion des enregistrement zero -> pas reelement d'erreur !
// 7 - Exception
// 8 - Autre erreur
var
  DestPath : string;
  NbFiles, i : integer;
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  LastSep : string;
  tmpLogs : TStringList;
begin
  ReturnValue := 8;
  ProgressStyle(pbstMarquee);

  try
    CoInitialize(nil);

    try
      try
        DestPath := GetTempDirectory();
        ForceDirectories(DestPath);

        DoLog('/******************************************************************************/');
        DoLog('Recuperation du nombre de patch');
        DoLog('');

        if GetNbPatch(NbFiles) then
        begin
          DoLog(IntToStr(NbFiles) + ' fichiers');

          if NbFiles > 0 then
          begin
            ProgressInit(NbFiles * 2 +1);

            DoLog('/******************************************************************************/');
            DoLog('Téléchargement des patchs');
            DoLog('');

            if DownloadPatch(DestPath) then
            begin
              DoLog('/******************************************************************************/');
              DoLog('Application des patchs');
              DoLog('');

              // application des patch !!
              try
                Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
                Transaction := GetNewTransaction(Connexion, false);

                Connexion.Open();

                try
                  tmpLogs := TStringList.Create();
                  for i := FMinPatch to FMaxPatch do
                  begin
                    ProgressStepLbl('Passage du fichier ' + GetNomFichier(i) + '...');
                    if DoPatch(Connexion, Transaction, DestPath + GetNomFichier(i), FSeparateur, LastSep, tmpLogs, ProgressStepLbl) then
                    begin
                      DoMajPatch(i, true);
                      ProgressStepLbl('');
                    end
                    else
                    begin
                      DoMajPatch(i, false);
                      ProgressStepLbl('');
                      DoMajVersion(Connexion, Transaction, LastSep, false);
                      ReturnValue := 6;
                      Exit;
                    end;
                    ProgressStepIt();
                  end;
                finally
                  DoLog(tmpLogs);
                  FreeAndNil(tmpLogs);
                end;

                // si ici ;)
                ProgressStepLbl('Marquage de la mise-à-jour...');
                DoLog('/******************************************************************************/');
                DoLog('Marquage de la mise-à-jour');
                DoLog('');
                DoMajVersion(Connexion, Transaction, LastSep, true);
                ProgressStepIt();
              finally
                FreeAndNil(Transaction);
                FreeAndNil(Connexion);
              end;
              ReturnValue := 0;
            end
            else
              ReturnValue := 5;
          end
          else
            ReturnValue := 4;
        end
        else
          ReturnValue := 3;
      finally
        // suppression du repertoire !
        DelTree(DestPath);
      end;
    except
      on e : Exception do
      begin
        DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        ReturnValue := 7;
      end;
    end;
  finally
    CoUninitialize();
  end;
end;

constructor TBasePatchThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; GUID : string; DoAll, DoMaj : boolean; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Progress, StepLbl, CreateSuspended);
  FSeparateur := '<---->';
  FGUID := GUID;
  FDoAll := DoAll;
  FDoMaj := DoMaj;
end;

function TBasePatchThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'GUID non trouvé.';
    2 : Result := 'Erreur lors de la recupération du nombre de patch.';
    3 : Result := 'Pas de patch a passer.';
    4 : Result := 'Erreur lors du téléchargement des patchs.';
    5 : Result := 'Erreur lors de l''application des patchs.';
    6 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TScriptVersionThread }

function TScriptVersionThread.GetNbPatch(out NbPatch : integer) : boolean;
var
  Yellis : Tconnexion;
  Res : TStringList;
begin
  Result := true;
  Res := nil;
  NbPatch := 1;
  FMinPatch := 1;
  FMaxPatch := 1;

  try
    try
      Yellis := Tconnexion.Create();
      try
        Res := Yellis.Select('select id, blockmaj, version from clients where clt_guid = ' + QuotedStr(FGUID) + ';');
        FIdClient := StrToIntDef(Trim(Yellis.UneValeur(Res, 'id', 0)), 0);
        FBlockMaj := StrToIntDef(Trim(Yellis.UneValeur(Res, 'blockmaj', 0)), 0) = 1;
        FIdOldVersion := StrToIntDef(Trim(Yellis.UneValeur(Res, 'version', 0)), 0);
      finally
        Yellis.FreeResult(Res);
      end;
      DoLog('Information Yellis de la base :');
      DoLog(' - id : ' + IntToStr(FIdClient));
      DoLog(' - blockmaj : ' + BoolToStr(FBlockMaj, true));
      DoLog(' - version : ' + IntToStr(FIdOldVersion));
      if IndexText(ExtractFileExt(FNewVersion), ['.SCR', '.SQL']) >= 0 then
      begin
        DoLog('Fichier local...');
        FDoMaj := false;
      end
      else
      begin
        try
          Res := Yellis.Select('select id from version where nomversion = ' + QuotedStr(FNewVersion) + ';');
          FIdNewVersion := StrToIntDef(Trim(Yellis.UneValeur(Res, 'id', 0)), 0);
        finally
          Yellis.FreeResult(Res);
        end;
        DoLog('Id de la nouvelle version : ' + IntToStr(FIdNewVersion));
      end;
    finally
      FreeAndNil(Yellis);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TScriptVersionThread.DownloadPatch(DestPath : string) : boolean;
var
  OldFichier, NewFichier : TStringList;
  Idx, i : integer;
begin
  result := false;

  // telechargement du script
  try
    ProgressStepLbl('Téléchargement du fichier Script.scr...');

    if IndexText(ExtractFileExt(FNewVersion), ['.SCR', '.SQL']) >= 0 then
    begin
      if IndexText(Copy(FNewVersion, 1, Pos(':', FNewVersion)-1 ), ['http', 'https']) >= 0 then
      begin
        DoLog('Téléchargement du fichier : "' + FNewVersion + '"');
        if not DownloadHTTP(FNewVersion, DestPath + 'Script1.sql') then
        begin
          DoLog('  -> Failed...');
          Exit;
        end;
      end
      else
      begin
        DoLog('Utilisation du fichier : "' + FNewVersion + '"');
        if not CopyFile(PWideChar(FNewVersion), PWideChar(DestPath + 'Script1.sql'), true) then
        begin
          DoLog('  -> Failed...');
          Exit;
        end;
      end;
    end
    else
    begin
      DoLog('Téléchargement de : "' + URL_SERVEUR_MAJ + '/maj/' + FNewVersion + '/SCRIPT.SCR" vers "' + DestPath + 'Script1.sql"');
      // Telechargement
      if not DownloadHTTP(URL_SERVEUR_MAJ + '/maj/' + FNewVersion + '/SCRIPT.SCR', DestPath + 'Script1.sql') then
      begin
        DoLog('  -> Failed...');
        Exit;
      end;
    end;

    // decoupage du fichier, ne garder que la partie util
    try
      OldFichier := TStringList.Create();
      OldFichier.LoadFromFile(DestPath + 'Script1.sql');
      NewFichier := TStringList.Create();
      // recherche de la release qui vas bien
      Idx := OldFichier.IndexOf('<RELEASE>' + FOldVersion) +1;
      if Idx > 0 then
      begin
        while not (Trim(Copy(OldFichier[Idx], 1, 9)) = '<RELEASE>') do
          Inc(Idx);
        Inc(Idx);
        // copier a partir de la release qui va bien !
        for i := Idx to OldFichier.Count -1 do
          NewFichier.Add(OldFichier[i]);
        // maintenant... cherché le prochain release
        NewFichier.SaveToFile(DestPath + 'Script1.sql');
        // fin :)
        Result := true;
      end
      else
        DoLog('Numéro de release non trouvé !!');
    finally
      FreeAndNil(OldFichier);
      FreeAndNil(NewFichier);
    end;
    ProgressStepIt();
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

procedure TScriptVersionThread.DoMajVersion(Connexion : TMyConnection; Transaction : TMyTransaction; valeur : string; Reussite : boolean);
var
  Query : TMyQuery;
  Yellis : Tconnexion;
begin
  try
    if not (Trim(valeur) = '')then
    begin
      try
        Query := GetNewQuery(Connexion, Transaction);
        try
          DoLog('Mise-à-jour de la table "GENVERSION"');
          Transaction.StartTransaction();
          Query.SQL.Text := 'insert into genversion (ver_date, ver_version) values (current_timestamp, ' + QuotedStr(valeur) + ')';
          Query.ExecSQL();
          Transaction.Commit();
        except
          begin
            Transaction.Rollback();
            raise;
          end;
        end;
      finally
        FreeAndNil(Query);
      end;
    end;

    if FDoMaj then
    begin
      try
        Yellis := Tconnexion.Create();
        if Reussite then
        begin
          DoLog('Mise-à-jour de Yellis');
          Yellis.ordre('update clients set version = ' + IntToStr(FIdNewVersion) + ', patch = 0 where id = ' + IntToStr(FIdClient));
          Yellis.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) values (' + IntToStr(FIdClient) + ', "' + Yellis.DateTime(Now()) + '", 2, "Maj de la version par le client", "", "", "")');
        end
        else
          DoLog('Pas de mise-à-jour de Yellis, echec !');
      finally
        FreeAndNil(Yellis);
      end;
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

constructor TScriptVersionThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; GUID, OldVersion, NewVersion : string; DoMaj : boolean; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, GUID, true, DoMaj, Progress, StepLbl, CreateSuspended);
  FSeparateur := '<RELEASE>';
  FOldVersion := OldVersion;
  FNewVersion := NewVersion;
  FIdNewVersion := 0;
end;

{ TPatchVersionThread }

function TPatchVersionThread.GetNbPatch(out NbPatch : integer) : boolean;
var
  Yellis : Tconnexion;
  Res : TStringList;
begin
  Result := false;
  NbPatch := 0;
  Res := nil;

  // recup du nombre de patch
  try
    try
      Yellis := Tconnexion.Create();
      try
        Res := Yellis.Select('select id, blockmaj, patch from clients where clt_guid = ' + QuotedStr(FGUID) + ';');
        FIdClient := StrToIntDef(Trim(Yellis.UneValeur(Res, 'id', 0)), 0);
        FBlockMaj := StrToIntDef(Trim(Yellis.UneValeur(Res, 'blockmaj', 0)), 0) = 1;
        if FDoAll then
          FMinPatch := 1
        else
          FMinPatch := StrToIntDef(Trim(Yellis.UneValeur(Res, 'patch', 0)), 0) +1;
        DoLog('Information Yellis de la base :');
        DoLog(' - id : ' + IntToStr(FIdClient));
        DoLog(' - blockmaj : ' + BoolToStr(FBlockMaj, true));
        DoLog(' - niveau de patch : ' + Yellis.UneValeur(Res, 'patch', 0));
        DoLog('Niveau de depart des patch : ' + IntToStr(FMinPatch));
      finally
        Yellis.FreeResult(Res);
      end;
      try
        Res := Yellis.Select('Select patch from version where nomversion = ' + QuotedStr(GetYellisVersion(FVersion)) + ';');
        FMaxPatch := StrToIntDef(Trim(Yellis.UneValeur(Res, 'patch', 0)), 0);
      finally
        Yellis.FreeResult(Res);
      end;
      DoLog('Nombre de patchs de la version : ' + IntToStr(FMaxPatch));

      Result := true;
      NbPatch := FMaxPatch - FMinPatch +1;
    finally
      FreeAndNil(Yellis);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TPatchVersionThread.DownloadPatch(DestPath : string) : boolean;
var
  i : integer;
begin
  result := false;

  // telechargement des patch (s'il y en a)
  try
    for i := FMinPatch to FMaxPatch do
    begin
      ProgressStepLbl('Téléchargement du fichier ' + GetNomFichier(i) + '...');
      DoLog('Téléchargement de : "' + URL_SERVEUR_MAJ + '/maj/patch/' + GetYellisVersion(FVersion) + '/script' + Inttostr(i) + '.sql" vers "' + DestPath + 'script' + Inttostr(i) + '.sql"');
      if not DownloadHTTP(URL_SERVEUR_MAJ + '/maj/patch/' + GetYellisVersion(FVersion) + '/script' + Inttostr(i) + '.sql', DestPath + 'script' + Inttostr(i) + '.sql') then
      begin
        DoLog('  -> Failed...');
        Exit;
      end;
      ProgressStepIt();
    end;
    Result := true;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

procedure TPatchVersionThread.DoMajPatch(valeur : integer; Reussite : boolean);
var
  Yellis : Tconnexion;
begin
  try
    if FDoMaj then
    begin
      try
        Yellis := Tconnexion.Create();
        if Reussite then
        begin
          DoLog('Mise-à-jour de Yellis : reussite');
          Yellis.ordre('update clients set patch = ' + Inttostr(valeur) + ' where id = ' + IntToStr(FIdClient));
          Yellis.ordre('insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) values (' + IntToStr(FIdClient) + ', "' + Yellis.DateTime(Now()) + '", 4, "script' + Inttostr(valeur) + '.SQL", "' + FDataBase + '", "", "")');
          Yellis.ordre('update histo set fait = 1 where action = 5 and id_cli = ' + IntToStr(FIdClient));
        end
        else
        begin
          DoLog('Mise-à-jour de Yellis : echec');
          Yellis.ordre('insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) values (' + IntToStr(FIdClient) + ', "' + Yellis.DateTime(Now()) + '", 5, "script' + Inttostr(valeur) + '.SQL", "' + FDataBase + '", "Problème", "")');
        end;
      finally
        FreeAndNil(Yellis);
      end;
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

constructor TPatchVersionThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; GUID, Version : string; DoAll, DoMaj : boolean; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, GUID, DoAll, DoMaj, Progress, StepLbl, CreateSuspended);
  FVersion := Version;
end;

{ TPatchSpecifiqueThread }

function TPatchSpecifiqueThread.GetNbPatch(out NbPatch : integer) : boolean;
var
  Yellis : TConnexion;
  Res : TStringList;
begin
  Result := false;
  NbPatch := 0;
  Res := nil;

  // recup du nombre de patch
  try
    try
      Yellis := Tconnexion.Create();
      Res := Yellis.Select('select id, blockmaj, spe_patch, spe_fait from clients where clt_guid = ' + QuotedStr(FGUID) + ';');
      FIdClient := StrToIntDef(Trim(Yellis.UneValeur(Res, 'id', 0)), 0);
      FBlockMaj := StrToIntDef(Trim(Yellis.UneValeur(Res, 'blockmaj', 0)), 0) = 1;
      FMaxPatch := StrToIntDef(Trim(Yellis.UneValeur(Res, 'spe_patch', 0)), 0);
      if FDoAll then
        FMinPatch := 1
      else
        FMinPatch := StrToIntDef(Trim(Yellis.UneValeur(Res, 'spe_fait', 0)), 0) +1;
      DoLog('Information Yellis de la base :');
      DoLog(' - id : ' + IntToStr(FIdClient));
      DoLog(' - blockmaj : ' + BoolToStr(FBlockMaj, true));
      DoLog(' - niveau de patch : ' + Trim(Yellis.UneValeur(Res, 'spe_fait', 0)));
      DoLog('Niveau de depart des patch : ' + IntToStr(FMinPatch));
      DoLog('Nombre de patchs de la version : ' + IntToStr(FMaxPatch));

      Result := true;
      NbPatch := FMaxPatch - FMinPatch +1;
    finally
      Yellis.FreeResult(Res);
      FreeAndNil(Yellis);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TPatchSpecifiqueThread.DownloadPatch(DestPath : string) : boolean;
var
  i : integer;
begin
  result := false;

  // telechargement des patch (s'il y en a)
  try
    for i := FMinPatch to FMaxPatch do
    begin
      ProgressStepLbl('Téléchargement du fichier ' + GetNomFichier(i) + '...');
      DoLog('Téléchargement de : "' + URL_SERVEUR_MAJ + '/maj/patch/' + FGUID + '/script' + Inttostr(i) + '.sql" vers "' + DestPath + 'script' + Inttostr(i) + '.sql"');
      if not DownloadHTTP(URL_SERVEUR_MAJ + '/maj/patch/' + FGUID + '/script' + Inttostr(i) + '.sql', DestPath + 'script' + Inttostr(i) + '.sql') then
      begin
        DoLog('  -> Failed...');
        Exit;
      end;
      ProgressStepIt();
    end;
    Result := true;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

procedure TPatchSpecifiqueThread.DoMajPatch(valeur : integer; Reussite : boolean);
var
  Yellis : Tconnexion;
begin
  try
    if FDoMaj then
    begin
      try
        Yellis := Tconnexion.Create();
        if Reussite then
        begin
          Yellis.ordre('update clients set spe_fait = ' + Inttostr(valeur) + ' where id = ' + IntToStr(FIdClient));
          Yellis.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) values (' + IntToStr(FIdClient) + ', "' + Yellis.DateTime(Now()) + '", 7, "script' + Inttostr(valeur) + '.SQL","' + FDataBase + '", "", "")');
          Yellis.ordre('update histo set fait = 1 where action = 8 and id_cli = ' + IntToStr(FIdClient));
        end
        else
        begin
          Yellis.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) values (' + IntToStr(FIdClient) + ', "' + Yellis.DateTime(Now()) + '", 8, "script' + Inttostr(valeur) + '.SQL", "' + FDataBase + '", "Problème", "")');
        end;
      finally
        FreeAndNil(Yellis);
      end;
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

{ TDesPatchThread }

function TDesPatchThread.GetNbPatch(out NbPatch : integer) : boolean;
begin
  Result := true;
  NbPatch := FFileNames.Count;
  FMinPatch := 1;
  FMaxPatch := FFileNames.Count;
end;

function TDesPatchThread.DownloadPatch(DestPath : string) : boolean;
var
  i : integer;
begin
  Result := false;
  try
    for i := FMinPatch to FMaxPatch do
    begin
      if IndexText(Copy(FFileNames[i-1], 1, Pos(':', FFileNames[i-1])-1 ), ['http', 'https']) >= 0 then
      begin
        DoLog('Téléchargement du fichier : "' + FFileNames[i-1] + '"');
        if not DownloadHTTP(FFileNames[i-1], DestPath + 'Script' + IntToStr(i) + '.sql') then
        begin
          DoLog('  -> Failed...');
          Exit;
        end;
      end
      else
      begin
        DoLog('Utilisation du fichier : "' + FFileNames[i-1] + '"');
        if not CopyFile(PWideChar(FFileNames[i-1]), PWideChar(DestPath + 'Script' + IntToStr(i) + '.sql'), true) then
        begin
          DoLog('  -> Failed...');
          Exit;
        end;
      end;
      ProgressStepIt();
    end;
    Result := true;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

constructor TDesPatchThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; GUID : string; FileNames : TStringList; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, GUID, true, false, Progress, StepLbl, CreateSuspended);
  FFileNames := TStringList.Create();
  FFileNames.AddStrings(FileNames);
end;

destructor TDesPatchThread.Destroy();
begin
  FreeAndNil(FFileNames);
  Inherited Destroy();
end;

{ TEnreg0Thread }

procedure TEnreg0Thread.Execute();

  function GetValueFromDB(Query : TMyQuery) : string;
  begin
    case Query.FieldByName('rdb$field_type').AsInteger of
      07 : result := '0';
      08 : result := '0';
      09 : result := '0';
      10 : result := '0';
      11 : result := '0';
      12 : result := QuotedStr('1899-12-30');
      13 : result := QuotedStr('00:00:00.000');
      14 : result := QuotedStr('');
      16 : result := '0';
      27 : result := '0';
      35 : result := QuotedStr('1899-12-30 00:00:00.000');
      37 : result := QuotedStr('');
      40 : result := QuotedStr('');
      261 : result := 'null';
      else result := 'null';
    end;
  end;

// code de retour :
// 0 - reussite
// 1 - Exception
// 2 - Autre erreur
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  QueryTables, QueryChamps, QueryEnreg : TMyQuery;
  HasEnreg : boolean;
  FiledsName, FieldsValue : string;
begin
  ReturnValue := 2;
  ProgressStyle(pbstMarquee);

  Connexion := nil;
  Transaction := nil;
  QueryTables := nil;
  QueryChamps := nil;
  QueryEnreg := nil;

  try
    CoInitialize(nil);

    try
      try
        Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
        Transaction := GetNewTransaction(Connexion, false);
        QueryTables := GetNewQuery(Connexion, Transaction);
        QueryChamps := GetNewQuery(Connexion, Transaction);
        QueryEnreg := GetNewQuery(Connexion, Transaction);

        Connexion.Open();
        Transaction.StartTransaction();

        try
          DoLog('/******************************************************************************/');
          ProgressStepLbl('Recuperation de la liste des tables');
          DoLog('');

          QueryTables.SQL.Text := 'select rdb$relation_name, rdb$field_name, rdb$field_source '
                                + 'from rdb$relation_fields join rdb$relations on rdb$relations.rdb$relation_name = rdb$relation_fields.rdb$relation_name '
                                + 'where rdb$system_flag = 0 and rdb$field_position = 0 and rdb$relation_type = ''PERSISTENT'' '
                                + 'order by rdb$relation_name;';
          try
            QueryTables.Open();
            QueryTables.FetchAll();

            // init progress bar !
            ProgressInit(QueryTables.RecordCount);

            DoLog('/******************************************************************************/');
            ProgressStepLbl('Vérification des tables');
            DoLog('');

            while not QueryTables.Eof do
            begin
              ProgressStepLbl('Traitement de la table "' + QueryTables.FieldByName('rdb$relation_name').AsString + '"...');
              if trim(QueryTables.FieldByName('rdb$field_source').AsString) = 'ALGOL_KEY' then
              begin
                // init !
                HasEnreg := false;
                FiledsName := '';
                FieldsValue := '';

                // recherche de l'enregistrement 0
                QueryEnreg.SQL.Text := 'select ' + QueryTables.FieldByName('rdb$field_name').AsString
                                     + ' from ' + QueryTables.FieldByName('rdb$relation_name').AsString
                                     + ' where ' + QueryTables.FieldByName('rdb$field_name').AsString + ' = 0;';
                try
                  QueryEnreg.Open();
                  HasEnreg := not QueryEnreg.Eof;
                finally
                  QueryEnreg.Close();
                end;
                // pas d'enregistrement 0 ???
                if not HasEnreg then
                begin
                  DoLog('Pas d''enregistrement 0 sur la table : ' + QueryTables.FieldByName('rdb$relation_name').AsString);
                  // recuperation de la structure de table pour l'insertion
                  QueryChamps.SQL.Text := 'select r.rdb$field_name, f.rdb$field_type '
                                        + 'from rdb$relation_fields r join rdb$fields f on f.rdb$field_name = r.rdb$field_source '
                                        + 'where rdb$system_flag = 0 and rdb$relation_name = ' + QuotedStr(QueryTables.FieldByName('rdb$relation_name').AsString) + ' '
                                        + 'order by rdb$field_position;';
                  try
                    QueryChamps.Open();
                    while not QueryChamps.Eof do
                    begin
                      if FiledsName = '' then
                        FiledsName := QueryChamps.FieldByName('rdb$field_name').AsString
                      else
                        FiledsName := FiledsName + ', ' + QueryChamps.FieldByName('rdb$field_name').AsString;
                      if FieldsValue = '' then
                        FieldsValue := GetValueFromDB(QueryChamps)
                      else
                        FieldsValue := FieldsValue + ', ' + GetValueFromDB(QueryChamps);
                      QueryChamps.Next();
                    end;
                  finally
                    QueryChamps.Close();
                  end;
                  // creation de la requete et insertion !
                  if (FiledsName = '') or (FieldsValue = '') then
                    DoLog(' -> Erreur lors de la construction de la requete...')
                  else
                  begin
                    QueryEnreg.SQL.Text := 'Insert into ' + QueryTables.FieldByName('rdb$relation_name').AsString + ' (' + FiledsName + ') values (' + FieldsValue + ');';
                    DoLog(' -> Requete : ' + QueryEnreg.SQL.Text);
                    QueryEnreg.ExecSQL()
                  end
                end;
              end
              else
                DoLog('  -> ATTENTION : pas de clé pour cette table...');
              QueryTables.Next();
              ProgressStepIt();
            end;
          finally
            QueryTables.Close();
          end;

          ProgressStepLbl('Commit');
          Transaction.Commit();
          ReturnValue := 0;
          DoLog('');
          DoLog('Traitement terminé avec succès.');
        except
          Transaction.Rollback();
          raise;
        end;
      finally
        FreeAndNil(QueryTables);
        FreeAndNil(QueryChamps);
        FreeAndNil(QueryEnreg);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
        DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        ReturnValue := 1;
      end;
    end;
  finally
    CoUninitialize();
  end;
end;

function TEnreg0Thread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

end.
