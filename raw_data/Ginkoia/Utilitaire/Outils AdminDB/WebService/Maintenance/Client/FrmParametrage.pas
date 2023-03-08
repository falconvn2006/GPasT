unit FrmParametrage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaBox, cxPropertiesStore, StdCtrls, Buttons, ExtCtrls,
  Grids, ValEdit, IdHTTP;

type
  TParametrageFrm = class(TCustomGinkoiaBoxFrm)
    pnlParam: TPanel;
    SpdBtnSaveParam: TSpeedButton;
    ValueListEditor: TValueListEditor;
    SpdBtnTestingConnexion: TSpeedButton;
    Pan_1: TPanel;
    grpbxSyncSvr: TGroupBox;
    lblAnswerServeur: TLabel;
    SpdBtnSyncSvr: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpdBtnSaveParamClick(Sender: TObject);
    procedure SpdBtnTestingConnexionClick(Sender: TObject);
    procedure SpdBtnSyncSvrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure OptSyncSvrLoad;
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

end;

procedure TParametrageFrm.FormShow(Sender: TObject);
begin
  inherited;
  ValueListEditor.Strings.Assign(GParams.ListParam);
  OptSyncSvrLoad;
end;

procedure TParametrageFrm.OptSyncSvrLoad;
var
  vIdHTTP: TIdHTTP;
begin
  vIdHTTP:= dmClients.GetNewIdHTTP(nil);
  try
    lblAnswerServeur.Caption:= vIdHTTP.Get(GParams.Url + 'SynchronizeSVRStarted');
    SpdBtnSyncSvr.Enabled:= lblAnswerServeur.Caption = '';
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

procedure TParametrageFrm.SpdBtnSaveParamClick(Sender: TObject);
begin
  inherited;
  GParams.ListParam.Assign(ValueListEditor.Strings);
  GParams.Save;
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
        vThrdSyncSvr.FreeOnTerminate:= True;
        vThrdSyncSvr.priority:= tpNormal;
        vThrdSyncSvr.Resume;
        Sleep(3000);
        OptSyncSvrLoad;
      finally
        Screen.Cursor:= crDefault;
      end;
    end;
end;

procedure TParametrageFrm.SpdBtnTestingConnexionClick(Sender: TObject);
begin
  inherited;
  MainFrm.ActTestingConnexion.Execute;
end;

end.
