unit GSCFGSMMagasin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TFsmMagasin = class(TForm)
    Pan_Bottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    Rgr_Type: TRadioGroup;
    cbo_Axe: TComboBox;
    txt_Numero: TEdit;
    Lab_Numero: TLabel;
    Lab_User: TLabel;
    Lab_Type: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FsmMagasin: TFsmMagasin;

implementation

uses GSCFGMain_DM, GSCFGSMDossier_Frm;

{$R *.dfm}


procedure TFsmMagasin.FormCreate(Sender: TObject);
begin
  CAPTION := CAPTION + FMain_DM.Que_MagasinMAGASIN.AsString;


end;

procedure TFsmMagasin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
end;

procedure TFsmMagasin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key) = VK_Escape then
    Close;
end;

end.
