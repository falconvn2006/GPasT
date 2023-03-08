unit unitChart;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, TAGraph, TASeries;

type

  { TFormSin }

  TFormSin = class(TForm)
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    Chart1LineSeries4: TLineSeries;
    Chart1LineSeries5: TLineSeries;
    Chart1LineSeries6: TLineSeries;
    Chart1LineSeries7: TLineSeries;
    Chart1LineSeries8: TLineSeries;
    Timer1: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
  chartPen: array of array of double ; //  value stored as a double requires 64 bits;
  HZ_ref_sample : integer
  end;

var
  FormSin: TFormSin;

implementation

{$R *.lfm}

{ TFormSin }

procedure TFormSin.FormCreate(Sender: TObject);
var
i : integer;
begin
      setLength( chartPen , 8 , 1024 )  ;


          for i:=0 to 1024 -1 do begin
        Chart1LineSeries1.AddXY(i, chartPen[0,i]);
        Chart1LineSeries2.AddXY(i, chartPen[1,i]);
        Chart1LineSeries3.AddXY(i, chartPen[2,i]);
        Chart1LineSeries4.AddXY(i, chartPen[3,i]);
        Chart1LineSeries5.AddXY(i, chartPen[4,i]);
        Chart1LineSeries6.AddXY(i, chartPen[5,i]);
        Chart1LineSeries7.AddXY(i, chartPen[6,i]);
        Chart1LineSeries8.AddXY(i, chartPen[7,i]);
      end;






end;

procedure TFormSin.Panel1Click(Sender: TObject);
begin

end;

procedure TFormSin.Timer1Timer(Sender: TObject);
const
N = 1000;

var
i: Integer;
x: Double;
begin
    // svn test

 { Chart1LineSeries1.Clear;
  Chart1LineSeries2.Clear;
  Chart1LineSeries3.Clear;         // much faster to keep serie and not recreate avary time
  Chart1LineSeries4.Clear;
  Chart1LineSeries5.Clear;
  Chart1LineSeries6.Clear;
  Chart1LineSeries7.Clear;
  Chart1LineSeries8.Clear; }

 // Chart1LineSeries1.SetXValue();

      for i:=0 to HZ_ref_sample-1 do begin
        Chart1LineSeries1.SetyValue(i, chartPen[0,i]);
        Chart1LineSeries2.SetyValue(i, chartPen[1,i]);
        Chart1LineSeries3.SetyValue(i, chartPen[2,i]);
        Chart1LineSeries4.SetyValue(i, chartPen[3,i]);
        Chart1LineSeries5.SetyValue(i, chartPen[4,i]);
        Chart1LineSeries6.SetyValue(i, chartPen[5,i]);
        Chart1LineSeries7.SetyValue(i, chartPen[6,i]);
        Chart1LineSeries8.SetyValue(i, chartPen[7,i]);
      end;

       {   for i:=0 to HZ_ref_sample-1 do begin
        Chart1LineSeries1.AddXY(i, chartPen[0,i]);
        Chart1LineSeries2.AddXY(i, chartPen[1,i]);
        Chart1LineSeries3.AddXY(i, chartPen[2,i]);
        Chart1LineSeries4.AddXY(i, chartPen[3,i]);
        Chart1LineSeries5.AddXY(i, chartPen[4,i]);
        Chart1LineSeries6.AddXY(i, chartPen[5,i]);
        Chart1LineSeries7.AddXY(i, chartPen[6,i]);
        Chart1LineSeries8.AddXY(i, chartPen[7,i]);
      end;  }

end;





end.

