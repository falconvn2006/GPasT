unit MagicKartinka;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, StdCtrls, sButton, sGroupBox, Grids, DBGrids,
  acDBGrid;

type
  TForm12 = class(TForm)
    sGroupBox1: TsGroupBox;
    sButton1: TsButton;
    sButton2: TsButton;
    sDBGrid1: TsDBGrid;
    procedure sButton2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation
   uses  QuestionType;
{$R *.dfm}

procedure TForm12.sButton2Click(Sender: TObject);
begin
    Close();
end;

procedure TForm12.Image1Click(Sender: TObject);
begin
 //if image1.Tag = 0 then
 // begin
 //  image1.Picture.LoadFromFile('Picture/1.bmp');
 //  image1.Tag:=1;
//  end
// else
  begin

  end;
  ShowMessage('PRODULY!!!!');
  Close();
end;

procedure TForm12.Image2Click(Sender: TObject);
begin

// else
//  begin
//   image2.Picture.LoadFromFile('Picture/2.bmp');
//   image2.Tag:=0;

end;

procedure TForm12.Image3Click(Sender: TObject);
begin
// if image3.Tag = 0 then
 // begin
 //  image3.Picture.LoadFromFile('Picture/1.bmp');
 //  image3.Tag:=1;
 // end
// else

end;

procedure TForm12.Image4Click(Sender: TObject);
begin
// if image4.Tag = 0 then
 // begin
 //  image4.Picture.LoadFromFile('Picture/1.bmp');
 //  image4.Tag:=1;
 // end
// else
 
end;

procedure TForm12.FormCreate(Sender: TObject);
//var
 // i: Integer;
 // s: string;
begin
 // for i:= 0 to sListBox1.Items.Count - 1 do
  begin
  //  if sListBox1.Selected[i] then s:= s + 'Выделена строка ' + IntToStr(i+1) + #13#10;
  end;
 // ShowMessage(s);
end;

end.
