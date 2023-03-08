unit uTransacao;

interface

uses System.Classes, System.SysUtils;

type
  TTransacao = class
  private
    FFormaPagamento: TFormaPagamento;
  public
    constructor Create(AFormaPagamento: TFormaPagamento);
    procedure RealizarTransacao(Valor: Currency);
  end;

implementation

constructor TTransacao.Create(AFormaPagamento: TFormaPagamento);
begin
  FFormaPagamento := AFormaPagamento;
end;

procedure TTransacao.RealizarTransacao(Valor: Currency);
begin
  FFormaPagamento.RealizarPagamento(Valor);
end;

end.