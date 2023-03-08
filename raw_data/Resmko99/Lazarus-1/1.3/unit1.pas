unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var   i,t,k,j: integer;
begin
  k:=strtoint(Edit1.Text);
  j:=strtoint(Edit2.Text);
  i:=1;t:=1;
  while i <=j do begin
    t:=t*k;
    i:=i+1;
  end;
  Memo1.Clear;
  Memo1.Lines.add('Число '+Edit1.Text+' в степени '+Edit2.Text+' = '+IntToStr(t));


end;

procedure TForm1.Memo1Change(Sender: TObject);
begin

end;

end.

