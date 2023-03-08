unit MotDePasse_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, RzPanel, RzLabel;

type
  TFrm_MotDePasse = class(TForm)
    Lab_pass: TRzLabel;
    Pan_bas: TRzPanel;
    Nbt_Ok: TLMDButton;
    Nbt_Cancel: TLMDButton;
    Chp_Pass: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_OkEnter(Sender: TObject);
    procedure Nbt_OkExit(Sender: TObject);
    procedure Nbt_OkClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_MotDePasse: TFrm_MotDePasse;

implementation

{$R *.dfm}

procedure TFrm_MotDePasse.FormCreate(Sender: TObject);
begin
  Chp_Pass.Text := '';
end;

procedure TFrm_MotDePasse.Nbt_OkClick(Sender: TObject);
begin
  if Chp_Pass.Text <> '1082' then begin
    MessageDlg('Mot de passe invalide !', mterror, [mbok], 0);
    ModalResult := mrnone;
    Chp_Pass.Text := '';
    Chp_Pass.SetFocus;
    exit;
  end;
end;

procedure TFrm_MotDePasse.Nbt_OkEnter(Sender: TObject);
begin
  if not (fsBold in TLMDButton(Sender).Font.Style) then
    TLMDButton(Sender).Font.Style := TLMDButton(Sender).Font.Style + [fsBold];
end;

procedure TFrm_MotDePasse.Nbt_OkExit(Sender: TObject);
begin
  if (fsBold in TLMDButton(Sender).Font.Style) then
    TLMDButton(Sender).Font.Style := TLMDButton(Sender).Font.Style - [fsBold];
end;

end.

