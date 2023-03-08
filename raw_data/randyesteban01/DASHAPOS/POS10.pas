unit POS10;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmNCF = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    ncf : integer;
  end;

var
  frmNCF: TfrmNCF;

implementation

uses POS01;

{$R *.dfm}

procedure TfrmNCF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then
  begin
    ncf := 1;
    close;
  end
  else if key = vk_f2 then
  begin
    ncf := 2;
    close;
  end
  else if key = vk_f6 then
  begin
    ncf := 3;
    close;
  end
  else if key = vk_f9 then
  begin
    ncf := 4;
    close;
  end;
end;

end.
