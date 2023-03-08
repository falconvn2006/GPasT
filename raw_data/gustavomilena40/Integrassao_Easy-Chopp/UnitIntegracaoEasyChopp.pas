unit UnitIntegracaoEasyChopp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, httpsend, ssl_openssl, StdCtrls, ACBrJSON, StrUtils,
  ACBrBase, acbrsocket2, ujson, IdHashMessageDigest, idhttp, IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket,
  IdSSLOpenSSL, synautil, DateUtils ;


   type
     TEasyTransacoes = record
     idCliente           : Integer;
     idTransacao         : Integer;
     dtTransacao         : tdatetime;
     vlValorTransacao    : Currency;
     vlQtdeTransacao     : Currency;
     idProduto           : Integer;
     idProdutoERP        : String;
     dsProduto           : String;
     dsUnidadeMedida     : String;
     dsTipoTransacao     : String;
     dsTipoMovimento     : String;
     dsSiglaMovimento    : String;
     stSituacaoPagamento : Integer;
     nrDocumentoFiscal   : String;
     cdAutorizacao       : String;
  end;

  type
     TEasyClientes = record
     idCliente       : Integer;
     dsNomeCliente   : String;
     dsTipoDocumento : String;
     nrDocumento     : String;
     vlCreditoAtual  : Currency;
     lstTransacoes   : array of TEasyTransacoes;
  end;

  type
     TEasyClienteTransacoes = record
     lstClientes : array of TEasyClientes;
  end;





  type
     tRecGetClientes =    record
     retorno             :string;
     idCliente           :integer;
     dsNomeCliente       :string;
     dsEmail             :string;
     dtNascimento        :string;
     dsTipoDocumento     :string;
     nrDocumento         :string;
     dsSexo              :string;
     dsCategoriaCliente  :string;
     nrTelefone          :string;
     dtCadastro          :string;
     dtSituacao          :string;
     idtag               :string;
  end;

  type
     tRecGetTodosClientes = record
     lstGetTodosClientes : array of tRecGetClientes;
  end;

type
  tTransacoesArray = array of array of string;
  TUnitIntegracaoEasyChopp = class(TObject)
  private
    HTTPClient: TacbrHTTP;
    pJSON: myJSONItem;

    function MD5(chave: string; Tag: string): string;
    function ExtractNumberInString(sChaine: String): String;


  public
    Burl, TokenAcesso: string;
    RespostaWebService, header: string;
    credito: double;

    constructor Create();
    destructor Destroy; override;

    function login(IdFilial: string; login: string; Senha: string): string;
    function getcliente(pNrDocumento: string = ''; pIdTag: String = ''): tRecGetClientes;

    function addcliente(pNome: string; pEmail: string; pSexo: string;
      pCpf: string; pTelefone: string; pDTNasc: string): string;

    function getcredito(pNrDocumento: string; pIdTag: string): string;

    function addTag(pNrDocumento: String; pIdTag: String;
      pIdTipoCartao: integer; pStCobrancaTarifa: integer;
      pDsEmailUsurio: String): string;

    function removeTAG(pNrDocumento: string = ''; pIdTag: String = ''): string;

    function AddCredito(pNrDocumento: string; pIdTag: String;
      pVlValorCredito: double; pCodAutorizacao: string; pdsEmailUsuario: string;
      pStSituacaoPagamento: boolean; pIdFormaPagamento: integer;
      pNrCupom: string; pDsObservacao: string): string;

    function AddDebito(pNrDocumento, pIdTag: String; pvlValorDebito: double;
      pidTipoTransacao: integer; pCodAutorizacao, pdsEmailUsuario: string;
      stPermiteSaldoNegativo: boolean; pDsObservacao: string): string;

    function addVenda(nrDocumento: string; idTag: string; dtTransacao: string;
      vlValorTransacao: double; vlQtdeTransacao: double; idProduto: String;
      idProdutoERP: String; nrDocumentoTransacao: String;
      stSituacaoPagamento: integer; stPermiteSaldoNegativo: boolean;
      idFormaPagamento: integer; codAutorizacao: String; dsEmailUsuario: String;
      dsObservacao: String): string;

    function GetTransacoesPendentes(nrDocumento: string; idTag: string;
      dtTransacaoInicial: string; dtTransacaoFinal: string): ttransacoesArray;

    function addPagamentoTransacoes(nrDocumento: string; idTag: string;
      dtPagamento: string; vlTotalPago: double; idFormaPagamento: integer;
      nrDocumentoFiscal: string; codAutorizacao: string; dsEmailUsuario: string;
      dsObservacao: string; idTransacao: integer; dtTransacao: string;
      vlValorTransacao: double; idProduto: integer): string;

    function getTransacoesPendentesPagamentoFilial(IdFilial: string): TEasyClienteTransacoes;

    function getTransacoesClienteCPF(nrDocumento: string; dtInicial: string;
      dtFinal: String): ttransacoesArray;

    function estornarCupomVenda(nrDocumentoTransacao: String;
      dsEmailUsuario: String; dsObservacao: String): String;

    function addVendaLote(nrDocumento: string; idTag: string;
      stPermiteSaldoNegativo: boolean; dsEmailUsuario: String;
      dtTransacao: String; vlValorTransacao: double; vlQtdeTransacao: Double;
      idProduto: String; idProdutoERP: String; nrDocumentoTransacao: String;
      stSituacaoPagamento: String; idFormaPagamento: integer;
      codAutorizacao: string; dsObservacao: String): String;

    function getTodosClientes(data:string):tRecGetTodosClientes;

    function UNIXTimeInMilliseconds: Int64;

  end;

const
  CChave: string = 'SAL63511TST******';
  CUrl: string = 'https://a***st.easychopp*********';

var
  teste: string;
  

implementation

{ TUnitIntegracaoEasyChopp }

constructor TUnitIntegracaoEasyChopp.Create;
begin
  inherited;

end;

destructor TUnitIntegracaoEasyChopp.Destroy;
begin
  inherited;

end;

function TUnitIntegracaoEasyChopp.MD5(chave: string; Tag: string): string;
var
  idmd5: TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;

  try
    result := idmd5.AsHex(idmd5.HashValue(chave + Tag));
  finally
    idmd5.Free;

  end;
end;

/// //////////////////////////////////LOGIN/////////////////////////////////////
function TUnitIntegracaoEasyChopp.login(IdFilial: string; login: string;
  Senha: string): string;
var
  x: integer;
begin
  Burl := CUrl + 'Login?key=' + MD5(CChave, IdFilial) +
   '&idFilial=' + IdFilial +
   '&password=' + Senha +
   '&user=' + login;

  try
    HTTPClient := TacbrHTTP.Create(nil);
    pJSON := myJSONItem.Create;

    HTTPClient.HTTPPost(Burl);
    pJSON.Code := HTTPClient.RespHTTP.Text;

    for x := 0 to pJSON.Count - 1 do
      if (pJSON.Value[x]['Token'].getStr <> '') then
        TokenAcesso := pJSON.Value[x]['Token'].getStr; // controle

    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;

  finally
    HTTPClient.Free;
    pJSON.Free;
  end;

end;

/// /////////////////////////////GET CLIENTE////////////////////////////////////
function TUnitIntegracaoEasyChopp.getcliente(pNrDocumento: string;
  pIdTag: String): tRecGetClientes;
var
  vBusca: string;
  x:integer;
begin

  vBusca := ifthen(pNrDocumento <> '', pNrDocumento, pIdTag);

  Burl := CUrl + 'getCliente?key=' + MD5(CChave, vBusca) +
   '&idTAG=' + pIdTag +
   '&nrDocumento=' + pNrDocumento;

  try
    HTTPClient := TacbrHTTP.Create(nil);
       pJSON := myJSONItem.Create;

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPget(Burl);

    pJSON.Code := HTTPClient.RespHTTP.Text;

    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle


          if AnsiUpperCase(pJSON['stintegracao'].getStr) =  'TRUE' then
          begin

               result.retorno       :=    pJSON['stintegracao'].getStr;
               result.dsNomeCliente :=    pJSON['dsnomecliente'].getStr;
               result.idtag         :=    pJSON['idtag'].getStr;
               result.dsemail       :=    pJSON['dsemail'].getStr;
               result.dtnascimento  :=    pJSON['dtnascimento'].getStr;

          end
          else
          begin
               result.retorno       :=    pJSON['stintegracao'].getStr ;
               exit;
         end;







   // result := HTTPClient.RespHTTP.Text;
  finally
    HTTPClient.Free;
    pjson.Free;
  end;

end;

/// //////////////////////////ADD CLIENTE//////////////////////////////////////////////////////////////
/// SE O CPF PASSADO JÁ FOR ENCONTRADO NA BASE, ELE ALTERA AS INFORMAÇÕES DO CLIENTE JÁ CADASTRADO ////
/// ///////////////////////////////////////////////////////////////////////////////////////////////////
function TUnitIntegracaoEasyChopp.addcliente(pNome: string; pEmail: string;
  pSexo: string; pCpf: string; pTelefone: string; pDTNasc: string): string;
begin

  Burl := CUrl + 'addCliente?key=' + MD5(CChave, pCpf) +
  '&dsNomeCliente=' + pNome +
  '&dsEmail=' + pEmail +
  '&dsSexo=' + pSexo +
  '&nrDocumento=' + pCpf +
  '&nrTelefone=' + pTelefone +
  '&dtNascimento=' + pDTNasc;

  try
    HTTPClient := TacbrHTTP.Create(nil);

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPPost(Burl);
    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;
  finally
    HTTPClient.Free;
  end;
end;

//////////////////////////GET CREDITO/////////////////////////////////////////////////////////////////
function TUnitIntegracaoEasyChopp.getcredito(pNrDocumento: string;
  pIdTag: string): string;
var
  vBusca: string;
  x: integer;
begin

  vBusca := ifthen(pNrDocumento <> '', pNrDocumento, pIdTag);

  Burl := CUrl + 'getCredito?key=' + MD5(CChave, vBusca) +
  '&nrDocumento=' + pNrDocumento +
  '&idTag=' + pIdTag;

  try
    HTTPClient := TacbrHTTP.Create(nil);
    pJSON := myJSONItem.Create;

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPget(Burl);
    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle
    pJSON.Code := HTTPClient.RespHTTP.Text;

    for x := 0 to pJSON.Count - 1 do
      if (pJSON.Value[x].Name = 'vlsaldoatual') then
        credito := pJSON.Value[x].getNum; // controle

    result := HTTPClient.RespHTTP.Text;
  finally
    HTTPClient.Free;
    pJSON.Free;
  end;

  
end;

function TUnitIntegracaoEasyChopp.addTag(pNrDocumento, pIdTag: String;
  pIdTipoCartao, pStCobrancaTarifa: integer; pDsEmailUsurio: String): string;
begin
  Burl := CUrl + 'addTAG?key=' + MD5(CChave, pNrDocumento) +
  '&nrDocumento=' + pNrDocumento +
  '&idTag=' + pIdTag +
  '&idTipoCartao=' + inttostr(pIdTipoCartao) +
  '&stCobrancaTarifa=' + inttostr(pStCobrancaTarifa) +
  '&dsEmailUsuario=' + pDsEmailUsurio;

  try
    HTTPClient := TacbrHTTP.Create(nil);
    pJSON := myJSONItem.Create;

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPget(Burl);
    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle
    pJSON.Code := HTTPClient.RespHTTP.Text;

    result := HTTPClient.RespHTTP.Text;
  finally
    HTTPClient.Free;
  end;

end;

function TUnitIntegracaoEasyChopp.removeTAG(pNrDocumento,
  pIdTag: String): string;
var
  vBusca: string;
begin

  vBusca := ifthen(pNrDocumento <> '', pNrDocumento, pIdTag);

  Burl := CUrl + 'removeTag?key=' + MD5(CChave, vBusca) +
  '&idTAG=' + pIdTag +
  '&nrDocumento=' + pNrDocumento;

  try
    HTTPClient := TacbrHTTP.Create(nil);

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPget(Burl);
    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;
  finally
    HTTPClient.Free;
  end;

end;

function TUnitIntegracaoEasyChopp.AddCredito(pNrDocumento, pIdTag: String;
  pVlValorCredito: double; pCodAutorizacao, pdsEmailUsuario: string;
  pStSituacaoPagamento: boolean; pIdFormaPagamento: integer;
  pNrCupom, pDsObservacao: string): string;
var
  vBusca: string;
begin

  vBusca := ifthen(pNrDocumento <> '', pNrDocumento, pIdTag);

  Burl := CUrl + 'AddCredito?key=' + MD5(CChave, vBusca) +
    '&idTAG=' + pIdTag +
    '&nrDocumento=' + pNrDocumento +
    '&vlValorCredito=' +StringReplace(formatfloat('######0.00', pVlValorCredito), ',', '.',[rfReplaceAll]) +
    '&codAutorizacao=' + pCodAutorizacao +
    '&dsEmailUsuario=' + pdsEmailUsuario +
    '&stSituacaoPagamento=' + ifthen(pStSituacaoPagamento,'true', 'false') +
    '&idFormaPagamento=' + inttostr(pIdFormaPagamento) +
    '&nrCupom=' + pNrCupom +
    '&dsObservacao=' + pDsObservacao;

  try
    HTTPClient := TacbrHTTP.Create(nil);

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPPost(Burl);
    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;

  finally
    HTTPClient.Free;
  end;

end;

function TUnitIntegracaoEasyChopp.AddDebito(pNrDocumento, pIdTag: String;
  pvlValorDebito: double; pidTipoTransacao: integer;
  pCodAutorizacao, pdsEmailUsuario: string; stPermiteSaldoNegativo: boolean;
  pDsObservacao: string): string;
var
  vBusca: string;
begin

  vBusca := ifthen(pNrDocumento <> '', pNrDocumento, pIdTag);

  Burl := CUrl + 'AddDebito?key=' + MD5(CChave, vBusca) +
    '&idTAG=' + pIdTag +
    '&nrDocumento=' + pNrDocumento +
    '&vlValorDebito=' + StringReplace(formatfloat('######0.00', pvlValorDebito), ',', '.',[rfReplaceAll]) +
    '&idTipoTransacao=' + inttostr(pidTipoTransacao) +
    '&codAutorizacao=' + pCodAutorizacao +
    '&dsEmailUsuario=' + pdsEmailUsuario +
    '&stPermiteSaldoNegativo=' + ifthen(stPermiteSaldoNegativo, 'true','false') +
    '&dsObservacao=' + pDsObservacao;

  try
    HTTPClient := TacbrHTTP.Create(nil);

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPPost(Burl);
    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;

  finally
    HTTPClient.Free;
  end;

end;





function TUnitIntegracaoEasyChopp.addPagamentoTransacoes(nrDocumento, idTag,
  dtPagamento: string; vlTotalPago: double; idFormaPagamento: integer;
  nrDocumentoFiscal, codAutorizacao, dsEmailUsuario, dsObservacao: string;
  idTransacao: integer; dtTransacao: string; vlValorTransacao: double;
  idProduto: integer): string;
var
  vBusca, body: string;
begin
  // PARAMETRO ID PRODUTO É A BUSCA PELO ID DO SITE
  // PARA INTEGRAÇÃO UTILIZAR APENAS O IDPRODUTO ERP QUE DEVE SER COLOCADO O ID DO
  // PRODUTO NO BBIFOOD NO SITE DO EASY CHOOP

  vBusca := ifthen(nrDocumento <> '', nrDocumento, idTag);

  Burl := CUrl + 'addPagamentoTransacoes';

  body:=   '{'                                              +
    '"key": "'+ md5(CChave, vBusca) +'",'                   +
    '"idTAG": "' + idTag+ '",'                              +
    '"nrDocumento": "'+ nrDocumento+'",'                    +
    '"dtPagamento": "'+ dtPagamento +'", '                  +
    '"vlTotalPago": '+ StringReplace(floattostr(vlTotalPago),',','.',[])+','           +
    '"idFormaPagamento": "'+ inttostr(IdFormaPagamento)+'",'+
    '"nrDocumentoFiscal": "'+ nrDocumentoFiscal +'",'       +
    '"codAutorizacao": "' + codAutorizacao +'",'            +
    '"dsEmailUsuario": "' + dsEmailUsuario +'",'            +
    '"dsObservacao": "' + dsObservacao +'",'                +
     '"Transacoes": [ '                                     +
   //for inicia aqui
        '{ '                                                +
         '"idTransacao": '+ inttostr(idTransacao) +','      +
         '"dtTransacao": "'+ dtTransacao +'", '             +
         '"vlValorTransacao": '+ StringReplace(floattostr(vlValorTransacao),',','.',[])+',' +
         '"idProduto": '+ inttostr(idProduto)                    +
         '}'                                                     +
   //concatena uma virgula no final caso seja + de uma transacao
    ']'                                                          +
  '}';

  {
    '&Transacao[0][idTransacao]=58380'+//+inttostr(idTransacao)+
    '&Transacao[0][dtTransacao]=07/11/2022'+//+dtTransacao+
    '&Transacao[0][vlValorTransacao]=10'+//+floattostr(vlValorTransacao)+
    '&Transacao[0][idProduto]=508';//+inttostr(idProduto);
    }

  
  try

    HTTPClient := TacbrHTTP.Create(nil);

     HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPSend.MimeType := 'application/json';


    HTTPClient.HTTPPost(Burl, body);
    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;

  finally
    HTTPClient.Free;
  end;

end;


function TUnitIntegracaoEasyChopp.getTransacoesPendentesPagamentoFilial
  (IdFilial: string): TEasyClienteTransacoes;
var
    JSON, jClientes, jTransacoes : myJSONItem;
    x, y: Integer;

begin

  Burl := CUrl + 'getTransacoesPendentesPagamentoFilial?key=' +
    MD5(CChave, IdFilial) +
    '&idFilial=' + IdFilial;

  try
    HTTPClient := TacbrHTTP.Create(nil);

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPget(Burl);


    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    JSON := myJSONItem.Create;
    JSON.Code := HTTPClient.RespHTTP.Text;

    jClientes := JSON['Clientes'];

     SetLength(Result.lstClientes, jClientes.Count);

     for x := 0 to jClientes.Count -1 do
          begin
               Result.lstClientes[x].idCliente       := jClientes.Value[x]['idCliente'].getInt;
               Result.lstClientes[x].dsNomeCliente   := jClientes.Value[x]['dsNomeCliente'].getStr;
               Result.lstClientes[x].dsTipoDocumento := jClientes.Value[x]['dsTipoDocumento'].getStr;
               Result.lstClientes[x].nrDocumento     := jClientes.Value[x]['nrDocumento'].getStr;
               Result.lstClientes[x].vlCreditoAtual  := jClientes.Value[x]['vlCreditoAtual'].getNum;

               jTransacoes := jClientes.Value[x]['Transacoes'];

               SetLength(Result.lstClientes[x].lstTransacoes, jTransacoes.Count);

               for y := 0 to jTransacoes.Count -1 do
               begin
                    Result.lstClientes[x].lstTransacoes[y].idCliente           := Result.lstClientes[x].idCliente;
                    Result.lstClientes[x].lstTransacoes[y].idTransacao         := jTransacoes.Value[y]['idTransacao'].getInt;
                    Result.lstClientes[x].lstTransacoes[y].dtTransacao         :=
                         UnixToDateTime(
                              	STRTOINT64(
                              		ExtractNumberInString(jTransacoes.Value[y]['dtTransacao'].getStr)) div 1000);

                    Result.lstClientes[x].lstTransacoes[y].vlValorTransacao    := jTransacoes.Value[y]['vlValorTransacao'].getNum;
                    Result.lstClientes[x].lstTransacoes[y].vlQtdeTransacao     := jTransacoes.Value[y]['vlQtdeTransacao'].getNum;
                    Result.lstClientes[x].lstTransacoes[y].idProduto           := jTransacoes.Value[y]['idProduto'].getInt;
                    Result.lstClientes[x].lstTransacoes[y].idProdutoERP        := jTransacoes.Value[y]['idProdutoERP'].getStr;
                    Result.lstClientes[x].lstTransacoes[y].dsProduto           := jTransacoes.Value[y]['dsProduto'].getStr;
                    Result.lstClientes[x].lstTransacoes[y].dsUnidadeMedida     := jTransacoes.Value[y]['dsUnidadeMedida'].getStr;
                    Result.lstClientes[x].lstTransacoes[y].dsTipoTransacao     := jTransacoes.Value[y]['dsTipoTransacao'].getStr;
                    Result.lstClientes[x].lstTransacoes[y].dsTipoMovimento     := jTransacoes.Value[y]['dsTipoMovimento'].getStr;
                    Result.lstClientes[x].lstTransacoes[y].dsSiglaMovimento    := jTransacoes.Value[y]['dsSiglaMovimento'].getStr;
                    Result.lstClientes[x].lstTransacoes[y].stSituacaoPagamento := jTransacoes.Value[y]['stSituacaoPagamento'].getInt;
                    Result.lstClientes[x].lstTransacoes[y].nrDocumentoFiscal   := jTransacoes.Value[y]['nrDocumentoFiscal'].getStr;
                    Result.lstClientes[x].lstTransacoes[y].cdAutorizacao       := jTransacoes.Value[y]['cdAutorizacao'].getStr;
               end;
          end;




 //   result := HTTPClient.RespHTTP.Text;

  finally
    HTTPClient.Free;
    FreeAndNil(JSON);
  end;



end;

function TUnitIntegracaoEasyChopp.getTransacoesClienteCPF(nrDocumento,
  dtInicial, dtFinal: String): ttransacoesArray;
  var

  x,y,i,j:integer;
  transacoes : String;
  // transacoesArray : array of array of string;
begin

//Essa função pede um  formato de  diferente das outras
// YYYY-MM-DD

transacoes :='';

  Burl := CUrl + 'getTransacoesClienteCPF?key=' + MD5(CChave, nrDocumento) +
    '&nrDocumento=' + nrDocumento +
    '&dtInicial=' + dtInicial +
    '&dtFinal='+ dtFinal +
    '&HoursLocalTimeOffSet=-03:00';

  try


    HTTPClient := TacbrHTTP.Create(nil);
    pJSON := myJSONItem.Create;

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPget(Burl);



     pJSON.Code := HTTPClient.RespHTTP.Text;

   //  setlength(transacoesArray, pJSON.Count -1);


    for x := 0 to pJSON.Count - 1 do
      if (pJSON.Value[x].Name = 'transacoes') then
      begin
      	for y := 0 to pjson.value[x].count -1 do
      	begin

             SetLength(result,  pjson.value[x].count  ,6);

        		transacoes :=  transacoes + 'ID: '+ pJSON.Value[x].value[y]['idtransacao'].getStr +
               ' Valor: '+pJSON.Value[x].value[y]['vlValorTransacao'].getStr+
               ' Tipo transacao: ' +pJSON.Value[x].value[y]['dsTipoTransacao'].getStr+
               ' Produto: ' + pJSON.Value[x].value[y]['dsProduto'].getStr +
               ' sigla: '   + pJSON.Value[x].value[y]['dsSiglaMovimento'].getStr +
               ' tipo moviemnto: '   + pJSON.Value[x].value[y]['dsTipoMovimento'].getStr +
               ' Data: '+   DATETIMETOSTR(
               			UnixToDateTime(
                              	STRTOINT64(
                              		ExtractNumberInString(
                              			pJSON.Value[x].value[y]['dtTransacao'].getStr)) DIV 1000)) + chr(13)+ chr(13)+ chr(13); // controle


                 result[y][0]:= 'idtransacao: ' +   pJSON.Value[x].value[y]['idtransacao'].getStr;
                 result[y][1]:= 'vlValorTransacao: ' + pJSON.Value[x].value[y]['vlValorTransacao'].getStr;
                 result[y][2]:= 'dsTipoTransacao: ' + pJSON.Value[x].value[y]['dsTipoTransacao'].getStr;
                 result[y][3]:= 'dsProduto: ' +pJSON.Value[x].value[y]['dsProduto'].getStr;
                 result[y][4]:= 'dtTransacao: ' +  DATETIMETOSTR(
               			UnixToDateTime(
                              	STRTOINT64(
                              		ExtractNumberInString(
                              			pJSON.Value[x].value[y]['dtTransacao'].getStr)) DIV 1000)) ; // controle





        	end;
      end;




     showmessage(inttostr(length(result)));

   {  for i:=0 to  length(transacoesArray) -1 do
        for  j:=0 to length(transacoesArray[i]) -1  do
        begin
          showmessage(transacoesArray[i][j]);

        end; }


    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

 //   result := transacoes;

  finally
    HTTPClient.Free;
    pJSON.free;
  end;

end;


function TUnitIntegracaoEasyChopp.GetTransacoesPendentes(nrDocumento, idTag,
  dtTransacaoInicial, dtTransacaoFinal: string): ttransacoesArray;
var
  vBusca: string;
  x, y, i, j, aux: integer;
  transacoes: String;
  varia : boolean;
  transacoesArray : tTransacoesArray;
begin
  // PARAMETRO ID PRODUTO É A BUSCA PELO ID DO SITE
  // PARA INTEGRAÇÃO UTILIZAR APENAS O IDPRODUTO ERP QUE DEVE SER COLOCADO O ID DO
  // PRODUTO NO BBIFOOD NO SITE DO EASY CHOOP

  vBusca := ifthen(nrDocumento <> '', nrDocumento, idTag);

  Burl := CUrl + 'GetTransacoesPendentes?key=' + MD5(CChave, vBusca) +
  '&idTAG=' + idTag +
  '&nrDocumento=' + nrDocumento +
  '&dtInicial=' + dtTransacaoInicial  +
  '&dtFinal=' + dtTransacaoFinal;

  try
  aux:=0;
    HTTPClient := TacbrHTTP.Create(nil);
    pJSON := myJSONItem.Create;


    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPget(Burl);

     pJSON.Code := HTTPClient.RespHTTP.Text;


    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle



    

   //  setlength(transacoesArray, pJSON.Count -1);


    for x := 0 to pJSON.Count - 1 do
      if (pJSON.Value[x].Name = 'transacoes') then
      begin
      	for y := 0 to pjson.value[x].count -1 do
      	begin


        		transacoes :=  transacoes + 'ID: '+ pJSON.Value[x].value[y]['idtransacao'].getStr +
               ' Valor: '+pJSON.Value[x].value[y]['vlValorTransacao'].getStr+
               ' Tipo transacao: ' +pJSON.Value[x].value[y]['dsTipoTransacao'].getStr+
               ' Produto: ' + pJSON.Value[x].value[y]['dsProduto'].getStr +
               ' sigla: '   + pJSON.Value[x].value[y]['dsSiglaMovimento'].getStr +
               ' tipo moviemnto: '   + pJSON.Value[x].value[y]['dsTipoMovimento'].getStr +
               ' Data: '+   DATETIMETOSTR(
               			UnixToDateTime(
                              	STRTOINT64(
                              		ExtractNumberInString(
                              			pJSON.Value[x].value[y]['dtTransacao'].getStr)) DIV 1000)) + chr(13)+ chr(13)+ chr(13); // controle


             varia :=   pJSON.Value[x].value[y]['idProdutoERP'].getStr <> '';
            if varia  then
            begin
            aux := aux+1;
            end;

          end;
          SetLength(result,  aux , 6);

        for y := 0 to pjson.value[x].count -1 do
      	begin


        if  pJSON.Value[x].value[y]['idProdutoERP'].getStr <> '' then
          begin
                 result[y][0]:= 'idtransacao: ' +   pJSON.Value[x].value[y]['idtransacao'].getStr;
                 result[y][1]:= 'vlValorTransacao: ' + pJSON.Value[x].value[y]['vlValorTransacao'].getStr;
                 result[y][2]:= 'vlQtdeTransacao: ' + pJSON.Value[x].value[y]['vlQtdeTransacao'].getStr;
                 result[y][3]:= 'idProdutoERP: ' + pJSON.Value[x].value[y]['idProdutoERP'].getStr;
                 result[y][4]:= 'idProduto: ' +pJSON.Value[x].value[y]['idProduto'].getStr;
                 result[y][5]:= 'dtTransacao: ' +  DATETIMETOSTR(
               			UnixToDateTime(
                              	STRTOINT64(
                              		ExtractNumberInString(
                              			pJSON.Value[x].value[y]['dtTransacao'].getStr)) DIV 1000)) ; // controle

        end;

      end;

    end;




  showmessage(inttostr(length(result)));

   {  for i:=0 to  length(transacoesArray) -1 do
        for  j:=0 to length(transacoesArray[i]) -1  do
        begin
          showmessage(transacoesArray[i][j]);

        end; }


    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

 //   result := transacoes;

  finally
    HTTPClient.Free;
    pJSON.free;
  end;


end;


function TUnitIntegracaoEasyChopp.estornarCupomVenda(nrDocumentoTransacao,
  dsEmailUsuario, dsObservacao: String): String;
begin
  Burl := CUrl + 'estornarCupomVenda?key=' + MD5(CChave, nrDocumentoTransacao) +
    '&nrDocumentoTransacao=' + nrDocumentoTransacao +
    '&dsEmailUsuario=' + dsEmailUsuario +
    '&dsObservacao=' + dsObservacao;

  try
    HTTPClient := TacbrHTTP.Create(nil);

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPPost(Burl);

    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;

  finally
    HTTPClient.Free;
  end;

end;



function TUnitIntegracaoEasyChopp.addVenda(nrDocumento, idTag,
  dtTransacao: string; vlValorTransacao, vlQtdeTransacao: double;
  idProduto, idProdutoERP, nrDocumentoTransacao: String;
  stSituacaoPagamento: integer; stPermiteSaldoNegativo: boolean;
  idFormaPagamento: integer; codAutorizacao, dsEmailUsuario,
  dsObservacao: String): string;
  var
  vBusca:String;
begin
 // PARAMETRO ID PRODUTO É A BUSCA PELO ID DO SITE
  // PARA INTEGRAÇÃO UTILIZAR APENAS O IDPRODUTO ERP QUE DEVE SER COLOCADO O ID DO
  // PRODUTO NO BBIFOOD NO SITE DO EASY CHOOP

  vBusca := ifthen(nrDocumento <> '', nrDocumento, idTag);

  Burl := CUrl + 'addVenda?key=' + MD5(CChave, vBusca) +
    '&idTAG=' + idTag +
    '&nrDocumento=' + nrDocumento +
    '&dtTransacao=' + dtTransacao +
    '&vlValorTransacao=' + StringReplace(formatfloat('######0.00', vlValorTransacao), ',', '.', [rfReplaceAll]) +
    '&vlQtdeTransacao=' + StringReplace(formatfloat('######0.00', vlQtdeTransacao), ',', '.', [rfReplaceAll]) +
    '&idProduto=' + idProduto +
    '&idProdutoERP=' + idProdutoERP +
    '&nrDocumentoTransacao=' + nrDocumentoTransacao +
    '&stSituacaoPagamento=' + inttostr(stSituacaoPagamento) +
    '&stPermiteSaldoNegativo=' + ifthen(stPermiteSaldoNegativo, 'true','false') +
    '&idFormaPagamento=' + inttostr(stSituacaoPagamento) +
    '&codAutorizacao='+ codAutorizacao +
    '&dsEmailUsuario=' + dsEmailUsuario +
    '&dsObservacao=' + dsObservacao;

  try
    HTTPClient := TacbrHTTP.Create(nil);

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPPost(Burl);
    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;

  finally
    HTTPClient.Free;
  end;

end;

function TUnitIntegracaoEasyChopp.addVendaLote(nrDocumento, idTag: string;
  stPermiteSaldoNegativo: boolean; dsEmailUsuario, dtTransacao: String;
  vlValorTransacao, vlQtdeTransacao: Double; idProduto, idProdutoERP,
  nrDocumentoTransacao, stSituacaoPagamento: String;
  idFormaPagamento: integer; codAutorizacao, dsObservacao: String): String;
var
  vBusca, body: string;
begin

  vBusca := ifthen(nrDocumento <> '', nrDocumento, idTag);



  Burl := CUrl + 'AddVendaLote';

   body:=   '{'                                                 +
    '"key": "'+ md5(CChave, vBusca) +'",'                       +
    '"idTAG": "' + idTag+ '",'                                  +
    '"nrDocumento": "'+ nrDocumento+'",'                        +
    '"stPermiteSaldoNegativo": "'+  ifthen(stPermiteSaldoNegativo, 'true','false') +'",'+
    '"dsEmailUsuario": "'+ dsEmailUsuario +'",'                 +
    '"Transacoes": [ '                                          +
   //for inicia aqui
        '{ '                                                    +
        '"dtTransacao": "'+ dtTransacao +'", '                  +
        '"vlValorTransacao": '+floattostr(vlValorTransacao)+',' +
        '"vlQtdeTransacao": '+floattostr(vlQtdeTransacao)+','   +
        '"idProduto": '+ idProduto+','                          +
        '"idProdutoERP": "'+ idProdutoERP +'",'                 +
        '"nrDocumentoTransacao": "'+ nrDocumentoTransacao+'",'  +
        '"stSituacaoPagamento": "'+ stSituacaoPagamento+'",'    +
        '"idFormaPagamento": "'+ inttostr(IdFormaPagamento)+'",'+
        '"codAutorizacao": "'+codAutorizacao+'",'               +
        '"dsObservacao": "'+ dsObservacao+'"'                   +
        '}'                                                     +
   //concatena uma virgula no final caso seja + de uma transacao
    ']'                                                         +
  '}';

   //showmessage(body);
   
    try
    HTTPClient := TacbrHTTP.Create(nil);
  //  Bound := IntToHex(Random(MaxInt), 8) + '_Synapse_boundary';
   // HTTP := THTTPSend.Create;

    HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
    header := HTTPClient.httpsend.Headers[0]; // controle

    HTTPClient.HTTPSend.MimeType := 'application/json';

   HTTPClient.HTTPPost(burl, body); // maneira 1 primeiro metódo post descrito na unit


    RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
      ',' + chr(13), [rfReplaceAll]); // controle

    result := HTTPClient.RespHTTP.Text;

  finally
    HTTPClient.Free;
  end;


end;


function TUnitIntegracaoEasyChopp.getTodosClientes(data: string): tRecGetTodosClientes;
var
    JSON, jClientes: myJSONItem;
    x, y: Integer;

begin

     Burl := CUrl + 'getClientes?key=' + MD5(CChave,copy(StringReplace(data,'/','',[rfReplaceAll]),0,8))  +
          '&dtCadastro='+data;

     try
          HTTPClient := TacbrHTTP.Create(nil);

          HTTPClient.httpsend.Headers.Add('Authorization: Bearer ' + TokenAcesso);
          header := HTTPClient.httpsend.Headers[0]; // controle

          HTTPClient.HTTPPost(Burl);
          RespostaWebService := StringReplace(HTTPClient.RespHTTP.Text, ',',
          ',' + chr(13), [rfReplaceAll]); // controle



          JSON := myJSONItem.Create;
          JSON.Code := HTTPClient.RespHTTP.Text;

          jClientes := JSON['Clientes'];
          SetLength(Result.lstGetTodosClientes, jClientes.Count);


          for x := 0 to jClientes.Count -1 do
          begin
               Result.lstGetTodosClientes[x].idCliente           := jClientes.Value[x]['idCliente'].getInt;
               Result.lstGetTodosClientes[x].dsNomeCliente       := jClientes.Value[x]['dsNomeCliente'].getStr;
               Result.lstGetTodosClientes[x].dsEmail             := jClientes.Value[x]['dsEmail'].getStr;
               Result.lstGetTodosClientes[x].dtNascimento        := jClientes.Value[x]['dtNascimento'].getStr;
               Result.lstGetTodosClientes[x].dsTipoDocumento     := jClientes.Value[x]['dsTipoDocumento'].getStr;
               Result.lstGetTodosClientes[x].nrDocumento         := jClientes.Value[x]['nrDocumento'].getStr;
               Result.lstGetTodosClientes[x].dsSexo              := jClientes.Value[x]['dsSexo'].getStr;
               Result.lstGetTodosClientes[x].dsCategoriaCliente  := jClientes.Value[x]['dsCategoriaCliente'].getStr;
               Result.lstGetTodosClientes[x].nrTelefone          := jClientes.Value[x]['nrTelefone'].getStr;
               Result.lstGetTodosClientes[x].dtCadastro          := jClientes.Value[x]['dtCadastro'].getStr;
               Result.lstGetTodosClientes[x].dtSituacao          := jClientes.Value[x]['dtSituacao'].getStr;
         END;

     finally
          HTTPClient.Free;
          FreeAndNil(JSON);
     end;

end;

function TUnitIntegracaoEasyChopp.ExtractNumberInString ( sChaine: String ): String ;
var
    i: Integer ;
begin
    Result := '' ;
    for i := 1 to length( sChaine ) do
    begin
        if sChaine[ i ] in ['0'..'9'] then
        Result := Result + sChaine[ i ] ;
    end ;
end ;

function TUnitIntegracaoEasyChopp.UNIXTimeInMilliseconds: Int64;
var
  ST: SystemTime;
  DT: TDateTime;
begin
  Windows.GetSystemTime(ST);
  DT := SysUtils.EncodeDate(ST.wYear, ST.wMonth, ST.wDay) +
        SysUtils.EncodeTime(ST.wHour, ST.wMinute, ST.wSecond, ST.wMilliseconds);
  Result := DateUtils.MilliSecondsBetween(DT, UnixDateDelta);


end;



end.
