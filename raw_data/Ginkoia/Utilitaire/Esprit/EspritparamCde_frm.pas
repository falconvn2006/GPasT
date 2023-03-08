//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit EspritparamCde_frm;

interface

uses
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
    LMDFormShadow, RzRadGrp, RzDBRGrp, RzDBRadioGroupRv, wwdbedit,
    wwDBEditRv, Grids, Wwdbigrd, Wwdbgrid, wwDBGridRv, StdCtrls, Mask,
    DBCtrls, RzDBEdit, RzDBBnEd, RzDBButtonEditRv, RzLabel, ActionRv, Db,
    wwDialog, wwidlg, wwLookupDialogRv, IBODataset, RzEdit;

type
    TFrm_EspritParamCde = class(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
        RzLabel2: TRzLabel;
        Dbg_Esprit: TwwDBGridRv;
        RzLabel3: TRzLabel;
        RzLabel4: TRzLabel;
        RzLabel5: TRzLabel;
        RzLabel6: TRzLabel;
        RzLabel7: TRzLabel;
        RzLabel8: TRzLabel;
        RzLabel9: TRzLabel;
        Chp_Exo: TRzDBButtonEditRv;
        Chp_Mak: TRzDBButtonEditRv;
        Chp_Reg: TRzDBButtonEditRv;
        Chp_Four: TRzDBButtonEditRv;
        Chp_Liv: TwwDBEditRv;
        Chp_Ret: TwwDBEditRv;
        Chp_Saison: TRzDBRadioGroupRv;
        Que_Mag: TIBOQuery;
        LK_Mag: TwwLookupDialogRV;
        Que_Pexo: TIBOQuery;
        Que_Preg: TIBOQuery;
        Que_Pmarque: TIBOQuery;
        Que_Pfourn: TIBOQuery;
        Que_Pliv: TIBOQuery;
        Que_Pret: TIBOQuery;
        Que_PSais: TIBOQuery;
        Que_Exo: TIBOQuery;
        Que_Reg: TIBOQuery;
        Que_Marque: TIBOQuery;
        Que_Fourn: TIBOQuery;
        Ds_Exo: TDataSource;
        Ds_Preg: TDataSource;
        Ds_Marque: TDataSource;
        Ds_Fourn: TDataSource;
        LK_Exo: TwwLookupDialogRV;
        LK_Reg: TwwLookupDialogRV;
        LK_Marque: TwwLookupDialogRV;
        LK_Fourn: TwwLookupDialogRV;
        Grd: TGroupDataRv;
        Que_PexoPRM_ID: TIntegerField;
        Que_PexoEXE_NOM: TStringField;
        Que_PexoPRM_CODE: TIntegerField;
        Que_PexoPRM_TYPE: TIntegerField;
        Que_PexoPRM_INTEGER: TIntegerField;
        Ds_Sais: TDataSource;
        Ds_Liv: TDataSource;
        Ds_Ret: TDataSource;
        Que_PexoPRM_INFO: TStringField;
        Chp_Mag: TRzDBButtonEditRv;
        Ds_Mag: TDataSource;
        Que_Esprit: TIBOQuery;
        Que_MagMAG_ID: TIntegerField;
        Que_MagMAG_ENSEIGNE: TStringField;
        Ds_Esprit: TDataSource;
        close: TGroupDataRv;
        RzLabel1: TRzLabel;
        wwDBEditRv1: TwwDBEditRv;
        Que_Resu: TIBOQuery;
        Ds_Resu: TDataSource;
        procedure Nbt_PostClick(Sender: TObject);
        procedure Nbt_CancelClick(Sender: TObject);
        procedure AlgolMainFrmKeyDown(Sender: TObject; var Key: Word;
            Shift: TShiftState);
        procedure AlgolStdFrmCreate(Sender: TObject);
        procedure Pan_BtnEnter(Sender: TObject);
        procedure Pan_BtnExit(Sender: TObject);
        procedure GenerikAfterCancel(DataSet: TDataSet);
        procedure GenerikAfterPost(DataSet: TDataSet);
        procedure GenerikBeforeDelete(DataSet: TDataSet);
        procedure GenerikNewRecord(DataSet: TDataSet);
        procedure GenerikUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure AlgolStdFrmCloseQuery(Sender: TObject;
            var CanClose: Boolean);
        procedure LK_MagCloseDialog(Dialog: TwwLookupDlg);



        procedure GenerikNewRecord2(DataSet: TDataSet);
        procedure GenerikUpdateRecord2(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    private
        UserCanModify, UserVisuMags: Boolean;

        { Private declarations }
    protected
        { Protected declarations }
    public
        { Public declarations }
    published

    end;

function ExecuteEspritparamCde: Boolean;

implementation
{$R *.DFM}
uses
    StdUtils,
    GinkoiaStd,
    GinkoiaResStr, Main_Dm;

function ExecuteEspritparamCde: Boolean;
var Frm_EspritparamCde: TFrm_EspritparamCde;
begin
    Result := False;
    Application.createform(TFrm_EspritparamCde, Frm_EspritparamCde);
    with Frm_EspritparamCde do
    begin
        try
            if Showmodal = mrOk then
            begin
                Result := True;
            end;
        finally
            Free;
        end;
    end;
end;

procedure TFrm_EspritParamCde.AlgolStdFrmCreate(Sender: TObject);
var i: integer;
begin
    try
        screen.Cursor := crSQLWait;
        Hint := Caption;
        StdGinkoia.AffecteHintEtBmp(self);
        UserVisuMags := StdGinkoia.UserVisuMags;
        UserCanModify := StdGinkoia.UserCanModify('YES_PAR_DEFAUT');
        grd.open;
        if que_pexo.eof then
        begin
            que_pexo.insert;
            que_pexo.fieldbyname('prm_type').asinteger := 12;
            que_pexo.fieldbyname('prm_code').asinteger := 2;
            que_pexo.fieldbyname('prm_info').asstring := 'Esprit Integ CDE Exercice Comm';
            que_pexo.fieldbyname('prm_integer').asinteger := 0;
            que_pexo.post;
            Dm_Main.IBOUpDateCache(que_pexo);
        end;
        if que_preg.eof then
        begin
            que_preg.insert;
            que_preg.fieldbyname('prm_type').asinteger := 12;
            que_preg.fieldbyname('prm_code').asinteger := 3;
            que_preg.fieldbyname('prm_info').asstring := 'Esprit Integ CDE Reglement';
            que_preg.fieldbyname('prm_integer').asinteger := 0;
            que_preg.post;
            Dm_Main.IBOUpDateCache(que_preg);
        end;
        if que_pmarque.eof then
        begin
            que_pmarque.insert;
            que_pmarque.fieldbyname('prm_type').asinteger := 12;
            que_pmarque.fieldbyname('prm_code').asinteger := 5;
            que_pmarque.fieldbyname('prm_info').asstring := 'Esprit Integ CDE marque';
            que_pmarque.fieldbyname('prm_integer').asinteger := 0;
            que_pmarque.post;
            Dm_Main.IBOUpDateCache(que_pmarque);
        end;
        if que_pfourn.eof then
        begin
            que_pfourn.insert;
            que_pfourn.fieldbyname('prm_type').asinteger := 12;
            que_pfourn.fieldbyname('prm_code').asinteger := 4;
            que_pfourn.fieldbyname('prm_info').asstring := 'Esprit Integ CDE Fourn';
            que_pfourn.fieldbyname('prm_integer').asinteger := 0;
            que_pfourn.post;
            Dm_Main.IBOUpDateCache(que_pfourn);
        end;
        if que_pliv.eof then
        begin
            que_pliv.insert;
            que_pliv.fieldbyname('prm_type').asinteger := 12;
            que_pliv.fieldbyname('prm_code').asinteger := 6;
            que_pliv.fieldbyname('prm_info').asstring := 'Esprit Integ CDE Dt Liv';
            que_pliv.fieldbyname('prm_integer').asinteger := 0;
            que_pliv.post;
            Dm_Main.IBOUpDateCache(que_pliv);
        end;
        if que_pret.eof then
        begin
            que_pret.insert;
            que_pret.fieldbyname('prm_type').asinteger := 12;
            que_pret.fieldbyname('prm_code').asinteger := 7;
            que_pret.fieldbyname('prm_info').asstring := 'Esprit Integ CDE Retard';
            que_pret.fieldbyname('prm_integer').asinteger := 0;
            que_pret.post;
            Dm_Main.IBOUpDateCache(que_pret);
        end;
        if que_psais.eof then
        begin
            que_psais.insert;
            que_psais.fieldbyname('prm_type').asinteger := 12;
            que_psais.fieldbyname('prm_code').asinteger := 8;
            que_psais.fieldbyname('prm_info').asstring := 'Esprit Integ CDE Saison';
            que_psais.fieldbyname('prm_integer').asinteger := 0;
            que_psais.post;
            Dm_Main.IBOUpDateCache(que_psais);
        end;

        if que_resu.eof then
        begin
            que_resu.insert;
            que_resu.fieldbyname('prm_type').asinteger := 12;
            que_resu.fieldbyname('prm_code').asinteger := 9;
            que_resu.fieldbyname('prm_info').asstring := '@mail destinataire resultats mensuels';
            que_resu.fieldbyname('prm_integer').asinteger := 0;
            que_resu.post;
            Dm_Main.IBOUpDateCache(que_resu);
        end;

        que_mag.open;
        QUE_MAG.FIRST;
        while not que_mag.eof do
        begin
            que_esprit.close;
            que_esprit.parambyname('magid').asinteger := Que_MagMAG_ID.asinteger;
            que_esprit.open;
            if que_esprit.eof then
            begin
                for i := 1 to 10 do
                begin
                    que_esprit.insert;
                    que_esprit.fieldbyname('prm_type').asinteger := 12;
                    que_esprit.fieldbyname('prm_code').asinteger := 1;
                    que_esprit.fieldbyname('prm_info').asstring := 'Esprit Integ Code magasin';
                    que_esprit.fieldbyname('prm_integer').asinteger := 0;
                    que_esprit.fieldbyname('prm_magid').asinteger := Que_MagMAG_ID.asinteger;
                    que_esprit.fieldbyname('prm_string').asstring := '';
                    que_esprit.post;
                end;
                Dm_Main.IBOUpDateCache(que_ESPRIT);
            end;
            que_mag.next;
        end;



    finally
        screen.Cursor := crDefault;
    end;
end;

procedure TFrm_EspritParamCde.AlgolMainFrmKeyDown(Sender: TObject;
    var Key: Word; Shift: TShiftState);
begin
    case key of
        VK_ESCAPE: Nbt_CancelClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN: if Pan_Btn.Focused then Nbt_PostClick(Sender);
    end;
end;

procedure TFrm_EspritParamCde.Nbt_PostClick(Sender: TObject);
begin
    Dm_Main.IBOUpDateCache(que_pexo);
    Dm_Main.IBOUpDateCache(que_preg);
    Dm_Main.IBOUpDateCache(que_pmarque);
    Dm_Main.IBOUpDateCache(que_pfourn);
    Dm_Main.IBOUpDateCache(que_pret);
    Dm_Main.IBOUpDateCache(que_pliv);
    Dm_Main.IBOUpDateCache(que_psais);
    Dm_Main.IBOUpDateCache(que_esprit);
    Dm_Main.IBOUpDateCache(que_resu);



    ModalResult := mrOk;
end;

procedure TFrm_EspritParamCde.Nbt_CancelClick(Sender: TObject);
begin


    Dm_Main.IBOUpDateCache(que_pexo);
    Dm_Main.IBOCancelCache(que_preg);
    Dm_Main.IBOCancelCache(que_pmarque);
    Dm_Main.IBOCancelCache(que_pfourn);
    Dm_Main.IBOCancelCache(que_pret);
    Dm_Main.IBOUpDateCache(que_pliv);
    Dm_Main.IBOCancelCache(que_psais);
    Dm_Main.IBOUpDateCache(que_esprit);
    Dm_Main.IBOUpDateCache(que_resu);

    ModalResult := mrCancel;
end;

procedure TFrm_EspritParamCde.Pan_BtnEnter(Sender: TObject);
begin
    Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_EspritParamCde.Pan_BtnExit(Sender: TObject);
begin
    Nbt_Post.Font.style := [];
end;


procedure TFrm_EspritParamCde.GenerikAfterCancel(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_EspritParamCde.GenerikAfterPost(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_EspritParamCde.GenerikBeforeDelete(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_EspritParamCde.GenerikNewRecord(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_EspritParamCde.GenerikUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;


procedure TFrm_EspritParamCde.AlgolStdFrmCloseQuery(Sender: TObject;
    var CanClose: Boolean);
begin
    close.close;
end;

procedure TFrm_EspritParamCde.LK_MagCloseDialog(Dialog: TwwLookupDlg);
begin
    Dm_Main.IBOUpDateCache(que_esprit);
    que_esprit.close;
    que_esprit.parambyname('magid').asinteger := Que_MagMAG_ID.asinteger;
    que_esprit.open;
end;


procedure TFrm_EspritParamCde.GenerikNewRecord2(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_EspritParamCde.GenerikUpdateRecord2(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;


end.

