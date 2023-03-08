unit Confirmation_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, RzPanel, RzLabel,
  dxGDIPlusClasses;

type
  TFrm_Confirmation = class(TForm)
    Img_Ques: TImage;
    Lab_Confirmation: TRzLabel;
    Pan_Bas: TRzPanel;
    Nbt_Non: TLMDButton;
    Nbt_Oui: TLMDButton;
    procedure Nbt_NonClick(Sender: TObject);
    procedure Nbt_OuiClick(Sender: TObject);
    procedure Nbt_OuiEnter(Sender: TObject);
    procedure Nbt_OuiExit(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Confirmation: TFrm_Confirmation;

implementation

{$R *.dfm}

procedure TFrm_Confirmation.Nbt_NonClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TFrm_Confirmation.Nbt_OuiClick(Sender: TObject);
begin    
  ModalResult:=mrOk;
end;

procedure TFrm_Confirmation.Nbt_OuiEnter(Sender: TObject);
begin
  if not(fsBold in TLMDButton(Sender).Font.Style) then
    TLMDButton(Sender).Font.Style:=TLMDButton(Sender).Font.Style+[fsBold];
end;

procedure TFrm_Confirmation.Nbt_OuiExit(Sender: TObject);
begin   
  if (fsBold in TLMDButton(Sender).Font.Style) then
    TLMDButton(Sender).Font.Style:=TLMDButton(Sender).Font.Style-[fsBold];
end;

end.
