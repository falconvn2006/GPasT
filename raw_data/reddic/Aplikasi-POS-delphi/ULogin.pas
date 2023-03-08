unit ULogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzLabel, Vcl.Mask, RzEdit,
  Vcl.ExtCtrls, RzPanel;

type
  TfrmLogin = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    RzEdUsername: TRzEdit;
    RzEdPassword: TRzEdit;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    procedure RzEdUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure RzEdPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation
 Uses UDM,UMain;
{$R *.dfm}

procedure TfrmLogin.RzEdPasswordKeyPress(Sender: TObject; var Key: Char);
var I : Integer;
begin
  if key = Chr(13) then
    begin
      with dm.FDQuGlobal do
      begin
        sql.Clear;
        sql.Add('SELECT * FROM vUsers WHERE iduser =:A AND PASSWORD =:B');
        Params[0].AsString := RzEdUsername.Text;
        Params[1].AsString := RzEdPassword.Text;
        Open;
      end;

      if dm.FDQuGlobal.RecordCount <> 0 then
        begin
          frmMain.vUsers := dm.FDQuGlobal.FieldByName('iduser').AsString;

          dm.FDQuGlobal.First;
          while not dm.FDQuGlobal.Eof do
            begin
              for I := 0 to frmMain.ActionList1.ActionCount - 1 do
                begin
                  if frmMain.ActionList1.Actions[i].Name = dm.FDQuGlobal.FieldByName('formname').AsString then
                  if dm.FDQuGlobal.FieldByName('MARK').AsBoolean then

                  frmMain.ActionList1.Actions[i].Visible := True;
                end;
              dm.FDQuGlobal.Next;
            end;
          Close;
        end

      else
        begin
          MessageDlg('Invalid User or Password!!!',mtWarning,[mbOK],0);
          RzEdUsername.SetFocus;
          Abort;
        end;
    end;

end;


procedure TfrmLogin.RzEdUsernameKeyPress(Sender: TObject; var Key: Char);
begin
      if key = Chr(13) then
      RzEdUsername.SetFocus;
end;

end.
