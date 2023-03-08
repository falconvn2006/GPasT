unit Controle.Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIRegClasses,
  uniGUIForm, uniGUIBaseClasses, uniBasicGrid, uniDBGrid, uniDBNavigator,
  unimDBNavigator, uniButton, uniBitBtn, uniColorButton, uniMenuButton, uniEdit,
  uniDBEdit, uniImageList, uniSpeedButton, uniPanel, uniToolBar, uniImage,
  Vcl.Imaging.pngimage, uniPageControl, uniGUIFrame, uniStatusBar,
  System.ImageList, Vcl.ImgList, uniLabel, uniSplitter, uniScreenMask, uniChart,
  Vcl.Imaging.jpeg, uniURLFrame, uniSyntaxEditorBase, uniSyntaxEditor,
  uniCalendarPanel, uniCalendar, uniTimer, uniDateTimePicker, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniCanvas, uniRadioGroup,
  uniCheckBox, uniRadioButton, uniScrollBox, 
  uniHTMLFrame, uniDBText, Vcl.ExtCtrls, uniMultiItem, uniComboBox,
  uniDBComboBox, uniDBLookupComboBox,  uniListBox, 
   uniProgressBar,    uniSweetAlert, Controle.Consulta.Filial;

type
  TIntegracao = record
    VendorLib : string;
    Database  : string;
    UserName  : string;
    Password  : string;
    Protocol  : string;
    Server    : string;
  end;

type
  TControleMain = class(TUniForm)
    UniImageList1: TUniImageList;
    UniScreenMask1: TUniScreenMask;
    UniPanel6: TUniPanel;
    UniPanel4: TUniPanel;
    UniPanel5: TUniPanel;
    UniPanel20: TUniPanel;
    UniImage1: TUniImage;
    LbUsuario: TUniLabel;
    UniPanel7: TUniPanel;
    UniPanelGeral: TUniPanel;
    UniPanel9: TUniPanel;
    ImageList1: TUniImageList;
    UniImage2: TUniImage;
    CdsAgendamento: TClientDataSet;
    DscAgendamento: TDataSetProvider;
    CdsAgendamentoID: TFMTBCDField;
    CdsAgendamentoDATAHORA_INICIO: TDateTimeField;
    CdsAgendamentoDATAHORA_FIM: TDateTimeField;
    CdsAgendamentoPACIENTE_ID: TFMTBCDField;
    CdsAgendamentoPROFISSIONAL_ID: TFMTBCDField;
    CdsAgendamentoOBSERVACAO: TWideStringField;
    CdsAgendamentoPACIENTE: TWideStringField;
    CdsAgendamentoPROFISSIONAL: TWideStringField;
    QryAgendamento: TADOQuery;
    QryAgendamentoID: TFMTBCDField;
    QryAgendamentoDATAHORA_INICIO: TDateTimeField;
    QryAgendamentoDATAHORA_FIM: TDateTimeField;
    QryAgendamentoPACIENTE_ID: TFMTBCDField;
    QryAgendamentoPROFISSIONAL_ID: TFMTBCDField;
    QryAgendamentoOBSERVACAO: TWideStringField;
    QryAgendamentoPACIENTE: TWideStringField;
    QryAgendamentoPROFISSIONAL: TWideStringField;
    DscProfissional: TDataSource;
    DspProfissional: TDataSetProvider;
    QryProfissional: TADOQuery;
    QryProfissionalID: TFloatField;
    QryProfissionalDESCRICAO: TWideStringField;
    CdsProfissional: TClientDataSet;
    CdsProfissionalID: TFloatField;
    CdsProfissionalDESCRICAO: TWideStringField;
    MenuPanel_01: TUniPanel;
    UniPanelEsq1: TUniPanel;
    BotaoMenuCliente: TUniButton;
    BotaoMenuFornecedor: TUniButton;
    BotaoMenuEmpresa: TUniButton;
    UniButton3: TUniButton;
    BotaoMenuTitulosPagar: TUniButton;
    BotaoMenuTitulosReceber: TUniButton;
    pagePrincipal: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniStatusBar1: TUniStatusBar;
    UniPageControlDashBoard: TUniPageControl;
    UniTabSheet3: TUniTabSheet;
    UniPanel17: TUniPanel;
    UniTabSheet9: TUniTabSheet;
    BotaoMenuRepresentante: TUniButton;
    UniPanel1: TUniPanel;
    UniPanel58: TUniPanel;
    UniPanelGestaoAgenda: TUniPanel;
    UniImageList2: TUniImageList;
    UniPanel22: TUniPanel;
    UniDateTimeInicial: TUniDateTimePicker;
    UniDateTimePicker1: TUniDateTimePicker;
    UniLabel1: TUniLabel;
    UniLabel5: TUniLabel;
    UniPanel64: TUniPanel;
    UniComboBox1: TUniComboBox;
    UniLabel10: TUniLabel;
    UniPanelIntervalo: TUniPanel;
    UniBotaoMesAnterior: TUniButton;
    uniEditMes: TUniEdit;
    UniBotaoMesPosterior: TUniButton;
    uniEditAno: TUniEdit;
    UniPanel68: TUniPanel;
    UniPanel34: TUniPanel;
    UniPanel3: TUniPanel;
    BotaoMenuCaixa: TUniButton;
    UniPanel15: TUniPanel;
    UniButton1: TUniButton;
    BotaoMenuProduto: TUniButton;
    UniPanel18: TUniPanel;
    BotaoMenuServico: TUniButton;
    UniPanel27: TUniPanel;
    ImageLoginInicial: TUniImage;
    DscConsultaTutorial: TDataSource;
    CdsConsultaTutorial: TClientDataSet;
    CdsConsultaTutorialID: TFloatField;
    CdsConsultaTutorialTITULO: TWideStringField;
    CdsConsultaTutorialDESCRICAO: TWideStringField;
    CdsConsultaTutorialLINK_URL: TWideStringField;
    CdsConsultaTutorialORDEM: TFloatField;
    DspConsultaTutorial: TDataSetProvider;
    QryConsultaTutorial: TADOQuery;
    QryConsultaTutorialID: TFloatField;
    QryConsultaTutorialTITULO: TWideStringField;
    QryConsultaTutorialDESCRICAO: TWideStringField;
    QryConsultaTutorialLINK_URL: TWideStringField;
    QryConsultaTutorialORDEM: TFloatField;
    BotaoMenuChequesRecebidos: TUniButton;
    BotaoMenuChequesDepositados: TUniButton;
    UniPanel8: TUniPanel;
    LbNomeEmpresa: TUniLabel;
    UniImage5: TUniImage;
    UniImage6: TUniImage;
    UniImage3: TUniImage;
    UniSweetAlertFechar: TUniSweetAlert;
    BotaoMenuConfigMsgCobranca: TUniButton;
    UniImage4: TUniImage;
    BotaoMenuEnviaMsgCobranca: TUniButton;
    UniButton10: TUniButton;
    BotaoMenuCategoriaProduto: TUniButton;
    BotaoMenuTabelaPreco: TUniButton;
    BotaoMenuProdTabelaPrecoExcecao: TUniButton;
    BotaoMenuProdutoEmbalagem: TUniButton;
    BotaoMenuGrupoTributos: TUniButton;
    BotaoMenuBanco: TUniButton;
    BotaoMenuContaBancaria: TUniButton;
    BotaoMenuCategoriaTitulo: TUniButton;
    BotaoMenuCondicoesPagamento: TUniButton;
    BotaoMenuDestinoCheques: TUniButton;
    BotaoMenuDescontosVales: TUniButton;
    BotaoMenuCadastro: TUniButton;
    BotaoSchemaCadastro: TUniButton;
    BotaoMenuSchema: TUniButton;
    BotaoMenuRecebiveisRepresentante: TUniButton;
    BotaoMenuDadosRepresentante: TUniButton;
    BotaoMenuClienteRepresentante: TUniButton;
    UniButton13: TUniButton;
    BotaoMenuUsuarios: TUniButton;
    BotaoMenuContratoTodos: TUniButton;
    BotaoMenuIntRecebidos: TUniButton;
    BotaoMenuIntContasReceber: TUniButton;
    BotaoMenuIntContasPagar: TUniButton;
    BotaoMenuRelatCheques: TUniButton;
    BotaoMenuRelatContasPagarObs: TUniButton;
    BotaoMenuRelatContasPagar: TUniButton;
    BotaoMenuRelatContasReceber: TUniButton;
    UniButton4: TUniButton;
    UniButton2: TUniButton;
    UniButton5: TUniButton;
    UniLabel2: TUniLabel;
    BotaoMenuIntRelatorioAReceber: TUniButton;
    BotaoMenuCaixaGeral: TUniButton;
    procedure BotaoMenuClienteClick(Sender: TObject);
    procedure BotaoMenuFornecedorClick(Sender: TObject);
    procedure BotaoMenuVendedorClick(Sender: TObject);
    procedure BotaoMenuContratosClick(Sender: TObject);
    procedure BotaoMenuUsuariosClick(Sender: TObject);
    procedure BotaoMenuCadastroClick(Sender: TObject);
    procedure UniURLFrame1FrameLoaded(Sender: TObject);
    procedure BotaoMenuSchemaClick(Sender: TObject);
    procedure BotaoSchemaCadastroClick(Sender: TObject);
    procedure UniPageCalendarioChange(Sender: TObject);
    procedure UniHTMLFrame1AjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
    procedure BotaoMenuBancoClick(Sender: TObject);
    procedure BotaoMenuContaBancariaClick(Sender: TObject);
    procedure BotaoMenuCondicoesPagamentoClick(Sender: TObject);
    procedure BotaoMenuTitulosReceberClick(Sender: TObject);
    procedure BotaoMenuTitulosPagarClick(Sender: TObject);
    procedure BotaoMenuRepresentanteClick(Sender: TObject);
    procedure BotaoMenuRecebiveisRepresentanteClick(Sender: TObject);
    procedure BotaoMenuDadosRepresentanteClick(Sender: TObject);
    procedure UniTabSheet1AjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
    procedure UniBotaoMesPosteriorClick(Sender: TObject);
    procedure UniBotaoMesAnteriorClick(Sender: TObject);
    procedure BotaoMenuCaixaClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure BotaoMenuProdutoClick(Sender: TObject);
    procedure BotaoMenuContratoTodosClick(Sender: TObject);
    procedure btnWhatsappClick(Sender: TObject);
    procedure btnSugestaoClick(Sender: TObject);
    procedure UniFormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnVideosClick(Sender: TObject);
    procedure BotaoMenuChequesRecebidosClick(Sender: TObject);
    procedure BotaoMenuDestinoChequesClick(Sender: TObject);
    procedure BotaoMenuCategoriaTituloClick(Sender: TObject);
    procedure BotaoMenuChequesDepositadosClick(Sender: TObject);
    procedure BotaoMenuCategoriaProdutoClick(Sender: TObject);
    procedure BotaoMenuTabelaPrecoClick(Sender: TObject);
    procedure BotaoMenuGrupoTributosClick(Sender: TObject);
    procedure BotaoMenuProdTabelaPrecoExcecaoClick(Sender: TObject);
    procedure BotaoMenuProdutoEmbalagemClick(Sender: TObject);
    procedure UniImage3Click(Sender: TObject);
    procedure UniImage6Click(Sender: TObject);
    procedure UniImage5Click(Sender: TObject);
    procedure UniSweetAlertFecharConfirm(Sender: TObject);
    procedure BotaoMenuIntContasPagarClick(Sender: TObject);
    procedure BotaoMenuIntContasReceberClick(Sender: TObject);
    procedure BotaoMenuIntRecebidosClick(Sender: TObject);
    procedure BotaoMenuConfigMsgCobrancaClick(Sender: TObject);
    procedure UniImage4Click(Sender: TObject);
    procedure BotaoMenuDescontosValesClick(Sender: TObject);
    procedure BotaoMenuEmpresaClick(Sender: TObject);
    procedure BotaoMenuRelatContasReceberClick(Sender: TObject);
    procedure BotaoMenuRelatContasPagarClick(Sender: TObject);
    procedure BotaoMenuEnviaMsgCobrancaClick(Sender: TObject);
    procedure BotaoMenuRelatContasPagarObsClick(Sender: TObject);
    procedure BotaoMenuRelatChequesClick(Sender: TObject);
    procedure BotaoMenuIntRelatorioAReceberClick(Sender: TObject);
    procedure BotaoMenuCaixaGeralClick(Sender: TObject);
  private
    { Private declarations }
    procedure NovaAba(nomeFormFrame: TFrame; descFormFrame: string; Fechar: Boolean);
    function LocalizaPanelMenu(Nome_Interno: string): Boolean;
  //  function ConsultaTitulos(Tipo: String): Double;
    function ConsultaTitulosMesLiquidado(Mes: string; Ano: string; Tipo: string): Double;
    function ConsultaTitulosMesAtrasado(Mes, Ano, Tipo: string): Double;
    procedure CarregaVideos(Schema: string);

//    procedure CarregaListaDeAtendimentos2;
  public
    { Public declarations }

    PosicaoMouseX : Integer;
    PosicaoMouseY : Integer;
    FSequenciaID_MontaAvaliacao: Integer;
    HdLivre : integer;

    type
      TMensageiroCor = (Azul, Verde, Amarelo, Branco, Vermelho, Transparente);

      TMensageiroTamanho = (Pequeno, Medio);

      TMensageiroPosicaoX = (Direita, Esquerda, Centro);

      TMensageiroPosicaoY = (Superior, Inferior);
    procedure CarregandoMenu;
    procedure CarregaTelaInicio;
    procedure CarregandoOpcoesInicio;
    procedure ExecutaEscolhePlano;
    function LimitePlanoHD: boolean;
    Function LerIniIntegracao: TIntegracao;
  end;

function ControleMain: TControleMain;

implementation

{$R *.dfm}



uses
  uniGUIVars, Controle.Main.Module, uniGUIApplication, Controle.Consulta.Fornecedor,
  Controle.Consulta.Usuario, Controle.Consulta.Cliente,
  Controle.Login,  Controle.Consulta.Vendedor, Controle.Server.Module,
  Controle.Consulta.Modelo, Controle.Consulta.Menu, Controle.Modal.Ajuda,
  Controle.Consulta.Menu.Schema, Controle.Consulta.Schema,
  Controle.Consulta.Banco, Controle.Consulta.ContaBancaria,
  Controle.Consulta.CondicoesPagamento, Controle.Consulta.TituloReceber,
  Controle.Consulta.TituloPagar, Controle.Funcoes, Controle.Consulta.Representante,
  Controle.Operacoes.Caixa, Controle.Consulta.Caixa,
  Controle.Operacoes.Logout,  Controle.Consulta.Produto,
  Controle.Consulta.Sugestao, Controle.Consulta.VideoTutoriais,
  Controle.Consulta.Cheque.Destino,
  Controle.Consulta.ChequesRecebidos, Controle.Consulta.TituloCategoria,
  Controle.Consulta.ChequesDepositados, Controle.Consulta.ProdutoCategoria,
  Controle.Consulta.TreeView.ProdutoCategoria, Controle.Consulta.TabelaPreco,
  Controle.Consulta.GrupoTributario,
  Controle.Consulta.Produto.TabelaPrecoExcecao,
  Controle.Consulta.ProdutoEmbalagem,Controle.Relatorio,
  Controle.Consulta.IntegracaoContasPagar,
  Controle.Consulta.Integracao.ContasReceber,
  Controle.Consulta.Integracao.ContasRecebidas,
  Controle.Operacoes.MensagensCobranca, Controle.Envia.Mensagem,
  Controle.Consulta.DescontosVales, Controle.Relatorio.Cadastro.ContasReceber,
  Controle.Relatorio.Cadastro.ContasPagar, System.IniFiles,
  Controle.Relatorio.ContasPagarObservacao,
  Controle.Relatorio.Cadastro.Cheques,
  Controle.Relatorio.Cadastro.IntegracaoReceber, Controle.Consulta.Caixa.Geral;

function ControleMain: TControleMain;
begin
  Result := TControleMain(ControleMainModule.GetFormInstance(TControleMain));
end;

procedure TControleMain.BotaoMenuBancoClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaBanco), 'Bancos', True);
end;

procedure TControleMain.BotaoMenuContaBancariaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaContaBancaria), 'Contas bancárias', True);
end;


procedure TControleMain.BotaoMenuClienteClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaCliente), 'Clientes', True);
end;

procedure TControleMain.BotaoMenuFornecedorClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaFornecedor), 'Fornecedores', True);
end;

procedure TControleMain.BotaoMenuGrupoTributosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaGrupoTributario), 'Grupo de tributos', True);
end;

procedure TControleMain.BotaoMenuProdutoClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaProduto), 'Produtos', True);
end;

procedure TControleMain.BotaoMenuProdutoEmbalagemClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaProdutoEmbalagem), 'Embalagens', True);
end;

procedure TControleMain.BotaoMenuRecebiveisRepresentanteClick(Sender: TObject);
begin
// NovaAba(TFrame(TControleConsultaRecebiveisRepresentante),'Recebíveis',True);
end;

procedure TControleMain.BotaoMenuRepresentanteClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaRepresentante), 'Representante', True);
end;

procedure TControleMain.BotaoMenuCadastroClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaMenu), 'Menus', True);
end;

procedure TControleMain.BotaoMenuVendedorClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaVendedor), 'Vendedores', True);
end;

procedure TControleMain.BotaoMenuSchemaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaMenuSchema), 'Menus do schema', True);
end;

procedure TControleMain.BotaoMenuTabelaPrecoClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaTabelaPreco), 'Tabela de Preço', True);
end;

procedure TControleMain.BotaoMenuCondicoesPagamentoClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaCondicoesPagamento), 'Condições pagamento', True);
end;

procedure TControleMain.BotaoMenuCaixaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaCaixa), 'Fluxo de caixa', True);
end;

procedure TControleMain.BotaoMenuCaixaGeralClick(Sender: TObject);
begin
 NovaAba(TFrame(TControleConsultaCaixaGeral), 'Caixa Geral', True);
end;

procedure TControleMain.BotaoMenuCategoriaProdutoClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaTreeViewProdutoCategoria), 'Categoria dos produtos', True);
end;

procedure TControleMain.BotaoMenuCategoriaTituloClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaTituloCategoria), 'Categoria dos títulos', True);
end;

procedure TControleMain.BotaoMenuChequesDepositadosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaChequesDepositados), 'lote de cheques depositados', True);
end;

procedure TControleMain.BotaoMenuChequesRecebidosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaChequesRecebidos), 'Cheques recebidos', True);
end;

procedure TControleMain.BotaoMenuTitulosPagarClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaTituloPagar), 'Títulos a pagar', True);
end;

procedure TControleMain.BotaoMenuTitulosReceberClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaTituloReceber), 'Títulos a receber', True);
end;

procedure TControleMain.BotaoSchemaCadastroClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaSchema), 'Schemas', True);
end;

procedure TControleMain.BotaoMenuIntContasPagarClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaIntegracaoContasPagar),'Int. Contas a Pagar',True)
end;

procedure TControleMain.BotaoMenuIntContasReceberClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaIntegracaoContasReceber),'Int. Contas a Receber',True)
end;

procedure TControleMain.BotaoMenuIntRecebidosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaIntegracaoContasRecebidas),'Int. Contas Recebidos',True)
end;

procedure TControleMain.BotaoMenuIntRelatorioAReceberClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleRelatorioCadastroIntegracaoReceber),'Rel. Int. A Receber',True);
end;

procedure TControleMain.btnSugestaoClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaSugestao),'Sugestões',True);
end;

procedure TControleMain.btnVideosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaVideoTutoriais),'Tutoriais',True);
end;

procedure TControleMain.btnWhatsappClick(Sender: TObject);
var
  URL_WhatsApp: String;
begin
  //URL_WhatsApp := 'https://web.whatsapp.com/send?phone=55' + ControleFuncoes.RemoveMascara(AText) + '?text=' + '%20' + 'Prezado cliente, segue o link do boleto da empresa ' + ControleMainModule.FNomeFantasia +' : '+ CdsConsultaLINK_WHATSAPP.AsString + '%20';
  URL_WhatsApp := 'https://wa.me/55' + '81991425896' + '?text='  + 'Preciso de suporte para a empresa ' + ControleMainModule.FNomeFantasia;
  UniSession.AddJS('window.open('+'"'+ URL_WhatsApp + '"'+')');
end;

procedure TControleMain.BotaoMenuDadosRepresentanteClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaRepresentante), 'Meus dados', True);
end;

procedure TControleMain.BotaoMenuDescontosValesClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaDescontosVales), 'Descontos e vales', True);
end;

procedure TControleMain.BotaoMenuDestinoChequesClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaChequeDestino), 'Destino de cheques', True);
end;

procedure TControleMain.BotaoMenuEmpresaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaFilial), 'Empresas', True);
end;

procedure TControleMain.BotaoMenuContratosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaModelo), 'Modelos', True);
end;

procedure TControleMain.BotaoMenuContratoTodosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaModelo), 'Módulo de documentos', True);
end;

procedure TControleMain.BotaoMenuUsuariosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaUsuario), 'Usuários', True);
end;

procedure TControleMain.BotaoMenuProdTabelaPrecoExcecaoClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaProdutoTabelaPrecoExcecao), 'Exceções tabela de preço', True);
end;

procedure TControleMain.UniBotaoMesAnteriorClick(Sender: TObject);
begin
  Cont := Cont - 1;
  if Cont = 0 then
  begin
    Cont := 12;
    UniEditAno.Text := IntToStr(StrToInt(UniEditAno.Text) - 1);
  end;
  UnieditMes.Text := ControleFuncoes.MesExtenso(Cont);
end;

procedure TControleMain.UniBotaoMesPosteriorClick(Sender: TObject);
begin
  Cont := Cont + 1;
  if Cont = 13 then
  begin
    Cont := 1;
    UniEditAno.Text := IntToStr(StrToInt(UniEditAno.Text) + 1);
  end;
  UnieditMes.Text := ControleFuncoes.MesExtenso(Cont);
end;

procedure TControleMain.BotaoMenuConfigMsgCobrancaClick(Sender: TObject);
begin
  ControleOperacoesMensagensCobranca.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
   //
  end);
end;

procedure TControleMain.BotaoMenuEnviaMsgCobrancaClick(Sender: TObject);
var
  ControleEnviaMensagem : TControleEnviaMensagem;
begin
  ControleEnviaMensagem := TControleEnviaMensagem.Create(UniApplication);
  ControleEnviaMensagem.ShowModal;
end;

procedure TControleMain.BotaoMenuRelatChequesClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleRelatorioCadastroCheques), 'Rel.Cheques', True);
end;

procedure TControleMain.BotaoMenuRelatContasPagarClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleRelatorioCadastroContasPagar), 'Rel.Extrato pagar', True);
end;

procedure TControleMain.BotaoMenuRelatContasPagarObsClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleRelatorioContasPagarObservacao), 'Rel.Contas Pagar Obs', True);
end;

procedure TControleMain.BotaoMenuRelatContasReceberClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleRelatorioCadastroContasReceber), 'Rel.Extrato receber', True);
end;

procedure TControleMain.UniFormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown  := false;
end;

procedure TControleMain.UniFormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PosicaoMouseX := X;
  PosicaoMouseY := Y;
end;

procedure TControleMain.UniFormShow(Sender: TObject);
begin
  if ControleMainModule.FRepresentante = 0 then
  begin
    UniPageControlDashBoard.ActivePageIndex := 0;
    begin
      uniEditAno.Text := FormatDateTime('yyyy', Date);
      unieditMes.Text := ControleFuncoes.MesExtenso(StrToInt(FormatDateTime('mm', Date)));
      Cont := StrToInt(FormatDateTime('mm', Date));
    end;
  end
  else
  begin
    UniPageControlDashBoard.ActivePageIndex := 0;
  end;
  CarregaVideos(Copy(ControleMainModule.FSchema,1,8));

  LerIniIntegracao;
end;

procedure TControleMain.UniHTMLFrame1AjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
var
  mMenuEvento: TStringList;
begin
  mMenuEvento := TStringList.Create;
  mMenuEvento.Delimiter := ':';
  mMenuEvento.DelimitedText := EventName;

  if mMenuEvento[0] = 'editar' then
    ControleMainModule.MensageiroSweetAlerta('Atenção!' + 'EDITANDO ', mMenuEvento[1])
  else if mMenuEvento[0] = 'procedimento' then
    ControleMainModule.MensageiroSweetAlerta('Atenção!' + 'EDITANDO ', mMenuEvento[1])
  else if mMenuEvento[0] = 'recebimento' then
    ControleMainModule.MensageiroSweetAlerta('Atenção!' + 'RECEBIMENTO ', mMenuEvento[1]);
  mMenuEvento.Free;
end;

procedure TControleMain.UniImage3Click(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaVideoTutoriais),'Tutoriais',True);
end;

procedure TControleMain.UniImage4Click(Sender: TObject);
var
  ControleEnviaMensagem : TControleEnviaMensagem;
begin
  ControleEnviaMensagem := TControleEnviaMensagem.Create(UniApplication);
  ControleEnviaMensagem.ShowModal;
end;

procedure TControleMain.UniImage5Click(Sender: TObject);
var
  URL_WhatsApp: String;
begin
  URL_WhatsApp := 'https://wa.me/55' + '81991425896' + '?text='  + 'Preciso de suporte para a empresa ' + ControleMainModule.FNomeFantasia;
  UniSession.AddJS('window.open('+'"'+ URL_WhatsApp + '"'+')');
end;

procedure TControleMain.UniImage6Click(Sender: TObject);
begin
  UniSweetAlertFechar.Show;
end;

function TControleMain.LocalizaPanelMenu(Nome_Interno: string): Boolean;
begin
  if ControleMainModule.cdsMenu_Schema.Locate('menu_descricao', UpperCase(Nome_Interno), []) then
    Result := True
  else
    Result := False;
end;

procedure TControleMain.UniPageCalendarioChange(Sender: TObject);
begin
 { if UniPageCalendario.ActivePageIndex  = 0 then
  begin
    UniCalendarioDiario.StartDate  := UniDateTimeInicial.DateTime;
  end
  else if UniPageCalendario.ActivePageIndex  = 1 then
  begin
    UniCalendarioSemanal.StartDate := UniDateTimeInicial.DateTime;
  end
  else if UniPageCalendario.ActivePageIndex  = 2 then
  begin
    UniCalendarioMensal.StartDate  := UniDateTimeInicial.DateTime;
  end;}

  //UniPageCalendario.Refresh;
end;

procedure TControleMain.UniSweetAlertFecharConfirm(Sender: TObject);
begin
  Close;
end;

procedure TControleMain.UniTabSheet1AjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
begin
  //ShowMessage(EventName);
end;

procedure TControleMain.UniURLFrame1FrameLoaded(Sender: TObject);
begin
  pagePrincipal.ActivePageIndex := 0;
end;

procedure TControleMain.CarregandoMenu();
begin
  Try
    with ControleMainModule do
    begin
      CdsUsuarioPermissao.Refresh;
      // habilitando para a visualização os panels de cada menu
      // segundo a tabela menu_schema
      // Abre o registro
      CdsMenu_Schema.Close;
      QryMenu_Schema.Parameters.ParamByName('tschema').Value := FSchema;
      CdsMenu_Schema.Open;


    {  if ControleMainModule.FPlano = 'NOVO' then
      begin
        // ClinicaPlanos.ShowModal;
      end
      else
      begin
        //calculo para pegar espaço utilizado e comparar com plano no banco fonte
        ControleMainModule.DirBytes :=0;
        HdUsado      := ControleMainModule.FolderSize('UploadFolder\'+ ControleMainModule.FSchema);
        HdContratado := ControleMainModule.PlanoSistemaHDControle(ControleMainModule.FPlano);
        HdLivre      := StrToInt(FormatFloat('###,00',((HdUsado / HdContratado)*100)));
        controleMain.UniProgressBar1.Position := HdLivre;
      end;}

      if ControleMainModule.FRepresentante = 0 then
      begin
        //--------------------------------INICIO PANEL CONTROLE---------------------------------------
        // Menus do controle
        MenuPanel_01.Visible := LocalizaPanelMenu(MenuPanel_01.Name);
//        MenuPanel_02.Visible := LocalizaPanelMenu(MenuPanel_02.Name);//precisa criar no banco de permissções para chamar o menu
//        MenuPanel_03.Visible := LocalizaPanelMenu(MenuPanel_03.Name);
//        MenuPanel_04.Visible := LocalizaPanelMenu(MenuPanel_04.Name);
//        MenuPanel_06.Visible := LocalizaPanelMenu(MenuPanel_06.Name);
//        MenuPanel_16.Visible := LocalizaPanelMenu(MenuPanel_16.Name);
//        MenuPanel_17.Visible := LocalizaPanelMenu(MenuPanel_17.Name);

        // Botões do MenuPanel_01 ----------------------------------------------------------------------
        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CLIENTE_BOTAO').AsString) = 'P' then
          BotaoMenuCliente.Visible := True
        else
          BotaoMenuCliente.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_FORNECEDOR_BOTAO').AsString) = 'P' then
          BotaoMenuFornecedor.Visible := True
        else
          BotaoMenuFornecedor.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_EMPRESA_BOTAO').AsString) = 'P' then
          BotaoMenuEmpresa.Visible := True
        else
          BotaoMenuEmpresa.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_TITULOSRECEBER_BOTAO').AsString) = 'P' then
          BotaoMenuTitulosReceber.Visible := True
        else
          BotaoMenuTitulosReceber.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_TITULOSPAGAR_BOTAO').AsString) = 'P' then
          BotaoMenuTitulosPagar.Visible := True
        else
          BotaoMenuTitulosPagar.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CAIXA_BOTAO').AsString) = 'P' then
          BotaoMenuCaixa.Visible := True
        else
          BotaoMenuCaixa.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CAIXA_GERAL_BOTAO').AsString) = 'P' then
          BotaoMenuCaixaGeral.Visible := True
        else
          BotaoMenuCaixaGeral.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CHEQUESRECEBIDOS_BOTAO').AsString) = 'P' then
          BotaoMenuChequesRecebidos.Visible := True
        else
          BotaoMenuChequesRecebidos.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CHEQUESDEPOSITADOS_BOTAO').AsString) = 'P' then
          BotaoMenuChequesDepositados.Visible := True
        else
          BotaoMenuChequesDepositados.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_BANCO_BOTAO').AsString) = 'P' then
          BotaoMenuBanco.Visible := True
        else
          BotaoMenuBanco.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CONTABANCARIA_BOTAO').AsString) = 'P' then
          BotaoMenuContaBancaria.Visible := True
        else
          BotaoMenuContaBancaria.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_TIPOTITULO_BOTAO').AsString) = 'P' then
          BotaoMenuCondicoesPagamento.Visible := True
        else
          BotaoMenuCondicoesPagamento.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_DESTINOCHEQUE_BOTAO').AsString) = 'P' then
          BotaoMenuDestinoCheques.Visible := True
        else
          BotaoMenuDestinoCheques.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CATEGORIATITULO_BOTAO').AsString) = 'P' then
          BotaoMenuCategoriaTitulo.Visible := True
        else
          BotaoMenuCategoriaTitulo.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CATEGORIAPRODUTO_BOTAO').AsString) = 'P' then
          BotaoMenuCategoriaProduto.Visible := True
        else
          BotaoMenuCategoriaProduto.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_TABELAPRECO_BOTAO').AsString) = 'P' then
          BotaoMenuTabelaPreco.Visible := True
        else
          BotaoMenuTabelaPreco.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_PROD_TABPRECO_EXCEC_BOTAO').AsString) = 'P' then
          BotaoMenuProdTabelaPrecoExcecao.Visible := True
        else
          BotaoMenuProdTabelaPrecoExcecao.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_PRODUTO_EMBALAGEM_BOTAO').AsString) = 'P' then
          BotaoMenuProdutoEmbalagem.Visible := True
        else
          BotaoMenuProdutoEmbalagem.Visible := False;


        if Trim(CdsUsuarioPermissao.FieldByName('MENU_GRUPOTRIBUTOS_BOTAO').AsString) = 'P' then
          BotaoMenuGrupoTributos.Visible := True
        else
          BotaoMenuGrupoTributos.Visible := False;


        if Trim(CdsUsuarioPermissao.FieldByName('MENU_USUARIOS_BOTAO').AsString) = 'P' then
          BotaoMenuUsuarios.Visible := True
        else
          BotaoMenuUsuarios.Visible := False;


        // Botões do MenuPanel_06 ----------------------------------------------------------------------
        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CADASTRO_BOTAO').AsString) = 'P' then
          BotaoMenuCadastro.Visible := True
        else
          BotaoMenuCadastro.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_SCHEMA_CADASTRO_BOTAO').AsString) = 'P' then
          BotaoSchemaCadastro.Visible := True
        else
          BotaoSchemaCadastro.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_SCHEMA_BOTAO').AsString) = 'P' then
          BotaoMenuSchema.Visible := True
        else
          BotaoMenuSchema.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_DESCONTO_VALE_BOTAO').AsString) = 'P' then
          BotaoMenuDescontosVales.Visible := True
        else
          BotaoMenuDescontosVales.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CONFIG_MSG_COBRANCA_BOTAO').AsString) = 'P' then
          BotaoMenuConfigMsgCobranca.Visible := True
        else
          BotaoMenuConfigMsgCobranca.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_ENVIA_MSG_COBRANCA_BOTAO').AsString) = 'P' then
          BotaoMenuEnviaMsgCobranca.Visible := True
        else
          BotaoMenuEnviaMsgCobranca.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_RELAT_CONTASPAGAR_BOTAO').AsString) = 'P' then
          BotaoMenuRelatContasPagar.Visible := True
        else
          BotaoMenuRelatContasPagar.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_RELAT_CONTASRECEBER_BOTAO').AsString) = 'P' then
          BotaoMenuRelatContasReceber.Visible := True
        else
          BotaoMenuRelatContasReceber.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_RELAT_CPAGAR_OBS_BOTAO').AsString) = 'P' then
          BotaoMenuRelatContasPagarObs.Visible := True
        else
          BotaoMenuRelatContasPagarObs.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_RELAT_CHEQUES_BOTAO').AsString) = 'P' then
          BotaoMenuRelatCheques.Visible := True
        else
          BotaoMenuRelatCheques.Visible := False;

        // Botões do MenuPanel_17 ----------------------------------------------------------------------
        if Trim(CdsUsuarioPermissao.FieldByName('MENU_INTCONTASPAGAR_BOTAO').AsString) = 'P' then
          BotaoMenuIntContasPagar.Visible := True
        else
          BotaoMenuIntContasPagar.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_INTCONTASRECEBER_BOTAO').AsString) = 'P' then
          BotaoMenuIntContasReceber.Visible := True
        else
          BotaoMenuIntContasReceber.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_INTRECEBIDOS_BOTAO').AsString) = 'P' then
          BotaoMenuIntRecebidos.Visible := True
        else
          BotaoMenuIntRecebidos.Visible := False;

        if Trim(CdsUsuarioPermissao.FieldByName('MENU_MODELOS_DOC_BOTAO').AsString) = 'P' then
          BotaoMenuContratoTodos.Visible := True
        else
          BotaoMenuContratoTodos.Visible := False;

        //--------------------------------FIM PANEL CONTROLE--------------------------------------------
      end
      else
      begin
        //--------------------------------INICIO PANEL REPRESENTANTE------------------------------------------
        //      MenuPanel_01.Visible := LocalizaPanelMenu(MenuPanel_01.Name);
        if Trim(CdsUsuarioPermissao.FieldByName('MENU_CLIENTE_REPRES_BOTAO').AsString) = 'P' then
          BotaoMenuClienteRepresentante.Visible := True
        else
          BotaoMenuClienteRepresentante.Visible := False;

        // Botões do MenuPanel_14 ----------------------------------------------------------------------
        if Trim(CdsUsuarioPermissao.FieldByName('MENU_DADOS_REPRES_BOTAO').AsString) = 'P' then
          BotaoMenuDadosRepresentante.Visible := True
        else
          BotaoMenuDadosRepresentante.Visible := False;

        // Botões do MenuPanel_14 ----------------------------------------------------------------------
        if Trim(CdsUsuarioPermissao.FieldByName('MENU_RECEBIVEIS_REPRES_BOTAO').AsString) = 'P' then
          BotaoMenuRecebiveisRepresentante.Visible := True
        else
          BotaoMenuRecebiveisRepresentante.Visible := False;

        // Botões do MenuPanel_14 ----------------------------------------------------------------------
        if Trim(CdsUsuarioPermissao.FieldByName('MENU_RECEBIVEIS_REPRES_BOTAO').AsString) = 'P' then
          BotaoMenuRecebiveisRepresentante.Visible := True
        else
          BotaoMenuRecebiveisRepresentante.Visible := False;

      end;

      if ControleMainModule.CdsFilial.FieldByName('LOGOMARCA_CAMINHO').AsString <> '' then
      begin
        try
          if FileExists(ControleMainModule.CdsFilial.FieldByName('LOGOMARCA_CAMINHO').AsString) then
            ImageLoginInicial.Picture.LoadFromFile(ControleMainModule.CdsFilial.FieldByName('LOGOMARCA_CAMINHO').AsString);
        except
          on E: Exception do
          begin
            ControleMainModule.MensageiroSweetAlerta('Atenção!', ControleFuncoes.RetiraAspaSimples(E.Message));
          end;
        end;
      end;
    end;

    // Alterando a cor dos panels do menu
    UniPanelGeral.Color := $00F5F5F5;
    UniPanelGeral.Width := 226;
    MenuPanel_01.Color := $00F5F5F5;
//    MenuPanel_02.Color := $00F5F5F5;
//    MenuPanel_03.Color := $00F5F5F5;
//    MenuPanel_04.Color := $00F5F5F5;
//    MenuPanel_06.Color := $00F5F5F5;
//    MenuPanel_15.color := $00F5F5F5;
//    MenuPanel_16.color := $00F5F5F5;
//    MenuPanel_17.color := $00F5F5F5;
  Except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção!', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  End;
end;

function TControleMain.ConsultaTitulosMesLiquidado(Mes: string; Ano: string; Tipo: string): Double; //Tipo = 'Receber', 'Pagar'
var
  DiaInicial, DiaFinal: string;
begin
  DiaInicial := '01/' + Mes + '/' + Ano;
  DiaFinal := IntToStr(ControleMainModule.UltimoDia(StrToDate(DiaInicial))) + '/' + Mes + '/' + Ano;

  Result := 0;
  with ControleMainModule do
  begin
    CdsAx1.Close;
    QryAx1.SQL.Clear;
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Add('  SELECT SUM(tit.valor) valor');
    QryAx1.SQL.Add('    FROM titulo tit');
    if Tipo = 'Receber' then
      QryAx1.SQL.Add(' INNER JOIN titulo_receber pag')
    else if Tipo = 'Pagar' then
      QryAx1.SQL.Add(' INNER JOIN titulo_pagar pag');
    QryAx1.SQL.Add('      ON tit.id = pag.id');
    QryAx1.SQL.Add('   WHERE TRUNC(data_liquidacao)');
    QryAx1.SQL.Add(' BETWEEN TO_DATE(''' + Trim(DiaInicial) + ''', ''dd/mm/yyyy'')');
    QryAx1.SQL.Add('     AND TO_DATE(''' + Trim(DiaFinal) + ''', ''dd/mm/yyyy'')');
    QryAx1.SQL.Add('     AND tit.situacao = ''L''');
    CdsAx1.Open;

    if CdsAx1.RecordCount <> 0 then
      Result := CdsAx1.FieldByName('valor').AsFloat;
  end;
end;

function TControleMain.ConsultaTitulosMesAtrasado(Mes: string; Ano: string; Tipo: string): Double; //Tipo = 'Receber', 'Pagar'
var
  DiaInicial, DiaFinal: string;
begin
  DiaInicial := '01/' + Mes + '/' + Ano;
  DiaFinal := IntToStr(ControleMainModule.UltimoDia(StrToDate(DiaInicial))) + '/' + Mes + '/' + Ano;

  Result := 0;
  with ControleMainModule do
  begin
    CdsAx1.Close;
    QryAx1.SQL.Clear;
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Add('  SELECT SUM(tit.valor) valor');
    QryAx1.SQL.Add('    FROM titulo tit');
    if Tipo = 'Receber' then
      QryAx1.SQL.Add(' INNER JOIN titulo_receber pag')
    else if Tipo = 'Pagar' then
      QryAx1.SQL.Add(' INNER JOIN titulo_pagar pag');
    QryAx1.SQL.Add('      ON tit.id = pag.id');
    QryAx1.SQL.Add('   WHERE TRUNC(data_vencimento)');
    QryAx1.SQL.Add(' BETWEEN TO_DATE(''' + Trim(DiaInicial) + ''', ''dd/mm/yyyy'')');
    QryAx1.SQL.Add('     AND TO_DATE(''' + Trim(DiaFinal) + ''', ''dd/mm/yyyy'')');
    QryAx1.SQL.Add('     AND TRUNC(data_vencimento) < TRUNC(sysdate)');
    QryAx1.SQL.Add('     AND tit.situacao = ''A''');
    CdsAx1.Open;

    if CdsAx1.RecordCount <> 0 then
      Result := CdsAx1.FieldByName('valor').AsFloat;
  end;
end;


procedure TControleMain.NovaAba(nomeFormFrame: TFrame; descFormFrame: string; Fechar: Boolean);
var TabSheet      :TUniTabSheet;
    FCurrentFrame :TUniFrame;
    I             :Integer;
begin
  pagePrincipal.Visible := True;

  {Verificando se a tela já está aberto e redireciona a ela}
  for I := 0 to pagePrincipal.PageCount - 1 do
    with pagePrincipal do
      if Pages[I].Caption = descFormFrame  then
        begin
          pagePrincipal.ActivePageIndex := I;
          Exit;
        end;

  TabSheet              := TUniTabSheet.Create(Self);
  TabSheet.PageControl  := pagePrincipal;
  TabSheet.Caption      := descFormFrame;
  TabSheet.Closable     := Fechar;

  Try
    FCurrentFrame:= TUniFrameClass(nomeFormFrame).Create(Self);
  Except
    on e:Exception do
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
   End;

  with FCurrentFrame do
  begin
    Align               := alClient;
    Parent              := TabSheet;
  end;

  Refresh;
  pagePrincipal.ActivePage := TabSheet;
end;

procedure TControleMain.CarregandoOpcoesInicio;
begin
  if ControleMainModule.FRepresentante = 0 then
  begin
    UniPageControlDashBoard.ActivePageIndex := 0;
    begin
      uniEditAno.Text := FormatDateTime('yyyy', Date);
      unieditMes.Text := ControleFuncoes.MesExtenso(StrToInt(FormatDateTime('mm', Date)));
      Cont := StrToInt(FormatDateTime('mm', Date));
    end;
  end
  else
  begin
    UniPageControlDashBoard.ActivePageIndex := 0;
  end;
end;

procedure TControleMain.ExecutaEscolhePlano;
begin
  // implemementar
end;

function TControleMain.LimitePlanoHD() : boolean;
begin
  Result := True;
  // Implementar
end;

procedure TControleMain.CarregaVideos(Schema: string);
begin
  CdsConsultaTutorial.Filtered := False;
  CdsConsultaTutorial.Params.ParamByName('nome_schema').AsString := Schema;
  CdsConsultaTutorial.Filtered := True;
  CdsConsultaTutorial.Open;
end;

procedure TControleMain.CarregaTelaInicio;
begin

end;

Function TControleMain.LerIniIntegracao: TIntegracao;
var
  Config : TiniFile;
begin
  // Carregando os parametros e conexao
  Try
    try
      Config := TiniFile.Create( '.\Config.ini' );

      with Result do
      begin
        VendorLib := Config.ReadString( 'INTEGRACAO', 'VendorLib','');
        Database  := Config.ReadString( 'INTEGRACAO', 'Database','');
        UserName  := Config.ReadString( 'INTEGRACAO', 'UserName','');
        Password  := Config.ReadString( 'INTEGRACAO', 'Password','');
        Protocol  := Config.ReadString( 'INTEGRACAO', 'Protocol','');
        Server    := Config.ReadString( 'INTEGRACAO', 'Server','');
      end;
    finally
      Config.Free;
    end;
  Except
    ControleMainModule.MensageiroSweetAlerta('Atenção','Não foi possível ler o config.ini da integração');
    Exit;
  end;

end;

initialization
  RegisterAppFormClass(TControleMain);

end.

