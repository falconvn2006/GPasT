unit uTraitement;

interface

uses
  Classes,
  uLog;

const
  CODE_RETOUR_SUCCESS = 0;
  // paramètres
  CODE_RETOUR_MISSING_PARAM = 11;
  CODE_RETOUR_INVALID_PARAM = 12;
  // sous fonction
  CODE_RETOUR_ERREUR_GETBASE0 = 21;
  CODE_RETOUR_ERREUR_GETINFOBASE = 22;
  CODE_RETOUR_ERREUR_ISINTERSPORT = 23;
  CODE_RETOUR_ERREUR_LOADFROMLAME = 42;
  CODE_RETOUR_ERREUR_UN7ZIPFILE = 43;
  // test intersport

  // fonction principale
  CODE_RETOUR_ERREUR_CREEINI = 91;
  CODE_RETOUR_ERREUR_INSTALLSERVEUR = 92;
  CODE_RETOUR_ERREUR_INSTALLCLIENT = 93;

  // Autres
  CODE_RETOUR_EXCEPTION = MaxInt -1;
  CODE_RETOUR_UNKNOW_ERROR = MaxInt;

const
  PARAM_SERVEUR = 'SERVEUR';
  PARAM_CLIENT = 'CLIENT';
  PARAM_DOWNLOAD = 'DOWNLOAD';
  PARAM_TEST = 'TEST';
  PARAM_UNINSTALL = 'UNINSTALL';

// Gestion du Log
procedure InitLog(Dossier, Module, Reference, Magasin : string);
procedure DoLog(Key, Value : string; Level : TLogLevel; Ovl : boolean = false);
// Recherche du fichier de base
function GetBase0(out BaseFile : string) : boolean;
// Recupération des informations sur la base
function GetInfoBase(BaseFile, Login, Password : string; out GUID, MagID, Sender, CodeTier, Nom, Ville : string) : boolean;
// ... et quand elles sont déjà dans le fichier ini
function GetInfoIni(var CodeTier, Nom, Ville, GUID, MagId : string) : boolean;
// Téléchargement uniquement
function DownLoadFiles() : boolean;

// installation serveur
function CreerIni(CodeTier, Nom, Ville, GUID, MagId : string) : boolean;
function IsServeur(Sender : string) : boolean;
function IsIntersport(BaseFile, Login, Password : string) : boolean;
function InstallServeur() : boolean;
// installation client !
function InstallClient() : boolean;
// desinstallation
function UnInstall() : boolean;

implementation

uses
  Registry,
  Windows,
  SysUtils,
  IniFiles,
  IOUtils,
  IB_Components,
  IBODataset,
  uGestionBDD,
  LaunchProcess,
  uSevenZip,
  ActiveX,
  ShlObj,
  ShellAPI,
  ServiceControler,
  tlHelp32,
  IdStack,
  IdGlobal,
  IdHTTP,
  IdURI;

const
  REG_PATH = '\Software\Algol\Ginkoia\';
  REG_VALUE = 'Base0';

  INI_FILE_PATH = '\Ginkoia\BPL\';
  INI_FILE_NAME = 'BMCINIT.INI';
  INI_SECTION_IDTIER = 'IDTIERS';
  INI_SECTION_NOMDOSSIER = 'NMDOSSIER';
  INI_SECTION_VILLE = 'VILLE';
  INI_SECTION_GUID = 'GUID';
  INI_SECTION_MAGID = 'MAGID';
  INI_VALUE = 'VALUE';

  URL_DOWNLOAD = 'http://oce1.ginkoia.eu/algol/BMC/';
  EXE_NAME_SERVEUR = 'Reinstall_FPAC_Relais.exe';
  EXE_NAME_CLIENT = 'Reinstall_FPAC_Client.exe';
  EXE_NAME_UNINSTALL = 'Remove_FPAC_Agent.exe';

//  FICHIER_INI_GINKOIA = 'Ginkoia.ini';
//  FICHIER_INI_CAISSE = 'CaisseGinkoia.ini';

var
  FModule : string;
  FReference : string;
  FMagasin : string;

//==============================================================================

// utilitaire (non declaré !)

function LoadFileFromLame(FileToDl : string; out FileName : string) : boolean;

  function DownloadHTTP(const AUrl, FileName : string) : boolean;
  var
    IdHTTP : TIdHTTP;
    FileStream : TStream;
  begin
    Result := false;
    try
      IdHTTP :=  TIdHTTP.Create(nil);
      IdHTTP.HandleRedirects := true;
      IdHTTP.RedirectMaximum := 15;
      FileStream := TFileStream.Create(FileName, fmCreate);
      IdHTTP.Get(TIdURI.URLEncode(AUrl), FileStream);
      Result := true;
    finally
      FreeAndNil(FileStream);
      FreeAndNil(IdHTTP);
    end;
  end;

begin
  try
    FileName := ExtractFilePath(ParamStr(0)) + FileToDl;
    Result := DownloadHTTP(URL_DOWNLOAD + FileToDl, FileName);
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "LoadFileFromLame" : "' + e.ClassName + ' - ' + e.Message + '".', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_LOADFROMLAME;
      Result := False;
    end;
  end;
end;

function Un7ZipFile(FileName : string; out path : string) : Boolean;
var
  Arch : I7zInArchive;
begin
  try
    if FileExists(FileName) then
    begin
      path := IncludeTrailingPathDelimiter(ChangeFileExt(FileName, ''));
      ForceDirectories(Path);
      Arch := CreateInArchive(CLSID_CFormat7z);
      Arch.OpenFile(FileName);
      Arch.ExtractTo(path);
      Result := True;
    end
    else
      Raise Exception.Create('Fichier non existant');
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "Un7ZipFile" : "' + e.ClassName + ' - ' + e.Message + '".', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_UN7ZIPFILE;
      Result := False;
    end;
  end;
end;

procedure DeleteDirectory(const DirName: string);
var
  FileOp: TSHFileOpStruct;
begin
  FillChar(FileOp, SizeOf(FileOp), 0);
  FileOp.wFunc := FO_DELETE;
  FileOp.pFrom := PChar(DirName+#0);//double zero-terminated
  FileOp.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
  SHFileOperation(FileOp);
end;

//==============================================================================

// Gestion du Log

procedure InitLog(Dossier, Module, Reference, Magasin : string);
begin
  Log.readIni();
  Log.LogKeepDays := 31;
  Log.FileLogFormat := [elDate, elLevel, elDos, elRef, elKey, elValue, elData];
  Log.MaxItems := 10000;
  Log.Deboublonage := false;
  log.SendOnClose := true;
  Log.Open();
  // valeurs interne
  Log.Srv := Log.Host;
  Log.Doss := Dossier;
  Log.Frequence := 0;
  // valeur externe
  FModule := Module;
  FReference := Reference;
  FMagasin := Magasin;
end;

procedure DoLog(Key, Value : string; Level : TLogLevel; Ovl : boolean = false);
begin
  Log.Log(FModule, FReference, FMagasin, Key, Value, Level, Ovl);
end;

// Recherche du fichier de base

function GetBase0(out BaseFile : string) : boolean;
var
  Reg : TRegistry;
begin
  Result := False;
  try
    try
      Reg := TRegistry.Create(KEY_READ);
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKeyReadOnly(REG_PATH) then
      begin
        BaseFile := Reg.ReadString(REG_VALUE);
        if (Trim(BaseFile) = '') then
          Raise Exception.Create('Pas de base 0')
        else
          Result := True;
        DoLog('', 'Chemin de base : "' + BaseFile + '"', logDebug);
      end
      else
        Raise Exception.Create('Chemin non present en base de registre');
    finally
      FreeAndNil(Reg);
    end;
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "GetBase0" : "' + e.ClassName + ' - ' + e.Message + '"', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_GETBASE0;
      Result := False;
    end;
  end;
end;

// Recupération des information sur la base

function GetInfoBase(BaseFile, Login, Password : string; out GUID, MagID, Sender, CodeTier, Nom, Ville : string) : boolean;
var
  Connex : TIB_Connection;
  Trans : TIB_Transaction;
  Query : TIBOQuery;
  BaseIdent, tmpCodeTier : string;
  tmpListeSender : TStringList;
begin
  Result := False;
  CodeTier := '';
  Nom := '';
  Ville := '';
  try
    try
      Connex := GetNewConnexion(BaseFile, Login, Password);
      Trans := GetNewTransaction(Connex, false);
      Query := GetNewQuery(Trans);

      try
        Trans.StartTransaction();

        // recup de l'identifiant de base
        Query.SQL.Text := 'select par_string from genparambase where par_nom = ''IDGENERATEUR'';';
        try
          Query.Open();
          if Query.Eof then
            Raise Exception.Create('Pas d''idgenerateur.')
          else
            BaseIdent := Query.FieldByName('par_string').AsString;
        finally
          Query.Close();
        end;

        DoLog('', 'ID Generateur : "' + BaseIdent + '".', logDebug);

        // recup des infos de base
        Query.SQL.Text := 'select bas_guid, bas_magid, bas_sender, bas_nompournous from genbases join k on k_id = bas_id and k_enabled = 1 where bas_ident = ' + QuotedStr(BaseIdent);
        try
          Query.Open();
          if Query.Eof then
            Raise Exception.Create('Pas d''enregistrement dans genbases.')
          else
          begin
            GUID := Query.FieldByName('bas_guid').AsString;
            MagId := Query.FieldByName('bas_magid').AsString;
            Sender := Query.FieldByName('bas_sender').AsString;
            Nom := Query.FieldByName('bas_nompournous').AsString;
          end;
        finally
          Query.Close();
        end;

        DoLog('', 'BAS_Sender : "' + Sender + '".', logDebug);

        Trans.Commit();
      except
        trans.Rollback();
        raise;
      end;

      // decomposition du sender
      try
        tmpListeSender := TStringList.Create();
        tmpListeSender.Delimiter := '_';
        tmpListeSender.DelimitedText := Sender;
        // Recup du code tier
        if tmpListeSender.Count > 2 then
        begin
          tmpCodeTier := tmpListeSender[tmpListeSender.Count -2];
          if IsNumeric(tmpCodeTier) then
            CodeTier := tmpCodeTier;
        end;
        // Recup de la ville
        if tmpListeSender.Count > 3 then
          Ville := tmpListeSender[tmpListeSender.Count -3];
      finally
        FreeAndNil(tmpListeSender);
      end;

      Result := True;
    finally
      FreeAndNil(Query);
      FreeAndNil(Trans);
      FreeAndNil(Connex);
    end;
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "GetInfoBase" : "' + e.ClassName + ' - ' + e.Message + '".', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_GETINFOBASE;
      Result := False;
    end;
  end;
end;

// Gestion du fichier INI

function GetInfoIni(var CodeTier, Nom, Ville, GUID, MagId : string) : boolean;
var
  FileName : string;
  FichierIni : TIniFile;
begin
  Result := false;
  FileName := ExtractFileDrive(ParamStr(0)) + INI_FILE_PATH + INI_FILE_NAME;

  if FileExists(FileName) then
  begin
    try
      FichierIni := TIniFile.Create(FileName);
      CodeTier := FichierIni.ReadString(INI_SECTION_IDTIER, INI_VALUE, CodeTier);
      Nom := FichierIni.ReadString(INI_SECTION_NOMDOSSIER, INI_VALUE, Nom);
      Ville := FichierIni.ReadString(INI_SECTION_VILLE, INI_VALUE, Ville);
      GUID := FichierIni.ReadString(INI_SECTION_GUID, INI_VALUE, GUID);
      MagId := FichierIni.ReadString(INI_SECTION_MAGID, INI_VALUE, MagId);

      Result := true;
    finally
      FreeAndNil(FichierIni);
    end;
  end;
end;

// Téléchargement uniquement

function DownLoadFiles() : boolean;
var
  FileResServer, FileResClient : string;
begin
  Result := LoadFileFromLame(ChangeFileExt(EXE_NAME_SERVEUR, '.7z'), FileResServer)
        and LoadFileFromLame(ChangeFileExt(EXE_NAME_CLIENT, '.7z'), FileResClient);
end;

//==============================================================================

// installation

function CreerIni(CodeTier, Nom, Ville, GUID, MagId : string) : boolean;
var
  FileName : string;
  FichierIni : TIniFile;
begin
  Result := false;
  FileName := ExtractFileDrive(ParamStr(0)) + INI_FILE_PATH + INI_FILE_NAME;

  try
    try
      FichierIni := TIniFile.Create(FileName);

      if not ((Trim(CodeTier) = '') and FichierIni.ValueExists(INI_SECTION_IDTIER, INI_VALUE)) then
        FichierIni.WriteString(INI_SECTION_IDTIER, INI_VALUE, CodeTier);

      if not ((Trim(Nom) = '') and FichierIni.ValueExists(INI_SECTION_NOMDOSSIER, INI_VALUE)) then
        FichierIni.WriteString(INI_SECTION_NOMDOSSIER, INI_VALUE, Nom);

      if not ((Trim(Ville) = '') and FichierIni.ValueExists(INI_SECTION_VILLE, INI_VALUE)) then
        FichierIni.WriteString(INI_SECTION_VILLE, INI_VALUE, Ville);

      if not ((Trim(GUID) = '') and FichierIni.ValueExists(INI_SECTION_GUID, INI_VALUE)) then
        FichierIni.WriteString(INI_SECTION_GUID, INI_VALUE, GUID);

      if not ((Trim(MagId) = '') and FichierIni.ValueExists(INI_SECTION_MAGID, INI_VALUE)) then
        FichierIni.WriteString(INI_SECTION_MAGID, INI_VALUE, MagId);

      Result := true;
    finally
      FreeAndNil(FichierIni);
    end;
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "CreerIni" : "' + e.ClassName + ' - ' + e.Message + '".', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_CREEINI;
      Result := false;
    end;
  end;
end;

function IsServeur(Sender : string) : boolean;
begin
  Result := (copy (Sender, 1, 8) = 'SERVEUR_') and not (Copy(Sender, Length(Sender) -3, 4) = '-SEC');
end;

function IsIntersport(BaseFile, Login, Password : string) : boolean;
var
  Connex : TIB_Connection;
  Trans : TIB_Transaction;
  Query : TIBOQuery;
begin
  Result := False;
  try
    try
      Connex := GetNewConnexion(BaseFile, Login, Password);
      Trans := GetNewTransaction(Connex, false);
      Query := GetNewQuery(Trans);

      try
        Trans.StartTransaction();

        // recup de l'identifiant de base
        Query.SQL.Text := 'select ugg_id  '
                        + 'from uilgrpginkoiamag join k on k_id = ugm_id and k_enabled = 1 '
                        + 'join uilgrpginkoia join k on k_id = ugg_id and k_enabled = 1 on (ugg_id = ugm_uggid) '
                        + 'where ugg_id != 0 and ugg_nom = ''CENTRALE INTERSPORT''';
        try
          Query.Open();
          Result := not Query.Eof;
        finally
          Query.Close();
        end;

        Trans.Commit();
      except
        trans.Rollback();
        raise;
      end;
    finally
      FreeAndNil(Query);
      FreeAndNil(Trans);
      FreeAndNil(Connex);
    end;
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "GetInfoBase" : "' + e.ClassName + ' - ' + e.Message + '".', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_ISINTERSPORT;
      Result := False;
    end;
  end;
end;

function InstallServeur() : boolean;
var
  Res : TResourceStream;
  ZipServeur, ZipClient, outPath, ExeName, error : string;
  Ret : integer;
begin
  Result := false;

  try
    // nom des fichier
    ZipServeur := ExtractFilePath(ParamStr(0)) + ChangeFileExt(EXE_NAME_SERVEUR, '.7z');
    ZipClient := ExtractFilePath(ParamStr(0)) + ChangeFileExt(EXE_NAME_CLIENT, '.7z');

    try
      // DLL pour le dezippage !
      if not FileExists(ExtractFilePath(ParamStr(0)) + '7z.dll') then
      begin
        try
          Res := TResourceStream.Create(HInstance, '7zDLL', RT_RCDATA);
          Res.SaveToFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
        finally
          FreeAndNil(Res);
        end;
      end;

      // téléchargement du package client
      if not FileExists(ZipClient) then
        if not LoadFileFromLame(ChangeFileExt(EXE_NAME_CLIENT, '.7z'), ZipClient) then
          raise Exception.Create('Downloading the client rescource fail...');

      // téléchargement du package Serveur
      if not FileExists(ZipServeur) then
        if not LoadFileFromLame(ChangeFileExt(EXE_NAME_SERVEUR, '.7z'), ZipServeur) then
          raise Exception.Create('Downloading the server rescource fail...');

      // Decompression et execution
      if Un7ZipFile(ZipServeur, outPath) then
      begin
        ExeName := IncludeTrailingPathDelimiter(outPath) + EXE_NAME_SERVEUR;
        Ret := ExecAndWaitProcess(error, ExeName, ''{$IFDEF DEBUG}, true{$ENDIF});
        if ret <> 0 then
          Raise Exception.Create('Retour du process : ' + IntToStr(Ret) + ' - ' + error);
        // oki fini bien !
        Result := true;
      end
      else
        raise Exception.Create('Un7ZipFile fail...');
    finally
      DeleteFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
      DeleteDirectory(outPath);
      DeleteFile(ZipServeur);
    end;
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "InstallServeur" : "' + e.ClassName + ' - ' + e.Message + '".', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_INSTALLSERVEUR;
      Result := false;
    end;
  end;
end;

function InstallClient() : boolean;
var
  Res : TResourceStream;
  ZipClient, outPath, ExeName, error : string;
  Ret : integer;
begin
  Result := false;
  try
    // nom des fichier
    ZipClient := ExtractFilePath(ParamStr(0)) + ChangeFileExt(EXE_NAME_CLIENT, '.7z');

    // Existance du package client ?
    if not FileExists(ZipClient) then
      raise Exception.Create('Client rescource isn''t here...');

    // si l'install est deja faite ?
    try
      // DLL pour le dezippage !
      if not FileExists(ExtractFilePath(ParamStr(0)) + '7z.dll') then
      begin
        try
          Res := TResourceStream.Create(HInstance, '7zDLL', RT_RCDATA);
          Res.SaveToFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
        finally
          FreeAndNil(Res);
        end;
      end;

      // Decompression et execution
      if Un7ZipFile(ZipClient, outPath) then
      begin
        ExeName := IncludeTrailingPathDelimiter(outPath) + EXE_NAME_CLIENT;
        Ret := ExecAndWaitProcess(error, ExeName, ''{$IFDEF DEBUG}, true{$ENDIF});
        if ret <> 0 then
          Raise Exception.Create('Retour du process : ' + IntToStr(Ret) + ' - ' + error);
        // oki fini bien !
        Result := true;
      end
      else
        raise Exception.Create('Un7ZipFile fail...');
    finally
      DeleteFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
      DeleteDirectory(outPath);
    end;
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "InstallClient" : "' + e.ClassName + ' - ' + e.Message + '".', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_INSTALLCLIENT;
      Result := false;
    end;
  end;
end;

// desinstallation

function UnInstall() : boolean;
var
  Res : TResourceStream;
  ZipUnInstall, outPath, ExeName, error : string;
  Ret : integer;
begin
  Result := false;

  try
    // nom des fichier
    ZipUnInstall := ExtractFilePath(ParamStr(0)) + ChangeFileExt(EXE_NAME_UNINSTALL, '.7z');

    try
      // DLL pour le dezippage !
      if not FileExists(ExtractFilePath(ParamStr(0)) + '7z.dll') then
      begin
        try
          Res := TResourceStream.Create(HInstance, '7zDLL', RT_RCDATA);
          Res.SaveToFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
        finally
          FreeAndNil(Res);
        end;
      end;

      // téléchargement du package de desinstallation
      if not FileExists(ZipUnInstall) then
        if not LoadFileFromLame(ChangeFileExt(EXE_NAME_UNINSTALL, '.7z'), ZipUnInstall) then
          raise Exception.Create('Downloading the uninstall rescource fail...');

      // Decompression et execution
      if Un7ZipFile(ZipUnInstall, outPath) then
      begin
        ExeName := IncludeTrailingPathDelimiter(outPath) + EXE_NAME_UNINSTALL;
        Ret := ExecAndWaitProcess(error, ExeName, ''{$IFDEF DEBUG}, true{$ENDIF});
        if ret <> 0 then
          Raise Exception.Create('Retour du process : ' + IntToStr(Ret) + ' - ' + error);
        // oki fini bien !
        Result := true;
      end
      else
        raise Exception.Create('Un7ZipFile fail...');
    finally
      DeleteFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
      DeleteDirectory(outPath);
      DeleteFile(ZipUnInstall);
    end;
  except
    on e : Exception do
    begin
      DoLog('', 'Exception dans "UnInstall" : "' + e.ClassName + ' - ' + e.Message + '".', logCritical);
      ExitCode := CODE_RETOUR_ERREUR_INSTALLSERVEUR;
      Result := false;
    end;
  end;
end;

end.
