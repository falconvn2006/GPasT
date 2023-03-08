unit Solution;
{$mode objfpc}{$H+}
{$interfaces corba}
interface
 type
  PTSolution = ^TSolution;
  TSolution = class
  public
   Procedure Assign(const x:TObject); virtual;abstract;

   Function IsIdentical(const x:TObject):boolean;virtual;abstract;
   Function IsEqual(const x:TObject):boolean;virtual;abstract;
   Function IsNotEqual(const x:TObject):boolean;virtual;abstract;
   Function IsBetter(const x:TObject):boolean;virtual;abstract;
   Function IsBetterOrEqual(const x:TObject):boolean;virtual;abstract;
   Function IsWorseOrEqual(const x:TObject):boolean;virtual;abstract;
   Function IsWorse(const x:TObject):boolean;virtual;abstract;

   Procedure GetMemory;virtual;abstract;
   Procedure FreeMemory;virtual;abstract;
  end;
implementation
end.
