unit DateLimit_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TFrm_DateLimit = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Chp_Date: TDateTimePicker;
    Bevel1: TBevel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_DateLimit: TFrm_DateLimit;

implementation

{$R *.dfm}

procedure TFrm_DateLimit.BitBtn1Click(Sender: TObject);
begin
  if Chp_Date.Date>=Trunc(Date) then
  begin
    MessageDlg('Date trop grande !',mterror,[mbok],0);
    ModalResult := mrnone;
    exit;
  end;
end;

end.
