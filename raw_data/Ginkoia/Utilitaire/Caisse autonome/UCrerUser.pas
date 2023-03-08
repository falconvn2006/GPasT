UNIT UCrerUser;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    IBDatabase, Db, StdCtrls, Buttons, IBCustomDataSet, IBSQL, IBQuery;

TYPE
    TForm1 = CLASS(TForm)
        Edit1: TEdit;
        Label1: TLabel;
        SpeedButton1: TSpeedButton;
        Button1: TButton;
        data: TIBDatabase;
        tran: TIBTransaction;
        IBQue_ListeTable: TIBQuery;
        SQL: TIBSQL;
        IBQue_ListeTableNOM: TIBStringField;
    IBQue_ListeProc: TIBQuery;
    IBQue_ListeProcNOM: TIBStringField;
        PROCEDURE Button1Click(Sender: TObject);
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
BEGIN
    screen.cursor := crhourglass;
    TRY
        data.Close;
        data.databasename := edit1.text;
        data.Open;
        tran.active := true;
        IBQue_ListeTable.Open;
        IBQue_ListeTable.First;
        WHILE NOT IBQue_ListeTable.Eof DO
        BEGIN
            Sql.sql.Text := 'GRANT ALL ON TABLE ' + IBQue_ListeTableNOM.AsString + ' TO REPL';
            Sql.ExecQuery;
            IBQue_ListeTable.next;
        END;
        IBQue_ListeTable.Close;
        IF tran.Intransaction THEN
            tran.Commit;
        tran.active := true;

        IBQue_ListeProc.Open;
        IBQue_ListeProc.First;
        WHILE NOT IBQue_ListeProc.Eof DO
        BEGIN
            Sql.sql.Text := 'GRANT EXECUTE ON PROCEDURE ' + IBQue_ListeProcNOM.AsString + ' TO REPL';
            Sql.ExecQuery;
            IBQue_ListeProc.next;
        END;
        IBQue_ListeProc.Close ;
        IF tran.Intransaction THEN
            tran.Commit;
        tran.active := true;

        data.Close;
    FINALLY
        screen.cursor := crdefault;
    END;
END;

END.

