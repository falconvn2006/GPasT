unit QuestionType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sListBox, sButton, sGroupBox, MPlayer, ExtCtrls,
  ComCtrls, sTrackBar, sPanel, sDialogs, sRadioButton, sLabel,
  sTreeView, Buttons, sBitBtn, sListView;
type
  TQuestionTypeForm = class(TForm)
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sListView1: TsListView;
    Timer1: TTimer;
    procedure sBitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sListView1DblClick(Sender: TObject);
    procedure sListView1KeyPress(Sender: TObject; var Key: Char);
    function GenerateQuestionID (CompleXity_ID:integer;QuestionType_ID:integer):integer;
    procedure Timer1Timer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QuestionTypeForm: TQuestionTypeForm;

implementation

uses Choose, IndependentWork, MyDB, ResultToChild, MainMenu, DB,
  DiagReports;


{$R *.dfm}

procedure TQuestionTypeForm.sBitBtn2Click(Sender: TObject);
var
  i,count,CountRecord:integer;
  temp,tempQuestions:string;
begin
  Hide;
  if fmainmenu.work='Ind' then
    begin
      fChoose:=TfChoose.Create(nil);
      try
        if sListView1.Selected<>nil then
          begin
            if (fFromWhere=1) then
                begin
                fdb.QuestionTypes_ID:=138;
                end else fdb.QuestionTypes_ID:=integer(sListView1.Selected.Data);
            fFromWhere:=0;
            Timer1.Enabled:=true;
            fChoose.ShowModal;
          end
        else
          ShowMessage('Вы не выбрали тип задачи!')
      finally
        FreeAndNil(fChoose);
      end;
    end;
  if fmainmenu.work='IndReport' then
    begin
      fChoose := TfChoose.Create(nil);
      try
        if sListView1.Selected<>nil then
          begin
            fdb.QuestionTypes_ID:=integer(sListView1.Selected.Data);
            fChoose.ShowModal;
          end
        else
          ShowMessage('Вы не выбрали тип задачи!')
      finally
        FreeAndNil(fChoose);
      end;
    end;
  if fmainmenu.work='Diag' then
    begin
      if sListView1.Selected<>nil then
        begin
          fdb.QuestionTypes_ID:=integer(sListView1.Selected.Data);
          Randomize;
          fDB.ADOQueryType.Close;
          fDB.ADOQueryType.SQL.Clear;
          fDB.ADOQueryType.SQL.Add('SELECT ID FROM CompleXity ORDER BY Question_Level');
          fDB.ADOQueryType.Open;
          SetLength(fDB.CompleXity_IDs,fdb.ADOQueryType.RecordCount);
          SetLength(fDB.Question_IDs,fdb.ADOQueryType.RecordCount);
          for i:=0 to length(fDB.Question_IDs)-1 do
            fDB.Question_IDs[i]:=-1;
          SetLength(fdb.Results,fdb.ADOQueryType.RecordCount);
          fDB.ADOQueryType.First;
          i:=0;
          While not fDB.ADOQueryType.Eof do
            begin
              fdb.CompleXity_IDs[i]:=fdb.ADOQueryType.FieldByName('ID').AsInteger;
              fdb.Question_IDs[i]:=-1;
              fdb.Question_IDs[i]:=GenerateQuestionID(fdb.CompleXity_IDs[i], integer(sListView1.Selected.Data));
              fDB.ADOQueryType.Next;
              i:=i+1;
            end;
          count:=0;
          for i:=0 to length(fdb.Question_IDs)-1 do
            begin
              if fdb.Question_IDs[i]=-1 then
                count:=count+1;
            end;
          if count=length(fdb.Question_IDs) then
            begin
              ShowMessage('Вопросы не найдены!');
              exit;
            end;
          temp:='';
          for i:=0 to length(fdb.Question_IDs)-1 do
            temp:=temp+IntToStr(fdb.Question_IDs[i])+',';
          Delete(temp,length(temp),1);
          if temp='' then
            begin
              ShowMessage('Вопросы не найдены!');
              exit;
            end;
          fDB.ADOInsertQuestion.Close;
          fDB.ADOInsertQuestion.SQL.Clear;
          fDB.ADOInsertQuestion.SQL.ADD('SELECT DISTINCT Q.ID AS Q_ID, Q.Nazvanie, Q.QuestionType_ID, Q.AnswerType, Q.ConditionAudio_ID, Q.ConditionVideo_ID, Q.ConditionPhoto_ID,Q.SolveAudio_ID, Q.SolveVideo_ID, Q.SolvePhoto_ID, Q.Theory_ID, Q.WorkType, Q.CompleXity_ID');
          fDB.ADOInsertQuestion.SQL.ADD('FROM Questions AS Q WHERE Q.ID IN ('+temp+') AND Q.WorkType=2');
          fDB.ADOInsertQuestion.Open;
          if fDB.ADOInsertQuestion.RecordCount=0 then
            begin
              ShowMessage('Вопросы не найдены!');
              exit;
            end;
          fdb.CurrentQuestion:=-1;
          for i:=0 to length(fdb.Results)-1 do
            fdb.Results[i]:=false;
          fIndependentWork := TfIndependentWork.Create(nil);
          try
            fIndependentWork.ShowModal;
          finally
            FreeAndNil(fIndependentWork);
          end;
        end;
        fDB.ADOQueryType.Close;
        fDB.ADOQueryType.SQL.Clear; 
    end;
    if fmainmenu.work='DiagReport' then
    begin
      if sListView1.Selected<>nil then
        begin
          fdb.QuestionTypes_ID:=integer(sListView1.Selected.Data);
          DiagReportsForm := TDiagReportsForm.Create(nil);
          try
            DiagReportsForm.ShowModal;
          finally
            FreeAndNil(DiagReportsForm);
          end;
        end;
    end;
  Show;
end;

function TQuestionTypeForm.GenerateQuestionID(CompleXity_ID:integer;QuestionType_ID:integer):integer;
var
  count,i,j:integer;
  label NextRandom;
begin
  Result:=-1;
  fDB.ADOInsertQuestion.Close;
  fDB.ADOInsertQuestion.SQL.Clear;
  fDB.ADOInsertQuestion.SQL.ADD('SELECT DISTINCT Q.ID AS QID');
  fDB.ADOInsertQuestion.SQL.ADD('FROM Questions AS Q, TrajectLessons AS TL, Lessons AS L, LessonsQuestions AS LQ, CompleXity AS CX, Traject AS T, QuestionTypes AS QT');
  fDB.ADOInsertQuestion.SQL.ADD('WHERE CX.ID=:1 and TL.Lessons_ID=L.ID and LQ.Lesson_ID=L.ID and CX.ID=Q.CompleXity_ID and Q.ID=LQ.Question_ID and T.ID=TL.Traject_ID and QT.ID=Q.QuestionType_ID and QT.ID=:2 and Q.WorkType=2 AND T.Zoya_Level=:3');
  fDB.ADOInsertQuestion.parameters.ParamByName('1').value:=CompleXity_ID;
  fDB.ADOInsertQuestion.parameters.ParamByName('2').value:=QuestionType_ID;
  fDB.ADOInsertQuestion.parameters.ParamByName('3').value:=fdb.Zoya_level;
  fDB.ADOInsertQuestion.Open;
  if fdb.ADOInsertQuestion.RecordCount=0 then
    begin
      if fdb.ADOInsertQuestion.Active then
        fdb.ADOInsertQuestion.close;
      exit;
    end;
  fDB.ADOInsertQuestion.First;
  if fdb.ADOInsertQuestion.RecordCount=1 then
    begin
      for i:=0 to length(fdb.Question_IDs)-1 do
        begin
          if fdb.Question_IDs[i]<>fDB.ADOInsertQuestion.fieldByName('QID').AsInteger then
            begin
              Result:=fDB.ADOInsertQuestion.fieldByName('QID').AsInteger;
              if fdb.ADOInsertQuestion.Active then
                fdb.ADOInsertQuestion.close;
              exit;
            end
          else
              begin
                exit;
              end;
        end;
    end;
NextRandom:
  count:=Random(fdb.ADOInsertQuestion.RecordCount);
  for j:=0 to fdb.ADOInsertQuestion.RecordCount-1 do
    begin
      if j=count then
        begin
          for i:=0 to length(fdb.Question_IDs)-1 do
            begin
              if fdb.Question_IDs[i]<>fDB.ADOInsertQuestion.fieldByName('QID').AsInteger then
                begin
                  Result:=fDB.ADOInsertQuestion.fieldByName('QID').AsInteger;
                  if fdb.ADOInsertQuestion.Active then
                    fdb.ADOInsertQuestion.close;
                  exit;
                end
                else
                  goto NextRandom;
            end;
          if fdb.ADOInsertQuestion.Active then
            fdb.ADOInsertQuestion.close;
        Break;
        end;
      fdb.ADOInsertQuestion.Next;
    end;
    if fdb.ADOInsertQuestion.Active then
      fdb.ADOInsertQuestion.close;
end;


procedure TQuestionTypeForm.FormShow(Sender: TObject);
begin
  sListView1.Items.Clear;
  fDB.ADOQueryType.Close;
  fDB.ADOQueryType.SQL.Clear;
  fDB.ADOQueryType.SQL.Add('SELECT ID, Nazvanie FROM QuestionTypes ORDER BY Nazvanie');
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

procedure TQuestionTypeForm.sListView1DblClick(Sender: TObject);
begin
  sBitBtn2.Click;
end;

procedure TQuestionTypeForm.sListView1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key=#13) and sListView1.Focused then
    sBitBtn2.Click;
end;

procedure TQuestionTypeForm.Timer1Timer(Sender: TObject);
begin
  if (fFromWhere=1) then
  begin
    Timer1.Enabled:=false;
    sBitBtn2.Click;
  end;
end;

end.
