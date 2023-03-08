unit ISAdminCheckPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, sLabel, Buttons, sBitBtn, Registry;

type
  TfISAdminCheckPassword = class(TForm)
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    EditAdminPas: TsEdit;
    bOk: TsBitBtn;
    sBitBtn1: TsBitBtn;
    procedure sLabel2MouseEnter(Sender: TObject);
    procedure sLabel2MouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EditAdminPasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sLabel2Click(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure bOkClick(Sender: TObject);
  private
    { Private declarations }
    password: String;
  public
    { Public declarations }
  end;

var
  fISAdminCheckPassword: TfISAdminCheckPassword;
  Reg:TRegistry;
  hint:String;
implementation

uses Entry, Admin, Misc;

{$R *.dfm}



procedure TfISAdminCheckPassword.EditAdminPasKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key=13 then bOk.Click; 
end;

procedure TfISAdminCheckPassword.FormActivate(Sender: TObject);
begin
  editAdminPas.Text := '';
  editAdminPas.SetFocus;
  try
    Reg := TRegistry.Create;
    Reg.OpenKey(GetBaseKey, true);
    if (Reg.ReadString('hint')<>'') then begin
      sLabel2.Visible:=True;
      hint:= Reg.ReadString('hint');
    end
      else sLabel2.Visible:=False;
    password := Reg.ReadString('admin_password');
    if (password = '') then begin
      Reg.WriteString('admin_password','12345');
      password := '12345';
    end;
      finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure TfISAdminCheckPassword.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  EditAdminPas.Clear;
end;

procedure TfISAdminCheckPassword.FormShow(Sender: TObject);
begin
  EditAdminPas.SetFocus;
end;

procedure TfISAdminCheckPassword.sLabel2Click(Sender: TObject);
begin
  Application.MessageBox(PWideChar(hint),'Подсказка',MB_OK);
end;

procedure TfISAdminCheckPassword.sLabel2MouseEnter(Sender: TObject);
begin
    sLabel2.Font.Color := clBlue;
end;

procedure TfISAdminCheckPassword.sLabel2MouseLeave(Sender: TObject);
begin
    sLabel2.Font.Color := clBlack;
end;

procedure TfISAdminCheckPassword.sBitBtn1Click(Sender: TObject);
begin
  Close();
end;

procedure TfISAdminCheckPassword.bOkClick(Sender: TObject);
begin
if (LowerCase(editAdminPas.Text) = password) then
  begin
    fEntry.Hide;
    hide;
    AdminForm := TAdminForm.Create(nil);
    try
      AdminForm.ShowModal();
    finally
      FreeAndNil(AdminForm);
    end;
    close;
    fEntry.EditEnterPas.Text:='';
    fEntry.Show;
    end
  else
    begin                            
      Application.MessageBox('Пароль неверен!.','Ошибка',MB_OK);
      EditAdminPas.Clear;
    end;
end;

end.
