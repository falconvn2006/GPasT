unit form_cadastro_Tipo_Manequim;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  Grids, Wwdbigrd, Wwdbgrid;

type
  Tcadastro_Tipo_Manequim = class(TForm)
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
    dtsTipoManequim: TDataSource;
    qryTipoManequim: TIBQuery;
    udpTipoManequim: TIBUpdateSQL;
    Image1: TImage;
    qryTipoManequimCODIGO: TIntegerField;
    qryTipoManequimDESCRICAO: TIBStringField;
    qryTipoManequimAPLICACAO: TIntegerField;
    DBRadioGroup1: TDBRadioGroup;
    GroupBox1: TGroupBox;
    wwDBGrid1: TwwDBGrid;
    dtsValorPadrao: TDataSource;
    qryValorPadrao: TIBQuery;
    updValorPadrao: TIBUpdateSQL;
    qryValorPadraoCODIGOTIPOMANEQUIM: TIntegerField;
    qryValorPadraoVALORINICIAL: TIBBCDField;
    qryValorPadraoVALORFINAL: TIBBCDField;
    qryValorPadraoDESCRICAO: TIBStringField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryTipoManequimAfterPost(DataSet: TDataSet);
    procedure qryTipoManequimBeforeDelete(DataSet: TDataSet);
    procedure qryTipoManequimBeforePost(DataSet: TDataSet);
    procedure qryTipoManequimNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsTipoManequimStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryValorPadraoNewRecord(DataSet: TDataSet);
    procedure qryTipoManequimAfterScroll(DataSet: TDataSet);
    procedure qryValorPadraoBeforePost(DataSet: TDataSet);
    procedure qryValorPadraoBeforeInsert(DataSet: TDataSet);

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
  cadastro_Tipo_Manequim: Tcadastro_Tipo_Manequim;

implementation

uses untPesquisa, untDados, versao, funcao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_Tipo_Manequim.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_Tipo_Manequim.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_Tipo_Manequim.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_Tipo_Manequim.dtsTipoManequimStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_Tipo_Manequim.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryTipoManequim.State in [dsInsert, dsEdit] then
       qryTipoManequim.Post;
  end;
end;

procedure Tcadastro_Tipo_Manequim.btn_novoClick(Sender: TObject);
begin
  if dtsTipoManequim.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryTipoManequim.Post;
  end;
  qryTipoManequim.Insert;
end;

procedure Tcadastro_Tipo_Manequim.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsTipoManequim, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryTipoManequim.Delete;
end;

procedure Tcadastro_Tipo_Manequim.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABTIPOMANEQUIM';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryTipoManequim.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryTipoManequimCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_Tipo_Manequim.qryTipoManequimAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_Tipo_Manequim.qryTipoManequimAfterScroll(DataSet: TDataSet);
begin
  qryValorPadrao.Close;
  qryValorPadrao.Open;
end;

procedure Tcadastro_Tipo_Manequim.qryTipoManequimBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryTipoManequimCODIGO.Text + ' Nome: '+qryTipoManequimDESCRICAO.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_Tipo_Manequim.qryTipoManequimBeforePost(DataSet: TDataSet);
begin
  IF qryTipoManequimCODIGO.Value = 0 THEN
    qryTipoManequimCODIGO.Value := Dados.NovoCodigo('TABTIPOMANEQUIM');
  if dtsTipoManequim.State = dsInsert then
    dados.Log(3, 'Código: '+ qryTipoManequimCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsTipoManequim.State = dsEdit then
    dados.Log(4, 'Código: '+ qryTipoManequimCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_Tipo_Manequim.qryTipoManequimNewRecord(DataSet: TDataSet);
begin
  qryTipoManequimCODIGO.Value := 0;
end;

procedure Tcadastro_Tipo_Manequim.qryValorPadraoBeforeInsert(DataSet: TDataSet);
begin
  if qryTipoManequim.State = dsInsert then
    qryTipoManequim.Post;
end;

procedure Tcadastro_Tipo_Manequim.qryValorPadraoBeforePost(DataSet: TDataSet);
begin
  if qryValorPadraoVALORINICIAL.AsInteger = 0 then
  begin
    application.MessageBox('Valor não informado!','',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;
end;

procedure Tcadastro_Tipo_Manequim.qryValorPadraoNewRecord(DataSet: TDataSet);
begin
  qryValorPadraoCODIGOTIPOMANEQUIM.AsInteger := qryTipoManequimCODIGO.AsInteger;
end;

procedure Tcadastro_Tipo_Manequim.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsTipoManequim.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoManequim.Post;
  end;
  qryTipoManequim.Close;
end;

procedure Tcadastro_Tipo_Manequim.FormCreate(Sender: TObject);
begin
  NomeMenu := 'TipoManequim';
end;

procedure Tcadastro_Tipo_Manequim.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryTipoManequim.Close;
    qryTipoManequim.Open;
    Dados.NovoRegistro(qryTipoManequim);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_Tipo_Manequim.SpeedButton5Click(Sender: TObject);
begin
  if dtsTipoManequim.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoManequim.Post;
  end;
  qryTipoManequim.First;
end;

procedure Tcadastro_Tipo_Manequim.SpeedButton2Click(Sender: TObject);
begin
  if dtsTipoManequim.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoManequim.Post;
  end;
  qryTipoManequim.Prior;
end;

procedure Tcadastro_Tipo_Manequim.SpeedButton4Click(Sender: TObject);
begin
  if dtsTipoManequim.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoManequim.Post;
  end;
  qryTipoManequim.Next;
end;

procedure Tcadastro_Tipo_Manequim.SpeedButton1Click(Sender: TObject);
begin
  if dtsTipoManequim.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryTipoManequim.Post;
  end;
  qryTipoManequim.Last;
end;

procedure Tcadastro_Tipo_Manequim.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
