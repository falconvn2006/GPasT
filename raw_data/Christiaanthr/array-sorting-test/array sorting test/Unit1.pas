unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    pnlenter: TPanel;
    btnsortname: TButton;
    btnsortsurname: TButton;
    btnsortage: TButton;
    Memo1: TMemo;
    procedure pnlenterClick(Sender: TObject);
    procedure btnsortageClick(Sender: TObject);
    procedure btnsortsurnameClick(Sender: TObject);
    procedure btnsortnameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
number_names = 3;

var
  Form1: TForm1;
  iage : Integer;

  sname, ssurname,snumber : string;
  arrNames : array[1..number_names] of string;
  arrSur : array[1..number_names] of string;
  arrage : array[1..number_names] of Integer;

implementation

{$R *.dfm}

procedure TForm1.btnsortageClick(Sender: TObject);
var i,a : Integer;

begin
for i := 1 to number_names do
  begin
    for a := 1 to number_names -1 do
      begin
        if arrage[a] < arrage[a+1] then
        begin
           sname := arrNames[a];
           arrNames[a] := arrNames[a+1];
           arrNames[a+1] := sname;

           ssurname := arrSur[a];
           arrSur[a] := arrSur[a+1];
           arrSur[a+1] := ssurname;

           iage := arrage[a];
           arrage[a] := arrage[a+1];
           arrage[a+1] := iage;
        end;
      end;
  end;

Memo1.Lines.Clear;
for I := 1 to number_names do
  begin
   Memo1.Lines.Add(arrNames[i] + ' ' + arrSur[i] + ' ' + IntToStr(arrage[i]))
  end;
end;

procedure TForm1.btnsortnameClick(Sender: TObject);
var i,a : Integer;
begin
for i := 1 to number_names do
  begin
    for a := 1 to number_names-1 do
      begin
        if arrNames[a] > arrNames[a+1] then
        begin
           sname := arrNames[a];
           arrNames[a] := arrNames[a+1];
           arrNames[a+1] := sname;

           ssurname := arrSur[a];
           arrSur[a] := arrSur[a+1];
           arrSur[a+1] := ssurname;

           iage := arrage[a];
           arrage[a] := arrage[a+1];
           arrage[a+1] := iage;
        end;
      end;
  end;

Memo1.Lines.Clear;
for I := 1 to number_names do
  begin
   Memo1.Lines.Add(arrNames[i] + ' ' + arrSur[i] + ' ' + IntToStr(arrage[i]))
  end;
end;

procedure TForm1.btnsortsurnameClick(Sender: TObject);
var
i,a : Integer;
begin
for i := 1 to number_names do
  begin
    for a := 1 to number_names-1 do
    begin
        if arrNames[a] > arrNames[a+1] then
        begin
           sname := arrNames[a];
           arrNames[a] := arrNames[a+1];
           arrNames[a+1] := sname;

           ssurname := arrSur[a];
           arrSur[a] := arrSur[a+1];
           arrSur[a+1] := ssurname;

           iage := arrage[a];
           arrage[a] := arrage[a+1];
           arrage[a+1] := iage;
        end;
      end;
  end;
Memo1.Lines.Clear;
for I := 1 to number_names do
  begin
   Memo1.Lines.Add(arrNames[i] + ' ' + arrSur[i] + ' ' + IntToStr(arrage[i]))
  end;
end;

procedure TForm1.pnlenterClick(Sender: TObject);
var
i : Integer;
begin
for I := 1 to number_names do
 begin
  sname := InputBox('name','','');
  ssurname :=  InputBox('surname','','');
  iage := StrToInt(InputBox('age','',''));

  arrNames[i] := sname;
  arrSur[i] := ssurname;
  arrage[i] := iage;
 end;
end;

end.
