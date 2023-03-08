unit Unit11;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Grids, clipbrd, ActnList, Menus, LCLType,strutils;

type

  { TForm11 }

  TForm11 = class(TForm)
    Button12: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    StringGrid6: TStringGrid;
    StringGrid7: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    procedure Button12Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure StringGrid1ColRowDeleted(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure StringGrid1ColRowInserted(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure StringGrid1ColRowMoved(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure HeaderClick(Sender: tstringgrid; IsColumn: Boolean;
      Index: Integer);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditingDone(Sender: tstringgrid);
    procedure StringGrid1SelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure StringGrid2ColRowDeleted(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure StringGrid2ColRowInserted(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure StringGrid2ColRowMoved(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure ColRowMoved(Sender: tstringgrid; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure sprawdz;
  public
    { public declarations }
  end;

var
  Form11: TForm11;
  element:tstringgrid;
  tabela,tabela2: array[1..1000,1..10] of string;
  maxi,maxi2:integer;

implementation

{$R *.lfm}

{ TForm11 }

uses
  Unit1;

procedure TForm11.FormActivate(Sender: TObject);
var Item: TListItem;
begin
  case pagecontrol1.ActivePageIndex of
    0: element:=stringgrid1;
    1: element:=stringgrid2;
    2: element:=stringgrid3;
    3: element:=stringgrid4;
    4: element:=stringgrid5;
    5: element:=stringgrid6;
    6: element:=stringgrid7;
  end;
  sprawdz;
end;

procedure TForm11.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button12.setfocus;
end;

procedure TForm11.FormShow(Sender: TObject);
begin
  menuitem1.Enabled:=false; menuitem8.Enabled:=false;
  element:=stringgrid1;
  sprawdz;
  stringgrid1.RowCount:=Lw+1;
  stringgrid2.RowCount:=Le+1;
  stringgrid2.columns.items[3].PickList.Clear;
  stringgrid3.RowCount:=Lwar+1;
  stringgrid4.RowCount:=RowsPp+1;
  stringgrid5.RowCount:=RowsPm+1;
  stringgrid6.RowCount:=RowsPq+1;
  stringgrid7.RowCount:=RowsPt+1;
  for i:=1 to Lprz do  stringgrid2.columns.items[3].PickList.Add(Nazwaprz[i]);
  for i:=1 to Lw do
  begin
    stringgrid1.Cells[1,i] := floattostr(Xw[i]);
    stringgrid1.Cells[2,i] := floattostr(Yw[i]);
  end;
  for i:=1 to Le do
  begin
    stringgrid2.Cells[1,i] := floattostr(Wp[i]);
    stringgrid2.Cells[2,i] := floattostr(Wk[i]);
    stringgrid2.Cells[3,i] := floattostr(Typs[i]);
    stringgrid2.Cells[4,i] := NazwaPrz[Prz[i]+1];
  end;
  for i:=1 to Lwar do
  begin
    stringgrid3.Cells[1,i] := floattostr(s[i]);
    if rpod[i]=1 then stringgrid3.Cells[2,i] := '--M';
    if rpod[i]=2 then stringgrid3.Cells[2,i] := 'VHM';
    if rpod[i]=3 then stringgrid3.Cells[2,i] := 'VH-';
    if rpod[i]=4 then stringgrid3.Cells[2,i] := 'V-M';
    if rpod[i]=5 then stringgrid3.Cells[2,i] := 'V--';
    stringgrid3.Cells[3,i] := floattostr(fipod[i]);
    stringgrid3.Cells[4,i] := floattostr(DV[i]);
    stringgrid3.Cells[5,i] := floattostr(DH[i]);
    stringgrid3.Cells[6,i] := floattostr(DM[i]);
    stringgrid3.Cells[7,i] := floattostr(kV[i]);
    stringgrid3.Cells[8,i] := floattostr(kH[i]);
    stringgrid3.Cells[9,i] := floattostr(kM[i]);
    stringgrid3.Cells[10,i] :='';
    for j:=1 to warianty do if wariantPod[i,j]=true then stringgrid3.Cells[10,i] := stringgrid3.Cells[10,i]+floattostr(j)+' ';
  end;
  for i:=1 to RowsPp do
  begin
    stringgrid4.Cells[1,i] := floattostr(P[i]);
    stringgrid4.Cells[2,i] := floattostr(alfaP[i]);
    stringgrid4.Cells[3,i] := floattostr(np[i]);
    stringgrid4.Cells[4,i] := floattostr(xp[i]);
    stringgrid4.Cells[5,i] :='';
    for j:=1 to warianty do if wariantP[i,j]=true then stringgrid4.Cells[5,i] := stringgrid4.Cells[5,i]+floattostr(j)+' ';
  end;
  for i:=1 to RowsPm do
  begin
    stringgrid5.Cells[1,i] := floattostr(Pm[i]);
    stringgrid5.Cells[2,i] := floattostr(nm[i]);
    stringgrid5.Cells[3,i] := floattostr(xm[i]);
    stringgrid5.Cells[4,i] :='';
    for j:=1 to warianty do if wariantM[i,j]=true then stringgrid5.Cells[4,i] := stringgrid5.Cells[4,i]+floattostr(j)+' ';
  end;
  for i:=1 to RowsPq do
  begin
    stringgrid6.Cells[1,i] :=floattostr(Pqi[i]);
    stringgrid6.Cells[2,i] :=floattostr(Pqj[i]);
    stringgrid6.Cells[3,i] :=floattostr(alfaq[i]);
    stringgrid6.Cells[4,i] :=floattostr(nq[i]);
    stringgrid6.Cells[5,i] :=floattostr(xqi[i]);
    stringgrid6.Cells[6,i] :=floattostr(xqj[i]);
    stringgrid6.Cells[7,i] :='';
    for j:=1 to warianty do if wariantQ[i,j]=true then stringgrid6.Cells[7,i] := stringgrid6.Cells[7,i]+floattostr(j)+' ';
  end;
  for i:=1 to RowsPt do
  begin
    stringgrid7.Cells[1,i] :=floattostr(Tg[i]);
    stringgrid7.Cells[2,i] :=floattostr(Td[i]);
    stringgrid7.Cells[3,i] :=floattostr(nt[i]);
    stringgrid7.Cells[4,i] :='';
    for j:=1 to warianty do if wariantT[i,j]=true then stringgrid7.Cells[4,i] := stringgrid7.Cells[4,i]+floattostr(j)+' ';
  end;
  for i:=1 to element.RowCount-1 do for j:=1 to element.colcount-1 do tabela[i,j]:=element.cells[j,i];
  for i:=1 to element.RowCount-1 do for j:=1 to element.colcount-1 do tabela2[i,j]:=element.cells[j,i];
  maxi:=element.rowcount-1;maxi2:=element.rowcount-1;
  if wyswietl=0 then button3.enabled:=true else button3.enabled:=false;
end;


procedure TForm11.MenuItem10Click(Sender: TObject);
var wiersz,kolumna:integer;
begin
  //kopiuj
   if not element.EditorMode then element.CopyToClipboard(true);
end;

procedure TForm11.MenuItem11Click(Sender: TObject);
var symbol,symbol2,lwierszy,lkolumn:integer; bufor:array[1..1000]of string; pamiec:array[1..10,1..1000] of string;
begin
  //wklej
  symbol:=0;
  symbol2:=0;
  i:=1;
  repeat
    symbol2:=PosEx(#13#10,clipboard.astext,symbol+1);
    if symbol2=0 then bufor[i]:=copy(clipboard.astext,symbol+1,clipboard.AsText.length-symbol) else bufor[i]:=copy(clipboard.astext,symbol+1,symbol2-symbol-1);
    inc(i);
    symbol:=symbol2;
  until symbol2=0;
  lwierszy:=i-1;
  for i:=1 to lwierszy do
  begin
    symbol:=0;
    symbol2:=0;
    j:=1;
    repeat
      symbol2:=PosEx(#9,bufor[i],symbol+1);
      if symbol2=0 then pamiec[j,i]:=copy(bufor[i],symbol+1,bufor[i].length-symbol) else pamiec[j,i]:=copy(bufor[i],symbol+1,symbol2-symbol-1);
      inc(j);
      symbol:=symbol2;
    until symbol2=0;
  end;
  lkolumn:=j-1;
  for i:=1 to lwierszy do
    for j:=1 to lkolumn do
      if (i+element.row<=element.RowCount) and (j+element.col<=element.colcount) then element.Cells[j+element.col-1,i+element.row-1]:=pamiec[j,i];
  editingdone(element);
end;

procedure TForm11.MenuItem12Click(Sender: TObject);
begin
  //usun
  for i:=1 to element.rowcount-1 do for j:=1 to element.colcount-1 do if element.iscellselected[j,i] then element.cells[j,i]:='';
  editingdone(element);
end;

procedure TForm11.MenuItem13Click(Sender: TObject);
begin
  //zaznacz wszystko
  element.Selection:=TGridRect(Rect(0,0,element.colcount,element.rowcount))
end;

procedure TForm11.MenuItem8Click(Sender: TObject);
begin
  //cofnij
  element.RowCount:=maxi2+1;
  for i:=1 to element.rowcount-1 do for j:=1 to element.colcount-1 do element.Cells[j,i]:=tabela2[i,j];
  for i:=1 to 1000 do for j:=1 to element.colcount-1 do tabela2[i,j]:=tabela[i,j];
  for i:=1 to element.rowcount-1 do for j:=1 to element.colcount-1 do tabela[i,j]:=element.Cells[j,i];
  maxi2:=maxi;
  maxi:=element.rowcount-1;
end;

procedure TForm11.MenuItem9Click(Sender: TObject);
begin
  //wytnij
  menuitem10.Click;
  menuitem12.click;
end;

procedure TForm11.PageControl1Change(Sender: TObject);
begin
  case pagecontrol1.ActivePageIndex of
    0: element:=stringgrid1;
    1: element:=stringgrid2;
    2: element:=stringgrid3;
    3: element:=stringgrid4;
    4: element:=stringgrid5;
    5: element:=stringgrid6;
    6: element:=stringgrid7;
  end;
  menuitem1.Enabled:=false; menuitem8.Enabled:=false;
  for i:=1 to element.RowCount-1 do for j:=1 to element.colcount-1 do tabela[i,j]:=element.cells[j,i];
  for i:=1 to element.RowCount-1 do for j:=1 to element.colcount-1 do tabela2[i,j]:=element.cells[j,i];
  maxi:=element.rowcount-1;maxi2:=element.rowcount-1;
  element.SetFocus;
  sprawdz;
end;

procedure TForm11.PopupMenu1Popup(Sender: TObject);
begin
  sprawdz;
end;

procedure TForm11.StringGrid1ColRowDeleted(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
begin
  try
    for i:=1 to stringgrid2.RowCount-1 do if strtoint(stringgrid2.Cells[1,i])>=sindex then stringgrid2.Cells[1,i]:=inttostr(strtoint(stringgrid2.Cells[1,i])-1);
    for i:=1 to stringgrid2.RowCount-1 do if strtoint(stringgrid2.Cells[2,i])>=sindex then stringgrid2.Cells[2,i]:=inttostr(strtoint(stringgrid2.Cells[2,i])-1);
    for i:=1 to stringgrid3.RowCount-1 do if strtoint(stringgrid3.Cells[1,i])>=sindex then stringgrid3.Cells[1,i]:=inttostr(strtoint(stringgrid3.Cells[1,i])-1);
  except
  end;
end;

procedure TForm11.StringGrid1ColRowInserted(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
begin
  try
    for i:=1 to stringgrid2.RowCount-1 do if strtoint(stringgrid2.Cells[1,i])>=sindex then stringgrid2.Cells[1,i]:=inttostr(strtoint(stringgrid2.Cells[1,i])+1);
    for i:=1 to stringgrid2.RowCount-1 do if strtoint(stringgrid2.Cells[2,i])>=sindex then stringgrid2.Cells[2,i]:=inttostr(strtoint(stringgrid2.Cells[2,i])+1);
    for i:=1 to stringgrid3.RowCount-1 do if strtoint(stringgrid3.Cells[1,i])>=sindex then stringgrid3.Cells[1,i]:=inttostr(strtoint(stringgrid3.Cells[1,i])+1);
  except
  end;
end;

procedure TForm11.StringGrid1ColRowMoved(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
var si:integer;
begin
  try
    if sindex<tindex then begin
    for i:=1 to stringgrid2.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid2.Cells[1,i])=sindex then si:=i;
      if (strtoint(stringgrid2.Cells[1,i])<=tindex) and (strtoint(stringgrid2.Cells[1,i])>sindex) then stringgrid2.cells[1,i]:=inttostr(strtoint(stringgrid2.cells[1,i])-1);
      if si=i then stringgrid2.cells[1,i]:=inttostr(tindex);
      si:=0;
      if strtoint(stringgrid2.Cells[2,i])=sindex then si:=i;
      if (strtoint(stringgrid2.Cells[2,i])<=tindex) and (strtoint(stringgrid2.Cells[2,i])>sindex) then stringgrid2.cells[2,i]:=inttostr(strtoint(stringgrid2.cells[2,i])-1);
      if si=i then stringgrid2.cells[2,i]:=inttostr(tindex);
     end;
     for i:=1 to stringgrid3.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid3.Cells[1,i])=sindex then si:=i;
      if (strtoint(stringgrid3.Cells[1,i])<=tindex) and (strtoint(stringgrid3.Cells[1,i])>sindex) then stringgrid3.cells[1,i]:=inttostr(strtoint(stringgrid3.cells[1,i])-1);
      if si=i then stringgrid3.cells[1,i]:=inttostr(tindex);
     end;
    end;
    if sindex>tindex then begin
    for i:=1 to stringgrid2.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid2.Cells[1,i])=sindex then si:=i;
      if (strtoint(stringgrid2.Cells[1,i])>=tindex) and (strtoint(stringgrid2.Cells[1,i])<sindex) then stringgrid2.cells[1,i]:=inttostr(strtoint(stringgrid2.cells[1,i])+1);
      if si=i then stringgrid2.cells[1,i]:=inttostr(tindex);
      si:=0;
      if strtoint(stringgrid2.Cells[2,i])=sindex then si:=i;
      if (strtoint(stringgrid2.Cells[2,i])>=tindex) and (strtoint(stringgrid2.Cells[2,i])<sindex) then stringgrid2.cells[2,i]:=inttostr(strtoint(stringgrid2.cells[2,i])+1);
      if si=i then stringgrid2.cells[2,i]:=inttostr(tindex);
     end;
     for i:=1 to stringgrid3.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid3.Cells[1,i])=sindex then si:=i;
      if (strtoint(stringgrid3.Cells[1,i])>=tindex) and (strtoint(stringgrid3.Cells[1,i])<sindex) then stringgrid3.cells[1,i]:=inttostr(strtoint(stringgrid3.cells[1,i])+1);
      if si=i then stringgrid3.cells[1,i]:=inttostr(tindex);
     end;
    end;
  except
  end;
  stringgrid1.beginupdate;
  stringgrid1.row:=sindex;
  stringgrid1.Selection:=TGridRect(Rect(stringgrid1.colcount,stringgrid1.row,0,stringgrid1.row));
  stringgrid1.SetFocus;
  stringgrid1.endupdate;
  editingdone(stringgrid1);
end;

procedure TForm11.HeaderClick(Sender: tstringgrid; IsColumn: Boolean;
  Index: Integer);
begin
  if iscolumn=false then sender.row:=index else sender.col:=index;
  if iscolumn=false then sender.Selection:=TGridRect(Rect(sender.colcount,sender.row,0,sender.row)) else sender.Selection:=TGridRect(Rect(sender.col,sender.rowcount,sender.col,0));
end;

procedure TForm11.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (button=mbright) and (element.EditorMode=false) then popupmenu1.PopUp;
  sprawdz;
end;

procedure TForm11.EditingDone(Sender: tstringgrid);
begin
  for i:=1 to 1000 do for j:=1 to sender.colcount-1 do tabela2[i,j]:=tabela[i,j];
  for i:=1 to sender.RowCount-1 do for j:=1 to sender.colcount-1 do tabela[i,j]:=sender.cells[j,i];
  maxi2:=maxi;
  maxi:=sender.rowcount-1;
  sprawdz;
  menuitem1.Enabled:=true;  menuitem8.Enabled:=true;
end;

procedure TForm11.StringGrid1SelectEditor(Sender: TObject; aCol, aRow: Integer;
  var Editor: TWinControl);
begin
  menuitem9.Enabled:=false; menuitem10.Enabled:=false; menuitem11.Enabled:=false; menuitem12.Enabled:=false; menuitem13.Enabled:=false;
  menuitem2.Enabled:=false; menuitem3.Enabled:=false; menuitem4.Enabled:=false; menuitem5.Enabled:=false; menuitem6.Enabled:=false;
end;

procedure TForm11.StringGrid2ColRowDeleted(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
begin
  try
    for i:=1 to stringgrid4.RowCount-1 do if strtoint(stringgrid4.Cells[3,i])>=sindex then stringgrid4.Cells[3,i]:=inttostr(strtoint(stringgrid4.Cells[3,i])-1);
    for i:=1 to stringgrid5.RowCount-1 do if strtoint(stringgrid5.Cells[2,i])>=sindex then stringgrid5.Cells[2,i]:=inttostr(strtoint(stringgrid5.Cells[2,i])-1);
    for i:=1 to stringgrid6.RowCount-1 do if strtoint(stringgrid6.Cells[4,i])>=sindex then stringgrid6.Cells[4,i]:=inttostr(strtoint(stringgrid6.Cells[4,i])-1);
    for i:=1 to stringgrid7.RowCount-1 do if strtoint(stringgrid7.Cells[3,i])>=sindex then stringgrid7.Cells[3,i]:=inttostr(strtoint(stringgrid7.Cells[3,i])-1);
  except
  end;
end;

procedure TForm11.StringGrid2ColRowInserted(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
begin
  try
    for i:=1 to stringgrid4.RowCount-1 do if strtoint(stringgrid4.Cells[3,i])>=sindex then stringgrid4.Cells[3,i]:=inttostr(strtoint(stringgrid4.Cells[3,i])+1);
    for i:=1 to stringgrid5.RowCount-1 do if strtoint(stringgrid5.Cells[2,i])>=sindex then stringgrid5.Cells[2,i]:=inttostr(strtoint(stringgrid5.Cells[2,i])+1);
    for i:=1 to stringgrid6.RowCount-1 do if strtoint(stringgrid6.Cells[4,i])>=sindex then stringgrid6.Cells[4,i]:=inttostr(strtoint(stringgrid6.Cells[4,i])+1);
    for i:=1 to stringgrid7.RowCount-1 do if strtoint(stringgrid7.Cells[3,i])>=sindex then stringgrid7.Cells[3,i]:=inttostr(strtoint(stringgrid7.Cells[3,i])+1);
  except
  end;
end;

procedure TForm11.StringGrid2ColRowMoved(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
var si:integer;
begin
  try
    if sindex<tindex then begin
    for i:=1 to stringgrid4.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid4.Cells[3,i])=sindex then si:=i;
      if (strtoint(stringgrid4.Cells[3,i])<=tindex) and (strtoint(stringgrid4.Cells[3,i])>sindex) then stringgrid4.cells[3,i]:=inttostr(strtoint(stringgrid4.cells[3,i])-1);
      if si=i then stringgrid4.cells[3,i]:=inttostr(tindex);
     end;
     for i:=1 to stringgrid5.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid5.Cells[2,i])=sindex then si:=i;
      if (strtoint(stringgrid5.Cells[2,i])<=tindex) and (strtoint(stringgrid5.Cells[2,i])>sindex) then stringgrid5.cells[2,i]:=inttostr(strtoint(stringgrid5.cells[2,i])-1);
      if si=i then stringgrid5.cells[2,i]:=inttostr(tindex);
     end;
     for i:=1 to stringgrid6.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid6.Cells[4,i])=sindex then si:=i;
      if (strtoint(stringgrid6.Cells[4,i])<=tindex) and (strtoint(stringgrid6.Cells[4,i])>sindex) then stringgrid6.cells[4,i]:=inttostr(strtoint(stringgrid6.cells[4,i])-1);
      if si=i then stringgrid6.cells[4,i]:=inttostr(tindex);
     end;
     for i:=1 to stringgrid7.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid7.Cells[3,i])=sindex then si:=i;
      if (strtoint(stringgrid7.Cells[3,i])<=tindex) and (strtoint(stringgrid7.Cells[3,i])>sindex) then stringgrid7.cells[3,i]:=inttostr(strtoint(stringgrid7.cells[3,i])-1);
      if si=i then stringgrid7.cells[3,i]:=inttostr(tindex);
     end;
    end;
    if sindex>tindex then begin
    for i:=1 to stringgrid4.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid4.Cells[3,i])=sindex then si:=i;
      if (strtoint(stringgrid4.Cells[3,i])>=tindex) and (strtoint(stringgrid4.Cells[3,i])<sindex) then stringgrid4.cells[3,i]:=inttostr(strtoint(stringgrid4.cells[3,i])+1);
      if si=i then stringgrid4.cells[3,i]:=inttostr(tindex);
     end;
     for i:=1 to stringgrid5.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid5.Cells[2,i])=sindex then si:=i;
      if (strtoint(stringgrid5.Cells[2,i])>=tindex) and (strtoint(stringgrid5.Cells[2,i])<sindex) then stringgrid5.cells[2,i]:=inttostr(strtoint(stringgrid5.cells[2,i])+1);
      if si=i then stringgrid5.cells[2,i]:=inttostr(tindex);
     end;
     for i:=1 to stringgrid6.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid6.Cells[4,i])=sindex then si:=i;
      if (strtoint(stringgrid6.Cells[4,i])>=tindex) and (strtoint(stringgrid6.Cells[4,i])<sindex) then stringgrid6.cells[4,i]:=inttostr(strtoint(stringgrid6.cells[4,i])+1);
      if si=i then stringgrid6.cells[4,i]:=inttostr(tindex);
     end;
     for i:=1 to stringgrid7.RowCount-1 do
     begin
      si:=0;
      if strtoint(stringgrid7.Cells[3,i])=sindex then si:=i;
      if (strtoint(stringgrid7.Cells[3,i])>=tindex) and (strtoint(stringgrid7.Cells[3,i])<sindex) then stringgrid7.cells[3,i]:=inttostr(strtoint(stringgrid7.cells[3,i])+1);
      if si=i then stringgrid7.cells[3,i]:=inttostr(tindex);
     end;
    end;
  except
  end;
  stringgrid2.beginupdate;
  stringgrid2.row:=sindex;
  stringgrid2.Selection:=TGridRect(Rect(stringgrid2.colcount,stringgrid2.row,0,stringgrid2.row));
  stringgrid2.SetFocus;
  stringgrid2.endupdate;
  editingdone(stringgrid2);
end;

procedure TForm11.Button4Click(Sender: TObject);
var bufor:integer;
begin
  if element.row>0 then begin
  bufor:=element.row;
  element.DeleteRow(bufor);
  element.row:=bufor;
  element.Selection:=TGridRect(Rect(element.colcount,element.row,0,element.row));
  element.SetFocus;
  editingdone(element);
  end;
end;

procedure TForm11.Button5Click(Sender: TObject);
begin
  if element.row>0 then begin element.InsertColRow(false,element.row+1); element.Selection:=TGridRect(Rect(element.colcount,element.row,0,element.row)) end;
  if element.row=0 then begin element.InsertColRow(false,element.rowcount-1); element.Selection:=TGridRect(Rect(element.colcount,element.rowcount-1,0,element.rowcount-1)) end;
  element.SetFocus;
  editingdone(element);
end;

procedure TForm11.Button6Click(Sender: TObject);
begin
  if element.row>1 then begin
    element.MoveColRow(false,element.row,element.row-1);
    element.Selection:=TGridRect(Rect(element.colcount,element.row,0,element.row));
    element.SetFocus;
  end;
end;

procedure TForm11.Button7Click(Sender: TObject);
begin
  if (element.row>0) and (element.row<element.RowCount) then begin
    element.InsertColRow(false,element.row+1);
    for i:=0 to element.ColCount-1 do
    element.cells[i,element.row+1]:=element.cells[i,element.row];
    element.Selection:=TGridRect(Rect(element.colcount,element.row,0,element.row));
    element.SetFocus;
    editingdone(element);
  end;
end;

procedure TForm11.Button2Click(Sender: TObject);
begin
  if (element.row>0) and (element.row<element.rowcount-1) then
  begin
    element.MoveColRow(false,element.row,element.row+1);
    element.Selection:=TGridRect(Rect(element.colcount,element.row,0,element.row));
    element.SetFocus;
  end;
end;

procedure TForm11.Button3Click(Sender: TObject);
var blad,blad2:boolean;
  xxx:real; yyy,symbol,symbol2:integer; zzz: array[1..5,1..100,1..1000] of string; liczbawariantow:array [1..5,1..1000] of integer;
begin
  button3.setfocus;
  blad:=false;
  for k:=1 to 5 do
  begin
    case k of
      1: element:=stringgrid3;
      2: element:=stringgrid4;
      3: element:=stringgrid5;
      4: element:=stringgrid6;
      5: element:=stringgrid7;
    end;
    for i:=1 to element.RowCount-1 do
    begin
     element.cells[element.colcount-1,i]:=element.cells[element.colcount-1,i]+' ';
     element.cells[element.colcount-1,i]:=stringreplace(element.cells[element.colcount-1,i],';',' ',[rfReplaceAll]);
     element.cells[element.colcount-1,i]:=stringreplace(element.cells[element.colcount-1,i],',',' ',[rfReplaceAll]);
     element.cells[element.colcount-1,i]:=stringreplace(element.cells[element.colcount-1,i],'  ',' ',[rfReplaceAll]);
     symbol:=0;
     symbol2:=0;
     j:=1;
     repeat
       symbol2:=posex(' ',element.cells[element.colcount-1,i],symbol+1);
       if (symbol2>0) or (symbol>0) then zzz[k,j,i]:=copy(element.cells[element.colcount-1,i],symbol+1,symbol2-symbol-1);
       symbol:=symbol2;
       if ((symbol2>0) or (symbol>0)) and (length(element.cells[element.colcount-1,i])>1) then if (strtointdef(zzz[k,j,i],0)=0) or (strtointdef(zzz[k,j,i],0)>warianty) then begin blad:=true; pagecontrol1.ActivePageIndex:=k+1; element.row:=i;element.Col:=element.colcount-1; element.SetFocus; end;
       inc(j);
     until symbol2=0 ;
     liczbawariantow[k,i]:=j-2;
    end;
  end;
  for i:=1 to stringgrid1.RowCount-1 do if not trystrtofloat(stringgrid1.Cells[1,i],xxx) then begin blad:=true; pagecontrol1.ActivePageIndex:=0; stringgrid1.row:=i;stringgrid1.Col:=1; stringgrid1.SetFocus; end;
  for i:=1 to stringgrid1.RowCount-1 do if not trystrtofloat(stringgrid1.Cells[2,i],xxx) then begin blad:=true; pagecontrol1.ActivePageIndex:=0; stringgrid1.row:=i;stringgrid1.Col:=2; stringgrid1.SetFocus; end;
  try for i:=1 to stringgrid1.RowCount-1 do for j:=1 to i-1 do
    if strtofloat(stringgrid1.Cells[2,i])*1000+strtofloat(stringgrid1.Cells[1,i])=strtofloat(stringgrid1.Cells[2,j])*1000+strtofloat(stringgrid1.Cells[1,j])
    then begin blad:=true; pagecontrol1.ActivePageIndex:=0; stringgrid1.row:=i; stringgrid1.Col:=2; stringgrid1.SetFocus; end;
  except begin blad:=true; pagecontrol1.ActivePageIndex:=0; stringgrid1.row:=i; stringgrid1.Col:=2; stringgrid1.SetFocus; end; end;

  for i:=1 to stringgrid2.RowCount-1 do if not ((trystrtoint(stringgrid2.Cells[1,i],yyy)) and (yyy<=stringgrid1.rowcount-1) and (yyy>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=1; stringgrid2.row:=i;stringgrid2.Col:=1; stringgrid2.SetFocus; end;
  for i:=1 to stringgrid2.RowCount-1 do if not ((trystrtoint(stringgrid2.Cells[2,i],yyy)) and (yyy<=stringgrid1.rowcount-1) and (yyy>=0) and (stringgrid2.Cells[2,i]<>stringgrid2.Cells[1,i])) then begin blad:=true; pagecontrol1.ActivePageIndex:=1; stringgrid2.row:=i;stringgrid2.Col:=2; stringgrid2.SetFocus; end;
  for i:=1 to stringgrid2.RowCount-1 do if not ((trystrtoint(stringgrid2.Cells[3,i],yyy)) and (yyy<=4) and (yyy>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=1; stringgrid2.row:=i;stringgrid2.Col:=3; stringgrid2.SetFocus; end;
  for i:=1 to stringgrid2.RowCount-1 do begin blad2:=true; for j:=1 to Lprz do if stringgrid2.cells[4,i]=nazwaprz[j] then blad2:=false; if blad2=true then begin blad:=true; pagecontrol1.ActivePageIndex:=1; stringgrid2.row:=i;stringgrid2.Col:=4; stringgrid2.SetFocus; end; end;  
  try for i:=1 to stringgrid2.RowCount-1 do for j:=1 to i-1 do
    if ((strtofloat(stringgrid2.Cells[2,i])=strtofloat(stringgrid2.Cells[2,j])) and (strtofloat(stringgrid2.Cells[1,i])=strtofloat(stringgrid2.Cells[1,j]))) or ((strtofloat(stringgrid2.Cells[1,i])=strtofloat(stringgrid2.Cells[2,j])) and (strtofloat(stringgrid2.Cells[2,i])=strtofloat(stringgrid2.Cells[1,j])))
    then begin blad:=true; pagecontrol1.ActivePageIndex:=1; stringgrid2.row:=i; stringgrid2.Col:=2; stringgrid2.SetFocus; end;
  except begin blad:=true; pagecontrol1.ActivePageIndex:=1; stringgrid2.row:=i; stringgrid2.Col:=2; stringgrid2.SetFocus; end; end;

  for i:=1 to stringgrid3.RowCount-1 do if not ((trystrtoint(stringgrid3.Cells[1,i],yyy)) and (yyy<=stringgrid1.rowcount-1) and (yyy>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=2; stringgrid3.row:=i;stringgrid3.Col:=1; stringgrid3.SetFocus; end;
  for i:=1 to stringgrid3.RowCount-1 do begin blad2:=true; for j:=1 to 5 do if stringgrid3.cells[2,i]=stringgrid3.columns.items[1].PickList.Strings[j-1] then blad2:=false; if blad2=true then begin blad:=true; pagecontrol1.ActivePageIndex:=2; stringgrid3.row:=i;stringgrid3.Col:=2; stringgrid3.SetFocus; end; end;
  for i:=1 to stringgrid3.RowCount-1 do if not ((trystrtofloat(stringgrid3.Cells[3,i],xxx)) and (xxx<=360) and (xxx>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=2; stringgrid3.row:=i;stringgrid3.Col:=3; stringgrid3.SetFocus; end;
  for j:=4 to 9 do for i:=1 to stringgrid3.RowCount-1 do if not trystrtofloat(stringgrid3.Cells[j,i],xxx)  then begin blad:=true; pagecontrol1.ActivePageIndex:=2; stringgrid3.row:=i;stringgrid3.Col:=j; stringgrid3.SetFocus; end;


  for i:=1 to stringgrid4.RowCount-1 do if not trystrtofloat(stringgrid4.Cells[1,i],xxx)  then begin blad:=true; pagecontrol1.ActivePageIndex:=3; stringgrid4.row:=i;stringgrid4.Col:=1; stringgrid4.SetFocus; end;
  for i:=1 to stringgrid4.RowCount-1 do if not ((trystrtofloat(stringgrid4.Cells[2,i],xxx)) and (xxx<=360) and (xxx>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=3; stringgrid4.row:=i;stringgrid4.Col:=2; stringgrid4.SetFocus; end;
  for i:=1 to stringgrid4.RowCount-1 do if not ((trystrtoint(stringgrid4.Cells[3,i],yyy)) and (yyy<=stringgrid2.rowcount-1) and (yyy>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=3; stringgrid4.row:=i;stringgrid4.Col:=3; stringgrid4.SetFocus; end;
  for i:=1 to stringgrid4.RowCount-1 do if not ((trystrtofloat(stringgrid4.Cells[4,i],xxx)) and (xxx<=1) and (xxx>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=3; stringgrid4.row:=i;stringgrid4.Col:=4; stringgrid4.SetFocus; end;

  for i:=1 to stringgrid5.RowCount-1 do if not trystrtofloat(stringgrid5.Cells[1,i],xxx)  then begin blad:=true; pagecontrol1.ActivePageIndex:=4; stringgrid5.row:=i;stringgrid5.Col:=1; stringgrid5.SetFocus; end;
  for i:=1 to stringgrid5.RowCount-1 do if not ((trystrtoint(stringgrid5.Cells[2,i],yyy)) and (yyy<=stringgrid2.rowcount-1) and (yyy>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=4; stringgrid5.row:=i;stringgrid5.Col:=2; stringgrid5.SetFocus; end;
  for i:=1 to stringgrid5.RowCount-1 do if not ((trystrtofloat(stringgrid5.Cells[3,i],xxx)) and (xxx<=1) and (xxx>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=4; stringgrid5.row:=i;stringgrid5.Col:=3; stringgrid5.SetFocus; end;

  for i:=1 to stringgrid6.RowCount-1 do if not trystrtofloat(stringgrid6.Cells[1,i],xxx)  then begin blad:=true; pagecontrol1.ActivePageIndex:=5; stringgrid6.row:=i;stringgrid6.Col:=1; stringgrid6.SetFocus; end;
  for i:=1 to stringgrid6.RowCount-1 do if not trystrtofloat(stringgrid6.Cells[2,i],xxx)  then begin blad:=true; pagecontrol1.ActivePageIndex:=5; stringgrid6.row:=i;stringgrid6.Col:=2; stringgrid6.SetFocus; end;
  for i:=1 to stringgrid6.RowCount-1 do if not ((trystrtofloat(stringgrid6.Cells[3,i],xxx)) and (xxx<=360) and (xxx>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=5; stringgrid6.row:=i;stringgrid6.Col:=3; stringgrid6.SetFocus; end;
  for i:=1 to stringgrid6.RowCount-1 do if not ((trystrtoint(stringgrid6.Cells[4,i],yyy)) and (yyy<=stringgrid2.rowcount-1) and (yyy>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=5; stringgrid6.row:=i;stringgrid6.Col:=4; stringgrid6.SetFocus; end;
  for i:=1 to stringgrid6.RowCount-1 do if not ((trystrtofloat(stringgrid6.Cells[5,i],xxx)) and (xxx<=1) and (xxx>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=5; stringgrid6.row:=i;stringgrid6.Col:=5; stringgrid6.SetFocus; end;
  for i:=1 to stringgrid6.RowCount-1 do if not ((trystrtofloat(stringgrid6.Cells[6,i],xxx)) and (xxx<=1) and (xxx>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=5; stringgrid6.row:=i;stringgrid6.Col:=6; stringgrid6.SetFocus; end;

  for i:=1 to stringgrid7.RowCount-1 do if not trystrtofloat(stringgrid7.Cells[1,i],xxx)  then begin blad:=true; pagecontrol1.ActivePageIndex:=6; stringgrid7.row:=i;stringgrid7.Col:=1; stringgrid7.SetFocus; end;
  for i:=1 to stringgrid7.RowCount-1 do if not trystrtofloat(stringgrid7.Cells[2,i],xxx)  then begin blad:=true; pagecontrol1.ActivePageIndex:=6; stringgrid7.row:=i;stringgrid7.Col:=2; stringgrid7.SetFocus; end;
  for i:=1 to stringgrid7.RowCount-1 do if not ((trystrtoint(stringgrid7.Cells[3,i],yyy)) and (yyy<=stringgrid2.rowcount-1) and (yyy>=0)) then begin blad:=true; pagecontrol1.ActivePageIndex:=6; stringgrid7.row:=i;stringgrid7.Col:=3; stringgrid7.SetFocus; end;
  if blad=false then begin
    Lw:=stringgrid1.RowCount-1;
    for i:=1 to Lw do begin Xw[i]:=strtofloat(stringgrid1.Cells[1,i]); Yw[i]:=strtofloat(stringgrid1.Cells[2,i]); end;
    Le:=stringgrid2.rowcount-1;
    for i:=1 to Le do begin Wp[i]:=strtoint(stringgrid2.Cells[1,i]); Wk[i]:=strtoint(stringgrid2.Cells[2,i]); Typs[i]:=strtoint(stringgrid2.Cells[3,i]);
      for j:=1 to Lprz do if Nazwaprz[j]=stringgrid2.Cells[4,i] then Prz[i]:=j-1; end;
    Lwar:=stringgrid3.rowcount-1;
    for i:=1 to Lwar do begin s[i]:=strtoint(stringgrid3.Cells[1,i]); fipod[i]:=strtofloat(stringgrid3.cells[3,i]);
      DV[i]:=strtofloat(stringgrid3.cells[4,i]);DH[i]:=strtofloat(stringgrid3.cells[5,i]);DM[i]:=strtofloat(stringgrid3.cells[6,i]);
      kV[i]:=strtofloat(stringgrid3.cells[7,i]);kH[i]:=strtofloat(stringgrid3.cells[8,i]);kM[i]:=strtofloat(stringgrid3.cells[9,i]);
      for j:=1 to warianty do wariantPod[i,j]:=false; for j:=1 to liczbawariantow[1,i] do wariantPod[i,strtointdef(zzz[1,j,i],0)]:=true;
      case stringgrid3.cells[2,i] of
        '--M':rpod[i]:=1;
        'VHM':rpod[i]:=2;
        'VH-':rpod[i]:=3;
        'V-M':rpod[i]:=4;
        'V--':rpod[i]:=5;
      end;
    end;
    RowsPp:=stringgrid4.rowcount-1;
    for i:=1 to RowsPp do begin P[i]:=strtofloat(stringgrid4.cells[1,i]); alfaP[i]:=strtofloat(stringgrid4.cells[2,i]); np[i]:=strtoint(stringgrid4.cells[3,i]); xp[i]:=strtofloat(stringgrid4.cells[4,i]); for j:=1 to warianty do wariantP[i,j]:=false; for j:=1 to liczbawariantow[2,i] do wariantP[i,strtointdef(zzz[2,j,i],0)]:=true; end;
    RowsPm:=stringgrid5.rowcount-1;
    for i:=1 to RowsPm do begin Pm[i]:=strtofloat(stringgrid5.cells[1,i]); nm[i]:=strtoint(stringgrid5.cells[2,i]); xm[i]:=strtofloat(stringgrid5.cells[3,i]); for j:=1 to warianty do wariantM[i,j]:=false; for j:=1 to liczbawariantow[3,i] do wariantM[i,strtointdef(zzz[3,j,i],0)]:=true  end;
    RowsPq:=stringgrid6.rowcount-1;
    for i:=1 to RowsPq do begin Pqi[i]:=strtofloat(stringgrid6.cells[1,i]); Pqj[i]:=strtofloat(stringgrid6.cells[2,i]); alfaq[i]:=strtofloat(stringgrid6.cells[3,i]);
      nq[i]:=strtoint(stringgrid6.cells[4,i]); xqi[i]:=strtofloat(stringgrid6.cells[5,i]); xqj[i]:=strtofloat(stringgrid6.cells[6,i]); for j:=1 to warianty do wariantQ[i,j]:=false; for j:=1 to liczbawariantow[4,i] do wariantQ[i,strtointdef(zzz[4,j,i],0)]:=true end;
    RowsPt:=stringgrid7.rowcount-1;
    for i:=1 to RowsPt do begin Tg[i]:=strtofloat(stringgrid7.cells[1,i]); Td[i]:=strtofloat(stringgrid7.cells[2,i]); nt[i]:=strtoint(stringgrid7.cells[3,i]); for j:=1 to warianty do wariantT[i,j]:=false; for j:=1 to liczbawariantow[5,i] do wariantT[i,strtointdef(zzz[5,j,i],0)]:=true  end;
    //zapiszwstecz
    form11open:=true;
    close;
  end
  else MessageDlg('Błąd!', 'Nie wszystkie pola zostały wypełnione prawidłowo. Należy je poprawić.', mtError, [mbOK], 0);
end;

procedure TForm11.Button12Click(Sender: TObject);
begin
  close;
end;

procedure TForm11.ColRowMoved(Sender: tstringgrid; IsColumn: Boolean;
  sIndex, tIndex: Integer);
begin
  sender.beginupdate;
  sender.row:=sindex;
  sender.Selection:=TGridRect(Rect(sender.colcount,sender.row,0,sender.row));
  sender.SetFocus;
  sender.endupdate;
  editingdone(sender);
end;

procedure tform11.sprawdz;
begin
  menuitem2.Enabled:=false; menuitem3.enabled:=false; menuitem5.enabled:=false;   menuitem6.Enabled:=false;
  menuitem9.Enabled:=false; menuitem10.enabled:=false; menuitem12.enabled:=false; menuitem13.enabled:=false;
  if (clipboard.HasFormat(cf_text)) and (element.editormode=false) then begin menuitem4.Enabled:=true; menuitem11.Enabled:=true end else begin menuitem4.Enabled:=false; menuitem11.Enabled:=false; end;
  if element.EditorMode=false then for i:=1 to element.rowCount-1 do for j:=1 to element.colcount-1 do if element.iscellselected[j,i] then
  begin menuitem2.Enabled:=true; menuitem3.enabled:=true; menuitem5.enabled:=true;  menuitem9.Enabled:=true; menuitem10.enabled:=true; menuitem12.enabled:=true; end;
  if element.EditorMode=false then for i:=1 to element.rowCount-1 do for j:=1 to element.colcount-1 do if not element.iscellselected[j,i] then
  begin menuitem6.Enabled:=true; menuitem13.Enabled:=true; end;
end;

end.

