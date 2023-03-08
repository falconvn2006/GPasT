unit DM_hosxp;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  Tdm_database = class(TDataModule)
    dm_connect: TADOConnection;
    dm_table: TADOTable;
    dm_dsc: TDataSource;
    dm_query: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm_database: Tdm_database;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
