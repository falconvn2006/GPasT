unit untAcompanhaHistoricoProduto;

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
  dxPSCore, dxPScxCommon, dxPScxGrid6Lnk, DBCtrls, cxButtonEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  cxContainer, cxGroupBox, untdados;

type
  TfrmAcompanhaHistoricoProduto = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    qryRegistros: TIBQuery;
    dtsRegistros: TDataSource;
    Panel3: TPanel;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    Panel4: TPanel;
    cxButton4: TcxButton;
    Panel6: TPanel;
    DBText1: TDBText;
    Panel5: TPanel;
    qryRegistrosDATAHORAINICIO: TDateTimeField;
    qryRegistrosDATAHORAFINAL: TDateTimeField;
    qryRegistrosTIPO: TIntegerField;
    qryRegistrosCODIGOCLIENTE: TIntegerField;
    qryRegistrosNOMECLIENTE: TIBStringField;
    qryRegistrosCODIGOPRODUTO: TIntegerField;
    qryRegistrosNOMEPRODUTO: TIBStringField;
    qryRegistrosCODIGOREGISTRO: TIntegerField;
    qryRegistrosOBSERVACOES: TMemoField;
    grdPainelDBTableView1DATAHORAINICIO: TcxGridDBColumn;
    grdPainelDBTableView1DATAHORAFINAL: TcxGridDBColumn;
    grdPainelDBTableView1NOMETIPO: TcxGridDBColumn;
    grdPainelDBTableView1NOMECLIENTE: TcxGridDBColumn;
    grdPainelDBTableView1CODIGOPRODUTO: TcxGridDBColumn;
    grdPainelDBTableView1NOMEPRODUTO: TcxGridDBColumn;
    grdPainelDBTableView1CODIGOREGISTRO: TcxGridDBColumn;
    grdPainelDBTableView1OBSERVACOES: TcxGridDBColumn;
    qryRegistrosDATAINICIO: TDateField;
    qryRegistrosDATAFIM: TDateField;
    Label27: TLabel;
    cbPerfil: TRxDBLookupCombo;
    edtDtInicial: TwwDBDateTimePicker;
    Label38: TLabel;
    edtDtFinal: TwwDBDateTimePicker;
    Label1: TLabel;
    cxButton1: TcxButton;
    qryRegistrosNOMETIPO: TIBStringField;
    cxButton6: TcxButton;
    qryRegistrosREFERENCIA: TIBStringField;
    grdPainelDBTableView1Column1: TcxGridDBColumn;
    qryRegistrosEXISTEORDEMSERVICO: TIntegerField;
    grdPainelDBTableView1Column2: TcxGridDBColumn;
    cxButton7: TcxButton;
    PopupMenu1: TPopupMenu;
    NovaOS1: TMenuItem;
    SelecionarOS1: TMenuItem;
    cbProduto: TRxDBLookupCombo;
    Label2: TLabel;
    dtsProduto: TDataSource;
    qryProduto: TIBQuery;
    IntegerField1: TIntegerField;
    IBStringField1: TIBStringField;
    qryRegistrosTIPOPECA: TIBStringField;
    grdPainelDBTableView1Column3: TcxGridDBColumn;
    qryRegistrosTIPOSERVICO: TIBStringField;
    grdPainelDBTableView1Column4: TcxGridDBColumn;
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
    qryRegistrosDEVOLVIDO: TIntegerField;
    grdPainelDBTableView1Column5: TcxGridDBColumn;
    cxButton8: TcxButton;
    qryRegistrosLOCALIZACAO: TIBStringField;
    grdPainelDBTableView1Column6: TcxGridDBColumn;
    grdPainelDBTableView1Column7: TcxGridDBColumn;
    qryRegistrosMANEQUIM: TIBStringField;
    qryRegistrosTIPOCONVIDADO: TIBStringField;
    grdPainelDBTableView1Column8: TcxGridDBColumn;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryRegistrosBeforeOpen(DataSet: TDataSet);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure qryRegistrosAfterScroll(DataSet: TDataSet);
    procedure cxButton6Click(Sender: TObject);
    procedure NovaOS1Click(Sender: TObject);
    procedure btnCriar1Click(Sender: TObject);
    procedure btnExcluir1Click(Sender: TObject);
    procedure cmbRelatorio1Exit(Sender: TObject);
    procedure qryPaineisBeforeOpen(DataSet: TDataSet);
    procedure cxButton8Click(Sender: TObject);
    
    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure FormCreate(Sender: TObject); // e esta tb
    //FIM BOTÃO HELP
  private
//    vDiasUrgente, vDiasAlerta, vDiasMuitoUrgente: Integer;
    function Filtro(): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAcompanhaHistoricoProduto: TfrmAcompanhaHistoricoProduto;

implementation

uses untDtmRelatorios, Funcao, untAcompanhaPedidoAgenda, untAgenda,
  untContrato, untOrdemServico, versao;

const
   NomeMenu = 'HistricoProduto1';
   cCaption = 'HISTÓRICO DE PRODUTOS';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAcompanhaHistoricoProduto.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAcompanhaHistoricoProduto.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAcompanhaHistoricoProduto.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmAcompanhaHistoricoProduto.FormCreate(Sender: TObject);
begin
  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAcompanhaHistoricoProduto.btnCriar1Click(Sender: TObject);
begin
  Dados.CriarModeloPainel('frmAcompanhaHistoricoProduto',grdPainelDBTableView1);

  qryPaineis.Close;
  qryPaineis.Open;
end;

procedure TfrmAcompanhaHistoricoProduto.btnExcluir1Click(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cmbRelatorio1.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaHistoricoProduto.cmbRelatorio1Exit(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
    Dados.SelecionarModeloPainel(grdPainelDBTableView1,cmbRelatorio1.EditValue);
end;

procedure TfrmAcompanhaHistoricoProduto.Configuraes1Click(Sender: TObject);
begin
 dados.ShowConfig(frmAcompanhaHistoricoProduto);
end;

procedure TfrmAcompanhaHistoricoProduto.cxButton1Click(Sender: TObject);
begin
  qryRegistros.Close;
  qryRegistros.Open;
end;

procedure TfrmAcompanhaHistoricoProduto.cxButton2Click(Sender: TObject);
begin
  ImprimirGrid(grdPainel,'Painel de Histórico de Produtos'+iif(cmbRelatorio1.EditValue > 0,' - '+cmbRelatorio1.Text,''));
end;

procedure TfrmAcompanhaHistoricoProduto.cxButton3Click(Sender: TObject);
begin
  ExportarGrid(grdPainel);
end;

procedure TfrmAcompanhaHistoricoProduto.cxButton4Click(Sender: TObject);
begin
  Case qryRegistrosTIPO.AsInteger of
  
    1: begin

         if Application.FindComponent('frmAgenda') = nil then
           Application.CreateForm(TfrmAgenda, frmAgenda);

         frmAgenda.Show;

         frmAgenda.edtDtInicial.Date := qryRegistrosDATAINICIO.AsDateTime;
         frmAgenda.edtDtFinal.Date := qryRegistrosDATAINICIO.AsDateTime;
         frmAgenda.cxButton1.Click;

         frmAgenda.cxScheduler1.GoToDate(qryRegistrosDATAINICIO.AsDateTime);

       end;

    2: begin
         if Application.FindComponent('frmContrato') = Nil then
           Application.CreateForm(TfrmContrato, frmContrato);

         frmContrato.Show;

         frmContrato.qryContrato.Close;
         frmContrato.qryContrato.ParamByName('CODIGO').AsInteger := qryRegistrosCODIGOREGISTRO.AsInteger;
         frmContrato.qryContrato.Open;

       end;

    3: begin
         if Application.FindComponent('frmOrdemServico') = Nil then
           Application.CreateForm(TfrmOrdemServico, frmOrdemServico);

         frmOrdemServico.pubCodigo := qryRegistrosCODIGOREGISTRO.AsInteger;

         frmOrdemServico.Show;
       end;
  End;

end;

procedure TfrmAcompanhaHistoricoProduto.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcompanhaHistoricoProduto.cxButton6Click(Sender: TObject);
//var
//  cQtdDias : String;
begin

  if Application.MessageBox('Deseja realmente gerar a devolução dos produtos?'#13,
                            'Devolução',MB_YESNO+MB_ICONQUESTION) = IDNO then
    Exit;

  try

    Dados.GerarDevolucao(qryRegistrosCODIGOREGISTRO.AsInteger,(qryRegistrosTIPO.AsInteger - 1),qryRegistrosCODIGOPRODUTO.AsInteger);

    Application.MessageBox('Devolução efetuada com sucesso!','Terminado!',MB_OK+MB_ICONEXCLAMATION);

  except
    on e:Exception do
      application.MessageBox(Pchar('Erro ao gerar Devolução.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;



//
//  cQtdDias := Dados.DigitarValor('Quantidade de dias que o produto retornou antecip.:');
//
//  try
//    StrToInt(cQtdDias);
//  except
//    application.messagebox('Quantidade de dias inválido!','',MB_OK+MB_ICONERROR);
//    Abort;
//  end;
//
//  try
//
//    dados.Geral.Close;
//    dados.Geral.SQl.Text := 'UPDATE TABCONTRATO '+
//                            '   SET DIASRETORNOANTECIPADO =0'+Trim(cQtdDias) +
//                            ' WHERE CODIGO ='+qryRegistrosCODIGOREGISTRO.Text;
//    dados.Geral.ExecSQL;
//
//    dados.Geral.Transaction.CommitRetaining;
//
//    application.MessageBox('Processamento Concluído!','',MB_OK+MB_ICONEXCLAMATION);
//
//  except
//    on E:Exception do
//      application.MessageBox(Pchar('Erro 154857:'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
//  end;
end;

procedure TfrmAcompanhaHistoricoProduto.cxButton8Click(Sender: TObject);
var
   i: Integer;
   lCodLocal: Integer;
begin
   lCodLocal := dados.DigitarValorBD('Selecione a Localização',
                                     'TABLOCALIZACAO',
                                     0,
                                     'DESCRICAO',
                                     'CODIGO',
                                     '');

   for i := 0 to grdPainelDBTableView1.Controller.SelectedRowCount - 1 do
   begin

     DADOS.Geral.SQL.TEXT := 'UPDATE TABPRODUTOS SET CODIGOLOCALIZACAO = :LOCALIZACAO WHERE CODIGO = :CODIGO';
     DADOS.Geral.ParamByName('LOCALIZACAO').AsInteger := lCodLocal;
     DADOS.Geral.ParamByName('CODIGO').AsInteger := grdPainelDBTableView1.Controller.SelectedRows[i].Values[grdPainelDBTableView1CODIGOPRODUTO.Index];
     DADOS.Geral.ExecSQL;
     DADOS.Geral.Transaction.CommitRetaining();

   end;

   ShowMessage('Terminado!');
end;

function TfrmAcompanhaHistoricoProduto.Filtro(): String;
var
  vFiltro : String;
//  vCampoData : String;
begin
  if cbPerfil.KeyValue > 0 then
    vFiltro := vFiltro + ' and CODIGOCLIENTE = '+VarToStr(cbPerfil.KeyValue);

  if cbProduto.KeyValue > 0 then
    vFiltro := vFiltro + ' and CODIGOPRODUTO = '+VarToStr(cbProduto.KeyValue);

  if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
    vFiltro := vFiltro + ' and (DATAHORAINICIO between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))+
                 ' or DATAHORAFINAL between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))+
                 ' or '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date)) +
                 ' between DATAHORAINICIO and DATAHORAFINAL '+
                 ' or '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date)) +
                 ' between DATAHORAINICIO and DATAHORAFINAL )'
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' between DATAHORAINICIO and DATAHORAFINAL'
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))+' between DATAHORAINICIO and DATAHORAFINAL';

  result := vFiltro;
end;

procedure TfrmAcompanhaHistoricoProduto.FormShow(Sender: TObject);
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

procedure TfrmAcompanhaHistoricoProduto.NovaOS1Click(Sender: TObject);
var
  CodigoOS : Integer;
  ProdutosContrato : array of TProdutosContrato;
  i : Integer;
begin

  CodigoOS := 0;

  try

    if Sender = SelecionarOS1 then
        CodigoOS := dados.DigitarValorBD('Selecione a Ordem de Serviço!','TabOS',0,'CAST(CODIGO AS VARCHAR(20))','CODIGO','',' and SITUACAO = 1');

    if grdPainelDBTableView1.Controller.SelectedRowCount = 0 then
    begin
      Application.MessageBox('Nenhum registro selecionado!', '', mb_ok+MB_ICONEXCLAMATION);
      Exit;
    end;

    SetLength(ProdutosContrato,0);

    for i:=0 to grdPainelDBTableView1.Controller.SelectedRowCount - 1 do
    begin

      SetLength(ProdutosContrato,i + 1);

      ProdutosContrato[i].CodigoProduto := grdPainelDBTableView1.Controller.SelectedRows[i].Values[grdPainelDBTableView1CODIGOPRODUTO.Index];
      ProdutosContrato[i].Valor := 0;

    end;

    CodigoOS := Dados.InserirOrdemServico(0,0,ProdutosContrato, 'Ordem de serviço gerada a partir do Histórico de Produtos!',CodigoOS);

  finally
    If Application.FindComponent('frmOrdemServico') = Nil then
           Application.CreateForm(TfrmOrdemServico, frmOrdemServico);

    frmOrdemServico.pubCodigo := CodigoOS;

    frmOrdemServico.Show;
  end;

end;

procedure TfrmAcompanhaHistoricoProduto.qryPaineisBeforeOpen(DataSet: TDataSet);
begin
  qryPaineis.ParamByName('TELA').Value := 'frmAcompanhaHistoricoProduto';
  qryPaineis.ParamByName('COMPONENTE').Value := grdPainelDBTableView1.Name;
end;

procedure TfrmAcompanhaHistoricoProduto.qryRegistrosAfterScroll(
  DataSet: TDataSet);
begin
  cxButton6.Enabled := (qryRegistrosTIPO.AsInteger in[2,3]) and (qryRegistrosDEVOLVIDO.AsInteger = 0);
end;

procedure TfrmAcompanhaHistoricoProduto.qryRegistrosBeforeOpen(DataSet: TDataSet);
begin
  qryRegistros.SQL.Strings[qryRegistros.SQL.IndexOf('--AND')+1] := Filtro();
end;

end.
