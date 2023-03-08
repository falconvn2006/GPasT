unit testedecelular;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms3D, FMX.Types3D, FMX.Forms, FMX.Graphics, 
  FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TForm1 = class(TForm3D)
    Button1: TButton;
    CheckBox1: TCheckBox;
    ProgressBar1: TProgressBar;
    PathLabel1: TPathLabel;
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
{$R *.LgXhdpiPh.fmx ANDROID}

end.
