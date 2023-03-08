unit datamodul;

interface

uses
  System.SysUtils, System.Classes, OraCall, Data.DB, DBAccess, Ora;

type
  Tdm = class(TDataModule)
    OraSession1: TOraSession;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
