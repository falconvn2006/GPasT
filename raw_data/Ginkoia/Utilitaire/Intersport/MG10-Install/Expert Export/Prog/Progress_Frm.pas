unit Progress_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, AdvProgr;

type
  TFrm_Progress = class(TForm)
    Lab_Etat1: TLabel;
    Lab_Etat2: TLabel;
    pb_Etat1: TProgressBar;
  private
    { Déclarations privées }
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    procedure DoEtat(AEtat1, AEtat2: string); overload;
    procedure DoEtat(AEtat2: string); overload;

    procedure SetInitBar(ACount: integer);
    procedure DoProgress(APosition: integer);
    procedure SetEndBar;
  end;

var
  Frm_Progress: TFrm_Progress;

implementation

{$R *.dfm}

{ TFrm_Progress }

procedure TFrm_Progress.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then
  begin
    Msg.Result := 1;
    Application.Minimize;
    Application.ProcessMessages;
    exit;
  end;
  inherited;
end;

procedure TFrm_Progress.DoEtat(AEtat1, AEtat2: string);
begin
  if AEtat1<>Lab_Etat1.Caption then
    Lab_Etat1.Caption := AEtat1;
  Lab_Etat2.Caption := AEtat2;
  Application.ProcessMessages;
end;

procedure TFrm_Progress.DoEtat(AEtat2: string);
begin
  DoEtat(Lab_Etat1.Caption, AEtat2);
end;

procedure TFrm_Progress.DoProgress(APosition: integer);
begin
  if APosition>pb_Etat1.Max then
    pb_Etat1.Position := pb_Etat1.Max
  else
    pb_Etat1.Position := APosition;
  pb_Etat1.Refresh;
  Application.ProcessMessages;
end;

procedure TFrm_Progress.SetEndBar;
begin
  pb_Etat1.Visible := false;
  Refresh;
  Application.ProcessMessages;
end;

procedure TFrm_Progress.SetInitBar(ACount: integer);
begin
  pb_Etat1.Position := 0;
  pb_Etat1.Max := ACount;
  pb_Etat1.Visible := True;
  Refresh;
  Application.ProcessMessages;
end;

end.
