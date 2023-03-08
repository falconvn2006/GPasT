unit SuppressionDossier_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  // Uses perso
  MonitorStat_Dm,
  // Fin uses P
  Controls,
  Forms,
  Dialogs,
  RzButton, ExtCtrls, RzPanel, StdCtrls, RzLabel;

type
  TFrm_SuppressionDossier = class(TForm)
    Pan_fenetre: TRzPanel;
    Lab_suppression: TRzLabel;
    RzButton_Suppression: TRzButton;
    RzButton_Annuler: TRzButton;
    procedure FormShow(Sender: TObject);
    procedure RzButton_SuppressionClick(Sender: TObject);
    procedure RzButton_AnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_SuppressionDossier: TFrm_SuppressionDossier;

function VerifSuppression(Const ANom: string): boolean;

implementation

{$R *.dfm}

function VerifSuppression(Const ANom: string): boolean;
begin
  Result := false;
  Frm_SuppressionDossier := TFrm_SuppressionDossier.Create(nil);

  try
    Frm_SuppressionDossier.Caption := 'Suppréssion du dossier : ' + UpperCase(ANom);

    if Frm_SuppressionDossier.ShowModal = mrOk then
    begin
      Result := True;
    end;

  finally
    FreeAndNil(Frm_SuppressionDossier);
  end;

end;

procedure TFrm_SuppressionDossier.FormShow(Sender: TObject);
begin
  RzButton_Annuler.SetFocus;
  Lab_suppression.Caption := 'Voulez vous vraiment supprimer le dossier ?'
end;

procedure TFrm_SuppressionDossier.RzButton_AnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_SuppressionDossier.RzButton_SuppressionClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.

