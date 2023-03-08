unit uTestVisu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls;

type
  TFrmVisu = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    lblCompteur: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    FCompteur: Integer;
  public
    { Déclarations publiques }
    procedure AddRow(const ISR_CID, CID, marketing, civilite, nom, prenom, pays, adresse, codePostal, ville, email: string);
  end;

var
  FrmVisu: TFrmVisu;

implementation

{$R *.dfm}

procedure TFrmVisu.AddRow(const ISR_CID, CID, marketing, civilite, nom, prenom,
  pays, adresse, codePostal, ville, email: string);
var
  i: Integer;
begin
  FCompteur := FCompteur + 1;
  if FCompteur < 20 then
  begin
    i := StringGrid1.RowCount;
    StringGrid1.RowCount := i + 1;
    StringGrid1.Cells[0, i] := ISR_CID;
    StringGrid1.Cells[1, i] := CID;
    StringGrid1.Cells[2, i] := marketing;
    StringGrid1.Cells[3, i] := civilite;
    StringGrid1.Cells[4, i] := nom;
    StringGrid1.Cells[5, i] := prenom;
    StringGrid1.Cells[6, i] := pays;
    StringGrid1.Cells[7, i] := adresse;
    StringGrid1.Cells[8, i] := codePostal;
    StringGrid1.Cells[9, i] := ville;
    StringGrid1.Cells[10, i] := email;
  end;
  lblCompteur.Caption := IntToStr(FCompteur);
end;

procedure TFrmVisu.FormCreate(Sender: TObject);
begin
  FCompteur := 0;
  StringGrid1.ColCount := 11;
  StringGrid1.RowCount := 1;
  StringGrid1.Cells[0, 0] := 'ISR_CID';
  StringGrid1.Cells[1, 0] := 'CID';
  StringGrid1.Cells[2, 0] := 'marketing';
  StringGrid1.Cells[3, 0] := 'civilite';
  StringGrid1.Cells[4, 0] := 'nom';
  StringGrid1.Cells[5, 0] := 'prenom';
  StringGrid1.Cells[6, 0] := 'pays';
  StringGrid1.Cells[7, 0] := 'adresse';
  StringGrid1.Cells[8, 0] := 'codePostal';
  StringGrid1.Cells[9, 0] := 'ville';
  StringGrid1.Cells[10,0] := 'email';
end;

end.
