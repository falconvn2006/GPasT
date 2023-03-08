unit Controller.Pessoa;

interface

uses Horse, System.JSON, System.SysUtils, Model.Pessoa,
     FireDAC.Comp.Client, Data.DB, DataSet.Serialize;

procedure Pessoa;
procedure ListarPessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListarPessoaID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure InserirPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ExcluirPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure AlterarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure InserirPessoaLote(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

uses
  System.Classes;

procedure Pessoa;
begin
  THorse.Get('/pessoa', ListarPessoas);
  THorse.Get('/pessoa/:id', ListarPessoaID);
  THorse.Get('/pessoa/nome/:id', ListarPessoaID);
  THorse.Get('/pessoa/nome', ListarPessoaID);
  THorse.Post('/pessoa', InserirPessoa);
  THorse.Post('/pessoa/insertlote', InserirPessoaLote);
  THorse.Put('/pessoa', AlterarPessoa);
  THorse.Delete('/pessoa/:id', ExcluirPessoa);
end;

procedure ListarPessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  pessoa : TPessoa;
  qry : TFDQuery;
  erro : string;
  arrayPessoas : TJSONArray;
begin
  try
    pessoa := TPessoa.Create;
  except
    res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    qry := pessoa.ListarPessoa('', erro);

    arrayPessoas := qry.ToJSONArray();
    res.Send<TJSONArray>(arrayPessoas);
  finally
    qry.Free;
    pessoa.Free;
  end;
end;

procedure ListarPessoaID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  pessoa : TPessoa;
//  objPessoas: TJSONObject;
  arrayPessoas : TJSONArray;
  qry : TFDQuery;
  erro : string;
begin
  try
    pessoa := TPessoa.Create;

    if (StrToIntDef(Req.Params['id'], 0) > 0) then
      pessoa.idpessoa   := Req.Params['id'].ToInteger
    else
      pessoa.nmprimeiro := Req.Params['id'];
  except
    res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    qry := pessoa.ListarPessoa('', erro);

    if qry.RecordCount > 0 then
    begin
      arrayPessoas := qry.ToJSONArray();
      res.Send<TJSONArray>(arrayPessoas);
    end
    else
      res.Send('Pessoa não encontrada').Status(404);
  finally
    qry.Free;
    pessoa.Free;
  end;

//  try
//    qry := pessoa.ListarPessoa('', erro);
//
//    if qry.RecordCount > 0 then
//    begin
//      objPessoas := qry.ToJSONObject;
//      res.Send<TJSONObject>(objPessoas)
//    end
//    else
//      res.Send('Pessoa não encontrada').Status(404);
//  finally
//    qry.Free;
//    pessoa.Free;
//  end;
end;

procedure InserirPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  pessoa : TPessoa;
  objCliente: TJSONObject;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    pessoa := TPessoa.Create;
  except
    res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

      pessoa.flnatureza  := body.GetValue<integer>('flnatureza', 0);
      pessoa.dsdocumento := body.GetValue<string>('dsdocumento', '');
      pessoa.nmprimeiro  := body.GetValue<string>('nmprimeiro', '');
      pessoa.nmsegundo   := body.GetValue<string>('nmsegundo', '');
      pessoa.dtregistro  := body.GetValue<TDate>('dtregistro', now);
      pessoa.dscep       := body.GetValue<string>('dscep', '');
      pessoa.Inserir(erro);

      body.Free;

      if erro <> '' then
          raise Exception.Create(erro);
    except on ex:exception do
      begin
        res.Send(ex.Message).Status(400);
        exit;
      end;
    end;

    objCliente := TJSONObject.Create;
    objCliente.AddPair('idpessoa', pessoa.idpessoa.ToString);

    res.Send<TJSONObject>(objCliente).Status(201);
  finally
    pessoa.Free;
  end;
end;

procedure ExcluirPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  pessoa : TPessoa;
  objPessoa: TJSONObject;
  erro : string;
begin
  // Conexao com o banco...
  try
    pessoa := TPessoa.Create;
  except
    res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      pessoa.idpessoa := Req.Params['id'].ToInteger;

      if NOT pessoa.Excluir(erro) then
          raise Exception.Create(erro);
    except on ex:exception do
      begin
        res.Send(ex.Message).Status(400);
        exit;
      end;
    end;

    objPessoa := TJSONObject.Create;
    objPessoa.AddPair('idpessoa', pessoa.idpessoa.ToString);

    res.Send<TJSONObject>(objPessoa);
  finally
    pessoa.Free;
  end;
end;

procedure AlterarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  pessoa : TPessoa;
  objPessoa: TJSONObject;
  erro : string;
  body : TJsonValue;
begin
  // Conexao com o banco...
  try
    pessoa := TPessoa.Create;
  except
    res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

      pessoa.idpessoa    := body.GetValue<integer>('idpessoa', 0);
      pessoa.flnatureza  := body.GetValue<integer>('flnatureza', 0);
      pessoa.nmprimeiro  := body.GetValue<string>('nmprimeiro', '');
      pessoa.nmsegundo   := body.GetValue<string>('nmsegundo', '');
      pessoa.dsdocumento := body.GetValue<string>('dsdocumento', '');
      pessoa.dtregistro  := body.GetValue<TDate>('dtregistro', now);
      pessoa.dscep       := body.GetValue<string>('dscep', '');

      pessoa.Alterar(erro);

      body.Free;

      if erro <> '' then
        raise Exception.Create(erro);

    except on ex:exception do
      begin
        res.Send(ex.Message).Status(400);
        exit;
      end;
    end;

    objPessoa := TJSONObject.Create;
    objPessoa.AddPair('idpessoa', pessoa.idpessoa.ToString);

    res.Send<TJSONObject>(objPessoa).Status(200);
  finally
    pessoa.Free;
  end;
end;

procedure InserirPessoaLote(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  pessoa : TPessoa;
  objPessoa: TJSONObject;
  flnatureza : Integer;
  dtregistro : TDate;
  dsdocumento, nmprimeiro,
  nmsegundo, dscep,
  erro : string;
  ListaArray : TJSONArray;
  body  : TJsonValue;
  I: Integer;
  ListaInsert : TStringList;
begin
  // Conexao com o banco...
  try
    pessoa := TPessoa.Create;
  except
    res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      ListaInsert := TStringList.Create;
      ListaArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONArray;

      for body in ListaArray do
      begin
        flnatureza  := body.GetValue<integer>('flnatureza', 0);
        dsdocumento := body.GetValue<string>('dsdocumento', '');
        nmprimeiro  := body.GetValue<string>('nmprimeiro', '');
        nmsegundo   := body.GetValue<string>('nmsegundo', '');
        dtregistro  := body.GetValue<TDate>('dtregistro', now);
        dscep       := body.GetValue<string>('dscep', '');

        ListaInsert.Add('INSERT INTO PESSOA (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) Values ('+IntToStr(flnatureza)+', '+QuotedStr(dsdocumento)+','+QuotedStr(nmprimeiro)+','+QuotedStr(nmsegundo)+','+QuotedStr(FormatDateTime('yyyy-mm-dd', dtregistro))+') returning idpessoa as idpessoa ');
        ListaInsert.Add('INSERT INTO ENDERECO (idpessoa, dscep) Values (:idpessoa, '+QuotedStr(dscep)+')');
      end;

      pessoa.InsertLote(ListaInsert, erro);

      body.Free;

      if erro <> '' then
        raise Exception.Create(erro)
      else
        res.Send(IntToStr(ListaArray.Count)+' pessoas inseridas com sucesso!').Status(200);
    except on ex:exception do
      begin
        res.Send(ex.Message).Status(400);
        exit;
      end;
    end;
  finally
    pessoa.Free;
  end;
end;

end.
