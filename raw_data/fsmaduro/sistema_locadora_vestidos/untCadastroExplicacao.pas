unit untCadastroExplicacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses;

type
  TfrmCadastroExplicacao = class(TForm)
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
    dtsExplicacao: TDataSource;
    qryExplicacao: TIBQuery;
    updExplicacao: TIBUpdateSQL;
    Image1: TImage;
    qryExplicacaoCODIGO: TIntegerField;
    qryExplicacaoDESCRICAO: TIBStringField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryExplicacaoAfterPost(DataSet: TDataSet);
    procedure qryExplicacaoBeforeDelete(DataSet: TDataSet);
    procedure qryExplicacaoBeforePost(DataSet: TDataSet);
    procedure qryExplicacaoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsExplicacaoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastroExplicacao: TfrmCadastroExplicacao;

implementation

uses untPesquisa, untDados, funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmCadastroExplicacao.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmCadastroExplicacao.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmCadastroExplicacao.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastroExplicacao.dtsExplicacaoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmCadastroExplicacao.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryExplicacao.State in [dsInsert, dsEdit] then
       qryExplicacao.Post;
  end;
end;

procedure TfrmCadastroExplicacao.btn_novoClick(Sender: TObject);
begin
  if dtsExplicacao.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryExplicacao.Post;
  end;
  qryExplicacao.Insert;
end;

procedure TfrmCadastroExplicacao.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsExplicacao, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryExplicacao.Delete;
end;

procedure TfrmCadastroExplicacao.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABEXPLICACAO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryExplicacao.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryExplicacaoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmCadastroExplicacao.qryExplicacaoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmCadastroExplicacao.qryExplicacaoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryExplicacaoCODIGO.Text + ' Nome: '+qryExplicacaoDESCRICAO.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure TfrmCadastroExplicacao.qryExplicacaoBeforePost(DataSet: TDataSet);
begin
  IF qryExplicacaoCODIGO.Value = 0 THEN
    qryExplicacaoCODIGO.Value := Dados.NovoCodigo('TABEXPLICACAO');
  if dtsExplicacao.State = dsInsert then
    dados.Log(3, 'Código: '+ qryExplicacaoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsExplicacao.State = dsEdit then
    dados.Log(4, 'Código: '+ qryExplicacaoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure TfrmCadastroExplicacao.qryExplicacaoNewRecord(DataSet: TDataSet);
begin
  qryExplicacaoCODIGO.Value := 0;
end;

procedure TfrmCadastroExplicacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsExplicacao.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryExplicacao.Post;
  end;
  qryExplicacao.Close;
end;                                

procedure TfrmCadastroExplicacao.FormCreate(Sender: TObject);
begin
  NomeMenu := 'ipoLanamento1';
end;

procedure TfrmCadastroExplicacao.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryExplicacao.Close;
    qryExplicacao.Open;
    Dados.NovoRegistro(qryExplicacao);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmCadastroExplicacao.SpeedButton5Click(Sender: TObject);
begin
  if dtsExplicacao.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryExplicacao.Post;
  end;
  qryExplicacao.First;
end;

procedure TfrmCadastroExplicacao.SpeedButton2Click(Sender: TObject);
begin
  if dtsExplicacao.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryExplicacao.Post;
  end;
  qryExplicacao.Prior;
end;

procedure TfrmCadastroExplicacao.SpeedButton4Click(Sender: TObject);
begin
  if dtsExplicacao.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryExplicacao.Post;
  end;
  qryExplicacao.Next;
end;

procedure TfrmCadastroExplicacao.SpeedButton1Click(Sender: TObject);
begin
  if dtsExplicacao.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryExplicacao.Post;
  end;
  qryExplicacao.Last;
end;

procedure TfrmCadastroExplicacao.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
