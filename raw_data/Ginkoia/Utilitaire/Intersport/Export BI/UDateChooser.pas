unit UDateChooser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  Tfrm_DateChooser = class(TForm)
    Lab_Date: TLabel;
    dtp_Date: TDateTimePicker;
    Btn_Cancel: TButton;
    Btn_OK: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function SelectDate(out Selected : TDate) : boolean;

implementation

{$R *.dfm}

function SelectDate(out Selected : TDate) : boolean;
var
  Fiche : Tfrm_DateChooser;
begin
  try
    Fiche := Tfrm_DateChooser.Create(nil);
    Result := Fiche.ShowModal() = mrOK;
    Selected := Fiche.dtp_Date.Date
  finally
    FreeAndNil(Fiche)
  end;
end;

{ Tfrm_DateChooser }

procedure Tfrm_DateChooser.FormCreate(Sender: TObject);
begin
  dtp_Date.Date := Trunc(Now());
end;

end.
