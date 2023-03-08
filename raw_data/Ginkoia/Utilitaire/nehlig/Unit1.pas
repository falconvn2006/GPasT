UNIT Unit1;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    LMDControl, LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
    LMDSpeedButton, Db, ADODB, Grids, DBGrids, dxmdaset;

TYPE
    TForm1 = CLASS(TForm)
    ADO: TADOConnection;
        DataSource1: TDataSource;
        fourn: TADOQuery;
        LMDSpeedButton1: TLMDSpeedButton;
        mrk: TADOQuery;
        M_fourn: TdxMemData;
        M_mrk: TdxMemData;
        art: TADOQuery;
        M_art: TdxMemData;
        Tail: TADOQuery;
        Cou: TADOQuery;
        M_t: TdxMemData;
        mtl: TdxMemData;
        M_tcode: TStringField;
        M_tnom: TStringField;
        mtlcode_gt: TStringField;
        mtlnom: TStringField;
        LMDSpeedButton2: TLMDSpeedButton;
        Tailar_ref: TStringField;
        Taileg_enumere: TStringField;
        CB: TADOQuery;
        M_cb: TdxMemData;
        LMDSpeedButton3: TLMDSpeedButton;
        LMDSpeedButton4: TLMDSpeedButton;
        Prix: TADOQuery;
        m_p: TdxMemData;
        Coul: TADOQuery;
        LMDSpeedButton5: TLMDSpeedButton;
        m_c: TdxMemData;
        dxMemData1: TdxMemData;
        dxMemData1toto: TStringField;
        LMDSpeedButton6: TLMDSpeedButton;
    LMDSpeedButton7: TLMDSpeedButton;
    client: TADOQuery;
    LMDSpeedButton8: TLMDSpeedButton;
    m_cl: TdxMemData;
        PROCEDURE LMDSpeedButton1Click(Sender: TObject);
        PROCEDURE LMDSpeedButton2Click(Sender: TObject);
        PROCEDURE LMDSpeedButton3Click(Sender: TObject);
        PROCEDURE LMDSpeedButton4Click(Sender: TObject);
        PROCEDURE LMDSpeedButton5Click(Sender: TObject);
        PROCEDURE M_artCalcFields(DataSet: TDataSet);
        PROCEDURE LMDSpeedButton6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LMDSpeedButton7Click(Sender: TObject);
    procedure LMDSpeedButton8Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

USES
    DlgStd_Frm, GaugeMess_Frm;
{$R *.DFM}

PROCEDURE TForm1.LMDSpeedButton1Click(Sender: TObject);
BEGIN
    screen.Cursor := crSQLWait;
    fourn.open;
    mrk.open;
    m_fourn.open;
    m_mrk.open;

    m_fourn.loadfromdataset(fourn);
    m_fourn.DelimiterChar := ';';
    m_fourn.savetotextfile('c:\temp\transpoNehlig\fourn.csv');

    M_mrk.loadfromdataset(mrk);
    m_mrk.DelimiterChar := ';';
    m_mrk.savetotextfile('c:\temp\transpoNehlig\marque.csv');

   
    screen.Cursor := crdefault;

END;

PROCEDURE TForm1.LMDSpeedButton2Click(Sender: TObject);
VAR cd: STRING;
    nb: extended;
    nbr: variant;
    j: integer;
BEGIN
    ShowMessHPAvi('Chargement des tailles...', false, 0, 0);
    tail.open;
    showCloseHP;

    m_t.open;
    mtl.open;
    nb := tail.recordcount;
    nbr := int(nb / 1000);
    InitGaugeMessHP('Traitement des grilles de taille (' + floattostr(nb) + ')', nbr, false, 0, 0);

    cd := '';
    tail.first;
    j := 0;
    WHILE NOT tail.eof DO
    BEGIN
        j := j + 1;
        IF j = 1000 THEN
        BEGIN
            IncGaugeMessHP(0);
            j := 0;
        END;
        IF cd <> Tailar_ref.asstring THEN
        BEGIN
            m_t.insert;
            M_tcode.asstring := Tailar_ref.asstring;
            M_tnom.asstring := Tailar_ref.asstring;
            m_t.post;
            cd := Tailar_ref.asstring;
        END;
        mtl.append;
        mtlcode_gt.asstring := cd;
        mtlnom.asstring := Taileg_enumere.asstring;
        mtl.post;
        tail.next;
    END;
    CloseGaugeMessHP;
    m_t.DelimiterChar := ';';
    mtl.DelimiterChar := ';';
    m_t.savetotextfile('c:\temp\transpoNehlig\gr_taille.csv');
    mtl.savetotextfile('c:\temp\transpoNehlig\gr_taille_lig.csv');

END;

PROCEDURE TForm1.LMDSpeedButton3Click(Sender: TObject);
BEGIN
    screen.Cursor := crSQLWait;
    cb.open;
    m_cb.open;
    m_cb.loadfromdataset(cb);
    m_cb.DelimiterChar := ';';
    m_cb.savetotextfile('c:\temp\transpoNehlig\CODE_BARRE.csv');
    screen.Cursor := crdefault;

END;

PROCEDURE TForm1.LMDSpeedButton4Click(Sender: TObject);
BEGIN
    screen.Cursor := crSQLWait;
    prix.open;
    m_p.open;
    m_p.loadfromdataset(prix);
    m_p.DelimiterChar := ';';
    m_p.savetotextfile('c:\temp\transpoNehlig\PRIX.csv');
    m_p.close;
    TRY
        prix.close;
    EXCEPT
    END;
    screen.Cursor := crdefault;
END;

PROCEDURE TForm1.LMDSpeedButton5Click(Sender: TObject);
VAR i: integer;
BEGIN
    screen.Cursor := crSQLWait;
    art.open;
    m_art.open;
    m_art.loadfromdataset(art);
    art.close;

    coul.open;
    m_c.loadfromdataset(coul);

    InitGaugeMessHP('Traitement des articles (' + floattostr(m_c.recordcount) + ')', m_c.recordcount, false, 0, 0);

    m_c.first;
    WHILE NOT m_c.eof DO
    BEGIN
        IncGaugeMessHP(0);
        IF m_art.locate('code', m_c.fieldbyname('ar_ref').asstring, []) THEN
        BEGIN

            FOR i := 1 TO 20 DO
            BEGIN
                IF m_art.fieldbyname('coul' + inttostr(i)).asstring = '' THEN
                //IF m_art.fields[10+i].asstring = '' THEN
                BEGIN
                    m_art.edit;
                    //m_art.fields[10+i].asstring
                    m_art.fieldbyname('coul' + inttostr(i)).asstring := m_c.fieldbyname('eg_enumere').asstring;
                    m_art.post;
                    BREAK;
                END;
            END;

        END;
        m_c.next;
    END;
    CloseGaugeMessHP;
    m_art.DelimiterChar := ';';
    m_art.savetotextfile('c:\temp\transpoNehlig\ARTICLES.csv');
    screen.Cursor := crdefault;
END;

PROCEDURE TForm1.M_artCalcFields(DataSet: TDataSet);
BEGIN
    MessageDlg('', mtWarning, [], 0);
END;

PROCEDURE TForm1.LMDSpeedButton6Click(Sender: TObject);
BEGIN
    LMDSpeedButton1Click(NIL);
    LMDSpeedButton2Click(NIL);
    LMDSpeedButton3Click(NIL);
    LMDSpeedButton4Click(NIL);
    LMDSpeedButton5Click(NIL);
    LMDSpeedButton8Click(NIL);
    InfoMessHP('Traitement terminé', false, 0, 0);

END;

procedure TForm1.FormCreate(Sender: TObject);
begin
    // ado.connected := true;
end;

procedure TForm1.LMDSpeedButton7Click(Sender: TObject);
begin
     ado.connected:=true;
     IF ado.connected THEN MessageDlg('Connexion locale OK', mtWarning, [], 0);
end;

procedure TForm1.LMDSpeedButton8Click(Sender: TObject);
begin
    screen.Cursor := crSQLWait;
    client.open;
    m_cl.open;
    m_cl.loadfromdataset(client);
    m_cl.DelimiterChar := ';';
    m_cl.savetotextfile('c:\temp\transpoNehlig\CLIENTS.csv');
    m_cl.close;
    screen.Cursor := crdefault;
end;

END.

