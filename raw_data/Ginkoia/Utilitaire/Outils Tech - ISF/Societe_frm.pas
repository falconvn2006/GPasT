unit Societe_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TFrm_Societe = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    ed_Nom: TEdit;
    Edt_Date: TDateTimePicker;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Societe: TFrm_Societe;

implementation

{$R *.DFM}

end.
