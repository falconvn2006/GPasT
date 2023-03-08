unit qrfilename;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFrmQueryFileName = class(TForm)
    EdFileName: TEdit;
    BitBtn1:    TBitBtn;
    BitBtn2:    TBitBtn;
    Label1:     TLabel;
  private
  public
    FileName: string;
    function Execute: boolean;
  end;

var
  FrmQueryFileName: TFrmQueryFileName;

implementation

{$R *.DFM}


function TFrmQueryFileName.Execute: boolean;
begin
  if mrOk = ShowModal then begin
    FileName := EdFileName.Text;
    Result   := True;
  end else
    Result := False;
end;


end.
