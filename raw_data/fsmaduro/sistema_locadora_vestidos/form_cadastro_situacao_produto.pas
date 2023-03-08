unit form_cadastro_situacao_produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  wwdbedit, Wwdotdot, Wwdbcomb;

type
  Tcadastro_situacao_produto = class(TForm)
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
    dtsSituacaoProduto: TDataSource;
    qrySituacaoProduto: TIBQuery;
    udpSituacaoProduto: TIBUpdateSQL;
    Image1: TImage;
    qrySituacaoProdutoCODIGO: TIntegerField;
    qrySituacaoProdutoDESCRICAO: TIBStringField;
    DBRadioGroup1: TDBRadioGroup;
    qrySituacaoProdutoAPLICACAO: TIntegerField;
    qrySituacaoProdutoOPERACAO: TIntegerField;
    qrySituacaoProdutoDIASREAVALIACAO: TIntegerField;
    DBEdit12: TDBEdit;
    Label2: TLabel;
    DBRadioGroup2: TDBRadioGroup;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qrySituacaoProdutoAfterPost(DataSet: TDataSet);
    procedure qrySituacaoProdutoBeforeDelete(DataSet: TDataSet);
    procedure qrySituacaoProdutoBeforePost(DataSet: TDataSet);
    procedure qrySituacaoProdutoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsSituacaoProdutoStateChange(Sender: TObject);
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
  cadastro_situacao_produto: Tcadastro_situacao_produto;

implementation

uses untPesquisa, untDados, funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_situacao_produto.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_situacao_produto.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_situacao_produto.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_situacao_produto.dtsSituacaoProdutoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_situacao_produto.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qrySituacaoProduto.State in [dsInsert, dsEdit] then
       qrySituacaoProduto.Post;
  end;
end;

procedure Tcadastro_situacao_produto.btn_novoClick(Sender: TObject);
begin
  if dtsSituacaoProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qrySituacaoProduto.Post;
  end;
  qrySituacaoProduto.Insert;
end;

procedure Tcadastro_situacao_produto.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsSituacaoProduto, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qrySituacaoProduto.Delete;
end;

procedure Tcadastro_situacao_produto.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABSITUACAOPRODUTO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qrySituacaoProduto.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qrySituacaoProdutoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_situacao_produto.qrySituacaoProdutoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_situacao_produto.qrySituacaoProdutoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qrySituacaoProdutoCODIGO.Text + ' Nome: '+qrySituacaoProdutoDESCRICAO.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_situacao_produto.qrySituacaoProdutoBeforePost(DataSet: TDataSet);
begin
  IF qrySituacaoProdutoCODIGO.Value = 0 THEN
    qrySituacaoProdutoCODIGO.Value := Dados.NovoCodigo('tabSituacaoProduto');
  if dtsSituacaoProduto.State = dsInsert then
    dados.Log(3, 'Código: '+ qrySituacaoProdutoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsSituacaoProduto.State = dsEdit then
    dados.Log(4, 'Código: '+ qrySituacaoProdutoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_situacao_produto.qrySituacaoProdutoNewRecord(DataSet: TDataSet);
begin
  qrySituacaoProdutoCODIGO.Value := 0;
end;

procedure Tcadastro_situacao_produto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsSituacaoProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qrySituacaoProduto.Post;
  end;
  qrySituacaoProduto.Close;
end;

procedure Tcadastro_situacao_produto.FormCreate(Sender: TObject);
begin
  NomeMenu := 'SituaodoProduto';
end;

procedure Tcadastro_situacao_produto.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qrySituacaoProduto.Close;
    qrySituacaoProduto.Open;
    Dados.NovoRegistro(qrySituacaoProduto);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_situacao_produto.SpeedButton5Click(Sender: TObject);
begin
  if dtsSituacaoProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qrySituacaoProduto.Post;
  end;
  qrySituacaoProduto.First;
end;

procedure Tcadastro_situacao_produto.SpeedButton2Click(Sender: TObject);
begin
  if dtsSituacaoProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qrySituacaoProduto.Post;
  end;
  qrySituacaoProduto.Prior;
end;

procedure Tcadastro_situacao_produto.SpeedButton4Click(Sender: TObject);
begin
  if dtsSituacaoProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qrySituacaoProduto.Post;
  end;
  qrySituacaoProduto.Next;
end;

procedure Tcadastro_situacao_produto.SpeedButton1Click(Sender: TObject);
begin
  if dtsSituacaoProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qrySituacaoProduto.Post;
  end;
  qrySituacaoProduto.Last;
end;

procedure Tcadastro_situacao_produto.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
