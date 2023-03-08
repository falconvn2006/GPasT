unit UdpClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient,
  Buttons;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Button2: TButton;
    Label2: TLabel;
    IdUDPClient1: TIdUDPClient;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  MessageText: string;

implementation

{$R *.dfm}

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;    
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  MessageText := Edit1.Text;
  IdUDPClient1.Send(MessageText);
  Memo1.Text := Memo1.Text + 'Me: ' + MessageText + #13#10;
  Edit1.Text := '';
end;

end.
