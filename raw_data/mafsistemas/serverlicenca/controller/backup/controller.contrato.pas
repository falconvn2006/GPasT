unit controller.contrato;

{$mode Delphi}

interface

uses
  Classes, SysUtils,
  Horse,
  dao.contrato,
  udmglobal;


procedure RegistrarRotas;
procedure BuscarContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure ListarContratos(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure CadastrarContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure EditarContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure ExcluirContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);


implementation

procedure RegistrarRotas;
begin
  THorse.Get('contrato/:id', BuscarContrato);
  THorse.Get('contrato', ListarContratos);
  THorse.Post('contrato', CadastrarContrato);
  THorse.Put('contrato/:id', EditarContrato);
  THorse.Delete('contrato/:id', ExcluirContrato);
end;

procedure BuscarContrato(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
begin

end;

procedure ListarContratos(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
var
   contrato: TContrato;
begin
    try
      try
        contrato := TContrato.Create(DmGlobal.Conexao);
        res.Send<TJSONArray>(contrato.ListarContratos).Status(200);
      except on ex:exception do
        res.Send(ex.message).Status(500);
      end;
    finally
       FreeAndNil( contrato );
    end;
end;

procedure CadastrarContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
begin

end;

procedure EditarContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
begin

end;

procedure ExcluirContrato(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
begin

end;

end.

