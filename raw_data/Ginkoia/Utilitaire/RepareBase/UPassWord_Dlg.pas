unit UPassWord_Dlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons;

type
  TDlgPassword = class(TForm)
    LblPwd: TLabel;
    EdtPwd: TEdit;
    BtnOK: TButton;
    BtnCancel: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function IsPassworOk: Boolean;

implementation

uses
  UParams;

{$R *.dfm}

function IsPassworOk: Boolean;
begin
  with TDlgPassword.Create(nil) do
  try
    Result := (ShowModal = mrOK) and (EdtPwd.Text = SRepareBase.Password);
  finally
    Release;
  end;
end;

end.
 
