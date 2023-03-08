unit ControllerEndereco;

interface

uses
  Endereco, unDm, FireDAC.Comp.Client;

type
  TControleEndereco = class
  private


  public
    procedure DadosEndereco(pEndereco: TEndereco);
    procedure AlterarRegistro(oEndereco: TEndereco);
    procedure InserirRegistro(oEndereco: TEndereco);
    function RegistroExistente(pIdPessoa: longInt): Boolean;
  end;

implementation

procedure TControleEndereco.DadosEndereco(pEndereco : TEndereco);
var
  qEndereco : TFDQuery;
begin
  qEndereco := TFDQuery.Create(nil);
  try
    qEndereco.Connection := DM.FDConnection;
    qEndereco.SQL.Add('SELECT ');
    qEndereco.SQL.Add('  idendereco,');
    qEndereco.SQL.Add('  idpessoa, ');
    qEndereco.SQL.Add('  dscep');
    qEndereco.SQL.Add('FROM  ');
    qEndereco.SQL.Add('  public.endereco  ');
    qEndereco.SQL.Add('WHERE idpessoa =:pidpessoa  ');
    qEndereco.Parambyname('pidpessoa').AsInteger := pEndereco.IdPessoa;
    qEndereco.Open;
    pEndereco.IdEndereco := qEndereco.fieldbyname('idendereco').AsInteger;
    pEndereco.DsCep := qEndereco.fieldbyname('dscep').AsString;
  finally
    qEndereco.Free;
  end;
end;

procedure TControleEndereco.InserirRegistro(oEndereco : TEndereco);
var
  qEndereco : TFDQuery;
begin

  qEndereco := TFDQuery.Create(nil);
  try
    qEndereco.Connection := DM.FDConnection;
    qEndereco.SQL.Add('INSERT INTO public.endereco ( ');
    qEndereco.SQL.Add('  idendereco, ');
    qEndereco.SQL.Add('  idpessoa, ');
    qEndereco.SQL.Add('  dscep) ');
    qEndereco.SQL.Add('VALUES ( ');
    qEndereco.SQL.Add('  :idendereco, ');
    qEndereco.SQL.Add('  :idpessoa, ');
    qEndereco.SQL.Add('  :dscep) ');
    qEndereco.ParambyName('idendereco').AsInteger := oEndereco.IdEndereco;
    qEndereco.ParambyName('idpessoa').AsInteger := oEndereco.IdPessoa;
    qEndereco.ParambyName('dscep').AsString := oEndereco.DsCep;
    qEndereco.ExecSQL;

  finally
    qEndereco.Free;
  end;
end;

procedure TControleEndereco.AlterarRegistro(oEndereco : TEndereco);
var
  qEndereco : TFDQuery;
begin

  qEndereco := TFDQuery.Create(nil);
  try
    qEndereco.Connection := DM.FDConnection;
    qEndereco.SQL.Add('UPDATE ');
    qEndereco.SQL.Add('  public.endereco ');
    qEndereco.SQL.Add('SET ');
    qEndereco.SQL.Add('  idendereco = :idendereco,');
    qEndereco.SQL.Add('  dscep = :dscep ');
    qEndereco.SQL.Add('WHERE ');
    qEndereco.SQL.Add('  idpessoa = :idpessoa ');
    qEndereco.ParambyName('idpessoa').AsInteger := oEndereco.IdPessoa;
    qEndereco.ParambyName('idendereco').AsInteger := oEndereco.IdEndereco;
    qEndereco.ParambyName('dscep').AsString := oEndereco.DsCep;
    qEndereco.ExecSQL;
  finally
    oEndereco.Free;
  end;
end;

function TControleEndereco.RegistroExistente(pIdPessoa : longInt) : Boolean;
var
  qEndereco: TFDQuery;
begin
  qEndereco := TFDQuery.Create(nil);
  try
    qEndereco.Connection := DM.FDConnection;
    qEndereco.SQL.Add('SELECT count(*) as reg ');
    qEndereco.SQL.Add('FROM endereco ');
    qEndereco.SQL.Add('WHERE IdPessoa = :pIdPessoa ');
    qEndereco.ParambyName('pIdPessoa').AsInteger := pIdPessoa;
    qEndereco.Open;

  finally
    Result := qEndereco.FieldByName('reg').AsInteger > 0;
    qEndereco.Free;
  end;
end;


end.
