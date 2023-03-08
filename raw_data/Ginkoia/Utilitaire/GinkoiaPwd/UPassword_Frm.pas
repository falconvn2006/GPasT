unit UPassword_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrmPwd = class(TForm)
    LblPassword: TLabel;
    EdtPassword: TEdit;
    BtnChiffrer: TButton;
    BtnDechiffrer: TButton;
    ChbClipboard: TCheckBox;
    RdbAnsi: TRadioButton;
    RdbUnicode: TRadioButton;
    procedure BtnChiffrerClick(Sender: TObject);
    procedure BtnDechiffrerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdtPasswordChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FrmPwd: TFrmPwd;

implementation

{$R *.dfm}

uses
  Vcl.Clipbrd,
  DCPBase64, BaseCrypt;

procedure TFrmPwd.FormCreate(Sender: TObject);
begin
  EdtPassword.Clear;
  RdbAnsi.Checked := True;
  ChbClipboard.Checked := True;
end;

procedure TFrmPwd.EdtPasswordChange(Sender: TObject);
begin
  if EdtPassword.Modified then
  begin
    BtnChiffrer.Enabled := True;
    BtnDechiffrer.Enabled := True;
  end;
end;

procedure TFrmPwd.BtnChiffrerClick(Sender: TObject);
var
  Chiffre: String;
begin
  Chiffre := CryptString(EdtPassword.Text, 'algol1082');
  if RdbAnsi.Checked then
    EdtPassword.Text := Base64EncodeStr(AnsiString(Chiffre))
  else
    EdtPassword.Text := Base64EncodeStr(Chiffre);
  //
  if ChbClipboard.Enabled then
  begin
    EdtPassword.SelectAll;
    EdtPassword.CopyToClipboard;
    EdtPassword.SelStart := 0;
  end;
  //
  BtnChiffrer.Enabled := False;
  BtnDechiffrer.Enabled := True;
end;

procedure TFrmPwd.BtnDechiffrerClick(Sender: TObject);
var
  DeChiffre: String;
begin
  //
  if RdbAnsi.Checked then
    DeChiffre := Base64DecodeStr(AnsiString(EdtPassword.Text))
  else
    DeChiffre := Base64DecodeStr(EdtPassword.Text);
  //
  try
    //EdtPassword.Text := DecryptString(DeChiffre, 'algol1082');
    EdtPassword.Text := UTF8ToString(DecryptString(DeChiffre, 'algol1082'));
    //
    if ChbClipboard.Enabled then
    begin
      EdtPassword.SelectAll;
      EdtPassword.CopyToClipboard;
      EdtPassword.SelStart := 0;
    end;
    //
    BtnDechiffrer.Enabled := False;
    BtnChiffrer.Enabled := True;
  except
    on E:Exception do
    begin
      MessageDlg('Erreur lors du déchiffrement !'#13#10'Vérifiez la saisie ou les paramètres...', mtError, [mbOK], 0);
      EdtPassword.SetFocus;
    end;
  end;
end;

end.

