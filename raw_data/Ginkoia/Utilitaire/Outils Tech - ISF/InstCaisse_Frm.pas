unit InstCaisse_Frm;

interface

uses
   UInstall,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ExtCtrls, Buttons;

type
  TFrm_InstCaisse = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Lb_Magasin: TComboBox;
    Lb_Poste: TComboBox;
    Panel: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Lb_MagasinClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  public
    first: Boolean;
    Install: TInstall;
    NomDuPoste: string;
    procedure Initialisation;
    procedure OnMagasin(Sender: TObject; Magasin: string);
    procedure OnPoste(Sender: TObject; Poste: string);
  end;

var
   Frm_InstCaisse: TFrm_InstCaisse;

implementation

{$R *.DFM}

procedure TFrm_InstCaisse.FormCreate(Sender: TObject);
begin
  Install := TInstall.Create(Self);
  //  Install.Serveur := 'Pascal_Fix';
  first := true;
end;

procedure TFrm_InstCaisse.FormDestroy(Sender: TObject);
begin
  Install.Ferme;
  Install.free;
end;

procedure TFrm_InstCaisse.FormPaint(Sender: TObject);
begin
  if first then
  begin
     first := false;
     Update;
     Initialisation;
  end;
end;

procedure TFrm_InstCaisse.Initialisation;
begin
  Screen.Cursor := CrHourGlass;
  try
     Install.GetMagasinSurServeur;
     NomDuPoste := Install.GetNomPoste;
     Install.OuvreServeur;
     Install.OnNotifyMagasin := OnMagasin;
     Install.OnNotifyPoste := OnPoste;
     Lb_Magasin.Clear;
     Install.ListeMagasin;
     Lb_Poste.Clear;
     if Lb_Magasin.ItemIndex > -1 then
        Install.ListePoste(Lb_Magasin.Items[Lb_Magasin.ItemIndex]);
  finally
     Screen.Cursor := CrDefault;
  end;
end;

procedure TFrm_InstCaisse.Lb_MagasinClick(Sender: TObject);
begin
  Lb_Poste.Clear;
  if Lb_Magasin.ItemIndex > -1 then
     Install.ListePoste(Lb_Magasin.Items[Lb_Magasin.ItemIndex]);
end;

procedure TFrm_InstCaisse.OnMagasin(Sender: TObject; Magasin: string);
begin
  Lb_Magasin.Items.add(Magasin);
  if Magasin = Install.MagasinSurServeur then
     Lb_Magasin.ItemIndex := Lb_Magasin.Items.count - 1;
end;

procedure TFrm_InstCaisse.OnPoste(Sender: TObject; Poste: string);
begin
  Lb_poste.Items.add(Poste);
  if NomDuPoste = Poste then
     Lb_Poste.ItemIndex := Lb_poste.Items.count - 1;
end;

procedure TFrm_InstCaisse.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrm_InstCaisse.SpeedButton2Click(Sender: TObject);
begin
  if (Lb_Magasin.ItemIndex > -1) and
     (Lb_poste.ItemIndex > -1) then
  begin
    Install.SetPathBPL ;
    Install.CreerIniPoste(Lb_Magasin.items[Lb_Magasin.itemindex],Lb_Poste.items[Lb_Poste.itemindex]) ;
    Install.CreerIconPoste ;
    Close ;
  end;
end;

end.


