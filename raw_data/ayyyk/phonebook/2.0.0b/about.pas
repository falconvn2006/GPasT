unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, jpeg, ShellAPI;

type
  TAboutForm = class(TForm)
    Image: TImage;
    Panel2: TPanel;
    Label5: TLabel;
    Panel3: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    OK: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Label4MouseEnter(Sender: TObject);
    procedure Label4MouseLeave(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','mailto:AyyyK@yandex.ru', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.Label4MouseEnter(Sender: TObject);
begin
  Label4.Font.Style:=[fsUnderline];
end;

procedure TAboutForm.Label4MouseLeave(Sender: TObject);
begin
  label4.Font.Style:=[];
end;

procedure TAboutForm.Label4Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','mailto:AyyyK@yandex.ru', nil, nil, SW_SHOWNORMAL);
end;

end.
