unit pComuns;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON,
  REST.Authenticator.Basic, FMX.Dialogs, REST.Types, REST.Response.Adapter, REST.Client,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.DApt, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdAuthentication,
  IdHTTP,

  {$IFDEF ANDROID}
    Androidapi.JNI.GraphicsContentViewText,
    Androidapi.JNI.Provider,
    Androidapi.JNI.JavaTypes,
    Androidapi.JNI.Net,
    Androidapi.JNI.App,
    Androidapi.JNI.Os,
    Androidapi.JNIBridge,
    FMX.Helpers.Android,
    Androidapi.Helpers,
    FMX.Platform.Android,

  {$ENDIF}

  System.IOUtils, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TprvComuns = class(TDataModule)
    FDMemTableMeusPedidos: TFDMemTable;
    FDMemTableItens: TFDMemTable;
    FDMemTableParcelas: TFDMemTable;
    FDMemTableProdutos: TFDMemTable;
    FDMemTableNovoPedido: TFDMemTable;
    FDMemTableNovoItem: TFDMemTable;
    FDMemTablePedido: TFDMemTable;
    FDMemTableClientes: TFDMemTable;
    FDConnectionLocal: TFDConnection;
    FDQueryConfigura: TFDQuery;
    FDMemTableCondicoes: TFDMemTable;
    FDMemTableItem: TFDMemTable;
    FDMemTableVendedores: TFDMemTable;
    FDMemTableProdutoItem: TFDMemTable;
    FDMemTableCondicao: TFDMemTable;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    FDMemTableGrade: TFDMemTable;
    FDQueryConfiguraid: TGuidField;
    FDQueryConfiguraidCliente: TIntegerField;
    FDQueryConfiguranomeCliente: TStringField;
    FDQueryConfiguraidCondicao: TIntegerField;
    FDQueryConfiguranomeCondicao: TStringField;
    FDQueryConfiguraipAPI: TStringField;
    FDQueryConfiguraportaAPI: TStringField;
    FDQueryConfiguralerEtiquetaCodBarra: TBooleanField;
    FDQueryConfiguramostrarSomentePedidoVendedor: TBooleanField;
    FDQueryConfiguranumeracaoSequencial: TBooleanField;
    FDMemTableEmpresa: TFDMemTable;
    FDQueryConfiguratipoLeitorCodBarra: TStringField;
    procedure FDConnectionLocalBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    function RetornaURL: string;
    function RetornaErro(XContent: string): string;
    procedure CarregaPesquisaProduto(XContent: string);
  public
    FBaseURL: string;
    FIdUsuario: integer;
    FNomeUsuario,FSenha,FTipoLeitor: string;
    function ValidaAcesso(XUsuario: integer; XNomeUsuario,XSenha,XSenha1: string): boolean;
    function CarregaPedido(XIdPedido: integer): boolean;
    function CarregaMeusPedidos(XData: tdatetime; XVendedor: string): boolean;
    function CarregaItensPedido(XPedido: integer): boolean;
    function CarregaParcelasPedido(XPedido: integer): boolean;
    function PesquisaProdutos(XProduto,XTipo: string; XPagina: integer): boolean;
    function PesquisaProduto(XIdProduto: integer): boolean;
    function PesquisaEmpresa(XIdEmpresa: integer): boolean;
    function PesquisaProdutoGrade(XIdProduto: integer): boolean;
    function PesquisaCondicao(XIdCondicao: integer): boolean;
    function PesquisaProdutoItem(XPedido,XIdProduto: integer): boolean;
    function PesquisaProdutoItemGrade(XPedido,XIdProduto,XTamanho,XCor: integer): boolean;
    function NovoPedido(XPedido: TJSONObject): boolean;
    function NovoItem(XPedido: integer; XItem: TJSONObject): boolean;
    function AlteraPedido(XIdPedido: integer; XPedido: TJSONObject): boolean;
    function AlteraPedidoItem(XIdPedido,XIdItem: integer; XItem: TJSONObject): boolean;
    function ExcluiPedido(XIdPedido: integer): boolean;
    function ExcluiItem(XIdPedido,XIdItem: integer): boolean;
    function CarregaClientes(XCliente: string): boolean;
    function CarregaVendedores(XVendedor: string): boolean;
    function CarregaCondicoes(XCondicao: string): boolean;
    function AbreConexaoLocal: boolean;
    function FechaConexaoLocal: boolean;
    function DownloadPedidoPDF(XIdPedido: integer): boolean;
    function AbreArquivoPedidoPDF: boolean;
    function RetornaTipoLeituraCEAN: boolean;
    { Public declarations }
  end;

var
  prvComuns: TprvComuns;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses RESTRequest4D, DataSet.Serialize;

//const BASE_URL = 'http://192.168.1.32:9000';
//const BASE_URL = 'http://192.168.8.56:9000';
//const BASE_URL = '';

function TprvComuns.RetornaURL: string;
var wret,wip,wporta: string;
begin
  try
    AbreConexaoLocal;
    with FDQueryConfigura do
    begin
      DisableControls;
      Close;
      Open;
      EnableControls;
      wip    := FieldByName('ipAPI').AsString;
      wporta := FieldByName('portaAPI').AsString;
      wret   := 'http://'+wip+':'+wporta;
    end;
    FechaConexaoLocal;
  except
    On E: Exception do
    begin
      showmessage('Erro ao retornar URL '+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.RetornaTipoLeituraCEAN: boolean;
var wret: boolean;
begin
  try
    AbreConexaoLocal;
    with FDQueryConfigura do
    begin
      DisableControls;
      Close;
      Open;
      EnableControls;
      wret   := FieldByName('lerEtiquetaCodBarra').Asboolean;
    end;
    FechaConexaoLocal;
  except
    On E: Exception do
    begin
      showmessage('Erro ao retornar Tipo de Leitura CEAN '+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;


function TprvComuns.ValidaAcesso(XUsuario: integer; XNomeUsuario,XSenha,XSenha1: string): boolean;
var wret: boolean;
begin
  if (LowerCase(XSenha)=LowerCase(XSenha1)) then
     begin
       FIdUsuario   := XUsuario;
       FNomeUsuario := XNomeUsuario;
       FSenha       := XSenha;
       wret         := true;
     end
  else
     wret := false;
  Result := wret;
end;

function TprvComuns.CarregaMeusPedidos(XData: tdatetime; XVendedor: string): boolean;
var wresponse: IResponse;
    wret: boolean;
    wfiltro,werro: string;
begin
  try
    wfiltro   := '?dataemissao='+formatdatetime('dd/mm/yyyy',XData);
    if length(trim(XVendedor))>0 then
       wfiltro := wfiltro+'&vendedor='+XVendedor;
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos'+wfiltro)
      .Timeout(300000) // 300 segundos
      .DataSetAdapter(FDMemTableMeusPedidos)
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret  := false;
                 werro := RetornaErro(wresponse.Content);
                 if (werro='Nenhum pedido encontrado') and (XData=date) then
                    werro := ''
                 else
                    showmessage(werro);
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;


function TprvComuns.CarregaPedido(XIdPedido: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XIdPedido))
      .DataSetAdapter(FDMemTablePedido)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

procedure TprvComuns.DataModuleCreate(Sender: TObject);
begin
  FBaseURL := RetornaURL;
end;

function TprvComuns.CarregaItensPedido(XPedido: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  FDMemTableItens.Close;
  FDMemTableItens.FieldDefs.Clear;

  FDMemTableItens.FieldDefs.Add('foto',TFieldType.ftWideString,65536,false);
  FDMemTableItens.FieldDefs.Add('id',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('idorcamento',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('idproduto',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('xcodproduto',TFieldType.ftString,255,false);
  FDMemTableItens.FieldDefs.Add('xdescproduto',TFieldType.ftString,255,false);
  FDMemTableItens.FieldDefs.Add('idaliquota',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('xcodaliquota',TFieldType.ftString,255,false);
  FDMemTableItens.FieldDefs.Add('idvendedor',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('xvendedor',TFieldType.ftString,255,false);
  FDMemTableItens.FieldDefs.Add('idsituacaotributaria',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('xsituacaotributaria',TFieldType.ftString,255,false);
  FDMemTableItens.FieldDefs.Add('idcodigofiscal',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('xcodigofiscal',TFieldType.ftString,255,false);
  FDMemTableItens.FieldDefs.Add('numerocalcado',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('idcorcalcado',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('xtamanho',TFieldType.ftString,255,false);
  FDMemTableItens.FieldDefs.Add('xcor',TFieldType.ftString,255,false);
  FDMemTableItens.FieldDefs.Add('valorunitario',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('valortotal',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('quantidade',TFieldType.ftInteger,0,false);
  FDMemTableItens.FieldDefs.Add('percentualicms',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('baseicms',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('valoricms',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('basest',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('valorst',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('percentualpis',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('percentualcofins',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('percentualbasepis',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('percentualbasecofins',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('valorpis',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('valorcofins',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('cstpis',TFieldType.ftString,0,false);
  FDMemTableItens.FieldDefs.Add('cstcofins',TFieldType.ftString,0,false);
  FDMemTableItens.FieldDefs.Add('percentualdesconto',TFieldType.ftFloat,0,false);
  FDMemTableItens.FieldDefs.Add('valordesconto',TFieldType.ftFloat,0,false);
  FDMemTableItens.CreateDataSet;
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XPedido)+'/itens')
      .Accept('application/json')
      .Timeout(300000) // 300 segundos
      .DataSetAdapter(FDMemTableItens)
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
               end;
    else
       begin
         wret := true;
       end;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.CarregaParcelasPedido(XPedido: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XPedido)+'/parcelas')
      .DataSetAdapter(FDMemTableParcelas)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.PesquisaProdutos(XProduto,XTipo: string; XPagina: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
    wfiltro,wdesc: string;
begin
  if XTipo='código' then
     wfiltro := '?codigo='+XProduto
  else if XTipo='descrição' then
     wfiltro := '?descricao='+XProduto
  else
     wfiltro := '?codigobarra='+XProduto;

  if XPagina>=0 then
     wfiltro := wfiltro+'&pagina='+inttostr(XPagina);

  FDMemTableProdutos.Close;
  FDMemTableProdutos.FieldDefs.Clear;

  FDMemTableProdutos.FieldDefs.Add('foto',TFieldType.ftWideString,65536,false);
  FDMemTableProdutos.FieldDefs.Add('id',TFieldType.ftInteger,0,false);
  FDMemTableProdutos.FieldDefs.Add('codigo',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('cean',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('descricao',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('unidade',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('marca',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('fabricante',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('preco1',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco2',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco3',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco4',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco5',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco6',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco7',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco8',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco9',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco10',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('grade',TFieldType.ftInteger,0,false);
  FDMemTableProdutos.CreateDataSet;

  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/cadastros/produtos'+wfiltro+'')
      .DataSetAdapter(FDMemTableProdutos)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Accept('application/json')
      .Get;
    case wresponse.StatusCode of
      400,404,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       begin
         wret := true;
       end;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      if XPagina<=0 then
         showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

procedure TprvComuns.CarregaPesquisaProduto(XContent: string);
var jobj: TJSONObject;
    jarray: TJSONArray;
    ix: integer;
    wquery: TFDQuery;
    wfoto: widestring;
    wid,wcodigo,wdescricao,wcean,wunidade,wmarca,wfabricante,wpreco,wgrade: string;
    wproduto: TJSONObject;
    wfile,wfile2,wfile3: TStringList;
begin
  jarray := TJSONObject.ParseJSONValue(XContent) as TJSONArray;
  wfile := TStringList.Create;
  wfile.Add(XContent);
  wfile.SaveToFile(GetCurrentDir+'\arquivo2.txt');

  FDMemTableProdutos.FieldDefs.Add('foto',TFieldType.ftWideString,65536,false);
  FDMemTableProdutos.FieldDefs.Add('id',TFieldType.ftInteger,0,false);
  FDMemTableProdutos.FieldDefs.Add('codigo',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('cean',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('descricao',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('unidade',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('marca',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('fabricante',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('preco',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('grade',TFieldType.ftInteger,0,false);
  FDMemTableProdutos.CreateDataSet;

{  wproduto := TJSONObject.Create;
  wproduto.AddPair('id','');
  wproduto.AddPair('codigo','');
  wproduto.AddPair('cean','');
  wproduto.AddPair('descricao','');
  wproduto.AddPair('unidade','');
  wproduto.AddPair('marca','');
  wproduto.AddPair('fabricante','');
  wproduto.AddPair('preco','');
  wproduto.AddPair('grade','');
  wproduto.AddPair('foto','');
  wproduto.ad
  FDMemTableProdutos.LoadFromJSON(wproduto);}

  if FDMemTableProdutos.RecordCount>0 then
     FDMemTableProdutos.EmptyDataSet;

  for ix:= jarray.Count-1 downto 0  do
    begin
      FDMemTableProdutos.Insert;
      if jarray.Get(ix).TryGetValue('id',wid) then
         FDMemTableProdutos.FieldByName('id').AsInteger  := strtointdef(wid,0);
      if jarray.Get(ix).TryGetValue('codigo',wcodigo) then
         FDMemTableProdutos.FieldByName('codigo').AsString  := wcodigo;
      if jarray.Get(ix).TryGetValue('descricao',wdescricao) then
         FDMemTableProdutos.FieldByName('descricao').AsString  := wdescricao;
      if jarray.Get(ix).TryGetValue('cean',wcean) then
         FDMemTableProdutos.FieldByName('cean').AsString  := wcean;
      if jarray.Get(ix).TryGetValue('unidade',wunidade) then
         FDMemTableProdutos.FieldByName('unidade').AsString  := wunidade;
      if jarray.Get(ix).TryGetValue('marca',wmarca) then
         FDMemTableProdutos.FieldByName('marca').AsString  := wmarca;
      if jarray.Get(ix).TryGetValue('fabricante',wfabricante) then
         FDMemTableProdutos.FieldByName('fabricante').AsString  := wfabricante;
      if jarray.Get(ix).TryGetValue('preco',wpreco) then
         FDMemTableProdutos.FieldByName('preco').AsFloat  := strtofloatdef(StringReplace(wpreco,'.',',',[rfReplaceAll]),0);
      if jarray.Get(ix).TryGetValue('grade',wgrade) then
         FDMemTableProdutos.FieldByName('grade').AsInteger  := strtointdef(wgrade,0);
//      if jarray.Get(ix).TryGetValue('foto',wfoto) then
//         FDMemTableProdutos.FieldByName('foto').AsWideString := wfoto;
      jobj := jarray.Items[ix] as TJSONObject;
      wfile2 := TStringList.Create;
      wfile2.Add(jobj.GetValue('foto').Value);
      wfile2.SaveToFile(GetCurrentDir+'\arquivo3.txt');
      FDMemTableProdutos.FieldByName('foto').AsWideString  := jobj.GetValue('foto').Value;
      FDMemTableProdutos.Post;
      wfile3 := TStringList.Create;
      wfile3.Add(FDMemTableProdutos.FieldByName('foto').AsWideString);
      wfile3.SaveToFile(GetCurrentDir+'\arquivo4.txt');
    end;

//    showmessage(inttostr(FDMemTableProdutos.RecordCount));

//    showmessage(jobj.Get(0).GetValue('foto',wdesc));
//    FDMemTableProdutos


//    showmessage(wresponse.Content);
//    showmessage(FDMemTableProdutos.FieldByName('descricao').AsString);
end;


function TprvComuns.PesquisaProduto(XIdProduto: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  FDMemTableProdutos.Close;
  FDMemTableProdutos.FieldDefs.Clear;

  FDMemTableProdutos.FieldDefs.Add('foto',TFieldType.ftWideString,65536,false);
  FDMemTableProdutos.FieldDefs.Add('id',TFieldType.ftInteger,0,false);
  FDMemTableProdutos.FieldDefs.Add('codigo',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('cean',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('descricao',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('unidade',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('marca',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('fabricante',TFieldType.ftString,255,false);
  FDMemTableProdutos.FieldDefs.Add('preco1',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco2',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco3',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco4',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco5',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco6',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco7',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco8',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco9',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('preco10',TFieldType.ftFloat,0,false);
  FDMemTableProdutos.FieldDefs.Add('grade',TFieldType.ftInteger,0,false);
  FDMemTableProdutos.CreateDataSet;
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/cadastros/produtos/'+inttostr(XIdProduto)+'')
      .DataSetAdapter(FDMemTableProdutos)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .AcceptCharset('utf-8')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       begin
//         CarregaPesquisaProduto(wresponse.Content);
         wret := true;
       end;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.PesquisaEmpresa(XIdEmpresa: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/cadastros/empresas/'+inttostr(XIdEmpresa)+'')
      .DataSetAdapter(FDMemTableEmpresa)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .AcceptCharset('utf-8')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       begin
//         CarregaPesquisaProduto(wresponse.Content);
         wret := true;
       end;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;


function TprvComuns.PesquisaProdutoGrade(XIdProduto: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/cadastros/produtos/'+inttostr(XIdProduto)+'/grade')
      .DataSetAdapter(FDMemTableGrade)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .AcceptCharset('utf-8')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;


function TprvComuns.PesquisaCondicao(XIdCondicao: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/cadastros/condicoes/'+inttostr(XIdCondicao)+'')
      .DataSetAdapter(FDMemTableCondicao)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;


function TprvComuns.PesquisaProdutoItem(XPedido,XIdProduto: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XPedido)+'/itens/produto/'+inttostr(XIdProduto)+'')
      .DataSetAdapter(FDMemTableProdutoItem)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.PesquisaProdutoItemGrade(XPedido,XIdProduto,XTamanho,XCor: integer): boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XPedido)+'/itens/produto/'+inttostr(XIdProduto)+'/tamanho/'+inttostr(XTamanho)+'/cor/'+inttostr(XCor))
      .Timeout(300000) // 300 segundos
      .DataSetAdapter(FDMemTableProdutoItem)
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;


function TprvComuns.NovoPedido(XPedido: TJSONObject) : boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos')
      .ContentType('application/json')
      .AddBody(XPedido)
      .AddHeader('idempresa','77222')
      .Timeout(300000) // 300 segundos
      .DataSetAdapter(FDMemTableNovoPedido)
      .BasicAuthentication('user','password')
      .Post;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.AlteraPedido(XIdPedido: integer; XPedido: TJSONObject) : boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XIdPedido))
      .ContentType('application/json')
      .AddBody(XPedido)
      .AddHeader('idempresa','77222')
      .Timeout(300000) // 300 segundos
      .DataSetAdapter(FDMemTablePedido)
      .BasicAuthentication('user','password')
      .Put;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.AlteraPedidoItem(XIdPedido,XIdItem: integer; XItem: TJSONObject) : boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XIdPedido)+'/itens/'+inttostr(XIdItem))
      .ContentType('application/json')
      .AddBody(XItem)
      .AddHeader('idempresa','77222')
      .Timeout(300000) // 300 segundos
      .DataSetAdapter(FDMemTableItem)
      .BasicAuthentication('user','password')
      .Put;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;


function TprvComuns.ExcluiPedido(XIdPedido: integer) : boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XIdPedido))
      .AddHeader('idempresa','77222')
//      .DataSetAdapter(FDMemTablePedido)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Delete;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.ExcluiItem(XIdPedido,XIdItem: integer) : boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XIdPedido)+'/itens/'+inttostr(XIdItem))
      .AddHeader('idempresa','77222')
//      .DataSetAdapter(FDMemTablePedido)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Delete;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.NovoItem(XPedido: integer; XItem: TJSONObject) : boolean;
var wresponse: IResponse;
    wret: boolean;
begin
  try
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/movimentos/orcamentos/'+inttostr(XPedido)+'/itens')
      .ContentType('application/json')
      .AddBody(XItem)
      .AddHeader('idempresa','77222')
      .Timeout(300000) // 300 segundos
      .DataSetAdapter(FDMemTableNovoItem)
      .BasicAuthentication('user','password')
      .Post;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.CarregaClientes(XCliente: string): boolean;
var wresponse: IResponse;
    wret: boolean;
    wfiltro: string;
begin
  try
    wfiltro   := '?nome='+XCliente;
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/cadastros/clientes'+wfiltro)
      .DataSetAdapter(FDMemTableClientes)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,404,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.CarregaVendedores(XVendedor: string): boolean;
var wresponse: IResponse;
    wret: boolean;
    wfiltro: string;
begin
  try
    wfiltro   := '?nome='+XVendedor;
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/cadastros/vendedores'+wfiltro)
      .DataSetAdapter(FDMemTableVendedores)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Get;
    case wresponse.StatusCode of
      400,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;


function TprvComuns.CarregaCondicoes(XCondicao: string): boolean;
var wresponse: IResponse;
    wret: boolean;
    wfiltro: string;
begin
  try
    wfiltro   := '?descricao='+XCondicao;
//    showmessage(wfiltro);
    wresponse := TRequest.New.BaseURL(FBaseURL)
      .Resource('trabinapi/cadastros/condicoes'+wfiltro)
      .DataSetAdapter(FDMemTableCondicoes)
      .Timeout(300000) // 300 segundos
      .BasicAuthentication('user','password')
      .Get;
//    showmessage(inttostr(wresponse.StatusCode));
    case wresponse.StatusCode of
      400,404,500: begin
                 wret := false;
//                 showmessage(RetornaErro(wresponse.Content));
//                 showmessage(wresponse.Content);
               end;
    else
       wret := true;
    end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.AbreArquivoPedidoPDF: boolean;
var wret: boolean;
    warqlocal: string;
    {$IFDEF ANDROID}
      wIntentJ: JIntent;
      wJar: JFile;
    {$ENDIF}
begin
  try
    {$IFDEF MSWINDOWS}
        warqlocal := GetCurrentDir + '\arquivo-pedido.pdf';
    {$ELSE}
        warqlocal := TPath.Combine(TPath.GetDocumentsPath,'arquivo-pedido.pdf');
    {$ENDIF}

    if not FileExists(warqlocal) then
       begin
         showmessage('Arquivo não encontrado: '+warqlocal);
         wret := false;
       end
    else
       begin
        {$IFDEF ANDROID}
          wJar     := TJFile.JavaClass.init(StringToJString(warqlocal));
          wIntentJ := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
          wIntentJ.setDataAndType(TAndroidHelper.JFileToJURI(wJar),StringToJString('application/pdf'));
          wIntentJ.setFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
          TAndroidHelper.Activity.startActivity(wIntentJ);
        {$ENDIF}
         wret := true;
       end;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage(E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.AbreConexaoLocal: boolean;
var wret: boolean;
begin
  try
    if not FDConnectionLocal.Connected then
       FDConnectionLocal.Connected := true;
    wret := true;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage('Problema ao abrir conexão local'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TprvComuns.FDConnectionLocalBeforeConnect(Sender: TObject);
begin
  {$IFDEF ANDROID}
//    showmessage(GetHomePath);
    FDConnectionLocal.Params.Values['Database'] := GetHomePath + PathDelim + 'PedidoMobile7.db3';
  {$ENDIF ANDROID}
end;

function TprvComuns.FechaConexaoLocal: boolean;
var wret: boolean;
begin
  try
    if FDConnectionLocal.Connected then
       FDConnectionLocal.Connected := false;
    wret := true;
  except
    On E: Exception do
    begin
      wret := false;
      showmessage('Problema ao fechar conexão local'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TprvComuns.RetornaErro(XContent: string): string;
var wret: string;
    wpos: integer;
begin
  wret := XContent;
  wpos := pos('description',XContent);
  if wpos>0 then
     begin
       delete(wret,1,wpos+13);
       wret := copy(wret,1,pos('datetime',wret)-4);

     end;
  Result := wret;
end;

function TprvComuns.DownloadPedidoPDF(XIdPedido: integer): boolean;
var wret: boolean;
    wstream: TMemoryStream;
    wURL,wretorno,wretjson,warqlocal: string;
    wstatus: integer;
begin
  try

    {$IFDEF MSWINDOWS}
        warqlocal := GetCurrentDir + '\arquivo-pedido.pdf';
    {$ELSE}
        warqlocal := TPath.Combine(TPath.GetDocumentsPath,'arquivo-pedido.pdf');
    {$ENDIF}
    wstream := TMemoryStream.Create;


    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/octet-stream';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/octet-stream';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := FBaseURL+'/trabinapi/arquivos/orcamento/'+inttostr(XIdPedido);


    IdHTTP1.Get(wURL,wstream);


    wstream.Position := 0;

    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;
    if wstatus=200 then
       begin
         wstream.SaveToFile(warqlocal);
         wret := true;
       end
    else
       wret := false;

  except
    On E: Exception do
    begin
      wret := false;
      ShowMessage(E.Message);
    end;

  end;
  Result := wret;
end;


end.
