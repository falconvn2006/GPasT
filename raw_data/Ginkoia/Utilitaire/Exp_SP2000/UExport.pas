unit UExport;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  Tfrm_Export = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ed_Nom: TEdit;
    Label1: TLabel;
    Chk_Commande: TRadioButton;
    Chk_vente: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Label5: TLabel;
    Chk_Oui: TRadioButton;
    Chk_Non: TRadioButton;
    Dte_Debut: TDateTimePicker;
    Dte_Fin: TDateTimePicker;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Export: Tfrm_Export;

implementation

{$R *.DFM}

end.
