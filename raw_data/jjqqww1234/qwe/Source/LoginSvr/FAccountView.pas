unit FAccountView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrmAccountView = class(TForm)
    EdFindID: TEdit;
    EdFindIP: TEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure EdFindIDKeyPress(Sender: TObject; var Key: char);
    procedure EdFindIPKeyPress(Sender: TObject; var Key: char);
  private
  public
  end;

var
  FrmAccountView: TFrmAccountView;

implementation

{$R *.DFM}


procedure TFrmAccountView.EdFindIDKeyPress(Sender: TObject; var Key: char);
var
  i: integer;
begin
  if Key = #13 then begin
    Key := #0;
    for i := 0 to ListBox1.Items.Count - 1 do begin
      if EdFindID.Text = ListBox1.Items[i] then begin
        ListBox1.ItemIndex := i;
      end;
    end;
  end;
end;

procedure TFrmAccountView.EdFindIPKeyPress(Sender: TObject; var Key: char);
var
  i: integer;
begin
  if Key = #13 then begin
    Key := #0;
    for i := 0 to ListBox2.Items.Count - 1 do begin
      if EdFindIP.Text = ListBox2.Items[i] then begin
        ListBox2.ItemIndex := i;
      end;
    end;
  end;
end;

end.
