unit TrtChooser_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Samples.Spin;

type
  Tfrm_TrtChooser = class(TForm)
    pnl_DateInit: TGridPanel;
    Lab_Date: TLabel;
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    GroupBox1: TGroupBox;
    chk_HasDate: TCheckBox;
    dtp_Date: TDateTimePicker;
    dtp_Time: TDateTimePicker;
    rb_Selection: TRadioButton;
    rb_Commande: TRadioButton;
    edt_Commande: TEdit;
    chk_Magasins: TCheckBox;
    chk_Articles: TCheckBox;
    chk_Tickets: TCheckBox;
    chk_Factures: TCheckBox;
    chk_Mouvements: TCheckBox;
    chk_HistoStk: TCheckBox;
    chk_ResetStk: TCheckBox;
    pnl_Accolade: TPanel;
    chk_LogForce: TCheckBox;
    chk_Reinit: TCheckBox;
    pnl_Sep: TPanel;
    chk_Commandes: TCheckBox;
    chk_Receptions: TCheckBox;
    chk_Retours: TCheckBox;
    chk_Reexport: TCheckBox;
    chk_Fournisseurs: TCheckBox;
    chk_Exercices: TCheckBox;
    chk_Collections: TCheckBox;
    chk_ReMouvemente: TCheckBox;
    pnl_ReMouvemente: TPanel;
    dtp_ReMouvemente: TDateTimePicker;
    se_ReMouvemente: TSpinEdit;

    procedure FormCreate(Sender: TObject);

    procedure chk_HasDateClick(Sender: TObject);
    procedure RadionBoutonChange(Sender: TObject);
    procedure CheckBoxChange(Sender: TObject);
    procedure edt_CommandeChange(Sender: TObject);
  private
    { Déclarations privées }
  protected
    function GetTraitement() : string;
    procedure SetTraitement(Value : string);
    function GetDateTrt() : TDateTime;
    procedure SetDateTrt(Value : TDateTime);
  public
    { Déclarations publiques }
    property Traitement : string read GetTraitement write SetTraitement;
    property DateTrt : TDateTime read GetDateTrt write SetDateTrt;
  end;

function SelectTraitement(var Traitement : string; var DateTrt : TDateTime) : boolean;

implementation

uses
  System.DateUtils,
  System.Math;

{$R *.dfm}

function SelectTraitement(var Traitement : string; var DateTrt : TDateTime) : boolean;
var
  Fiche : Tfrm_TrtChooser;
begin
  Result := false;
  try
    Fiche := Tfrm_TrtChooser.Create(nil);
    if not (Trim(Traitement) = '') then
      Fiche.Traitement := Traitement;
    if DateTrt > 2 then
      Fiche.DateTrt := DateTrt;
    if Fiche.ShowModal() = mrOK then
    begin
      Traitement := Fiche.Traitement;
      DateTrt := Fiche.DateTrt;
      Result := not (Trim(Traitement) = '');
    end;
  finally
    FreeAndNil(Fiche)
  end;
end;

{ Tfrm_TrtChooser }

procedure Tfrm_TrtChooser.FormCreate(Sender: TObject);
begin
  chk_HasDate.Checked := false;
end;

procedure Tfrm_TrtChooser.chk_HasDateClick(Sender: TObject);
begin
  if chk_HasDate.Checked then
  begin
    dtp_Date.Date := Trunc(Now());
    dtp_Time.Time := Frac(Now());
  end
  else
  begin
    dtp_Date.Date := 0;
    dtp_Time.Time := EncodeTime(0, 0, 0, 1);;
  end;
end;

procedure Tfrm_TrtChooser.RadionBoutonChange(Sender: TObject);
begin
  edt_Commande.ReadOnly := rb_Selection.Checked;

  chk_Magasins.Enabled := rb_Selection.Checked;
  chk_Exercices.Enabled := rb_Selection.Checked;
  chk_Collections.Enabled := rb_Selection.Checked;
  chk_Articles.Enabled := rb_Selection.Checked;
  chk_Fournisseurs.Enabled := rb_Selection.Checked;

  chk_Tickets.Enabled := rb_Selection.Checked;
  chk_Factures.Enabled := rb_Selection.Checked;
  chk_Mouvements.Enabled := rb_Selection.Checked;
  chk_Commandes.Enabled := rb_Selection.Checked;
  chk_Receptions.Enabled := rb_Selection.Checked;
  chk_Retours.Enabled := rb_Selection.Checked;

  chk_Reinit.Enabled := (chk_Articles.Checked or chk_Fournisseurs.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked) and not (chk_Reexport.Checked or chk_ReMouvemente.Checked);
  chk_Reexport.Enabled := (chk_Articles.Checked or chk_Fournisseurs.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked) and not (chk_Reinit.Checked or chk_ReMouvemente.Checked);
  chk_ReMouvemente.Enabled := (chk_Articles.Checked or chk_Fournisseurs.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked) and not (chk_Reinit.Checked or chk_Reexport.Checked);
  dtp_ReMouvemente.Enabled := chk_ReMouvemente.Enabled;
  se_ReMouvemente.Enabled := chk_ReMouvemente.Enabled;

  chk_HistoStk.Enabled := rb_Selection.Checked;
  chk_ResetStk.Enabled := rb_Selection.Checked;

  chk_LogForce.Enabled := rb_Selection.Checked;
end;

procedure Tfrm_TrtChooser.CheckBoxChange(Sender: TObject);
var
  tmpCommande : string;
begin
  if rb_Selection.Checked then
  begin
    // activation...
    chk_Reinit.Enabled := (chk_Articles.Checked or chk_Fournisseurs.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked) and not (chk_Reexport.Checked or chk_ReMouvemente.Checked);
    if not chk_Reinit.Enabled then
      chk_Reinit.Checked := false;
    chk_Reexport.Enabled := (chk_Articles.Checked or chk_Fournisseurs.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked) and not (chk_Reinit.Checked or chk_ReMouvemente.Checked);
    if not chk_Reexport.Enabled then
      chk_Reexport.Checked := false;
    chk_ReMouvemente.Enabled := (chk_Articles.Checked or chk_Fournisseurs.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked) and not (chk_Reinit.Checked or chk_Reexport.Checked);
    if not chk_ReMouvemente.Enabled then
      chk_ReMouvemente.Checked := false;

    chk_LogForce.Enabled := not (chk_Magasins.Checked or chk_Exercices.Checked or chk_Collections.Checked or chk_Articles.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked  or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked or chk_HistoStk.Checked or chk_ResetStk.Checked);
    if not chk_LogForce.Enabled then
      chk_LogForce.Checked := false;

    // construction de la chaine
    tmpCommande := '';
    if chk_Magasins.Checked then
      tmpCommande := tmpCommande + ' -GestionMagasins';
    if chk_Exercices.Checked then
      tmpCommande := tmpCommande + ' -GestionExercices';
    if chk_Collections.Checked then
      tmpCommande := tmpCommande + ' -GestionCollections';
    if chk_Fournisseurs.Checked then
      tmpCommande := tmpCommande + ' -GestionFournisseurs';

    if chk_Articles.Checked then
      tmpCommande := tmpCommande + ' -CompletArticles';
    if chk_Tickets.Checked then
      tmpCommande := tmpCommande + ' -CompletTickets';
    if chk_Factures.Checked then
      tmpCommande := tmpCommande + ' -CompletFactures';
    if chk_Mouvements.Checked then
      tmpCommande := tmpCommande + ' -CompletMouvements';
    if chk_Commandes.Checked then
      tmpCommande := tmpCommande + ' -CompletCommandes';
    if chk_Receptions.Checked then
      tmpCommande := tmpCommande + ' -CompletReceptions';
    if chk_Retours.Checked then
      tmpCommande := tmpCommande + ' -CompletRetours';

    if chk_Reinit.Checked then
      tmpCommande := tmpCommande + ' -ReInitialisation';
    if chk_Reexport.Checked then
      tmpCommande := tmpCommande + ' -ReExport';
    if chk_ReMouvemente.Checked then
    begin
      if not dtp_ReMouvemente.Enabled then
      begin
        dtp_ReMouvemente.Enabled := true;
        dtp_ReMouvemente.Date := Trunc(Date());
      end;
      if not se_ReMouvemente.Enabled then
      begin
        se_ReMouvemente.Enabled := true;
        se_ReMouvemente.Value := 1;
      end;
      tmpCommande := tmpCommande + ' -ReMouvement:' + FormatDateTime('yyyy-mm-dd', dtp_ReMouvemente.Date) + '|' + IntToStr(se_ReMouvemente.Value);
    end
    else
    begin
      dtp_ReMouvemente.Enabled := false;
      dtp_ReMouvemente.Date := IncSecond(0);
      se_ReMouvemente.Enabled := false;
      se_ReMouvemente.Value := 1;
    end;

    if chk_HistoStk.Checked then
      tmpCommande := tmpCommande + ' -HistoStock';
    if chk_ResetStk.Checked then
      tmpCommande := tmpCommande + ' -ResetStock';

    if chk_LogForce.Checked then
      tmpCommande := tmpCommande + ' -LogForce';

    edt_Commande.Text := Trim(tmpCommande);
  end;
end;

procedure Tfrm_TrtChooser.edt_CommandeChange(Sender: TObject);
var
  posRM, posPipe : integer;
begin
  if rb_Commande.Checked then
  begin
    chk_Magasins.Checked := Pos('-GestionMagasins', edt_Commande.Text) > 0;
    chk_Exercices.Checked := Pos('-GestionExercices', edt_Commande.Text) > 0;
    chk_Collections.Checked := Pos('-GestionCollections', edt_Commande.Text) > 0;
    chk_Fournisseurs.Checked := Pos('-GestionFournisseurs', edt_Commande.Text) > 0;

    chk_Articles.Checked := Pos('-CompletArticles', edt_Commande.Text) > 0;
    chk_Tickets.Checked := Pos('-CompletTickets', edt_Commande.Text) > 0;
    chk_Factures.Checked := Pos('-CompletFactures', edt_Commande.Text) > 0;
    chk_Mouvements.Checked := Pos('-CompletMouvements', edt_Commande.Text) > 0;
    chk_Commandes.Checked := Pos('-CompletCommandes', edt_Commande.Text) > 0;
    chk_Receptions.Checked := Pos('-CompletReceptions', edt_Commande.Text) > 0;
    chk_Retours.Checked := Pos('-CompletRetours', edt_Commande.Text) > 0;

    chk_Reinit.Checked := Pos('-ReInitialisation', edt_Commande.Text) > 0;
    chk_Reexport.Checked := Pos('-ReExport', edt_Commande.Text) > 0;
    posRM := Pos('-ReMouvement', edt_Commande.Text);
    if posRM > 0 then
    begin
      chk_ReMouvemente.Checked := true;
      posPipe := Pos('|', edt_Commande.Text, posRM);
      dtp_ReMouvemente.Date := ISO8601ToDate(Copy(edt_Commande.Text, posRM +13, posPipe - (PosRM +13)));
      se_ReMouvemente.Value := StrToIntDef(Copy(edt_Commande.Text, posPipe +1, Max(1, Pos(' ', edt_Commande.Text, posPipe))), 1);
    end
    else
      chk_ReMouvemente.Checked := false;

    chk_HistoStk.Checked := Pos('-HistoStock', edt_Commande.Text) > 0;
    chk_ResetStk.Checked := Pos('-ResetStock', edt_Commande.Text) > 0;
    chk_LogForce.Checked := Pos('-LogForce', edt_Commande.Text) > 0;
  end;
end;

function Tfrm_TrtChooser.GetTraitement() : string;
begin
  Result := edt_Commande.Text;
end;

procedure Tfrm_TrtChooser.SetTraitement(Value : string);
begin
  if not (edt_Commande.Text = Value) then
  begin
    rb_Commande.Checked := true;
    edt_Commande.Text := Value;
  end;
end;

function Tfrm_TrtChooser.GetDateTrt() : TDateTime;
begin
  if chk_HasDate.Checked then
    Result := Trunc(dtp_Date.Date) + Frac(dtp_Time.Time)
  else
    Result := 0;
end;

procedure Tfrm_TrtChooser.SetDateTrt(Value : TDateTime);
begin
  if Value = 0 then
  begin
    chk_HasDate.Checked := false;
    dtp_Date.Date := 0;
    dtp_Time.Time := EncodeTime(0, 0, 0, 1);
  end
  else
  begin
    chk_HasDate.Checked := true;
    dtp_Date.Date := Trunc(Value);
    dtp_Time.Time := Frac(Value);
  end;
end;

end.
