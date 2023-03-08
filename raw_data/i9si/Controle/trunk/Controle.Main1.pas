unit Controle.Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniBasicGrid,
  uniDBGrid, uniDBNavigator, unimDBNavigator, uniButton, uniBitBtn,
  uniColorButton, uniMenuButton, uniEdit, uniDBEdit,
  uniSpeedButton, uniPanel, uniToolBar, uniImage, Vcl.Imaging.pngimage,
  uniPageControl, uniGUIFrame, uniStatusBar, System.ImageList, Vcl.ImgList,
  uniLabel, uniSplitter, uniScreenMask, uniChart, Vcl.Imaging.jpeg, uniURLFrame,
  uniSyntaxEditorBase, uniSyntaxEditor, uniCalendarPanel, uniCalendar, uniTimer,
  uniDateTimePicker, Data.Win.ADODB, Datasnap.Provider, Data.DB,
  Datasnap.DBClient, uniCanvas, uniRadioGroup, uniCheckBox, uniRadioButton,
  uniScrollBox,   uniHTMLFrame, uniDBText,
  Vcl.ExtCtrls, uniMultiItem, uniComboBox, uniDBComboBox, uniDBLookupComboBox,
  uniGUIApplication, uniGUIVars, 
  uniImageList,  DateUtils, uniTreeView, uniWidgets, Vcl.Menus,
  uniMainMenu;

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
    ImageLoginInicial: TUniImage;
    UniImage2: TUniImage;
    Timer1: TTimer;
    UniImageList2: TUniImageList;
    MenuPanel_08: TUniPanel;
    MenuPanel_09: TUniPanel;
    UniPanel11: TUniPanel;
    BotaoMenuProfissionalTipo: TUniButton;
    BotaMenuTipoAtendimento: TUniButton;
    BotaMenuConvenio: TUniButton;
    BotaMenuEscolaridade: TUniButton;
    MenuPanel_10: TUniPanel;
    MenuPanel_11: TUniPanel;
    UniPanel18: TUniPanel;
    BotaoMenuUsuariosClinica: TUniButton;
    UniButton1: TUniButton;
    UniButton12: TUniButton;
    BotaoMenuBancoClinica: TUniButton;
    BotaoMenuContaBancariaClinica: TUniButton;
    BotaoMenuTipoTituloClinica: TUniButton;
    MenuPanel_13: TUniPanel;
    UniPanel19: TUniPanel;
    UniButton17: TUniButton;
    BotaoMenuDocumentosClinica: TUniButton;
    BotaoMenuVideosImagensClinica: TUniButton;
    pagePrincipal: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniStatusBar1: TUniStatusBar;
    AlertaMain: TUniSFSweetAlert;
    UniSFHold_Aguarde: TUniSFHold;
    MenuPanel_14: TUniPanel;
    UniPanel8: TUniPanel;
    BotaoMenuEvolucaoPaciente: TUniButton;
    BotaoMenuFichaAnalise01_01: TUniButton;
    BotaoMenuFichaAnalise01_02: TUniButton;
    BotaoMenuFichaAnalise01_03: TUniButton;
    BotaoMenuFichaAnalise01_04: TUniButton;
    BotaoMenuFichaAnalise01_05: TUniButton;
    BotaoMenuFichaAnalise01_06: TUniButton;
    BotaoMenuFichaAnalise01_07: TUniButton;
    BotaoMenuFichaAnalise01_08: TUniButton;
    BotaoMenuFichaAnalise01_09: TUniButton;
    BotaoMenuFichaAnalise01_10: TUniButton;
    BotaoMenuFichaAnalise02_01: TUniButton;
    BotaoMenuFichaAnalise02_02: TUniButton;
    BotaoMenuFichaAnalise02_03: TUniButton;
    BotaoMenuFichaAnalise02_04: TUniButton;
    BotaoMenuFichaAnalise02_05: TUniButton;
    BotaoMenuFichaAnalise02_06: TUniButton;
    BotaoMenuFichaAnalise02_07: TUniButton;
    BotaoMenuFichaAnalise02_08: TUniButton;
    BotaoMenuFichaAnalise02_09: TUniButton;
    BotaoMenuFichaAnalise02_10: TUniButton;
    BotaoMenuFichaAnalise03_01: TUniButton;
    BotaoMenuFichaAnalise03_02: TUniButton;
    BotaoMenuFichaAnalise03_03: TUniButton;
    BotaoMenuFichaAnalise03_04: TUniButton;
    BotaoMenuFichaAnalise03_05: TUniButton;
    BotaoMenuFichaAnalise03_06: TUniButton;
    BotaoMenuFichaAnalise03_07: TUniButton;
    BotaoMenuFichaAnalise03_08: TUniButton;
    BotaoMenuFichaAnalise03_09: TUniButton;
    BotaoMenuFichaAnalise03_10: TUniButton;
    UniButton4: TUniButton;
    BotaoMenuEmpresaClinica: TUniButton;
    BotaoMenuFornecedorClinica: TUniButton;
    UniButton16: TUniButton;
    BotaoMenuResponsavel: TUniButton;
    BotaoMenuPaciente: TUniButton;
    BotaoMenuProfissional: TUniButton;
    UniButton8: TUniButton;
    BotaoMenuTitulosReceberClinica: TUniButton;
    BotaoMenuTitulosPagarClinica: TUniButton;
    BotaoMenuCaixa: TUniButton;
    UniPanel2: TUniPanel;
    BotaoMenuMontaAvaliacaoClinica: TUniButton;
    UniPageCalendario: TUniPageControl;
    UniTabSheet4: TUniTabSheet;
    UniPageControlDiaDet: TUniPageControl;
    UniTabSheet6: TUniTabSheet;
    UniPanel12: TUniPanel;
    UniCalendarioDiario: TUniCalendarPanel;
    UniTabSheet7: TUniTabSheet;
    UniPanel15: TUniPanel;
    UniHTMLFrame1: TUniHTMLFrame;
    UniTabSheet5: TUniTabSheet;
    UniCalendarioSemanal: TUniCalendarPanel;
    UniTabSheet8: TUniTabSheet;
    UniCalendarioMensal: TUniCalendarPanel;
    UniPanelGestaoAgenda: TUniPanel;
    UniPanel13: TUniPanel;
    UniDateTimeInicial: TUniDateTimePicker;
    UniPanel14: TUniPanel;
    UniButton6: TUniButton;
    UniButton5: TUniButton;
    UniButton7: TUniButton;
    UniPanel3: TUniPanel;
    UniCheckBox5: TUniCheckBox;
    UniCheckBox2: TUniCheckBox;
    UniCheckBox3: TUniCheckBox;
    UniCheckBox1: TUniCheckBox;
    UniCheckBox6: TUniCheckBox;
    UniPanelPesquisaAgenda: TUniPanel;
    UniEdit2: TUniEdit;
    UniButton9: TUniButton;
    UniPanel1: TUniPanel;
    UniPanel10: TUniPanel;
    UniPanel16: TUniPanel;
    UniButton2: TUniButton;
    UniButton3: TUniButton;
    BotaoDescartar: TUniButton;
    UniImageList3: TUniImageList;
    UniButton10: TUniButton;
    UniPopupMenu1: TUniPopupMenu;
    Cadastrodefornecedor1: TUniMenuItem;
    Cadastrodepaciente1: TUniMenuItem;
    procedure BotaoMenuClienteClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure BotaoMenuFornecedorClick(Sender: TObject);
    procedure BotaoMenuVendedorClick(Sender: TObject);
    procedure BotaoMenuEmpresaClick(Sender: TObject);
    procedure BotaoMenuDashBoardClick(Sender: TObject);
    procedure BotaoMenuAuditoriaClick(Sender: TObject);
    procedure BotaoMenuUsuariosClick(Sender: TObject);
    procedure BotaoMenuCadastroClick(Sender: TObject);
    procedure UniURLFrame1FrameLoaded(Sender: TObject);
    procedure BotaoMenuSchemaClick(Sender: TObject);
    procedure BotaoSchemaCadastroClick(Sender: TObject);
    procedure BotaoMenuProfissionalTipoClick(Sender: TObject);
    procedure BotaoMenuEmpresaClinicaClick(Sender: TObject);
    procedure BotaoMenuProfissionalClick(Sender: TObject);
    procedure BotaMenuEscolaridadeClick(Sender: TObject);
    procedure BotaoMenuResponsavelClick(Sender: TObject);
    procedure BotaoMenuPacienteClick(Sender: TObject);
    procedure UniImage4Click(Sender: TObject);
    procedure UniButton5Click(Sender: TObject);
    procedure UniButton6Click(Sender: TObject);
    procedure UniButton7Click(Sender: TObject);
    procedure UniDateTimeInicialChange(Sender: TObject);
    procedure UniPageCalendarioChange(Sender: TObject);
    procedure UniCalendarioDiarioDayClick(Sender: TUniCalendarPanel;
      ADate: TDateTime; Allday: Boolean);
    procedure UniCalendarioDiarioEventClick(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent);
    procedure UniCalendarioSemanalEventClick(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent);
    procedure UniCalendarioMensalEventClick(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent);
    procedure BotaoMenuUsuariosClinicaClick(Sender: TObject);
    procedure UniCalendarioDiarioEventMove(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate,
      AEndDate: TDateTime; var Handled: Boolean);
    procedure UniCalendarioDiarioEventResize(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate,
      AEndDate: TDateTime; var Handled: Boolean);
    procedure UniCalendarioSemanalDayClick(Sender: TUniCalendarPanel;
      ADate: TDateTime; Allday: Boolean);
    procedure UniCalendarioMensalDayClick(Sender: TUniCalendarPanel;
      ADate: TDateTime; Allday: Boolean);
    procedure UniCalendarioSemanalEventMove(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate,
      AEndDate: TDateTime; var Handled: Boolean);
    procedure UniCalendarioMensalEventMove(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate,
      AEndDate: TDateTime; var Handled: Boolean);
    procedure UniCalendarioSemanalEventResize(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate,
      AEndDate: TDateTime; var Handled: Boolean);
    procedure UniCalendarioMensalEventResize(Sender: TUniCalendarPanel;
      AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate,
      AEndDate: TDateTime; var Handled: Boolean);
    procedure UniImage1Click(Sender: TObject);
    procedure BotaoMenuMontaAvaliacaoClinicaClick(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_01Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_02Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_03Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_04Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_05Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_06Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_07Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_08Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_09Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise01_10Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_01Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_02Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_03Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_04Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_05Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_06Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_07Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_08Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_09Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise02_10Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_01Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_02Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_03Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_04Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_05Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_06Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_07Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_08Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_09Click(Sender: TObject);
    procedure BotaoMenuFichaAnalise03_10Click(Sender: TObject);
    procedure UniHTMLFrame1AjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure Timer1Timer(Sender: TObject);
    procedure BotaMenuTipoAtendimentoClick(Sender: TObject);
    procedure UniPageControlDiaDetChange(Sender: TObject);
    procedure BotaMenuConvenioClick(Sender: TObject);
    procedure BotaoMenuBancoClick(Sender: TObject);
    procedure BotaoMenuContaBancariaClick(Sender: TObject);
    procedure BotaoMenuTipoTituloClick(Sender: TObject);
    procedure BotaoMenuTitulosReceberClick(Sender: TObject);
    procedure BotaoMenuTitulosPagarClick(Sender: TObject);
    procedure BotaoMenuMainRepresentanteClick(Sender: TObject);
    procedure BotaoMenuRepresentanteClick(Sender: TObject);
    procedure BotaoMenuCaixaClick(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure UniFormBeforeShow(Sender: TObject);
    procedure BotaoMenuEvolucaoPacienteClick(Sender: TObject);
    procedure UniCalendarioSemanalRangeSelect(Sender: TUniCalendarPanel;
      AStartDate, AEndDate: TDateTime);
    procedure UniCalendarioDiarioRangeSelect(Sender: TUniCalendarPanel;
      AStartDate, AEndDate: TDateTime);
    procedure MenuPanel_10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BotaoDescartarClick(Sender: TObject);
    procedure UniButton3Click(Sender: TObject);
    procedure UniButton2Click(Sender: TObject);
    procedure UniButton10Click(Sender: TObject);
    procedure UniFormShow(Sender: TObject);


  private
    { Private declarations }
    procedure NovaAba(nomeFormFrame: TFrame; descFormFrame: string; Fechar: Boolean);
    function LocalizaPanelMenu(Nome_Interno: String): Boolean;

    function SelecionaMontaAvaliacao(SequenciaID: Integer): String;
    Procedure CarregaListaDeAtendimentos();
//    procedure CarregaListaDeAtendimentos2;
  public
    { Public declarations }
   FSequenciaID_MontaAvaliacao: Integer;
   Mensagens : TUniSFiGrowl;
   type
      TMensageiroCor      = (Azul, Verde, Amarelo, Branco, Vermelho, Transparente);
      TMensageiroTamanho  = (Pequeno, Medio);
      TMensageiroPosicaoX = (Direita, Esquerda, Centro);
      TMensageiroPosicaoY = (Superior, Inferior);
    procedure Mensageiro(Texto: string;
                               Titulo: String;
                               Tempo: integer = 5000;
                               Cor: TMensageiroCor = Verde;
                               Tamanho: TMensageiroTamanho = Medio;
                               PosicaoX: TMensageiroPosicaoX = Centro;
                               PosicaoY: TMensageiroPosicaoY = Superior);
    procedure CarregandoMenu;
    procedure CarregandoOpcoesInicio;
    procedure MontaCalendario(Calend : TUniCalendarPanel;
                              DataHora: TDateTime);
  end;

function ControleMain: TControleMain;

implementation

{$R *.dfm}

uses
  // Referente as units compartilhadas do controle
  Controle.Main.Module,
  Controle.Consulta.Fornecedor,
  Controle.Consulta.Cliente,
  Controle.Consulta.Filial,
//  Controle.Login,
  Controle.DashBoard,
  Controle.Consulta.Vendedor,
  Controle.Server.Module,
  Controle.Livre.Auditoria,
  Controle.Consulta.Menu,
  Controle.Modal.Ajuda,
  Controle.Consulta.Menu.Schema,
  Controle.Consulta.Schema,
  Controle.Consulta.Banco,
  Controle.Consulta.ContaBancaria,
  Controle.Consulta.TipoTitulo,
  Clinica.Consulta.TituloReceber,
  Controle.Consulta.TituloPagar,
  Controle.Funcoes,
  Controle.Consulta.Usuario,
  Clinica.Module.Principal,
  Clinica.Consulta.ProfissionalTipo,
  Clinica.Consulta.Profissional,
  Clinica.Consulta.Escolaridade,
  Clinica.Consulta.Responsavel,
  Clinica.Consulta.Paciente,
  Clinica.Cadastro.Agenda,
  Clinica.Consulta.Avaliacao,
  Clinica.Consulta.Avaliacao01,
  Clinica.Consulta.Avaliacao02,
  Clinica.Consulta.Avaliacao03,
  Clinica.Consulta.Avaliacao04,
  Clinica.Consulta.Avaliacao05,
  Clinica.Consulta.Avaliacao06,
  Clinica.Consulta.Avaliacao07,
  Clinica.Consulta.Avaliacao08,
  Clinica.Consulta.Avaliacao09,
  Clinica.Consulta.Avaliacao10,
  Clinica.Consulta.Avaliacao11,
  Clinica.Consulta.Avaliacao12,
  Clinica.Consulta.Avaliacao13,
  Clinica.Consulta.Avaliacao14,
  Clinica.Consulta.Avaliacao15,
  Clinica.Consulta.Avaliacao16,
  Clinica.Consulta.Avaliacao17,
  Clinica.Consulta.Avaliacao18,
  Clinica.Consulta.Avaliacao19,
  Clinica.Consulta.Avaliacao20,
  Clinica.Consulta.Avaliacao21,
  Clinica.Consulta.Avaliacao22,
  Clinica.Consulta.Avaliacao23,
  Clinica.Consulta.Avaliacao24,
  Clinica.Consulta.Avaliacao25,
  Clinica.Consulta.Avaliacao26,
  Clinica.Consulta.Avaliacao27,
  Clinica.Consulta.Avaliacao28,
  Clinica.Consulta.Avaliacao29,
  Clinica.Consulta.Avaliacao30,
  Clinica.Consulta.Monta.Avaliacao,
  Clinica.Consulta.Modal.Profissional,
  Clinica.Consulta.TipoAtendimento,
  Clinica.Consulta.Convenio,
  Controle.Consulta.Caixa,
  Clinica.Consulta.Evolucao.Paciente,
  Controle.Consulta.Sugestao,
  Controle.Consulta.Tutorial,
  UniSFCore;

function ControleMain: TControleMain;
begin
  Result := TControleMain(ControleMainModule.GetFormInstance(TControleMain));
end;

procedure TControleMain.BotaoMenuBancoClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaBanco),'Bancos',True);
end;

procedure TControleMain.BotaoMenuContaBancariaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaContaBancaria),'Contas bancárias',True);
end;

procedure TControleMain.BotaMenuConvenioClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaConvenio),'Convênio',True);
end;

procedure TControleMain.BotaMenuEscolaridadeClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaEscolaridade),'Escolaridade',True);
end;

procedure TControleMain.BotaMenuTipoAtendimentoClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaTipoAtendimento),'Tipo de atendimento',True);
end;

procedure TControleMain.BotaoDescartarClick(Sender: TObject);
begin
  with AlertaMain do
  begin
    QuestionBasic('Encerrar aplicação',
                  procedure(const ButtonClicked: TAButton)
                  begin
                    if ButtonClicked = abConfirm then
                    begin
                      ScreenMask.Hide;
                      UniSession.Terminate( );
                      UniSession.UniApplication.Terminate( );
                    end;
                  end,
                  'A aplicação será encerrada'
                  );
  end;
end;

procedure TControleMain.BotaoMenuAuditoriaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleLivreAuditoria),'Auditoria',True);
end;

procedure TControleMain.BotaoMenuClienteClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaCliente),'Clientes',True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_01Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 1;
  NovaAba(TFrame(TClinicaConsultaAvaliacao01),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(1))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_02Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 2;
  NovaAba(TFrame(TClinicaConsultaAvaliacao02),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(2))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_03Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 3;
  NovaAba(TFrame(TClinicaConsultaAvaliacao03),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(3))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_04Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 4;
  NovaAba(TFrame(TClinicaConsultaAvaliacao04),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(4))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_05Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 5;
  NovaAba(TFrame(TClinicaConsultaAvaliacao05),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(5))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_06Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 6;
  NovaAba(TFrame(TClinicaConsultaAvaliacao06),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(6))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_07Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 7;
  NovaAba(TFrame(TClinicaConsultaAvaliacao07),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(7))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_08Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 8;
  NovaAba(TFrame(TClinicaConsultaAvaliacao08),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(8))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_09Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 9;
  NovaAba(TFrame(TClinicaConsultaAvaliacao09),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(9))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise01_10Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 10;
  NovaAba(TFrame(TClinicaConsultaAvaliacao10),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(10))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_01Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 11;
  NovaAba(TFrame(TClinicaConsultaAvaliacao11),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(11))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_02Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 12;
  NovaAba(TFrame(TClinicaConsultaAvaliacao12),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(12))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_03Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 13;
  NovaAba(TFrame(TClinicaConsultaAvaliacao13),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(13))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_04Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 14;
  NovaAba(TFrame(TClinicaConsultaAvaliacao14),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(14))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_05Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 15;
  NovaAba(TFrame(TClinicaConsultaAvaliacao15),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(15))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_06Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 16;
  NovaAba(TFrame(TClinicaConsultaAvaliacao16),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(16))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_07Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 17;
  NovaAba(TFrame(TClinicaConsultaAvaliacao17),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(17))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_08Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 18;
  NovaAba(TFrame(TClinicaConsultaAvaliacao18),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(18))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_09Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 19;
  NovaAba(TFrame(TClinicaConsultaAvaliacao19),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(19))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise02_10Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 20;
  NovaAba(TFrame(TClinicaConsultaAvaliacao20),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(20))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_01Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 21;
  NovaAba(TFrame(TClinicaConsultaAvaliacao21),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(21))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_02Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 22;
  NovaAba(TFrame(TClinicaConsultaAvaliacao22),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(22))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_03Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 23;
  NovaAba(TFrame(TClinicaConsultaAvaliacao23),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(23))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_04Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 24;
  NovaAba(TFrame(TClinicaConsultaAvaliacao24),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(24))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_05Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 25;
  NovaAba(TFrame(TClinicaConsultaAvaliacao25),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(25))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_06Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 26;
  NovaAba(TFrame(TClinicaConsultaAvaliacao26),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(26))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_07Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 27;
  NovaAba(TFrame(TClinicaConsultaAvaliacao27),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(27))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_08Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 28;
{  NovaAba(TFrame(TClinicaConsultaAvaliacao28),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(28))),
                 True);}
end;

procedure TControleMain.BotaoMenuFichaAnalise03_09Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 29;
  NovaAba(TFrame(TClinicaConsultaAvaliacao29),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(29))),
                 True);
end;

procedure TControleMain.BotaoMenuFichaAnalise03_10Click(Sender: TObject);
begin
  FSequenciaID_MontaAvaliacao := 30;
 { NovaAba(TFrame(TClinicaConsultaAvaliacao30),
                 ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(30))),
                 True);}
end;

procedure TControleMain.BotaoMenuFornecedorClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaFornecedor),'Fornecedores',True);
end;

procedure TControleMain.BotaoMenuMainRepresentanteClick(Sender: TObject);
begin
   NovaAba(TFrame(TControleDashBoard),'Painel de controle',True);
end;

procedure TControleMain.BotaoMenuMontaAvaliacaoClinicaClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaMontaAvaliacao),'Monta avaliação',True);
end;

procedure TControleMain.BotaoMenuPacienteClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaPaciente),'Pacientes',True);
end;

procedure TControleMain.BotaoMenuProfissionalClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaProfissional),'Terapeutas',True);
end;

procedure TControleMain.BotaoMenuProfissionalTipoClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaProfissionalTipo),'Área dos terapeutas',True);
end;

procedure TControleMain.BotaoMenuRepresentanteClick(Sender: TObject);
begin
// NovaAba(TFrame(TControleConsultaRepresentante),'Representante',True);
end;

procedure TControleMain.BotaoMenuResponsavelClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaResponsavel),'Responsáveis',True);
end;

procedure TControleMain.BotaoMenuCadastroClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaMenu),'Menus',True);
end;

procedure TControleMain.BotaoMenuCaixaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaCaixa), 'Fluxo de caixa', True);
end;

procedure TControleMain.BotaoMenuVendedorClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaVendedor),'Vendedores',True);
end;

procedure TControleMain.BotaoMenuSchemaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaMenuSchema),'Menus do schema',True);
end;

procedure TControleMain.BotaoMenuTipoTituloClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaTipoTitulo),'Tipo título',True);
end;

procedure TControleMain.BotaoMenuTitulosPagarClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaTituloPagar),'Títulos a pagar',True);
end;

procedure TControleMain.BotaoMenuTitulosReceberClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaTituloReceber),'Títulos a receber',True);
end;

procedure TControleMain.BotaoSchemaCadastroClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaSchema),'Schemas',True);
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
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não é possível inserir a imagem');
  End;

  with FCurrentFrame do
  begin
    Align               := alClient;
    Parent              := TabSheet;
  end;

  Refresh;

  pagePrincipal.ActivePage := TabSheet;
end;

procedure TControleMain.BotaoMenuDashBoardClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleDashBoard),'Painel de controle',True);
end;

procedure TControleMain.BotaoMenuEmpresaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaFilial),'Empresa',True);
end;

procedure TControleMain.BotaoMenuUsuariosClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaUsuario),'Usuários',True);
end;

procedure TControleMain.BotaoMenuUsuariosClinicaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaUsuario),'Usuários',True);
end;

procedure TControleMain.BotaoMenuEmpresaClinicaClick(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaFilial),'Empresa',True);
end;

procedure TControleMain.BotaoMenuEvolucaoPacienteClick(Sender: TObject);
begin
  NovaAba(TFrame(TClinicaConsultaEvolucaoPaciente),'Evolução',True);
end;

procedure TControleMain.UniButton6Click(Sender: TObject);
begin
  UniPageCalendario.ActivePageIndex := 0;
  MontaCalendario(UniCalendarioDiario,
                  UniDateTimeInicial.DateTime);

  // alterar o javascript que mostra o agendameneto diario, quando usa a barra

end;

procedure TControleMain.UniButton10Click(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaTutorial),'Vídeos de ajuda',True);
end;

procedure TControleMain.UniButton2Click(Sender: TObject);
begin
  NovaAba(TFrame(TControleConsultaSugestao),'Sugestões',True);
end;

procedure TControleMain.UniButton3Click(Sender: TObject);
var
  URL_WhatsApp: String;
begin
  //URL_WhatsApp := 'https://web.whatsapp.com/send?phone=55' + ControleFuncoes.RemoveMascara(AText) + '?text=' + '%20' + 'Prezado cliente, segue o link do boleto da empresa ' + ControleMainModule.FNomeFantasia +' : '+ CdsConsultaLINK_WHATSAPP.AsString + '%20';
  URL_WhatsApp := 'https://wa.me/55' + '81991425896' + '?text='  + 'Preciso de suporte para a empresa ' + ControleMainModule.FNomeFantasia;
  UniSession.AddJS('window.open('+'"'+ URL_WhatsApp + '"'+')');
end;

procedure TControleMain.UniButton5Click(Sender: TObject);
begin
  UniPageCalendario.ActivePageIndex := 1;
  MontaCalendario(UniCalendarioSemanal,
                  UniDateTimeInicial.DateTime);
end;

procedure TControleMain.UniButton7Click(Sender: TObject);
begin
  UniPageCalendario.ActivePageIndex := 2;
  MontaCalendario(UniCalendarioMensal,
                  UniDateTimeInicial.DateTime);
end;

procedure TControleMain.UniCalendarioDiarioDayClick(Sender: TUniCalendarPanel;
  ADate: TDateTime; Allday: Boolean);
begin
{  if ADate < Date() then
  begin

    AlertaMain.warning('Não é permitido agendar para uma data passada!');
                       MontaCalendario(UniCalendarioDiario,
                       UniDateTimeInicial.DateTime);
  end
  else
  begin
    if ClinicaCadastroAgenda.Novo(ClinicaModulePrincipal.CdsAgendamento,
                                  ADate,
                                 ADate) then
    begin
      ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        ClinicaModulePrincipal.SelecionaAgenda;
        MontaCalendario(UniCalendarioDiario,
                        UniDateTimeInicial.DateTime);
      end);
    end;
  end;}
end;

procedure TControleMain.UniCalendarioDiarioEventClick(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent);
begin
  // Abre o formulário de cadastro para visualização e edição
  if ClinicaCadastroAgenda.Abrir(StrToInt(AEvent.Location)) then
  begin
    ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      ClinicaModulePrincipal.SelecionaAgenda();
      MontaCalendario(UniCalendarioDiario,
                      UniDateTimeInicial.DateTime);
    end);
  end;
end;

procedure TControleMain.UniCalendarioDiarioEventMove(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate, AEndDate: TDateTime;
  var Handled: Boolean);
begin
  if AStartDate < now() then
  begin
    AlertaMain.Success('Atenção!','Não é permitido agendar para uma hora menor que a hora atual',
                        procedure(const ButtonClicked: TAButton)
                        begin
                           MontaCalendario(UniCalendarioDiario,
                                           UniDateTimeInicial.DateTime);
                        end);
  end
  else
  begin
    // Abre o formulário de cadastro para visualização e edição
    if ClinicaCadastroAgenda.AbrirEventoAlterado(StrToInt(AEvent.Location),
                                                 AStartDate,
                                                 AEndDate) then
    begin
      ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        ClinicaModulePrincipal.SelecionaAgenda();
        MontaCalendario(UniCalendarioDiario,
                        UniDateTimeInicial.DateTime);
      end);
    end;
  end;
end;

procedure TControleMain.UniCalendarioDiarioEventResize(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate, AEndDate: TDateTime;
  var Handled: Boolean);
begin
  // Abre o formulário de cadastro para visualização e edição
  if ClinicaCadastroAgenda.AbrirEventoAlterado(StrToInt(AEvent.Location),
                                               AStartDate,
                                               AEndDate) then
  begin
    ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      ClinicaModulePrincipal.SelecionaAgenda();
      MontaCalendario(UniCalendarioDiario,
                      UniDateTimeInicial.DateTime);
    end);
  end;
end;

procedure TControleMain.UniCalendarioDiarioRangeSelect(
  Sender: TUniCalendarPanel; AStartDate, AEndDate: TDateTime);
begin
 if AStartDate < Date() then
  begin
    AlertaMain.warning('Não é permitido agendar para uma data passada!');
            MontaCalendario(UniCalendarioDiario,
                        UniDateTimeInicial.DateTime);
  end
  else
  begin
    if ClinicaCadastroAgenda.Novo(ClinicaModulePrincipal.CdsAgendamento,
                                AStartDate,
                                AEndDate) then
    begin
      ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        ClinicaModulePrincipal.SelecionaAgenda;
        MontaCalendario(UniCalendarioDiario,
                        UniDateTimeInicial.DateTime);
      end);
    end;
  end;
end;

procedure TControleMain.UniCalendarioMensalDayClick(Sender: TUniCalendarPanel;
  ADate: TDateTime; Allday: Boolean);
begin
  if ADate < Date() then
  begin
    AlertaMain.Success('Atenção!','Não é permitido agendar para uma data passada',
                        procedure(const ButtonClicked: TAButton)
                        begin
                           MontaCalendario(UniCalendarioMensal,
                                           UniDateTimeInicial.DateTime);
                        end);
  end
  else
  begin
    if ClinicaCadastroAgenda.Novo(ClinicaModulePrincipal.CdsAgendamento,
                                  ADate,
                                  ADate) then
    begin
      ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        ClinicaModulePrincipal.SelecionaAgenda();
        MontaCalendario(UniCalendarioMensal,
                        UniDateTimeInicial.DateTime);
      end);
    end;
  end;
end;

procedure TControleMain.UniCalendarioMensalEventClick(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent);
begin
  // Abre o formulário de cadastro para visualização e edição
  if ClinicaCadastroAgenda.Abrir(StrToInt(AEvent.Location)) then
  begin
    ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      ClinicaModulePrincipal.SelecionaAgenda();
      MontaCalendario(UniCalendarioMensal,
                      UniDateTimeInicial.DateTime);
    end);
  end;
end;

procedure TControleMain.UniCalendarioMensalEventMove(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate, AEndDate: TDateTime;
  var Handled: Boolean);
begin
 if AStartDate < Date() then
 begin
    AlertaMain.Success('Atenção!','Não é permitido agendar para uma data passada',
                        procedure(const ButtonClicked: TAButton)
                        begin
                           MontaCalendario(UniCalendarioMensal,
                                           UniDateTimeInicial.DateTime);
                        end);
 end
 else
 begin
  // Abre o formulário de cadastro para visualização e edição
  if ClinicaCadastroAgenda.AbrirEventoAlterado(StrToInt(AEvent.Location),
                                               AStartDate,
                                               AEndDate) then
  begin
    ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      ClinicaModulePrincipal.SelecionaAgenda();
      MontaCalendario(UniCalendarioMensal,
                      UniDateTimeInicial.DateTime);
    end);
  end;
 end;
end;

procedure TControleMain.UniCalendarioMensalEventResize(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate, AEndDate: TDateTime;
  var Handled: Boolean);
begin
  // Abre o formulário de cadastro para visualização e edição
  if ClinicaCadastroAgenda.AbrirEventoAlterado(StrToInt(AEvent.Location),
                                                AStartDate,
                                                AEndDate) then
  begin
    ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      ClinicaModulePrincipal.SelecionaAgenda();
      MontaCalendario(UniCalendarioMensal,
                      UniDateTimeInicial.DateTime);
    end);
  end;
end;

procedure TControleMain.UniCalendarioSemanalDayClick(Sender: TUniCalendarPanel;
  ADate: TDateTime; Allday: Boolean);
begin
  if ADate < Date() then
  begin
    AlertaMain.Success('Atenção!','Não é permitido agendar para uma data passada',
                        procedure(const ButtonClicked: TAButton)
                        begin
                           MontaCalendario(UniCalendarioSemanal,
                                           UniDateTimeInicial.DateTime);
                        end);
  end
  else
  begin
    if ClinicaCadastroAgenda.Novo(ClinicaModulePrincipal.CdsAgendamento,
                                  ADate,
                                  ADate) then
    begin
      ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        ClinicaModulePrincipal.SelecionaAgenda();
        MontaCalendario(UniCalendarioSemanal,
                        UniDateTimeInicial.DateTime);
      end);
    end;
  end;
end;



procedure TControleMain.UniCalendarioSemanalEventClick(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent);
begin
  // Abre o formulário de cadastro para visualização e edição
  if ClinicaCadastroAgenda.Abrir(StrToInt(AEvent.Location)) then
  begin
    ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      ClinicaModulePrincipal.SelecionaAgenda();
      MontaCalendario(UniCalendarioMensal,
                      UniDateTimeInicial.DateTime);
    end);
  end;
end;

procedure TControleMain.UniCalendarioSemanalEventMove(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate, AEndDate: TDateTime;
  var Handled: Boolean);
begin
 if AStartDate < Date() then
  begin
    AlertaMain.Success('Atenção!','Não é permitido agendar para uma data passada',
                        procedure(const ButtonClicked: TAButton)
                        begin
                           MontaCalendario(UniCalendarioSemanal,
                                           UniDateTimeInicial.DateTime);
                        end);
  end
  else
  begin
  // Abre o formulário de cadastro para visualização e edição
    if ClinicaCadastroAgenda.AbrirEventoAlterado(StrToInt(AEvent.Location),
                                                  AStartDate,
                                                  AEndDate) then
    begin
      ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        ClinicaModulePrincipal.SelecionaAgenda();
        MontaCalendario(UniCalendarioSemanal,
                        UniDateTimeInicial.DateTime);
      end);
    end;
  end;
end;

procedure TControleMain.UniCalendarioSemanalEventResize(Sender: TUniCalendarPanel;
  AEventId: Integer; AEvent: TUniCalendarEvent; AStartDate, AEndDate: TDateTime;
  var Handled: Boolean);
begin
  // Abre o formulário de cadastro para visualização e edição
  if ClinicaCadastroAgenda.AbrirEventoAlterado(StrToInt(AEvent.Location),
                                                AStartDate,
                                                AEndDate) then
  begin
    ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      ClinicaModulePrincipal.SelecionaAgenda();
      MontaCalendario(UniCalendarioSemanal,
                      UniDateTimeInicial.DateTime);
    end);
  end;
end;

procedure TControleMain.UniCalendarioSemanalRangeSelect(
  Sender: TUniCalendarPanel; AStartDate, AEndDate: TDateTime);
begin
  if AStartDate < Date() then
  begin
    AlertaMain.Success('Atenção!','Não é permitido agendar para uma data passada',
                        procedure(const ButtonClicked: TAButton)
                        begin
                           MontaCalendario(UniCalendarioSemanal,
                                           UniDateTimeInicial.DateTime);
                        end);
  end
  else
  begin
    if ClinicaCadastroAgenda.Novo(ClinicaModulePrincipal.CdsAgendamento,
                                  AStartDate,
                                  AEndDate) then
    begin
      ClinicaCadastroAgenda.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        ClinicaModulePrincipal.SelecionaAgenda();
        MontaCalendario(UniCalendarioSemanal,
                        UniDateTimeInicial.DateTime);
      end);
    end;
  end;
end;


procedure TControleMain.UniDateTimeInicialChange(Sender: TObject);
begin
  if UniPageCalendario.ActivePageIndex = 0 then
  begin
    UniCalendarioDiario.StartDate  := UniDateTimeInicial.DateTime;
    CarregaListaDeAtendimentos();
    MontaCalendario(UniCalendarioDiario,
                    UniDateTimeInicial.DateTime);
  end
  else if UniPageCalendario.ActivePageIndex = 1 then
  begin
    UniCalendarioSemanal.StartDate := UniDateTimeInicial.DateTime;
    MontaCalendario(UniCalendarioSemanal,
                    UniDateTimeInicial.DateTime);
  end
  else if UniPageCalendario.ActivePageIndex = 2 then
  begin
    UniCalendarioMensal.StartDate  := UniDateTimeInicial.DateTime;
  end;
end;

procedure TControleMain.UniFormAjaxEvent(Sender: TComponent; EventName: string;
  Params: TUniStrings);
begin
//  if EventName = 'resize' then
    UniSFHold_Aguarde.MaskHide;
end;

procedure TControleMain.UniFormBeforeShow(Sender: TObject);
begin
  UniSFHold_Aguarde.MaskShow('Aguarde...');
end;

procedure TControleMain.UniFormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown  := false;
//  UniPageCalendario.ActivePageIndex := 2;
end;

procedure TControleMain.UniFormShow(Sender: TObject);
begin
  MontaCalendario(UniCalendarioDiario,
                  UniDateTimeInicial.DateTime);
end;

procedure TControleMain.UniHTMLFrame1AjaxEvent(Sender: TComponent;
  EventName: string; Params: TUniStrings);
Var
  mMenuEvento: TStringList;
begin
  mMenuEvento := TStringList.Create;
  mMenuEvento.Delimiter :=':';
  mMenuEvento.DelimitedText := EventName;

  if mMenuEvento[0] = 'editar' then
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'EDITANDO '+mMenuEvento[1])
  else if mMenuEvento[0] = 'procedimento' then
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'PROCEDIMENTO '+mMenuEvento[1])
  else if mMenuEvento[0] = 'recebimento' then
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'RECEBIMENTO '+mMenuEvento[1]);
  mMenuEvento.Free;
end;

function TControleMain.LocalizaPanelMenu(Nome_Interno: String): Boolean;
begin
  if ControleMainModule.cdsMenu_Schema.Locate('menu_descricao', UpperCase(Nome_Interno),[]) then
    Result := True
  else
    Result := False;
end;

procedure TControleMain.MontaCalendario(Calend : TUniCalendarPanel;
                                        DataHora: TDateTime);
var
  B : TUniCalendarEvent;
begin
  with ClinicaModulePrincipal do
  begin
    CdsAgendamento.Refresh;
    CdsAgendamento.First;
    Calend.Events.Clear;
    Calend.StartDate := DataHora;

    while not CdsAgendamento.Eof do
    begin
      B:= Calend.Events.Add;
      if CdsAgendamento.FieldByName('situacao').AsString = 'A' then // Consulta aguardando
        B.CalendarId := 2
      else if CdsAgendamento.FieldByName('situacao').AsString = 'R' then // Consulta Realizada
        B.CalendarId := 3
      else if CdsAgendamento.FieldByName('situacao').AsString = 'C' then // Consulta cancelada
        B.CalendarId := 1
      else if CdsAgendamento.FieldByName('situacao').AsString = 'F' then // Consulta faltou
        B.CalendarId := 4;
      B.Title      := 'Paciente: ' + CdsAgendamento.FieldByName('paciente').AsString + ' || ' +
                      'Profissional ' + CdsAgendamento.FieldByName('profissional').AsString;
      B.StartDate  := CdsAgendamento.FieldByName('datahora_inicio').AsDateTime;
      B.EndDate    := CdsAgendamento.FieldByName('datahora_fim').AsDateTime;
      B.Location   := CdsAgendamento.FieldByName('id').AsString;
      CdsAgendamento.Next;
    end;
  end;
  UniPageControlDiaDet.ActivePageIndex := 0;
end;

procedure TControleMain.UniImage1Click(Sender: TObject);
begin
  MenuPanel_08.TabOrder := 0;
end;

procedure TControleMain.UniImage4Click(Sender: TObject);
begin
  ControleModalAjuda.ShowModal;
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

procedure TControleMain.UniPageControlDiaDetChange(Sender: TObject);
begin
  if UniPageControlDiaDet.ActivePageIndex = 1 then
    CarregaListaDeAtendimentos()
  else if UniPageControlDiaDet.ActivePageIndex = 0 then
    MontaCalendario(UniCalendarioDiario,
                    UniDateTimeInicial.DateTime);

end;

procedure TControleMain.UniURLFrame1FrameLoaded(Sender: TObject);
begin
  pagePrincipal.ActivePageIndex := 0;
end;

procedure TControleMain.Mensageiro(Texto: string;
                               Titulo: String;
                               Tempo: integer = 5000;
                               Cor: TMensageiroCor = Verde;
                               Tamanho: TMensageiroTamanho = Medio;
                               PosicaoX: TMensageiroPosicaoX = Centro;
                               PosicaoY: TMensageiroPosicaoY = Superior);
begin
  // Utiliza o componente TUniSFiGrowl para exibir mensagens na tela,
  // Essa função pode ser usada em qualquer tela
  try
    Mensagens := TUniSFiGrowl.Create(nil);
    With Mensagens do
    begin
      Text          := Texto;
      Title         := Titulo;
      Timer         := Tempo;
      if Cor = Azul then
        iType         := it_info
      else if Cor = Verde then
        iType         := it_Success_sat
      else if Cor = Amarelo then
        iType         := it_Notice_sat
      else if Cor = Branco then
        iType         := it_Simple
      else if Cor = Vermelho then
        iType         := it_Error_sat
      else if Cor = Transparente then
        iType         := it_info_stat;
      if Tamanho = Pequeno then
        AlertSize     := as_small
      else if Tamanho = Medio then
        AlertSize     := as_regular;
      if PosicaoX = Direita then
        PlacementX    := px_right
      else if PosicaoX = Esquerda then
        PlacementX    := px_left
      else if PosicaoX = Centro then
        PlacementX    := px_center;
      if PosicaoY = Superior then
        PlacementY    := py_top
      else if PosicaoY = Inferior then
        PlacementY    := py_bottom;
     // icon.icon     := TFontAwesome(fa_child);
      AnimationShow := TAnimationShow(as_wobble);
      Show;
    end;
  finally
    Mensagens.Free;
  end;
end;

procedure TControleMain.MenuPanel_10MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if BotaoMenuFichaAnalise01_01.Visible = False then
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Para criar sua primeira avaliação clique no botão "Criador de avaliações" no menu Cadastros >> Clínica');
end;

Function TControleMain.SelecionaMontaAvaliacao(SequenciaID: Integer): String;
begin
  Result := '';
  With ControleMainModule do
  begin
    CdsAx1.Close;
    QryAx1.SQL.Clear;
    QryAx1.Parameters.clear;
    QryAx1.SQL.Add('SELECT id, descricao_avaliacao');
    QryAx1.SQL.Add('  FROM monta_avaliacao');
    QryAx1.SQL.Add(' WHERE sequencial = '+ IntTostr(SequenciaID) +'');
    CdsAx1.Open;

    // nao mostrou o botao na consulta
    if CdsAx1.RecordCount > 0 then
      Result := CdsAx1.FieldByName('descricao_avaliacao').AsString;
  end;
end;

procedure TControleMain.Timer1Timer(Sender: TObject);
begin
  With ClinicaModulePrincipal do
  begin
    if CdsListaAgendamento.Active = True then
      CdsListaAgendamento.Refresh;
  end;
end;

procedure TControleMain.CarregandoMenu();
var
  DescricaoAvaliacao: String;
begin
  Try
    With ControleMainModule do
    begin
      CdsUsuarioPermissao.Refresh;
      // habilitando para a visualização os panels de cada menu
      // segundo a tabela menu_schema
      // Abre o registro
      CdsMenu_Schema.Close;
      QryMenu_Schema.Parameters.ParamByName('tschema').Value := FSchema;
      CdsMenu_Schema.Open;

      //--------------------------------INICIO PANEL CLINICA------------------------------------------
      // Menus da Clinica
      MenuPanel_08.Visible := LocalizaPanelMenu(MenuPanel_08.Name);
      MenuPanel_09.Visible := LocalizaPanelMenu(MenuPanel_09.Name);
      MenuPanel_10.Visible := LocalizaPanelMenu(MenuPanel_10.Name);
      MenuPanel_11.Visible := LocalizaPanelMenu(MenuPanel_11.Name);
//      MenuPanel_12.Visible := LocalizaPanelMenu(MenuPanel_12.Name);
      MenuPanel_13.Visible := LocalizaPanelMenu(MenuPanel_13.Name);
      MenuPanel_14.Visible := LocalizaPanelMenu(MenuPanel_14.Name);

      // Botões do MenuPanel_08 ----------------------------------------------------------------------
      if Trim(CdsUsuarioPermissao.FieldByName('MENU_EMPRESA_BOTAO').AsString) = 'P' then
        BotaoMenuEmpresaClinica.Enabled := True
      else
        BotaoMenuEmpresaClinica.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FORNECEDOR_BOTAO').AsString) = 'P' then
        BotaoMenuFornecedorClinica.Enabled := True
      else
        BotaoMenuFornecedorClinica.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_PACIENTE_BOTAO').AsString) = 'P' then
        BotaoMenuPaciente.Enabled := True
      else
        BotaoMenuPaciente.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_PROFISSIONAL_BOTAO').AsString) = 'P' then
        BotaoMenuProfissional.Enabled := True
      else
        BotaoMenuProfissional.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_RESPONSAVEL_BOTAO').AsString) = 'P' then
        BotaoMenuResponsavel.Enabled := True
      else
        BotaoMenuResponsavel.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_TITULOSRECEBER_BOTAO').AsString) = 'P' then
        BotaoMenuTitulosReceberClinica.Enabled := True
      else
        BotaoMenuTitulosReceberClinica.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_TITULOSPAGAR_BOTAO').AsString) = 'P' then
        BotaoMenuTitulosPagarClinica.Enabled := True
      else
        BotaoMenuTitulosPagarClinica.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_CAIXA_BOTAO').AsString) = 'P' then
        BotaoMenuCaixa.Enabled := True
      else
        BotaoMenuCaixa.Enabled := False;

      // Botões do MenuPanel_09 ----------------------------------------------------------------------
      if Trim(CdsUsuarioPermissao.FieldByName('MENU_PROFISSIONAL_TIPO_BOTAO').AsString) = 'P' then
        BotaoMenuProfissionalTipo.Enabled := True
      else
        BotaoMenuProfissionalTipo.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_TIPO_ATENDIMENTO_BOTAO').AsString) = 'P' then
        BotaMenuTipoAtendimento.Enabled := True
      else
        BotaMenuTipoAtendimento.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_CONVENIO_BOTAO').AsString) = 'P' then
        BotaMenuConvenio.Enabled := True
      else
        BotaMenuConvenio.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_ESCOLARIDADE_BOTAO').AsString) = 'P' then
        BotaMenuEscolaridade.Enabled := True
      else
        BotaMenuEscolaridade.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_TIPOATENDIMENTO_BOTAO').AsString) = 'P' then
        BotaMenuEscolaridade.Enabled := True
      else
        BotaMenuEscolaridade.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_BANCO_BOTAO').AsString) = 'P' then
        BotaoMenuBancoClinica.Enabled := True
      else
        BotaoMenuBancoClinica.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_CONTABANCARIA_BOTAO').AsString) = 'P' then
        BotaoMenuContaBancariaClinica.Enabled := True
      else
        BotaoMenuContaBancariaClinica.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_TIPOTITULO_BOTAO').AsString) = 'P' then
        BotaoMenuTipoTituloClinica.Enabled := True
      else
        BotaoMenuTipoTituloClinica.Enabled := False;

      // Botões do MenuPanel_10 ----------------------------------------------------------------------
      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_01').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(1)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_01.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_01.Enabled := True;
          BotaoMenuFichaAnalise01_01.Caption := '01 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_01.Visible := False;
      end
      else
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(1)));
        BotaoMenuFichaAnalise01_01.Visible := False;
        BotaoMenuFichaAnalise01_01.Caption := '01 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_02').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(2)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_02.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_02.Enabled := True;
          BotaoMenuFichaAnalise01_02.Caption := '02 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_02.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(2)));
        BotaoMenuFichaAnalise01_02.Visible := False;
        BotaoMenuFichaAnalise01_02.Caption := '02 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_03').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(3)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_03.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_03.Enabled := True;
          BotaoMenuFichaAnalise01_03.Caption := '03 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_03.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(3)));
        BotaoMenuFichaAnalise01_03.Visible := False;
        BotaoMenuFichaAnalise01_03.Caption := '03 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_04').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(4)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_04.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_04.Enabled := True;
          BotaoMenuFichaAnalise01_04.Caption := '04 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_04.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(4)));
        BotaoMenuFichaAnalise01_04.Visible := False;
        BotaoMenuFichaAnalise01_04.Caption := '04 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_05').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(5)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_05.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_05.Enabled := True;
          BotaoMenuFichaAnalise01_05.Caption := '05 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_05.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(5)));
        BotaoMenuFichaAnalise01_05.Visible := False;
        BotaoMenuFichaAnalise01_05.Caption := '05 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_06').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(6)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_06.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_06.Enabled := True;
          BotaoMenuFichaAnalise01_06.Caption := '06 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_06.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(6)));
        BotaoMenuFichaAnalise01_06.Visible := False;
        BotaoMenuFichaAnalise01_06.Caption := '06 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_07').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(7)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_07.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_07.Enabled := True;
          BotaoMenuFichaAnalise01_07.Caption := '07 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_07.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(7)));
        BotaoMenuFichaAnalise01_07.Visible := False;
        BotaoMenuFichaAnalise01_07.Caption := '07 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_08').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(8)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_08.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_08.Enabled := True;
          BotaoMenuFichaAnalise01_08.Caption := '08 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_08.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(8)));
        BotaoMenuFichaAnalise01_08.Visible := False;
        BotaoMenuFichaAnalise01_08.Caption := '08 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_09').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(9)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_09.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_09.Enabled := True;
          BotaoMenuFichaAnalise01_09.Caption := '09 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_09.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(9)));
        BotaoMenuFichaAnalise01_09.Visible := False;
        BotaoMenuFichaAnalise01_09.Caption := '09 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO01_10').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(10)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise01_10.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise01_10.Enabled := True;
          BotaoMenuFichaAnalise01_10.Caption := '10 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise01_10.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(10)));
        BotaoMenuFichaAnalise01_10.Visible := False;
        BotaoMenuFichaAnalise01_10.Caption := '10 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_01').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(11)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_01.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_01.Enabled := True;
          BotaoMenuFichaAnalise02_01.Caption := '11 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_01.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(11)));
        BotaoMenuFichaAnalise02_01.Visible := False;
        BotaoMenuFichaAnalise02_01.Caption := '11 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_02').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(12)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_02.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_02.Enabled := True;
          BotaoMenuFichaAnalise02_02.Caption := '12 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_02.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(12)));
        BotaoMenuFichaAnalise02_02.Visible := False;
        BotaoMenuFichaAnalise02_02.Caption :=  '12 - ' + DescricaoAvaliacao;;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_03').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(13)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_03.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_03.Enabled := True;
          BotaoMenuFichaAnalise02_03.Caption :=  '13 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_03.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(13)));
        BotaoMenuFichaAnalise02_03.Visible := False;
        BotaoMenuFichaAnalise02_03.Caption :=  '13 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_04').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(14)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_04.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_04.Enabled := True;
          BotaoMenuFichaAnalise02_04.Caption :=  '14 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_04.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(14)));
        BotaoMenuFichaAnalise02_04.Visible := False;
        BotaoMenuFichaAnalise02_04.Caption :=  '14 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_05').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(15)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_05.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_05.Enabled := True;
          BotaoMenuFichaAnalise02_05.Caption :=  '15 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_05.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(15)));
        BotaoMenuFichaAnalise02_05.Visible := False;
        BotaoMenuFichaAnalise02_05.Caption :=  '15 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_06').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(16)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_06.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_06.Enabled := True;
          BotaoMenuFichaAnalise02_06.Caption :=  '16 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_06.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(16)));
        BotaoMenuFichaAnalise02_06.Visible := False;
        BotaoMenuFichaAnalise02_06.Caption :=  '16 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_07').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(17)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_07.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_07.Enabled := True;
          BotaoMenuFichaAnalise02_07.Caption :=  '17 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_07.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(17)));
        BotaoMenuFichaAnalise02_07.Visible := False;
        BotaoMenuFichaAnalise02_07.Caption :=  '17 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_08').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(18)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_08.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_08.Enabled := True;
          BotaoMenuFichaAnalise02_08.Caption :=  '18 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_08.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(18)));
        BotaoMenuFichaAnalise02_08.Visible := False;
        BotaoMenuFichaAnalise02_08.Caption :=  '18 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_09').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(19)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_09.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_09.Enabled := True;
          BotaoMenuFichaAnalise02_09.Caption :=  '19 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_09.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(19)));
        BotaoMenuFichaAnalise02_09.Visible := False;
        BotaoMenuFichaAnalise02_09.Caption :=  '19 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO02_10').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(20)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise02_10.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise02_10.Enabled := True;
          BotaoMenuFichaAnalise02_10.Caption :=  '20 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise02_10.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(20)));
        BotaoMenuFichaAnalise02_10.Visible := False;
        BotaoMenuFichaAnalise02_10.Caption :=  '20 - ' + DescricaoAvaliacao;;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_01').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(21)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_01.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_01.Enabled := True;
          BotaoMenuFichaAnalise03_01.Caption :=  '21 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_01.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(21)));
        BotaoMenuFichaAnalise03_01.Visible := False;
        BotaoMenuFichaAnalise03_01.Caption :=  '21 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_02').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(22)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_02.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_02.Enabled := True;
          BotaoMenuFichaAnalise03_02.Caption := '22 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_02.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(22)));
        BotaoMenuFichaAnalise03_02.Visible := False;
        BotaoMenuFichaAnalise03_02.Caption :=  '22 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_03').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(23)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_03.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_03.Enabled := True;
          BotaoMenuFichaAnalise03_03.Caption :=  '23 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_03.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(23)));
        BotaoMenuFichaAnalise03_03.Visible := False;
        BotaoMenuFichaAnalise03_03.Caption :=  '23 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_04').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(24)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_04.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_04.Enabled := True;
          BotaoMenuFichaAnalise03_04.Caption :=  '24 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_04.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(24)));
        BotaoMenuFichaAnalise03_04.Enabled := False;
        BotaoMenuFichaAnalise03_04.Caption :=  '24 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_05').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(25)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_05.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_05.Enabled := True;
          BotaoMenuFichaAnalise03_05.Caption := '25 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_05.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(25)));
        BotaoMenuFichaAnalise03_05.Visible := False;
        BotaoMenuFichaAnalise03_05.Caption :=  '25 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_06').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(26)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_06.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_06.Enabled := True;
          BotaoMenuFichaAnalise03_06.Caption :=  '26 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_06.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(26)));
        BotaoMenuFichaAnalise03_06.Visible := False;
        BotaoMenuFichaAnalise03_06.Caption :=  '26 - ' + DescricaoAvaliacao;
      end;


      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_07').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(27)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_07.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_07.Enabled := True;
          BotaoMenuFichaAnalise03_07.Caption :=  '27 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_07.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(27)));
        BotaoMenuFichaAnalise03_07.Visible := False;
        BotaoMenuFichaAnalise03_07.Caption :=  '27 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_08').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(28)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_08.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_08.Enabled := True;
          BotaoMenuFichaAnalise03_08.Caption :=  '28 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_08.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(28)));
        BotaoMenuFichaAnalise03_08.Visible := False;
        BotaoMenuFichaAnalise03_08.Caption := DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_09').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(29)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_09.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_09.Enabled := True;
          BotaoMenuFichaAnalise03_09.Caption :=  '29 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_09.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(29)));
        BotaoMenuFichaAnalise03_09.Visible := False;
        BotaoMenuFichaAnalise03_09.Caption :=  '29 - ' + DescricaoAvaliacao;
      end;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_FICHA_ANALISE_BOTAO03_10').AsString) = 'P' then
      begin
        // Só deixa o botão visivel se existir modelo de avaliação para o mesmo
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(30)));
        if DescricaoAvaliacao <> '' then
        begin
          BotaoMenuFichaAnalise03_10.Visible := True;
          // Alterando o caption do botão
          BotaoMenuFichaAnalise03_10.Enabled := True;
          BotaoMenuFichaAnalise03_10.Caption :=  '30 - ' + DescricaoAvaliacao;
        end
        else
          BotaoMenuFichaAnalise03_10.Visible := False;
      end
      else
      begin
        DescricaoAvaliacao := ControleFuncoes.PrimeiraLetraMaiscula(AnsiLowerCase(SelecionaMontaAvaliacao(30)));
        BotaoMenuFichaAnalise03_10.Visible := False;
        BotaoMenuFichaAnalise03_10.Caption :=  '30 - ' + DescricaoAvaliacao;
      end;

      // Botões do MenuPanel_11 ----------------------------------------------------------------------
      if Trim(CdsUsuarioPermissao.FieldByName('MENU_USUARIOS_BOTAO').AsString) = 'P' then
        BotaoMenuUsuariosClinica.Enabled := True
      else
        BotaoMenuUsuariosClinica.Enabled := False;

     { if Trim(CdsUsuarioPermissao.FieldByName('MENU_AUDITORIA_BOTAO').AsString) = 'P' then
        BotaoMenuAuditoriaClinica.Enabled := True
      else
        BotaoMenuAuditoriaClinica.Enabled := False;}

      // Botões do MenuPanel_12 ----------------------------------------------------------------------
      if Trim(CdsUsuarioPermissao.FieldByName('MENU_MONTA_AVALIACAO_BOTAO').AsString) = 'P' then
        BotaoMenuMontaAvaliacaoClinica.Enabled := True
      else
        BotaoMenuMontaAvaliacaoClinica.Enabled := False;

      // Botões do MenuPanel_13 ----------------------------------------------------------------------
      if Trim(CdsUsuarioPermissao.FieldByName('MENU_DOCUMENTOS_BOTAO').AsString) = 'P' then
        BotaoMenuDocumentosClinica.Enabled := True
      else
        BotaoMenuDocumentosClinica.Enabled := False;

      if Trim(CdsUsuarioPermissao.FieldByName('MENU_VIDEOIMAGEM_BOTAO').AsString) = 'P' then
        BotaoMenuVideosImagensClinica.Enabled := True
      else
        BotaoMenuVideosImagensClinica.Enabled := False;

      // Botões do MenuPanel_14 ----------------------------------------------------------------------
      if Trim(CdsUsuarioPermissao.FieldByName('MENU_EVOLUCAOPACIENTE_BOTAO').AsString) = 'P' then
        BotaoMenuEvolucaoPaciente.Enabled := True
      else
        BotaoMenuEvolucaoPaciente.Enabled := False;

      if ControleMainModule.CdsFilial.FieldByName('LOGOMARCA_CAMINHO').AsString <> '' then
      begin
        Try
          if FileExists(ControleMainModule.CdsFilial.FieldByName('LOGOMARCA_CAMINHO').AsString) then
            ImageLoginInicial.Picture.LoadFromFile(ControleMainModule.CdsFilial.FieldByName('LOGOMARCA_CAMINHO').AsString);
        except
          on E: Exception do
          begin
            ControleMainModule.MensageiroSweetAlerta('Atenção!', ControleFuncoes.RetiraAspaSimples(E.Message));
          end;
        End;
      end;
    end;

    // Alterando a cor dos panels do menu
    UniPanelGeral.Color   := $00F5F5F5;
    UniPanelGeral.Width   := 202;
    MenuPanel_08.color := $00F5F5F5;
    MenuPanel_09.color := $00F5F5F5;
    MenuPanel_10.color := $00F5F5F5;
    MenuPanel_11.color := $00F5F5F5;
    //MenuPanel_12.color := $00F5F5F5;
    MenuPanel_13.color := $00F5F5F5;
    MenuPanel_14.color := $00F5F5F5;

  { BotaoMenuFichaAnalise01_06.Visible := False;
    BotaoMenuFichaAnalise01_07.Visible := False;
    BotaoMenuFichaAnalise01_08.Visible := False;
    BotaoMenuFichaAnalise01_09.Visible := False;
    BotaoMenuFichaAnalise01_10.Visible := False;}
  Except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção!', 'Mensagem');
      abort;
    end;
  End;
end;

Procedure TControleMain.CarregaListaDeAtendimentos();
var
  html:String;
  TamanhoWithDivPrincipal: Integer;
  i: Integer;
const
  CoresDiv : array[1..30] of string =  ('#87CEFA',
                                        '#9fe0ca',
                                        '#ADFF2F',
                                        '#FFDEAD',
                                        '#EE82EE',
                                        '#FFB6C1',
                                        '#FFA07A',
                                        '#F0E68C',
                                        '#D8BFD8',
                                        '#B0E0E6',
                                        '#EEE8AA',
                                        '#FFE4B5',
                                        '#FFEBCD',
                                        '#DDA0DD',
                                        '#7FFFD4',
                                        '#D2B48C',
                                        '#7CFC00',
                                        '#B0C4DE',
                                        '#FFA07A',
                                        '#F0E68C',
                                        '#D8BFD8',
                                        '#B0E0E6',
                                        '#EEE8AA',
                                        '#FFE4B5',
                                        '#FFEBCD',
                                        '#DDA0DD',
                                        '#D2B48C',
                                        '#7CFC00',
                                        '#66CDAA',
                                        '#B0C4DE');
begin
  Try
    UniHTMLFrame1.HTML.Clear;

    With ClinicaModulePrincipal do
    begin
      // Abrindo o dataset que contem todos os profissionais ativos
      If CdsProfissional.Active = False then
        CdsProfissional.Active := True
      else
        CdsProfissional.Refresh;

      // Declaração de arquivos externos
      html := '<!DOCTYPE html> '
            +' <html> '
            +'     <head> '
            +'        <script src="/files/bootstrap/js/bootstrap.min.js" type="text/javascript"></script> '
            +'        <link rel="stylesheet" href="/files/bootstrap/css/bootstrap.min.css"> '
            +'       </head> '
            +'       <body> ';
      html := html +
             '<div id="Layer1" style="position:absolute; left:0px; top:0px; width:100%; height:100%; z-index:1; overflow: auto"> ';

      TamanhoWithDivPrincipal := 0;
      i:= 1;

      CdsProfissional.First;
      while not CdsProfissional.eof do
      begin
        CdsListaAgendamento.Close;
        QryListaAgendamento.Parameters.Clear;
        QryListaAgendamento.SQL.Clear;
        QryListaAgendamento.SQL.Add(' SELECT age.id,' +
                                    '        age.datahora_inicio,' +
                                    '        age.datahora_fim,' +
                                    '        age.paciente_id,' +
                                    '        age.profissional_id,' +
                                    '        age.tipoatendimento_id,' +
                                    '        age.convenio_id,' +
                                    '        age.observacao,' +
                                    '        age.situacao,' +
                                    '        pess_pac.razao_social paciente,' +
                                    '        pess_pro.razao_social profissional,' +
                                    '        pro_tip.descricao,'+
                                    '        tpa.descricao tipoatendimento,'+
                                    '        con.descricao convenio'+
                                    '   FROM agendamento age' +
                                    '   LEFT JOIN pessoa pess_pac' +
                                    '     ON pess_pac.id = age.paciente_id' +
                                    '   LEFT JOIN pessoa pess_pro' +
                                    '     ON pess_pro.id = age.profissional_id' +
                                    '   LEFT JOIN profissional pro' +
                                    '     ON pro.id = age.profissional_id' +
                                    '   LEFT JOIN profissional_tipo pro_tip' +
                                    '     ON pro_tip.id = pro.profissional_tipo_id' +
                                    '   LEFT JOIN tipo_atendimento tpa' +
                                    '     ON tpa.id = age.tipoatendimento_id' +
                                    '   LEFT JOIN convenio con' +
                                    '     ON con.id = age.convenio_id' +
                                    '  WHERE TRUNC(age.datahora_inicio)' +
                                    'BETWEEN TO_DATE('''+ Trim(UniDateTimeInicial.Text) +''', ''dd/mm/yyyy'')' +
                                    '    AND TO_DATE('''+ Trim(UniDateTimeInicial.Text) +''', ''dd/mm/yyyy'')' +
                                    '    AND age.profissional_id = '+ CdsProfissionalID.AsString +'');
        CdsListaAgendamento.Open;

        if CdsListaAgendamento.RecordCount > 0 then
        begin
          // Cabeçalho HTML
          html := html
          +'<font color="#414141">'
          +'<div id="Layer1" style="position:absolute; left:'+ IntToStr(TamanhoWithDivPrincipal) +'px; top:0px; width:450; height:100%; z-index:1; overflow: auto"> '
          +'<br><div class="container"> '
          //aqui eu passo o tipo de cor de acordo com a situação do tratamento
          // +'    <div class="notice  notice-'+corSituacao+' "> '
          +'    <div style="background-color: '+ CoresDiv[i] +'" class="notice  notice-sucess"> '
          +'     <div class="container"> '
          +'        <div class="row" > '
          +'             &nbsp;&nbsp;&nbsp;&nbsp;Profissional:&nbsp;<strong>'+ CdsListaAgendamento.FieldByName('profissional').AsString +'</strong> &nbsp;&nbsp;'
          +'        </div> '
          +'        <div class="row"> '
          +'             &nbsp;&nbsp;&nbsp;&nbsp;Tipo:&nbsp;<strong>'+ CdsListaAgendamento.FieldByName('descricao').AsString +'</strong> '
          +'        </div> '
          +'     </div>  '
          +'    </div>  '
          +'    </div>  ';

          TamanhoWithDivPrincipal :=  TamanhoWithDivPrincipal + 451;

          while not CdsListaAgendamento.eof do
          begin
            html := html +
            '<div class="container-fluid"> '
             +'    <div class="notice notice-success "> '
             +'     <div class="container"> '
             +'        <div class="row"> '
             +'          <div class="col-sm-12"> <small>Paciente&nbsp : <strong> &nbsp;'+ CdsListaAgendamento.FieldByName('paciente').AsString +'</strong></small> </div> '
             +'        </div> '
             +'        <div class="row"> '
             +'          <div class="col-sm-6"> <small>Hora início : <strong> &nbsp;'+ CdsListaAgendamento.FieldByName('datahora_inicio').AsString +'</strong></small> </div> '
             +'          <div class="col-sm-6"> <small>Hora. Fim : <strong> &nbsp;'+ CdsListaAgendamento.FieldByName('datahora_fim').AsString +'</strong></small> </div> '
             +'        </div> '
             +'        <div class="row"> '
             +'          <div class="col-sm-6"> <small>Tp. atendimento : <strong> &nbsp;'+ CdsListaAgendamento.FieldByName('tipoatendimento').AsString +'</strong> </small> </div> '
             +'          <div class="col-sm-6"> <small>Convênio :  <strong> &nbsp;'+ CdsListaAgendamento.FieldByName('convenio').AsString +'</strong> </small> </div> '
             +'        </div> '
             +'        <div class="row"> ';
             if CdsListaAgendamento.FieldByName('situacao').AsString = 'A' then
               html := html + '<div class="col-sm-12"> <small>Situação : </small>  <strong> &nbsp; <span class="badge badge-primary">Aguardando</span></strong> </div> '
             else if CdsListaAgendamento.FieldByName('situacao').AsString = 'R' then
               html := html + '<div class="col-sm-12"> <small>Situação : </small>  <strong> &nbsp; <span class="badge badge-success">Realizada</span></strong> </div> '
             else if CdsListaAgendamento.FieldByName('situacao').AsString = 'C' then
               html := html + '<div class="col-sm-12"> <small>Situação : </small>  <strong> &nbsp; <span class="badge badge-warning">Cancelada</span></strong> </div> '
             else if CdsListaAgendamento.FieldByName('situacao').AsString = 'F' then
               html := html + '<div class="col-sm-12"> <small>Situação : </small>  <strong> &nbsp; <span class="badge badge-danger">Faltou</span></strong>  </div> ';
             html := html +
                 '        </div> '
                 +'     </div>  '
                 +'    </div>  '
                 +'    </div>  ';

             CdsListaAgendamento.Next;
          end;
          html := html +
          '        </div> '
         +'       </font>';
        end;
        CdsProfissional.Next;
        i := i + 1;
      end;
    end;

    html := html + '</div> </body> </html> ';
    UniHTMLFrame1.HTML.Text := html;
    UniHTMLFrame1.Refresh;
  except on E : Exception do
    ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
  end;
end;

procedure TControleMain.CarregandoOpcoesInicio;
begin
  ClinicaModulePrincipal.SelecionaAgenda();
  UniCalendarioDiario.Events.Clear;
  UniCalendarioSemanal.Events.Clear;
  UniCalendarioMensal.Events.Clear;
  UniDateTimeInicial.DateTime := Now;
  MontaCalendario(UniCalendarioMensal,
                  UniDateTimeInicial.DateTime);
  //UniPageControl1.ActivePageIndex := 0;
end;

initialization
  RegisterAppFormClass(TControleMain);

end.
