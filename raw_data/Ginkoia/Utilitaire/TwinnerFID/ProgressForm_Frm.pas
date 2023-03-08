unit ProgressForm_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvSmoothProgressBar, StdCtrls;

type
  TFrm_ProgressForm = class(TForm)
    Lab_Info1: TLabel;
    AS_Progress1: TAdvSmoothProgressBar;
    AS_Progress2: TAdvSmoothProgressBar;
    Lab_Info2: TLabel;
    Lab_TitreProg1: TLabel;
    Lab_Progress1: TLabel;
    Lab_TitreProg2: TLabel;
    Lab_Progress2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
    bFermer: boolean;
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
  end;

var
  Frm_ProgressForm: TFrm_ProgressForm;

procedure InitProgressForm(AInfo1, AInfo2, ATitreProg1, AProgress1, ATitreProg2, AProgress2: string);
procedure SetProgressFormInfo1(AInfo: string);
procedure SetProgressFormInfo2(AInfo: string);
procedure SetProgressFormTitreProg1(ATitreProg: string);
procedure SetProgressFormTitreProg2(ATitreProg: string);
procedure SetProgressFormProgress1(AProgress: string; APosition: integer);
procedure SetProgressFormProgress2(AProgress: string; APosition: integer);
procedure CloseProgressForm;

implementation

{$R *.dfm}

procedure InitProgressForm(AInfo1, AInfo2, ATitreProg1, AProgress1, ATitreProg2, AProgress2: string);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  if Assigned(Frm_ProgressForm) then
  begin
    Frm_ProgressForm.BringToFront;
    Application.ProcessMessages;
  end
  else
  begin
    Application.CreateForm(TFrm_ProgressForm, Frm_ProgressForm);
  end;
  with Frm_ProgressForm do
  begin
    Lab_Info1.Caption := AInfo1;
    Lab_Info2.Caption := AInfo2;

    Lab_TitreProg1.Caption := ATitreProg1;
    Lab_Progress1.Caption := AProgress1;
    AS_Progress1.Position := 0.0;

    Lab_TitreProg2.Caption := ATitreProg2;
    Lab_Progress2.Caption := AProgress2;
    AS_Progress2.Position := 0.0;
    Application.ProcessMessages;

    Refresh;
    Show;
  end;
  Application.ProcessMessages;
end;

procedure SetProgressFormInfo1(AInfo: string);
begin
  if Assigned(Frm_ProgressForm) then
  begin
    Frm_ProgressForm.Lab_Info1.Caption := AInfo;
  end;
  Application.ProcessMessages;
end;

procedure SetProgressFormInfo2(AInfo: string);
begin
  if Assigned(Frm_ProgressForm) then
  begin
    Frm_ProgressForm.Lab_Info2.Caption := AInfo;
  end;
  Application.ProcessMessages;
end;

procedure SetProgressFormTitreProg1(ATitreProg: string);
begin
  if Assigned(Frm_ProgressForm) then
  begin
    Frm_ProgressForm.Lab_TitreProg1.Caption := ATitreProg;
  end;
  Application.ProcessMessages;
end;

procedure SetProgressFormTitreProg2(ATitreProg: string);
begin
  if Assigned(Frm_ProgressForm) then
  begin
    Frm_ProgressForm.Lab_TitreProg2.Caption := ATitreProg;
  end;
  Application.ProcessMessages;
end;

procedure SetProgressFormProgress1(AProgress: string; APosition: integer);
var
  APosi: integer;
begin
  if Assigned(Frm_ProgressForm) then
  begin
    Frm_ProgressForm.Lab_Progress1.Caption := AProgress;
    APosi := APosition;
    if APosi<0 then
      APosi := 0;
    if APosi>100 then
      APosi := 100;
    Frm_ProgressForm.AS_Progress1.Position := APosi;
  end;
  Application.ProcessMessages;
end;

procedure SetProgressFormProgress2(AProgress: string; APosition: integer);
var
  APosi: integer;
begin
  if Assigned(Frm_ProgressForm) then
  begin
    Frm_ProgressForm.Lab_Progress2.Caption := AProgress;
    APosi := APosition;
    if APosi<0 then
      APosi := 0;
    if APosi>100 then
      APosi := 100;
    Frm_ProgressForm.AS_Progress2.Position := APosi;
  end;
  Application.ProcessMessages;
end;

procedure CloseProgressForm;
begin
  Application.ProcessMessages;
  Screen.Cursor := crDefault;
  if Assigned(Frm_ProgressForm) then
  begin
    Frm_ProgressForm.bFermer := true;
    FreeAndNil(Frm_ProgressForm);
  end;
  Application.ProcessMessages;
end;

procedure TFrm_ProgressForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := bFermer;
end;

procedure TFrm_ProgressForm.FormCreate(Sender: TObject);
begin
  bFermer := false;
end;

procedure TFrm_ProgressForm.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
end;

initialization
  Frm_ProgressForm := nil;

end.
