unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, Buttons, ComCtrls, types, process, MouseAndKeyInput, LCLType,
  registry, shellapi, unit2, Unit3, Unit4, Unit5, Unit6, Unit7, Unit8, Unit9,
  Unit10, unit11, unit12, unit13, unit14, unit15, unit16, Unit17, clipbrd,
  LMessages, Spin, BGRABitmap, BGRABitmapTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    IdleTimer1: TIdleTimer;
    IdleTimer2: TIdleTimer;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
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
    Label30: TLabel;
    mbusunobc: TMenuItem;
    Panel4: TPanel;
    Shape1: TShape;
    Timer1: TTimer;
    ImageList1: TImageList;
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
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    mbwariant: TMenuItem;
    mbwar0: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    mbprzekroj2: TMenuItem;
    MenuItem15: TMenuItem;
    mbprzekroj: TMenuItem;
    mbsuwak: TMenuItem;
    mbzoom: TMenuItem;
    mbobrot: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mplik: TMenuItem;
    mbcofnij: TMenuItem;
    mbprzywroc: TMenuItem;
    mbprzenies: TMenuItem;
    mbkopiuj: TMenuItem;
    mblustro: TMenuItem;
    mbusun: TMenuItem;
    mbpodziel: TMenuItem;
    mbzaznaczwszystko: TMenuItem;
    mbpodglad: TMenuItem;
    mbrodzajpreta: TMenuItem;
    mbpodpora: TMenuItem;
    mboprogramie: TMenuItem;
    medycja: TMenuItem;
    mbpomoc: TMenuItem;
    mwstaw: TMenuItem;
    mbrysujpret: TMenuItem;
    mbsila: TMenuItem;
    mbciagle: TMenuItem;
    mbmoment: TMenuItem;
    mbtemperatura: TMenuItem;
    mbpodpory: TMenuItem;
    mnarzedzia: TMenuItem;
    mboblicz: TMenuItem;
    mpomoc: TMenuItem;
    mbmenprzekrojow: TMenuItem;
    Panel3: TPanel;
    PMStatecznosc: TMenuItem;
    mbmenprojektu: TMenuItem;
    PMStatyka: TMenuItem;
    mbstatyka: TMenuItem;
    PMLiniawplywu: TMenuItem;
    mbliniawplywu: TMenuItem;
    mbprzeciecia: TMenuItem;
    PMRozbij: TMenuItem;
    mbmenwariantow: TMenuItem;
    mbnowy: TMenuItem;
    mbkreator: TMenuItem;
    mbkreatorruszt: TMenuItem;
    mbrozbij: TMenuItem;
    mbstatecznosc: TMenuItem;
    mbkreatorkratownica: TMenuItem;
    mbutwierdzenie: TMenuItem;
    mbutwprzesuw: TMenuItem;
    mbwolnapodpora: TMenuItem;
    mbprzesuw: TMenuItem;
    mbblokadaobrotu: TMenuItem;
    mbtyppreta1: TMenuItem;
    mbtyppreta2: TMenuItem;
    mbtyppreta3: TMenuItem;
    mbtyppreta4: TMenuItem;
    mbotworz: TMenuItem;
    mbzdjecie: TMenuItem;
    mwyniki: TMenuItem;
    mbnormalne: TMenuItem;
    mbtnace: TMenuItem;
    mbmomenty: TMenuItem;
    mbprzemieszczenia: TMenuItem;
    mbnaprezenia: TMenuItem;
    mbreakcje: TMenuItem;
    mbzapisz: TMenuItem;
    mbpowrot: TMenuItem;
    mbpoprzwariant: TMenuItem;
    mbnastwariant: TMenuItem;
    mbzapiszjako: TMenuItem;
    mbustawienia: TMenuItem;
    mbzakoncz: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    PopupMenu4: TPopupMenu;
    Process1: TProcess;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    SaveDialog1: TSaveDialog;
    tbmenprojektu1: TToolButton;
    TBMenPrzekrojow1: TToolButton;
    tbmenwariantow1: TToolButton;
    TBNowy1: TToolButton;
    tboprogramie1: TToolButton;
    TBOtworz1: TToolButton;
    tbpomoc1: TToolButton;
    TBUstawienia1: TToolButton;
    TBWyjscie1: TToolButton;
    TBZapisz1: TToolButton;
    TBZapiszjako1: TToolButton;
    tbzdjecie1: TToolButton;
    tbzoom1: TToolButton;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    TBTyppreta1: TToolButton;
    TBWyjscie: TToolButton;
    TBZaznaczwszystko: TToolButton;
    TBPodpora: TToolButton;
    tbmenprojektu: TToolButton;
    tbmenwariantow: TToolButton;
    ToolButton1: TToolButton;
    tbkreatorruszt: TToolButton;
    tbkreatorkratownica: TToolButton;
    ToolButton2: TToolButton;
    tboprogramie: TToolButton;
    tbpomoc: TToolButton;
    tbzdjecie: TToolButton;
    tbEJ: TToolButton;
    tbEA: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    TBPodglad: TToolButton;
    TBZapiszjako: TToolButton;
    tbpodglad1: TToolButton;
    TBUstawienia: TToolButton;
    TBCofnij: TToolButton;
    div4: TToolButton;
    TBPrzywroc: TToolButton;
    TBRysujpret: TToolButton;
    TBSila: TToolButton;
    div8: TToolButton;
    TBCiagle: TToolButton;
    TBMoment: TToolButton;
    TBTemperatura: TToolButton;
    div6: TToolButton;
    TBTyppreta2: TToolButton;
    TBPrzenies: TToolButton;
    TBKopiuj: TToolButton;
    TBLustro: TToolButton;
    TBPodziel: TToolButton;
    div3: TToolButton;
    div7: TToolButton;
    TBUsun: TToolButton;
    TBOblicz: TToolButton;
    TBWolnapodpora: TToolButton;
    TBTyppreta3: TToolButton;
    div2: TToolButton;
    tbnormalne: TToolButton;
    tbtnace: TToolButton;
    tbmomenty: TToolButton;
    tbprzemieszczenia: TToolButton;
    div9: TToolButton;
    tbPowrot: TToolButton;
    tbnaprezenia: TToolButton;
    tbreakcje: TToolButton;
    TBTyppreta4: TToolButton;
    TBPrzeciecie: TToolButton;
    ToolButton33: TToolButton;
    TBPoprzWariant: TToolButton;
    ToolButton34: TToolButton;
    TBNastWariant: TToolButton;
    div1: TToolButton;
    TBUtwierdzenie: TToolButton;
    TBUtwprzesuw: TToolButton;
    TBPrzesuw: TToolButton;
    TBBlokadaobrotu: TToolButton;
    div5: TToolButton;
    TBMenPrzekrojow: TToolButton;
    TBNowy: TToolButton;
    TBOtworz: TToolButton;
    TBZapisz: TToolButton;
    ToolButton5: TToolButton;
    TBTyppreta: TToolButton;
    TBRpodpory: TToolButton;
    tbzoom: TToolButton;
    tbobrot: TToolButton;
    TBUsunobc: TToolButton;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure ComboBox2CloseUp(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure IdleTimer2Timer(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label19Click(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure Label21Click(Sender: TObject);
    procedure Label22Click(Sender: TObject);
    procedure Label23Click(Sender: TObject);
    procedure Label24Click(Sender: TObject);
    procedure Label25Click(Sender: TObject);
    procedure Label26Click(Sender: TObject);
    procedure Label27Click(Sender: TObject);
    procedure Label28Click(Sender: TObject);
    procedure Label29Click(Sender: TObject);
    procedure Label30Click(Sender: TObject);
    procedure mbprzekrojClick(Sender: TObject);
    procedure mbsuwakClick(Sender: TObject);
    procedure mbwariantClick(Sender: TObject);
    procedure PMStatecznoscClick(Sender: TObject);
    procedure PMStatykaClick(Sender: TObject);
    procedure PMLiniawplywuClick(Sender: TObject);
    procedure PMRozbijClick(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure Przekrojclick(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton3Change;
    procedure obliczklik;
    procedure RadioButton5Change(Sender: TObject);
    procedure rysuj;
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape1MouseEnter(Sender: TObject);
    procedure Shape1MouseLeave(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbkreatorkratownicaClick(Sender: TObject);
    procedure tbkreatorrusztClick(Sender: TObject);
    procedure tbmenwariantowClick(Sender: TObject);
    procedure tbobrotClick(Sender: TObject);
    procedure tboprogramieClick(Sender: TObject);
    procedure TBPodporaClick(Sender: TObject);
    procedure tbpomocClick(Sender: TObject);
    procedure TBUsunobcClick(Sender: TObject);
    procedure TBWyjscieClick(Sender: TObject);
    procedure TBZaznaczwszystkoClick(Sender: TObject);
    procedure tbzdjecieClick(Sender: TObject);
    procedure TBzoomclick(Sender: TObject);
    procedure tbmenprojektuClick(Sender: TObject);
    procedure TBPodgladClick(Sender: TObject);
    procedure TBZapiszjakoClick(Sender: TObject);
    procedure TBUstawieniaClick(Sender: TObject);
    procedure TBCofnijClick(Sender: TObject);
    procedure TBPrzywrocClick(Sender: TObject);
    procedure tbnormalneClick(Sender: TObject);
    procedure tbtnaceClick(Sender: TObject);
    procedure tbmomentyClick(Sender: TObject);
    procedure tbprzemieszczeniaClick(Sender: TObject);
    procedure tbPowrotClick(Sender: TObject);
    procedure tbnaprezeniaClick(Sender: TObject);
    procedure tbreakcjeClick(Sender: TObject);
    procedure TBPrzeciecieClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolButton33Click(Sender: TObject);
    procedure TBPoprzWariantClick(Sender: TObject);
    procedure TBNastWariantClick(Sender: TObject);
    procedure TBNowyClick(Sender: TObject);
    procedure TBOtworzClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure wariantclick(Sender: TObject);
    procedure zapiszjako;
    procedure zapiszwstecz;
    procedure otworz2;
    procedure procesotwierania;
    procedure proceszapisywania;
    procedure odnowa;
    procedure wczytajopcje;
    procedure StatusBar1DrawPanel;
    procedure StatusBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TBSilaClick(Sender: TObject);
    procedure TBCiagleClick(Sender: TObject);
    procedure TBMomentClick(Sender: TObject);
    procedure TBTemperaturaClick(Sender: TObject);
    procedure TBPrzeniesClick(Sender: TObject);
    procedure TBKopiujClick(Sender: TObject);
    procedure TBLustroClick(Sender: TObject);
    procedure TBPodzielClick(Sender: TObject);
    procedure TBUsunClick(Sender: TObject);
    procedure TBMenPrzekrojowClick(Sender: TObject);
    procedure TBZapiszClick(Sender: TObject);
    procedure koniecrysowania;
    procedure sprawdzwezly;
    procedure klikenterspacja;
    procedure TBRysujpretClick(Sender: TObject);
    procedure TBTyppreta1Click(Sender: TObject);
    procedure TBTyppreta2Click(Sender: TObject);
    procedure TBTyppreta3Click(Sender: TObject);
    procedure TBTyppreta4Click(Sender: TObject);
    procedure statyka;
    procedure ukladrownan;
    procedure trackbarzmiana;
    procedure powrotobciazen;
    function Xpoint:real;
    function Ypoint:real;
    function maxP:real;
    function maxQ:real;
    function atan(a,b:real):real;
    function wp0(a:real):real;
    function wk0(a:real):real;
    function wp4(a:real):real;
    function wk4(a:real):real;
    function wp3(a:real):real;
    function wk3(a:real):real;
    function wpm3(a:real):real;
    function wp2(a:real):real;
    function wk2(a:real):real;
    function wkm1(a:real):real;
    function wpm1(a:real):real;
    function wkm2(a:real):real;
    function op3(a:real):real;
    function ok3(a:real):real;
    function opm3(a:real):real;
    function op2(a:real):real;
    function ok2(a:real):real;
    function okm2(a:real):real;
    function op1(a:real):real;
    function ok1(a:real):real;
    function opm1(a:real):real;
    function okm1(a:real):real;
    function Pq(a:real):real;
    function sgn(a:real):real;
    function det(ax,ay,bx,by,cx,cy:real):real;
    function statecznosc(a:real):real;
    function pointpodpora(x1,y1:real):tpoint;  
    function pointsila(x1,y1:real):tpoint;
  private

  public

  end;

var
  Form1: TForm1;
  wersja: string;
  A,B,C,D,i,j,k,x,w,Xt,Yt,Xmysz,Ymysz,zoom,tryb,tryb2,jedenpunkt,okienko,maleikony:integer;
  Lewymyszy,middlemyszy,czyzoomuje,rozbijobc:boolean;
  Xw,Yw,Lx,Ly,L,Xw1,Yw1,Lx1,Ly1,L1,alfapr,KLIKX,KLIKY:array [1..1000] of real;
  Wp,Wk,Wp1,Wk1,np,np1,nq,nq1,nm,nm1,nt,s,ww,typs,prz,typ1,prz1:array [1..1000] of integer;
  zaznaczonypret,zaznaczonywezel,zaznaczoneP,zaznaczoneQ,ZaznaczoneM,ZaznaczoneT,czyrysowac:array[1..1000] of boolean;
  Le,Lw,Le1,Lw1,Lwar,PreLwar,Lprz,Lr,form7podz,LEE:integer;
  Key:char;
  UU:integer;
  Xpoczramki,Ypoczramki:real;
  P,xp,xp1,alfap,Pqi,Pqj,Pqj1,xqi,xqi1,xqj,xqj1,alfaq,Pm,xm,xm1,Tg,Td,T0,DT,fipod,fipod2,KH,KV,KM,DH,DV,DM:array [1..1000] of real;
  Rpod:array [1..1000] of integer;
  wariantP, wariantQ,wariantM,wariantT,wariantPod: array [1..1000,-1..100] of boolean;
  RowsPp,PreRowsPp,RowsPq,PreRowsPq,RowsPm,PreRowsPm,RowsPt,PreRowsPt:integer;
  form2open,form3open,form4open,form5open,form6open,form7open,form8open,form7type,form11open,form12open,form13open,form14open:boolean;
  form2P,form2x,form2alfa,form3qp,form3qk,form3xp,form3xk,form3alfa,form4M,form4x,form5g,form5d,f6alfa,f6DH,f6DV,f6DM,f6KH,f6KV,f6KM,form7x,form13x:real;
  f6V,f6H,f6M:boolean;
  blabla,czas:string;
  NazwaPrz:array [1..100] of string;
  Ei,gi,ati,Ai,Ji,hi,ii:array [1..100] of real;
  plik,tymczasowy:text;
  nazwapliku:string;
  nic:char;
  bar:array [1..4] of boolean;
  delta,cel:integer;
  polar,wprowadzalfa:boolean;
  polarpoint,polarangle:integer;
  wprowadz:integer;
  liczba1,liczba2,ulamek:real;
  pozycja,ilecofnij,ileprzywroc:integer;
  o:array [1..6] of integer;
  czasowe,tak,zmiana:boolean;
  texton,textoff,tekst:array [1..13] of boolean;
  kolor:array [1..17] of tcolor;
  rozmiar:array [1..3] of integer;
  skalaP,skalaQ,ES:integer;     //ES liczba elementów skończonych
  skok,skalawew,skaladisp:real;
  ur,u,pr,p0,pr1,reakr:array[1..3000]of real;
  reak:array[1..3000,-1..100] of real;
  Kr,K0,Kr1:array[1..3000,1..3000] of real;
  Lss,wyswietl,wybranypret:integer;
  R,Rp,Rk,F,G,Z,D2,C2,B2,D3,B3,C3:array [1..3,1..3,1..1000] of real;
  Atemp,Pole,Jx,at,wys,E,h:array [1..1000] of real;
  pa,ka:array [1..1000] of integer;
  xpwsp,xqiwsp,xqjwsp,xmwsp:array [1..1000,-1..100] of integer;
  nrx:array[1..1000,-1..100] of integer;
  Npp,Nkp,Tpp,Tkp,Mpp,Mkp:array [1..1000] of real;
  Tpm,Tkm,Mpm,Mkm,Ni,Nj,Ti,Tj,Mi,Mj,Npq,Nkq,Tpq,Tkq,Mpq,Mkq,Npt,Nkt,Tpt,Tkt,Mpt,Mkt,fii,fij,czesc,fip,fim,fiq,fiqp,fiqt,fitem,ri,rj,fi4:array [1..1000] of real;
  calkaP,calkaK,xwybranypret:real;
  Mpx,Mqx,Mmx,Tpx,Tqx,Npx,Nqx,DM1,Mz,xz,fit,Dx,Dy,DMx,DMy,DTx,DTy,DNx,DNy,Dnapr1x,Dnapr1y,Dnapr2x,Dnapr2y:array[1..1000,1..100]of real;
  M,T,N,napr1,napr2,ux,uy,fi,v,vN:array[1..1000,1..100,-1..100] of real;
  wsp:array[1..1000,1..100,-1..100]of real;
  skip,miedzywezlami:integer;
  pret1p,pret2p:boolean;
  wezel1,wezel2,pret1,pret2,pretlw,wezlw1,wezlw2:integer;
  uxw1,uyw1,uxw2,uyw2:real;
  Mlw,Tlw,Nlw:array[1..3000,1..3000] of real;
  keyscut:array [1..100]of char;
  autosave:real;
  anulowano:boolean;
  wspolnyx,wspolnyy,a1,b1,aj,bj:real;  //do dzielenia pręta
  kliknietoco,kliknietonr:integer;
  doubleklik:boolean;
  Warianty,tenwariant,warianty1:integer;
  WariantNazwa:array [-1..100] of string;
  WariantWlasny,formwariant: array[-1..100] of boolean;
  rodzajpodpory,ils,ts,fs:integer;
  bln,motyw:string;
  Kappa:array[1..500] of real;                                          //do statecznosci
  G11,G12,G22,G11x,G22x,G12x: array [1..3,1..3,1..1000] of real;
  Gr:array[1..3000,1..3000] of real;
  lewa,prawa,mnoznik:real;
  noweLw,noweLe:integer;
  uruchomiono:boolean;
  filestream:tfilestream;
  nazwatool,nazwatool1:array [0..500] of string;
  checktool,checktool1:array [0..500] of boolean;
  liczbatool,liczbatool1:integer;

implementation

{$R *.lfm}

{ TForm1 }


//klawiatura
procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  if (wyswietl>0) and (key=#27) then begin miedzywezlami:=0;wybranypret:=0; button2.Enabled:=true; button3.enabled:=true; rysuj; end;
  if (key=#27) then begin tryb2:=0; TBRysujpret.down:=false; TBPrzenies.down:=false; TBKopiuj.down:=false; TBLustro.down:=false; TBObrot.down:=false; TBPodglad.down:=false; TBPodglad1.down:=false; TBZdjecie.down:=false; TBZdjecie1.down:=false;tbzoom.down:=false; tbzoom1.down:=false;screen.cursor:=crdefault; end;
  if key=keyscut[1] then tbrysujpret.click;     //rysowanie pretow
  if key=keyscut[2] then tbusun.click;
  if key=keyscut[3] then tbsila.click;                                   //wstawianie sil
  if key=keyscut[4] then tbciagle.click;                                   //wstawianie q
  if key=keyscut[5] then tbmoment.click;                                    //wstawianie m
  if key=keyscut[6]  then tbtemperatura.Click;                                   //wstawianie t
  if key=keyscut[7] then tbpodpora.click;       //wstawianie podpor
  if key=keyscut[18] then tbutwierdzenie.click;
  if key=keyscut[19] then tbutwprzesuw.click;
  if key=keyscut[20] then tbwolnapodpora.click;
  if key=keyscut[21] then tbprzesuw.click;
  if key=keyscut[22] then tbblokadaobrotu.click;
  if key=keyscut[8] then tbprzenies.click;                            //przenoszenie
  if key=keyscut[9] then tbkopiuj.click;
  if key=keyscut[10] then tblustro.click;                        //lustro
  if key=keyscut[11] then tbpodziel.click;                               //podzial
  if key=keyscut[12] then tbpodglad.click;                                //podglad
  if key=keyscut[14] then tbmenprzekrojow.click;
  if key=keyscut[15] then tbmenprojektu.click;
  if key=keyscut[16] then PMStatyka.Click;
  if key=keyscut[17] then PMLiniawplywu.Click;
  if key=keyscut[24] then PMRozbij.Click;
  if key=keyscut[25] then PMStatecznosc.Click;
  if key=keyscut[23] then TBPrzeciecie.click;
  if key=keyscut[26] then tbPowrot.Click;
  if key=keyscut[27] then tbzoom.Click;
  if key=keyscut[28] then tbobrot.click;                        //obrot
  if wyswietl=0 then begin
  if (key>='0') and (key<='9') and (polar=true) then
  begin
    if (wprowadz=0) or (wprowadz=1) then begin wprowadz:=1;if liczba1>=0 then liczba1:=liczba1*10+strtoint(key) else liczba1:=liczba1*10-strtoint(key);rysuj; end;
    if (wprowadz=4) then begin if liczba2>=0 then liczba2:=liczba2*10+strtoint(key) else liczba2:=liczba2*10-strtoint(key);rysuj;end;
    if ((wprowadz=3) or (wprowadz=2)) and (ulamek>0.001) then begin wprowadz:=3; ulamek:=ulamek/10; if liczba1>=0 then liczba1:=liczba1+strtoint(key)*ulamek else liczba1:=liczba1-strtoint(key)*ulamek; rysuj; end;
    if ((wprowadz=6) or (wprowadz=5)) and (ulamek>0.001) then begin wprowadz:=6; ulamek:=ulamek/10; if liczba2>=0 then liczba2:=liczba2+strtoint(key)*ulamek else liczba2:=liczba2-strtoint(key)*ulamek;rysuj; end;
  end;
  if (key=',') and (polar=true) then
    if (wprowadz=1) or (wprowadz=4) then begin wprowadz:=wprowadz+1; ulamek:=1; rysuj; end;
  if (key=';') and (polar=true) then                                                         //TUTAJ MA BYĆ TABULATOR - przycisk
    if (wprowadz>0) and (wprowadz<4) then begin wprowadz:=4; rysuj; end;
  if (key=' ') or (key=#13) then begin klikenterspacja; end;
  if (key=#8) and (polar=true) then                                                   //backspace
  begin
    if wprowadz=1 then begin if liczba1=0 then wprowadz:=0; wprowadzalfa:=false; liczba1:=trunc(liczba1/10); rysuj; end;
    if wprowadz=4 then begin if liczba2=0 then if trunc(liczba1)=liczba1 then wprowadz:=1 else wprowadz:=3; liczba2:=trunc(liczba2/10); rysuj; end;
    if (wprowadz=2) or (wprowadz=5) then begin wprowadz:=wprowadz-1; rysuj; end;
    if wprowadz=3 then if ulamek<0.1 then begin ulamek:=ulamek*10; liczba1:=trunc(liczba1/ulamek)*ulamek; rysuj; end else begin ulamek:=1;liczba1:=trunc(liczba1/ulamek)*ulamek;wprowadz:=2;rysuj; end;
    if wprowadz=6 then if ulamek<0.1 then begin ulamek:=ulamek*10; liczba2:=trunc(liczba2/ulamek)*ulamek; rysuj; end else begin ulamek:=1;liczba2:=trunc(liczba2/ulamek)*ulamek;wprowadz:=5;rysuj; end;
  end;
  if (key='-') and (polar=true) then begin if wprowadz<4 then liczba1:=-liczba1 else liczba2:=-liczba2; rysuj; end;
  if (key=keyscut[13]) and (wprowadz>3) then begin if wprowadzalfa=true then wprowadzalfa:=false else wprowadzalfa:=true; rysuj; end;
  if key=#27 then       //escape
    begin
    if tryb=3 then begin tryb:=0; form6.show; end;
    if jedenpunkt=1 then begin jedenpunkt:=0; Le:=Le-1; end;
    if (tryb=1) or (tryb=7) or (tryb=8) then begin koniecrysowania; zapiszwstecz; end;
    tryb:=0;
    if form14open=true then begin Lw:=Lw-noweLw; Le:=Le-NoweLe; form14open:=false; end;
    for i:=1 to Le do zaznaczonypret[i]:=false;
    for i:=1 to Lw do zaznaczonywezel[i]:=false;
    for i:=1 to RowsPp do zaznaczoneP[i]:=false;
    for i:=1 to RowsPq do zaznaczoneQ[i]:=false;
    for i:=1 to RowsPm do zaznaczoneM[i]:=false;
    for i:=1 to RowsPt do zaznaczoneT[i]:=false;
    polar:=false; idletimer1.Enabled:=false; wprowadz:=0; ulamek:=1; liczba1:=0;liczba2:=0;
    label13.caption:='';
    rysuj;
    end;
  end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var kliknieto:boolean;
    bmp1: TBitmap;
    EJ,grlewa,grprawa,grdol,grgora,wspolrzx1,wspolrzy1,wspolrzx2,wspolrzy2,buforx,bufory:real;
    height2:integer;
begin
  if shift=[ssLeft] then begin
    if tryb2=3 then begin tryb2:=0; rysuj;
        tbzdjecie.down:=false; tbzdjecie1.down:=false; bmp1:=tbitmap.Create;  bmp1.Width := trunc(X-xpoczramki*zoom-A); bmp1.Height := trunc(Y+Ypoczramki*zoom-B);
        bmp1.canvas.copyrect(rect(0,0,bmp1.width,bmp1.height),canvas,rect(trunc(xpoczramki*zoom+A),trunc(-Ypoczramki*zoom+B),trunc(xpoczramki*zoom+A)+bmp1.width,trunc(-Ypoczramki*zoom+B)+bmp1.height));
        if (X-xpoczramki*zoom-A>0) and (Y+Ypoczramki*zoom-B>0) and (-Ypoczramki*zoom+B>0) and (xpoczramki*zoom+A>0) then begin label13.caption:='Zdjęcie skopiowano do schowka'; clipboard.assign(bmp1); end
          else label13.caption:='Nieprawidłowe zaznaczenie'; exit; end;   //zrobiono zdjecie
    if tryb2=5 then begin tryb2:=0; rysuj;
      tbzoom.down:=false; tbzoom1.down:=false;
      label13.caption:='';      //cała procedura zoomowania
      if Xmysz<xpoczramki*zoom+A then begin buforx:=xpoczramki; xpoczramki:=(Xmysz-A)/zoom; Xmysz:=round(buforx*zoom+A) end;
      if Ymysz<-Ypoczramki*zoom+B then begin bufory:=ypoczramki; ypoczramki:=-(Ymysz-B)/zoom; Ymysz:=round(-bufory*zoom+B) end;
      buforx:=(Xmysz-A)/zoom; bufory:=-(Ymysz-B)/zoom;
      if toolbar1.visible=true then height2:=height-toolbar1.Height else height2:=height-toolbar2.height;
      height2:=height2-mainmenu1.Height-panel4.Height;
      if ((Xmysz-A)/zoom-Xpoczramki)/(Ypoczramki+(Ymysz-B)/zoom)<width/height2 then zoom:=round(height2/(Ypoczramki+(Ymysz-B)/zoom)) else zoom:=round(width/((Xmysz-A)/zoom-Xpoczramki));
      if zoom>=5 then begin if (buforx-Xpoczramki)/(Ypoczramki-bufory)<width/height2
        then begin B:=round(Ypoczramki*zoom); A:=-round(Xpoczramki*zoom-0.5*(width-(buforx-Xpoczramki)*zoom)) end
        else begin A:=-round(Xpoczramki*zoom); B:=round(Ypoczramki*zoom+0.5*(height2-(Ypoczramki-bufory)*zoom)) end;
        if toolbar1.Visible=true then B:=B+toolbar1.height else B:=B+toolbar2.Height;
      end;
      if zoom<5 then zoom:=5;
      rysuj;
      exit;
    end;
    if tryb2=2 then begin tryb2:=3; xpoczramki:=(Xmysz-A)/zoom;Ypoczramki:=-(Ymysz-B)/zoom; end;
    if tryb2=4 then begin tryb2:=5; xpoczramki:=(Xmysz-A)/zoom;Ypoczramki:=-(Ymysz-B)/zoom; end;
  end;
  if shift=[ssMiddle] then                    //lapka
  begin
    middlemyszy:=True;
    Xt:=X;Yt:=Y;C:=A;D:=B;
  end;
  if (wyswietl=0) and (tryb=2) and ((shift=[ssLeft]) or (shift=[ssRight])) then                                                                   //ramka zaznaczania
    begin
     if xpoczramki<(Xmysz-A)/zoom then begin grlewa:=xpoczramki; grprawa:=(Xmysz-A)/zoom end else begin grprawa:=xpoczramki; grlewa:=(Xmysz-A)/zoom end;
     if Ypoczramki>-(Ymysz-B)/zoom then begin grgora:=ypoczramki; grdol:=-(Ymysz-B)/zoom end else begin grdol:=ypoczramki; grgora:=-(Ymysz-B)/zoom end;
     for i:=1 to Le do                                                                   //zaznaczanie pretow
      begin
       if ((xpoczramki<(Xmysz-A)/zoom) and (Xw[Wp[i]]>grlewa) and (Xw[Wk[i]]>grlewa) and (Xw[Wp[i]]<grprawa) and (Xw[Wk[i]]<grprawa)
        and (Yw[Wp[i]]<grgora) and (Yw[Wk[i]]<grgora) and (Yw[Wp[i]]>grdol) and (Yw[Wk[i]]>grdol)) or
          ((xpoczramki>=(Xmysz-A)/zoom) and (((Xw[Wp[i]]>grlewa) and (Xw[Wp[i]]<grprawa) and (Yw[Wp[i]]<grgora) and (Yw[Wp[i]]>grdol))
        or ((Xw[Wk[i]]>grlewa) and (Xw[Wk[i]]<grprawa) and (Yw[Wk[i]]<grgora) and (Yw[Wk[i]]>grdol))))
        then if shift=[ssleft] then zaznaczonypret[i]:=true else zaznaczonypret[i]:=false;
       if (xpoczramki>=(Xmysz-A)/zoom) and (det(grlewa,grdol,grprawa,grgora,Xw[Wp[i]],Yw[Wp[i]])*det(grlewa,grdol,grprawa,grgora,Xw[Wk[i]],Yw[Wk[i]])<0) and (det(Xw[Wp[i]],Yw[Wp[i]],Xw[Wk[i]],Yw[Wk[i]],grlewa,grdol)*det(Xw[Wp[i]],Yw[Wp[i]],Xw[Wk[i]],Yw[Wk[i]],grprawa,grgora)<0) then if shift=[ssleft] then zaznaczonypret[i]:=true else zaznaczonypret[i]:=false;
       if (xpoczramki>=(Xmysz-A)/zoom) and (det(grlewa,grgora,grprawa,grdol,Xw[Wp[i]],Yw[Wp[i]])*det(grlewa,grgora,grprawa,grdol,Xw[Wk[i]],Yw[Wk[i]])<0) and (det(Xw[Wp[i]],Yw[Wp[i]],Xw[Wk[i]],Yw[Wk[i]],grlewa,grgora)*det(Xw[Wp[i]],Yw[Wp[i]],Xw[Wk[i]],Yw[Wk[i]],grprawa,grdol)<0) then if shift=[ssleft] then zaznaczonypret[i]:=true else zaznaczonypret[i]:=false;
      end;
     for i:=1 to Lw do
      if (Xw[i]>grlewa) and (Xw[i]<grprawa) and (Yw[i]<grgora) and (Yw[i]>grdol)
      then if shift=[ssleft] then zaznaczonywezel[i]:=true else zaznaczonywezel[i]:=false;
     for i:=1 to RowsPp do
      begin wspolrzx1:=(Xw[Wk[np[i]]]-Xw[Wp[np[i]]])*xp[i]+Xw[Wp[np[i]]]+sin(alfap[i]*pi()/180)*(abs(P[i])/maxp*skalap+8*sgn(P[i]))/zoom;
            wspolrzy1:=(Yw[Wk[np[i]]]-Yw[Wp[np[i]]])*xp[i]+Yw[Wp[np[i]]]+cos(alfap[i]*pi()/180)*(abs(P[i])/maxp*skalap+8*sgn(P[i]))/zoom;
       if (wspolrzx1>Grlewa) and (wspolrzx1<grprawa) and (wspolrzy1<grgora) and (wspolrzy1>grdol)
       then if shift=[ssleft] then zaznaczoneP[i]:=true else zaznaczoneP[i]:=false;
      end;
     for i:=1 to RowsPq do
      begin wspolrzx1:=(Xw[Wk[nq[i]]]-Xw[Wp[nq[i]]])*xqi[i]+Xw[Wp[nq[i]]]+sin(alfaq[i]*pi()/180)*(Pqi[i]/maxq*skalaq+sgn(Pqi[i]))/zoom;
            wspolrzy1:=(Yw[Wk[nq[i]]]-Yw[Wp[nq[i]]])*xqi[i]+Yw[Wp[nq[i]]]+cos(alfaq[i]*pi()/180)*(Pqi[i]/maxq*skalaq+sgn(Pqi[i]))/zoom;
            wspolrzx2:=(Xw[Wk[nq[i]]]-Xw[Wp[nq[i]]])*xqj[i]+Xw[Wp[nq[i]]]+sin(alfaq[i]*pi()/180)*(Pqj[i]/maxq*skalaq+sgn(Pqj[i]))/zoom;
            wspolrzy2:=(Yw[Wk[nq[i]]]-Yw[Wp[nq[i]]])*xqj[i]+Yw[Wp[nq[i]]]+cos(alfaq[i]*pi()/180)*(Pqj[i]/maxq*skalaq+sgn(Pqj[i]))/zoom;
       if ((xpoczramki<(Xmysz-A)/zoom) and (wspolrzx1>grlewa) and (wspolrzx2>grlewa) and (wspolrzx1<grprawa) and (wspolrzx2<grprawa)
       and (wspolrzy1<grgora) and (wspolrzy2<grgora) and (wspolrzy1>grdol) and (wspolrzy2>grdol)) or
          ((xpoczramki>=(Xmysz-A)/zoom) and (((wspolrzx1>grlewa) and (wspolrzx1<grprawa) and (wspolrzy1<grgora) and (wspolrzy1>grdol))
       or ((wspolrzx2>grlewa) and (wspolrzx2<grprawa) and (wspolrzy2<grgora) and (wspolrzy2>grdol))))
       then if shift=[ssleft] then zaznaczoneQ[i]:=true else zaznaczoneQ[i]:=false;
      end;
     for i:=1 to RowsPt do
      if (Lx[nt[i]]/4+Xw[Wp[nt[i]]]>grlewa) and (Lx[nt[i]]/4+Xw[Wp[nt[i]]]<grprawa) and
         (Ly[nt[i]]/4+Yw[Wp[nt[i]]]<grgora) and (Ly[nt[i]]/4+Yw[Wp[nt[i]]]>grdol)
      then if shift=[ssleft] then zaznaczoneT[i]:=true else zaznaczoneT[i]:=false;
     for i:=1 to RowsPm do
      begin
       wspolrzx1:=Lx[nm[i]]*xm[i]+xw[wp[nm[i]]]+(25*Ly[nm[i]])/L[nm[i]]/zoom;
       wspolrzy1:=Ly[nm[i]]*xm[i]+yw[wp[nm[i]]]-(25*Lx[nm[i]])/L[nm[i]]/zoom;
       wspolrzx2:=Lx[nm[i]]*xm[i]+xw[wp[nm[i]]]-(25*Ly[nm[i]])/L[nm[i]]/zoom;
       wspolrzy2:=Ly[nm[i]]*xm[i]+yw[wp[nm[i]]]+(25*Lx[nm[i]])/L[nm[i]]/zoom;
       if ((xpoczramki<(Xmysz-A)/zoom) and (wspolrzx1>grlewa) and (wspolrzx1>grlewa) and (wspolrzx2<grprawa) and (wspolrzx2<grprawa)
       and (wspolrzy1<grgora) and (wspolrzy1<grgora) and (wspolrzy2>grdol) and (wspolrzy2>grdol)) or
          ((xpoczramki>=(Xmysz-A)/zoom) and (((wspolrzx1>grlewa) and (wspolrzx1<grprawa) and (wspolrzy1<grgora) and (wspolrzy1>grdol))
       or ((wspolrzx2>grlewa) and (wspolrzx2<grprawa) and (wspolrzy2<grgora) and (wspolrzy2>grdol))))
       then if shift=[ssleft] then zaznaczoneM[i]:=true else zaznaczoneM[i]:=false;
      end;
      tryb:=10; rysuj;
    end;
  if (wyswietl=0) and ((shift=[ssLeft]) or (shift=[ssRight])) and (tryb=0) and (tryb2=0) and (jedenpunkt=0) then       //zaznacza pojedyncze elementy
    begin
      obliczklik;
      if kliknietoco=1 then begin if shift=[ssLeft] then Zaznaczonypret[kliknietonr]:=true else Zaznaczonypret[kliknietonr]:=false; end;  //pret
      if kliknietoco=2 then                                //edycja sil
      begin if shift=[ssLeft] then
        if doubleklik=true then
        begin
          form2P:=P[kliknietonr];
          form2x:=xp[kliknietonr];
          form2alfa:=alfap[kliknietonr];
          for x:=1 to warianty do if wariantP[kliknietonr,x]=true then formwariant[x]:=true else formwariant[x]:=false;
          zaznaczonypret[np[kliknietonr]]:=true;
          for x:=kliknietonr to RowsPp do begin P[x]:=P[x+1]; xp[x]:=xp[x+1]; np[x]:=np[x+1]; alfap[x]:=alfap[x+1]; zaznaczoneP[x]:=zaznaczoneP[x+1]; for y:=1 to warianty do wariantP[x,y]:=wariantP[x+1,y] end;
          RowsPp:=RowsPp-1; PreRowsPp:=RowsPp;
          form2open:=true; form2.show; okienko:=1; o[3]:=-1;
        end
        else ZaznaczoneP[kliknietonr]:=true else ZaznaczoneP[kliknietonr]:=false;
     end;
     if kliknietoco=3 then                                               //edycja q
     begin if shift=[ssLeft] then
       if doubleklik=true then
       begin
         form3qp:=pqi[kliknietonr];form3qk:=Pqj[kliknietonr];
         form3xp:=xqi[kliknietonr];form3xk:=xqj[kliknietonr];
         form3alfa:=alfaq[kliknietonr];
         for x:=1 to warianty do if wariantQ[kliknietonr,x]=true then formwariant[x]:=true else formwariant[x]:=false;
         zaznaczonypret[nq[kliknietonr]]:=true;
         for x:=kliknietonr to RowsPq do begin pqi[x]:=pqi[x+1]; pqj[x]:=pqj[x+1];xqi[x]:=xqi[x+1]; xqj[x]:=xqj[x+1]; nq[x]:=nq[x+1]; alfaq[x]:=alfaq[x+1]; zaznaczoneQ[x]:=zaznaczoneQ[x+1]; for y:=1 to warianty do wariantQ[x,y]:=wariantQ[x+1,y] end;
         RowsPq:=RowsPq-1; PreRowsPq:=RowsPq;
         form3open:=true; form3.show; okienko:=1; o[4]:=-1;
       end
       else ZaznaczoneQ[kliknietonr]:=true else ZaznaczoneQ[kliknietonr]:=false;
     end;
     if kliknietoco=4 then                            //edycja momentow
     begin if shift=[ssLeft] then
       if doubleklik=true then
       begin
         form4M:=Pm[kliknietonr];
         form4x:=xm[kliknietonr];
         for x:=1 to warianty do if wariantM[kliknietonr,x]=true then formwariant[x]:=true else formwariant[x]:=false;
         zaznaczonypret[nm[kliknietonr]]:=true;
         for x:=kliknietonr to RowsPm do begin Pm[x]:=Pm[x+1]; xm[x]:=xm[x+1]; nm[x]:=nm[x+1]; zaznaczoneM[x]:=zaznaczoneM[x+1]; for y:=1 to warianty do wariantM[x,y]:=wariantM[x+1,y] end;
         RowsPm:=RowsPm-1; PreRowsPm:=RowsPm;
         form4open:=true; form4.show; okienko:=1; o[5]:=-1;
       end
       else ZaznaczoneM[kliknietonr]:=true else ZaznaczoneM[kliknietonr]:=false;
     end;
     if kliknietoco=5 then                                   //edycja temperatur
     begin if shift=[ssLeft] then
       if doubleklik=true then
       begin
         form5g:=Tg[kliknietonr];
         form5d:=Td[kliknietonr];
         for x:=1 to warianty do if wariantT[kliknietonr,x]=true then formwariant[x]:=true else formwariant[x]:=false;
         zaznaczonypret[nt[kliknietonr]]:=true;
         for x:=kliknietonr to RowsPt do begin Tg[x]:=Tg[x+1]; Td[x]:=Td[x+1]; nt[x]:=nt[x+1]; zaznaczoneT[x]:=zaznaczoneT[x+1]; for y:=1 to warianty do wariantM[x,y]:=wariantM[x+1,y] end;
         RowsPt:=RowsPt-1; PreRowsPt:=RowsPt;
         form5open:=true; form5.show; okienko:=1; o[6]:=-1;
       end
       else ZaznaczoneT[kliknietonr]:=true else ZaznaczoneT[kliknietonr]:=false;
     end;
     if kliknietoco=6 then                                                   //edycja podpór
     begin if shift=[ssLeft] then
       if doubleklik=true then
       begin
         f6V:=false;f6H:=false;f6M:=false;f6DV:=0;f6DH:=0;f6DM:=0;f6KV:=0;f6KH:=0;f6KM:=0;f6alfa:=0;
         for x:=1 to warianty do if wariantPod[s[kliknietonr],x]=true then formwariant[x]:=true else formwariant[x]:=false;
         for j:=1 to Lwar do if s[j]=kliknietonr then
         begin
           case RPod[j] of
             1: f6M:=true;
             2: begin f6H:=true; f6V:=true; f6M:=true; end;
             3: begin f6H:=true; f6V:=true; end;
             4: begin f6V:=true; f6M:=true; end;
             5: f6V:=true;
           end;
           f6alfa:=fipod[j];
           f6DH:=100*DH[j];f6KH:=KH[j];
           f6DV:=100*DV[j];f6KV:=KV[j];
           f6DM:=DM[j];f6KM:=KM[j];
           for x:=j to Lwar do begin s[x]:=s[x+1]; rpod[x]:=rpod[x+1]; DH[x]:=DH[x+1]; KH[x]:=KH[x+1]; DV[x]:=DV[x+1]; KV[x]:=KV[x+1]; DM[x]:=DM[x+1]; KM[x]:=KM[x+1]; fipod[x]:=fipod[x+1]; for y:=1 to warianty do wariantPod[x,y]:=wariantPod[x+1,y] end;
           Lwar:=Lwar-1;
           PreLwar:=Lwar;
           rodzajpodpory:=0;
           form6open:=true; form6.show; okienko:=1;
         end;

       end
       else Zaznaczonywezel[kliknietonr]:=true else Zaznaczonywezel[kliknietonr]:=false;
     end;
     if kliknietoco=0 then begin tryb:=2; Xpoczramki:=(Xmysz-A)/zoom; Ypoczramki:=-(Ymysz-B)/zoom; end;         //poczatek ramki
    end;
  if (wyswietl=0) and (shift=[ssLeft]) then klikenterspacja;
  if (shift=[ssright]) and (tryb2>0) then label13.caption:=''; label14.caption:='';
  if (shift=[ssRight]) then begin tryb2:=0; TBPrzenies.down:=false; TBKopiuj.down:=false; TBLustro.down:=false; TBObrot.down:=false; TBPodglad.down:=false; tbzdjecie.down:=false;TBPodglad1.down:=false; tbzdjecie1.down:=false;  tbzoom.down:=false;  tbzoom1.down:=false; screen.cursor:=crdefault; end;
  if (shift=[ssRight]) and (wyswietl=0) then                    //prawy myszy
    begin
      if (tryb=1) and (jedenpunkt=0) then
      begin
        tryb:=0; TBRysujpret.down:=false;polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; koniecrysowania; zapiszwstecz; label13.caption:=''; label14.caption:='';
      end;
      if (tryb=1) and (jedenpunkt=1) then
      begin
        Le:=Le-1;
        jedenpunkt:=0;
      end;
      if (tryb=7) or (tryb=8) then begin koniecrysowania; zapiszwstecz; end;
      if tryb>3 then begin tryb:=0; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; label13.caption:='' end;                         //anulowanie trybów
      if tryb=3 then begin tryb:=0; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; form6.show; label13.caption:=''; end;
      if form14open=true then begin Lw:=Lw-noweLw; Le:=Le-noweLe; form14open:=false; end;
      rysuj;
    end;
  if (shift=[ssleft]) and (wyswietl>0) and (lewymyszy=false) and (miedzywezlami=0) then
    begin
    i:=0;
    repeat
      inc(i);
       KLIKX[i]:=(Lx1[i]/L1[i]*((Xmysz-A)/zoom-Xw1[Wp1[i]])+Ly1[i]/L1[i]*(-(Ymysz-B)/zoom-Yw1[Wp1[i]]));
       KLIKY[i]:=(Ly1[i]/L1[i]*((Xmysz-A)/zoom-Xw1[Wp1[i]])-Lx1[i]/L1[i]*(-(Ymysz-B)/zoom-Yw1[Wp1[i]]));
       if (KLIKX[i]>0) and (KLIKX[i]<L1[i]) and (KLIKY[i]<5/zoom) and (KLIKY[i]>-5/zoom) then
         begin wybranypret:=i; xwybranypret:=klikx[i]/L1[i];  panel3.visible:=true; trackbar2.position:=trunc(xwybranypret*1000); end
       else wybranypret:=0;
     until (i=Le1) or (wybranypret>0);
     lewymyszy:=true;
     rysuj;
    end;
  kliknieto:=false;
  if (shift=[ssleft]) and (wyswietl>0) and (miedzywezlami=2) then
    for i:=1 to Lw1 do if kliknieto=false then
      if sqrt(sqr((Xmysz-A)/zoom-Xw1[i])+sqr(-(Ymysz-B)/zoom-Yw1[i]))<5/zoom then begin wezel2:=i; kliknieto:=true; miedzywezlami:=3;end;
  if (shift=[ssleft]) and (wyswietl>0) and (miedzywezlami=1) then
    for i:=1 to Lw1 do if kliknieto=false then
      if sqrt(sqr((Xmysz-A)/zoom-Xw1[i])+sqr(-(Ymysz-B)/zoom-Yw1[i]))<5/zoom then begin wezel1:=i; kliknieto:=true; miedzywezlami:=2; rysuj; end;
  kliknieto:=false;
  if miedzywezlami=3 then
  begin
    radiobutton3.Checked:=true;
    for i:=1 to Le1 do if (kliknieto=false) and (wp1[i]=wezel1) then begin kliknieto:=true; pret1:=i; pret1p:=true; end;
    for i:=1 to Le1 do if (kliknieto=false) and (wk1[i]=wezel1) then begin kliknieto:=true; pret1:=i; pret1p:=false; end;
    kliknieto:=false;
    for i:=1 to Le1 do if (kliknieto=false) and (wp1[i]=wezel2) then begin kliknieto:=true; pret2:=i; pret2p:=true; end;
    for i:=1 to Le1 do if (kliknieto=false) and (wk1[i]=wezel2) then begin kliknieto:=true; pret2:=i; pret2p:=false; end;
    if (pret1p=true) then begin uxw1:=ux[pret1,1,tenwariant]; uyw1:=uy[pret1,1,tenwariant]; end else begin uxw1:=ux[pret1,nrx[pret1,tenwariant],tenwariant]; uyw1:=uy[pret1,nrx[pret1,tenwariant],tenwariant]; end;
    if (pret2p=true) then begin uxw2:=ux[pret2,1,tenwariant]; uyw2:=uy[pret2,1,tenwariant]; end else begin uxw2:=ux[pret2,nrx[pret2,tenwariant],tenwariant]; uyw2:=uy[pret2,nrx[pret2,tenwariant],tenwariant]; end;
    if wezel1<>wezel2 then begin
      EJ:=1;
      if checkbox2.checked=true then EJ:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ji[combobox1.Items.IndexOf(combobox2.text)+1];
      if checkbox3.checked=true then EJ:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ai[combobox1.Items.IndexOf(combobox2.text)+1];
      if checkbox4.checked=true then EJ:=1/ati[combobox1.Items.IndexOf(combobox2.text)+1];
      if radiobutton5.checked=true then
       begin
         edit5.text:=floattostrf(1/sqrt(sqr(xw1[wezel2]-xw1[wezel1])+sqr(yw1[wezel2]-yw1[wezel1]))*((xw1[wezel2]-xw1[wezel1])*(uxw2-uxw1)+(yw1[wezel2]-yw1[wezel1])*(uyw2-uyw1))*1000*EJ,fffixed,9,5);
         edit6.text:=floattostrf(1/sqrt(sqr(xw1[wezel2]-xw1[wezel1])+sqr(yw1[wezel2]-yw1[wezel1]))*((xw1[wezel2]-xw1[wezel1])*(uyw2-uyw1)-(yw1[wezel2]-yw1[wezel1])*(uxw2-uxw1))*1000*EJ,fffixed,9,5);
       end
       else
       begin
         edit5.text:=floattostrf(1/sqrt(sqr(xw1[wezel2]-xw1[wezel1])+sqr(yw1[wezel2]-yw1[wezel1]))*((xw1[wezel2]-xw1[wezel1])*(uxw2-uxw1)+(yw1[wezel2]-yw1[wezel1])*(uyw2-uyw1))*EJ,fffixed,9,5);
         edit6.text:=floattostrf(1/sqrt(sqr(xw1[wezel2]-xw1[wezel1])+sqr(yw1[wezel2]-yw1[wezel1]))*((xw1[wezel2]-xw1[wezel1])*(uyw2-uyw1)-(yw1[wezel2]-yw1[wezel1])*(uxw2-uxw1))*EJ,fffixed,9,5);
       end;
       if radiobutton1.checked=true then edit7.text:=floattostrf(arctan(-strtofloat(edit6.text)/(1000*sqrt(sqr(xw1[wezel2]-xw[wezel1])+sqr(yw1[wezel2]-yw1[wezel1]))+strtofloat(edit5.text)))*180/pi()*EJ,fffixed,9,5)
                                    else edit7.text:=floattostrf(arctan(-strtofloat(edit6.text)/(1000*sqrt(sqr(xw1[wezel2]-xw[wezel1])+sqr(yw1[wezel2]-yw1[wezel1]))+strtofloat(edit5.text)))*EJ,fffixed,9,5);
    end else begin edit5.text:='0,00000'; edit6.text:='0,00000'; edit7.text:='0,00000'; end;
    miedzywezlami:=0; button2.enabled:=true; button3.enabled:=true; rysuj; label13.caption:='Wyznaczono przemieszczenia między węzłami '+inttostr(wezel1)+' i '+inttostr(wezel2); panel3.Visible:=true;
  end;
  kliknieto:=false;
  if (shift=[ssleft]) and (wyswietl>0) and (miedzywezlami=5) then
  for i:=1 to Le1 do if kliknieto=false then begin
     KLIKX[i]:=(Lx1[i]/L1[i]*((Xmysz-A)/zoom-Xw1[Wp1[i]])+Ly1[i]/L1[i]*(-(Ymysz-B)/zoom-Yw1[Wp1[i]]));
     KLIKY[i]:=(Ly1[i]/L1[i]*((Xmysz-A)/zoom-Xw1[Wp1[i]])-Lx1[i]/L1[i]*(-(Ymysz-B)/zoom-Yw1[Wp1[i]]));
     if (KLIKX[i]>0) and (KLIKX[i]<L1[i]) and (KLIKY[i]<5/zoom) and (KLIKY[i]>-5/zoom) then begin pret2:=i; kliknieto:=true; miedzywezlami:=6; end;
  end;
  kliknieto:=false;
  if (shift=[ssleft]) and (wyswietl>0) and (miedzywezlami=4) then
  for i:=1 to Le1 do if kliknieto=false then begin
     KLIKX[i]:=(Lx1[i]/L1[i]*((Xmysz-A)/zoom-Xw1[Wp1[i]])+Ly1[i]/L1[i]*(-(Ymysz-B)/zoom-Yw1[Wp1[i]]));
     KLIKY[i]:=(Ly1[i]/L1[i]*((Xmysz-A)/zoom-Xw1[Wp1[i]])-Lx1[i]/L1[i]*(-(Ymysz-B)/zoom-Yw1[Wp1[i]]));
     if (KLIKX[i]>0) and (KLIKX[i]<L1[i]) and (KLIKY[i]<5/zoom) and (KLIKY[i]>-5/zoom) then begin pret1:=i; kliknieto:=true; miedzywezlami:=5; rysuj; end;
  end;
  if miedzywezlami=6 then
  begin
    kliknieto:=false;
    EJ:=1;
    if checkbox2.checked=true then EJ:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ji[combobox1.Items.IndexOf(combobox2.text)+1];
    if checkbox3.checked=true then EJ:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ai[combobox1.Items.IndexOf(combobox2.text)+1];
    if checkbox4.checked=true then EJ:=1/ati[combobox1.Items.IndexOf(combobox2.text)+1];
    if pret1=pret2 then begin edit7.text:='0,00000'; label13.caption:='Wybrano ten sam pręt.'; kliknieto:=true; end;
    if (kliknieto=false) then
     if (radiobutton1.checked=true) then begin
      if wp1[pret1]=wp1[pret2] then begin edit7.text:=floattostrf((fi[pret2,1,tenwariant]-fi[pret1,1,tenwariant])*180/pi()*EJ,fffixed,9,5); kliknieto:=true; end;
      if wp1[pret1]=wk1[pret2] then begin edit7.text:=floattostrf((fi[pret2,nrx[pret2,tenwariant],tenwariant]-fi[pret1,1,tenwariant])*180/pi()*EJ,fffixed,9,5); kliknieto:=true; end;
      if wk1[pret1]=wp1[pret2] then begin edit7.text:=floattostrf((fi[pret2,1,tenwariant]-fi[pret1,nrx[pret1,tenwariant],tenwariant])*180/pi()*EJ,fffixed,9,5); kliknieto:=true; end;
      if wk1[pret1]=wk1[pret2] then begin edit7.text:=floattostrf((fi[pret2,nrx[pret2,tenwariant],tenwariant]-fi[pret1,nrx[pret1,tenwariant],tenwariant])*180/pi()*EJ,fffixed,9,5); kliknieto:=true; end;
     end else begin
      if wp1[pret1]=wp1[pret2] then begin edit7.text:=floattostrf((fi[pret2,1,tenwariant]-fi[pret1,1,tenwariant])*EJ,fffixed,9,5); kliknieto:=true; end;
      if wp1[pret1]=wk1[pret2] then begin edit7.text:=floattostrf((fi[pret2,nrx[pret2,tenwariant],tenwariant]-fi[pret1,1,tenwariant])*EJ,fffixed,9,5); kliknieto:=true; end;
      if wk1[pret1]=wp1[pret2] then begin edit7.text:=floattostrf((fi[pret2,1,tenwariant]-fi[pret1,nrx[pret1,tenwariant],tenwariant])*EJ,fffixed,9,5); kliknieto:=true; end;
      if wk1[pret1]=wk1[pret2] then begin edit7.text:=floattostrf((fi[pret2,nrx[pret2,tenwariant],tenwariant]-fi[pret1,nrx[pret1,tenwariant],tenwariant])*EJ,fffixed,9,5); kliknieto:=true; end;
     end;
    if kliknieto=false then begin edit7.text:='0,00000'; label13.caption:='Pręty '+inttostr(pret1)+' i '+inttostr(pret2)+' nie mają wspólnego węzła.' end
      else label13.caption:='Wyznaczono różnicę kątów między prętami '+inttostr(pret1)+' i '+inttostr(pret2)+'.';
    button2.Enabled:=true; button3.enabled:=true; miedzywezlami:=0; rysuj;
  end;
  kliknieto:=false;
  if (shift=[ssleft]) and (tryb=44) then
  for x:=1 to Le do if kliknieto=false then begin
     KLIKX[x]:=(Lx[x]/L[x]*((Xmysz-A)/zoom-Xw[Wp[x]])+Ly[x]/L[x]*(-(Ymysz-B)/zoom-Yw[Wp[x]]));
     KLIKY[x]:=(Ly[x]/L[x]*((Xmysz-A)/zoom-Xw[Wp[x]])-Lx[x]/L[x]*(-(Ymysz-B)/zoom-Yw[Wp[x]]));
     if (KLIKX[x]>0) and (KLIKX[x]<L[x]) and (KLIKY[x]<5/zoom) and (KLIKY[x]>-5/zoom) then begin kliknieto:=true; pretlw:=x; tryb:=0; rysuj; form13.show; end;
  end;
  if (shift=[ssright]) and (tryb=44) then begin tryb:=0; rysuj; form13.show; end;
  if (shift=[ssright]) and (wyswietl>0) then begin miedzywezlami:=0;wybranypret:=0; button2.Enabled:=true; button3.enabled:=true; rysuj; end;
  if tryb=10 then tryb:=0;
  doubleklik:=false;
end;

procedure TForm1.FormMouseEnter(Sender: TObject);
begin
  rysuj;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  yy,kk:integer;
begin
  if tryb=10 then begin tryb:=0;  polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0;
  label13.caption:=''; end;
  Ymysz:=Y; Xmysz:=X;
  if middlemyszy=true then
  begin
    A:=C+Xmysz-Xt;
    B:=D+Ymysz-Yt;
    rysuj;
  end;
  if (wybranypret>0) and (wyswietl>0) and (lewymyszy=true) then
    begin
      KLIKX[wybranypret]:=(Lx1[wybranypret]/L1[wybranypret]*((Xmysz-A)/zoom-Xw1[Wp1[wybranypret]])+Ly1[wybranypret]/L1[wybranypret]*(-(Ymysz-B)/zoom-Yw1[Wp1[wybranypret]]));
      if (KLIKX[wybranypret]>0) and (KLIKX[wybranypret]<L1[wybranypret]) then xwybranypret:=klikx[wybranypret]/L1[wybranypret];
      if klikx[wybranypret]>=L1[wybranypret] then xwybranypret:=1;
      if klikx[wybranypret]<=0 then xwybranypret:=0;
      trackbar2.position:=trunc(xwybranypret*1000);
    end;
  kk:=10000;
  if tryb>0 then  for yy:=1 to Lw do
      if kk>trunc(sqrt(sqr(xmysz-Xw[yy]*zoom-A)+sqr(-ymysz-Yw[yy]*zoom+B)))
      then begin kk:=trunc(sqrt(sqr(xmysz-Xw[yy]*zoom-A)+sqr(-ymysz-Yw[yy]*zoom+B))); cel:=yy; end;
  delta:=kk;
  if (polar=true) and (delta>20) then
    begin
      if (xmysz-Xw[polarpoint]*zoom-A)>0 then polarangle:=90-trunc(arctan((-ymysz-Yw[polarpoint]*zoom+B)/(xmysz-Xw[polarpoint]*zoom-A))*180/pi());
      if (xmysz-Xw[polarpoint]*zoom-A)=0 then if (-ymysz-Yw[polarpoint]*zoom+B)>0 then polarangle:=0 else polarangle:=180;
      if (xmysz-Xw[polarpoint]*zoom-A)<0 then polarangle:=270-trunc(arctan((-ymysz-Yw[polarpoint]*zoom+B)/(xmysz-Xw[polarpoint]*zoom-A))*180/pi());
    end;
  if (tryb=1) or ((tryb>2) and (tryb<13)) then begin label14.caption:='x= '+floattostrf(Xpoint,fffixed,7,3)+'; y= '+floattostrf(Ypoint,fffixed,7,3); end;
  if miedzywezlami>0 then rysuj;
  if tryb2>0 then begin obliczklik; rysuj; end;
  if (tryb>0) and (tryb<44) then rysuj;
  if form13open=true then rysuj;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var minx,miny,maxx,maxy:real;
begin
  Lewymyszy:=false;
  middlemyszy:=false;
  if (shift=[ssDouble]) and (mbmiddle=button) and (Lw>0) then
  begin
    minx:=1000000;miny:=1000000;maxx:=-1000000;maxy:=-1000000;
    for i:=1 to Lw do
    begin
      if Xw[i]>maxx then maxx:=Xw[i];
      if Xw[i]<minx then minx:=Xw[i]; 
      if Yw[i]>maxy then maxy:=Yw[i];
      if Yw[i]<miny then miny:=Yw[i];
    end;
    minx:=minx-1;miny:=miny-1;maxx:=maxx+1;maxy:=maxy+1;
    tryb2:=5;
    xpoczramki:=minx;
    ypoczramki:=maxy;
    xmysz:=round(maxx*zoom+A);
    ymysz:=round(-miny*zoom+B);
    formMouseDown(nil,mbLeft,[ssLeft],Xmysz,Ymysz);
    rysuj;
  end;
  if (wyswietl=0) and (button=mbLeft) and (shift=[ssDouble]) and (tryb=0) and (tryb2=0) and (jedenpunkt=0) then
  begin
    doubleklik:=true;
    formMouseDown(nil,mbLeft,[ssLeft],Xmysz,Ymysz);
  end;
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if zoom>5 then begin A:=trunc((A-Xmysz)*trunc(zoom*5/6)/zoom+Xmysz); B:=trunc((B-Ymysz)*trunc(zoom*5/6)/zoom+Ymysz); zoom:=trunc(zoom*5/6); polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; rysuj; end;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if zoom<3000 then begin A:=trunc((A-Xmysz)*trunc(zoom*6/5)/zoom+Xmysz); B:=trunc((B-Ymysz)*trunc(zoom*6/5)/zoom+Ymysz); zoom:=trunc(zoom*6/5); polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; rysuj; end;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  rysuj;
end;


procedure TForm1.ComboBox1CloseUp(Sender: TObject);     //zmiana przekroju
var hah:boolean;
begin
  hah:=false;
  for i:=1 to Le do if zaznaczonypret[i]=true then begin hah:=true; Prz[i]:=combobox1.ItemIndex; zaznaczonypret[i]:=false; end;
  if hah=true then zapiszwstecz;
  combobox1.Enabled:=false;
  combobox1.Enabled:=true;
end;

procedure TForm1.ComboBox2CloseUp(Sender: TObject);
begin
  combobox2.Enabled:=false;
  combobox2.Enabled:=true;
  trackbar1.Enabled:=false;
  trackbar1.Enabled:=true;
  radiobutton3change;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  panel3.Visible:=false;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  wybranypret:=0; miedzywezlami:=1; button2.enabled:=false; button3.enabled:=false; rysuj;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  wybranypret:=0; miedzywezlami:=4; button2.enabled:=false; button3.enabled:=false; rysuj;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  wczytajopcje;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  if tryb=47 then tryb:=45;
  statyka;
  trackbarzmiana;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  if checkbox2.Checked=true then begin checkbox3.checked:=false; checkbox4.checked:=false; checkbox5.checked:=false; checkbox6.checked:=false end;
  radiobutton3change;
  rysuj;
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  if checkbox3.Checked=true then begin checkbox2.checked:=false; checkbox4.checked:=false; checkbox5.checked:=false; checkbox6.checked:=false end;
  radiobutton3change;
  rysuj;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  if checkbox4.Checked=true then begin checkbox2.checked:=false; checkbox3.checked:=false; checkbox5.checked:=false; checkbox6.checked:=false end;
  radiobutton3change;
  rysuj;
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
  if checkbox5.Checked=true then begin checkbox2.checked:=false; checkbox3.checked:=false; checkbox4.checked:=false; checkbox6.checked:=false end;
  radiobutton3change;
  rysuj;
end;

procedure TForm1.CheckBox6Change(Sender: TObject);
begin
  if checkbox6.Checked=true then begin checkbox2.checked:=false; checkbox3.checked:=false; checkbox4.checked:=false; checkbox5.checked:=false end;
  radiobutton3change;
  rysuj;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  trystrtofloat(edit1.text,xwybranypret);
  if xwybranypret<0 then xwybranypret:=0;
  if xwybranypret>1 then xwybranypret:=1;
  trackbar2.position:=trunc(xwybranypret*1000);
end;

procedure TForm1.FormActivate(Sender: TObject);
var indeks:integer;
begin
  if form8open=true then begin
    form8open:=false;
    with combobox1 do items.Clear;
    for i:=1 to Lprz do with combobox1 do items.add(Nazwaprz[i]);
    combobox1.ItemIndex:=0; if j>=0 then combobox1.ItemIndex:=j;
  end;
  if (okienko=2) and (anulowano=false) then begin zapiszwstecz; okienko:=0; end;                  // co się dzieje po zamknięciu okienka z siłą, ciągłym, momentem, temperaturą
  if anulowano=true then begin okienko:=0;
    indeks:=combobox1.ItemIndex;
    assignfile(plik,'C:/temp/mtr'+czas+'_'+inttostr(pozycja)+'.tmp');
    procesotwierania;
    combobox1.ItemIndex:=indeks;
  end;
  if tryb=45 then statyka;                                                                      //statyka
  if form14open=true then                                                          //kreatorrusztu   i kraty
    begin koniecrysowania; xpoczramki:=1000; ypoczramki:=1000;
     for i:=Le-noweLe+1 to Le do Prz[i]:=combobox1.ItemIndex;
     for i:=1 to Lw do zaznaczonywezel[i]:=false;
     for i:=Lw-noweLw+1 to Lw do zaznaczonywezel[i]:=true;
     for i:=1 to Le do zaznaczonypret[i]:=false;
     for i:=Le-NoweLe+1 to Le do zaznaczonypret[i]:=true;
     tryb:=6; end;
  if form11open=true then begin form11open:=false; koniecrysowania; zapiszwstecz; end;
  if form12open=true then
    begin
     form12open:=false;
     if autosave=0 then idletimer2.Enabled:=false else begin idletimer2.Enabled:=true; idletimer2.Interval:=trunc(autosave*60000); end;  //definiowanie autosave
     wczytajopcje;
    end;
  mbusun.Enabled:=true;        //przywraca mozliwosc usuwania elementow po wyjsciu z innych formularzy
  statusbar1drawpanel;
  rysuj;
end;

procedure TForm1.FormChangeBounds(Sender: TObject);
begin
  rysuj;
end;

procedure TForm1.FormClick(Sender: TObject);
begin

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var bbb:boolean;
    reg:tregistry;
begin
  if zmiana=true then
  case QuestionDlg ('Materia '+wersja,'Czy chcesz zapisać zmiany w pliku '+extractfilename(savedialog1.FileName)+'?',mtConfirmation,[mrYes,'Tak', mrNo, 'Nie', mrCancel, 'Anuluj'],'') of
    mrYes: begin tbzapisz.click; if tak=false then abort else bbb:=true end;
    mrCancel:abort;
    mrNo: bbb:=true;
  end
  else bbb:=true;
  if bbb=true then begin for i:=1 to 10 do deletefile('C:/temp/mtr'+czas+'_'+inttostr(i)+'.tmp'); filestream.Free; deletefile('C:/temp/mtt'+czas+'.tmp');  end;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.Access:= KEY_WRITE;
    Reg.OpenKey('Software\Materia', true); // OpenKey creates the new key, if it does not already exist. Returns true if successful.
    case form1.windowstate of
      wsNormal:Reg.WriteString('Windowstate','wsNormal');
      wsFullScreen:Reg.WriteString('Windowstate','wsFullScreen');
      wsMaximized:Reg.WriteString('Windowstate','wsMaximized');
      wsMinimized:Reg.WriteString('Windowstate','wsMinimized');
    end;
    Reg.WriteString('Top',inttostr(form1.Top));
    Reg.WriteString('Left',inttostr(form1.left));
    Reg.WriteString('Height',inttostr(form1.height));
    Reg.WriteString('Width',inttostr(form1.width));
  finally
    reg.free;
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var bufo:string;
    reg:tregistry;
    tempfiles:tstringlist;
    dataa:tdatetime;
    tempdate:string;
    filestream2:tfilestream;
    State: Integer;

    EXStyle: Longint;
    AppHandle: THandle;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKeyreadonly('.mtr\defaulticon');
    if (not Reg.OpenKeyreadonly('.mtr\defaulticon')) and (Reg.ReadString('')<>ExtractFilePath(Application.ExeName)+'mtrfile.ico,0') then
      begin
       bufo:=ExtractFilePath(Application.ExeName);
       bufo:=stringreplace(bufo,'\','$',[rfreplaceall]);
       bufo:=stringreplace(bufo,'$','\\',[rfreplaceall]);
       assignfile(plik,ExtractFilePath(Application.ExeName)+'mtrfile.reg');
       rewrite(plik);
       writeln(plik,'Windows Registry Editor Version 5.00');
       writeln(plik);
       writeln(plik,'[HKEY_CLASSES_ROOT\.mtr\shell\open\command]');
       writeln(plik,'@="\"'+bufo+'Materia.exe\" \"%1\""');
       writeln(plik);
       writeln(plik,'[HKEY_CLASSES_ROOT\.mtr\DefaultIcon]');
       writeln(plik,'@="'+bufo+'mtrfile.ico,0"');
       writeln(plik);
       writeln(plik,'[HKEY_CLASSES_ROOT\Applications\Materia.exe\shell\open\command]');
       writeln(plik,'@="'+bufo+'Materia.exe"');
       writeln(plik);
       writeln(plik,'[HKEY_CLASSES_ROOT\mtr_auto_file\shell\open\command]');
       writeln(plik,'@="'+bufo+'Materia.exe"');
       writeln(plik);
       writeln(plik,'[HKEY_CLASSES_ROOT\Applications\Materia.exe\DefaultIcon]');
       writeln(plik,'@="'+bufo+'mtrfile.ico,0"');
       closefile(plik);
       assignfile(plik,ExtractFilePath(Application.ExeName)+'regadd.bat');
       rewrite(plik);
       writeln(plik,'@ECHO OFF');
       writeln(plik,'regedit.exe /s "'+ExtractFilePath(Application.ExeName)+'mtrfile.reg"');
       closefile(plik);
       process1.Executable:=ExtractFilePath(Application.ExeName)+'regadd.bat';
       process1.Parameters.Add('-h');
       Process1.Options := Process1.Options + [poWaitOnExit];
       Process1.Execute;
       Process1.Free;
       deletefile(ExtractFilePath(Application.ExeName)+'regadd.bat');
       deletefile(ExtractFilePath(Application.ExeName)+'mtrfile.reg');
       k:=1;
      end;
  finally
    Reg.Free;
  end;
  Form17:=TForm17.Create(nil);
  form17.Show;
  if not DirectoryExists('C:/temp') then createdir('C:/temp');
  tempfiles := FindAllFiles('C:/temp', 'mtt'+'*.tmp', false);
  if tempfiles.Count>0 then begin
    for i:=1 to tempfiles.Count do
     try filestream2:=tfilestream.Create(tempfiles.Strings[i-1],fmopenreadwrite,fmshareexclusive);
         tempdate:=copy(tempfiles.Strings[i-1],12,9);
         filestream2.free;
         deletefile('C:/temp/mtt'+tempdate+'.tmp');
     except;
     end;
  end;
  tempfiles := FindAllFiles('C:/temp', 'mtr'+tempdate+'*.tmp', false);
  if (tempfiles.Count>0) and (tempdate<>'') then begin
    dataa:=-1;
    for i:=1 to tempfiles.count do
      if FileDateTodateTime(fileage(tempfiles.Strings[i-1]))>dataa then begin dataa:=FileDateTodateTime(fileage(tempfiles.Strings[i-1])); j:=i end;
    if QuestionDlg('Uwaga!', 'Ostatnim razem program nie został zamknięty prawidłowo. Czy chcesz otworzyć ostatni odzyskany plik?', mtConfirmation, [mrYes, 'Tak', mrNo, 'Nie'],0)=mrYes
      then begin copyfile(tempfiles.Strings[i-1],ExtractFilePath(Application.ExeName)+'recovered.mtr'); nazwapliku:=ExtractFilePath(Application.ExeName)+'recovered.mtr'; end else j:=0;
    for i:=1 to 10 do deletefile('C:/temp/mtr'+tempdate+'_'+inttostr(i)+'.tmp');
  end;
  Form1.doubleBuffered:=True;
  saveDialog1.Options := saveDialog1.Options + [ofOverwritePrompt];
  odnowa;
  if (ParamCount>=1) or (j>=1) then begin
    if (paramcount>=1) and (j=0) then nazwapliku:=ParamStr(1);
    assignfile(plik,nazwapliku);
    SaveDialog1.filename:=nazwapliku;
    try
    procesotwierania;
    label13.caption:=('otwarto plik '+savedialog1.filename);
    zapiszwstecz;
    TBCofnij.enabled:=false; mbcofnij.enabled:=false; TBCofnij.imageindex:=31; mbcofnij.ImageIndex:=31;
    TBPrzywroc.enabled:=false; mbprzywroc.enabled:=false; TBPrzywroc.ImageIndex:=32; mbprzywroc.ImageIndex:=32;
    ilecofnij:=0;ileprzywroc:=0;
    zmiana:=false;
    form1.caption:='Materia '+wersja+' - '+extractfilename(nazwapliku);
    except
      MessageDlg('Błąd!', 'Plik '+savedialog1.filename+' jest uszkodzony.', mterror, [mbOK], 0);
      odnowa;
    end;
  end;
//  AppHandle := TWin32WidgetSet(WidgetSet).AppHandle;
//  EXStyle:= GetWindowLong(AppHandle, GWL_EXSTYLE);
//  SetWindowLong(AppHandle, GWL_EXSTYLE, EXStyle or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

end;

procedure TForm1.FormDeactivate(Sender: TObject);
begin
  mbusun.Enabled:=false;                  //pozwala na uzywanie del w innych formularzach
end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of String
  );
var otworzyc:boolean;
begin
  otworzyc:=false;
  if zmiana=true then
  case QuestionDlg ('Materia '+wersja,'Czy chcesz zapisać zmiany w pliku '+extractfilename(savedialog1.FileName)+'?',mtConfirmation,[mrYes,'Tak', mrNo, 'Nie', mrCancel, 'Anuluj'],'') of
      mrYes: begin tbZapisz.Click;otworzyc:=true;end;
      mrCancel:;
      mrNo:otworzyc:=true;
  end
  else otworzyc:=true;
  if otworzyc=true then begin
   assignfile(plik,filenames[0]);
   SaveDialog1.filename:=filenames[0];
   try
   procesotwierania;
   label13.caption:=('otwarto plik '+savedialog1.filename);
   TBCofnij.enabled:=false; mbcofnij.enabled:=false; TBCofnij.imageindex:=31; mbcofnij.ImageIndex:=31;
   TBPrzywroc.enabled:=false; mbprzywroc.enabled:=false; TBPrzywroc.ImageIndex:=32; mbprzywroc.ImageIndex:=32;
   ilecofnij:=0;ileprzywroc:=0;
   zmiana:=false;
   form1.caption:='Materia '+wersja+' - '+extractfilename(filenames[0]);
   except
     MessageDlg('Błąd!', 'Plik '+savedialog1.filename+' jest uszkodzony.', mterror, [mbOK], 0);
     odnowa;
   end;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);        //resize
begin
  rysuj;
end;

procedure TForm1.FormShow(Sender: TObject);
var bufor:string;
    reg:tregistry;
begin
  wczytajopcje;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKeyReadOnly('Software\Materia');
    bufor:=Reg.ReadString('Windowstate');
    case bufor of
      'wsNormal':form1.WindowState:=wsnormal;
      'wsFullScreen':form1.WindowState:=wsfullscreen;
      'wsMaximized':form1.WindowState:=wsmaximized;
      'wsMinimized':form1.WindowState:=wsminimized;
    else form1.WindowState:=wsmaximized;
    end;
    form1.Top:=strtointdef(Reg.ReadString('Top'),10);
    form1.Left:=strtointdef(Reg.ReadString('Left'),10);
    form1.Height:=strtointdef(Reg.ReadString('Height'),100);
    form1.Width:=strtointdef(Reg.ReadString('Width'),100);
  finally
    reg.free;
  end;
end;

procedure TForm1.IdleTimer1Timer(Sender: TObject);
begin
  if ((polarpoint<>cel) or (polar=false)) and ((tryb=1) or (tryb>2)) then begin polar:=true; polarpoint:=cel; rysuj; end;
end;

procedure TForm1.IdleTimer2Timer(Sender: TObject);
begin
  label13.caption:=('...autozapis');
  assignfile(plik,ExtractFilePath(Application.ExeName)+'autosave.mtr');
  proceszapisywania;
end;


procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if shift=[ssLeft] then
  begin
    if bar[1]=false then bar[1]:=true else bar[1]:=false;
    statusbar1drawpanel;
    rysuj;
  end;
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if shift=[ssLeft] then
  begin
    if bar[2]=false then bar[2]:=true else bar[2]:=false;
    if bar[2]=true then begin bar[3]:=false; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; end;
    statusbar1drawpanel;
    rysuj;
  end;
end;

procedure TForm1.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if shift=[ssLeft] then
  begin
    if bar[3]=false then bar[3]:=true else bar[3]:=false;
    if bar[3]=true  then bar[2]:=false;
    statusbar1drawpanel;
    rysuj;
  end;
end;


procedure TForm1.Image4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if shift=[ssLeft] then
  begin
    if bar[4]=false then bar[4]:=true else bar[4]:=false;
    if bar[4]=true then for i:=1 to 13 do tekst[i]:=texton[i] else for i:=1 to 13 do tekst[i]:=textoff[i];
    statusbar1drawpanel;
    rysuj;
  end;
end;

procedure TForm1.Label10MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=mbleft then popupmenu2.PopUp;
end;

procedure TForm1.Label19Click(Sender: TObject);
begin
  radiobutton3.Checked:=true;
  radiobutton4.checked:=false;
end;

procedure TForm1.Label20Click(Sender: TObject);
begin
  radiobutton3.Checked:=false;
  radiobutton4.checked:=true;
end;

procedure TForm1.Label21Click(Sender: TObject);
begin
  radiobutton5.Checked:=true;
  radiobutton6.checked:=false;
end;

procedure TForm1.Label22Click(Sender: TObject);
begin
    radiobutton5.Checked:=false;
    radiobutton6.checked:=true;
end;

procedure TForm1.Label23Click(Sender: TObject);
begin
    radiobutton1.Checked:=true;
    radiobutton2.checked:=false;
end;

procedure TForm1.Label24Click(Sender: TObject);
begin 
    radiobutton1.Checked:=false;
    radiobutton2.checked:=true;
end;

procedure TForm1.Label25Click(Sender: TObject);
begin
  if checkbox1.checked=true then begin checkbox1.Checked:=false; exit; end;
  if checkbox1.checked=false then checkbox1.Checked:=true;
end;

procedure TForm1.Label26Click(Sender: TObject);
begin
  if checkbox2.checked=true then begin checkbox2.Checked:=false; exit; end;
  if checkbox2.checked=false then checkbox2.Checked:=true;
end;

procedure TForm1.Label27Click(Sender: TObject);
begin
  if checkbox3.checked=true then begin checkbox3.Checked:=false; exit; end;
  if checkbox3.checked=false then checkbox3.Checked:=true;
end;

procedure TForm1.Label28Click(Sender: TObject);
begin
  if checkbox4.checked=true then begin checkbox4.Checked:=false; exit; end;
  if checkbox4.checked=false then checkbox4.Checked:=true;
end;

procedure TForm1.Label29Click(Sender: TObject);
begin
  if checkbox5.checked=true then begin checkbox5.Checked:=false; exit; end;
  if checkbox5.checked=false then checkbox5.Checked:=true;
end;

procedure TForm1.Label30Click(Sender: TObject);
begin
  if checkbox6.checked=true then begin checkbox6.Checked:=false; exit; end;
  if checkbox6.checked=false then checkbox6.Checked:=true;
end;


procedure TForm1.mbprzekrojClick(Sender: TObject);
var menuitem:tmenuitem;
begin
 mbprzekroj.Clear;  mbprzekroj2.Clear;
 if wyswietl=0 then for i:=0 to combobox1.Items.Count-1 do
  begin
   menuitem:=tmenuitem.create(self);
   menuitem.tag:=i;
   menuitem.OnClick:=@przekrojclick;
   mbprzekroj.add(menuitem);
   mbprzekroj.Items[i].Caption:=combobox1.Items.Strings[i]; end;
 if wyswietl>0 then for i:=0 to combobox2.Items.Count-1 do
  begin
   menuitem:=tmenuitem.create(self);
   menuitem.tag:=i;
   menuitem.OnClick:=@przekrojclick;
   mbprzekroj2.add(menuitem);
   mbprzekroj2.Items[i].Caption:=combobox2.Items.strings[i]; end;
end;

procedure TForm1.mbsuwakClick(Sender: TObject);
var UserString: string;
begin
  if InputQuery('Ustaw wartość skali wyników (0-1600):', 'Obecna wartość: '+floattostr(sqr(sqr(trackbar1.position))/1000000), UserString) then
  trackbar1.Position:=trunc(sqrt(sqrt(strtointdef(userstring,0)*1000000)));
end;

procedure TForm1.mbwariantClick(Sender: TObject);
var menuitem:tmenuitem; bufor:integer;
begin
 mbwariant.Clear;
 if wyswietl>0 then bufor:=warianty1 else bufor:=warianty;
 for i:=0 to bufor do
  begin
   menuitem:=tmenuitem.create(self);
   menuitem.tag:=i;
   menuitem.OnClick:=@wariantclick;
   mbwariant.add(menuitem);
   mbwariant.Items[i].Caption:=inttostr(i)+' '+wariantnazwa[i]; end;
end;

procedure TForm1.PMStatecznoscClick(Sender: TObject);            //statecznosc
begin
  if tryb=0 then
   if Le>0 then begin tryb:=50; statyka; end else  MessageDlg('Błąd!', 'Musisz zamodelować schemat.', mtError, [mbOK], 0);
end;

procedure TForm1.PMStatykaClick(Sender: TObject);
begin
    if tryb=0 then
   if Le>0 then statyka else  MessageDlg('Błąd!', 'Musisz zamodelować schemat.', mtError, [mbOK], 0);
end;

procedure TForm1.PMLiniawplywuClick(Sender: TObject);
begin
  if tryb=0 then
   if Le>0 then begin okienko:=1; form13open:=true; form13.show; end else  MessageDlg('Błąd!', 'Musisz zamodelować schemat.', mtError, [mbOK], 0);
end;

procedure TForm1.PMRozbijClick(Sender: TObject);
begin
  if tryb=0 then
   if Le>0 then begin rozbijobc:=true; statyka; end else  MessageDlg('Błąd!', 'Musisz zamodelować schemat.', mtError, [mbOK], 0);
end;

procedure TForm1.PopupMenu2Popup(Sender: TObject);
var menuitem:tmenuitem; bufor:integer;
begin
 popupmenu2.Items.Clear;
 if wyswietl>0 then bufor:=warianty1 else bufor:=warianty;
 for i:=0 to bufor do
  begin
   menuitem:=tmenuitem.create(self);
   menuitem.Caption:=inttostr(i);
   menuitem.tag:=i;
   menuitem.OnClick:=@wariantclick;
   popupmenu2.items.add(menuitem);
   popupmenu2.Items[i].Caption:=inttostr(i)+' '+wariantnazwa[i]; ; end;
end;

procedure TForm1.Przekrojclick(Sender: TObject);
var menuitem:tmenuitem;
begin
  if wyswietl=0 then begin combobox1.ItemIndex:=menuitem.tag; combobox1closeup(combobox1); end;
  if wyswietl>0 then begin combobox2.ItemIndex:=menuitem.tag; combobox2closeup(combobox2); end;
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  if wybranypret>0 then if trackbar2.position=1000 then begin trackbar2.position:=trackbar2.position-1; trackbar2.position:=trackbar2.position+1 end
  else begin trackbar2.position:=trackbar2.position+1; trackbar2.position:=trackbar2.position-1 end;
  if wybranypret=0 then if radiobutton1.checked=true then edit7.text:=floattostrf(strtofloat(edit7.text)*180/pi(),fffixed,9,5) else edit7.text:=floattostrf(strtofloat(edit7.text)*pi()/180,fffixed,9,5);
end;

procedure TForm1.RadioButton3Change;
begin
 if wybranypret>0 then if trackbar2.position=1000 then begin trackbar2.position:=trackbar2.position-1; trackbar2.position:=trackbar2.position+1 end
 else begin trackbar2.position:=trackbar2.position+1; trackbar2.position:=trackbar2.position-1 end;
end;

procedure Tform1.obliczklik;
var poczatek,koniec:array [1..500]of real;
begin
  kliknietoco:=0;
  for i:=1 to Le do                   //prety
    begin
      KLIKX[i]:=(Lx[i]/L[i]*((Xmysz-A)/zoom-Xw[Wp[i]])+Ly[i]/L[i]*(-(Ymysz-B)/zoom-Yw[Wp[i]]));
      KLIKY[i]:=(Ly[i]/L[i]*((Xmysz-A)/zoom-Xw[Wp[i]])-Lx[i]/L[i]*(-(Ymysz-B)/zoom-Yw[Wp[i]]));
      if (KLIKX[i]>10*screen.pixelsperinch/96/zoom) and (KLIKX[i]<L[i]-10*screen.pixelsperinch/96/zoom) and (KLIKY[i]<10*screen.pixelsperinch/96/zoom) and (KLIKY[i]>-10*screen.pixelsperinch/96/zoom) then begin kliknietoco:=1; kliknietonr:=i; end;
    end;
  for i:=1 to RowsPp do                               //edycja sil
    begin
    KLIKX[i]:=sin(alfap[i]*pi()/180)*((Xmysz-A)/zoom-(Xw[Wk[np[i]]]-Xw[Wp[np[i]]])*xp[i]-Xw[Wp[np[i]]])+cos(alfap[i]*pi()/180)*(-(Ymysz-B)/zoom-(Yw[Wk[np[i]]]-Yw[Wp[np[i]]])*xp[i]-Yw[Wp[np[i]]]);
    KLIKY[i]:=cos(alfap[i]*pi()/180)*((Xmysz-A)/zoom-(Xw[Wk[np[i]]]-Xw[Wp[np[i]]])*xp[i]-Xw[Wp[np[i]]])-sin(alfap[i]*pi()/180)*(-(Ymysz-B)/zoom-(Yw[Wk[np[i]]]-Yw[Wp[np[i]]])*xp[i]-Yw[Wp[np[i]]]);
    if (KLIKY[i]<5/zoom) and (KLIKY[i]>-5/zoom) and (((abs(P[i])>0) and (KLIKX[i]>5/zoom) and (KLIKX[i]<(abs(P[i])/maxP*skalaP+8)/zoom)) or ((abs(P[i])<0) and (KLIKX[i]<5/zoom) and (KLIKX[i]>(abs(P[i])/maxP*skalaP-8)/zoom)))
      then begin kliknietoco:=2; kliknietonr:=i; end;
    end;
  for i:=1 to RowsPq do                                               //edycja q
    begin
      KLIKX[i]:=(Lx[nq[i]]/L[nq[i]]*((Xmysz-A)/zoom-Xw[Wp[nq[i]]])+Ly[nq[i]]/L[nq[i]]*(-(Ymysz-B)/zoom-Yw[Wp[nq[i]]]));
      KLIKY[i]:=(Ly[nq[i]]/L[nq[i]]*((Xmysz-A)/zoom-Xw[Wp[nq[i]]])-Lx[nq[i]]/L[nq[i]]*(-(Ymysz-B)/zoom-Yw[Wp[nq[i]]]));
      poczatek[i]:=(xqi[i]*L[nq[i]]+Pqi[i]/maxQ*skalaQ*cos(pi()/2-alfapr[nq[i]]-alfaq[i]*pi()/180)/zoom);
      koniec[i]  :=(xqj[i]*L[nq[i]]+Pqj[i]/maxQ*skalaQ*cos(pi()/2-alfapr[nq[i]]-alfaq[i]*pi()/180)/zoom);
      if  ((-KLIKY[i]<( 5+Pqi[i]/maxQ*skalaQ*sin(pi()/2-alfapr[nq[i]]-alfaq[i]*pi()/180)+(KLIKX[i]-poczatek[i])/(koniec[i]-poczatek[i])*(Pqj[i]-Pqi[i])/maxQ*skalaQ*sin(pi()/2-alfapr[nq[i]]-alfaq[i]*pi()/180))/zoom)
      and (-KLIKY[i]>(-5+Pqi[i]/maxQ*skalaQ*sin(pi()/2-alfapr[nq[i]]-alfaq[i]*pi()/180)+(KLIKX[i]-poczatek[i])/(koniec[i]-poczatek[i])*(Pqj[i]-Pqi[i])/maxQ*skalaQ*sin(pi()/2-alfapr[nq[i]]-alfaq[i]*pi()/180))/zoom)
      and (KLIKX[i]>poczatek[i]) and (KLIKX[i]<koniec[i])) then begin kliknietoco:=3; kliknietonr:=i; end;
    end;
  for i:=1 to RowsPq do                                                //edycja q strzałka1
    begin
      KLIKX[i]:=sin(alfaq[i]*pi()/180)*((Xmysz-A)/zoom-(Xw[Wk[nq[i]]]-Xw[Wp[nq[i]]])*xqi[i]-Xw[Wp[nq[i]]])+cos(alfaq[i]*pi()/180)*(-(Ymysz-B)/zoom-(Yw[Wk[nq[i]]]-Yw[Wp[nq[i]]])*xqi[i]-Yw[Wp[nq[i]]]);
      KLIKY[i]:=cos(alfaq[i]*pi()/180)*((Xmysz-A)/zoom-(Xw[Wk[nq[i]]]-Xw[Wp[nq[i]]])*xqi[i]-Xw[Wp[nq[i]]])-sin(alfaq[i]*pi()/180)*(-(Ymysz-B)/zoom-(Yw[Wk[nq[i]]]-Yw[Wp[nq[i]]])*xqi[i]-Yw[Wp[nq[i]]]);
      if (KLIKY[i]<5/zoom) and (KLIKY[i]>-5/zoom) and (((pqi[i]>0) and (KLIKX[i]>5/zoom) and (KLIKX[i]<(Pqi[i]/maxq*skalaq)/zoom)) or ((pqi[i]<0) and (KLIKX[i]<5/zoom) and (KLIKX[i]>(Pqi[i]/maxq*skalaq)/zoom)))
        then begin kliknietoco:=3; kliknietonr:=i; end;
    end;
  for i:=1 to RowsPq do                                              //edycja q strzałka2
    begin
      KLIKX[i]:=sin(alfaq[i]*pi()/180)*((Xmysz-A)/zoom-(Xw[Wk[nq[i]]]-Xw[Wp[nq[i]]])*xqj[i]-Xw[Wp[nq[i]]])+cos(alfaq[i]*pi()/180)*(-(Ymysz-B)/zoom-(Yw[Wk[nq[i]]]-Yw[Wp[nq[i]]])*xqj[i]-Yw[Wp[nq[i]]]);
      KLIKY[i]:=cos(alfaq[i]*pi()/180)*((Xmysz-A)/zoom-(Xw[Wk[nq[i]]]-Xw[Wp[nq[i]]])*xqj[i]-Xw[Wp[nq[i]]])-sin(alfaq[i]*pi()/180)*(-(Ymysz-B)/zoom-(Yw[Wk[nq[i]]]-Yw[Wp[nq[i]]])*xqj[i]-Yw[Wp[nq[i]]]);
      if (KLIKY[i]<5/zoom) and (KLIKY[i]>-5/zoom) and (((pqj[i]>0) and (KLIKX[i]>5/zoom) and (KLIKX[i]<(Pqj[i]/maxq*skalaq)/zoom)) or ((pqj[i]<0) and (KLIKX[i]<5/zoom) and (KLIKX[i]>(Pqj[i]/maxq*skalaq)/zoom)))
        then begin kliknietoco:=3; kliknietonr:=i; end;
    end;
  for i:=1 to RowsPm do                         //edycja momentow
    begin
      KLIKX[i]:=-sin(alfapr[nm[i]])*((Xmysz-A)/zoom-(Xw[Wk[nm[i]]]-Xw[Wp[nm[i]]])*xm[i]-Xw[Wp[nm[i]]])+cos(alfapr[nm[i]])*(-(Ymysz-B)/zoom-(Yw[Wk[nm[i]]]-Yw[Wp[nm[i]]])*xm[i]-Yw[Wp[nm[i]]]);
      KLIKY[i]:=cos(alfapr[nm[i]])*((Xmysz-A)/zoom-(Xw[Wk[nm[i]]]-Xw[Wp[nm[i]]])*xm[i]-Xw[Wp[nm[i]]])+sin(alfapr[nm[i]])*(-(Ymysz-B)/zoom-(Yw[Wk[nm[i]]]-Yw[Wp[nm[i]]])*xm[i]-Yw[Wp[nm[i]]]);
      if ((KLIKY[i]<5/zoom) and (KLIKY[i]>-5/zoom) and (KLIKX[i]>-25/zoom) and (KLIKX[i]<25/zoom))
      or ((Pm[i]>=0) and (KLIKY[i]<25/zoom) and (KLIKY[i]>0/zoom) and (KLIKX[i]>20/zoom) and (KLIKX[i]<30/zoom))
      or ((Pm[i]>=0) and (KLIKY[i]>-25/zoom) and (KLIKY[i]<0/zoom) and (KLIKX[i]>-30/zoom) and (KLIKX[i]<-20/zoom))
      or ((Pm[i]<0) and (KLIKY[i]>-25/zoom) and (KLIKY[i]<0/zoom) and (KLIKX[i]>20/zoom) and (KLIKX[i]<30/zoom))
      or ((Pm[i]<0) and (KLIKY[i]<25/zoom) and (KLIKY[i]>0/zoom) and (KLIKX[i]>-30/zoom) and (KLIKX[i]<-20/zoom)) then begin kliknietoco:=4; kliknietonr:=i; end;
    end;
  for i:=1 to RowsPt do                                //edycja temperatur
    begin
      KLIKX[i]:=Lx[nt[i]]*zoom/4+A+Xw[Wp[nt[i]]]*zoom+6-Xmysz;
      KLIKY[i]:=-Ly[nt[i]]*zoom/4+B-Yw[Wp[nt[i]]]*zoom-Ymysz;
      if (KLIKY[i]>-7*screen.pixelsperinch/96) and (KLIKY[i]<7*screen.pixelsperinch/96) and (KLIKX[i]>-7*screen.pixelsperinch/96) and (KLIKX[i]<7*screen.pixelsperinch/96) then begin kliknietoco:=5; kliknietonr:=i; end;
    end;
  for i:=1 to Lw do                                                //edycja podpór
    begin
      if sqrt(sqr((Xmysz-A)/zoom-Xw[i])+sqr(-(Ymysz-B)/zoom-Yw[i]))<10*screen.pixelsperinch/96/zoom then begin kliknietoco:=6; kliknietonr:=i; end;
    end;
end;


procedure TForm1.RadioButton5Change(Sender: TObject);
begin
  if radiobutton5.checked=true then edit5.text:=floattostrf(strtofloat(edit5.text)*1000,fffixed,9,5) else edit5.text:=floattostrf(strtofloat(edit5.text)/1000,fffixed,9,5);
  if radiobutton5.checked=true then edit6.text:=floattostrf(strtofloat(edit6.text)*1000,fffixed,9,5) else edit6.text:=floattostrf(strtofloat(edit6.text)/1000,fffixed,9,5);
end;

procedure Tform1.rysuj;
var x1,y1:real; oo:integer; rownaj: array [1..6] of integer;
    EJ,angle:real;
    aaaa,bbbb:string;
    mybitmap:tbitmap;
    maxx,maxy,xrect,yrect:integer;
    znak:integer;
    rea:real;
begin;
  MyBitmap := TBitmap.Create;
  try
  MyBitmap.SetSize(Width,Height);
  mybitmap.canvas.brush.color:=kolor[1];
  mybitmap.Canvas.FillRect(0,0,width,height);
  mybitmap.canvas.pen.style:=pssolid;
  mybitmap.Canvas.Font.Style:=[];
  mybitmap.canvas.Brush.Color:=kolor[10];
  mybitmap.canvas.font.Size:=rozmiar[2];
  mybitmap.canvas.pen.Width:=1;
  mybitmap.canvas.pen.color:=kolor[13];
  mybitmap.canvas.Line(5,height-37-panel4.Height,5,height-43-panel4.Height);
  mybitmap.canvas.pen.color:=kolor[17];
  if zoom>15 then begin                                        //siatka i skala
    if (bar[1]=true) and (rozmiar[3]=1) then for i:=-round(A/zoom) to round((Width-A)/zoom) do
      for x:=-round(B/zoom) to round((Height-B)/zoom) do mybitmap.Canvas.Pixels[A+i*zoom,B+x*zoom]:=kolor[17];
    if (bar[1]=true) and (rozmiar[3]=0) then for i:=-round(A/zoom) to round((Width-A)/zoom) do mybitmap.canvas.line(A+i*zoom,0,A+i*zoom,height);
    if (bar[1]=true) and (rozmiar[3]=0) then for x:=-round(B/zoom) to round((Height-B)/zoom) do mybitmap.canvas.line(0,B+x*zoom,width,B+x*zoom);
    mybitmap.canvas.pen.color:=kolor[13];
    mybitmap.canvas.textout(round(zoom/2),height-40-panel4.Height-round(1.8*rozmiar[2]*screen.pixelsperinch/96),'1m');
    mybitmap.canvas.Line(5,height-40-panel4.Height,5+zoom,height-40-panel4.Height);
    mybitmap.canvas.Line(5+zoom,height-37-panel4.Height,5+zoom,height-43-panel4.Height);
  end;
  if (zoom <=15) and (zoom>9) then begin
    if (bar[1]=true) and (rozmiar[3]=1) then for i:=-round(A/zoom/2) to round((Width-A)/zoom/2) do
      for x:=-round(B/zoom/2) to round((Height-B)/zoom/2) do mybitmap.Canvas.Pixels[A+i*2*zoom,B+x*2*zoom]:=kolor[17];
    mybitmap.canvas.pen.color:=kolor[17];
    if (bar[1]=true) and (rozmiar[3]=0) then for i:=-round(A/zoom/2) to round((Width-A)/zoom/2) do mybitmap.canvas.line(A+i*2*zoom,0,A+i*2*zoom,height);
    if (bar[1]=true) and (rozmiar[3]=0) then for x:=-round(B/zoom/2) to round((Height-B)/zoom/2) do mybitmap.canvas.line(0,B+x*2*zoom,width,B+x*2*zoom);
    mybitmap.canvas.pen.color:=kolor[13];
    mybitmap.canvas.textout(zoom,height-40-panel4.Height-round(1.8*rozmiar[2]*screen.pixelsperinch/96),'2m');
    mybitmap.canvas.Line(5,height-40-panel4.Height,5+zoom*2,height-40-panel4.Height);
    mybitmap.canvas.Line(5+zoom*2,height-37-panel4.Height,5+zoom*2,height-43-panel4.Height);
  end;
  if zoom <=9 then begin
    if (bar[1]=true) and (rozmiar[3]=1) then for i:=-round(A/zoom/5) to round((Width-A)/zoom/5) do
      for x:=-round(B/zoom/5) to round((Height-B)/zoom/5) do mybitmap.Canvas.Pixels[A+i*5*zoom,B+x*5*zoom]:=kolor[17];
    mybitmap.canvas.pen.color:=kolor[17];
    if (bar[1]=true) and (rozmiar[3]=0) then for i:=-round(A/zoom/5) to round((Width-A)/zoom/5) do mybitmap.canvas.line(A+i*5*zoom,0,A+i*5*zoom,height);
    if (bar[1]=true) and (rozmiar[3]=0) then for x:=-round(B/zoom/5) to round((Height-B)/zoom/5) do mybitmap.canvas.line(0,B+x*5*zoom,width,B+x*5*zoom);
    mybitmap.canvas.pen.color:=kolor[13];
    mybitmap.canvas.textout(round(zoom*2.5),height-40-panel4.Height-round(1.8*rozmiar[2]*screen.pixelsperinch/96),'5m');
    mybitmap.canvas.Line(5,height-40-panel4.Height,5+zoom*5,height-40-panel4.Height);
    mybitmap.canvas.Line(5+zoom*5,height-37-panel4.Height,5+zoom*5,height-43-panel4.Height);
  end;
  mybitmap.canvas.pen.Width:=1;
  mybitmap.Canvas.Font.Bold:=false;
  mybitmap.canvas.pen.color:=kolor[13];
  mybitmap.canvas.Line(A,B+5,A,B-20);
  mybitmap.canvas.Line(A-5,B,A+20,B);
  mybitmap.canvas.brush.color:=kolor[10];
  if form6open=true then for i:=1 to PreLwar do if zaznaczonywezel[s[i]]=true then zaznaczonywezel[s[i]]:=false;  //odznaczanie t i podpor jesli juz jest w tym miejscu
  if form5open=true then for i:=1 to PreRowsPt do if zaznaczonypret[nt[i]]=true then zaznaczonypret[nt[i]]:=false;
  if tryb=1 then                                     //tryb rysowania preta
    begin
      mybitmap.canvas.line(round(Xpoint*zoom+A-10),round(-Ypoint*zoom+B),round(Xpoint*zoom+A+10),round(-Ypoint*zoom+B));
      mybitmap.canvas.line(round(Xpoint*zoom+A),round(-Ypoint*zoom+B-10),round(Xpoint*zoom+A),round(-Ypoint*zoom+B+10));
    end;
  mybitmap.canvas.pen.color:=kolor[14];
  if tryb=2 then                      //zaznaczanie ramka
    begin
      if (Xpoczramki<(Xmysz-A)/zoom) then mybitmap.canvas.pen.Style:=pssolid else mybitmap.canvas.pen.Style:=psdot;
      mybitmap.canvas.line(Xmysz,Ymysz,Xmysz,round(-Ypoczramki*zoom+B));
      mybitmap.canvas.line(Xmysz,Ymysz,round(Xpoczramki*zoom+A),Ymysz);
      mybitmap.canvas.line(round(Xpoczramki*zoom+A),Ymysz,round(Xpoczramki*zoom+A),round(-Ypoczramki*zoom+B));
      mybitmap.canvas.line(Xmysz,round(-Ypoczramki*zoom+B),round(Xpoczramki*zoom+A),round(-Ypoczramki*zoom+B));
    end;
  if (tryb2=3) or (tryb2=5) then                      //zaznaczanie ramka
    begin
      mybitmap.canvas.pen.Style:=pssolid;
      mybitmap.canvas.line(Xmysz,Ymysz,Xmysz,round(-Ypoczramki*zoom+B));
      mybitmap.canvas.line(Xmysz,Ymysz,round(Xpoczramki*zoom+A),Ymysz);
      mybitmap.canvas.line(round(Xpoczramki*zoom+A),Ymysz,round(Xpoczramki*zoom+A),round(-Ypoczramki*zoom+B));
      mybitmap.canvas.line(Xmysz,round(-Ypoczramki*zoom+B),round(Xpoczramki*zoom+A),round(-Ypoczramki*zoom+B));
    end;
  if tryb=3 then                          //tryb ustawiania kierunku podpory
    begin
     mybitmap.canvas.pen.Style:=pssolid;
     mybitmap.canvas.line(round(Xpoint*zoom+A-10),round(-Ypoint*zoom+B),round(Xpoint*zoom+A+10),round(-Ypoint*zoom+B));
     mybitmap.canvas.line(round(Xpoint*zoom+A),round(-Ypoint*zoom+B-10),round(Xpoint*zoom+A),round(-Ypoint*zoom+B+10));
     mybitmap.canvas.pen.Style:=psdot;
     i:=0;
     repeat inc(i) until zaznaczonywezel[i]=true;
     mybitmap.canvas.line(round(Xpoint*zoom+A),round(-Ypoint*zoom+B),round(A+zoom*Xw[i]),round(B-zoom*Yw[i]));
    end;
  mybitmap.canvas.pen.Style:=pssolid;
  mybitmap.canvas.pen.color:=kolor[13];
  if (tryb=5) or (tryb=7) or (tryb=11) or (tryb=13) then           //punkt poczatkowy przy przenoszeniu, kopiowaniu,lustrze, obrocie
    begin
     mybitmap.canvas.line(round(Xpoint*zoom+A-10),round(-Ypoint*zoom+B),round(Xpoint*zoom+A+10),round(-Ypoint*zoom+B));
     mybitmap.canvas.line(round(Xpoint*zoom+A),round(-Ypoint*zoom+B-10),round(Xpoint*zoom+A),round(-Ypoint*zoom+B+10));
    end;
  if (tryb=6) or (tryb=8) or (tryb=12) or (tryb=14) then                //punkt koncowy przy przenoszeniu, kopiowaniu,lustrze, obrocie
    begin
     mybitmap.canvas.line(round(Xpoint*zoom+A-10),round(-Ypoint*zoom+B),round(Xpoint*zoom+A+10),round(-Ypoint*zoom+B));
     mybitmap.canvas.line(round(Xpoint*zoom+A),round(-Ypoint*zoom+B-10),round(Xpoint*zoom+A),round(-Ypoint*zoom+B+10));
     mybitmap.canvas.pen.Style:=psdot;
     mybitmap.canvas.pen.color:=kolor[14];
     if form14open=false then mybitmap.canvas.line(round(Xpoint*zoom+A),round(-Ypoint*zoom+B),A+round(zoom*Xpoczramki),B-round(zoom*Ypoczramki));
      if (tryb=6) or (tryb=8) then      //przenoszenie i kopiowanie
          for i:=1 to Le do if zaznaczonypret[i]=true then mybitmap.canvas.line(round((Xw[Wp[i]]+Xpoint-Xpoczramki)*zoom)+A,-round((Yw[Wp[i]]+Ypoint-Ypoczramki)*zoom)+B,round((Xw[Wk[i]]+Xpoint-Xpoczramki)*zoom)+A,-round((Yw[Wk[i]]+Ypoint-Ypoczramki)*zoom)+B);
     if tryb=12 then                    //lustro
      begin
       for i:=1 to Le do if zaznaczonypret[i]=true then
        begin
          x1:=Xpoint-Xpoczramki;
          y1:=Ypoint-Ypoczramki;
          if x1=0 then mybitmap.canvas.line(round((Xw[Wp[i]]+2*(Xpoczramki-Xw[Wp[i]]))*zoom)+A,-round(Yw[Wp[i]]*zoom)+B,round((Xw[Wk[i]]+2*(Xpoczramki-Xw[Wk[i]]))*zoom)+A,-round(Yw[Wk[i]]*zoom)+B)
          else mybitmap.canvas.line(round((Xw[Wp[i]]-2*(Ypoint-Yw[Wp[i]]+(Xw[Wp[i]]-Xpoczramki)*y1/x1-y1)/(1+y1*y1/x1/x1)*y1/x1)*zoom)+A,-round((Yw[Wp[i]]+2*(Ypoint-Yw[Wp[i]]+(Xw[Wp[i]]-Xpoczramki)*y1/x1-y1)/(1+y1*y1/x1/x1))*zoom)+B,round((Xw[Wk[i]]-2*(Ypoint-Yw[Wk[i]]+(Xw[Wk[i]]-Xpoczramki)*y1/x1-y1)/(1+y1*y1/x1/x1)*y1/x1)*zoom)+A,-round((Yw[Wk[i]]+2*(Ypoint-Yw[Wk[i]]+(Xw[Wk[i]]-Xpoczramki)*y1/x1-y1)/(1+y1*y1/x1/x1))*zoom)+B);
        end;
      end;
      if tryb=14 then                         //obrot
       begin
        for i:=1 to Le do if zaznaczonypret[i]=true then
         begin
           x1:=Xpoint-Xpoczramki;
           y1:=Ypoint-Ypoczramki;
           angle:=ATAN(-y1,x1);
           if x1<0 then angle:=angle+pi();
           if (x1>=0) and (y1>0) then angle:=angle+2*pi();
           mybitmap.canvas.line(round(((Xw[Wp[i]]-xpoczramki)*COS(angle)+(Yw[Wp[i]]-ypoczramki)*SIN(angle)+xpoczramki)*zoom)+A,-round((-(Xw[Wp[i]]-xpoczramki)*SIN(angle)+(Yw[Wp[i]]-ypoczramki)*COS(angle)+ypoczramki)*zoom)+B,round(((Xw[Wk[i]]-xpoczramki)*COS(angle)+(Yw[Wk[i]]-ypoczramki)*SIN(angle)+xpoczramki)*zoom)+A,-round((-(Xw[Wk[i]]-xpoczramki)*SIN(angle)+(Yw[Wk[i]]-ypoczramki)*COS(angle)+ypoczramki)*zoom)+B);
         end;
        mybitmap.canvas.line(width,B-round(zoom*Ypoczramki),A+round(zoom*Xpoczramki),B-round(zoom*Ypoczramki));
        if angle>0 then mybitmap.Canvas.arc(A+round(zoom*Xpoczramki)-50,B-round(zoom*Ypoczramki)-50,A+round(zoom*Xpoczramki)+50,B-round(zoom*Ypoczramki)+50,360*16-round(angle*180/pi()*16),round(angle*180/pi()*16));
        mybitmap.canvas.textout(A+round(zoom*Xpoczramki)+60,B-round(zoom*Ypoczramki)+10,floattostr(round(angle*180/pi()*1000)/1000)+'°')
       end;
    end;
  mybitmap.canvas.pen.Style:=pssolid;
  if jedenpunkt=1 then                                      //obliczanie długości rysowanego pręta
    begin
      Xw[Lw+1]:=Xpoint;
      Yw[Lw+1]:=Ypoint;
      Wk[Le]:=Lw+1;
    end;
  mybitmap.canvas.pen.Width:=1;
  if form7open=true then for i:=1 to Le do if zaznaczonypret[i]=true then              //krzyzyki przy trybie dzielenia preta
    begin
      if form7type=true then
        for j:=1 to form7podz-1 do
          begin
            mybitmap.canvas.line(A+round(((Xw[Wk[i]]-Xw[Wp[i]])*j/form7podz+Xw[Wp[i]])*zoom)-5,B-round(((Yw[Wk[i]]-Yw[Wp[i]])*j/form7podz+Yw[Wp[i]])*zoom)-5,A+round(((Xw[Wk[i]]-Xw[Wp[i]])*j/form7podz+Xw[Wp[i]])*zoom)+5,B-round(((Yw[Wk[i]]-Yw[Wp[i]])*j/form7podz+Yw[Wp[i]])*zoom)+5);
            mybitmap.canvas.line(A+round(((Xw[Wk[i]]-Xw[Wp[i]])*j/form7podz+Xw[Wp[i]])*zoom)-5,B-round(((Yw[Wk[i]]-Yw[Wp[i]])*j/form7podz+Yw[Wp[i]])*zoom)+5,A+round(((Xw[Wk[i]]-Xw[Wp[i]])*j/form7podz+Xw[Wp[i]])*zoom)+5,B-round(((Yw[Wk[i]]-Yw[Wp[i]])*j/form7podz+Yw[Wp[i]])*zoom)-5);
          end;
      if form7type=false then
        begin
          mybitmap.canvas.line(A+round(((Xw[Wk[i]]-Xw[Wp[i]])*form7x+Xw[Wp[i]])*zoom)-5,B-round(((Yw[Wk[i]]-Yw[Wp[i]])*form7x+Yw[Wp[i]])*zoom)-5,A+round(((Xw[Wk[i]]-Xw[Wp[i]])*form7x+Xw[Wp[i]])*zoom)+5,B-round(((Yw[Wk[i]]-Yw[Wp[i]])*form7x+Yw[Wp[i]])*zoom)+5);
          mybitmap.canvas.line(A+round(((Xw[Wk[i]]-Xw[Wp[i]])*form7x+Xw[Wp[i]])*zoom)-5,B-round(((Yw[Wk[i]]-Yw[Wp[i]])*form7x+Yw[Wp[i]])*zoom)+5,A+round(((Xw[Wk[i]]-Xw[Wp[i]])*form7x+Xw[Wp[i]])*zoom)+5,B-round(((Yw[Wk[i]]-Yw[Wp[i]])*form7x+Yw[Wp[i]])*zoom)-5);
        end;
    end;
  for i:=1 to Le do
  begin                                  //prety
    mybitmap.canvas.pen.Width:=3 ;
    if zaznaczonypret[i]=true then mybitmap.canvas.Pen.Color:=kolor[3] else mybitmap.canvas.pen.Color:=kolor[2];
    mybitmap.canvas.Line(A+round(Xw[Wp[i]]*zoom),B-round(Yw[Wp[i]]*zoom),A+round(Xw[Wk[i]]*zoom),B-round(Yw[Wk[i]]*zoom));
    mybitmap.canvas.Font.Color:=kolor[14];
    mybitmap.canvas.Font.Size:=rozmiar[1];
    mybitmap.canvas.pen.Width:=1;
    case typs[i] of                                      //przeguby
     2:mybitmap.canvas.EllipseC(A+round(Xw[Wp[i]]*zoom+7*cos(alfapr[i])),B-round(Yw[Wp[i]]*zoom+7*sin(alfapr[i])),5,5);
     3:mybitmap.canvas.EllipseC(A+round(Xw[Wk[i]]*zoom-7*cos(alfapr[i])),B-round(Yw[Wk[i]]*zoom-7*sin(alfapr[i])),5,5);
     4:begin mybitmap.canvas.EllipseC(A+round(Xw[Wp[i]]*zoom+7*cos(alfapr[i])),B-round(Yw[Wp[i]]*zoom+7*sin(alfapr[i])),5,5); mybitmap.canvas.EllipseC(A+round(Xw[Wk[i]]*zoom-7*cos(alfapr[i])),B-round(Yw[Wk[i]]*zoom-7*sin(alfapr[i])),5,5);end;
    end;
  end;
  i:=0;
  mybitmap.canvas.pen.style:=psdot;
  mybitmap.canvas.pen.Color:=kolor[2];
  if ((jedenpunkt=0) and (Le>0)) or ((jedenpunkt=1) and (Le>1))then repeat
    inc(i);
    oo:=0;
    if (tekst[9]=true) and (form14open=false) then mybitmap.canvas.Line(A+round(Xw[Wp[i]]*zoom+4*Ly[i]/L[i]),B-round(Yw[Wp[i]]*zoom-4*Lx[i]/L[i]),A+round(Xw[Wk[i]]*zoom+4*Ly[i]/L[i]),B-round(Yw[Wk[i]]*zoom-4*Lx[i]/L[i]));
    if (tekst[2]=true) then begin mybitmap.canvas.textout(round((Xw[Wk[i]]+Xw[Wp[i]])*zoom/2+A+15),round(-(Yw[Wk[i]]+Yw[Wp[i]])*zoom/2+B+10+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),inttostr(i)); inc(oo); end;
    if (tekst[3]=true) then begin mybitmap.canvas.textout(round((Xw[Wk[i]]+Xw[Wp[i]])*zoom/2+A+5),round(-(Yw[Wk[i]]+Yw[Wp[i]])*zoom/2+B+10+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),nazwaPrz[prz[i]+1]); inc(oo); end;
    if (tekst[7]=true) then begin mybitmap.canvas.textout(round((Xw[Wk[i]]+Xw[Wp[i]])*zoom/2+A+5),round(-(Yw[Wk[i]]+Yw[Wp[i]])*zoom/2+B+10+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'Lx= '+floattostrf(Lx[i],fffixed,7,3)+'m'); inc(oo);
                                  mybitmap.canvas.textout(round((Xw[Wk[i]]+Xw[Wp[i]])*zoom/2+A+5),round(-(Yw[Wk[i]]+Yw[Wp[i]])*zoom/2+B+10+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'Ly= '+floattostrf(Ly[i],fffixed,7,3)+'m'); inc(oo);end;
    if (tekst[8]=true) then begin mybitmap.canvas.textout(round((Xw[Wk[i]]+Xw[Wp[i]])*zoom/2+A+5),round(-(Yw[Wk[i]]+Yw[Wp[i]])*zoom/2+B+10+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'L= '+floattostrf(L[i],fffixed,7,3)+'m'); inc(oo); end;
    if (tekst[11]=true) then mybitmap.canvas.textout(round((Xw[Wk[i]]+Xw[Wp[i]])*zoom/2+A+5),round(-(Yw[Wk[i]]+Yw[Wp[i]])*zoom/2+B+10+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'α= '+floattostrf(alfapr[i]*180/pi(),fffixed,7,3)+'°');
  until ((jedenpunkt=0) and (i=Le)) or ((jedenpunkt=1) and (i=Le-1));
  mybitmap.canvas.pen.Width:=3;
  mybitmap.canvas.pen.Style:=pssolid;
  mybitmap.canvas.Font.Color:=kolor[13];
  mybitmap.canvas.Font.Size:=rozmiar[2];
  for i:=1 to Lw do begin                              //wezly
    oo:=0;
    if zaznaczonywezel[i]=true then mybitmap.canvas.Pen.Color:=kolor[5] else mybitmap.canvas.pen.Color:=kolor[4];
    mybitmap.canvas.EllipseC(A+round(Xw[i]*zoom),B-round(Yw[i]*zoom),2,2);
    if (tekst[1]=true) then begin mybitmap.canvas.textout(round(Xw[i]*zoom+A+5),round(-Yw[i]*zoom+B+10+1.6*oo*rozmiar[2]*screen.pixelsperinch/96),inttostr(i)); inc(oo); end;
    if (tekst[6]=true) then begin mybitmap.canvas.textout(round(Xw[i]*zoom+A+5),round(-Yw[i]*zoom+B+10+1.6*oo*rozmiar[2]*screen.pixelsperinch/96),'X= '+floattostrf(Xw[i],fffixed,7,3)+'m'); inc(oo);
                                  mybitmap.canvas.textout(round(Xw[i]*zoom+A+5),round(-Yw[i]*zoom+B+10+1.6*oo*rozmiar[2]*screen.pixelsperinch/96),'Y= '+floattostrf(Yw[i],fffixed,7,3)+'m'); end;
  end;
  mybitmap.canvas.pen.width:=1;
  mybitmap.canvas.font.Size:=rozmiar[2];
  mybitmap.canvas.pen.Color:=kolor[14];
  if jedenpunkt=1 then begin      //wymiary pręta przy rysowaniu
    mybitmap.canvas.textout(A+10+round((Xw[Wp[Le]]+Xw[Wk[Le]])/2*zoom),B-20-round((Yw[Wp[Le]]+Yw[Wk[Le]])/2*zoom),floattostr(round(100*sqrt(sqr(Xw[Wp[Le]]-Xw[Wk[Le]])+sqr(Yw[Wp[Le]]-Yw[Wk[Le]])))/100));
    if xw[wk[le]]>xw[wp[le]] then x1:=xw[wk[le]] else x1:=xw[wp[le]];
    mybitmap.canvas.textout(A+round(x1*zoom)+25,B-round((Yw[Wp[Le]]+Yw[Wk[Le]])/2*zoom),floattostr(round(abs(yw[wp[Le]]-yw[wk[Le]])*100)/100));
    mybitmap.canvas.line(round(x1*zoom)+A+20,-round(yw[wp[le]]*zoom)+B,round(x1*zoom)+A+20,-round(yw[wk[le]]*zoom)+B);
    mybitmap.canvas.line(round(x1*zoom)+A+15,-round(yw[wp[le]]*zoom)+B,round(x1*zoom)+A+25,-round(yw[wp[le]]*zoom)+B);
    mybitmap.canvas.line(round(x1*zoom)+A+15,-round(yw[wk[le]]*zoom)+B,round(x1*zoom)+A+25,-round(yw[wk[le]]*zoom)+B);
    if yw[wk[le]]>yw[wp[le]] then y1:=yw[wp[le]] else y1:=yw[wk[le]];
    mybitmap.canvas.textout(A+10+round((Xw[Wp[Le]]+Xw[Wk[Le]])/2*zoom),B+20-round(y1*zoom-rozmiar[2]*screen.pixelsperinch/96),floattostr(round(abs(xw[wp[Le]]-xw[wk[Le]])*100)/100));
    mybitmap.canvas.line(round(xw[wp[le]]*zoom)+A,-round(y1*zoom)+B+20,round(xw[wk[le]]*zoom)+A,-round(y1*zoom)+B+20);
    mybitmap.canvas.line(round(xw[wp[le]]*zoom)+A,-round(y1*zoom)+B+15,round(xw[wp[le]]*zoom)+A,-round(y1*zoom)+B+25);
    mybitmap.canvas.line(round(xw[wk[le]]*zoom)+A,-round(y1*zoom)+B+15,round(xw[wk[le]]*zoom)+A,-round(y1*zoom)+B+25);
  end;
  mybitmap.canvas.Font.size:=rozmiar[1];
  mybitmap.canvas.pen.Color:=kolor[4];
  if wyswietl=0 then
  begin
    if form6open=true then               //rysowanie podpor
  begin
    Lwar:=PreLwar;
    for i:=1 to Lw do
      if Zaznaczonywezel[i]=true then begin
      if (f6H=true) or (f6V=true) or (f6M=true) then begin Lwar:=Lwar+1; fipod[Lwar]:=f6alfa; s[Lwar]:=i; end;
      if (f6V=false) and (f6H=false) and (f6M=true) then Rpod[lwar]:=1;
      if (f6V=true)  and (f6H=true)  and (f6M=true) then Rpod[lwar]:=2;
      if (f6V=true)  and (f6H=true)  and (f6M=false)then Rpod[lwar]:=3;
      if (f6V=true)  and (f6H=false) and (f6M=true) then Rpod[lwar]:=4;
      if (f6V=true)  and (f6H=false) and (f6M=false)then Rpod[lwar]:=5;
      if (f6V=true) then begin DV[Lwar]:=f6DV/100; KV[Lwar]:=f6KV end else begin DV[Lwar]:=0; KV[Lwar]:=0 end;
      if (f6H=true) then begin DH[Lwar]:=f6DH/100; KH[Lwar]:=f6KH end else begin DH[Lwar]:=0; KH[Lwar]:=0 end;
      if (f6M=true) then begin DM[Lwar]:=f6DM; KM[Lwar]:=f6KM end else begin DM[Lwar]:=0; KM[Lwar]:=0 end;
      for x:=0 to warianty do wariantPod[Lwar,x]:=true;
      end;
    for i:=Lwar+1 to Lw+2 do s[i]:=0;
  end;
  for i:=1 to Lwar do begin
    mybitmap.canvas.brush.color:=kolor[7]; //sprawdź czy ma pokolorować na zielono czy niebiesko podpore
    if ((DV[i]<>0) or (KV[i]<>0) or (DH[i]<>0) or (KH[i]<>0) or (DM[i]<>0) or (KM[i]<>0)) and (wariantPod[i,tenwariant]=true) then mybitmap.canvas.brush.color:=kolor[8];
    case RPod[i] of
      1: mybitmap.canvas.polygon([point(round(A+zoom*Xw[s[i]]),round(B-zoom*Yw[s[i]])),point(round(A+10+zoom*Xw[s[i]]),round(B+5-zoom*Yw[s[i]])),point(round(A+5+zoom*Xw[s[i]]),round(B+10-zoom*Yw[s[i]]))]);
      2: mybitmap.canvas.polygon([pointpodpora(-10,-3),pointpodpora(10,-3),pointpodpora(10,-9),pointpodpora(-10,-9)]);
      3: mybitmap.canvas.polygon([pointpodpora(0,-3),pointpodpora(8,-12),pointpodpora(-8,-12)]);
      4: begin mybitmap.canvas.line(pointpodpora(-10,-3),pointpodpora(10,-3)); mybitmap.canvas.polygon([pointpodpora(-10,-6),pointpodpora(10,-6),pointpodpora(10,-12),pointpodpora(-10,-12)]); end;
      5: begin mybitmap.canvas.polygon([pointpodpora(0,-3),pointpodpora(8,-12),pointpodpora(-8,-12)]); mybitmap.canvas.line(pointpodpora(-10,-15),pointpodpora(10,-15)); end;
    end;
    oo:=0;
    mybitmap.canvas.brush.color:=kolor[10];
    if (tekst[10]=true) then begin
      if (KM[i]<>0) then begin mybitmap.canvas.TextOut(round(A+zoom*Xw[s[i]])+15,round(B-zoom*Yw[s[i]]-15-1.8*oo*rozmiar[2]*screen.pixelsperinch/96),'kφ= '+floattostrf(kM[i],fffixed,7,3)+'kNm/rad'); inc(oo); end;
      if (KV[i]<>0) then begin mybitmap.canvas.TextOut(round(A+zoom*Xw[s[i]])+15,round(B-zoom*Yw[s[i]]-15-1.8*oo*rozmiar[2]*screen.pixelsperinch/96),'ky= '+floattostrf(kV[i],fffixed,7,3)+'kN/m'); inc(oo); end;
      if (KH[i]<>0) then begin mybitmap.canvas.TextOut(round(A+zoom*Xw[s[i]])+15,round(B-zoom*Yw[s[i]]-15-1.8*oo*rozmiar[2]*screen.pixelsperinch/96),'kx= '+floattostrf(kH[i],fffixed,7,3)+'kN/m'); inc(oo); end;
      if (DM[i]<>0) then begin mybitmap.canvas.TextOut(round(A+zoom*Xw[s[i]])+15,round(B-zoom*Yw[s[i]]-15-1.8*oo*rozmiar[2]*screen.pixelsperinch/96),'φ= ' +floattostrf(DM[i]*180/pi(),fffixed,7,3)+'°'); inc(oo); end;
      if (DV[i]<>0) then begin mybitmap.canvas.TextOut(round(A+zoom*Xw[s[i]])+15,round(B-zoom*Yw[s[i]]-15-1.8*oo*rozmiar[2]*screen.pixelsperinch/96),'Δy= '+floattostrf(DV[i],fffixed,7,3)+'m'); inc(oo); end;
      if (DH[i]<>0) then begin mybitmap.canvas.TextOut(round(A+zoom*Xw[s[i]])+15,round(B-zoom*Yw[s[i]]-15-1.8*oo*rozmiar[2]*screen.pixelsperinch/96),'Δx= '+floattostrf(DH[i],fffixed,7,3)+'m'); inc(oo); end;
    end;
    if (tekst[12]=true) then begin mybitmap.canvas.TextOut(round(A+zoom*Xw[s[i]])+15,round(B-zoom*Yw[s[i]]-15-1.8*oo*rozmiar[2]*screen.pixelsperinch/96),'α= '+floattostrf(fipod[i],fffixed,7,3)+'°'); inc(oo); end;
    if dv[i]<0 then begin mybitmap.canvas.Line(pointpodpora(0,-18),pointpodpora(0,-38)); mybitmap.canvas.Line(pointpodpora(0,-38),pointpodpora(-5,-32)); mybitmap.canvas.Line(pointpodpora(0,-38),pointpodpora(5,-32)); mybitmap.canvas.Line(pointpodpora(-5,-18),pointpodpora(5,-18)); end;
    if dv[i]>0 then begin mybitmap.canvas.Line(pointpodpora(0,18),pointpodpora(0,38)); mybitmap.canvas.Line(pointpodpora(0,38),pointpodpora(-5,32)); mybitmap.canvas.Line(pointpodpora(0,38),pointpodpora(5,32)); mybitmap.canvas.Line(pointpodpora(-5,18),pointpodpora(5,18)); end;
    if dh[i]<0 then begin mybitmap.canvas.Line(pointpodpora(-18,0),pointpodpora(-38,0)); mybitmap.canvas.Line(pointpodpora(-38,0),pointpodpora(-32,-5)); mybitmap.canvas.Line(pointpodpora(-38,0),pointpodpora(-32,5)); mybitmap.canvas.Line(pointpodpora(-18,-5),pointpodpora(-18,5)); end;
    if dh[i]>0 then begin mybitmap.canvas.Line(pointpodpora(18,0),pointpodpora(38,0)); mybitmap.canvas.Line(pointpodpora(38,0),pointpodpora(32,-5)); mybitmap.canvas.Line(pointpodpora(38,0),pointpodpora(32,5)); mybitmap.canvas.Line(pointpodpora(18,-5),pointpodpora(18,5)); end;
    if (kv[i]<>0) and (dv[i]<0) then begin mybitmap.canvas.line(pointpodpora(-5,-45),pointpodpora(5,-45));mybitmap.canvas.lineto(pointpodpora(-5,-50)); mybitmap.canvas.lineto(pointpodpora(5,-55)); mybitmap.canvas.lineto(pointpodpora(-5,-60)); mybitmap.canvas.lineto(pointpodpora(5,-60)); end;
    if (kv[i]<>0) and (dv[i]>=0) then begin mybitmap.canvas.line(pointpodpora(-5,-20),pointpodpora(5,-20));mybitmap.canvas.lineto(pointpodpora(-5,-25)); mybitmap.canvas.lineto(pointpodpora(5,-30)); mybitmap.canvas.lineto(pointpodpora(-5,-35)); mybitmap.canvas.lineto(pointpodpora(5,-35)); end;
    if (kh[i]<>0) and (dh[i]<0) then begin mybitmap.canvas.line(pointpodpora(-45,-5),pointpodpora(-45,5));mybitmap.canvas.lineto(pointpodpora(-50,-5)); mybitmap.canvas.lineto(pointpodpora(-55,5)); mybitmap.canvas.lineto(pointpodpora(-60,-5)); mybitmap.canvas.lineto(pointpodpora(-60,5)); end;
    if (kh[i]<>0) and (dh[i]>=0) then begin mybitmap.canvas.line(pointpodpora(-20,-5),pointpodpora(-20,5));mybitmap.canvas.lineto(pointpodpora(-25,-5)); mybitmap.canvas.lineto(pointpodpora(-30,5)); mybitmap.canvas.lineto(pointpodpora(-35,-5)); mybitmap.canvas.lineto(pointpodpora(-35,5)); end;
    if dm[i]<>0 then begin mybitmap.canvas.Line(pointpodpora(15,-12),pointpodpora(38,-28)); mybitmap.canvas.Line(pointpodpora(12,-15),pointpodpora(28,-38)); mybitmap.canvas.Line(pointpodpora(32,-23),pointpodpora(23,-32)); end;
      if dm[i]<0 then begin mybitmap.canvas.Line(pointpodpora(30,-30),pointpodpora(32,-23)); mybitmap.canvas.Line(pointpodpora(25,-25),pointpodpora(32,-23)); end;
      if dm[i]>0 then begin mybitmap.canvas.Line(pointpodpora(30,-30),pointpodpora(23,-32)); mybitmap.canvas.Line(pointpodpora(25,-25),pointpodpora(23,-32)); end;
    if km[i]<>0 then begin mybitmap.canvas.Line(pointpodpora(-35,-10),pointpodpora(-25,-10));
                           mybitmap.canvas.lineto(pointpodpora(-34,-14)); mybitmap.canvas.lineto(pointpodpora(-24,-15)); mybitmap.canvas.lineto(pointpodpora(-30,-23));
                           mybitmap.canvas.lineto(pointpodpora(-20,-20)); mybitmap.canvas.lineto(pointpodpora(-23,-30)); mybitmap.canvas.lineto(pointpodpora(-15,-24));
                           mybitmap.canvas.lineto(pointpodpora(-14,-34)); mybitmap.canvas.lineto(pointpodpora(-10,-25)); mybitmap.canvas.lineto(pointpodpora(-10,-35)); end;


  end;
  if form2open=true then               //rysowanie sil
  begin
    RowsPp:=PreRowsPp;
    for i:=1 to Le do
      if Zaznaczonypret[i]=true then begin
        RowsPp:=RowsPp+1;
        P[RowsPp]:=form2P;
        xp[RowsPp]:=form2x;
        alfap[RowsPp]:=form2alfa;
        np[RowsPp]:=i;
        for x:=0 to warianty do wariantP[RowsPp,x]:=true;
      end;
  end;
  for i:=1 to RowsPp do
   begin
     oo:=0;
     if wariantP[i,tenwariant]=true then mybitmap.canvas.pen.color:=kolor[6] else mybitmap.canvas.pen.color:=kolor[16];
     if zaznaczoneP[i]=true then mybitmap.canvas.pen.width:=3 else mybitmap.canvas.pen.width:=1;
     if p[i]>=0 then begin
       mybitmap.canvas.line(pointsila(0,0),pointsila(5,8)); mybitmap.canvas.lineto(pointsila(2,8));
       mybitmap.canvas.lineto(pointsila(2,abs(P[i])/maxP*skalaP+8)); mybitmap.canvas.lineto(pointsila(-2,abs(P[i])/maxP*skalaP+8));
       mybitmap.canvas.lineto(pointsila(-2,8));mybitmap.canvas.lineto(pointsila(-5,8));mybitmap.canvas.lineto(pointsila(0,0)); end else
     begin
       mybitmap.canvas.line(pointsila(2,0),pointsila(2,abs(P[i])/maxP*skalaP)); mybitmap.canvas.lineto(pointsila(5,abs(P[i])/maxP*skalaP));
       mybitmap.canvas.lineto(pointsila(0,abs(P[i])/maxP*skalaP+8)); mybitmap.canvas.lineto(pointsila(-5,abs(P[i])/maxP*skalaP));
       mybitmap.canvas.lineto(pointsila(-2,abs(P[i])/maxP*skalaP)); mybitmap.canvas.lineto(pointsila(-2,0));mybitmap.canvas.lineto(pointsila(2,0));
     end;
          //tekst
     xrect:=round((Xw[Wk[np[i]]]*zoom-Xw[Wp[np[i]]]*zoom)*xp[i]+A+Xw[Wp[np[i]]]*zoom+abs(P[i])/maxP*skalaP*sin(alfap[i]*pi()/180))+15;
     yrect:=round((-Yw[Wk[np[i]]]*zoom+Yw[Wp[np[i]]]*zoom)*xp[i]+B-Yw[Wp[np[i]]]*zoom-abs(P[i])/maxP*skalaP*cos(alfap[i]*pi()/180));
     maxx:=0; if (tekst[4]=true) and (maxx<mybitmap.Canvas.TextWidth(floattostrf(abs(P[i]),fffixed,7,3)+'kN')) then maxx:=mybitmap.Canvas.TextWidth(floattostrf(abs(P[i]),fffixed,7,3)+'kN');
              if (tekst[6]=true) and (maxx<mybitmap.Canvas.TextWidth('x= '+floattostrf(xP[i],fffixed,7,3))) then maxx:=mybitmap.Canvas.TextWidth('x= '+floattostrf(xP[i],fffixed,7,3));
              if (tekst[13]=true) and (maxx<mybitmap.Canvas.TextWidth('α= '+floattostrf(alfaP[i],fffixed,7,3)+'°')) then maxx:=mybitmap.Canvas.TextWidth('α= '+floattostrf(alfaP[i],fffixed,7,3)+'°');
     if ((alfaP[i]>=0) and (alfaP[i]<180) and (abs(P[i])<0)) or ((alfaP[i]<=360) and (alfaP[i]>=180) and (abs(P[i])>=0)) then xrect:=xrect-30-maxx;
     maxy:=0; if tekst[4]=true then maxy:=maxy+1; if tekst[6]=true then maxy:=maxy+1; if tekst[13]=true then maxy:=maxy+1;
     maxy:=round(maxy*1.6*rozmiar[1]*screen.pixelsperinch/96);
     if (((alfaP[i]>=0) and (alfaP[i]<90)) or ((alfaP[i]>=270) and (alfaP[i]<=360)) and (abs(P[i])>=0)) or ((alfaP[i]<=270) and (alfaP[i]>=90) and (abs(P[i])<0)) then yrect:=yrect-maxy;
     if rozmiar[4]=0 then mybitmap.canvas.Pen.Style:=psclear else mybitmap.canvas.Pen.Style:=pssolid; //jeżeli mamy zaznaczoną opcję w ustawieniach: obramowanie tekstu
     mybitmap.Canvas.Brush.Style:=bssolid;
     if maxy>0 then mybitmap.canvas.Rectangle(xrect-5,yrect-4,xrect+maxx+5,yrect+maxy+6);
     mybitmap.canvas.Pen.Style:=pssolid;
     mybitmap.Canvas.Brush.Style:=bsclear;
     if (tekst[4]=true) then begin mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),floattostrf(P[i],fffixed,7,3)+'kN'); inc(oo); end;
     if (tekst[5]=true) then begin mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'x= '+floattostrf(xp[i],fffixed,7,3)); inc(oo); end;
     if (tekst[13]=true) then      mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'α= '+floattostrf(alfap[i],fffixed,7,3)+'°');
   end;
  if form5open=true then               //rysowanie temperatur
  begin
    RowsPt:=PreRowsPt;
    for i:=1 to Le do
      if Zaznaczonypret[i]=true then begin
        RowsPt:=RowsPt+1;
        Tg[RowsPt]:=form5g;
        Td[RowsPt]:=form5d;
        nt[RowsPt]:=i;
        for x:=0 to warianty do wariantT[RowsPt,x]:=true;
      end;
  end;

  for i:=1 to RowsPt do
   begin
   if zaznaczoneT[i]=true then mybitmap.canvas.pen.width:=5 else mybitmap.canvas.pen.width:=2;
   if wariantT[i,tenwariant]=true then mybitmap.canvas.pen.color:=kolor[6] else mybitmap.canvas.pen.color:=kolor[16];
   mybitmap.canvas.line(round(Lx[nt[i]]*zoom/4+A+Xw[Wp[nt[i]]]*zoom)-round(6*screen.pixelsperinch/96)+6,round(-Ly[nt[i]]*zoom/4+B-Yw[Wp[nt[i]]]*zoom)-round(6*screen.pixelsperinch/96),round(Lx[nt[i]]*zoom/4+A+Xw[Wp[nt[i]]]*zoom)+round(6*screen.pixelsperinch/96)+6,round(-Ly[nt[i]]*zoom/4+B-Yw[Wp[nt[i]]]*zoom)-round(6*screen.pixelsperinch/96));
   mybitmap.canvas.line(round(Lx[nt[i]]*zoom/4+A+Xw[Wp[nt[i]]]*zoom)+6,round(-Ly[nt[i]]*zoom/4+B-Yw[Wp[nt[i]]]*zoom)-round(6*screen.pixelsperinch/96),round(Lx[nt[i]]*zoom/4+A+Xw[Wp[nt[i]]]*zoom)+6,round(-Ly[nt[i]]*zoom/4+B-Yw[Wp[nt[i]]]*zoom)+round(6*screen.pixelsperinch/96));
   //tekst
   maxx:=mybitmap.Canvas.TextWidth('Tg= '+floattostr(Tg[i])+'K');
   maxy:=0; if tekst[4]=true then maxy:=round(1.6*rozmiar[1]*screen.pixelsperinch/96);
   xrect:=round(Lx[nt[i]]*zoom/4+A+Xw[Wp[nt[i]]]*zoom-sin(alfapr[nt[i]])*(2+maxx)-maxx/2)+5;
   yrect:=round(-Ly[nt[i]]*zoom/4+B-Yw[Wp[nt[i]]]*zoom-cos(alfapr[nt[i]])*maxy*2-maxy/2);
   if rozmiar[4]=0 then mybitmap.canvas.Pen.Style:=psclear else mybitmap.canvas.Pen.Style:=pssolid; //jeżeli mamy zaznaczoną opcję w ustawieniach: obramowanie tekstu
   mybitmap.Canvas.Brush.Style:=bssolid;
   if zaznaczoneT[i]=true then mybitmap.canvas.pen.width:=3 else mybitmap.canvas.pen.width:=1;
   if maxy>0 then mybitmap.canvas.Rectangle(xrect-5,yrect-4,xrect+maxx+5,yrect+maxy+6);
   mybitmap.canvas.Pen.Style:=pssolid;
   mybitmap.Canvas.Brush.Style:=bsclear;
   if tekst[4]=true then mybitmap.canvas.textout(xrect,yrect,'Tg= '+floattostr(Tg[i])+'K');
   maxx:=mybitmap.Canvas.TextWidth('Td= '+floattostr(Td[i])+'K');
   maxy:=0; if tekst[4]=true then maxy:=round(1.6*rozmiar[1]*screen.pixelsperinch/96);
   xrect:=round(Lx[nt[i]]*zoom/4+A+Xw[Wp[nt[i]]]*zoom+sin(alfapr[nt[i]])*(2+maxx)-maxx/2)+5;
   yrect:=round(-Ly[nt[i]]*zoom/4+B-Yw[Wp[nt[i]]]*zoom+cos(alfapr[nt[i]])*maxy*2-maxy/2);
   if rozmiar[4]=0 then mybitmap.canvas.Pen.Style:=psclear else mybitmap.canvas.Pen.Style:=pssolid; //jeżeli mamy zaznaczoną opcję w ustawieniach: obramowanie tekstu
   mybitmap.Canvas.Brush.Style:=bssolid;
   if zaznaczoneT[i]=true then mybitmap.canvas.pen.width:=3 else mybitmap.canvas.pen.width:=1;
   if maxy>0 then mybitmap.canvas.Rectangle(xrect-5,yrect-4,xrect+maxx+5,yrect+maxy+6);
   mybitmap.canvas.Pen.Style:=pssolid;
   mybitmap.Canvas.Brush.Style:=bsclear;
   if tekst[4]=true then mybitmap.canvas.textout(xrect,yrect,'Td= '+floattostr(Td[i])+'K');

  end;
  mybitmap.canvas.font.Style:=[];
  mybitmap.canvas.pen.Width:=1;
  mybitmap.canvas.pen.color:=kolor[6];
  if form4open=true then               //rysowanie momentow skupionych
  begin
    RowsPm:=PreRowsPm;
    for i:=1 to Le do
      if Zaznaczonypret[i]=true then begin
        RowsPm:=RowsPm+1;
        Pm[RowsPm]:=form4M;
        xm[RowsPm]:=form4x;
        nm[RowsPm]:=i;
        for x:=0 to warianty do wariantM[RowsPm,x]:=true;
      end;
  end;
  for i:=1 to RowsPm do
   begin
     oo:=0;
     if wariantM[i,tenwariant]=true then mybitmap.canvas.pen.color:=kolor[6] else mybitmap.canvas.pen.color:=kolor[16];
     if zaznaczoneM[i]=true then mybitmap.canvas.pen.width:=3 else mybitmap.canvas.pen.width:=1;
     mybitmap.canvas.line(round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom+(sgn(Pm[i])*20*Lx[nm[i]]-22*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom-(sgn(Pm[i])*20*Ly[nm[i]]+22*Lx[nm[i]])/L[nm[i]]),round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom+(sgn(Pm[i])*25*Lx[nm[i]]-25*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom-(sgn(Pm[i])*25*Ly[nm[i]]+25*Lx[nm[i]])/L[nm[i]]));
     mybitmap.canvas.line(round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom+(sgn(Pm[i])*20*Lx[nm[i]]-28*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom-(sgn(Pm[i])*20*Ly[nm[i]]+28*Lx[nm[i]])/L[nm[i]]),round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom+(sgn(Pm[i])*25*Lx[nm[i]]-25*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom-(sgn(Pm[i])*25*Ly[nm[i]]+25*Lx[nm[i]])/L[nm[i]]));
     mybitmap.canvas.lineto(round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom+(-25*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom-(25*Lx[nm[i]])/L[nm[i]]));
     mybitmap.canvas.lineto(round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom+(25*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom-(-25*Lx[nm[i]])/L[nm[i]]));
     mybitmap.canvas.lineto(round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom-(sgn(Pm[i])*25*Lx[nm[i]]-25*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom+(sgn(Pm[i])*25*Ly[nm[i]]+25*Lx[nm[i]])/L[nm[i]]));
     mybitmap.canvas.lineto(round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom-(sgn(Pm[i])*20*Lx[nm[i]]-28*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom+(sgn(Pm[i])*20*Ly[nm[i]]+28*Lx[nm[i]])/L[nm[i]]));
     mybitmap.canvas.line(round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom-(sgn(Pm[i])*20*Lx[nm[i]]-22*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom+(sgn(Pm[i])*20*Ly[nm[i]]+22*Lx[nm[i]])/L[nm[i]]),round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom-(sgn(Pm[i])*25*Lx[nm[i]]-25*Ly[nm[i]])/L[nm[i]]),round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom+(sgn(Pm[i])*25*Ly[nm[i]]+25*Lx[nm[i]])/L[nm[i]]));
     //tekst
     xrect:=round(A+(Lx[nm[i]]*xm[i]+xw[wp[nm[i]]])*zoom+(sgn(Pm[i])*25*Lx[nm[i]]-25*Ly[nm[i]])/L[nm[i]])+10;
     yrect:=round(B-(Ly[nm[i]]*xm[i]+yw[wp[nm[i]]])*zoom-(sgn(Pm[i])*25*Ly[nm[i]]+25*Lx[nm[i]])/L[nm[i]]);
     maxx:=0; if (tekst[4]=true) and (maxx<mybitmap.Canvas.TextWidth(floattostrf(Pm[i],fffixed,7,3)+'kNm')) then maxx:=mybitmap.Canvas.TextWidth(floattostrf(Pm[i],fffixed,7,3)+'kNm');
              if (tekst[5]=true) and (maxx<mybitmap.Canvas.TextWidth('x= '+floattostrf(xm[i],fffixed,7,3))) then maxx:=mybitmap.Canvas.TextWidth('x= '+floattostrf(xm[i],fffixed,7,3));
     if ((Pm[i]>=0) and ((Lx[nm[i]]<0) or ((Lx[nm[i]]=0) and (Ly[nm[i]]>0)))) or ((Pm[i]<0) and ((Lx[nm[i]]>0) or ((Lx[nm[i]]=0) and (Ly[nm[i]]>0)))) then xrect:=xrect-20-maxx;
     maxy:=0; if tekst[4]=true then maxy:=maxy+1; if tekst[5]=true then maxy:=maxy+1;
     maxy:=round(maxy*1.6*rozmiar[1]*screen.pixelsperinch/96);
     if ((Lx[nm[i]]>=0)) then yrect:=yrect-maxy;
     if rozmiar[4]=0 then mybitmap.canvas.Pen.Style:=psclear else mybitmap.canvas.Pen.Style:=pssolid; //jeżeli mamy zaznaczoną opcję w ustawieniach: obramowanie tekstu
     mybitmap.Canvas.Brush.Style:=bssolid;
     if maxy>0 then mybitmap.canvas.Rectangle(xrect-5,yrect-4,xrect+maxx+5,yrect+maxy+6);
     mybitmap.canvas.Pen.Style:=pssolid;
     mybitmap.Canvas.Brush.Style:=bsclear;
     if tekst[4]=true then begin mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),floattostrf(Pm[i],fffixed,7,3)+'kNm'); inc(oo); end;
     if tekst[5]=true then       mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'x= '+floattostrf(xm[i],fffixed,7,3));
     mybitmap.canvas.brush.style:=bssolid;
   end;
  if form3open=true then               //rysowanie obc ciaglego
  begin
    RowsPq:=PreRowsPq;
    for i:=1 to Le do
      if Zaznaczonypret[i]=true then begin
        RowsPq:=RowsPq+1;
        Pqi[RowsPq]:=form3qp;
        Pqj[RowsPq]:=form3qk;
        xqi[RowsPq]:=form3xp;
        xqj[RowsPq]:=form3xk;
        alfaq[RowsPq]:=form3alfa;
        nq[RowsPq]:=i;
        for x:=0 to warianty do wariantQ[RowsPq,x]:=true;
      end;
  end;
  for i:=1 to RowsPq do
   begin
     oo:=0;
     if wariantQ[i,tenwariant]=true then mybitmap.canvas.pen.color:=kolor[6] else mybitmap.canvas.pen.color:=kolor[16];
     if zaznaczoneQ[i]=true then mybitmap.canvas.pen.width:=3 else mybitmap.canvas.pen.width:=1;
     mybitmap.canvas.Line(round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqi[i]+A+Xw[Wp[nq[i]]]*zoom),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqi[i]+B-Yw[Wp[nq[i]]]*zoom),round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqi[i]+A+Xw[Wp[nq[i]]]*zoom+Pqi[i]/maxQ*skalaQ*sin(alfaq[i]*pi()/180)),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqi[i]+B-Yw[Wp[nq[i]]]*zoom-Pqi[i]/MaxQ*skalaQ*cos(alfaq[i]*pi()/180)));
     mybitmap.canvas.Line(round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqi[i]+A+Xw[Wp[nq[i]]]*zoom),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqi[i]+B-Yw[Wp[nq[i]]]*zoom),round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqi[i]+A+Xw[Wp[nq[i]]]*zoom+sgn(pqi[i])*10*sin((alfaq[i]+30)*pi()/180)),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqi[i]+B-Yw[Wp[nq[i]]]*zoom-sgn(pqi[i])*10*cos((alfaq[i]+30)*pi()/180)));
     mybitmap.canvas.Line(round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqi[i]+A+Xw[Wp[nq[i]]]*zoom),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqi[i]+B-Yw[Wp[nq[i]]]*zoom),round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqi[i]+A+Xw[Wp[nq[i]]]*zoom+sgn(pqi[i])*10*sin((alfaq[i]-30)*pi()/180)),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqi[i]+B-Yw[Wp[nq[i]]]*zoom-sgn(pqi[i])*10*cos((alfaq[i]-30)*pi()/180)));
     mybitmap.canvas.Line(round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqj[i]+A+Xw[Wp[nq[i]]]*zoom),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqj[i]+B-Yw[Wp[nq[i]]]*zoom),round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqj[i]+A+Xw[Wp[nq[i]]]*zoom+Pqj[i]/maxQ*skalaQ*sin(alfaq[i]*pi()/180)),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqj[i]+B-Yw[Wp[nq[i]]]*zoom-Pqj[i]/MaxQ*skalaQ*cos(alfaq[i]*pi()/180)));
     mybitmap.canvas.Line(round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqj[i]+A+Xw[Wp[nq[i]]]*zoom),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqj[i]+B-Yw[Wp[nq[i]]]*zoom),round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqj[i]+A+Xw[Wp[nq[i]]]*zoom+sgn(pqj[i])*10*sin((alfaq[i]+30)*pi()/180)),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqj[i]+B-Yw[Wp[nq[i]]]*zoom-sgn(pqj[i])*10*cos((alfaq[i]+30)*pi()/180)));
     mybitmap.canvas.Line(round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqj[i]+A+Xw[Wp[nq[i]]]*zoom),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqj[i]+B-Yw[Wp[nq[i]]]*zoom),round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqj[i]+A+Xw[Wp[nq[i]]]*zoom+sgn(pqj[i])*10*sin((alfaq[i]-30)*pi()/180)),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqj[i]+B-Yw[Wp[nq[i]]]*zoom-sgn(pqj[i])*10*cos((alfaq[i]-30)*pi()/180)));
     mybitmap.canvas.Line(round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqi[i]+A+Xw[Wp[nq[i]]]*zoom+Pqi[i]/maxQ*skalaQ*sin(alfaq[i]*pi()/180)),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqi[i]+B-Yw[Wp[nq[i]]]*zoom-Pqi[i]/MaxQ*skalaQ*cos(alfaq[i]*pi()/180)),round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqj[i]+A+Xw[Wp[nq[i]]]*zoom+Pqj[i]/maxQ*skalaQ*sin(alfaq[i]*pi()/180)),round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqj[i]+B-Yw[Wp[nq[i]]]*zoom-Pqj[i]/MaxQ*skalaQ*cos(alfaq[i]*pi()/180)));
               //tekst
     xrect:=round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqi[i]+A+Xw[Wp[nq[i]]]*zoom+Pqi[i]/maxQ*skalaQ*sin(alfaq[i]*pi()/180))+10;
     yrect:=round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqi[i]+B-Yw[Wp[nq[i]]]*zoom-Pqi[i]/maxQ*skalaQ*cos(alfaq[i]*pi()/180))+7;
     maxx:=0; if (tekst[4]=true) and (maxx<mybitmap.Canvas.TextWidth(floattostrf(Pqi[i],fffixed,7,3)+'kN/m')) then maxx:=mybitmap.Canvas.TextWidth(floattostrf(Pqi[i],fffixed,7,3)+'kN/m');
              if (tekst[5]=true) and (maxx<mybitmap.Canvas.TextWidth('x= '+floattostrf(xqi[i],fffixed,7,3))) then maxx:=mybitmap.Canvas.TextWidth('x= '+floattostrf(xqi[i],fffixed,7,3));
              if (tekst[13]=true) and (maxx<mybitmap.Canvas.TextWidth('α= '+floattostrf(alfaq[i],fffixed,7,3)+'°')) then maxx:=mybitmap.Canvas.TextWidth('α= '+floattostrf(alfaq[i],fffixed,7,3)+'°');
     if ((alfaq[i]>=0) and (alfaq[i]<180) and (Pqi[i]<0)) or ((alfaq[i]<=360) and (alfaq[i]>=180) and (Pqi[i]>=0)) then xrect:=xrect-20-maxx;
     maxy:=0; if tekst[4]=true then maxy:=maxy+1; if tekst[6]=true then maxy:=maxy+1; if tekst[13]=true then maxy:=maxy+1;
     maxy:=round(maxy*1.6*rozmiar[1]*screen.pixelsperinch/96);
     if (((alfaq[i]>=0) and (alfaq[i]<90)) or ((alfaq[i]>=270) and (alfaq[i]<=360)) and (Pqi[i]>=0)) or ((alfaq[i]<=270) and (alfaq[i]>=90) and (Pqi[i]<0)) then yrect:=yrect-maxy-14;
     if rozmiar[4]=0 then mybitmap.canvas.Pen.Style:=psclear else mybitmap.canvas.Pen.Style:=pssolid; //jeżeli mamy zaznaczoną opcję w ustawieniach: obramowanie tekstu
     mybitmap.Canvas.Brush.Style:=bssolid;
     if maxy>0 then mybitmap.canvas.Rectangle(xrect-5,yrect-4,xrect+maxx+5,yrect+maxy+6);
     mybitmap.canvas.Pen.Style:=pssolid;
     mybitmap.Canvas.Brush.Style:=bsclear;
     if tekst[4]=true then begin mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),floattostrf(Pqi[i],fffixed,7,3)+'kN/m'); inc(oo); end;
     if tekst[5]=true then begin mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'x= '+floattostrf(xqi[i],fffixed,7,3)); inc(oo); end;
     if tekst[13]=true then      mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'α= '+floattostrf(alfaq[i],fffixed,7,3)+'°');
     oo:=0;
     xrect:=round((Xw[Wk[nq[i]]]*zoom-Xw[Wp[nq[i]]]*zoom)*xqj[i]+A+Xw[Wp[nq[i]]]*zoom+Pqj[i]/maxQ*skalaQ*sin(alfaq[i]*pi()/180))+10;
     yrect:=round((-Yw[Wk[nq[i]]]*zoom+Yw[Wp[nq[i]]]*zoom)*xqj[i]+B-Yw[Wp[nq[i]]]*zoom-Pqj[i]/maxQ*skalaQ*cos(alfaq[i]*pi()/180))+7;
     maxx:=0; if (tekst[4]=true) and (maxx<mybitmap.Canvas.TextWidth(floattostrf(Pqj[i],fffixed,7,3)+'kN/m')) then maxx:=mybitmap.Canvas.TextWidth(floattostrf(Pqj[i],fffixed,7,3)+'kN/m');
              if (tekst[5]=true) and (maxx<mybitmap.Canvas.TextWidth('x= '+floattostrf(xqj[i],fffixed,7,3))) then maxx:=mybitmap.Canvas.TextWidth('x= '+floattostrf(xqj[i],fffixed,7,3));
              if (tekst[13]=true) and (maxx<mybitmap.Canvas.TextWidth('α= '+floattostrf(alfaq[i],fffixed,7,3)+'°')) then maxx:=mybitmap.Canvas.TextWidth('α= '+floattostrf(alfaq[i],fffixed,7,3)+'°');
     if ((alfaq[i]>=0) and (alfaq[i]<180) and (Pqj[i]<0)) or ((alfaq[i]<=360) and (alfaq[i]>=180) and (Pqj[i]>=0)) then xrect:=xrect-20-maxx;
     maxy:=0; if tekst[4]=true then maxy:=maxy+1; if tekst[6]=true then maxy:=maxy+1; if tekst[13]=true then maxy:=maxy+1;
     maxy:=round(maxy*1.6*rozmiar[1]*screen.pixelsperinch/96);
     if (((alfaq[i]>=0) and (alfaq[i]<90)) or ((alfaq[i]>=270) and (alfaq[i]<=360)) and (Pqj[i]>=0)) or ((alfaq[i]<=270) and (alfaq[i]>=90) and (Pqj[i]<0)) then yrect:=yrect-maxy-14;
     if rozmiar[4]=0 then mybitmap.canvas.Pen.Style:=psclear else mybitmap.canvas.Pen.Style:=pssolid; //jeżeli mamy zaznaczoną opcję w ustawieniach: obramowanie tekstu
     mybitmap.Canvas.Brush.Style:=bssolid;
     if maxy>0 then mybitmap.canvas.Rectangle(xrect-5,yrect-4,xrect+maxx+5,yrect+maxy+6);
     mybitmap.canvas.Pen.Style:=pssolid;
     mybitmap.Canvas.Brush.Style:=bsclear;
     if tekst[4]=true then begin mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),floattostrf(Pqj[i],fffixed,7,3)+'kN/m'); inc(oo); end;
     if tekst[5]=true then begin mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'x= '+floattostrf(xqj[i],fffixed,7,3)); inc(oo); end;
     if tekst[13]=true then      mybitmap.canvas.textout(xrect,round(yrect+1.6*oo*rozmiar[1]*screen.pixelsperinch/96),'α= '+floattostrf(alfaq[i],fffixed,7,3)+'°');
   end;
  end;
  if polar=true then          //polar
    begin
     mybitmap.canvas.pen.style:=pssolid;
     mybitmap.canvas.brush.color:=kolor[14];
     mybitmap.canvas.framerect(A+round(Xw[polarpoint]*zoom)-7,B-round(Yw[polarpoint]*zoom)-7,A+round(Xw[polarpoint]*zoom)+7,B-round(Yw[polarpoint]*zoom)+7);
     mybitmap.canvas.pen.Style:=psdot;
     mybitmap.canvas.brush.color:=kolor[1];
     if ((10>polarangle) or (polarangle>350))     then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom),0);
     if ((35>=polarangle) and (polarangle>=10))   then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)+1155,B-round(Yw[polarpoint]*zoom)-2000);
     if ((55>polarangle) and (polarangle>35))     then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)+2000,B-round(Yw[polarpoint]*zoom)-2000);
     if ((80>=polarangle) and (polarangle>=55))   then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)+2000,B-round(Yw[polarpoint]*zoom)-1155);
     if ((100>polarangle) and (polarangle>80))    then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),mybitmap.Width,B-round(Yw[polarpoint]*zoom));
     if ((125>=polarangle) and (polarangle>=100)) then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)+2000,B-round(Yw[polarpoint]*zoom)+1155);
     if ((145>polarangle) and (polarangle>125))   then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)+2000,B-round(Yw[polarpoint]*zoom)+2000);
     if ((170>=polarangle) and (polarangle>=145)) then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)+1155,B-round(Yw[polarpoint]*zoom)+2000);
     if ((190>polarangle) and (polarangle>170))   then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom),mybitmap.Height);
     if ((215>=polarangle) and (polarangle>=190)) then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)-1155,B-round(Yw[polarpoint]*zoom)+2000);
     if ((235>polarangle) and (polarangle>215))   then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)-2000,B-round(Yw[polarpoint]*zoom)+2000);
     if ((260>=polarangle) and (polarangle>=235)) then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)-2000,B-round(Yw[polarpoint]*zoom)+1155);
     if ((280>polarangle) and (polarangle>260))   then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),0,B-round(Yw[polarpoint]*zoom));
     if ((305>=polarangle) and (polarangle>=280)) then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)-2000,B-round(Yw[polarpoint]*zoom)-1155);
     if ((325>polarangle) and (polarangle>305))   then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)-2000,B-round(Yw[polarpoint]*zoom)-2000);
     if ((350>=polarangle) and (polarangle>=325)) then mybitmap.canvas.Line(A+round(Xw[polarpoint]*zoom),B-round(Yw[polarpoint]*zoom),A+round(Xw[polarpoint]*zoom)-1155,B-round(Yw[polarpoint]*zoom)-2000);
     mybitmap.Canvas.Font.Style:=[fsBold];
     if wprowadz=1 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1));
     if wprowadz=2 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+',');
     if wprowadz=3 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1));
     if (wprowadz=3) and (round(liczba1)=liczba1) then begin
       if ulamek=0.1 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+',0');
       if ulamek=0.01 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+',00');
       if ulamek=0.001 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+',000');
     end;
     if wprowadzalfa=false then
     begin
       if wprowadz=4 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'x='+floattostr(liczba1)+' ; y='+floattostr(liczba2));
       if wprowadz=5 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'x='+floattostr(liczba1)+' ; y='+floattostr(liczba2)+',');
       if wprowadz=6 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'x='+floattostr(liczba1)+' ; y='+floattostr(liczba2));
       if (wprowadz=6) and (round(liczba2)=liczba2) then
       begin
        if ulamek=0.1 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'x='+floattostr(liczba1)+' ; y='+floattostr(liczba2)+',0');
        if ulamek=0.01 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'x='+floattostr(liczba1)+' ; y='+floattostr(liczba2)+',00');
        if ulamek=0.001 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'x='+floattostr(liczba1)+' ; y='+floattostr(liczba2)+',000');
       end;
     end else
     begin
       if wprowadz=4 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+' ; α='+floattostr(liczba2)+'°');
       if wprowadz=5 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+' ; α='+floattostr(liczba2)+',°');
       if wprowadz=6 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+' ; α='+floattostr(liczba2)+'°');
       if (wprowadz=6) and (round(liczba2)=liczba2) then
       begin
        if ulamek=0.1 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+' ; α='+floattostr(liczba2)+',0°');
        if ulamek=0.01 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+' ; α='+floattostr(liczba2)+',00°');
        if ulamek=0.001 then mybitmap.canvas.textout(Xmysz+20,Ymysz-40,'L='+floattostr(liczba1)+' ; α='+floattostr(liczba2)+',000°');
       end;
     end;
    end;
  mybitmap.canvas.pen.style:=pssolid;
  mybitmap.Canvas.Font.Style:=[];
  mybitmap.canvas.Brush.Color:=kolor[10];
  mybitmap.canvas.font.Size:=rozmiar[2];
  mybitmap.canvas.pen.Width:=1;
  mybitmap.canvas.pen.color:=kolor[13];
  if wyswietl>0 then for i:=1 to Le1 do     //wyniki
    for j:=1 to nrx[i,tenwariant] do
      begin
        Dx[i,j]:=Xw1[Wp1[i]]+(Xw1[Wk1[i]]-Xw1[Wp1[i]])*wsp[i,j,tenwariant]+skaladisp*ux[i,j,tenwariant];
        Dy[i,j]:=Yw1[Wp1[i]]+(Yw1[Wk1[i]]-Yw1[Wp1[i]])*wsp[i,j,tenwariant]+skaladisp*uy[i,j,tenwariant];
        if tryb=46 then begin
          DMx[i,j]:=Xw1[Wp1[i]]+(Xw1[Wk1[i]]-Xw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/100*(+M[i,j,tenwariant]*Ly1[i]/L1[i]);
          DMy[i,j]:=Yw1[Wp1[i]]+(Yw1[Wk1[i]]-Yw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/100*(-M[i,j,tenwariant]*Lx1[i]/L1[i]);
        end else begin
          DMx[i,j]:=Xw1[Wp1[i]]+(Xw1[Wk1[i]]-Xw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/100*(-M[i,j,tenwariant]*Ly1[i]/L1[i]);
          DMy[i,j]:=Yw1[Wp1[i]]+(Yw1[Wk1[i]]-Yw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/100*(+M[i,j,tenwariant]*Lx1[i]/L1[i]);
        end;
        DTx[i,j]:=Xw1[Wp1[i]]+(Xw1[Wk1[i]]-Xw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/100*(-T[i,j,tenwariant]*Ly1[i]/L1[i]);
        DTy[i,j]:=Yw1[Wp1[i]]+(Yw1[Wk1[i]]-Yw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/100*(T[i,j,tenwariant]*Lx1[i]/L1[i]);
        DNx[i,j]:=Xw1[Wp1[i]]+(Xw1[Wk1[i]]-Xw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/100*(-N[i,j,tenwariant]*Ly1[i]/L1[i]);
        DNy[i,j]:=Yw1[Wp1[i]]+(Yw1[Wk1[i]]-Yw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/100*(N[i,j,tenwariant]*Lx1[i]/L1[i]);
        Dnapr1x[i,j]:=Xw1[Wp1[i]]+(Xw1[Wk1[i]]-Xw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/10000*(-Napr1[i,j,tenwariant]*Ly1[i]/L1[i]);
        Dnapr1y[i,j]:=Yw1[Wp1[i]]+(Yw1[Wk1[i]]-Yw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/10000*(Napr1[i,j,tenwariant]*Lx1[i]/L1[i]);
        Dnapr2x[i,j]:=Xw1[Wp1[i]]+(Xw1[Wk1[i]]-Xw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/10000*(-Napr2[i,j,tenwariant]*Ly1[i]/L1[i]);
        Dnapr2y[i,j]:=Yw1[Wp1[i]]+(Yw1[Wk1[i]]-Yw1[Wp1[i]])*wsp[i,j,tenwariant]+skalawew/10000*(Napr2[i,j,tenwariant]*Lx1[i]/L1[i]);
      end;
  if wyswietl=4 then mybitmap.canvas.Pen.Color:=kolor[12] else mybitmap.canvas.Pen.Color:=kolor[11];
  if wyswietl>0 then for i:=1 to Le1 do          // wykresy
    if not((A+round(Xw1[Wp1[i]]*zoom)<0) and (A+round(Xw1[Wk1[i]]*zoom)<0)) and not((A+round(Xw1[Wp1[i]]*zoom)>Width) and (A+round(Xw1[Wk1[i]]*zoom)>Width))
    and not((B-round(Yw1[Wp1[i]]*zoom)<0) and (B-round(Yw1[Wk1[i]]*zoom)<0)) and not((B-round(Yw1[Wp1[i]]*zoom)>Height) and (B-round(Yw1[Wk1[i]]*zoom)>Height))
    then
      if czyrysowac[i]=true then
      for j:=1 to nrx[i,tenwariant]-1 do
        case wyswietl of
          5:begin mybitmap.canvas.Line(A+round(zoom*Dnapr1x[i,j]),B-round(zoom*Dnapr1y[i,j]),A+round(zoom*Dnapr1x[i,j+1]),B-round(zoom*Dnapr1y[i,j+1]));
                  mybitmap.canvas.Line(A+round(zoom*Dnapr2x[i,j]),B-round(zoom*Dnapr2y[i,j]),A+round(zoom*Dnapr2x[i,j+1]),B-round(zoom*Dnapr2y[i,j+1]));end;
          4: mybitmap.canvas.Line(A+round(zoom*Dx[i,j]),B-round(zoom*Dy[i,j]),A+round(zoom*Dx[i,j+1]),B-round(zoom*Dy[i,j+1]));
          3:mybitmap.canvas.Line(A+round(zoom*DMx[i,j]),B-round(zoom*DMy[i,j]),A+round(zoom*DMx[i,j+1]),B-round(zoom*DMy[i,j+1]));
          2:mybitmap.canvas.Line(A+round(zoom*DTx[i,j]),B-round(zoom*DTy[i,j]),A+round(zoom*DTx[i,j+1]),B-round(zoom*DTy[i,j+1]));
          1:mybitmap.canvas.Line(A+round(zoom*DNx[i,j]),B-round(zoom*DNy[i,j]),A+round(zoom*DNx[i,j+1]),B-round(zoom*DNy[i,j+1]));
        end;
  EJ:=1;
  if checkbox5.checked=true then EJ:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ji[combobox1.Items.IndexOf(combobox2.text)+1];
  if checkbox6.checked=true then EJ:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ai[combobox1.Items.IndexOf(combobox2.text)+1];
  for i:=1 to Le1 do                         // wartosci na krawędziach
    if not((A+round(Xw1[Wp1[i]]*zoom)<0) and (A+round(Xw1[Wk1[i]]*zoom)<0)) and not((A+round(Xw1[Wp1[i]]*zoom)>Width) and (A+round(Xw1[Wk1[i]]*zoom)>Width))
    and not((B-round(Yw1[Wp1[i]]*zoom)<0) and (B-round(Yw1[Wk1[i]]*zoom)<0)) and not((B-round(Yw1[Wp1[i]]*zoom)>Height) and (B-round(Yw1[Wk1[i]]*zoom)>Height))
    then
      if czyrysowac[i]=true then
       case wyswietl of
        5:begin mybitmap.canvas.line(A+round(zoom*Xw1[Wp1[i]]),B-round(zoom*Yw1[Wp1[i]]),A+round(zoom*Dnapr1x[i,1]),B-round(zoom*Dnapr1y[i,1]));
                mybitmap.canvas.line(A+round(zoom*Dnapr1x[i,nrx[i,tenwariant]]),B-round(zoom*Dnapr1y[i,nrx[i,tenwariant]]),A+round(zoom*Xw1[Wk1[i]]),B-round(zoom*Yw1[Wk1[i]]));
                mybitmap.canvas.line(A+round(zoom*Xw1[Wp1[i]]),B-round(zoom*Yw1[Wp1[i]]),A+round(zoom*Dnapr2x[i,1]),B-round(zoom*Dnapr2y[i,1]));
                mybitmap.canvas.line(A+round(zoom*Dnapr2x[i,nrx[i,tenwariant]]),B-round(zoom*Dnapr2y[i,nrx[i,tenwariant]]),A+round(zoom*Xw1[Wk1[i]]),B-round(zoom*Yw1[Wk1[i]]));
                if (alfapr[i]<90) and (alfapr[i]>-90) then begin rownaj[2]:=5; rownaj[4]:=5; rownaj[1]:=-5-mybitmap.canvas.textwidth(floattostrf(napr1[i,1,tenwariant],fffixed,7,3)); rownaj[3]:=-5-mybitmap.canvas.textwidth(floattostrf(napr2[i,1,tenwariant],fffixed,7,3)) end else begin rownaj[2]:=-5-mybitmap.canvas.textwidth(floattostrf(napr1[i,nrx[i,tenwariant],tenwariant],fffixed,7,3)); rownaj[1]:=5; rownaj[4]:=-5-mybitmap.canvas.textwidth(floattostrf(napr2[i,nrx[i,tenwariant],tenwariant],fffixed,7,3)); rownaj[3]:=5; end;
                if abs(napr1[i,nrx[i,tenwariant],tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*Dnapr1x[i,nrx[i,tenwariant]])+rownaj[2],B-round(zoom*Dnapr1y[i,nrx[i,tenwariant]]),floattostrf(napr1[i,nrx[i,tenwariant],tenwariant],fffixed,7,3));
                if abs(napr2[i,nrx[i,tenwariant],tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*Dnapr2x[i,nrx[i,tenwariant]])+rownaj[2],B-round(zoom*Dnapr2y[i,nrx[i,tenwariant]]),floattostrf(napr2[i,nrx[i,tenwariant],tenwariant],fffixed,7,3));
                if abs(napr1[i,1,tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*Dnapr1x[i,1])+rownaj[1],B-round(zoom*Dnapr1y[i,1]),floattostrf(napr1[i,1,tenwariant],fffixed,7,3));
                if abs(napr2[i,1,tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*Dnapr2x[i,1])+rownaj[1],B-round(zoom*Dnapr2y[i,1]),floattostrf(napr2[i,1,tenwariant],fffixed,7,3));
          end;
        3:begin mybitmap.canvas.line(A+round(zoom*Xw1[Wp1[i]]),B-round(zoom*Yw1[Wp1[i]]),A+round(zoom*DMx[i,1]),B-round(zoom*DMy[i,1]));
                mybitmap.canvas.line(A+round(zoom*DMx[i,nrx[i,tenwariant]]),B-round(zoom*DMy[i,nrx[i,tenwariant]]),A+round(zoom*Xw1[Wk1[i]]),B-round(zoom*Yw1[Wk1[i]]));
                if (alfapr[i]<90) and (alfapr[i]>-90) then begin rownaj[2]:=5; rownaj[1]:=-5-mybitmap.canvas.textwidth(floattostrf(M[i,1,tenwariant]/EJ,fffixed,7,3))end else begin rownaj[2]:=-5-mybitmap.canvas.textwidth(floattostrf(M[i,nrx[i,tenwariant],tenwariant]/EJ,fffixed,7,3)); rownaj[1]:=5; end;
                if abs(M[i,nrx[i,tenwariant],tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*DMx[i,nrx[i,tenwariant]])+rownaj[2],B-round(zoom*DMy[i,nrx[i,tenwariant]]),floattostrf(M[i,nrx[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                if abs(M[i,1,tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*DMx[i,1])+rownaj[1],B-round(zoom*DMy[i,1]),floattostrf(M[i,1,tenwariant]/EJ,fffixed,7,3));
          end;
        2:begin mybitmap.canvas.line(A+round(zoom*Xw1[Wp1[i]]),B-round(zoom*Yw1[Wp1[i]]),A+round(zoom*DTx[i,1]),B-round(zoom*DTy[i,1]));
                mybitmap.canvas.line(A+round(zoom*DTx[i,nrx[i,tenwariant]]),B-round(zoom*DTy[i,nrx[i,tenwariant]]),A+round(zoom*Xw1[Wk1[i]]),B-round(zoom*Yw1[Wk1[i]]));
                if (alfapr[i]<90) and (alfapr[i]>-90) then begin rownaj[2]:=5; rownaj[1]:=-5-mybitmap.canvas.textwidth(floattostrf(T[i,1,tenwariant]/EJ,fffixed,7,3))end else begin rownaj[2]:=-5-mybitmap.canvas.textwidth(floattostrf(T[i,nrx[i,tenwariant],tenwariant]/EJ,fffixed,7,3)); rownaj[1]:=5; end;
                if abs(T[i,nrx[i,tenwariant],tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*DTx[i,nrx[i,tenwariant]])+rownaj[2],B-round(zoom*DTy[i,nrx[i,tenwariant]]),floattostrf(T[i,nrx[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                if abs(T[i,1,tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*DTx[i,1])+rownaj[1],B-round(zoom*DTy[i,1]),floattostrf(T[i,1,tenwariant]/EJ,fffixed,7,3));
          end;
        1:begin mybitmap.canvas.line(A+round(zoom*Xw1[Wp1[i]]),B-round(zoom*Yw1[Wp1[i]]),A+round(zoom*DNx[i,1]),B-round(zoom*DNy[i,1]));
                mybitmap.canvas.line(A+round(zoom*DNx[i,nrx[i,tenwariant]]),B-round(zoom*DNy[i,nrx[i,tenwariant]]),A+round(zoom*Xw1[Wk1[i]]),B-round(zoom*Yw1[Wk1[i]]));
                if (alfapr[i]<90) and (alfapr[i]>-90) then begin rownaj[2]:=5; rownaj[1]:=-5-mybitmap.canvas.textwidth(floattostrf(N[i,1,tenwariant]/EJ,fffixed,7,3))end else begin rownaj[2]:=-5-mybitmap.canvas.textwidth(floattostrf(N[i,nrx[i,tenwariant],tenwariant]/EJ,fffixed,7,3)); rownaj[1]:=5; end;
                if abs(N[i,nrx[i,tenwariant],tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*DNx[i,nrx[i,tenwariant]])+rownaj[2],B-round(zoom*DNy[i,nrx[i,tenwariant]]),floattostrf(N[i,nrx[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                if abs(N[i,1,tenwariant])>0.001 then mybitmap.canvas.textout(A+round(zoom*DNx[i,1])+rownaj[1],B-round(zoom*DNy[i,1]),floattostrf(N[i,1,tenwariant]/EJ,fffixed,7,3));
          end;
      end;
  if tryb=46 then begin
  for i:=1 to RowsPp do                     // wartości w miejscach P
    if  not((A+round(Xw1[Wp1[np[i]]]*zoom)<0) and (A+round(Xw1[Wk1[np[i]]]*zoom)<0)) and not((A+round(Xw1[Wp1[np[i]]]*zoom)>Width)  and (A+round(Xw1[Wk1[np[i]]]*zoom)>Width))
    and not((B-round(Yw1[Wp1[np[i]]]*zoom)<0) and (B-round(Yw1[Wk1[np[i]]]*zoom)<0)) and not((B-round(Yw1[Wp1[np[i]]]*zoom)>Height) and (B-round(Yw1[Wk1[np[i]]]*zoom)>Height))
    then
      if czyrysowac[np[i]]=true then
      begin
        if xpwsp[i,tenwariant]>0 then
        case wyswietl of
         5:begin if abs(napr1[np[i],xpwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*Dnapr1x[np[i],xpwsp[i,tenwariant]])+5,B-round(zoom*Dnapr1y[np[i],xpwsp[i,tenwariant]]),floattostrf(napr1[np[i],xpwsp[i,tenwariant],tenwariant],fffixed,7,3));
                                                                mybitmap.canvas.Line(A+round(zoom*Dnapr1x[np[i],xpwsp[i,tenwariant]]),B-round(zoom*Dnapr1y[np[i],xpwsp[i,tenwariant]]),A+round((xw[wp[np[i]]]+(xw[wk[np[i]]]-xw[wp[np[i]]])*xp[i])*zoom),B-round((yw[wp[np[i]]]+(yw[wk[np[i]]]-yw[wp[np[i]]])*xp[i])*zoom)); end;
                 if abs(napr2[np[i],xpwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*Dnapr2x[np[i],xpwsp[i,tenwariant]])+5,B-round(zoom*Dnapr2y[np[i],xpwsp[i,tenwariant]]),floattostrf(napr2[np[i],xpwsp[i,tenwariant],tenwariant],fffixed,7,3));
                                                                mybitmap.canvas.Line(A+round(zoom*Dnapr2x[np[i],xpwsp[i,tenwariant]]),B-round(zoom*Dnapr2y[np[i],xpwsp[i,tenwariant]]),A+round((xw[wp[np[i]]]+(xw[wk[np[i]]]-xw[wp[np[i]]])*xp[i])*zoom),B-round((yw[wp[np[i]]]+(yw[wk[np[i]]]-yw[wp[np[i]]])*xp[i])*zoom)); end;
           end;
         3:begin if abs(M[np[i],xpwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DMx[np[i],xpwsp[i,tenwariant]])+5,B-round(zoom*DMy[np[i],xpwsp[i,tenwariant]]),floattostrf(M[np[i],xpwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                            mybitmap.canvas.Line(A+round(zoom*DMx[np[i],xpwsp[i,tenwariant]]),B-round(zoom*DMy[np[i],xpwsp[i,tenwariant]]),A+round((xw[wp[np[i]]]+(xw[wk[np[i]]]-xw[wp[np[i]]])*xp[i])*zoom),B-round((yw[wp[np[i]]]+(yw[wk[np[i]]]-yw[wp[np[i]]])*xp[i])*zoom)); end;
           end;
         2:begin if abs(T[np[i],xpwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DTx[np[i],xpwsp[i,tenwariant]])+5,B-round(zoom*DTy[np[i],xpwsp[i,tenwariant]]),floattostrf(T[np[i],xpwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                            mybitmap.canvas.Line(A+round(zoom*DTx[np[i],xpwsp[i,tenwariant]]),B-round(zoom*DTy[np[i],xpwsp[i,tenwariant]]),A+round((xw[wp[np[i]]]+(xw[wk[np[i]]]-xw[wp[np[i]]])*xp[i])*zoom),B-round((yw[wp[np[i]]]+(yw[wk[np[i]]]-yw[wp[np[i]]])*xp[i])*zoom)); end;
             if (np[i]>0) and (abs(T[np[i],xpwsp[i,tenwariant]+1,tenwariant])>0.001) then begin mybitmap.canvas.textout(A+round(zoom*DTx[np[i],xpwsp[i,tenwariant]+1])+5,B-round(zoom*DTy[np[i],xpwsp[i,tenwariant]+1]),floattostrf(T[np[i],xpwsp[i,tenwariant]+1,tenwariant]/EJ,fffixed,7,3));
                                                                          mybitmap.canvas.Line(A+round(zoom*DTx[np[i],xpwsp[i,tenwariant]+1]),B-round(zoom*DTy[np[i],xpwsp[i,tenwariant]+1]),A+round((xw[wp[np[i]]]+(xw[wk[np[i]]]-xw[wp[np[i]]])*xp[i])*zoom),B-round((yw[wp[np[i]]]+(yw[wk[np[i]]]-yw[wp[np[i]]])*xp[i])*zoom)); end;
           end;
         1:begin if abs(N[np[i],xpwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DNx[np[i],xpwsp[i,tenwariant]])+5,B-round(zoom*DNy[np[i],xpwsp[i,tenwariant]]),floattostrf(N[np[i],xpwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                            mybitmap.canvas.Line(A+round(zoom*DNx[np[i],xpwsp[i,tenwariant]]),B-round(zoom*DNy[np[i],xpwsp[i,tenwariant]]),A+round((xw[wp[np[i]]]+(xw[wk[np[i]]]-xw[wp[np[i]]])*xp[i])*zoom),B-round((yw[wp[np[i]]]+(yw[wk[np[i]]]-yw[wp[np[i]]])*xp[i])*zoom)); end;
             if (np[i]>0) and (abs(N[np[i],xpwsp[i,tenwariant]+1,tenwariant])>0.001) then begin mybitmap.canvas.textout(A+round(zoom*DNx[np[i],xpwsp[i,tenwariant]+1])+5,B-round(zoom*DNy[np[i],xpwsp[i,tenwariant]+1]),floattostrf(N[np[i],xpwsp[i,tenwariant]+1,tenwariant]/EJ,fffixed,7,3));
                                                                          mybitmap.canvas.Line(A+round(zoom*DNx[np[i],xpwsp[i,tenwariant]+1]),B-round(zoom*DNy[np[i],xpwsp[i,tenwariant]+1]),A+round((xw[wp[np[i]]]+(xw[wk[np[i]]]-xw[wp[np[i]]])*xp[i])*zoom),B-round((yw[wp[np[i]]]+(yw[wk[np[i]]]-yw[wp[np[i]]])*xp[i])*zoom)); end;
           end;
        end;
      end;
  for i:=1 to RowsPq do                 // wartości w miejscach q
    if  not((A+round(Xw1[Wp1[nq[i]]]*zoom)<0) and (A+round(Xw1[Wk1[nq[i]]]*zoom)<0)) and not((A+round(Xw1[Wp1[nq[i]]]*zoom)>Width)  and (A+round(Xw1[Wk1[nq[i]]]*zoom)>Width))
    and not((B-round(Yw1[Wp1[nq[i]]]*zoom)<0) and (B-round(Yw1[Wk1[nq[i]]]*zoom)<0)) and not((B-round(Yw1[Wp1[nq[i]]]*zoom)>Height) and (B-round(Yw1[Wk1[nq[i]]]*zoom)>Height))
    then
    if czyrysowac[nq[i]]=true then
    begin
     if xqiwsp[i,tenwariant]>0 then
     case wyswietl of
      5: begin if abs(napr1[nq[i],xqiwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*Dnapr1x[nq[i],xqiwsp[i,tenwariant]])+5,B-round(zoom*Dnapr1y[nq[i],xqiwsp[i,tenwariant]]),floattostrf(napr1[nq[i],xqiwsp[i,tenwariant],tenwariant],fffixed,7,3));
                                                               mybitmap.canvas.Line(A+round(zoom*Dnapr1x[nq[i],xqiwsp[i,tenwariant]]),B-round(zoom*Dnapr1y[nq[i],xqiwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqi[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqi[i])*zoom)); end;
               if abs(napr2[nq[i],xqiwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*Dnapr2x[nq[i],xqiwsp[i,tenwariant]])+5,B-round(zoom*Dnapr2y[nq[i],xqiwsp[i,tenwariant]]),floattostrf(napr2[nq[i],xqiwsp[i,tenwariant],tenwariant],fffixed,7,3));
                                                               mybitmap.canvas.Line(A+round(zoom*Dnapr2x[nq[i],xqiwsp[i,tenwariant]]),B-round(zoom*Dnapr2y[nq[i],xqiwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqi[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqi[i])*zoom)); end;
        end;
      3: if abs(M[nq[i],xqiwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DMx[nq[i],xqiwsp[i,tenwariant]])+5,B-round(zoom*DMy[nq[i],xqiwsp[i,tenwariant]]),floattostrf(M[nq[i],xqiwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                     mybitmap.canvas.Line(A+round(zoom*DMx[nq[i],xqiwsp[i,tenwariant]]),B-round(zoom*DMy[nq[i],xqiwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqi[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqi[i])*zoom)); end;
      2: if abs(T[nq[i],xqiwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DTx[nq[i],xqiwsp[i,tenwariant]])+5,B-round(zoom*DTy[nq[i],xqiwsp[i,tenwariant]]),floattostrf(T[nq[i],xqiwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                     mybitmap.canvas.Line(A+round(zoom*DTx[nq[i],xqiwsp[i,tenwariant]]),B-round(zoom*DTy[nq[i],xqiwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqi[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqi[i])*zoom)); end;
      1: if abs(N[nq[i],xqiwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DNx[nq[i],xqiwsp[i,tenwariant]])+5,B-round(zoom*DNy[nq[i],xqiwsp[i,tenwariant]]),floattostrf(N[nq[i],xqiwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                     mybitmap.canvas.Line(A+round(zoom*DNx[nq[i],xqiwsp[i,tenwariant]]),B-round(zoom*DNy[nq[i],xqiwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqi[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqi[i])*zoom)); end;
      end;
     if xqjwsp[i,tenwariant]>0 then
     case wyswietl of
      5: begin if abs(napr1[nq[i],xqjwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*Dnapr1x[nq[i],xqjwsp[i,tenwariant]])+5,B-round(zoom*Dnapr1y[nq[i],xqjwsp[i,tenwariant]]),floattostrf(napr1[nq[i],xqjwsp[i,tenwariant],tenwariant],fffixed,7,3));
                                                               mybitmap.canvas.Line(A+round(zoom*Dnapr1x[nq[i],xqjwsp[i,tenwariant]]),B-round(zoom*Dnapr1y[nq[i],xqjwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqj[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqj[i])*zoom)); end;
               if abs(napr2[nq[i],xqjwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*Dnapr2x[nq[i],xqjwsp[i,tenwariant]])+5,B-round(zoom*Dnapr2y[nq[i],xqjwsp[i,tenwariant]]),floattostrf(napr2[nq[i],xqjwsp[i,tenwariant],tenwariant],fffixed,7,3));
                                                               mybitmap.canvas.Line(A+round(zoom*Dnapr2x[nq[i],xqjwsp[i,tenwariant]]),B-round(zoom*Dnapr2y[nq[i],xqjwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqj[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqj[i])*zoom)); end;
        end;
      3: if abs(M[nq[i],xqjwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DMx[nq[i],xqjwsp[i,tenwariant]])+5,B-round(zoom*DMy[nq[i],xqjwsp[i,tenwariant]]),floattostrf(M[nq[i],xqjwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                     mybitmap.canvas.Line(A+round(zoom*DMx[nq[i],xqjwsp[i,tenwariant]]),B-round(zoom*DMy[nq[i],xqjwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqj[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqj[i])*zoom)); end;
      2: if abs(T[nq[i],xqjwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DTx[nq[i],xqjwsp[i,tenwariant]])+5,B-round(zoom*DTy[nq[i],xqjwsp[i,tenwariant]]),floattostrf(T[nq[i],xqjwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                     mybitmap.canvas.Line(A+round(zoom*DTx[nq[i],xqjwsp[i,tenwariant]]),B-round(zoom*DTy[nq[i],xqjwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqj[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqj[i])*zoom)); end;
      1: if abs(N[nq[i],xqjwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DNx[nq[i],xqjwsp[i,tenwariant]])+5,B-round(zoom*DNy[nq[i],xqjwsp[i,tenwariant]]),floattostrf(N[nq[i],xqjwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                     mybitmap.canvas.Line(A+round(zoom*DNx[nq[i],xqjwsp[i,tenwariant]]),B-round(zoom*DNy[nq[i],xqjwsp[i,tenwariant]]),A+round((xw[wp[nq[i]]]+(xw[wk[nq[i]]]-xw[wp[nq[i]]])*xqj[i])*zoom),B-round((yw[wp[nq[i]]]+(yw[wk[nq[i]]]-yw[wp[nq[i]]])*xqj[i])*zoom)); end;
      end;
    end;
  for i:=1 to RowsPm do                 // wartości w miejscach M
    if  not((A+round(Xw1[Wp1[nm[i]]]*zoom)<0) and (A+round(Xw1[Wk1[nm[i]]]*zoom)<0)) and not((A+round(Xw1[Wp1[nm[i]]]*zoom)>Width)  and (A+round(Xw1[Wk1[nm[i]]]*zoom)>Width))
    and not((B-round(Yw1[Wp1[nm[i]]]*zoom)<0) and (B-round(Yw1[Wk1[nm[i]]]*zoom)<0)) and not((B-round(Yw1[Wp1[nm[i]]]*zoom)>Height) and (B-round(Yw1[Wk1[nm[i]]]*zoom)>Height))
    then
    if czyrysowac[nm[i]]=true then
    begin
     if xmwsp[i,tenwariant]>0 then
     case wyswietl of
       5:begin if abs(napr1[nm[i],xmwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*Dnapr1x[nm[i],xmwsp[i,tenwariant]])+5,B-round(zoom*Dnapr1y[nm[i],xmwsp[i,tenwariant]]),floattostrf(napr1[nm[i],xmwsp[i,tenwariant],tenwariant],fffixed,7,3));
                                                              mybitmap.canvas.Line(A+round(zoom*Dnapr1x[nm[i],xmwsp[i,tenwariant]]),B-round(zoom*Dnapr1y[nm[i],xmwsp[i,tenwariant]]),A+round((xw[wp[nm[i]]]+(xw[wk[nm[i]]]-xw[wp[nm[i]]])*xm[i])*zoom),B-round((yw[wp[nm[i]]]+(yw[wk[nm[i]]]-yw[wp[nm[i]]])*xm[i])*zoom)); end;
               if abs(napr2[nm[i],xmwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*Dnapr2x[nm[i],xmwsp[i,tenwariant]])+5,B-round(zoom*Dnapr2y[nm[i],xmwsp[i,tenwariant]]),floattostrf(napr2[nm[i],xmwsp[i,tenwariant],tenwariant],fffixed,7,3));
                                                              mybitmap.canvas.Line(A+round(zoom*Dnapr2x[nm[i],xmwsp[i,tenwariant]]),B-round(zoom*Dnapr2y[nm[i],xmwsp[i,tenwariant]]),A+round((xw[wp[nm[i]]]+(xw[wk[nm[i]]]-xw[wp[nm[i]]])*xm[i])*zoom),B-round((yw[wp[nm[i]]]+(yw[wk[nm[i]]]-yw[wp[nm[i]]])*xm[i])*zoom)); end;
         end;
       3:begin if abs(M[nm[i],xmwsp[i,tenwariant],tenwariant])>0.001 then begin mybitmap.canvas.textout(A+round(zoom*DMx[nm[i],xmwsp[i,tenwariant]])+5,B-round(zoom*DMy[nm[i],xmwsp[i,tenwariant]]),floattostrf(M[nm[i],xmwsp[i,tenwariant],tenwariant]/EJ,fffixed,7,3));
                                                          mybitmap.canvas.Line(A+round(zoom*DMx[nm[i],xmwsp[i,tenwariant]]),B-round(zoom*DMy[nm[i],xmwsp[i,tenwariant]]),A+round((xw[wp[nm[i]]]+(xw[wk[nm[i]]]-xw[wp[nm[i]]])*xm[i])*zoom),B-round((yw[wp[nm[i]]]+(yw[wk[nm[i]]]-yw[wp[nm[i]]])*xm[i])*zoom)); end;
               if (nm[i]>0) and (abs(M[nm[i],xmwsp[i,tenwariant]+1,tenwariant])>0.001) then begin mybitmap.canvas.textout(A+round(zoom*DMx[nm[i],xmwsp[i,tenwariant]+1])+5,B-round(zoom*DMy[nm[i],xmwsp[i,tenwariant]+1]),floattostrf(M[nm[i],xmwsp[i,tenwariant]+1,tenwariant]/EJ,fffixed,7,3));
                                                                            mybitmap.canvas.Line(A+round(zoom*DMx[nm[i],xmwsp[i,tenwariant]+1]),B-round(zoom*DMy[nm[i],xmwsp[i,tenwariant]+1]),A+round((xw[wp[nm[i]]]+(xw[wk[nm[i]]]-xw[wp[nm[i]]])*xm[i])*zoom),B-round((yw[wp[nm[i]]]+(yw[wk[nm[i]]]-yw[wp[nm[i]]])*xm[i])*zoom)); end;
         end;
     end;
    end;
  end;
  //reakcje
  mybitmap.canvas.pen.Width:=3;
  mybitmap.canvas.pen.color:=kolor[15];
  if (tbreakcje.Down=true) and (wyswietl>0) then
    for i:=1 to Lwar do
      begin
      rea:=reak[s[i]*3-2,tenwariant];
      if abs(rea)>=0.001 then //pionowe
        begin
         if rea>0 then znak:=1 else znak:=-1;
         mybitmap.canvas.line(pointpodpora(0,-10*znak),pointpodpora(0,-30*znak));
         mybitmap.canvas.line(pointpodpora(0,-10*znak),pointpodpora(-3,-15*znak));
         mybitmap.canvas.line(pointpodpora(0,-10*znak),pointpodpora(3,-15*znak));
         mybitmap.canvas.textout(A-trunc(mybitmap.Canvas.TextWidth(floattostrf(rea,fffixed,7,3))/2)+round(zoom*xw[s[i]]-sin(fipod[i]*pi()/180)*znak*60),B-6-round(zoom*yw[s[i]]-cos(fipod[i]*pi()/180)*znak*45),floattostrf(rea/EJ,fffixed,7,3));
        end;
      rea:=reak[s[i]*3-1,tenwariant];
      if abs(rea)>=0.001 then //poziome
        begin
         if rea>0 then znak:=1 else znak:=-1;
         mybitmap.canvas.line(pointpodpora(-10*znak,0),pointpodpora(-30*znak,0));
         mybitmap.canvas.line(pointpodpora(-10*znak,0),pointpodpora(-15*znak,-3));
         mybitmap.canvas.line(pointpodpora(-10*znak,0),pointpodpora(-15*znak,3));
         mybitmap.canvas.textout(A-trunc(mybitmap.Canvas.TextWidth(floattostrf(rea,fffixed,7,3))/2)+round(zoom*xw[s[i]]-cos(fipod[i]*pi()/180)*znak*60),B-6-round(zoom*yw[s[i]]+sin(fipod[i]*pi()/180)*znak*45),floattostrf(rea/EJ,fffixed,7,3));
        end;
      rea:=reak[s[i]*3,tenwariant];
      if abs(rea)>=0.001 then //momenty
        begin
          if rea>0 then znak:=1 else znak:=-1;
          mybitmap.canvas.line(pointpodpora(-20,-50),pointpodpora(-28,-49));
          mybitmap.canvas.LineTo(pointpodpora(-35,-46));mybitmap.canvas.LineTo(pointpodpora(-41,-41));mybitmap.canvas.LineTo(pointpodpora(-46,-35));
          mybitmap.canvas.LineTo(pointpodpora(-49,-28));mybitmap.canvas.LineTo(pointpodpora(-50,-20));
          if znak=-1 then begin
            mybitmap.canvas.line(pointpodpora(-20,-50),pointpodpora(-25,-53));
            mybitmap.canvas.line(pointpodpora(-20,-50),pointpodpora(-25,-47));
          end
          else begin
             mybitmap.canvas.line(pointpodpora(-50,-20),pointpodpora(-53,-25));
             mybitmap.canvas.line(pointpodpora(-50,-20),pointpodpora(-47,-25));
          end;
          mybitmap.canvas.textout(A-trunc(mybitmap.Canvas.TextWidth(floattostrf(rea,fffixed,7,3))/2)+round(zoom*xw[s[i]]-sin((fipod[i]+45)*pi()/180)*90),B-6-round(zoom*yw[s[i]]-cos((fipod[i]+45)*pi()/180)*70),floattostrf(rea/EJ,fffixed,7,3));

        end;
    end;

  if wybranypret>0 then begin              //wyswietlanie okienka wynikow
    mybitmap.canvas.EllipseC(A+round((Xw1[Wp1[wybranypret]]+xwybranypret*(Xw1[Wk1[wybranypret]]-Xw1[Wp1[wybranypret]]))*zoom),B-round((Yw1[Wp1[wybranypret]]+xwybranypret*(Yw1[Wk1[wybranypret]]-Yw1[Wp1[wybranypret]]))*zoom),5,5);
  end;
  mybitmap.canvas.brush.color:=kolor[14];
  if (miedzywezlami>0) and (miedzywezlami<4) then for i:=1 to Lw1 do if sqrt(sqr((Xmysz-A)/zoom-Xw1[i])+sqr(-(Ymysz-B)/zoom-Yw1[i]))<5/zoom then mybitmap.canvas.framerect(round(Xw1[i]*zoom+A)-7,round(-Yw1[i]*zoom+B)-7,round(Xw1[i]*zoom+A)+7,round(-Yw1[i]*zoom+B)+7);
  mybitmap.canvas.brush.color:=kolor[1];
  if miedzywezlami=1 then mybitmap.canvas.textout(Xmysz+10,Ymysz-10,'wybierz pierwszy węzeł');
  if miedzywezlami=2 then begin mybitmap.canvas.brush.color:=kolor[14]; mybitmap.canvas.Line(round(Xw[wezel1]*zoom+A),round(-Yw[wezel1]*zoom+B),xmysz,ymysz); mybitmap.canvas.framerect(round(Xw[wezel1]*zoom+A)-7,round(-Yw[wezel1]*zoom+B)-7,round(Xw[wezel1]*zoom+A)+7,round(-Yw[wezel1]*zoom+B)+7); mybitmap.canvas.brush.color:=kolor[1]; mybitmap.canvas.textout(Xmysz+10,Ymysz-10,'wybierz drugi węzeł'); end;
  mybitmap.canvas.pen.width:=5;
  if miedzywezlami>3 then
    for i:=1 to Le1 do begin
     KLIKX[i]:=(Lx1[i]/L1[i]*((Xmysz-A)/zoom-Xw1[Wp1[i]])+Ly1[i]/L1[i]*(-(Ymysz-B)/zoom-Yw1[Wp1[i]]));
     KLIKY[i]:=(Ly1[i]/L1[i]*((Xmysz-A)/zoom-Xw1[Wp1[i]])-Lx1[i]/L1[i]*(-(Ymysz-B)/zoom-Yw1[Wp1[i]]));
     if (KLIKX[i]>10/zoom) and (KLIKX[i]<L1[i]-10/zoom) and (KLIKY[i]<10/zoom) and (KLIKY[i]>-10/zoom) then
       mybitmap.canvas.line(round(xw1[wp1[i]]*zoom+A),round(-yw1[wp1[i]]*zoom+B),round(xw1[wk1[i]]*zoom+A),round(-yw1[wk1[i]]*zoom+B));
    end;
  if tryb=44 then
    for i:=1 to Le do begin
     KLIKX[i]:=(Lx[i]/L[i]*((Xmysz-A)/zoom-Xw[Wp[i]])+Ly[i]/L[i]*(-(Ymysz-B)/zoom-Yw[Wp[i]]));
     KLIKY[i]:=(Ly[i]/L[i]*((Xmysz-A)/zoom-Xw[Wp[i]])-Lx[i]/L[i]*(-(Ymysz-B)/zoom-Yw[Wp[i]]));
     if (KLIKX[i]>10/zoom) and (KLIKX[i]<L[i]-10/zoom) and (KLIKY[i]<10/zoom) and (KLIKY[i]>-10/zoom) then
       mybitmap.canvas.line(round(xw[wp[i]]*zoom+A),round(-yw[wp[i]]*zoom+B),round(xw[wk[i]]*zoom+A),round(-yw[wk[i]]*zoom+B));
    end;
  if miedzywezlami=4 then mybitmap.canvas.textout(Xmysz+10,Ymysz-10,'wybierz pierwszy pręt');
  if miedzywezlami=5 then begin mybitmap.canvas.line(round(xw1[wp1[pret1]]*zoom+A),round(-yw1[wp1[pret1]]*zoom+B),round(xw1[wk1[pret1]]*zoom+A),round(-yw1[wk1[pret1]]*zoom+B)); mybitmap.canvas.textout(Xmysz+10,Ymysz-10,'wybierz drugi pręt'); end;
  if tryb=44 then mybitmap.canvas.textout(Xmysz+10,Ymysz-10,'wybierz pręt');
  mybitmap.canvas.pen.width:=3;
  if form13open=true then begin mybitmap.canvas.line(round((xw[wp[pretlw]]+(xw[wk[pretlw]]-xw[wp[pretlw]])*form13x)*zoom)+A-10,-round((yw[wp[pretlw]]+(yw[wk[pretlw]]-yw[wp[pretlw]])*form13x)*zoom)+B-10,round((xw[wp[pretlw]]+(xw[wk[pretlw]]-xw[wp[pretlw]])*form13x)*zoom)+A+10,-round((yw[wp[pretlw]]+(yw[wk[pretlw]]-yw[wp[pretlw]])*form13x)*zoom)+B+10);
                                mybitmap.canvas.line(round((xw[wp[pretlw]]+(xw[wk[pretlw]]-xw[wp[pretlw]])*form13x)*zoom)+A-10,-round((yw[wp[pretlw]]+(yw[wk[pretlw]]-yw[wp[pretlw]])*form13x)*zoom)+B+10,round((xw[wp[pretlw]]+(xw[wk[pretlw]]-xw[wp[pretlw]])*form13x)*zoom)+A+10,-round((yw[wp[pretlw]]+(yw[wk[pretlw]]-yw[wp[pretlw]])*form13x)*zoom)+B-10);end;
  //napisy
  if tryb=46 then
  begin
    mybitmap.canvas.font.Size:=rozmiar[1];
    mybitmap.canvas.font.Bold:=true;
    mybitmap.canvas.pen.color:=kolor[13];
    case wyswietl of
      1:aaaa:='N [kN]';
      2:aaaa:='T [kN]';
      3:aaaa:='M [kNm]';
      4:aaaa:='u [mm]';
      5:aaaa:='σ [MPa]';
    end;
    if wyswietl=4 then
    begin
      if checkbox2.checked=true then aaaa:=aaaa+' (*EJ)';
      if checkbox3.checked=true then aaaa:=aaaa+' (*EA)';
      if checkbox4.checked=true then aaaa:=aaaa+' (/αt)';
    end;
    if (wyswietl>=1) and (wyswietl<=3) then
    begin
      if checkbox5.checked=true then aaaa:=aaaa+' (/EJ)';
      if checkbox6.checked=true then aaaa:=aaaa+' (/EA)';
    end;
    if rozbijobc=true then case tenwariant of
      0:bbbb:='' ;
      1:bbbb:=', stan p';
      2:bbbb:=', stan t0';
      3:bbbb:=', stan Δt';
      4:bbbb:=', stan Δ';
      5:bbbb:=', stan k';
    end else if tenwariant>0 then bbbb:=', '+wariantnazwa[tenwariant];
    mybitmap.canvas.TextOut(10,10+toolbar2.height,aaaa+bbbb);
  end;
  mybitmap.canvas.brush.color:=kolor[9];
  mybitmap.canvas.font.Style:=[];
  mybitmap.canvas.font.size:=rozmiar[1];
  if tryb2=1 then          //podgląd wymiarów
    begin
      if kliknietoco=1 then
      begin
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(8.0*rozmiar[1]*screen.pixelsperinch/96),'Pręt '+inttostr(kliknietonr));
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(6.4*rozmiar[1]*screen.pixelsperinch/96),combobox1.Items[Prz[kliknietonr]]);
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(4.8*rozmiar[1]*screen.pixelsperinch/96),'Lx= '+floattostrf(Lx[kliknietonr],fffixed,7,3)+'m');
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(3.2*rozmiar[1]*screen.pixelsperinch/96),'Ly= '+floattostrf(Ly[kliknietonr],fffixed,7,3)+'m');
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(1.6*rozmiar[1]*screen.pixelsperinch/96),'L= '+floattostrf(L[kliknietonr],fffixed,7,3)+'m');
        mybitmap.canvas.textout(Xmysz,Ymysz-15,'α= '+floattostrf(alfapr[kliknietonr]*180/pi(),fffixed,7,3)+'°');
      end;
      if kliknietoco=2 then
      begin
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(6.4*rozmiar[1]*screen.pixelsperinch/96),'Siła '+inttostr(kliknietonr));
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(4.8*rozmiar[1]*screen.pixelsperinch/96),'P= '+floattostrf(P[kliknietonr],fffixed,7,3)+'kN');
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(3.2*rozmiar[1]*screen.pixelsperinch/96),'x= '+floattostrf(xp[kliknietonr],fffixed,7,3));
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(1.6*rozmiar[1]*screen.pixelsperinch/96),'α= '+floattostrf(alfapr[kliknietonr]*180/pi(),fffixed,7,3)+'°');
        mybitmap.canvas.textout(Xmysz,Ymysz-15,'Pręt '+inttostr(np[kliknietonr]));
      end;
      if kliknietoco=3 then
      begin
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(9.6*rozmiar[1]*screen.pixelsperinch/96),'Obc. ciągłe '+inttostr(kliknietonr));
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(8.0*rozmiar[1]*screen.pixelsperinch/96),'qp= '+floattostrf(Pqi[kliknietonr],fffixed,7,3)+'kN/m');
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(6.4*rozmiar[1]*screen.pixelsperinch/96),'xp= '+floattostrf(xqi[kliknietonr],fffixed,7,3));
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(4.8*rozmiar[1]*screen.pixelsperinch/96),'qk= '+floattostrf(Pqj[kliknietonr],fffixed,7,3)+'kN/m');
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(3.2*rozmiar[1]*screen.pixelsperinch/96),'xk= '+floattostrf(xqj[kliknietonr],fffixed,7,3));
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(1.6*rozmiar[1]*screen.pixelsperinch/96),'α= '+floattostrf(alfapr[kliknietonr]*180/pi(),fffixed,7,3)+'°');
        mybitmap.canvas.textout(Xmysz,Ymysz-15,'Pręt '+inttostr(nq[kliknietonr]));
      end;
      if kliknietoco=4 then
      begin
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(4.8*rozmiar[1]*screen.pixelsperinch/96),'Moment '+inttostr(kliknietonr));
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(3.2*rozmiar[1]*screen.pixelsperinch/96),'M= '+floattostrf(Pm[kliknietonr],fffixed,7,3)+'kNm');
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(1.6*rozmiar[1]*screen.pixelsperinch/96),'x= '+floattostrf(xm[kliknietonr],fffixed,7,3));
        mybitmap.canvas.textout(Xmysz,Ymysz-15,'Pręt '+inttostr(nm[kliknietonr]));
      end;
      if kliknietoco=5 then
      begin
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(4.8*rozmiar[1]*screen.pixelsperinch/96),'Temperatura '+inttostr(kliknietonr));
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(3.2*rozmiar[1]*screen.pixelsperinch/96),'Tg= '+floattostrf(tg[kliknietonr],fffixed,7,3)+'K');
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(1.6*rozmiar[1]*screen.pixelsperinch/96),'Td= '+floattostrf(td[kliknietonr],fffixed,7,3)+'K');
        mybitmap.canvas.textout(Xmysz,Ymysz-15,'Pręt '+inttostr(nt[kliknietonr]));
      end;
      if kliknietoco=6 then
      begin
        oo:=0;
        for i:=1 to Lwar do if s[i]=kliknietonr then begin
          if KM[i]<>0 then begin mybitmap.canvas.TextOut(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'kφ= '+floattostrf(KM[i],fffixed,7,3)+'kNm/rad'); inc(oo) end;
          if KH[i]<>0 then begin mybitmap.canvas.TextOut(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'kx= '+floattostrf(KH[i],fffixed,7,3)+'kN/m'); inc(oo) end;
          if KV[i]<>0 then begin mybitmap.canvas.TextOut(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'ky= '+floattostrf(KV[i],fffixed,7,3)+'kN/m'); inc(oo) end;
          if DM[i]<>0 then begin mybitmap.canvas.TextOut(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'φ= '+floattostrf(DM[i]*180/pi(),fffixed,7,3)+'°'); inc(oo) end;
          if DH[i]<>0 then begin mybitmap.canvas.TextOut(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'Δx= '+floattostrf(DH[i],fffixed,7,3)+'m'); inc(oo) end;
          if DV[i]<>0 then begin mybitmap.canvas.TextOut(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'Δy= '+floattostrf(DV[i],fffixed,7,3)+'m'); inc(oo) end;
          mybitmap.canvas.TextOut(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'α= '+floattostrf(fipod[i],fffixed,7,3)+'°'); inc(oo);
          mybitmap.canvas.textout(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'Podpora '+inttostr(i)); inc(oo);
          inc(oo);
        end;
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'y= '+floattostrf(Yw[kliknietonr],fffixed,7,3)+'m'); inc(oo);
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'x= '+floattostrf(Xw[kliknietonr],fffixed,7,3)+'m'); inc(oo);
        mybitmap.canvas.textout(Xmysz,Ymysz-15-round(oo*1.6*rozmiar[1]*screen.pixelsperinch/96),'Węzeł '+inttostr(kliknietonr));
      end;
    end;
  Canvas.Draw(0, 0, MyBitmap);
  finally
    mybitmap.Free;
  end;
end;

procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    shape1.brush.Color:=clblack;
end;

procedure TForm1.Shape1MouseEnter(Sender: TObject);
begin
  shape1.brush.Color:=clblue;
end;

procedure TForm1.Shape1MouseLeave(Sender: TObject);
begin
  shape1.brush.color:=clwhite;
end;

procedure TForm1.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 shape1.brush.Color:=clblue;
end;

procedure TForm1.tbkreatorkratownicaClick(Sender: TObject);
begin
  if okienko=0 then form16.show;
end;

procedure TForm1.tbkreatorrusztClick(Sender: TObject);
begin
  if okienko=0 then form14.show;
end;

procedure TForm1.tbmenwariantowClick(Sender: TObject);
begin
  if okienko=0 then Form15.show;
end;

procedure TForm1.tbobrotClick(Sender: TObject);
begin
  if (tryb=13) or (tryb=14) then tryb:=10;
  if (tryb=0) and (okienko=0) and (Le>0) then begin tryb:=13;TBObrot.down:=true;  label13.caption:='Obrót - punkt początkowy'; end;
  if tryb=10 then begin TBObrot.down:=false; tryb:=0; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; label13.caption:='';label14.caption:=''; end;
  rysuj;
end;

procedure TForm1.tboprogramieClick(Sender: TObject);
begin
  k:=2; form17.show;
end;

procedure Tform1.koniecrysowania;                  //obliczenia po skonczeniu trybu rysowania
var uu:integer;
begin
  for uu:=1 to Le do
   begin
     Lx[uu]:=Xw[Wk[uu]]-Xw[Wp[uu]];
     Ly[uu]:=Yw[Wk[uu]]-Yw[Wp[uu]];
     L[uu]:=sqrt(sqr(Lx[uu])+sqr(Ly[uu]));
     if Lx[uu]=0 then begin if Ly[uu]=0 then alfapr[uu]:=0 else alfapr[uu]:=pi()/2*abs(Ly[uu])/Ly[uu] end else alfapr[uu]:=arctan(Ly[uu]/Lx[uu]);
     if Lx[uu]<0 then alfapr[uu]:=alfapr[uu]+pi();
   end;
end;

procedure tform1.sprawdzwezly;                      //sprawdzanie czy wezly po kopiowaniu itd sie pokrywaja
var uu:integer;
begin
  if Lw>1 then begin
  i:=0;
  repeat
    inc(i);
    j:=i;
    repeat
      inc(j);
      if (trunc(Xw[i]*1000000+0.5)=trunc(Xw[j]*1000000+0.5)) and (trunc(Yw[i]*1000000+0.5)=trunc(Yw[j]*1000000+0.5)) then
      begin
        if Lwar>0 then begin
        k:=0;
        repeat
          inc(k);
          if s[k]=j then begin for x:=k to Lwar do begin s[x]:=s[x+1]; Rpod[x]:=Rpod[x+1]; DV[x]:=DV[x+1]; KV[x]:=KV[x+1]; DH[x]:=DH[x+1]; KH[x]:=KH[x+1]; DM[x]:=DM[x+1]; KM[x]:=KM[x+1]; fipod[x]:=fipod[x+1]; for uu:=0 to warianty do wariantpod[x,uu]:=wariantpod[x+1,uu]; end; Lwar:=Lwar-1; k:=k-1; end;
        until (k=Lwar);
        PreLwar:=Lwar; end;
        for k:=j to Lw do begin Xw[k]:=Xw[k+1]; Yw[k]:=Yw[k+1]; end;
        for k:=1 to Le do begin if Wp[k]=j then Wp[k]:=i; if Wp[k]>=j then Wp[k]:=Wp[k]-1; end;
        for k:=1 to Le do begin if Wk[k]=j then Wk[k]:=i; if Wk[k]>=j then Wk[k]:=Wk[k]-1; end;
        for k:=1 to Lwar do if s[k]>=j then s[k]:=s[k]-1;
        Lw:=Lw-1; j:=j-1;
      end;
    until (j>=Lw);
  until (i>=Lw);
  end;
  for i:=1 to Lw do begin Xw[i]:=trunc(Xw[i]*10000000+0.5)/10000000; Yw[i]:=trunc(Yw[i]*10000000+0.5)/10000000 end;
end;

procedure TForm1.TBRysujpretClick(Sender: TObject);
begin
  if tryb=1 then begin if jedenpunkt=1 then Le:=Le-1; jedenpunkt:=0; tryb:=10; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; label13.caption:=''; label14.caption:=''; koniecrysowania; zapiszwstecz; rysuj; end;
  if (tryb=0) and (okienko=0) then begin rysuj; TBRysujpret.down:=true; tryb:=1; label13.caption:='Tryb Rysowania';  for i:=1 to Le do zaznaczonypret[i]:=false; for i:=1 to Lw do zaznaczonywezel[i]:=false; end;
  if tryb=10 then begin tryb:=0; TBRysujpret.down:=false; end;
end;

procedure TForm1.TBTyppreta1Click(Sender: TObject);                         //pret typs 1
begin
  for i:=1 to Le do if zaznaczonypret[i]=true then typs[i]:=1; zapiszwstecz; rysuj;
end;

procedure TForm1.TBTyppreta2Click(Sender: TObject);                         //pret typs 2   (przegub na poczatku)
begin
  for i:=1 to Le do if zaznaczonypret[i]=true then typs[i]:=2; zapiszwstecz; rysuj;
end;

procedure TForm1.TBTyppreta3Click(Sender: TObject);
begin
  for i:=1 to Le do if zaznaczonypret[i]=true then typs[i]:=3; zapiszwstecz; rysuj;         //pret typs 3 (przegub na koncu)
end;

procedure TForm1.TBTyppreta4Click(Sender: TObject);
begin
  for i:=1 to Le do if zaznaczonypret[i]=true then typs[i]:=4; zapiszwstecz; rysuj;          //pret typs 4 (kratowy)
end;

procedure TForm1.TBPodporaClick(Sender: TObject);
begin
  if (sender=menuitem7) or (sender=tbutwierdzenie) or (sender=mbutwierdzenie) then rodzajpodpory:=1;
  if (sender=menuitem8) or (sender=tbutwprzesuw) or (sender=mbutwprzesuw) then rodzajpodpory:=2;
  if (sender=menuitem9) or (sender=tbwolnapodpora) or (sender=mbwolnapodpora) then rodzajpodpory:=3;
  if (sender=menuitem10) or (sender=tbprzesuw) or (sender=mbprzesuw) then rodzajpodpory:=4;
  if (sender=menuitem11) or (sender=tbblokadaobrotu) or (sender=tbblokadaobrotu) then rodzajpodpory:=5;
  if (tryb=0) and (okienko=0) then begin
  for i:=1 to warianty do formwariant[i]:=false;
  k:=0;
  for i:=1 to Lw do begin if zaznaczonywezel[i]=true then k:=k+1; end;
  if k>0 then begin form6.Show; form6open:=true; okienko:=1;  rysuj end;
  end;
end;

procedure TForm1.tbpomocClick(Sender: TObject);
begin
  //pomoc
end;

procedure TForm1.TBUsunobcClick(Sender: TObject);
var gg:boolean;
begin
 if (tryb=0) and (okienko=0) then begin
 gg:=false;
 if Lw>0 then                //usuwanie wezlow
   begin
     i:=0;
     repeat inc(i);
     if zaznaczonywezel[i]=true then
     begin                                          //podpory
       if Lwar>0 then begin
       k:=0;
       repeat
         inc(k);
         if s[k]=i then begin for x:=k to Lwar do begin DH[x]:=0; DV[x]:=0; DM[x]:=0; KH[x]:=0; KV[x]:=0; KM[x]:=0; end; end;
       until k=Lwar;
       PreLwar:=Lwar; gg:=true; end;
     end;
     until i=Lw;
   end;
 if RowsPp>0 then                    //usuwanie sil
   begin
     i:=0;
     repeat
       begin
         inc(i);
         if zaznaczoneP[i]=true then
           begin for x:=i to RowsPp do begin P[x]:=P[x+1]; xp[x]:=xp[x+1]; np[x]:=np[x+1]; alfap[x]:=alfap[x+1]; zaznaczoneP[x]:=zaznaczoneP[x+1]; end; i:=i-1; RowsPp:=RowsPp-1;  gg:=true; end;
       end;
     until i=RowsPp;
     PreRowsPp:=RowsPp;
   end;
 if RowsPm>0 then                 //usuwanie momentow
   begin
     i:=0;
     repeat
       begin
         inc(i);
         if zaznaczoneM[i]=true then
           begin for x:=i to RowsPM do begin Pm[x]:=Pm[x+1]; xm[x]:=xm[x+1]; nm[x]:=nm[x+1]; zaznaczoneM[x]:=zaznaczoneM[x+1]; end; i:=i-1; RowsPm:=RowsPm-1;  gg:=true;  end;
       end;
     until i=RowsPm;
     PreRowsPm:=RowsPm;
   end;
 if RowsPt>0 then                   //usuwanie temperatur
   begin
     i:=0;
     repeat
       begin
         inc(i);
         if zaznaczoneT[i]=true then
           begin for x:=i to RowsPt do begin Tg[x]:=Tg[x+1]; Td[x]:=Td[x+1]; nt[x]:=nt[x+1]; zaznaczoneT[x]:=zaznaczoneT[x+1]; end; i:=i-1; RowsPt:=RowsPt-1;  gg:=true; end;
       end;
     until i=RowsPt;
     PreRowsPt:=RowsPt;
   end;
 if RowsPq>0 then                     //usuwanie rozlozonego
   begin
     i:=0;
     repeat
       begin
         inc(i);
         if zaznaczoneQ[i]=true then
           begin for x:=i to RowsPq do begin Pqi[x]:=Pqi[x+1]; Pqj[x]:=Pqj[x+1]; xqi[x]:=xqi[x+1]; xqj[x]:=xqj[x+1]; nq[x]:=nq[x+1]; alfaq[x]:=alfaq[x+1]; zaznaczoneQ[x]:=zaznaczoneQ[x+1]; end; i:=i-1; RowsPq:=RowsPq-1;  gg:=true;  end;
       end;
     until i=RowsPq;
     PreRowsPq:=RowsPq;
   end;
   koniecrysowania;
   if gg=true then zapiszwstecz;
   rysuj;
   end;
end;

procedure TForm1.TBWyjscieClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.TBZaznaczwszystkoClick(Sender: TObject);
begin
 for i:=1 to Le do zaznaczonypret[i]:=true;
 for i:=1 to Lw do zaznaczonywezel[i]:=true;
 for i:=1 to RowsPp do zaznaczoneP[i]:=true;
 for i:=1 to RowsPq do zaznaczoneQ[i]:=true;
 for i:=1 to RowsPm do zaznaczoneM[i]:=true;
 for i:=1 to RowsPt do zaznaczoneT[i]:=true;
 rysuj;
end;

procedure TForm1.tbzdjecieClick(Sender: TObject);
begin
 if (tryb=0) or (tryb=46) or (tryb=47) then begin
 label13.caption:='Zrób zdjęcie';
 if (tryb2=2) or (tryb2=3) then begin tryb2:=10; TBzdjecie.Down:=false;TBzdjecie1.Down:=false; end;
 if tryb2=0 then begin tryb2:=2; TBzdjecie.Down:=true;TBzdjecie1.Down:=true; end;
 if tryb2=10 then begin tryb2:=0; label13.caption:=''; end;
 rysuj;
 end;
end;

procedure TForm1.TBzoomclick(Sender: TObject);
begin
 if (tryb=0) or (tryb=46) or (tryb=47) then begin
 label13.caption:='Zoom';
 if (tryb2=4) or (tryb2=5) then begin tryb2:=10; tbzoom.Down:=false;tbzoom1.Down:=false; end;
 if tryb2=0 then begin tryb2:=4; tbzoom.Down:=true;tbzoom1.Down:=true; end;
 if tryb2=10 then begin tryb2:=0; label13.caption:=''; end;
 rysuj;
 end;
end;

procedure TForm1.tbmenprojektuClick(Sender: TObject);
begin
 form11.Show;
end;

procedure tform1.trackbarzmiana;
var gg,mnoznik:integer;
     EJ,EJN:real;
begin
  if edit1.Focused=false then edit1.Text:=floattostr(trackbar2.Position/1000);
  xwybranypret:=trackbar2.position/1000;
  gg:=0;
  EJ:=1;
  EJN:=1;
  if checkbox2.checked=true then EJ:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ji[combobox1.Items.IndexOf(combobox2.text)+1];
  if checkbox3.checked=true then EJ:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ai[combobox1.Items.IndexOf(combobox2.text)+1];
  if checkbox4.checked=true then EJ:=1/ati[combobox1.Items.IndexOf(combobox2.text)+1];
  if checkbox5.checked=true then EJN:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ji[combobox1.Items.IndexOf(combobox2.text)+1];
  if checkbox6.checked=true then EJN:=Ei[combobox1.Items.IndexOf(combobox2.text)+1]*Ai[combobox1.Items.IndexOf(combobox2.text)+1];
  repeat
  inc(gg);
  until wsp[wybranypret,gg+1,tenwariant]>=xwybranypret;
  if radiobutton5.checked=true then mnoznik:=1000 else mnoznik:=1;
  if (xwybranypret<1) then
  begin
    edit2.text:=floattostrf((N[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(N[wybranypret,gg+1,tenwariant]-N[wybranypret,gg,tenwariant]))/EJN,fffixed,9,5);
    edit3.text:=floattostrf((T[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(T[wybranypret,gg+1,tenwariant]-T[wybranypret,gg,tenwariant]))/EJN,fffixed,9,5);
    edit4.text:=floattostrf((M[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(M[wybranypret,gg+1,tenwariant]-M[wybranypret,gg,tenwariant]))/EJN,fffixed,9,5);
    if radiobutton3.Checked=true then begin
     edit5.text:=floattostrf((vN[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(vN[wybranypret,gg+1,tenwariant]-vN[wybranypret,gg,tenwariant]))*mnoznik*EJ,fffixed,9,5);
     edit6.text:=floattostrf((v[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(v[wybranypret,gg+1,tenwariant]-v[wybranypret,gg,tenwariant]))*mnoznik*EJ,fffixed,9,5);
     end else begin
     edit5.text:=floattostrf((ux[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(ux[wybranypret,gg+1,tenwariant]-ux[wybranypret,gg,tenwariant]))*mnoznik*EJ,fffixed,9,5);
     edit6.text:=floattostrf((uy[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(uy[wybranypret,gg+1,tenwariant]-uy[wybranypret,gg,tenwariant]))*mnoznik*EJ,fffixed,9,5);
    end;
    if radiobutton1.Checked=true then edit7.text:=floattostrf((fi[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(fi[wybranypret,gg+1,tenwariant]-fi[wybranypret,gg,tenwariant]))*180/pi()*EJ,fffixed,9,5)
    else edit7.text:=floattostrf((fi[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(fi[wybranypret,gg+1,tenwariant]-fi[wybranypret,gg,tenwariant]))*EJ,fffixed,9,5);
    edit8.text:=floattostrf((napr1[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(napr1[wybranypret,gg+1,tenwariant]-napr1[wybranypret,gg,tenwariant])),fffixed,9,5);
    edit9.text:=floattostrf((napr2[wybranypret,gg,tenwariant]+(xwybranypret-wsp[wybranypret,gg,tenwariant])/(wsp[wybranypret,gg+1,tenwariant]-wsp[wybranypret,gg,tenwariant])*(napr2[wybranypret,gg+1,tenwariant]-napr2[wybranypret,gg,tenwariant])),fffixed,9,5);
  end else begin
    edit2.text:=floattostrf(N[wybranypret,nrx[wybranypret,tenwariant],tenwariant]/EJ,fffixed,9,5);
    edit3.text:=floattostrf(T[wybranypret,nrx[wybranypret,tenwariant],tenwariant]/EJ,fffixed,9,5);
    edit4.text:=floattostrf(M[wybranypret,nrx[wybranypret,tenwariant],tenwariant]/EJ,fffixed,9,5);
    if radiobutton3.Checked=true then begin
     edit5.text:=floattostrf(vN[wybranypret,nrx[wybranypret,tenwariant],tenwariant]*mnoznik*EJ,fffixed,9,5);
     edit6.text:=floattostrf(v[wybranypret,nrx[wybranypret,tenwariant],tenwariant]*mnoznik*EJ,fffixed,9,5);
     end else begin
     edit5.text:=floattostrf(ux[wybranypret,nrx[wybranypret,tenwariant],tenwariant]*mnoznik*EJ,fffixed,9,5);
     edit6.text:=floattostrf(uy[wybranypret,nrx[wybranypret,tenwariant],tenwariant]*mnoznik*EJ,fffixed,9,5);
    end;
    if radiobutton1.Checked=true then edit7.text:=floattostrf(fi[wybranypret,nrx[wybranypret,tenwariant],tenwariant]*180/pi()*EJ,fffixed,9,5)
    else edit7.text:=floattostrf(fi[wybranypret,nrx[wybranypret,tenwariant],tenwariant]*EJ,fffixed,9,5);
    edit8.text:=floattostrf(napr1[wybranypret,nrx[wybranypret,tenwariant],tenwariant],fffixed,9,5);
    edit9.text:=floattostrf(napr2[wybranypret,nrx[wybranypret,tenwariant],tenwariant],fffixed,9,5);
  end;
  rysuj;
end;

procedure TForm1.TBCofnijClick(Sender: TObject);
begin
  if wyswietl=0 then begin
  ilecofnij:=ilecofnij-1;pozycja:=pozycja-1; if pozycja=0 then pozycja:=10;
  inc(ileprzywroc); TBPrzywroc.Enabled:=true; mbprzywroc.enabled:=true; TBPrzywroc.ImageIndex:=9; mbprzywroc.ImageIndex:=9;
  if ilecofnij=0 then begin TBCofnij.Enabled:=false; mbcofnij.enabled:=false; TBCofnij.imageindex:=31; mbcofnij.ImageIndex:=31; end;
  assignfile(plik,'C:/temp/mtr'+czas+'_'+inttostr(pozycja)+'.tmp');
  procesotwierania;
  zmiana:=true;
  end;
end;

procedure TForm1.TBPrzywrocClick(Sender: TObject);
begin
  if wyswietl=0 then begin
  ileprzywroc:=ileprzywroc-1;pozycja:=pozycja+1; if pozycja=11 then pozycja:=1;
  inc(ilecofnij); TBCofnij.Enabled:=true; mbcofnij.enabled:=true; TBCofnij.ImageIndex:=8; mbcofnij.ImageIndex:=8;
  if ileprzywroc=0 then begin TBPrzywroc.Enabled:=false; mbprzywroc.enabled:=false; TBPrzywroc.imageindex:=32; mbprzywroc.ImageIndex:=32; end;
  assignfile(plik,'C:/temp/mtr'+czas+'_'+inttostr(pozycja)+'.tmp');
  procesotwierania;
  zmiana:=true;
  end;
end;

procedure TForm1.tbnormalneClick(Sender: TObject);
begin
  wyswietl:=1;
  tbnormalne.down:=true; tbtnace.down:=false; tbmomenty.down:=false; tbprzemieszczenia.down:=false; tbnaprezenia.down:=false;
  trackbar1.position:=trunc(sqrt(sqrt(skalawew*1000000)));
  rysuj;
end;

procedure TForm1.tbtnaceClick(Sender: TObject);
begin
  wyswietl:=2;
  tbnormalne.down:=false; tbtnace.down:=true; tbmomenty.down:=false; tbprzemieszczenia.down:=false; tbnaprezenia.down:=false;
  trackbar1.position:=trunc(sqrt(sqrt(skalawew*1000000)));
  rysuj;
end;

procedure TForm1.tbmomentyClick(Sender: TObject);
begin
  wyswietl:=3;
  tbnormalne.down:=false; tbtnace.down:=false; tbmomenty.down:=true; tbprzemieszczenia.down:=false; tbnaprezenia.down:=false;
  trackbar1.position:=trunc(sqrt(sqrt(skalawew*1000000)));
  rysuj;
end;

procedure TForm1.tbprzemieszczeniaClick(Sender: TObject);
begin
  wyswietl:=4;
  tbnormalne.down:=false; tbtnace.down:=false; tbmomenty.down:=false; tbprzemieszczenia.down:=true; tbnaprezenia.down:=false;
  trackbar1.position:=trunc(sqrt(sqrt(skaladisp*1000000)));
  rysuj;
end;

procedure TForm1.tbPowrotClick(Sender: TObject);
begin
  keyinput.Press(vk_escape);
  tenwariant:=0;label11.caption:='0';
  wyswietl:=0;
  wybranypret:=0;
  tryb:=0;
  toolbar2.visible:=false;
  toolbar1.Visible:=true;
  medycja.Enabled:=true;
  mwstaw.Enabled:=true;
  mnarzedzia.Enabled:=true;
  panel3.Visible:=false;
  tenwariant:=0;  label10.caption:='0';
  medycja.enabled:=true; mwstaw.enabled:=true;tbprzenies.enabled:=true;tbkopiuj.enabled:=true; tblustro.enabled:=true; tbobrot.enabled:=true;
    tbusun.enabled:=true;tbpodziel.enabled:=true; tbprzeciecie.enabled:=true;
    tbzaznaczwszystko.enabled:=true;tbpodpora.enabled:=true; tbutwierdzenie.enabled:=true; tbutwprzesuw.enabled:=true;
    tbwolnapodpora.enabled:=true; tbprzesuw.enabled:=true; tbblokadaobrotu.enabled:=true;
    mbrysujpret.enabled:=true;tbrysujpret.enabled:=true; mbsila.enabled:=true; tbsila.enabled:=true; mbciagle.enabled:=true;tbciagle.enabled:=true;
    mbmoment.enabled:=true;tbmoment.enabled:=true; mbtemperatura.enabled:=true; tbtemperatura.enabled:=true;
    mboblicz.enabled:=true; tboblicz.enabled:=true;mbkreator.enabled:=true; tbkreatorruszt.enabled:=true; mbkreatorkratownica.enabled:=true;  tbkreatorkratownica.enabled:=true;
    tbtyppreta1.enabled:=true; tbtyppreta2.enabled:=true; tbtyppreta3.enabled:=true; tbtyppreta4.enabled:=true;
  mwyniki.enabled:=false;
  rysuj;
  rozbijobc:=false;
  label13.caption:='';
  label14.caption:='';
end;

procedure TForm1.tbnaprezeniaClick(Sender: TObject);
begin
  wyswietl:=5;
  tbnormalne.down:=false; tbtnace.down:=false; tbmomenty.down:=false; tbprzemieszczenia.down:=false; tbnaprezenia.down:=true;
  trackbar1.position:=trunc(sqrt(sqrt(skalawew*1000000)));
  rysuj;
end;

procedure TForm1.tbreakcjeClick(Sender: TObject);
begin
 if sender = mbreakcje then if tbreakcje.down=true then tbreakcje.down:=false else tbreakcje.down:=true;
 rysuj;
end;

procedure TForm1.TBPrzeciecieClick(Sender: TObject);           //dzielenie prętów w przecięciach
begin
 if (tryb=0) and (wyswietl=0) then
 begin
  repeat
  x:=0;
  for i:=1 to Le do
   if i<Le then for j:=i+1 to Le do
    if (zaznaczonypret[i]=true) and (zaznaczonypret[j]=true) then
      //algorytm dzielenia;                       // nie działa coś, chyba te punkty wspólne na początku
      begin
        if xw[wp[i]]<>xw[wk[i]] then a1:=(yw[wp[i]]-yw[wk[i]])/(xw[wp[i]]-xw[wk[i]]) else a1:=1000000;
        if xw[wp[j]]<>xw[wk[j]] then aj:=(yw[wp[j]]-yw[wk[j]])/(xw[wp[j]]-xw[wk[j]]) else aj:=1000000;
        b1:=yw[wp[i]]-xw[wp[i]]*a1;
        bj:=yw[wp[j]]-xw[wp[j]]*aj;
        if (abs(aj-a1)>0.0001) then wspolnyx:=-(bj-b1)/(aj-a1) else wspolnyx:=10000000;
        wspolnyy:=a1*wspolnyx+b1;
        if (abs(xw[wp[i]]-xw[wk[i]])<0.0001) and (abs(xw[wp[j]]-xw[wk[j]])>0.0001) then begin wspolnyx:=xw[wp[i]]; wspolnyy:=aj*wspolnyx+bj; end;
        if (abs(xw[wp[j]]-xw[wk[j]])<0.0001) and (abs(xw[wp[i]]-xw[wk[i]])>0.0001) then begin wspolnyx:=xw[wp[j]]; wspolnyy:=a1*wspolnyx+b1; end;
        if (abs(xw[wp[j]]-xw[wk[j]])<0.0001) and (abs(xw[wp[i]]-xw[wk[i]])<0.0001) then begin wspolnyx:=100000000; wspolnyy:=10000000; end;
        if (((wspolnyx>=xw[wp[i]]) and (wspolnyx<=xw[wk[i]])) or ((wspolnyx<=xw[wp[i]]) and (wspolnyx>=xw[wk[i]]))) and (((wspolnyx>=xw[wp[j]]) and (wspolnyx<=xw[wk[j]])) or ((wspolnyx<=xw[wp[j]]) and (wspolnyx>=xw[wk[j]]))) and
           (((wspolnyy>=yw[wp[i]]) and (wspolnyy<=yw[wk[i]])) or ((wspolnyy<=yw[wp[i]]) and (wspolnyy>=yw[wk[i]]))) and (((wspolnyy>=yw[wp[j]]) and (wspolnyy<=yw[wk[j]])) or ((wspolnyy<=yw[wp[j]]) and (wspolnyy>=yw[wk[j]])))
        then begin
          if not(((abs(xw[wp[i]]-wspolnyx)<0.0001) and (abs(yw[wp[i]]-wspolnyy)<0.0001)) or ((abs(xw[wk[i]]-wspolnyx)<0.0001) and (abs(yw[wk[i]]-wspolnyy)<0.0001)) or ((abs(xw[wp[j]]-wspolnyx)<0.0001) and (abs(yw[wp[j]]-wspolnyy)<0.0001)) or ((abs(xw[wk[j]]-wspolnyx)<0.0001) and (abs(yw[wk[j]]-wspolnyy)<0.0001))) then
           begin
            Xw[Lw+1]:=wspolnyx;
            Yw[Lw+1]:=wspolnyy;
            Wp[Le+1]:=Lw+1;
            Wp[Le+2]:=Lw+1;
            Wk[Le+1]:=Wk[i];
            Wk[Le+2]:=Wk[j];
            Le:=Le+2;
            Wk[i]:=Lw+1;
            Wk[j]:=Lw+1;
            Lw:=Lw+1;
            typs[Le-1]:=1;typs[Le]:=1;Prz[Le-1]:=Prz[i];Prz[Le]:=Prz[j];
            if typs[i]=3 then begin typs[i]:=1; typs[Le-1]:=3; end;
            if typs[i]=4 then begin typs[i]:=2; typs[Le-1]:=3; end;
            if typs[j]=3 then begin typs[j]:=1; typs[Le]:=3; end;
            if typs[j]=4 then begin typs[j]:=2; typs[Le]:=3; end;
            zaznaczonypret[Le-1]:=true;zaznaczonypret[Le]:=true; x:=1; koniecrysowania;
          end;
         if (x=0) and (abs(xw[wp[i]]-wspolnyx)<0.0001) and (abs(yw[wp[i]]-wspolnyy)<0.0001) and ((abs(xw[wp[j]]-wspolnyx)>0.0001) or (abs(yw[wp[j]]-wspolnyy)>0.0001)) and ((abs(xw[wk[j]]-wspolnyx)>0.0001) or (abs(yw[wk[j]]-wspolnyy)>0.0001)) then
         begin
           Wk[Le+1]:=Wk[j];Wk[j]:=Wp[i];Wp[Le+1]:=Wp[i]; Le:=Le+1; Prz[Le]:=Prz[j]; typs[Le]:=1;
           if typs[j]=3 then begin typs[j]:=1; typs[Le]:=3; end;
           if typs[j]=4 then begin typs[j]:=2; typs[Le]:=3; end;
           zaznaczonypret[Le]:=true;   x:=1; koniecrysowania;
         end;
         if (x=0) and (abs(xw[wk[i]]-wspolnyx)<0.0001) and (abs(yw[wk[i]]-wspolnyy)<0.0001) and ((abs(xw[wp[j]]-wspolnyx)>0.0001) or (abs(yw[wp[j]]-wspolnyy)>0.0001)) and ((abs(xw[wk[j]]-wspolnyx)>0.0001) or (abs(yw[wk[j]]-wspolnyy)>0.0001)) then
         begin
           Wk[Le+1]:=Wk[j];Wk[j]:=Wk[i];Wp[Le+1]:=Wk[i]; Le:=Le+1; Prz[Le]:=Prz[j]; typs[Le]:=1;
           if typs[j]=3 then begin typs[j]:=1; typs[Le]:=3; end;
           if typs[j]=4 then begin typs[j]:=2; typs[Le]:=3; end;
           zaznaczonypret[Le]:=true;   x:=1; koniecrysowania;
         end;
         if (x=0) and (abs(xw[wp[j]]-wspolnyx)<0.0001) and (abs(yw[wp[j]]-wspolnyy)<0.0001) and ((abs(xw[wp[i]]-wspolnyx)>0.0001) or (abs(yw[wp[i]]-wspolnyy)>0.0001)) and ((abs(xw[wk[i]]-wspolnyx)>0.0001) or (abs(yw[wk[i]]-wspolnyy)>0.0001)) then
         begin
           Wk[Le+1]:=Wk[i];Wk[i]:=Wp[j];Wp[Le+1]:=Wp[j]; Le:=Le+1; Prz[Le]:=Prz[i]; typs[Le]:=1;
           if typs[i]=3 then begin typs[i]:=1; typs[Le]:=3; end;
           if typs[i]=4 then begin typs[i]:=2; typs[Le]:=3; end;
           zaznaczonypret[Le]:=true;   x:=1; koniecrysowania;
         end;
         if (x=0) and (abs(xw[wk[j]]-wspolnyx)<0.0001) and (abs(yw[wk[j]]-wspolnyy)<0.0001) and ((abs(xw[wp[i]]-wspolnyx)>0.0001) or (abs(yw[wp[i]]-wspolnyy)>0.0001)) and ((abs(xw[wk[i]]-wspolnyx)>0.0001) or (abs(yw[wk[i]]-wspolnyy)>0.0001)) then
         begin
           Wk[Le+1]:=Wk[i];Wk[i]:=Wk[j];Wp[Le+1]:=Wk[j]; Le:=Le+1; Prz[Le]:=Prz[i]; typs[Le]:=1;
           if typs[i]=3 then begin typs[i]:=1; typs[Le]:=3; end;
           if typs[i]=4 then begin typs[i]:=2; typs[Le]:=3; end;
           zaznaczonypret[Le]:=true;   x:=1; koniecrysowania;
         end;
        end;
      end;
  until (x=0);
  zapiszwstecz;
  rysuj;
 end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if czasowe=true then trackbarzmiana;
  czasowe:=false;
end;

procedure TForm1.ToolButton33Click(Sender: TObject);
begin

end;

procedure TForm1.TBPoprzWariantClick(Sender: TObject);
begin
  if tenwariant>0 then tenwariant:=tenwariant-1;
  label10.caption:=inttostr(tenwariant);
  label11.caption:=inttostr(tenwariant);
  if wybranypret>0 then if trackbar2.position=1000 then begin trackbar2.position:=trackbar2.position-1; trackbar2.position:=trackbar2.position+1 end
  else begin trackbar2.position:=trackbar2.position+1; trackbar2.position:=trackbar2.position-1 end;
  rysuj;
end;

procedure TForm1.TBNastWariantClick(Sender: TObject);
var bufor:integer;
begin
  if wyswietl>0 then bufor:=warianty1 else bufor:=warianty;
  if tenwariant<bufor then tenwariant:=tenwariant+1;
  if wybranypret>0 then if trackbar2.position=1000 then begin trackbar2.position:=trackbar2.position-1; trackbar2.position:=trackbar2.position+1 end
    else begin trackbar2.position:=trackbar2.position+1; trackbar2.position:=trackbar2.position-1 end;
  label10.caption:=inttostr(tenwariant);
  label11.caption:=inttostr(tenwariant);
  rysuj;
end;

procedure TForm1.TBNowyClick(Sender: TObject);
begin
  if zmiana=true then
  case QuestionDlg ('Materia '+wersja,'Czy chcesz zapisać zmiany w pliku '+extractfilename(savedialog1.FileName)+'?',mtConfirmation,[mrYes,'Tak', mrNo, 'Nie', mrCancel, 'Anuluj'],'') of
      mrYes: begin tbzapisz.click;odnowa;end;
      mrCancel:;
      mrNo:odnowa;
  end
  else odnowa;
end;

procedure TForm1.TBOtworzClick(Sender: TObject);
begin
  if zmiana=true then
  case QuestionDlg ('Materia '+wersja,'Czy chcesz zapisać zmiany w pliku '+extractfilename(savedialog1.FileName)+'?',mtConfirmation,[mrYes,'Tak', mrNo, 'Nie', mrCancel, 'Anuluj'],'') of
      mrYes: begin tbZapisz.Click;otworz2;end;
      mrCancel:;
      mrNo:otworz2;
  end
  else otworz2;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  if wyswietl=4 then skaladisp:=trackbar1.Position*trackbar1.Position*trackbar1.Position*trackbar1.Position/1000000 else skalawew:=trackbar1.Position*trackbar1.Position*trackbar1.Position*trackbar1.Position/1000000;
  rysuj;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  czasowe:=true;
end;

procedure TForm1.wariantclick(Sender: TObject);
var menuitem:tmenuitem;
begin
  tenwariant:=(sender as tmenuitem).tag;
  label10.caption:=inttostr(tenwariant);
  label11.caption:=inttostr(tenwariant);
  if wybranypret>0 then if trackbar2.position=1000 then begin trackbar2.position:=trackbar2.position-1; trackbar2.position:=trackbar2.position+1 end
    else begin trackbar2.position:=trackbar2.position+1; trackbar2.position:=trackbar2.position-1 end;
end;

procedure TForm1.StatusBar1DrawPanel;
var ile:integer;
begin
  if bar[1]=true then ImageList1.GetBitmap(58,Image1.Picture.Bitmap) else ImageList1.GetBitmap(59,Image1.Picture.Bitmap);   
  if bar[2]=true then ImageList1.GetBitmap(60,Image2.Picture.Bitmap) else ImageList1.GetBitmap(61,Image2.Picture.Bitmap);
  if bar[3]=true then ImageList1.GetBitmap(62,Image3.Picture.Bitmap) else ImageList1.GetBitmap(63,Image3.Picture.Bitmap);
  if bar[4]=true then ImageList1.GetBitmap(64,Image4.Picture.Bitmap) else ImageList1.GetBitmap(65,Image4.Picture.Bitmap);
end;

procedure TForm1.StatusBar1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.TBSilaClick(Sender: TObject);
begin
  if (tryb=0) and (okienko=0) then begin
  for i:=1 to warianty do formwariant[i]:=false;
  k:=0;
  for i:=1 to Le do begin if zaznaczonypret[i]=true then k:=k+1; end;
  if k>0 then begin form2.Show; form2open:=true; okienko:=1; rysuj; end;
  end;
end;

procedure TForm1.TBCiagleClick(Sender: TObject);
begin
  if (tryb=0) and (okienko=0) then begin
  for i:=1 to warianty do formwariant[i]:=false;
  k:=0;
  for i:=1 to Le do begin if zaznaczonypret[i]=true then k:=k+1; end;
  if k>0 then begin form3.Show; form3open:=true; okienko:=1; rysuj; end;
  end;
end;

procedure TForm1.TBMomentClick(Sender: TObject);
begin
  if (tryb=0) and (okienko=0) then begin
  for i:=1 to warianty do formwariant[i]:=false;
  k:=0;
  for i:=1 to Le do begin if zaznaczonypret[i]=true then k:=k+1; end;
  if k>0 then begin form4.Show; form4open:=true; okienko:=1; rysuj; end;
  end;
end;

procedure TForm1.TBTemperaturaClick(Sender: TObject);
begin
  if (tryb=0) and (okienko=0) then begin
  for i:=1 to warianty do formwariant[i]:=false;
  k:=0;
  for i:=1 to Le do begin if zaznaczonypret[i]=true then k:=k+1; end;
  if k>0 then begin form5.Show; form5open:=true; okienko:=1;  rysuj; end;
  end;
end;

procedure TForm1.TBPrzeniesClick(Sender: TObject);
begin
 if (tryb=5) or (tryb=6) then tryb:=10;
 if (tryb=0) and (okienko=0) and (Le>0) then begin TBPrzenies.down:=true; tryb:=5; label13.caption:='Przenoszenie - punkt początkowy'; end;
 if tryb=10 then begin TBPrzenies.down:=false; tryb:=0; label13.caption:=''; label14.caption:='';polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; end;
 rysuj;
end;

procedure TForm1.TBKopiujClick(Sender: TObject);
begin
 if (tryb=7) or (tryb=8) then tryb:=10;   //kopiowanie
 if (tryb=0) and (okienko=0) and (Le>0) then begin TBKopiuj.down:=true; tryb:=7; label13.caption:='Kopiowanie - punkt początkowy'; end;
 if tryb=10 then begin tryb:=0; TBKopiuj.down:=false; koniecrysowania; zapiszwstecz; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; label13.caption:='';label14.caption:=''; end;
 rysuj;
end;

procedure TForm1.TBLustroClick(Sender: TObject);
begin
 if (tryb=11) or (tryb=12) then tryb:=10;
 if (tryb=0) and (okienko=0) and (Le>0) then begin tryb:=11;TBLustro.down:=true;  label13.caption:='Lustro - punkt początkowy'; end;
 if tryb=10 then begin TBLustro.down:=false; tryb:=0; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0; label13.caption:='';label14.caption:=''; end;
 rysuj;
end;

procedure TForm1.TBPodzielClick(Sender: TObject);
begin
 if (tryb=0) and (okienko=0) then begin
 k:=0;
 for i:=1 to Le do begin if zaznaczonypret[i]=true then k:=k+1; end;
 if k>0 then begin if form7podz<1 then form7podz:=1; form7.Show; form7open:=true; okienko:=1; rysuj; end;
 end;
end;

procedure TForm1.TBPodgladClick(Sender: TObject);
begin
 if (tryb=0) or (tryb=46) or (tryb=47) then begin
 label13.caption:='Tryb Podglądu';
 if tryb2=1 then begin tryb2:=10; screen.cursor:=crdefault;TBPodglad.Down:=false;TBPodglad1.Down:=false; end;
 if tryb2=0 then begin tryb2:=1; screen.Cursor:=crhelp; TBPodglad.Down:=true;TBPodglad1.Down:=true; end;
 if tryb2=10 then begin tryb2:=0; label13.caption:=''; end;
 rysuj;
 end;
end;

procedure TForm1.TBZapiszjakoClick(Sender: TObject);
begin
 tak:=false;
 saveDialog1.Title := 'Zapisz';
 saveDialog1.InitialDir := GetCurrentDir;
 saveDialog1.Filter := 'Materia file|*.mtr';
 saveDialog1.DefaultExt := 'mtr';
 opendialog1.filename:=savedialog1.filename;
 if SaveDialog1.Execute then tak:=true;
 assignfile(plik,UTF8ToAnsi(savedialog1.filename));
 if tak=true then zapiszjako else savedialog1.filename:=opendialog1.filename;
end;

procedure TForm1.TBUstawieniaClick(Sender: TObject);
begin
  Form12.show;
end;

procedure TForm1.TBUsunClick(Sender: TObject);
var gg:boolean;
begin
  if (tryb=0) and (okienko=0) then begin
gg:=false;
if Le>0 then      //usuwanie pretow
  begin
    if rowsPp>0 then                   //sily
    begin
      i:=0;
      repeat
        begin
          inc(i);
          if zaznaczonypret[np[i]]=true then
            begin for x:=i to RowsPp do begin P[x]:=P[x+1]; xp[x]:=xp[x+1]; np[x]:=np[x+1]; alfap[x]:=alfap[x+1]; zaznaczoneP[x]:=zaznaczoneP[x+1]; end; i:=i-1; RowsPp:=RowsPp-1; gg:=true; end;
        end;
      until i=RowsPp;
      PreRowsPp:=RowsPp;
    end;
    if rowsPm>0 then                 //momenty
    begin
      i:=0;
      repeat
        begin
          inc(i);
          if zaznaczonypret[nm[i]]=true then
            begin for x:=i to RowsPm do begin Pm[x]:=Pm[x+1]; xm[x]:=xm[x+1]; nm[x]:=nm[x+1]; zaznaczoneM[x]:=zaznaczoneM[x+1]; end; i:=i-1; RowsPm:=RowsPm-1; gg:=true; end;
        end;
      until i=RowsPm;
      PreRowsPm:=RowsPm;
    end;
    if rowsPt>0 then                    //temperatura
    begin
      i:=0;
      repeat
        begin
          inc(i);
          if zaznaczonypret[nt[i]]=true then
            begin for x:=i to RowsPt do begin Tg[x]:=Tg[x+1]; Td[x]:=Td[x+1]; nt[x]:=nt[x+1]; zaznaczoneT[x]:=zaznaczoneT[x+1]; end; i:=i-1; RowsPt:=RowsPt-1; gg:=true; end;
        end;
      until i=RowsPt;
      PreRowsPt:=RowsPt;
    end;
    if rowsPq>0 then                //rozlozone
    begin
      i:=0;
      repeat
        begin
          inc(i);
          if zaznaczonypret[nq[i]]=true then
            begin for x:=i to RowsPq do begin Pqi[x]:=Pqi[x+1]; Pqj[x]:=Pqj[x+1]; xqi[x]:=xqi[x+1]; xqj[x]:=xqj[x+1]; nq[x]:=nq[x+1]; alfaq[x]:=alfaq[x+1]; zaznaczoneQ[x]:=zaznaczoneQ[x+1]; end; i:=i-1; RowsPq:=RowsPq-1; gg:=true;end;
        end;
      until i=RowsPq;
      PreRowsPq:=RowsPq;
    end;
    i:=0;                                     //prety
    repeat
      begin
        inc(i);
        if zaznaczonypret[i]=true then
          begin
           for x:=i to Le do begin Wp[x]:=Wp[x+1]; Wk[x]:=Wk[x+1]; typs[x]:=typs[x+1]; Prz[x]:=Prz[x+1]; zaznaczonypret[x]:=zaznaczonypret[x+1]; end;
           if RowsPp>0 then for x:=1 to RowsPp do if np[x]>i then np[x]:=np[x]-1;
           if RowsPq>0 then for x:=1 to RowsPq do if nq[x]>i then nq[x]:=nq[x]-1;
           if RowsPm>0 then for x:=1 to RowsPm do if nm[x]>i then nm[x]:=nm[x]-1;
           if RowsPt>0 then for x:=1 to RowsPt do if nt[x]>i then nt[x]:=nt[x]-1;
           i:=i-1; Le:=Le-1; gg:=true;
          end;
      end;
    until i=Le;
  end;
if Lw>0 then                //usuwanie wezlow
  begin
    i:=0;
    repeat inc(i);
    if zaznaczonywezel[i]=true then
    begin                                          //podpory
      if Lwar>0 then begin
      k:=0;
      repeat
        inc(k);
        if s[k]=i then begin for x:=k to Lwar do begin s[x]:=s[x+1]; rpod[x]:=rpod[x+1]; DH[x]:=DH[x+1]; DV[x]:=DV[x+1]; DM[x]:=DM[x+1]; KH[x]:=KH[x+1]; KV[x]:=KV[x+1]; KM[x]:=KM[x+1]; fipod[x]:=fipod[x+1]; end; k:=k-1; Lwar:=Lwar-1; end;
      until k=Lwar;
      PreLwar:=Lwar; gg:=true; end;                               //wezly
      k:=0;
      begin
        for j:=1 to Le do if Wp[j]<>i then inc(k);
        for j:=1 to Le do if Wk[j]<>i then inc(k);
        if k=Le*2 then
          begin
            for j:=i to Lw do begin Xw[j]:=Xw[j+1]; Yw[j]:=Yw[j+1]; zaznaczonywezel[j]:=zaznaczonywezel[j+1]; end;
            for j:=1 to Le do if Wp[j]>i then Wp[j]:=Wp[j]-1;
            for j:=1 to Le do if Wk[j]>i then Wk[j]:=Wk[j]-1;
            for j:=1 to Lwar do if s[j]>i then s[j]:=s[j]-1;
            Lw:=Lw-1;i:=i-1; gg:=true;
          end;
      end;
    end;
    until i=Lw;
    for i:=1 to Lw do zaznaczonywezel[i]:=false;
  end;
if RowsPp>0 then                    //usuwanie sil
  begin
    i:=0;
    repeat
      begin
        inc(i);
        if zaznaczoneP[i]=true then
          begin for x:=i to RowsPp do begin P[x]:=P[x+1]; xp[x]:=xp[x+1]; np[x]:=np[x+1]; alfap[x]:=alfap[x+1]; zaznaczoneP[x]:=zaznaczoneP[x+1]; end; i:=i-1; RowsPp:=RowsPp-1;  gg:=true; end;
      end;
    until i=RowsPp;
    PreRowsPp:=RowsPp;
  end;
if RowsPm>0 then                 //usuwanie momentow
  begin
    i:=0;
    repeat
      begin
        inc(i);
        if zaznaczoneM[i]=true then
          begin for x:=i to RowsPM do begin Pm[x]:=Pm[x+1]; xm[x]:=xm[x+1]; nm[x]:=nm[x+1]; zaznaczoneM[x]:=zaznaczoneM[x+1]; end; i:=i-1; RowsPm:=RowsPm-1;  gg:=true;  end;
      end;
    until i=RowsPm;
    PreRowsPm:=RowsPm;
  end;
if RowsPt>0 then                   //usuwanie temperatur
  begin
    i:=0;
    repeat
      begin
        inc(i);
        if zaznaczoneT[i]=true then
          begin for x:=i to RowsPt do begin Tg[x]:=Tg[x+1]; Td[x]:=Td[x+1]; nt[x]:=nt[x+1]; zaznaczoneT[x]:=zaznaczoneT[x+1]; end; i:=i-1; RowsPt:=RowsPt-1;  gg:=true; end;
      end;
    until i=RowsPt;
    PreRowsPt:=RowsPt;
  end;
if RowsPq>0 then                     //usuwanie rozlozonego
  begin
    i:=0;
    repeat
      begin
        inc(i);
        if zaznaczoneQ[i]=true then
          begin for x:=i to RowsPq do begin Pqi[x]:=Pqi[x+1]; Pqj[x]:=Pqj[x+1]; xqi[x]:=xqi[x+1]; xqj[x]:=xqj[x+1]; nq[x]:=nq[x+1]; alfaq[x]:=alfaq[x+1]; zaznaczoneQ[x]:=zaznaczoneQ[x+1]; end; i:=i-1; RowsPq:=RowsPq-1;  gg:=true;  end;
      end;
    until i=RowsPq;
    PreRowsPq:=RowsPq;
  end;
  koniecrysowania;
  if gg=true then zapiszwstecz;
  rysuj;
  end;
end;

procedure TForm1.TBMenPrzekrojowClick(Sender: TObject);
begin
  form8.show;
end;

procedure TForm1.TBZapiszClick(Sender: TObject);
begin
  tak:=false;
  saveDialog1.Title := 'Zapisz';
  saveDialog1.InitialDir := GetCurrentDir;
  saveDialog1.Filter := 'Materia file|*.mtr';
  saveDialog1.DefaultExt := 'mtr';
  if SaveDialog1.Filename='' then begin if SaveDialog1.Execute then tak:=true; end else tak:=true;
  assignfile(plik,UTF8ToAnsi(savedialog1.filename));
  if tak=true then zapiszjako;
end;

procedure tform1.klikenterspacja;
var
x1,y1,xd,yd,angle:real;
begin
  if (tryb=1) and (jedenpunkt=1) then       //rysowanie końca pręta
    begin
      k:=0;
      for i:=1 to Lw do
        begin if (Xpoint<>Xw[i]) or (Ypoint<>Yw[i]) then inc(k) else
          if sqrt(sqr(Xw[Wp[Le]]-Xpoint)+sqr(Yw[Wp[Le]]-Ypoint))>0 then
          begin
            Wk[Le]:=i;Le:=Le+1;typs[Le]:=1;Prz[Le]:=combobox1.ItemIndex;Wp[Le]:=i; if polar=true then polarpoint:=i;
          end;
        end;
      if k=Lw then
      begin
        Lw:=Lw+1;
        Xw[Lw]:=Xpoint;
        Yw[Lw]:=Ypoint;
        zaznaczonywezel[Lw]:=false;
        Wk[Le]:=Lw;
        Le:=Le+1;
        zaznaczonypret[Le]:=false;
        Wp[Le]:=Lw;
        Prz[Le]:=combobox1.ItemIndex;
        typs[Le]:=1;
        if polar=true then polarpoint:=Lw;
      end;
      Lx[Le-1]:=Xw[Wk[Le-1]]-Xw[Wp[Le-1]];
      Ly[Le-1]:=Yw[Wk[Le-1]]-Yw[Wp[Le-1]];
      L[Le-1]:=sqrt(sqr(Lx[Le-1])+sqr(Ly[Le-1]));
      if Lx[Le-1]=0 then alfapr[Le-1]:=pi()/2*abs(Ly[Le-1])/Ly[Le-1] else alfapr[Le-1]:=arctan(Ly[Le-1]/Lx[Le-1]);
      if Lx[Le-1]<0 then alfapr[Le-1]:=alfapr[Le-1]+pi();
    end;
  if (tryb=1) and (jedenpunkt=0) then      //rysowanie pręta
    begin
      k:=0;
      jedenpunkt:=1;
      for i:=1 to Lw do
        if (Xpoint<>Xw[i]) or (Ypoint<>Yw[i])  then inc(k) else begin Le:=Le+1; typs[Le]:=1;Prz[Le]:=combobox1.ItemIndex; Wp[Le]:=i; if polar=true then polarpoint:=i; end;
      if k=Lw then
      begin
        Lw:=Lw+1;
        Xw[Lw]:=Xpoint;
        Yw[Lw]:=Ypoint;
        zaznaczonywezel[Lw]:=false;
        Le:=Le+1;
        zaznaczonypret[Le]:=false;
        Wp[Le]:=Lw;
        Prz[Le]:=combobox1.ItemIndex;
        typs[Le]:=1;
        if polar=true then polarpoint:=Lw;
      end;
    end;
  if tryb=3 then                                       //tryb ustawiania kąta podpory
    begin
     i:=0;
     repeat inc(i) until zaznaczonywezel[i]=true;
     begin
      if Xpoint>Xw[i] then f6alfa:=90-arctan((Ypoint-Yw[i])/(Xpoint-Xw[i]))*180/pi();
      if Xpoint<Xw[i] then f6alfa:=270-arctan((Ypoint-Yw[i])/(Xpoint-Xw[i]))*180/pi();
      if Xpoint=Xw[i] then if Ypoint>=Yw[i] then f6alfa:=0 else f6alfa:=180;
     end;
     tryb:=4; label13.caption:=''; label14.caption:=''; polar:=false; idletimer1.Enabled:=false; polarpoint:=0; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0;
     form6.show;
     rysuj;
    end;
  if tryb=6 then      //przenoszenie
    begin
      Xd:=Xpoint;Yd:=Ypoint;
      for i:=1 to Lw do if zaznaczonywezel[i]=true then
        begin
          Xw[i]:=Xw[i]+Xd-Xpoczramki; Yw[i]:=Yw[i]+Yd-Ypoczramki;
        end;
      tryb:=0;  polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0;
      label13.caption:=''; label14.caption:=''; koniecrysowania;
      for i:=1 to rowsPp do zaznaczoneP[i]:=false; for i:=1 to rowsPq do zaznaczoneQ[i]:=false; for i:=1 to rowsPm do zaznaczoneM[i]:=false; for i:=1 to rowsPm do zaznaczoneM[i]:=false;
      for i:=1 to rowsPt do zaznaczoneT[i]:=false; for i:=1 to Lw do zaznaczonywezel[i]:=false; for i:=1 to Le do if L[i]=0 then zaznaczonyPret[i]:=true else zaznaczonyPret[i]:=false;
      tbusun.click;
      form14open:=false;
      TBPrzenies.Down:=false;
      sprawdzwezly; zapiszwstecz;
    end;
  if tryb=5 then
    begin
      Xpoczramki:=Xpoint; Ypoczramki:=Ypoint;
      tryb:=6; label13.caption:='Przenoszenie - punkt końcowy';
    end;
  if tryb=8 then  //kopiowanie
    begin
      Xd:=Xpoint;Yd:=Ypoint;
      for i:=1 to Le do if zaznaczonypret[i]=true then
        begin
          Lw:=Lw+2;Le:=Le+1;
          Xw[Lw-1]:=Xw[Wp[i]]+Xd-Xpoczramki; Yw[Lw-1]:=Yw[wp[i]]+Yd-Ypoczramki;
          Xw[Lw]:=Xw[Wk[i]]+Xd-Xpoczramki; Yw[Lw]:=Yw[wk[i]]+Yd-Ypoczramki;
          Wp[Le]:=Lw-1;Wk[Le]:=Lw; typs[Le]:=typs[i]; Prz[Le]:=Prz[i];
          if rowsPp>0 then for j:=1 to RowsPp do if np[j]=i then begin RowsPp:=RowsPp+1; P[RowsPp]:=P[j]; np[RowsPp]:=Le; alfap[RowsPp]:=alfap[j]; xp[RowsPp]:=xp[j]; for x:=0 to warianty do wariantP[RowsPp]:=wariantP[j] end;
          if rowsPq>0 then for j:=1 to RowsPq do if nq[j]=i then begin RowsPq:=RowsPq+1; Pqi[RowsPq]:=Pqi[j]; Pqj[RowsPq]:=Pqj[j]; nq[RowsPq]:=Le; alfaq[RowsPq]:=alfaq[j]; xqi[RowsPq]:=xqi[j]; xqj[RowsPq]:=xqj[j]; for x:=0 to warianty do wariantQ[RowsPq]:=wariantQ[j] end;
          if rowsPm>0 then for j:=1 to RowsPm do if nm[j]=i then begin RowsPm:=RowsPm+1; Pm[RowsPm]:=Pm[j]; nm[RowsPm]:=Le; xm[RowsPm]:=xm[j]; for x:=0 to warianty do wariantM[RowsPm]:=wariantM[j] end;
          if rowsPt>0 then for j:=1 to RowsPt do if nt[j]=i then begin RowsPt:=RowsPt+1; Tg[RowsPt]:=Tg[j]; Td[RowsPt]:=Td[j]; nt[RowsPt]:=Le; for x:=0 to warianty do wariantT[RowsPt]:=wariantT[j] end;
          if Lwar>0 then   for j:=1 to Lwar do if s[j]=Wp[i] then begin Lwar:=Lwar+1; Rpod[Lwar]:=Rpod[j]; DH[Lwar]:=DH[j]; KH[Lwar]:=KH[j]; DV[Lwar]:=DV[j]; KV[Lwar]:=KV[j]; DM[Lwar]:=DM[j]; KM[Lwar]:=KM[j]; fipod[Lwar]:=fipod[j]; s[Lwar]:=Lw-1; for x:=0 to warianty do wariantPod[Lwar]:=wariantPod[j] end;
          if Lwar>0 then   for j:=1 to Lwar do if s[j]=Wk[i] then begin Lwar:=Lwar+1; Rpod[Lwar]:=Rpod[j]; DH[Lwar]:=DH[j]; KH[Lwar]:=KH[j]; DV[Lwar]:=DV[j]; KV[Lwar]:=KV[j]; DM[Lwar]:=DM[j]; KM[Lwar]:=KM[j]; fipod[Lwar]:=fipod[j]; s[Lwar]:=Lw; for x:=0 to warianty do wariantPod[Lwar]:=wariantPod[j] end;
        end;
        PreRowsPp:=RowsPp; PreRowsPq:=RowsPq; PreRowsPm:=RowsPm; PreRowsPt:=RowsPt; PreLwar:=Lwar; sprawdzwezly; koniecrysowania;
    end;
  if tryb=7 then
    begin
      Xpoczramki:=Xpoint; Ypoczramki:=Ypoint; tryb:=8; label13.caption:='Kopiowanie - punkt końcowy';
    end;
  if tryb=12 then  //lustro
    begin
      Xd:=Xpoint;Yd:=Ypoint;
      for i:=1 to Le do if zaznaczonypret[i]=true then
        begin
          Lw:=Lw+2;Le:=Le+1;
          x1:=Xd-Xpoczramki;
          y1:=Yd-Ypoczramki;
          if x1=0 then begin
            Xw[Lw-1]:=Xw[Wp[i]]+2*(Xpoczramki-Xw[Wp[i]]);Yw[Lw-1]:=Yw[Wp[i]];
            Xw[Lw]:=Xw[Wk[i]]+2*(Xpoczramki-Xw[Wk[i]]);Yw[Lw]:=Yw[Wk[i]];
          end else begin
           Xw[Lw-1]:=Xw[Wp[i]]-2*(Yd-Yw[Wp[i]]+(Xw[Wp[i]]-Xpoczramki)*y1/x1-y1)/(1+y1*y1/x1/x1)*y1/x1; Yw[Lw-1]:=Yw[Wp[i]]+2*(Yd-Yw[Wp[i]]+(Xw[Wp[i]]-Xpoczramki)*y1/x1-y1)/(1+y1*y1/x1/x1);
           Xw[Lw]:=  Xw[Wk[i]]-2*(Yd-Yw[Wk[i]]+(Xw[Wk[i]]-Xpoczramki)*y1/x1-y1)/(1+y1*y1/x1/x1)*y1/x1; Yw[Lw]:=  Yw[Wk[i]]+2*(Yd-Yw[Wk[i]]+(Xw[Wk[i]]-Xpoczramki)*y1/x1-y1)/(1+y1*y1/x1/x1);
          end;
          Wp[Le]:=Lw-1;Wk[Le]:=Lw; typs[Le]:=typs[i]; Prz[Le]:=Prz[i];
          for j:=1 to RowsPp do if np[j]=i then begin RowsPp:=RowsPp+1; P[RowsPp]:=P[j]; np[RowsPp]:=Le; if y1=0 then alfap[rowsPp]:=180-alfap[j] else alfap[RowsPp]:=2*arctan(x1/y1)*180/pi-alfap[j]; while alfap[rowsPp]<0 do alfap[rowsPp]:=alfap[rowsPp]+360; while alfap[rowsPp]>=360 do alfap[rowsPp]:=alfap[rowsPp]-360; xp[RowsPp]:=xp[j]; for x:=0 to warianty do wariantP[RowsPp]:=wariantP[j] end;
          for j:=1 to RowsPq do if nq[j]=i then begin RowsPq:=RowsPq+1; Pqi[RowsPq]:=Pqi[j]; Pqj[RowsPq]:=Pqj[j]; nq[RowsPq]:=Le; if y1=0 then alfaq[rowsPq]:=180-alfaq[j] else alfaq[RowsPq]:=2*arctan(x1/y1)*180/pi-alfaq[j]; while alfaq[rowsPq]<0 do alfaq[rowsPq]:=alfaq[rowsPq]+360; while alfaq[rowsPq]>=360 do alfaq[rowsPq]:=alfaq[rowsPq]-360; xqi[RowsPq]:=xqi[j]; xqj[RowsPq]:=xqj[j]; for x:=0 to warianty do wariantQ[RowsPq]:=wariantQ[j] end;
          for j:=1 to RowsPm do if nm[j]=i then begin RowsPm:=RowsPm+1; Pm[RowsPm]:=Pm[j]; nm[RowsPm]:=Le; xm[RowsPm]:=xm[j]; for x:=0 to warianty do wariantM[RowsPm]:=wariantM[j] end;
          for j:=1 to RowsPt do if nt[j]=i then begin RowsPt:=RowsPt+1; Tg[RowsPt]:=Tg[j]; Td[RowsPt]:=Td[j]; nt[RowsPt]:=Le; for x:=0 to warianty do wariantT[RowsPt]:=wariantT[j] end;
          if Lwar>0 then   for j:=1 to Lwar do if s[j]=Wp[i] then begin Lwar:=Lwar+1; Rpod[Lwar]:=Rpod[j]; DH[Lwar]:=DH[j]; KH[Lwar]:=KH[j]; DV[Lwar]:=DV[j]; KV[Lwar]:=KV[j]; DM[Lwar]:=DM[j]; KM[Lwar]:=KM[j]; if y1=0 then fipod[Lwar]:=180-fipod[j] else fipod[Lwar]:=2*arctan(x1/y1)*180/pi-fipod[j]; while fipod[Lwar]<0 do fipod[lwar]:=fipod[lwar]+360; while fipod[lwar]>=360 do fipod[lwar]:=fipod[lwar]-360; s[Lwar]:=Lw-1; for x:=0 to warianty do wariantPod[Lwar]:=wariantPod[j] end;
          if Lwar>0 then   for j:=1 to Lwar do if s[j]=Wk[i] then begin Lwar:=Lwar+1; Rpod[Lwar]:=Rpod[j]; DH[Lwar]:=DH[j]; KH[Lwar]:=KH[j]; DV[Lwar]:=DV[j]; KV[Lwar]:=KV[j]; DM[Lwar]:=DM[j]; KM[Lwar]:=KM[j]; if y1=0 then fipod[Lwar]:=180-fipod[j] else fipod[Lwar]:=2*arctan(x1/y1)*180/pi-fipod[j]; while fipod[Lwar]<0 do fipod[lwar]:=fipod[lwar]+360; while fipod[lwar]>=360 do fipod[lwar]:=fipod[lwar]-360; s[Lwar]:=Lw; for x:=0 to warianty do wariantPod[Lwar]:=wariantPod[j] end;
        end;
      PreRowsPp:=RowsPp; PreRowsPq:=RowsPq; PreRowsPm:=RowsPm; PreRowsPt:=RowsPt; PreLwar:=Lwar; tryb:=0; TBLustro.down:=false; sprawdzwezly; koniecrysowania; zapiszwstecz;
      label13.caption:=''; label14.caption:=''; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0;
    end;
  if tryb=11 then
    begin
      Xpoczramki:=Xpoint; Ypoczramki:=Ypoint; tryb:=12; label13.caption:='Lustro - punkt końcowy';
    end;
  if tryb=14 then  //obrot
    begin
      Xd:=Xpoint;Yd:=Ypoint;
      for i:=1 to Le do if zaznaczonypret[i]=true then
        begin
          Lw:=Lw+2;Le:=Le+1;
          x1:=Xd-Xpoczramki;
          y1:=Yd-Ypoczramki;
          angle:=ATAN(-y1,x1);         //wyznaczanie kąta obrotu
          if x1<0 then angle:=angle+pi();
          if (x1>=0) and (y1>0) then angle:=angle+2*pi();
          Xw[Lw-1]:=(Xw[Wp[i]]-xpoczramki)*COS(angle)+(Yw[Wp[i]]-ypoczramki)*SIN(angle)+xpoczramki; Yw[Lw-1]:=-(Xw[Wp[i]]-xpoczramki)*SIN(angle)+(Yw[Wp[i]]-ypoczramki)*COS(angle)+ypoczramki;
          Xw[Lw]:=  (Xw[Wk[i]]-xpoczramki)*COS(angle)+(Yw[Wk[i]]-ypoczramki)*SIN(angle)+xpoczramki; Yw[Lw]:=  -(Xw[Wk[i]]-xpoczramki)*SIN(angle)+(Yw[Wk[i]]-ypoczramki)*COS(angle)+ypoczramki;
          Wp[Le]:=Lw-1;Wk[Le]:=Lw; typs[Le]:=typs[i]; Prz[Le]:=Prz[i];
          for j:=1 to RowsPp do if np[j]=i then begin RowsPp:=RowsPp+1; P[RowsPp]:=P[j]; np[RowsPp]:=Le; alfap[rowsPp]:=alfap[j]+angle*180/pi(); while alfap[rowsPp]<0 do alfap[rowsPp]:=alfap[rowsPp]+360; while alfap[rowsPp]>=360 do alfap[rowsPp]:=alfap[rowsPp]-360; xp[RowsPp]:=xp[j]; for x:=0 to warianty do wariantP[RowsPp]:=wariantP[j] end;
          for j:=1 to RowsPq do if nq[j]=i then begin RowsPq:=RowsPq+1; Pqi[RowsPq]:=Pqi[j]; Pqj[RowsPq]:=Pqj[j]; nq[RowsPq]:=Le; alfaq[rowsPq]:=alfaq[j]+angle*180/pi(); while alfaq[rowsPq]<0 do alfaq[rowsPq]:=alfaq[rowsPq]+360; while alfaq[rowsPq]>=360 do alfaq[rowsPq]:=alfaq[rowsPq]-360; xqi[RowsPq]:=xqi[j]; xqj[RowsPq]:=xqj[j]; for x:=0 to warianty do wariantQ[RowsPq]:=wariantQ[j] end;
          for j:=1 to RowsPm do if nm[j]=i then begin RowsPm:=RowsPm+1; Pm[RowsPm]:=Pm[j]; nm[RowsPm]:=Le; xm[RowsPm]:=xm[j]; for x:=0 to warianty do wariantM[RowsPm]:=wariantM[j] end;
          for j:=1 to RowsPt do if nt[j]=i then begin RowsPt:=RowsPt+1; Tg[RowsPt]:=Tg[j]; Td[RowsPt]:=Td[j]; nt[RowsPt]:=Le; for x:=0 to warianty do wariantT[RowsPt]:=wariantT[j] end;
          if Lwar>0 then   for j:=1 to Lwar do if s[j]=Wp[i] then begin Lwar:=Lwar+1; Rpod[Lwar]:=Rpod[j]; DH[Lwar]:=DH[j]; KH[Lwar]:=KH[j]; DV[Lwar]:=DV[j]; KV[Lwar]:=KV[j]; DM[Lwar]:=DM[j]; KM[Lwar]:=KM[j]; fipod[Lwar]:=fipod[j]+angle*180/pi(); while fipod[Lwar]<0 do fipod[lwar]:=fipod[lwar]+360; while fipod[lwar]>=360 do fipod[lwar]:=fipod[lwar]-360; s[Lwar]:=Lw-1; for x:=0 to warianty do wariantPod[Lwar]:=wariantPod[j] end;
          if Lwar>0 then   for j:=1 to Lwar do if s[j]=Wk[i] then begin Lwar:=Lwar+1; Rpod[Lwar]:=Rpod[j]; DH[Lwar]:=DH[j]; KH[Lwar]:=KH[j]; DV[Lwar]:=DV[j]; KV[Lwar]:=KV[j]; DM[Lwar]:=DM[j]; KM[Lwar]:=KM[j]; fipod[Lwar]:=fipod[j]+angle*180/pi(); while fipod[Lwar]<0 do fipod[lwar]:=fipod[lwar]+360; while fipod[lwar]>=360 do fipod[lwar]:=fipod[lwar]-360; s[Lwar]:=Lw; for x:=0 to warianty do wariantPod[Lwar]:=wariantPod[j] end;
        end;
      PreRowsPp:=RowsPp; PreRowsPq:=RowsPq; PreRowsPm:=RowsPm; PreRowsPt:=RowsPt; PreLwar:=Lwar; tryb:=0; TBObrot.down:=false; sprawdzwezly; koniecrysowania; zapiszwstecz;
      label13.caption:=''; label14.caption:=''; polar:=false; idletimer1.Enabled:=false; wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0;liczba2:=0;
    end;
  if tryb=13 then
    begin
      Xpoczramki:=Xpoint; Ypoczramki:=Ypoint; tryb:=14; label13.caption:='Obrót - punkt końcowy';
    end;
  wprowadz:=0; wprowadzalfa:=false; ulamek:=1; liczba1:=0; liczba2:=0;
  rysuj;
end;

procedure tform1.zapiszjako;
begin
  zmiana:=false;
  label13.caption:=('zapisano plik '+savedialog1.filename);
  Form1.Caption := 'Materia '+wersja+' - '+extractfilename(savedialog1.filename);
  proceszapisywania
end;

procedure tform1.proceszapisywania;
begin
  Rewrite(plik);
  writeln(plik,'Przekroj    E[kPa]  g[g/cm^3]    at[1/K]      A[m2]        J[m4]     h[m]       i[m]   Nazwa');
  if Lprz>0 then
  for i:=1 to LPrz do
  begin
   write(plik,i,'     ');
   write(plik,Ei[i]:12:0,' ',gi[i]:10:3,' ',ati[i]:10:6,' ',Ai[i]:10:6,' ',Ji[i]:12:9,' ',hi[i]:8:3,'   ',ii[i]:8:4,'   ');
   writeln(plik,NazwaPrz[i]);
  end;
  writeln(plik,' ');
  writeln(plik,'Warianty');
  writeln(plik,'Numer C. wl.  Nazwa');
  for i:=0 to Warianty do
  begin
   write(plik,i,'     ');
   if WariantWlasny[i]=true then write(plik,'T       ') else write(plik,'N       ');
   writeln(plik,WariantNazwa[i]);
  end;
  writeln(plik,' ');
  writeln(plik,'Wezly');
  writeln(plik,'Numer     X[m]    Y[m]');
  if Lw>0 then
  for i:=1 to Lw do writeln(plik,i,'     ',Xw[i]:8:3,' ',Yw[i]:8:3);
  writeln(plik,' ');
  writeln(plik,'Prety');
  writeln(plik,'Numer   Wp   Wk  typs  Prz');
  if Le>0 then
  for i:=1 to Le do writeln(plik,i,'     ',Wp[i]:4,' ',Wk[i]:4,' ',typs[i]:4,' ',Prz[i]+1:4);
  writeln(plik,' ');
  writeln(plik,'Podpory');
  writeln(plik,'Numer W Rodzaj    fi[deg]    DV[m]        DH[m]        DM[rad]       kV[m/kN] kH[m/kN] kM[1/kNm]   Warianty');
  if Lwar>0 then
  for i:=1 to Lwar do begin
    write(plik,i,'  ',s[i]:4,' ',Rpod[i]:6,' ',fipod[i]:11:6,' ',DV[i]:12:8,' ',DH[i]:12:8,' ',DM[i]:12:8,' ',KV[i]:8:3,' ',KH[i]:8:3,' ',KM[i]:8:3,'       ');
    for x:=1 to Warianty do if WariantPod[i,x]=true then write(plik,x,' ');
    writeln(plik,'0');
  end;
  writeln(plik,' ');
  writeln(plik,'Skupione');
  writeln(plik,'Numer    P[kN]    fi[deg]  Pret    xp[-]   Warianty');
  if RowsPp>0 then
  for i:=1 to RowsPp do begin
    write(plik,i,'     ',P[i]:8:3,' ',alfaP[i]:11:6,' ',np[i]:4,' ',xp[i]:8:3,'   ');
    for x:=1 to Warianty do if WariantP[i,x]=true then write(plik,x,' ');
    writeln(plik,'0');
  end;
  writeln(plik,' ');
  writeln(plik,'Momenty');
  writeln(plik,'Numer   M[kNm] Pret    xm[-]   Warianty');
  if RowsPm>0 then
  for i:=1 to RowsPm do begin
    write(plik,i,'     ',Pm[i]:8:3,' ',nm[i]:4,' ',xm[i]:8:3,'   ');
    for x:=1 to Warianty do if WariantM[i,x]=true then write(plik,x,' ');
    writeln(plik,'0');
  end;
  writeln(plik,' ');
  writeln(plik,'Ciagle');
  writeln(plik,'Numer qi[kN/m] qj[kN/m]     fi[deg] Pret   xqi[-]   xqj[-]   Warianty');
  if RowsPq>0 then
  for i:=1 to RowsPq do begin
    write(plik,i,'     ',Pqi[i]:8:3,' ',Pqj[i]:8:3,' ',alfaq[i]:11:6,' ',nq[i]:4,' ',xqi[i]:8:3,' ',xqj[i]:8:3,'   ');
    for x:=1 to Warianty do if WariantQ[i,x]=true then write(plik,x,' ');
    writeln(plik,'0');
  end;
  writeln(plik,' ');
  writeln(plik,'Temperatura');
  writeln(plik,'Numer    Tg[K]    Td[K] Pret   Warianty');
  if RowsPt>0 then
  for i:=1 to RowsPt do begin
    write(plik,i,'     ',Tg[i]:8:3,' ',Td[i]:8:3,' ',nt[i]:4,'   ');
    for x:=1 to Warianty do if WariantT[i,x]=true then write(plik,x,' ');
    writeln(plik,'0');
  end;
  writeln(plik,' ');
  writeln(plik,'okno');
  write(plik,A:8,B:8,zoom:8);
  closefile(plik);
end;

procedure tform1.otworz2;
begin
  openDialog1.Title := 'Otwórz';
  openDialog1.InitialDir := GetCurrentDir;
  openDialog1.Filter := 'Materia file|*.mtr';
  openDialog1.DefaultExt := 'mtr';
  if OpenDialog1.Execute then
  begin
   odnowa;
   SaveDialog1.filename:=OpenDialog1.Filename;
   assignfile(plik,utf8toansi(openDialog1.Filename));
   try
   form1.caption:='Materia '+wersja+' - '+extractfilename(savedialog1.FileName);
   procesotwierania;
   pozycja:=0;
   zapiszwstecz;
   label13.caption:=('otwarto plik '+savedialog1.filename);
   TBCofnij.enabled:=false; mbcofnij.enabled:=false; TBCofnij.imageindex:=31; mbcofnij.ImageIndex:=31;
   TBPrzywroc.enabled:=false; mbprzywroc.enabled:=false; TBPrzywroc.ImageIndex:=32; mbprzywroc.ImageIndex:=32;
   ilecofnij:=0;ileprzywroc:=0;
   zmiana:=false;
   except
   MessageDlg('Błąd!', 'Plik '+opendialog1.filename+' jest uszkodzony.', mterror, [mbOK], 0);
   odnowa;
   end;
  end
end;

procedure tform1.procesotwierania;
begin
    for i:=1 To Lw do begin Xw[i]:=0; Yw[i]:=0; zaznaczonywezel[i]:=false;end;
    for i:=1 To Le do begin Wp[i]:=0; Wk[i]:=0; typs[i]:=1; Prz[i]:=1; if anulowano=true then zaznaczonypret[i]:=false; end;
    for i:=1 To Lwar do begin s[i]:=0; fipod[i]:=0; rpod[i]:=3;DV[i]:=0; KV[i]:=0;DH[i]:=0; KH[i]:=0;DM[i]:=0; KM[i]:=0; end;
    for i:=1 To RowsPp do begin P[i]:=0; alfap[i]:=0; np[i]:=0; xp[i]:=0; zaznaczoneP[i]:=false;end;
    for i:=1 To RowsPm do begin Pm[i]:=0; nm[i]:=0; xm[i]:=0;zaznaczoneM[i]:=false;end;
    for i:=1 To RowsPq do begin Pqi[i]:=0; Pqj[i]:=0; alfaq[i]:=0; nq[i]:=0; xqi[i]:=0;xqj[i]:=0;zaznaczoneQ[i]:=false;end;
    for i:=1 To RowsPt do begin Tg[i]:=0; Td[i]:=0; nt[i]:=0;zaznaczoneT[i]:=false;end;
    Le:=0;Lw:=0;Lprz:=0;Lwar:=0;PreLwar:=0;RowsPp:=0;PrerowsPp:=0;RowsPm:=0;PrerowsPm:=0;RowsPq:=0;PrerowsPq:=0;RowsPt:=0;PrerowsPt:=0;
    reset(plik);
    readln(plik,nic);
    read(plik,nic);
    Lprz:=0;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until nic=' ';
     inc(Lprz);
     read(plik,Ei[Lprz],gi[Lprz],ati[Lprz],Ai[Lprz],Ji[Lprz],hi[Lprz],ii[Lprz]);
     repeat read(plik,nic); until nic<>' ';
     readln(plik,blabla);
     NazwaPrz[Lprz]:=nic+blabla;
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);readln(plik,nic);read(plik,nic);
    Warianty:=-1;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until (nic='T') or (nic='N');
     inc(warianty);
     if nic='T' then WariantWlasny[warianty]:=true else WariantWlasny[warianty]:=false;
     repeat read(plik,nic); until nic<>' ';
     readln(plik,blabla);
     WariantNazwa[warianty]:=nic+blabla;
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);readln(plik,nic);read(plik,nic);
    Lw:=0;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until nic=' ';
     inc(Lw);
     readln(plik,Xw[Lw],Yw[Lw]);
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);readln(plik,nic);read(plik,nic);
    Le:=0;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until nic=' ';
     inc(Le);
     readln(plik,Wp[Le],Wk[Le],typs[Le],Prz[Le]);
     Prz[Le]:=Prz[Le]-1;
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);readln(plik,nic);read(plik,nic);
    Lwar:=0;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until nic=' ';
     inc(Lwar);
     read(plik,s[Lwar],rpod[lwar],fipod[Lwar],Dv[Lwar],dh[lwar],dm[lwar],Kv[Lwar],kh[lwar],km[lwar]);
     for i:=1 to Warianty do wariantpod[Lwar,i]:=false;
     repeat
       read(plik,i);
       WariantPod[Lwar,i]:=true;
     until i=0;
     readln(plik,nic);
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);readln(plik,nic);read(plik,nic);
    rowsPp:=0;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until nic=' ';
     inc(rowsPp);
     read(plik,P[rowspp],alfap[rowspp],np[rowspp],xp[rowspp]);
     for i:=1 to Warianty do wariantP[rowspp,i]:=false;
     repeat
       read(plik,i);
       WariantP[RowsPp,i]:=true;
     until i=0;
     readln(plik,nic);
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);readln(plik,nic);read(plik,nic);
    RowsPm:=0;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until nic=' ';
     inc(RowsPm);
     read(plik,Pm[rowspm],nm[rowspm],xm[rowspm]);
     for i:=1 to Warianty do wariantM[rowspm,i]:=false;
     repeat
       read(plik,i);
       WariantM[RowsPm,i]:=true;
     until i=0;
     readln(plik,nic);
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);readln(plik,nic);read(plik,nic);
    RowsPq:=0;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until nic=' ';
     inc(RowsPq);
     read(plik,Pqi[rowspq],Pqj[rowspq],alfaq[rowspq],nq[rowspq],xqi[rowspq],xqj[rowspq]);
     for i:=1 to Warianty do wariantQ[rowspq,i]:=false;
     repeat
       read(plik,i);
       WariantQ[RowsPq,i]:=true;
     until i=0;
     readln(plik,nic);
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);readln(plik,nic);read(plik,nic);
    RowsPt:=0;
    if nic<>' ' then
    repeat
     repeat read(plik,nic) until nic=' ';
     inc(RowsPt);
     read(plik,Tg[rowspt],Td[rowspt],nt[rowspt]);
     for i:=1 to Warianty do wariantT[rowspt,i]:=false;
     repeat
       read(plik,i);
       WariantT[RowsPt,i]:=true;
     until i=0;
     readln(plik,nic);
     read(plik,nic);
    until nic=' ';
    readln(plik,nic);readln(plik,nic);
    if anulowano=false then read(plik,A,B,zoom);
    closefile(plik);
    with combobox1 do items.Clear;
    for i:=1 to Lprz do with combobox1 do items.add(Nazwaprz[i]);
    combobox1.ItemIndex:=0;
    PreLwar:=Lwar;PrerowsPp:=RowsPp;PrerowsPm:=RowsPm;PrerowsPq:=RowsPq;PrerowsPt:=RowsPt;
    anulowano:=false;
    koniecrysowania;
    rysuj;
end;


procedure tform1.odnowa;
begin
  tbPowrot.click;
  if assigned(form2) then if form2.Visible=true then begin anulowano:=true; form2.Close; form1.Activate; end;
  if assigned(form3) then if form3.Visible=true then begin anulowano:=true; form3.Close; form1.Activate; end;
  if assigned(form4) then if form4.Visible=true then begin anulowano:=true; form4.Close; form1.Activate; end;
  if assigned(form5) then if form5.Visible=true then begin anulowano:=true; form5.Close; form1.Activate; end;
  if assigned(form6) then if form6.Visible=true then begin anulowano:=true; form6.Close; form1.Activate; end;
  if assigned(form7) then if form7.Visible=true then begin form7.Close; form1.Activate; end;
  if assigned(form9) then if form9.Visible=true then begin form9.Close; form1.Activate; end;
  if assigned(form10) then if form10.Visible=true then begin form10.Close; form1.Activate; end;
  if assigned(form8) then if form8.Visible=true then begin form8.Close; form1.Activate; end;
  if assigned(form11) then if form11.Visible=true then begin form11.Close; form1.Activate; end;
  if assigned(form12) then if form12.Visible=true then begin form12.Close; form1.Activate; end;
  if assigned(form13) then if form13.Visible=true then begin form13.Close; form1.Activate; end;
  if assigned(form14) then if form14.Visible=true then begin form14.Close; form1.Activate; end;
  if assigned(form15) then if form15.Visible=true then begin okienko:=0; form15.Close; form1.Activate; end;
  if assigned(form16) then if form16.Visible=true then begin form16.Close; form1.Activate; end;
  for i:=1 To Lw do begin Xw[i]:=0; Yw[i]:=0; zaznaczonywezel[i]:=false;end;
  for i:=1 To Le do begin Wp[i]:=0; Wk[i]:=0; typs[i]:=1; Prz[i]:=1;zaznaczonypret[i]:=false;end;
  for i:=1 To Lwar do begin s[i]:=0; fipod[i]:=0; rpod[i]:=3; DV[i]:=0; KV[i]:=0;DH[i]:=0; KH[i]:=0;DM[i]:=0; KM[i]:=0;end;
  for i:=1 To RowsPp do begin P[i]:=0; alfap[i]:=0; np[i]:=0; xp[i]:=0;zaznaczoneP[i]:=false;for x:=1 to warianty do wariantP[i,x]:=false; end;
  for i:=1 To RowsPm do begin Pm[i]:=0; nm[i]:=0; xm[i]:=0;zaznaczoneM[i]:=false;for x:=1 to warianty do wariantM[i,x]:=false;end;
  for i:=1 To RowsPq do begin Pqi[i]:=0; Pqj[i]:=0; alfaq[i]:=0; nq[i]:=0; xqi[i]:=0;xqj[i]:=0;zaznaczoneQ[i]:=false;for x:=1 to warianty do wariantq[i,x]:=false;end;
  for i:=1 To RowsPt do begin Tg[i]:=0; Td[i]:=0; nt[i]:=0;zaznaczoneT[i]:=false;for x:=1 to warianty do wariantT[i,x]:=false;end;
  Le:=0;Lw:=0;Lprz:=0;Lwar:=0;PreLwar:=0;RowsPp:=0;PrerowsPp:=0;RowsPm:=0;PrerowsPm:=0;RowsPq:=0;PrerowsPq:=0;RowsPt:=0;PrerowsPt:=0;
  warianty:=0; wariantnazwa[0]:='Wszystko'; wariantwlasny[0]:=false;
  for i:=1 to 10 do deletefile('C:/temp/mtr'+czas+'_'+inttostr(i)+'.tmp');
  filestream.Free;
  deletefile('C:/temp/mtt'+czas+'.tmp');
  czas:=FormatDateTime('hhnnsszzz',time);
  assignfile(plik,'C:/temp/mtt'+czas+'.tmp');
  rewrite(plik);
  closefile(plik);
  filestream:=tfilestream.Create('C:/temp/mtt'+czas+'.tmp',fmopenreadwrite,fmshareexclusive);
  savedialog1.FileName:='';
  assignfile(plik,ExtractFilePath(Application.ExeName)+'new');
  try
  reset(plik);
  readln(plik,nic);
  read(plik,nic);
  i:=0;
  repeat
   begin
   inc(i);
   repeat read(plik,nic) until nic=' ';
   read(plik,Ei[i],gi[i],ati[i],Ai[i],Ji[i],hi[i],ii[i]);
   repeat read(plik,nic); until nic<>' ';
   readln(plik,blabla);
   NazwaPrz[i]:=nic+blabla;
   read(plik,nic);
   inc(LPrz);
   end;
  until nic=' ';
  closefile(plik);
  except
    MessageDlg('Błąd!', 'Pliki programu Materia są uszkodzone. Zainstaluj ponownie program.', mterror, [mbOK], 0);
    application.terminate;
  end;
  with combobox1 do items.Clear;
  for i:=1 to Lprz do with combobox1 do items.add(Nazwaprz[i]);       //WSTAWIANIE ELEMENTÓW Z BAZY
  combobox1.ItemIndex:=0;
  form1.caption:='Materia '+wersja;
  label14.caption:=('');
  pozycja:=0;
  zapiszwstecz;
  TBCofnij.enabled:=false; mbcofnij.enabled:=false; TBCofnij.imageindex:=31; mbcofnij.ImageIndex:=31;
  TBPrzywroc.enabled:=false; mbprzywroc.enabled:=false; TBPrzywroc.ImageIndex:=32; mbprzywroc.ImageIndex:=32;
  ilecofnij:=0;ileprzywroc:=0; pretlw:=1; form13x:=0.5;
  zmiana:=false;
  label13.caption:='';
  rysuj;
end;

procedure tform1.zapiszwstecz;
begin
  zmiana:=true;
  label14.caption:='';
  TBPrzywroc.enabled:=false; mbprzywroc.enabled:=false; TBPrzywroc.ImageIndex:=32; mbprzywroc.ImageIndex:=32;
  TBCofnij.enabled:=true; mbcofnij.enabled:=true; TBCofnij.ImageIndex:=8; mbcofnij.ImageIndex:=8;
  inc(pozycja);if pozycja=11 then pozycja:=1;
  ileprzywroc:=0;
  inc(ilecofnij);if ilecofnij>9 then ilecofnij:=9;
  assignfile(plik,'C:/temp/mtr'+czas+'_'+inttostr(pozycja)+'.tmp');
  proceszapisywania;
end;

procedure tform1.wczytajopcje;
var logiczna:integer;
    stryng:string;
    litera:char;
    bmp,bmp2: tbgrabitmap;
    newbtn: TToolButton;
begin
  try
  assignfile(plik,ExtractFilePath(Application.ExeName)+'options');
  reset(plik);
  readln(plik,stryng);
  readln(plik,skalawew);
  readln(plik,skaladisp);
  readln(plik,skalaP);
  readln(plik,skalaQ);
  readln(plik,ES);
  readln(plik,autosave);
  readln(plik,skok);
  readln(plik,bln);
  for i:=1 to 13 do begin readln(plik,logiczna); if logiczna=1 then texton[i]:=true else texton[i]:=false; end;
  for i:=1 to 13 do begin readln(plik,logiczna); if logiczna=1 then textoff[i]:=true else textoff[i]:=false; end;
  for i:=1 to 17 do begin readln(plik,stryng); kolor[i]:=stringtocolor(stryng); end;
  for i:=1 to 4 do readln(plik,rozmiar[i]);
  readln(plik,liczbatool);
  for i:=0 to liczbatool do begin     //czytanie toolbara
    readln(plik,nazwatool[i]);
    readln(plik,stryng);       //całe zadanie przekształcania nazwy na elementy
    if stryng='tak' then checktool[i]:=true else checktool[i]:=false;
  end;
  readln(plik,liczbatool1);
  for i:=0 to liczbatool1 do begin       //czytanie toolbara 2
    readln(plik,nazwatool1[i]);      //całe zadanie przekształcania nazwy na elementy
    readln(plik,stryng);
    if stryng='tak' then checktool1[i]:=true else checktool1[i]:=false;
  end;
  closefile(plik);
  if bar[4]=true then for i:=1 to 13 do tekst[i]:=texton[i] else for i:=1 to 13 do tekst[i]:=textoff[i];
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
  assignfile(plik,ExtractFilePath(Application.ExeName)+'images/'+bln+'.mot');
  reset(plik);
  readln(plik,motyw);
  readln(plik,ils);
  readln(plik,ts);
  readln(plik,fs);
  readln(plik,stryng);
  form1.Color:=stringtocolor(stryng);
  readln(plik,stryng);
  label10.font.size:=trunc(fs*screen.PixelsPerInch/96);
  label11.font.size:=trunc(fs*screen.PixelsPerInch/96);
  combobox1.font.size:=trunc(fs*screen.PixelsPerInch/96);
  for I := ComponentCount -1 downto 0 do
  begin
    if Components[i] is TLabel then TLabel(Components[i]).font.color:=stringtocolor(stryng);
    if Components[i] is TEdit then TEdit(Components[i]).font.color:=stringtocolor(stryng);
    if Components[i] is TCombobox then TCombobox(Components[i]).font.color:=stringtocolor(stryng);
    if Components[i] is TGroupbox then TGroupbox(Components[i]).font.color:=stringtocolor(stryng);
  end;
  readln(plik,stryng);
  label15.Color:=stringtocolor(stryng); 
  label16.Color:=stringtocolor(stryng);
  label17.Color:=stringtocolor(stryng);
  label18.Color:=stringtocolor(stryng);
  readln(plik,stryng);
  for I := ComponentCount -1 downto 0 do if Components[i] is TEdit then TEdit(Components[i]).color:=stringtocolor(stryng);
  readln(plik,logiczna);
  if logiczna=1 then for I := ComponentCount -1 downto 0 do if Components[i] is TEdit then begin TEdit(Components[i]).borderstyle:=bsSingle; TEdit(Components[i]).BorderSpacing.InnerBorder:=0; end;
  if logiczna=0 then for I := ComponentCount -1 downto 0 do if Components[i] is TEdit then begin TEdit(Components[i]).borderstyle:=bsNone; TEdit(Components[i]).BorderSpacing.InnerBorder:=2; end;
  closefile(plik);
  toolbar1.ButtonHeight:=trunc(ts*screen.PixelsPerInch/96);toolbar1.ButtonWidth:=trunc(ts*screen.PixelsPerInch/96);toolbar2.ButtonHeight:=trunc(ts*screen.PixelsPerInch/96);toolbar2.ButtonWidth:=trunc(ts*screen.PixelsPerInch/96);
  Panel4.Height:=trunc((ts+8)*screen.PixelsPerInch/96);
  try
  imagelist1.Clear;
  imagelist1.Width:=trunc(ils*screen.PixelsPerInch/96);
  imagelist1.Height:=trunc(ils*screen.PixelsPerInch/96);

  for i:=0 to 98 do try
  if (i>maleikony) and (i<90) then continue;
  bmp:=TBgrabitmap.Create(ExtractFilePath(Application.ExeName)+'images/'+bln+inttostr(i)+'.png');
  bmp2 := bmp.Resample(trunc(ils*screen.PixelsPerInch/96),trunc(ils*screen.PixelsPerInch/96)) as TBGRABitmap;
  bmp2.ReplaceColor(bgra(255,255,255,255),bgrapixeltransparent);
  imagelist1.add(bmp2.Bitmap,nil);bmp.free; bmp2.Free; finally end;

  i:=0; repeat if toolbar1.Buttons[i].Style=tbsdivider then toolbar1.Buttons[i].Destroy else inc(i) until i=toolbar1.ButtonCount;
  i:=0; repeat if toolbar2.Buttons[i].Style=tbsdivider then toolbar2.Buttons[i].Destroy else inc(i) until i=toolbar2.ButtonCount;
  toolbar1.Wrapable:=false; toolbar1.Visible:=true;toolbar2.visible:=true;
  for i:=liczbatool downto 0 do
    begin
    case nazwatool[i] of
      'Typ pręta 1'            :newbtn:=tbtyppreta1;
      'Typ pręta 2'            :newbtn:=tbtyppreta2;
      'Rysuj pręt'             :newbtn:=tbrysujpret;
      'Siła skupiona...'       :newbtn:=tbsila;
      'Obc. ciągłe...'         :newbtn:=tbciagle;
      'Moment skupiony...'     :newbtn:=tbmoment;
      'Temperatura...'         :newbtn:=tbtemperatura;
      'Przenieś'               :newbtn:=tbprzenies;
      'Kopiuj'                 :newbtn:=tbkopiuj;
      'Lustro'                 :newbtn:=tblustro;
      'Podziel pręty...'       :newbtn:=tbpodziel;
      'Podgląd'                :newbtn:=tbpodglad;
      'Typ pręta 3'            :newbtn:=tbtyppreta3;
      'Usuń'                   :newbtn:=tbusun;
      'Usuń obciążenie'        :newbtn:=tbusunobc;
      'Oblicz...'              :newbtn:=tboblicz;
      'Ostatnia podpora...'    :newbtn:=tbpodpora;
      'Typ pręta 4'            :newbtn:=tbtyppreta4;
      'Znajdź przecięcia'      :newbtn:=tbprzeciecie;
      'Poprzedni wariant'      :newbtn:=tbpoprzwariant;
      'Następny wariant'       :newbtn:=tbnastwariant;
      'Pełne utwierdzenie...'  :newbtn:=tbutwierdzenie;
      'Utwierdzenie z przesuwem...':newbtn:=tbutwprzesuw;
      'Wolna podpora...'       :newbtn:=tbwolnapodpora;
      'Podpora z przesuwem...' :newbtn:=tbprzesuw;
      'Blokada obrotu...'      :newbtn:=tbblokadaobrotu;
      'Menadżer przekrojów...' :newbtn:=tbmenprzekrojow;
      'Zakończ'                :newbtn:=tbwyjscie;
      'Pomoc'                  :newbtn:=tbpomoc;
      'Materia - informacje'   :newbtn:=tboprogramie;
      'Zapisz jako...'         :newbtn:=tbzapiszjako;
      'Zaznacz wszystko'       :newbtn:=tbzaznaczwszystko;
      'Ustawienia...'          :newbtn:=tbustawienia;
      'Menadżer projektu...'   :newbtn:=tbmenprojektu;
      'Menadżer wariantów...'  :newbtn:=tbmenwariantow;
      'Kreator rusztu...'      :newbtn:=tbkreatorruszt;
      'Kreator kratownicy...'  :newbtn:=tbkreatorkratownica;
      'Nowy'                   :newbtn:=tbnowy;
      'Zrób zdjęcie'           :newbtn:=tbzdjecie;
      'Wybierz podporę'        :newbtn:=tbrpodpory;
      'Wybierz typ pręta'      :newbtn:=tbtyppreta;
      'Wybór wariantu'         :begin label10.left:=0; if checktool[i]=true then label10.visible:=true else label10.Visible:=false; end;
      'Wybór przekroju'        :begin combobox1.left:=0;  if checktool[i]=true then combobox1.visible:=true else combobox1.Visible:=false; end;
      'Otwórz...'              :newbtn:=tbotworz;
      'Zapisz'                 :newbtn:=tbzapisz;
      'Cofnij'                 :newbtn:=tbcofnij;
      'Ponów'                  :newbtn:=tbprzywroc;
      'Zoom'                   :newbtn:=tbzoom;
      'Obrót'                  :newbtn:=tbobrot;
      '---------------'        :begin
                                  newbtn := TToolButton.Create(self);
                                  newbtn.Style:=tbsdivider;
                                  newbtn.Parent := toolbar1;
                                end;
      end;
      if newbtn<>nil then begin newbtn.Left:=0;  if checktool[i]=true then newbtn.Visible:=true else newbtn.Visible:=false; end;
      newbtn:=nil;
    end;
  toolbar1.Wrapable:=true;
  toolbar2.Wrapable:=false;
  for i:=liczbatool1 downto 0 do
    begin
    case nazwatool1[i] of
      'Menadżer projektu...'   :newbtn:=tbmenprojektu1;
      'Menadżer przekrojów...' :newbtn:=tbmenprzekrojow1;
      'Menadżer wariantów...'  :newbtn:=tbmenwariantow1;
      'Momenty'                :newbtn:=tbmomenty;
      'Naprężenia'             :newbtn:=tbnaprezenia;
      'Następny wariant'       :newbtn:=toolbutton34;
      'Normalne'               :newbtn:=tbnormalne;
      'Nowy'                   :newbtn:=tbnowy1;
      'Materia - informacje'   :newbtn:=tboprogramie1;
      'Otwórz...'              :newbtn:=tbotworz1;
      'Podgląd'                :newbtn:=tbpodglad1;
      'Pomoc'                  :newbtn:=tbpomoc1;
      'Poprzedni wariant'      :newbtn:=toolbutton33;
      'Powrót'                 :newbtn:=tbpowrot;
      'Ustawienia...'          :newbtn:=tbustawienia1;
      'Przemieszczenia'        :newbtn:=tbprzemieszczenia;
      'Reakcje'                :newbtn:=tbreakcje;
      'Suwak skali'            :begin trackbar1.left:=0;  if checktool1[i]=true then trackbar1.visible:=true else trackbar1.Visible:=false; end;
      'Tnące'                  :newbtn:=tbtnace;
      'Wybór wariantu'         :begin label11.left:=0; if checktool1[i]=true then label11.visible:=true else label11.Visible:=false; end;
      'Wyjście'                :newbtn:=tbwyjscie1;
      'Zapisz'                 :newbtn:=tbzapisz1;
      'Zapisz jako...'         :newbtn:=tbzapiszjako1;
      'Zoom'                   :newbtn:=tbzoom1;
      'Zrób zdjęcie'           :newbtn:=tbzdjecie1;
      '---------------'        :begin
                                  newbtn := TToolButton.Create(self);
                                  newbtn.Style:=tbsdivider;
                                  newbtn.Parent := toolbar2;
                                end;
      end;
      if newbtn<>nil then begin newbtn.Left:=0;  if checktool1[i]=true then newbtn.Visible:=true else newbtn.Visible:=false; end;
      newbtn:=nil;
    end;
  toolbar2.Wrapable:=true;
  if wyswietl=0 then toolbar2.visible:=false else toolbar1.visible:=false;
  toolbar1.images:=imagelist1;
  toolbar2.images:=imagelist1;
  combobox1.Width:=8*combobox1.Font.Size;
  combobox1.ItemHeight:=trunc(combobox1.Font.size*2);
  toolbar1.ButtonHeight:=trunc(combobox1.Font.size*2);
  except MessageDlg('Błąd!', 'Pliki motywu "'+motyw+'" są uszkodzone. Wybierz inny motyw.', mterror, [mbOK], 0);
  end;
  except
    MessageDlg('Błąd!', 'Pliki programu Materia są uszkodzone. Zainstaluj ponownie program.', mterror, [mbOK], 0);
    application.terminate;
  end;
end;

procedure tform1.ukladrownan;
begin
 for i:=1 to Lr do ur[i]:=0;
 i:=0;
 repeat
  i:=i+1;
  k:=i-1;
  repeat
   k:=k+1;
   j:=0;
   ur[k]:=Kr1[k,i];
   repeat
    j:=j+1;
   if ur[k]<>0 then
   begin
     if k=i
       then Kr1[k,j]:=(Kr1[k,j])/(ur[k])
       else Kr1[k,j]:=(Kr1[k,j])/(ur[k])-(Kr1[i,j])
   end
   else
   begin
     if k=i
       then Kr1[k,j]:=0
       else Kr1[k,j]:=(Kr1[k,j])
   end;
   until j=Lr;
   if ur[k]<>0 then
   begin
     if k=i
       then pr1[k]:=pr1[k]/ur[k]
       else pr1[k]:=(pr1[k]/ur[k])-pr1[i]
   end
   else pr1[k]:=pr1[k];
  until k=Lr;
 until i=Lr;
 {obliczanie k}
 ur[i]:=pr1[i];
 repeat
  i:=i-1;
  k:=i;
  ur[i]:=pr1[i];
   repeat
   k:=k+1;
   ur[i]:=ur[i]-ur[k]*Kr1[i,k];
   until k=Lr;
  until i=1;
end;

procedure tform1.statyka;
var macierzw,macierzp,macierzpod,s1:array[1..500] of integer;
    tak:boolean;
    odliczanie,lpodz:integer;
    RowsPp1,RowsPq1,RowsPm1,RowsPt1,Lwar1:integer;
    DWB,KWB:array[1..500] of real;
    wariantpod1:array[1..500] of boolean;
    max,max2:real;
    Nr,Nr2,cale:integer;
    iks:real;
    buttonselected:integer;
begin
  combobox2.items.Clear;
  for i:=1 to Le do if combobox2.Items.IndexOf(nazwaprz[prz[i]+1])=-1 then combobox2.Items.Add(nazwaprz[prz[i]+1]);
  combobox2.ItemIndex:=0;
  canvas.Font.size:=16;
  canvas.Brush.color:=clyellow;
  canvas.Rectangle(trunc(width*0.5)-55,trunc(height*0.5)-17,trunc(width*0.5)+55,trunc(height*0.5)+17);
  Canvas.textout(trunc(width*0.5)-48,trunc(height*0.5)-15,'Obliczanie');
  RowsPp1:=RowsPp;RowsPq1:=RowsPq;RowsPm1:=RowsPm;RowsPt1:=RowsPt;
  if jedenpunkt=1 then begin jedenpunkt:=0; Le:=Le-1; end;
  Lw1:=Lw; Le1:=Le; warianty1:=warianty;
  //kopiowanie prętów
  for i:=1 to Le do begin Wp1[i]:=Wp[i];Wk1[i]:=Wk[i];Typ1[i]:=typs[i];Prz1[i]:=Prz[i]; Lx1[i]:=Lx[i]; Ly1[i]:=Ly[i]; L1[i]:=L[i]; end;
  for i:=1 to Lw do begin Xw1[i]:=Xw[i]; Yw1[i]:=Yw[i]; end;
  Lw1:=Lw; Le1:=Le;
  for i:=1 to RowsPp1 do begin if Lx1[np[i]]<0 then P[i]:=-P[i]; np1[i]:=np[i]; xp1[i]:=xp[i] end;
  for i:=1 to RowsPq1 do begin if Lx1[nq[i]]<0 then begin Pqi[i]:=-Pqi[i]; Pqj[i]:=-Pqj[i]; end; nq1[i]:=nq[i]; xqi1[i]:=xqi[i]; xqj1[i]:=xqj[i];Pqj1[i]:=Pqj[i] end;
  for i:=1 to RowsPm1 do begin nm1[i]:=nm[i]; xm1[i]:=xm[i]; end;
  //usuwanie nadmiaru przegubów
  for i:=1 to Lw1 do begin macierzw[i]:=0; macierzp[i]:=0; macierzpod[i]:=0 end;
  for i:=1 to Le1 do begin inc(macierzw[Wp1[i]]); inc(macierzw[Wk1[i]]);           //ile jest prętów w każdym węźle
    if (Typ1[i]=2) or (Typ1[i]=4) then inc(macierzp[Wp1[i]]);                      //ile jest przegubów w każdym węźle
    if (Typ1[i]=3) or (Typ1[i]=4) then inc(macierzp[Wk1[i]]);
  end;
  for i:=1 to Lwar do if (rpod[i]<3) or (rpod[i]=4) then macierzpod[s[i]]:=1;      // czy w wezle jest podpora blokujaca obrot, jesli tak, to nie usuwamy tu przegubów
  for i:=1 to Lw1 do begin
    tak:=false;
    if (macierzw[i]=macierzp[i]) and (macierzpod[i]=0) then
    begin
      j:=0;
      repeat
        inc(j);
        if Wp1[j]=i then begin if Typ1[j]=2 then Typ1[j]:=1; if Typ1[j]=4 then Typ1[j]:=3; tak:=true; end;
        if (Wk1[j]=i) and (tak=false) then begin if Typ1[j]=3 then Typ1[j]:=1; if Typ1[j]=4 then Typ1[j]:=2; tak:=true; end;
      until tak=true;
    end;
  end;
  //dodanie węzłów linii Wpływu
  if tryb=45 then
  begin
    warianty1:=0;
    RowsPp1:=0;RowsPm1:=0;RowsPq1:=0;RowsPt1:=0;//przy okazji usunięcie obciążeń;
    form13x:=trunc(form13x*1000)/1000;
    if (form13x>0) and (form13x<1) then
     begin
       Lw1:=Lw1+2;
       Xw1[Lw1-1]:=Xw1[Wp1[pretlw]]+(Xw1[Wk1[pretlw]]-Xw1[Wp1[pretlw]])*form13x;
       Xw1[Lw1]:=Xw1[Lw1-1];
       Yw1[Lw1-1]:=Yw1[Wp1[pretlw]]+(Yw1[Wk1[pretlw]]-Yw1[Wp1[pretlw]])*form13x;
       Yw1[Lw1]:=Yw1[Lw1-1];
       Le1:=Le1+1;
       Prz1[Le1]:=Prz1[pretlw];
       Wk1[Le1]:=Wk1[pretlw];
       Wk1[pretlw]:=Lw1-1;
       Wp1[Le1]:=Lw1;
       typ1[Le1]:=1;
       if typ1[pretlw]=3 then begin typ1[pretlw]:=1; typ1[Le1]:=3; end;
       if typ1[pretlw]=4 then begin typ1[pretlw]:=2; typ1[Le1]:=3; end;
       Lx1[pretlw]:=Xw1[Wk1[pretlw]]-Xw1[Wp1[pretlw]];
       Ly1[pretlw]:=Yw1[Wk1[pretlw]]-Yw1[Wp1[pretlw]];
        L1[pretlw]:=sqrt(sqr(Lx1[pretlw])+sqr(Ly1[pretlw]));
       Lx1[Le1]:=Xw1[Wk1[Le1]]-Xw1[Wp1[Le1]];
       Ly1[Le1]:=Yw1[Wk1[Le1]]-Yw1[Wp1[Le1]];
        L1[Le1]:=sqrt(sqr(Lx1[Le1])+sqr(Ly1[Le1]));
        wezlw1:=Lw1-1;wezlw2:=Lw1;
     end;
    if form13x=0 then
     begin
       inc(Lw1);
       Xw1[Lw1]:=Xw1[Wp1[pretlw]];
       Yw1[Lw1]:=Yw1[Wp1[pretlw]];
       wezlw1:=Wp1[pretlw];
       Wp1[pretlw]:=Lw1;
       wezlw2:=Lw1;
     end;
    if form13x=1 then
     begin
       inc(Lw1);
       Xw1[Lw1]:=Xw1[Wk1[pretlw]];
       Yw1[Lw1]:=Yw1[Wk1[pretlw]];
       wezlw1:=Wk1[pretlw];
       Wk1[pretlw]:=Lw1;
       wezlw2:=Lw1;
     end;
  end;
  //podzial pretow dla statecznosci
  if tryb=50 then
    for i:=1 to Le do
    begin
      Lpodz:=8;
      Lw1:=Lw1+Lpodz-1;
      Le1:=Le1+Lpodz-1;
      for j:=1 to Lpodz-1 do Xw1[Lw1-Lpodz+j+1]:=(Xw1[Wk1[i]]-Xw1[Wp1[i]])*j/Lpodz+Xw1[Wp1[i]];
      for j:=1 to Lpodz-1 do Yw1[Lw1-Lpodz+j+1]:=(Yw1[Wk1[i]]-Yw1[Wp1[i]])*j/Lpodz+Yw1[Wp1[i]];
      for j:=1 to Lpodz-2 do begin Wp1[Le1-Lpodz+j+1]:=Lw1-Lpodz+j+1; Wk1[Le1-Lpodz+j+1]:=Lw1-Lpodz+j+2; end;
      Wp1[Le1]:=Lw1;     Wk1[Le1]:=Wk[i];
      Wk1[i]:=Lw1-Lpodz+2;
      Lx1[i]:=Lx1[i]/Lpodz; Ly1[i]:=Ly1[i]/Lpodz;  L1[i]:=L1[i]/Lpodz;
      for j:=1 to Lpodz-1 do Prz1[Le1-Lpodz+j+1]:=Prz1[i];
      for j:=1 to Lpodz-1 do Lx1[Le1-Lpodz+j+1]:=Lx1[i];
      for j:=1 to Lpodz-1 do Ly1[Le1-Lpodz+j+1]:=Ly1[i];
      for j:=1 to Lpodz-1 do L1[Le1-Lpodz+j+1]:=L1[i];
      for j:=1 to Lpodz-1 do Typ1[Le1-Lpodz+j+1]:=1;
      if (Typ1[i]=4) or (Typ1[i]=3) then Typ1[Le1]:=3;
      if (Typ1[i]=4) or (Typ1[i]=2) then Typ1[i]:=2 else Typ1[i]:=1;
      for j:=1 to RowsPp do if (np[j]=i) and (xp[j]=1) then np[j]:=Le1;
      for j:=1 to RowsPm do if (nm[j]=i) and (xm[j]=1) then nm[j]:=Le1;
      for j:=1 to RowsPq do if (nq[j]=i) then
      begin
        RowsPq1:=RowsPq1+Lpodz-1;
        for k:=1 to Lpodz-1 do nq[RowsPq1-Lpodz+k+1]:=Le1-Lpodz+k+1;
        for k:=1 to Lpodz-1 do xqi[RowsPq1-Lpodz+k+1]:=0;
        for k:=1 to Lpodz-1 do xqj[RowsPq1-Lpodz+k+1]:=1;
        for k:=1 to Lpodz-1 do alfaq[RowsPq1-Lpodz+k+1]:=alfaq[j];
        for k:=1 to Lpodz-1 do Pqi[RowsPq1-Lpodz+k+1]:=Pqi[j]*(Lpodz-k)/Lpodz+Pqj[j]*k/Lpodz;
        for k:=1 to Lpodz-1 do Pqj[RowsPq1-Lpodz+k+1]:=Pqi[j]*(Lpodz-k-1)/Lpodz+Pqj[j]*(k+1)/Lpodz;
        Pqj[j]:=Pqi[j]*(Lpodz-1)/Lpodz+Pqj[j]/Lpodz;
      end;
      for j:=1 to RowsPt do if nt[j]=i then
      begin
        RowsPt1:=RowsPt1+Lpodz-1;
        for k:=1 to Lpodz-1 do nt[RowsPt1-Lpodz+k+1]:=Le1-Lpodz+k+1;
        for k:=1 to Lpodz-1 do td[RowsPq1-Lpodz+k+1]:=td[j];
        for k:=1 to Lpodz-1 do tg[RowsPq1-Lpodz+k+1]:=tg[j];
      end;
    end;
  //symulacja
  Lss:=3;
  Lr:=Lss*Lw1;
  if rozbijobc=true then warianty1:=5;
  if tryb=50 then warianty1:=0;
  for i:=1 to Le1 do czyrysowac[i]:=true;
  for x:=0 to warianty1 do
  begin
    Lwar1:=0;
    for j:=1 to Lr do fipod2[j]:=0;                             //nowe podpory
    for i:=1 to Lwar do
    case rpod[i] of
      1:begin inc(Lwar1); s1[Lwar1]:=s[i]*3; DWB[Lwar1]:=DM[i];KWB[Lwar1]:=KM[i]; wariantPod1[Lwar1]:=wariantpod[i,x];  end;
      2:begin inc(Lwar1); s1[Lwar1]:=s[i]*3-2; fipod2[s1[lwar1]]:=fipod[i]; DWB[Lwar1]:=Dh[i];KWB[Lwar1]:=Kh[i]; wariantPod1[Lwar1]:=wariantPod[i,x]; inc(Lwar1); s1[Lwar1]:=s[i]*3-1; fipod2[s1[lwar1]]:=fipod[i]; DWB[Lwar1]:=DV[i];KWB[Lwar1]:=Kv[i]; wariantPod1[Lwar1]:=wariantPod[i,x]; inc(Lwar1); s1[Lwar1]:=s[i]*3; DWB[Lwar1]:=DM[i];KWB[Lwar1]:=KM[i]; wariantPod1[Lwar1]:=wariantPod[i,x]; end;
      3:begin inc(Lwar1); s1[Lwar1]:=s[i]*3-2; fipod2[s1[lwar1]]:=fipod[i]; DWB[Lwar1]:=Dh[i];KWB[Lwar1]:=Kh[i]; wariantPod1[Lwar1]:=wariantPod[i,x]; inc(Lwar1); s1[Lwar1]:=s[i]*3-1; fipod2[s1[lwar1]]:=fipod[i]; DWB[Lwar1]:=DV[i];KWB[Lwar1]:=Kv[i]; wariantPod1[Lwar1]:=wariantPod[i,x]; end;
      4:begin inc(Lwar1); s1[Lwar1]:=s[i]*3-1; fipod2[s1[lwar1]]:=fipod[i]; fipod2[s1[lwar1]-1]:=fipod[i]; DWB[Lwar1]:=Dv[i];KWB[Lwar1]:=KV[i]; wariantPod1[Lwar1]:=wariantPod[i,x]; inc(Lwar1); s1[Lwar1]:=s[i]*3; DWB[Lwar1]:=DM[i];KWB[Lwar1]:=KM[i]; wariantPod1[Lwar1]:=wariantPod[i,x]; end;
      5:begin inc(Lwar1); s1[Lwar1]:=s[i]*3-1; fipod2[s1[lwar1]]:=fipod[i]; fipod2[s1[lwar1]-1]:=fipod[i]; DWB[Lwar1]:=Dv[i];KWB[Lwar1]:=Kv[i]; wariantPod1[Lwar1]:=wariantPod[i,x]; end;
    end;
    for i:=1 to Lr do
     for j:=1 to Lr do
      begin K0[i,j]:=0; Kr[i,j]:=0; end;
    for i:=1 to Lr do
     p0[i]:=0;
    for i:=1 to 3 do
      for j:=1 to 3 do
        for k:=1 to Le1 do
        begin
          Rk[i,j,k]:=0;Rp[i,j,k]:=0;R[i,j,k]:=0;G[i,j,k]:=0;F[i,j,k]:=0;Z[i,j,k]:=0;
        end;
    for i:=1 to Le1 do
    begin
      Atemp[i]:=Ai[Prz1[i]+1];
      if checkbox1.checked=True then Pole[i]:=Atemp[i] else Pole[i]:=1000000*Atemp[i];
      Jx[i]:=Ji[Prz1[i]+1];
      E[i]:=Ei[Prz1[i]+1];
      at[i]:=ati[Prz1[i]+1];
      wys[i]:=ii[Prz1[i]+1];
      h[i]:=hi[Prz1[i]+1];
      R[1,1,i]:=Lx1[i]/L1[i];R[1,2,i]:=-Ly1[i]/L1[i];
      R[2,1,i]:=Ly1[i]/L1[i];R[2,2,i]:=Lx1[i]/L1[i];
      R[3,3,i]:=1;
      //Typ1 4 i kazdy inny
      G[1,1,i]:=Pole[i]*E[i]/L1[i];
      F[1,1,i]:=-Pole[i]*E[i]/L1[i];
      Z[1,1,i]:=Pole[i]*E[i]/L1[i];
      if Typ1[i]=3 then
      begin
        G[2,2,i]:=3*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
        G[2,3,i]:=-3*Jx[i]*E[i]/L1[i]/L1[i];
        G[3,2,i]:=-3*Jx[i]*E[i]/L1[i]/L1[i];
        G[3,3,i]:=3*Jx[i]*E[i]/L1[i];
        F[2,2,i]:=-3*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
        F[3,2,i]:=3*Jx[i]*E[i]/L1[i]/L1[i];
        Z[2,2,i]:=3*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
      end;
      if Typ1[i]=2 then
      begin
        Z[2,2,i]:=3*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
        Z[2,3,i]:=3*Jx[i]*E[i]/L1[i]/L1[i];
        Z[3,2,i]:=3*Jx[i]*E[i]/L1[i]/L1[i];
        Z[3,3,i]:=3*Jx[i]*E[i]/L1[i];
        F[2,2,i]:=-3*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
        F[2,3,i]:=-3*Jx[i]*E[i]/L1[i]/L1[i];
        G[2,2,i]:=3*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
      end;
      if Typ1[i]=1 then
      begin
        G[2,2,i]:=12*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
        G[2,3,i]:=-6*Jx[i]*E[i]/L1[i]/L1[i];
        G[3,2,i]:=-6*Jx[i]*E[i]/L1[i]/L1[i];
        G[3,3,i]:=4*Jx[i]*E[i]/L1[i];
        F[2,2,i]:=-12*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
        F[2,3,i]:=-6*Jx[i]*E[i]/L1[i]/L1[i];
        F[3,2,i]:=6*Jx[i]*E[i]/L1[i]/L1[i];
        F[3,3,i]:=2*Jx[i]*E[i]/L1[i];
        Z[2,2,i]:=12*Jx[i]*E[i]/L1[i]/L1[i]/L1[i];
        Z[2,3,i]:=6*Jx[i]*E[i]/L1[i]/L1[i];
        Z[3,2,i]:=6*Jx[i]*E[i]/L1[i]/L1[i];
        Z[3,3,i]:=4*Jx[i]*E[i]/L1[i];
      end;
      for j:=1 to 3 do
        for k:=1 to 3 do
          begin
            D2[j,k,i]:=R[j,1,i]*G[1,k,i]+R[j,2,i]*G[2,k,i]+R[j,3,i]*G[3,k,i];
            C2[j,k,i]:=R[j,1,i]*F[1,k,i]+R[j,2,i]*F[2,k,i]+R[j,3,i]*F[3,k,i];
            B2[j,k,i]:=R[j,1,i]*Z[1,k,i]+R[j,2,i]*Z[2,k,i]+R[j,3,i]*Z[3,k,i];
          end;
      for j:=1 to 3 do
        for k:=1 to 3 do
          begin
            D3[j,k,i]:=D2[j,1,i]*R[k,1,i]+D2[j,2,i]*R[k,2,i]+D2[j,3,i]*R[k,3,i];
            C3[j,k,i]:=C2[j,1,i]*R[k,1,i]+C2[j,2,i]*R[k,2,i]+C2[j,3,i]*R[k,3,i];
            B3[j,k,i]:=B2[j,1,i]*R[k,1,i]+B2[j,2,i]*R[k,2,i]+B2[j,3,i]*R[k,3,i];
          end;
      pa[i]:=Lss*Wp1[i]-2;
      ka[i]:=Lss*Wk1[i]-2;
      for j:=1 to 3 do
        for k:=1 to 3 do          //agregacja
          begin
            K0[pa[i]+j-1,pa[i]+k-1]:=K0[pa[i]+j-1,pa[i]+k-1]+D3[j,k,i];
            K0[ka[i]+j-1,ka[i]+k-1]:=K0[ka[i]+j-1,ka[i]+k-1]+B3[j,k,i];
            K0[pa[i]+j-1,ka[i]+k-1]:=K0[pa[i]+j-1,ka[i]+k-1]+C3[j,k,i];
            K0[ka[i]+j-1,pa[i]+k-1]:=K0[ka[i]+j-1,pa[i]+k-1]+C3[k,j,i];
          end;
    end;
    //obroty podpor
    for i:=1 to Le1 do
      begin
        Rp[1,1,i]:=cos(fipod2[pa[i]]*pi/180);Rp[1,2,i]:=-sin(fipod2[pa[i]]*pi/180);
        Rp[2,1,i]:=sin(fipod2[pa[i]]*pi/180);Rp[2,2,i]:=cos(fipod2[pa[i]]*pi/180);
        Rp[3,3,i]:=1;
        Rk[1,1,i]:=cos(fipod2[ka[i]]*pi/180);Rk[1,2,i]:=-sin(fipod2[ka[i]]*pi/180);
        Rk[2,1,i]:=sin(fipod2[ka[i]]*pi/180);Rk[2,2,i]:=cos(fipod2[ka[i]]*pi/180);
        Rk[3,3,i]:=1;
      for j:=1 to 3 do
        for k:=1 to 3 do
          begin
            D2[j,k,i]:=Rp[j,1,i]*D3[1,k,i]+Rp[j,2,i]*D3[2,k,i]+Rp[j,3,i]*D3[3,k,i];
            C2[j,k,i]:=Rp[j,1,i]*C3[1,k,i]+Rp[j,2,i]*C3[2,k,i]+Rp[j,3,i]*C3[3,k,i];
            B2[j,k,i]:=Rk[j,1,i]*B3[1,k,i]+Rk[j,2,i]*B3[2,k,i]+Rk[j,3,i]*B3[3,k,i];
          end;
      for j:=1 to 3 do
        for k:=1 to 3 do
          begin
            G[j,k,i]:=D2[j,1,i]*Rp[k,1,i]+D2[j,2,i]*Rp[k,2,i]+D2[j,3,i]*Rp[k,3,i];
            F[j,k,i]:=C2[j,1,i]*Rk[k,1,i]+C2[j,2,i]*Rk[k,2,i]+C2[j,3,i]*Rk[k,3,i];
            Z[j,k,i]:=B2[j,1,i]*Rk[k,1,i]+B2[j,2,i]*Rk[k,2,i]+B2[j,3,i]*Rk[k,3,i];
          end;
      for j:=1 to 3 do
        for k:=1 to 3 do          //agregacja
          begin
            Kr[pa[i]+j-1,pa[i]+k-1]:=Kr[pa[i]+j-1,pa[i]+k-1]+G[j,k,i];
            Kr[ka[i]+j-1,ka[i]+k-1]:=Kr[ka[i]+j-1,ka[i]+k-1]+Z[j,k,i];
            Kr[pa[i]+j-1,ka[i]+k-1]:=Kr[pa[i]+j-1,ka[i]+k-1]+F[j,k,i];
            Kr[ka[i]+j-1,pa[i]+k-1]:=Kr[ka[i]+j-1,pa[i]+k-1]+F[k,j,i];
          end;
    end;
    //definiowanie wektora obciazen
    For i:=1 to Le1 do
      begin
        Npp[i]:=0;Tpp[i]:=0;Mpp[i]:=0;Nkp[i]:=0;Tkp[i]:=0;Mkp[i]:=0;
        Npq[i]:=0;Tpq[i]:=0;Mpq[i]:=0;Nkq[i]:=0;Tkq[i]:=0;Mkq[i]:=0;
        Tpm[i]:=0;Mpm[i]:=0;Tkm[i]:=0;Mkm[i]:=0;
        Npt[i]:=0;Tpt[i]:=0;Mpt[i]:=0;Nkt[i]:=0;Tkt[i]:=0;Mkt[i]:=0;
      end;
    //ciezar wlasny
    rowspq1:=rowspq;
    if wariantwlasny[x]=true then for i:=1 to Le do
    begin
      inc(RowsPq1);
      xqi[RowsPq1]:=0;xqj[RowsPq1]:=1;alfaq[RowsPq1]:=0;nq[RowsPq1]:=i;
      Pqi[RowsPq1]:=trunc(gi[prz[i]+1]*Ai[prz[i]+1]*9.807*1000)/1000;
      Pqj[RowsPq1]:=Pqi[RowsPq1];
      wariantQ[Rowspq1,x]:=true;
    end;
    //sily skupione
    for i:=1 to rowsPp1 do if (wariantP[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then
      begin
        Npp[np[i]]:=Npp[np[i]]-P[i]*sin(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wp0(xp[i]);
        Nkp[np[i]]:=Nkp[np[i]]-P[i]*sin(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wk0(xp[i]);
        case Typ1[np[i]] of
          4:begin Tpp[np[i]]:=Tpp[np[i]]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wp4(xp[i]);
                  Tkp[np[i]]:=Tkp[np[i]]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wk4(xp[i]);end;
          3:begin Tpp[np[i]]:=Tpp[np[i]]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wp3(xp[i]);
                  Tkp[np[i]]:=Tkp[np[i]]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wk3(xp[i]);
                  Mpp[np[i]]:=Mpp[np[i]]+P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wpm3(xp[i])*L1[np[i]];end;
          2:begin Tpp[np[i]]:=Tpp[np[i]]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wp2(xp[i]);
                  Tkp[np[i]]:=Tkp[np[i]]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wk2(xp[i]);
                  Mkp[np[i]]:=Mkp[np[i]]+P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wkm2(xp[i])*L1[np[i]];end;
          1:begin Tpp[np[i]]:=Tpp[np[i]]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wp0(xp[i]);
                  Tkp[np[i]]:=Tkp[np[i]]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wk0(xp[i]);
                  Mpp[np[i]]:=Mpp[np[i]]+P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wpm1(xp[i])*L1[np[i]];
                  Mkp[np[i]]:=Mkp[np[i]]+P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*wkm1(xp[i])*L1[np[i]];end;
        end;
      end;
    //momenty
    for i:=1 to rowsPm1 do if (wariantM[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then
      begin
        case Typ1[nm[i]] of
          4:begin Tpm[nm[i]]:=Tpm[nm[i]]+Pm[i]/L1[nm[i]];
                  Tkm[nm[i]]:=Tkm[nm[i]]-Pm[i]/L1[nm[i]];end;
          3:begin Tpm[nm[i]]:=Tpm[nm[i]]-Pm[i]/L1[nm[i]]*op3(xm[i]);
                  Tkm[nm[i]]:=Tkm[nm[i]]-Pm[i]/L1[nm[i]]*ok3(xm[i]);
                  Mpm[nm[i]]:=Mpm[nm[i]]+Pm[i]*opm3(xm[i]);end;
          2:begin Tpm[nm[i]]:=Tpm[nm[i]]-Pm[i]/L1[nm[i]]*op2(xm[i]);
                  Tkm[nm[i]]:=Tkm[nm[i]]-Pm[i]/L1[nm[i]]*ok2(xm[i]);
                  Mkm[nm[i]]:=Mkm[nm[i]]+Pm[i]*okm2(xm[i]);end;
          1:begin Tpm[nm[i]]:=Tpm[nm[i]]-Pm[i]/L1[nm[i]]*op1(xm[i]);
                  Tkm[nm[i]]:=Tkm[nm[i]]-Pm[i]/L1[nm[i]]*ok1(xm[i]);
                  Mpm[nm[i]]:=Mpm[nm[i]]+Pm[i]*opm1(xm[i]);
                  Mkm[nm[i]]:=Mkm[nm[i]]+Pm[i]*okm1(xm[i]);end;
        end;
      end;
    //rownomiernie rozlozone
    for i:=1 to rowsPq1 do if (wariantQ[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then
      begin
        //ten caly fragment jest do liczenia Nqp
        calkaP:=wp0(xqi[i])*Pq(xqi[i])+wp0(xqj[i])*Pq(xqj[i]);
        for j:=1 to 9 do
          calkaP:=calkaP+2*(wp0(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
        for j:=1 to 10 do
          calkaP:=calkaP+4*(wp0(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
        calkaP:=calkaP*(xqj[i]-xqi[i])/60;
        Npq[nq[i]]:=Npq[nq[i]]+L1[nq[i]]*sin(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkaP;
        calkak:=wk0(xqi[i])*Pq(xqi[i])+wk0(xqj[i])*Pq(xqj[i]);
        for j:=1 to 9 do
          calkak:=calkak+2*(wk0(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
        for j:=1 to 10 do
          calkak:=calkak+4*(wk0(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
        calkak:=calkak*(xqj[i]-xqi[i])/60;
        Nkq[nq[i]]:=Nkq[nq[i]]+L1[nq[i]]*sin(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkak;
        case Typ1[nq[i]] of
          1:begin Tpq[nq[i]]:=Tpq[nq[i]]+L1[nq[i]]*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkaP;
            Tkq[nq[i]]:=Tkq[nq[i]]+L1[nq[i]]*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkak;
            calkaP:=wpm1(xqi[i])*Pq(xqi[i])+wpm1(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkaP:=calkaP+2*(wpm1(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkaP:=calkaP+4*(wpm1(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkaP:=calkaP*(xqj[i]-xqi[i])/60;
             Mpq[nq[i]]:=Mpq[nq[i]]-sqr(L1[nq[i]])*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkaP;
            calkak:=wkm1(xqi[i])*Pq(xqi[i])+wkm1(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkak:=calkak+2*(wkm1(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkak:=calkak+4*(wkm1(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkak:=calkak*(xqj[i]-xqi[i])/60;
             Mkq[nq[i]]:=Mkq[nq[i]]-sqr(L1[nq[i]])*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkak;end;
          2:begin calkaP:=wp2(xqi[i])*Pq(xqi[i])+wp2(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkaP:=calkaP+2*(wp2(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkaP:=calkaP+4*(wp2(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkaP:=calkaP*(xqj[i]-xqi[i])/60;
             Tpq[nq[i]]:=Tpq[nq[i]]+L1[nq[i]]*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkaP;
            calkak:=wk2(xqi[i])*Pq(xqi[i])+wk2(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkak:=calkak+2*(wk2(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkak:=calkak+4*(wk2(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkak:=calkak*(xqj[i]-xqi[i])/60;
             Tkq[nq[i]]:=Tkq[nq[i]]+L1[nq[i]]*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkak;
            calkak:=wkm2(xqi[i])*Pq(xqi[i])+wkm2(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkak:=calkak+2*(wkm2(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkak:=calkak+4*(wkm2(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkak:=calkak*(xqj[i]-xqi[i])/60;
             Mkq[nq[i]]:=Mkq[nq[i]]-sqr(L1[nq[i]])*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkak;end;
          3:begin calkaP:=wp3(xqi[i])*Pq(xqi[i])+wp3(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkaP:=calkaP+2*(wp3(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkaP:=calkaP+4*(wp3(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkaP:=calkaP*(xqj[i]-xqi[i])/60;
             Tpq[nq[i]]:=Tpq[nq[i]]+L1[nq[i]]*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkaP;
            calkak:=wk3(xqi[i])*Pq(xqi[i])+wk3(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkak:=calkak+2*(wk3(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkak:=calkak+4*(wk3(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkak:=calkak*(xqj[i]-xqi[i])/60;
             Tkq[nq[i]]:=Tkq[nq[i]]+L1[nq[i]]*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkak;
            calkaP:=wpm3(xqi[i])*Pq(xqi[i])+wkm2(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkaP:=calkaP+2*(wpm3(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkaP:=calkaP+4*(wpm3(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkaP:=calkaP*(xqj[i]-xqi[i])/60;
             Mpq[nq[i]]:=Mpq[nq[i]]-sqr(L1[nq[i]])*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkaP;end;
          4:begin calkaP:=wp4(xqi[i])*Pq(xqi[i])+wp4(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkaP:=calkaP+2*(wp4(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkaP:=calkaP+4*(wp4(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkaP:=calkaP*(xqj[i]-xqi[i])/60;
             Tpq[nq[i]]:=Tpq[nq[i]]+L1[nq[i]]*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkaP;
            calkak:=wk4(xqi[i])*Pq(xqi[i])+wk4(xqj[i])*Pq(xqj[i]);
             for j:=1 to 9 do
              calkak:=calkak+2*(wk4(xqi[i]+j/10*(xqj[i]-xqi[i]))*Pq(xqi[i]+j/10*(xqj[i]-xqi[i])));
             for j:=1 to 10 do
              calkak:=calkak+4*(wk4(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i]))*Pq(xqi[i]+(2*j-1)/20*(xqj[i]-xqi[i])));
             calkak:=calkak*(xqj[i]-xqi[i])/60;
             Tkq[nq[i]]:=Tkq[nq[i]]+L1[nq[i]]*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*calkak;end;
        end;
      end;
    //temperatury
    for i:=1 to rowsPt1 do if (wariantT[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=2) or (x=3))) then
      begin
        T0[i]:=Td[i]+wys[nt[i]]/h[nt[i]]*(Tg[i]-Td[i]);
        DT[i]:=Td[i]-Tg[i];
        if (x=2) and (rozbijobc=true) then DT[i]:=0;
        if (x=3) and (rozbijobc=true) then T0[i]:=0;
        Npt[nt[i]]:=Npt[nt[i]]-at[nt[i]]*E[nt[i]]*Pole[nt[i]]*T0[i];
        Nkt[nt[i]]:=Nkt[nt[i]]+at[nt[i]]*E[nt[i]]*Pole[nt[i]]*T0[i];
        case Typ1[nt[i]] of
          3:begin Tpt[nt[i]]:=Tpt[nt[i]]-3/2*at[nt[i]]*E[nt[i]]*Jx[nt[i]]*DT[i]/h[nt[i]]/L1[nt[i]];
                  Tkt[nt[i]]:=Tkt[nt[i]]+3/2*at[nt[i]]*E[nt[i]]*Jx[nt[i]]*DT[i]/h[nt[i]]/L1[nt[i]];
                  Mpt[nt[i]]:=Mpt[nt[i]]+3/2*at[nt[i]]*E[nt[i]]*Jx[nt[i]]*DT[i]/h[nt[i]];end;
          2:begin Tpt[nt[i]]:=Tpt[nt[i]]+3/2*at[nt[i]]*E[nt[i]]*Jx[nt[i]]*DT[i]/h[nt[i]]/L1[nt[i]];
                  Tkt[nt[i]]:=Tkt[nt[i]]-3/2*at[nt[i]]*E[nt[i]]*Jx[nt[i]]*DT[i]/h[nt[i]]/L1[nt[i]];
                  Mkt[nt[i]]:=Mkt[nt[i]]-3/2*at[nt[i]]*E[nt[i]]*Jx[nt[i]]*DT[i]/h[nt[i]];end;
          1:begin Mpt[nt[i]]:=Mpt[nt[i]]+at[nt[i]]*E[nt[i]]*Jx[nt[i]]*DT[i]/h[nt[i]];
                  Mkt[nt[i]]:=Mkt[nt[i]]-at[nt[i]]*E[nt[i]]*Jx[nt[i]]*DT[i]/h[nt[i]];end;
        end;
      end;
    //sumowanie obciazen od wektora
    for i:=1 to Le1 do
      begin
        p0[pa[i]]:=p0[pa[i]]+(Npp[i]+Npq[i]+Npt[i])*Lx1[i]/L1[i]-(Tpp[i]+Tpq[i]+Tpt[i]+Tpm[i])*Ly1[i]/L1[i];
        p0[pa[i]+1]:=p0[pa[i]+1]+(Npp[i]+Npq[i]+Npt[i])*Ly1[i]/L1[i]+(Tpp[i]+Tpq[i]+Tpt[i]+Tpm[i])*Lx1[i]/L1[i];
        p0[pa[i]+2]:=p0[pa[i]+2]+Mpp[i]+Mpm[i]+Mpq[i]+Mpt[i];
        p0[ka[i]]:=p0[ka[i]]+(Nkp[i]+Nkq[i]+Nkt[i])*Lx1[i]/L1[i]-(Tkp[i]+Tkq[i]+Tkt[i]+Tkm[i])*Ly1[i]/L1[i];
        p0[ka[i]+1]:=p0[ka[i]+1]+(Nkp[i]+Nkq[i]+Nkt[i])*Ly1[i]/L1[i]+(Tkp[i]+Tkq[i]+Tkt[i]+Tkm[i])*Lx1[i]/L1[i];
        p0[ka[i]+2]:=p0[ka[i]+2]+Mkp[i]+Mkm[i]+Mkq[i]+Mkt[i];
      end;
    //warunki brzegowe
    for i:=1 to Lwar1 do
      begin
        if (KWB[i]<>0) and ((wariantPod1[i]=true) or ((rozbijobc=true) and ((x=0) or (x=5)))) then
          Kr[s1[i],s1[i]]:=Kr[s1[i],s1[i]]+KWB[i]
          else
          begin
            for j:=1 to Lr do Kr[s1[i],j]:=0;
            Kr[s1[i],s1[i]]:=1;
          end;
        end;
    for i:=1 to Lw1 do
      begin
        pr[3*i-2]:=p0[3*i-2]*cos(fipod2[3*i-2]*pi/180)-p0[3*i-1]*sin(fipod2[3*i-1]*pi/180);
        pr[3*i-1]:=p0[3*i-2]*sin(fipod2[3*i-2]*pi/180)+p0[3*i-1]*cos(fipod2[3*i-1]*pi/180);
        pr[3*i]:=p0[3*i];
      end;
    for i:=1 to Lwar1 do
      if (KWB[i]<>0) and ((wariantPod1[i]=true) or ((rozbijobc=true) and (x=0))) then
      pr[s1[i]]:=DWB[i]*KWB[i]+pr[s1[i]]
      else
      begin if (wariantPod1[i]=true) or ((rozbijobc=true) and ((x=0) or (x=4))) then pr[s1[i]]:=DWB[i] else pr[s1[i]]:=0; end;
    //dodawnie warunków linii wpływu
    if tryb=45 then
    begin
     for i:=1 to Lr do pr[i]:=0;
     for i:=1 to Lr do for j:=3*wezlw2-2 to 3*wezlw2 do Kr[j,i]:=Kr[j,i]+Kr[j+wezlw1*3-wezlw2*3,i];
     for i:=1 to Lr do for j:=3*wezlw2-2 to 3*wezlw2 do Kr[j+wezlw1*3-wezlw2*3,i]:=0;
     Kr[wezlw1*3-2,wezlw1*3-2]:=1;
     Kr[wezlw1*3-1,wezlw1*3-1]:=1;
     Kr[wezlw1*3,wezlw1*3]:=1;
     Kr[wezlw1*3-2,wezlw2*3-2]:=-1;
     Kr[wezlw1*3-1,wezlw2*3-1]:=-1;
     Kr[wezlw1*3,wezlw2*3]:=-1;
    end;
    odliczanie:=0;
    if tryb=45 then odliczanie:=3;
    repeat
      if tryb=45 then begin
       if odliczanie=3 then begin pr[wezlw1*3-2]:=0; pr[wezlw1*3-1]:=0; pr[wezlw1*3]:=1; end;
       if odliczanie=2 then begin pr[wezlw1*3-2]:=Ly[pretlw]/L[pretlw]; pr[wezlw1*3-1]:=-Lx[pretlw]/L[pretlw]; pr[wezlw1*3]:=0; end;
       if odliczanie=1 then begin pr[wezlw1*3-2]:=Lx[pretlw]/L[pretlw]; pr[wezlw1*3-1]:=Ly[pretlw]/L[pretlw]; pr[wezlw1*3]:=0; end;
      end;
      if form13x=1 then for i:=1 to Lr do pr[i]:=-pr[i];
      for i:=1 to Lr do for j:=1 to Lr do Kr1[i,j]:=Kr[i,j];
      //sprawdzenie czy jest geometrycznie zmienny
      if (x=0) and (odliczanie<=1) then
      begin
        for i:=1 to Lr do pr1[i]:=Lr/2-i;
        ukladrownan;
        max:=0;
        for i:=1 to Lr do if abs(ur[i])>max then max:=abs(ur[i]);
        if max>1e4 then begin  buttonselected:=MessageDlg('Ostrzeżenie', 'Układ jest geometrycznie zmienny lub przesadnie duży'+slinebreak+'Czy chcesz mimo to kontynuować? Wyniki nie będą prawidłowe.', mtConfirmation, [mbYes, mbNo],0);
                               if buttonselected = MrNo then begin tbPowrot.Click; powrotobciazen; rysuj; form1.show; exit end;
                               if buttonselected = mryes then form1.show;
        end;
      end;
      //rozwiazanie ukladu rownan
      for i:=1 to Lr do for j:=1 to Lr do Kr1[i,j]:=Kr[i,j];
      for i:=1 to Lr do pr1[i]:=pr[i];
      ukladrownan;
      //dostosowanie do wspolzednych globalnych
      for i:=1 to Lw1 do
        begin
          u[3*i-2]:=ur[3*i-2]*cos(fipod2[3*i-2]*pi/180)+ur[3*i-1]*sin(fipod2[3*i-1]*pi/180);
          u[3*i-1]:=-ur[3*i-2]*sin(fipod2[3*i-2]*pi/180)+ur[3*i-1]*cos(fipod2[3*i-1]*pi/180);
          u[3*i]:=ur[3*i];
        end;
      //reakcje
      for i:=1 to Lr do
       begin
        reakr[i]:=0;
        for j:=1 to Lr do
          reakr[i]:=reakr[i]+K0[i,j]*u[j];
        reakr[i]:=reakr[i]-p0[i];
       end;
      for i:=1 to Lw1 do
        begin
          reak[3*i-2,x]:=reakr[3*i-2]*sin(fipod2[3*i-2]*pi/180)+reakr[3*i-1]*cos(fipod2[3*i-1]*pi/180);
          reak[3*i-1,x]:=reakr[3*i-2]*cos(fipod2[3*i-2]*pi/180)-reakr[3*i-1]*sin(fipod2[3*i-1]*pi/180);
          reak[3*i,x]:=reakr[3*i];
        end;
      //modyfikacja obrotów w przegubach
      for i:=1 to Le1 do
       begin
        fii[i]:=0;fij[i]:=0;
        if Typ1[i]=4 then
         begin
           fii[i]:=((u[pa[i]+1]-u[ka[i]+1])*Lx1[i]+(u[ka[i]]-u[pa[i]])*Ly1[i])/(sqr(L1[i])+(u[ka[i]+1]-u[pa[i]+1])*Ly1[i]+(u[ka[i]]-u[pa[i]])*Lx1[i]);
           fij[i]:=fii[i];
         end
         else
         begin
           fii[i]:=u[pa[i]+2];fij[i]:=u[ka[i]+2];
         end;
       end;
      //sily wewnetrzne
      for i:=1 to Le1 do
        begin
         Ni[i]:=E[i]*Pole[i]/L1[i]/L1[i]*((u[ka[i]]-u[pa[i]])*Lx1[i]+(u[ka[i]+1]-u[pa[i]+1])*Ly1[i]);
         Ti[i]:=0; Mi[i]:=0; Mj[i]:=0;
         case Typ1[i] of
          1:begin Ti[i]:=12*E[i]*Jx[i]/L1[i]/L1[i]/L1[i]/L1[i]*((u[ka[i]]-u[pa[i]])*Ly1[i]+(u[pa[i]+1]-u[ka[i]+1])*Lx1[i])-6*E[i]*Jx[i]/L1[i]/L1[i]*(u[pa[i]+2]+u[ka[i]+2]);
                  Mi[i]:=-6*E[i]*Jx[i]/L1[i]/L1[i]/L1[i]*((u[ka[i]]-u[pa[i]])*Ly1[i]+(u[pa[i]+1]-u[ka[i]+1])*Lx1[i])+2*E[i]*Jx[i]/L1[i]*(2*u[pa[i]+2]+u[ka[i]+2]);
                  Mj[i]:=6*E[i]*Jx[i]/L1[i]/L1[i]/L1[i]*((u[ka[i]]-u[pa[i]])*Ly1[i]+(u[pa[i]+1]-u[ka[i]+1])*Lx1[i])-2*E[i]*Jx[i]/L1[i]*(u[pa[i]+2]+2*u[ka[i]+2]);end;
          2:begin Ti[i]:=3*E[i]*Jx[i]/L1[i]/L1[i]/L1[i]/L1[i]*((u[ka[i]]-u[pa[i]])*Ly1[i]+(u[pa[i]+1]-u[ka[i]+1])*Lx1[i])-3*E[i]*Jx[i]/L1[i]/L1[i]*u[ka[i]+2];
                  Mj[i]:=3*E[i]*Jx[i]/L1[i]/L1[i]/L1[i]*((u[ka[i]]-u[pa[i]])*Ly1[i]+(u[pa[i]+1]-u[ka[i]+1])*Lx1[i])-3*E[i]*Jx[i]/L1[i]*u[ka[i]+2];end;
          3:begin Ti[i]:=3*E[i]*Jx[i]/L1[i]/L1[i]/L1[i]/L1[i]*((u[ka[i]]-u[pa[i]])*Ly1[i]+(u[pa[i]+1]-u[ka[i]+1])*Lx1[i])-3*E[i]*Jx[i]/L1[i]/L1[i]*u[pa[i]+2];
                  Mi[i]:=-3*E[i]*Jx[i]/L1[i]/L1[i]/L1[i]*((u[ka[i]]-u[pa[i]])*Ly1[i]+(u[pa[i]+1]-u[ka[i]+1])*Lx1[i])+3*E[i]*Jx[i]/L1[i]*u[pa[i]+2];end;
         end;
         Ni[i]:=Ni[i]+Npp[i]+Npq[i]+Npt[i];
         Nj[i]:=Ni[i]-Nkp[i]-Nkq[i]-Nkt[i];
         Ti[i]:=Ti[i]-Tpp[i]-Tpq[i]-Tpm[i]-Tpt[i];
         Tj[i]:=Ti[i]+Tkp[i]+Tkq[i]+Tkm[i]+Tkt[i];
         Mi[i]:=Mi[i]-Mpp[i]-Mpq[i]-Mpm[i]-Mpt[i];
         Mj[i]:=Mj[i]+Mkp[i]+Mkq[i]+Mkm[i]+Mkt[i];
        end;
      //dodanie dodatkowych punktów
      for i:=1 to Le1 do
       begin
       nrx[i,x]:=ES+1;
       for j:=1 to ES+1 do
        wsp[i,j,x]:=(j-1)/ES;
       end;
      for i:=1 to RowsPp1 do if (wariantP[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then                     //skupione
        begin
        xpwsp[i,x]:=0;
        tak:=false;
          for j:=1 to nrx[np[i],x] do
          if xp[i]=wsp[np[i],j,x] then begin tak:=true; if (xp[i]>0) and (xp[i]<1) then xpwsp[i,x]:=j; end;
          if tak=false then
          begin
           j:=nrx[np[i],x];
           while wsp[np[i],j,x]>xp[i] do begin wsp[np[i],j+1,x]:=wsp[np[i],j,x]; j:=j-1; end;
           wsp[np[i],j+1,x]:=xp[i];
           inc(nrx[np[i],x]);
           xpwsp[i,x]:=j+1;
           for j:=1 to i-1 do if (xpwsp[j,x]>=xpwsp[i,x]) and (np[i]=np[j]) then xpwsp[j,x]:=xpwsp[j,x]+2;
          end;
          if xp[i]>0 then
           begin
            j:=nrx[np[i],x];
            while wsp[np[i],j,x]>xp[i]-0.000001 do begin wsp[np[i],j+1,x]:=wsp[np[i],j,x]; j:=j-1; end;
            wsp[np[i],j+1,x]:=xp[i]-0.000001;
            inc(nrx[np[i],x]);
           end;
        end;
      for i:=1 to RowsPq1 do if (wariantQ[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then                         //ciągłe
        begin
        xqiwsp[i,x]:=0; xqjwsp[i,x]:=0;
        tak:=false;
          for j:=1 to nrx[nq[i],x] do
          if xqi[i]=wsp[nq[i],j,x] then begin tak:=true; if (xqi[i]>0) and (xqi[i]<1) then xqiwsp[i,x]:=j; end;
          if tak=false then
          begin
           j:=nrx[nq[i],x];
           while wsp[nq[i],j,x]>xqi[i] do begin wsp[nq[i],j+1,x]:=wsp[nq[i],j,x]; j:=j-1; end;
           wsp[nq[i],j+1,x]:=xqi[i];
           inc(nrx[nq[i],x]);
           xqiwsp[i,x]:=j+1;
           for j:=1 to RowsPp do if xpwsp[j,x]>=xqiwsp[i,x] then inc(xpwsp[j,x]);
           for j:=1 to i-1 do begin if (xqiwsp[j,x]>=xqiwsp[i,x]) and (nq[i]=nq[j]) then inc(xqiwsp[j,x]); if (xqjwsp[j,x]>=xqiwsp[i,x]) and (nq[i]=nq[j]) then inc(xqjwsp[j,x]); end;
          end;
        tak:=false;
          for j:=1 to nrx[nq[i],x] do
          if xqj[i]=wsp[nq[i],j,x] then begin tak:=true; if (xqj[i]>0) and (xqj[i]<1) then xqjwsp[i,x]:=j; end;
          if tak=false then
          begin
           j:=nrx[nq[i],x];
           while wsp[nq[i],j,x]>xqj[i] do begin wsp[nq[i],j+1,x]:=wsp[nq[i],j,x]; j:=j-1; end;
           wsp[nq[i],j+1,x]:=xqj[i];
           inc(nrx[nq[i],x]);
           xqjwsp[i,x]:=j+1;
           for j:=1 to RowsPp do if (xpwsp[j,x]>=xqjwsp[i,x]) and (np[j]=nq[i]) then inc(xpwsp[j,x]);
           for j:=1 to i-1 do begin if (xqiwsp[j,x]>=xqjwsp[i,x]) and (nq[i]=nq[j]) then inc(xqiwsp[j,x]); if (xqjwsp[j,x]>=xqjwsp[i,x]) and (nq[i]=nq[j]) then inc(xqjwsp[j,x]); end;
          end;
        end;
      for i:=1 to RowsPm1 do if (wariantM[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then                          //momenty
        begin
        xmwsp[i,x]:=0;
        tak:=false;
          for j:=1 to nrx[nm[i],x] do
          if xm[i]=wsp[nm[i],j,x] then begin tak:=true; if (xm[i]>0) and (xm[i]<1) then xmwsp[i,x]:=j; end;
          if tak=false then
          begin
           j:=nrx[nm[i],x];
           while wsp[nm[i],j,x]>xm[i] do begin wsp[nm[i],j+1,x]:=wsp[nm[i],j,x]; j:=j-1; end;
           wsp[nm[i],j+1,x]:=xm[i];
           inc(nrx[nm[i],x]);
           xmwsp[i,x]:=j+1;
           for j:=1 to RowsPp1 do if (wariantP[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then if (xpwsp[j,x]>=xmwsp[i,x]) and (np[j]=nm[i]) then xpwsp[j,x]:=xpwsp[j,x]+2;
           for j:=1 to RowsPq1 do if (wariantQ[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then begin if (xqiwsp[j,x]>=xmwsp[i,x]) and (nq[j]=np[i]) then xqiwsp[j,x]:=xqiwsp[j,x]+2; if (xqjwsp[j,x]>=xmwsp[i,x]) and (nq[j]=nm[i]) then xqjwsp[j,x]:=xqjwsp[j,x]+2;; end;
           for j:=1 to i-1 do if (xmwsp[j,x]>=xmwsp[i,x]) and (nm[j]=nm[i]) then xmwsp[j,x]:=xmwsp[j,x]+2;
          end;
          if xm[i]>0 then
           begin
            j:=nrx[nm[i],x];
            while wsp[nm[i],j,x]>xm[i]-0.000001 do begin wsp[nm[i],j+1,x]:=wsp[nm[i],j,x]; j:=j-1; end;
            wsp[nm[i],j+1,x]:=xm[i]-0.000001;
            inc(nrx[nm[i],x]);
           end;
        end;
      //dokladne sily wewnetrzne
      for i:=1 to rowsPp1 do if (wariantP[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then for j:=1 to nrx[np[i],x] do begin Mpx[i,j]:=0;Tpx[i,j]:=0;Npx[i,j]:=0;end;
      for i:=1 to rowsPq1 do if (wariantQ[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then for j:=1 to nrx[nq[i],x] do begin Mqx[i,j]:=0;Tqx[i,j]:=0;Nqx[i,j]:=0;end;
      for i:=1 to rowsPm1 do if (wariantM[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then for j:=1 to nrx[nm[i],x] do Mmx[i,j]:=0;
      for i:=1 to Le1 do for j:=1 to nrx[i,x] do begin M[i,j,x]:=Mi[i]+Ti[i]*wsp[i,j,x]*L1[i];T[i,j,x]:=Ti[i];N[i,j,x]:=Ni[i];end;
      for i:=1 to rowsPp1 do if (wariantP[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then for j:=1 to nrx[np[i],x] do          //skupione
        begin
          if (xp[i]<=wsp[np[i],j,x]) and (xp[i]<1) then begin
            Mpx[i,j]:=Mpx[i,j]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]))*(wsp[np[i],j,x]-xp[i])*L1[np[i]];
            Tpx[i,j]:=Tpx[i,j]-P[i]*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]));
            Npx[i,j]:=Npx[i,j]+P[i]*sin(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]));
            end;
          M[np[i],j,x]:=M[np[i],j,x]+Mpx[i,j];
          T[np[i],j,x]:=T[np[i],j,x]+Tpx[i,j];
          N[np[i],j,x]:=N[np[i],j,x]+Npx[i,j];
        end;
      for i:=1 to rowsPq1 do if (wariantQ[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then for j:=1 to nrx[nq[i],x] do           //ciągłe
        begin
          if (xqi[i]<=wsp[nq[i],j,x]) and (xqi[i]<1) then
            begin
              if xqj[i]>wsp[nq[i],j,x] then
               begin
                Mqx[i,j]:=Mqx[i,j]+cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*(-Pqi[i]/2*sqr(wsp[nq[i],j,x]-xqi[i])+(-Pqj[i]+Pqi[i])/6/(xqj[i]-xqi[i])*sqr(wsp[nq[i],j,x]-xqi[i])*(wsp[nq[i],j,x]-xqi[i]))*sqr(L1[nq[i]]);
                Tqx[i,j]:=Tqx[i,j]+cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*(-Pqi[i]+(-Pqj[i]+Pqi[i])/2/(xqj[i]-xqi[i])*(wsp[nq[i],j,x]-xqi[i]))*(wsp[nq[i],j,x]-xqi[i])*L1[nq[i]];
                Nqx[i,j]:=Nqx[i,j]-sin(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*(-Pqi[i]+(-Pqj[i]+Pqi[i])/2/(xqj[i]-xqi[i])*(wsp[nq[i],j,x]-xqi[i]))*(wsp[nq[i],j,x]-xqi[i])*L1[nq[i]];
               end
              else
               begin
                Mqx[i,j]:=Mqx[i,j]+cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*(-Pqi[i]*(xqj[i]-xqi[i])*(wsp[nq[i],j,x]-(xqj[i]+xqi[i])/2)+(-Pqj[i]+Pqi[i])/6*(xqj[i]-xqi[i])*(3*wsp[nq[i],j,x]-xqi[i]-2*xqj[i]))*sqr(L1[nq[i]]);
                Tqx[i,j]:=Tqx[i,j]+cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*(-Pqi[i]+-Pqj[i])/2*(xqj[i]-xqi[i])*L1[nq[i]];
                Nqx[i,j]:=Nqx[i,j]-sin(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]))*(-Pqi[i]+-Pqj[i])/2*(xqj[i]-xqi[i])*L1[nq[i]];
               end;
            end;
          M[nq[i],j,x]:=M[nq[i],j,x]+Mqx[i,j];
          T[nq[i],j,x]:=T[nq[i],j,x]+Tqx[i,j];
          N[nq[i],j,x]:=N[nq[i],j,x]+Nqx[i,j];
        end;
      for i:=1 to rowsPm1 do if (wariantM[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then for j:=1 to nrx[nm[i],x] do             //momenty
        begin
          if (xm[i]<=wsp[nm[i],j,x]) and (xm[i]<1) then Mmx[i,j]:=Mmx[i,j]+Pm[i];
          M[nm[i],j,x]:=M[nm[i],j,x]+Mmx[i,j];
        end;
      if (tryb=50) and (x=0) then
      begin
        max:=0;                                         //przerywanie obliczeń dla statecznosci
        for i:=1 to RowsPp1 do
          if (xp[i]>0) and (xp[i]<1) then max:=1;
        for i:=1 to RowsPm1 do
          if (xm[i]>0) and (xm[i]<1) then max:=1;
        for i:=1 to RowsPq1 do
          if (xqi[i]>0) and (xqj[i]<1) then max:=1;
        if max=1 then begin powrotobciazen; MessageDlg('Błąd!', 'Musisz zadać obciążenia w węzłach.', mterror, [mbOK], 0); tbPowrot.Click; exit; end;
        max:=0;
        for i:=1 to Le1 do
          if max>N[i,trunc(nrx[i,0]/2),0] then max:=N[i,trunc(nrx[i,0]/2),0];
        if max>=0 then begin powrotobciazen; MessageDlg('Błąd!', 'Brak sił ściskających w prętach. Nie można wyznaczyć siły krytycznej.', mterror, [mbOK], 0); tbPowrot.Click; exit; end;
      end;
      //obroty
      for i:=1 to rowsPt1 do if (wariantT[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=2) or (x=3))) then
        for j:=2 to nrx[nt[i],x] do
          fit[nt[i],j]:=-L1[nt[i]]*DT[i]*at[nt[i]]/h[nt[i]]*wsp[nt[i],j,x];
      for i:=1 to Le1 do
        begin
          fi[i,1,x]:=fii[i];
          fit[i,1]:=0;
          for j:=2 to nrx[i,x] do fi[i,j,x]:=fi[i,j-1,x]-((M[i,j,x]+M[i,j-1,x])/2)*L1[i]*(wsp[i,j,x]-wsp[i,j-1,x])/E[i]/Jx[i];
        end;
      for i:=1 to Le1 do
        for j:=2 to nrx[i,x] do
          fi[i,j,x]:=fi[i,j,x]+fit[i,j];
      //dla 4 typu kat poczatkowy
      for i:=1 to Le1 do
        begin
          fip[i]:=0;fim[i]:=0;fiq[i]:=0;fiqp[i]:=0;fiqt[i]:=0;fitem[i]:=0;
        end;
      for i:=1 to rowsPp1 do if (wariantP[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then
        fip[np[i]]:=fip[np[i]]-P[i]*xp[i]*sqr(L1[np[i]])/6/E[np[i]]/Jx[np[i]]*(sqr(xp[i])-3*(xp[i])+2)*cos(alfaP[i]*pi/180+atan(Ly1[np[i]],Lx1[np[i]]));
      for i:=1 to rowsPm1 do if (wariantM[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then
        fim[nm[i]]:=fim[nm[i]]+Pm[i]*L1[nm[i]]/6/E[nm[i]]/Jx[nm[i]]*(6*xm[i]-3*sqr(xm[i])-2);
      for i:=1 to rowsPq1 do if (wariantQ[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=1))) then
        begin
          rj[i]:=L1[nq[i]]/6*((-Pqi[i]+Pqj[i])*(xqi[i]-xqj[i])*(xqi[i]+2*xqj[i])-3*-Pqi[i]*(sqr(xqi[i])-sqr(xqj[i])));
          ri[i]:=L1[nq[i]]/6*(3*-Pqi[i]*(sqr(xqi[i])-sqr(xqj[i]))-(-Pqi[i]+Pqj[i])*(xqi[i]-xqj[i])*(xqi[i]+2*xqj[i])-3*(xqi[i]-xqj[i])*(-Pqi[i]-Pqj[i]));
          fiq[nq[i]]:=fiq[nq[i]]+sqr(L1[nq[i]])/E[nq[i]]/Jx[nq[i]]*(ri[i]*sqr(xqi[i])*(0.5-xqi[i]/3)+(xqj[i]-xqi[i])*(ri[i]*xqi[i]*((1-xqi[i])/3+(1-xqj[i])/6)+rj[i]*(1-xqj[i])*((1-xqi[i])/6+(1-xqj[i])/3))+rj[i]*sqr(1-xqj[i])*(1-xqj[i])/3)*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]));
          fiqp[nq[i]]:=fiqp[nq[i]]+1/24/E[nq[i]]/Jx[nq[i]]*-Pqi[i]*sqr(L1[nq[i]])*L1[nq[i]]*sqr(xqj[i]-xqi[i])*(xqj[i]-xqi[i])*(2-xqj[i]-xqi[i])*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]));
          fiqt[nq[i]]:=fiqt[nq[i]]+sqr(L1[nq[i]])*sqr(xqj[i]-xqi[i])/24/E[nq[i]]/Jx[nq[i]]*((-Pqj[i]+Pqi[i])*L1[nq[i]]*(xqj[i]-xqi[i]))*(1-xqj[i]+(xqj[i]-xqi[i])*7/15)*cos(alfaq[i]*pi/180+atan(Ly1[nq[i]],Lx1[nq[i]]));
        end;
      for i:=1 to rowsPt1 do if (wariantT[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=2) or (x=3))) then
        fitem[nt[i]]:=fitem[nt[i]]-L1[nt[i]]*DT[i]*at[nt[i]]/2/h[nt[i]];
      for i:=1 to Le1 do
        begin
          fi4[i]:=fip[i]+fim[i]+fiq[i]+fiqp[i]+fiqt[i]+fitem[i];
          for j:=1 to nrx[i,x] do
            case Typ1[i] of
              2:fi[i,j,x]:=fi[i,j,x]-fi[i,nrx[i,x],x]+fij[i];
              4:fi[i,j,x]:=fi[i,j,x]-fi4[i];
            end;
        end;
      //przemieszczenia
      for i:=1 to Le1 do
        begin
          v[i,1,x]:=Lx1[i]/L1[i]*u[pa[i]+1]-Ly1[i]/L1[i]*u[pa[i]];
          vN[i,1,x]:=Ly1[i]/L1[i]*u[pa[i]+1]+Lx1[i]/L1[i]*u[pa[i]];
          for j:=2 to nrx[i,x] do
            begin
              v[i,j,x]:=v[i,j-1,x]-(fi[i,j-1,x]+fi[i,j,x])*L1[i]/2*(wsp[i,j,x]-wsp[i,j-1,x]);
              vN[i,j,x]:=vN[i,j-1,x]+N[i,j,x]/Pole[i]/E[i]*L1[i]*(wsp[i,j,x]-wsp[i,j-1,x]);
            end;
        end;
      for i:=1 to rowsPt1 do if (wariantT[i,x]=true) or ((rozbijobc=true) and ((x=0) or (x=2) or (x=3))) then
        begin
          for j:=2 to nrx[nt[i],x] do begin vN[nt[i],j,x]:=vN[nt[i],j,x]+T0[i]*at[nt[i]]*L1[nt[i]]*wsp[nt[i],j,x]; fit[nt[i],j]:=0;end;
          T0[i]:=0; DT[i]:=0;
        end;
      if odliczanie=3 then for i:=1 to Le1 do for j:=1 to nrx[i,x] do Mlw[i,j]:=-v[i,j,x];
      if odliczanie=2 then for i:=1 to Le1 do for j:=1 to nrx[i,x] do Tlw[i,j]:=v[i,j,x];
      if odliczanie=1 then for i:=1 to Le1 do for j:=1 to nrx[i,x] do Nlw[i,j]:=v[i,j,x];
      if tryb=45 then odliczanie:=odliczanie-1;
    until odliczanie=0;
    //przywrócenie momentów do linii wpływu
    if tryb=45 then for i:=1 to Le1 do for j:=1 to nrx[i,x] do begin M[i,j,x]:=Mlw[i,j]; T[i,j,x]:=Tlw[i,j]; N[i,j,x]:=Nlw[i,j]; v[i,j,x]:=0; vN[i,j,x]:=0; end;
    //naprężenia i przemieszczenia w osiach głównych
    if tryb<>45 then
    for i:=1 to Le1 do
      for j:=1 to nrx[i,x] do
        begin
          napr1[i,j,x]:=(-M[i,j,x]/Jx[i]*wys[i]+N[i,j,x]/pole[i])/1000;
          napr2[i,j,x]:=( M[i,j,x]/Jx[i]*wys[i]+N[i,j,x]/pole[i])/1000;
          ux[i,j,x]:=-v[i,j,x]*Ly1[i]/L1[i]+vN[i,j,x]*Lx1[i]/L1[i];
          uy[i,j,x]:=v[i,j,x]*Lx1[i]/L1[i]+vN[i,j,x]*Ly1[i]/L1[i];
        end;
    for i:=1 to Le1 do if (abs(ux[i,round(nrx[i,x]/2),x])>1e6) or (abs(uy[i,round(nrx[i,x]/2),x])>1e6) then czyrysowac[i]:=false;
    // powrot sil
  end;
  //statecznosc
  if tryb=50 then
  begin
   for i:=1 to Le1 do Kappa[i]:=N[i,trunc(nrx[i,0]/2),0]/L1[i];
   for i:=1 to Le1 do
   begin
     for j:=1 to 3 do for k:=1 to 3 do
       begin G11[j,k,i]:=0; G12[j,k,i]:=0; G22[j,k,i]:=0; G11x[j,k,i]:=0; G12x[j,k,i]:=0; G22x[j,k,i]:=0; end;
     if typ1[i]=1 then begin
       G11[2,2,i]:=kappa[i]*1.2;
       G11[2,3,i]:=kappa[i]*-0.1*L1[i];
       G11[3,2,i]:=kappa[i]*-0.1*L1[i];
       G11[3,3,i]:=kappa[i]*2/15*L1[i]*L1[i];
       G12[2,2,i]:=kappa[i]*-1.2;
       G12[2,3,i]:=kappa[i]*-0.1*L1[i];
       G12[3,2,i]:=kappa[i]*0.1*L1[i];
       G12[3,3,i]:=kappa[i]*-1/30*L1[i]*L1[i];
       G22[2,2,i]:=kappa[i]*1.2;
       G22[2,3,i]:=kappa[i]*0.1*L1[i];
       G22[3,2,i]:=kappa[i]*0.1*L1[i];
       G22[3,3,i]:=kappa[i]*2/15*L1[i]*L1[i];
     end;
     if typ1[i]=3 then begin
       G11[2,2,i]:=kappa[i]*1.2;
       G11[2,3,i]:=kappa[i]*-0.2*L1[i];
       G11[3,2,i]:=kappa[i]*-0.2*L1[i];
       G11[3,3,i]:=kappa[i]*0.2*L1[i]*L1[i];
       G12[2,2,i]:=kappa[i]*-1.2;
       G12[2,3,i]:=0;
       G12[3,2,i]:=kappa[i]*0.2*L1[i];
       G12[3,3,i]:=0;
       G22[2,2,i]:=kappa[i]*1.2;
       G22[2,3,i]:=0;
       G22[3,2,i]:=0;
       G22[3,3,i]:=0;
     end;
     if typ1[i]=2 then begin
       G11[2,2,i]:=kappa[i]*1.2;
       G11[2,3,i]:=0;
       G11[3,2,i]:=0;
       G11[3,3,i]:=0;
       G12[2,2,i]:=kappa[i]*-1.2;
       G12[2,3,i]:=kappa[i]*-0.2*L1[i];
       G12[3,2,i]:=0;
       G12[3,3,i]:=0;
       G22[2,2,i]:=kappa[i]*1.2;
       G22[2,3,i]:=kappa[i]*0.2*L1[i];
       G22[3,2,i]:=kappa[i]*0.2*L1[i];
       G22[3,3,i]:=kappa[i]*0.2*L1[i]*L1[i];
     end;
   end;
   for i:=1 to Le1 do
    begin
    for j:=1 to 3 do
     for k:=1 to 3 do
       begin
         G11x[j,k,i]:=R[j,1,i]*G11[1,k,i]+R[j,2,i]*G11[2,k,i]+R[j,3,i]*G11[3,k,i];
         G12x[j,k,i]:=R[j,1,i]*G12[1,k,i]+R[j,2,i]*G12[2,k,i]+R[j,3,i]*G12[3,k,i];
         G22x[j,k,i]:=R[j,1,i]*G22[1,k,i]+R[j,2,i]*G22[2,k,i]+R[j,3,i]*G22[3,k,i];
       end;
    for j:=1 to 3 do
     for k:=1 to 3 do
       begin
         G11[j,k,i]:=G11x[j,1,i]*R[k,1,i]+G11x[j,2,i]*R[k,2,i]+G11x[j,3,i]*R[k,3,i];
         G12[j,k,i]:=G12x[j,1,i]*R[k,1,i]+G12x[j,2,i]*R[k,2,i]+G12x[j,3,i]*R[k,3,i];
         G22[j,k,i]:=G22x[j,1,i]*R[k,1,i]+G22x[j,2,i]*R[k,2,i]+G22x[j,3,i]*R[k,3,i];
       end;
    end;
   for i:=1 to Lr do
    for j:=1 to Lr do
     Gr[i,j]:=0;
   for i:=1 to Le1 do
    begin
    for j:=1 to 3 do
     for k:=1 to 3 do
       begin
         G11x[j,k,i]:=Rp[j,1,i]*G11[1,k,i]+Rp[j,2,i]*G11[2,k,i]+Rp[j,3,i]*G11[3,k,i];
         G12x[j,k,i]:=Rp[j,1,i]*G12[1,k,i]+Rp[j,2,i]*G12[2,k,i]+Rp[j,3,i]*G12[3,k,i];
         G22x[j,k,i]:=Rk[j,1,i]*G22[1,k,i]+Rk[j,2,i]*G22[2,k,i]+Rk[j,3,i]*G22[3,k,i];
       end;
    for j:=1 to 3 do
     for k:=1 to 3 do
       begin
         G11[j,k,i]:=G11x[j,1,i]*Rp[k,1,i]+G11x[j,2,i]*Rp[k,2,i]+G11x[j,3,i]*Rp[k,3,i];
         G12[j,k,i]:=G12x[j,1,i]*Rk[k,1,i]+G12x[j,2,i]*Rk[k,2,i]+G12x[j,3,i]*Rk[k,3,i];
         G22[j,k,i]:=G22x[j,1,i]*Rk[k,1,i]+G22x[j,2,i]*Rk[k,2,i]+G22x[j,3,i]*Rk[k,3,i];
       end;
    for j:=1 to 3 do
     for k:=1 to 3 do          //agregacja
       begin
         Gr[pa[i]+j-1,pa[i]+k-1]:=Gr[pa[i]+j-1,pa[i]+k-1]+G11[j,k,i];
         Gr[ka[i]+j-1,ka[i]+k-1]:=Gr[ka[i]+j-1,ka[i]+k-1]+G22[j,k,i];
         Gr[pa[i]+j-1,ka[i]+k-1]:=Gr[pa[i]+j-1,ka[i]+k-1]+G12[j,k,i];
         Gr[ka[i]+j-1,pa[i]+k-1]:=Gr[ka[i]+j-1,pa[i]+k-1]+G12[k,j,i];
       end;
    end;
   //warunki brzegowe
   for i:=1 to Lwar1 do
     begin
       if (KWB[i]<>0) then
         Gr[s1[i],s1[i]]:=Gr[s1[i],s1[i]]+KWB[i]
         else
         begin
           for j:=1 to Lr do Gr[s1[i],j]:=0;
           Gr[s1[i],s1[i]]:=1;
         end;
       end;
   //obliczenia statecznosci
   lewa:=statecznosc(0.01);
   prawa:=1;
   while lewa*statecznosc(prawa)>=0 do
    begin
      prawa:=prawa*1.1;
      if prawa>100000 then begin powrotobciazen; MessageDlg('Błąd!', 'Nie można znaleźć mnożnika krytycznego dla zadanego układu.', mterror, [mbOK], 0); tbPowrot.Click; exit; end;
    end;
   lewa:=prawa/1.1;
   while (lewa-prawa>0.001) or (lewa-prawa<-0.001) do
    begin
      mnoznik:=(lewa+prawa)/2;
      if statecznosc(lewa)*statecznosc(mnoznik)<0 then prawa:=mnoznik else lewa:=mnoznik;
    end;
  end;
  toolbar1.visible:=false;
  toolbar2.visible:=true;
  if tbnormalne.down=true then tbnormalne.click;
  if tbtnace.down=true then tbtnace.click;
  if tbmomenty.down=true then tbmomenty.click;
  if tbprzemieszczenia.down=true then tbprzemieszczenia.click;
  if tbnaprezenia.down=true then tbnaprezenia.click;
  medycja.enabled:=false;mwstaw.enabled:=false;tbprzenies.enabled:=false;tbkopiuj.enabled:=false; tblustro.enabled:=false; tbobrot.enabled:=false;
  tbusun.enabled:=false;tbpodziel.enabled:=false; tbprzeciecie.enabled:=false;
  tbzaznaczwszystko.enabled:=false;tbpodpora.enabled:=false; tbutwierdzenie.enabled:=false; tbutwprzesuw.enabled:=false;
  tbwolnapodpora.enabled:=false; tbprzesuw.enabled:=false; tbblokadaobrotu.enabled:=false;
  mbrysujpret.enabled:=false;tbrysujpret.enabled:=false; mbsila.enabled:=false; tbsila.enabled:=false; mbciagle.enabled:=false;tbciagle.enabled:=false;
  mbmoment.enabled:=false;tbmoment.enabled:=false; mbtemperatura.enabled:=false; tbtemperatura.enabled:=false;
  mboblicz.enabled:=false; tboblicz.enabled:=false;mbkreator.enabled:=false; tbkreatorruszt.enabled:=false; mbkreatorkratownica.enabled:=false;  tbkreatorkratownica.enabled:=false;
  tbtyppreta1.enabled:=false; tbtyppreta2.enabled:=false; tbtyppreta3.enabled:=false; tbtyppreta4.enabled:=false;
  mwyniki.enabled:=true;
  trackbar1.Position:=trunc(sqrt(sqrt(skalawew*1000000)));
  label13.caption:=''; label14.caption:='';
  for i:=1 to Le1 do zaznaczonypret[i]:=false;
  for i:=1 to Lw1 do zaznaczonywezel[i]:=false;
  for i:=1 to RowsPp do zaznaczoneP[i]:=false;
  for i:=1 to RowsPq do zaznaczoneQ[i]:=false;
  for i:=1 to RowsPm do zaznaczoneM[i]:=false;
  for i:=1 to RowsPt do zaznaczoneT[i]:=false;
  polar:=false; idletimer1.Enabled:=false; wprowadz:=0; ulamek:=1; liczba1:=0;liczba2:=0;
  if tryb=45 then tryb:=47; if tryb=0 then tryb:=46;
  powrotobciazen;
  if tryb=50 then
  begin
   tbPowrot.Click;
   MessageDlg('Wynik', 'Mnożnik krytyczny dla pierwszej formy wyboczenia wynosi '+slinebreak+floattostrf(mnoznik,fffixed,7,3), mtInformation, [mbOK], 0);
  end;
  rysuj;
end;

procedure tform1.powrotobciazen;
begin
  for i:=1 to RowsPp do begin np[i]:=np1[i]; xp[i]:=xp1[i] end;                        //powrot obciazen
  for i:=1 to RowsPq do begin nq[i]:=nq1[i]; xqi[i]:=xqi1[i]; xqj[i]:=xqj1[i]; Pqj[i]:=Pqj1[i] end;
  for i:=1 to RowsPm do begin nm[i]:=nm1[i]; xm[i]:=xm1[i]; end;
  for i:=1 to rowsPp do if (Lx[np[i]]<0) then P[i]:=-P[i];
  for i:=1 to rowsPq do if (Lx[nq[i]]<0) then begin Pqi[i]:=-Pqi[i]; Pqj[i]:=-Pqj[i]; end;
end;

function tform1.xpoint:real;
begin
  xpoint:=(xmysz-A)/zoom;
  if (wprowadz>0) and (wprowadz<4) then ;
  if bar[2]=true then if xmysz-A>0 then xpoint:=trunc((Xmysz-A+zoom/2*skok)/zoom/skok)*skok else xpoint:=trunc((Xmysz-A-zoom/2*skok)/zoom/skok)*skok;
  if (bar[3]=true) and (Lw>0) then if delta<20 then xpoint:=Xw[cel];
  if (polar=true) and (delta>20) then begin
    if ((10>polarangle) or (polarangle>350)) or ((190>polarangle) and (polarangle>170)) then xpoint:=Xw[polarpoint];
    if ((35>=polarangle) and (polarangle>=10)) or ((215>=polarangle) and (polarangle>=190)) then xpoint:=Xw[polarpoint]+sqrt(3)/3*(-(ymysz-B)/zoom-Yw[polarpoint]);
    if ((170>=polarangle) and (polarangle>=145)) or ((350>=polarangle) and (polarangle>=325)) then xpoint:=Xw[polarpoint]-sqrt(3)/3*(-(ymysz-B)/zoom-Yw[polarpoint]);
    if ((55>polarangle) and (polarangle>35)) or ((235>polarangle) and (polarangle>215)) then xpoint:=Xw[polarpoint]+(-(ymysz-B)/zoom-Yw[polarpoint]);
    if ((145>polarangle) and (polarangle>125)) or ((325>polarangle) and (polarangle>305)) then xpoint:=Xw[polarpoint]-(-(ymysz-B)/zoom-Yw[polarpoint]);
  end;
  if (wprowadz<4) and (wprowadz>0) then begin
    if (100>polarangle) and (polarangle>80) then xpoint:=Xw[polarpoint]+liczba1;
    if (280>polarangle) and (polarangle>260) then xpoint:=Xw[polarpoint]-liczba1;
    if (80>=polarangle) and (polarangle>=55) then xpoint:=Xw[polarpoint]+liczba1*sqrt(3)/2;
    if (260>=polarangle) and (polarangle>=235) then xpoint:=Xw[polarpoint]-liczba1*sqrt(3)/2;
    if (125>=polarangle) and (polarangle>=100) then xpoint:=Xw[polarpoint]+liczba1*sqrt(3)/2;
    if (305>=polarangle) and (polarangle>=280) then xpoint:=Xw[polarpoint]-liczba1*sqrt(3)/2;
    if (10>polarangle) or (polarangle>350) then xpoint:=Xw[polarpoint];
    if (190>polarangle) and (polarangle>170) then xpoint:=Xw[polarpoint];
    if (35>=polarangle) and (polarangle>=10) then xpoint:=Xw[polarpoint]+liczba1/2;
    if (215>=polarangle) and (polarangle>=190) then xpoint:=Xw[polarpoint]-liczba1/2;
    if (170>=polarangle) and (polarangle>=145) then xpoint:=Xw[polarpoint]+liczba1/2;
    if (350>=polarangle) and (polarangle>=325) then xpoint:=Xw[polarpoint]-liczba1/2;
    if (55>polarangle) and (polarangle>35) then Xpoint:=Xw[polarpoint]+liczba1*sqrt(2)/2;
    if (235>polarangle) and (polarangle>215) then Xpoint:=Xw[polarpoint]-liczba1*sqrt(2)/2;
    if (145>polarangle) and (polarangle>125) then Xpoint:=Xw[polarpoint]+liczba1*sqrt(2)/2;
    if (325>polarangle) and (polarangle>305) then Xpoint:=Xw[polarpoint]-liczba1*sqrt(2)/2;
  end;
  if wprowadz>3 then if wprowadzalfa=false then Xpoint:=Xw[polarpoint]+liczba1 else xpoint:=Xw[polarpoint]+liczba1*cos(liczba2*pi()/180);
end;

function tform1.ypoint:real;
begin
  ypoint:=-(ymysz-B)/zoom;
  if (wprowadz>0) and (wprowadz<4) then ;
  if bar[2]=true then if ymysz-B<0 then ypoint:=-trunc((Ymysz-B-zoom*skok/2)/zoom/skok)*skok else ypoint:=-trunc((Ymysz-B+zoom*skok/2)/zoom/skok)*skok;
  if (bar[3]=true) and (Lw>0) then if delta<20 then begin ypoint:=Yw[cel]; idletimer1.Enabled:=true; end else idletimer1.Enabled:=false;
  if (polar=true) and (delta>20) then begin
    if ((100>polarangle) and (polarangle>80)) or ((280>polarangle) and (polarangle>260)) then ypoint:=Yw[polarpoint];
    if ((80>=polarangle) and (polarangle>=55)) or ((260>=polarangle) and (polarangle>=235)) then ypoint:=Yw[polarpoint]+sqrt(3)/3*((xmysz-A)/zoom-Xw[polarpoint]);
    if ((125>=polarangle) and (polarangle>=100)) or ((305>=polarangle) and (polarangle>=280)) then ypoint:=Yw[polarpoint]-sqrt(3)/3*((xmysz-A)/zoom-Xw[polarpoint]);
  end;
  if (wprowadz<4) and (wprowadz>0) then begin
    if (10>polarangle) or (polarangle>350) then ypoint:=Yw[polarpoint]+liczba1;
    if (190>polarangle) and (polarangle>170) then ypoint:=Yw[polarpoint]-liczba1;
    if (35>=polarangle) and (polarangle>=10) then ypoint:=Yw[polarpoint]+liczba1*sqrt(3)/2;
    if (215>=polarangle) and (polarangle>=190) then ypoint:=Yw[polarpoint]-liczba1*sqrt(3)/2;
    if (170>=polarangle) and (polarangle>=145) then ypoint:=Yw[polarpoint]-liczba1*sqrt(3)/2;
    if (350>=polarangle) and (polarangle>=325) then ypoint:=Yw[polarpoint]+liczba1*sqrt(3)/2;
    if (55>polarangle) and (polarangle>35) then ypoint:=Yw[polarpoint]+liczba1*sqrt(2)/2;
    if (235>polarangle) and (polarangle>215) then ypoint:=Yw[polarpoint]-liczba1*sqrt(2)/2;
    if (145>polarangle) and (polarangle>125) then ypoint:=Yw[polarpoint]-liczba1*sqrt(2)/2;
    if (325>polarangle) and (polarangle>305) then ypoint:=Yw[polarpoint]+liczba1*sqrt(2)/2;
    if (100>polarangle) and (polarangle>80) then ypoint:=Yw[polarpoint];
    if (280>polarangle) and (polarangle>260) then Ypoint:=Yw[polarpoint];
    if (80>=polarangle) and (polarangle>=55) then Ypoint:=Yw[polarpoint]+liczba1/2;
    if (260>=polarangle) and (polarangle>=235) then Ypoint:=Yw[polarpoint]-liczba1/2;
    if (125>=polarangle) and (polarangle>=100) then Ypoint:=Yw[polarpoint]-liczba1/2;
    if (305>=polarangle) and (polarangle>=280) then Ypoint:=Yw[polarpoint]+liczba1/2;
  end;
  if wprowadz>3 then if wprowadzalfa=false then ypoint:=Yw[polarpoint]+liczba2 else ypoint:=Yw[polarpoint]+liczba1*sin(liczba2*pi()/180);
end;

function tform1.maxP:real;
var gg:integer;
begin
  maxP:=0;
  for gg:=1 to rowsPp do if abs(P[gg])>maxP then maxP:=abs(P[gg]);
  if maxP=0 then maxP:=skalaP;
end;

function tform1.maxQ:real;
var gg:integer;
begin
  maxQ:=0;
  for gg:=1 to rowsPq do if abs(Pqi[gg])>maxQ then maxQ:=abs(Pqi[gg]);
  for gg:=1 to rowsPq do if abs(Pqj[gg])>maxQ then maxQ:=abs(Pqj[gg]);
  if maxQ=0 then maxQ:=skalaQ;
end;

function tform1.wp0(a:real):real;
begin
  wp0:=1-3*a*a+2*a*a*a;
end;

function tform1.wk0(a:real):real;
begin
  wk0:=a*a*(3-2*a);
end;

function tform1.wp2(a:real):real;
begin
  wp2:=1/2*(a*a*a-3*a+2);
end;

function tform1.wk2(a:real):real;
begin
  wk2:=a/2*(3-a*a);
end;

function tform1.wpm1(a:real):real;
begin
  wpm1:=a*(1-2*a+a*a);
end;

function tform1.wkm1(a:real):real;
begin
  wkm1:=-a*a*(1-a);
end;

function tform1.wpm3(a:real):real;
begin
  wpm3:=a/2*(a*a-3*a+2);
end;

function tform1.wkm2(a:real):real;
begin
  wkm2:=a/2*(a*a-1);
end;

function tform1.wp3(a:real):real;
begin
  wp3:=1/2*(a*a*a-3*a*a+2);
end;

function tform1.wk3(a:real):real;
begin
  wk3:=a*a/2*(3-a);
end;

function tform1.wp4(a:real):real;
begin
  wp4:=1-a;
end;

function tform1.wk4(a:real):real;
begin
  wk4:=a;
end;

function tform1.op1(a:real):real;
begin
  op1:=6*a*(a-1);
end;

function tform1.ok1(a:real):real;
begin
  ok1:=6*a*(1-a);
end;

function tform1.op2(a:real):real;
begin
  op2:=3/2*(a*a-1);
end;

function tform1.ok2(a:real):real;
begin
  ok2:=3/2*(1-a*a);
end;

function tform1.opm1(a:real):real;
begin
  opm1:=3*a*a-4*a+1;
end;

function tform1.okm1(a:real):real;
begin
  okm1:=a*(3*a-2);
end;

function tform1.opm3(a:real):real;
begin
  opm3:=3*a*a/2-3*a+1;
end;

function tform1.okm2(a:real):real;
begin
  okm2:=1/2*(3*a*a-1);
end;

function tform1.op3(a:real):real;
begin
  op3:=3*a*(a/2-1);
end;

function tform1.ok3(a:real):real;
begin
  ok3:=3*a*(1-a/2);
end;

function tform1.Pq(a:real):real;
begin
  Pq:=(Pqi[i]-Pqj[i])/(xqj[i]-xqi[i])*(a-xqi[i])-Pqi[i];
end;

function tform1.atan(a,b:real):real;
begin
  if b=0 then begin if a<0 then atan:=-pi/2 else atan:=pi/2 end else atan:=arctan(a/b);
  if (a=0) and (b=0) then atan:=0;
  if abs(atan)<1e-9 then atan:=0;
end;

function tform1.sgn(a:real):real;
begin
  if a>=0 then sgn:=1 else sgn:=-1;
end;

function tform1.det(ax,ay,bx,by,cx,cy:real):real;
begin
  det:=ax*by+bx*cy+cx*ay-ax*cy-bx*ay-cx*by;
end;

function tform1.statecznosc(a:real):real;
var bufor:real;
    im,jm,ki:integer;
begin
  for im:=1 to Lr do
   for jm:=1 to Lr do
     K0[im,jm]:=Kr[im,jm]+a*Gr[im,jm];
  for im:=1 to Lr-1 do
   for jm:=im+1 to Lr do
    begin
     bufor:=K0[jm,im];
     for ki:=im to Lr do
      if K0[im,im]=0 then K0[jm,ki]:=K0[jm,ki]-10000000 else K0[jm,ki]:=K0[jm,ki]-K0[im,ki]*bufor/K0[im,im];
    end;
  statecznosc:=1;
   for im:=1 to Lr do if K0[im,im]<0 then statecznosc:=-statecznosc;
end;

function tform1.pointpodpora(x1,y1:real):tpoint;
begin
  pointpodpora:=point(round(A+x1*cos(fipod[i]*pi()/180)+y1*sin(fipod[i]*pi()/180)+zoom*Xw[s[i]]),round(B+x1*sin(fipod[i]*pi()/180)-y1*cos(fipod[i]*pi()/180)-zoom*Yw[s[i]]))
end;



function tform1.pointsila(x1,y1:real):tpoint;
begin
  pointsila:=point(round(((Xw[Wk[np[i]]]-Xw[Wp[np[i]]])*xp[i]+Xw[Wp[np[i]]])*zoom+(cos(alfap[i]*pi()/180)*x1+sin(alfap[i]*pi()/180)*y1))+A,round(((-Yw[Wk[np[i]]]+Yw[Wp[np[i]]])*xp[i]-Yw[Wp[np[i]]])*zoom+(sin(alfap[i]*pi()/180)*x1-cos(alfap[i]*pi()/180)*y1))+B)
end;

begin
  wersja:='4.0';
  UU:=0;                                                //wartosci poczatkowe
  A:=20;
  B:=400;
  zoom:=50;
  Le:=0;
  jedenpunkt:=0;
  PreRowsPp:=0;
  PreRowsPq:=0;
  PreRowsPm:=0;
  PreRowsPt:=0;
  PreLwar:=0;
  Form2P:=10; Form2x:=0.5; Form2alfa:=0;
  form3qp:=1;form3qk:=1;form3xp:=0;form3xk:=1;form3alfa:=0;
  form4M:=10;form4x:=0.5;
  form5g:=10;form5d:=-10;
  f6V:=true;f6H:=true;f6M:=false;f6alfa:=0;f6DV:=0;f6DH:=0;f6DM:=0;f6KV:=0;f6KH:=0;f6KM:=0;
  form7podz:=1;form7x:=0.5;
  Bar[1]:=true;
  Bar[2]:=true;
  Bar[3]:=false;
  Bar[4]:=false;
  wprowadzalfa:=false;
  pozycja:=0;
  ilecofnij:=0;
  ileprzywroc:=0;
  tenwariant:=0;
  maleikony:=57;
end.

