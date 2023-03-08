unit OCMAGUpdate_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, AlgolDialogForms,
  Dialogs, AdvGlowButton, StdCtrls, RzLabel, ExtCtrls, RzPanel, ComCtrls;

type
  Tfrm_OCMAGUpdate = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_Ou: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Gbx_Bottom: TGroupBox;
    Lab_Debut: TLabel;
    Lab_Fin: TLabel;
    dtp_Debut: TDateTimePicker;
    Dtp_Fin: TDateTimePicker;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
  private
    function FGetDateDebut : TDate;
    function FGetDateFin : TDate;
    { Déclarations privées }
  public
    { Déclarations publiques }
  published
    property DateDebut : TDate read FGetDateDebut;
    property DateFin : TDate read FGetDateFin;
  end;

var
  frm_OCMAGUpdate: Tfrm_OCMAGUpdate;

implementation

{$R *.dfm}

{ Tfrm_OCMAGUpdate }

procedure Tfrm_OCMAGUpdate.AlgolDialogFormCreate(Sender: TObject);
begin
  dtp_Debut.Date := Now;
  Dtp_Fin.Date := Now;
end;

function Tfrm_OCMAGUpdate.FGetDateDebut: TDate;
begin
  Result := dtp_Debut.Date;
end;

function Tfrm_OCMAGUpdate.FGetDateFin: TDate;
begin
  Result := Dtp_Fin.Date;
end;

procedure Tfrm_OCMAGUpdate.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_OCMAGUpdate.Nbt_PostClick(Sender: TObject);
begin
 if dtp_Debut.Date > Dtp_Fin.Date then
 begin
   ShowMessage('La date de début doit être inférieure à celle de fin');
   Exit;
 end;


 ModalResult := mrOk;
end;

end.
