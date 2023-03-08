unit ChoixKVersion_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPlage = record
    _Start : Integer;
    _End : Integer;
  end;
  TFrm_ChoixKVersion = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtStart: TEdit;
    Label2: TLabel;
    edtEnd: TEdit;
    btnValider: TButton;
    procedure btnValiderClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;
  function Show(aPlage : TPlage)  : TPlage;
var
  Frm_ChoixKVersion: TFrm_ChoixKVersion;

implementation

{$R *.dfm}

function Show(aPlage: TPlage): TPlage;
begin
  result := aPlage;
  Frm_ChoixKVersion := TFrm_ChoixKVersion.Create(nil);
  Frm_ChoixKVersion.edtStart.Text := IntToStr(result._Start);
  Frm_ChoixKVersion.edtEnd.Text := IntToStr(result._End);
  if Frm_ChoixKVersion.ShowModal = mrOk then
  begin
    result._Start := StrToIntDef(Frm_ChoixKVersion.edtStart.Text, aPlage._Start);
    result._End := StrToIntDef(Frm_ChoixKVersion.edtEnd.Text, aPlage._End);
  end;
end;


{ TFrm_ChoixKVersion }


procedure TFrm_ChoixKVersion.btnValiderClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
