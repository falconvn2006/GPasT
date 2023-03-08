unit AddRep_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrm_AddRep = class(TForm)
    Lab_NewRep: TLabel;
    Edt_NewRep: TEdit;
    Nbt_NewRep: TSpeedButton;
    Btn_Valider: TButton;
    Btn_Annuler: TButton;
    procedure Edt_NewRepChange(Sender: TObject);
    procedure Nbt_NewRepClick(Sender: TObject);
  private
    { Déclarations privées }
    function GetNewRep() : string;
    procedure SetNewRep(value : string);
  public
    { Déclarations publiques }
    property NewRep : string read GetNewRep write SetNewRep;
  end;

function GetNewRep(AOwner : TComponent; out NewRep : string) : boolean;

implementation

uses
  BrowseForFolderU;

{$R *.dfm}

function GetNewRep(AOwner : TComponent; out NewRep : string) : boolean;
var
  Fiche : TFrm_AddRep;
begin
  Result := false;
  try
    Fiche := TFrm_AddRep.Create(AOwner);
    Fiche.NewRep := NewRep;
    if Fiche.ShowModal() = mrOk then
    begin
      NewRep := Fiche.NewRep;
      if not (Trim(NewRep) = '') then
        Result := true;
    end;
  finally
    FreeAndNil(Fiche);
  end;
end;

{ TFrm_AddRep }

procedure TFrm_AddRep.Edt_NewRepChange(Sender: TObject);
begin
  Btn_Valider.Enabled := DirectoryExists(Edt_NewRep.Text);
end;

procedure TFrm_AddRep.Nbt_NewRepClick(Sender: TObject);
var
  tmpRep : string;
begin
  tmpRep := BrowseForFolder('Séléctionnez un repertoire', Edt_NewRep.Text, true);
  if not (Trim(tmpRep) = '') then
  begin
    Edt_NewRep.Text := '';
    Edt_NewRep.Text := tmpRep;
  end;
end;

function TFrm_AddRep.GetNewRep() : string;
begin
  Result := Edt_NewRep.Text;
end;

procedure TFrm_AddRep.SetNewRep(value : string);
begin
  Edt_NewRep.Text := value;
end;

end.
