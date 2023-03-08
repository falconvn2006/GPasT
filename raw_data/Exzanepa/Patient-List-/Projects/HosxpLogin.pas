unit HosxpLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg;

type
  THosxpLogins = class(TForm)
    Image1: TImage;
    username: TEdit;
    Login: TButton;
    password: TEdit;
    Cancel: TButton;
    procedure LoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NewString : integer;

  end;

var
  HosxpLogins: THosxpLogins;
  sName, sPass, sPassl :string;

implementation

{$R *.dfm}

procedure THosxpLogins.LoginClick(Sender: TObject);
begin
  sPass := password.Text;
  sPassl := 'admin';
  if username.Text = '' then
  begin
    ShowMessage('Please enter valid name.');
  end;
  if Password.Text ='' then
  begin
    ShowMessage('Please enter valid password.')
  end;
  if sPass = sPassl then
  begin
    NewString := 1;
    close;
  end
  else
  begin
    Showmessage('Incorrect password.');
  end;


end;

end.
