unit form_cadastro_empresa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,  RXDBCtrl, StdCtrls, Mask, DBCtrls, Buttons,
  jpeg, untDados, DB, IBCustomDataSet, IBQuery, IBUpdateSQL, ExtDlgs, RxLookup, rxToolEdit;

type
  Tcadastro_empresa = class(TForm)
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
    Image2: TImage;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    DBEdit12: TDBEdit;
    DBEdit15: TDBEdit;
    Label28: TLabel;
    Label29: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Panel4: TPanel;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit22: TDBEdit;
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
    qryEmpresa: TIBQuery;
    udpEmpresa: TIBUpdateSQL;
    dtsEmpresa: TDataSource;
    qryEmpresaCODIGO: TIntegerField;
    qryEmpresaDATACADASTRO: TDateField;
    qryEmpresaRAZAOSOCIAL: TIBStringField;
    qryEmpresaNOMEFANTASIA: TIBStringField;
    qryEmpresaCNPJ: TIBStringField;
    qryEmpresaINSCRICAOESTADUAL: TIBStringField;
    qryEmpresaINSCRICAOMUNICIPAL: TIBStringField;
    qryEmpresaCEP: TIBStringField;
    qryEmpresaNUMERO: TIBStringField;
    qryEmpresaCOMPLEMENTO: TIBStringField;
    qryEmpresaTELA: TIBStringField;
    qryEmpresaTELB: TIBStringField;
    qryEmpresaTELC: TIBStringField;
    qryEmpresaCELULAR: TIBStringField;
    qryEmpresaFAX: TIBStringField;
    qryEmpresaEMAIL: TIBStringField;
    qryEmpresaSITE: TIBStringField;
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
    qryEmpresaURLLOGO: TIBStringField;
    cbcidade: TRxDBLookupCombo;
    cbUF: TDBEdit;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure qryEmpresaAfterDelete(DataSet: TDataSet);
    procedure qryEmpresaAfterPost(DataSet: TDataSet);
    procedure qryEmpresaNewRecord(DataSet: TDataSet);
    procedure qryCepAfterOpen(DataSet: TDataSet);
    procedure qryCepBeforeClose(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryEmpresaCEPValidate(Sender: TField);
    procedure qryEmpresaAfterOpen(DataSet: TDataSet);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure qryEmpresaBeforeDelete(DataSet: TDataSet);
    procedure qryEmpresaBeforePost(DataSet: TDataSet);
    procedure Image1DblClick(Sender: TObject);
    procedure qryEmpresaAfterScroll(DataSet: TDataSet);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cadastro_empresa: Tcadastro_empresa;

implementation

uses untPesquisa;

{$R *.dfm}

procedure Tcadastro_empresa.btn_excluirClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryEmpresa.Delete;
end;

procedure Tcadastro_empresa.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryEmpresa.Post;
end;

procedure Tcadastro_empresa.btn_novoClick(Sender: TObject);
begin
  if dtsEmpresa.State in [dsEdit, dsInsert] then
    begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryEmpresa.Post;
  end;
  qryEmpresa.Insert;
end;

procedure Tcadastro_empresa.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABEMPRESA';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryEmpresa.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);
  dados.Log(2, 'Código: '+ qryEmpresaCODIGO.Text + ' Janela: '+ copy(Caption,7,length(Caption)));
end;

procedure Tcadastro_empresa.btn_sairClick(Sender: TObject);
begin
  close;
end;

procedure Tcadastro_empresa.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,7,length(Caption)));
  except
  End;
end;

procedure Tcadastro_empresa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if qryEmpresa.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryEmpresa.Post;
  end;
  qryEmpresa.Close;
  qryCep.Close;
  qryCidadeUF.Close;
end;

procedure Tcadastro_empresa.FormShow(Sender: TObject);
begin
  TOP := 0;
  LEFT := 124;
  try
    qryEmpresa.Close;
    qryCidadeUF.Close;
    //qryCep.close;
    qryEmpresa.Open;
    qryCidadeUF.Open;
    //qryCep.Open;
    Dados.NovoRegistro(qryEmpresa);
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_empresa.qryCepAfterOpen(DataSet: TDataSet);
begin
  qryCidadeUF.Close;
  qryCidadeUF.Open;
end;

procedure Tcadastro_empresa.qryCepBeforeClose(DataSet: TDataSet);
begin
  qryCidadeUF.close;
end;

procedure Tcadastro_empresa.qryEmpresaAfterDelete(DataSet: TDataSet);
begin
  if dtsCep.State in [dsedit,dsinsert] then
     qryCep.Post;
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_empresa.qryEmpresaAfterOpen(DataSet: TDataSet);
begin
  qryEmpresaCEPValidate(qryEmpresaCEP);
end;

procedure Tcadastro_empresa.qryEmpresaAfterPost(DataSet: TDataSet);
begin
  if dtsCep.State in [dsedit,dsinsert] then
     qryCep.Post;
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_empresa.qryEmpresaCEPValidate(Sender: TField);
begin
  if qryEmpresaCEP.Text <> '' then
  begin
    qryCep.Close;
    qryCep.SQL.Clear;
    qryCep.SQL.Add(' select * from TABCEP');
    qryCep.SQL.Add(' ');
    dados.Geral.Close;
    dados.Geral.sql.Text := 'Select Cep from tabcep where cep = ' + #39 + qryEmpresaCEP.Text +#39;
    dados.Geral.Open;
    if dados.Geral.IsEmpty then
    begin
      qryCep.Open;
      qryCep.Insert;
      qryCepCEP.Text := qryEmpresaCEP.Text;
    end
    else
    begin
      qryCep.SQL.Strings[1] := ' where cep = ' + #39 + qryEmpresaCEP.Text +#39;
      qryCep.Open;
    end;
  end
  else
    qryCep.Close;
end;

procedure Tcadastro_empresa.qryEmpresaNewRecord(DataSet: TDataSet);
begin
  qryEmpresaCODIGO.Value := 0;
  qryEmpresaDATACADASTRO.AsDateTime := Date;
end;

procedure Tcadastro_empresa.SpeedButton1Click(Sender: TObject);
begin
  if dtsEmpresa.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryEmpresa.Post;
  end;
  qryEmpresa.Last;
end;

procedure Tcadastro_empresa.SpeedButton2Click(Sender: TObject);
begin
  if dtsEmpresa.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryEmpresa.Post;
  end;
  qryEmpresa.Prior;
end;

procedure Tcadastro_empresa.SpeedButton4Click(Sender: TObject);
begin
  if dtsEmpresa.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryEmpresa.Post;
  end;
 qryEmpresa.Next;
end;

procedure Tcadastro_empresa.SpeedButton5Click(Sender: TObject);
begin
  if dtsEmpresa.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryEmpresa.Post;
  end;
  qryEmpresa.First;
end;

procedure Tcadastro_empresa.qryEmpresaBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryEmpresaCODIGO.Text + ' Nome: '+qryEmpresaRAZAOSOCIAL.Text+' Janela: '+copy(Caption,7,length(Caption)));

end;

procedure Tcadastro_empresa.qryEmpresaBeforePost(DataSet: TDataSet);
begin
  IF qryEmpresaCODIGO.Value = 0 THEN
    qryEmpresaCODIGO.Value := Dados.NovoCodigo('TABEMPRESA');
  if dtsEmpresa.State = dsInsert then
    dados.Log(3, 'Código: '+ qryEmpresaCODIGO.Text + ' Janela: '+copy(Caption,7,length(Caption)))
  else if dtsEmpresa.State = dsEdit then
    dados.Log(4, 'Código: '+ qryEmpresaCODIGO.Text + ' Janela: '+copy(Caption,7,length(Caption)))
end;

procedure Tcadastro_empresa.Image1DblClick(Sender: TObject);
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

    if not( dtsEmpresa.State in [dsEdit, dsInsert]) then
      qryEmpresa.Edit;

    qryEmpresaURLLOGO.Text := arquivo;
  end;
end;

procedure Tcadastro_empresa.qryEmpresaAfterScroll(DataSet: TDataSet);
var
  arquivo : string;
begin
  arquivo := qryEmpresaURLLOGO.Text;

  If FileExists(arquivo) Then
    Image1.Picture.LoadFromFile(arquivo)
  else
    Image1.Picture := nil;
    
end;

end.
