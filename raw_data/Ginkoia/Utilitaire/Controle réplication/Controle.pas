//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Controle;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    AlgolStdFrm,
    LMDCustomComponent,
    LMDIniCtrl,
    ExtCtrls,
    RzPanel,
    RzPanelRv,
    dxDBCtrl,
    dxDBGrid,
    dxTL,
    dxCntner,
    dxDBGridRv,
    Db,
    dxmdaset, StdCtrls, wwdbdatetimepicker, wwDBDateTimePickerRv, RzLabel,
  BmDelay;

TYPE
    TFrmBase = CLASS ( TAlgolStdFrm )
        IniCtrl: TLMDIniCtrl;
        MemD_Cont: TdxMemData;
        MemD_Contclient: TStringField;
        MemD_ContRecuHier: TIntegerField;
        MemD_ContEmisHier: TIntegerField;
        MemD_ContRecuAujourdhui: TIntegerField;
        MemD_ContEmisAujourdhui: TIntegerField;
        Ds_Cont: TDataSource;
        dxDBGridRv1: TdxDBGridRv;
        dxDBGridRv1RecId: TdxDBGridColumn;
        dxDBGridRv1client: TdxDBGridMaskColumn;
        dxDBGridRv1RecuHier: TdxDBGridMaskColumn;
        dxDBGridRv1EmisHier: TdxDBGridMaskColumn;
        dxDBGridRv1RecuAujourdhui: TdxDBGridMaskColumn;
        dxDBGridRv1EmisAujourdhui: TdxDBGridMaskColumn;
        RzPanelRv1: TRzPanelRv;
    Chp_Date: TwwDBDateTimePickerRv;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    delay: TBmDelay;
        PROCEDURE dxDBGridRv1CustomDrawCell ( Sender: TObject; ACanvas: TCanvas;
            ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
            ASelected, AFocused, ANewItemRow: Boolean; VAR AText: STRING;
            VAR AColor: TColor; AFont: TFont; VAR AAlignment: TAlignment;
            VAR ADone: Boolean ) ;
    procedure Chp_DateChange(Sender: TObject);
    procedure AlgolStdFrmActivate(Sender: TObject);
    Private
    { Private declarations }
    Protected
    { Protected declarations }
    Public
    { Public declarations }
    Published
    { Published declarations }
    END;

VAR
    FrmBase: TFrmBase;

IMPLEMENTATION
{$R *.DFM}

PROCEDURE TFrmBase.dxDBGridRv1CustomDrawCell ( Sender: TObject;
    ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
    AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
    VAR AText: STRING; VAR AColor: TColor; AFont: TFont;
    VAR AAlignment: TAlignment; VAR ADone: Boolean ) ;

VAR
    nbr: integer;

BEGIN
//    IF acolumn.caption <> 'Client' THEN
//    BEGIN
//        TRY
//            nbr := anode.values[acolumn.index+1];
//            IF nbr <> 0 THEN
//            BEGIN
//                IF int ( nbr / 15 ) = nbr / 15 THEN
//                   color := clgreen
//                else
//                   color:= clred;
//            END;
//            //IF nbr=0 THEN atext:='';
//        EXCEPT
//        END;
//
//    END;
END;

procedure TFrmBase.Chp_DateChange(Sender: TObject);
VAR
    Year, Month, Day: word;
    YYA, mma, ddA: STRING;
    YYy, mmy, ddy: STRING;
    folder: STRING;
    i: integer;
    numero: STRING;
    client, chemin, hier: STRING;
    sr: TSearchRec;

    recuAujourdhui, recuhier, emisaujourdhui, emishier: integer;

BEGIN
    delay.wait; 


    memd_cont.close;
    memd_cont.open;

    

    DecodeDate ( chp_date.Date, Year, Month, Day ) ;
    YYA := inttostr ( year ) ;
    mmA := inttostr ( month ) ;
    IF length ( mma ) = 1 THEN mma := '0' + mma;
    ddA := inttostr ( day ) ;
    IF length ( dda ) = 1 THEN dda := '0' + dda;

    DecodeDate ( chp_date.Date - 1, Year, Month, Day ) ;
    YYy := inttostr ( year ) ;
    mmy := inttostr ( month ) ;
    IF length ( mmy ) = 1 THEN mmy := '0' + mmy;
    ddy := inttostr ( day ) ;
    IF length ( ddy ) = 1 THEN ddy := '0' + ddy;

//Lecture du fichier ini

    FOR i := 1 TO 999 DO
    BEGIN
        numero := inttostr ( i ) ;
        client := IniCtrl.readString ( 'CLIENT', numero, '' ) ;
        chemin := IniCtrl.readString ( 'PATH', numero, '' ) ;
        hier := IniCtrl.readString ( 'HIER', numero, '' ) ;

        IF ( client <> '' ) AND ( chemin <> '' ) THEN
        BEGIN

            recuaujourdhui := 0;
            emisaujourdhui := 0;
            recuhier := 0;
            emishier := 0;

              //Rechercher le nombre de paquet Recus aujourd'hui
            folder := chemin + 'batch\' + yya + '\' + mma + '\' + dda + '\*.*';
            IF FindFirst ( folder, faanyfile, sr ) = 0 THEN
            BEGIN
                IF sr.attr <> fadirectory THEN inc ( recuAujourdhui ) ;
                WHILE FindNext ( sr ) = 0 DO
                BEGIN
                    IF sr.attr <> fadirectory THEN inc ( recuAujourdhui ) ;
                END;
            END;
            FindClose ( sr ) ;

              //Rechercher le nombre de paquet Emis aujourd'hui
            folder := chemin + 'Extract\' + yya + '\' + mma + '\' + dda + '\*.*';
            IF FindFirst ( folder, faAnyFile, sr ) = 0 THEN
            BEGIN
                IF sr.attr <> fadirectory THEN inc ( EmisAujourdhui ) ;
                WHILE FindNext ( sr ) = 0 DO
                BEGIN
                    IF sr.attr <> fadirectory THEN inc ( EmisAujourdhui ) ;
                END;
            END;
            FindClose ( sr ) ;

              //Rechercher le nombre de paquet Recus hier
            folder := chemin + 'batch\' + yyy + '\' + mmy + '\' + ddy + '\*.*';
            IF FindFirst ( folder, faAnyFile, sr ) = 0 THEN
            BEGIN
                IF sr.attr <> fadirectory THEN inc ( recuhier ) ;
                WHILE FindNext ( sr ) = 0 DO
                BEGIN
                    IF sr.attr <> fadirectory THEN inc ( recuHier ) ;
                END;
            END;
            FindClose ( sr ) ;

              //Rechercher le nombre de paquet hier aujourd'hui
            folder := chemin + 'Extract\' + yyy + '\' + mmy + '\' + ddy + '\*.*';
            IF FindFirst ( folder, faAnyFile, sr ) = 0 THEN
            BEGIN
                IF sr.attr <> fadirectory THEN inc ( EmisHier ) ;
                WHILE FindNext ( sr ) = 0 DO
                BEGIN
                    IF sr.attr <> fadirectory THEN inc ( EmisHier ) ;
                END;
            END;
            FindClose ( sr ) ;

            memd_cont.append;
            memd_cont.fieldbyname ( 'client' ) .asstring := client;
            memd_cont.fieldbyname ( 'RecuHier' ) .asinteger := recuhier;
            memd_cont.fieldbyname ( 'EmisHier' ) .asinteger := emishier;
            memd_cont.fieldbyname ( 'RecuAujourdhui' ) .asinteger := recuAujourdhui;
            memd_cont.fieldbyname ( 'EmisAujourdhui' ) .asinteger := emisAujourdhui;
            memd_cont.post;

//            MessageDlg ( client + ' RA : ' + inttostr ( recuaujourdhui ) +
//                ' / EA : ' + inttostr ( emisaujourdhui ) +
//                ' / RH : ' + inttostr ( recuhier ) +
//                ' / EH : ' + inttostr ( emishier ) , mtWarning, [], 0 ) ;

        END;
    END;

END;


procedure TFrmBase.AlgolStdFrmActivate(Sender: TObject);
begin
chp_date.Date:=now;
end;

END.

