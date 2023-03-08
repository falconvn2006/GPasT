unit UdpServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Sockets, Buttons, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPServer, UdpClient, IDSocketHandle;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    IdUDPServer1: TIdUDPServer;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  UdpClient: TForm2;
  MessageText: string;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  UdpClient := TForm2.Create(Application);
  UdpClient.Show;
end;

procedure TForm1.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  Rec: string;
begin
  SetLength(Rec, AData.Size);
  AData.Read(Rec[1], AData.Size);
  Memo1.Text := Memo1.Text + 'Client(' + IntToStr(ABinding.Handle) + '): ' + Rec + #13#10;
end;

end.
