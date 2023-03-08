UNIT Modif_frm;

INTERFACE

USES
    registry,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls;

TYPE
    TFrm_Modif = CLASS(TForm)
        Label1: TLabel;
        Edt_Chrono: TEdit;
        Button1: TButton;
        Label2: TLabel;
        Lab_PUMP: TLabel;
        Label3: TLabel;
        Edt_Pump: TEdit;
        Bt_MAJ: TButton;
        Label4: TLabel;
        Base: TIBDatabase;
        Tran: TIBTransaction;
        IBQue_RechArt: TIBQuery;
        IBQue_Brl: TIBQuery;
        IBQue_BrlBRL_ID: TIntegerField;
        IBQue_RechArtARF_ARTID: TIntegerField;
        IBQue_RechArtPUMP: TFloatField;
        IBQue_UpK: TIBQuery;
        IBQue_UpBrl: TIBQuery;
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Bt_MAJClick(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Edt_ChronoKeyPress(Sender: TObject; VAR Key: Char);
        PROCEDURE Edt_PumpKeyPress(Sender: TObject; VAR Key: Char);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        ARTID: Integer;
    END;

VAR
    Frm_Modif: TFrm_Modif;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_Modif.Button1Click(Sender: TObject);
BEGIN
    IBQue_RechArt.ParamByName('CHRONO').AsString := Edt_Chrono.Text;
    IBQue_RechArt.Open;
    IF IBQue_RechArt.IsEmpty OR (IBQue_RechArtARF_ARTID.AsInteger = 0) OR (IBQue_RechArtPUMP.IsNull) THEN
    BEGIN
        ARTID := 0;
        Lab_PUMP.Caption := '';
        Edt_Pump.Text := '';
        Edt_Chrono.SetFocus;
        Bt_MAJ.enabled := false;
        Application.MessageBox('Article non trouvé', ' Article', Mb_Ok);
    END
    ELSE
    BEGIN
        ARTID := IBQue_RechArtARF_ARTID.AsInteger;
        Lab_PUMP.Caption := Format('%f', [IBQue_RechArtPUMP.AsFloat]);
        Edt_Pump.Text := '';
        Edt_Pump.SetFocus;
        Bt_MAJ.enabled := true;
    END;
    IBQue_RechArt.Close;
END;

PROCEDURE TFrm_Modif.Bt_MAJClick(Sender: TObject);
VAR
    S: STRING;
    fl: Double;
BEGIN
    S := trim(Edt_Pump.Text);
    IF S <> '' THEN
    BEGIN
        WHILE pos(',', S) > 0 DO
            S[pos(',', S)] := '.';
        TRY
            Fl := Strtofloat(s);
            IBQue_Brl.ParamByName('ARTID').AsInteger := ARTID;
            IBQue_Brl.Open;
            IBQue_Brl.first;
            WHILE NOT IBQue_Brl.Eof DO
            BEGIN
                IBQue_UpK.ParamByName('KID').AsInteger := IBQue_BrlBRL_ID.AsInteger;
                IBQue_UpK.ExecSQL;
                IBQue_UpBrl.ParamByName('BRLID').AsInteger := IBQue_BrlBRL_ID.AsInteger;
                IBQue_UpBrl.ParamByName('PX').AsFloat := fl;
                IBQue_UpBrl.ExecSQL;
                IBQue_Brl.Next;
            END;
            IBQue_Brl.Close;
            IF tran.InTransaction THEN
            BEGIN
                tran.Commit;
                tran.active := true;
            END;
            IBQue_RechArt.ParamByName('CHRONO').AsString := Edt_Chrono.Text;
            IBQue_RechArt.Open;
            Lab_PUMP.Caption := Format('%f', [IBQue_RechArtPUMP.AsFloat]);
            IBQue_RechArt.Close;
            Edt_Chrono.SetFocus;
        EXCEPT
            Application.MessageBox(' Pump invalide', ' PUMP', Mb_Ok);
        END;
    END;
END;

PROCEDURE TFrm_Modif.FormCreate(Sender: TObject);
VAR
    reg: TRegistry;
BEGIN
    DecimalSeparator := '.';
    Base.Close;
    Base.DataBaseName := '';
    reg := TRegistry.Create(KEY_READ);
    reg.rootkey := HKEY_LOCAL_MACHINE;
    IF reg.OpenKey('SOFTWARE\Algol\Ginkoia', false) THEN
    BEGIN
        Base.DataBaseName := reg.ReadString('Base0');
    END;
    reg.free;
    Base.Open;
    tran.active := true;
END;

PROCEDURE TFrm_Modif.Edt_ChronoKeyPress(Sender: TObject; VAR Key: Char);
BEGIN
    IF key = #13 THEN
    BEGIN
        Button1.SetFocus;
        Button1Click(NIL);
    END;
END;

PROCEDURE TFrm_Modif.Edt_PumpKeyPress(Sender: TObject; VAR Key: Char);
BEGIN
    IF key = #13 THEN
    BEGIN
        Bt_MAJ.SetFocus;
        Bt_MAJClick(NIL);
    END;

END;

END.

