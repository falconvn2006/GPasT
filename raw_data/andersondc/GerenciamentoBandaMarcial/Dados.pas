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
    Integrantes: TFDQuery;
    dsIntegrantes: TDataSource;
    Uniformes: TFDQuery;
    dsUniformes: TDataSource;
    Acessorios: TFDQuery;
    dsAcessorios: TDataSource;
    Caixa: TFDQuery;
    dsCaixa: TDataSource;
    dsQryAux3: TDataSource;
    QryAux3: TFDQuery;
    Mensalidades: TFDQuery;
    dsMensalidades: TDataSource;
    Config: TFDQuery;
    dsConfig: TDataSource;
    Notificacoes: TFDQuery;
    dsNotificacoes: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ConfigurarDados;
    procedure CadastraIntegrante(categoria, dataassociacao, naipe, ativo,
                                     instrproprio, nome, apelido, nomesocial,
                                     cpf, rg, celular, email, datanasc, endereco,
                                     numero, comp, cep, bairro, cidade, pais,
                                     uf, foto, obs, aprovpresidente,
                                     aprovfinanceiro, aprovmusical: string);
    procedure EditaIntegrante(id, categoria, dataassociacao, naipe, ativo,
                                     instrproprio, nome, apelido, nomesocial,
                                     cpf, rg, celular, email, datanasc, endereco,
                                     numero, comp, cep, bairro, cidade, pais,
                                     uf, foto, obs, aprovpresidente,
                                     aprovfinanceiro, aprovmusical: string);
    procedure CadastraIntegrantePJ(categoria, dataassociacao, ativo,
                                     nome, celular, email, endereco,
                                     numero, comp, cep, bairro, cidade, pais,
                                     uf, obs, cnpj, ie, nomeempresa,
                                     razaosocial, aprovpresidente,
                                     aprovfinanceiro, aprovmusical: string);
    procedure EditaIntegrantePJ(id, categoria, dataassociacao, ativo,
                                     nome, celular, email, endereco,
                                     numero, comp, cep, bairro, cidade, pais,
                                     uf, obs, cnpj, ie, nomeempresa, razaosocial,
                                     aprovpresidente, aprovfinanceiro,
                                     aprovmusical: string);
    procedure CadastraUniforme(categoria, idintegrante, barretina,
                                   tunica, colete, jardineira,
                                   circcabeca, ombroaombro,
                                   circtorax, altcintura,
                                   compbraco, circcintura,
                                   circquadril, comptronco,
                                   ombropulso, combrovest,
                                   unifproprio, unifBanda: string);
    procedure CadastraAcessorios(descricao, categoria, fotos, qnt, obs: string);
    function ConverteValor(numero: string): string;
    procedure Excluir(id: string; tabela: string);
    function Id(vtabela: string): string;
    procedure AtualizaTabela(tabela: string);
    procedure ListarTudo(tabela: string);
    procedure ListarNaipe(naipe: string);
    procedure ListarSomenteFisico;
    procedure ListarSomenteJur;
    function LocalizarNome(nome: string): string;
    function RetornaPais(codigo: string): string;

    function FormataData(data: string): string;
    function FiltroMesAniversario(vMes: string): boolean;
    function EhJuridico(vid: string): integer;
    function RetornarNome(vid: string): string;

    procedure CriarTabelaCaixa;
    procedure CriarTabelaMensalidades;
    procedure CadastraEditaCaixa(vid, descricao, valor,
                                     data, situacao : string);
    procedure AtualizaCampoValorCaixa;
    function TotalCaixa(mes, ano: string): string;
    function UltimoDiaDoMes( MesAno: string ): string;
    function ListarMesAnoCaixa(mes, ano: string): integer;

    procedure GerarListaPagadoresMesAno(mesano: string);
    procedure CriarTabelaConfig;
    function CampoConfig(desc, valor: string): boolean;
    function FormatarValor(valor: string): string;

    procedure DefinirMensalidadePaga(id: string);
    procedure ListarMensalidadePer(periodo: string);
    procedure ListarMensalidadePerNome(nome, periodo: string);
    procedure ListarMensalidadeNaoPago;
    function VerificarSeTemRef(periodo: string): boolean;
    function ContaRegistros(tabela: string): integer;
    function RestauraConfig(desc: string): string;
    function EmailDoIntegrante(nome: string): string;
    procedure CriarTabelaNotificacoes;
    procedure CadastraEditaNotificacoes(vid, assunto, mensagem, data: string; enviado: boolean);
  end;

var
  FDados: TFDados;
  vOrder: string;
  vSQLPadraoMensalidade: string;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

// Configura Conexões com o Banco de Dados SQLite
procedure TFDados.ConfigurarDados;
var
  vDiretorio: string;
begin
  vDiretorio := ParamStr(0);
  vDiretorio := LeftStr(vDiretorio,length(vDiretorio)-
                length(ExtractFileName(vDiretorio)));

  // DLL
  SQLiteDriverLink.VendorLib := vDiretorio+'DLL\sqlite3.dll';

  // Banco de Dados
  Conexao.Connected:=false;
  Conexao.Params.Database := vDiretorio+'Dados\Cefetianos.db3';
  Conexao.Connected:=true;
end;

procedure TFDados.DataModuleCreate(Sender: TObject);
begin
  vOrder:=' order by nome';
  vSQLPadraoMensalidade:='select m.id, i.nome, m.datavenc, m.datapag, m.mesano, m.valor, '+
                         'm.pago from mensalidades m '+
                         'inner join integrantes i on i.id = m.idintegrante '+
                         'order by m.mesano, i.nome';
end;

procedure TFDados.ListarTudo(tabela: string);
begin
  if tabela='mensalidades' then
  begin
    Mensalidades.Close;
    Mensalidades.SQL.Text:=vSQLPadraoMensalidade;
    Mensalidades.Open;

    if Mensalidades.RecordCount>0 then
      TNumericField(Mensalidades.FieldByName('valor')).DisplayFormat := ',0.00;-,0.00';
  end
  else
  begin
    Integrantes.Close;
    Integrantes.SQL.Text:='select * from '+tabela+ifthen(tabela='integrantes',vOrder,'');
    Integrantes.Open;
  end;
end;

procedure TFDados.ListarNaipe(naipe: string);
begin
  Integrantes.Close;
  Integrantes.SQL.Text:='select * from integrantes where upper(naipe)='+QuotedStr(naipe)+vOrder;
  Integrantes.Open;
end;

procedure TFDados.ListarSomenteFisico;
begin
  Integrantes.Close;
  Integrantes.SQL.Text:='select * from integrantes where cpf<>'+QuotedStr('')+vOrder;
  Integrantes.Open;
end;

procedure TFDados.ListarSomenteJur;
begin
  Integrantes.Close;
  Integrantes.SQL.Text:='select * from integrantes where cnpj<>'+QuotedStr('')+vOrder;
  Integrantes.Open;
end;

function TFDados.EhJuridico(vid: string): integer;
begin
  QryAux.Close;
  QryAux.SQL.Text:='select count(*) as contador from integrantes where '+
          'id='+vid+' and cnpj<>'+QuotedStr('')+vOrder;
  QryAux.Open;

  result:=QryAux.FieldByName('contador').AsInteger;
end;

procedure TFDados.CadastraIntegrante(categoria, dataassociacao, naipe, ativo,
                                     instrproprio, nome, apelido, nomesocial,
                                     cpf, rg, celular, email, datanasc, endereco,
                                     numero, comp, cep, bairro, cidade, pais,
                                     uf, foto, obs, aprovpresidente,
                                     aprovfinanceiro, aprovmusical: string);
begin
  QryAux.Close;
  QryAux.SQL.Text:='insert into integrantes '+
          '(id, categoria, dataassociacao, naipe, ativo, instrproprio, '+
          ' nome, apelido, nomesocial, cpf, rg, celular, email, '+
          ' datanasc, endereco, numero, comp, cep, bairro, '+
          ' cidade, pais, uf, foto, obs, aprovpresidente, '+
          ' aprovfinanceiro, aprovmusical, datadealteracao ) values '+
          '('+Id('integrantes')+', '+
          '"'+categoria+'", '+
          '"'+FormataData(dataassociacao)+'", '+
          '"'+naipe+'", '+
             ativo+', '+
             instrproprio+', '+
          '"'+nome+'", '+
          '"'+apelido+'", '+
          '"'+nomesocial+'", '+
          '"'+cpf+'", '+
          '"'+rg+'", '+
          '"'+celular+'", '+
          '"'+email+'", '+
          '"'+FormataData(datanasc)+'", '+
          '"'+endereco+'", '+
          '"'+numero+'", '+
          '"'+comp+'", '+
          '"'+cep+'", '+
          '"'+bairro+'", '+
          '"'+cidade+'", '+
          '"'+pais+'", '+
          '"'+uf+'", '+
          '"'+foto+'", '+
          '"'+obs+'", '+
             aprovpresidente+', '+
             aprovfinanceiro+', '+
             aprovmusical+', '+
          '"'+FormataData(datetoStr(date))+'")';
  QryAux.ExecSQL;
end;

procedure TFDados.CadastraUniforme(categoria, idintegrante, barretina,
                                   tunica, colete, jardineira,
                                   circcabeca, ombroaombro,
                                   circtorax, altcintura,
                                   compbraco, circcintura,
                                   circquadril, comptronco,
                                   ombropulso, combrovest,
                                   unifproprio, unifBanda: string);
begin
  QryAux.Close;
  QryAux.SQL.Text:='insert into uniformes '+
          '(id, categoria, idintegrante, barretina, tunica, colete, jardineira, '+
          'circcabeca, ombroaombro, circtorax, altcintura, compbraco, circcintura, '+
          'circquadril, comptronco, ombropulso, ombrovest, unifproprio, unifBanda) values '+
          '('+Id('uniformes')+', '+
          QuotedStr(categoria)+', '+
          idintegrante+', '+
          barretina+', '+
          tunica+', '+
          colete+', '+
          jardineira+', '+
          ConverteValor(circcabeca)+', '+
          ConverteValor(ombroaombro)+', '+
          ConverteValor(circtorax)+', '+
          ConverteValor(altcintura)+', '+
          ConverteValor(compbraco)+', '+
          ConverteValor(circcintura)+', '+
          ConverteValor(circquadril)+', '+
          ConverteValor(comptronco)+', '+
          ConverteValor(ombropulso)+', '+
          ConverteValor(combrovest)+', '+
          unifproprio+', '+
          unifBanda+')';
  QryAux.ExecSQL;
end;

procedure TFDados.CadastraAcessorios(descricao, categoria, fotos, qnt, obs: string);
begin
  QryAux.Close;
  QryAux.SQL.Text:='insert into acessorios '+
          '(id, descricao, categoria, fotos, qnt, fotos) values '+
          '('+Id('acessorios')+', '+
          QuotedStr(descricao)+', '+
          QuotedStr(categoria)+', '+
          QuotedStr(fotos)+', '+
          qnt+', '+
          QuotedStr(obs)+')';
  QryAux.ExecSQL;
end;

procedure TFDados.CadastraEditaCaixa(vid, descricao, valor,
                                     data, situacao : string);
begin
  Caixa.Close;

  if StrToInt(vid)=0 then
  begin
    vid:=id('caixa');

    Caixa.SQL.Text:='insert into caixa '+
              '(id, descricao, valor, data, situacao) values ('+
              vid+', '+
              QuotedStr(descricao)+', '+
              valor+', '+
              QuotedStr(FormataData(data))+', '+
              situacao+')';
  end
  else
  begin
    Caixa.SQL.Text:='update caixa set'+
              ' descricao='+QuotedStr(descricao)+','+
              ' valor='+valor+','+
              ' data='+QuotedStr(FormataData(data))+','+
              ' situacao='+situacao+
              ' where id='+vid;
  end;

  Caixa.ExecSQL;
end;

procedure TFDados.AtualizaCampoValorCaixa;
begin

end;

function TFDados.ConverteValor(numero: string): string;
begin
  result:=StringReplace(numero, ',', '.', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TFDados.CadastraIntegrantePJ(categoria, dataassociacao, ativo,
                                     nome, celular, email, endereco,
                                     numero, comp, cep, bairro, cidade, pais,
                                     uf, obs, cnpj, ie, nomeempresa,
                                     razaosocial, aprovpresidente,
                                     aprovfinanceiro, aprovmusical: string);
begin
  QryAux.Close;
  QryAux.SQL.Text:='insert into integrantes '+
          '(id, categoria, dataassociacao, '+
          ' nome, celular, email, '+
          ' endereco, numero, comp, cep, bairro, '+
          ' cidade, pais, uf, obs, cnpj, ie, nomeempresa, razaosocial, '+
          ' aprovpresidente, aprovfinanceiro, aprovmusical, datadealteracao) values '+
          '('+Id('integrantes')+', '+
          '"'+categoria+'", '+
          '"'+FormataData(dataassociacao)+'", '+
          '"'+nome+'", '+
          '"'+celular+'", '+
          '"'+email+'", '+
          '"'+endereco+'", '+
          '"'+numero+'", '+
          '"'+comp+'", '+
          '"'+cep+'", '+
          '"'+bairro+'", '+
          '"'+cidade+'", '+
          '"'+pais+'", '+
          '"'+uf+'", '+
          '"'+obs+'", '+
          '"'+cnpj+'", '+
          '"'+ie+'", '+
          '"'+nomeempresa+'", '+
          '"'+razaosocial+'", '+
             aprovpresidente+', '+
             aprovfinanceiro+', '+
             aprovmusical+', '+
          '"'+FormataData(datetoStr(date))+'")';

  QryAux.ExecSQL;
end;

procedure TFDados.EditaIntegrante(id, categoria, dataassociacao, naipe, ativo,
                                     instrproprio, nome, apelido, nomesocial,
                                     cpf, rg, celular, email, datanasc, endereco,
                                     numero, comp, cep, bairro, cidade, pais,
                                     uf, foto, obs, aprovpresidente,
                                     aprovfinanceiro, aprovmusical: string);
begin
  Integrantes.Close;
  Integrantes.SQL.Text:='update integrantes set '+
          'categoria='+QuotedStr(categoria)+', '+
          'dataassociacao='+QuotedStr(FormataData(dataassociacao))+', '+
          'naipe='+QuotedStr(naipe)+', '+
          'ativo='+ativo+', '+
          'instrproprio='+instrproprio+', '+
          'nome='+QuotedStr(nome)+', '+
          'apelido='+QuotedStr(apelido)+', '+
          'nomesocial='+QuotedStr(nomesocial)+', '+
          'cpf='+QuotedStr(cpf)+', '+
          'rg='+QuotedStr(rg)+', '+
          'celular='+QuotedStr(celular)+', '+
          'email='+QuotedStr(email)+', '+
          'datanasc='+QuotedStr(FormataData(datanasc))+', '+
          'endereco='+QuotedStr(endereco)+', '+
          'numero='+QuotedStr(numero)+', '+
          'comp='+QuotedStr(comp)+', '+
          'cep='+QuotedStr(cep)+', '+
          'bairro='+QuotedStr(bairro)+', '+
          'cidade='+QuotedStr(cidade)+', '+
          'pais='+QuotedStr(pais)+', '+
          'uf='+QuotedStr(uf)+', '+
          'foto='+QuotedStr(foto)+', '+
          'obs='+QuotedStr(obs)+', '+
          'aprovpresidente='+aprovpresidente+', '+
          'aprovfinanceiro='+aprovfinanceiro+', '+
          'aprovmusical='+aprovmusical+', '+
          'datadealteracao='+QuotedStr(FormataData(DateToStr(date)))+
          ' where id='+id;
  Integrantes.ExecSQL;
end;

procedure TFDados.EditaIntegrantePJ(id, categoria, dataassociacao, ativo,
                                     nome, celular, email, endereco,
                                     numero, comp, cep, bairro, cidade, pais,
                                     uf, obs, cnpj, ie, nomeempresa, razaosocial,
                                     aprovpresidente, aprovfinanceiro,
                                     aprovmusical: string);
begin
  Integrantes.Close;
  Integrantes.SQL.Text:='update integrantes set '+
          'categoria='+QuotedStr(categoria)+', '+
          'dataassociacao='+QuotedStr(FormataData(dataassociacao))+', '+
          'ativo='+ativo+', '+
          'nome='+QuotedStr(nome)+', '+
          'celular='+QuotedStr(celular)+', '+
          'email='+QuotedStr(email)+', '+
          'endereco='+QuotedStr(endereco)+', '+
          'numero='+QuotedStr(numero)+', '+
          'comp='+QuotedStr(comp)+', '+
          'cep='+QuotedStr(cep)+', '+
          'bairro='+QuotedStr(bairro)+', '+
          'cidade='+QuotedStr(cidade)+', '+
          'pais='+QuotedStr(pais)+', '+
          'uf='+QuotedStr(uf)+', '+
          'cnpj='+QuotedStr(cnpj)+', '+
          'ie='+QuotedStr(ie)+', '+
          'nomeempresa='+QuotedStr(nomeempresa)+', '+
          'razaosocial='+QuotedStr(razaosocial)+', '+
          'obs='+QuotedStr(obs)+
          'aprovpresidente='+aprovpresidente+', '+
          'aprovfinanceiro='+aprovfinanceiro+', '+
          'aprovmusical='+aprovmusical+', '+
          'datadealteracao='+QuotedStr(FormataData(DateToStr(date)))+
          ' where id='+id;
  Integrantes.ExecSQL;
end;

function TFDados.FormataData(data: string): string;
begin
  result:=FormatDateTime('yyyy-mm-dd', StrToDate(data))
end;

procedure TFDados.Excluir(id: string; tabela: string);
begin
  QryAux.Close;
  QryAux.SQL.Text:='delete from '+tabela+' where id='+id;
  QryAux.ExecSQL;

  AtualizaTabela(tabela);
end;

function TFDados.TotalCaixa(mes, ano: string): string;
var
  DataIni, Datafim, Resp: string;
begin
  if length(trim(mes))=1 then mes:='0'+trim(mes);

  DataIni:=ano+'-'+mes+'-01';
  DataFim:=ano+'-'+mes+'-'+UltimoDiaDoMes(mes+ano);

  QryAux3.Close;
  QryAux3.SQL.Text:='select sum(valor) as total '+
                    'from caixa '+
                    ifthen(StrToInt(mes)>0,'where data between '+
                    QuotedStr(DataIni)+' and '+QuotedStr(DataFim),'');
  QryAux3.Open;

  Resp:='0';

  if QryAux3.RecordCount>0 then
    Resp:=QryAux3.FieldByName('total').AsString;

  if length(Resp)=0 then
    Resp:='0';

  result:=Resp;
end;

function TFDados.ListarMesAnoCaixa(mes, ano: string): integer;
var
  DataIni, Datafim, Resp: string;
begin
  if length(trim(mes))=1 then mes:='0'+trim(mes);

  Resp:='0';

  DataIni:=ano+'-'+mes+'-01';
  DataFim:=ano+'-'+mes+'-'+UltimoDiaDoMes(mes+ano);

  Caixa.Close;
  Caixa.SQL.Text:='select * from caixa '+
                    'where data between '+
                    QuotedStr(DataIni)+' and '+QuotedStr(DataFim);
  Caixa.Open;

  result:=Caixa.RecordCount;
end;

function TFDados.UltimoDiaDoMes( MesAno: string ): string;
var
  sMes: string;
  sAno: string;
begin
  sMes := Copy( MesAno, 1, 2 );
  sAno := Copy( MesAno, 4, 2 );
  if Pos( sMes, '01 02 03 04 05 06 07 08 09 10 11 12' ) > 0 then
    UltimoDiaDoMes := '31'
  else if sMes <> '02' then
    UltimoDiaDoMes := '30'
  else if ( StrToInt( sAno ) mod 4 ) = 0 then
    UltimoDiaDoMes := '29'
  else
    UltimoDiaDoMes := '28';
end;

function TFDados.LocalizarNome(nome: string): string;
begin
  Integrantes.Close;
  Integrantes.SQL.Text:='select * from integrantes where nome like '+
      QuotedStr('%'+trim(nome)+'%');
  Integrantes.Open;

  if Integrantes.RecordCount>0 then
    result:=Integrantes.FieldByName('id').AsString
  else
    result:='0';
end;

function TFDados.RetornarNome(vid: string): string;
begin
  QryAux.Close;
  QryAux.SQL.Text:='select nome from integrantes where id='+vid;
  QryAux.Open;

  if QryAux.RecordCount>0 then
    result:=QryAux.FieldByName('nome').AsString
  else
    result:='';
end;

procedure TFDados.AtualizaTabela(tabela: string);
begin
  QryAux.Close;
  QryAux.SQL.Text:='select * from '+tabela+ifthen(tabela='integrantes',vOrder,'');
  QryAux.Open;
end;

function TFDados.RetornaPais(codigo: string): string;
begin
  QryAux.Close;
  QryAux.SQL.Text:='select * from paises where codigo='+codigo;
  QryAux.Open;

  if QryAux.RecordCount>0 then
    result:=QryAux.FieldByName('nome').AsString
  else
    result:='BRASIL';
end;

function TFDados.FiltroMesAniversario(vMes: string): boolean;
begin
  integrantes.Close;
  integrantes.SQL.Text:='select * from integrantes where '+
                        'strftime('+QuotedStr('%m')+', datanasc)='+QuotedStr(vMes);
  integrantes.Open;

  result:=(integrantes.RecordCount>0);
end;

function TFDados.Id(vtabela: string): string;
var
  vId: integer;
begin
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

procedure TFDados.CriarTabelaCaixa;
begin
  Caixa.Close;
  Caixa.SQL.Text:='SELECT count(*) as nregs '+
                    'FROM sqlite_master where name='+
                    QuotedStr('caixa');
  Caixa.Open;

  if Caixa.FieldByName('nregs').AsInteger=0 then
  begin
    Caixa.Close;
    Caixa.SQL.Text:='CREATE TABLE caixa('+
       'id int, '+
       'descricao varchar(200), '+
       'valor float(6,2), '+
       'data date, '+
       'situacao int )';
    Caixa.ExecSQL;
  end;
end;

procedure TFDados.CriarTabelaNotificacoes;
begin
  Notificacoes.Close;
  Notificacoes.SQL.Text:='SELECT count(*) as nregs '+
                    'FROM sqlite_master where name='+
                    QuotedStr('notificacoes');
  Notificacoes.Open;

  if Notificacoes.FieldByName('nregs').AsInteger=0 then
  begin
    Notificacoes.Close;
    Notificacoes.SQL.Text:='CREATE TABLE notificacoes('+
       'id int, '+
       'assunto varchar(300), '+
       'mensagem text, '+
       'enviado boolean, '+
       'data date )';
    Notificacoes.ExecSQL;
  end;
end;

procedure TFDados.CriarTabelaMensalidades;
begin
  QryAux3.Close;
  QryAux3.SQL.Text:='SELECT count(*) as nregs '+
                    'FROM sqlite_master where name='+
                    QuotedStr('Mensalidades');
  QryAux3.Open;

  if QryAux3.FieldByName('nregs').AsInteger=0 then
  begin
    QryAux3.Close;
    QryAux3.SQL.Text:='CREATE TABLE Mensalidades('+
       'id int, '+
       'idintegrante int, '+
       'datavenc date, '+
       'datapag date, '+
       'mesano varchar(8), '+
       'valor float(6,2), '+
       'pago boolean )';
    QryAux3.ExecSQL;
  end;
end;

procedure TFDados.CriarTabelaConfig;
begin
  Config.Close;
  Config.SQL.Text:='SELECT count(*) as nregs '+
                    'FROM sqlite_master where name='+
                    QuotedStr('config');
  Config.Open;

  if Config.FieldByName('nregs').AsInteger=0 then
  begin
    Config.Close;
    Config.SQL.Text:='CREATE TABLE config('+
       'id int, '+
       'descricao varchar(50), '+
       'valor varchar(200))';
    Config.ExecSQL;
  end;
end;

procedure TFDados.GerarListaPagadoresMesAno(mesano: string);
var
  vIDIntegrante: string;
  vDataVenc: string;
  vValor: string;
begin
  Config.Close;
  Config.SQL.Text:='select * from config where descricao like '+QuotedStr('mensalidade%');
  Config.Open;

  Config.First;
  while not Config.Eof do
  begin
    if Config.FieldByName('descricao').AsString='mensalidade_diavenc' then
      vDataVenc:=rightStr(mesano,4)+'-'+leftStr(mesano,2)+'-'+Config.FieldByName('valor').AsString
    else if Config.FieldByName('descricao').AsString='mensalidade_valor' then
      vValor:=FormatarValor(Config.FieldByName('valor').AsString);

    Config.Next;
  end;

  if VerificarSeTemRef(mesano) = false then
  begin
    QryAux2.Close;
    QryAux2.SQL.Text:='select id, ativo from integrantes '+
                      'where ativo=true order by id';
    QryAux2.Open;

    QryAux2.First;
    while not QryAux2.Eof do
    begin
      Mensalidades.Close;
      Mensalidades.SQL.Text:='insert into Mensalidades ('+
                             'id, idintegrante, datavenc, '+
                             'mesano, valor, pago) values ('+
                             id('Mensalidades')+', '+
                             QryAux2.FieldByName('id').AsString+', '+
                             QuotedStr(vDataVenc)+', '+
                             QuotedStr(mesano)+', '+
                             vValor+', false)';
      Mensalidades.ExecSQL;

      QryAux2.Next;
    end;
  end;
end;

function TFDados.CampoConfig(desc, valor: string): boolean;
begin
  QryAux3.Close;
  QryAux3.SQL.Text:='select count(*) as NRegs from config '+
                    'where descricao='+QuotedStr(desc);
  QryAux3.Open;

  Config.Close;

  if QryAux3.FieldByName('NRegs').AsInteger>0 then
    Config.SQL.Text:='update config set valor='+QuotedStr(valor)+
                     ' where descricao='+QuotedStr(desc)
  else
    Config.SQL.Text:='insert into config (id, descricao, valor) values ('+
                    id('config')+', '+QuotedStr(desc)+', '+QuotedStr(valor)+')';

  Config.ExecSQL;
end;

function TFDados.RestauraConfig(desc: string): string;
var
  vResp: string;
begin
  QryAux3.Close;
  QryAux3.SQL.Text:='select valor from config '+
                    'where descricao='+QuotedStr(desc);
  QryAux3.Open;

  if QryAux3.RecordCount>0 then
    vResp:=QryAux3.FieldByName('valor').AsString
  else
    vResp:='';

  result:=vResp;
end;

function TFDados.FormatarValor(valor: string): string;
var
  vResp: string;
begin
  vResp:=valor;
  vResp:=StringReplace(vResp, '.', '@',[rfReplaceAll, rfIgnoreCase]);
  vResp:=StringReplace(vResp, ',', '.',[rfReplaceAll, rfIgnoreCase]);
  vResp:=StringReplace(vResp, '@', '',[rfReplaceAll, rfIgnoreCase]);

  result:=vResp;
end;

procedure TFDados.DefinirMensalidadePaga(id: string);
var
  vDesc: string;
  vValor: string;
begin
  QryAux.Close;
  QryAux.SQL.Text:='update mensalidades set pago=true, '+
                    'datapag='+QuotedStr(FormataData(datetoStr(date)))+' '+
                    'where id='+id;
  QryAux.ExecSQL;

  QryAux2.Close;
  QryAux2.SQL.Text:='select m.id, i.nome, i.nomesocial, m.datapag, m.mesano, m.valor, '+
                    'm.pago from mensalidades m '+
                    'inner join integrantes i on i.id = m.idintegrante '+
                    'where m.id='+id;
  QryAux2.Open;

  vDesc:='Mensalidade - Ref: '+trim(QryAux2.FieldByName('mesano').AsString)+' - '+
         trim(QryAux2.FieldByName('nomesocial').AsString);
  vValor:=QryAux2.FieldByName('valor').AsString;

  CadastraEditaCaixa('0', vDesc, vValor, DateToStr(date), '1');
end;

procedure TFDados.ListarMensalidadePer(periodo: string);
begin
  Mensalidades.Close;
  Mensalidades.SQL.Text:='select m.id, i.nome, m.datavenc, m.datapag, m.mesano, m.valor, '+
                         'm.pago from mensalidades m '+
                         'inner join integrantes i on i.id = m.idintegrante '+
                         'where mesano='+QuotedStr(periodo)+' '+
                         'order by m.mesano, i.nome';
  Mensalidades.Open;

 if Mensalidades.RecordCount>0 then
   TNumericField(Mensalidades.FieldByName('valor')).DisplayFormat := ',0.00;-,0.00';

end;

procedure TFDados.ListarMensalidadePerNome(nome, periodo: string);
begin
  Mensalidades.Close;
  Mensalidades.SQL.Text:='select m.id, i.nome, m.datavenc, m.datapag, m.mesano, m.valor, '+
                         'm.pago from mensalidades m '+
                         'inner join integrantes i on i.id = m.idintegrante '+
                         'where '+
                         ifthen(uppercase(periodo)<>'TUDOTUDO',' m.mesano='+QuotedStr(periodo)+' and ','')+
                         'upper(i.nome) like '+QuotedStr('%'+trim(nome)+'%')+
                         'order by m.mesano, i.nome';
  Mensalidades.Open;

 if Mensalidades.RecordCount>0 then
   TNumericField(Mensalidades.FieldByName('valor')).DisplayFormat := ',0.00;-,0.00';

end;

procedure TFDados.ListarMensalidadeNaoPago;
begin
  Mensalidades.Close;
  Mensalidades.SQL.Text:='select m.id, i.nome, m.datavenc, m.datapag, m.mesano, m.valor, '+
                         'm.pago from mensalidades m '+
                         'inner join integrantes i on i.id = m.idintegrante '+
                         'where m.pago=false '+
                         'order by m.mesano, i.nome';
  Mensalidades.Open;

 if Mensalidades.RecordCount>0 then
   TNumericField(Mensalidades.FieldByName('valor')).DisplayFormat := ',0.00;-,0.00';

end;

function TFDados.VerificarSeTemRef(periodo: string): boolean;
begin
  QryAux3.Close;
  QryAux3.SQL.Text:='select count(*) as NRegs from mensalidades where mesano='+QuotedStr(periodo);
  QryAux3.Open;

  result:=QryAux3.FieldByName('NRegs').AsInteger>0
end;

function TFDados.ContaRegistros(tabela: string): integer;
begin
  QryAux3.Close;
  QryAux3.SQL.Text:='select count(*) as NRegs from '+tabela;
  QryAux3.Open;

  result:=QryAux3.FieldByName('NRegs').AsInteger;
end;

function TFDados.EmailDoIntegrante(nome: string): string;
var
  vResp: string;
begin
  vResp:='';

  QryAux3.Close;
  QryAux3.SQL.Text:='select nome, email from integrantes where nome like '+QuotedStr(nome+'%');
  QryAux3.Open;

  if QryAux3.RecordCount>0 then
    vResp:=QryAux3.FieldByName('email').AsString;

  result:=vResp;
end;

procedure TFDados.CadastraEditaNotificacoes(vid, assunto, mensagem, data: string; enviado: boolean);
var
  vEnviado: string;
begin
  Notificacoes.Close;
  vEnviado:=ifthen(enviado=true,'true','false');

  if StrToInt(vid)=0 then
  begin
    vid:=id('notificacoes');

    Notificacoes.SQL.Text:='insert into notificacoes '+
              '(id, assunto, mensagem, data, enviado) values ('+
              vid+', '+
              QuotedStr(assunto)+', '+
              QuotedStr(mensagem)+', '+
              QuotedStr(FormataData(data))+', '+
              vEnviado+')';
  end
  else
  begin
    Notificacoes.SQL.Text:='update notificacoes set'+
              ' assunto='+QuotedStr(assunto)+','+
              ' mensagem='+QuotedStr(mensagem)+','+
              ' data='+QuotedStr(FormataData(data))+','+
              ' enviado='+vEnviado+
              ' where id='+vid;
  end;

  Notificacoes.ExecSQL;
end;

end.
