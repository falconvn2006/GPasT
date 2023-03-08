unit UProgression_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxProgressBar, StdCtrls, RzLabel, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue, StrUtils;

type
  TFrm_Progression = class(TForm)
    Lab_Tache: TRzLabel;
    Lab_TacheNom: TRzLabel;
    Prg_Tache: TcxProgressBar;
    Lab_Traitement: TLabel;
    Prg_Traitement: TcxProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FNbTaches: integer;
  public
    procedure InitialiserTraitement( ANbTaches: Integer );
    procedure InitialiserTache( const ANomTache: string; ANbIncrements: Integer );
    procedure ProgresserTache;
  end;

var
  Frm_Progression: TFrm_Progression;

implementation
{$R *.dfm}

procedure TFrm_Progression.InitialiserTraitement( ANbTaches: Integer );
begin
  // intialiser nombre de tâches
  FNbTaches := ANbTaches;
  // initialiser barres de progression
  Prg_Tache.Position := 0;
  Prg_Traitement.Position := 0;
  Prg_Traitement.Properties.Max := FNbTaches;
  // afficher fenêtre
  Show;
end;

procedure TFrm_Progression.InitialiserTache( const ANomTache: string; ANbIncrements: Integer );
begin
  // afficher nom tâche
  Lab_TacheNom.Caption := LeftStr( ANomTache, 50 ) + '...';
  // ré-intialiser barre progression tâche
  Prg_Tache.Position := 0;
  Prg_Tache.Properties.Max := ANbIncrements;
  // afficher progression
  Update;
  Application.ProcessMessages;
end;

procedure TFrm_Progression.ProgresserTache;
begin
  // avancer barre de progression tâche
  Prg_Tache.Position := Prg_Tache.Position + 1;
  // avancer barre de progression traitement (en % d'avancement de la tâche / nombre total de tâches)
//  Prg_Traitement.Position := Prg_Traitement.Position + ( Prg_Tache.Position / Prg_Tache.Properties.PeakValue / FNbTaches );
  if Prg_Tache.Position >= Prg_Tache.Properties.Max then
  begin
    Prg_Traitement.Position := Prg_Traitement.Position + 1;
    Prg_Tache.Position := 0;
    Lab_TacheNom.Caption := 'Traitement en cours...';
  end;
  // afficher progression
  Update;
  Application.ProcessMessages;
end;

procedure TFrm_Progression.FormCreate(Sender: TObject);
begin
  // initialiser libellé tâche et barres de progression
  Lab_TacheNom.Caption := '';
  Prg_Tache.Position := 0;
  Prg_Traitement.Position := 0;
  if not Prg_Traitement.Visible then
  begin
    Frm_Progression.Height := 100;
  end;
end;

procedure TFrm_Progression.FormShow(Sender: TObject);
begin
  // curseur en attente
  Screen.Cursor := crSQLWait;
end;

procedure TFrm_Progression.FormHide(Sender: TObject);
begin
  // curseur par défaut
  Screen.Cursor := crDefault;
end;

end.
