//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT RegroupFourn_frm;

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
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    ExtCtrls,
    RzPanel,
    fcStatusBar,
    RzBorder,
    LMDCustomComponent,
    LMDWndProcComponent,
    LMDFormShadow,
    Db,
    IBODataset,
    IB_Components,
    dxDBTLCl,
    dxGrClms,
    dxTL,
    dxDBCtrl,
    dxDBGrid,
    BmDelay,
    splashms,
    UserDlg,
    ActionRv,
    dxCntner,
    dxDBGridHP,
    StdCtrls,
    RzLabel,
    RzPanelRv,
    Variants;

TYPE
    TFrm_RegroupFourn = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Post: TLMDSpeedButton;
        RzPanelRv5: TRzPanelRv;
        RzLabel1: TRzLabel;
        RzLabel2: TRzLabel;
        RzLabel3: TRzLabel;
        RzLabel4: TRzLabel;
        RzLabel5: TRzLabel;
        RzLabel6: TRzLabel;
        RzLabel7: TRzLabel;
        RzLabel8: TRzLabel;
        RzLabel9: TRzLabel;
        RzPanelRv4: TRzPanelRv;
        DBG_Fourn: TdxDBGridHP;
        Pan_Mess: TRzPanelRv;
        Nbt_Regroup: TLMDSpeedButton;
        Lab_Charge: TRzLabel;
        Grd_Close: TGroupDataRv;
        Que_Fourn: TIBOQuery;
        Ds_Fourn: TDataSource;
        Dlg_Sel: TUserDlg;
        Dlg_Gauge: TSplashMessage;
        Timer1: TTimer;
        BM_Delai: TBmDelay;
        Que_Con: TIBOQuery;
        Que_FournRECID: TIntegerField;
        Que_FournFOU_ID: TIntegerField;
        Que_FournFOU_NOM: TStringField;
        Que_FournMRKNOMS: TMemoField;
        Que_FournMRKIDS: TMemoField;
        DBG_FournRECID: TdxDBGridMaskColumn;
        DBG_FournFOU_ID: TdxDBGridMaskColumn;
        DBG_FournFOU_NOM: TdxDBGridMaskColumn;
        DBG_FournMRKNOMS: TdxDBGridMemoColumn;
        DBG_FournMRKIDS: TdxDBGridMemoColumn;
        IbC_Cde: TIB_Cursor;
        IbC_BRE: TIB_Cursor;
        Que_ConCON_ID: TIntegerField;
        Que_ConCON_FOUID: TIntegerField;
        Que_Det: TIBOQuery;
        Que_DetFOD_ID: TIntegerField;
        Que_DetFOD_FOUID: TIntegerField;
        Que_Anu: TIBOQuery;
        Que_AnuANU_ID: TIntegerField;
        Que_AnuANU_FOUID: TIntegerField;
        IbC_Tar: TIB_Cursor;
        Que_CDE: TIBOQuery;
        Que_BRE: TIBOQuery;
        Que_Ret: TIBOQuery;
        Que_BREBRE_ID: TIntegerField;
        Que_BREBRE_FOUID: TIntegerField;
        Que_TAR: TIBOQuery;
        Que_TARCLG_ID: TIntegerField;
        Que_TARCLG_ARTID: TIntegerField;
        Que_TARCLG_FOUID: TIntegerField;
        Que_TARCLG_TGFID: TIntegerField;
        Que_TARCLG_PX: TIBOFloatField;
        Que_TARCLG_PXNEGO: TIBOFloatField;
        Que_TARCLG_PXVI: TIBOFloatField;
        Que_TARCLG_RA1: TIBOFloatField;
        Que_TARCLG_RA2: TIBOFloatField;
        Que_TARCLG_RA3: TIBOFloatField;
        Que_TARCLG_TAXE: TIBOFloatField;
        Que_TARCLG_PRINCIPAL: TIntegerField;
        Que_TarG: TIBOQuery;
        Que_TarGCLG_ID: TIntegerField;
        Que_TarGCLG_ARTID: TIntegerField;
        Que_TarGCLG_FOUID: TIntegerField;
        Que_TarGCLG_TGFID: TIntegerField;
        Que_TarGCLG_PX: TIBOFloatField;
        Que_TarGCLG_PXNEGO: TIBOFloatField;
        Que_TarGCLG_PXVI: TIBOFloatField;
        Que_TarGCLG_RA1: TIBOFloatField;
        Que_TarGCLG_RA2: TIBOFloatField;
        Que_TarGCLG_RA3: TIBOFloatField;
        Que_TarGCLG_TAXE: TIBOFloatField;
        Que_TarGCLG_PRINCIPAL: TIntegerField;
        Que_Import: TIBOQuery;
        Que_ImportIMP_ID: TIntegerField;
        Que_ImportIMP_GINKOIA: TIntegerField;
        IbC_KTB: TIB_Cursor;
        Que_RetRET_ID: TIntegerField;
        Que_RetRET_FOUID: TIntegerField;
        Que_FMKV: TIBOQuery;
        Que_FMKVFMK_ID: TIntegerField;
        Que_FMKVFMK_FOUID: TIntegerField;
        Que_FMKVFMK_MRKID: TIntegerField;
        Que_FMKVFMK_PRIN: TIntegerField;
        Que_FMKG: TIBOQuery;
        Que_FMKGFMK_ID: TIntegerField;
        Que_FMKGFMK_FOUID: TIntegerField;
        Que_FMKGFMK_MRKID: TIntegerField;
        Que_FMKGFMK_PRIN: TIntegerField;
        Que_VireFRN: TIBOQuery;
        Que_DetFOD_MAGID: TIntegerField;
        Que_DetFOD_NUMCLIENT: TStringField;
        Que_DetFOD_COMENT: TMemoField;
        Que_DetFOD_FTOID: TIntegerField;
        Que_DetFOD_MRGID: TIntegerField;
        Que_DetFOD_CPAID: TIntegerField;
        Que_DetFOD_ENCOURSA: TIBOFloatField;
        Que_DetG: TIBOQuery;
        Que_DetGFOD_ID: TIntegerField;
        Que_DetGFOD_FOUID: TIntegerField;
        Que_DetGFOD_MAGID: TIntegerField;
        Que_DetGFOD_NUMCLIENT: TStringField;
        Que_DetGFOD_COMENT: TMemoField;
        Que_DetGFOD_FTOID: TIntegerField;
        Que_DetGFOD_MRGID: TIntegerField;
        Que_DetGFOD_CPAID: TIntegerField;
        Que_DetGFOD_ENCOURSA: TIBOFloatField;
        Que_FRN: TIBOQuery;
        Que_FRNFOU_ID: TIntegerField;
        Que_FRNFOU_IDREF: TIntegerField;
        Que_FRNFOU_NOM: TStringField;
        Que_FRNFOU_ADRID: TIntegerField;
        Que_FRNFOU_TEL: TStringField;
        Que_FRNFOU_FAX: TStringField;
        Que_FRNFOU_EMAIL: TStringField;
        Que_FRNFOU_REMISE: TIBOFloatField;
        Que_FRNFOU_GROS: TIntegerField;
        Que_FRNFOU_CDTCDE: TStringField;
        Que_FRNFOU_CODE: TStringField;
        Que_FRNFOU_TEXTCDE: TMemoField;
        Que_CDECDE_ID: TIntegerField;
        Que_CDECDE_FOUID: TIntegerField;
        Pan_Sel: TRzPanelRv;
        RzLabel10: TRzLabel;
        lst_Sel: TListBox;
    Que_ImportIMP_REF: TIntegerField;
    Que_ImportIMP_NUM: TIntegerField;
    Que_TestImport: TIBOQuery;
    Que_TestImportNB: TIntegerField;
    Que_Achat: TIBOQuery;
    Que_AchatRPE_ID: TIntegerField;
    Que_AchatRPE_FOUID: TIntegerField;
    Que_FRNFOU_MAGIDPF: TIntegerField;
    Que_FRNFOU_INTRA: TIntegerField;
    Que_FRNFOU_ERPNO: TStringField;
    Que_FRNFOU_ACTIVE: TIntegerField;
    Que_FRNFOU_ILN: TStringField;
    Que_FRNFOU_CENTRALE: TIntegerField;
    Que_FRNFOU_TYPE: TIntegerField;
    Que_FRNFOU_RAPPAUTO: TIntegerField;
    Que_FRNFOU_NUMTVAINTRA: TStringField;
    Que_FRNFOU_DTRAPPAUTO: TDateField;
    Que_FRNFOU_REGLCENT: TIntegerField;
    Que_FRNFOU_IDEXTERNE: TStringField;
    Que_FRNFOU_SOURCE: TStringField;
    Que_FournFOU_CENTRALE: TIntegerField;
    DBG_FournFOU_CENTRALE: TdxDBGridCheckColumn;
    IbC_BLA: TIB_Cursor;
    Que_BLA: TIBOQuery;
    Que_BLABLA_ID: TIntegerField;
    Que_BLABLA_FOUID: TIntegerField;
    Que_VireFRNFOU_ID: TIntegerField;
    Que_VireFRNFOU_IDREF: TIntegerField;
    Que_VireFRNFOU_NOM: TStringField;
    Que_VireFRNFOU_ADRID: TIntegerField;
    Que_VireFRNFOU_TEL: TStringField;
    Que_VireFRNFOU_FAX: TStringField;
    Que_VireFRNFOU_EMAIL: TStringField;
    Que_VireFRNFOU_REMISE: TIBOFloatField;
    Que_VireFRNFOU_GROS: TIntegerField;
    Que_VireFRNFOU_CDTCDE: TStringField;
    Que_VireFRNFOU_CODE: TStringField;
    Que_VireFRNFOU_TEXTCDE: TMemoField;
    Que_VireFRNFOU_MAGIDPF: TIntegerField;
    Que_VireFRNFOU_INTRA: TIntegerField;
    Que_VireFRNFOU_ERPNO: TStringField;
    Que_VireFRNFOU_ACTIVE: TIntegerField;
    Que_VireFRNFOU_ILN: TStringField;
    Que_VireFRNFOU_CENTRALE: TIntegerField;
    Que_VireFRNFOU_TYPE: TIntegerField;
    Que_VireFRNFOU_RAPPAUTO: TIntegerField;
    Que_VireFRNFOU_NUMTVAINTRA: TStringField;
    Que_VireFRNFOU_DTRAPPAUTO: TDateField;
    Que_VireFRNFOU_REGLCENT: TIntegerField;
    Que_VireFRNFOU_IDEXTERNE: TStringField;
    Que_VireFRNFOU_SOURCE: TStringField;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE Timer1Timer(Sender: TObject);
        PROCEDURE AlgolStdFrmClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE Nbt_RegroupClick(Sender: TObject);
        PROCEDURE DBG_FournCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
            ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
            ASelected, AFocused, ANewItemRow: Boolean; VAR AText: STRING;
            VAR AColor: TColor; AFont: TFont; VAR AAlignment: TAlignment;
            VAR ADone: Boolean);
        PROCEDURE DBG_FournKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
    procedure GenerikUpdateRecord2(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    PRIVATE
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
        TSSEl: TStrings;
    { Public declarations }
    PUBLISHED
        PROCEDURE GenerikUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);

    END;

PROCEDURE DedoubFourn;

IMPLEMENTATION
{$R *.DFM}
USES
    ConstStd,
    StdUtils,
    Main_Dm;

PROCEDURE DedoubFourn;
VAR
    Frm_RegroupFourn: TFrm_RegroupFourn;
BEGIN
    Application.createform(TFrm_RegroupFourn, Frm_RegroupFourn);
    WITH Frm_RegroupFourn DO
    BEGIN
        TRY
            TsSel := TStringList.Create;
            TsSel.Clear;
            Timer1.Enabled := True;
            Hint := Caption;
            Showmodal;
        FINALLY
            TsSel.Free;
            Que_Fourn.Close;
            release;
        END;
    END;
END;

PROCEDURE TFrm_RegroupFourn.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_RegroupFourn.Nbt_PostClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_RegroupFourn.Timer1Timer(Sender: TObject);
BEGIN
    Timer1.Enabled := False;
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
        Dbg_Fourn.BeginUpdate;
        Que_Fourn.Open;
    FINALLY
        Dbg_Fourn.GotoFirst;
        Dbg_Fourn.EndUpdate;
        screen.Cursor := crDefault;
        Lab_Charge.Visible := False;
    END;

END;

PROCEDURE TFrm_RegroupFourn.GenerikUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_RegroupFourn.AlgolStdFrmClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    Grd_Close.Close;
END;

TYPE
    TmonSplashMessage = CLASS(TSplashMessage);

PROCEDURE TFrm_RegroupFourn.Nbt_RegroupClick(Sender: TObject);
VAR
    n: TdxTreeListNode;
    Ktb, Garde, Vire, Lasel, i, zero, un, choix: Integer;
    ch: STRING;
    Ts: TStrings;
    z: ARRAY[0..1] OF Integer;
    vDeleteVireFRN: Boolean;
BEGIN
    vDeleteVireFRN := False;

    IF Tssel.Count <> 2 THEN EXIT;

    TRY
        Ktb := 0;
        Ibc_Ktb.Close;
        Ibc_Ktb.Open;
        Ktb := Ibc_Ktb.Fields[0].asInteger;
    FINALLY
        Ibc_Ktb.close;
    END;

    IF Ktb = 0 THEN EXIT;

    Ts := TStringList.Create;
    z[0] := 0;
    z[1] := 0;
    garde := 0;
    Vire := 0;
    Ts.Clear;

    ch := 'Confirmez le regroupement des fournisseurs sélectionnés          ' + #13#10;
    FOR i := 0 TO 1 DO
    BEGIN
        ch := ch + #13#10 + '   ' + lst_Sel.Items[i];
        Z[i] := StrToInt(TsSel[i]);
        Ts.Add(Lst_Sel.Items[i]);
    END;
    ch := ch + #13#10 + '  ';

    TRY
        Screen.cursor := CrHourGlass;
        Ibc_Cde.close;
        Ibc_Cde.ParamByName('FOUID').asInteger := Z[0];
        Ibc_Cde.Open;
        Zero := Ibc_Cde.Fields[0].asinteger;
        Ibc_BRE.close;
        Ibc_BRE.ParamByName('FOUID').asInteger := Z[0];
        Ibc_BRE.Open;
        Zero := Zero + Ibc_BRE.Fields[0].asinteger;
        Ibc_TAR.close;
        Ibc_TAR.ParamByName('FOUID').asInteger := Z[0];
        Ibc_TAR.Open;
        Zero := Zero + Ibc_TAR.Fields[0].asinteger;  
        IbC_BLA.close;
        IbC_BLA.ParamByName('FOUID').asInteger := Z[0];
        IbC_BLA.Open;
        Zero := Zero + IbC_BLA.Fields[0].asinteger;

        Ibc_Cde.close;
        Ibc_Cde.ParamByName('FOUID').asInteger := Z[1];
        Ibc_Cde.Open;
        Un := Ibc_Cde.Fields[0].asinteger;
        Ibc_BRE.close;
        Ibc_BRE.ParamByName('FOUID').asInteger := Z[1];
        Ibc_BRE.Open;
        Un := Un + Ibc_BRE.Fields[0].asinteger;
        Ibc_TAR.close;
        Ibc_TAR.ParamByName('FOUID').asInteger := Z[1];
        Ibc_TAR.Open;
        Un := Un + Ibc_TAR.Fields[0].asinteger;  
        IbC_BLA.close;
        IbC_BLA.ParamByName('FOUID').asInteger := Z[1];
        IbC_BLA.Open;
        Un := Un + IbC_BLA.Fields[0].asinteger;

        IF Un > zero THEN
        BEGIN
            Choix := 1;
            Dlg_Gauge.Gauge.MaxValue := Zero + 5;
            Garde := Z[1];
            Vire := z[0];
            Dlg_Sel.SetParam('%G', Ts[1]);
            Dlg_Sel.SetParam('%V', Ts[0]);
        END
        ELSE BEGIN
            Choix := 0;
            Garde := Z[0];
            Vire := z[1];
            Dlg_Gauge.Gauge.MaxValue := Un + 5;
            Dlg_Sel.SetParam('%V', Ts[1]);
            Dlg_Sel.SetParam('%G', Ts[0]);
        END;

    FINALLY
        Ibc_Cde.close;
        Ibc_Bre.Close;
        Ibc_Tar.Close;
        IbC_BLA.Close;
        Screen.Cursor := CrDefault;
        TS.Free;
    END;

    // on vérifie que les deux fournisseurs choisi ne sont pas centrales, sinon il est impossible de faire la fusion
    que_VireFRN.Close;
    que_VireFRN.ParamByName('FOUID').asInteger := Vire;
    que_VireFRN.Open;

    que_FRN.Close;
    que_FRN.ParamByName('FOUID').asInteger := Garde;
    que_FRN.Open;

    if (Que_FRN.FieldByName('FOU_CENTRALE').AsInteger <> 0) AND (que_VireFRN.FieldByName('FOU_CENTRALE').AsInteger <> 0) then
    BEGIN
      MessageDlg('Impossible de regrouper deux fournisseurs centrale', mtInformation, [mbOk], 0);
      que_FRN.Close;
      que_VireFRN.Close;

      Exit;
    END;

    Lasel := Dlg_Sel.show;
     // Lasel est le choix user ... et choix sera notre sélection !
    Application.ProcessMessages;

    IF Lasel = 0 THEN
    BEGIN

        TRY
            Dlg_Gauge.Gauge.Progress := 0;
            Dlg_Gauge.Splash;
                // Problème dans XP ou la boite de méssage et qquefois sous l'application
            Application.processmessages;
            IF (TmonSplashMessage(Dlg_Gauge).SplashForm <> NIL) THEN
            BEGIN
                TmonSplashMessage(Dlg_Gauge).SplashForm.FormStyle := fsStayOnTop;
                Application.processmessages;
                TmonSplashMessage(Dlg_Gauge).SplashForm.FormStyle := fsNormal;
                TmonSplashMessage(Dlg_Gauge).SplashForm.Update;
            END;

            que_Con.Close;
            que_Con.ParamByName('FOUID').asInteger := Vire;
            que_Con.Open;
            Que_Con.First;
            WHILE NOT que_Con.eof DO
            BEGIN
                Que_Con.Edit;
                Que_ConCon_FOUID.asInteger := Garde;
                Que_Con.Post;
                Que_Con.Next;
            END;
            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;

            que_Det.Close;
            que_Det.ParamByName('FOUID').asInteger := Vire;
            que_Det.Open;

            que_DetG.Close;
            que_DetG.ParamByName('FOUID').asInteger := Garde;
            que_DetG.Open;

            Que_Det.First;
            WHILE NOT que_Det.eof DO
            BEGIN
                IF que_DetG.Locate('FOD_MAGID', Que_DetFOD_MAGID.asInteger, []) THEN
                BEGIN
                    que_DETG.Edit;
                    IF (Trim(que_DetGFOD_NUMCLIENT.asstring) = '') AND (Trim(que_DetFOD_NUMCLIENT.asstring) <> '') THEN
                        que_DetGFOD_NUMCLIENT.asstring := que_DetFOD_NUMCLIENT.asstring;
                    IF (Trim(que_DetGFOD_COMENT.asstring) = '') AND (Trim(que_DetFOD_COMENT.asstring) <> '') THEN
                        que_DetGFOD_COMENT.asstring := que_DetFOD_COMENT.asstring;
                    IF (que_DetGFOD_FTOID.asInteger = 0) AND (que_DetFOD_FTOID.asInteger <> 0) THEN
                        que_DetGFOD_FTOID.asInteger := que_DetFOD_FTOID.asInteger;
                    IF (que_DetGFOD_MRGID.asInteger = 0) AND (que_DetFOD_MRGID.asInteger <> 0) THEN
                        que_DetGFOD_MRGID.asInteger := que_DetFOD_MRGID.asInteger;
                    IF (que_DetGFOD_CPAID.asInteger = 0) AND (que_DetFOD_CPAID.asInteger <> 0) THEN
                        que_DetGFOD_CPAID.asInteger := que_DetFOD_CPAID.asInteger;
                    IF (que_DetGFOD_ENCOURSA.AsFloat = 0) AND (que_DetFOD_ENCOURSA.AsFloat <> 0) THEN
                        que_DetGFOD_ENCOURSA.AsFloat := que_DetFOD_ENCOURSA.AsFloat;
                    Que_DetG.Post;

                    que_Det.Next;

                    // plus de k_updated à 0, on ne touche plus les anciennes lignes on désactive simplement le fournisseur à présent
                    //Que_Det.Delete;
                END
                ELSE BEGIN
                    que_Det.Edit;
                    que_DETFOD_FOUID.asInteger := Garde;
                    que_Det.Post;
                    que_Det.Next;
                END;
            END;

            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;

            que_ANU.Close;
            que_ANU.ParamByName('FOUID').asInteger := Vire;
            que_ANU.Open;
            Que_ANU.First;
            WHILE NOT que_ANU.eof DO
            BEGIN
                Que_ANU.Edit;
                Que_ANUANU_FOUID.asInteger := Garde;
                Que_ANU.Post;
                Que_ANU.Next;
            END;
            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;

            que_CDE.Close;
            que_CDE.ParamByName('FOUID').asInteger := Vire;
            que_CDE.Open;
            Que_CDE.First;
            WHILE NOT que_CDE.eof DO
            BEGIN
                IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                    Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
                Application.ProcessMessages;
                Que_CDE.Edit;
                Que_CDECDE_FOUID.asInteger := Garde;
                Que_CDE.Post;
                Que_CDE.Next;
            END;

            que_BRE.Close;
            que_BRE.ParamByName('FOUID').asInteger := Vire;
            que_BRE.Open;
            Que_BRE.First;
            WHILE NOT que_BRE.eof DO
            BEGIN
                IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                    Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
                Application.ProcessMessages;
                Que_BRE.Edit;
                Que_BREBRE_FOUID.asInteger := Garde;
                Que_BRE.Post;
                Que_BRE.Next;
            END;

            que_RET.Close;
            que_RET.ParamByName('FOUID').asInteger := Vire;
            que_RET.Open;
            Que_RET.First;
            WHILE NOT que_RET.eof DO
            BEGIN
                IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                    Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
                Application.ProcessMessages;
                Que_RET.Edit;
                Que_RETRET_FOUID.asInteger := Garde;
                Que_RET.Post;
                Que_RET.Next;
            END;

            Que_BLA.Close;
            Que_BLA.ParamByName('FOUID').asInteger := Vire;
            Que_BLA.Open;
            Que_BLA.First;
            WHILE NOT Que_BLA.eof DO
            BEGIN
                IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                    Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
                Application.ProcessMessages;
                Que_BLA.Edit;
                Que_BLABLA_FOUID.asInteger := Garde;
                Que_BLA.Post;
                Que_BLA.Next;
            END;

            que_TAR.Close;
            que_TAR.ParamByName('FOUID').asInteger := Vire;
            que_TAR.Open;

            que_TARG.Close;
            que_TARG.ParamByName('FOUID').asInteger := Garde;
            que_TARG.Open;

            Que_TAR.First;
            WHILE NOT que_TAR.eof DO
            BEGIN
                IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                    Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
                Application.ProcessMessages;

                IF que_TarG.Locate('CLG_ARTID;CLG_TGFID', VarArrayOf([que_TarCLG_ARTID.asInteger, que_TarCLG_TGFID.asInteger]), []) THEN
                BEGIN
                    IF (que_TarCLG_PRINCIPAL.asInteger <> que_TarGCLG_PRINCIPAL.asInteger) AND
                        (que_TarGCLG_PRINCIPAL.asInteger = 0) THEN
                    BEGIN
                        Que_TarG.Edit;
                        Que_TarGCLG_PRINCIPAL.asInteger := 1;
                        Que_TARG.Post;
                    END;

                    Que_TAR.Delete;
                END
                ELSE BEGIN
                    Que_Tar.Edit;
                    Que_TarCLG_FOUID.asInteger := Garde;
                    Que_TAR.Post;
                    Que_TAR.Next;
                END;
            END;

            que_FMKV.Close;
            que_FMKV.ParamByName('FOUID').asInteger := Vire;
            que_FMKV.Open;

            que_FMKG.Close;
            que_FMKG.ParamByName('FOUID').asInteger := Garde;
            que_FMKG.Open;

            Que_FMKV.First;
            WHILE NOT Que_FMKV.Eof DO
            BEGIN
//                IF que_FMKG.Locate('FMK_MRKID', que_FMKVFMK_MRKID.asInteger, []) THEN
//
//                    Que_FMKV.Delete
//                // le lien existait donc faut pas générer de doublon !
//                ELSE BEGIN
//                    Que_FMKV.Edit;
//                    Que_FMKVFMK_FOUID.asInteger := Garde;
//                    Que_FMKVFMK_PRIN.asInteger := que_FMKVFMK_PRIN.asInteger;
//                    Que_FMKV.Post;
//                    Que_FMKV.Next;
//                END;
                // Si le lien n'existe pas déjà pour le fournisseur de destination, on met à jour celui du fournisseur d'origine
               IF not que_FMKG.Locate('FMK_MRKID', que_FMKVFMK_MRKID.asInteger, []) THEN
               BEGIN
                    Que_FMKV.Edit;
                    Que_FMKVFMK_FOUID.asInteger := Garde;
                    Que_FMKVFMK_PRIN.asInteger := que_FMKVFMK_PRIN.asInteger;
                    Que_FMKV.Post;
                END;

                Que_FMKV.Next;
            END;
            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;

            // Sandrine 23/08/2008 : ACHENTETE ==> attention déploiement >= V7.1.0
            Que_Achat.Close;
            Que_Achat.ParamByName('FOUID').asInteger := Vire;
            Que_Achat.Open;
            Que_Achat.First;
            WHILE NOT Que_Achat.eof DO
            BEGIN
                Que_Achat.Edit;
                Que_AchatRPE_FOUID.asInteger := Garde;
                Que_Achat.Post;
                Que_Achat.Next;
            END;
            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;


            {que_VireFRN.Close;
            que_VireFRN.ParamByName('FOUID').asInteger := Vire;
            que_VireFRN.Open;

            que_FRN.Close;
            que_FRN.ParamByName('FOUID').asInteger := Garde;
            que_FRN.Open;}


            que_Frn.Edit;
            IF (que_FrnFOU_IDREF.asInteger = 0) AND (que_VireFrnFOU_IDREF.asInteger <> 0) THEN
                que_FrnFOU_IDREF.asInteger := que_VireFrnFOU_IDREF.asInteger;
            IF (que_FrnFOU_ADRID.asInteger = 0) AND (que_VireFrnFOU_ADRID.asInteger <> 0) THEN
                que_FrnFOU_ADRID.asInteger := que_VireFrnFOU_ADRID.asInteger;
            IF (que_FrnFOU_Remise.asFloat = 0) AND (que_VireFrnFOU_Remise.asFloat <> 0) THEN
                que_FrnFOU_Remise.asFloat := que_VireFrnFOU_Remise.asFloat;
            IF (que_FrnFOU_GROS.asInteger = 0) AND (que_VireFrnFOU_GROS.asInteger <> 0) THEN
                que_FrnFOU_GROS.asInteger := que_VireFrnFOU_GROS.asInteger;

            IF (Trim(que_FRNFOU_TEL.asstring) = '') AND (Trim(que_VireFrnFOU_TEL.asstring) <> '') THEN
                que_FrnFOU_TEL.asstring := que_VireFrnFOU_TEL.asstring;
            IF (Trim(que_FRNFOU_FAX.asstring) = '') AND (Trim(que_VireFrnFOU_FAX.asstring) <> '') THEN
                que_FrnFOU_FAX.asstring := que_VireFrnFOU_FAX.asstring;
            IF (Trim(que_FRNFOU_EMAIL.asstring) = '') AND (Trim(que_VireFrnFOU_EMAIL.asstring) <> '') THEN
                que_FrnFOU_EMAIL.asstring := que_VireFrnFOU_EMAIL.asstring;
            IF (Trim(que_FRNFOU_CDTCDE.asstring) = '') AND (Trim(que_VireFrnFOU_CDTCDE.asstring) <> '') THEN
                que_FrnFOU_CDTCDE.asstring := que_VireFrnFOU_CDTCDE.asstring;
            IF (Trim(que_FRNFOU_TEXTCDE.asstring) = '') AND (Trim(que_VireFrnFOU_TEXTCDE.asstring) <> '') THEN
                que_FrnFOU_TEXTCDE.asstring := que_VireFrnFOU_TEXTCDE.asstring;

            // Cas Où le fournisseur gardé n'est pas un fournisseur centrale et que le fournisseur virée est un fournisseur centrale
            If Que_FRN.FieldByName('FOU_CENTRALE').AsInteger = 0 then
            begin
              IF (Trim(que_FRNFOU_CODE.asstring) = '') AND (Trim(que_VireFrnFOU_CODE.asstring) <> '') THEN
                  que_FrnFOU_CODE.asstring := que_VireFrnFOU_CODE.asstring;

              IF (Trim(Que_FRN.FieldByName('FOU_ILN').AsString) = '') AND (Trim(Que_VireFRN.FieldByName('FOU_ILN').AsString) <> '') THEN
                  Que_FRN.FieldByName('FOU_ILN').AsString := Que_VireFRN.FieldByName('FOU_ILN').AsString;

              if Que_VireFRN.FieldByName('FOU_CENTRALE').AsInteger <> 0 then
              begin
                // Si c'est un fournisseur centrale vers un fournisseur standard, alors on copie aussi le nom et le code du fournisseur centrale
                que_Frn.FieldByName('FOU_CODE').asstring := que_VireFrn.FieldByName('FOU_CODE').asstring;
                Que_FRN.FieldByName('FOU_NOM').AsString := Que_VireFRN.FieldByName('FOU_NOM').AsString;
                Que_FRN.FieldByName('FOU_CENTRALE').AsInteger := Que_VireFRN.FieldByName('FOU_CENTRALE').AsInteger;
                Que_FRN.FieldByName('FOU_ERPNO').AsString     := Que_VireFRN.FieldByName('FOU_ERPNO').AsString;

                Que_FRN.FieldByName('FOU_TYPE').AsString     := Que_VireFRN.FieldByName('FOU_TYPE').AsString;
                Que_FRN.FieldByName('FOU_RAPPAUTO').AsString   := Que_VireFRN.FieldByName('FOU_RAPPAUTO').AsString;
                Que_FRN.FieldByName('FOU_DTRAPPAUTO').AsString := Que_VireFRN.FieldByName('FOU_DTRAPPAUTO').AsString;
                Que_FRN.FieldByName('FOU_IDEXTERNE').AsString := Que_VireFRN.FieldByName('FOU_IDEXTERNE').AsString;
                Que_FRN.FieldByName('FOU_SOURCE').AsString := Que_VireFRN.FieldByName('FOU_SOURCE').AsString;


                // effacer ou à 0 dans le que_vire
                // centrale 0 erpno '' fou_type = 0 four_rapauto = 0 
              end;
            end;

            // on désactive l'ancien fournisseur et on met ses valeurs à 0
            que_VireFRN.Edit;
            que_VireFRN.FieldByName('FOU_IDREF').AsInteger := 0;
            que_VireFRN.FieldByName('FOU_ACTIVE').AsInteger := 0;

            que_VireFRN.FieldByName('FOU_CENTRALE').AsInteger := 0;
            que_VireFRN.FieldByName('FOU_ERPNO').AsString := '';
            que_VireFRN.FieldByName('FOU_TYPE').AsInteger := 0;
            que_VireFRN.FieldByName('FOU_RAPPAUTO').AsInteger := 0;


            que_VireFRN.Post;
            Que_FRN.Post;
                        
            // Mantis 6326 : On remet le k_enabled à 0 en supprimant à la fin du traitement.
            vDeleteVireFRN := True;

            que_Import.Close;
            que_Import.ParamByName('KTBID').asInteger := Ktb;
            que_Import.ParamByName('FOUID').asInteger := Vire;
            que_Import.Open;
            Que_Import.First;
            WHILE NOT Que_Import.eof DO
            BEGIN
                // Tester si IMP_KTB, IMP_GINKOIA, IMP_REF, IMP_NUM existe déjà !!
                Que_TestImport.Close;
                Que_TestImport.ParamByName('NUM').asInteger := Que_ImportIMP_NUM.asInteger;
                Que_TestImport.ParamByName('KTB').asInteger := Ktb;
                Que_TestImport.ParamByName('GINKOIA').asInteger := Garde;
                Que_TestImport.ParamByName('REF').asInteger := Que_ImportIMP_REF.asInteger;
                Que_TestImport.Open;

                // forcer la MAJ pour plus de sécurité
                Que_Import.Edit;
                Que_ImportIMP_GINKOIA.asInteger := Garde;
                Que_Import.Post;

                // supprimer l'éventuel doublon
                IF (Que_TestImportNB.asinteger <> 0) THEN
                BEGIN
                    Que_Import.Delete;
                END;
                Que_TestImport.Close;

                Que_Import.Next;
            END;

        FINALLY
            WITH DM_MAIN DO
            BEGIN
                TRY
                    StartTransaction;

                    IBOUpDateCache(que_Con);
                    IBOUpDateCache(que_Det);
                    IBOUpDateCache(que_DetG);
                    IBOUpDateCache(que_Anu);
                    IBOUpDateCache(que_CDE);
                    IBOUpDateCache(que_BRE);
                    IBOUpDateCache(que_RET);
                    IBOUpdateCache(que_TAR);
                    IBOUpdateCache(que_TARG);
                    IBOUpdateCache(que_FMKV);
                    IBOUpdateCache(Que_BLA);
                    IBOUpdateCache(que_Achat);
                    IBOUpdateCache(que_VireFRN);
                    IBOUpdateCache(que_FRN);
                    IBOUpdateCache(que_Import);

                    Commit;

                EXCEPT

                    Rollback;

                    IBOCancelCache(que_Con);
                    IBOCancelCache(que_Det);
                    IBOCancelCache(que_DetG);
                    IBOCancelCache(que_Anu);
                    IBOCancelCache(que_CDE);
                    IBOCancelCache(que_BRE);
                    IBOCancelCache(que_RET);
                    IBOCancelCache(que_TAR);
                    IBOCancelCache(que_TARG);
                    IBOCancelCache(que_FMKV);
                    IBOCancelCache(Que_BLA);
                    IBOCancelCache(que_Achat);
                    IBOCancelCache(que_VireFRN);
                    IBOCancelCache(que_FRN);
                    IBOCancelCache(que_Import);

                    vDeleteVireFRN := False;
                END;

                IBOCOmmitCache(que_Con);
                IBOCommitCache(que_Det);
                IBOCommitCache(que_DetG);
                IBOCommitCache(que_Anu);
                IBOCommitCache(que_CDE);
                IBOCommitCache(que_BRE);
                IBOCommitCache(que_RET);
                IBOCommitCache(que_TAR);
                IBOCommitCache(que_TARG);
                IBOCommitCache(que_FMKV);
                IBOCommitCache(Que_BLA);
                IBOCommitCache(que_Achat);
                IBOCommitCache(que_VireFRN);
                IBOCommitCache(que_FRN);
                IBOCommitCache(que_Import);

            END;

            Que_Con.close;
            Que_Det.Close;
            Que_DetG.Close;
            Que_Anu.close;
            Que_Cde.close;
            Que_Bre.close;
            Que_Ret.close;
            Que_Tar.close;
            Que_TarG.close;
            Que_FMKV.Close;
            Que_BLA.close;
            Que_FMKG.Close;
            que_Achat.Close;

            // on supprime ici car sinon les valeurs mises à jours ne sont pas prises en compte.
            if vDeleteVireFRN then
            begin
                Que_VireFRN.Delete;
                try
                    Dm_Main.StartTransaction;
                    Dm_Main.IBOUpdateCache(que_VireFRN);
                    Dm_Main.Commit;
                except
                    Dm_Main.Rollback;
                    Dm_Main.IBOCancelCache(que_VireFRN);
                end;
                Dm_Main.IBOCommitCache(que_VireFRN);
            end;

            Que_VireFRN.Close;
            Que_FRN.Close;
            Que_Import.close;
        END;

        Bm_Delai.Wait;
        Dlg_Gauge.Stop;
        Lst_Sel.clear;
        TsSel.Clear;
        TRY
            DBG_Fourn.BeginUpdate;
            Que_Fourn.Close;
            Que_Fourn.Open;
        FINALLY
            dbg_Fourn.EndUpdate;
            que_Fourn.Locate('FOU_ID', Garde, []);
        END;

    END;

END;

PROCEDURE TFrm_RegroupFourn.DBG_FournCustomDrawCell(Sender: TObject;
    ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
    AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
    VAR AText: STRING; VAR AColor: TColor; AFont: TFont;
    VAR AAlignment: TAlignment; VAR ADone: Boolean);
VAR
    id, i: Integer;
BEGIN
    id := dbg_Fourn.GetvalueByFieldName(Anode, 'FOU_ID');
    i := TsSel.IndexOF(IntToStr(id));
    IF i <> -1 THEN AColor := clYellow;
    Pan_Mess.Visible := Tssel.Count = 2;
END;

PROCEDURE TFrm_RegroupFourn.DBG_FournKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
VAR
    id, i: Integer;
BEGIN
    IF Dbg_Fourn.FocusedNode = NIL THEN EXIT;
    CASE Key OF
        VK_F3:
            BEGIN
                id := dbg_Fourn.GetvalueByFieldName(Dbg_Fourn.FocusedNode, 'FOU_ID');
                i := tsSel.IndexOF(intToStr(id));
                IF i <> -1 THEN
                BEGIN
                    TsSel.Delete(i);
                    Lst_sel.items.Delete(i);
                END
                ELSE BEGIN
                    IF TsSel.Count < 2 THEN
                    BEGIN
                        TsSel.add(IntToStr(id));
                        Lst_sel.items.Add(dbg_Fourn.GetvalueByFieldName(Dbg_Fourn.FocusedNode, 'FOU_NOM'));
                    END;
                END;
                Dbg_Fourn.Repaint;
            END;
    END;
END;

procedure TFrm_RegroupFourn.GenerikUpdateRecord2(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;


END.

