unit untCadastroPlanoContas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  wwdbedit, Wwdotdot, Wwdbcomb, wwdblook, Grids, Wwdbigrd, Wwdbgrid, RxLookup,
  ComCtrls, dxtree, dxdbtree;

type
  TfrmCadastroPlanoContas = class(TForm)
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsPlanoContas: TDataSource;
    qryPlanoContas: TIBQuery;
    updPlanoContas: TIBUpdateSQL;
    Panel1: TPanel;
    ViewPlaContas: TdxDBTreeView;
    Panel2: TPanel;
    qryPlanoContasCODIGO: TIBStringField;
    qryPlanoContasNOME: TIBStringField;
    qryPlanoContasCONTAMAE: TIBStringField;
    qryPlanoContasNATUREZA: TIntegerField;
    qryPlanoContasCODIGOAUXILIAR: TIBStringField;
    lblCodigo: TLabel;
    Label30: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    edtCodigo: TDBEdit;
    Panel3: TPanel;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    wwDBComboBox1: TwwDBComboBox;
    Label2: TLabel;
    edtNome: TDBEdit;
    Image1: TImage;
    wwDBComboBox2: TwwDBComboBox;
    Label3: TLabel;
    qryPlanoContasTIPO: TIntegerField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryPlanoContasAfterPost(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsPlanoContasStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);

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
  frmCadastroPlanoContas: TfrmCadastroPlanoContas;

implementation

uses untPesquisa, untDados, funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmCadastroPlanoContas.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmCadastroPlanoContas.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmCadastroPlanoContas.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastroPlanoContas.dtsPlanoContasStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmCadastroPlanoContas.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsPlanoContas, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryPlanoContas.Delete;
end;

procedure TfrmCadastroPlanoContas.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryPlanoContas.State in [dsInsert, dsEdit] then
       qryPlanoContas.Post;
  end;
end;

procedure TfrmCadastroPlanoContas.btn_novoClick(Sender: TObject);
begin
  ViewPlaContas.Items.Add(ViewPlaContas.Selected, 'Novo Item');
end;

procedure TfrmCadastroPlanoContas.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABPLANOCONTAS';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := 'Nome';

  frmPesquisa.ShowModal;

  qryPlanoContas.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryPlanoContasCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmCadastroPlanoContas.qryPlanoContasAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmCadastroPlanoContas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsPlanoContas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPlanoContas.Post;
  end;
  qryPlanoContas.Close;
end;

procedure TfrmCadastroPlanoContas.FormCreate(Sender: TObject);
begin
  NomeMenu := 'PlanodeContas1';
end;

procedure TfrmCadastroPlanoContas.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryPlanoContas.Close;
    qryPlanoContas.Open;
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmCadastroPlanoContas.SpeedButton5Click(Sender: TObject);
begin
  if dtsPlanoContas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPlanoContas.Post;
  end;
  qryPlanoContas.First;
end;

procedure TfrmCadastroPlanoContas.SpeedButton2Click(Sender: TObject);
begin
  if dtsPlanoContas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPlanoContas.Post;
  end;
  qryPlanoContas.Prior;
end;

procedure TfrmCadastroPlanoContas.SpeedButton4Click(Sender: TObject);
begin
  if dtsPlanoContas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPlanoContas.Post;
  end;
  qryPlanoContas.Next;
end;

procedure TfrmCadastroPlanoContas.SpeedButton1Click(Sender: TObject);
begin
  if dtsPlanoContas.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPlanoContas.Post;
  end;
  qryPlanoContas.Last;
end;

procedure TfrmCadastroPlanoContas.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
