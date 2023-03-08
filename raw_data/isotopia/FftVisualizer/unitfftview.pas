unit unitFftView;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, TAGraph,
  TASeries;

type

  { TFormFftView }

  TFormFftView = class(TForm)
    ChartFFT: TChart;
    ChartFFTLineSeries1: TLineSeries;
    ChartFFTLineSeries2: TLineSeries;
    ChartFFTLineSeries3: TLineSeries;
    ChartPhase: TChart;
    ChartPhaseLineSeries1: TLineSeries;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
  chartFFTdata: array of array of double ; //  value stored as a double requires 64 bits;
  HZ_ref_sample : integer
  end;

var
  FormFftView: TFormFftView;

implementation

{$R *.lfm}

{ TFormFftView }

procedure TFormFftView.FormResize(Sender: TObject);
begin
  panel1.Height := formfftview.Height div 3;
end;

procedure TFormFftView.Timer1Timer(Sender: TObject);
var
i: Integer;
x: Double;
begin

  // versio test
   ChartFFTLineSeries1.Clear;
   ChartFFTLineSeries2.Clear;
   ChartFFTLineSeries3.Clear;

   ChartPhaseLineSeries1.Clear ;

      for i:=0 to HZ_ref_sample-1 do begin
        ChartFFTLineSeries1.AddXY(i, chartFFTdata[0,i]);
        ChartFFTLineSeries2.AddXY(i, chartFFTdata[1,i]);
        ChartFFTLineSeries3.AddXY(i, chartFFTdata[2,i]);
        ChartPhaseLineSeries1.AddXY(i,chartFFTdata[3,i] );
      end;
end;

procedure TFormFftView.FormCreate(Sender: TObject);
begin
  panel1.Height := formfftview.Height div 3;
   setLength( chartFFTdata , 8 , 2048 )  ;
   HZ_ref_sample := 1024;
end;

end.

