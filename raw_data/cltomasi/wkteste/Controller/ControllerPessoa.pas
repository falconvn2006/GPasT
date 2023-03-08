unit ControllerPessoa;

interface

uses
  Pessoa, Vcl.DBGrids, unDm, FireDAC.Comp.Client, SysUtils, System.Generics.Collections;

type
  TListaPessoa =  TObjectList<TPessoa>;
  TControlePessoa = class
  private

  public
    procedure ListarPessoa(pNome : string; pLista : TListaPessoa);
    procedure DadosPessoa(oPessoa : TPessoa);
    procedure BuscaIdPessoa(oPessoa: TPessoa);
    procedure InserirRegistro(oPessoa: TPessoa);
    procedure AlterarRegistro(oPessoa: TPessoa);
    function RegistroExistente(pIdPessoa: longInt): Boolean;
    procedure ExcluirPessoa(pIdPessoa: Integer);
  end;

implementation

procedure TControlePessoa.ListarPessoa(pNome : string; pLista : TListaPessoa);
var
  qListaPessoa : TFDQuery;
  x: integer;
begin
  qListaPessoa := TFDQuery.Create(nil);
  try
   qListaPessoa.Connection := DM.FDConnection;
    qListaPessoa.SQL.Add('SELECT ');
    qListaPessoa.SQL.Add('  idpessoa, ');
    qListaPessoa.SQL.Add('  nmprimeiro, ');
    qListaPessoa.SQL.Add('  nmsegundo, ');
    qListaPessoa.SQL.Add('  dtregistro ');
    qListaPessoa.SQL.Add('FROM pessoa ');
    if pNome <> '' then
    begin
      qListaPessoa.SQL.Add('WHERE upper(nmprimeiro) LIKE ''%'+UpperCase(pNome)+'%'' ');
      qListaPessoa.SQL.Add('   OR upper(nmsegundo) LIKE ''%'+UpperCase(pNome)+'%'' ');
    end;
    qListaPessoa.SQL.Add('ORDER BY idpessoa');
    qListaPessoa.Open;

    qListaPessoa.first;
    x := 0;
    while not qListaPessoa.eof do
    begin
      pLista.Add(TPessoa.Create);
      pLista[x].IdPessoa := qListaPessoa.fieldbyname('idpessoa').AsInteger;
      pLista[x].NmPrimeiro := qListaPessoa.fieldbyname('nmprimeiro').AsString;
      pLista[x].NmSegundo := qListaPessoa.fieldbyname('nmsegundo').AsString;
      pLista[x].DtRegistro := qListaPessoa.fieldbyname('dtregistro').AsDateTime;
      x := x + 1;
      qListaPessoa.next;
    end;

  finally
    qListaPessoa.Free;
  end;
end;

procedure TControlePessoa.DadosPessoa(oPessoa : TPessoa);
var
  qPessoa : TFDQuery;
begin

  qPessoa := TFDQuery.Create(nil);
  try
    qPessoa.Connection := DM.FDConnection;
    qPessoa.SQL.Add('SELECT ');
    qPessoa.SQL.Add('  idpessoa, ');
    qPessoa.SQL.Add('  dsdocumento, ');
    qPessoa.SQL.Add('  flnatureza, ');
    qPessoa.SQL.Add('  nmprimeiro, ');
    qPessoa.SQL.Add('  nmsegundo, ');
    qPessoa.SQL.Add('  dtregistro ');
    qPessoa.SQL.Add('FROM pessoa ');
    qPessoa.SQL.Add('WHERE idpessoa = :pId ');
    qPessoa.ParambyName('pId').AsInteger := oPessoa.IdPessoa;
    qPessoa.Open;

    qPessoa.first;

    oPessoa.IdPessoa := qPessoa.fieldbyname('idpessoa').AsInteger;
    oPessoa.FLNatureza := qPessoa.fieldbyname('flnatureza').AsInteger;
    oPessoa.DsDocumento := qPessoa.fieldbyname('dsdocumento').AsString;
    oPessoa.NmPrimeiro := qPessoa.fieldbyname('nmprimeiro').AsString;
    oPessoa.NmSegundo := qPessoa.fieldbyname('nmsegundo').AsString;
    oPessoa.DtRegistro := qPessoa.fieldbyname('dtregistro').AsDateTime;

  finally
    qPessoa.Free;
  end;
end;

procedure TControlePessoa.InserirRegistro(oPessoa : TPessoa);
var
  qPessoa : TFDQuery;
begin

  qPessoa := TFDQuery.Create(nil);
  try
    qPessoa.Connection := DM.FDConnection;
    qPessoa.SQL.Add('INSERT INTO public.pessoa ( ');
    qPessoa.SQL.Add('  idpessoa, ');
    qPessoa.SQL.Add('  flnatureza, ');
    qPessoa.SQL.Add('  nmprimeiro, ');
    qPessoa.SQL.Add('  dsdocumento, ');
    qPessoa.SQL.Add('  nmsegundo, ');
    qPessoa.SQL.Add('  dtregistro) ');
    qPessoa.SQL.Add('VALUES ( ');
    qPessoa.SQL.Add('  :idpessoa, ');
    qPessoa.SQL.Add('  :flnatureza, ');
    qPessoa.SQL.Add('  :nmprimeiro, ');
    qPessoa.SQL.Add('  :dsdocumento, ');
    qPessoa.SQL.Add('  :nmsegundo, ');
    qPessoa.SQL.Add('  :dtregistro) ');
    qPessoa.ParambyName('idpessoa').AsInteger := oPessoa.IdPessoa;
    qPessoa.ParambyName('flnatureza').AsInteger := oPessoa.FLNatureza;
    qPessoa.ParambyName('nmprimeiro').AsString := oPessoa.NmPrimeiro;
    qPessoa.ParambyName('nmsegundo').AsString := oPessoa.NmSegundo;
    qPessoa.ParambyName('dsdocumento').AsString := oPessoa.DsDocumento;
    qPessoa.ParambyName('dtregistro').AsDateTime := oPessoa.DtRegistro;
    qPessoa.ExecSQL;

  finally
    qPessoa.Free;
  end;
end;

procedure TControlePessoa.AlterarRegistro(oPessoa : TPessoa);
var
  qPessoa : TFDQuery;
begin

  qPessoa := TFDQuery.Create(nil);
  try
    qPessoa.Connection := DM.FDConnection;
    qPessoa.SQL.Add('UPDATE ');
    qPessoa.SQL.Add('  public.pessoa ');
    qPessoa.SQL.Add('SET ');
    qPessoa.SQL.Add('  flnatureza = :flnatureza,');
    qPessoa.SQL.Add('  dsdocumento = :dsdocumento, ');
    qPessoa.SQL.Add('  nmprimeiro = :nmprimeiro, ');
    qPessoa.SQL.Add('  nmsegundo = :nmsegundo, ');
    qPessoa.SQL.Add('  dtregistro = :dtregistro ');
    qPessoa.SQL.Add('WHERE ');
    qPessoa.SQL.Add('  idpessoa = :idpessoa ');
    qPessoa.ParambyName('idpessoa').AsInteger := oPessoa.IdPessoa;
    qPessoa.ParambyName('flnatureza').AsInteger := oPessoa.FLNatureza;
    qPessoa.ParambyName('dsdocumento').AsString := oPessoa.DsDocumento;
    qPessoa.ParambyName('nmprimeiro').AsString := oPessoa.NmPrimeiro;
    qPessoa.ParambyName('nmsegundo').AsString := oPessoa.NmSegundo;
    qPessoa.ParambyName('dtregistro').AsDateTime := oPessoa.DtRegistro;
    qPessoa.ExecSQL;
  finally
    qPessoa.Free;
  end;
end;


procedure TControlePessoa.BuscaIdPessoa(oPessoa : TPessoa);
var
  qPessoaSeq : TFDQuery;
begin

  qPessoaSeq := TFDQuery.Create(nil);
  try
    qPessoaSeq.Connection := DM.FDConnection;
    qPessoaSeq.SQL.Add('SELECT nextval(''pessoa_idpessoa_seq'') as id ; ');
    qPessoaSeq.Open;
    oPessoa.IdPessoa := qPessoaSeq.fieldbyname('id').AsInteger;

  finally
    qPessoaSeq.Free;
  end;
end;

procedure TControlePessoa.ExcluirPessoa(pIdPessoa:Integer);
var
  qPessoaDel: TFDQuery;
begin

  qPessoaDel := TFDQuery.Create(nil);
  try
    qPessoaDel.Connection := DM.FDConnection;
    qPessoaDel.SQL.Add('DELETE FROM pessoa where idpessoa = :pIdPessoa ');
    qPessoaDel.ParamByName('pIdPessoa').Asinteger := pIdPessoa;
    qPessoaDel.ExecSQL

  finally
    qPessoaDel.Free;
  end;
end;

function TControlePessoa.RegistroExistente(pIdPessoa : longInt) : Boolean;
var
  qListaPessoa : TFDQuery;
begin
  qListaPessoa := TFDQuery.Create(nil);
  try
    qListaPessoa.Connection := DM.FDConnection;
    qListaPessoa.SQL.Add('SELECT count(*) as reg ');
    qListaPessoa.SQL.Add('FROM pessoa ');
    qListaPessoa.SQL.Add('WHERE idpessoa = :pidPessoa ');
    qListaPessoa.ParambyName('pidPessoa').AsInteger := pIdPessoa;
    qListaPessoa.Open;

  finally
    Result := qListaPessoa.FieldByName('reg').AsInteger > 0;
    qListaPessoa.Free;
  end;
end;

end.
