unit form_principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Menus, StdCtrls, DBCtrls, ImgList, backup, Sockets,
  untClasseLembrete, DB, IBCustomDataSet, IBQuery, ACBrBase, ACBrSMS;

type
  Tprincipal = class(TForm)
    Panel_btns_cad: TPanel;
    btnAlunos: TSpeedButton;
    btnCaixa: TSpeedButton;
    btnMaterialDidatico: TSpeedButton;
    btnMovAlunos: TSpeedButton;
    btnHistorico: TSpeedButton;
    btnSair: TSpeedButton;
    MainMenu1: TMainMenu;
    Operacional1: TMenuItem;
    Cadastros1: TMenuItem;
    Perfil: TMenuItem;
    Produto: TMenuItem;
    cadastro_usuario: TMenuItem;
    Rastreamento: TMenuItem;
    CCAA1: TMenuItem;
    Financeiro1: TMenuItem;
    Sair1: TMenuItem;
    trocade_usuario: TMenuItem;
    trocar_senha: TMenuItem;
    Timer1: TTimer;
    Municpios1: TMenuItem;
    ImageList1: TImageList;
    Backup1: TMenuItem;
    Ajuda1: TMenuItem;
    Empresa1: TMenuItem;
    Preferencias: TMenuItem;
    TipoFoto: TMenuItem;
    TipoDocumento: TMenuItem;
    TipoPerfil: TMenuItem;
    TipoManequim: TMenuItem;
    SituaodoProduto: TMenuItem;
    Banco: TMenuItem;
    Avaliao1: TMenuItem;
    SpeedButton1: TSpeedButton;
    Panel2: TPanel;
    lblUsuario: TLabel;
    lblData: TLabel;
    lblHora: TLabel;
    Image1: TImage;
    Panel4: TPanel;
    Panel1: TPanel;
    Evento: TMenuItem;
    TipoConvidado: TMenuItem;
    Questionrio1: TMenuItem;
    AcompanhaPedidoAgenda: TMenuItem;
    Agendas: TMenuItem;
    Prospect: TMenuItem;
    FormadePagamento1: TMenuItem;
    PaineldeOramento1: TMenuItem;
    Arara: TMenuItem;
    Servicos: TMenuItem;
    OrdemServico: TMenuItem;
    PaineldeContrato1: TMenuItem;
    Financeiro2: TMenuItem;
    HistricoProduto1: TMenuItem;
    PlanodeContas1: TMenuItem;
    CentrodeCustos1: TMenuItem;
    ApuraoMensal1: TMenuItem;
    ipoLanamento1: TMenuItem;
    PrevisoOramento1: TMenuItem;
    AcompanhamentoPrevistoRealizado1: TMenuItem;
    Backup2: TMenuItem;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    pnlLembrete: TPanel;
    IBQuery1: TIBQuery;
    ACBrSMS1: TACBrSMS;
    ConfiguraesdeSincronismo1: TMenuItem;
    N1: TMenuItem;
    AcompanhamentodePerformance1: TMenuItem;
    MalaDireta1: TMenuItem;
    Localizacao: TMenuItem;
    procedure btn_sairClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure trocade_usuarioClick(Sender: TObject);
    procedure cadastro_usuarioClick(Sender: TObject);
    procedure trocar_senhaClick(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RastreamentoClick(Sender: TObject);
    procedure Municpios1Click(Sender: TObject);
    procedure btnAlunosClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SituacaoProdutoClick(Sender: TObject);
    procedure Relatrios1Click(Sender: TObject);
    procedure Financeiro1Click(Sender: TObject);
    procedure Backup1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Ajuda1Click(Sender: TObject);
    procedure Empresa1Click(Sender: TObject);
    procedure PreferenciasClick(Sender: TObject);
    procedure TipoFotoClick(Sender: TObject);
    procedure TipoDocumentoClick(Sender: TObject);
    procedure TipoPerfilClick(Sender: TObject);
    procedure TipoManequimClick(Sender: TObject);
    procedure ProdutoClick(Sender: TObject);
    procedure BancoClick(Sender: TObject);
    procedure Avaliao1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure EventoClick(Sender: TObject);
    procedure TipoConvidadoClick(Sender: TObject);
    procedure PedidoAgendaClick(Sender: TObject);
    procedure Questionrio1Click(Sender: TObject);
    procedure AcompanhaPedidoAgendaClick(Sender: TObject);
    procedure btnMovAlunosClick(Sender: TObject);
    procedure SituaodoProdutoClick(Sender: TObject);
    procedure AgendasClick(Sender: TObject);
    procedure ProspectClick(Sender: TObject);
    procedure btnMaterialDidaticoClick(Sender: TObject);
    procedure FormadePagamento1Click(Sender: TObject);
    procedure PaineldeOramento1Click(Sender: TObject);
    procedure AraraClick(Sender: TObject);
    procedure ServicosClick(Sender: TObject);
    procedure OrdemServicoClick(Sender: TObject);
    procedure PaineldeContrato1Click(Sender: TObject);
    procedure Financeiro2Click(Sender: TObject);
    procedure HistricoProduto1Click(Sender: TObject);
    procedure btnCaixaClick(Sender: TObject);
    procedure PlanodeContas1Click(Sender: TObject);
    procedure CentrodeCustos1Click(Sender: TObject);
    procedure ApuraoMensal1Click(Sender: TObject);
    procedure ipoLanamento1Click(Sender: TObject);
    procedure PrevisoOramento1Click(Sender: TObject);
    procedure AcompanhamentoPrevistoRealizado1Click(Sender: TObject);
    procedure Backup2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure btnHistoricoClick(Sender: TObject);
    procedure pnlLembreteDblClick(Sender: TObject);
    procedure estarEmail1Click(Sender: TObject);
    procedure AcompanhamentodePerformance1Click(Sender: TObject);
    procedure MalaDireta1Click(Sender: TObject);
    procedure LocalizacaoClick(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    Notif : Lembrete;
    vVerResumoAgendas : Boolean;
    vLembrarAgenda    : Boolean;
    vTempoLembrate    : TTime;
    vLembrarAgendaSMS : Boolean;
    vTempoLembrateSMS : TTime;
    vModeloModem      : Integer;
    vPortaModem       : String;
    vVelocidadeModem  : Integer;
    vTextoSMS         : TStringList;
    vUrlFotos         : String;



    procedure AbilitarUsuario;
    procedure CarregaConfiguracoes();
    { Private declarations }
  public
    vEnviarEmailAgenda: Boolean;
    vEmail: String;
    vAssunto: String;
    vTexto: TStringList;
    vUrlHtml: String;
    vArquivo: String;
    vSMTP: String;
    vUsuarioID: String;
    vSenha: String;
    vResponderPara: String ;
    vPorta: String;
    vRequerAutenticacao: Boolean;
    vUsarSSL: Boolean;
    vMetodoSSL: integer;
    vModoSSL: integer;
    vUsarTipoTLS: integer;
    vHost_Proxy: String;
    vPorta_Proxy: String;
    vUser_Proxy: String;
    vSenha_Proxy: String;

    vTextoOuHTML : integer;
    { Public declarations }
  end;

var
  principal: Tprincipal;



implementation

uses
  funcao, form_acesso_sistema, form_cadastro_usuarios, form_alterar_senha,
  untFiltroLog, form_cadastro_municipios, untDados,
  form_configuracoes, untBackup, form_cadastro_situacao_produto, form_cadastro_preferencia, form_cadastro_Tipo_Foto, Form_cadastro_tipo_documento,
  form_cadastro_Tipo_Perfil, form_cadastro_Tipo_Manequim, form_cadastro_perfil,
  form_cadastro_produto, form_cadastro_banco, form_cadastro_Avaliacao,
  form_cadastro_Evento, form_cadastro_Tipo_Convidado,
  form_cadastro_pedido_agenda, form_cadastro_questionario,
  untAcompanhaPedidoAgenda, untAgenda, form_cadastro_prospect, untOrcamento,
  form_cadastro_forma_pagamento, untAcompanhaOrcamento, untARARAS, untContrato,
  form_cadastro_Servicos, untOrdemServico, untAcompanhaOrdemServico,
  untFinanceiro, untContratoTerceiros, untAcompanhaContrato,
  untAcompanhaFinanceiro, untAcompanhaHistoricoProduto, untCadastroPlanoContas,
  untCadastroCentroCusto, untApuracaoMensal, untCadastroExplicacao,
  untPrevisaoOrcamento, untAcompanhaPrevistoRealizado, untConfigSincronismo,
  untNotificacoes, untAgendasDia, untAcompanhaPerformance, untMalaDireta,
  form_cadastro_localizacao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tprincipal.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tprincipal.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0;
    ControleVersao.ShowAlteracoes(self.Name);
  end
  else
    inherited;
end;
//FIM BOTÃO HELP


procedure Tprincipal.btn_sairClick(Sender: TObject);
begin
  close;
end;

procedure Tprincipal.Financeiro1Click(Sender: TObject);
begin
  dados.ShowConfig(principal);
  CarregaConfiguracoes();
end;

procedure Tprincipal.Financeiro2Click(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaFinanceiro') = Nil then
         Application.CreateForm(TfrmAcompanhaFinanceiro, frmAcompanhaFinanceiro);

  frmAcompanhaFinanceiro.Show;
end;

procedure Tprincipal.CarregaConfiguracoes();
var
   lTempInt: Integer;
begin

  vVerResumoAgendas      := Dados.Config(principal,'VERRESUMOAGENDAS','01 - Deseja Ver Agendas do Dia ao Iniciar o Sistema?',
                                    'Ver Resumo de Agendas do Dia ao Iniciar o Sistema.',0,
                                    tcCheck).vcBoolean;

  vLembrarAgenda         := Dados.Config(principal,'LEMBRARAGENDA','02 -Deseja Lembrar Agenda?',
                                    'Apresentar Pop-up de lembrete de Agenda.',0,
                                    tcCheck).vcBoolean;

  vTempoLembrate         := Dados.Config(principal,'TempoLembrete','03 - Tempo Lembrar Agenda',
                                    'Definir o Tempo que a agenda deve ser lembrada pelo sistema.',
                                    StrToTime('00:10:00'),tcHora).vcTime;

  vLembrarAgendaSMS      := Dados.Config(principal,'LEMBRARAGENDA_SMS','04 - Deseja Lembrar Agenda Via SMS?',
                                    'Enviar SMS para lembrar Agenda.',0,
                                    tcCheck).vcBoolean;

  vTempoLembrateSMS         := Dados.Config(principal,'TempoLembrete_SMS','05 - Tempo para Envio de SMS para Lembrete',
                                    'Definir o Tempo que a agenda deve ser lembrada pelo sistema via SMS.',
                                    StrToTime('23:59:00'),tcHora).vcTime;

  vModeloModem           := Dados.Config(principal,'MODELO_MODEM_SMS','06 - Modelo do Modem 3G',
                                    'Informe o Modelo do Modem 3G para Envio do SMS.',
                                    0,tcCodigoLookup,
                                    'Select 0 as codigo, ''Nenhum'' as Modelo from RDB$DataBase '+
                                    ' union Select 1 as codigo, ''Daruma'' as Modelo from RDB$DataBase '+
                                    ' union Select 2 as codigo, ''ZTE'' as Modelo from RDB$DataBase '+
                                    ' union Select 3 as codigo, ''Genérico'' as Modelo from RDB$DataBase',
                                    'Modelo', 'Codigo').vcInteger;

  vPortaModem            := Dados.Config(principal,'PORTA_MODEM_SMS','07 - Porta do Modem 3G',
                                    'Informe a Porta de Comunicação do Modem 3G para Envio do SMS.',
                                    'COM3',tcTexto).vcString;

  vVelocidadeModem       := Dados.Config(principal,'VELOCIDADE_MODEM_SMS','08 - Velocidade do Modem 3G',
                                    'Informe a Velocidade de Comunicação do Modem 3G para Envio do SMS.',
                                      115200,tcInteiro).vcInteger;

  vTextoSMS              := Dados.Config(principal,'TEXTO_SMS','09 - Mensagem SMS',
                                    'Defina a Mensagem do SMS.'+
                                    '    Variaveis:'+
                                    ' (@@PERFIL@@ = Nome do Perfil da Agenda)'#13+
                                    ' (@@DATA@@ = Data da Agenda)'#13+
                                    ' (@@HORA@@ = Hora da Agenda)',
                                    '',tcMemo).vcMemo;

  vUrlFotos              := Dados.Config(principal,'URL_FOTOS','10 - Diretório de Fotos',
                                    'Defina um Diretório válido aonde serão salvas as fotos no sistema.'#13+
                                    'Seram Criados dois Sub-Diretórios: "\PERFIL"  e "\PRODUTO".',
                                    ExtractFilePath(Application.ExeName)+'FOTOS',tcTexto).vcString;

  vEnviarEmailAgenda     := Dados.Config(principal,'EMAIL_ENVIAR','11 - Deseja Enviar Email da Agenda?',
                                    'Enviar Email com a Agenda.',0,
                                    tcCheck).vcBoolean;

  vEmail                 := Dados.Config(principal,'EMAIL_EMAIL','12 - EMAIL > Conta',
                                    'Defina uma Conta de Email para que seja enviado agenda para o email do perfil.',
                                    '',tcTexto).vcString;

  vAssunto               := Dados.Config(principal,'EMAIL_ASSUNTO','13 - EMAIL > Asunto',
                                    'Defina um Assunto do Email a ser Enviado.',
                                    '',tcTexto).vcString;

  vTextoOuHTML           := Dados.Config(principal,'EMAIL_TEXTO_HTML','14 - EMAIL > Email em Texto ou HTML',
                                    'Defina se a Mensagem Enviada será em Texto ou Algum arquivo HTML.',
                                    0,tcCodigoLookup,
                                    ' Select 0 as codigo, ''Texto'' as Modelo from RDB$DataBase '+
                                    ' union Select 1 as codigo, ''HTNL'' as Modelo from RDB$DataBase ',
                                    'Modelo', 'Codigo').vcInteger;

  vTexto                 := Dados.Config(principal,'EMAIL_TEXTO','15 - EMAIL > Mensagem de Texto',
                                    'Defina a Mensagem de Texto.'+
                                    '    Variaveis:'+
                                    ' (@@PERFIL@@ = Nome do Perfil da Agenda)'#13+
                                    ' (@@DATA@@ = Data da Agenda)'#13+
                                    ' (@@HORA@@ = Hora da Agenda)',
                                    '',tcMemo).vcMemo;

  vURLHtml               := Dados.Config(principal,'EMAIL_URL_HTML','16 - EMAIL > Url Arquivo HTML',
                                    'Defina a URL do arquivo HTML com o Conteúdo do Email.',
                                    '',tcTexto).vcString;

  vArquivo               := Dados.Config(principal,'EMAIL_ARQUIVO','17 - EMAIL > Url Arquivo Anexo',
                                    'Defina a URL do arquivo à se Anexado ao Email.',
                                    '',tcTexto).vcString;

  vSMTP                  := Dados.Config(principal,'EMAIL_SMTP','18 - EMAIL > Endereço SMTP',
                                    'Defina o Endereço do Servidor SMTP.',
                                    '',tcTexto).vcString;

  vUsuarioID             := Dados.Config(principal,'EMAIL_USUARIO_SMTP','19 - EMAIL > Usuário SMTP',
                                    'Defina o Usuário do Servidor SMTP.',
                                    '',tcTexto).vcString;

  vSenha                 := Dados.Config(principal,'EMAIL_SENHA_SMTP','20 - EMAIL > Senha SMTP',
                                    'Defina o Senha do Servidor SMTP.',
                                    '',tcTexto).vcString;

  vResponderPara         := Dados.Config(principal,'EMAIL_EMAIL_RESPOSTA','21 - EMAIL > Responder Para',
                                    'Defina um Email para Resposta.',
                                    '',tcTexto).vcString;

  vPorta                 := Dados.Config(principal,'EMAIL_PORTA_SMTP','22 - EMAIL > Porta SMTP',
                                    'Defina a Porta do Servidor SMTP.',
                                    '584',tcTexto).vcString;

  vRequerAutenticacao    := Dados.Config(principal,'EMAIL_REQUER_AUTENTICACAO','23 - EMAIL > Servidor Requer Autenticação?',
                                    'Defina se o Servidor SMTP requer autenticação para Envio.',True,
                                    tcCheck).vcBoolean;

  vUsarSSL               := Dados.Config(principal,'EMAIL_REQUER_AUTENTICACAO','24 - EMAIL > Usar SSL?',
                                    'Defina se o Servidor SMTP usa SSL para Envio.',False,
                                    tcCheck).vcBoolean;

  vMetodoSSL             := Dados.Config(principal,'EMAIL_METODO_SSL','25 - EMAIL > Metodo SSL',
                                    'Defina o Método SSL requerido pelo SSL no Servidor de SMTP.',
                                    4,tcCodigoLookup,
                                    ' Select 1 as codigo, ''SSL Versção 2'' as Modelo from RDB$DataBase '+
                                    ' union Select 2 as codigo, ''SSL Versção 2.3'' as Modelo from RDB$DataBase '+
                                    ' union Select 3 as codigo, ''SSL Versção 3'' as Modelo from RDB$DataBase '+
                                    ' union Select 4 as codigo, ''SSL Versção 1'' as Modelo from RDB$DataBase ',
                                    'Modelo', 'Codigo').vcInteger;

  vModoSSL               := Dados.Config(principal,'EMAIL_MODO_SSL','26 - EMAIL > Modo SSL',
                                    'Defina o Modo SSL requerido pelo SSL no Servidor de SMTP.',
                                    1,tcCodigoLookup,
                                    ' Select 1 as codigo, ''Normal'' as Modelo from RDB$DataBase '+
                                    ' union Select 2 as codigo, ''Cliente'' as Modelo from RDB$DataBase '+
                                    ' union Select 3 as codigo, ''Servidor'' as Modelo from RDB$DataBase '+
                                    ' union Select 4 as codigo, ''Cliente/Servidor'' as Modelo from RDB$DataBase ',
                                    'Modelo', 'Codigo').vcInteger;

  vUsarTipoTLS               := Dados.Config(principal,'EMAIL_TIPO_TSL','27 - EMAIL > Tipo TSL',
                                    'Defina o Tipo TSL requerido pelo SSL no Servidor de SMTP.',
                                    1,tcCodigoLookup,
                                    ' Select 1 as codigo, ''Sem suporte'' as Modelo from RDB$DataBase '+
                                    ' union Select 2 as codigo, ''Implícito'' as Modelo from RDB$DataBase '+
                                    ' union Select 3 as codigo, ''Requerido'' as Modelo from RDB$DataBase '+
                                    ' union Select 4 as codigo, ''Explícito'' as Modelo from RDB$DataBase ',
                                    'Modelo', 'Codigo').vcInteger;

  vHost_Proxy                 := Dados.Config(principal,'PROXY_HOST','28 - PROXY > Host',
                                    'Defina a Host do Servidor PROXY.',
                                    '',tcTexto).vcString;

  vPorta_Proxy                := Dados.Config(principal,'PROXY_PORTA','29 - PROXY > Porta',
                                    'Defina a Porta do Servidor PROXY.',
                                    '',tcTexto).vcString;

  vUser_Proxy                 := Dados.Config(principal,'PROXY_USUARIO','30 - PROXY > Usuário',
                                    'Defina o Usuário do Servidor PROXY.',
                                    '',tcTexto).vcString;

  vSenha_Proxy                := Dados.Config(principal,'PROXY_SENHA','31 - PROXY > Senha',
                                    'Defina a Senha do Servidor PROXY.',
                                    '',tcTexto).vcString;;

  lTempInt := Dados.Config(principal,'PERC_COMPRESS_FOTO','32 - Percentual de Compressão das Fotos',
                           'Percentual de Qualidade após Compressão das Fotos.',
                           '50',tcInteiro).vcInteger;

  if lTempInt = -99999 then
     Application.ProcessMessages;


end;

procedure Tprincipal.CentrodeCustos1Click(Sender: TObject);
begin
  If Application.FindComponent('frmCadastroCentroCusto') = Nil then
         Application.CreateForm(TfrmCadastroCentroCusto, frmCadastroCentroCusto);

  frmCadastroCentroCusto.Show;
end;

procedure Tprincipal.FormActivate(Sender: TObject);
begin
//  if not ProcurouAniversariantes then
//  begin
//    Dados.MostraAniversariantesDia(Date);
//    ProcurouAniversariantes := True;
//  end;
//
//  if dados.tblConfigTIPOENTIDADE.AsInteger = 1 then
//    Empresa1.Caption := '&Entidade'
//  else
//    Empresa1.Caption := '&Comunidade';

end;

procedure Tprincipal.FormadePagamento1Click(Sender: TObject);
begin
  if Application.FindComponent('cadastro_forma_pagamento') = Nil then
    Application.CreateForm(Tcadastro_forma_pagamento, cadastro_forma_pagamento);

  cadastro_forma_pagamento.Show;
end;

procedure Tprincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Notif.Terminate;

  Dados.BackupSeguranca;
end;

procedure Tprincipal.FormCreate(Sender: TObject);
begin
  left := 0;
  top := 0;
end;

procedure Tprincipal.AbilitarUsuario;
var
 i: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TMenuItem) then
    begin
      if ((Components[i] as TMenuItem).Name = 'Menu1') or
         ((Components[i] as TMenuItem).Name = 'Sair1') or
         ((Components[i] as TMenuItem).Name = 'Ajuda1') then
        Continue;

      Dados.geral.sql.text := 'select ativo from tabpermicoesusuario where codigousuario = '+IntToStr(untdados.CodigoUsuarioCorrente)+' and nomemenu = '+
                                    #39+(Components[i] as TMenuItem).Name+#39;
      Dados.geral.Open;
       (Components[i] as TMenuItem).Visible := Dados.geral.FieldByName('ativo').AsInteger = 1;

       if (Components[i] as TMenuItem).Name = 'Alunos1' then
          btnAlunos.Visible := (Components[i] as TMenuItem).Visible
       else if (Components[i] as TMenuItem).Name = 'ContribuiodoDizimo1' then
          btnHistorico.Visible := (Components[i] as TMenuItem).Visible
       else if (Components[i] as TMenuItem).Name = 'ColetasdaComunidade1' then
          btnMaterialDidatico.Visible := (Components[i] as TMenuItem).Visible
       else if (Components[i] as TMenuItem).Name = 'urmasAbertas2' then
          btnCaixa.Visible := (Components[i] as TMenuItem).Visible
       else if (Components[i] as TMenuItem).Name = 'RecibosEmitidos1' then
          btnMovAlunos.Visible := (Components[i] as TMenuItem).Visible;

      Dados.geral.Close;
    end;
  end;
end;

procedure Tprincipal.FormShow(Sender: TObject);
//var
  //MaisdeUmaComunidade: boolean;
begin
  {If Application.FindComponent('acesso_sistema') = Nil then
         Application.CreateForm(Tacesso_sistema, acesso_sistema);

  acesso_sistema.ShowModal;

  dados.geral.sql.text := 'Select codigo from tabcomunidade';
  dados.geral.open;
  dados.geral.last;
  dados.geral.first;
    if dados.geral.RecordCount > 1 then
      dados.CodigoComunidadeCorrente := dados.DigitarValorBD('Selecione a Comunidade',
                                                        'TABCOMUNIDADE',
                                                        1,
                                                        'NOMECOMUNIDADE',
                                                        'CODIGO',
                                                        'NOMECOMUNIDADE')
    else
      dados.CodigoComunidadeCorrente := dados.geral.fieldbyname('codigo').AsInteger;
  dados.geral.Close;

  dados.qryComunidade.Close;
  dados.qryComunidade.Open;

  dados.CodigoTurnoCorrente := dados.DigitarValorBD('Selecione o Turno','TABTURNOS',1);
   }

  Width := Screen.Width;

  CarregaConfiguracoes();

  AbilitarUsuario;

  Notif := Lembrete.Create(False,principal,pnlLembrete,IBQuery1,ACBrSMS1);

  if vVerResumoAgendas then
  begin

    dados.Geral.Sql.Text := ' select Count(codigo) xCount '#13+
                            ' from tabagenda ag             '#13+
                            '  where ag.data = :datainicio '#13+
                            '  and Coalesce(ag.situacao,0) in (0,1,3) ';
    dados.Geral.ParamByName('datainicio').AsDateTime := now;
    dados.Geral.Open;

    if dados.Geral.FieldByName('xCount').AsInteger > 0 then
    begin

      If Application.FindComponent('frmAgendasDia') = Nil then
           Application.CreateForm(TfrmAgendasDia, frmAgendasDia);

      frmAgendasDia.ShowModal;
      
    end;
  end;

end;

procedure Tprincipal.HistricoProduto1Click(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaHistoricoProduto') = Nil then
         Application.CreateForm(TfrmAcompanhaHistoricoProduto, frmAcompanhaHistoricoProduto);

  frmAcompanhaHistoricoProduto.Show;
end;

procedure Tprincipal.ipoLanamento1Click(Sender: TObject);
begin
  If Application.FindComponent('frmCadastroExplicacao') = Nil then
         Application.CreateForm(TfrmCadastroExplicacao, frmCadastroExplicacao);

  frmCadastroExplicacao.Show;
end;

procedure Tprincipal.LocalizacaoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_localizacao') = Nil then
         Application.CreateForm(Tcadastro_localizacao, cadastro_localizacao);

  cadastro_localizacao.Show;
end;

procedure Tprincipal.RastreamentoClick(Sender: TObject);
begin
  If Application.FindComponent('frmFiltroLog') = Nil then
         Application.CreateForm(TfrmFiltroLog, frmFiltroLog);

  frmFiltroLog.Show;
end;

procedure Tprincipal.Relatrios1Click(Sender: TObject);
begin
  application.MessageBox('EM DESENVOLVIMENTO','EM DESENVOLVIMENTO',MB_OK+MB_ICONEXCLAMATION);
  Abort;
//  If Application.FindComponent('frmFiltroFinanceiros') = Nil then
//         Application.CreateForm(TfrmFiltroFinanceiros, frmFiltroFinanceiros);
//
//  frmFiltroFinanceiros.Show;
end;

procedure Tprincipal.Sair1Click(Sender: TObject);
begin
  Close;
end;

procedure Tprincipal.ServicosClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Tipo_Servicos') = Nil then
         Application.CreateForm(Tcadastro_Tipo_Servicos, cadastro_Tipo_Servicos);

  cadastro_Tipo_Servicos.Show;
end;

procedure Tprincipal.Timer1Timer(Sender: TObject);
var
strdiasemana : string;
begin
   case DayOfWeek(date) of
        1 : strdiasemana := 'Dom. ';
        2 : strdiasemana := 'Seg. ';
        3 : strdiasemana := 'Ter. ';
        4 : strdiasemana := 'Qua. ';
        5 : strdiasemana := 'Qui. ';
        6 : strdiasemana := 'Sex. ';
        7 : strdiasemana := 'Sáb. ';
   end;
lblData.Caption := strdiasemana + FormatDateTime('dd/mm/yy',date);
lblHora.Caption := FormatDateTime('hh:mm:ss',Time);
end;

procedure Tprincipal.TipoConvidadoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_tipo_convidado') = Nil then
         Application.CreateForm(Tcadastro_tipo_convidado, cadastro_tipo_convidado);

  cadastro_tipo_convidado.Show;
end;

procedure Tprincipal.TipoDocumentoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_tipo_documento') = Nil then
         Application.CreateForm(Tcadastro_tipo_documento, cadastro_tipo_documento);

  cadastro_tipo_documento.Show;
end;

procedure Tprincipal.TipoFotoClick(Sender: TObject);
begin
    If Application.FindComponent('cadastro_Tipo_Foto') = Nil then
         Application.CreateForm(Tcadastro_Tipo_Foto, cadastro_Tipo_Foto);

  cadastro_Tipo_Foto.Show;
end;

procedure Tprincipal.TipoManequimClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Tipo_Manequim') = Nil then
         Application.CreateForm(Tcadastro_Tipo_Manequim, cadastro_Tipo_Manequim);

  cadastro_Tipo_Manequim.Show;
end;

procedure Tprincipal.TipoPerfilClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Tipo_Perfil') = Nil then
         Application.CreateForm(Tcadastro_Tipo_Perfil, cadastro_Tipo_Perfil);

  cadastro_Tipo_Perfil.Show;
end;

procedure Tprincipal.trocade_usuarioClick(Sender: TObject);
begin
  If Application.FindComponent('acesso_sistema') = Nil then
         Application.CreateForm(Tacesso_sistema, acesso_sistema);

  acesso_sistema.ShowModal;

  AbilitarUsuario;
end;

procedure Tprincipal.trocar_senhaClick(Sender: TObject);
begin
  If Application.FindComponent('alterar_senha') = Nil then
         Application.CreateForm(Talterar_senha, alterar_senha);

  alterar_senha.ShowModal;
end;

procedure Tprincipal.AcompanhamentodePerformance1Click(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaPerformance') = Nil then
         Application.CreateForm(TfrmAcompanhaPerformance, frmAcompanhaPerformance);

  frmAcompanhaPerformance.Show;
end;

procedure Tprincipal.AcompanhamentoPrevistoRealizado1Click(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaPrevistoRealizado') = Nil then
         Application.CreateForm(TfrmAcompanhaPrevistoRealizado, frmAcompanhaPrevistoRealizado);

  frmAcompanhaPrevistoRealizado.Show;
end;

procedure Tprincipal.AcompanhaPedidoAgendaClick(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaPedidoAgenda') = Nil then
         Application.CreateForm(TfrmAcompanhaPedidoAgenda, frmAcompanhaPedidoAgenda);

  frmAcompanhaPedidoAgenda.Show;
end;

procedure Tprincipal.AgendasClick(Sender: TObject);
begin
  if Assigned(frmAgenda) then
    FreeAndNil(frmAgenda);

  Application.CreateForm(TfrmAgenda, frmAgenda);

  frmAgenda.cConfirmarHorario := False;
  frmAgenda.Show;
end;

procedure Tprincipal.Ajuda1Click(Sender: TObject);
begin

  Application.MessageBox(Pchar('AMV System 1.0'+#13+
                           'Uso exclusivo de: Achei Meu Vestido'+#13+
                           ''+#13+
                           'Analista: Junior Cezar Delgado'+#13+
                           'Telefone: 27 3219-1195 Celular: 27 99607-5888'+#13+
                           'E-mail: juniorcesarcontador@gmail.com'+#13+
                           ''+#13+
                           'Desenvolvedor: Fábio Sant Anna Maduro'#13+
                           'Celular: 27 99227-9544'+#13+
                           'E-mail: fsmaduro2013@gmail.com'+#13+
                           ''+#13+
                           'Desenvolvedor: Bruno Leone'#13+
                           'Celular: 27 99902-2010'+#13+
                           'E-mail: bruno.rodn@gmail.com'+#13+
                           ''+#13+
                           'Inicio do Desenvolvimento: Fevereiro de 2015'+#13+
                           'Previsão de Termino: Agosto de 2015'+#13+
                           'Complementa Fase Final do Projeto (Ajustes e Melhorias)'), 'Registro', MB_OK + MB_ICONINFORMATION);
end;

procedure Tprincipal.ApuraoMensal1Click(Sender: TObject);
begin
  If Application.FindComponent('frmApuracaoMensal') = Nil then
         Application.CreateForm(TfrmApuracaoMensal, frmApuracaoMensal);

  frmApuracaoMensal.Show;
end;

procedure Tprincipal.AraraClick(Sender: TObject);
begin
  If Application.FindComponent('frmARARAS') = Nil then
         Application.CreateForm(TfrmARARAS, frmARARAS);

  frmARARAS.Show;
end;

procedure Tprincipal.Avaliao1Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Avaliacao') = Nil then
         Application.CreateForm(TCadastro_Avaliacao, Cadastro_Avaliacao);

  Cadastro_Avaliacao.Show;
end;

procedure Tprincipal.Backup1Click(Sender: TObject);
begin
  If Application.FindComponent('frmBackup') = Nil then
    Application.CreateForm(TfrmBackup, frmBackup);

  frmBackup.Show;
end;

procedure Tprincipal.Backup2Click(Sender: TObject);
begin
  If Application.FindComponent('frmConfigSincronismo') = Nil then
         Application.CreateForm(TfrmConfigSincronismo, frmConfigSincronismo);

  frmConfigSincronismo.Show;
end;

procedure Tprincipal.BancoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Banco') = Nil then
         Application.CreateForm(Tcadastro_Banco, cadastro_Banco);

  cadastro_Banco.Show;
end;

procedure Tprincipal.btnAlunosClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
         Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.Show;
end;

procedure Tprincipal.btnCaixaClick(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaContrato') = Nil then
         Application.CreateForm(TfrmAcompanhaContrato, frmAcompanhaContrato);

  frmAcompanhaContrato.Show;
end;

procedure Tprincipal.btnHistoricoClick(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaHistoricoProduto') = Nil then
         Application.CreateForm(TfrmAcompanhaHistoricoProduto, frmAcompanhaHistoricoProduto);

  frmAcompanhaHistoricoProduto.Show;
end;

procedure Tprincipal.btnMaterialDidaticoClick(Sender: TObject);
begin
  AgendasClick(self);
end;

procedure Tprincipal.btnMovAlunosClick(Sender: TObject);
begin
  AcompanhaPedidoAgendaClick(self);
end;

procedure Tprincipal.btnSairClick(Sender: TObject);
begin
  close;
end;

procedure Tprincipal.cadastro_usuarioClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_usuarios') = Nil then
         Application.CreateForm(Tcadastro_usuarios, cadastro_usuarios);

  cadastro_usuarios.Show;
end;

procedure Tprincipal.Empresa1Click(Sender: TObject);
begin
  application.MessageBox('EM DESENVOLVIMENTO','EM DESENVOLVIMENTO',MB_OK+MB_ICONEXCLAMATION);
  Abort;

//  If Application.FindComponent('cadastro_comunidade') = Nil then
//         Application.CreateForm(Tcadastro_comunidade, cadastro_comunidade);
//
//  cadastro_comunidade.Show;
end;

procedure Tprincipal.estarEmail1Click(Sender: TObject);
var
  sLog: TSTringList;
  EmailDestino: String;
begin
  sLog := TStringList.Create;
  try
    InputQuery('Email','Email de Destino:',EmailDestino);

    if Trim(EmailDestino) = '' then
      ShowMessage('Email Obrigatorio');

    if EnviarEmailAutomatico(vEmail,
                             EmailDestino,
                             '',
                             vAssunto,
                             'TESTE DE EMAIL AUTOMATICO AMV SYSTEM',
                             nil,
                             vArquivo,
                             vSMTP,
                             vUsuarioID,
                             vSenha,
                             vResponderPara,
                             vPorta,
                             vRequerAutenticacao,
                             vUsarSSL,
                             vMetodoSSL,
                             vModoSSL,
                             vUsarTipoTLS,
                             vHost_Proxy,
                             vPorta_Proxy,
                             vUser_Proxy,
                             vSenha_Proxy,
                             True,
                             sLog) then
    begin
      ShowMessage(Pchar('Email Enviado com Sucesso!'#13#13'LOG:'#13+
                  sLog.Text));
    end
    else
      ShowMessage(Pchar('Falha no Envio do Email!'#13#13'LOG:'#13+
                  sLog.Text));

  finally
    FreeAndNil(sLog);
  end;
end;

procedure Tprincipal.EventoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_evento') = Nil then
         Application.CreateForm(Tcadastro_evento, cadastro_evento);

  cadastro_evento.Show;
end;

procedure Tprincipal.SituacaoProdutoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_situacao_produto') = Nil then
         Application.CreateForm(Tcadastro_situacao_produto, cadastro_situacao_produto);

  cadastro_situacao_produto.Show;
end;

procedure Tprincipal.SituaodoProdutoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_situacao_produto') = Nil then
         Application.CreateForm(Tcadastro_situacao_produto, cadastro_situacao_produto);

  cadastro_situacao_produto.Show;
end;

procedure Tprincipal.SpeedButton1Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_produto') = Nil then
         Application.CreateForm(Tcadastro_produto, cadastro_produto);

  cadastro_produto.Show;
end;

procedure Tprincipal.SpeedButton2Click(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaOrcamento') = Nil then
         Application.CreateForm(TfrmAcompanhaOrcamento, frmAcompanhaOrcamento);

  frmAcompanhaOrcamento.Show;
end;

procedure Tprincipal.SpeedButton3Click(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaOrdemServico') = Nil then
         Application.CreateForm(TfrmAcompanhaOrdemServico, frmAcompanhaOrdemServico);

  frmAcompanhaOrdemServico.Show;
end;

procedure Tprincipal.MalaDireta1Click(Sender: TObject);
begin
  If Application.FindComponent('frmMalaDireta') = Nil then
         Application.CreateForm(TfrmMalaDireta, frmMalaDireta);

  frmMalaDireta.Show;
end;

procedure Tprincipal.Municpios1Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_municipios') = Nil then
         Application.CreateForm(Tcadastro_municipios, cadastro_municipios);

  cadastro_municipios.Show;
end;

procedure Tprincipal.OrdemServicoClick(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaOrdemServico') = Nil then
         Application.CreateForm(TfrmAcompanhaOrdemServico, frmAcompanhaOrdemServico);

  frmAcompanhaOrdemServico.Show;
end;

procedure Tprincipal.PaineldeContrato1Click(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaContrato') = Nil then
         Application.CreateForm(TfrmAcompanhaContrato, frmAcompanhaContrato);

  frmAcompanhaContrato.Show;
end;

procedure Tprincipal.PaineldeOramento1Click(Sender: TObject);
begin
  If Application.FindComponent('frmPainelOrcamento') = Nil then
         Application.CreateForm(TfrmAcompanhaOrcamento, frmAcompanhaOrcamento);

  frmAcompanhaOrcamento.Show;
end;

procedure Tprincipal.PedidoAgendaClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_pedido_agenda') = Nil then
         Application.CreateForm(Tcadastro_pedido_agenda, cadastro_pedido_agenda);

  cadastro_pedido_agenda.Show;
end;

procedure Tprincipal.PlanodeContas1Click(Sender: TObject);
begin
  If Application.FindComponent('frmCadastroPlanoContas') = Nil then
         Application.CreateForm(TfrmCadastroPlanoContas, frmCadastroPlanoContas);

  frmCadastroPlanoContas.Show;
end;

procedure Tprincipal.pnlLembreteDblClick(Sender: TObject);
begin
  If Application.FindComponent('frmNotificacoes') = Nil then
         Application.CreateForm(TfrmNotificacoes, frmNotificacoes);

  frmNotificacoes.ShowModal;
end;

procedure Tprincipal.PreferenciasClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_preferencia') = Nil then
         Application.CreateForm(Tcadastro_preferencia, cadastro_preferencia);

  cadastro_preferencia.Show;

end;

procedure Tprincipal.PrevisoOramento1Click(Sender: TObject);
begin
  If Application.FindComponent('frmPrevisaoOrcamento') = Nil then
         Application.CreateForm(TfrmPrevisaoOrcamento, frmPrevisaoOrcamento);

  frmPrevisaoOrcamento.Show;
end;

procedure Tprincipal.ProdutoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_produto') = Nil then
         Application.CreateForm(Tcadastro_produto, cadastro_produto);

  cadastro_produto.Show;
end;

procedure Tprincipal.ProspectClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_prospect') = Nil then
    Application.CreateForm(Tcadastro_prospect, cadastro_prospect);

  cadastro_prospect.Show;
end;

procedure Tprincipal.Questionrio1Click(Sender: TObject);
begin
  If Application.FindComponent('Cadastro_Questionario') = Nil then
    Application.CreateForm(TCadastro_Questionario, Cadastro_Questionario);

  Cadastro_Questionario.Show;
end;

end.
