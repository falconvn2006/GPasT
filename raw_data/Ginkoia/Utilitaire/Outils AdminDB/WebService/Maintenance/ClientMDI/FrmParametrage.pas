unit FrmParametrage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  Dialogs, FrmCustomGinkoiaBox, cxPropertiesStore, StdCtrls, Buttons, ExtCtrls,
  Grids, ValEdit, IdHTTP, FrmListLame;

type
  TParametrageFrm = class(TCustomGinkoiaBoxFrm)
    pnlParam: TPanel;
    SpdBtnSaveParam: TSpeedButton;
    SpdBtnTestingConnexion: TSpeedButton;
    Pan_1: TPanel;
    grpbxSyncSvr: TGroupBox;
    lblAnswerServeurSyncSrv: TLabel;
    SpdBtnSyncSvr: TSpeedButton;
    Memo: TMemo;
    lblTestConnexion: TLabel;
    pnlListLame: TPanel;
    GrpBxSyncDossier: TGroupBox;
    lblAnswerServeurSyncDos: TLabel;
    SpdBtnSyncDos: TSpeedButton;
    GrpBxRecyclerDataWS: TGroupBox;
    lblAnswerRecyclerDataWS: TLabel;
    SpdBtnRecyclerDataWS: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpdBtnSaveParamClick(Sender: TObject);
    procedure SpdBtnTestingConnexionClick(Sender: TObject);
    procedure SpdBtnSyncSvrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpdBtnSyncDosClick(Sender: TObject);
    procedure SpdBtnRecyclerDataWSClick(Sender: TObject);
  private
    FListLameFrm: TListLameFrm;
    procedure pOnDblClick(Sender: TObject);
    procedure pDoOnDataChange(Sender: TObject; Field: TField);
    procedure p_OnTerminate(Sender: TObject);
    procedure OptSyncSvrLoad;
    procedure OptSyncDosLoad;
    procedure LoadParams;
  public
  end;

var
  ParametrageFrm: TParametrageFrm;

implementation

uses dmdClients, FrmMain, uConst, ThrdSynchronizeSvr;

{$R *.dfm}

{ TParametrageFrm }

procedure TParametrageFrm.FormCreate(Sender: TObject);
begin
  cxPropertiesStore.Active:= True;
  inherited;
  FListLameFrm:= TListLameFrm.Create(Self);
  FListLameFrm.OnDblClick:= pOnDblClick;
  FListLameFrm.OnDataChange:= pDoOnDataChange;
  FListLameFrm.FramMode:= True;
  FListLameFrm.Parent:= pnlListLame;
  FListLameFrm.Align:= alClient;
  FListLameFrm.Visible:= True;
end;

procedure TParametrageFrm.FormShow(Sender: TObject);
begin
  inherited;
  LoadParams;
  OptSyncSvrLoad;
  OptSyncDosLoad;
end;

procedure TParametrageFrm.LoadParams;
begin
  Memo.Lines.Assign(GParams.ListParam);
  FListLameFrm.LoadListLame;
end;

procedure TParametrageFrm.OptSyncDosLoad;
var
  vIdHTTP: TIdHTTP;
begin
  vIdHTTP:= dmClients.GetNewIdHTTP(nil);
  try
    lblAnswerServeurSyncDos.Caption:= vIdHTTP.Get(GParams.Url + 'SynchronizeStarted?TYPESYNC=SYNCDOS');
    SpdBtnSyncDos.Enabled:= lblAnswerServeurSyncDos.Caption = '';
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

procedure TParametrageFrm.OptSyncSvrLoad;
var
  vIdHTTP: TIdHTTP;
begin
  vIdHTTP:= dmClients.GetNewIdHTTP(nil);
  try
    lblAnswerServeurSyncSrv.Caption:= vIdHTTP.Get(GParams.Url + 'SynchronizeStarted?TYPESYNC=SYNCSRV');
    SpdBtnSyncSvr.Enabled:= lblAnswerServeurSyncSrv.Caption = '';
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

procedure TParametrageFrm.pDoOnDataChange(Sender: TObject; Field: TField);
begin
  lblTestConnexion.Caption:= '';
end;

procedure TParametrageFrm.pOnDblClick(Sender: TObject);
begin
  GParams.Url:= FListLameFrm.CDSListLameURL.AsString;
  GParams.AliasName:= FListLameFrm.CDSListLameNAME.AsString;
  MainFrm.ActTestingConnexion.Execute;
  BtBtnClose.Click;
end;

procedure TParametrageFrm.p_OnTerminate(Sender: TObject);
var
  Buffer: String;
begin
  Buffer:= '';

  if TThrdSynchronizeSvr(Sender).TYPE_SYNC = 'SYNCDOS' then
    begin
      Buffer:= GrpBxSyncDossier.Caption;
      OptSyncDosLoad;
    end
  else
    if TThrdSynchronizeSvr(Sender).TYPE_SYNC = 'SYNCSRV' then
      begin
        Buffer:= grpbxSyncSvr.Caption;
        OptSyncSvrLoad;
      end;

  MainFrm.ShowPopupMsg(Caption, Buffer + cRC + cRC + 'Traitement terminé.', mtInformation, 8000);
end;

procedure TParametrageFrm.SpdBtnRecyclerDataWSClick(Sender: TObject);
var
  vIdHTTP: TIdHTTP;
begin
  inherited;
  if MessageDlg('Recycler les données du web service.' + cRC +
                'Voulez-vous continuer ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Screen.Cursor:= crHourGlass;
      try
        vIdHTTP:= dmClients.GetNewIdHTTP(nil);
        vIdHTTP.Get(GParams.Url + 'Synchronize?TYPESYNC=RECYCLEDATAWS');
      finally
        FreeAndNil(vIdHTTP);
        Screen.Cursor:= crDefault;
      end;
    end;
end;

procedure TParametrageFrm.SpdBtnSaveParamClick(Sender: TObject);
begin
  inherited;
  GParams.ListParam.Assign(Memo.Lines);
  GParams.Save;
  LoadParams;
end;

procedure TParametrageFrm.SpdBtnSyncDosClick(Sender: TObject);
var
  vThrdSyncSvr: TThrdSynchronizeSvr;
begin
  inherited;
  if MessageDlg('Cette action va synchroniser tous les dossiers avec la base maintenance.' + cRC +
                'Vérifiez qu''il n''y a pas de traitement lourd déjà en cours.'  + cRC + cRC +
                'Voulez-vous continuer ?', mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      Screen.Cursor:= crHourGlass;
      try
        vThrdSyncSvr:= TThrdSynchronizeSvr.create(True);
        vThrdSyncSvr.TYPE_SYNC:= 'SYNCDOS';
        vThrdSyncSvr.FreeOnTerminate:= True;
        vThrdSyncSvr.priority:= tpNormal;
        vThrdSyncSvr.OnTerminate:= p_OnTerminate;
        vThrdSyncSvr.Resume;
        Sleep(3000);
        OptSyncDosLoad;
      finally
        Screen.Cursor:= crDefault;
      end;
    end;
end;

procedure TParametrageFrm.SpdBtnSyncSvrClick(Sender: TObject);
var
  vThrdSyncSvr: TThrdSynchronizeSvr;
begin
  inherited;
  if MessageDlg('Cette action va scanner tous les répertoires de chaque lame.' + cRC +
                'Vérifiez qu''il n''y a pas de traitement lourd déjà en cours.'  + cRC + cRC +
                'Voulez-vous continuer ?', mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      Screen.Cursor:= crHourGlass;
      try
        vThrdSyncSvr:= TThrdSynchronizeSvr.create(True);
        vThrdSyncSvr.TYPE_SYNC:= 'SYNCSRV';
        vThrdSyncSvr.FreeOnTerminate:= True;
        vThrdSyncSvr.priority:= tpNormal;
        vThrdSyncSvr.OnTerminate:= p_OnTerminate;
        vThrdSyncSvr.Resume;
        Sleep(3000);
        OptSyncSvrLoad;
      finally
        Screen.Cursor:= crDefault;
      end;
    end;
end;

procedure TParametrageFrm.SpdBtnTestingConnexionClick(Sender: TObject);
var
  vUrl: String;
begin
  inherited;
  vUrl:= GParams.Url;
  GParams.Url:= FListLameFrm.CDSListLameURL.AsString;
  MainFrm.ActTestingConnexion.Execute;
  lblTestConnexion.Caption:= MainFrm.StBrMain.Panels.Items[2].Text + ' --> ' + MainFrm.StBrMain.Panels.Items[0].Text;
  GParams.Url:= vUrl;
end;

end.
