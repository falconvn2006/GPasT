UNIT Unit1;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, IBCustomDataSet, IBDatabase, IBQuery, StdCtrls, Buttons;

TYPE
    TForm1 = CLASS(TForm)
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Edit1: TEdit;
        Edit2: TEdit;
        Edit3: TEdit;
        SpeedButton1: TSpeedButton;
        OD: TOpenDialog;
        Memo1: TMemo;
        Memo2: TMemo;
        Button1: TButton;
        Data: TIBDatabase;
        Tbl: TIBQuery;
        rech: TIBQuery;
        tran: TIBTransaction;
        TblKTB_NAME: TIBStringField;
        TblKTB_ID: TIntegerField;
        Insert: TIBQuery;
        tran2: TIBTransaction;
        TblKFLD_NAME: TIBStringField;
        PROCEDURE SpeedButton1Click(Sender: TObject);
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

PROCEDURE TForm1.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        edit3.text := od.filename;
END;

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    Nbr: Integer;
BEGIN
    data.close;
    data.DatabaseName := edit3.text;
    data.open;
    tran.Active := true;
    tran2.Active := true;
    Tbl.Open;
    Tbl.first;
    memo1.clear;
    memo2.clear;
    WHILE NOT tbl.eof DO
    BEGIN
        IF (Uppercase(Trim(TblKTB_NAME.AsString)) = 'DDOC') or
           (Uppercase(COPY(Trim(TblKTB_NAME.AsString),1,3)) = 'INV') or
           (Uppercase(Trim(TblKTB_NAME.AsString)) = 'CFGUSERLEVELNONK') or
           (Uppercase(Trim(TblKTB_NAME.AsString)) = 'CFGMODULESNONK')
           THEN
        ELSE
        BEGIN
            Nbr := 0;
            Memo1.Lines.Add(TblKTB_NAME.AsString);
            Memo1.Update;
            Insert.ParamByName('TBL').AsInteger := TblKTB_ID.AsInteger;
            rech.sql.clear;
            rech.sql.add('SELECT ' + Trim(TblKFLD_NAME.AsString));
            rech.sql.add('FROM ' + Trim(TblKTB_NAME.AsString));
            rech.sql.add('WHERE NOT EXISTS (SELECT K_ID FROM K WHERE K_ID=' + Trim(TblKTB_NAME.AsString) + '.' + Trim(TblKFLD_NAME.AsString) + ')');
            rech.Open;
            WHILE NOT rech.eof DO
            BEGIN
                Inc(nbr);
                Insert.ParamByName('ID').AsInteger := Rech.Fields[0].AsInteger;
                Insert.ExecSQL;
                IF (Rech.Fields[0].AsInteger < StrToInt(Edit1.Text)) OR
                    (Rech.Fields[0].AsInteger > StrToInt(Edit2.Text)) THEN
                BEGIN
                    Memo2.Lines.Add(TblKTB_NAME.AsString + ' ' + Rech.Fields[0].AsString);
                    Memo2.Update;
                END;
                rech.Next;
            END;
            rech.close;
            Memo1.Lines.Add(Inttostr(Nbr));
            Memo1.Update;
            IF tran2.InTransaction THEN
                tran2.commit;
            tran2.active := true;
        END;
        tbl.next;
    END;
    data.close;
END;

END.

