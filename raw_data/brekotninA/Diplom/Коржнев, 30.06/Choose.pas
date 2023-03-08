unit Choose;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sGroupBox, ComCtrls, sListView;

type
  TfChoose = class(TForm)
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sListView1: TsListView;
    procedure FormShow(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sListView1KeyPress(Sender: TObject; var Key: Char);
    procedure sListView1DblClick(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fChoose: TfChoose;

implementation

uses IndependentWork, MyDB, QuestionType, MainMenu, IndReports, OptionUser;

{$R *.dfm}



procedure TfChoose.FormShow(Sender: TObject);
begin
  sListView1.Items.Clear;
  fDB.ADOQueryType.Close;
  fDB.ADOQueryType.SQL.Clear;
  fDB.ADOQueryType.SQL.Add('SELECT ID, Nazvanie FROM CompleXity ORDER BY ID');
  fDB.ADOQueryType.Open;
  fDB.ADOQueryType.First;
  While not fDB.ADOQueryType.Eof do
    begin
      sListView1.AddItem(fDB.ADOQueryType.Fields[1].AsString, TObject(fDB.ADOQueryType.Fields[0].AsInteger));
      fDB.ADOQueryType.Next;
    end;
  fDB.ADOQueryType.Close;
  fDB.ADOQueryType.SQL.Clear;
  sListView1.SetFocus;
  if sListView1.Items.Count>0 then
    sListView1.SelectItem(0);
end;

procedure TfChoose.sBitBtn2Click(Sender: TObject);
begin
 if sListView1.Selected=Nil then
    begin
      ShowMessage('Выберите сложность!');
      exit;
    end;
    fdb.CompleXity_ID:=Integer(sListView1.Selected.Data);
    fDB.ADOInsertQuestion.Close;
    fDB.ADOInsertQuestion.SQL.Clear;
    fDB.ADOInsertQuestion.SQL.ADD('SELECT DISTINCT Q.ID AS Q_ID');
    fDB.ADOInsertQuestion.SQL.ADD('FROM Questions AS Q, TrajectLessons AS TL, Lessons AS L, LessonsQuestions AS LQ, CompleXity AS CX, Traject AS T, QuestionTypes AS QT');
    fDB.ADOInsertQuestion.SQL.ADD('WHERE CX.ID=:1 AND T.ID=TL.Traject_ID AND TL.Lessons_ID=L.ID AND LQ.Lesson_ID=L.ID AND CX.ID=Q.CompleXity_ID AND Q.ID=LQ.Question_ID AND QT.ID=:2 AND QT.ID=Q.QuestionType_ID AND Q.WorkType=1');
    fDB.ADOInsertQuestion.Parameters.ParamByName('1').Value:=fDB.CompleXity_ID;
    fDB.ADOInsertQuestion.Parameters.ParamByName('2').Value:=fDB.QuestionTypes_ID;
    fDB.ADOInsertQuestion.Open;
    if fDB.ADOInsertQuestion.RecordCount=0 then
      begin
        ShowMessage('Вопросы не найдены!');
        exit;
      end;
    hide;
      if fmainmenu.work='Ind' then
        begin
          fIndependentWork:=TfIndependentWork.Create(nil);
          try
            fIndependentWork.ShowModal;
          finally
            FreeAndNil(fIndependentWork);
          end;
        end;
      if fmainmenu.work='IndReport' then
        begin
          IndReportsForm:=TIndReportsForm.Create(nil);
          try
            IndReportsForm.ShowModal;
          finally
            FreeAndNil(IndReportsForm);
          end;
        end;
      show;
end;


procedure TfChoose.sListView1DblClick(Sender: TObject);
begin
  sBitBtn2Click(Sender);
end;

procedure TfChoose.sListView1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key=#13) and sListView1.Focused then
    sBitBtn2Click(Sender);
end;

procedure TfChoose.sBitBtn1Click(Sender: TObject);
begin
  Close();
end;

end.
