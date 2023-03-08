unit CompleXityEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, Grids, DBGrids, acDBGrid, sSpinEdit,
  sLabel, sButton, sEdit, sGroupBox;

type
  TCompleXityEditorForm = class(TForm)
    sDBGrid1: TsDBGrid;
    sBitBtn1: TsBitBtn;
    sEdit1: TsEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sDecimalSpinEdit1: TsDecimalSpinEdit;
    sLabel7: TsLabel;
    eFind: TsEdit;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sButton4: TsButton;
    sButton5: TsButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton5Click(Sender: TObject);
    procedure eFindChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sDBGrid1DblClick(Sender: TObject);
    procedure sDBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CompleXityEditorForm: TCompleXityEditorForm;

implementation

uses MyDB, Admin;

{$R *.dfm}

procedure TCompleXityEditorForm.eFindChange(Sender: TObject);
begin
  if fdb.ADOQuery113.Active then
    fdb.ADOQuery113.Close;
  fdb.ADOQuery113.SQL.Clear;
  if EFind.text <>'' then
    fdb.ADOQuery113.SQL.Add('SELECT ID, Nazvanie, Question_Level FROM CompleXity WHERE Nazvanie LIKE ''' + '%' + EFind.Text + '%' + '''')
  else
    fdb.ADOQuery113.SQL.Add('SELECT ID, Nazvanie, Question_Level FROM CompleXity');
  fdb.ADOQuery113.Open;
end;

procedure TCompleXityEditorForm.FormCreate(Sender: TObject);
begin
  {if fdb.ADOQuery113.Active then
    fdb.ADOQuery113.close;
  fdb.ADOQuery113.Open;}
end;

procedure TCompleXityEditorForm.FormDestroy(Sender: TObject);
begin
  if fdb.ADOQuery113.Active then
    fdb.ADOQuery113.close;
end;

procedure TCompleXityEditorForm.FormShow(Sender: TObject);
begin
  if fdb.ADOQuery113.Active then
    fdb.ADOQuery113.Close;
  fdb.ADOQuery113.SQL.Clear;
  if EFind.text <>'' then
    fdb.ADOQuery113.SQL.Add('SELECT ID, Nazvanie, Question_Level FROM CompleXity WHERE Nazvanie LIKE ''' + '%' + EFind.Text + '%' + ''' ORDER BY Question_Level')
  else
    fdb.ADOQuery113.SQL.Add('SELECT ID, Nazvanie, Question_Level FROM CompleXity ORDER BY Question_Level');
  fdb.ADOQuery113.Open;
end;

procedure TCompleXityEditorForm.sButton1Click(Sender: TObject);
begin
  if (sEdit1.Text<>'') and ((sDecimalSpinEdit1.Value>=0) and (sDecimalSpinEdit1.Value<=255)) then
    begin
      try
        fdb.ADOQuery113.Insert;
        fdb.ADOQuery113.FieldByName('Nazvanie').AsString:=sEdit1.Text;
        fdb.ADOQuery113.FieldByName('Question_Level').AsInteger:=Trunc(sDecimalSpinEdit1.value);
        fdb.ADOQuery113.Post;
        ShowMessage('Сложность успешно добавлена.');
        sEdit1.Text:='';
        sDecimalSpinEdit1.value:=0;
        eFind.text:='';
      except
        on E:Exception do
          begin
            fdb.ADOQuery113.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Некорректные значения!');
end;
procedure TCompleXityEditorForm.sButton2Click(Sender: TObject);
begin
  if sDBGrid1.SelectedIndex<>-1 then
    begin
      sEdit1.Text:=fdb.ADOQuery113.FieldByName('Nazvanie').AsString;
      sDecimalSpinEdit1.value:=fdb.ADOQuery113.FieldByName('Question_Level').AsInteger;
    end
    else
      ShowMessage('Не выбрана запись!');
    sButton2.Visible:=false;
    sButton4.Visible:=true;
    sButton1.Enabled:=false;
    sButton3.Visible:=false;
    sButton5.Visible:=true;
    sDBGrid1.Enabled:=false;
end;

procedure TCompleXityEditorForm.sButton4Click(Sender: TObject);
begin
  if (sEdit1.Text<>'') and ((sDecimalSpinEdit1.Value>=0) and (sDecimalSpinEdit1.Value<=255)) then
    begin
      try
        if Application.MessageBox('Вы уверены?','Сохранение',MB_YESNO)=IDYES then
          begin
            fdb.ADOQuery113.Edit;
            fdb.ADOQuery113.FieldByName('Nazvanie').AsString:=sEdit1.Text;
            fdb.ADOQuery113.FieldByName('Question_Level').AsInteger:=Trunc(sDecimalSpinEdit1.value);
            fdb.ADOQuery113.Post;
            sButton1.Enabled:=true;
            sButton2.Visible:=true;
            sButton4.Visible:=false;
            sEdit1.Text:='';
            sDecimalSpinEdit1.value:=0;
            eFind.text:='';
            sButton5.Click;
          end;
      except
        on E:Exception do
          begin
            fdb.ADOQuery113.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
  else
      ShowMessage('Некорректные значения!');
end;

procedure TCompleXityEditorForm.sButton5Click(Sender: TObject);
begin
  sButton1.Enabled:=true;
  sButton2.Visible:=true;
  sButton3.Visible:=true;
  sButton4.Visible:=false;
  sButton5.Visible:=false;
  sEdit1.text:='';
  sDecimalSpinEdit1.value:=0;
  efind.Text:='';
  sDBGrid1.Enabled:=true;
end;

procedure TCompleXityEditorForm.sDBGrid1DblClick(Sender: TObject);
begin
  sButton2Click(Sender);
end;

procedure TCompleXityEditorForm.sButton3Click(Sender: TObject);
begin
  if (sDBGrid1.SelectedIndex<>-1) and (fdb.ADOQuery113.RecordCount<>0) then
    begin
      try
        if Application.MessageBox('Вы уверены?','Удаление',MB_YESNO)=IDYES then
          fdb.ADOQuery113.Delete;
      except
        on E:Exception do
          begin
            fdb.ADOQuery113.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Не выбрана запись!');
end;

procedure TCompleXityEditorForm.sDBGrid1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  sDBGrid1.Hint:=fdb.ADOQuery113.FieldByName('Nazvanie').AsString;
end;

end.
