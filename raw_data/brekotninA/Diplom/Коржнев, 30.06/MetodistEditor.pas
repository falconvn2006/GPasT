unit MetodistEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, sTreeView, StdCtrls, Buttons, sBitBtn, Grids, DBGrids,
  acDBGrid, sEdit, sLabel, sComboBox, sGroupBox;

type
  TMetodistForm = class(TForm)
    sDBGrid1: TsDBGrid;
    sTreeView1: TsTreeView;
    sDBGrid2: TsDBGrid;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sBitBtn5: TsBitBtn;
    sBitBtn6: TsBitBtn;
    sLabel7: TsLabel;
    eFind: TsEdit;
    sBitBtn3: TsBitBtn;
    sBitBtn7: TsBitBtn;
    sGroupBox5: TsGroupBox;
    sLabel4: TsLabel;
    sLabel10: TsLabel;
    sEdit1: TsEdit;
    sComboBox1: TsComboBox;
    sLabel1: TsLabel;
    sComboBox2: TsComboBox;
    sLabel13: TsLabel;
    sComboBox6: TsComboBox;
    procedure FormCreate(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure sTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn5Click(Sender: TObject);
    procedure eFindChange(Sender: TObject);
    procedure sEdit1Change(Sender: TObject);
    procedure sBitBtn7Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sDBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sComboBox2Change(Sender: TObject);
    procedure RefreshQuestions;
    procedure sDBGrid1DblClick(Sender: TObject);
    procedure sDBGrid2DblClick(Sender: TObject);
    procedure sComboBox6Change(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    List: TList;
    DeleteLessons_IDs:array of integer;
    DeleteLessonsQuestions_IDs: array of integer;
    DeleteQuestion_IDs:array of integer;
    IDs_QuestionType:array of integer;
    IDs_CompleXity:array of integer;
  end;
var
  MetodistForm: TMetodistForm;

implementation

uses MyDB, DB, Misc;

{$R *.dfm}  


procedure TMetodistForm.sBitBtn3Click(Sender: TObject);
begin
  if sTreeView1.Selected=Nil then
    begin
      ShowMessage('Урок не выбран!');
      exit;
    end;
  if sTreeView1.Selected.level=1 then
    begin
      if Application.MessageBox('Вы хотите удалить выбранный урок?','Удаление',MB_YESNO)=IDYES then
        begin
          SetLength(DeleteLessons_IDs,length(DeleteLessons_IDs)+1);
          DeleteLessons_IDs[length(DeleteLessons_IDs)-1]:=integer(sTreeView1.Selected.Data);
          sTreeView1.Items.Delete(sTreeView1.Selected);
          exit;
        end;
    end
  else
      ShowMessage('Урок не выбран!');
end;    

procedure TMetodistForm.eFindChange(Sender: TObject);
begin
  if fdb.ADOQuery116.Active then
    fdb.ADOQuery116.Close;
  fdb.ADOQuery116.SQL.Clear;
  if EFind.text <>'' then
    fdb.ADOQuery116.SQL.Add('SELECT ID, Nazvanie, Control, TimeLeft FROM Lessons WHERE Nazvanie LIKE ''' + '%' + EFind.Text + '%' + '''')
  else
    fdb.ADOQuery116.SQL.Add('SELECT ID, Nazvanie, Control, TimeLeft FROM Lessons');
  fdb.ADOQuery116.Open;
end;

procedure TMetodistForm.FormCreate(Sender: TObject);
var
  i,j,k: integer;
  Node, ChildNode, ChildChildNode : TTreeNode;
  temp:string;
begin
  Caption:=GetBaseCaption + ' (Методист)';
  if fdb.ADOQuery100.Active then
    fdb.ADOQuery100.Close;
  fdb.ADOQuery100.Open;
  if fdb.ADOQuery116.Active then
    fdb.ADOQuery116.close;
  fdb.ADOQuery116.Open;
   if fdb.ADOQuery114.Active then
    fdb.ADOQuery114.close;
  fdb.ADOQuery114.Open;
  if fdb.ADOQuery118.Active then
    fdb.ADOQuery118.close;
  fdb.ADOQuery118.Open;
  try
  if fdb.ADOQuery119.Active then
    fdb.ADOQuery119.close;
  fdb.ADOQuery119.Open;
  SetLength(IDs_QuestionType,fdb.ADOQuery119.RecordCount);
  fdb.ADOQuery119.First;
  sComboBox1.Items.Add('Все');
  for i:=0 to fdb.ADOQuery119.RecordCount-1 do
    begin
      IDs_QuestionType[i]:=fdb.ADOQuery119.FieldByName('ID').AsInteger;
      sComboBox1.Items.Add(fdb.ADOQuery119.FieldByName('Nazvanie').AsString);
      fdb.ADOQuery119.Next;
    end;
  sComboBox1.ItemIndex:=0;

  if fdb.ADOQuery2qq.Active then
    fdb.ADOQuery2qq.close;
  fdb.ADOQuery2qq.Open;
  fdb.ADOQuery2qq.First;
  sComboBox6.Items.Add('Все');
  for i:=0 to fdb.ADOQuery2qq.RecordCount-1 do
    begin
      case fdb.ADOQuery2qq.FieldByName('WorkType').AsInteger of
        0:
          temp:='Классная работа';
        1:
          temp:='Самостоятельаня работа';
        2:                                     
          temp:='Диагностика';
        3:
          Continue;
      end;
      sComboBox6.Items.Add(temp);
      fdb.ADOQuery2qq.Next;
    end;
  sComboBox6.ItemIndex:=0;

  if fdb.ADOQuery301.Active then
    fdb.ADOQuery301.close;
  fdb.ADOQuery301.Open;
  SetLength(IDs_CompleXity,fdb.ADOQuery301.RecordCount);
  fdb.ADOQuery301.First;
  sComboBox2.Items.Add('Все');
  for i:=0 to fdb.ADOQuery301.RecordCount-1 do
    begin
      IDs_CompleXity[i]:=fdb.ADOQuery301.FieldByName('ID').AsInteger;
      sComboBox2.Items.Add(fdb.ADOQuery301.FieldByName('Nazvanie').AsString);
      fdb.ADOQuery301.Next;
    end;
  sComboBox2.ItemIndex:=0;
    fDB.ADOTragect.Close;
    fDB.ADOTragect.SQL.Clear;
    fDB.ADOTragect.SQL.Add('SELECT ID, Nazvanie FROM Traject WHERE ID=:1 ORDER BY Nazvanie');
    fDB.ADOTragect.parameters.ParamByName('1').value:=fDB.Traject_ID;
    fDB.ADOTragect.Open;
    fDB.ADOTragect.First;
    sTreeView1.Items.Clear;
    for i:=0 to fDB.ADOTragect.RecordCount-1 do
      begin
        Node:=sTreeView1.Items.Add(Nil, fDB.ADOTragect.Fields[1].AsString);
        Node.Data:= Pointer(fDB.ADOTragect.Fields[0].AsInteger);   
        fDB.ADOLessons.Close;
        fDB.ADOLessons.SQL.Clear;
        fDB.ADOLessons.SQL.Add('SELECT DISTINCT T.Lessons_id, L.ID, L.Nazvanie FROM TrajectLessons t, Lessons L WHERE T.Traject_id=:1 AND T.Lessons_ID=L.ID ');
        fDB.ADOLessons.parameters.ParamByName('1').value:=fDB.ADOTragect.Fields[0].AsInteger;
        fDB.ADOLessons.Open;
        fDB.ADOLessons.first;
        for j:=0 to fDB.ADOLessons.RecordCount-1 do
          begin
            ChildNode:=sTreeView1.Items.AddChild(Node,fDB.ADOLessons.Fields[2].AsString);
            ChildNode.Data:= Pointer(fDB.ADOLessons.Fields[1].AsInteger);
            if fdb.ADOQueryQuestions.Active then
              fdb.ADOQueryQuestions.Close;
            fdb.ADOQueryQuestions.SQL.Clear;
            fdb.ADOQueryQuestions.SQL.Add('SELECT DISTINCT Question_ID, Questions.Nazvanie FROM LessonsQuestions, Questions WHERE  LessonsQuestions.Lesson_ID=:1 and LessonsQuestions.Question_ID=Questions.ID;');
            fdb.ADOQueryQuestions.Parameters.ParamByName('1').Value:=fDB.ADOLessons.Fields[1].AsInteger;
            fdb.ADOQueryQuestions.Open;
            fdb.ADOQueryQuestions.First;
            for k:=0 to fdb.ADOQueryQuestions.RecordCount-1 do
              begin
                 ChildChildNode:=sTreeView1.Items.AddChild(ChildNode,fDB.ADOQueryQuestions.Fields[1].AsString);
                 ChildChildNode.Data:=Pointer(fDB.ADOQueryQuestions.Fields[0].AsInteger);;
                 fdb.ADOQueryQuestions.Next;
              end;
            fDB.ADOLessons.Next;
          end;
        fDB.ADOTragect.Next;
    end;
    if sTreeView1.Items.Count<>0 then
      begin
        sTreeView1.Selected:=sTreeView1.Items[0];
        sTreeView1.FullExpand;
      end;

except
    on E:Exception do
      ShowMessage(E.Message);
end;

end;

procedure TMetodistForm.FormDestroy(Sender: TObject);
begin
  if fdb.ADOQuery118.Active then
    fdb.ADOQuery118.close;
  fdb.ADOQuery118.Open;   
end;

procedure TMetodistForm.FormShow(Sender: TObject);
begin
  if fdb.ADOQuery116.Active then
    fdb.ADOQuery116.Close;
  fdb.ADOQuery116.SQL.Clear;
  if EFind.text <>'' then
    fdb.ADOQuery116.SQL.Add('SELECT ID, Nazvanie, Control, TimeLeft FROM Lessons WHERE Nazvanie LIKE ''' + '%' + EFind.Text + '%' + '''')
  else                           
    fdb.ADOQuery116.SQL.Add('SELECT ID, Nazvanie, Control, TimeLeft FROM Lessons');
  fdb.ADOQuery116.Open;
  RefreshQuestions;
end;

procedure TMetodistForm.sBitBtn1Click(Sender: TObject);
var
  current_node:TTreeNode;
begin
  if sDBGrid1.SelectedField.Text='' then
    begin
      ShowMessage('Вы пытаетесь добавить пустое поле!');
      exit;
    end;
  if sTreeView1.Selected=Nil then
    ShowMessage('Выберите урок!')
  else
    begin
      current_node:=sTreeView1.Items.AddChild(sTreeView1.Selected, fDB.ADOQuery100.Fields[1].AsString);
      current_node.Data:=pointer(fDB.ADOQuery100.Fields[0].AsInteger);
      sTreeView1.Selected:=current_node;
      sTreeView1.FullExpand;
    end;
end;

procedure TMetodistForm.sBitBtn2Click(Sender: TObject);
var
  current_node:TTreeNode;
begin
  if sDBGrid2.SelectedField.Text='' then
    begin
      ShowMessage('Вы пытаетесь добавить пустое поле!');
      exit;
    end;
  if sTreeView1.Selected=Nil then
    ShowMessage('Выберите траекторию!')
  else
    begin
      current_node:=sTreeView1.Items.AddChild(sTreeView1.Selected, fDB.ADOQuery116.Fields[1].AsString);
      current_node.Data:=pointer(fDB.ADOQuery116.Fields[0].AsInteger);
      sTreeView1.Selected:=current_node;
      sTreeView1.FullExpand;
    end;
end;

procedure TMetodistForm.sTreeView1Change(Sender: TObject; Node: TTreeNode);
begin
if (Node <> nil) and (Node.Data <> nil) then
    case Node.Level of
      0:
        begin
          sBitBtn1.Enabled:=false;
          sBitBtn2.Enabled:=true;
        end;
      1:
        begin
          sBitBtn1.Enabled:=true;
          sBitBtn2.Enabled:=false;
        end;
      2:
        begin
          sBitBtn1.Enabled:=false;
          sBitBtn2.Enabled:=false;
        end;
    end;

end;   
procedure TMetodistForm.sBitBtn5Click(Sender: TObject);
var                           
  i:integer;
begin
  try
    if Application.MessageBox('Вы хотите сохранить изменения?','Сохранение',MB_YESNO)=IDYES then
      begin
        Screen.Cursor:=crAppStart;
        fdb.ADOConnection1.BeginTrans;
        for i:=0 to length(DeleteLessons_IDs)-1 do
          begin  
            if fdb.ADOQuery125.Active then
              fdb.ADOQuery125.Close;
            fdb.ADOQuery125.SQL.Clear;
            fdb.ADOQuery125.SQL.Add('DELETE FROM TrajectLessons WHERE Traject_ID=:1 AND Lessons_ID=:2');
            fdb.ADOQuery125.Parameters.ParamByName('1').Value:=fdb.Traject_ID;
            fdb.ADOQuery125.Parameters.ParamByName('2').Value:=DeleteLessons_IDs[i];
            fdb.ADOQuery125.ExecSQL;
            if fdb.ADOQuery125.Active then
              fdb.ADOQuery125.Close;
          end;
        for i:=0 to length(DeleteLessonsQuestions_IDs)-1 do
          begin
            if fdb.ADOQuery125.Active then
              fdb.ADOQuery125.Close;
            fdb.ADOQuery125.SQL.Clear;
            fdb.ADOQuery125.SQL.Add('DELETE FROM LessonsQuestions WHERE Lesson_ID=:1 AND Question_ID=:2');
            fdb.ADOQuery125.Parameters.ParamByName('1').Value:=DeleteLessonsQuestions_IDs[i];
            fdb.ADOQuery125.Parameters.ParamByName('2').Value:=DeleteQuestion_IDs[i];
            fdb.ADOQuery125.ExecSQL;
            if fdb.ADOQuery125.Active then
              fdb.ADOQuery125.Close;
          end;
        for i:=0 to sTreeView1.Items.Count-1 do
          begin
            if sTreeView1.Items[i].Level=0 then
              Continue;
            if sTreeView1.Items[i].Level=1 then
              begin
                if fdb.ADOQuery125.Active then
                  fdb.ADOQuery125.Close;
                fdb.ADOQuery125.SQL.Clear;
                fdb.ADOQuery125.SQL.Add('DELETE FROM TrajectLessons WHERE Traject_ID=:1 AND Lessons_ID=:2');
                fdb.ADOQuery125.Parameters.ParamByName('1').Value:=integer(sTreeView1.Items[i].Parent.Data);
                fdb.ADOQuery125.Parameters.ParamByName('2').Value:=integer(sTreeView1.Items[i].Data);
                fdb.ADOQuery125.ExecSQL;
                if fdb.ADOQuery125.Active then
                  fdb.ADOQuery125.Close;
                fdb.ADOQuery125.SQL.Clear;
                fdb.ADOQuery125.SQL.Add('INSERT INTO TrajectLessons(Traject_ID, Lessons_ID) VALUES(:1,:2)');
                fdb.ADOQuery125.Parameters.ParamByName('1').Value:=integer(sTreeView1.Items[i].Parent.Data);
                fdb.ADOQuery125.Parameters.ParamByName('2').Value:=integer(sTreeView1.Items[i].Data);
                fdb.ADOQuery125.ExecSQL;
                if fdb.ADOQuery125.Active then
                  fdb.ADOQuery125.Close;
              end;
            if sTreeView1.Items[i].Level=2 then
              begin
                if fdb.ADOQuery125.Active then
                  fdb.ADOQuery125.Close;
                fdb.ADOQuery125.SQL.Clear;
                fdb.ADOQuery125.SQL.Add('DELETE FROM LessonsQuestions WHERE Lesson_ID=:1 AND Question_ID=:2');
                fdb.ADOQuery125.Parameters.ParamByName('1').Value:=integer(sTreeView1.Items[i].Parent.Data);
                fdb.ADOQuery125.Parameters.ParamByName('2').Value:=integer(sTreeView1.Items[i].Data);
                fdb.ADOQuery125.ExecSQL;
                if fdb.ADOQuery125.Active then
                  fdb.ADOQuery125.Close;
                fdb.ADOQuery125.SQL.Clear;
                fdb.ADOQuery125.SQL.Add('INSERT INTO LessonsQuestions(Lesson_ID, Question_ID) VALUES(:1,:2)');
                fdb.ADOQuery125.Parameters.ParamByName('1').Value:=integer(sTreeView1.Items[i].Parent.Data);
                fdb.ADOQuery125.Parameters.ParamByName('2').Value:=integer(sTreeView1.Items[i].Data);
                fdb.ADOQuery125.ExecSQL;
                if fdb.ADOQuery125.Active then
                  fdb.ADOQuery125.Close;
              end;
          end;
      fdb.ADOConnection1.CommitTrans;
     end;
  except
    on E:Exception do
      begin
        fdb.ADOConnection1.RollbackTrans;
        Screen.Cursor:=crDefault;
        ShowMessage(E.Message);
      end;
  end;
  Screen.Cursor:=crDefault;
end;


procedure TMetodistForm.sEdit1Change(Sender: TObject);
begin
  RefreshQuestions;
end;

procedure TMetodistForm.sBitBtn7Click(Sender: TObject);
begin
  if sTreeView1.Selected=Nil then
    begin
      ShowMessage('Задача не выбрана!');
      exit;
    end;
  if sTreeView1.Selected.level=2 then
    begin
      if Application.MessageBox('Вы хотите удалить выбранную задачу?','Удаление',MB_YESNO)=IDYES then
        begin
          SetLength(DeleteLessonsQuestions_IDs,length(DeleteLessonsQuestions_IDs)+1);
          DeleteLessonsQuestions_IDs[length(DeleteLessonsQuestions_IDs)-1]:=integer(sTreeView1.Selected.Parent.Data);
          SetLength(DeleteQuestion_IDs,length(DeleteQuestion_IDs)+1);
          DeleteQuestion_IDs[length(DeleteQuestion_IDs)-1]:=integer(sTreeView1.Selected.Data);
          sTreeView1.Items.Delete(sTreeView1.Selected);
          exit;
        end;
    end
  else
    ShowMessage('Задача не выбрана!');
end;

procedure TMetodistForm.sComboBox1Change(Sender: TObject);
begin
  RefreshQuestions;
end;

procedure TMetodistForm.RefreshQuestions;
begin
  if fdb.ADOQuery100.Active then
    fdb.ADOQuery100.Close;
  fdb.ADOQuery100.SQL.Clear;
  fdb.ADOQuery100.SQL.Add('SELECT DISTINCT Q.ID, Q.Nazvanie AS Nazv, Q.QuestionType_Id,  Q.AnswerType, QT.ID, QT.Nazvanie AS TypeNazvanie, CX.ID, CX.Nazvanie AS CX_Nazvanie, Q.WorkType');
  fdb.ADOQuery100.SQL.Add('FROM Questions AS Q, QuestionTypes AS QT, CompleXity AS CX WHERE QT.ID=Q.QuestionType_ID AND CX.ID=Q.CompleXity_ID AND Q.WorkType<>3');
  if (sComboBox1.ItemIndex<>0) then
    begin
      fdb.ADOQuery100.SQL.ADD('and QT.ID=:2');
      fdb.ADOQuery100.Parameters.ParamByName('2').Value:=IDs_QuestionType[sComboBox1.ItemIndex-1];
    end;
  if (sComboBox2.ItemIndex<>0) then
    begin
      fdb.ADOQuery100.SQL.ADD('and CX.ID=:3');
      fdb.ADOQuery100.Parameters.ParamByName('3').Value:=IDs_CompleXity[sComboBox2.ItemIndex-1];
    end;
  if (sComboBox6.ItemIndex<>0) then
    begin
      fdb.ADOQuery100.SQL.ADD('and Q.WorkType=:4');
      fdb.ADOQuery100.Parameters.ParamByName('4').Value:=sComboBox6.ItemIndex-1;
    end;
  if sEdit1.text <>'' then
    fdb.ADOQuery100.SQL.Add('and Q.Nazvanie LIKE ''' + '%' + sEdit1.Text + '%' + '''ORDER BY QT.Nazvanie');
  fdb.ADOQuery100.Open;
end;

procedure TMetodistForm.sComboBox2Change(Sender: TObject);
begin
  RefreshQuestions;
end;

procedure TMetodistForm.sDBGrid1DblClick(Sender: TObject);
begin
  if (sTreeView1.Selected<>Nil) and (sTreeView1.Selected.Level=1) then
    sBitBtn1Click(Sender);
end;

procedure TMetodistForm.sDBGrid1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  sDBGrid1.Hint:=fdb.ADOQuery100.FieldByName('BriefNazv').AsString;
end;
procedure TMetodistForm.sDBGrid2DblClick(Sender: TObject);
begin
  if (sTreeView1.Selected<>Nil) and (sTreeView1.Selected.Level=0) then
    sBitBtn2Click(Sender);
end;

procedure TMetodistForm.sComboBox6Change(Sender: TObject);
begin
  RefreshQuestions;
end;

end.
