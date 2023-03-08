UNIT TarifTO_frm;

INTERFACE

USES
    inifiles, filectrl,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Buttons, StdCtrls, ComCtrls, Db, IBCustomDataSet, IBQuery, IBDatabase,
    IBUpdateSQL;

TYPE
    TFrm_TarifTO = CLASS(TForm)
        Label1: TLabel;
        Ed_Rep: TEdit;
        od: TOpenDialog;
        Nbt_Od: TSpeedButton;
        Button1: TButton;
        pb: TProgressBar;
        data: TIBDatabase;
        tran: TIBTransaction;
        IBQue_TOPERIOD: TIBQuery;
        IBQue_TOPERIODTOD_KEY: TIntegerField;
        IBQue_TOPERIODTOD_NOM: TIBStringField;
        IBQue_TOPERIODTOD_ACTIF: TIntegerField;
        IBQue_TOFAM: TIBQuery;
        IBQue_TOFAMFAM_KEY: TIntegerField;
        IBQue_TOFAMFAM_NOM: TIBStringField;
        IBQue_TOFAMFAM_ORDRE: TIntegerField;
        IBQue_TODES: TIBQuery;
        IBQue_TODESDES_KEY: TIntegerField;
        IBQue_TODESDES_FAM: TIntegerField;
        IBQue_TODESDES_NOM: TIBStringField;
        IBQue_TODESDES_ORDRE: TIntegerField;
        IBQue_TOCOMPO: TIBQuery;
        IBQue_TOCOMPOCOM_KEY: TIntegerField;
        IBQue_TOCOMPOCOM_DES: TIntegerField;
        IBQue_TOCOMPOCOM_LIB: TIBStringField;
        IBQue_TOCOMPOCOM_ORDRE: TIntegerField;
        IBQue_TOFP: TIBQuery;
        IBQue_TOFPTOP_KEY: TIntegerField;
        IBQue_TOFPTOP_NOM: TIBStringField;
        IBQue_TOFPTOP_FSP: TIntegerField;
        IBQue_TOFPTOP_COMPTA: TIBStringField;
        IBQue_TOFPTOP_NONVISIBLE: TIntegerField;
        IBQue_TOTISTAT: TIBQuery;
        IBQue_TOTISTATTOI_KEY: TIntegerField;
        IBQue_TOTISTATTOI_TO: TIntegerField;
        IBQue_TOTISTATTOI_PER: TIntegerField;
        IBQue_TOTISTATTOI_NOM: TIBStringField;
        IBQue_TOTISTATTOI_COM: TIBStringField;
        IBQue_ProcNeoCle: TIBQuery;
        IBQue_ProcNeoCleLACLE: TIntegerField;
        IBQue_TOSAIS: TIBQuery;
        IBQue_TOSAISTOA_KEY: TIntegerField;
        IBQue_TOSAISTOA_TO: TIntegerField;
        IBQue_TOSAISTOA_PER: TIntegerField;
        IBQue_TOSAISTOA_NOM: TIBStringField;
        IBQue_TOSAISTOA_COM: TIBStringField;
        IBQue_TOSAISDATE: TIBQuery;
        IBQue_TOSAISDATETOD_KEY: TIntegerField;
        IBQue_TOSAISDATETOD_TOAKEY: TIntegerField;
        IBQue_TOSAISDATETOD_DEBUT: TDateTimeField;
        IBQue_TOSAISDATETOD_FIN: TDateTimeField;
        IBQue_TOTOPROD: TIBQuery;
        IBQue_TOTOPRODTOO_KEY: TIntegerField;
        IBQue_TOTOPRODTOO_TO: TIntegerField;
        IBQue_TOTOPRODTOO_PER: TIntegerField;
        IBQue_TOTOPRODTOO_SED: TIntegerField;
        IBQue_TOTOPRODTOO_NOM: TIBStringField;
        IBQue_TOTARIF: TIBQuery;
        IBQue_TOTARIFTAR_KEY: TIntegerField;
        IBQue_TOTARIFTAR_TO: TIntegerField;
        IBQue_TOTARIFTAR_PER: TIntegerField;
        IBQue_TOTARIFTAR_TOOKEY: TIntegerField;
        IBQue_TOTARIFTAR_TOIKEY: TIntegerField;
        IBQue_TOTARIFTAR_TOAKEY: TIntegerField;
        IBQue_TOTARIFTAR_COMDUREE: TIBStringField;
        IBQue_TOTARIFTAR_PXTO: TFloatField;
        IBQue_TOTARIFTAR_PXADH: TFloatField;
        IBQue_TOTARIFTAR_DUREE: TFloatField;
        IBU_TOSAISDATE: TIBUpdateSQL;
        IBU_TOTISTAT: TIBUpdateSQL;
        IBU_TOSAIS: TIBUpdateSQL;
        IBU_TOTOPROD: TIBUpdateSQL;
        IBU_TOTARIF: TIBUpdateSQL;
        PROCEDURE Nbt_OdClick(Sender: TObject);
        PROCEDURE Ed_RepExit(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
    PRIVATE
        PROCEDURE VideTraite;
        FUNCTION NewId: Integer;
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        ATraiter: Tlist;
    END;

    TUnePeriode = CLASS
        NomPeriode: STRING;
        Du: STRING;
        Au: STRING;

        TOA_KEY: Integer;
        TOD_KEY: Integer;
    END;

    TNomenclature = CLASS
        Ray, Fam, SSF, LIB: STRING;
        PRIX: ARRAY[0..20] OF double;

        FAM_KEY: Integer;
        DES_KEY: Integer;
        COM_KEY: Integer;
        TOO_KEY: Integer;
    END;

    TLaStructure = CLASS
        Etat: Integer; // 0 non traité 1 OK -x erreur
        nomfichier: STRING;
        nomTO: STRING;
        NomgroupeTarif: STRING;
        PeriodeTarif: Tlist;
        Nomenclature: Tlist;
        NbrTaille: Integer;
        LesTailles: ARRAY[0..20] OF STRING;

        TOP_KEY: Integer;
        TOI_KEY: Integer;
        PROCEDURE TraiteFichier;
        CONSTRUCTOR Create;
        DESTRUCTOR destroy; OVERRIDE;
        PROCEDURE ecrit_lisible(tsl: tstringlist);
    END;

VAR
    Frm_TarifTO: TFrm_TarifTO;

IMPLEMENTATION
{$R *.DFM}
USES
    ChxPeriod_frm;

PROCEDURE TFrm_TarifTO.Nbt_OdClick(Sender: TObject);
BEGIN
    IF od.execute THEN
    BEGIN
        Ed_Rep.text := IncludeTrailingBackslash(extractfilepath(od.filename));
    END;
END;

PROCEDURE TFrm_TarifTO.Ed_RepExit(Sender: TObject);
BEGIN
    Ed_Rep.text := IncludeTrailingBackslash(Ed_Rep.text);
END;

{ TLaStructure }

CONSTRUCTOR TLaStructure.Create;
BEGIN
    INHERITED create;
    nomfichier := '';
    nomTO := '';
    NomgroupeTarif := '';
    PeriodeTarif := Tlist.create;
    Nomenclature := Tlist.Create;
    Etat := 0;
END;

DESTRUCTOR TLaStructure.destroy;
VAR
    i: integer;
BEGIN
    FOR i := 0 TO PeriodeTarif.Count - 1 DO
        TUnePeriode(PeriodeTarif[i]).free;
    FOR i := 0 TO Nomenclature.Count - 1 DO
        TNomenclature(Nomenclature[i]).free;
    PeriodeTarif.free;
    Nomenclature.free;
    INHERITED;
END;

PROCEDURE TFrm_TarifTO.FormCreate(Sender: TObject);
VAR
    ini: Tinifile;
BEGIN
    ATraiter := Tlist.create;
    ini := Tinifile.Create(ChangeFileExt(Application.exename, '.ini'));
    Ed_Rep.text := ini.readstring('DIVERS', 'CHEMIN', '');
    data.databasename := ini.readstring('DIVERS', 'BASE', '');
    ini.free;
END;

PROCEDURE TFrm_TarifTO.VideTraite;
VAR
    i: integer;
BEGIN
    FOR i := 0 TO ATraiter.count - 1 DO
        TLaStructure(ATraiter[i]).free;
    ATraiter.Clear;
END;

PROCEDURE TFrm_TarifTO.FormDestroy(Sender: TObject);
VAR
    ini: Tinifile;
BEGIN
    ini := Tinifile.Create(ChangeFileExt(Application.exename, '.ini'));
    ini.Writestring('DIVERS', 'CHEMIN', Ed_Rep.text);
    ini.free;
    videTraite;
    ATraiter.free;
END;

PROCEDURE TLaStructure.ecrit_lisible(tsl: tstringlist);
VAR
    i, j: integer;
    TP: TUnePeriode;
    TN: TNomenclature;
    S: STRING;

BEGIN
    tsl.add(nomfichier);
    tsl.add('etat : ' + Inttostr(etat));
    tsl.add('TO : ' + nomTO);
    tsl.add('group tarif ' + NomgroupeTarif);
    tsl.add('nbr taille : ' + Inttostr(NbrTaille));
    FOR i := 0 TO PeriodeTarif.Count - 1 DO
    BEGIN
        tp := TUnePeriode(PeriodeTarif[i]);
        tsl.add(tp.NomPeriode + '  ' + tp.Du + '   ' + tp.Au);
    END;
    S := 'Les Tailles  ';
    FOR i := 0 TO NbrTaille - 1 DO
        S := S + LesTailles[i] + ' //  ';
    tsl.add(S);
    FOR i := 0 TO Nomenclature.Count - 1 DO
    BEGIN
        TN := TNomenclature(Nomenclature[i]);
        S := tn.Ray + ' // ' + tn.Fam + ' // ' + tn.SSF + ' // ' + tn.LIB + ' // ';
        FOR j := 0 TO NbrTaille - 1 DO
            S := S + FloatToStr(tn.prix[j]) + ' //  ';
        tsl.add(S);
    END;
END;

PROCEDURE TLaStructure.TraiteFichier;
VAR
    tsl: tstringlist;
    s: STRING;
    PlNomGroupe: Integer;
    TUP: TUnePeriode;
    NomPtarif: STRING;
    S_1: STRING;
    S_2: STRING;
    S_3: STRING;
    lestaillenbr: ARRAY[0..20] OF Integer;
    _Ray, _Fam, _SSF, _LIB: STRING;
    plR, PLF, PLsf, PLl: Integer;
    TN: TNomenclature;
    i, j, k: Integer;
    ok: Boolean;
BEGIN
    tsl := tstringlist.create;
    TRY
        tsl.loadfromfile(nomfichier);
        tsl.delete(0);
        i := 0;
        WHILE i < tsl.Count DO
        BEGIN
            S := Tsl[i];
            IF pos('"', S) > 0 THEN
            BEGIN
                delete(S, pos('"', S), 1);
                WHILE pos('"', S) <= 0 DO
                BEGIN
                    S := S + ' ' + Tsl[i + 1];
                    tsl.delete(i + 1);
                    tsl[i] := S;
                END;
                // on l'enleve et on continue
                delete(S, pos('"', S), 1);
                tsl[i] := S;
            END
            ELSE
                inc(i);
        END;
        // Recherche du nom TO (1° ligne non vide)
        WHILE (tsl.Count > 0) DO
        BEGIN
            S := Tsl[0];
            tsl.delete(0);
            WHILE (length(S) > 0) AND (S[1] = ';') DO
                delete(S, 1, 1);
            IF length(s) > 0 THEN
            BEGIN
                s := trim(Copy(S, 1, pos(';', S) - 1));
                IF s <> '' THEN
                    NomTO := S
                ELSE
                    etat := -1;
                BREAK;
            END;
        END;
        IF tsl.Count = 0 THEN
        BEGIN
            etat := -1;
            EXIT;
        END;

        // recherche du groupe Tarif
        WHILE (tsl.Count > 0) DO
        BEGIN
            S := Tsl[0];
            tsl.delete(0);
            WHILE (length(S) > 0) AND (S[1] = ';') DO
                delete(S, 1, 1);
            IF length(s) > 0 THEN
            BEGIN
                s := trim(Copy(S, 1, pos(';', S) - 1));
                IF s <> '' THEN
                    NomgroupeTarif := S
                ELSE
                    etat := -2;
                BREAK;
            END;
        END;
        IF tsl.Count = 0 THEN
        BEGIN
            etat := -2;
            EXIT;
        END;

        //Recherche 1°ligne de période
        WHILE (tsl.Count > 0) DO
        BEGIN
            S := Tsl[0];
            WHILE (length(S) > 0) AND (S[1] = ';') DO
                delete(S, 1, 1);
            IF length(s) > 0 THEN
            BEGIN
                BREAK;
            END;
            tsl.delete(0);
        END;
        IF tsl.Count = 0 THEN
        BEGIN
            etat := -3;
            EXIT;
        END;

        S := Tsl[0];
        PlNomGroupe := 0;
        NomPtarif := '';

        WHILE (length(S) > 0) AND (S[1] = ';') DO
        BEGIN
            Inc(PlNomGroupe);
            delete(S, 1, 1);
        END;

        IF Uppercase(Copy(S, 1, Pos(';', S) - 1)) = Uppercase('libellé chez le TO') THEN
        BEGIN
            etat := -4;
            EXIT;
        END;

        REPEAT
            S := Tsl[0];
            WHILE (length(S) > 0) AND (S[1] = ';') DO
                delete(S, 1, 1);
            IF trim(S) <> '' THEN
            BEGIN
                IF Uppercase(Copy(S, 1, Pos(';', S) - 1)) = Uppercase('libellé chez le TO') THEN
                    BREAK;
                S := Tsl[0];
                FOR i := 1 TO PlNomGroupe DO
                    delete(S, 1, 1);
                S_1 := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                IF trim(s_1) = '' THEN
                    S_1 := NomPtarif
                ELSE
                    NomPtarif := S_1;
                REPEAT
                    WHILE (length(s) > 0) AND (S[1] = ';') DO
                        delete(S, 1, 1);
                    IF length(s) = 0 THEN
                    BEGIN
                        etat := -5;
                        EXIT;
                    END;
                    S_2 := Copy(S, 1, pos(';', S) - 1);
                    delete(S, 1, pos(';', S));
                UNTIL length(s_2) = 10;
                REPEAT
                    WHILE (length(s) > 0) AND (S[1] = ';') DO
                        delete(S, 1, 1);
                    IF length(s) = 0 THEN
                    BEGIN
                        etat := -5;
                        EXIT;
                    END;
                    IF pos(';', S) > 0 THEN
                    BEGIN
                        S_3 := Copy(S, 1, pos(';', S) - 1);
                        delete(S, 1, pos(';', S));
                    END
                    ELSE
                    BEGIN
                        S_3 := S;
                        S := '';
                    END;
                UNTIL length(s_3) = 10;
                TUP := TUnePeriode.Create;
                PeriodeTarif.Add(tup);
                tup.NomPeriode := S_1;
                tup.Du := S_2;
                tup.Au := S_3;
                TRY
                    StrtoDate(tup.Du);
                EXCEPT
                    etat := -99;
                    EXIT;
                END;
                TRY
                    StrtoDate(tup.au);
                EXCEPT
                    etat := -98;
                    EXIT;
                END;
            END;
            tsl.delete(0);
        UNTIL tsl.count = 0;
        IF tsl.count = 0 THEN
        BEGIN
            etat := -6;
            EXIT;
        END;

        // recherche des tailles
        NbrTaille := 0;
        S := Tsl[0];
        i := 0;
        WHILE s[1] = ';' DO
        BEGIN
            delete(S, 1, 1);
            inc(i);
        END;
        Delete(S, 1, Pos(';', S));
        inc(i);
        REPEAT
            WHILE (length(s) > 0) AND (S[1] = ';') DO
            BEGIN
                delete(s, 1, 1);
                inc(i);
            END;
            IF trim(s) <> '' THEN
            BEGIN
                lestaillenbr[nbrTaille] := i;
                IF pos(';', S) > 0 THEN
                    S_1 := Copy(S, 1, Pos(';', S) - 1)
                ELSE
                    S_1 := S;
                LesTailles[nbrTaille] := S_1;
                inc(nbrTaille);
                Inc(i);
                IF pos(';', S) > 0 THEN
                    delete(S, 1, Pos(';', S))
                ELSE
                    S := '';
            END;
        UNTIL trim(s) = '';
        tsl.delete(0);
        _Ray := ''; _Fam := ''; _SSF := ''; _LIB := '';
        plR := -1; PLF := 0; PLsf := 0; PLl := 0;
        WHILE tsl.count > 0 DO
        BEGIN
            S := tsl[0];
            WHILE (length(s) > 0) AND (S[1] = ';') DO
                delete(S, 1, 1);
            IF trim(s) <> '' THEN
            BEGIN
                IF plR < 0 THEN
                BEGIN
                    S := tsl[0];
                    plr := 0;
                    WHILE (trim(s) <> '') AND (S[1] = ';') DO
                    BEGIN
                        delete(s, 1, 1);
                        inc(plr);
                    END;
                    IF trim(s) = '' THEN
                    BEGIN
                        etat := -7;
                        EXIT;
                    END;
                    delete(s, 1, Pos(';', S));
                    plf := plr + 1;
                    WHILE (trim(s) <> '') AND (S[1] = ';') DO
                    BEGIN
                        delete(s, 1, 1);
                        inc(plf);
                    END;
                    IF trim(s) = '' THEN
                    BEGIN
                        etat := -7;
                        EXIT;
                    END;
                    delete(s, 1, Pos(';', S));
                    PlSf := PlF + 1;
                    WHILE (trim(s) <> '') AND (S[1] = ';') DO
                    BEGIN
                        delete(s, 1, 1);
                        inc(plsf);
                    END;
                    IF trim(s) = '' THEN
                    BEGIN
                        etat := -7;
                        EXIT;
                    END;
                    delete(s, 1, Pos(';', S));
                    PlL := PlSf + 1;
                    WHILE (trim(s) <> '') AND (S[1] = ';') DO
                    BEGIN
                        delete(s, 1, 1);
                        inc(pLl);
                    END;
                    IF trim(s) = '' THEN
                    BEGIN
                        etat := -7;
                        EXIT;
                    END;
                END;
                S := tsl[0];
                FOR i := 1 TO plr DO
                    delete(S, 1, pos(';', S));
                IF trim(copy(S, 1, pos(';', S) - 1)) <> '' THEN
                    _Ray := trim(copy(S, 1, pos(';', S) - 1));
                S := tsl[0];
                FOR i := 1 TO plf DO
                    delete(S, 1, pos(';', S));
                IF trim(copy(S, 1, pos(';', S) - 1)) <> '' THEN
                    _Fam := trim(copy(S, 1, pos(';', S) - 1));
                S := tsl[0];
                FOR i := 1 TO plsf DO
                    delete(S, 1, pos(';', S));
                IF trim(copy(S, 1, pos(';', S) - 1)) <> '' THEN
                    _SSF := trim(copy(S, 1, pos(';', S) - 1));
                S := tsl[0];
                FOR i := 1 TO pLl DO
                    delete(S, 1, pos(';', S));
                IF trim(copy(S, 1, pos(';', S) - 1)) <> '' THEN
                    _LIB := trim(copy(S, 1, pos(';', S) - 1));
                S := tsl[0];
                ok := False;
                FOR i := 0 TO nbrTaille - 1 DO
                BEGIN
                    S := tsl[0];
                    FOR j := 1 TO lestaillenbr[i] DO
                        delete(S, 1, pos(';', S));
                    S_1 := trim(Copy(S, 1, pos(';', S) - 1));
                    IF trim(s_1) <> '' THEN
                    BEGIN
                        Ok := true;
                        BREAK;
                    END;
                END;

                IF ok THEN
                BEGIN
                    tn := TNomenclature.Create;
                    Nomenclature.Add(tn);
                    tn.Ray := _Ray;
                    tn.Fam := _Fam;
                    tn.SSF := _SSF;
                    tn.LIB := _LIB;
                    IF length(tn.LIB) > 80 THEN
                    BEGIN
                        etat := -101;
                        EXIT;
                    END;
                    FOR i := 0 TO nbrTaille - 1 DO
                    BEGIN
                        S := tsl[0];
                        FOR j := 1 TO lestaillenbr[i] DO
                            delete(S, 1, pos(';', S));
                        IF pos(';',S)>0 then
                          S_1 := trim(Copy(S, 1, pos(';', S) - 1))
                        else
                          S_1 := trim(S) ;
                        k := 1;
                        WHILE (k <= length(S_1)) DO
                        BEGIN
                            IF s_1[k] IN ['0'..'9', ','] THEN
                                inc(k)
                            ELSE IF s_1[k] = '.' THEN
                            BEGIN
                                s_1[k] := ',';
                                inc(k);
                            END
                            ELSE delete(s_1, k, 1);
                        END;
                        TRY
                            IF trim(S_1) = '' THEN
                                tn.PRIX[i] := -999
                            ELSE
                                tn.PRIX[i] := strtofloat(S_1);
                        EXCEPT
                            etat := -8;
                            EXIT;
                        END;
                    END;
                END;
            END;
            tsl.delete(0);
        END;
    FINALLY
        tsl.free;
    END;
END;

PROCEDURE TFrm_TarifTO.Button1Click(Sender: TObject);
VAR
    TLS: TLaStructure;
    i: integer;

    PROCEDURE cherche(chemin: STRING);
    VAR
        f: tsearchrec;
    BEGIN
        IF findfirst(chemin + '*.*', faanyfile, f) = 0 THEN
        BEGIN
            REPEAT
                IF (f.name <> '.') AND (f.name <> '..') THEN
                BEGIN
                    IF f.attr AND fadirectory = fadirectory THEN
                    BEGIN
                        IF (uppercase(f.name) <> 'TRAITER') AND
                            (uppercase(f.name) <> 'BLOQUER') THEN
                            Cherche(chemin + f.name + '\');
                    END
                    ELSE IF uppercase(extractfileext(f.name)) = '.CSV' THEN
                    BEGIN
                        TLS := TLaStructure.create;
                        TLS.nomfichier := chemin + f.name;
                        ATraiter.Add(TLS);
                    END;
                END;
            UNTIL findnext(f) <> 0;
        END;
        findclose(f);
    END;

VAR
    LaStr: TstringList;
    Frm_ChxPeriod: TFrm_ChxPeriod;
    TNo: TNomenclature;
    j, k, l, m: Integer;
    LstErr: STRING;
    TOD_KEY: Integer;
    TUP: TUnePeriode;
    s: STRING;
    Cbon: boolean;
BEGIN
    data.Close;
    data.Open;
    Cbon := true;
    // Vérifier la période
    IBQue_TOPERIOD.Close;
    IBQue_TOPERIOD.Open;
    LstErr := '';
//    IF IBQue_TOPERIOD.recordcount <> 1 THEN
    BEGIN
        Application.createform(TFrm_ChxPeriod, Frm_ChxPeriod);
        TRY
            Frm_ChxPeriod.lb.items.clear;
            IBQue_TOPERIOD.first;
            WHILE NOT (IBQue_TOPERIOD.eof) DO
            BEGIN
                i := IBQue_TOPERIODTOD_KEY.AsInteger;
                Frm_ChxPeriod.lb.items.AddObject(IBQue_TOPERIODTOD_NOM.AsString, Pointer(i));
                IBQue_TOPERIOD.Next;
            END;
            Frm_ChxPeriod.lb.itemIndex := 0;
            IF Frm_ChxPeriod.showmodal <> MrOk THEN
                EXIT;
            TOD_KEY := Integer(Frm_ChxPeriod.lb.items.Objects[Frm_ChxPeriod.lb.itemIndex]);
        FINALLY
            Frm_ChxPeriod.release;
        END;
    END ;
//    ELSE TOD_KEY := IBQue_TOPERIODTOD_KEY.AsInteger;

    IF trim(ed_rep.text) <> '' THEN
    BEGIN
        LaStr := TstringList.Create;
        cherche(Ed_Rep.text);
        pb.Position := 0;
        pb.max := Atraiter.count;
        FOR i := 0 TO Atraiter.count - 1 DO
        BEGIN
            pb.Position := i + 1;
            TLaStructure(Atraiter[i]).TraiteFichier;
            TLaStructure(Atraiter[i]).ecrit_lisible(LaStr);
            // LaStr.Savetofile (changefileext(TLaStructure(Atraiter[i]).nomfichier,'.txt')) ;
            LaStr.clear;
            IF TLaStructure(Atraiter[i]).Etat < 0 THEN
            BEGIN
                Cbon := false;
                ForceDirectories(ed_rep.text + 'BLOQUER');
                deletefile(ed_rep.text + 'BLOQUER\' + ExtractFileName(TLaStructure(Atraiter[i]).NomFichier));
                Movefile(Pchar(TLaStructure(Atraiter[i]).NomFichier),
                    Pchar(ed_rep.text + 'BLOQUER\' + ExtractFileName(TLaStructure(Atraiter[i]).NomFichier)));
                IF fileexists(ed_rep.text + 'BLOQUER\Raisons.txt') THEN
                    LaStr.LoadFromFile(ed_rep.text + 'BLOQUER\Raisons.txt');
                CASE TLaStructure(Atraiter[i]).Etat OF
                    -1: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas le nom du TO');
                    -2: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas le nom du groupe tarif');
                    -3: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas de période');
                    -4: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas la ligne Libellé chez le TO');
                    -5: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas les dates de période');
                    -6: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas la ligne Libellé chez le TO');
                    -7: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas les libellés de nomenclature');
                    -8: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Erreur dans un des prix');
                    -98: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Erreur dans date de debut d''une période');
                    -99: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Erreur dans date de fin d''une période');
                    -101: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  un libelle est supérieur à 80 caractères ');
                ELSE
                    LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Erreur non référencée');
                END;
                LaStr.SaveToFile(ed_rep.text + 'BLOQUER\Raisons.txt');
            END
            ELSE
            BEGIN
                IBQue_TOFP.close;
                IBQue_TOFP.ParamByName('Nom').AsString := TLaStructure(Atraiter[i]).nomTO;
                IBQue_TOFP.Open;
                IF IBQue_TOFP.IsEmpty THEN
                BEGIN
                    IBQue_TOFP.close;
                    IBQue_TOFP.ParamByName('Nom').AsString := Uppercase(TLaStructure(Atraiter[i]).nomTO);
                    IBQue_TOFP.Open;
                END;
                IF IBQue_TOFP.IsEmpty THEN
                BEGIN
                    TLaStructure(Atraiter[i]).Etat := -12;
                    lsterr := TLaStructure(Atraiter[i]).nomTO;
                END
                ELSE
                BEGIN
                    TLaStructure(Atraiter[i]).TOP_KEY := IBQue_TOFPTOP_KEY.AsInteger;
                END;
                // test de la nomenclature
                IF TLaStructure(Atraiter[i]).Etat = 0 THEN
                BEGIN
                    FOR j := 0 TO TLaStructure(Atraiter[i]).Nomenclature.Count - 1 DO
                    BEGIN
                        TNo := TNomenclature(TLaStructure(Atraiter[i]).Nomenclature[j]);
                        IBQue_TOFAM.Close;
                        IBQue_TOFAM.ParamByName('Nom').AsString := Uppercase(tno.Ray);
                        IBQue_TOFAM.Open;
                        IF IBQue_TOFAM.IsEmpty THEN
                        BEGIN
                            IBQue_TOFAM.Close;
                            IBQue_TOFAM.ParamByName('Nom').AsString := tno.Ray;
                            IBQue_TOFAM.Open;
                        END;
                        IF IBQue_TOFAM.IsEmpty THEN
                        BEGIN
                            LstErr := tno.ray;
                            TLaStructure(Atraiter[i]).etat := -9;
                            BREAK;
                        END;
                        tno.FAM_KEY := IBQue_TOFAMFAM_KEY.AsInteger;
                        IBQue_TODES.Close;
                        IBQue_TODES.ParamByName('FAMID').AsInteger := IBQue_TOFAMFAM_KEY.AsInteger;
                        IBQue_TODES.ParamByName('Nom').AsString := Uppercase(tno.Fam);
                        IBQue_TODES.Open;
                        IF IBQue_TODES.IsEmpty THEN
                        BEGIN
                            IBQue_TODES.Close;
                            IBQue_TODES.ParamByName('Nom').AsString := tno.Fam;
                            IBQue_TODES.Open;
                        END;
                        IF IBQue_TODES.IsEmpty THEN
                        BEGIN
                            LstErr := tno.Fam;
                            TLaStructure(Atraiter[i]).etat := -10;
                            BREAK;
                        END;
                        tno.DES_KEY := IBQue_TODESDES_KEY.AsInteger;
                        IBQue_TOCOMPO.Close;
                        IBQue_TOCOMPO.ParamByName('DESID').AsInteger := IBQue_TODESDES_KEY.AsInteger;
                        IBQue_TOCOMPO.ParamByName('Nom').AsString := Uppercase(tno.SSF);
                        IBQue_TOCOMPO.Open;
                        IF IBQue_TOCOMPO.IsEmpty THEN
                        BEGIN
                            IBQue_TOCOMPO.Close;
                            IBQue_TOCOMPO.ParamByName('Nom').AsString := tno.SSF;
                            IBQue_TOCOMPO.Open;
                        END;
                        IF IBQue_TOCOMPO.IsEmpty THEN
                        BEGIN
                            LstErr := tno.SSF;
                            TLaStructure(Atraiter[i]).etat := -11;
                            BREAK;
                        END;
                        tno.COM_KEY := IBQue_TOCOMPOCOM_KEY.AsInteger;
                    END;
                END;
                IF TLaStructure(Atraiter[i]).Etat < 0 THEN
                BEGIN
                    Cbon := false;
                    ForceDirectories(ed_rep.text + 'BLOQUER');
                    deletefile(ed_rep.text + 'BLOQUER\' + ExtractFileName(TLaStructure(Atraiter[i]).NomFichier));
                    Movefile(Pchar(TLaStructure(Atraiter[i]).NomFichier),
                        Pchar(ed_rep.text + 'BLOQUER\' + ExtractFileName(TLaStructure(Atraiter[i]).NomFichier)));
                    IF fileexists(ed_rep.text + 'BLOQUER\Raisons.txt') THEN
                        LaStr.LoadFromFile(ed_rep.text + 'BLOQUER\Raisons.txt');
                    CASE TLaStructure(Atraiter[i]).Etat OF
                        -9: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas une des familles (' + LstErr + ')');
                        -10: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas une des descriptions (' + LstErr + ')');
                        -11: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas une des compositions (' + LstErr + ')');
                        -12: LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Ne trouve pas le TO (' + LstErr + ')');
                    ELSE
                        LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Erreur non référencée (nomenclature)');
                    END;
                    LaStr.SaveToFile(ed_rep.text + 'BLOQUER\Raisons.txt');
                END
                ELSE
                BEGIN
                  // valider le tarif
                    IF tran.InTransaction THEN
                        tran.rollback;
                    tran.active := true;
                    TRY
                        IBQue_TOTISTAT.Close;
                        IBQue_TOTISTAT.ParamByName('TOP_KEY').AsInteger := TLaStructure(Atraiter[i]).TOP_KEY;
                        IBQue_TOTISTAT.ParamByName('TOD_KEY').AsInteger := TOD_KEY;
                        IBQue_TOTISTAT.ParamByName('Nom').AsString := TLaStructure(Atraiter[i]).NomgroupeTarif;
                        IBQue_TOTISTAT.Open;
                        IF IBQue_TOTISTAT.IsEmpty THEN
                        BEGIN
                            IBQue_TOTISTAT.Close;
                            IBQue_TOTISTAT.ParamByName('Nom').AsString := Uppercase(TLaStructure(Atraiter[i]).NomgroupeTarif);
                            IBQue_TOTISTAT.Open;
                        END;
                        IF IBQue_TOTISTAT.IsEmpty THEN
                        BEGIN
                      // création
                            TLaStructure(Atraiter[i]).TOI_KEY := NewId;
                            IBQue_TOTISTAT.Insert;
                            IBQue_TOTISTATTOI_KEY.Asinteger := TLaStructure(Atraiter[i]).TOI_KEY;
                            IBQue_TOTISTATTOI_TO.AsInteger := TLaStructure(Atraiter[i]).TOP_KEY;
                            IBQue_TOTISTATTOI_PER.AsInteger := TOD_KEY;
                            IBQue_TOTISTATTOI_NOM.AsString := TLaStructure(Atraiter[i]).NomgroupeTarif;
                            IBQue_TOTISTATTOI_COM.AsString := 'Importation tarif TO';
                            IBQue_TOTISTAT.Post;
                        END
                        ELSE
                            TLaStructure(Atraiter[i]).TOI_KEY := IBQue_TOTISTATTOI_KEY.AsInteger;
                        FOR j := 0 TO TLaStructure(Atraiter[i]).PeriodeTarif.Count - 1 DO
                        BEGIN
                            TUP := TUnePeriode(TLaStructure(Atraiter[i]).PeriodeTarif[j]);
                            IBQue_TOSAIS.Close;
                            IBQue_TOSAIS.ParamByName('TOP_KEY').AsInteger := TLaStructure(Atraiter[i]).TOP_KEY;
                            IBQue_TOSAIS.ParamByName('TOD_KEY').AsInteger := TOD_KEY;
                            IBQue_TOSAIS.ParamByName('Nom').AsString := tup.NomPeriode;
                            IBQue_TOSAIS.Open;
                            IF IBQue_TOSAIS.IsEmpty THEN
                            BEGIN
                                IBQue_TOSAIS.Close;
                                IBQue_TOSAIS.ParamByName('Nom').AsString := Uppercase(tup.NomPeriode);
                                IBQue_TOSAIS.Open;
                            END;
                            IF IBQue_TOSAIS.IsEmpty THEN
                            BEGIN
                                tup.TOA_KEY := NewId;
                                IBQue_TOSAIS.Insert;
                                IBQue_TOSAISTOA_KEY.AsInteger := tup.TOA_KEY;
                                IBQue_TOSAISTOA_TO.AsInteger := TLaStructure(Atraiter[i]).TOP_KEY;
                                IBQue_TOSAISTOA_PER.AsInteger := TOD_KEY;
                                IBQue_TOSAISTOA_NOM.AsString := tup.NomPeriode;
                                IBQue_TOSAISTOA_COM.AsString := 'Importation tarif TO';
                                IBQue_TOSAIS.Post;
                            END
                            ELSE
                                tup.TOA_KEY := IBQue_TOSAISTOA_KEY.AsInteger;

                            IBQue_TOSAISDATE.Close;
                            IBQue_TOSAISDATE.ParamByName('TOA_KEY').AsInteger := tup.TOA_KEY;
                            IBQue_TOSAISDATE.ParamByName('DEBUT').AsDateTime := StrtoDate(tup.Du);
                            IBQue_TOSAISDATE.ParamByName('Fin').AsDateTime := StrtoDate(tup.Au);
                            IBQue_TOSAISDATE.Open;
                            IF IBQue_TOSAISDATE.isempty THEN
                            BEGIN
                                tup.TOD_KEY := NewId;
                                IBQue_TOSAISDATE.Insert;
                                IBQue_TOSAISDATETOD_KEY.AsInteger := tup.TOD_KEY;
                                IBQue_TOSAISDATETOD_TOAKEY.AsInteger := tup.TOA_KEY;
                                IBQue_TOSAISDATETOD_DEBUT.AsDateTime := StrtoDate(tup.Du);
                                IBQue_TOSAISDATETOD_FIN.AsDateTime := StrtoDate(tup.Au);
                                IBQue_TOSAISDATE.Post;
                            END
                            ELSE
                                tup.TOD_KEY := IBQue_TOSAISDATETOD_KEY.Asinteger;
                        END;

                        FOR j := 0 TO TLaStructure(Atraiter[i]).Nomenclature.Count - 1 DO
                        BEGIN
                            tno := TNomenclature(TLaStructure(Atraiter[i]).Nomenclature[j]);
                            IBQue_TOTOPROD.Close;
                            IBQue_TOTOPROD.ParamByName('TOP_KEY').AsInteger := TLaStructure(Atraiter[i]).TOP_KEY;
                            IBQue_TOTOPROD.ParamByName('TOD_KEY').AsInteger := TOD_KEY;
                            IBQue_TOTOPROD.ParamByName('COM_KEY').AsInteger := tno.COM_KEY;
                            IBQue_TOTOPROD.ParamByName('Nom').AsString := tno.LIB;
                            IBQue_TOTOPROD.Open;
                            IF IBQue_TOTOPROD.isempty THEN
                            BEGIN
                                IBQue_TOTOPROD.close;
                                IBQue_TOTOPROD.ParamByName('Nom').AsString := uppercase(tno.LIB);
                                IBQue_TOTOPROD.open;
                            END;
                            IF IBQue_TOTOPROD.isempty THEN
                            BEGIN
                                IBQue_TOTOPROD.insert;
                                tno.TOO_KEY := NewId;
                                IBQue_TOTOPRODTOO_KEY.AsInteger := tno.TOO_KEY;
                                IBQue_TOTOPRODTOO_TO.Asinteger := TLaStructure(Atraiter[i]).TOP_KEY;
                                IBQue_TOTOPRODTOO_PER.AsInteger := TOD_KEY;
                                IBQue_TOTOPRODTOO_SED.AsInteger := tno.COM_KEY;
                                IBQue_TOTOPRODTOO_NOM.AsString := tno.LIB;
                                IBQue_TOTOPROD.Post;
                            END
                            ELSE
                                tno.TOO_KEY := IBQue_TOTOPRODTOO_KEY.AsInteger;
                            FOR k := 0 TO TLaStructure(Atraiter[i]).PeriodeTarif.Count - 1 DO
                            BEGIN
                                TUP := TUnePeriode(TLaStructure(Atraiter[i]).PeriodeTarif[K]);
                                FOR l := 0 TO TLaStructure(Atraiter[i]).NbrTaille - 1 DO
                                BEGIN
                                    IF tno.PRIX[l] >= 0 THEN
                                    BEGIN
                                        m := 1;
                                        S := trim(TLaStructure(Atraiter[i]).LesTailles[l]);
                                        WHILE (m <= length(S)) AND (S[m] IN ['0'..'9']) DO
                                            inc(m);
                                        dec(m);
                                        S := Copy(S, 1, m);
                                        IBQue_TOTARIF.Close;
                                        IBQue_TOTARIF.ParamByName('TOP_KEY').AsInteger := TLaStructure(Atraiter[i]).TOP_KEY;
                                        IBQue_TOTARIF.ParamByName('TOD_KEY').AsInteger := TOD_KEY;
                                        IBQue_TOTARIF.ParamByName('TOO_KEY').AsInteger := tno.TOO_KEY;
                                        IBQue_TOTARIF.ParamByName('TOI_KEY').AsInteger := TLaStructure(Atraiter[i]).TOI_KEY;
                                        IBQue_TOTARIF.ParamByName('TOA_KEY').AsInteger := tup.TOA_KEY;
                                        IBQue_TOTARIF.ParamByName('DUREE').AsString := S;
                                        IBQue_TOTARIF.Open;
                                        IF IBQue_TOTARIF.IsEmpty THEN
                                        BEGIN
                                            IBQue_TOTARIF.Insert;
                                            IBQue_TOTARIFTAR_KEY.AsInteger := NewId;
                                            IBQue_TOTARIFTAR_TO.AsInteger := TLaStructure(Atraiter[i]).TOP_KEY;
                                            IBQue_TOTARIFTAR_PER.AsInteger := TOD_KEY;
                                            IBQue_TOTARIFTAR_TOOKEY.AsInteger := tno.TOO_KEY;
                                            IBQue_TOTARIFTAR_TOIKEY.AsInteger := TLaStructure(Atraiter[i]).TOI_KEY;
                                            IBQue_TOTARIFTAR_TOAKEY.AsInteger := tup.TOA_KEY;
                                            IBQue_TOTARIFTAR_COMDUREE.AsString := TLaStructure(Atraiter[i]).LesTailles[l];
                                            IBQue_TOTARIFTAR_DUREE.AsString := S;
                                            IBQue_TOTARIFTAR_PXTO.AsFloat := tno.PRIX[l];
                                            IBQue_TOTARIF.Post;
                                        END
                                        ELSE
                                        BEGIN
                                            IBQue_TOTARIF.Edit;
                                            IBQue_TOTARIFTAR_PXTO.AsFloat := tno.PRIX[l];
                                            IBQue_TOTARIF.Post;
                                        END;
                                    END;
                                END;
                            END;
                        END;
                        IF tran.InTransaction THEN
                            tran.Commit;
                        ForceDirectories(ed_rep.text + 'TRAITER');
                        deletefile(ed_rep.text + 'TRAITER\' + ExtractFileName(TLaStructure(Atraiter[i]).NomFichier));
                        Movefile(Pchar(TLaStructure(Atraiter[i]).NomFichier),
                            Pchar(ed_rep.text + 'TRAITER\' + ExtractFileName(TLaStructure(Atraiter[i]).NomFichier)));
                    EXCEPT
                        tran.RollBack;
                        ForceDirectories(ed_rep.text + 'BLOQUER');
                        deletefile(ed_rep.text + 'BLOQUER\' + ExtractFileName(TLaStructure(Atraiter[i]).NomFichier));
                        Movefile(Pchar(TLaStructure(Atraiter[i]).NomFichier),
                            Pchar(ed_rep.text + 'BLOQUER\' + ExtractFileName(TLaStructure(Atraiter[i]).NomFichier)));
                        IF fileexists(ed_rep.text + 'BLOQUER\Raisons.txt') THEN
                            LaStr.LoadFromFile(ed_rep.text + 'BLOQUER\Raisons.txt');
                        LaStr.Add(TLaStructure(Atraiter[i]).NomFichier + '  Erreur non référencée (base)');
                        LaStr.SaveToFile(ed_rep.text + 'BLOQUER\Raisons.txt');
                    END;
                END;
            END;
        END;
        LaStr.free;
    END;
    IF cbon THEN
        Application.MessageBox('Traitement terminé sans erreur', '  Fin', Mb_Ok)
    ELSE
        Application.MessageBox('Traitement terminé avec erreurs', '  Fin', Mb_Ok);
    pb.position := 0;
    videTraite;
END;

FUNCTION TFrm_TarifTO.NewId: Integer;
BEGIN
    IBQue_ProcNeoCle.Close;
    IBQue_ProcNeoCle.Prepare;
    IBQue_ProcNeoCle.open;
    result := IBQue_ProcNeoCleLACLE.Asinteger;
    IBQue_ProcNeoCle.close;
    IBQue_ProcNeoCle.UnPrepare;
END;

END.

