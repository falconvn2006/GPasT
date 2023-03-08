unit messagebox_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, ExtCtrls, RzPanel;

type
  TFmessagebox = class(TForm)
    Pan_Fond: TRzPanel;
    Pan_Btn: TRzPanel;
    Nbt_Ok: TLMDSpeedButton;
    Pan_Text: TRzPanel;
    Memo_Mess: TRzLabel;
    procedure Nbt_OkClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Fmessagebox: TFmessagebox;

implementation

{$R *.dfm}

procedure TFmessagebox.Nbt_OkClick(Sender: TObject);
begin
  modalresult := mrCancel ;
end;

end.
