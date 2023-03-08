unit form_cadastro_Evento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses;

type
  Tcadastro_evento = class(TForm)
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
    dtsTipoFoto: TDataSource;
    qryTipoFoto: TIBQuery;
    udpTipoFoto: TIBUpdateSQL;
    Image1: TImage;
    qryTipoFotoCODIGO: TIntegerField;
    qryTipoFotoNOME: TIBStringField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryTipoFotoAfterPost(DataSet: TDataSet);
    procedure qryTipoFotoBeforeDelete(DataSet: TDataSet);
    procedure qryTipoFotoBeforePost(DataSet: TDataSet);
    procedure qryTipoFotoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsTipoFotoStateChange(Sender: TObject);
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
  cadastro_evento: Tcadastro_evento;

implementation

uses untPesquisa, untDados, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_evento.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin 
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_evento.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_evento.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_evento.dtsTipoFotoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_evento.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryTipoFoto.State in [dsInsert, dsEdit] then
       qryTipoFoto.Post;
  end;
end;

procedure Tcadastro_evento.btn_novoClick(Sender: TObject);
begin
  if dtsTipoFoto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryTipoFoto.Post;
  end;
  qryTipoFoto.Insert;
end;

procedure Tcadastro_evento.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsTipoFoto, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryTipoFoto.Delete;
end;

procedure Tcadastro_evento.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABEVENTO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryTipoFoto.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryTipoFotoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_evento.qryTipoFotoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_evento.qryTipoFotoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryTipoFotoCODIGO.Text + ' Nome: '+qryTipoFotoNOME.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_evento.qryTipoFotoBeforePost(DataSet: TDataSet);
begin
  IF qryTipoFotoCODIGO.Value = 0 THEN
    qryTipoFotoCODIGO.Value := Dados.NovoCodigo('TABEVENTO');
  if dtsTipoFoto.State = dsInsert then
    dados.Log(3, 'Código: '+ qryTipoFotoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsTipoFoto.State = dsEdit then
    dados.Log(4, 'Código: '+ qryTipoFotoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_evento.qryTipoFotoNewRecord(DataSet: TDataSet);
begin
  qryTipoFotoCODIGO.Value := 0;
end;

procedure Tcadastro_evento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsTipoFoto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoFoto.Post;
  end;
  qryTipoFoto.Close;
end;

procedure Tcadastro_evento.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Evento';
end;

procedure Tcadastro_evento.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryTipoFoto.Close;
    qryTipoFoto.Open;
    Dados.NovoRegistro(qryTipoFoto);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_evento.SpeedButton5Click(Sender: TObject);
begin
  if dtsTipoFoto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoFoto.Post;
  end;
  qryTipoFoto.First;
end;

procedure Tcadastro_evento.SpeedButton2Click(Sender: TObject);
begin
  if dtsTipoFoto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoFoto.Post;
  end;
  qryTipoFoto.Prior;
end;

procedure Tcadastro_evento.SpeedButton4Click(Sender: TObject);
begin
  if dtsTipoFoto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoFoto.Post;
  end;
  qryTipoFoto.Next;
end;

procedure Tcadastro_evento.SpeedButton1Click(Sender: TObject);
begin
  if dtsTipoFoto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoFoto.Post;
  end;
  qryTipoFoto.Last;
end;

procedure Tcadastro_evento.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
