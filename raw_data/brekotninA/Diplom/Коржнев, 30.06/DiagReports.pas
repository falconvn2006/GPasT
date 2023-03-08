unit DiagReports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sGroupBox, Grids, DBGrids, acDBGrid;

type
  TDiagReportsForm = class(TForm)
    sBitBtn2: TsBitBtn;
    sBitBtn1: TsBitBtn;
    sBitBtn5: TsBitBtn;
    sDBGrid1: TsDBGrid;
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DiagReportsForm: TDiagReportsForm;

implementation

uses Utils, Entry, MyDB, MainMenu;

{$R *.dfm}

procedure TDiagReportsForm.FormShow(Sender: TObject);
begin
  if fMainMenu.Visible=false then
    begin

      //DiagReportsForm.Width:=874;
      fDB.ADOQuery190.Close;
      fDB.ADOQuery190.SQL.Clear;
      fDB.ADOQuery190.SQL.Add('SELECT * FROM Users, Groups WHERE Users.Group_ID=Groups.ID ORDER BY User_Login');
      fDB.ADOQuery190.Open;
    end
  else
    begin

      DiagReportsForm.Width:=442;
    end;
end;

procedure TDiagReportsForm.sBitBtn1Click(Sender: TObject);
begin
  ClassReport8;
end;

procedure TDiagReportsForm.sBitBtn2Click(Sender: TObject);
begin
  ClassReport9;
end;

end.
