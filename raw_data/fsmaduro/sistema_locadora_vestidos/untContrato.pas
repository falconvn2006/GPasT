unit untContrato;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  Grids, Wwdbigrd, Wwdbgrid, wwdbdatetimepicker, RxLookup, ppDB, ppDBPipe,
  ppParameter, ppDesignLayer, ppVar, ppBands, ppCtrls, ppPrnabl, ppClass,
  ppCache, ppComm, ppRelatv, ppProd, ppReport, ppStrtch, ppMemo, ComCtrls,
  wwdbedit, Wwdotdot, Wwdbcomb, wwdblook, Menus, rxPlacemnt,
  cxLookAndFeelPainters, cxButtons;

type
  TfrmContrato = class(TForm)
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
    updContratoDetalhe: TIBUpdateSQL;
    dtsClientes: TDataSource;
    qryClientes: TIBQuery;
    qryClientesCODIGO: TIntegerField;
    qryClientesNOME: TIBStringField;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    qryProdutos: TIBQuery;
    qryProdutosCODIGO: TIntegerField;
    qryProdutosDESCRICAO: TIBStringField;
    qryContratoDetalheNomeProduto: TStringField;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    dtsSituacao: TDataSource;
    btnFicha: TSpeedButton;
    qryClientesTELEFONE: TIBStringField;
    qryContratoCODIGO: TIntegerField;
    qryContratoDATA: TDateField;
    qryContratoDATARESERVA: TDateField;
    qryContratoHORARESERVA: TTimeField;
    qryContratoCODIGOUSUARIO: TIntegerField;
    qryContratoCODIGOCLIENTE: TIntegerField;
    qryContratoOBSERVACOES: TIBStringField;
    qryContratoCODIGOORCAMENTO: TIntegerField;
    qryContratoCODIGOARARA: TIntegerField;
    qryContratoCODIGOSITUACAO: TIntegerField;
    qryContratoCODIGOFORMAPAGAMENTO: TIntegerField;
    qryContratoDetalheCODIGO: TIntegerField;
    qryContratoDetalheID: TIntegerField;
    qryContratoDetalheCODIGOPRODUTO: TIntegerField;
    qryContratoDetalheVALOR: TIBBCDField;
    qryFormaPagamento: TIBQuery;
    dtsFormaPagamento: TDataSource;
    qryFormaPagamentoCODIGO: TIntegerField;
    qryFormaPagamentoDESCRICAO: TIBStringField;
    qryContratoTELEFONE: TStringField;
    qryContratoNomeUsuario: TStringField;
    qryMovimentacaoContrato: TIBQuery;
    dtsMovimentacaoContrato: TDataSource;
    updMovimentacaoContrato: TIBUpdateSQL;
    qryMovimentacaoContratoCODIGO: TIntegerField;
    qryMovimentacaoContratoID: TIntegerField;
    qryMovimentacaoContratoDATA: TDateField;
    qryMovimentacaoContratoCODIGOUSUARIO: TIntegerField;
    qryMovimentacaoContratoTIPO: TIntegerField;
    qryMovimentacaoContratoCODIGOREGISTRO: TIntegerField;
    dtsAgenda: TDataSource;
    qryAgenda: TIBQuery;
    qryAgendaCODIGO: TIntegerField;
    qryAgendaDATA: TDateField;
    qryAgendaHORA: TTimeField;
    qryAgendaIDPEDIDOAGENDA: TIntegerField;
    qryAgendaIDPERFIL: TIntegerField;
    qryAgendaCODIGOPRODUTO: TIntegerField;
    qryAgendaDESCRICAO: TMemoField;
    qryAgendaDATAFIM: TDateField;
    qryAgendaHORAFIM: TTimeField;
    qryAgendaSITUACAO: TIntegerField;
    qryAgendaMOTIVOCANCELAMENTO: TIBStringField;
    qryContratoCODIGOAGENDA: TIntegerField;
    qryMovimentacaoContratoHORA: TTimeField;
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
    qryContratoDetalheCODIGONOMEPRODUTO: TIBStringField;
    qryContratoVALORTOTAL: TCurrencyField;
    qryMovimentacaoContratoNOMETIPOREGISTRO: TStringField;
    qryMovimentacaoContratoNTIPO: TIBStringField;
    qryMovimentacaoContratoDTHR: TIBStringField;
    qryContratoDATARETORNO: TDateField;
    qryContratoHORARETORNO: TTimeField;
    qryContratoDIASBLOQUEIOAUTOMATICO: TIntegerField;
    qryContratoDIASRETORNOANTECIPADO: TIntegerField;
    qryPrevisaoContrato: TIBQuery;
    dtsPrevisaoContrato: TDataSource;
    updPrevisaoContrato: TIBUpdateSQL;
    qryPrevisaoContratoCODIGO: TIntegerField;
    qryPrevisaoContratoID: TIntegerField;
    qryPrevisaoContratoTIPO: TIntegerField;
    qryPrevisaoContratoDATA: TDateField;
    qryPrevisaoContratoVALOR: TIBBCDField;
    qryPrevisaoContratoCODIGOFORMAPAGAMENTO: TIntegerField;
    qryPrevisaoContratoNomeFormaPagamento: TStringField;
    qryContratoVALORDESCONTO: TIBBCDField;
    qryPrevisaoContratoNTIPO: TStringField;
    Panel6: TPanel;
    Panel5: TPanel;
    Label30: TLabel;
    Image1: TImage;
    lblCodigo: TLabel;
    Label1: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    SpeedButton6: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton3: TSpeedButton;
    Label45: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    SpeedButton7: TSpeedButton;
    Panel2: TPanel;
    edtCodigo: TDBEdit;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    DBEdit24: TDBEdit;
    DBEdit6: TDBEdit;
    cbtipodoc: TRxDBLookupCombo;
    DBEdit1: TDBEdit;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    wwDBDateTimePicker3: TwwDBDateTimePicker;
    RxDBLookupCombo1: TRxDBLookupCombo;
    wwDBLookupCombo1: TwwDBLookupCombo;
    wwDBComboBox1: TwwDBComboBox;
    wwDBDateTimePicker4: TwwDBDateTimePicker;
    wwDBDateTimePicker5: TwwDBDateTimePicker;
    DBEdit3: TDBEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Image2: TImage;
    grdDetalhe: TwwDBGrid;
    Panel1: TPanel;
    btn_inserirProduto: TSpeedButton;
    Panel4: TPanel;
    Label10: TLabel;
    DBEdit2: TDBEdit;
    GroupBox2: TGroupBox;
    DBMemo1: TDBMemo;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    SpeedButton8: TSpeedButton;
    wwDBGrid1: TwwDBGrid;
    cmbTipo: TwwDBComboBox;
    TabSheet3: TTabSheet;
    wwDBGrid2: TwwDBGrid;
    cmbTipoPrevisao: TwwDBComboBox;
    cmbFormaPagamento: TwwDBLookupCombo;
    chbFinanceiro: TCheckBox;
    FormStorage1: TFormStorage;
    cxButton1: TcxButton;
    PopupMenu1: TPopupMenu;
    Enviaremailreferenteaoalugueldeterceiros1: TMenuItem;
    Configuraes1: TMenuItem;
    Imprimirrelatriodealugueldeterceiros1: TMenuItem;
    N1: TMenuItem;
    qryContratoVALORLIQUIDO: TCurrencyField;
    qryContratoDIASBLOQUEIOAUTOMATICOAPOS: TIntegerField;
    edtAntes: TDBEdit;
    lblAntes: TLabel;
    edtDepois: TDBEdit;
    lblDepois: TLabel;
    edtRegistro: TwwDBEdit;
    popReagendar: TPopupMenu;
    Reagendar1: TMenuItem;
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
    procedure qryContratoDetalheNewRecord(DataSet: TDataSet);
    procedure qryContratoDetalheBeforeInsert(DataSet: TDataSet);
    procedure SpeedButton6Click(Sender: TObject);
    procedure qryContratoAfterScroll(DataSet: TDataSet);
    procedure Totalizar;
    procedure qryContratoDetalheAfterOpen(DataSet: TDataSet);
    procedure btn_inserirProdutoClick(Sender: TObject);
    procedure btnFichaClick(Sender: TObject);
    procedure relOrcamentoPreviewFormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure qryMovimentacaoContratoNewRecord(DataSet: TDataSet);
    procedure qryMovimentacaoContratoAfterPost(DataSet: TDataSet);
    procedure SpeedButton8Click(Sender: TObject);
    procedure qryContratoCalcFields(DataSet: TDataSet);
    procedure wwDBGrid1DblClick(Sender: TObject);
    procedure qryContratoDetalheBeforePost(DataSet: TDataSet);
    procedure dtsMovimentacaoContratoStateChange(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure qryPrevisaoContratoNewRecord(DataSet: TDataSet);
    procedure qryPrevisaoContratoBeforeInsert(DataSet: TDataSet);
    procedure qryPrevisaoContratoAfterPost(DataSet: TDataSet);
    procedure qryPrevisaoContratoCalcFields(DataSet: TDataSet);
    procedure DBEdit2Exit(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure Enviaremailreferenteaoalugueldeterceiros1Click(Sender: TObject);
    procedure Imprimirrelatriodealugueldeterceiros1Click(Sender: TObject);
    procedure qryMovimentacaoContratoBeforeInsert(DataSet: TDataSet);
    procedure Image1DblClick(Sender: TObject);
    procedure Reagendar1Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
  cInserindo : Boolean;
  vQtdDiasBloqueiAutomatico,
  vQtdDiasBloqueiAutomaticoAcessorios: Integer;
  vEmailCopia: String;
  vTextoPadraoEmailTerceiros : String;
  vQtdDiasPagamento: Integer;

    { Public declarations }
  procedure SalvarRegistro;
  Function SomarTotalContrato:Currency;
  procedure CarregaConfiguracoes();
  procedure EnviarEmailTerceiros(EnviaEmail:Boolean);
  end;

var
  frmContrato: TfrmContrato;

implementation

uses untPesquisa, untDados, form_cadastro_perfil, untConsultaProdutos,
  form_cadastro_situacao_produto, form_cadastro_forma_pagamento,
  untOrdemServico, untAgenda, untFinanceiro, Funcao, form_principal,
  untDtmRelatorios, untCadastroAgenda, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmContrato.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmContrato.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmContrato.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmContrato.CarregaConfiguracoes();
begin
  vQtdDiasBloqueiAutomatico      := Dados.Config(frmContrato,'DIASBLOQUEIOAUTOMATICO','Quantidade de dias que o produto ficará bloqueado automaticamente após um aluguel',
                                    'Informe a quantidade de dias para bloqueio automático do produto.',5,
                                    tcInteiro).vcInteger;

  vQtdDiasBloqueiAutomaticoAcessorios      := Dados.Config(frmContrato,'DIASBLOQUEIOAUTOMATICO_ACESSORIOS','Quantidade de dias que o acessório ficará bloqueado automaticamente após um aluguel',
                                    'Informe a quantidade de dias para bloqueio automático do acessório.',1,
                                    tcInteiro).vcInteger;

  vTextoPadraoEmailTerceiros      := Dados.Config(frmContrato,'TextoPadraoEmailTerceiros','Texto padrão para o envio do de email de terceiros',
                                    'Informe a o texto padrão para envio de email quando houver aluguel de terceiros.','',
                                    tcTexto).vcString;

  vQtdDiasPagamento      := Dados.Config(frmContrato,'QTDDIASPAGAMENTOTERCEIROS','Quantidade de dias para pagamento de terceiros',
                                         'Informe a quantidade de dias para pagamento de vestido de terceiros após o recebimento do contrato.',5,
                                         tcInteiro).vcInteger;

  vEmailCopia                 := Dados.Config(frmContrato,'EMAILCOPIA','Email Cópia',
                                    'Informe a conta de email que receberá os dados do aluguel de terceiro em cópia.',
                                    '',tcTexto).vcString;
end;


procedure TfrmContrato.Configuraes1Click(Sender: TObject);
begin
  dados.ShowConfig(frmContrato);
  CarregaConfiguracoes();
end;

procedure TfrmContrato.cxButton1Click(Sender: TObject);
begin

  if not (qryContrato.State = dsEdit) then
    qryContrato.Edit;

  qryContratoCODIGOSITUACAO.AsInteger := 3;
  qryContrato.Post;

  EnviarEmailTerceiros(True);

  btnFicha.Click;
  
end;

procedure TfrmContrato.DBEdit2Exit(Sender: TObject);
begin
  Totalizar;
end;

procedure TfrmContrato.dtsContratoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
  cxButton1.Enabled := qryContratoCODIGOSITUACAO.AsInteger <> 3;
end;

procedure TfrmContrato.dtsMovimentacaoContratoStateChange(Sender: TObject);
begin
  if (qryMovimentacaoContratoCODIGOREGISTRO.AsInteger > 0) and
     (qryMovimentacaoContrato.State in [dsEdit]) then
  begin
    application.MessageBox(Pchar('Não é permitido alterar um registro com movimentação gerada!'),'',mb_OK+MB_ICONWARNING);
    qryMovimentacaoContrato.Cancel;
    Abort;
  end;
end;

procedure TfrmContrato.Enviaremailreferenteaoalugueldeterceiros1Click(
  Sender: TObject);
begin
  EnviarEmailTerceiros(True);
end;

procedure TfrmContrato.EnviarEmailTerceiros(EnviaEmail:Boolean);
var
  _Log: TStringList;
  Arquivo: String;
begin

  Dados.Geral3.Close;
  Dados.Geral3.SQL.Text := 'SELECT PE.CODIGO AS CODIGOPERFIL, PE.EMAIL1 '+
                           '  FROM TABCONTRATODETALHE D '+
                           ' INNER JOIN TABPRODUTOS P ON (D.CODIGOPRODUTO = P.CODIGO) '+
                           ' INNER JOIN TABPERFIL PE ON (P.IDPERFIL = PE.CODIGO) '+
                           ' WHERE D.CODIGO =0'+qryContratoCODIGO.Text  +
                           '   AND P.ORIGEM = ''T''  '+
                           ' GROUP BY 1,2 ';
  Dados.Geral3.Open;

  While not Dados.Geral3.Eof do
  begin

    if Dados.Geral3.FieldByName('EMAIL1').AsString <> '' then
    begin

      Arquivo := frmDtmRelatorios.ImprimirAluguelTerceiros(qryContratoCODIGO.AsInteger,Dados.Geral3.FieldByName('CODIGOPERFIL').AsInteger,
                                                           EnviaEmail, vTextoPadraoEmailTerceiros, vQtdDiasPagamento);

      if EnviaEmail then
      begin
      
        EnviarEmailAutomatico(Principal.vEmail,
                              Dados.Geral3.FieldByName('EMAIL1').AsString,
                              vEmailCopia,
                              'Aluguel AMV',
                              '',
                              nil,
                              Arquivo,
                              Principal.vSMTP,
                              Principal.vUsuarioID,
                              Principal.vSenha,
                              Principal.vResponderPara,
                              Principal.vPorta,
                              Principal.vRequerAutenticacao,
                              Principal.vUsarSSL,
                              Principal.vMetodoSSL,
                              Principal.vModoSSL,
                              Principal.vUsarTipoTLS,
                              Principal.vHost_Proxy,
                              Principal.vPorta_Proxy,
                              Principal.vUser_Proxy,
                              Principal.vSenha_Proxy,
                              True,
                              _Log);
                              
      end;

    end;

    Dados.Geral3.Next;
    
  end;
end;

procedure TfrmContrato.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryContrato.State in [dsInsert, dsEdit] then
       qryContrato.Post;
  end;
end;

procedure TfrmContrato.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.Insert;
end;

procedure TfrmContrato.btn_inserirProdutoClick(Sender: TObject);
var
  lFrmConsultaProduto: TfrmConsultaProdutos;
  QtdProdutos, i : Integer;
  cValor : Currency;
begin

  if qryContrato.State in [dsEdit,dsInsert] then
    qryContrato.Post;

  if qryContratoDetalhe.State in [dsEdit,dsInsert] then
    qryContratoDetalhe.Post;

  lFrmConsultaProduto := TfrmConsultaProdutos.Create(Self);
  Try

    lFrmConsultaProduto._porArara := False;
    lFrmConsultaProduto._porPedido := False;
    lFrmConsultaProduto._porCadastro := False;

    lFrmConsultaProduto.ShowModal;

    QtdProdutos := Length(lFrmConsultaProduto.ProdutosSelecionados);

    for i := 0 to QtdProdutos - 1 do
    begin

      dados.Geral.Close;
      dados.Geral.sql.Text := 'Select VALORALUGUEL1 from TABPRODUTOS where CODIGO = ' +intToStr(lFrmConsultaProduto.ProdutosSelecionados[i]);
      dados.Geral.Open;

      cValor := dados.Geral.FieldByName('VALORALUGUEL1').AsCurrency;

      if not qryContratoDetalhe.Active then
         qryContratoDetalhe.Open;

      qryContratoDetalhe.Insert;
      qryContratoDetalheCODIGOPRODUTO.AsInteger := lFrmConsultaProduto.ProdutosSelecionados[i];
      qryContratoDetalheVALOR.AsCurrency        := cValor;
      qryContratoDetalhe.Post;

    end;
  Finally
    FreeAndNil(lFrmConsultaProduto);
  End;

end;

procedure TfrmContrato.btnFichaClick(Sender: TObject);
var
  arrayVariaveis, arrayValores: Array of String;
  DiretorioPadrao, DiretorioSalvar, ArquivoDestino : String;
  i, x : Integer;
begin

  if Application.MessageBox('Deseja gerar o arquivo de Contrato?','Contrato',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin

    DiretorioPadrao := ExtractFileDir(Application.ExeName) + '\CONTRATOS';
    DiretorioSalvar := ExtractFileDir(Application.ExeName) + '\CONTRATOS\'+Trim(qryClientesNOME.Text);
    ArquivoDestino  := DiretorioSalvar +'\CONTRATO_'+qryContratoCODIGO.Text+'.doc';

    if not FileExists(DiretorioPadrao+'\Contrato.doc') then
    begin
      Application.MessageBox(pchar('Arquivo '+DiretorioPadrao+'\CONTRATO.doc'+' não encontrado!'),'Erro!',MB_OK+MB_ICONERROR);
      Abort;
    end;

    try

      if not DirectoryExists(DiretorioSalvar) then
        CreateDir(DiretorioSalvar);

      CopyFile(pchar(DiretorioPadrao+'\CONTRATO.doc'),pchar(ArquivoDestino),false);


      setlength(arrayVariaveis,0);
      setlength(arrayValores,0);

      for I := 0 to qryContrato.Fields.Count - 1 do
      begin
        setlength(arrayVariaveis,length(arrayVariaveis)+1);
        setlength(arrayValores,length(arrayValores)+1);

        arrayVariaveis[length(arrayVariaveis)-1] := '@@qryContrato_'+qryContrato.Fields[i].FieldName+'@@';
        arrayValores[length(arrayValores)-1]     := qryContrato.Fields[i].Text;

        if (qryContrato.Fields[i].FieldName = 'VALORDESCONTO') and (qryContrato.Fields[i].Text = '') then
           arrayValores[length(arrayValores)-1] := '0,00'
      end;

      for I := 0 to qryClientes.Fields.Count - 1 do
      begin
        setlength(arrayVariaveis,length(arrayVariaveis)+1);
        setlength(arrayValores,length(arrayValores)+1);

        arrayVariaveis[length(arrayVariaveis)-1] := '@@qryClientes_'+qryClientes.Fields[i].FieldName+'@@';
        arrayValores[length(arrayValores)-1]     := qryClientes.Fields[i].Text;
      end;


      qryContratoDetalhe.Close;
      qryContratoDetalhe.Open;

      qryContratoDetalhe.First;

      for x := 0 to 20 do
      begin

        for I := 0 to qryContratoDetalhe.Fields.Count - 1 do
        begin
          setlength(arrayVariaveis,length(arrayVariaveis)+1);
          setlength(arrayValores,length(arrayValores)+1);

          arrayVariaveis[length(arrayVariaveis)-1] := '@@qryContratoDetalhe_'+qryContratoDetalhe.Fields[i].FieldName+'_#'+IntToStr(x)+'@@';

          if not qryContratoDetalhe.Eof then
          begin
            if qryContratoDetalhe.Fields[i].FieldName = 'VALOR' then
              arrayValores[length(arrayValores)-1]     := FormatFloat('#,##0.00',qryContratoDetalhe.Fields[i].AsFloat)
            else
              arrayValores[length(arrayValores)-1]     := qryContratoDetalhe.Fields[i].AsString;

          end
          else
            arrayValores[length(arrayValores)-1]     := '';
        end;

        qryContratoDetalhe.Next;

      end;



      qryMovimentacaoContrato.Close;
      qryMovimentacaoContrato.Open;

      qryMovimentacaoContrato.First;

      for x := 0 to 20 do
      begin

        for I := 0 to qryMovimentacaoContrato.Fields.Count - 1 do
        begin

          setlength(arrayVariaveis,length(arrayVariaveis)+1);
          setlength(arrayValores,length(arrayValores)+1);

          arrayVariaveis[length(arrayVariaveis)-1] := '@@qryMovimentacaoContrato_'+qryMovimentacaoContrato.Fields[i].FieldName+'_#'+IntToStr(x)+'@@';

          if (not qryMovimentacaoContrato.Eof) and (qryMovimentacaoContratoTIPO.AsInteger in [1,2,3,4]) then
          begin
            if qryMovimentacaoContrato.Fields[i].FieldName = 'DTHR' then
              arrayValores[length(arrayValores)-1]     := FormatDateTime('DD/MM/YYYY HH:MM',qryMovimentacaoContratoDATA.AsDateTime + qryMovimentacaoContratoHORA.AsDateTime)
            else
              arrayValores[length(arrayValores)-1]     := qryMovimentacaoContrato.Fields[i].AsString
          end
          else
            arrayValores[length(arrayValores)-1]     := '';
        end;

        qryMovimentacaoContrato.Next;

      end;


      qryPrevisaoContrato.First;

      for x := 0 to 5 do
      begin

        for I := 0 to qryPrevisaoContrato.Fields.Count - 1 do
        begin

          setlength(arrayVariaveis,length(arrayVariaveis)+1);
          setlength(arrayValores,length(arrayValores)+1);
          arrayVariaveis[length(arrayVariaveis)-1] := '@@qryPre_'+qryPrevisaoContrato.Fields[i].FieldName+'_#'+IntToStr(x)+'@@';

          if not qryPrevisaoContrato.Eof then
            arrayValores[length(arrayValores)-1]     := qryPrevisaoContrato.Fields[i].Text
          else
            arrayValores[length(arrayValores)-1]     := '';

        end;

        qryPrevisaoContrato.Next;

      end;

      if Dados.Word_StringReplace(ArquivoDestino,arrayVariaveis,arrayValores,[wrfReplaceAll]) then
      begin
        if Application.MessageBox(PChar('Contrato gerado com sucesso!'+#13+'Deseja abrir o arquivo '+ArquivoDestino+'?'),'Contrato',MB_YESNO+MB_ICONQUESTION) = idyes then
          Dados.AbrirDocumentoWord(ArquivoDestino);
      end;
      
    except
      on E:Exception do
        application.MessageBox(Pchar('Erro ao criar contrato'+E.message),'ERRO',mb_OK+MB_ICONERROR);
    end;
    
  end;

end;

procedure TfrmContrato.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsContrato, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryContrato.Delete;
end;

procedure TfrmContrato.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABCONTRATO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := DBMemo1.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  //untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
  begin
    qryContrato.Close;
    qryContrato.ParamByName('Codigo').AsInteger := untPesquisa.Resultado;
    qryContrato.Open;
  end;

  dados.Log(2, 'Código: '+ qryContratoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmContrato.qryContratoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;

  Totalizar;
end;

procedure TfrmContrato.qryContratoAfterScroll(DataSet: TDataSet);
begin
    qryContratoDetalhe.Close;
    qryContratoDetalhe.Open;

    qryMovimentacaoContrato.Close;
    qryMovimentacaoContrato.Open;

    qryAgenda.Close;
    qryAgenda.Open;

    qryPrevisaoContrato.Close;
    qryPrevisaoContrato.Open;
end;

procedure TfrmContrato.qryContratoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryContratoCODIGO.Text +' Janela: '+copy(Caption,17,length(Caption)));
end;

procedure TfrmContrato.qryContratoBeforePost(DataSet: TDataSet);
begin
  IF qryContratoCODIGO.Value = 0 THEN
    qryContratoCODIGO.Value := Dados.NovoCodigo('TABCONTRATO');
  if dtsContrato.State = dsInsert then
    dados.Log(3, 'Código: '+ qryContratoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsContrato.State = dsEdit then
    dados.Log(4, 'Código: '+ qryContratoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)));

  if qryContratoDIASBLOQUEIOAUTOMATICO.AsInteger = 0 then
    qryContratoDIASBLOQUEIOAUTOMATICO.AsInteger := vQtdDiasBloqueiAutomatico;
end;                                     

procedure TfrmContrato.qryContratoCalcFields(DataSet: TDataSet);
begin

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT SUM(VALOR) AS VALORTOTAL FROM TABCONTRATODETALHE WHERE CODIGO =0'+qryContratoCODIGO.Text;
  Dados.Geral.Open;
  
  qryContratoVALORTOTAL.AsCurrency := Dados.Geral.FieldByName('VALORTOTAL').AsCurrency;
  qryContratoVALORLIQUIDO.AsCurrency := Dados.Geral.FieldByName('VALORTOTAL').AsCurrency + qryContratoVALORDESCONTO.AsCurrency;

end;

procedure TfrmContrato.qryContratoNewRecord(DataSet: TDataSet);
begin
  qryContratoCODIGO.Value := 0;
  qryContratoDATA.AsDateTime := Date;
  qryContratoCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
  qryContratoDIASBLOQUEIOAUTOMATICO.AsInteger := vQtdDiasBloqueiAutomatico;
  qryContratoDIASBLOQUEIOAUTOMATICOAPOS.AsInteger := vQtdDiasBloqueiAutomatico;
  qryContratoDIASRETORNOANTECIPADO.AsInteger  := 0;
  qryContratoCODIGOSITUACAO.AsInteger := 1;
end;

procedure TfrmContrato.qryMovimentacaoContratoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmContrato.qryMovimentacaoContratoBeforeInsert(DataSet: TDataSet);
begin
  if qryContrato.State in [dsEdit,dsInsert] then
    qryContrato.Post;
end;

procedure TfrmContrato.qryMovimentacaoContratoNewRecord(DataSet: TDataSet);
begin
  qryMovimentacaoContratoCODIGO.AsInteger := qryContratoCODIGO.AsInteger;
  qryMovimentacaoContratoID.Value := Dados.NovoCodigo('TABMOVIMENTACAOCONTRATO','ID','CODIGO = 0'+qryContratoCODIGO.Text);
  qryMovimentacaoContratoDATA.AsDateTime := Date;
  qryMovimentacaoContratoHORA.AsDateTime := Time;
  qryMovimentacaoContratoCODIGOUSUARIO.AsInteger :=  untDados.CodigoUsuarioCorrente;
end;

procedure TfrmContrato.qryPrevisaoContratoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;

  Totalizar;
end;

procedure TfrmContrato.qryPrevisaoContratoBeforeInsert(DataSet: TDataSet);
begin
  if qryContrato.State = dsInsert then
    qryContrato.Post;
end;

procedure TfrmContrato.qryPrevisaoContratoCalcFields(DataSet: TDataSet);
begin
  if qryPrevisaoContratoTIPO.AsInteger = 1 then
    qryPrevisaoContratoNTIPO.Text := 'A-Escolha'
  else
  if qryPrevisaoContratoTIPO.AsInteger = 2 then
    qryPrevisaoContratoNTIPO.Text := 'A-Prova'
  else
    qryPrevisaoContratoNTIPO.Text := 'A-Retirada';
end;

procedure TfrmContrato.qryPrevisaoContratoNewRecord(DataSet: TDataSet);
begin
  qryPrevisaoContratoCODIGO.AsInteger := qryContratoCODIGO.AsInteger;
  qryPrevisaoContratoID.Value := Dados.NovoCodigo('TABCONTRATOPREVISAO','ID','CODIGO = 0'+qryContratoCODIGO.Text);
end;

procedure TfrmContrato.Reagendar1Click(Sender: TObject);
begin
   If Application.FindComponent('frmCadastroAgenda') = Nil then
         Application.CreateForm(TfrmCadastroAgenda, frmCadastroAgenda);

  frmCadastroAgenda.ReAgendar := True;
  frmCadastroAgenda.CodigoAgenda := qryMovimentacaoContratoCODIGOREGISTRO.AsInteger;
  frmCadastroAgenda.ShowModal;

  qryMovimentacaoContrato.Close;
  qryMovimentacaoContrato.Open;

  Application.MessageBox('Reagendado com sucesso!','Terminado!',MB_OK+MB_ICONEXCLAMATION);
end;

procedure TfrmContrato.relOrcamentoPreviewFormCreate(Sender: TObject);
begin
	Dados.AjustaRelatorio(Sender);
end;

procedure TfrmContrato.qryContratoDetalheAfterOpen(DataSet: TDataSet);
begin
 Totalizar;
end;

procedure TfrmContrato.qryContratoDetalheBeforeInsert(
  DataSet: TDataSet);
begin
  if qryContrato.State = dsInsert then
    qryContrato.Post;
end;

procedure TfrmContrato.qryContratoDetalheBeforePost(DataSet: TDataSet);
begin
  if qryContrato.State in [dsEdit,dsInsert] then
    qryContrato.Post;
end;

procedure TfrmContrato.qryContratoDetalheNewRecord(DataSet: TDataSet);
begin

  qryContratoDetalheCODIGO.AsInteger := qryContratoCODIGO.AsInteger;

  qryContratoDetalheID.Value := Dados.NovoCodigo('TABCONTRATODETALHE','ID','CODIGO = 0'+qryContratoCODIGO.Text);
  
end;

procedure TfrmContrato.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryContrato.Close;
  qryContratoDetalhe.Close;
end;

procedure TfrmContrato.FormCreate(Sender: TObject);
begin
  NomeMenu := 'PaineldeContrato1';
  cInserindo := False;
  CarregaConfiguracoes();
end;

procedure TfrmContrato.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;

  lblAntes.visible := False;
  lblDepois.Visible := False;
  edtAntes.Visible := False;
  edtDepois.Visible := False;

  try
    qryClientes.Close;
    qryClientes.Open;

    qrySituacao.Close;
    qrySituacao.Open;

    qryFormaPagamento.Close;
    qryFormaPagamento.Open;

    qryContrato.Close;
    qryContrato.ParamByName('Codigo').AsInteger := 0;
    qryContrato.Open;

    if cInserindo then
      qryContrato.Insert;

    Dados.NovoRegistro(qryContrato);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmContrato.Image1DblClick(Sender: TObject);
begin
  lblAntes.visible := True;
  lblDepois.Visible := True;
  edtAntes.Visible := True;
  edtDepois.Visible := True;
end;

procedure TfrmContrato.Imprimirrelatriodealugueldeterceiros1Click(
  Sender: TObject);
begin
  EnviarEmailTerceiros(False);
end;

procedure TfrmContrato.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.First;
end;

procedure TfrmContrato.SpeedButton6Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
         Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.ShowModal;
                                              
  qryClientes.Close;
  qryClientes.Open;
end;

procedure TfrmContrato.SpeedButton7Click(Sender: TObject);
begin
  if qryContratoCODIGOAGENDA.AsInteger > 0 then
    Dados.AbrirAgenda(qryContratoCODIGOAGENDA.AsInteger);
end;

procedure TfrmContrato.SpeedButton8Click(Sender: TObject);
var
  CodigoRegistro : Integer;
  BookMark : TBookMark;
  ProdutosContrato : array of TProdutosContrato;
  i : Integer;
  cDataInicio, cDataFim : TDateTime;
begin

  if qryMovimentacaoContrato.State in [dsEdit,dsInsert] then
    qryMovimentacaoContrato.Post;

  qryMovimentacaoContrato.First;

  While not qryMovimentacaoContrato.Eof do
  begin

    if qryMovimentacaoContratoCODIGOREGISTRO.AsInteger = 0 then
    begin

      Case qryMovimentacaoContratoTIPO.AsInteger of
        1,2,3,4 :
        begin

          try


            Dados.Geral.SQL.Text := 'SELECT IDPEDIDOAGENDA '+
                                    '  FROM TABAGENDA '+
                                    ' WHERE CODIGO =0'+qryContratoCODIGOAGENDA.Text;
            Dados.Geral.Open;


            if qryMovimentacaoContratoTIPO.AsInteger in [1,2] then
            begin

              if Assigned(frmAgenda) then
                FreeAndNil(frmAgenda);

              Application.CreateForm(TfrmAgenda, frmAgenda);

              frmAgenda.cConfirmarHorario := True;

              frmAgenda.cxButton12.Caption := '&Selecionar Horário'+#13+
                                              '&Agenda'+iif(qryMovimentacaoContratoTIPO.AsInteger = 2,' de Prova','');

              frmAgenda.ShowModal;

              cDataInicio := frmAgenda.cDataHoraInicio;
              cDataFim := frmAgenda.cDataHoraFim;

            end
            else
            begin
              cDataInicio := qryMovimentacaoContratoDATA.AsDateTime + qryMovimentacaoContratoHORA.AsDateTime;
              cDataFim := cDataInicio + StrToTime('00:30');
            end;

            if cDataInicio > 0 then
            begin
              CodigoRegistro := dados.Agendar(Dados.Geral.FieldByName('IDPEDIDOAGENDA').AsInteger,
                                              qryContratoCODIGOCLIENTE.AsInteger,
                                              0,
                                              cDataInicio,
                                              cDataFim,
                                              cDataInicio,
                                              cDataFim,
                                              'Agenda gerada a partir do Contrato ' +qryContratoCODIGO.Text+'.'+ #13+
                                              cmbTipo.Text);
            end
            else
            begin
              application.MessageBox(Pchar('Não foi selecionado horário para a Agenda!'),'',mb_OK+MB_ICONWARNING);
              Abort;
            end;
          finally
            if Assigned(frmAgenda) then
              frmAgenda.cConfirmarHorario := False;
          end;
        end;

        5:
        begin
          qryContratoDetalhe.Last;
          qryContratoDetalhe.First;

          SetLength(ProdutosContrato,qryContratoDetalhe.RecordCount);

          i := 0;

          While not qryContratoDetalhe.Eof do
          begin

            ProdutosContrato[i].CodigoProduto := qryContratoDetalhe.FieldByName('CODIGOPRODUTO').AsInteger;
            ProdutosContrato[i].Valor := 0;

            inc(i);

            qryContratoDetalhe.Next;

          end;

          CodigoRegistro := Dados.InserirOrdemServico(0,0,ProdutosContrato,
                            'Ordem de serviço gerada a partir do Contrato ' +qryContratoCODIGO.Text+'.');
        end;

        6:
        begin

          CodigoRegistro := Dados.InserirFinanceiro(qryContratoCODIGOCLIENTE.AsInteger,
                                                    qryContratoCODIGOFORMAPAGAMENTO.AsInteger,
                                                    2,
                                                    qryMovimentacaoContratoDATA.AsDateTime,
                                                    qryMovimentacaoContratoDATA.AsDateTime,
                                                    0,
                                                    SomarTotalContrato,
                                                    'Financeiro gerado a partir do Contrato ' +qryContratoCODIGO.Text+'.',
                                                    qryContratoCODIGO.AsInteger,
                                                    chbFinanceiro.Checked)


        end;

      End;


      if not (qryMovimentacaoContrato.State in [dsEdit,dsInsert]) then
        qryMovimentacaoContrato.Edit;

      qryMovimentacaoContratoCODIGOREGISTRO.AsInteger := CodigoRegistro;
      qryMovimentacaoContrato.Post;


      if qryMovimentacaoContratoTIPO.AsInteger = 4 then
      begin
        qryContrato.Edit;
        qryContratoDATARETORNO.AsDateTime := cDataInicio;
        qryContratoHORARETORNO.AsDateTime := cDataInicio;
        qryContrato.Post;
      end
      else
      if qryMovimentacaoContratoTIPO.AsInteger = 3 then
      begin
        qryContrato.Edit;
        qryContratoDATARESERVA.AsDateTime := cDataInicio;
        qryContratoHORARESERVA.AsDateTime := cDataInicio;
        qryContrato.Post;
      end;

    end;

    qryMovimentacaoContrato.Next;

  end;

  qryMovimentacaoContrato.Close;
  qryMovimentacaoContrato.Open;

  Application.MessageBox('Registro gerado com sucesso!','Terminado!',MB_OK+MB_ICONEXCLAMATION);
  
end;

procedure TfrmContrato.Totalizar;
 var
   Valor : Currency;
begin

  dados.Geral.Close;
  dados.Geral.sql.Text := 'Select SUM(VALOR) AS VALOR from TABCONTRATODETALHE  where CODIGO = ' + qryContratoCODIGO.Text;
  dados.Geral.Open;

  grdDetalhe.ColumnByName('VALOR').FooterValue:= FormatFloat('#,##0.00', dados.Geral.FieldByName('VALOR').AsCurrency + qryContratoVALORDESCONTO.AsCurrency);


  TabSheet3.Caption := 'Previsão Financeira - R$ ' + FormatFloat('#,##0.00', dados.Geral.FieldByName('VALOR').AsCurrency + qryContratoVALORDESCONTO.AsCurrency);

  dados.Geral.Close;
  dados.Geral.sql.Text := 'Select SUM(VALOR) AS VALOR from TABCONTRATOPREVISAO  where CODIGO = ' + qryContratoCODIGO.Text;
  dados.Geral.Open;

  wwDBGrid2.ColumnByName('VALOR').FooterValue:= FormatFloat('#,##0.00', dados.Geral.FieldByName('VALOR').AsCurrency);

end;

procedure TfrmContrato.wwDBGrid1DblClick(Sender: TObject);
begin

  if qryMovimentacaoContratoCODIGOREGISTRO.AsInteger > 0 then
  begin

    Case qryMovimentacaoContratoTIPO.AsInteger of
    
      1,2,3,4 :
      begin
        try

          if Application.FindComponent('frmAgenda') = Nil then
            Application.CreateForm(TfrmAgenda, frmAgenda);

          frmAgenda.cConfirmarHorario := False;
          frmAgenda.Show;

          dados.Geral.Close;
          dados.Geral.sql.Text := 'Select DATA,DATAFIM from TABAGENDA where CODIGO =0' + qryMovimentacaoContratoCODIGOREGISTRO.Text;
          dados.Geral.Open;


          frmAgenda.edtDtInicial.Date := dados.Geral.FieldByName('DATA').AsDateTime;
          frmAgenda.edtDtFinal.Date := dados.Geral.FieldByName('DATAFIM').AsDateTime;
          frmAgenda.cxButton1.Click;

          frmAgenda.cxScheduler1.GoToDate(dados.Geral.FieldByName('DATA').AsDateTime);

        finally
//          FreeAndNil(frmAgenda);
        end;

      end;

      5:
      begin
        If Application.FindComponent('frmOrdemServico') = Nil then
               Application.CreateForm(TfrmOrdemServico, frmOrdemServico);

        frmOrdemServico.pubCodigo := qryMovimentacaoContratoCODIGOREGISTRO.AsInteger;

        frmOrdemServico.Show;

      end;

      6:
      begin
        If Application.FindComponent('frmFinanceiro') = Nil then
               Application.CreateForm(TfrmFinanceiro, frmFinanceiro);

        frmFinanceiro.Show;

        frmFinanceiro.QryFinanceiro.Locate('CODIGO',qryMovimentacaoContratoCODIGOREGISTRO.AsInteger,[]);
        
      end;

    End;
    
  end;

end;

procedure TfrmContrato.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.Prior;
end;

procedure TfrmContrato.SpeedButton3Click(Sender: TObject);
begin
  if Application.FindComponent('cadastro_forma_pagamento') = Nil then
    Application.CreateForm(Tcadastro_forma_pagamento, cadastro_forma_pagamento);

  cadastro_forma_pagamento.Show;

  qryFormaPagamento.Close;
  qryFormaPagamento.Open;
end;

procedure TfrmContrato.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.Next;
end;

procedure TfrmContrato.SalvarRegistro;
begin
  if dtsContrato.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryContrato.Post;
  end;
end;

function TfrmContrato.SomarTotalContrato: Currency;
begin
//
  Dados.Geral.SQL.Text := 'SELECT SUM(VALOR) AS VALOR FROM TABCONTRATODETALHE WHERE CODIGO =0'+qryContratoCODIGO.Text;
  Dados.Geral.Open;

  Result := Dados.Geral.FieldByName('VALOR').AsCurrency;
  
end;

procedure TfrmContrato.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryContrato.Last;
end;

procedure TfrmContrato.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
