unit Unit16;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm16 }

  TForm16 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    function  parzysta(aaa:real):boolean;
  private

  public

  end;

var
  Form16: TForm16;
  typ:integer;
  wymH1,wymH2,wymH3,wymX1,wymY1,wymX2,wymY2:real;
  Pola1,Pola2:integer;

implementation

uses
  unit1;

{$R *.lfm}

{ TForm16 }

procedure TForm16.FormShow(Sender: TObject);
begin
  radiobutton1.top:=trunc(1*image1.Height/12+image1.top-radiobutton1.height/2);
  radiobutton2.top:=trunc(3*image1.Height/12+image1.top-radiobutton2.height/2);
  radiobutton3.top:=trunc(5*image1.Height/12+image1.top-radiobutton3.height/2);
  radiobutton4.top:=trunc(7*image1.Height/12+image1.top-radiobutton4.height/2);
  radiobutton5.top:=trunc(9*image1.Height/12+image1.top-radiobutton5.height/2);
  radiobutton6.top:=trunc(11*image1.Height/12+image1.top-radiobutton6.height/2);
end;

procedure TForm16.RadioButton1Change(Sender: TObject);
begin
  if radiobutton1.Checked=true then typ:=1;
end;

procedure TForm16.RadioButton2Change(Sender: TObject);
begin
  if radiobutton2.Checked=true then typ:=2;
end;

procedure TForm16.RadioButton3Change(Sender: TObject);
begin
  if radiobutton3.Checked=true then typ:=3;
end;

procedure TForm16.RadioButton4Change(Sender: TObject);
begin
  if radiobutton4.Checked=true then typ:=4;
end;

procedure TForm16.RadioButton5Change(Sender: TObject);
begin
  if radiobutton5.Checked=true then typ:=5;
end;

procedure TForm16.RadioButton6Change(Sender: TObject);
begin
  if radiobutton6.Checked=true then typ:=6;
end;

procedure TForm16.Button2Click(Sender: TObject);
var ok:boolean;
    LwA,LeA,LwB,LwC,LwD:integer;
    rodzaj:integer;
begin
  button2.setfocus;
  ok:=true;
  LwA:=Lw;LeA:=Le;
  trystrtofloat(edit1.text,wymH1);
  trystrtofloat(edit2.text,wymH2);
  trystrtofloat(edit3.text,wymH3);
  trystrtofloat(edit4.text,wymX1);
  trystrtofloat(edit5.text,wymY1);
  trystrtofloat(edit6.text,wymX2);
  trystrtofloat(edit7.text,wymY2);
  trystrtoint(edit8.text,Pola1);
  trystrtoint(edit9.text,Pola2);
  if checkbox1.checked=true then begin wymy1:=wymy2*wymx1/(wymx1+wymx2);wymh2:=(wymh3+wymy2-wymh1)*wymx1/(wymx1+wymx2)+wymh1-wymy1; end;
  if radiobutton1.checked=true then rodzaj:=1;
  if radiobutton2.checked=true then rodzaj:=2;
  if radiobutton3.checked=true then rodzaj:=3;
  if radiobutton4.checked=true then rodzaj:=4;
  if radiobutton5.checked=true then rodzaj:=5;
  if radiobutton6.checked=true then rodzaj:=6;
  //sprawdzenia
  if (edit1.text<>floattostr(wymH1)) or (edit3.text<>floattostr(wymH3)) or (edit4.text<>floattostr(wymX1))
    or (edit6.text<>floattostr(wymX2)) or (edit7.text<>floattostr(wymY2)) or (edit8.text<>floattostr(Pola1))
    or (edit9.text<>floattostr(Pola2)) then begin MessageDlg('Ostrzeżenie!', 'Należy wpisać liczby rzeczywiste a Liczba pól powinna być liczbą naturalną.', mtwarning, [mbOK], 0); ok:=false; end;
  if (ok=true) and (checkbox1.checked=false) and ((edit5.text<>floattostr(wymY1)) or (edit2.text<>floattostr(wymH2))) then begin MessageDlg('Ostrzeżenie!', 'Należy wpisać liczby rzeczywiste a Liczba pól powinna być liczbą naturalną.', mtwarning, [mbOK], 0); ok:=false; end;
  if (wymH2+wymH3=0) or (wymX2=0) then begin Pola2:=0; wymx2:=0; wymh3:=0; end;
  if (ok=true) and (checkbox1.checked=true) and (pola2=0) then begin MessageDlg('Ostrzeżenie!', 'Jeśli opcja "prostoliniowe pasy" jest zaznaczona, to kratownica musi mieć Pole 2.', mtwarning, [mbOK], 0); ok:=false; end;
  if (ok=true) and ((wymH1<0) or (wymH2<0) or (wymH3<0) or (wymX1<0) or (wymX2<0)) then begin MessageDlg('Ostrzeżenie!', 'Wymiary H i X nie mogą być ujemne.', mtwarning, [mbOK], 0);  ok:=false; end;
  if (ok=true) and ((wymh1+wymh2=0) or (wymx1=0) or (pola1=0)) then  begin MessageDlg('Ostrzeżenie!', 'Jeżeli kratownica ma tylko jedno pole, to musi być to pole 1.', mtwarning, [mbOK], 0); ok:=false; end;
  if (ok=true) and (((wymH1+wymH2=0) and (wymX2=0) and (Pola2=0)) or ((wymH2+wymH3=0) and (wymX1=0) and (Pola1=0))) then begin MessageDlg('Ostrzeżenie!', 'Wysokość pola nie może wynosić 0.', mtwarning, [mbOK], 0); ok:=false; end;
  if (ok=true) and (wymX1+wymX2=0) then begin MessageDlg('Ostrzeżenie!', 'Szerokość kratownicy nie może wynosić 0.', mtwarning, [mbOK], 0); ok:=false; end;
  if (ok=true) and ((wymX1+Pola2=0) or (wymX2+Pola1=0)) then  begin MessageDlg('Ostrzeżenie!', 'Szerokość kratownicy nie może wynosić 0.', mtwarning, [mbOK], 0); ok:=false; end;
  if (ok=true) and (rodzaj>=5) and ((pola1=1) or (pola2=1)) then begin MessageDlg('Ostrzeżenie!', 'Dla tego rodzaju skratowania muszą być conajmniej dwa pola.', mtwarning, [mbOK], 0); ok:=false; end;

  //rysowanie
  if ok=true then begin
    for i:=0 to Pola1 do
      if (i=Pola1) or (i=0) or ((parzysta(i)=true) and (rodzaj=5)) or ((parzysta(i)=false) and (rodzaj=6)) or (rodzaj<=4) then begin inc(Lw); Xw[Lw]:=1000+i*wymX1/Pola1; Yw[Lw]:=1000+i*wymY1/Pola1; end; //dolny pas 1
    for i:=1 to Lw-LwA-1 do begin inc(Le); Wp[Le]:=LwA+i; Wk[Le]:=LwA+i+1; end;
    if wymh1>0 then begin inc(Lw); inc (Le); Xw[Lw]:=1000; Yw[Lw]:=1000+wymh1; Wp[Le]:=LwA+1; Wk[Le]:=Lw;  end; //lewy slupek 1
    LwB:=Lw;
    for i:=1 to Pola1 do
      if (i=Pola1) or ((parzysta(i)=false) and (rodzaj=5)) or ((parzysta(i)=true) and (rodzaj=6)) or (rodzaj<=4) then begin inc(Lw); Xw[Lw]:=1000+i*wymX1/Pola1; Yw[Lw]:=1000+wymh1+i*(wymY1-wymh1+wymh2)/Pola1; end;  //pas gorny 1
    for i:=1 to Lw-LwB do begin inc(Le); Wp[Le]:=LwB+i-1; Wk[Le]:=LwB+i; end;
    if wymh1=0 then Wp[Le-Lw+LwB+1]:=LwA+1;
    if wymh2=0 then begin Lw:=Lw-1; Wk[Le]:=LwB-1; end;
    if wymh2>0 then begin inc(Le); if wymh1=0 then Wp[Le]:=LwB else Wp[Le]:=LwB-1; Wk[Le]:=Lw; end; //srodkowy slupek
    if (Pola1>1) and (rodzaj<=4) then for i:=1 to Pola1-1 do begin inc(Le); Wp[Le]:=LwA+i+1; Wk[Le]:=LwB+i; end;    //slupki 1
    if (wymh1>0) and ((rodzaj=1) or (rodzaj=3) or (rodzaj=5)) then begin inc(Le); Wp[Le]:=LwA+1; Wk[Le]:=LwB+1; end; //pierwszy ukos 1
    if (wymh1>0) and ((rodzaj=2) or (rodzaj=4) or (rodzaj=6)) then begin inc(Le); Wp[Le]:=LwB; Wk[Le]:=LwA+2; end;
    if pola1>=2 then for i:=2 to Pola1 do begin                                                    //wewnetrzne ukosy 1
      if (rodzaj=3) or ((rodzaj=2) and (parzysta(i)=true)) or ((rodzaj=1) and (parzysta(i)=false)) then
        begin inc(Le); Wp[Le]:=LwA+i;Wk[Le]:=LwB+i; end;
      if (rodzaj=4) or ((rodzaj=2) and (parzysta(i)=false)) or ((rodzaj=1) and (parzysta(i)=true)) then
        begin inc(Le); Wp[Le]:=LwA+i+1;Wk[Le]:=LwB+i-1; end;
      if (rodzaj=5) then
        begin inc(Le); Wp[Le]:=LwA+trunc(i/2)+1;Wk[Le]:=LwB+trunc((i+1)/2); end;
      if (rodzaj=6) then
        begin inc(Le); Wp[Le]:=LwA+trunc((i+1)/2)+1;Wk[Le]:=LwB+trunc(i/2); end;
    end;
    if wymh2=0 then Le:=Le-1;   //ostatni ukos 1
    LwC:=Lw;
    if Pola2>0 then begin                   //pola 2
      for i:=1 to Pola2 do
        if (i=Pola2) or ((parzysta(i+Pola1)=true) and (rodzaj=5)) or ((parzysta(i+Pola1)=false) and (rodzaj=6)) or (rodzaj<=4) then begin inc(Lw); Xw[Lw]:=1000+wymX1+i*wymX2/Pola2; Yw[Lw]:=1000+wymy1+i*(wymY2-wymy1)/Pola2; end; //dolny pas 2
      for i:=1 to Lw-LwC do begin inc(Le); Wp[Le]:=LwC+i-1; Wk[Le]:=LwC+i; end;
      if wymh1=0 then Wp[Le-Lw+LwC+1]:=LwB else Wp[Le-Lw+LwC+1]:=LwB-1; LwD:=Lw;
      for i:=1 to Pola2 do
        if (i=Pola2) or ((parzysta(i+Pola1)=false) and (rodzaj=5)) or ((parzysta(i+Pola1)=true) and (rodzaj=6)) or (rodzaj<=4) then begin inc(Lw); Xw[Lw]:=1000+wymX1+i*wymX2/Pola2; Yw[Lw]:=1000+wymH2+wymY1+i*(wymY2+wymH3-wymY1-wymH2)/Pola2; end;  //pas gorny 2
      for i:=1 to Lw-LwD do begin inc(Le); Wp[Le]:=LwD+i-1; Wk[Le]:=LwD+i; end;
      if wymh2=0 then Wp[Le-Lw+LwD+1]:=LwB-1 else Wp[Le-Lw+LwD+1]:=LwC;
      if wymh3=0 then begin Wk[Le]:=LwD; Lw:=Lw-1 end;
      if wymh3>0 then begin inc(Le); Wp[Le]:=LwD; Wk[Le]:=Lw; end; //ostatni slupek
      if (Pola1>1) and (rodzaj<=4) then for i:=1 to Pola2-1 do begin inc(Le); Wp[Le]:=LwC+i; Wk[Le]:=LwD+i; end;    //slupki 2
      if (wymh2>0) and ((((rodzaj=1) or (rodzaj=5)) and (parzysta(pola1)=true)) or (((rodzaj=2) or (rodzaj=6)) and (parzysta(pola1)=false)) or (rodzaj=3)) then begin inc(Le); if wymh1=0 then Wp[Le]:=LwB else Wp[Le]:=LwB-1; Wk[Le]:=LwD+1; end; //pierwszy ukos 2
      if (wymh2>0) and ((((rodzaj=1) or (rodzaj=5)) and (parzysta(pola1)=false)) or (((rodzaj=2) or (rodzaj=6)) and (parzysta(pola1)=true)) or (rodzaj=4)) then begin inc(Le); Wp[Le]:=LwC; Wk[Le]:=LwC+1; end;
      if Pola2>=2 then for i:=2 to Pola2 do begin                                                    //wewnetrzne ukosy 2
        if (rodzaj=3) or ((rodzaj=2) and (parzysta(i+Pola1)=true)) or ((rodzaj=1) and (parzysta(i+Pola1)=false)) then
          begin inc(Le); Wp[Le]:=LwC+i-1;Wk[Le]:=LwD+i; end;
        if (rodzaj=4) or ((rodzaj=2) and (parzysta(i+Pola1)=false)) or ((rodzaj=1) and (parzysta(i+Pola1)=true)) then
          begin inc(Le); Wp[Le]:=LwC+i;Wk[Le]:=LwD+i-1; end;
        if ((rodzaj=5) and (parzysta(Pola1)=true)) or ((rodzaj=6) and (parzysta(Pola1)=false)) then
          begin inc(Le); Wp[Le]:=LwC+trunc(i/2);Wk[Le]:=LwD+trunc((i+1)/2); end;
        if ((rodzaj=6) and (parzysta(Pola1)=true)) or ((rodzaj=5) and (parzysta(Pola1)=false)) then
          begin inc(Le); Wp[Le]:=LwC+trunc((i+1)/2);Wk[Le]:=LwD+trunc(i/2); end;
      end;
      if wymh3=0 then Le:=Le-1;   //ostatni ukos 2
    end;
    for i:=LeA+1 to Le do typs[i]:=4;
    noweLw:=Lw-LwA; noweLe:=Le-LeA;
    form14open:=true;
    close;
  end;
end;

procedure TForm16.CheckBox1Change(Sender: TObject);
begin
  if checkbox1.checked=true then begin edit2.Enabled:=false; edit5.enabled:=false end
                            else begin edit2.Enabled:=true;  edit5.enabled:=true  end
end;

procedure TForm16.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button1.setfocus;
end;

procedure TForm16.Button1Click(Sender: TObject);
begin
  close;
end;

function tform16.parzysta(aaa:real):boolean;
begin
  while aaa>1 do aaa:=aaa-2;
  if aaa=1 then parzysta:=false else parzysta:=true;
end;

end.

