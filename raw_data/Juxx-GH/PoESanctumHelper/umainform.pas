unit umainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    lbNum: Integer;
    procedure FillListBox(lb: TListBox; floorNum: Integer);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ListBox1Click(Sender: TObject);
begin

end;

procedure TForm1.FillListBox(lb: TListBox; floorNum: Integer);
var
  F: Text;
  s: String;
  i: Integer;
begin
  lbNum:=0;
  System.Assign(F, '[3.20] Sanctum Rooms.txt');
  // System.FileMode:=0; // open readonly
  System.Reset(F);
  while lbNum<floorNum do begin
    lbNum:=lbNum+1;
    { title }
    ReadLn(F, s);
    ListBox1.Items.Add(s);
    { divider }
    ReadLn(F, s);
    ListBox1.Items.Add(s);
    for i:=1 to 5 do begin
      // room
      ReadLn(F, s);
      ListBox1.Items.Add(s);
      // description
      ReadLn(F, s);
      ListBox1.Items.Add(s);
    end;
    // empty line
    ReadLn(F, s);
    ListBox1.Items.Add(s);
    if lbNum = floorNum-1 then begin
      ListBox1.Items.Clear();
    end;
  end;
  System.Close(F);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Label1.Caption:='PoE Sanctum rooms quick helper' + chr(13)
      + 'Original work (C) 2023 by Juxx.net and' + chr(13)
      + ' released into the public domain.'
      ;
  Label2.Caption:='This project is not affiliated with or' +chr(13)
    + ' endorsed by Grinding Gear Games' + chr(13)
    + ' (GGG) and contains itellectual property' + chr(13)
    + ' owned by GGG which is used with' + chr(13)
    + ' permission but cannot be relicensed.';
  lbNum:=1;
  FillListBox(ListBox1, lbNum);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Dec(lbNum);
  if lbNum<1 then lbNum:=1;
  ListBox1.Items.Clear();
  FillListBox(ListBox1, lbNum);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Inc(lbNum);
  if lbNum>4 then lbNum:=4;
  ListBox1.Items.Clear();
  FillListBox(ListBox1, lbNum);
end;

end.

