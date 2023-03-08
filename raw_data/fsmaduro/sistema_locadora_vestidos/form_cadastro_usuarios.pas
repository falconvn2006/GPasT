unit form_cadastro_usuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RxDBComb, ExtCtrls, RXDBCtrl, Mask, DBCtrls,
  Buttons, RxLookup, DB, IBCustomDataSet, IBUpdateSQL, IBQuery, untDados,
   rxToolEdit, ComCtrls, dxtree, dxdbtree, Menus, dxGDIPlusClasses;

type
  Tcadastro_usuarios = class(TForm)
    Label1: TLabel;
    lblCodigo: TLabel;
    lblNome: TLabel;
    Label3: TLabel;
    Label12: TLabel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    edtCodigo: TDBEdit;
    edtNome: TDBEdit;
    DBDateEdit2: TDBDateEdit;
    Panel2: TPanel;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    btn_novo: TSpeedButton;
    qryUsuarios: TIBQuery;
    udpUsuarios: TIBUpdateSQL;
    dtsUsuarios: TDataSource;
    dtsNomeProfessor: TDataSource;
    qryNomeProfessor: TIBQuery;
    qryNomeProfessorCODIGO: TIntegerField;
    qryNomeProfessorNOME: TIBStringField;
    cbprofessor: TRxDBLookupCombo;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    qryUsuariosCODIGO: TIntegerField;
    qryUsuariosUSERNAME: TIBStringField;
    qryUsuariosSENHA: TIBStringField;
    DBCheckBox1: TDBCheckBox;
    Label2: TLabel;
    Panel1: TPanel;
    qryUsuariosDATACADASTRO: TDateField;
    qryUsuariosATIVO: TIntegerField;
    dxDBTreeView1: TdxDBTreeView;
    GroupBox2: TGroupBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    dtsAcessos: TDataSource;
    dseAcessos: TIBDataSet;
    PopupMenu1: TPopupMenu;
    SincronizarEstrutura1: TMenuItem;
    dseAcessosCODIGOUSUARIO: TIntegerField;
    dseAcessosNOMEMENU: TIBStringField;
    dseAcessosTITULOMENU: TIBStringField;
    dseAcessosATIVO: TIntegerField;
    dseAcessosABRIR: TIntegerField;
    dseAcessosALTERAR: TIntegerField;
    dseAcessosEXCLUIR: TIntegerField;
    dseAcessosINSERIR: TIntegerField;
    dseAcessosMENUMAE: TIBStringField;
    qryUsuariosCODIGOFUNCIONARIO: TIntegerField;
    Image1: TImage;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryUsuariosAfterPost(DataSet: TDataSet);
    procedure qryUsuariosNewRecord(DataSet: TDataSet);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure qryUsuariosBeforeDelete(DataSet: TDataSet);
    procedure qryUsuariosBeforePost(DataSet: TDataSet);
    procedure qryUsuariosAfterOpen(DataSet: TDataSet);
    procedure SincronizarEstrutura1Click(Sender: TObject);
    procedure dxDBTreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dtsUsuariosStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
    PrimeiroUsuario: Boolean;
    { Public declarations }
  end;

var
  cadastro_usuarios: Tcadastro_usuarios;

implementation

uses untPesquisa, form_principal, Funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_usuarios.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_usuarios.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_usuarios.btn_excluirClick(Sender: TObject);
begin

  dados.VerificaPermicaoOPBD(NomeMenu, dtsUsuarios, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryUsuarios.Delete;
end;

procedure Tcadastro_usuarios.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryUsuarios.State in [dsInsert, dsEdit] then
       qryUsuarios.Post;
  end;
end;

procedure Tcadastro_usuarios.btn_novoClick(Sender: TObject);
begin
  if qryUsuarios.State in [dsEdit, dsInsert] then
    begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryUsuarios.Post;
    end;
  qryUsuarios.Insert;
end;

procedure Tcadastro_usuarios.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABUSUARIOS';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryUsuarios.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);
  dados.Log(2, 'Código: '+ qryUsuariosCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));
end;

procedure Tcadastro_usuarios.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_usuarios.dtsUsuariosStateChange(Sender: TObject);
begin
  if not PrimeiroUsuario then
    dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_usuarios.dxDBTreeView1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  try
    if dseAcessos.state in [dsInsert,dsEdit] then
      dseAcessos.post;
  except
  end;
end;

procedure Tcadastro_usuarios.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure Tcadastro_usuarios.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if qryUsuarios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryUsuarios.Post;
  end;
  qryUsuarios.Close;
  qryNomeProfessor.Close;
end;

procedure Tcadastro_usuarios.FormCreate(Sender: TObject);
begin
  NomeMenu := 'cadastro_usuario';
end;

procedure Tcadastro_usuarios.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryUsuarios.Close;
    qryNomeProfessor.Close;
    qryUsuarios.Open;
    qryNomeProfessor.Open;
    Dados.NovoRegistro(qryUsuarios);
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_usuarios.qryUsuariosAfterOpen(DataSet: TDataSet);
begin
  dseAcessos.Close;
  dseAcessos.Open;
end;

procedure Tcadastro_usuarios.qryUsuariosAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;

  if dseAcessos.IsEmpty then
    SincronizarEstrutura1Click(Self);

end;

procedure Tcadastro_usuarios.qryUsuariosNewRecord(DataSet: TDataSet);
begin
  qryUsuariosCODIGO.Value := 0;
  qryUsuariosDATACADASTRO.AsDateTime := Date;
  qryUsuariosATIVO.Value := 1;
end;

procedure Tcadastro_usuarios.SincronizarEstrutura1Click(Sender: TObject);
var
  I, J: Integer;

begin

  if dtsUsuarios.State in [dsInsert] then
  begin
    application.MessageBox('Registro em Estado de Inserção.'+#13+
                           'Operação não Permitida','OPERAÇÃO INVALIDA',MB_OK+MB_ICONSTOP);
    abort;
  end
  else  if dtsUsuarios.State in [dsEdit] then
  begin
    if application.MessageBox('Registro em Estado de Edição.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryUsuarios.Post;
  end ;

  dados.Geral.sql.Text := 'delete from TABPERMICOESUSUARIO where CODIGOUSUARIO = '+ qryUsuariosCODIGO.Text;
  dados.Geral.ExecSql;
  dados.Geral.Transaction.CommitRetaining;

  with principal do
  begin
    for I := 0 to MainMenu1.Items.Count - 1 do
    begin
      if MainMenu1.Items[i].Caption <> '-' then
      begin
        dseAcessos.insert;
        dseAcessosCODIGOUSUARIO.Text := qryUsuariosCODIGO.text;
        dseAcessosMENUMAE.Text := 'menu';
        dseAcessosNOMEMENU.Text := MainMenu1.Items[i].Name;
        dseAcessosTITULOMENU.Text := RemoveCaracter(MainMenu1.Items[i].Caption,'&');
        dseAcessosATIVO.Value := 1;
        dseAcessosINSERIR.Value := 0;
        dseAcessosALTERAR.Value := 0;
        dseAcessosEXCLUIR.Value := 0;
        dseAcessosABRIR.Value := 1;
        dseAcessos.Post;
        for j := 0 to MainMenu1.Items[i].Count - 1 do
        begin
          if MainMenu1.Items[i].Items[j].Caption <> '-' then
          begin
            dseAcessos.insert;
            dseAcessosCODIGOUSUARIO.Text := qryUsuariosCODIGO.text;
            dseAcessosMENUMAE.Text := MainMenu1.Items[i].Name;
            dseAcessosNOMEMENU.Text := MainMenu1.Items[i].Items[j].Name;
            dseAcessosTITULOMENU.Text := RemoveCaracter(MainMenu1.Items[i].Items[j].Caption,'&');
            dseAcessosATIVO.Value := 1;
            dseAcessosINSERIR.Value := 1;
            dseAcessosALTERAR.Value := 1;
            dseAcessosEXCLUIR.Value := 1;
            dseAcessosABRIR.Value := 1;
            dseAcessos.Post;
          end;
        end;
      end;
    end;
  end;
end;

procedure Tcadastro_usuarios.SpeedButton1Click(Sender: TObject);
begin
  if dtsUsuarios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryUsuarios.Post;
  end;
  qryUsuarios.Last;
end;

procedure Tcadastro_usuarios.SpeedButton2Click(Sender: TObject);
begin
  if dtsUsuarios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryUsuarios.Post;
  end;
  qryUsuarios.Prior;
end;

procedure Tcadastro_usuarios.SpeedButton4Click(Sender: TObject);
begin
  if dtsUsuarios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryUsuarios.Post;
  end;
  qryUsuarios.Next;
end;

procedure Tcadastro_usuarios.SpeedButton5Click(Sender: TObject);
begin
  if dtsUsuarios.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryUsuarios.Post;
  end;
  qryUsuarios.First;
end;

procedure Tcadastro_usuarios.qryUsuariosBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryUsuariosCODIGO.Text + ' Nome: '+qryUsuariosUSERNAME.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_usuarios.qryUsuariosBeforePost(DataSet: TDataSet);
begin
  IF qryUsuariosCODIGO.Value = 0 THEN
    qryUsuariosCODIGO.Value := Dados.NovoCodigo('TABUSUARIOS');
  if dtsUsuarios.State = dsInsert then
    dados.Log(3, 'Código: '+ qryUsuariosCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsUsuarios.State = dsEdit then
    dados.Log(4, 'Código: '+ qryUsuariosCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

end.
