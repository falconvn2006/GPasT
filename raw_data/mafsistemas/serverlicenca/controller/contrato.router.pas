unit contrato.router;

{$mode Delphi}

interface

uses
  Classes, SysUtils,
  Horse,
  fpjson,
  contrato.service;


procedure RegistrarRotas;
procedure ListarContratos(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure GetChaveSistema(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure GetBoletosContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure GetMensagensContrato(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
procedure BaixaBoleto(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
procedure RegistraLOGs(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);

procedure CadastrarContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure EditarContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
procedure ExcluirContrato(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);


implementation

procedure RegistrarRotas;
begin
  THorse.Get('contrato/:cnpj', GetChaveSistema);
  THorse.Get('contrato/boletos/:cnpj', GetBoletosContrato);
  THorse.Get('contrato/boletos/baixa/:sequencia', BaixaBoleto);
  THorse.Get('contrato/mensagens/:cnpj', GetMensagensContrato);
  THorse.Post('contrato', RegistraLOGs);


  THorse.Get('contrato', ListarContratos);
  THorse.Post('contrato', CadastrarContrato);
  THorse.Put('contrato/:id', EditarContrato);
  THorse.Delete('contrato/:id', ExcluirContrato);
end;

procedure GetChaveSistema(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
var
   contrato : TContratoService;
begin
  try
    try
      contrato := TContratoService.Create();
      res.Send<TJSONArray>(contrato.GetChaveContrato(Req.Params.Items['cnpj'])).Status(200);
    except on ex:exception do
      res.Send(ex.message).Status(500);
    end;
  finally
     FreeAndNil( contrato );
  end;
end;

procedure GetBoletosContrato(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
var
   contrato : TContratoService;
begin
  try
    try
      contrato := TContratoService.Create();
      res.Send<TJSONArray>(contrato.GetBoletosContrato(Req.Params.Items['cnpj'])).Status(200);
    except on ex:exception do
      res.Send(ex.message).Status(500);
    end;
  finally
     FreeAndNil( contrato );
  end;
end;

procedure GetMensagensContrato(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
var
   contrato : TContratoService;
begin
  try
    try
      contrato := TContratoService.Create();
      res.ContentType('application/json').Send<TJSONArray>(contrato.GetMensagensContrato(Req.Params.Items['cnpj'])).Status(200);
    except on ex:exception do
      res.Send(ex.message).Status(500);
    end;
  finally
     FreeAndNil( contrato );
  end;
end;

procedure BaixaBoleto(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
var
   contrato: TContratoService;
begin
  try
    try
      contrato := TContratoService.Create();
      res.Send(contrato.BaixaBoletoContrato(Req.Params.Items['sequencia'])).Status(200);
    except on ex:exception do
      res.Send(ex.message).Status(500);
    end;
  finally
     FreeAndNil( contrato );
  end;
end;

procedure RegistraLOGs(Req: THorseRequest; Res: THorseResponse; aNext: TNextProc);
var
   CodCli, DataPC, Funcao, Versao : String;
   body: TJSONObject;
   contrato: TContratoService;
begin
  try
      try
        body := Req.Body<TJSONObject>;
        CodCli := body.Get('codcli');
        DataPC := body.Get('datapc');
        Funcao := body.Get('funcao');
        Versao := body.Get('versao');

        contrato := TContratoService.Create();
        res.ContentType('application/json;charset=UTF-8').Send(contrato.RegistarLogs(Codcli, Funcao, DataPc, Versao) + 'Retorno '+ funcao).Status(200);
      except on ex:exception do
        res.Send(ex.message).Status(500);
      end;
    finally
      // FreeAndNil( contrato );
    end;
end;

procedure ListarContratos(Req: THorseRequest; Res: THorseResponse;  aNext: TNextProc);
var
   contrato: TContratoService;
begin
  try
    try
      contrato := TContratoService.Create();
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

