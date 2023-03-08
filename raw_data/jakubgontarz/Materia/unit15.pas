unit Unit15;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls;

type

  { TForm15 }

  TForm15 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ListView1: TListView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sprawdz;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form15: TForm15;
  i:integer;
  zaznacz:integer;

implementation

uses
  Unit1;

{$R *.lfm}

{ TForm15 }

procedure TForm15.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if listView1.ItemIndex>=0 then
    if (x>listview1.Width-listview1.column[2].width) and (x<listview1.Width) then
     begin if listview1.items.item[listview1.selected.index].subitems.strings[1]='TAK' then
     ListView1.Items.item[listview1.selected.index].subitems.Strings[1] := 'NIE' else
     ListView1.Items.item[listview1.selected.index].subitems.Strings[1] := 'TAK'; end;
     sprawdz;
end;

procedure TForm15.Button1Click(Sender: TObject);
var Item: TListItem;
begin
  button6.setfocus;
  Item := ListView1.Items.Add;
  Item.Caption := Format('wariant'+floattostr(listview1.Items.count-1), [listview1.Items.count]);
  Item.SubItems.Add(Format(floattostr(listview1.Items.count-1), [listview1.Items.count]));
  Item.SubItems.Add(Format('NIE', [listview1.Items.count]));
end;

procedure TForm15.Button2Click(Sender: TObject);
begin
  button6.setfocus;
  zaznacz:=listView1.ItemIndex;
  if zaznacz>=0 then
  begin
    listview1.items.Delete(zaznacz);
    listview1.SetFocus;
    if zaznacz<listview1.items.count then listview1.ItemIndex:=zaznacz;
    for i:=zaznacz to listview1.items.count-1 do
    ListView1.Items.item[i].subitems.Strings[0]:=inttostr(i);
    sprawdz;
  end;
end;

procedure TForm15.Button3Click(Sender: TObject);
begin
  button6.setfocus;
  zaznacz:=listView1.ItemIndex;
  if zaznacz>=0 then
  begin
    listview1.items.exchange(zaznacz,zaznacz-1);
    ListView1.Items.item[zaznacz].subitems.Strings[0]:=inttostr(zaznacz);
    ListView1.Items.item[zaznacz-1].subitems.Strings[0]:=inttostr(zaznacz-1);
    listview1.SetFocus; listview1.ItemIndex:=zaznacz-1;
    sprawdz;
  end;
end;

procedure TForm15.Button4Click(Sender: TObject);
begin
  button6.setfocus;
  zaznacz:=listView1.ItemIndex;
  if zaznacz>=0 then
  begin
    listview1.items.exchange(zaznacz,zaznacz+1);
    ListView1.Items.item[zaznacz].subitems.Strings[0]:=inttostr(zaznacz);
    ListView1.Items.item[zaznacz+1].subitems.Strings[0]:=inttostr(zaznacz+1);
    listview1.SetFocus; listview1.ItemIndex:=zaznacz+1;
    sprawdz;
  end;
end;

procedure TForm15.Button5Click(Sender: TObject);
begin
  okienko:=0;
  Close;
end;

procedure TForm15.Button6Click(Sender: TObject);
begin
  button6.setfocus;
  Warianty:=listview1.items.count-1;
  for i:=0 to warianty do begin
    WariantNazwa[i]:=ListView1.Items.item[i].Caption;
    if ListView1.Items.item[i].subitems.Strings[1]='TAK' then WariantWlasny[i]:=true else WariantWlasny[i]:=false;
  end;
  okienko:=0;
  form11open:=true;
  close;
end;

procedure TForm15.FormActivate(Sender: TObject);
var Item: TListItem;
begin
  if okienko=0 then begin
   okienko:=1;
   listview1.Clear;
   for i:=0 to warianty do
   begin
    Item := ListView1.Items.Add;
    Item.Caption := Format(wariantNazwa[i], [i]);
    Item.SubItems.Add(Format(inttostr(i), [i]));
    if wariantwlasny[i]=true then Item.SubItems.Add(Format('TAK', [i])) else Item.SubItems.Add(Format('NIE', [i]));
   end;
  end;
  if wyswietl=0 then button6.enabled:=true else button6.enabled:=false;
end;

procedure TForm15.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button5.setfocus;okienko:=0;
end;

procedure tform15.sprawdz;
begin
  if (listview1.itemindex=listview1.items.Count-1) or (listview1.itemindex<1) then button4.enabled:=false else button4.enabled:=true;
  if listview1.itemindex<2 then button3.enabled:=false else button3.enabled:=true;
  if listview1.itemindex<1 then button2.enabled:=false else button2.enabled:=true;
end;

end.

