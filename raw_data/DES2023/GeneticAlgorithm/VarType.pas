unit VarType;
interface
const
  am=255;
  an=255;
  mx=1.0e+37;
  max=255;
  min=-1e30;
 type
{MAIN--------------------------------------------------------------------------}
  TIndex = Integer;
  TPointer = Pointer;
//  TVariant = Variant;
  TInt = Integer;
  TReal = Double;
  TBool = Boolean;
  TString = string;
  TChar = char;

  PTInt = ^TInt;
  PTReal = ^TReal;

  PTBool = ^TBool;
  PTString = ^TString;
  PTChar = ^TChar;

//  TVariantArray = array of TVariant;
  TIntArray = array of TInt;
  TRealArray = array of TReal;
  TBoolArray = array of TBool;
  TStringArray = array of TString;
  TCharArray = array of TChar;

  TPIntArray = array of PTInt;
  TPRealArray = array of PTReal;

  TPBoolArray = array of PTBool;
  TPStringArray = array of PTString;
  TPCharArray = array of PTChar;

  PTIntArray = ^TIntArray;
  PTRealArray = ^TRealArray;
  PTBoolArray = ^TBoolArray;

implementation
end.
