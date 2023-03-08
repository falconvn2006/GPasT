unit QuestionEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, sBitBtn, StdCtrls, sButton, sLabel, sEdit, Grids,
  DBGrids, acDBGrid, sComboBox, sMemo, sCheckBox, sRadioButton, ExtCtrls,
  sPanel, sGroupBox, ComCtrls, sTrackBar, sDialogs, Mplayer, sRichEdit, DB, Jpeg,acPng;

type
  TQuestionEditorForm = class(TForm)
    sDBGrid1: TsDBGrid;
    sLabel1: TsLabel;
    sBitBtn1: TsBitBtn;
    sComboBox1: TsComboBox;
    sLabel2: TsLabel;
    sComboBox2: TsComboBox;
    sLabel3: TsLabel;
    sGroupBox1: TsGroupBox;
    sPanel1: TsPanel;
    sEdit1: TsEdit;
    sRadioButton1: TsRadioButton;
    sEdit2: TsEdit;
    sRadioButton2: TsRadioButton;
    sEdit4: TsEdit;
    sRadioButton4: TsRadioButton;
    sEdit5: TsEdit;
    sRadioButton5: TsRadioButton;
    sEdit3: TsEdit;
    sRadioButton3: TsRadioButton;
    sEdit6: TsEdit;
    sRadioButton6: TsRadioButton;
    sPanel3: TsPanel;
    sEdit8: TsEdit;
    sEdit9: TsEdit;
    sEdit10: TsEdit;
    sEdit11: TsEdit;
    sEdit12: TsEdit;
    sEdit13: TsEdit;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sCheckBox3: TsCheckBox;
    sCheckBox4: TsCheckBox;
    sCheckBox5: TsCheckBox;
    sCheckBox6: TsCheckBox;
    sPanel2: TsPanel;
    sEdit7: TsEdit;
    sTrackBar1: TsTrackBar;
    sLabel4: TsLabel;
    sTrackBar2: TsTrackBar;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    sLabel8: TsLabel;
    sLabel9: TsLabel;
    sGroupBox3: TsGroupBox;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sButton4: TsButton;
    sButton5: TsButton;
    sGroupBox2: TsGroupBox;
    sButton6: TsButton;
    sButton7: TsButton;
    sButton8: TsButton;
    sGroupBox4: TsGroupBox;
    sButton9: TsButton;
    sButton10: TsButton;
    sButton11: TsButton;
    sOpenDialog: TsOpenDialog;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Image2: TImage;
    Image1: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    sRadioGroup1: TsRadioGroup;
    sRichEdit1: TsMemo;
    sGroupBox5: TsGroupBox;
    sLabel7: TsLabel;
    eFind: TsEdit;
    sComboBox3: TsComboBox;
    sLabel10: TsLabel;
    sLabel11: TsLabel;
    sComboBox4: TsComboBox;
    sLabel12: TsLabel;
    sComboBox5: TsComboBox;
    sLabel13: TsLabel;
    sComboBox6: TsComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShowAnswers;
    procedure sComboBox2Change(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sTrackBar1Change(Sender: TObject);
    procedure sTrackBar2Change(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure eFindChange(Sender: TObject);
    procedure sButton5Click(Sender: TObject);
    procedure sButton8Click(Sender: TObject);
    procedure sButton7Click(Sender: TObject);
    procedure sButton6Click(Sender: TObject);
    procedure sButton11Click(Sender: TObject);
    procedure sButton10Click(Sender: TObject);
    procedure sButton9Click(Sender: TObject);
    procedure InsertMult(MMType:integer;FileName:string; var MM_ID:integer);
    procedure UpdateMult(MM_ID:Integer;OldMM_ID:integer;FieldName:string);
    procedure sButton12Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sDBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SetPicture(Number:integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure sButton13Click(Sender: TObject);
    procedure sButton14Click(Sender: TObject);
    procedure sDBGrid1DblClick(Sender: TObject);
    procedure sButton15Click(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure sComboBox3Change(Sender: TObject);
    procedure RefreshQuestions;
    procedure sComboBox5Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IDs_QuestionType:array of integer;
    IDs_CompleXity:array of integer;
    IDs_WorkType:array of integer;
    History:array[0..12] of boolean;
    Global_Number:Integer;
  end;

var
  QuestionEditorForm: TQuestionEditorForm;

implementation

uses MyDB, ShowAudio, ShowVideo, ShowPicture, Redact, OptionUser;

{$R *.dfm}

procedure TQuestionEditorForm.eFindChange(Sender: TObject);
begin
  RefreshQuestions;
end;


procedure TQuestionEditorForm.FormCreate(Sender: TObject);
var
  i:integer;
  temp:string;
begin
  if fdb.ADOQuery117.Active then
    fdb.ADOQuery117.close;
  fdb.ADOQuery117.Open;
  if fdb.ADOQuery118.Active then
    fdb.ADOQuery118.close;
  fdb.ADOQuery118.Open;
  if fdb.ADOQuery119.Active then
    fdb.ADOQuery119.close;
  fdb.ADOQuery119.Open;
  SetLength(IDs_QuestionType,fdb.ADOQuery119.RecordCount);
  fdb.ADOQuery119.First;
  sComboBox3.Items.Add('Все');
  for i:=0 to fdb.ADOQuery119.RecordCount-1 do
    begin
      IDs_QuestionType[i]:=fdb.ADOQuery119.FieldByName('ID').AsInteger;
      sComboBox1.Items.Add(fdb.ADOQuery119.FieldByName('Nazvanie').AsString);
      sComboBox3.Items.Add(fdb.ADOQuery119.FieldByName('Nazvanie').AsString);
      fdb.ADOQuery119.Next;
    end;
  sComboBox3.ItemIndex:=0;

  if fdb.ADOQuery1qq.Active then
    fdb.ADOQuery1qq.close;
  fdb.ADOQuery1qq.Open;
  SetLength(IDs_CompleXity,fdb.ADOQuery1qq.RecordCount);
  fdb.ADOQuery1qq.First;
  sComboBox5.Items.Add('Все');
  for i:=0 to fdb.ADOQuery1qq.RecordCount-1 do
    begin
      IDs_CompleXity[i]:=fdb.ADOQuery1qq.FieldByName('ID').AsInteger;
      sComboBox4.Items.Add(fdb.ADOQuery1qq.FieldByName('Nazvanie').AsString);
      sComboBox5.Items.Add(fdb.ADOQuery1qq.FieldByName('Nazvanie').AsString);
      fdb.ADOQuery1qq.Next;
    end;
  sComboBox5.ItemIndex:=0;

  if fdb.ADOQuery2qq.Active then
    fdb.ADOQuery2qq.close;
  fdb.ADOQuery2qq.Open;
  SetLength(IDs_WorkType,fdb.ADOQuery2qq.RecordCount);
  fdb.ADOQuery2qq.First;
  sComboBox6.Items.Add('Все');
  for i:=0 to fdb.ADOQuery2qq.RecordCount-1 do
    begin
      //IDs_WorkType[i]:=fdb.ADOQuery2qq.FieldByName('ID').AsInteger;
      case fdb.ADOQuery2qq.FieldByName('WorkType').AsInteger of
        0:
          temp:='Классная работа';
        1:
          temp:='Самостоятельаня работа';
        2:
          temp:='Диагностика';
        3:
          temp:='Неопределен';
      end;
      sComboBox6.Items.Add(temp);
      fdb.ADOQuery2qq.Next;
    end;
  sComboBox6.ItemIndex:=0;
  for i:=0 to 12 do
    History[i]:=false;
  ShowAnswers;
  SetLength(fdb.Picture_path,13);
end;

procedure TQuestionEditorForm.FormDestroy(Sender: TObject);
begin
  if fdb.ADOQuery118.Active then
    fdb.ADOQuery118.close;
  fdb.ADOQuery118.Open;
  if fdb.ADOQuery117.Active then
    fdb.ADOQuery117.close;
  fdb.ADOQuery117.Open;
  if fdb.ADOQuery119.Active then
    fdb.ADOQuery119.close;
end;

procedure TQuestionEditorForm.FormShow(Sender: TObject);
begin
  RefreshQuestions;
end;

procedure TQuestionEditorForm.ShowAnswers;
begin
  case sComboBox2.ItemIndex of
    0:
      begin
        sPanel1.Visible:=true;
        sPanel1.Enabled:=true;
        sPanel2.Visible:=false;
        sPanel2.Enabled:=false;
        sPanel3.Visible:=false;
        sPanel3.Enabled:=false;
      end;
    1:
      begin
        sPanel1.Visible:=false;
        sPanel1.Enabled:=false;
        sPanel2.Visible:=true;
        sPanel2.Enabled:=true;
        sPanel3.Visible:=false;
        sPanel3.Enabled:=false;
      end;
    2:
      begin
        sPanel1.Visible:=false;
        sPanel1.Enabled:=false;
        sPanel2.Visible:=false;
        sPanel2.Enabled:=false;
        sPanel3.Visible:=true;
        sPanel3.Enabled:=true;
      end;
  end;
end;

procedure TQuestionEditorForm.InsertMult(MMType:integer;FileName:string; var MM_ID:integer);
begin
  if (FileName<>'') and FileExists(FileName)  then
    begin
      if fdb.ADOQueryMult.Active then
        fdb.ADOQueryMult.Close;
      fdb.ADOQueryMult.Open;
      fdb.ADOQueryMult.Insert;
      //TBlobField(fdb.ADOQueryMult.FieldByName('Soderjanie')).LoadFromFile(FileName);
      fdb.ADOQueryMult.FieldByName('Soderjanie').AsString:=StringReplace(FileName, ExtractFilePath(Application.ExeName),'', [rfReplaceAll, rfIgnoreCase]);
      fdb.ADOQueryMult.FieldByName('Type').AsInteger:=MMType;
      //fdb.ADOQueryMult.FieldByName('Extension').AsString:=ExtractFileExt(FileName);
      fdb.ADOQueryMult.Post;
      MM_ID:=fdb.ADOQueryMult.FieldByName('ID').AsInteger;
    end;
end;

procedure TQuestionEditorForm.UpdateMult(MM_ID:Integer;OldMM_ID:integer;FieldName:string);
begin
  if MM_ID <> 0 then
    begin
      fdb.ADOQuery121.SQL.Clear;
      fdb.ADOQuery121.SQL.Add('UPDATE Multim SET Soderjanie=NULL WHERE ID=:1');
      fdb.ADOQuery121.Parameters.ParamByName('1').Value:=OldMM_ID;
      fdb.ADOQuery121.ExecSQL;
      fdb.ADOQuery121.SQL.Clear;
      fdb.ADOQuery121.SQL.Add('DELETE FROM Multim WHERE ID=:1');
      fdb.ADOQuery121.Parameters.ParamByName('1').Value:=OldMM_ID;
      fdb.ADOQuery121.ExecSQL;
      fdb.ADOQuery117.Edit;
      fdb.ADOQuery117.FieldByName(FieldName).AsInteger:=MM_ID;
      fdb.ADOQuery117.Post;
    end;
end;


procedure TQuestionEditorForm.sComboBox2Change(Sender: TObject);
begin
  ShowAnswers;
end;

procedure TQuestionEditorForm.sDBGrid1DblClick(Sender: TObject);
begin
  sButton2Click(Sender);
end;

procedure TQuestionEditorForm.sDBGrid1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  sDBGrid1.Hint:=fdb.ADOQuery117.FieldByName('QuestionNazvanie').AsString;
end;

procedure TQuestionEditorForm.sButton1Click(Sender: TObject);
var
  i,k,count:integer;
  validate:boolean;
  AudioCondition_ID,VideoCondition_ID,PhotoCondition_ID:Integer;
  AudioSolve_ID,VideoSolve_ID,PhotoSolve_ID:integer;
  Theory_ID,TheoryHelp_ID:integer;
  temp:Variant;
begin
  if sRichEdit1.Text='' then
    begin
      ShowMessage('Отсутствует текст вопроса!');
      exit;
    end;
  if sComboBox1.ItemIndex=-1 then
    begin
      ShowMessage('Не выбран тип задачи!');
      exit;
    end;
  if sComboBox4.ItemIndex=-1 then
    begin
      ShowMessage('Не выбрана сложность задачи!');
      exit;
    end;
  if sComboBox2.ItemIndex=-1 then
    begin
      ShowMessage('Не выбран тип ответа!');
      exit;
    end;
  case sComboBox2.ItemIndex of
    0:
      begin
        validate:=true;
        for i := 1 to sTrackBar1.Position do
          begin
           if TsEdit(FindComponent('sEdit' + IntToStr(i))).Text='' then
              begin
                validate:=false;
                break;
              end
          end;
        if validate then
          begin
            count:=0;
            for i := 1 to sTrackBar1.Position do
              begin
                if TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Checked then
                  begin
                    count:=count+1;
                    break;
                  end;
              end;
            if count=0 then
              validate:=false;
          end;
          if not validate then
            begin
              ShowMessage('Некорректно заполенены варианты ответа!');
              exit;
            end;
      end;
    1:
      begin
        if sEdit7.text='' then
          begin
            ShowMessage('Не заполнен вариант ответа!');
            exit;
          end;
      end;
    2:
      begin
        validate:=true;
        for i := 1 to sTrackBar2.Position do
          begin
           if TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Text='' then
              begin
                validate:=false;
                break;
              end
          end;
        if validate then
          begin
            count:=0;
            for i := 1 to sTrackBar2.Position do
              begin
                if TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).State = cbChecked then
                  begin
                    count:=count+1;
                    break;
                  end;
              end;
            if count=0 then
              validate:=false;
          end;
          if not validate then
            begin
              ShowMessage('Некорректно заполенены варианты ответа!');
              exit;
            end;
      end;
  end;
  AudioCondition_ID:=0;
  VideoCondition_ID:=0;
  PhotoCondition_ID:=0;
  AudioSolve_ID:=0;
  VideoSolve_ID:=0;
  PhotoSolve_ID:=0;
  Theory_ID:=0;
  TheoryHelp_ID:=0;
  Screen.Cursor:=crAppStart;
  fdb.ADOConnection1.BeginTrans;
  try
    InsertMult(1,fdb.AudioCondition, AudioCondition_ID);
    InsertMult(1,fdb.AudioSolve, AudioSolve_ID);
    InsertMult(2,fdb.VideoCondition, VideoCondition_ID);
    InsertMult(2,fdb.VideoSolve, VideoSolve_ID);
    InsertMult(3,fdb.PhotoCondition, PhotoCondition_ID);
    InsertMult(3,fdb.PhotoSolve, PhotoSolve_ID);
    InsertMult(4,fdb.Theory, Theory_ID);
    InsertMult(4,fdb.TheoryHelp, TheoryHelp_ID);
    fdb.ADOQuery117.Insert;
    fdb.ADOQuery117.FieldByName('Nazvanie').AsString:=sRichEdit1.Text;
    fdb.ADOQuery117.FieldByName('QuestionType_ID').AsInteger:=IDs_QuestionType[sComboBox1.itemIndex];
    fdb.ADOQuery117.FieldByName('CompleXity_ID').AsInteger:=IDs_CompleXity[sComboBox4.itemIndex];
    fdb.ADOQuery117.FieldByName('AnswerType').AsInteger:=sComboBox2.itemIndex+1;
    if sRadioGroup1.ItemIndex=0 then
      fdb.ADOQuery117.FieldByName('WorkType').AsInteger:=0;
    if sRadioGroup1.ItemIndex=1 then
      fdb.ADOQuery117.FieldByName('WorkType').AsInteger:=1;
    if sRadioGroup1.ItemIndex=2 then
      fdb.ADOQuery117.FieldByName('WorkType').AsInteger:=2;
    if sRadioGroup1.ItemIndex=3 then
      fdb.ADOQuery117.FieldByName('WorkType').AsInteger:=3;
    if Theory_ID<>0 then
      fdb.ADOQuery117.FieldByName('Theory_ID').AsInteger:=Theory_ID;
    if TheoryHelp_ID<>0 then
      fdb.ADOQuery117.FieldByName('TheoryHelp_ID').AsInteger:=TheoryHelp_ID;
    if AudioCondition_ID<>0 then
       fdb.ADOQuery117.FieldByName('ConditionAudio_ID').AsInteger:=AudioCondition_ID;
    if AudioSolve_ID<>0 then
       fdb.ADOQuery117.FieldByName('SolveAudio_Id').AsInteger:=AudioSolve_ID;
    if VideoCondition_ID<>0 then
       fdb.ADOQuery117.FieldByName('ConditionVideo_Id').AsInteger:=VideoCondition_ID;
    if VideoSolve_ID<>0 then
       fdb.ADOQuery117.FieldByName('SolveVideo_Id').AsInteger:=VideoSolve_ID;
    if PhotoCondition_ID<>0 then
       fdb.ADOQuery117.FieldByName('ConditionPhoto_Id').AsInteger:=PhotoCondition_ID;
    if PhotoSolve_ID<>0 then
       fdb.ADOQuery117.FieldByName('SolvePhoto_Id').AsInteger:=PhotoSolve_ID;
    fdb.ADOQuery117.Post;
    fdb.ADOQuery120.Open;
    case sComboBox2.ItemIndex of
      0:
        begin
          for i:=1 to sTrackBar1.Position do
            begin
                fdb.ADOQuery120.insert;
                fdb.ADOQuery120.FieldByName('Nazvanie').AsString:=TsEdit(FindComponent('sEdit' + IntToStr(i))).Text;
                fdb.ADOQuery120.FieldByName('Question_ID').AsInteger:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
                fdb.ADOQuery120.FieldByName('Righted').AsBoolean:=TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Checked;
                if fdb.Picture_path[i-1]<>'' then
                  fdb.ADOQuery120.FieldByName('Picture').AsString:=fdb.Picture_path[i-1];
                fdb.ADOQuery120.Post;
            end;
        end;
      1:
        begin
          fdb.ADOQuery120.insert;
          fdb.ADOQuery120.FieldByName('Nazvanie').AsString:=sEdit7.Text;
          fdb.ADOQuery120.FieldByName('Question_ID').AsInteger:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
          fdb.ADOQuery120.FieldByName('Righted').AsBoolean:=true;
          if fdb.Picture_path[6]<>'' then
            fdb.ADOQuery120.FieldByName('Picture').AsString:=fdb.Picture_path[6];
          fdb.ADOQuery120.Post;
        end;
      2:
        begin
          for i:=1 to sTrackBar2.Position do
            begin
                fdb.ADOQuery120.insert;
                fdb.ADOQuery120.FieldByName('Nazvanie').AsString:=TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Text;
                fdb.ADOQuery120.FieldByName('Question_ID').AsInteger:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
                if TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).State=cbChecked then
                  fdb.ADOQuery120.FieldByName('Righted').AsBoolean:=true
                else
                  fdb.ADOQuery120.FieldByName('Righted').AsBoolean:=false;
                if fdb.Picture_path[i+6]<>'' then
                  fdb.ADOQuery120.FieldByName('Picture').AsString:=fdb.Picture_path[i+6];
                fdb.ADOQuery120.Post;
            end;
        end;
    end;
    if fdb.ADOQueryMult.Active then
      fdb.ADOQueryMult.Close;
    fdb.ADOConnection1.CommitTrans;
    for k:=1 to 13 do
      TImage(FindComponent('Image'+IntToStr(k))).Visible:=false;
      if sPanel1.Visible then
        begin
          for k:=0 to sTrackBar1.Position-1 do
            begin
              if fdb.Picture_path[k]<>'' then
                fdb.Picture_path[k]:='';
            end;
        end;
      if sPanel2.Visible then
        fdb.Picture_path[6]:='';
      if sPanel3.Visible then
        begin
          for k:=0 to sTrackBar2.Position-1 do
            begin
              if fdb.Picture_path[k+7]<>'' then
                fdb.Picture_path[k+7]:='';
            end;
        end;
    sRadioGroup1.ItemIndex:=-1;
    sRichEdit1.text:='';
    eFind.text:='';
    sComboBox1.ItemIndex:=-1;
    sComboBox4.ItemIndex:=-1;
    for i:=1 to 13 do
      TsEdit(FindComponent('sEdit' + IntToStr(i))).Text:=''; 
    sEdit7.text:='';
    if sPanel1.Visible  then
      begin
        for i:=1 to 6 do
          TsRadioButton(FindComponent('sRadioButton'+IntToStr(i))).Checked:=false;
      end;
    if sPanel2.Visible  then
      sEdit7.text:='';
    if sPanel3.Visible  then
      begin
        for i:=1 to 6 do
          TsCheckBox(FindComponent('sCheckBox'+IntToStr(i))).Checked:=false;
      end;
  except
    on E:Exception do
      begin
        fdb.ADOQuery117.Cancel;
        fdb.ADOConnection1.RollbackTrans;
        Screen.Cursor:=crDefault;
        ShowMessage(E.Message);
        exit;
      end;
  end;
  temp:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
  sComboBox3.ItemIndex:=0;
  sComboBox5.ItemIndex:=0;
  RefreshQuestions;
  fdb.ADOQuery117.Locate('Q.ID', temp, [loCaseInsensitive]);
  Screen.Cursor:=crDefault;
  ShowMessage('Вопрос успешно добавлен.');
end;

procedure TQuestionEditorForm.sButton2Click(Sender: TObject);
var
  i:integer;
begin
  sRichEdit1.Text:=fdb.ADOQuery117.FieldByName('Nazvanie').AsString;
  for i:=0 to length(IDs_QuestionType)-1 do
    begin
      if IDs_QuestionType[i]=fdb.ADOQuery117.FieldByName('QuestionType_ID').AsInteger then
        begin
          sComboBox1.ItemIndex:=i;
          break;
        end;
    end;
  for i:=0 to length(IDs_CompleXity)-1 do
    begin
      if IDs_CompleXity[i]=fdb.ADOQuery117.FieldByName('CompleXity_ID').AsInteger then
        begin
          sComboBox4.ItemIndex:=i;
          break;
        end;
    end;

  sComboBox2.ItemIndex:=fdb.ADOQuery117.FieldByName('AnswerType').AsInteger-1;
  if fdb.ADOQuery117.FieldByName('WorkType').AsInteger=0 then
    sRadioGroup1.ItemIndex:=0;
  if fdb.ADOQuery117.FieldByName('WorkType').AsInteger=1 then
    sRadioGroup1.ItemIndex:=1;
  if fdb.ADOQuery117.FieldByName('WorkType').AsInteger=2 then
    sRadioGroup1.ItemIndex:=2;
  if fdb.ADOQuery117.FieldByName('WorkType').AsInteger=3 then
    sRadioGroup1.ItemIndex:=3;
  if sDBGrid1.SelectedIndex<>-1 then
    begin
      if fdb.ADOQuery122.Active then
        fdb.ADOQuery122.Close;
      fdb.ADOQuery122.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
      fdb.ADOQuery122.Open;
      fdb.ADOQuery122.First;
      case fdb.ADOQuery117.FieldByName('AnswerType').AsInteger of
      1:
        begin
          sPanel1.Visible:=true;
          sPanel1.Enabled:=true;
          sPanel2.Visible:=false;
          sPanel3.Visible:=false;
          for i:=1 to 6 do
            begin
              if i<=fdb.ADOQuery122.RecordCount then
                begin
                  TsEdit(FindComponent('sEdit' + IntToStr(i))).Text:=fdb.ADOQuery122.FieldByName('Nazvanie').AsString;
                  TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Checked:=fdb.ADOQuery122.FieldByName('Righted').AsBoolean;
                  fdb.ADOQueryAnsw.Close;
                  fdb.ADOQueryAnsw.SQL.Clear;
                  fdb.ADOQueryAnsw.SQL.Add('SELECT Picture FROM Answers WHERE Question_ID=:1 AND Nazvanie=:2');
                  fdb.ADOQueryAnsw.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
                  fdb.ADOQueryAnsw.Parameters.ParamByName('2').Value:=fdb.ADOQuery122.FieldByName('Nazvanie').AsString;
                  fdb.ADOQueryAnsw.Open;
                  fdb.Picture_path[i-1]:=fdb.ADOQueryAnsw.FieldByName('Picture').AsString;
                  if fdb.Picture_path[i-1]<>'' then
                    TImage(FindComponent('Image'+IntToStr(i))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fdb.Picture_path[i-1]);
                end
              else
                begin
                  TsEdit(FindComponent('sEdit' + IntToStr(i))).Text:='';
                  TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Checked:=false;
                  fdb.Picture_path[i-1]:='';
                end;
              fdb.ADOQuery122.Next;
            end;
            sTrackBar1.Position:=fdb.ADOQuery122.RecordCount;
        end;
      2:
        begin
          sPanel1.Visible:=false;
          sPanel2.Visible:=true;
          sPanel2.Enabled:=true;
          sPanel3.Visible:=false;
          sEdit7.Text:=fdb.ADOQuery122.FieldByName('Nazvanie').AsString;
          fdb.ADOQueryAnsw.Close;
          fdb.ADOQueryAnsw.SQL.Clear;
          fdb.ADOQueryAnsw.SQL.Add('SELECT Picture FROM Answers WHERE Question_ID=:1');
          fdb.ADOQueryAnsw.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
          fdb.ADOQueryAnsw.Open;
          fdb.Picture_path[6]:=fdb.ADOQueryAnsw.FieldByName('Picture').AsString;
          if fdb.Picture_path[6]<>'' then
            TImage(FindComponent('Image'+IntToStr(7))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fdb.Picture_path[6]);
        end;
      3:
        begin
          sPanel1.Visible:=false;
          sPanel2.Visible:=false;
          sPanel3.Visible:=true;
          sPanel3.Enabled:=true;
          sTrackBar2.Position:=fdb.ADOQuery122.RecordCount;
          for i:=1 to 6 do
            begin
              if i<=fdb.ADOQuery122.RecordCount then
                begin
                  TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Text:=fdb.ADOQuery122.FieldByName('Nazvanie').AsString;
                  if fdb.ADOQuery122.FieldByName('Righted').AsBoolean then
                    TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).State:=cbChecked;
                  fdb.ADOQueryAnsw.Close;
                  fdb.ADOQueryAnsw.SQL.Clear;
                  fdb.ADOQueryAnsw.SQL.Add('SELECT Picture FROM Answers WHERE Question_ID=:1 AND Nazvanie=:2');
                  fdb.ADOQueryAnsw.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
                  fdb.ADOQueryAnsw.Parameters.ParamByName('2').Value:=fdb.ADOQuery122.FieldByName('Nazvanie').AsString;
                  fdb.ADOQueryAnsw.Open;
                  fdb.Picture_path[i+6]:=fdb.ADOQueryAnsw.FieldByName('Picture').AsString;
                  if fdb.Picture_path[i+6]<>'' then
                    TImage(FindComponent('Image'+IntToStr(i+7))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fdb.Picture_path[i+6]);
                end
              else
                begin
                  TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).State:=cbUnchecked;
                  TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Text:='';
                end;
                fdb.ADOQuery122.Next;
            end;
            sTrackBar2.Position:=fdb.ADOQuery122.RecordCount;
        end;
      end;
    end;
    sDBGrid1.Enabled:=false;
    sButton2.Visible:=false;
    sButton4.Visible:=true;
    sButton1.Enabled:=false;
    sButton3.Visible:=false;
    sButton5.Visible:=true;
    sGroupBox5.Enabled:=false;
end;

procedure TQuestionEditorForm.sButton3Click(Sender: TObject);
var
  i:integer;
begin
  if (sDBGrid1.SelectedIndex<>-1) and (fdb.ADOQuery117.RecordCount<>0) then
    begin
      fdb.ADOConnection1.BeginTrans;
      try
        if Application.MessageBox('Вы уверены?','Удаление',MB_YESNO)=IDYES then
          begin
            if fdb.ADOQuery121.Active then
              fdb.ADOQuery121.Close;
            fdb.ADOQuery121.SQL.Clear;
            fdb.ADOQuery121.SQL.Add('DELETE FROM LessonsQuestions WHERE Question_ID=:1');
            fdb.ADOQuery121.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
            fdb.ADOQuery121.ExecSQL;

            fdb.ADOQuery121.SQL.Clear;
            fdb.ADOQuery121.SQL.Add('DELETE FROM Continue_Class WHERE ID_Question=:1');
            fdb.ADOQuery121.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
            fdb.ADOQuery121.ExecSQL; 

            fdb.ADOQuery121.SQL.Clear;
            fdb.ADOQuery121.SQL.Add('DELETE FROM Answers WHERE Question_ID=:1');
            fdb.ADOQuery121.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
            fdb.ADOQuery121.ExecSQL;
            if fdb.ADOQuery121.Active then
              fdb.ADOQuery121.Close;
            fdb.ADOQuery121.SQL.Clear;
            fdb.ADOQuery121.SQL.Add('DELETE FROM Questions WHERE ID=:1');
            fdb.ADOQuery121.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
            fdb.ADOQuery121.ExecSQL;
            if fdb.ADOQuery121.Active then
              fdb.ADOQuery121.Close;
            fdb.ADOQuery117.Close;
            fdb.ADOQuery117.Open;
            if sPanel1.Visible  then
              begin
                for i:=1 to 6 do
                  TsRadioButton(FindComponent('sRadioButton'+IntToStr(i))).Checked:=false;
              end;
            if sPanel2.Visible  then
              sEdit7.text:='';
            if sPanel3.Visible  then
              begin
                for i:=1 to 6 do
                  TsCheckBox(FindComponent('sCheckBox'+IntToStr(i))).Checked:=false;
              end;
            sComboBox3.ItemIndex:=0;
            sComboBox5.ItemIndex:=0;
            RefreshQuestions;
            fDB.ADOQuery117.Last;
          end;
      fdb.ADOConnection1.CommitTrans;
      except
        on E:Exception do
          begin
            fdb.ADOConnection1.RollbackTrans;
            fdb.ADOQuery117.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Не выбрана запись!');
end;

procedure TQuestionEditorForm.sButton4Click(Sender: TObject);
var
  i,count:integer;
  validate:boolean;
  AudioCondition_ID,VideoCondition_ID,PhotoCondition_ID:Integer;
  AudioSolve_ID,VideoSolve_ID,PhotoSolve_ID:integer;
  OldAudioCondition_ID,OldVideoCondition_ID,OldPhotoCondition_ID:Integer;
  OldAudioSolve_ID,OldVideoSolve_ID,OldPhotoSolve_ID:integer;
  Theory_ID, OldTheory_ID, TheoryHelp_ID, OldTheoryHelp_ID:integer;
  temp:variant;
begin
  if sRichEdit1.Text='' then
    begin
      ShowMessage('Отсутствует текст вопроса!');
      exit;
    end;
  if sComboBox1.ItemIndex=-1 then
    begin
      ShowMessage('Не выбран тип задачи!');
      exit;
    end;
  if sComboBox4.ItemIndex=-1 then
    begin
      ShowMessage('Не выбрана сложность задачи!');
      exit;
    end;
  if sComboBox2.ItemIndex=-1 then
    begin
      ShowMessage('Не выбран тип ответа!');
      exit;
    end;
  case sComboBox2.ItemIndex of
    0:
      begin
        validate:=true;
        for i := 1 to sTrackBar1.Position do
          begin
           if TsEdit(FindComponent('sEdit' + IntToStr(i))).Text='' then
              begin
                validate:=false;
                break;
              end
          end;
        if validate then
          begin
            count:=0;
            for i := 1 to sTrackBar1.Position do
              begin
                if TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Checked then
                  begin
                    count:=count+1;
                    break;
                  end;
              end;
            if count=0 then
              validate:=false;
          end;
          if not validate then
            begin
              ShowMessage('Некорректно заполенены варианты ответа!');
              exit;
            end;
      end;
    1:
      begin
        if sEdit7.text='' then
          begin
            ShowMessage('Не заполнен вариант ответа!');
            exit;
          end;
      end;
    2:
      begin
        validate:=true;
        for i := 1 to sTrackBar2.Position do
          begin
           if TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Text='' then
              begin
                validate:=false;
                break;
              end
          end;
        if validate then
          begin
            count:=0;
            for i := 1 to sTrackBar2.Position do
              begin
                if TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).State = cbChecked then
                  begin
                    count:=count+1;
                    break;
                  end;
              end;
            if count=0 then
              validate:=false;
          end;
          if not validate then
            begin
              ShowMessage('Некорректно заполенены варианты ответа!');
              exit;
            end;
      end;
  end;
  Screen.Cursor:=crAppStart;
  fdb.ADOConnection1.BeginTrans;
  try
    if Application.MessageBox('Вы уверены?','Сохранение',MB_YESNO)=IDYES then
      begin
        AudioCondition_ID:=0;
        VideoCondition_ID:=0;
        PhotoCondition_ID:=0;
        AudioSolve_ID:=0;
        VideoSolve_ID:=0;
        PhotoSolve_ID:=0;
        Theory_ID:=0;
        TheoryHelp_ID:=0;
        OldAudioCondition_ID:=0;
        OldVideoCondition_ID:=0;
        OldPhotoCondition_ID:=0;
        OldAudioSolve_ID:=0;
        OldVideoSolve_ID:=0;
        OldPhotoSolve_ID:=0;
        OldTheory_ID:=0;
        OldTheoryHelp_ID:=0;
        InsertMult(1, fdb.AudioCondition, AudioCondition_ID);
        InsertMult(1, fdb.AudioSolve, AudioSolve_ID);
        InsertMult(2, fdb.VideoCondition, VideoCondition_ID);
        InsertMult(2, fdb.VideoSolve, VideoSolve_ID);
        InsertMult(3, fdb.PhotoCondition, PhotoCondition_ID);
        InsertMult(3, fdb.PhotoSolve, PhotoSolve_ID);
        InsertMult(4, fdb.Theory, Theory_ID);
        InsertMult(4, fdb.TheoryHelp, TheoryHelp_ID);

        fdb.ADOQuery121.SQL.Clear;
        fdb.ADOQuery121.SQL.Add('DELETE FROM Answers WHERE Question_ID=:1');
        fdb.ADOQuery121.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
        fdb.ADOQuery121.ExecSQL;
        OldAudioCondition_ID:=fdb.ADOQuery117.FieldByName('ConditionAudio_ID').AsInteger;
        OldAudioSolve_ID:=fdb.ADOQuery117.FieldByName('SolveAudio_Id').AsInteger;
        OldVideoCondition_ID:=fdb.ADOQuery117.FieldByName('ConditionVideo_ID').AsInteger;
        OldVideoSolve_ID:=fdb.ADOQuery117.FieldByName('SolveVideo_Id').AsInteger;
        OldPhotoCondition_ID:=fdb.ADOQuery117.FieldByName('ConditionPhoto_Id').AsInteger;
        OldPhotoSolve_ID:=fdb.ADOQuery117.FieldByName('SolvePhoto_Id').AsInteger;
        OldTheory_ID:=fdb.ADOQuery117.FieldByName('Theory_ID').AsInteger;
        OldTheoryHelp_ID:=fdb.ADOQuery117.FieldByName('TheoryHelp_ID').AsInteger;
        fdb.ADOQuery117.Edit;
        fdb.ADOQuery117.FieldByName('Nazvanie').AsString:=sRichEdit1.Text;
        fdb.ADOQuery117.FieldByName('QuestionType_ID').AsInteger:=IDs_QuestionType[sComboBox1.itemIndex];
        fdb.ADOQuery117.FieldByName('CompleXity_ID').AsInteger:=IDs_CompleXity[sComboBox4.itemIndex];
        fdb.ADOQuery117.FieldByName('AnswerType').AsInteger:=sComboBox2.itemIndex+1;
        if sRadioGroup1.ItemIndex=0 then
          fdb.ADOQuery117.FieldByName('WorkType').AsInteger:=0;
        if sRadioGroup1.ItemIndex=1 then
          fdb.ADOQuery117.FieldByName('WorkType').AsInteger:=1;
        if sRadioGroup1.ItemIndex=2 then
          fdb.ADOQuery117.FieldByName('WorkType').AsInteger:=2;
        if sRadioGroup1.ItemIndex=3 then
          fdb.ADOQuery117.FieldByName('WorkType').AsInteger:=3;
        if AudioCondition_ID <> 0 then
          fdb.ADOQuery117.FieldByName('ConditionAudio_ID').Clear;
        if AudioSolve_ID <> 0 then
          fdb.ADOQuery117.FieldByName('SolveAudio_Id').Clear;
        if VideoCondition_ID <> 0 then
          fdb.ADOQuery117.FieldByName('ConditionVideo_ID').Clear;
        if VideoSolve_ID <> 0 then
          fdb.ADOQuery117.FieldByName('SolveVideo_Id').Clear;
        if PhotoCondition_ID <> 0 then
          fdb.ADOQuery117.FieldByName('ConditionPhoto_Id').Clear;
        if PhotoSolve_ID <> 0 then
          fdb.ADOQuery117.FieldByName('SolvePhoto_Id').Clear;
        if Theory_ID<>0 then
          fdb.ADOQuery117.FieldByName('Theory_ID').Clear;
        if TheoryHelp_ID<>0 then
          fdb.ADOQuery117.FieldByName('TheoryHelp_ID').Clear;
        fdb.ADOQuery117.Post;
        UpdateMult(AudioCondition_ID,OldAudioCondition_ID,'ConditionAudio_ID');
        UpdateMult(AudioSolve_ID,OldAudioSolve_ID,'SolveAudio_ID');
        UpdateMult(VideoCondition_ID,OldVideoCondition_ID, 'ConditionVideo_ID');
        UpdateMult(VideoSolve_ID,OldVideoSolve_ID,'SolveVideo_ID');
        UpdateMult(PhotoCondition_ID,OldPhotoCondition_ID,'ConditionPhoto_ID');
        UpdateMult(PhotoSolve_ID,OldPhotoSolve_ID,'SolvePhoto_ID');
        UpdateMult(Theory_ID,OldTheory_ID,'Theory_ID');
        UpdateMult(TheoryHelp_ID,OldTheoryHelp_ID,'TheoryHelp_ID');
        fdb.ADOQuery120.Open;
        case sComboBox2.ItemIndex of
          0:
            begin
              for i:=1 to sTrackBar1.Position do
                begin
                  fdb.ADOQuery120.insert;
                  fdb.ADOQuery120.FieldByName('Nazvanie').AsString:=TsEdit(FindComponent('sEdit' + IntToStr(i))).Text;
                  fdb.ADOQuery120.FieldByName('Question_ID').AsInteger:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
                  fdb.ADOQuery120.FieldByName('Righted').AsBoolean:=TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Checked;
                  if fdb.Picture_path[i-1]<>'' then
                    fdb.ADOQuery120.FieldByName('Picture').AsString:=fdb.Picture_path[i-1];
                  fdb.ADOQuery120.Post;
                end;
            end;
          1:
            begin
              fdb.ADOQuery120.insert;
              fdb.ADOQuery120.FieldByName('Nazvanie').AsString:=sEdit7.Text;
              fdb.ADOQuery120.FieldByName('Question_ID').AsInteger:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
              fdb.ADOQuery120.FieldByName('Righted').AsBoolean:=true;
              if fdb.Picture_path[6]<>'' then
                fdb.ADOQuery120.FieldByName('Picture').AsString:=fdb.Picture_path[6];
              fdb.ADOQuery120.Post;
            end;
          2:
            begin
              for i:=1 to sTrackBar2.Position do
                begin
                  fdb.ADOQuery120.insert;
                  fdb.ADOQuery120.FieldByName('Nazvanie').AsString:=TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Text;
                  fdb.ADOQuery120.FieldByName('Question_ID').AsInteger:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
                  if TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).State=cbChecked then
                    fdb.ADOQuery120.FieldByName('Righted').AsBoolean:=true
                  else
                    fdb.ADOQuery120.FieldByName('Righted').AsBoolean:=false;
                  if fdb.Picture_path[i+6]<>'' then
                    fdb.ADOQuery120.FieldByName('Picture').AsString:=fdb.Picture_path[i+6];
                  fdb.ADOQuery120.Post;
                end;
            end;
        end;
        fdb.ADOConnection1.CommitTrans;  
        sRichEdit1.text:='';
        eFind.text:='';
        sRadioGroup1.ItemIndex:=-1;
        sComboBox1.ItemIndex:=-1;
        sComboBox4.ItemIndex:=-1;
        for i:=1 to 13 do
          TsEdit(FindComponent('sEdit' + IntToStr(i))).Text:=''; 
        sEdit7.text:='';
        if sPanel1.Visible then
          begin
            for i:=0 to sTrackBar1.Position-1 do
              begin
                if fdb.Picture_path[i]<>'' then
                  fdb.Picture_path[i]:='';
                TImage(FindComponent('Image'+IntToStr(i+1))).Picture:=Nil;
              end;
          end;
        if sPanel2.Visible then
          begin
            fdb.Picture_path[6]:='';
            TImage(FindComponent('Image'+IntToStr(7))).Picture:=Nil;
          end;
        if sPanel3.Visible then
          begin
            for i:=0 to sTrackBar2.Position-1 do
              begin
                if fdb.Picture_path[i+7]<>'' then
                  fdb.Picture_path[i+7]:='';
                TImage(FindComponent('Image'+IntToStr(i+8))).Picture:=Nil;
              end;
          end;
        sButton2.Visible:=true;
        sButton4.Visible:=false;
      end;
  except
    on E:Exception do
      begin
        fdb.ADOQuery117.Cancel;
        fdb.ADOConnection1.RollbackTrans;
        ShowMessage(E.Message);
        Screen.Cursor:=crDefault;
        exit;
      end;
  end;
  temp:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
  //sComboBox3.ItemIndex:=0;
  //sComboBox5.ItemIndex:=0;
  //sComboBox6.ItemIndex:=0;
  RefreshQuestions;
  fdb.ADOQuery117.Locate('Q.ID', temp, [loCaseInsensitive]);
  Screen.Cursor:=crDefault;
  sButton5.Click;
end;

procedure TQuestionEditorForm.sButton5Click(Sender: TObject);
var
  i:integer;
begin
  sButton1.Enabled:=true;
  sButton2.Visible:=true;
  sButton3.Visible:=true;
  sButton4.Visible:=false;
  sButton5.Visible:=false;
  sRichEdit1.text:='';
  sComboBox1.ItemIndex:=-1;
  sComboBox4.ItemIndex:=-1;
  if sPanel1.Visible  then
    begin
      for i:=1 to 6 do
        TsRadioButton(FindComponent('sRadioButton'+IntToStr(i))).Checked:=false;
    end;
  if sPanel2.Visible  then
    sEdit7.text:='';
  if sPanel3.Visible  then
    begin
      for i:=1 to 6 do
        TsCheckBox(FindComponent('sCheckBox'+IntToStr(i))).Checked:=false;
    end;
  for i:=1 to 13 do
    TsEdit(FindComponent('sEdit' + IntToStr(i))).Text:='';
  if sPanel1.Visible then
    begin
      for i:=0 to sTrackBar1.Position-1 do
        begin
          if fdb.Picture_path[i]<>'' then
            fdb.Picture_path[i]:='';
          TImage(FindComponent('Image'+IntToStr(i+1))).Picture:=Nil;
        end;
    end;
  if sPanel2.Visible then
    begin
      fdb.Picture_path[6]:='';
      TImage(FindComponent('Image'+IntToStr(7))).Picture:=Nil;
    end;
  if sPanel3.Visible then
    begin
      for i:=0 to sTrackBar2.Position-1 do
        begin
          if fdb.Picture_path[i+7]<>'' then
            fdb.Picture_path[i+7]:='';
          TImage(FindComponent('Image'+IntToStr(i+8))).Picture:=Nil;
        end;
    end;
  sEdit7.text:='';
  sRadioGroup1.ItemIndex:=-1;
  sDBGrid1.Enabled:=true;
  sGroupBox5.Enabled:=true;
end;

procedure TQuestionEditorForm.sTrackBar1Change(Sender: TObject);
var
  i: Integer;
begin
  sLabel8.Caption:=inttostr(sTrackBar1.Position);
  for i := 1 to 6 do
    begin
      if i<=sTrackBar1.Position then
        begin
          TsEdit(FindComponent('sEdit' + IntToStr(i))).Visible:=true;
          TsEdit(FindComponent('sEdit' + IntToStr(i))).Enabled:=true;
          TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Visible:=true;
          TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Enabled:=true;
          TSpeedButton(FindComponent('SpeedButton' + IntToStr(i))).Visible:=true;
          TSpeedButton(FindComponent('SpeedButton' + IntToStr(i))).Enabled:=true;
        end
      else
        begin
          TsEdit(FindComponent('sEdit' + IntToStr(i))).Visible:=false;
          TsEdit(FindComponent('sEdit' + IntToStr(i))).Enabled:=false;
          TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Visible:=false;
          TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Enabled:=false;
          TSpeedButton(FindComponent('SpeedButton' + IntToStr(i))).Visible:=false;
          TSpeedButton(FindComponent('SpeedButton' + IntToStr(i))).Enabled:=false;
        end;
    end;
    //SetLength(fdb.Picture_path,sTrackBar1.Position)
end;

procedure TQuestionEditorForm.sTrackBar2Change(Sender: TObject);
var
  i: Integer;
begin
  sLabel9.Caption:=inttostr(sTrackBar2.Position);
  for i := 1 to 6 do
    begin
      if i<=sTrackBar2.Position then
        begin
          TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Visible:=true;
          TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Enabled:=true;
          TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).Visible:=true;
          TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).Enabled:=true;
          TSpeedButton(FindComponent('SpeedButton' + IntToStr(i+7))).Visible:=true;
          TSpeedButton(FindComponent('SpeedButton' + IntToStr(i+7))).Enabled:=true;
        end
      else
        begin
          TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Visible:=false;
          TsEdit(FindComponent('sEdit' + IntToStr(i+7))).Enabled:=false;
          TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).Visible:=false;
          TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).Enabled:=false;
          TSpeedButton(FindComponent('SpeedButton' + IntToStr(i+7))).Visible:=false;
          TSpeedButton(FindComponent('SpeedButton' + IntToStr(i+7))).Enabled:=false;
        end;
    end;   

end;

procedure TQuestionEditorForm.sButton8Click(Sender: TObject);
begin
  if not (fdb.ADOQuery117.FieldByName('ConditionAudio_ID').IsNull) and (sButton2.Visible=false) then
    begin
      RedactForm:=TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование аудио условия';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
      if sOpenDialog.Execute then
        begin
          fdb.AudioCondition:=sOpenDialog.FileName;
          ShowAudioForm:=TShowAudioForm.Create(nil);
          try
            ShowAudioForm.Mode:=0;
            ShowAudioForm.FileName:=fdb.AudioCondition;
            try
              ShowAudioForm.MediaPlayer1.FileName:=ShowAudioForm.FileName;
              ShowAudioForm.MediaPlayer1.Open;
            except
              ShowMessage('Нераспознанный формат файла!');
              exit;
            end;
            if ShowAudioForm.ShowModal=mrCancel then
              fdb.AudioCondition:='';
            if ShowAudioForm.MediaPlayer1.Mode=mpPlaying then
              ShowAudioForm.MediaPlayer1.Stop;
            finally
              FreeAndNil(ShowAudioForm);
            end;
            if fdb.AudioCondition<>'' then
              ShowMessage('Аудио условие добавлено!');
        end;
    end;
end;

procedure TQuestionEditorForm.sButton7Click(Sender: TObject);
begin
  if not fdb.ADOQuery117.FieldByName('ConditionVideo_ID').IsNull and (sButton2.Visible=false) then
    begin
      RedactForm := TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование видео условия';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
      if sOpenDialog.Execute then
        begin
          fdb.VideoCondition:=sOpenDialog.FileName;
          ShowVideoForm := TShowVideoForm.Create(nil);
          try
            ShowVideoForm.Mode:=0;
            ShowVideoForm.FileName:=fdb.VideoCondition;
            try   
              ShowVideoForm.MediaPlayer1.FileName:=ShowVideoForm.FileName;
              ShowVideoForm.MediaPlayer1.Open;
            except
              ShowMessage('Нераспознанный формат файла!');
              exit;
            end;
            if ShowVideoForm.ShowModal=mrCancel then
              fdb.VideoCondition:='';
            if ShowVideoForm.MediaPlayer1.Mode=mpPlaying then
              ShowVideoForm.MediaPlayer1.Stop;
            finally
              FreeAndNil(ShowVideoForm);
            end;
            if fdb.VideoCondition<>'' then
              ShowMessage('Видео условие добавлено!');
        end;
    end;

end;

procedure TQuestionEditorForm.sButton6Click(Sender: TObject);
begin
  if not fdb.ADOQuery117.FieldByName('ConditionPhoto_ID').IsNull and (sButton2.Visible=false) then
    begin
      RedactForm := TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование фото условия';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
      if sOpenDialog.Execute then
        begin
          fdb.PhotoCondition:=sOpenDialog.FileName;
          ShowPictureForm := TShowPictureForm.Create(nil);
          try
            ShowPictureForm.Mode:=0;
            ShowPictureForm.FileName:=fdb.PhotoCondition;
            try
              ShowPictureForm.Image1.Picture.LoadFromFile(ShowPictureForm.FileName);
            except
              ShowMessage('Нераспознанный формат файла!');
              exit;
            end;
            if ShowPictureForm.ShowModal=mrCancel then
              fdb.PhotoCondition:='';
            finally
              FreeAndNil(ShowPictureForm);
            end;
            if fdb.PhotoCondition<>'' then
              ShowMessage('Иллюстрация условия добавлена!');
        end;
    end; 
end;

procedure TQuestionEditorForm.sButton11Click(Sender: TObject);
begin
  if not fdb.ADOQuery117.FieldByName('SolveAudio_ID').IsNull and (sButton2.Visible=false) then
    begin
      RedactForm := TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование аудио решения';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
      if sOpenDialog.Execute then
        begin
          fdb.AudioSolve:=sOpenDialog.FileName;
          ShowAudioForm := TShowAudioForm.Create(nil);
          try
            ShowAudioForm.Mode:=0;
            ShowAudioForm.FileName:=fdb.AudioSolve;
            try
              ShowAudioForm.MediaPlayer1.FileName:=ShowAudioForm.FileName;
              ShowAudioForm.MediaPlayer1.Open;
            except
              ShowMessage('Нераспознанный формат файла!');
              exit;
            end;
            if ShowAudioForm.ShowModal=mrCancel then
              fdb.AudioSolve:='';
            if ShowAudioForm.MediaPlayer1.Mode=mpPlaying then
              ShowAudioForm.MediaPlayer1.Stop;
          finally
            FreeAndNil(ShowAudioForm);
          end;
          if fdb.AudioSolve<>'' then
            ShowMessage('Аудио решение добавлено!');
        end;
    end;
end;

procedure TQuestionEditorForm.sBitBtn1Click(Sender: TObject);
begin
  if sRichEdit1.Text<>'' then
    begin
        if Application.MessageBox('Вы сохранили задачу?','',MB_YESNO)=IDYES then
          close;
    end
  else
    close;
end;

procedure TQuestionEditorForm.sButton10Click(Sender: TObject);
begin
  if not fdb.ADOQuery117.FieldByName('SolveVideo_ID').IsNull and (sButton2.Visible=false) then
    begin
      RedactForm := TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование видео решения';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
      if sOpenDialog.Execute then
        begin
          fdb.VideoSolve:=sOpenDialog.FileName;
          ShowVideoForm := TShowVideoForm.Create(nil);
          try
            ShowVideoForm.Mode:=0;
            ShowVideoForm.FileName:=fdb.VideoSolve;
            try
              ShowVideoForm.MediaPlayer1.FileName:=ShowVideoForm.FileName;
              ShowVideoForm.MediaPlayer1.Open;
            except
              ShowMessage('Нераспознанный формат файла!');
              exit;
            end;
            if ShowVideoForm.ShowModal=mrCancel then
              fdb.VideoSolve:='';
            if ShowVideoForm.MediaPlayer1.Mode=mpPlaying then
              ShowVideoForm.MediaPlayer1.Stop;
            finally
              FreeAndNil(ShowVideoForm);
            end;
            if fdb.VideoSolve<>'' then
              ShowMessage('Видео решение добавлено!');
        end;
    end;
end;

procedure TQuestionEditorForm.sButton9Click(Sender: TObject);
begin
  if not fdb.ADOQuery117.FieldByName('SolvePhoto_ID').IsNull and (sButton2.Visible=false) then
    begin
      RedactForm := TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование фото решения';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
      if sOpenDialog.Execute then
        begin
          fdb.PhotoSolve:=sOpenDialog.FileName;
          ShowPictureForm:=TShowPictureForm.Create(nil);
          try
            ShowPictureForm.Mode:=0;
            ShowPictureForm.FileName:=fdb.PhotoSolve;
            try
              ShowPictureForm.Image1.Picture.LoadFromFile(ShowPictureForm.FileName);
            except
              ShowMessage('Нераспознанный формат файла!');
              exit;
            end;
            if ShowPictureForm.ShowModal=mrCancel then
              fdb.PhotoSolve:='';
            finally
              FreeAndNil(ShowPictureForm);
            end;
            if fdb.PhotoSolve<>'' then
              ShowMessage('Иллюстрация решение добавлена!');
        end;
    end;
end;

procedure TQuestionEditorForm.sButton12Click(Sender: TObject);
begin
  if not fdb.ADOQuery117.FieldByName('Theory_ID').IsNull and (sButton2.Visible=false) then
    begin
      RedactForm:=TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование теории';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
      if sOpenDialog.Execute then
        begin
          //fdb.Theory:=StringReplace(sOpenDialog.FileName, ExtractFilePath(Application.ExeName), '', [rfReplaceAll, rfIgnoreCase]);
          fdb.Theory:=sOpenDialog.FileName;
          if fdb.Theory<>'' then
            ShowMessage('Теория добавлена!');
        end;
    end;
end;

procedure TQuestionEditorForm.SetPicture(Number:integer);
begin
  if fdb.ADOQueryAnswers.Active then
    fdb.adoqueryAnswers.Close;
  fdb.ADOQueryAnswers.SQL.Clear;
  fdb.ADOQueryAnswers.SQL.Add('SELECT Picture FROM Answers WHERE Question_ID=:1 AND Nazvanie=:2');
  fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=fdb.ADOQuery117.FieldByName('Q.ID').AsInteger;
  if TsEdit(FindComponent('sEdit' + IntToStr(Number))).Text='' then
    begin
      if sPanel1.Visible then
        begin
          ShowMessage('Заполните ответ '+IntToStr(Number));
          Exit;
        end;
      if sPanel2.Visible then
        begin
          ShowMessage('Заполните ответ '+IntToStr(1));
          Exit;
        end;
      if sPanel3.Visible then
        begin
          ShowMessage('Заполните ответ '+IntToStr(Number-7));
          Exit;
        end;
    end;
  fdb.ADOQueryAnswers.Parameters.ParamByName('2').Value:=TsEdit(FindComponent('sEdit' + IntToStr(Number))).Text;
  fdb.ADOQueryAnswers.Open;
  fdb.ADOQueryAnswers.First;
  Global_Number:=Number;
  if (fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'') and (sButton2.Visible=false) then
    begin
      RedactForm:=TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование фото ответа';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      try
        sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
        if sOpenDialog.Execute then
          begin
            fdb.Picture_path[Number-1]:=StringReplace(sOpenDialog.FileName, ExtractFilePath(Application.ExeName), '', [rfReplaceAll, rfIgnoreCase]);
            TImage(FindComponent('Image' + IntToStr(Number))).Visible:=true;
            TImage(FindComponent('Image' + IntToStr(Number))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fdb.Picture_path[Number-1]);
            ShowMessage('Фото ответ добавлен!');
          end;
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;   
      end;
    end;
end;

procedure TQuestionEditorForm.SpeedButton1Click(Sender: TObject);
begin
  SetPicture(1);
end;

procedure TQuestionEditorForm.SpeedButton2Click(Sender: TObject);
begin
  SetPicture(2);
end;

procedure TQuestionEditorForm.SpeedButton3Click(Sender: TObject);
begin
  SetPicture(3);
end;

procedure TQuestionEditorForm.SpeedButton4Click(Sender: TObject);
begin
  SetPicture(4);
end;

procedure TQuestionEditorForm.SpeedButton5Click(Sender: TObject);
begin
  SetPicture(5);
end;

procedure TQuestionEditorForm.SpeedButton6Click(Sender: TObject);
begin
  SetPicture(6);
end;

procedure TQuestionEditorForm.SpeedButton7Click(Sender: TObject);
begin
  SetPicture(7);
end;

procedure TQuestionEditorForm.SpeedButton8Click(Sender: TObject);
begin
  SetPicture(8);
end;

procedure TQuestionEditorForm.SpeedButton9Click(Sender: TObject);
begin
  SetPicture(9);
end;

procedure TQuestionEditorForm.SpeedButton10Click(Sender: TObject);
begin
  SetPicture(10);
end;

procedure TQuestionEditorForm.SpeedButton11Click(Sender: TObject);
begin
  SetPicture(11);
end;

procedure TQuestionEditorForm.SpeedButton12Click(Sender: TObject);
begin
  SetPicture(12);
end;

procedure TQuestionEditorForm.SpeedButton13Click(Sender: TObject);
begin
  SetPicture(13);
end;

procedure TQuestionEditorForm.sButton13Click(Sender: TObject);
begin
  Close;
end;

procedure TQuestionEditorForm.sButton14Click(Sender: TObject);
begin
  sGroupBox2.Visible:=false;
  sGroupBox4.Visible:=false;
  //sButton13.Visible:=true;
  //sButton14.Visible:=false;
end;

procedure TQuestionEditorForm.sButton15Click(Sender: TObject);
begin
  if not fdb.ADOQuery117.FieldByName('TheoryHelp_Id').IsNull and (sButton2.Visible=false) then
    begin
      RedactForm:=TRedactForm.Create(nil);
      try
        RedactForm.Caption:='Редактирование теории подсказки';
        RedactForm.ShowModal;
      finally
        FreeAndNil(RedactForm);
      end;
      Show;
    end
  else
    begin
      sOpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'\';
      if sOpenDialog.Execute then
        begin
          //fdb.Theory:=StringReplace(sOpenDialog.FileName, ExtractFilePath(Application.ExeName), '', [rfReplaceAll, rfIgnoreCase]);
          fdb.TheoryHelp:=sOpenDialog.FileName;
          if fdb.TheoryHelp<>'' then
            ShowMessage('Теория подсказка добавлена!');
        end;
    end;
end;

procedure TQuestionEditorForm.Image1Click(Sender: TObject);
var
  AnswerImage:TImage;
  ImageNumber:integer;
begin
  ShowPictureForm := TShowPictureForm.Create(nil);
    try
      AnswerImage:=Sender As TImage;
      ImageNumber:=StrToInt(StringReplace(AnswerImage.Name, 'Image', '', [rfReplaceAll, rfIgnoreCase]));
      ShowPictureForm.Mode:=0;
      ShowPictureForm.FileName:=fdb.Picture_path[ImageNumber-1];
      try
        ShowPictureForm.Image1.Picture.LoadFromFile(ShowPictureForm.FileName);
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
      ShowPictureForm.ShowModal;
    finally
      FreeAndNil(ShowPictureForm);
    end;
end;

procedure TQuestionEditorForm.RefreshQuestions;
begin
  if fdb.ADOQuery117.Active then
    fdb.ADOQuery117.Close;
  fdb.ADOQuery117.SQL.Clear;
  fdb.ADOQuery117.SQL.Add('SELECT DISTINCT Q.ID, Q.Nazvanie, Q.QuestionType_ID, Q.AnswerType, Q.ConditionAudio_ID, Q.ConditionVideo_ID, Q.ConditionPhoto_ID, Q.SolveAudio_ID, ');
  fdb.ADOQuery117.SQL.Add('Q.SolveVideo_ID, Q.SolvePhoto_ID, Q.WorkType, Q.Theory_ID, Q.TheoryHelp_Id, Q.CompleXity_ID, QT.ID, QT.Nazvanie AS TypeNazvanie, CX.ID, CX.Nazvanie AS CX_Nazvanie');
  fdb.ADOQuery117.SQL.Add('FROM Questions AS Q, QuestionTypes AS QT, CompleXity AS CX WHERE QT.ID=Q.QuestionType_ID AND CX.ID=Q.CompleXity_ID');
  if (sComboBox3.ItemIndex<>0) then
    begin
      fdb.ADOQuery117.SQL.ADD('and QT.ID=:2');
      fdb.ADOQuery117.Parameters.ParamByName('2').Value:=IDs_QuestionType[sComboBox3.ItemIndex-1];
    end;
  if (sComboBox5.ItemIndex<>0) then
    begin
      fdb.ADOQuery117.SQL.ADD('and CX.ID=:3');
      fdb.ADOQuery117.Parameters.ParamByName('3').Value:=IDs_CompleXity[sComboBox5.ItemIndex-1];
    end;
  if (sComboBox6.ItemIndex<>0) then
    begin
      fdb.ADOQuery117.SQL.ADD('and Q.WorkType=:4');
      fdb.ADOQuery117.Parameters.ParamByName('4').Value:=sComboBox6.ItemIndex-1;
    end;
  if eFind.text <>'' then
    fdb.ADOQuery117.SQL.Add('and Q.Nazvanie LIKE ''' + '%' + eFind.Text + '%' + '''ORDER BY QT.Nazvanie');
  fdb.ADOQuery117.Open;
end;

procedure TQuestionEditorForm.sComboBox3Change(Sender: TObject);
begin
  RefreshQuestions;
end;

procedure TQuestionEditorForm.sComboBox5Change(Sender: TObject);
begin
  RefreshQuestions;
end;

end.
