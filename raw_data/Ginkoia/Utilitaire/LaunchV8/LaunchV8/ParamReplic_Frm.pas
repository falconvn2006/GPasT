unit ParamReplic_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  // Uses perso
  AlgolStdFrm,
  GinkoiaStyle_dm,
  AlgolDialogForms,
  Param_Dm,
  CstLaunch,
  LaunchMain_Dm,
  ProvidersSubscribers_Frm,
  // ----------
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxContainer,
  cxEdit,
  dxSkinsCore,
  dxSkinBlack,
  dxSkinBlue,
  dxSkinCaramel,
  dxSkinCoffee,
  dxSkinDarkRoom,
  dxSkinDarkSide,
  dxSkinFoggy,
  dxSkinGlassOceans,
  dxSkiniMaginary,
  dxSkinLilian,
  dxSkinLiquidSky,
  dxSkinLondonLiquidSky,
  dxSkinMcSkin,
  dxSkinMoneyTwins,
  dxSkinOffice2007Black,
  dxSkinOffice2007Blue,
  dxSkinOffice2007Green,
  dxSkinOffice2007Pink,
  dxSkinOffice2007Silver,
  dxSkinOffice2010Black,
  dxSkinOffice2010Blue,
  dxSkinOffice2010Silver,
  dxSkinPumpkin,
  dxSkinSeven,
  dxSkinSharp,
  dxSkinSilver,
  dxSkinSpringTime,
  dxSkinStardust,
  dxSkinSummer2008,
  dxSkinsDefaultPainters,
  dxSkinValentine,
  dxSkinXmas2008Blue,
  dxCntner,
  dxTL,
  dxDBCtrl,
  dxDBGrid,
  dxDBGridHP,
  cxSpinEdit,
  cxTextEdit,
  cxMaskEdit,
  cxTimeEdit,
  AdvOfficePager,
  AdvGlowButton,
  RzLabel,
  RzPanel,
  ExtCtrls,
  GinPanel,
  AdvEdit,
  AdvEdBtn,
  AdvFileNameEdit,
  AdvDirectoryEdit,
  DBAdvEd,
  AdvOfficeButtons,
  DBAdvOfficeButtons;

type
  TFrm_ParamReplic = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    opParamReplic: TAdvOfficePager;
    AopParametres: TAdvOfficePage;
    Gbx_Chemins: TGroupBox;
    Lab_Eai: TLabel;
    Lab_Base: TLabel;
    fne_Base: TAdvFileNameEdit;
    de_EAI: TAdvDirectoryEdit;
    Gbx_Ordres: TGroupBox;
    Lab_Ping: TLabel;
    Lab_Push: TLabel;
    Lab_Pull: TLabel;
    Gbx_URL: TGroupBox;
    Lab_URLLocale: TLabel;
    Lab_URLDistante: TLabel;
    Lab_User: TLabel;
    Lab_Password: TLabel;
    Btn_TestUrlL: TButton;
    Btn_TestUrlD: TButton;
    AopProviders: TAdvOfficePage;
    Lab_ProvidersTraiter: TLabel;
    Lab_ProvidersDispo: TLabel;
    Lab_ProvidersLoop: TLabel;
    btn_ProvidersModify: TAdvGlowButton;
    btn_ProvidersAdd: TAdvGlowButton;
    btn_ProvidersDel: TAdvGlowButton;
    btn_ProvidersDown: TAdvGlowButton;
    btn_ProvidersUp: TAdvGlowButton;
    btn_ProvidersAllDisable: TAdvGlowButton;
    btn_ProvidersDisable: TAdvGlowButton;
    btn_ProvidersEnable: TAdvGlowButton;
    btn_ProvidersAllEnable: TAdvGlowButton;
    DBG_ProvidersD: TdxDBGridHP;
    DBG_ProvidersT: TdxDBGridHP;
    btn_ProvidersEnableLoop: TButton;
    btn_ProvidersDisableLoop: TButton;
    AopSubscription: TAdvOfficePage;
    Lab_SubscriptionTraiter: TLabel;
    Lab_SubscriptionLoop: TLabel;
    Lab_SubscriptionDispo: TLabel;
    DBG_SubscriptionT: TdxDBGridHP;
    btn_SubscriptionAllDisable: TAdvGlowButton;
    btn_SubscriptionDisable: TAdvGlowButton;
    btn_SubscriptionEnable: TAdvGlowButton;
    btn_SubscriptionAllEnable: TAdvGlowButton;
    btn_SubscriptionModify: TAdvGlowButton;
    btn_SubscriptionAdd: TAdvGlowButton;
    btn_SubscriptionDel: TAdvGlowButton;
    btn_SubscriptionDown: TAdvGlowButton;
    btn_SubscriptionUp: TAdvGlowButton;
    btn_SubscriptionDisableLoop: TButton;
    btn_SubscriptionEnableLoop: TButton;
    DBG_SubscriptionD: TdxDBGridHP;
    ed_UrlL: TDBAdvEdit;
    ed_UrlD: TDBAdvEdit;
    ed_User: TDBAdvEdit;
    ed_Pwd: TDBAdvEdit;
    ed_Ping: TDBAdvEdit;
    ed_Push: TDBAdvEdit;
    ed_Pull: TDBAdvEdit;
    DBG_ProvidersDPRO_ID: TdxDBGridMaskColumn;
    DBG_ProvidersDPRO_NOM: TdxDBGridColumn;
    DBG_ProvidersDPRO_ORDRE: TdxDBGridMaskColumn;
    DBG_ProvidersDPRO_LOOP: TdxDBGridMaskColumn;
    DBG_ProvidersTPRO_ID: TdxDBGridMaskColumn;
    DBG_ProvidersTPRO_NOM: TdxDBGridColumn;
    DBG_ProvidersTPRO_ORDRE: TdxDBGridMaskColumn;
    DBG_ProvidersTPRO_LOOP: TdxDBGridMaskColumn;
    DBG_SubscriptionDSUB_ID: TdxDBGridMaskColumn;
    DBG_SubscriptionDSUB_NOM: TdxDBGridColumn;
    DBG_SubscriptionDSUB_ORDRE: TdxDBGridMaskColumn;
    DBG_SubscriptionDSUB_LOOP: TdxDBGridMaskColumn;
    DBG_SubscriptionTSUB_ID: TdxDBGridMaskColumn;
    DBG_SubscriptionTSUB_NOM: TdxDBGridColumn;
    DBG_SubscriptionTSUB_ORDRE: TdxDBGridMaskColumn;
    DBG_SubscriptionTSUB_LOOP: TdxDBGridMaskColumn;
    Nbt_Modify: TAdvGlowButton;
    ed_ProvidersLoop: TAdvEdit;
    ed_SubscriptionLoop: TAdvEdit;
    Gbx_ReplicJour: TGroupBox;
    cb_ReplicJour: TDBAdvOfficeCheckBox;
    Gbx_EXEFinReplic: TGroupBox;
    Lab_ExecFinReplic: TLabel;
    fne_ExeFinReplic: TAdvFileNameEdit;
    btSubscriptionLoopAuto: TButton;
    btProviderLoopAuto: TButton;
    procedure Btn_TestUrlDClick(Sender: TObject);
    procedure Btn_TestUrlLClick(Sender: TObject);
    procedure Ed_EditExit(Sender: TObject);
    procedure AlgolDialogFormShow(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure btn_ProvidersUpClick(Sender: TObject);
    procedure btn_SubscriptionUpClick(Sender: TObject);
    procedure btn_SubscriptionDownClick(Sender: TObject);
    procedure btn_ProvidersDownClick(Sender: TObject);
    procedure Nbt_ModifyClick(Sender: TObject);
    procedure btn_ProvidersAllDisableClick(Sender: TObject);
    procedure btn_ProvidersAllEnableClick(Sender: TObject);
    procedure btn_ProvidersDisableClick(Sender: TObject);
    procedure btn_ProvidersEnableClick(Sender: TObject);
    procedure btn_SubscriptionAllDisableClick(Sender: TObject);
    procedure btn_SubscriptionDisableClick(Sender: TObject);
    procedure btn_SubscriptionEnableClick(Sender: TObject);
    procedure btn_SubscriptionAllEnableClick(Sender: TObject);
    procedure AlgolDialogFormClose(Sender: TObject; var Action: TCloseAction);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure btn_ProvidersAddClick(Sender: TObject);
    procedure btn_ProvidersModifyClick(Sender: TObject);
    procedure btn_SubscriptionAddClick(Sender: TObject);
    procedure btn_SubscriptionModifyClick(Sender: TObject);
    procedure btn_ProvidersEnableLoopClick(Sender: TObject);
    procedure btn_ProvidersDisableLoopClick(Sender: TObject);
    procedure DBG_ProvidersTChangeNode(Sender: TObject; OldNode, Node: TdxTreeListNode);
    procedure btn_SubscriptionEnableLoopClick(Sender: TObject);
    procedure DBG_SubscriptionTChangeNode(Sender: TObject; OldNode, Node: TdxTreeListNode);
    procedure AopProvidersShow(Sender: TObject);
    procedure AopSubscriptionShow(Sender: TObject);
    procedure AopParametresShow(Sender: TObject);
    procedure DBG_ProvidersDCustomDrawCell(Sender: TObject; ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: string; var AColor: TColor; AFont: TFont; var AAlignment: TAlignment; var ADone: Boolean);
    procedure DBG_SubscriptionDCustomDrawCell(Sender: TObject; ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: string; var AColor: TColor; AFont: TFont; var AAlignment: TAlignment; var ADone: Boolean);
    procedure btn_SubscriptionDelClick(Sender: TObject);
    procedure btn_ProvidersDelClick(Sender: TObject);
    procedure de_EAIChange(Sender: TObject);
    procedure DBG_ProvidersDPRO_LOOPGetText(Sender: TObject;
      ANode: TdxTreeListNode; var AText: string);
  private
    { Déclarations privées }
    iMaxOrdre: Integer;
    procedure RefreshReplic;
    procedure Initcomposant(aVisible: Boolean);
  public
    bGlobModify: Boolean;
    iGlobLauId : Integer;
    iGlobRepId : Integer;
    iGlobBaseId: Integer;
    bGlobWeb   : Boolean;

    { Déclarations publiques }
  end;

var
  Frm_ParamReplic: TFrm_ParamReplic;

Function ExecuteParamReplicFrm(aRepId, aBaseId, aLauId: Integer; aModify: Boolean; aMaxOrdre: Integer = 0; aWeb: Boolean = False): Boolean;

implementation

{$R *.dfm}

Function ExecuteParamReplicFrm(aRepId, aBaseId, aLauId: Integer; aModify: Boolean; aMaxOrdre: Integer; aWeb: Boolean): Boolean;
begin
  Result                        := False;
  Frm_ParamReplic               := TFrm_ParamReplic.Create(Nil);
  TRY
    Frm_ParamReplic.bGlobModify := aModify;
    Frm_ParamReplic.iGlobRepId  := aRepId;
    Frm_ParamReplic.iGlobBaseId := aBaseId;
    Frm_ParamReplic.iGlobLauId  := aLauId;
    Frm_ParamReplic.iMaxOrdre   := aMaxOrdre;
    Frm_ParamReplic.bGlobWeb    := aWeb;

    Result                      := Frm_ParamReplic.ShowModal = mrClose;
  FINALLY
    Frm_ParamReplic.Release;
  END;
end;

procedure TFrm_ParamReplic.Ed_EditExit(Sender: TObject);
var
  s: string;
begin
  s := Tedit(Sender).Text;
  if pos('\', s) > 0 then
  begin
    while pos('\', s) > 0 do
      s[pos('\', s)]   := '/';
    Tedit(Sender).Text := s;
  end;
  if (length(s) > 0) and (s[length(s)] <> '/') then
  begin
    s                  := s + '/';
    Tedit(Sender).Text := s;
  end;
end;

procedure TFrm_ParamReplic.Initcomposant(aVisible: Boolean);
begin
  if aVisible then // Cacher les boutons Valider Annuler + Afficher le bouton Modify
  begin
    Nbt_Cancel.Visible                  := False;
    Lab_OuAnnuler.Visible               := False;
    Nbt_Post.Visible                    := False;
    Nbt_Modify.Visible                  := True;
    // Débloque les btn pour la modification des Providers
    btn_ProvidersAdd.Enabled            := True;
    btn_ProvidersModify.Enabled         := True;
    btn_ProvidersDel.Enabled            := True;
    btn_ProvidersUp.Enabled             := True;
    btn_ProvidersDown.Enabled           := True;

    btn_ProvidersAllDisable.Enabled     := True;
    btn_ProvidersDisable.Enabled        := True;
    btn_ProvidersEnable.Enabled         := True;
    btn_ProvidersAllEnable.Enabled      := True;

    btn_ProvidersDisableLoop.Enabled    := True;
    btn_ProvidersEnableLoop.Enabled     := True;
    // Débloque les btn pour la modification des Subscription
    btn_SubscriptionAdd.Enabled         := True;
    btn_SubscriptionModify.Enabled      := True;
    btn_SubscriptionDel.Enabled         := True;
    btn_SubscriptionUp.Enabled          := True;
    btn_SubscriptionDown.Enabled        := True;

    btn_SubscriptionAllDisable.Enabled  := True;
    btn_SubscriptionDisable.Enabled     := True;
    btn_SubscriptionEnable.Enabled      := True;
    btn_SubscriptionAllEnable.Enabled   := True;

    btn_SubscriptionDisableLoop.Enabled := True;
    btn_SubscriptionEnableLoop.Enabled  := True;

    de_EAI.ReadOnly                     := True;
    fne_Base.ReadOnly                   := True;
    fne_ExeFinReplic.ReadOnly           := True;
  end
  else
  begin
    Nbt_Post.Visible                    := True;
    Lab_OuAnnuler.Visible               := True;
    Nbt_Cancel.Visible                  := True;
    Nbt_Modify.Visible                  := False;
    // Bloque les btn pour la modification des Providers
    btn_ProvidersAdd.Enabled            := False;
    btn_ProvidersModify.Enabled         := False;
    btn_ProvidersDel.Enabled            := False;
    btn_ProvidersUp.Enabled             := False;
    btn_ProvidersDown.Enabled           := False;

    btn_ProvidersAllDisable.Enabled     := False;
    btn_ProvidersDisable.Enabled        := False;
    btn_ProvidersEnable.Enabled         := False;
    btn_ProvidersAllEnable.Enabled      := False;

    btn_ProvidersDisableLoop.Enabled    := False;
    btn_ProvidersEnableLoop.Enabled     := False;
    // Bloque les btn pour la modification des Subscription
    btn_SubscriptionAdd.Enabled         := False;
    btn_SubscriptionModify.Enabled      := False;
    btn_SubscriptionDel.Enabled         := False;
    btn_SubscriptionUp.Enabled          := False;
    btn_SubscriptionDown.Enabled        := False;

    btn_SubscriptionAllDisable.Enabled  := False;
    btn_SubscriptionDisable.Enabled     := False;
    btn_SubscriptionEnable.Enabled      := False;
    btn_SubscriptionAllEnable.Enabled   := False;

    btn_SubscriptionDisableLoop.Enabled := False;
    btn_SubscriptionEnableLoop.Enabled  := False;

    de_EAI.ReadOnly                     := False;
    fne_Base.ReadOnly                   := False;
    fne_ExeFinReplic.ReadOnly           := False;
  end;
end;


procedure TFrm_ParamReplic.Nbt_CancelClick(Sender: TObject);
begin
  Dm_LaunchMain.Tra_Ginkoia.Rollback;
  RefreshReplic;
  Initcomposant(True);
  AopProviders.TabVisible    := True;
  AopSubscription.TabVisible := True;

  if not bGlobModify then
  begin
    bGlobModify := True;
    Self.Close;
  end;
end;

procedure TFrm_ParamReplic.Nbt_ModifyClick(Sender: TObject);
begin
  try
    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    RefreshReplic;

    Dm_Param.StartModifyGenReplication;
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la modification des données. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
  AopProviders.TabVisible    := False;
  AopSubscription.TabVisible := False;
  Initcomposant(False);
end;

procedure TFrm_ParamReplic.Nbt_PostClick(Sender: TObject);
begin
  try
    Dm_Param.SetRepIdPlaceEAI(de_EAI.Text);
    Dm_Param.SetRepIdPlaceBase(fne_Base.Text);
    Dm_Param.SetREPEXEFINREPLIC(fne_ExeFinReplic.Text);

    if not bGlobModify then
    begin
      Dm_Param.IBQue_GenReplicationREP_PING.AsString       := ed_Ping.Text;
      Dm_Param.IBQue_GenReplicationREP_PUSH.AsString       := ed_Push.Text;
      Dm_Param.IBQue_GenReplicationREP_PULL.AsString       := ed_Pull.Text;
      Dm_Param.IBQue_GenReplicationREP_USER.AsString       := ed_User.Text;
      Dm_Param.IBQue_GenReplicationREP_PWD.AsString        := ed_Pwd.Text;
      Dm_Param.IBQue_GenReplicationREP_URLLOCAL.AsString   := ed_UrlL.Text;
      Dm_Param.IBQue_GenReplicationREP_URLDISTANT.AsString := ed_UrlD.Text;
      Dm_Param.IBQue_GenReplicationREP_PLACEEAI.AsString   := de_EAI.Text;
      Dm_Param.IBQue_GenReplicationREP_PLACEBASE.AsString  := fne_Base.Text;
      Dm_Param.IBQue_GenReplicationREP_EXEFINREPLIC.AsString := fne_ExeFinReplic.Text;

      Dm_Param.PostGenRepication(iMaxOrdre, bGlobWeb);
      Dm_Param.IBQue_GenReplication.Close;

      if not bGlobWeb then
        Dm_Param.EnableProviders(True, True, iGlobRepId, 0, 0);

      Dm_Param.EnableSubscribers(True, True, iGlobRepId, 0, 0);
      bGlobModify := True; // Une fois créer nous passons en modification
    end
    else
    begin
      Dm_Param.EndModifyGenReplication;
    end;

    Dm_LaunchMain.Tra_Ginkoia.Commit;
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la validation des données. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
  RefreshReplic;

  AopProviders.TabVisible    := True;
  AopSubscription.TabVisible := True;

  Initcomposant(True);
end;

procedure TFrm_ParamReplic.RefreshReplic;
begin
  Dm_Param.RefreshGenReplication(iGlobLauId); // On ne refresh que la réplication
  Dm_Param.LocateRepId(iGlobRepId);           // On se replace sur la réplication courrante
  de_EAI.Text   := Dm_Param.GetRepIdPlaceEAI;
  fne_Base.Text := Dm_Param.GetRepIdPlaceBase;
  fne_ExeFinReplic.Text := Dm_Param.GetREPEXEFINREPLIC;
end;

procedure TFrm_ParamReplic.AlgolDialogFormClose(Sender: TObject; var Action: TCloseAction);
begin
  Nbt_CancelClick(Sender);
end;

procedure TFrm_ParamReplic.AlgolDialogFormCreate(Sender: TObject);
begin
  Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
end;

procedure TFrm_ParamReplic.AlgolDialogFormShow(Sender: TObject);
begin
  opParamReplic.ActivePage := AopParametres;
  Initcomposant(True);
  if bGlobModify then
  begin
    Initcomposant(True);
  end
  else
  begin
    // RefreshForm;
    iGlobRepId                 := Dm_Param.AddGenReplication(iGlobLauId);
    AopProviders.TabVisible    := False;
    AopSubscription.TabVisible := False;
    Initcomposant(False);
  end;
end;

procedure TFrm_ParamReplic.AopParametresShow(Sender: TObject);
begin
  if bGlobModify then
    Nbt_Modify.Visible := True;

  Dm_Param.RefreshGenReplication(iGlobLauId); // On ne refresh que la réplication
  Dm_Param.LocateRepId(iGlobRepId);           // On se replace sur la réplication courrante
  de_EAI.Text   := Dm_Param.GetRepIdPlaceEAI;
  fne_Base.Text := Dm_Param.GetRepIdPlaceBase;
  fne_ExeFinReplic.Text := Dm_Param.GetREPEXEFINREPLIC;
end;

procedure TFrm_ParamReplic.AopProvidersShow(Sender: TObject);
begin
  Nbt_Post.Visible      := False;
  Lab_OuAnnuler.Visible := False;
  Nbt_Cancel.Visible    := False;
  Nbt_Modify.Visible    := False;
  Dm_Param.RefreshProviders(iGlobRepId); // On ne refresh que les Providers
  ed_ProvidersLoop.Text := Dm_Param.IBQue_ProviderTPRO_LOOP.AsString;
end;

procedure TFrm_ParamReplic.AopSubscriptionShow(Sender: TObject);
begin
  Nbt_Post.Visible         := False;
  Lab_OuAnnuler.Visible    := False;
  Nbt_Cancel.Visible       := False;
  Nbt_Modify.Visible       := False;
  Dm_Param.RefreshSubscribers(iGlobRepId); // On ne refresh que les Subscribers
  ed_SubscriptionLoop.Text := Dm_Param.IBQue_SubscriptionTSUB_LOOP.AsString;
end;

procedure TFrm_ParamReplic.btn_ProvidersAddClick(Sender: TObject);
begin
  ExecuteProviderSubscribersFrm(True, True, iGlobRepId);
end;

procedure TFrm_ParamReplic.btn_ProvidersAllDisableClick(Sender: TObject);
begin
  try
    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.EnableProviders(False, True, iGlobRepId, 0, 0);

    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshProviders(iGlobRepId); // On ne refresh que le Providers
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la désactivation de tous les Provider. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_ProvidersAllEnableClick(Sender: TObject);
begin
  try
    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.EnableProviders(True, True, iGlobRepId, 0, 0);

    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshProviders(iGlobRepId); // On ne refresh que le Providers
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de l''activation de tous les Provider. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_ProvidersDelClick(Sender: TObject);
begin
  if not Dm_Param.DelProviders(Dm_Param.IBQue_ProviderDPRO_ID.AsInteger) then
  begin
    ShowMessage('Impossible de supprimer ce Provider car il est encore utilisé dans une réplication.');
  end
  else
  begin
    Dm_Param.RefreshProviders(iGlobRepId);
  end;
end;

procedure TFrm_ParamReplic.btn_ProvidersDisableClick(Sender: TObject);
var
  id: Integer;
begin
  try
    id := Dm_Param.IBQue_ProviderTGLR_ID.AsInteger;

    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.EnableProviders(False, False, iGlobRepId, 0, id);

    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshProviders(iGlobRepId); // On ne refresh que le Providers
    Dm_Param.LocateDProId(id);             // On se place sur le Provider désactivé
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la désactivation d''un Provider. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_ProvidersDisableLoopClick(Sender: TObject);
var
  idT, idD: Integer;
  sNom    : string;
begin
  try
    idT  := Dm_Param.IBQue_ProviderTPRO_ID.AsInteger;
    idD  := Dm_Param.IBQue_ProviderDPRO_ID.AsInteger;
    sNom := Dm_Param.IBQue_ProviderTPRO_NOM.AsString;

    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.ModifyProviders(idT, sNom, 0);
    Dm_LaunchMain.MainModifK(idT);
    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshProviders(iGlobRepId); // On ne refresh que le Providers
    Dm_Param.LocateDProId(idD);
    Dm_Param.LocateTProId(idT);
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la modification du Loop d''un Provider. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_ProvidersDownClick(Sender: TObject);
begin
  Dm_Param.DownProId(iGlobRepId);
end;

procedure TFrm_ParamReplic.btn_ProvidersEnableClick(Sender: TObject);
var
  id: Integer;
begin
  try
    id := Dm_Param.IBQue_ProviderDPRO_ID.AsInteger;
    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.EnableProviders(True, False, iGlobRepId, id, 0);

    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshProviders(iGlobRepId); // On ne refresh que le Providers
    Dm_Param.LocateDProId(id);             // On se place sur le Providers activé
    Dm_Param.LocateTProId(id);
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de l''activation d''un Provider. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_ProvidersEnableLoopClick(Sender: TObject);
var
  idT, idD: Integer;
  sNom    : string;
  vMode   : Integer ;
begin
  vMode := 0 ;
  if Sender is TButton
    then vMode := (Sender as TButton).tag ;


  try
    idT  := Dm_Param.IBQue_ProviderTPRO_ID.AsInteger;
    idD  := Dm_Param.IBQue_ProviderDPRO_ID.AsInteger;
    sNom := Dm_Param.IBQue_ProviderTPRO_NOM.AsString;

    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    case vMode of
      0 : Dm_Param.ModifyProviders(idT, sNom, 0);
      1 : begin
            if ed_ProvidersLoop.Text = '0'
              then ed_ProvidersLoop.Text := '1500' ;
            Dm_Param.ModifyProviders(idT, sNom, StrToInt(ed_ProvidersLoop.Text));
          end;
      2 : Begin
            if ed_ProvidersLoop.Text = '0'
              then ed_ProvidersLoop.Text := '1500' ;
            Dm_Param.ModifyProviders(idT, sNom, 0-StrToInt(ed_ProvidersLoop.Text));
          End;
    end;

    Dm_LaunchMain.MainModifK(idT);
    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshProviders(iGlobRepId); // On ne refresh que le Providers
    Dm_Param.LocateDProId(idD);
    Dm_Param.LocateTProId(idT);
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la modification du Loop d''un Provider. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_ProvidersModifyClick(Sender: TObject);
begin
  ExecuteProviderSubscribersFrm(False, True, iGlobRepId, Dm_Param.IBQue_ProviderDPRO_ID.AsInteger, Dm_Param.IBQue_ProviderDPRO_NOM.AsString,
    Dm_Param.IBQue_ProviderDPRO_LOOP.AsInteger);
end;

procedure TFrm_ParamReplic.btn_ProvidersUpClick(Sender: TObject);
begin
  Dm_Param.UpProId(iGlobRepId);
end;

procedure TFrm_ParamReplic.btn_SubscriptionAddClick(Sender: TObject);
begin
  ExecuteProviderSubscribersFrm(True, False, iGlobRepId);
end;

procedure TFrm_ParamReplic.btn_SubscriptionAllDisableClick(Sender: TObject);
begin
  try
    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.EnableSubscribers(False, True, iGlobRepId, 0, 0);

    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshSubscribers(iGlobRepId); // On ne refresh que le Subscribers
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la désactivation de tous les Subscribers. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_SubscriptionAllEnableClick(Sender: TObject);
begin
  try
    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.EnableSubscribers(True, True, iGlobRepId, 0, 0);

    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshSubscribers(iGlobRepId); // On ne refresh que le Subscribers
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de l''activation de tous les Subscribers. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_SubscriptionDelClick(Sender: TObject);
begin
  if not Dm_Param.DelSubscribers(Dm_Param.IBQue_SubscriptionDSUB_ID.AsInteger) then
  begin
    ShowMessage('Impossible de supprimer ce Subscription car il est encore utilisé dans une réplication.');
  end
  else
  begin
    Dm_Param.RefreshSubscribers(iGlobRepId);
  end;
end;

procedure TFrm_ParamReplic.btn_SubscriptionDisableClick(Sender: TObject);
var
  id: Integer;
begin
  try
    id := Dm_Param.IBQue_SubscriptionTGLR_ID.AsInteger;
    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.EnableSubscribers(False, False, iGlobRepId, 0, id);

    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshSubscribers(iGlobRepId); // On ne refresh que le Subscribers
    Dm_Param.LocateDSubId(id);
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la désactivation d''un Subscribers. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_SubscriptionDownClick(Sender: TObject);
begin
  Dm_Param.DownSubId(iGlobRepId);
end;

procedure TFrm_ParamReplic.btn_SubscriptionEnableClick(Sender: TObject);
var
  id: Integer;
begin
  try
    id := Dm_Param.IBQue_SubscriptionDSUB_ID.AsInteger;
    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    Dm_Param.EnableSubscribers(True, False, iGlobRepId, id, 0);

    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshSubscribers(iGlobRepId); // On ne refresh que le Subscribers
    Dm_Param.LocateDSubId(id);               // On se place sur le Subscribers activé
    Dm_Param.LocateTSubId(id);
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de l''activation d''un Subscribers. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_SubscriptionEnableLoopClick(Sender: TObject);
var
  idT, idD: Integer;
  sNom    : string;
  vMode   : Integer ;
begin
  vMode := 0 ;
  if Sender is TButton
    then vMode := (Sender as TButton).Tag ;

  try
    idT  := Dm_Param.IBQue_SubscriptionTSUB_ID.AsInteger;
    idD  := Dm_Param.IBQue_SubscriptionDSUB_ID.AsInteger;
    sNom := Dm_Param.IBQue_SubscriptionTSUB_NOM.AsString;

    // Démarre une transaction
    if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    case vMode of
      0 : Dm_Param.ModifySubscribers(idT, sNom, 0);
      1 : begin
            if ed_SubscriptionLoop.Text = '0'
              then ed_SubscriptionLoop.Text := '1500' ;
            Dm_Param.ModifySubscribers(idT, sNom, StrToInt(ed_SubscriptionLoop.Text));
          end;
      2 : begin
            if ed_SubscriptionLoop.Text = '0'
              then ed_SubscriptionLoop.Text := '1500' ;
            Dm_Param.ModifySubscribers(idT, sNom, 0 - StrToInt(ed_SubscriptionLoop.Text));
          end;
    end;

    Dm_LaunchMain.MainModifK(idT);
    Dm_LaunchMain.Tra_Ginkoia.Commit;

    Dm_Param.RefreshSubscribers(iGlobRepId); // On ne refresh que le Subscribers
    Dm_Param.LocateDSubId(idD);
    Dm_Param.LocateTSubId(idT);
  except
    on e: Exception do
    begin
      ShowMessage('Erreur lors de la modification du Loop d''un Subscription. (' + e.Message + ')');
      Dm_LaunchMain.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TFrm_ParamReplic.btn_SubscriptionModifyClick(Sender: TObject);
begin
  ExecuteProviderSubscribersFrm(False, False, iGlobRepId, Dm_Param.IBQue_SubscriptionDSUB_ID.AsInteger, Dm_Param.IBQue_SubscriptionDSUB_NOM.AsString,
    Dm_Param.IBQue_SubscriptionDSUB_LOOP.AsInteger);
end;

procedure TFrm_ParamReplic.btn_SubscriptionUpClick(Sender: TObject);
begin
  Dm_Param.UpSubId(iGlobRepId);
end;

procedure TFrm_ParamReplic.Btn_TestUrlDClick(Sender: TObject);
begin
  if UnPing(ed_UrlD.Text + ed_Ping.Text) then
    Application.MessageBox('Ping réussi', 'Ping', Mb_Ok)
  else
    Application.MessageBox('Ping raté', 'Ping', Mb_Ok);
end;

procedure TFrm_ParamReplic.Btn_TestUrlLClick(Sender: TObject);
var
  TestExec: integer;
begin
  try
    TestExec := Winexec(PAnsiChar(AnsiString(de_EAI.Text + 'Delos_QpmAgent.exe')), 0);
    IF TestExec > 31 THEN
    BEGIN
      // Tempo pour laisser a delos le temps de se lancer
      LeDelay(1000);

      // 2° : tester si le ping local fonctionne
      IF UnPing(Ed_UrlL.Text + Ed_Ping.text) THEN
      BEGIN
        Application.MessageBox('Ping local réussi', 'Ping', Mb_Ok)
      END
      else begin
        Application.MessageBox('Ping local raté', 'Ping', Mb_Ok);
      end;
    END
    else IF TestExec = ERROR_BAD_FORMAT then
    begin
      Application.MessageBox('Fichier DelosQPMAgent.exe endommagé', 'Attention', Mb_Ok);
    end
    else IF TestExec = ERROR_FILE_NOT_FOUND then
    begin
      Application.MessageBox('Fichier DelosQPMAgent.exe introuvable', 'Attention', Mb_Ok);
    end
    else IF TestExec = ERROR_PATH_NOT_FOUND then
    begin
      Application.MessageBox('Chemin DelosQPMAgent.exe inconnu', 'Attention', Mb_Ok);
    end
    else begin
      Application.MessageBox('Erreur DelosQPMAgent', 'Attention', Mb_Ok);
    end;
  except
     Application.MessageBox('Echec de lancement de QPMAgent', 'Attention', Mb_Ok);
  end;
  ArretDelos;
end;

procedure TFrm_ParamReplic.DBG_ProvidersDCustomDrawCell(Sender: TObject; ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
  ASelected, AFocused, ANewItemRow: Boolean; var AText: string; var AColor: TColor; AFont: TFont; var AAlignment: TAlignment; var ADone: Boolean);
begin
  if Dm_Param.FindTProId(Dm_Param.IBQue_ProviderDPRO_ID.AsInteger, iGlobRepId) then
    AColor := clLtGray
  else
    AColor := clWhite;
end;

procedure TFrm_ParamReplic.DBG_ProvidersDPRO_LOOPGetText(Sender: TObject;
  ANode: TdxTreeListNode; var AText: string);
var
  aLoop : Integer ;
begin
  aLoop := ANode.Values[3] ;

  if ALoop = 0
    then AText := 'Désactivé' ;
  if ALoop = 1
    then AText := 'Actif' ;
  if ALoop > 1
    then AText := 'Manuel [' + IntToStr(aLoop) + ']' ;
  if ALoop = -1
    then AText := 'Auto' ;
  if ALoop < -1
    then AText := 'Auto [' + IntToStr(0-aLoop) + ']' ;
end;

procedure TFrm_ParamReplic.DBG_ProvidersTChangeNode(Sender: TObject; OldNode, Node: TdxTreeListNode);
begin
  ed_ProvidersLoop.Text := IntToStr(Abs(Dm_Param.IBQue_ProviderTPRO_LOOP.AsInteger)) ;
end;

procedure TFrm_ParamReplic.DBG_SubscriptionDCustomDrawCell(Sender: TObject; ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
  ASelected, AFocused, ANewItemRow: Boolean; var AText: string; var AColor: TColor; AFont: TFont; var AAlignment: TAlignment; var ADone: Boolean);
begin
  if Dm_Param.FindTSubId(Dm_Param.IBQue_SubscriptionDSUB_ID.AsInteger, iGlobRepId) then
    AColor := clLtGray
  else
    AColor := clWhite;
end;

procedure TFrm_ParamReplic.DBG_SubscriptionTChangeNode(Sender: TObject; OldNode, Node: TdxTreeListNode);
begin
  ed_SubscriptionLoop.Text := IntToStr(Abs(Dm_Param.IBQue_SubscriptionTSUB_LOOP.AsInteger));
end;

procedure TFrm_ParamReplic.de_EAIChange(Sender: TObject);
var
  sPathEAI        : string;      // Chemin de l'EAI
  sPathDatabaseXML: string;      // Chemin vers le fichier Database.xml
  tsFicXML        : TStringList; // Chargement du fichier XML
  i               : Integer;     // Variable de parcours
  sDatabaseXML    : string;      // Recherche dans le fichier XML
begin
  //
  sPathEAI         := IncludeTrailingPathDelimiter(de_EAI.Text);
  sPathDatabaseXML := sPathEAI + 'DelosQPMAgent.DataSources.xml';
  IF (FileExists(sPathEAI + 'Delos_QpmAgent.exe')) and (FileExists(sPathDatabaseXML)) THEN
  BEGIN
    tsFicXML := TStringList.Create;
    TRY
      tsFicXML.LoadFromFile(sPathDatabaseXML);
      sDatabaseXML := Uppercase(trim(tsFicXML.Text));
      i            := pos('<NAME>SERVER NAME</NAME>', sDatabaseXML);
      IF i > 0 THEN
      BEGIN
        i            := i + length('<NAME>SERVER NAME</NAME>') - 1;
        delete(sDatabaseXML, 1, i);
        sDatabaseXML := trim(sDatabaseXML);
        i            := pos('<VALUE>', sDatabaseXML);
        IF i > 0 THEN
        BEGIN
          i := i + length('<VALUE>') - 1;
          delete(sDatabaseXML, 1, i);
          i := pos('<', sDatabaseXML) - 1;
          IF i > 0 THEN
          BEGIN
            sDatabaseXML := Copy(sDatabaseXML, 1, i);
            IF pos('LOCALHOST:', Uppercase(sDatabaseXML)) = 1 THEN
            begin
              delete(sDatabaseXML, 1, length('LOCALHOST:'));
            end;

            fne_Base.Text := sDatabaseXML;
            de_EAI.Text   := sPathEAI;
          END;
        END;
      END;
    EXCEPT
    END;
    tsFicXML.free;
  END;
end;

end.
