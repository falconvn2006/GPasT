unit RegNewUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sEdit, sLabel, DB, {DBTables,} Buttons, sBitBtn,
  sSpinEdit, sComboBox, EncdDecd, Vcl.Mask, sMaskEdit, sCustomComboEdit;

type
  TfRegNewUser = class(TForm)
    sLabel1: TsLabel;
    EditName: TsEdit;
    sLabel2: TsLabel;
    EditFamiliya: TsEdit;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    EditPass: TsEdit;
    sLabel6: TsLabel;
    EditPassAgain: TsEdit;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sDecimalSpinEdit1: TsDecimalSpinEdit;
    sComboBox1: TsComboBox;
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sEditNameKeyPress(Sender: TObject; var Key: Char);
    procedure sEditFamiliyaKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    ids_groups: array of Integer;
  end;

var
  fRegNewUser: TfRegNewUser;

implementation

uses Entry, MyDB;

{$R *.dfm}

procedure TfRegNewUser.sBitBtn1Click(Sender: TObject);
var
  group_id:integer;
  temp:string;
begin
  try
    if ((EditName.text<>'')and(EditFamiliya.text<>'')and(sDecimalSpinEdit1.Value<>0)and(sComboBox1.Text<>'')and(EditPass.Text=EditPassAgain.Text)and(EditPass.Text<>'')) then
      begin
        if sComboBox1.ItemIndex=-1 then
          begin
            fDB.ADOQuery1.Close;
            fDB.ADOQuery1.SQL.Clear;
            fDB.ADOQuery1.SQL.Text:='INSERT INTO Groups(Nazvanie) VALUES(:1)';
            fDB.ADOQuery1.Parameters.ParamByName('1').Value := sComboBox1.text;
            fDB.ADOQuery1.ExecSQL;
            fDB.ADOQuery1.SQL.Clear;
            fDB.ADOQuery1.SQL.Text:='SELECT MAX(id) AS max_id FROM Groups';
            fDB.ADOQuery1.open;
            fDB.ADOQuery1.First;
            group_id:=fDB.ADOQuery1.Fieldbyname('max_id').Value;
            fDB.ADOQuery1.Close;
          end
        else
          group_id:=ids_groups[sComboBox1.ItemIndex];
        fDB.ADOQuery1.SQL.Clear;
        fDB.ADOQuery1.SQL.Text:='SELECT MAX(id) AS max_id FROM Groups';
        fDB.ADOQuery1.open;
        fDB.ADOQuery1.First;
        fDB.ADOQuery1.Close;
        fDB.ADOQuery1.SQL.Clear;
        fDB.ADOQuery1.SQL.Text:='INSERT INTO [Users](User_Family, User_Login, User_Password, Group_Id, Age) VALUES(:User_Family, :User_Login, :User_Password, :Group_Id, :Age)';
        fDB.ADOQuery1.Parameters.ParamByName('User_Family').Value := EditName.Text;
        fDB.ADOQuery1.Parameters.ParamByName('User_Login').Value := EditFamiliya.Text;
        temp:=EncodeString(EditPassAgain.Text);
        fDB.ADOQuery1.Parameters.ParamByName('User_Password').Value := temp;
        fDB.ADOQuery1.Parameters.ParamByName('Group_id').Value := group_id;
        fDB.ADOQuery1.Parameters.ParamByName('Age').Value := sDecimalSpinEdit1.Text;
        fDB.ADOQuery1.ExecSQL;
        showmessage('Вы успешно зарегистрированы!');
        Close;
      end
    else
      showmessage('Проверьте правильность введённых данных. Все поля должны быть заполнены!');
  except
    on E:Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
  end;
end;

procedure TfRegNewUser.sBitBtn2Click(Sender: TObject);
begin
  Close();
end;

procedure TfRegNewUser.sEditNameKeyPress(Sender: TObject; var Key: Char);
begin
If (Key in ['0'..'9']) then
begin
  Key:=#0;
  MessageDlg('Ввод  цифр запрещен!', mtError, [mbOk],0);
end;
end;

procedure TfRegNewUser.sEditFamiliyaKeyPress(Sender: TObject; var Key: Char);
begin
If (Key in ['0'..'9']) then
begin
  Key:=#0;
  MessageDlg('Ввод  цифр запрещен!', mtError, [mbOk],0);
end;
end;
procedure TfRegNewUser.FormShow(Sender: TObject);
var
  i:integer;
begin
try
      EditName.Clear;
      EditFamiliya.Clear;
      sDecimalSpinEdit1.Clear;
      EditPass.Clear;
      EditPassAgain.Clear;
      sComboBox1.Clear;
      sComboBox1.ItemIndex:=-1;
      SetLength(ids_groups,0);
      fDB.ADOQuery1.SQL.Clear;
      fDB.ADOQuery1.SQL.Text:='SELECT id, Nazvanie FROM Groups ORDER BY Nazvanie';
      fDB.ADOQuery1.open;
      fDB.ADOQuery1.first;
      for i:=0 to  fDB.ADOQuery1.RecordCount-1 do
      begin
        SetLength(ids_groups,i+1);
        ids_groups[i]:=fDB.ADOQuery1.Fields[0].AsInteger;
        sComboBox1.Items.Add(fDB.ADOQuery1.Fields[1].AsString);
        fDB.ADOQuery1.Next;
      end;
except
    on E:Exception do;
end;
end;

procedure TfRegNewUser.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
fEntry.Visible := true;
end;                   
end.
