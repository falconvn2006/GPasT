unit uFormaPagamento;

interface

uses System.Classes, System.SysUtils;

type
  TFormaPagamento = class abstract
  public
    procedure RealizarPagamento(Valor: Currency); virtual; abstract;
  end;

implementation

end.