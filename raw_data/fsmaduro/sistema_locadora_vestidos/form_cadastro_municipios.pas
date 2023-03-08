unit form_cadastro_municipios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit;

type
  Tcadastro_municipios = class(TForm)
    Label1: TLabel;
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
    DBDateEdit2: TDBDateEdit;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsMunicipios: TDataSource;
    qryMunicipios: TIBQuery;
    udpMunicipios: TIBUpdateSQL;
    qryMunicipiosCODIGO: TIntegerField;
    qryMunicipiosDATACADASTRO: TDateField;
    qryMunicipiosNOME: TIBStringField;
    Label2: TLabel;
    DBComboBox1: TDBComboBox;
    qryMunicipiosUF: TIBStringField;
    Image1: TImage;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryMunicipiosAfterPost(DataSet: TDataSet);
    procedure qryMunicipiosBeforeDelete(DataSet: TDataSet);
    procedure qryMunicipiosBeforePost(DataSet: TDataSet);
    procedure qryMunicipiosNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsMunicipiosStateChange(Sender: TObject);
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
  cadastro_municipios: Tcadastro_municipios;

implementation

uses untPesquisa, untDados, versao;

{$R *.dfm}


//BOTÃO HELP
procedure Tcadastro_municipios.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin 
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_municipios.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_municipios.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_municipios.dtsMunicipiosStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_municipios.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryMunicipios.State in [dsInsert, dsEdit] then
       qryMunicipios.Post;
  end;
end;

procedure Tcadastro_municipios.btn_novoClick(Sender: TObject);
begin
  if dtsMunicipios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryMunicipios.Post;
  end;
  qryMunicipios.Insert;
end;

procedure Tcadastro_municipios.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsMunicipios, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryMunicipios.Delete;
end;

procedure Tcadastro_municipios.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABMUNICIPIOS';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryMunicipios.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryMunicipiosCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_municipios.qryMunicipiosAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_municipios.qryMunicipiosBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryMunicipiosCODIGO.Text + ' Nome: '+qryMunicipiosNOME.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_municipios.qryMunicipiosBeforePost(DataSet: TDataSet);
begin
  IF qryMunicipiosCODIGO.Value = 0 THEN
    qryMunicipiosCODIGO.Value := Dados.NovoCodigo('tabMunicipios');
  if dtsMunicipios.State = dsInsert then
    dados.Log(3, 'Código: '+ qryMunicipiosCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsMunicipios.State = dsEdit then
    dados.Log(4, 'Código: '+ qryMunicipiosCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_municipios.qryMunicipiosNewRecord(DataSet: TDataSet);
begin
  qryMunicipiosCODIGO.Value := 0;
  qryMunicipiosDATACADASTRO.AsDateTime := Date;
end;

procedure Tcadastro_municipios.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsMunicipios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryMunicipios.Post;
  end;
  qryMunicipios.Close;
end;

procedure Tcadastro_municipios.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Municpios1';
end;

procedure Tcadastro_municipios.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryMunicipios.Close;
    qryMunicipios.Open;
    Dados.NovoRegistro(qryMunicipios);
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_municipios.SpeedButton5Click(Sender: TObject);
begin
  if dtsMunicipios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryMunicipios.Post;
  end;
  qryMunicipios.First;
end;

procedure Tcadastro_municipios.SpeedButton2Click(Sender: TObject);
begin
  if dtsMunicipios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryMunicipios.Post;
  end;
  qryMunicipios.Prior;
end;

procedure Tcadastro_municipios.SpeedButton4Click(Sender: TObject);
begin
  if dtsMunicipios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryMunicipios.Post;
  end;
  qryMunicipios.Next;
end;

procedure Tcadastro_municipios.SpeedButton1Click(Sender: TObject);
begin
  if dtsMunicipios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryMunicipios.Post;
  end;
  qryMunicipios.Last;
end;

procedure Tcadastro_municipios.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
