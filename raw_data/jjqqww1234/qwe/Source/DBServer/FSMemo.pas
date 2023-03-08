unit FSMemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFrmSysMemo = class(TForm)
    EdMemo:  TEdit;
    Label1:  TLabel;
    BitBtn1: TBitBtn;
  private
  public
    UName:   string;
    MemoStr: string;
    function Execute: boolean;
  end;

var
  FrmSysMemo: TFrmSysMemo;

implementation

{$R *.DFM}

function TFrmSysMemo.Execute: boolean;
begin
  Label1.Caption := UName + ' : memo';
  EdMemo.Text    := '';
  ShowModal;
  MemoStr := EdMemo.Text;
  Result  := True;
end;

end.
