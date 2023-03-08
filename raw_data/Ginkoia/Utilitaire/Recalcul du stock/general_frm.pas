UNIT general_frm;

INTERFACE

USES
    registry,
    inifiles,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, Db, IBCustomDataSet, IBQuery, IBDatabase, ComCtrls;

TYPE
    TFrm_General = CLASS(TForm)
        Edit1: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        Edit2: TEdit;
        Button1: TButton;
        Data: TIBDatabase;
        Tran: TIBTransaction;
        IBQue_Magasin: TIBQuery;
        IBQue_MagasinMAG_ID: TIntegerField;
        IBQue_RecupAgr: TIBQuery;
        IBQue_RecupAgrSTC_ID: TIntegerField;
        IBQue_RecupAgrSTC_ARTID: TIntegerField;
        IBQue_RecupAgrSTC_MAGID: TIntegerField;
        IBQue_RecupAgrSTC_TGFID: TIntegerField;
        IBQue_RecupAgrSTC_COUID: TIntegerField;
        IBQue_RecupAgrSTC_QTE: TFloatField;
        IBQue_Nbr: TIBQuery;
        IBQue_NbrNB: TIntegerField;
        Bar: TProgressBar;
        IBQue_RecupK: TIBQuery;
        IBQue_RecupKK_ID: TIntegerField;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
    PRIVATE
        { Déclarations privées }
    PUBLIC
        { Déclarations publiques }
        Pathexe: STRING;
        PathBase: STRING;
        MagId: Integer;
    END;

VAR
    Frm_General: TFrm_General;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_General.FormCreate(Sender: TObject);
VAR
    reg: TRegistry;
    ini: tinifile;
    MagNom: STRING;
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
        PathBase := ini.readString('DATABASE', 'PATH0', '');
        MagNom := ini.readString('NOMMAGS', 'MAG0', '');
        IF Copy(PathBase, 2, 1) <> ':' THEN
        BEGIN
            PathBase := ini.readString('DATABASE', 'PATH1', '');
            MagNom := ini.readString('NOMMAGS', 'MAG1', '');
        END;
        IF Copy(PathBase, 2, 1) <> ':' THEN
        BEGIN
            PathBase := ini.readString('DATABASE', 'PATH2', '');
            MagNom := ini.readString('NOMMAGS', 'MAG2', '');
        END;
        IF Copy(PathBase, 2, 1) <> ':' THEN
        BEGIN
            PathBase := ini.readString('DATABASE', 'PATH3', '');
            MagNom := ini.readString('NOMMAGS', 'MAG3', '');
        END;
    FINALLY
        ini.free;
    END;
    data.databasename := PathBase;
    edit1.text := PathBase;
    IBQue_Magasin.paramByName('MAGNOM').AsString := MagNom;
    edit2.text := MagNom;
    IBQue_Magasin.Open;
    MagId := IBQue_MagasinMag_Id.AsInteger;

END;

PROCEDURE TFrm_General.Button1Click(Sender: TObject);
VAR
    f: textfile;
    i: integer;
    j: integer;
    S: STRING;
BEGIN
    DecimalSeparator := '.';
    IBQue_Nbr.paramByName('MAGID').AsInteger := MagId;
    IBQue_Nbr.Open;
    Bar.Min := 0;
    Bar.Position := 0;
    Bar.Max := IBQue_NbrNb.AsInteger;
    IBQue_Nbr.Close;
    AssignFile(F, Pathexe + 'AGRCOUR.SQL');
    rewrite(f);
    IBQue_RecupAgr.paramByName('MAGID').AsInteger := MagId;
    IBQue_RecupAgr.Open;
    Writeln(f, 'DELETE FROM AGRSTOCKCOUR WHERE STC_MAGID = ' + Inttostr(MAGID) + ' ;');
    Writeln(f, 'COMMIT ;');
    i := 0;
    WHILE NOT IBQue_RecupAgr.eof DO
    BEGIN
        Bar.Position := Bar.Position + 1;
        Writeln(f, 'INSERT INTO AGRSTOCKCOUR (STC_ID, STC_ARTID, STC_MAGID,STC_TGFID, STC_COUID ,STC_QTE)');
        Writeln(f, 'VALUES (' + IBQue_RecupAgrSTC_ID.ASSTRING + ',' +
            IBQue_RecupAgrSTC_ARTID.ASSTRING + ',' +
            IBQue_RecupAgrSTC_MAGID.ASSTRING + ',' +
            IBQue_RecupAgrSTC_TGFID.ASSTRING + ',' +
            IBQue_RecupAgrSTC_COUID.ASSTRING + ',' +
            IBQue_RecupAgrSTC_QTE.ASSTRING + ') ;');
        inc(i);
        IF i > 99 THEN
        BEGIN
            Writeln(f, 'COMMIT ;');
            i := 0;
        END;
        IBQue_RecupAgr.next;
    END;
    Writeln(f, 'COMMIT ;');

    IBQue_RecupK.Open;
    S := ''; i := 0; J := 0;
    WHILE NOT IBQue_RecupK.EOF DO
    BEGIN
        Inc(i);
        IF I > 30 THEN
        BEGIN
            S := S + IBQue_RecupKK_ID.AsString;
            Writeln(F, 'UPDATE K SET K_ENABLED=0 WHERE K_ID IN (' + S + ') ; ');
            S := '';
            I := 0;
            inc(j);
            IF j > 99 THEN
            BEGIN
                Writeln(f, 'COMMIT ;');
                J := 0;
            END;
        END
        ELSE
            S := S + IBQue_RecupKK_ID.AsString + ', ';
        IBQue_RecupK.Next;
    END;
    IF length(S)>0 then
    Begin
      delete(S,length(S)-1,2) ;
      Writeln(F, 'UPDATE K SET K_ENABLED=0 WHERE K_ID IN (' + S + ') ; ');
      Writeln(f, 'COMMIT ;');
    END ;

    Closefile(f);
    application.messagebox('c''est fini', '  fin', mb_ok)
END;

END.

