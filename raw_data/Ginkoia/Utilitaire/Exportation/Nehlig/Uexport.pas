UNIT Uexport;

INTERFACE

USES
    registry,
    inifiles,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    IBDatabase, Db, StdCtrls, IBCustomDataSet, IBQuery, ComCtrls;

TYPE
    TForm1 = CLASS(TForm)
        Button1: TButton;
        Button2: TButton;
        data: TIBDatabase;
        tran: TIBTransaction;
        ib_reference: TIBQuery;
        ib_referenceARF_ID: TIntegerField;
        ib_referenceARF_CHRONO: TIBStringField;
        Ib_couleur: TIBQuery;
        Ib_couleurCBI_CB: TIBStringField;
        Ib_couleurCOU_NOM: TIBStringField;
        Ib_couleurTGF_NOM: TIBStringField;
        Prog: TProgressBar;
        Ib_Nombre: TIBQuery;
        Ib_NombreNB: TIntegerField;
        lab: TLabel;
        Ib_Export: TIBQuery;
        Ib_ExportNBR: TIntegerField;
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
    PRIVATE
        PROCEDURE traite;
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        f: textfile;
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TForm1.traite;
BEGIN
    IF ib_couleur.isempty THEN
    BEGIN
        Writeln(F, '"' + ib_referenceARF_CHRONO.AsString + '","","","Pas de code barre"');
    END
    ELSE
    BEGIN
        Writeln(F, '"' + ib_referenceARF_CHRONO.AsString + '","' +
            Ib_couleurCOU_NOM.AsString + '","' +
            Ib_couleurTGF_NOM.AsString + '","' +
            Ib_couleurCBI_CB.AsString + '"');
    END;
END;

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    i: integer;
BEGIN
    Screen.Cursor := CrHourGlass;
    TRY
        AssignFile(f, 'C:\CODEBARRE.CSV');
        rewrite(f);
        Writeln(f, 'CHRONO,COULEUR,TAILLE,CODEBARRE');
        Ib_reference.Open;
        Prog.position := 0;
        Prog.Min := 0;
        Prog.Max := 99;
        FOR i := 0 TO 99 DO
        BEGIN
            Lab.Caption := Inttostr(i + 1) + '/' + Inttostr(100);
            lab.update;
            Prog.position := i;
            Prog.Update;
            ib_couleur.parambyname('arfid').asinteger := ib_referenceARF_ID.Asinteger;
            ib_couleur.Open;
            REPEAT
                traite;
                ib_couleur.next;
            UNTIL ib_couleur.Eof;
            ib_couleur.close;
            Ib_reference.next;
        END;
        Prog.position := prog.max;
        Ib_reference.close;
        Closefile(f);
    FINALLY
        Screen.Cursor := CrDefault;
    END;
END;

PROCEDURE TForm1.Button2Click(Sender: TObject);
VAR
    Max: Integer;
    i: integer;
BEGIN
    Ib_Export.open;
    IF Ib_ExportNBR.AsInteger < 1 THEN
        application.messageBox('Fonction non initialisée', 'Impossible d''exporter', mb_ok)
    ELSE
    BEGIN
        Screen.Cursor := CrHourGlass;
        TRY
            AssignFile(f, 'C:\CODEBARRE.CSV');
            rewrite(f);
            Writeln(f, 'CHRONO,COULEUR,TAILLE,CODEBARRE');
            Ib_reference.Open;
            Prog.position := 0;
            Prog.Min := 0;
            Ib_Nombre.Open;
            Max := Ib_NombreNB.Asinteger;
            Prog.Max := Ib_NombreNB.Asinteger;
            Ib_Nombre.Close;
            i := 0;
            WHILE NOT Ib_reference.Eof DO
            BEGIN
                inc(i);
                Lab.Caption := Inttostr(i) + '/' + Inttostr(Max);
                lab.update;
                Prog.position := Prog.position + 1;
                Prog.Update;
                ib_couleur.parambyname('arfid').asinteger := ib_referenceARF_ID.Asinteger;
                ib_couleur.Open;
                REPEAT
                    traite;
                    ib_couleur.next;
                UNTIL ib_couleur.Eof;
                ib_couleur.close;
                Ib_reference.next;
            END;
            Prog.position := prog.max;
            Lab.Caption := Inttostr(max) + '/' + Inttostr(Max);
            Ib_reference.close;
            Closefile(f);
        FINALLY
            Screen.Cursor := CrDefault;
        END;
    END;
END;

PROCEDURE TForm1.FormCreate(Sender: TObject);
VAR
    reg: TRegistry;
    PathDataBase: STRING;
    Pathexe: STRING;
    ini: tinifile;
BEGIN
    reg := TRegistry.Create;
    reg.access := Key_Read;
    Reg.RootKey := HKEY_CURRENT_USER;
    Pathexe := '';
    IF Reg.OpenKey('\Software\Agol\Ginkoia\Current Version', False) THEN
        Pathexe := Reg.readString('Path');
    reg.free;

    Pathexe := ExtractFilePath(Pathexe);
    IF Pathexe[length(Pathexe)] <> '\' THEN
        Pathexe := Pathexe + '\';

    ini := tinifile.create(Pathexe + 'Ginkoia.Ini');
    TRY
        PathDataBase := ini.readString('DATABASE', 'PATH0', '');
        IF Copy(PathDataBase, 2, 1) <> ':' THEN
            PathDataBase := ini.readString('DATABASE', 'PATH1', '');
        IF Copy(PathDataBase, 2, 1) <> ':' THEN
            PathDataBase := ini.readString('DATABASE', 'PATH2', '');
        IF Copy(PathDataBase, 2, 1) <> ':' THEN
            PathDataBase := ini.readString('DATABASE', 'PATH3', '');
    FINALLY
        ini.free;
    END;
    data.databasename := PathDataBase;
END;

END.

// à Ajouter dans la base

{
INSERT INTO K
  (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)
VALUES
  (gen_id(general_id,1),-101,-11111338,gen_id(general_id,0),1,-1,-1,Current_Date,0,'12/30/1899',-1,Current_Date,0,0);


INSERT INTO GenDossier
  (DOS_ID,DOS_NOM,DOS_STRING,DOS_FLOAT)
VALUES
  (gen_id(general_id,0),'NEHLIG','NEHLIG',1);
}

