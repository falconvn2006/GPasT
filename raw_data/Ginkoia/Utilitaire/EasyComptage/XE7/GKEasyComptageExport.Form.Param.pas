unit GKEasyComptageExport.Form.Param;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.DateUtils,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Samples.Spin,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.FileCtrl,
  GKEasyComptageExport.Methodes;

type
  TFormParam = class(TForm)
    LblRepertoire: TLabel;
    TxtRepertoire: TEdit;
    BtnRepertoire: TBitBtn;
    RdgPeridodicite: TRadioGroup;
    LblHeure: TLabel;
    DtpHeure: TDateTimePicker;
    PnlBoutons: TPanel;
    BtnOk: TBitBtn;
    BtnAnnuler: TBitBtn;
    LblMinutes: TLabel;
    SpnMinutes: TSpinEdit;
    LblMinutes2: TLabel;
    LblJours: TLabel;
    SpnJours: TSpinEdit;
    LblJours2: TLabel;
    BvlSeparation: TBevel;
    GrbAuto: TGroupBox;
    ChkDemarrage: TCheckBox;
    ChkArret: TCheckBox;
    DtpDemarrage: TDateTimePicker;
    DtpArret: TDateTimePicker;
    BtnTachePlanifiee: TButton;
    LblInformation: TLabel;
    LblIconeInfo: TLabel;
    procedure RdgPeridodiciteClick(Sender: TObject);
    procedure BtnTachePlanifieeClick(Sender: TObject);
    procedure ChkDemarrageClick(Sender: TObject);
    procedure ChkArretClick(Sender: TObject);
    procedure BtnRepertoireClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormParam: TFormParam;

implementation

{$R *.dfm}

procedure TFormParam.BtnRepertoireClick(Sender: TObject);
var
  sDossier: string;
begin
  sDossier := TxtRepertoire.Text;
  if SelectDirectory('', '', sDossier,
    [sdNewFolder, sdShowEdit, sdShowShares, sdNewUI, sdValidateDir], Self) then
    TxtRepertoire.Text  := sDossier;
end;

procedure TFormParam.BtnTachePlanifieeClick(Sender: TObject);
begin
  // Créer le démarrage auto
  CreerDemarrageAuto();
end;

procedure TFormParam.ChkArretClick(Sender: TObject);
begin
  DtpArret.Enabled      := ChkArret.Checked;
end;

procedure TFormParam.ChkDemarrageClick(Sender: TObject);
begin
  DtpDemarrage.Enabled        := ChkDemarrage.Checked;
  BtnTachePlanifiee.Enabled   := ChkDemarrage.Checked;
end;

procedure TFormParam.FormCreate(Sender: TObject);
begin
  LblIconeInfo.Visible    := (FindCmdLineSwitch('PARAM') and (MinutesBetween(HeureLancement, Now()) < 15));
  LblInformation.Visible  := (FindCmdLineSwitch('PARAM') and (MinutesBetween(HeureLancement, Now()) < 15));
end;

procedure TFormParam.RdgPeridodiciteClick(Sender: TObject);
begin
  // Active les composants nécessaires
  LblHeure.Enabled    := (RdgPeridodicite.ItemIndex = 0);
  DtpHeure.Enabled    := (RdgPeridodicite.ItemIndex = 0);
  LblMinutes.Enabled  := (RdgPeridodicite.ItemIndex = 1);
  SpnMinutes.Enabled  := (RdgPeridodicite.ItemIndex = 1);
  LblMinutes2.Enabled := (RdgPeridodicite.ItemIndex = 1);
end;

end.
