unit untFinanceiro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  Grids, Wwdbigrd, Wwdbgrid, wwdbdatetimepicker, RxLookup, ppDB, ppDBPipe,
  ppParameter, ppDesignLayer, ppVar, ppBands, ppCtrls, ppPrnabl, ppClass,
  ppCache, ppComm, ppRelatv, ppProd, ppReport, ppStrtch, ppMemo, cxStyles,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData,
  cxDBLookupComboBox, cxButtonEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView,
  cxGrid, Menus, cxLookAndFeelPainters, cxButtons, cxContainer, cxGroupBox,
  cxGridBandedTableView, cxGridDBBandedTableView, wwdbedit, Wwdotdot, Wwdbcomb,
  cxCheckComboBox;

type
  TfrmFinanceiro = class(TForm)
    Label30: TLabel;
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsFinanceiro: TDataSource;
    qryFinanceiro: TIBQuery;
    updFinanceiro: TIBUpdateSQL;
    dtsFinanceiroDetalhe: TDataSource;
    qryFinanceiroDetalhe: TIBQuery;
    updFinanceiroDetalhe: TIBUpdateSQL;
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
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    Label2: TLabel;
    btnFicha: TSpeedButton;
    qryPerfilTELEFONE: TIBStringField;
    cxGroupBox1: TcxGroupBox;
    wwDBComboBox13: TwwDBComboBox;
    Label3: TLabel;
    DBMemo1: TDBMemo;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    qryFinanceiroCODIGO: TIntegerField;
    qryFinanceiroCODIGOUSUARIO: TIntegerField;
    qryFinanceiroDATA: TDateField;
    qryFinanceiroTIPO: TIntegerField;
    qryFinanceiroCODIGOCLIENTE: TIntegerField;
    qryFinanceiroOBSERVACOES: TIBStringField;
    qryFinanceiroNomeUsuario: TStringField;
    qryFinanceiroDetalheCODIGO: TIntegerField;
    qryFinanceiroDetalhePARCELA: TIntegerField;
    qryFinanceiroDetalheDATAVENCIMENTO: TDateField;
    qryFinanceiroDetalheCODIGOSITUACAO: TIntegerField;
    qryFinanceiroDetalheVALOR: TIBBCDField;
    qryFinanceiroDetalheOBSERVACOES: TIBStringField;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyleRepository2: TcxStyleRepository;
    cxStyle2: TcxStyle;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    Label4: TLabel;
    qryFinanceiroDATAEMISSAO: TDateField;
    qryFinanceiroDetalheDATAPAGAMENTO: TDateField;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1DBTableView1PARCELA: TcxGridDBColumn;
    cxGrid1DBTableView1DATAVENCIMENTO: TcxGridDBColumn;
    cxGrid1DBTableView1CODIGOSITUACAO: TcxGridDBColumn;
    cxGrid1DBTableView1VALOR: TcxGridDBColumn;
    cxGrid1DBTableView1DATAPAGAMENTO: TcxGridDBColumn;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    dtsSituacao: TDataSource;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxStyleRepository3: TcxStyleRepository;
    cxStyle3: TcxStyle;
    qryFinanceiroCODIGOFORMAPAGAMENTO: TIntegerField;
    RxDBLookupCombo1: TRxDBLookupCombo;
    Label6: TLabel;
    SpeedButton3: TSpeedButton;
    qryFormaPagamento: TIBQuery;
    qryFormaPagamentoCODIGO: TIntegerField;
    qryFormaPagamentoDESCRICAO: TIBStringField;
    dtsFormaPagamento: TDataSource;
    cxGrid1DBTableView1Column2: TcxGridDBColumn;
    cxGrid1DBTableView1Column3: TcxGridDBColumn;
    dtsTipodocumento: TDataSource;
    qryTipoDocumento: TIBQuery;
    qryTipoDocumentoCODIGO: TIntegerField;
    qryTipoDocumentoNOME: TIBStringField;
    cxGrid1DBTableView1Column4: TcxGridDBColumn;
    qryFinanceiroDetalheCODIGOTIPODOCUMENTO: TIntegerField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryFinanceiroAfterPost(DataSet: TDataSet);
    procedure qryFinanceiroBeforeDelete(DataSet: TDataSet);
    procedure qryFinanceiroBeforePost(DataSet: TDataSet);
    procedure qryFinanceiroNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsFinanceiroStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryFinanceiroDetalheNewRecord(DataSet: TDataSet);
    procedure qryFinanceiroDetalheBeforeInsert(DataSet: TDataSet);
    procedure SpeedButton6Click(Sender: TObject);
    procedure qryFinanceiroAfterScroll(DataSet: TDataSet);
    procedure cxGrid1Enter(Sender: TObject);
    procedure qryFinanceiroDetalheBeforeDelete(DataSet: TDataSet);
    procedure cxGrid1DBTableView1Column1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure btnFichaClick(Sender: TObject);
    procedure cxGrid1DBTableView1Column2PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxGrid1DBTableView1Column3PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
    pubCodigo: integer;
    cInserindo : Boolean;
    { Public declarations }
    procedure SalvarRegistro;
    procedure VerificaParcelaLiquidada(CodigoSitucao:Integer);
  end;

var
  frmFinanceiro: TfrmFinanceiro;

implementation

uses untPesquisa, untDados, form_cadastro_perfil, untConsultaProdutos,
  form_cadastro_situacao_produto, form_cadastro_Servicos, untDtmRelatorios,
  form_cadastro_forma_pagamento, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmFinanceiro.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmFinanceiro.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmFinanceiro.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFinanceiro.cxGrid1DBTableView1Column1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if Application.MessageBox('Deseja realmente excluir a Parcela?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
    qryFinanceiroDetalhe.Delete;
end;

procedure TfrmFinanceiro.cxGrid1DBTableView1Column2PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin

  if not (qryFinanceiroDetalhe.State in [dsEdit,dsInsert]) then
    qryFinanceiroDetalhe.Edit;

  if qryFinanceiroDetalheDATAPAGAMENTO.Text = '' then
    qryFinanceiroDetalheDATAPAGAMENTO.AsDateTime := Date;

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT CODIGO '+
                          '  FROM TABSITUACAOPRODUTO '+
                          ' WHERE APLICACAO = 5 '+
                          '   AND OPERACAO = 4';
  Dados.Geral.Open;

  if Dados.Geral.FieldByName('CODIGO').Text <> '' then
    qryFinanceiroDetalheCODIGOSITUACAO.Text := Dados.Geral.FieldByName('CODIGO').Text;

  qryFinanceiroDetalhe.Post;

end;

procedure TfrmFinanceiro.cxGrid1DBTableView1Column3PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin

  if not (qryFinanceiroDetalhe.State in [dsEdit,dsInsert]) then
    qryFinanceiroDetalhe.Edit;

  qryFinanceiroDetalheDATAPAGAMENTO.Text := '';

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT CODIGO '+
                          '  FROM TABSITUACAOPRODUTO ' +
                          ' WHERE APLICACAO = 5 '+
                          '   AND OPERACAO = 0';
  Dados.Geral.Open;

  if Dados.Geral.FieldByName('CODIGO').Text <> '' then
    qryFinanceiroDetalheCODIGOSITUACAO.Text := Dados.Geral.FieldByName('CODIGO').Text;

  qryFinanceiroDetalhe.Post;
  
end;

procedure TfrmFinanceiro.cxGrid1Enter(Sender: TObject);
begin
  if qryFinanceiro.State in [dsInsert, dsEdit] then
    qryFinanceiro.Post;
    
  if qryFinanceiroDetalhe.IsEmpty then
    qryFinanceiroDetalhe.Append;
end;

procedure TfrmFinanceiro.dtsFinanceiroStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmFinanceiro.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryFinanceiro.State in [dsInsert, dsEdit] then
       qryFinanceiro.Post;
  end;
end;

procedure TfrmFinanceiro.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryFinanceiro.Insert;
end;

procedure TfrmFinanceiro.btnFichaClick(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirBoleto(qryFinanceiroCODIGO.AsInteger);
end;

procedure TfrmFinanceiro.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsFinanceiro, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryFinanceiro.Delete;
end;

procedure TfrmFinanceiro.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABFINANCEIRO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := DBMemo1.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  //untPesquisa.Nome_Campo_Nome   := Label27.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryFinanceiro.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryFinanceiroCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmFinanceiro.qryFinanceiroAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmFinanceiro.qryFinanceiroAfterScroll(DataSet: TDataSet);
begin
  qryFinanceiroDetalhe.Close;
  qryFinanceiroDetalhe.Open;
end;

procedure TfrmFinanceiro.qryFinanceiroBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryFinanceiroCODIGO.Text +' Janela: '+copy(Caption,17,length(Caption)));
end;

procedure TfrmFinanceiro.qryFinanceiroBeforePost(DataSet: TDataSet);
begin
  IF qryFinanceiroCODIGO.Value = 0 THEN
    qryFinanceiroCODIGO.Value := Dados.NovoCodigo('TABFINANCEIRO');
  if dtsFinanceiro.State = dsInsert then
    dados.Log(3, 'Código: '+ qryFinanceiroCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsFinanceiro.State = dsEdit then
    dados.Log(4, 'Código: '+ qryFinanceiroCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure TfrmFinanceiro.qryFinanceiroNewRecord(DataSet: TDataSet);
begin
  qryFinanceiroCODIGO.Value := 0;
  qryFinanceiroDATA.AsDateTime := Date;
  qryFinanceiroCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
end;

procedure TfrmFinanceiro.qryFinanceiroDetalheBeforeDelete(DataSet: TDataSet);
begin
  VerificaParcelaLiquidada(qryFinanceiroDetalheCODIGOSITUACAO.AsInteger);
end;

procedure TfrmFinanceiro.qryFinanceiroDetalheBeforeInsert(
  DataSet: TDataSet);
begin
  if qryFinanceiro.State = dsInsert then
    qryFinanceiro.Post;
end;

procedure TfrmFinanceiro.qryFinanceiroDetalheNewRecord(DataSet: TDataSet);
begin

  qryFinanceiroDetalheCODIGO.AsInteger := qryFinanceiroCODIGO.AsInteger;

  qryFinanceiroDetalhePARCELA.AsInteger := Dados.NovoCodigo('TABFINANCEIRODETALHE','PARCELA','CODIGO = 0'+qryFinanceiroCODIGO.Text);

end;

procedure TfrmFinanceiro.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryFinanceiro.Close;
  qryFinanceiroDetalhe.Close;
end;

procedure TfrmFinanceiro.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Financeiro2';
  cInserindo := False;
end;

procedure TfrmFinanceiro.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryPerfil.Close;
    qryPerfil.Open;

    qryUsuario.Close;
    qryUsuario.Open;

    qrySituacao.Close;
    qrySituacao.Open;

    qryFormaPagamento.Close;
    qryFormaPagamento.Open;

    qryTipoDocumento.Close;
    qryTipoDocumento.Open;

    qryFinanceiro.Close;
    qryFinanceiro.Open;

    if cInserindo then
      qryFinanceiro.Insert;

    Dados.NovoRegistro(qryFinanceiro);

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmFinanceiro.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryFinanceiro.First;
end;

procedure TfrmFinanceiro.SpeedButton6Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
         Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.ShowModal;

  qryPerfil.Close;
  qryPerfil.Open;
end;

procedure TfrmFinanceiro.VerificaParcelaLiquidada(CodigoSitucao: Integer);
begin
//
end;

procedure TfrmFinanceiro.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryFinanceiro.Prior;
end;

procedure TfrmFinanceiro.SpeedButton3Click(Sender: TObject);
begin
  if Application.FindComponent('cadastro_forma_pagamento') = Nil then
    Application.CreateForm(Tcadastro_forma_pagamento, cadastro_forma_pagamento);

  cadastro_forma_pagamento.Show;

  qryFormaPagamento.Close;
  qryFormaPagamento.Open;
end;

procedure TfrmFinanceiro.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryFinanceiro.Next;
end;

procedure TfrmFinanceiro.SalvarRegistro;
begin
  if qryFinanceiro.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryFinanceiro.Post;
  end;
end;

procedure TfrmFinanceiro.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryFinanceiro.Last;
end;

procedure TfrmFinanceiro.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
