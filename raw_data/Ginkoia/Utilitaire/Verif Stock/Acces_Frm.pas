unit Acces_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, RzLabel;

type
  TFrm_Acces = class(TForm)
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    EUtil: TEdit;
    EPass: TEdit;
    Bevel1: TBevel;
    Nbt_ok: TLMDButton;
    Nbt_Cancel: TLMDButton;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_okClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Déclarations publiques }
  end;

var
  Frm_Acces: TFrm_Acces;

implementation

{$R *.dfm} 

procedure TFrm_Acces.CMDialogKey(var M: TCMDialogKey);
begin
  if (m.CharCode=VK_RETURN) and (ActiveControl=EUtil) then
    m.CharCode:=VK_TAB;
  inherited;
end;

procedure TFrm_Acces.FormCreate(Sender: TObject);
begin
  EUtil.Text:='';
  EPass.Text:='';
end;

procedure TFrm_Acces.Nbt_okClick(Sender: TObject);
begin
  if (EUtil.Text<>'algol') or (EPass.Text<>'1082') then
  begin
    ModalResult:=mrnone;
    MessageDlg('Utilisateur/Mot de passe invalide !',mterror,[mbok],0);
    EUtil.SetFocus;
    EUtil.SelectAll;
    exit;
  end;
end;

end.
