unit Frm_WDPOST;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdStack;

Const Codes64 ='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
      MaxExe  = 20;

type
  TFormWDPOST = class(TForm)
    mresult: TMemo;
    Button2: TButton;
    Label3: TLabel;
    teURL: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    tepsk: TEdit;
    Label8: TLabel;
    teSalt: TEdit;
    lbl_exe: TLabel;
    mjson: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FnbExe:Integer;
    Auto:boolean;
    NoDel:Boolean;
    log:boolean;
    FHttpErrorCode:integer;
    FUrl:string;
    FSalt:string;
    FPsk:string;
    FJson:string;
    procedure SetHttpErrorCode(Avalue:integer);
    procedure SetnbExe(Avalue:integer);
    procedure SetPsk(Avalue:string);
    procedure SetJson(Avalue:string);
    procedure SendPostData;
    procedure SetUrl(Avalue:string);
    procedure SetSalt(Avalue:string);
    procedure Attendre;
    procedure Load_Param(aparam:string;avalue:string);
    function  Randomstring(strLen: Integer): string;
    { Déclarations privées }
    procedure  MyEnumprocess;
  public
    property nbExe:Integer read FnbExe write SetnbExe;
    property HttpErrorCode:integer read FHttpErrorCode write SetHttpErrorCode;
    property Psk:string read FPsk write SetPsk;
    property Url:string read Furl write SetUrl;
    property Json:string read FJson write SetJson;
    property Salt:string read FSalt write SetSalt;
    { Déclarations publiques }
  end;
    function EnumProcess(hHwnd: HWND; lParam : integer): boolean; stdcall;

var
  FormWDPOST: TFormWDPOST;
  lp:Integer;

implementation

{$R *.dfm}

function EnumProcess(hHwnd: HWND; lParam : integer): boolean; stdcall;
var
  pPid : DWORD;
  title, ClassName : string;
  x:integer;
begin
  //if the returned value in null the
  //callback has failed, so set to false and exit.
  if (hHwnd=NULL) then
  begin
    result := false;
  end
  else
  begin
    //additional functions to get more
    //information about a process.
    //get the Process Identification number.
    GetWindowThreadProcessId(hHwnd,pPid);
    //set a memory area to receive
    //the process class name
    SetLength(ClassName, 255);
    //get the class name and reset the
    //memory area to the size of the name
    SetLength(ClassName,
              GetClassName(hHwnd,
                           PChar(className),
                           Length(className)));
    SetLength(title, 255);
    //get the process title; usually displayed
    //on the top bar in visible process
    SetLength(title, GetWindowText(hHwnd, PChar(title), Length(title)));
    //Display the process information
    //by adding it to a list box
    if (UpperCase(title) = Application.Title) AND (UpperCase(className)='TAPPLICATION')
      then
          begin
               x:=FormWDPOST.nbExe;
               FormWDPOST.nbExe:=x+1;
          end;
    {
          FormWDPOST.mresult.Lines.Add
        ('Class Name = ' + className +
         '; Title = ' + title +
         '; HWND = ' + IntToStr(hHwnd) +
         '; Pid = ' + IntToStr(pPid));
    }
    Result := true;
  end;
end;


procedure TFormWDPOST.MyEnumprocess;
begin
    //lp := 0; //globally declared integer
    //call the windows function with the address
    //of handling function and show an error message if it fails
    if EnumWindows(@EnumProcess,0) = false then
        ShowMessage('Error: Could not obtain process window hook from system.');
end;

function TFormWDPOST.Randomstring(strLen: Integer): string;
begin
    Randomize;
    Result := '';
    repeat
      Result := Result + Codes64[Random(Length(Codes64)) + 1];
    until (Length(Result) = strLen)
end;

procedure TFormWDPOST.SetNbExe(Avalue:integer);
begin
     FNbExe:=Avalue;
     lbl_exe.Caption:=IntToStr(Avalue);
end;

procedure TFormWDPOST.SetSalt(Avalue:string);
begin
     FSalt:=Avalue;
end;

procedure TFormWDPOST.SetUrl(Avalue:string);
begin
     FUrl:=Avalue;
end;

procedure TFormWDPOST.SetHttpErrorCode(Avalue:integer);
begin
     FHttpErrorCode:=Avalue;
end;

procedure TFormWDPOST.SetJson(Avalue:string);
begin
     FJson:='{' + Avalue +',c:security_code}';
end;

procedure TFormWDPOST.SetPsk(Avalue: string);
begin
      FPsk:=Avalue;
end;

procedure TFormWDPOST.Button2Click(Sender: TObject);
begin
     SendPostData();
end;


procedure TFormWDPOST.FormCreate(Sender: TObject);
var i:integer;
    tmp:string;
    param:string;
    value:string;
begin
     Caption:='WDPOST : ' + FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz',Now());
     Auto:=false;
     log:=false;
     NoDel:=False;
     teSalt.Text:=Randomstring(10);
     //-------------------------------------------------------------------------
     for i :=1 to ParamCount do
      begin
            // Debug
            If lowercase(ParamStr(i))='-log' then log:=true;
            // Auto
            If lowercase(ParamStr(i))='-auto'  then Auto:=true;
            // DeleteFile
            If lowercase(ParamStr(i))='-nodel' then NoDel:=true;

            param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
            value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
            If lowercase(param)='-url'      then Load_Param('url',value);
            If lowercase(param)='-psk'      then Load_Param('psk',value);
            If lowercase(param)='-json'     then Load_Param('json',value);
            If lowercase(param)='-file'     then Load_Param('file',value);
      end;
    Application.ProcessMessages;
    MyEnumprocess;
    if nbExe>MaxExe then Application.Terminate;
    If Auto
        then
            begin
                 ShowWindow(Application.Handle, SW_HIDE);
                 SendPostData;
                 Application.ProcessMessages;
                 Attendre;
                 Application.Terminate;
            end
        else
            begin
                 Application.ShowMainForm:=true;
                 ShowWindow(Application.Handle, SW_SHOW);
            end;
end;

procedure TFormWDPOST.Load_Param(aparam:string;avalue:string);
begin
     if aparam='url'      then teUrl.text:=avalue;
     if aparam='psk'      then tepsk.text:=avalue;
     if aparam='json'     then mJson.Lines.Text:=avalue;
     if aparam='file'     then
        begin
           if FileExists(avalue) then
             begin
                 mJson.Lines.LoadFromFile(avalue,TEncoding.Ansi);
                 if not(NoDel) then
                   DeleteFile(avalue);
             end;
        end;
end;

procedure  TFormWDPOST.Attendre;
var Ticks: DWORD;
begin
     Ticks := 0;
     while (Ticks = GetTickCount) do  Sleep(10);
end;


procedure TFormWDPOST.SendPostData;
var s:string;
    ParamList: TStringList;
    HTTP: TIdHTTP;
begin
     SetUrl(teURL.Text);
     SetPsk(tePSK.Text);
     SetJson(mJson.Lines.text);
     SetSalt(teSalt.Text);
     HTTP := TIdHTTP.Create(nil);
     Http.ConnectTimeout := 4000; // 4 seconds
     Http.ReadTimeout    := 3000; // 3 seconds
     HTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64)';
     ParamList := TStringList.Create;
     Try
        ParamList.Add(Format('psk=%s',[psk]));
        ParamList.Add(Format('salt=%s',[Salt]));
        ParamList.Add(Format('json=%s',[Json]));
        Label6.Caption:='';
        mresult.Text:='';
        Try
           s := HTTP.Post(Url, ParamList);
           HttpErrorCode:=HTTP.ResponseCode;
           Label6.Caption:=IntToStr(HttpErrorCode);
           mresult.Text := s;
        Except
              on E : EIdHTTPProtocolException do
              begin
                   mresult.Lines.Add(Format('ErrorCode    : %d',[E.ErrorCode]));
              end;
              on E : EIdUnknownProtocol do
              begin
                   mresult.Lines.Add(Format('Message      : %s',[E.Message]));
              end;
              on E : EIdSocketError do
              begin
                   if E.LastError=11001 then
                      begin
                           mresult.Lines.Add('Hôte non trouvé.');
                      end
                      else
                      begin
                           mresult.Lines.Add(Format('LastError : %d',[E.LastError]));
                           mresult.Lines.Add(Format('Message      : %s',[E.Message]));
                           mresult.Lines.Add(Format('StackTrace   : %s',[E.StackTrace]));
                      end;
              end;
              on E : Exception do
                  begin
                         mresult.Lines.Add(Format('ClassName : %s',[E.ClassName]));
                         mresult.Lines.Add(Format('Message : %s',[E.Message]));
                  end;

        End;
     Finally
        ParamList.Free;
        HTTP.Free;
     End;
end;

end.

