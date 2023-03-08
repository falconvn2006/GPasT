unit Hash;
interface
{$mode objfpc}{$H+}
{$interfaces corba}

 type
  PTObject = ^TObject;
  PTHash = ^THash;
  THash = class
  public
    procedure Add(x:PTObject);virtual;abstract;
    function Find(x:PTObject):PTObject;virtual;abstract;
    function Equal(const x,y:PTObject):boolean;virtual;abstract;
  end;
implementation
end.


