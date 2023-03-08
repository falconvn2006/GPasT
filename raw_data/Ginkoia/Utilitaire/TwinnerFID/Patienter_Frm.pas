unit Patienter_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvSmoothProgressBar;

type
  TFrm_Patienter = class(TForm)
    Lab_Info: TLabel;
    AdvSmoothProgressBar1: TAdvSmoothProgressBar;
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
  Frm_Patienter: TFrm_Patienter;

procedure VeuillezPatienter(AInfo: string);
procedure FermerPatienter;

implementation

{$R *.dfm}

procedure VeuillezPatienter(AInfo: string);
begin
  if Assigned(Frm_Patienter) then
  begin
    Frm_Patienter.BringToFront;
    Application.ProcessMessages;
    exit;
  end;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Application.CreateForm(TFrm_Patienter, Frm_Patienter);
  Frm_Patienter.Lab_Info.Caption := AInfo;
  Frm_Patienter.Show;
  Application.ProcessMessages;
end;

procedure FermerPatienter;
begin
  Application.ProcessMessages;
  Screen.Cursor := crDefault;
  if Assigned(Frm_Patienter) then
  begin
    Frm_Patienter.bFermer := true;
    FreeAndNil(Frm_Patienter);
  end;
  Application.ProcessMessages;
end;

procedure TFrm_Patienter.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := bFermer;
end;

procedure TFrm_Patienter.FormCreate(Sender: TObject);
begin
  bFermer := false;
end;

procedure TFrm_Patienter.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
end;

initialization
  Frm_Patienter := nil;

end.
