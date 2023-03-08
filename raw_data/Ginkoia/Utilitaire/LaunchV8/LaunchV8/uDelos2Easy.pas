unit uDelos2Easy;

interface

uses
  SysUtils, Windows, IBDatabase, DB, IBQuery, uLog, Dialogs, uGestionBDD,
  DateUtils, ShellAPI, IBServices, ServiceControler;

const
  dataBaseNameEasy: string = 'DELOS2EASY.IB';

type
  TGenparam = record
    PRM_TYPE: Integer;
    PRM_FLOAT: Double;
    PRM_CODE: Integer;
    PRM_STRING: string;
    PRM_INTEGER: Integer;
    PRM_ID: Integer;
    DATE_PARAM: TDateTime;
  public
    procedure Init;
  end;

  Tdelos2Easy = class
  private
    FBasId: Integer;
    FDatabasePath: string;
    FHasError: Boolean;
    FBasGUID: string;
    FPARAM_80_2: TGenparam;
    FIsEasy: boolean;
    procedure SetBasIDS();
    function GetIsEasy(): boolean;
  public
    DateDownload: Integer;
    property BasId: Integer read FBasId write FBasId;
    property BasGUID: string read FBasGUID write FBasGUID;
    property HasError: Boolean read FHasError write FHasError;
    property DatabasePath: string read FDatabasePath write FDatabasePath;
    property PARAM_80_2: TGenparam read FPARAM_80_2 write FPARAM_80_2;
    property IsEasy: boolean read GetIsEasy write FIsEasy;
    constructor Create(aBasePath: string);
    procedure LogDelos2Easy(aLog: string; alogLvl: TLogLevel);
    procedure ShutdownDatabase;
    procedure RestartInterbaseService;
    procedure BackupRenameBase;
    procedure SetGenParam();
    procedure LaunchDelos2Easy(aParam: string);
    procedure UpdateGenParam(aPRM_INTEGER: integer);
  end;

var
  Delos2Easy: Tdelos2Easy;

implementation

{ Tdelos To Easy }

constructor Tdelos2Easy.Create(aBasePath: string);
begin
  DatabasePath := aBasePath;
  HasError := False;
  SetBasIDS(); // on récupère le BAS_ID et GUID en sysdba pour être sur de l'avoir pour les tests même si la base est Shutdown (car il est déjà récupéré dans le launcher
  DateDownload := 0;
  PARAM_80_2.Init;
end;

function Tdelos2Easy.GetIsEasy: boolean;
var
  connexion: TMyConnection;
  transaction: TMyTransaction;
  query: TMyQuery;
begin
  result := False;

  // vérification si le genparam de easy existe
  connexion := GetNewConnexion(DatabasePath, 'ginkoia', 'ginkoia');
  try
    try
      transaction := GetNewTransaction(connexion);
      try
        query := GetNewQuery(transaction, '', true);
        query.SQL.Add('SELECT * FROM GENPARAM');
        query.SQL.Add('JOIN K ON K_ID = PRM_ID');
        query.SQL.Add('WHERE PRM_TYPE = 80 AND PRM_CODE = 1 AND K_ENABLED = 1 AND prm_string <> ''''');
        query.Open;

        if not (query.Eof) then
        begin
          result := true;
        end;
      finally
        query.Free;
      end;
    finally
      transaction.Free;
    end;
  finally
    connexion.Free;
  end;
end;

procedure Tdelos2Easy.SetGenParam();
var
  connexion: TMyConnection;
  transaction: TMyTransaction;
  query: TMyQuery;
  GENPARAM: TGenparam;
begin

  // connexion à la base en sysdba pour que la connexion fonctionne toujours après avoir shutdown la base
  connexion := GetNewConnexion(DatabasePath, 'sysdba', 'masterkey');
  try
    try
      transaction := GetNewTransaction(connexion);
      try
        query := GetNewQuery(transaction, '', true);
        query.SQL.Add('SELECT * FROM GENPARAM');
        query.SQL.Add('JOIN K ON K_ID = PRM_ID');
        query.SQL.Add('WHERE PRM_TYPE = 80 AND PRM_CODE = 2 AND PRM_POS = :bas_id AND K_ENABLED = 1');
        query.ParamByName('bas_id').AsLargeInt := BasId;
        query.Open;

        if not (query.Eof) then
        begin
          GENPARAM.PRM_TYPE := query.FieldByName('PRM_TYPE').AsInteger;
          GENPARAM.PRM_FLOAT := query.FieldByName('PRM_FLOAT').AsFloat;
          GENPARAM.PRM_CODE := query.FieldByName('PRM_CODE').AsInteger;
          GENPARAM.PRM_STRING := query.FieldByName('PRM_STRING').AsString;
          GENPARAM.PRM_INTEGER := query.FieldByName('PRM_INTEGER').AsInteger;
          GENPARAM.PRM_ID := query.FieldByName('PRM_ID').AsInteger;
          GENPARAM.DATE_PARAM := Now;

          FPARAM_80_2 := GENPARAM;
        end
        else
          raise Exception.Create('le GENPARAM de MAJ Delos Vers Easy N''existe pas.');
      finally
        query.Free;
      end;
    finally
      transaction.Free;
    end;
  finally
    connexion.Free;
  end;
end;

procedure Tdelos2Easy.UpdateGenParam(aPRM_INTEGER: integer);
var
  connexion: TMyConnection;
  transaction: TMyTransaction;
  query: TMyQuery;
begin
  // connexion à la base en sysdba pour que la connexion fonctionne toujours après avoir shutdown la base, on se connecte sur la base renommée donc on met à jour le chemin
  try
    connexion := GetNewConnexion(ExtractFilePath(DatabasePath) + dataBaseNameEasy, 'sysdba', 'masterkey');
    try
      try
        transaction := GetNewTransaction(connexion);
        try
          try
            query := GetNewQuery(transaction, '', true);
            query.SQL.Add('UPDATE GENPARAM SET PRM_INTEGER = :PRM_INTEGER WHERE PRM_ID = :PRM_ID');
            query.ParamByName('PRM_INTEGER').AsInteger := aPRM_INTEGER;
            query.ParamByName('PRM_ID').AsInteger := PARAM_80_2.PRM_ID;
            query.ExecSQL;

            transaction.Commit;

            LogDelos2Easy('Mise à jour du GENPARAM à l''état ' + IntToStr(aPRM_INTEGER), logInfo);
          except
            on E: Exception do
            begin
              HasError := true;
              LogDelos2Easy('Erreur lors de la mise à jour du GENPARAM à l''état ' + IntToStr(aPRM_INTEGER) + ' : ' + E.message, logError);
            end;
          end;
        finally
          query.Free;
        end;
      finally
        transaction.Free;
      end;
    finally
      connexion.Free;
    end;
  except
    on E: Exception do
    begin
      HasError := true;
      LogDelos2Easy('Erreur lors de la mise à jour du GENPARAM à l''état ' + IntToStr(aPRM_INTEGER) + ' : ' + E.message, logError);
    end;
  end;
end;

procedure Tdelos2Easy.SetBasIDS();
var
  connexion: TMyConnection;
  transaction: TMyTransaction;
  query: TMyQuery;
begin
  // connexion à la base en sysdba pour que la connexion fonctionne toujours après avoir shutdown la base
  connexion := GetNewConnexion(DatabasePath, 'sysdba', 'masterkey');
  try
    try
      transaction := GetNewTransaction(connexion);
      try
        query := GetNewQuery(transaction, '', true);
        query.SQL.Add('SELECT BAS_ID, BAS_GUID');
        query.SQL.Add('FROM genbases JOIN k on (k_id=bas_id and k_enabled=1) JOIN genparambase ON (bas_ident = par_string)');
        query.SQL.Add('Where par_nom = ''IDGENERATEUR''');
        query.Open;

        if not (query.Eof) then
        begin
          BasId := query.FieldByName('BAS_ID').AsInteger;
          BasGUID := query.FieldByName('BAS_GUID').AsString;
        end
        else
          raise Exception.Create('Impossible de trouver le BAS_ID.');
      finally
        query.Free;
      end;
    finally
      transaction.Free;
    end;
  finally
    connexion.Free;
  end;
end;

procedure Tdelos2Easy.LogDelos2Easy(aLog: string; alogLvl: TLogLevel);
begin
  try
    Log.App := 'Delos2Easy';
    Log.Log('Launcher', BasGUID, 'MagasinDelos', aLog, alogLvl, True, 0, ltServer);
  finally
    Log.App := 'Launcher';
  end;
end;

procedure Tdelos2Easy.ShutdownDatabase();
var
  ibService: TIBConfigService;
begin
  ibService := TIBConfigService.Create(Nil);
  try
    try
      LogDelos2Easy('Shutdown de la base En cours', logNotice);

      ibService.DatabaseName := DatabasePath;
      ibService.LoginPrompt := False;
      ibService.Params.Clear;
      ibService.Params.Add('user_name=sysdba');
      ibService.Params.Add('password=masterkey');
      ibService.Active := True;
      ibService.ShutdownDatabase(Forced, 5);
      ibService.Active := False;

      LogDelos2Easy('Shutdown de la base réussi', logInfo);
    finally
      ibService.Active := False;
      FreeAndNil(ibService);
    end;
  except
    on E: Exception do
    begin
      HasError := true;
      LogDelos2Easy('Erreur lors du shutdown de la base : ' + E.message, logError);
    end;
  end;
end;

// procédure pour arrêter et relancer le service interbase pour être certain de bien fermer toutes les connexions ouvertes
procedure Tdelos2Easy.RestartInterbaseService();
begin
  try
    if ServiceWaitStop('', 'IBG_gds_db', 10000) then
      LogDelos2Easy('Arrêt d''Interbase réussi', logInfo)
    else
    begin
      HasError := true;
      LogDelos2Easy('Echec lors de l''arrêt d''Interbase', logError);
      Exit;
    end;

    if ServiceWaitStart('', 'IBG_gds_db', 10000) then
      LogDelos2Easy('Démarrage d''Interbase réussi', logInfo)
    else
    begin
      HasError := true;
      LogDelos2Easy('Echec lors du démarrage d''Interbase', logError);
      Exit;
    end;
  except
    on E: Exception do
    begin
      HasError := true;
      LogDelos2Easy('Erreur lors de l''arrête / redémmarrage d''interbase : ' + E.message, logError);
    end;
  end;
end;

procedure Tdelos2Easy.BackupRenameBase();
begin
  // on copie la base à la place de la Ginkoia.toto
  try
    LogDelos2Easy('Backup de la base en Ginkoia.toto', logNotice);
    if CopyFile(PWideChar(DatabasePath), PWideChar(ExtractFilePath(DatabasePath) + 'backup\GINKOIA.toto'), False) then
      LogDelos2Easy('Backup de la base en GINKOIA.toto réussi', logInfo)
    else
    begin
      // HasError := true; pas d'erreur, si on n'arrive pas à copier la base on continue les étapes
      LogDelos2Easy('Echec du backup de la base en GINKOIA.toto', logError);
    end;


    // on renomme la base en DELOS2EASY.IB
    LogDelos2Easy('Renommage de la base en ' + dataBaseNameEasy, logNotice);
    if RenameFile(DatabasePath, ExtractFilePath(DatabasePath) + dataBaseNameEasy) then
      LogDelos2Easy('Renommage de la base en ' + dataBaseNameEasy + ' réussi', logInfo)
    else
    begin
      HasError := true;
      LogDelos2Easy('Echec du renommage de la base en ' + dataBaseNameEasy, logError);
      Exit;
    end;
  except
    on E: Exception do
    begin
      HasError := true;
      LogDelos2Easy('Erreur lors du backup / renommage de la base : ' + E.message, logError);
    end;
  end;
end;

procedure Tdelos2Easy.LaunchDelos2Easy(aParam: string);
begin
  try
    ShellExecute(0, 'Open', PWideChar(ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(DatabasePath))) + 'EasyInstall/Delos2Easy.exe'), PWideChar(aParam), Nil, SW_SHOWDEFAULT);
    LogDelos2Easy('Lancement de Delos2Easy.exe paramètre(s) : ' + aParam, logInfo);
  except
    on E: Exception do
    begin
      HasError := true;
      LogDelos2Easy('Impossible de lancer Delos2Easy.exe ' + aParam + ' : ' + E.message, logError);
    end;
  end;
end;

{ ---------------------------- TGENPARAM ------------------------------------- }

procedure TGenparam.Init;
begin
  PRM_TYPE := 0;
  PRM_FLOAT := 0;
  PRM_CODE := 0;
  PRM_STRING := '';
  PRM_INTEGER := 0;
  PRM_ID := 0;
  DATE_PARAM := 0;
end;

end.

