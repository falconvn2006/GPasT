unit Email;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdSMTP, IdMessage, IdSSLOpenSSL,
  IdExplicitTLSClientServerBase, IdText, IdAttachmentFile, System.StrUtils,
  Vcl.ComCtrls, RichEdit, Vcl.OleCtrls;

type
  TFEmail = class(TForm)
    Resp: TMemo;
    RichEdit1: TRichEdit;
  private
    { Private declarations }
  public
    function EnviarEmail(aServidor, aUsuario, aSenha, aPorta,
      aEmailRemetente, aNomeRemetente, aEmailsDestinatarios, aAssunto, aMensagem, aAnexos: string;
      aUsarHtml, aUsarAutenticacao: boolean; aQtdTentativas: integer): boolean;
  end;

var
  FEmail: TFEmail;

implementation

{$R *.dfm}

function TFEmail.EnviarEmail(aServidor, aUsuario, aSenha, aPorta,
  aEmailRemetente, aNomeRemetente, aEmailsDestinatarios, aAssunto, aMensagem, aAnexos: string;
  aUsarHtml, aUsarAutenticacao: boolean; aQtdTentativas: integer): boolean;
var
  _IdSmtp: TidSMTP;
  _IdMessage: TIdMessage;
  _IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  _Anexo: TStringList;
  _i: Integer;
begin
  Result := False;

  _IdSmtp    := TIdSMTP.Create(nil);
  _IdMessage := TIdMessage.Create(nil);
  _IdSSL     := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try

    try
      //Configurar Servidor e Usuário
      _IdSmtp.AuthType  := satDefault; //Login
      _IdSmtp.Host      := aServidor;
      _IdSmtp.Password  := aSenha;
      _IdSmtp.Username  := aUsuario;
      _IdSmtp.IOHandler := _IdSSL;

      //Configurar Porta
      if StrToIntDef(aPorta,0) <> 0 then
        _IdSmtp.Port    := StrToInt(aPorta)
      else
      begin
        if aUsarAutenticacao then
          _IdSmtp.Port  := 465
        else
          _IdSmtp.Port  := 25;
      end;

      if not aUsarAutenticacao then
        _IdSmtp.UseTLS := utNoTLSSupport
      else
        _IdSmtp.UseTLS := utUseRequireTLS;
      //IdSmtp.UseTLS -> existem ainda utUseImplicitTLS e utUseExplicitTLS

      //Configurar Timeout -> nesse exemplo deixamos 10 segundos
      _IdSmtp.ConnectTimeout := 10000;
      _IdSmtp.ReadTimeout    := 10000;

      _IdSSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
      _IdSSL.SSLOptions.Mode := sslmUnassigned;

      //Configurar mensagem
      _IdMessage.Clear;
      _IdMessage.MessageParts.Clear;
      _IdMessage.From.Address := aEmailRemetente;
      _IdMessage.From.Name    := aNomeRemetente;
      _IdMessage.Subject      := aAssunto;

      if aUsarHtml then
      begin
        with TIdText.Create(_IdMessage.MessageParts, nil) do
        begin
          Body.Text := aMensagem;
          ContentType := 'text/html';
          CharSet := 'ISO-8859-1';
        end;
      end
      else
        _IdMessage.Body.Text := aMensagem;

      _IdMessage.Recipients.EMailAddresses := aEmailsDestinatarios;

      {
      _IdMessage.BccList.EMailAddresses := 'adicionar aqui os emails'; //Se for usar BccList
      _IdMessage.ccList.EMailAddresses := 'adicionar aqui os emails'; //Se for usar ccList
      }

      //Configurar os Anexos
      _Anexo := TStringList.Create;
      try
        _Anexo.Text := Trim(aAnexos);
        for _i := 0 to _Anexo.Count - 1 do
          TIdAttachmentFile.Create(_IdMessage.MessageParts, _Anexo.Strings[_i]);
      finally
        _Anexo.Free
      end;

      if not _IdSmtp.Connected then
      begin
        for _i := 0 to aQtdTentativas - 1 do
        begin
          //Realizando tentativas de conexão
          try
            _IdSmtp.Connect();
            _IdSmtp.Authenticate();
            //Conexão com servidor estabelecida com sucesso.
            Break;
          except on e: Exception do
            begin
              if (_i = aQtdTentativas -1) then
                raise;
              if AnsiContainsText(e.Message, 'Username and Password not accepted') then
                raise;
            end;
          end;
        end;
      end;

      if _IdSmtp.Connected then
      begin
        //Enviando Email
        if aUsarHtml then
        begin
          _IdMessage.ContentType := 'multipart/mixed';
          _IdMessage.IsEncoded := True;
          _IdMessage.Encoding := meDefault;
          _IdMessage.CharSet := 'UTF-8';
        end
        else
        begin
          _IdMessage.Encoding := meDefault;
          _IdMessage.CharSet := 'ISO-8859-1';
        end;

        for _i := 0 to aQtdTentativas - 1 do
        begin
          //Realizando tentativas de envio de e-mail
          try
            _IdSmtp.Send(_IdMessage);
            //E-mail enviado com sucesso.
            Result := True;
            Break;
          except on e: Exception do
            if (_i = aQtdTentativas -1) then
              raise;
          end;
        end;
      end;
    except
      on e : Exception do
        raise Exception.Create('Erro ao enviar email - ' + e.Message);
    end;
  finally
    //Encerra conexão com Servidor
    _IdSmtp.Disconnect;

    _IdSmtp.Free;
    _IdMessage.Free;
    _IdSSL.Free;
  end;
end;



end.
