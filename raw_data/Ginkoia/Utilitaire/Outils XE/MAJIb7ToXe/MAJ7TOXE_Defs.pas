unit MAJ7TOXE_Defs;

interface
  uses SysUtils, uSevenZip, Registry, Windows, IniFiles,Forms;

const
  E0Initialisation = 0;
  E1BackUp         = 10;
  E2Installation12 = 20;
  E2Installation22 = 30;
  E3Restore        = 40;
  E4Divers         = 50;
  EExit            = 999;


type
  TModeRun = (mrServer, mrClient);
  TIBInstall = (ibComplet, ibPatchOnly);

  EIB7NOTPRESENT   = class(Exception);
  EIB7DIRNOTFOUND  = class(Exception);
  EIB7ROOTNOTFOUND = class(Exception);
  EIBXEPRESENT     = class(Exception);
  EIB7NOTSTARTED   = class(Exception);
  EJAVAERRORINST   = class(Exception);

  TInfoBase = record
    public
      NomBase : String;
      CodeTiers : string;
      Magasin : String;
      ModeIbInstall : TIBInstall;
      Infos : record
        Adresse ,
        CodePostal,
        Ville ,
        Telephone : String;
      end;
      procedure SaveIni;
      procedure LoadIni;
  end;

  TInfoSurExe = record
    FileDescription:  String;
    CompanyName:      String;
    FileVersion:      String;
    InternalName:     String;
    LegalCopyright:   String;
    OriginalFileName: String;
    ProductName:      String;
    ProductVersion:   String;
  end;

var
  GAPPPATH ,
  GAPPTEMP ,
  GAPPSAVE ,
  GAPPLOGS ,
  GAPPTOOL : String;

  GINSTALLMODE : TModeRun;
  GIBINSTALL : TIBInstall;

  GINKOIAIBDIR ,
  GINKOIAIB    : string;
  INTERBASEXEBINDIR,
  INTERBASEXEROOTDIR : String;
  INTERBASE7ROOTDIR : String;
  IsAppWorking : Boolean;
  IsLaunchVerifAuto : Boolean;

  InfoBase : TInfoBase; // Permet de stockée les informations de la base lors de l'envoi du mail

  function UnzipFile(ASource, ADestination : string) : Boolean;
  procedure RestartAndRunOnce(AFileToRestart : String);

  // Récupère des informations sur un exécutable
function InfoSurExe(AFichier: String): TInfoSurExe;

implementation

// Récupère des informations sur un exécutable
function InfoSurExe(AFichier: String): TInfoSurExe;
const
  VersionInfo: array [1..8] of String =
    ('FileDescription', 'CompanyName', 'FileVersion',
    'InternalName', 'LegalCopyRight', 'OriginalFileName',
    'ProductName', 'ProductVersion');
var
  Handle:   DWord;
  Info:     Pointer;
  InfoData: PChar;
  InfoSize: Longint;
  DataLen:  UInt;
  LangPtr:  Pointer;
  InfoType: String;
  i:        Integer;
begin
  // Récupère la taille nécessaire pour les infos
  InfoSize := GetFileVersionInfoSize(Pchar(AFichier), Handle);

  // Initialise la variable de retour
  with Result do
  begin
    FileDescription  := '';
    CompanyName      := '';
    FileVersion      := '';
    InternalName     := '';
    LegalCopyright   := '';
    OriginalFileName := '';
    ProductName      := '';
    ProductVersion   := '';
  end;
  i := 1;

  // Si il y a des informations de version
  if InfoSize > 0 then
  begin
    // Réserve la mémoire
    GetMem(Info, InfoSize);

    try
      // Si les infos peuvent être récupérées
      if GetFileVersionInfo(Pchar(AFichier), Handle, InfoSize, Info) then
        repeat
          // Spécifie le type d'information à récupérer
          InfoType := VersionInfo[i];

          if VerQueryValue(Info, '\VarFileInfo\Translation',
            LangPtr, DataLen) then
            InfoType := Format('\StringFileInfo\%0.4x%0.4x\%s'#0,
              [LoWord(Longint(LangPtr^)), HiWord(Longint(LangPtr^)),
              InfoType]);

            // Remplit la variable de retour
          if VerQueryValue(Info, @InfoType[1], Pointer(InfoData), DataLen) then
            case i of
              1:
                Result.FileDescription    := InfoData;
              2:
                Result.CompanyName        := InfoData;
              3:
                Result.FileVersion        := InfoData;
              4:
                Result.InternalName       := InfoData;
              5:
                Result.LegalCopyright     := InfoData;
              6:
                Result.OriginalFileName   := InfoData;
              7:
                Result.ProductName        := InfoData;
              8:
                Result.ProductVersion     := InfoData;
            end;

          // Incrémente i
          Inc(i);
        until i >= 8;
    finally
      // Libère la mémoire
      FreeMem(Info, InfoSize);
    end;
  end;
end;


function UnzipFile(ASource, ADestination : String) : Boolean;
var
  Zip : I7zInArchive;
begin
  Result := False;
  try
    Zip := CreateInArchive(CLSID_CFormat7z);
    Zip.OpenFile(ASource);
    Zip.ExtractTo(ADestination);
    Result := True;
  Except on E:Exception do
    begin
      raise Exception.Create('UnZipFile -> ' + E.Message);
    end;
  end;
end;

procedure RestartAndRunOnce(AFileToRestart : String);
var
  Reg : TRegistry;
  hToken,
  hProcess  : THandle;
  tp,
  prev_tp   : TTokenPrivileges;
  Len       : DWORD;

begin
  reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce', true);
    reg.WriteString('RESTARTAPP', AFileToRestart);
  finally
    reg.free;
  end;

  hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, GetCurrentProcessID);
  if OpenProcessToken(hProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    CloseHandle(hProcess);
    if LookupPrivilegeValue('', 'SeShutdownPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.PrivilegeCount := 1;
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      if AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp), prev_tp, Len) then
      begin
        CloseHandle(hToken);

        ExitWindowsEx(EWX_FORCE or EWX_REBOOT, 0);
        HALT(1);
      end;
    end;
  end;
end;

procedure TInfoBase.SaveIni;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    WriteString('INFOBASE','NomBase',NomBase);
    WriteString('INFOBASE','CodeTiers',CodeTiers);
    WriteString('INFOBASE','Magasin',Magasin);
    WriteString('INFOBASE','Adresse',Infos.Adresse);
    WriteString('INFOBASE','CodePostal',Infos.CodePostal);
    WriteString('INFOBASE','Ville',Infos.Ville);
    WriteString('INFOBASE','Telephone',Infos.Telephone);
    case GIBINSTALL of
      ibComplet: WriteInteger('ETATINSTALL','IBINSTALL',1);
      ibPatchOnly: WriteInteger('ETATINSTALL','IBINSTALL',0);
    end;
  finally
    Free;
  end;
end;

procedure TInfoBase.LoadIni;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    NomBase          := ReadString('INFOBASE','NomBase','');
    CodeTiers        := ReadString('INFOBASE','CodeTiers','');
    Magasin          := ReadString('INFOBASE','Magasin','');
    Infos.Adresse    := ReadString('INFOBASE','Adresse','');
    Infos.CodePostal := ReadString('INFOBASE','CodePostal','');
    Infos.Ville      := ReadString('INFOBASE','Ville','');
    Infos.Telephone  := ReadString('INFOBASE','Telephone','');

    case ReadInteger('ETATINSTALL','IBINSTALL',1) of
      0: GIBINSTALL := ibPatchOnly;
      1: GIBINSTALL := ibComplet;
    end;
  finally
    Free;
  end;
end;

end.
