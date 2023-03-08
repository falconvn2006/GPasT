UNIT Dedouble_dm;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, IBDataset, IB_Components, IB_Process, IB_Script, IBODataset;

TYPE
    TDm_Dedouble = CLASS(TDataModule)
        Que_TABLE: TIBOQuery;
        Que_LSTCHAMPS: TIBOQuery;
        Que_TABLEKTB_ID: TIntegerField;
        Que_TABLEKFLD_NAME: TStringField;
        Que_NBR: TIBOQuery;
        Que_Champs: TIBOQuery;
        Que_ChampsNOM: TStringField;
        IBS_Script: TIB_Script;
        Que_LSTCHAMPSKFLD_NAME: TStringField;
        Que_LSTCHAMPSKTB_NAME: TStringField;
        Que_LSTCHAMPSIDTBL: TStringField;
        Que_Divers: TIBOQuery;
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        FUNCTION Dedouble(TABLE: STRING; ID: Integer; ListeId: TStringList): Integer;
    END;

VAR
    Dm_Dedouble: TDm_Dedouble;

IMPLEMENTATION
{$R *.DFM}
USES
    GinkoiaStd,
    GinkoiaResstr,
    StdUtils,
    Main_Dm;

{ TDm_Dedouble }

FUNCTION TDm_Dedouble.Dedouble(TABLE: STRING; ID: Integer; ListeId: TStringList): Integer;
VAR
    NbrId: ARRAY OF Integer;
    i: Integer;
    j: integer;
    S1: STRING;
    S: STRING;
    VraiID: Integer;

    PROCEDURE Traite_TarClgFourn;
    VAR
        i: integer;
        S1: STRING;
        S2: STRING;
    BEGIN
        // Cas particulier ne conserver que le tarclgfourn du VraiID et supprimer les autres
        IF VraiId <> ID THEN
        BEGIN
            S1 := Inttostr(ID);
            FOR i := 0 TO ListeId.Count - 1 DO
                IF StrToInt(ListeId[i]) <> VRAIID THEN
                    S := S + ',' + ListeId[i];
        END
        ELSE
        BEGIN
            S1 := S;
        END;
        Que_Nbr.Sql.Clear;
        Que_Nbr.Sql.ADD('SELECT CLG_ID');
        Que_Nbr.Sql.ADD('FROM TARCLGFOURN JOIN K ON (k_id=CLG_ID and K_Enabled=1)');
        Que_Nbr.Sql.ADD('WHERE CLG_FOUID IN (' + S1 + ')');
        Que_Nbr.Open;
        S2 := '';
        WHILE NOT Que_Nbr.Eof DO
        BEGIN
            IF S2 = '' THEN
                S2 := Que_Nbr.Fields[0].AsString
            ELSE
                S2 := S2 + ',' + Que_Nbr.Fields[0].AsString;

            IF Length(S2) > 255 THEN
            BEGIN
                IBS_Script.Sql.ADD('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_ENABLED=0, K_DELETED=CURRENT_TIMESTAMP WHERE K_ID IN (' + S2 + ') ;');
                S2 := '';
            END;
            Que_Nbr.Next;
        END;
        Que_Nbr.Close;
        IF S2 <> '' THEN
            IBS_Script.Sql.ADD('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_ENABLED=0, K_DELETED=CURRENT_TIMESTAMP WHERE K_ID IN (' + S2 + ') ;');
        IF VraiId <> ID THEN
        BEGIN
            Que_Nbr.Sql.Clear;
            Que_Nbr.Sql.ADD('SELECT CLG_ID');
            Que_Nbr.Sql.ADD('FROM TARCLGFOURN JOIN K ON (k_id=CLG_ID and K_Enabled=1)');
            Que_Nbr.Sql.ADD('WHERE CLG_FOUID = ' + Inttostr(VRAIID));
            Que_Nbr.Open;
            S2 := '';
            WHILE NOT Que_Nbr.Eof DO
            BEGIN
                IF S2 = '' THEN
                    S2 := Que_Nbr.Fields[0].AsString
                ELSE
                    S2 := S2 + ',' + Que_Nbr.Fields[0].AsString;
                IF length(S2) > 255 THEN
                BEGIN
                    IBS_Script.Sql.ADD('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_UPDATED=CURRENT_TIMESTAMP WHERE K_ID IN (' + S2 + ') ;');
                    IBS_Script.Sql.ADD('UPDATE TARCLGFOURN SET CLG_FOUID=' + Inttostr(ID) + ' WHERE CLG_ID IN (' + S2 + ') ;');
                END;
                Que_Nbr.Next;
            END;
            Que_Nbr.Close;
            // On modifie
            IF s2 <> '' THEN
            BEGIN
                IBS_Script.Sql.ADD('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_UPDATED=CURRENT_TIMESTAMP WHERE K_ID IN (' + S2 + ') ;');
                IBS_Script.Sql.ADD('UPDATE TARCLGFOURN SET CLG_FOUID=' + Inttostr(ID) + ' WHERE CLG_ID IN (' + S2 + ') ;');
            END;
        END;
    END;

    PROCEDURE Traite_ArtMRKFourn;
    BEGIN
        // on ne doit pas créer 2 fois le même enregistrement
        IBS_Script.Sql.Clear;
        Que_Nbr.Sql.Clear;
        Que_Nbr.Sql.ADD('SELECT MIN(FMK_ID),FMK_FOUID, FMK_MRKID');
        Que_Nbr.Sql.ADD('FROM ARTMRKFOURN JOIN K ON (k_ID=FMK_ID and K_ENABLED=1)');
        Que_Nbr.Sql.ADD('WHERE FMK_ID<>0');
        Que_Nbr.Sql.ADD('GROUP BY FMK_FOUID, FMK_MRKID');
        Que_Nbr.Sql.ADD('HAVING COUNT(*)>1');
        Que_Nbr.Open;
        WHILE NOT Que_Nbr.EOF DO
        BEGIN
            Que_Divers.Sql.Clear;
            Que_Divers.Sql.ADD('SELECT FMK_ID');
            Que_Divers.Sql.ADD('FROM ARTMRKFOURN JOIN K ON (k_ID=FMK_ID and K_ENABLED=1)');
            Que_Divers.Sql.ADD('WHERE FMK_ID<>' + Que_Nbr.Fields[0].AsString);
            Que_Divers.Sql.Add('AND FMK_FOUID=' + Que_Nbr.Fields[1].AsString);
            Que_Divers.Sql.Add('AND FMK_MRKID=' + Que_Nbr.Fields[2].AsString);
            Que_Divers.Open;
            WHILE NOT Que_Divers.EOF DO
            BEGIN
                IBS_Script.Sql.Add('UPDATE K SET K_Version=GEN_ID(GENERAL_ID,1),');
                IBS_Script.Sql.Add('K_ENABLED=0, K_DELETED=CURRENT_TIMESTAMP');
                IBS_Script.Sql.Add('WHERE K_ID=' + Que_Divers.FIELDS[0].AsString + ';');
                Que_Divers.Next;
            END;
            Que_Divers.Close;
            Que_Nbr.Next;
        END;
        Que_Nbr.Close;
        IF IBS_Script.Sql.Count > 2 THEN
        BEGIN
            IBS_Script.Sql.Add('COMMIT ;');
            IBS_Script.Execute;
        END;
        // on ne doit pas avoir une seul marque avec deux fournisseur principal
        IBS_Script.Sql.Clear;
        Que_Nbr.Sql.Clear;
        Que_Nbr.Sql.ADD('SELECT MIN(FMK_ID),FMK_MRKID');
        Que_Nbr.Sql.ADD('FROM ARTMRKFOURN JOIN K ON (k_ID=FMK_ID and K_ENABLED=1)');
        Que_Nbr.Sql.ADD('WHERE FMK_ID<>0');
        Que_Nbr.Sql.ADD('  AND FMK_PRIN=1');
        Que_Nbr.Sql.ADD('GROUP BY FMK_MRKID');
        Que_Nbr.Sql.ADD('HAVING COUNT(*)>1');
        Que_Nbr.Open;
        WHILE NOT Que_Nbr.Eof DO
        BEGIN
            Que_Divers.Sql.Clear;
            Que_Divers.Sql.ADD('SELECT FMK_ID');
            Que_Divers.Sql.ADD('FROM ARTMRKFOURN JOIN K ON (k_ID=FMK_ID and K_ENABLED=1)');
            Que_Divers.Sql.ADD('WHERE FMK_ID<>' + Que_Nbr.Fields[0].AsString);
            Que_Divers.Sql.ADD('  AND FMK_PRIN=1');
            Que_Divers.Sql.Add('AND FMK_MRKID=' + Que_Nbr.Fields[1].AsString);
            Que_Divers.Open;
            WHILE NOT Que_Divers.EOF DO
            BEGIN
                IBS_Script.Sql.Add('UPDATE K SET K_Version=GEN_ID(GENERAL_ID,1),');
                IBS_Script.Sql.Add('K_UPDATED=CURRENT_TIMESTAMP');
                IBS_Script.Sql.Add('WHERE K_ID=' + Que_Divers.FIELDS[0].AsString + ';');
                IBS_Script.Sql.Add('UPDATE ARTMRKFOURN SET FMK_PRIN=0');
                IBS_Script.Sql.Add('WHERE FMK_ID=' + Que_Divers.FIELDS[0].AsString + ';');
                Que_Divers.Next;
            END;
            Que_Divers.Close;
            IF IBS_Script.Sql.Count > 2 THEN
            BEGIN
                IBS_Script.Sql.Add('COMMIT ;');
                IBS_Script.Execute;
            END;
            Que_Nbr.next;
        END;
        Que_Nbr.Close;
    END;

BEGIN
    ListeId.Sort;
    i := 0;
    WHILE i < ListeId.Count DO
    BEGIN
        IF ListeId[i] = Inttostr(ID) THEN
            ListeId.Delete(i)
        ELSE IF (i < ListeId.Count - 1) AND (ListeId[i] = ListeId[i + 1]) THEN
            ListeId.Delete(i)
        ELSE
            inc(i);
    END;
    IF listeId.Count > 0 THEN
    BEGIN
        VraiID := ID;
        Que_TABLE.ParamByName('LATABLE').AsString := Uppercase(Table);
        Que_TABLE.Open;
        Que_LSTCHAMPS.ParamByName('LID').AsString := Que_TABLEKFLD_NAME.AsString;
        Que_LSTCHAMPS.Open;
        SetLength(NbrId, ListeId.Count + 1);
        FOR i := 0 TO high(NbrId) DO
            Nbrid[i] := 0;
        Que_LSTCHAMPS.First;
        WHILE NOT Que_LSTCHAMPS.Eof DO
        BEGIN
            Que_Nbr.Sql.Clear;
            Que_Nbr.Sql.ADD('SELECT COUNT(*) NBR');
            Que_Nbr.Sql.ADD('FROM ' + Que_LSTCHAMPSKTB_NAME.AsString);
            Que_Nbr.Sql.ADD('WHERE ' + Que_LSTCHAMPSKFLD_NAME.AsString + ' = :LID');
            Que_Nbr.Prepared := true;
            Que_Nbr.ParamByName('LID').AsInteger := ID;
            Que_Nbr.Open;
            NBRID[0] := NBRID[0] + Que_Nbr.fields[0].AsInteger;
            Que_Nbr.Close;
            FOR i := 0 TO ListeId.Count - 1 DO
            BEGIN
                Que_Nbr.ParamByName('LID').AsString := ListeId[i]; ;
                Que_Nbr.Open;
                NBRID[i + 1] := NBRID[i + 1] + Que_Nbr.fields[0].AsInteger;
                Que_Nbr.Close;
            END;
            Que_Nbr.Prepared := False;
            Que_LSTCHAMPS.Next;
        END;
        J := 0;
        FOR i := 1 TO High(NbrId) DO
            IF NbrId[j] < NbrId[i] THEN
                J := I;
        IF J <> 0 THEN
        BEGIN
            // L'enregistrement à sauvegarder N'est pas le maitre
            // Dans ce cas on copy Le maitre dans L'autre et on les échanges
            IBS_Script.Sql.Clear;
            IBS_Script.Sql.Add('UPDATE ' + Uppercase(Table));
            IBS_Script.Sql.Add('SET ');
            Que_Champs.ParamByName('LATABLE').AsString := Uppercase(Table);
            Que_Champs.ParamByName('LID').AsString := Que_TABLEKFLD_NAME.AsString;
            Que_Champs.Open;
            Que_Champs.First;
            WHILE NOT Que_Champs.Eof DO
            BEGIN
                S := Que_ChampsNOM.AsString + ' = (Select ' + Que_ChampsNOM.AsString + ' FROM ' + Uppercase(Table) + ' WHERE ' + Que_TABLEKFLD_NAME.AsString + ' = ' + Inttostr(ID) + ')';
                Que_Champs.Next;
                IF NOT Que_Champs.Eof THEN
                    S := S + ',';
                IBS_Script.Sql.Add(S);
            END;
            Que_Champs.close;
            IBS_Script.Sql.Add('WHERE ' + Que_TABLEKFLD_NAME.AsString + ' = ' + ListeId[j - 1] + ';');
            IBS_Script.Sql.Add('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_UPDATED=CURRENT_TIMESTAMP WHERE K_ID = ' + ListeId[j - 1] + ' ;');
            IBS_Script.Sql.Add('COMMIT ;');
            IBS_Script.Execute;
            I := StrToInt(ListeId[j]);
            ListeId[j] := Inttostr(ID);
            ID := I;
        END;
        // Le champs ID est la référence maitre
        // on update tous les champs concernée par L'ID
        S := ListeId[0];
        FOR i := 1 TO ListeId.Count - 1 DO
            S := S + ',' + ListeId[i];
        Que_LSTCHAMPS.First;
        IBS_Script.Sql.Clear;
        WHILE NOT Que_LSTCHAMPS.Eof DO
        BEGIN
            IF (Que_LSTCHAMPSKTB_NAME.AsString = 'TARCLGFOURN') AND
                (Uppercase(TABLE) = 'ARTFOURN') THEN
            BEGIN
                // Cas particulier
                Traite_TarClgFourn;
            END
            ELSE
            BEGIN
                Que_Nbr.Sql.Clear;
                Que_Nbr.Sql.ADD('SELECT ' + Que_LSTCHAMPSIDTBL.AsString);
                Que_Nbr.Sql.ADD('FROM ' + Que_LSTCHAMPSKTB_NAME.AsString);
                Que_Nbr.Sql.ADD('WHERE ' + Que_LSTCHAMPSKFLD_NAME.AsString + ' in (' + S + ')');
                Que_Nbr.Open;
                S1 := '';
                WHILE NOT Que_Nbr.EOF DO
                BEGIN
                    IF S1 = '' THEN
                        S1 := Que_Nbr.Fields[0].AsString
                    ELSE
                        S1 := S1 + ',' + Que_Nbr.Fields[0].AsString;
                    IF Length(S1) > 255 THEN
                    BEGIN
                        IBS_Script.Sql.ADD('UPDATE ' + Que_LSTCHAMPSKTB_NAME.AsString);
                        IBS_Script.Sql.ADD('SET ' + Que_LSTCHAMPSKFLD_NAME.AsString + ' = ' + Inttostr(ID));
                        IBS_Script.Sql.ADD('WHERE ' + Que_LSTCHAMPSIDTBL.AsString + ' IN (' + S1 + '); ');
                        IBS_Script.Sql.Add('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_UPDATED=CURRENT_TIMESTAMP WHERE K_ID IN (' + S1 + ') ;');
                        S1 := '';
                    END;
                    Que_Nbr.Next;
                END;
                Que_Nbr.Close;
                IF S1 <> '' THEN
                BEGIN
                    IBS_Script.Sql.ADD('UPDATE ' + Que_LSTCHAMPSKTB_NAME.AsString);
                    IBS_Script.Sql.ADD('SET ' + Que_LSTCHAMPSKFLD_NAME.AsString + ' = ' + Inttostr(ID));
                    IBS_Script.Sql.ADD('WHERE ' + Que_LSTCHAMPSIDTBL.AsString + ' IN (' + S1 + '); ');
                    IBS_Script.Sql.Add('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_UPDATED=CURRENT_TIMESTAMP WHERE K_ID IN (' + S1 + ') ;');
                END;
            END;
            Que_LSTCHAMPS.Next;
        END;
        IF IBS_Script.Sql.Count > 2 THEN
        BEGIN
            IBS_Script.Sql.Add('COMMIT ;');
            IBS_Script.Execute;
        END;
        Que_LSTCHAMPS.First;
        WHILE NOT Que_LSTCHAMPS.Eof DO
        BEGIN
            // Tester les tables particulières
            IF Uppercase(Que_LSTCHAMPSKTB_NAME.AsString) = 'ARTMRKFOURN' THEN
            BEGIN
                Traite_ArtMRKFourn;
            END;
            Que_LSTCHAMPS.Next;
        END;
        Que_LSTCHAMPS.Close;
        IBS_Script.Sql.Clear;
        // Modif de la table de référence
        Que_Nbr.Sql.Clear;
        Que_Nbr.Sql.ADD('SELECT IMP_ID');
        Que_Nbr.Sql.ADD('FROM  GENIMPORT');
        Que_Nbr.Sql.ADD('WHERE IMP_GINKOIA IN  (' + S + ')');
        Que_Nbr.Sql.ADD('  AND IMP_KTBID = ' + Que_TABLEKTB_ID.AsString);
        Que_Nbr.Open;
        S1 := '';
        WHILE NOT Que_Nbr.EOF DO
        BEGIN
            IF S1 = '' THEN
                S1 := Que_Nbr.Fields[0].AsString
            ELSE
                S1 := S1 + ',' + Que_Nbr.Fields[0].AsString;
            Que_Nbr.Next;
        END;
        Que_Nbr.Close;
        IF S1 <> '' THEN
        BEGIN
            IBS_Script.Sql.ADD('UPDATE GENIMPORT');
            IBS_Script.Sql.ADD('SET IMP_GINKOIA = ' + Inttostr(ID));
            IBS_Script.Sql.ADD('WHERE IMP_ID IN (' + S1 + '); ');
            IBS_Script.Sql.Add('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_UPDATED=CURRENT_TIMESTAMP WHERE K_ID IN (' + S1 + ') ;');
        END;

        // enfin supression des enregistrements
        IBS_Script.Sql.Add('UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1), K_ENABLED=0, K_DELETED=CURRENT_TIMESTAMP WHERE K_ID IN (' + S + ') ;');
        IBS_Script.Sql.Add('COMMIT ;');
        IBS_Script.EXECUTE;

        Que_LSTCHAMPS.Close;
        Que_TABLE.Close;
    END;
    result := ID;
END;

END.

