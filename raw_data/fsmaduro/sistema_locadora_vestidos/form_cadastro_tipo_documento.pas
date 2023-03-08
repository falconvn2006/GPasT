unit form_cadastro_tipo_documento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses;

type
  Tcadastro_tipo_documento = class(TForm)
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
    dtsTipoDocumento: TDataSource;
    qryTipoDocumento: TIBQuery;
    udpTipoDocumento: TIBUpdateSQL;
    Image1: TImage;
    qryTipoDocumentoCODIGO: TIntegerField;
    qryTipoDocumentoNOME: TIBStringField;
    DBRadioGroup1: TDBRadioGroup;
    qryTipoDocumentoAPLICACAO: TIntegerField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryTipoDocumentoAfterPost(DataSet: TDataSet);
    procedure qryTipoDocumentoBeforeDelete(DataSet: TDataSet);
    procedure qryTipoDocumentoBeforePost(DataSet: TDataSet);
    procedure qryTipoDocumentoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsTipoDocumentoStateChange(Sender: TObject);
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
  cadastro_tipo_documento: Tcadastro_tipo_documento;

implementation

uses untPesquisa, untDados, versao, funcao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_tipo_documento.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_tipo_documento.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_tipo_documento.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_tipo_documento.dtsTipoDocumentoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_tipo_documento.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryTipoDocumento.State in [dsInsert, dsEdit] then
       qryTipoDocumento.Post;
  end;
end;

procedure Tcadastro_tipo_documento.btn_novoClick(Sender: TObject);
begin
  if dtsTipoDocumento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryTipoDocumento.Post;
  end;
  qryTipoDocumento.Insert;
end;

procedure Tcadastro_tipo_documento.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsTipoDocumento, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryTipoDocumento.Delete;
end;

procedure Tcadastro_tipo_documento.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABTIPODOCUMENTO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryTipoDocumento.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryTipoDocumentoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_tipo_documento.qryTipoDocumentoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_tipo_documento.qryTipoDocumentoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryTipoDocumentoCODIGO.Text + ' Nome: '+qryTipoDocumentoNOME.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_tipo_documento.qryTipoDocumentoBeforePost(DataSet: TDataSet);
begin
  IF qryTipoDocumentoCODIGO.Value = 0 THEN
    qryTipoDocumentoCODIGO.Value := Dados.NovoCodigo('tabtipodocumento');
  if dtsTipoDocumento.State = dsInsert then
    dados.Log(3, 'Código: '+ qryTipoDocumentoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsTipoDocumento.State = dsEdit then
    dados.Log(4, 'Código: '+ qryTipoDocumentoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_tipo_documento.qryTipoDocumentoNewRecord(DataSet: TDataSet);
begin
  qryTipoDocumentoCODIGO.Value := 0;
end;

procedure Tcadastro_tipo_documento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsTipoDocumento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoDocumento.Post;
  end;
  qryTipoDocumento.Close;
end;

procedure Tcadastro_tipo_documento.FormCreate(Sender: TObject);
begin
  NomeMenu := 'TipoDocumento';
end;

procedure Tcadastro_tipo_documento.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryTipoDocumento.Close;
    qryTipoDocumento.Open;
    Dados.NovoRegistro(qryTipoDocumento);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_tipo_documento.SpeedButton5Click(Sender: TObject);
begin
  if dtsTipoDocumento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoDocumento.Post;
  end;
  qryTipoDocumento.First;
end;

procedure Tcadastro_tipo_documento.SpeedButton2Click(Sender: TObject);
begin
  if dtsTipoDocumento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoDocumento.Post;
  end;
  qryTipoDocumento.Prior;
end;

procedure Tcadastro_tipo_documento.SpeedButton4Click(Sender: TObject);
begin
  if dtsTipoDocumento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoDocumento.Post;
  end;
  qryTipoDocumento.Next;
end;

procedure Tcadastro_tipo_documento.SpeedButton1Click(Sender: TObject);
begin
  if dtsTipoDocumento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoDocumento.Post;
  end;
  qryTipoDocumento.Last;
end;

procedure Tcadastro_tipo_documento.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
