{ Interface invocable IJetonLaunch }

unit JetonLaunchIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type

  TEnumTest = (etNone, etAFew, etSome, etAlot);

  TDoubleArray = array of Double;

  TMyEmployee = class(TRemotable)
  private
    FLastName: AnsiString;
    FFirstName: AnsiString;
    FSalary: Double;
  published
    property LastName: AnsiString read FLastName write FLastName;
    property FirstName: AnsiString read FFirstName write FFirstName;
    property Salary: Double read FSalary write FSalary;
  end;

  { Les interfaces invocables doivent dériver de IInvokable }
  IJetonLaunch = interface(IInvokable)
  ['{A23414F7-3292-4620-AAC4-FF95CC2BD6E8}']

    { Les méthodes de l'interface invocable ne doivent pas utiliser la valeur par défaut }
    { convention d'appel ; stdcall est recommandé }
    function echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
    function echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
    function echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
    function echoDouble(const Value: Double): Double; stdcall;
    function GetToken(const ANomClient, ASender: string): string; stdcall;
    procedure FreeToken(const ANomClient, ASender: string); stdcall;
  end;

implementation

initialization
  { Les interfaces invocables doivent être enregistrées }
  InvRegistry.RegisterInterface(TypeInfo(IJetonLaunch));

end.
