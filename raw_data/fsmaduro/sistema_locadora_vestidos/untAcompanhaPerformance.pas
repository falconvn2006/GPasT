unit untAcompanhaPerformance;

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
  dxPSCore, dxPScxCommon, dxPScxGrid6Lnk, DBCtrls, cxPC, cxContainer,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, DBTables, rxMemTable,
  cxGridBandedTableView, cxGridDBBandedTableView, rxPlacemnt, TeEngine, Series,
  TeeProcs, Chart, PivotChart_SRC, TeeDBEdit, TeeDBCrossTab, cxSplitter,
  cxGroupBox, cxRadioGroup, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompDynamicChart, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxDBExtLookupComboBox, Mask, untdados;

type
  TfrmAcompanhaPerformance = class(TForm)
    Panel2: TPanel;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    qryComparativoReceita: TIBQuery;
    dtsComparativoReceita: TDataSource;
    SaveDialog2: TSaveDialog;
    Panel3: TPanel;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    grdPainel: TcxGrid;
    grdPainelLevel1: TcxGridLevel;
    Panel1: TPanel;
    Image1: TImage;
    cxButton1: TcxButton;
    Label1: TLabel;
    Label2: TLabel;
    cmbAnoFim: TcxComboBox;
    dtsTblComparativoReceita: TDataSource;
    tblComparativoReceita: TMemoryTable;
    grdPainelDBBandedTableView1: TcxGridDBBandedTableView;
    cmbAnoInicio: TcxComboBox;
    FormStorage1: TFormStorage;
    Panel4: TPanel;
    GraficoComparativo: TPivotChart;
    cxSplitter1: TcxSplitter;
    rdgGrafico: TcxRadioGroup;
    cxTabSheet2: TcxTabSheet;
    Panel5: TPanel;
    Image2: TImage;
    cxButton4: TcxButton;
    cxGrid1: TcxGrid;
    cxGridLevel1: TcxGridLevel;
    Panel6: TPanel;
    cxSplitter2: TcxSplitter;
    cxGrid1DBTableView1: TcxGridDBTableView;
    dtsReceitaProduto: TDataSource;
    qryReceitaProduto: TIBQuery;
    Label38: TLabel;
    edtDtInicial: TwwDBDateTimePicker;
    edtDtFinal: TwwDBDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    qryReceitaProdutoCODIGOPRODUTO: TIntegerField;
    qryReceitaProdutoDESCRICAO: TIBStringField;
    qryReceitaProdutoREFERENCIA: TIBStringField;
    qryReceitaProdutoDATAAQUISICAO: TDateField;
    qryReceitaProdutoVIDAUTIL: TIntegerField;
    qryReceitaProdutoSITUACAO: TIBStringField;
    qryReceitaProdutoVALORCUSTO: TIBBCDField;
    qryReceitaProdutoVALORTOTAL: TIBBCDField;
    qryReceitaProdutoMEDIAVALOR: TIBBCDField;
    qryReceitaProdutoQTD: TIntegerField;
    qryReceitaProdutoRECEITA: TIBBCDField;
    cxGrid1DBTableView1CODIGOPRODUTO: TcxGridDBColumn;
    cxGrid1DBTableView1DESCRICAO: TcxGridDBColumn;
    cxGrid1DBTableView1REFERENCIA: TcxGridDBColumn;
    cxGrid1DBTableView1DATAAQUISICAO: TcxGridDBColumn;
    cxGrid1DBTableView1VIDAUTIL: TcxGridDBColumn;
    cxGrid1DBTableView1SITUACAO: TcxGridDBColumn;
    cxGrid1DBTableView1VALORCUSTO: TcxGridDBColumn;
    cxGrid1DBTableView1VALORTOTAL: TcxGridDBColumn;
    cxGrid1DBTableView1MEDIAVALOR: TcxGridDBColumn;
    cxGrid1DBTableView1QTD: TcxGridDBColumn;
    cxGrid1DBTableView1RECEITA: TcxGridDBColumn;
    dtsProduto: TDataSource;
    qryProduto: TIBQuery;
    IntegerField1: TIntegerField;
    IBStringField1: TIBStringField;
    qryReceitaProdutoGrafico: TIBQuery;
    dtsReceitaProdutoGrafico: TDataSource;
    qryReceitaProdutoGraficoTIPO: TIBStringField;
    qryReceitaProdutoGraficoQTD: TIntegerField;
    PivotChart1: TPivotChart;
    serReceitaProduto: TPieSeries;
    cxTabSheet3: TcxTabSheet;
    Panel7: TPanel;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    cxButton6: TcxButton;
    edtDtInicial2: TwwDBDateTimePicker;
    edtDtFinal2: TwwDBDateTimePicker;
    Label27: TLabel;
    cxGrid2: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    qryReceitaPerfil: TIBQuery;
    dtsReceitaPerfil: TDataSource;
    Panel8: TPanel;
    PivotChart2: TPivotChart;
    serFaixaEtaria: TPieSeries;
    qryReceitaPerfilGrafico: TIBQuery;
    dtsReceitaPerfilGrafico: TDataSource;
    qryReceitaPerfilGraficoVALORTOTAL: TIBBCDField;
    qryReceitaPerfilGraficoMEDIAVALOR: TIBBCDField;
    qryReceitaPerfilGraficoQTD: TLargeintField;
    cxSplitter3: TcxSplitter;
    qryReceitaPerfilGraficoFAIXA: TIBStringField;
    cbProduto: TcxLookupComboBox;
    cbPerfil: TcxLookupComboBox;
    edtProduto: TcxTextEdit;
    edtPerfil: TcxTextEdit;
    qryReceitaProdutoTIPOPECA: TIBStringField;
    qryReceitaProdutoORIGEM: TIBStringField;
    qryReceitaProdutoTAMANHO: TIBBCDField;
    qryReceitaProdutoSALDOVIDAUTIL: TLargeintField;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxGrid1DBTableView1Column2: TcxGridDBColumn;
    cxGrid1DBTableView1Column3: TcxGridDBColumn;
    cxGrid1DBTableView1Column4: TcxGridDBColumn;
    cxTabSheet4: TcxTabSheet;
    Panel9: TPanel;
    Image4: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    cxButton7: TcxButton;
    edtDtInicial3: TwwDBDateTimePicker;
    edtDtFinal3: TwwDBDateTimePicker;
    cbPerfil3: TcxLookupComboBox;
    edtPerfil3: TcxTextEdit;
    cxGrid3: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel3: TcxGridLevel;
    dtsPedidoAgenda: TDataSource;
    qryPedidoAgenda: TIBQuery;
    Panel10: TPanel;
    PivotChart3: TPivotChart;
    serPedidoAgenda: TPieSeries;
    cxSplitter4: TcxSplitter;
    cxTabSheet5: TcxTabSheet;
    Panel11: TPanel;
    cxButton8: TcxButton;
    cxGrid4: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    dtsTerceiros: TDataSource;
    qryTerceiros: TIBQuery;
    cxGridDBTableView3CODIGO: TcxGridDBColumn;
    cxGridDBTableView3NOME: TcxGridDBColumn;
    cxGridDBTableView3CODIGOPRODUTO: TcxGridDBColumn;
    cxGridDBTableView3DESCRICAO: TcxGridDBColumn;
    cxGridDBTableView3QTD: TcxGridDBColumn;
    cxGridDBTableView3VALORTOTAL: TcxGridDBColumn;
    cxGridDBTableView3VALORMEDIO: TcxGridDBColumn;
    qryPedidoAgendaTAMANHO: TLargeintField;
    qryPedidoAgendaQTDPEDIDOAGENDA: TIntegerField;
    qryPedidoAgendaQTDAGENDA: TLargeintField;
    qryPedidoAgendaALUGADO: TIntegerField;
    cxGridDBTableView2TAMANHO: TcxGridDBColumn;
    cxGridDBTableView2QTDPEDIDOAGENDA: TcxGridDBColumn;
    cxGridDBTableView2QTDAGENDA: TcxGridDBColumn;
    cxGridDBTableView2ALUGADO: TcxGridDBColumn;
    cxGridDBTableView3Column1: TcxGridDBColumn;
    cxGridDBTableView3Column2: TcxGridDBColumn;
    cxGridDBTableView3Column3: TcxGridDBColumn;
    chbAcumulado: TcxCheckBox;
    cxGridDBTableView1CODIGO: TcxGridDBColumn;
    cxGridDBTableView1NOME: TcxGridDBColumn;
    cxGridDBTableView1CPF: TcxGridDBColumn;
    cxGridDBTableView1SITUACAO: TcxGridDBColumn;
    cxGridDBTableView1VALORTOTAL: TcxGridDBColumn;
    cxGridDBTableView1MEDIAVALOR: TcxGridDBColumn;
    cxGridDBTableView1QTD: TcxGridDBColumn;
    cxGridDBTableView1IDADE: TcxGridDBColumn;
    cxGridDBTableView1QTDPRODUTOS: TcxGridDBColumn;
    cxGridDBTableView1QTDAGENDAS: TcxGridDBColumn;
    cxGridDBTableView1QTDPECAS: TcxGridDBColumn;
    cxGridDBTableView1QTDACESSORIOS: TcxGridDBColumn;
    cxGridDBTableView1VALORMEDIOPECAS: TcxGridDBColumn;
    cxGridDBTableView1VALORMEDIOACESSORIOS: TcxGridDBColumn;
    cxGridDBTableView1PERFOMANCE: TcxGridDBColumn;
    cxGridDBTableView1Column1: TcxGridDBColumn;
    cxGridDBTableView1Column2: TcxGridDBColumn;
    cxGroupBox1: TcxGroupBox;
    cmbRelatorio1: TcxLookupComboBox;
    dtsPaineis: TDataSource;
    qryPaineis: TIBQuery;
    qryPaineisCODIGO: TIntegerField;
    qryPaineisDATA: TDateField;
    qryPaineisNOMERELATORIO: TIBStringField;
    qryPaineisNOMEARQUIVO: TIBStringField;
    qryPaineisDETALHEARQUIVO: TBlobField;
    qryPaineisTELA: TIBStringField;
    qryPaineisCOMPONENTE: TIBStringField;
    btnCriar1: TcxButton;
    btnExcluir1: TcxButton;
    Image5: TImage;
    cxGroupBox2: TcxGroupBox;
    cxLookupComboBox1: TcxLookupComboBox;
    cxButton9: TcxButton;
    cxButton10: TcxButton;
    cxGroupBox3: TcxGroupBox;
    cxLookupComboBox2: TcxLookupComboBox;
    cxButton11: TcxButton;
    cxButton12: TcxButton;
    cxGroupBox4: TcxGroupBox;
    cxLookupComboBox3: TcxLookupComboBox;
    cxButton13: TcxButton;
    cxButton14: TcxButton;
    qryReceitaProdutoDESC_ACRES: TFloatField;
    qryReceitaProdutoVALORTOTAL_CD: TFloatField;
    cxGrid1DBTableView1DESC_ACRES: TcxGridDBColumn;
    cxGrid1DBTableView1VALORTOTAL_CD: TcxGridDBColumn;
    qryComparativoReceitaANO: TSmallintField;
    qryComparativoReceitaMES: TSmallintField;
    qryComparativoReceitaQTDAGENDA: TLargeintField;
    qryComparativoReceitaQTDCONTRATOS: TLargeintField;
    qryComparativoReceitaVALORTOTAL: TFloatField;
    qryComparativoReceitaMEDIAVALORCONTRATO: TFloatField;
    qryComparativoReceitaQTDPRODUTOSCONTRATO: TLargeintField;
    qryComparativoReceitaQTDMEDIAPRODCONTRATOS: TLargeintField;
    qryComparativoReceitaMEDIAVALORPRODUTO: TFloatField;
    qryComparativoReceitaQTDPECAS: TLargeintField;
    qryComparativoReceitaVALORPECAS: TIBBCDField;
    qryComparativoReceitaMEDIAVALORPECAS: TIBBCDField;
    qryComparativoReceitaQTDACESSORIOS: TLargeintField;
    qryComparativoReceitaVALORACESSORIOS: TIBBCDField;
    qryComparativoReceitaMEDIAVALORACESSORIOS: TIBBCDField;
    qryReceitaPerfilCODIGO: TIntegerField;
    qryReceitaPerfilNOME: TIBStringField;
    qryReceitaPerfilCPF: TIBStringField;
    qryReceitaPerfilSITUACAO: TIBStringField;
    qryReceitaPerfilIDADE: TLargeintField;
    qryReceitaPerfilVALORTOTAL: TFloatField;
    qryReceitaPerfilQTD: TIntegerField;
    qryReceitaPerfilQTDPRODUTOS: TIntegerField;
    qryReceitaPerfilQTDPECAS: TLargeintField;
    qryReceitaPerfilQTDACESSORIOS: TLargeintField;
    qryReceitaPerfilVALORPECAS: TFloatField;
    qryReceitaPerfilVALORACESSORIOS: TFloatField;
    qryReceitaPerfilQTDAGENDAS: TIntegerField;
    qryReceitaPerfilMEDIAVALOR: TFloatField;
    qryReceitaPerfilVALORMEDIOPECAS: TFloatField;
    qryReceitaPerfilVALORMEDIOACESSORIOS: TFloatField;
    qryReceitaPerfilPERFOMANCE: TIBBCDField;
    qryReceitaPerfilVALORMEDIOPRODUTOS: TFloatField;
    qryReceitaPerfilQTDMEDIAPRODUTOS: TLargeintField;
    qryTerceirosCODIGOCONTRATO: TIntegerField;
    qryTerceirosDATACADASTRO: TDateField;
    qryTerceirosSITUACAO: TIBStringField;
    qryTerceirosCODIGO: TIntegerField;
    qryTerceirosNOME: TIBStringField;
    qryTerceirosCODIGOPRODUTO: TIntegerField;
    qryTerceirosDESCRICAO: TIBStringField;
    qryTerceirosQTD: TIntegerField;
    qryTerceirosVALORTOTAL: TFloatField;
    qryTerceirosVALORMEDIO: TIBBCDField;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryComparativoReceitaBeforeOpen(DataSet: TDataSet);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure qryReceitaProdutoBeforeOpen(DataSet: TDataSet);
    procedure cxButton4Click(Sender: TObject);
    procedure qryReceitaProdutoGraficoBeforeOpen(DataSet: TDataSet);
    procedure cxButton6Click(Sender: TObject);
    procedure qryReceitaPerfilBeforeOpen(DataSet: TDataSet);
    procedure qryReceitaPerfilGraficoBeforeOpen(DataSet: TDataSet);
    procedure edtProdutoExit(Sender: TObject);
    procedure cbProdutoExit(Sender: TObject);
    procedure edtPerfilExit(Sender: TObject);
    procedure cbPerfilExit(Sender: TObject);
    procedure qryPedidoAgendaBeforeOpen(DataSet: TDataSet);
    procedure cxButton7Click(Sender: TObject);
    procedure edtPerfil3Exit(Sender: TObject);
    procedure cbPerfil3Exit(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure qryComparativoReceitaAfterOpen(DataSet: TDataSet);
    procedure btnCriar1Click(Sender: TObject);
    procedure cmbRelatorio1Exit(Sender: TObject);
    procedure qryPaineisBeforeOpen(DataSet: TDataSet);
    procedure cxPageControl1Change(Sender: TObject);
    procedure btnExcluir1Click(Sender: TObject);
    procedure cxButton10Click(Sender: TObject);
    procedure cxButton12Click(Sender: TObject);
    procedure cxButton14Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    function Filtro(): String;
    function Filtro2: String;
    function Filtro3: String;
    function Filtro4: String;
    { Private declarations }
  public
    { Public declarations }
  cQtdProdutos, cQtdPecas, cQtdAcessorios : Integer;
  cxGrid1DBTableViewAux: TcxGridDBTableView;
  end;

var
  frmAcompanhaPerformance: TfrmAcompanhaPerformance;

implementation

uses form_cadastro_pedido_agenda, untConsultaProdutos,
  untAgendarPedido, untAcompanhaPedidoAgenda, untOrcamento, untContrato,
  untDtmRelatorios, Funcao, untContratoTerceiros, versao;

const NomeMenu = 'AcompanhamentodePerformance1';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAcompanhaPerformance.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAcompanhaPerformance.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAcompanhaPerformance.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmAcompanhaPerformance.edtPerfil3Exit(Sender: TObject);
begin
  try
    if cbPerfil3.Text <> '' then
      cbPerfil3.EditValue := StrToInt(edtPerfil3.Text)
    else
      cbPerfil3.EditValue := Null;
  except
  end;
end;

procedure TfrmAcompanhaPerformance.btnExcluir1Click(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cmbRelatorio1.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaPerformance.cbPerfil3Exit(Sender: TObject);
begin
  if (Trim(cbPerfil3.Text) <> '') and (cbPerfil3.EditValue > 0) then
    edtPerfil3.Text := VarToStr(cbPerfil3.EditValue)
  else
    edtPerfil3.Text := '';
end;

procedure TfrmAcompanhaPerformance.cbPerfilExit(Sender: TObject);
begin
  if (Trim(cbPerfil.Text) <> '') and (cbPerfil.EditValue > 0) then
    edtPerfil.Text := VarToStr(cbPerfil.EditValue)
  else
    edtPerfil.Text := '';
end;

procedure TfrmAcompanhaPerformance.cbProdutoExit(Sender: TObject);
begin
  if (Trim(cbProduto.Text) <> '') and (cbProduto.EditValue > 0) then
    edtProduto.Text := VarToStr(cbProduto.EditValue)
  else
    edtProduto.Text := '';
end;

procedure TfrmAcompanhaPerformance.cmbRelatorio1Exit(Sender: TObject);
begin

  if cxPageControl1.ActivePage = cxTabSheet2 then
    cxGrid1DBTableViewAux := cxGrid1DBTableView1
  else
  if cxPageControl1.ActivePage = cxTabSheet3 then
    cxGrid1DBTableViewAux := cxGridDBTableView1
  else
  if cxPageControl1.ActivePage = cxTabSheet4 then
    cxGrid1DBTableViewAux := cxGridDBTableView2
  else
  if cxPageControl1.ActivePage = cxTabSheet5 then
    cxGrid1DBTableViewAux := cxGridDBTableView3;

  if (Sender as TcxLookupCombobox).EditValue > 0 then
    Dados.SelecionarModeloPainel(cxGrid1DBTableViewAux,(Sender as TcxLookupCombobox).EditValue);
end;

procedure TfrmAcompanhaPerformance.Configuraes1Click(Sender: TObject);
begin
 dados.ShowConfig(frmAcompanhaPerformance);
end;

procedure TfrmAcompanhaPerformance.cxButton10Click(Sender: TObject);
begin
  if cxLookupComboBox1.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cxLookupComboBox1.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaPerformance.cxButton12Click(Sender: TObject);
begin
  if cxLookupComboBox2.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cxLookupComboBox2.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaPerformance.cxButton14Click(Sender: TObject);
begin
  if cxLookupComboBox3.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cxLookupComboBox3.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaPerformance.cxButton1Click(Sender: TObject);
 var
   QtdAnos, AnoAtual: Integer;
   NomeCampo : String;

 procedure CriarTabelaMemoria;
 var
    i, cont, cAno: Integer;
 begin

   cAno := cmbAnoInicio.EditValue;

   tblComparativoReceita.close;
   tblComparativoReceita.EmptyTable;
   tblComparativoReceita.FieldDefs.Clear;


   tblComparativoReceita.FieldDefs.Add('MES',ftString,50,false);

   for i:=1 to QtdAnos do
   begin

     if not chbAcumulado.Checked  then
       NomeCampo := '_'+intToStr(cAno)
     else
       NomeCampo := '_Acumulado';

     tblComparativoReceita.FieldDefs.Add('ANO'+NomeCampo,ftString,50,false);

     //Valor totas dos contratos
     tblComparativoReceita.FieldDefs.Add('VALORTOTAL'+NomeCampo,ftCurrency,0,false);

     //Valor acumulado até o mês
     tblComparativoReceita.FieldDefs.Add('VALORACUMULADO'+NomeCampo,ftCurrency,0,false);

     //Valor médio por dia corrido
     tblComparativoReceita.FieldDefs.Add('MEDIADIAOCORRIDO'+NomeCampo,ftCurrency,0,false);

     //Valor médio por dia útil
     tblComparativoReceita.FieldDefs.Add('MEDIADIAUTIL'+NomeCampo,ftCurrency,0,false);

     // Quantidade de aluguéis
     tblComparativoReceita.FieldDefs.Add('QTDALUGUEL'+NomeCampo,ftInteger,0,false);

     // Quantidade de Agenda
     tblComparativoReceita.FieldDefs.Add('QTDAGENDA'+NomeCampo,ftInteger,0,false);

     //Valor médio de contrato
     tblComparativoReceita.FieldDefs.Add('MEDIACONTRATO'+NomeCampo,ftCurrency,0,false);

     //Quantidade de peças alugadas
     tblComparativoReceita.FieldDefs.Add('QTDPECASALUG'+NomeCampo,ftInteger,0,false);

     //Valor médio das peças alugadas
     tblComparativoReceita.FieldDefs.Add('MEDIAPECAALUG'+NomeCampo,ftCurrency,0,false);

     //Quantidade de acessórios alugados
     tblComparativoReceita.FieldDefs.Add('QTDACESSALUG'+NomeCampo,ftInteger,0,false);

     //Valor médio dos acessórios alugados
     tblComparativoReceita.FieldDefs.Add('MEDIAACESSALUG'+NomeCampo,ftCurrency,0,false);

     //Quantidade todal de prdutos alugados
     tblComparativoReceita.FieldDefs.Add('QTDPRODALUG'+NomeCampo,ftInteger,0,false);

     //Valor médio dos produtos alugados
     tblComparativoReceita.FieldDefs.Add('MEDIAPRODALUG'+NomeCampo,ftCurrency,0,false);

     //Quantidade média de produtos por contrato
     tblComparativoReceita.FieldDefs.Add('MEDIAQTDPRODCONTR'+NomeCampo,ftInteger,0,false);

     // % = Qtd. Acessórios alugados/Qtd. Total Acessórios
     tblComparativoReceita.FieldDefs.Add('GIROACESS'+NomeCampo,ftCurrency,0,false);

     // % = Qtd. Peças alugadas/Qtd. Total Peças
     tblComparativoReceita.FieldDefs.Add('GIROPECA'+NomeCampo,ftCurrency,0,false);

     // % = Qtd. Prod. alugados/Qtd. Total Produtos
     tblComparativoReceita.FieldDefs.Add('GIROPRODUTO'+NomeCampo,ftCurrency,0,false);

     // % = QTDALUGUEL/QTDAGENDA
     tblComparativoReceita.FieldDefs.Add('PERFOMANCE'+NomeCampo,ftCurrency,0,false);

     inc(cAno);
     
   end;


   cAno := cmbAnoInicio.EditValue;

   tblComparativoReceita.Open;

   for i:=1 to QtdAnos do
   begin

     if not chbAcumulado.Checked  then
       NomeCampo := '_'+intToStr(cAno)
     else
       NomeCampo := '_Acumulado';

     tblComparativoReceita.fieldbyname('ANO'+NomeCampo).Visible := False;


     tblComparativoReceita.fieldbyname('MES').DisplayLabel  := 'Mês';

     tblComparativoReceita.fieldbyname('VALORTOTAL'+NomeCampo).DisplayLabel  := 'Vl. Total';
     TFloatField(tblComparativoReceita.fieldbyname('VALORTOTAL'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('VALORACUMULADO'+NomeCampo).DisplayLabel  := 'Vl. Acumul.';
     TFloatField(tblComparativoReceita.fieldbyname('VALORACUMULADO'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('MEDIACONTRATO'+NomeCampo).DisplayLabel  := 'Méd. Contr.';
     TFloatField(tblComparativoReceita.fieldbyname('MEDIACONTRATO'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('MEDIADIAOCORRIDO'+NomeCampo).DisplayLabel  := 'Méd. Dia Corr.';
     TFloatField(tblComparativoReceita.fieldbyname('MEDIADIAOCORRIDO'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('MEDIADIAUTIL'+NomeCampo).DisplayLabel  := 'Méd. Dia. Útil';
     TFloatField(tblComparativoReceita.fieldbyname('MEDIADIAUTIL'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('MEDIAQTDPRODCONTR'+NomeCampo).DisplayLabel  := 'Qtd. Méd. Prod.';

     tblComparativoReceita.fieldbyname('QTDPRODALUG'+NomeCampo).DisplayLabel  := 'Qtd. Prod. Alug.';

     tblComparativoReceita.fieldbyname('MEDIAPRODALUG'+NomeCampo).DisplayLabel  := 'Méd. Prod. Alug.';
     TFloatField(tblComparativoReceita.fieldbyname('MEDIAPRODALUG'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('QTDPECASALUG'+NomeCampo).DisplayLabel  := 'Qtd. Peç. Alug.';

     tblComparativoReceita.fieldbyname('MEDIAPECAALUG'+NomeCampo).DisplayLabel  := 'Méd. Peç. Alug.';
     TFloatField(tblComparativoReceita.fieldbyname('MEDIAPECAALUG'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('QTDACESSALUG'+NomeCampo).DisplayLabel  := 'Qtd. Aces. Alug.';

     tblComparativoReceita.fieldbyname('MEDIAACESSALUG'+NomeCampo).DisplayLabel  := 'Méd. Aces. Alug.';
     TFloatField(tblComparativoReceita.fieldbyname('MEDIAACESSALUG'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('GIROPRODUTO'+NomeCampo).DisplayLabel  := '% Giro Prod.';
     TFloatField(tblComparativoReceita.fieldbyname('GIROPRODUTO'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('GIROPECA'+NomeCampo).DisplayLabel  := '% Giro Peça';
     TFloatField(tblComparativoReceita.fieldbyname('GIROPECA'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('GIROACESS'+NomeCampo).DisplayLabel  := '% Giro Acess.';
     TFloatField(tblComparativoReceita.fieldbyname('GIROACESS'+NomeCampo)).DisplayFormat := '#,##0.00';

     tblComparativoReceita.fieldbyname('QTDALUGUEL'+NomeCampo).DisplayLabel  := 'Qtd. Alug.';

     tblComparativoReceita.fieldbyname('QTDAGENDA'+NomeCampo).DisplayLabel  := 'Qtd. Agend.';

     tblComparativoReceita.fieldbyname('PERFOMANCE'+NomeCampo).DisplayLabel  := '% Performance';
     TFloatField(tblComparativoReceita.fieldbyname('PERFOMANCE'+NomeCampo)).DisplayFormat := '#,##0.00';

     inc(cAno);
   end;


 end;

 procedure PopularTabelaMemoria;
 var
   i, cont, cAno, cQtdDiasUteis: Integer;
   NomeMesAno, cOldAno : String;
   cValorAcumulado, cValorAcumuladoTotal : Currency;

 begin



   for cont:= 1 to 12 do
   begin

     tblComparativoReceita.Insert;
     tblComparativoReceita.fieldbyname('MES').text := NomeMes(cont);
     tblComparativoReceita.post;

   end;

   cValorAcumulado := 0;
   cOldAno := '';

   While not qryComparativoReceita.Eof do
   begin

     if cOldAno <> qryComparativoReceitaANO.Text then
       cValorAcumulado := 0;

     NomeMesAno := NomeMes(qryComparativoReceitaMES.AsInteger);

     if not chbAcumulado.Checked  then
       NomeCampo := '_'+qryComparativoReceitaANO.Text
     else
       NomeCampo := '_Acumulado';

     if tblComparativoReceita.Locate('MES',NomeMesAno,[]) then
     begin

       try
         Dados.Geral.Close;
         Dados.Geral.SQL.Text := 'SELECT * '+
                                 '  FROM PRC_RETORNADIASUTEIS('+QuotedStr(FormatDateTime('mm/dd/yyyy',StrToDate('01/'+qryComparativoReceitaMES.Text+'/'+qryComparativoReceitaANO.Text)))+', '+
                                                                QuotedStr(FormatDateTime('mm/dd/yyyy',StrToDate(UltimoDiaMes('01/'+qryComparativoReceitaMES.Text+'/'+qryComparativoReceitaANO.Text))))+') ';
         Dados.Geral.Open;

         cQtdDiasUteis := Dados.Geral.FieldByName('QTD').AsInteger;
       except
         cQtdDiasUteis := 20;
       end;


       tblComparativoReceita.edit;
       tblComparativoReceita.fieldbyname('ANO'+NomeCampo).Text := qryComparativoReceitaANO.Text;
       tblComparativoReceita.fieldbyname('VALORTOTAL'+NomeCampo).AsCurrency := qryComparativoReceitaVALORTOTAL.AsCurrency;
       tblComparativoReceita.fieldbyname('VALORACUMULADO'+NomeCampo).AsCurrency := cValorAcumulado + qryComparativoReceitaVALORTOTAL.AsCurrency;
       tblComparativoReceita.fieldbyname('MEDIACONTRATO'+NomeCampo).AsCurrency := qryComparativoReceitaMEDIAVALORCONTRATO.AsCurrency;
       tblComparativoReceita.fieldbyname('MEDIADIAOCORRIDO'+NomeCampo).AsCurrency := qryComparativoReceitaVALORTOTAL.AsCurrency/MonthDays[IsLeapYear(qryComparativoReceitaANO.AsInteger),qryComparativoReceitaMES.AsInteger];
       tblComparativoReceita.fieldbyname('MEDIADIAUTIL'+NomeCampo).AsCurrency := qryComparativoReceitaVALORTOTAL.AsCurrency/cQtdDiasUteis;

       try
         tblComparativoReceita.fieldbyname('MEDIAQTDPRODCONTR'+NomeCampo).AsInteger := Trunc(qryComparativoReceitaQTDPRODUTOSCONTRATO.AsInteger/qryComparativoReceitaQTDCONTRATOS.AsInteger);
       except
         tblComparativoReceita.fieldbyname('MEDIAQTDPRODCONTR'+NomeCampo).AsInteger  := 0;
       end;
       
       tblComparativoReceita.fieldbyname('QTDALUGUEL'+NomeCampo).AsInteger := qryComparativoReceitaQTDCONTRATOS.AsInteger;
       tblComparativoReceita.fieldbyname('QTDAGENDA'+NomeCampo).AsInteger := qryComparativoReceitaQTDAGENDA.AsInteger;

       tblComparativoReceita.fieldbyname('QTDPRODALUG'+NomeCampo).AsInteger := qryComparativoReceitaQTDPRODUTOSCONTRATO.AsInteger;
       tblComparativoReceita.fieldbyname('MEDIAPRODALUG'+NomeCampo).AsCurrency := qryComparativoReceitaMEDIAVALORPRODUTO.AsCurrency;

       tblComparativoReceita.fieldbyname('QTDPECASALUG'+NomeCampo).AsInteger  := qryComparativoReceitaQTDPECAS.AsInteger;
       tblComparativoReceita.fieldbyname('MEDIAPECAALUG'+NomeCampo).AsCurrency := qryComparativoReceitaMEDIAVALORPECAS.AsCurrency;

       tblComparativoReceita.fieldbyname('QTDACESSALUG'+NomeCampo).AsInteger := qryComparativoReceitaQTDACESSORIOS.AsInteger;
       tblComparativoReceita.fieldbyname('MEDIAACESSALUG'+NomeCampo).AsCurrency := qryComparativoReceitaMEDIAVALORACESSORIOS.AsCurrency;

       tblComparativoReceita.fieldbyname('GIROPRODUTO'+NomeCampo).AsCurrency := qryComparativoReceitaQTDPRODUTOSCONTRATO.AsInteger/cQtdProdutos;
       tblComparativoReceita.fieldbyname('GIROPECA'+NomeCampo).AsCurrency := qryComparativoReceitaQTDPECAS.AsInteger/cQtdPecas;
       tblComparativoReceita.fieldbyname('GIROACESS'+NomeCampo).AsCurrency := qryComparativoReceitaQTDACESSORIOS.AsInteger/cQtdAcessorios;

       try
         tblComparativoReceita.fieldbyname('PERFOMANCE'+NomeCampo).AsCurrency  := (qryComparativoReceitaQTDCONTRATOS.AsInteger/qryComparativoReceitaQTDAGENDA.AsInteger) * 100;
       except
         tblComparativoReceita.fieldbyname('PERFOMANCE'+NomeCampo).AsCurrency  := 0;
       end;

       tblComparativoReceita.post;

       cValorAcumulado := cValorAcumulado + qryComparativoReceitaVALORTOTAL.AsCurrency;

       cOldAno := qryComparativoReceitaANO.Text;

     end;

     qryComparativoReceita.Next;

   end;

 end;

 procedure AtualizarGrid;
 var
   i, x, y, cAno : Integer;
 begin

   grdPainelDBBandedTableView1.BeginUpdate;
   grdPainelDBBandedTableView1.ClearItems;
   grdPainelDBBandedTableView1.Bands.Clear;
   grdPainelDBBandedTableView1.DataController.CreateAllItems;

   cAno := cmbAnoInicio.EditValue;

   grdPainelDBBandedTableView1.Bands.Add;
   grdPainelDBBandedTableView1.Bands[0].Caption := '';
   grdPainelDBBandedTableView1.Columns[0].Position.BandIndex := 0;
   y := 1;

   for i:=1 to QtdAnos do
   begin

     if not chbAcumulado.Checked  then
       NomeCampo := intTostr(cAno)
     else
       NomeCampo := 'Acumulado';

     grdPainelDBBandedTableView1.Bands.Add;
     grdPainelDBBandedTableView1.Bands[i].Caption := NomeCampo;

     for x:=1 to 19 do
     begin

       grdPainelDBBandedTableView1.Columns[y].Position.BandIndex := grdPainelDBBandedTableView1.Bands[i].ID;
       grdPainelDBBandedTableView1.Columns[y].Width := 79;

       with grdPainelDBBandedTableView1.DataController.Summary.FooterSummaryItems do
       begin
         Case x of
           2:
              begin
                Add(grdPainelDBBandedTableView1.Columns[y],spFooter,skSum,'#,##0.00');
                grdPainelDBBandedTableView1.Columns[y].Summary.GroupKind := skSum;
                grdPainelDBBandedTableView1.Columns[y].Summary.GroupFormat := '#,##0.00';
              end;
           4,5,8,10,12,14,15,16,17,18,19:
              begin
                Add(grdPainelDBBandedTableView1.Columns[y],spFooter,skAverage,'#,##0.00');
                grdPainelDBBandedTableView1.Columns[y].Summary.GroupKind := skAverage;
                grdPainelDBBandedTableView1.Columns[y].Summary.GroupFormat := '#,##0.00';
              end;
           6,7,9,11,13:
              begin
                Add(grdPainelDBBandedTableView1.Columns[y],spFooter,skSum,'#0');
                grdPainelDBBandedTableView1.Columns[y].Summary.GroupKind := skSum;
                grdPainelDBBandedTableView1.Columns[y].Summary.GroupFormat := '#0';
              end;
         End;
       end;

       inc(y);
       
     end;

     inc(cAno);
     
   end;

   grdPainelDBBandedTableView1.Columns[0].Width := 80;

   grdPainelDBBandedTableView1.EndUpdate;

 end;

 procedure PreencherGrafico;
 var
   i, cAno:Integer;
   Serie : TBarSeries;
   Campo: String;
   Valor: Currency;
 begin

   cAno := cmbAnoInicio.EditValue;

   try
     for i := 0 to GraficoComparativo.SeriesCount - 1  do
       GraficoComparativo.Series[i].Destroy;
   except
     for i := 0 to GraficoComparativo.SeriesCount - 1  do
       GraficoComparativo.Series[i].Destroy;
   end;

   for i:=1 to QtdAnos do
   begin

     if not chbAcumulado.Checked  then
       NomeCampo := intTostr(cAno)
     else
       NomeCampo := 'Acumulado';

     With GraficoComparativo do
     begin
       AddSeries(TBarSeries.Create(nil));
       Series[GraficoComparativo.SeriesCount - 1].Name := 'Ano_'+NomeCampo;
       Series[GraficoComparativo.SeriesCount - 1].Marks.Style := smsValue;
     end;

     inc(cAno);

   end;

   Case rdgGrafico.ItemIndex of
     0: Campo := 'VALORTOTAL_';
     1: Campo := 'MEDIACONTRATO_';
     2: Campo := 'QTDALUGUEL_';
     3: Campo := 'QTDAGENDA_';
   End;

   tblComparativoReceita.First;

   While not tblComparativoReceita.Eof do
   begin

     cAno := cmbAnoInicio.EditValue;

     for i:=1 to QtdAnos do
     begin

       if not chbAcumulado.Checked  then
         NomeCampo := intTostr(cAno)
       else
         NomeCampo := 'Acumulado';

       GraficoComparativo.Series[i-1].Add(tblComparativoReceita.FieldByName(Campo+NomeCampo).AsCurrency,Copy(tblComparativoReceita.FieldByName('MES').Text,1,3) ) ;
       inc(cAno);
     end; 

     tblComparativoReceita.Next;
   end;

 end;

begin


  try
    QtdAnos := (cmbAnoFim.EditValue - cmbAnoInicio.EditValue) + 1;
  except
    ShowMessage('Informe o período!');
    Abort;
  end;

  if chbAcumulado.Checked then
    QtdAnos := 1;

  if QtdAnos < 1 then
  begin
    ShowMessage('Período inválido!');
    Abort;
  end;

  qryComparativoReceita.Close;
  qryComparativoReceita.Open;

  CriarTabelaMemoria;
  PopularTabelaMemoria;
  AtualizarGrid;
  PreencherGrafico;

end;

procedure TfrmAcompanhaPerformance.cxButton2Click(Sender: TObject);
begin
  if cxPageControl1.ActivePage = cxTabSheet1 then
    ImprimirGrid(grdPainel,'Painel Geral')
  else
  if cxPageControl1.ActivePage = cxTabSheet2 then
    ImprimirGrid(cxGrid1,'Painel por Produto'+iif(cmbRelatorio1.EditValue > 0,' - '+cmbRelatorio1.Text,''))
  else
  if cxPageControl1.ActivePage = cxTabSheet3 then
    ImprimirGrid(cxGrid2,'Painel por Cliente'+iif(cxLookupComboBox1.EditValue > 0,' - '+cxLookupComboBox1.Text,''))
  else
  if cxPageControl1.ActivePage = cxTabSheet4 then
    ImprimirGrid(cxGrid3,'Painel Pedido de Agenda'+iif(cxLookupComboBox2.EditValue > 0,' - '+cxLookupComboBox2.Text,''))
  else
  if cxPageControl1.ActivePage = cxTabSheet5 then
    ImprimirGrid(cxGrid4,'Painel de Terceiros'+iif(cxLookupComboBox3.EditValue > 0,' - '+cxLookupComboBox3.Text,''));
end;

procedure TfrmAcompanhaPerformance.cxButton3Click(Sender: TObject);
begin
  if cxPageControl1.ActivePage = cxTabSheet1 then
    ExportarGrid(grdPainel)
  else
  if cxPageControl1.ActivePage = cxTabSheet2 then
    ExportarGrid(cxGrid1)
  else
  if cxPageControl1.ActivePage = cxTabSheet3 then
    ExportarGrid(cxGrid2)
  else
  if cxPageControl1.ActivePage = cxTabSheet4 then
    ExportarGrid(cxGrid3)
  else
  if cxPageControl1.ActivePage = cxTabSheet5 then
    ExportarGrid(cxGrid4);
end;

procedure TfrmAcompanhaPerformance.cxButton4Click(Sender: TObject);

  procedure PreencherPainelReceitaProduto;
  var
    color : Tcolor;
  begin

    qryReceitaProdutoGrafico.Close;
    qryReceitaProdutoGrafico.Open;

    serReceitaProduto.Clear;

    While not qryReceitaProdutoGrafico.Eof do
    begin

      if qryReceitaProdutoGraficoTIPO.Text = 'Positiva' then
        color := clGreen
      else
        color := clRed;

      serReceitaProduto.AddPie(qryReceitaProdutoGraficoQTD.AsInteger, qryReceitaProdutoGraficoTIPO.Text, color);

      qryReceitaProdutoGrafico.Next;

    end;

  end;

begin
  qryReceitaProduto.Close;
  qryReceitaProduto.Open;

  PreencherPainelReceitaProduto;
end;

procedure TfrmAcompanhaPerformance.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcompanhaPerformance.cxButton6Click(Sender: TObject);

  procedure PreencherGraficoCliente;
  var
    cFaixa: String;
  begin

    qryReceitaPerfilGrafico.Close;
    qryReceitaPerfilGrafico.Open;

    serFaixaEtaria.Clear;

    While not qryReceitaPerfilGrafico.Eof do
    begin

      if Trim(qryReceitaPerfilGraficoFAIXA.Text) = '20' then
        cFaixa := '<= 20 anos'
      else
      if Trim(qryReceitaPerfilGraficoFAIXA.Text) = '50' then
        cFaixa := '>= 50 anos'
      else
        cFaixa := qryReceitaPerfilGraficoFAIXA.Text;

      serFaixaEtaria.AddPie(qryReceitaPerfilGraficoVALORTOTAL.AsCurrency, cFaixa);

      qryReceitaPerfilGrafico.Next;

    end;

  end;

begin
  qryReceitaPerfil.Close;
  qryReceitaPerfil.Open;

  PreencherGraficoCliente;
end;

procedure TfrmAcompanhaPerformance.cxButton7Click(Sender: TObject);
begin

  qryPedidoAgenda.Close;
  qryPedidoAgenda.Open;

  serPedidoAgenda.Clear;

  While not qryPedidoAgenda.Eof do
  begin

    serPedidoAgenda.AddPie(qryPedidoAgendaQTDPEDIDOAGENDA.AsInteger, 'Tam. '+ qryPedidoAgendaTAMANHO.Text);

    qryPedidoAgenda.Next;

  end;

  qryPedidoAgenda.First;

end;

procedure TfrmAcompanhaPerformance.cxButton8Click(Sender: TObject);
begin
  qryTerceiros.Close;
  qryTerceiros.Open;
end;

procedure TfrmAcompanhaPerformance.btnCriar1Click(Sender: TObject);
begin
  if cxPageControl1.ActivePage = cxTabSheet2 then
    cxGrid1DBTableViewAux := cxGrid1DBTableView1
  else
  if cxPageControl1.ActivePage = cxTabSheet3 then
    cxGrid1DBTableViewAux := cxGridDBTableView1
  else
  if cxPageControl1.ActivePage = cxTabSheet4 then
    cxGrid1DBTableViewAux := cxGridDBTableView2
  else
  if cxPageControl1.ActivePage = cxTabSheet5 then
    cxGrid1DBTableViewAux := cxGridDBTableView3;

  Dados.CriarModeloPainel('frmAcompanhaPerformance',cxGrid1DBTableViewAux);

  qryPaineis.Close;
  qryPaineis.Open;
end;

procedure TfrmAcompanhaPerformance.cxPageControl1Change(Sender: TObject);
begin
  qryPaineis.Close;
  qryPaineis.Open;
end;

procedure TfrmAcompanhaPerformance.edtPerfilExit(Sender: TObject);
begin
  try
    if edtPerfil.Text <> '' then
      cbPerfil.EditValue := StrToInt(edtPerfil.Text)
    else
      cbPerfil.EditValue := Null;
  except
  end;
end;

procedure TfrmAcompanhaPerformance.edtProdutoExit(Sender: TObject);
begin
  try
    if edtProduto.Text <> '' then
      cbProduto.EditValue := StrToInt(edtProduto.Text)
    else
      cbProduto.EditValue := Null;
  except
  end;
end;

function TfrmAcompanhaPerformance.Filtro(): String;
var
  vFiltro : String;
  vCampoData : String;
begin

  if (Trim(cbProduto.Text) <> '') and (cbProduto.EditValue > 0) then
    vFiltro := vFiltro + ' and CODIGOPRODUTO = '+VarToStr(cbProduto.EditValue);

  if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
    vFiltro := vFiltro + ' and C.DATA between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and C.DATA >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and C.DATA <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date));

  result := vFiltro;
end;

function TfrmAcompanhaPerformance.Filtro2: String;
var
  vFiltro : String;
  vCampoData : String;
begin

  if (Trim(cbPerfil.Text) <> '') and (cbPerfil.EditValue > 0) then
    vFiltro := vFiltro + ' and CODIGOCLIENTE = '+VarToStr(cbPerfil.EditValue);

  if (edtDtInicial2.Text <> '') and (edtDtFinal2.Text <> '') then
    vFiltro := vFiltro + ' and C.DATA between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial2.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal2.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and C.DATA >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial2.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and C.DATA <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal2.Date));

  result := vFiltro;
end;

procedure TfrmAcompanhaPerformance.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryPerfil.Close;
    qryPerfil.Open;

    qryProduto.Close;
    qryProduto.Open;

    qryPaineis.Close;
    qryPaineis.Open;
    
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmAcompanhaPerformance.qryComparativoReceitaAfterOpen(
  DataSet: TDataSet);
begin

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT COUNT(1) AS QTDPRODUTOS '+
                          '  FROM TABPRODUTOS P  '+
                          ' WHERE P.CODIGOSITUACAO = 1 ';
  Dados.Geral.Open;

  cQtdProdutos := Dados.Geral.FieldByName('QTDPRODUTOS').AsInteger;


  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT COUNT(1) AS QTDPRODUTOS '+
                          '  FROM TABPRODUTOS P  '+
                          ' INNER JOIN TABPREFERENCIASPRODUTO PR ON (P.CODIGO = PR.CODIGOPRODUTO) '+
                          ' WHERE P.CODIGOSITUACAO = 1  AND PR.TIPO = 1 ';
  Dados.Geral.Open;

  cQtdPecas := Dados.Geral.FieldByName('QTDPRODUTOS').AsInteger;


  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT COUNT(1) AS QTDPRODUTOS '+
                          '  FROM TABPRODUTOS P  '+
                          ' INNER JOIN TABPREFERENCIASPRODUTO PR ON (P.CODIGO = PR.CODIGOPRODUTO) '+
                          ' WHERE P.CODIGOSITUACAO = 1  AND PR.TIPO = 2 ';
  Dados.Geral.Open;

  cQtdAcessorios := Dados.Geral.FieldByName('QTDPRODUTOS').AsInteger;


end;

procedure TfrmAcompanhaPerformance.qryComparativoReceitaBeforeOpen(DataSet: TDataSet);
begin

  if not chbAcumulado.Checked then
    qryComparativoReceita.SQL.Strings[qryComparativoReceita.SQL.IndexOf('--ANO')+1] := ' X.ANO, '
  else
    qryComparativoReceita.SQL.Strings[qryComparativoReceita.SQL.IndexOf('--ANO')+1] := ' 0 ANO, ';
    
  qryComparativoReceita.SQL.Strings[qryComparativoReceita.SQL.IndexOf('--AND')+1] := ' AND X.ANO BETWEEN '+cmbAnoInicio.Text + ' AND '+cmbAnoFim.Text;

end;

procedure TfrmAcompanhaPerformance.qryPaineisBeforeOpen(DataSet: TDataSet);
var
  Componente : String;
begin
  if cxPageControl1.ActivePage = cxTabSheet2 then
    Componente := cxGrid1DBTableView1.Name
  else
  if cxPageControl1.ActivePage = cxTabSheet3 then
    Componente := cxGridDBTableView1.Name
  else
  if cxPageControl1.ActivePage = cxTabSheet4 then
    Componente := cxGridDBTableView2.Name
  else
  if cxPageControl1.ActivePage = cxTabSheet5 then
    Componente := cxGridDBTableView3.Name;

  qryPaineis.ParamByName('TELA').Value := 'frmAcompanhaPerformance';
  qryPaineis.ParamByName('COMPONENTE').Value := Componente;

end;

procedure TfrmAcompanhaPerformance.qryPedidoAgendaBeforeOpen(DataSet: TDataSet);
begin
  qryPedidoAgenda.SQL.Strings[qryPedidoAgenda.SQL.IndexOf('--AND')+1] := Filtro3();
  qryPedidoAgenda.SQL.Strings[qryPedidoAgenda.SQL.IndexOf('--AND2')+1] := Filtro4();
end;

procedure TfrmAcompanhaPerformance.qryReceitaPerfilBeforeOpen(
  DataSet: TDataSet);
begin
  qryReceitaPerfil.SQL.Strings[qryReceitaPerfil.SQL.IndexOf('--AND')+1] := Filtro2();
end;

procedure TfrmAcompanhaPerformance.qryReceitaPerfilGraficoBeforeOpen(
  DataSet: TDataSet);
begin
  qryReceitaPerfilGrafico.SQL.Strings[qryReceitaPerfilGrafico.SQL.IndexOf('--AND')+1] := Filtro2();
end;

procedure TfrmAcompanhaPerformance.qryReceitaProdutoBeforeOpen(
  DataSet: TDataSet);
begin
  qryReceitaProduto.SQL.Strings[qryReceitaProduto.SQL.IndexOf('--AND')+1] := Filtro();
end;

procedure TfrmAcompanhaPerformance.qryReceitaProdutoGraficoBeforeOpen(
  DataSet: TDataSet);
begin
  qryReceitaProdutoGrafico.SQL.Strings[qryReceitaProdutoGrafico.SQL.IndexOf('--AND1')+1] := Filtro();
  qryReceitaProdutoGrafico.SQL.Strings[qryReceitaProdutoGrafico.SQL.IndexOf('--AND2')+1] := Filtro();
end;

function TfrmAcompanhaPerformance.Filtro3: String;
var
  vFiltro : String;
  vCampoData : String;
begin

  if (Trim(cbPerfil3.Text) <> '') and (cbPerfil3.EditValue > 0) then
    vFiltro := vFiltro + ' and A.codigoperfil = '+VarToStr(cbPerfil3.EditValue);

  if (edtDtInicial3.Text <> '') and (edtDtFinal3.Text <> '') then
    vFiltro := vFiltro + ' and P.DATAEVENTO between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial3.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal3.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and P.DATAEVENTO >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial3.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and P.DATAEVENTO <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal3.Date));

  result := vFiltro;
end;


function TfrmAcompanhaPerformance.Filtro4: String;
var
  vFiltro : String;
  vCampoData : String;
begin

  if (Trim(cbPerfil3.Text) <> '') and (cbPerfil3.EditValue > 0) then
    vFiltro := vFiltro + ' and C.CODIGOCLIENTE = '+VarToStr(cbPerfil3.EditValue);

  if (edtDtInicial3.Text <> '') and (edtDtFinal3.Text <> '') then
    vFiltro := vFiltro + ' and C.DATA between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial3.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal3.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and C.DATA  >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial3.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and C.DATA  <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal3.Date));

  result := vFiltro;
end;


end.
