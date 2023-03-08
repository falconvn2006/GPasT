unit passwd;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons;

type
  TPasswordDlg = class(TForm)
    Label1:    TLabel;
    Password:  TEdit;
    OKBtn:     TButton;
    CancelBtn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute: boolean;
  end;

var
  PasswordDlg: TPasswordDlg;

implementation

{$R *.DFM}

function TPasswordDlg.Execute: boolean;
begin
  Password.Text := '';
  PasswordDlg.ShowModal;
  if Password.Text = 'amir#05!' then
    Result := True
  else
    Result := False;
end;

end.
