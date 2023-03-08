UNIT u_nomsrv;

INTERFACE

USES
    WinSvc,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

TYPE
    TForm1 = CLASS(TForm)
        Edit1: TEdit;
        Button1: TButton;
        PROCEDURE Button1Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    Pc: pchar;
    size : DWord ;
    hSCManager : SC_HANDLE ;
BEGIN
    hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT) ;
    getmem(pc, 1000); size := 1000;
    GetServiceKeyName(hSCManager, Pchar(Edit1.Text), pc, size);
    Caption := pc;
    freemem(pc, 1000);
    CloseServiceHandle(hSCManager);
END;

END.

