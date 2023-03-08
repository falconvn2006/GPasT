unit Utils;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, sBitBtn, sMemo, sLabel, Math,
  sButton, ComCtrls, ComObj, MPlayer, DateUtils, DB, ADODB, Menus,IniFiles;

  procedure ClassReport1;
  procedure ClassReport2;
  procedure ClassReport3;
  procedure ClassReport4;
  procedure ClassReport5;
  procedure ClassReport6;
  procedure ClassReport7;
  procedure ClassReport8;
  procedure ClassReport9;
  procedure ClassReport11;
  procedure DevelopmentReport;
  procedure DevelopmentInterReport;
  procedure DevelopmentShortReport;
  procedure TrajectProcess_L(ID_Traject:integer; Traject_Nazvanie:string;  Word:variant; Doc: variant; S:variant);
  procedure TrajectProcess(ID_Traject:integer; Traject_Nazvanie:string; Word:variant; Doc: variant; S:variant);
  procedure LessonProcess(ID_Lesson:integer;ID_Traject:integer;Traject_Nazvanie:string;Lesson_Nazvanie:string; Word:variant; Doc: variant; S:variant; T:variant; var i:integer);
  function GetTextControl(ID_Traject:integer):string;
  
implementation

uses MainMenu, MyDB, OptionUser, Entry, ClassReports, SelectLesson, Admin;



function GetTextControl(ID_Traject:integer):string;
begin
  Result:='';
  fDB.ADOQuery444.Close;
  fDB.ADOQuery444.SQL.Clear;
  fDB.ADOQuery444.SQL.Add('SELECT COUNT(*) AS CountControl FROM TrajectLessons T, Lessons L');
  fDB.ADOQuery444.SQL.Add('WHERE T.Lessons_ID=L.ID AND T.Traject_id=:1 and L.Control ');
  fDB.ADOQuery444.parameters.ParamByName('1').value:=ID_Traject;
  fDB.ADOQuery444.Open;
  fDB.ADOQuery444.First;
  Result:=IntToStr(fdb.ADOQuery444.FieldByName('CountControl').AsInteger);
  fDB.ADOQuery444.Close;
end;

procedure ClassReport11;
var
 Word: variant;
 Doc: variant;
 S,T: variant;
 i:integer;
 Traject_ID,Lessons_ID:Integer;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
  S:=Word.Selection;
  if fDB.ADOQueryLessonsProcess.Active then
    fDB.ADOQueryLessonsProcess.close;
  fDB.ADOQueryLessonsProcess.SQL.Clear;
  fDB.ADOQueryLessonsProcess.SQL.Add('SELECT RS.Traject_ID AS RS_Traject_ID, RS.Lessons_Id AS RS_Lessons_ID, T.Nazvanie AS T_Nazvanie,L.Nazvanie AS L_Nazvanie');
  fDB.ADOQueryLessonsProcess.SQL.Add('FROM Results_Class AS RS, Users AS U, Lessons AS L, Traject AS T, TrajectLessons AS TL, ');
  fDB.ADOQueryLessonsProcess.SQL.Add('(SELECT DISTINCT RS1.Traject_ID, RS1.Lessons_Id FROM Results_Class AS RS1, Users AS U1 WHERE RS1.User_ID=U1.ID AND RS1.User_ID=:1) AS TL1');
  fDB.ADOQueryLessonsProcess.SQL.Add('WHERE RS.Traject_ID=T.ID AND RS.Lessons_ID=L.ID AND RS.User_ID=U.ID AND RS.User_ID=:2 AND T.ID=TL.Traject_ID AND TL.Lessons_ID=L.ID');
  fDB.ADOQueryLessonsProcess.SQL.Add('AND RS.Traject_ID=RS1.Traject_ID AND RS.Lessons_ID=RS1.Lessons_ID');
  fDB.ADOQueryLessonsProcess.SQL.Add('ORDER BY T.Nazvanie, L.Nazvanie, RS.Traject_ID, RS.Lessons_ID;');
  fDB.ADOQueryLessonsProcess.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryLessonsProcess.Parameters.ParamByName('2').Value:=fMainMenu.userId;
  fDB.ADOQueryLessonsProcess.Open;
  fDB.ADOQueryLessonsProcess.First;
  S.Font.Size:=12;
  S.ParagraphFormat.Alignment:=0;
  S.TypeText('Дата печати: '+DateToStr(Date));
  S.TypeParagraph;
  S.ParagraphFormat.Alignment:=2;
  if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
  S.TypeParagraph;
  S.Font.Bold:=1;
  S.Font.Size:=16;
  S.ParagraphFormat.Alignment:=1;
  S.TypeText('Ведомость результатов по математике' +#13#10+'Классная работа');
  S.Font.Bold:=1;
  S.Font.Size:=14;
  S.ParagraphFormat.Alignment:=1;
  S.Font.Bold:=1;    
  S.Font.Size:=16;
  S.ParagraphFormat.Alignment:=1;
  S.Font.italic:=True;
  S.Font.italic:=false;
  S.Font.Size:=12;
  i:=3;
  Traject_ID:=-1;
  Lessons_ID:=-1;
  While not fdb.ADOQueryLessonsProcess.Eof do
    begin
      if Traject_ID<>fDB.ADOQueryLessonsProcess.FieldByName('RS_Traject_ID').AsInteger then
        begin
          S.Font.Size:=16;
          S.ParagraphFormat.Alignment:=1;
          S.TypeParagraph;
          S.TypeText(fDB.ADOQueryLessonsProcess.FieldByName('T_Nazvanie').AsString);
          S.Font.Size:=12;
          S.ParagraphFormat.Alignment:=1;
          T:=Doc.Tables.Add(Word.Selection.Range, 2, 6);   
          T.Cell(1, 1).Range.Text := 'Название урока';
          T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
          T.Cell(1, 1).Borders.Enable:=1;
          T.Cell(1, 2).Range.Text := 'ОЦЕНКА';
          T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
          T.Cell(1, 2).Borders.Enable:=1;
          T.Cell(1, 3).Range.Text := '';
          T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
          T.Cell(1, 3).Borders.Enable:=1;
          T.Cell(1, 4).Range.Text := 'ЭФФЕКТИВНОСТЬ';
          T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
          T.Cell(1, 4).Borders.Enable:=1;
          T.Cell(1, 5).Range.Text := '';
          T.Cell(1, 5).Range.ParagraphFormat.alignment:=1;
          T.Cell(1, 5).Borders.Enable:=1;
          T.Cell(1, 6).Range.Text := 'ОТНОШЕНИЕ';
          T.Cell(1, 6).Range.ParagraphFormat.alignment:=1;
          T.Cell(1, 6).Borders.Enable:=1;
          T.Cell(1, 4).Merge(T.Cell(1, 5));
          T.Cell(1, 2).Merge(T.Cell(1, 3));
          T.Cell(2, 1).Borders.Enable:=1;
          T.Cell(1, 1).Merge(T.Cell(2, 1));
          T.Cell(2, 2).Range.Text := 'НАЧАЛЬНАЯ';
          T.Cell(2, 2).Range.ParagraphFormat.alignment:=1;
          T.Cell(2, 2).Borders.Enable:=1;
          T.Cell(2, 3).Range.Text := 'КОНЕЧНАЯ';
          T.Cell(2, 3).Range.ParagraphFormat.alignment:=1;
          T.Cell(2, 3).Borders.Enable:=1;
          T.Cell(2, 4).Range.Text := 'НАЧАЛЬНАЯ';
          T.Cell(2, 4).Range.ParagraphFormat.alignment:=1;
          T.Cell(2, 4).Borders.Enable:=1;
          T.Cell(2, 5).Range.Text := 'КОНЕЧНАЯ';
          T.Cell(2, 5).Range.ParagraphFormat.alignment:=1;
          T.Cell(2, 5).Borders.Enable:=1;
          T.Cell(2, 6).Range.Text := 'КОН/НАЧ';
          T.Cell(2, 6).Range.ParagraphFormat.alignment:=1;
          T.Cell(2, 6).Borders.Enable:=1;
          i:=3;
          T.AutoFitBehavior(2);
          Word.Selection.EndKey(6, 0);
          Traject_ID:=fDB.ADOQueryLessonsProcess.FieldByName('RS_Traject_ID').AsInteger;
        end;
      if Lessons_ID<>fDB.ADOQueryLessonsProcess.FieldByName('RS_Lessons_ID').AsInteger then
        begin
          T.Rows.Add;
          LessonProcess(fDB.ADOQueryLessonsProcess.FieldByName('RS_Lessons_ID').AsInteger,fDB.ADOQueryLessonsProcess.FieldByName('RS_Traject_ID').AsInteger,fdb.ADOQueryLessonsProcess.FieldByName('T_Nazvanie').AsString, fdb.ADOQueryLessonsProcess.FieldByName('L_Nazvanie').AsString,Word,Doc,S,T,i);
          Lessons_ID:=fDB.ADOQueryLessonsProcess.FieldByName('RS_Lessons_ID').AsInteger;
          i:=i+1;
        end;
      fdb.ADOQueryLessonsProcess.Next;
    end;
  if fdb.ADOQueryLessonsProcess.Active then
    fdb.ADOQueryLessonsProcess.Close;
  Word.Visible:=True;
  Word.Activate;
  Word.WindowState:=1;
end;

procedure LessonProcess(ID_Lesson:integer;ID_Traject:integer;Traject_Nazvanie:string;Lesson_Nazvanie:string; Word:variant; Doc: variant; S:variant; T:variant;var i:integer);
var
 begin_date,end_date:TDateTime;
 Marks: array [1..2] of integer;
 Times: array [1..2] of integer;
 effect: array[1..2] of Double;
begin
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MIN(Start_Data) AS StartDate FROM Results_Class WHERE User_ID=:1 and Lessons_ID=:2 and Traject_ID=:3');
  if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('2').Value:=ID_Lesson;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('3').Value:=ID_Traject;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  begin_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MAX(Start_Data) AS StartDate FROM Results_Class WHERE User_ID=:1 and Lessons_ID=:2 and Traject_ID=:3');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('2').Value:=ID_Lesson;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('3').Value:=ID_Traject;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  end_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.Close;
  Marks[1]:=0;
  Marks[2]:=0;
  Times[1]:=0;
  Times[2]:=0;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT SUM(RS.Finish_Time) AS Finish_Time, SUM(RS.Mark) AS Mark FROM Results_Class AS RS WHERE RS.User_ID=:1 AND RS.Start_Data=:2 AND RS.Lessons_ID=:3 AND RS.Traject_ID=:4  GROUP BY RS.Lessons_Id, RS.Finish_Time');
  if fMainMenu.userId=0 then
    fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('2').Value:=begin_date;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('3').Value:=ID_Lesson;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('4').Value:=ID_Traject;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  if fDB.ADOQueryResultsDate.RecordCount>0 then
    begin
      fDB.ADOQueryResultsDate.First;
      Marks[1]:=fDB.ADOQueryResultsDate.FieldByName('Mark').AsInteger;
      Times[1]:=fDB.ADOQueryResultsDate.FieldByName('Finish_Time').AsInteger;
      if fDB.ADOQueryResultsDate.Active then
        fDB.ADOQueryResultsDate.close;
      fDB.ADOQueryResultsDate.SQL.Clear;
    end;                  

  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.Close;    
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT SUM(RS.Finish_Time) AS Finish_Time, SUM(RS.Mark) AS Mark FROM Results_Class AS RS WHERE RS.User_ID=:1 AND RS.Start_Data=:2 AND RS.Lessons_ID=:3 AND RS.Traject_ID=:4 GROUP BY RS.Lessons_Id, RS.Finish_Time');
  if fMainMenu.userId=0 then
    fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('2').Value:=end_date;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('3').Value:=ID_Lesson;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('4').Value:=ID_Traject;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  if fDB.ADOQueryResultsDate.RecordCount>0 then
    begin
      fDB.ADOQueryResultsDate.First;
      Marks[2]:=fDB.ADOQueryResultsDate.FieldByName('Mark').AsInteger;
      Times[2]:=fDB.ADOQueryResultsDate.FieldByName('Finish_Time').AsInteger;
      if fDB.ADOQueryResultsDate.Active then
        fDB.ADOQueryResultsDate.close;
      fDB.ADOQueryResultsDate.SQL.Clear;
    end;
    if (Marks[1]=0) and (Times[1]=0) and (Marks[2]=0) and (Times[2]=0) then
      exit;
    T.Cell(i, 1).Range.Text:=Lesson_Nazvanie;
    T.Cell(i, 1).Borders.Enable:=1;
    if Marks[1]<>0 then
      begin
        T.Cell(i, 2).Range.Text:=IntToStr(Marks[1]);
        T.Cell(i, 2).Borders.Enable:=1;
      end;
    if Marks[2]<>0 then
      begin
        if begin_date=end_date then
          T.Cell(i, 3).Range.Text:='-'
        else
          T.Cell(i, 3).Range.Text:=IntToStr(Marks[2]);
        T.Cell(i, 3).Borders.Enable:=1;
      end;
    effect[1]:=0;
    effect[2]:=0;
    if Times[1]<>0 then
      begin
        effect[1]:=(Marks[1]/Times[1])*1000/60;
        if RoundTo(effect[1],-2)<0.01 then
          T.Cell(i, 4).Range.Text:=''
        else
          T.Cell(i, 4).Range.Text:=FloatToStr(RoundTo(effect[1],-2));
        T.Cell(i, 4).Borders.Enable:=1;
      end;
    if Times[2]<>0 then
      begin
        effect[2]:=(Marks[2]/Times[2])*1000/60;
        if (RoundTo(effect[2],-2)<0.01) or (begin_date=end_date) then
          T.Cell(i, 5).Range.Text:='-'
         else
          T.Cell(i, 5).Range.Text:=FloatToStr(RoundTo(effect[2],-2));
        T.Cell(i, 5).Borders.Enable:=1;
      end;
    if effect[1]<>0.0 then
      T.Cell(i, 6).Range.Text:=FloatToStr(RoundTo(effect[2]/effect[1],-2))
     else
      T.Cell(i, 6).Range.Text:='';
     T.Cell(i, 6).Borders.Enable:=1;
      Word.Selection.EndKey(6, 0);
end;

procedure DevelopmentReport;
var
 Word:variant;
 Doc:variant;
 S:variant;
 T:variant;
 i:integer;
 Date:TDateTime;
 temp:string;
begin
  try
    Date:=Now;
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
    S:=Word.Selection;
    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if fEntry.Visible then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Устный счёт');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;

        if not fdb.ADOQuery111.Active then
          fdb.ADOQuery111.close;
        fdb.ADOQuery111.sql.clear;
        fdb.ADOQuery111.Fields.clear;
        fdb.ADOQuery111.sql.add('SELECT U.User_Family AS Family, U.User_Login AS Login, Gr.Nazvanie AS Groups, RC.Start_Data AS Start_Data,');
        fdb.ADOQuery111.sql.add('RC.Task_Type AS Task, RC.Radio_Set AS Radio, RC.Combo_Set AS Combo, RC.Slider_Set AS Slider, RC.Effect AS Effect');
        fdb.ADOQuery111.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
        fdb.ADOQuery111.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1');
        fdb.ADOQuery111.sql.add('ORDER BY RC.Start_Data');
        if fMainMenu.userId=0 then
          fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
        fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
        fdb.ADOQuery111.Open;
        fdb.ADOQuery111.First;
        if fdb.ADOQuery111.RecordCount>0 then
          begin
            S.TypeParagraph;
            S.Font.Bold:=1;
            S.ParagraphFormat.Alignment:=1;
            S.Font.Size:=12;
            T := Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery111.RecordCount+1, 4);
            T.AutoFitBehavior(2);
            T.Cell(1, 1).Range.Text:='ДАТА';
            T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 1).Borders.Enable:=1;
            T.Cell(1, 2).Range.Text:='РЕЖИМ';
            T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 2).Borders.Enable:=1;
            T.Cell(1, 3).Range.Text:='НАСТРОЙКИ';
            T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 3).Borders.Enable:=1;
            T.Cell(1, 4).Range.Text:='ЭФФЕКТИВНОСТЬ';
            T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 4).Borders.Enable:=1;
            T.Columns.Width:=118;
            T.Rows.Alignment:=0;
            i:=0;
            While not fdb.ADOQuery111.Eof do
              begin
                T.Cell(i+2, 1).Range.Text := fdb.ADOQuery111.FieldByName('Start_Data').AsString;
                T.Cell(i+2, 1).Borders.Enable:=1;
                Case fdb.ADOQuery111.FieldByName('Task').AsInteger of
                  0 : temp := 'Операции с числами';
                  1 : temp := 'Строка';
                  2 : temp := 'Таблица умножения';
                  3 : temp := 'Матрицы';
                  4 : temp := 'Быстрый тренинг';
                end;
                T.Cell(i+2, 2).Range.Text := temp;
                T.Cell(i+2, 2).Borders.Enable:=1;
                if (fdb.ADOQuery111.FieldByName('Task').AsInteger = 0) then
                begin
                  Case fdb.ADOQuery111.FieldByName('Radio').AsInteger of
                    0 : temp := 'От 0 до 9';
                    1 : temp := 'Переход через 10';
                    2 : temp := 'От 10 до 99';
                    3 : temp := 'Переход через 100';
                    4 : temp := 'От 100 до 999';
                  end;
                  Case fdb.ADOQuery111.FieldByName('Combo').AsInteger of
                    1   :  temp := temp + ', умножение';
                    10  :  temp := temp + ', вычитание';
                    11  :  temp := temp + ', вычитание, умножение';
                    100 :  temp := temp + ', сложение';
                    101 :  temp := temp + ', сложение, умножение';
                    110 :  temp := temp + ', сложение, вычитание';
                    111 :  temp := temp + ', сложение, вычитание, умножение';
                    1000:  temp := temp + ', деление';
                    1001:  temp := temp + ', деление, умножение';
                    1010:  temp := temp + ', деление, вычитание';
                    1011:  temp := temp + ', деление, вычитание, умножение';
                    1100:  temp := temp + ', деление, сложение';
                    1101:  temp := temp + ', деление, сложение, умножение';
                    1110:  temp := temp + ', деление, сложение, вычитание';
                    1111:  temp := temp + ', деление, сложение, вычитание, умножение';
                  end;
                end;
                if (fdb.ADOQuery111.FieldByName('Task').AsInteger = 2) then
                  Case fdb.ADOQuery111.FieldByName('Radio').AsInteger of
                    0 : temp := 'Вся таблица';
                    1 : temp := 'Умножение на 2';
                    2 : temp := 'Умножение на 3';
                    3 : temp := 'Умножение на 4';
                    4 : temp := 'Умножение на 5';
                    5 : temp := 'Умножение на 6';
                    6 : temp := 'Умножение на 7';
                    7 : temp := 'Умножение на 8';
                    8 : temp := 'Умножение на 9';
                  end;
                if (fdb.ADOQuery111.FieldByName('Task').AsInteger = 3) then
                begin
                  Case fdb.ADOQuery111.FieldByName('Radio').AsInteger of
                    0 : temp := 'От 0 до 9';
                    1 : temp := 'От 10 до 99';
                    2 : temp := 'От 100 до 999';
                  end;
                  Case fdb.ADOQuery111.FieldByName('Combo').AsInteger of
                    1   :  temp := temp + ', умножение';
                    10  :  temp := temp + ', вычитание';
                    11  :  temp := temp + ', вычитание, умножение';
                    100 :  temp := temp + ', сложение';
                    101 :  temp := temp + ', сложение, умножение';
                    110 :  temp := temp + ', сложение, вычитание';
                    111 :  temp := temp + ', сложение, вычитание, умножение';
                  end;
                  Case fdb.ADOQuery111.FieldByName('Slider').AsInteger of
                    3 : temp := temp + ', 3x3';
                    4 : temp := temp + ', 4x4';
                    5 : temp := temp + ', 5x5';
                  end;
                end;
                if (fdb.ADOQuery111.FieldByName('Task').AsInteger = 4) then
                begin
                   temp := fdb.ADOQuery111.FieldByName('Slider').AsString + ' мин';
                end;
                T.Cell(i+2, 3).Range.Text := temp;
                T.Cell(i+2, 3).Borders.Enable:=1;
                T.Cell(i+2, 4).Range.Text:=RoundTo(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
                T.Cell(i+2, 4).Borders.Enable:=1;
                T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=2;
                fdb.ADOQuery111.Next;
                i:=i+1;
              end;
            Word.Selection.EndKey(6, 0);
          end;

    Word.Visible := True;
    Word.Activate;
    Word.WindowState:= 1;
end;

procedure DevelopmentInterReport;
var
 Word:variant;
 Doc:variant;
 S:variant;
 T:variant;
 i:integer;
 Date:TDateTime;
 temp:string;
begin
  try
    Date:=Now;
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
    S:=Word.Selection;
    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if fEntry.Visible then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Устный счёт');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;
    if not fdb.ADOQueryDevMode.Active then
          fdb.ADOQueryDevMode.close;
    fdb.ADOQueryDevMode.sql.Clear;
    fdb.ADOQueryDevMode.Fields.Clear;
    fdb.ADOQueryDevMode.sql.add('SELECT DISTINCT RC.Task_Type AS Task');
    fdb.ADOQueryDevMode.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
    fdb.ADOQueryDevMode.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1');
    //fdb.ADOQueryDevMode.sql.add('ORDER BY Task');
    if fMainMenu.userId=0 then
          fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
    fdb.ADOQueryDevMode.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQueryDevMode.Open;
    fdb.ADOQueryDevMode.First;
    while not fdb.ADOQueryDevMode.eof do
      begin
        Case fdb.ADOQueryDevMode.FieldByName('Task').AsInteger of
          0 : temp := 'Операции с числами';
          1 : temp := 'Строка';
          2 : temp := 'Таблица умножения';
          3 : temp := 'Матрицы';
          4 : temp := 'Быстрый тренинг';
        end;
        S.TypeParagraph;
        S.Font.Bold:=1;
        S.Font.Size:=14;
        S.ParagraphFormat.Alignment:=1;
        S.TypeText(temp);
        if not fdb.ADOQuery111.Active then
          fdb.ADOQuery111.close;
        fdb.ADOQuery111.sql.clear;
        //fdb.ADOQuery111.Fields.clear;
        fdb.ADOQuery111.sql.add('SELECT U.User_Family AS Family, U.User_Login AS Login, Gr.Nazvanie AS Groups, RC.Start_Data AS Start_Data,');
        fdb.ADOQuery111.sql.add('RC.Task_Type AS Task, RC.Radio_Set AS Radio, RC.Combo_Set AS Combo, RC.Slider_Set AS Slider, RC.Correct AS Correct, RC.Effect AS Effect');
        fdb.ADOQuery111.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
        fdb.ADOQuery111.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Task_Type=:2');
        fdb.ADOQuery111.sql.add('ORDER BY RC.Start_Data');
        fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
        fdb.ADOQuery111.Parameters.ParamByName('2').Value:=fdb.ADOQueryDevMode.FieldByName('Task').AsInteger;
        fdb.ADOQuery111.Open;
        fdb.ADOQuery111.First;
        if fdb.ADOQuery111.RecordCount>0 then
          begin
            S.TypeParagraph;
            S.Font.Bold:=1;
            S.ParagraphFormat.Alignment:=1;
            S.Font.Size:=12;
            T := Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery111.RecordCount+1, 4);
            T.AutoFitBehavior(2);
            T.Cell(1, 1).Range.Text:='ДАТА';
            T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 1).Borders.Enable:=1;
            T.Cell(1, 2).Range.Text:='НАСТРОЙКИ';
            T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 2).Borders.Enable:=1;
            T.Cell(1, 3).Range.Text:='ПРАВИЛЬНЫЕ ОТВЕТЫ';
            T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 3).Borders.Enable:=1;
            T.Cell(1, 4).Range.Text:='ЭФФЕКТИВНОСТЬ';
            T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 4).Borders.Enable:=1;
            T.Columns.Width:=118;
            T.Rows.Alignment:=0;
            i:=0;
            While not fdb.ADOQuery111.Eof do
              begin
                T.Cell(i+2, 1).Range.Text := fdb.ADOQuery111.FieldByName('Start_Data').AsString;
                T.Cell(i+2, 1).Borders.Enable:=1;
                if (fdb.ADOQuery111.FieldByName('Task').AsInteger = 0) then
                begin
                  Case fdb.ADOQuery111.FieldByName('Radio').AsInteger of
                    0 : temp := 'От 0 до 9';
                    1 : temp := 'Переход через 10';
                    2 : temp := 'От 10 до 99';
                    3 : temp := 'Переход через 100';
                    4 : temp := 'От 100 до 999';
                  end;
                  Case fdb.ADOQuery111.FieldByName('Combo').AsInteger of
                    1   :  temp := temp + ', умножение';
                    10  :  temp := temp + ', вычитание';
                    11  :  temp := temp + ', вычитание, умножение';
                    100 :  temp := temp + ', сложение';
                    101 :  temp := temp + ', сложение, умножение';
                    110 :  temp := temp + ', сложение, вычитание';
                    111 :  temp := temp + ', сложение, вычитание, умножение';
                    1000:  temp := temp + ', деление';
                    1001:  temp := temp + ', деление, умножение';
                    1010:  temp := temp + ', деление, вычитание';
                    1011:  temp := temp + ', деление, вычитание, умножение';
                    1100:  temp := temp + ', деление, сложение';
                    1101:  temp := temp + ', деление, сложение, умножение';
                    1110:  temp := temp + ', деление, сложение, вычитание';
                    1111:  temp := temp + ', деление, сложение, вычитание, умножение';
                  end;
                end;
                if (fdb.ADOQuery111.FieldByName('Task').AsInteger = 2) then
                  Case fdb.ADOQuery111.FieldByName('Radio').AsInteger of
                    0 : temp := 'Вся таблица';
                    1 : temp := 'Умножение на 2';
                    2 : temp := 'Умножение на 3';
                    3 : temp := 'Умножение на 4';
                    4 : temp := 'Умножение на 5';
                    5 : temp := 'Умножение на 6';
                    6 : temp := 'Умножение на 7';
                    7 : temp := 'Умножение на 8';
                    8 : temp := 'Умножение на 9';
                  end;
                if (fdb.ADOQuery111.FieldByName('Task').AsInteger = 3) then
                begin
                  Case fdb.ADOQuery111.FieldByName('Radio').AsInteger of
                    0 : temp := 'От 0 до 9';
                    1 : temp := 'От 10 до 99';
                    2 : temp := 'От 100 до 999';
                  end;
                  Case fdb.ADOQuery111.FieldByName('Combo').AsInteger of
                    1   :  temp := temp + ', умножение';
                    10  :  temp := temp + ', вычитание';
                    11  :  temp := temp + ', вычитание, умножение';
                    100 :  temp := temp + ', сложение';
                    101 :  temp := temp + ', сложение, умножение';
                    110 :  temp := temp + ', сложение, вычитание';
                    111 :  temp := temp + ', сложение, вычитание, умножение';
                  end;
                  Case fdb.ADOQuery111.FieldByName('Slider').AsInteger of
                    3 : temp := temp + ', 3x3';
                    4 : temp := temp + ', 4x4';
                    5 : temp := temp + ', 5x5';
                  end;
                end;
                if (fdb.ADOQuery111.FieldByName('Task').AsInteger = 4) then
                begin
                   temp := fdb.ADOQuery111.FieldByName('Slider').AsString + ' мин';
                end;
                T.Cell(i+2, 2).Range.Text := temp;
                T.Cell(i+2, 2).Borders.Enable:=1;
                T.Cell(i+2, 3).Range.Text := fdb.ADOQuery111.FieldByName('Correct').AsInteger;
                T.Cell(i+2, 3).Borders.Enable:=1;
                T.Cell(i+2, 4).Range.Text:=RoundTo(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
                T.Cell(i+2, 4).Borders.Enable:=1;
                T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=2;
                fdb.ADOQuery111.Next;
                i:=i+1;
              end;
            Word.Selection.EndKey(6, 0);
          end;
          fdb.ADOQueryDevMode.Next;
      end;
    Word.Visible := True;
    Word.Activate;
    Word.WindowState:= 1;
end;

procedure DevelopmentShortReport;
var
 Word:variant;
 Doc:variant;
 S:variant;
 T:variant;
 i:integer;
 Date:TDateTime;
 temp:string;
begin
  try
    Date:=Now;
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
    S:=Word.Selection;
    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if fEntry.Visible then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Устный счёт');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;
    if not fdb.ADOQueryDevMode.Active then
          fdb.ADOQueryDevMode.close;
    fdb.ADOQueryDevMode.sql.Clear;
    fdb.ADOQueryDevMode.Fields.Clear;
    fdb.ADOQueryDevMode.sql.add('SELECT DISTINCT RC.Task_Type AS Task, RC.Radio_Set AS Radio, RC.Combo_Set AS Combo, RC.Slider_Set AS Slider');
    fdb.ADOQueryDevMode.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
    fdb.ADOQueryDevMode.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1');
    //fdb.ADOQueryDevMode.sql.add('ORDER BY Task');
    if fMainMenu.userId=0 then
          fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
    fdb.ADOQueryDevMode.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQueryDevMode.Open;
    fdb.ADOQueryDevMode.First;
    while not fdb.ADOQueryDevMode.eof do
      begin
        Case fdb.ADOQueryDevMode.FieldByName('Task').AsInteger of
          0 : temp := 'Операции с числами. ';
          1 : temp := 'Строка. ';
          2 : temp := 'Таблица умножения. ';
          3 : temp := 'Матрицы. ';
          4 : temp := 'Быстрый тренинг. ';
        end;
        if (fdb.ADOQueryDevMode.FieldByName('Task').AsInteger = 0) then
        begin
          Case fdb.ADOQueryDevMode.FieldByName('Radio').AsInteger of
            0 : temp := temp + 'От 0 до 9';
            1 : temp := temp + 'Переход через 10';
            2 : temp := temp + 'От 10 до 99';
            3 : temp := temp + 'Переход через 100';
            4 : temp := temp + 'От 100 до 999';
          end;
          Case fdb.ADOQueryDevMode.FieldByName('Combo').AsInteger of
            1   :  temp := temp + ', умножение';
            10  :  temp := temp + ', вычитание';
            11  :  temp := temp + ', вычитание, умножение';
            100 :  temp := temp + ', сложение';
            101 :  temp := temp + ', сложение, умножение';
            110 :  temp := temp + ', сложение, вычитание';
            111 :  temp := temp + ', сложение, вычитание, умножение';
            1000:  temp := temp + ', деление';
            1001:  temp := temp + ', деление, умножение';
            1010:  temp := temp + ', деление, вычитание';
            1011:  temp := temp + ', деление, вычитание, умножение';
            1100:  temp := temp + ', деление, сложение';
            1101:  temp := temp + ', деление, сложение, умножение';
            1110:  temp := temp + ', деление, сложение, вычитание';
            1111:  temp := temp + ', деление, сложение, вычитание, умножение';
          end;
        end;
        if (fdb.ADOQueryDevMode.FieldByName('Task').AsInteger = 2) then
          Case fdb.ADOQueryDevMode.FieldByName('Radio').AsInteger of
            0 : temp := temp + 'Вся таблица';
            1 : temp := temp + 'Умножение на 2';
            2 : temp := temp + 'Умножение на 3';
            3 : temp := temp + 'Умножение на 4';
            4 : temp := temp + 'Умножение на 5';
            5 : temp := temp + 'Умножение на 6';
            6 : temp := temp + 'Умножение на 7';
            7 : temp := temp + 'Умножение на 8';
            8 : temp := temp + 'Умножение на 9';
          end;
        if (fdb.ADOQueryDevMode.FieldByName('Task').AsInteger = 3) then
        begin
          Case fdb.ADOQueryDevMode.FieldByName('Radio').AsInteger of
            0 : temp := temp + 'От 0 до 9';
            1 : temp := temp + 'От 10 до 99';
            2 : temp := temp + 'От 100 до 999';
          end;
          Case fdb.ADOQueryDevMode.FieldByName('Combo').AsInteger of
            1   :  temp := temp + ', умножение';
            10  :  temp := temp + ', вычитание';
            11  :  temp := temp + ', вычитание, умножение';
            100 :  temp := temp + ', сложение';
            101 :  temp := temp + ', сложение, умножение';
            110 :  temp := temp + ', сложение, вычитание';
            111 :  temp := temp + ', сложение, вычитание, умножение';
          end;
          Case fdb.ADOQueryDevMode.FieldByName('Slider').AsInteger of
            3 : temp := temp + ', 3x3';
            4 : temp := temp + ', 4x4';
            5 : temp := temp + ', 5x5';
          end;
        end;
        if (fdb.ADOQueryDevMode.FieldByName('Task').AsInteger = 4) then
        begin
           temp := temp + fdb.ADOQueryDevMode.FieldByName('Slider').AsString + ' мин';
        end;
        S.TypeParagraph;
        S.Font.Bold:=1;
        S.Font.Size:=14;
        S.ParagraphFormat.Alignment:=1;
       // S.TypeText(temp);
        if not fdb.ADOQuery111.Active then
          fdb.ADOQuery111.close;
        fdb.ADOQuery111.sql.clear;
        //fdb.ADOQuery111.Fields.clear;
        fdb.ADOQuery111.sql.add('SELECT U.User_Family AS Family, U.User_Login AS Login, Gr.Nazvanie AS Groups,');
        fdb.ADOQuery111.sql.add('RC.Start_Data AS Start_Data, RC.Correct AS Correct, RC.Effect AS Effect');
        fdb.ADOQuery111.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
        fdb.ADOQuery111.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Task_Type=:2 AND RC.Radio_Set=:3 AND RC.Combo_Set=:4 AND RC.Slider_Set=:5');
        fdb.ADOQuery111.sql.add('ORDER BY RC.Start_Data');
        fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
        fdb.ADOQuery111.Parameters.ParamByName('2').Value:=fdb.ADOQueryDevMode.FieldByName('Task').AsInteger;
        fdb.ADOQuery111.Parameters.ParamByName('3').Value:=fdb.ADOQueryDevMode.FieldByName('Radio').AsInteger;
        fdb.ADOQuery111.Parameters.ParamByName('4').Value:=fdb.ADOQueryDevMode.FieldByName('Combo').AsInteger;
        fdb.ADOQuery111.Parameters.ParamByName('5').Value:=fdb.ADOQueryDevMode.FieldByName('Slider').AsInteger;
        if not fdb.ADOQueryDevMin.Active then
          fdb.ADOQueryDevMin.close;
        fdb.ADOQueryDevMin.sql.clear;
        fdb.ADOQueryDevMin.Fields.clear;
        fdb.ADOQueryDevMin.sql.add('SELECT MIN(RC.Effect) AS Result');
        fdb.ADOQueryDevMin.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
        fdb.ADOQueryDevMin.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Task_Type=:2 AND RC.Radio_Set=:3 AND RC.Combo_Set=:4 AND RC.Slider_Set=:5');
        fdb.ADOQueryDevMin.sql.add('AND RC.Effect > 0');
        fdb.ADOQueryDevMin.Parameters.ParamByName('1').Value:=fMainMenu.userId;
        fdb.ADOQueryDevMin.Parameters.ParamByName('2').Value:=fdb.ADOQueryDevMode.FieldByName('Task').AsInteger;
        fdb.ADOQueryDevMin.Parameters.ParamByName('3').Value:=fdb.ADOQueryDevMode.FieldByName('Radio').AsInteger;
        fdb.ADOQueryDevMin.Parameters.ParamByName('4').Value:=fdb.ADOQueryDevMode.FieldByName('Combo').AsInteger;
        fdb.ADOQueryDevMin.Parameters.ParamByName('5').Value:=fdb.ADOQueryDevMode.FieldByName('Slider').AsInteger;
        if not fdb.ADOQueryDevMax.Active then
          fdb.ADOQueryDevMax.close;
        fdb.ADOQueryDevMax.sql.clear;
        fdb.ADOQueryDevMax.Fields.clear;
        fdb.ADOQueryDevMax.sql.add('SELECT MAX(RC.Effect) AS Result');
        fdb.ADOQueryDevMax.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
        fdb.ADOQueryDevMax.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Task_Type=:2 AND RC.Radio_Set=:3 AND RC.Combo_Set=:4 AND RC.Slider_Set=:5');
        fdb.ADOQueryDevMax.Parameters.ParamByName('1').Value:=fMainMenu.userId;
        fdb.ADOQueryDevMax.Parameters.ParamByName('2').Value:=fdb.ADOQueryDevMode.FieldByName('Task').AsInteger;
        fdb.ADOQueryDevMax.Parameters.ParamByName('3').Value:=fdb.ADOQueryDevMode.FieldByName('Radio').AsInteger;
        fdb.ADOQueryDevMax.Parameters.ParamByName('4').Value:=fdb.ADOQueryDevMode.FieldByName('Combo').AsInteger;
        fdb.ADOQueryDevMax.Parameters.ParamByName('5').Value:=fdb.ADOQueryDevMode.FieldByName('Slider').AsInteger;
        fdb.ADOQueryDevMax.Open;
        fdb.ADOQueryDevMax.First;
        fdb.ADOQueryDevMin.Open;
        fdb.ADOQueryDevMin.First;
        fdb.ADOQuery111.Open;
        fdb.ADOQuery111.First;
        if (fdb.ADOQuery111.RecordCount>1) and (fdb.ADOQueryDevMax.FieldByName('Result').AsFloat > 0) then
          begin
            S.TypeText(temp);
            S.TypeParagraph;
            S.Font.Bold:=1;
            S.ParagraphFormat.Alignment:=1;
            S.Font.Size:=12;
            T := Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery111.RecordCount+1, 4);
            T.AutoFitBehavior(2);
            T.Cell(1, 1).Range.Text:='ДАТА';
            T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 1).Borders.Enable:=1;
            T.Cell(1, 2).Range.Text:='ЗНАЧЕНИЕ';
            T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 2).Borders.Enable:=1;
            T.Cell(1, 3).Range.Text:='ПРАВИЛЬНЫЕ ОТВЕТЫ';
            T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 3).Borders.Enable:=1;
            T.Cell(1, 4).Range.Text:='ЭФФЕКТИВНОСТЬ';
            T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 4).Borders.Enable:=1;
            T.Columns.Width:=118;
            T.Rows.Alignment:=0;
            i:=0;
            While not fdb.ADOQuery111.Eof do
              begin
                T.Cell(i+2, 1).Range.Text := fdb.ADOQuery111.FieldByName('Start_Data').AsString;
                T.Cell(i+2, 1).Borders.Enable:=1;
                if (fdb.ADOQuery111.FieldByName('Effect').AsFloat = fdb.ADOQueryDevMax.FieldByName('Result').AsFloat) then
                  temp := 'Максимум'
                else if (fdb.ADOQuery111.FieldByName('Effect').AsFloat = fdb.ADOQueryDevMin.FieldByName('Result').AsFloat) then
                  temp := 'Минимум'
                else
                  temp := '';
                T.Cell(i+2, 2).Range.Text := temp;
                T.Cell(i+2, 2).Borders.Enable:=1;
                T.Cell(i+2, 3).Range.Text := fdb.ADOQuery111.FieldByName('Correct').AsInteger;;
                T.Cell(i+2, 3).Borders.Enable:=1;
                T.Cell(i+2, 4).Range.Text:=RoundTo(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
                T.Cell(i+2, 4).Borders.Enable:=1;
                T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=2;
                fdb.ADOQuery111.Next;
                i:=i+1;
              end;
            Word.Selection.EndKey(6, 0);
            S.Font.Bold:=1;
            S.ParagraphFormat.Alignment:=1;
            S.Font.Size:=14;
            S.TypeText('Отмечен рост эффективности в ' + FloatToStr(RoundTo(fdb.ADOQueryDevMax.FieldByName('Result').AsFloat / fdb.ADOQueryDevMin.FieldByName('Result').AsFloat,-2)) + ' раза');
          end;
          fdb.ADOQueryDevMode.Next;
      end;
    Word.Visible := True;
    Word.Activate;
    Word.WindowState:= 1;
end;

procedure ClassReport1;
var
 Word:variant;
 Doc:variant;
 S:variant;
 T:variant;
 i:integer;
 Date:TDateTime;
 temp:string;
begin
  try
    Date:=Now;
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
    S:=Word.Selection;
    if not fdb.ADOQueryCompleXity.Active then
      fdb.ADOQueryCompleXity.close;
    fdb.ADOQueryCompleXity.Open;
    fdb.ADOQueryCompleXity.First;
    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if fEntry.Visible then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Классная работа');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;
    while not fdb.ADOQueryCompleXity.eof do
      begin
        if not fdb.ADOQuery4qq.Active then
          fdb.ADOQuery4qq.close;
        fdb.ADOQuery4qq.sql.clear;
        fdb.ADOQuery4qq.sql.add('SELECT AVG(RC.Mark) AS Mark');
        fdb.ADOQuery4qq.sql.add('FROM Groups AS Gr, Results_Class AS RC, Users AS U, Traject AS T, Lessons AS L');
        fdb.ADOQuery4qq.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Traject_ID=T.ID AND RC.Lessons_ID=L.ID AND T.Zoya_level=:2 AND RC.Traject_ID=:3');
        if fMainMenu.userId=0 then
          fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
        fdb.ADOQuery4qq.Parameters.ParamByName('1').Value:=fMainMenu.userId;
        fdb.ADOQuery4qq.Parameters.ParamByName('2').Value:=fdb.Zoya_level;
        fdb.ADOQuery4qq.Parameters.ParamByName('3').Value:=fdb.ADOQueryCompleXity.FieldByName('ID').AsInteger;
        fdb.ADOQuery4qq.Open;
        fdb.ADOQuery4qq.First;

        if not fdb.ADOQuery111.Active then
          fdb.ADOQuery111.close;
        fdb.ADOQuery111.sql.clear;
        fdb.ADOQuery111.sql.add('SELECT U.User_Family AS Family, U.User_Login AS Login, Gr.Nazvanie AS Groups, RC.Start_Data AS Start_Data, T.Nazvanie AS Traject_Nazvanie,');
        fdb.ADOQuery111.sql.add('L.Nazvanie AS Lessons_Nazvanie, RC.Mark AS Mark, RC.Effect AS Effect, RC.Traject_ID AS Results_Class_Traject_ID');
        fdb.ADOQuery111.sql.add('FROM Groups AS Gr, Results_Class AS RC, Users AS U, Traject AS T, Lessons AS L');
        fdb.ADOQuery111.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Traject_ID=T.ID AND RC.Lessons_ID=L.ID AND T.Zoya_level=:2 AND RC.Traject_ID=:3');
        fdb.ADOQuery111.sql.add('ORDER BY RC.Start_Data, T.Zoya_level');
        if fMainMenu.userId=0 then
          fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
        fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
        fdb.ADOQuery111.Parameters.ParamByName('2').Value:=fdb.Zoya_level;
        fdb.ADOQuery111.Parameters.ParamByName('3').Value:=fdb.ADOQueryCompleXity.FieldByName('ID').AsInteger;
        fdb.ADOQuery111.Open;
        fdb.ADOQuery111.First;
        if fdb.ADOQuery111.RecordCount>0 then
          begin
            S.TypeParagraph;
            S.Font.Bold:=1;
            S.Font.Size:=16;
            S.ParagraphFormat.Alignment:=1;
            if fdb.ADOQuery4qq.RecordCount>0 then
              temp:=floattostr(roundto(fdb.ADOQuery4qq.FieldByName('Mark').AsFloat,-2))
            else
              temp:='';
            S.TypeText(fdb.ADOQuery111.FieldByName('Traject_Nazvanie').AsString+'-'+temp);
            S.ParagraphFormat.Alignment:=1;
            S.Font.Size:=12;
            T := Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery111.RecordCount+1, 5);
            T.AutoFitBehavior(2);
            T.Cell(1, 1).Range.Text:='ДАТА';
            T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 1).Borders.Enable:=1;
            T.Cell(1, 2).Range.Text:='ТРАЕКТОРИЯ';
            T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 2).Borders.Enable:=1;
            T.Cell(1, 3).Range.Text:='УРОК';
            T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 3).Borders.Enable:=1;
            T.Cell(1, 4).Range.Text:='ОЦЕНКА';
            T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 4).Borders.Enable:=1;
            T.Cell(1, 5).Range.Text:='ЭФФЕКТИВНОСТЬ';
            T.Cell(1, 5).Range.ParagraphFormat.alignment:=1;
            T.Cell(1, 5).Borders.Enable:=1;
            T.Columns.Width:=94;
            T.Rows.Alignment:=0;
            i:=0;
            While not fdb.ADOQuery111.Eof do
              begin
                T.Cell(i+2, 1).Range.Text := fdb.ADOQuery111.FieldByName('Start_Data').AsString;
                T.Cell(i+2, 1).Borders.Enable:=1;
                T.Cell(i+2, 2).Range.Text := fdb.ADOQuery111.FieldByName('Traject_Nazvanie').AsString+' (' +GetTextControl(fdb.ADOQuery111.FieldByName('Results_Class_Traject_ID').AsInteger) + ')';
                T.Cell(i+2, 2).Borders.Enable:=1;
                T.Cell(i+2, 3).Range.Text := fdb.ADOQuery111.FieldByName('Lessons_Nazvanie').AsString;
                T.Cell(i+2, 3).Borders.Enable:=1;
                T.Cell(i+2, 4).Range.Text := fdb.ADOQuery111.FieldByName('Mark').AsString;
                T.Cell(i+2, 4).Borders.Enable:=1;
                T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=1;
                T.Cell(i+2, 5).Range.Text:=RoundTo(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
                T.Cell(i+2, 5).Borders.Enable:=1;
                T.Cell(i+2, 5).Range.ParagraphFormat.alignment:=2;
                fdb.ADOQuery111.Next;
                i:=i+1;
              end;
            Word.Selection.EndKey(6, 0);
          end;
      fdb.ADOQueryCompleXity.Next;
      end;
    Word.Visible := True;
    Word.Activate;
    Word.WindowState:= 1;
end;

procedure ClassReport2;
var
 Word: variant;
 Doc: variant;
 S: variant;
 Traject_FullName:String;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
  S:=Word.Selection;
  if fDB.ADOQueryTrajectProcess.Active then
    fDB.ADOQueryTrajectProcess.close;
  fDB.ADOQueryTrajectProcess.SQL.Clear;
  fDB.ADOQueryTrajectProcess.SQL.Add('SELECT T.ID, T.Nazvanie FROM Traject AS T WHERE T.Zoya_level=:1 ORDER BY T.Zoya_Level');
  fdb.ADOQueryTrajectProcess.Parameters.ParamByName('1').Value:=fdb.Zoya_level;
  fDB.ADOQueryTrajectProcess.Open;
  fDB.ADOQueryTrajectProcess.First;
  S.Font.Size:=12;
  S.ParagraphFormat.Alignment:=0;
  S.TypeText('Дата печати: '+DateToStr(Date));
  S.TypeParagraph;
  S.ParagraphFormat.Alignment:=2;
  if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
  S.TypeParagraph;
  S.Font.Bold:=1;
  S.Font.Size:=16;
  S.ParagraphFormat.Alignment:=1;
  S.TypeText('Ведомость результатов по математике' +#13#10+'Классная работа');
  S.Font.Bold:=1;
  S.Font.Size:=14;
  S.ParagraphFormat.Alignment:=1;
  While not fdb.ADOQueryTrajectProcess.Eof do
    begin
      Traject_FullName:=fdb.ADOQueryTrajectProcess.FieldByName('Nazvanie').AsString+' ('+GetTextControl(fdb.ADOQueryTrajectProcess.FieldByName('ID').AsInteger)+ ')';
      TrajectProcess_L(fdb.ADOQueryTrajectProcess.FieldByName('ID').AsInteger, Traject_FullName,Word,Doc,S);
      fdb.ADOQueryTrajectProcess.Next;
    end;
  Word.Visible := True;
  Word.Activate;
  Word.WindowState:=1;
end;

procedure TrajectProcess_L(ID_Traject:integer; Traject_Nazvanie:string;Word:variant; Doc: variant; S:variant);
var
 begin_date,end_date:TDateTime;
 Marks: array [1..2] of integer;
 Effects: array [1..2] of double;
 T:variant;
 i:integer;
begin
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MIN(Start_Data) AS StartDate FROM Results_Class WHERE User_ID=:1 and Traject_ID=:2');
  if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('2').Value:=ID_Traject;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  begin_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MAX(Start_Data) AS StartDate FROM Results_Class WHERE User_ID=:1 and Traject_ID=:2');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('2').Value:=ID_Traject;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  end_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.Close;
  if fdb.ADOQuery112.Active then
      fdb.ADOQuery112.close;
  fdb.ADOQuery112.sql.clear;
  fdb.ADOQuery112.sql.add('SELECT Users.User_Family, Users.User_Login, Groups.Nazvanie, Results_Class.Start_Data, Traject.Nazvanie, Lessons.Nazvanie, Results_Class.Mark, Results_Class.Effect');
  fdb.ADOQuery112.sql.add('FROM Groups, Results_Class, Users, Traject, Lessons WHERE Users.Group_id=Groups.ID and Results_Class.User_ID=:1 and Results_Class.User_ID=Users.ID and Results_Class.Traject_ID=Traject.ID and Results_Class.Lessons_ID=Lessons.ID and');
  fdb.ADOQuery112.sql.add('Results_Class.Traject_ID=:2 AND Traject.Zoya_Level=:3  AND ((Results_Class.Start_Data=:4) or (Results_Class.Start_Data=:5))');
  fdb.ADOQuery112.sql.add('ORDER BY Results_Class.Start_Data');
  fdb.ADOQuery112.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fdb.ADOQuery112.Parameters.ParamByName('2').Value:=ID_Traject;
  fdb.ADOQuery112.Parameters.ParamByName('3').Value:=fdb.Zoya_level;
  fdb.ADOQuery112.Parameters.ParamByName('4').Value:=begin_date;
  fdb.ADOQuery112.Parameters.ParamByName('5').Value:=end_date;
  fdb.ADOQuery112.Open;
  fdb.ADOQuery112.First;
  if fdb.ADOQuery112.RecordCount>0 then
    begin
      S.Font.Bold:=1;
      S.Font.Size:=16;
      S.ParagraphFormat.Alignment:=1;
      S.TypeParagraph;
      S.Font.italic:=True;
      S.TypeText(Traject_Nazvanie);
      S.TypeParagraph;
      S.Font.italic:=false;
      S.Font.Size:=12;
      T:=Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery112.RecordCount+1, 4);

      T.Cell(1, 1).Range.Text := 'ОЦЕНКА';
      T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 1).Borders.Enable:=1;
      T.Cell(1, 2).Range.Text := '';
      T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 2).Borders.Enable:=1;
      T.Cell(1, 3).Range.Text := 'ЭФФЕКТИВНОСТЬ';
      T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 3).Borders.Enable:=1;
      T.Cell(1, 4).Range.Text := '';
      T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 4).Borders.Enable:=1;
      T.Cell(1, 3).Merge(T.Cell(1, 4));
      T.Cell(1, 1).Merge(T.Cell(1, 2));

      T.Cell(2, 1).Range.Text := 'НАЧАЛЬНАЯ';
      T.Cell(2, 1).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 1).Borders.Enable:=1;
      T.Cell(2, 2).Range.Text := 'КОНЕЧНАЯ';
      T.Cell(2, 2).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 2).Borders.Enable:=1;
      T.Cell(2, 3).Range.Text := 'НАЧАЛЬНАЯ';
      T.Cell(2, 3).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 3).Borders.Enable:=1;
      T.Cell(2, 4).Range.Text := 'КОНЕЧНАЯ';
      T.Cell(2, 4).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 4).Borders.Enable:=1;

      i:=1;
      While not fdb.ADOQuery112.Eof do
        begin
          if begin_date<>end_date then
            begin
              Marks[i]:=fdb.ADOQuery112.FieldByName('Mark').AsInteger;
              S.ParagraphFormat.Alignment:=1;
              Effects[i]:=Roundto(fdb.ADOQuery112.FieldByName('Effect').AsFloat,-2);
            end
            else
            begin
              Marks[1]:=fdb.ADOQuery112.FieldByName('Mark').AsInteger;
              S.ParagraphFormat.Alignment:=1;
              Effects[1]:=Roundto(fdb.ADOQuery112.FieldByName('Effect').AsFloat,-2);
              break;
            end;
          fdb.ADOQuery112.Next;
          i:=i+1;
        end;
      for i:=1 to 4 do
        begin
          T.Cell(i+2, 1).Range.Text := inttostr(Marks[1]);
          T.Cell(i+2, 1).Borders.Enable:=1;
          if begin_date<>end_date then
            T.Cell(i+2, 2).Range.Text:=inttostr(Marks[2])
          else
            T.Cell(i+2, 2).Range.Text:='-';
          T.Cell(i+2, 2).Borders.Enable:=1;
          T.Cell(i+2, 3).Range.Text := floattostr(Effects[1]);
          T.Cell(i+2, 3).Borders.Enable:=1;
          if begin_date<>end_date then
            T.Cell(i+2, 4).Range.Text:=floattostr(Effects[2])
          else
            T.Cell(i+2, 4).Range.Text:='-';
          T.Cell(i+2, 4).Borders.Enable:=1;
        end;
      T.AutoFitBehavior(2);
      Word.Selection.EndKey(6, 0);
    end;
end;


procedure ClassReport3;
var
 Word: variant;
 Doc: variant;
 S: variant;
  Traject_FullName:String;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
  S:=Word.Selection;
  if fDB.ADOQueryTrajectProcess.Active then
    fDB.ADOQueryTrajectProcess.close;
  fDB.ADOQueryTrajectProcess.SQL.Clear;
  fDB.ADOQueryTrajectProcess.SQL.Add('SELECT T.ID, T.Nazvanie FROM Traject AS T WHERE T.Zoya_level=:1 ORDER BY T.Zoya_Level');
  fDB.ADOQueryTrajectProcess.Parameters.ParamByName('1').Value:=fDB.Zoya_level;
  fDB.ADOQueryTrajectProcess.Open;
  fDB.ADOQueryTrajectProcess.First;

  S.Font.Size:=12;
  S.ParagraphFormat.Alignment:=0;
  S.TypeText('Дата печати: '+DateToStr(Date));
  S.TypeParagraph;
  S.ParagraphFormat.Alignment:=2;
  if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
  S.TypeParagraph;
  S.Font.Bold:=1;
  S.Font.Size:=16;
  S.ParagraphFormat.Alignment:=1;
  S.TypeText('Ведомость результатов по математике' +#13#10+'Классная работа');
  S.Font.Bold:=1;
  S.Font.Size:=14;
  S.ParagraphFormat.Alignment:=1;

  While not fdb.ADOQueryTrajectProcess.Eof do
    begin
      Traject_FullName:=fdb.ADOQueryTrajectProcess.FieldByName('Nazvanie').AsString+' ('+GetTextControl(fdb.ADOQueryTrajectProcess.FieldByName('ID').AsInteger)+ ')';
      TrajectProcess(fdb.ADOQueryTrajectProcess.FieldByName('ID').AsInteger, Traject_FullName,Word,Doc,S);
      fdb.ADOQueryTrajectProcess.Next;
    end;
  Word.Visible := True;
  Word.Activate;
  Word.WindowState:= 1;
end;

procedure TrajectProcess(ID_Traject:integer; Traject_Nazvanie:string; Word:variant; Doc: variant; S:variant);
var
 begin_date,end_date:TDateTime;
 Marks: array [1..2] of integer;
 Effects: array [1..2] of double;
 T:variant;
 i:integer;
begin
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MIN(Start_Data) AS StartDate FROM Results_Class WHERE User_ID=:1 and Traject_ID=:2');
  if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('2').Value:=ID_Traject;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  begin_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MAX(Start_Data) AS StartDate FROM Results_Class WHERE User_ID=:1 and Traject_ID=:2');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('2').Value:=ID_Traject;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  end_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.Close;
  if fdb.ADOQuery112.Active then
      fdb.ADOQuery112.close;
  fdb.ADOQuery112.sql.clear;
  fdb.ADOQuery112.sql.add('SELECT Users.User_Family, Users.User_Login, Groups.Nazvanie, Results_Class.Start_Data, Traject.Nazvanie, Lessons.Nazvanie, Results_Class.Mark, Results_Class.Effect');
  fdb.ADOQuery112.sql.add('FROM Groups, Results_Class, Users, Traject, Lessons WHERE Users.Group_id=Groups.ID and Results_Class.User_ID=:1 and Results_Class.User_ID=Users.ID and Results_Class.Traject_ID=Traject.ID and Results_Class.Lessons_ID=Lessons.ID and');
  fdb.ADOQuery112.sql.add('Results_Class.Traject_ID=:2 AND Traject.Zoya_level=:3 AND ((Results_Class.Start_Data=:4) or (Results_Class.Start_Data=:5))');
  fdb.ADOQuery112.sql.add('ORDER BY Results_Class.Start_Data');
  fdb.ADOQuery112.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fdb.ADOQuery112.Parameters.ParamByName('2').Value:=ID_Traject;
  fdb.ADOQuery112.Parameters.ParamByName('3').Value:=fdb.Zoya_level;
  fdb.ADOQuery112.Parameters.ParamByName('4').Value:=begin_date;
  fdb.ADOQuery112.Parameters.ParamByName('5').Value:=end_date;
  fdb.ADOQuery112.open;
  fdb.ADOQuery112.First;
  if fdb.ADOQuery112.RecordCount>0 then
    begin
      S.Font.Bold:=1;
      S.Font.Size:=16;
      S.ParagraphFormat.Alignment:=1;
      S.TypeParagraph;
      S.Font.italic:=True;
      S.TypeText(Traject_Nazvanie);
      S.TypeParagraph;
      S.Font.italic:=false;
      S.Font.Size:=12;
      T:= Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery112.RecordCount+1, 5);
      T.Cell(1, 1).Range.Text := 'ОЦЕНКА';
      T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 1).Borders.Enable:=1;
      T.Cell(1, 2).Range.Text := '';
      T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 2).Borders.Enable:=1;
      T.Cell(1, 3).Range.Text := 'ЭФФЕКТИВНОСТЬ';
      T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 3).Borders.Enable:=1;
      T.Cell(1, 4).Range.Text := '';
      T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 4).Borders.Enable:=1;
      T.Cell(1, 5).Range.Text := 'ОТНОШЕНИЕ';
      T.Cell(1, 5).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 5).Borders.Enable:=1;
      T.Cell(1, 3).Merge(T.Cell(1, 4));
      T.Cell(1, 1).Merge(T.Cell(1, 2));

      T.Cell(2, 1).Range.Text := 'НАЧАЛЬНАЯ';
      T.Cell(2, 1).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 1).Borders.Enable:=1;
      T.Cell(2, 2).Range.Text := 'КОНЕЧНАЯ';
      T.Cell(2, 2).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 2).Borders.Enable:=1;
      T.Cell(2, 3).Range.Text := 'НАЧАЛЬНАЯ';
      T.Cell(2, 3).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 3).Borders.Enable:=1;
      T.Cell(2, 4).Range.Text := 'КОНЕЧНАЯ';
      T.Cell(2, 4).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 4).Borders.Enable:=1;
      T.Cell(2, 5).Range.Text := 'КОН/НАЧ';
      T.Cell(2, 5).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 5).Borders.Enable:=1;

      i:=1;
      While not fdb.ADOQuery112.Eof do
        begin
          if begin_date<>end_date then
            begin
              Marks[i]:=fdb.ADOQuery112.FieldByName('Mark').AsInteger;
              S.ParagraphFormat.Alignment:=1;
              Effects[i]:=Roundto(fdb.ADOQuery112.FieldByName('Effect').AsFloat,-2);
            end
          else
            begin
              Marks[1]:=fdb.ADOQuery112.FieldByName('Mark').AsInteger;
              S.ParagraphFormat.Alignment:=1;
              Effects[1]:=Roundto(fdb.ADOQuery112.FieldByName('Effect').AsFloat,-2);
              break;
            end;
          fdb.ADOQuery112.Next;
          i:=i+1;
        end;
      for i:=1 to 4 do
        begin
          T.Cell(i+2, 1).Range.Text := inttostr(Marks[1]);
          T.Cell(i+2, 1).Borders.Enable:=1;
          if begin_date<>end_date then
            T.Cell(i+2, 2).Range.Text:=inttostr(Marks[2])
          else
            T.Cell(i+2, 2).Range.Text:='-';
          T.Cell(i+2, 2).Borders.Enable:=1;
          T.Cell(i+2, 3).Range.Text := floattostr(Effects[1]);
          T.Cell(i+2, 3).Borders.Enable:=1;
          if begin_date<>end_date then
            begin
              T.Cell(i+2, 4).Range.Text:=floattostr(Effects[2]);
                if effects[1]=0 then
                  T.Cell(i+2, 5).Range.Text:='0'
                else
                  T.Cell(i+2, 5).Range.Text:=roundto(Effects[2]/Effects[1],-2);
              T.Cell(i+2, 5).Borders.Enable:=1;
            end
          else
            T.Cell(i+2, 4).Range.Text:='-';
          T.Cell(i+2, 4).Borders.Enable:=1;
        end;
      T.AutoFitBehavior(2);
      Word.Selection.EndKey(6, 0);
    end;
end;


procedure ClassReport4;
var
 Word: variant;
 Doc: variant;
 S: variant;
 T: variant;
 i:integer;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
    S:=Word.Selection;
    if not fdb.ADOQuery112.Active then
      fdb.ADOQuery112.close;
    fdb.ADOQuery112.sql.clear;
    fdb.ADOQuery112.sql.add('SELECT Users.User_Family, Users.User_Login, Groups.Nazvanie, Results_Class.Start_Data, Traject.Nazvanie AS Traject_Nazvanie, Lessons.Nazvanie, Results_Class.Mark, Results_Class.Effect, Results_Class.Traject_ID AS Results_Class_Traject_ID');
    fdb.ADOQuery112.sql.add('FROM Groups, Results_Class, Users, Traject, Lessons WHERE Users.Group_id=Groups.ID and Results_Class.User_ID=:1 and Results_Class.Traject_ID=Traject.ID and Results_Class.Lessons_ID=Lessons.ID ORDER BY Results_Class.Start_Data');
    if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
    fdb.ADOQuery112.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQuery112.open;
    fdb.ADOQuery112.First;

    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Классная работа');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;

    T:=Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery112.RecordCount+1, 5);
    T.AutoFitBehavior(2);
    T.Cell(1, 1).Range.Text := 'ДАТА';
    T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 1).Borders.Enable:=1;
    T.Cell(1, 2).Range.Text := 'ТРАЕКТОРИЯ';
    T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 2).Borders.Enable:=1;
    T.Cell(1, 3).Range.Text := 'УРОК';
    T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 3).Borders.Enable:=1;
    T.Cell(1, 4).Range.Text := 'ОЦЕНКА';
    T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 4).Borders.Enable:=1;
    T.Cell(1, 5).Range.Text := 'ЭФФЕКТИВНОСТЬ';
    T.Cell(1, 5).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 5).Borders.Enable:=1;
    T.Columns.Width:=94;
    T.Rows.Alignment:=0;
    i:=0;
    While not fdb.ADOQuery112.Eof do
      begin
        T.Cell(i+2, 1).Range.Text := fdb.ADOQuery112.FieldByName('Start_Data').AsString;
        T.Cell(i+2, 1).Borders.Enable:=1;
        T.Cell(i+2, 2).Range.Text := fdb.ADOQuery112.FieldByName('Traject_Nazvanie').AsString+' (' +GetTextControl(fdb.ADOQuery112.FieldByName('Results_Class_Traject_ID').AsInteger) + ')';
        T.Cell(i+2, 2).Borders.Enable:=1;
        T.Cell(i+2, 3).Range.Text := fdb.ADOQuery112.FieldByName('Lessons.Nazvanie').AsString;
        T.Cell(i+2, 3).Borders.Enable:=1;
        T.Cell(i+2, 4).Range.Text := fdb.ADOQuery112.FieldByName('Mark').AsString;
        T.Cell(i+2, 4).Borders.Enable:=1;
        T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 5).Range.Text := roundto(fdb.ADOQuery112.FieldByName('Effect').AsFloat,-2);
        T.Cell(i+2, 5).Borders.Enable:=1;
        T.Cell(i+2, 5).Range.ParagraphFormat.alignment:=2;
        fdb.ADOQuery112.Next;
        i:=i+1;
      end;
  Word.Visible := True;
  Word.Activate;
  Word.WindowState:= 1;
end;

procedure ClassReport5;
var
 Word: variant;
 Doc: variant;
 S: variant;
 T: variant;
 i:integer;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
    S:=Word.Selection;
    if not fdb.ADOQuery111.Active then
      fdb.ADOQuery111.close;
    fdb.ADOQuery111.sql.clear;
    fdb.ADOQuery111.sql.add('SELECT Users.User_Family AS Family, Users.User_Login AS Login, Groups.Nazvanie AS Groups, Results_Ind.Start_Data AS Start_Data, Results_Ind.Finish_Time AS Finish_Time,');
    fdb.ADOQuery111.sql.add('Results_Ind.Mark AS Mark, Results_Ind.Effect AS Effect');
    fdb.ADOQuery111.sql.add('FROM Groups, Results_Ind, Users');
    fdb.ADOQuery111.sql.add('WHERE Users.Group_id=Groups.ID and Results_Ind.User_ID=Users.ID and Results_Ind.User_ID=:1');
    fdb.ADOQuery111.sql.add('ORDER BY Results_Ind.Start_Data');
    if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
    fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQuery111.Open;
    fdb.ADOQuery111.First;
    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Самостоятельная работа');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;

    S.TypeParagraph;
    if fdb.ADOQuery111.RecordCount>0 then
      //S.TypeText(fdb.ADOQuery111.FieldByName('CompleXity_Nazvanie').AsString)
    else
      begin
        ShowMessage('Результаты не найдены!');
        exit;
      end;
    S.ParagraphFormat.Alignment:=1;
    S.Font.Size:=12;

    T := Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery111.RecordCount+1, 3);
    T.Rows.Alignment := 1;
    T.AutoFitBehavior(2);
    T.Cell(1, 1).Range.Text := 'ДАТА';
    T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 1).Borders.Enable:=1;
    T.Cell(1, 2).Range.Text := 'ОЦЕНКА';
    T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 2).Borders.Enable:=1;
    T.Cell(1, 3).Range.Text := 'ЭФФЕКТИВНОСТЬ';
    T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 3).Borders.Enable:=1;
    T.Columns.Width:=94;
    T.Rows.Alignment:=1;
    i:=0;
    While not fdb.ADOQuery111.Eof do
      begin
        T.Cell(i+2, 1).Range.Text := fdb.ADOQuery111.FieldByName('Start_Data').AsString;
        T.Cell(i+2, 1).Borders.Enable:=1;
        T.Cell(i+2, 2).Range.Text := fdb.ADOQuery111.FieldByName('Mark').AsString;
        T.Cell(i+2, 2).Borders.Enable:=1;
        T.Cell(i+2, 2).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 3).Range.Text := roundto(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
        T.Cell(i+2, 3).Borders.Enable:=1;
        T.Cell(i+2, 3).Range.ParagraphFormat.alignment:=2;
        fdb.ADOQuery111.Next;
        i:=i+1;
      end;
  Word.Visible := True;
  Word.Activate;
  Word.WindowState:= 1;
end;


procedure ClassReport6;
var
 Word:variant;
 Doc:variant;
 S,T:variant;
 begin_date,end_date:TDateTime;
 Marks:array [1..2] of integer;
 Effects:array [1..2] of double;
 i:integer;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
  S:=Word.Selection;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MIN(Start_Data) AS StartDate FROM Results_Ind WHERE User_ID=:1');
  if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  begin_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MAX(Start_Data) AS StartDate FROM Results_Ind WHERE User_ID=:1');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  end_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
     fDB.ADOQueryResultsDate.Close;
  if not fdb.ADOQuery111.Active then
      fdb.ADOQuery111.close;
  fdb.ADOQuery111.sql.clear;
  fdb.ADOQuery111.sql.add('SELECT Users.User_Family AS Family, Users.User_Login AS Login, Groups.Nazvanie AS Groups, Results_Ind.Start_Data AS Start_Data, Results_Ind.Finish_Time AS Finish_Time,');
  fdb.ADOQuery111.sql.add('Results_Ind.Mark AS Mark, Results_Ind.Effect AS Effect');
  fdb.ADOQuery111.sql.add('FROM Groups, Results_Ind, Users');
  fdb.ADOQuery111.sql.add('WHERE Users.Group_id=Groups.ID and Results_Ind.User_ID=Users.ID and Results_Ind.User_ID=:1');
  fdb.ADOQuery111.sql.add('and ((Results_Ind.Start_Data=:2) or (Results_Ind.Start_Data=:3))');
  fdb.ADOQuery111.sql.add('ORDER BY Results_Ind.Start_Data');
  fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fdb.ADOQuery111.Parameters.ParamByName('2').Value:=begin_date;
  fdb.ADOQuery111.Parameters.ParamByName('3').Value:=end_date;
  fdb.ADOQuery111.Open;
  if fdb.ADOQuery111.RecordCount=0 then
    begin
      ShowMessage('Резуьтаты не найдены!');
      exit;
    end;
  S.Font.Size:=12;
  S.ParagraphFormat.Alignment:=0;
  S.TypeText('Дата печати: '+DateToStr(Date));
  S.TypeParagraph;
  S.ParagraphFormat.Alignment:=2;
  if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
  S.TypeParagraph;
  S.Font.Bold:=1;
  S.Font.Size:=16;
  S.ParagraphFormat.Alignment:=1;
  S.TypeText('Ведомость результатов по математике' +#13#10+'Самостоятельная работа');
  S.Font.Bold:=1;
  S.Font.Size:=14;
  S.ParagraphFormat.Alignment:=1;
  S.Font.Size:=14;

  S.TypeParagraph;
  S.ParagraphFormat.Alignment:=1;
  //S.TypeText(fdb.ADOQuery111.FieldByName('CompleXity_Nazvanie').AsString);
  fdb.ADOQuery111.First;

  T:= Doc.Tables.Add(Word.Selection.Range, 3, 4);
  T.Rows.Alignment := 1;
  T.Cell(1, 1).Range.Text := 'ОЦЕНКА';
  T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
  T.Cell(1, 1).Borders.Enable:=1;
  T.Cell(1, 2).Range.Text := '';
  T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
  T.Cell(1, 2).Borders.Enable:=1;
  T.Cell(1, 3).Range.Text := 'ЭФФЕКТИВНОСТЬ';
  T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
  T.Cell(1, 3).Borders.Enable:=1;
  T.Cell(1, 4).Range.Text := '';
  T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
  T.Cell(1, 4).Borders.Enable:=1;
  T.Cell(1, 3).Merge(T.Cell(1, 4));
  T.Cell(1, 1).Merge(T.Cell(1, 2));
  T.Cell(2, 1).Range.Text := 'НАЧАЛЬНАЯ';
  T.Cell(2, 1).Range.ParagraphFormat.alignment:=1;
  T.Cell(2, 1).Borders.Enable:=1;
  T.Cell(2, 2).Range.Text := 'КОНЕЧНАЯ';
  T.Cell(2, 2).Range.ParagraphFormat.alignment:=1;
  T.Cell(2, 2).Borders.Enable:=1;
  T.Cell(2, 3).Range.Text := 'НАЧАЛЬНАЯ';
  T.Cell(2, 3).Range.ParagraphFormat.alignment:=1;
  T.Cell(2, 3).Borders.Enable:=1;
  T.Cell(2, 4).Range.Text := 'КОНЕЧНАЯ';
  T.Cell(2, 4).Range.ParagraphFormat.alignment:=1;
  T.Cell(2, 4).Borders.Enable:=1;


  i:=1;
  While not fdb.ADOQuery111.Eof do
    begin
      if begin_date<>end_date then
        begin
          Marks[i]:=fdb.ADOQuery111.FieldByName('Mark').AsInteger;
          S.ParagraphFormat.Alignment:=1;
          Effects[i]:=roundto(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
        end
        else
        begin
          Marks[1]:=fdb.ADOQuery111.FieldByName('Mark').AsInteger;
          S.ParagraphFormat.Alignment:=1;
          Effects[1]:=roundto(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
          break;
        end;
        fdb.ADOQuery111.Next;
        i:=i+1;
    end;
    if fdb.ADOQuery111.Active then
      fdb.ADOQuery111.close;
    for i:=1 to 4 do
      begin
        T.Cell(i+2, 1).Range.Text := inttostr(Marks[1]);
        T.Cell(i+2, 1).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 1).Borders.Enable:=1;
        if begin_date<>end_date then
          begin
            T.Cell(i+2, 2).Range.Text:=inttostr(Marks[2]);
            T.Cell(i+2, 2).Range.ParagraphFormat.alignment:=1;
          end
        else
          T.Cell(i+2, 2).Range.Text:='';
        T.Cell(i+2, 2).Borders.Enable:=1;
        T.Cell(i+2, 3).Range.Text := floattostr(Effects[1]);
        T.Cell(i+2, 3).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 3).Borders.Enable:=1;
        if begin_date<>end_date then
          begin
            T.Cell(i+2, 4).Range.Text:=floattostr(Effects[2]);
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

procedure ClassReport7;
var
 Word:variant;
 Doc:variant;
 S,T:variant;
 begin_date,end_date:TDateTime;
 Marks: array [1..2] of integer;
 Effects: array [1..2] of double;
 i:integer;
begin
  try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
  S:=Word.Selection;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MIN(Start_Data) AS StartDate FROM Results_Ind WHERE User_ID=:1');
  if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  begin_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
    fDB.ADOQueryResultsDate.close;
  fDB.ADOQueryResultsDate.SQL.Clear;
  fDB.ADOQueryResultsDate.SQL.Add('SELECT MAX(Start_Data) AS StartDate FROM Results_Ind WHERE User_ID=:1');
  fDB.ADOQueryResultsDate.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fDB.ADOQueryResultsDate.Open;
  if fDB.ADOQueryResultsDate.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  fDB.ADOQueryResultsDate.First;
  end_date:=fDB.ADOQueryResultsDate.FieldByName('StartDate').AsDateTime;
  if fDB.ADOQueryResultsDate.Active then
     fDB.ADOQueryResultsDate.Close;
  if not fdb.ADOQuery111.Active then
      fdb.ADOQuery111.close;
  fdb.ADOQuery111.sql.clear;
  fdb.ADOQuery111.sql.add('SELECT Users.User_Family AS Family, Users.User_Login AS Login, Groups.Nazvanie AS Groups, Results_Ind.Start_Data AS Start_Data, Results_Ind.Finish_Time AS Finish_Time,');
  fdb.ADOQuery111.sql.add('Results_Ind.Mark AS Mark, Results_Ind.Effect AS Effect');
  fdb.ADOQuery111.sql.add('FROM Groups, Results_Ind, Users');
  fdb.ADOQuery111.sql.add('WHERE Users.Group_id=Groups.ID and Results_Ind.User_ID=Users.ID and Results_Ind.User_ID=:1');
  fdb.ADOQuery111.sql.add('and ((Results_Ind.Start_Data=:2) or (Results_Ind.Start_Data=:3))');
  fdb.ADOQuery111.sql.add('ORDER BY Results_Ind.Start_Data');
  fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fdb.ADOQuery111.Parameters.ParamByName('2').Value:=begin_date;
  fdb.ADOQuery111.Parameters.ParamByName('3').Value:=end_date;
  fdb.ADOQuery111.Open;
  if fdb.ADOQuery111.RecordCount=0 then
    begin
      ShowMessage('Резуьтаты не найдены!');
      exit;
    end;
    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Самостоятельная работа');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;
    S.Font.Size:=14;

    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=1;
    S.Font.Size:=14;
    //S.TypeText(fdb.ADOQuery111.FieldByName('CompleXity_Nazvanie').AsString);
    fdb.ADOQuery111.First;

      T:= Doc.Tables.Add(Word.Selection.Range, 3, 5);
      T.Rows.Alignment := 1;
      T.Cell(1, 1).Range.Text := 'ОЦЕНКА';
      T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 1).Borders.Enable:=1;
      T.Cell(1, 2).Range.Text := '';
      T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 2).Borders.Enable:=1;
      T.Cell(1, 3).Range.Text := 'ЭФФЕКТИВНОСТЬ';
      T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 3).Borders.Enable:=1;
      T.Cell(1, 4).Range.Text := '';
      T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 4).Borders.Enable:=1;
      T.Cell(1, 5).Range.Text := 'ОТНОШЕНИЕ';
      T.Cell(1, 5).Range.ParagraphFormat.alignment:=1;
      T.Cell(1, 5).Borders.Enable:=1;
      T.Cell(1, 3).Merge(T.Cell(1, 4));
      T.Cell(1, 1).Merge(T.Cell(1, 2));

      T.Cell(2, 1).Range.Text := 'НАЧАЛЬНАЯ';
      T.Cell(2, 1).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 1).Borders.Enable:=1;
      T.Cell(2, 2).Range.Text := 'КОНЕЧНАЯ';
      T.Cell(2, 2).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 2).Borders.Enable:=1;
      T.Cell(2, 3).Range.Text := 'НАЧАЛЬНАЯ';
      T.Cell(2, 3).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 3).Borders.Enable:=1;
      T.Cell(2, 4).Range.Text := 'КОНЕЧНАЯ';
      T.Cell(2, 4).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 4).Borders.Enable:=1;
      T.Cell(2, 5).Range.Text := 'КОН/НАЧ';
      T.Cell(2, 5).Range.ParagraphFormat.alignment:=1;
      T.Cell(2, 5).Borders.Enable:=1;
  i:=1;
  While not fdb.ADOQuery111.Eof do
    begin
      if begin_date<>end_date then
        begin
          Marks[i]:=fdb.ADOQuery111.FieldByName('Mark').AsInteger;
          S.ParagraphFormat.Alignment:=1;
          Effects[i]:=roundto(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
        end
        else
        begin
          Marks[1]:=fdb.ADOQuery111.FieldByName('Mark').AsInteger;
          S.ParagraphFormat.Alignment:=1;
          Effects[1]:=roundto(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
          break;
        end;
        fdb.ADOQuery111.Next;
        i:=i+1;
    end;
    if fdb.ADOQuery111.Active then
      fdb.ADOQuery111.close;
    for i:=1 to 4 do
        begin
          T.Cell(i+2, 1).Range.Text := inttostr(Marks[1]);
          T.Cell(i+2, 1).Range.ParagraphFormat.alignment:=1;
          T.Cell(i+2, 1).Borders.Enable:=1;
          if begin_date<>end_date then
            begin
              T.Cell(i+2, 2).Range.Text:=inttostr(Marks[2]);
              T.Cell(i+2, 2).Range.ParagraphFormat.alignment:=1;
            end
          else
            T.Cell(i+2, 2).Range.Text:='';
          T.Cell(i+2, 2).Borders.Enable:=1;
          T.Cell(i+2, 3).Range.Text := floattostr(Effects[1]);
          T.Cell(i+2, 3).Range.ParagraphFormat.alignment:=1;
          T.Cell(i+2, 3).Borders.Enable:=1;
          if begin_date<>end_date then
            begin
              T.Cell(i+2, 4).Range.Text:=floattostr(Effects[2]);
              T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=1;
              if effects[1]=0 then
                T.Cell(i+2, 5).Range.Text:='0'
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


procedure ClassReport8;
var
 Word: variant;
 Doc: variant;
 S: variant;
 T: variant;
 i:integer;
begin
   try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
    S:=Word.Selection;
    if not fdb.ADOQuery111.Active then
      fdb.ADOQuery111.close;
    fdb.ADOQuery111.sql.clear;
    fdb.ADOQuery111.sql.add('SELECT Users.User_Family AS Family, Users.User_Login AS Login, Groups.Nazvanie AS Groups, Results_Diag.Start_Data AS Start_Data, Results_Diag.Finish_Time AS Finish_Time,');
    fdb.ADOQuery111.sql.add('Results_Diag.Mark AS Mark, Results_Diag.Effect AS Effect, CompleXity.Nazvanie AS CompleXity_Nazvanie, QuestionTypes.Nazvanie AS QT_Nazvanie');
    fdb.ADOQuery111.sql.add('FROM Groups, Results_Diag, Users, CompleXity, Questions, QuestionTypes');
    fdb.ADOQuery111.sql.add('WHERE Users.Group_id=Groups.ID and Results_Diag.User_ID=Users.ID and Results_Diag.User_ID=:1 and Questions.CompleXity_Id=CompleXity.ID');
    fdb.ADOQuery111.sql.add('and Results_Diag.Question_ID=Questions.ID and Questions.QuestionType_ID=QuestionTypes.ID  and Questions.QuestionType_ID=:2');
    fdb.ADOQuery111.sql.add('ORDER BY CompleXity.Question_Level, Results_DIag.Start_Data');
    if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
    fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQuery111.Parameters.ParamByName('2').Value:=fdb.QuestionTypes_ID;
    fdb.ADOQuery111.Open;

    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Диагностика');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;


    S.TypeParagraph;
    S.Font.Size:=14;
    S.TypeText(fdb.ADOQuery111.FieldByName('QT_Nazvanie').AsString);
    fdb.ADOQuery111.First;

    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=1;
    S.Font.Size:=12;

    T := Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery111.RecordCount+1, 4);
    T.Rows.Alignment := 1;
    T.AutoFitBehavior(2);
    T.Cell(1, 1).Range.Text := 'ДАТА';
    T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 1).Borders.Enable:=1;
    T.Cell(1, 2).Range.Text := 'СЛОЖНОСТЬ';
    T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 2).Borders.Enable:=1;
    T.Cell(1, 3).Range.Text := 'ОЦЕНКА';
    T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 3).Borders.Enable:=1;
    T.Cell(1, 4).Range.Text := 'ЭФФЕКТИВНОСТЬ';
    T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 4).Borders.Enable:=1;
    T.Columns.Width:=94;
    T.Rows.Alignment:=1;
    i:=0;
    While not fdb.ADOQuery111.Eof do
      begin
        T.Cell(i+2, 1).Range.Text := fdb.ADOQuery111.FieldByName('Start_Data').AsString;
        T.Cell(i+2, 1).Borders.Enable:=1;
        T.Cell(i+2, 2).Range.Text := fdb.ADOQuery111.FieldByName('CompleXity_Nazvanie').AsString;
        T.Cell(i+2, 2).Borders.Enable:=1;
        T.Cell(i+2, 2).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 3).Range.Text := fdb.ADOQuery111.FieldByName('Mark').AsString;
        T.Cell(i+2, 3).Borders.Enable:=1;
        if fdb.ADOQuery111.FieldByName('Mark').AsString='2' then
          T.Cell(i+2, 3).Range.Font.Color := clRed;;
        T.Cell(i+2, 3).Range.ParagraphFormat.alignment:=2;
        T.Cell(i+2, 4).Range.Text :=roundto(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
        T.Cell(i+2, 4).Borders.Enable:=1;
        T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=2;
        fdb.ADOQuery111.Next;
        i:=i+1;
      end;
  Word.Visible := True;
  Word.Activate;
  Word.WindowState:= 1;
end;


procedure ClassReport9;
var
 Word:variant;
 Doc:variant;
 S:variant;
 T:variant;
 i:integer;
begin
   try
    Word := CreateOleObject('Word.Application');
    Doc:=Word.Documents.Add;
  except
    ShowMessage('Не могу запустить Microsoft Word');
    exit;
  end;
    S:=Word.Selection;
    if not fdb.ADOQuery111.Active then
      fdb.ADOQuery111.close;
    fdb.ADOQuery111.sql.clear;
    fdb.ADOQuery111.sql.add('SELECT Users.User_Family AS Family, Users.User_Login AS Login, Groups.Nazvanie AS Groups, Results_Diag.Start_Data AS Start_Data, Results_Diag.Finish_Time AS Finish_Time,');
    fdb.ADOQuery111.sql.add('Results_Diag.Mark AS Mark, Results_Diag.Effect AS Effect, CompleXity.Nazvanie AS CompleXity_Nazvanie, QuestionTypes.Nazvanie AS QT_Nazvanie');
    fdb.ADOQuery111.sql.add('FROM Groups, Results_Diag, Users, CompleXity, Questions, QuestionTypes');
    fdb.ADOQuery111.sql.add('WHERE Users.Group_id=Groups.ID and Results_Diag.User_ID=Users.ID and Results_Diag.User_ID=:1 and Questions.CompleXity_Id=CompleXity.ID');
    fdb.ADOQuery111.sql.add('and Results_Diag.Question_ID=Questions.ID and Questions.QuestionType_ID=QuestionTypes.ID');
    fdb.ADOQuery111.sql.add('ORDER BY CompleXity.ID, QuestionTypes.ID, Results_DIag.Start_Data;');
    if fMainMenu.userId=0 then
      fMainMenu.userId:=fDB.ADOQuery190.Fields[0].AsInteger;
    fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQuery111.Open;
    fdb.ADOQuery111.First;
    S.Font.Size:=12;
    S.ParagraphFormat.Alignment:=0;
    S.TypeText('Дата печати: '+DateToStr(Date));
    S.TypeParagraph;
    S.ParagraphFormat.Alignment:=2;
    if AdminForm<>Nil then
      S.TypeText(fDB.ADOQuery190.FieldByName('User_Login').AsString+' '+fDB.ADOQuery190.FieldByName('User_Family').AsString+' '+fDB.ADOQuery190.FieldByName('Age').AsString+' лет '+fDB.ADOQuery190.FieldByName('Nazvanie').AsString+' класс')
    else
      S.TypeText(fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс');
    S.TypeParagraph;
    S.Font.Bold:=1;
    S.Font.Size:=16;
    S.ParagraphFormat.Alignment:=1;
    S.TypeText('Ведомость результатов по математике' +#13#10+'Диагностика');
    S.Font.Bold:=1;
    S.Font.Size:=14;
    S.ParagraphFormat.Alignment:=1;
    S.TypeParagraph;
    S.Font.Size:=14;

    S.ParagraphFormat.Alignment:=1;
    S.Font.Size:=12;
    T:=Doc.Tables.Add(Word.Selection.Range, fdb.ADOQuery111.RecordCount+1, 5);
    T.Rows.Alignment := 1;
    T.AutoFitBehavior(2);
    T.Cell(1, 1).Range.Text := 'ДАТА';
    T.Cell(1, 1).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 1).Borders.Enable:=1;
    T.Cell(1, 2).Range.Text := 'СЛОЖНОСТЬ';
    T.Cell(1, 2).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 2).Borders.Enable:=1;
    T.Cell(1, 3).Range.Text := 'ТИП ЗАДАЧИ';
    T.Cell(1, 3).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 3).Borders.Enable:=1;
    T.Cell(1, 4).Range.Text := 'ОЦЕНКА';
    T.Cell(1, 4).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 4).Borders.Enable:=1;
    T.Cell(1, 5).Range.Text := 'ЭФФЕКТИВНОСТЬ';
    T.Cell(1, 5).Range.ParagraphFormat.alignment:=1;
    T.Cell(1, 5).Borders.Enable:=1;

    T.Columns.Width:=94;
    T.Rows.Alignment:=1;
    i:=0; 
    While not fdb.ADOQuery111.Eof do
       begin
        T.Cell(i+2, 1).Range.Text := fdb.ADOQuery111.FieldByName('Start_Data').AsString;
        T.Cell(i+2, 1).Borders.Enable:=1;
        T.Cell(i+2, 2).Range.Text := fdb.ADOQuery111.FieldByName('CompleXity_Nazvanie').AsString;
        T.Cell(i+2, 2).Borders.Enable:=1;
        T.Cell(i+2, 2).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 3).Range.Text := fdb.ADOQuery111.FieldByName('QT_Nazvanie').AsString;
        T.Cell(i+2, 3).Borders.Enable:=1;
        T.Cell(i+2, 3).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 4).Range.Text := fdb.ADOQuery111.FieldByName('Mark').AsString;
        T.Cell(i+2, 4).Borders.Enable:=1;
        if fdb.ADOQuery111.FieldByName('Mark').AsString='2' then
          T.Cell(i+2, 4).Range.Font.Color := clRed;
        T.Cell(i+2, 4).Range.ParagraphFormat.alignment:=1;
        T.Cell(i+2, 5).Range.Text := roundto(fdb.ADOQuery111.FieldByName('Effect').AsFloat,-2);
        T.Cell(i+2, 5).Borders.Enable:=1;
        T.Cell(i+2, 5).Range.ParagraphFormat.alignment:=2;
        i:=i+1;
        fdb.ADOQuery111.Next;
        Word.Selection.EndKey(6, 0);
      end;
  Word.Visible := True;
  Word.Activate;
  Word.WindowState:= 1;
end;

end.
