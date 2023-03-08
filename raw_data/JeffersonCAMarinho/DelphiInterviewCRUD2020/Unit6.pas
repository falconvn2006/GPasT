unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm6 = class(TForm)
    Label1: TLabel;
    StaticText1: TStaticText;
    btnclientes: TBitBtn;
    BitBtn2: TBitBtn;
    btnestoque: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    procedure btnclientesClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnestoqueClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

uses Unit1, Unit3, Unit4, Unit5, projeto;

procedure TForm6.BitBtn2Click(Sender: TObject);
begin
  Form3.showModal;
end;

procedure TForm6.BitBtn4Click(Sender: TObject);
begin
  Form4.showModal;
end;

procedure TForm6.BitBtn5Click(Sender: TObject);
begin
if MessageDlg('Sair do sistema?',mtConfirmation, [mbYes,mbNo],0) = mrYes then
CLOSE;
end;

procedure TForm6.btnclientesClick(Sender: TObject);
begin
  Form1.ShowModal;

end;

procedure TForm6.btnestoqueClick(Sender: TObject);
begin
  Form5.showModal;
end;

end.
