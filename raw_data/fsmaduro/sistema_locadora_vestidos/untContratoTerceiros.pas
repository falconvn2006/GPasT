unit untContratoTerceiros;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  Grids, Wwdbigrd, Wwdbgrid, wwdbdatetimepicker, RxLookup, ppDB, ppDBPipe,
  ppParameter, ppDesignLayer, ppVar, ppBands, ppCtrls, ppPrnabl, ppClass,
  ppCache, ppComm, ppRelatv, ppProd, ppReport, ppStrtch, ppMemo, ComCtrls,
  wwdbedit, Wwdotdot, Wwdbcomb, wwdblook, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData,
  cxButtonEdit, cxDBLookupComboBox, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView,
  cxGrid, cxContainer, cxGroupBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter;

type
  TfrmContratoTerceiros = class(TForm)
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
    dtsContrato: TDataSource;
    qryContrato: TIBQuery;
    updContrato: TIBUpdateSQL;
    dtsContratoDetalhe: TDataSource;
    qryContratoDetalhe: TIBQuery;
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
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    dtsSituacao: TDataSource;
    btnFicha: TSpeedButton;
    qryClientesTELEFONE: TIBStringField;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    RxDBLookupCombo3: TRxDBLookupCombo;
    Label45: TLabel;
    SpeedButton7: TSpeedButton;
    qryClientesDATACADASTRO: TDateField;
    qryClientesSEXO: TIBStringField;
    qryClientesNASCIMENTO: TDateField;
    qryClientesCODIGOMUNICIPIONATURALIDADE: TIntegerField;
    qryClientesESTADOCIVIL: TIntegerField;
    qryClientesCODIGOTIPODOCUMENTO: TIntegerField;
    qryClientesNUMERODOCUMENTO: TIBStringField;
    qryClientesORGAOEMISSOR: TIBStringField;
    qryClientesUFDOCUMENTO: TIBStringField;
    qryClientesCPF: TIBStringField;
    qryClientesCEP: TIBStringField;
    qryClientesNUMERO: TIntegerField;
    qryClientesCOMPLEMENTO: TIBStringField;
    qryClientesTELRESIDENCIAL: TIBStringField;
    qryClientesTELCELULAR: TIBStringField;
    qryClientesTELCOMERCIAL: TIBStringField;
    qryClientesTELRECADO: TIBStringField;
    qryClientesPESSOARECADO: TIBStringField;
    qryClientesEMAIL1: TIBStringField;
    qryClientesFACEBOOK: TIBStringField;
    qryClientesINSTAGRAM: TIBStringField;
    qryClientesWHATSAPP: TIBStringField;
    qryClientesOUTRO: TIBStringField;
    qryClientesPONTUALIDADE: TIBStringField;
    qryClientesCODIGOUSUARIO: TIntegerField;
    qryClientesCODIGOTIPOPERFIL: TIntegerField;
    qryClientesZELO: TIBStringField;
    qryClientesOBSERVACOES: TMemoField;
    qryClientesURLFOTO: TIBStringField;
    qryClientesVERCAO: TIntegerField;
    qryClientesCODIGOBANCO: TIntegerField;
    qryClientesAGENCIA: TIBStringField;
    qryClientesOPERACAO_CONTA: TIBStringField;
    qryClientesNUMERO_CONTA: TIBStringField;
    qryClientesNOME_CLIENTE: TIBStringField;
    qryClientesCPF_CLIENTE_BANCO: TIBStringField;
    qryClientesCODIGOSITUACAO: TIntegerField;
    DBEdit5: TDBEdit;
    Label12: TLabel;
    cxGroupBox1: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    qryContratoCODIGO: TIntegerField;
    qryContratoCODIGOFORNECEDOR: TIntegerField;
    qryContratoCODIGOUSUARIO: TIntegerField;
    qryContratoCODIGOSITUACAO: TIntegerField;
    qryContratoDATACADASTRO: TDateField;
    qryContratoVERSAO: TIntegerField;
    qryContratoOBSERVACOES: TIBStringField;
    qryContratoNomeUsuario: TStringField;
    qryContratoTELEFONE: TStringField;
    qryContratoDetalheDATAAQUISICAO: TDateField;
    qryContratoDetalheCODIGO: TIntegerField;
    qryContratoDetalheDESCRICAO: TIBStringField;
    qryContratoDetalheVALORALUGUEL1: TIBBCDField;
    cxGrid1DBTableView1DATAAQUISICAO: TcxGridDBColumn;
    cxGrid1DBTableView1CODIGO: TcxGridDBColumn;
    cxGrid1DBTableView1DESCRICAO: TcxGridDBColumn;
    cxGrid1DBTableView1VALORALUGUEL1: TcxGridDBColumn;
    DBMemo1: TDBMemo;
    Label2: TLabel;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryContratoAfterPost(DataSet: TDataSet);
    procedure qryContratoBeforeDelete(DataSet: TDataSet);
    procedure qryContratoBeforePost(DataSet: TDataSet);
    procedure qryContratoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsContratoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure qryContratoAfterScroll(DataSet: TDataSet);
    procedure SpeedButton7Click(Sender: TObject);
    procedure qryMovimentacaoContratoAfterPost(DataSet: TDataSet);
    procedure btnFichaClick(Sender: TObject);

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
  frmContratoTerceiros: TfrmContratoTerceiros;

implementation

uses untPesquisa, untDados, form_cadastro_perfil, untConsultaProdutos,
  form_cadastro_situacao_produto, form_cadastro_forma_pagamento,
  untOrdemServico, untAgenda, untFinanceiro, untDtmRelatorios, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmContratoTerceiros.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmContratoTerceiros.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmContratoTerceiros.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmContratoTerceiros.dtsContratoStateChange(Sender: TObject);
begin
    dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmContratoTerceiros.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryContrato.State in [dsInsert, dsEdit] then
       qryContrato.Post;
  end;
end;

procedure TfrmContratoTerceiros.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.Insert;
end;

procedure TfrmContratoTerceiros.btnFichaClick(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirContratoTerceiro(qryContratoCODIGO.AsInteger);
end;

procedure TfrmContratoTerceiros.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsContrato, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryContrato.Delete;
end;

procedure TfrmContratoTerceiros.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABCONTRATOTERCEIROS';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := DBMemo1.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  //untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryContrato.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryContratoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmContratoTerceiros.qryContratoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmContratoTerceiros.qryContratoAfterScroll(DataSet: TDataSet);
begin
  qryContratoDetalhe.Close;
  qryContratoDetalhe.Open;
end;

procedure TfrmContratoTerceiros.qryContratoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryContratoCODIGO.Text +' Janela: '+copy(Caption,17,length(Caption)));
end;

procedure TfrmContratoTerceiros.qryContratoBeforePost(DataSet: TDataSet);
begin
  IF qryContratoCODIGO.Value = 0 THEN
    qryContratoCODIGO.Value := Dados.NovoCodigo('TABCONTRATOTERCEIROS');
  if dtsContrato.State = dsInsert then
    dados.Log(3, 'Código: '+ qryContratoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsContrato.State = dsEdit then
    dados.Log(4, 'Código: '+ qryContratoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)));


  qryContratoVERSAO.AsInteger := qryContratoVERSAO.AsInteger + 1;
end;                                     

procedure TfrmContratoTerceiros.qryContratoNewRecord(DataSet: TDataSet);
begin
  qryContratoCODIGO.Value := 0;
  qryContratoDATACADASTRO.AsDateTime := Date;
  qryContratoCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
end;

procedure TfrmContratoTerceiros.qryMovimentacaoContratoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmContratoTerceiros.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryContrato.Close;
  qryContratoDetalhe.Close;
end;

procedure TfrmContratoTerceiros.FormCreate(Sender: TObject);
begin
  NomeMenu := 'PaineldeContrato1';
  cInserindo := False;
end;

procedure TfrmContratoTerceiros.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryClientes.Close;
    qryClientes.Open;

    qrySituacao.Close;
    qrySituacao.Open;

    qryContrato.Close;
    qryContrato.Open;

    if cInserindo then
      qryContrato.Insert;

    Dados.NovoRegistro(qryContrato);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmContratoTerceiros.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.First;
end;

procedure TfrmContratoTerceiros.SpeedButton6Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
    Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.ShowModal;
                                              
  qryClientes.Close;
  qryClientes.Open;
end;

procedure TfrmContratoTerceiros.SpeedButton7Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_situacao_produto') = Nil then
         Application.CreateForm(Tcadastro_situacao_produto, cadastro_situacao_produto);

  cadastro_situacao_produto.ShowModal;

  qrySituacao.Close;
  qrySituacao.Open;
end;

procedure TfrmContratoTerceiros.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.Prior;
end;

procedure TfrmContratoTerceiros.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.Next;
end;

procedure TfrmContratoTerceiros.SalvarRegistro;
begin
  if dtsContrato.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryContrato.Post;
  end;
end;

procedure TfrmContratoTerceiros.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.Last;
end;

procedure TfrmContratoTerceiros.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
