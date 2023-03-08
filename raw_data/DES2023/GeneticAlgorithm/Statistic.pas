unit Statistic;
interface
 uses
  VarType,
  RunStatistic;
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
  ResultArray = array of TRunStatistic;
  PTRunStatistic = ^TRunStatistic;
  TStatistic = Class
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
   Procedure WriteInFile(var f:TextFile; use_iter_stat:TBool);
  public
   RunStatistic                :ResultArray;

   Constructor Create;overload;
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure AppendInFile(name : TString; use_iter_stat:TBool);
   Procedure RewriteFile(name : TString; use_iter_stat:TBool);

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
 Procedure TStatistic.GetStatistic;
 var
   i:TInt;
   sum:TReal;
 begin
  if RealQuantity_ > 0 then
  begin
    sum:=0;
    for i:=0 to RealQuantity_ do
     sum:=sum+RunStatistic[i].RunTime;

    AmountTimeMean:=sum/(RealQuantity*1.0);

     sum:=0;
     for i:=0 to RealQuantity_ do
      sum:=sum+RunStatistic[i].Result.Getvalue;
     Expectation:=sum/(RealQuantity*1.0);

     sum:=0;
     for i:=0 to RealQuantity_ do
      sum:=sum+(Expectation-RunStatistic[i].Result.Getvalue)*(Expectation-RunStatistic[i].Result.Getvalue);
     if RealQuantity = 1 then
      Dispersion:=0
     else
      Dispersion:=sum/(1.0*RealQuantity-1.0);

     sum:=Dispersion/(Quantity*1.0);
     TrustInterval:=1.96*sqrt(sum);

     AmountIterationMean:=0;
     for i:=0 to RealQuantity_ do
      AmountIterationMean:=AmountIterationMean+RunStatistic[i].AmountIteration;
     AmountIterationMean:=AmountIterationMean/(RealQuantity*1.0);
  end;
 end;
 {******************************************************************************}
  Procedure TStatistic.WriteInFile(var f:TextFile; use_iter_stat:TBool);
  var
   s:TString;
   i,j:TInt;
  begin
    FindAll;

    //s:=b1;
   s:='';
   for i:=0 to RunStatistic[BestRecordNumber].Result.Size-1 do
     s:=s+IntToStr(RunStatistic[BestRecordNumber].Result.Element[i])+' ';
   writeln(f,'Solution: ' + s);
   writeln(f,'Throughput: ' + FloatToStr(RunStatistic[BestRecordNumber].Result.Throughput));
   writeln(f,'Volume: ' + FloatToStr(RunStatistic[BestRecordNumber].Result.Volume));
   writeln(f,'StorageCost: ' + FloatToStr(RunStatistic[BestRecordNumber].Result.StorageCost));
   WriteLn(f,'______________________________________________________________');
   writeln(f,'Value: ' + FloatToStr(RunStatistic[BestRecordNumber].Result.GetValue));
   if use_iter_stat = True then
   begin
      WriteLn(f,'______________________________________________________________');
      for i:=0 to FRealQuantity-1 do
        for j:=0 to RunStatistic[i].IterationStatistic.Count-1 do
          WriteLn(f,RunStatistic[i].IterationStatistic[j]);

      WriteLn(f,'______________________________________________________________');
   end
   else
   begin
      WriteLn(f,'______________________________________________________________');
      for i:=0 to FRealQuantity-1 do
         WriteLn(f,RunStatistic[i].IterationStatistic[RunStatistic[i].IterationStatistic.Count-1]);
      WriteLn(f,'______________________________________________________________');
   end;
    {s:=b3;
    for i:=0 to size_ do
     s:=s+IntToStr(RunStatistic[WorseRecordNumber].Element[i])+' ';
    writeln(f,s);

    s:=b4+FloatToStr(RunStatistic[WorseRecordNumber].GetValue);
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
     write(f,RunStatistic[i].GetValue,' ');
     for j:=0 to Size_ do
      write(f,RunStatistic[i].Element[j],' ');
     writeln(f);
    end; }
  end;
  {******************************************************************************}
   Procedure TStatistic.AppendInFile(name : TString; use_iter_stat:TBool);
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

     WriteInFile(f,use_iter_stat);

     closefile(f);
    end;
   end;
{******************************************************************************}
 Procedure TStatistic.RewriteFile(name : TString; use_iter_stat:TBool);
 var
  s:TString;
  f:TextFile;
  i,j:TInt;
 begin
  if name<> '' then
  begin
   AssignFile(f,name);
   Rewrite(f);

   WriteInFile(f,use_iter_stat);

   closefile(f);
  end;
 end;
{******************************************************************************}
 Constructor TStatistic.Create;
 begin
  FRealQuantity:=0;
 end;
{******************************************************************************}
 Destructor TStatistic.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure TStatistic.GetMemory;
 var i:TInt; tmp:TRunStatistic;
 begin
  SetLength(RunStatistic, Quantity);
  for i:=0 to Quantity_ do
  begin
   RunStatistic[i]:=TRunStatistic.Create;
   RunStatistic[i].Result.Size:=Size;
  end;
 end;
{******************************************************************************}
 Procedure TStatistic.FreeMemory;
 var i:TInt;
 begin
  if Length(RunStatistic)<>0 then
  begin
   for i:=0 to High(RunStatistic) do RunStatistic[i].Destroy;
   Finalize(RunStatistic);
  end;
 end;
{******************************************************************************}
 Procedure TStatistic.FindBest;
 var
  i  :TInt;
  max:TReal;
 begin
  if RealQuantity_ > 0 then
  begin
    max:=RunStatistic[0].Result.GetValue;
    FBestRecordNumber:=0;
    for i:=1 to RealQuantity_ do
     if RunStatistic[i].Result.Getvalue > max then
     begin
      max:=RunStatistic[i].Result.Getvalue;
      FBestRecordNumber:=i;
     end;
  end;
 end;
{******************************************************************************}
 Procedure TStatistic.FindWorse;
 var
  i:TInt;
  min:TReal;
 begin
  if RealQuantity_ > 0 then
  begin
    min:=RunStatistic[0].Result.Getvalue;
    FWorseRecordNumber:=0;
    for i:=1 to RealQuantity_ do
     if RunStatistic[i].Result.Getvalue < min then
     begin
      min:=RunStatistic[i].Result.Getvalue;
      FWorseRecordNumber:=i;
     end;
  end;
 end;
{******************************************************************************}
 Procedure TStatistic.FindAll;
 begin
  FindBest;
  FindWorse;
 end;
{******************************************************************************}
 Procedure TStatistic.SetQuantity(x:TInt);
 begin
  FreeMemory;
  FQuantity:=x;
  GetMemory;
 end;
{******************************************************************************}
 Function TStatistic.GetQuantity_ :TInt;
 begin
  GetQuantity_:=Quantity-1;
 end;
{******************************************************************************}
 Function TStatistic.GetSize_ :TInt;
 begin
  GetSize_:=Size-1;
 end;
{******************************************************************************}
 Function TStatistic.GetRealQuantity_ :TInt;
 begin
  GetRealQuantity_:=RealQuantity-1;
 end;
{******************************************************************************}
end.
