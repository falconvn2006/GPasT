UNIT UInsert;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    inifiles,
    StdCtrls, Buttons, Db, IBDatabase, RzPrgres, IBCustomDataSet, IBQuery,
    IBStoredProc, IBSQL;

TYPE
    TForm1 = CLASS(TForm)
        Ed_Base: TEdit;
        SpeedButton1: TSpeedButton;
        Button1: TButton;
        lb: TListBox;
        Label1: TLabel;
        Ed_Fichier: TEdit;
        SpeedButton2: TSpeedButton;
        Button2: TButton;
        Db: TIBDatabase;
        OD_BD: TOpenDialog;
        OD_FIC: TOpenDialog;
        Tran: TIBTransaction;
        RechCb: TIBQuery;
        lab_status: TLabel;
        Bar: TRzProgressBar;
        RechCbCBI_ID: TIntegerField;
        RechCbARF_ARTID: TIntegerField;
        RechCbCBI_TGFID: TIntegerField;
        RechCbCBI_COUID: TIntegerField;
        LesInv: TIBQuery;
        ArtExiste: TIBQuery;
        LesInvINV_ID: TIntegerField;
        LesInvINV_CHRONO: TIBStringField;
        LesInvINV_COMENT: TIBStringField;
        TrouveID: TIBQuery;
        ArtExisteNBR: TIntegerField;
        Lab_temps: TLabel;
        GenId: TIBStoredProc;
        Chrono: TIBStoredProc;
        Ins_ENTETE: TIBQuery;
        INS_LIGNES: TIBQuery;
        TrouveIDINL_ID: TIntegerField;
        AjoutArt: TIBStoredProc;
        LesInvINV_MAGID: TIntegerField;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE SpeedButton2Click(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
        Lesmag: TstringList;
    PUBLIC
    { Déclarations publiques }
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TForm1.FormCreate(Sender: TObject);
VAR
    base: STRING;
    ini: tinifile;
BEGIN
    Base := '';
    IF fileexists('c:\ginkoia\ginkoia.ini') THEN
        base := 'c:\ginkoia\ginkoia.ini'
    ELSE IF fileexists('D:\ginkoia\ginkoia.ini') THEN
        base := 'd:\ginkoia\ginkoia.ini';
    IF base <> '' THEN
    BEGIN
        ini := tinifile.create(base);
        TRY
            base := ini.readstring('DATABASE', 'PATH0', '');
            IF base = '' THEN
                base := ini.readstring('DATABASE', 'PATH', '');
        FINALLY
            ini.free;
        END;
    END;
    ed_base.text := Base;
    ed_fichier.text := '';
END;

PROCEDURE TForm1.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od_bd.execute THEN
        ed_base.text := od_bd.filename;
END;

PROCEDURE TForm1.SpeedButton2Click(Sender: TObject);
BEGIN
    IF od_fic.execute THEN
        ed_fichier.text := od_fic.filename;
END;

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    pt: integer;
BEGIN
    db.connected := false;
    db.databasename := ed_base.text;
    db.connected := true;
    tran.active := true;
    LesInv.Open;
    lb.items.clear;
    LesInv.first;
    Lesmag := TstringList.Create;
    WHILE NOT LesInv.eof DO
    BEGIN
        pt := LesInvINV_ID.AsInteger;
        lb.items.AddObject(LesInvINV_CHRONO.AsString + '  ' + LesInvINV_COMENT.AsString, Pointer(pt));
        Lesmag.add(LesInvINV_MAGID.AsString);
        LesInv.Next;
    END;
    LesInv.Close;
    lb.itemIndex := 0;
END;

// trier par code barre

FUNCTION PortableListeTriUn(List: TStringList; Index1, Index2: Integer): Integer;
VAR
    S1, S2: STRING;
BEGIN
    S1 := List[Index1];
    S2 := List[Index2];
    delete(S1, 1, pos(';', s1));
    delete(S1, Pos(';', S1), 255);
    delete(S2, 1, pos(';', s2));
    delete(S2, Pos(';', S2), 255);
    IF s1 < s2 THEN
        result := -1
    ELSE IF s1 > s2 THEN
        result := 1
    ELSE
        result := 0;
END;

// trier par numéro

FUNCTION PortableListeTriDeux(List: TStringList; Index1, Index2: Integer): Integer;
VAR
    S1, S2: STRING;
    i, j: Integer;
BEGIN
    S1 := List[Index1];
    S2 := List[Index2];
    delete(S1, Pos(';', S1), 255);
    delete(S2, Pos(';', S2), 255);
    i := Strtoint(S1);
    j := Strtoint(S2);
    IF i < j THEN
        result := -1
    ELSE IF i > j THEN
        result := 1
    ELSE
        result := 0;
END;

PROCEDURE TForm1.Button2Click(Sender: TObject);
VAR
    tsl: tstringlist;
    i: integer;
    nb: integer;
    S: STRING;
    s2: STRING;
    AncienCB: STRING;
    Ajout: STRING;
    temps: Dword;
    total: Integer;
    Actu: Integer;
    rest: Integer;
    LeMag: STRING;

    SesID: Integer;
    InvId: Integer;
    LeChrono: STRING;

    NbEnr: Integer;

    PROCEDURE traite_temps;
    VAR
        s: STRING;
    BEGIN
        rest := trunc((gettickcount - temps) / Actu * Total / 1000);
        IF rest > 60 THEN
        BEGIN
            rest := (rest DIV 60) + 1; // Minute
            IF (rest > 60) THEN
            BEGIN
                S := Inttostr((rest MOD 60));
                IF length(s) < 2 THEN s := '0' + s;
                rest := (rest DIV 60); // Heure
                Lab_Temps.Caption := inttostr(rest) + ':' + s + 'h';
            END
            ELSE
                Lab_Temps.Caption := inttostr(rest) + 'm';
        END
        ELSE
            Lab_Temps.Caption := inttostr(rest) + 's';
        Lab_Temps.Update;
    END;

    FUNCTION unId: Integer;
    BEGIN
        GenId.Close;
        GenId.Prepare;
        GenId.execProc;
        result := GenId.ParamByName('INVID').AsInteger;
        GenId.Close;
        GenId.UnPrepare;
    END;

    PROCEDURE COMMIT;
    BEGIN
        IF tran.InTransaction THEN
            Tran.commit;
        tran.Active := true;
    END;

BEGIN
    InvId := Integer(Lb.items.objects[Lb.itemIndex]);
    LeMag := Lesmag[Lb.itemIndex];
    SesId := UnId;
    Chrono.Close;
    Chrono.Prepare;
    Chrono.ExecProc;
    LeChrono := Chrono.ParamByName('NEWNUM').AsString;
    Chrono.Close;
    Chrono.UnPrepare;

    tsl := tstringlist.create;
    rechCb.Prepare;
    ArtExiste.Prepare;
    TRY
        tsl.loadfromfile(ed_fichier.text);

        INS_ENTETE.ParamByName('SESID').Asinteger := SesId;
        INS_ENTETE.ParamByName('INVID').Asinteger := INVId;
        INS_ENTETE.ParamByName('CHRONO').AsString := LeCHRONO;
        INS_ENTETE.ExecSQL;
        COMMIT;

        INS_Lignes.Prepare;
        INS_Lignes.ParamByName('SESID').Asinteger := SesId;

        temps := GetTickCount;
        total := tsl.count * 8;
        Actu := 0;
        FOR i := 0 TO tsl.count - 1 DO
        BEGIN
            s := tsl[i];
            IF pos(';', S) > 0 THEN
            BEGIN
                tsl[i] := inttostr(i + 1) + ';' + Tsl[i];
            END
            ELSE
            BEGIN
                nb := Strtoint(copy(S, 14, 4));
                tsl[i] := inttostr(i + 1) + ';' + copy(s, 1, 13) + ';' + Inttostr(nb);
            END;
        END;
        lab_status.Caption := 'tri par code barre'; lab_status.Update;
        // on le tri par CB
        tsl.CustomSort(PortableListeTriUn);
        AncienCB := '';
        Ajout := '';
        lab_status.Caption := 'Recherche des articles'; lab_status.Update;
        Bar.PartsComplete := 0;
        Bar.TotalParts := tsl.count;
        Bar.Visible := true;
        Update;
        FOR i := 0 TO tsl.count - 1 DO
        BEGIN
            Inc(Actu, 7);
            Nb := Bar.Percent;
            Bar.PartsComplete := i;
            IF nb <> Bar.Percent THEN
            BEGIN
                Bar.Update;
                traite_temps;
            END;
            IF Actu MOD 350 = 0 THEN
                traite_temps;
            S := tsl[i];
            delete(s, 1, pos(';', S));
            s := copy(S, 1, pos(';', S) - 1);
            IF S <> AncienCB THEN
            BEGIN
                IF trim(s) = '' THEN
                BEGIN
                    Ajout := '3;0;0;0;0';
                END
                ELSE
                BEGIN
                    rechCb.close;
                    rechCb.ParamByName('RECH').AsString := S;
                    rechCb.Open;
                    IF rechCb.IsEmpty THEN
                    BEGIN
                        Ajout := '3;0;0;0;0';
                    END
                    ELSE IF rechCb.recordcount <> 1 THEN
                    BEGIN
                        Ajout := '4;0;0;0;0';
                    END
                    ELSE
                    BEGIN
                        TrouveID.Close;
                        TrouveID.ParamByName('INVID').AsInteger := InvId;
                        TrouveID.ParamByName('ARTID').AsInteger := RechCbARF_ARTID.AsInteger;
                        TrouveID.ParamByName('COUID').AsInteger := RechCbCBI_COUID.AsInteger;
                        TrouveID.ParamByName('TGFID').AsInteger := RechCbCBI_TGFID.AsInteger;
                        TrouveID.Open;
                        IF TrouveIDINL_ID.AsString = '' THEN
                        BEGIN
                            AjoutArt.ParamByName('MAGID').AsString := LeMag;
                            AjoutArt.ParamByName('INVID').AsInteger := InvId;
                            AjoutArt.ParamByName('ARTID').AsInteger := RechCbARF_ARTID.AsInteger;
                            AjoutArt.ParamByName('LADATE').AsDateTime := DATE;
                            AjoutArt.ExecProc;
                            TrouveID.Close;
                            TrouveID.ParamByName('INVID').AsInteger := InvId;
                            TrouveID.ParamByName('ARTID').AsInteger := RechCbARF_ARTID.AsInteger;
                            TrouveID.ParamByName('COUID').AsInteger := RechCbCBI_COUID.AsInteger;
                            TrouveID.ParamByName('TGFID').AsInteger := RechCbCBI_TGFID.AsInteger;
                            TrouveID.Open;
                        END;
                        Ajout := RechCbARF_ARTID.AsString + ';' +
                            RechCbCBI_TGFID.AsString + ';' +
                            RechCbCBI_COUID.AsString + ';' + TrouveIDINL_ID.AsString;
                        TrouveID.Close;
                        ArtExiste.Close;
                        ArtExiste.ParamByName('INVID').AsInteger := InvId;
                        ArtExiste.ParamByName('ARTID').AsInteger := RechCbARF_ARTID.AsInteger;
                        ArtExiste.Open;
                        IF ArtExisteNBR.AsInteger = 0 THEN
                            Ajout := '2;' + Ajout
                        ELSE
                        BEGIN
                            Ajout := '1;' + Ajout;
                        END;
                        ArtExiste.Close;
                    END;
                    rechCb.Close;
                END;
            END;
            AncienCB := S;
            Tsl[i] := tsl[i] + ';' + Ajout;
        END;
        Bar.Visible := false;
        Update;
        // on remet dans l'ordre
        lab_status.Caption := 'Remise en ordre'; lab_status.Update;
        tsl.CustomSort(PortableListeTrideux);
        lab_status.Caption := 'Intégration des articles'; lab_status.Update;
        NbEnr := 0;
        Bar.PartsComplete := 0;
        Bar.TotalParts := tsl.count;
        Bar.Visible := true;
        Update;
        FOR i := 0 TO tsl.count - 1 DO
        BEGIN
            Inc(Actu);
            Nb := Bar.Percent;
            Bar.PartsComplete := i;
            IF nb <> Bar.Percent THEN
            BEGIN
                Bar.Update;
            END;
            IF Actu MOD 100 = 0 THEN
                traite_temps;
            S := Tsl[i];
            Nb := UnId;
            INS_LIGNES.ParamByName('ID').AsInteger := Nb;
            delete(s, 1, pos(';', S));
            S2 := Copy(S, 1, pos(';', S) - 1); // Saisie
            delete(s, 1, pos(';', S));
            INS_LIGNES.ParamByName('SAISIE').AsString := S2;
            S2 := Copy(S, 1, pos(';', S) - 1); // Qtte
            delete(s, 1, pos(';', S));
            INS_LIGNES.ParamByName('QTE').AsString := S2;
            S2 := Copy(S, 1, pos(';', S) - 1); // ARTOK
            delete(s, 1, pos(';', S));
            INS_LIGNES.ParamByName('ARTOK').AsString := S2;
            S2 := Copy(S, 1, pos(';', S) - 1); // ARTID
            delete(s, 1, pos(';', S));
            INS_LIGNES.ParamByName('ARTID').AsString := S2;
            S2 := Copy(S, 1, pos(';', S) - 1); // TGFID
            delete(s, 1, pos(';', S));
            INS_LIGNES.ParamByName('TGFID').AsString := S2;
            S2 := Copy(S, 1, pos(';', S) - 1); // COUID
            delete(s, 1, pos(';', S));
            INS_LIGNES.ParamByName('COUID').AsString := S2;
            IF S = '' THEN
                INS_LIGNES.ParamByName('INLID').AsString := '0'
            ELSE
                INS_LIGNES.ParamByName('INLID').AsString := S;
            INS_LIGNES.ExecSQL;
            inc(NbEnr);
            IF NbEnr > 250 THEN
            BEGIN
                Commit;
                NbEnr := 0;
            END;
        END;
        Commit;
        Bar.Visible := false;
        Update;
        Application.messageBox('Intégration terminée', 'FIN', Mb_Ok);
        close;
    FINALLY
        tsl.free;
    END;
END;

END.

