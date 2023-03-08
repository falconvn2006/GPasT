unit form_cadastro_Tipo_Perfil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses;

type
  Tcadastro_Tipo_Perfil = class(TForm)
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
    dtsTipoPerfil: TDataSource;
    qryTipoPerfil: TIBQuery;
    udpTipoPerfil: TIBUpdateSQL;
    Image1: TImage;
    qryTipoPerfilCODIGO: TIntegerField;
    qryTipoPerfilDESCRICAO: TIBStringField;
    DBRadioGroup1: TDBRadioGroup;
    qryTipoPerfilTIPO: TIntegerField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryTipoPerfilAfterPost(DataSet: TDataSet);
    procedure qryTipoPerfilBeforeDelete(DataSet: TDataSet);
    procedure qryTipoPerfilBeforePost(DataSet: TDataSet);
    procedure qryTipoPerfilNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsTipoPerfilStateChange(Sender: TObject);
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
  cadastro_Tipo_Perfil: Tcadastro_Tipo_Perfil;

implementation

uses untPesquisa, untDados, versao, funcao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_Tipo_Perfil.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_Tipo_Perfil.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_Tipo_Perfil.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_Tipo_Perfil.dtsTipoPerfilStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_Tipo_Perfil.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryTipoPerfil.State in [dsInsert, dsEdit] then
       qryTipoPerfil.Post;
  end;
end;

procedure Tcadastro_Tipo_Perfil.btn_novoClick(Sender: TObject);
begin
  if dtsTipoPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryTipoPerfil.Post;
  end;
  qryTipoPerfil.Insert;
end;

procedure Tcadastro_Tipo_Perfil.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsTipoPerfil, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryTipoPerfil.Delete;
end;

procedure Tcadastro_Tipo_Perfil.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABTIPOPERFIL';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryTipoPerfil.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryTipoPerfilCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_Tipo_Perfil.qryTipoPerfilAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_Tipo_Perfil.qryTipoPerfilBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryTipoPerfilCODIGO.Text + ' Nome: '+qryTipoPerfilDESCRICAO.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_Tipo_Perfil.qryTipoPerfilBeforePost(DataSet: TDataSet);
begin
  IF qryTipoPerfilCODIGO.Value = 0 THEN
    qryTipoPerfilCODIGO.Value := Dados.NovoCodigo('TABTIPOPERFIL');
  if dtsTipoPerfil.State = dsInsert then
    dados.Log(3, 'Código: '+ qryTipoPerfilCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsTipoPerfil.State = dsEdit then
    dados.Log(4, 'Código: '+ qryTipoPerfilCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_Tipo_Perfil.qryTipoPerfilNewRecord(DataSet: TDataSet);
begin
  qryTipoPerfilCODIGO.Value := 0;
end;

procedure Tcadastro_Tipo_Perfil.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsTipoPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoPerfil.Post;
  end;
  qryTipoPerfil.Close;
end;

procedure Tcadastro_Tipo_Perfil.FormCreate(Sender: TObject);
begin
  NomeMenu := 'TipoPerfil';
end;

procedure Tcadastro_Tipo_Perfil.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryTipoPerfil.Close;
    qryTipoPerfil.Open;
    Dados.NovoRegistro(qryTipoPerfil);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_Tipo_Perfil.SpeedButton5Click(Sender: TObject);
begin
  if dtsTipoPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoPerfil.Post;
  end;
  qryTipoPerfil.First;
end;

procedure Tcadastro_Tipo_Perfil.SpeedButton2Click(Sender: TObject);
begin
  if dtsTipoPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoPerfil.Post;
  end;
  qryTipoPerfil.Prior;
end;

procedure Tcadastro_Tipo_Perfil.SpeedButton4Click(Sender: TObject);
begin
  if dtsTipoPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoPerfil.Post;
  end;
  qryTipoPerfil.Next;
end;

procedure Tcadastro_Tipo_Perfil.SpeedButton1Click(Sender: TObject);
begin
  if dtsTipoPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoPerfil.Post;
  end;
  qryTipoPerfil.Last;
end;

procedure Tcadastro_Tipo_Perfil.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
