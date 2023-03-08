unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, uDWDataModule, uDWAbout, uRESTDWServerEvents, FireDAC.Phys.PG, FireDAC.Phys.PGDef, System.Json, FMX.Graphics,
  uDWJSONObject, System.NetEncoding, uRESTDWPoolerDB, System.Net.HttpClient,
  uRestDWDriverFD, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB;

  const FTOKEN = 'U33ONZBJRRCWBCO55CI72A16CIX9O';

type
  TDM = class(TServerMethodDataModule)

    Conexao: TFDConnection;
    DWEvents: TDWServerEvents;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
    Driver: TFDPhysFBDriverLink;
    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure DWEventsEventsNovoClienteReplyEvent(var Params: TDWParams;
      var Result: string);
  private
    function LoadConfig: String;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses uPrincipal, System.IniFiles, Soap.EncdDecd, uDWConsts, ClienteModel,
  FMX.Dialogs, ClienteController, EnderecoIntegracaoModel, EnderecoModel,
  EnderecoController;

{$R *.dfm}

function TDM.LoadConfig() : String;
var
 arq_ini, base, usuario, senha, driver : String;
 ini : TIniFile;
begin


    arq_ini := System.SysUtils.GetCurrentDir + '..\..\Config\Config.ini';

    if not FileExists(arq_ini) then
    begin
      Result := 'Arquivo INI não encontrado: ' + arq_ini;

      Exit;
    end;

    ini := TIniFile.Create(arq_ini);

    base    := ini.ReadString('Banco de Dados', 'Database', 'SAC_NFCE.FDB');
    usuario := ini.ReadString('Banco de Dados', 'User_Name','SYSDBA');
    senha   := ini.ReadString('Banco de Dados', 'Password', 'masterkey');
    driver  := ini.ReadString('Banco de Dados', 'DriverID', 'FB');

    Conexao.Params.Clear;
    Conexao.Params.Values['DriverID']  := driver;
    Conexao.Params.Values['Database']  := base;
    Conexao.Params.Values['User_Name'] := usuario;
    Conexao.Params.Values['Password']  := senha;

    try
      Conexao.Connected := True;

      Result := 'OK';
    except on Ex : Exception do
      Result := 'Erro ao conectar com o banco de dados: ' + Ex.Message;
    end;

end;

procedure TDM.ServerMethodDataModuleCreate(Sender: TObject);
var
  Retorno : String;
begin
  Retorno := LoadConfig;

  if Retorno <> 'OK' then
    frmPrincipal.Log(Retorno);
end;

procedure TDM.DWEventsEventsNovoClienteReplyEvent(var Params: TDWParams;
  var Result: string);
var
  erro : String;
  json : TJsonObject;
var
  nmPrimeiro, nmSegundo, flNatureza, dsDocumento, dtRegistro : String;
  dsCep, dsUf, nmCidade, nmBairro, nmLogradouro : String;
  clienteController : TClienteController;
  enderecoController : TEnderecoController;
  cliente : TPessoa;
  endereco : TEndereco;
  enderecoIntegracao : TEnderecoIntegracao;
begin
  if Assigned(Params.ItemsString['nmprimeiro']) then
    nmPrimeiro := Params.ItemsString['nmprimeiro'].AsString;
  if Assigned(Params.ItemsString['nmsegundo']) then
    nmSegundo := Params.ItemsString['nmsegundo'].AsString;
  if Assigned(Params.ItemsString['flnatureza']) then
    flNatureza := Params.ItemsString['flnatureza'].AsString;
  if Assigned(Params.ItemsString['dsdocumento']) then
    dsDocumento := Params.ItemsString['dsdocumento'].AsString;
  if Assigned(Params.ItemsString['dtregistro']) then
    dtRegistro := Params.ItemsString['dtregistro'].AsString;


  if Assigned(Params.ItemsString['dsCep']) then
    dsCep := Params.ItemsString['dsCep'].AsString;
  if Assigned(Params.ItemsString['dsUf']) then
    dsUf := Params.ItemsString['dsUf'].AsString;
  if Assigned(Params.ItemsString['nmCidade']) then
    nmCidade := Params.ItemsString['nmCidade'].AsString;
  if Assigned(Params.ItemsString['nmBairro']) then
    nmBairro := Params.ItemsString['nmBairro'].AsString;
  if Assigned(Params.ItemsString['nmLogradouro']) then
    nmLogradouro := Params.ItemsString['nmLogradouro'].AsString;

  json               := TJsonObject.Create;
  cliente            := TPessoa.Create;
  clienteController  := TClienteController.Create;
  enderecoController := TEnderecoController.Create;
  endereco           := TEndereco.Create;
  enderecoIntegracao := TEnderecoIntegracao.Create;
  try
    cliente.FlNatureza := flNatureza.ToInteger;
    cliente.NmPrimeiro := nmPrimeiro;
    cliente.NmSegundo  := nmSegundo;
    cliente.DsDocumento:= dsDocumento;
    cliente.DtRegistro := StrToDate(dtRegistro);

    endereco.DsCep := dsCep;

    enderecoIntegracao.DsUf         := dsUf;
    enderecoIntegracao.NmCidade     := nmCidade;
    enderecoIntegracao.NmBairro     := nmBairro;
    enderecoIntegracao.NmLogradouro := nmLogradouro;

    enderecoController.NovoEndereco(erro, endereco);

    if (clienteController.NovoCliente(erro, cliente)) then
    begin
      json.AddPair('sucesso', 'S');
      json.AddPair('erro', '');
    end
    else
    begin
      json.AddPair('sucesso', 'N');
      json.AddPair('erro', 'Falha ao inserir o cliente');
    end;

    Result := json.ToString;
  finally
    cliente.DisposeOf;
    clienteController.DisposeOf;
    json.DisposeOf;
    endereco.DisposeOf;
    enderecoIntegracao.DisposeOf;
    enderecoController.DisposeOf;
  end;

end;

end.
