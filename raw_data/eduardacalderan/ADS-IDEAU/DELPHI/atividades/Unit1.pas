unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Exerccios1: TMenuItem;
    Exerccio21: TMenuItem;
    Exerccio41: TMenuItem;
    Exerccio52: TMenuItem;
    Exerccio61: TMenuItem;
    Exerccio101: TMenuItem;
    Exerccio111: TMenuItem;
    Exerccio121: TMenuItem;
    Exerccio131: TMenuItem;
    Exerccio161: TMenuItem;
    procedure Exerccio101Click(Sender: TObject);
    procedure Exerccio111Click(Sender: TObject);
    procedure Exerccio121Click(Sender: TObject);
    procedure Exerccio131Click(Sender: TObject);
    procedure Exerccio161Click(Sender: TObject);
    procedure Exerccio141Click(Sender: TObject);
    procedure Exerccio61Click(Sender: TObject);
    procedure Exerccio52Click(Sender: TObject);
    procedure Exerccio41Click(Sender: TObject);
    procedure Exerccio21Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit12, Unit10, Unit11, Unit3, Unit4, Unit5, Unit6, Unit7, Unit8, Unit9;



procedure TForm1.Exerccio101Click(Sender: TObject);
begin
   FormPN := TFormPN.create(self);

  try
    FormPN.showModal;
  finally
    FreeAndNil(FormPN)
  end;
end;

procedure TForm1.Exerccio111Click(Sender: TObject);
begin
    FormMaior := TFormMaior.create(self);

  try
    FormMaior.showModal;
  finally
    FreeAndNil(FormMaior)
  end;
end;

procedure TForm1.Exerccio121Click(Sender: TObject);
begin
     FormSenha := TFormSenha.create(self);

  try
    FormSenha.showModal;
  finally
    FreeAndNil(FormSenha)
  end;
end;

procedure TForm1.Exerccio131Click(Sender: TObject);
begin
       FormParOrIm := TFormParOrIm.create(self);

  try
    FormParOrIm.showModal;
  finally
    FreeAndNil(FormParOrIm)
  end;
end;



procedure TForm1.Exerccio141Click(Sender: TObject);
begin
    FormMaiorTres := TFormMaiorTres.create(self);

  try
    FormMaiorTres.showModal;
  finally
    FreeAndNil(FormMaiorTres)
  end;
end;

procedure TForm1.Exerccio161Click(Sender: TObject);
begin
    FormMaioresTres := TFormMaioresTres.create(self);

  try
    FormMaioresTres.showModal;
  finally
    FreeAndNil(FormMaioresTres)
  end;
end;

procedure TForm1.Exerccio21Click(Sender: TObject);
begin
  FormDenNum := TFormDenNum.create(self);

  try
    FormDenNum.showModal;
  finally
    FreeAndNil(FormDenNum)
  end;
end;

procedure TForm1.Exerccio41Click(Sender: TObject);
begin
  FormSalario := TFormSalario.create(self);

  try
    FormSalario.showModal;
  finally
    FreeAndNil(FormSalario)
  end;
end;

procedure TForm1.Exerccio52Click(Sender: TObject);
begin
  FormTemperatura := TFormTemperatura.create(self);

  try
    FormTemperatura.showModal;
  finally
    FreeAndNil(FormTemperatura)
  end;
end;

procedure TForm1.Exerccio61Click(Sender: TObject);
begin
   FormTemperaturaF := TFormTemperaturaF.create(self);

  try
    FormTemperaturaF.showModal;
  finally
    FreeAndNil(FormTemperaturaF)
  end;
end;

end.
