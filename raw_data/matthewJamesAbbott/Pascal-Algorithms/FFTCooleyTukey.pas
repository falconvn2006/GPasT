unit FFTCooleyTukey;

interface

type
   TComplex = record
      Real: Double;
      Imag: Double;
   end;

   TFFTCooleyTukey = object
   private
      FSize: Integer;
      FBitRev: array of Integer;
      FExpTable: array of TComplex;
      procedure BitReverse(var Data: array of TComplex);
      procedure FFT(var Data: array of TComplex; Inverse: Boolean);
   public
      function Add(const A, B: TComplex): TComplex; inline; static;
      function Subtract(const A, B: TComplex): TComplex; inline; static;
      function Multiply(const A, B: TComplex): TComplex; inline; static;
      constructor Create(Size: Integer);
      procedure Transform(var Data: array of TComplex);
      procedure InverseTransform(var Data: array of TComplex);
   end;


implementation

uses
  Math;

constructor TFFTCooleyTukey.Create(Size: Integer);
var
   I, J: Integer;
   Theta, Cosine, Sine: Double;
begin
   FSize := Size;
   SetLength(FBitRev, FSize);
   SetLength(FExpTable, FSize);

   // Initialize bit reversal table
   for I := 0 to FSize - 1 do
   begin
      J := 0;
      Theta := 0;
      while (1 shl J) < FSize do
      begin
         Theta := Theta + ((I shr J) and 1) * (Pi / (1 shl J));
         Inc(J);
      end;
      FBitRev[I] := (I and $1) shl (J - 1);
      for J := 1 to J - 1 do
      begin
         FBitRev[I] := FBitRev[I] or ((I shr J) and $1) shl (J - 1);
      end;
   end;

   // Initialize twiddle factor table
   for I := 0 to FSize - 1 do
   begin
      Theta := -2 * Pi * I / FSize;
      Cosine := Cos(Theta);
      Sine := Sin(Theta);
      FExpTable[I].Real := Cosine;
      FExpTable[I].Imag := Sine;
   end;
end;

function TFFTCooleyTukey.Add(const A, B: TComplex): TComplex; inline;
begin
   Add.Real := A.Real + B.Real;
   Add.Imag := A.Imag + B.Imag;
end;

function TFFTCooleyTukey.Subtract(const A, B: TComplex): TComplex; inline;
begin
   Subtract.Real := A.Real - B.Real;
   Subtract.Imag := A.Imag - B.Imag;
end;

function TFFTCooleyTukey.Multiply(const A, B: TComplex): TComplex; inline;
begin
   Multiply.Real := A.Real * B.Real - A.Imag * B.Imag;
   Multiply.Imag := A.Real * B.Imag + A.Imag * B.Real;
end;


procedure TFFTCooleyTukey.BitReverse(var Data: array of TComplex);
var
   I, J: Integer;
   Temp: TComplex;
begin
   for I := 0 to FSize - 1 do
   begin
      J := FBitRev[I];
      if J > I then
      begin
         Temp := Data[I];
         Data[I] := Data[J];
         Data[J] := Temp;
      end;
   end;
end;

procedure TFFTCooleyTukey.FFT(var Data: array of TComplex; Inverse: Boolean);
var
   N, L, M, I, J, K: Integer;
   W, Temp, U: TComplex;
begin
   N := FSize;
   BitReverse(Data);

   for L := 1 to Trunc(Log2(N)) do
   begin
      M := 1 shl L;
      for K := 0 to M div 2 - 1 do
      begin
         W := FExpTable[K shl (Trunc(Log2(N)) - L)];
         if Inverse then
         begin
            W.Imag := -W.Imag;
         end;

         J := K;
         while J < N - M do
         begin
            I := J + M div 2;
            Temp := TFFTCooleyTukey.Multiply(Data[I], W);
            U := Data[J];
            Data[J] := TFFTCooleyTukey.Add(U, Temp);
            Data[I] := TFFTCooleyTukey.Subtract(U, Temp);

            Inc(J, M);
         end;
      end;

   end;

   if Inverse then
   begin
      for I := 0 to N - 1 do
      begin
         if Inverse then
            begin
               Data[I].Real := Data[I].Real / N;
               Data[I].Imag := Data[I].Imag / N;
            end;
      end;
   end;
end;

procedure TFFTCooleyTukey.Transform(var Data: array of TComplex);
begin
   FFT(Data, False);
end;

procedure TFFTCooleyTukey.InverseTransform(var Data: array of TComplex);
begin
   FFT(Data, True);
end;

end.
