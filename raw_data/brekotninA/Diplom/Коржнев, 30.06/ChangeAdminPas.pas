unit ChangeAdminPas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sLabel, sEdit, sCheckBox, Buttons, sBitBtn, Registry;

type
  TfChangeAdminPas = class(TForm)
    eOldPas: TsEdit;
    eNewPas1: TsEdit;
    eNewPas2: TsEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sBitBtn1: TsBitBtn;
    sCheckBox1: TsCheckBox;
    sLabel4: TsLabel;
    eHint: TsEdit;
    sBitBtn2: TsBitBtn;
    procedure sCheckBox1Click(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure OriginalForm;
    procedure FormShow(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fChangeAdminPas: TfChangeAdminPas;
  Reg:TRegistry;
  password: String;
implementation

uses Misc;
{$R *.dfm}



procedure TfChangeAdminPas.FormShow(Sender: TObject);
begin
  OriginalForm;
end;

procedure TfChangeAdminPas.OriginalForm;
begin
  eOldPas.Clear;
  eNewPas1.Clear;
  eNewPas2.Clear;
  sCheckBox1.Checked:=False;
  eHint.Clear;
  eHint.Enabled:=False;
end;

procedure TfChangeAdminPas.sBitBtn1Click(Sender: TObject);
begin
  if ((eOldPas.Text<>'')and(eNewPas1.Text<>'')) then
    begin
      try
        Reg := TRegistry.Create;
        Reg.OpenKey(GetBaseKey, true);
        password := Reg.ReadString('admin_password');
        if eOldPas.Text<>password then
          begin
            showmessage('Старый пароль введен неправильно!');
            eOldPas.text:='';
            eNewPas1.Text:='';
            eNewPas2.Text:=''
          end
        else
          begin
            if eNewPas1.Text<>eNewPas2.Text then
              begin
                ShowMessage('Подтверждение пароля неверно!');
                eOldPas.text:='';
                eNewPas1.Text:='';
                eNewPas2.Text:=''
              end
            else
              begin
                Reg.WriteString('admin_password',eNewPas1.Text);
                Showmessage('Пароль успешно изменен.');
                close;
              end;
          end;
      finally
        Reg.CloseKey;
        Reg.Free;
      end;
    end
  else
    begin
      ShowMessage('Заполните поля!');
      eOldPas.text:='';
      eNewPas1.Text:='';
      eNewPas2.Text:=''
    end;
end;

procedure TfChangeAdminPas.sCheckBox1Click(Sender: TObject);
begin
  if sCheckBox1.Checked then
    eHint.Enabled:=True
  else
    eHint.Enabled:=False;
end;

procedure TfChangeAdminPas.sBitBtn2Click(Sender: TObject);
begin
Close;
end;

end.
