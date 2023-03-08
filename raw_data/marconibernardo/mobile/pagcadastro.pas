unit pagcadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Edit, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListBox, FMX.Ani;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Switch1: TSwitch;
    Label1: TLabel;
    Login: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Label2: TLabel;
    FloatAnimation1: TFloatAnimation;
    StyleBook1: TStyleBook;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

end.
