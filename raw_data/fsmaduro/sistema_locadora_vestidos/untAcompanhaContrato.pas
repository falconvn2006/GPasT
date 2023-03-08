unit untAcompanhaContrato;

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
  TfrmAcompanhaContrato = class(TForm)
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
    qryContrato: TIBQuery;
    dtsOrcamento: TDataSource;
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
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1DATA: TcxGridDBColumn;
    grdPainelDBTableView1OBSERVACOES: TcxGridDBColumn;
    grdPainelDBTableView1NOMESITUACAO: TcxGridDBColumn;
    grdPainelDBTableView1NOMECLIENTE: TcxGridDBColumn;
    grdPainelDBTableView1TELEFONE: TcxGridDBColumn;
    grdPainelDBTableView1USERNAME: TcxGridDBColumn;
    grdPainelDBTableView1VALOR: TcxGridDBColumn;
    grdPainelDBTableView1Column1: TcxGridDBColumn;
    qryContratoTIPO: TIBStringField;
    qryContratoCODIGO: TIntegerField;
    qryContratoDATA: TDateField;
    qryContratoCODIGOCLIENTE: TIntegerField;
    qryContratoCODIGOUSUARIO: TIntegerField;
    qryContratoCODIGOSITUACAO: TIntegerField;
    qryContratoOBSERVACOES: TIBStringField;
    qryContratoCODIGOORCAMENTO: TIntegerField;
    qryContratoVALOR: TIBBCDField;
    qryContratoNOMESITUACAO: TIBStringField;
    qryContratoNOMECLIENTE: TIBStringField;
    qryContratoTELEFONE: TIBStringField;
    qryContratoUSERNAME: TIBStringField;
    rgTipo: TRadioGroup;
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
    qryContratoVALORDESCONTO: TIBBCDField;
    qryContratoVALORLIQUIDO: TIBBCDField;
    grdPainelDBTableView1VALORDESCONTO: TcxGridDBColumn;
    grdPainelDBTableView1VALORLIQUIDO: TcxGridDBColumn;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryContratoBeforeOpen(DataSet: TDataSet);
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
    vDiasUrgente, vDiasAlerta, vDiasMuitoUrgente: Integer;
    function Filtro(): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAcompanhaContrato: TfrmAcompanhaContrato;

implementation

uses form_cadastro_pedido_agenda, untConsultaProdutos,
  untAgendarPedido, untAcompanhaPedidoAgenda, untOrcamento, untContrato,
  untDtmRelatorios, Funcao, untContratoTerceiros, versao;

const
   NomeMenu = 'PaineldeContrato1';
   cCaption = 'ACOMPANHAMENTO DE CONTRATO';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAcompanhaContrato.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAcompanhaContrato.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAcompanhaContrato.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmAcompanhaContrato.FormCreate(Sender: TObject);
begin
  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAcompanhaContrato.btnCriar1Click(Sender: TObject);
begin
  Dados.CriarModeloPainel('frmAcompanhaContrato',grdPainelDBTableView1);

  qryPaineis.Close;
  qryPaineis.Open;
end;

procedure TfrmAcompanhaContrato.btnExcluir1Click(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cmbRelatorio1.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaContrato.cmbRelatorio1Exit(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
    Dados.SelecionarModeloPainel(grdPainelDBTableView1,cmbRelatorio1.EditValue);
end;

procedure TfrmAcompanhaContrato.Configuraes1Click(Sender: TObject);
begin
 dados.ShowConfig(frmAcompanhaContrato);
end;

procedure TfrmAcompanhaContrato.cxButton1Click(Sender: TObject);
begin
  qryContrato.Close;
  qryContrato.Open;
end;

procedure TfrmAcompanhaContrato.cxButton2Click(Sender: TObject);
begin
  ImprimirGrid(grdPainel,'Painel de Contrato');
end;

procedure TfrmAcompanhaContrato.cxButton3Click(Sender: TObject);
begin
  ExportarGrid(grdPainel);
end;

procedure TfrmAcompanhaContrato.cxButton4Click(Sender: TObject);
begin

  if qryContratoCODIGO.Text <> '' then
  begin

    if rgTipo.ItemIndex = 0 then
    begin

      if Assigned(frmContrato) then
        FreeAndNil(frmContrato);

      Application.CreateForm(TfrmContrato, frmContrato);

      frmContrato.Show;

      frmContrato.qryContrato.Close;
      frmContrato.qryContrato.ParamByName('CODIGO').AsInteger := qryContratoCODIGO.AsInteger;
      frmContrato.qryContrato.Open;

    end
    else
    begin

      if Assigned(frmContratoTerceiros) then
        FreeAndNil(frmContratoTerceiros);

      Application.CreateForm(TfrmContratoTerceiros, frmContratoTerceiros);

      frmContratoTerceiros.Show;

      frmContratoTerceiros.qryContrato.Locate('CODIGO',qryContratoCODIGO.AsInteger,[]);
    end;

  end;

end;

procedure TfrmAcompanhaContrato.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcompanhaContrato.cxButton6Click(Sender: TObject);
begin

  if rgTipo.ItemIndex = 0 then
  begin
    If Application.FindComponent('frmContrato') = Nil then
           Application.CreateForm(TfrmContrato, frmContrato);

    frmContrato.cInserindo := True;

    frmContrato.ShowModal;
  end
  else
  begin
  
    If Application.FindComponent('frmContratoTerceiros') = Nil then
           Application.CreateForm(TfrmContratoTerceiros, frmContratoTerceiros);

    frmContratoTerceiros.cInserindo := True;

    frmContratoTerceiros.Show;
    
  end;
end;

function TfrmAcompanhaContrato.Filtro(): String;
var
  vFiltro : String;
  vCampoData : String;
begin
  if cbPerfil.KeyValue > 0 then
    vFiltro := vFiltro + ' and x.codigocliente = '+VarToStr(cbPerfil.KeyValue);

  if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
    vFiltro := vFiltro + ' and x.data between '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+
                 QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and x.data >= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and x.data <= '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date));

  if rgTipo.ItemIndex = 0 then
    vFiltro := vFiltro + ' and x.tipo = ''próprio'' '
  else
    vFiltro := vFiltro + ' and x.tipo = ''terceiros'' ';

  result := vFiltro;
end;

procedure TfrmAcompanhaContrato.FormShow(Sender: TObject);
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

procedure TfrmAcompanhaContrato.qryContratoBeforeOpen(DataSet: TDataSet);
begin
  qryContrato.SQL.Strings[qryContrato.SQL.IndexOf('--and')+1] := Filtro();
end;

procedure TfrmAcompanhaContrato.qryPaineisBeforeOpen(DataSet: TDataSet);
begin
  qryPaineis.ParamByName('TELA').Value := 'frmAcompanhaContrato';
  qryPaineis.ParamByName('COMPONENTE').Value := grdPainelDBTableView1.Name;
end;

end.
