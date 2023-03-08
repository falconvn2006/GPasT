unit UTraitement_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Buttons,
  UTraitement_Thread;

type
  TFrmTraitement = class(TForm)
    SbrInfos: TStatusBar;
    PgcTraitement: TPageControl;
    TshModeAuto: TTabSheet;
    MmoComplet: TMemo;
    TshShutDown: TTabSheet;
    TshValidate: TTabSheet;
    TshMend: TTabSheet;
    TshBackup: TTabSheet;
    TshRestore: TTabSheet;
    TshOnline: TTabSheet;
    MmoShutDown: TMemo;
    BtnShutDn: TBitBtn;
    BtnNextStep: TBitBtn;
    BtnPrevStep: TBitBtn;
    MmoValidate: TMemo;
    BtnValidate: TBitBtn;
    BtnMend: TBitBtn;
    MmoMend: TMemo;
    MmoBackup: TMemo;
    MmoRestore: TMemo;
    MmoOnLine: TMemo;
    BtnBackup: TBitBtn;
    BtnRestore: TBitBtn;
    BtnOnline: TBitBtn;
    BtnDbInfos: TBitBtn;
    BtnDbCopy: TBitBtn;
    PgbCopyFile: TProgressBar;
    BtnStopPs: TBitBtn;
    BtnStartPs: TBitBtn;
    BtnReboot: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TshModeAutoShow(Sender: TObject);
    procedure TshCommonShow(Sender: TObject);
    procedure BtnPrevStepClick(Sender: TObject);
    procedure BtnNextStepClick(Sender: TObject);
    procedure BtnStopPsClick(Sender: TObject);
    procedure BtnDbInfosClick(Sender: TObject);
    procedure BtnShutDnClick(Sender: TObject);
    procedure BtnDbCopyClick(Sender: TObject);
    procedure BtnValidateClick(Sender: TObject);
    procedure BtnMendClick(Sender: TObject);
    procedure BtnBackupClick(Sender: TObject);
    procedure BtnRestoreClick(Sender: TObject);
    procedure BtnOnlineClick(Sender: TObject);
    procedure BtnStartPsClick(Sender: TObject);
    procedure BtnRebootClick(Sender: TObject);
    procedure RBThreadCopyProgress(Sender: TObject; const APercent: Integer);
    procedure RBThreadChange(Sender: TObject);
    procedure RBThreadError(Sender: TObject; const AMessage: string);
    procedure RBThreadProgress(Sender: TObject; const AMessage: string);
    procedure RBThreadStepProgress(Sender: TObject);
    procedure RBThreadTerminate(Sender: TObject);
    procedure SbrInfosDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
  private
    { Déclarations privées }
    FCurrentMemo: TMemo;
    FModeAuto: Boolean;
    FRBThread: TRepareBaseThread;
    FBackupFileName: string;
    FDatabaseName: string;
    FDatabaseNameCopy: string;
    FLogFileName: string;
    FRestoreFileName: string;
    FShutDown: Boolean;
    FRebootAuto: Boolean;
    procedure CreateThread;
    procedure CheckDatabaseName;
  public
    { Déclarations publiques }
    property BackupFileName: string read FBackupFileName write FBackupFileName;
    property DatabaseName: string read FDatabaseName write FDatabaseName;
    property DatabaseNameCopy: string read FDatabaseNameCopy write FDatabaseNameCopy;
    property LogFileName: string read FLogFileName write FLogFileName;
    property ModeAuto: Boolean read FModeAuto write FModeAuto;
    property RebootAuto: Boolean read FRebootAuto write FRebootAuto;
    property RestoreFileName: string read FRestoreFileName write FRestoreFileName;
  end;

var
  FrmTraitement: TFrmTraitement;

implementation

uses
  System.UITypes, System.IOUtils, Winapi.CommCtrl,
  UConstants, UUtils;


{$R *.dfm}

procedure TFrmTraitement.BtnBackupClick(Sender: TObject);
begin
  CheckDatabaseName;
  //
  BtnBackup.Enabled := False;
  BtnPrevStep.Enabled := False;
  BtnNextStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoBackup;
  MmoBackup.Clear;
  FRBThread.Options := [rbBackup];
  FRBThread.Start;
end;

procedure TFrmTraitement.BtnDbCopyClick(Sender: TObject);
begin
  CheckDatabaseName;
  //
  BtnStopPs.Enabled := False;
  BtnShutDn.Enabled := False;
  BtnDbInfos.Enabled := False;
  BtnDbCopy.Enabled := False;
  BtnNextStep.Enabled := False;
  PgbCopyFile.Visible := True;
  //
  CreateThread;
  FCurrentMemo := MmoShutDown;
  MmoShutDown.Clear;
  FRBThread.Options := [rbCopy];
  FRBThread.Start;
end;

procedure TFrmTraitement.BtnDbInfosClick(Sender: TObject);
begin
  CheckDatabaseName;
  //
  BtnStopPs.Enabled := False;
  BtnShutDn.Enabled := False;
  BtnDbInfos.Enabled := False;
  BtnDbCopy.Enabled := False;
  BtnNextStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoShutDown;
  MmoShutDown.Clear;
  FRBThread.Options := [rbInfo];
  FRBThread.Start;
end;

procedure TFrmTraitement.BtnMendClick(Sender: TObject);
begin
  CheckDatabaseName;
  //
  BtnMend.Enabled := False;
  BtnPrevStep.Enabled := False;
  BtnNextStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoMend;
  MmoMend.Clear;
  FRBThread.Options := [rbMend];
  FRBThread.Start;
end;

procedure TFrmTraitement.BtnNextStepClick(Sender: TObject);
begin
  if PgcTraitement.ActivePageIndex < PgcTraitement.PageCount - 1 then
    PgcTraitement.ActivePageIndex := PgcTraitement.ActivePageIndex + 1;
end;

procedure TFrmTraitement.BtnOnlineClick(Sender: TObject);
begin
  CheckDatabaseName;
  //
  BtnStartPs.Enabled := False;
  BtnOnline.Enabled := False;
  BtnReboot.Enabled := False;
  BtnPrevStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoOnLine;
  MmoOnLine.Clear;
  FRBThread.Options := [rbOnline];
  FRBThread.Start;
end;

procedure TFrmTraitement.BtnPrevStepClick(Sender: TObject);
begin
  if PgcTraitement.ActivePageIndex > 1 then
    PgcTraitement.ActivePageIndex := PgcTraitement.ActivePageIndex - 1;
end;

procedure TFrmTraitement.BtnRebootClick(Sender: TObject);
begin
  if MessageDlg('Confirmer le redémarrage du poste ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) <> mrYes then
    Exit;
  //
  BtnStartPs.Enabled := False;
  BtnOnline.Enabled := False;
  BtnReboot.Enabled := False;
  BtnPrevStep.Enabled := False;
  //
  if not ArretSystem(EWX_REBOOT + EWX_FORCEIFHUNG) then
    MessageDlg('Echec du redémarrage automatique, veuillez procéder manuellement...', mtWarning, [mbOK], 0);
end;

procedure TFrmTraitement.BtnRestoreClick(Sender: TObject);
begin
  CheckDatabaseName;
  //
  BtnRestore.Enabled := False;
  BtnPrevStep.Enabled := False;
  BtnNextStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoRestore;
  MmoRestore.Clear;
  FRBThread.Options := [rbRestore];
  FRBThread.Start;
end;

procedure TFrmTraitement.BtnShutDnClick(Sender: TObject);
begin
  CheckDatabaseName;
  //
  BtnStopPs.Enabled := False;
  BtnShutDn.Enabled := False;
  BtnDbInfos.Enabled := False;
  BtnDbCopy.Enabled := False;
  BtnNextStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoShutDown;
  MmoShutDown.Clear;
  FRBThread.Options := [rbShutDown];
  FRBThread.Start;
end;


procedure TFrmTraitement.BtnStartPsClick(Sender: TObject);
begin
  //
  BtnStartPs.Enabled := False;
  BtnOnline.Enabled := False;
  BtnReboot.Enabled := False;

  BtnPrevStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoOnLine;
  MmoOnLine.Clear;
  FRBThread.Options := [rbStartPs];
  FRBThread.Start;
end;

procedure TFrmTraitement.BtnStopPsClick(Sender: TObject);
begin
  //
  BtnStopPs.Enabled := False;
  BtnDbInfos.Enabled := False;
  BtnShutDn.Enabled := False;
  BtnDbCopy.Enabled := False;

  BtnNextStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoShutDown;
  MmoShutDown.Clear;
  FRBThread.Options := [rbStopPs];
  FRBThread.Start;
end;

procedure TFrmTraitement.BtnValidateClick(Sender: TObject);
begin
  CheckDatabaseName;
  //
  BtnValidate.Enabled := False;
  BtnPrevStep.Enabled := False;
  BtnNextStep.Enabled := False;
  //
  CreateThread;
  FCurrentMemo := MmoValidate;
  MmoValidate.Clear;
  FRBThread.Options := [rbValidate];
  FRBThread.Start;
end;

procedure TFrmTraitement.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (not Assigned(FRBThread)) or FRBThread.Finished then
    CanClose := True
  else if MessageDlg(STOP_WORK_IN_PROGRESS, mtConfirmation, [mbNo, mbYes], 0, mbNo) = mrYes then
  begin
    if Assigned(FCurrentMemo) then
      FCurrentMemo.Lines.Add(STOP_REQUESTED);
    FRBThread.Free; // TThread.Free attend la fin de fonctionnement du thread !
    FRBThread := nil;
    CanClose := True;
  end
  else
    CanClose := False;
end;

procedure TFrmTraitement.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  //
  for i := 0 to PgcTraitement.PageCount - 1 do
    PgcTraitement.Pages[i].TabVisible := False;

  MmoComplet.Clear;
  MmoShutDown.Clear;
  MmoValidate.Clear;
  MmoMend.Clear;
  MmoBackup.Clear;
  MmoRestore.Clear;
  MmoOnLine.Clear;
  //
  SbrInfos.Panels[0].Text := TOSVersion.ToString;
  SbrInfos.Panels[1].Text := GetInterbaseVersion;
  SbrInfos.Hint := SbrInfos.Panels[0].Text + #13#10 + SbrInfos.Panels[1].Text;
  //
  PgbCopyFile.Parent := SbrInfos;
  PgbCopyFile.Min := 0;
  PgbCopyFile.Max := 100;
end;

procedure TFrmTraitement.FormShow(Sender: TObject);
begin
  if FModeAuto then
    PgcTraitement.ActivePageIndex := 0
  else
  begin
    PgcTraitement.ActivePageIndex := 1;
    BtnDbCopy.Enabled := TrimRight(FDatabaseNameCopy) <> '';
    BtnShutDn.Enabled := not FShutDown;
    BtnOnline.Enabled := FShutDown;
  end;
end;

procedure TFrmTraitement.CreateThread;
begin
  FRBThread := TRepareBaseThread.Create;
  //
  FRBThread.DBFileName := FDatabaseName;
  FRBThread.DBCopyFileName := FDatabaseNameCopy;
  FRBThread.BackupFileName := FBackupFileName;
  FRBThread.RestoreFileName := FRestoreFileName;
  FRBThread.LogFileName := FLogFileName;
  // Evènements
  FRBThread.OnTerminate := RBThreadTerminate;
  FRBThread.OnChange := RBThreadChange;
  FRBThread.OnStepProgress := RBThreadStepProgress;
  FRBThread.OnProgress := RBThreadProgress;
  FRBThread.OnError := RBThreadError;
  FRBThread.OnCopyProgress :=RBThreadCopyProgress;
end;

procedure TFrmTraitement.CheckDatabaseName;
begin
  if not FileExists(FDatabaseName) then
  begin
    MessageDlg(DB_NOT_EXIST, mtWarning, [mbAbort], 0);
    Close;
  end;
end;

procedure TFrmTraitement.TshModeAutoShow(Sender: TObject);
begin
  CreateThread;
  FCurrentMemo := MmoComplet;
  FRBThread.Options := [rbStopPs, rbInfo, rbCopy, rbShutDown, rbBackup, rbRestore, rbValidate, rbMend, rbOnline, rbStartPs];
  FRBThread.Start;
end;

procedure TFrmTraitement.TshCommonShow(Sender: TObject);
var
  TabSheet: TTabSheet;
begin
  TabSheet := TTabSheet(Sender);
  BtnPrevStep.Visible := TabSheet <> TshShutDown;
  BtnNextStep.Visible := TabSheet <> TshOnline;
end;

procedure TFrmTraitement.RBThreadChange(Sender: TObject);
begin
  if Assigned(FCurrentMemo) then
    FCurrentMemo.Lines.Add(TRepareBaseThread(Sender).Status);
end;

procedure TFrmTraitement.RBThreadCopyProgress(Sender: TObject; const APercent: Integer);
begin
  if not PgbCopyFile.Visible then
    PgbCopyFile.Visible := True;
  PgbCopyFile.Position := APercent;
end;

procedure TFrmTraitement.RBThreadError(Sender: TObject; const AMessage: string);
begin
  if Assigned(FCurrentMemo) then
    FCurrentMemo.Lines.Add(AMessage);
end;

procedure TFrmTraitement.RBThreadProgress(Sender: TObject; const AMessage: string);
begin
  if Assigned(FCurrentMemo) then
    FCurrentMemo.Lines.Add(AMessage);
end;

procedure TFrmTraitement.RBThreadStepProgress(Sender: TObject);
var
  Step: string;
begin
  case TRepareBaseThread(Sender).Step of
    rbInfo: Step := IB_OP_INFO;
    rbCopy: Step := IB_COPY;
    rbShutDown: Step := IB_OP_SHUTDOWN;
    rbValidate: Step := IB_OP_VALIDATE;
    rbMend: Step := IB_OP_MEND;
    rbBackup: Step := IB_OP_BACKUP;
    rbRestore: Step := IB_OP_RESTORE;
    rbOnline: Step := IB_OP_ONLINE;
  end;
  Caption := Step;
end;

procedure TFrmTraitement.RBThreadTerminate(Sender: TObject);
begin
  if Assigned(FCurrentMemo) then
  begin
    FCurrentMemo.Lines.Add(WORK_FINISHED);
    FCurrentMemo.Lines.Add('');
    TFile.AppendAllText(FRBThread.LogFileName, FCurrentMemo.Lines.Text, TUnicodeEncoding.Default);
    FCurrentMemo.Lines.Add(SAVE_TO_FILE + FRBThread.LogFileName);
    FCurrentMemo := nil;
    //
    if FRBThread.Step = rbStopPs then
    begin
      BtnNextStep.Enabled := True;
      BtnStopPs.Enabled := not FRBThread.LauncherStopped;
      BtnStartPs.Enabled := FRBThread.LauncherStopped;
      BtnDbInfos.Enabled := True;
      BtnDbCopy.Enabled := TrimRight(FDatabaseNameCopy) <> '';
      BtnShutDn.Enabled := not FShutDown;
      BtnOnline.Enabled := FShutDown;
    end
    else if FRBThread.Step = rbInfo then
    begin
      BtnNextStep.Enabled := True;
      BtnStopPs.Enabled := not FRBThread.LauncherStopped;
      BtnStartPs.Enabled := FRBThread.LauncherStopped;
      BtnDbInfos.Enabled := True;
      BtnDbCopy.Enabled := TrimRight(FDatabaseNameCopy) <> '';
      BtnShutDn.Enabled := not FShutDown;
      BtnOnline.Enabled := FShutDown;
    end
    else if FRBThread.Step = rbCopy then
    begin
      BtnNextStep.Enabled := True;
      BtnStopPs.Enabled := not FRBThread.LauncherStopped;
      BtnStartPs.Enabled := FRBThread.LauncherStopped;
      BtnDbInfos.Enabled := True;
      BtnDbCopy.Enabled := True;
      BtnShutDn.Enabled := not FShutDown;
      BtnOnline.Enabled := FShutDown;
      PgbCopyFile.Visible := False;
    end
    else if FRBThread.Step = rbShutDown then
    begin
      FShutDown := True;
      BtnNextStep.Enabled := True;
      BtnStopPs.Enabled := not FRBThread.LauncherStopped;
      BtnStartPs.Enabled := FRBThread.LauncherStopped;
      BtnDbInfos.Enabled := True;
      BtnDbCopy.Enabled := TrimRight(FDatabaseNameCopy) <> '';
      BtnOnline.Enabled := True;
    end
    else if FRBThread.Step = rbValidate then
    begin
      BtnValidate.Enabled := True;
      BtnPrevStep.Enabled := True;
      BtnNextStep.Enabled := True;
    end
    else if FRBThread.Step = rbMend then
    begin
      BtnMend.Enabled := True;
      BtnPrevStep.Enabled := True;
      BtnNextStep.Enabled := True;
    end
    else if FRBThread.Step = rbBackup then
    begin
      BtnBackup.Enabled := True;
      BtnPrevStep.Enabled := True;
      BtnNextStep.Enabled := True;
    end
    else if FRBThread.Step = rbRestore then
    begin
      BtnRestore.Enabled := True;
      BtnPrevStep.Enabled := True;
      BtnNextStep.Enabled := True;
    end
    else if FRBThread.Step = rbOnline then
    begin
      BtnOnline.Enabled := True;
      BtnStartPs.Enabled := True;
      BtnReboot.Enabled := True;
      BtnPrevStep.Enabled := True;
      BtnShutDn.Enabled := FShutDown;
      BtnOnline.Enabled := not FShutDown;
    end
    else if FRBThread.Step = rbStartPs then
    begin
      BtnOnline.Enabled := True;
      BtnStartPs.Enabled := FRBThread.LauncherStopped;
      BtnReboot.Enabled := True;
      BtnPrevStep.Enabled := True;
      BtnShutDn.Enabled := not FShutDown;
      BtnOnline.Enabled := FShutDown;
    end;
  end;
  //
  if FRebootAuto then
    BtnRebootClick(nil);
end;

procedure TFrmTraitement.SbrInfosDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel = StatusBar.Panels[2] then
  begin
    PgbCopyFile.Top := Rect.Top;
    PgbCopyFile.Left := Rect.Left;
    PgbCopyFile.Width := Rect.Right - Rect.Left - 15;
    PgbCopyFile.Height := Rect.Bottom - Rect.Top;
  end;
end;

end.


{
L'API ExitWindowsEx permet l'arrêt ou le redémarrage de Windows. Elle envoie le message WM_QUERYENDSESSION à toutes les applications pour déterminer si elles peuvent s'arrêter.
Si une application renvoie False la procédure est annulée.

Unité Windows :
Function ExitWindowsEx(uFlags: UINT; dwReserved: DWORD): BOOL; stdcall;

Valeurs de uFlags :
Pour terminer la session en cours : EWX_LOGOFF

Pour arrêter Windows ( n'arrête pas l'alimentation ) : EWX_SHUTDOWN
Sous Windows XP SP1, si l'ordinateur supporte l'arrêt logiciel de l'alimentation, dans ce cas elle est arrêtée.

Pour arrêter Windows et l'alimentation : EWX_POWEROFF

Pour redémarrer Windows : EWX_REBOOT

Pour forcer la fin des process avant le redémarrage de Windows : EWX_SHUTDOWN + EWX_ FORCE
Dans ce cas la fonction n'envoie pas le message WM_QUERYENDSESSION et WM_ENDSESSION ce qui peut entraîner des pertes de données. A n'utiliser qu'en cas d'urgence
Sous Windows XP, si l'ordinateur est verrouillé, la procédure d'arrêt échoue sauf si celle-ci est exécutée à partir d'un service.

Pour forcer l'arrêt des applications qui ne répondent pas au message WM_QUERYENDSESSION ou WM_ENDSESSION dans l'intervalle de temps alloué : EWX_SHUTDOWN + EWX_FORCEIFHUNG
Sous Windows NT et Windows Me/98/95: cette valeur n'est pas supportée.

dwReserved (le SDK indique : DWORD dwReason)
Indique la raison de l'arrêt. Zéro indique qu'il s'agit d'un arrêt 'non défini'. Vous pouvez spécifier un code indiquant la raison du arrêt du système.
Pour plus de détails
Si l'appel renvoie True rien ne vous assure que l'arrêt sera effectivement exécuté, le système ou une application pouvant l'annuler.
Si l'appel échoue la fonction renvoie False dans ce cas appellez l'API GetLastError pour obtenir des informations sur l'erreur.

Pour pouvoir exécuter cette fonction il faut positionner le privilège SE_SHUTDOWN_NAME avant l'appel


Function ArretSystem: Boolean;
Var
 Token: THandle;
 TokenPrivilege: TTokenPrivileges;
 Outlen : Cardinal;
 Error:Dword;

Const
 SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';

Begin
   Result:=False;
   // Récupère les informations de sécurité pour ce process.
   if not OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, Token)
    then Exit;
  try

   FillChar(TokenPrivilege, SizeOf(TokenPrivilege),0);
     // Valeur de retour
   Outlen := 0;
     // Un seul privilége à positionner
   TokenPrivilege.PrivilegeCount := 1;

     // Récupère le LUID pour le privilége 'shutdown'.
     // un Locally Unique IDentifier est une valeur générée unique jusqu'a ce
     // que le système soit redémarré
   LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TokenPrivilege.Privileges[0].Luid);

     // Positionne le privilége shutdown pour ce process.
   TokenPrivilege.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
   AdjustTokenPrivileges(Token, False, TokenPrivilege, SizeOf(TokenPrivilege),nil, OutLen);

   Error:=GetLastError;
   If Error <> ERROR_SUCCESS
    then Exit;

     // Arrête le système
   if ExitWindowsEx(EWX_POWEROFF, 0)=False
      then Exit;
   Result:=True;

  finally
   CloseHandle(Token);
  end;
end;
}
