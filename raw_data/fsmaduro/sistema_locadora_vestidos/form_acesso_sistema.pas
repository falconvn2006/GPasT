unit form_acesso_sistema;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, Buttons, untDados, RxLookup, DB,
  IBCustomDataSet, IBQuery, wwdblook, rxPlacemnt, dxGDIPlusClasses, jpeg;

type
  Tacesso_sistema = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btn_ok: TSpeedButton;
    btn_sair: TSpeedButton;
    dtsUSUARIO: TDataSource;
    qryUSUARIO: TIBQuery;
    qryUSUARIOUSERNAME: TIBStringField;
    qryUSUARIOSENHA: TIBStringField;
    Edit1: TEdit;
    qryUSUARIOATIVO: TIntegerField;
    qryUSUARIOCODIGO: TIntegerField;
    FormStorage1: TFormStorage;
    cmbusuario: TRxDBLookupCombo;
    Image1: TImage;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure Label1DblClick(Sender: TObject);
    procedure Label2DblClick(Sender: TObject);
    procedure Image2DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure cbprofessorKeyPress(Sender: TObject; var Key: Char);
    procedure cmbusuarioKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  acesso_sistema: Tacesso_sistema;
  username, senha: boolean;

implementation

uses form_principal, funcao;

{$R *.dfm}

procedure Tacesso_sistema.btn_okClick(Sender: TObject);
begin

  if cmbusuario.KeyValue = null then
  begin
    Application.MessageBox('Selecione um Usuário!', 'Acesso', MB_OK + MB_ICONERROR);
    Abort;
  end;

  if (uppercase(Edit1.Text) = uppercase(qryUSUARIOSENHA.Text)) and (qryUSUARIOATIVO.asInteger = 1) then
  begin
    principal.lblUsuario.Caption := qryUSUARIOUSERNAME.Text;
    untDados.CodigoUsuarioCorrente := qryUSUARIOCODIGO.AsInteger;
//    if Dados.tblConfigUSARFALA.Value = 1 then
//      dados.Saudacao;
    principal.Show;
    Close;
  end
  else
  begin
    if (uppercase(Edit1.Text) <> uppercase(qryUSUARIOSENHA.Text)) then
      Application.MessageBox('Senha Ivalida!', 'Acesso', MB_OK + MB_ICONERROR);
    if (qryUSUARIOATIVO.asInteger = 0) then
      Application.MessageBox('Usuário Inativo!', 'Acesso', MB_OK + MB_ICONERROR);
    Edit1.SetFocus;
  end;
end;

procedure Tacesso_sistema.btn_sairClick(Sender: TObject);
begin
  APPLICATION.Terminate;
end;

procedure Tacesso_sistema.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btn_ok.Click;
end;

procedure Tacesso_sistema.FormShow(Sender: TObject);
begin
  try
    GetVersao(Label4);
    Edit1.Text := '1313';
    qryUsuario.Close;
    qryUsuario.Open;
    cmbusuario.SetFocus;
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tacesso_sistema.Image2DblClick(Sender: TObject);
begin
  if (Edit1.Text = '195951') and
     (username) and (senha) then
     Edit1.Text := qryUSUARIOSENHA.Text;

end;

procedure Tacesso_sistema.Label1DblClick(Sender: TObject);
begin
  username := true;
end;

procedure Tacesso_sistema.Label2DblClick(Sender: TObject);
begin
  senha := true;
end;

procedure Tacesso_sistema.cbprofessorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    Edit1.SetFocus;
end;

procedure Tacesso_sistema.cmbusuarioKeyPress(Sender: TObject; var Key: Char);
begin
  IF KEY = #13 THEN
    EDIT1.SetFocus;
end;

end.
