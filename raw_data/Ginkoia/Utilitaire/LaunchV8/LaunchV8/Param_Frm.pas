unit Param_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils,
  //Uses perso
  AlgolStdFrm, GinkoiaStyle_dm, AlgolDialogForms, LaunchMain_Dm, DB,
  ParamReplic_Frm, Confirmation_Frm,
  //----------
  ExtCtrls, RzPanel, GinPanel, StdCtrls, dxCntner, dxTL, dxDBCtrl,
  dxDBGrid, dxDBGridHP, ComCtrls, vgPageControlRv, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue, cxTextEdit,
  cxMaskEdit, cxSpinEdit, cxTimeEdit, AdvGlowButton, RzLabel, AdvOfficePager,
  AdvDateTimePicker, Mask, AdvSpin, DBCtrls, AdvDBDateTimePicker, DBAdvSp,
  AdvOfficeButtons, DBAdvOfficeButtons, AdvEdit, DBAdvEd,
  GinAdvDBDateTimePickers, RzRadGrp, RzDBRGrp, RzDBRadioGroupRv, AdvGroupBox,
  dxDBTLCl, dxGrClms;

type
  TFrm_Param = class(TAlgolDialogForm)
    Nbt_Modify: TAdvGlowButton;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Pan_Btn: TRzPanel;
    Nbt_Post: TAdvGlowButton;
    opParam: TAdvOfficePager;
    AopReplicLame: TAdvOfficePage;
    Gbx_ReplicTpsReel: TGroupBox;
    Lab_ReplicTpsReelURL: TLabel;
    Lab_ReplicTpsReelSender: TLabel;
    Lab_ReplicTpsReelDatabase: TLabel;
    Lab_ReplicTpsReelStart: TLabel;
    Lab_ReplicTpsReelEnd: TLabel;
    Lab_ReplicTpsReelNbTest: TLabel;
    Lab_ReplicTpsReelTime: TLabel;
    Lab_ReplicTpsReel: TLabel;
    se_ReplicTpsReelNbTest: TDBAdvSpinEdit;
    se_ReplicTpsReelTime: TDBAdvSpinEdit;
    ed_ReplicTpsReelUrl: TDBAdvEdit;
    ed_ReplicTpsReelSender: TDBAdvEdit;
    ed_ReplicTpsReelDatabase: TDBAdvEdit;
    dtp_ReplicTpsReelStart: TAdvDateTimePicker;
    dtp_ReplicTpsReelEnd: TAdvDateTimePicker;
    Gbx_ReplicClassique: TGroupBox;
    Chk_ReplicClassiqueFirst: TDBAdvOfficeCheckBox;
    Chk_ReplicClassiqueSecond: TDBAdvOfficeCheckBox;
    dtp_ReplicClassiqueFirst: TGinAdvDBDateTimePicker;
    dtp_ReplicClassiqueSecond: TGinAdvDBDateTimePicker;
    DBG_ReplicLame: TdxDBGridHP;
    DBG_ReplicLameREP_ID: TdxDBGridMaskColumn;
    DBG_ReplicLameREP_URLDISTANT: TdxDBGridColumn;
    DBG_ReplicLameREP_PLACEEAI: TdxDBGridColumn;
    DBG_ReplicLameREP_PLACEBASE: TdxDBGridColumn;
    btn_ReplicLamesUp: TAdvGlowButton;
    btn_ReplicLamesDown: TAdvGlowButton;
    btn_ReplicLamesAdd: TAdvGlowButton;
    btn_ReplicLamesModify: TAdvGlowButton;
    btn_ReplicLamesDel: TAdvGlowButton;
    Gbx_Options: TGroupBox;
    Chk_OptionForcerMaj: TDBAdvOfficeCheckBox;
    Chk_OtpionForcerBackup: TDBAdvOfficeCheckBox;
    Chk_ReplicClassiqueAuto: TDBAdvOfficeCheckBox;
    AopWeb: TAdvOfficePage;
    Lab_WebHStart: TLabel;
    Lab_WebHEnd: TLabel;
    Lab_WebIntervalle: TLabel;
    btn_WebUp: TAdvGlowButton;
    DBG_Web: TdxDBGridHP;
    DBG_WebREP_ID: TdxDBGridMaskColumn;
    DBG_WebREP_URLDISTANT: TdxDBGridColumn;
    DBG_WebREP_PLACEEAI: TdxDBGridColumn;
    DBG_WebREP_PLACEBASE: TdxDBGridColumn;
    DBG_WebREP_JOUR: TdxDBGridMaskColumn;
    btn_WebDown: TAdvGlowButton;
    btn_WebDel: TAdvGlowButton;
    btn_WebModify: TAdvGlowButton;
    btn_WebAdd: TAdvGlowButton;
    dtp_WebHStart: TAdvDateTimePicker;
    dtp_WebEnd: TAdvDateTimePicker;
    se_WebIntervalle: TDBAdvSpinEdit;
    rg_WebOrdre: TDBAdvOfficeRadioGroup;
    GinAdvDBDateTimePicker1: TGinAdvDBDateTimePicker;
    Chk_ReplicWeb: TAdvOfficeCheckBox;
    DBG_ReplicLameREP_JOUR: TdxDBGridCheckColumn;
    Lab_BaseCour: TRzLabel;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_ModifyClick(Sender: TObject);
    procedure AlgolDialogFormShow(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure btn_ReplicLamesAddClick(Sender: TObject);
    procedure btn_ReplicLamesModifyClick(Sender: TObject);
    procedure btn_ReplicLamesDelClick(Sender: TObject);
    procedure btn_ReplicLamesUpClick(Sender: TObject);
    procedure btn_ReplicLamesDownClick(Sender: TObject);
    procedure AlgolDialogFormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBG_ReplicLameDblClick(Sender: TObject);
    procedure AopReplicLameShow(Sender: TObject);
    procedure AopWebShow(Sender: TObject);
    procedure btn_WebAddClick(Sender: TObject);
    procedure btn_WebUpClick(Sender: TObject);
    procedure btn_WebDownClick(Sender: TObject);
    procedure btn_WebModifyClick(Sender: TObject);
    procedure Chk_ReplicWebClick(Sender: TObject);
    procedure btn_WebDelClick(Sender: TObject);
  private
    { Déclarations privées }
    iGlobBaseId : Integer;
    iGlobLauId : Integer;
    bGlobModifyWeb : Boolean;
    procedure RefreshReplication;

    procedure Initcomposant(aVisible : Boolean);
    procedure InitUpDown;
  public
    { Déclarations publiques }
  end;

var
  Frm_Param: TFrm_Param;

Function ExecuteParamFrm(aBaseId : Integer):Boolean;

implementation

Uses
  Param_Dm;

{$R *.dfm}

{ TParamSite }

Function ExecuteParamFrm(aBaseId: Integer):Boolean;
begin
  Result           := False;
  Frm_Param := TFrm_Param.Create(Nil);
  TRY
    Frm_Param.iGlobBaseId := aBaseId;

    Result := Frm_Param.ShowModal = mrClose;
  FINALLY
    Frm_Param.Release;
  END;
end;

procedure TFrm_Param.AlgolDialogFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Nbt_CancelClick(Sender);
end;

procedure TFrm_Param.AlgolDialogFormCreate(Sender: TObject);
begin
  Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
  Lab_BaseCour.Caption := 'Base : ' + LaunchMain_Dm.NomBase0;
  bGlobModifyWeb := False;
end;

procedure TFrm_Param.AlgolDialogFormShow(Sender: TObject);
begin
  opParam.ActivePage := AopReplicLame;
  RefreshReplication;
  Initcomposant(True);
end;

procedure TFrm_Param.AopReplicLameShow(Sender: TObject);
begin
  with Dm_Param do
  begin
    with IBQue_GenReplication do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select REP_ID, '+
                     'REP_LAUID, '+
                     'REP_PING, '+
                     'REP_PUSH, '+
                     'REP_PULL, '+
                     'REP_USER, '+
                     'REP_PWD, '+
                     'REP_ORDRE, '+
                     'REP_URLLOCAL, '+
                     'REP_URLDISTANT, '+
                     'REP_PLACEEAI, '+
                     'REP_PLACEBASE, '+
                     'REP_JOUR, REP_EXEFINREPLIC '+
              'From GENREPLICATION '+
                'Join K on (K_ID = REP_ID and K_ENABLED = 1) '+
              'Where  REP_ORDRE > 0 '+
              'And REP_LAUID = :LAUID '+
              'Order By REP_ORDRE');
    end;
    RefreshGenReplication(iGlobLauId);
  end;
  InitUpDown;
end;

procedure TFrm_Param.AopWebShow(Sender: TObject);
begin
  with Dm_Param do
  begin
    with IBQue_GenReplication do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select REP_ID, '+
                     'REP_LAUID, '+
                     'REP_PING, '+
                     'REP_PUSH, '+
                     'REP_PULL, '+
                     'REP_USER, '+
                     'REP_PWD, '+
                     'REP_ORDRE, '+
                     'REP_URLLOCAL, '+
                     'REP_URLDISTANT, '+
                     'REP_PLACEEAI, '+
                     'REP_PLACEBASE, '+
                     'REP_JOUR , REP_EXEFINREPLIC '+
              'From GENREPLICATION '+
                'Join K on (K_ID = REP_ID and K_ENABLED = 1) '+
              'Where  REP_ORDRE < 0 '+
              'And REP_LAUID = :LAUID '+
              'Order By REP_ORDRE desc');
    end;
    RefreshGenReplication(iGlobLauId);
  end;
  InitUpDown;
end;

procedure TFrm_Param.btn_ReplicLamesAddClick(Sender: TObject);
begin
  Dm_Param.IBQue_GenReplication.Last;
  ExecuteParamReplicFrm(0,iGlobBaseId,iGlobLauId,False,Dm_Param.IBQue_GenReplicationREP_ORDRE.AsInteger);
  RefreshReplication;
  Initcomposant(True);
end;

procedure TFrm_Param.btn_ReplicLamesDelClick(Sender: TObject);
begin
  if ConfirmerSortie('Vous allez supprimer la réplication sélectionnée.') then
  begin
    Dm_Param.DelGenReplication;
    RefreshReplication;
    Dm_Param.VerifOrdreReplic;
    RefreshReplication;
    Initcomposant(True);
  end;
end;

procedure TFrm_Param.btn_ReplicLamesDownClick(Sender: TObject);
var
  id : Integer;
begin
  id := Dm_Param.IBQue_GenReplicationREP_ID.AsInteger;
  Dm_Param.DownRepId(False);
  RefreshReplication;
  Dm_Param.LocateRepId(id);
end;

procedure TFrm_Param.btn_ReplicLamesModifyClick(Sender: TObject);
begin
  ExecuteParamReplicFrm(Dm_Param.IBQue_GenReplicationREP_ID.AsInteger,iGlobBaseId,iGlobLauId,True);
  RefreshReplication;
  Initcomposant(True);
end;

procedure TFrm_Param.btn_ReplicLamesUpClick(Sender: TObject);
var
  id : Integer;
begin
  id := Dm_Param.IBQue_GenReplicationREP_ID.AsInteger;
  Dm_Param.UpRepId(False);
  RefreshReplication;
  Dm_Param.LocateRepId(id);
end;

procedure TFrm_Param.btn_WebAddClick(Sender: TObject);
begin
  Dm_Param.IBQue_GenReplication.Last;
  ExecuteParamReplicFrm(0,iGlobBaseId,iGlobLauId,False,Dm_Param.IBQue_GenReplicationREP_ORDRE.AsInteger,True);
  RefreshReplication;
  Initcomposant(True);
end;

procedure TFrm_Param.btn_WebDelClick(Sender: TObject);
begin
  if ConfirmerSortie('Vous allez supprimer la réplication sélectionnée.') then
  begin
    Dm_Param.DelGenReplication;
    RefreshReplication;
    Dm_Param.VerifOrdreWeb;
    RefreshReplication;
    Initcomposant(True);
  end;
end;

procedure TFrm_Param.btn_WebDownClick(Sender: TObject);
var
  id : Integer;
begin
  id := Dm_Param.IBQue_GenReplicationREP_ID.AsInteger;
  Dm_Param.DownRepId(True);
  RefreshReplication;
  Dm_Param.LocateRepId(id);
end;

procedure TFrm_Param.btn_WebModifyClick(Sender: TObject);
begin
  ExecuteParamReplicFrm(Dm_Param.IBQue_GenReplicationREP_ID.AsInteger,iGlobBaseId,iGlobLauId,True);
  RefreshReplication;
  Initcomposant(True);
end;

procedure TFrm_Param.btn_WebUpClick(Sender: TObject);
var
  id : Integer;
begin
  id := Dm_Param.IBQue_GenReplicationREP_ID.AsInteger;
  Dm_Param.UpRepId(True);
  RefreshReplication;
  Dm_Param.LocateRepId(id);
end;

procedure TFrm_Param.Chk_ReplicWebClick(Sender: TObject);
begin
  if not Chk_ReplicWeb.ReadOnly then
  begin
    if Chk_ReplicWeb.Checked = True then
    begin
      Dm_Param.AddWeb(iGlobBaseId);
      dtp_WebHStart.Time    := Dm_Param.GetWebHStart;
      dtp_WebEnd.Time       := Dm_Param.GetWebHEnd;
      bGlobModifyWeb := True;
    end
    else
    begin
      Dm_Param.DelWeb;
      dtp_WebHStart.Time      := 0;
      dtp_WebEnd.Time         := 0;
      se_WebIntervalle.Value  := 0;
      rg_WebOrdre.Value       := '0';
      bGlobModifyWeb := False;
    end;
    Initcomposant(False);
  end;
end;

procedure TFrm_Param.DBG_ReplicLameDblClick(Sender: TObject);
begin
  btn_ReplicLamesModifyClick(Sender);
end;

procedure TFrm_Param.Initcomposant(aVisible: Boolean);
begin
  if aVisible then        //Cacher les boutons Valider Annuler + Afficher le bouton Modify
  begin
    Nbt_Cancel.Visible    := False;
    Lab_OuAnnuler.Visible := False;
    Nbt_Post.Visible      := False;
    Nbt_Modify.Visible    := True;
    //Débloque les btn pour la modification de la réplication
    btn_ReplicLamesAdd.Enabled    := True;
    btn_ReplicLamesModify.Enabled := True;
    btn_ReplicLamesDel.Enabled    := True;
    btn_ReplicLamesUp.Enabled     := True;
    btn_ReplicLamesDown.Enabled   := True;

    dtp_ReplicTpsReelStart.Enabled  := False;
    dtp_ReplicTpsReelEnd.Enabled    := False;

    ed_ReplicTpsReelUrl.ReadOnly      := True;
    ed_ReplicTpsReelSender.ReadOnly   := True;
    ed_ReplicTpsReelDatabase.ReadOnly := True;
    //------------------------------------------//

    //Débloque les btn pour la modification du Web
    btn_WebAdd.Enabled    := True;
    btn_WebModify.Enabled := True;
    btn_WebDel.Enabled    := True;
    btn_WebUp.Enabled     := True;
    btn_WebDown.Enabled   := True;

    Chk_ReplicWeb.ReadOnly := True;
    //------------------------------------------//
  end
  else
  begin
    Nbt_Post.Visible      := True;
    Lab_OuAnnuler.Visible := True;
    Nbt_Cancel.Visible    := True;
    Nbt_Modify.Visible    := False;
    //Bloque les btn pour la modification de la réplication
    btn_ReplicLamesAdd.Enabled    := False;
    btn_ReplicLamesModify.Enabled := False;
    btn_ReplicLamesDel.Enabled    := False;
    btn_ReplicLamesUp.Enabled     := False;
    btn_ReplicLamesDown.Enabled   := False;

    dtp_ReplicTpsReelStart.Enabled  := True;
    dtp_ReplicTpsReelEnd.Enabled    := True;

    ed_ReplicTpsReelUrl.ReadOnly      := False;
    ed_ReplicTpsReelSender.ReadOnly   := False;
    ed_ReplicTpsReelDatabase.ReadOnly := False;
    //------------------------------------------//

    //Débloque les btn pour la modification du Web
    btn_WebAdd.Enabled    := False;
    btn_WebModify.Enabled := False;
    btn_WebDel.Enabled    := False;
    btn_WebUp.Enabled     := False;
    btn_WebDown.Enabled   := False;

    Chk_ReplicWeb.ReadOnly := False;
    //------------------------------------------//
  end;

  InitUpDown;

  if bGlobModifyWeb then
  begin
    rg_WebOrdre.Enabled       := True;
    dtp_WebHStart.Enabled     := True;
    dtp_WebEnd.Enabled        := True;
    se_WebIntervalle.ReadOnly := False;
  end
  else
  begin
    rg_WebOrdre.Enabled       := False;
    dtp_WebHStart.Enabled     := False;
    dtp_WebEnd.Enabled        := False;
    se_WebIntervalle.ReadOnly := True;
  end;
end;

procedure TFrm_Param.InitUpDown;
begin
  if Dm_Param.IBQue_GenReplication.RecordCount > 1 then
  begin
    btn_ReplicLamesUp.Visible   := True;
    btn_ReplicLamesDown.Visible := True;
    btn_WebUp.Visible           := True;
    btn_WebDown.Visible         := True;
  end
  else
  begin
    btn_ReplicLamesUp.Visible   := False;
    btn_ReplicLamesDown.Visible := False;
    btn_WebUp.Visible           := False;
    btn_WebDown.Visible         := False;
  end;
end;

procedure TFrm_Param.RefreshReplication;
var
  id : Integer;
begin
  id := Dm_Param.IBQue_GenReplicationREP_ID.AsInteger;

  Dm_Param.RefreshGenLaunch(iGlobBaseId);
  iGlobLauId := Dm_Param.IBQue_GenLaunchLAU_ID.AsInteger;
  Dm_Param.RefreshGenParam(iGlobBaseId);
  Dm_Param.RefreshGenReplication(iGlobLauId);

  Chk_ReplicWeb.Checked     := Dm_Param.RefreshWeb(iGlobBaseId);

  dtp_ReplicTpsReelStart.Time := Dm_Param.GetReplicTpsReelStart;
  dtp_ReplicTpsReelEnd.Time   := Dm_Param.GetReplicTpsReelEnd;

  dtp_WebHStart.Time    := Dm_Param.GetWebHStart;
  dtp_WebEnd.Time       := Dm_Param.GetWebHEnd;

  Dm_Param.LocateRepId(id);
end;

procedure TFrm_Param.Nbt_CancelClick(Sender: TObject);
begin
  bGlobModifyWeb := False;
  Dm_LaunchMain.Tra_Ginkoia.Rollback;
  RefreshReplication;
  Initcomposant(True);
end;

procedure TFrm_Param.Nbt_ModifyClick(Sender: TObject);
begin
  try
    //Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    RefreshReplication;

    Dm_Param.StartModifyGenLaunch;
    Dm_Param.StartModifyGenParam;

    bGlobModifyWeb := Dm_Param.StartModifyWeb;

  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la modification des données. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
  Initcomposant(False);
end;

procedure TFrm_Param.Nbt_PostClick(Sender: TObject);
begin
  try
    Dm_Param.SetReplicTpsReelStart(dtp_ReplicTpsReelStart.Time);
    Dm_Param.SetReplicTpsReelEnd(dtp_ReplicTpsReelEnd.Time);

    Dm_Param.EndModifyGenLaunch;
    Dm_Param.EndModifyGenParam;

    if bGlobModifyWeb then
    begin
      Dm_Param.SetWebHStart(dtp_WebHStart.Time);
      Dm_Param.SetWebHEnd(dtp_WebEnd.Time);
      Dm_Param.EndModifyWeb;
    end;

    Dm_LaunchMain.Tra_Ginkoia.Commit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la validation des données. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
  RefreshReplication;
  Initcomposant(True);
end;


end.
