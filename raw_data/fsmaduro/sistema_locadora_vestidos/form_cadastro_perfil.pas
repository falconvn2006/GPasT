unit form_cadastro_perfil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  ppDB, ppComm, ppRelatv, ppDBPipe, RxLookup, RxDBComb, wwdbdatetimepicker,
  wwdbedit, Grids, Wwdbigrd, Wwdbgrid, ExtDlgs, DateUtils, ACBrBase, ACBrSocket,
  ACBrCEP, ComCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxDBData, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, cxGridDBTableView, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  Tcadastro_perfil = class(TForm)
    lblCodigo: TLabel;
    Label30: TLabel;
    edtCodigo: TDBEdit;
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    Image1: TImage;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    Label1: TLabel;
    lblNome: TLabel;
    edtNome: TDBEdit;
    Label35: TLabel;
    cbSexo: TRxDBComboBox;
    Label4: TLabel;
    Label15: TLabel;
    cbprofissao: TRxDBLookupCombo;
    SpeedButton3: TSpeedButton;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    qryCidadeUF: TIBQuery;
    qryCidadeUFCODIGO: TIntegerField;
    qryCidadeUFNOME: TIBStringField;
    qryCidadeUFUF: TIBStringField;
    pipCidadeUF: TppDBPipeline;
    Label8: TLabel;
    RxDBLookupCombo1: TRxDBLookupCombo;
    Label9: TLabel;
    DBEdit4: TDBEdit;
    SpeedButton8: TSpeedButton;
    SpeedButton11: TSpeedButton;
    opdFoto: TOpenPictureDialog;
    Bevel1: TBevel;
    Label12: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Label17: TLabel;
    dtsBanco: TDataSource;
    qryBanco: TIBQuery;
    qryBancoCODIGO: TIntegerField;
    qryBancoNOME: TIBStringField;
    DBEdit24: TDBEdit;
    DBEdit26: TDBEdit;
    Label44: TLabel;
    updCidadeUF: TIBUpdateSQL;
    qryCidadeUFDATACADASTRO: TDateField;
    RxDBLookupCombo3: TRxDBLookupCombo;
    Label45: TLabel;
    PageControl1: TPageControl;
    tbsGerais: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label19: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    SpeedButton6: TSpeedButton;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    SpeedButton7: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    SpeedButton9: TSpeedButton;
    Label18: TLabel;
    Label36: TLabel;
    SpeedButton12: TSpeedButton;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    SpeedButton13: TSpeedButton;
    wwDBEdit1: TwwDBEdit;
    Panel1: TPanel;
    cbtipodoc: TRxDBLookupCombo;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    Panel3: TPanel;
    DBEdit12: TDBEdit;
    edtCEP: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit20: TDBEdit;
    cbcidade: TRxDBLookupCombo;
    Panel4: TPanel;
    DBEdit18: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    wwDBGrid1: TwwDBGrid;
    Panel5: TPanel;
    Panel7: TPanel;
    RxDBLookupCombo2: TRxDBLookupCombo;
    DBEdit7: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit25: TDBEdit;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilDATACADASTRO: TDateField;
    qryPerfilNOME: TIBStringField;
    qryPerfilSEXO: TIBStringField;
    qryPerfilNASCIMENTO: TDateField;
    qryPerfilCODIGOMUNICIPIONATURALIDADE: TIntegerField;
    qryPerfilESTADOCIVIL: TIntegerField;
    qryPerfilCODIGOTIPODOCUMENTO: TIntegerField;
    qryPerfilNUMERODOCUMENTO: TIBStringField;
    qryPerfilORGAOEMISSOR: TIBStringField;
    qryPerfilUFDOCUMENTO: TIBStringField;
    qryPerfilCPF: TIBStringField;
    qryPerfilCEP: TIBStringField;
    qryPerfilNUMERO: TIntegerField;
    qryPerfilCOMPLEMENTO: TIBStringField;
    qryPerfilTELRESIDENCIAL: TIBStringField;
    qryPerfilTELCELULAR: TIBStringField;
    qryPerfilTELCOMERCIAL: TIBStringField;
    qryPerfilTELRECADO: TIBStringField;
    qryPerfilPESSOARECADO: TIBStringField;
    qryPerfilEMAIL1: TIBStringField;
    qryPerfilFACEBOOK: TIBStringField;
    qryPerfilINSTAGRAM: TIBStringField;
    qryPerfilWHATSAPP: TIBStringField;
    qryPerfilOUTRO: TIBStringField;
    qryPerfilPONTUALIDADE: TIBStringField;
    qryPerfilCODIGOUSUARIO: TIntegerField;
    qryPerfilCODIGOTIPOPERFIL: TIntegerField;
    qryPerfilZELO: TIBStringField;
    qryPerfilOBSERVACOES: TMemoField;
    qryPerfilURLFOTO: TIBStringField;
    qryPerfilVERCAO: TIntegerField;
    qryPerfilNomeUsuario: TStringField;
    qryPerfilCODIGOBANCO: TIntegerField;
    qryPerfilAGENCIA: TIBStringField;
    qryPerfilOPERACAO_CONTA: TIBStringField;
    qryPerfilNUMERO_CONTA: TIBStringField;
    qryPerfilNOME_CLIENTE: TIBStringField;
    qryPerfilCPF_CLIENTE_BANCO: TIBStringField;
    qryPerfilIDADE: TIntegerField;
    qryPerfilCODIGOSITUACAO: TIntegerField;
    udpPerfil: TIBUpdateSQL;
    pipTipoPerfil: TppDBPipeline;
    pipProfissaoppField1: TppField;
    pipProfissaoppField2: TppField;
    dtsTipoPerfil: TDataSource;
    qryTipoPerfil: TIBQuery;
    IntegerField1: TIntegerField;
    qryTipoPerfilDESCRICAO: TIBStringField;
    qryTipoPerfilTIPO: TIntegerField;
    dtsTipodocumento: TDataSource;
    qryTipoDocumento: TIBQuery;
    qryTipoDocumentoCODIGO: TIntegerField;
    qryTipoDocumentoNOME: TIBStringField;
    pipTipoDocumento: TppDBPipeline;
    pipTipoDocumentoppField1: TppField;
    pipTipoDocumentoppField2: TppField;
    dtsCep: TDataSource;
    qryCep: TIBQuery;
    qryCepCEP: TIBStringField;
    qryCepENDERECO: TIBStringField;
    qryCepBAIRRO: TIBStringField;
    qryCepCODIGOMUNICIPIO: TIntegerField;
    dtsCidadeUF: TDataSource;
    udpCep: TIBUpdateSQL;
    pipCep: TppDBPipeline;
    dtsCidadeUFNaturalidade: TDataSource;
    qryCidadeUFNaturalidade: TIBQuery;
    IntegerField2: TIntegerField;
    IBStringField2: TIBStringField;
    IBStringField3: TIBStringField;
    pipCidadeUFNaturalidade: TppDBPipeline;
    dtsPessoaManequim: TDataSource;
    qryPessoaManequim: TIBQuery;
    qryPessoaManequimDESCRICAO: TIBStringField;
    qryPessoaManequimVALOR: TIBBCDField;
    qryPessoaManequimOBSERVACAO: TIBStringField;
    pipPessoaManequim: TppDBPipeline;
    dtsPessoasPreferencias: TDataSource;
    qryPessoaPreferencias: TIBQuery;
    qryPessoaPreferenciasDESCRICAO: TIBStringField;
    pipPessoasPreferencias: TppDBPipeline;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    dtsUsuario: TDataSource;
    ACBrCEP: TACBrCEP;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    dtsSituacao: TDataSource;
    tbsSituacao: TTabSheet;
    dtsAvaliacaoPerfil: TDataSource;
    qryAvaliacaoPerfil: TIBQuery;
    qryAvaliacaoPerfilCODIGOORIGEM: TIntegerField;
    qryAvaliacaoPerfilCODIGOAVALIACAO: TIntegerField;
    qryAvaliacaoPerfilVALOR: TIBBCDField;
    qryAvaliacaoPerfilDESCRICAO: TStringField;
    qryAvaliacaoPerfilDESCRICAORESULTADO: TStringField;
    qryAvaliacao: TIBQuery;
    qryAvaliacaoDESCRICAO: TIBStringField;
    qryAvaliacaoDESCRIACAOAVALIACAO: TIBStringField;
    qryAvaliacaoCODIGOAVALIACAO: TIntegerField;
    qryAvaliacaoID: TIntegerField;
    qryAvaliacaoVALOR: TIBBCDField;
    btnBloqueado: TSpeedButton;
    qryHistorico: TIBQuery;
    dtsHistorico: TDataSource;
    cxGrid1: TcxGrid;
    cxGrid1DBBandedTableView1: TcxGridDBBandedTableView;
    cxGrid1DBBandedTableView1DATA: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1HORA: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1DATAFIM: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1HORAFIM: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1CODIGOSITUACAO: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1NOMESITUACAO: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1USERNAME: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1CODIGOQUESTIONARIO: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1OBSERVACOES: TcxGridDBBandedColumn;
    cxGrid1Level1: TcxGridLevel;
    dtsHistoricoDetalhe: TDataSource;
    qryHistoricoDetalhe: TIBQuery;
    qryHistoricoCODIGOORIGEM: TIntegerField;
    qryHistoricoID: TIntegerField;
    qryHistoricoTIPO: TIntegerField;
    qryHistoricoDATA: TDateField;
    qryHistoricoHORA: TTimeField;
    qryHistoricoCODIGOSITUACAO: TIntegerField;
    qryHistoricoDESCRICAOSITUACAO: TIBStringField;
    qryHistoricoDATAFIM: TDateField;
    qryHistoricoHORAFIM: TTimeField;
    qryHistoricoCODIGOUSUARIO: TIntegerField;
    qryHistoricoHISTORICOTRANSFERENCIA: TIBStringField;
    qryHistoricoCODIGOQUESTIONARIO: TIntegerField;
    qryHistoricoUSERNAME: TIBStringField;
    qryHistoricoNOMESITUACAO: TIBStringField;
    qryHistoricoOBSERVACOES: TIBStringField;
    DBEdit27: TDBEdit;
    Label46: TLabel;
    qryPerfilPONTUACAO: TIntegerField;
    cxGrid1Level2: TcxGridLevel;
    qryHistoricoDetalheCODIGO: TIntegerField;
    qryHistoricoDetalheDESCRICAOAVALIACAO: TIBStringField;
    qryHistoricoDetalheVALOR: TIBBCDField;
    qryHistoricoDetalheDESCRICAORESULTADO: TIBStringField;
    cxGrid1DBBandedTableView2: TcxGridDBBandedTableView;
    cxGrid1DBBandedTableView2CODIGO: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView2DESCRICAOAVALIACAO: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView2VALOR: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView2DESCRICAORESULTADO: TcxGridDBBandedColumn;
    qryHistoricoDetalheCODIGOREGISTRO: TIntegerField;
    qryHistoricoCODIGOREGISTRO: TIntegerField;
    TabSheet1: TTabSheet;
    Label47: TLabel;
    DBMemo1: TDBMemo;
    TabSheet2: TTabSheet;
    Panel6: TPanel;
    Label11: TLabel;
    btnPeca: TSpeedButton;
    btnModelo: TSpeedButton;
    btnMarca: TSpeedButton;
    btnEstilo: TSpeedButton;
    btnCor: TSpeedButton;
    btnExigencia: TSpeedButton;
    SpeedButton10: TSpeedButton;
    lbPreferncias: TListBox;
    PageControl3: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    qryPerfilPREFERENCIAS: TIBStringField;
    qryPerfilINFOCOMPLEMENTO: TIBStringField;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    btnConsumo: TSpeedButton;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryPerfilAfterPost(DataSet: TDataSet);
    procedure qryPerfilBeforeDelete(DataSet: TDataSet);
    procedure qryPerfilBeforePost(DataSet: TDataSet);
    procedure qryPerfilNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsPerfilStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure qryPerfilCEPValidate(Sender: TField);
    procedure qryPessoaPreferenciasAfterOpen(DataSet: TDataSet);
    procedure SpeedButton11Click(Sender: TObject);
    procedure qryPerfilAfterScroll(DataSet: TDataSet);
    procedure btnPecaClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure qryPerfilCalcFields(DataSet: TDataSet);
    procedure SpeedButton14Click(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure ACBrCEPBuscaEfetuada(Sender: TObject);
    procedure edtCEPEnter(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure qryAvaliacaoPerfilBeforeOpen(DataSet: TDataSet);
    procedure PageControl1Change(Sender: TObject);
    procedure RxDBLookupCombo3Enter(Sender: TObject);
    procedure RxDBLookupCombo3Exit(Sender: TObject);
    procedure btnBloqueadoClick(Sender: TObject);
    procedure cxGrid1DBBandedTableView1DblClick(Sender: TObject);
    procedure qryHistoricoAfterOpen(DataSet: TDataSet);
    procedure wwDBEdit1Exit(Sender: TObject);
    procedure qryPerfilDeleteError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure btnConsumoClick(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    vUrlFoto: String;
    { Private declarations }
  public
  cOldCep, cOldSituacao : String;
    { Public declarations }
    procedure VerificaPerfilBloqueado;
    function RetornaPontuacao:Integer;
    procedure ValidarCnpj;
  end;

var
  cadastro_perfil: Tcadastro_perfil;

implementation

uses untPesquisa, untDados, form_cadastro_Tipo_Perfil,
  form_cadastro_tipo_documento, form_cadastro_municipios,
  form_inserir_preferencias, form_inserir_manequim, form_cadastro_banco,
  form_inserir_avaliacao, form_visualizar_historico, Funcao, versao,
  form_cadastro_situacao_produto, form_valor_universal, untAcompanhaHistoricoProduto;


Const
  cCaption = 'CADASTRO DE PERFIL';

{$R *.dfm}


//BOTÃO HELP
procedure Tcadastro_perfil.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_perfil.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_perfil.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_perfil.cxGrid1DBBandedTableView1DblClick(Sender: TObject);
begin
  if qryHistoricoCODIGOQUESTIONARIO.AsInteger > 0 then
  begin
    if Application.FindComponent('inserir_avaliacao') = Nil then
      Application.CreateForm(Tinserir_avaliacao, inserir_avaliacao);

    inserir_avaliacao._Finalidade := tAvPerfil;

    inserir_avaliacao._codigoRegistro := qryHistoricoCODIGOQUESTIONARIO.AsInteger;

    inserir_avaliacao.ShowModal;

  end;
end;

procedure Tcadastro_perfil.dtsPerfilStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_perfil.edtCEPEnter(Sender: TObject);
begin
  cOldCep := edtCEP.Text;
end;

procedure Tcadastro_perfil.edtCEPExit(Sender: TObject);
begin
  if (edtCep.Text <> '') and (cOldCep <> qryPerfilCEP.text) then
  begin
    try
      ACBrCEP.BuscarPorCEP(ApenasAlgarismos(edtCep.Text));
    except
    end;
  end;
end;

procedure Tcadastro_perfil.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryPerfil.State in [dsInsert, dsEdit] then
       qryPerfil.Post;
  end;
end;

procedure Tcadastro_perfil.btn_novoClick(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryPerfil.Post;
  end;
  qryPerfil.Insert;
end;

procedure Tcadastro_perfil.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsPerfil, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryPerfil.Delete;
end;

procedure Tcadastro_perfil.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABPERFIL';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
  begin
    qryPerfil.Close;
    qryPerfil.ParamByName('Codigo').AsInteger := untPesquisa.Resultado;
    qryPerfil.Open;
  end;

  dados.Log(2, 'Código: '+ qryPerfilCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_perfil.qryAvaliacaoPerfilBeforeOpen(DataSet: TDataSet);
begin
  qryAvaliacaoPerfil.Params[0].Value := qryPerfilCODIGO.Value;
end;

procedure Tcadastro_perfil.qryHistoricoAfterOpen(DataSet: TDataSet);
begin
  qryHistoricoDetalhe.Close;
  qryHistoricoDetalhe.Open;
end;

procedure Tcadastro_perfil.qryPerfilAfterPost(DataSet: TDataSet);
begin
  if dtsCep.State in [dsedit,dsinsert] then
    qryCep.Post;
  dados.IBTransaction.CommitRetaining;

  VerificaPerfilBloqueado;
end;

procedure Tcadastro_perfil.qryPerfilAfterScroll(DataSet: TDataSet);
begin

    if FileExists(vUrlFoto+qryPerfilURLFOTO.Text) then
      Image1.Picture.LoadFromFile(vUrlFoto+qryPerfilURLFOTO.Text)
    else
      Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');

    qryPessoaManequim.Close;
    qryPessoaManequim.Open;

    qryHistorico.Close;
    qryHistorico.Open;

    btnPeca.Down := True;
    btnPecaClick(btnPeca);
    cOldCep := '';

    qryPerfilCEPValidate(qryPerfilCEP);

    VerificaPerfilBloqueado;

    end;

procedure Tcadastro_perfil.qryPerfilBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryPerfilCODIGO.Text + ' Nome: '+qryPerfilNOME.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_perfil.qryPerfilBeforePost(DataSet: TDataSet);
begin
  IF qryPerfilCODIGO.Value = 0 THEN
    qryPerfilCODIGO.Value := Dados.NovoCodigo('tabperfil');
  if dtsPerfil.State = dsInsert then
    dados.Log(3, 'Código: '+ qryPerfilCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsPerfil.State = dsEdit then
    dados.Log(4, 'Código: '+ qryPerfilCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)));

  qryPerfilCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
  qryPerfilVERCAO.AsInteger := qryPerfilVERCAO.AsInteger + 1;

  ValidarCnpj;
end;

procedure Tcadastro_perfil.qryPerfilCalcFields(DataSet: TDataSet);
begin
  if qryPerfilNASCIMENTO.AsDateTime > 0 then
    qryPerfilIDADE.AsInteger := YearsBetween(qryPerfilNASCIMENTO.AsDateTime,Date);

  qryPerfilPONTUACAO.AsInteger := RetornaPontuacao;

end;

procedure Tcadastro_perfil.qryPerfilCEPValidate(Sender: TField);

begin

  qryCep.Close;
  qryCep.SQL.Clear;
  qryCep.SQL.Add(' select * from TABCEP');
  qryCep.SQL.Add(' where cep = ' + #39 + qryPerfilCEP.Text +#39);
  qryCep.Open;

{  if (qryPerfilCEP.Text <> '') then
  begin
    qryCep.Close;
    qryCep.SQL.Clear;
    qryCep.SQL.Add(' select * from TABCEP');
    qryCep.SQL.Add(' ');
    dados.Geral.Close;
    dados.Geral.sql.Text := 'Select Cep from tabcep where cep = ' + #39 + qryPerfilCEP.Text +#39;
    dados.Geral.Open;
    if dados.Geral.IsEmpty then
    begin
      qryCep.Open;
      qryCep.Insert;
      qryCepCEP.Text := qryPerfilCEP.Text;
    end
    else
    begin
      qryCep.SQL.Strings[1] := ' where cep = ' + #39 + qryPerfilCEP.Text +#39;
      qryCep.Open;
    end;
  end
  else
    qryCep.Close;  }
end;

procedure Tcadastro_perfil.qryPerfilDeleteError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  if pos('FOREIGN', e.Message) > 0 then
  begin
    application.MessageBox(Pchar('Nao é possivel excluir o cadastro!'+#13+
                                 'Existem registros vinculados.'),'',mb_OK+MB_ICONWARNING);
    Action:= daAbort;
  end;
end;

procedure Tcadastro_perfil.qryPerfilNewRecord(DataSet: TDataSet);
begin
  qryPerfilCODIGO.Value := 0;
  qryPerfilDATACADASTRO.AsDateTime := Date;
  qryPerfilSEXO.Text := 'F';
end;

procedure Tcadastro_perfil.qryPessoaPreferenciasAfterOpen(DataSet: TDataSet);
begin
  lbPreferncias.Clear;
  qryPessoaPreferencias.First;
  while not qryPessoaPreferencias.Eof do
  begin
    lbPreferncias.Items.Add(qryPessoaPreferenciasDESCRICAO.Text);
    qryPessoaPreferencias.Next;
  end;
end;

function Tcadastro_perfil.RetornaPontuacao: Integer;
begin
 //
  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT SUM(RESULTADO) AS TOTAL '+
                          '  FROM TABAVALIACAOPERFILGERAL '+
                          ' WHERE CODIGOORIGEM =0'+qryPerfilCODIGO.Text+
                          '   AND TIPO = 1 ';
  Dados.Geral.Open;

  Result := Dados.Geral.FieldByName('TOTAL').AsInteger;

end;

procedure Tcadastro_perfil.RxDBLookupCombo3Enter(Sender: TObject);
begin
  cOldSituacao := qryPerfilCODIGOSITUACAO.Text;
end;

procedure Tcadastro_perfil.RxDBLookupCombo3Exit(Sender: TObject);
//var
//  DataVigencia, HoraVigencia : String;
//  cCodigo : Integer;
begin
  if cOldSituacao <> qryPerfilCODIGOSITUACAO.Text then
  begin

    qryPerfil.Post;

    Dados.InserirHistorico(0,
                           qryPerfilCODIGO.AsInteger,
                           1,
                           qryPerfilCODIGOSITUACAO.AsInteger,
                           RxDBLookupCombo3.Text,
                           '',
                           '');

    qryHistorico.Close;
    qryHistorico.Open;

  end;
end;

procedure Tcadastro_perfil.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.Close;

  qryTipoPerfil.Close;
  qryCidadeUFNaturalidade.Close;
  qryTipoDocumento.Close;
  qryCidadeUF.Close;
end;

procedure Tcadastro_perfil.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Perfil';

  cbSexo.Items.Add('FEMININO');
  cbSexo.Items.Add('MASCULINO');

  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure Tcadastro_perfil.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try

    vUrlFoto := Dados.ValidaURL(tuPerfil);

    qryTipoPerfil.Open;
    qryCidadeUFNaturalidade.Open;
    qryTipoDocumento.Open;
    qryCidadeUF.Open;
    qryUsuario.Open;
    qryBanco.Open;
    qrySituacao.Close;
    qrySituacao.Open;
    qryAvaliacao.Open;

    qryPerfil.Close;
    qryPerfil.ParamByName('Codigo').AsInteger := untPesquisa.Resultado;
    qryPerfil.Open;

    cOldSituacao := '';

    Dados.NovoRegistro(qryPerfil);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_perfil.PageControl1Change(Sender: TObject);
begin
  qryHistorico.Close;
  qryHistorico.Open;
end;

procedure Tcadastro_perfil.SpeedButton5Click(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.First;
end;

procedure Tcadastro_perfil.SpeedButton6Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_tipo_documento') = Nil then
         Application.CreateForm(Tcadastro_tipo_documento, cadastro_tipo_documento);

  cadastro_tipo_documento.ShowModal;

  qryTipoDocumento.Close;
  qryTipoDocumento.Open;
end;

procedure Tcadastro_perfil.SpeedButton7Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_municipios') = Nil then
         Application.CreateForm(Tcadastro_municipios, cadastro_municipios);

  cadastro_municipios.ShowModal;

  qryCidadeUF.Close;
  qryCidadeUF.Open;

  qryCidadeUFNaturalidade.Close;
  qryCidadeUFNaturalidade.Open;
end;

procedure Tcadastro_perfil.SpeedButton9Click(Sender: TObject);
begin
  if qryTipoPerfilTIPO.Text <> '1' then
  begin
    application.MessageBox('Somente é Permitido Informar o Manequim de Perfil do Tipo "Cliente"!','Informação!',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;

  If Application.FindComponent('inserir_manequim') = Nil then
    Application.CreateForm(Tinserir_manequim, inserir_manequim);

  inserir_manequim._Finalidade := tfmPerfil;

  inserir_manequim._codigo := qryPerfilCODIGO.AsInteger;

  inserir_manequim.ShowModal;

  qryPerfil.Edit;
  qryPerfil.Post;

  qryPessoaManequim.Close;
  qryPessoaManequim.Open;
end;

procedure Tcadastro_perfil.ValidarCnpj;
begin

  if Trim(qryPerfilCPF.Text) <> '' then
  begin

    if length(Trim(qryPerfilCPF.Text)) < 11 then
    begin
      Application.MessageBox(PChar('CPF / CNPJ Inválido!'),'Validação de Documento',MB_OK+MB_ICONEXCLAMATION);
      wwDBEdit1.SetFocus;
      Abort;
    end;

    Dados.Geral.Close;
    Dados.Geral.SQL.Text := 'SELECT * '+
                            '  FROM TABPERFIL P'+
                            ' WHERE TRIM(REPLACE(REPLACE(CPF,''-'',''''),''/'','''')) = '+QuotedStr(Trim(StringReplace(StringReplace(qryPerfilCPF.Text,'-','',[]),'/','',[]))) +
                            '   AND P.CODIGO <> 0'+qryPerfilCODIGO.Text;
    Dados.Geral.Open;

    if not Dados.Geral.IsEmpty then
    begin
      Application.MessageBox(PChar('Já existe um perfil cadastrado com o CPF / CNPJ: '+qryPerfilCPF.Text + #13+
                             'Perfil: '+Dados.Geral.FieldByName('CODIGO').Text +' - '+Dados.Geral.FieldByName('NOME').Text),
                             'Informação!',MB_OK+MB_ICONEXCLAMATION);
      wwDBEdit1.SetFocus;
      Abort;
    end;

  end;

end;

procedure Tcadastro_perfil.VerificaPerfilBloqueado;
begin

  if qryPerfilCODIGOSITUACAO.Text <> '' then
  begin
    dados.Geral.Close;
    dados.Geral.sql.Text := 'Select OPERACAO from TABSITUACAOPRODUTO where CODIGO = ' + qryPerfilCODIGOSITUACAO.Text;
    dados.Geral.Open;

    btnBloqueado.Visible := dados.Geral.FieldByName('OPERACAO').AsInteger = 1

  end
  else
    btnBloqueado.Visible := False;


end;

procedure Tcadastro_perfil.wwDBEdit1Exit(Sender: TObject);
begin
  ValidarCnpj;
end;

procedure Tcadastro_perfil.SpeedButton2Click(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.Prior;
end;

procedure Tcadastro_perfil.SpeedButton3Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Tipo_Perfil') = Nil then
         Application.CreateForm(Tcadastro_Tipo_Perfil, cadastro_Tipo_Perfil);

  cadastro_Tipo_Perfil.ShowModal;

  qryTipoPerfil.Close;
  qryTipoPerfil.Open;

end;

procedure Tcadastro_perfil.SpeedButton4Click(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.Next;
end;

procedure Tcadastro_perfil.SpeedButton10Click(Sender: TObject);
begin
  if qryTipoPerfilTIPO.Text <> '1' then
  begin
    application.MessageBox('Somente é Permitido Informar o Preferencias de Perfil do Tipo "Cliente"!','Informação!',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;

  If Application.FindComponent('inserir_preferencias') = Nil then
    Application.CreateForm(Tinserir_preferencias, inserir_preferencias);

  inserir_preferencias._Finalidade := tfpPerfil;

  if btnPeca.Down then
    inserir_preferencias._Tipo := 1
  else if btnModelo.Down then
    inserir_preferencias._Tipo := 2
  else if btnMarca.Down then
    inserir_preferencias._Tipo := 3
  else if btnEstilo.Down then
    inserir_preferencias._Tipo := 4
  else if btnCor.Down then
    inserir_preferencias._Tipo := 5
  else if btnExigencia.Down then
    inserir_preferencias._Tipo := 6;

  inserir_preferencias._codigo := qryPerfilCODIGO.AsInteger;

  inserir_preferencias.ShowModal;

  qryPerfil.Edit;
  qryPerfil.Post;

  qryPessoaPreferencias.Close;
  qryPessoaPreferencias.ParamByName('TIPO').AsInteger := inserir_preferencias._Tipo;
  qryPessoaPreferencias.Open;
end;

procedure Tcadastro_perfil.SpeedButton11Click(Sender: TObject);
var
  xNewUrl: String;
begin
  if qryPerfilCodigo.Text <> '' then
  begin
    if opdFoto.Execute() then
    begin

      if not (qryPerfil.State in [dsInsert, dsEdit]) then
        qryPerfil.Edit;

      xNewUrl := 'AMV_'+qryPerfilCODIGO.Text+'_'+FormatDateTime('ddMMyyyyhhmmss', now)+'.jpg';

      if not CopyFile(Pchar(opdFoto.FileName),Pchar(vUrlFoto+xNewUrl),False) then
      begin
        Application.MessageBox(Pchar('Falha ao Copiar Foto "'+opdFoto.FileName+'" para "'+vUrlFoto+xNewUrl+'"!'),'Falha',MB_OK+MB_ICONERROR);
        Abort;
      end;

      qryPerfilURLFOTO.Text := xNewUrl;
      Image1.Picture.LoadFromFile(vUrlFoto+qryPerfilURLFOTO.Text);
    end;
  end;
end;

procedure Tcadastro_perfil.SpeedButton12Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Banco') = Nil then
    Application.CreateForm(Tcadastro_Banco, cadastro_Banco);

  cadastro_Banco.ShowModal;

  qryBanco.Close;
  qryBanco.Open;
end;

procedure Tcadastro_perfil.SpeedButton13Click(Sender: TObject);
begin

  if application.MessageBox('Deseja realmente realizar a avaliação de perfil?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
  begin

    if Application.FindComponent('inserir_avaliacao') = Nil then
      Application.CreateForm(Tinserir_avaliacao, inserir_avaliacao);

    inserir_avaliacao._Finalidade := tAvPerfil;

    inserir_avaliacao._codigoRegistro := 0;

    inserir_avaliacao._codigoOrigem   := qryPerfilCODIGO.AsInteger;

    inserir_avaliacao.ShowModal;

    if inserir_avaliacao.cCodigoSituacaoAlterada <> '' then
    begin

      if not (qryPerfil.State in [dsEdit,dsInsert]) then
        qryPerfil.Edit;

      qryPerfilCODIGOSITUACAO.Text := inserir_avaliacao.cCodigoSituacaoAlterada;

      qryPerfil.Post;
    
    end;


    qryHistorico.Close;
    qryHistorico.Open;

  end;

end;

procedure Tcadastro_perfil.SpeedButton14Click(Sender: TObject);
begin
  if Application.FindComponent('visualizar_historico') = Nil then
    Application.CreateForm(Tvisualizar_historico, visualizar_historico);

  visualizar_historico._codigoRegistro := qryPerfilCODIGO.AsInteger;

  visualizar_historico.ShowModal;
end;

procedure Tcadastro_perfil.SpeedButton15Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_situacao_produto') = Nil then
         Application.CreateForm(Tcadastro_situacao_produto, cadastro_situacao_produto);

  cadastro_situacao_produto.ShowModal;

  qrySituacao.Close;
  qrySituacao.Open;
end;

procedure Tcadastro_perfil.ACBrCEPBuscaEfetuada(Sender: TObject);
var
  CodigoMunicipio : Integer;
begin

  if ( qryPerfil.State in [dsEdit, dsInsert] ) then
  begin
    try
      if ACBrCEP.Enderecos.Count > 0 then
      begin

        qryPerfilCOMPLEMENTO.AsString := UpperCase(TrocaAcentos(ACBrCEP.Enderecos[0].Complemento));

        if (qryPerfilCEP.Text <> '') then
        begin

          dados.Geral.Close;
          dados.Geral.sql.Text := 'Select CODIGO from TABMUNICIPIOS where UPPER(NOME) = ' + QuotedStr(UpperCase(ACBrCEP.Enderecos[0].Municipio));
          dados.Geral.Open;


          if dados.Geral.IsEmpty then
          begin

            qryCidadeUF.Close;
            qryCidadeUF.Open;

            CodigoMunicipio := Dados.NovoCodigo('tabMunicipios');

            qryCidadeUF.Insert;
            qryCidadeUFCODIGO.Value :=  CodigoMunicipio;
            qryCidadeUFNOME.Text    := UpperCase(TrocaAcentos(ACBrCEP.Enderecos[0].Municipio));
            qryCidadeUFUF.Text      := UpperCase(ACBrCEP.Enderecos[0].UF);
            qryCidadeUFDATACADASTRO.AsDateTime := Date;
            qryCidadeUF.Post;
            
          end
          else
            CodigoMunicipio := dados.Geral.FieldByName('CODIGO').AsInteger;


          qryCep.Close;
          qryCep.SQL.Clear;
          qryCep.SQL.Add(' select * from TABCEP');
          qryCep.SQL.Add(' where cep = ' + #39 + qryPerfilCEP.Text +#39);
          qryCep.Open;

          if qryCep.IsEmpty then
          begin

            qryCep.Open;

            qryCep.Insert;
            qryCepCEP.Text                  := edtCEP.Text;
            qryCepENDERECO.Text             := UpperCase(TrocaAcentos(ACBrCEP.Enderecos[0].Tipo_Logradouro + ' ' + ACBrCEP.Enderecos[0].Logradouro));
            qryCepBAIRRO.Text               := UpperCase(TrocaAcentos(ACBrCEP.Enderecos[0].Bairro));
            qryCepCODIGOMUNICIPIO.AsInteger := CodigoMunicipio;
            qryCep.Post;
            
          end;

          
        end;

      end;
    except
      on E:Exception do
        application.MessageBox(Pchar('Erro ao consultar CEP.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
    end;
  end;
end;

procedure Tcadastro_perfil.btnBloqueadoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_situacao_produto') = Nil then
         Application.CreateForm(Tcadastro_situacao_produto, cadastro_situacao_produto);

  cadastro_situacao_produto.Show;

  qrySituacao.Close;
  qrySituacao.Open;
end;

procedure Tcadastro_perfil.btnConsumoClick(Sender: TObject);
begin
  If Application.FindComponent('frmAcompanhaHistoricoProduto') = Nil then
    Application.CreateForm(TfrmAcompanhaHistoricoProduto, frmAcompanhaHistoricoProduto);

  frmAcompanhaHistoricoProduto.cbPerfil.KeyValue := StrToIntDef(edtCodigo.Text,0);
  frmAcompanhaHistoricoProduto.cxButton1Click(self);
   
  frmAcompanhaHistoricoProduto.Show;
end;

procedure Tcadastro_perfil.btnPecaClick(Sender: TObject);
var
  CodTipo : Integer;
begin
//  if sender <> btnPeca then btnPeca.Down := False;
//  if sender <> btnModelo then btnModelo.Down      := False;
//  if sender <> btnMarca then btnMarca.Down       := False;
//  if sender <> btnEstilo then btnEstilo.Down      := False;
//  if sender <> btnCor then btnCor.Down         := False;
//  if sender <> btnExigencia then btnExigencia.Down   := False;
//  if sender <> btnComplemento then btnComplemento.Down := False;
//
//  (sender as TSpeedButton).Down := True;

  CodTipo := 0;
  if sender = btnPeca then CodTipo := 1
  else if sender = btnModelo then CodTipo := 2
  else if sender = btnMarca then CodTipo := 3
  else if sender = btnEstilo then CodTipo := 4
  else if sender = btnCor then CodTipo := 5
  else if sender = btnExigencia then CodTipo := 6;

  qryPessoaPreferencias.Close;
  qryPessoaPreferencias.ParamByName('TIPO').AsInteger := CodTipo;
  qryPessoaPreferencias.Open;
end;

procedure Tcadastro_perfil.SpeedButton1Click(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.Last;
end;

procedure Tcadastro_perfil.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
