unit Progression_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, RzLabel;

type
  TFrm_Progression = class(TForm)
    Lab_Info: TRzLabel;
    prg_Progress: TProgressBar;
    Lab_Pourcen: TRzLabel;
  private
    { Déclarations privées }    
  // intercepte le clic sur le bouton minimise
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
  end;

var
  Frm_Progression: TFrm_Progression;

procedure VeuillezPatienter(sInfo: string; MaxProgress: integer);
procedure SetMaxProgress(AMax: integer);
procedure AffichePatienter;
procedure AvanceProgress(const ANbre: integer = 1);
procedure FermerPatienter;

implementation

{$R *.dfm}

procedure VeuillezPatienter(sInfo: string; MaxProgress: integer);
begin
  if not(Assigned(Frm_Progression)) then
    Frm_Progression := TFrm_Progression.Create(Application);
  Frm_Progression.Lab_Info.Caption := sInfo;
  Frm_Progression.prg_Progress.Position := 0;
  Frm_Progression.prg_Progress.Max := MaxProgress;
  Frm_Progression.Lab_Pourcen.Caption := '0%';
  Application.ProcessMessages;
end;

procedure SetMaxProgress(AMax: integer);
begin
  Frm_Progression.prg_Progress.Max := AMax;
  Frm_Progression.Lab_Pourcen.Caption := '0%';
  Application.ProcessMessages;
end;
    
procedure AffichePatienter;
begin
  if Assigned(Frm_Progression) then
  begin
    Frm_Progression.Show;
    Frm_Progression.BringToFront;
    Application.ProcessMessages;
  end;
end;

procedure AvanceProgress(const ANbre: integer = 1);
begin
  if Assigned(Frm_Progression) then
  begin
    if Frm_Progression.prg_Progress.Position<Frm_Progression.prg_Progress.Max then
      Frm_Progression.prg_Progress.Position := Frm_Progression.prg_Progress.Position+ANbre;
    if Frm_Progression.prg_Progress.Max>0 then
      Frm_Progression.Lab_Pourcen.Caption := FormatFloat('0%',
              ((Frm_Progression.prg_Progress.Position/Frm_Progression.prg_Progress.Max)*100));
    Application.ProcessMessages;
  end;
end;

procedure FermerPatienter;
begin
  if Assigned(Frm_Progression) then
  begin
    Frm_Progression.Free;
    Frm_Progression := nil;
  end;
end;
               
procedure TFrm_Progression.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  // intercept le close du bouton en haut à droite de la fenetre  
  if ((msg.CmdType and $FFF0) = SC_CLOSE) then begin  //ne pas fermer
    Msg.Result:=1;
    exit;
  end;

  inherited;
end;

initialization
  Frm_Progression := nil;

end.
