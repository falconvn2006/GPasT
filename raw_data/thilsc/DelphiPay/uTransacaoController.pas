unit uTransacaoController;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, MVCFramework;

type
  [MVCPath('/transacao')]
  TTransacaoController = class(TMVCController)
  public
    [MVCPost('/realizar')]
    procedure RealizarTransacao;
    [MVCPost('/confirmar')]
    procedure ConfirmarTransacao;
    [MVCPost('/estornar')]
    procedure EstornarTransacao;
  end;

implementation

uses
  TransacaoService, MVCFramework.Commons;

procedure TTransacaoController.RealizarTransacao;
var
  Transacao: TTransacao;
begin
  try
    Transacao := TTransacaoService.RealizarTransacao;
    Render<TTransacao>(Transacao);
  except
    on E: Exception do
      Render(HTTP_STATUS.BadRequest, E.Message);
  end;
end;

procedure TTransacaoController.ConfirmarTransacao;
var
  ID: Integer;
begin
  try
    ID := StrToInt(Context.Request.BodyAsString);
    TTransacaoService.ConfirmarTransacao(ID);
    Render(HTTP_STATUS.OK);
  except
    on E: Exception do
      Render(HTTP_STATUS.BadRequest, E.Message);
  end;
end;

procedure TTransacaoController.EstornarTransacao;
var
  ID: Integer;
begin
  try
    ID := StrToInt(Context.Request.BodyAsString);
    TTransacaoService.EstornarTransacao(ID);
    Render(HTTP_STATUS.OK);
  except
    on E: Exception do
      Render(HTTP_STATUS.BadRequest, E.Message);
  end;
end;

end.
