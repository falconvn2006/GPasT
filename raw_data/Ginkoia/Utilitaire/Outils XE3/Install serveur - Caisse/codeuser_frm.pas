unit Codeuser_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFcodeuser = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edtUser: TEdit;
    edtpwd: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fcodeuser: TFcodeuser;

implementation

{$R *.dfm}

procedure TFcodeuser.btnCancelClick(Sender: TObject);
begin
 modalResult := mrCancel ;
end;

procedure TFcodeuser.btnOkClick(Sender: TObject);
begin
   if edtUser.Text = '' then
    begin
      beep ;
      beep ;
      edtuser.SetFocus ;
      exit ;
    end;
   if edtPwd.Text = '' then
    begin 
      beep ;
      beep ;
      edtPwd.SetFocus ;
      exit ;
    end;

   modalresult := mrOk ; 
end;

procedure TFcodeuser.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = vk_return then
    begin
      btnOkClick(Sender);
    end;
end;

procedure TFcodeuser.FormShow(Sender: TObject);
begin
  edtUser.Text := '';
  edtPwd.Text := '';
end;

end.
