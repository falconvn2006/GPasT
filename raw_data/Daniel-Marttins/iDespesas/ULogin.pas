unit ULogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, UCadastro, Data.DB, Data.Win.ADODB, UPrincipal;

type
  TFormLogin = class(TForm)
    pnMain: TPanel;
    pnInfos: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtUSUARIO: TEdit;
    edtSENHA: TEdit;
    QueryLogin: TADOQuery;
    QueryLoginUS_USUARIO: TStringField;
    QueryLoginUS_SENHA: TIntegerField;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.dfm}

uses UDados;

procedure TFormLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FormCadastro := TFormCadastro.Create(nil);

  try
    if Key = VK_RETURN then
      begin
        QueryLogin.SQL.Clear;
        QueryLogin.SQL.Text := 'SELECT US_USUARIO, US_SENHA FROM USUARIO WHERE US_USUARIO = '+ QuotedStr(edtUSUARIO.Text) + ' AND US_SENHA = '+ QuotedStr(edtSENHA.Text);
        QueryLogin.Open;

        if QueryLogin.RecordCount = 1 then
          try
            FormPrincipal.Show;
            FormLogin.Visible := False;
          finally

          end;
      end;
    if Key = VK_F2 then
    begin
      FormCadastro.Show;
      FormLogin.Visible := False;
    end;
  finally

  end;
end;

end.
