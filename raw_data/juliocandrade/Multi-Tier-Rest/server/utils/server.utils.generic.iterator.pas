unit server.utils.generic.iterator;

interface

uses
  System.Generics.Collections;
type
  iGenericIterator<T> = interface
    ['{61625260-A81A-42FD-8C96-A985F189A63E}']
    function HasNext : boolean;
    function Next : T;
  end;

  TGenericIterator<T: class, constructor> = class(TInterfacedObject, iGenericIterator<T>)
  private
    FList : TObjectList<T>;
    FCount : Integer;
  public
    constructor Create(AList : TObjectList<T>);
    class function New(AList : TObjectList<T>) : iGenericIterator<T>;
    function HasNext : boolean;
    function Next : T;

  end;
implementation

{ TGenericIterator<T> }

constructor TGenericIterator<T>.Create(AList : TObjectList<T>);
begin
  FList := AList;
  FCount := 0;
end;

function TGenericIterator<T>.HasNext: boolean;
begin
  Result := not (FCount = FList.Count);
end;

class function TGenericIterator<T>.New(AList : TObjectList<T>): iGenericIterator<T>;
begin
  Result := Self.Create(AList);
end;

function TGenericIterator<T>.Next: T;
begin
  Result := FList[FCount];
  Inc(FCount);
end;

end.
