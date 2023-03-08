UNIT UMAJPATCH;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls;

TYPE
    TForm1 = CLASS(TForm)
        Label1: TLabel;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormActivate(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        first: boolean;
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TForm1.FormCreate(Sender: TObject);
BEGIN
    first := true;
    Update; Label1.update;
END;

PROCEDURE TForm1.FormActivate(Sender: TObject);
VAR
    path: STRING;
    ginkoia: STRING;
    i: integer;
BEGIN
    IF first THEN
    BEGIN
        first := false;
        Label1.update; Update;
        Path := IncludeTrailingBackslash(extractfilepath(application.exename));
        Path := Uppercase(Path);
        Ginkoia := Copy(Path, 1, pos('\LIVEUPDATE', Path));
        Copyfile(Pchar(Path + 'MAJAuto.exe'), Pchar(Ginkoia + '\LiveUpdate\MAJAuto.exe'), false);
        FOR i := 1 TO 50 DO
        BEGIN
            Application.processmessages;
            sleep(100);
        END;
        FOR i := 1 TO 100 DO
        BEGIN
            IF Copyfile(Pchar(Ginkoia + '\LiveUpdate\MAJAuto.exe'), Pchar(Ginkoia + 'MAJAuto.exe'), false) THEN
                break;
            sleep(1000);
        END;
        FOR i := 1 TO 100 DO
        BEGIN
            IF deletefile(Ginkoia + '\LiveUpdate\Afaire.txt') THEN
                BREAK;
            sleep(1000);
        END;
        Close;
    END;
END;

END.

