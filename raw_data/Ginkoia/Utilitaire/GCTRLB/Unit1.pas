unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP,IdStack;

Const Codes64 ='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

type
  TForm1 = class(TForm)
    mresult: TMemo;
    Button2: TButton;
    Label3: TLabel;
    teJson: TEdit;
    teURL: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    tepsk: TEdit;
    Label8: TLabel;
    teSalt: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Auto:boolean;
    log:boolean;
    FHttpErrorCode:integer;
    FUrl:string;
    FSalt:string;
    FPsk:string;
    FJson:string;
    procedure SetHttpErrorCode(Avalue:integer);
    procedure SetPsk(Avalue:string);
    procedure SetJson(Avalue:string);
    procedure SendPostData;
    procedure SetUrl(Avalue:string);
    procedure SetSalt(Avalue:string);
    procedure Attendre;
    procedure Load_Param(aparam:string;avalue:string);
    function  Randomstring(strLen: Integer): string;
    { Déclarations privées }
  public
    property HttpErrorCode:integer read FHttpErrorCode write SetHttpErrorCode;
    property Psk:string read FPsk write SetPsk;
    property Url:string read Furl write SetUrl;
    property Json:string read FJson write SetJson;
    property Salt:string read FSalt write SetSalt;
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.Randomstring(strLen: Integer): string;
begin
    Randomize;
    Result := '';
    repeat
      Result := Result + Codes64[Random(Length(Codes64)) + 1];
    until (Length(Result) = strLen)
end;

procedure TForm1.SetSalt(Avalue:string);
begin
     FSalt:=Avalue;
end;

procedure TForm1.SetUrl(Avalue:string);
begin
     FUrl:=Avalue;
end;

procedure TForm1.SetHttpErrorCode(Avalue:integer);
begin
     FHttpErrorCode:=Avalue;
end;

procedure TForm1.SetJson(Avalue:string);
begin
     FJson:='{' + Avalue +',c:security_code}';
end;

procedure TForm1.SetPsk(Avalue: string);
begin
      FPsk:=Avalue;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     SendPostData();
end;


procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
    tmp:string;
    param:string;
    value:string;
begin
     Auto:=false;
     log:=false;
     teSalt.Text:=Randomstring(10);
     //-------------------------------------------------------------------------
     for i :=1 to ParamCount do
      begin
            // Debug
            If lowercase(ParamStr(i))='-log' then log:=true;
            // Auto
            If lowercase(ParamStr(i))='-auto'   then Auto:=true;
            param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
            value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
            If lowercase(param)='-url'      then Load_Param('url',value);
            If lowercase(param)='-psk'      then Load_Param('psk',value);
            If lowercase(param)='-json'     then Load_Param('json',value);
      end;
    Application.ProcessMessages;
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

procedure TForm1.Load_Param(aparam:string;avalue:string);
var i:integer;
begin
     if aparam='url'      then teUrl.text:=avalue;
     if aparam='psk'      then tepsk.text:=avalue;
     if aparam='json'     then teJson.text:=avalue;
end;

procedure  TForm1.Attendre;
var Ticks: DWORD;
begin
     Ticks := 0;
     while (Ticks = GetTickCount) do  Sleep(10);
end;

procedure TForm1.SendPostData;
var s:string;
    ParamList: TStringList;
    HTTP: TIdHTTP;
begin
     SetUrl(teURL.Text);
     SetPsk(tePSK.Text);
     SetJson(teJson.Text);
     SetSalt(teSalt.Text);
     HTTP := TIdHTTP.Create(nil);
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

