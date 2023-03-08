UNIT UMAJVOLD;

INTERFACE

USES
    Registry,
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

FUNCTION Enumerate(hwnd: HWND; Param: LPARAM): Boolean; STDCALL; FAR;
VAR
    lpClassName: ARRAY[0..999] OF Char;
    lpClassName2: ARRAY[0..999] OF Char;
    Handle: DWORD;
    // lpdwProcessId: Pointer;
BEGIN
    result := true;
    Windows.GetClassName(hWnd, lpClassName, 500);
    IF Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' THEN
    BEGIN
        Windows.GetWindowText(hWnd, lpClassName2, 500);
        IF Uppercase(StrPas(lpClassName2)) = 'LE LAUNCHER' THEN
        BEGIN
            GetWindowThreadProcessId(hWnd, @Handle);
            TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, False, Handle), 0);
            result := False;
        END;
    END;
END;

PROCEDURE TForm1.FormActivate(Sender: TObject);
VAR
    path: STRING;
    ginkoia: STRING;
    S: STRING;
    reg: TRegistry;
BEGIN
    IF first THEN
    BEGIN
        first := false;
        Label1.update; Update;
        Application.processmessages;
        EnumWindows(@Enumerate, 0);

        Path := IncludeTrailingBackslash(extractfilepath(application.exename));
        Path := Uppercase(Path);
        Ginkoia := Copy(Path, 1, pos('\LIVEUPDATE', Path));

        Copyfile(Pchar(Path + 'Pqt_Patch.bpl'), Pchar(Ginkoia + 'BPL\Pqt_Patch.bpl'),false);
        Copyfile(Pchar(Path + 'LaunchV7.exe'), Pchar(Ginkoia + 'LaunchV7.exe'),false);
        Copyfile(Pchar(Path + 'VerifVersion.exe'), Pchar(Ginkoia + 'VerifVersion.exe'),false);

        S := '';
        TRY
            reg := TRegistry.Create(KEY_READ);
            TRY
                reg.RootKey := HKEY_LOCAL_MACHINE;
                reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
                S := reg.ReadString('Launch_Replication');
            FINALLY
                reg.free;
            END;
        EXCEPT
        END;
        IF S <> '' THEN
        BEGIN
            Winexec(PChar(S), 0);
        END;
        Close;
    END;
END;

END.

