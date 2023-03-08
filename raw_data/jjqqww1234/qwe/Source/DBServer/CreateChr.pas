unit CreateChr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFrmCreateChr = class(TForm)
    EdUserId:  TEdit;
    EdChrName: TEdit;
    Label1:    TLabel;
    Label2:    TLabel;
    BitBtn1:   TBitBtn;
    BitBtn2:   TBitBtn;
    procedure FormShow(Sender: TObject);
  private
  public
    UserId, ChrName: string;
    function Execute: boolean;
    function Execute2: boolean;
  end;

var
  FrmCreateChr: TFrmCreateChr;

implementation

{$R *.DFM}

function TFrmCreateChr.Execute: boolean;
begin
  UserId  := '';
  ChrName := '';
  Result  := Execute2;
end;

function TFrmCreateChr.Execute2: boolean;
begin
  Result := False;
  EdUserId.Text := UserId;
  EdChrName.Text := ChrName;
  if ShowModal = mrOk then begin
    UserId  := Trim(EdUserId.Text);
    ChrName := Trim(EdChrName.Text);
    Result  := True;
  end;
end;

procedure TFrmCreateChr.FormShow(Sender: TObject);
begin
  EduserId.SetFocus;
end;

end.
