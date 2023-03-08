unit untAcompanhaPrevistoRealizado;

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
  dxPSCore, dxPScxCommon, dxPScxGrid6Lnk, DBCtrls;

type
  TfrmAcompanhaPrevistoRealizado = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Label38: TLabel;
    edtDtInicial: TwwDBDateTimePicker;
    Label1: TLabel;
    edtDtFinal: TwwDBDateTimePicker;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    qryRegistros: TIBQuery;
    dtsRegistros: TDataSource;
    SaveDialog2: TSaveDialog;
    dxCompPrinterGrid: TdxComponentPrinter;
    Panel3: TPanel;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    qryRegistrosCODIGO: TIBStringField;
    qryRegistrosNOME: TIBStringField;
    qryRegistrosANOMES: TIBStringField;
    qryRegistrosMES: TIBStringField;
    qryRegistrosVALORPREVISTO: TIBBCDField;
    qryRegistrosNATUREZA: TIBStringField;
    qryRegistrosSALDO: TIBBCDField;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1NOME: TcxGridDBColumn;
    grdPainelDBTableView1ANOMES: TcxGridDBColumn;
    grdPainelDBTableView1MES: TcxGridDBColumn;
    grdPainelDBTableView1VALORPREVISTO: TcxGridDBColumn;
    grdPainelDBTableView1NATUREZA: TcxGridDBColumn;
    grdPainelDBTableView1TIPO: TcxGridDBColumn;
    grdPainelDBTableView1SALDO: TcxGridDBColumn;
    qryRegistrosCODIGOAPURACAO: TIntegerField;
    grdPainelDBTableView2: TcxGridDBTableView;
    grdPainelDBTableView2DATA: TcxGridDBColumn;
    grdPainelDBTableView2VALORDEBITO: TcxGridDBColumn;
    grdPainelDBTableView2VALORCREDITO: TcxGridDBColumn;
    grdPainelDBTableView2SALDO: TcxGridDBColumn;
    grdPainelDBTableView2DESCRICAO: TcxGridDBColumn;
    grdPainelDBTableView2OBSERVACAO: TcxGridDBColumn;
    grdPainelDBTableView3: TcxGridDBTableView;
    grdPainelDBTableView3DATA: TcxGridDBColumn;
    grdPainelDBTableView3VALORDEBITO: TcxGridDBColumn;
    grdPainelDBTableView3VALORCREDITO: TcxGridDBColumn;
    grdPainelDBTableView3SALDO: TcxGridDBColumn;
    grdPainelDBTableView3DESCRICAO: TcxGridDBColumn;
    grdPainelDBTableView3OBSERVACAO: TcxGridDBColumn;
    grdPainelDBTableView3CHAVE: TcxGridDBColumn;
    grdPainelDBTableView3ID: TcxGridDBColumn;
    qryRegistrosCONTAMAE: TIBStringField;
    qryRegistrosNOMECONTAMAE: TIBStringField;
    qryRegistrosPERCENTUAL: TIBBCDField;
    grdPainelDBTableView1Column1: TcxGridDBColumn;
    grdPainelDBTableView1Column2: TcxGridDBColumn;
    grdPainelDBTableView1Column3: TcxGridDBColumn;
    dtsRegistrosDetalhe: TDataSource;
    qryRegistrosDetalhe: TIBQuery;
    qryRegistrosDetalheID: TIntegerField;
    qryRegistrosDetalheDATA: TDateField;
    qryRegistrosDetalheVALORDEBITO: TIBBCDField;
    qryRegistrosDetalheVALORCREDITO: TIBBCDField;
    qryRegistrosDetalheSALDO: TIBBCDField;
    qryRegistrosDetalheDESCRICAO: TIBStringField;
    qryRegistrosDetalheOBSERVACAO: TIBStringField;
    grdPainelLevel2: TcxGridLevel;
    grdPainelDBTableView4: TcxGridDBTableView;
    qryRegistrosDetalheCODIGOAPURACAO: TIntegerField;
    grdPainelDBTableView4DATA: TcxGridDBColumn;
    grdPainelDBTableView4VALORDEBITO: TcxGridDBColumn;
    grdPainelDBTableView4VALORCREDITO: TcxGridDBColumn;
    grdPainelDBTableView4SALDO: TcxGridDBColumn;
    grdPainelDBTableView4DESCRICAO: TcxGridDBColumn;
    grdPainelDBTableView4OBSERVACAO: TcxGridDBColumn;
    qryRegistrosCHAVE: TIBStringField;
    qryRegistrosDetalheCHAVE: TIBStringField;
    qryRegistrosNOMECONTACONTABIL: TIBStringField;
    qryRegistrosTIPO: TIBStringField;
    qryRegistrosDIFERENCA: TIBBCDField;
    grdPainelDBTableView1Column4: TcxGridDBColumn;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryRegistrosBeforeOpen(DataSet: TDataSet);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);

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
  frmAcompanhaPrevistoRealizado: TfrmAcompanhaPrevistoRealizado;

implementation

uses untdados, form_cadastro_pedido_agenda, untConsultaProdutos,
  untAgendarPedido, untAcompanhaPedidoAgenda, untOrcamento, untContrato,
  untDtmRelatorios, Funcao, untContratoTerceiros, versao;

const
   NomeMenu = 'AcompanhamentoPrevistoRealizado1';
   cCaption = 'ACOMPANHAMENTO PREVISTO / REALIZADO';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAcompanhaPrevistoRealizado.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAcompanhaPrevistoRealizado.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAcompanhaPrevistoRealizado.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmAcompanhaPrevistoRealizado.FormCreate(Sender: TObject);
begin
   CarregarImagem(Image1,'topo_painel.png');
   Caption := CaptionTela(cCaption);
end;

procedure TfrmAcompanhaPrevistoRealizado.Configuraes1Click(Sender: TObject);
begin
 dados.ShowConfig(frmAcompanhaPrevistoRealizado);
end;

procedure TfrmAcompanhaPrevistoRealizado.cxButton1Click(Sender: TObject);
begin
  try
    qryRegistros.Close;
    qryRegistros.Open;

    qryRegistrosDetalhe.Close;
    qryRegistrosDetalhe.Open;    
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro 4871.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmAcompanhaPrevistoRealizado.cxButton2Click(Sender: TObject);
begin
  ExpandViewGroups(grdPainelDBTableView1);

  ImprimirGrid(grdPainel,'Painel Previsto/Realizado',False);
end;

procedure TfrmAcompanhaPrevistoRealizado.cxButton3Click(Sender: TObject);
begin
  ExportarGrid(grdPainel);
end;

procedure TfrmAcompanhaPrevistoRealizado.cxButton5Click(Sender: TObject);
begin
  Close;
end;

function TfrmAcompanhaPrevistoRealizado.Filtro(): String;
var
  vFiltro : String;
  vCampoData : String;
begin

  if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
    vFiltro := vFiltro + ' and D.data between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and D.data >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and D.data <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date));

  result := vFiltro;
end;

procedure TfrmAcompanhaPrevistoRealizado.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
end;

procedure TfrmAcompanhaPrevistoRealizado.qryRegistrosBeforeOpen(DataSet: TDataSet);
begin
  qryRegistros.SQL.Strings[qryRegistros.SQL.IndexOf('--AND')+1] := Filtro();
end;

end.
