//$Log:
// 2    Utilitaires1.1         18/08/2006 08:52:48    pascal          empecher
//      la r?plication de la table gentrigger pour ?viter des conflits
// 1    Utilitaires1.0         27/04/2005 10:41:27    pascal          
//$
//$NoKeywords$
//
UNIT UCreationRepli;

INTERFACE

USES
    WinSvc,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls, IBSQL, Buttons;

TYPE
    TForm1 = CLASS(TForm)
        Label1: TLabel;
        Edit1: TEdit;
        Label2: TLabel;
        Edit2: TEdit;
        Button1: TButton;
        DataSrc: TIBDatabase;
        TranSrc: TIBTransaction;
        DataDest: TIBDatabase;
        TranDest: TIBTransaction;
        IBQue_LstTable: TIBQuery;
        IBQue_LstChamp: TIBQuery;
        IBQue_TblExist: TIBQuery;
        IBQue_TblExistRELATIONNO: TIntegerField;
        IBQue_ChpExist: TIBQuery;
        IBQue_ChpExistFIELDNO: TIntegerField;
        sql: TIBSQL;
        IBQue_LstTableNOM: TIBStringField;
        IBQue_LstChampNOMCHAMP: TIBStringField;
        TranLst: TIBTransaction;
        IBQue_ListeBases: TIBQuery;
        IBQue_ListeBasesDBNO: TIntegerField;
        IBQue_ListeRepli: TIBQuery;
        IBQue_ListeRepliREPLNO: TIntegerField;
        IBQue_ListeRepliDBNO: TIntegerField;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        OD: TOpenDialog;
        IBQue_ChpPremExist: TIBQuery;
        IntegerField1: TIntegerField;
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE SpeedButton2Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    prem: boolean;
    REPLNO: STRING;
    DBNO: STRING;
    TGTDBNO: STRING;
BEGIN
    DataSrc.Close;
    DataDest.Close;
    DataSrc.DatabaseName := Edit1.text;
    DataDest.DatabaseName := Edit2.Text;
    DataSrc.Open;
    DataDest.Open;
    TranDest.Active := true;

    IBQue_ListeRepli.Open;
    REPLNO := IBQue_ListeRepliREPLNO.AsString;
    DbNo := IBQue_ListeRepliDBNO.AsString;
    IBQue_ListeRepli.Close;
    IBQue_ListeBases.Open;
    IBQue_ListeBases.First;
    WHILE NOT IBQue_ListeBases.Eof DO
    BEGIN
        IF IBQue_ListeBasesDBNO.AsString <> DBNO THEN
        BEGIN
            TGTDBNO := IBQue_ListeBasesDBNO.AsString;
            BREAK;
        END;
        IBQue_ListeBases.Next;
    END;
    IBQue_ListeBases.Close;
    IBQue_LstTable.Open;
    IBQue_LstTable.First;
    WHILE NOT IBQue_LstTable.eof DO
    BEGIN
        IBQue_TblExist.ParamByName('NOMTABLE').AsString := trim(IBQue_LstTableNOM.ASSTRING);
        IBQue_TblExist.Open;
        IF IBQue_TblExist.recordcount = 0 THEN
        BEGIN
            Sql.sql.clear;
            Sql.sql.ADD('INSERT INTO RELATIONS');
            Sql.sql.ADD('(REPLNO,DBNO,RELATIONNO,RELATIONNAME,COMMENTS,SELECTSQL,DELETESQL,UPDATESQL,INSERTSQL,DISABLED,TIMEFIELDNAME,CONDITION,TGTDBNO,TARGETNAME,TARGETTYPE,INSERTS,UPDATES,DELETES,SECONDS,KEEPSTATS,ERRORS,CONFLICTS)');
            Sql.sql.ADD('VALUES');
            Sql.sql.ADD('(' + REPLNO + ',' + DBNO + ',GEN_ID(RELATIONGEN,1),''' + trim(IBQue_LstTableNOM.ASSTRING) + ''',NULL,'''','''','''','''',''N'',NULL,'''',2,''' + trim(IBQue_LstTableNOM.ASSTRING) + ''',''T'',0,0,0,0,1,0,0)');
            Sql.ExecQuery;
            IF TranDest.InTransaction THEN TranDest.commit;
            TranDest.Active := true;
            IBQue_TblExist.Close;
            IBQue_TblExist.Open;
        END;
        IBQue_LstChamp.ParamByName('NOMTABLE').AsString := trim(IBQue_LstTableNOM.ASSTRING);
        IBQue_LstChamp.Open;
        IBQue_LstChamp.First;
        prem := true;
        WHILE NOT IBQue_LstChamp.Eof DO
        BEGIN
            IF prem THEN
            BEGIN
                IBQue_ChpPremExist.ParamByName('RELATIONNO').AsInteger := IBQue_TblExistRELATIONNO.AsInteger;
                IBQue_ChpPremExist.ParamByName('NOMCHAMPS').AsString := trim(IBQue_LstChampNOMCHAMP.AsString);
                IBQue_ChpPremExist.Open;
                IF IBQue_ChpPremExist.EOF THEN
                BEGIN
                    Sql.sql.clear;
                    Sql.sql.ADD('INSERT INTO RELATIONKEYFIELDS');
                    Sql.sql.ADD('  (REPLNO,DBNO,TGTDBNO,RELATIONNO,FIELDNO,FIELDNAME,TARGETNAME,COMMENTS)');
                    Sql.sql.ADD('VALUES');
                    Sql.sql.ADD('  (' + REPLNO + ',' + DBNO + ',' + TGTDBNO + ',' + IBQue_TblExistRELATIONNO.AsString + ',GEN_ID(FIELDGEN,1),''' + trim(IBQue_LstChampNOMCHAMP.AsString) + ''',''' + trim(IBQue_LstChampNOMCHAMP.AsString) + ''',NULL);');
                    Sql.ExecQuery;
                    IF TranDest.InTransaction THEN TranDest.commit;
                    TranDest.Active := true;
                END;
                IBQue_ChpPremExist.Close;
            END
            ELSE
            BEGIN
                IBQue_ChpExist.ParamByName('RELATIONNO').AsInteger := IBQue_TblExistRELATIONNO.AsInteger;
                IBQue_ChpExist.ParamByName('NOMCHAMPS').AsString := trim(IBQue_LstChampNOMCHAMP.AsString);
                IBQue_ChpExist.Open;
                IF IBQue_ChpExist.recordcount = 0 THEN
                BEGIN
                    Sql.sql.clear;
                    Sql.sql.ADD('INSERT INTO RELATIONREPLFIELDS');
                    Sql.sql.ADD('  (REPLNO,DBNO,RELATIONNO,FIELDNO,FIELDNAME,TGTDBNO,TARGETNAME,COMMENTS)');
                    Sql.sql.ADD('VALUES ');
                    Sql.sql.ADD('(' + REPLNO + ',' + DBNO + ',' + IBQue_TblExistRELATIONNO.AsString + ',GEN_ID(FIELDGEN,1),''' + trim(IBQue_LstChampNOMCHAMP.AsString) + ''',2,''' + trim(IBQue_LstChampNOMCHAMP.AsString) + ''',NULL);');
                    Sql.ExecQuery;
                    IF TranDest.InTransaction THEN TranDest.commit;
                    TranDest.Active := true;
                END;
                IBQue_ChpExist.Close;
            END;
            prem := false;
            IBQue_LstChamp.next;
        END;
        IBQue_LstChamp.Close;
        IBQue_TblExist.Close;
        IBQue_LstTable.next;
    END;
    DataSrc.Close;
    DataDest.Close;
    Application.messageBox('C''EST FINI', 'C''EST FINI', MB_OK);
END;

PROCEDURE TForm1.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        Edit1.text := od.FileName;
END;

PROCEDURE TForm1.SpeedButton2Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        Edit2.text := od.FileName;
END;

END.
(*
hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS OR SERVICE_START OR SERVICE_STOP OR SERVICE_PAUSE_CONTINUE);
// Si Hservice=Null alors : GETLASTERROR -> ERROR_SERVICE_DOES_NOT_EXIST	Le service n'est pas installé

QueryServiceStatus(hService, Statut);
statut.dwCurrentState =
{SERVICE_STOPPED
  SERVICE_START_PENDING
  SERVICE_STOP_PENDING
  SERVICE_RUNNING
  SERVICE_CONTINUE_PENDING
  SERVICE_PAUSE_PENDING
  SERVICE_PAUSED
}
Statut.dwWaitHint // Temps à attendre avant une nouvelle intérogation
Statut.dwCheckPoint // devrait être différent à chaque appel à QueryServiceStatus donnant un pending

ControlService(hService, SERVICE_CONTROL_PAUSE, Statut)
ControlService(hService, SERVICE_CONTROL_CONTINUE, Statut)

ControlService(hService, SERVICE_CONTROL_STOP, Statut)
StartService(hService, 0, NIL);

CloseServiceHandle(hService);
CloseServiceHandle(hSCManager);
*)

