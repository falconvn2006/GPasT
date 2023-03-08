unit LessonsEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, sBitBtn, StdCtrls, sButton, sEdit, sLabel, Grids,
  DBGrids, acDBGrid, sGroupBox, sCheckBox, sComboBox, sSpinEdit, Data.DB;

type
  TLessonsEditorForm = class(TForm)
    sDBGrid1: TsDBGrid;
    sLabel1: TsLabel;
    sEdit1: TsEdit;
    sBitBtn1: TsBitBtn;
    sLabel7: TsLabel;
    eFind: TsEdit;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sButton4: TsButton;
    sButton5: TsButton;
    sCheckBox1: TsCheckBox;
    sLabel2: TsLabel;
    sDecimalSpinEdit1: TsDecimalSpinEdit;
    sLabel3: TsLabel;
    sCheckBox2: TsCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sButton5Click(Sender: TObject);
    procedure eFindChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sDBGrid1DblClick(Sender: TObject);
    procedure sDBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sCheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LessonsEditorForm: TLessonsEditorForm;

implementation

uses MyDB;

{$R *.dfm}

procedure TLessonsEditorForm.eFindChange(Sender: TObject);
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

procedure TLessonsEditorForm.FormCreate(Sender: TObject);
begin
  if fdb.ADOQuery116.Active then
    fdb.ADOQuery116.close;
  fdb.ADOQuery116.Open;
end;

procedure TLessonsEditorForm.FormDestroy(Sender: TObject);
begin
  if fdb.ADOQuery116.Active then
    fdb.ADOQuery116.close;
  fdb.ADOQuery116.Open;
end;

procedure TLessonsEditorForm.FormShow(Sender: TObject);
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

procedure TLessonsEditorForm.sButton1Click(Sender: TObject);
begin
  if (sEdit1.Text<>'') and (sDecimalSpinEdit1.Text<>'0') then
    begin
      try
        fdb.ADOQuery116.Insert;
        fdb.ADOQuery116.FieldByName('Nazvanie').AsString:=sEdit1.Text;
        fdb.ADOQuery116.FieldByName('Control').AsBoolean:=sCheckBox1.Checked;
        if sCheckBox2.Checked then
          fdb.ADOQuery116.FieldByName('TimeLeft').AsInteger:=StrToInt(sDecimalSpinEdit1.Text)
        else
          fdb.ADOQuery116.FieldByName('TimeLeft').AsInteger:=0;
        fdb.ADOQuery116.Post;
        ShowMessage('Урок успешно добавлен.');
        sEdit1.Text:='';
        eFind.text:='';
        sCheckBox1.Checked:=false;
        sCheckBox2.Checked:=false;
        sDecimalSpinEdit1.text:='1';
      except
        on E:Exception do
          begin
            fdb.ADOQuery116.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
  else
      ShowMessage('Некорректные значения!');
end;

procedure TLessonsEditorForm.sButton2Click(Sender: TObject);
begin
  if sDBGrid1.SelectedIndex<>-1 then
    begin
      sEdit1.Text:=fdb.ADOQuery116.FieldByName('Nazvanie').AsString;
      sCheckBox1.Checked:=fdb.ADOQuery116.FieldByName('Control').AsBoolean;
      if fdb.ADOQuery116.FieldByName('TimeLeft').AsInteger<>0 then
        begin
          sCheckBox2.Checked:=true;
          sDecimalSpinEdit1.Text:=IntToStr(fdb.ADOQuery116.FieldByName('TimeLeft').AsInteger);
        end
      else
        sCheckBox2.Checked:=false;
    end
  else
    ShowMessage('Не выбрана запись!');
  sDBGrid1.Enabled:=false;
  sButton2.Visible:=false;
  sButton4.Visible:=true;
  sButton1.Enabled:=false;
  sButton3.Visible:=false;
  sButton5.Visible:=true;
end;

procedure TLessonsEditorForm.sButton3Click(Sender: TObject);
begin
  if (sDBGrid1.SelectedIndex<>-1) and (fdb.ADOQuery116.RecordCount<>0) then
    begin
      try
        if Application.MessageBox('Вы уверены?','Удаление',MB_YESNO)=IDYES then
          fdb.ADOQuery116.Delete;
      except
        on E:Exception do
          begin
            fdb.ADOQuery116.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Не выбрана запись!');
end;

procedure TLessonsEditorForm.sButton4Click(Sender: TObject);
begin
  if (sEdit1.Text<>'') and (sDecimalSpinEdit1.Text<>'0') then
    begin
      try
        if Application.MessageBox('Вы уверены?','Сохранение',MB_YESNO)=IDYES then
          begin
            fdb.ADOQuery116.Edit;
            fdb.ADOQuery116.FieldByName('Nazvanie').AsString:=sEdit1.Text;
            fdb.ADOQuery116.FieldByName('Control').AsBoolean:=sCheckBox1.Checked;
            if sCheckBox2.Checked then
              fdb.ADOQuery116.FieldByName('TimeLeft').AsInteger:=StrToInt(sDecimalSpinEdit1.Text)
            else
              fdb.ADOQuery116.FieldByName('TimeLeft').AsInteger:=0;
            fdb.ADOQuery116.Post;
            sButton1.Enabled:=true;
            sButton2.Visible:=true;
            sButton4.Visible:=false;
            sEdit1.Text:='';
            eFind.text:='';
            sCheckBox1.Checked:=false;
            sCheckBox2.Checked:=false;
            sDecimalSpinEdit1.text:='1';;
            sButton5.Click;
          end;
      except
        on E:Exception do
          begin
            fdb.ADOQuery116.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Некорректные значения!'); 
end;

procedure TLessonsEditorForm.sButton5Click(Sender: TObject);
begin
  sButton1.Enabled:=true;
  sButton2.Visible:=true;
  sButton3.Visible:=true;
  sButton4.Visible:=false;
  sButton5.Visible:=false;
  sEdit1.text:='';
  efind.Text:='';
  sCheckBox1.Checked:=false;
  sCheckBox2.Checked:=false;
  sDecimalSpinEdit1.text:='1';
  sDBGrid1.Enabled:=true;
end;

procedure TLessonsEditorForm.sDBGrid1DblClick(Sender: TObject);
begin
  sButton2Click(Sender);
end;

procedure TLessonsEditorForm.sDBGrid1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  sDBGrid1.Hint:=fdb.ADOQuery116.FieldByName('Nazvanie').AsString;
end;

procedure TLessonsEditorForm.sCheckBox2Click(Sender: TObject);
begin
  if sCheckBox2.Checked then
    begin
      sLabel2.Enabled:=true;
      sLabel3.Enabled:=true;
      sDecimalSpinEdit1.Enabled:=true;
    end
  else
    begin
      sLabel2.Enabled:=False;
      sLabel3.Enabled:=False;
      sDecimalSpinEdit1.Enabled:=False;
    end;
end;

end.
