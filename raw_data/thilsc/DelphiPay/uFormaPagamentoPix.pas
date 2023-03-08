unit uFormaPagamentoPix;

interface

uses System.Classes, System.SysUtils, uFormaPagamento;

type
  TFormaPagamentoPix = class(TFormaPagamento)
  public
    TipoChave: ShortInt;
    Chave: string;
    procedure RealizarPagamento(Valor: Currency); override;
  end;

implementation

{ TFormaPagamentoPix }

procedure TFormaPagamentoPix.RealizarPagamento(Valor: Currency);
begin
  // Implemente a lógica para realizar o pagamento com Pix
end;

end.