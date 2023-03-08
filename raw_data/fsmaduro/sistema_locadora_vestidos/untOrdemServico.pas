unit untOrdemServico;

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
  cxGridBandedTableView, cxGridDBBandedTableView, wwdbedit, Wwdotdot, Wwdbcomb;

type
  TfrmOrdemServico = class(TForm)
    Label30: TLabel;
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsOrdemServico: TDataSource;
    qryOrdemServico: TIBQuery;
    updOrdemServico: TIBUpdateSQL;
    dtsOrdemServicoDetalhe: TDataSource;
    qryOrdemServicoDetalhe: TIBQuery;
    updOrdemServicoDetalhe: TIBUpdateSQL;
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
    qryProdutos: TIBQuery;
    qryProdutosCODIGO: TIntegerField;
    qryProdutosDESCRICAO: TIBStringField;
    qryOrdemServicoDetalheNomeProduto: TStringField;
    SpeedButton3: TSpeedButton;
    qryServicos: TIBQuery;
    dtsServicos: TDataSource;
    DBMemo1: TDBMemo;
    Label2: TLabel;
    btnFicha: TSpeedButton;
    qryPerfilTELEFONE: TIBStringField;
    DBMemo2: TDBMemo;
    Label38: TLabel;
    wwDBDateTimePicker45: TwwDBDateTimePicker;
    Label37: TLabel;
    wwDBDateTimePicker44: TwwDBDateTimePicker;
    Label3: TLabel;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    Label4: TLabel;
    wwDBDateTimePicker3: TwwDBDateTimePicker;
    Label27: TLabel;
    DBEdit1: TDBEdit;
    lkpServico: TRxDBLookupCombo;
    Label5: TLabel;
    cxButton2: TcxButton;
    qryOrdemServicoCODIGO: TIntegerField;
    qryOrdemServicoNUMEROPRESTADOR: TIBStringField;
    qryOrdemServicoDATA: TDateField;
    qryOrdemServicoCODIGOPERFIL: TIntegerField;
    qryOrdemServicoCODIGOSERVICO: TIntegerField;
    qryOrdemServicoDATAINICIO: TDateField;
    qryOrdemServicoHORAINICIO: TTimeField;
    qryOrdemServicoDATAFIM: TDateField;
    qryOrdemServicoHORAFIM: TTimeField;
    qryOrdemServicoOBSERVACOES: TMemoField;
    qryOrdemServicoSITUACAO: TIntegerField;
    qryOrdemServicoCODIGOUSUARIO: TIntegerField;
    qryOrdemServicoNomeUsuario: TStringField;
    cxGroupBox1: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1Level1: TcxGridLevel;
    btn_inserirProduto: TSpeedButton;
    qryOrdemServicoDetalheCODIGOOS: TIntegerField;
    qryOrdemServicoDetalheID: TIntegerField;
    qryOrdemServicoDetalheCODIGOPRODUTO: TIntegerField;
    qryOrdemServicoDetalheVALORSERVICO: TIBBCDField;
    cxGrid1DBBandedTableView1: TcxGridDBBandedTableView;
    cxGrid1DBBandedTableView1ID: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1CODIGOPRODUTO: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1VALORSERVICO: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1NomeProduto: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyleRepository2: TcxStyleRepository;
    cxStyle2: TcxStyle;
    qryServicosCODIGO: TIntegerField;
    qryServicosDECRICAO: TIBStringField;
    qryServicosDETALHAMENTO: TMemoField;
    Label6: TLabel;
    wwDBComboBox1: TwwDBComboBox;
    qryOrdemServicoCODIGOAGENDA: TIntegerField;
    Label7: TLabel;
    DBEdit2: TDBEdit;
    qryOrdemServicoDetalheDATAFIM: TDateField;
    qryOrdemServicoDetalheHORAFIM: TTimeField;
    cxGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn;
    qryOrdemServicoDETALHAMENTO: TStringField;
    qryOrdemServicoDetalheCODIGOSERVICO: TIntegerField;
    qryOrdemServicoDetalheNOMESERVICO: TStringField;
    cxGrid1DBBandedTableView1CODIGOSERVICO: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1NOMESERVICO: TcxGridDBBandedColumn;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryOrdemServicoAfterPost(DataSet: TDataSet);
    procedure qryOrdemServicoBeforeDelete(DataSet: TDataSet);
    procedure qryOrdemServicoBeforePost(DataSet: TDataSet);
    procedure qryOrdemServicoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsOrdemServicoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryOrdemServicoDetalheNewRecord(DataSet: TDataSet);
    procedure qryOrdemServicoDetalheBeforeInsert(DataSet: TDataSet);
    procedure SpeedButton6Click(Sender: TObject);
    procedure qryOrdemServicoAfterScroll(DataSet: TDataSet);
    procedure btn_inserirProdutoClick(Sender: TObject);
    procedure relOrcamentoPreviewFormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxGrid1DBBandedTableView1Column1PropertiesButtonClick(
      Sender: TObject; AButtonIndex: Integer);
    procedure qryOrdemServicoBeforeOpen(DataSet: TDataSet);
    procedure qryOrdemServicoBeforeEdit(DataSet: TDataSet);
    procedure btnFichaClick(Sender: TObject);
    procedure lkpServicoChange(Sender: TObject);

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
    procedure ValidaAlteracaoData;
  end;

var
  frmOrdemServico: TfrmOrdemServico;

implementation

uses untPesquisa, untDados, form_cadastro_perfil, untConsultaProdutos,
  form_cadastro_situacao_produto, form_cadastro_Servicos, untDtmRelatorios,
  funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmOrdemServico.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmOrdemServico.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmOrdemServico.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOrdemServico.cxButton2Click(Sender: TObject);
begin
  SalvarRegistro;

  if qryOrdemServicoSITUACAO.AsInteger <> 1 then
  begin
    application.MessageBox('Somente é Permitido Agendar para Ordem de Serviço "EM ABERTO"!','Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;
end;

procedure TfrmOrdemServico.cxGrid1DBBandedTableView1Column1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if qryOrdemServicoSITUACAO.AsInteger <> 1 then
  begin
    application.MessageBox('Somente é Permitido Remover Produto em Ordem de Serviço "EM ABERTO"!','Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;

  if Application.MessageBox('Deseja Remover Produto?','Remover',MB_YESNO+MB_ICONQUESTION) = idyes then
    qryOrdemServicoDetalhe.Delete;
end;

procedure TfrmOrdemServico.dtsOrdemServicoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmOrdemServico.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryOrdemServico.State in [dsInsert, dsEdit] then
       qryOrdemServico.Post;
  end;
end;

procedure TfrmOrdemServico.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryOrdemServico.Insert;
end;

procedure TfrmOrdemServico.btn_inserirProdutoClick(Sender: TObject);
var
  lFrmConsultaProduto: TfrmConsultaProdutos;
  QtdProdutos, i : Integer;
//  cValor : Currency;
//  Retorno,
  Msg : String;
  lCodigoServico: Integer;
begin

  Msg := '';

  SalvarRegistro;

  if qryOrdemServico.State in [dsEdit, dsInsert] then
  begin
    application.MessageBox('Ordem de Serviço não Salva!'#13+
                           'Para Inserir Produtos Grave a Ordem de Serviço.','Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;

  if qryOrdemServicoSITUACAO.AsInteger <> 1 then
  begin
    application.MessageBox('Somente é Permitido Inserir Produtos em Ordem de Serviço "EM ABERTO"!','Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;


  lFrmConsultaProduto := TfrmConsultaProdutos.Create(Self);
  Try

    lFrmConsultaProduto.ShowModal;

    QtdProdutos := Length(lFrmConsultaProduto.ProdutosSelecionados);

//    for i := 0 to QtdProdutos - 1 do
//    begin
//
//      Retorno := Dados.RetornaSituacaoProduto(qryOrdemServicoDATAINICIO.AsDateTime + qryOrdemServicoHORAINICIO.AsDateTime,
//                                              qryOrdemServicoDATAFIM.AsDateTime + qryOrdemServicoHORAFIM.AsDateTime,
//                                              lFrmConsultaProduto.ProdutosSelecionados[i]);
//
//      if Trim(Retorno) <> '' then
//        Msg := Msg + Retorno + #13;
//
//    end;
//
//    if Msg <> '' then
//    begin
//      application.MessageBox(PChar(Msg),'Erro!',MB_OK+MB_ICONERROR);
//
//      Abort;
//    end;

    lCodigoServico := dados.DigitarValorBD('Selecione o Serviço',
                                           'TABSERVICO',
                                           qryOrdemServicoCODIGOSERVICO.AsInteger,
                                           'DECRICAO',
                                           'CODIGO',
                                           '');

    if lCodigoServico <= 0 then
    begin
      application.MessageBox('Serviço inválido!','Erro!',MB_OK+MB_ICONERROR);
      Abort;
    end;

    for i := 0 to QtdProdutos - 1 do
    begin

      qryOrdemServicoDetalhe.Insert;
      qryOrdemServicoDetalheCODIGOPRODUTO.AsInteger  := lFrmConsultaProduto.ProdutosSelecionados[i];
      qryOrdemServicoDetalheCODIGOSERVICO.AsInteger  := lCodigoServico;
      qryOrdemServicoDetalheVALORSERVICO.AsCurrency  := 0;
      qryOrdemServicoDetalhe.Post;

    end;
  Finally
    FreeAndNil(lFrmConsultaProduto);
  End;

end;

procedure TfrmOrdemServico.btnFichaClick(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirOS(qryOrdemServicoCODIGO.AsInteger);
end;

procedure TfrmOrdemServico.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsOrdemServico, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryOrdemServicoDetalhe.Delete;
end;

procedure TfrmOrdemServico.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABOS';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := DBEdit1.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := Label27.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryOrdemServicoDetalhe.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryOrdemServicoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmOrdemServico.qryOrdemServicoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmOrdemServico.qryOrdemServicoAfterScroll(DataSet: TDataSet);
begin
  qryOrdemServicoDetalhe.Close;
  qryOrdemServicoDetalhe.Open;
end;

procedure TfrmOrdemServico.qryOrdemServicoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryOrdemServicoCODIGO.Text +' Janela: '+copy(Caption,17,length(Caption)));
end;

procedure TfrmOrdemServico.qryOrdemServicoBeforeEdit(DataSet: TDataSet);
begin
  if qryOrdemServicoSITUACAO.AsInteger <> 1 then
  begin
    application.MessageBox('Somente é Permitido Alterar Ordem de Serviço "EM ABERTO"!','Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;
end;

procedure TfrmOrdemServico.qryOrdemServicoBeforeOpen(DataSet: TDataSet);
begin
  if pubCodigo > 0 then
    qryOrdemServico.Params[0].AsInteger := pubCodigo
  else
    qryOrdemServico.Params[0].AsInteger := -1;
end;

procedure TfrmOrdemServico.qryOrdemServicoBeforePost(DataSet: TDataSet);
begin
  IF qryOrdemServicoCODIGO.Value = 0 THEN
    qryOrdemServicoCODIGO.Value := Dados.NovoCodigo('TABOS');
  if dtsOrdemServico.State = dsInsert then
    dados.Log(3, 'Código: '+ qryOrdemServicoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsOrdemServico.State = dsEdit then
    dados.Log(4, 'Código: '+ qryOrdemServicoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)));


  ValidaAlteracaoData;

end;

procedure TfrmOrdemServico.qryOrdemServicoNewRecord(DataSet: TDataSet);
begin
  qryOrdemServicoCODIGO.Value := 0;
  qryOrdemServicoSITUACAO.Value := 1;
  qryOrdemServicoDATA.AsDateTime := Date;
  qryOrdemServicoCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
end;

procedure TfrmOrdemServico.relOrcamentoPreviewFormCreate(Sender: TObject);
begin
	Dados.AjustaRelatorio(Sender);
end;

procedure TfrmOrdemServico.lkpServicoChange(Sender: TObject);
begin
   if (lkpServico.KeyValue > 0) and (qryOrdemServicoDETALHAMENTO.Text = '') then
      begin
      qryServicos.Locate('CODIGO',qryOrdemServicoCODIGOSERVICO.AsInteger, []);
      qryOrdemServicoDETALHAMENTO.AsString := qryServicosDETALHAMENTO.AsString;
      end;

end;

procedure TfrmOrdemServico.qryOrdemServicoDetalheBeforeInsert(
  DataSet: TDataSet);
begin
  if qryOrdemServico.State = dsInsert then
    qryOrdemServico.Post;
end;

procedure TfrmOrdemServico.qryOrdemServicoDetalheNewRecord(DataSet: TDataSet);
begin

  qryOrdemServicoDetalheCODIGOOS.AsInteger := qryOrdemServicoCODIGO.AsInteger;

  qryOrdemServicoDetalheID.Value := Dados.NovoCodigo('TABOSDETALHE','ID','CODIGOOS = 0'+qryOrdemServicoCODIGO.Text);
  
end;

procedure TfrmOrdemServico.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryOrdemServico.Close;
  qryOrdemServicoDetalhe.Close;
end;

procedure TfrmOrdemServico.FormCreate(Sender: TObject);
begin
  NomeMenu := 'OrdemServico';
  cInserindo := False;
end;

procedure TfrmOrdemServico.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryPerfil.Close;
    qryPerfil.Open;

    qryServicos.Close;
    qryServicos.Open;

    qryUsuario.Close;
    qryUsuario.Open;

    qryProdutos.Close;
    qryProdutos.Open;

    qryOrdemServico.Close;
    qryOrdemServico.Open;

    if cInserindo then
      qryOrdemServico.Insert;

    Dados.NovoRegistro(qryOrdemServico);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmOrdemServico.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrdemServico.First;
end;

procedure TfrmOrdemServico.SpeedButton6Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
         Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.ShowModal;

  qryPerfil.Close;
  qryPerfil.Open;
end;

procedure TfrmOrdemServico.ValidaAlteracaoData;
var
  Retorno, Msg: String;
begin

  qryOrdemServicoDetalhe.First;

  While not qryOrdemServicoDetalhe.Eof do
  begin

    Retorno := Dados.RetornaSituacaoProduto(qryOrdemServicoDATAINICIO.AsDateTime + qryOrdemServicoHORAINICIO.AsDateTime,
                                            qryOrdemServicoDATAFIM.AsDateTime + qryOrdemServicoHORAFIM.AsDateTime,
                                            qryOrdemServicoDetalheCODIGOPRODUTO.AsInteger);

    if Trim(Retorno) <> '' then
      Msg := Msg + Retorno + #13;

    qryOrdemServicoDetalhe.Next;

  end;

  if Msg <> '' then
  begin
    application.MessageBox(PChar(Msg),'Erro!',MB_OK+MB_ICONERROR);

    Abort;
  end;

end;

procedure TfrmOrdemServico.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrdemServico.Prior;
end;

procedure TfrmOrdemServico.SpeedButton3Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Tipo_Servicos') = Nil then
         Application.CreateForm(Tcadastro_Tipo_Servicos, cadastro_Tipo_Servicos);

  cadastro_Tipo_Servicos.Show;

  qryServicos.Close;
  qryServicos.Open;
end;

procedure TfrmOrdemServico.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrdemServico.Next;
end;

procedure TfrmOrdemServico.SalvarRegistro;
begin
  if qryOrdemServico.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryOrdemServico.Post;
  end;
end;

procedure TfrmOrdemServico.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrdemServico.Last;
end;

procedure TfrmOrdemServico.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
