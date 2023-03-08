unit untOrcamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  Grids, Wwdbigrd, Wwdbgrid, wwdbdatetimepicker, RxLookup, ppDB, ppDBPipe,
  ppParameter, ppDesignLayer, ppVar, ppBands, ppCtrls, ppPrnabl, ppClass,
  ppCache, ppComm, ppRelatv, ppProd, ppReport, ppStrtch, ppMemo;

type
  TfrmOrcamento = class(TForm)
    Label30: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsOrcamento: TDataSource;
    qryOrcamento: TIBQuery;
    updOrcamento: TIBUpdateSQL;
    Image1: TImage;
    GroupBox1: TGroupBox;
    grdDetalhe: TwwDBGrid;
    dtsOrcamentoDetalhe: TDataSource;
    qryOrcamentoDetalhe: TIBQuery;
    updOrcamentoDetalhe: TIBUpdateSQL;
    edtCodigo: TDBEdit;
    lblCodigo: TLabel;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    Label1: TLabel;
    Label17: TLabel;
    DBEdit24: TDBEdit;
    DBEdit6: TDBEdit;
    cbtipodoc: TRxDBLookupCombo;
    Label19: TLabel;
    SpeedButton6: TSpeedButton;
    dtsClientes: TDataSource;
    qryClientes: TIBQuery;
    qryClientesCODIGO: TIntegerField;
    qryClientesNOME: TIBStringField;
    qryOrcamentoCODIGO: TIntegerField;
    qryOrcamentoDATACADASTRO: TDateField;
    qryOrcamentoCODIGOUSUARIO: TIntegerField;
    qryOrcamentoCODIGOCLIENTE: TIntegerField;
    qryOrcamentoOBSERVACOES: TIBStringField;
    qryOrcamentoDetalheCODIGO: TIntegerField;
    qryOrcamentoDetalheID: TIntegerField;
    qryOrcamentoDetalheCODIGOPRODUTO: TIntegerField;
    qryOrcamentoDetalheVALOR: TIBBCDField;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    qryProdutos: TIBQuery;
    qryProdutosCODIGO: TIntegerField;
    qryProdutosDESCRICAO: TIBStringField;
    qryOrcamentoNomeUsuario: TStringField;
    qryOrcamentoDetalheNomeProduto: TStringField;
    qryOrcamentoCODIGOSITUACAO: TIntegerField;
    qryOrcamentoCODIGOPEDIDO: TIntegerField;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    dtsSituacao: TDataSource;
    DBMemo1: TDBMemo;
    Label2: TLabel;
    Panel1: TPanel;
    btn_inserirProduto: TSpeedButton;
    btnFicha: TSpeedButton;
    qryOrcamentoNOMCLIENTE: TIBStringField;
    qryClientesTELEFONE: TIBStringField;
    qryOrcamentoTELEFONE: TStringField;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    RxDBLookupCombo1: TRxDBLookupCombo;
    Label6: TLabel;
    SpeedButton3: TSpeedButton;
    qryOrcamentoCODIGOFORMAPAGAMENTO: TIntegerField;
    qryFormaPagamento: TIBQuery;
    qryFormaPagamentoCODIGO: TIntegerField;
    qryFormaPagamentoDESCRICAO: TIBStringField;
    dtsFormaPagamento: TDataSource;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryOrcamentoAfterPost(DataSet: TDataSet);
    procedure qryOrcamentoBeforeDelete(DataSet: TDataSet);
    procedure qryOrcamentoBeforePost(DataSet: TDataSet);
    procedure qryOrcamentoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsOrcamentoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryOrcamentoDetalheNewRecord(DataSet: TDataSet);
    procedure qryOrcamentoDetalheBeforeInsert(DataSet: TDataSet);
    procedure SpeedButton6Click(Sender: TObject);
    procedure qryOrcamentoAfterScroll(DataSet: TDataSet);
    procedure Totalizar;
    procedure qryOrcamentoDetalheAfterOpen(DataSet: TDataSet);
    procedure btn_inserirProdutoClick(Sender: TObject);
    procedure btnFichaClick(Sender: TObject);
    procedure relOrcamentoPreviewFormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
  cInserindo : Boolean;
    { Public declarations }
  procedure SalvarRegistro;
  end;

var
  frmOrcamento: TfrmOrcamento;

implementation

uses untPesquisa, untDados, form_cadastro_perfil, untConsultaProdutos,
  form_cadastro_situacao_produto, untDtmRelatorios,
  form_cadastro_forma_pagamento, funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmOrcamento.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmOrcamento.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmOrcamento.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOrcamento.dtsOrcamentoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmOrcamento.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryOrcamento.State in [dsInsert, dsEdit] then
       qryOrcamento.Post;
  end;
end;

procedure TfrmOrcamento.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.Insert;
end;

procedure TfrmOrcamento.btn_inserirProdutoClick(Sender: TObject);
var
  QtdProdutos, i : Integer;
  cValor : Currency;
  lFrmConsultaProduto: TfrmConsultaProdutos;
begin
  lFrmConsultaProduto := TfrmConsultaProdutos.Create(Self);
  Try

    lFrmConsultaProduto.ShowModal;

    QtdProdutos := Length(lFrmConsultaProduto.ProdutosSelecionados);

    for i := 0 to QtdProdutos - 1 do
    begin

      dados.Geral.Close;
      dados.Geral.sql.Text := 'Select VALOR1 from TABPRODUTOS where CODIGO = ' +intToStr(lFrmConsultaProduto.ProdutosSelecionados[i]);
      dados.Geral.Open;

      cValor := dados.Geral.FieldByName('VALOR1').AsCurrency;

      qryOrcamentoDetalhe.Insert;
      qryOrcamentoDetalheCODIGOPRODUTO.AsInteger := lFrmConsultaProduto.ProdutosSelecionados[i];
      qryOrcamentoDetalheVALOR.AsCurrency        := cValor;
      qryOrcamentoDetalhe.Post;

    end;
  Finally
    FreeAndNil(lFrmConsultaProduto);
  End;

end;

procedure TfrmOrcamento.btnFichaClick(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirOrcamento(qryOrcamentoCODIGO.AsInteger);
end;

procedure TfrmOrcamento.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsOrcamento, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryOrcamento.Delete;
end;

procedure TfrmOrcamento.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABORCAMENTO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := DBMemo1.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  //untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryOrcamento.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryOrcamentoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmOrcamento.qryOrcamentoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;

  Totalizar;
end;

procedure TfrmOrcamento.qryOrcamentoAfterScroll(DataSet: TDataSet);
begin
  qryOrcamentoDetalhe.Close;
  qryOrcamentoDetalhe.Open;
end;

procedure TfrmOrcamento.qryOrcamentoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryOrcamentoCODIGO.Text +' Janela: '+copy(Caption,17,length(Caption)));
end;

procedure TfrmOrcamento.qryOrcamentoBeforePost(DataSet: TDataSet);
begin
  IF qryOrcamentoCODIGO.Value = 0 THEN
    qryOrcamentoCODIGO.Value := Dados.NovoCodigo('TABORCAMENTO');
  if dtsOrcamento.State = dsInsert then
    dados.Log(3, 'Código: '+ qryOrcamentoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsOrcamento.State = dsEdit then
    dados.Log(4, 'Código: '+ qryOrcamentoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure TfrmOrcamento.qryOrcamentoNewRecord(DataSet: TDataSet);
begin
  qryOrcamentoCODIGO.Value := 0;
  qryOrcamentoDATACADASTRO.AsDateTime := Date;
  qryOrcamentoCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
end;

procedure TfrmOrcamento.relOrcamentoPreviewFormCreate(Sender: TObject);
begin
	Dados.AjustaRelatorio(Sender);
end;

procedure TfrmOrcamento.qryOrcamentoDetalheAfterOpen(DataSet: TDataSet);
begin
 Totalizar;
end;

procedure TfrmOrcamento.qryOrcamentoDetalheBeforeInsert(
  DataSet: TDataSet);
begin
  if qryOrcamento.State = dsInsert then
    qryOrcamento.Post;
end;

procedure TfrmOrcamento.qryOrcamentoDetalheNewRecord(DataSet: TDataSet);
begin

  qryOrcamentoDetalheCODIGO.AsInteger := qryOrcamentoCODIGO.AsInteger;

  qryOrcamentoDetalheID.Value := Dados.NovoCodigo('TABORCAMENTODETALHE','ID','CODIGO = 0'+qryOrcamentoCODIGO.Text);
  
end;

procedure TfrmOrcamento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryOrcamento.Close;
  qryOrcamentoDetalhe.Close;
end;

procedure TfrmOrcamento.FormCreate(Sender: TObject);
begin
  NomeMenu := 'PaineldeOramento1';
  cInserindo := False;
end;

procedure TfrmOrcamento.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryClientes.Close;
    qryClientes.Open;

    qrySituacao.Close;
    qrySituacao.Open;

    qryOrcamento.Close;
    qryOrcamento.Open;

    qryFormaPagamento.Close;
    qryFormaPagamento.Open;

    if cInserindo then
      qryOrcamento.Insert;

    Dados.NovoRegistro(qryOrcamento);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmOrcamento.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.First;
end;

procedure TfrmOrcamento.SpeedButton6Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
         Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.Show;

  qryClientes.Close;
  qryClientes.Open;
end;

procedure TfrmOrcamento.Totalizar;
 var
   Valor : Currency;
begin

  dados.Geral.Close;
  dados.Geral.sql.Text := 'Select SUM(VALOR) AS VALOR from TABORCAMENTODETALHE  where CODIGO = ' + qryOrcamentoCODIGO.Text;
  dados.Geral.Open;

  grdDetalhe.ColumnByName('VALOR').FooterValue:= FormatFloat('#,##0.00', dados.Geral.FieldByName('VALOR').AsCurrency);
  
end;

procedure TfrmOrcamento.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.Prior;
end;

procedure TfrmOrcamento.SpeedButton3Click(Sender: TObject);
begin
  if Application.FindComponent('cadastro_forma_pagamento') = Nil then
    Application.CreateForm(Tcadastro_forma_pagamento, cadastro_forma_pagamento);

  cadastro_forma_pagamento.Show;

  qryFormaPagamento.Close;
  qryFormaPagamento.Open;
end;

procedure TfrmOrcamento.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.Next;
end;

procedure TfrmOrcamento.SalvarRegistro;
begin
  if dtsOrcamento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryOrcamento.Post;
  end;
end;

procedure TfrmOrcamento.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.Last;
end;

procedure TfrmOrcamento.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
