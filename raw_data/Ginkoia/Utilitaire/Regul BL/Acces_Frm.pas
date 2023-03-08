unit Acces_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrm_Acces = class(TForm)
    Label1: TLabel;
    Edt_Pass: TEdit;
    Nbt_Ok: TBitBtn;
    Nbt_Cancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_OkClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Acces: TFrm_Acces;

implementation

{$R *.dfm}

procedure TFrm_Acces.FormCreate(Sender: TObject);
begin
  Edt_Pass.Text:='';
end;

procedure TFrm_Acces.Nbt_OkClick(Sender: TObject);
begin
  if Edt_Pass.Text<>'1082' then
  begin
    ModalResult:=mrnone;
    MessageDlg('Mot de pass invalide !',mterror,[mbok],0);
    Edt_Pass.SetFocus;
    Edt_Pass.SelectAll;
    exit;
  end;
end;

end.
