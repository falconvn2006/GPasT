unit UIBUtilsThread;

interface

uses System.Classes,
     Vcl.ComCtrls,
     FireDAC.Phys;

const
  CST_BASE_LOGIN    = 'SYSDBA';
  CST_BASE_PASSWORD = 'masterkey';
  CST_BASE_PORT     = 3050;
  URL_SERVEUR_MAJ   = 'lame2.ginkoia.eu';

type
  TBaseIBThread = class(TThread)
  protected
    // connexion BDD
    FServeur : string;
    FDataBase : string;
    FPort : integer;
    // Fonctions de "controle" de base
    function DoActivation(Online : boolean) : boolean; virtual;
    function DoValidate(FileBase : string) : boolean; virtual;
    function DoGFix(FileBase : string) : boolean; virtual;
    // Fonctions de backup/retore
    function DoBackup(FileBase, FileSave : string) : boolean; virtual;
    function DoRestore(FileBase, FileSave : string) : boolean; virtual;
  public
    constructor Create(Serveur, DataBase : string; Port :integer; CreateSuspended: Boolean = false); reintroduce;
  property ReturnValue;
  end;

  TBaseBackRestThread = class(TBaseIBThread)
  protected
    procedure Execute(); override;
  end;

  TBaseBackupThread = class(TBaseBackRestThread)
  protected
    FBackupFile : string;
    procedure Execute(); override;
  public
    constructor Create(Serveur, DataBase : string; Port : integer; BackupFile : string; CreateSuspended: Boolean = false); reintroduce;
  end;

  TBaseRetoreThread = class(TBaseBackRestThread)
  protected
    FBackupFile : string;

    procedure Execute(); override;
  public
    constructor Create(Serveur, DataBase : string; Port : integer; BackupFile : string; CreateSuspended: Boolean = false); reintroduce;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.Math,
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBWrapper,
  FireDAC.Phys.IBBase;

{ TBaseIBThread }

function TBaseIBThread.DoActivation(Online : boolean) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Config : TFDIBConfig;
begin
  Result := false;

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';
      Config := TFDIBConfig.Create(nil);
      Config.DriverLink := DriverLink;
      Config.Protocol := ipTCPIP;
      Config.Host := FServeur;
      Config.Database := FDataBase;
      Config.UserName := CST_BASE_LOGIN;
      Config.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Config.Port := FPort;

      if Online then
        Config.OnlineDB()
      else
        Config.ShutdownDB(smForce, 5);
      Result := true;
    finally
      FreeAndNil(Config);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      // FLogs.Add('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseIBThread.DoValidate(FileBase : string) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Validate : TFDIBValidate;
begin
  Result := false;

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';
      Validate := TFDIBValidate.Create(nil);
      Validate.DriverLink := DriverLink;
      Validate.Options := [roValidateFull];
      Validate.Protocol := ipTCPIP;
      Validate.Host := FServeur;
      Validate.Database := FileBase;
      Validate.UserName := CST_BASE_LOGIN;
      Validate.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Validate.Port := FPort;
      // Validate.OnProgress := LogDriverMessage;

      Validate.Sweep();
      Validate.Repair();
      Result := true;
    finally
      FreeAndNil(Validate);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      // FLogs.Add('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseIBThread.DoGFix(FileBase : string) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Config : TFDIBConfig;
begin
  Result := false;

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';
      Config := TFDIBConfig.Create(nil);
      Config.DriverLink := DriverLink;
      Config.Protocol := ipTCPIP;
      Config.Host := FServeur;
      Config.Database := FileBase;
      Config.UserName := CST_BASE_LOGIN;
      Config.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Config.Port := FPort;
      // Config.OnProgress := LogDriverMessage;

      Config.SetPageBuffers(4096);
      Config.SetSweepInterval(0);
      Config.SetWriteMode(wmAsync);
      Config.SetAccessMode(amReadWrite);
      Result := true;
    finally
      FreeAndNil(Config);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      // FLogs.Add('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseIBThread.DoBackup(FileBase, FileSave : string) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Backup : TFDIBBackup;
  vErrorMsg :string;
begin
  Result := false;

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';
      Backup := TFDIBBackup.Create(nil);
      Backup.DriverLink := DriverLink;
      Backup.Protocol := ipTCPIP;
      Backup.Host := FServeur;
      Backup.Database := FileBase;
      Backup.UserName := CST_BASE_LOGIN;
      Backup.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Backup.Port := FPort;
      Backup.Verbose := true;
      // Backup.OnProgress := LogDriverMessage;

      Backup.BackupFiles.Add(FileSave);
      Backup.Backup();
      Result := true;
    finally
      FreeAndNil(Backup);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      begin
          vErrorMsg := E.Message;
      end;
      // FLogs.Add('!! Exception : ' + e.ClassName + ' - ' + );
  end;
end;

function TBaseIBThread.DoRestore(FileBase, FileSave : string) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Restore : TFDIBRestore;
begin
  Result := false;

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';
      Restore := TFDIBRestore.Create(nil);
      Restore.DriverLink := DriverLink;
      Restore.Options := Restore.Options + [roCreate, roValidate];
      Restore.Protocol := ipTCPIP;
      Restore.Host := FServeur;
      Restore.Database := FileBase;
      Restore.UserName := CST_BASE_LOGIN;
      Restore.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Restore.Port := FPort;
      Restore.Verbose := true;
      // Restore.OnProgress := LogDriverMessage;

      Restore.BackupFiles.Add(FileSave);
      Restore.Restore();
      Result := true;
    finally
      FreeAndNil(Restore);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      // FLogs.Add('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

constructor TBaseIBThread.Create(Serveur, DataBase : string; Port : integer; CreateSuspended: Boolean = false);
begin
  Inherited Create(CreateSuspended);
  FServeur := Serveur;
  FDataBase := DataBase;
  FPort := Port;
end;


{ TGFixThread }



{ TBaseBackRestThread }

procedure TBaseBackRestThread.Execute();
// code de retour :
//  0 - reussite
// ...
//  2 - Pas assez d'espace
//  3 - Shutdown base
//  4 - Erreur de validation
//  5 - Erreur lors de la creation de verif
//  6 - Erreur de backup
//  7 - Erreur de restauration
//  8 - GFix
//  9 - Verification nok
// 10 - Restart base
// 11 - Exception
// 12 - Autre erreur
var
  // Verif : TDataBaseVerif;
  ResVerif : TStringList;
  SvgName, OldName, NewName : string;
  FileSize : int64;
begin
  ReturnValue := 12;
//  if Assigned(FProgress) then
//    Synchronize(ProgressMarquee);
  SvgName := ChangeFileExt(FDataBase, '.TMP');
  OldName := ChangeFileExt(FDataBase, '.OLD');
  NewName := ChangeFileExt(FDataBase, '.NEW');

  try
    CoInitialize(nil);

    if FileExists(SvgName) then
      DeleteFile(SvgName);
    if FileExists(OldName) then
      DeleteFile(OldName);
    if FileExists(NewName) then
      DeleteFile(NewName);

    try
      try
        try
          // renommage du fichier
          MoveFile(PWideChar(FDataBase), PWideChar(OldName));

            try
              // backup
              if not DoBackup(OldName, SvgName) then
              begin
                ReturnValue := 6;
                Exit;
              end;
              if not DoRestore(NewName, SvgName) then
              begin
                ReturnValue := 7;
                Exit;
              end;
            finally
              DeleteFile(SvgName);
            end;
        finally
          if ReturnValue = 0 then
          begin
            DeleteFile(OldName);
            MoveFile(PWideChar(NewName), PWideChar(FDataBase));
          end
          else
          begin
            DeleteFile(NewName);
            MoveFile(PWideChar(OldName), PWideChar(FDataBase));
          end;
        end;
      finally
        // Restart
        if not DoActivation(true) then
          if ReturnValue = 0 then
            ReturnValue := 10;
      end;
    except
      on e : Exception do
      begin
        // FLogs.Add('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        ReturnValue := 11;
      end;
    end;
  finally
    CoUninitialize();
  end;
end;

{ TBaseBackupThread }

procedure TBaseBackupThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Pas assez d'espace
// 2 - Erreur lors de la creation de verif
// 3 - Erreur de backup
// 4 - Erreur de Zip
// 5 - Exception
// 6 - Autre erreur
var
//  Verif : TDataBaseVerif;
  FilesTo7z : TStringList;
  DestPath, SvgName, VrfName : string;
  FileSize : int64;
begin
  ReturnValue := 6;

  try
    CoInitialize(nil);

    if FileExists(FBackupFile) then
      DeleteFile(FBackupFile);

    try
        ForceDirectories(DestPath);
        SvgName := DestPath + ChangeFileExt(ExtractFileName(FBackupFile), '.GBK');
        VrfName := DestPath + ChangeFileExt(ExtractFileName(FBackupFile), '.XML');

          try
            // backup
            if not DoBackup(FDataBase, SvgName) then
            begin
              ReturnValue := 3;
              Exit;
            end;

          finally
            DeleteFile(SvgName);
          end;
    except
      on e : Exception do
      begin
        ReturnValue := 5;
      end;
    end;
  finally
    CoUninitialize();
  end;
end;

constructor TBaseBackupThread.Create(Serveur, DataBase : string; Port : integer; BackupFile : string; CreateSuspended: Boolean = false);
begin
  Inherited Create(Serveur, DataBase, Port, CreateSuspended);
  FBackupFile := BackupFile;
end;

{ TBaseRetoreThread }

procedure TBaseRetoreThread.Execute();
// code de retour :
//  0 - reussite
//  1 - Erreur de fichier
// ...
//  3 - Pas assez d'espace
// ...
//  5 - Erreur lors du dézippage
//  6 - Erreur de restauration
//  7 - GFix
//  8 - Erreur lors de la vérification de la restauration
// ...
// ...
// 11 - Erreur de validation
// 12 - Restart de base
// 13 - Exception
// 14 - Autre erreur
var
  ResVerif : TStringList;
  NewName, DestPath : string;
  FileExt, SvgName, VrfName : string;
  FileSize : int64;
  RetFind : integer;
  FindStruc : TSearchRec;
  Version : string;
  DateVersion : TDateTime;
  Recalcul : boolean;
  DateFinBck : TDateTime;
  error : string;
begin
  ReturnValue := 14;
  NewName := ChangeFileExt(FDataBase, '.NEW');
  FileExt := '';
  SvgName := '';
  VrfName := '';

  try
    CoInitialize(nil);
    if FileExists(FBackupFile) then
    begin
      if FileExists(FDataBase) then
        DeleteFile(FDataBase);
      if FileExists(NewName) then
        DeleteFile(NewName);

      try
          if (FileExt = '.GBK') or (FileExt = '.IBK') then
          begin
            SvgName := DestPath + ExtractFileName(FBackupFile);
            CopyFile(PWideChar(FBackupFile), PWideChar(SvgName), true);
            if FileExists(ChangeFileExt(FBackupFile, '.xml')) then
            begin
              VrfName := DestPath + ChangeFileExt(ExtractFileName(FBackupFile), '.xml');
              CopyFile(PWideChar(ChangeFileExt(FBackupFile, '.xml')), PWideChar(VrfName), true);
            end;
          end;
          if SvgName = '' then
          begin
            ReturnValue := 1;
            Exit;
          end;

          try
            // retore
            if not DoRestore(NewName, SvgName) then
            begin
              ReturnValue := 6;
              Exit;
            end;
            // ok terminé ??
            ReturnValue := 0;
          finally
            if ReturnValue = 0 then
              MoveFile(PWideChar(NewName), PWideChar(FDataBase))
            else
              DeleteFile(NewName);
          end;

          if not DoActivation(true) then
          begin
            ReturnValue := 12;
            Exit;
          end;
      except
        on e : Exception do
        begin
          ReturnValue := 13;
        end;
      end;
    end
    else
      ReturnValue := 1;
  finally
    CoUninitialize();
  end;
end;

constructor TBaseRetoreThread.Create( Serveur, DataBase : string; Port : integer; BackupFile : string; CreateSuspended: Boolean = false);
begin
  Inherited Create(Serveur, DataBase, Port, CreateSuspended);
  FBackupFile := BackupFile;
end;

end.


