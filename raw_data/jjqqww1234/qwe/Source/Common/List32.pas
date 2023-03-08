unit List32;

{ U_IntList
Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for non-commercial purposes
 so long as this original notice remains in place.
 All other rights are reserved
 }
{ List32
Modified by Cardinal.
TIntList32: based on TIntList. changed int64 to cardinal, added IndexOfObject.
TList32: based on TList. added IndexOfObject.
}

interface

uses Classes, sysconst, SysUtils;

const
  maxlistsize = maxint div 32;

type
  { TIntList32 class }
  TIntList32 = class;

  PIntItem = ^TIntItem;

  TIntItem = record
    FInt:    cardinal;
    FObject: TObject;
  end;

  PIntItemList = ^TIntItemList;
  TIntItemList = array[0..MaxListSize] of TIntItem;
  TIntListSortCompare = function(List: TIntList32; Index1, Index2: integer): integer;

  TIntList32 = class(TPersistent)
  private
    FUpDateCount: integer;
    FList:     PIntItemList;
    FCount:    integer;
    FCapacity: integer;
    FSorted:   boolean;
    FDuplicates: TDuplicates;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    procedure ExchangeItems(Index1, Index2: integer);
    procedure Grow;
    procedure QuickSort(L, R: integer; SCompare: TIntListSortCompare);
    procedure InsertItem(Index: integer; const S: cardinal);
    procedure SetSorted(Value: boolean);
  protected
    procedure Error(const Msg: string; Data: integer);
    procedure Changed; virtual;
    procedure Changing; virtual;
    function Get(Index: integer): cardinal;
    function GetCapacity: integer;
    function GetCount: integer;
    function GetObject(Index: integer): TObject;
    procedure Put(Index: integer; const S: cardinal);
    procedure PutObject(Index: integer; AObject: TObject);
    procedure SetCapacity(NewCapacity: integer);
    procedure SetUpdateState(Updating: boolean);
  public

    destructor Destroy; override;
    function Add(const S: cardinal): integer;
    function AddObject(const S: cardinal; AObject: TObject): integer; virtual;
    procedure Clear;
    procedure Delete(Index: integer);
    procedure Exchange(Index1, Index2: integer);
    function Find(const S: cardinal; var Index: integer): boolean; virtual;
    function IndexOf(const S: cardinal): integer;
    function IndexOfObject(const S: cardinal): TObject;
    procedure Insert(Index: integer; const S: cardinal);
    procedure Sort; virtual;
    procedure CustomSort(Compare: TIntListSortCompare); virtual;

    procedure LoadFromFile(const FileName: string); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    procedure SaveToStream(Stream: TStream);

    property Duplicates: TDuplicates Read FDuplicates Write FDuplicates;
    property Sorted: boolean Read FSorted Write SetSorted;
    property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
    property OnChanging: TNotifyEvent Read FOnChanging Write FOnChanging;
    property Integers[Index: integer]: cardinal Read Get Write Put; default;
    property Count: integer Read GetCount;
    property Objects[Index: integer]: TObject Read GetObject Write PutObject;
  end;

implementation


{ TIntList32 }

destructor TIntList32.Destroy;
begin
  FOnChange   := nil;
  FOnChanging := nil;
  inherited Destroy;
  FCount := 0;
  SetCapacity(0);
end;



procedure TIntList32.Error(const Msg: string; Data: integer);

  function ReturnAddr: Pointer;
  asm
    MOV     EAX,[EBP+4]
  end;

begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;


const
  sDuplicateInt: string = 'Cannot add integer because if already exists';
  sListIndexError  = 'List index Error';
  SSortedListError = 'Cannont insert to sorted list';

function TIntList32.Add(const S: cardinal): integer;
begin
  if not Sorted then Result := FCount
  else if Find(S, Result) then case Duplicates of
      dupIgnore: Exit;
      dupError: Error(SDuplicateInt, 0);
    end;
  InsertItem(Result, S);
end;

function TIntList32.AddObject(const S: cardinal; AObject: TObject): integer;
begin
  Result := Add(S);
  PutObject(Result, AObject);
end;

procedure TIntList32.Changed;
begin
  if (FUpdateCount = 0) and Assigned(FOnChange) then FOnChange(Self);
end;

procedure TIntList32.Changing;
begin
  if (FUpdateCount = 0) and Assigned(FOnChanging) then FOnChanging(Self);
end;

procedure TIntList32.Clear;
begin
  if FCount <> 0 then begin
    Changing;
    FCount := 0;
    SetCapacity(0);
    Changed;
  end;
end;

procedure TIntList32.Delete(Index: integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  Dec(FCount);
  if Index < FCount then System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TIntItem));
  Changed;
end;

procedure TIntList32.Exchange(Index1, Index2: integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
  Changing;
  ExchangeItems(Index1, Index2);
  Changed;
end;

procedure TIntList32.ExchangeItems(Index1, Index2: integer);
var
  Temp: cardinal;
  Item1, Item2: PIntItem;
begin
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  Temp  := integer(Item1^.FInt);
  Item1^.FInt := Item2^.FInt;
  Item2^.FInt := Temp;
  Temp  := integer(Item1^.FObject);
  integer(Item1^.FObject) := integer(Item2^.FObject);
  integer(Item2^.FObject) := Temp;
end;

function TIntList32.Find(const S: cardinal; var Index: integer): boolean;
var
  L, H, I: integer;
begin
  Result := False;
  L      := 0;
  H      := FCount - 1;
  while L <= H do begin
    I := (L + H) shr 1;
    if Flist^[I].FInt < S then L := L + 1
    else begin
      H := I - 1;
      if FList^[I].FInt = S then begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function TIntList32.Get(Index: integer): cardinal;
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Result := FList^[Index].FInt;
end;

function TIntList32.GetCapacity: integer;
begin
  Result := FCapacity;
end;

function TIntList32.GetCount: integer;
begin
  Result := FCount;
end;

function TIntList32.GetObject(Index: integer): TObject;
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Result := FList^[Index].FObject;
end;

procedure TIntList32.Grow;
var
  Delta: integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4
  else if FCapacity > 8 then Delta := 16
  else
    Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TIntList32.IndexOf(const S: cardinal): integer;
begin
  if not Sorted then begin
    for Result := 0 to GetCount - 1 do if Get(Result) = s then Exit;
    Result := -1;
  end else if not Find(S, Result) then Result := -1;
end;

function TIntList32.IndexOfObject(const S: cardinal): TObject;
var
  i: integer;
begin
  i := IndexOf(S);
  if i = -1 then Result := nil
  else
    Result := GetObject(i);
end;

procedure TIntList32.Insert(Index: integer; const S: cardinal);
begin
  if Sorted then Error(SSortedListError, 0);
  if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
  InsertItem(Index, S);
end;

procedure TIntList32.InsertItem(Index: integer; const S: cardinal);
begin
  Changing;
  if FCount = FCapacity then Grow;
  if Index < FCount then System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TIntItem));
  with FList^[Index] do begin
    FObject := nil;
    FInt    := S;
  end;
  Inc(FCount);
  Changed;
end;

procedure TIntList32.Put(Index: integer; const S: cardinal);
begin
  if Sorted then Error(SSortedListError, 0);
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  FList^[Index].FInt := S;
  Changed;
end;

procedure TIntList32.PutObject(Index: integer; AObject: TObject);
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  FList^[Index].FObject := AObject;
  Changed;
end;

procedure TIntList32.QuickSort(L, R: integer; SCompare: TIntListSortCompare);
var
  I, J, P: integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do Inc(I);
      while SCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then begin
        ExchangeItems(I, J);
        if P = I then P := J
        else if P = J then P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TIntList32.SetCapacity(NewCapacity: integer);
begin
  ReallocMem(FList, NewCapacity * SizeOf(TIntItem));
  FCapacity := NewCapacity;
end;

procedure TIntList32.SetSorted(Value: boolean);
begin
  if FSorted <> Value then begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TIntList32.SetUpdateState(Updating: boolean);
begin
  if Updating then Changing
  else
    Changed;
end;


function IntListCompare(List: TIntList32; Index1, Index2: integer): integer;
begin
  if List.FList^[Index1].FInt > List.FList^[Index2].FInt then Result := +1
  else if List.FList^[Index1].FInt < List.FList^[Index2].FInt then Result := -1
  else
    Result := 0;
end;


procedure TIntList32.Sort;
begin
  CustomSort(IntListCompare);
end;


procedure TIntList32.SaveToFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TIntList32.SaveToStream(Stream: TStream);
var
  i:   integer;
  N:   integer;
  Val: cardinal;
begin
  N := Count;
  Stream.WriteBuffer(N, sizeof(N));
  for i := 0 to Count - 1 do begin
    val := integers[i];
    stream.writebuffer(val, sizeof(val));
  end;
end;


procedure TIntList32.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TIntList32.LoadFromStream(Stream: TStream);
var
  Size: integer;
  i:    integer;
  N:    cardinal;
begin
  {BeginUpdate;  }
  try
    Clear;
    Stream.readbuffer(size, sizeof(size));
    for i := 0 to size - 1 do begin
      Stream.Read(N, sizeof(N));
      add(N);
    end;
  finally
    {EndUpdate;}
  end;
end;



procedure TIntList32.CustomSort(Compare: TIntListSortCompare);
begin
  if not Sorted and (FCount > 1) then begin
    Changing;
    QuickSort(0, FCount - 1, Compare);
    Changed;
  end;
end;

end.
