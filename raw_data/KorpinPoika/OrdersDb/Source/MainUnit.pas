unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.DBCtrls, DataModuleUnit, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls;

type
  TForm1 = class(TForm)
    OrderDBNavigator: TDBNavigator;
    OrderDBGrid: TDBGrid;
    BitBtn1: TBitBtn;
    MainActionManager: TActionManager;
    AddOrderAction: TAction;
    ClientEditAction: TAction;
    ActionToolBar1: TActionToolBar;
    OrderEditAction: TAction;
    procedure AddOrderActionExecute(Sender: TObject);
    procedure ClientEditActionExecute(Sender: TObject);
    procedure OrderEditActionExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ClientEditorForm, OrderEditorForm;

{$R *.dfm}

procedure TForm1.AddOrderActionExecute(Sender: TObject);
begin
  if DataModule1.OrderTable.State <> dsInsert then begin
    DataModule1.OrderTable.Append;
  end;

  OrderEditor.ShowModal;
end;

procedure TForm1.OrderEditActionExecute(Sender: TObject);
begin
  if DataModule1.OrderTable.State <> dsEdit
  then DataModule1.OrderTable.Edit;

  OrderEditor.ShowModal;
end;

procedure TForm1.ClientEditActionExecute(Sender: TObject);
begin
  ClientEditor.ShowModal;
end;

end.
