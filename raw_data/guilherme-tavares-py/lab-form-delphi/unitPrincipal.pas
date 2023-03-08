unit unitPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.Imaging.jpeg, PReport, PdfDoc;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label7: TLabel;
    DataDeEnvio: TDateTimePicker;
    Panel5: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Ordem: TEdit;
    Entrada: TDateTimePicker;
    Label10: TLabel;
    Label11: TLabel;
    Saida: TDateTimePicker;
    Label12: TLabel;
    Hora: TEdit;
    Panel4: TPanel;
    Label13: TLabel;
    NomeDoutor: TEdit;
    Label14: TLabel;
    Fone: TEdit;
    Label15: TLabel;
    NomePaciente: TEdit;
    Label16: TLabel;
    Pele: TEdit;
    Feminino: TRadioButton;
    Masculino: TRadioButton;
    ScrollBox1: TScrollBox;
    Panel6: TPanel;
    Label17: TLabel;
    Panel7: TPanel;
    Panel8: TPanel;
    Prova: TRadioButton;
    Pronto: TRadioButton;
    Panel9: TPanel;
    Label18: TLabel;
    Label19: TLabel;
    CorEscala: TEdit;
    Label20: TLabel;
    MarcaDoDente: TEdit;
    Label21: TLabel;
    CorSTG: TEdit;
    Label22: TLabel;
    Check11: TCheckBox;
    Check12: TCheckBox;
    Check13: TCheckBox;
    Check14: TCheckBox;
    Check15: TCheckBox;
    Check16: TCheckBox;
    Check17: TCheckBox;
    Check18: TCheckBox;
    Check21: TCheckBox;
    Check22: TCheckBox;
    Check23: TCheckBox;
    Check24: TCheckBox;
    Check26: TCheckBox;
    Check27: TCheckBox;
    Check28: TCheckBox;
    Check41: TCheckBox;
    Check42: TCheckBox;
    Check43: TCheckBox;
    Check44: TCheckBox;
    Check45: TCheckBox;
    Check46: TCheckBox;
    Check47: TCheckBox;
    Check48: TCheckBox;
    Check25: TCheckBox;
    Check31: TCheckBox;
    Check32: TCheckBox;
    Check33: TCheckBox;
    Check34: TCheckBox;
    Check35: TCheckBox;
    Check36: TCheckBox;
    Check37: TCheckBox;
    Check38: TCheckBox;
    Splitter1: TSplitter;
    Panel10: TPanel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    QtdeAntagonista: TEdit;
    QtdeBolacha: TEdit;
    QtdeEscala: TEdit;
    QtdeModeloEstudo: TEdit;
    QtdeOutros: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    DescOutros: TEdit;
    Label31: TLabel;
    QtdeModeloTrabalho: TEdit;
    QtdeMoldagem: TEdit;
    QtdeMoldeira: TEdit;
    QtdeMordida: TEdit;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    QtdeParafuso: TEdit;
    QtdeAnalogo: TEdit;
    QtdeTransfer: TEdit;
    QtdeUcla: TEdit;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    QtdeMuralha: TEdit;
    QtdeBarra: TEdit;
    QtdeProtocolo: TEdit;
    QtdeBase: TEdit;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Panel11: TPanel;
    Submit: TButton;
    PReport1: TPReport;
    SolicitacaoServico: TMemo;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    procedure SubmitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure FillFormatSettings(var FSettings: TFormatSettings);
begin
  FSettings := TFormatSettings.Create('pt-BR');
  FSettings.DateSeparator := #47;
  FSettings.ShortDateFormat := 'dd/mm/yyy';
  Fsettings.TimeSeparator := #58;
  FSettings.LongTimeFormat := '';
  FSettings.ShortTimeFormat := 'hh:nn';
end;

function DateTimeToStrBrazilian(DateTime: TDateTime): String;
var
  FmtSettings: TFormatSettings;
begin
  FillFormatSettings(FmtSettings);
  Result := DateToStr(DateTime, FmtSettings)
end;

procedure TForm1.SubmitClick(Sender: TObject);
var
  Pagina1: TPRPage;
  Layout: TPRLayoutPanel;
  Image: TPRImage;
  Titulo: TPRLabel;
  Subtitulo: TPRLabel;

  ContatoFone: TPRLabel;
  ContatoCadastro: TPRLabel;
  ContatoGutoFinanceiro: TPRLabel;
  ContatoEndereco: TPRLabel;

  DataDeEnvioLabel: TPRLabel;
  DataDeEnvioResult: TPRLabel;

  UsoLab: TPRLabel;
  UsoLabOrdem: TPRLabel;
  UsoLabEntrada: TPRLabel;
  UsoLabEntrega: TPRLabel;
  UsoLabHora: TPRLabel;
  UsoLabOrdemResult: TPRLabel;
  UsoLabEntradaResult: TPRLabel;
  UsoLabEntregaResult: TPRLabel;
  UsoLabHoraResult: TPRLabel;

  InfoPrincipalDrNome: TPRLabel;
  InfoPrincipalDrFone: TPRLabel;
  InfoPrincipalPacienteNome: TPRLabel;
  InfoPrincipalPacienteIdade: TPRLabel;
  InfoPrincipalPacientePele: TPRLabel;
  InfoPrincipalPacienteSexo: TPRLabel;
  InfoPrincipalDrNomeResult: TPRLabel;
  InfoPrincipalDrFoneResult: TPRLabel;
  InfoPrincipalPacienteNomeResult: TPRLabel;
  InfoPrincipalPacienteIdadeResult: TPRLabel;
  InfoPrincipalPacientePeleResult: TPRLabel;
  InfoPrincipalPacienteSexoResult: TPRLabel;

  SolicitacaoServicoLabel: TPRLabel;
  SolicitacaoServicoResult: TPRText;

  ProvaouProntoLabel: TPRLabel;

  InfoDente: TPRLabel;
  InfoDenteCorEscala: TPRLabel;
  InfoDenteMarcaDente: TPRLabel;
  InfoCorGengivaSTG: TPRLabel;
  InfoDenteCorEscalaResult: TPRLabel;
  InfoDenteMarcaDenteResult: TPRLabel;
  InfoCorGengivaSTGResult: TPRLabel;

  InfoGuiaCaracterizacao: TPRLabel;

  InfoGuiaCheck11: TPRLabel;
  InfoGuiaCheck12: TPRLabel;
  InfoGuiaCheck13: TPRLabel;
  InfoGuiaCheck14: TPRLabel;
  InfoGuiaCheck15: TPRLabel;
  InfoGuiaCheck16: TPRLabel;
  InfoGuiaCheck17: TPRLabel;
  InfoGuiaCheck18: TPRLabel;

  InfoGuiaCheck21: TPRLabel;
  InfoGuiaCheck22: TPRLabel;
  InfoGuiaCheck23: TPRLabel;
  InfoGuiaCheck24: TPRLabel;
  InfoGuiaCheck25: TPRLabel;
  InfoGuiaCheck26: TPRLabel;
  InfoGuiaCheck27: TPRLabel;
  InfoGuiaCheck28: TPRLabel;

  InfoGuiaCheck31: TPRLabel;
  InfoGuiaCheck32: TPRLabel;
  InfoGuiaCheck33: TPRLabel;
  InfoGuiaCheck34: TPRLabel;
  InfoGuiaCheck35: TPRLabel;
  InfoGuiaCheck36: TPRLabel;
  InfoGuiaCheck37: TPRLabel;
  InfoGuiaCheck38: TPRLabel;


  InfoGuiaCheck41: TPRLabel;
  InfoGuiaCheck42: TPRLabel;
  InfoGuiaCheck43: TPRLabel;
  InfoGuiaCheck44: TPRLabel;
  InfoGuiaCheck45: TPRLabel;
  InfoGuiaCheck46: TPRLabel;
  InfoGuiaCheck47: TPRLabel;
  InfoGuiaCheck48: TPRLabel;

  MateriasEnviados: TPRLabel;
  QtdeLabel1: TPRLabel;
  QtdeLabel2: TPRLabel;
  QtdeLabel3: TPRLabel;
  QtdeLabel4: TPRLabel;
  DescLabel1: TPRLabel;
  DescLabel2: TPRLabel;
  DescLabel3: TPRLabel;
  DescLabel4: TPRLabel;

  QtdeAntagonistaLabel: TPRLabel;
  QtdeBolachaLabel: TPRLabel;
  QtdeEscalaCoresLabel: TPRLabel;
  QtdeModeloEstudoLabel: TPRLabel;
  QtdeAntagonistaResult: TPRLabel;
  QtdeBolachaResult: TPRLabel;
  QtdeEscalaCoresResult: TPRLabel;
  QtdeModeloEstudoResult: TPRLabel;

  QtdeModeloTrabalhoLabel: TPRLabel;
  QtdeMoldagemLabel: TPRLabel;
  QtdeMoldeiraLabel: TPRLabel;
  QtdeMordidaLabel: TPRLabel;
  QtdeModeloTrabalhoResult: TPRLabel;
  QtdeMoldagemResult: TPRLabel;
  QtdeMoldeiraResult: TPRLabel;
  QtdeMordidaResult: TPRLabel;

  QtdeParafusoLabel: TPRLabel;
  QtdeAnalogoLabel: TPRLabel;
  QtdeTransferLabel: TPRLabel;
  QtdeUclaLabel: TPRLabel;
  QtdeParafusoResult: TPRLabel;
  QtdeAnalogoResult: TPRLabel;
  QtdeTransferResult: TPRLabel;
  QtdeUclaResult: TPRLabel;

  QtdeMuralhaLabel: TPRLabel;
  QtdeBarraLabel: TPRLabel;
  QtdeProtocoloLabel: TPRLabel;
  QtdeBaseProvaLabel: TPRLabel;
  QtdeMuralhaResult: TPRLabel;
  QtdeBarraResult: TPRLabel;
  QtdeProtocoloResult: TPRLabel;
  QtdeBaseProvaResult: TPRLabel;

  QtdeOutrosLabel: TPRLabel;
  QtdeOutrosDesc: TPRLabel;
  QtdeOutrosResult: TPRLabel;

  dateFormat: TFormatSettings;


begin

  // pdf dimensions: width x height = 595 x 842 pt


  Pagina1 := TPRPage.Create(nil);
  Layout := TPRLayoutPanel.Create(nil);
  Image := TPRImage.Create(nil);
  Titulo := TPRLabel.Create(nil);
  Subtitulo := TPRLabel.Create(nil);

  ContatoFone := TPRLabel.Create(nil);
  ContatoCadastro := TPRLabel.Create(nil);
  ContatoGutoFinanceiro := TPRLabel.Create(nil);
  ContatoEndereco := TPRLabel.Create(nil);

  DataDeEnvioLabel := TPRLabel.Create(nil);
  DataDeEnvioResult := TPRLabel.Create(nil);

  UsoLab := TPRLabel.Create(nil);
  UsoLabOrdem := TPRLabel.Create(nil);
  UsoLabEntrada := TPRLabel.Create(nil);
  UsoLabEntrega := TPRLabel.Create(nil);
  UsoLabHora := TPRLabel.Create(nil);
  UsoLabOrdemResult := TPRLabel.Create(nil);
  UsoLabEntradaResult := TPRLabel.Create(nil);
  UsoLabEntregaResult := TPRLabel.Create(nil);
  UsoLabHoraResult := TPRLabel.Create(nil);

  InfoPrincipalDrNome := TPRLabel.Create(nil);
  InfoPrincipalDrFone := TPRLabel.Create(nil);
  InfoPrincipalPacienteNome := TPRLabel.Create(nil);
  InfoPrincipalPacienteIdade := TPRLabel.Create(nil);
  InfoPrincipalPacientePele := TPRLabel.Create(nil);
  InfoPrincipalPacienteSexo := TPRLabel.Create(nil);

  InfoPrincipalDrNomeResult := TPRLabel.Create(nil);
  InfoPrincipalDrFoneResult := TPRLabel.Create(nil);
  InfoPrincipalPacienteNomeResult := TPRLabel.Create(nil);
  InfoPrincipalPacienteIdadeResult := TPRLabel.Create(nil);
  InfoPrincipalPacientePeleResult := TPRLabel.Create(nil);
  InfoPrincipalPacienteSexoResult := TPRLabel.Create(nil);

  SolicitacaoServicoLabel := TPRLabel.Create(nil);
  SolicitacaoServicoResult := TPRText.Create(nil);

  ProvaOuProntoLabel := TPRLabel.Create(nil);

  InfoDente := TPRLabel.Create(nil);
  InfoDenteCorEscala := TPRLabel.Create(nil);
  InfoDenteMarcaDente := TPRLabel.Create(nil);
  InfoCorGengivaSTG := TPRLabel.Create(nil);
  InfoDenteCorEscalaResult := TPRLabel.Create(nil);
  InfoDenteMarcaDenteResult := TPRLabel.Create(nil);
  InfoCorGengivaSTGResult := TPRLabel.Create(nil);

  InfoGuiaCaracterizacao := TPRLabel.Create(nil);

  InfoGuiaCheck11 := TPRLabel.Create(nil);
  InfoGuiaCheck12 := TPRLabel.Create(nil);
  InfoGuiaCheck13 := TPRLabel.Create(nil);
  InfoGuiaCheck14 := TPRLabel.Create(nil);
  InfoGuiaCheck15 := TPRLabel.Create(nil);
  InfoGuiaCheck16 := TPRLabel.Create(nil);
  InfoGuiaCheck17 := TPRLabel.Create(nil);
  InfoGuiaCheck18 := TPRLabel.Create(nil);

  InfoGuiaCheck21 := TPRLabel.Create(nil);
  InfoGuiaCheck22 := TPRLabel.Create(nil);
  InfoGuiaCheck23 := TPRLabel.Create(nil);
  InfoGuiaCheck24 := TPRLabel.Create(nil);
  InfoGuiaCheck25 := TPRLabel.Create(nil);
  InfoGuiaCheck26 := TPRLabel.Create(nil);
  InfoGuiaCheck27 := TPRLabel.Create(nil);
  InfoGuiaCheck28 := TPRLabel.Create(nil);

  InfoGuiaCheck31 := TPRLabel.Create(nil);
  InfoGuiaCheck32 := TPRLabel.Create(nil);
  InfoGuiaCheck33 := TPRLabel.Create(nil);
  InfoGuiaCheck34 := TPRLabel.Create(nil);
  InfoGuiaCheck35 := TPRLabel.Create(nil);
  InfoGuiaCheck36 := TPRLabel.Create(nil);
  InfoGuiaCheck37 := TPRLabel.Create(nil);
  InfoGuiaCheck38 := TPRLabel.Create(nil);

  InfoGuiaCheck41 := TPRLabel.Create(nil);
  InfoGuiaCheck42 := TPRLabel.Create(nil);
  InfoGuiaCheck43 := TPRLabel.Create(nil);
  InfoGuiaCheck44 := TPRLabel.Create(nil);
  InfoGuiaCheck45 := TPRLabel.Create(nil);
  InfoGuiaCheck46 := TPRLabel.Create(nil);
  InfoGuiaCheck47 := TPRLabel.Create(nil);
  InfoGuiaCheck48 := TPRLabel.Create(nil);

  MateriasEnviados := TPRLabel.Create(nil);
  QtdeLabel1 := TPRLabel.Create(nil);
  QtdeLabel2 := TPRLabel.Create(nil);
  QtdeLabel3 := TPRLabel.Create(nil);
  QtdeLabel4 := TPRLabel.Create(nil);
  DescLabel1 := TPRLabel.Create(nil);
  DescLabel2 := TPRLabel.Create(nil);
  DescLabel3 := TPRLabel.Create(nil);
  DescLabel4 := TPRLabel.Create(nil);


  QtdeAntagonistaLabel := TPRLabel.Create(nil);
  QtdeBolachaLabel := TPRLabel.Create(nil);
  QtdeEscalaCoresLabel := TPRLabel.Create(nil);
  QtdeModeloEstudoLabel := TPRLabel.Create(nil);
  QtdeAntagonistaResult := TPRLabel.Create(nil);
  QtdeBolachaResult := TPRLabel.Create(nil);
  QtdeEscalaCoresResult := TPRLabel.Create(nil);
  QtdeModeloEstudoResult := TPRLabel.Create(nil);

  QtdeModeloTrabalhoLabel := TPRLabel.Create(nil);
  QtdeMoldagemLabel := TPRLabel.Create(nil);
  QtdeMoldeiraLabel := TPRLabel.Create(nil);
  QtdeMordidaLabel := TPRLabel.Create(nil);
  QtdeModeloTrabalhoResult := TPRLabel.Create(nil);
  QtdeMoldagemResult := TPRLabel.Create(nil);
  QtdeMoldeiraResult := TPRLabel.Create(nil);
  QtdeMordidaResult := TPRLabel.Create(nil);

  QtdeParafusoLabel := TPRLabel.Create(nil);
  QtdeAnalogoLabel := TPRLabel.Create(nil);
  QtdeTransferLabel := TPRLabel.Create(nil);
  QtdeUclaLabel := TPRLabel.Create(nil);
  QtdeParafusoResult := TPRLabel.Create(nil);
  QtdeAnalogoResult := TPRLabel.Create(nil);
  QtdeTransferResult := TPRLabel.Create(nil);
  QtdeUclaResult := TPRLabel.Create(nil);

  QtdeMuralhaLabel := TPRLabel.Create(nil);
  QtdeBarraLabel := TPRLabel.Create(nil);
  QtdeProtocoloLabel := TPRLabel.Create(nil);
  QtdeBaseProvaLabel := TPRLabel.Create(nil);
  QtdeMuralhaResult := TPRLabel.Create(nil);
  QtdeBarraResult := TPRLabel.Create(nil);
  QtdeProtocoloResult := TPRLabel.Create(nil);
  QtdeBaseProvaResult := TPRLabel.Create(nil);

  QtdeOutrosLabel := TPRLabel.Create(nil);
  QtdeOutrosDesc := TPRLabel.Create(nil);
  QtdeOutrosResult := TPRLabel.Create(nil);

  Layout.Parent := Pagina1;



  // *** Cabeçalho ***

  // Image
  Image.Parent := Layout;
  Image.Picture := Image1.Picture;
  Image.Width := 185;
  Image.Height := 185;
  Image.Top := 1;
  Image.Left := 0;

  // Titulo
  Titulo.Parent := Layout;
  Titulo.Left := 0;
  Titulo.Top := 71;
  Titulo.Width :=  590;
  Titulo.Height := 40;
  Titulo.Margins.Top := 70;
  Titulo.Margins.Bottom := 10;
  Titulo.Align := alTop;
  Titulo.Alignment := taCenter;
  Titulo.Caption := 'José Augusto Ribeiro';
  Titulo.FontSize := 24;
  Titulo.FontName := TPRFontName.fnTimesRoman;

  // subtitulo
  Subtitulo.Parent := Layout;
  Subtitulo.Left := 0;
  Subtitulo.Top := 124;
  Subtitulo.Width := 590;
  Subtitulo.Height := 15;
  Subtitulo.Margins.Bottom := 0;
  Subtitulo.Align := alTop;
  Subtitulo.Alignment := taCenter;
  Subtitulo.Caption := 'CRO/ TPD 11210 – CRO/LB 1115';
  Subtitulo.FontBold := true;
  Subtitulo.FontSize := 10;
  Subtitulo.FontName := TPRFontName.fnTimesRoman;

  // Contatos
  ContatoFone.Parent := Layout;
  ContatoFone.Left := 0;
  ContatoFone.Top := 139;
  ContatoFone.Width := 590;
  ContatoFone.Height := 15;
  ContatoFone.Margins.Top := 0;
  ContatoFone.Margins.Right := 15;
  ContatoFone.Align := alTop;
  ContatoFone.Alignment := taRightJustify;
  ContatoFone.Caption := 'Fone (18) 3529-1005';
  ContatoFone.FontName := TPRFontName.fnTimesRoman;

  ContatoCadastro.Parent := Layout;
  ContatoCadastro.Left := 0;
  ContatoCadastro.Top := 157;
  ContatoCadastro.Width := 590;
  ContatoCadastro.Height := 15;
  ContatoCadastro.Margins.Top := 0;
  ContatoCadastro.Margins.Right := 15;
  ContatoCadastro.Align := alTop;
  ContatoCadastro.Alignment := taRightJustify;
  ContatoCadastro.Caption := 'Cadastro (18) 99156-9756';
  ContatoCadastro.FontName := TPRFontName.fnTimesRoman;

  ContatoGutoFinanceiro.Parent := Layout;
  ContatoGutoFinanceiro.Left := 0;
  ContatoGutoFinanceiro.Top := 175;
  ContatoGutoFinanceiro.Width := 590;
  ContatoGutoFinanceiro.Height := 15;
  ContatoGutoFinanceiro.Margins.Top := 0;
  ContatoGutoFinanceiro.Margins.Right := 15;
  ContatoGutoFinanceiro.Align := alTop;
  ContatoGutoFinanceiro.Alignment := taRightJustify;
  ContatoGutoFinanceiro.Caption := 'Guto (18) 99715-4290 Vivo | Financeiro (18) 9968390436';
  ContatoGutoFinanceiro.FontName := TPRFontName.fnTimesRoman;

  ContatoEndereco.Parent := Layout;
  ContatoEndereco.Left := 0;
  ContatoEndereco.Top := 193;
  ContatoEndereco.Width := 575;
  ContatoEndereco.Height := 15;
  ContatoEndereco.Margins.Top := 0;
  ContatoEndereco.Margins.Right := 15;
  ContatoEndereco.Align := alTop;
  ContatoEndereco.Alignment := taRightJustify;
  ContatoEndereco.Caption := 'Av. José Siqueira, 40 – Centro – CEP 17700-000 – Osvaldo Cruz-SP';
  ContatoEndereco.FontName := TPRFontName.fnTimesRoman;

  // Data de Envio
  DataDeEnvioLabel.Parent := Layout;
  DataDeEnvioLabel.Left := 1;
  DataDeEnvioLabel.Top := 211;
  DataDeEnvioLabel.Width := 135;
  DataDeEnvioLabel.Height := 19;
  DataDeEnvioLabel.Align := alTop;
  DataDeEnvioLabel.Alignment := taCenter;
  DataDeEnvioLabel.Caption := 'Data de Envio';
  DataDeEnvioLabel.FontName := TPRFontName.fnTimesRoman;

  DataDeEnvioResult.Parent := Layout;
  DataDeEnvioResult.Left := 1;
  DataDeEnvioResult.Top := 229;
  DataDeEnvioResult.Width := 120;
  DataDeEnvioResult.Height := 19;
  DataDeEnvioResult.Align := alTop;
  DataDeEnvioResult.Alignment := taCenter;
  DataDeEnvioResult.FontBold := true;

  DataDeEnvioResult.Caption :=DateTimeToStrBrazilian(DataDeEnvio.DateTime);
  DataDeEnvioResult.FontName := TPRFontName.fnTimesRoman;

  // Uso Exclusivo do Laboratório
  UsoLab.Parent := Layout;
  UsoLab.Left := 1;
  UsoLab.Top := 211;
  UsoLab.Width := 695;
  UsoLab.Height := 19;
  UsoLab.Align := alTop;
  UsoLab.Alignment := taCenter;
  UsoLab.Caption := 'Uso Exclusivo do Laboratório';
  UsoLab.FontName := TPRFontName.fnTimesRoman;

  UsoLabOrdem.Parent := Layout;
  UsoLabOrdem.Left := 1;
  UsoLabOrdem.Top := 229;
  UsoLabOrdem.Width := 400;
  UsoLabOrdem.Height := 19;
  UsoLabOrdem.Align := alTop;
  UsoLabOrdem.Alignment := taCenter;
  UsoLabOrdem.Caption := 'Ordem';
  UsoLabOrdem.FontName := TPRFontName.fnTimesRoman;

  UsoLabEntrada.Parent := Layout;
  UsoLabEntrada.Left := 1;
  UsoLabEntrada.Top := 229;
  UsoLabEntrada.Width := 600;
  UsoLabEntrada.Height := 19;
  UsoLabEntrada.Align := alTop;
  UsoLabEntrada.Alignment := taCenter;
  UsoLabEntrada.Caption := 'Entrada';
  UsoLabEntrada.FontName := TPRFontName.fnTimesRoman;

  UsoLabEntrega.Parent := Layout;
  UsoLabEntrega.Left := 1;
  UsoLabEntrega.Top := 229;
  UsoLabEntrega.Width := 800;
  UsoLabEntrega.Height := 19;
  UsoLabEntrega.Align := alTop;
  UsoLabEntrega.Alignment := taCenter;
  UsoLabEntrega.Caption := 'Entrega';
  UsoLabEntrega.FontName := TPRFontName.fnTimesRoman;

  UsoLabHora.Parent := Layout;
  UsoLabHora.Left := 1;
  UsoLabHora.Top := 229;
  UsoLabHora.Width := 1000;
  UsoLabHora.Height := 19;
  UsoLabHora.Align := alTop;
  UsoLabHora.Alignment := taCenter;
  UsoLabHora.Caption := 'Hora';
  UsoLabHora.FontName := TPRFontName.fnTimesRoman;

  UsoLabOrdemResult.Parent := Layout;
  UsoLabOrdemResult.Left := 1;
  UsoLabOrdemResult.Top := 247;
  UsoLabOrdemResult.Width := 400;
  UsoLabOrdemResult.Height := 19;
  UsoLabOrdemResult.Align := alTop;
  UsoLabOrdemResult.Alignment := taCenter;
  UsoLabOrdemResult.Caption := Ordem.Text;
  UsoLabOrdemResult.FontName := TPRFontName.fnTimesRoman;
  UsoLabOrdemResult.FontBold := true;

  UsoLabEntradaResult.Parent := Layout;
  UsoLabEntradaResult.Left := 1;
  UsoLabEntradaResult.Top := 247;
  UsoLabEntradaResult.Width := 600;
  UsoLabEntradaResult.Height := 19;
  UsoLabEntradaResult.Align := alTop;
  UsoLabEntradaResult.Alignment := taCenter;
  UsoLabEntradaResult.Caption := DateTimeToStrBrazilian(Entrada.DateTime);
  UsoLabEntradaResult.FontName := TPRFontName.fnTimesRoman;
  UsoLabEntradaResult.FontBold := true;

  UsoLabEntregaResult.Parent := Layout;
  UsoLabEntregaResult.Left := 1;
  UsoLabEntregaResult.Top := 247;
  UsoLabEntregaResult.Width := 800;
  UsoLabEntregaResult.Height := 19;
  UsoLabEntregaResult.Align := alTop;
  UsoLabEntregaResult.Alignment := taCenter;
  UsoLabEntregaResult.Caption := DateTimeToStrBrazilian(Saida.DateTime);
  UsoLabEntregaResult.FontName := TPRFontName.fnTimesRoman;
  UsoLabEntregaResult.FontBold := true;

  UsoLabHoraResult.Parent := Layout;
  UsoLabHoraResult.Left := 1;
  UsoLabHoraResult.Top := 247;
  UsoLabHoraResult.Width := 1000;
  UsoLabHoraResult.Height := 19;
  UsoLabHoraResult.Align := alTop;
  UsoLabHoraResult.Alignment := taCenter;
  UsoLabHoraResult.Caption := Hora.Text;
  UsoLabHoraResult.FontName := TPRFontName.fnTimesRoman;
  UsoLabHoraResult.FontBold := true;

  // InfoPrincipal
  InfoPrincipalDrNome.Parent := Layout;
  InfoPrincipalDrNome.Left := 1;
  InfoPrincipalDrNome.Top := 265;
  InfoPrincipalDrNome.Width := 100;
  InfoPrincipalDrNome.Height := 19;
  InfoPrincipalDrNome.Align := alTop;
  InfoPrincipalDrNome.Alignment := taCenter;
  InfoPrincipalDrNome.Caption := 'Dr. (a): ';
  InfoPrincipalDrNome.FontName := TPRFontName.fnTimesRoman;

  InfoPrincipalDrNomeResult.Parent := Layout;
  InfoPrincipalDrNomeResult.Left := 1;
  InfoPrincipalDrNomeResult.Top := 265;
  InfoPrincipalDrNomeResult.Width := 300;
  InfoPrincipalDrNomeResult.Height := 19;
  InfoPrincipalDrNomeResult.Align := alTop;
  InfoPrincipalDrNomeResult.Alignment := taCenter;
  InfoPrincipalDrNomeResult.Caption := NomeDoutor.Text;
  InfoPrincipalDrNomeResult.FontName := TPRFontName.fnTimesRoman;
  InfoPrincipalDrNomeResult.FontBold := true;


  InfoPrincipalDrFone.Parent := Layout;
  InfoPrincipalDrFone.Left := 1;
  InfoPrincipalDrFone.Top := 265;
  InfoPrincipalDrFone.Width := 800;
  InfoPrincipalDrFone.Height := 19;
  InfoPrincipalDrFone.Align := alTop;
  InfoPrincipalDrFone.Alignment := taCenter;
  InfoPrincipalDrFone.Caption := 'Fone:';
  InfoPrincipalDrFone.FontName := TPRFontName.fnTimesRoman;

  InfoPrincipalDrFoneResult.Parent := Layout;
  InfoPrincipalDrFoneResult.Left := 1;
  InfoPrincipalDrFoneResult.Top := 265;
  InfoPrincipalDrFoneResult.Width := 1000;
  InfoPrincipalDrFoneResult.Height := 19;
  InfoPrincipalDrFoneResult.Align := alTop;
  InfoPrincipalDrFoneResult.Alignment := taCenter;
  InfoPrincipalDrFoneResult.Caption := Fone.Text;
  InfoPrincipalDrFoneResult.FontName := TPRFontName.fnTimesRoman;
  InfoPrincipalDrFoneResult.FontBold := true;

  InfoPrincipalPacienteNome.Parent := Layout;
  InfoPrincipalPacienteNome.Left := 1;
  InfoPrincipalPacienteNome.Top := 283;
  InfoPrincipalPacienteNome.Width := 108;
  InfoPrincipalPacienteNome.Height := 19;
  InfoPrincipalPacienteNome.Align := alTop;
  InfoPrincipalPacienteNome.Alignment := taCenter;
  InfoPrincipalPacienteNome.Caption := 'Paciente:';
  InfoPrincipalPacienteNome.FontName := TPRFontName.fnTimesRoman;

  InfoPrincipalPacienteNomeResult.Parent := Layout;
  InfoPrincipalPacienteNomeResult.Left := 1;
  InfoPrincipalPacienteNomeResult.Top := 283;
  InfoPrincipalPacienteNomeResult.Width := 292;
  InfoPrincipalPacienteNomeResult.Height := 19;
  InfoPrincipalPacienteNomeResult.Align := alTop;
  InfoPrincipalPacienteNomeResult.Alignment := taCenter;
  InfoPrincipalPacienteNomeResult.Caption := NomePaciente.Text;
  InfoPrincipalPacienteNomeResult.FontName := TPRFontName.fnTimesRoman;
  InfoPrincipalPacienteNomeResult.FontBold := true;

  InfoPrincipalPacientePele.Parent := Layout;
  InfoPrincipalPacientePele.Left := 1;
  InfoPrincipalPacientePele.Top := 283;
  InfoPrincipalPacientePele.Width := 800;
  InfoPrincipalPacientePele.Height := 19;
  InfoPrincipalPacientePele.Align := alTop;
  InfoPrincipalPacientePele.Alignment := taCenter;
  InfoPrincipalPacientePele.Caption := 'Pele:';
  InfoPrincipalPacientePele.FontName := TPRFontName.fnTimesRoman;

  InfoPrincipalPacientePeleResult.Parent := Layout;
  InfoPrincipalPacientePeleResult.Left := 1;
  InfoPrincipalPacientePeleResult.Top := 283;
  InfoPrincipalPacientePeleResult.Width := 900;
  InfoPrincipalPacientePeleResult.Height := 19;
  InfoPrincipalPacientePeleResult.Align := alTop;
  InfoPrincipalPacientePeleResult.Alignment := taCenter;
  InfoPrincipalPacientePeleResult.Caption := Pele.Text;
  InfoPrincipalPacientePeleResult.FontName := TPRFontName.fnTimesRoman;
  InfoPrincipalPacientePeleResult.FontBold := true;

  InfoPrincipalPacienteSexo.Parent := Layout;
  InfoPrincipalPacienteSexo.Left := 1;
  InfoPrincipalPacienteSexo.Top := 283;
  InfoPrincipalPacienteSexo.Width := 1000;
  InfoPrincipalPacienteSexo.Height := 19;
  InfoPrincipalPacienteSexo.Align := alTop;
  InfoPrincipalPacienteSexo.Alignment := taCenter;
  InfoPrincipalPacienteSexo.Caption := 'Sexo';
  InfoPrincipalPacienteSexo.FontName := TPRFontName.fnTimesRoman;

  InfoPrincipalPacienteSexoResult.Parent := Layout;
  InfoPrincipalPacienteSexoResult.Left := 1;
  InfoPrincipalPacienteSexoResult.Top := 283;
  InfoPrincipalPacienteSexoResult.Width := 1100;
  InfoPrincipalPacienteSexoResult.Height := 19;
  InfoPrincipalPacienteSexoResult.Align := alTop;
  InfoPrincipalPacienteSexoResult.Alignment := taCenter;
  InfoPrincipalPacienteSexoResult.FontBold := true;

  if Feminino.Checked then
    InfoPrincipalPacienteSexoResult.Caption := 'Feminino'
  else if Masculino.Checked then
    InfoPrincipalPacienteSexoResult.Caption := 'Masculino'
  else
    InfoPrincipalPacienteSexoResult.Caption := 'Não Inserido';

  InfoPrincipalPacienteSexoResult.FontName := TPRFontName.fnTimesRoman;

  // Solicitação do Serviço
  SolicitacaoServicoLabel.Parent := Layout;
  SolicitacaoServicoLabel.Left := 1;
  SolicitacaoServicoLabel.Top := 301;
  SolicitacaoServicoLabel.Width := 595;
  SolicitacaoServicoLabel.Height := 19;
  SolicitacaoServicoLabel.Align := alTop;
  SolicitacaoServicoLabel.Alignment := taCenter;
  SolicitacaoServicoLabel.Caption := 'Solicitação do Serviço';
  SolicitacaoServicoLabel.FontName := TPRFontName.fnTimesRoman;

  SolicitacaoServicoResult.Parent := Layout;
  SolicitacaoServicoResult.Left := 30;
  SolicitacaoServicoResult.Top := 319;
  SolicitacaoServicoResult.Width := 550;
  SolicitacaoServicoResult.Height := 200;
  SolicitacaoServicoResult.WordWrap := true;
  SolicitacaoServicoResult.Align := alTop;
  SolicitacaoServicoResult.Text := SolicitacaoServico.Lines.GetText;
  SolicitacaoServicoResult.FontName := TPRFontName.fnTimesRoman;

  // Prova ou Pronto
  ProvaOuProntoLabel.Parent := Layout;
  ProvaOuProntoLabel.Left := 1;
  ProvaOuProntoLabel.Top := 519;
  ProvaOuProntoLabel.Width := 595;
  ProvaOuProntoLabel.Height := 19;
  ProvaOuProntoLabel.Align := alTop;
  ProvaOuProntoLabel.Alignment := taCenter;
  if Prova.Checked then
    ProvaOuProntoLabel.Caption := 'Serviço: Prova'
  else if Pronto.Checked then
    ProvaOuProntoLabel.Caption := 'Serviço: Pronto'
  else
    ProvaOuProntoLabel.Caption := 'Não Inserido';
  ProvaOuProntoLabel.FontName := TPRFontName.fnTimesRoman;

  //  Informação Dentes
  InfoDente.Parent := Layout;
  InfoDente.Left := 1;
  InfoDente.Top := 537;
  InfoDente.Width := 108;
  InfoDente.Height := 19;
  InfoDente.Align := alTop;
  InfoDente.Alignment := taCenter;
  InfoDente.Caption := 'Dentes';
  InfoDente.FontName := TPRFontName.fnTimesRoman;

  InfoDenteCorEscala.Parent := Layout;
  InfoDenteCorEscala.Left := 1;
  InfoDenteCorEscala.Top := 555;
  InfoDenteCorEscala.Width := 130;
  InfoDenteCorEscala.Height := 19;
  InfoDenteCorEscala.Align := alTop;
  InfoDenteCorEscala.Alignment := taCenter;
  InfoDenteCorEscala.Caption := 'Cor / Escala:';
  InfoDenteCorEscala.FontName := TPRFontName.fnTimesRoman;

  InfoDenteCorEscalaResult.Parent := Layout;
  InfoDenteCorEscalaResult.Left := 1;
  InfoDenteCorEscalaResult.Top := 555;
  InfoDenteCorEscalaResult.Width := 400;
  InfoDenteCorEscalaResult.Height := 19;
  InfoDenteCorEscalaResult.Align := alTop;
  InfoDenteCorEscalaResult.Alignment := taCenter;
  InfoDenteCorEscalaResult.Caption := CorEscala.Text;
  InfoDenteCorEscalaResult.FontName := TPRFontName.fnTimesRoman;

  InfoDenteMarcaDente.Parent := Layout;
  InfoDenteMarcaDente.Left := 1;
  InfoDenteMarcaDente.Top := 573;
  InfoDenteMarcaDente.Width := 153;
  InfoDenteMarcaDente.Height := 19;
  InfoDenteMarcaDente.Align := alTop;
  InfoDenteMarcaDente.Alignment := taCenter;
  InfoDenteMarcaDente.Caption := 'Marca Do Dente:';
  InfoDenteMarcaDente.FontName := TPRFontName.fnTimesRoman;

  InfoDenteMarcaDenteResult.Parent := Layout;
  InfoDenteMarcaDenteResult.Left := 1;
  InfoDenteMarcaDenteResult.Top := 573;
  InfoDenteMarcaDenteResult.Width := 400;
  InfoDenteMarcaDenteResult.Height := 19;
  InfoDenteMarcaDenteResult.Align := alTop;
  InfoDenteMarcaDenteResult.Alignment := taCenter;
  InfoDenteMarcaDenteResult.Caption := MarcaDoDente.Text;
  InfoDenteMarcaDenteResult.FontName := TPRFontName.fnTimesRoman;

  InfoCorGengivaSTG.Parent := Layout;
  InfoCorGengivaSTG.Left := 1;
  InfoCorGengivaSTG.Top := 591;
  InfoCorGengivaSTG.Width := 160;
  InfoCorGengivaSTG.Height := 19;
  InfoCorGengivaSTG.Align := alTop;
  InfoCorGengivaSTG.Alignment := taCenter;
  InfoCorGengivaSTG.Caption := 'Cor Gengiva STG:';
  InfoCorGengivaSTG.FontName := TPRFontName.fnTimesRoman;

  InfoCorGengivaSTGResult.Parent := Layout;
  InfoCorGengivaSTGResult.Left := 1;
  InfoCorGengivaSTGResult.Top := 591;
  InfoCorGengivaSTGResult.Width := 400;
  InfoCorGengivaSTGResult.Height := 19;
  InfoCorGengivaSTGResult.Align := alTop;
  InfoCorGengivaSTGResult.Alignment := taCenter;
  InfoCorGengivaSTGResult.Caption := CorSTG.Text;
  InfoCorGengivaSTGResult.FontName := TPRFontName.fnTimesRoman;

  InfoGuiaCaracterizacao.Parent := Layout;
  InfoGuiaCaracterizacao.Left := 1;
  InfoGuiaCaracterizacao.Top := 537;
  InfoGuiaCaracterizacao.Width := 900;
  InfoGuiaCaracterizacao.Height := 19;
  InfoGuiaCaracterizacao.Align := alTop;
  InfoGuiaCaracterizacao.Alignment := taCenter;
  InfoGuiaCaracterizacao.Caption := 'Guia de Caracterização';
  InfoGuiaCaracterizacao.FontName := TPRFontName.fnTimesRoman;

  InfoGuiaCheck11.Parent := Layout;
  InfoGuiaCheck11.Left := 1;
  InfoGuiaCheck11.Top := 555;
  InfoGuiaCheck11.Width := 890;
  InfoGuiaCheck11.Height := 19;
  InfoGuiaCheck11.Align := alTop;
  InfoGuiaCheck11.Alignment := taCenter;
  if Check11.Checked then
    InfoGuiaCheck11.Caption := '11';
  InfoGuiaCheck11.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck11.FontBold := true;

  InfoGuiaCheck12.Parent := Layout;
  InfoGuiaCheck12.Left := 1;
  InfoGuiaCheck12.Top := 555;
  InfoGuiaCheck12.Width := 860;
  InfoGuiaCheck12.Height := 19;
  InfoGuiaCheck12.Align := alTop;
  InfoGuiaCheck12.Alignment := taCenter;
  if Check12.Checked then
    InfoGuiaCheck12.Caption := '12';
  InfoGuiaCheck12.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck12.FontBold := true;

  InfoGuiaCheck13.Parent := Layout;
  InfoGuiaCheck13.Left := 1;
  InfoGuiaCheck13.Top := 555;
  InfoGuiaCheck13.Width := 830;
  InfoGuiaCheck13.Height := 19;
  InfoGuiaCheck13.Align := alTop;
  InfoGuiaCheck13.Alignment := taCenter;
  if Check13.Checked then
    InfoGuiaCheck13.Caption := '13';
  InfoGuiaCheck13.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck13.FontBold := true;

  InfoGuiaCheck14.Parent := Layout;
  InfoGuiaCheck14.Left := 1;
  InfoGuiaCheck14.Top := 555;
  InfoGuiaCheck14.Width := 800;
  InfoGuiaCheck14.Height := 19;
  InfoGuiaCheck14.Align := alTop;
  InfoGuiaCheck14.Alignment := taCenter;
  if Check14.Checked then
    InfoGuiaCheck14.Caption := '14';
  InfoGuiaCheck14.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck14.FontBold := true;

  InfoGuiaCheck15.Parent := Layout;
  InfoGuiaCheck15.Left := 1;
  InfoGuiaCheck15.Top := 573;
  InfoGuiaCheck15.Width := 890;
  InfoGuiaCheck15.Height := 19;
  InfoGuiaCheck15.Align := alTop;
  InfoGuiaCheck15.Alignment := taCenter;
  if Check15.Checked then
    InfoGuiaCheck15.Caption := '15';
  InfoGuiaCheck15.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck15.FontBold := true;

  InfoGuiaCheck16.Parent := Layout;
  InfoGuiaCheck16.Left := 1;
  InfoGuiaCheck16.Top := 573;
  InfoGuiaCheck16.Width := 860;
  InfoGuiaCheck16.Height := 19;
  InfoGuiaCheck16.Align := alTop;
  InfoGuiaCheck16.Alignment := taCenter;
  if Check16.Checked then
    InfoGuiaCheck16.Caption := '16';
  InfoGuiaCheck16.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck16.FontBold := true;

  InfoGuiaCheck17.Parent := Layout;
  InfoGuiaCheck17.Left := 1;
  InfoGuiaCheck17.Top := 573;
  InfoGuiaCheck17.Width := 830;
  InfoGuiaCheck17.Height := 19;
  InfoGuiaCheck17.Align := alTop;
  InfoGuiaCheck17.Alignment := taCenter;
  if Check17.Checked then
    InfoGuiaCheck17.Caption := '17';
  InfoGuiaCheck17.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck17.FontBold := true;

  InfoGuiaCheck18.Parent := Layout;
  InfoGuiaCheck18.Left := 1;
  InfoGuiaCheck18.Top := 573;
  InfoGuiaCheck18.Width := 800;
  InfoGuiaCheck18.Height := 19;
  InfoGuiaCheck18.Align := alTop;
  InfoGuiaCheck18.Alignment := taCenter;
  if Check18.Checked then
    InfoGuiaCheck18.Caption := '18';
  InfoGuiaCheck18.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck18.FontBold := true;


  InfoGuiaCheck21.Parent := Layout;
  InfoGuiaCheck21.Left := 1;
  InfoGuiaCheck21.Top := 555;
  InfoGuiaCheck21.Width := 950;
  InfoGuiaCheck21.Height := 19;
  InfoGuiaCheck21.Align := alTop;
  InfoGuiaCheck21.Alignment := taCenter;
  if Check21.Checked then
    InfoGuiaCheck21.Caption := '21';
  InfoGuiaCheck21.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck21.FontBold := true;

  InfoGuiaCheck22.Parent := Layout;
  InfoGuiaCheck22.Left := 1;
  InfoGuiaCheck22.Top := 555;
  InfoGuiaCheck22.Width := 980;
  InfoGuiaCheck22.Height := 19;
  InfoGuiaCheck22.Align := alTop;
  InfoGuiaCheck22.Alignment := taCenter;
  if Check22.Checked then
    InfoGuiaCheck22.Caption := '22';
  InfoGuiaCheck22.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck22.FontBold := true;

  InfoGuiaCheck23.Parent := Layout;
  InfoGuiaCheck23.Left := 1;
  InfoGuiaCheck23.Top := 555;
  InfoGuiaCheck23.Width := 1010;
  InfoGuiaCheck23.Height := 19;
  InfoGuiaCheck23.Align := alTop;
  InfoGuiaCheck23.Alignment := taCenter;
  if Check23.Checked then
    InfoGuiaCheck23.Caption := '23';
  InfoGuiaCheck23.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck23.FontBold := true;

  InfoGuiaCheck24.Parent := Layout;
  InfoGuiaCheck24.Left := 1;
  InfoGuiaCheck24.Top := 555;
  InfoGuiaCheck24.Width := 1040;
  InfoGuiaCheck24.Height := 19;
  InfoGuiaCheck24.Align := alTop;
  InfoGuiaCheck24.Alignment := taCenter;
  if Check24.Checked then
    InfoGuiaCheck24.Caption := '24';
  InfoGuiaCheck24.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck24.FontBold := true;

  InfoGuiaCheck25.Parent := Layout;
  InfoGuiaCheck25.Left := 1;
  InfoGuiaCheck25.Top := 573;
  InfoGuiaCheck25.Width := 950;
  InfoGuiaCheck25.Height := 19;
  InfoGuiaCheck25.Align := alTop;
  InfoGuiaCheck25.Alignment := taCenter;
  if Check25.Checked then
    InfoGuiaCheck25.Caption := '25';
  InfoGuiaCheck25.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck25.FontBold := true;

  InfoGuiaCheck26.Parent := Layout;
  InfoGuiaCheck26.Left := 1;
  InfoGuiaCheck26.Top := 573;
  InfoGuiaCheck26.Width := 980;
  InfoGuiaCheck26.Height := 19;
  InfoGuiaCheck26.Align := alTop;
  InfoGuiaCheck26.Alignment := taCenter;
  if Check26.Checked then
    InfoGuiaCheck26.Caption := '26';
  InfoGuiaCheck26.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck26.FontBold := true;

  InfoGuiaCheck27.Parent := Layout;
  InfoGuiaCheck27.Left := 1;
  InfoGuiaCheck27.Top := 573;
  InfoGuiaCheck27.Width := 1010;
  InfoGuiaCheck27.Height := 19;
  InfoGuiaCheck27.Align := alTop;
  InfoGuiaCheck27.Alignment := taCenter;
  if Check27.Checked then
    InfoGuiaCheck27.Caption := '27';
  InfoGuiaCheck27.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck27.FontBold := true;

  InfoGuiaCheck28.Parent := Layout;
  InfoGuiaCheck28.Left := 1;
  InfoGuiaCheck28.Top := 573;
  InfoGuiaCheck28.Width := 1040;
  InfoGuiaCheck28.Height := 19;
  InfoGuiaCheck28.Align := alTop;
  InfoGuiaCheck28.Alignment := taCenter;
  if Check28.Checked then
    InfoGuiaCheck28.Caption := '28';
  InfoGuiaCheck28.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck28.FontBold := true;


  InfoGuiaCheck31.Parent := Layout;
  InfoGuiaCheck31.Left := 1;
  InfoGuiaCheck31.Top := 591;
  InfoGuiaCheck31.Width := 950;
  InfoGuiaCheck31.Height := 19;
  InfoGuiaCheck31.Align := alTop;
  InfoGuiaCheck31.Alignment := taCenter;
  if Check31.Checked then
    InfoGuiaCheck31.Caption := '31';
  InfoGuiaCheck31.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck31.FontBold := true;

  InfoGuiaCheck32.Parent := Layout;
  InfoGuiaCheck32.Left := 1;
  InfoGuiaCheck32.Top := 591;
  InfoGuiaCheck32.Width := 980;
  InfoGuiaCheck32.Height := 19;
  InfoGuiaCheck32.Align := alTop;
  InfoGuiaCheck32.Alignment := taCenter;
  if Check32.Checked then
    InfoGuiaCheck32.Caption := '32';
  InfoGuiaCheck32.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck32.FontBold := true;

  InfoGuiaCheck33.Parent := Layout;
  InfoGuiaCheck33.Left := 1;
  InfoGuiaCheck33.Top := 591;
  InfoGuiaCheck33.Width := 1010;
  InfoGuiaCheck33.Height := 19;
  InfoGuiaCheck33.Align := alTop;
  InfoGuiaCheck33.Alignment := taCenter;
  if Check33.Checked then
    InfoGuiaCheck33.Caption := '33';
  InfoGuiaCheck33.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck33.FontBold := true;

  InfoGuiaCheck34.Parent := Layout;
  InfoGuiaCheck34.Left := 1;
  InfoGuiaCheck34.Top := 591;
  InfoGuiaCheck34.Width := 1040;
  InfoGuiaCheck34.Height := 19;
  InfoGuiaCheck34.Align := alTop;
  InfoGuiaCheck34.Alignment := taCenter;
  if Check34.Checked then
    InfoGuiaCheck34.Caption := '34';
  InfoGuiaCheck34.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck34.FontBold := true;

  InfoGuiaCheck35.Parent := Layout;
  InfoGuiaCheck35.Left := 1;
  InfoGuiaCheck35.Top := 608;
  InfoGuiaCheck35.Width := 950;
  InfoGuiaCheck35.Height := 19;
  InfoGuiaCheck35.Align := alTop;
  InfoGuiaCheck35.Alignment := taCenter;
  if Check35.Checked then
    InfoGuiaCheck35.Caption := '35';
  InfoGuiaCheck35.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck35.FontBold := true;

  InfoGuiaCheck36.Parent := Layout;
  InfoGuiaCheck36.Left := 1;
  InfoGuiaCheck36.Top := 608;
  InfoGuiaCheck36.Width := 980;
  InfoGuiaCheck36.Height := 19;
  InfoGuiaCheck36.Align := alTop;
  InfoGuiaCheck36.Alignment := taCenter;
  if Check36.Checked then
    InfoGuiaCheck36.Caption := '36';
  InfoGuiaCheck36.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck36.FontBold := true;

  InfoGuiaCheck37.Parent := Layout;
  InfoGuiaCheck37.Left := 1;
  InfoGuiaCheck37.Top := 608;
  InfoGuiaCheck37.Width := 1010;
  InfoGuiaCheck37.Height := 19;
  InfoGuiaCheck37.Align := alTop;
  InfoGuiaCheck37.Alignment := taCenter;
  if Check37.Checked then
    InfoGuiaCheck37.Caption := '37';
  InfoGuiaCheck37.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck37.FontBold := true;

  InfoGuiaCheck38.Parent := Layout;
  InfoGuiaCheck38.Left := 1;
  InfoGuiaCheck38.Top := 608;
  InfoGuiaCheck38.Width := 1040;
  InfoGuiaCheck38.Height := 19;
  InfoGuiaCheck38.Align := alTop;
  InfoGuiaCheck38.Alignment := taCenter;
  if Check38.Checked then
    InfoGuiaCheck38.Caption := '38';
  InfoGuiaCheck38.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck38.FontBold := true;

  InfoGuiaCheck41.Parent := Layout;
  InfoGuiaCheck41.Left := 1;
  InfoGuiaCheck41.Top := 591;
  InfoGuiaCheck41.Width := 890;
  InfoGuiaCheck41.Height := 19;
  InfoGuiaCheck41.Align := alTop;
  InfoGuiaCheck41.Alignment := taCenter;
  if Check41.Checked then
    InfoGuiaCheck41.Caption := '41';
  InfoGuiaCheck41.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck41.FontBold := true;

  InfoGuiaCheck42.Parent := Layout;
  InfoGuiaCheck42.Left := 1;
  InfoGuiaCheck42.Top := 591;
  InfoGuiaCheck42.Width := 860;
  InfoGuiaCheck42.Height := 19;
  InfoGuiaCheck42.Align := alTop;
  InfoGuiaCheck42.Alignment := taCenter;
  if Check42.Checked then
    InfoGuiaCheck42.Caption := '42';
  InfoGuiaCheck42.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck43.FontBold := true;

  InfoGuiaCheck43.Parent := Layout;
  InfoGuiaCheck43.Left := 1;
  InfoGuiaCheck43.Top := 591;
  InfoGuiaCheck43.Width := 830;
  InfoGuiaCheck43.Height := 19;
  InfoGuiaCheck43.Align := alTop;
  InfoGuiaCheck43.Alignment := taCenter;
  if Check43.Checked then
    InfoGuiaCheck43.Caption := '43';
  InfoGuiaCheck43.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck43.FontBold := true;

  InfoGuiaCheck44.Parent := Layout;
  InfoGuiaCheck44.Left := 1;
  InfoGuiaCheck44.Top := 591;
  InfoGuiaCheck44.Width := 800;
  InfoGuiaCheck44.Height := 19;
  InfoGuiaCheck44.Align := alTop;
  InfoGuiaCheck44.Alignment := taCenter;
  if Check44.Checked then
    InfoGuiaCheck44.Caption := '44';
  InfoGuiaCheck24.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck44.FontBold := true;

  InfoGuiaCheck45.Parent := Layout;
  InfoGuiaCheck45.Left := 1;
  InfoGuiaCheck45.Top := 608;
  InfoGuiaCheck45.Width := 890;
  InfoGuiaCheck45.Height := 19;
  InfoGuiaCheck45.Align := alTop;
  InfoGuiaCheck45.Alignment := taCenter;
  if Check45.Checked then
    InfoGuiaCheck45.Caption := '45';
  InfoGuiaCheck45.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck45.FontBold := true;

  InfoGuiaCheck46.Parent := Layout;
  InfoGuiaCheck46.Left := 1;
  InfoGuiaCheck46.Top := 608;
  InfoGuiaCheck46.Width := 860;
  InfoGuiaCheck46.Height := 19;
  InfoGuiaCheck46.Align := alTop;
  InfoGuiaCheck46.Alignment := taCenter;
  if Check46.Checked then
    InfoGuiaCheck46.Caption := '46';
  InfoGuiaCheck46.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck46.FontBold := true;

  InfoGuiaCheck47.Parent := Layout;
  InfoGuiaCheck47.Left := 1;
  InfoGuiaCheck47.Top := 608;
  InfoGuiaCheck47.Width := 830;
  InfoGuiaCheck47.Height := 19;
  InfoGuiaCheck47.Align := alTop;
  InfoGuiaCheck47.Alignment := taCenter;
  if Check47.Checked then
    InfoGuiaCheck47.Caption := '47';
  InfoGuiaCheck47.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck47.FontBold := true;

  InfoGuiaCheck48.Parent := Layout;
  InfoGuiaCheck48.Left := 1;
  InfoGuiaCheck48.Top := 608;
  InfoGuiaCheck48.Width := 800;
  InfoGuiaCheck48.Height := 19;
  InfoGuiaCheck48.Align := alTop;
  InfoGuiaCheck48.Alignment := taCenter;
  if Check48.Checked then
    InfoGuiaCheck48.Caption := '48';
  InfoGuiaCheck48.FontName := TPRFontName.fnTimesRoman;
  InfoGuiaCheck48.FontBold := true;






  // Materiais Enviados ao Laboratório

  MateriasEnviados.Parent := Layout;
  MateriasEnviados.Top := 626;
  MateriasEnviados.Left := 220;
  MateriasEnviados.Width := 595;
  MateriasEnviados.Caption := 'Materiais Enviados ao Laboratório';
  MateriasEnviados.FontName := TPRFontName.fnTimesRoman;

  DescLabel1.Parent := Layout;
  DescLabel1.Top := 644;
  DescLabel1.Left := 14;
  DescLabel1.Width := 100;
  DescLabel1.Caption := 'Descrição';
  DescLabel1.FontName := TPRFontName.fnTimesRoman;

  DescLabel2.Parent := Layout;
  DescLabel2.Top := 644;
  DescLabel2.Left := 164;
  DescLabel2.Width := 100;
  DescLabel2.Caption := 'Descrição';
  DescLabel2.FontName := TPRFontName.fnTimesRoman;

  DescLabel3.Parent := Layout;
  DescLabel3.Top := 644;
  DescLabel3.Left := 314;
  DescLabel3.Width := 100;
  DescLabel3.Caption := 'Descrição';
  DescLabel3.FontName := TPRFontName.fnTimesRoman;

  DescLabel4.Parent := Layout;
  DescLabel4.Top := 644;
  DescLabel4.Left := 464;
  DescLabel4.Width := 100;
  DescLabel4.Caption := 'Descrição';
  DescLabel4.FontName := TPRFontName.fnTimesRoman;

  QtdeLabel1.Parent := Layout;
  QtdeLabel1.Top := 644;
  QtdeLabel1.Left := 114;
  QtdeLabel1.Width := 100;
  QtdeLabel1.Caption := 'Qtde';
  QtdeLabel1.FontName := TPRFontName.fnTimesRoman;

  QtdeLabel2.Parent := Layout;
  QtdeLabel2.Top := 644;
  QtdeLabel2.Left := 264;
  QtdeLabel2.Width := 100;
  QtdeLabel2.Caption := 'Qtde';
  QtdeLabel2.FontName := TPRFontName.fnTimesRoman;

  QtdeLabel3.Parent := Layout;
  QtdeLabel3.Top := 644;
  QtdeLabel3.Left := 414;
  QtdeLabel3.Width := 100;
  QtdeLabel3.Caption := 'Qtde';
  QtdeLabel3.FontName := TPRFontName.fnTimesRoman;

  QtdeLabel4.Parent := Layout;
  QtdeLabel4.Top := 644;
  QtdeLabel4.Left := 564;
  QtdeLabel4.Width := 100;
  QtdeLabel4.Caption := 'Qtde';
  QtdeLabel4.FontName := TPRFontName.fnTimesRoman;

  QtdeAntagonistaLabel.Parent := Layout;
  QtdeAntagonistaLabel.Top := 662;
  QtdeAntagonistaLabel.Left := 14;
  QtdeAntagonistaLabel.Width := 100;
  QtdeAntagonistaLabel.Caption := 'Antagonista';
  QtdeAntagonistaLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeBolachaLabel.Parent := Layout;
  QtdeBolachaLabel.Top := 680;
  QtdeBolachaLabel.Left := 14;
  QtdeBolachaLabel.Width := 100;
  QtdeBolachaLabel.Caption := 'Bolacha';
  QtdeBolachaLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeEscalaCoresLabel.Parent := Layout;
  QtdeEscalaCoresLabel.Top := 698;
  QtdeEscalaCoresLabel.Left := 14;
  QtdeEscalaCoresLabel.Width := 100;
  QtdeEscalaCoresLabel.Caption := 'Escala de Cores';
  QtdeEscalaCoresLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeModeloEstudoLabel.Parent := Layout;
  QtdeModeloEstudoLabel.Top := 716;
  QtdeModeloEstudoLabel.Left := 14;
  QtdeModeloEstudoLabel.Width := 100;
  QtdeModeloEstudoLabel.Caption := 'Modelo de Estudo';
  QtdeModeloEstudoLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeAntagonistaResult.Parent := Layout;
  QtdeAntagonistaResult.Top := 662;
  QtdeAntagonistaResult.Left := 114;
  QtdeAntagonistaResult.Width := 100;
  QtdeAntagonistaResult.Caption := QtdeAntagonista.Text;
  QtdeAntagonistaResult.FontName := TPRFontName.fnTimesRoman;

  QtdeBolachaResult.Parent := Layout;
  QtdeBolachaResult.Top := 680;
  QtdeBolachaResult.Left := 114;
  QtdeBolachaResult.Width := 100;
  QtdeBolachaResult.Caption := QtdeBolacha.Text;
  QtdeBolachaResult.FontName := TPRFontName.fnTimesRoman;

  QtdeEscalaCoresResult.Parent := Layout;
  QtdeEscalaCoresResult.Top := 698;
  QtdeEscalaCoresResult.Left := 114;
  QtdeEscalaCoresResult.Width := 100;
  QtdeEscalaCoresResult.Caption := QtdeEscala.Text;
  QtdeEscalaCoresResult.FontName := TPRFontName.fnTimesRoman;

  QtdeModeloEstudoResult.Parent := Layout;
  QtdeModeloEstudoResult.Top := 716;
  QtdeModeloEstudoResult.Left := 114;
  QtdeModeloEstudoResult.Width := 100;
  QtdeModeloEstudoResult.Caption := QtdeModeloEstudo.Text;
  QtdeModeloEstudoResult.FontName := TPRFontName.fnTimesRoman;


  QtdeModeloTrabalhoLabel.Parent := Layout;
  QtdeModeloTrabalhoLabel.Top := 662;
  QtdeModeloTrabalhoLabel.Left := 164;
  QtdeModeloTrabalhoLabel.Width := 100;
  QtdeModeloTrabalhoLabel.Caption := 'Mod. de Trabalho';
  QtdeModeloTrabalhoLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeMoldagemLabel.Parent := Layout;
  QtdeMoldagemLabel.Top := 680;
  QtdeMoldagemLabel.Left := 164;
  QtdeMoldagemLabel.Width := 100;
  QtdeMoldagemLabel.Caption := 'Moldagem';
  QtdeMoldagemLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeMoldeiraLabel.Parent := Layout;
  QtdeMoldeiraLabel.Top := 698;
  QtdeMoldeiraLabel.Left := 164;
  QtdeMoldeiraLabel.Width := 100;
  QtdeMoldeiraLabel.Caption := 'Moldeira';
  QtdeMoldeiraLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeMordidaLabel.Parent := Layout;
  QtdeMordidaLabel.Top := 716;
  QtdeMordidaLabel.Left := 164;
  QtdeMordidaLabel.Width := 100;
  QtdeMordidaLabel.Caption := 'Mordida';
  QtdeMordidaLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeModeloTrabalhoResult.Parent := Layout;
  QtdeModeloTrabalhoResult.Top := 662;
  QtdeModeloTrabalhoResult.Left := 264;
  QtdeModeloTrabalhoResult.Width := 100;
  QtdeModeloTrabalhoResult.Caption := QtdeModeloTrabalho.Text;
  QtdeModeloTrabalhoResult.FontName := TPRFontName.fnTimesRoman;

  QtdeMoldagemResult.Parent := Layout;
  QtdeMoldagemResult.Top := 680;
  QtdeMoldagemResult.Left := 264;
  QtdeMoldagemResult.Width := 100;
  QtdeMoldagemResult.Caption := QtdeMoldagem.Text;
  QtdeMoldagemResult.FontName := TPRFontName.fnTimesRoman;

  QtdeMoldeiraResult.Parent := Layout;
  QtdeMoldeiraResult.Top := 698;
  QtdeMoldeiraResult.Left := 264;
  QtdeMoldeiraResult.Width := 100;
  QtdeMoldeiraResult.Caption := QtdeMoldeira.Text;
  QtdeMoldeiraResult.FontName := TPRFontName.fnTimesRoman;

  QtdeMordidaResult.Parent := Layout;
  QtdeMordidaResult.Top := 716;
  QtdeMordidaResult.Left := 264;
  QtdeMordidaResult.Width := 100;
  QtdeMordidaResult.Caption := QtdeMordida.Text;
  QtdeMordidaResult.FontName := TPRFontName.fnTimesRoman;



  QtdeParafusoLabel.Parent := Layout;
  QtdeParafusoLabel.Top := 662;
  QtdeParafusoLabel.Left := 314;
  QtdeParafusoLabel.Width := 100;
  QtdeParafusoLabel.Caption := 'Parafuso';
  QtdeParafusoLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeAnalogoLabel.Parent := Layout;
  QtdeAnalogoLabel.Top := 680;
  QtdeAnalogoLabel.Left := 314;
  QtdeAnalogoLabel.Width := 100;
  QtdeAnalogoLabel.Caption := 'Análogo';
  QtdeAnalogoLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeTransferLabel.Parent := Layout;
  QtdeTransferLabel.Top := 698;
  QtdeTransferLabel.Left := 314;
  QtdeTransferLabel.Width := 100;
  QtdeTransferLabel.Caption := 'Transfer';
  QtdeTransferLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeUclaLabel.Parent := Layout;
  QtdeUclaLabel.Top := 716;
  QtdeUclaLabel.Left := 314;
  QtdeUclaLabel.Width := 100;
  QtdeUclaLabel.Caption := 'Ucla';
  QtdeUclaLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeParafusoResult.Parent := Layout;
  QtdeParafusoResult.Top := 662;
  QtdeParafusoResult.Left := 414;
  QtdeParafusoResult.Width := 100;
  QtdeParafusoResult.Caption := QtdeParafuso.Text;
  QtdeParafusoResult.FontName := TPRFontName.fnTimesRoman;

  QtdeAnalogoResult.Parent := Layout;
  QtdeAnalogoResult.Top := 680;
  QtdeAnalogoResult.Left := 414;
  QtdeAnalogoResult.Width := 100;
  QtdeAnalogoResult.Caption := QtdeAnalogo.Text;
  QtdeAnalogoResult.FontName := TPRFontName.fnTimesRoman;

  QtdeTransferResult.Parent := Layout;
  QtdeTransferResult.Top := 698;
  QtdeTransferResult.Left := 414;
  QtdeTransferResult.Width := 100;
  QtdeTransferResult.Caption := QtdeTransfer.Text;
  QtdeTransferResult.FontName := TPRFontName.fnTimesRoman;

  QtdeUclaResult.Parent := Layout;
  QtdeUclaResult.Top := 716;
  QtdeUclaResult.Left := 414;
  QtdeUclaResult.Width := 100;
  QtdeUclaResult.Caption := QtdeUcla.Text;
  QtdeUclaResult.FontName := TPRFontName.fnTimesRoman;




  QtdeMuralhaLabel.Parent := Layout;
  QtdeMuralhaLabel.Top := 662;
  QtdeMuralhaLabel.Left := 464;
  QtdeMuralhaLabel.Width := 100;
  QtdeMuralhaLabel.Caption := 'Muralha';
  QtdeMuralhaLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeBarraLabel.Parent := Layout;
  QtdeBarraLabel.Top := 680;
  QtdeBarraLabel.Left := 464;
  QtdeBarraLabel.Width := 100;
  QtdeBarraLabel.Caption := 'Barra';
  QtdeBarraLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeProtocoloLabel.Parent := Layout;
  QtdeProtocoloLabel.Top := 698;
  QtdeProtocoloLabel.Left := 464;
  QtdeProtocoloLabel.Width := 100;
  QtdeProtocoloLabel.Caption := 'Protocolo';
  QtdeProtocoloLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeBaseProvaLabel.Parent := Layout;
  QtdeBaseProvaLabel.Top := 716;
  QtdeBaseProvaLabel.Left := 464;
  QtdeBaseProvaLabel.Width := 100;
  QtdeBaseProvaLabel.Caption := 'Base de Prova';
  QtdeBaseProvaLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeMuralhaResult.Parent := Layout;
  QtdeMuralhaResult.Top := 662;
  QtdeMuralhaResult.Left := 564;
  QtdeMuralhaResult.Width := 100;
  QtdeMuralhaResult.Caption := QtdeMuralha.Text;
  QtdeMuralhaResult.FontName := TPRFontName.fnTimesRoman;

  QtdeBarraResult.Parent := Layout;
  QtdeBarraResult.Top := 680;
  QtdeBarraResult.Left := 564;
  QtdeBarraResult.Width := 100;
  QtdeBarraResult.Caption := QtdeBarra.Text;
  QtdeBarraResult.FontName := TPRFontName.fnTimesRoman;

  QtdeProtocoloResult.Parent := Layout;
  QtdeProtocoloResult.Top := 698;
  QtdeProtocoloResult.Left := 564;
  QtdeProtocoloResult.Width := 100;
  QtdeProtocoloResult.Caption := QtdeProtocolo.Text;
  QtdeProtocoloResult.FontName := TPRFontName.fnTimesRoman;

  QtdeBaseProvaResult.Parent := Layout;
  QtdeBaseProvaResult.Top := 716;
  QtdeBaseProvaResult.Left := 564;
  QtdeBaseProvaResult.Width := 100;
  QtdeBaseProvaResult.Caption := QtdeBase.Text;
  QtdeBaseProvaResult.FontName := TPRFontName.fnTimesRoman;


  QtdeOutrosLabel.Parent := Layout;
  QtdeOutrosLabel.Top := 734;
  QtdeOutrosLabel.Left := 14;
  QtdeOutrosLabel.Width := 100;
  QtdeOutrosLabel.Caption := DescOutros.Text;
  QtdeOutrosLabel.FontName := TPRFontName.fnTimesRoman;

  QtdeOutrosResult.Parent := Layout;
  QtdeOutrosResult.Top := 734;
  QtdeOutrosResult.Left := 114;
  QtdeOutrosResult.Width := 100;
  QtdeOutrosResult.Caption := QtdeOutros.Text;
  QtdeOutrosResult.FontName := TPRFontName.fnTimesRoman;


//  QtdeOutrosLabel := TPRLabel.Create(nil);
//  QtdeOutrosDesc := TPRLabel.Create(nil);
//  QtdeOutrosResult := TPRLabel.Create(nil);


//      object QtdeOutros: TEdit
//        Left = 16
//        Top = 219
//        Width = 50
//        Height = 25
//        Constraints.MaxHeight = 25
//        Constraints.MaxWidth = 50
//        Constraints.MinHeight = 25
//        Constraints.MinWidth = 50
//        TabOrder = 4
//      end
//      object DescOutros: TEdit
//        Left = 124
//        Top = 219
//        Width = 624
//        Height = 31
//        TabOrder = 5
//      end

  PReport1.FileName := 'formulario_lab.pdf';
  PReport1.BeginDoc;
  PReport1.Print(Pagina1);
  PReport1.EndDoc;

end;

end.
