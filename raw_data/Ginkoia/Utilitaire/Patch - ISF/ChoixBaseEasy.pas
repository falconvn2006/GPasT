unit ChoixBaseEasy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrm_ChoixBase = class(TForm)
    lblChoixBase: TLabel;
    cbDossiers: TComboBox;
    btnValider: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnValiderClick(Sender: TObject);
    procedure cbDossiersKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

uses
  UGUID, ClassDossier;

{$R *.dfm}


//Traitement_Databases_EASY_PAR_MAINTENANCE(aDossID:integer = 0);

procedure TFrm_ChoixBase.btnValiderClick(Sender: TObject);
var
  SelectedID: integer;
  SelectedDossier: string;
begin
  // on masque cette form pendant le traitement pour qu'on voit ce qui se passe sur la form principale
  Self.Hide;

  // on récupère le dossID à traiter et on le passe à la fonction de traitement
  if cbDossiers.ItemIndex <> -1 then
  begin

    SelectedDossier := Tdossier(cbDossiers.Items.Objects[cbDossiers.ItemIndex]).Nom;
    SelectedID := Tdossier(cbDossiers.Items.Objects[cbDossiers.ItemIndex]).DOSS_ID;

    Form1.Traitement_Databases_EASY_PAR_MAINTENANCE(SelectedID);
  end;

  ModalResult := mrOk;
end;

procedure TFrm_ChoixBase.cbDossiersKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
  begin
    btnValiderClick(Self);
  end;
end;

procedure TFrm_ChoixBase.FormCreate(Sender: TObject);
var
  vDossiers: TDossiers;
  i: integer;
begin
  FichierLog := 'GUID_Easy.log';

  // on récupère la liste des dossiers EASY et on remplit le combobox
  vDossiers := Form1.LoadBaseMaintenance_Easy();

  for i := 0 to vDossiers.Count - 1 do
  begin
    cbDossiers.AddItem(TDossier(vDossiers.Items[i]).Nom, vDossiers.Items[i]);
  end;
end;

end.

