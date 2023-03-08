unit Unit8;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ActnList,
  StdCtrls, unit9, unit10;

type

  { TForm8 }

  TForm8 = class(TForm)
    Button1: TButton;
    Button12: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    procedure Button12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form8: TForm8;
  BNazwaPrz:String;
  BA,BJ,Bi,Bh,BE,Bro,Bat:real;
  h,bd,bg,g,td,tg,A,Jx,isrodek:real;
  form9open,form10open:boolean;

implementation

{$R *.lfm}

uses
  Unit1;

{ TForm8 }

procedure TForm8.FormShow(Sender: TObject);
begin
  with listbox1 do items.Clear;
  for i:=1 to Lprz do with listbox1 do items.add(Nazwaprz[i]);
  if wyswietl=0 then button3.Enabled:=true else button3.enabled:=false;
  form8.Left:=form1.left+form1.Width-form8.width-10;
  form8.top:=form1.top+form1.ToolBar1.Height+70;
end;

procedure TForm8.ListBox1Click(Sender: TObject);
begin

end;

procedure TForm8.Button4Click(Sender: TObject);
begin
  button3.setfocus;
  if (listbox1.itemindex>-1) and (LPrz>1) then
  begin
   for i:=listbox1.itemindex+1 to Lprz do
   begin
    Nazwaprz[i]:=Nazwaprz[i+1];
    Ai[i]:=Ai[i+1];Ji[i]:=Ji[i+1];ii[i]:=ii[i+1];hi[i]:=hi[i+1];Ei[i]:=Ei[i+1];gi[i]:=gi[i+1];ati[i]:=ati[i+1];
   end;
   LPrz:=LPrz-1;
   with listbox1 do items.Delete(listbox1.itemindex);
  end;
end;

procedure TForm8.Button2Click(Sender: TObject);
begin
  if wyswietl=0 then button3.setfocus else button12.setfocus;
  if listbox1.itemindex<LPrz-1 then
  begin
    j:=listbox1.itemindex+1;
    BNazwaPrz:=NazwaPrz[j+1];
    BA:=Ai[j+1];
    BJ:=Ji[j+1];
    Bi:=ii[j+i];
    Bh:=hi[j+1];
    BE:=Ei[j+1];
    Bro:=gi[j+1];
    Bat:=ati[j+1];
    NazwaPrz[j+1]:=NazwaPrz[j];
    Ai[j+1]:=Ai[j];
    Ji[j+1]:=Ji[j];
    ii[j+1]:=ii[j];
    hi[j+1]:=hi[j];
    Ei[j+1]:=Ei[j];
    gi[j+1]:=gi[j];
    ati[j+1]:=ati[j];
    NazwaPrz[j]:=Bnazwaprz;
    Ai[j]:=BA;
    Ji[j]:=BJ;
    ii[j]:=Bi;
    hi[j]:=Bh;
    Ei[j]:=BE;
    gi[j]:=Bro;
    ati[j]:=Bat;
    with listbox1 do begin
     items.Delete(j-1); items.Delete(j-1);
     items.Insert(j-1,NazwaPrz[j+1]); items.Insert(j-1,NazwaPrz[j]);
    end;
    listbox1.itemindex:=j;
  end;
end;

procedure TForm8.Button12Click(Sender: TObject);
begin
  close;
end;

procedure TForm8.Button1Click(Sender: TObject);
begin
  if wyswietl=0 then button3.setfocus else button12.setfocus;
  form9.show;
end;

procedure TForm8.Button3Click(Sender: TObject);
begin
  {button3.setfocus;}
  okienko:=2;j:=listbox1.itemindex;form8open:=true;close;
end;

procedure TForm8.Button5Click(Sender: TObject);
var blad:boolean;
begin
  if wyswietl=0 then button3.setfocus else button12.setfocus;
  blad:=false;
  for i:=1 to Lprz do
    if edit1.text=nazwaprz[i] then begin MessageDlg('Ostrzeżenie!', 'Przekrój o tej nazwie już istnieje!', mtWarning, [mbOK], 0); blad:=true ; end;
  if blad=false then if (edit1.text<>'') and (strtofloat(edit2.text)>0) and (strtofloat(edit3.text)>0) and (strtofloat(edit4.text)>0) and
   (strtofloat(edit5.text)>0) and (strtofloat(edit6.text)>0) and (strtofloat(edit7.text)>0) and (strtofloat(edit8.text)>0) then
  begin
    inc(LPrz);
    Nazwaprz[LPrz]:=edit1.text;
    trystrtofloat(edit5.text,Ai[LPrz]);
    trystrtofloat(edit6.text,Ji[LPrz]);
    trystrtofloat(edit8.text,ii[LPrz]);
    trystrtofloat(edit7.text,hi[LPrz]);
    trystrtofloat(edit2.text,Ei[LPrz]);
    trystrtofloat(edit3.text,gi[LPrz]);
    trystrtofloat(edit4.text,ati[LPrz]);
    with listbox1 do items.add(Nazwaprz[LPrz]);
    listbox1.itemindex:=LPrz-1;
  end
  else MessageDlg('Błąd!', 'Sprawdź wszystkie liczby.', mterror, [mbOK], 0);
end;

procedure TForm8.Button6Click(Sender: TObject);
begin
  if wyswietl=0 then button3.setfocus else button12.setfocus;
  if listbox1.itemindex>0 then
  begin
    j:=listbox1.itemindex;
    BNazwaPrz:=NazwaPrz[j];
    BA:=Ai[j];
    BJ:=Ji[j];
    Bi:=ii[j];
    Bh:=hi[j];
    BE:=Ei[j];
    Bro:=gi[j];
    Bat:=ati[j];
    NazwaPrz[j]:=NazwaPrz[j+1];
    Ai[j]:=Ai[j+1];
    Ji[j]:=Ji[j+1];
    ii[j]:=ii[j+1];
    hi[j]:=hi[j+1];
    Ei[j]:=Ei[j+1];
    gi[j]:=gi[j+1];
    ati[j]:=ati[j+1];
    NazwaPrz[j+1]:=Bnazwaprz;
    Ai[j+1]:=BA;
    Ji[j+1]:=BJ;
    ii[j+1]:=Bi;
    hi[j+1]:=Bh;
    Ei[j+1]:=BE;
    gi[j+1]:=Bro;
    ati[j+1]:=Bat;
    with listbox1 do begin
     items.Delete(j-1); items.Delete(j-1);
     items.Insert(j-1,NazwaPrz[j+1]); items.Insert(j-1,NazwaPrz[j]);
    end;
    listbox1.itemindex:=j-1;
  end;
end;

procedure TForm8.Button7Click(Sender: TObject);
begin
  if wyswietl=0 then button3.setfocus else button12.setfocus;
  if Messagedlg('Uwaga,'+LineEnding+'obecna lista będzie od teraz używana dla każdego nowego pliku.'+LineEnding+'Kontynuować?', mtConfirmation, [mbYes,mbNo],0)=MrYes then
  begin            //zapisywanie wzoru
    assignfile(plik,ExtractFilePath(Application.ExeName)+'new');
    rewrite(plik);
    writeln(plik,'Przekroj    E[kPa]  g[g/cm^3]    at[1/K]      A[m2]        J[m4]     h[m]   i[m]    Nazwa');
    for i:=1 to LPrz do
    begin
     write(plik,i,'     ');
     write(plik,Ei[i]:12:0,' ',gi[i]:10:3,' ',ati[i]:10:6,' ',Ai[i]:10:6,' ',Ji[i]:12:9,' ',hi[i]:8:3,'   ',ii[i]:8:4,'   ');
     writeln(plik,NazwaPrz[i]);
    end;
    write(plik,' ');
    closefile(plik);
    MessageDlg('Informacja', 'Zapisano z sukcesem.', mtinformation, [mbOK], 0);
  end;
end;

procedure TForm8.Button8Click(Sender: TObject);
begin
  if wyswietl=0 then button3.setfocus else button12.setfocus;
  form10.show;
end;

procedure TForm8.FormActivate(Sender: TObject);
begin
  if form9open=true then
  begin
    with listbox1 do items.Clear;
    for i:=1 to Lprz do with listbox1 do items.add(Nazwaprz[i]);
    form9open:=false;
  end;
  if form10open=true then
  begin
    edit5.text:=floattostrf(A,ffexponent,4,3);
    edit6.text:=floattostrf(Jx,ffexponent,4,3);
    edit8.text:=floattostrf(isrodek,ffexponent,4,3);
    edit7.text:=floattostr(h/1000);
    form10open:=false;
  end;
end;

procedure TForm8.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  {button12.setfocus;}if form9.Visible=true then form9.Close; if form10.visible=true then form10.close;
end;

procedure TForm8.ListBox1SelectionChange(Sender: TObject; User: boolean);
begin
  edit1.text:=nazwaprz[listbox1.itemindex+1];
  edit5.text:=floattostr(Ai[listbox1.itemindex+1]);
  edit6.text:=floattostr(Ji[listbox1.itemindex+1]);
  edit7.text:=floattostr(hi[listbox1.itemindex+1]);
  edit8.text:=floattostr(ii[listbox1.itemindex+1]);
  edit2.text:=floattostr(Ei[listbox1.itemindex+1]);
  edit3.text:=floattostr(gi[listbox1.itemindex+1]);
  edit4.text:=floattostr(ati[listbox1.itemindex+1]);
end;

end.

