unit UfrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmPrincipal = class(TForm)
    edtDestinario: TEdit;
    edtAssunto: TEdit;
    mmMenssagem: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnEnviar: TButton;
    procedure btnEnviarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UConsts,
  IdSMTP,
  IdMessage,
  IdSSLOpenSSL,
  IdExplicitTLSClientServerBase;

{$R *.dfm}

procedure TfrmPrincipal.btnEnviarClick(Sender: TObject);
var
  xSMTP: TIdSMTP;
  xMessage: TIdMessage;
  xSocketSSL : TIdSSLIOHandlerSocketOpenSSL;
begin

  try
    xSMTP := TIdSMTP.Create;
    xMessage := TIdMessage.Create;
    xSocketSSL := TIdSSLIOHandlerSocketOpenSSL.Create;

    xSocketSSL.SSLOptions.Mode := sslmClient;
    xSocketSSL.SSLOptions.Method := sslvTLSv1_2;

    xSocketSSL.Host := SMTP;
    xSocketSSL.Port := PORTA;

    xSMTP.IOHandler := xSocketSSL;
    xSMTP.Host := SMTP;
    xSMTP.Port := PORTA;
    xSMTP.AuthType := satDefault;
    xSMTP.Username := EMAIL;
    xSMTP.Password := PASSWORD;
    xSMTP.UseTLS := utUseExplicitTLS;

    xMessage.From.Address := edtDestinario.Text;
    xMessage.Recipients.Add;
    xMessage.Recipients.Items[0].Address := edtDestinario.Text;
    xMessage.Subject := edtAssunto.Text;
    xMessage.Body.Add(mmMenssagem.Text);

    try
      xSMTP.Connect;
      xSMTP.Send(xMessage);
      showMessage('Menssagem enviada com sucesso');
    except on E: Exception do
      raise Exception.Create('Erro ao enviar email: ' + E.Message);
    end;

  finally
    FreeAndNil(xSMTP);
    FreeAndNil(xMessage);
    FreeAndNil(xSocketSSL);
  end;

end;

end.
