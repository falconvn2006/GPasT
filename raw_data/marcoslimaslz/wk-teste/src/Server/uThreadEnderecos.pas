unit uThreadEnderecos;

interface

uses
  Classes, IdHTTP, udtoEndereco, udaoEndereco, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.UI, SysUtils, udtoEnderecoIntegracao, uDAOEnderecoIntegracao,
  REST.Json, uJsonObject;

type
  TCepIntegracao = class(TThread)
  FDConnection: TFDConnection;
  private
   { Private declarations }
  protected
    procedure Execute; override;
end;

implementation

procedure TCepIntegracao.Execute;
var
  lHTTP: TIdHTTP;
  Response: string;
  ttyDTOListaEnderecos: TDTOListaEnderecos;
  ttyDAOEndereco: TDaoEndereco;
  Endereco: TDtoEndereco;
  sCep: System.String;
  ttyDAOEnderecoIntegracao: TDAOEnderecoIntegracao;
  ttyDTOEnderecoIntegracao: TDTOEnderecoIntegracao;
  JsonObject: TDTOJsonObject;
begin
  ReturnValue := 0;
  NameThreadForDebugging('Consulta Endereços');
  FDConnection := TFDConnection.Create(nil);
  FDConnection.DriverName := 'PG';
  FDConnection.Params.Database := 'wk';
  FDConnection.Params.UserName := 'postgres';
  FDConnection.Params.Password := 'postgres';
  ttyDTOListaEnderecos := TDTOListaEnderecos.Create;
  ttyDAOEndereco := TDAOEndereco.Create(FDConnection);
  ttyDTOEnderecoIntegracao := TDTOEnderecoIntegracao.Create();
  ttyDAOEnderecoIntegracao := TDAOEnderecoIntegracao.Create(FDConnection);
  lHTTP := TIdHTTP.Create;
  try
    ttyDAOEndereco.LoadAll(ttyDTOListaEnderecos);
    for Endereco in ttyDTOListaEnderecos do
    begin
      if (Endereco.dscep.isEmpty) then
        continue;

      sCep := StringReplace(Endereco.dscep, '-', '', [rfReplaceAll]);
      Response := lHTTP.Get('HTTP://viacep.com.br/ws/'+sCep+'/json/');
      JsonObject := TJson.JsonToObject<TDTOJsonObject>(Response);

      ttyDTOEnderecoIntegracao.idendereco := Endereco.idendereco;
      ttyDTOEnderecoIntegracao.nmcidade := JsonObject.localidade;
      ttyDTOEnderecoIntegracao.dsuf := JsonObject.uf;
      ttyDTOEnderecoIntegracao.nmbairro := JsonObject.bairro;
      ttyDTOEnderecoIntegracao.nmlogradouro := JsonObject.logradouro;
      ttyDTOEnderecoIntegracao.dscomplemento := JsonObject.complemento;
      ttyDAOEnderecoIntegracao.Save(ttyDTOEnderecoIntegracao);
      ttyDTOEnderecoIntegracao.Clear;
    end;
  finally
    lHTTP.Free;
    FDConnection.Free;
    ttyDTOListaEnderecos.Free;
    ttyDAOEndereco.Free;
    ttyDTOEnderecoIntegracao.Free;
    ttyDAOEnderecoIntegracao.Free;
  end;
end;

end.
