unit DataStr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TDataStrF = class(TForm)
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
  private
    { Private declarations }
  public
  Procedure ShowFile( S: String);
    { Public declarations }
  end;

var
  DataStrF: TDataStrF;

implementation
Procedure TDataStrF.ShowFile(S:String);
Begin
 Memo1.Lines.LoadFromFile(S);
end;

{$R *.dfm}

end.
