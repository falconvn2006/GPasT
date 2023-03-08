unit untAcompanhaPedidoAgenda;

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
  TfrmAcompanhaPedidoAgenda = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Label27: TLabel;
    cbPerfil: TRxDBLookupCombo;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    qryEvento: TIBQuery;
    IntegerField1: TIntegerField;
    IBStringField1: TIBStringField;
    qryTipoConvidado: TIBQuery;
    IntegerField15: TIntegerField;
    IBStringField2: TIBStringField;
    dtsTipoConvidado: TDataSource;
    dtsEvento: TDataSource;
    Label36: TLabel;
    cbEvento: TRxDBLookupCombo;
    Label39: TLabel;
    cbTipoConvidado: TRxDBLookupCombo;
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
    qryPainelCODIGO: TIntegerField;
    qryPainelDATACADASTRO: TDateField;
    qryPainelCODIGOPERFIL: TIntegerField;
    qryPainelNOMEPERFIL: TIBStringField;
    qryPainelNOMETIPOCONVIDADO: TIBStringField;
    qryPainelNOMEEVENTO: TIBStringField;
    qryPainelAGENDADO: TIntegerField;
    qryPainelQTDEACOMPANHANTES: TIntegerField;
    qryPainelDATAEVENTO: TDateField;
    qryPainelHORAEVENDO: TTimeField;
    btnLimpar: TcxButton;
    SaveDialog2: TSaveDialog;
    dxCompPrinterGrid: TdxComponentPrinter;
    Panel3: TPanel;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1DATACADASTRO: TcxGridDBColumn;
    grdPainelDBTableView1AGENDADO: TcxGridDBColumn;
    grdPainelDBTableView1CODIGOPERFIL: TcxGridDBColumn;
    grdPainelDBTableView1NOMEPERFIL: TcxGridDBColumn;
    grdPainelDBTableView1QTDEACOMPANHANTES: TcxGridDBColumn;
    grdPainelDBTableView1DATAEVENTO: TcxGridDBColumn;
    grdPainelDBTableView1HORAEVENDO: TcxGridDBColumn;
    grdPainelDBTableView1NOMEEVENTO: TcxGridDBColumn;
    grdPainelDBTableView1NOMETIPOCONVIDADO: TcxGridDBColumn;
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
    qryPainelDiasParaEvento: TIntegerField;
    qryPainelAlerta: TStringField;
    grdPainelDBTableView1DiasParaEvento: TcxGridDBColumn;
    grdPainelDBTableView1Alerta: TcxGridDBColumn;
    cxButton8: TcxButton;
    qryPainelDATAMELHORDIA: TDateField;
    qryPainelHORAMELHORDIA: TTimeField;
    grdPainelDBTableView1DATAMELHORDIA: TcxGridDBColumn;
    grdPainelDBTableView1HORAMELHORDIA: TcxGridDBColumn;
    qryPainelCONTATO: TIBStringField;
    qryPainelTELEFONECONTATO: TIBStringField;
    qryPainelEMAILCONTATO: TIBStringField;
    grdPainelDBTableView1CONTATO: TcxGridDBColumn;
    grdPainelDBTableView1TELEFONECONTATO: TcxGridDBColumn;
    grdPainelDBTableView1EMAILCONTATO: TcxGridDBColumn;
    qryPainelLOCALEVENTO: TIBStringField;
    qryPainelHORARIOEVENTO: TIBStringField;
    grdPainelDBTableView1LOCALEVENTO: TcxGridDBColumn;
    grdPainelDBTableView1HORARIOEVENTO: TcxGridDBColumn;
    qryPainelPROXIMADATAAGENDA: TDateField;
    grdPainelDBTableView1PROXIMADATAAGENDA: TcxGridDBColumn;
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
    procedure qryPainelCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure btnCriar1Click(Sender: TObject);
    procedure btnExcluir1Click(Sender: TObject);
    procedure qryPaineisBeforeOpen(DataSet: TDataSet);
    procedure cmbRelatorio1Exit(Sender: TObject);

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
  frmAcompanhaPedidoAgenda: TfrmAcompanhaPedidoAgenda;

implementation

uses form_cadastro_pedido_agenda, untConsultaProdutos, Funcao,
  untAgendarPedido, versao;

const
  NomeMenu = 'AcompanhaPedidoAgenda';
  cCaption = 'ACOMPANHAMENTO DE PEDIDO DE AGENDA';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAcompanhaPedidoAgenda.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAcompanhaPedidoAgenda.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAcompanhaPedidoAgenda.CarregaConfiguracoes();
begin
  vDiasUrgente      := Dados.Config(frmAcompanhaPedidoAgenda,'DIASURGENTE','Número de Dias para Pedido com Urgencia',
                                    'Informe o número de dias para que o pedido seja Alertado como URGENTE.',15,
                                    tcInteiro).vcInteger;
  vDiasAlerta       := Dados.Config(frmAcompanhaPedidoAgenda,'DIASALERTA','Número de Dias para Pedido como Em Aletra',
                                    'Informe o número de dias para que o pedido seja Alertado como EM ALERTA.',30,
                                    tcInteiro).vcInteger;
  vDiasMuitoUrgente := Dados.Config(frmAcompanhaPedidoAgenda,'DIASMUITOURGENTE','Número de Dias para Pedido com Muita Urgencia',
                                    'Informe o número de dias para que o pedido seja Alertado como MUITO URGENTE.',7,
                                    tcInteiro).vcInteger;
end;

procedure TfrmAcompanhaPedidoAgenda.cmbRelatorio1Exit(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
    Dados.SelecionarModeloPainel(grdPainelDBTableView1,cmbRelatorio1.EditValue);
end;

procedure TfrmAcompanhaPedidoAgenda.btnCriar1Click(Sender: TObject);
begin
  Dados.CriarModeloPainel('frmAcompanhaPedidoAgenda',grdPainelDBTableView1);

  qryPaineis.Close;
  qryPaineis.Open;
end;

procedure TfrmAcompanhaPedidoAgenda.btnExcluir1Click(Sender: TObject);
begin
  if cmbRelatorio1.EditValue > 0 then
  begin
    Dados.ExcluirModeloPainel(cmbRelatorio1.EditValue);

    qryPaineis.Close;
    qryPaineis.Open;
  end;
end;

procedure TfrmAcompanhaPedidoAgenda.btnLimparClick(Sender: TObject);
begin
  cbPerfil.KeyValue := -1;
  cbEvento.KeyValue := -1;
  cbTipoConvidado.KeyValue := -1;
  edtDtInicial.Text := '';
  edtDtFinal.Text := '';
  rgTipoData.ItemIndex := 0;
end;

procedure TfrmAcompanhaPedidoAgenda.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure TfrmAcompanhaPedidoAgenda.FormCreate(Sender: TObject);
begin
  CarregaConfiguracoes();
  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAcompanhaPedidoAgenda.Configuraes1Click(Sender: TObject);
begin
  dados.ShowConfig(frmAcompanhaPedidoAgenda);
  CarregaConfiguracoes();
end;

procedure TfrmAcompanhaPedidoAgenda.cxButton1Click(Sender: TObject);
begin
  qryPainel.Close;
  qryPainel.Open;
end;

procedure TfrmAcompanhaPedidoAgenda.cxButton2Click(Sender: TObject);
begin
  ImprimirGrid(grdPainel,'Painel de Pedido de Agenda');
end;

procedure TfrmAcompanhaPedidoAgenda.cxButton3Click(Sender: TObject);
begin
  ExportarGrid(grdPainel);
end;

procedure TfrmAcompanhaPedidoAgenda.cxButton4Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_pedido_agenda') = Nil then
         Application.CreateForm(Tcadastro_pedido_agenda, cadastro_pedido_agenda);

  cadastro_pedido_agenda.pubNovoPedido := True;

  cadastro_pedido_agenda.Show;
end;

procedure TfrmAcompanhaPedidoAgenda.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcompanhaPedidoAgenda.cxButton6Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_pedido_agenda') = Nil then
         Application.CreateForm(Tcadastro_pedido_agenda, cadastro_pedido_agenda);

  cadastro_pedido_agenda.pubCodigo := qryPainelCODIGO.AsInteger;

  cadastro_pedido_agenda.Show;
end;

procedure TfrmAcompanhaPedidoAgenda.cxButton7Click(Sender: TObject);
begin
  Dados.Geral.SQL.Text := 'select * '+
    '    from tabpedidoagendamento p '+
    '    left join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '+
    '   where a.tipoagendamento = 1 '+
    '     and p.codigo = '+IntToStr(qryPainelCODIGO.AsInteger)+
    '     and Exists(Select ag.codigo from tabagenda ag where ag.idpedidoagenda = p.codigo and ag.idperfil = a.codigoperfil and ag.situacao <> 2)';

  Dados.Geral.Open;

  if not Dados.Geral.IsEmpty then
  begin
    application.MessageBox('Pedido Já Agendado!','Agendamento',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;

  If Application.FindComponent('frmAgendarPedido') = Nil then
    FreeAndNil(frmAgendarPedido);
  Application.CreateForm(TfrmAgendarPedido, frmAgendarPedido);

  frmAgendarPedido.CodigoPedido := qryPainelCODIGO.AsInteger;
  frmAgendarPedido.DataEvento   := qryPainelDATAEVENTO.AsDateTime;

  frmAgendarPedido.ShowModal;
end;

procedure TfrmAcompanhaPedidoAgenda.cxButton8Click(Sender: TObject);
var
  lFrmConsultaProduto: TfrmConsultaProdutos;
begin
  lFrmConsultaProduto := TfrmConsultaProdutos.Create(Self);
  Try
     lFrmConsultaProduto.ShowModal;
  Finally
    FreeAndNil(lFrmConsultaProduto);
  End;
end;

function TfrmAcompanhaPedidoAgenda.Filtro(): String;
var
  vFiltro : String;
  vCampoData : String;
begin
  if cbPerfil.KeyValue > 0 then
    vFiltro := vFiltro + ' and p.codigoperfil = '+VarToStr(cbPerfil.KeyValue);

  if cbEvento.KeyValue > 0 then
    vFiltro := vFiltro + ' and p.codigoevento = '+VarToStr(cbEvento.KeyValue);

  if cbTipoConvidado.KeyValue > 0 then
    vFiltro := vFiltro + ' and p.codigotipoconvidado = '+VarToStr(cbTipoConvidado.KeyValue);

  vCampoData := 'p.datacadastro';
  if rgTipoData.ItemIndex = 1 then
    vCampoData := 'p.dataevento'
  else if rgTipoData.ItemIndex = 2 then
    vCampoData := 'p.datamelhordia';     

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

procedure TfrmAcompanhaPedidoAgenda.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    btnLimparClick(self);

    qryPerfil.Close;
    qryPerfil.Open;

    qryEvento.Close;
    qryEvento.Open;

    qryTipoConvidado.Close;
    qryTipoConvidado.Open;

    qryPaineis.Close;
    qryPaineis.Open;
    
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmAcompanhaPedidoAgenda.qryPaineisBeforeOpen(DataSet: TDataSet);
begin
  qryPaineis.ParamByName('TELA').Value := 'frmAcompanhaPedidoAgenda';
  qryPaineis.ParamByName('COMPONENTE').Value := grdPainelDBTableView1.Name;
end;

procedure TfrmAcompanhaPedidoAgenda.qryPainelBeforeOpen(DataSet: TDataSet);
begin
  qryPainel.SQL.Strings[qryPainel.SQL.IndexOf('--where')+1] := Filtro();
end;

procedure TfrmAcompanhaPedidoAgenda.qryPainelCalcFields(DataSet: TDataSet);
begin
  qryPainelDiasParaEvento.AsInteger := Trunc(qryPainelDATAEVENTO.AsDateTime - Now);
  if qryPainelDiasParaEvento.AsInteger <= vDiasMuitoUrgente then
    qryPainelAlerta.Text := 'MUITO URGENTE'
  else if qryPainelDiasParaEvento.AsInteger <= vDiasUrgente then
    qryPainelAlerta.Text := 'URGENTE'
  else if qryPainelDiasParaEvento.AsInteger <= vDiasAlerta then
    qryPainelAlerta.Text := 'ALERTA'
  else
    qryPainelAlerta.Text := 'NORMAL';
end;

end.
