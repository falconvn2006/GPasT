unit udm;

// todas as validações que precisam de consulta ao bancos foram jogadas aqui
// isso só funciona no DM pq o projeto só tem 1 tela e eu verifico diretamente
// o form de uAberturaComanda, mas isso não é correto pois o DM não deveria ver
// diretamento o form visual
// caso criado mais forms, o ideal seria criar outro DM para controlar suas funções
// ou adaptar / não utilizar as funções já criadas

interface

uses
  System.SysUtils, System.Classes,
  Data.DBXCommon, Data.DB, Datasnap.DBClient, Datasnap.DSConnect, Data.SqlExpr,
  System.strutils, Data.FMTBcd, idftp,

  System.Bindings.Outputs,
  System.Types, System.UITypes, FMX.Dialogs, System.IOUtils,
  System.Variants, uproxy, ufuncoes, Data.DbxDatasnap, IPPeerClient,
  IdBaseComponent, IdComponent, IdIPWatch, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Comp.Client,
{$IFDEF MSWINDOWS}
  FireDAC.VCLUI.Wait,
{$ENDIF}
  FireDAC.Comp.UI;

type

  Tdm = class(TDataModule)
    SQLConnection1: TSQLConnection;
    DSServerModule: TDSProviderConnection;
    CDS_TBPARAMETRO: TClientDataSet;
    CDS_TBPARAMETROPARAMETRO: TStringField;
    CDS_TBPARAMETROTIPO: TStringField;
    CDS_TBPARAMETROTIPO_SN: TStringField;
    CDS_TBPARAMETROVALOR: TStringField;
    CDS_TBPARAMETROGRUPO: TStringField;
    CDS_TBPARAMETRODESCRICAO: TStringField;
    CDS_TBPARAMETROPALAVRA_CHAVE: TStringField;
    cds_sqlgenerico: TClientDataSet;
    CDS_TBCLI: TClientDataSet;
    CDS_TBPROD: TClientDataSet;
    CDS_TBPRODCODIGO: TStringField;
    CDS_TBPRODDESCRICAO: TStringField;
    CDS_TBPRODPVENDAA: TFloatField;
    CDS_TBPRODCODPESQUISA: TStringField;
    CDS_TBPRODTIPO_PRODUTO: TIntegerField;
    CDS_TBPRODVR_CREDITO: TFloatField;
    FDConnection1: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure SQLConnection1AfterConnect(Sender: TObject);
  private
    MetodosServidor: TDSServerModule_bancoClient;

    { Private declarations }
  public


    VCodCli: string;

    vParametroBUSCA_CLIENTE_POR, vParametroBLOQUEIO_COMANDA,
      vParametroCLIENTE_TIPO_PESQUISA, vParametroLIBERA_COMANDA,
      VParametroUTILIZA_COMANDA_SAIDA, VParametroUTILIZA_ITEM_OBRIGATORIO,
      vParametroDDD_PADRAO: string;


    vRodandoBuscaCliente, vAchouNaTBcli, vAchouNaTBvip: boolean;
    function validaCampo(pInfo: string; pOrigem: string): String;

    function VerificaComanda(sComanda: String): boolean;
    procedure CarregaParametros();
    function BuscaCliente(pCampo: String; pOrigem: string): string;
    function valida_cliente: boolean;
    procedure GravaCliente;
    procedure GravaComanda;
    procedure GravaItens;
    function ConsultaComandasAbertas: string;
    { function CanConnect(): boolean; }

    { Public declarations }

  end;

var
  dm: Tdm;

implementation

uses
  uAberturaComanda;
//{ %CLASSGROUP 'FMX.Controls.TControl' }

{$R *.dfm}

function Tdm.BuscaCliente(pCampo: String; pOrigem: string): string;
var
vParametroWhere, vStringSql: string;
begin
  if pOrigem = vParametroBUSCA_CLIENTE_POR then
  begin

    vRodandoBuscaCliente := True;
    vAchouNaTBcli := False;
    vAchouNaTBvip := False;
    VCodCli := '';

    if vParametroBUSCA_CLIENTE_POR = 'F' then
      vParametroWhere := ' fone '
    else if vParametroBUSCA_CLIENTE_POR = 'C' then
      vParametroWhere := ' cgc '
    else if vParametroBUSCA_CLIENTE_POR = 'R' then
      vParametroWhere := ' insc '
    else if vParametroBUSCA_CLIENTE_POR = 'E' then
      vParametroWhere := ' email ';

    // monta consulta na tabela de cliente
    vStringSql := 'select  tbcli.* from tbcli' + ' where (1=1) and tbcli.' +
      vParametroWhere + '= ' + quotedstr(pCampo) + ' and (tipo = ''0'')';

    if vParametroCLIENTE_TIPO_PESQUISA = 'S' then
      vStringSql := vStringSql + ' and pesq_eventos = ''S''';

    vStringSql := vStringSql + ' order by codigo';

    CDS_TBCLI.Close;
    MetodosServidor.sqlTBCLI(vStringSql);
    CDS_TBCLI.Open;

    // se não achou o cliente na tbcli procura na lista vip
    if (CDS_TBCLI.IsEmpty) and (vParametroBUSCA_CLIENTE_POR <> 'R') then
    begin
      if vParametroBUSCA_CLIENTE_POR = 'C' then
        vParametroWhere := ' CPF ';

      vStringSql :=
        'select cast(1 as integer) as ordem, tblista_vip.* from tblista_vip' +
        ' where tblista_vip.' + vParametroWhere + '= ' + quotedstr(pCampo);
      CDS_TBCLI.Close;
      MetodosServidor.sqlTBCLI(vStringSql);
      CDS_TBCLI.Open;

      if (not CDS_TBCLI.IsEmpty) then
        vAchouNaTBvip := True;

    end
    else if not (CDS_TBCLI.IsEmpty) then
    begin
      // se achou seta as variaveis|| vcodcli é usado de parametro na função valida cliente
      // vAchouNaTBcli indica se a informação ta vindo na tbcli ou da lista vip
      VCodCli := CDS_TBCLI.FieldByName('codigo').AsString;
      vAchouNaTBcli := True;
    end;

    // joga as informações nos campos, caso tenha achado na tbcli ou na lista vip
    if (vAchouNaTBvip) OR (vAchouNaTBcli) then
    begin
      // chamo o onEnter e o onExit de cada edit pra simular o input manual e rodar as validações

      fAberturaComanda.edemail.OnEnter(nil);
      fAberturaComanda.edemail.Text := CDS_TBCLI.FieldByName('email').AsString;
      fAberturaComanda.edemail.OnExit(nil);

      fAberturaComanda.edtelefone.OnEnter(nil);
      fAberturaComanda.edtelefone.Text := CDS_TBCLI.FieldByName('fone')
        .AsString;
      fAberturaComanda.edtelefone.OnExit(nil);

      if vAchouNaTBcli then
      begin
        fAberturaComanda.edcpf.OnEnter(nil);
        fAberturaComanda.edcpf.Text := CDS_TBCLI.FieldByName('cgc').AsString;
        fAberturaComanda.edcpf.OnExit(nil);

        fAberturaComanda.edrg.OnEnter(nil);
        fAberturaComanda.edrg.Text := CDS_TBCLI.FieldByName('insc').AsString;
        fAberturaComanda.edrg.OnExit(nil);
      end
      else
      begin
        fAberturaComanda.edcpf.OnEnter(nil);
        fAberturaComanda.edcpf.Text := CDS_TBCLI.FieldByName('cpf').AsString;
        fAberturaComanda.edcpf.OnExit(nil);

        // n tem RG na lista vip
      end;

      fAberturaComanda.edDtNasc.OnEnter(nil);

      if vAchouNaTBcli then
      begin
        fAberturaComanda.edDtNasc.Text :=
          CDS_TBCLI.FieldByName('DATA_NASCIMENTO').AsString;
      end
      else
        fAberturaComanda.edDtNasc.Text :=
          CDS_TBCLI.FieldByName('DATANASC').AsString;
      fAberturaComanda.edDtNasc.OnExit(nil);

      fAberturaComanda.ednomecli.OnEnter(nil);
      fAberturaComanda.ednomecli.Text := CDS_TBCLI.FieldByName('nome').AsString;

      if VCodCli <> '' then // caso tenha o código do cliente, valida o mesmo
        valida_cliente;

    end;
  end;
  vRodandoBuscaCliente := False;
end;

procedure Tdm.CarregaParametros;
begin
  // função com o objetivo de carregar todos os parametros e salvar em variaveis
  // pra não ter que ficar consultando o servidor toda hora

  vParametroBUSCA_CLIENTE_POR := MetodosServidor.parametro
    ('BUSCA_CLIENTE_POR', '');
  vParametroBLOQUEIO_COMANDA := MetodosServidor.parametro
    ('BLOQUEIO_COMANDA', '');
  vParametroCLIENTE_TIPO_PESQUISA := MetodosServidor.parametro
    ('CLIENTE_TIPO_PESQUISA', '');

  vParametroLIBERA_COMANDA := MetodosServidor.parametro('LIBERA_COMANDA', '');

  VParametroUTILIZA_COMANDA_SAIDA := MetodosServidor.parametro
    ('UTILIZA_COMANDA_SAIDA', '');
  VParametroUTILIZA_ITEM_OBRIGATORIO := MetodosServidor.parametro
    ('UTILIZA_ITEM_OBRIGATORIO', '');

  vParametroDDD_PADRAO := MetodosServidor.parametro('DDD_PADRAO', '');

end;



function Tdm.ConsultaComandasAbertas: string;
begin
  cds_sqlgenerico.Close;
  MetodosServidor.sqlgenerico
    ('select count(comanda) as comanda from tbcomanda');
  cds_sqlgenerico.Open;

  result := cds_sqlgenerico.FieldByName('comanda').AsString;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  // instancia classe do servidor para utilizar as funções declaradas na unit uProxy
  // unit uproxy é a classe intermediaria entre o cliente e o servidor
  // ela da o acesso as funções declaradas na clase TDSServerModule_banco no servidor android
  // é gerada atraves do 'generate datasnap class client' clicando com o botão
  // direito no componente sqlconnection 1
  // sempre que adicionada uma nova função a essa classe é preciso 'generate datasnap class client' novamente

  vRodandoBuscaCliente := False;
  VCodCli := '';

{$IFDEF MSWINDOWS}
  FDConnection1.Connected := True;
  if FDConnection1.Connected then

{$ENDIF}
{$IFDEF Android}
    if FileExists(TPath.Combine(TPath.GetDocumentsPath, 'Employees.s3db')) then
    begin
      FDConnection1.Params.Database := TPath.Combine(TPath.GetDocumentsPath,
        'Employees.s3db');

      FDConnection1.Connected := True;

    end;

{$ENDIF}
end;

procedure Tdm.FDConnection1AfterConnect(Sender: TObject);
begin
  if FDConnection1.Connected then
  begin
   //  FDConnection1.ExecSQL('drop table tbConfiguracoes');
     FDConnection1.ExecSQL
      ('CREATE TABLE IF NOT EXISTS tbConfiguracoes (ipServidorAndroid  TEXT,' +
      ' PortaServidorAndroid TEXT, DescEntradaPadrao TEXT, CodEntradaPadrao text,'
      + ' NumeroTablet int, ConectaAutomatico char)');
  end;

end;

procedure Tdm.FDConnection1BeforeConnect(Sender: TObject);
begin

{$IFDEF Android}
  // if FileExists('/storage/emulated/0/Employees.s3db') then
  // begin
  // FDConnection1.Params.Database := '/storage/emulated/0/Employees.s3db';

  // end;
{$ENDIF}
end;

procedure Tdm.GravaCliente;
var
  vSQLInsert: string;

begin
  // select GEN_ID (' + pGenerator +',1) AS ID_ATUAL FROM RDB$DATABASE

  cds_sqlgenerico.Close;
  MetodosServidor.sqlgenerico
    ('select NEXT VALUE FOR GEN_TBCLI AS ID_ATUAL FROM RDB$DATABASE', 'E');
  cds_sqlgenerico.Open;

  VCodCli := FormatCurr('00000',
    cds_sqlgenerico.FieldByName('ID_ATUAL').AsFLOAT);

  vSQLInsert :=
    'insert into tbcli(codigo, nome, cgc, insc, fone, email, DATA_NASCIMENTO, STATUS, PESQ_EVENTOS, TIPO, regime_simples, categoria) values('
    + quotedstr(VCodCli) + ', ' + quotedstr(fAberturaComanda.ednomecli.Text) +
    ', ' + quotedstr(fAberturaComanda.edcpf.Text) + ', ' +
    quotedstr(fAberturaComanda.edrg.Text) + ', ' +
    quotedstr(fAberturaComanda.edtelefone.Text) + ', ' +
    quotedstr(fAberturaComanda.edemail.Text) + ', ' +
    quotedstr(FORMATDATETIME('MM/DD/YYYY', fAberturaComanda.edDtNasc.DATE)) +
    ',''A'', ''S'', 0, -1, -1 )';

  cds_sqlgenerico.Close;
  MetodosServidor.sqlgenerico(vSQLInsert, 'I');
  VCodCli := '';
end;

procedure Tdm.GravaComanda;
var
  vSQLInsert: string;
begin
  vSQLInsert := 'insert into tbcomanda(comanda, seq, mesa, qtd_pessoas,' +
    ' data_abertura, hora_abertura, fone, cliente, nome,' +
    ' rg, cpf, data_nascimento, maioridade, tableT_numero' + ') values(' + '  '
    + fAberturaComanda.edComanda.Text + ', 0' + ', 0' + ', 1' + ', ' +
    quotedstr(FORMATDATETIME('mm/dd/yyyy', DATE)) + ', ' +
    quotedstr(FORMATDATETIME('hh:mm:ss', Time)) + ', ' +
    quotedstr(replacestr(fAberturaComanda.edtelefone.Text, ' ', '')) + ', ' +
    quotedstr(VCodCli) + ', ' + quotedstr(fAberturaComanda.ednomecli.Text) +
    ', ' + quotedstr(fAberturaComanda.edrg.Text) + ', ' +
    quotedstr(fAberturaComanda.edcpf.Text) + ', ' +
    quotedstr(FORMATDATETIME('mm/dd/yyyy', fAberturaComanda.edDtNasc.DATE));

  if fAberturaComanda.cbMaioridade.isChecked then
    vSQLInsert := vSQLInsert + ', ''S'''
  else
    vSQLInsert := vSQLInsert + ', ''N''';

  vSQLInsert := vSQLInsert + ', ' + fAberturaComanda.ednumtablet.Text;

  vSQLInsert := vSQLInsert + ') ';

  cds_sqlgenerico.Close;
  MetodosServidor.sqlgenerico(vSQLInsert, 'I');

end;

procedure Tdm.GravaItens;
var
  vSQLInsert: string;
begin
  vSQLInsert :=
    'insert into TBCOMANDA_ITEM (comanda, CodProd, codprod_2, descricao,' +
    ' qtd, vr_unit, funcionario, id_ingre, seq_peso, viagem' + ') values (' +
    '  ' + fAberturaComanda.edComanda.Text + ', ' + quotedstr(ufuncoes.lpad(fAberturaComanda.edtaxa.Text,6,'0'))
    + '' + ', ''''' + ', ' + quotedstr(fAberturaComanda.edtaxadesc.Text) + '' +
    ', 1' + ', ' + replacestr(fAberturaComanda.edvalor.Text, ',', '.') + '' +
    ', ''''' + ', 0' + ', 0' + ', ''N''' + ')';

  cds_sqlgenerico.Close;
  MetodosServidor.sqlgenerico(vSQLInsert, 'I');

end;

procedure Tdm.SQLConnection1AfterConnect(Sender: TObject);
begin
  MetodosServidor := TDSServerModule_bancoClient.Create
    (SQLConnection1.DBXConnection);
  CarregaParametros;

  fAberturaComanda.SetaCamposNovaComanda;

end;

function Tdm.VerificaComanda(sComanda: String): boolean;
begin
  // lógica da função alterada se comparado ao PDV
  // todas as validações que precisam de consulta ao bancos foram jogadas aqui
  // retorno True  = comanda valida| prosseguir
  // retorno False = comanda invalida| sair
  // verifica bloqueio

  result := True;
  sComanda := TiraZeros(sComanda);

  if (MetodosServidor.parametro('BLOQUEIO_COMANDA', 'N') = 'S') then
  begin
    cds_sqlgenerico.Close;
    MetodosServidor.sqlgenerico
      ('select * from tbcomanda_bloqueada where comanda = ' + sComanda);
    cds_sqlgenerico.Open;
    if not cds_sqlgenerico.IsEmpty then
    begin
      fAberturaComanda.lbvalidacomanda.visible := True;
      fAberturaComanda.lbvalidacomanda.Text :=
        ('Comanda ' + sComanda + ' está bloqueada');
      result := False;
      exit;
    end;
  end;

  // verifica se já está aberta
  cds_sqlgenerico.Close;
  MetodosServidor.sqlgenerico('select * from tbcomanda where comanda = ' +
    sComanda);
  cds_sqlgenerico.Open;

  if not cds_sqlgenerico.IsEmpty then
  begin
    result := False;
    fAberturaComanda.lbvalidacomanda.visible := True;
    fAberturaComanda.lbvalidacomanda.Text :=
      ('Comanda informada já está aberta!');

    exit;
  end;

  if (vParametroLIBERA_COMANDA = 'S') OR (VParametroUTILIZA_COMANDA_SAIDA = 'S')
  then
  begin
    // verifica se esse numero de comanda tem saida pendente
    cds_sqlgenerico.Close;
    MetodosServidor.sqlgenerico(' select * from TBCOMANDA_SAIDA' +
      ' where DATA_SAIDA is null and HORA_SAIDA is null and comanda = ' +
      sComanda);
    cds_sqlgenerico.Open;

    if not cds_sqlgenerico.IsEmpty then
    begin
      result := False;
      fAberturaComanda.lbvalidacomanda.visible := True;
      fAberturaComanda.lbvalidacomanda.Text :=
        ('Saída da comanda pendente.' + #13 +
        'É necessário realizar a saída da comanda para fazer uma nova abertura');

      exit;
    end;

  end;
   fAberturaComanda.lbvalidacomanda.visible := false;
end;

function Tdm.valida_cliente: boolean;

begin
  result := False;

  //Verifica se o cliente já está vinculado a outra comanda
  cds_sqlgenerico.Close;
  MetodosServidor.sqlgenerico('select comanda, data_abertura, hora_abertura' +
    ' from tbcomanda' + ' where cliente = ''' + VCodCli + '''' +
    ' and comanda not in (' +
    ' select tbcomanda_bloqueada.comanda from tbcomanda_bloqueada)');
  cds_sqlgenerico.Open;

  if not cds_sqlgenerico.IsEmpty then
  begin
    fAberturaComanda.lbmensagemcli.Text :=
      ('Cliente já vinculado à comanda: ' + cds_sqlgenerico.FieldByName
      ('comanda').AsString + ' Aberta em: ' + cds_sqlgenerico.FieldByName
      ('data_abertura').AsString + ' - ' + cds_sqlgenerico.FieldByName
      ('hora_abertura').AsString);
    fAberturaComanda.lbmensagemcli.visible := True;
    exit;
  end;

  if (vParametroLIBERA_COMANDA = 'S') then
  begin
    cds_sqlgenerico.Close;
    MetodosServidor.sqlgenerico('select * from TBCOMANDA_SAIDA' +
      ' where (DATA_SAIDA is null OR' + ' HORA_SAIDA is null) and' +
      ' CODCLI = ' + quotedstr(VCodCli));
    cds_sqlgenerico.Open;

    if not cds_sqlgenerico.IsEmpty then
    begin
      fAberturaComanda.lbmensagemcli.Text := 'Saída do cliente pendente.' +
        'É necessário que o cliente realize a saída da comanda numero: ' +
        cds_sqlgenerico.FieldByName('comanda').AsString +
        ' antes de abrir uma nova comanda.';
      fAberturaComanda.lbmensagemcli.visible := True;
      exit;
    end;
  end;
   fAberturaComanda.lbmensagemcli.visible := False;
  result := True;
end;

function Tdm.validaCampo(pInfo: string; pOrigem: string): String;
var
StringSQl : string;
begin

  result := '';
  StringSQl := 'select codigo from tbcli where ' +
   pOrigem + ' = ' + quotedstr(pInfo);
  cds_sqlgenerico.Close;
  MetodosServidor.sqlgenerico(StringSQl);
  cds_sqlgenerico.Open;

  if not cds_sqlgenerico.IsEmpty then
    result := cds_sqlgenerico.FieldByName('codigo').AsString;


  cds_sqlgenerico.close;

end;

end.
