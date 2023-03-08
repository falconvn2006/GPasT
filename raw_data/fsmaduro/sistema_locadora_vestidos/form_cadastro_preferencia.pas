unit form_cadastro_preferencia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, wwdbedit, Wwdotdot,
  Wwdbcomb, dxGDIPlusClasses;

type
  Tcadastro_preferencia = class(TForm)
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
    dtsPreferencias: TDataSource;
    qryPreferencias: TIBQuery;
    udpPreferencias: TIBUpdateSQL;
    Image1: TImage;
    qryPreferenciasCODIGO: TIntegerField;
    qryPreferenciasTIPO: TIBStringField;
    qryPreferenciasDESCRICAO: TIBStringField;
    Label1: TLabel;
    wwDBComboBox1: TwwDBComboBox;
    qryPreferenciasCODIGOAUX: TIBStringField;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryPreferenciasAfterPost(DataSet: TDataSet);
    procedure qryPreferenciasBeforeDelete(DataSet: TDataSet);
    procedure qryPreferenciasBeforePost(DataSet: TDataSet);
    procedure qryPreferenciasNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsPreferenciasStateChange(Sender: TObject);
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
  cadastro_preferencia: Tcadastro_preferencia;

implementation

uses untPesquisa, untDados, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_preferencia.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_preferencia.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_preferencia.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_preferencia.dtsPreferenciasStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_preferencia.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryPreferencias.State in [dsInsert, dsEdit] then
       qryPreferencias.Post;
  end;
end;

procedure Tcadastro_preferencia.btn_novoClick(Sender: TObject);
begin
  if dtsPreferencias.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryPreferencias.Post;
  end;
  qryPreferencias.Insert;
end;

procedure Tcadastro_preferencia.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsPreferencias, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryPreferencias.Delete;
end;

procedure Tcadastro_preferencia.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABpreferencias';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryPreferencias.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryPreferenciasCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_preferencia.qryPreferenciasAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_preferencia.qryPreferenciasBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryPreferenciasCODIGO.Text + ' Nome: '+qryPreferenciasDESCRICAO.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_preferencia.qryPreferenciasBeforePost(DataSet: TDataSet);
begin
  IF qryPreferenciasCODIGO.Value = 0 THEN
    qryPreferenciasCODIGO.Value := Dados.NovoCodigo('tabPreferencias');
  if dtsPreferencias.State = dsInsert then
    dados.Log(3, 'Código: '+ qryPreferenciasCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsPreferencias.State = dsEdit then
    dados.Log(4, 'Código: '+ qryPreferenciasCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_preferencia.qryPreferenciasNewRecord(DataSet: TDataSet);
begin
  qryPreferenciasCODIGO.Value := 0;
end;

procedure Tcadastro_preferencia.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsPreferencias.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPreferencias.Post;
  end;
  qryPreferencias.Close;
end;

procedure Tcadastro_preferencia.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Preferencias';
end;

procedure Tcadastro_preferencia.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryPreferencias.Close;
    qryPreferencias.Open;
    Dados.NovoRegistro(qryPreferencias);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_preferencia.SpeedButton5Click(Sender: TObject);
begin
  if dtsPreferencias.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPreferencias.Post;
  end;
  qryPreferencias.First;
end;

procedure Tcadastro_preferencia.SpeedButton2Click(Sender: TObject);
begin
  if dtsPreferencias.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPreferencias.Post;
  end;
  qryPreferencias.Prior;
end;

procedure Tcadastro_preferencia.SpeedButton4Click(Sender: TObject);
begin
  if dtsPreferencias.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPreferencias.Post;
  end;
  qryPreferencias.Next;
end;

procedure Tcadastro_preferencia.SpeedButton1Click(Sender: TObject);
begin
  if dtsPreferencias.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPreferencias.Post;
  end;
  qryPreferencias.Last;
end;

procedure Tcadastro_preferencia.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
