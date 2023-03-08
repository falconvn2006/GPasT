unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, ComCtrls, ToolWin, cxPropertiesStore, StdCtrls,
  ExtCtrls, UVersion, u_Parser;

Const
  cApplName = 'Maintenance Ginkoia';

type
  TMainFrm = class(TForm)
    MainMenu: TMainMenu;
    mmFichier: TMenuItem;
    Paramtrage1: TMenuItem;
    N2: TMenuItem;
    Fermer2: TMenuItem;
    mmTableauDeBord: TMenuItem;
    SuiviSplittage1: TMenuItem;
    Synthse2: TMenuItem;
    Clients2: TMenuItem;
    PpMenuMain: TPopupMenu;
    SuiviSplittage2: TMenuItem;
    Synthse1: TMenuItem;
    Clients1: TMenuItem;
    N1: TMenuItem;
    Fermer1: TMenuItem;
    ActLstMain: TActionList;
    ActClose: TAction;
    ActSynthese: TAction;
    ActClients: TAction;
    ActParametrage: TAction;
    ActTestingConnexion: TAction;
    ActRecupBase: TAction;
    StBrMain: TStatusBar;
    TlBrMain: TToolBar;
    TlBtnChangerLame: TToolButton;
    TlBtnSuiviSplittage: TToolButton;
    TlBtnSynthese: TToolButton;
    ActChangerLame: TAction;
    ToolButton4: TToolButton;
    TlBtnClients: TToolButton;
    Changerdelame1: TMenuItem;
    N3: TMenuItem;
    mnFenetre: TMenuItem;
    Cascade1: TMenuItem;
    ActCascade: TAction;
    ActWindowsTileH: TAction;
    ActWindowsTileV: TAction;
    Mosaquehorizontale1: TMenuItem;
    Mosaqueverticale1: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    ActCloseAll: TAction;
    N4: TMenuItem;
    outfermer1: TMenuItem;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    cxPropertiesStore: TcxPropertiesStore;
    Btn_1: TButton;
    pnlPopupMsg: TPanel;
    TimerPopupMsg: TTimer;
    lblPopupMsg: TLabel;
    lblPopupMsgTitle: TLabel;
    pnlSep: TPanel;
    procedure ActRecupBaseExecute(Sender: TObject);
    procedure ActClientsExecute(Sender: TObject);
    procedure ActSyntheseExecute(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure ActParametrageExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActTestingConnexionExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActChangerLameExecute(Sender: TObject);
    procedure ActCascadeExecute(Sender: TObject);
    procedure ActWindowsTileHExecute(Sender: TObject);
    procedure ActWindowsTileVExecute(Sender: TObject);
    procedure ActCloseAllExecute(Sender: TObject);
    procedure Btn_1Click(Sender: TObject);
    procedure TimerPopupMsgTimer(Sender: TObject);
    procedure lblPopupMsgClick(Sender: TObject);
    procedure TestMailClick(Sender: TObject);
  private
    function GetFormExist(const AName: String): TForm;

    procedure TestConnexion;
  public
    procedure ShowPopupMsg(Const ATitle, AMessage: String;
                           Const ADlgType: TMsgDlgType; Const ADelai: integer = -1);
    property FormExist[Const AName: String]: TForm read GetFormExist;
  end;

var
  MainFrm: TMainFrm;

procedure VerifVersion;

implementation

uses dmdClients, FrmSplittage, FrmClients, FrmClient, FrmSynthese,
  FrmParametrage, uConst, FrmListLame, uTool, FrmListFolder,
  uXmlDelosQPMAgentDatabases, FrmDlgModeleMail;

{$R *.dfm}

{ TMainFrm }

procedure VerifVersion;
var
  vSLTmp,
  vSL     : TStringList;
  vVersion_Client: string;
begin
  vSL:= TStringList.Create;
  vSLTmp:= TStringList.Create;
  try
    try
      vSLTmp.Clear;
      vSLTmp.Delimiter := '.';
      vSLTmp.DelimitedText := GetNumVersionSoft;
      vVersion_Client := 'v' + vSLTmp.Strings[0] + '.' + vSLTmp.Strings[1] + '.' +  vSLTmp.Strings[2];

      dmClients.XmlToList('MaintenanceVersion?VERSION_CLIENT=' + vVersion_Client, cBlsResult, '', vSL, nil, False);
    except
      Raise;
    end;

    if vSL.Count <> 0 then
      begin
        if Pos('identique',vSL.Text)>1
          then MessageDlg(vSL.Text, mtInformation, [mbOk], 0)
          else MessageDlg(vSL.Text, mtError, [mbOk], 0)
      end;
  finally
    FreeAndNil(vSL);
    FreeAndNil(vSLTmp);
  end;
end;

procedure TMainFrm.ActCascadeExecute(Sender: TObject);
begin
  Cascade;
end;

procedure TMainFrm.ActChangerLameExecute(Sender: TObject);
var
  vListLameFrm: TListLameFrm;
begin
  if MDIChildCount <> 0 then
    begin
      MessageDlg('Vous devez fermer toutes les fenêtres avant de changer de lame.', mtInformation, [mbOk], 0);
      Exit;
    end;

  vListLameFrm:= TListLameFrm.Create(nil);
  try
    if vListLameFrm.ShowModal = mrOk then
    begin
      GParams.Url:= vListLameFrm.CDSListLameURL.AsString;
      GParams.AliasName:= vListLameFrm.CDSListLameNAME.AsString;
      GParams.Load;
      ActTestingConnexion.Execute;

      VerifVersion;
    end;
  finally
    FreeAndNil(vListLameFrm);
  end;
end;

procedure TMainFrm.ActClientsExecute(Sender: TObject);
var
  vClientsFrm: TClientsFrm;
  vForm: TForm;
begin
  vForm:= FormExist['ClientsFrm'];
  if vForm = nil then
    begin
      vClientsFrm:= TClientsFrm.Create(Application);
      vClientsFrm.Name:= 'ClientsFrm';
      //vClientsFrm.Top:= TlBrMain.Top + TlBrMain.Height;
      vClientsFrm.WindowState:= wsMaximized;
    end
  else
    vForm.Show;
end;

procedure TMainFrm.ActCloseAllExecute(Sender: TObject);
var
  i: integer;
  vForm: TForm;
begin
  for i:= MDIChildCount -1 Downto 0 do
    begin
      vForm:= MDIChildren[i];
      FreeAndNil(vForm);
    end;
end;

procedure TMainFrm.ActCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainFrm.ActParametrageExecute(Sender: TObject);
var
  vParametrageFrm: TParametrageFrm;
begin
  vParametrageFrm:= TParametrageFrm.Create(nil);
  try
    vParametrageFrm.ShowModal;
  finally
    FreeAndNil(vParametrageFrm);
  end;
end;

procedure TMainFrm.ActRecupBaseExecute(Sender: TObject);
var
  vSplittageFrm: TSplittageFrm;
  vForm: TForm;
begin
  vForm:= FormExist['SplittageFrm'];
  if vForm = nil then
    begin
      vSplittageFrm:= TSplittageFrm.Create(Application);
      vSplittageFrm.Name:= 'SplittageFrm';
      //vSplittageFrm.Top:= TlBrMain.Top + TlBrMain.Height;
      vSplittageFrm.WindowState := wsMaximized;
    end
  else
    vForm.Show;
end;

procedure TMainFrm.ActSyntheseExecute(Sender: TObject);
var
  vSyntheseFrm: TSyntheseFrm;
  vForm: TForm;
begin
  vForm:= FormExist['SyntheseFrm'];
  if vForm = nil then
    begin
      vSyntheseFrm:= TSyntheseFrm.Create(Application);
      vSyntheseFrm.Name:= 'SyntheseFrm';
      //vSyntheseFrm.Top:= TlBrMain.Top + TlBrMain.Height;
      vSyntheseFrm.WindowState := wsMaximized;
      Application.ProcessMessages;
      vSyntheseFrm.Initialize;
    end
  else
    vForm.Show;
end;

procedure TMainFrm.ActTestingConnexionExecute(Sender: TObject);
begin
  Screen.Cursor:= crHourGlass;
  try
    StBrMain.Panels.Items[2].Text:= GParams.Url;
    StBrMain.Panels.Items[1].Text:= GParams.UrlToHost(StBrMain.Panels.Items[2].Text);
    Caption:= 'Connecté à : ' + GParams.AliasName;
    TestConnexion;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainFrm.ActWindowsTileHExecute(Sender: TObject);
begin
  TileMode:= tbHorizontal;
  Tile;
end;

procedure TMainFrm.ActWindowsTileVExecute(Sender: TObject);
begin
  TileMode:= tbVertical;
  Tile;
end;

procedure TMainFrm.Btn_1Click(Sender: TObject);
//var
//  i: integer;
begin
  //-->
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  ActTestingConnexion.Execute;
  MainFrm.Caption := 'Maintenance Ginkoia - Version : ' + GetNumVersionSoft;
end;

procedure TMainFrm.FormShow(Sender: TObject);
begin
  Screen.Cursor:= crDefault;
end;

function TMainFrm.GetFormExist(const AName: String): TForm;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to MDIChildCount -1 do
    begin
      if Pos(AName, MDIChildren[i].Name) <> 0 then
        begin
          Result:= MDIChildren[i];
          Break;
        end;
    end;
end;

procedure TMainFrm.lblPopupMsgClick(Sender: TObject);
begin
  pnlPopupMsg.Visible:= False;
end;

procedure TMainFrm.ShowPopupMsg(const ATitle, AMessage: String;
  Const ADlgType: TMsgDlgType; const ADelai: integer);
begin
  case ADlgType of
    mtWarning: pnlPopupMsg.Color:= $004080FF;
    mtError: pnlPopupMsg.Color:= clRed;
    mtConfirmation, mtInformation: pnlPopupMsg.Color:= clSkyBlue;
  end;

  pnlPopupMsg.Visible:= True;
  lblPopupMsgTitle.Caption:= ATitle;
  lblPopupMsg.Caption:= AMessage;
  pnlPopupMsg.Refresh;

  if ADelai <> -1 then
    begin
      TimerPopupMsg.Interval:= ADelai;
      TimerPopupMsg.Enabled:= True;
    end;
end;

procedure TMainFrm.TestConnexion;
var
  vSL: TStringList;
begin
  StBrMain.Panels.Items[0].Text:= cConnexionNotOk;
  ActSynthese.Enabled:= False;
  ActClients.Enabled:= False;
  ActRecupBase.Enabled:= False;
  vSL:= TStringList.Create;
  try
    try
      vSL.Append(cStart);

      if dmClients.ResetConnexion then
        begin
          StBrMain.Panels.Items[0].Text:= cConnexionOk;
          ActSynthese.Enabled:= True;
          ActClients.Enabled:= True;
          ActRecupBase.Enabled:= True;
          dmClients.LoadLists;
        end;
    except
      ActSynthese.Enabled:= False;
      ActClients.Enabled:= False;
      ActRecupBase.Enabled:= False;
      StBrMain.Panels.Items[0].Text:= cConnexionNotOk;
      Raise;
    end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TMainFrm.TestMailClick(Sender: TObject);
var
  i, vEMET_ID: integer;
  vModeleMailFrm: TDlgModeleMailFrm;
begin
  vModeleMailFrm:= TDlgModeleMailFrm.Create(nil);
  try
    if vModeleMailFrm.ShowModal = mrOk then
    begin
      Screen.Cursor:= crHourGlass;
      dmClients.CDSSendMail.EmptyDataSet;
      dmClients.CDSSendMail.Append;
      dmClients.CDSSendMail.FieldByName('EMET_ID').AsInteger:= 0;
      dmClients.CDSSendMail.FieldByName('MAIL_FILENAME').AsString:= dmClients.CDSModeleMail.FieldByName('MAIL_FILENAME').AsString;
      dmClients.CDSSendMail.Post;
    end;
    if dmClients.CDSSendMail.RecordCount <> 0 then
      dmClients.PostRecordToXml('SendMailTest', 'TEmetteur', dmClients.CDSSendMail, nil, True);
  finally
    FreeAndNil(vModeleMailFrm);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainFrm.TimerPopupMsgTimer(Sender: TObject);
begin
  pnlPopupMsg.Visible:= False;
end;

end.
