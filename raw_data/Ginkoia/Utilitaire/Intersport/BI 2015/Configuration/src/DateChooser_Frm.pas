unit DateChooser_Frm;

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
  Vcl.ExtCtrls;

type
  Tfrm_DateChooser = class(TForm)
    Lab_Date: TLabel;
    Btn_Cancel: TButton;
    Btn_OK: TButton;
    pnl_DateInit: TGridPanel;
    dtp_Date: TDateTimePicker;
    dtp_Time: TDateTimePicker;

    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  protected
    function GetSelected() : TDateTime;
    procedure SetSelected(Value : TDateTime);
  public
    { Déclarations publiques }
    property Selected : TDateTime read GetSelected write SetSelected;
  end;

function SelectDate(var Selected : TDateTime) : boolean;

implementation

uses
  System.DateUtils;

{$R *.dfm}

function SelectDate(var Selected : TDateTime) : boolean;
var
  Fiche : Tfrm_DateChooser;
begin
  Result := false;
  try
    Fiche := Tfrm_DateChooser.Create(nil);
    if Selected > 2 then
      Fiche.Selected := Selected;
    if Fiche.ShowModal() = mrOK then
    begin
      Selected := Fiche.Selected;
      Result := Selected > 2;
    end;
  finally
    FreeAndNil(Fiche)
  end;
end;

{ Tfrm_DateChooser }

procedure Tfrm_DateChooser.FormCreate(Sender: TObject);
begin
  dtp_Date.Date := Trunc(Now());
  dtp_Time.Time := Frac(Now());
end;

function Tfrm_DateChooser.GetSelected() : TDateTime;
begin
  Result := Trunc(dtp_Date.Date) + Frac(dtp_Time.Time);
end;

procedure Tfrm_DateChooser.SetSelected(Value : TDateTime);
begin
  if Value = 0 then
    Value := IncMilliSecond(Value, 1);
  dtp_Date.Date := Trunc(Value);
  dtp_Time.Time := Frac(Value);
end;

end.
