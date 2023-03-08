unit unitIFftView1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, TAGraph,
  TASeries;

type

  { TForm_IFftView }

  TForm_IFftView = class(TForm)
    Chart1_I_FFT: TChart;
    Chart1_I_FFTLineSeries1Ifft_Q: TLineSeries;
    Chart1_I_FFTLineSeries1Ifft_I: TLineSeries;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
  chart_I_FFTdata: array of array of double ; //  value stored as a double requires 64 bits;
  end;

var
  Form_IFftView: TForm_IFftView;

implementation

{$R *.lfm}

{ TForm_IFftView }

procedure TForm_IFftView.Timer1Timer(Sender: TObject);
var
i: Integer;
x: Double;
begin
   Chart1_I_FFTLineSeries1Ifft_I.Clear;
   Chart1_I_FFTLineSeries1Ifft_Q.Clear;


      for i:=0 to 1024 -1 do begin
         Chart1_I_FFTLineSeries1Ifft_I.AddXY(i, chart_I_FFTdata[0,i]);
         Chart1_I_FFTLineSeries1Ifft_Q.AddXY(i, chart_I_FFTdata[1,i] );

       // version test
      end;
end;

procedure TForm_IFftView.FormCreate(Sender: TObject);
begin
    setLength( chart_I_FFTdata , 8 , 2048 )  ;
end;

end.

