unit ClassReports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sGroupBox, Grids, DBGrids, acDBGrid;

type
  TClassReportsForm = class(TForm)
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sBitBtn3: TsBitBtn;
    sBitBtn4: TsBitBtn;
    sBitBtn5: TsBitBtn;
    sDBGrid1: TsDBGrid;
    sBitBtn6: TsBitBtn;
    sBitBtn7: TsBitBtn;
    sBitBtn8: TsBitBtn;
    sBitBtn9: TsBitBtn;
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn4Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sBitBtn6Click(Sender: TObject);
    procedure sBitBtn7Click(Sender: TObject);
    procedure sBitBtn8Click(Sender: TObject);
    procedure sBitBtn9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClassReportsForm: TClassReportsForm;

implementation

uses Utils, MyDB, Entry, MainMenu, Admin;

{$R *.dfm}

procedure TClassReportsForm.FormShow(Sender: TObject);
begin
  if fMainMenu.Visible=false then
    begin
      fDB.ADOQuery190.Close;
      fDB.ADOQuery190.SQL.Clear;
      fDB.ADOQuery190.SQL.Add('SELECT * FROM Users, Groups WHERE Users.Group_ID=Groups.ID ORDER BY User_Login');
      fDB.ADOQuery190.Open;
    end;
   if fMainMenu.DevReport then
   begin
      Caption:='Отчеты по устному счёту';
      sBitBtn1.Visible:=false;
      sBitBtn2.Visible:=false;
      sBitBtn3.Visible:=false;
      sBitBtn4.Visible:=false;
      sBitBtn6.Visible:=false;
      sBitBtn7.Visible:=true;
      sBitBtn8.Visible:=true;
      sBitBtn9.Visible:=true;
   end
   else
   begin
      Caption:='Отчеты по классной работе';
      sBitBtn1.Visible:=true;
      sBitBtn2.Visible:=true;
      sBitBtn3.Visible:=true;
      sBitBtn4.Visible:=true;
      sBitBtn6.Visible:=true;
      sBitBtn7.Visible:=false;
      sBitBtn8.Visible:=false;
      sBitBtn9.Visible:=false;
   end;
   if fMainMenu.Visible then
    begin
    end;
end;

procedure TClassReportsForm.sBitBtn1Click(Sender: TObject);
begin
  ClassReport1;
end;

procedure TClassReportsForm.sBitBtn2Click(Sender: TObject);
begin
  ClassReport2;
end;

procedure TClassReportsForm.sBitBtn4Click(Sender: TObject);
begin
  ClassReport3;
end;

procedure TClassReportsForm.sBitBtn3Click(Sender: TObject);
begin
  ClassReport4;
end;

procedure TClassReportsForm.sBitBtn6Click(Sender: TObject);
begin
  ClassReport11;
end;

procedure TClassReportsForm.sBitBtn7Click(Sender: TObject);
begin
  DevelopmentReport;
end;

procedure TClassReportsForm.sBitBtn8Click(Sender: TObject);
begin
  DevelopmentInterReport;
end;

procedure TClassReportsForm.sBitBtn9Click(Sender: TObject);
begin
   DevelopmentShortReport;
end;

end.
