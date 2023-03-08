unit untServidor;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  IPPeerServer,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TfrmServidor = class(TForm)
    lblPorta: TLabel;
    edtPorta: TEdit;
    btnConectar: TButton;
    procedure btnConectarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmServidor: TfrmServidor;

implementation

{$R *.dfm}

uses ServerContainerUnit1;

procedure TfrmServidor.btnConectarClick(Sender: TObject);
begin
  if btnConectar.Caption = 'Conectar' then
  begin
    ServerContainer1.DSTCPServerTransport1.Port := StrToInt(edtPorta.Text);
    ServerContainer1.DSServer1.Start;
    if ServerContainer1.DSServer1.Started then
      btnConectar.Caption := 'Desconectar';
  end
  else
  ServerContainer1.DSServer1.Stop;
  if not ServerContainer1.DSServer1.Started then
      btnConectar.Caption := 'Conectar';
end;

end.

