UNIT UTraiteBase;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    IBDatabase, Db, IBCustomDataSet, IBQuery;
Const
  TaillePacket = 500 ;
TYPE
    TDm_Module = CLASS(TDataModule)
        data: TIBDatabase;
        Tran: TIBTransaction;
        IBQue_Proc: TIBQuery;
        IBQue_EtatTrig: TIBQuery;
        IBQue_Calcul: TIBQuery;
        IBQue_Exec: TIBQuery;
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        erreur: STRING;
        nbpack: Integer;
        Ouvert: boolean;
        FUNCTION initialise(Nom: STRING): Boolean;
        FUNCTION traitement(VAR fini: boolean): boolean;
        PROCEDURE traitementerreur;
        PROCEDURE finalise;
        PROCEDURE startTransaction;
        PROCEDURE rollback;
        PROCEDURE Commit;
    END;

VAR
    Dm_Module: TDm_Module;

IMPLEMENTATION

{$R *.DFM}

{ TDataModule1 }

PROCEDURE TDm_Module.Commit;
BEGIN
    IF tran.InTransaction THEN
        tran.Commit;
END;

PROCEDURE TDm_Module.finalise;
BEGIN
    IF ouvert THEN
    BEGIN
        IBQue_Exec.close;
        WITH IBQue_Exec.sql DO
        BEGIN
            clear;
            Add('execute procedure BN_ACTIVETRIGGER(0)');
        END;
        IBQue_Exec.ExecSQL;
        IF tran.InTransaction THEN
            tran.Commit;
    END;
    Data.close;
END;

FUNCTION TDm_Module.initialise(Nom: STRING): Boolean;
BEGIN
    erreur := '';
    result := true;
    Ouvert := false;
    TRY
        data.databasename := Nom;
        data.Open;
        tran.active := true;
    EXCEPT
        result := false;
        erreur := 'Probleme de connexion a la base ' + Nom;
    END;
    TRY
        IF result THEN
        BEGIN
            Ouvert := true;
            IBQue_Proc.Open; // vérification de la presence de la proc de calcul
            IF IBQue_Proc.Fields[0].AsInteger > 0 THEN
            BEGIN
                IBQue_Proc.Close;
                IBQue_EtatTrig.Open;
                IF IBQue_EtatTrig.Fields[0].AsInteger <> 1 THEN
                BEGIN
                    result := false;
                    erreur := 'trigger non active dans la base ' + Nom;
                END;
            END
            ELSE
            BEGIN
                IBQue_Proc.Close;
                result := false;
                erreur := 'Pas de proc BN_TRIGGERDIFFERE dans la base ' + Nom;
            END;
        END;
    EXCEPT
        result := false;
        erreur := 'Probleme inconnu d''acces a la base ' + Nom;
    END;
    IF result THEN
    BEGIN
        IBQue_Exec.Close;
        WITH IBQue_Exec.sql DO
        BEGIN
            clear;
            Add('select count(*) paquet from gentrigger');
        END;
        IBQue_Exec.Open;
        IF (IBQue_Exec.fields[0].AsInteger > 0) then
           nbpack := trunc(IBQue_Exec.fields[0].AsInteger / TaillePacket) + 1
        ELSE nbpack:=0;
        IBQue_Exec.Close;
    END;
END;

PROCEDURE TDm_Module.rollback;
BEGIN
    IF tran.InTransaction THEN
        tran.rollback;
END;

PROCEDURE TDm_Module.startTransaction;
BEGIN
    IF tran.InTransaction THEN
        tran.Commit;
    tran.active := true;
END;

FUNCTION TDm_Module.traitement(VAR fini: boolean): boolean;
BEGIN
    result := true;
    TRY
        IBQue_Calcul.Close;
        IBQue_Calcul.Open;
        fini := IBQue_Calcul.Fields[0].asinteger = 0;
    EXCEPT
        result := False;
    END;
END;

PROCEDURE TDm_Module.traitementerreur;
VAR
    num: STRING;
    id: STRING;
BEGIN
    IF tran.InTransaction THEN
        tran.Rollback;
    IBQue_Exec.close;
    WITH IBQue_Exec.sql DO
    BEGIN
        clear;
        Add('select Cast(PAR_STRING as Integer) Numero');
        Add('from genparambase');
        Add('Where PAR_NOM=''IDGENERATEUR''');
    END;
    IBQue_Exec.Open;
    num := IBQue_Exec.Fields[0].AsString;
    IBQue_Exec.Close;
    WITH IBQue_Exec.sql DO
    BEGIN
        clear;
        Add('select Bas_ID');
        Add('from GenBases');
        Add('where BAS_ID<>0');
        Add('AND BAS_IDENT=''' + Num + '''');
    END;
    IBQue_Exec.Open;
    num := IBQue_Exec.Fields[0].AsString;
    IBQue_Exec.Close;
    WITH IBQue_Exec.sql DO
    BEGIN
        clear;
        Add('Select NewKey ');
        Add('From PROC_NEWKEY');
    END;
    Id := IBQue_Exec.Fields[0].AsString;
    IBQue_Exec.Close;
    WITH IBQue_Exec.sql DO
    BEGIN
        clear;
        Add('Insert Into GenDossier');
        Add('(DOS_ID, DOS_NOM, DOS_STRING)');
        Add('VALUES (');
        Add(Id + ',' + Num + ', ' + '''Recalc Trigger''');
        Add(')');
    END;
    IBQue_Exec.ExecSQL;
    IF tran.InTransaction THEN
        tran.commit;
    tran.Active := true;
    WITH IBQue_Exec.sql DO
    BEGIN
        clear;
        Add('Insert Into K');
        Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
        Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED,KSE_LOCK_ID, KMA_LOCK_ID )');
        Add('VALUES (');
        Add(ID + ',-101,-11111338,' + Id + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
    END;
    IBQue_Exec.ExecSQL;
    IF tran.InTransaction THEN
        tran.commit;
    tran.Active := true;
    erreur := data.databasename+' probleme de calcul d''un paquet ';
END;

END.

