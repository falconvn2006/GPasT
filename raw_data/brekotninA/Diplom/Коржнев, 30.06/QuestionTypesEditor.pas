unit QuestionTypesEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, Grids, DBGrids, acDBGrid, ExtCtrls,
  sPanel, sDBNavigator, sButton, sEdit, sLabel, sGroupBox;

type
  TQuestionTypesEditorForm = class(TForm)
    sBitBtn1: TsBitBtn;
    sLabel1: TsLabel;
    sEdit1: TsEdit;
    sDBGrid1: TsDBGrid;
    sLabel7: TsLabel;
    eFind: TsEdit;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sButton4: TsButton;
    sButton5: TsButton;
    procedure FormShow(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sButton5Click(Sender: TObject);
    procedure eFindChange(Sender: TObject);
    procedure sDBGrid1DblClick(Sender: TObject);
    procedure sDBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QuestionTypesEditorForm: TQuestionTypesEditorForm;

implementation

uses MyDB;

{$R *.dfm}

procedure TQuestionTypesEditorForm.eFindChange(Sender: TObject);
begin
  if fdb.ADOQuery66.Active then
    fdb.ADOQuery66.Close;
  fdb.ADOQuery66.SQL.Clear;
  if EFind.text <>'' then
    fdb.ADOQuery66.SQL.Add('SELECT ID, Nazvanie FROM QuestionTypes WHERE Nazvanie LIKE ''' + '%' + EFind.Text + '%' + '''')
  else
    fdb.ADOQuery66.SQL.Add('SELECT ID, Nazvanie FROM QuestionTypes');
  fdb.ADOQuery66.Open;
end;

procedure TQuestionTypesEditorForm.FormShow(Sender: TObject);
begin
  try
    fDB.ADOQuery66.Close;
    fDB.ADOQuery66.SQL.Clear;
    fDB.ADOQuery66.SQL.Add('SELECT ID,Nazvanie FROM QuestionTypes');
    fDB.ADOQuery66.Open;
  except
    on E:Exception do;
  end;
  if fdb.ADOQuery66.Active then
    fdb.ADOQuery66.Close;
  fdb.ADOQuery66.SQL.Clear;
  if EFind.text <>'' then
    fdb.ADOQuery66.SQL.Add('SELECT ID, Nazvanie FROM QuestionTypes WHERE Nazvanie LIKE ''' + '%' + EFind.Text + '%' + '''')
  else
    fdb.ADOQuery66.SQL.Add('SELECT ID, Nazvanie FROM QuestionTypes');
  fdb.ADOQuery66.Open;
end;

procedure TQuestionTypesEditorForm.sButton1Click(Sender: TObject);
begin
  if sEdit1.Text<>'' then
    begin
      try 
        fdb.ADOQuery66.Insert;
        fdb.ADOQuery66.FieldByName('Nazvanie').AsString:=sEdit1.Text;
        fdb.ADOQuery66.Post;
        ShowMessage('Тип задачи успешно добавлен.');
        sEdit1.Text:='';
        eFind.text:='';
      except
        on E:Exception do
          begin
            fdb.ADOQuery66.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Некорректные значения!');
end;

procedure TQuestionTypesEditorForm.sButton2Click(Sender: TObject);
begin
  if sDBGrid1.SelectedIndex<>-1 then
    sEdit1.Text:=fdb.ADOQuery66.FieldByName('Nazvanie').AsString
  else
    ShowMessage('Не выбрана запись!');
  sButton2.Visible:=false;
  sButton4.Visible:=true;
  sButton1.Enabled:=false;
  sButton3.Visible:=false;
  sButton5.Visible:=true;
  sDBGrid1.Enabled:=false;
end;

procedure TQuestionTypesEditorForm.sButton3Click(Sender: TObject);
begin
  if (sDBGrid1.SelectedIndex<>-1) and (fdb.ADOQuery66.RecordCount<>0) then
    begin
      try
        if Application.MessageBox('Вы уверены?','Удаление',MB_YESNO)=IDYES then
          fdb.ADOQuery66.Delete;
      except
        on E:Exception do
          begin
            fdb.ADOQuery66.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
  else
    ShowMessage('Не выбрана запись!');
end;

procedure TQuestionTypesEditorForm.sButton4Click(Sender: TObject);
begin
if sEdit1.Text<>'' then
    begin
      try
        if Application.MessageBox('Вы уверены?','Сохранение',MB_YESNO)=IDYES then
          begin
            fdb.ADOQuery66.Edit;
            fdb.ADOQuery66.FieldByName('Nazvanie').AsString:=sEdit1.Text;
            fdb.ADOQuery66.Post;
            sButton1.Enabled:=true;
            sButton2.Visible:=true;
            sButton4.Visible:=false;
            sEdit1.Text:='';
            eFind.text:='';
            sButton5.Click;
          end;
      except
        on E:Exception do
          begin
            fdb.ADOQuery66.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Некорректные значения!');
end;

procedure TQuestionTypesEditorForm.sButton5Click(Sender: TObject);
begin
  sButton1.Enabled:=true;
  sButton2.Visible:=true;
  sButton3.Visible:=true;
  sButton4.Visible:=false;
  sButton5.Visible:=false;
  sEdit1.text:='';
  eFind.text:='';
  sDBGrid1.Enabled:=true;
end;

procedure TQuestionTypesEditorForm.sDBGrid1DblClick(Sender: TObject);
begin
  sButton2Click(Sender);
end;

procedure TQuestionTypesEditorForm.sDBGrid1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  sDBGrid1.Hint:=fdb.ADOQuery66.FieldByName('Nazvanie').AsString;
end;

end.
