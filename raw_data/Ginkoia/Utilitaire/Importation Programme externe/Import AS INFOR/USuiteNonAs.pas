UNIT USuiteNonAs;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    IBDatabase, Db, IBSQL, IBCustomDataSet, IBQuery, DBTables, ComCtrls;

TYPE
    TForm1 = CLASS(TForm)
        Db: TIBDatabase;
        Tran: TIBTransaction;
        sql: TIBSQL;
        qry_art: TIBQuery;
        Qry_rech2: TQuery;
        Qry_rech2ARTRE_PA: TFloatField;
        Qry_Rech: TQuery;
        Qry_RechARTRE_PA: TFloatField;
        Qry_table: TIBQuery;
        Qry_tableBRE_DATE: TDateTimeField;
        Qry_tableBRL_ID: TIntegerField;
        Qry_tableBRL_QTE: TFloatField;
        Qry_tableBRL_PXNN: TFloatField;
        Qry_tableBRL_PXACHAT: TFloatField;
        Qry_tableART_REFMRK: TIBStringField;
        DbWinShop: TDatabase;
        tran2: TIBTransaction;
        sql_K: TIBSQL;
        IBQue_CB: TIBQuery;
        IBQue_CBNEWNUM: TIBStringField;
        IBQue_Key: TIBQuery;
        IBQue_KeyNEWKEY: TIntegerField;
        Sql_CB: TIBSQL;
        IBQue_Count: TIBQuery;
        pb: TProgressBar;
        IBQue_CountNBR: TIntegerField;
        IBQue_UnCB: TIBQuery;
        IBQue_UnCBNBR: TIntegerField;
        qry_artTMP_ARTID: TIntegerField;
        qry_artTMP_COUID: TIntegerField;
        qry_artTMP_TGFID: TIntegerField;
        IBQue_NbrCbMarque: TIBQuery;
        IBQue_NbrCbMarqueNBR: TIntegerField;
        IBQue_CBPresent: TIBQuery;
        IBQue_CBPresentCBI_ARFID: TIntegerField;
        IBQue_CBPresentCBI_COUID: TIntegerField;
        IBQue_CBPresentCBI_TGFID: TIntegerField;
        IBSql_MarqueCb: TIBSQL;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormPaint(Sender: TObject);
    PRIVATE
    { Déclarations privées }
        premier: Boolean;
    PUBLIC
    { Déclarations publiques }
        PROCEDURE start;
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION
USES
    Inifiles;

{$R *.DFM}

PROCEDURE TForm1.FormCreate(Sender: TObject);
BEGIN
    premier := true;
END;

PROCEDURE TForm1.FormPaint(Sender: TObject);
BEGIN
    IF premier THEN
    BEGIN
        premier := false;
        Update;
        Start;
    END
END;

PROCEDURE TForm1.start;
VAR
    reg: tinifile;
    S: STRING;
    ttsl: tstringlist;
    Numcb: STRING;
    kid: integer;
    nombre: Integer;
    toto: Integer;
BEGIN
  //
    reg := tinifile.Create('C:\IP_HUSKY\Import_Husky.ini');
    S := reg.readstring('DATABASE', 'PATH', '');
    TRY
        IF s <> '' THEN
        BEGIN
            Caption := 'Passage des script en cours';
            Db.DatabaseName := S;
            Db.Open;
            tran.Active := true;
            tran2.active := true;

            toto := 0;
            IF reg.readstring('PASCAL', 'PATH', '') = S THEN
                toto := reg.readInteger('PASCAL', 'ENCOURS', 0);

            IF toto < 2 THEN
            BEGIN
                Caption := 'Création de l''index TMPSTATP'; Update;
                Sql.sql.clear;
                Sql.sql.Add('CREATE INDEX INX_TMPALL ON TMPSTAT (TMP_ID, TMP_ARTID, TMP_COUID, TMP_TGFID)');
                Sql.ExecQuery;
                IF tran.InTransaction THEN
                    tran.Commit;
                tran.active := true;
                reg.WriteInteger('PASCAL', 'ENCOURS', 2);
            END;

            IF toto < 3 THEN
            BEGIN
                Caption := 'Vidage de la table tmpstat'; Update;
                Sql.sql.clear;
                Sql.sql.Add('DELETE FROM TMPSTAT');
                Sql.ExecQuery;
                IF tran.InTransaction THEN
                    tran.Commit;
                tran.Active := true;
                reg.WriteInteger('PASCAL', 'ENCOURS', 3);
            END;

            IF toto < 4 THEN
            BEGIN
                Sql.sql.clear;
                Caption := 'Préparation de la liste des CB'; Update;
                Sql.sql.Add('Insert into TMPSTAT (TMP_ID, TMP_ARTID, TMP_COUID, TMP_TGFID, TMP_MAGID)');
                Sql.sql.Add('SELECT -1, Arf_id,COU_iD,TTV_TGFID, 0');
                Sql.sql.Add('FROM ARTREFERENCE JOIN K ON (K_ID=ARF_ID AND K_ENABLED=1)');
                Sql.sql.Add('                  JOIN PLXTAILLESTRAV ON (TTV_ARTID=ARF_ARTID)');
                Sql.sql.Add('                  JOIN PLXCOULEUR ON (COU_ARTID=ARF_ARTID)');
                Sql.sql.Add('Where ARF_ID<>0');
                Sql.ExecQuery;
                IF tran.InTransaction THEN
                    tran.Commit;
                tran.Active := true;
                reg.WriteInteger('PASCAL', 'ENCOURS', 4);
            END;
            Sql.sql.clear;

            IBQue_NbrCbMarque.Open;
            pb.Position := 0;
            pb.Max := IBQue_NbrCbMarqueNBR.AsInteger;
            IBQue_NbrCbMarque.Close;
            Caption := 'Marquage des CB déja présent'; Update;

            nombre := 0;
            IBQue_CBPresent.Open;
            IBQue_CBPresent.First;
            WHILE NOT IBQue_CBPresent.Eof DO
            BEGIN
                pb.Position := pb.Position + 1;
                IBSql_MarqueCb.Params[0].AsInteger := IBQue_CBPresentCBI_ARFID.AsInteger;
                IBSql_MarqueCb.Params[1].AsInteger := IBQue_CBPresentCBI_COUID.AsInteger;
                IBSql_MarqueCb.Params[2].AsInteger := IBQue_CBPresentCBI_TGFID.AsInteger;
                IBSql_MarqueCb.ExecQuery;
                Inc(nombre);
                IF nombre > 100 THEN
                BEGIN
                    Update;
                    IF tran2.Intransaction THEN
                        tran2.commit;
                    tran2.active := true;
                    nombre := 0;
                END;
                IBQue_CBPresent.Next;
            END;
            IBQue_CBPresent.Close;
            IF tran2.Intransaction THEN
                tran2.commit;
            tran2.active := true;

            Caption := 'Récupération des CB'; Update;
        // Création des codes barres
            IBQue_Count.Open;
            pb.Position := 0;
            pb.Max := IBQue_CountNBR.AsInteger;
            IBQue_Count.Close;
            qry_art.open;
            qry_art.first;
            nombre := 0;
            WHILE NOT qry_art.eof DO
            BEGIN
                pb.position := pb.position + 1;
                IBQue_CB.Prepare;
                IBQue_CB.Open;
                Numcb := IBQue_CBNEWNUM.AsString;
                IBQue_CB.Close;
                IBQue_CB.UnPrepare;
                IBQue_Key.Prepare;
                IBQue_Key.Open;
                kid := IBQue_KeyNEWKEY.AsInteger;
                IBQue_Key.Close;
                IBQue_Key.UnPrepare;

                Sql_K.Params[0].AsInteger := kid;
                Sql_K.ExecQuery;
                Sql_CB.Params[0].AsInteger := KID;
                Sql_CB.Params[1].AsInteger := qry_artTMP_ARTID.AsInteger;
                Sql_CB.Params[2].AsInteger := qry_artTMP_TGFID.AsInteger;
                Sql_CB.Params[3].AsInteger := qry_artTMP_COUID.AsInteger;
                Sql_CB.Params[4].AsString := NumCb;
                Sql_CB.ExecQuery;
                inc(nombre);
                IF nombre > 100 THEN
                BEGIN
                    Update;
                    IF tran2.Intransaction THEN
                        tran2.commit;
                    tran2.active := true;
                    nombre := 0;
                END;
                qry_art.next;
            END;
            pb.position := Pb.Max;
            IF tran2.Intransaction THEN
                tran2.commit;
            tran2.active := true;
            qry_art.Close;
            Tran.Active := true;
            ttsl := tstringlist.Create;
            ttsl.loadfromfile('SuiteAS.sql');
            WHILE ttsl.count > 0 DO
            BEGIN
                Update;
                Sql.sql.clear;
                WHILE (ttsl.count > 0) AND (trim(ttsl[0]) <> '<----->') DO
                BEGIN
                    IF trim(ttsl[0]) <> '' THEN
                        Sql.sql.Add(ttsl[0]);
                    ttsl.delete(0);
                END;
                IF (ttsl.count > 0) THEN
                    ttsl.delete(0);
                IF sql.sql.count > 0 THEN
                BEGIN
                    Caption := Sql.sql[0];
                    Sql.ExecQuery;
                    IF tran.InTransaction THEN
                        tran.Commit;
                    tran.active := true;
                END;
            END;
            ttsl.free;
            reg.WriteInteger('PASCAL', 'ENCOURS', 0);
            Application.MessageBox('C''est fini', 'FINI', Mb_OK);
        END
        ELSE
        BEGIN
            Close;
        END;
    FINALLY
        reg.free;
    END;
  //
END;

END.

