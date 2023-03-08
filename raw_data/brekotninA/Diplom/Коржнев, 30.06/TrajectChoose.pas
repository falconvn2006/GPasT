unit TrajectChoose;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sGroupBox, ComCtrls, sListView;

type
  TTrajectChooseForm = class(TForm)
    sBitBtn2: TsBitBtn;
    sBitBtn1: TsBitBtn;
    sListView1: TsListView;
    procedure FormShow(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sListView1DblClick(Sender: TObject);
    procedure sListView1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TrajectChooseForm: TTrajectChooseForm;

implementation

uses MyDB, IndReports, MetodistEditor;

{$R *.dfm}

procedure TTrajectChooseForm.FormCreate(Sender: TObject);
begin
  fDB.ADOQuery223.Close;
  fDB.ADOQuery223.SQL.Clear;
  fDB.ADOQuery223.SQL.Add('SELECT ID, Nazvanie, Zoya_level FROM Traject ORDER BY Nazvanie');
  fDB.ADOQuery223.Open;
  fDB.ADOQuery223.First;
  While not fDB.ADOQuery223.Eof do
    begin
      sListView1.AddItem(fDB.ADOQuery223.Fields[1].AsString, TObject(fDB.ADOQuery223.Fields[0].AsInteger));
      fDB.ADOQuery223.Next;
    end;
  fDB.ADOQuery223.Close;
  fDB.ADOQuery223.SQL.Clear;   
  if sListView1.Items.Count>0 then
    sListView1.SelectItem(0);
end;

procedure TTrajectChooseForm.FormShow(Sender: TObject);
begin
  //sListView1.Items.Clear;
  sListView1.SetFocus;
end;

procedure TTrajectChooseForm.sBitBtn2Click(Sender: TObject);
begin
  if sListView1.Selected<>Nil then
    begin
      fdb.Traject_ID:=Integer(sListView1.Selected.Data);
      fDB.ADOQueryTraject.Close;
      fDB.ADOQueryTraject.SQL.Clear;
      fDB.ADOQueryTraject.SQL.ADD('SELECT ID, Nazvanie, Zoya_level FROM Traject ORDER BY Zoya_level');
      fDB.ADOQueryTraject.Open;
      hide;
      MetodistForm:= TMetodistForm.Create(nil);
      try
        MetodistForm.ShowModal;
      finally
        FreeAndNil(MetodistForm);
      end;
      show;
    end
  else
    ShowMessage('Не выбрана запись!');
end;

procedure TTrajectChooseForm.sListView1DblClick(Sender: TObject);
begin
  sBitBtn2Click(Sender);
end;

procedure TTrajectChooseForm.sListView1KeyPress(Sender: TObject; var Key: Char);
begin
 if (Key=#13) and sListView1.Focused then
    sBitBtn2Click(Sender);
end;

end.
