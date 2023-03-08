unit Unit16;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uLog, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.OleCtrls, SHDocVw;

type
  TForm15 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form15: TForm15;

implementation

{$R *.dfm}

procedure TForm15.Button1Click(Sender: TObject);
var
  Flags, TargetFrameName, PostData, Headers: OleVariant;

begin
(*   Log.Log('TESTR', Log.Ref, Log.Mag, 'Download', 'blabla', logInfo, True, 0, ltServer);
   Log.Close;
   Timer1.Enabled:=true;
*)


    WebBrowser1.Navigate('https://microsoft.github.io/PowerBI-JavaScript/demo/v2-demo/index.html', Flags, TargetFrameName, PostData, Headers);


end;

procedure TForm15.FormCreate(Sender: TObject);
begin
    Log.App   := 'Delos2Easy';
    Log.Inst  := '' ;
    Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue] ;
    Log.SendOnClose := true ;
    Log.Open ;
    Log.SendLogLevel := logTrace;
    Log.Mag   := 'TEST';
    Log.Ref   := 'TEST';
    Log.Log('TESTR', Log.Ref, Log.Mag, 'Download', 'Lancement', logNotice, True, 0, ltServer);
end;

procedure TForm15.Timer1Timer(Sender: TObject);
begin
    Timer1.Enabled:=False;
    Application.Terminate;
end;

end.
