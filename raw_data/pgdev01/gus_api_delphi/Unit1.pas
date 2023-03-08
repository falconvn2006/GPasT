unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function WypiszPodmioty(klucz, nip: PAnsiChar): PAnsiChar; cdecl; external 'gus_api.dll';
procedure TForm1.Button1Click(Sender: TObject);
begin
  Label1.Caption := WypiszPodmioty('', PAnsiChar(Edit1.Text));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit1.Text := '7740001454';
end;

end.
