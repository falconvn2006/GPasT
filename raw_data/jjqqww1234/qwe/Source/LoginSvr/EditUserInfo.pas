unit EditUserInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IDDB;

type
  TFrmUserInfoEdit = class(TForm)
    Label1:    TLabel;
    EdId:      TEdit;
    Label2:    TLabel;
    EdPasswd:  TEdit;
    Label3:    TLabel;
    EdUserName: TEdit;
    Label4:    TLabel;
    EdBirthDay: TEdit;
    Label5:    TLabel;
    EdPhone:   TEdit;
    Button1:   TButton;
    Button2:   TButton;
    CkFullEdit: TCheckBox;
    Label9:    TLabel;
    EdSSNo:    TEdit;
    Label6:    TLabel;
    Label7:    TLabel;
    EdQuiz:    TEdit;
    EdAnswer:  TEdit;
    Label10:   TLabel;
    Label11:   TLabel;
    EdQuiz2:   TEdit;
    EdAnswer2: TEdit;
    Label12:   TLabel;
    EdMobilePhone: TEdit;
    Label13:   TLabel;
    EdMemo1:   TEdit;
    Label14:   TLabel;
    EdMemo2:   TEdit;
    Label8:    TLabel;
    EdEMail:   TEdit;
    procedure CkFullEditClick(Sender: TObject);
  private
  public
    function Execute(var ircd: FIdRcd): boolean;
    function ExecuteEdit(bonew: boolean; var ircd: FIdRcd): boolean;
  end;

var
  FrmUserInfoEdit: TFrmUserInfoEdit;

implementation

{$R *.DFM}


function TFrmUserInfoEdit.Execute(var ircd: FIdRcd): boolean;
begin
  Result := ExecuteEdit(False, ircd);
end;

function TFrmUserInfoEdit.ExecuteEdit(bonew: boolean; var ircd: FIdRcd): boolean;
begin
  Result := False;
  if not bonew then begin
    CkFullEdit.Enabled := True;
    CkFullEdit.Checked := False;
    CkFullEditClick(self);
    EdId.Enabled := False;
  end else begin
    CkFullEdit.Enabled := False;
    CkFullEdit.Checked := True;
    CkFullEditClick(self);
    EdId.Enabled := True;
  end;

  EdId.Text      := ircd.Block.UInfo.LoginId;
  EdPasswd.Text  := ircd.Block.UInfo.Password;
  EdUserName.Text := ircd.Block.UInfo.UserName;
  EdSSNo.Text    := ircd.Block.UInfo.SSNo;
  EdBirthDay.Text := ircd.Block.UAdd.Birthday;
  EdQuiz.Text    := ircd.Block.UInfo.Quiz;
  EdAnswer.Text  := ircd.Block.UInfo.Answer;
  EdQuiz2.Text   := ircd.Block.UAdd.Quiz2;
  EdAnswer2.Text := ircd.Block.UAdd.Answer2;
  EdPhone.Text   := ircd.Block.UInfo.Phone;
  EdMobilePhone.Text := ircd.Block.UAdd.MobilePhone;
  EdMemo1.Text   := ircd.Block.UAdd.Memo1;
  EdMemo2.Text   := ircd.Block.UAdd.Memo2;
  EdEMail.Text   := ircd.Block.UInfo.EMail;

  if ShowModal = mrOk then begin
    if bonew then begin
      ircd.Block.UInfo.LoginId := EdId.Text;
    end;
    ircd.Block.UInfo.Password := EdPasswd.Text;
    ircd.Block.UInfo.UserName := EdUserName.Text;
    ircd.Block.UInfo.SSNo := EdSSNo.Text;
    ircd.Block.UAdd.Birthday := EdBirthday.Text;
    ircd.Block.UInfo.Quiz := EdQuiz.Text;
    ircd.Block.UInfo.Answer := EdAnswer.Text;
    ircd.Block.UAdd.Quiz2 := EdQuiz2.Text;
    ircd.Block.UAdd.Answer2 := EdAnswer2.Text;
    ircd.Block.UInfo.Phone := EdPhone.Text;
    ircd.Block.UAdd.MobilePhone := EdMobilePhone.Text;
    ircd.Block.UAdd.Memo1 := EdMemo1.Text;
    ircd.Block.UAdd.Memo2 := EdMemo2.Text;
    ircd.Block.UInfo.EMail := EdEMail.Text;
    Result := True;
  end;

end;

procedure TFrmUserInfoEdit.CkFullEditClick(Sender: TObject);
var
  flag: boolean;
begin
  flag := CkFullEdit.Checked;
  EdUserName.Enabled := flag;
  EdSSNo.Enabled := flag;
  EdBirthDay.Enabled := flag;
  EdQuiz.Enabled := flag;
  EdAnswer.Enabled := flag;
  EdQuiz2.Enabled := flag;
  EdAnswer2.Enabled := flag;
  EdPhone.Enabled := flag;
  EdMobilePhone.Enabled := flag;
  EdMemo1.Enabled := flag;
  EdMemo2.Enabled := flag;
  EdEMail.Enabled := flag;
end;

end.
