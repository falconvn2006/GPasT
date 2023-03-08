unit server.routers.pessoas;

interface

implementation

uses

  server.controller.interfaces,
  server.controller.factory,
  System.SysUtils,
  server.model.exceptions,
  System.JSON,
  server.provider.core;

  function ValidarID(LID : String) : int64;
  begin
    if not (TryStrToInt64(LID, Result)) then
    begin
      raise EProviderException.New.Status(404).Error('Cadastro não encontrado');
    end;
  end;

  procedure DoGetPessoas(AReq: TProviderRequest; ARes: TProviderResponse);
  var
    LController : iController;
  begin
    LController := TController.New;
    Ares.Body := LController.Pessoa.Services.ListarTodos.ListAsJSONArray;
    Ares.ResultStatusCode := 200;
  end;

  procedure DoPostPessoas(AReq: TProviderRequest; ARes: TProviderResponse);
  var
    LController : iController;
  begin
    LController := TController.New;
    Ares.Body := LController.Pessoa.JsonStringToObject(AReq.Body).Services.Inserir.EntityAsJSONObject;
    Ares.ResultStatusCode := 201;
  end;

  procedure DoDeletePessoas(AReq: TProviderRequest; ARes: TProviderResponse);
  var
    LController : iController;
    LID : int64;
  begin
    LID := ValidarID(AReq.Params[0]);
    LController := TController.New;
    if LController.Pessoa.Services.ListarPorID(LID).IsEmpty then
    begin
      raise EProviderException.New.Status(404).Error('Cadastro não encontrado');
    end;
    LController.Pessoa.Services.Excluir;
    ARes.ResultStatusCode := 204;
  end;

  procedure DoGetPessoasID(AReq: TProviderRequest; ARes: TProviderResponse);
  var
    LController : iController;
    LID : int64;
  begin
    LID := ValidarID(AReq.Params[0]);
    LController := TController.New;
    if LController.Pessoa.Services.ListarPorID(LID).IsEmpty then
    begin
      raise EProviderException.New.Status(404).Error('Cadastro não encontrado');
    end;

    ARes.Body := LController.Pessoa.Services.EntityAsJSONObject;
    ARes.ResultStatusCode := 200;
  end;

  procedure DoPutPessoas(AReq: TProviderRequest; ARes: TProviderResponse);
  var
    LController : iController;
    LID : int64;
    JSONBody : TJSONObject;
  begin
    LID := ValidarID(AReq.Params[0]);
    LController := TController.New;
    if LController.Pessoa.Services.ListarPorID(LID).IsEmpty then
    begin
      raise EProviderException.New.Status(404).Error('Cadastro não encontrado');
    end;
    JSONBody := TJSONobject.ParseJSONValue(AReq.body) as TJSONObject;
    try
      if JSONBody.Get('id') <> nil then
        JSONBody.RemovePair('id');

      JSONBody.AddPair('id', LID.ToString);
      LController.Pessoa.JsonStringToObject(JSONBody.ToString).Services.Alterar;
    finally
      JSONBody.Free;
    end;

    ARes.ResultStatusCode := 204;
  end;

  procedure DoPostPessoasLote(AReq: TProviderRequest; ARes: TProviderResponse);
  var
    LController : iController;
  begin
    LController := TController.New;
    LController.Pessoa.JsonArrayStringToList(AReq.Body).Services.InserirLote;
    Ares.ResultStatusCode := 204;
  end;

  procedure Registry();
  begin
    TProvider
      .Routes
        .Get('/pessoas', DoGetPessoas)
        .Get('/pessoas/:ID', DoGetPessoasID)
        .Post('/pessoas', DoPostPessoas)
        .Post('/pessoas/lote', DoPostPessoasLote)
        .Delete('/pessoas/:ID', DoDeletePessoas)
        .Put('/pessoas/:ID', DoPutPessoas);
  end;
  initialization
  Registry;
end.
