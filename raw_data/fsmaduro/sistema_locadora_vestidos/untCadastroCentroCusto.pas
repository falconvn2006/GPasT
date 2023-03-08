unit untCadastroCentroCusto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  wwdbedit, Wwdotdot, Wwdbcomb, wwdblook, Grids, Wwdbigrd, Wwdbgrid, RxLookup,
  ComCtrls, dxtree, dxdbtree;

type
  TfrmCadastroCentroCusto = class(TForm)
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsCentroCusto: TDataSource;
    qryCentroCusto: TIBQuery;
    updCentroCusto: TIBUpdateSQL;
    Panel1: TPanel;
    ViewCentroCusto: TdxDBTreeView;
    Panel2: TPanel;
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
    edtNome: TDBEdit;
    Image1: TImage;
    qryCentroCustoCODIGO: TIBStringField;
    qryCentroCustoNOME: TIBStringField;
    qryCentroCustoCONTAMAE: TIBStringField;
    qryCentroCustoCODIGOAUXILIAR: TIBStringField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryCentroCustoAfterPost(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsCentroCustoStateChange(Sender: TObject);
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
  frmCadastroCentroCusto: TfrmCadastroCentroCusto;

implementation

uses untPesquisa, untDados, funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmCadastroCentroCusto.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmCadastroCentroCusto.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmCadastroCentroCusto.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastroCentroCusto.dtsCentroCustoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmCadastroCentroCusto.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsCentroCusto, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryCentroCusto.Delete;
end;

procedure TfrmCadastroCentroCusto.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryCentroCusto.State in [dsInsert, dsEdit] then
       qryCentroCusto.Post;
  end;
end;

procedure TfrmCadastroCentroCusto.btn_novoClick(Sender: TObject);
begin
  ViewCentroCusto.Items.Add(ViewCentroCusto.Selected, 'Novo Item');
end;

procedure TfrmCadastroCentroCusto.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABCENTROCUSTO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := 'Nome';

  frmPesquisa.ShowModal;

  qryCentroCusto.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryCentroCustoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmCadastroCentroCusto.qryCentroCustoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmCadastroCentroCusto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsCentroCusto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryCentroCusto.Post;
  end;
  qryCentroCusto.Close;
end;

procedure TfrmCadastroCentroCusto.FormCreate(Sender: TObject);
begin
  NomeMenu := 'PlanodeContas1';
end;

procedure TfrmCadastroCentroCusto.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryCentroCusto.Close;
    qryCentroCusto.Open;
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmCadastroCentroCusto.SpeedButton5Click(Sender: TObject);
begin
  if dtsCentroCusto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryCentroCusto.Post;
  end;
  qryCentroCusto.First;
end;

procedure TfrmCadastroCentroCusto.SpeedButton2Click(Sender: TObject);
begin
  if dtsCentroCusto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryCentroCusto.Post;
  end;
  qryCentroCusto.Prior;
end;

procedure TfrmCadastroCentroCusto.SpeedButton4Click(Sender: TObject);
begin
  if dtsCentroCusto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryCentroCusto.Post;
  end;
  qryCentroCusto.Next;
end;

procedure TfrmCadastroCentroCusto.SpeedButton1Click(Sender: TObject);
begin
  if dtsCentroCusto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryCentroCusto.Post;
  end;
  qryCentroCusto.Last;
end;

procedure TfrmCadastroCentroCusto.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
