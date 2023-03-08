unit form_cadastro_Avaliacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  Grids, Wwdbigrd, Wwdbgrid, versao;

type
  Tcadastro_Avaliacao = class(TForm)
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
    dtsAvaliacao: TDataSource;
    qryAvaliacao: TIBQuery;
    updAvaliacao: TIBUpdateSQL;
    Image1: TImage;
    DBRadioGroup1: TDBRadioGroup;
    GroupBox1: TGroupBox;
    grdDetalhe: TwwDBGrid;
    dtsAvaliacaoDetalhe: TDataSource;
    qryAvaliacaoDetalhe: TIBQuery;
    updAvaliacaoDetalhe: TIBUpdateSQL;
    qryAvaliacaoCODIGO: TIntegerField;
    qryAvaliacaoDESCRICAO: TIBStringField;
    qryAvaliacaoAPLICACAO: TIntegerField;
    qryAvaliacaoDetalheCODIGOAVALIACAO: TIntegerField;
    qryAvaliacaoDetalheID: TIntegerField;
    qryAvaliacaoDetalheDESCRICAO: TIBStringField;
    qryAvaliacaoDetalheVALOR: TIBBCDField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryAvaliacaoAfterPost(DataSet: TDataSet);
    procedure qryAvaliacaoBeforeDelete(DataSet: TDataSet);
    procedure qryAvaliacaoBeforePost(DataSet: TDataSet);
    procedure qryAvaliacaoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsAvaliacaoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryAvaliacaoDetalheNewRecord(DataSet: TDataSet);
    procedure qryAvaliacaoAfterScroll(DataSet: TDataSet);
    procedure qryAvaliacaoDetalheBeforeInsert(DataSet: TDataSet);

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
  cadastro_Avaliacao: Tcadastro_Avaliacao;

Const
  cCaption = 'CADASTRO DE AVALIAÇÃO';

implementation

uses untPesquisa, untDados, funcao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_Avaliacao.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin 
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_Avaliacao.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_Avaliacao.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_Avaliacao.dtsAvaliacaoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_Avaliacao.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryAvaliacao.State in [dsInsert, dsEdit] then
       qryAvaliacao.Post;
  end;
end;

procedure Tcadastro_Avaliacao.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryAvaliacao.Insert;
end;

procedure Tcadastro_Avaliacao.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsAvaliacao, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryAvaliacao.Delete;
end;

procedure Tcadastro_Avaliacao.btn_pesquisarClick(Sender: TObject);
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
    qryAvaliacao.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryAvaliacaoCODIGO.Text + ' Janela: '+ cCaption);

end;

procedure Tcadastro_Avaliacao.qryAvaliacaoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_Avaliacao.qryAvaliacaoAfterScroll(DataSet: TDataSet);
begin
  qryAvaliacaoDetalhe.Close;
  qryAvaliacaoDetalhe.Open;
end;

procedure Tcadastro_Avaliacao.qryAvaliacaoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryAvaliacaoCODIGO.Text + ' Nome: '+qryAvaliacaoDESCRICAO.Text+' Janela: '+cCaption);

end;

procedure Tcadastro_Avaliacao.qryAvaliacaoBeforePost(DataSet: TDataSet);
begin
  IF qryAvaliacaoCODIGO.Value = 0 THEN
    qryAvaliacaoCODIGO.Value := Dados.NovoCodigo('TABAVALIACAO');
  if dtsAvaliacao.State = dsInsert then
    dados.Log(3, 'Código: '+ qryAvaliacaoCODIGO.Text + ' Janela: '+cCaption)
  else if dtsAvaliacao.State = dsEdit then
    dados.Log(4, 'Código: '+ qryAvaliacaoCODIGO.Text + ' Janela: '+cCaption)
end;

procedure Tcadastro_Avaliacao.qryAvaliacaoNewRecord(DataSet: TDataSet);
begin
  qryAvaliacaoCODIGO.Value := 0;
end;

procedure Tcadastro_Avaliacao.qryAvaliacaoDetalheBeforeInsert(
  DataSet: TDataSet);
begin
  if qryAvaliacao.State = dsInsert then
    qryAvaliacao.Post;
end;

procedure Tcadastro_Avaliacao.qryAvaliacaoDetalheNewRecord(DataSet: TDataSet);
begin

  qryAvaliacaoDetalheCODIGOAVALIACAO.AsInteger := qryAvaliacaoCODIGO.AsInteger;

  qryAvaliacaoDetalheID.Value := Dados.NovoCodigo('TABAVALIACAODETALHE','ID','CODIGOAVALIACAO = 0'+qryAvaliacaoCODIGO.Text);
  
end;

procedure Tcadastro_Avaliacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryAvaliacao.Close;
end;

procedure Tcadastro_Avaliacao.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Avaliao1';
  CarregarImagem(Image1,'topo.png');
  Caption := CaptionTela(cCaption);
end;

procedure Tcadastro_Avaliacao.FormShow(Sender: TObject);
begin
  TOP := 0;
  LEFT := 124;
  try
    qryAvaliacao.Close;
    qryAvaliacao.Open;
    Dados.NovoRegistro(qryAvaliacao);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_Avaliacao.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryAvaliacao.First;
end;

procedure Tcadastro_Avaliacao.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryAvaliacao.Prior;
end;

procedure Tcadastro_Avaliacao.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryAvaliacao.Next;
end;

procedure Tcadastro_Avaliacao.SalvarRegistro;
begin
  if dtsAvaliacao.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryAvaliacao.Post;
  end;
end;

procedure Tcadastro_Avaliacao.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryAvaliacao.Last;
end;

procedure Tcadastro_Avaliacao.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,cCaption);
  except
  End;
end;

end.
