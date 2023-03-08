unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ujson, StdCtrls;

type
  TForm1 = class(TForm)
    mmo1: TMemo;
    edt1: TEdit;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
a,b : myJSONItem;
begin
a := myJSONItem.Create;
b := myJSONItem.Create;

a.Code := '{"item1":"value 1","item2":[3,4,5]}';
a['item3'].setStr('value 3');
Writeln(a.Code); // {"item1":"value 1","item2":[3,4,5],"item3":"value 3"}
b['desc'].setStr('And now for something completelly different');
b['c'].Code := a.Code;
Writeln(b.Code); // {"desc":"And now for something completelly different","c":{"item1":"value 1","item2":[3,4,5],"item3":"value 3"}}

end;

end.
