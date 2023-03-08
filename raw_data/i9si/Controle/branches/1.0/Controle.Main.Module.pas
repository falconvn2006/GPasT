unit Controle.Main.Module;

interface

uses
  uniGUIMainModule, uniGUIForm, SysUtils, Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,Messages, Dialogs,
  uniPageControl, uniMemo, uniDBMemo, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, ACBrValidador,

  System.RegularExpressions, System.math,
  uniGUIBaseClasses, uniGUIClasses,  
  frxClass, frxExportBaseDialog, frxExportPDF, frxDBSet, 
  uniSweetAlert;

type
  TADOConnectionHelper = class Helper for TADOConnection
  public
    function BeginTrans: Integer;
  end;

type
    TVisualizacaoAgendamentosProfissional = record
      Restricao : Boolean;
      Profissional_id: integer;
    end;

type
  TCalJurosMulta = Record
     ValorMulta: double;
     ValorJuros: double;
     ValorAtualizadoComDesconto : double;
  End;

  TControleMainModule = class(TUniGUIMainModule)
    ADOConnection: TADOConnection;
    CdsAx1: TClientDataSet;
    DspAx1: TDataSetProvider;
    QryAx1: TADOQuery;
    CdsAx2: TClientDataSet;
    DspAx2: TDataSetProvider;
    QryAx2: TADOQuery;
    CdsAx3: TClientDataSet;
    DspAx3: TDataSetProvider;
    QryAx3: TADOQuery;
    ADOConnectionLogin: TADOConnection;
    CdsUsuario: TClientDataSet;
    DspUsuario: TDataSetProvider;
    QryUsuario: TADOQuery;
    CdsUsuarioPermissao: TClientDataSet;
    DspUsuarioPermissao: TDataSetProvider;
    QryUsuarioPermissao: TADOQuery;
    CdsFilial: TClientDataSet;
    DspFilial: TDataSetProvider;
    QryFilial: TADOQuery;
    ADOConnectionAudit: TADOConnection;
    cdsMenu_Schema: TClientDataSet;
    DspMenu_Schema: TDataSetProvider;
    QryMenu_Schema: TADOQuery;
    cdsMenu_SchemaID: TFloatField;
    cdsMenu_SchemaMENU_DESCRICAO: TWideStringField;
    DspListaArquivos: TDataSetProvider;
    CdsListaArquivos: TClientDataSet;
    QryListaArquivos: TADOQuery;
    DscListaArquivos: TDataSource;
    CdsListaArquivosID: TFMTBCDField;
    CdsListaArquivosDESCRICAO: TWideStringField;
    CdsListaArquivosCAMINHO: TWideStringField;
    CdsListaArquivosTABELA_ID: TFMTBCDField;
    CdsListaArquivosTABELA_NOME: TWideStringField;
    CdsListaArquivosSCHEMA: TWideStringField;
    CdsAx4: TClientDataSet;
    DspAx4: TDataSetProvider;
    QryAx4: TADOQuery;
    CdsAx5: TClientDataSet;
    DspAx5: TDataSetProvider;
    QryAx5: TADOQuery;
    ADOConnectionFonte: TADOConnection;
    CdsAx6: TClientDataSet;
    DspAx6: TDataSetProvider;
    QryAx6: TADOQuery;
    frxPDFExport1: TfrxPDFExport;
    DspParametros: TDataSetProvider;
    CdsParametros: TClientDataSet;
    CdsParametrosTABELA: TWideStringField;
    CdsParametrosCAMPO: TWideStringField;
    CdsParametrosVALOR: TWideStringField;
    QryParametros: TADOQuery;
    DscParametros: TDataSource;
    procedure FDConnectionError(ASender, AInitiator: TObject;
      var AException: Exception);
    procedure UniGUIMainModuleCreate(Sender: TObject);
    procedure CdsListaArquivosAvaliacaoCAMINHOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure CdsListaArquivosCAMINHOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    function CurrencyToInteger(valor: Currency): Integer;
    function RetornaDataProximoTitulo(DataVenc: TDateTime): TDateTime;
    procedure QuantosCaixasEmAbertos(IdDoUsuario: Integer);
    function CondicoesPagGeraChCaBo(id_cond_pag: Integer; Gera: string): Boolean;
   { Private declarations }
  public
    { Public declarations }
    MensageiroSweetAlert : TUniSweetAlert;
    VisualizacaoAgendamentosProfissional : TVisualizacaoAgendamentosProfissional;
    Retorno         : String;
    FSchema         : string;
    FRepresentante  : Integer;
    FFilial         : Integer;
    FRazaoSocial    : string;
    FNomeFantasia   : string;
    FPlano          : string;
    FCodigoRegimeTributario : String; // 1 - SIMPLES NACIONAL / 3 - REGIME NORMAL
    FUsuarioId      : Integer;
    FNomeUsuario    : string;
    FNumeroCaixaLogado  : Integer;
    RetornoInputBox : String;
    URL_LOGO_MAIN_MODULE   : string;
    NumeroDocumentoTitulo : string;
    titulo_id_m     : Integer;
    modelo_id_m     : Integer;
    FDataAbertura : TDateTime;
    percentual_juros: Double;
    percentual_multa: Double;
    tipo_geracao_titulos: string;
    negociar_titulo_varios_clientes: string;
    DirBytes : integer;
    procedure UltimoLogin(id: integer);
    function ContaAvaliacoesCadastradas: integer;
    function ContaAgendaRealizada(): integer;
    function FolderSize(Dir: string): double;
    function UltimoDia(Mes: TDateTime): integer;
    procedure ApagarDocumento(tabela: String;
                              Id: Integer);
    Function TituloPossuiAnexo(titulo_id: integer;
                               possui_anexo: string): Boolean;
    function SalvarDocumentos(Descricao: String;
                              Caminho: string;
                              tabela_id: Integer;
                              tabela_nome: String): Boolean;
    Procedure CarregaListaDeArquivos(tabela_id: Integer;
                                     tabela_nome: String);
    Function AtualizaDataTitulo(data_vencimento: TDate;
                                titulo_id: Integer): Boolean;
    Function SelecionaLink_Boleto(Titulo_id: Integer): String;
    function SelecionaEmail(Pessoa_Id: Integer): String;
//    function ConfereTituloGeraBoleto(Tipo_Titulo_id: Integer): String;
    function GetFileSize(aFile: TFileName): Int64;
    procedure ComprimirImagem(ACompression: integer; const AInFile,
      AOutFile: string);
    Function BaixaTituloReceber(titulo_id,
                                           conta_bancaria_id: integer;
                                           valor_titulo,
                                           valor_juros,
                                           valor_multa,
                                           valor_pago,
                                           valor_desconto: Double;
                                           historico: string;
                                           data_vencimento,
                                           data_liquidacao: TDate;
                                           dias_atraso : integer;
                                           Carne_id: String = '';
                                           Sequencia_Parcela: String = '';
                                           condicoes_pagamento_id: integer = 1): Boolean;
    Function CancelaTitulo(titulo_id: integer): Boolean;
    function GeraId(Tabela: String): Integer;
    function GeraUsuarioId(Tabela: String): Integer;
    function Conectar(BDUser: string): Boolean;
    Function SelecionaFilial(id: Integer): Boolean;
    procedure Insere_Tabela_Temp_Login();
    procedure FindReplaceUniMemo(const Enc, subs: String; Var Texto: TUniMemo);
    procedure FindReplaceUniDbMemo(const Enc, subs: String; Var Texto: TUniDbMemo);
    procedure ConfirmaSalvarDocumento(Sender: TComponent; AResult: Integer;
      AText: string);
    procedure registra_movimento(caixa_id: integer;
                                 operacao,
                                 natureza:String;
                                 valor: Double;
                                 forma_pagamento_id: integer;
                                 Observacao: String);
    procedure EstornaMovimentoCaixa(caixa_movimento_id: integer;
                                    Observacao: String);
    procedure FechaCaixa(CaixaId: Integer);
    function VerificaNumeroCaixaAberto(UsuarioId: Integer): Integer;
    function CriaCaixa: Boolean;
    Function BaixaTituloPagar(titulo_id,
                                         conta_bancaria_id: integer;
                                         valor_titulo,
                                         valor_juros,
                                         valor_multa,
                                         valor_pago: Double;
                                         historico: string;
                                         data_liquidacao: TDate;
                                         Carne_id: String = '';
                                         Sequencia_Parcela: String = '';
                                         boleto_id: String = '';
                                         condicoes_pagamento_id: integer = 1;
                                         titulo_categoria_id: String = ''): Boolean;

    function VerificaCaixaAberto(UsuarioId: Integer): Boolean;
    Function AtualizaValorTitulo(valor: String;
                                 titulo_id: Integer): Boolean;
    function ValidandoUsuario(UserName, Password: String): Boolean;
    function GeraIdSchemaFonte(Tabela: String): Integer;
//    function PlanoSistemaHDControle(plano: String): double;
    function ModeloPossuiAnexo(Modelo_id: integer;
                               possui_anexo: string): Boolean;
    procedure ConfirmaSalvarDocumentoModelo(Sender: TComponent;
                               AResult: Integer; AText: string);
    Function GravandoTituloReceber(CondicoesPagamentoId: Integer;
                                                   IdTituloCategoria: Integer;
                                                   PessoaId: Integer;
                                                   Natureza: String; // C - Cobranca | L - Liquidação
                                                   NumeroDocumento: String; // Caso queira relacionar com uma pre-venda de produtos/serviços
                                                   DataVencimento: TDateTime;
                                                   Valor: Double;
                                                   Desconto: Double;
                                                   Observacao: String;
                                                   IntervaloProprio: Integer; // Data do dia
                                                   NumeroParcelas: Integer;
                                                   NumeroReferencia: string): Boolean;

    Function GravandoTituloPagar(CondicoesPagamentoId: Integer;
                                                 IdTituloCategoria: Integer;
                                                 PessoaId: Integer;
                                                 Natureza: String; // C - Cobranca | L - Liquidação
                                                 NumeroDocumento: String; // Caso queira relacionar com uma pre-venda de produtos/serviços
                                                 DataVencimento: TDateTime;
                                                 Valor: Double;
                                                 Desconto: Double;
                                                 Observacao: String;
                                                 IntervaloProprio: Integer; // Data do dia
                                                 NumeroParcelas: Integer;
                                                 NumeroReferencia: string):  Boolean;
    procedure MensageiroSweetAlerta(Titulo, Texto: string; tipoAlerta: tAlertType = atError);
    procedure ExportarPDF(arquivoPDF: string; Report: TfrxReport);
    Function SelecioPedidoCabecalhoGestor(num_pedido: Integer): TClientDataset;
    function SelecioPedidoItensGestor(num_pedido: Integer): TClientDataset;
    function SelecionaCliente(cpf_cnpj: string): TClientDataSet;
//    procedure MergePessoa(Schema_Source: String;
//                                          Schema_Alvo: string);
    function CalculaJurosMulta(Data: TDateTime; Valor_original, Juros,
      Multa: Double; Dias_Atraso: Integer; Desconto: Double): TCalJurosMulta;
    function ConverteToBase64(CaminhoArquivoOriginal,
      CaminhoArquivoConvertido: string): String;
  end;

function ControleMainModule: TControleMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, Controle.Server.Module, uniGUIApplication, Controle.Funcoes,
  Winapi.Windows, uniGUIDialogs, Controle.Mensagem.Erro,
  Vcl.Imaging.jpeg, System.DateUtils,Controle.Impressao.Documento,
  System.NetEncoding, System.StrUtils;


function ControleMainModule: TControleMainModule;
begin
  Result := TControleMainModule(UniApplication.UniMainModule)
end;

procedure TControleMainModule.FDConnectionError(ASender, AInitiator: TObject;
  var AException: Exception);
begin
  if (AException is EFDDBEngineException) and (EFDDBEngineException(AException).Kind = ekRecordLocked) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Impossível continuar, no momento o registro está em uso');
  end
  else if (AException is EFDDBEngineException) and (EFDDBEngineException(AException).Kind = ekFKViolated) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Impossível continuar, esse registro possui dependencias com outras tabelas');
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Impossível continuar, erro ao gravar dados, procure o suporte técnico');
  end;
//  Abort;
end;

// -------------------------------------------------------------------------- //
function TControleMainModule.GeraId(Tabela: String): Integer;
var
  Query: TADOQuery;
  Sequencia: String;
begin
  Result := -1;

  // Define o nome da sequência.
  // NOTE: O nome da sequência deve ter no máximo 30 caracteres (conforme o
  //       padrão de nomeclatura do Oracle).
  Sequencia := Copy('se_' + Tabela, 1, 30);

  Query := TADOQuery.Create(Self);
  Query.Connection := ADOConnection;

  // Carrega o id gerado pela sequência
  Query.SQL.Text := 'SELECT ' + Sequencia + '.NEXTVAL FROM dual';
  Query.Open;

  Result := Query.Fields[0].AsInteger;

  // Fecha e descarta a query
  Query.Close;
  Query.Destroy;
end;

function TControleMainModule.GeraIdSchemaFonte(Tabela: String): Integer;
var
  Query: TADOQuery;
  Sequencia: String;
begin
  Result := -1;

  // Define o nome da sequência.
  // NOTE: O nome da sequência deve ter no máximo 30 caracteres (conforme o
  //       padrão de nomeclatura do Oracle).
  Sequencia := Copy('se_' + Tabela, 1, 30);

  Query := TADOQuery.Create(Self);
  Query.Connection := ADOConnectionFonte;

  // Carrega o id gerado pela sequência
  Query.SQL.Text := 'SELECT ' + Sequencia + '.NEXTVAL FROM dual';
  Query.Open;

  Result := Query.Fields[0].AsInteger;

  // Fecha e descarta a query
  Query.Close;
  Query.Destroy;
end;


// -------------------------------------------------------------------------- //
function TControleMainModule.GeraUsuarioId(Tabela: String): Integer;
var
  Query: TADOQuery;
  Sequencia: String;
begin
  Result := -1;

  // Define o nome da sequência.
  // NOTE: O nome da sequência deve ter no máximo 30 caracteres (conforme o
  //       padrão de nomeclatura do Oracle).
  Sequencia := Copy('se_' + Tabela, 1, 30);

  Query := TADOQuery.Create(Self);
  Query.Connection := ADOConnectionLogin;

  // Carrega o id gerado pela sequência
  Query.SQL.Text := 'SELECT ' + Sequencia + '.NEXTVAL FROM dual';
  Query.Open;

  Result := Query.Fields[0].AsInteger;

  // Fecha e descarta a query
  Query.Close;
  Query.Destroy;
end;

procedure TControleMainModule.UniGUIMainModuleCreate(Sender: TObject);
begin
  FRepresentante := 0;
  // Verifica se a conexão foi aberta em tempo de projeto.
  if ADOConnection.Connected then
  begin
    // Fecha a conexão para ser aberta com os parâmetros do arquivo de
    // configuração através da função 'Conectar'.
    ADOConnection.Close;

    // Levanta uma exceção para avisar ao Gerente de Configuração que
    // o ADOConnection deve ser desconectado antes de fazer o build.
    raise Exception.Create(
      'A conexão com o banco de dados não foi configurada corretamente.');
  end;

  // Inicializa a classe BaseUtil
  ControleFuncoes := TControleFuncoes.Create;

  // Arredonda os valores por padrão na função CalculaAT.
  ControleFuncoes.IndicadorAT := 'A';
end;


// -------------------------------------------------------------------------- //
function TADOConnectionHelper.BeginTrans: Integer;
begin
  // Reabre a conexão se tiver sido desconectado
  if not Connected then
    Open();

  // Inicia a transação
  Result := inherited BeginTrans;
end;

// -------------------------------------------------------------------------- //
procedure TControleMainModule.CdsListaArquivosAvaliacaoCAMINHOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsString <> '' then
    Text := '<img src=./files/icones/printer-settings.png height=22 align="center" />';
end;

procedure TControleMainModule.CdsListaArquivosCAMINHOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := '<img src=./files/icones/printer-settings.png height=22 align="center" />'
end;

function TControleMainModule.Conectar(BDUser: string): Boolean;
var
  Usuario, Senha, DataSource: String;
begin
  // Guardando variável para uso posterior
  FSchema := BDUser;

  Result := False;

  Usuario := BDUser;
  Senha   := 'Ralios3105';
  DataSource := 'localhost:1521/xe';

  // Tenta conectar-se ao banco de dados
  try
    ADOConnection.ConnectionString :=
        'Provider = OraOLEDB.Oracle.1;'
      + 'Persist Security Info = True;'
      + 'User ID = ' + Usuario + ';'
      + 'Password = ' + Senha + ';'
      + 'Data Source = ' + DataSource + ';';

    // NOTE:
    // 1. O comando Open abre uma conexão apenas para testar se a conexão com o
    //    banco de dados está funcionando corretamente, mas como a propriedade
    //    KeepConnection está desabilitada, o ADOConnection ficará sempre
    //    desconectado, e reabrirá a conexão apenas quando for necessário
    //    acessar o banco de dados.
    // 2. A propriedade KeepConnection do ADOConnection foi desabilitada para
    //    evitar problemas com perdas de conexão quando o sistema estiver
    //    funcionando em uma rede problematica ou quando estiver acessando um
    //    banco de dados pela internet.
    // 3. O helper TADOConnectionHelper foi criado para controlar a reabertura
    //    da conexão quando houver necessidade de utilizar transação.
    ADOConnection.KeepConnection := False;
    ADOConnection.LoginPrompt    := False;
    ADOConnection.Open();

    Result := True;
  except
    Result := False;
  end;
end;
// -------------------------------------------------------------------------- //

Function TControleMainModule.SelecionaFilial(id: Integer): Boolean;
begin
  Result := False;

  Try
    Try
      // Carregando as permissões do usuário
      CdsFilial.Close;
      QryFilial.SQL.Clear;
      QryFilial.SQL.Text := 'SELECT fil.id,'
                           +'       fil.ativo,'
                           +'       fil.logomarca_caminho,'
                           +'       decode(fil.plano,''N'',''NOVO'',''G'',''GRÁTIS'',''B'',''BÁSICO'',''P'',''PRO'') plano,'
                           +'       pes.razao_social,'
                           +'       pes.nome_fantasia,'
                           +'       pes.codigo_regime_tributario'
                           +'  FROM filial fil'
                           +'  LEFT JOIN pessoa pes'
                           +'    ON pes.id = fil.id'
                           +' WHERE fil.id  = :id';
      QryFilial.Parameters.ParamByName('id').Value := id;
      CdsFilial.Open;
    Finally
      if CdsFilial.RecordCount > 0 then
      begin
        FFilial       := CdsFilial.FieldByName('id').AsInteger;
        FRazaoSocial  := CdsFilial.FieldByName('razao_social').AsString;
        FNomeFantasia := CdsFilial.FieldByName('nome_fantasia').AsString;
        FPlano        := CdsFilial.FieldByName('plano').AsString;
        FCodigoRegimeTributario := CdsFilial.FieldByName('codigo_regime_tributario').AsString;

        Result := True;
      end
      else
      begin
        raise Exception.Create('Nenhuma filial cadastrada');
      end;
    End;
  Except
    on e:Exception do
      ControleMainModule.MensageiroSweetAlerta('Atenção', e.Message);
  End;
end;

procedure TControleMainModule.Insere_Tabela_Temp_Login();
begin
  // Não utiliza transação, porque o preenchimento da tabela ficara dentro
  // da transação da tabela que esta utilizado o crud

  // Passo Unico - Salva os dados da cidade
  QryAx1.Parameters.Clear;
  QryAx1.SQL.Clear;

  // Insert
  QryAx1.SQL.Add('INSERT INTO temp$login (');
  QryAx1.SQL.Add('       filial_id,');
  QryAx1.SQL.Add('       usuario_id,');
  QryAx1.SQL.Add('       login)');
  QryAx1.SQL.Add('VALUES (');
  QryAx1.SQL.Add('       :filial_id,');
  QryAx1.SQL.Add('       :usuario_id,');
  QryAx1.SQL.Add('       :login)');

  QryAx1.Parameters.ParamByName('filial_id').Value   := ControleMainModule.FFilial;
  QryAx1.Parameters.ParamByName('usuario_id').Value  := CdsUsuario.FieldByName('id').AsString;
  QryAx1.Parameters.ParamByName('login').Value       := CdsUsuario.FieldByName('login').AsString;

  try
    // Tenta salvar os dados
    QryAx1.ExecSQL;
  except
    on E: Exception do
    begin
      Exit;
    end;
  end;
end;

procedure TControleMainModule.FindReplaceUniMemo(const Enc, subs: String; Var Texto: TUniMemo);
Var
  i, Posicao: Integer;
  Linha: string;
Begin
  For i:= 0 to Texto.Lines.count - 1 do
  begin
    Linha := Texto.Lines[i];
    Repeat
      Posicao:=Pos(Enc,Linha);
      If Posicao > 0 then
      Begin
        Delete(Linha,Posicao,Length(Enc));
        Insert(Subs,Linha,Posicao);
        Texto.Lines[i]:=Linha;
      end;
    until Posicao = 0;
  end;
end;

procedure TControleMainModule.FindReplaceUniDbMemo(const Enc, subs: String; Var Texto: TUniDbMemo);
Var
  i, Posicao: Integer;
  Linha: string;
Begin
  For i:= 0 to Texto.Lines.count - 1 do
  begin
    Linha := Texto.Lines[i];
    Repeat
      Posicao:=Pos(Enc,Linha);
      If Posicao > 0 then
      Begin
        Delete(Linha,Posicao,Length(Enc));
        Insert(Subs,Linha,Posicao);
        Texto.Lines[i]:=Linha;
      end;
    until Posicao = 0;
  end;
end;


//function TControleMainModule.ConfereTituloGeraBoleto(Tipo_Titulo_id: Integer): String;
//begin
//  // Seleciona se a opção do titulo emite boleto
//  CdsAx2.Close;
//  QryAx2.Parameters.Clear;
//  QryAx2.SQL.Clear;
//  QryAx2.SQL.Add(' SELECT gera_boleto');
//  QryAx2.SQL.Add('   FROM tipo_titulo tip');
//  QryAx2.SQL.Add('   LEFT JOIN titulo tit');
//  QryAx2.SQL.Add('     ON tit.tipo_titulo_id = tip.id');
//  QryAx2.SQL.Add('  WHERE tip.id = :id');
//  QryAx2.Parameters.ParamByName('id').Value := Tipo_Titulo_id;
//  CdsAx2.Open;
//
//  Result := CdsAx2.FieldByName('gera_boleto').AsString;
//end;

function TControleMainModule.CurrencyToInteger(valor: Currency): Integer;
var
  NovoValor: string;
begin
  NovoValor := FormatFloat(',0.00', valor);
  NovoValor := StringReplace(NovoValor, ',', '', [rfReplaceAll]);
  result := NovoValor.ToInteger;
end;

function TControleMainModule.SalvarDocumentos(Descricao: String;
                                         Caminho: string;
                                         tabela_id: Integer;
                                         tabela_nome: String): Boolean;
var
  CadastroId: integer;
begin
  inherited;

  Result := False;

  // Inicia a transação
  ADOConnection.BeginTrans;

  // Passo Unico - Salva os dados da cidade
  QryAx1.Parameters.Clear;
  QryAx1.SQL.Clear;

  // Gera um novo id para a tabela avaliacao_url_docs
  CadastroId := GeraId('documentos');
  // Insert
  QryAx1.SQL.Add('INSERT INTO documentos (');
  QryAx1.SQL.Add('       id,');
  QryAx1.SQL.Add('       descricao,');
  QryAx1.SQL.Add('       caminho,');
  QryAx1.SQL.Add('       tabela_id,');
  QryAx1.SQL.Add('       tabela_nome,');
  QryAx1.SQL.Add('       schema)');
  QryAx1.SQL.Add('VALUES (');
  QryAx1.SQL.Add('       :id,');
  QryAx1.SQL.Add('       :descricao,');
  QryAx1.SQL.Add('       :caminho,');
  QryAx1.SQL.Add('       :tabela_id,');
  QryAx1.SQL.Add('       :tabela_nome,');
  QryAx1.SQL.Add('       :schema)');

  QryAx1.Parameters.ParamByName('id').Value            := CadastroId;
  QryAx1.Parameters.ParamByName('descricao').Value     := Descricao;
  // Exite uma diferença no caminho do aceito pelo Unigui e IIS, trocar abaixo se nao funcionar.
//    QryAx1.Parameters.ParamByName('caminho').Value       := URL_LOGO;
  QryAx1.Parameters.ParamByName('caminho').Value       := Caminho;
  QryAx1.Parameters.ParamByName('tabela_id').Value     := tabela_id;
  QryAx1.Parameters.ParamByName('tabela_nome').Value   := tabela_nome;
  QryAx1.Parameters.ParamByName('schema').Value        := FSchema;

  try
    // Tenta salvar os dados
    QryAx1.ExecSQL;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));

      Exit;
    end;
  end;

  // Confirma a transação
  ADOConnection.CommitTrans;

  // Recarrega o registro
//    Abrir(CadastroId);
  Result := True;
end;

Function TControleMainModule.BaixaTituloReceber(titulo_id,
                                           conta_bancaria_id: integer;
                                           valor_titulo,
                                           valor_juros,
                                           valor_multa,
                                           valor_pago,
                                           valor_desconto: Double;
                                           historico: string;
                                           data_vencimento,
                                           data_liquidacao: TDate;
                                           dias_atraso : integer;
                                           Carne_id: String = '';
                                           Sequencia_Parcela: String = '';
                                           condicoes_pagamento_id: integer = 1): Boolean;
var
  CadastroId : Integer;
begin

  // Passo Unico - Salva os dados da cidade
  QryAx1.Parameters.Clear;
  QryAx1.SQL.Clear;

  // Update
  QryAx1.SQL.Add('UPDATE titulo SET');
  QryAx1.SQL.Add('       situacao                = ''L'',');
  QryAx1.SQL.Add('       data_liquidacao         = TO_DATE(''' + Trim(DateToStr(data_liquidacao)) + ''', ''dd/mm/yyyy''),');
  QryAx1.SQL.Add('       valor_multa             = :valor_multa,');
  QryAx1.SQL.Add('       valor_juros             = :valor_juros,');
  QryAx1.SQL.Add('       valor_liquidado         = :valor_liquidado,');
  QryAx1.SQL.Add('       valor_desconto          = :valor_desconto,');
  QryAx1.SQL.Add('       valor_pago              = :valor_pago,');
  QryAx1.SQL.Add('       historico               = :historico,');
  QryAx1.SQL.Add('       condicoes_pagamento_id  = :condicoes_pagamento_id');
  QryAx1.SQL.Add(' WHERE id                      = :id');

  QryAx1.Parameters.ParamByName('id').Value                     := titulo_id;
  QryAx1.Parameters.ParamByName('valor_multa').Value            := valor_multa;
  QryAx1.Parameters.ParamByName('valor_juros').Value            := valor_juros;
  QryAx1.Parameters.ParamByName('valor_pago').Value             := valor_pago;
  QryAx1.Parameters.ParamByName('valor_desconto').Value         := valor_desconto;
  QryAx1.Parameters.ParamByName('historico').Value              := historico;
  QryAx1.Parameters.ParamByName('condicoes_pagamento_id').Value := condicoes_pagamento_id;
  QryAx1.Parameters.ParamByName('valor_liquidado').Value        := valor_pago;

  try
    // Tenta salvar os dados
    QryAx1.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      Result := False;
    end;
  end;
end;

Function TControleMainModule.BaixaTituloPagar(titulo_id,
                                         conta_bancaria_id: integer;
                                         valor_titulo,
                                         valor_juros,
                                         valor_multa,
                                         valor_pago: Double;
                                         historico: string;
                                         data_liquidacao: TDate;
                                         Carne_id: String = '';
                                         Sequencia_Parcela: String = '';
                                         boleto_id: String = '';
                                         condicoes_pagamento_id: integer = 1;
                                         titulo_categoria_id: String = ''): Boolean;
begin
  // Passo Unico - Salva os dados da cidade
  QryAx1.Parameters.Clear;
  QryAx1.SQL.Clear;

  QryAx1.SQL.Add('UPDATE titulo SET'                                );
  QryAx1.SQL.Add('       situacao                = ''L'','              );
  QryAx1.SQL.Add('       data_liquidacao         = TO_DATE(''' + Trim(DateToStr(data_liquidacao)) + ''', ''dd/mm/yyyy''),');
  QryAx1.SQL.Add('       valor_multa             = :valor_multa,'       );
  QryAx1.SQL.Add('       valor_juros             = :valor_juros,'       );
  QryAx1.SQL.Add('       valor_liquidado         = :valor_liquidado,'   );
  QryAx1.SQL.Add('       valor_pago              = :valor_pago,'        );
  QryAx1.SQL.Add('       historico               = :historico,'         );
  QryAx1.SQL.Add('       condicoes_pagamento_id  = :condicoes_pagamento_id,');
  QryAx1.SQL.Add('       titulo_categoria_id     = :titulo_categoria_id');
  QryAx1.SQL.Add(' WHERE id                      = :id'                 );

  QryAx1.Parameters.ParamByName('id').Value                 := titulo_id;
  QryAx1.Parameters.ParamByName('valor_multa').Value        := valor_multa;// criar parametro para multa
  if valor_pago > valor_titulo then
  begin
    QryAx1.Parameters.ParamByName('valor_juros').Value      := (valor_pago - valor_titulo) - valor_multa;
    QryAx1.Parameters.ParamByName('valor_liquidado').Value  := valor_titulo;

  end
  else if valor_pago < valor_titulo  then
  begin
    QryAx1.Parameters.ParamByName('valor_juros').Value      := 0;
    QryAx1.Parameters.ParamByName('valor_liquidado').Value  := valor_titulo;
  end
  else
  begin
    QryAx1.Parameters.ParamByName('valor_juros').Value      := 0;
    QryAx1.Parameters.ParamByName('valor_liquidado').Value  := valor_titulo;
  end;
  QryAx1.Parameters.ParamByName('valor_pago').Value         := valor_pago;
  QryAx1.Parameters.ParamByName('historico').Value          := historico;
  QryAx1.Parameters.ParamByName('condicoes_pagamento_id').Value := condicoes_pagamento_id;
  QryAx1.Parameters.ParamByName('titulo_categoria_id').Value := titulo_categoria_id;

  try
    // Tenta salvar os dados
    QryAx1.ExecSQL;
    // Confirma a transação
   // ADOConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      Result := False;
    end;
  end;
////FOI RETIRADO DAQUI E COLOCADO NA TELA DE CADASTRO DO TITULO POIS NÃO É POSSIVEL DAR COMMIT ANTES QUE A SOMA DE PAGAMENTO COMPLETE O VALOR TOTAL DO TÍTULO
//  Try
//    registra_movimento(FNumeroCaixaLogado,
//                       'D',
//                       'PG',
//                       valor_pago,
//                       Forma_Pagamento_id,
//                       'Referente ao título n.º '+ inttoStr(titulo_id));
//  except
//    on E: Exception do
//    begin
//      // Descarta a transação
//      ADOConnection.RollbackTrans;
//      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
//
//      Exit;
//    end;
//  End;
//
//  Try
//    // Confirma a transação
//    ADOConnection.CommitTrans;
//  Except
//    on E: Exception do
//    begin
//      // Descarta a transação
//      ADOConnection.RollbackTrans;
//      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
//    end;
//  End;
end;

Function TControleMainModule.AtualizaDataTitulo(data_vencimento: TDate;
                                           titulo_id: Integer): Boolean;
begin
  // Inicia a transação
  ADOConnection.BeginTrans;

  // Passo Unico - Salva os dados da cidade
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;


  // Update
  QryAx3.SQL.Add('UPDATE titulo SET');
  QryAx3.SQL.Add('       data_vencimento     = TO_DATE(''' + Trim(DateToStr(data_vencimento)) + ''', ''dd/mm/yyyy'')');
  QryAx3.SQL.Add(' WHERE id                  = :id');

  QryAx3.Parameters.ParamByName('id').Value                 := titulo_id;

  try
    // Tenta salvar os dados
    QryAx3.ExecSQL;
    // Confirma a transação
    ADOConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não foi possível salvar os dados alterados: ' +ControleFuncoes.RetiraAspaSimples(E.Message));
      Result := False;
    end;
  end;
end;

Function TControleMainModule.AtualizaValorTitulo(valor: String;
                                                 titulo_id: Integer): Boolean;
begin
  valor := StringReplace(valor,',','.',[]);

  // Inicia a transação
  ADOConnection.BeginTrans;

  // Passo Unico - Salva os dados da cidade
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;

  // Update
  QryAx3.SQL.Add('UPDATE titulo SET');
  QryAx3.SQL.Add('       valor = '+ valor +'');
  QryAx3.SQL.Add(' WHERE id    = :id');

  QryAx3.Parameters.ParamByName('id').Value := titulo_id;

  try
    // Tenta salvar os dados
    QryAx3.ExecSQL;
    // Confirma a transação
    ADOConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      Result := False;
    end;
  end;
end;

Function TControleMainModule.CancelaTitulo(titulo_id: integer): Boolean;
begin
  // Inicia a transação
  ADOConnection.BeginTrans;

  // Passo Unico - Salva os dados da cidade
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;

  // Update
  QryAx3.SQL.Add('UPDATE titulo SET');
  QryAx3.SQL.Add('       situacao            = ''C'',');
  QryAx3.SQL.Add('       data_canelamento    = sysdate');
  QryAx3.SQL.Add(' WHERE id                  = :id');

  QryAx3.Parameters.ParamByName('id').Value  := titulo_id;

  try
    // Tenta salvar os dados
    QryAx3.ExecSQL;
    // Confirma a transação
    ADOConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      Result := False;
    end;
  end;
end;

Function TControleMainModule.TituloPossuiAnexo(titulo_id: integer;
                                          possui_anexo: string): Boolean;
begin
  // Inicia a transação
  ADOConnection.BeginTrans;

  // Passo Unico - Salva os dados da cidade
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;

  // Update
  QryAx3.SQL.Add('UPDATE titulo SET');
  QryAx3.SQL.Add('       possui_anexo = '''+ copy(possui_anexo,1,1) +'''');
  QryAx3.SQL.Add(' WHERE id = :id');

  QryAx3.Parameters.ParamByName('id').Value := titulo_id;

  try
    // Tenta salvar os dados
    QryAx3.ExecSQL;
    // Confirma a transação
    ADOConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      Result := False;
    end;
  end;
end;

procedure TControleMainModule.ComprimirImagem(ACompression: integer; const AInFile: string; const AOutFile: string);
var
  iCompression: integer;
  oJPG: TJPegImage;
begin
  // Force Compression to range 1..100
  iCompression := abs(ACompression);
  if iCompression = 0 then
    iCompression := 1;
  if iCompression > 100 then
    iCompression := 100;

  // Create Jpeg and Bmp work classes
  oJPG := TJPegImage.Create;
  oJPG.LoadFromFile(AInFile);

  // Do the Compression and Save New File
  oJPG.CompressionQuality := iCompression;
  oJPG.Compress;
  oJPG.SaveToFile(AOutFile);

  // Clean Up
  freeandnil(oJPG);
end;

function TControleMainModule.GetFileSize(aFile: TFileName): Int64;
begin
  with TFileStream.Create(aFile, fmOpenRead or fmShareExclusive) do
  try
    Result := Size;
  finally
   Free;
  end;
end;

function TControleMainModule.SelecionaEmail(Pessoa_Id: Integer): String;
begin
  // Pesquisa o cpf/cnpj
  CdsAx1.Close;
  QryAx1.Parameters.Clear;
  QryAx1.SQL.Clear;
  QryAx1.SQL.Add('SELECT Email');
  QryAx1.SQL.Add('  FROM pessoa_endereco');
  QryAx1.SQL.Add(' WHERE pessoa_id = :pessoa_id');
  QryAx1.Parameters.ParamByName('pessoa_id').Value := Pessoa_Id;
  CdsAx1.Open;

  Result := CdsAx1.FieldByName('Email').AsString;
end;

Function TControleMainModule.SelecionaLink_Boleto(Titulo_id: Integer): String;
begin
  // Selecionando o titulos
  CdsAx2.Close;
  QryAx2.Parameters.Clear;
  QryAx2.SQL.Clear;
  QryAx2.SQL.Add('SELECT tir.link_boleto');
  QryAx2.SQL.Add('  FROM titulo tit');
  QryAx2.SQL.Add('  LEFT JOIN titulo_receber tir');
  QryAx2.SQL.Add('    ON tit.id = tir.id');
  QryAx2.SQL.Add(' WHERE tit.id = '+ IntToStr(titulo_Id) +'');
  CdsAx2.Open;

  Result := CdsAx2.fieldByname('link_boleto').AsString;
end;

Procedure TControleMainModule.CarregaListaDeArquivos(tabela_id: Integer;
                                                tabela_nome: String);
begin
  Try
    CdsListaArquivos.Close;
    QryListaArquivos.SQL.Clear;
    QryListaArquivos.SQL.Add('      SELECT id,');
    QryListaArquivos.SQL.Add('             descricao,');
    QryListaArquivos.SQL.Add('             caminho,');
    QryListaArquivos.SQL.Add('             tabela_id,');
    QryListaArquivos.SQL.Add('             tabela_nome,');
    QryListaArquivos.SQL.Add('             schema');
    QryListaArquivos.SQL.Add('        FROM documentos');
    QryListaArquivos.SQL.Add('       WHERE tabela_id   = '+ IntToStr(tabela_id) +'');
    QryListaArquivos.SQL.Add('         AND tabela_nome = '''+ tabela_nome +'''');
    QryListaArquivos.SQL.Add('         AND schema = '''+ FSchema +'''');
    CdsListaArquivos.Open;
  except
    on E : Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  end;
end;

procedure TControleMainModule.ApagarDocumento(tabela: String;
                                         Id: Integer);
var
  Erro: String;
begin
  Erro := '';
  // Inicia a transação
  ADOConnection.BeginTrans;

  // Inserindo o login do usuario em tabela temporaria,
  // Utilizado para auditoria
  Insere_Tabela_Temp_Login;

  QryAx1.Parameters.Clear;
  QryAx1.SQL.Clear;
  QryAx1.SQL.Text :=
      'DELETE FROM '+ tabela +''
    + ' WHERE id = :id';
  QryAx1.Parameters.ParamByName('id').Value := Id;

  try
    // Tenta apagar o registro
    QryAx1.ExecSQL;
  except
    on E: Exception do
    begin
      Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
      ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
    end;
  end;

  if Erro = '' then
  begin
    // Confirma a transação
    ADOConnection.CommitTrans;
  end
  else
  begin
    // Descarta a transação
    ADOConnection.RollbackTrans;
  end;
end;

procedure TControleMainModule.ConfirmaSalvarDocumento(Sender: TComponent; AResult:Integer; AText: string);
begin
  if AText = '' then
  begin
    Raise exception.Create('Você precisa digitar uma descrição para o documento');
    Abort;
  end;

  if ControleMainModule.SalvarDocumentos(AText,
                                 Copy(URL_LOGO_MAIN_MODULE, Pos('UploadFolder\', URL_LOGO_MAIN_MODULE), Length(URL_LOGO_MAIN_MODULE)),
                                 titulo_id_m,
                                 'TITULO') then
  begin
    ControleMainModule.cdsListaArquivos.Refresh;
    ControleMainModule.TituloPossuiAnexo(titulo_id_m,
                                    'S');
  end;
end;

function TControleMainModule.UltimoDia(Mes: TDateTime): integer;
var Date: TDateTime;
begin
  Date:= EndOfTheMonth(Mes);
  Result:= StrToInt(Copy(DateToStr(Date),0,2));
end;

procedure TControleMainModule.registra_movimento(caixa_id: integer;
                                            operacao,
                                            natureza:String;
                                            valor: Double;
                                            forma_pagamento_id: integer;
                                            Observacao: String);
begin
  // Passo Unico - Salva os dados
  QryAx2.Parameters.Clear;
  QryAx2.SQL.Clear;

  // Realiza o suprimento do caixa
  QryAx2.Parameters.Clear;
  QryAx2.SQL.Clear;
  QryAx2.SQL.Text :=
      'BEGIN'
    + '  pkg_caixa.registra_movimento ('
    + '    :caixa_id,'
    + '    :operacao,'
    + '    :natureza,'
    + '    SYSDATE,'
    + '    :valor,'
    + '    :forma_pagamento_id,'
    + '    NULL,'
    + '    NULL,'
    + '    NULL,'
    + '    :observacao);'
    + 'END;';
  QryAx2.Parameters.ParamByName('caixa_id').Value           := caixa_id;
  QryAx2.Parameters.ParamByName('operacao').Value           := operacao;//'C';   // Crédito
  QryAx2.Parameters.ParamByName('natureza').Value           := natureza;//'SU';  // Suprimento
  QryAx2.Parameters.ParamByName('valor').Value              := valor;
  QryAx2.Parameters.ParamByName('forma_pagamento_id').Value := forma_pagamento_id;
  QryAx2.Parameters.ParamByName('observacao').Value         := Observacao;

  try
    // Tenta executar a operação
    QryAx2.ExecSQL;
  except
    on E: Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  end;
end;

procedure TControleMainModule.EstornaMovimentoCaixa(caixa_movimento_id: integer;
                                               Observacao: String);
begin
  // Confirma a transação
  ADOConnection.BeginTrans;
  // Passo Unico - Salva os dados da cidade
  QryAx2.Parameters.Clear;
  QryAx2.SQL.Clear;

  // Estorna o movimento
  CdsAx2.Close;
  QryAx2.Parameters.Clear;
  QryAx2.SQL.Clear;
  QryAx2.SQL.Text :=
      'BEGIN'
    + '  pkg_caixa.estorna_movimento('
    + '    :caixa_movimento_id,'
    + '    :observacao);'
    + 'END;';
  QryAx2.Parameters.ParamByName('caixa_movimento_id').Value := caixa_movimento_id;
  QryAx2.Parameters.ParamByName('observacao').Value         := Observacao;

  try
    // Tenta executar a operação
    QryAx2.ExecSQL;
    ADOConnection.CommitTrans;
  except
    on E: Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  end;
end;

procedure TControleMainModule.FechaCaixa(CaixaId: Integer);
begin
  // Inicia a transação
  ADOConnection.BeginTrans;

  // Fecha o caixa
  CdsAx1.Close;
  QryAx1.Parameters.Clear;
  QryAx1.SQL.Clear;
  QryAx1.SQL.Text :=
      'UPDATE caixa'
    + '   SET data_fechamento = SYSDATE'
    + ' WHERE id = :id';
  QryAx1.Parameters.ParamByName('id').Value := CaixaId;

  try
    // Tenta salvar os dados
    QryAx1.ExecSQL();
    ADOConnection.CommitTrans;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  end;
end;

function TControleMainModule.VerificaNumeroCaixaAberto(UsuarioId: Integer): Integer;// retorna o id do caixa conectado, se for 0 é caixa novo
begin
  Result := 0;

  //verifica se tem mais de um caixa aberto e finaliza
  QuantosCaixasEmAbertos(UsuarioId);

  CdsAx2.Close;
  QryAx2.SQL.Clear;
  QryAx2.Parameters.Clear;
  QryAx2.SQL.Add('SELECT id,');
  QryAx2.SQL.Add('       data_abertura,');
  QryAx2.SQL.Add('       data_fechamento');
  QryAx2.SQL.Add('  FROM caixa');
  QryAx2.SQL.Add(' WHERE usuario_id = '+ IntToStr(UsuarioId) +'');
  QryAx2.SQL.Add('   AND TRUNC(data_abertura) = TRUNC(sysdate)');
  QryAx2.SQL.Add('   AND data_fechamento IS NULL');
  CdsAx2.Open;

  FDataAbertura := cdsAx2.FieldByName('data_abertura').AsDateTime;

  if CdsAx2.RecordCount > 0 then
    Result := CdsAx2.FieldByname('id').AsInteger;

end;


procedure TControleMainModule.QuantosCaixasEmAbertos(IdDoUsuario : Integer);
var
  UltimoCaixaId : Integer;
begin
   //verifica quantos caixas tem em aberto
  CdsAx3.Close;
  QryAx3.SQL.Clear;
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;
  QryAx3.SQL.Text := '  SELECT id                                     '
                    +'  FROM caixa                                    '
                    +' WHERE usuario_id = '+ IntToStr(IdDoUsuario) +'   '
                    +'   AND data_fechamento IS NULL                  '
                    +'   ORDER BY 1 DESC                              ';
  CdsAx3.Open;

  if CdsAx3.RecordCount >1 then
  begin
    // Inicia a transação
    with ControleMainModule do
    begin
      if ADOConnection.Connected = false then
          ADOConnection.Open;

      if ADOConnection.InTransaction = False then
        ADOConnection.BeginTrans;
    end;

    //vá para o inicio e pegue o primeiro registro
    CdsAx3.First;
    UltimoCaixaId :=  CdsAx3.FieldByName('id').AsInteger;

    QryAx4.Parameters.Clear;
    QryAx4.SQL.Clear;
    QryAx4.SQL.Text := 'UPDATE caixa SET                        '
                      +'       data_fechamento = TRUNC(sysdate) '
                      +' WHERE id < :IdDoCaixa                  ';

    QryAx4.Parameters.ParamByName('IdDoCaixa').Value := UltimoCaixaId;

    try
      // Tenta salvar os dados
      QryAx4.ExecSQL;
      // Confirma a transação
      ADOConnection.CommitTrans;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
        Exit;
      end;
    end;
  end;
end;

function TControleMainModule.CriaCaixa: Boolean;
var
  CadastroId: Integer;
begin
  inherited;

  Result := False;

  // ABERTURA//////////////////////////////////////////////////////////
  // Inicia a transação
  ADOConnection.BeginTrans;

  // Passo Unico - Salva os dados do caixa
  QryAx1.Parameters.Clear;
  QryAx1.SQL.Clear;

  CadastroId := 0;
  if CadastroId = 0 then
  begin
    // Gera um novo id para a tabela caixa
    CadastroId := GeraId('caixa');
    // Insert
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Text :=
        'INSERT INTO caixa ('
      + '       id,'
      + '       filial_id,'
      + '       usuario_id,'
      + '       data_abertura)'
      + 'VALUES ('
      + '       :id,'
      + '       :filial_id,'
      + '       :usuario_id,'
      + '       SYSDATE)';
  end
  else
  begin
    // Update
    QryAx1.SQL.Add('UPDATE caixa SET');
    QryAx1.SQL.Add('       filial_id       = :filial_id,');
    QryAx1.SQL.Add('       usuario_id      = :usuario_id');
    QryAx1.SQL.Add(' WHERE id              = :id');
  end;

  QryAx1.Parameters.ParamByName('id').Value              := CadastroId;
  QryAx1.Parameters.ParamByName('filial_id').Value       := FFilial;
  QryAx1.Parameters.ParamByName('usuario_id').Value      := FUsuarioId;
  // QryAx1.Parameters.ParamByName('pdv_id').Value          := 0;// Falta aplicar

  try
    // Tenta salvar os dados
    QryAx1.ExecSQL;
    // Confirma a transação
    ADOConnection.CommitTrans;

    Result := True;
    ControleMainModule.FNumeroCaixaLogado := CadastroId;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));

      Exit;
    end;
  end;
end;

function TControleMainModule.VerificaCaixaAberto(UsuarioId: Integer): Boolean;// retorna o id do caixa conectado, se for 0 é caixa novo
begin
  Result := False;

  CdsAx2.Close;
  QryAx2.SQL.Clear;
  QryAx2.Parameters.Clear;
  QryAx2.SQL.Add('SELECT id,');
  QryAx2.SQL.Add('       data_fechamento');
  QryAx2.SQL.Add('  FROM caixa');
  QryAx2.SQL.Add(' WHERE id = '+ IntToStr(UsuarioId) +'');
  QryAx2.SQL.Add('   AND data_fechamento IS NULL');
  CdsAx2.Open;

  if CdsAx2.RecordCount > 0 then
    Result := True;
end;

function TControleMainModule.ValidandoUsuario(UserName, Password: String): Boolean;
begin
  Result := False;

  Try
    // Verificando se o usuário existe
    with ControleMainModule do
    begin
      // Pesquisando na database usuario
      CdsUsuario.Close;
      QryUsuario.SQL.Clear;
      QryUsuario.SQL.Text := 'SELECT usr.id,'
                            +'       usr.login,'
                            +'       usr.senha,'
                            +'       usr.ativo,'
                            +'       usr.schema,'
                            +'       usr.representante_id'
                            +'  FROM usuario usr'
                            +' WHERE UPPER(usr.login)  = :login'
                            +'   AND UPPER(usr.senha)  = :senha';
      QryUsuario.Parameters.ParamByName('login').Value := UpperCase(Trim(UserName));
      QryUsuario.Parameters.ParamByName('senha').Value := UpperCase(Trim(Password));
      CdsUsuario.Open;


      // Atribuindo o nome
      FUsuarioId   := CdsUsuario.FieldByName('id').AsInteger;
      FNomeUsuario := CdsUsuario.FieldByName('login').AsString;
      FRepresentante := CdsUsuario.FieldByName('representante_id').AsInteger;

      // Carregando as permissões do controle
      CdsUsuarioPermissao.Close;
      QryUsuarioPermissao.SQL.Clear;
      QryUsuarioPermissao.SQL.Text := 'SELECT usp.id,'
                                     +'       usp.usuario_id,'
                                     +'       menu_cliente_botao,'
                                     +'       menu_empresa_botao,'
                                     +'       menu_cidades_botao,'
                                     +'       menu_dashboard_botao,'
                                     +'       menu_auditoria_botao,'
                                     +'       menu_usuarios_botao,'
                                     +'       menu_cadastro_botao,'
                                     +'       menu_schema_botao,'
                                     +'       menu_schema_cadastro_botao,'
                                     +'       menu_fornecedor_botao,'
                                     +'       menu_banco_botao,'
                                     +'       menu_contabancaria_botao,'
                                     +'       menu_titulospagar_botao,'
                                     +'       menu_titulosreceber_botao,'
                                     +'       menu_tipotitulo_botao,'
                                     +'       menu_destinocheque_botao,'
                                     +'       menu_cliente_repres_botao,'
                                     +'       menu_dados_repres_botao,'
                                     +'       menu_recebiveis_repres_botao,'
                                     +'       menu_caixa_botao,'
                                     +'       menu_chequesrecebidos_botao,'
                                     +'       menu_chequesdepositados_botao,'
                                     +'       menu_categoriatitulo_botao,'
                                     +'       menu_categoriaproduto_botao,'
                                     +'       menu_tabelapreco_botao,'
                                     +'       menu_prod_tabpreco_excec_botao,'
                                     +'       menu_produto_embalagem_botao,'
                                     +'       menu_grupotributos_botao,'
                                     +'       menu_relatorio_botao,'
                                     +'       menu_intcontaspagar_botao,'
                                     +'       menu_intcontasreceber_botao,'
                                     +'       menu_desconto_vale_botao'
                                     +'  FROM usuario_permissao_controle usp'
                                     +' WHERE usp.usuario_id  = :usuario_id';
      QryUsuarioPermissao.Parameters.ParamByName('usuario_id').Value := CdsUsuario.FieldByName('id').AsString;
      CdsUsuarioPermissao.Open;

      ControleMainModule.FFilial := 1; // Essa versão nao trabalha com multiempresa, ficou para uma versao futura?!
     if CdsUsuarioPermissao.RecordCount >0 then
      Result := True;
    end;
  Except
    on e:exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção!', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  End;
end;

function TControleMainModule.FolderSize(Dir: string): double;
var
  SearchRec: TSearchRec;
  Separator: string;
begin
  SearchRec.Size := 0;
  Result := 0;
  if Copy(Dir,Length(Dir),1)='\' then
    Separator := ''
  else
    Separator := '\';
  if FindFirst(Dir+Separator+'*.*', faAnyFile, SearchRec) = 0 then
  begin
    if FileExists(Dir+Separator+SearchRec.Name) then
    begin
      DirBytes := DirBytes + SearchRec.Size;
    end
    else if DirectoryExists(Dir+Separator+SearchRec.Name) then
    begin
      if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
      begin
        FolderSize(Dir+Separator+SearchRec.Name);
      end;
    end;
    while FindNext(SearchRec) = 0 do
    begin
      if FileExists(Dir+Separator+SearchRec.Name) then
      begin
        DirBytes := DirBytes + SearchRec.Size;
      end
      else if DirectoryExists(Dir+Separator+SearchRec.Name) then
      begin
        if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
        begin
          FolderSize(Dir+Separator+SearchRec.Name) ;
        end;
      end;
    end;
  end;
  SysUtils.FindClose(SearchRec) ;
  Result := DirBytes;
end;

procedure TControleMainModule.UltimoLogin(id : integer);
begin
  // Inicia a transação
  ADOConnection.BeginTrans;
  // Passo 1 - Salva os dados da pessoa
  QryAx4.Parameters.Clear;
  QryAx4.SQL.Clear;
  // Update
  QryAx4.SQL.Add('UPDATE usuario.usuario');
  QryAx4.SQL.Add('   SET ultimo_login = :data');
  QryAx4.SQL.Add(' WHERE id                = :id');

  QryAx4.Parameters.ParamByName('id').Value := id;
  QryAx4.Parameters.ParamByName('data').Value := Date;

  try
    // Tenta salvar os dados
      QryAx4.ExecSQL;
      ADOConnection.CommitTrans;
    except
    on E: Exception do
    begin
       ADOConnection.RollbackTrans;
    end;
  end;
end;


function TControleMainModule.ContaAgendaRealizada():integer;
begin
  // Carregando as permissões do usuário
  CdsAx3.Close;
  QryAx3.SQL.Clear;
  QryAx3.SQL.Text := 'SELECT count(*) conta'
                    +'  FROM agendamento'
                    +' WHERE datahora_inicio between trunc(SYSDATE,''MM'') and trunc(LAST_DAY(SYSDATE))';
  CdsAx3.Open;

  Result       := CdsAx3.FieldByName('conta').AsInteger;
end;

function TControleMainModule.ContaAvaliacoesCadastradas():integer;
begin
  // Carregando as permissões do usuário
  CdsAx4.Close;
  QryAx4.SQL.Clear;
  QryAx4.SQL.Text := 'SELECT count(*) conta'
                    +'  FROM avaliacao';
  CdsAx4.Open;

  Result       := CdsAx4.FieldByName('conta').AsInteger;
end;



//function TControleMainModule.PlanoSistemaHDControle(plano: String):double;
//begin
//  // Carregando as permissões do usuário
//  CdsAx6.Close;
//  QryAx6.SQL.Clear;
//  QryAx6.SQL.Text := 'SELECT id,'
//                    +'       descricao,'
//                    +'       valor,'
//                    +'       tamanho_max_hd_bytes'
//                    +'  FROM fonte.param_controle_planos'
//                    +' WHERE descricao  = :plano';
//  QryAx6.Parameters.ParamByName('plano').Value := plano;
//  CdsAx6.Open;
//
//  Result := CdsAx6.FieldByName('tamanho_max_hd_bytes').AsInteger;
//end;

Function TControleMainModule.ModeloPossuiAnexo(Modelo_id: integer;
                                               possui_anexo: string): Boolean;
begin
  // Inicia a transação
  ADOConnection.BeginTrans;

  // Passo Unico - Salva os dados da cidade
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;

  // Update
  QryAx3.SQL.Add('UPDATE modelo SET');
  QryAx3.SQL.Add('       possui_anexo = '''+ copy(possui_anexo,1,1) +'''');
  QryAx3.SQL.Add(' WHERE id = :id');

  QryAx3.Parameters.ParamByName('id').Value := modelo_id;

  try
    // Tenta salvar os dados
    QryAx3.ExecSQL;
    // Confirma a transação
    ADOConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      Result := False;
    end;
  end;
end;

procedure TControleMainModule.ConfirmaSalvarDocumentoModelo(Sender: TComponent; AResult:Integer; AText: string);
begin
  if AText = '' then
  begin
    Raise exception.Create('Você precisa digitar uma descrição para o documento');
    Abort;
  end;

  if ControleMainModule.SalvarDocumentos(AText,
                                 Copy(URL_LOGO_MAIN_MODULE, Pos('UploadFolder\', URL_LOGO_MAIN_MODULE), Length(URL_LOGO_MAIN_MODULE)),
                                 modelo_id_m,
                                 'MODELO') then
  begin
    ControleMainModule.cdsListaArquivos.Refresh;
    ControleMainModule.ModeloPossuiAnexo(Modelo_id_m,
                                        'S');
  end;
end;

Function TControleMainModule.GravandoTituloReceber(CondicoesPagamentoId: Integer;
                                                   IdTituloCategoria: Integer;
                                                   PessoaId: Integer;
                                                   Natureza: String; // C - Cobranca | L - Liquidação
                                                   NumeroDocumento: String; // Caso queira relacionar com uma pre-venda de produtos/serviços
                                                   DataVencimento: TDateTime;
                                                   Valor: Double;
                                                   Desconto: Double;
                                                   Observacao: String;
                                                   IntervaloProprio: Integer; // Data do dia
                                                   NumeroParcelas: Integer;
                                                   NumeroReferencia: string): Boolean;
Var
 I, H: Integer;
 CadastroId, DiaPadrao: Integer;
 PrimeiraDataDoCarne : TDateTime;
 Erro : String;
begin
  Result := False;

  // Se for igual a zero, indica que o título
  // nao veio de prevenda, por isso precisa de uma
  // numeração propria, que será o numero do titulo Pai
  NumeroDocumentoTitulo := NumeroDocumento;
  DiaPadrao := 0;

  H := 1;

  Erro := '';
  PrimeiraDataDoCarne := 0;
  // Criando os títulos
  // Inicia a transação
  if ControleMainModule.ADOConnection.InTransaction = False then
    ControleMainModule.ADOConnection.BeginTrans;
  for I := 1 to NumeroParcelas do
  begin
    with ControleMainModule do
    begin
      // Gravando a primeira data, para geração do carne do gerencianet
      if PrimeiraDataDoCarne = 0 then
         PrimeiraDataDoCarne := DataVencimento;

      // Passo Unico - Salva os dados da cidade
      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;

      // Gera um novo id para a tabela titulo
      CadastroId := GeraId('titulo');

      // Atribuindo o mesmo número do título inicial
      // Esse número se repete em todos os títulos
      if NumeroDocumentoTitulo = '0' then
        NumeroDocumentoTitulo := IntToStr(CadastroId);

      // Insert
      QryAx1.SQL.Add('INSERT INTO titulo (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       filial_id,');
      QryAx1.SQL.Add('       condicoes_pagamento_id,');
      QryAx1.SQL.Add('       titulo_categoria_id,');
      QryAx1.SQL.Add('       natureza,');
      QryAx1.SQL.Add('       numero_documento,');
      QryAx1.SQL.Add('       data_emissao,');
      QryAx1.SQL.Add('       data_vencimento,');
      QryAx1.SQL.Add('       data_venc_original,');
      QryAx1.SQL.Add('       valor,');
      QryAx1.SQL.Add('       valor_original,');
      QryAx1.SQL.Add('       valor_desconto,');
      QryAx1.SQL.Add('       situacao,');
      QryAx1.SQL.Add('       data_liquidacao,');
      QryAx1.SQL.Add('       data_cancelamento,');
      QryAx1.SQL.Add('       valor_juros,');
      QryAx1.SQL.Add('       valor_multa,');
      QryAx1.SQL.Add('       valor_pago,');
      QryAx1.SQL.Add('       valor_liquidado,');
      QryAx1.SQL.Add('       historico,');
      QryAx1.SQL.Add('       observacao,');
      QryAx1.SQL.Add('       sequencia_parcelas,');
      QryAx1.SQL.Add('       numero_referencia)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :filial_id,');
      QryAx1.SQL.Add('       :condicoes_pagamento_id,');
      QryAx1.SQL.Add('       :titulo_categoria_id,');
      QryAx1.SQL.Add('       :natureza,');
      QryAx1.SQL.Add('       :numero_documento,');
      QryAx1.SQL.Add('       SYSDATE,');
      QryAx1.SQL.Add('       :data_vencimento,');
      QryAx1.SQL.Add('       :data_venc_original,'); // Coloca a mesma data do vencimento, caso altere a data de vencimento esta continuará intacta
      QryAx1.SQL.Add('       :valor,');
      QryAx1.SQL.Add('       :valor_original,');
      QryAx1.SQL.Add('       :valor_desconto,');
      QryAx1.SQL.Add('       ''A'','); // Marca o título como aberto
      QryAx1.SQL.Add('       NULL,');
      QryAx1.SQL.Add('       NULL,');
      QryAx1.SQL.Add('       ''0.00'',');
      QryAx1.SQL.Add('       ''0.00'',');
      QryAx1.SQL.Add('       ''0.00'',');
      QryAx1.SQL.Add('       ''0.00'',');
      QryAx1.SQL.Add('       :historico,');
      QryAx1.SQL.Add('       :observacao,');
      QryAx1.SQL.Add('       :sequencia_parcelas,');
      QryAx1.SQL.Add('       :numero_referencia)');

      QryAx1.Parameters.ParamByName('id').Value                     := CadastroId;
      QryAx1.Parameters.ParamByName('filial_id').Value              := 1;
      QryAx1.Parameters.ParamByName('condicoes_pagamento_id').Value := CondicoesPagamentoId;
      QryAx1.Parameters.ParamByName('titulo_categoria_id').Value    := IdTituloCategoria;
      // C - Cobranca | L - Liquidação
      QryAx1.Parameters.ParamByName('natureza').Value               := 'C';
      QryAx1.Parameters.ParamByName('numero_documento').Value       := NumeroDocumentoTitulo;
      QryAx1.Parameters.ParamByName('data_vencimento').Value        := DataVencimento;
      QryAx1.Parameters.ParamByName('data_venc_original').Value     := DataVencimento;
      QryAx1.Parameters.ParamByName('valor').Value                  := Valor;
      QryAx1.Parameters.ParamByName('valor_original').Value         := Valor;
      QryAx1.Parameters.ParamByName('valor_desconto').Value         := Desconto;
      QryAx1.Parameters.ParamByName('historico').Value              := Observacao;
      QryAx1.Parameters.ParamByName('Observacao').Value             := Observacao;
      QryAx1.Parameters.ParamByName('sequencia_parcelas').Value     := H;
      QryAx1.Parameters.ParamByName('numero_referencia').Value      := NumeroReferencia;

      try
        // Tenta salvar os dados
        QryAx1.ExecSQL;

        // Se intervalo próprio for igual a 30 é mensal, substitui por (data fixa)
        if IntervaloProprio = 30 then
          begin
            DataVencimento := RetornaDataProximoTitulo(DataVencimento);
          end
        else
          DataVencimento := DataVencimento + IntervaloProprio;

        H := I + 1;
      except
        on E: Exception do
        begin
          Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
          ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
        end;
      end;

      // Passo 2 - Salva os dados do titulo a receber
      if Erro = '' then
      begin
        QryAx2.Parameters.Clear;
        QryAx2.SQL.Clear;

        // Insert
        QryAx2.SQL.Add('INSERT INTO titulo_receber (');
        QryAx2.SQL.Add('       id,');
        QryAx2.SQL.Add('       cliente_id)');
        QryAx2.SQL.Add('VALUES (');
        QryAx2.SQL.Add('       :id,');
        QryAx2.SQL.Add('       :cliente_id)');

        QryAx2.Parameters.ParamByName('id').Value           := CadastroId; // O id do titulo a receber será igual ao id do titulo
        QryAx2.Parameters.ParamByName('cliente_id').Value    := PessoaId;

        try
          // Tenta salvar os dados
          QryAx2.ExecSQL;
        except
          on E: Exception do
          begin
            Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
            ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
          end;
        end;
      end;
    end;
  end;

  if Erro = '' then
  begin
    ControleMainModule.ADOConnection.CommitTrans;
    Result := True;
  end
  else
  begin
    // Descarta a transação
    ControleMainModule.ADOConnection.RollbackTrans;
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não foi possível salvar os dados alterados');
  end;

  DiaPadrao := 0
end;


function TControleMainModule.CondicoesPagGeraChCaBo(id_cond_pag : Integer; Gera :string): Boolean;
begin
  Result := False;

  CdsAx4.Close;
  QryAx4.SQL.Clear;
  QryAx4.SQL.Text :=
                 '  SELECT id,'
                +'         descricao,'
                +'         tipo,'
                +'         ordem_exibicao,'
                +'         gera_carne,'
                +'         gera_boleto,'
                +'         gera_cheque'
                +'    FROM condicoes_pagamento'
                +'    WHERE id= :p_id';
  QryAx4.Parameters.ParamByName('p_id').Value := id_cond_pag;
  CdsAx4.Open;

  if CdsAx4.RecordCount >0 then
  begin
    case AnsiIndexStr(UpperCase(Gera),['GERA_CARNE','GERA_BOLETO','GERA_CHEQUE']) of
      0:begin
          if CdsAx4.FieldByName('gera_carne').AsString  = 'S' then
           Result := True;
        end;
      1:begin
          if CdsAx4.FieldByName('gera_boleto').AsString  = 'S' then
           Result := True;
        end;
      2:begin
          if CdsAx4.FieldByName('gera_cheque').AsString  = 'S' then
           Result := True;
        end;
    end;
  end;
end;



Function TControleMainModule.GravandoTituloPagar(CondicoesPagamentoId: Integer;
                                                 IdTituloCategoria: Integer;
                                                 PessoaId: Integer;
                                                 Natureza: String; // C - Cobranca | L - Liquidação
                                                 NumeroDocumento: String; // Caso queira relacionar com uma pre-venda de produtos/serviços
                                                 DataVencimento: TDateTime;
                                                 Valor: Double;
                                                 Desconto: Double;
                                                 Observacao: String;
                                                 IntervaloProprio: Integer; // Data do dia
                                                 NumeroParcelas: Integer;
                                                 NumeroReferencia: string): Boolean;
Var
 I, H: Integer;
 CadastroId, DiaPadrao: Integer;
 PrimeiraDataDoCarne : TDateTime;
 Erro : String;
begin
  Result := False;

  // Se for igual a zero, indica que o título
  // nao veio de prevenda, por isso precisa de uma
  // numeração propria, que será o numero do titulo Pai
  NumeroDocumentoTitulo := NumeroDocumento;
  DiaPadrao := 0;

  H := 1;

  Erro := '';
  PrimeiraDataDoCarne := 0;
  // Criando os títulos
  // Inicia a transação
  ControleMainModule.ADOConnection.BeginTrans;

  for I := 1 to NumeroParcelas do
  begin
    with ControleMainModule do
    begin
      // Gravando a primeira data, para geração do carne do gerencianet
      if PrimeiraDataDoCarne = 0 then
         PrimeiraDataDoCarne := DataVencimento;

      // Passo Unico - Salva os dados da cidade
      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;

      // Gera um novo id para a tabela titulo
      CadastroId := GeraId('titulo');

      // Atribuindo o mesmo número do título inicial
      // Esse número se repete em todos os títulos
      if NumeroDocumentoTitulo = '0' then
      begin
        NumeroDocumentoTitulo := IntToStr(CadastroId);
      end;

      // Insert
      QryAx1.SQL.Add('INSERT INTO titulo (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       filial_id,');
      QryAx1.SQL.Add('       condicoes_pagamento_id,');
      QryAx1.SQL.Add('       titulo_categoria_id,');
      QryAx1.SQL.Add('       natureza,');
      QryAx1.SQL.Add('       numero_documento,');
      QryAx1.SQL.Add('       data_emissao,');
      QryAx1.SQL.Add('       data_vencimento,');
      QryAx1.SQL.Add('       data_venc_original,');
      QryAx1.SQL.Add('       valor,');
      QryAx1.SQL.Add('       valor_original,');
      QryAx1.SQL.Add('       valor_desconto,');
      QryAx1.SQL.Add('       situacao,');
      QryAx1.SQL.Add('       data_liquidacao,');
      QryAx1.SQL.Add('       data_cancelamento,');
      QryAx1.SQL.Add('       valor_juros,');
      QryAx1.SQL.Add('       valor_multa,');
      QryAx1.SQL.Add('       valor_pago,');
      QryAx1.SQL.Add('       valor_liquidado,');
      QryAx1.SQL.Add('       historico,');
      QryAx1.SQL.Add('       observacao,');
      QryAx1.SQL.Add('       sequencia_parcelas,');
      QryAx1.SQL.Add('       numero_referencia)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :filial_id,');
      QryAx1.SQL.Add('       :condicoes_pagamento_id,');
      QryAx1.SQL.Add('       :titulo_categoria_id,');
      QryAx1.SQL.Add('       :natureza,');
      QryAx1.SQL.Add('       :numero_documento,');
      QryAx1.SQL.Add('       SYSDATE,');
      QryAx1.SQL.Add('       :data_vencimento,');
      QryAx1.SQL.Add('       :data_venc_original,'); // Coloca a mesma data do vencimento, caso altere a data de vencimento esta continuará intacta
      QryAx1.SQL.Add('       :valor,');
      QryAx1.SQL.Add('       :valor_original,');
      QryAx1.SQL.Add('       :valor_desconto,');
      QryAx1.SQL.Add('       ''A'','); // Marca o título como aberto
      QryAx1.SQL.Add('       NULL,');
      QryAx1.SQL.Add('       NULL,');
      QryAx1.SQL.Add('       ''0.00'',');
      QryAx1.SQL.Add('       ''0.00'',');
      QryAx1.SQL.Add('       ''0.00'',');
      QryAx1.SQL.Add('       ''0.00'',');
      QryAx1.SQL.Add('       :historico,');
      QryAx1.SQL.Add('       :observacao,');
      QryAx1.SQL.Add('       :sequencia_parcelas,');
      QryAx1.SQL.Add('       :numero_referencia)');

      QryAx1.Parameters.ParamByName('id').Value                 := CadastroId;
      QryAx1.Parameters.ParamByName('filial_id').Value          := 1;
      QryAx1.Parameters.ParamByName('condicoes_pagamento_id').Value     := CondicoesPagamentoId;
      QryAx1.Parameters.ParamByName('titulo_categoria_id').Value := IdTituloCategoria;
      // C - Cobranca | L - Liquidação
      QryAx1.Parameters.ParamByName('natureza').Value           := 'C';
      QryAx1.Parameters.ParamByName('numero_documento').Value   := NumeroDocumento;
      QryAx1.Parameters.ParamByName('data_vencimento').Value    := DataVencimento;
      QryAx1.Parameters.ParamByName('data_venc_original').Value := DataVencimento;
      QryAx1.Parameters.ParamByName('valor').Value              := Valor;
      QryAx1.Parameters.ParamByName('valor_original').Value     := Valor;
      QryAx1.Parameters.ParamByName('valor_desconto').Value     := Desconto;
      QryAx1.Parameters.ParamByName('historico').Value          := Observacao;
      QryAx1.Parameters.ParamByName('Observacao').Value         := Observacao;
      QryAx1.Parameters.ParamByName('sequencia_parcelas').Value := H;
      QryAx1.Parameters.ParamByName('numero_referencia').Value  := NumeroReferencia;

      try
        // Tenta salvar os dados
        QryAx1.ExecSQL;

        // Se intervalo próprio for igual a 30 é mensal, substitui por (data fixa)
        if IntervaloProprio = 30 then
          begin
            DataVencimento := RetornaDataProximoTitulo(DataVencimento);
          end
        else
          DataVencimento := DataVencimento + IntervaloProprio;

        H := I + 1;
      except
        on E: Exception do
        begin
          Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
          ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
        end;
      end;

      // Passo 2 - Salva os dados do titulo a receber
      if Erro = '' then
      begin
        QryAx2.Parameters.Clear;
        QryAx2.SQL.Clear;

        // Insert
        QryAx2.SQL.Add('INSERT INTO titulo_pagar (');
        QryAx2.SQL.Add('       id,');
        QryAx2.SQL.Add('       fornecedor_id)');
        QryAx2.SQL.Add('VALUES (');
        QryAx2.SQL.Add('       :id,');
        QryAx2.SQL.Add('       :fornecedor_id)');

        QryAx2.Parameters.ParamByName('id').Value             := CadastroId; // O id do titulo a receber será igual ao id do titulo
        QryAx2.Parameters.ParamByName('fornecedor_id').Value  := PessoaId;

        try
          // Tenta salvar os dados
          QryAx2.ExecSQL;
        except
          on E: Exception do
          begin
            Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
            ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
          end;

        end;
      end;
    end;
  end;

  if Erro = '' then
  begin
    try
      ControleMainModule.ADOConnection.CommitTrans;
      Result := True;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ControleMainModule.ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
    end;
  end
  else
  begin
    // Descarta a transação
    ControleMainModule.ADOConnection.RollbackTrans;
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não foi possível salvar os dados alterados');
  end;

  DiaPadrao := 0
end;

Function TControleMainModule.RetornaDataProximoTitulo(DataVenc: TDateTime): TDateTime;
var
  Dia, Mes, Ano : Word;
  Data_teste : TDateTime;
begin
  Data_teste := DataVenc;
  DecodeDate(DataVenc, Ano, Mes, Dia);

//  if DiaPadrao = 0 then
//    DiaPadrao := Dia;
//
//  if DiaPadrao <> 0 then
//    Dia := DiaPadrao;

  if Mes = 12 then
  begin
     Mes := 0;
     Ano := Ano + 1;
  end;

  Mes := Mes + 1;

  if Mes = 2 then
  begin
    // Fevereiro
    if Dia > 28 then
      if IsLeapYear(Ano) then
        Dia := 29
      else
        Dia := 28;
  end
  else if Mes = 4 then
  begin
    //Abril
    if dia = 31 then
      dia := 30;
  end
  else if Mes = 6 then
  begin
    //Junho
    if dia = 31 then
      dia := 30;
  end
  else if Mes = 9 then
  begin
    //Setembro
    if dia = 31 then
      dia := 30;
  end
  else if Mes = 11 then
  begin
    //Novembro
    if dia = 31 then
      dia := 30;
  end;

  Try
    Result := EncodeDate(Ano, Mes, Dia);
  Except
   on e:Exception do
    ControleMainModule.MensageiroSweetAlerta('Atenção',ControleFuncoes.RetiraAspaSimples(e.Message));
  End;
end;

procedure TControleMainModule.MensageiroSweetAlerta(Titulo, Texto: string; tipoAlerta: tAlertType = atError);
begin
  // Essa função pode ser usada em qualquer tela
  try
    MensageiroSweetAlert := TUniSweetAlert.Create(UniApplication);
    With MensageiroSweetAlert do
    begin
      Text                := Texto;
      Title               := Titulo;
      AlertType           := tipoAlerta;
      ConfirmButtonText   := 'OK';
      Show;
    end;
  finally
    MensageiroSweetAlert.Free;
  end;
end;

procedure TControleMainModule.ExportarPDF(arquivoPDF: string; Report: TfrxReport);
var
  assinatura, logo: string;
  imgLogo, imgAssinatura: TfrxPictureView;
  textoassinatura: TfrxMemoView;
  thr: TThread;
begin
  try
    Report.PrintOptions.ShowDialog := False;
    Report.ShowProgress := false;

    Report.EngineOptions.SilentMode := True;
    Report.EngineOptions.EnableThreadSafe := True;
    Report.EngineOptions.DestroyForms := False;
    Report.EngineOptions.UseGlobalDataSetList := False;

    frxPDFExport1.Background := True;
    frxPDFExport1.ShowProgress := False;
    frxPDFExport1.ShowDialog := False;
    frxPDFExport1.FileName := ControleServerModule.NewCacheFileUrl(False, 'pdf', '', '', arquivoPDF, True);
    frxPDFExport1.DefaultPath := '';

    thr := TThread.CurrentThread;
    Report.EngineOptions.ReportThread := thr;
    Report.PreviewOptions.AllowEdit := False;
    Report.PrepareReport;
    Report.Export(frxPDFExport1);

    if FileExists(frxPDFExport1.FileName) then
    begin
      ControleImpressaoDocumento.UniURLFrame1.URL := arquivoPDF;
      ControleImpressaoDocumento.ShowModal;
    end
    else
      ControleMainModule.MensageiroSweetAlerta('Atenção','Falha ao gerar PDF, tente novamente!');
  except
    raise Exception.Create('Não foi possível concluir a operação, entre em contato com o suporte.');
  end;
end;


Function TControleMainModule.SelecioPedidoCabecalhoGestor(num_pedido: Integer): TClientDataset;
begin
  Try
    CdsAx1.Close;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Text :=  'SELECT p.cpf_cnpj,'
	                     +'       p.razao_social,'
                       +'	    	(SELECT SUM(VALOR_PAGO)'
                       +'   		   FROM GESTOR.TITULO_PAGAMENTO tp'
                       +' 		     LEFT JOIN GESTOR.FORMA_PAGAMENTO fp'
                       +'     	     ON fp.ID = tp.FORMA_PAGAMENTO_ID'
                       +'  	      WHERE	TITULO_ID = t.id'
                       +'    	      AND fp.GERA_NOVO_TITULO = ''S'') valor_total,'
                       +'	    	T.id numero_titulo,'
                       +'		    pv.cliente_id'
                       +'  FROM GESTOR.PEDIDO_VENDA pv'
                       +'  LEFT JOIN GESTOR.PEDIDO_VENDA_ITEM pvi'
                       +'    ON	pvi.PEDIDO_VENDA_ID = pv.ID'
                       +'  LEFT JOIN GESTOR.CLIENTE c'
                       +'    ON c.ID = pv.CLIENTE_ID'
                       +'  LEFT JOIN GESTOR.PESSOA p'
                       +'    ON	p.ID = c.ID'
                       +'  LEFT JOIN GESTOR.TITULO t'
                       +'    ON t.PEDIDO_VENDA_ID = pv.ID'
                       +' WHERE pv.id  = :num_pedido';

    QryAx1.Parameters.ParamByName('num_pedido').Value := num_pedido;
    CdsAx1.Open;
  Finally
    Result := CdsAx1;
  End;
end;

function TControleMainModule.SelecioPedidoItensGestor(num_pedido: Integer): TClientDataset;
begin
  Try
    CdsAx2.Close;
    QryAx2.SQL.Clear;
    QryAx2.SQL.Text :=   'SELECT pvi.produto_id cod_prod,'
                        +'       pvi.quantidade,'
                        +'       pvi.valor_unitario,'
                        +'       pvi.desconto,'
                        +'       pvi.valor_total,'
                        +'       p.descricao nome_prod'
                        +'  FROM GESTOR.PEDIDO_VENDA pv'
                        +'  LEFT JOIN GESTOR.PEDIDO_VENDA_ITEM pvi'
                        +'    ON pvi.PEDIDO_VENDA_ID = pv.ID'
                        +'  LEFT JOIN GESTOR.PRODUTO p'
                        +'    ON p.ID = pvi.PRODUTO_ID'
                        +' WHERE pv.id  = :num_pedido';
    QryAx2.Parameters.ParamByName('num_pedido').Value := num_pedido;
    CdsAx2.Open;
  Finally
    Result := CdsAx1;
  End;
end;

function TControleMainModule.SelecionaCliente(cpf_cnpj: string): TClientDataSet;
begin
  Try
    CdsAx1.Close;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Text :=   'SELECT id,'
                        +'       razao_social'
                        +'  FROM PESSOA pes'
                        +' WHERE pes.cpf_cnpj  = :cpf_cnpj';
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value := cpf_cnpj;
    CdsAx1.Open;
  Finally
    Result := CdsAx1;
  End;
end;

Function TControleMainModule.CalculaJurosMulta(Data: TDateTime;
                                               Valor_original: Double;
                                               Juros: Double;
                                               Multa: Double;
                                               Dias_Atraso: Integer;
                                               Desconto: Double): TCalJurosMulta;
  Function AnoBiSexto(Ayear: Integer): Boolean;
  begin
    // Verifica se o ano é Bi-Sexto
    Result := (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or
    (AYear mod 400 = 0));
  end;

  function DiasPorMes(Ayear, AMonth: Integer): Integer;
  const DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  begin
    Result := DaysInMonth[AMonth];
    if (AMonth = 2) and AnoBiSexto(AYear) then
      Inc(Result);
  end;
var
  Percet_Dia     :Real;
  Novo_Valor     :Real;
  dia, mes, ano : Word;
begin
  Try
    Percet_Dia     := 0;
    Novo_Valor     := 0;

    // Dias do mês
    DecodeDate(Data, ano, mes, dia);
    // Calculando o percentual por dia
    Percet_Dia := Juros / DiasPorMes(ano, mes);
    // Calculo dos juros diário
    Juros:=(Valor_Original)*(Percet_Dia)/100;
    // Calculo dos juros pelos dias em atraso
    Juros:=RoundTo(Juros,-2)*Dias_Atraso;
    // Calculando a multa
    Multa := (Valor_Original * Multa)/100;
    Multa := RoundTo(Multa,-2);

    Novo_Valor := Valor_Original + Juros + Multa;
    Novo_Valor := RoundTo(Novo_Valor,-2);
  finally
    Result.ValorMulta := Multa;
    Result.ValorJuros := Juros;
    Result.ValorAtualizadoComDesconto := Novo_Valor - Desconto;
  end;
end;

function TControleMainModule.ConverteToBase64(CaminhoArquivoOriginal : string;
                                     CaminhoArquivoConvertido: string): String;
  procedure GeraExportaArquivo(const AInFileName, AOutFileName: string);
  var
    inStream: TStream;
    outStream: TStream;
  begin
    inStream := TFileStream.Create(AInFileName, fmOpenRead);
    try
      outStream := TFileStream.Create(AOutFileName, fmCreate);
      try
        TNetEncoding.Base64.Encode(inStream, outStream);
      finally
        outStream.Free;
      end;
    finally
      inStream.Free;
    end;
  end;
var
  stringListRetiraQuebraLinha: TStringList;
  i: integer;
  novaLinha: string;
begin
  // Convertendo para base64
  GeraExportaArquivo(CaminhoArquivoOriginal,
                     CaminhoArquivoConvertido);

  Try
    stringListRetiraQuebraLinha := TStringList.Create;

    // Carrega o arquivo em um stringlist
    stringListRetiraQuebraLinha.LoadFromFile(CaminhoArquivoConvertido);

    // Varrendo todo o stringlist para retirar as quebras de linhas
    for i :=0 to (stringListRetiraQuebraLinha.Count -1) do
      novaLinha := novaLinha + stringListRetiraQuebraLinha.Strings[i];
  finally
    // Resultado envia para a função
    Result := novaLinha;
    stringListRetiraQuebraLinha.Free;
  end;
end;

initialization
  RegisterMainModuleClass(TControleMainModule);

  end.
