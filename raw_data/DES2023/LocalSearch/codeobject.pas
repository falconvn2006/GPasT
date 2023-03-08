unit CodeObject;
interface
 {$mode objfpc}{$H+}
{$interfaces corba}
  uses
  Cryptographer;
 type
  PICodeObject = ^ICodeObject;
  ICodeObject = Interface
       Procedure SetCode(var x:TCryptographer);
       Function GetCode:Double;
       Property Code:Double read GetCode;
  end;
implementation
end.

