unit ExportImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, ComCtrls, sListView, XMLIntf, sDialogs, EncdDecd,
  ComObj, ActiveX;

type
  TExportImportForm = class(TForm)
    sListView1: TsListView;
    sBitBtn2: TsBitBtn;
    sBitBtn1: TsBitBtn;
    sBitBtn3: TsBitBtn;
    sOpenDialog1: TsOpenDialog;
    sSaveDialog1: TsSaveDialog;
    sSaveDialog2: TsSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sListView1Click(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    Function Encode64(s:string):String;
    Function Decode64(s:string):String;
    function EncodeFile(FileName:string):string;
    function SaveFile(Buffer:string; var FileName:string):boolean;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportImportForm: TExportImportForm;

implementation

uses MyDB, DB;

{$R *.dfm}

procedure TExportImportForm.FormCreate(Sender: TObject);
begin
  fdb.ADOQuery223.Close;
  fdb.ADOQuery223.SQL.Clear;
  fdb.ADOQuery223.SQL.Add('SELECT ID, Nazvanie FROM Traject ORDER BY Nazvanie');
  fdb.ADOQuery223.Open;
  fdb.ADOQuery223.First;
  while not fdb.ADOQuery223.Eof do
    begin
      sListView1.AddItem(fdb.ADOQuery223.Fields[1].AsString, TObject(fdb.ADOQuery223.Fields[0].AsInteger));
      fdb.ADOQuery223.Next;
    end;
  if sListView1.Items.Count>0 then
    sListView1.SelectItem(0);
end;

procedure TExportImportForm.FormShow(Sender: TObject);
begin
  sListView1.SetFocus;
end;

function TExportImportForm.EncodeFile(FileName:string):string;
var
  content:string;
  f:TFileStream;
begin
  f:=TFileStream.Create(FileName, fmOpenRead);
  SetLength(content,f.Size);
  f.Read(content[1],f.Size);
  f.Free;
  result:=Encode64(content);
end;

function TExportImportForm.SaveFile(Buffer:string; var FileName:string):boolean;
var
  f:TFileStream;
  FileGUID:TGUID;
  Dir:string;
begin
  Dir:=ExtractFilePath(Application.ExeName)+ExtractFilePath(FileName);
  if not DirectoryExists(Dir) then
    begin
      if not ForceDirectories(Dir) then
        Dir:=ExtractFilePath(Application.ExeName);
    end;
  if FileExists(Dir+ExtractFileName(FileName)) then
    begin
      repeat
        CoCreateGuid(FileGUID);
        FileName:=Dir+GUIDToString(FileGUID)+ExtractFileExt(FileName);
      until not FileExists(FileName);
    end
  else
    FileName:=ExtractFilePath(Application.ExeName)+FileName;
  Screen.Cursor:=crAppStart;
  f:=TFileStream.Create(FileName, fmCreate);
  Buffer:=Decode64(VarToStr(Buffer));
  f.Write(Buffer[1],length(Buffer));
  f.Free;
  FileName:=StringReplace(FileName, ExtractFilePath(Application.ExeName),'', [rfReplaceAll, rfIgnoreCase]);
  Result:=true;
end;

procedure TExportImportForm.sBitBtn1Click(Sender: TObject);
var
XmlRoot,XmLCompleXitys, XmLCompleXity,XmLTrajects,XmLTraject,XmLLessons,XmLLesson,XmLQuestions,XmLQuestion, XmLAnswers:IXMLNode;
i,j,k,l,m,tablescount,ID_Traj,ID_Lesson,ID_Question,count1: integer;
text,temp:string;
MaxID_Theory:integer;
MaxID_TheoryHelp:integer;
MaxID_ConditionAudio:integer;
MaxID_ConditionVideo:integer;
MaxID_ConditionPhoto:integer;
MaxID_SolveAudio:integer;
MaxID_SolveVideo:integer;
MaxID_SolvePhoto:integer;
tempFileName:string;
IDCompleXity,IDQuestionTypes:integer;
CompleXity:TNodeType;
  begin
    if sOpenDialog1.Execute then
      begin
        if Application.MessageBox('Вы уверены, что хотите загрузить данную траекторию? ','Подтверждение',MB_YESNO)=IDYES then
          begin
            Screen.Cursor:=crAppStart;
            fdb.XMLDocument1.LoadFromFile(sOpenDialog1.FileName);
            fdb.XMLDocument1.Active:=true;
            fdb.XMLDocument1.Encoding:='UTF-8';
            fdb.XMLDocument1.LoadFromFile(sOpenDialog1.FileName);
            XmlRoot:=fdb.XMLDocument1.ChildNodes.FindNode('root');
            XmLTrajects:=XmlRoot.ChildNodes.FindNode('trajects');
            fdb.ADOConnection1.BeginTrans;
            try
              for i:=0 to XmLTrajects.ChildNodes.Count-1 do
                begin
                  XmLTraject:=XmLTrajects.ChildNodes[i];
                  {fdb.ADOQuery245.SQL.Clear;
                  fdb.ADOQuery245.SQL.Add('SELECT ID, Nazvanie, Question_Level FROM CompleXity WHERE Nazvanie=:1');
                  fdb.ADOQuery245.Parameters.ParamByName('1').Value:=VarToStr(XmlTraject.Attributes['CompleXity_Name']);
                  fdb.ADOQuery245.Open;
                  fdb.ADOQuery245.First;
                  if fdb.ADOQuery245.RecordCount=0 then
                    begin
                      fdb.ADOQuery68.SQL.Clear;
                      fdb.ADOQuery68.SQL.Add('INSERT INTO CompleXity(Nazvanie, Question_Level) VALUES(:1,:2)');
                      fdb.ADOQuery68.Parameters.ParamByName('1').Value:=VarToStr(XmlTraject.Attributes['CompleXity_Name']);
                      fdb.ADOQuery68.Parameters.ParamByName('2').Value:=VarToStr(XmlTraject.Attributes['CompleXity_QuestionLevel']);
                      fdb.ADOQuery68.ExecSQL;
                      fdb.ADOQuery68.SQL.Clear;
                      fdb.ADOQuery68.SQL.Add('SELECT MAX(ID) AS ID FROM CompleXity');
                      fdb.ADOQuery68.Open;
                      IDCompleXity:=fdb.ADOQuery68.FieldByName('ID').AsInteger;
                    end
                  else
                    IDCompleXity:=fdb.ADOQuery245.FieldByName('ID').AsInteger;}
                  fdb.ADOQuery227.SQL.Clear;
                  fdb.ADOQuery227.Sql.Add('INSERT INTO Traject(Nazvanie,Zoya_level) VALUES(:1,:2)');
                  fdb.ADOQuery227.Parameters.ParamByName('1').Value:=VarToStr(XmLTraject.Attributes['TrajectName']);
                  //fdb.ADOQuery227.Parameters.ParamByName('2').Value:=IDCompleXity;
                  fdb.ADOQuery227.Parameters.ParamByName('2').Value:=VarToStr(XmLTraject.Attributes['Class']);
                  fdb.ADOQuery227.ExecSQL;
                  fdb.ADOQuery227.SQL.Clear;
                  fdb.ADOQuery227.SQL.Add('SELECT MAX(ID) AS ID FROM Traject');
                  fdb.ADOQuery227.Open;
                  ID_Traj:=fdb.ADOQuery227.FieldByName('ID').AsInteger;
                  XmLLessons:=XmLTraject.ChildNodes.First;
                  for j:=0 to XmLLessons.ChildNodes.Count-1 do
                    begin
                      XmLLesson:=XmLLessons.ChildNodes[j];
                      fdb.ADOQuery228.SQL.Clear;
                      fdb.ADOQuery228.SQL.Add('INSERT INTO Lessons(Nazvanie,Control,TimeLeft) VALUES(:1,:2,:3)');
                      fdb.ADOQuery228.Parameters.ParamByName('1').Value:=VarToStr(XmLLesson.Attributes['LessonName']);
                      if VarToStr(XmLLesson.Attributes['Control'])='True' then
                        fdb.ADOQuery228.Parameters.ParamByName('2').Value:=1
                      else
                        fdb.ADOQuery228.Parameters.ParamByName('2').Value:=0;
                      fdb.ADOQuery228.Parameters.ParamByName('3').Value:=VarToStr(XmLLesson.Attributes['TimeLeft']);
                      fdb.ADOQuery228.ExecSQL;
                      fdb.ADOQuery228.SQL.Clear;
                      fdb.ADOQuery228.SQL.Add('SELECT MAX(ID) AS ID FROM Lessons');
                      fdb.ADOQuery228.Open;
                      ID_Lesson:=fdb.ADOQuery228.FieldByName('ID').AsInteger;
                      fdb.ADOQuery228.SQL.Clear;
                      fdb.ADOQuery228.SQL.Add('INSERT INTO TrajectLessons(Traject_ID,Lessons_ID) VALUES(:1,:2)');
                      fdb.ADOQuery228.Parameters.ParamByName('1').Value:=ID_Traj;
                      fdb.ADOQuery228.Parameters.ParamByName('2').Value:=ID_Lesson;
                      fdb.ADOQuery228.ExecSQL;
                      XmLQuestions:=XmLLesson.ChildNodes.First;
                      for k:=0 to XmLQuestions.ChildNodes.Count-1 do
                        begin
                          XmLQuestion:=XmLQuestions.ChildNodes[k];
                          fdb.ADOQuery245.SQL.Clear;
                          fdb.ADOQuery245.SQL.Add('SELECT ID, Nazvanie, Question_Level FROM CompleXity WHERE Nazvanie=:1');
                          fdb.ADOQuery245.Parameters.ParamByName('1').Value:=VarToStr(XmLQuestion.Attributes['CompleXity_Name']);
                          fdb.ADOQuery245.Open;
                          fdb.ADOQuery245.First;
                          if fdb.ADOQuery245.RecordCount=0 then
                            begin
                              fdb.ADOQuery68.SQL.Clear;
                              fdb.ADOQuery68.SQL.Add('INSERT INTO CompleXity(Nazvanie, Question_Level) VALUES(:1,:2)');
                              fdb.ADOQuery68.Parameters.ParamByName('1').Value:=VarToStr(XmLQuestion.Attributes['CompleXity_Name']);
                              fdb.ADOQuery68.Parameters.ParamByName('2').Value:=VarToStr(XmLQuestion.Attributes['CompleXity_QuestionLevel']);
                              fdb.ADOQuery68.ExecSQL;
                              fdb.ADOQuery68.SQL.Clear;
                              fdb.ADOQuery68.SQL.Add('SELECT MAX(ID) AS ID FROM CompleXity');
                              fdb.ADOQuery68.Open;
                              IDCompleXity:=fdb.ADOQuery68.FieldByName('ID').AsInteger;
                            end
                        else
                          IDCompleXity:=fdb.ADOQuery245.FieldByName('ID').AsInteger;



                          fdb.ADOQuery229.SQL.Clear;
                          fdb.ADOQuery229.SQL.Add('INSERT INTO Questions(Nazvanie, QuestionType_ID, AnswerType, ConditionAudio_Id, ConditionVideo_Id, ConditionPhoto_Id, SolveAudio_Id, SolveVideo_Id, SolvePhoto_Id, Theory_ID, TheoryHelp_ID, WorkType, CompleXity_ID)');
                          fdb.ADOQuery229.SQL.Add('VALUES(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13)');
                          fdb.ADOQuery229.Parameters.ParamByName('1').Value:=VarToStr(XmLQuestion.Attributes['QuestionName']);
                          fdb.ADOQuery69.SQL.Clear;
                          fdb.ADOQuery69.SQL.Add('SELECT ID, Nazvanie FROM QuestionTypes WHERE Nazvanie=:1');
                          fdb.ADOQuery69.Parameters.ParamByName('1').Value:=VarToStr(XmLQuestion.Attributes['QuestionType_Name']);
                          fdb.ADOQuery69.Open;
                          fdb.ADOQuery69.First;
                          if fdb.ADOQuery69.RecordCount=0 then
                            begin
                              fdb.ADOQuery69.SQL.Clear;
                              fdb.ADOQuery69.SQL.Add('INSERT INTO QuestionTypes(Nazvanie) VALUES(:1)');
                              fdb.ADOQuery69.Parameters.ParamByName('1').Value:=VarToStr(XmLQuestion.Attributes['QuestionType_Name']);
                              fdb.ADOQuery69.ExecSQL;
                              fdb.ADOQuery69.SQL.Clear;
                              fdb.ADOQuery69.SQL.Add('SELECT MAX(ID) AS ID FROM QuestionTypes');
                              fdb.ADOQuery69.Open;
                              IDQuestionTypes:=fdb.ADOQuery69.FieldByName('ID').AsInteger;
                            end
                          else
                            IDQuestionTypes:=fdb.ADOQuery69.FieldByName('ID').AsInteger;
                          fdb.ADOQuery229.Parameters.ParamByName('2').Value:=IDQuestionTypes;
                          fdb.ADOQuery229.Parameters.ParamByName('3').Value:=VarToStr(XmLQuestion.Attributes['AnswerType']);
                          if (VarToStr(XmLQuestion.Attributes['ConditionAudio'])<>'') and (VarToStr(XmLQuestion.Attributes['Path_ConditionAudio'])<>'') then
                            begin
                              tempFileName:=VarToStr(XmLQuestion.Attributes['Path_ConditionAudio']);
                              if SaveFile(VarToStr(XmLQuestion.Attributes['ConditionAudio']),tempFileName) then
                                begin
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('INSERT INTO Multim(Soderjanie, Type) VALUES(:1,:2)');
                                  fdb.ADOQuery244.Parameters.ParamByName('1').Value:=tempFileName;
                                  fdb.ADOQuery244.Parameters.ParamByName('2').Value:=1;
                                  fdb.ADOQuery244.ExecSQL;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('SELECT MAX(ID) AS MAX_ID FROM Multim');
                                  fdb.ADOQuery244.Open;
                                  fdb.ADOQuery244.First;
                                  MaxID_ConditionAudio:=fdb.ADOQuery244.FieldByName('MAX_ID').AsInteger;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery229.Parameters.ParamByName('4').Value:=MaxID_ConditionAudio;
                                end
                              else
                                raise Exception.Create('Импорт прерван.');
                            end;
                          if (VarToStr(XmLQuestion.Attributes['ConditionVideo'])<>'') and (VarToStr(XmLQuestion.Attributes['Path_ConditionVideo'])<>'') then
                            begin
                              tempFileName:=VarToStr(XmLQuestion.Attributes['Path_ConditionVideo']);
                              if SaveFile(VarToStr(XmLQuestion.Attributes['ConditionVideo']),tempFileName) then
                                begin
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('INSERT INTO Multim(Soderjanie, Type) VALUES(:1,:2)');
                                  fdb.ADOQuery244.Parameters.ParamByName('1').Value:=tempFileName;
                                  fdb.ADOQuery244.Parameters.ParamByName('2').Value:=2;
                                  fdb.ADOQuery244.ExecSQL;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('SELECT MAX(ID) AS MAX_ID FROM Multim');
                                  fdb.ADOQuery244.Open;
                                  fdb.ADOQuery244.First;
                                  MaxID_ConditionVideo:=fdb.ADOQuery244.FieldByName('MAX_ID').AsInteger;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery229.Parameters.ParamByName('5').Value:=MaxID_ConditionVideo;
                                end
                              else
                                raise Exception.Create('Импорт прерван.');
                            end;
                          if (VarToStr(XmLQuestion.Attributes['ConditionPhoto'])<>'') and (VarToStr(XmLQuestion.Attributes['Path_ConditionPhoto'])<>'') then
                            begin
                              tempFileName:=VarToStr(XmLQuestion.Attributes['Path_ConditionPhoto']);
                              if SaveFile(VarToStr(XmLQuestion.Attributes['ConditionPhoto']),tempFileName) then
                                begin
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('INSERT INTO Multim(Soderjanie, Type) VALUES(:1,:2)');
                                  fdb.ADOQuery244.Parameters.ParamByName('1').Value:=tempFileName;
                                  fdb.ADOQuery244.Parameters.ParamByName('2').Value:=3;
                                  fdb.ADOQuery244.ExecSQL;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('SELECT MAX(ID) AS MAX_ID FROM Multim');
                                  fdb.ADOQuery244.Open;
                                  fdb.ADOQuery244.First;
                                  MaxID_ConditionPhoto:=fdb.ADOQuery244.FieldByName('MAX_ID').AsInteger;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery229.Parameters.ParamByName('6').Value:=MaxID_ConditionPhoto;
                                end
                              else
                                raise Exception.Create('Импорт прерван.');
                            end;
                          if (VarToStr(XmLQuestion.Attributes['SolveAudio'])<>'') and (VarToStr(XmLQuestion.Attributes['Path_SolveAudio'])<>'') then
                            begin
                              tempFileName:=VarToStr(XmLQuestion.Attributes['Path_SolveAudio']);
                              if SaveFile(VarToStr(XmLQuestion.Attributes['SolveAudio']),tempFileName) then
                                begin
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('INSERT INTO Multim(Soderjanie, Type) VALUES(:1,:2)');
                                  fdb.ADOQuery244.Parameters.ParamByName('1').Value:=tempFileName;
                                  fdb.ADOQuery244.Parameters.ParamByName('2').Value:=1;
                                  fdb.ADOQuery244.ExecSQL;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('SELECT MAX(ID) AS MAX_ID FROM Multim');
                                  fdb.ADOQuery244.Open;
                                  fdb.ADOQuery244.First;
                                  MaxID_SolveAudio:=fdb.ADOQuery244.FieldByName('MAX_ID').AsInteger;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery229.Parameters.ParamByName('7').Value:=MaxID_SolveAudio;
                                end
                              else
                                raise Exception.Create('Импорт прерван.');
                            end;
                          if (VarToStr(XmLQuestion.Attributes['SolveVideo'])<>'') and (VarToStr(XmLQuestion.Attributes['Path_SolveVideo'])<>'') then
                            begin
                              tempFileName:=VarToStr(XmLQuestion.Attributes['Path_SolveVideo']);
                              if SaveFile(VarToStr(XmLQuestion.Attributes['SolveVideo']),tempFileName) then
                                begin
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('INSERT INTO Multim(Soderjanie, Type) VALUES(:1,:2)');
                                  fdb.ADOQuery244.Parameters.ParamByName('1').Value:=tempFileName;
                                  fdb.ADOQuery244.Parameters.ParamByName('2').Value:=2;
                                  fdb.ADOQuery244.ExecSQL;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('SELECT MAX(ID) AS MAX_ID FROM Multim');
                                  fdb.ADOQuery244.Open;
                                  fdb.ADOQuery244.First;
                                  MaxID_SolveVideo:=fdb.ADOQuery244.FieldByName('MAX_ID').AsInteger;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery229.Parameters.ParamByName('8').Value:=MaxID_SolveVideo;
                                end
                              else
                                raise Exception.Create('Импорт прерван.');
                            end;
                          if (VarToStr(XmLQuestion.Attributes['SolvePhoto'])<>'') and (VarToStr(XmLQuestion.Attributes['Path_SolvePhoto'])<>'') then
                            begin
                              tempFileName:=VarToStr(XmLQuestion.Attributes['Path_SolvePhoto']);
                              if SaveFile(VarToStr(XmLQuestion.Attributes['SolvePhoto']),tempFileName) then
                                begin
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('INSERT INTO Multim(Soderjanie, Type) VALUES(:1,:2)');
                                  fdb.ADOQuery244.Parameters.ParamByName('1').Value:=tempFileName;
                                  fdb.ADOQuery244.Parameters.ParamByName('2').Value:=3;
                                  fdb.ADOQuery244.ExecSQL;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('SELECT MAX(ID) AS MAX_ID FROM Multim');
                                  fdb.ADOQuery244.Open;
                                  fdb.ADOQuery244.First;
                                  MaxID_SolvePhoto:=fdb.ADOQuery244.FieldByName('MAX_ID').AsInteger;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery229.Parameters.ParamByName('9').Value:=MaxID_SolvePhoto;
                                end
                              else
                                raise Exception.Create('Импорт прерван.');
                            end;
                          if (VarToStr(XmLQuestion.Attributes['Theory'])<>'') and (VarToStr(XmLQuestion.Attributes['Path_Theory'])<>'') then
                            begin
                              tempFileName:=VarToStr(XmLQuestion.Attributes['Path_Theory']);
                              if SaveFile(VarToStr(XmLQuestion.Attributes['Theory']),tempFileName) then
                                begin
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('INSERT INTO Multim(Soderjanie, Type) VALUES(:1,:2)');
                                  fdb.ADOQuery244.Parameters.ParamByName('1').Value:=tempFileName;
                                  fdb.ADOQuery244.Parameters.ParamByName('2').Value:=4;
                                  fdb.ADOQuery244.ExecSQL;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('SELECT MAX(ID) AS MAX_ID FROM Multim');
                                  fdb.ADOQuery244.Open;
                                  fdb.ADOQuery244.First;
                                  MaxID_Theory:=fdb.ADOQuery244.FieldByName('MAX_ID').AsInteger;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery229.Parameters.ParamByName('10').Value:=MaxID_Theory;
                                end
                              else
                                raise Exception.Create('Импорт прерван.');
                            end;
                          if (VarToStr(XmLQuestion.Attributes['TheoryHelp'])<>'') and (VarToStr(XmLQuestion.Attributes['Path_TheoryHelp'])<>'') then
                            begin
                              tempFileName:=VarToStr(XmLQuestion.Attributes['Path_TheoryHelp']);
                              if SaveFile(VarToStr(XmLQuestion.Attributes['TheoryHelp']),tempFileName) then
                                begin
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('INSERT INTO Multim(Soderjanie, Type) VALUES(:1,:2)');
                                  fdb.ADOQuery244.Parameters.ParamByName('1').Value:=tempFileName;
                                  fdb.ADOQuery244.Parameters.ParamByName('2').Value:=4;
                                  fdb.ADOQuery244.ExecSQL;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery244.SQL.Clear;
                                  fdb.ADOQuery244.SQL.Add('SELECT MAX(ID) AS MAX_ID FROM Multim');
                                  fdb.ADOQuery244.Open;
                                  fdb.ADOQuery244.First;
                                  MaxID_TheoryHelp:=fdb.ADOQuery244.FieldByName('MAX_ID').AsInteger;
                                  fdb.ADOQuery244.Close;
                                  fdb.ADOQuery229.Parameters.ParamByName('11').Value:=MaxID_TheoryHelp;
                                end
                              else
                                raise Exception.Create('Импорт прерван.');
                            end;
                          fdb.ADOQuery229.Parameters.ParamByName('12').Value:=VarToStr(XmLQuestion.Attributes['WorkType']);
                          fdb.ADOQuery229.Parameters.ParamByName('13').Value:=IDCompleXity;
                          fdb.ADOQuery229.ExecSQL;
                          fdb.ADOQuery229.SQL.Clear;
                          fdb.ADOQuery229.SQL.Add('SELECT MAX(ID) AS ID FROM Questions');
                          fdb.ADOQuery229.Open;
                          ID_Question:=fdb.ADOQuery229.FieldByName('ID').AsInteger;
                          fdb.ADOQuery229.SQL.Clear;
                          fdb.ADOQuery229.SQL.Add('INSERT INTO LessonsQuestions(Lesson_ID, Question_ID) VALUES(:1,:2)');
                          fdb.ADOQuery229.Parameters.ParamByName('1').Value:=ID_Lesson;
                          fdb.ADOQuery229.Parameters.ParamByName('2').Value:=ID_Question;
                          fdb.ADOQuery229.ExecSQL;
                          XmLAnswers:=XmLQuestion.ChildNodes.First;
                          for l:=0 to XmLQuestion.ChildNodes.Count-1 do
                            begin
                              XmLAnswers:=XmLQuestion.ChildNodes[l];
                              fdb.ADOQuery230.SQL.Clear;
                              fdb.ADOQuery230.SQL.Add('INSERT INTO Answers(Nazvanie, Question_ID, Righted, Picture) VALUES(:1,:2,:3,:4)');
                              fdb.ADOQuery230.Parameters.ParamByName('1').Value:=VarToStr(XmLAnswers.Attributes['AnswerName']);
                              fdb.ADOQuery230.Parameters.ParamByName('2').Value:=ID_Question;
                              if VarToStr(XmLAnswers.Attributes['Answer_righted'])='True' then
                                fdb.ADOQuery230.Parameters.ParamByName('3').Value:=1
                              else
                                fdb.ADOQuery230.Parameters.ParamByName('3').Value:=0;
                              if (VarToStr(XmLAnswers.Attributes['Answer_picture'])<>'') and (VarToStr(XmLAnswers.Attributes['Path_AnswerPicture'])<>'') then
                                begin
                                  tempFileName:=VarToStr(XmLAnswers.Attributes['Path_AnswerPicture']);
                                    if SaveFile(VarToStr(XmLAnswers.Attributes['Answer_picture']),tempFileName) then
                                      fdb.ADOQuery230.Parameters.ParamByName('4').Value:=tempFileName;
                                end;
                              fdb.ADOQuery230.ExecSQL;
                            end;
                        end;
                    end;
                end;
            except
              on e:EOleException do
                begin
                  fdb.ADOConnection1.RollbackTrans;
                  Application.MessageBox('В файле найдены дублирующиеся записи базы данных.'+#13#10+'Импорт прерван.','Ошибка');
                  Screen.Cursor:=crDefault;
                  exit;
                end;
              on e:Exception do
                begin
                  fdb.ADOConnection1.RollbackTrans;
                  Application.MessageBox('Импорт прерван.','Ошибка');
                  Screen.Cursor:=crDefault;
                  exit;
                end;
            end;
            fdb.ADOConnection1.CommitTrans;
            sListView1.Items.Clear;
            fdb.ADOQuery223.Close;
            fdb.ADOQuery223.SQL.Clear;
            fdb.ADOQuery223.SQL.Add('SELECT ID, Nazvanie FROM Traject ORDER BY Nazvanie');
            fdb.ADOQuery223.Open;
            fdb.ADOQuery223.First;
            while not fdb.ADOQuery223.Eof do
              begin
                sListView1.AddItem(fdb.ADOQuery223.Fields[1].AsString, TObject(fdb.ADOQuery223.Fields[0].AsInteger));
                fdb.ADOQuery223.Next;
              end;
            if sListView1.Items.Count>0 then
              sListView1.SelectItem(0);
            fdb.XMLDocument1.Active:=false;
            showmessage('Траектория импортирована.');
            Screen.Cursor:=crDefault;
          end;
      end;
  end;


procedure TExportImportForm.sBitBtn2Click(Sender: TObject);
var
  sum,count1,count2,count3,i:integer;
  nodeRoot,nodeCompleXity,nodeTrajects,nodeTraject,nodeLessons,nodeLesson,nodeQuestions,nodeQuestion,nodeAnswer:IXMLNode;
  f:TFileStream;
  Theory,TheoryHelp,answer_picture,ConditionAudio,ConditionVideo,ConditionPhoto,SolveAudio,SolveVideo,SolvePhoto:string;
begin
  sum:=0;
  for i:=0 to sListView1.Items.Count-1 do
    begin
      if sListView1.Items[i].Checked then
        sum:=sum+1;
    end;
  if sum=0 then
    begin
      showmessage('Не выбрана ни одна траектория для экспорта.');
      exit;
    end;
   sSaveDialog1.InitialDir:=Extractfilepath(application.ExeName);
   if sSaveDialog1.Execute then
    begin
      Screen.Cursor:=crAppStart;
      if fdb.XMLDocument1.Active then
        fdb.XMLDocument1.Active:=False;
      fdb.XMLDocument2.Active:=True;
      fdb.XMLDocument2.Encoding:='UTF-8';
      nodeRoot:=fdb.XMLDocument2.AddChild('root');
      nodeRoot.Attributes['version']:='1.0';
      nodeTrajects:=nodeRoot.AddChild('trajects');
      sum:=1;
      for i:=0 to sListView1.Items.Count-1 do
        begin
          if sListView1.Items[i].Checked then
            begin
              nodeTraject:=nodeTrajects.AddChild('traject');
              nodeTraject.Attributes['ID']:=sum;
              nodeTraject.Attributes['TrajectName']:=sListView1.Items[i].Caption;
              fdb.ADOQuery223.SQL.Clear;
              //fdb.ADOQuery223.SQL.Add('SELECT T.ID, T.Nazvanie, T.CompleXity_ID AS T_CompleXityID , T.Zoya_level AS T_ZoyaLevel, CX.Nazvanie AS CX_Nazvanie, CX.Question_Level AS CX_QuestionLevel FROM Traject AS T, CompleXity AS CX WHERE T.CompleXity_ID=CX.ID AND T.ID=:1 ORDER BY T.Nazvanie');
              fdb.ADOQuery223.SQL.Add('SELECT T.ID, T.Nazvanie, T.Zoya_level AS T_ZoyaLevel FROM Traject AS T WHERE T.ID=:1 ORDER BY T.Nazvanie');
              fdb.ADOQuery223.Parameters.ParamByName('1').Value:=Integer(sListView1.Items[i].Data);
              fdb.ADOQuery223.Open;
              fdb.ADOQuery223.First;
              //nodeTraject.Attributes['CompleXity_ID']:=fdb.ADOQuery223.FieldByName('T_CompleXityID').AsString;
              nodeTraject.Attributes['Class']:=fdb.ADOQuery223.FieldByName('T_ZoyaLevel').AsString;
              //nodeTraject.Attributes['CompleXity_Name']:=fdb.ADOQuery223.FieldByName('CX_Nazvanie').AsString;
              //nodeTraject.Attributes['CompleXity_QuestionLevel']:=fdb.ADOQuery223.FieldByName('CX_QuestionLevel').AsString;
              if fdb.ADOQuery223.RecordCount=0 then
                begin
                  showmessage('Запись не найдена');
                  exit;
                end;
              nodeLessons:=nodeTraject.AddChild('lessons');
              fdb.ADOQuery224.SQL.Clear;
              fdb.ADOQuery224.SQL.Add('SELECT L.ID AS L_ID, L.Nazvanie AS L_Nazvanie, L.Control AS L_Control, L.TimeLeft AS TimeLeft FROM Lessons AS L, TrajectLessons AS TL, Traject AS T WHERE T.ID=TL.Traject_ID AND TL.Lessons_ID=L.ID AND T.ID=:1');
              fdb.ADOQuery224.Parameters.ParamByName('1').Value:=Integer(sListView1.Items[i].Data);
              fdb.ADOQuery224.Open;
              fdb.ADOQuery224.First;
              count1:=1;
              while not fdb.ADOQuery224.Eof do
                begin
                  nodeLesson:=nodeLessons.AddChild('lesson');
                  nodeLesson.Attributes['ID']:=count1;
                  nodeLesson.Attributes['LessonName']:=fdb.ADOQuery224.FieldByName('L_Nazvanie').AsString;
                  nodeLesson.Attributes['Control']:=fdb.ADOQuery224.FieldByName('L_Control').AsString;
                  nodeLesson.Attributes['TimeLeft']:=fdb.ADOQuery224.FieldByName('TimeLeft').AsInteger;
                  nodeQuestions:=nodeLesson.AddChild('questions');
                  fdb.ADOQuery225.SQL.Clear;
                  fdb.ADOQuery225.SQL.Add('SELECT Q.ID AS Q_ID, Q.Nazvanie AS Q_Nazvanie, Q.QuestionType_ID AS Q_QuestionTypeID, Q.CompleXity_Id AS Q_CompleXityID, Q.AnswerType AS Q_AnswerType, QT.Nazvanie AS QT_Nazvanie,');
                  fdb.ADOQuery225.SQL.Add('CX.Nazvanie AS CX_Nazvanie, CX.Question_Level AS CX_QuestionLevel, Q.ConditionAudio_ID AS ConditionAudio_ID, Q.ConditionVideo_ID AS ConditionVideo_ID, Q.ConditionPhoto_ID AS ConditionPhoto_ID,');
                  fdb.ADOQuery225.SQL.Add('Q.SolveAudio_ID AS SolveAudio_ID, Q.SolveVideo_ID AS SolveVideo_ID, Q.SolvePhoto_ID AS SolvePhoto_ID, Q.Theory_ID AS Theory_ID, Q.TheoryHelp_ID AS TheoryHelp_ID, Q.WorkType AS WorkType');
                  fdb.ADOQuery225.SQL.Add('FROM Lessons AS L, TrajectLessons AS TL, Traject AS T, LessonsQuestions AS LQ, Questions AS Q, QuestionTypes AS QT, CompleXity AS CX');
                  fdb.ADOQuery225.SQL.Add('WHERE T.ID=TL.Traject_ID AND TL.Lessons_ID=L.ID AND L.ID=LQ.Lesson_ID AND LQ.Question_ID=Q.ID AND Q.QuestionType_ID=QT.ID AND Q.CompleXity_ID=CX.ID AND L.ID=:1 AND T.ID=:2');
                  fdb.ADOQuery225.Parameters.ParamByName('1').Value:=fdb.ADOQuery224.FieldByName('L_ID').AsInteger;
                  fdb.ADOQuery225.Parameters.ParamByName('2').Value:=Integer(sListView1.Items[i].Data);
                  fdb.ADOQuery225.Open;
                  fdb.ADOQuery225.First;
                  fdb.ADOQuery231.SQL.Clear;
                  fdb.ADOQuery231.SQL.Add('SELECT Soderjanie, Type FROM Multim WHERE ID=:1 AND Type=1');
                  fdb.ADOQuery231.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('ConditionAudio_ID').AsString;
                  fdb.ADOQuery231.Open;
                  fdb.ADOQuery231.First;
                  fdb.ADOQuery232.SQL.Clear;
                  fdb.ADOQuery232.SQL.Add('SELECT Soderjanie, Type FROM Multim WHERE ID=:1 AND Type=2');
                  fdb.ADOQuery232.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('ConditionVideo_ID').AsString;
                  fdb.ADOQuery232.Open;
                  fdb.ADOQuery232.First;
                  fdb.ADOQuery233.SQL.Clear;
                  fdb.ADOQuery233.SQL.Add('SELECT Soderjanie, Type FROM Multim WHERE ID=:1 AND Type=3');
                  fdb.ADOQuery233.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('ConditionPhoto_ID').AsString;
                  fdb.ADOQuery233.Open;
                  fdb.ADOQuery233.First;
                  fdb.ADOQuery234.SQL.Clear;
                  fdb.ADOQuery234.SQL.Add('SELECT Soderjanie, Type FROM Multim WHERE ID=:1 AND Type=1');
                  fdb.ADOQuery234.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('SolveAudio_ID').AsString;
                  fdb.ADOQuery234.Open;
                  fdb.ADOQuery234.First;
                  fdb.ADOQuery235.SQL.Clear;
                  fdb.ADOQuery235.SQL.Add('SELECT Soderjanie, Type FROM Multim WHERE ID=:1 AND Type=2');
                  fdb.ADOQuery235.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('SolveVideo_ID').AsString;
                  fdb.ADOQuery235.Open;
                  fdb.ADOQuery235.First;
                  fdb.ADOQuery236.SQL.Clear;
                  fdb.ADOQuery236.SQL.Add('SELECT Soderjanie, Type FROM Multim WHERE ID=:1 AND Type=3');
                  fdb.ADOQuery236.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('SolvePhoto_ID').AsString;
                  fdb.ADOQuery236.Open;
                  fdb.ADOQuery236.First;
                  fdb.ADOQuery239.SQL.Clear;
                  fdb.ADOQuery239.SQL.Add('SELECT Soderjanie, Type FROM Multim WHERE ID=:1 AND Type=4');
                  fdb.ADOQuery239.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('Theory_ID').AsString;
                  fdb.ADOQuery239.Open;
                  fdb.ADOQuery239.First;
                  fdb.ADOQuery240.SQL.Clear;
                  fdb.ADOQuery240.SQL.Add('SELECT Soderjanie, Type FROM Multim WHERE ID=:1 AND Type=4');
                  fdb.ADOQuery240.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('TheoryHelp_ID').AsString;
                  fdb.ADOQuery240.Open;
                  fdb.ADOQuery240.First;
                  count2:=1;
                  while not fdb.ADOQuery225.Eof do
                    begin
                      nodeQuestion:=nodeQuestions.AddChild('question');
                      nodeQuestion.Attributes['ID']:=count2;
                      nodeQuestion.Attributes['QuestionName']:=fdb.ADOQuery225.FieldByName('Q_Nazvanie').AsString;
                      nodeQuestion.Attributes['QuestionType_ID']:=fdb.ADOQuery225.FieldByName('Q_QuestionTypeID').AsString;
                      nodeQuestion.Attributes['QuestionType_Name']:=fdb.ADOQuery225.FieldByName('QT_Nazvanie').AsString;
                      nodeQuestion.Attributes['CompleXity_ID']:=fdb.ADOQuery225.FieldByName('Q_CompleXityID').AsString;
                      nodeQuestion.Attributes['CompleXity_Name']:=fdb.ADOQuery225.FieldByName('CX_Nazvanie').AsString;
                      nodeQuestion.Attributes['CompleXity_QuestionLevel']:=fdb.ADOQuery225.FieldByName('CX_QuestionLevel').AsString;
                      nodeQuestion.Attributes['AnswerType']:=fdb.ADOQuery225.FieldByName('Q_AnswerType').AsString;
                      nodeQuestion.Attributes['WorkType']:=fdb.ADOQuery225.FieldByName('WorkType').AsInteger;
                      if fdb.ADOQuery225.FieldByName('ConditionAudio_ID').AsString<>'' then
                        begin
                          ConditionAudio:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery231.FieldByName('Soderjanie').AsString);
                          nodeQuestion.Attributes['Path_ConditionAudio']:=fdb.ADOQuery231.FieldByName('Soderjanie').AsString;
                          nodeQuestion.Attributes['ConditionAudio']:=ConditionAudio;
                        end
                      else
                         nodeQuestion.Attributes['ConditionAudio']:='ConditionAudio is not added';
                      if fdb.ADOQuery225.FieldByName('ConditionVideo_ID').AsString<>'' then
                        begin
                          ConditionVideo:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery232.FieldByName('Soderjanie').AsString);
                          nodeQuestion.Attributes['Path_ConditionVideo']:=fdb.ADOQuery232.FieldByName('Soderjanie').AsString;
                          nodeQuestion.Attributes['ConditionVideo']:=ConditionVideo;
                        end
                      else
                         nodeQuestion.Attributes['ConditionVideo']:='ConditionVideo is not added';
                      if fdb.ADOQuery225.FieldByName('ConditionPhoto_ID').AsString<>'' then
                        begin
                          ConditionPhoto:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery233.FieldByName('Soderjanie').AsString);
                          nodeQuestion.Attributes['Path_ConditionPhoto']:=fdb.ADOQuery233.FieldByName('Soderjanie').AsString;
                          nodeQuestion.Attributes['ConditionPhoto']:=ConditionPhoto;
                        end
                      else
                         nodeQuestion.Attributes['ConditionPhoto']:='ConditionPhoto is not added';
                      if fdb.ADOQuery225.FieldByName('SolveAudio_ID').AsString<>'' then
                        begin
                          SolveAudio:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery234.FieldByName('Soderjanie').AsString);
                          nodeQuestion.Attributes['Path_SolveAudio']:=fdb.ADOQuery234.FieldByName('Soderjanie').AsString;
                          nodeQuestion.Attributes['SolveAudio']:=SolveAudio;
                        end
                      else
                         nodeQuestion.Attributes['SolveAudio']:='SolveAudio is not added';
                      if fdb.ADOQuery225.FieldByName('SolveVideo_ID').AsString<>'' then
                        begin
                          SolveVideo:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery235.FieldByName('Soderjanie').AsString);
                          nodeQuestion.Attributes['Path_SolveVideo']:=fdb.ADOQuery235.FieldByName('Soderjanie').AsString;
                          nodeQuestion.Attributes['SolveVideo']:=SolveVideo;
                        end
                      else
                         nodeQuestion.Attributes['SolveVideo']:='SolveVideo is not added';
                      if fdb.ADOQuery225.FieldByName('SolvePhoto_ID').AsString<>'' then
                        begin
                          SolvePhoto:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery236.FieldByName('Soderjanie').AsString);
                          nodeQuestion.Attributes['Path_SolvePhoto']:=fdb.ADOQuery236.FieldByName('Soderjanie').AsString;
                          nodeQuestion.Attributes['SolvePhoto']:=SolvePhoto;
                        end
                      else
                         nodeQuestion.Attributes['SolvePhoto']:='SolvePhoto is not added';
                      if fdb.ADOQuery225.FieldByName('Theory_ID').AsString<>'' then
                        begin
                          Theory:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery239.FieldByName('Soderjanie').AsString);
                          nodeQuestion.Attributes['Path_Theory']:=fdb.ADOQuery239.FieldByName('Soderjanie').AsString;
                          nodeQuestion.Attributes['Theory']:=Theory;
                        end
                      else
                         nodeQuestion.Attributes['Theory']:='Theory is not added';
                      if fdb.ADOQuery225.FieldByName('TheoryHelp_ID').AsString<>'' then
                        begin
                          TheoryHelp:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery240.FieldByName('Soderjanie').AsString);
                          nodeQuestion.Attributes['Path_TheoryHelp']:=fdb.ADOQuery240.FieldByName('Soderjanie').AsString;
                          nodeQuestion.Attributes['TheoryHelp']:=TheoryHelp;
                        end
                      else
                         nodeQuestion.Attributes['TheoryHelp']:='Theory_help is not added';
                      fdb.ADOQuery226.SQL.Clear;
                      fdb.ADOQuery226.SQL.Add('SELECT A.ID, A.Nazvanie AS A_Nazvanie, A.Question_ID AS A_QuestionID, A.Righted AS A_Righted, A.Picture AS A_Picture FROM Lessons AS L, TrajectLessons AS TL, Traject AS T, LessonsQuestions AS LQ, Questions AS Q, Answers AS A ');
                      fdb.ADOQuery226.SQL.Add('WHERE T.ID=TL.Traject_ID AND TL.Lessons_ID=L.ID AND L.ID=LQ.Lesson_ID AND LQ.Question_ID=Q.ID AND Q.ID=A.Question_ID AND Q.ID=:1 AND T.ID=:2');
                      fdb.ADOQuery226.Parameters.ParamByName('1').Value:=fdb.ADOQuery225.FieldByName('Q_ID').AsString;
                      fdb.ADOQuery226.Parameters.ParamByName('2').Value:=Integer(sListView1.Items[i].Data);
                      fdb.ADOQuery226.Open;
                      fdb.ADOQuery226.First;
                      count3:=1;
                      while not fdb.ADOQuery226.Eof do
                        begin
                          nodeAnswer:=nodeQuestion.AddChild('answer');
                          nodeAnswer.Attributes['ID']:=count3;
                          nodeAnswer.Attributes['AnswerName']:=fdb.ADOQuery226.FieldByName('A_Nazvanie').AsString;
                          nodeAnswer.Attributes['Answer_righted']:=fdb.ADOQuery226.FieldByName('A_Righted').AsString;
                          if fdb.ADOQuery226.FieldByName('A_Picture').AsString<>'' then
                            begin
                              answer_picture:=EncodeFile(ExtractFilePath(Application.ExeName)+fdb.ADOQuery226.FieldByName('A_Picture').AsString);
                              nodeAnswer.Attributes['Path_AnswerPicture']:=fdb.ADOQuery226.FieldByName('A_Picture').AsString;
                              nodeAnswer.Attributes['Answer_picture']:=answer_picture;
                            end
                          else
                            nodeAnswer.Attributes['Answer_picture']:='Answer_picture is not added';
                          count3:=count3+1;
                          fdb.ADOQuery226.Next;
                        end;
                      count2:=count2+1;
                      fdb.ADOQuery225.Next;
                      fdb.ADOQuery231.Next;
                      fdb.ADOQuery232.Next;
                      fdb.ADOQuery233.Next;
                      fdb.ADOQuery234.Next;
                      fdb.ADOQuery235.Next;
                      fdb.ADOQuery236.Next;
                      fdb.ADOQuery239.Next;
                    end;
                  count1:=count1+1;
                  fdb.ADOQuery224.Next;
                end;
              sum:=sum+1;
           end;
       end;
      fdb.XMLDocument2.SaveToFile(sSaveDialog1.FileName);
      fdb.XMLDocument2.Active:=false;
      if FileExists(sSaveDialog1.FileName) then
        ShowMessage('Файл успешно экспортирован.')
      else
        ShowMessage('Внутренняя ошибка базы данных!');
      Screen.Cursor:=crDefault;
    end;
end;

const
  Codes64='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
function TExportImportForm.Encode64(s:string):string;
var
  i:Integer;
  a:Integer;
  x:Integer;
  b:Integer;
begin
  Result:='';
  a:=0;
  b:=0;
  for i:=1 to Length(s) do
    begin
      x:=Ord(s[i]);
      b:=b*256+x;
      a:=a+8;
      while a>= 6 do
        begin
          a:=a-6;
          x:=b div(1 shl a);
          b:=b mod(1 shl a);
          Result:=Result+Codes64[x+1];
        end;
    end;
  if a>0 then
    begin
      x:= b shl(6 - a);
      Result:=Result+Codes64[x+1];
    end;
end;

function TExportImportForm.Decode64(s:string): string;
var
  i:Integer;
  a:Integer;
  x:Integer;
  b:Integer;
begin
  Result:='';
  a:=0;
  b:=0;
  for i:=1 to Length(s) do
    begin
      x:=Pos(s[i],codes64)-1;
      if x >= 0 then
        begin
          b:=b*64+x;
          a:=a+6;
          if a>= 8 then
            begin
              a:=a-8;
              x:=b shr a;
              b:=b mod(1 shl a);
              x:=x mod 256;
              Result:=Result+chr(x);
            end;
        end
      else
        Exit;
    end;
end;

procedure TExportImportForm.sListView1Click(Sender: TObject);
var
  i:integer;
begin
  for i :=0 to sListView1.Items.Count-1 do
    begin
      if sListView1.Items[i].Checked then
        sListView1.Items[i].Selected:=true;
    end;
end;

end.
