unit BAR69;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDM_Update = class(TDataModule)
    qSep2020: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM_Update: TDM_Update;

implementation

uses
  BAR04;

{$R *.dfm}

end.
