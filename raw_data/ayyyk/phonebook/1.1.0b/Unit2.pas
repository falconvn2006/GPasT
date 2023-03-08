unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ShellAPI;

type
  TInform = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    BitBtn1: TBitBtn;
    procedure Label8MouseEnter(Sender: TObject);
    procedure Label8MouseLeave(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  end;

var
  Inform: TInform;

implementation

{$R *.dfm}

procedure TInform.Label8MouseEnter(Sender: TObject);
begin
  Label8.Font.Style:=[fsUnderline];
end;

procedure TInform.Label8MouseLeave(Sender: TObject);
begin
  Label8.Font.Style:=[];
end;

procedure TInform.Label8Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','mailto:Kovylyayev@rambler.ru', nil, nil, SW_SHOWNORMAL);
end;

procedure TInform.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Close;
end;

end.
