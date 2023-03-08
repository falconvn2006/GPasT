unit chxSender_frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFrm_ChxSender = class(TForm)
    Label1: TLabel;
    Lab_Machine: TLabel;
    ed_Sender: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ChxSender: TFrm_ChxSender;

implementation

{$R *.DFM}

procedure TFrm_ChxSender.BitBtn1Click(Sender: TObject);
begin
  IF ed_Sender.text='' then
     Application.MessageBox('Veuillez saisir un sender SVP','Erreur', mb_ok)
  else
    modalresult := mrok ;
end;

end.
