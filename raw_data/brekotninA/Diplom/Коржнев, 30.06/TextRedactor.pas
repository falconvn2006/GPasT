unit TextRedactor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sMemo, sDialogs, sButton, sGroupBox, ComCtrls,
  ExtCtrls, MPlayer, sPanel, Buttons, sBitBtn, sComboBox, Grids, DBGrids,
  acDBGrid, sLabel, ComObj;

type
  TForm7 = class(TForm)
    sGroupBox1: TsGroupBox;
    sButton2: TsButton;
    sButton3: TsButton;
    sOpenDialog1: TsOpenDialog;
    sSaveDialog1: TsSaveDialog;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sOpenDialog2: TsOpenDialog;
    Timer1: TTimer;
    sButton4: TsButton;
    sDBGrid2: TsDBGrid;
    sBitBtn4: TsBitBtn;
    sLabel1: TsLabel;
    procedure sButton1Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sComboBox1Change(Sender: TObject);
    procedure sComboBox2Change(Sender: TObject);
    procedure TrackQuestionCountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sBitBtn4Click(Sender: TObject);
    procedure sDBGrid2CellClick(Column: TColumn);
    procedure sDBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure sBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
//     function NewAudioName(): String;
//    procedure CreateParams(var Params:TCreateParams);
   // override;
  public
    { Public declarations }
     addedit: String;
     Table:String;
      work:String;
  end;

var
  Form7: TForm7;
  EditArray: array [1..6] of TEdit;
  PictureArray: array [1..3] of TEdit;
  RButtonPicArray: array [1..3] of TRadioButton;
  RButtonArray: array [1..6] of TRadioButton;
implementation
 uses   MyDB, MainMenu,
  SelectLesson, ResultVideo, IndependentWork;
{$R *.dfm}

procedure TForm7.sButton1Click(Sender: TObject);
begin
    ///
end;

procedure TForm7.sButton3Click(Sender: TObject);

begin
///
end;
procedure TForm7.sButton2Click(Sender: TObject);
var
  //var

 Word: variant;
 Doc: variant;
 S: variant;
 T: variant;
 i:integer;
 Max:integer;
begin
try
Word := CreateOleObject('Word.Application');
Doc:=Word.Documents.Add;
except
ShowMessage('Не могу запустить Microsoft Word');
end;
Word.Visible := True;

 S:=Word.Selection;
 S.Font.Bold := 1;
 S.Font.Size:=16;
S.ParagraphFormat.Alignment:=1;
S.TypeText('Результаты');
S.TypeParagraph;
S.TypeParagraph;
S.Font.Bold := 1;
S.Font.Size:=12;
S.ParagraphFormat.Alignment:=1;
S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+IntToStr(fMainMenu.userOld)+' класс');
//S.Font.Bold := _bold;
{вывод фразы полужирным шрифтом}
//S.Font.Bold := integer(True);
//S.TypeText('Be bold!');
//S.Font.Bold := integer(False);
//S.TypeParagraph;
//{прописным шрифтом}
//S.Font.Italic := integer(True);
//S.TypeText('Be daring!');
//S.Font.Italic := integer(False);

T := Doc.Tables.Add(Word.Selection.Range, 5, 5);
T.Cell(1, 1).Range.Text := 'ДАТА';
T.Cell(1, 2).Range.Text := 'ОЦЕНКА';
T.Cell(1, 3).Range.Text := 'ТИП ЗАДАЧ';
T.Cell(1, 4).Range.Text := 'ТРАЕКТОРИЯ';
T.Cell(1, 5).Range.Text := 'СЛОЖНОСТЬ';

T.Columns.Width := 100; // in points
T.Rows.Alignment :=1;
//T.Cells.VerticalAlignment := 1;
//T.Font.Bold := 0;
if not fDB.ADOQuery4.Active    then begin
   // fDB.ADOQuery4.Close();
    fDB.ADOQuery4.SQL.Clear;
   fDB.ADOQuery4.SQL.Add('select Name_Trajectory,QuestionType_Name,Slog,Mark,Effect,Date_Result from [PolRez] Where User_ID=:ID');
   fDB.ADOQuery4.Parameters.ParamByName('ID').Value:= fMainMenu.userId;
  fDB.ADOQuery4.Open;
  end;
fDB.ADOQuery4.First;
  i:=0;
   While not fDB.ADOQuery4.Eof do begin

       T.Cell(i+2, 1).Range.Text := fDB.ADOQuery4.FieldByName('Date_Result').AsString;
       T.Cell(i+2, 2).Range.Text := fDB.ADOQuery4.FieldByName('Mark').AsString;
       T.Cell(i+2, 3).Range.Text := fDB.ADOQuery4.FieldByName('QuestionType_Name').AsString;
       T.Cell(i+2, 4).Range.Text := fDB.ADOQuery4.FieldByName('Name_Trajectory').AsString;
       T.Cell(i+2, 5).Range.Text := fDB.ADOQuery4.FieldByName('Slog').AsString;
      fDB.ADOQuery4.Next;
      i:=i+1;

 end;


end;

procedure TForm7.sButton4Click(Sender: TObject);
begin
   if fDB.ADOQuery4.Active then
     fDB.ADOQuery4.Close;
   Close();
end;

procedure TForm7.Timer1Timer(Sender: TObject);
begin
  //
end;

procedure TForm7.sBitBtn2Click(Sender: TObject);
//var
//i:integer;
begin
//  if sOpenDialog2.Execute then
//    begin
//    Edit4.Text:= sOpenDialog2.FileName;
//    Image1.Picture.LoadFromFile(sOpenDialog2.FileName);
//    end;
//  if sOpenDialog2.Execute then
//    begin
//    Edit5.Text:= sOpenDialog2.FileName;
//    Image2.Picture.LoadFromFile(sOpenDialog2.FileName);
//    end;
//  if sOpenDialog2.Execute then
//    begin
//    Edit6.Text:= sOpenDialog2.FileName;
//    Image3.Picture.LoadFromFile(sOpenDialog2.FileName);
//    end;
end;
procedure TForm7.sComboBox1Change(Sender: TObject);
var //i:Integer;
Table_Rez: String;
//ID: integer;
begin

  fDB.ADORezTrack.Close();
    fDB.ADORezTrack.SQL.Clear;
//    fDB.ADOLessons.SQL.Add('select * from [Trajectories] order by Name_Trajectory asc');
    fDB.ADORezTrack.SQL.Add('SELECT User.User_ID, User.User_Login+ ''  '' + User.User_Name, User.Active, ['+Table_Rez+'].Mark, QuestionType.QuestionType_Name, ['+Table_Rez+'].Date_Result, Trajectories.Name_Trajectory   FROM [User], ['+Table_Rez+'] , [QuestionType]  where (User.User_ID = ['+Table_Rez+'].User_ID) and (User.User_ID = QuestionType.User_ID) and (User.Active = ''yes'') and (User.User_ID = ' + IntToStr(fMainMenu.userId) + ')');
    fDB.ADORezTrack.Open;
    fDB.ADORezTrack.First;
end;

procedure TForm7.sComboBox2Change(Sender: TObject);
begin
//    case sComboBox2.ItemIndex of
//    1: Table:='VideoVeryEasy';
//    2: Table:='VideoEasy';
//    3: Table:='VideoHard';
 //   end;
end;

procedure TForm7.TrackQuestionCountChange(Sender: TObject);
 //   var
 // i: Integer;
begin
 // Label1.Caption:=IntToStr(TrackQuestionCount.Position);
 // for I := 1 to 3 do begin
//    PictureArray[i].Visible:=false;
 //   RButtonPicArray[i].Visible:=false;
 // end;
//  for I := 1 to TrackQuestionCount.Position do begin
//    PictureArray[i].Visible:=true;
//    RButtonPicArray[i].Visible:=true;
//  end;
end;


procedure TForm7.FormCreate(Sender: TObject);
//var
// i:integer;
begin
//       for i:=2 to 32 do
 //  sDBGrid2.Columns[i].width:=40;
//  for i:=34 to 36 do
//   sDBGrid2.Columns[i].Width:=30;
//   sDBGrid2.Columns[33].Width:=190;
//   sDBGrid2.Columns[37].Width:=150;
//sDBGrid2.Columns.Clear;
end;

procedure TForm7.sBitBtn4Click(Sender: TObject);
begin
   ///
end;

procedure TForm7.sDBGrid2CellClick(Column: TColumn);
var i:Integer;
j:integer;
Table_Rez: String;
begin

    fDB.ADOQuery4.Close();
    fDB.ADOQuery4.SQL.Clear;
    fDB.ADOQuery4.SQL.Add('select * from [PolRez] Where User_ID=:ID');
    fDB.ADOQuery4.Parameters.ParamByName('ID').Value:= fMainMenu.userId;
    fDB.ADOQuery4.Open;
     fDB.ADOQuery4.First;
     if fDB.ADOQuery4.Eof then begin
        Work:='Class';
         fSelectLesson := TfSelectLesson.Create(nil);

      try
         Form7.Close;
        fSelectLesson.Traject;
        fSelectLesson.ShowModal();
  finally
        FreeAndNil(fSelectLesson);
  end;
     end
     else begin
  if ((fDB.ADOQuery4.FieldByName('Mark').AsInteger < 5) and (fDB.ADOQuery4.FieldByName('Effect').AsInteger < 6000)) then begin

 // fDB.ADOPolRez.FieldByName('Mark').AsString:=;
////  i :=sDBGrid1.SelectedIndex; //определяем номер выделенного поля (столбца)
////  j:=sDBGrid1.DataSource.DataSet.RecNo;
////  if (i=4) and (j=1)then // если это ячейка 4-го поля, то
//fIndependentWork.ShowModal;//показываем нашу форму
  Work:='Class';
  fSelectLesson := TfSelectLesson.Create(nil);
  try

    Form7.Close;
    fDB.ADOQuery7.Close();
    fDB.ADOQuery7.SQL.Clear;
    fDB.ADOQuery7.SQL.Add('select ID_Trajectory from [Trajectories] Where Name_Trajectory=:Name_Trajectory');
    fDB.ADOQuery7.Parameters.ParamByName('Name_Trajectory').Value:= sDBGrid2.DataSource.DataSet.FieldByName('Name_Trajectory').AsString;

/// sDBGrid2.DataSource.DataSet.FieldByName('Name_Trajectory')

    fDB.ADOQuery7.Open;
    fDB.ADOQuery7.First;
   // if (fSelectLesson.INDEX = 0) then   begin
 //   showmessage('Данный урок был удалён!!!');
//  end
//else
    fSelectLesson.INDEX :=  fDB.ADOQuery7.FieldByName('ID_Trajectory').AsInteger;
    fSelectLesson.Traject;
    fSelectLesson.sTreeView1.Selected := fSelectLesson.sTreeView1.Items[1];
    fSelectLesson.sBitBtn1Click(nil);
 //   fSelectLesson.ShowModal();

  finally
    FreeAndNil(fSelectLesson);
  end;

end
else
showmessage('У вас всё нормально!!!');
end;
//end;
end;

procedure TForm7.sDBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if sDBGrid2.DataSource.DataSet['Mark'] = 5 then
    sDBGrid2.Canvas.Brush.Color := clWhite;
  if sDBGrid2.DataSource.DataSet['Mark'] = 4 then
    sDBGrid2.Canvas.Brush.Color := clGreen;
  if sDBGrid2.DataSource.DataSet['Mark'] = 3 then
    sDBGrid2.Canvas.Brush.Color := clYellow;
  if sDBGrid2.DataSource.DataSet['Mark'] = 2 then
    sDBGrid2.Canvas.Brush.Color := clRed;
  if sDBGrid2.DataSource.DataSet['Mark'] = 1 then
    sDBGrid2.Canvas.Brush.Color := clGray;
  if sDBGrid2.DataSource.DataSet['Mark'] = 0 then
    sDBGrid2.Canvas.Brush.Color := clBlack;
  sDBGrid2.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TForm7.sBitBtn1Click(Sender: TObject);
begin
  Work:='Class';
    Form7.Close;
    fDB.ADOQuery4.Close();
    fDB.ADOQuery4.SQL.Clear;
    fDB.ADOQuery4.SQL.Add('select * from [PolRez] where User_ID=:ID order by Date_Result Desc');
    fDB.ADOQuery4.Parameters.ParamByName('ID').Value:= fMainMenu.userId;
    fDB.ADOQuery4.Open;
    fDB.ADOQuery4.First;
    if fDB.ADOQuery4.Eof then
     ShowMessage('Отсутствуют пройденные курсы!')
    else begin
      Work:='Class';
      fSelectLesson := TfSelectLesson.Create(nil);
      try
        Form7.Close;
        fDB.ADOQuery7.Close();
        fDB.ADOQuery7.SQL.Clear;
        fDB.ADOQuery7.SQL.Add('select ID_Trajectory from [Trajectories] Where Name_Trajectory=:Name_Trajectory');
        fDB.ADOQuery7.Parameters.ParamByName('Name_Trajectory').Value:= fDB.ADOQuery4.Fields[1].AsString;
        fDB.ADOQuery7.Open;
        fDB.ADOQuery7.First;
        fSelectLesson.INDEX :=  fDB.ADOQuery7.FieldByName('ID_Trajectory').AsInteger;
        fSelectLesson.Traject;
        fSelectLesson.sTreeView1.Selected := fSelectLesson.sTreeView1.Items[1];
        fSelectLesson.sBitBtn1Click(nil);
      finally
        FreeAndNil(fSelectLesson);
      end;
    end;
end;


end.

