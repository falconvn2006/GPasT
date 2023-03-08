unit form_cadastro_prospect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  ppDB, ppComm, ppRelatv, ppDBPipe, RxLookup, RxDBComb, wwdbdatetimepicker,
  wwdbedit, Grids, Wwdbigrd, Wwdbgrid, ExtDlgs, DateUtils, ACBrBase, ACBrSocket,
  ACBrCEP, ComCtrls;

type
  Tcadastro_prospect = class(TForm)
    lblCodigo: TLabel;
    Label30: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    edtCodigo: TDBEdit;
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    Label1: TLabel;
    lblNome: TLabel;
    edtNome: TDBEdit;
    Label35: TLabel;
    cbSexo: TRxDBComboBox;
    Label12: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Label17: TLabel;
    DBEdit24: TDBEdit;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilDATACADASTRO: TDateField;
    qryPerfilNOME: TIBStringField;
    qryPerfilSEXO: TIBStringField;
    qryPerfilNASCIMENTO: TDateField;
    qryPerfilCODIGOMUNICIPIONATURALIDADE: TIntegerField;
    qryPerfilESTADOCIVIL: TIntegerField;
    qryPerfilCODIGOTIPODOCUMENTO: TIntegerField;
    qryPerfilNUMERODOCUMENTO: TIBStringField;
    qryPerfilORGAOEMISSOR: TIBStringField;
    qryPerfilUFDOCUMENTO: TIBStringField;
    qryPerfilCPF: TIBStringField;
    qryPerfilCEP: TIBStringField;
    qryPerfilNUMERO: TIntegerField;
    qryPerfilCOMPLEMENTO: TIBStringField;
    qryPerfilTELRESIDENCIAL: TIBStringField;
    qryPerfilTELCELULAR: TIBStringField;
    qryPerfilTELCOMERCIAL: TIBStringField;
    qryPerfilTELRECADO: TIBStringField;
    qryPerfilPESSOARECADO: TIBStringField;
    qryPerfilEMAIL1: TIBStringField;
    qryPerfilFACEBOOK: TIBStringField;
    qryPerfilINSTAGRAM: TIBStringField;
    qryPerfilWHATSAPP: TIBStringField;
    qryPerfilOUTRO: TIBStringField;
    qryPerfilPONTUALIDADE: TIBStringField;
    qryPerfilCODIGOUSUARIO: TIntegerField;
    qryPerfilCODIGOTIPOPERFIL: TIntegerField;
    qryPerfilZELO: TIBStringField;
    qryPerfilOBSERVACOES: TMemoField;
    qryPerfilURLFOTO: TIBStringField;
    qryPerfilVERCAO: TIntegerField;
    qryPerfilNomeUsuario: TStringField;
    qryPerfilCODIGOBANCO: TIntegerField;
    qryPerfilAGENCIA: TIBStringField;
    qryPerfilOPERACAO_CONTA: TIBStringField;
    qryPerfilNUMERO_CONTA: TIBStringField;
    qryPerfilNOME_CLIENTE: TIBStringField;
    qryPerfilCPF_CLIENTE_BANCO: TIBStringField;
    qryPerfilIDADE: TIntegerField;
    qryPerfilCODIGOSITUACAO: TIntegerField;
    udpPerfil: TIBUpdateSQL;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    dtsUsuario: TDataSource;
    Label28: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel4: TPanel;
    DBEdit18: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    btn_novo: TSpeedButton;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryPerfilBeforeDelete(DataSet: TDataSet);
    procedure qryPerfilBeforePost(DataSet: TDataSet);
    procedure qryPerfilNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsPerfilStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryPerfilCalcFields(DataSet: TDataSet);
    procedure RxDBLookupCombo3Enter(Sender: TObject);
    procedure qryPerfilAfterPost(DataSet: TDataSet);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
    cOldCep, cOldSituacao : String;
    vCodigoInserido: Integer;
    { Public declarations }
    procedure VerificaPerfilBloqueado;
  end;

var
  cadastro_prospect: Tcadastro_prospect;

implementation

uses untPesquisa, untDados,Funcao,versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_prospect.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_prospect.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure Tcadastro_prospect.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_prospect.dtsPerfilStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_prospect.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryPerfil.State in [dsInsert, dsEdit] then
       qryPerfil.Post;
  end;
end;

procedure Tcadastro_prospect.btn_novoClick(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryPerfil.Post;
  end;
  qryPerfil.Insert;
end;

procedure Tcadastro_prospect.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsPerfil, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryPerfil.Delete;
end;

procedure Tcadastro_prospect.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABPERFIL';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryPerfil.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryPerfilCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_prospect.qryPerfilAfterPost(DataSet: TDataSet);
begin
   vCodigoInserido := qryPerfilCODIGO.AsInteger;
end;

procedure Tcadastro_prospect.qryPerfilBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryPerfilCODIGO.Text + ' Nome: '+qryPerfilNOME.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_prospect.qryPerfilBeforePost(DataSet: TDataSet);
begin
  IF qryPerfilCODIGO.Value = 0 THEN
    qryPerfilCODIGO.Value := Dados.NovoCodigo('tabperfil');
  if dtsPerfil.State = dsInsert then
    dados.Log(3, 'Código: '+ qryPerfilCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsPerfil.State = dsEdit then
    dados.Log(4, 'Código: '+ qryPerfilCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)));

  qryPerfilCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
  qryPerfilVERCAO.AsInteger := qryPerfilVERCAO.AsInteger + 1;
end;

procedure Tcadastro_prospect.qryPerfilCalcFields(DataSet: TDataSet);
begin
  if qryPerfilNASCIMENTO.AsDateTime > 0 then
    qryPerfilIDADE.AsInteger := YearsBetween(qryPerfilNASCIMENTO.AsDateTime,Date);
end;

procedure Tcadastro_prospect.qryPerfilNewRecord(DataSet: TDataSet);
begin
  qryPerfilCODIGO.Value := 0;
  qryPerfilDATACADASTRO.AsDateTime := Date;
  qryPerfilSEXO.Text := 'F';

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'Select first 1 codigo from tabtipoperfil where tipo = 6';
  Dados.Geral.Open;
  qryPerfilCODIGOTIPOPERFIL.Text := Dados.Geral.FieldByName('codigo').Text;
end;

procedure Tcadastro_prospect.RxDBLookupCombo3Enter(Sender: TObject);
begin
  cOldSituacao := qryPerfilCODIGOSITUACAO.Text;
end;

procedure Tcadastro_prospect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.Close;
end;

procedure Tcadastro_prospect.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Prospect';

  cbSexo.Items.Add('FEMININO');
  cbSexo.Items.Add('MASCULINO');
end;

procedure Tcadastro_prospect.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try

    qryUsuario.Close;
    qryUsuario.Open;

    qryPerfil.Close;
    qryPerfil.Open;

    cOldSituacao := '';
    vCodigoInserido := 0; 

    Dados.NovoRegistro(qryPerfil);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_prospect.SpeedButton5Click(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.First;
end;

procedure Tcadastro_prospect.VerificaPerfilBloqueado;
begin

end;

procedure Tcadastro_prospect.SpeedButton2Click(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.Prior;
end;

procedure Tcadastro_prospect.SpeedButton4Click(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.Next;
end;

procedure Tcadastro_prospect.SpeedButton1Click(Sender: TObject);
begin
  if dtsPerfil.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPerfil.Post;
  end;
  qryPerfil.Last;
end;

procedure Tcadastro_prospect.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
