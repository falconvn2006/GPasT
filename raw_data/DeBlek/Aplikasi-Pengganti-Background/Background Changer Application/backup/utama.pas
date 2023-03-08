unit UTAMA;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtDlgs,
  ExtCtrls, ColorBox, Menus, PopupNotifier;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ColorBox1: TColorBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenPictureDialog2: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    ScrollBox3: TScrollBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
uses
  windows;

var
  awalX, awalY, akhirX, akhirY : integer;
  drag : Bool;
Type
  Larik = array[0..1000] of integer;

Procedure SelectionSort(var Data:Larik; n: integer);
var
  i, j, min, temp: integer;
begin
  for i := 0 to n-1 do
  begin
    min := i;
    for j:=i+1 to n do
    begin
      if Data[j] < Data[min] then
      min:=j;
    end;
    temp := Data[j];
    Data[i]:= Data[min];
    Data[min] := temp;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  x, y : integer;
  R, G, B, i, j, k : integer;
  TR, TG, TB : array [0..1000] of integer;
  jarak : array [0..1000] of integer;
  Threshold, ganti : integer;
begin
  Threshold := StrToInt(Edit1.Text);
  i := 0;

  //Mengambil Data training
  for y := awalY to akhirY do
  begin
    for x := awalX to akhirX do
    begin
      TR[i] := GetRValue(Image1.Canvas.Pixels[x,y]);
      TG[i] := GetGValue(Image1.Canvas.Pixels[x,y]);
      TB[i] := GetBValue(Image1.Canvas.Pixels[x,y]);
      i := i +1;
    end;
  end;

  //Mengambil New Data
  for y := 0 to image1.Height-1 do
  begin
    for x := 0 to image1.Width-1 do
    begin
      R := GetRValue(Image1.Canvas.Pixels[x,y]);
      G := GetGValue(Image1.Canvas.Pixels[x,y]);
      B := GetBValue(Image1.Canvas.Pixels[x,y]);

      //Menghitung Jarak
      for i := 0  to i do
      begin
        jarak[i] := abs(R-TR[i]) + abs(G - TG[i]) + abs(B - TB[i]);
      end;
      SelectionSort(jarak,i);

      //Melakukan Klasifikasi Terhadap Background
      ganti := 0;
      k := StrToInt(Edit2.Text);
      for j := 0 to k-1 do
      begin
        if jarak[j] <= threshold then
        begin
             ganti := ganti + 1;
        end
        else
        begin
          ganti := ganti - 1;
        end;
      end;

      //Mengganti Warna Background
      if CheckBox2.Checked then
      begin
        if ganti > 0 then
        begin
          image3.Canvas.Pixels[x,y] := ColorBox1.Selected;
        end;
      end
      else
      begin
        if ganti > 0 then
        begin
          image3.Canvas.Pixels[x,y] := image4.Canvas.Pixels[x,y];
        end;
      end;
    end;
  end;
  image2.Picture := image1.Picture;
  Timer1.Enabled := false;
end;

procedure TForm1.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  RMIN, GMIN, BMIN, RMAX, GMAX, BMAX, temp : integer;
begin
  RMIN := 255;
  GMIN := 255;
  BMIN := 255;
  RMAX := 0;
  GMAX := 0;
  BMAX := 0;
  drag := false;

  if CheckBox1.Checked then
  begin
    for y := awalY to akhirY do
    begin
      for x := awalX to akhirX do
      begin
        if RMIN > GetRValue(image1.Canvas.Pixels[x,y]) then RMIN := GetRValue(image1.Canvas.Pixels[x,y]);
        if GMIN > GetGValue(image1.Canvas.Pixels[x,y]) then GMIN := GetGValue(image1.Canvas.Pixels[x,y]);
        if BMIN > GetBValue(image1.Canvas.Pixels[x,y]) then BMIN := GetBValue(image1.Canvas.Pixels[x,y]);
        if RMAX < GetRValue(image1.Canvas.Pixels[x,y]) then RMAX := GetRValue(image1.Canvas.Pixels[x,y]);
        if GMAX < GetGValue(image1.Canvas.Pixels[x,y]) then GMAX := GetGValue(image1.Canvas.Pixels[x,y]);
        if BMAX < GetBValue(image1.Canvas.Pixels[x,y]) then BMAX := GetBValue(image1.Canvas.Pixels[x,y]);
      end;
    end;
    temp := (abs(RMAX - RMIN) + abs(GMAX - GMIN) + abs(BMAX - BMIN)) div 3;
    Edit1.Text := IntToStr(temp);
  end;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if drag then
  begin
    akhirX := X;
    akhirY := Y;
    label6.caption := IntToStr(akhirX);
    label7.caption := IntToStr(akhirY);
    image2.Picture := image1.Picture;
    image2.Canvas.Brush.Style := bsClear;
    image2.Canvas.Pen.Style := psdot;
    image2.Canvas.Pen.Color := clred;
    image2.Canvas.Rectangle(awalX,awalY,akhirX,akhirY);
  end;
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  awalX := X;
  awalY := Y;
  label4.caption := IntToStr(awalX);
  label5.caption := IntToStr(awalY);
  drag := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    image3.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if OpenPictureDialog2.Execute then
  begin
    image4.Picture.LoadFromFile(OpenPictureDialog2.FileName);
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  showMessage('Masukkan gambar yang akan dilakukan proses pergantian background');
  showMessage('Pilih atau select background pada gambar yang akan diproses');
  showMessage('Jika ingin menggunakan nilai threshold secara manual matikan threshold otomatis');
  showMessage('Masukan nilai K sesuai dengan keinginan (nilai K WAJIB bernilai ganjil)');
  showMessage('Pilih lah warna sebagai pengganti background melalui color box yang tersedia');
  showMessage('Jika ingin menggunakan bentuk background yang baru, maka masukan gambar background yang baru memalui load background dan hilangkan cetang pada colored background');
  showMessage('Setelah selesai, untuk melakukan proses peggantian background tekan tombol change background');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    Image2.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    Image3.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
end;

end.

