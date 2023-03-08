unit UnitPrincipale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, RzPanel, DB, ADODB,UnitThread, StdCtrls,
  ComCtrls, IB_Components, IBODataset, wwDialog, wwidlg, wwLookupDialogRv,
  RzLabel, Mask, wwdbedit, Wwdotdot, Wwdbcomb, wwDBComboBoxRv, RzEdit, RzDBEdit,
  RzDBBnEd, RzDBButtonEditRv, DBClient, dxCntner, dxTL, dxDBCtrl, dxDBGrid,
  wwcheckbox, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, RzLstBox, RzChkLst, RzPanelRv, dxmdaset,
  IB_Process, IB_Script;

type
  TFrm_Principale = class(TForm)
    Pan_fond: TRzPanel;
    Pan_Cmd: TRzPanel;
    Tim_Refresh: TTimer;
    Btn_Start: TButton;
    Btn_Stop: TButton;
    Btn_Quit: TButton;
    PgB_Traitement: TProgressBar;
    Lab_Cpt: TLabel;
    Lab_NbMat: TLabel;
    Pan_Haut: TRzPanel;
    Pan_Titre: TRzPanel;
    Lab_Titre: TRzLabel;
    OD_BdDSource: TOpenDialog;
    Pan_Info: TRzPanel;
    Lab_Info: TRzLabel;
    Lab_BdDGinkoia: TLabel;
    Chp_BdDGinkoia: TEdit;
    Btn_BdDGinkoia: TButton;
    Ginkoia: TIB_Connection;
    Memo_info: TMemo;
    Pan_param: TRzPanel;
    Pan_Mag: TRzPanelRv;
    Lab_ChoixMag: TRzLabel;
    Lbx_Mags: TRzCheckList;
    Pan_Fourn: TRzPanelRv;
    RzPanelRv1: TRzPanelRv;
    RzLabel1: TRzLabel;
    Lbx_Fourn: TListBox;
    RzPanelRv4: TRzPanelRv;
    RzPanelRv5: TRzPanelRv;
    Nbt_Fourn: TLMDSpeedButton;
    Nbt_VidFourn: TLMDSpeedButton;
    Pan_droite: TRzPanel;
    Pan_Exe: TRzPanelRv;
    Lab_Exe: TRzLabel;
    Chp_Exe: TRzDBButtonEditRv;
    Pan_Saison: TRzPanelRv;
    Lab_Sais: TRzLabel;
    Chk_Ete: TwwCheckBox;
    Chk_Hiver: TwwCheckBox;
    Pan_Tip: TRzPanelRv;
    Lab_Tip: TRzLabel;
    Chp_Tip: TRzDBButtonEditRv;
    RzPanelRv6: TRzPanelRv;
    Lab_Collection: TRzLabel;
    Chp_Collection: TRzDBButtonEditRv;
    Que_Collec: TIBOQuery;
    Que_CollecCOL_NOM: TStringField;
    Que_CollecCOL_ID: TIntegerField;
    Que_CollecCOL_NOVISIBLE: TIntegerField;
    LK_Collec: TwwLookupDialogRV;
    Que_Fournisseur: TIBOQuery;
    Que_FournisseurFOU_NOM: TStringField;
    Que_FournisseurFOU_ID: TIntegerField;
    Que_TipCde: TIBOQuery;
    Que_TipCdeTYP_ID: TIntegerField;
    Que_TipCdeTYP_LIB: TStringField;
    Que_TipCdeTYP_COD: TIntegerField;
    Que_TipCdeTYP_CATEG: TIntegerField;
    Que_Exercice: TIBOQuery;
    Que_ExerciceEXE_NOM: TStringField;
    Que_ExerciceEXE_ID: TIntegerField;
    Que_Mags: TIBOQuery;
    Que_MagsMAG_ENSEIGNE: TStringField;
    Que_MagsMAG_ID: TIntegerField;
    LK_EXE: TwwLookupDialogRV;
    LK_FOURN: TwwLookupDialogRV;
    LK_TipCde: TwwLookupDialogRV;
    Ds_Filtre: TDataSource;
    MemD_Filtre: TdxMemData;
    MemD_FiltreExeID: TIntegerField;
    MemD_FiltreExeNom: TStringField;
    MemD_FiltreTYPID: TIntegerField;
    MemD_FiltreTYPNOM: TStringField;
    MemD_FiltreCOLID: TIntegerField;
    MemD_FiltreCOLNOM: TStringField;
    Btn_createProc: TButton;
    Btn_DropProc: TButton;
    IB_Create: TIB_Script;
    procedure Tim_RefreshTimer(Sender: TObject);
    procedure Btn_StartClick(Sender: TObject);
    procedure Btn_StopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Btn_QuitClick(Sender: TObject);
    procedure Btn_BdDGinkoiaClick(Sender: TObject);
    procedure Nbt_FournClick(Sender: TObject);
    procedure Nbt_VidFournClick(Sender: TObject);
    procedure LK_FOURNCloseDialog(Dialog: TwwLookupDlg);
    procedure Btn_createProcClick(Sender: TObject);
    procedure Btn_DropProcClick(Sender: TObject);
  private
    { Déclarations privées }
    function InitParam:boolean;
  public
    { Déclarations publiques }
  end;

var
  Frm_Principale: TFrm_Principale;
  Transpo       : TTranspoThread;

implementation
{$R *.dfm}

function TFrm_Principale.InitParam:boolean;
  VAR
    ch, arch, Chsel, ChMag: STRING;
    i: Integer;
    Vide, fmag: Boolean;
    NbMag : Integer;
BEGIN
    result := false;
    Fmag := False;
    Vide := False;
    Arch := '|0|1|';

    FOR i := 0 TO Lbx_mags.items.count - 1 DO
    BEGIN
        IF Lbx_mags.ItemChecked[i] THEN
        BEGIN
            Fmag := True;
            BREAK;
        END;
    END;

    IF NOT Fmag THEN
    BEGIN
        showmessage('Il faut cocher au moins un magasin !...');
        EXIT;
    END;

    IF (Lbx_Fourn.Count <= 0) THEN
    BEGIN
        showmessage('Au moins un fournisseur doit être désigné, à moins d''avoir coché l''option "Tous Fournisseurs"');
        EXIT;
    END;


    IF (NOT Chk_Ete.Checked) AND (NOT Chk_Hiver.Checked) THEN
    BEGIN
        showmessage('Il faut saisir au moins une saison !...');
        EXIT;
    END;
    IF memd_FiltreEXEID.asInteger = 0 THEN
    BEGIN
        IF NOT MessageDlg('Lorsqu''aucun exercice commercial n''est défini,' + #13 + #10 +
                          'seules les commandes NON CLOTUREES sont prises en compte...' + #13 + #10 + #13 + #10 +
                          'Souhaitez-vous continuer ?...',mtInformation,[mbYes,mbNo], 0,mbyes)=mrno THEN
        BEGIN
          EXIT;
        END;
    END;

    TRY
        //Param saison
        ch := '';
        ch := '|';
        IF Chk_Ete.Checked THEN ch := ch + '0|';
        IF Chk_Hiver.Checked THEN ch := ch + '1|';
        Param_SAIS := ch;

        //Param exercice et arch
        ch := '';
        IF memd_FiltreEXEID.asInteger <> 0 THEN
            ch := '|' + memd_FiltreEXEID.asString + '|'
        ELSE
            arch := '|0|';
        Param_CIAL := ch;
        Param_ARCH := arch;

        //Param tip
        ch := '';
            IF memd_FiltreTYPID.asInteger <> 0 THEN
                ch := '|' + memd_FiltreTYPID.asString + '|';
        Param_TIP := ch;


        //Param collection
        ch := '';
        IF memd_FiltreCOLID.asInteger <> 0 THEN
            ch := '|' + memd_FiltreCOLID.asString + '|';
        Param_COLID := ch;

        //Param Fournisseur
        ch := '|';
        FOR i := 0 TO Lbx_mags.items.count - 1 DO
        BEGIN
          ch := ch + IntToStr(Integer(Lbx_Fourn.Items.Objects[I])) + '|';
        END;
        Param_FOURN := ch;


        //Param mag
        ch := '|';
        FOR i := 0 TO Lbx_mags.items.count - 1 DO
        BEGIN
            IF Lbx_mags.ItemChecked[i] THEN
                ch := ch + IntToStr(Integer(Lbx_Mags.Items.Objects[I])) + '|';
        END;
        Param_MAGID := ch;

        result := true;
    FINALLY
        screen.Cursor := CrDefault;
    END;
end;
procedure TFrm_Principale.Btn_BdDGinkoiaClick(Sender: TObject);
begin
  OD_BdDSource.Filter          := 'fichier ib|*.ib';
  OD_BdDSource.FileName        := Chp_BdDGinkoia.Text;
  if OD_BdDSource.Execute then
  begin
    Memo_info.Clear;
    Chp_BdDGinkoia.Text          := OD_BdDSource.FileName;
    Ginkoia.Connected            := False;
    Ginkoia.DatabaseName         := Chp_BdDGinkoia.Text;
    Ginkoia.Connected            := True;
    Pan_Param.Enabled            := True;
    Que_Collec.DatabaseName      := Ginkoia.DatabaseName;
    Que_Mags.DatabaseName        := Ginkoia.DatabaseName;
    Que_Fournisseur.DatabaseName := Ginkoia.DatabaseName;
    Que_TipCde.DatabaseName      := Ginkoia.DatabaseName;
    Que_Exercice.DatabaseName    := Ginkoia.DatabaseName;
    Que_Collec.Open;
    Que_Mags.Open;
    Que_Fournisseur.Open;
    Que_TipCde.Open;
    Que_Exercice.Open;
    MemD_Filtre.Close;
    MemD_Filtre.open;
    Lbx_mags.Clear;
    Que_Mags.First;
    while Not Que_Mags.eof do
    begin
      Lbx_Mags.AddObject(Que_Mags.FieldByName('MAG_ENSEIGNE').AsString,TOBJECT(Que_Mags.FieldByName('MAG_ID').AsInteger));
      Que_Mags.Next;
    end;
    Lbx_Fourn.clear;
  end;
end;

procedure TFrm_Principale.Btn_createProcClick(Sender: TObject);
begin
  //Ajout de la procedure stocké
  Try
    IB_Create.SQL.clear;
    IB_Create.SQL.add('CREATE PROCEDURE DIAG_CARNETCDE(');
    IB_Create.SQL.add('  MAGSID VARCHAR(2048) CHARACTER SET NONE,');
    IB_Create.SQL.add('  SAIS VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CIAL VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  FOURN VARCHAR(2048) CHARACTER SET NONE,');
    IB_Create.SQL.add('  TIP VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  ARCH VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  COLID VARCHAR(32) CHARACTER SET NONE)');
    IB_Create.SQL.add('RETURNS(');
    IB_Create.SQL.add('  R_RECID INTEGER,');
    IB_Create.SQL.add('  R_CDEID INTEGER,');
    IB_Create.SQL.add('  R_MAGID INTEGER,');
    IB_Create.SQL.add('  R_ARTID INTEGER,');
    IB_Create.SQL.add('  R_COUID INTEGER,');
    IB_Create.SQL.add('  R_LIVRAISON DATE,');
    IB_Create.SQL.add('  R_OFFSET INTEGER,');
    IB_Create.SQL.add('  R_TVA NUMERIC(18, 7),');
    IB_Create.SQL.add('  R_PXCTLG NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_PXACHAT NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_PXVENTE NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_MTCTLG NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_MTACHAT NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_MTVENTE NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_QTECDE NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_QTERAL NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_QTEANU NUMERIC(18, 4),');
    IB_Create.SQL.add('  R_TIPCDE VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  R_VALRAL NUMERIC(18, 4),');
    IB_Create.SQL.add('  ART_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  MRK_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  ART_REFMRK VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  ARF_CHRONO VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  SEC_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  RAY_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  FAM_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  SSF_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CTF_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CAT_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  GRE_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CLA1 VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CLA2 VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CLA3 VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CLA4 VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CLA5 VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  FOU_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CDE_NUMERO VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CDE_SAISON INTEGER,');
    IB_Create.SQL.add('  EXE_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  MAG_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  MAG_ENSEIGNE VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  DATCDE DATE,');
    IB_Create.SQL.add('  COU_NOM VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  ART_DESCRIPTION VARCHAR(255) CHARACTER SET NONE,');
    IB_Create.SQL.add('  MRGV NUMERIC(18, 4),');
    IB_Create.SQL.add('  VALTVA NUMERIC(18, 4),');
    IB_Create.SQL.add('  SAISON VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CDE_USRID INTEGER,');
    IB_Create.SQL.add('  USR_USERNAME VARCHAR(64) CHARACTER SET NONE,');
    IB_Create.SQL.add('  COL_NOM VARCHAR(32) CHARACTER SET NONE,');
    IB_Create.SQL.add('  CDL_ID INTEGER)');
    IB_Create.SQL.add('AS');
    IB_Create.SQL.add('DECLARE VARIABLE DLIVR DATE;');
    IB_Create.SQL.add('DECLARE VARIABLE ARCH1 INTEGER;');
    IB_Create.SQL.add('DECLARE VARIABLE ARCH2 INTEGER;');
    IB_Create.SQL.add('DECLARE VARIABLE CCODE VARCHAR(64);');
    IB_Create.SQL.add('DECLARE VARIABLE CNOM VARCHAR(64);');
    IB_Create.SQL.add('begin');
    IB_Create.SQL.add('    R_RECID=0;');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('    FOR SELECT');
    IB_Create.SQL.add('        L.CDL_CDEID,');
    IB_Create.SQL.add('        CDE_MAGID,');
    IB_Create.SQL.add('        L.CDL_ARTID,');
    IB_Create.SQL.add('        L.CDL_COUID,');
    IB_Create.SQL.add('        L.CDL_LIVRAISON,');
    IB_Create.SQL.add('        L.CDL_OFFSET,');
    IB_Create.SQL.add('        L.CDL_TVA,');
    IB_Create.SQL.add('        TYP_LIB,');
    IB_Create.SQL.add('        ART_NOM,');
    IB_Create.SQL.add('        MRK_NOM,');
    IB_Create.SQL.add('        ART_REFMRK,');
    IB_Create.SQL.add('        ARF_CHRONO,');
    IB_Create.SQL.add('        SEC_NOM,');
    IB_Create.SQL.add('        RAY_NOM,');
    IB_Create.SQL.add('        FAM_NOM,');
    IB_Create.SQL.add('        SSF_NOM,');
    IB_Create.SQL.add('        CTF_NOM,');
    IB_Create.SQL.add('        CAT_NOM,');
    IB_Create.SQL.add('        GRE_NOM,');
    IB_Create.SQL.add('        C1.ICL_NOM,');
    IB_Create.SQL.add('        C2.ICL_NOM,');
    IB_Create.SQL.add('        C3.ICL_NOM,');
    IB_Create.SQL.add('        C4.ICL_NOM,');
    IB_Create.SQL.add('        C5.ICL_NOM,');
    IB_Create.SQL.add('        FOU_NOM,');
    IB_Create.SQL.add('        CDE_NUMERO,');
    IB_Create.SQL.add('        CDE_SAISON,');
    IB_Create.SQL.add('        EXE_NOM,');
    IB_Create.SQL.add('        MAG_ENSEIGNE,');
    IB_Create.SQL.add('        MAG_ENSEIGNE,');
    IB_Create.SQL.add('        CAST (CDE_DATE AS DATE),');
    IB_Create.SQL.add('        COU_NOM,');
    IB_Create.SQL.add('        COU_CODE,');
    IB_Create.SQL.add('        ART_DESCRIPTION,');
    IB_Create.SQL.add('        MIN (L.CDL_PXCTLG),');
    IB_Create.SQL.add('        MIN (L.CDL_PXACHAT),');
    IB_Create.SQL.add('        MIN (L.CDL_PXVENTE),');
    IB_Create.SQL.add('        SUM (L.CDL_QTE*L.CDL_PXCTLG),');
    IB_Create.SQL.add('        SUM (L.CDL_QTE*L.CDL_PXACHAT),');
    IB_Create.SQL.add('        SUM (L.CDL_QTE*L.CDL_PXVENTE),');
    IB_Create.SQL.add('        SUM (L.CDL_QTE ),');
    IB_Create.SQL.add('        CDE_USRID,');
    IB_Create.SQL.add('    	USR_USERNAME,');
    IB_Create.SQL.add('        COL_NOM,');
    IB_Create.SQL.add('        L.CDL_ID');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('        FROM combcde');
    IB_Create.SQL.add('        JOIN K ON (K_ID=CDE_ID AND K_ENABLED=1)');
    IB_Create.SQL.add('        JOIN ARTFOURN ON (FOU_ID=CDE_FOUID)');
    IB_Create.SQL.add('        JOIN GENMAGASIN ON (MAG_ID=CDE_MAGID)');
    IB_Create.SQL.add('        JOIN GENEXERCICECOMMERCIAL ON (EXE_ID=CDE_EXEID)');
    IB_Create.SQL.add('        JOIN GENTYPCDV ON (TYP_ID=CDE_TYPID)');
    IB_Create.SQL.add('        JOIN combcdel L');
    IB_Create.SQL.add('             JOIN K ON (K_ID=CDL_ID AND K_ENABLED=1)');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('             JOIN PLXCOULEUR ON (COU_ID=CDL_COUID)');
    IB_Create.SQL.add('             JOIN ARTARTICLE');
    IB_Create.SQL.add('                  JOIN ARTMARQUE ON (MRK_ID=ART_MRKID)');
    IB_Create.SQL.add('                  JOIN ARTGENRE ON (GRE_ID=ART_GREID)');
    IB_Create.SQL.add('                  JOIN NKLSSFAMILLE');
    IB_Create.SQL.add('                       JOIN NKLFAMILLE');
    IB_Create.SQL.add('                            JOIN NKLCATFAMILLE ON (CTF_ID=FAM_CTFID)');
    IB_Create.SQL.add('                            JOIN NKLRAYON');
    IB_Create.SQL.add('                                 JOIN NKLSECTEUR ON (SEC_ID=RAY_SECID)');
    IB_Create.SQL.add('                            ON (RAY_ID=FAM_RAYID)');
    IB_Create.SQL.add('                       ON (FAM_ID=SSF_FAMID)');
    IB_Create.SQL.add('                  ON (SSF_ID=ART_SSFID)');
    IB_Create.SQL.add('                  JOIN ARTREFERENCE');
    IB_Create.SQL.add('                        JOIN NKLCATEGORIE ON (CAT_ID=ARF_CATID)');
    IB_Create.SQL.add('                        JOIN ARTITEMC C1 ON (ICL_ID=ARF_ICLID1)');
    IB_Create.SQL.add('                        JOIN ARTITEMC C2 ON (ICL_ID=ARF_ICLID2)');
    IB_Create.SQL.add('                        JOIN ARTITEMC C3 ON (ICL_ID=ARF_ICLID3)');
    IB_Create.SQL.add('                        JOIN ARTITEMC C4 ON (ICL_ID=ARF_ICLID4)');
    IB_Create.SQL.add('                        JOIN ARTITEMC C5 ON (ICL_ID=ARF_ICLID5)');
    IB_Create.SQL.add('                        ON (ARF_ARTID=CDL_ARTID)');
    IB_Create.SQL.add('                  ON (ART_ID=CDL_ARTID)');
    IB_Create.SQL.add('             ON (CDL_CDEID=CDE_ID)');
    IB_Create.SQL.add('    	JOIN UilUsers ON (USR_ID=CDE_USRID)');
    IB_Create.SQL.add('        JOIN ARTCOLLECTION ON (COL_ID=CDE_COLID)');
    IB_Create.SQL.add('        WHERE');
    IB_Create.SQL.add('          :MAGSID Like ''%|''||CDE_MAGID||''|%''');
    IB_Create.SQL.add('          AND ((:SAIS Like ''%|''||CDE_SAISON||''|%'') or (:SAIS=''''))');
    IB_Create.SQL.add('          AND ((:FOURN LIKE ''%|''||CDE_FOUID||''|%'') or (:FOURN=''''))');
    IB_Create.SQL.add('          AND ((:CIAL LIKE ''%|''||CDE_EXEID||''|%'') or (:CIAL=''''))');
    IB_Create.SQL.add('          AND ((:TIP LIKE ''%|''||CDE_TYPID||''|%'') or (:TIP=''''))');
    IB_Create.SQL.add('          AND ((:ARCH LIKE ''%|''||CDE_ARCHIVE||''|%'') or (:ARCH=''''))');
    IB_Create.SQL.add('          AND ((:COLID LIKE ''%|''||CDE_COLID||''|%'') or (:COLID=''''))');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('        GROUP BY');
    IB_Create.SQL.add('        L.CDL_CDEID,');
    IB_Create.SQL.add('        CDE_MAGID,');
    IB_Create.SQL.add('        L.CDL_ARTID,');
    IB_Create.SQL.add('        L.CDL_COUID,');
    IB_Create.SQL.add('        L.CDL_LIVRAISON,');
    IB_Create.SQL.add('        L.CDL_OFFSET,');
    IB_Create.SQL.add('        L.CDL_TVA,');
    IB_Create.SQL.add('        TYP_LIB,');
    IB_Create.SQL.add('        ART_NOM,');
    IB_Create.SQL.add('        MRK_NOM,');
    IB_Create.SQL.add('        ART_REFMRK,');
    IB_Create.SQL.add('        ARF_CHRONO,');
    IB_Create.SQL.add('        SEC_NOM,');
    IB_Create.SQL.add('        RAY_NOM,');
    IB_Create.SQL.add('        FAM_NOM,');
    IB_Create.SQL.add('        SSF_NOM,');
    IB_Create.SQL.add('        CTF_NOM,');
    IB_Create.SQL.add('        CAT_NOM,');
    IB_Create.SQL.add('        GRE_NOM,');
    IB_Create.SQL.add('        C1.ICL_NOM,');
    IB_Create.SQL.add('        C2.ICL_NOM,');
    IB_Create.SQL.add('        C3.ICL_NOM,');
    IB_Create.SQL.add('        C4.ICL_NOM,');
    IB_Create.SQL.add('        C5.ICL_NOM,');
    IB_Create.SQL.add('        FOU_NOM,');
    IB_Create.SQL.add('        CDE_NUMERO,');
    IB_Create.SQL.add('        CDE_SAISON,');
    IB_Create.SQL.add('        EXE_NOM,');
    IB_Create.SQL.add('        MAG_ENSEIGNE,');
    IB_Create.SQL.add('        MAG_ENSEIGNE,');
    IB_Create.SQL.add('        CDE_DATE,');
    IB_Create.SQL.add('        COU_NOM,');
    IB_Create.SQL.add('        COU_CODE,');
    IB_Create.SQL.add('        ART_DESCRIPTION,');
    IB_Create.SQL.add('        CDE_USRID,');
    IB_Create.SQL.add('        USR_USERNAME,');
    IB_Create.SQL.add('        COL_NOM,');
    IB_Create.SQL.add('        L.CDL_ID');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('        ORDER BY MAG_ENSEIGNE,CDE_SAISON,EXE_NOM,MRK_NOM,FOU_NOM,L.CDL_CDEID,CDE_DATE,L.CDL_LIVRAISON,ARF_CHRONO,L.CDL_COUID');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('    INTO :R_CDEID, :R_MAGID, :R_ARTID, :R_COUID, :DLIVR, :R_OFFSET, :R_TVA, :R_TIPCDE,');
    IB_Create.SQL.add('        :ART_NOM,');
    IB_Create.SQL.add('        :MRK_NOM,');
    IB_Create.SQL.add('        :ART_REFMRK,');
    IB_Create.SQL.add('        :ARF_CHRONO,');
    IB_Create.SQL.add('        :SEC_NOM,');
    IB_Create.SQL.add('        :RAY_NOM,');
    IB_Create.SQL.add('        :FAM_NOM,');
    IB_Create.SQL.add('        :SSF_NOM,');
    IB_Create.SQL.add('        :CTF_NOM,');
    IB_Create.SQL.add('        :CAT_NOM,');
    IB_Create.SQL.add('        :GRE_NOM,');
    IB_Create.SQL.add('        :CLA1,');
    IB_Create.SQL.add('        :CLA2,');
    IB_Create.SQL.add('        :CLA3,');
    IB_Create.SQL.add('        :CLA4,');
    IB_Create.SQL.add('        :CLA5,');
    IB_Create.SQL.add('        :FOU_NOM,');
    IB_Create.SQL.add('        :CDE_NUMERO,');
    IB_Create.SQL.add('        :CDE_SAISON,');
    IB_Create.SQL.add('        :EXE_NOM,');
    IB_Create.SQL.add('        :MAG_NOM,');
    IB_Create.SQL.add('        :MAG_ENSEIGNE,');
    IB_Create.SQL.add('        :DATCDE,');
    IB_Create.SQL.add('        :CNOM,');
    IB_Create.SQL.add('        :CCODE,');
    IB_Create.SQL.add('        :ART_DESCRIPTION,');
    IB_Create.SQL.add('        :R_PXCTLG, :R_PXACHAT, :R_PXVENTE,');
    IB_Create.SQL.add('        :R_MTCTLG, :R_MTACHAT, :R_MTVENTE,');
    IB_Create.SQL.add('        :R_QTECDE,');
    IB_Create.SQL.add('        :CDE_USRID,');
    IB_Create.SQL.add('    	:USR_USERNAME,');
    IB_Create.SQL.add('        :COL_NOM,');
    IB_Create.SQL.add('        :CDL_ID');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('');
    IB_Create.SQL.add('    DO BEGIN');
    IB_Create.SQL.add('        SUSPEND;');
    IB_Create.SQL.add('    END');
    IB_Create.SQL.add('end');
    IB_Create.Execute;

    //Grant de la procedure
    IB_Create.SQL.Clear;
    IB_Create.SQL.add('grant execute on procedure DIAG_CARNETCDE to GINKOIA');
    IB_Create.Execute;
  except on E:exception do
    showmessage(E.message)
  End;
end;

procedure TFrm_Principale.Btn_DropProcClick(Sender: TObject);
begin
  //Grant de la procedure
  Try
    IB_Create.SQL.Clear;
    IB_Create.SQL.add('drop procedure DIAG_CARNETCDE');
    IB_Create.Execute;
  except on E:exception do
    showmessage(E.message)
  End;
end;

procedure TFrm_Principale.Btn_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Principale.Btn_StartClick(Sender: TObject);
begin
  //Contrôle les connections aux bases de données
  if (Not Ginkoia.Connected) then
    Begin
      MessageDlg('Aucune base de données n''est connectée.',mtInformation,[mbOK],0);
      exit;
    End;
  Memo_info.Clear;
  if not InitParam then exit;
  Btn_createProc.Click;
  Btn_Start.enabled := False;
  Btn_Quit.enabled  := False;
  Stop              := False;
  Start             := True;
  Btn_Stop.enabled  := True;
end;

procedure TFrm_Principale.Btn_StopClick(Sender: TObject);
begin
  Btn_Stop.enabled  := False;
  Stop              := True;
end;

procedure TFrm_Principale.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Transpo.Suspend;
  Que_Collec.Close;
  Que_Mags.Close;
  Que_Fournisseur.Close;
  Que_TipCde.Close;
  Que_Exercice.Close;
end;

procedure TFrm_Principale.FormCreate(Sender: TObject);
begin
  //Start du thread
  Transpo.Resume;

  //Initialisation de variable
  DecimalSeparator   := '.';
  LibInfo            := 'Cliquez sur Start pour commencer la transpo';
  ChemSource         := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

procedure TFrm_Principale.LK_FOURNCloseDialog(Dialog: TwwLookupDlg);
begin
  Lbx_Fourn.AddItem(Que_Fournisseur.FieldByName('FOU_NOM').AsString,TOBJECT(Que_Fournisseur.FieldByName('FOU_ID').AsInteger));
end;

procedure TFrm_Principale.Nbt_FournClick(Sender: TObject);
begin
  Lk_Fourn.Execute;
end;

procedure TFrm_Principale.Nbt_VidFournClick(Sender: TObject);
begin
  IF Lbx_Fourn.Items.Count > 0 THEN
  BEGIN
    Lbx_Fourn.Items.Delete(Lbx_Fourn.ItemIndex);
  END;
end;

procedure TFrm_Principale.Tim_RefreshTimer(Sender: TObject);
begin
  //Réinitialisation une fois le traitement terminé
  if (NbLigne=-1) then
    Begin
      NbLigne           := 0;
      Btn_Stop.enabled  := False;
      Stop              := False;
      Start             := False;
      Btn_Start.enabled := True;
      Btn_Quit.enabled  := True;
    End;

  //Raffraichi l'affichage
  Lab_Info.caption        := LibInfo;
  PgB_Traitement.Min      := 0;
  PgB_Traitement.Max      := NbLigne;
  PgB_Traitement.Position := Compteur;
  Lab_Cpt.caption := IntToStr(Compteur) + ' / ' + IntToStr(NbLigne);
end;

initialization
  Transpo :=  TTranspoThread.Create(true);
finalization
  Transpo.Free;
end.
