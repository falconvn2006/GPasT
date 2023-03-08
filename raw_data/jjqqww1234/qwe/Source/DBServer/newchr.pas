unit newchr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrmNewChr = class(TForm)
    EdName:  TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdNameKeyPress(Sender: TObject; var Key: char);
  private
    { Private declarations }
  public
    NewName: string;
    function NewChar(var newname: string): boolean;
  end;

var
  FrmNewChr: TFrmNewChr;

implementation

{$R *.DFM}

function TFrmNewChr.NewChar(var newname: string): boolean;
begin
  EdName.Text := '';
  ShowModal;
  NewName := EdName.Text;
  if NewName <> '' then
    Result := True
  else
    Result := False;
end;

procedure TFrmNewChr.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmNewChr.EdNameKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    Button1Click(self);
end;

procedure TFrmNewChr.FormShow(Sender: TObject);
begin
  EdName.SetFocus;
end;

end.
