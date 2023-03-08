unit uFunctions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Win.Registry, System.IOUtils, uRessourcestr, Vcl.Dialogs, Vcl.Forms,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Controls, System.StrUtils, Winapi.ShellAPI, FireDAC.Phys.IBBase,
  FireDAC.Phys.IBWrapper, uLog, Winapi.ActiveX, System.Win.ComObj;

const
  RST_SYSTEM_32 = '32 bits';
  RST_SYSTEM_64 = '64 bits';
  RST_VERSION = 'Version :';
  Log_Mdl = 'Fonctions';

type
  RFileToCopy = record
    folderName: string;
    fileName: string;
    fileSize: Int64;
  end;

function GetInfoSystem: string;

function GetVersion(sExename: string; Handle: cardinal): string;

function IsVistaOrHigher: boolean;

function IsAvalidtype(Drive: string): boolean;

function Is64bits: boolean;

function EnCryptDeCrypt(const Value: string): string;

function IsAuthorized(sUser, sPwd: string): boolean;

function GetGinkoiaPath: string;

function SearchSourcesEasy(aFolderToSearch: string = ''; onlySearchPath: boolean = False): string;

function ArchiveIsEasy(aFile: string): boolean;

function InstallEasy(aPathEasy, aPathInstall: string; aSender: string = ''): boolean;

function InstallEasyNew(aDriveOrigin, aPathInstall, aSender: string; IsPortable, IsCaisseSec: Boolean; EasyURL: String): boolean;
function UpdateConfFiles(const aDriveOrigin: string; const aPathInstall: string): boolean;
function Sender_To_Node(aSender:string):string;
function GenerePropertiesFiles(aNode: string; aGroup: string; aURL: String; aPathInstall: String):boolean;

function GetComputerNetName: string;

procedure CleanRegistryDelos();

function SearchLocalGinkoiaPathBase(): string;

procedure RestartDatabase(aBasePath: string);

procedure ShutdownDatabase(aBasePath: string);

function BackupFile(aFile: string; aProgressBar: TProgressBar): boolean;

// procédures pour la copie des fichiers
//function CopyGinkoiaFromServer(PathDistant, PathLocal: string; CopyToto: boolean; aProgressBar: TProgressBar = Nil): boolean;
function CopyFromServeur(PathDistant, PathLocal, PathSourcesEasy: string; aProgressBar: TProgressBar = Nil; aLbl: TLabel = Nil): boolean;
function CopyFileWithProgressBar(aFileFrom, aFileTo: string; aProgressBar: TProgressBar): boolean;
function CopyCallBack(TotalFileSize: Int64; TotalBytesTransferred: Int64; StreamSize: Int64; StreamBytesTransferred: Int64; dwStreamNumber: DWord; dwCallbackReason: DWord; hSourceFile: THandle; hDestinationFile: THandle; ProgressBar: TProgressBar): DWord; far; stdcall;
function RecreateDirectory(aPath: String): Boolean;
function CopyFolder(PathDistant, PathLocal: String; extsToSkip: TStringList = Nil; FoldersToSkip: TStringList = Nil): boolean;
function CheckIfCashFolderExists(PathDistant, PathLocal: string): Boolean;

procedure GatherFilesFromDirectory(const ADirectory: string; var AFileArray: TArray<RFileToCopy>; out ATotalSize: Int64; aSubFolder: string = '');

function DelDir(DirPath: string): boolean;

procedure ErrorMsg(sMsg: string);

function GetTimefromMsc(var Msecs: cardinal): Ttime; // var pour test

procedure PathExtractElements(const Source: string; var Drive, Path, fileName, Ext: string);
// procédure pour mettre à jour les paramètres régionaux sur français (date, heure)

procedure SetRegionToFr();

function getMachineGuid: string;

var
  UsrLogged: string;
  test: string;
  TotalSize, CurrentSize: Int64;

implementation

uses
  uSevenZip, uToolsXE;

procedure PathExtractElements(const Source: string; var Drive, Path, fileName, Ext: string);
var
  cSeparator: char;
begin
  cSeparator := Tpath.DirectorySeparatorChar;
  Drive := ExtractFileDrive(Source);
  Path := ExtractFilePath(Source);
  if Drive <> '' then
    Delete(Path, 1, Length(Drive));
  // add/remove separators
  Drive := IncludeTrailingBackslash(Drive);
  if Path[Length(Path)] = cSeparator then
    Path := Copy(Path, Length(Path) - 1);
  if (Path <> '') and (Path[1] = cSeparator) then
    Delete(Path, 1, 1);
  // and extract the remaining elements
  fileName := Tpath.GetFileNameWithoutExtension(Source);
  Ext := Tpath.GetExtension(Source);
end;

function EnCryptDeCrypt(const Value: string): string;
var
  i: integer;
  Val: AnsiString;
begin
  Val := AnsiString(Value);
  for i := 1 to Length(Val) do
    Val[i] := AnsiChar(Chr(not (Ord(Val[i]))));
  result := string(Val);
end;

function IsAuthorized(sUser, sPwd: string): boolean;
begin
  sUser := lowercase(sUser);

  UsrLogged := '';

  if (((sUser.Equals('nosymag') = true) and (sPwd.Equals('admin') = true)) or (sUser.Equals('ginkoia') = true) and (sPwd.Equals('ch@mon1x') = true)) then
  begin
    if sUser = 'nosymag' then
      UsrLogged := UsrISF;

    if sUser = 'ginkoia' then
      UsrLogged := UsrGin;

    result := true;
  end
  else
  begin
    result := False;
  end;
end;

function GetInfoSystem: string;
var
  sSystem: string;
begin
  if Tosversion.platform = pfWindows then
  begin
    sSystem := Tosversion.Name;
    if Tosversion.Architecture = arIntelX64 then
      sSystem := sSystem + ' ' + RST_SYSTEM_64
    else
      sSystem := sSystem + ' ' + RST_SYSTEM_32;

    sSystem := sSystem + ' ' + IntTostr(Tosversion.Build) + ' ' + IntTostr(Tosversion.ServicePackMajor) + ' ' + IntTostr(Tosversion.ServicePackMinor);
  end;
  exit(sSystem);

end;

function Is64bits: boolean;
begin
  exit(Tosversion.Architecture = arIntelX64);
end;

function GetVersion(sExename: string; Handle: cardinal): string;
const
  Infok = 11;
  InfoStr: array[1..Infok] of string = ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyRight', 'LegalTradeMarks', 'OriginalFilename', 'ProductName', 'ProductVersion', 'Comments', 'Author');
var
  k, i: integer;
  Len: cardinal;
  Buff, Value: Pwchar;
begin
  { * basée sur la fonction de Zarko Gajic Versioninformation * }

  k := GetFileVersionInfoSizeW(Pwchar(sExename), Handle);
  if k > 0 then
  begin
    try
      Buff := Allocmem(k);
      GetFileVersionInfoW(Pwchar(sExename), 0, k, Buff);
      for i := 1 to Infok do
      begin
        if VerQueryValueW(Buff, Pwchar('StringFileInfo\040904E4\' + InfoStr[i]), Pointer(Value), Len) then
        begin
          if i = 3 then
          begin
            Value := Pwchar(Trim(Value));
            break;
          end;
        end;

      end;
    finally
      Freemem(Buff, k);
    end;
    exit(RST_VERSION + ' ' + string(Value));
  end
  else
    exit('');

end;

function IsVistaOrHigher: boolean;
begin
  exit(Tosversion.Major > 5); // Vista 6.0 Seven 6.1
end;

function IsAvalidtype(Drive: string): boolean;
begin
  case GetDriveType(Pwchar(Drive)) of
    DRIVE_REMOVABLE:
      exit(False);
    DRIVE_FIXED:
      exit(true);
    DRIVE_REMOTE:
      exit(true);
    DRIVE_CDROM:
      exit(False);
    DRIVE_RAMDISK:
      exit(False);
  end;
end;

function GetTimefromMsc(var Msecs: cardinal): Ttime;
const
  secondTicks = 1000;
  minuteTicks = 1000 * 60;
  hourTicks = 1000 * 60 * 60;
  dayTicks = 1000 * 60 * 60 * 24;
var
  k: cardinal;
  ZD, ZH, ZM, ZS: integer;
begin
  try
    ZD := Msecs div dayTicks;
    Dec(Msecs, ZD * dayTicks);
    ZH := Msecs div hourTicks;
    Dec(Msecs, ZH * hourTicks);
    ZM := Msecs div minuteTicks;
    Dec(Msecs, ZM * minuteTicks);
    ZS := Msecs div secondTicks;

    result := EncodeTime(ZH, ZM, ZS, 0);
  except
  end;
end;

function GetGinkoiaPath: string;
var
  sPath: string;
begin
  result := 'C:\Ginkoia';
  with Tregistry.Create(KEY_ALL_ACCESS) do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenkeyreadOnly('\SOFTWARE\GINKOIA') then
    begin
      result := IncludeTrailingBackslash(Readstring('InstallDir'));
    end;
    free;
  end;

end;

function SearchLocalGinkoiaPathBase(): string;
var
  VLecteurs: TStringList;
  i: integer;
  Bits: set of 0..25;
  FileBase: string;
begin
  // on liste les disque présents, puis on cherche dans le répertoire Ginkoia et si pas trouvé dans le répertoire sources

  result := '';

  VLecteurs := TStringList.Create;
  try
    integer(Bits) := GetLogicalDrives;
    for i := 0 to 25 do
    begin
      if i in Bits then
        VLecteurs.Append(char(i + Ord('A')) + ':\')
    end;

    for i := 0 to VLecteurs.Count - 1 do
    begin
      // pour chaque lecteur on cherche si on à un répertoire Ginkoia
      FileBase := VLecteurs[i] + 'Ginkoia\Data\Ginkoia.ib';

      // si on le trouve, on vérifie que les fichiers utiles sont présents
      // on test les trois fichiers, s'ils existent, on renvoi le chemin des sources et on sort de la boucle
      if (FileExists(FileBase)) then
      begin
        result := FileBase;
        break;
      end;
    end;
  finally
    VLecteurs.free;
  end;
end;

function SearchSourcesEasy(aFolderToSearch: string = ''; onlySearchPath: boolean = False): string;
var
  VLecteurs: TStringList;
  i: integer;
  Bits: set of 0..25;
  FolderSrc: string;
begin
  // on liste les disque présents, puis on cherche dans le répertoire Ginkoia et si pas trouvé dans le répertoire sources

  result := '';

  // si un chemin est passé, on cherche d'abord dans ce chemin
  if (aFolderToSearch <> '') then
  begin
    if DirectoryExists(aFolderToSearch) then
    begin
      // si on le trouve, on vérifie que les fichiers utiles sont présents
      // on test les trois fichiers, s'ils existent, on renvoi le chemin des sources et on sort de la boucle
      //if (FileExists(aFolderToSearch + 'EasyDeploy.exe')) and (FileExists(aFolderToSearch + 'Java.7z')) and (FileExists(aFolderToSearch + 'symmetric-pro-3.7.36-setup.jar')) then
      //EasyDeploy.exe est maintenant embarqué
      if (FileExists(aFolderToSearch + 'Java.7z')) and (FileExists(aFolderToSearch + 'symmetric-pro-3.7.36-setup.jar')) then
      begin
        result := aFolderToSearch;
      end;
    end;
  end;

  if (onlySearchPath) and (aFolderToSearch <> '') then
    Exit;

  if result = '' then
  begin
    VLecteurs := TStringList.Create;
    try
      integer(Bits) := GetLogicalDrives;
      for i := 0 to 25 do
      begin
        if i in Bits then
          VLecteurs.Append(char(i + Ord('A')) + ':\')
      end;

      for i := 0 to VLecteurs.Count - 1 do
      begin
        // pour chaque lecteur on cherche si on à un répertoire Ginkoia
        FolderSrc := VLecteurs[i] + 'Ginkoia\EasyInstall\';

        if DirectoryExists(FolderSrc) then
        begin
          // si on le trouve, on vérifie que les fichiers utiles sont présents
          // on test les trois fichiers, s'ils existent, on renvoi le chemin des sources et on sort de la boucle
          //if (FileExists(FolderSrc + 'EasyDeploy.exe')) and (FileExists(FolderSrc + 'Java.7z')) and (FileExists(FolderSrc + 'symmetric-pro-3.7.36-setup.jar')) then
          //EasyDeploy.exe est maintenant embarqué
          if (FileExists(FolderSrc + 'Java.7z')) and (FileExists(FolderSrc + 'symmetric-pro-3.7.36-setup.jar')) then
          begin
            result := FolderSrc;
            break;
          end;
        end;
      end;

      // si après avoir parcouru tous les disques on a toujours pas trouvé les sources, on cherche la même chose dans le répertoire sources
      if result = '' then
      begin
        for i := 0 to VLecteurs.Count - 1 do
        begin
          // pour chaque lecteur on cherche si on à un répertoire Ginkoia
          FolderSrc := VLecteurs[i] + 'Sources\Easy\';

          if DirectoryExists(FolderSrc) then
          begin
            // si on le trouve, on vérifie que les fichiers utiles sont présents
            // on test les trois fichiers, s'ils existent, on renvoi le chemin des sources et on sort de la boucle
            //if (FileExists(FolderSrc + 'EasyDeploy.exe')) and (FileExists(FolderSrc + 'Java.7z')) and (FileExists(FolderSrc + 'symmetric-pro-3.7.36-setup.jar')) then
            //EasyDeploy.exe est maintenant embarqué
            if (FileExists(FolderSrc + 'Java.7z')) and (FileExists(FolderSrc + 'symmetric-pro-3.7.36-setup.jar')) then
            begin
              result := FolderSrc;
              break;
            end;
          end;
        end;
      end;

    finally
      VLecteurs.free;
    end;
  end;
end;

function ArchiveIsEasy(aFile: string): boolean;
var
  vZip: I7zInArchive;
  ArchiveItem: string;
  i: integer;
begin
  result := False;

  if FileExists(aFile) then
  begin
    vZip := CreateInArchive(CLSID_CFormatZip);
    // on vérifie si on est sous easy en parcourant l'archive
    try
      vZip.Openfile(aFile);

      // on parcourt tous les fichiers de l'archive pour voir si c'est une base .split ou .ib
      for i := 0 to vZip.NumberOfItems - 1 do
      begin
        ArchiveItem := vZip.ItemPath[i];
        if (lowercase(ArchiveItem.Substring(0, 5)) = 'data\') then
        begin
          if (lowercase(ArchiveItem.Substring(Length(ArchiveItem) - 6, 6)) = '.split') then
          begin
            result := true;
            break;
          end;
        end;
      end;
    finally
      vZip.Close();
    end;

  end;
end;

function InstallEasy(aPathEasy, aPathInstall: string; aSender: string = ''): boolean;
var
  installOk: integer;
  splitPath, fileName, folderToCheck: string;
  fileInfo: TSearchRec;
  Res: TResourceStream;
begin
  result := False;
  splitPath := '';

  // on extrait le Easy Deploy des ressources, et on le supprime à la fin
  Res := TResourceStream.Create(0, 'EasyDeployRes', RT_RCDATA);
  try
    Res.SaveToFile(aPathEasy + 'EasyDeploy.exe');
  finally
    Res.Free;
  end;


  if not FileExists(aPathEasy + 'EasyDeploy.exe') then
  begin
    ShowMessage(RST_ERROR_EASYDEPLOY);
    exit;
  end;


  // si on a le sender de passé, on est sur une base IB et pas un split et on veut faire l'installation directement depuis cette base
  if aSender <> '' then
  begin
    // on lance EasyDeploy et on attends le code de retour
    installOk := ExecuteAndWait(aPathEasy + 'EasyDeploy.exe', '"' + aPathEasy + 'EasyDeploy.exe' + '"' + ' DRIVE="' + ExtractFileDrive(aPathInstall) + '\' + '" SENDER="' + aSender + '" AUTO');
  end
  else
  begin

    folderToCheck := IncludeTrailingBackslash(aPathInstall) + 'data\';

    // on récupère le chemin du split
    if FindFirst(folderToCheck + '*.*', faAnyFile, fileInfo) = 0 then
    begin
      repeat
        // cas d'un fichier
        if ((fileInfo.Attr and faDirectory) = 0) then
        begin
          fileName := lowercase(fileInfo.FindData.cFileName);

          // Writeligne('Fichier : ' + info.FindData.cFileName);

          // on test si l'extension est 7z, si oui on retourne ce fichier
          if (lowercase(ExtractFileExt(fileName)) = '.split') then
          begin
            // si on trouve une archive, on regarde si le fichier INI associé existe,
            // si oui le fichier est valide et le téléchargement est terminé

            splitPath := folderToCheck + fileName;
          end;
        end;
        // Il faut ensuite rechercher l'entrée suivante
      until FindNext(fileInfo) <> 0;
      // Dans le cas ou une entrée au moins est trouvée il faut appeler FindClose pour libérer les ressources de la recherche
      FindClose(fileInfo);
    end;

    if splitPath = '' then
    begin
      ShowMessage(RST_ERROR_EASYSPLIT);
      exit;
    end;

    // on lance EasyDeploy et on attends le code de retour
    installOk := ExecuteAndWait(aPathEasy + 'EasyDeploy.exe', '"' + aPathEasy + 'EasyDeploy.exe' + '"' + ' DRIVE="' + ExtractFileDrive(aPathInstall) + '\' + '" SPLIT="' + splitPath + '" AUTO');
  end;

  if FileExists(aPathEasy + 'EasyDeploy.exe') then
  begin
    DeleteFile(aPathEasy + 'EasyDeploy.exe')
  end;

  if installOk = 0 then
    result := true;
end;

function InstallEasyNew(aDriveOrigin, aPathInstall, aSender: string; IsPortable, IsCaisseSec: Boolean; EasyURL: String): boolean;
var
  vNodeName: String;
  vGroup: string;
begin
  result := False;

  // si le Ginkoia copié n'était pas sur le même lecteur, il faut changer la lettre dans les fichiers suivants
  if (aDriveOrigin + ':' <> ExtractFileDrive(aPathInstall)) then
  begin
    if not (UpdateConfFiles(aDriveOrigin, ExcludeTrailingBackslash(aPathInstall))) then
    begin
      ShowMessage('Erreur lors de la modification les fichiers de configuration de Easy');
      Exit;
    end;
  end;

  if IsPortable then
    vGroup := 'portables'
  else
    vGroup := 'mags';

  // on génère le fichier properties
  if not (GenerePropertiesFiles(Sender_To_Node(aSender), vGroup, EasyURL, aPathInstall)) then
  begin
    ShowMessage('Erreur lors de la création du fichier properties de Easy');
    Exit;
  end;

  // Installation et démarrage du service
  ShellExecute(0, 'open', PWideChar(aPathInstall + '\EASY\bin\sym_service.bat'), 'install', Nil, SW_SHOW);
  Sleep(5000);
  ShellExecute(0, 'open', PWideChar(aPathInstall + '\EASY\bin\sym_service.bat'), 'start', Nil, SW_SHOW);

  result := true;
end;

function GenerePropertiesFiles(aNode: string; aGroup: string; aURL: String; aPathInstall: String):boolean;
var
  slConfFile: TstringList;
  vEngineName: string;
begin
  Result := False;
  vEngineName:= aGroup + '-' + aNode;

  slConfFile := TStringList.Create();
  try

    slConfFile.NameValueSeparator             := '=';
    slConfFile.Values['external.id']          := aNode;
    slConfFile.Values['engine.name']          := vEngineName;
    slConfFile.Values['group.id']             := aGroup;
    slConfFile.Values['sync.url']             := Format('http\://%s\:32415/sync/%s',[GetComputerNetName, vEngineName]);
    slConfFile.Values['db.driver']            := 'interbase.interclient.Driver';
    slConfFile.Values['db.url']               := ReplaceStr('jdbc:interbase://localhost:3050/' + ReplaceStr(aPathInstall + '\DATA\Ginkoia.ib', '\', '/'),':','\:');
    slConfFile.Values['db.user']              := 'SYSDBA';
    slConfFile.Values['db.password']          := 'masterkey';
    slConfFile.Values['db.validation.query']  := 'SELECT CAST(1 AS INTEGER) FROM RDB$DATABASE';
    slConfFile.Values['registration.url']     := ReplaceStr(aURL,':','\:');
    slConfFile.Values['auto.config.registration.svr.sql.script'] := IncludeTrailingPathDelimiter(aPathInstall) + 'Easy\' + 'grants.sql';
    slConfFile.SaveToFile(IncludeTrailingPathDelimiter(aPathInstall) + 'Easy\engines\' + vEngineName + '.properties');
  finally
    slConfFile.Free();
  end;

  Result := True;
end;

function UpdateConfFiles(const aDriveOrigin: string; const aPathInstall: string): boolean;
var
  TsFileMod: TStringList;
  vFile: String;
  i: Integer;
begin
  Result := False;

  // on ouvre le fichier
  TsFileMod := TStringList.Create;
  Try
    // fichier setenv.bat
    vFile := aPathInstall + '\EASY\bin\setenv.bat';
    if not FileExists(vFile) then
    begin
      ShowMessage(Format(RTS_ERRORFINDFILE,[vFile]));
      Exit;
    end;
    TsFileMod.LoadFromFile(vFile);

    for i := 0 to TsFileMod.Count - 1 do
    begin
      if (ContainsText(TsFileMod[i], aDriveOrigin + ':\GINKOIA')) then
        TsFileMod[i] := StringReplace(TsFileMod[i], aDriveOrigin +':\GINKOIA', aPathInstall, [rfReplaceAll])
    end;

    TsFileMod.SaveToFile(vFile);

    // fichier sym_service.conf
    TsFileMod.Clear;
    vFile := aPathInstall + '\EASY\conf\sym_service.conf';
    if not FileExists(vFile) then
    begin
      ShowMessage(Format(RTS_ERRORFINDFILE,[vFile]));
      Exit;
    end;
    TsFileMod.LoadFromFile(vFile);

    for i := 0 to TsFileMod.Count - 1 do
    begin
      if (ContainsText(TsFileMod[i], aDriveOrigin + ':\GINKOIA')) then
        TsFileMod[i] := StringReplace(TsFileMod[i], aDriveOrigin +':\GINKOIA', aPathInstall, [rfReplaceAll])
    end;

    TsFileMod.SaveToFile(vFile);

    Result := True;
  Finally
    TsFileMod.Free;
  end;
end;

function Sender_To_Node(aSender:string):string;
var tmp:string;
begin
   tmp:=LowerCase(aSender);
   if RightStr(tmp,4)='-sec' then
    begin
      tmp := StringReplace(tmp,'serveur','',[]);
      tmp :='sec'+tmp;
    end;
   tmp := StringReplace(tmp,'serveur','s',[]);
   tmp := StringReplace(tmp,'portable','p',[]);
   tmp := StringReplace(tmp,'-sync','-s',[]);
   tmp := Copy(tmp, 1, 30);
   result:=tmp;
end;

function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

procedure CleanRegistryDelos();
var
  reg: Tregistry;
  stringValue: string;
  ListStrings: TStringList;
  i: integer;
begin
  // On regarde si les valeurs existe, et si ou on les supprimes
  try
    reg := Tregistry.Create();
    try
      // ******************************************
      // ************ clé d'autorun ***************
      // ******************************************
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('Software\wow6432Node\Microsoft\Windows\CurrentVersion\Run', true);
      stringValue := reg.Readstring('Launch_Replication');
      // si c'est la clé du launchV7 on la supprime
      if pos(lowercase(LAUNCHER), lowercase(stringValue)) > 0 then
      begin
        reg.DeleteValue('Launch_Replication');
      end;

      // ******************************************
      // ****** Toutes les clés dans UFH\SHC ******
      // ******************************************
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\UFH\SHC', true);
      // on parcourt toutes les valeurs de cette clé et on supprime celles qui contienent launchV7
      ListStrings := TStringList.Create;
      try
        reg.GetValueNames(ListStrings);
        for i := 0 to ListStrings.Count - 1 do
        begin
          // if (reg.ReadString('0') is String) then
          stringValue := '';

          // uniquement si la valeur est de type string
          if reg.GetDataType(ListStrings[i]) = rdString then
          begin
            stringValue := reg.Readstring(ListStrings[i]);

            // si c'est la clé du launchV7 on la supprime
            if pos(lowercase(LAUNCHER), lowercase(stringValue)) > 0 then
            begin
              reg.DeleteValue(ListStrings[i]);
            end;
          end;
        end;
      finally
        ListStrings.free;
      end;
      // C:\Users\jolya\Desktop\LaunchV7.exe

    finally
      reg.CloseKey;
      reg.free;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erreur lors du nettoyage du registre des clés du launcher Delos');
      Log.Log(Log_Mdl, 'CleanRegistryDelos', 'Erreur lors du nettoyage du registre des clés du launcher Delos : ' + E.Message, logError, True, 0, ltBoth);
    end;
  end;
end;

procedure SetRegionToFr();
var
  localeLCID: longint;
  i: integer;
  reg: Tregistry;
  ListStrings: TStringList;
begin
  Log.Log(Log_Mdl, 'SetRegionToFr', 'Mise à jour des paramètres régionaux', logInfo, True, 0, ltBoth);

  localeLCID := GetUserDefaultLCID();

  // changement des paramètres régionaux
  // dates courtes et longues
  if not SetLocaleInfo(localeLCID, LOCALE_SSHORTDATE, 'dd/MM/yyyy') then
    raise Exception.Create('Impossible de mettre à jour le paramètre régional de date courte : ' + SysErrorMessage(GetLastError));
  if not SetLocaleInfo(localeLCID, LOCALE_SLONGDATE, 'dddd d MMMM yyyy') then
    raise Exception.Create('Impossible de mettre à jour le paramètre régional de date longue');

  // heures courtes et longues
  if not SetLocaleInfo(localeLCID, LOCALE_SSHORTTIME, 'HH:mm') then
    raise Exception.Create('Impossible de mettre à jour le paramètre régional d''heure courte : ' + SysErrorMessage(GetLastError));
  if not SetLocaleInfo(localeLCID, LOCALE_STIMEFORMAT, 'HH:mm:ss') then
    raise Exception.Create('Impossible de mettre à jour le paramètre régional d'' heure longue : ' + SysErrorMessage(GetLastError));

  // 1er jour de la semaine
  if not SetLocaleInfo(localeLCID, LOCALE_IFIRSTDAYOFWEEK, '0') then
    raise Exception.Create('Impossible de mettre à jour le paramètre régional du premier jour de la semaine : ' + SysErrorMessage(GetLastError));

  // envoi du changement au système pour que les applications en cours le prenne en compte
  PostMessage(HWND_BROADCAST, WM_WININICHANGE, 0, 0);

end;

procedure ErrorMsg(sMsg: string);
var
  oMsg: TForm;
begin
  Log.Log(Log_Mdl, 'ErrorMsg', sMsg, logError, True, 0, ltBoth);

  oMsg := CreateMessageDialog(sMsg, mtError, [mbOk]);
  oMsg.Position := poOwnerFormCenter;
  oMsg.FormStyle := fsStayOnTop;
  oMsg.ShowModal;
  oMsg.Release;
end;

function BackupFile(aFile: string; aProgressBar: TProgressBar): boolean;
var
  newName, fileExt: string;
  Retour: LongBool;
begin
  result := True;
  Retour := False;

  fileExt := ExtractFileExt(aFile);
  newName := ChangeFileExt(aFile, '') + '_backup' + fileExt;

  TotalSize := 0; // set à 0 pour que le callback se serve de la taille du fichier en cours
  aProgressBar.Visible := true;
  aProgressBar.Position := 0;
  aProgressBar.Align := alBottom;
  aProgressBar.Max := 100;

  if not CopyFileEx(PWideChar(aFile), PWideChar(newName), @CopyCallBack, aProgressBar, @Retour, COPY_FILE_NO_BUFFERING) then
  begin
    result := False;
    //ShowMessage(SysErrorMessage(GetLastError));
  end;

  aProgressBar.Visible := False;
  aProgressBar.Position := 0;
end;

function CopyFileWithProgressBar(aFileFrom, aFileTo: string; aProgressBar: TProgressBar): boolean;
var
  Retour: LongBool;
begin
  result := True;
  Retour := False;

  TotalSize := 0; // set à 0 pour que le callback se serve de la taille du fichier en cours
  aProgressBar.Visible := true;
  aProgressBar.Position := 0;
  aProgressBar.Align := alBottom;
  aProgressBar.Max := 100;

  if not CopyFileEx(PWideChar(aFileFrom), PWideChar(aFileTo), @CopyCallBack, aProgressBar, @Retour, COPY_FILE_NO_BUFFERING) then
  begin
    result := False;
    ErrorMsg('Erreur lors de la copie du fichier : ' + SysErrorMessage(GetLastError));
    //ShowMessage(SysErrorMessage(GetLastError));
  end;

  aProgressBar.Visible := False;
  aProgressBar.Position := 0;
end;

function CopyCallBack(TotalFileSize: Int64;          // Taille totale du fichier en octets
  TotalBytesTransferred: Int64;  // Nombre d'octets déjàs transférés
  StreamSize: Int64;             // Taille totale du flux en cours
  StreamBytesTransferred: Int64; // Nombre d'octets déjà tranférés dans ce flus
  dwStreamNumber: DWord;                 // Numéro de flux actuem
  dwCallbackReason: DWord;               // Raison de l'appel de cette fonction
  hSourceFile: THandle;                  // handle du fichier source
  hDestinationFile: THandle;             // handle du fichier destination
  ProgressBar: TProgressBar             // paramètre passé à la fonction qui est une progress bar
): DWord; far; stdcall;
var
  EnCours: Int64;
begin
  if Assigned(ProgressBar) then
  begin
      // cas ou on a une progression totale avec plusieurs fichiers
    if (TotalSize > 0) then // pour éviter la division par 0
      ProgressBar.Position := Round((CurrentSize + TotalBytesTransferred) / TotalSize * 100)
    else
      // cas ou c'est juste la progression sur le fichier en corus
    begin
      ProgressBar.Position := TotalBytesTransferred * 100 div TotalFileSize;
    end;
  end;

  Result := PROGRESS_CONTINUE;
end;

function CheckIfCashFolderExists(PathDistant, PathLocal: string): Boolean;
var
  FoldToSkip: TStringList;
  ExtToSkip: TStringList;
begin
  Result := True;
  PathDistant := IncludeTrailingPathDelimiter(PathDistant);
  PathLocal := IncludeTrailingPathDelimiter(PathLocal);

  if not DirectoryExists(PathLocal) then
  begin
    ExtToSkip := TStringList.Create;
    FoldToSkip := TStringList.Create;
    try
      FoldToSkip.Clear;
      FoldToSkip.Add('logs');
      FoldToSkip.Add('exceptions');

      ExtToSkip.Clear;
      ExtToSkip.Add('.ini');
      ExtToSkip.Add('.tmp');

      Result := CopyFolder(PathDistant, PathLocal, ExtToSkip, FoldToSkip);
    finally
      FreeAndNil(FoldToSkip);
      FreeAndNil(ExtToSkip);
    end;
  end;
end;

function CopyFolder(PathDistant, PathLocal: String; extsToSkip: TStringList = Nil; FoldersToSkip: TStringList = Nil): boolean;
var
  FileList: TStringList;
  i, j, tentatives: integer;
  arrayFiles: TArray<RFileToCopy>;
  Retour: LongBool;
  doExtFolder: Boolean;
begin
  result := False;
  PathLocal := IncludeTrailingPathDelimiter(PathLocal);
  PathDistant := IncludeTrailingPathDelimiter(PathDistant);

  // On copie le contenu de Synchro, Easy et JAVA
  // on commence par créer le répertoire en local
  if not DirectoryExists(PathLocal) then
    if not CreateDir(PathLocal) then
      exit;

  try
    TotalSize := 0;
    CurrentSize := 0;

    // on ajoute le contenu du répertoire Synchro
    GatherFilesFromDirectory(PathDistant, arrayFiles, TotalSize);

    try
      if Length(arrayFiles) = 0 then // on a pas pu récupérer de fichiers
      begin
        ErrorMsg('Impossible de récupérer la liste des fichiers à copier');
        exit;
      end;

      for i := 0 to Length(arrayFiles) - 1 do
      begin

        doExtFolder := True;

        // si c'est un sous dossier à skip, on ne le prends pas
        if Assigned(FoldersToSkip) then
        begin
          for j := 0 to FoldersToSkip.Count - 1 do
          begin
            if (LowerCase(arrayFiles[i].folderName) = LowerCase(IncludeTrailingPathDelimiter(FoldersToSkip[j]))) then
            begin
              doExtFolder := False;
              break;
            end;
          end;
        end;

        // si c'est une extension à skip, on ne la prends pas
        if Assigned(extsToSkip) then
        begin
          for j := 0 to extsToSkip.Count - 1 do
          begin
            if (LowerCase(ExtractFileExt(arrayFiles[i].fileName)) = LowerCase(extsToSkip[j])) then
            begin
              doExtFolder := False;
              break;
            end;
          end;
        end;

        if not doExtFolder then
          Continue;

        if not DirectoryExists(PathLocal + arrayFiles[i].folderName) then
        begin
          if not forcedirectories(PathLocal + arrayFiles[i].folderName) then
          begin
            ErrorMsg('Impossible de créer le sous-dossier : ' + arrayFiles[i].folderName);
            exit;
          end;
        end;

        // on fait jusqu'à trois tentatives de copie avec une pause de 5 secondes
        for tentatives := 0 to 2 do
        begin
          if not CopyFileEx(PWideChar(PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName), PWideChar(PathLocal + arrayFiles[i].folderName + arrayFiles[i].fileName), @CopyCallBack, Nil, @Retour, COPY_FILE_NO_BUFFERING) then
          begin
            if tentatives = 2 then
            begin
              Log.Log(Log_Mdl, 'CopyFolder', 'Erreur lors de la copie du fichier ' + PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName, logError, True, 0, ltBoth);

              ErrorMsg('Erreur lors de la copie du fichier ' + PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName);
              exit;
            end
            else
              Sleep(5000);
          end
          else
            Break;
        end;

        CurrentSize := CurrentSize + arrayFiles[i].fileSize;

      end;
    finally
      arrayFiles := nil;
    end;
  except
    on E: Exception do
    begin
      ErrorMsg('Erreur lors de la copie des fichiers par le réseau : ' + E.Message);
      exit;
    end;
  end;

  result := true;
end;

function CopyFromServeur(PathDistant, PathLocal, PathSourcesEasy: string; aProgressBar: TProgressBar = Nil; aLbl: TLabel = Nil): boolean;
var
  FileList: TStringList;
  i, tentatives: integer;
  arrayFiles: TArray<RFileToCopy>;
  Retour: LongBool;
begin
  result := False;
  Retour := False;
  PathLocal := IncludeTrailingPathDelimiter(PathLocal);
  PathDistant := IncludeTrailingPathDelimiter(PathDistant);

  // On copie le contenu de Synchro, Easy et JAVA
  // on commence par créer le répertoire en local
  if not DirectoryExists(PathLocal) then
    if not CreateDir(PathLocal) then
      exit;

  try
    TotalSize := 0;
    CurrentSize := 0;

    // on ajoute le contenu du répertoire Synchro
    GatherFilesFromDirectory(PathDistant + 'Data\Synchro\', arrayFiles, TotalSize, 'Data\Synchro');

    // si les sources Easy ont été trouvé sur le serveur distant, on les ajoute à la liste des fichier à copier
    // plus utilisé dans la nouvelle version, on modifie directement les fichiers Easy
//    if ExtractFileDrive(PathDistant) = ExtractFileDrive(PathSourcesEasy) then
//      GatherFilesFromDirectory(PathSourcesEasy, arrayFiles, TotalSize, ExtractFileName(ExcludeTrailingPathDelimiter(PathSourcesEasy)));

    // à présent on prends les dossiers Easy et JAVA depuis le server
    GatherFilesFromDirectory(PathDistant + 'EASY\', arrayFiles, TotalSize, 'EASY');
    GatherFilesFromDirectory(PathDistant + 'JAVA\', arrayFiles, TotalSize, 'JAVA');

    try
      if Assigned(aProgressBar) then
      begin
        aProgressBar.Visible := true;
        aProgressBar.Position := 0;
        aProgressBar.Max := 100;
      end;

      if Length(arrayFiles) = 0 then // on a pas pu récupérer de fichiers
      begin
        ErrorMsg('Impossible de récupérer la liste des fichiers à copier');
        exit;
      end;

      for i := 0 to Length(arrayFiles) - 1 do
      begin
        // si c'est un sous dossier et qu'il n'existe pas, on le créé, uniquement s'il ne s'agit pas des dossiers easy et eai
        if not DirectoryExists(PathLocal + arrayFiles[i].folderName) then
        begin
          //if (LowerCase(LeftStr(arrayFiles[i].folderName, 5)) <> 'easy\') and (LowerCase(LeftStr(arrayFiles[i].folderName, 4)) <> 'eai\') then
          // à présent on copie le répertoire Easy, on copie tout ce qui a été passé
          if not forcedirectories(PathLocal + arrayFiles[i].folderName) then
          begin
            ErrorMsg('Impossible de créer le sous-dossier : ' + arrayFiles[i].folderName);
            exit;
          end;
        end;

        if (LowerCase(LeftStr(arrayFiles[i].folderName,9)) = 'easy\tmp\') or (LowerCase(LeftStr(arrayFiles[i].folderName,10)) = 'easy\logs\') or (LowerCase(LeftStr(arrayFiles[i].folderName,13)) = 'easy\engines\')  then
        begin
          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
          Continue;
        end;

        if Assigned(aLbl) then
        begin
          aLbl.Caption := 'Copie de : ' + arrayFiles[i].fileName;
          Application.ProcessMessages;
        end;

        // on fait jusqu'à trois tentatives de copie avec une pause de 5 secondes
        for tentatives := 0 to 2 do
        begin
          if not CopyFileEx(PWideChar(PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName), PWideChar(PathLocal + arrayFiles[i].folderName + arrayFiles[i].fileName), @CopyCallBack, aProgressBar, @Retour, COPY_FILE_NO_BUFFERING) then
          begin
            if tentatives = 2 then
            begin
              Log.Log(Log_Mdl, 'CopyGinkoiaFromServer', 'Erreur lors de la copie du fichier ' + PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName, logError, True, 0, ltBoth);
              if Assigned(aProgressBar) then
                aProgressBar.Position := 0;
              ErrorMsg('Erreur lors de la copie du fichier ' + PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName);
              exit;
            end
            else
              Sleep(5000);
          end
          else
            Break;
        end;

        CurrentSize := CurrentSize + arrayFiles[i].fileSize;

      end;
    finally
      arrayFiles := nil;

      if Assigned(aProgressBar) then
      begin
        aProgressBar.Visible := False;
        aProgressBar.Position := 0;
      end;
    end;

    // on supprime les dossiers propres au serveur d'origine
    if not (RecreateDirectory(PathLocal + 'EASY\engines\')) then
    begin
      ErrorMsg('Erreur lors de la création du répertoire ' + PathLocal + 'EASY\engines\');
      Exit;
    end;
    if not (RecreateDirectory(PathLocal + 'EASY\logs\')) then
    begin
      ErrorMsg('Erreur lors de la création du répertoire ' + PathLocal + 'EASY\logs\');
      Exit;
    end;
    if not (RecreateDirectory(PathLocal + 'EASY\tmp\')) then
    begin
      ErrorMsg('Erreur lors de la création du répertoire ' + PathLocal + 'EASY\tmp\');
      Exit;
    end;

    // après la copie, si on prends la toto on remplace la Ginkoia.ib, puis on supprime le répertoire backup dans tous les cas
    if Assigned(aLbl) then
    begin
      aLbl.Caption := 'Remplacement de la base locale par la base copiée';
      Application.ProcessMessages;
    end;

    aProgressBar.Visible := True;
    aProgressBar.Position := 0;
    TotalSize := 0; // pour que le callback prenne la taille du fichier et pas la taille totale
    if not MoveFileWithProgress(PWideChar(PathLocal + 'data\Synchro\GINKCOPY.IB'), PWideChar(PathLocal + 'data\GINKOIA.IB'), @CopyCallBack, aProgressBar, MOVEFILE_COPY_ALLOWED or MOVEFILE_REPLACE_EXISTING) then
    begin
      ErrorMsg('Erreur lors du remplacement de la base Ginkoia par la Synchro : ' + SysErrorMessage(GetLastError));
      exit;
    end;
    aProgressBar.Visible := False;


    // on restart la base
    if Assigned(aLbl) then
    begin
      aLbl.Caption := 'Restart de la base locale';
      Application.ProcessMessages;
    end;

    RestartDatabase(PathLocal + 'data\GINKOIA.IB');
  except
    on E: Exception do
    begin
      ErrorMsg('Erreur lors de la copie des fichiers par le réseau : ' + E.Message);
      exit;
    end;
  end;

  result := true;
end;

function RecreateDirectory(aPath: String): Boolean;
begin
  Result := True;

  if DirectoryExists(aPath) then
  begin
    if not DelDir(aPath) then
    begin
      Result := False;
      exit;
    end;
  end;

  if not CreateDir(aPath) then
  begin
    Result := False;
    exit;
  end;
end;

// ancienne fonction pour la copie de tout le répertoire ginkoia, remplacé par le copie uniquement de la synchro et des sources Easy
//function CopyGinkoiaFromServer(PathDistant, PathLocal: string; CopyToto: boolean; aProgressBar: TProgressBar = Nil): boolean;
//var
//  FileList: TStringList;
//  TotalSize, CurrentSize: Int64;
//  i, tentatives: integer;
//  arrayFiles: TArray<RFileToCopy>;
//begin
//  result := False;
//  PathLocal := IncludeTrailingPathDelimiter(PathLocal);
//  PathDistant := IncludeTrailingPathDelimiter(PathDistant);
//
//  // On copie tout le répertoire, on supprime ensuite les backup et la ginkoia.ib si la toto est présente
//  // on commence par créer le répertoire en local
//  if not DirectoryExists(PathLocal) then
//    if not CreateDir(PathLocal) then
//      exit;
//
//  try
//    TotalSize := 0;
//    CurrentSize := 0;
//    // FileList := TStringList.Create;
//    try
//      GatherFilesFromDirectory(PathDistant, arrayFiles, TotalSize);
//      if Assigned(aProgressBar) then
//      begin
//        aProgressBar.Visible := true;
//        aProgressBar.Position := 0;
//        aProgressBar.Max := 100;
//      end;
//
//      if Length(arrayFiles) = 0 then // on a pas pu récupérer de fichiers
//      begin
//        ErrorMsg('Impossible de récupérer la liste des fichiers à copier');
//        exit;
//      end;
//
//      for i := 0 to Length(arrayFiles) - 1 do
//      begin
//        // si c'est un sous dossier et qu'il n'existe pas, on le créé, uniquement s'il ne s'agit pas des dossiers easy et eai
//        if not DirectoryExists(PathLocal + arrayFiles[i].folderName) then
//        begin
//          if (LowerCase(LeftStr(arrayFiles[i].folderName, 5)) <> 'easy\') and (LowerCase(LeftStr(arrayFiles[i].folderName, 4)) <> 'eai\') then
//          begin
//            if not forcedirectories(PathLocal + arrayFiles[i].folderName) then
//            begin
//              ErrorMsg('Impossible de créer le sous-dossier : ' + arrayFiles[i].folderName);
//              exit;
//            end;
//          end;
//        end;
//
//        // si c'est le répertoire Backup est qu'on ne copie pas le fichier Toto, on ne fait pas la copie du fichier en cours
//        if LowerCase(arrayFiles[i].folderName) = 'data\backup\' then
//        begin
//          if LowerCase(arrayFiles[i].fileName) <> 'ginkoia.toto' then
//          begin
//            CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//            Continue;
//          end;
//        end;
//
//        // si on copie la toto, on ne copie pas la ginkoia.ib et les autres fichiers ib qu'il pourrait y avoir
//        //dans le répertoire data pour gagner du temps et éviter les problèmes de fichier en cours d'utilisation
//        if LowerCase(LeftStr(arrayFiles[i].folderName,5)) = 'data\' then
//        begin
//          if CopyToto and (LowerCase(arrayFiles[i].fileName) = 'ginkoia.ib') then
//          begin
//            CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//            Continue;
//          end;
//
//          if (MatchText(ExtractFileExt(LowerCase(arrayFiles[i].fileName)), ['.ib', '.split', '.7z', '.zip', '.gbk', '.txt', '.log', '.tmp'])) and (LowerCase(arrayFiles[i].fileName) <> 'ginkoia.ib') then
//          begin
//            CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//            Continue;
//          end;
//        end;
//
//        // ************************************************
//        // ** liste des répertoires à ne pas récuperer ****
//        // ************************************************
//
//        // si c'est le répertoire Easy on ne copie pas le contenu
//        if LowerCase(LeftStr(arrayFiles[i].folderName, 5)) = 'easy\' then
//        begin
//          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//          Continue;
//        end;
//
//        // si c'est le répertoire EAI on ne copie pas le contenu
//        if LowerCase(LeftStr(arrayFiles[i].folderName, 4)) = 'eai\' then
//        begin
//          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//          Continue;
//        end;
//
//        if LowerCase(LeftStr(arrayFiles[i].folderName, 5)) = 'test\' then
//        begin
//          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//          Continue;
//        end;
//
//        if LowerCase(LeftStr(arrayFiles[i].folderName, 6)) = 'sauve\' then
//        begin
//          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//          Continue;
//        end;
//
//        if LowerCase(LeftStr(arrayFiles[i].folderName, 11)) = 'liveupdate\' then
//        begin
//          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//          Continue;
//        end;
//
//        if LowerCase(LeftStr(arrayFiles[i].folderName, 6)) = 'a_maj\' then
//        begin
//          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//          Continue;
//        end;
//
//        if LowerCase(LeftStr(arrayFiles[i].folderName, 8)) = 'a_patch\' then
//        begin
//          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//          Continue;
//        end;
//
//        if LowerCase(LeftStr(arrayFiles[i].folderName, 4)) = 'bdc\' then
//        begin
//          CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//          Continue;
//        end;
//        // ************************************************
//        // * fin liste des répertoires à ne pas récuperer *
//        // ************************************************
//
//        // on fait jusqu'à trois tentatives de copie avec une pause de 5 secondes
//        for tentatives := 0 to 2 do
//        begin
//          if CopyFile(PWideChar(PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName), PWideChar(PathLocal + arrayFiles[i].folderName + arrayFiles[i].fileName), False) then
//          begin
//            if Assigned(aProgressBar) then
//            begin
//              CurrentSize := CurrentSize + arrayFiles[i].fileSize;
//
//              if (TotalSize > 0) then // pour éviter la division par 0
//                aProgressBar.Position := Round(CurrentSize / TotalSize * 100);
//
//              Application.ProcessMessages;
//            end;
//            Break;
//          end
//          else
//          begin
//            // dorénavant on n'interrompt plus la copie sauf s'il s'agit de la base de données
//            // si on a atteint le max de tentatives, on log le fichier manqué
//            if tentatives < 2 then
//              Sleep(5000) // pause de 5 secondes entre chaque tentative
//            else
//            begin
//              if (LowerCase(arrayFiles[i].fileName) = 'Ginkoia.ib') or (LowerCase(arrayFiles[i].fileName) = 'ginkoia.toto') then
//              begin
//                if Assigned(aProgressBar) then
//                  aProgressBar.Position := 0;
//
//                ErrorMsg('Erreur lors de la copie du fichier ' + PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName);
//                exit;
//              end
//              else
//              begin
//                Log.Log(Log_Mdl, 'CopyGinkoiaFromServer', 'Erreur lors de la copie du fichier ' + PathDistant + arrayFiles[i].folderName + arrayFiles[i].fileName, logWarning, True, 0, ltBoth);
//              end;
//            end;
//          end;
//        end;
//      end;
//    finally
//      arrayFiles := nil;
//
//      if Assigned(aProgressBar) then
//      begin
//        aProgressBar.Visible := False;
//        aProgressBar.Position := 0;
//      end;
//
//    end;
//
//    // après la copie, si on prends la toto on remplace la Ginkoia.ib, puis on supprime le répertoire backup dans tous les cas
//    if CopyToto then
//    begin
//      if not MoveFileEx(PWideChar(PathLocal + 'data\backup\GINKOIA.toto'), PWideChar(PathLocal + 'data\GINKOIA.IB'), MOVEFILE_COPY_ALLOWED or MOVEFILE_REPLACE_EXISTING or MOVEFILE_WRITE_THROUGH) then
//      begin
//        ErrorMsg('Erreur lors du remplacement de la base Ginkoia par la Toto');
//        exit;
//      end;
//
//      // on restart la base car toto est shutdown
//      RestartDatabase(PathLocal + 'data\GINKOIA.IB');
//    end;
//
//    // on supprime le répertoire de backup
//    if DirectoryExists(PathLocal + 'data\backup\') then
//    begin
//      if not DelDir(PathLocal + 'data\backup\') then
//      begin
//        ErrorMsg('Erreur lors de la suppression du répertoire de backup');
//        exit;
//      end;
//    end;
//    // On supprime le répertoire easy qui contient les infos de paramétrage
//    if DirectoryExists(PathLocal + 'Easy\') then
//    begin
//      if not DelDir(PathLocal + 'Easy\') then
//      begin
//        ErrorMsg('Erreur lors de la suppression du répertoire Easy');
//        exit;
//      end;
//    end;
//  except
//    on E: Exception do
//    begin
//      ErrorMsg('Erreur lors de la copie de Ginkoia par le réseau : ' + E.Message);
//      exit;
//    end;
//  end;
//
//  result := true;
//end;

procedure GatherFilesFromDirectory(const ADirectory: string; var AFileArray: TArray<RFileToCopy>; out ATotalSize: Int64; aSubFolder: string = '');
var
  SR: TSearchRec;
begin
  try
    if FindFirst(ADirectory + '*.*', faDirectory, SR) = 0 then
    begin
      repeat
        if ((SR.Attr and faDirectory) = SR.Attr) and (SR.Name <> '.') and (SR.Name <> '..') then
        begin
          if aSubFolder <> '' then
            GatherFilesFromDirectory(ADirectory + SR.Name + '\', AFileArray, ATotalSize, aSubFolder + '\' + SR.Name)
          else
            GatherFilesFromDirectory(ADirectory + SR.Name + '\', AFileArray, ATotalSize, SR.Name)
        end;

      until FindNext(SR) <> 0;
      FindClose(SR);
    end;

    if FindFirst(ADirectory + '*.*', faAnyFile, SR) = 0 then
    begin
      repeat
        if ((SR.Attr and not faDirectory) = SR.Attr) and (SR.Name <> '.') and (SR.Name <> '..') then
        begin
          if (aSubFolder <> '') and (AnsiRightStr(aSubFolder, 1) <> '\') then
            aSubFolder := aSubFolder + '\'; // on rajoute le \ pour concatener ensuite au nom de fichier pour le chemin local

          SetLength(AFileArray, Length(AFileArray) + 1);
          AFileArray[Length(AFileArray) - 1].folderName := aSubFolder;
          AFileArray[Length(AFileArray) - 1].fileName := SR.Name;
          AFileArray[Length(AFileArray) - 1].fileSize := SR.Size;

          Inc(ATotalSize, SR.Size);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  except
    on E: Exception do
    begin
      ErrorMsg('Error lors de la récupération de la liste des fichiers : ' + E.Message);
      Log.Log(Log_Mdl, 'GatherFilesFromDirectory', 'Error lors de la récupération de la liste des fichiers : ' + E.Message, logError, True, 0, ltBoth);
      exit;
    end;
  end;

end;

function DelDir(DirPath: string): boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom := PChar(DirPath + #0);
  end;
  result := (0 = ShFileOperation(fos));
end;

procedure RestartDatabase(aBasePath: string);
var
  ibConfig: TFDIBConfig;
  driverLink: TFDPhysIBBaseDriverLink;
begin
  ibConfig := TFDIBConfig.Create(nil);
  driverLink := TFDPhysIBBaseDriverLink.Create(nil);
  try
    try
      driverLink.DriverID := 'IB';
      ibConfig.driverLink := driverLink;
      ibConfig.Protocol := ipTCPIP;
      ibConfig.Database := aBasePath;
      ibConfig.UserName := 'sysdba';
      ibConfig.Password := 'masterkey';
      ibConfig.OnlineDB;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erreur lors du restart de la base : ' + E.Message);
        Log.Log(Log_Mdl, 'RestartDatabase', 'Erreur lors du restart de la base : ' + E.Message, logError, True, 0, ltBoth);
      end;
    end;
  finally
    FreeAndNil(ibConfig);
    FreeAndNil(driverLink);
  end;
end;

procedure ShutdownDatabase(aBasePath: string);
var
  ibConfig: TFDIBConfig;
  driverLink: TFDPhysIBBaseDriverLink;
begin
  ibConfig := TFDIBConfig.Create(nil);
  driverLink := TFDPhysIBBaseDriverLink.Create(nil);
  try
    try
      driverLink.DriverID := 'IB';
      ibConfig.driverLink := driverLink;
      ibConfig.Protocol := ipTCPIP;
      ibConfig.Database := aBasePath;
      ibConfig.UserName := 'sysdba';
      ibConfig.Password := 'masterkey';
      ibConfig.ShutdownDB(smForce, 3);
    except
      on E: Exception do
      begin
        raise Exception.Create('Erreur lors du restart de la base : ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(ibConfig);
    FreeAndNil(driverLink);
  end;
end;

function getMachineGuid: string;
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;

  function GetWMIObject(const objectName: String): IDispatch;
  var
    chEaten: Integer;
    BindCtx: IBindCtx;
    Moniker: IMoniker;
  begin
    OleCheck(CreateBindCtx(0, bindCtx));
    OleCheck(MkParseDisplayName(BindCtx, StringToOleStr(objectName), chEaten, Moniker));
    OleCheck(Moniker.BindToObject(BindCtx, nil, IDispatch, Result));
  end;
begin
  result := '{GUID}';
  CoInitialize(nil);
  try
    objWMIService := GetWMIObject('winmgmts:\\localhost\root\cimv2');
    colItems      := objWMIService.ExecQuery('SELECT SerialNumber FROM Win32_BaseBoard','WQL',0);
    oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
    if oEnum.Next(1, colItem, iValue) = 0 then
      Result := VarToStr(colItem.SerialNumber);
  finally
    CoUninitialize;
  end;
end;

end.

