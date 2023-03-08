unit Unit12;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, ColorBox, CheckLst, ShellAPI, MouseAndKeyInput, LCLType;

type

  { TForm12 }

  TForm12 = class(TForm)
    Button1: TButton;
    Button12: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckGroup1: TCheckGroup;
    CheckGroup2: TCheckGroup;
    ColorButton1: TColorButton;
    ColorButton10: TColorButton;
    ColorButton11: TColorButton;
    ColorButton12: TColorButton;
    ColorButton13: TColorButton;
    ColorButton14: TColorButton;
    ColorButton15: TColorButton;
    ColorButton16: TColorButton;
    ColorButton17: TColorButton;
    ColorButton2: TColorButton;
    ColorButton3: TColorButton;
    ColorButton4: TColorButton;
    ColorButton5: TColorButton;
    ColorButton6: TColorButton;
    ColorButton7: TColorButton;
    ColorButton8: TColorButton;
    ColorButton9: TColorButton;
    ComboBox1: TComboBox;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit1: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListView1: TListView;
    ListView2: TListView;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    procedure Button12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
    procedure CheckGroup2ItemClick(Sender: TObject; Index: integer);
    procedure ColorButton1Click(Sender: tcolorbutton);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListView1Enter(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView2Enter(Sender: TObject);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure edit3Change(Sender: TObject);
    procedure edit4Change(Sender: TObject);
    procedure edit5Change(Sender: TObject);
    procedure edit6Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Chang(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form12: TForm12;
  dane: array [1..100] of string;

implementation

{$R *.lfm}

{ TForm12 }

uses Unit1;

procedure TForm12.Button3Click(Sender: TObject);
var licznik:integer;
    stryng:string;
    litera:char;
begin
  button3.setfocus;
  licznik:=0;
  for i:=1 to 13 do if checkgroup1.Checked[i-1]=true then texton[i]:=true else texton[i]:=false;
  for i:=1 to 13 do if checkgroup2.Checked[i-1]=true then textoff[i]:=true else textoff[i]:=false;
  if bar[4]=true then for i:=1 to 13 do tekst[i]:=texton[i] else for i:=1 to 13 do tekst[i]:=textoff[i];
  if trystrtofloat(edit1.text,skok) then if (skok>0) then inc(licznik);
  if trystrtoint(edit2.text,ES) then if (ES>0) and (ES<=1000) then inc(licznik);
  if trystrtoint(edit3.text,skalap) then if (skalap>=0) and (skalap<=100) then inc(licznik);
  if trystrtoint(edit6.text,skalaq) then if (skalaq>=0) and (skalaq<=100) then inc(licznik);
  if trystrtofloat(edit4.text,skalawew) then if (skalawew>=0) and (skalawew<=1600) then inc(licznik);
  if trystrtofloat(edit5.text,skaladisp) then if (skaladisp>=0) and (skaladisp<=1600) then inc(licznik);
  if trystrtofloat(edit7.text,autosave) then if (autosave>=0) then inc(licznik);
  if trystrtoint(Edit8.text,rozmiar[1]) then if (rozmiar[1]>0) then inc(licznik);
  if trystrtoint(Edit9.text,rozmiar[2]) then if (rozmiar[2]>0) then inc(licznik);
  if checkbox2.checked=true then rozmiar[3]:=1 else rozmiar[3]:=0;   
  if checkbox3.checked=true then rozmiar[4]:=1 else rozmiar[4]:=0;
  if licznik<>9 then MessageDlg('Błąd!', 'Sprawdź wszystkie liczby.', mterror, [mbOK], 0);
  if licznik=9 then
  begin
    for i:=1 to 17 do kolor[i]:=(findcomponent('colorbutton'+inttostr(i)) as tcolorbutton).buttonColor;
    motyw:=combobox1.text;
    assignfile(plik,ExtractFilePath(Application.ExeName)+'options');
    rewrite(plik);
    writeln(plik,'Options');
    writeln(plik,skalawew);
    writeln(plik,skaladisp);
    writeln(plik,skalaP);
    writeln(plik,skalaQ);
    writeln(plik,ES);
    writeln(plik,autosave);
    writeln(plik,skok);
    writeln(plik,bln);
    for i:=1 to 13 do if texton[i]=true then writeln(plik,1) else writeln(plik,0);
    for i:=1 to 13 do if textoff[i]=true then writeln(plik,1) else writeln(plik,0);
    for i:=1 to 17 do writeln(plik,colortostring(kolor[i]));
    for i:=1 to 4 do writeln(plik,inttostr(rozmiar[i]));
    writeln(plik,inttostr(listview1.items.count-1));
    for i:=0 to listview1.Items.count-1 do begin writeln(plik,listview1.Items.Item[i].Caption);
      if listview1.Items.Item[i].Checked=true then writeln(plik,'tak') else writeln(plik,'nie');
    end;
    writeln(plik,inttostr(listview2.items.count-1));
    for i:=0 to listview2.Items.count-1 do begin writeln(plik,listview2.Items.Item[i].Caption);
      if listview2.Items.Item[i].Checked=true then writeln(plik,'tak') else writeln(plik,'nie');
    end;
    closefile(plik);
    assignfile(plik,ExtractFilePath(Application.ExeName)+'keyscuts.txt');
    reset(plik);
    repeat
      read(plik,litera);
      readln(plik,stryng);
      case stryng of
        ' draw':keyscut[1]:=litera;
        ' delete':keyscut[2]:=litera;
        ' force':keyscut[3]:=litera;
        ' distributed':keyscut[4]:=litera;
        ' moment':keyscut[5]:=litera;
        ' temperature':keyscut[6]:=litera;
        ' support':keyscut[7]:=litera;
        ' move':keyscut[8]:=litera;
        ' copy':keyscut[9]:=litera;
        ' mirror':keyscut[10]:=litera;
        ' divide':keyscut[11]:=litera;
        ' preview':keyscut[12]:=litera;
        ' polarangle':keyscut[13]:=litera;
        ' sectionmanager':keyscut[14]:=litera;
        ' projectmanager':keyscut[15]:=litera;
        ' staticsolve':keyscut[16]:=litera;
        ' liniawplywu':keyscut[17]:=litera;
        ' support-XYM':keyscut[18]:=litera;
        ' support-XM':keyscut[19]:=litera;
        ' support-XY':keyscut[20]:=litera;
        ' support-X':keyscut[21]:=litera;
        ' support-M':keyscut[22]:=litera;
        ' intersections':keyscut[23]:=litera;
        ' staticseparate':keyscut[24]:=litera;
        ' bucklingsolve':keyscut[25]:=litera;
        ' back':keyscut[26]:=litera;
        ' zoom':keyscut[27]:=litera;
        ' rotate':keyscut[28]:=litera;
        ' deleteload':keyscut[29]:=litera;
      end;
    until eof(plik);
    closefile(plik);
    form12open:=true;
    close;
  end;
end;

procedure TForm12.Button4Click(Sender: TObject);
begin
  if listview1.itemindex>=0then begin
    listview1.SetFocus;
    if listview1.itemindex<listview1.Items.count-1 then
    begin listview1.Items.Exchange(listview1.itemindex,listview1.itemindex+1);
          listview1.ItemIndex:=listview1.itemindex-1;
          KeyInput.Press(VK_UP); KeyInput.Press(VK_DOWN); end;
  end;
  if listview2.itemindex>=0 then begin
    listview2.SetFocus;
    if listview2.itemindex<listview2.Items.count-1 then
    begin listview2.Items.Exchange(listview2.itemindex,listview2.itemindex+1);
          listview2.ItemIndex:=listview2.itemindex-1;
          KeyInput.Press(VK_UP); KeyInput.Press(VK_DOWN); end;
  end;
end;

procedure TForm12.Button5Click(Sender: TObject);
var Item: TListItem;
begin
  if listview1.itemindex>=0 then begin
    Item := ListView1.Items.add;
    listview1.Items.move(listview1.Items.count-1,listview1.ItemIndex+1);
    item.ImageIndex:=maleikony+1;
    Item.Caption :='---------------';
    listview1.SetFocus;
    KeyInput.Press(VK_DOWN);
  end;
  if listview2.itemindex>=0 then begin
    Item := ListView2.Items.add;
    listview2.Items.move(listview2.Items.count-1,listview2.ItemIndex+1);
    listview2.ItemIndex:=listview2.ItemIndex+1;
    item.ImageIndex:=maleikony+1;
    Item.Caption :='---------------';
    listview2.SetFocus;
    KeyInput.Press(VK_DOWN);
  end;
end;

procedure TForm12.Button6Click(Sender: TObject);
var bufor:integer;
begin
  if listview1.ItemIndex>=0 then begin listview1.setfocus; button6.enabled:=false;
    bufor:=listview1.ItemIndex;
    listview1.Items.Move(listview1.itemindex,listview1.Items.Count-1); listview1.Items.Delete(listview1.Items.Count-1);
    listview1.itemindex:=bufor;
    if listview1.Items[listview1.itemindex].Caption='---------------' then button6.Enabled:=true; end;
  if listview2.ItemIndex>=0 then begin listview2.setfocus; button6.enabled:=false;
    bufor:=listview2.ItemIndex;
    listview2.Items.Move(listview2.itemindex,listview2.Items.Count-1); listview2.Items.Delete(listview2.Items.Count-1);
    listview2.itemindex:=bufor;
    if listview2.Items[listview2.itemindex].Caption='---------------' then button6.Enabled:=true; end;
end;

procedure TForm12.CheckGroup1ItemClick(Sender: TObject; Index: integer);
begin
  for i:=0 to 12 do if checkgroup1.Checked[i]=false then
  begin
    checkgroup2.Checked[i]:=false;
  end;
end;

procedure TForm12.CheckGroup2ItemClick(Sender: TObject; Index: integer);
begin
  for i:=0 to 12 do if checkgroup1.Checked[i]=false then
  begin
    checkgroup2.Checked[i]:=false;
  end;
end;

procedure TForm12.ColorButton1Click(Sender: tcolorbutton);
begin
  sender.Caption:=inttohex(sender.buttonColor,6);
 end;

procedure TForm12.ComboBox1Change(Sender: TObject);
var stryng:string;
begin
  bln:=copy(dane[combobox1.ItemIndex],1,dane[combobox1.ItemIndex].Length-4) ;
  assignfile(plik,ExtractFilePath(Application.ExeName)+'images/'+bln+'.mot');
  reset(plik);
  readln(plik);
  readln(plik);
  readln(plik);
  readln(plik);
  readln(plik);
  readln(plik);
  readln(plik);
  readln(plik);
  readln(plik);
  for i:=1 to 17 do begin
    readln(plik,stryng);
    (findcomponent('colorbutton'+inttostr(i)) as tcolorbutton).ButtonColor:=stringtocolor(stryng);
  end;
  closefile(plik);
end;

procedure TForm12.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button12.setfocus;form12.FormStyle:=fsstayontop;
end;

procedure TForm12.Button12Click(Sender: TObject);
begin
  close;
end;

procedure TForm12.Button1Click(Sender: TObject);
begin
  button3.setfocus;
  form12.FormStyle:=fsnormal;
  ShellExecute(0, 'open', PChar(ExtractFilePath(Application.ExeName)+'keyscuts.txt'), nil, '', 1);
end;

procedure TForm12.Button2Click(Sender: TObject);
begin
  if listview1.itemindex>=0then begin
    listview1.SetFocus;
    if listview1.itemindex>0 then
    begin listview1.Items.Exchange(listview1.itemindex,listview1.itemindex-1);
          listview1.itemindex:=listview1.itemindex+1;
          KeyInput.Press(VK_DOWN); KeyInput.Press(VK_UP); end;
  end;
  if listview2.itemindex>=0then begin
    listview2.SetFocus;
    if listview2.itemindex>0 then
    begin listview2.Items.Exchange(listview2.itemindex,listview2.itemindex-1);
          listview2.itemindex:=listview2.itemindex+1;
          KeyInput.Press(VK_DOWN); KeyInput.Press(VK_UP); end;
  end;
end;

procedure TForm12.FormShow(Sender: TObject);
var   SR: TSearchRec;
    plik2:text;
    item: TListItem;
begin
  if (FindFirst('images\' + '*.mot', faAnyFile, SR) = 0) then
  begin
    combobox1.clear;
    i:=-1;
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        inc(i);
        dane[i]:=SR.name;
        assignfile(plik2,'images\'+SR.Name);
        reset(plik2);
        readln(plik2,motyw);
        combobox1.Items.Add(motyw);
        closefile(plik2);
      end;
    for i:=0 to combobox1.Items.Count-1 do if bln+'.mot'=dane[i] then combobox1.ItemIndex:=i;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  for i:=1 to 13 do if texton[i]=true then checkgroup1.Checked[i-1]:=true else checkgroup1.Checked[i-1]:=false;
  for i:=1 to 13 do if textoff[i]=true then checkgroup2.Checked[i-1]:=true else checkgroup2.Checked[i-1]:=false;
  edit1.text:=floattostr(skok);
  edit2.text:=inttostr(ES);
  edit3.text:=inttostr(skalap);
  edit4.text:=floattostr(skalawew);
  edit5.text:=floattostr(skaladisp);
  edit6.text:=inttostr(skalaq);
  edit7.text:=floattostrf(autosave,fffixed,5,2);
  Edit8.text:=inttostr(rozmiar[1]);
  Edit9.text:=inttostr(rozmiar[2]);
  if rozmiar[3]=1 then checkbox2.checked:=true else checkbox2.checked:=false; 
  if rozmiar[4]=1 then checkbox3.checked:=true else checkbox3.checked:=false;
  for i:=1 to 17 do (findcomponent('colorbutton'+inttostr(i)) as tcolorbutton).buttonColor:=clwhite;
  for i:=1 to 17 do (findcomponent('colorbutton'+inttostr(i)) as tcolorbutton).buttonColor:=kolor[i];

  i:=-1; repeat inc(i); if listview1.Items.Item[i].Caption='---------------' then begin listview1.Items.exchange(i,listview1.Items.Count-1); listview1.Items.Delete(listview1.Items.Count-1); i:=i-1; end; until i>=listview1.items.count-1;
  for i:=0 to liczbatool do
    begin
      if nazwatool[i]='---------------' then
      begin
        Item := ListView1.Items.add;
        listview1.Items.exchange(listview1.Items.count-1,i);
        item.ImageIndex:=maleikony+9;
        Item.Caption :='---------------';
        if checktool[i]=true then item.Checked:=true else item.Checked:=false;
      end;
      if nazwatool[i]<>'---------------' then
      begin
        j:=-1;
        repeat inc(j) until listview1.Items.Item[j].Caption=nazwatool[i];
        listview1.Items.Exchange(j,i);
        if checktool[i]=true then listview1.Items.Item[i].Checked:=true else listview1.Items.Item[i].Checked:=false;
      end;
    end;
  i:=-1; repeat inc(i); if listview2.Items.Item[i].Caption='---------------' then begin listview2.Items.exchange(i,listview2.Items.Count-1); listview2.Items.Delete(listview2.Items.Count-1); i:=i-1;  end; until i>=listview2.items.count-1;
  for i:=0 to liczbatool1 do
    begin
      if nazwatool1[i]='---------------' then  begin  Item := ListView2.Items.add;
                                                      listview2.Items.exchange(listview2.Items.count-1,i);
                                                      item.ImageIndex:=maleikony+9;
                                                      Item.Caption :='---------------';
                                                      if checktool1[i]=true then item.Checked:=true else item.Checked:=false; end
      else begin j:=-1; repeat inc(j) until listview2.Items.Item[j].Caption=nazwatool1[i]; listview2.Items.Exchange(j,i); if checktool1[i]=true then listview2.Items.Item[i].Checked:=true else listview2.Items.Item[i].Checked:=false; end;
    end;
  listview1.SmallImages:=form1.imagelist1;
  listview2.SmallImages:=form1.imagelist1;
end;

procedure TForm12.ListView1Enter(Sender: TObject);
begin
  listview2.itemindex:=-1;
end;

procedure TForm12.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  button6.enabled:=false;
  if item.Caption='---------------' then button6.Enabled:=true;
end;

procedure TForm12.ListView2Enter(Sender: TObject);
begin
  listview1.itemindex:=-1;
end;

procedure TForm12.ListView2SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  button6.enabled:=false;
  if item.Caption='---------------' then button6.Enabled:=true;
end;

procedure TForm12.edit3Change(Sender: TObject);
var gg:integer;
begin
  if TryStrToInt(edit3.Text,gg) then trackbar3.position:=gg;
end;

procedure TForm12.edit4Change(Sender: TObject);
var gg:real;
begin
  if TryStrTofloat(edit4.Text,gg) then trackbar2.position:=trunc(sqrt(sqrt(gg*1000000)));
end;

procedure TForm12.edit5Change(Sender: TObject);
var gg:real;
begin
  if TryStrTofloat(edit5.Text,gg) then trackbar1.position:=trunc(sqrt(sqrt(gg*1000000)));
end;

procedure TForm12.edit6Change(Sender: TObject);
var gg:integer;
begin
  if TryStrToInt(edit6.Text,gg) then trackbar4.position:=gg;
end;

procedure TForm12.TrackBar1Change(Sender: TObject);
begin
  if trackbar1.focused=true then edit5.text:=floattostr(sqr(sqr(trackbar1.position))/1000000);
end;

procedure TForm12.TrackBar2Change(Sender: TObject);
begin
  if trackbar2.focused=true then edit4.text:=floattostr(sqr(sqr(trackbar2.position))/1000000);
end;

procedure TForm12.TrackBar3Chang(Sender: TObject);
begin
  edit3.text:=inttostr(trackbar3.position);
end;

procedure TForm12.TrackBar4Change(Sender: TObject);
begin
  edit6.text:=inttostr(trackbar4.position);
end;

end.

