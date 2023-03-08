unit Entry;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinManager, StdCtrls, sButton, sEdit, sComboBox, Grids, DBGrids,
  acDBGrid, sLabel, DB, ADODB, Buttons, sBitBtn, ExtCtrls, sBevel, sRadioButton,
  IniFiles, {sHintManager,} acMagn, ComCtrls, sListBox, sFontCtrls, Mask,
  sMaskEdit, sCustomComboEdit, sCurrEdit, sSpeedButton, sColorSelect, Registry, EncdDecd;

type          
  TfEntry = class(TForm)
    sSkinManager1: TsSkinManager;
    sDBGrid1: TsDBGrid;
    ComboClass: TsComboBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    EditEnterPas: TsEdit;
    Button1: TButton;
    Button2: TButton;
    bStart: TsBitBtn;
    bReg: TsBitBtn;
    bAdmin: TsBitBtn;
    bExit: TsBitBtn;
   // sHintManager1: TsHintManager;
    sMagnifier1: TsMagnifier;
    sLabel3: TsLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboClassChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bRegClick(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure bAdminClick(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure EditEnterPasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sDBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    Familiy:String;
    Name:String;
  end;

var
  fEntry: TfEntry;
  fs:string;
implementation

uses RegNewUser, MyDB, MainMenu, ISAdminCheckPassword, Utils, Start, Misc;

{$R *.dfm}

procedure TfEntry.bAdminClick(Sender: TObject);
begin
  fISAdminCheckPassword.ShowModal();
end;

procedure TfEntry.bExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfEntry.bRegClick(Sender: TObject);
begin
  fRegNewUser.Visible := True;
  fEntry.Visible := False;
end;

procedure TfEntry.bStartClick(Sender: TObject);
begin
  try
    if (fDB.ADOQuery1.Locate('User_Login;User_Family;User_Password', VarArrayOf([sDBGrid1.Fields[1].AsString,sDBGrid1.Fields[2].AsString,EncodeString(EditEnterPas.Text)]),[])) then
      begin
        fMainMenu.userId := fDB.ADOQuery1.Fields[0].AsInteger;
        fMainMenu.userPassword := EncodeString(EditEnterPas.Text);
        fMainMenu.userFirstName := fDB.ADOQuery1.Fields[1].AsString;
        fMainMenu.userName := fDB.ADOQuery1.Fields[2].AsString;
        fMainMenu.userOld := fDB.ADOQuery1.Fields[5].AsInteger;
        fMainMenu.userClass := sDBGrid1.Fields[4].AsString;
        fMainMenu.sStatusBar1.Panels[0].Text:=trim(fDB.ADOQuery1.Fields[1].AsString)+ ' ' + trim(fDB.ADOQuery1.Fields[2].AsString);
        fEntry.EditEnterPas.Clear;
        fEntry.Familiy := fDB.ADOQuery1.Fields[1].AsString;
        fEntry.Name := fDB.ADOQuery1.Fields[0].AsString;
        fMainMenu.Show;
      end
    else
        Application.MessageBox('Пароль неправильный!','Ошибка авторизации',MB_OK);
  except
    on E:Exception do;
  end;
end;

procedure TfEntry.Button1Click(Sender: TObject);
begin
  sskinmanager1.Active:=true;
end;

procedure TfEntry.Button2Click(Sender: TObject);
begin
  sskinmanager1.Active:=false;
end;

procedure TfEntry.ComboClassChange(Sender: TObject);
begin
  try
    fDB.ADOQuery1.Close;
    EditEnterPas.Clear;
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
    EditEnterPas.SetFocus;
  except
    on E:Exception do;
  end;
end;

procedure TfEntry.EditEnterPasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    bStart.Click;
end;

procedure TfEntry.FormCreate(Sender: TObject);
begin
  Caption:=GetBaseCaption;
  EditEnterPas.Text:='';
end;

procedure TfEntry.FormShow(Sender: TObject);
var
  i:integer;
begin
  try
    Sskinmanager1.SkinName:='XPSilver (internal)';
    EditEnterPas.Text:='';
    if fDB.ADOQuery250.Active then
      fDB.ADOQuery250.Close;
    fDB.ADOQuery250.SQL.Clear;
    fDB.ADOQuery250.SQL.Add('SELECT DISTINCT Groups.ID, Groups.Nazvanie FROM Users, Groups WHERE Users.Group_ID=Groups.ID');
    fDB.ADOQuery250.Open;
    ComboClass.Items.Clear;
    ComboClass.Items.Add('Все');
    fDB.ADOQuery250.First;
    for i:=0 to fDB.ADOQuery250.RecordCount-1 do
      begin
        ComboClass.Items.Add(fDB.ADOQuery250.Fields[1].AsString);
        fDB.ADOQuery250.Next;
      end;
    ComboClass.ItemIndex:=0;
    if fDB.ADOQuery1.Active then
      fDB.ADOQuery1.Close;
    fDB.ADOQuery1.SQL.Clear;
    fDB.ADOQuery1.SQL.Add('SELECT * FROM Users, Groups WHERE Users.Group_ID=Groups.ID ORDER BY User_Login');
    fDB.ADOQuery1.Open;
  except
    on E:Exception do
      ShowMessage(E.Message);
end;
  EditEnterPas.SetFocus;
end;

procedure TfEntry.sDBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  fs:=fs+key;
  sDBGrid1.DataSource.DataSet.Locate('User_Login',fs,[loPartialKey]);
end;

procedure TfEntry.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox('Вы хотите закрыть приложение?','Выход',MB_YESNO)=IDYES then
    begin
      StartForm.Close;
      CanClose:=true;
    end
  else
    CanClose:=false;
end;

end.
