unit WarningMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrmWarning = class(TForm)
    Label1: TLabel;
  private
  public
    procedure Execute(msgtitle: string);
  end;

var
  FrmWarning: TFrmWarning;

implementation

{$R *.DFM}


procedure TFrmWarning.Execute(msgtitle: string);
begin
  FrmWarning.Caption := msgtitle;
  Show;
end;

end.
