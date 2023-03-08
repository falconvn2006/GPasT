unit HosxpMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, HosxpLogin, ExtCtrls, StdCtrls, Grids, DBGrids, DB, ADODB,
  Data.FMTBcd, Data.SqlExpr, Data.DBXMySql, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Mask, Vcl.DBCtrls, DM_hosxp, Hosxp_Create, Hosxp_edit  ;

type
  THosxpMains = class(TForm)
    btn_create: TButton;
    btn_update: TButton;
    btn_logout: TButton;
    btn_delete: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    btn_search: TButton;
    Button1: TButton;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    tInput: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btn_createClick(Sender: TObject);
    procedure btn_searchClick(Sender: TObject);
    procedure btn_updateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HosxpMains: THosxpMains;
  iNew : integer;

implementation

{$R *.dfm}

procedure THosxpMains.btn_createClick(Sender: TObject);
begin
  hosxp_add.Show;
end;

procedure THosxpMains.btn_searchClick(Sender: TObject);
var sInput: string;

    bFound: boolean;
begin
sInput := tInput.Text ;
bFound := False;


with dm_database do
begin
  dm_table.First;
  while (NOT dm_table.Eof) AND (bFound = False) do
    begin
      if dm_table['ID'] = sInput then
        begin
          showmessage('Name :'+' '+dm_table['firstname']+' '+dm_table['lastname']+'   '+'Disease :'+' '+dm_table['notice']);
          bFound := true;
        end;

      dm_table.Next;
    end;

if bFound = False then
  showmessage('Not found');
end
end;

procedure THosxpMains.btn_updateClick(Sender: TObject);
begin
  Hosxp_editmain.show;
end;

procedure THosxpMains.FormShow(Sender: TObject);
begin
  HosxpLogins := THosxplogins.Create(self);
  HosxpLogins.ShowModal;
  iNew := HosxpLogins.NewString;
  if iNew = 0 then
  begin
    Application.Terminate;
  end;



end;

end.
