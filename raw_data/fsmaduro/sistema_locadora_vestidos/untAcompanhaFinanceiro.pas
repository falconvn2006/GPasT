unit untAcompanhaFinanceiro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  dxGDIPlusClasses, ExtCtrls, IBCustomDataSet, IBQuery, RxLookup, StdCtrls,
  wwdbdatetimepicker, Menus, cxLookAndFeelPainters, cxButtons, cxCheckBox,
  cxGridExportLink, ShellAPI, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd,
  dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns,
  dxPSCore, dxPScxCommon, dxPScxGrid6Lnk, DBCtrls, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxContainer,
  cxGroupBox, untdados;

type
  TfrmAcompanhaFinanceiro = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Label27: TLabel;
    cbPerfil: TRxDBLookupCombo;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    Label38: TLabel;
    edtDtInicial: TwwDBDateTimePicker;
    Label1: TLabel;
    edtDtFinal: TwwDBDateTimePicker;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    qryFinanceiro: TIBQuery;
    dtsFinanceiro: TDataSource;
    SaveDialog2: TSaveDialog;
    dxCompPrinterGrid: TdxComponentPrinter;
    Panel3: TPanel;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    Panel4: TPanel;
    cxButton6: TcxButton;
    cxButton4: TcxButton;
    Panel6: TPanel;
    DBText1: TDBText;
    Panel5: TPanel;
    rgTipo: TRadioGroup;
    qryFinanceiroCODIGO: TIntegerField;
    qryFinanceiroDATAEMISSAO: TDateField;
    qryFinanceiroCODIGOCLIENTE: TIntegerField;
    qryFinanceiroNOMECLIENTE: TIBStringField;
    qryFinanceiroCODIGOFORMAPAGAMENTO: TIntegerField;
    qryFinanceiroNOMEFORMAPGAMENTO: TIBStringField;
    qryFinanceiroTIPO: TIntegerField;
    qryFinanceiroNOMETIPO: TIBStringField;
    qryFinanceiroOBSERVACOES: TIBStringField;
    qryFinanceiroCODIGOUSUARIO: TIntegerField;
    qryFinanceiroUSERNAME: TIBStringField;
    qryFinanceiroVALOR: TIBBCDField;
    qryFinanceiroPARCELA: TIntegerField;
    qryFinanceiroCODIGOSITUACAO: TIntegerField;
    qryFinanceiroNOMESITUACAO: TIBStringField;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1DATAEMISSAO: TcxGridDBColumn;
    grdPainelDBTableView1NOMECLIENTE: TcxGridDBColumn;
    grdPainelDBTableView1NOMETIPO: TcxGridDBColumn;
    grdPainelDBTableView1USERNAME: TcxGridDBColumn;
    grdPainelDBTableView1VALOR: TcxGridDBColumn;
    grdPainelDBTableView1PARCELA: TcxGridDBColumn;
    grdPainelDBTableView1NOMESITUACAO: TcxGridDBColumn;
    qryFinanceiroDATAVENCIMENTO: TDateField;
    qryFinanceiroDATAPAGAMENTO: TDateField;
    qryFinanceiroCODIGOCONTRATO: TIntegerField;
    grdPainelDBTableView1Column1: TcxGridDBColumn;
    grdPainelDBTableView1Column2: TcxGridDBColumn;
    grdPainelDBTableView1Column3: TcxGridDBColumn;
    qryFinanceiroCPF: TIBStringField;
    qryFinanceiroDATACONTRATO: TDateField;
    qryFinanceiroQTDPRODUTOS: TIntegerField;
    grdPainelDBTableView1Column4: TcxGridDBColumn;
    grdPainelDBTableView1Column5: TcxGridDBColumn;
    grdPainelDBTableView1Column6: TcxGridDBColumn;
    grdPainelDBTableView1Column7: TcxGridDBColumn;
    qryPaineis: TIBQuery;
    qryPaineisCODIGO: TIntegerField;
    qryPaineisDATA: TDateField;
    qryPaineisNOMERELATORIO: TIBStringField;
    qryPaineisNOMEARQUIVO: TIBStringField;
    qryPaineisDETALHEARQUIVO: TBlobField;
    qryPaineisTELA: TIBStringField;
    qryPaineisCOMPONENTE: TIBStringField;
    dtsPaineis: TDataSource;
    cxGroupBox1: TcxGroupBox;
    cmbRelatorio1: TcxLookupComboBox;
    btnCriar1: TcxButton;
    btnExcluir1: TcxButton;
    qryFinanceiroNUMEROPARCELA: TIBStringField;
    qryFinanceiroCODIGOTIPODOCUMENTO: TIntegerField;
    qryFinanceiroNOMETIPODOCUMENTO: TIBStringField;
    grdPainelDBTableView1Column9: TcxGridDBColumn;
    rgData: TRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryFinanceiroBeforeOpen(DataSet: TDataSet);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure btnCriar1Click(Sender: TObject);
    procedure btnExcluir1Click(Sender: TObject);
    procedure cmbRelatorio1Exit(Sender: TObject);
    procedure qryPaineisBeforeOpen(DataSet: TDataSet);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure FormCreate(Sender: TObject); // e esta tb
    //FIM BOTÃO HELP
  private
    function Filtro(): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAcompanhaFinanceiro: TfrmAcompanhaFinanceiro;

implementation

uses form_cadastro_pedido_agenda, untConsultaProdutos, versao,
  untAgendarPedido, untAcompanhaPedidoAgenda, untOrcamento, untContrato,
  untDtmRelatorios, Funcao, untContratoTerceiros, untFinanceiro;

const
   NomeMenu = 'Financeiro2';
   cCaption = 'ACOMPANHAMENTO DE FINANCEIRO';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAcompanhaFinanceiro.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAcompanhaFinanceiro.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAcompanhaFinanceiro.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmAcompanhaFinanceiro.FormCreate(Sender: TObject);
begin
  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAcompanhaFinanceiro.btnCriar1Click(Sender: TObject);
begin
  Dados.CriarModeloPainel('frmAcompanhaFinanceiro',grdPainelDBTableView1);

  qryPaineis.Close;
  qryPaineis.Open;
end;

procedure TfrmAcompanhaFinanceiro.btnExcluir1Click(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cmbRelatorio1.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaFinanceiro.cmbRelatorio1Exit(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
    Dados.SelecionarModeloPainel(grdPainelDBTableView1,cmbRelatorio1.EditValue);
end;

procedure TfrmAcompanhaFinanceiro.Configuraes1Click(Sender: TObject);
begin
 dados.ShowConfig(frmAcompanhaFinanceiro);
end;

procedure TfrmAcompanhaFinanceiro.cxButton1Click(Sender: TObject);
begin
  qryFinanceiro.Close;
  qryFinanceiro.Open;
end;

procedure TfrmAcompanhaFinanceiro.cxButton2Click(Sender: TObject);
begin
  ImprimirGrid(grdPainel,'Painel de Financeiro'+iif(cmbRelatorio1.EditValue > 0,' - '+cmbRelatorio1.Text,''));
end;

procedure TfrmAcompanhaFinanceiro.cxButton3Click(Sender: TObject);
begin
  ExportarGrid(grdPainel);
end;

procedure TfrmAcompanhaFinanceiro.cxButton4Click(Sender: TObject);
begin
  If Application.FindComponent('frmFinanceiro') = Nil then
         Application.CreateForm(TfrmFinanceiro, frmFinanceiro);

  frmFinanceiro.Show;

  frmFinanceiro.qryFinanceiro.Locate('CODIGO',qryFinanceiroCODIGO.AsInteger,[]);
end;

procedure TfrmAcompanhaFinanceiro.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcompanhaFinanceiro.cxButton6Click(Sender: TObject);
begin
  If Application.FindComponent('frmFinanceiro') = Nil then
         Application.CreateForm(TfrmFinanceiro, frmFinanceiro);

  frmFinanceiro.cInserindo := True;

  frmFinanceiro.ShowModal;
end;

function TfrmAcompanhaFinanceiro.Filtro(): String;
var
  vFiltro : String;
  vCampoData : String;
begin
  if cbPerfil.KeyValue > 0 then
    vFiltro := vFiltro + ' and f.codigocliente = '+VarToStr(cbPerfil.KeyValue);

  Case rgData.ItemIndex of
    0: vCampoData := 'F.DATAEMISSAO';
    1: vCampoData := 'D.DATAVENCIMENTO';
    2: vCampoData := 'D.DATAPAGAMENTO';
  End;

  if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
    vFiltro := vFiltro + ' and '+vCampoData+' between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and '+vCampoData+' >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and '+vCampoData+' <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date));

  if rgTipo.ItemIndex = 0 then
    vFiltro := vFiltro + ' and f.tipo = 1 '
  else
    vFiltro := vFiltro + ' and f.tipo = 2 ';

  result := vFiltro;
end;

procedure TfrmAcompanhaFinanceiro.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryPerfil.Close;
    qryPerfil.Open;

    qryPaineis.Close;
    qryPaineis.Open;
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmAcompanhaFinanceiro.qryFinanceiroBeforeOpen(DataSet: TDataSet);
begin
  qryFinanceiro.SQL.Strings[qryFinanceiro.SQL.IndexOf('--and')+1] := Filtro();
end;

procedure TfrmAcompanhaFinanceiro.qryPaineisBeforeOpen(DataSet: TDataSet);
begin
  qryPaineis.ParamByName('TELA').Value := 'frmAcompanhaFinanceiro';
  qryPaineis.ParamByName('COMPONENTE').Value := grdPainelDBTableView1.Name;
end;

end.
