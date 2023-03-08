unit form_cadastro_questionario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  Grids, Wwdbigrd, Wwdbgrid, wwdblook, wwdbedit, Wwdotdot, Wwdbcomb;

type
  Tcadastro_questionario = class(TForm)
    lblCodigo: TLabel;
    lblNome: TLabel;
    Label30: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    edtCodigo: TDBEdit;
    edtNome: TDBEdit;
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsQuestionario: TDataSource;
    qryQuestionario: TIBQuery;
    updQuestionario: TIBUpdateSQL;
    Image1: TImage;
    DBRadioGroup1: TDBRadioGroup;
    GroupBox1: TGroupBox;
    dtsQuestionarioDetalhe: TDataSource;
    qryQuestionarioDetalhe: TIBQuery;
    updQuestionarioDetalhe: TIBUpdateSQL;
    qryQuestionarioDetalheCODIGOQUESTIONARIO: TIntegerField;
    qryQuestionarioDetalheID: TIntegerField;
    qryQuestionarioDetalheVALORINICIAL: TIBBCDField;
    qryQuestionarioDetalheVALORFINAL: TIBBCDField;
    GroupBox2: TGroupBox;
    qryAvaliacoes: TIBQuery;
    qryAvaliacoesCODIGO: TIntegerField;
    qryAvaliacoesDESCRICAO: TIBStringField;
    qryAvaliacoesAPLICACAO: TIntegerField;
    qryQuestionarioDetalheOPERACAO: TIntegerField;
    qryQuestionarioCODIGO: TIntegerField;
    qryQuestionarioDESCRICAO: TIBStringField;
    qryQuestionarioAPLICACAO: TIntegerField;
    qryQuestionarioAvaliacao: TIBQuery;
    dtsQuestionarioAvaliacao: TDataSource;
    updQuestionarioAvaliacao: TIBUpdateSQL;
    qryQuestionarioAvaliacaoCODIGOQUESTIONARIO: TIntegerField;
    qryQuestionarioAvaliacaoCODIGOAVALIACAO: TIntegerField;
    qryQuestionarioAvaliacaoOBSERVACAO: TIBStringField;
    grdDetalhe: TwwDBGrid;
    cmbCodAvaliacao: TwwDBLookupCombo;
    qryQuestionarioAvaliacaoNomeAvaliacao: TStringField;
    IBQuery1: TIBQuery;
    wwDBGrid1: TwwDBGrid;
    cmbResultado: TwwDBComboBox;
    qryQuestionarioDetalheCODIGOSITUACAO: TIntegerField;
    cmbSituacao: TwwDBLookupCombo;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    qryQuestionarioDetalheNOMESITUACAO: TStringField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryQuestionarioAfterPost(DataSet: TDataSet);
    procedure qryQuestionarioBeforeDelete(DataSet: TDataSet);
    procedure qryQuestionarioBeforePost(DataSet: TDataSet);
    procedure qryQuestionarioNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsQuestionarioStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryQuestionarioAfterScroll(DataSet: TDataSet);
    procedure qryQuestionarioAvaliacaoBeforeInsert(DataSet: TDataSet);
    procedure qryQuestionarioAvaliacaoNewRecord(DataSet: TDataSet);
    procedure qryQuestionarioDetalheBeforeInsert(DataSet: TDataSet);
    procedure qryQuestionarioDetalheNewRecord(DataSet: TDataSet);
    procedure qryQuestionarioAvaliacaoCalcFields(DataSet: TDataSet);
    procedure qryQuestionarioAvaliacaoPostError(DataSet: TDataSet;
      E: EDatabaseError; var Action: TDataAction);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
    { Public declarations }
  procedure SalvarRegistro;
  end;

var
  cadastro_questionario: Tcadastro_questionario;

implementation

uses untPesquisa, untDados, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_questionario.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_questionario.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_questionario.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_questionario.dtsQuestionarioStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_questionario.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryQuestionario.State in [dsInsert, dsEdit] then
       qryQuestionario.Post;
  end;
end;

procedure Tcadastro_questionario.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryQuestionario.Insert;
end;

procedure Tcadastro_questionario.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsQuestionario, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryQuestionario.Delete;
end;

procedure Tcadastro_questionario.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABAVALIACAO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryQuestionario.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryQuestionarioCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_questionario.qryQuestionarioAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_questionario.qryQuestionarioAfterScroll(DataSet: TDataSet);
begin

  qryQuestionarioAvaliacao.Close;
  qryQuestionarioAvaliacao.Open;

  qryQuestionarioDetalhe.Close;
  qryQuestionarioDetalhe.Open;
end;

procedure Tcadastro_questionario.qryQuestionarioAvaliacaoBeforeInsert(
  DataSet: TDataSet);
begin
  if qryQuestionario.State = dsInsert then
    qryQuestionario.Post;
end;

procedure Tcadastro_questionario.qryQuestionarioAvaliacaoCalcFields(
  DataSet: TDataSet);
begin
  IBQuery1.Close;
  IBQuery1.SQL.Text := 'SELECT DESCRICAO '+
                       '  FROM TABAVALIACAO '+
                       '  WHERE CODIGO =0'+qryQuestionarioAvaliacaoCODIGOAVALIACAO.Text;
  IBQuery1.Open;

  qryQuestionarioAvaliacaoNomeAvaliacao.Text := IBQuery1.FieldByName('DESCRICAO').Text;
end;

procedure Tcadastro_questionario.qryQuestionarioAvaliacaoNewRecord(
  DataSet: TDataSet);
begin
  qryQuestionarioAvaliacaoCODIGOQUESTIONARIO.AsInteger := qryQuestionarioCODIGO.AsInteger;
end;

procedure Tcadastro_questionario.qryQuestionarioAvaliacaoPostError(
  DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
begin
  if Pos(E.Message,'PRIMARY or UNIQUE KEY') > 0 then
      application.MessageBox(Pchar('Avaliação já informada!'),'ERRO',mb_OK+MB_ICONERROR);
end;

procedure Tcadastro_questionario.qryQuestionarioBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryQuestionarioCODIGO.Text + ' Nome: '+qryQuestionarioDESCRICAO.Text+' Janela: '+copy(Caption,17,length(Caption)));
end;

procedure Tcadastro_questionario.qryQuestionarioBeforePost(DataSet: TDataSet);
begin
  IF qryQuestionarioCODIGO.Value = 0 THEN
    qryQuestionarioCODIGO.Value := Dados.NovoCodigo('TABQUESTIONARIO');
  if dtsQuestionario.State = dsInsert then
    dados.Log(3, 'Código: '+ qryQuestionarioCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsQuestionario.State = dsEdit then
    dados.Log(4, 'Código: '+ qryQuestionarioCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_questionario.qryQuestionarioDetalheBeforeInsert(
  DataSet: TDataSet);
begin
  if qryQuestionario.State = dsInsert then
    qryQuestionario.Post;
end;

procedure Tcadastro_questionario.qryQuestionarioDetalheNewRecord(
  DataSet: TDataSet);
begin

  qryQuestionarioDetalheCODIGOQUESTIONARIO.AsInteger := qryQuestionarioCODIGO.AsInteger;

  qryQuestionarioDetalheID.Value := Dados.NovoCodigo('TABQUESTIONARIODETALHE','ID','CODIGOQUESTIONARIO = 0'+qryQuestionarioCODIGO.Text);

end;

procedure Tcadastro_questionario.qryQuestionarioNewRecord(DataSet: TDataSet);
begin
  qryQuestionarioCODIGO.Value := 0;
end;

procedure Tcadastro_questionario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryQuestionario.Close;
end;

procedure Tcadastro_questionario.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Questionrio1';
end;

procedure Tcadastro_questionario.FormShow(Sender: TObject);
begin
  TOP := 0;
  LEFT := 124;
  try
    qryQuestionario.Close;
    qryQuestionario.Open;

    qryAvaliacoes.Close;
    qryAvaliacoes.Open;

    Dados.NovoRegistro(qryQuestionario);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_questionario.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryQuestionario.First;
end;

procedure Tcadastro_questionario.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryQuestionario.Prior;
end;

procedure Tcadastro_questionario.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryQuestionario.Next;
end;

procedure Tcadastro_questionario.SalvarRegistro;
begin
  if dtsQuestionario.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryQuestionario.Post;
  end;
end;

procedure Tcadastro_questionario.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryQuestionario.Last;
end;

procedure Tcadastro_questionario.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
