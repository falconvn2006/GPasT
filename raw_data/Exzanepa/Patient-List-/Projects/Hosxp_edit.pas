unit Hosxp_edit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, DM_hosxp;

type
  THosxp_editmain = class(TForm)
    Panel_edit: TPanel;
    grid_edit: TDBGrid;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Hosxp_editmain: THosxp_editmain;

implementation

{$R *.dfm}

procedure THosxp_editmain.Button1Click(Sender: TObject);
var iCD4,iID:integer;
begin
iID := StrToInt(Inputbox('ID',' ID to change :',''));
iCD4 := StrToInt(Inputbox('value','change CD4 value by:',''));

with dm_database do
begin
  if dm_table.Locate('ID',iID,[])=true then
    begin
      dm_table.Edit;
      dm_table['CD4']:=iCD4;
      dm_table.post;
    end
  else
    begin
      showmessage('not found!');
    end;

end;






end;

end.
