unit TrajectEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, sBitBtn, sSpinEdit, StdCtrls, sEdit, sButton, sLabel,
  Grids, DBGrids, acDBGrid, DBCtrls, sDBLookupComboBox, sComboBox, sGroupBox;

type
  TTrajectEditorForm = class(TForm)
    sDBGrid1: TsDBGrid;
    sBitBtn1: TsBitBtn;
    eFind: TsEdit;
    sLabel7: TsLabel;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sButton4: TsButton;
    sButton5: TsButton;
    sLabel3: TsLabel;
    sComboBox2: TsComboBox;
    sEdit1: TsEdit;
    sLabel1: TsLabel;
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
  private
    { Private declarations }
  public
    { Public declarations }
  IDs:array of integer;
  IDs_Traject_level:array of integer;
  end;

var
  TrajectEditorForm: TTrajectEditorForm;

implementation

uses MyDB, DB;

{$R *.dfm}

procedure TTrajectEditorForm.eFindChange(Sender: TObject);
begin
  if fdb.ADOQuery114.Active then
    fdb.ADOQuery114.Close;
  fdb.ADOQuery114.SQL.Clear;
  if EFind.text <>'' then
    fdb.ADOQuery114.SQL.Add('SELECT ID, Nazvanie, Zoya_Level FROM Traject WHERE Nazvanie LIKE ''' + '%' + EFind.Text + '%' + '''')
  else
    fdb.ADOQuery114.SQL.Add('SELECT ID, Nazvanie, Zoya_Level FROM Traject');
  fdb.ADOQuery114.Open;
end;

procedure TTrajectEditorForm.FormCreate(Sender: TObject);
var
  i:integer;
begin
  if fdb.ADOQuery113.Active then
    fdb.ADOQuery113.close;
  fdb.ADOQuery113.Open;
  if fdb.ADOQuery114.Active then
    fdb.ADOQuery114.close;
  fdb.ADOQuery114.Open;
  if fdb.ADOQuery115.Active then
    fdb.ADOQuery115.close;
  fdb.ADOQuery115.Open;
  SetLength(IDs,fdb.ADOQuery115.RecordCount);
  fdb.ADOQuery115.First;

  if fdb.ADOQuery171.Active then
    fdb.ADOQuery171.close;
  fdb.ADOQuery171.Open;
  SetLength(IDs_Traject_level,fdb.ADOQuery171.RecordCount);
  fdb.ADOQuery171.First;
  {for i:=0 to fdb.ADOQuery115.RecordCount-1 do
    begin
      IDs[i]:=fdb.ADOQuery115.FieldByName('ID').AsInteger;
      sComboBox1.Items.Add(fdb.ADOQuery115.FieldByName('Nazvanie').AsString);
      fdb.ADOQuery115.Next;
    end;}

  sComboBox2.Items.Clear;
  sComboBox2.Items.Add('1-ый класс');
  sComboBox2.Items.Add('2-ой класс');
  sComboBox2.Items.Add('3-ий класс');
  sComboBox2.Items.Add('4-ый класс');
  sComboBox2.Items.Add('5-ый класс');
  sComboBox2.Items.Add('6-ой класс');
  sComboBox2.Items.Add('7-ой класс');
  sComboBox2.Items.Add('8-ой класс');
  sComboBox2.Items.Add('9-ый класс');
  sComboBox2.Items.Add('10-ый класс');
  sComboBox2.Items.Add('11-ый класс');
  sComboBox2.ItemIndex:=-1;
  for i:=0 to fdb.ADOQuery171.RecordCount-1 do
    begin
      IDs_Traject_level[i]:=fdb.ADOQuery171.FieldByName('Zoya_level').AsInteger;
      fdb.ADOQuery171.Next;
    end;

end;

procedure TTrajectEditorForm.FormDestroy(Sender: TObject);
begin
  if fdb.ADOQuery114.Active then
    fdb.ADOQuery114.close;
  fdb.ADOQuery114.Open;
  if fdb.ADOQuery113.Active then
    fdb.ADOQuery113.close;
  fdb.ADOQuery113.Open;
  if fdb.ADOQuery115.Active then
    fdb.ADOQuery115.close;
  fdb.ADOQuery115.Open;
end;

procedure TTrajectEditorForm.FormShow(Sender: TObject);
begin
 if fdb.ADOQuery114.Active then
    fdb.ADOQuery114.Close;
  fdb.ADOQuery114.SQL.Clear;
  if EFind.text <>'' then
    fdb.ADOQuery114.SQL.Add('SELECT ID, Nazvanie, Zoya_Level FROM Traject WHERE Nazvanie LIKE ''' + '%' + EFind.Text + '%' + '''')
  else
    fdb.ADOQuery114.SQL.Add('SELECT ID, Nazvanie, Zoya_Level FROM Traject');
  fdb.ADOQuery114.Open;
end;

procedure TTrajectEditorForm.sButton1Click(Sender: TObject);
begin
  if (sEdit1.Text<>'') and (sComboBox2.ItemIndex<>-1) then
    begin
      try
        fdb.ADOQuery114.Insert;
        fdb.ADOQuery114.FieldByName('Nazvanie').AsString:=sEdit1.Text;
        fdb.ADOQuery114.FieldByName('Zoya_Level').AsInteger:=sComboBox2.ItemIndex;
        fdb.ADOQuery114.Post;
        ShowMessage('Траектория успешно добавлена.');
        sEdit1.Text:='';
        eFind.text:='';
        sComboBox2.ItemIndex:=-1;
      except
        on E:Exception do
          begin
            fdb.ADOQuery114.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Некорректные значения!');
end;

procedure TTrajectEditorForm.sButton2Click(Sender: TObject);
begin
  if sDBGrid1.SelectedIndex<>-1 then
    begin
      sEdit1.Text:=fdb.ADOQuery114.FieldByName('Nazvanie').AsString;
      sComboBox2.ItemIndex:=fdb.ADOQuery114.FieldByName('Zoya_level').AsInteger;
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


procedure TTrajectEditorForm.sButton3Click(Sender: TObject);
begin
  if (sDBGrid1.SelectedIndex<>-1) and (fdb.ADOQuery114.RecordCount<>0) then
    begin
      try
        if Application.MessageBox('Вы уверены?','Удаление',MB_YESNO)=IDYES then
          fdb.ADOQuery114.Delete;
      except
        on E:Exception do
          begin
            fdb.ADOQuery114.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Не выбрана запись!');
end;

procedure TTrajectEditorForm.sButton4Click(Sender: TObject);
begin
    if sEdit1.Text<>'' then
    begin
      try
        if Application.MessageBox('Вы уверены?','Сохранение',MB_YESNO)=IDYES then
          begin
            fdb.ADOQuery114.Edit;
            fdb.ADOQuery114.FieldByName('Nazvanie').AsString:=sEdit1.Text;
            fdb.ADOQuery114.FieldByName('Zoya_level').AsInteger:=sComboBox2.ItemIndex;
            fdb.ADOQuery114.Post;
            sButton1.Enabled:=true;
            sButton2.Visible:=true;
            sButton4.Visible:=false;
            sEdit1.Text:='';
            eFind.text:='';
            sComboBox2.ItemIndex:=-1;
            sButton5.Click;
          end;
      except
        on E:Exception do
          begin
            fdb.ADOQuery114.Cancel;
            ShowMessage(E.Message);
          end;
      end;
    end
    else
      ShowMessage('Некорректные значения!');
end;

procedure TTrajectEditorForm.sButton5Click(Sender: TObject);
begin
  sButton1.Enabled:=true;
  sButton2.Visible:=true;
  sButton3.Visible:=true;
  sButton4.Visible:=false;
  sButton5.Visible:=false;
  sComboBox2.ItemIndex:=-1;
  sEdit1.text:='';
  efind.Text:='';
  sDBGrid1.Enabled:=true;
end;

procedure TTrajectEditorForm.sDBGrid1DblClick(Sender: TObject);
begin
  sButton2Click(Sender);
end;

procedure TTrajectEditorForm.sDBGrid1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  sDBGrid1.Hint:=fdb.ADOQuery114.FieldByName('Nazvanie').AsString;
end;

end.
