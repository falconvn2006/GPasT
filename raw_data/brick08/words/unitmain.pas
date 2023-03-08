unit unitmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, LCLType, LazUtils,
  LazUTF8;

type

  { TMain }

  TMain = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit2: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit1UTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
  private

  public

  end;

var
  Main: TMain;
  sarr: array[1..5,1..5] of string;
  barr: array[1..5,1..5] of Boolean;
            //строка, столбец

implementation

{$R *.lfm}

{ TMain }

procedure TMain.Edit1UTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
var
  s: TCaption;
  l: Integer;
  cmp: TComponent;
begin
  UTF8Key:=UTF8UpperCase(UTF8Key);
  s:=edit1.Text + UTF8Key;
  l:=UTF8Length(s);
  sarr[(l div 5) + 1, ((l + 1)  mod 5) - 1]:=UTF8Key;
  cmp:= FindComponent('Edit' + IntToStr(l+1));
  if (cmp is TEdit) then
      (cmp as TEdit).text:=UTF8Key;
end;

procedure TMain.BitBtn1Click(Sender: TObject);
var
  str: TStringStream;
  sl: TStringList;
  k, c, r, n: Integer;
  s: String;
  b: Char;
begin
  str := TStringStream.Create('слово');
  sl := TStringList.Create;
  sl.LoadFromStream(str);
  for k := 0 to sl.Count - 1 do
  begin
    s := sl.Strings[k];
    for n:=1 to UTF8Length(s) do
    begin
      b:=s[n];
      for c := 1 to 5 do
      begin
        for r := 1 to 5 do
        begin
          if sarr[r, c] = b then
            barr[r, c]:=True;
        end;
      end;
    end;
  end;
end;

end.

