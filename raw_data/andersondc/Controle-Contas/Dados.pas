unit Dados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, StrUtils,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFDados = class(TDataModule)
    Conexao: TFDConnection;
    Trans: TFDTransaction;
    dsQryAux: TDataSource;
    QryAux: TFDQuery;
    SQLiteDriverLink: TFDPhysSQLiteDriverLink;
    QryAux2: TFDQuery;
    dsQryAux2: TDataSource;
    Bancos: TFDQuery;
    dsBancos: TDataSource;
    Cartoes: TFDQuery;
    dsCartoes: TDataSource;
    Contas: TFDQuery;
    dsContas: TDataSource;
  private
    { Private declarations }
  public
    procedure ConfigurarDados(vDiretorio: string);
    procedure CadastraBanco(nome: string; agencia: string; conta: string; saldo: string);
    procedure AtualizaBanco(id: integer; nome: string; agencia: string; conta: string; saldo: string);

    procedure CadastraCartao(nome: string; ncartao: string; limite: string; banco: string; vencimento: string; jurosano: string; jurosatraso: string; imagem: string);
    procedure AtualizaCartao(id: integer; nome: string; limite: string; ncartao: string; banco: string; vencimento: string; jutosano: string; jurosatraso: string; imagem: string);

    procedure CadastraConta(descricao: string; tipopagamento: string; datapagamento: string; valor: string; valorparcela: string; parcelas: string; cartao: string; pago: string);

    procedure Excluir(id: integer; tabela: string);
    function Id(opcao: integer): string;
    procedure AtualizaTabela(tabela: string);
    procedure LocalizarID(vid: string; tabela: string);

    function SaldoTotal: string;
    function SaldoBancos: string;
  end;

var
  FDados: TFDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

// Configura Conexões com o Banco de Dados SQLite
procedure TFDados.ConfigurarDados(vDiretorio: string);
begin
  // DLL
  SQLiteDriverLink.VendorLib := vDiretorio+'DLL\sqlite3.dll';

  // Banco de Dados
  Conexao.Connected:=false;
  Conexao.Params.Database := vDiretorio+'Dados\acontas.db3';
  Conexao.Connected:=true;
end;

procedure TFDados.CadastraBanco(nome: string; agencia: string;
                                conta: string; saldo: string);
begin
  Bancos.Close;
  Bancos.SQL.Text:='insert into bancos '+
          '(id, nome, agencia, conta, saldo) values '+
          '('+Id(1)+', '+
          '"'+nome+'", '+
          '"'+agencia+'", '+
          '"'+conta+'", '+
          saldo+')';
  Bancos.ExecSQL;
end;

procedure TFDados.CadastraCartao(nome: string; ncartao: string;
                                limite: string; banco: string;
                                vencimento: string; jurosano: string;
                                jurosatraso: string; imagem: string);
begin
  Cartoes.Close;
  Cartoes.SQL.Text:='insert into cartoes '+
          '(id, nome, ncartao, limite, banco, '+
          'vencimento, jurosano, jurosatraso, imagem) values '+
          '('+Id(2)+', '+
          '"'+nome+'", '+
          '"'+ncartao+'", '+
          '"'+limite+'", '+
          '"'+banco+'", '+
          '"'+FormatDateTime('yyyy-mm-dd', StrToDate(vencimento))+'", '+
          jurosano+', '+
          jurosatraso+', '+
          '"'+imagem+'")';
  Cartoes.ExecSQL;
end;

procedure TFDados.CadastraConta(descricao: string; tipopagamento: string;
                                datapagamento: string; valor: string;
                                valorparcela: string; parcelas: string;
                                cartao: string; pago: string);
begin
  Contas.Close;
  Contas.SQL.Text:='insert into contas '+
          '(id, descricao, tipopagamento, datapagamento, valor, '+
          'valorparcela, parcelas, cartao, pago, datacadastro) values '+
          '('+Id(3)+', '+
          '"'+descricao+'", '+
          ''+tipopagamento+', '+
          '"'+FormatDateTime('yyyy-mm-dd', StrToDate(datapagamento))+'", '+
          ''+valor+', '+
          ''+valorparcela+', '+
          ''+parcelas+', '+
          '"'+cartao+'", '+
          ''+pago+', '+
          '"'+FormatDateTime('yyyy-mm-dd', date)+'")';
  Contas.ExecSQL;
end;

procedure TFDados.AtualizaBanco(id: integer; nome: string; agencia: string;
                                conta: string; saldo: string);
begin
  Bancos.Close;
  Bancos.SQL.Text:='update bancos set '+
          'nome="'+nome+'", '+
          'agencia="'+agencia+'", '+
          'conta="'+conta+'", '+
          'saldo='+saldo+' where id='+IntToStr(id);
  Bancos.ExecSQL;

  AtualizaTabela('bancos');
end;

procedure TFDados.AtualizaCartao(id: integer; nome: string; limite: string;
                                 ncartao: string; banco: string; vencimento: string;
                                 jutosano: string; jurosatraso: string; imagem: string);
begin
  Bancos.Close;
  Bancos.SQL.Text:='update cartoes set '+
          'nome="'+nome+'", '+
          'limite='+limite+', '+
          'ncartao="'+ncartao+'", '+
          'banco="'+banco+'", '+
          'vencimento="'+FormatDateTime('yyyy-mm-dd', StrToDate(vencimento))+'", '+
          'jurosano='+jutosano+', '+
          'jurosatraso='+jurosatraso+', '+
          'imagem="'+imagem+'" where id='+IntToStr(id);
  Bancos.ExecSQL;

  AtualizaTabela('cartoes');
end;

procedure TFDados.Excluir(id: integer; tabela: string);
begin
  Bancos.Close;
  Bancos.SQL.Text:='delete from '+tabela+' where id='+IntToStr(id);
  Bancos.ExecSQL;

  AtualizaTabela(tabela);
end;

procedure TFDados.LocalizarID(vid: string; tabela: string);
begin
  if tabela='bancos' then
  begin
    Bancos.Close;
    Bancos.SQL.Text:='select * from '+tabela+' where id='+vId;
    Bancos.Open;
  end;

  if tabela='cartoes' then
  begin
    Cartoes.Close;
    Cartoes.SQL.Text:='select * from '+tabela+' where id='+vId;
    Cartoes.Open;
  end;
end;

procedure TFDados.AtualizaTabela(tabela: string);
begin
  if tabela='bancos' then
  begin
    Bancos.Close;
    Bancos.SQL.Text:='select * from '+tabela;
    Bancos.Open;
  end;

  if tabela='cartoes' then
  begin
    Cartoes.Close;
    Cartoes.SQL.Text:='select * from '+tabela;
    Cartoes.Open;
  end;
end;

function TFDados.Id(opcao: integer): string;
var
  vId: integer;
  vTabela: string;
begin
  if opcao=1 then
    vtabela:='Bancos';
  if opcao=2 then
    vtabela:='Cartoes';
  if opcao=3 then
    vtabela:='Contas';

  QryAux.Close;
  QryAux.SQL.Text:='select count(*) as contador from '+vTabela;
  QryAux.Open;

  if QryAux.FieldByName('contador').AsInteger>0 then
  begin
    QryAux.Close;
    QryAux.SQL.Text:='select max(id) as ultimo from '+vTabela;
    QryAux.Open;

    vId:=QryAux.FieldByName('ultimo').Value+1;
  end
  else
    vId:=1;

  result:= IntToStr(vId);
end;

function TFDados.SaldoTotal: string;
begin
  QryAux.Close;
  QryAux.SQL.Text:='select sum(saldo) as total from bancos';
  QryAux.Open;

  result:=QryAux.FieldByName('total').AsString;
end;

function TFDados.SaldoBancos: string;
var
  vBancos: string;
  vSaldo: string;
begin
  QryAux.Close;
  QryAux.SQL.Text:='select nome, saldo from bancos';
  QryAux.Open;

  QryAux.First;

  while not QryAux.Eof do
  begin
    if QryAux.FieldByName('saldo').AsFloat>0 then
    begin
      vSaldo:=QryAux.FieldByName('saldo').AsString;
      if pos(',',vSaldo)=0 then
        vSaldo:=vSaldo+',00';

      vBancos:=vBancos+QryAux.FieldByName('nome').AsString+': R$ '+vSaldo+' / ';
    end;

    QryAux.Next;
  end;

  vBancos:=trim(leftStr(vBancos,length(vBancos)-2));

  result:=vBancos;
end;

end.
