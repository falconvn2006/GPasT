//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Marques_Frm;

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
    StdCtrls,
    RzPanelRv,
    dxDBTLCl,
    dxGrClms,
    dxTL,
    dxDBCtrl,
    dxDBGrid,
    dxCntner,
    dxDBGridHP,
    RzLabel,
    Boxes,
    PanBtnDbgHP,
    dxmdaset,
    IB_Components,
    splashms,
    UserDlg,
    ActionRv,
    BmDelay
//    , IBODataset
    ;

TYPE
    TFrm_Marques = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Post: TLMDSpeedButton;
        Que_Mrk: TIBOQuery;
        Ds_Mrk: TDataSource;
        Que_RechTable: TIBOQuery;
        RzPanelRv1: TRzPanelRv;
        RzPanelRv2: TRzPanelRv;
        RzPanelRv3: TRzPanelRv;
        Timer1: TTimer;
        Lab_Charge: TRzLabel;
        RzPanelRv5: TRzPanelRv;
        RzLabel1: TRzLabel;
        RzLabel2: TRzLabel;
        RzLabel3: TRzLabel;
        RzLabel4: TRzLabel;
        RzLabel5: TRzLabel;
        RzLabel6: TRzLabel;
        RzLabel7: TRzLabel;
        RzLabel8: TRzLabel;
        Que_MrkRECID: TIntegerField;
        Que_MrkMRK_ID: TIntegerField;
        Que_MrkMRK_NOM: TStringField;
        Que_MrkFOUNOMS: TMemoField;
        RzPanelRv4: TRzPanelRv;
        DBG_Mrk: TdxDBGridHP;
        DBG_MrkRECID: TdxDBGridMaskColumn;
        DBG_MrkMRK_ID: TdxDBGridMaskColumn;
        DBG_MrkMRK_NOM: TdxDBGridMaskColumn;
        DBG_MrkFOUNOMS: TdxDBGridMemoColumn;
        Pan_mess: TRzPanelRv;
        Nbt_Regroup: TLMDSpeedButton;
        RzLabel9: TRzLabel;
        Lbx_M: TListBox;
        LMDSpeedButton1: TLMDSpeedButton;
        IbC_Art: TIB_Cursor;
        IbC_Loc: TIB_Cursor;
        Dlg_Sel: TUserDlg;
        Que_MrkFOUIDS: TMemoField;
        DBG_MrkFOUIDS: TdxDBGridColumn;
        Dlg_Gauge: TSplashMessage;
        Que_Article: TIBOQuery;
        Que_LocArticle: TIBOQuery;
        Que_ArticleART_ID: TIntegerField;
        Que_ArticleART_MRKID: TIntegerField;
        Que_LocArticleARL_ID: TIntegerField;
        Que_LocArticleARL_MRKID: TIntegerField;
        Que_Etik: TIBOQuery;
        Que_EtikETQ_ID: TIntegerField;
        Que_EtikETQ_MRKID: TIntegerField;
        Que_EtikD: TIBOQuery;
        Que_EtikDETD_ID: TIntegerField;
        Que_EtikDETD_MRKID: TIntegerField;
        Que_Vire: TIBOQuery;
        Que_FMKV: TIBOQuery;
        Que_FMKVFMK_ID: TIntegerField;
        Que_FMKVFMK_FOUID: TIntegerField;
        Que_FMKVFMK_MRKID: TIntegerField;
        Que_FMKVFMK_PRIN: TIntegerField;
        Que_Garde: TIBOQuery;
        Que_FMKG: TIBOQuery;
        Que_VireMRK_ID: TIntegerField;
        Que_VireMRK_IDREF: TIntegerField;
        Que_VireMRK_NOM: TStringField;
        Que_VireMRK_CONDITION: TMemoField;
        Que_VireMRK_CODE: TStringField;
        Que_FMKGFMK_ID: TIntegerField;
        Que_FMKGFMK_FOUID: TIntegerField;
        Que_FMKGFMK_MRKID: TIntegerField;
        Que_FMKGFMK_PRIN: TIntegerField;
        BM_Delai: TBmDelay;
        IbC_KTB: TIB_Cursor;
        Que_Import: TIBOQuery;
        Grd_Close: TGroupDataRv;
        Que_ImportIMP_ID: TIntegerField;
        Que_ImportIMP_GINKOIA: TIntegerField;
        Pan_Sel: TRzPanelRv;
        Lab_1: TRzLabel;
        lst_Sel: TListBox;
        Que_ImportIMP_REF: TIntegerField;
        Que_ImportIMP_NUM: TIntegerField;
        Que_TestImport: TIBOQuery;
        Que_TestImportNB: TIntegerField;
    Que_SAV: TIBOQuery;
    Que_SAVMAT_ID: TIntegerField;
    Que_SAVMAT_MRKID: TIntegerField;
    Que_VireMRK_ACTIVE: TIntegerField;
    Que_VireMRK_PROPRE: TIntegerField;
    Que_VireMRK_CENTRALE: TIntegerField;
    Que_GardeMRK_ID: TIntegerField;
    Que_GardeMRK_IDREF: TIntegerField;
    Que_GardeMRK_NOM: TStringField;
    Que_GardeMRK_CONDITION: TMemoField;
    Que_GardeMRK_CODE: TStringField;
    Que_GardeMRK_ACTIVE: TIntegerField;
    Que_GardeMRK_PROPRE: TIntegerField;
    Que_GardeMRK_CENTRALE: TIntegerField;
    Que_GardeMRK_IDEXTERNE: TStringField;
    Que_GardeMRK_SOURCE: TStringField;
    Que_VireMRK_IDEXTERNE: TStringField;
    Que_VireMRK_SOURCE: TStringField;
    Que_MrkMRK_CENTRALE: TIntegerField;
    DBG_MrkMRK_CENTRALE: TdxDBGridCheckColumn;
    Ibc_MDV: TIB_Cursor;
    Ibc_BAP: TIB_Cursor;
    Que_DPVMateriel: TIBOQuery;
    Que_CSHBPA: TIBOQuery;
    Que_DPVMaterielMDV_ID: TIntegerField;
    Que_DPVMaterielMDV_MRKID: TIntegerField;
    Que_CSHBPABAP_ID: TIntegerField;
    Que_CSHBPABAP_MRKID: TIntegerField;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE LMDSpeedButton1Click(Sender: TObject);
        PROCEDURE Timer1Timer(Sender: TObject);
        PROCEDURE Nbt_RegroupClick(Sender: TObject);
        PROCEDURE GenerikUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE AlgolStdFrmClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE DBG_MrkKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE DBG_MrkCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
            ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
            ASelected, AFocused, ANewItemRow: Boolean; VAR AText: STRING;
            VAR AColor: TColor; AFont: TFont; VAR AAlignment: TAlignment;
            VAR ADone: Boolean);
    procedure GenerikAfterCancel(DataSet: TDataSet);
    procedure GenerikAfterPost(DataSet: TDataSet);
    procedure GenerikBeforeDelete(DataSet: TDataSet);
    procedure GenerikNewRecord(DataSet: TDataSet);
    procedure GenerikUpdateRecord2(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    PRIVATE
        TsSel: TStrings;
        FUNCTION Liste_Table_Par_Id(Id: STRING): TstringList;

    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED

    END;

PROCEDURE DeDoubMarques;

IMPLEMENTATION
{$R *.DFM}
USES
    ConstStd,
    StdUtils,
    Main_Dm;

PROCEDURE DeDoubMarques;
VAR
    Frm_Marques: TFrm_Marques;
BEGIN
    Application.createform(TFrm_Marques, Frm_Marques);
    WITH Frm_Marques DO
    BEGIN
        TRY
            TsSel := TstringList.Create;
            TsSel.clear;
            Timer1.Enabled := True;
            Hint := Caption;
            Showmodal;
        FINALLY
            TsSel.Free;
            Que_Mrk.Close;
            release;
        END;
    END;
END;

PROCEDURE TFrm_Marques.Nbt_PostClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

FUNCTION TFrm_Marques.Liste_Table_Par_Id(Id: STRING): TstringList;
BEGIN
    IF Pos('_', Id) > 0 THEN
        delete(id, 1, Pos('_', Id));

    Que_RechTable.Close;
    Que_RechTable.Sql.Clear;
    Que_RechTable.Sql.ADD('Select rdb$field_Name Champs, RDB$Relation_Name Tables');
    Que_RechTable.Sql.ADD('  from rdb$relation_fields ');
    Que_RechTable.Sql.ADD(' where rdb$field_Name like ''%/_' + Uppercase(ID) + '%'' escape ''/'' ');
    Que_RechTable.Sql.ADD(' order by RDB$Relation_Name');
    result := tstringList.create;
    Que_RechTable.Open;
    WHILE NOT Que_RechTable.Eof DO
    BEGIN
        result.add(Que_RechTable.Fields[1].AsString + ';' + Que_RechTable.Fields[0].AsString);
        Que_RechTable.Next;
    END;
    Que_RechTable.Close;

END;

PROCEDURE TFrm_Marques.LMDSpeedButton1Click(Sender: TObject);
BEGIN
    Lbx_M.Items.Clear;
    Lbx_M.Items.assign(Liste_Table_Par_Id('FOUID'));
END;

PROCEDURE TFrm_Marques.Timer1Timer(Sender: TObject);
BEGIN
    Timer1.Enabled := False;
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
        Dbg_Mrk.BeginUpdate;
        Que_Mrk.Open;
    FINALLY
        Dbg_Mrk.GotoFirst;
        Dbg_Mrk.EndUpdate;
        screen.Cursor := crDefault;
        Lab_Charge.Visible := False;
    END;

END;

TYPE
    TmonSplashMessage = CLASS(TSplashMessage);

PROCEDURE TFrm_Marques.Nbt_RegroupClick(Sender: TObject);
VAR
    n: TdxTreeListNode;
    Ktb, Garde, Vire, Lasel, i, zero, un, choix: Integer;
    s, ch: STRING;
    z: ARRAY[0..1] OF Integer;
    Ts: TStrings;
    vDeleteVireMRK: Boolean;
BEGIN
  vDeleteVireMRK := False;

  Ts := TStringList.Create;
  TRY
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

    garde := 0;
    Vire := 0;
    s := '';
    ch := 'Confirmez le regroupement des marques sélectionnées          ' + #13#10;
    FOR i := 0 TO 1 DO
    BEGIN
        ch := ch + #13#10 + '   ' + lst_Sel.Items[i];
        Z[i] := StrToInt(TsSel[i]);
        s := Lst_Sel.Items[i];
        //Dlg_Sel.SetParam('%' + IntToStr(i), s);
        Ts.Add(Lst_Sel.Items[i]);
    END;
    ch := ch + #13#10 + '  ';

    //Lasel := Dlg_Sel.show;
     // Lasel est le choix user ... et choix sera notre sélection !
    //Application.ProcessMessages;

//    IF Lasel <> 2 THEN
//    BEGIN
    TRY
        Screen.cursor := CrHourGlass;
        Ibc_Art.close;
        Ibc_Art.ParamByName('MRKID').asInteger := Z[0];
        Ibc_Art.Open;
        Zero := Ibc_Art.Fields[0].asinteger;
        Ibc_Loc.close;
        Ibc_Loc.ParamByName('MRKID').asInteger := Z[0];
        Ibc_Loc.Open;
        Zero := Zero + Ibc_Loc.Fields[0].asinteger;
        Ibc_MDV.close;
        Ibc_MDV.ParamByName('MRKID').asInteger := Z[0];
        Ibc_MDV.Open;
        Zero := Zero + Ibc_MDV.Fields[0].asinteger;
        Ibc_BAP.close;
        Ibc_BAP.ParamByName('MRKID').asInteger := Z[0];
        Ibc_BAP.Open;
        Zero := Zero + Ibc_BAP.Fields[0].asinteger;

        Ibc_Art.close;
        Ibc_Art.ParamByName('MRKID').asInteger := Z[1];
        Ibc_Art.Open;
        Un := Ibc_Art.Fields[0].asinteger;
        Ibc_Loc.close;
        Ibc_Loc.ParamByName('MRKID').asInteger := Z[1];
        Ibc_Loc.Open;
        Un := Un + Ibc_Loc.Fields[0].asinteger;
        Ibc_MDV.close;
        Ibc_MDV.ParamByName('MRKID').asInteger := Z[1];
        Ibc_MDV.Open;
        Un := Un + Ibc_MDV.Fields[0].asinteger;
        Ibc_BAP.close;
        Ibc_BAP.ParamByName('MRKID').asInteger := Z[1];
        Ibc_BAP.Open;
        Un := Un + Ibc_BAP.Fields[0].asinteger;

        Choix := 0;
        Garde := Z[0];
        Vire := z[1];
        Dlg_Sel.SetParam('%V', Ts[1]);
        Dlg_Sel.SetParam('%G', Ts[0]);
        Dlg_Gauge.Gauge.MaxValue := un + 5;

        IF Un > zero THEN
        BEGIN
            Choix := 1;
            Dlg_Gauge.Gauge.MaxValue := Zero + 5;
            Garde := Z[1];
            Vire := z[0];
            Dlg_Sel.SetParam('%G', Ts[1]);
            Dlg_Sel.SetParam('%V', Ts[0]);
        END;

//        if (Lasel = 1) then
//        begin
//           Choix := 1;
//           Dlg_Gauge.Gauge.MaxValue := Zero + 5;
//           Garde := Z[1];
//           Vire := z[0];
//        end;
    FINALLY
        Ibc_Art.close;
        Ibc_Loc.Close;
        Ibc_MDV.Close;
        Ibc_BAP.Close;
        Screen.Cursor := CrDefault;
    END;
  FINALLY
    ts.Free;
  END;

  // on vérifie que les deux fournisseurs choisi ne sont pas centrales, sinon il est impossible de faire la fusion

  que_Vire.Close;
  que_Vire.ParamByName('MRKID').asInteger := Vire;
  que_Vire.Open;

  que_Garde.Close;
  que_Garde.ParamByName('MRKID').asInteger := Garde;
  que_Garde.Open;

  if (que_Vire.FieldByName('MRK_CENTRALE').AsInteger <> 0) and (que_Garde.FieldByName('MRK_CENTRALE').AsInteger <> 0) then
  BEGIN
    MessageDlg('Impossible de regrouper deux marques centrale', mtInformation, [mbOk], 0);
    que_Garde.Close;
    que_Vire.Close;

    Exit;
  END;

  Lasel := Dlg_Sel.show;
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

//                que_Etik.Close;
//                que_Etik.ParamByName('MRKID').asInteger := Vire;
//                que_Etik.Open;
//                Que_Etik.First;
//                WHILE NOT que_Etik.eof DO
//                BEGIN
//                     Que_Etik.Edit;
//                     Que_EtikETQ_MRKID.asInteger := Garde;
//                     Que_Etik.Post;
//                     Que_Etik.Next;
//                END;
//                IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
//                    Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
//                Application.ProcessMessages;
//
//                que_EtikD.Close;
//                que_EtikD.ParamByName('MRKID').asInteger := Vire;
//                que_EtikD.Open;
//                Que_EtikD.First;
//                WHILE NOT que_EtikD.eof DO
//                BEGIN
//                     Que_EtikD.Edit;
//                     Que_EtikDETD_MRKID.asInteger := Garde;
//                     Que_EtikD.Post;
//                     Que_EtikD.Next;
//                END;
//                IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
//                    Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
//                Application.ProcessMessages;

        que_Article.Close;
        que_Article.ParamByName('MRKID').asInteger := Vire;
        que_Article.Open;
        Que_Article.First;
        WHILE NOT que_Article.eof DO
        BEGIN
            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;
            Que_Article.Edit;
            Que_ArticleART_MRKID.asInteger := Garde;
            Que_Article.Post;
            Que_Article.Next;
        END;

        que_LocArticle.Close;
        que_LocArticle.ParamByName('MRKID').asInteger := Vire;
        que_LocArticle.Open;
        Que_LocArticle.First;
        WHILE NOT que_LocArticle.eof DO
        BEGIN
            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;
            Que_LocArticle.Edit;
            Que_LocArticleARL_MRKID.asInteger := Garde;
            Que_LocArticle.Post;
            Que_LocArticle.Next;
        END;

        Que_DPVMateriel.Close;
        Que_DPVMateriel.ParamByName('MRKID').asInteger := Vire;
        Que_DPVMateriel.Open;
        Que_DPVMateriel.First;
        WHILE NOT Que_DPVMateriel.eof DO
        BEGIN
            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;
            Que_DPVMateriel.Edit;
            Que_DPVMaterielMDV_MRKID.asInteger := Garde;
            Que_DPVMateriel.Post;
            Que_DPVMateriel.Next;
        END;

        Que_CSHBPA.Close;
        Que_CSHBPA.ParamByName('MRKID').asInteger := Vire;
        Que_CSHBPA.Open;
        Que_CSHBPA.First;
        WHILE NOT Que_CSHBPA.eof DO
        BEGIN
            IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
                Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
            Application.ProcessMessages;
            Que_CSHBPA.Edit;
            Que_CSHBPABAP_MRKID.asInteger := Garde;
            Que_CSHBPA.Post;
            Que_CSHBPA.Next;
        END;


        IF Lasel <> Choix THEN
        BEGIN
            Que_Garde.Edit;
            Que_GardeMRK_NOM.AsString       := Que_VireMRK_NOM.AsString;
            Que_GardeMRK_IDREF.AsInteger    := Que_VireMRK_IDREF.AsInteger;
            Que_GardeMRK_CONDITION.AsString := Que_VireMRK_CONDITION.AsString;
            Que_GardeMRK_PROPRE.AsInteger   := Que_VireMRK_PROPRE.AsInteger;
            IF Que_VireMRK_CODE.AsString <> '' THEN
              Que_GardeMRK_CODE.AsString := Que_VireMRK_CODE.AsString;
            Que_Garde.Post;
        END
        ELSE                           
        BEGIN
            IF ((Que_VireMRK_CODE.AsString <> '') AND
                (Que_GardeMRK_CODE.AsString = '')) THEN
            BEGIN
                Que_Garde.Edit;
                Que_GardeMRK_CODE.AsString := Que_VireMRK_CODE.AsString;
                Que_Garde.Post;
            END;
        END;

        // Cas Où la marque gardée n'est pas une marque centrale et que la marque virée est une marque centrale
        if Que_Garde.FieldbyName('MRK_CENTRALE').AsInteger = 0 then
        begin
          if Que_Vire.FieldbyName('MRK_CENTRALE').AsInteger <> 0 then
          begin
            Que_Garde.Edit;
            Que_Garde.FieldByName('MRK_CENTRALE').AsInteger := Que_Vire.FieldByName('MRK_CENTRALE').AsInteger;
            Que_Garde.FieldByName('MRK_NOM').AsString       := Que_Vire.FieldByName('MRK_NOM').AsString;
            Que_Garde.FieldByName('MRK_CODE').AsString      := Que_Vire.FieldByName('MRK_CODE').AsString;
            //Que_Garde.FieldByName('MRK_IDREF').AsInteger    := Que_Vire.FieldByName('MRK_IDREF').AsInteger;
            Que_Garde.FieldByName('MRK_PROPRE').AsInteger   := Que_Vire.FieldByName('MRK_PROPRE').AsInteger;

            Que_Garde.FieldByName('MRK_IDEXTERNE').AsString   := Que_Vire.FieldByName('MRK_IDEXTERNE').AsString;
            Que_Garde.FieldByName('MRK_SOURCE').AsString   := Que_Vire.FieldByName('MRK_SOURCE').AsString;

            Que_Garde.Post;
          end;
        end;

        // on désactive l'ancienne marque et on met ses valeurs à 0
        que_Vire.Edit;
        que_Vire.FieldByName('MRK_IDREF').AsInteger := 0;
        que_Vire.FieldByName('MRK_ACTIVE').AsInteger := 0;

        que_Vire.FieldByName('MRK_CENTRALE').AsInteger := 0;
        que_Vire.FieldByName('MRK_CODE').AsString := '';
        que_Vire.FieldByName('MRK_PROPRE').AsInteger := 0;
        que_Vire.FieldByName('MRK_SOURCE').AsString := '';
        que_Vire.FieldByName('MRK_IDEXTERNE').AsString := '';
        Que_Vire.Post;

        // Mantis 6326 : On remet le k_enabled à 0 en supprimant à la fin du traitement.
        vDeleteVireMRK := True;

        IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
            Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
        Application.ProcessMessages;

        que_FMKV.Close;
        que_FMKV.ParamByName('MRKID').asInteger := Vire;
        que_FMKV.Open;

        que_FMKG.Close;
        que_FMKG.ParamByName('MRKID').asInteger := Garde;
        que_FMKG.Open;

        Que_FMKV.First;
        WHILE NOT Que_FMKV.Eof DO
        BEGIN
//                IF que_FMKG.Locate('FMK_FOUID', que_FMKVFMK_FOUID.asInteger, []) THEN
//                    Que_FMKV.Delete
//                         // le lien existait donc faut pas générer de doublon !
//                ELSE BEGIN
//                    Que_FMKV.Edit;
//                    Que_FMKVFMK_MRKID.asInteger := Garde;
//                    Que_FMKVFMK_PRIN.asInteger := 0;
//                         // car la marque gardée avait forcément son fournisseur principal dejà défini !
//                         // donc les liens éventuellement rajoutés ne peuvent pas être les principaux....
//                    Que_FMKV.Post;
//                    Que_FMKV.Next;
//                END;

            // Si le lien n'existe pas déjà pour la marque de destination, on met à jour celui de la marque d'origine
           IF not que_FMKG.Locate('FMK_FOUID', que_FMKVFMK_FOUID.asInteger, []) THEN
           BEGIN
                Que_FMKV.Edit;
                Que_FMKVFMK_MRKID.asInteger := Garde;
                Que_FMKVFMK_PRIN.asInteger := 0;
                     // car la marque gardée avait forcément son fournisseur principal dejà défini !
                     // donc les liens éventuellement rajoutés ne peuvent pas être les principaux....
                Que_FMKV.Post;
            END;
            Que_FMKV.Next;
        END;
        IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
            Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
        Application.ProcessMessages;

        // Sandrine 23/08/2008 : ACHENTETE ==> attention déploiement >= V7.1.0
        Que_SAV.Close;
        Que_SAV.ParamByName('MRKID').asInteger := Vire;
        Que_SAV.Open;
        Que_SAV.First;
        WHILE NOT Que_SAV.eof DO
        BEGIN
            Que_SAV.Edit;
            Que_SAVMAT_MRKID.asInteger := Garde;
            Que_SAV.Post;
            Que_SAV.Next;
        END;
        IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
            Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
        Application.ProcessMessages;

        que_Import.Close;
        que_Import.ParamByName('KTBID').asInteger := Ktb;
        que_Import.ParamByName('MRKID').asInteger := Vire;
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

                IBOUpDateCache(que_Article);
                IBOUpDateCache(que_LocArticle);
//                            IBOUpDateCache(que_Etik);
//                            IBOUpDateCache(que_EtikD);
                IBOUpDateCache(Que_SAV);
                IBOUpDateCache(Que_DPVMateriel);
                IBOUpDateCache(Que_CSHBPA);
                IBOUpDateCache(que_Garde);
                IBOUpDateCache(que_Vire);
                IBOUpdateCache(que_FMKV);
                IBOUpdateCache(que_IMPORT);
                Commit;

            EXCEPT

                Rollback;

                IBOCancelCache(que_Article);
                IBOCancelCache(que_LocArticle);
//                            IBOCancelCache(que_Etik);
//                            IBOCancelCache(que_EtikD);
                IBOCancelCache(Que_SAV);
                IBOCancelCache(Que_DPVMateriel);
                IBOCancelCache(Que_CSHBPA);
                IBOCancelCache(que_Garde);
                IBOCancelCache(que_Vire);
                IBOCancelCache(que_FMKV);
                IBOCancelCache(que_IMPORT);

                vDeleteVireMRK := False;
            END;

            IBOCOmmitCache(que_Article);
            IBOCommitCache(que_Locarticle);
//                     IBOCommitCache(que_Etik);
//                     IBOCommitCache(que_EtikD);
            IBOCommitCache(Que_SAV);
            IBOCommitCache(Que_DPVMateriel);
            IBOCommitCache(Que_CSHBPA);
            IBOCommitCache(que_Garde);
            IBOCommitCache(que_Vire);
            IBOCommitCache(que_FmkV);
            IBOCommitCache(que_Import);

        END;

        Que_Article.close;
        Que_LocArticle.Close;
        Que_Etik.close;
        Que_EtikD.close;
        Que_Garde.close;

        // on supprime ici car sinon les valeurs mises à jours ne sont pas prises en compte.
        if vDeleteVireMRK then
        begin
            Que_Vire.Delete;
            try
                Dm_Main.StartTransaction;
                Dm_Main.IBOUpdateCache(Que_Vire);
                Dm_Main.Commit;
            except
                Dm_Main.Rollback;
                Dm_Main.IBOCancelCache(Que_Vire);
            end;
            Dm_Main.IBOCommitCache(Que_Vire);
        end;

        Que_Vire.close;
        Que_SAV.close;
        Que_DPVMateriel.Close;
        Que_CSHBPA.Close;
        Que_FMKV.close;
        Que_FMKG.close;
        Que_Import.Close;
    END;

    Bm_Delai.Wait;
    Dlg_Gauge.Stop;
    TsSel.Clear;
    Lst_Sel.Items.Clear;
    TRY
        DBG_Mrk.BeginUpdate;
        Que_Mrk.Close;
        Que_Mrk.Open;
    FINALLY
        dbg_Mrk.EndUpdate;
        que_Mrk.Locate('MRK_ID', Garde, []);
    END;
  END;
END;

PROCEDURE TFrm_Marques.GenerikUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_Marques.AlgolStdFrmClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    Grd_Close.Close;
END;

PROCEDURE TFrm_Marques.DBG_MrkKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
VAR
    id, i: Integer;
BEGIN
    IF Dbg_Mrk.FocusedNode = NIL THEN EXIT;
    CASE Key OF
        VK_F3:
            BEGIN
                id := Dbg_Mrk.GetvalueByFieldName(Dbg_Mrk.FocusedNode, 'MRK_ID');
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
                        Lst_sel.items.Add(dbg_Mrk.getvalueByFieldName(dbg_Mrk.FocusedNode, 'MRK_NOM') + ' --> ' + dbg_Mrk.getvalueByFieldName(dbg_Mrk.FocusedNode, 'FOUNOMS'));
                    END;
                END;
                Dbg_Mrk.Repaint;
            END;
    END;
END;

PROCEDURE TFrm_Marques.DBG_MrkCustomDrawCell(Sender: TObject;
    ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
    AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
    VAR AText: STRING; VAR AColor: TColor; AFont: TFont;
    VAR AAlignment: TAlignment; VAR ADone: Boolean);
VAR
    id, i: Integer;
BEGIN
    id := dbg_Mrk.GetvalueByFieldName(Anode, 'MRK_ID');
    i := TsSel.IndexOF(IntToStr(id));
    IF i <> -1 THEN AColor := clYellow;
    Pan_Mess.Visible := Tssel.Count = 2;
END;

procedure TFrm_Marques.GenerikAfterCancel(DataSet: TDataSet);
begin
  Dm_Main.IBOCancelCache ( DataSet As TIBOQuery) ;
end;

procedure TFrm_Marques.GenerikAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TFrm_Marques.GenerikBeforeDelete(DataSet: TDataSet);
begin
{ A achever ...
    IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
    BEGIN
        StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
        ABORT;
    END;
}
end;

procedure TFrm_Marques.GenerikNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TFrm_Marques.GenerikUpdateRecord2(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;


END.

