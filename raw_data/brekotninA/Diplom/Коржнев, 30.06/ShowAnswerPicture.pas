unit ShowAnswerPicture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, StdCtrls, Buttons, sBitBtn, Grids;

type
  TShowAnswerPictureForm = class(TForm)
    sPanel100: TsPanel;
    sBitBtn21: TsBitBtn;
    sPanel101: TsPanel;
    StringGrid1: TStringGrid;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    sBitBtn1: TsBitBtn;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sBitBtn1Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    ImagePictureWidth:integer;
    ImagePictureHeight:integer;
    ImagePath:string;
  end;

var
  ShowAnswerPictureForm: TShowAnswerPictureForm;

implementation

uses Math, Image, MyDB, MainMenu;

{$R *.dfm}

procedure TShowAnswerPictureForm.FormShow(Sender: TObject);
var
  MaxW,MaxH,i:Integer;
  Rows,Cols:Integer;
  Image:TImage;
begin
  if fdb.ADOInsertQuestion.FieldByName('SolveAudio_ID').IsNull and
    fdb.ADOInsertQuestion.FieldByName('SolveVideo_ID').IsNull and
    fdb.ADOInsertQuestion.FieldByName('SolvePhoto_ID').IsNull then
    begin
      sBitBtn1.Enabled:=false;
      sBitBtn1.Visible:=false;
    end
  else
    begin
      //sBitBtn1.Enabled:=true;
      //sBitBtn1.Visible:=true;
    end;
  MaxW:=0;
  MaxH:=0;
  Rows:=1;
  Cols:=1;
  for i:=1 to 6 do
    begin
      Image:=TImage(FindComponent('Image'+IntToStr(i)));
      if (Image.Picture<>nil) and (Image.Picture.Width<>0) and (Image.Picture.Height<>0)  then
        begin
          if (Image.Width<Image.Picture.Width) or (Image.Height<Image.Picture.Height) then
            Image.Stretch:=true
          else
            Image.Stretch:=false;
          if Image.Picture.Width>MaxW then
            MaxW:=Image.Picture.Width;
          if Image.Picture.Height>MaxH then
            MaxH:=Image.Picture.Height;
          if (i=2) or (i=4) or (i=6) then
            Cols:=2;
          if (i=3) or (i=4) then
            Rows:=2;
          if (i=5) or (i=6) then
            Rows:=3;
        end;
    end;
  StringGrid1.RowCount:=Rows;
  StringGrid1.ColCount:=Cols;
  for i:=0 to Cols-1 do
    StringGrid1.ColWidths[i]:=390;
    //MaxW;
  for i:=0 to Rows-1 do
    StringGrid1.RowHeights[i]:=250;
    //MaxH;
end;

procedure TShowAnswerPictureForm.sBitBtn1Click(Sender: TObject);
begin
  Hide;
  try
    ImageForm:= TImageForm.Create(nil);
    ImageForm.ShowModal;
  finally
    FreeAndNil(ImageForm);
  end;
  Show;
end;

procedure TShowAnswerPictureForm.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i:integer;
  Image:TImage;
begin
  if (ACol=0) and (ARow=0) then
    begin
      if (Image1.Picture<>nil) and (Image1.Picture.Width<>0) and (Image1.Picture.Height<>0) then
        StringGrid1.Canvas.StretchDraw(Rect,Image1.Picture.Graphic);
    end;
  if (ACol=1) and (ARow=0) then
    begin
      if (Image2.Picture<>nil) and (Image2.Picture.Width<>0) and (Image2.Picture.Height<>0) then
        StringGrid1.Canvas.StretchDraw(Rect,Image2.Picture.Graphic);
    end;
  if (ACol=0) and (ARow=1) then
    begin
      if (Image3.Picture<>nil) and (Image3.Picture.Width<>0) and (Image3.Picture.Height<>0) then
        StringGrid1.Canvas.StretchDraw(Rect,Image3.Picture.Graphic);
    end;
  if (ACol=1) and (ARow=1) then
    begin
      if (Image4.Picture<>nil) and (Image4.Picture.Width<>0) and (Image4.Picture.Height<>0) then
        StringGrid1.Canvas.StretchDraw(Rect,Image4.Picture.Graphic);
    end;
  if  (ACol=0) and (ARow=2) then
    begin
      if (Image5.Picture<>nil) and (Image5.Picture.Width<>0) and (Image5.Picture.Height<>0) then
        StringGrid1.Canvas.StretchDraw(Rect,Image5.Picture.Graphic);
    end;
  if (ACol=1) and (ARow=2) then
    begin
      if (Image6.Picture<>nil) and (Image6.Picture.Width<>0) and (Image6.Picture.Height<>0) then
        StringGrid1.Canvas.StretchDraw(Rect,Image6.Picture.Graphic);
    end;
end;

procedure TShowAnswerPictureForm.StringGrid1SelectCell(Sender: TObject; ACol,ARow: Integer; var CanSelect: Boolean);
begin
  {if (ACol=0) and (ARow=0) then
    begin
      if (Image1.Picture<>nil) and (Image1.Picture.Width<>0) and (Image1.Picture.Height<>0) then
        begin
          ImagePictureWidth:=Image1.Picture.Width+100;
          ImagePictureHeight:=Image1.Picture.Height+100;
          ImagePath:=ExtractFilePath(Application.ExeName)+fdb.ADOQueryAnswers.FieldByName('Picture').AsString;
        end;
    end;
  if (ACol=1) and (ARow=0) then
    begin
      if (Image1.Picture<>nil) and (Image1.Picture.Width<>0) and (Image1.Picture.Height<>0) then
        begin
          ImagePictureWidth:=Image1.Picture.Width+100;
          ImagePictureHeight:=Image1.Picture.Height+100;
          ImagePath:=ExtractFilePath(Application.ExeName)+fdb.ADOQueryAnswers.FieldByName('Picture').AsString;
        end;
    end;

 }
end;

end.
