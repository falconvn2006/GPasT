unit Data.Connection;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, MemDS, UniProvider,
  MySQLUniProvider;

type
  TDataStream = class(TDataModule)
    con: TUniConnection;
    query: TUniQuery;
    sql: TUniSQL;
    dataSource: TUniDataSource;
    mysqlnprvdr: TMySQLUniProvider;
  end;

var
  DataStream: TDataStream;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
