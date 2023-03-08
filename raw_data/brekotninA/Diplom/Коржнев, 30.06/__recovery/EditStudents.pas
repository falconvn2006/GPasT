unit EditStudents;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, Grids, DBGrids, acDBGrid, sComboBox,
  sLabel, sEdit, sGroupBox, sButton, EncdDecd, Data.DB, Vcl.Mask, sMaskEdit,
  sCustomComboEdit;

type
  TfEditStudents = class(TForm)
    bEdit: TsBitBtn;
    bDelete: TsBitBtn;
    bCancel: TsBitBtn;
    sDBGrid1: TsDBGrid;
    sLabel1: TsLabel;
    ComboClass: TsComboBox;
    sGroupBox1: TsGroupBox;
    eLogin: TsEdit;
    eName: TsEdit;
    eOld: TsEdit;
    eClass: TsEdit;
    ePass: TsEdit;
    sBitBtn1: TsBitBtn;
    sButton1: TsButton;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    procedure FormShow(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure ComboClassChange(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure bEditClick(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sDBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fEditStudents: TfEditStudents;

implementation

uses MyDB,ChangeAdminPas;

{$R *.dfm}

procedure TfEditStudents.bCancelClick(Sender: TObject);
begin
  Close();
end;

procedure TfEditStudents.bDeleteClick(Sender: TObject);
begin
  if sDBGrid1.SelectedIndex <> -1 then
    begin
      try
        fdb.ADOQuery1.Open;
        if fdb.ADOQuery1.RecordCount=0 then
          begin
            ShowMessage('Нету пользователей!');
            exit;
          end
        else
          begin
            fdb.ADOConnection1.BeginTrans;
            if Application.MessageBox('Вы уверены?','Удаление',MB_YESNO)=IDYES then
              begin
                fDB.ADODelete.SQL.Clear;
                fDB.ADODelete.SQL.Add('DELETE FROM Continue_Class WHERE User_ID=:1');
                fDB.ADODelete.Parameters.ParamByName('1').Value:=sDBGrid1.DataSource.DataSet['Users.ID'];
                fDB.ADODelete.ExecSQL;

                fDB.ADODelete.SQL.Clear;
                fDB.ADODelete.SQL.Add('DELETE FROM Users WHERE ID=:1');
                fDB.ADODelete.Parameters.ParamByName('1').Value:=sDBGrid1.DataSource.DataSet['Users.ID'];
                fDB.ADODelete.ExecSQL;

                fDB.ADOQuery1.Active:=false;
                fDB.ADOQuery1.Active:=true;
                eLogin.Clear;
                eName.Clear;
                eOld.Clear;
                eClass.Clear;
                ePass.Clear;
             end;
            if fdb.ADOConnection1.InTransaction then
              fdb.ADOConnection1.CommitTrans;
          end;
      except
        on E:Exception do
          begin
            if fdb.ADOConnection1.InTransaction then
              fdb.ADOConnection1.RollbackTrans;
            ShowMessage(E.Message);
            exit;
          end;
      end;

    end;
end;

procedure TfEditStudents.bEditClick(Sender: TObject);
begin
  eLogin.Text:=sDBGrid1.Fields[1].AsString;
  eName.Text:=sDBGrid1.Fields[2].AsString;
  eOld.Text:=sDBGrid1.Fields[3].AsString;
  eClass.Text:=sDBGrid1.Fields[4].AsString;

  ePass.Text:=DecodeString(sDBGrid1.Fields[5].AsString);
end;

procedure TfEditStudents.ComboClassChange(Sender: TObject);
begin
  try
    fDB.ADOQuery1.Close;
    if (ComboClass.Text <> 'Все') then
      begin
        fDB.ADOQuery1.SQL.Clear;
        fDB.ADOQuery1.SQL.Add('SELECT * FROM Users, Groups WHERE Users.Group_ID=Groups.ID and Groups.Nazvanie=''' + ComboClass.Text + ''' ORDER BY User_Login');
        fDB.ADOQuery1.Open;
      end;
    if (ComboClass.Text = 'Все') then
      begin
        fDB.ADOQuery1.SQL.Clear;
        fDB.ADOQuery1.SQL.Add('SELECT * FROM Users, Groups WHERE Users.Group_ID=Groups.ID ORDER BY User_Login');
        fDB.ADOQuery1.Open;
      end;
  except
    on E:Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
  end;
end;


procedure TfEditStudents.FormShow(Sender: TObject);
var
  i:integer;
begin
  try
    fDB.ADOQuery1.Close();
    fDB.ADOQuery1.SQL.Clear;
    fDB.ADOQuery1.SQL.Add('SELECT DISTINCT Groups.ID, Groups.Nazvanie FROM Users, Groups WHERE Users.Group_ID=Groups.ID');
    fDB.ADOQuery1.Open;
    ComboClass.Items.Clear;
    ComboClass.Items.Add('Все');
    fDB.ADOQuery1.First;
    for i:=0 to fDB.ADOQuery1.RecordCount-1 do
      begin
        ComboClass.Items.Add(fDB.ADOQuery1.Fields[1].AsString);
        fDB.ADOQuery1.Next;
      end;
    ComboClass.ItemIndex:=0;
    fDB.ADOQuery1.Close;
    fDB.ADOQuery1.SQL.Clear;
    fDB.ADOQuery1.SQL.Add('SELECT * FROM Users, Groups WHERE Users.Group_ID=Groups.ID ORDER BY User_Login');
    fDB.ADOQuery1.Open;
  except
    on E:Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
  end;
end;

procedure TfEditStudents.sBitBtn1Click(Sender: TObject);
begin
  try
    fdb.ADOConnection1.BeginTrans;
    if Application.MessageBox('Вы действительно хотите сохранить изменения?','Внесение изменений',MB_YESNO)=IDYES then begin
      fDB.ADOQuery1.Edit;
      fDB.ADOQuery1.FieldByName('User_Login').AsString:=eLogin.Text;
      fDB.ADOQuery1.FieldByName('User_Family').AsString:=eName.Text;
      fDB.ADOQuery1.FieldByName('User_Password').AsString:=EncodeString(ePass.Text);
      fDB.ADOQuery1.FieldByName('Age').AsString:=eOld.Text;
      fDB.ADOQuery1.FieldByName('Nazvanie').AsString:=eClass.Text;
      fDB.ADOQuery1.Post;
    end;
    if fdb.ADOConnection1.InTransaction then
      fdb.ADOConnection1.CommitTrans;
  except
    on E:Exception do
      begin
        if fdb.ADOConnection1.InTransaction then
          fdb.ADOConnection1.RollbackTrans;
        ShowMessage(E.Message);
        exit;
      end;
  end;
end;

procedure TfEditStudents.sButton1Click(Sender: TObject);
begin
  fChangeAdminPas.ShowModal;
end;

procedure TfEditStudents.sDBGrid1DblClick(Sender: TObject);
begin
  bEdit.Click;
end;

end.
