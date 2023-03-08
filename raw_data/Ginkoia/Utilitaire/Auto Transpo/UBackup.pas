UNIT UBackup;

INTERFACE

USES
    registry,
    inifiles,
    FileUtil,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Buttons, StdCtrls, IBSQL, Db, IBCustomDataSet, IBQuery, IBDatabase,
    DBCtrls, ComCtrls, dxmdaset, Menus;

TYPE
    TForm1 = CLASS(TForm)
        OD: TOpenDialog;
        SD: TSaveDialog;
        Od2: TOpenDialog;
        SD2: TSaveDialog;
        Data: TIBDatabase;
        Tran: TIBTransaction;
        IBQue_Dossier: TIBQuery;
        IBQue_DossierDOS_ID: TIntegerField;
        IBQue_DossierDOS_NOM: TIBStringField;
        IBQue_DossierDOS_STRING: TIBStringField;
        IBQue_DossierDOS_FLOAT: TFloatField;
        IBSql_Insert: TIBSQL;
        IBQue_NewKey: TIBQuery;
        IBQue_NewKeyNEWKEY: TIntegerField;
        IBQue_Univers: TIBQuery;
        IBQue_UniversUNI_ID: TIntegerField;
        IBQue_UniversUNI_IDREF: TIntegerField;
        IBQue_UniversUNI_NOM: TIBStringField;
        IBQue_UniversUNI_NIVEAU: TIntegerField;
        IBQue_UniversUNI_ORIGINE: TIntegerField;
        IBQue_Sites: TIBQuery;
        IBQue_SitesBAS_ID: TIntegerField;
        IBQue_SitesBAS_NOM: TIBStringField;
        IBQue_SitesBAS_IDENT: TIBStringField;
        IBQue_SitesBAS_JETON: TIntegerField;
        IBQue_SitesBAS_PLAGE: TIBStringField;
        IBQue_TrouveSite: TIBQuery;
        IntegerField1: TIntegerField;
        IBStringField1: TIBStringField;
        IBStringField2: TIBStringField;
        IntegerField2: TIntegerField;
        IBStringField3: TIBStringField;
        IBQue_ModifParam: TIBQuery;
        IBQue_Generateur: TIBQuery;
        IBQue_Script: TIBQuery;
        IBQue_Champs: TIBQuery;
        OD3: TOpenDialog;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        Label13: TLabel;
        Edt_ChxBack: TEdit;
        SpeedButton8: TSpeedButton;
        CB_VidRep: TCheckBox;
        CB_RecopImport: TCheckBox;
        Button6: TButton;
        Button7: TButton;
        Cb_LancImport: TCheckBox;
        TabSheet2: TTabSheet;
        Label14: TLabel;
        Label3: TLabel;
        Edit3: TEdit;
        SpeedButton3: TSpeedButton;
        Label4: TLabel;
        Edit4: TEdit;
        SpeedButton4: TSpeedButton;
        Label5: TLabel;
        Edit5: TEdit;
        SpeedButton5: TSpeedButton;
        Button2: TButton;
        TabSheet3: TTabSheet;
        Button4: TButton;
        mem_site: TMemo;
        Label8: TLabel;
        Label7: TLabel;
        Cb_Univers: TComboBox;
        Button3: TButton;
        SpeedButton6: TSpeedButton;
        Edit6: TEdit;
        Label6: TLabel;
        Button8: TButton;
        TabSheet4: TTabSheet;
        Label9: TLabel;
        Label10: TLabel;
        SpeedButton7: TSpeedButton;
        Label11: TLabel;
        Label12: TLabel;
        Button5: TButton;
        Ed_EAI: TEdit;
        RB3: TRadioButton;
        RB2: TRadioButton;
        Ed_EAIBin: TEdit;
        Edit8: TEdit;
        Pb: TProgressBar;
        Edit7: TEdit;
        Label15: TLabel;
        SpeedButton9: TSpeedButton;
        TabSheet5: TTabSheet;
        Label1: TLabel;
        Label2: TLabel;
        Edit1: TEdit;
        Edit2: TEdit;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        Button1: TButton;
        TabSheet6: TTabSheet;
        Label16: TLabel;
        Ed_BaseCtrl: TEdit;
        SpeedButton10: TSpeedButton;
        Button9: TButton;
        Lab_EtatCtrl: TLabel;
        mem: TdxMemData;
        memChrono: TStringField;
        memstock: TIntegerField;
        memRAL: TIntegerField;
        IBSQL1: TIBSQL;
        pbctrl: TProgressBar;
        Label17: TLabel;
        Ed_RepTranspo: TEdit;
        SpeedButton11: TSpeedButton;
        MainMenu1: TMainMenu;
        Fichier1: TMenuItem;
        N1: TMenuItem;
        Quitter1: TMenuItem;
        Paramtrage1: TMenuItem;
        Od4: TOpenDialog;
        Label18: TLabel;
        ProgressBar1: TProgressBar;
    RB1: TRadioButton;
    IBQue_GenerateurNAME: TIBStringField;
    IBQue_ChampsCHAMPS: TIBStringField;
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE SpeedButton2Click(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE SpeedButton3Click(Sender: TObject);
        PROCEDURE SpeedButton4Click(Sender: TObject);
        PROCEDURE SpeedButton5Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE SpeedButton6Click(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE Cb_UniversChange(Sender: TObject);
        PROCEDURE Button4Click(Sender: TObject);
        PROCEDURE Button5Click(Sender: TObject);
        PROCEDURE SpeedButton7Click(Sender: TObject);
        PROCEDURE SpeedButton8Click(Sender: TObject);
        PROCEDURE Button6Click(Sender: TObject);
        PROCEDURE Button7Click(Sender: TObject);
        PROCEDURE Button8Click(Sender: TObject);
        PROCEDURE SpeedButton10Click(Sender: TObject);
        PROCEDURE Button9Click(Sender: TObject);
        PROCEDURE Quitter1Click(Sender: TObject);
        PROCEDURE SpeedButton11Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Paramtrage1Click(Sender: TObject);
        PROCEDURE Ed_EAIBinExit(Sender: TObject);
        PROCEDURE Ed_RepTranspoExit(Sender: TObject);
    PRIVATE
    { Déclarations privées }
        FUNCTION NewId: STRING;
        PROCEDURE BaseInit;
        PROCEDURE VerifDossier(Nom, Valeur, Nombre: STRING);
        PROCEDURE ChangeDossier(Nom, Valeur, Nombre: STRING);
        FUNCTION insertK(KTB_ID: STRING): STRING;
        PROCEDURE commit;
        PROCEDURE Copier(Source, Dest: STRING);
        PROCEDURE decodeplage(S: STRING; VAR Deb, fin: integer);
        PROCEDURE Recup_Generateur(Plage_pantin, Plage_Magasin: STRING; NumMagasin: Integer; Path, Nom: STRING);
        FUNCTION Restoration(Backup, Fichier: STRING): Boolean;
    PUBLIC
    { Déclarations publiques }
        CheminTranspo: STRING;
        CheminBasesVide: STRING;
        CheminBackup: STRING;
        DerniereBase: STRING;
        CheminImport: STRING;
        CheminParam: STRING;
        CheminEAI: STRING;
        IPHUSKY: STRING;
        LastEAI: STRING;
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION
{$R *.DFM}
USES
    Param_Frm;

CONST
    k_Dossier = '-11111338';
    K_Base = '-11111334';

FUNCTION PlaceDeInterbase: STRING;
VAR
    Reg: Tregistry;
BEGIN
    reg := Tregistry.Create;
    TRY
        reg.Access := KEY_READ;
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
        result := Reg.ReadString('ServerDirectory');
    FINALLY
        reg.free;
    END;
END;

PROCEDURE TForm1.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        edit1.text := od.filename;
END;

PROCEDURE TForm1.SpeedButton2Click(Sender: TObject);
BEGIN
    IF sd.execute THEN
        edit2.text := sd.filename;
END;

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    tsl: tstringList;
    i: integer;
    result: boolean;
    debut: TDateTime;
BEGIN
    Screen.cursor := crHourGlass;
    TRY
        TRY
            tsl := tstringList.create;
            TRY
                deletefile('C:\un.txt');
                deletefile('C:\trois.txt');

                tsl.Add('"' + PlaceDeInterbase + 'gbak.exe " "' + edit1.text + '" "' + edit2.text +
                    '" -user sysdba -password masterkey -C -K -BU 4096 -P 4096 -Y "C:\un.txt"'
                    );
                tsl.Add('Copy "C:\un.txt" "C:\trois.txt"');
                tsl.Add('exit');
                tsl.savetofile('C:\Go.Bat');
                IF Winexec(Pchar('c:\GO.BAT'), 0) <= 31 THEN
                BEGIN
                    result := false;
                    exit;
                END;
                FOR i := 1 TO 25 DO
                BEGIN
                    application.processmessages;
                    sleep(100);
                END;
                debut := now;
                WHILE NOT fileexists('C:\trois.txt') DO
                BEGIN
                    IF Now - debut > 0.1 THEN
                    BEGIN
                        result := False;
                        Exit;
                    END;
                    application.processmessages;
                    sleep(1000);
                END;
                FOR i := 1 TO 25 DO
                BEGIN
                    application.processmessages;
                    sleep(100);
                END;
                tsl.loadfromfile('C:\trois.txt');
                IF tsl.count > 1 THEN
                    result := false
                ELSE
                    result := true;
            FINALLY
                tsl.free;
            END;
        EXCEPT
            result := false;
        END;
    FINALLY
        Screen.cursor := crDefault;
    END;
    IF NOT result THEN
    BEGIN
        application.MessageBox('Problème dans le restore', 'Problème', Mb_Ok);
    END
    ELSE
    BEGIN
        application.MessageBox('Restoration Réussie', 'Tous va bien', Mb_Ok);
    END;
END;

PROCEDURE TForm1.SpeedButton3Click(Sender: TObject);
BEGIN
    IF od2.execute THEN
        edit3.text := od2.filename;
END;

PROCEDURE TForm1.SpeedButton4Click(Sender: TObject);
BEGIN
    IF sd2.execute THEN
        edit4.text := sd2.filename;
END;

PROCEDURE TForm1.SpeedButton5Click(Sender: TObject);
BEGIN
    IF sd.execute THEN
        edit5.text := sd.filename;
END;

PROCEDURE TForm1.Button2Click(Sender: TObject);
VAR
    tsl: tstringList;
    i: integer;
    result: boolean;
    debut: TDateTime;
    inv: boolean;

    PROCEDURE increment;
    BEGIN
        IF inv THEN
        BEGIN
            ProgressBar1.Position := ProgressBar1.Position - 1;
            IF ProgressBar1.Position = ProgressBar1.Min THEN
                inv := False;
        END
        ELSE
        BEGIN
            ProgressBar1.Position := ProgressBar1.Position + 1;
            IF ProgressBar1.Position = ProgressBar1.Max THEN
                inv := true;
        END;
    END;

BEGIN
    Enabled := False;
    Caption := 'Backup en cours';
    Label18.Caption := 'Ne toucher à rien';
    Label18.Update;
    TRY
        tsl := tstringlist.Create;
        TRY
            deletefile('c:\deux.txt');
            deletefile('c:\un.txt');
            deletefile('c:\trois.txt');
            Deletefile(Edit4.Text);
            tsl.add('"' + PlaceDeInterbase + 'gbak.exe " "' + edit3.text + '" "' + edit4.text + '" -user sysdba -password masterkey -B -L -NT -Y "C:\un.txt"');
            tsl.add('Copy "C:\un.txt" "C:\trois.txt"');
            tsl.add('exit');
            tsl.SaveToFile('C:\GO.BAT');
            IF Winexec(Pchar('C:\GO.BAT'), 0) <= 31 THEN
            BEGIN
                result := false;
                exit;
            END;
            FOR i := 1 TO 30 DO
            BEGIN
                application.processmessages;
                sleep(100);
            END;
            debut := Now;
            WHILE NOT fileexists('c:\trois.txt') DO
            BEGIN
                application.processmessages;
                sleep(1000);
                increment;
                IF Now - debut > 0.1 THEN
                BEGIN
                    result := False;
                    Exit;
                END;
            END;

            FOR i := 1 TO 25 DO
            BEGIN
                application.processmessages;
                sleep(100);
            END;

            tsl.loadfromfile('c:\trois.txt');
            IF tsl.count > 1 THEN
            BEGIN
                result := false;
            END
            ELSE
            BEGIN
                result := true;
            END;

        FINALLY
            tsl.free;
        END;
    EXCEPT
        result := false;
    END;
    IF NOT result THEN
    BEGIN
        Enabled := true;
        application.MessageBox('Problème dans le backup', 'Problème', Mb_Ok AND MB_ICONASTERISK);
        EXIT;
    END;
    Caption := 'restore en cours';
    TRY
        TRY
            tsl := tstringList.create;
            TRY
                deletefile('C:\un.txt');
                deletefile('C:\trois.txt');
                Deletefile(Edit5.Text);
                renamefile(Edit3.Text, Edit5.text);

                tsl.Add('"' + PlaceDeInterbase + 'gbak.exe " "' + edit4.text + '" "' + edit3.text +
                    '" -user sysdba -password masterkey -C -BU 4096 -P 4096 -Y "C:\un.txt"'
                    );
                tsl.Add('Copy "C:\un.txt" "C:\trois.txt"');
                tsl.Add('exit');
                tsl.savetofile('C:\Go.Bat');
                IF Winexec(Pchar('c:\GO.BAT'), 0) <= 31 THEN
                BEGIN
                    result := false;
                    exit;
                END;
                FOR i := 1 TO 25 DO
                BEGIN
                    application.processmessages;
                    sleep(100);
                END;
                debut := now;
                WHILE NOT fileexists('C:\trois.txt') DO
                BEGIN
                    IF Now - debut > 0.1 THEN
                    BEGIN
                        result := False;
                        Exit;
                    END;
                    application.processmessages;
                    increment;
                    sleep(1000);
                END;
                FOR i := 1 TO 25 DO
                BEGIN
                    application.processmessages;
                    sleep(100);
                END;
                tsl.loadfromfile('C:\trois.txt');
                IF tsl.count > 1 THEN
                    result := false
                ELSE
                    result := true;
            FINALLY
                tsl.free;
            END;
        EXCEPT
            result := false;
        END;
    FINALLY
        Enabled := True;
        Screen.cursor := crDefault;
    END;
    IF NOT result THEN
    BEGIN
        application.MessageBox('Problème dans le restore', 'Problème', Mb_Ok AND MB_ICONASTERISK);
    END
    ELSE
    BEGIN
        application.MessageBox('Backup/Restore Réussie', 'Tous va bien', Mb_Ok AND MB_ICONASTERISK);
    END;
END;

FUNCTION TForm1.NewId: STRING;
BEGIN
    IBQue_NewKey.Prepare;
    IBQue_NewKey.Open;
    result := Inttostr(IBQue_NewKeyNEWKEY.AsInteger);
    IBQue_NewKey.Close;
    IBQue_NewKey.UnPrepare;
END;

PROCEDURE TForm1.BaseInit;
BEGIN
    VerifDossier('MONNAIE_REFERENCE', 'EUR', '0');
    VerifDossier('MONNAIE_CIBLE', 'FRF', '0');
    VerifDossier('MONNAIE_TRAVAIL', '0', '0');
    VerifDossier('HISTO_DUREE', '6', '0');
    VerifDossier('OFFSET', '30', '0');
    VerifDossier('TVA', '', '19.6');
    VerifDossier('ETIQ_TAILLEFOUR', '0', '0');
    VerifDossier('ETIQ_MAJ', '0', '0');
    VerifDossier('ETIQ_PXMIN', '1', '0');
    VerifDossier('ETIQ_PXVTE', '1', '0');
    VerifDossier('REPLICATION', 'OUI', '1');
END;

PROCEDURE TForm1.VerifDossier(Nom, Valeur, Nombre: STRING);
VAR
    id: STRING;
BEGIN
    IBQue_Dossier.ParamByName('Nom').AsString := Nom;
    IBQue_Dossier.Open;
    IF IBQue_Dossier.IsEmpty THEN
    BEGIN
        id := insertK(k_Dossier);
        WITH IBSql_Insert.Sql DO
        BEGIN
            clear;
            Add('INSERT INTO GENDOSSIER');
            Add('  (DOS_ID,DOS_NOM,DOS_STRING,DOS_FLOAT)');
            Add('VALUES');
            Add('  (' + id + ',''' + NOM + ''',''' + Valeur + ''',' + Nombre + ');');
        END;
        IBSql_Insert.ExecQuery;
        Commit;
    END;
    IBQue_Dossier.Close;
END;

FUNCTION TForm1.insertK(KTB_ID: STRING): STRING;
VAR
    id: STRING;
BEGIN
    id := NewId;
    WITH IBSql_Insert.Sql DO
    BEGIN
        clear;
        add('INSERT INTO K');
        add('  (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
        add('VALUES');
        Add('(' + id + ',-101,' + KTB_ID + ',' + id + ',1,-1,-1,Current_timestamp,0,''12/30/1899'',-1,Current_timestamp,0,0);');
    END;
    IBSql_Insert.ExecQuery;
    Commit;
    result := id;
END;

PROCEDURE TForm1.SpeedButton6Click(Sender: TObject);
BEGIN
    IF od2.execute THEN
        edit6.text := od2.filename;
END;

PROCEDURE TForm1.Button3Click(Sender: TObject);
VAR
    i: integer;
BEGIN
    data.close;
    data.DatabaseName := edit6.text;
    data.Open;
    tran.Active := true;
    BaseInit;
    IBQue_Univers.Open;
    VerifDossier('UNIVERS_REF', IBQue_UniversUNI_NOM.AsString, '0');
    Cb_Univers.Items.clear;
    WHILE NOT IBQue_Univers.Eof DO
    BEGIN
        Cb_Univers.Items.Add(IBQue_UniversUNI_NOM.AsString);
        IBQue_Univers.Next;
    END;
    IBQue_Univers.Close;
    IBQue_Dossier.ParamByName('Nom').AsString := 'UNIVERS_REF';
    IBQue_Dossier.Open;
    i := Cb_Univers.Items.IndexOf(IBQue_DossierDOS_STRING.AsString);
    Cb_Univers.ItemIndex := I;
    IBQue_Dossier.Close;
    mem_site.Lines.clear;
    IBQue_Sites.Open;
    WHILE NOT IBQue_Sites.Eof DO
    BEGIN
        mem_site.Lines.Add(IBQue_SitesBAS_NOM.AsString + ';' + IBQue_SitesBAS_IDENT.AsString + ';' + IBQue_SitesBAS_JETON.AsString + ';' + IBQue_SitesBAS_PLAGE.AsString);
        IBQue_Sites.Next;
    END;
    IBQue_Sites.Close;
END;

PROCEDURE TForm1.Cb_UniversChange(Sender: TObject);
BEGIN
    ChangeDossier('UNIVERS_REF', IBQue_UniversUNI_NOM.AsString, '0');
END;

PROCEDURE TForm1.ChangeDossier(Nom, Valeur, Nombre: STRING);
BEGIN
    IBQue_Dossier.ParamByName('Nom').AsString := NOM;
    IBQue_Dossier.Open;

    WITH IBSql_Insert.Sql DO
    BEGIN
        clear;
        add('UPDATE K');
        add('  SET K_VERSION=GEN_ID(GENERAL_ID,1)');
        add('WHERE K_ID=' + IBQue_DossierDOS_ID.asstring + ';');
        add('UPDATE GENDOSSIER');
        add('SET DOS_STRING=''' + VALEUR + ''', DOS_FLOAT = ' + Nombre);
        add('WHERE DOS_ID=' + IBQue_DossierDOS_ID.asstring + ';');
    END;
    IBSql_Insert.ExecQuery;
    Commit;
    IBQue_Dossier.Close;
END;

PROCEDURE TForm1.Button4Click(Sender: TObject);
VAR
    i: integer;
    id: STRING;
    Nom: STRING;
    Ident: STRING;
    Jeton: STRING;
    Plage: STRING;
    s: STRING;
BEGIN
    FOR i := 0 TO mem_site.lines.count - 1 DO
    BEGIN
        S := trim(mem_site.lines[i]);
        IF s <> '' THEN
        BEGIN
            IF pos(';', S) > 0 THEN
            BEGIN
                Nom := Copy(S, 1, pos(';', S) - 1);
                delete(s, 1, pos(';', s));
            END
            ELSE
            BEGIN
                nom := S;
                S := '';
            END;
            IF pos(';', S) > 0 THEN
            BEGIN
                Ident := Copy(S, 1, pos(';', S) - 1);
                delete(s, 1, pos(';', s));
            END
            ELSE
            BEGIN
                Ident := S;
                S := '';
            END;
            IF pos(';', S) > 0 THEN
            BEGIN
                Jeton := Copy(S, 1, pos(';', S) - 1);
                delete(s, 1, pos(';', s));
            END
            ELSE
            BEGIN
                Jeton := S;
                S := '';
            END;
            IF pos(';', S) > 0 THEN
            BEGIN
                Plage := Copy(S, 1, pos(';', S) - 1);
                delete(s, 1, pos(';', s));
            END
            ELSE
            BEGIN
                Plage := S;
                S := '';
            END;
            IBQue_TrouveSite.ParamByName('NOM').AsString := Nom;
            IBQue_TrouveSite.Open;
            IF IBQue_TrouveSite.IsEmpty THEN
            BEGIN
                IF Ident = '' THEN Ident := Inttostr(i);
                IF jeton = '' THEN jeton := '10';
                IF Plage = '' THEN
                BEGIN
                    IF i = 0 THEN
                        plage := '[170M_300M]'
                    ELSE IF i = 1 THEN
                        plage := '[0M_50M]'
                    ELSE IF i = 2 THEN
                        plage := '[50M_90M]'
                    ELSE IF i = 3 THEN
                        plage := '[90M_130M]'
                    ELSE IF i = 4 THEN
                        plage := '[130M_170M]'
                    ELSE
                    BEGIN
                        Plage := '[' + Inttostr((i - 5) * 40 + 300) + 'M_' + Inttostr((i - 4) * 40 + 300) + 'M]';
                    END;
                    id := insertK(K_Base);
                    WITH IBSql_Insert.Sql DO
                    BEGIN
                        clear;
                        Add('INSERT INTO GENBASES');
                        Add('  (BAS_ID,BAS_NOM,BAS_IDENT,BAS_JETON,BAS_PLAGE)');
                        Add('VALUES');
                        Add('  (' + id + ',''' + NOM + ''',''' + Ident + ''',' + Jeton + ',''' + Plage + ''');');
                    END;
                    IBSql_Insert.ExecQuery;
                    commit;
                END;
            END;
            IBQue_TrouveSite.Close;
        END;
    END;
    mem_site.Lines.clear;
    IBQue_Sites.Open;
    WHILE NOT IBQue_Sites.Eof DO
    BEGIN
        mem_site.Lines.Add(IBQue_SitesBAS_NOM.AsString + ';' + IBQue_SitesBAS_IDENT.AsString + ';' + IBQue_SitesBAS_JETON.AsString + ';' + IBQue_SitesBAS_PLAGE.AsString);
        IBQue_Sites.Next;
    END;
    IBQue_Sites.Close;
    application.MessageBox('Création terminée ', 'Tout est OK', Mb_Ok AND MB_ICONASTERISK);
END;

PROCEDURE TForm1.commit;
BEGIN
    IF tran.InTransaction THEN
        tran.commit;
    tran.Active := true;
END;

PROCEDURE TForm1.Copier(Source, Dest: STRING);
VAR
    Fs, Fd: FILE;
    Buf: ARRAY[0..65000] OF byte;
    Lut: Integer;
BEGIN
    AssignFile(Fs, Source);
    AssignFile(Fd, Dest);
    Reset(Fs, 1);
    Rewrite(fd, 1);
    Pb.Max := filesize(fs);
    Pb.Position := 0;
    REPEAT
        BlockRead(Fs, Buf, 65000, Lut);
        BlockWrite(Fd, Buf, Lut);
        Pb.Position := Pb.Position + Lut;
    UNTIL Lut < 65000;
    Closefile(fs);
    Closefile(fd);
END;

PROCEDURE TForm1.Button5Click(Sender: TObject);
VAR
    S: STRING;
    S1: STRING;
    S2: STRING;
    S3: STRING;
    Plage: STRING;
    PlagePantin: STRING;
    NumMagasin: STRING;
    i: integer;
BEGIN
    Edit6.text := Edit7.text;
    Button3Click(NIL);
    Data.close;
    S := IncludeTrailingBackslash(ExtractFilePath(Edit6.text));
    S1 := Mem_Site.lines[0];
    S3 := Copy(S1, Pos(';', S1) + 1, length(s1));
    PlagePantin := Copy(S3, Pos(';', S3) + 1, Length(s3));
    delete(PlagePantin, 1, Pos(';', PlagePantin));
    Delete(S1, Pos(';', S1), length(s1));
    Delete(S3, Pos(';', S3), length(s3));
    Label9.Caption := 'Création de la base ' + S1 + '.GDB'; Label9.Update;
    ForceDirectories (S + S1) ;
    Copier(Edit6.text,S + S1 + '\GINKOIA.GDB') ;
    // renamefile(Edit6.text, S + S1 + '.GDB');
    Label9.Caption := 'MAJ de la base ' + S1 + '.GDB'; Label9.Update;
    Data.DatabaseName := S + S1 + '\GINKOIA.GDB';
    data.Open;
    tran.Active := true;
    IBQue_ModifParam.ParamByName('ID').AsString := S3;
    IBQue_ModifParam.ExecSQL;
    Commit;
    Recup_Generateur(PlagePantin, PlagePantin, 0, S + S1, S1);
    Data.close;
    FOR i := 1 TO Mem_Site.lines.Count - 1 DO
    BEGIN
        S2 := trim(Mem_Site.lines[i]);
        IF S2 <> '' THEN
        BEGIN
            S3 := Copy(S2, Pos(';', S2) + 1, length(s2));
            Plage := Copy(S3, Pos(';', S3) + 1, Length(s3));
            delete(Plage, 1, Pos(';', Plage));
            Delete(S2, Pos(';', S2), length(s2));
            Delete(S3, Pos(';', S3), length(s3));
            Label9.Caption := 'Création de la base ' + S2 + '.GDB'; Label9.Update;
            ForceDirectories (S + S2) ;
            Copier(Edit6.text,S + S2 + '\GINKOIA.GDB') ;
            Label9.Caption := 'MAJ de la base ' + S2 + '.GDB'; Label9.Update;
            Data.DatabaseName := S + S2 + '\GINKOIA.GDB';
            data.Open;
            tran.Active := true;
            IBQue_ModifParam.ParamByName('ID').AsString := S3;
            IBQue_ModifParam.ExecSQL;
            Commit;
            NumMagasin := S3;
            Recup_Generateur(PlagePantin, Plage, StrToInt(NumMagasin), S + S2, S2 );
            Data.close;
        END;
    END;
    application.MessageBox('Création des bases terminée ', 'Tout est OK', Mb_Ok AND MB_ICONASTERISK);
END;

PROCEDURE TForm1.decodeplage(S: STRING; VAR Deb, fin: integer);
BEGIN
    IF Pos('[', S) = 1 THEN
        delete(S, 1, 1);
    deb := Strtoint(copy(S, 1, pos('M', S) - 1));
    IF Pos('_', S) > 0 THEN
        delete(S, 1, pos('_', S))
    ELSE
        delete(S, 1, pos('-', S));
    fin := Strtoint(copy(S, 1, pos('M', S) - 1));
END;

PROCEDURE TForm1.Recup_Generateur(Plage_pantin, Plage_Magasin: STRING;
    NumMagasin: Integer; Path, Nom: STRING);

    PROCEDURE transforme(TAG, Valeur: STRING; VAR S2: STRING);
    VAR
        i: Integer;
    BEGIN
        WHILE pos('<' + TAG + '>', S2) > 0 DO
        BEGIN
            i := pos('<' + TAG + '>', S2);
            delete(S2, i, length('<' + TAG + '>'));
            WHILE s2[i] <> '<' DO delete(s2, i, 1);
            INSERT('<@@>' + Valeur, S2, I);
        END;
        WHILE pos('<@@>', S2) > 0 DO
        BEGIN
            i := pos('<@@>', S2);
            delete(S2, i, length('<@@>'));
            INSERT('<' + TAG + '>', S2, I);
        END;
    END;

VAR
    ini: tinifile;
    deb, fin: Integer;
    deb2, fin2: Integer;
    def: integer;
    minimum: integer;
    num: Integer;
    J: Integer;
    S: STRING;
    Table: STRING;
    Champs: STRING;
    Plus: STRING;
    Pass: STRING;

    genid: Integer;
    genidpantin: Integer;

    Tsl: TstringList;

    Generateur: STRING;

BEGIN
    ini := tinifile.create(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'RecupBase.ini');
    TRY
        decodeplage(Plage_Magasin, deb, fin);
        decodeplage(plage_Pantin, deb2, fin2);
        IBQue_Generateur.Open;
        GenIdPantin := 0;
        GenId := 0;
        WHILE NOT IBQue_Generateur.EOF DO
        BEGIN
            Generateur := trim(IBQue_GenerateurNAME.AsString);
            def := ini.readinteger(Generateur, 'Def', 0);
            minimum := ini.readinteger(Generateur, 'Min', -9999);
            IF def = 1 THEN // plage
            BEGIN
                Num := 0;
                IF Uppercase(Generateur) = 'GENERAL_ID' THEN
                BEGIN // Pantin
                    num := 0;
                    j := ini.readinteger(Generateur, 'NbTable', 0);
                    FOR j := 1 TO j DO
                    BEGIN
                        S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                        Table := copy(S, 1, pos(';', S) - 1);
                        Champs := copy(S, pos(';', S) + 1, 255);
                        IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table + ' where ' + Champs + ' between ' + Inttostr(deb2) + '*1000000 and ' + Inttostr(fin2) + '*1000000 ';
                        IBQue_Script.Open;
                        IF NOT (IBQue_Script.fields[0].IsNull) AND (IBQue_Script.fields[0].Asinteger > Num) THEN
                            Num := IBQue_Script.fields[0].Asinteger;
                        IBQue_Script.Close;
                    END;
                    IF num < deb2 * 1000000 THEN
                        num := deb2 * 1000000;
                    IF num < minimum THEN
                        num := minimum;
                    genidpantin := Num;
                END;
                IF (Uppercase(Generateur) = 'GENERAL_ID') AND
                    (NumMagasin = 0) THEN
                BEGIN
                    genid := genidpantin;
                    IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                    IBQue_Script.ExecSQL;
                END
                ELSE
                BEGIN
                    num := 0;
                    j := ini.readinteger(Generateur, 'NbTable', 0);
                    FOR j := 1 TO j DO
                    BEGIN
                        S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                        Table := copy(S, 1, pos(';', S) - 1);
                        Champs := copy(S, pos(';', S) + 1, 255);
                        IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table + ' where ' + Champs + ' between ' + Inttostr(deb) + '*1000000 and ' + Inttostr(fin) + '*1000000 ';
                        IBQue_Script.Open;
                        IF NOT (IBQue_Script.fields[0].IsNull) AND (IBQue_Script.fields[0].Asinteger > Num) THEN
                            Num := IBQue_Script.fields[0].Asinteger;
                        IBQue_Script.Close;
                    END;
                    IF num < deb * 1000000 THEN
                        num := deb * 1000000;
                    IF num < minimum THEN
                        num := minimum;
                    IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                    IBQue_Script.ExecSQL;
                    genid := Num;
                END;
            END
            ELSE IF def = 2 THEN // magasin+plage
            BEGIN
                num := 0;
                j := ini.readinteger(Generateur, 'NbTable', 0);
                FOR j := 1 TO j DO
                BEGIN
                    S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                    Table := copy(S, 1, pos(';', S) - 1);
                    delete(S, 1, pos(';', S));
                    IF pos(';', S) > 0 THEN
                    BEGIN
                        Champs := copy(S, 1, pos(';', S) - 1);
                        delete(S, 1, pos(';', S));
                        plus := S;
                    END
                    ELSE
                    BEGIN
                        Champs := S;
                        plus := '';
                    END;
                    IBQue_Script.sql.text := 'select Max( Cast(f_mid (' + Champs + ',' + InttoStr(Length(Inttostr(NumMagasin)) + 1) + ',12) as integer)) from ' + table + ' where ' + Champs + ' Like ''' + Inttostr(NumMagasin) + '-%''';
                    IF plus <> '' THEN
                        IBQue_Script.sql.text := IBQue_Script.sql.text + 'AND ' + Plus;
                    IBQue_Script.Open;
                    IF (NOT IBQue_Script.eof) AND (NOT IBQue_Script.fields[0].IsNull) AND (IBQue_Script.fields[0].Asinteger > Num) THEN
                        Num := IBQue_Script.fields[0].Asinteger;
                    IBQue_Script.Close;
                END;
                IF num < minimum THEN
                    num := minimum;
                IBQue_Script.sql.TEXT := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                IBQue_Script.ExecSQL;
            END
            ELSE IF def = 5 THEN // magasin+(M)+plage
            BEGIN
                num := 0;
                j := ini.readinteger(Generateur, 'NbTable', 0);
                FOR j := 1 TO j DO
                BEGIN
                    S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                    Table := copy(S, 1, pos(';', S) - 1);
                    delete(S, 1, pos(';', S));
                    IF pos(';', S) > 0 THEN
                    BEGIN
                        Champs := copy(S, 1, pos(';', S) - 1);
                        delete(S, 1, pos(';', S));
                        plus := S;
                    END
                    ELSE
                    BEGIN
                        Champs := S;
                        plus := '';
                    END;
                    IBQue_Script.sql.text := 'select Max( Cast(f_mid (' + Champs + ',' + InttoStr(Length(Inttostr(NumMagasin)) + 2) + ',12) as integer)) from ' + table + ' where ' + Champs + ' Like ''' + Inttostr(NumMagasin) + '-%''';
                    IF plus <> '' THEN
                        IBQue_Script.sql.text := IBQue_Script.sql.text + 'AND ' + Plus;
                    IBQue_Script.Open;
                    IF (NOT IBQue_Script.eof) AND (NOT IBQue_Script.fields[0].IsNull) AND (IBQue_Script.fields[0].Asinteger > Num) THEN
                        Num := IBQue_Script.fields[0].Asinteger;
                    IBQue_Script.Close;
                END;
                IF num < minimum THEN
                    num := minimum;
                IBQue_Script.sql.text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                IBQue_Script.execSql;
            END
            ELSE IF def = 3 THEN // pas de plage
            BEGIN
                num := 0;
                j := ini.readinteger(Generateur, 'NbTable', 0);
                FOR j := 1 TO j DO
                BEGIN
                    S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                    Table := copy(S, 1, pos(';', S) - 1);
                    Champs := copy(S, pos(';', S) + 1, 255);
                    IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table;
                    IBQue_Script.Open;
                    IF NOT (IBQue_Script.fields[0].IsNull) AND (IBQue_Script.fields[0].Asinteger > Num) THEN
                        Num := IBQue_Script.fields[0].Asinteger;
                    IBQue_Script.Close;
                END;
                IF num < minimum THEN
                    num := minimum;
                IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                IBQue_Script.execSql;
            END
            ELSE IF def = 4 THEN // Code Barre
            BEGIN
                num := 0;
                j := ini.readinteger(Generateur, 'NbTable', 0);
                FOR j := 1 TO j DO
                BEGIN
                    S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                    Table := copy(S, 1, pos(';', S) - 1);
                    IBQue_Champs.ParamByName('Nom').AsString := Table;
                    IBQue_Champs.Open;
                    IBQue_Champs.First;
                    Pass := IBQue_ChampsCHAMPS.AsString;
                    IBQue_Champs.Close;
                    delete(S, 1, pos(';', S));
                    IF pos(';', S) > 0 THEN
                    BEGIN
                        Champs := copy(S, 1, pos(';', S) - 1);
                        delete(S, 1, pos(';', S));
                        plus := S;
                    END
                    ELSE
                    BEGIN
                        Champs := S;
                        plus := '';
                    END;
                    IBQue_Script.sql.text := 'Select ' + Champs + ' from ' + Table + ' Where ' + Pass + ' = (' +
                        'Select Max(' + Pass + ') from ' + Table + ' Where ' + Pass + ' Between ' + Inttostr(deb) + '*1000000 and ' + Inttostr(fin) + '*1000000 ';
                    IF plus <> '' THEN
                        IBQue_Script.sql.Add('AND ' + Plus + ')')
                    ELSE
                        IBQue_Script.sql.Add(')');
                    TRY
                        IBQue_Script.Open;
                        IF NOT (IBQue_Script.fields[0].IsNull) THEN
                        BEGIN
                            S := IBQue_Script.fields[0].AsString;
                            Delete(S, 1, 4);
                            Delete(S, length(S), 1);
                            IF Num < StrToInt(S) THEN
                                Num := StrToInt(S);
                        END
                        ELSE
                            Num := 0;
                        IBQue_Script.Close;
                    EXCEPT
                        Num := 0;
                    END;
                END;
                IF num < minimum THEN
                    num := minimum;
                IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
                IBQue_Script.ExecSQL;
            END;
            IBQue_Generateur.Next;
        END;
        IBQue_Generateur.Close;
        Commit;
        IF (NumMagasin <> 0) AND (trim(Ed_EAI.TEXT) <> '') THEN
        BEGIN
            ForceDirectories(Path);
            Tsl := TstringList.Create;
            TRY
                tsl.loadfromfile(Ed_EAI.TEXT + 'DelosQPMAgent.Providers.xml');
                S := Tsl.text;
                IF rb3.checked THEN
                    transforme('URL', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/Batch', S)
                ELSE IF rb2.checked THEN
                    transforme('URL', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/Batch', S)
                ELSE
                    transforme('URL', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/Batch', S);
                transforme('Sender', Nom, S);
                transforme('Database', Edit8.Text, S);
                transforme('LAST_VERSION', Inttostr(GenId), S);
                Tsl.Text := S;
                tsl.savetofile(Path + '\DelosQPMAgent.Providers.xml');

                tsl.loadfromfile(Ed_EAI.TEXT + 'DelosQPMAgent.Subscriptions.xml');
                S := Tsl.text;
                IF rb3.checked THEN
                BEGIN
                    transforme('URL', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/Extract', S);
                    transforme('GetCurrentVersion', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/GetCurrentVersion', S);
                END
                ELSE
                IF rb2.checked THEN
                Begin
                    transforme('URL', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/Extract', S);
                    transforme('GetCurrentVersion', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/GetCurrentVersion', S);
                END
                ELSE
                BEGIN
                    transforme('URL', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/Extract', S);
                    transforme('GetCurrentVersion', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/GetCurrentVersion', S);
                END;
                transforme('Sender', Nom, S);
                transforme('Database', Edit8.Text, S);
                transforme('LAST_VERSION', Inttostr(genidpantin), S);
                Tsl.Text := S;
                tsl.savetofile(Path + '\DelosQPMAgent.Subscriptions.xml');

                tsl.loadfromfile(Ed_EAI.TEXT + 'DelosQPMAgent.InitParams.xml');
                S := Tsl.text;
                IF rb3.checked THEN
                BEGIN
                    transforme('QPM_BatchException', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_ExtractException', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PullDone', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PullException', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PushDone', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PushException', 'http://replic3.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                END
                ELSE
                IF rb2.checked THEN
                BEGIN
                    transforme('QPM_BatchException', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_ExtractException', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PullDone', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PullException', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PushDone', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PushException', 'http://replic2.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                END
                ELSE
                BEGIN
                    transforme('QPM_BatchException', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_ExtractException', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PullDone', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PullException', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PushDone', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                    transforme('QPM_PushException', 'http://replic1.algol.fr/' + Ed_EAIBin.Text + '/DelosQPMAgent.dll/InsertLOG', S);
                END;
                Tsl.Text := S;
                tsl.savetofile(Path + '\DelosQPMAgent.InitParams.xml');
            FINALLY
                tsl.free;
            END;
        END;
    FINALLY
        ini.free;
    END;
END;

PROCEDURE TForm1.SpeedButton7Click(Sender: TObject);
BEGIN
    IF Od3.Execute THEN
        Ed_EAI.Text := IncludeTrailingBackslash(ExtractFilePath(Od3.FileName));
END;

PROCEDURE TForm1.SpeedButton8Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        Edt_ChxBack.text := od.filename;
END;

FUNCTION TForm1.Restoration(Backup, Fichier: STRING): Boolean;
VAR
    tsl: tstringList;
    i: integer;
    debut: TDateTime;
BEGIN
    Screen.cursor := crHourGlass;
    TRY
        TRY
            tsl := tstringList.create;
            TRY
                deletefile('C:\un.txt');
                deletefile('C:\trois.txt');

                tsl.Add('"' + PlaceDeInterbase + 'gbak.exe " "' + Backup + '" "' + Fichier +
                    '" -user sysdba -password masterkey -C -K -BU 4096 -P 4096 -Y "C:\un.txt"'
                    );
                tsl.Add('Copy "C:\un.txt" "C:\trois.txt"');
                tsl.Add('exit');
                tsl.savetofile('C:\Go.Bat');
                IF Winexec(Pchar('c:\GO.BAT'), 0) <= 31 THEN
                BEGIN
                    result := false;
                    exit;
                END;
                FOR i := 1 TO 25 DO
                BEGIN
                    application.processmessages;
                    sleep(100);
                END;
                debut := now;
                WHILE NOT fileexists('C:\trois.txt') DO
                BEGIN
                    IF Now - debut > 0.1 THEN
                    BEGIN
                        result := False;
                        Exit;
                    END;
                    application.processmessages;
                    sleep(1000);
                END;
                FOR i := 1 TO 25 DO
                BEGIN
                    application.processmessages;
                    sleep(100);
                END;
                tsl.loadfromfile('C:\trois.txt');
                IF tsl.count > 1 THEN
                    result := false
                ELSE
                    result := true;
            FINALLY
                tsl.free;
            END;
        EXCEPT
            result := false;
        END;
    FINALLY
        Screen.cursor := crDefault;
    END;
END;

PROCEDURE TForm1.Button6Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    IF CB_VidRep.Checked THEN
    BEGIN
        deletefile(CheminTranspo + 'Ginkoia.gdb');
        deletefile(CheminTranspo + 'Import.gdb');
    END;
    IF CB_RecopImport.Checked THEN
    BEGIN
        CopyFile(Pchar(CheminBasesVide + 'Import.Gdb'), Pchar(CheminTranspo + 'Import.Gdb'), false);
    END;
    IF Restoration(Edt_ChxBack.text, CheminTranspo + 'Ginkoia.gdb') THEN
    BEGIN
        CopyFile(Pchar(CheminTranspo + 'Ginkoia.Gdb'), Pchar(CheminTranspo + 'GinkoiaVide.Gdb'), false);
        DerniereBase := CheminTranspo + 'GinkoiaVide.Gdb';
        ini := tinifile.create(changefileext(application.exename, '.ini'));
        ini.Writestring('PARAM', 'DERNIEREBASE', DerniereBase);
        ini.free;
        IF Cb_LancImport.Checked THEN
            Winexec(PChar(CheminImport + ' AUTO OUI ' + CheminTranspo), 0);
        application.MessageBox('Phase une terminée, Import en cours', 'Tout est OK', Mb_Ok AND MB_ICONASTERISK);
    END
    ELSE
    BEGIN
        application.MessageBox('Problème dans le restore', 'Problème', Mb_Ok AND MB_ICONASTERISK);
    END;
END;

PROCEDURE TForm1.Button7Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    IF DerniereBase <> '' THEN
    BEGIN
        IF Application.MessageBox(PChar('Repartir de la derniere base ' + DerniereBase), ' Voulez-vous', Mb_YESNO) = MrNo THEN
            DerniereBase := '';
    END;
    IF DerniereBase = '' THEN
    BEGIN
        Od2.InitialDir := CheminBasesVide;
        IF od2.execute THEN
        BEGIN
            derniereBase := od2.FileName;
            ini := tinifile.create(changefileext(application.exename, '.ini'));
            ini.Writestring('PARAM', 'DERNIEREBASE', DerniereBase);
            ini.free;
        END;
    END;
    IF DerniereBase = '' THEN
        EXIT;

    IF CB_VidRep.Checked THEN
    BEGIN
        deletefile(CheminTranspo + 'Ginkoia.gdb');
        deletefile(CheminTranspo + 'Import.gdb');
    END;
    IF CB_RecopImport.Checked THEN
    BEGIN
        IF NOT (fileexists(CheminBasesVide + 'Import.Gdb')) THEN
        BEGIN
            application.MessageBox(Pchar(CheminBasesVide + 'Import.Gdb n''existe pas'), 'Problème', Mb_Ok);
            EXIT;
        END;
        CopyFile(Pchar(CheminBasesVide + 'Import.Gdb'), Pchar(CheminTranspo + 'Import.Gdb'), false);
    END;
    IF NOT (fileexists(derniereBase)) THEN
    BEGIN
        application.MessageBox(PChar(derniereBase + ' n''existe pas'), 'Problème', Mb_Ok);
        EXIT;
    END;
    CopyFile(Pchar(derniereBase), Pchar(CheminTranspo + 'Ginkoia.Gdb'), false);
    IF Cb_LancImport.Checked THEN
        Winexec(PChar(CheminImport + ' AUTO OUI 0 ' + CheminTranspo), 0);
    application.MessageBox('Phase une terminée, Import en cours', 'Tout est OK', Mb_Ok AND MB_ICONASTERISK);
END;

PROCEDURE TForm1.Button8Click(Sender: TObject);
BEGIN
    data.close;
    WinExec(Pchar(CheminParam), 0);
END;

PROCEDURE TForm1.SpeedButton10Click(Sender: TObject);
BEGIN
    IF Od2.execute THEN
        Ed_BaseCtrl.Text := Od2.FileName;
END;

PROCEDURE TForm1.Button9Click(Sender: TObject);
VAR
    Rap: TstringList;
    Tsl: TstringList;
    S: STRING;
    i: integer;
    ii:integer ;
BEGIN
    DecimalSeparator := ',';
    rap := TStringList.Create;
    TRY
        rap.add('Contrôle des données Le : ' + DateTimeToStr(Now));
        Data.Close;
        Data.DatabaseName := Ed_BaseCtrl.text;
        Data.Open;
        tran.active := true;

        Tsl := TstringList.Create;
        tsl.loadfromfile(IPHUSKY + 'Rapport.txt');

        Lab_EtatCtrl.Caption := 'Contrôle du nombre de client'; Lab_EtatCtrl.Update;
        ii := 0 ;
        WHILE Copy(trim(TSL[ii]),1,length('Nombre de clients'))<>'Nombre de clients' do
          inc(ii) ;
        S := TSL[ii]; Delete(S, 1, pos(':', S)); S := trim(S);
        IBQue_Script.Sql.Text := 'Select COUNT(*) from CLTCLIENT Join k on (k_id=clt_id and K_enabled=1) WHERE CLT_ID<>0';
        IBQue_Script.Open;
        IF IBQue_Script.Fields[0].AsInteger <> StrToInt(S) THEN
            rap.add('Problème sur le fichier CLIENT          -> ' + S + ' enregistrements attendus, ' + IBQue_Script.Fields[0].AsString + ' trouvés')
        ELSE
            rap.add('Fichier Client          : OK');
        IBQue_Script.Close;

        Lab_EtatCtrl.Caption := 'Contrôle du nombre de Fournisseur'; Lab_EtatCtrl.Update;
        S := TSL[ii+1]; Delete(S, 1, pos(':', S)); S := trim(S);
        IBQue_Script.Sql.Text := 'Select COUNT(*) from ARTFOURN Join k on (k_id=Fou_id and K_enabled=1)  WHERE FOU_ID<>0';
        IBQue_Script.Open;
        IF IBQue_Script.Fields[0].AsInteger <> StrToInt(S) THEN
            rap.add('Problème sur le fichier Fournisseur     -> ' + S + ' enregistrements attendus, ' + IBQue_Script.Fields[0].AsString + ' trouvés')
        ELSE
            rap.add('Fichier Fournisseur     : OK');
        IBQue_Script.Close;

        Lab_EtatCtrl.Caption := 'Contrôle du nombre d''article'; Lab_EtatCtrl.Update;
        S := TSL[ii+2]; Delete(S, 1, pos(':', S)); S := trim(S);
        IBQue_Script.Sql.Text := 'Select COUNT(*) from ArtArticle Join k on (k_id=ART_id and K_enabled=1) Join ArtReference on (ARF_ARTID=ART_ID) WHERE ART_ID<>0';
        IBQue_Script.Open;
        IF IBQue_Script.Fields[0].AsInteger <> StrToInt(S) THEN
            rap.add('Problème sur le fichier Article         -> ' + S + ' enregistrements attendus, ' + IBQue_Script.Fields[0].AsString + ' trouvés')
        ELSE
            rap.add('Fichier Article         : OK');
        IBQue_Script.Close;

        Lab_EtatCtrl.Caption := 'Contrôle du solde des comptes clients '; Lab_EtatCtrl.Update;
        S := TSL[ii+3]; Delete(S, 1, pos(':', S)); S := trim(S);
        IBQue_Script.Sql.Text := 'select SUM(CTE_CREDIT-CTE_DEBIT) from cltcompte Join CltClient on (Clt_ID=Cte_CltId) Join k on (k_id=Cte_id and K_Enabled=1) Where CTE_ID<>0';
        IBQue_Script.Open;
        IF trunc(IBQue_Script.Fields[0].AsFloat) <> trunc(StrToFloat(S)) THEN
            rap.add('Problème les soldes des comptes client  -> ' + S + ' attendue, ' + IBQue_Script.Fields[0].AsString + ' trouvés')
        ELSE
            rap.add('Solde des cpt client    : OK');
        IBQue_Script.Close;

        Lab_EtatCtrl.Caption := 'Contrôle du stock '; Lab_EtatCtrl.Update;
        S := TSL[ii+4]; Delete(S, 1, pos(':', S)); S := trim(S);
        IBQue_Script.Sql.Text := 'select Sum(STC_QTE) from agrstockcour';
        IBQue_Script.Open;
        IF IBQue_Script.Fields[0].Asinteger <> StrToInt(S) THEN
            rap.add('Problème sur le stock                   -> ' + S + ' attendue, ' + IBQue_Script.Fields[0].AsString + ' trouvés')
        ELSE
            rap.add('Somme du Stock          : OK');
        IBQue_Script.Close;

        Lab_EtatCtrl.Caption := 'Contrôle du RAL '; Lab_EtatCtrl.Update;
        S := TSL[ii+5]; Delete(S, 1, pos(':', S)); S := trim(S);
        IBQue_Script.Sql.Text := 'select SUM(RAL_QTE) from agrRAL';
        IBQue_Script.Open;
        IF IBQue_Script.Fields[0].Asinteger <> StrToInt(S) THEN
            rap.add('Problème sur le RAL                     -> ' + S + ' attendue, ' + IBQue_Script.Fields[0].AsString + ' trouvés')
        ELSE
            rap.add('Somme du RAL            : OK');
        IBQue_Script.Close;

        Tsl.free;
        rap.add('');
        rap.add('====================================================================');
        rap.add('');
        rap.add('    Contrôle détaillé du stock et ral');
        rap.add('');

        TRY
            IBSQL1.sql.Text := 'DROP PROCEDURE PR_CONTROLE';
            IBSQL1.ExecQuery;
        EXCEPT
        END;
        IBSQL1.sql.clear;
        IBSQL1.sql.Add('CREATE PROCEDURE PR_CONTROLE');
        IBSQL1.sql.Add('RETURNS (');
        IBSQL1.sql.Add('    VCHRONO VARCHAR (32),');
        IBSQL1.sql.Add('    VSTOCK INTEGER,');
        IBSQL1.sql.Add('    VRAL INTEGER)');
        IBSQL1.sql.Add('AS');
        IBSQL1.sql.Add('declare variable artid Integer;');
        IBSQL1.sql.Add('BEGIN');
        IBSQL1.sql.Add('  For Select arf_chrono, Arf_artid');
        IBSQL1.sql.Add('        from artreference join k on (k_id=arf_id and k_enabled=1)');
        IBSQL1.sql.Add('  where arf_id<>0');
        IBSQL1.sql.Add('  into :vChrono, :artid');
        IBSQL1.sql.Add('  do');
        IBSQL1.sql.Add('  begin');
        IBSQL1.sql.Add('    vStock = 0 ;');
        IBSQL1.sql.Add('    Select Sum(stc_qte)');
        IBSQL1.sql.Add('      from agrstockcour');
        IBSQL1.sql.Add('     where stc_artid = :artid');
        IBSQL1.sql.Add('    into :vStock ;');
        IBSQL1.sql.Add('    if (vStock is null) then vstock = 0 ;');
        IBSQL1.sql.Add('    vRAL = 0 ;');
        IBSQL1.sql.Add('    Select SUM (ral_qte)');
        IBSQL1.sql.Add('      from agrral join combcdel on (cdl_id=ral_cdlid)');
        IBSQL1.sql.Add('     where cdl_artid = :artid');
        IBSQL1.sql.Add('    into :vRal ;');
        IBSQL1.sql.Add('    if (vral is null) then vral = 0 ;');
        IBSQL1.sql.Add('    Suspend ;');
        IBSQL1.sql.Add('  end');
        IBSQL1.sql.Add('END');
        IBSQL1.ExecQuery;

        Lab_EtatCtrl.Caption := 'Contrôle du stock et du RAL Phase 1 Traitement'; Lab_EtatCtrl.Update;
        Mem.DelimiterChar := ';';
        mem.SortedField := '';
        Mem.LoadFromTextFile(IPHUSKY + 'Controle.txt');
        pbctrl.max := Mem.RecordCount;
        pbctrl.Position := 0;
        Mem.first;
        WHILE NOT mem.eof DO
        BEGIN
            pbctrl.Position := pbctrl.Position + 1;
            IF trim(memchrono.AsString) = '' THEN
                mem.delete
            ELSE
            BEGIN
                S := inttostr(memChrono.AsInteger);
                IF S <> memChrono.AsString THEN
                BEGIN
                    mem.edit; memChrono.AsString := S; mem.post;
                END;
                mem.next;
            END;
        END;
        mem.SortedField := 'Chrono';

        Lab_EtatCtrl.Caption := 'Contrôle du stock et du RAL Phase 2 Vérification'; Lab_EtatCtrl.Update;
        IBQue_Script.Sql.Clear;
        IBQue_Script.Sql.Add('Select VCHRONO, VSTOCK, VRAL');
        IBQue_Script.Sql.Add('From PR_CONTROLE');
        IBQue_Script.Sql.Add('Order by VChrono');
        IBQue_Script.Open;
        Mem.first;
        IBQue_Script.First;
        pbctrl.max := Mem.RecordCount;
        pbctrl.Position := 0;
        tsl := tstringlist.create;
        WHILE NOT (IBQue_Script.eof AND mem.eof) DO
        BEGIN
            IF IBQue_Script.eof THEN
            BEGIN
                rap.add('Article ' + memChrono.AsString + ' dans Husky et pas dans Ginkoia');
                pbctrl.Position := pbctrl.Position + 1;
                mem.next;
            END
            ELSE IF Mem.eof THEN
            BEGIN
                // rap.add('Article '+IBQue_Script.Fields[0].AsString + ' dans Ginkoia et pas dans Husky');
                IBQue_Script.next;
            END
            ELSE IF IBQue_Script.fields[0].AsString < memChrono.asstring THEN
            BEGIN
                //rap.add('Article ' + IBQue_Script.Fields[0].AsString + ' dans Ginkoia et pas dans Husky');
                IBQue_Script.next;
            END
            ELSE IF IBQue_Script.fields[0].AsString > memChrono.asstring THEN
            BEGIN
                rap.add('Article ' + memChrono.AsString + ' dans Husky et pas dans Ginkoia');
                pbctrl.Position := pbctrl.Position + 1;
                mem.next;
            END
            ELSE
            BEGIN
                IF memstock.AsInteger <> IBQue_Script.Fields[1].AsInteger THEN
                    rap.add('Article ' + memChrono.AsString + ' Erreur de stock ' + IBQue_Script.Fields[1].AsString + ' au lieu de ' + memstock.AsString);
                IF memRAL.AsInteger <> IBQue_Script.Fields[2].AsInteger THEN
                    tsl.add('Article ' + memChrono.AsString + ' Erreur de RAL   ' + IBQue_Script.Fields[2].AsString + ' au lieu de ' + memRAL.AsString);
                IBQue_Script.next;
                mem.next;
                pbctrl.Position := pbctrl.Position + 1;
            END;
        END;
        rap.add('-----------------------------------------------------------');
        FOR i := 0 TO tsl.count - 1 DO
            rap.add(tsl[i]);

        tsl.free;
        IBSQL1.sql.Text := 'DROP PROCEDURE PR_CONTROLE';
        IBSQL1.ExecQuery;

        Data.Close;
    FINALLY
        rap.savetofile(IPHUSKY + 'Controles.txt');
        rap.free;
    END;
    Winexec(PCHAR('CMD /C Notepad.exe ' + IPHUSKY + 'Controles.txt'), 0);
END;

PROCEDURE TForm1.Quitter1Click(Sender: TObject);
BEGIN
    Close;
END;

PROCEDURE TForm1.SpeedButton11Click(Sender: TObject);
VAR
    ini: TIniFile;
BEGIN
    IF od4.execute THEN
    BEGIN
        //
        Ed_RepTranspo.text := IncludeTrailingBackslash(extractfilepath(od4.filename));
        CheminTranspo := Ed_RepTranspo.text;
        IPHUSKY := CheminTranspo + 'IP_HUSKY\';
        ini := tinifile.create(changefileext(application.exename, '.ini'));
        ini.Writestring('PARAM', 'CHEMINTRAN', CheminTranspo);
        ini.free;
        Ed_BaseCtrl.text := CheminTranspo + 'Ginkoia.gdb';
        Edit3.text := CheminTranspo + 'Ginkoia.gdb';
        Edit4.text := CheminTranspo + 'Ginkoia.gbK';
        Edit5.text := CheminTranspo + 'GinkoiaBCK.gdb';
        Edit6.text := CheminTranspo + 'Ginkoia.gdb';
        Edit7.text := CheminTranspo + 'Ginkoia.gdb';
    END;
END;

PROCEDURE TForm1.FormCreate(Sender: TObject);
VAR
    ini: TIniFile;
BEGIN
    ini := tinifile.create(changefileext(application.exename, '.ini'));
    CheminTranspo := ini.readstring('PARAM', 'CHEMINTRAN', 'C:\Ginkoia\Clientxx\');
    IPHUSKY := CheminTranspo + 'IP_HUSKY\';
    Ed_BaseCtrl.text := CheminTranspo + 'Ginkoia.gdb';
    Edit3.text := CheminTranspo + 'Ginkoia.gdb';
    Edit4.text := CheminTranspo + 'Ginkoia.gbK';
    Edit5.text := CheminTranspo + 'GinkoiaBCK.gdb';
    Edit6.text := CheminTranspo + 'Ginkoia.gdb';
    Edit7.text := CheminTranspo + 'Ginkoia.gdb';
    CheminBasesVide := ini.readstring('PARAM', 'CHEMINVIDE', 'C:\BASEVIDE\');
    CheminBackup := ini.readstring('PARAM', 'CHEMINBACKUP', 'C:\BACKUP\');
    DerniereBase := ini.readstring('PARAM', 'DERNIEREBASE', '');
    CheminImport := ini.readstring('PARAM', 'PLACEIMPORT', 'C:\Ginkoia\Import_Husky.exe');
    //IPHUSKY := ini.readstring('PARAM', 'IP_HUSKY', 'C:\IP_HUSKY\');
    CheminParam := ini.readstring('PARAM', 'PARAMETRAGE', 'C:\Ginkoia\ParametrageGinkoia.exe');
    CheminEAI := ini.readstring('PARAM', 'EAI', 'C:\Ginkoia\EAI\');
    LastEAI := ini.readstring('PARAM', 'LASTEAI', 'V2_4_0_43Bin');
    Ed_EAIBin.Text := LastEAI;
    ini.free;
END;

PROCEDURE TForm1.Paramtrage1Click(Sender: TObject);
VAR
    Frm_Param: TFrm_Param;
    ini: TIniFile;
BEGIN
    application.createform(TFrm_Param, Frm_Param);
    IF Frm_Param.ShowModal = MrOk THEN
    BEGIN
        ini := tinifile.create(changefileext(application.exename, '.ini'));
        CheminBasesVide := ini.readstring('PARAM', 'CHEMINVIDE', 'C:\BASEVIDE\');
        CheminBackup := ini.readstring('PARAM', 'CHEMINBACKUP', 'C:\BACKUP\');
        CheminImport := ini.readstring('PARAM', 'PLACEIMPORT', 'C:\Ginkoia\Import_Husky.exe');
        // IPHUSKY := ini.readstring('PARAM', 'IP_HUSKY', 'C:\IP_HUSKY\');
        CheminParam := ini.readstring('PARAM', 'PARAMETRAGE', 'C:\Ginkoia\ParametrageGinkoia.exe');
        CheminEAI := ini.readstring('PARAM', 'EAI', 'C:\Ginkoia\EAI\');
        ini.free;
    END;
    Frm_Param.release;
END;

PROCEDURE TForm1.Ed_EAIBinExit(Sender: TObject);
VAR
    ini: TIniFile;
BEGIN
    IF LastEAI <> Ed_EAIBin.text THEN
    BEGIN
        LastEAI := Ed_EAIBin.Text;
        ini := tinifile.create(changefileext(application.exename, '.ini'));
        ini.Writestring('PARAM', 'LASTEAI', LastEAI);
        ini.free;
    END;
END;

PROCEDURE TForm1.Ed_RepTranspoExit(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    Ed_RepTranspo.text := IncludeTrailingBackslash(Ed_RepTranspo.text);
    IF CheminTranspo <> Ed_RepTranspo.text THEN
    BEGIN
        CheminTranspo := Ed_RepTranspo.text;
        IPHUSKY := CheminTranspo + 'IP_HUSKY\';
        ini := tinifile.create(changefileext(application.exename, '.ini'));
        ini.Writestring('PARAM', 'CHEMINTRAN', CheminTranspo);
        ini.free;
        Ed_BaseCtrl.text := CheminTranspo + 'Ginkoia.gdb';
        Edit3.text := CheminTranspo + 'Ginkoia.gdb';
        Edit4.text := CheminTranspo + 'Ginkoia.gbK';
        Edit5.text := CheminTranspo + 'GinkoiaBCK.gdb';
        Edit6.text := CheminTranspo + 'Ginkoia.gdb';
        Edit7.text := CheminTranspo + 'Ginkoia.gdb';
    END;
END;

END.

