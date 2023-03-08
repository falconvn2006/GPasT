unit MajStk_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TFrm_MajStk = class(TForm)
    Lab_Etat: TLabel;
    Lab_Duree: TLabel;
    pb_Etat: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    OkFermer: boolean;
    procedure DoInit;
  end;

var
  Frm_MajStk: TFrm_MajStk;

implementation

uses
  Main_Frm;

{$R *.dfm}

procedure TFrm_MajStk.WMSysCommand(var Msg: TWMSysCommand);
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

procedure TFrm_MajStk.DoInit;
begin
  Lab_Etat.Caption := '';
  Lab_Duree.Caption := '';
  pb_Etat.Position := 0;
end;

procedure TFrm_MajStk.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Frm_Main.Enabled := True;
end;

procedure TFrm_MajStk.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := OkFermer;
  if not(OkFermer) then
  begin
    Application.Minimize;
    Application.ProcessMessages;
  end;
end;

procedure TFrm_MajStk.FormCreate(Sender: TObject);
begin
  OkFermer := true;
end;

end.
