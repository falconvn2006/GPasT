unit FrmInID;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFrmInputID = class(TForm)
    Label1:  TLabel;
    EdID:    TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    ID: string;
    function Execute: boolean;
  end;

var
  FrmInputID: TFrmInputID;

implementation

{$R *.DFM}


function TFrmInputID.Execute: boolean;
begin
  Result    := False;
  EdID.Text := '';
  if ShowModal = mrOk then begin
    ID     := EdID.Text;
    Result := True;
  end;
end;


end.
