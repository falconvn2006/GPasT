unit Dm.Dados;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  System.Json, REST.Json, REST.Client, REST.Types, System.Actions,
  Vcl.ActnList, System.UITypes, Messages;

type

  TTipoAcao = (
    taInserir,
    taEditar,
    taExcluir,
    taViaCep
  );

  TdmDados = class(TDataModule)
    cdsDados: TClientDataSet;
    cdsDadosidpessoa: TLargeintField;
    cdsDadosnmprimeiro: TWideStringField;
    cdsDadosnmsegundo: TWideStringField;
    cdsDadosflnatureza: TSmallintField;
    cdsDadosdtregistro: TDateField;
    cdsDadosidendereco: TLargeintField;
    cdsDadosdscep: TWideStringField;
    cdsDadosnmlogradouro: TWideStringField;
    cdsDadosnmbairro: TWideStringField;
    cdsDadosnmcidade: TWideStringField;
    cdsDadosdsuf: TWideStringField;
    cdsDadosdscomplemento: TWideStringField;
    dsDados: TDataSource;
    acAcoes: TActionList;
    acPrimeiro: TAction;
    acIncluir: TAction;
    acEditar: TAction;
    acExcluir: TAction;
    acSalvar: TAction;
    acCancelar: TAction;
    acAnterior: TAction;
    acProximo: TAction;
    acUltimo: TAction;
    acImportar: TAction;
    acConectar: TAction;
    acAtualizar: TAction;
    cdsDadosdsdocumento: TStringField;
    acViaCep: TAction;
    procedure dsDadosStateChange(Sender: TObject);
    procedure acIncluirExecute(Sender: TObject);
    procedure acConectarExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure acCancelarExecute(Sender: TObject);
    procedure acSalvarExecute(Sender: TObject);
    procedure acAtualizarExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
    procedure acViaCepExecute(Sender: TObject);
    procedure acPrimeiroExecute(Sender: TObject);
    procedure acAnteriorExecute(Sender: TObject);
    procedure acProximoExecute(Sender: TObject);
    procedure acUltimoExecute(Sender: TObject);
    procedure acImportarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure Manutencao(Acao: TTipoAcao);
  public
    { Public declarations }
    procedure CarregaDados;
    function RESTReqHTTP(sBaseURL, sBody, jsParametros: String; rmMetodo: TRESTRequestMethod; var CodHttp: Integer): String;
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses View.Manutencao, Controller.Crud, View.Principal, Winapi.Windows,
  View.DadosImport;

{$R *.dfm}

{ Tdm }

procedure TdmDados.acAnteriorExecute(Sender: TObject);
begin
  cdsDados.Prior;
end;

procedure TdmDados.acAtualizarExecute(Sender: TObject);
begin
  CarregaDados;
end;

procedure TdmDados.acCancelarExecute(Sender: TObject);
begin
  cdsDados.Cancel;
  frmManutencao.ModalResult := mrCancel;
end;

procedure TdmDados.acConectarExecute(Sender: TObject);
begin
  CarregaDados;
end;

procedure TdmDados.acEditarExecute(Sender: TObject);
begin
  Manutencao(taEditar);
end;

procedure TdmDados.acExcluirExecute(Sender: TObject);
begin
  Manutencao(taExcluir);
end;

procedure TdmDados.acImportarExecute(Sender: TObject);
begin
  try
    frmDadosImport := TfrmDadosImport.Create(Self);
    frmDadosImport.ShowModal;
  finally
    FreeAndNil(frmDadosImport);
  end;
end;

procedure TdmDados.acIncluirExecute(Sender: TObject);
begin
  Manutencao(taInserir);
end;

procedure TdmDados.acPrimeiroExecute(Sender: TObject);
begin
  cdsDados.First;
end;

procedure TdmDados.acProximoExecute(Sender: TObject);
begin
  cdsDados.Next;
end;

procedure TdmDados.acSalvarExecute(Sender: TObject);
var
  FCrud: TControllerCrud;
  Sucesso: Boolean;
  Msg: String;
begin
  try
    if frmManutencao.Acao = taInserir then
      Sucesso := FCrud.Inserir(cdsDadosnmprimeiro.AsString,
                               cdsDadosnmsegundo.AsString,
                               cdsDadosdsdocumento.AsString,
                               cdsDadosflnatureza.AsString,
                               cdsDadosdscep.AsString,
                               Msg)
    else
    if frmManutencao.Acao = taEditar then
      Sucesso := FCrud.Editar(cdsDadosidpessoa.AsInteger,
                              cdsDadosnmprimeiro.AsString,
                              cdsDadosnmsegundo.AsString,
                              cdsDadosdsdocumento.AsString,
                              cdsDadosflnatureza.AsString,
                              cdsDadosdscep.AsString,
                              Msg);
    if Sucesso then
    begin
      cdsDados.Post;
      MessageBox(frmManutencao.Handle,pWideChar(Msg),'Atenção',MB_OK + MB_ICONINFORMATION);
    end else
    begin
      cdsDados.Cancel;
      MessageBox(frmManutencao.Handle,pWideChar(Msg),'Atenção',MB_OK + MB_ICONWARNING);
    end;
  finally
    if frmManutencao.Acao = taInserir then
      CarregaDados;
    frmManutencao.ModalResult := mrOk;
  end;
end;

procedure TdmDados.acUltimoExecute(Sender: TObject);
begin
  cdsDados.Last;
end;

procedure TdmDados.acViaCepExecute(Sender: TObject);
begin
  Manutencao(taViaCep);
end;

procedure TdmDados.CarregaDados;
var
  FCrud: TControllerCrud;
  Msg: String;
  i: Byte;
begin
    FCrud.Selecao(dmDados.cdsDados, Msg);
    if Msg = EmptyStr then
    begin
      for i := 0 to Pred(frmPrincipal.dbgDados.Columns.Count) do
        frmPrincipal.dbgDados.Columns[i].Title.Alignment := taCenter;
      acIncluir.Enabled := True;
      acEditar.Enabled := True;
      acExcluir.Enabled := True;
      acProximo.Enabled := True;
      acPrimeiro.Enabled := True;
      acUltimo.Enabled := True;
      acAnterior.Enabled := True;
      acImportar.Enabled := True;
      acSalvar.Enabled := True;
      acCancelar.Enabled := True;
      acAtualizar.Enabled := True;
      acViaCep.Enabled := True;
      acConectar.Enabled := False;
      frmPrincipal.pcPessoas.Visible := True;
    end else
      MessageBox(frmPrincipal.Handle,'O servidor não está respondendo ou não foi ativado.','Aviso',MB_OK + MB_ICONWARNING);
end;

procedure TdmDados.dsDadosStateChange(Sender: TObject);
begin
  if dsDados.State in [dsInsert,dsEdit] then
  begin
    acSalvar.Enabled := True;
    acCancelar.Enabled := True;
  end else
  begin
    acSalvar.Enabled := False;
    acCancelar.Enabled := False;
  end;
end;

procedure TdmDados.Manutencao(Acao: TTipoAcao);
var
  Caption: String;
  FCrud: TControllerCrud;
  Sucesso: Boolean;
  CodHttp: Integer;
  Msg: String;
begin
  if (Acao in [taEditar,taExcluir,taViaCep]) and (cdsDados.IsEmpty) then
    Abort;

  if Acao in [taInserir,taEditar] then
  begin
    try
      frmManutencao := TfrmManutencao.Create(Self);
      case Acao of
        taInserir:
        begin;
          Caption := 'Inclusão de pessoa';
          cdsDados.Append;
        end;
        taEditar:
        begin;
          Caption := 'Edição de pessoa';
          cdsDados.Edit;
        end;
      end;
      frmManutencao.Acao := Acao;
      frmManutencao.Caption := Caption;
      frmManutencao.ShowModal;
    finally
      FreeAndNil(frmManutencao);
    end;
  end else
  if Acao in [taExcluir] then
  begin
    if MessageBox(frmPrincipal.Handle,pWideChar('Confirma a exclusão da pessoa ' +
      cdsDadosnmprimeiro.AsString + ' ' +
      cdsDadosnmsegundo.AsString + '?'),
      'Confirmação',MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = ID_NO
    then
      Abort;
    Sucesso := FCrud.Excluir(cdsDadosidpessoa.AsInteger,Msg);
    if Sucesso then
    begin
      cdsDados.Delete;
      MessageBox(frmPrincipal.Handle,'Pessoa excluída com sucesso!','Aviso',MB_OK + MB_ICONINFORMATION);
    end else
    begin
      MessageBox(frmPrincipal.Handle,pWideChar(Msg),'Aviso',MB_OK + MB_ICONINFORMATION);
    end;
  end else
  if Acao in [taViaCep] then
  begin
    Sucesso := FCrud.AtualizarEndereco(cdsDadosidendereco.AsInteger,cdsDadosdscep.AsString,Msg);
    if Sucesso then
    begin
      CarregaDados;
      MessageBox(frmPrincipal.Handle,pWideChar(Msg),'Aviso',MB_OK + MB_ICONINFORMATION);
    end else
    begin
      MessageBox(frmPrincipal.Handle,pWideChar(Msg),'Aviso',MB_OK + MB_ICONWARNING);
    end;
  end;
end;

function TdmDados.RESTReqHTTP(sBaseURL, sBody, jsParametros: String;
  rmMetodo: TRESTRequestMethod; var CodHttp: Integer): String;
var
  RestClient: TRESTClient;
  RestRequest: TRESTRequest;
  RestResponse: TRESTResponse;
  i: Smallint;
  Valor: String;
  Chave: String;
  Tipo: String;
  Encode: String;
  ArrayJS: TJSONArray;
begin
  Result  := '';
  CodHttp := 0;
  try
    try
      RestClient                     := TRESTClient.Create(nil);
      RestRequest                    := TRESTRequest.Create(nil);
      RestResponse                   := TRESTResponse.Create(nil);
      RestRequest.Client             := RestClient;
      RestRequest.Response           := RestResponse;
      RestRequest.SynchronizedEvents := False;
      RestRequest.Body.ClearBody;
      RestClient.FallbackCharsetEncoding := 'raw';
      RestRequest.Params.Clear;
      RestRequest.Method := rmMetodo;
      RestClient.BaseURL := sBaseURL;
      if jsParametros <> '' then
      begin
        //Tipo HEADER fixado (implementar tratativa se preciso)
        //Encode fixado (implementar tratativa se preciso)
        ArrayJS := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(jsParametros),0) as TJSONArray;
        for i := 0 to Pred(ArrayJS.Size) do begin
          Encode := TJSONObject(ArrayJS.Get(i)).Get('encode').JsonValue.Value;
          Tipo   := TJSONObject(ArrayJS.Get(i)).Get('tipo').JsonValue.Value;
          Chave  := TJSONObject(ArrayJS.Get(i)).Get('chave').JsonValue.Value;
          Valor  := TJSONObject(ArrayJS.Get(i)).Get('valor').JsonValue.Value;
          if Chave <> '' then begin
            if Tipo = 'GET/POST' then
              RestClient.Params.AddItem(Chave, Valor, TRESTRequestParameterKind.pkGETorPOST, [poDoNotEncode])
            else
              RestClient.Params.AddItem(Chave, Valor, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
            end;
        end;
        FreeAndNil(ArrayJs);
      end;
      if sBody <> '' then RestRequest.Body.Add(sBody, TRESTContentType.ctAPPLICATION_JSON);
      RestRequest.Execute;
      CodHttp := RestResponse.StatusCode;
      if not RestResponse.Status.Success then
      begin
        Result := '[FALHA]: ' + RestResponse.ErrorMessage;
      end;
    except
      on e:Exception do
      begin
        CodHttp := RestResponse.StatusCode;
        Result := '[FALHA]: ' + e.Message;
      end;
    end;
    Result := RestResponse.Content;
  finally
    FreeAndNil(RestClient);
    FreeAndNil(RestResponse);
    FreeAndNil(RestRequest);
  end;
end;

end.
