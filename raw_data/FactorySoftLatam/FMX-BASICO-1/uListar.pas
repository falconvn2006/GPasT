unit uListar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti, FMX.Grid.Style,
  Data.Bind.Controls, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, FMX.Layouts, Fmx.Bind.Navigator,
  FMX.ScrollBox, FMX.Grid;

type
  TfListar = class(TForm)
    Panel3: TPanel;
    Panel1: TPanel;
    GridBindSourceDB1: TGrid;
    Panel2: TPanel;
    NavigatorBindSourceDB1: TBindNavigator;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fListar: TfListar;

implementation

{$R *.fmx}

uses dmData;

procedure TfListar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BindSourceDB1.DataSource.DataSet.Close;
  Action := TCloseAction.caFree;
end;

procedure TfListar.FormCreate(Sender: TObject);
begin
  BindSourceDB1.DataSource.DataSet.Close;
  BindSourceDB1.DataSource.DataSet.Open;
end;

end.
