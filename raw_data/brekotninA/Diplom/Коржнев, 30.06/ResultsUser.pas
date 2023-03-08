unit ResultsUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, sTrackBar, StdCtrls, sButton, sGroupBox, MPlayer,
  ExtCtrls, sListBox, Grids, DBGrids, acDBGrid, sLabel, Data.DB;

type
  TForm6 = class(TForm)
    sButton1: TsButton;
    sButton2: TsButton;
    sDBGrid1: TsDBGrid;
    procedure sButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

Uses MyDB;

{$R *.dfm}

procedure TForm6.sButton2Click(Sender: TObject);
begin
  Close();
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
 fdb.ADOQuery200.active:=false;
 fdb.ADOQuery200.active:=true;
 fdb.ADOQuery200.Open;
end;

procedure TForm6.sButton1Click(Sender: TObject);
begin
  if sDBGrid1.SelectedIndex <> -1 then
    begin
      try
        fdb.ADOConnection1.BeginTrans;
        if Application.MessageBox('Вы уверены?','Удаление',MB_YESNO)=IDYES then
          begin
            fDB.ADODelete.SQL.Clear;
            fDB.ADODelete.SQL.Add('DELETE FROM Continue_Class WHERE User_ID=:1');
            fDB.ADODelete.Parameters.ParamByName('1').Value:=sDBGrid1.DataSource.DataSet['Users.ID'];
            fDB.ADODelete.ExecSQL;

            fDB.ADODelete.SQL.Clear;
            fDB.ADODelete.SQL.Add('DELETE FROM Results_Ind WHERE User_ID=:1');
            fDB.ADODelete.Parameters.ParamByName('1').Value:=sDBGrid1.DataSource.DataSet['Users.ID'];
            fDB.ADODelete.ExecSQL;

            fDB.ADODelete.SQL.Clear;
            fDB.ADODelete.SQL.Add('DELETE FROM Results_Class WHERE User_ID=:1');
            fDB.ADODelete.Parameters.ParamByName('1').Value:=sDBGrid1.DataSource.DataSet['Users.ID'];
            fDB.ADODelete.ExecSQL;

            fDB.ADODelete.SQL.Clear;
            fDB.ADODelete.SQL.Add('DELETE FROM Results_Diag WHERE User_ID=:1');
            fDB.ADODelete.Parameters.ParamByName('1').Value:=sDBGrid1.DataSource.DataSet['Users.ID'];
            fDB.ADODelete.ExecSQL;

        Application.MessageBox('Успех!','Результаты удалены.',MB_OK);
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
    end
  else
    ShowMessage('Пользователь не выбран!');
end;

end.
