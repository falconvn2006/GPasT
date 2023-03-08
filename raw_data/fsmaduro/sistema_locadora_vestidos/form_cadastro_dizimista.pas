unit form_cadastro_dizimista;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DBCtrls, Mask,  RXDBCtrl,
  IBCustomDataSet, IBUpdateSQL, DB, IBQuery, untDados, RxDBComb, RxLookup,
   rxToolEdit, ppDB, ppComm, ppRelatv, ppDBPipe, ppVar, ppBands, ppCtrls,
  ppPrnabl, ppClass, ppCache, ppProd, ppReport, ppStrtch, ppMemo, Funcao,
  ppSubRpt, wwcheckbox, ppParameter, ppDesignLayer;

type
  Tcadastro_dizimista = class(TForm)
    Label1: TLabel;
    lblCodigo: TLabel;
    lblNome: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label17: TLabel;
    Label15: TLabel;
    Label30: TLabel;
    Label35: TLabel;
    edtCodigo: TDBEdit;
    edtNome: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit3: TDBEdit;
    bdeNacimento: TDBDateEdit;
    Panel2: TPanel;
    DBDateEdit2: TDBDateEdit;
    DBEdit1: TDBEdit;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    Image2: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel1: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    Label20: TLabel;
    Panel3: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    DBEdit12: TDBEdit;
    edtCEP: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit20: TDBEdit;
    Label28: TLabel;
    Panel4: TPanel;
    Label29: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    DBEdit18: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    Label36: TLabel;
    Panel5: TPanel;
    Label37: TLabel;
    edtConjuge: TDBEdit;
    Label41: TLabel;
    Panel6: TPanel;
    DBMemo1: TDBMemo;
    btnPrimeiro: TSpeedButton;
    btnAnterior: TSpeedButton;
    BtnProximo: TSpeedButton;
    btnUltimo: TSpeedButton;
    Label42: TLabel;
    DBEdit28: TDBEdit;
    Label43: TLabel;
    DBEdit29: TDBEdit;
    qryDizimistas: TIBQuery;
    dtsDizimistas: TDataSource;
    dtsNaturalidade: TDataSource;
    qryNaturalidade: TIBQuery;
    qryNaturalidadeCODIGO: TIntegerField;
    qryNaturalidadeNOME: TIBStringField;
    qryNaturalidadeUF: TIBStringField;
    qryProfissao: TIBQuery;
    IntegerField1: TIntegerField;
    IBStringField1: TIBStringField;
    dtsProfissao: TDataSource;
    dtsTipodocumento: TDataSource;
    qryTipoDocumento: TIBQuery;
    qryTipoDocumentoCODIGO: TIntegerField;
    qryTipoDocumentoNOME: TIBStringField;
    dtsCep: TDataSource;
    qryCep: TIBQuery;
    qryCepCEP: TIBStringField;
    qryCepENDERECO: TIBStringField;
    qryCepBAIRRO: TIBStringField;
    qryCepCODIGOMUNICIPIO: TIntegerField;
    dtsCidadeUF: TDataSource;
    qryCidadeUF: TIBQuery;
    qryCidadeUFCODIGO: TIntegerField;
    qryCidadeUFNOME: TIBStringField;
    qryCidadeUFUF: TIBStringField;
    udpCep: TIBUpdateSQL;
    cbSexo: TRxDBComboBox;
    cbEstadoCivil: TRxDBComboBox;
    cbEscolaridade: TRxDBComboBox;
    udpDizimistas: TIBUpdateSQL;
    cbnaturalidade: TRxDBLookupCombo;
    cbtipodoc: TRxDBLookupCombo;
    cbcidade: TRxDBLookupCombo;
    cbprofissao: TRxDBLookupCombo;
    dtsSerie: TDataSource;
    qrySerie: TIBQuery;
    dtsEstabelecimento: TDataSource;
    qryEstabelecimento: TIBQuery;
    qrySerieCODIGO: TIntegerField;
    qrySerieDATACADASTRO: TDateField;
    qrySerieNOME: TIBStringField;
    qryEstabelecimentoCODIGO: TIntegerField;
    qryEstabelecimentoDATACADASTRO: TDateField;
    qryEstabelecimentoNOME: TIBStringField;
    RxDBLookupCombo1: TRxDBLookupCombo;
    RxDBLookupCombo2: TRxDBLookupCombo;
    qryDizimistasCODIGO: TIntegerField;
    qryDizimistasDATACADASTRO: TDateField;
    qryDizimistasNOME: TIBStringField;
    qryDizimistasNOMEPAI: TIBStringField;
    qryDizimistasNOMEMAE: TIBStringField;
    qryDizimistasSEXO: TIBStringField;
    qryDizimistasNASCIMENTO: TDateField;
    qryDizimistasCODIGOMUNICIPIONATURALIDADE: TIntegerField;
    qryDizimistasESTADOCIVIL: TIntegerField;
    qryDizimistasCODIGOPROFISSAO: TIntegerField;
    qryDizimistasCODIGOTIPODOCUMENTO: TIntegerField;
    qryDizimistasNUMERODOCUMENTO: TIBStringField;
    qryDizimistasORGAOEMISSOR: TIBStringField;
    qryDizimistasUFDOCUMENTO: TIBStringField;
    qryDizimistasCPF: TIBStringField;
    qryDizimistasCEP: TIBStringField;
    qryDizimistasNUMERO: TIntegerField;
    qryDizimistasCOMPLEMENTO: TIBStringField;
    qryDizimistasTELRESIDENCIAL: TIBStringField;
    qryDizimistasTELCELULAR: TIBStringField;
    qryDizimistasTELCOMERCIAL: TIBStringField;
    qryDizimistasTELRECADO: TIBStringField;
    qryDizimistasPESSOARECADO: TIBStringField;
    qryDizimistasEMAIL1: TIBStringField;
    qryDizimistasEMAIL2: TIBStringField;
    qryDizimistasOBSERVACAO: TMemoField;
    qryDizimistasESCOLARIDADE: TIntegerField;
    qryDizimistasCODIGOESTABELECIMENTO: TIntegerField;
    qryDizimistasCODIGOSERIE: TIntegerField;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    qryDizimistasSITUACAO: TIntegerField;
    qryDizimistasDATASITUACAO: TDateField;
    qryDizimistasCONJUGEDIZIMISTA: TIntegerField;
    qryDizimistasNOMECONJUGE: TIBStringField;
    qryDizimistasNASCIMENTOCONJUGE: TDateField;
    qryDizimistasCODIGOCONJUGEDIZIMISTA: TIntegerField;
    qryDizimistasINICIOCONTRIBUICAO: TDateField;
    qryDizimistasVALORCONTRIBUICAO: TIBBCDField;
    Label2: TLabel;
    DBDateEdit1: TDBDateEdit;
    DBCheckBox1: TDBCheckBox;
    lcbConjuge: TRxDBLookupCombo;
    Label5: TLabel;
    DBDateEdit3: TDBDateEdit;
    dtsConjuge: TDataSource;
    qryConjuge: TIBQuery;
    qryConjugeCODIGO: TIntegerField;
    qryConjugeNOME: TIBStringField;
    qryConjugeNASCIMENTO: TDateField;
    Panel7: TPanel;
    Label38: TLabel;
    DBEdit2: TDBEdit;
    qryDizimistasDATACASAMENTO: TDateField;
    Label39: TLabel;
    DBEdit4: TDBEdit;
    Panel8: TPanel;
    Label40: TLabel;
    chbSituacao: TRxDBComboBox;
    DBDateEdit4: TDBDateEdit;
    qryDizimistasREFERENCIA: TIBStringField;
    pipDizimistas: TppDBPipeline;
    pipNaturalidade: TppDBPipeline;
    pipSerie: TppDBPipeline;
    pipEstabelecimento: TppDBPipeline;
    pipProfissao: TppDBPipeline;
    pipTipoDocumento: TppDBPipeline;
    pipCep: TppDBPipeline;
    pipCidadeUF: TppDBPipeline;
    pipConjuge: TppDBPipeline;
    rbiFicha: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppImage1: TppImage;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppLine1: TppLine;
    ppLine2: TppLine;
    OME: TppLabel;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppLine4: TppLine;
    ppSystemVariable1: TppSystemVariable;
    ppSystemVariable2: TppSystemVariable;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLine3: TppLine;
    ppLine5: TppLine;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppLine6: TppLine;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppLabel8: TppLabel;
    ppLine7: TppLine;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    ppLabel11: TppLabel;
    ppLabel12: TppLabel;
    ppLabel13: TppLabel;
    ppLine8: TppLine;
    ppLabel14: TppLabel;
    ppLabel15: TppLabel;
    ppLabel16: TppLabel;
    ppLine9: TppLine;
    ppLabel17: TppLabel;
    ppLabel18: TppLabel;
    ppLabel19: TppLabel;
    ppLabel20: TppLabel;
    ppLine10: TppLine;
    ppLabel21: TppLabel;
    ppLabel22: TppLabel;
    ppLabel23: TppLabel;
    ppLabel25: TppLabel;
    ppLabel26: TppLabel;
    ppLine11: TppLine;
    ppLabel24: TppLabel;
    ppLabel27: TppLabel;
    ppLabel29: TppLabel;
    ppLabel30: TppLabel;
    ppLine12: TppLine;
    ppLabel28: TppLabel;
    ppLabel31: TppLabel;
    ppLabel32: TppLabel;
    ppLabel33: TppLabel;
    ppLabel34: TppLabel;
    ppLabel35: TppLabel;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppDBText9: TppDBText;
    ppDBText10: TppDBText;
    ppDBText11: TppDBText;
    ppDBText12: TppDBText;
    ppDBText13: TppDBText;
    ppDBText14: TppDBText;
    ppDBText15: TppDBText;
    ppDBText16: TppDBText;
    ppDBText17: TppDBText;
    ppDBText18: TppDBText;
    ppDBText19: TppDBText;
    ppDBText20: TppDBText;
    ppDBText21: TppDBText;
    ppDBText22: TppDBText;
    ppDBText23: TppDBText;
    ppDBText24: TppDBText;
    ppDBText25: TppDBText;
    ppDBText26: TppDBText;
    ppDBText27: TppDBText;
    ppDBText28: TppDBText;
    ppDBText29: TppDBText;
    ppDBText30: TppDBText;
    ppDBText31: TppDBText;
    ppDBText32: TppDBText;
    ppDBText33: TppDBText;
    ppDBText34: TppDBText;
    ppDBText35: TppDBText;
    ppDBText36: TppDBText;
    ppDBText37: TppDBText;
    ppDBText38: TppDBText;
    ppDBText39: TppDBText;
    ppDBText40: TppDBText;
    ppDBMemo1: TppDBMemo;
    ppLine13: TppLine;
    ppLabel36: TppLabel;
    ppLabel37: TppLabel;
    ppDBText41: TppDBText;
    ppDBText42: TppDBText;
    ppShape1: TppShape;
    qryFilhos: TIBQuery;
    qryFilhosCODIGO: TIntegerField;
    qryFilhosNOME: TIBStringField;
    qryFilhosSEXO: TIBStringField;
    qryFilhosDATANASCIMENTO: TDateField;
    qryFilhosCODIGODIZIMISTA: TIntegerField;
    dtsFilhos: TDataSource;
    pipFilhos: TppDBPipeline;
    ppSubReport1: TppSubReport;
    ppChildReport1: TppChildReport;
    ppLabel38: TppLabel;
    ppLabel39: TppLabel;
    ppDetailBand2: TppDetailBand;
    ppDBText43: TppDBText;
    ppDBText44: TppDBText;
    ppLabel40: TppLabel;
    ppShape2: TppShape;
    wwCheckBox1: TwwCheckBox;
    qryDizimistasESERVO: TIntegerField;
    btnFicha: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure qryDizimistasAfterPost(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnProximoClick(Sender: TObject);
    procedure btnPrimeiroClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    procedure qryDizimistasCEPValidate(Sender: TField);
    procedure qryCepAfterOpen(DataSet: TDataSet);
    procedure qryDizimistasNewRecord(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure qryCepBeforeClose(DataSet: TDataSet);
    procedure qryDizimistasAfterRefresh(DataSet: TDataSet);
    procedure qryDizimistasAfterOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure qryDizimistasBeforePost(DataSet: TDataSet);
    procedure qryDizimistasBeforeDelete(DataSet: TDataSet);
    procedure qryDizimistasBeforeOpen(DataSet: TDataSet);
    procedure SpeedButton3Click(Sender: TObject);
    procedure lcbConjugeExit(Sender: TObject);
    procedure DBCheckBox1Click(Sender: TObject);
    procedure qryDizimistasAfterScroll(DataSet: TDataSet);
    procedure ppImage1Print(Sender: TObject);
    procedure ppDBText9GetText(Sender: TObject; var Text: string);
    procedure ppDBText11GetText(Sender: TObject; var Text: string);
    procedure ppDBText18GetText(Sender: TObject; var Text: string);
    procedure ppDBText40GetText(Sender: TObject; var Text: string);
    procedure btnFichaClick(Sender: TObject);
    procedure qryCepBeforeEdit(DataSet: TDataSet);
    procedure ppDBText16GetText(Sender: TObject; var Text: string);
    procedure ppDBText19GetText(Sender: TObject; var Text: string);
    procedure ppDBText20GetText(Sender: TObject; var Text: string);
    procedure dtsDizimistasStateChange(Sender: TObject);
  private
    NomeMenu: String;
    { Private declarations }
  public
    SemMsgInicial: Boolean;
    { Public declarations }
  end;

var
  cadastro_dizimista: Tcadastro_dizimista;

implementation

uses untPesquisa, Math, form_cadastro_municipios;

{$R *.dfm}

procedure Tcadastro_dizimista.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsDizimistas, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
    qryDizimistas.Delete;
end;

procedure Tcadastro_dizimista.btn_gravarClick(Sender: TObject);
begin
   if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
    qryDizimistas.Post;
end;

procedure Tcadastro_dizimista.btn_novoClick(Sender: TObject);
begin
  if dtsDizimistas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryDizimistas.Post;
  end;
  qryDizimistas.Insert;
end;

procedure Tcadastro_dizimista.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABDIZIMISTA';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryDizimistas.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryDizimistasCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_dizimista.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_dizimista.DBCheckBox1Click(Sender: TObject);
begin
  lcbConjuge.Visible := DBCheckBox1.Checked;
  edtConjuge.Visible := not DBCheckBox1.Checked;
end;

procedure Tcadastro_dizimista.dtsDizimistasStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_dizimista.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure Tcadastro_dizimista.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if dtsDizimistas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryDizimistas.Post;
  end;

  qryDizimistas.Close;
  qryNaturalidade.Close;
  qryProfissao.Close;
  qryTipoDocumento.Close;
  qryEstabelecimento.close;
  qryConjuge.close;
  qrySerie.close;
  qryFilhos.close;
end;

procedure Tcadastro_dizimista.FormCreate(Sender: TObject);
begin
  cbEstadoCivil.Items.Add('SOLTEIRO');
  cbEstadoCivil.Items.Add('CASADO');
  cbEstadoCivil.Items.Add('DIVORCIADO');
  cbEstadoCivil.Items.Add('VIÚVO');
  cbEstadoCivil.Items.Add('SEPARADO');
  cbEstadoCivil.Items.Add('OUTROS');
  cbEscolaridade.Items.Add('ENSINO FUNDAMENTAL INCOMPLETO');
  cbEscolaridade.Items.Add('ENSINO FUNDAMENTAL COMPLETO');
  cbEscolaridade.Items.Add('ENSINO MÉDIO INCOMPLETO');
  cbEscolaridade.Items.Add('ENSINO MÉDIO COMPLETO');
  cbEscolaridade.Items.Add('ENSINO SUPERIOR INCOMPLETO');
  cbEscolaridade.Items.Add('ENSINO SUPERIOR COMPLETO');
  cbEscolaridade.Items.Add('POS-GRADUAÇÃO INCOMPLETO');
  cbEscolaridade.Items.Add('POS-GRADUAÇÃO COMPLETO');
  cbEscolaridade.Items.Add('MESTRADO INCOMPLETO');
  cbEscolaridade.Items.Add('MESTRADO COMPLETO');
  cbEscolaridade.Items.Add('DOUTORADO INCOMPLETO');
  cbEscolaridade.Items.Add('DOUTORADO COMPLETO');
  cbSexo.Items.Add('FEMININO');
  cbSexo.Items.Add('MASCULINO');
  chbSituacao.Items.Add('ATIVO');
  chbSituacao.Items.Add('INATIVO');
  chbSituacao.Items.Add('FALECIDO');
  chbSituacao.Items.Add('AUSENTE');

  NomeMenu := 'Alunos1';
end;

procedure Tcadastro_dizimista.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryDizimistas.Close;
    qryNaturalidade.Close;
    qryProfissao.Close;
    qryTipoDocumento.Close;
    qryEstabelecimento.close;
    qrySerie.close;
    qryConjuge.close;
    qryDizimistas.Open;
    qryNaturalidade.Open;
    qryProfissao.Open;
    qryTipoDocumento.Open;
    qryEstabelecimento.Open;
    qrySerie.Open;
    qryConjuge.open;
    qryFilhos.Open;
    if not SemMsgInicial then
      Dados.NovoRegistro(qryDizimistas);
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_dizimista.qryDizimistasAfterOpen(DataSet: TDataSet);
begin
  qryDizimistasCEPValidate(qryDizimistasCEP);
end;

procedure Tcadastro_dizimista.qryDizimistasAfterPost(DataSet: TDataSet);
begin
  if dtsCep.State in [dsedit,dsinsert] then
    qryCep.Post;
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_dizimista.qryDizimistasAfterRefresh(DataSet: TDataSet);
begin
  qryDizimistasCEPValidate(qryDizimistasCEP);
end;


procedure Tcadastro_dizimista.qryDizimistasAfterScroll(DataSet: TDataSet);
begin
  qryDizimistasCEPValidate(qryDizimistasCEP);
end;

procedure Tcadastro_dizimista.qryDizimistasBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryDizimistasCODIGO.Text + ' Nome: '+qryDizimistasNOME.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_dizimista.qryDizimistasBeforePost(DataSet: TDataSet);
begin
  if qryDizimistasCODIGO.Value = 0 then
    qryDizimistasCODIGO.Value := Dados.NovoCodigo('TABDIZIMISTA');
  if qryDizimistasSituacao.Text = '' then
  begin
    qryDizimistasSituacao.Value := 1;
    qryDizimistasDataSituacao.Value := qryDizimistasDataCadastro.Value;
  end;
  if dtsDizimistas.State = dsInsert then
    dados.Log(3, 'Código: '+ qryDizimistasCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsDizimistas.State = dsEdit then
    dados.Log(4, 'Código: '+ qryDizimistasCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_dizimista.qryDizimistasCEPValidate(Sender: TField);
begin
  if (qryDizimistasCEP.Text <> '') then
  begin
    qryCep.Close;
    qryCep.SQL.Clear;
    qryCep.SQL.Add(' select * from TABCEP');
    qryCep.SQL.Add(' ');
    dados.Geral.Close;
    dados.Geral.sql.Text := 'Select Cep from tabcep where cep = ' + #39 + qryDizimistasCEP.Text +#39;
    dados.Geral.Open;
    if dados.Geral.IsEmpty then
    begin
      qryCep.Open;
      qryCep.Insert;
      qryCepCEP.Text := qryDizimistasCEP.Text;
    end
    else
    begin
      qryCep.SQL.Strings[1] := ' where cep = ' + #39 + qryDizimistasCEP.Text +#39;
      qryCep.Open;
    end;
  end
  else
    qryCep.Close;
end;

procedure Tcadastro_dizimista.qryDizimistasNewRecord(DataSet: TDataSet);
begin

  dados.Geral.SQL.Text := 'Select Count(codigo) as QtdRegistros from TABDIZIMISTA';
  dados.Geral.Open;
  if dados.Geral.FieldByName('QtdRegistros').AsInteger >= dados.LimiteDizimistas then
  begin
    Application.MessageBox(Pchar('O numero de '+IntToStr(dados.LimiteDizimistas)+' registros liberados para'+#13+
                           'a sua comunidades foi atingido.'+#13+
                           'Para cadastrar mais dizimistas é nescessário'+#13+
                           'que registre o SoftDizimo 2.0.'+#13+#13+
                           'Para Registrar Ligue para 27 3328-3286'+#13+
                           'ou no site www.softeweb.com.br.'), 'Registro', MB_OK + MB_ICONINFORMATION);
    Abort;
  end;
  dados.Geral.Close;

  qryDizimistasCODIGO.Value := 0;
  qryDizimistasDATACADASTRO.AsDateTime := Date;
end;

procedure Tcadastro_dizimista.qryCepAfterOpen(DataSet: TDataSet);
begin
  qryCidadeUF.Close;
  qryCidadeUF.Open;
end;

procedure Tcadastro_dizimista.qryCepBeforeClose(DataSet: TDataSet);
begin
  qryCidadeUF.close;
end;

procedure Tcadastro_dizimista.qryCepBeforeEdit(DataSet: TDataSet);
begin
  qryDizimistas.Edit;
end;

procedure Tcadastro_dizimista.lcbConjugeExit(Sender: TObject);
begin
  qryDizimistasNOMECONJUGE.Text := qryConjugeNOME.Text;
  qryDizimistasNASCIMENTOCONJUGE.Value := qryConjugeNASCIMENTO.Value;
end;

procedure Tcadastro_dizimista.ppDBText11GetText(Sender: TObject;
  var Text: string);
begin
  if Text = '1' then
    Text := 'Ativo'
  else if Text = '2' then
    Text := 'Inativo'
  else if Text = '3' then
    Text := 'Falecido'
  else if Text = '4' then
    Text := 'Ausente'
  else
    Text := '';

  Text := uppercase(Text);
end;

procedure Tcadastro_dizimista.ppDBText16GetText(Sender: TObject;
  var Text: string);
begin
  text := iif(qryDizimistasCODIGOMUNICIPIONATURALIDADE.text = '','',Text);
end;

procedure Tcadastro_dizimista.ppDBText18GetText(Sender: TObject;
  var Text: string);
begin
  if Text = '1' then
    Text := 'Solteiro'
  else if Text = '2' then
    Text := 'Casado'
  else if Text = '3' then
    Text := 'Divorciado'
  else if Text = '4' then
    Text := 'Viúvo'
  else if Text = '4' then
    Text := 'Separado'
  else if Text = '4' then
    Text := 'Outros'
  else
    Text := '';

  Text := uppercase(Text);
end;

procedure Tcadastro_dizimista.ppDBText19GetText(Sender: TObject;
  var Text: string);
begin
  text := iif(qryDizimistasCODIGOPROFISSAO.text = '','',Text);
end;

procedure Tcadastro_dizimista.ppDBText20GetText(Sender: TObject;
  var Text: string);
begin
  text := iif(qryDizimistasCODIGOTIPODOCUMENTO.text = '','',Text);
end;

procedure Tcadastro_dizimista.ppDBText40GetText(Sender: TObject;
  var Text: string);
begin
   if Text = '1' then
    Text := 'Sim'
  else
    Text := 'Não';

  Text := uppercase(Text);
end;

procedure Tcadastro_dizimista.ppDBText9GetText(Sender: TObject;
  var Text: string);
begin
  if Text = 'M' then
    Text := 'Masculino'
  else if Text = 'F' then
    Text := 'Feminino'
  else
    Text := '';

  Text := uppercase(Text);
end;

procedure Tcadastro_dizimista.ppImage1Print(Sender: TObject);
begin
  Dados.GetImage(ppImage1);
end;

procedure Tcadastro_dizimista.btnUltimoClick(Sender: TObject);
begin
  if dtsDizimistas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryDizimistas.Post;
  end;
  qryDizimistas.Last;
end;

procedure Tcadastro_dizimista.btnAnteriorClick(Sender: TObject);
begin
  if dtsDizimistas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryDizimistas.Post;
  end;
   qryDizimistas.Prior;
end;

procedure Tcadastro_dizimista.BtnProximoClick(Sender: TObject);
begin
  if dtsDizimistas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryDizimistas.Post;
  end;
   qryDizimistas.Next;
end;

procedure Tcadastro_dizimista.btnFichaClick(Sender: TObject);
begin
  if qryDizimistas.IsEmpty then
  begin
    application.MessageBox('Selecione um Registro para que a ficha seja impressa!','SELECIONE',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;

  if dtsDizimistas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Para Imprimir Ficha é Nescessário Gravar Refistro!'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryDizimistas.Post
    else
      Abort;
  end;

  if not qryCep.Active then
  begin
    qrycep.close;
    qryCep.SQL.Strings[1] := ' where 1=2';
    qryCep.Open;
  end;

  qryFilhos.close;
  qryFilhos.open;

  rbiFicha.Print;
end;

procedure Tcadastro_dizimista.btnPrimeiroClick(Sender: TObject);
begin
  if dtsDizimistas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryDizimistas.Post;
  end;
   qryDizimistas.First;
end;

procedure Tcadastro_dizimista.qryDizimistasBeforeOpen(DataSet: TDataSet);
begin
  qryDizimistas.SQL.Strings[qryDizimistas.SQL.IndexOf('where 1=1')+1] := '';
end;

procedure Tcadastro_dizimista.SpeedButton3Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_municipios') = Nil then
         Application.CreateForm(Tcadastro_municipios, cadastro_municipios);

    cadastro_municipios.ShowModal;

   qryNaturalidade.Close;
   qryNaturalidade.Open;

   if qryCidadeUF.Active then
   begin
     qryCidadeUF.Close;
     qryCidadeUF.Open;
   end;


end;

end.
