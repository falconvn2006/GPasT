unit uFormaPagamentoTransferencia;

interface

uses System.Classes, System.SysUtils, uFormaPagamento;

type
  TFormaPagamentoTransferencia = class(TFormaPagamento)
  public
    Banco: string;
    Agencia: string;
    Conta: string;
    procedure RealizarPagamento(Valor: Currency); override;
  end;

implementation

{ TFormaPagamentoTransferencia }

procedure TFormaPagamentoTransferencia.RealizarPagamento(Valor: Currency);
begin
  // Implemente a lógica para realizar o pagamento com Transferência
end;

end.