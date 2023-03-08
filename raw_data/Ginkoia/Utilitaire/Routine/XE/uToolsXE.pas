unit uToolsXE;

interface

  uses SysUtils, Windows, Forms, Shlobj, TlHelp32, WinSvc, Shellapi, StdCtrls,
       Controls, Consts, Graphics;


  // Permet de vérifier et/ou de le créer
  function DoDir (sDirName : String) : Boolean;

  // Fonction permetant de faire une pause mais ne stoppe pas l'application comme le sleep
  function DoWait(AMillisecondes : Integer) : Boolean;

  // fonctions de cryptage et décryptage de mot de passe (Méthode simple)
  function DoCryptPass(APass : String) : String;
  function DoUnCryptPass(APass : String) : String;

  // Permet de retrouver les répertoire spéciaux de windows
  {$REGION 'Liste des répertoires'}
  {
    uses ShlObj

    CSIDL_APPDATA : Répertoire contenant les données des applications.
    CSIDL_COMMON_FAVORITES : Répertoire contenant les Favoris commun à tous les utilisateurs.
    CSIDL_COMMON_STARTMENU : Répertoire du menu démarrer commun à tous les utilisateurs.
    CSIDL_COMMON_PROGRAMS : Répertoire Programmes du menu démarrer commun à tous les utilisateurs.
    CSIDL_COMMON_STARTUP : Répertoire du groupe Démarrage du menu démarrer commun à tous les utilisateurs.
    CSIDL_COMMON_DESKTOPDIRECTORY : Répertoire correspondant au bureau commun à tous les utilisateurs.
    CSIDL_COOKIES : Répertoire ou sont stockés les cookies d'Internet Explorer.
    CSIDL_DESKTOP : Répertoire correspondant à votre Bureau.
    CSIDL_DESKTOPDIRECTORY : Répertoire correspondant à votre Bureau.
    CSIDL_FAVORITES : Répertoire Favoris.
    CSIDL_FONTS : Répertoire dans lequel sont stockées toutes les polices de caractères.
    CSIDL_HISTORY : Répertoire contenant les historiques d'Internet Explorer.
    CSIDL_INTERNET_CACHE : Répertoire ou sont stockés les fichiers temporaires d'Internet Explorer.
    CSIDL_NETHOOD : Répertoire Voisinage Réseau.
    CSIDL_PERSONAL : Répertoire Mes Documents.
    CSIDL_PRINTHOOD : Répertoire de voisinage d'impression.
    CSIDL_PROGRAMS : Répertoire Programmes du Menu Démarrer.
    CSIDL_RECENT : Répertoire dans lequel se trouvent les raccourcis vers les Fichiers récemment ouverts.
    CSIDL_SENDTO : Répertoire dans lequel se trouvent les raccourcis Envoyer vers
    CSIDL_STARTMENU : Répertoire Menu Démarrer.
    CSIDL_STARTUP : Répertoire du groupe Démarrage du Menu Démarrer.
    CSIDL_TEMPLATES : Répertoire contenant les modèles de documents de Windows.
    CSIDL_PROGRAM_FILES : Répertoire program files
    }
  {$ENDREGION}
  function SpecialFolder(Folder: Integer): String;

  // Exécute un programme exterieur et attend qu'il finisse
  function ExecuteAndWait (sExeName : String;Param : String = '';ACurrentDir : String = '') : Integer;

  // Permet de tuer un processus en mémoire.
  procedure KillProcessus(ExeAKill:string);
  // Permet de vérifier si un processus est en memoire
  function IsProcessInMemory(AProcessName : String) : Boolean;

  // Gestion des services
  function ServiceStart(sMachine, sService : string ) : boolean;
  function ServiceStop(sMachine, sService : string ) : boolean;
  function ServiceStarted(sMachine, sService : string ) : boolean;  

  // Permet de supprimer un répertoire et tous les fichiers
  Function DelDirectory(ADirName : string): Boolean;
  function SetPrivilege(Privilege: PChar; EnablePrivilege: boolean; out PreviousState: boolean): DWORD;


  // Permet de supprimer un fichier
  function DelFile(AFileName : String) : Boolean;

  function InputPassword(const ACaption, APrompt: string;  var Value: string): Boolean;

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

function DoWait(AMillisecondes : Integer) : Boolean;
var
  Start, Encours : Integer;
begin
  Start := GetTickCount;
  Encours := Start;
  while Encours <= Start + AMillisecondes do
  begin
    EnCours := GetTickCount;
    Application.ProcessMessages;
    sleep(10) ;
  end;
end;

function DoCryptPass(APass : String) : String;
var
  i : Integer;
begin
  Result := '';
  for i  := 1 to Length(APass) do
    Result := Result +IntToHex(Ord(APass[i]),2) + IntToHex(Random(255),2);
end;

function DoUnCryptPass(APass : String) : String;
var
  i : Integer;
begin
  Result := '';
  for i  := 1 to (Length(APass) Div 4) do
    Result := Result + Chr(StrToInt('$' + APass[(i - 1)* 4 + 1] + APass[(i -1) * 4 + 2]));
end;

function SpecialFolder(Folder: Integer): String;
var
  SFolder : pItemIDList;
  SpecialPath : Array[0..MAX_PATH] Of Char;
begin
  SHGetSpecialFolderLocation(Application.Handle, Folder, SFolder);
  SHGetPathFromIDList(SFolder, SpecialPath);
  Result := StrPas(SpecialPath);
end;

function ExecuteAndWait (sExeName : String;Param : String = '';ACurrentDir : String = '') : Integer;
Var  StartInfo   : TStartupInfo;
     ProcessInfo : TProcessInformation;
     Fin         : Boolean;
     ExitCode    : Cardinal;
begin
  if Trim(ACurrentDir) = '' then
    ACurrentDir := ExtractFilePath(sExeName);

  Result := -1;
  { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo,SizeOf(StartInfo),#0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb     := SizeOf(StartInfo);
  StartInfo.wShowWindow := SW_HIDE;

  { Lancement de la ligne de commande }
  If CreateProcess(PChar(sExeName),PChar(Param) ,nil , Nil, False,
                0, Nil, PChar(ACurrentDir), StartInfo,ProcessInfo) Then
  Begin
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    Fin:=False;
    Repeat
      { On attend la fin de l'application }
      Case WaitForSingleObject(ProcessInfo.hProcess, 200)Of
        WAIT_OBJECT_0 :Fin:=True; { L'application est terminée, on sort }
        WAIT_TIMEOUT  :;          { elle n'est pas terminée, on continue d'attendre }
      End;
      { Mise à jour de la fenêtre pour que l'application ne paraisse pas bloquée. }
      Application.ProcessMessages;
    Until Fin;

    GetExitCodeProcess(ProcessInfo.hProcess,ExitCode);
    Result := ExitCode;
    { C'est fini }
  End
  Else RaiseLastOSError;
end;


procedure KillProcessus(ExeAKill:string);
var
  ProcessEntry32 : TProcessEntry32;
  HSnapShot : THandle;
  HProcess : THandle;
  bOk:boolean;
  s:string;
begin
  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then
    exit;
  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  bOk:=Process32First(HSnapShot, ProcessEntry32);
  while bOk do begin
    s := String(ProcessEntry32.szExeFile);
    if UpperCase(s)=UpperCase(ExeAKill) then
    begin
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        TerminateProcess(HProcess, 0);
        CloseHandle(HProcess);
      end;
      Break;
    end;
    bOk := Process32Next(HSnapShot, ProcessEntry32);
  end;
  CloseHandle(HSnapshot);
end;

function IsProcessInMemory(AProcessName : String) : Boolean;
var
  ProcessEntry32 : TProcessEntry32;
  HSnapShot : THandle;
  HProcess : THandle;
  bOk:boolean;
  s:string;
begin
  Result := False;
  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then
    exit;
  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  bOk:=Process32First(HSnapShot, ProcessEntry32);
  while bOk and not Result do begin
    s := String(ProcessEntry32.szExeFile);
    if UpperCase(s)=UpperCase(AProcessName) then
    begin
      Result := True;
    end;
    bOk := Process32Next(HSnapShot, ProcessEntry32);
  end;
  CloseHandle(HSnapshot);
end;


function ServiceStart(sMachine, sService : string ) : boolean;
var
  schm, schs  : SC_Handle;
  ss          : TServiceStatus;
  psTemp      : PChar;
  dwChkP      : DWord;
begin
  ss.dwCurrentState := 0;
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if(schm > 0)then
  begin
    schs := OpenService(schm,PChar(sService),SERVICE_START or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      psTemp := Nil;
      if (StartService(schs,0,psTemp)) then
      begin
        if (QueryServiceStatus(schs,ss)) then
        begin
          while (SERVICE_RUNNING <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs,ss)) then
            begin
              break;
            end;
            if (ss.dwCheckPoint < dwChkP) then
            begin
              break;
            end;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := SERVICE_RUNNING = ss.dwCurrentState;
end;

function ServiceStop(sMachine, sService : string ) : boolean;
var
  schm, schs  : SC_Handle;
  ss          : TServiceStatus;
  dwChkP      : DWord;
begin
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if(schm > 0)then
  begin
    schs := OpenService(schm,PChar(sService),SERVICE_STOP or SERVICE_QUERY_STATUS);
    if(schs > 0)then
    begin
      if (ControlService(schs,SERVICE_CONTROL_STOP,ss)) then
      begin
        if (QueryServiceStatus(schs,ss)) then
        begin
          while (SERVICE_STOPPED <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs,ss))then
            begin
              break;
            end;
            if (ss.dwCheckPoint < dwChkP) then
            begin
              break;
            end;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := (SERVICE_STOPPED = ss.dwCurrentState);
end;

function ServiceStarted(sMachine, sService : string ) : boolean;
var
  schm, schs  : SC_Handle;
  ss          : TServiceStatus;
begin
  Result := false ;
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if(schm > 0)then
  begin
    schs := OpenService(schm,PChar(sService),SERVICE_QUERY_STATUS);
    if(schs > 0)then
    begin
      if winSvc.QueryServiceStatus(schs, ss) then
      begin
        Result := (ss.dwCurrentState = SERVICE_RUNNING) ;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
end;

Function DelDirectory(ADirName : string): Boolean;
var
  SHFileOpStruct : TSHFileOpStruct;
  DirBuf : array [0..255] of char;
  boo : boolean;
begin
  SetPrivilege('SeRestorePrivilege',true,boo);
  try
   Fillchar(SHFileOpStruct,Sizeof(SHFileOpStruct),0) ;
   FillChar(DirBuf, Sizeof(DirBuf), 0 ) ;
   StrPCopy(DirBuf, ADirName) ;
   with SHFileOpStruct do begin
    Wnd := 0;
    pFrom := @DirBuf;
    wFunc := FO_DELETE;
    //fFlags := FOF_ALLOWUNDO;   //Evite la poubelle
    fFlags := fFlags or FOF_NOCONFIRMATION;
    fFlags := fFlags or FOF_SILENT;
   end;
    Result := (SHFileOperation(SHFileOpStruct) = 0) ;
   except
    Result := False;
  end;
  SetPrivilege('SeRestorePrivilege',boo,boo);
end;

function SetPrivilege(Privilege: PChar; EnablePrivilege: boolean; out PreviousState: boolean): DWORD;
var
  Token: THandle;
  NewState: TTokenPrivileges;
  Luid: TLargeInteger;
  PrevState: TTokenPrivileges;
  Return: DWORD;
begin
  PreviousState := True;
  if (GetVersion() > $80000000) then
    Result := ERROR_SUCCESS
  else
  begin
    if not OpenProcessToken(GetCurrentProcess(), MAXIMUM_ALLOWED, Token) then
      Result := GetLastError()
    else
    try
      if not LookupPrivilegeValue(nil, Privilege, Luid) then
        Result := GetLastError()
      else
      begin
        NewState.PrivilegeCount := 1;
        NewState.Privileges[0].Luid := Luid;
        if EnablePrivilege then
          NewState.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
        else
          NewState.Privileges[0].Attributes := 0;
        if not AdjustTokenPrivileges(Token, False, NewState,
          SizeOf(TTokenPrivileges), PrevState, Return) then
          Result := GetLastError()
        else
        begin
          Result := ERROR_SUCCESS;
          PreviousState :=
            (PrevState.Privileges[0].Attributes and SE_PRIVILEGE_ENABLED <> 0);
        end;
      end;
    finally
      CloseHandle(Token);
    end;
  end;
end;

function DelFile(AFileName : String) : Boolean;
var
  SHFileOpStruct : TSHFileOpStruct;
  boo : boolean;
begin
  SetPrivilege('SeRestorePrivilege',true,boo);
  Try
    With SHFileOpStruct do
    begin
      wFunc := FO_DELETE;
      {$IFDEF VER180}
      pFrom := PChar(AFileName);
      {$ELSE}
      pFrom := PWideChar(AFileName);
      {$ENDIF}
      fFlags := FOF_NOCONFIRMATION;
    end;
    Try
      Result := (SHFileOperation(SHFileOpStruct) = 0);
    Except on E:Exception do
      Result := False;
    End;
  Finally
    SetPrivilege('SeRestorePrivilege',boo,boo);
  End;

end;

function InputPassword(const ACaption, APrompt: string;
  var Value: string): Boolean;

  function GetAveCharSize(Canvas: TCanvas): TPoint;
  {$IF DEFINED(CLR)}
  var
    I: Integer;
    Buffer: string;
    Size: TSize;
  begin
    SetLength(Buffer, 52);
    for I := 0 to 25 do Buffer[I + 1] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 27] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, Size);
    Result.X := Size.cx div 52;
    Result.Y := Size.cy;
  end;
  {$ELSE}
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;
  {$IFEND}

var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      PopupMode := pmAuto;
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        PasswordChar := '*';
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgOK;
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgCancel;
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

end.
