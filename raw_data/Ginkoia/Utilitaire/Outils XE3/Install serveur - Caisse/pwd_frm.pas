unit Pwd_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  //Début Uses Perso
  //Fin Uses Perso
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrm_Pwd = class(TForm)
    edtPwd: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Pwd: TFrm_Pwd;

implementation

{$R *.dfm}

procedure TFrm_Pwd.btnCancelClick(Sender: TObject);
begin
 modalResult := mrCancel;
end;

procedure TFrm_Pwd.btnOkClick(Sender: TObject);
begin
  if edtpwd.Text <> '' then
    modalresult := mrOK ;
end;

procedure TFrm_Pwd.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = vk_return then
   begin
     if edtpwd.Text <> '' then
       begin
         modalresult := mrOk ;
       end;
   end;
end;

end.
