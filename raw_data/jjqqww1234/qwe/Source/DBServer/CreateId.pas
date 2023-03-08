unit CreateId;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFrmCreateId = class(TForm)
    EdId:     TEdit;
    EdPasswd: TEdit;
    Label1:   TLabel;
    Label2:   TLabel;
    BitBtn1:  TBitBtn;
    BitBtn2:  TBitBtn;
    procedure FormShow(Sender: TObject);
  private
  public
    TItle: string;
    UserId, Passwd: string;
    function Execute: boolean;
  end;

var
  FrmCreateId: TFrmCreateId;

implementation

{$R *.DFM}


function TFrmCreateId.Execute: boolean;
begin
  Result    := False;
  EdId.Text := '';
  EdPasswd.Text := '';
  Caption   := Title;
  if ShowModal = mrOk then begin
    UserId := Trim(EdId.Text);
    PassWd := Trim(EdPasswd.Text);
    Result := True;
  end;
end;


procedure TFrmCreateId.FormShow(Sender: TObject);
begin
  EdId.SetFocus;
end;

end.
