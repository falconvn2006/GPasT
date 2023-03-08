unit SelectLesson;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, sListView, sTreeView, StdCtrls, sLabel, Buttons, sBitBtn,
  ImgList, Grids, DBGrids, acDBGrid, Math, System.ImageList;

type
  TfSelectLesson = class(TForm)
    sTreeView1: TsTreeView;
    sLabel1: TsLabel;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sBitBtn3: TsBitBtn;
    sBitBtn4: TsBitBtn;
    ImageList1: TImageList;
    sBitBtn5: TsBitBtn;
    procedure sBitBtn1Click(Sender: TObject);
    procedure Traject;
    procedure sTreeView1KeyPress(Sender: TObject; var Key: Char);
    procedure sTreeView1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sBitBtn5Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Id_Lesson:Integer;
    List: TList;
    NameTraj: String;
    NameLes: String;
    num_les : TStringList;
    Id_Traj:Integer;
    Kol_Les: Integer;
    Continue:String;
  end;

var
  fSelectLesson: TfSelectLesson;

implementation

uses MyDB, IndependentWork, ResultToChild,MainMenu,IndReports, DB,
  Traject_level, Utils;

{$R *.dfm}                                                 

procedure TfSelectLesson.sBitBtn1Click(Sender: TObject);
var
  i,selected_index:integer;
begin
  Continue:='no';
  if sTreeView1.Items.Count=0 then
    begin
      ShowMessage('База данных пуста!');
      exit;
    end;
  if (sTreeView1.Selected=nil) or (sTreeView1.Selected.Level=0) then
    begin
      ShowMessage('Не выбран урок!');
      exit;
    end;
  Id_Traj:=Integer(sTreeView1.Selected.Parent.data);
  NameTraj:=sTreeView1.Selected.Parent.Text;
  Id_Lesson:=Integer(sTreeView1.Selected.data);
  NameLes:=sTreeView1.Selected.Text;
  hide;
  if fMainMenu.work='Class' then
    begin
      fIndependentWork := TfIndependentWork.Create(nil);
      try
        fIndependentWork.ShowModal;
        Traject;
        if fIndependentWork.normal_exit and (sTreeView1.Selected<>Nil) and (sTreeView1.Selected.Level=1)then
          begin
            selected_index:=0;
            for i:=0 to sTreeView1.Items.Count-1 do
              begin
                if sTreeView1.Selected=sTreeView1.Items[i] then
                  begin
                    selected_index:=i;
                    break;
                  end;
              end;
            if (selected_index<sTreeView1.Items.Count-1) then
              begin
                if sTreeView1.Selected.Level=sTreeView1.Items[selected_index+1].Level then
                  begin
                    sTreeView1.Selected:=sTreeView1.Items[selected_index+1];
                    sBitBtn1Click(Sender);
                  end;
              end;
          end;
      finally
        FreeAndNil(fIndependentWork);
      end;
    end;
    Show;
end;

procedure TfSelectLesson.sTreeView1DblClick(Sender: TObject);
begin
  sBitBtn1Click(Sender);
end;

procedure TfSelectLesson.sTreeView1KeyPress(Sender: TObject; var Key: Char);
begin
 if (Key=#13) and sTreeView1.Focused then
    sBitBtn1Click(Sender);
end;

procedure TfSelectLesson.Traject;
var
  i,j,MarkTraject, MarkSUM, MarkCount: integer;
  Node, ChildNode : TTreeNode;
  Traject_FullName:string;
  tempDate:TDateTime;
begin
  try
    MarkSUM:=0;
    fDB.ADOTragect.Close;
    fDB.ADOTragect.SQL.Clear;
    fDB.ADOTragect.SQL.Add('SELECT DISTINCT T.ID, T.Nazvanie FROM Traject AS T, TrajectLessons AS TL, Lessons AS L, LessonsQuestions AS LQ, Questions AS Q');
    fDB.ADOTragect.SQL.Add('WHERE T.Zoya_level=:1 AND T.ID=TL.Traject_ID AND TL.Lessons_ID=L.ID AND L.ID=LQ.Lesson_ID AND LQ.Question_ID=Q.ID AND Q.Worktype=0');
    fDB.ADOTragect.Parameters.ParamByName('1').Value:=fdb.Zoya_level;
    fDB.ADOTragect.Open;
    fDB.ADOTragect.First;
    sTreeView1.Items.Clear;
    for i:=0 to fDB.ADOTragect.RecordCount-1 do
      begin
        Traject_FullName:=fDB.ADOTragect.Fields[1].AsString+' ('+GetTextControl(fDB.ADOTragect.Fields[0].AsInteger)+ ')';
        Node:=sTreeView1.Items.Add(Nil, Traject_FullName);
        Node.Data:=Pointer(fDB.ADOTragect.Fields[0].AsInteger);
        fDB.ADOLessons.Close;
        fDB.ADOLessons.SQL.Clear;
        fDB.ADOLessons.SQL.Add('SELECT DISTINCT T.Lessons_id, L.ID, L.Nazvanie FROM TrajectLessons t, Lessons L, LessonsQuestions AS LQ, Questions AS Q');
        fDB.ADOLessons.SQL.Add('WHERE T.Traject_id=:1 AND T.Lessons_ID=L.ID AND L.ID=LQ.Lesson_ID AND LQ.Question_ID=Q.ID AND Q.WorkType=0 AND L.TimeLeft<>0 ORDER BY L.ID');
        fDB.ADOLessons.parameters.ParamByName('1').value:=fDB.ADOTragect.Fields[0].AsInteger;
        fDB.ADOLessons.Open;
        fDB.ADOLessons.First;
        for j:=0 to fDB.ADOLessons.RecordCount-1 do
          begin
            ChildNode:=sTreeView1.Items.AddChild(Node,fDB.ADOLessons.Fields[2].AsString);
            ChildNode.Data:= Pointer(fDB.ADOLessons.Fields[1].AsInteger);
            if integer(ChildNode.Data)=Id_Lesson then
              sTreeView1.Selected:=ChildNode;
            if fDB.ADOQuery300.Active then
              fDB.ADOQuery300.close;
            fDB.ADOQuery300.SQL.Clear;
            fDB.ADOQuery300.SQL.Add('SELECT Results_Class.Start_Data, Results_Class.Mark AS Mark, SUM(Results_Class.Mark) AS MarkFull FROM Groups, Results_Class, Users, Traject, Lessons');
            fDB.ADOQuery300.SQL.Add('WHERE Users.Group_id=Groups.ID and Results_Class.User_ID=:1 and Results_Class.User_ID=Users.ID AND Results_Class.Traject_ID=Traject.ID');
            fDB.ADOQuery300.SQL.Add('AND Results_Class.Lessons_ID=Lessons.ID AND Results_Class.Traject_ID=:2 AND Results_Class.Lessons_ID=:3 AND Traject.Zoya_level=:4');
            fDB.ADOQuery300.SQL.Add('GROUP BY Results_Class.Start_Data, Results_Class.Mark ORDER BY Results_Class.Start_Data DESC');
            fdb.ADOQuery300.Parameters.ParamByName('1').Value:=fMainMenu.userId;
            fdb.ADOQuery300.Parameters.ParamByName('2').Value:=fDB.ADOTragect.Fields[0].AsInteger;
            fdb.ADOQuery300.Parameters.ParamByName('3').Value:=fDB.ADOLessons.Fields[1].AsInteger;
            fdb.ADOQuery300.Parameters.ParamByName('4').Value:=fDB.Zoya_level;
            fdb.ADOQuery300.Open;
            if fDB.ADOQuery1z.Active then
              fDB.ADOQuery1z.Close;
            fDB.ADOQuery1z.SQL.Clear;
            fDB.ADOQuery1z.SQL.Add('SELECT Lessons_ID, MAX(Start_Data) AS MAX_StartDate FROM Results_Class');
            fDB.ADOQuery1z.SQL.Add('WHERE User_ID=:1 AND Traject_Id=:2 AND Lessons_ID=:3 GROUP BY Lessons_ID');
            fdb.ADOQuery1z.Parameters.ParamByName('1').Value:=fMainMenu.userId;
            fdb.ADOQuery1z.Parameters.ParamByName('2').Value:=fDB.ADOTragect.Fields[0].AsInteger;
            fdb.ADOQuery1z.Parameters.ParamByName('3').Value:=fDB.ADOLessons.Fields[1].AsInteger;
            fdb.ADOQuery1z.Open;
            tempDate:=fdb.ADOQuery1z.FieldByName('MAX_StartDate').AsDateTime;
            if fDB.ADOQuery1z.Active then
              fDB.ADOQuery1z.close;
            fDB.ADOQuery1z.SQL.Clear;
            fDB.ADOQuery1z.SQL.Add('SELECT SUM(Mark) AS MarkSUM FROM Results_Class');
            fDB.ADOQuery1z.SQL.Add('WHERE User_ID=:1 AND Traject_Id=:2 AND Start_Data=:3');
            fdb.ADOQuery1z.Parameters.ParamByName('1').Value:=fMainMenu.userId;
            fdb.ADOQuery1z.Parameters.ParamByName('2').Value:=fDB.ADOTragect.Fields[0].AsInteger;
            fdb.ADOQuery1z.Parameters.ParamByName('3').Value:=tempDate;
            fdb.ADOQuery1z.Open;
            MarkSUM:=MarkSUM+fdb.ADOQuery1z.FieldByName('MarkSUM').AsInteger;
            if fdb.ADOQuery300.RecordCount<>0 then
              begin
                fdb.ADOQuery300.First;
                case fdb.ADOQuery300.FieldByName('Mark').AsInteger of
                  2:
                    ChildNode.StateIndex:=1;
                  3:
                    ChildNode.StateIndex:=2;
                  4:
                    ChildNode.StateIndex:=3;
                  5:
                    ChildNode.StateIndex:=4;
                end;
              end;
            if fDB.ADOQuery300.Active then
              fDB.ADOQuery300.close;
            fDB.ADOLessons.Next;
          end;
          if fDB.ADOLessons.Active then
              fDB.ADOLessons.close;
          if fDB.ADOQuery1z.Active then
            fDB.ADOQuery1z.close;
          fDB.ADOQuery1z.SQL.Clear;
          fDB.ADOQuery1z.SQL.Add('SELECT DISTINCT Lessons_Id FROM Results_Class');
          fDB.ADOQuery1z.SQL.Add('WHERE User_ID=:1 AND Traject_ID=:2');
          fdb.ADOQuery1z.Parameters.ParamByName('1').Value:=fMainMenu.userId;
          fdb.ADOQuery1z.Parameters.ParamByName('2').Value:=fDB.ADOTragect.Fields[0].AsInteger;
          fdb.ADOQuery1z.Open;
          MarkCount:=fdb.ADOQuery1z.RecordCount;
          if (MarkSUM<>0) and (MarkCount<>0) then
            begin
              MarkTraject:=MarkSUM div MarkCount;
              case MarkTraject of
                2:
                  Node.StateIndex:=1;
                3:
                  Node.StateIndex:=2;
                4:
                  Node.StateIndex:=3;
                5:
                  Node.StateIndex:=4;
              end;
            end;
        MarkSUM:=0;
        fDB.ADOTragect.Next;
    end;
  except
    on E:Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfSelectLesson.FormCreate(Sender: TObject);
begin
  Id_Lesson:=-1;
  Continue:='no';
end;

procedure TfSelectLesson.sBitBtn5Click(Sender: TObject);
var
  i,selected_index:integer;
begin
  Continue:='yes';
  {if sTreeView1.Items.Count=0 then
    begin
      ShowMessage('База данных пуста!');
      exit;
    end;}
  fdb.ADOQueryContinue.Close;
  fdb.ADOQueryContinue.SQL.Clear;
  fdb.ADOQueryContinue.SQL.Add('SELECT CW.ID, CW.Id_Traject AS Id_Traject, CW.Id_Lessons AS Id_Lessons FROM Continue_Class AS CW, Traject AS T, Lessons AS L, Users AS U, Questions AS Q');
  fdb.ADOQueryContinue.SQL.Add('WHERE CW.Id_Traject=T.ID AND CW.Id_Lessons=L.ID AND CW.User_ID=U.ID AND U.ID=:1 AND CW.Id_Question=Q.ID ORDER BY CW.ID desc');
  fdb.ADOQueryContinue.Parameters.ParamByName('1').Value:=fMainMenu.userId;
  fdb.ADOQueryContinue.Open;
  fdb.ADOQueryContinue.First;
  if fdb.ADOQueryContinue.RecordCount=0 then
    begin
      ShowMessage('Внутренняя ошибка базы данных!');
      exit;
    end;
  Id_Traj:=fdb.ADOQueryContinue.FieldByName('Id_Traject').AsInteger;
  Id_Lesson:=fdb.ADOQueryContinue.FieldByName('Id_Lessons').AsInteger;
  hide;
  if fMainMenu.work='Class' then
    begin
      fIndependentWork:=TfIndependentWork.Create(nil);
      try
        fIndependentWork.ShowModal;        
        if fIndependentWork.normal_exit and (sTreeView1.Selected<>Nil) and (sTreeView1.Selected.Level=1)then
          begin
            selected_index:=0;
            for i:=0 to sTreeView1.Items.Count-1 do
              begin
                if sTreeView1.Selected=sTreeView1.Items[i] then
                  begin
                    selected_index:=i;
                    break;
                  end;
              end;
            if (selected_index<sTreeView1.Items.Count-1) then
              begin
                if sTreeView1.Selected.Level=sTreeView1.Items[selected_index+1].Level then
                  begin
                    sTreeView1.Selected:=sTreeView1.Items[selected_index+1];
                    sBitBtn1Click(Sender);
                  end;             
              end;
          end;
      finally
        FreeAndNil(fIndependentWork);
      end;
    end;
    Show;
end;

procedure TfSelectLesson.sBitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
