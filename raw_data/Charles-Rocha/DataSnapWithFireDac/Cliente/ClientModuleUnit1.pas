unit ClientModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, ClientClassesUnit1, Data.DBXDataSnap,
  IPPeerClient, Data.DBXCommon, Data.DB, Data.SqlExpr, Datasnap.DBClient,
  Datasnap.DSConnect;

type
  TClientModule1 = class(TDataModule)
    SQLConnection1: TSQLConnection;
    dtsPessoa: TDataSource;
    DSProviderConnection1: TDSProviderConnection;
    cdsPessoa: TClientDataSet;
    cdsPessoaidpessoa: TLargeintField;
    cdsPessoaflnatureza: TSmallintField;
    cdsPessoadsdocumento: TWideStringField;
    cdsPessoanmprimeiro: TWideStringField;
    cdsPessoanmsegundo: TWideStringField;
    cdsPessoadtregistro: TDateField;
    cdsPessoadscep: TWideStringField;
  private
    FInstanceOwner: Boolean;
    FServerMethods1Client: TServerMethods1Client;
    function GetServerMethods1Client: TServerMethods1Client;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property ServerMethods1Client: TServerMethods1Client read GetServerMethods1Client write FServerMethods1Client;

end;

var
  ClientModule1: TClientModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TClientModule1.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
end;

destructor TClientModule1.Destroy;
begin
  FServerMethods1Client.Free;
  inherited;
end;

function TClientModule1.GetServerMethods1Client: TServerMethods1Client;
begin
  FServerMethods1Client := nil;
  SQLConnection1.Open;
  FServerMethods1Client:= TServerMethods1Client.Create(SQLConnection1.DBXConnection, FInstanceOwner);
  Result := FServerMethods1Client;
end;

end.
