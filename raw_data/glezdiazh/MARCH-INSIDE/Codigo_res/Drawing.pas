unit Drawing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TDraw_frm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Draw_frm: TDraw_frm;

implementation 

uses Main;

{$R *.dfm}

procedure TDraw_frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.ChemToDraw.Destroy;
  Action:=Cafree;
end;

end.
