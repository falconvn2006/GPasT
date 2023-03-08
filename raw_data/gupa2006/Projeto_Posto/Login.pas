unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Conexao, Data.DB, Data.Win.ADODB, Principal;

type
  TfrmLogin = class(TForm)
    qryLogin: TADOQuery;
    btOK: TButton;
    edtLogin: TEdit;
    edtSenha: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    btSair: TButton;
    qryPosto: TADOQuery;
    procedure btOKClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
  private
    { Private declarations }
    function ValidarLogin:Boolean;
    function NomePosto:String;
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btOKClick(Sender: TObject);
Var
  Val : Boolean;
begin
  Val := ValidarLogin;
  if Val then
  begin
    Application.CreateForm(TfrmPrincipal,frmPrincipal);
    try
      frmPrincipal.lbNomePosto.Caption := NomePosto;
      frmPrincipal.ID_Posto := qryPosto.FieldByName('ID_Posto').AsString;
      frmPrincipal.ShowModal;
    finally
      FreeAndNil(frmPrincipal);
    end;
  end
  else
    MessageDlg('Login ou Senha incorreta', mtWarning,[mbOk], 0, mbOk);
end;

procedure TfrmLogin.btSairClick(Sender: TObject);
begin
  Close;
end;

function TfrmLogin.NomePosto: String;
begin
  qryPosto.Close;
  qryPosto.SQL.Text := '';
  qryPosto.SQL.Text := 'Select ID_Posto,Nome From Posto';
  qryPosto.Open;
  Result := qryPosto.FieldByName('Nome').AsString;
end;

function TfrmLogin.ValidarLogin: Boolean;
begin
  qryLogin.Close;
  qryLogin.SQL.Text := '';
  qryLogin.SQL.Text := 'Select COUNT(*) Valido From Acesso ';
  qryLogin.SQL.Text := qryLogin.SQL.Text + ' Where LoginUsuario = ''' + Trim(edtLogin.Text) + '''';
  qryLogin.SQL.Text := qryLogin.SQL.Text + ' And Senha = ' + edtSenha.Text;
  qryLogin.Open;
  Result := qryLogin.FieldByName('Valido').AsInteger > 0;
end;

end.
