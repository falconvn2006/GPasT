unit IterRs;
interface
 uses
  VarType,
  IterR;
 const
  b1 = 'Best solve: ';
  b2 = 'Best solve value: ';
  b3 = 'Worse solve: ';
  b4 = 'Worse solve value: ';
  b5 = 'Expectation: ';
  b6 = 'Variance: ';
  b7 = 'Confidence segment: ';
  b8 = 'Amount iteration mean at one run: ';
  b9 = 'Amount time mean one run: ';

 type
  ResultArray = array of TIterationResult;
  PTIterationResults = ^TIterationResults;
  TIterationResults = Class
  private
   FAmountIterationMean        :TReal;
   FAmountTimeMean             :TReal;
   FExpectation                :TReal;
   FDispersion                 :TReal;
   FTrustInterval              :TReal;

   FBestRecordNumber           :TInt;
   FWorseRecordNumber          :TInt;

   FQuantity                   :TInt;
   FRealQuantity               :TInt;
   FSize                       :TInt;

   Function GetSize_:TInt;
   Procedure SetQuantity(x:TInt);
   Function GetQuantity_:TInt;
   Function GetRealQuantity_:TInt;
   Procedure WriteInFile(var f:TextFile);
  public
   RunResult                  :ResultArray;

   Constructor Create(var x:TIterationResults);overload;
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;
   Procedure Assign(var x:TIterationResults);

   Procedure AppendInFile(name : TString);
   Procedure RewriteFile(name : TString);

   Procedure GetStatistic;
   Procedure FindBest;
   Procedure FindWorse;
   Procedure FindAll;

   Property AmountIterationMean :TReal read FAmountIterationMean write FAmountIterationMean;
   Property AmountTimeMean :TReal read FAmountTimeMean write FAmountTimeMean;
   Property Expectation :TReal read FExpectation write FExpectation;
   Property Dispersion :TReal read FDispersion write FDispersion;
   Property TrustInterval :TReal read FTrustInterval write FTrustInterval;

   Property Size:TInt read FSize write FSize;
   Property Size_:TInt read GetSize_;

   Property Quantity:TInt read FQuantity write SetQuantity;
   Property Quantity_:TInt read GetQuantity_;

   Property RealQuantity:TInt read FRealQuantity write FRealQuantity;
   Property RealQuantity_:TInt read GetRealQuantity_;

   Property BestRecordNumber :TInt read FBestRecordNumber;
   Property WorseRecordNumber:TInt read FWorseRecordNumber;
  end;
implementation
 uses Sysutils;
{******************************************************************************}
 Procedure TIterationResults.GetStatistic;
 var
   i:TInt;
   sum:TReal;
 begin
  if RealQuantity_ > 0 then
  begin
    sum:=0;
    for i:=0 to RealQuantity_ do
     sum:=sum+RunResult[i].RunTime;

    AmountTimeMean:=sum/(RealQuantity*1.0);

     sum:=0;
     for i:=0 to RealQuantity_ do
      sum:=sum+RunResult[i].Getvalue;
     Expectation:=sum/(RealQuantity*1.0);

     sum:=0;
     for i:=0 to RealQuantity_ do
      sum:=sum+(Expectation-RunResult[i].Getvalue)*(Expectation-RunResult[i].Getvalue);
     if RealQuantity = 1 then
      Dispersion:=0
     else
      Dispersion:=sum/(1.0*RealQuantity-1.0);

     sum:=Dispersion/(Quantity*1.0);
     TrustInterval:=1.96*sqrt(sum);

     AmountIterationMean:=0;
     for i:=0 to RealQuantity_ do
      AmountIterationMean:=AmountIterationMean+Runresult[i].AmountIteration;
     AmountIterationMean:=AmountIterationMean/(RealQuantity*1.0);
  end;
 end;
 {******************************************************************************}
  Procedure TIterationResults.WriteInFile(var f:TextFile);
  var
   s:TString;
   i,j:TInt;
  begin
    FindAll;

    //s:=b1;
   s:='';
   for i:=0 to RunResult[BestRecordNumber].Size-1 do
     s:=s+IntToStr(RunResult[BestRecordNumber].Element[i])+' ';
   writeln(f,'Solution: ' + s);
   writeln(f,'Throughput: ' + FloatToStr(RunResult[BestRecordNumber].Throughput));
   writeln(f,'Volume: ' + FloatToStr(RunResult[BestRecordNumber].Volume));
   writeln(f,'StorageCost: ' + FloatToStr(RunResult[BestRecordNumber].StorageCost));
   WriteLn(f,'______________________________________________________________');
   writeln(f,'Value: ' + FloatToStr(RunResult[BestRecordNumber].GetValue));


    {s:=b3;
    for i:=0 to size_ do
     s:=s+IntToStr(RunResult[WorseRecordNumber].Element[i])+' ';
    writeln(f,s);

    s:=b4+FloatToStr(RunResult[WorseRecordNumber].GetValue);
    writeln(f,s);

    s:=b5+FloatToStr(Expectation);
    writeln(f,s);

    s:=b6+FloatToStr(Dispersion);
    writeln(f,s);

    s:=b7+FloatToStr(TrustInterval);
    writeln(f,s);

    s:=b8+FloatToStr(AmountIterationMean);
    writeln(f,s);

    s:=b9+Floattostr(AmountTimeMean)+'(Sec)';
    writeln(f,s);

    for i:=0 to RealQuantity_ do
    begin
     write(f,RunResult[i].GetValue,' ');
     for j:=0 to Size_ do
      write(f,RunResult[i].Element[j],' ');
     writeln(f);
    end; }
  end;
  {******************************************************************************}
   Procedure TIterationResults.AppendInFile(name : TString);
   var
    s:TString;
    f:TextFile;
    i,j:TInt;
   begin
    if name<> '' then
    begin
     AssignFile(f,name);
     Append(f);

     FindAll;

     WriteInFile(f);

     closefile(f);
    end;
   end;
{******************************************************************************}
 Procedure TIterationResults.RewriteFile(name : TString);
 var
  s:TString;
  f:TextFile;
  i,j:TInt;
 begin
  if name<> '' then
  begin
   AssignFile(f,name);
   Rewrite(f);

   WriteInFile(f);

   closefile(f);
  end;
 end;
{******************************************************************************}
 Constructor TIterationResults.Create(var x:TIterationResults);
 begin
  Assign(x);
  FRealQuantity:=0;
 end;
{******************************************************************************}
 Destructor TIterationResults.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure TIterationResults.GetMemory;
 var i:TInt;
 begin
  SetLength(RunResult, Quantity);
  for i:=0 to Quantity_ do
  begin
   RunResult[i]:=TIterationResult.Create;
   RunResult[i].Size:=Size;
  end;
 end;
{******************************************************************************}
 Procedure TIterationResults.FreeMemory;
 var i:TInt;
 begin
  if Length(RunResult)<>0 then
  begin
   for i:=0 to High(RunResult) do RunResult[i].Destroy;
   Finalize(RunResult);
  end;
 end;
{******************************************************************************}
 Procedure TIterationResults.Assign(var x:TIterationResults);
 var i:TInt;
 begin
  if Quantity <> x.Quantity then   Quantity := x.Quantity;
  for i:=0 to Quantity_ do RunResult[i].Assign(x.RunResult[i]);
  if Quantity_>0 then FSize:=RunResult[Quantity_].Size;
  FBestRecordNumber :=x.BestRecordNumber;
  FWorseRecordNumber:=x.WorseRecordNumber;
 end;
{******************************************************************************}
 Procedure TIterationResults.FindBest;
 var
  i  :TInt;
  max:TReal;
 begin
  if RealQuantity_ > 0 then
  begin
    max:=RunResult[0].GetValue;
    FBestRecordNumber:=0;
    for i:=1 to RealQuantity_ do
     if RunResult[i].Getvalue > max then
     begin
      max:=RunResult[i].Getvalue;
      FBestRecordNumber:=i;
     end;
  end;
 end;
{******************************************************************************}
 Procedure TIterationResults.FindWorse;
 var
  i:TInt;
  min:TReal;
 begin
  if RealQuantity_ > 0 then
  begin
    min:=RunResult[0].Getvalue;
    FWorseRecordNumber:=0;
    for i:=1 to RealQuantity_ do
     if RunResult[i].Getvalue < min then
     begin
      min:=RunResult[i].Getvalue;
      FWorseRecordNumber:=i;
     end;
  end;
 end;
{******************************************************************************}
 Procedure TIterationResults.FindAll;
 begin
  FindBest;
  FindWorse;
 end;
{******************************************************************************}
 Procedure TIterationResults.SetQuantity(x:TInt);
 begin
  FreeMemory;
  FQuantity:=x;
  GetMemory;
 end;
{******************************************************************************}
 Function TIterationResults.GetQuantity_ :TInt;
 begin
  GetQuantity_:=Quantity-1;
 end;
{******************************************************************************}
 Function TIterationResults.GetSize_ :TInt;
 begin
  GetSize_:=Size-1;
 end;
{******************************************************************************}
 Function TIterationResults.GetRealQuantity_ :TInt;
 begin
  GetRealQuantity_:=RealQuantity-1;
 end;
{******************************************************************************}
end.
