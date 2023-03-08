unit HotSyncDM;

interface

uses
  SysUtils, Classes, DB, IBDatabase, IBCustomDataSet, IBQuery;

type
  TDMHotSync = class(TDataModule)
    Database: TIBDatabase;
    Transaction: TIBTransaction;
    Query: TIBQuery;
    QueryTables: TIBQuery;

  private

  public

  end;

var
  DMHotSync: TDMHotSync;

implementation

{$R *.dfm}

end.
