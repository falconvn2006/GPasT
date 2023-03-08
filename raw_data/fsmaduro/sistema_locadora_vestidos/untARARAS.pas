unit untARARAS;

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
  TfrmARARAS = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label27: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    Label1: TLabel;
    cbPerfil: TRxDBLookupCombo;
    cbEvento: TRxDBLookupCombo;
    edtDtInicial: TwwDBDateTimePicker;
    edtDtFinal: TwwDBDateTimePicker;
    rgTipoData: TRadioGroup;
    cxButton1: TcxButton;
    btnLimpar: TcxButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    DBText1: TDBText;
    cxButton6: TcxButton;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    Panel2: TPanel;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    qryPainel: TIBQuery;
    dtsPainel: TDataSource;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    qryEvento: TIBQuery;
    IntegerField1: TIntegerField;
    IBStringField1: TIBStringField;
    dtsEvento: TDataSource;
    SaveDialog2: TSaveDialog;
    dxCompPrinterGrid: TdxComponentPrinter;
    dxCompPrinterCntLinkCnt: TdxGridReportLink;
    qryPainelCODIGO: TIntegerField;
    qryPainelPERFIL: TIBStringField;
    qryPainelDATA: TDateField;
    qryPainelHORA: TTimeField;
    qryPainelIDPEDIDOAGENDA: TIntegerField;
    qryPainelEVENTO: TIBStringField;
    qryPainelPRODUTOS: TIntegerField;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1PERFIL: TcxGridDBColumn;
    grdPainelDBTableView1DATA: TcxGridDBColumn;
    grdPainelDBTableView1HORA: TcxGridDBColumn;
    grdPainelDBTableView1IDPEDIDOAGENDA: TcxGridDBColumn;
    grdPainelDBTableView1EVENTO: TcxGridDBColumn;
    grdPainelDBTableView1PRODUTOS: TcxGridDBColumn;
    qryPainelCODIGOAGENDA: TIntegerField;
    grdPainelDBTableView1CODIGOAGENDA: TcxGridDBColumn;
    cxButton4: TcxButton;
    chbSemFoto: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure qryPainelBeforeOpen(DataSet: TDataSet);
    procedure cxButton4Click(Sender: TObject);

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
  frmARARAS: TfrmARARAS;

implementation

uses untDados, untARARA, untDtmRelatorios, funcao, versao;

Const
  cCaption = 'ACOMPANHAMENTO DE ARARAS';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmARARAS.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmARARAS.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmARARAS.btnLimparClick(Sender: TObject);
begin
  cbPerfil.KeyValue := -1;
  cbEvento.KeyValue := -1;
  edtDtInicial.Text := '';
  edtDtFinal.Text := '';
  rgTipoData.ItemIndex := 0;
end;

procedure TfrmARARAS.cxButton1Click(Sender: TObject);
begin
  qryPainel.Close;
  qryPainel.Open;
end;

procedure TfrmARARAS.cxButton2Click(Sender: TObject);
begin
  dxCompPrinterGrid.CurrentLink.Component := grdPainel;

  dxCompPrinterGrid.Preview(True,dxCompPrinterCntLinkCnt);
end;

procedure TfrmARARAS.cxButton3Click(Sender: TObject);
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

procedure TfrmARARAS.cxButton4Click(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirArara(qryPainelCODIGO.AsInteger, chbSemFoto.Checked);
end;

procedure TfrmARARAS.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmARARAS.cxButton6Click(Sender: TObject);
begin
  If Application.FindComponent('frmARARA') = Nil then
    FreeAndNil(frmARARA);
  Application.CreateForm(TfrmARARA, frmARARA);

  frmARARA.vCodigo := qryPainelCODIGO.AsInteger;

  frmARARA.ShowModal;
end;

function TfrmARARAS.Filtro(): String;
var
  vFiltro : String;
  vCampoData : String;
begin
  if cbPerfil.KeyValue > 0 then
    vFiltro := vFiltro + ' and a.codigoperfil = '+VarToStr(cbPerfil.KeyValue);

  if cbEvento.KeyValue > 0 then
    vFiltro := vFiltro + ' and pa.codigoevento = '+VarToStr(cbEvento.KeyValue);

  vCampoData := 'a.dataregistro';
  if rgTipoData.ItemIndex = 1 then
    vCampoData := 'ag.data';

  if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
    vFiltro := vFiltro + ' and '+vCampoData+' between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and '+vCampoData+' >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and '+vCampoData+' <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date));

  result := vFiltro;
end;

procedure TfrmARARAS.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmARARAS.FormCreate(Sender: TObject);
begin
  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmARARAS.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    btnLimparClick(self);

    qryPerfil.Close;
    qryPerfil.Open;

    qryEvento.Close;
    qryEvento.Open;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmARARAS.qryPainelBeforeOpen(DataSet: TDataSet);
begin
  qryPainel.SQL.Strings[qryPainel.SQL.IndexOf('--where')+1] := Filtro();
end;

end.
