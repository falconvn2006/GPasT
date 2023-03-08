unit AjoutModifGrpPump_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvGlowButton, ExtCtrls, RzPanel;

type
  TFrom_AjoutModifGrpPump = class(TForm)
    Label1: TLabel;
    ENom: TEdit;
    Pan_Bottom: TRzPanel;
    btn_Valid: TAdvGlowButton;
    btn_Annul: TAdvGlowButton;
    procedure btn_ValidClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure InitEcr(ANomGroupe: string);
  end;

var
  From_AjoutModifGrpPump: TFrom_AjoutModifGrpPump;

implementation

{$R *.dfm}

{ TFrom_AjoutModifGrpPump }

procedure TFrom_AjoutModifGrpPump.btn_ValidClick(Sender: TObject);
begin
  if Trim(ENom.Text)='' then
  begin
    MessageDlg('Nom obligatoire !', mterror,[mbok],0);
    ModalResult := mrnone;
    exit;
  end;
  ModalResult := mrok;
end;

procedure TFrom_AjoutModifGrpPump.InitEcr(ANomGroupe: string);
begin
  if Trim(ANomGroupe)='' then
    Caption := 'Ajouter un groupe'
  else
    Caption := 'Modifier un groupe';
  ENom.Text := ANomGroupe;
end;

end.
