unit Unit10;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TForm10 = class(TForm)
    Config: TImage;
    TextPassword: TEdit;
    TextUser: TEdit;
    Image1: TImage;
    Label5: TLabel;
    Label1: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure LockForm(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TextUserKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

uses Unit1;

procedure TForm10.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    //Form10.Image2Click(Sender: TObject);
  end;
end;

procedure TForm10.FormShow(Sender: TObject);
begin
	Form10.SetFocus;
  TextUser.SetFocus;
end;

procedure TForm10.Image2Click(Sender: TObject);
begin
if (TextUser.Text = 'root') and (TextPassword.Text = '')  then
begin
    //showmessage ('Contraseña Correcta');
    Form1.Enabled := True;
    Form10.Close;
end
else
begin
  showmessage ('Contraseña Incorrecta');
end;
end;

procedure TForm10.Image3Click(Sender: TObject);
begin
  Form1.Close;
  Form10.Close;
end;

procedure TForm10.LockForm(Sender: TObject);
begin
  //so it doesnt get delete
  Form1.Enabled := False;
end;

procedure TForm10.TextUserKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Image2Click(nil);
  end;
end;


{$R *.dfm}

end.
