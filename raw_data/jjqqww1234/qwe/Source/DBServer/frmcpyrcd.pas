unit frmcpyrcd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFrmCopyRcd = class(TForm)
    Edit1:    TEdit;
    Edit2:    TEdit;
    BitBtn1:  TBitBtn;
    BitBtn2:  TBitBtn;
    Label1:   TLabel;
    Label2:   TLabel;
    Label3:   TLabel;
    EdWithID: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    SrcName, TargName, WithID: string;
    function Execute: boolean;
  end;

var
  FrmCopyRcd: TFrmCopyRcd;

implementation

{$R *.DFM}

function TFrmCopyRcd.Execute: boolean;
begin
  SrcName    := '';
  TargName   := '';
  WithID     := '';
  Edit1.Text := SrcName;
  Edit2.Text := TargName;
  if mrOk = ShowModal then begin
    SrcName  := Edit1.Text;
    TargName := Edit2.Text;
    WithID   := EdWithID.Text;
    Result   := True;
  end else
    Result := False;
end;

procedure TFrmCopyRcd.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

end.
