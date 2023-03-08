unit MyDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs,  DB, ADODB, xmldom, XMLIntf, msxmldom, XMLDoc;

type
  TfDB = class(TDataModule)
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    ADOQueryType: TADOQuery;
    ADOInsertQuestion: TADOQuery;
    DataSource2: TDataSource;
    ADOSelLesson: TADOQuery;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
    ADOLessons: TADOQuery;
    DataSource5: TDataSource;
    ADORes: TADOQuery;
    ADOQuery2: TADOQuery;
    DataSource6: TDataSource;
    ADOQuery3: TADOQuery;
    DataSource7: TDataSource;
    DataPicture: TDataSource;
    DataVideo: TDataSource;
    ADOPicture: TADOQuery;
    ADOVideo: TADOQuery;
    ADOQueryRes: TADOQuery;
    DataSource8: TDataSource;
    ADOQuery4: TADOQuery;
    DataSource9: TDataSource;
    DataSource10: TDataSource;
    ADOQuery5: TADOQuery;
    ADOQuery3QuestionType_ID: TAutoIncField;
    ADOQuery3QuestionType_Name: TWideStringField;
    ADOQuery3QuestionType: TStringField;
    ADOQuery6: TADOQuery;
    ADOResUser_ID: TAutoIncField;
    ADOResExpr1001: TWideStringField;
    ADOResActive: TWideStringField;
    ADOResMark: TIntegerField;
    ADOPolRez: TADOQuery;
    DataSource12: TDataSource;
    ADOPolRezUser_ID: TAutoIncField;
    ADOPolRezExpr1001: TWideStringField;
    ADOPolRezActive: TWideStringField;
    ADOPolRezMark: TIntegerField;
    ADOPolRezQuestionType_Name: TWideStringField;
    ADOGraph: TADOQuery;
    DataGraph: TDataSource;
    DataSource13: TDataSource;
    ADOClassRez: TADOQuery;
    ADOPolRezDate_Result: TDateTimeField;
    DataSource14: TDataSource;
    ADORezTrack: TADOQuery;
    DataSource15: TDataSource;
    ADOQuery7: TADOQuery;
    DataSource16: TDataSource;
    ADOQuery8: TADOQuery;
    DataSource17: TDataSource;
    ADOProw: TADOQuery;
    ADOQuery8Name_Trajectory: TWideStringField;
    ADOQuery8Name_Lesson: TWideStringField;
    ADOQuery8QuestionType_Name: TWideStringField;
    ADOQuery8Slog: TWideStringField;
    ADOQuery8Mark: TIntegerField;
    ADOQuery8Effect: TIntegerField;
    ADOQuery8Date_Result: TDateTimeField;
    ADOQuery8Pol_Mark: TIntegerField;
    DataSource18: TDataSource;
    ADOQuery9: TADOQuery;
    ADOQuery9User_ID: TAutoIncField;
    ADOQuery9User_Login: TWideStringField;
    ADOQuery9User_Name: TWideStringField;
    ADOQuery9User_Class: TWideStringField;
    DataSource19: TDataSource;
    ADODelete: TADOQuery;
    DataSource20: TDataSource;
    ADOSam: TADOQuery;
    ADOSamQuestionType_Name: TWideStringField;
    ADOSamSlog: TWideStringField;
    ADOSamMark: TIntegerField;
    ADOSamEffect: TIntegerField;
    ADOSamDate_Result: TDateTimeField;
    DataSource21: TDataSource;
    ADOQuery10: TADOQuery;
    ADOQuery11: TADOQuery;
    DataSource22: TDataSource;
    DataSource23: TDataSource;
    ADODelTrac: TADOQuery;
    ADOQuery13: TADOQuery;
    DataSource24: TDataSource;
    ADOQuery12: TADOQuery;
    ADOQuery12Name_Trajectory: TWideStringField;
    ADOQuery12Num_Lessons: TWideStringField;
    ADOQuery12Count_Lessons: TIntegerField;
    ADOQuery12QuestionType_Name: TWideStringField;
    ADOQuery13ID_Trajectory: TAutoIncField;
    ADOQuery13Name_Trajectory: TWideStringField;
    ADOQuery13Num_Lessons: TWideStringField;
    ADOQuery13Count_Lessons: TIntegerField;
    ADOQuery13QuestionType_Name: TWideStringField;
    DataSource25: TDataSource;
    DataSource26: TDataSource;
    DataSource27: TDataSource;
    DataSource28: TDataSource;
    DataSource29: TDataSource;
    DataSource30: TDataSource;
    DataSource31: TDataSource;
    DataSource32: TDataSource;
    DataSource33: TDataSource;
    ADOVideoUsl: TADOQuery;
    ADOAudioUsl: TADOQuery;
    ADOQuery16: TADOQuery;
    ADOPolTer: TADOQuery;
    ADODelVopr: TADOQuery;
    ADOVideoRes: TADOQuery;
    ADOAudioRes: TADOQuery;
    ADOQuery21: TADOQuery;
    ADOQuery22: TADOQuery;
    ADOQuery16Name_Trajectory: TWideStringField;
    ADOQuery16Name_Lesson: TWideStringField;
    ADOQuery16QuestionType_Name: TWideStringField;
    ADOQuery16Slog: TWideStringField;
    ADOQuery16Mark: TIntegerField;
    ADOQuery16Effect: TIntegerField;
    ADOQuery16Date_Result: TDateTimeField;
    ADOQuery16Pol_Mark: TIntegerField;
    ADOQuery14: TADOQuery;
    WideStringField1: TWideStringField;
    WideStringField2: TWideStringField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    DateTimeField1: TDateTimeField;
    DataSourceUserUpd: TDataSource;
    ADOQuery2aa: TStringField;
    ADOTragect: TADOQuery;
    DataSourceTragect: TDataSource;
    ADOQueryAnswers: TADOQuery;
    DataSourceAnswers: TDataSource;
    ADOQuery15: TADOQuery;
    ADOQueryResultsDate: TADOQuery;
    DatasourseResultsDate: TDataSource;
    ADOQueryTrajectProcess: TADOQuery;
    DataSourceTrajectProcess: TDataSource;
    ADOQuery6QuestionsId: TAutoIncField;
    ADOQuery6QuestionTypesNazvanie: TWideStringField;
    ADOQuery6aa: TStringField;
    ADOQuery6QuestionType_Id: TIntegerField;
    ADOQuery6AnswerType: TIntegerField;
    ADOQuery6Audio_Id: TIntegerField;
    ADOQuery6Video_Id: TIntegerField;
    ADOQuery6Photo_Id: TIntegerField;
    ADOQuery6QuestionTypesId: TAutoIncField;
    ADOQuery2QID: TAutoIncField;
    ADOQuery2Nazv: TMemoField;
    ADOQuery2QuestionType_Id: TIntegerField;
    ADOQuery2AnswerType: TIntegerField;
    ADOQuery2Audio_Id: TIntegerField;
    ADOQuery2Video_Id: TIntegerField;
    ADOQuery2Photo_Id: TIntegerField;
    ADOQuery2QTID: TAutoIncField;
    ADOQuery2TypeNazvanie: TWideStringField;
    ADOQuery100: TADOQuery;
    DataSource100: TDataSource;
    ADOQuery100QID: TAutoIncField;
    ADOQuery100Nazv: TMemoField;
    ADOQuery100QuestionType_Id: TIntegerField;
    ADOQuery100AnswerType: TIntegerField;
    ADOQuery100QTID: TAutoIncField;
    ADOQuery100TypeNazvanie: TWideStringField;
    ADOQuery100BriefNazv: TStringField;
    ADOQuery111: TADOQuery;
    DataSource111: TDataSource;
    ADOQuery112: TADOQuery;
    DataSource112: TDataSource;
    DataSource113: TDataSource;
    ADOQuery113: TADOQuery;
    ADOQuery113ID: TAutoIncField;
    ADOQuery113Nazvanie: TWideStringField;
    ADOQuery113Question_Level: TWordField;
    ADOQuery114: TADOQuery;
    DataSource114: TDataSource;
    ADOQuery114ID: TAutoIncField;
    ADOQuery114Nazvanie: TWideStringField;
    ADOQuery115: TADOQuery;
    AutoIncField1: TAutoIncField;
    WideStringField3: TWideStringField;
    WordField1: TWordField;
    DataSource115: TDataSource;
    ADOQuery116: TADOQuery;
    DataSource116: TDataSource;
    ADOQuery116ID: TAutoIncField;
    ADOQuery116Nazvanie: TWideStringField;
    ADOQuery118: TADOQuery;
    DataSource118: TDataSource;
    ADOQuery118ID: TAutoIncField;
    ADOQuery118Nazvanie: TWideStringField;
    ADOQuery117: TADOQuery;
    ADOQuery117AnswerType: TIntegerField;
    ADOQuery117QuestionTypeNazvanie: TStringField;
    ADOQuery117AnswerTypeNazvanie: TStringField;
    DataSource117: TDataSource;
    ADOQuery119: TADOQuery;
    DataSource119: TDataSource;
    ADOQuery117QuestionNazvanie: TStringField;
    ADOQuery119ID: TAutoIncField;
    ADOQuery119Nazvanie: TWideStringField;
    ADOQuery120: TADOQuery;
    DataSource120: TDataSource;
    ADOQuery121: TADOQuery;
    AutoIncField2: TAutoIncField;
    WideStringField4: TWideStringField;
    IntegerField3: TIntegerField;
    BooleanField1: TBooleanField;
    DataSource121: TDataSource;
    ADOQuery122: TADOQuery;
    DataSource122: TDataSource;
    ADOQuery122ID: TAutoIncField;
    ADOQuery122Nazvanie: TWideStringField;
    ADOQuery122Question_ID: TIntegerField;
    ADOQuery122Righted: TBooleanField;
    ADOQuery200: TADOQuery;
    DataSource200: TDataSource;
    ADOQuery125: TADOQuery;
    DataSource125: TDataSource;
    ADOQueryQuestions: TADOQuery;
    DataSourceQuestions: TDataSource;
    ADOQueryQuestionsQuestion_ID: TIntegerField;
    ADOQueryQuestionsNazvanie: TMemoField;
    ADOQuery117ConditionAudio_ID: TIntegerField;
    ADOQuery117ConditionVideo_ID: TIntegerField;
    ADOQuery117ConditionPhoto_ID: TIntegerField;
    ADOQuery117SolveAudio_ID: TIntegerField;
    ADOQuery117SolveVideo_ID: TIntegerField;
    ADOQuery117SolvePhoto_ID: TIntegerField;
    ADOQueryMult: TADOQuery;
    DataSourceMult: TDataSource;
    ADOQueryMultID: TAutoIncField;
    ADOQueryMultSoderjanie: TMemoField;
    ADOQueryMultType: TIntegerField;
    ADOQuery170: TADOQuery;
    DataSource170: TDataSource;
    ADOQuery180: TADOQuery;
    DataSource180: TDataSource;
    ADOQuery190: TADOQuery;
    DataSource190: TDataSource;
    ADOQuery300: TADOQuery;
    DataSource300: TDataSource;
    ADOQuery301: TADOQuery;
    DataSource301: TDataSource;
    ADOQuery301ID: TAutoIncField;
    ADOQuery301Nazvanie: TWideStringField;
    ADOQuery117QuestionType_ID: TIntegerField;
    ADOQuery250: TADOQuery;
    DataSource250: TDataSource;
    ADOQuery117qqq: TMemoField;
    ADOQueryTraject: TADOQuery;
    DataSourceTraject: TDataSource;
    ADOQueryAnsw: TADOQuery;
    DataSourceAnsw: TDataSource;
    ADOQuery114Zoya_Level: TIntegerField;
    ADOQuery114User_level: TStringField;
    ADOQuery171: TADOQuery;
    DataSource171: TDataSource;
    ADOQuery171ID: TAutoIncField;
    ADOQuery171Nazvanie: TWideStringField;
    ADOQuery171Zoya_level: TIntegerField;
    ADOQueryContinue: TADOQuery;
    DataSourceContinue: TDataSource;
    ADOQueryContRez: TADOQuery;
    DataSourceContRez: TDataSource;
    ADOQueryContRezRightAnswer: TIntegerField;
    ADOQuery222: TADOQuery;
    DataSource222: TDataSource;
    ADOQueryLessonName: TADOQuery;
    DataSourceLessonName: TDataSource;
    ADOQuery116Control: TBooleanField;
    ADOQuery116TextControl: TStringField;
    ADOQuery444: TADOQuery;
    DataSource444: TDataSource;
    ADOQueryCompleXity: TADOQuery;
    DataSourceCompleXity: TDataSource;
    ADOQueryLessonsProcess: TADOQuery;
    DataSourceLessonsProcess: TDataSource;
    ADOQuery223: TADOQuery;
    DataSource223: TDataSource;
    XMLDocument1: TXMLDocument;
    ADOQuery224: TADOQuery;
    DataSource224: TDataSource;
    ADOQuery225: TADOQuery;
    DataSource225: TDataSource;
    ADOQuery226: TADOQuery;
    DataSource226: TDataSource;
    ADOQuery227: TADOQuery;
    DataSource227: TDataSource;
    ADOQuery228: TADOQuery;
    DataSource228: TDataSource;
    ADOQuery229: TADOQuery;
    DataSource229: TDataSource;
    ADOQuery230: TADOQuery;
    DataSource230: TDataSource;
    ADOQuery231: TADOQuery;
    DataSource231: TDataSource;
    ADOQuery232: TADOQuery;
    DataSource232: TDataSource;
    ADOQuery233: TADOQuery;
    DataSource233: TDataSource;
    ADOQuery234: TADOQuery;
    DataSource234: TDataSource;
    ADOQuery235: TADOQuery;
    DataSource235: TDataSource;
    ADOQuery236: TADOQuery;
    DataSource236: TDataSource;
    ADOQuery237: TADOQuery;
    DataSource237: TDataSource;
    ADOQuery999: TADOQuery;
    DataSource999: TDataSource;
    ADOQuery238: TADOQuery;
    DataSource238: TDataSource;
    ADOQuery117Theory_ID: TIntegerField;
    ADOQuery239: TADOQuery;
    DataSource239: TDataSource;
    ADOQuery244: TADOQuery;
    DataSource244: TDataSource;
    XMLDocument2: TXMLDocument;
    ADOQuery245: TADOQuery;
    DataSource245: TDataSource;
    ADOQuery66: TADOQuery;
    AutoIncField3: TAutoIncField;
    WideStringField5: TWideStringField;
    DataSource66: TDataSource;
    ADOQuery67: TADOQuery;
    DataSource67: TDataSource;
    ADOQuery68: TADOQuery;
    DataSource68: TDataSource;
    ADOQuery998: TADOQuery;
    DataSource998: TDataSource;
    ADOQuery69: TADOQuery;
    DataSource69: TDataSource;
    ADOQuery120ID: TAutoIncField;
    ADOQuery120Nazvanie: TWideStringField;
    ADOQuery120Question_ID: TIntegerField;
    ADOQuery120Righted: TBooleanField;
    ADOQuery120Picture: TMemoField;
    ADOQueryQQ: TADOQuery;
    DataSourceQQ: TDataSource;
    ADOQuery117WorkType: TWordField;
    ADOQuery117TheoryHelp_ID: TIntegerField;
    ADOQuery240: TADOQuery;
    DataSource240: TDataSource;
    ADOQuery1z: TADOQuery;
    DataSource1z: TDataSource;
    ADOQuery2z: TADOQuery;
    DataSource2z: TDataSource;
    ADOQuery116TimeLeft: TIntegerField;
    ADOQuery3z: TADOQuery;
    DataSource3z: TDataSource;
    ADOQuery4z: TADOQuery;
    DataSource4z: TDataSource;
    ADOQuery100WorkType: TWordField;
    ADOQuery117QID: TAutoIncField;
    ADOQuery117QTID: TAutoIncField;
    ADOQuery117TypeNazvanie: TWideStringField;
    ADOQuery117CompleXity_ID: TIntegerField;
    ADOQuery117CX_Nazvanie: TWideStringField;
    ADOQuery1qq: TADOQuery;
    AutoIncField4: TAutoIncField;
    WideStringField6: TWideStringField;
    DataSource4qq: TDataSource;
    ADOQuery117CompleXityNazvanie: TStringField;
    ADOQuery117CXID: TIntegerField;
    ADOQuery2qq: TADOQuery;
    DataSource2qq: TDataSource;
    ADOQuery2qqWorkType: TWordField;
    ADOQuery100CX_Nazvanie: TWideStringField;
    ADOQueryCompleXityID: TAutoIncField;
    ADOQueryCompleXityNazvanie: TWideStringField;
    ADOQueryCompleXityZoya_level: TIntegerField;
    ADOQuery4qq: TADOQuery;
    DataSource11: TDataSource;
    ADOQueryW: TADOQuery;
    ADOQueryGrammar: TADOQuery;
    DataSourceGrammar: TDataSource;
    ADOQueryGrammar2: TADOQuery;
    ADOCommandTheory: TADOCommand;
    ADOQueryPOS: TADOQuery;
    DataSourcePOS: TDataSource;
    ADOCommandWord: TADOCommand;
    ADOQueryTEST: TADOQuery;
    DataSourceTEST: TDataSource;
    ADOCommandTEST: TADOCommand;
    DataSourceCalcReport: TDataSource;
    ADOQueryCalcReport: TADOQuery;
    AutoIncField5: TAutoIncField;
    WideStringField7: TWideStringField;
    IntegerField4: TIntegerField;
    ADOQueryDevMode: TADOQuery;
    AutoIncField6: TAutoIncField;
    WideStringField8: TWideStringField;
    IntegerField5: TIntegerField;
    DataSourceDevMode: TDataSource;
    ADOQueryDevMin: TADOQuery;
    AutoIncField7: TAutoIncField;
    WideStringField9: TWideStringField;
    IntegerField6: TIntegerField;
    DataSourceDevMin: TDataSource;
    ADOQueryDevMax: TADOQuery;
    AutoIncField8: TAutoIncField;
    WideStringField10: TWideStringField;
    IntegerField7: TIntegerField;
    DataSourceDevMax: TDataSource;
    ADOQuery17: TADOQuery;
    procedure ADOQuery2CalcFields(DataSet: TDataSet);
    procedure ADOQuery6CalcFields(DataSet: TDataSet);
    procedure ADOQuery100CalcFields(DataSet: TDataSet);
    procedure ADOQuery117CalcFields(DataSet: TDataSet);
    procedure DataSource117DataChange(Sender: TObject; Field: TField);
    procedure DataSource190DataChange(Sender: TObject; Field: TField);
    procedure ADOQuery114CalcFields(DataSet: TDataSet);
    procedure ADOQuery116CalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    CompleXity_ID:integer;
    Traject_ID:integer;
    QuestionTypes_ID:integer;
    CompleXity_IDs:array of integer;
    Question_IDs:array of integer;
    Results:array of Boolean;
    CurrentQuestion:integer;
    AudioCondition,VideoCondition,PhotoCondition:String;
    AudioSolve,VideoSolve,PhotoSolve:String;
    AnswerImage:string;
    Theory, TheoryHelp:string;
    Answer:string;
    Picture_path:array of string;
    Zoya_level:integer;
   end;

var
  fDB: TfDB;

implementation

uses MainMenu, QuestionEditor;

{$R *.dfm}


procedure TfDB.ADOQuery2CalcFields(DataSet: TDataSet);
begin
   ADOQuery2aa.AsString := Copy(ADOQuery2.FieldByName('Nazv').AsString, 1, 255);
end;

procedure TfDB.ADOQuery6CalcFields(DataSet: TDataSet);
begin
    ADOQuery6aa.AsString := Copy(ADOQuery6.FieldByName('Questions.Nazvanie').AsString, 1, 255);
end;

procedure TfDB.ADOQuery100CalcFields(DataSet: TDataSet);
begin
  ADOQuery100BriefNazv.AsString := Copy(ADOQuery100.FieldByName('Nazv').AsString, 1, 255);
end;

procedure TfDB.ADOQuery117CalcFields(DataSet: TDataSet);
begin
  ADOQuery117QuestionNazvanie.AsString:=Copy(ADOQuery117.FieldByName('Nazvanie').AsString, 1, 255);
  case ADOQuery117.FieldByName('AnswerType').AsInteger of
    1: ADOQuery117AnswerTypeNazvanie.AsString:='Единственный выбор';
    2: ADOQuery117AnswerTypeNazvanie.AsString:='Текст';
    3: ADOQuery117AnswerTypeNazvanie.AsString:='Множественный выбор';
  end;

end;

procedure TfDB.DataSource117DataChange(Sender: TObject; Field: TField);
begin
   AudioCondition:='';
   VideoCondition:='';
   PhotoCondition:='';
   AudioSolve:='';
   VideoSolve:='';
   PhotoSolve:='';
   Theory:='';
   TheoryHelp:='';
   {if QuestionEditorForm<>nil then
    begin
      if (QuestionEditorForm.sPanel1.Visible) and (QuestionEditorForm.sButton2.Visible=true) and (QuestionEditorForm.sButton1.Enabled=false) then
        begin
          for i := 0 to QuestionEditorForm.sTrackBar1.Position do
            fdb.Picture_path[i]:='';
        end;
    end;}
end;

procedure TfDB.DataSource190DataChange(Sender: TObject; Field: TField);
begin
  fMainMenu.userId:=0;
end;

procedure TfDB.ADOQuery114CalcFields(DataSet: TDataSet);
begin
  case ADOQuery114.FieldByName('Zoya_Level').AsInteger of
    0:
      ADOQuery114User_level.AsString:='1-ый класс';
    1:
      ADOQuery114User_level.AsString:='2-ой класс';
    2:
      ADOQuery114User_level.AsString:='3-ий класс';
    3:
      ADOQuery114User_level.AsString:='4-ый класс';
      4:
      ADOQuery114User_level.AsString:='5-ый класс';
      5:
      ADOQuery114User_level.AsString:='6-ой класс';
      6:
      ADOQuery114User_level.AsString:='7-ой класс';
      7:
      ADOQuery114User_level.AsString:='8-ой класс';
      8:
      ADOQuery114User_level.AsString:='9-ый класс';
      9:
      ADOQuery114User_level.AsString:='10-ый класс';
      10:
      ADOQuery114User_level.AsString:='11-ый класс';
    end;
end;

procedure TfDB.ADOQuery116CalcFields(DataSet: TDataSet);
begin
  if ADOQuery116Control.AsBoolean then
    ADOQuery116TextControl.AsString:='Да'
  else
    ADOQuery116TextControl.AsString:='Нет';
end;

end.
