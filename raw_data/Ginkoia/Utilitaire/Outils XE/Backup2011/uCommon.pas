unit uCommon;

interface

uses SysUtils, WinSock, Inifiles, Forms;

type
  TModeChx = (mdAdd,mdEdit);
  TModeAct = (maCopy, maZip, maDel, maEnd);

  TRecCfg = Record
    NbThread : Integer;
    GinkoiaMode : Boolean; // True : Permet d'ignorer les répertoires ayant DelosQPMAgent.dll présent
  public
    Procedure LoadConfig;
    procedure SaveConfig;
  End;
var
  GAPPPATH : String;
  GAPPCFGPATH : String;
  GLOGSPATH : String;
  GLOGSNAME : String;
  FCanChangePage : Boolean;
  bInProgress : Boolean;
  GActionMode : TModeAct;
  MainCfg : TRecCfg;
  function DoDir (sDirName : String) : Boolean;

implementation

function DoDir(sDirName : String) : Boolean;
begin
  Result := False;
  Try
    if not DirectoryExists(sDirName) then
      ForceDirectories(sDirName);
    Result := True;
  Except on E:Exception do
    raise Exception.Create('DoDir -> ' + E.Message);
  End;
end;


{ TRecCfg }

procedure TRecCfg.LoadConfig;
begin
  With TIniFile.Create(GAPPCFGPATH + ChangeFileExt(ExtractFileName(Application.ExeName),'.ini')) do
  try
    NbThread := ReadInteger('CFG','THREAD',4);
    GinkoiaMode := ReadBool('CFG','GKMODE',False);
  finally
    Free;
  end;
end;

procedure TRecCfg.SaveConfig;
begin
  With TIniFile.Create(GAPPCFGPATH + ChangeFileExt(ExtractFileName(Application.ExeName),'.ini')) do
  try
    WriteInteger('CFG','THREAD',NbThread);
    WriteBool('CFG','GKMODE',GinkoiaMode);
  finally
    Free;
  end;
end;

end.
