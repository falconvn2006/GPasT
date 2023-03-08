unit IndReports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sGroupBox, Grids, DBGrids, acDBGrid;

type
  TIndReportsForm = class(TForm)
    sGroupBox1: TsGroupBox;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sBitBtn4: TsBitBtn;
    sBitBtn5: TsBitBtn;
    sGroupBox2: TsGroupBox;
    sDBGrid1: TsDBGrid;
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IndReportsForm: TIndReportsForm;

implementation

uses Utils, Entry, MyDB, MainMenu;

{$R *.dfm}

procedure TIndReportsForm.FormShow(Sender: TObject);
begin
  if fMainMenu.Visible=false then
    begin
      sGroupBox2.Visible:=true;
   //   IndReportsForm.Width:=895;
      fDB.ADOQuery190.Close;
      fDB.ADOQuery190.SQL.Clear;
      fDB.ADOQuery190.SQL.Add('SELECT * FROM Users, Groups WHERE Users.Group_ID=Groups.ID ORDER BY User_Login');
      fDB.ADOQuery190.Open;
    end
  else
    begin
      sGroupBox2.Visible:=false;
      IndReportsForm.Width:=426;
    end;
end;

procedure TIndReportsForm.sBitBtn1Click(Sender: TObject);
begin
  ClassReport5;
end;

procedure TIndReportsForm.sBitBtn2Click(Sender: TObject);
begin
  ClassReport6;
end;

procedure TIndReportsForm.sBitBtn4Click(Sender: TObject);
begin
  ClassReport7;
end;

end.
