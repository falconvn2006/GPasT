unit Version_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrm_Version = class(TForm)
    Lab_Version: TLabel;
    cbx_Version: TComboBox;
    Btn_Valider: TButton;
    Btn_Annuler: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function SelectVersion(Versions : TStringList) : string;  

implementation

{$R *.dfm}

function SelectVersion(Versions : TStringList) : string;
var
  Fiche : TFrm_Version;
begin
  Result := '';
  try
    Fiche := TFrm_Version.Create(nil);
    Fiche.cbx_Version.Items.AddStrings(Versions);
    if Fiche.ShowModal() = mrOk then
      Result := Fiche.cbx_Version.Items[Fiche.cbx_Version.ItemIndex]
  finally
    FreeAndNil(Fiche);
  end;
end;

end.
