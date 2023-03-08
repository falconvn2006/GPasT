unit uChatGPT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComObj, 
  YxdJson, YxdStr, IniFiles,
  AxCtrls,
  ActiveX,
  Mask,
  WinInet,
  clipbrd,
  StrUtils, ShellApi,
  StdCtrls, ComCtrls, ExtCtrls,
  Dialogs, ImgList, CoolTrayIcon, Menus, ActnList, sSkinManager, Buttons;

const
  SkinName = 'Office12Style (internal)';

const
  MicrosoftTranslatorTranslateUri = 'http://api.microsofttranslator.com/v2/Http.svc/Translate?appId=%s&text=%s&from=%s&to=%s';
  MicrosoftTranslatorDetectUri    = 'http://api.microsofttranslator.com/v2/Http.svc/Detect?appId=%s&text=%s';
  MicrosoftTranslatorGetLngUri    = 'http://api.microsofttranslator.com/v2/Http.svc/GetLanguagesForTranslate?appId=%s';
  MicrosoftTranslatorGetSpkUri    = 'http://api.microsofttranslator.com/v2/Http.svc/GetLanguagesForSpeak?appId=%s';
  MicrosoftTranslatorSpeakUri     = 'http://api.microsofttranslator.com/v2/Http.svc/Speak?appId=%s&text=%s&language=%s';
  //Google
  GoogleUrl                       = 'https://www.googleapis.com/language/translate/v2?key=%s&source=%s&target=%s&q=%s';
  GoogleTranslateUrl              = 'https://www.googleapis.com/language/translate/v2?key=%s&q=%s&source=%s&target=%s';
  GoogleTranslateUrlAuto          = 'https://www.googleapis.com/language/translate/v2?key=%s&target=%s&q=%s';
  //this AppId if for demo only please be nice and use your own , it's easy get one from here http://msdn.microsoft.com/en-us/library/ff512386.aspx
  BingAppId                       = '73C8F474CA4D1202AD60747126813B731199ECEA';
  Msxml2_DOMDocument              = 'Msxml2.DOMDocument.6.0';
  CreateImage = '{"prompt": "#",  "n": 2,  "size": "@"}';
  SetFileName = 'ResponseJsonImage';

type
  TGoogleLanguages = (Autodetect,Afrikaans,Albanian,Arabic,Basque,Belarusian,Bulgarian,Catalan,Chinese,Chinese_Traditional,
  Croatian,Czech,Danish,Dutch,English,Estonian,Filipino,Finnish,French,Galician,German,Greek,
  Haitian_Creole,Hebrew,Hindi,Hungarian,Icelandic,Indonesian,Irish,Italian,Japanese,Latvian,
  Lithuanian,Macedonian,Malay,Maltese,Norwegian,Persian,Polish,Portuguese,Romanian,Russian,
  Serbian,Slovak,Slovenian,Spanish,Swahili,Swedish,Thai,Turkish,Ukrainian,Vietnamese,Welsh,Yiddish);
 
const
  GoogleLanguagesArr : array[TGoogleLanguages] of string =
  ( 'Autodetect','af','sq','ar','eu','be','bg','ca','zh-CN','zh-TW','hr','cs','da','nl','en','et','tl','fi','fr','gl',
    'de','el','ht','iw','hi','hu','is','id','ga','it','ja','lv','lt','mk','ms','mt','no','fa','pl','pt',
    'ro','ru','sr','sk','sl','es','sw','sv','th','tr','uk','vi','cy','yi');

type
  TWWWParams = record
    RequestURL: string;
    Bearer: string;
    Token: string;
    ObjId: string;
    clients: string;
    phone: string;
    externalid: string;
    countryISO3166: string;
    phoneNumber: string;
    ObjName: string;
    DocName: string;
    Method: string;
    dt:String;
  end;

type
  TProgressProc = procedure (aProgress: Integer) of object; // 0 to 100
  TProgressThread = class(TThread)
                  private
                    FProgressProc: TProgressProc;
                    FProgressValue: integer;
                  procedure SynchedProgress;
                  protected
                  procedure Progress(aProgress: integer); virtual;
                  public
                  constructor Create(aProgressProc: TProgressProc; CreateSuspended: Boolean = False); reintroduce; virtual;
 end;
 TMyThread = class(TProgressThread)
                  protected
                  procedure Execute; override;
 end;

type
  TAnimationThread = class(TThread)
  private
    { Private declarations }
    FWnd: HWND;
    FPaintRect: TRect;
    FbkColor, FfgColor: TColor;
    FInterval: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(paintsurface : TWinControl; {Control to paint on }
      paintrect : TRect;          {area for animation bar }
      bkColor, barcolor : TColor; {colors to use }
      interval : integer);       {wait in msecs between paints}
  end;

type
  TmyChatGPT = class(TForm)
    grp1: TGroupBox;
    Memo1: TMemo;
    grp2: TGroupBox;
    grpTrans: TGroupBox;
    spl1: TSplitter;
    Memo2: TMemo;
    mmo1: TMemo;
    spl2: TSplitter;
    pnl1: TPanel;
    g_query: TGroupBox;
    btn1: TButton;
    chksave: TCheckBox;
    grpClean: TGroupBox;
    lst2: TListBox;
    spl3: TSplitter;
    pnl2: TPanel;
    edt1: TEdit;
    stat1: TStatusBar;
    btnToken: TButton;
    TrayIcon1: TCoolTrayIcon;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    ShowWindow1: TMenuItem;
    HideWindow1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    btnCreateImage: TButton;
    ActionList: TActionList;
    aYourToken: TAction;
    aCreateCompletion: TAction;
    aCreateImage: TAction;
    SaveDialog1: TSaveDialog;
    btnListmodels: TButton;
    aListModels: TAction;
    lSize: TLabel;
    cbbSize: TComboBox;
    btnListfinetunes: TButton;
    aListFineTunes: TAction;
    lPrompts: TLabel;
    cPrompts: TComboBox;
    sSkinManager1: TsSkinManager;
    btnTranc: TSpeedButton;
    ProgressBar1: TProgressBar;
    chkVoice: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure chksaveClick(Sender: TObject);
    procedure lst2Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowWindow1Click(Sender: TObject);
    procedure HideWindow1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure TrayIcon1BalloonHintClick(Sender: TObject);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrayIcon1Click(Sender: TObject);
    procedure aYourTokenExecute(Sender: TObject);
    procedure aCreateCompletionExecute(Sender: TObject);
    procedure aCreateImageExecute(Sender: TObject);
    procedure aListModelsExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure aListFineTunesExecute(Sender: TObject);
    procedure cPromptsChange(Sender: TObject);
    procedure btnTrancClick(Sender: TObject);
  private
    { Private declarations }
    sSkinForm: integer;
    ResStream: TResourceStream;
    fMyThread: TMyThread;
    procedure UpdateProgressBar(aProgress: Integer);
    procedure GetRegStatus(id: Integer);
    function GetTranslate(Metod: string; RequestURL: string): string;
    function PostParam(Metod: string; RequestURL: string; Params: string; Bearer: string): string;
    function PostTranslate(Metod: string; RequestURL: string; Params: string): string;
    { Setting ini file }
    procedure WriteIniFile(uFile: string; Section_Name: string; Key_Name: string; StrValue: string);
    function ReadIniFile(uFile: string; Section_Name: string; Key_Name: string) : string;
    procedure ReadAllSecIniFile(uFile: string);
    procedure EraseSecIniFile(uFile: string; Section_Name: string);
    procedure ReadValueSecIniFile(uFile: string; Section_Name: string);
    procedure ReadSecIniFile(uFile: string; Section_Name: string);
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
  public
    { Public declarations }
    uText     : string;
    ApiKey,GoogleLanguageApiKey : string;
    lng       : TStringList;
    uStr,uStr1,
    uStr2     : TStringList;
    FileName  : string;
    temper : Integer;
    uToken : string;
  end;

  THTTPRequest = class(TThread)
    js: string;
    Json : JSONBase;
    str  : JSONString;
    ABuilder: TStringCatHelper;
  private
    FParams: TWWWParams;
    FResponseText: string;
    FMessage: string;
    FFileName: string;
    sSkinForm: integer;
    procedure Execute; override;
    procedure SynchronizeResult;
    procedure SetFileName;
    procedure GetImage;
  public
    constructor Create(AParams: TWWWParams);
    destructor Destroy; override;
  end;

var
  myChatGPT: TmyChatGPT;
  FParams: TWWWParams;
  wy,wm,wd: Word;
  myDir: string;

implementation

{$R *.dfm}
{$R Office12Style.RES}

uses uSetting;

procedure TmyChatGPT.WMQueryEndSession(var Message: TMessage);
begin
  Message.Result := 1;
  Application.Terminate;
end;

procedure RamClean;
var MainHandle: THandle;
begin
try
if Win32Platform = VER_PLATFORM_WIN32_NT then
begin
   MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID);
   SetProcessWorkingSetSize(MainHandle, DWORD(-1), DWORD(-1));
   CloseHandle(MainHandle);
end;
except
  Exit;
end;
end;

constructor THTTPRequest.Create(AParams: TWWWParams);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FParams := AParams;
end;

destructor THTTPRequest.Destroy;
begin
  inherited;
end;

procedure THTTPRequest.SynchronizeResult;
begin
  if FMessage <> '' then MessageBox(Handle,PChar(FMessage),PChar('Attention'),64);
end;

//Get of status
procedure TmyChatGPT.GetRegStatus(id: Integer);
var Result: string;
begin
try
    if id = 401 then
    begin
       Result := 'You are using a revoked API key.'+#13#10+
                 'You are using a different API key than the one assigned to the requesting organization.'+#13#10+
                 'You are using an API key belonging to another organization.'+#13#10+
                 'There is a typo or an extra space in the API key.'+#13#10+
                 'You are using an API key that has been removed or deactivated.'+#13#10+
                 'Old, revoked API key can be cached locally.'+#13#10+
                 'You have left or been removed from your previous organization.'+#13#10+
                 'Your organization has been deleted.'+#13#10+
                 'You are using an API key that does not have the necessary permissions for the called endpoint.';
       MessageBox(Handle,PChar(Result), PChar('Attention'), 64);
       ShellExecute(Handle, 'open', 'https://platform.openai.com/account/api-keys', nil, nil, SW_SHOW);
       ShellExecute(Handle, 'open', 'https://console.cloud.google.com/apis/credentials', nil, nil, SW_SHOW);
       Memo2.Clear;
    end;
    if id = 429 then
    begin
       Result := 'You are using a loop or a script that makes frequent or concurrent requests.'+#13#10+
                 'You are sharing your API key with other users or applications.'+#13#10+
                 'You are using a high-volume or complex service that consumes a lot of credits or tokens.'+#13#10+
                 'Your limit is set too low for your organization’s usage.'+#13#10+
                 'There is a sudden spike or surge in demand for our services.'+#13#10+
                 'There is scheduled or unscheduled maintenance or update on our servers.'+#13#10+
                 'There is an unexpected or unavoidable outage or incident on our servers.'+#13#10+
                 'You are using a free plan that has a low rate limit.';
       MessageBox(Handle,PChar(Result), PChar('Attention'), 64);
       ShellExecute(Handle, 'open', 'https://platform.openai.com/account/api-keys', nil, nil, SW_SHOW);
       ShellExecute(Handle, 'open', 'https://console.cloud.google.com/apis/credentials', nil, nil, SW_SHOW);
       Memo2.Clear;
    end;
except
  Exit;
end;
end;

constructor TAnimationThread.Create(paintsurface : TWinControl;
  paintrect : TRect; bkColor, barcolor : TColor; interval : integer);
begin
  inherited Create(True);
  FWnd := paintsurface.Handle;
  FPaintRect := paintrect;
  FbkColor := bkColor;
  FfgColor := barColor;
  FInterval := interval;
  FreeOnterminate := True;
  Resume;
end; { TAnimationThread.Create }

procedure TAnimationThread.Execute;
var
  image : TBitmap;
  DC : HDC;
  left, right : integer;
  increment : integer;
  imagerect : TRect;
  state : (incRight, incLeft, decLeft, decRight);
begin
  Image := TBitmap.Create;
  try
    with Image do 
    begin
      Width := FPaintRect.Right - FPaintRect.Left;
      Height := FPaintRect.Bottom - FPaintRect.Top;
      imagerect := Rect(0, 0, Width, Height);
    end; { with }
    left := 0;
    right := 0;
    increment := imagerect.right div 50;
    state := Low(State);
    while not Terminated do 
    begin
      with Image.Canvas do 
      begin
        Brush.Color := FbkColor;
        FillRect(imagerect);
        case state of
          incRight: 
          begin
            Inc(right, increment);
            if right > imagerect.right then 
            begin
              right := imagerect.right;
              Inc(state);
            end; { if }
          end; { Case incRight }
          incLeft: 
          begin
            Inc(left, increment);
            if left >= right then 
            begin
              left := right;
              Inc(state);
            end; { if }
          end; { Case incLeft }
          decLeft: 
          begin
            Dec(left, increment);
            if left <= 0 then 
            begin
              left := 0;
              Inc(state);
            end; { if }
          end; { Case decLeft }
          decRight: 
          begin
            Dec(right, increment);
            if right <= 0 then 
            begin
              right := 0;
              state := incRight;
            end; { if }
          end; { Case decLeft }
        end; { Case }
        Brush.Color := FfgColor;
        FillRect(Rect(left, imagerect.top, right, imagerect.bottom));
      end; { with }
      DC := GetDC(FWnd);
      if DC <> 0 then
        try
          BitBlt(DC,
            FPaintRect.Left,
            FPaintRect.Top,
            imagerect.right,
            imagerect.bottom,
            Image.Canvas.handle,
            0, 0,
            SRCCOPY);
        finally
          ReleaseDC(FWnd, DC);
        end;
      Sleep(FInterval);
    end; { While }
  finally
    Image.Free;
  end;
  InvalidateRect(FWnd, nil, True);
end; { TAnimationThread.Execute }

constructor TProgressThread.Create(aProgressProc: TProgressProc; CreateSuspended: Boolean = False);
begin
  inherited Create(CreateSuspended);
            FreeOnTerminate := True;
            FProgressProc := aProgressProc;
end;

procedure TProgressThread.Progress(aProgress: Integer);
begin
  FProgressValue := aProgress;
  Synchronize(SynchedProgress);
end;

procedure TProgressThread.SynchedProgress;
begin
if Assigned(FProgressProc) then FProgressProc(FProgressValue);
end;

{ TMyThread }
procedure TMyThread.Execute;
var I: Integer;
begin
try
    Progress(0);
    for I := 1 to 100 do begin
        Sleep(1000);
        Progress(I);
    end;
except
  Exit;
end;
end;


procedure WinInet_HttpGet(const Url: string;Stream:TStream);overload;
const BuffSize = 1024*1024;
var
  hInter   : HINTERNET;
  UrlHandle: HINTERNET;
  BytesRead: DWORD;
  Buffer   : Pointer;
begin
  hInter := InternetOpen('', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hInter) then
    try
      Stream.Seek(0,0);
      GetMem(Buffer,BuffSize);
      try
          UrlHandle := InternetOpenUrl(hInter, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);
          if Assigned(UrlHandle) then
          begin
            repeat
              InternetReadFile(UrlHandle, Buffer, BuffSize, BytesRead);
              if BytesRead>0 then
               Stream.WriteBuffer(Buffer^,BytesRead);
            until BytesRead = 0;
            InternetCloseHandle(UrlHandle);
          end;
      finally
        FreeMem(Buffer);
      end;
    finally
     InternetCloseHandle(hInter);
    end;
end;

function WinInet_HttpGet(const Url: string): string;overload;
Var
  StringStream : TStringStream;
begin
  Result:='';
    StringStream:=TStringStream.Create('');
    try
        WinInet_HttpGet(Url,StringStream);
        if StringStream.Size>0 then
        begin
          StringStream.Seek(0,0);
          Result:=StringStream.ReadString(StringStream.Size);
        end;
    finally
      StringStream.Free;
    end;
end;

function TranslateText(const AText,SourceLng,DestLng:string):string;
var
   XmlDoc : OleVariant;
   Node   : OleVariant;
begin
  Result:=WinInet_HttpGet(Format(MicrosoftTranslatorTranslateUri,[BingAppId,AText,SourceLng,DestLng]));
  XmlDoc:= CreateOleObject(Msxml2_DOMDocument);
  try
    XmlDoc.Async := False;
    XmlDoc.LoadXML(Result);
    if (XmlDoc.parseError.errorCode <> 0) then
     raise Exception.CreateFmt('Error in Xml Data %s',[XmlDoc.parseError]);
    Node:= XmlDoc.documentElement;
    if not VarIsClear(Node) then
     Result:=Utf8ToAnsi(XmlDoc.Text);
  finally
     XmlDoc:=Unassigned;
  end;
end;

function DetectLanguage(const AText:string ):string;
var
   XmlDoc : OleVariant;
   Node   : OleVariant;
begin
  Result:=WinInet_HttpGet(Format(MicrosoftTranslatorDetectUri,[BingAppId,AText]));
  XmlDoc:= CreateOleObject(Msxml2_DOMDocument);
  try
    XmlDoc.Async := False;
    XmlDoc.LoadXML(Result);
    if (XmlDoc.parseError.errorCode <> 0) then
     raise Exception.CreateFmt('Error in Xml Data %s',[XmlDoc.parseError]);
    Node:= XmlDoc.documentElement;
    if not VarIsClear(Node) then
      Result:=XmlDoc.Text;
  finally
     XmlDoc:=Unassigned;
  end;
end;

function GetLanguagesForTranslate: TStringList;
var
   XmlDoc : OleVariant;
   Node   : OleVariant;
   Nodes  : OleVariant;
   lNodes : Integer;
   i      : Integer;
   sValue : string;
begin
  Result:=TStringList.Create;
  sValue:=WinInet_HttpGet(Format(MicrosoftTranslatorGetLngUri,[BingAppId]));
  XmlDoc:= CreateOleObject(Msxml2_DOMDocument);
  try
    XmlDoc.Async := False;
    XmlDoc.LoadXML(sValue);
    if (XmlDoc.parseError.errorCode <> 0) then
     raise Exception.CreateFmt('Error in Xml Data %s',[XmlDoc.parseError]);
    Node:= XmlDoc.documentElement;
    if not VarIsClear(Node) then
    begin
      Nodes := Node.childNodes;
       if not VarIsClear(Nodes) then
       begin
         lNodes:= Nodes.Length;
           for i:=0 to lNodes-1 do
            Result.Add(Nodes.Item(i).Text);
       end;
    end;
  finally
     XmlDoc:=Unassigned;
  end;
end;

function GetLanguagesForSpeak: TStringList;
var
   XmlDoc : OleVariant;
   Node   : OleVariant;
   Nodes  : OleVariant;
   lNodes : Integer;
   i      : Integer;
   sValue : string;
begin
  Result:=TStringList.Create;
  sValue:=WinInet_HttpGet(Format(MicrosoftTranslatorGetSpkUri,[BingAppId]));
  XmlDoc:= CreateOleObject(Msxml2_DOMDocument);
  try
    XmlDoc.Async := False;
    XmlDoc.LoadXML(sValue);
    if (XmlDoc.parseError.errorCode <> 0) then
     raise Exception.CreateFmt('Error in Xml Data %s',[XmlDoc.parseError]);
    Node:= XmlDoc.documentElement;
    if not VarIsClear(Node) then
    begin
      Nodes := Node.childNodes;
       if not VarIsClear(Nodes) then
       begin
         lNodes:= Nodes.Length;
           for i:=0 to lNodes-1 do
            Result.Add(Nodes.Item(i).Text);
       end;
    end;
  finally
     XmlDoc:=Unassigned;
  end;
end;

procedure Speak(const FileName,AText,Lng:string);
var
  Stream : TFileStream;
begin
  Stream:=TFileStream.Create(FileName,fmCreate);
  try
    WinInet_HttpGet(Format(MicrosoftTranslatorSpeakUri,[BingAppId,AText,Lng]),Stream);
  finally
    Stream.Free;
  end;
end;

{ TForm1 }
procedure TmyChatGPT.UpdateProgressBar(aProgress: Integer);
var str0: string; voice: OleVariant; ani: TAnimationThread;
    r: TRect;
begin
try
  //   ProgressBar1.Position := aProgress;
  //   ProgressBar1.Update; // Make sure to repaint the progressbar
  //if aProgress >= 100 then
  if Length(uText) > 0 then begin
     fMyThread := nil;
     r := ProgressBar1.ClientRect;
     InflateRect(r, - ProgressBar1.BorderWidth, - ProgressBar1.BorderWidth);
     ani := TanimationThread.Create(ProgressBar1, r, ProgressBar1.Brush.Color, clGreen, 25);
     Application.ProcessMessages;
     CoInitialize(nil);
  try
     voice := CreateOleObject('SAPI.SpVoice');
     str0 := TranslateText(Trim(uText),'en','ru'); //'TranslateApiExceptionMethod: Translate()Message: AppId is over the quotamessage id=V2_Rest_Translate.BNZE.1C19.0304T1827.9F76D4'
     if Pos('TranslateApiExceptionMethod',str0) = 0 then begin
        Memo2.Lines.Add(str0);
        lst2.Items.Add(Trim(str0));
     end;
     str0 := Trim(DetectLanguage(uText));
     lng:=GetLanguagesForTranslate;
     lng:=GetLanguagesForSpeak; {}
     if chkVoice.Checked then voice.speak(Trim(uText));
     uText := '';
  finally
     CoUninitialize;
     ani.Terminate;
     Application.ProcessMessages;
  end;
  end else begin
     if Win32Platform = VER_PLATFORM_WIN32_NT then SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF); RamClean;
  end;
except
  Exit;
end;
end;

// Write values to a INI file
procedure TmyChatGPT.WriteIniFile(uFile: string; Section_Name: string; Key_Name: string; StrValue: string); //'c:\MyIni.ini'
 var
   ini: TIniFile;
begin
try
   // Create INI Object and open or create file test.ini
    ini := TIniFile.Create(uFile);
   try
     // Write a string value to the INI file.
    ini.WriteString(Section_Name, Key_Name, StrValue);
   finally
     ini.Free;
   end;
except
  Exit;
end;
end;


 // Read values from an INI file
function TmyChatGPT.ReadIniFile(uFile: string; Section_Name: string; Key_Name: string) : string;
 var
   ini: TIniFile;
   res: string;
begin
try
     Result := '';
     // Create INI Object and open or create file test.ini
     ini := TIniFile.Create(uFile);
   try
     res := ini.ReadString(Section_Name, Key_Name, ''); //MessageDlg('Value of Section:  ' + res, mtInformation, [mbOK], 0);
     Result := res;
   finally
     ini.Free;
   end;
except
  Exit;
end;
end;

 // Read all sections
procedure TmyChatGPT.ReadAllSecIniFile(uFile: string);
 var
    ini: TIniFile;
    uList: TStringList;
begin
try
  try
     uList := TStringList.Create;
     ini := TIniFile.Create('MyIni.ini');
   try
     ini.ReadSections(uList);
     if uList.Count > 0 then MessageDlg('All Section:  ' + uList.Text, mtInformation, [mbOK], 0);
   finally
     ini.Free;
   end;
  finally
    uList.Free;
  end;
except
  Exit;
end;
end;

 // Read a section
procedure TmyChatGPT.ReadSecIniFile(uFile: string; Section_Name: string);
var
    ini: TIniFile;
    uList: TStringList;
begin
try
  try
    uList := TStringList.Create;
    ini := TIniFile.Create(uFile);
   try
    ini.ReadSection(Section_Name, uList);
    if uList.Count > 0 then MessageDlg('Read of Section:  ' + uList.Text, mtInformation, [mbOK], 0);
   finally
    ini.Free;
   end;
  finally
    uList.Free;
  end;
except
   Exit;
end;
end;

 // Read section values
procedure TmyChatGPT.ReadValueSecIniFile(uFile: string; Section_Name: string);
var
    ini: TIniFile;
    uList: TStringList;
begin
try
  try
    uList := TStringList.Create;
    ini := TIniFile.Create(uFile);
   try
    ini.ReadSectionValues(Section_Name, uList);
    if uList.Count > 0 then MessageDlg('Value of Section:  ' + uList.Text, mtInformation, [mbOK], 0);
   finally
    ini.Free;
   end;
  finally
    uList.Free;
  end;
except
   Exit;
end;
end;

 // Erase a section
procedure TmyChatGPT.EraseSecIniFile(uFile: string; Section_Name: string);
var
    ini: TIniFile;
begin
try
    ini := TIniFile.Create(uFile);
   try
    ini.EraseSection(Section_Name);
    MessageDlg('Erase of Section:  ' + Section_Name + ' successfully', mtInformation, [mbOK], 0);
   finally
    ini.Free;
   end;
except
   Exit;
end;
end;

function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;  { Run a DOS program and retrieve its output dynamically while it is running. }
var
  SecAtrrs: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  pCommandLine: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SecAtrrs do begin
    nLength := SizeOf(SecAtrrs);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SecAtrrs, 0);
  try
    with StartupInfo do
    begin
      FillChar(StartupInfo, SizeOf(StartupInfo), 0);
      cb := SizeOf(StartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), StartupInfo, ProcessInfo);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := windows.ReadFile(StdOutPipeRead, pCommandLine, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            pCommandLine[BytesRead] := #0;
            Result := Result + pCommandLine;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      finally
        CloseHandle(ProcessInfo.hThread);
        CloseHandle(ProcessInfo.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;

function MemoryStreamToString(M: TMemoryStream): string;
begin
  SetString(Result, PChar(M.Memory), M.Size div SizeOf(Char));
end;

procedure StringToStream(const AString: string; out AStream: TStream);
begin
  AStream := TStringStream.Create(AString);
end;

function StreamToString(Stream : TStream) : String;
var ms : TMemoryStream;
begin
  Result := '';
  ms := TMemoryStream.Create;
  try
    ms.LoadFromStream(Stream);
    SetString(Result,PChar(ms.memory),ms.Size);
  finally
    ms.free;
  end;
end;

//Translate
function TmyChatGPT.PostTranslate(Metod: string; RequestURL: string; Params: string): string;
var
  Req: OleVariant;
  OV: Variant;
  os: TOLEStream;
  im: TMemoryStream;
  Json : JSONBase;
  str : JSONString;
  ABuilder: TStringCatHelper;
begin
try
  Result:='';
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(Metod, RequestURL, False);
    Req.SetRequestHeader('Content-Type','application/json; charset=utf-8');
    Req.SetRequestHeader('Cache-control','no-cache');
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.SetRequestHeader('Accept','application/json');
    Req.Send(Params);
    Req.WaitForResponse;
    GetRegStatus(Req.Status);
  finally
    OV:=Req.ResponseStream;
    TVarData(OV).vType:=varUnknown;
    os:=TOLEStream.Create(IStream(TVarData(OV).VUnknown));
    im:=TMemoryStream.Create;
    im.CopyFrom(os,os.Size);
    im.Position:=0;
    str:=StreamToString(im);
    str:=Utf8ToAnsi(str);
    if Length(str)>0 then
     try
       ABuilder := TStringCatHelper.Create;
       Json := JSONBase.Parser(Trim(str), False);
       mmo1.Lines.Add(PChar(Trim(Json.ToString(4,False))));
       Result:=Trim(Json.GetSTS('content',Json,0,ABuilder,7));
     finally
       FreeAndNil(ABuilder);
     end;
  end;
except
  Result:='Error Out Json';
  Exit;
end;
end;

procedure THTTPRequest.SetFileName;
var
  vDlg: TSaveDialog;
begin
  vDlg := TSaveDialog.Create(Application);
  try
    if DirectoryExists(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir) then
    vDlg.InitialDir := GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir
    else vDlg.InitialDir := GetCurrentDir;
    vDlg.Filter := 'Json file|*.json';
    vDlg.DefaultExt := 'json';
    vDlg.FilterIndex := 1;
    vDlg.FileName := FParams.DocName + '_' + FParams.ObjName;
    //if vDlg.Execute then FFileName := vDlg.FileName else FFileName := '';
    FFileName := vDlg.InitialDir +'\'+ vDlg.FileName;
  finally
    vDlg.Free;
  end
end;

procedure THTTPRequest.Execute;
begin
 try
  Synchronize(GetImage);
 except
  Exit;
 end;  
end;

//GetImage
procedure THTTPRequest.GetImage;  //(Metod: string; RequestURL: string; Params: string; Bearer: string)
var
  Req: OleVariant;
  OV: Variant;
  os: TOLEStream;
  im: TMemoryStream;
  Json : JSONBase;
  str : JSONString;
  ABuilder: TStringCatHelper;
begin
try
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(FParams.Method, FParams.RequestURL, False);
    Req.SetRequestHeader('Authorization', 'Bearer ' + FParams.Token); //Req.SetRequestHeader('OpenAI-Organization','org-bXVjI4KnG03UZemtwcyVmWoi');
    Req.SetRequestHeader('Content-Type','application/json; charset=utf-8');
    Req.SetRequestHeader('Cache-control','no-cache');
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.SetRequestHeader('Accept','application/json');
    Req.Send(FParams.ObjId);
    Req.WaitForResponse;
    myChatGPT.GetRegStatus(Req.Status);
    if Req.Status = 200 then
    begin
       Synchronize(SetFileName);
    if FFileName <> '' then begin
       os := TOleStream.Create(IUnknown(Req.ResponseStream) as IStream);
       im := TMemoryStream.Create;
        try
          im.LoadFromStream(os);
          im.SaveToFile(FFileName);
        finally
          im.Free;
        end;
        FMessage := ''   //
    end;
    os := TOleStream.Create(IUnknown(Req.ResponseStream) as IStream);
    im:=TMemoryStream.Create;
    im.CopyFrom(os,os.Size);
    im.Position:=0;
    str:=StreamToString(im);
    str:=Utf8ToAnsi(str);
    if Length(str) > 0 then begin
       ABuilder := TStringCatHelper.Create;
       try
          Json := JSONBase.Parser(Trim(str), False);
       if Assigned(Json) then begin
          str := '';
          str := PChar(Trim(Json.ToString(4,False)));
          myChatGPT.mmo1.Lines.Add(str);
          myChatGPT.lst2.Items.Add(str);
          str := '';
          str:=Trim(Json.GetSTS('url',Json,0,ABuilder,7));
          myChatGPT.Memo2.Lines.Add(str);
          if Length(str) > 0 then ShellExecute(Handle, 'open', PChar(str), nil, nil, SW_NORMAL);
       end;
       finally
          FreeAndNil(ABuilder);
       end;
    end;
    end
    else
    begin
      FMessage := 'HTTP ' + IntToStr(Req.Status) + ' ' + Req.StatusText;
    end;
    Synchronize(SynchronizeResult);
  finally
    Req := Unassigned;
  end;
except
  Exit;
end;
end;

//Translate
function TmyChatGPT.GetTranslate(Metod: string; RequestURL: string): string;
var
  Req: OleVariant;
  OV: Variant;
  os: TOLEStream;
  im: TMemoryStream;
  Json : JSONBase;
  str : JSONString;
  ABuilder: TStringCatHelper;
begin
try
  Result:='';
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(Metod, RequestURL, False);
    Req.SetRequestHeader('Content-Type','application/json; charset=utf-8');
    Req.SetRequestHeader('Cache-control','no-cache');
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.SetRequestHeader('Accept','application/json');
    Req.Send;
    Req.WaitForResponse;
    GetRegStatus(Req.Status);
  finally
    OV:=Req.ResponseStream;
    TVarData(OV).vType:=varUnknown;
    os:=TOLEStream.Create(IStream(TVarData(OV).VUnknown));
    im:=TMemoryStream.Create;
    im.CopyFrom(os,os.Size);
    im.Position:=0;
    str:=StreamToString(im);
    str:=Utf8ToAnsi(str);
    if Length(str)>0 then
     try
       ABuilder := TStringCatHelper.Create;
       Json := JSONBase.Parser(Trim(str), False);
       str:='';
       str:=PChar(Trim(Json.ToString(4,False)));
       mmo1.Lines.Add(Trim(str));
       lst2.Items.Add(Trim(str));
       if Pos('translatedText',Trim(str)) > 0 then Result:=Trim(Json.GetSTS('translatedText',Json,0,ABuilder,7)) else
       Result := PChar(Trim(Json.ToString(4,False)));
     finally
       FreeAndNil(ABuilder);
     end;
  end;
except
  Result:='Error Out Json';
  Exit;
end;
end;

//Autorisation
function TmyChatGPT.PostParam(Metod: string; RequestURL: string; Params: string; Bearer: string): string;
var
  Req: OleVariant;
  OV: Variant;
  os: TOLEStream;
  im: TMemoryStream;
  Json : JSONBase;
  str : JSONString;
  ABuilder: TStringCatHelper;
begin
try
  Result:='';
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(Metod, RequestURL, False);
    Req.SetRequestHeader('Authorization', 'Bearer ' + Bearer); //Req.SetRequestHeader('OpenAI-Organization','org-bXVjI4KnG03UZemtwcyVmWoi');
    Req.SetRequestHeader('Content-Type','application/json; charset=utf-8');
    Req.SetRequestHeader('Cache-control','no-cache');
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.SetRequestHeader('Accept','application/json');
    if ((Length(Params) = 0)and(Metod = 'GET')) then Req.Send else Req.Send(Params);
    Req.WaitForResponse;
    GetRegStatus(Req.Status);
  finally
    OV:=Req.ResponseStream;
    TVarData(OV).vType:=varUnknown;
    os:=TOLEStream.Create(IStream(TVarData(OV).VUnknown));
    im:=TMemoryStream.Create;
    im.CopyFrom(os,os.Size);
    im.Position:=0;
    str:=StreamToString(im);
    str:=Utf8ToAnsi(str);
    if Length(str)>0 then
     try
       ABuilder := TStringCatHelper.Create;
       Json := JSONBase.Parser(Trim(str), False);
       str:='';
       str:=PChar(Trim(Json.ToString(4,False)));
       mmo1.Lines.Add(Trim(str));
       lst2.Items.Add(Trim(str));
       if Pos('content',Trim(str)) > 0 then Result:=Trim(Json.GetSTS('content',Json,0,ABuilder,7)) else
       Result := PChar(Trim(Json.ToString(4,False)));
     finally
       FreeAndNil(ABuilder);
     end;
  end;
except
  Result:='Error Out Json';
  Exit;
end;
end;

procedure CaptureConsoleOutput(const ACommand, AParameters: String; AMemo: TMemo);
 const
   CReadBuffer = 2400;
 var
   saSecurity: TSecurityAttributes;
   hRead: THandle;
   hWrite: THandle;
   suiStartup: TStartupInfo;
   piProcess: TProcessInformation;
   pBuffer: array[0..CReadBuffer] of AnsiChar;      //----- update
   dRead: DWord;
   dRunning: DWord;
begin
try
   saSecurity.nLength := SizeOf(TSecurityAttributes);
   saSecurity.bInheritHandle := True;  
   saSecurity.lpSecurityDescriptor := nil; 
   if CreatePipe(hRead, hWrite, @saSecurity, 0) then
   begin    
     FillChar(suiStartup, SizeOf(TStartupInfo), #0);
     suiStartup.cb := SizeOf(TStartupInfo);
     suiStartup.hStdInput := hRead;
     suiStartup.hStdOutput := hWrite;
     suiStartup.hStdError := hWrite;
     suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;    
     suiStartup.wShowWindow := SW_HIDE;
     if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity,
       @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup, piProcess)
       then
     begin
       repeat
         dRunning  := WaitForSingleObject(piProcess.hProcess, 100);        
         Application.ProcessMessages(); 
         repeat
           dRead := 0;
           ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);          
           pBuffer[dRead] := #0;
           OemToAnsi(pBuffer, pBuffer);
           AMemo.Lines.Add(String(pBuffer));
         until (dRead < CReadBuffer);      
       until (dRunning <> WAIT_TIMEOUT);
       CloseHandle(piProcess.hProcess);
       CloseHandle(piProcess.hThread);    
     end;
     CloseHandle(hRead);
     CloseHandle(hWrite);
   end;
except
  Exit;
end;
end;

procedure TmyChatGPT.FormCreate(Sender: TObject);
var Url : string; i : Integer; s,s1,str: string;
begin
try
      TrayIcon1.IconVisible := True;
      DecodeDate(Now,wy,wm,wd);
      myDir := FormatDateTime('dd',Now)+'.'+FormatDateTime('mm',Now)+'.'+FormatDateTime('yyyy',Now);
   if not DirectoryExists(GetCurrentDir+'\'+IntToStr(wy)) then  ForceDirectories(GetCurrentDir+'\'+IntToStr(wy));
   if not DirectoryExists(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)) then  ForceDirectories(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy));
   if not DirectoryExists(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir) then ForceDirectories(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir);
      Url := 'https://api.openai.com/v1/completions';
   if FileExists(FileName) then DeleteFile(FileName);
      cbbSize.ItemIndex := 0;
      TrayIcon1.IconVisible := True;
   if FileExists(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini') then begin
      ApiKey := ReadIniFile(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini','Bearer','Token');
      GoogleLanguageApiKey := ReadIniFile(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini','Bearer','GoogleLanguageApiKey');
   end;
   if FileExists(ExtractFileDir(ParamStr(0))+'\prompts.csv') then begin
    try
     try
       uStr := TStringList.Create;
       uStr1 := TStringList.Create;
       uStr2 := TStringList.Create;
       uStr.LoadFromFile(ExtractFileDir(ParamStr(0))+'\prompts.csv');
       if uStr.Count > 0 then
       for i := 0 to uStr.Count-1 do begin
           str := uStr.Strings[i];
           if pos('"',str)<>0 then begin
              s := str;
              delete(s,1,pos('"',s));
              s:=copy(s,1,pos('"',s)-1);
              uStr1.Add(s);
              cPrompts.Items.Add(s);
              if pos('"',str)<>0 then begin
                 s1 := str;
                 delete(s1,1,pos('"',s1)+Length(s)+2);
                 if pos('"',s1)<>0 then begin
                    delete(s1,1,pos('"',s1));
                    s:=copy(s1,1,pos('"',s1)-1);
                    uStr2.Add(s);
                 end;
              end;
           end;//          cPrompts
       end;
     finally
       uStr.Free;
     end;
    except
      //
    end;
   end;
   if sSkinForm = 0 then begin
     ResStream := TResourceStream.Create(HInstance, 'Office12S', RT_RCDATA);   //Office12Style.RES
   try
     sSkinManager1.InternalSkins.Add;
     sSkinManager1.InternalSkins[sSkinManager1.InternalSkins.Count - 1].Name := SkinName;
     sSkinManager1.InternalSkins[sSkinManager1.InternalSkins.Count - 1].PackedData.LoadFromStream(ResStream);
     sSkinManager1.SkinName := SkinName;
     sSkinManager1.Active := True;
   finally
     FreeAndNil(ResStream);
   end;
   end else FreeAndNil(sSkinManager1);
except
  Exit;
end;
end;

procedure TmyChatGPT.chksaveClick(Sender: TObject);
begin
  if chksave.Checked then begin
  if DirectoryExists(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir) then begin
     lst2.Items.SaveToFile(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir+'\Dialog.txt');
     mmo1.Lines.SaveToFile(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir+'\Respons.txt');
  end;
     lst2.Items.Clear;
     mmo1.Lines.Clear;
     Sleep(500);
     stat1.SimpleText := 'Saved successfully';
  end else stat1.SimpleText := '';
end;

procedure TmyChatGPT.lst2Click(Sender: TObject);
begin
try
  if lst2.ItemIndex > -1 then Clipboard.AsText:=lst2.Items.Strings[lst2.ItemIndex]; Caption := 'Text copied to clipboard';
except
  Exit;
end;
end;

procedure TmyChatGPT.Memo1Change(Sender: TObject);
begin
  Caption := '';
end;

procedure TmyChatGPT.edt1KeyPress(Sender: TObject; var Key: Char);
var str,Url : string; i : Integer;
begin
if Key = #13 then
if Length(Trim(ApiKey)) > 0 then begin
try
    str:='';
    btnTranc.Enabled := True;
    str := edt1.Text; edt1.Clear;
    if Length(str) > 0 then begin
       Url := 'https://api.openai.com/v1/chat/completions';
       Memo1.Lines.Add(PostParam('POST',Url,'{  "model": "gpt-3.5-turbo",  "messages": [{"role": "user", "content": "'+str+'!"}]}',ApiKey));
       Memo2.Clear;
       str := Trim(Memo1.Lines.Text);
       Memo2.Lines.Add(str);      
       Application.ProcessMessages;
     try
       uText := str;
       if not Assigned(fMyThread) then fMyThread := TMyThread.Create(UpdateProgressBar);
       Application.ProcessMessages;
     except
       on E:Exception do
          Writeln(E.Classname, ':', E.Message);
     end;
       lst2.Items.Add(Trim(Memo1.Lines.Text));
       Memo1.Clear;
    end else begin
       stat1.SimpleText := 'Empty text';
       TrayIcon1.ShowBalloonHint('The ChatGPT', 'Empty text', bitInfo, 11);  //bitInfo, bitWarning, bitError,
       Application.ProcessMessages;
    end;
except
  Exit;
end;
end else if (Length(Trim(ApiKey)) = 0) then begin
  MessageBox(Handle,PChar('No token, please enter a token!'), PChar('Attention'), 64);
  btnToken.Click;
end;
end;

procedure TmyChatGPT.FormActivate(Sender: TObject);
begin
try
  edt1.SetFocus;
  if Win32Platform = VER_PLATFORM_WIN32_NT then SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF); RamClean;
except
  Exit;
end;
end;

procedure TmyChatGPT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
try
  uStr1.Free;
  uStr2.Free;
  if sSkinManager1 <> nil then FreeAndNil(sSkinManager1);
  Application.Terminate;
except
  Exit;
end;
end;

procedure TmyChatGPT.ShowWindow1Click(Sender: TObject);
begin
try
  TrayIcon1.ShowMainForm;    // ALWAYS use this method to restore!!!
  if Win32Platform = VER_PLATFORM_WIN32_NT then SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF); RamClean;
except
  Exit;
end;
end;

procedure TmyChatGPT.HideWindow1Click(Sender: TObject);
begin
  Application.Minimize;      // Will hide dialogs and popup windows as well (this demo has none)
  TrayIcon1.HideMainForm;
end;

procedure TmyChatGPT.Exit1Click(Sender: TObject);
begin
try
  if DirectoryExists(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir) then begin
     lst2.Items.SaveToFile(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir+'\Dialog.txt');
     mmo1.Lines.SaveToFile(GetCurrentDir+'\'+IntToStr(wy)+'\'+IntToStr(wm)+IntToStr(wy)+'\'+myDir+'\Respons.txt');
  end;
  lst2.Items.Clear;
  mmo1.Lines.Clear;
  Sleep(500);
  stat1.SimpleText := 'Saved successfully';
  uStr1.Free;
  uStr2.Free;
  if sSkinManager1 <> nil then FreeAndNil(sSkinManager1);  
  Application.Terminate;
  Close;
except
  Exit;
end;
end;

procedure TmyChatGPT.TrayIcon1BalloonHintClick(Sender: TObject);
begin
  SetForegroundWindow(Application.Handle);  // Move focus from tray icon to this form
end;

procedure TmyChatGPT.TrayIcon1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(PopupMenu1) then
    if not PopupMenu1.AutoPopup then
    begin
      SetForegroundWindow(Application.Handle);  // Move focus from tray icon to this form
      MessageDlg('The popup menu is disabled.', mtInformation, [mbOk], 0);
    end;
end;

procedure TmyChatGPT.TrayIcon1Click(Sender: TObject);
begin
try
  TrayIcon1.IconList := ImageList1;  //TrayIcon1.ShowBalloonHint('The ChatGPT', 'Do you here?', bitInfo, 11);  //bitInfo, bitWarning, bitError,
  TrayIcon1.CycleInterval := 300;
  TrayIcon1.CycleIcons := True;
  TrayIcon1.ShowMainForm;    // ALWAYS use this method to restore!!!
  if Win32Platform = VER_PLATFORM_WIN32_NT then SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF); RamClean;
except
  Exit;
end;
end;

procedure TmyChatGPT.aYourTokenExecute(Sender: TObject);
begin
try
 try
  fSetting := TfSetting.Create(Self);
  fSetting.ShowModal;
  ApiKey := fSetting.uToken;
  GoogleLanguageApiKey := fSetting.uGoogleLanguageApiKey;
  temper := fSetting.temper;
  stat1.SimpleText := 'Token saved successfully';
 finally
  fSetting.Free;
 end;
except
  Exit;
end;
end;

procedure TmyChatGPT.aCreateCompletionExecute(Sender: TObject);
var str,Url : string;
begin
try
  Memo1.Clear;
  Memo2.Clear;
  str := '';
  str := InputBox('Add your prompt ?','Say this is a test','');
  Url := 'https://api.openai.com/v1/completions';
  if ((Length(Trim(ApiKey)) > 0)and(Length(str) > 0)) then PostParam('POST',Url,'{"model": "text-davinci-003", "prompt": "'+str+'", "temperature": 0, "max_tokens": 7}',ApiKey) else if (Length(Trim(ApiKey)) = 0) then begin
     MessageBox(Handle,PChar('No token, please enter a token!'), PChar('Attention'), 64);
     btnToken.Click;
  end;
except
  Exit;
end;
end;

procedure TmyChatGPT.aCreateImageExecute(Sender: TObject);
var str,promt,Url: string;
begin
try
  Memo1.Clear;
  Memo2.Clear;
  str:='';
  promt:='';
  promt:=InputBox('Creates an image given a prompt ?','A cute baby sea otter [size : '+cbbSize.Text+']','');
  if ((Length(Trim(ApiKey)) > 0)and(Length(promt) > 0)) then begin
     Url := 'https://api.openai.com/v1/images/generations';
     str := StringReplace(CreateImage, '#', promt, [rfReplaceAll, rfIgnoreCase]);
     str := StringReplace(CreateImage, '@', cbbSize.Text, [rfReplaceAll, rfIgnoreCase]); 
     if Length(str) > 0 then begin 
        FParams.RequestURL := '';
        FParams.ObjId := str;
        FParams.DocName := SetFileName;
        FParams.ObjName := 'out';
        FParams.RequestURL := Url;
        FParams.Token := ApiKey;
        FParams.Method := 'POST';
        THTTPRequest.Create(FParams);
     end;
  end else if (Length(Trim(ApiKey)) = 0) then begin
     MessageBox(Handle,PChar('No token, please enter a token!'), PChar('Attention'), 64);
     btnToken.Click;
  end;
except
  Exit;
end;
end;

procedure TmyChatGPT.aListModelsExecute(Sender: TObject);
var Url : string;
begin
try
  Memo1.Clear;
  Memo2.Clear;
  Url := 'https://api.openai.com/v1/models';
  if Length(Trim(ApiKey)) > 0 then PostParam('GET',url,'',ApiKey) else if (Length(Trim(ApiKey)) = 0) then begin
     MessageBox(Handle,PChar('No token, please enter a token!'), PChar('Attention'), 64);
     btnToken.Click;
  end;
except
  Exit;
end;
end;

procedure TmyChatGPT.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := False;
  TrayIcon1.HideMainForm;
end;

procedure TmyChatGPT.aListFineTunesExecute(Sender: TObject);
var Url : string;
begin
try
  Memo1.Clear;
  Memo2.Clear;
  Url := 'https://api.openai.com/v1/fine-tunes';
  if Length(Trim(ApiKey)) > 0 then PostParam('GET',url,'',ApiKey) else if (Length(Trim(ApiKey)) = 0) then begin
     MessageBox(Handle,PChar('No token, please enter a token!'), PChar('Attention'), 64);
     btnToken.Click;
  end;
except
  Exit;
end;
end;

procedure TmyChatGPT.cPromptsChange(Sender: TObject);
begin
try
  if cPrompts.ItemIndex = -1 then Exit;
  if cPrompts.Items.Count > 0 then edt1.Text := uStr2.Strings[cPrompts.ItemIndex];
except
  Exit;
end;
end;

//TextEncode
function UrlEncode(Str: ansistring): ansistring; 
  function CharToHex(Ch: ansiChar): Integer;
  asm
    and eax, 0FFh
    mov ah, al
    shr al, 4
    and ah, 00fh
    cmp al, 00ah
    jl @@10
    sub al, 00ah
    add al, 041h
    jmp @@20
@@10:
    add al, 030h
@@20:
    cmp ah, 00ah
    jl @@30
    sub ah, 00ah
    add ah, 041h
    jmp @@40
@@30:
    add ah, 030h
@@40:
    shl eax, 8
    mov al, '%'
  end;
var
  i, Len: Integer;
  Ch: ansiChar;
  N: Integer;
  P: PansiChar;
begin
  Result := '';
  Len := Length(Str);
  P := PansiChar(@N);
  for i := 1 to Len do
  begin
    Ch := Str[i];
    if Ch in ['0'..'9', 'A'..'Z', 'a'..'z', '_'] then
      Result := Result + Ch
    else
    begin
      if Ch = ' ' then
        Result := Result + '+'
      else
      begin
        N := CharToHex(Ch);
        Result := Result + P;
      end;
    end;
  end;
end;
 
function UrlDecode(Str: Ansistring): Ansistring;
  function HexToChar(W: word): AnsiChar;
  asm
   cmp ah, 030h
   jl @@error
   cmp ah, 039h
   jg @@10
   sub ah, 30h
   jmp @@30
@@10:
   cmp ah, 041h
   jl @@error
   cmp ah, 046h
   jg @@20
   sub ah, 041h
   add ah, 00Ah
   jmp @@30
@@20:
   cmp ah, 061h
   jl @@error
   cmp al, 066h
   jg @@error
   sub ah, 061h
   add ah, 00Ah
@@30:
   cmp al, 030h
   jl @@error
   cmp al, 039h
   jg @@40
   sub al, 030h
   jmp @@60
@@40:
   cmp al, 041h
   jl @@error
   cmp al, 046h
   jg @@50
   sub al, 041h
   add al, 00Ah
   jmp @@60
@@50:
   cmp al, 061h
   jl @@error
   cmp al, 066h
   jg @@error
   sub al, 061h
   add al, 00Ah
@@60:
   shl al, 4
   or al, ah
   ret
@@error:
   xor al, al
  end; 
  function GetCh(P: PAnsiChar; var Ch: AnsiChar): AnsiChar;
  begin
    Ch := P^;
    Result := Ch;
  end;
var
  P: PAnsiChar;
  Ch: AnsiChar;
begin
  Result := '';
  P := @Str[1];
  while GetCh(P, Ch) <> #0 do
  begin
    case Ch of
      '+': Result := Result + ' ';
      '%':
        begin
          Inc(P);
          Result := Result + HexToChar(PWord(P)^);
          Inc(P);
        end;
    else
      Result := Result + Ch;
    end;
    Inc(P);
  end;
end;

procedure TmyChatGPT.btnTrancClick(Sender: TObject);
var Url: string;
begin
try
  if Length(edt1.Text) > 0 then begin
     Memo1.Clear;
     Memo2.Clear;
     btnTranc.Enabled := False;
  if Length(Trim(GoogleLanguageApiKey)) > 0 then begin
     Url := 'https://www.googleapis.com/language/translate/v2?key='+GoogleLanguageApiKey+'&source=ru&target=en&q='+UrlEncode(AnsiToUtf8(edt1.Text));;
     edt1.Text := GetTranslate('GET',Url);
  end else if (Length(Trim(GoogleLanguageApiKey)) = 0) then begin
     MessageBox(Handle,PChar('No GoogleLanguageApiKey, please enter a GoogleLanguageApiKey!'), PChar('Attention'), 64);
     btnToken.Click;
  end;
  end;
except
  Exit;
end;
end;

end.
