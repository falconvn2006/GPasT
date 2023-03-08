unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Calendar, FMX.Ani, FMX.Effects;

type
  TForm1 = class(TForm)
    Calendar1: TCalendar;
    Label1: TLabel;
    ColorAnimation1: TColorAnimation;
    GlowEffect1: TGlowEffect;
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
