unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActnList, Menus, ExtCtrls, ComCtrls;


type
  TMainFrm = class(TForm)
    ActLstMain: TActionList;
    StBrMain: TStatusBar;
    TrayIconMain: TTrayIcon;
    PpMenuMain: TPopupMenu;
    ActClose: TAction;
    ActSynthese: TAction;
    ActClients: TAction;
    Synthse1: TMenuItem;
    Clients1: TMenuItem;
    N1: TMenuItem;
    Fermer1: TMenuItem;
    ActParametrage: TAction;
    MainMenu: TMainMenu;
    mmFichier: TMenuItem;
    mmTableauDeBord: TMenuItem;
    Paramtrage1: TMenuItem;
    N2: TMenuItem;
    Fermer2: TMenuItem;
    Synthse2: TMenuItem;
    Clients2: TMenuItem;
    pnlTaleauDeBord: TPanel;
    SpdBtnSynthese: TSpeedButton;
    SpdBtnClient: TSpeedButton;
    pnlProgress: TPanel;
    lblProgress: TLabel;
    PrgsBrMain: TProgressBar;
    ActTestingConnexion: TAction;
    Button1: TButton;
    SpdBtnSplittage: TSpeedButton;
    ActRecupBase: TAction;
    SuiviSplittage1: TMenuItem;
    SuiviSplittage2: TMenuItem;
    procedure ActCloseExecute(Sender: TObject);
    procedure ActSyntheseExecute(Sender: TObject);
    procedure ActClientsExecute(Sender: TObject);
    procedure TrayIconMainDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActParametrageExecute(Sender: TObject);
    procedure ActTestingConnexionExecute(Sender: TObject);
    procedure PpMenuMainPopup(Sender: TObject);
    procedure TrayIconMainClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ActRecupBaseExecute(Sender: TObject);
  private
    procedure StartConnexion;
  public
  end;

var
  MainFrm: TMainFrm;

procedure ShowApplication;

implementation

uses FrmClients, FrmSynthese, dmdClients, uConst, u_Parser, uTool,
  FrmParametrage, uZipGinkoia, FrmSplittage;

procedure ShowApplication;
var
  vHdl: THandle;
begin
  vHdl:= FindWindow(nil, cNameMain);
  SetForegroundWindow(vHdl);
end;

{$R *.dfm}

procedure TMainFrm.ActClientsExecute(Sender: TObject);
begin
  if not Assigned(ClientsFrm) then
    begin
      ClientsFrm:= TClientsFrm.Create(Self);
      StBrMain.Panels.Items[0].Text:= cConnexionOk;
    end;
//  Hide;
  ClientsFrm.Show;
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
begin
  if not Assigned(SplittageFrm) then
    begin
      SplittageFrm:= TSplittageFrm.Create(Self);
      StBrMain.Panels.Items[0].Text:= cConnexionOk;
    end;
//  Hide;
  SplittageFrm.Show;
end;

procedure TMainFrm.ActSyntheseExecute(Sender: TObject);
begin
  if not Assigned(SyntheseFrm) then
    begin
      TrayIconMainDblClick(nil);
      pnlProgress.Visible:= True;
      SyntheseFrm:= TSyntheseFrm.Create(Self);
      SyntheseFrm.AProgessBar:= PrgsBrMain;
      Application.ProcessMessages;
      SyntheseFrm.Initialize;
      pnlProgress.Visible:= False;
      StBrMain.Panels.Items[0].Text:= cConnexionOk;
    end;
//  Hide;
  SyntheseFrm.Show;
end;

procedure TMainFrm.ActTestingConnexionExecute(Sender: TObject);
begin
  StBrMain.Panels.Items[1].Text:= GParams.Url;
  StartConnexion;
end;

procedure TMainFrm.Button1Click(Sender: TObject);
//var
//  vSL: TStringList;
//  Buffer: String;
begin
//  CopyFile(Pchar('C:\temp\toto\*.*'), Pchar('C:\tmp\titi\'), False);
//  vSL:= TStringList.Create;
//  try
//    vSL.Append('C:\temp\toto\DATA\GINKOIA.IB');
//    vSL.Append('C:\temp\toto\EAI\DelosQPMAgent.InitParams.xml');
//    vSL.Append('C:\temp\toto\EAI\DelosQPMAgent.Providers.xml');
//    vSL.Append('C:\temp\toto\EAI\DelosQPMAgent.Subscriptions.xml');

//    ZipFile(vSL, 'C:\tmp\titi\TEST4.zip');
//    ZipFileWithPath('D:\EAI\MAJ\V13.1.1.1', '', '*.*', True, 'D:\Transferts\Bases\TEST.7z');
//  finally
//    FreeAndNil(vSL);
//  end;

//  if ExecAndWaitProcess('C:\Developpement\Ginkoia\UTILITAIRE\Outils AdminDB\WebService\Maintenance\RecupBase.exe',
//                        ' AUTO="C:\Ginkoia\EAI\MORAT\SERVEUR_MONTMELIAN_ST-ALBAN_000034_MORAT\DATA\GINKOIA.IB"', '', Buffer) <> 0 then

//  if ExecAndWaitProcess('C:\Developpement\Ginkoia\UTILITAIRE\Outils AdminDB\FileCopy\Debug\Win32\FileCopy.exe', '/SRC=C:\toto.txt /DEST=D:\toto.txt /SILENT=0 /AUTOCLOSE=1', '', Buffer) <> 0 then
//    ShowMessage(Buffer)
//  else
//    ShowMessage('Ok');
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  if not GParams.IsFileExist then
    begin
      ActSynthese.Enabled:= False;
      ActClients.Enabled:= False;
    end
  else
    ActTestingConnexion.Execute;
end;

procedure TMainFrm.PpMenuMainPopup(Sender: TObject);
begin
  ActClose.Enabled:= GIsBrowse;
  ActSynthese.Enabled:= GIsBrowse;
  ActClients.Enabled:= GIsBrowse;
end;

procedure TMainFrm.StartConnexion;
var
  vSL: TStringList;
begin
  StBrMain.Panels.Items[0].Text:= cConnexionNotOk;
  ActSynthese.Enabled:= False;
  ActClients.Enabled:= False;
  vSL:= TStringList.Create;
  try
    try
      vSL.Append(cStart);

      if dmClients.ResetConnexion then
        begin
          StBrMain.Panels.Items[0].Text:= cConnexionOk;
          ActSynthese.Enabled:= True;
          ActClients.Enabled:= True;
          dmClients.LoadLists;
        end;
    except
      ActSynthese.Enabled:= False;
      ActClients.Enabled:= False;
      StBrMain.Panels.Items[0].Text:= cConnexionNotOk;
      Raise;
    end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TMainFrm.TrayIconMainClick(Sender: TObject);
begin
  ShowApplication;
end;

procedure TMainFrm.TrayIconMainDblClick(Sender: TObject);
begin
  if GIsBrowse then
    begin
      if Assigned(SyntheseFrm) then
        SyntheseFrm.Hide;
      if Assigned(ClientsFrm) then
        ClientsFrm.Hide;
      if Assigned(SplittageFrm) then
        SplittageFrm.Hide;
      Show;
    end;
end;

end.
