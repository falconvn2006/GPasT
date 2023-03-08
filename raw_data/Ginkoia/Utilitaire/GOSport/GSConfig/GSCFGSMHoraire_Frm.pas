unit GSCFGSMHoraire_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, GSCFGMain_DM;

type
  TFrmHoraire = class(TForm)
    Pan_Bottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    Lab_Debut: TLabel;
    Lab_Fin: TLabel;
    Lab_Type: TLabel;
    dtp_Debut: TDateTimePicker;
    dtp_Fin: TDateTimePicker;
    Cbx_Type: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure dtp_DebutChange(Sender: TObject);
    procedure dtp_FinChange(Sender: TObject);
  private
    { Déclarations privées }
    FidHor : integer;
  public
    { Déclarations publiques }
  end;

function AddHoraire(AOwner : TComponent; out hdeb, hfin : TTime; out htype : integer) : boolean;
function EditHoraire(AOwner : TComponent; idHor : integer; var hdeb, hfin : TTime; var htype : integer) : boolean;

implementation

uses
  DB,
  DateUtils,
  Types;

{$R *.dfm}

function AddHoraire(AOwner : TComponent; out hdeb, hfin : TTime; out htype : integer) : boolean;
begin
  Result := false;
  with TFrmHoraire.Create(AOwner) do
  begin
    if ShowModal() = mrOK then
    begin
      hdeb := dtp_Debut.Time;
      hfin := dtp_Fin.Time;
      htype := Cbx_Type.ItemIndex +1;
      Result := true;
    end;
  end;
end;

function EditHoraire(AOwner : TComponent; idHor : integer; var hdeb, hfin : TTime; var htype : integer) : boolean;
begin
  with TFrmHoraire.Create(AOwner) do
  begin
    FidHor := idHor;
    dtp_Debut.Time := hdeb;
    dtp_Fin.Time := hfin;
    Cbx_Type.ItemIndex := htype -1;
    if ShowModal() = mrOK then
    begin
      hdeb := dtp_Debut.Time;
      hfin := dtp_Fin.Time;
      htype := Cbx_Type.ItemIndex +1;
      Result := true;
    end;
  end;
end;

procedure TFrmHoraire.dtp_DebutChange(Sender: TObject);
begin
  if dtp_Debut.Time >= dtp_Fin.Time then
    dtp_Fin.Time := IncHour(dtp_Debut.Time);
end;

procedure TFrmHoraire.dtp_FinChange(Sender: TObject);
begin
  if dtp_Fin.Time <= dtp_Debut.Time then
    dtp_Debut.Time := IncMinute(dtp_Fin.Time, -1);
end;

procedure TFrmHoraire.FormCreate(Sender: TObject);
begin
  FidHor := 0;
  dtp_Debut.DateTime := 0;
  dtp_Fin.DateTime := 0;
end;

procedure TFrmHoraire.Nbt_PostClick(Sender: TObject);
var
  bmk : TBookmark;
begin
  try
    // verification de remplissage
    if dtp_Debut.Time = 0 then
    begin
      ShowMessage('Vous devez saisir une date de debut.');
      dtp_Debut.SetFocus();
      Exit;
    end;
    if dtp_Fin.Time = 0 then
    begin
      ShowMessage('vous devez saisir une date de fin.');
      dtp_Debut.SetFocus();
      Exit;
    end;
    if Cbx_Type.ItemIndex < 0 then
    begin
      ShowMessage('vous devez saisir un type de traitement.');
      dtp_Debut.SetFocus();
      Exit;
    end;
    // verification du chevauchement des horaire
    bmk := FMain_DM.Que_Horaire.GetBookmark();
    FMain_DM.Que_Horaire.DisableControls();
    FMain_DM.Que_Horaire.First();
    while not FMain_DM.Que_Horaire.Eof do
    begin
      if not ((FidHor = FMain_DM.Que_Horaire.FieldByName('hor_id').AsInteger) or
              (dtp_Debut.DateTime >= FMain_DM.Que_Horaire.FieldByName('hor_hfin').AsDateTime) or
              (dtp_Fin.DateTime <= FMain_DM.Que_Horaire.FieldByName('hor_hdeb').AsDateTime)) then
      begin
        ShowMessage('Attention, les horaires ne doivent pas se chevaucher.');
        Exit;
      end;
      FMain_DM.Que_Horaire.Next();
    end;
    // si on arrive ici alors tt vas bien
    ModalResult := mrOK;
  finally
    FMain_DM.Que_Horaire.GotoBookmark(bmk);
    FMain_DM.Que_Horaire.FreeBookmark(bmk);
    FMain_DM.Que_Horaire.EnableControls();
  end;
end;

end.
