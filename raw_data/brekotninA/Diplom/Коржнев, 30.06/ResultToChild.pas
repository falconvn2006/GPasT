unit ResultToChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, sBitBtn, sMemo, sLabel, Math,
  sButton, ComCtrls, ComObj, MPlayer, DateUtils, DB, ADODB, Menus;

type
  TfResultToChild = class(TForm)
    sBitBtn1: TsBitBtn;
    LabelName: TsLabel;
    LabelClass: TsLabel;
    LabelDate: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    Timer1: TTimer;
    sBitBtn5: TsBitBtn;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    PopupMenu2: TPopupMenu;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    PopupMenu3: TPopupMenu;
    ou4rh1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    ADOQuery1: TADOQuery;
    ADOQuery1User_Family: TWideStringField;
    ADOQuery1User_Login: TWideStringField;
    ADOQuery1GroupsNazvanie: TWideStringField;
    ADOQuery1Start_Data: TDateTimeField;
    ADOQuery1TrajectNazvanie: TWideStringField;
    ADOQuery1LessonsNazvanie: TWideStringField;
    ADOQuery1Mark: TIntegerField;
    ADOQuery1Effect: TIntegerField;
    ADOQuery2: TADOQuery;
    sBitBtn4: TsBitBtn;
    N11: TMenuItem;
    sLabel1: TsLabel;
    procedure FormShow(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sBitBtn5Click(Sender: TObject);
    procedure sBitBtn6Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure ou4rh1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure sBitBtn4Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QuestionType_Name:String;
    RightAnswerCount:Integer;
  end;

var
  fResultToChild: TfResultToChild;

implementation

uses MainMenu, IndependentWork, Choose, OptionUser, MyDB, SelectLesson, QuestionType, Utils, Misc;

{$R *.dfm}



procedure TfResultToChild.FormShow(Sender: TObject);
var
  Mark,i:Integer;
  effect1,effect2,temp:double;
begin
  LabelName.Caption:=fMainMenu.userName+' '+fMainmenu.userFirstName;
  LabelClass.Caption:=fMainMenu.UserClass+' класс';
  LabelDate.Caption:=DateToStr(Date);
  temp:=Roundto(StrToTime(fIndependentWork.LabelTime.Caption)*100000,0);
  {if temp<1.0 then
    temp:=1.0                                  1
  else
    temp:=Roundto(StrToTime(fIndependentWork.LabelTime.Caption),-2);}
    if (fSelectLesson<>nil) and(fSelectLesson.Continue='yes') then
      begin
        fdb.ADOQueryContRez.Close;
        fdb.ADOQueryContRez.SQL.Clear;
        fdb.ADOQueryContRez.SQL.Add('SELECT RightAnswer FROM Continue_Class AS CW, Traject AS T, Lessons AS L, Users AS U, Questions AS Q WHERE CW.Id_Traject=T.ID AND CW.Id_Lessons=L.ID AND CW.User_ID=U.ID AND CW.ID_Question=Q.ID');
        fdb.ADOQueryContRez.SQL.Add('AND T.ID=:1 AND L.ID=:2 AND U.ID=:3 ORDER BY CW.ID desc');
        fdb.ADOQueryContRez.Parameters.ParamByName('1').Value:=fSelectLesson.Id_Traj;
        fdb.ADOQueryContRez.Parameters.ParamByName('2').Value:=fSelectLesson.Id_Lesson;
        fdb.ADOQueryContRez.Parameters.ParamByName('3').Value:=fMainMenu.userId;
        fdb.ADOQueryContRez.Open;
        fdb.ADOQueryContRez.first;
        case Round(((RightAnswerCount+fdb.ADOQueryContRez.FieldByName('RightAnswer').AsInteger)/fIndependentWork.NodeCount)*100) of
          0..49: Mark:=2;
          50..74: Mark:=3;
          75..89: Mark:=4;
          90..100: Mark:=5;
        end;
        effect1:=Roundto((((RightAnswerCount+fdb.ADOQueryContRez.FieldByName('RightAnswer').AsInteger)/(fIndependentWork.NodeCount)*temp))*1000,-2);
        sLabel5.Caption:='¬ы ответили правильно на '+IntToStr(RightAnswerCount+fdb.ADOQueryContRez.FieldByName('RightAnswer').AsInteger)+' вопрос(ов) из '+IntToStr(fIndependentWork.NodeCount);
        sLabel3.Caption:='ѕроцент правильно выполненных: '+IntToStr(round(((RightAnswerCount+fdb.ADOQueryContRez.FieldByName('RightAnswer').AsInteger)/fIndependentWork.NodeCount)*100))+'%';
        sLabel6.Caption:='Ёффективность выпонени€: '+FloatToStr(effect1);
      end
    else
      begin
        case Round((RightAnswerCount/fIndependentWork.NodeCount)*100) of
          0..49: Mark:=2;
          50..74: Mark:=3;
          75..89: Mark:=4;
          90..100: Mark:=5;
        end;
        effect2:=Roundto(RightAnswerCount/(fIndependentWork.NodeCount*temp)*100,-2);
        sLabel5.Caption:='¬ы ответили правильно на '+IntToStr(RightAnswerCount)+' вопрос(ов) из '+IntToStr(fIndependentWork.NodeCount);
        sLabel3.Caption:='ѕроцент правильно выполненных: '+IntToStr(round((RightAnswerCount/fIndependentWork.NodeCount)*100))+'%';
        sLabel6.Caption:='Ёффективность выпонени€: '+FloatToStr(effect2);
      end;
  if fIndependentWork.LabelTime.Caption='0:00:00' then
    fIndependentWork.LabelTime.Caption:='0:00:01';
  sLabel2.Caption:='¬рем€ выполнени€: '+fIndependentWork.LabelTime.Caption;
  if fIndependentWork.Mark then
    Mark:=Mark-1;
  sLabel4.Caption:='ќценка: '+InttoStr(Mark);
  if fMainMenu.work='Class' then
    begin
      try
        fdb.ADOConnection1.BeginTrans;
        if fdb.ADOQueryAnswers.Active then
          fdb.ADOQueryAnswers.Close;
          fdb.ADOQueryAnswers.SQL.Clear;
          fdb.ADOQueryAnswers.SQL.ADD('INSERT INTO Results_Class(User_ID, Start_Data, Finish_time, Traject_id, Lessons_id, Mark, Effect) VALUES(:1,:2,:3,:4,:5,:6,:7)');
          fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=fMainMenu.userId;
          fdb.ADOQueryAnswers.Parameters.ParamByName('2').Value:=fIndependentWork.Start;
          fdb.ADOQueryAnswers.Parameters.ParamByName('3').Value:=SecondsBetween(Now,fIndependentWork.Start);
          fdb.ADOQueryAnswers.Parameters.ParamByName('4').Value:=fSelectLesson.Id_Traj;
          fdb.ADOQueryAnswers.Parameters.ParamByName('5').Value:=fSelectLesson.Id_Lesson;
          fdb.ADOQueryAnswers.Parameters.ParamByName('6').Value:=Mark;
          if fSelectLesson.Continue='yes' then
            fdb.ADOQueryAnswers.Parameters.ParamByName('7').Value:=effect1
          else
            fdb.ADOQueryAnswers.Parameters.ParamByName('7').Value:=effect2;
          fdb.ADOQueryAnswers.ExecSQL;
        if fdb.ADOConnection1.InTransaction then
          fdb.ADOConnection1.CommitTrans;
      except
        on E:Exception do
          begin
            if fdb.ADOConnection1.InTransaction then
              fdb.ADOConnection1.RollbackTrans;
            ShowMessage(E.Message);
            exit;
          end;
      end;
    end;
    if fMainMenu.work='Ind' then
    begin
      try
        fdb.ADOConnection1.BeginTrans;
        if fdb.ADOQueryAnswers.Active then
          fdb.ADOQueryAnswers.Close;
        fdb.ADOQueryAnswers.SQL.Clear;
        fdb.ADOQueryAnswers.SQL.ADD('INSERT INTO Results_Ind(User_ID, Start_Data, Finish_time, Mark, Effect) VALUES(:1,:2,:3,:4,:5)');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=fMainMenu.userId;
        fdb.ADOQueryAnswers.Parameters.ParamByName('2').Value:=fIndependentWork.Start;
        fdb.ADOQueryAnswers.Parameters.ParamByName('3').Value:=SecondsBetween(Now,fIndependentWork.Start);
        fdb.ADOQueryAnswers.Parameters.ParamByName('4').Value:=Mark;
        fdb.ADOQueryAnswers.Parameters.ParamByName('5').Value:=effect2;
        fdb.ADOQueryAnswers.ExecSQL;
        if fdb.ADOConnection1.InTransaction then
          fdb.ADOConnection1.CommitTrans;
      except
        on E:Exception do
          begin
            if fdb.ADOConnection1.InTransaction then
              fdb.ADOConnection1.RollbackTrans;
            ShowMessage(E.Message);
            exit;
          end;
      end;
    end;
    if fMainMenu.work='Diag' then
      begin
        try
          fdb.ADOConnection1.BeginTrans;
          for i:=0 to length(fdb.Question_IDs)-1 do
            begin
              if fdb.Question_IDs[i]=-1 then
                Continue;
              if fdb.ADOQueryAnswers.Active then
                fdb.ADOQueryAnswers.Close;
              fdb.ADOQueryAnswers.SQL.Clear;
              fdb.ADOQueryAnswers.SQL.ADD('INSERT INTO Results_Diag(User_ID, Start_Data, Finish_time, Mark, Effect, Question_ID) VALUES(:1,:2,:3,:4,:5,:6)');
              fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=fMainMenu.userId;
              fdb.ADOQueryAnswers.Parameters.ParamByName('2').Value:=fIndependentWork.Start;
              fdb.ADOQueryAnswers.Parameters.ParamByName('3').Value:=SecondsBetween(Now,fIndependentWork.Start);
              if fDB.Results[i] then
                begin
                  fdb.ADOQueryAnswers.Parameters.ParamByName('4').Value:=5;
                  fdb.ADOQueryAnswers.Parameters.ParamByName('5').Value:=Roundto(1/(1*temp)*100,-2);
                end
              else
                begin
                  fdb.ADOQueryAnswers.Parameters.ParamByName('4').Value:=2;
                  fdb.ADOQueryAnswers.Parameters.ParamByName('5').Value:=Roundto(0/(1*temp)*100,-2);
                end;
              fdb.ADOQueryAnswers.Parameters.ParamByName('6').Value:=fdb.Question_IDs[i];
              fdb.ADOQueryAnswers.ExecSQL;
            end;
          if fdb.ADOConnection1.InTransaction then
            fdb.ADOConnection1.CommitTrans;
        except
          on E:Exception do
            begin
              if fdb.ADOConnection1.InTransaction then
                fdb.ADOConnection1.RollbackTrans;
              ShowMessage(E.Message);
              exit;
            end;
        end;
    end;
  if fdb.ADOQueryAnswers.Active then
    fdb.ADOQueryAnswers.Close;
end;

procedure TfResultToChild.sBitBtn5Click(Sender: TObject);
begin
  ClassReport4;
end;


procedure TfResultToChild.sButton1Click(Sender: TObject);
begin
  ClassReport1;
end;


procedure TfResultToChild.sBitBtn6Click(Sender: TObject);
var
  cp,sp:tpoint;
begin
  cp.X:=sBitBtn5.Left;
  cp.Y:=sBitBtn5.Top+sBitBtn5.Height;
  sp:=clienttoscreen(cp);
  if fMainMenu.work='Class' then
    PopupMenu1.Popup(sp.X,sp.Y);
  if fMainMenu.work='Ind' then
    PopupMenu2.Popup(sp.X,sp.Y);
  if fMainMenu.work='Diag' then
    PopupMenu3.Popup(sp.X,sp.Y);
end;

procedure TfResultToChild.N10Click(Sender: TObject);
var
 Word:variant;
 Doc:variant;
 S,T:variant;
 begin_date,end_date:TDateTime;
 Marks:array [1..2] of integer;
 Effects:array [1..2] of integer;
 i:integer;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Ќе могу запустить Microsoft Word');
    exit;
  end;
  S:=Word.Selection;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MIN(Start_Data) AS StartDate FROM Results_Diag WHERE User_ID=:1');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('¬нутренн€€ ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  begin_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MAX(Start_Data) AS StartDate FROM Results_Diag WHERE User_ID=:1');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('¬нутренн€€ ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  end_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;

  S.TypeText('ƒата итоговой диагностики: '+DateToStr(end_date));
  S.ParagraphFormat.Alignment:=0;
  S.TypeParagraph;
  S.Font.UnderLine:=0;
  S.Font.Size:=12;
  S.ParagraphFormat.Alignment:=2;
  S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
  S.TypeParagraph;
  S.Font.Bold:=1;
  S.Font.Size:=16;
  S.ParagraphFormat.Alignment:=1;
  S.TypeText('¬едомость результатов по развитию логического мышлени€' +#13#10+'ƒиагностика');
  S.Font.Bold:=1;
  S.Font.Size:=14;
  S.ParagraphFormat.Alignment:=1;


  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.Close;
  if not ADOQuery2.Active then
    ADOQuery2.close;
  adoquery2.sql.clear;
  adoquery2.sql.add('SELECT Users.User_Family AS Family, Users.User_Login AS Login, Groups.Nazvanie AS Groups, Results_Diag.Start_Data AS Start_Data, Results_Diag.Finish_Time AS Finish_Time,');
  adoquery2.sql.add('Results_Diag.Mark AS Mark, Results_Diag.Effect AS Effect, CompleXity.Nazvanie AS CompleXity_Nazvanie, QuestionTypes.Nazvanie AS QT_Nazvanie');
  adoquery2.sql.add('FROM Groups, Results_Diag, Users, CompleXity, Questions, QuestionTypes');
  adoquery2.sql.add('WHERE Users.Group_id=Groups.ID and Results_Diag.User_ID=Users.ID and Results_Diag.User_ID=:1 and Results_Diag.CompleXity_Id=CompleXity.ID');
  adoquery2.sql.add('and Results_Diag.Question_ID=Questions.ID and Questions.QuestionType_ID=QuestionTypes.ID and QuestionTypes.ID=:2 and ((Results_Diag.Start_Data=:3) or (Results_Diag.Start_Data=:4))');
  adoquery2.sql.add('ORDER BY CompleXity.ID, Results_DIag.Start_Data;');
  ADOQuery2.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  ADOQuery2.Parameters.ParamByName('2').Value:=fdb.QuestionTypes_ID;
  ADOQuery2.Parameters.ParamByName('3').Value:=begin_date;
  ADOQuery2.Parameters.ParamByName('4').Value:=end_date;
  ADOQuery2.Open;


  if ADOQuery2.RecordCount=0 then
    begin
      ShowMessage('–езуьтаты не найдены!');
      exit;
    end;
  S.TypeParagraph;
  S.ParagraphFormat.Alignment:=1;
  S.Font.Size:=14;
  S.TypeText(ADOQuery2.FieldByName('QT_Nazvanie').AsString);
  ADOQuery2.First;

      T:= Doc.Tables.Add(Word.Selection.Range, 3, 5);
      T.Rows.Alignment := 1;
      T.Cell(1, 1).Range.Text := '—–≈ƒЌяя ќ÷≈Ќ ј';
      T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 1).Borders.Enable:=1;
      T.Cell(1, 2).Range.Text := '';
      T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 2).Borders.Enable:=1;
      T.Cell(1, 3).Range.Text := 'Ё‘‘≈ “»¬Ќќ—“№';
      T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 3).Borders.Enable:=1;
      T.Cell(1, 4).Range.Text := '';
      T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 4).Borders.Enable:=1;
      T.Cell(1, 5).Range.Text := 'ќ“ЌќЎ≈Ќ»≈';
      T.Cell(1, 5).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 5).Borders.Enable:=1;
      T.Cell(1, 3).Merge(T.Cell(1, 4));
      T.Cell(1, 1).Merge(T.Cell(1, 2));

      T.Cell(2, 1).Range.Text := 'Ќј„јЋ№Ќјя';
      T.Cell(2, 1).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 1).Borders.Enable:=1;
      T.Cell(2, 2).Range.Text := '»“ќ√ќ¬јя';
      T.Cell(2, 2).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 2).Borders.Enable:=1;
      T.Cell(2, 3).Range.Text := 'Ќј„јЋ№Ќјя';
      T.Cell(2, 3).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 3).Borders.Enable:=1;
      T.Cell(2, 4).Range.Text := '»“ќ√ќ¬јя';
      T.Cell(2, 4).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 4).Borders.Enable:=1;
      T.Cell(2, 5).Range.Text := ' ќЌ/Ќј„';
      T.Cell(2, 5).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 5).Borders.Enable:=1;

  i:=1;
  While not ADOQuery2.Eof do
    begin
      if begin_date<>end_date then
        begin
          Marks[i]:=ADOQuery2.FieldByName('Mark').AsInteger;
          S.ParagraphFormat.Alignment:=1;
          Effects[i]:=ADOQuery2.FieldByName('Effect').AsInteger;
          if (Marks[1]<>0) and (Marks[2]<>0) then
            break;
        end
        else
        begin
          Marks[1]:=ADOQuery2.FieldByName('Mark').AsInteger;
          S.ParagraphFormat.Alignment:=1;
          Effects[1]:=ADOQuery2.FieldByName('Effect').AsInteger;
          break;
        end;
        ADOQuery2.Next;
        i:=i+1;
    end;
    if ADOQuery2.Active then
      ADOQuery2.close;
    for i:=1 to 4 do
        begin
          if Marks[1]=2 then
            T.Cell(i+2, 1).Range.Font.Color := clRed;
          T.Cell(i+2, 1).Range.Text := inttostr(Marks[1]);
          T.Cell(i+2, 1).Range.ParagraphFormat.alignment:=1;
          T.Cell(i+2, 1).Borders.Enable:=1;
          if begin_date<>end_date then
            begin
              if Marks[2]=2 then
                T.Cell(i+2, 2).Range.Font.Color := clRed;
              T.Cell(i+2, 2).Range.Text:=inttostr(Marks[2]);
              T.Cell(i+2, 2).Range.ParagraphFormat.alignment:=1;
            end
          else
            T.Cell(i+2, 2).Range.Text:='';
          T.Cell(i+2, 2).Borders.Enable:=1;
          T.Cell(i+2, 3).Range.Text := inttostr(Effects[1]);
          T.Cell(i+2, 3).Range.ParagraphFormat.alignment:=1;
          T.Cell(i+2, 3).Borders.Enable:=1;
          if begin_date<>end_date then
            begin
              T.Cell(i+2, 4).Range.Text:=inttostr(Effects[2]);
              T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=1;
                if effects[1]=0 then
                  T.Cell(i+2, 5).Range.Text:=''
                else
                  begin
                    T.Cell(i+2, 5).Range.Text:=roundto(Effects[2]/Effects[1],-2);
                    T.Cell(i+2, 5).Range.ParagraphFormat.alignment:=1;
                  end;
              T.Cell(i+2, 5).Borders.Enable:=1;
            end
          else
            T.Cell(i+2, 4).Range.Text:='';
          T.Cell(i+2, 4).Borders.Enable:=1;
        end;

  T.AutoFitBehavior(2);
  Word.Visible:=True;
  Word.Activate;
  Word.WindowState:=1;

end;

procedure TfResultToChild.N2Click(Sender: TObject);
begin
  ClassReport3;
end;

procedure TfResultToChild.N4Click(Sender: TObject);
begin
  ClassReport2;
end;      

procedure TfResultToChild.N5Click(Sender: TObject);
begin
  ClassReport5;
end;

procedure TfResultToChild.N6Click(Sender: TObject);
begin
  ClassReport6;
end;


procedure TfResultToChild.N7Click(Sender: TObject);
begin
  ClassReport7;
end;

procedure TfResultToChild.ou4rh1Click(Sender: TObject);
begin
  ClassReport8;
end;

procedure TfResultToChild.N8Click(Sender: TObject);
begin
  ClassReport9;
end;

procedure TfResultToChild.N9Click(Sender: TObject);
var
 Word:variant;
 Doc:variant;
 S,T:variant;
 begin_date,end_date:TDateTime;
 Marks:array [1..2] of integer;
 Effects:array [1..2] of integer;
 i:integer;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Ќе могу запустить Microsoft Word');
    exit;
  end;
  S:=Word.Selection;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MIN(Start_Data) AS StartDate FROM Results_Diag WHERE User_ID=:1');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('¬нутренн€€ ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  begin_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MAX(Start_Data) AS StartDate FROM Results_Diag WHERE User_ID=:1');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('¬нутренн€€ ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  end_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;

  S.TypeText('ƒата итоговой диагностики: '+DateToStr(end_date));
  S.ParagraphFormat.Alignment:=0;
  S.TypeParagraph;
  S.Font.UnderLine:=0;
  S.Font.Size:=12;
  S.ParagraphFormat.Alignment:=2;
  S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
  S.TypeParagraph;
  S.Font.Bold:=1;
  S.Font.Size:=16;
  S.ParagraphFormat.Alignment:=1;
  S.TypeText('¬едомость результатов по развитию логического мышлени€' +#13#10+'ƒиагностика');
  S.Font.Bold:=1;
  S.Font.Size:=14;
  S.ParagraphFormat.Alignment:=1;

  if fDB.ADOQueryResultsDate.Active then
     fDB.ADOQueryResultsDate.Close;
  if not ADOQuery2.Active then
      ADOQuery2.close;
  adoquery2.sql.clear;
  adoquery2.sql.add('SELECT Users.User_Family AS Family, Users.User_Login AS Login, Groups.Nazvanie AS Groups, Results_Diag.Start_Data AS Start_Data, Results_Diag.Finish_Time AS Finish_Time,');
  adoquery2.sql.add('Results_Diag.Mark AS Mark, Results_Diag.Effect AS Effect, CompleXity.Nazvanie AS CompleXity_Nazvanie, QuestionTypes.Nazvanie AS QT_Nazvanie');
  adoquery2.sql.add('FROM Groups, Results_Diag, Users, CompleXity, Questions, QuestionTypes');
  adoquery2.sql.add('WHERE Users.Group_id=Groups.ID and Results_Diag.User_ID=Users.ID and Results_Diag.User_ID=:1 and Results_Diag.CompleXity_Id=CompleXity.ID');
  adoquery2.sql.add('and Results_Diag.Question_ID=Questions.ID and Questions.QuestionType_ID=QuestionTypes.ID and QuestionTypes.ID=:2 and ((Results_Diag.Start_Data=:3) or (Results_Diag.Start_Data=:4))');
  adoquery2.sql.add('ORDER BY CompleXity.ID, Results_DIag.Start_Data;');
  ADOQuery2.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  ADOQuery2.Parameters.ParamByName('2').Value:=fdb.QuestionTypes_ID;
  ADOQuery2.Parameters.ParamByName('3').Value:=begin_date;
  ADOQuery2.Parameters.ParamByName('4').Value:=end_date;
  ADOQuery2.Open;  

  if ADOQuery2.RecordCount=0 then
    begin
      ShowMessage('–езуьтаты не найдены!');
      exit;
    end;
  S.TypeParagraph;
  S.ParagraphFormat.Alignment:=1;
  S.Font.Size:=14;
  S.TypeText(ADOQuery2.FieldByName('QT_Nazvanie').AsString);
  ADOQuery2.First;

  T:= Doc.Tables.Add(Word.Selection.Range, 3, 4);
  T.Rows.Alignment := 1;
  T.Cell(1, 1).Range.Text := '—–≈ƒЌяя ќ÷≈Ќ ј';
  T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
  T.Cell(1, 1).Borders.Enable:=1;
  T.Cell(1, 2).Range.Text := '';
  T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
  T.Cell(1, 2).Borders.Enable:=1;
  T.Cell(1, 3).Range.Text := 'Ё‘‘≈ “»¬Ќќ—“№';
  T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
  T.Cell(1, 3).Borders.Enable:=1;
  T.Cell(1, 4).Range.Text := '';
  T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
  T.Cell(1, 4).Borders.Enable:=1;
  T.Cell(1, 3).Merge(T.Cell(1, 4));
  T.Cell(1, 1).Merge(T.Cell(1, 2));
  T.Cell(2, 1).Range.Text := 'Ќј„јЋ№Ќјя';
  T.Cell(2, 1).Range.ParagraphFormat.alignment:=1;
  T.Cell(2, 1).Borders.Enable:=1;
  T.Cell(2, 2).Range.Text := '»“ќ√ќ¬јя';
  T.Cell(2, 2).Range.ParagraphFormat.alignment:=1;
  T.Cell(2, 2).Borders.Enable:=1;
  T.Cell(2, 3).Range.Text := 'Ќј„јЋ№Ќјя';
  T.Cell(2, 3).Range.ParagraphFormat.alignment:=1;
  T.Cell(2, 3).Borders.Enable:=1;
  T.Cell(2, 4).Range.Text := '»“ќ√ќ¬јя';
  T.Cell(2, 4).Range.ParagraphFormat.alignment:=1;
  T.Cell(2, 4).Borders.Enable:=1;


  i:=1;
  While not ADOQuery2.Eof do
    begin
      if begin_date<>end_date then
        begin
          Marks[i]:=ADOQuery2.FieldByName('Mark').AsInteger;
          S.ParagraphFormat.Alignment:=1;
          Effects[i]:=ADOQuery2.FieldByName('Effect').AsInteger;
          if (Marks[1]<>0) and (Marks[2]<>0) then
            break;
        end
        else
        begin
          Marks[1]:=ADOQuery2.FieldByName('Mark').AsInteger;
          S.ParagraphFormat.Alignment:=1;
          Effects[1]:=ADOQuery2.FieldByName('Effect').AsInteger;
          break;
        end;
        ADOQuery2.Next;
        i:=i+1;
    end;
    if ADOQuery2.Active then
      ADOQuery2.close;
    for i:=1 to 4 do
      begin
        if Marks[1]=2 then
          T.Cell(i+2, 1).Range.Font.Color := clRed;
        T.Cell(i+2, 1).Range.Text := inttostr(Marks[1]);
        T.Cell(i+2, 1).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 1).Borders.Enable:=1;
        if begin_date<>end_date then
          begin
            if Marks[2]=2 then
              T.Cell(i+2, 2).Range.Font.Color := clRed;
            T.Cell(i+2, 2).Range.Text:=inttostr(Marks[2]);
            T.Cell(i+2, 2).Range.ParagraphFormat.alignment:=1;
          end
        else
          T.Cell(i+2, 2).Range.Text:='';
        T.Cell(i+2, 2).Borders.Enable:=1;
        T.Cell(i+2, 3).Range.Text := inttostr(Effects[1]);
        T.Cell(i+2, 3).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 3).Borders.Enable:=1;
        if begin_date<>end_date then
          begin
            T.Cell(i+2, 4).Range.Text:=inttostr(Effects[2]);
            T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=1;
          end
        else
          T.Cell(i+2, 4).Range.Text:='';
        T.Cell(i+2, 4).Borders.Enable:=1;
      end;

  T.AutoFitBehavior(2);
  Word.Visible:=True;
  Word.Activate;
  Word.WindowState:=1;
end;

procedure TfResultToChild.sBitBtn4Click(Sender: TObject);
begin
  fIndependentWork.normal_exit:=true;
end;

procedure TfResultToChild.N11Click(Sender: TObject);
begin
  ClassReport11;
end;

procedure TfResultToChild.FormCreate(Sender: TObject);
begin
  Caption:=GetBaseCaption + '(–езультаты)';  
end;

end.

