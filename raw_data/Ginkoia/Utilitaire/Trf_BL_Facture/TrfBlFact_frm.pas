UNIT TrfBlFact_frm;

INTERFACE

USES
    NegBL_DM,
    Main_Dm,
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    StdCtrls,
    Mask,
    wwdbedit,
    wwDBEditRv,
    Db,
    IBDataset,
    RzLabel,
    wwcheckbox;

TYPE
    TFrm_TrfBLFact = CLASS ( TForm )
        Chp_NomBase: TwwDBEditRv;
        LMDSpeedButton1: TLMDSpeedButton;
        OD: TOpenDialog;
        LMDSpeedButton2: TLMDSpeedButton;
        Que_LesBl: TIBOQuery;
        Que_LesBlBLE_ID: TIntegerField;
        Que_UpdateBl: TIBOQuery;
        Lab_Prog: TRzLabel;
        Que_UpdateFacture: TIBOQuery;
        cb1: TwwCheckBox;
        cb3: TwwCheckBox;
        RzLabel1: TRzLabel;
        RzLabel2: TRzLabel;
        cb2: TwwCheckBox;
    Chp_Num: TwwDBEditRv;
    RzLabel3: TRzLabel;
    Que_NbrBl: TIBOQuery;
    Que_NbrBlNUM: TIntegerField;
    Que_Lance: TIBOQuery;
    Que_LanceIID: TIntegerField;
    Que_Script1: TIBOQuery;
    Que_Script2: TIBOQuery;
        PROCEDURE LMDSpeedButton1Click ( Sender: TObject ) ;
        PROCEDURE LMDSpeedButton2Click ( Sender: TObject ) ;
        PROCEDURE cb1Click ( Sender: TObject ) ;
    procedure FormCreate(Sender: TObject);
    Private
    { Déclarations privées }
    Public
    { Déclarations publiques }
      premier : boolean ;
    END;

VAR
    Frm_TrfBLFact: TFrm_TrfBLFact;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_TrfBLFact.LMDSpeedButton1Click ( Sender: TObject ) ;
BEGIN
    IF od.execute THEN
        Chp_NomBase.Text := od.FileName;
END;

PROCEDURE TFrm_TrfBLFact.LMDSpeedButton2Click ( Sender: TObject ) ;
VAR
//    fact: STRING;
    hh, mm, ss: integer;
    iid,
    Id: DWord;
    num: integer;
    Max: integer;
    tmps: Integer;
BEGIN
    LMDSpeedButton2.enabled := false ;
    try
        Dm_Main.Initialize ( Chp_NomBase.Text ) ;

        try
            Que_Script1.ExecSQL ;
            Que_Script1.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        Dm_Main.DataBase.Connected := true;
        Que_Script2.Sql.text := 'DROP INDEX INX_NEGFCLARTID' ;
        try
            Que_Script2.ExecSQL ;
            Que_Script2.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        Dm_Main.DataBase.Connected := true;
        Que_Script2.Sql.text := 'DROP INDEX INX_NEGFCLCOUID' ;
        try
            Que_Script2.ExecSQL ;
            Que_Script2.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        Dm_Main.DataBase.Connected := true;
        Que_Script2.Sql.text := 'DROP INDEX INX_NEGFCLTGFID' ;
        try
            Que_Script2.ExecSQL ;
            Que_Script2.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        Dm_Main.DataBase.Connected := true;
        Que_Script2.Sql.text := 'DROP INDEX INX_NEGFCLTYPID' ;
        try
            Que_Script2.ExecSQL ;
            Que_Script2.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        Dm_Main.DataBase.Connected := true;
        Que_Script2.Sql.text := 'DROP INDEX INX_NEGFCLUSRID' ;
        try
            Que_Script2.ExecSQL ;
            Que_Script2.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        Dm_Main.DataBase.Connected := true;
        Que_Script2.Sql.text := 'CREATE INDEX NEGFACTUREL_IDX ON NEGFACTUREL (FCL_ARTID, FCL_COUID, FCL_TGFID)' ;
        try
            Que_Script2.ExecSQL ;
            Que_Script2.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        Dm_Main.DataBase.Connected := true;
        Que_Script2.Sql.text := 'ALTER TRIGGER  "Maj_StkPump_FAC_I"  INACTIVE' ;
        try
            Que_Script2.ExecSQL ;
            Que_Script2.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        Dm_Main.DataBase.Connected := true;

        id := gettickcount ;
        Que_NbrBl.Open ;
        Max := Que_NbrBl.fields[0].AsInteger ;
        Que_NbrBl.Close ;
        IF cb1.checked THEN
            Que_Lance.ParamByName('CAS').AsInteger := 1
        ELSE IF cb2.checked THEN
            Que_Lance.ParamByName('CAS').AsInteger := 2
        ELSE
            Que_Lance.ParamByName('CAS').AsInteger := 3;
        Que_Lance.ParamByName('NUMERO').AsString := Chp_Num.Text ;
        Num := 0 ;
        repeat
          Que_Lance.Open ;
          if Que_Lance.IsEmpty then
            begin
              Que_Lance.Close ;
              Break ;
            end ;
          iid := Que_LanceIID.AsInteger ;
          Que_Lance.Close ;
          inc ( num ) ;
          tmps := trunc ( ( ( gettickcount - id ) / ( Num ) * max ) / 1000 ) ;
          hh := tmps DIV 3600;
          mm := ( tmps MOD 3600 ) DIV 60;
          ss := ( tmps MOD 3600 ) MOD 60;
          rzlabel2.caption := Inttostr ( hh ) + ':' + Inttostr ( mm ) + ':' + Inttostr ( ss ) ;
          Lab_Prog.Caption := Inttostr ( num ) + '/' + Inttostr ( Max ) ;
          Que_Lance.ParamByName('Numero').AsInteger := iid ;
        until False ;

{

        Application.CreateForm ( TDm_NegBL, Dm_NegBL ) ;
        TRY
            IF cb1.checked THEN
                Dm_NegBL.Version := 1
            ELSE IF cb2.checked THEN
                Dm_NegBL.Version := 2
            ELSE
                Dm_NegBL.Version := 3;

            Dm_NegBL.RZL := RzLabel1;
            id := gettickcount ;

            Que_LesBl.Open;
            num := 0;
            Max := Que_LesBl.recordCount;
            TRY
                WHILE NOT Que_LesBl.Eof DO
                BEGIN
                    inc ( num ) ;
                    IF Que_LesBlBLE_ID.AsInteger <> 0 THEN
                    BEGIN
                        IF ( num - 1 ) > 0 THEN
                        BEGIN
                            tmps := trunc ( ( ( gettickcount - id ) / ( Num - 1 ) * max ) / 1000 ) ;
                            hh := tmps DIV 3600;
                            mm := ( tmps MOD 3600 ) DIV 60;
                            ss := ( tmps MOD 3600 ) MOD 60;
                            rzlabel2.caption := Inttostr ( hh ) + ':' + Inttostr ( mm ) + ':' + Inttostr ( ss ) ;
                        END;
                        Lab_Prog.Caption := Inttostr ( num ) + '/' + Inttostr ( Max ) ;
                        Dm_NegBL.Que_TetBl.ParamByName ( 'BLEID' ) .AsInteger := Que_LesBlBLE_ID.AsInteger;
                        Que_UpdateBl.ParamByName ( 'BLEID' ) .AsInteger := Que_LesBlBLE_ID.AsInteger;
                        Dm_NegBL.Que_TetBl.Open;
                        Dm_Main.StartTransaction;
                        fact := Dm_NegBL.TransBLKour;

                        Dm_Main.StartTransaction;
                        Que_UpdateBl.ParamByName ( 'BLEID' ) .AsInteger := Que_LesBlBLE_ID.AsInteger;
                        Que_UpdateBl.execSql;
                        Que_UpdateBl.close;
                        Que_UpdateFacture.ParamByName ( 'NUMFACT' ) .AsString := Fact;
                        Que_UpdateFacture.execSql;
                        Que_UpdateFacture.close;
                        Dm_Main.commit;

                        Dm_NegBL.Que_TetBl.Close;
                    END;
                    IF num MOD 5 = 0 THEN
                    BEGIN
                      Dm_Main.DataBase.Connected := false;
                      winexec ('cmd /c net stop "interbase server"',0) ;
                      iid := gettickcount+2000 ;
                      While iid>gettickcount do
                        Application.processmessages ;
                      winexec ('cmd /c net start "interbase guardian"',0) ;
                      iid := gettickcount+2000 ;
                      While iid>gettickcount do
                        Application.processmessages ;
                      Dm_Main.DataBase.Connected := true ;
                      Que_LesBl.Open ;
                    END;
                    Que_LesBl.next;
                END;
            FINALLY
                Que_LesBl.Close;
            END;
        FINALLY
            Dm_NegBL.free;
        END;
        }
        Que_Script2.Sql.text := 'ALTER TRIGGER  "Maj_StkPump_FAC_I"  ACTIVE' ;
        try
            Que_Script2.ExecSQL ;
            Que_Script2.IB_Transaction.Commit ;
          except
          end ;
        Dm_Main.DataBase.Connected := false;
        id := gettickcount - id;
        id := trunc ( id / 1000 ) ;
        hh := id DIV 3600;
        mm := ( id MOD 3600 ) DIV 60;
        ss := ( id MOD 3600 ) MOD 60;
        Caption := Inttostr ( hh ) + ':' + Inttostr ( mm ) + ':' + Inttostr ( ss ) ;
    finally
      LMDSpeedButton2.enabled := true ;
    end ;
END;

PROCEDURE TFrm_TrfBLFact.cb1Click ( Sender: TObject ) ;
BEGIN
    IF ( sender = cb1 ) THEN
    BEGIN
        IF cb1.checked THEN
        BEGIN
            cb2.checked := false;
            cb3.checked := false;
        END
        ELSE IF NOT ( cb3.checked OR cb2.checked ) THEN
            cb1.checked := true;
    END
    ELSE IF ( sender = cb2 ) THEN
    BEGIN
        IF cb2.checked THEN
        BEGIN
            cb1.checked := false;
            cb3.checked := false;
        END
        ELSE IF NOT ( cb1.checked OR cb3.checked ) THEN
            cb2.checked := true;
    END
    ELSE IF ( sender = cb3 ) THEN
    BEGIN
        IF cb3.checked THEN
        BEGIN
            cb1.checked := false;
            cb2.checked := false;
        END
        ELSE IF NOT ( cb1.checked OR cb2.checked ) THEN
            cb3.checked := true;
    END;
END;

procedure TFrm_TrfBLFact.FormCreate(Sender: TObject);
begin
  premier := true ;
end;

END.

