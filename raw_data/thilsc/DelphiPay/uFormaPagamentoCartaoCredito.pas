unit uFormaPagamentoCartaoCredito;

interface

uses System.Classes, System.SysUtils, uFormaPagamento;

type
  TFormaPagamentoCartaoCredito = class(TFormaPagamento)
  public
    NumeroCartao: string;
    DataValidade: TDateTime;
    CodigoSeguranca: string;
    procedure RealizarPagamento(Valor: Currency); override;
  end;

implementation

{ TFormaPagamentoCartaoCredito }

procedure TFormaPagamentoCartaoCredito.RealizarPagamento(Valor: Currency);
begin
  // Implemente a lógica para realizar o pagamento com Transferência
end;

end.