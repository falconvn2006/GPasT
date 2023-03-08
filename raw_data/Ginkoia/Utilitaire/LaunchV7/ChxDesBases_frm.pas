UNIT ChxDesBases_frm;

INTERFACE

USES
    registry,
    Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls, Dialogs;

TYPE
    Tfrm_ChxDesBases = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Lb_Bases: TListBox;
        Button1: TButton;
        SB_Down: TSpeedButton;
        Sb_Up: TSpeedButton;
        Od: TOpenDialog;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Sb_UpClick(Sender: TObject);
        PROCEDURE SB_DownClick(Sender: TObject);
        PROCEDURE OKBtnClick(Sender: TObject);
    PRIVATE
    { Private declarations }
    PUBLIC
    { Public declarations }
    END;

{
VAR
    frm_ChxDesBases: Tfrm_ChxDesBases;
}

IMPLEMENTATION

{$R *.DFM}

PROCEDURE Tfrm_ChxDesBases.FormCreate(Sender: TObject);
VAR
    reg: TRegistry;
    S: STRING;
    i: integer;
BEGIN
    reg := TRegistry.Create;
    TRY
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Algol\Ginkoia', True);
        i := 0;
        REPEAT
            S := reg.ReadString('EAI' + Inttostr(i));
            IF s <> '' THEN
                Lb_Bases.Items.Add(s);
            inc(i);
        UNTIL s = '';
    FINALLY
        reg.free;
    END;
END;

PROCEDURE Tfrm_ChxDesBases.Button1Click(Sender: TObject);
VAR
    S: STRING;
    tsl: tstringList;
    S1: STRING;
    i: Integer;
BEGIN
    IF od.execute THEN
    BEGIN
        S := extractFilePath(Od.filename);
        IF S[length(S)] <> '\' THEN
            S := S + '\';
        tsl := tstringList.create;
        TRY
            tsl.LoadFromFile(Od.filename);
            S1 := Uppercase(trim(tsl.Text));
            i := Pos('<NAME>SERVER NAME</NAME>', S1);
            IF i > 0 THEN
            BEGIN
                i := I + length('<NAME>SERVER NAME</NAME>') - 1;
                delete(S1, 1, i);
                S1 := trim(S1);
                I := Pos('<VALUE>', S1);
                IF I > 0 THEN
                BEGIN
                    I := I + Length('<VALUE>') - 1;
                    delete(S1, 1, i);
                    I := Pos('<', S1) - 1;
                    IF I > 0 THEN
                    BEGIN
                        S1 := Copy(S1, 1, i);
                        IF fileexists(S1) THEN
                            Lb_Bases.Items.Add(S);
                    END;
                END;
            END;
        EXCEPT
        END;
        tsl.free;
    END;
END;

PROCEDURE Tfrm_ChxDesBases.Sb_UpClick(Sender: TObject);
VAR
    I: Integer;
BEGIN
    i := Lb_Bases.ItemIndex;
    IF I > 0 THEN
    BEGIN
        Lb_Bases.items.Exchange(i, i - 1);
        Lb_Bases.ItemIndex := i - 1;
    END;
END;

PROCEDURE Tfrm_ChxDesBases.SB_DownClick(Sender: TObject);
VAR
    i: integer;
BEGIN
    i := Lb_Bases.ItemIndex;
    IF I < Lb_Bases.Items.Count - 1 THEN
    BEGIN
        Lb_Bases.items.Exchange(i, i + 1);
        Lb_Bases.ItemIndex := i + 1;
    END;
END;

PROCEDURE Tfrm_ChxDesBases.OKBtnClick(Sender: TObject);
VAR
    reg: TRegistry;
    S: STRING;
    j: integer;
    ii: integer;
    i: integer;
    S1: STRING;
    tsl: tstringList;
    S2: STRING;
BEGIN
    reg := TRegistry.Create;
    TRY
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Algol\Ginkoia', True);
        i := 0;
        REPEAT
            S := reg.ReadString('EAI' + Inttostr(i));
            IF s <> '' THEN
                reg.DeleteValue('EAI' + Inttostr(i));
            inc(i);
        UNTIL s = '';
        i := 0;
        REPEAT
            S := reg.ReadString('Base' + Inttostr(i));
            IF s <> '' THEN
                reg.DeleteValue('Base' + Inttostr(i));
            inc(i);
        UNTIL s = '';

        j := 0;
        FOR i := 0 TO Lb_Bases.Items.Count - 1 DO
        BEGIN
            S := Lb_Bases.Items[i];
            IF fileexists(S + 'DelosQPMAgent.DataSources.xml') THEN
                S2 := S + 'DelosQPMAgent.DataSources.xml'
            ELSE
                S2 := S + 'Delos_QPMAgent.DataSources.xml';
            tsl := tstringList.Create;
            TRY
                tsl.LoadFromFile(S2);
                S1 := Uppercase(trim(tsl.Text));
                ii := Pos('<NAME>SERVER NAME</NAME>', S1);
                IF ii > 0 THEN
                BEGIN
                    ii := iI + length('<NAME>SERVER NAME</NAME>') - 1;
                    delete(S1, 1, ii);
                    S1 := trim(S1);
                    iI := Pos('<VALUE>', S1);
                    IF iI > 0 THEN
                    BEGIN
                        iI := iI + Length('<VALUE>') - 1;
                        delete(S1, 1, ii);
                        iI := Pos('<', S1) - 1;
                        IF iI > 0 THEN
                        BEGIN
                            S1 := Copy(S1, 1, ii);
                            IF fileexists(S1) THEN
                            BEGIN
                                reg.WriteString('Base' + Inttostr(j), S1);
                                reg.WriteString('EAI' + Inttostr(j), S);
                                Inc(j);
                            END;
                        END;
                    END;
                END;
            EXCEPT
            END;
            tsl.free;
        END;
    FINALLY
        reg.free;
    END;
END;

END.

