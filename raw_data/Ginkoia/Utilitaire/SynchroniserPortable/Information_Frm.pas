unit Information_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TFrm_Information = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Nbt_Ok: TBitBtn;
    Tim_Delai: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_OkClick(Sender: TObject);
    procedure Tim_DelaiTimer(Sender: TObject);
  private
    { Déclarations privées }
    Delai: integer;
    procedure CMDialogKey(var M: TCMDialogKey);
  public
    { Déclarations publiques }
  end;

var
  Frm_Information: TFrm_Information;

implementation

{$R *.dfm}

procedure TFrm_Information.CMDialogKey(var M: TCMDialogKey);
begin
  if (m.CharCode = VK_ESCAPE) then
  begin
    m.Result := 1;
    Close;
    Exit;
  end;
  inherited;
end;

procedure TFrm_Information.FormCreate(Sender: TObject);
begin
  Delai := 15;
  Nbt_OK.Caption := 'Ok ('+inttostr(Delai)+')';
end;

procedure TFrm_Information.Nbt_OkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrm_Information.Tim_DelaiTimer(Sender: TObject);
begin
  Dec(Delai);
  Nbt_OK.Caption := 'Ok ('+inttostr(Delai)+')';
  if Delai<=0 then
    Nbt_OkClick(Nbt_Ok);
end;

end.
