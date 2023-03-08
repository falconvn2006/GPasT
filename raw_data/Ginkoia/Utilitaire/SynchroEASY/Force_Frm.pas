unit Force_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, dxGDIPlusClasses,
  Vcl.ExtCtrls;

type
  TFormFORCE = class(TForm)
    Panel3: TPanel;
    Image2: TImage;
    Label9: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FChoix :integer;
    FNbLignes : integer;
    procedure MotDePasse();
    procedure SetNbLignes(aValue:integer);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property NBLignes:integer read FNbLignes write SetNbLignes;
    property Choix:integer    read FChoix;
  end;

var
  FormFORCE: TFormFORCE;

implementation

{$R *.dfm}

Uses uPasswordManager;

procedure TFormFORCE.SetNbLignes(aValue:integer);
begin
  FNbLignes := aValue;
  Label1.Caption := Format('Vous avez %d données qui n''ont pas été envoyées. Si vous forcer la synchronisation, elles seront perdues',[aValue]);
  Label1.Visible:=true;
end;


procedure TFormFORCE.Button1Click(Sender: TObject);
begin
    FChoix := 1;
    Close;
end;

procedure TFormFORCE.Button2Click(Sender: TObject);
begin
    MotDePasse;
end;

procedure TFormFORCE.Button3Click(Sender: TObject);
begin
    FChoix :=3;
    Close;
end;

procedure TFormFORCE.MotDePasse();
var passCorrect: Boolean;
    password: string;
    test: AnsiString;
    retourPassword: TPasswordValidation;
begin
  passCorrect := true;
  password := InputBox('Service Easy', #31'Mot de passe : ', '');

  PasswordManager.PasswordName := 'GestionServices';

  retourPassword := PasswordManager.ComparePassword(password);

  // si le fichier de mot de passe, ou la clé du mot de passe n'existe pas, on prend chamonix par défaut
  if (retourPassword = fileNotExist) or (retourPassword = PasswordNotExist) then
  begin
    if password <> 'ch@mon1x' then
      passCorrect := false;
  end
  else if retourPassword <> PassOk then
    passCorrect := false;

  if passCorrect then
  begin
     FChoix := 2;
     Close;
  end;
end;

procedure TFormFORCE.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   // Action := CaFree;
end;

procedure TFormFORCE.FormCreate(Sender: TObject);
begin
    FChoix := 0;
end;

end.
