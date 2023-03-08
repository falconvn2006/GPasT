unit uFileRestart;
{-------------------------------------------------------------------------------
Unité commune aux logiciels : Launcher/Verification
Commentaires : Cette unité permet de dialoguer, via un fichier, entre différents
               programmes.

Variables :
  - ETAPE : Indique l'étape de fonctionnement.
           (Ex : Launcher, ETAPE indique le nombre de fois que le logiciel à
                 redémarrer)

  - RestartSynchro : Si = 1 Indique qu'il faut relancer la synchro

Procédures :
  - Init : Initialise les variables
  - LoadFile : Charge le fichier commun
  - SaveFile : Sauvegarde le fichier commun
  - DelFile : Supprime le fichier commun
-------------------------------------------------------------------------------}
interface

uses IniFiles, Forms, SysUtils;

type
  TFileRestart = record
    ETAPE           : Integer;
    RestartSynchro  : Integer;
    procedure Init;
    procedure LoadFile;
    procedure SaveFile;
    procedure DelFile;

    function getBackupRestore : Boolean ;
    procedure setBackupRestore( aVal : Boolean) ;
  end;

var
  FileRestart : TFileRestart;

implementation

{ TFileRestart }

procedure TFileRestart.DelFile;
begin
  if FileExists(ExtractFilePath(Application.ExeName) + 'CfgRestart.ini') then
    DeleteFile(ExtractFilePath(Application.ExeName) + 'CfgRestart.ini');
end;

function TFileRestart.getBackupRestore: Boolean;
begin
  With TIniFile.Create(ExtractFilePath(Application.ExeName) + 'CfgRestart.ini') do
  try
    Result := ReadBool('RESTART', 'BackRest', false) ;
  finally
    Free;
  end;
end;

procedure TFileRestart.Init;
begin
  ETAPE          := 0 ;
  RestartSynchro := 0 ;
end;

procedure TFileRestart.LoadFile;
begin
  With TIniFile.Create(ExtractFilePath(Application.ExeName) + 'CfgRestart.ini') do
  try
    ETAPE := ReadInteger('RESTART','ETAPE',0);
    RestartSynchro := ReadInteger('RESTART','SYNCHRO',0);
  finally
    Free;
  end;
end;

procedure TFileRestart.SaveFile;
begin
  With TIniFile.Create(ExtractFilePath(Application.ExeName) + 'CfgRestart.ini') do
  try
    WriteInteger('RESTART','ETAPE',ETAPE);
    WriteInteger('RESTART','SYNCHRO',RestartSynchro);
  finally
    Free;
  end;
end;

procedure TFileRestart.setBackupRestore(aVal: Boolean);
begin
  With TIniFile.Create(ExtractFilePath(Application.ExeName) + 'CfgRestart.ini') do
  try
    WriteBool('RESTART', 'BackRest', aVal) ;
  finally
    Free;
  end;
end;

end.
