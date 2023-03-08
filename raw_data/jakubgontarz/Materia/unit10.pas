unit Unit10;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Spin;

type

  { TForm10 }

  TForm10 = class(TForm)
    Button12: TButton;
    Button3: TButton;
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
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioGroup1: TRadioGroup;
    procedure Button12Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edit1Change(Sender: TObject);
    procedure edit2Change(Sender: TObject);
    procedure edit3Change(Sender: TObject);
    procedure edit4Change(Sender: TObject);
    procedure edit5Change(Sender: TObject);
    procedure edit8Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Licz;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form10: TForm10;

implementation

{$R *.lfm}

uses
  unit8;

{ TForm10 }

procedure TForm10.RadioGroup1Click(Sender: TObject);
begin
  case radiogroup1.ItemIndex of
  0 : begin edit2.enabled:=true;edit3.enabled:=false;edit4.enabled:=false;edit5.enabled:=false;edit8.enabled:=false;end;
  1 : begin edit2.enabled:=false;edit3.enabled:=false;edit4.enabled:=false;edit5.enabled:=false;edit8.enabled:=false; end;
  2 : begin edit2.enabled:=true;edit3.enabled:=true;edit4.enabled:=true;edit5.enabled:=true;edit8.enabled:=true; end;
  3 : begin edit2.enabled:=true;edit3.enabled:=true;edit4.enabled:=true;edit5.enabled:=true;edit8.enabled:=true; end;
  4 : begin edit2.enabled:=true;edit3.enabled:=false;edit4.enabled:=true;edit5.enabled:=true;edit8.enabled:=false; end;
  5 : begin edit2.enabled:=true;edit3.enabled:=false;edit4.enabled:=true;edit5.enabled:=true;edit8.enabled:=false; end;
  6 : begin edit2.enabled:=false;edit3.enabled:=false;edit4.enabled:=false;edit5.enabled:=true;edit8.enabled:=false; end;
  7 : begin edit2.enabled:=true;edit3.enabled:=true;edit4.enabled:=true;edit5.enabled:=true;edit8.enabled:=false; end;
  end;
  ImageList1.GetBitmap(radiogroup1.itemindex,Image1.Picture.Bitmap);
  licz;
end;

procedure TForm10.Button12Click(Sender: TObject);
begin
  close;
end;

procedure TForm10.Button3Click(Sender: TObject);
begin
  button3.setfocus;
  if strtofloat(edit7.text)>0 then
  begin form10open:=true; close; end
  else MessageDlg('Błąd!', 'Sprawdź wszystkie liczby.', mterror, [mbOK], 0);
end;

procedure TForm10.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button12.setfocus;
end;

procedure TForm10.FormShow(Sender: TObject);
begin
  radiogroup1click(radiogroup1);
  form10.Left:=form8.left-form10.width-5;
  form10.top:=form8.top;
end;

{-$}
procedure TForm10.edit1Change(Sender: TObject);
begin
  trystrtofloat(edit1.text,h); licz;
end;

procedure TForm10.edit2Change(Sender: TObject);
begin
  trystrtofloat(edit2.text,bd); licz;
end;

procedure TForm10.edit3Change(Sender: TObject);
begin
  trystrtofloat(edit3.text,tg); licz;
end;

procedure TForm10.edit4Change(Sender: TObject);
begin
  trystrtofloat(edit4.text,td); licz;
end;

procedure TForm10.edit5Change(Sender: TObject);
begin
  trystrtofloat(edit5.text,g); licz;
end;

procedure TForm10.edit8Change(Sender: TObject);
begin
  trystrtofloat(edit8.text,bg); licz;
end;

{+$}

procedure tform10.licz;
begin
  case radiogroup1.ItemIndex of
  0:begin A:=h*bd*1E-6;Jx:=h*h*h*bd/12*1E-12; isrodek:=h/2*1E-3; end;
  1:begin A:=h*h*pi()/4*1E-6;Jx:=h*h*h*h*pi()/64*1E-12; isrodek:=h/2*1E-3; end;
  2,3:begin if (h<>0) and (bg<>0) and (tg<>0) and (bd<>0) and (td<>0) then  isrodek:=(tg*bg*(h-tg/2)+(h-tg-td)*g*0.5*(h-tg+td)+td*bd*td/2)/(tg*bg+(h-tg-td)*g+td*bd) else isrodek:=0;
      A:=((h-tg-td)*g+tg*bg+td*bd)*1E-6;
      Jx:=(tg*tg*tg*bg/12+tg*bg*sqr(h-tg/2-isrodek)+sqr(h-tg-td)*(h-tg-td)*g/12+(h-tg-td)*g*0.25*sqr(h-tg+td-2*isrodek)+td*td*td*bd/12+td*bd*sqr(td/2-isrodek))*1E-12;
      isrodek:=isrodek/1000;end;
  4,5:begin if (h<>0) and (bd<>0) and (td<>0) then  isrodek:=((h-td)*g*0.5*(h+td)+td*bd*td/2)/((h-td)*g+td*bd) else isrodek:=0;
      A:=((h-td)*g+td*bd)*1E-6;
      Jx:=(sqr(h-td)*(h-td)*g/12+(h-td)*g*0.25*sqr(h+td-2*isrodek)+td*td*td*bd/12+td*bd*sqr(td/2-isrodek))*1E-12;
      isrodek:=isrodek/1000;end;
  6:begin A:=(sqr(h/2)-sqr(h/2-g))*pi()*1E-6;Jx:=(sqr(sqr(h/2))-sqr(sqr(h/2-g)))*pi()/4*1E-12; isrodek:=h/2*1E-3; end;
  7:begin if (h<>0) and (tg<>0) and (bd<>0) and (td<>0) then  isrodek:=(tg*bd*(h-tg/2)+(h-tg-td)*g*(h-tg+td)+td*bd*td/2)/(tg*bd+2*(h-tg-td)*g+td*bd) else isrodek:=0;
      A:=((h-tg-td)*g*2+tg*bd+td*bd)*1E-6;
      Jx:=(tg*tg*tg*bd/12+tg*bd*sqr(h-tg/2-isrodek)+sqr(h-tg-td)*(h-tg-td)*g/6+(h-tg-td)*g*0.5*sqr(h-tg+td-2*isrodek)+td*td*td*bd/12+td*bd*sqr(td/2-isrodek))*1E-12;
      isrodek:=isrodek/1000;  end;
  end;
  edit7.text:=floattostrf(A,ffexponent,4,3);
  edit6.text:=floattostrf(Jx,ffexponent,4,3);
  edit9.text:=floattostrf(isrodek,ffexponent,4,3);
end;


end.

