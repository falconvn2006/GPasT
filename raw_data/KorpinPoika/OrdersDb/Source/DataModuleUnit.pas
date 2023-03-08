unit DataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModule1 = class(TDataModule)
    OrdersDbConnection: TADOConnection;
    OrderTable: TADOTable;
    OrderDataSource: TDataSource;
    ArticulDataSource: TDataSource;
    ClientDataSource: TDataSource;
    ArticulTable: TADOTable;
    ClientTable: TADOTable;
    ArticulTablea_id: TAutoIncField;
    ArticulTablea_name: TWideStringField;
    ClientTablec_id: TAutoIncField;
    ClientTablec_fio: TWideStringField;
    OrderTableo_id: TAutoIncField;
    OrderTableo_datetime: TDateTimeField;
    OrderTableo_client_id: TIntegerField;
    OrderTableo_group_id: TIntegerField;
    OrderTablel_Client: TWideStringField;
    OrderTablel_Articul: TWideStringField;
    ClientHasOrdersQuery: TADOQuery;
    procedure OrderTableNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure ClientTableBeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

uses Dialogs;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.ClientTableBeforeDelete(DataSet: TDataSet);
begin
  ClientHasOrdersQuery.Parameters.ParamByName('ClientId').Value  := ClientTablec_id.Value;
  ClientHasOrdersQuery.Open;

  if ClientHasOrdersQuery.RecordCount > 0 then begin
    ShowMessage('This client has some orders, so it cannot be deleted');
    ClientHasOrdersQuery.Close;
    Abort;
  end;

  ClientHasOrdersQuery.Close;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin

  if Not OrdersDbConnection.Connected
  then OrdersDbConnection.Connected := true;

  ArticulTable.Open;
  ClientTable.Open;
  OrderTable.Open;

  OrderTable.Sort := 'o_datetime';
end;

procedure TDataModule1.OrderTableNewRecord(DataSet: TDataSet);
begin
  OrderTableo_datetime.AsDateTime := Now;
end;

end.
