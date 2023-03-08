unit Problem;
{$mode objfpc}{$H+}
{$interfaces corba}
interface
uses
  Classes
  ,SysUtils
  ,Solution;
type
  PTProblem = ^TProblem;
  TProblem = class
  public
   Procedure GetMemory;virtual;abstract;
   Procedure FreeMemory;virtual;abstract;
   Function GetSize :Integer;virtual;abstract;
   Function GetSize_:Integer;virtual;abstract;
   Procedure SetValue(x:TSolution);virtual;abstract;
   Function GetUpBoundary(i:Integer):Integer;virtual;abstract;

   Property Size :Integer read GetSize;
   Property Size_ :Integer read GetSize_;

  end;
implementation

end.

