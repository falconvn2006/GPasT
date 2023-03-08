unit Unit9;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { TForm9 }

  TForm9 = class(TForm)
    Button1: TButton;
    Button12: TButton;
    Button13: TButton;
    TreeView1: TTreeView;
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form9: TForm9;
  catalog:array [1..50] of string;
  ldrzewo:array [1..50] of integer;
  NazwaPrzb:array [1..50,1..1000] of string;
  Eib,gib,atib,Aib,Jib,hib,iib:array [1..50,1..1000] of real;
  u,uu:integer;
  plik2:text;

implementation

{$R *.lfm}

uses
  Unit1,unit8;

{ TForm9 }

procedure TForm9.FormShow(Sender: TObject);
var
  RootNode: TTreeNode;
begin
  try
  treeview1.Items.clear;
  i:=1;
  assignfile(plik,ExtractFilePath(Application.ExeName)+'default.bas');              //czytanie bazy
  reset(plik);
  readln(plik,catalog[i]);
  repeat
    read(plik,nic);
    ldrzewo[i]:=0;
    repeat
      inc(ldrzewo[i]);
      repeat read(plik,nic) until nic=' ';
      read(plik,Eib[i,ldrzewo[i]],gib[i,ldrzewo[i]],atib[i,ldrzewo[i]],Aib[i,ldrzewo[i]],Jib[i,ldrzewo[i]],hib[i,ldrzewo[i]],iib[i,ldrzewo[i]]);
      repeat read(plik,nic); until nic<>' ';
      readln(plik,blabla);
      NazwaPrzb[i,ldrzewo[i]]:=nic+blabla;
      read(plik,nic);
    until nic=' ';
    readln(plik,nic);
    inc(i);
    readln(plik,catalog[i]);
  until catalog[i]='#';
  i:=i-1;
  closefile(plik);
  //tworzenie listy
   for u:=1 to i do
   begin
     rootnode:=TreeView1.items.add(treeview1.Selections[u-1],catalog[u]);
     for uu:=1 to Ldrzewo[u] do TreeView1.items.AddChild(rootnode,NazwaPrzb[u,uu]);
   end;
  except
    MessageDlg('Błąd!', 'Plik z bazą przekrojów jest uszkodzony.', mterror, [mbOK], 0);
    form9.Close;
  end;
  form9.Left:=form8.left-form9.width-5;
  form9.top:=form8.top;
end;

procedure TForm9.Button1Click(Sender: TObject);
var blad:boolean;
begin
  blad:=false;
  if (treeview1.SelectionCount=1) then if (treeview1.Selected.Level=1)  then
    for i:=1 to lprz do if NazwaPrzb[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1]=nazwaprz[i] then begin MessageDlg('Ostrzeżenie!', 'Przekrój o tej nazwie już istnieje!', mtWarning, [mbOK], 0);blad:=true;end;
    if blad=false then begin
      inc(Lprz);
      NazwaPrz[LPrz]:=NazwaPrzb[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1];
      Ei[LPrz]:=Eib[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1];
      gi[LPrz]:=gib[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1];
      ati[LPrz]:=atib[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1];
      Ai[LPrz]:=Aib[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1];
      Ji[LPrz]:=Jib[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1];
      hi[LPrz]:=hib[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1];
      ii[LPrz]:=iib[treeview1.Selected.Parent.Index+1,treeview1.Selected.Index+1];
      form9open:=true;
    end;
  if (treeview1.SelectionCount=1) then if (treeview1.Selected.Level<>1) then
    MessageDlg('Ostrzeżenie', 'Nie wybrano przekroju!', mtWarning, [mbOK], 0);
  if (treeview1.SelectionCount<>1) then MessageDlg('Ostrzeżenie', 'Nie wybrano przekroju!', mtWarning, [mbOK], 0);
  form8.SetFocus;
end;

procedure TForm9.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button12.setfocus;
end;

procedure TForm9.Button12Click(Sender: TObject);
begin
  close;
end;

procedure TForm9.Button13Click(Sender: TObject);
begin
  button12.setfocus;
  MessageDlg('Ostrzeżenie', 'Funkcja niedostępna w tej wersji programu.', mtWarning, [mbOK], 0);
end;

end.

