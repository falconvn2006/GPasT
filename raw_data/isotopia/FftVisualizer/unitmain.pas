unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Spin, TAGraph, unitChart,unitFftView,unitIFftView1, math;

type

  { TFormMain }

  TFormMain = class(TForm)
    Amplitude: TLabel;
    Amplitude1: TLabel;
    Button1: TButton;
    ButtonFftMemo: TButton;
    Button_I_FftMemo: TButton;
    ButtonShowSin1: TButton;
    ButtonSinMemo: TButton;
    ButtonShowSin: TButton;
    Button_I_FftMemo1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBoxIfftI: TCheckBox;
    CheckBoxIfftR: TCheckBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    LabelFftTime: TLabel;
    LabelFftLowPass: TLabel;
    LabelFftHighPass: TLabel;
    Label_I_FftTime: TLabel;
    Labelphase: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Labelf1: TLabel;
    Labelf2: TLabel;
    Labelf3: TLabel;
    Labelf4: TLabel;
    Labelf5: TLabel;
    Labelf6: TLabel;
    Labelf7: TLabel;
    LabelSample: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SpinEdita1: TSpinEdit;
    SpinEdita2: TSpinEdit;
    SpinEdita3: TSpinEdit;
    SpinEdita4: TSpinEdit;
    SpinEdita5: TSpinEdit;
    SpinEdita6: TSpinEdit;
    SpinEdita7: TSpinEdit;
    SpinEdita8: TSpinEdit;
    SpinEditFFTI: TSpinEdit;
    SpinEditFFTs: TSpinEdit;
    SpinEditFFTr: TSpinEdit;
    SpinEditO1: TSpinEdit;
    SpinEdito2: TSpinEdit;
    SpinEdito3: TSpinEdit;
    SpinEdito4: TSpinEdit;
    SpinEdito5: TSpinEdit;
    SpinEdito6: TSpinEdit;
    SpinEdito7: TSpinEdit;
    SpinEditp1: TSpinEdit;
    SpinEditp2AT: TSpinEdit;
    SpinEditp3AT: TSpinEdit;
    SpinEditp4AT: TSpinEdit;
    SpinEditp5AT: TSpinEdit;
    SpinEditp6AT: TSpinEdit;
    SpinEditp7AT: TSpinEdit;
    SpinEditp2: TSpinEdit;
    SpinEditp3: TSpinEdit;
    SpinEditp4: TSpinEdit;
    SpinEditp5: TSpinEdit;
    SpinEditp6: TSpinEdit;
    SpinEditp7: TSpinEdit;
    SpinEditp1AT: TSpinEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Timer1: TTimer;
    TrackBarHighPass: TTrackBar;
    TrackBarLowPass: TTrackBar;
    TrackBarThreshold: TTrackBar;
    TrackBarf1: TTrackBar;
    TrackBarf2: TTrackBar;
    TrackBarf3: TTrackBar;
    TrackBarf4: TTrackBar;
    TrackBarf5: TTrackBar;
    TrackBarf6: TTrackBar;
    TrackBarf7: TTrackBar;
    TrackBarsample: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button_I_FftMemo1Click(Sender: TObject);
    procedure Button_I_FftMemoClick(Sender: TObject);
    procedure ButtonFftMemoClick(Sender: TObject);
    procedure ButtonShowSinClick(Sender: TObject);
    procedure ButtonSinMemoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBarThresholdChange(Sender: TObject);

  private

  public
  RawDataI: array of array of double ; //  value stored as a double requires 64 bits;
  RawDataQ: array of array of double ; //  value stored as a double requires 64 bits;
  FFTthreshold : double
  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }
 
//Type SArray = Array of String;
//Type RArray = Array of Real;


//--------------------------------------------------
//-- COMPLEX NUMBERS HANDLING ----------------------
type Complex = Array [0..1] of Real;
type CArray = Array of Complex;

var
fftInput,FFtoutput, IfftOutput:CArray ;

function RandomBetween(a, b: Double): Double;
begin
  Result := a + Random * (b - a);
end;

function PointPrincipalAngleDeg(P1x,P1y,Treshold: Real) : real;    // -180 TO 180DEG
var Ang : real;
begin
         if abs(P1x) < Treshold then P1x :=0;
         if abs(P1y) < Treshold then P1y :=0;
          Ang :=( arctan2 (P1y,P1x)) /pi * 180   ;

	result:= Ang;

end;



function Vector3DangleDeg(V1x,V1y,V1z,V2x,V2y,V2z: Double) : real;
var prod , vw ,Lv1,Lv2 : real;
begin
       vw := (V1x * V2x) + (V1y * V2y) + (V1z * V2z)  ;
       Lv1 := sqrt(sqr(v1x)+sqr(v1y)+sqr(v1z));    //  length of vector 1
       Lv2 := sqrt(sqr(v2x)+sqr(v2y)+sqr(v2z));    //  length of vector 2
          //***********-----  verifier , pas confirmer si fonctionne cf

          result:= ( arccos (vw / (Lv1*Lv2))) /pi * 180   ;

end;



 
//-------------from https://github.com/merlinND/pascal-fast-fourier-transform/blob/master/pascal-fft.pas-------
//-- -----------jan 23-2023----------------   Avatar  Merlin Nimier-David   --------------------------------

function multiply(c1, c2 : Complex) : Complex;
var prod : Complex;
begin
	prod[0] := c1[0] * c2[0] - c1[1] * c2[1];
	prod[1] := c1[0] * c2[1] + c1[1] * c2[0];
	multiply:= prod;
end;
function add(c1,c2 : Complex):Complex;
var sum : Complex;
begin
	sum[0] := c1[0] + c2[0];
	sum[1] := c1[1] + c2[1];
	add := sum;
end;
function substract(c1,c2 : Complex):Complex;
var sum : Complex;
begin
	sum[0] := c1[0] - c2[0];
	sum[1] := c1[1] - c2[1];
	substract := sum;
end;
function conjugate(c1 : Complex):Complex;
var conj : Complex;
begin
	conj[0] := c1[0];                 // not used cf
	conj[1] := - c1[1];
	conjugate := conj;
end;
function conjugateArray(c1 : CArray):CArray;
var conjArray : CArray;
	i, n : Integer;
begin
	n := length(c1);
	SetLength(conjArray, n);

	for i:=0 to n - 1 do
	begin
		conjArray[i][0] := c1[i][0];
		conjArray[i][1] := - c1[i][1];
	end;


	conjugateArray := conjArray;
end;

//--------------------------------------------------
//-- DATA DIMENSION DETECTION ----------------------
// Read the value of a bit from any variable
function getBit(const Val: DWord; const BitVal: Byte): Boolean;
begin
	getBit := (Val and (1 shl BitVal)) <> 0;
end;
// Set the value of a bit in any variable
function enableBit(const Val: DWord; const BitVal: Byte; const SetOn: Boolean): DWord;
begin
	enableBit := (Val or (1 shl BitVal)) xor (Integer(not SetOn) shl BitVal);
end;

//--------------------------------------------------
//-- MIRROR PERMUTATION ----------------------------
function mirrorTransform(n,m:Integer):Integer;
var i,p : Integer;
begin
	p := 0;

	for i:=0 to m-1 do
	begin
		p := enableBit(p, m-1-i, getBit(n, i));
	end;

	mirrorTransform:=p;
end;

function doPermutation(source:CArray; m:Integer):CArray;
var i, n : Integer;
 resultx : CArray;  // cf ????
begin
	n := length(source);
	SetLength(resultx, n);

	for i:=0 to n-1 do
	begin
		resultx[i] := source[mirrorTransform(i, m)];
	end;

	doPermutation := resultx;
end;

//--------------------------------------------------
//-- FFT COMPUTATION STEP --------------------------
function doStep(k, M : Longint; prev:CArray):CArray;
var expTerm, substractTerm : Complex;
	dimension, q, j, offset : Longint;
	u : CArray;
begin
	// INITIALIzATION
	//offset = 2^(M-k)
	offset := system.round(intpower(2, M-k));

	SetLength(u, length(prev));

	// COMPUTE EACH COORDINATE OF u_k
	for q:=0 to system.round(intpower(2, k-1) - 1) do
	begin // For each block of the matrix

		for j:=0 to (offset - 1) do
		begin // Fo each line of this block

			// First half
			u[q*2*offset + j] := add( prev[q*2*offset + j], prev[q*2*offset + j + offset] );

			// Second half
			expTerm[0] := cos( (j * PI) / offset );
			expTerm[1] := sin( (j * PI) / offset );
			substractTerm := substract( prev[q*2*offset + j], prev[q*2*offset + j + offset] );
			u[q*2*offset + j + offset] := multiply(expTerm, substractTerm);
		end;

	end;

	// Output result
	doStep := u;
end;

// DISCRETE FOURIER TRANSFORM USING COOLEY-TUKEY'S FFT ALGORITHM
function fft(g:CArray; order:Integer):CArray;
var previousRank, nextRank : CArray;
	i : Integer;
begin

	previousRank := g;
	for i:=1 to order do
	begin
               ///////// ShowMessage('This loop' + inttostr(i) );/
		nextRank := doStep(i, order, previousRank);
		previousRank := nextRank;
	end;

	// Mirror transform
	nextRank := doPermutation(nextRank, order);

	fft := nextRank;
end;
// INVERSE FOURIER TRANSFORM
function ifft(G:CArray; order:Integer):CArray;
var resultx : CArray;  // cf ???
	i, n : Longint;
begin
	n := length(G);
	SetLength(resultx, n);

	//La transformée inverse est le conjugué de la transformée du conjugué
	resultx := fft(conjugateArray(G), order);
	resultx := conjugateArray(resultx);
	//...ajustée par un facteur 1/n
	for i := 0 to n - 1 do
	begin
		resultx[i][0] := resultx[i][0] / n;
		resultx[i][1] := resultx[i][1] / n;
	end;

	ifft := resultx;
end;
//--------------------------------------------------





procedure TFormMain.Timer1Timer(Sender: TObject);
const
N = 1024; ///sample per ref 1 hz

var
i: Integer;
fftInputComplex,fftOutputComplex, IfftOutputComplex:Complex;
start: QWord;  // time calculation
//x: double;
begin
start := getTickCount64;
      // svn test     /*/ plus exe
Labelf1.Caption := inttostr( TrackBarf1.Position );
Labelf2.Caption := inttostr( TrackBarf2.Position );
Labelf3.Caption := inttostr( TrackBarf3.Position );
Labelf4.Caption := inttostr( TrackBarf4.Position );
Labelf5.Caption := inttostr( TrackBarf5.Position );
Labelf6.Caption := inttostr( TrackBarf6.Position );
Labelf7.Caption := inttostr( TrackBarf7.Position );
LabelSample.Caption := inttostr( TrackBarsample.Position );

formSin.HZ_ref_sample := TrackBarsample.Position   ;

   for i:=0 to formSin.HZ_ref_sample -1 do begin     // --- build data for FFT
   // x := MIN + (MAX - MIN) * i /(N - 1);



        RawDataQ[0,i] := ((((SpinEditp1AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf1.Position+(SpinEditp1.Value/180*pi))*(0.01*SpinEdita1.Value))+SpinEditO1.Value  ;
        RawDataI[0,i] := ((((SpinEditp1AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf1.Position+((SpinEditp1.Value + 90) /180*pi))*(0.01*SpinEdita1.Value))+SpinEditO1.Value  ;

        RawDataQ[1,i] := ((((SpinEditp2AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf2.Position+(SpinEditp2.Value/180*pi))*(0.01*SpinEdita2.Value))+SpinEditO2.Value  ;
        RawDatai[1,i] := ((((SpinEditp2AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf2.Position+((SpinEditp2.Value + 90) /180*pi))*(0.01*SpinEdita2.Value))+SpinEditO2.Value  ;

        RawDataQ[2,i] := ((((SpinEditp3AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf3.Position+(SpinEditp3.Value/180*pi))*(0.01*SpinEdita3.Value))+SpinEditO3.Value  ;
        RawDataI[2,i] := ((((SpinEditp3AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf3.Position+((SpinEditp3.Value + 90) /180*pi))*(0.01*SpinEdita3.Value))+SpinEditO3.Value  ;


        RawDataQ[3,i] := ((((SpinEditp4AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf4.Position+(SpinEditp4.Value/180*pi))*(0.01*SpinEdita4.Value))+SpinEditO4.Value  ;
        RawDataI[3,i] := ((((SpinEditp4AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf4.Position+((SpinEditp4.Value + 90) /180*pi))*(0.01*SpinEdita4.Value))+SpinEditO4.Value  ;

        RawDataQ[4,i] := ((((SpinEditp5AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf5.Position+(SpinEditp5.Value/180*pi))*(0.01*SpinEdita5.Value))+SpinEditO5.Value  ;
        RawDataI[4,i] := ((((SpinEditp5AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf5.Position+((SpinEditp5.Value + 90) /180*pi))*(0.01*SpinEdita5.Value))+SpinEditO5.Value  ;


        RawDataQ[5,i] := ((((SpinEditp6AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf6.Position+(SpinEditp6.Value/180*pi))*(0.01*SpinEdita6.Value))+SpinEditO6.Value  ;
        RawDataI[5,i] := ((((SpinEditp6AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf6.Position+((SpinEditp6.Value + 90) /180*pi))*(0.01*SpinEdita6.Value))+SpinEditO6.Value  ;


        RawDataQ[6,i] := ((((SpinEditp7AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf7.Position+(SpinEditp7.Value/180*pi))*(0.01*SpinEdita7.Value))+SpinEditO7.Value  ;
        RawDataI[6,i] := ((((SpinEditp7AT.Value -100) /100000)*i) +1 ) * (sin( i*2*pi/N*TrackBarf7.Position+((SpinEditp7.Value + 90) /180*pi))*(0.01*SpinEdita7.Value))+SpinEditO7.Value  ;

        RawDataQ[7,i] := (0.01*SpinEdita8.Value) * (RawDataQ[0,i] + RawDataQ[1,i] + RawDataQ[2,i] + RawDataQ[3,i]
                                                  + RawDataQ[4,i] + RawDataQ[5,i] + RawDataQ[6,i]                );

        RawDataI[7,i] := (0.01*SpinEdita8.Value) * (RawDataI[0,i] + RawDataI[1,i] + RawDataI[2,i] + RawDataI[3,i]
                                                  + RawDataI[4,i] + RawDataI[5,i] + RawDataI[6,i]                );

        if CheckBox1.Checked then formSin.chartPen[0,i] :=  RawDataI[0,i];
        if not CheckBox1.Checked then formSin.chartPen[0,i] :=  RawDataQ[0,i];

        if CheckBox2.Checked then formSin.chartPen[1,i] :=  RawDataI[1,i];
        if not CheckBox2.Checked then formSin.chartPen[1,i] :=  RawDataQ[1,i];

        if CheckBox3.Checked then formSin.chartPen[2,i] :=  RawDataI[2,i];
        if not CheckBox3.Checked then formSin.chartPen[2,i] :=  RawDataQ[2,i];

        if CheckBox4.Checked then formSin.chartPen[3,i] :=  RawDataI[3,i];
        if not CheckBox4.Checked then formSin.chartPen[3,i] :=  RawDataQ[3,i];

        if CheckBox5.Checked then formSin.chartPen[4,i] :=  RawDataI[4,i];
        if not CheckBox5.Checked then formSin.chartPen[4,i] :=  RawDataQ[4,i];

        if CheckBox6.Checked then formSin.chartPen[5,i] :=  RawDataI[5,i];
        if not CheckBox6.Checked then formSin.chartPen[5,i] :=  RawDataQ[5,i];

        if CheckBox7.Checked then formSin.chartPen[6,i] :=  RawDataI[6,i];
        if not CheckBox7.Checked then formSin.chartPen[6,i] :=  RawDataQ[6,i];

        if CheckBox8.Checked then formSin.chartPen[7,i] :=  RawDataI[7,i];
        if not CheckBox8.Checked then formSin.chartPen[7,i] :=  RawDataQ[7,i];

        fftInputComplex[0] := RawDataQ[7,i]  ;
        fftInputComplex[1] := RawDataI[7,i] ;
        fftInput[i] := fftInputComplex ;
   end;

start := getTickCount64;

   fftoutput := fft(fftInput, 10);   // Do FFT ---  10 for 1024 value , 11 for 2048 , multiple to 2^n
//sleep(10);
LabelFftTime.Caption := ('FFT time ' + IntToStr(GetTickCount64-start)+' ms');



   LabelFftHighPass.Caption:= 'High pass Filter value : ' + inttostr(TrackBarHighPass.Position);
   LabelFftLowPass.Caption:= 'Low Pass Filter value : ' + inttostr(TrackBarLowPass.Position);

   for i:=0 to formSin.HZ_ref_sample -1 do begin    // --- show Frequency domain data FFT

        fftoutputComplex := fftoutput[i];

        if TrackBarHighPass.Position > i then begin    // Low pass filter on FFT
           fftoutputComplex[0] := 0 ;
           fftoutputComplex[1] := 0 ;
           end;

        if TrackBarLowPass.Position < i then begin   // High pas filter on FFT
           fftoutputComplex[0] := 0 ;
           fftoutputComplex[1] := 0 ;
           end;
         fftoutput[i] :=  fftoutputComplex   ;

        FormFftView.chartFFTdata[0,i] := SpinEditFFTr.Value + fftoutputComplex[0] /1024 ;    // move fft  up/dn in fftview
        FormFftView.chartFFTdata[1,i] := SpinEditFFTi.Value + fftoutputComplex[1] /1024 ;    // move fft  up/dn in fftview

        FormFftView.chartFFTdata[2,i] := SpinEditFFTs.Value  + sqrt(sqr(fftoutputComplex[0]) + sqr( fftoutputComplex[1] )) /1024 ;
        FormFftView.chartFFTdata[3,i] := PointPrincipalAngleDeg(fftoutputComplex[0]/1024, fftoutputComplex[1]/1024, FFTthreshold  );





   end;
LabelFftTime.Caption := ('FFT time ' + IntToStr(GetTickCount64-start)+' ms');
start := getTickCount64;

IfftOutput := ifft(fftoutput, 10);  // Do Invers FFT --  10 for 1024 value , 11 for 2048 , multiple to 2^n
//Sleep(10);
Label_I_FftTime.Caption := ('Inverse FFT time ' + IntToStr(GetTickCount64-start)+' ms');

   for i:=0 to formSin.HZ_ref_sample -1 do begin     // ---Show IFFT data

        IfftoutputComplex := Ifftoutput[i];
      //Form_IFftView.chart_I_FFTdata[0,i] :=  IfftoutputComplex[0]    ;
      //Form_IFftView.chart_I_FFTdata[1,i] :=  IfftoutputComplex[1]  ;

        if CheckBoxIfftR.Checked then Form_IFftView.chart_I_FFTdata[0,i] :=  IfftoutputComplex[0]    ;
        if not CheckBoxIfftR.Checked then Form_IFftView.chart_I_FFTdata[0,i] :=  0;

        if CheckBoxIffti.Checked then  Form_IFftView.chart_I_FFTdata[1,i] :=  IfftoutputComplex[1]    ;
        if not CheckBoxIffti.Checked then Form_IFftView.chart_I_FFTdata[1,i] :=  0;


   end;
// memo1.Lines.Add('IFFT time ' + IntToStr(GetTickCount64-start)+' ms');











//For the square root use sqrt();, for any n use power() from unit Math, e.g.
//Code: Pascal  [Select]
///    power(64, 1/3);//

end;

procedure TFormMain.TrackBarThresholdChange(Sender: TObject);
begin
  Labelphase.Caption:= floattostr( TrackBarThreshold.Position /1000)  ;
  FFTthreshold :=  TrackBarThreshold.Position /1000
end;


procedure TFormMain.FormCreate(Sender: TObject);
begin
   setLength( RawDataQ , 8 , 2048 )  ;
   setLength( RawDataI , 8 , 2048 )  ;
   setLength( fftInput , 1024 )  ;
   setLength( fftOutput , 1024 )  ;
   self.TrackBarThresholdChange(nil) ;

end;

procedure TFormMain.Panel3Click(Sender: TObject);
begin

end;




procedure TFormMain.ButtonShowSinClick(Sender: TObject);
begin
  Form_IFftView.Show;
end;

procedure TFormMain.Button_I_FftMemoClick(Sender: TObject);
  var
i: Integer;
begin
 formSin.HZ_ref_sample := TrackBarsample.Position   ;
  memo1.Lines.Clear;

 for i:=0 to 1024 -1 do begin
       memo1.Lines.Add( '  IFFT_I  ,'+ floattostr(Form_iFftView.chart_I_FFTdata[0,i]) +
                        ', Ifft_Q  ,'+ floattostr(Form_iFftView.chart_I_FFTdata[1,i])  );
   end;
end;


procedure TFormMain.ButtonFftMemoClick(Sender: TObject);
var
i: Integer;
begin
 formSin.HZ_ref_sample := TrackBarsample.Position   ;
  memo1.Lines.Clear;

 for i:=0 to formSin.HZ_ref_sample -1 do begin
       memo1.Lines.Add( '  fftQ  ,'+ floattostr(FormFftView.chartFFTdata[0,i]) +
                        ', fftI  ,'+ floattostr(FormFftView.chartFFTdata[1,i]) +
                        ', fftA  ,'+ floattostr(FormFftView.chartFFTdata[2,i]) +
                        ', phase ,'+ floattostr(FormFftView.chartFFTdata[3,i])  );
   end;
end;

procedure TFormMain.ButtonSinMemoClick(Sender: TObject);
var
i: Integer;
begin
 formSin.HZ_ref_sample := TrackBarsample.Position   ;
 memo1.Lines.Clear;

 for i:=0 to formSin.HZ_ref_sample -1 do begin
    memo1.Lines.Add(',pen1 Data Q ,'+ floattostr(RawDataQ[0,i]) +
                    ',pen1 Data I ,'+ floattostr(RawDataI[0,i]) +
                    ',pen2 Data Q ,'+ floattostr(RawDataQ[1,i]) +
                    ',pen2 Data I ,'+ floattostr(RawDataI[1,i]) +
                    ',pen3 Data Q ,'+ floattostr(RawDataQ[2,i]) +
                    ',pen3 Data I ,'+ floattostr(RawDataI[2,i]) +
                    ',pen4 Data Q ,'+ floattostr(RawDataQ[3,i]) +
                    ',pen4 Data I ,'+ floattostr(RawDataI[3,i]) +
                    ',pen5 Data Q ,'+ floattostr(RawDataQ[4,i]) +
                    ',pen5 Data I ,'+ floattostr(RawDataI[4,i]) +
                    ',pen6 Data Q ,'+ floattostr(RawDataQ[5,i]) +
                    ',pen6 Data I ,'+ floattostr(RawDataI[5,i]) +
                    ',pen7 Data Q ,'+ floattostr(RawDataQ[6,i]) +
                    ',pen7 Data I ,'+ floattostr(RawDataI[6,i]) +
                    ',pen9 Data Q ,'+ floattostr(RawDataQ[7,i]) +
                    ',pen8 Data I ,'+ floattostr(RawDataI[7,i])  );

    end;

end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  FormFftView.Show;
end;

procedure TFormMain.Button_I_FftMemo1Click(Sender: TObject);
begin
  memo1.Clear;
end;




end.


{
procedure TFormMain.StoreFormState;         /// xml save form status
begin
  with XMLConfig1 do begin
    SetValue('NormalLeft', Left);
    SetValue('NormalTop', Top);
    SetValue('NormalWidth', Width);
    SetValue('NormalHeight', Height);

    SetValue('RestoredLeft', RestoredLeft);
    SetValue('RestoredTop', RestoredTop);
    SetValue('RestoredWidth', RestoredWidth);
    SetValue('RestoredHeight', RestoredHeight);

    SetValue('WindowState', Integer(WindowState));
  end;

}
