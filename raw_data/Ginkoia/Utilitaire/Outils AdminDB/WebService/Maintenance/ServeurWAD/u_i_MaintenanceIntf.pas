{ Interface invocable I_Maintenance }

unit u_i_MaintenanceIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type

  { Les interfaces invocables doivent dériver de IInvokable }
  I_Maintenance = interface(IInvokable)
  ['{23F3644A-770E-4DF0-B967-728999E8A18A}']

    { Les méthodes de l'interface invocable ne doivent pas utiliser la }
    { convention d'appel par défaut ; stdcall est conseillé }
  end;

implementation

initialization
  { Les interfaces invocables doivent être recensées }
  InvRegistry.RegisterInterface(TypeInfo(I_Maintenance));

end.
