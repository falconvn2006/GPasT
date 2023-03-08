unit uFormaPagamentoBoleto;

interface

uses System.Classes, System.SysUtils, uFormaPagamento;

type
  TFormaPagamentoBoleto = class(TFormaPagamento)
  public
    procedure RealizarPagamento(Valor: Currency); override;
  end;

implementation

{ TFormaPagamentoBoleto }

procedure TFormaPagamentoBoleto.RealizarPagamento(Valor: Currency);
begin
  // Implemente a lógica para realizar o pagamento com boleto
end;

end.
