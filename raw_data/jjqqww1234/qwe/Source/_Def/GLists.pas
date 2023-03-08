unit GLists;

interface

uses
  Windows, Classes, SyncObjs;

type
  PIntegerList = ^TIntegerList;
  TIntegerList = array[0..MaxListSize - 1] of integer;

  TIntList = class(TObject)
  private
    FList:     PIntegerList;
    FCount:    integer;
    FCapacity: integer;
  protected
    function Get(Index: integer): integer;
    procedure Grow; virtual;
    procedure Put(Index: integer; Item: integer);
    procedure SetCapacity(NewCapacity: integer);
    procedure SetCount(NewCount: integer);
  public
    destructor Destroy; override;
    function Add(Item: integer): integer;
    procedure Assign(List: TIntList);
    procedure Clear; virtual;
    procedure Delete(Index: integer);
    class procedure Error(const Msg: string; Data: integer); overload; virtual;
    class procedure Error(Msg: PResStringRec; Data: integer); overload;
    procedure Exchange(Index1, Index2: integer);
    function Expand: TIntList;
    function Extract(Item: integer): integer;
    function First: integer;
    function IndexOf(Item: integer): integer;
    procedure Insert(Index: integer; Item: integer);
    function Last: integer;
    procedure Move(CurIndex, NewIndex: integer);
    function Remove(Item: integer): integer;
    procedure Sort;
    property Capacity: integer Read FCapacity Write SetCapacity;
    property Count: integer Read FCount Write SetCount;
    property Items[Index: integer]: integer Read Get Write Put; default;
    property List: PIntegerList Read FList;
  end;

  TGList = class(TList)
  protected
    CriticalSection: TCriticalSection;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Enter;
    procedure Leave;
  end;

  TGStringList = class(TStringList)
  protected
    CriticalSection: TCriticalSection;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Enter;
    procedure Leave;
  end;

implementation

uses
  RTLConsts, SysConst;

{ TIntList }

function TIntList.Add(Item: integer): integer;
begin
  Result := FCount;
  if Result = FCapacity then
    Grow;
  FList^[Result] := Item;
  Inc(FCount);
end;

procedure TIntList.Assign(List: TIntList);
var
  I: integer;
begin
  Clear;
  Capacity := List.Capacity;
  for I := 0 to List.Count - 1 do
    Add(List[I]);
end;

procedure TIntList.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

procedure TIntList.Delete(Index: integer);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(@SListIndexError, Index);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(integer));
end;

destructor TIntList.Destroy;
begin
  Clear;
end;

class procedure TIntList.Error(Msg: PResStringRec; Data: integer);
begin
  TIntList.Error(LoadResString(Msg), Data);
end;

class procedure TIntList.Error(const Msg: string; Data: integer);

  function ReturnAddr: Pointer;
  asm
           MOV     EAX,[EBP+4]
  end;

begin
  raise EListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure TIntList.Exchange(Index1, Index2: integer);
var
  Item: integer;
begin
  if (Index1 < 0) or (Index1 >= FCount) then
    Error(@SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then
    Error(@SListIndexError, Index2);
  Item := FList^[Index1];
  FList^[Index1] := FList^[Index2];
  FList^[Index2] := Item;
end;

function TIntList.Expand: TIntList;
begin
  if FCount = FCapacity then
    Grow;
  Result := Self;
end;

function TIntList.Extract(Item: integer): integer;
var
  I: integer;
begin
  Result := 0;
  I      := IndexOf(Item);
  if I >= 0 then begin
    Result    := Item;
    FList^[I] := 0;
    Delete(I);
  end;
end;

function TIntList.First: integer;
begin
  Result := Get(0);
end;

function TIntList.Get(Index: integer): integer;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(@SListIndexError, Index);
  Result := FList^[Index];
end;

procedure TIntList.Grow;
var
  Delta: integer;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else if FCapacity > 8 then
    Delta := 16
  else
    Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TIntList.IndexOf(Item: integer): integer;
begin
  Result := 0;
  while (Result < FCount) and (FList^[Result] <> Item) do
    Inc(Result);
  if Result = FCount then
    Result := -1;
end;

procedure TIntList.Insert(Index, Item: integer);
begin
  if (Index < 0) or (Index > FCount) then
    Error(@SListIndexError, Index);
  if FCount = FCapacity then
    Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(Pointer));
  FList^[Index] := Item;
  Inc(FCount);
end;

function TIntList.Last: integer;
begin
  Result := Get(FCount - 1);
end;

procedure TIntList.Move(CurIndex, NewIndex: integer);
var
  Item: integer;
begin
  if CurIndex <> NewIndex then begin
    if (NewIndex < 0) or (NewIndex >= FCount) then
      Error(@SListIndexError, NewIndex);
    Item := Get(CurIndex);
    FList^[CurIndex] := 0;
    Delete(CurIndex);
    Insert(NewIndex, 0);
    FList^[NewIndex] := Item;
  end;
end;

procedure TIntList.Put(Index, Item: integer);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(@SListIndexError, Index);
  if Item <> FList^[Index] then begin
    FList^[Index] := Item;
  end;
end;

function TIntList.Remove(Item: integer): integer;
begin
  Result := IndexOf(Item);
  if Result >= 0 then
    Delete(Result);
end;

procedure TIntList.SetCapacity(NewCapacity: integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
    Error(@SListCapacityError, NewCapacity);
  if NewCapacity <> FCapacity then begin
    ReallocMem(FList, NewCapacity * SizeOf(integer));
    FCapacity := NewCapacity;
  end;
end;

procedure TIntList.SetCount(NewCount: integer);
var
  I: integer;
begin
  if (NewCount < 0) or (NewCount > MaxListSize) then
    Error(@SListCountError, NewCount);
  if NewCount > FCapacity then
    SetCapacity(NewCount);
  if NewCount > FCount then
    FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0)
  else
    for I := FCount - 1 downto NewCount do
      Delete(I);
  FCount := NewCount;
end;

procedure QuickSort(SortList: PIntegerList; L, R: integer);
var
  I, J: integer;
  P, T: integer;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SortList^[I] < P do
        Inc(I);
      while SortList^[J] > P do
        Dec(J);
      if I <= J then begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(SortList, L, J);
    L := I;
  until I >= R;
end;

procedure TIntList.Sort;
begin
  if (FList <> nil) and (Count > 0) then
    QuickSort(FList, 0, Count - 1);
end;



constructor TGList.Create;
begin
  inherited;
  CriticalSection := TCriticalSection.Create;
end;

destructor TGList.Destroy;
begin
  CriticalSection.Free;
  inherited;
end;

procedure TGList.Enter;
begin
  CriticalSection.Enter;
end;

procedure TGList.Leave;
begin
  CriticalSection.Leave;
end;

{ TGStringList }

constructor TGStringList.Create;
begin
  inherited;
  CriticalSection := TCriticalSection.Create;
end;

destructor TGStringList.Destroy;
begin
  CriticalSection.Free;
  inherited;
end;

procedure TGStringList.Enter;
begin
  CriticalSection.Enter;
end;

procedure TGStringList.Leave;
begin
  CriticalSection.Leave;
end;

end.
