unit untAcompanhaOrdemServico;

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
  TfrmAcompanhaOrdemServico = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Label27: TLabel;
    cbPerfil: TRxDBLookupCombo;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    qryServico: TIBQuery;
    IntegerField1: TIntegerField;
    dtsServico: TDataSource;
    Label36: TLabel;
    cbServico: TRxDBLookupCombo;
    Label38: TLabel;
    edtDtInicial: TwwDBDateTimePicker;
    Label1: TLabel;
    edtDtFinal: TwwDBDateTimePicker;
    rgTipoData: TRadioGroup;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    qryPainel: TIBQuery;
    dtsPainel: TDataSource;
    btnLimpar: TcxButton;
    SaveDialog2: TSaveDialog;
    dxCompPrinterGrid: TdxComponentPrinter;
    dxCompPrinterCntLinkCnt: TdxGridReportLink;
    Panel3: TPanel;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    DBText1: TDBText;
    cxButton6: TcxButton;
    cxButton7: TcxButton;
    cxButton4: TcxButton;
    PopupMenu1: TPopupMenu;
    Configuraes1: TMenuItem;
    qryServicoDECRICAO: TIBStringField;
    qryPainelCODIGO: TIntegerField;
    qryPainelCODIGOPERFIL: TIntegerField;
    qryPainelNOMEPERFIL: TIBStringField;
    qryPainelCODIGOSERVICO: TIntegerField;
    qryPainelSERVICO: TIBStringField;
    qryPainelNUMEROPRESTADOR: TIBStringField;
    qryPainelDATA: TDateField;
    qryPainelDATAINICIO: TDateField;
    qryPainelHORAINICIO: TTimeField;
    qryPainelDATAFIM: TDateField;
    qryPainelHORAFIM: TTimeField;
    qryPainelSITUACAO: TIBStringField;
    qryPainelPRODUTOS: TIntegerField;
    qryPainelTOTAL: TIBBCDField;
    cxButton8: TcxButton;
    cxButton9: TcxButton;
    Panel7: TPanel;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1CODIGOPERFIL: TcxGridDBColumn;
    grdPainelDBTableView1NOMEPERFIL: TcxGridDBColumn;
    grdPainelDBTableView1CODIGOSERVICO: TcxGridDBColumn;
    grdPainelDBTableView1SERVICO: TcxGridDBColumn;
    grdPainelDBTableView1NUMEROPRESTADOR: TcxGridDBColumn;
    grdPainelDBTableView1DATA: TcxGridDBColumn;
    grdPainelDBTableView1DATAINICIO: TcxGridDBColumn;
    grdPainelDBTableView1HORAINICIO: TcxGridDBColumn;
    grdPainelDBTableView1DATAFIM: TcxGridDBColumn;
    grdPainelDBTableView1HORAFIM: TcxGridDBColumn;
    grdPainelDBTableView1SITUACAO: TcxGridDBColumn;
    grdPainelDBTableView1PRODUTOS: TcxGridDBColumn;
    grdPainelDBTableView1TOTAL: TcxGridDBColumn;
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
    procedure btnLimparClick(Sender: TObject);
    procedure qryPainelBeforeOpen(DataSet: TDataSet);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxButton9Click(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure btnCriar1Click(Sender: TObject);
    procedure btnExcluir1Click(Sender: TObject);
    procedure cmbRelatorio1Exit(Sender: TObject);
    procedure qryPaineisBeforeOpen(DataSet: TDataSet);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    vDiasUrgente, vDiasAlerta, vDiasMuitoUrgente: Integer;
    function Filtro(): String;
    procedure CarregaConfiguracoes();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAcompanhaOrdemServico: TfrmAcompanhaOrdemServico;

implementation

uses form_cadastro_pedido_agenda, untConsultaProdutos,
  untAgendarPedido, untOrdemServico, untDtmRelatorios,
  versao, funcao;

const
  NomeMenu = 'AcompanhaOS';
  cCaption = 'ACOMPANHAMENTO DE ORDEM DE SERVIÇO';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAcompanhaOrdemServico.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAcompanhaOrdemServico.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAcompanhaOrdemServico.CarregaConfiguracoes();
begin
  //config
end;

procedure TfrmAcompanhaOrdemServico.cmbRelatorio1Exit(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
    Dados.SelecionarModeloPainel(grdPainelDBTableView1,cmbRelatorio1.EditValue);
end;

procedure TfrmAcompanhaOrdemServico.btnCriar1Click(Sender: TObject);
begin
  Dados.CriarModeloPainel('frmAcompanhaOrdemServico',grdPainelDBTableView1);

  qryPaineis.Close;
  qryPaineis.Open;
end;

procedure TfrmAcompanhaOrdemServico.btnExcluir1Click(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cmbRelatorio1.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaOrdemServico.btnLimparClick(Sender: TObject);
begin
  cbPerfil.KeyValue := -1;
  cbServico.KeyValue := -1;
  edtDtInicial.Text := '';
  edtDtFinal.Text := '';
  rgTipoData.ItemIndex := 0;
end;

procedure TfrmAcompanhaOrdemServico.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmAcompanhaOrdemServico.FormCreate(Sender: TObject);
begin
  CarregaConfiguracoes();
  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAcompanhaOrdemServico.Configuraes1Click(Sender: TObject);
begin
  dados.ShowConfig(frmAcompanhaOrdemServico);
  CarregaConfiguracoes();
end;

procedure TfrmAcompanhaOrdemServico.cxButton1Click(Sender: TObject);
begin
  qryPainel.Close;
  qryPainel.Open;
end;

procedure TfrmAcompanhaOrdemServico.cxButton2Click(Sender: TObject);
begin
  dxCompPrinterGrid.CurrentLink.Component := grdPainel;

  dxCompPrinterGrid.Preview(True,dxCompPrinterCntLinkCnt);
end;

procedure TfrmAcompanhaOrdemServico.cxButton3Click(Sender: TObject);
var
  sPath : string;
begin
  sPath := '';
  if SaveDialog2.Execute then
    sPath := SaveDialog2.FileName;

  if sPath <> '' then
  begin
    if pos('.xls', sPath) > 0 then
      ExportGridToExcel(sPath, grdPainel, True, True, True)
    else if pos('.xml', sPath) > 0 then
      ExportGridToXML(sPath, grdPainel, True, True)
    else if pos('.html', sPath) > 0 then
      ExportGridToHTML(sPath, grdPainel, True, True)
    else if pos('.txt', sPath) > 0 then
      ExportGridToText(sPath, grdPainel, True, True);

    ShellExecute(0, 'open', PChar(sPath), nil, nil, SW_SHOW);
  end;

end;

procedure TfrmAcompanhaOrdemServico.cxButton4Click(Sender: TObject);
begin
  If Application.FindComponent('frmOrdemServico') = Nil then
         Application.CreateForm(TfrmOrdemServico, frmOrdemServico);

  frmOrdemServico.cInserindo := True;

  frmOrdemServico.Show;
end;

procedure TfrmAcompanhaOrdemServico.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcompanhaOrdemServico.cxButton6Click(Sender: TObject);
begin
  If Application.FindComponent('frmOrdemServico') = Nil then
         Application.CreateForm(TfrmOrdemServico, frmOrdemServico);

  frmOrdemServico.cInserindo := False;
  frmOrdemServico.pubCodigo := qryPainelCODIGO.AsInteger;

  frmOrdemServico.Show;
end;

procedure TfrmAcompanhaOrdemServico.cxButton7Click(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirOS(qryPainelCODIGO.AsInteger);
end;

procedure TfrmAcompanhaOrdemServico.cxButton8Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja Realmente Finalizar Ordem de Serviço?','Finalizar OS',MB_YESNO+MB_ICONQUESTION) = IDYES THEN
  begin
    Dados.Geral.SQL.Text := 'update tabos set Situacao = 3, '+
        ' DATAFIM = (CASE WHEN DATAFIM > CURRENT_DATE THEN CURRENT_DATE ELSE DATAFIM END), '+
        ' HORAFIM = (CASE WHEN DATAFIM >= CURRENT_DATE THEN current_time ELSE HORAFIM END) '+
        ' where codigo = '+intToStr(qryPainelCODIGO.AsInteger);
    Dados.Geral.ExecSql();
    Dados.Geral.Transaction.CommitRetaining;

    qryPainel.Close;
    qryPainel.Open;
  end;
end;

procedure TfrmAcompanhaOrdemServico.cxButton9Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja Realmente Cancelar Ordem de Serviço?','Cancelar OS',MB_YESNO+MB_ICONQUESTION) = IDYES THEN
  begin
    Dados.Geral.SQL.Text := 'update tabos set Situacao = 4, '+
        ' DATAFIM = (CASE WHEN DATAFIM > CURRENT_DATE THEN CURRENT_DATE ELSE DATAFIM END), '+
        ' HORAFIM = (CASE WHEN DATAFIM >= CURRENT_DATE THEN current_time ELSE HORAFIM END) '+
        ' where codigo = '+intToStr(qryPainelCODIGO.AsInteger);
    Dados.Geral.ExecSql();
    Dados.Geral.Transaction.CommitRetaining;

    qryPainel.Close;
    qryPainel.Open;
  end;
end;

function TfrmAcompanhaOrdemServico.Filtro(): String;
var
  vFiltro : String;
  vCampoData : String;
begin
  if cbPerfil.KeyValue > 0 then
    vFiltro := vFiltro + ' and O.codigoperfil = '+VarToStr(cbPerfil.KeyValue);

  if cbServico.KeyValue > 0 then
    vFiltro := vFiltro + ' and o.codigoservico = '+VarToStr(cbServico.KeyValue);

  if rgTipoData.ItemIndex = 1 then
  begin
    if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
    begin
      vFiltro := vFiltro + ' and ('+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' between o.datainicio and o.datafim'+
                           ' or '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))+' between o.datainicio and o.datafim)'
    end
    else if (edtDtInicial.Text <> '')  then
      vFiltro := vFiltro + ' and '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' between o.datainicio and o.datafim'
    else if (edtDtFinal.Text <> '')  then
      vFiltro := vFiltro + ' and '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))+' between o.datainicio and o.datafim';
  end
  else
  begin
    if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
      vFiltro := vFiltro + ' and o.data between '+
                   QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                   QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))
    else if (edtDtInicial.Text <> '')  then
      vFiltro := vFiltro + ' and o.data >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))
    else if (edtDtFinal.Text <> '')  then
      vFiltro := vFiltro + ' and o.data <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date));
  end;

  result := vFiltro;
end;

procedure TfrmAcompanhaOrdemServico.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    btnLimparClick(self);

    qryPerfil.Close;
    qryPerfil.Open;

    qryServico.Close;
    qryServico.Open;

    qryPaineis.Close;
    qryPaineis.Open;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmAcompanhaOrdemServico.qryPaineisBeforeOpen(DataSet: TDataSet);
begin
  qryPaineis.ParamByName('TELA').Value := 'frmAcompanhaOrdemServico';
  qryPaineis.ParamByName('COMPONENTE').Value := grdPainelDBTableView1.Name;
end;

procedure TfrmAcompanhaOrdemServico.qryPainelBeforeOpen(DataSet: TDataSet);
begin
  qryPainel.SQL.Strings[qryPainel.SQL.IndexOf('--where')+1] := Filtro();
end;

end.
