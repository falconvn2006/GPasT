{ Fichier d'implémentation invocable pour T_Maintenance implémentant I_Maintenance }

unit u_i_MaintenanceImpl;

interface

uses InvokeRegistry, Types, XSBuiltIns, u_i_MaintenanceIntf;

type

  { T_Maintenance }
  T_Maintenance = class(TInvokableClass, I_Maintenance)
  public
  end;

implementation


initialization
{ les classes invocables doivent être recensées  }
   InvRegistry.RegisterInvokableClass(T_Maintenance);

end.

