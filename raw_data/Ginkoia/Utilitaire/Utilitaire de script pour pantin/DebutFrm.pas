//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT DebutFrm;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls,
    Forms, Dialogs, AlgolStdFrm, RXSplit, ExtCtrls, StdCtrls, CheckLst,
    Menus, IB_Components, IB_Process, IB_Script;

TYPE
    Tfrm_Debut = CLASS(TAlgolStdFrm)
        Panel1: TPanel;
        Panel2: TPanel;
        RxSplitter1: TRxSplitter;
        CL: TCheckListBox;
        Panel3: TPanel;
        Button1: TButton;
        Panel4: TPanel;
        Button2: TButton;
        Button3: TButton;
        Memo1: TMemo;
        Button4: TButton;
        pop: TPopupMenu;
        Loadfromfile1: TMenuItem;
        Vider1: TMenuItem;
        OD: TOpenDialog;
        Connect: TIB_Connection;
        script: TIB_Script;
        IB_Transaction1: TIB_Transaction;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    Loadfromfile2: TMenuItem;
    Vider2: TMenuItem;
    N1: TMenuItem;
    Quiter1: TMenuItem;
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE AlgolStdFrmClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE Vider1Click(Sender: TObject);
        PROCEDURE Loadfromfile1Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE Button4Click(Sender: TObject);
    procedure Quiter1Click(Sender: TObject);
    PRIVATE
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;

VAR
    frm_Debut       : Tfrm_Debut;

IMPLEMENTATION
{$R *.DFM}

PROCEDURE Tfrm_Debut.Button1Click(Sender: TObject);
    PROCEDURE recherche(Path: STRING);
    VAR
        f           : TSearchRec;
    BEGIN
        IF findFirst(Path + '\*.*', faDirectory, F) = 0 THEN
        BEGIN
            REPEAT
                IF NOT ((f.name = '.') OR (f.name = '..')) THEN
                BEGIN
                    IF F.Attr AND faDirectory = faDirectory THEN
                        recherche(Path + '\' + F.Name)
                END;
            UNTIL Findnext(f) <> 0;
        END;
        findclose(f);

        Panel3.Caption := Path + '       ';
        Panel3.Update;

        IF findFirst(Path + '\*.GDB', FaAnyFile, F) = 0 THEN
        BEGIN
            REPEAT
                IF NOT ((f.name = '.') OR (f.name = '..')) THEN
                BEGIN
                    IF F.Attr AND faDirectory = faDirectory THEN
                        recherche(Path + '\' + F.Name)
                    ELSE IF Uppercase(extractfileext(F.Name)) = '.GDB' THEN
                        Cl.Items.Add(Path + '\' + F.Name);
                END;
            UNTIL Findnext(f) <> 0;
        END;
        findclose(f);

    END;

BEGIN
    Cl.Items.Clear;
    recherche(Copy(Application.exename,1,2));
END;

PROCEDURE Tfrm_Debut.AlgolStdFrmClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    Cl.Items.SaveToFile(changefileext(Application.exename, '.lst'));
END;

PROCEDURE Tfrm_Debut.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        Cl.Items.LoadFromFile(changefileext(Application.exename, '.lst'));
    EXCEPT
    END;
END;

PROCEDURE Tfrm_Debut.Vider1Click(Sender: TObject);
BEGIN
    memo1.clear;
END;

PROCEDURE Tfrm_Debut.Loadfromfile1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        memo1.lines.loadfromfile(od.filename);
END;

PROCEDURE Tfrm_Debut.Button2Click(Sender: TObject);
VAR
    i               : integer;
BEGIN
    FOR i := 0 TO cl.items.count-1 DO
        cl.Checked[i] := true;
END;

PROCEDURE Tfrm_Debut.Button3Click(Sender: TObject);
VAR
    i               : integer;
BEGIN
    FOR i := 0 TO cl.items.count-1 DO
        cl.Checked[i] := false;
END;

PROCEDURE Tfrm_Debut.Button4Click(Sender: TObject);
VAR
    i               : integer;
BEGIN
    screen.cursor := crHourGlass;
    TRY
        FOR i := 0 TO cl.items.count-1 DO
        BEGIN
            IF cl.Checked[i] THEN
            BEGIN
                Connect.Connected := false;
                Connect.Databasename := cl.items[i];
                Connect.Connected := true;
                script.sql.text := memo1.text;
                script.Execute;
                Connect.Connected := false;
            END;
        END;
    FINALLY
        screen.cursor := crdefault;
    END;
END;

procedure Tfrm_Debut.Quiter1Click(Sender: TObject);
begin
  close ;
end;

END.

