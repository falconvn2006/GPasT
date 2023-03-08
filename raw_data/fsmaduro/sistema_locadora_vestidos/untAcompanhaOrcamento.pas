unit untAcompanhaOrcamento;

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
  cxGroupBox, untDados;

type
  TfrmAcompanhaOrcamento = class(TForm)
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
    qryOrcamento: TIBQuery;
    dtsOrcamento: TDataSource;
    SaveDialog2: TSaveDialog;
    dxCompPrinterGrid: TdxComponentPrinter;
    Panel3: TPanel;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    Panel4: TPanel;
    cxButton6: TcxButton;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1DATACADASTRO: TcxGridDBColumn;
    grdPainelDBTableView1CODIGOCLIENTE: TcxGridDBColumn;
    grdPainelDBTableView1OBSERVACOES: TcxGridDBColumn;
    grdPainelDBTableView1NOMESITUACAO: TcxGridDBColumn;
    grdPainelDBTableView1NOMECLIENTE: TcxGridDBColumn;
    grdPainelDBTableView1TELEFONE: TcxGridDBColumn;
    grdPainelDBTableView1USERNAME: TcxGridDBColumn;
    cxButton4: TcxButton;
    grdPainelDBTableView1Column1: TcxGridDBColumn;
    grdPainelDBTableView1Column2: TcxGridDBColumn;
    cxButton7: TcxButton;
    grdPainelDBTableView1Column3: TcxGridDBColumn;
    Panel6: TPanel;
    DBText1: TDBText;
    Panel5: TPanel;
    qryOrcamentoCODIGO: TIntegerField;
    qryOrcamentoDATACADASTRO: TDateField;
    qryOrcamentoCODIGOCLIENTE: TIntegerField;
    qryOrcamentoCODIGOUSUARIO: TIntegerField;
    qryOrcamentoCODIGOSITUACAO: TIntegerField;
    qryOrcamentoOBSERVACOES: TIBStringField;
    qryOrcamentoNOMESITUACAO: TIBStringField;
    qryOrcamentoNOMECLIENTE: TIBStringField;
    qryOrcamentoTELEFONE: TIBStringField;
    qryOrcamentoUSERNAME: TIBStringField;
    qryOrcamentoCODIGOCONTRATO: TIntegerField;
    qryOrcamentoDATAVENCIMENTO: TDateField;
    qryOrcamentoVALOR: TIBBCDField;
    cxButton8: TcxButton;
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
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryOrcamentoBeforeOpen(DataSet: TDataSet);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure grdPainelDBTableView1Column3CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure cxButton7Click(Sender: TObject);
    procedure dtsOrcamentoDataChange(Sender: TObject; Field: TField);
    procedure grdPainelDBTableView1NOMESITUACAOCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure grdPainelDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
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
    vDiasUrgente, vDiasAlerta, vDiasMuitoUrgente: Integer;
    function Filtro(): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAcompanhaOrcamento: TfrmAcompanhaOrcamento;

implementation

uses form_cadastro_pedido_agenda, untConsultaProdutos,
  untAgendarPedido, untAcompanhaPedidoAgenda, untOrcamento, untContrato,
  untDtmRelatorios, Funcao, versao;

const
   NomeMenu = 'PaineldeOramento1';
   cCaption = 'ACOMPANHAMENTO DE ORÇAMENTO';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAcompanhaOrcamento.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAcompanhaOrcamento.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAcompanhaOrcamento.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmAcompanhaOrcamento.FormCreate(Sender: TObject);
begin
  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAcompanhaOrcamento.btnCriar1Click(Sender: TObject);
begin
  Dados.CriarModeloPainel('frmAcompanhaOrcamento',grdPainelDBTableView1);

  qryPaineis.Close;
  qryPaineis.Open;
end;

procedure TfrmAcompanhaOrcamento.btnExcluir1Click(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cmbRelatorio1.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaOrcamento.cmbRelatorio1Exit(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
    Dados.SelecionarModeloPainel(grdPainelDBTableView1,cmbRelatorio1.EditValue);
end;

procedure TfrmAcompanhaOrcamento.Configuraes1Click(Sender: TObject);
begin
 dados.ShowConfig(frmAcompanhaPedidoAgenda);
end;

procedure TfrmAcompanhaOrcamento.cxButton1Click(Sender: TObject);
begin
  qryOrcamento.Close;
  qryOrcamento.Open;
end;

procedure TfrmAcompanhaOrcamento.cxButton2Click(Sender: TObject);
begin
  ImprimirGrid(grdPainel,'Painel de Orçamento');
end;

procedure TfrmAcompanhaOrcamento.cxButton3Click(Sender: TObject);
begin
  ExportarGrid(grdPainel);
end;

procedure TfrmAcompanhaOrcamento.cxButton4Click(Sender: TObject);
begin

  if qryOrcamentoCODIGO.Text <> '' then
  begin

    If Application.FindComponent('frmOrcamento') = Nil then
           Application.CreateForm(TfrmOrcamento, frmOrcamento);

    frmOrcamento.Show;

    frmOrcamento.qryOrcamento.Locate('CODIGO',qryOrcamentoCODIGO.AsInteger,[]);
    
  end;

end;

procedure TfrmAcompanhaOrcamento.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcompanhaOrcamento.cxButton6Click(Sender: TObject);
begin
  If Application.FindComponent('frmOrcamento') = Nil then
         Application.CreateForm(TfrmOrcamento, frmOrcamento);

  frmOrcamento.cInserindo := True;

  frmOrcamento.ShowModal;
end;

procedure TfrmAcompanhaOrcamento.cxButton7Click(Sender: TObject);
var
  ProdutosContrato : array of TProdutosContrato;
  i : Integer;
begin

  try
    Dados.Geral.Close;
    Dados.Geral.SQL.Text := 'SELECT * FROM TABORCAMENTODETALHE WHERE CODIGO = 0'+qryOrcamentoCODIGO.Text;
    Dados.Geral.Open;

    Dados.Geral.Last;
    Dados.Geral.First;

    i := 0;

    SetLength(ProdutosContrato,Dados.Geral.RecordCount);

    While not Dados.Geral.Eof do
    begin

      ProdutosContrato[i].CodigoProduto := Dados.Geral.FieldByName('CODIGOPRODUTO').AsInteger;
      ProdutosContrato[i].Valor := Dados.Geral.FieldByName('VALOR').AsInteger;

      inc(i);

      Dados.Geral.Next;

    end;

    Dados.InserirContrato(qryOrcamentoCODIGOCLIENTE.AsInteger,ProdutosContrato,qryOrcamentoCODIGO.AsInteger);

  finally
    cxButton1.Click;
  end;
end;

procedure TfrmAcompanhaOrcamento.cxButton8Click(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirOrcamento(qryOrcamentoCODIGO.AsInteger);
end;

procedure TfrmAcompanhaOrcamento.dtsOrcamentoDataChange(Sender: TObject;
  Field: TField);
begin
  cxButton7.Enabled := (qryOrcamentoCODIGOCONTRATO.AsInteger = 0) and (Trim(qryOrcamentoNOMESITUACAO.Text) <> 'VENCIDO');
end;

function TfrmAcompanhaOrcamento.Filtro(): String;
var
  vFiltro : String;
  vCampoData : String;
begin
  if cbPerfil.KeyValue > 0 then
    vFiltro := vFiltro + ' and o.codigocliente = '+VarToStr(cbPerfil.KeyValue);

  if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
    vFiltro := vFiltro + ' and o.datacadastro between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and o.datacadastro >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and o.datacadastro <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date));

  result := vFiltro;
end;

procedure TfrmAcompanhaOrcamento.FormShow(Sender: TObject);
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

procedure TfrmAcompanhaOrcamento.grdPainelDBTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if (ACellViewInfo.Item.Caption =  'Contrato') then
  begin
    if qryOrcamentoCODIGOCONTRATO.Text <> '' then
    begin

      if Application.FindComponent('frmContrato') = Nil then
             Application.CreateForm(TfrmContrato, frmContrato);

      frmContrato.Show;

      frmContrato.qryContrato.Close;
      frmContrato.qryContrato.ParamByName('CODIGO').AsInteger := qryOrcamentoCODIGOCONTRATO.ASInteger;
      frmContrato.qryContrato.Open;

    end;
  end;
end;

procedure TfrmAcompanhaOrcamento.grdPainelDBTableView1Column3CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  Contrato : Integer;
begin
  try
    try
      Contrato := VarAsType(AViewInfo.GridRecord.DisplayTexts[grdPainelDBTableView1Column3.Index], varInteger);
    except
      Contrato := 0;
    end;

    if Contrato > 0 then
    begin
       ACanvas.Brush.Color := clMoneyGreen;
    end
  except

  end;
end;

procedure TfrmAcompanhaOrcamento.grdPainelDBTableView1NOMESITUACAOCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  Situacao : String;
begin
{  try

    Situacao := Trim(UPPERCASE(VarAsType(AViewInfo.GridRecord.DisplayTexts[grdPainelDBTableView1NOMESITUACAO.Index], varString)));

    if Situacao = 'CONFIRMADO' then
      ACanvas.Brush.Color := clMoneyGreen
    else
    if Situacao = 'VENCIDO' then
      ACanvas.Brush.Color := $004A25FA
    else
      ACanvas.Brush.Color := $0020F4FF
  except
  end;      }
end;

procedure TfrmAcompanhaOrcamento.qryOrcamentoBeforeOpen(DataSet: TDataSet);
begin
  qryOrcamento.SQL.Strings[qryOrcamento.SQL.IndexOf('--where')+1] := Filtro();
end;

procedure TfrmAcompanhaOrcamento.qryPaineisBeforeOpen(DataSet: TDataSet);
begin
  qryPaineis.ParamByName('TELA').Value := 'frmAcompanhaOrcamento';
  qryPaineis.ParamByName('COMPONENTE').Value := grdPainelDBTableView1.Name;
end;

end.
