unit ExeCommunication;

interface


{$IF CompilerVersion < 30.0}
  {$DEFINE DELPHI_OLD}
{$IFEND}

uses
  {$IfDef DELPHI_OLD}
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;
  {$ELSE}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;
  {$ENDIF}

CONST
  DefaultCryptKey = 'Wut?CantRead';
  WM_CUSTOM_MSG = WM_USER + 44;

type
  PCopyDataStruct = ^TCopyDataStruct;
  TCopyDataStruct = record
    dwData: LongInt;
    cbData: LongInt;
    lpData: Pointer;
  end;

  PComRec = ^TComRec;

  TComRec = packed record
    valStr: string[255];
    valInt: Int64;
    HandleCaller: dword;
  end;

  TExeCommunication = class
  private
    FExeToLink: string;
    FWindowClassToFind: string;
    FHandleExternalExe: HWND;
    FComRec: TComRec;
    FCallerHandle: HWND;
    FDefaultRec: TComRec;
    FLaunchParams: string;
    FMustBringToFront: boolean;

    procedure LaunchExe;
    procedure CheckLinkExes;
    function DoSendMessage: Integer;
    class function GetExeCommunicationPath: string; static;
  public
    property ExeToLink: string read FExeToLink write FExeToLink;
    property WindowClassToFind: string read FWindowClassToFind write FWindowClassToFind;
    property CallerHandle: HWND read FCallerHandle write FCallerHandle;
    property ComRec: TComRec read FComRec write FComRec;
    property DefaultRec: TComRec read FDefaultRec write FDefaultRec;
    property HandleExternalExe: HWND read FHandleExternalExe write FHandleExternalExe;
    property LaunchParams: string read FLaunchParams write FLaunchParams;
    property MustBringToFront: boolean read FMustBringToFront write FMustBringToFront;
    class property ExeCommunicationPath: string read GetExeCommunicationPath;

    constructor Create(aExeToLink: String; aWindowClassToFind: String; aCallerHandle: HWND;
      aDefaultInt: Integer = 0; aDefaultStr: string = ''; aMustBringToFront: Boolean = true);

    procedure PostToExe(aValStr: string; aValInt: int64; bCheckLink: boolean = true);
    procedure PostToExeAsync(aValStr: string; aValInt: int64; bCheckLink: boolean = true);
    procedure PostToCaller(aValStr: string; aValInt: int64);
    procedure PostToCallerAsync(aValStr: string; aValInt: int64);
    class procedure FillRecord(var aRecord: TComRec; aMsg: TMessage);
    class function Encrypt(aStr : string; aKey : string = DefaultCryptKey) : string;
    class function Decrypt(aStr : string; aKey : string = DefaultCryptKey) : string;
  end;

  TPostToExeThread = class(TThread)
  private
    FVarStr : string;
    FVarInt : integer;
    FExeCom : TExeCommunication;
    FCheckLink : boolean;
  protected
    procedure Execute; override;
  public
    property VarStr : string read FVarStr write FVarStr;
    property VarInt : integer read FVarInt write FVarInt;
    property ExeCom : TExeCommunication read FExeCom write FExeCom;
    property CheckLink : boolean read FCheckLink write FCheckLink;

    constructor Create(aExeCom : TExeCommunication; aValStr : string; aValInt : integer; aCheckLink : boolean); overload;
  end;

function ProcessExists(sExename: string): boolean;

implementation

uses
  TlHelp32;

var
  MyDataID: UINT = 0;

constructor TExeCommunication.Create(aExeToLink, aWindowClassToFind: String; aCallerHandle: HWND;
  aDefaultInt: Integer = 0; aDefaultStr: string = ''; aMustBringToFront: Boolean = true);
begin
  inherited create;

  FLaunchParams := '';

  FExeToLink := aExeToLink;
  FWindowClassToFind := aWindowClassToFind;
  FCallerHandle := aCallerHandle;

  // sert pour un appel par défaut si on veut faire un post lors du premier lancement de l'exe externe
  FDefaultRec.HandleCaller := aCallerHandle;
  if aDefaultInt <> 0 then
    FDefaultRec.valInt := aDefaultInt;
  if aDefaultStr <> '' then
      FDefaultRec.valStr := aDefaultStr;

  FMustBringToFront := aMustBringToFront;
end;

function ProcessExists(sExename: string): boolean;
var
  ContinueLoop: Boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(sExename)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(sExename))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TExeCommunication.PostToCaller(aValStr: string; aValInt: int64);
begin
  PostToExe(aValStr, aValInt, False);
end;

procedure TExeCommunication.PostToCallerAsync(aValStr: string; aValInt: int64);
begin
  PostToExeAsync(aValStr, aValInt, false);
end;

procedure TExeCommunication.PostToExe(aValStr: string; aValInt: int64; bCheckLink: boolean = true);
var
  error: Integer;
  i: Integer;
begin
  // si on a pas l'exe de lancée on la lance et on récupère son handle
  if bCheckLink then
    CheckLinkExes;

  if FHandleExternalExe <> 0 then
  begin
    FComRec.HandleCaller := FCallerHandle;
    FComRec.valInt := aValInt;
    FComRec.valStr := aValStr;

    // avant le send message car sinon le programme est en "attente"
    if FMustBringToFront then
    begin
      BringWindowToTop(FHandleExternalExe);
      SetForegroundWindow(FHandleExternalExe);
    end;

    Error := DoSendMessage;

    if Error <> ERROR_SUCCESS then
      Raise Exception.Create(SysErrorMessage(Error));
  end
  else
    ShowMessage('impossible de trouver la fenêtre de l''executable communiquant');
end;

procedure TExeCommunication.PostToExeAsync(aValStr: string; aValInt: int64;
  bCheckLink: boolean);
var
  vPostToExeThread : TPostToExeThread;
begin
  vPostToExeThread := TPostToExeThread.Create(Self, aValStr, aValInt, bCheckLink);
end;

procedure TExeCommunication.CheckLinkExes;
var
  allReadyLaunched: Boolean;
  Error: Integer;
  i: Integer;
begin
  i := 0;
  FHandleExternalExe := 0;

  allReadyLaunched := True;
  // si on a pas l'exe de lancée on le lance
  if not ProcessExists(FExeToLink) then
  begin
    LaunchExe;
    allReadyLaunched := false;
  end;

  // on récupère le handle de la fenêtre en paramètre
  while (FHandleExternalExe = 0) and (i < 10) do
  begin
    {$IfDef DELPHI_OLD}
    FHandleExternalExe := FindWindow(PChar(FWindowClassToFind), nil); // il faut chercher le Handle
    {$ELSE}
    FHandleExternalExe := FindWindow(PWideChar(FWindowClassToFind), nil); // il faut chercher le Handle
    {$ENDIF}
    i := i + 1;
    Sleep(500);
    Application.ProcessMessages;
  end;

  if not allReadyLaunched then
  begin
    // si on a des valeurs par défaut on les appeles
    if (FHandleExternalExe <> 0)  then
    begin
      if (FDefaultRec.valInt <> 0) and (FDefaultRec.valStr <> '') then
      begin
        FComRec.HandleCaller := FCallerHandle;
        FComRec.valInt := FDefaultRec.valInt;
        FComRec.valStr := FDefaultRec.valStr;

        Error := DoSendMessage;

        if Error <> ERROR_SUCCESS then
          raise Exception.Create(SysErrorMessage(Error));
      end;
    end
    else
      ShowMessage('impossible de trouver la fenêtre de l''exe lancé');
  end;
end;

class function TExeCommunication.Decrypt(aStr : string; aKey : string): string;
var
  i, j : Integer;
  PassPhrase : string;
begin
  Result := '';
  PassPhrase := aKey;

  i := 1;
  j := 1;
  repeat
    Result := Result + Chr(StrToInt('$' + Copy(aStr, i, 2)) xor Ord(PassPhrase[j]));
    Inc(i, 2);
    Inc(j);
    if j > Length(PassPhrase) then
      j := 1;
  until i > Length(aStr);
end;

function TExeCommunication.DoSendMessage: Integer;
var
  CopyDataStruct: TCopyDataStruct;
begin
  if MyDataID = 0 then
  begin
    ShowMessage('La communication entre les exécutables n''a pas pu être enregistrée');
    exit;
  end;

  CopyDataStruct.dwData := MyDataID;
  CopyDataStruct.cbData := sizeof(FComRec);
  CopyDataStruct.lpData := @FComRec;

  Result := SendMessage(FHandleExternalExe, WM_COPYDATA, FComRec.HandleCaller, LongInt(@CopyDataStruct));
end;

class function TExeCommunication.Encrypt(aStr : string; aKey : string): string;
var
  i, j : Integer;
  PassPhrase : string;
begin
  Result := '';
  PassPhrase := aKey;

  j := 1;
  for i := 1 to Length(aStr) do
  begin
    Result := Result + IntToHex(Ord(aStr[i]) xor Ord(PassPhrase[j]), 2);
    Inc(j);
    if j > Length(PassPhrase) then
      j := 1;
  end;
end;

class procedure TExeCommunication.FillRecord(var aRecord: TComRec; aMsg: TMessage);
var
  p: PCopyDataStruct;
begin
  p := PCopyDataStruct(aMsg.lParam);

  if (p <> nil) and (MyDataID <> 0) and (p^.dwData = MyDataID) then
  begin
    with PComRec(PCopyDataStruct(aMsg.LParam)^.lpData)^ do
    begin
      aRecord.valStr := valStr;
      aRecord.valInt := valInt;
      aRecord.HandleCaller := HandleCaller;
    end
  end;
end;

class function TExeCommunication.GetExeCommunicationPath: string;
begin
  Result := 'AppMod\';
end;

procedure TExeCommunication.LaunchExe;
var
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Fin: Boolean;
  ExitCode: Cardinal;
  nbWait: Integer;
begin
  nbWait := 0;
  if not FileExists(IncludeTrailingBackslash(ExtractFileDir(Application.ExeName)) + ExeCommunicationPath + FExeToLink) then
    raise Exception.Create('Impossible de trouver l''executable');

  { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb := SizeOf(StartInfo);
  StartInfo.wShowWindow := SW_HIDE;

  { Lancement de la ligne de commande }
  if CreateProcess(PChar(ExeCommunicationPath + FExeToLink), PChar(ExeCommunicationPath + FExeToLink + FLaunchParams), nil, Nil, False, 0, Nil, PChar(ExeCommunicationPath), StartInfo, ProcessInfo) then
  begin
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    Fin := False;

    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
  end
  else
    RaiseLastOSError;

  while (not ProcessExists(FExeToLink)) and (nbWait < 10) do
  begin
    Sleep(500);
    Application.ProcessMessages;
    Inc(nbWait);
  end;

  // on attend que l'exe soit bien lancé pour être prêt à recevoir les messages
  Sleep(2000);
end;

{ TPostToExeThread }

constructor TPostToExeThread.Create(aExeCom : TExeCommunication; aValStr: string; aValInt: integer; aCheckLink : boolean);
begin
  inherited Create(False);
  FreeOnTerminate := true;
  FExeCom := aExeCom;
  FVarStr := aValStr;
  FVarInt := aValInt;
  FCheckLink := aCheckLink;
end;

procedure TPostToExeThread.Execute;
begin
  try
    FExeCom.PostToExe(FVarStr, FVarInt, FCheckLink);
  finally
    Terminate;
  end;
end;

initialization
  MyDataID := RegisterWindowMessage('MyDataID');

end.


