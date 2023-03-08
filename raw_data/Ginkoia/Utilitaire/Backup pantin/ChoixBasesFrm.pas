unit ChoixBasesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit_Backup;

type
  Tfrm_ChoixBases = class(TForm)
    Lbx_ChoixBases: TListBox;
    OK: TButton;
    Btn_Annuler: TButton;
  private
    { Déclarations privées }
    function GetBase(Idx : integer) : TuneBase;
    function GetSelected(Idx : integer) : boolean;
    function GetCount() : integer;
  public
    { Déclarations publiques }
    procedure Initialise(Liste : TListeBases);

    property Base[Idx : integer] : TuneBase read GetBase;
    property Selected[Idx : integer] : boolean read GetSelected;
    property Count : integer read GetCount;
  end;

implementation

{$R *.dfm}

{ Tfrm_ChoixBases }

function Tfrm_ChoixBases.GetBase(Idx : integer) : TuneBase;
begin
  Result := PUneBase(Pointer(Lbx_ChoixBases.Items.Objects[Idx]))^;
end;

function Tfrm_ChoixBases.GetSelected(Idx : integer) : boolean;
begin
  Result := Lbx_ChoixBases.Selected[Idx];
end;

function Tfrm_ChoixBases.GetCount() : integer;
begin
  Result := Lbx_ChoixBases.Items.Count;
end;

procedure Tfrm_ChoixBases.Initialise(Liste : TListeBases);
var
  i : integer;
begin
  Lbx_ChoixBases.Items.Clear();
  for i := 0 to Length(Liste) -1 do
    Lbx_ChoixBases.AddItem(Liste[i].LaBase, @Liste[i]);
end;

end.
