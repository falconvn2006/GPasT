UNIT Unit1;

INTERFACE

USES
    registry, inifiles,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, IB_Components, Buttons, Db, IBCustomDataSet, IBDatabase,
    IBQuery, ComCtrls, IBStoredProc;

TYPE
    TForm1 = CLASS(TForm)
        Edit1: TEdit;
        SpeedButton1: TSpeedButton;
        CbMag: TComboBox;
        OD: TOpenDialog;
        Base: TIBDatabase;
        ListeCouleur: TIBQuery;
        tran: TIBTransaction;
        ListeCouleurTKL_ARTID: TIntegerField;
        ListeCouleurTKL_COUID: TIntegerField;
        ListeCouleurTKL_TGFID: TIntegerField;
        RefArticle: TIBQuery;
        Magasin: TIBQuery;
        Correction: TIBQuery;
        MagasinMAG_NOM: TIBStringField;
        correction2: TIBQuery;
        RefArticleLADATE: TDateTimeField;
        ListeCouleurMAG_ID: TIntegerField;
        ListeCouleurSOCID: TIntegerField;
        Creligne1: TIBQuery;
        CreLigne2: TIBQuery;
        CreLigne4: TIBQuery;
        CreLigne3: TIBQuery;
        Lesdates: TIBQuery;
        LesdatesLADATE: TDateField;
        MagasinMAG_ID: TIntegerField;
        Button2: TButton;
        Ib_NbChrono: TIBQuery;
        Ib_NbChronoNB: TIntegerField;
        Prog: TProgressBar;
        Lab: TLabel;
        Button3: TButton;
        Ib_Chrono: TIBQuery;
        Ib_ChronoART_ID: TIntegerField;
        tran2: TIBTransaction;
        ib_minbr: TIBQuery;
        Ib_Stock: TIBQuery;
        Ib_Pump: TIBQuery;
        Ib_StockSTC_QTE: TFloatField;
        Ib_PumpPPC_PUMP: TFloatField;
        Ib_Gormond: TIBQuery;
        Ib_GormondMAG_ID: TIntegerField;
        ListeCouleurMAG_NOM: TIBStringField;
        Sp_NewKey: TIBStoredProc;
        Ib_K: TIBQuery;
        Ib_ConsoDiv: TIBQuery;
    ib_minbrLADATE: TDateField;
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PRIVATE
        Pathexe: STRING;
        DernierId: Integer;
        fin: boolean;
        Gormond: boolean;
        PROCEDURE ChangeBase;
        FUNCTION NouvelleClef: Integer;

    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TForm1.ChangeBase;
BEGIN
    IF tran.InTransaction THEN
        tran.commit;
    Base.connected := false;
    Base.DataBaseName := Edit1.Text;
    Base.connected := True;
    tran.Active := true;
    Ib_Gormond.Open;
    IF NOT (Ib_Gormond.IsEmpty) AND
        (Ib_Gormondmag_id.AsInteger = 9068) THEN
        gormond := true
    ELSE
        gormond := false;

    CbMag.visible := gormond;
    CbMag.items.clear;
    CbMag.items.Add(' --- Aucun Magasin --- ');
    Magasin.open;
    Magasin.first;
    WHILE NOT magasin.eof DO
    BEGIN
        CbMag.items.Add(magasinMAG_NOM.AsString);
        magasin.next;
    END;
    Magasin.close;
    CbMag.itemIndex := -1;
END;

PROCEDURE TForm1.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
    BEGIN
        edit1.text := od.filename;
        ChangeBase;
    END;
END;

FUNCTION TForm1.NouvelleClef: Integer;
BEGIN
    Sp_NewKey.Prepare;
    Sp_NewKey.ExecProc;
    Result := Sp_NewKey.Parambyname('NEWKEY').AsInteger;
    Sp_NewKey.UnPrepare;
    Sp_NewKey.Close;
END;

PROCEDURE TForm1.FormCreate(Sender: TObject);
VAR
    reg: TRegistry;
    PathDataBase: STRING;
    ini: tinifile;
BEGIN
    Gormond := false;
    reg := TRegistry.Create;
    reg.access := Key_Read;
    Reg.RootKey := HKEY_CURRENT_USER;
    Pathexe := '';
    IF Reg.OpenKey('\Software\Agol\Ginkoia\Current Version', False) THEN
        Pathexe := Reg.readString('Path');
    reg.free;

    Pathexe := ExtractFilePath(Pathexe);
    IF Pathexe[length(Pathexe)] <> '\' THEN
        Pathexe := Pathexe + '\';

    ini := tinifile.create(Pathexe + 'Ginkoia.Ini');
    TRY
        PathDataBase := ini.readString('DATABASE', 'PATH0', '');
        IF Copy(PathDataBase, 2, 1) <> ':' THEN
            PathDataBase := ini.readString('DATABASE', 'PATH1', '');
        IF Copy(PathDataBase, 2, 1) <> ':' THEN
            PathDataBase := ini.readString('DATABASE', 'PATH2', '');
        IF Copy(PathDataBase, 2, 1) <> ':' THEN
            PathDataBase := ini.readString('DATABASE', 'PATH3', '');
    FINALLY
        ini.free;
    END;
    Edit1.text := PathDataBase;
    ChangeBase;
END;

FUNCTION Enumerate(hwnd: HWND; Param: LPARAM): Boolean; STDCALL; FAR;
VAR
    lpClassName: ARRAY[0..999] OF Char;
    lpClassName2: ARRAY[0..999] OF Char;
    Handle: DWORD;
    // lpdwProcessId: Pointer;
BEGIN
    result := true;
    Windows.GetClassName(hWnd, lpClassName, 500);
    IF Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' THEN
    BEGIN
        Windows.GetWindowText(hWnd, lpClassName2, 500);
        IF Uppercase(StrPas(lpClassName2)) = 'LE LAUNCHER' THEN
        BEGIN
            GetWindowThreadProcessId(hWnd, @Handle);
            TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, False, Handle), 0);
            result := False;
        END;
    END;
END;

PROCEDURE TForm1.Button2Click(Sender: TObject);
VAR
    ini: tinifile;
    Qte: Integer;
    Fait: Integer;
    tps: Dword;
    pass: Integer;
    Temps: DWord;
    gorok: boolean;
    LeStock : double ;
    Clef:Integer ;
BEGIN
    LeStock := 0 ;
    IF gormond AND (cbmag.itemindex < 0) THEN
    BEGIN
        Application.messageBox('Veuillez indiquer votre magasin', ' Magasin', Mb_Ok);
        cbmag.SetFocus;
    END
    ELSE
    BEGIN
        Button2.Enabled := False;
        EnumWindows(@Enumerate, 0);
        ini := tinifile.create(Pathexe + 'Ginkoia.Ini');
        TRY
            dernierid := ini.readinteger('RECALCULE', 'LASTID', 0);
            Qte := ini.readinteger('RECALCULE', 'QTE', 0);
            Fait := ini.Readinteger('RECALCULE', 'FAIT', 0);
            Temps := ini.Readinteger('RECALCULE', 'Temps', 0);
        FINALLY
            ini.free;
        END;
        IF dernierid = 0 THEN
        BEGIN
            Ib_NbChrono.Open;
            Qte := Ib_NbChronoNB.AsInteger;
            Ib_NbChrono.Close;
            ini := tinifile.create(Pathexe + 'Ginkoia.Ini');
            TRY
                ini.Writeinteger('RECALCULE', 'QTE', Qte);
            FINALLY
                ini.free;
            END;
        END;
        Prog.Position := 0;
        Prog.Max := Qte;
        fin := false;
        Ib_Chrono.ParamByName('ARTID').AsInteger := dernierid;
        Ib_Chrono.Open;
        Magasin.open;
        WHILE (NOT fin) AND (NOT Ib_Chrono.EOF) DO
        BEGIN
            tps := GetTickCount;
            Prog.Position := Fait;
            Lab.Caption := Inttostr(Fait) + '/' + Inttostr(Qte);
            IF (fait > 0) THEN
            BEGIN
                Pass := trunc(((temps / Fait * Qte) - temps) / 1000);
                IF pass < 60 THEN
                    Lab.Caption := Lab.Caption + '  Reste ' + Inttostr(pass) + 's'
                ELSE IF pass < 60 * 60 THEN
                    Lab.Caption := Lab.Caption + '  Reste ' + Inttostr(pass DIV 60) + 'Min ' + Inttostr(pass MOD 60) + 's'
                ELSE
                    Lab.Caption := Lab.Caption + '  Reste ' + Inttostr(pass DIV 3600) + 'H ' + Inttostr((pass MOD 3600) DIV 60) + 'min ';
            END;
            prog.update;
            Lab.update;
            Magasin.first;
            WHILE NOT Magasin.Eof DO
            BEGIN
                ListeCouleur.ParamByName('ARTID').AsInteger := Ib_ChronoART_ID.AsInteger;
                ListeCouleur.ParamByName('MAGID').AsInteger := MagasinMAG_ID.AsInteger;
                ListeCouleur.Open;
                IF (ListeCouleur.Isempty) THEN
                ELSE
                BEGIN
                    RefArticle.parambyname('MAGID').AsInteger := MagasinMAG_ID.AsInteger;
                    RefArticle.parambyname('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                    RefArticle.Open;

                    ListeCouleur.first;
                    WHILE NOT ListeCouleur.eof DO
                    BEGIN

                        gorok := gormond AND (ListeCouleurMAG_NOM.AsString = cbmag.items[cbmag.ItemIndex]);
                        IF gorOk THEN
                        BEGIN
                            Ib_Stock.paramByName('MAGID').AsInteger := ListeCouleurMAG_ID.AsInteger;
                            Ib_Stock.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                            Ib_Stock.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                            Ib_Stock.paramByName('COUID').AsInteger := ListeCouleurTKL_COUID.AsInteger;
                            Ib_Stock.Open;
                            LeStock := Ib_StockSTC_QTE.AsFloat;
                            Ib_Stock.Close;
                        END;
                        CreLigne1.paramByName('MAGID').AsInteger := ListeCouleurMAG_ID.AsInteger;
                        CreLigne1.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                        CreLigne1.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                        CreLigne1.paramByName('COUID').AsInteger := ListeCouleurTKL_COUID.AsInteger;

                        CreLigne3.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                        CreLigne3.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;

                        CreLigne1.ExecSQL;
                        CreLigne3.ExecSQL;

                        LesDates.paramByName('MAGID').AsInteger := ListeCouleurMAG_ID.AsInteger;
                        LesDates.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                        LesDates.paramByName('COUID').AsInteger := ListeCouleurTKL_COUID.AsInteger;
                        LesDates.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                        LesDates.Open;
                        LesDates.First;
                        WHILE NOT (LesDates.eof) DO
                        BEGIN
                            CreLigne2.paramByName('MAGID').AsInteger := ListeCouleurMAG_ID.AsInteger;
                            CreLigne2.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                            CreLigne2.paramByName('COUID').AsInteger := ListeCouleurTKL_COUID.AsInteger;
                            CreLigne2.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                            CreLigne2.paramByName('LADATE').AsDateTime := LesDatesLADATE.AsDateTime;
                            CreLigne2.ExecSQL;

                            CreLigne4.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                            CreLigne4.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                            CreLigne4.paramByName('LADATE').AsDateTime := LesDatesLADATE.AsDateTime;
                            CreLigne4.ExecSQL;
                            LesDates.next;
                        END;
                        LesDates.close;

                        ib_minbr.paramByName('ARTID').asinteger := ListeCouleurTKL_ARTID.AsInteger;
                        ib_minbr.paramByName('COUID').AsInteger := ListeCouleurTKL_COUID.AsInteger;
                        ib_minbr.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                        ib_minbr.paramByName('MAGID').AsInteger := ListeCouleurMAG_ID.AsInteger;
                        ib_minbr.Open;

                        Correction.paramByName('MAGID').AsInteger := ListeCouleurMAG_ID.AsInteger;
                        Correction.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                        Correction.paramByName('COUID').AsInteger := ListeCouleurTKL_COUID.AsInteger;
                        Correction.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                        Correction.paramByName('LADATE').AsDATETIME := ib_minbrLaDate.AsDateTime;

                        Correction2.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                        Correction2.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                        Correction2.paramByName('LADATE').AsDateTime := ib_minbrLaDate.AsDateTime;

                        Correction.ExecSQL;
                        Correction2.ExecSQL;

                        IF gorOk THEN
                        BEGIN
                            Ib_Stock.paramByName('MAGID').AsInteger := ListeCouleurMAG_ID.AsInteger;
                            Ib_Stock.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                            Ib_Stock.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                            Ib_Stock.paramByName('COUID').AsInteger := ListeCouleurTKL_COUID.AsInteger;
                            Ib_Stock.Open;
                            IF round(Abs(LeStock - Ib_StockSTC_QTE.AsFloat)) > 0 THEN
                            BEGIN
                                // Ajouter une demarque de Ib_StockSTC_QTE.AsFloat-LeStock
                                Clef := NouvelleClef;
                                Ib_K.ParamByName('ID').AsInteger := Clef;
                                Ib_K.ExecSQL;
                                Ib_ConsoDiv.ParamByName('ID').AsInteger := Clef;
                                Ib_ConsoDiv.paramByName('MAGID').AsInteger := ListeCouleurMAG_ID.AsInteger;
                                Ib_ConsoDiv.paramByName('ARTID').AsInteger := ListeCouleurTKL_ARTID.AsInteger;
                                Ib_ConsoDiv.paramByName('TGFID').AsInteger := ListeCouleurTKL_TGFID.AsInteger;
                                Ib_ConsoDiv.paramByName('COUID').AsInteger := ListeCouleurTKL_COUID.AsInteger;
                                Ib_ConsoDiv.paramByName('QTTE').AsFloat := Ib_StockSTC_QTE.AsFloat - LeStock;
                            END;
                            Ib_Stock.Close;
                        END;

                        ListeCouleur.next;
                    END;
                    RefArticle.Close;
                END;
                ListeCouleur.Close;
                Magasin.next;
            END;
            IF tran.intransaction THEN
                tran.commit;
            tran.active := true;
            Application.processMessages;
            Fait := fait + 1;
            dernierid := Ib_ChronoART_ID.AsInteger;
            Temps := Temps + GetTickCount - tps;
            Ib_Chrono.Next;
        END;
        ini := tinifile.create(Pathexe + 'Ginkoia.Ini');
        TRY
            ini.Writeinteger('RECALCULE', 'LASTID', dernierid);
            ini.Writeinteger('RECALCULE', 'FAIT', Fait);
            ini.Writeinteger('RECALCULE', 'Temps', Temps);
        FINALLY
            ini.free;
        END;
        Magasin.Close;
        Ib_Chrono.Close;
        Button2.Enabled := true;
        Winexec(PChar(Pathexe + 'Launch.exe'), 0);
    END;
END;

PROCEDURE TForm1.Button3Click(Sender: TObject);
BEGIN
    fin := true;
END;

PROCEDURE TForm1.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
BEGIN
    Canclose := Button2.enabled;
END;

END.

