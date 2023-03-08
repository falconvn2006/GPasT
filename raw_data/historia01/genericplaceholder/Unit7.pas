unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.OleCtrls, SHDocVw;

type
  TAyuda = class(TForm)
    WebBrowser1: TWebBrowser;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    //procedure OpenUrl;
  public
    { Public declarations }
  end;

var
  Help: TAyuda;

implementation

uses Unit1;

{$R *.dfm}

procedure TAyuda.Button1Click(Sender: TObject);
begin
  Help.Hide;
  Form1.Show;
end;
procedure TAyuda.Button2Click(Sender: TObject);
begin
  WebBrowser1.Navigate('https://historia01.github.io/schoolprojecthelp/');
end;
procedure TAyuda.FormCreate(Sender: TObject);
begin
  WebBrowser1.Navigate('https://historia01.github.io/schoolprojecthelp/');
end;

end.
