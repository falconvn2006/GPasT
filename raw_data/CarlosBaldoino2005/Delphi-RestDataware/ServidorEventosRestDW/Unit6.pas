unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDWAbout, uRESTDWBase, Vcl.StdCtrls;

type
  TForm6 = class(TForm)
    Button1: TButton;
    RESTServicePooler1: TRESTServicePooler;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses
  Unit1;

{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
begin
  RESTServicePooler1.ServerMethodClass := TDataModule1;
  RESTServicePooler1.Active := not RESTServicePooler1.Active;
end;

end.
