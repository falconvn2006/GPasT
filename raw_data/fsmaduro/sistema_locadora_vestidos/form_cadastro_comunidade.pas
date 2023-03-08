unit form_cadastro_comunidade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,  RXDBCtrl, StdCtrls, Mask, DBCtrls, Buttons,
  jpeg, untDados, DB, IBCustomDataSet, IBQuery, IBUpdateSQL, ExtDlgs,
  RxLookup, rxToolEdit, dxGDIPlusClasses;

type
  Tcadastro_comunidade = class(TForm)
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    Label1: TLabel;
    lblCodigo: TLabel;
    lblNome: TLabel;
    Label6: TLabel;
    Label30: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    edtCodigo: TDBEdit;
    edtNome: TDBEdit;
    DBEdit6: TDBEdit;
    Panel2: TPanel;
    DBDateEdit2: TDBDateEdit;
    Panel1: TPanel;
    DBEdit8: TDBEdit;
    Panel3: TPanel;
    DBEdit13: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    DBEdit12: TDBEdit;
    DBEdit15: TDBEdit;
    Label28: TLabel;
    Label29: TLabel;
    Label32: TLabel;
    Label34: TLabel;
    Panel4: TPanel;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit21: TDBEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Image1: TImage;
    qryComunidade: TIBQuery;
    udpComunidade: TIBUpdateSQL;
    dtsComunidade: TDataSource;
    qryComunidadeCEP: TIBStringField;
    dtsCep: TDataSource;
    qryCep: TIBQuery;
    qryCepCEP: TIBStringField;
    qryCepENDERECO: TIBStringField;
    qryCepBAIRRO: TIBStringField;
    qryCepCODIGOMUNICIPIO: TIntegerField;
    udpCep: TIBUpdateSQL;
    dtsCidadeUF: TDataSource;
    qryCidadeUF: TIBQuery;
    qryCidadeUFCODIGO: TIntegerField;
    qryCidadeUFNOME: TIBStringField;
    qryCidadeUFUF: TIBStringField;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    opdLogo: TOpenPictureDialog;
    cbcidade: TRxDBLookupCombo;
    cbUF: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    qryComunidadeCODIGO: TIntegerField;
    qryComunidadeDATACADASTRO: TDateField;
    qryComunidadeNOMEPAROQUIA: TIBStringField;
    qryComunidadeNOMECOMUNIDADE: TIBStringField;
    qryComunidadeNOMEDIOCESE: TIBStringField;
    qryComunidadeCNPJ: TIBStringField;
    qryComunidadeNUMERO: TIBStringField;
    qryComunidadeCOMPLEMENTO: TIBStringField;
    qryComunidadeTELA: TIBStringField;
    qryComunidadeTELB: TIBStringField;
    qryComunidadeTELC: TIBStringField;
    qryComunidadeFAX: TIBStringField;
    qryComunidadeEMAIL: TIBStringField;
    qryComunidadeSITE: TIBStringField;
    qryComunidadeURLLOGO: TMemoField;
    Image2: TImage;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure qryComunidadeAfterDelete(DataSet: TDataSet);
    procedure qryComunidadeAfterPost(DataSet: TDataSet);
    procedure qryComunidadeNewRecord(DataSet: TDataSet);
    procedure qryCepAfterOpen(DataSet: TDataSet);
    procedure qryCepBeforeClose(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryComunidadeCEPValidate(Sender: TField);
    procedure qryComunidadeAfterOpen(DataSet: TDataSet);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure qryComunidadeBeforeDelete(DataSet: TDataSet);
    procedure qryComunidadeBeforePost(DataSet: TDataSet);
    procedure Image1DblClick(Sender: TObject);
    procedure qryComunidadeAfterScroll(DataSet: TDataSet);
    procedure dtsComunidadeStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    NomeMenu: String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cadastro_comunidade: Tcadastro_comunidade;

implementation

uses untPesquisa;

{$R *.dfm}

procedure Tcadastro_comunidade.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsComunidade, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryComunidade.Delete;
end;

procedure Tcadastro_comunidade.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryComunidade.Post;
end;

procedure Tcadastro_comunidade.btn_novoClick(Sender: TObject);
begin
  if dtsComunidade.State in [dsEdit, dsInsert] then
    begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryComunidade.Post;
  end;
  qryComunidade.Insert;
end;

procedure Tcadastro_comunidade.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABCOMUNIDADE';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryComunidade.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);
  dados.Log(2, 'Código: '+ qryComunidadeCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));
end;

procedure Tcadastro_comunidade.btn_sairClick(Sender: TObject);
begin
  close;
end;

procedure Tcadastro_comunidade.dtsComunidadeStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_comunidade.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

procedure Tcadastro_comunidade.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if qryComunidade.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryComunidade.Post;
  end;
  qryComunidade.Close;
  qryCep.Close;
  qryCidadeUF.Close;
end;

procedure Tcadastro_comunidade.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Empresa1';
end;

procedure Tcadastro_comunidade.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;


  try
    qryComunidade.Close;
    qryCidadeUF.Close;
    //qryCep.close;
    qryComunidade.Open;
    qryCidadeUF.Open;
    //qryCep.Open;
    Dados.NovoRegistro(qryComunidade);
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_comunidade.qryCepAfterOpen(DataSet: TDataSet);
begin
  qryCidadeUF.Close;
  qryCidadeUF.Open;
end;

procedure Tcadastro_comunidade.qryCepBeforeClose(DataSet: TDataSet);
begin
  qryCidadeUF.close;
end;

procedure Tcadastro_comunidade.qryComunidadeAfterDelete(DataSet: TDataSet);
begin
  if dtsCep.State in [dsedit,dsinsert] then
     qryCep.Post;
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_comunidade.qryComunidadeAfterOpen(DataSet: TDataSet);
begin
  qryComunidadeCEPValidate(qryComunidadeCEP);
end;

procedure Tcadastro_comunidade.qryComunidadeAfterPost(DataSet: TDataSet);
begin
  if dtsCep.State in [dsedit,dsinsert] then
     qryCep.Post;
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_comunidade.qryComunidadeCEPValidate(Sender: TField);
begin
  if qryComunidadeCEP.Text <> '' then
  begin
    qryCep.Close;
    qryCep.SQL.Clear;
    qryCep.SQL.Add(' select * from TABCEP');
    qryCep.SQL.Add(' ');
    dados.Geral.Close;
    dados.Geral.sql.Text := 'Select Cep from tabcep where cep = ' + #39 + qryComunidadeCEP.Text +#39;
    dados.Geral.Open;
    if dados.Geral.IsEmpty then
    begin
      qryCep.Open;
      qryCep.Insert;
      qryCepCEP.Text := qryComunidadeCEP.Text;
    end
    else
    begin
      qryCep.SQL.Strings[1] := ' where cep = ' + #39 + qryComunidadeCEP.Text +#39;
      qryCep.Open;
    end;
  end
  else
    qryCep.Close;
end;

procedure Tcadastro_comunidade.qryComunidadeNewRecord(DataSet: TDataSet);
begin
  qryComunidadeCODIGO.Value := 0;
  qryComunidadeDATACADASTRO.AsDateTime := Date;
end;

procedure Tcadastro_comunidade.SpeedButton1Click(Sender: TObject);
begin
  if dtsComunidade.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryComunidade.Post;
  end;
  qryComunidade.Last;
end;

procedure Tcadastro_comunidade.SpeedButton2Click(Sender: TObject);
begin
  if dtsComunidade.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryComunidade.Post;
  end;
  qryComunidade.Prior;
end;

procedure Tcadastro_comunidade.SpeedButton4Click(Sender: TObject);
begin
  if dtsComunidade.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryComunidade.Post;
  end;
 qryComunidade.Next;
end;

procedure Tcadastro_comunidade.SpeedButton5Click(Sender: TObject);
begin
  if dtsComunidade.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryComunidade.Post;
  end;
  qryComunidade.First;
end;

procedure Tcadastro_comunidade.qryComunidadeBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryComunidadeCODIGO.Text + ' Nome: '+qryComunidadeNOMECOMUNIDADE.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_comunidade.qryComunidadeBeforePost(DataSet: TDataSet);
begin
  IF qryComunidadeCODIGO.Value = 0 THEN
    qryComunidadeCODIGO.Value := Dados.NovoCodigo('TABCOMUNIDADE');
  if dtsComunidade.State = dsInsert then
    dados.Log(3, 'Código: '+ qryComunidadeCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsComunidade.State = dsEdit then
    dados.Log(4, 'Código: '+ qryComunidadeCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_comunidade.Image1DblClick(Sender: TObject);
var
  arquivo : string;
begin
  {tratar melhor este campo}
  IF opdLogo.Execute Then
  begin
    arquivo := opdLogo.FileName;
    If FileExists(arquivo) Then
      Image1.Picture.LoadFromFile(arquivo)
    else
      Image1.Picture := nil;

    if not( dtsComunidade.State in [dsEdit, dsInsert]) then
      qryComunidade.Edit;

    qryComunidadeURLLOGO.Text := arquivo;
  end;
end;

procedure Tcadastro_comunidade.qryComunidadeAfterScroll(DataSet: TDataSet);
var
  arquivo : string;
begin
  arquivo := qryComunidadeURLLOGO.Text;

  If FileExists(arquivo) Then
    Image1.Picture.LoadFromFile(arquivo)
  else
    Image1.Picture := nil;
    
end;

end.
