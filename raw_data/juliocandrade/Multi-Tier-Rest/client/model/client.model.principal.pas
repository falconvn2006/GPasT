unit client.model.principal;

interface

uses
  System.SysUtils, System.Classes, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TdmPrincipal = class(TDataModule)
    RestClientPessoa: TRESTClient;
    RestRequestPessoa: TRESTRequest;
    RestResponsePessoa: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    FDMemTablePessoa: TFDMemTable;
    FDMemTablePessoaid: TWideStringField;
    FDMemTablePessoanatureza: TWideStringField;
    FDMemTablePessoadataregistro: TWideStringField;
    FDMemTablePessoadocumento: TWideStringField;
    FDMemTablePessoaprimeironome: TWideStringField;
    FDMemTablePessoasegundonome: TWideStringField;
    FDMemTablePessoaendereco: TWideStringField;
    FDMemTablePessoaenderecoidendereco: TWideStringField;
    FDMemTablePessoaenderecoidpessoa: TWideStringField;
    FDMemTablePessoaenderecocep: TWideStringField;
    FDMemTablePessoaenderecointegracao: TWideStringField;
    FDMemTablePessoaenderecointegracaoidendereco: TWideStringField;
    FDMemTablePessoaenderecointegracaouf: TWideStringField;
    FDMemTablePessoaenderecointegracaocidade: TWideStringField;
    FDMemTablePessoaenderecointegracaobairro: TWideStringField;
    FDMemTablePessoaenderecointegracaologradouro: TWideStringField;
    FDMemTablePessoaenderecointegracaocomplemento: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FServerURL : String;
  public
    { Public declarations }
    procedure Pesquisar;
      procedure ServerURL(aValue : String);  overload;
      function ServerURL : String; overload;
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmPessoa }

procedure TdmPrincipal.DataModuleCreate(Sender: TObject);
begin
  ServerURL('http://localhost:3000');
end;

procedure TdmPrincipal.Pesquisar;
begin
  RESTRequestPessoa.Execute;
  if RestResponsePessoa.StatusCode = 200 then
    RESTResponseDataSetAdapter.UpdateDataSet();
end;

function TdmPrincipal.ServerURL: String;
begin
  Result := FServerURL;
end;

procedure TdmPrincipal.ServerURL(aValue: String);
begin
  FServerURL := aValue;
  RestClientPessoa.BaseURL := FServerURL;
end;

end.
