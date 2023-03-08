unit prv.srvAutorizaNFe;

interface

uses Horse,Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,blcksock,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,pcnRetConsSitNFe,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
     System.Generics.Collections, Math, System.StrUtils, ACBrUtil,prv.dataModuleConexao,
     ACBrBase, ACBrDFe, ACBrDFeSSL, ACBrNFe, IniFiles, pcnConversao, pcnConversaoNFe, ACBrDFeConfiguracoes,
     ACBrDFeReport, ACBrDFeDANFeReport, ACBrNFeDANFEClass, ACBrNFeDANFeESCPOS, TypInfo,
     ACBrPosPrinter ;

type
  TVendedor = class
    private
    FXCampo: string;
    FXTexto: string;
    public
      property XCampo: string read FXCampo write FXCampo;
      property XTexto: string read FXTexto write FXTexto;
  end;

  TAgenciada = class
    private
    FXCampo: string;
    FXTexto: string;
    public
      property XCampo: string read FXCampo write FXCampo;
      property XTexto: string read FXTexto write FXTexto;
  end;

  TProviderServicoAutorizaNFe = class(TDataModule)
    ACBrNFeAPI: TACBrNFe;
    ACBrNFeAPI2: TACBrNFe;
    procedure DataModuleCreate(Sender: TObject);
  private
    FIni : TIniFile;
    FAdicionarLiteral,FEmissaoPathNFe,FSalvarArquivos,FSalvarApenasNFeProcessadas,FSalvarEvento,FSepararPorCNPJ,FSepararPorMes,FSepararPorModelo,FIncluirRefProd,FUsaEANImpressao: boolean;
    FAjustaAguardaConsultaRet,FVisualizar,FVerificarValidade,FValidarDigest,FNaoEnviaNomeFantasia,FNaoEnviaCodigoBarra,FConsumidorFinal,FAutXMLAcess,FIncluirObsProd,FDiferimento: boolean;
    FIniServicos,FCaminhoArquivoXML,FPathSchemas,FUF,FQuebradeLinha,FSSLType,FNumeroSerie,FSenha,FCaminhoCertificado,FCSRT,FCnpjAutXMLAcess: string;
    FCNPJRT,FXContatoRT,FEmailRT,FFoneRT,FCSC,FFormatoAlerta,FIdCSC,FCNPJEmitente,FSSLCryptLib,FSSLHttpLib,FSSLLib,FSSLXmlSignLib,FSequenceUltDoc: string;
    FAtualizarXMLCancelado,FExibirErroSchema,FIncluirQRCodeXMLNFCe,FQRCodeLateral,FICMSEfetivo,FRetirarAcentos,FSalvarGeral,FCnpjAutSomenteVeiculo,FIncluirCxsProd,FIncluirLocProd: boolean;
    FAguardarConsultaRet, FIntervaloTentativas, FTentativas, FTimeOut,FidCSRT,FClienteConsumidor,FNumCaracLoc: integer;
    FPathNFe, FPathSalvar, FPathDonwload, FPathEvento, FPathInu: string;
    FAmbiente: TpcnTipoAmbiente;
    FFormaEmissao: TpcnTipoEmissao;
    FModeloDF: TpcnModeloDF;
    FVersaoDF: TpcnVersaoDF;
    FVersaoQrCode: TpcnVersaoQrCode;
    FSomaVtotTribUnit,FSomaDesconto,FSomaICMSUFDest,FSomaICMSUFRemet,
    FSomaFCP, FSomaFCPST,FSomaFCPSTRet,FSomaFCPUFDest: double;
    Fconexao: TProviderDataModuleConexao;

    function CarregaArquivoIni: boolean;
    function VerificaCertificadoDigital: boolean;
    function RetornaSSLLib(XSSLLib: string): TSSLLib;
    function RetornaSSLCryptLib(XSSLCryptLib: string): TSSLCryptLib;
    function RetornaSSLHttpLib(XSSLHttpLib: string): TSSLHttpLib;
    function RetornaSSLXmlSignLib(XSSLXmlSignLib: string): TSSLXmlSignLib;
    function RetornaSSLType(XSSLType: string): TSSLType;
    function VerificaStatusServicoNFe: boolean;
    function IniciaServico: boolean;
    function CriaNota(XId: Integer): boolean;
    procedure CarregaComponenteNFeACBr(XId: integer; XqueryNota,XqueryItem,XqueryCondicao,XqueryParcela,XQueryValorParcela,XQueryTransporte: TFDQuery);
    procedure GravaItem(XQueryNota,XQueryItem: TFDQuery; XConsumidorFinal: boolean);
    function Min_Round(const AValue: Double; const ADigit: TRoundToRange): Double;
    function ConfiguraNFe: boolean;
    function RetornaCaixas(XCaixas: string): string;
    function ArredondaValorNew(XValor: double; XDecimal: integer): double;
    function AssinaNota: boolean;
    function ValidaNota: boolean;
    function RetornaSequence(XSequence,XTipo: string): integer;
    procedure GravaPagamento(XQueryNota: TFDQuery; XNum: integer);
    function EnviaNota(XId: integer): boolean;
    procedure AnalisaRetorno(XId: integer; XStatus: integer; XMotivo: string);
    procedure AtualizaNumeroDocumento(XId: integer);
    procedure AtualizaSequence;
    function CancelarEvento(var Retorno: string; XChave, XJustificativa: string;
      XIdNota: integer; XMensagem: boolean): boolean;
    function RetornaChaveNFe(XIdNota: integer): string;
    procedure AtualizaNumeroSituacaoNota(XIdNota: integer);
    procedure ApagaParcelasNota(XIdNota: integer);
    function VerificaXMLNota(XChave: string): boolean;
    procedure MostraMensagem(XMensagem: string);
    procedure AtualizaStatus(XChave,XStatus: string);
    procedure AtualizaListaXML;

    { Private declarations }
  public
    function DFeRetornaArquivoIni: TJSONObject;
    function CriaNFe(XId: integer): TJSONObject;
    function ConsultaNFe(XChave: string): TJSONObject;
    function CancelaNFe(XIdNota: integer): TJSONObject;
    function ConsultaStatusWS: TJSONObject;
    function ConsultaDFeUltimoNSU(XUltNSU: string): TJSONArray;
    function DarCienciaDFe(XChave: string): TJSONObject;
    function ConfirmaOperacao(XChave: string): TJSONObject;
    function DesconheceOperacao(XChave: string): TJSONObject;
    function OperacaoNaoRealizada(XChave: string): TJSONObject;
    function TransfereArquivosXML: TJSONObject;

    { Public declarations }
  end;

var
  ProviderServicoAutorizaNFe: TProviderServicoAutorizaNFe;
  wdescerro: string;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses dat.movDFeConsultados;


{$R *.dfm}

{ TDataModule1 }

function TProviderServicoAutorizaNFe.CarregaArquivoIni: boolean;
var wret: boolean;
begin
  try
    if not FileExists(GetCurrentDir+'\Autorizador.ini') then
       begin
         wdescerro := 'Arquivo Autorizador.ini não localizado';
         Result    := false;
         exit;
       end;

    FIni := TIniFile.Create(GetCurrentDir+'\Autorizador.ini');

// carrega variaveis de WebService
    FAguardarConsultaRet      := FIni.ReadInteger('WebService','AguardaConsultaRet',0);
    FAjustaAguardaConsultaRet := uppercase(FIni.ReadString('WebService','AjustaAguardaConsultaRet','Sim'))='SIM';
    if FIni.ReadInteger('WebService','Ambiente',2)=2 then
       FAmbiente := taHomologacao
    else if FIni.ReadInteger('WebService','Ambiente',2)=1 then
       FAmbiente := taProducao;
    FIntervaloTentativas      := FIni.ReadInteger('WebService','IntervaloTentativas',0);
    FTentativas               := FIni.ReadInteger('WebService','Tentativas',5);
    FUF                       := FIni.ReadString('WebService','UF','RS');
    FQuebradeLinha            := FIni.ReadString('WebService','QuebradeLinha','|');
    FAjustaAguardaConsultaRet := uppercase(FIni.ReadString('WebService','Salvar','Sim'))='SIM';
    FVisualizar               := uppercase(FIni.ReadString('WebService','Visualizar','Sim'))='SIM';
    FTimeOut                  := FIni.ReadInteger('WebService','TimeOut',1000);
    FSSLType                  := FIni.ReadString('WebService','SSLType','');
// carrega variaveis de Certificado
    FNumeroSerie              := FIni.ReadString('Certificado','NumeroSerie','');
    FSenha                    := FIni.ReadString('Certificado','Senha','');
    FCaminhoCertificado       := FIni.ReadString('Certificado','Caminho','');
    FVerificarValidade        := uppercase(FIni.ReadString('Certificado','VerificarValidade','Sim'))='SIM';
// carrega variaveis de Arquivos
    FAdicionarLiteral         := uppercase(FIni.ReadString('Arquivos','AdicionarLiteral','Não'))='SIM';
    FEmissaoPathNFe           := uppercase(FIni.ReadString('Arquivos','EmissaoPathNFe','Não'))='SIM';
    FIniServicos              := FIni.ReadString('Arquivos','IniServicos','');
    FPathSchemas              := FIni.ReadString('Arquivos','PathSchemas','');
    FPathNFe                  := FIni.ReadString('Arquivos','PathNFe','');
    FPathSalvar               := FIni.ReadString('Arquivos','PathSalvar','');
    FPathDonwload             := FIni.ReadString('Arquivos','PathDownload','');
    FPathEvento               := FIni.ReadString('Arquivos','PathEvento','');
    FPathInu                  := FIni.ReadString('Arquivos','PathInu','');
    FSalvarArquivos           := uppercase(FIni.ReadString('Arquivos','Salvar','Não'))='SIM';
    FSalvarApenasNFeProcessadas := uppercase(FIni.ReadString('Arquivos','SalvarApenasNFeProcessadas','Não'))='SIM';
    FSalvarEvento             := uppercase(FIni.ReadString('Arquivos','SalvarEvento','Não'))='SIM';
    FSepararPorCNPJ           := uppercase(FIni.ReadString('Arquivos','SepararPorCNPJ','Não'))='SIM';
    FSepararPorMes            := uppercase(FIni.ReadString('Arquivos','SepararPorMes','Não'))='SIM';
    FSepararPorModelo         := uppercase(FIni.ReadString('Arquivos','SepararPorModelo','Não'))='SIM';
// carrega variáveis Geral
    FCaminhoArquivoXML        := FIni.ReadString('Geral','CaminhoSalvar','');
    FAtualizarXMLCancelado    := uppercase(FIni.ReadString('Geral','AtualizarXMLCancelado','Não'))='SIM';
    FCSC                      := FIni.ReadString('Geral','CSC','');
    FExibirErroSchema         := uppercase(FIni.ReadString('Geral','ExibirErroSchema','Não'))='SIM';
    FFormaEmissao             := teNormal;
    FFormatoAlerta            := FIni.ReadString('Geral','FormatoAlerta','');
    FIdCSC                    := FIni.ReadString('Geral','IdCSC','1');
    FCNPJEmitente             := FIni.ReadString('Geral','CNPJEmitente','');
    FIncluirQRCodeXMLNFCe     := uppercase(FIni.ReadString('Geral','IncluirQRCodeXMLNFCe','Sim'))='SIM';
    FModeloDF                 := moNFCe;
    FSSLCryptLib              := FIni.ReadString('Geral','SSLCryptLib','');
    FSSLHttpLib               := FIni.ReadString('Geral','SSLHttpLib','');
    FSSLLib                   := FIni.ReadString('Geral','SSLLib','libCapicom');
    FSSLXmlSignLib            := FIni.ReadString('Geral','SSLXmlSignLib','');
    FQRCodeLateral            := uppercase(FIni.ReadString('Geral','QrCodeLateral','Não'))='SIM';
    FICMSEfetivo              := uppercase(FIni.ReadString('Geral','ICMSEfetivo','Não'))='SIM';
    FModeloDF                 := moNFe;
    FRetirarAcentos           := uppercase(FIni.ReadString('Geral','RetirarAcentos','Sim'))='SIM';
    FSalvarGeral              := uppercase(FIni.ReadString('Geral','Salvar','Sim'))='SIM';
//    FSSLLib                   := libCapicom;
    FValidarDigest            := uppercase(FIni.ReadString('Geral','ValidarDigest','Sim'))='SIM';
    if uppercase(FIni.ReadString('Geral','Versao','ve310'))='VE310' then
       FVersaoDF              := ve310
    else if uppercase(FIni.ReadString('Geral','Versao','ve310'))='VE400' then
       FVersaoDF              := ve400;
    if uppercase(FIni.ReadString('Geral','VersaoQrCode','veqr100'))='VEQR100' then
       FVersaoQrCode          := TpcnVersaoQrCode.veqr100
    else if uppercase(FIni.ReadString('Geral','VersaoQrCode','veqr100'))='VEQR200' then
       FVersaoQrCode          := TpcnVersaoQrCode.veqr200;
    FNaoEnviaNomeFantasia     := uppercase(FIni.ReadString('Geral','NaoEnviaNomeFantasia','Não'))='SIM';
    FNaoEnviaCodigoBarra      := uppercase(FIni.ReadString('Geral','NaoEnviaCodigoBarras','Não'))='SIM';
    FClienteConsumidor        := FIni.ReadInteger('Geral','ClienteConsumidor',0);
    FConsumidorFinal          := uppercase(FIni.ReadString('DocumentoEletronico','ConsumidorFinal','Sim'))='SIM';
    FAutXMLAcess              := uppercase(FIni.ReadString('DocumentoEletronico','AutorizaXMLAcesso','Sim'))='SIM';
    FCnpjAutSomenteVeiculo    := uppercase(FIni.ReadString('DocumentoEletronico','AutorizaXMLSomenteVeiculos','Não'))='SIM';
    FCnpjAutXMLAcess          := FIni.ReadString('DocumentoEletronico','CnpjAutorizaXMLAcesso','');
    FIncluirRefProd           := uppercase(FIni.ReadString('DocumentoEletronico','IncluirRefProduto','Não'))='SIM';
    FIncluirObsProd           := uppercase(FIni.ReadString('DocumentoEletronico','IncluirObsProduto','Não'))='SIM';
    FIncluirCxsProd           := uppercase(FIni.ReadString('DocumentoEletronico','IncluirCxsProduto','Não'))='SIM';
    FIncluirLocProd           := uppercase(FIni.ReadString('DocumentoEletronico','IncluirLocProduto','Não'))='SIM';
    FUsaEANImpressao          := uppercase(FIni.ReadString('DocumentoEletronico','UsaCodigoEANImpressao','Não'))='SIM';
    FNumCaracLoc              := FIni.ReadInteger('DocumentoEletronico','NumeroCaracteresLocal',1);

// Responsável Técnico
    FidCSRT                   := FIni.ReadInteger('ResponsavelTecnico','idCSRT',0);
    FCSRT                     := FIni.ReadString('ResponsavelTecnico','CSRT','');
    FCNPJRT                   := FIni.ReadString('ResponsavelTecnico','CNPJ','');
    FXContatoRT               := FIni.ReadString('ResponsavelTecnico','XContato','');
    FEmailRT                  := FIni.ReadString('ResponsavelTecnico','Email','');
    FFoneRT                   := FIni.ReadString('ResponsavelTecnico','Fone','');

    wret := true;
  except
    on E: Exception do
    begin
      wdescerro := 'Problema ao carregar arquivo Autorizador.Ini'+slinebreak+E.Message;
      wret      := false;
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.ConfiguraNFe: boolean;
var wret: boolean;
begin
  if not CarregaArquivoIni then
     begin
       wret   := false;
       Result := wret;
       exit;
     end;
  try

// Configura Arquivos
    with ACBrNFeAPI.Configuracoes.Arquivos do
    begin
      AdicionarLiteral            := FAdicionarLiteral;
      EmissaoPathNFe              := FEmissaoPathNFe;
      IniServicos                 := FIniServicos;
      PathNFe                     := FPathNFe;
      PathSalvar                  := FPathSalvar;
      DownloadDFe.PathDownload    := FPathDonwload;
      PathEvento                  := FPathEvento;
      PathInu                     := FPathInu;

//      PathEvento                  := FCaminhoArquivoXML+'\'+formatdatetime('yyyy',now)+'\'+formatdatetime('mmmm',now);
//      PathInu                     := FCaminhoArquivoXML+'\'+formatdatetime('yyyy',now)+'\'+formatdatetime('mmmm',now);
//      PathNFe                     := FCaminhoArquivoXML+'\'+formatdatetime('yyyy',now)+'\'+formatdatetime('mmmm',now);
//      PathSalvar                  := FCaminhoArquivoXML+'\'+formatdatetime('yyyy',now)+'\'+formatdatetime('mmmm',now);
      PathSchemas                 := FPathSchemas;
      Salvar                      := FSalvarArquivos;
      SalvarApenasNFeProcessadas  := FSalvarApenasNFeProcessadas;
      SalvarEvento                := FSalvarEvento;
      SepararPorCNPJ              := FSepararPorCNPJ;
      SepararPorMes               := FSepararPorMes;
      SepararPorModelo            := FSepararPorModelo;
    end;

// Configura Certificado
    with ACBrNFeAPI.Configuracoes.Certificados do
    begin
      NumeroSerie                 := FNumeroSerie;
      Senha                       := FSenha;
      VerificarValidade           := FVerificarValidade;
      ArquivoPFX                  := FCaminhoCertificado;
    end;


// Configura Geral
    with ACBrNFeAPI.Configuracoes.Geral do
    begin
      AtualizarXMLCancelado          := FAtualizarXMLCancelado;
      CSC                            := FCSC;
      ExibirErroSchema               := FExibirErroSchema;
      FormaEmissao                   := FFormaEmissao;
      FormatoAlerta                  := FFormatoAlerta;
      IdCSC                          := FIdCSC;
//   FACBrNFe.Configuracoes.Geral.IncluirQRCodeXMLNFCe           := FIncluirQRCodeXMLNFCe;
      ModeloDF                       := FModeloDF;
      RetirarAcentos                 := FRetirarAcentos;
      Salvar                         := FSalvarGeral;
      ValidarDigest                  := FValidarDigest;
      VersaoDF                       := FVersaoDF;
      VersaoQRCode                   := FVersaoQrCode;
      CamposFatObrigatorios          := true;

{      ACBrNFeApi.SSL.SSLType         := TSSLType(0);
      SSLCryptLib                    := TSSLCryptLib(2);     // TSSLCryptLib(cbCryptLib.ItemIndex);
      SSLLib                         := TSSLLib(2);          // TSSLLib(cbSSLLib.ItemIndex);
      SSLHttpLib                     := TSSLHttpLib(1);      // TSSLHttpLib(cbHttpLib.ItemIndex);
      SSLXmlSignLib                  := TSSLXmlSignLib(3);   // TSSLXmlSignLib(cbXmlSignLib.ItemIndex);}

      if FSSLCryptLib<>'' then
         SSLCryptLib                 := RetornaSSLCryptLib(FSSLCryptLib)
      else
         SSLCryptLib                 := TSSLCryptLib(2);     // TSSLCryptLib(cbCryptLib.ItemIndex);

      if FSSLHttpLib<>'' then
         SSLHttpLib                  := RetornaSSLHttpLib(FSSLHttpLib)
      else
         SSLHttpLib                  := TSSLHttpLib(1);      // TSSLHttpLib(cbHttpLib.ItemIndex);
      if FSSLLib<>'' then
         SSLLib                      := RetornaSSLLib(FSSLLib)
      else
         SSLLib                      := TSSLLib(2);          // TSSLLib(cbSSLLib.ItemIndex);
      if FSSLXmlSignLib<>'' then
         SSLXmlSignLib               := RetornaSSLXmlSignLib(FSSLXmlSignLib)
      else
         SSLXmlSignLib               := TSSLXmlSignLib(3);   // TSSLXmlSignLib(cbXmlSignLib.ItemIndex);
    end;

// Configura WebServices
    with ACBrNFeAPI.Configuracoes.WebServices do
    begin
      AguardarConsultaRet      := FAguardarConsultaRet;
      AjustaAguardaConsultaRet := FAjustaAguardaConsultaRet;
      Ambiente                 := FAmbiente;
      IntervaloTentativas      := FIntervaloTentativas;
      Tentativas               := FTentativas;
      UF                       := FUF;
      Visualizar               := FVisualizar;
      QuebradeLinha            := FQuebradeLinha;
      Salvar                   := false;
      TimeOut                  := FTimeOut;
      if FSSLType<>'' then
         begin
          ACBrNFeApi.Configuracoes.WebServices.SSLType             := RetornaSSLType(FSSLType);
          ACBrNFeApi.SSL.SSLType                                   := RetornaSSLType(FSSLType);
        end
     else
        begin
          ACBrNFeApi.Configuracoes.WebServices.SSLType             := TSSLType(0);
          ACBrNFeApi.SSL.SSLType                                   := TSSLType(0);
        end;
    end;
// Configura Responsável Técnico
    with ACBrNFeAPI.Configuracoes.RespTec do
    begin
      CSRT                     := FCSRT;
      IdCSRT                   := FidCSRT;
    end;

    wret := true;
  except
    On E: Exception do
    begin
      wdescerro := 'Problema ao configurar AcbrNFe'+slinebreak+E.Message;
      wret := false;
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.ConsultaNFe(XChave: string): TJSONObject;
var wret: TJSONObject;
    wstatus: integer;
    wmotivo: string;
begin
  try
    wret      := TJSONObject.Create;

// Configura NFe
    if not ConfiguraNFe then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;
  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Verifca Status do WebService
    if not VerificaStatusServicoNFe then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Inicia Serviço WebService
    if not IniciaServico then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

    ACBrNFeAPI.WebServices.Consulta.NFeChave := XChave;

    if not ACBrNFeAPI.WebServices.Consulta.Executar then
       begin
         wstatus := ACBrNFeAPI.WebServices.Consulta.cStat;
         wmotivo := ACBrNFeAPI.WebServices.Consulta.XMotivo;
         wret.AddPair('status','500');
         wret.AddPair('description','Não foi possível consultar nfe '+slinebreak+'Status: '+inttostr(wstatus)+slinebreak+'Motivo: '+wmotivo);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
    else
       begin
         wstatus := ACBrNFeAPI.WebServices.Consulta.cStat;
         wmotivo := ACBrNFeAPI.WebServices.Consulta.XMotivo;
         wret.AddPair('status','200');
         wret.AddPair('description','Status: '+inttostr(wstatus)+slinebreak+'Motivo: '+wmotivo);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
  except
    On E: Exception do
    begin
      wret.AddPair('status','500');
      wret.AddPair('description','Erro ao consulta NFe.'+slinebreak+E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.ConsultaStatusWS: TJSONObject;
var wret: TJSONObject;
    wstatus: boolean;
    wretorno: string;
begin
  try
    wret      := TJSONObject.Create;
// Configura NFe
    if not ConfiguraNFe then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;
  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

// Verifca Status do WebService
    try
      wstatus := ACBrNFeAPI.WebServices.StatusServico.Executar;
    except
      On E: Exception do
      begin
        wdescerro := 'Erro ao consultar status WS'+slinebreak+E.Message;
      end;
    end;
    if not wstatus then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
    else
       begin
//         wretorno := ACBrNFeAPI.WebServices.StatusServico.RetWS;
         wretorno := ACBrNFeAPI.WebServices.StatusServico.xMotivo;
         wret.AddPair('status','200');
         wret.AddPair('description',wretorno);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
  except
    On E: Exception do
    begin
      wret.AddPair('status','500');
      wret.AddPair('description','Erro ao consultar status WS.'+slinebreak+E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.TransfereArquivosXML: TJSONObject;
var warqini: TIniFile;
    wcaminhonfe,wcaminhotransfere,warquivo,woldarquivo,wnewarquivo: string;
    wachou: boolean;
    procura: TSearchRec;
    wcta: integer;
    wret: TJSONObject;
begin
  try
    wcta        := 0;
    warqini     := TIniFile.Create(GetCurrentDir+'\Autorizador.ini');
    wcaminhonfe := warqini.ReadString('Arquivos','PathDownload','');
    wcaminhotransfere := warqini.ReadString('Arquivos','PathTransfere','')+'\'+formatdatetime('yyyy',date)+'\'+formatdatetime('mm',date);
    if not DirectoryExists(wcaminhotransfere) then
       ForceDirectories(wcaminhotransfere);
    warquivo    := wcaminhonfe+'\*-nfe.xml';
    wachou      := FindFirst(warquivo,faArchive,procura) = 0;
    if wachou then
       begin
         while wachou do
         begin
           woldarquivo := wcaminhonfe+'\'+procura.Name;
           wnewarquivo := wcaminhotransfere+'\'+procura.Name;
           if RenameFile(woldarquivo,wnewarquivo) then
              inc(wcta);
           wachou := (FindNext(Procura)=0);
         end;
         wret := TJSONObject.Create;
         wret.AddPair('status','200');
         wret.AddPair('description','Nenhum arquivo XML encontrado');
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
    else
       begin
         wret := TJSONObject.Create;
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum arquivo XML encontrado');
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;
  except
    On E: Exception do
    begin
      wret.AddPair('status','500');
      wret.AddPair('description','Erro ao transferir arquivos XML.'+slinebreak+E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.DFeRetornaArquivoIni: TJSONObject;
var wret: TJSONObject;
    wstatus: boolean;
    wretorno: string;
begin
  try
    wret      := TJSONObject.Create;
    if not FileExists(GetCurrentDir+'\Autorizador.ini') then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Arquivo Autorizador.ini não localizado');
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
    else
       begin
         FIni := TIniFile.Create(GetCurrentDir+'\Autorizador.ini');
         wret.AddPair('status','200');
         wret.AddPair('numeroseriecertificado',FIni.ReadString('Certificado','NumeroSerie',''));
         wret.AddPair('cnpjinteressado',FIni.ReadString('Geral','CNPJEmitente',''));
         wret.AddPair('iniservicos',FIni.ReadString('Arquivos','IniServicos',''));
         wret.AddPair('pathschemas',FIni.ReadString('Arquivos','PathSchemas',''));
         wret.AddPair('pathnfe',FIni.ReadString('Arquivos','PathNFe',''));
         wret.AddPair('pathsalvar',FIni.ReadString('Arquivos','PathSalvar',''));
         wret.AddPair('pathevento',FIni.ReadString('Arquivos','PathEvento',''));
         wret.AddPair('pathdownload',FIni.ReadString('Arquivos','PathDownload',''));
         wret.AddPair('pathinu',FIni.ReadString('Arquivos','PathInu',''));
       end;
  except
    On E: Exception do
    begin
      wret.AddPair('status','500');
      wret.AddPair('description','Erro ao retornor arquivo Ini.'+slinebreak+E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.CancelaNFe(XIdNota: integer): TJSONObject;
var wret: TJSONObject;
    NFeRetCancNFe: TRetConsSitNFe;
    wstatus: integer;
    wmotivo,wmsg,wchave: string;
begin
  try
    wret      := TJSONObject.Create;

// Estabelece Conexão com Banco de Dados
    Fconexao  := TProviderDataModuleConexao.Create(nil);
    if not Fconexao.EstabeleceConexaoDB then
       begin
         wdescerro := 'Problema na conexão com banco de dados';
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

    wchave    := RetornaChaveNFe(XIdNota);

// Configura NFe
    if not ConfiguraNFe then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;
  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Verifca Status do WebService
    if not VerificaStatusServicoNFe then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Inicia Serviço WebService
    if not IniciaServico then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Consulta Chave
    ACBrNFeAPI.WebServices.Consulta.NFeChave := wchave;
    if not ACBrNFeAPI.WebServices.Consulta.Executar then
       begin
         wstatus := ACBrNFeAPI.WebServices.Consulta.cStat;
         wmotivo := ACBrNFeAPI.WebServices.Consulta.XMotivo;
         wret.AddPair('status','500');
         wret.AddPair('description','Não foi possível consultar nfe '+slinebreak+'Status: '+inttostr(wstatus)+slinebreak+'Motivo: '+wmotivo);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
    else
       begin
//        ShowMessage('Status1: '+inttostr(wstatus));
        if (wstatus <> 101) or (wstatus <> 135) then
           begin
             wmsg    := '';
             wmotivo := 'Teste de cancelamento de nfe';
             //Executa Cancelamento por Evento
             if not CancelarEvento(wmsg,wchave,wmotivo,XIdNota,false)  then
                begin
                 // Consulta Nota
                  ACBrNFeAPI.WebServices.Consulta.NFeChave := wchave;
                  ACBrNFeAPI.WebServices.Consulta.Executar;
                  wstatus := ACBrNFeAPI.WebServices.Consulta.cStat;
                end
             else
                wstatus := ACBrNFeAPI.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat;

//           ShowMessage('Status2: '+inttostr(wstatus));

          // Verifica Retorno
           if (wstatus=101) or (wstatus=135) then
              begin
                AtualizaNumeroSituacaoNota(XIdNota);
                ApagaParcelasNota(XIdNota);

                wret.AddPair('status','200');
                wret.AddPair('description','NFe cancelada com sucesso');
                wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
              end
           end
        else
           begin
             wret.AddPair('status','500');
             wret.AddPair('description','NFe já cancelada');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
       end;
  except
    On E: Exception do
    begin
      Fconexao.EncerraConexaoDB;
      wret.AddPair('status','500');
      wret.AddPair('description','Erro ao cancelar NFe.'+slinebreak+E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Fconexao.EncerraConexaoDB;
  Result := wret;
end;


// Cancelar por Evento
function TProviderServicoAutorizaNFe.CancelarEvento(var Retorno: string; XChave,XJustificativa: string; XIdNota: integer; XMensagem: boolean): boolean;
var wret: boolean;
    NFeRetCancNFe: TRetConsSitNFe;
    teste: TRetCancNFe;
begin
  try
    // Cancelamento por evento
    ACBrNFeAPI.EventoNFe.Evento.Clear;
    with ACBrNFeAPI.EventoNFe.Evento.Add do
    begin
      InfEvento.chNFe           := ACBrNFeAPI.WebServices.Consulta.NFeChave;
      InfEvento.CNPJ            := FCNPJEmitente;
      InfEvento.dhEvento        := ACBrNFeAPI.WebServices.Consulta.DhRecbto;
      InfEvento.tpEvento        := teCancelamento;
      InfEvento.detEvento.xJust := XJustificativa;
      InfEvento.detEvento.nProt := ACBrNFeAPI.WebServices.Consulta.Protocolo;
    end;
    if ACBrNFeAPI.EnviarEvento(XIdNota) then
       begin
         NFeRetCancNFe := TRetConsSitNFe.Create;
         NFeRetCancNFe.Leitor.Arquivo := UTF8Encode(ACBrNFeAPI.WebServices.EnvEvento.RetWS); //ACBrNFe.WebServices.EnvEvento.RetWS;
         NFeRetCancNFe.LerXml;
       end;
    wret := true;
  except
    On E: Exception do
    begin
      wret := false;
    end;
  end;
  Result := wret;
end;



function TProviderServicoAutorizaNFe.CriaNFe(XId: integer): TJSONObject;
var wret: TJSONObject;
    wstatus: integer;
    wmotivo: string;
begin
  try
    wret      := TJSONObject.Create;
    wstatus   := 0;
    wmotivo   := '';
    wdescerro := '';
// Estabelece Conexão com Banco de Dados
    Fconexao  := TProviderDataModuleConexao.Create(nil);
    if not Fconexao.EstabeleceConexaoDB then
       begin
         wdescerro := 'Problema na conexão com banco de dados';
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Configura NFe
    if not ConfiguraNFe then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;
  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Verifca Status do WebService
    if not VerificaStatusServicoNFe then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Inicia Serviço WebService
    if not IniciaServico then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Cria a Nota
     if not CriaNota(XId) then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Assina a Nota
    if not AssinaNota then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Valida a Nota
    if not ValidaNota then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end;

// Envia a Nota
    if not EnviaNota(XId) then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
    else
       begin
         wstatus := ACBrNFeApi.NotasFiscais.Items[0].NFe.procNFe.cStat;
         wmotivo := ACBrNFeApi.NotasFiscais.Items[0].NFe.procNFe.xMotivo;
         AnalisaRetorno(XId,wstatus,wmotivo);
       end;

// Verifica se Houve Erro
    if length(trim(wdescerro))=0 then
       begin
         if wstatus=100 then
            begin
              wret.AddPair('status','200');
              wret.AddPair('description','NFe autorizada com sucesso. Status: '+inttostr(wstatus)+slinebreak+wmotivo);
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end
         else
            begin
              wret.AddPair('status','200');
              wret.AddPair('description','NFe enviada com sucesso. Status: '+inttostr(wstatus)+slinebreak+wmotivo);
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
       end
    else
       begin
         if wret.Count=0 then
            begin
              wret.AddPair('status','500');
              wret.AddPair('description',wdescerro);
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
       end;
    Fconexao.EncerraConexaoDB;
  except
    On E: Exception do
    begin
      Fconexao.EncerraConexaoDB;
      wret.AddPair('status','500');
      wret.AddPair('description','Problema ao criar NFe'+slinebreak+E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

procedure TProviderServicoAutorizaNFe.DataModuleCreate(Sender: TObject);
begin
  wdescerro := '';
end;

function TProviderServicoAutorizaNFe.VerificaCertificadoDigital: boolean;
var wret: boolean;
begin
  try
    wret := ACBrNFeAPI.Configuracoes.Certificados.NumeroSerie = ACBrNFeAPI.SSL.NumeroSerie;
  except
    On E: Exception do
    begin
      wdescerro := 'Problema ao verificar Certificado Digital'+slinebreak+E.Message;
      wret      := false;
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.RetornaSSLLib(XSSLLib: string): TSSLLib;
var wret: TSSLLib;
begin
  if lowercase(XSSLLib)='libcapicom' then
     wret := TSSLLib.libCapicom
  else if lowercase(XSSLLib)='libcapicomdelphisoap' then
     wret := TSSLLib.libCapicomDelphiSoap
    else if lowercase(XSSLLib)='libcustom' then
       wret := TSSLLib.libCustom
  else if lowercase(XSSLLib)='libnone' then
     wret := TSSLLib.libNone
  else if lowercase(XSSLLib)='libopenssl' then
     wret := TSSLLib.libOpenSSL
    else if lowercase(XSSLLib)='libwincrypt' then
       wret := TSSLLib.libWinCrypt
  else
     wret := TSSLLib.libOpenSSL;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.VerificaStatusServicoNFe: boolean;
var wret: boolean;
begin
  try
    ACBrNFeAPI.WebServices.StatusServico.Executar;
    wret := true;
  except
    On E: Exception do
    begin
      wret      := false;
      wdescerro := 'Erro ao consultar status de serviço NFe'+slinebreak+E.Message;
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.IniciaServico: boolean;
var wret: boolean;
begin
  try
    wret := ACbrNFeApi.WebServices.StatusServico.Executar;
//    Retorno := 'Serviço WebService iniciado com sucesso';
    wret    := true;
  except
    On E: Exception do
    begin
      wdescerro := 'Erro ao iniciar WebService'+slinebreak+E.Message;
      wret      := false;
    end;
  end;
  Result := wret;
end;


function TProviderServicoAutorizaNFe.CriaNota(XId: Integer): boolean;
var wret: boolean;
    wqueryNota,wqueryItem,wqueryCondicao,wqueryParcela,wqueryValorParcela,wqueryTransporte: TFDQuery;
begin
  try
    FSomaVtotTribUnit := 0;
    FSomaICMSUFDest   := 0;
    FSomaICMSUFRemet  := 0;
    FSomaDesconto     := 0;
    FSomaFCP          := 0;
    FSomaFCPST        := 0;
    FSomaFCPSTRet     := 0;
    FSomaFCPUFDest    := 0;
    wqueryNota     := TFDQuery.Create(nil);
    wqueryItem     := TFDQuery.Create(nil);
    wqueryCondicao := TFDQuery.Create(nil);
    wqueryParcela  := TFDQuery.Create(nil);
    wqueryValorParcela  := TFDQuery.Create(nil);
    wqueryTransporte    := TFDQuery.Create(nil);

// Carrega dados da nota fiscal
    with wqueryNota do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('SELECT * FROM ts_nfe_retornaNotaFiscal(:XNota) as (');
      SQL.Add('"_codigoInternoNota" Integer,"_cUF" Integer,"_cMunFG" integer,"_natOp" Character Varying,"_indPag" Integer,"_tpNF" Integer,"_mod" Integer,"_serie" Integer,');
      SQL.Add('"_nNF" Character Varying,"_nProvisorio" integer,"_nECF" integer,"_nCOO" varchar,"_dEmi" Date,"_dSaiEnt" Date,"_hSaiEnt" varchar,"_tpImp" Integer,"_tpEmis" Integer,');
      SQL.Add('"_tpAmb" Integer,"_finNFe" Integer,"_procEmi" Integer,"_verProc" Integer,"_modFrete" Character Varying(1),"_infCpl" text,"_tipoOperacao" Character Varying(1),');
      SQL.Add('"_VendaPresencial" boolean,"_Transportadora_CodigoInterno" Integer,"_totalICMS_vBC" Numeric(15,2),"_totalICMS_vICMS" Numeric(15,2),"_totalICMS_vBCST" Numeric(15,2),');
      SQL.Add('"_totalICMS_vST" Numeric(15,2),"_totalICMS_vProd" Numeric(15,2),"_totalICMS_vFrete" Numeric(15,2),"_totalICMS_vDesc" Numeric,"_totalICMS_vIPI" Numeric(15,2),');
      SQL.Add('"_totalICMS_vNF" Numeric(15,2),"_totalICMS_vPIS" numeric(15,2),"_totalICMS_vCOFINS" numeric(15,2),"_totalICMS_vOutro" numeric(15,2),"_totalICMS_vTroco" numeric(15,2),');
      SQL.Add('"_CNPJEmit" Character Varying,"_CPFEmit" Character Varying,"_xNomeEmit" Character Varying(50),"_xFantEmit" Character Varying(50),"_xLgrEmit" Character Varying(50),');
      SQL.Add('"_nroEmit" Integer,"_xCplEmit" Character Varying(50),"_xBairroEmit" Character Varying(50),"_cMunEmit" Integer,"_xMunEmit" Character Varying(40),"_UFEmit" Character Varying(2),');
      SQL.Add('"_CEPEmit" Character Varying,"_cPaisEmit" Integer,"_xPaisEmit" Character Varying,"_foneEmit" Character Varying(14),"_IEEmit" Character Varying,"_IEEmitST" Character Varying,');
      SQL.Add('"_CNPJDest" Character Varying,"_CPFDest" Character Varying,"_ISUFDest" Character Varying(9),"_xInternoDest" Integer,"_xNomeDest" Character Varying,"_xLgrDest" Character Varying,');
      SQL.Add('"_nroDest" Integer,"_xCplDest" Character Varying(50),"_xBairroDest" Character Varying,"_cMunDest" Integer,"_xMunDest" Character Varying,"_UFDest" Character Varying(2),');
      SQL.Add('"_CEPDest" Character Varying,"_cPaisDest" Integer,"_xPaisDest" Character Varying,"_foneDest" Character Varying,"_identIEDest" Character Varying(1),"_IEDest"  Character Varying,');
      SQL.Add('"_emailDest" varchar,"_ehRevendedorDest" boolean,"_CNPJEntrega" Character Varying,"_CPFEntrega" Character Varying,"_CNPJCPFEntrega" Character Varying,"_xLgrEntrega" Character Varying,');
      SQL.Add('"_nroEntrega" integer,"_xCplEntrega" Character Varying(50),"_xBairroEntrega" Character Varying(50),"_cMunEntrega" integer,"_xMunEntrega" Character Varying,"_UFEntrega" Character Varying(2),');
      SQL.Add('"_TipoEntrega" integer,"_EmpresaSimples" integer,"_CSOSN" integer,"_CSOSN_ST" integer,"_ObsNota" Character Varying,"_NotaOrigem" Character Varying(10),"_refNFe" varchar,');
      SQL.Add('"_InfAdFisco" varchar(80),"_vTotTrib" varchar,"_CpfCnpjAdquirente" varchar(14),"_RefnECF" integer,"_RefnCOO" varchar,"_totalCredDevolucao" numeric(15,2),');
      SQL.Add('"_totalCredFidelidade" numeric(15,2),"_cpfVendedor" varchar(20),"_vendaAgenciada" varchar(20)) ');
      ParamByName('XNota').AsInteger := XId;
      Open;
      EnableControls;
    end;

// Carrega itens da nota fiscal
    with wqueryItem do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('SELECT * FROM ts_nfe_retornaprodutosnota(:XNota) AS (');
      SQL.Add('"_codigoInternoItem" integer,"_nItem" integer,"_nPedCompra" integer,"_nItemPedCompra" integer,"_cProd" varchar(20),"_cEAN" varchar,"_qtdEmb" numeric,"_Caixas" varchar,');
      SQL.Add('"_xProd" varchar(200),"_RefProd" varchar,"_ObsProd" varchar,"_LocProd" varchar,"_NCM" varchar(8),"_CEST" varchar(7),"_CFOP" varchar(5),"_uCom" varchar(5),"_qCom" numeric(15,4),');
      SQL.Add('"_vUnCom" numeric(18,8),"_vBCIPI" numeric(15,2),"_vProd" numeric(15, 2),"_cEANTrib" varchar,"_uTrib" varchar,"_qTrib" numeric(15,4),"_vUnTrib" numeric(18,8),"_vFrete" numeric(15, 2),');
      SQL.Add('"_vDesc" numeric(15, 2),"_vOutro" numeric(15,2),"_vAcresc" numeric(15,2),"_CST" varchar,"_IPI_CST" varchar,"_IPI_pIPI" numeric(15, 2),"_IPI_vIPI" numeric(15, 2),"_PIS_CST" varchar,');
      SQL.Add('"_PIS_vBC" numeric(15,2),"_PIS_pPIS" numeric(5,2),"_PIS_vPIS" numeric(15,2),"_PIS_qBCProd" numeric(16,4),"_PIS_vAliqProd" numeric(15,4),"_COFINS_CST" varchar,"_COFINS_vBC" numeric(15,2),');
      SQL.Add('"_COFINS_pCOFINS" numeric(5,2),"_COFINS_vCOFINS" numeric(15,2),"_COFINS_qBCProd" numeric(16,4),"_COFINS_vAliqProd" numeric(15,4),"_Origem" varchar,"_IncideST" boolean,"_InfAdProd" varchar(500),');
      SQL.Add('"_vTotTribItem" numeric,"_nFCI" varchar(36),"_pICMSUFDest" numeric(15,4),"_pICMSInter" numeric(15,4),"_pICMSInterPart" numeric(15,4),"_vICMSUFDest" numeric(15,4),"_vICMSUFRemet" numeric(15,4),');
      SQL.Add('"_vIOF" numeric(15,2),"_vII" numeric(15,2),"_vBaseII" numeric(15,2),"_vDespAdu" numeric(15,2),"_AliqST" numeric(15,2),"_PercReduzST" numeric(15,2),"_cBenef" varchar(8)) ');
      ParamByName('XNota').AsInteger := XId;
      Open;
      EnableControls;
    end;

// Carrega condição de Pagamento
    with wqueryCondicao do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('select coalesce("CondicaoPagamento"."TaxaRetencaoCondicao",0) as retencao ');
      SQL.Add('from "CondicaoPagamento" inner join "NotaFiscal" on "CondicaoPagamento"."CodigoInternoCondicao" = "NotaFiscal"."CodigoCondicaoNota" ');
      SQL.Add('where "NotaFiscal"."CodigoInternoNota"=:XNota ');
      ParamByName('XNota').AsInteger := XId;
      Open;
      EnableControls;
    end;

 // Carrega Parcela
    with wqueryParcela do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('SELECT * FROM "Parcela" WHERE "Parcela"."CodigoDocFiscalParcela"=:XCodNota Order by "Parcela"."NumeroParcela" ');
      ParamByName('XCodNota').AsInteger := XId;
      Open;
      EnableControls;
    end;

 // Carrega Valor Parcela
    with wqueryValorParcela do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('SELECT Sum("Parcela"."ValorOriginalParcela") AS "ValorOriginal",');
      SQL.Add('Sum("Parcela"."ValorFinalParcela") AS "ValorFinal" ');
      SQL.Add('FROM "Parcela" WHERE "Parcela"."CodigoDocFiscalParcela"=:XCodNota and ("DesdobramentoParcela" is null or "DesdobramentoParcela"=''P'') ');
      ParamByName('XCodNota').AsInteger := XId;
      Open;
      EnableControls;
    end;

 // Carrega Transporte
    with wqueryTransporte do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('SELECT * FROM ts_nfe_retornatransportenota(:XNota) AS (');
      SQL.Add('"_CNPJ" Character Varying(14),"_CPF" Character Varying(14),"_xNome" Character Varying(100),"_IE" Character Varying(18),"_xEnder" Character Varying(50),');
      SQL.Add('"_xMun" Character Varying(40),"_UF" Character Varying(2),"_ICMS_vServ" Numeric(15, 4),"_ICMS_pICMSRet" Numeric(15, 4),"_veiculo_placa" Character Varying(8),');
      SQL.Add('"_veiculo_UF" Character Varying(2),"_volume_qVol" integer,"_volume_esp" varchar(60),"_volume_marca" varchar(15),"_volume_pesoL" numeric(15, 3),"_volume_pesoB" numeric(15, 3)) ');
      ParamByName('XNota').AsInteger := XId;
      Open;
      EnableControls;
    end;

// Carrega o Componente NFe do ACBr
    CarregaComponenteNFeACBr(Xid,wqueryNota,wqueryItem,wqueryCondicao,wqueryParcela,wqueryValorParcela,wqueryTransporte);

    wret := true;
  except
    On E: Exception do
    begin
      wdescerro := 'Erro ao criar nota'+slinebreak+E.Message;
      wret      := false;
    end;
  end;
  Result := wret;
end;


function TProviderServicoAutorizaNFe.RetornaSSLCryptLib(XSSLCryptLib: string): TSSLCryptLib;
var wret: TSSLCryptLib;
begin
  try
    if lowercase(XSSLCryptLib)='crycapicom' then
       wret := TSSLCryptLib.cryCapicom
    else if lowercase(XSSLCryptLib)='crynone' then
       wret := TSSLCryptLib.cryNone
    else if lowercase(XSSLCryptLib)='cryopenssl' then
       wret := TSSLCryptLib.cryOpenSSL
    else if lowercase(XSSLCryptLib)='crywincrypt' then
       wret := TSSLCryptLib.cryWinCrypt
    else
       wret := TSSLCryptLib.cryOpenSSL;
  except
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.RetornaSSLHttpLib(XSSLHttpLib: string): TSSLHttpLib;
var wret: TSSLHttpLib;
begin
  try
    if lowercase(XSSLHttpLib)='httpindy' then
       wret := TSSLHttpLib.httpIndy
    else if lowercase(XSSLHttpLib)='httpnone' then
       wret := TSSLHttpLib.httpNone
    else if lowercase(XSSLHttpLib)='httpopenssl' then
       wret := TSSLHttpLib.httpOpenSSL
    else if lowercase(XSSLHttpLib)='httpwinhttp' then
       wret := TSSLHttpLib.httpWinHttp
    else if lowercase(XSSLHttpLib)='httpwininet' then
       wret := TSSLHttpLib.httpWinINet
    else
       wret := TSSLHttpLib.httpOpenSSL;
  except
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.RetornaSSLXmlSignLib(XSSLXmlSignLib: string): TSSLXmlSignLib;
var wret: TSSLXmlSignLib;
begin
  try
    if lowercase(XSSLXmlSignLib)='xslibxml2' then
       wret := TSSLXmlSignLib.xsLibXml2
    else if lowercase(XSSLXmlSignLib)='xsmsxml' then
       wret := TSSLXmlSignLib.xsMsXml
    else if lowercase(XSSLXmlSignLib)='xsmsxmlcapicom' then
       wret := TSSLXmlSignLib.xsMsXmlCapicom
    else if lowercase(XSSLXmlSignLib)='xsnone' then
       wret := TSSLXmlSignLib.xsNone
    else if lowercase(XSSLXmlSignLib)='xsxmlsec' then
       wret := TSSLXmlSignLib.xsXmlSec
    else
       wret := TSSLXmlSignLib.xsMsXmlCapicom;
  except
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.RetornaSSLType(XSSLType: string): TSSLType;
var wret: TSSLType;
begin
  try
    if lowercase(XSSLType)='lt_all' then
       wret := TSSLType.LT_all
    else if lowercase(XSSLType)='lt_sshv2' then
       wret := TSSLType.LT_SSHv2
    else if lowercase(XSSLType)='lt_sslv2' then
       wret := TSSLType.LT_SSLv2
    else if lowercase(XSSLType)='lt_sslv3' then
       wret := TSSLType.LT_SSLv3
    else if lowercase(XSSLType)='lt_tlsv1' then
       wret := TSSLType.LT_TLSv1
    else if lowercase(XSSLType)='lt_tlsv1_1' then
       wret := TSSLType.LT_TLSv1_1
    else if lowercase(XSSLType)='lt_tlsv1_2' then
       wret := TSSLType.LT_TLSv1_2
    else
       wret := TSSLType.LT_all;
  except
  end;
  Result := wret;
end;

procedure TProviderServicoAutorizaNFe.CarregaComponenteNFeACBr(XId: integer; XqueryNota,XqueryItem,XqueryCondicao,XqueryParcela,XQueryValorParcela,XQueryTransporte: TFDQuery);
var winterno: string;
    OK: boolean;
    wvendedor: TVendedor;
    wagenciada: TAgenciada;

begin
  try
    winterno  := inttostr(XId);
    ACBrNFeApi.NotasFiscais.Clear;
    with ACBrNFeApi.NotasFiscais.Add.NFe do
    begin
      // dados da Nota
      Ide.cUF  := ACBrNFeApi.Configuracoes.WebServices.UFCodigo;
      Ide.cNF  := strtoint(copy(winterno,1+(length(winterno)-8),8));
      if XQueryNota.FieldByName('_finNFe').Value = 3 then
         Ide.natOp   := '999 - Estorno de NF-e não cancelada no prazo legal'
      else
         Ide.natOp   := XQueryNota.FieldByName('_natOp').value;
      if FVersaoDF = ve310 then
         Ide.indPag  := StrToIndpag(OK, IntToStr(XQueryNota.FieldByName('_indPag').value));
      Ide.modelo     := XQueryNota.FieldByName('_mod').AsInteger;
      Ide.serie      := XQueryNota.FieldByName('_serie').asInteger;
//      Ide.nNF        := XQueryNota.FieldByName('_nProvisorio').AsInteger;

      FSequenceUltDoc := 'UltimoDocumentoTSFature_'+ IntToStr(77222)+'_0_seq';
      Ide.nNF        := RetornaSequence('"'+FSequenceUltDoc+'"','A');

      Ide.dEmi       := IfThen(ACBrNFeApi.WebServices.StatusServico.dhRecbto>2000,ACBrNFeApi.WebServices.StatusServico.dhRecbto,now);
      Ide.dSaiEnt    := XQueryNota.FieldByName('_dSaiEnt').AsDateTime;
      Ide.hSaiEnt    := strtotime(XQueryNota.FieldByName('_hSaiEnt').AsString);
      Ide.tpNF       := StrToTpNF(OK, IntToStr(XQueryNota.FieldByName('_tpNF').asInteger));
      Ide.cMunFG     := XQueryNota.FieldByName('_cMunFG').AsInteger;
//      Ide.tpEmis     := StrToTpEmis(Ok,IfThen(XContingencia,'9','1'));
      Ide.tpEmis     := StrToTpEmis(Ok,'1');
      Ide.tpAmb      := StrToTpAmb(Ok, IntToStr(ACBrNFeApi.Configuracoes.WebServices.AmbienteCodigo));
      Ide.finNFe     := StrToFinNFe(OK, IntToStr(XQueryNota.FieldByName('_finNFe').asInteger)); //Finalidade 1-Normal, 2-Complementar, 3-Ajuste, 4-Devolucao
      Ide.procEmi    := StrToprocEmi(OK,'0');
      Ide.verProc    := '1.38.0.0'; //Ide.verProc    := '1.0.0.0';

      if XQueryNota.FieldByName('_mod').AsInteger = 55 then
         begin
           Ide.tpImp   := tiRetrato;
//           if XConsumidorFinal then
              Ide.indFinal := cfConsumidorFinal; //; //cfNao; //
//           else
//              Ide.indFinal := cfNao;
           if XQueryNota.FieldByName('_VendaPresencial').AsBoolean = true then
              begin
                Ide.indPres     := pcPresencial;
                Ide.indIntermed := iiSemOperacao;
              end
           else
              begin
                Ide.indPres     := pcnao;
                ide.indIntermed := iiSemOperacao;
              end;
         end ;

// Dados do Emitente
      Emit.CNPJCPF           := Trim(XQueryNota.FieldByName('_CNPJEmit').AsString);
      Emit.xNome             := Trim(XQueryNota.FieldByName('_xNomeEmit').AsString);
      if not(FNaoEnviaNomeFantasia) then
         Emit.xFant          := Trim(XQueryNota.FieldByName('_xFantEmit').asString);
      Emit.EnderEmit.xLgr    := XQueryNota.FieldByName('_xLgrEmit').AsString;
      if not XQueryNota.FieldByName('_nroEmit').isNull then
         Emit.EnderEmit.nro     := IntToStr(XQueryNota.FieldByName('_nroEmit').AsInteger);
      if XQueryNota.FieldByName('_xCplEmit').AsString <> '' then
         Emit.EnderEmit.xCpl    := Trim(XQueryNota.FieldByName('_xCplEmit').AsString);
      Emit.EnderEmit.xBairro := IfThen(not XQueryNota.FieldByName('_xBairroEmit').isNull, XQueryNota.FieldByName('_xBairroEmit').asString, 'Nao Especificado');
      Emit.EnderEmit.cMun    := XQueryNota.FieldByName('_cMunEmit').AsInteger;
      Emit.EnderEmit.xMun    := XQueryNota.FieldByName('_xMunEmit').AsString;
      Emit.EnderEmit.UF      := XQueryNota.FieldByName('_UFEmit').asString;
      Emit.EnderEmit.CEP     := StrToInt(IfThen(not XQueryNota.FieldByName('_CEPEmit').isNull,XQueryNota.FieldByName('_CEPEmit').asString,'00000000'));
      Emit.EnderEmit.cPais   := XQueryNota.FieldByName('_cPaisEmit').AsInteger;
      Emit.EnderEmit.xPais   := Trim(XQueryNota.FieldByName('_xPaisEmit').asString);
      Emit.EnderEmit.fone    := Trim(Copy(XQueryNota.FieldByName('_foneEmit').asString, ((Length(XQueryNota.FieldByName('_foneEmit').asString) - 14)+1), 14));
      Emit.IE                := Trim(XQueryNota.FieldByName('_IEEmit').asString);
      {TODO: Inscricao Estadual Substituto Tributario}
      if (XQueryNota.FieldByName('_mod').AsInteger = 55) and (XQueryNota.FieldByName('_VendaPresencial').AsBoolean = false ) and
         (Length(Trim(XQueryNota.FieldByName('_IEEmitST').asString))>0) and (XQueryNota.FieldByName('_UFDest').asString = 'SP')  then
         Emit.IEST              := Trim(XQueryNota.FieldByName('_IEEmitST').asString);
      //Emit.IEST
      Emit.CRT               := StrToCRT(OK,IfThen(XQueryNota.FieldByName('_EmpresaSimples').asInteger=1,XQueryNota.FieldByName('_EmpresaSimples').AsString,'3'));


// Dados do Destinatario
      if XQueryNota.FieldByName('_UFDest').asString <> 'EX' then // Se a origem do destinatário for Exterior, não informa esta TAG
         begin
           if XQueryNota.FieldByName('_mod').AsInteger = 55 then // NFe
              begin
               if XQueryNota.FieldByName('_CNPJDest').asString <> '' then
                  Dest.CNPJCPF        := Trim(XQueryNota.FieldByName('_CNPJDest').asString)
               else if XQueryNota.FieldByName('_CPFDest').asString <> '' then
                  Dest.CNPJCPF        := Trim(XQueryNota.FieldByName('_CPFDest').asString)
               else if length(trim(XQueryNota.FieldByName('_CpfCnpjAdquirente').AsString))>10 then
                   Dest.CNPJCPF       := Trim(XQueryNota.FieldByName('_CpfCnpjAdquirente').asString);
              end
           else if XQueryNota.FieldByName('_mod').AsInteger = 65 then
              begin
                if length(trim(XQueryNota.FieldByName('_CpfCnpjAdquirente').AsString))>10 then
                   Dest.CNPJCPF       := Trim(XQueryNota.FieldByName('_CpfCnpjAdquirente').asString);
              end;
         end;
      if ACBrNFeAPi.Configuracoes.WebServices.Ambiente = taHomologacao then
         Dest.xNome          := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
      else
         Dest.xNome          := Trim(XQueryNota.FieldByName('_xNomeDest').asString);
      if XQueryNota.FieldByName('_mod').AsInteger = 55 then // NFe
         begin
           Dest.EnderDest.xLgr    := XQueryNota.FieldByName('_xLgrDest').asString;
           if not XQueryNota.FieldByName('_nroDest').isNull then
              Dest.EnderDest.nro  := IntToStr(XQueryNota.FieldByName('_nroDest').asInteger);
           if XQueryNota.FieldByName('_xCplDest').asString <> '' then
              Dest.EnderDest.xCpl := Trim(XQueryNota.FieldByName('_xCplDest').asString);
           Dest.EnderDest.xBairro := IfThen(not XQueryNota.FieldByName('_xBairroDest').isNull, XQueryNota.FieldByName('_xBairroDest').asString, 'Nao Especificado');
           if XQueryNota.FieldByName('_UFDest').asString <> 'EX' then // Se a origem do destinatário for Exterior
              begin
                Dest.EnderDest.cMun    := XQueryNota.FieldByName('_cMunDest').asInteger;
                Dest.EnderDest.xMun    := XQueryNota.FieldByName('_xMunDest').asString;
              end
           else
              begin
                Dest.EnderDest.cMun    := 9999999;
                Dest.EnderDest.xMun    := 'EXTERIOR';
              end;
           Dest.EnderDest.UF      := XQueryNota.FieldByName('_UFDest').asString;
           if XQueryNota.FieldByName('_VendaPresencial').AsBoolean = true then
              ide.idDest := doInterna
           else
              begin
                if Dest.EnderDest.UF = 'EX' then
                   ide.idDest := doExterior
                else if Dest.EnderDest.UF = Emit.EnderEmit.UF then
                   ide.idDest := doInterna
                else
                   ide.idDest := doInterestadual;
              end;
           Dest.EnderDest.CEP     := StrToInt(IfThen(not XQueryNota.FieldByName('_CEPDest').isNull,XQueryNota.FieldByName('_CEPDest').asString, '00000000'));
           Dest.EnderDest.cPais   := XQueryNota.FieldByName('_cPaisDest').asInteger;
           Dest.EnderDest.xPais   := Trim(XQueryNota.FieldByName('_xPaisDest').asString);
           Dest.EnderDest.Fone    := Trim(Copy(XQueryNota.FieldByName('_foneDest').asString, ((Length(XQueryNota.FieldByName('_foneDest').asString) - 14)+1), 14));
          // Se for estrangeiro ver se existe algum documento para vincular ao cliente
           if Dest.EnderDest.UF = 'EX' then
              Dest.idEstrangeiro := Trim(XQueryNota.FieldByName('_CpfCnpjAdquirente').asString); //'12345678900';
           Dest.ISUF              := trim(XQueryNota.FieldByName('_ISUFDest').asString);
           Dest.Email             := trim(XQueryNota.FieldByName('_emailDest').asString);
         end
      else if (XQueryNota.FieldByName('_mod').AsInteger = 65) and
              (XQueryNota.FieldByName('_xInternoDest').asInteger <> FClienteConsumidor) then
         begin
           Dest.EnderDest.xLgr    := XQueryNota.FieldByName('_xLgrDest').asString;
           if not XQueryNota.FieldByName('_nroDest').isNull then
              Dest.EnderDest.nro  := IntToStr(XQueryNota.FieldByName('_nroDest').asInteger);
           if XQueryNota.FieldByName('_xCplDest').asString <> '' then
              Dest.EnderDest.xCpl := Trim(XQueryNota.FieldByName('_xCplDest').asString);
           Dest.EnderDest.xBairro := IfThen(not XQueryNota.FieldByName('_xBairroDest').isNull, XQueryNota.FieldByName('_xBairroDest').AsString, 'Nao Especificado');
           if XQueryNota.FieldByName('_UFDest').asString <> 'EX' then // Se a origem do destinatário for Exterior
              begin
                Dest.EnderDest.cMun    := XQueryNota.FieldByName('_cMunDest').asInteger;
                Dest.EnderDest.xMun    := XQueryNota.FieldByName('_xMunDest').asString;
              end
           else
              begin
                Dest.EnderDest.cMun    := 9999999;
                Dest.EnderDest.xMun    := 'EXTERIOR';
              end;
           Dest.EnderDest.UF      := XQueryNota.FieldByName('_UFDest').asString;
           ide.idDest             := doInterna;
           Dest.EnderDest.CEP     := StrToInt(IfThen(not XQueryNota.FieldByName('_CEPDest').isNull,XQueryNota.FieldByName('_CEPDest').asString, '00000000'));
           Dest.EnderDest.cPais   := XQueryNota.FieldByName('_cPaisDest').asInteger;
           Dest.EnderDest.xPais   := Trim(XQueryNota.FieldByName('_xPaisDest').asString);
           Dest.EnderDest.Fone    := Trim(Copy(XQueryNota.FieldByName('_foneDest').asString, ((Length(XQueryNota.FieldByName('_foneDest').asString) - 14)+1), 14));
           if Dest.EnderDest.UF = 'EX' then
              Dest.idEstrangeiro := Trim(XQueryNota.FieldByName('_CpfCnpjAdquirente').asString); //'12345678900';
           Dest.ISUF              := trim(XQueryNota.FieldByName('_ISUFDest').asString);
           Dest.Email             := trim(XQueryNota.FieldByName('_emailDest').asString);
         end;
      if (Length(Trim(XQueryNota.FieldByName('_IEDest').asString)) > 0) and (XQueryNota.FieldByName('_mod').AsInteger = 55) then
         begin
           if (XQueryNota.FieldByName('_VendaPresencial').AsBoolean = true) and
              (XQueryNota.FieldByName('_UFDest').asString <> XQueryNota.FieldByName('_UFEmit').asString) then
              begin
                Dest.indIEDest         := inNaoContribuinte;
                Dest.IE                := Trim(XQueryNota.FieldByName('_IEDest').asString);
              end
           else if XQueryNota.FieldByName('_identIEDest').asString = '1' then
              begin
                Dest.indIEDest         := inContribuinte;
                Dest.IE                := Trim(XQueryNota.FieldByName('_IEDest').AsString);
              end
           else if XQueryNota.FieldByName('_identIEDest').asString = '2' then
              begin
                Dest.indIEDest         := inIsento;
                Dest.IE                := 'ISENTO';
              end
           else if XQueryNota.FieldByName('_identIEDest').asString = '9' then
              begin
                Dest.indIEDest         := inNaoContribuinte;
                Dest.IE                := Trim(XQueryNota.FieldByName('_IEDest').asString);
              end;
         end
      else
         begin
           Dest.indIEDest         := inNaoContribuinte;
//           Dest.IE                := 'ISENTO';
         end;

// Dados da Entrega
      if XQueryNota.FieldByName('_TipoEntrega').asInteger = 1 then
         begin
           Entrega.CNPJCPF := trim(XQueryNota.FieldByName('_CNPJCPFEntrega').asString); //Alterado em 25/10/2012 por Walmir Junior
           Entrega.xLgr    := XQueryNota.FieldByName('_xLgrEntrega').asString;
           if not XQueryNota.FieldByName('_nroEntrega').IsNull then
              Entrega.nro  := inttostr(XQueryNota.FieldByName('_nroEntrega').asInteger);
           if XQueryNota.FieldByName('_xCplEntrega').asString <> '' then
              Entrega.xCpl := trim(XQueryNota.FieldByName('_xCplEntrega').asString);
           Entrega.xBairro := IfThen(not XQueryNota.FieldByName('_xBairroEntrega').isNull, XQueryNota.FieldByName('_xBairroEntrega').asString, 'Nao Especificado');
           Entrega.cMun    := XQueryNota.FieldByName('_cMunEntrega').asInteger;
           Entrega.xMun    := XQueryNota.FieldByName('_xMunEntrega').asString;
           Entrega.UF      := XQueryNota.FieldByName('_UFEntrega').asString;
         end;

// Venda de Veículo
{      wqueryExisteVeiculo := TFDQuery(FDataSetExisteVeiculo);
      if (FAutXMLAcess) and (length(trim(FCnpjAutXMLAcess)) >0) then
         begin
           with TFDQuery(FDataSetExisteVeiculo)  do
           begin
              DisableControls;
              Close;
              ParamByName('XCodigoInternoNota').AsInteger := wquery.FieldByName('_codigoInternoNota').AsInteger;
              Open;
              EnableControls;
           end;
           if (FCnpjAutSomenteVeiculo) and (TFDQuery(FDataSetExisteVeiculo).RecordCount > 0) then
              autXML.Add.CNPJCPF := FCnpjAutXMLAcess // '62934252000145';
           else if not(FCnpjAutSomenteVeiculo) then
              autXML.Add.CNPJCPF := FCnpjAutXMLAcess; // '62934252000145';
         end;}

// Ítems da Nota
      GravaItem(XQueryNota,XQueryItem,True);

// Dados do Total da Nota
      Total.ICMSTot.vBC      := XQueryNota.FieldByName('_totalICMS_vBC').AsFloat;
      Total.ICMSTot.vICMS    := XQueryNota.FieldByName('_totalICMS_vICMS').AsFloat;  // + 0.03;  //* 2;        {TODO:vIMCS*2 TESTE - REMOVER}
      Total.ICMSTot.vProd    := XQueryNota.FieldByName('_totalICMS_vProd').AsFloat;
      Total.ICMSTot.vBCST    := XQueryNota.FieldByName('_totalICMS_vBCST').AsFloat;
      Total.ICMSTot.vST      := XQueryNota.FieldByName('_totalICMS_vST').AsFloat;
      if XQueryNota.FieldByName('_mod').AsInteger = 55 then // NFe
         Total.ICMSTot.vFrete   := XQueryNota.FieldByName('_totalICMS_vFrete').asFloat;
      Total.ICMSTot.vSeg     := 0.0;
      Total.ICMSTot.vDesc    := XQueryNota.FieldByName('_totalICMS_vDesc').asFloat;
      Total.ICMSTot.vII      := 0.0;
      Total.ICMSTot.vIPI     := XQueryNota.FieldByName('_totalICMS_vIPI').asFloat;
      Total.ICMSTot.vPIS     := XQueryNota.FieldByName('_totalICMS_vPIS').asFloat;
      Total.ICMSTot.vCOFINS  := XQueryNota.FieldByName('_totalICMS_vCOFINS').asFloat;
      Total.ICMSTot.vOutro   := XQueryNota.FieldByName('_totalICMS_vOutro').asFloat;
      Total.ICMSTot.vNF      := XQueryNota.FieldByName('_totalICMS_vNF').asFloat;
      Total.ISSQNtot.vServ   := 0.0;
      Total.ISSQNTot.vBC     := 0.0;
      Total.ISSQNTot.vISS    := 0.0;
      Total.ISSQNTot.vPIS    := 0.0;
      Total.ISSQNTot.vCOFINS := 0.0;
      Total.ICMSTot.vTotTrib := FSomaVtotTribUnit;          //  StrToCurr( StringReplace(
      Total.ICMSTot.vFCP     := FSomaFCP;
      Total.ICMSTot.vFCPST   := FSomaFCPST;
      Total.ICMSTot.vFCPSTRet:= FSomaFCPSTRet;
      Total.ICMSTot.vFCPUFDest:= FSomaFCPUFDest;

      if (XQueryNota.FieldByName('_identIEDest').asString = '9') and
         (XQueryNota.FieldByName('_mod').AsInteger = 55) and // NFe
         (UpperCase(XQueryNota.FieldByName('_UFEmit').asString) <> UpperCase(XQueryNota.FieldByName('_UFDest').asString)) and
         (UpperCase(XQueryNota.FieldByName('_UFDest').asString) <>'EX') and
         (XQueryNota.FieldByName('_VendaPresencial').asBoolean = False) then
//         (wSomaICMSUFDest > 0.00) then
         begin
           Total.ICMSTot.vICMSUFDest  := FSomaICMSUFDest;  //40.0;
           Total.ICMSTot.vICMSUFRemet := FSomaICMSUFRemet; //60.0;
         end;

// Dados de Transporte
      if XQueryNota.FieldByName('_mod').AsInteger=55 then
         begin
           if not XQueryNota.FieldByName('_Transportadora_CodigoInterno').IsNull then
              begin
                Transp.modFrete := StrTomodFrete(OK,XQueryNota.FieldByName('_modFrete').asString);

                if not XQueryTransporte.IsEmpty then
                begin
                  if not XQueryTransporte.FieldByName('_CNPJ').isNull then
                     Transp.Transporta.CNPJCPF  := Trim(XQueryTransporte.FieldByName('_CNPJ').Value)
                  else
                     Transp.Transporta.CNPJCPF  := Trim(XQueryTransporte.FieldByName('_CPF').Value);
                  Transp.Transporta.xNome    := Trim(XQueryTransporte.FieldByName('_xNome').value);
                  Transp.Transporta.IE       := Trim(XQueryTransporte.FieldByName('_IE').value);
                  Transp.Transporta.xEnder   := Trim(XQueryTransporte.FieldByName('_xEnder').value);
                  Transp.Transporta.xMun     := Trim(XQueryTransporte.FieldByName('_xMun').value);
                  Transp.Transporta.UF       := XQueryTransporte.FieldByName('_UF').value;

                  Transp.veicTransp.placa    := Trim(StringReplace(XQueryTransporte.FieldByName('_veiculo_placa').value, ' ', '', [rfReplaceAll, rfIgnoreCase]));
                  Transp.veicTransp.UF       := XQueryTransporte.FieldByName('_veiculo_UF').value;

                  with Transp.Vol.Add do
                  begin
                    qVol  := XQueryTransporte.FieldByName('_volume_qVol').Value;
                    esp   := Trim(XQueryTransporte.FieldByName('_volume_esp').Value);
                    marca := Trim(XQueryTransporte.FieldByName('_volume_marca').Value);
                    nVol  := '';
                    pesoL := XQueryTransporte.FieldByName('_volume_pesoL').Value;
                    pesoB := XQueryTransporte.FieldByName('_volume_pesoB').Value;
                  end;
                end;

              end
           else
              begin
                Transp.modFrete := StrTomodFrete(OK,XQueryNota.FieldByName('_modFrete').asString); //mfContaDestinatario;
              end;
         end
      else
         begin
           Transp.modFrete :=  mfSemFrete; // ou StrTomodFrete(OK, '9');
         end;

// Define os dados de cobrança
      if XQueryNota.FieldByName('_mod').AsInteger=55 then
         begin
           if XQueryParcela.RecordCount <> 0 then
              begin
                if  XQueryParcela.FieldByName('ValorFinalParcela').Value > 0 then
                    begin
                      Cobr.Fat.nFat   := formatfloat('000',xQueryNota.FieldByName('_nProvisorio').AsInteger);   //IntToStr(NumeroDocumentoNFE);
                      Cobr.Fat.vOrig  := XQueryValorParcela.FieldByName('ValorFinal').asFloat;       //ZQueryValorParcelaValorFinal.Value;
                      Cobr.Fat.vLiq   := XQueryValorParcela.FieldByName('ValorFinal').asFloat;       //ZQueryValorParcelaValorFinal.Value;
                      if (XQueryValorParcela.FieldByName('ValorFinal').Value < XQueryValorParcela.FieldByName('ValorOriginal').Value) and
                         (XqueryCondicao.FieldByName('retencao').AsFloat = 0) then
                         begin
                           Cobr.Fat.vOrig  := XQueryValorParcela.FieldByName('ValorOriginal').asFloat;    //ZQueryValorParcelaValorOriginal.Value;
                           Cobr.Fat.vDesc  := XQueryValorParcela.FieldByName('ValorOriginal').asFloat - XQueryValorParcela.FieldByName('ValorFinal').asFloat;
                           Cobr.Fat.vLiq   := XQueryValorParcela.FieldByName('ValorFinal').asFloat;       //ZQueryValorParcelaValorFinal.Value;
                           FSomaDesconto   := FSomaDesconto + Cobr.Fat.vDesc;
                         end
                      else
                         begin
                           Cobr.Fat.vOrig  := XQueryValorParcela.FieldByName('ValorFinal').asFloat;       //ZQueryValorParcelaValorFinal.Value;
                           Cobr.Fat.vLiq   := XQueryValorParcela.FieldByName('ValorFinal').asFloat;       //ZQueryValorParcelaValorFinal.Value;
                         end;

                      XQueryParcela.first;
                      while not XQueryParcela.EOF do
                      begin
                        with Cobr.Dup.Add do
                        begin
                          nDup  := formatfloat('000',XQueryParcela.FieldByName('NumeroParcela').Value); //IntToStr(NumeroDocumentoNFE) //ZQueryParcelaNumeroParcela.AsString;
                          dVenc := XQueryParcela.FieldByName('DataVencimentoParcela').Value;  //ZQueryParcelaDataVencimentoParcela.Value;
                          vDup  := XQueryParcela.FieldByName('ValorFinalParcela').Value;       //ZQueryParcelaValorFinalParcela.Value;
                        end;
                        XQueryParcela.Next;
                      end;
                   end;
               end;
         end;

// Responsável Técnico
      infRespTec.idCSRT   :=  FidCSRT;
      infRespTec.hashCSRT :=  FCSRT;
      infRespTec.CNPJ     :=  FCNPJRT;
      infRespTec.xContato :=  FXContatoRT;
      infRespTec.email    :=  FEmailRT;
      infRespTec.fone     :=  FFoneRT;

     wvendedor            := TVendedor.Create;
     wagenciada           := TAgenciada.Create;
// CPF Vendedor
     if length(trim(XQueryNota.FieldByName('_cpfVendedor').AsString))>0 then
        begin
           wvendedor.XCampo    := 'Vendedor';
           wvendedor.XTexto    := XQueryNota.FieldByName('_cpfVendedor').AsString;
           InfAdic.obsCont.Add(wvendedor);
         end;
// Venda Agenciada
      if length(trim(XQueryNota.FieldByName('_vendaAgenciada').AsString))>0 then
         begin
           wagenciada.XCampo    := 'VendaAgenciada';
           wagenciada.XTexto    := XQueryNota.FieldByName('_vendaAgenciada').AsString;
           InfAdic.obsCont.Add(wagenciada);
         end;

// Define os dados das informações adicionais
      if XQueryNota.FieldByName('_EmpresaSimples').asInteger = 1 then
         begin
           if not(XQueryNota.FieldByName('_infCpl').IsNull) then
              infAdic.infCpl := 'DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL;'+sLineBreak+
                                'NÃO GERA DIREITO A CRÉDITO FISCAL DE IPI.'+slinebreak+XQueryNota.FieldByName('_infCpl').asString
           else
              infAdic.infCpl := 'DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL;'+sLineBreak+
                                'NÃO GERA DIREITO A CRÉDITO FISCAL DE IPI.';
         end
      else if length(trim(XQueryNota.FieldByName('_infCpl').asString))>0 then
         infAdic.infCpl := XQueryNota.FieldByName('_infCpl').asString;

      if length(trim(XQueryNota.FieldByName('_ObsNota').asString))>0 then
         begin
           if length(trim(infAdic.infCpl))>0 then
              infAdic.infCpl := infAdic.infCpl + slinebreak + XQueryNota.FieldByName('_ObsNota').asString
           else
              infAdic.infCpl := XQueryNota.FieldByName('_ObsNota').asString;
         end;

{      if FDiferimento then
         begin
           if length(trim(infAdic.infCpl))>0 then
              infAdic.infCpl := infAdic.infCpl + slinebreak + 'Dif parcial de 33,333% do valor operação cfe Livro III, Art. 1°-A, XVI e apêndice II, Seção IV, Subseção X do RICMS.'
           else
              infAdic.infCpl := 'Dif parcial de 33,333% do valor operação cfe Livro III, Art. 1°-A, XVI e apêndice II, Seção IV, Subseção X do RICMS.';
         end;}

// Grava Formas Pagamento
      if XQueryNota.FieldByName('_mod').AsInteger=55 then
         GravaPagamento(XQueryNota,XQueryparcela.RecordCount)
      else
         GravaPagamento(XQueryNota,1);
    end;
  except

  end;
end;

// Carrega os itens da nota
procedure TProviderServicoAutorizaNFe.GravaItem(XQueryNota,XQueryItem: TFDQuery; XConsumidorFinal: boolean);
var wquery,
    wqueryDetalheVeiculo,
    wqueryDetalheCombustivel: TFDQuery;
    ix: integer;
    OK: boolean;
    wqueryProdutoICMSSN500,wqueryProdutoICMSSN101,wqueryProdutoICMSSN102,wqueryProdutoICMSSN202: TFDQuery;
    wqueryProdutoICMS00,wqueryProdutoICMS10, wqueryProdutoICMS20,wqueryProdutoICMS30,wqueryProdutoICMS40,wqueryProdutoICMS51,wqueryProdutoICMS60,wqueryProdutoICMS70,wqueryProdutoICMS90: TFDQuery;
begin
  ix     := 0;
  if XQueryItem.IsEmpty then
     begin
       showmessage('Não registros de ítens');
       exit;
     end;

  wqueryProdutoICMSSN500 := TFDQuery.Create(nil);
  wqueryProdutoICMSSN101 := TFDQuery.Create(nil);
  wqueryProdutoICMSSN102 := TFDQuery.Create(nil);
  wqueryProdutoICMSSN202 := TFDQuery.Create(nil);
  wqueryProdutoICMS00    := TFDQuery.Create(nil);
  wqueryProdutoICMS10    := TFDQuery.Create(nil);
  wqueryProdutoICMS20    := TFDQuery.Create(nil);
  wqueryProdutoICMS30    := TFDQuery.Create(nil);
  wqueryProdutoICMS40    := TFDQuery.Create(nil);
  wqueryProdutoICMS51    := TFDQuery.Create(nil);
  wqueryProdutoICMS60    := TFDQuery.Create(nil);
  wqueryProdutoICMS70    := TFDQuery.Create(nil);
  wqueryProdutoICMS90    := TFDQuery.Create(nil);

  XQueryItem.DisableControls;
  XQueryItem.First;
  while not XQueryItem.Eof do
  begin
    with ACBrNFeAPi.NotasFiscais.Items[0].NFe.Det.Add do
    begin
      inc(ix);
      Prod.nItem := XQueryItem.FieldByName('_nItem').AsInteger;
      Prod.cProd := XQueryItem.FieldByName('_cProd').AsString;
      if (not(FNaoEnviaCodigoBarra)) or (length(trim(XQueryItem.FieldByName('_cEAN').asString))=0) then
         begin
           Prod.cEAN     := 'SEM GTIN';
           Prod.cEANTrib := 'SEM GTIN';
         end
      else
         begin
           Prod.cEAN     := XQueryItem.FieldByName('_cEAN').asString;
           Prod.cEANTrib := XQueryItem.FieldByName('_cEAN').asString;
         end;
      if (ACBrNFeAPi.Configuracoes.WebServices.Ambiente=taHomologacao) and (ix = 1) and (XQueryNota.FieldByName('_mod').AsInteger = 65) then
         Prod.xProd := 'NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
      else
         begin
           Prod.xProd := IfThen( (FIncluirLocProd=true) and (length(Trim(XQueryItem.FieldByName('_LocProd').asString))>0) ,
                                  '('+UpperCase(Trim(copy(XQueryItem.FieldByName('_LocProd').asString,1,FNumCaracLoc)))+') '+Trim(XQueryItem.FieldByName('_xProd').asString), Trim(XQueryItem.FieldByName('_xProd').asString) );
           Prod.xProd := IfThen( (FIncluirRefProd=true) and (length(Trim(XQueryItem.FieldByName('_RefProd').asString))>0) ,
                                  Prod.xProd+' '+Trim(XQueryItem.FieldByName('_RefProd').asString) , Prod.xProd);
           Prod.xProd := IfThen( (FIncluirObsProd=true) and (length(Trim(XQueryItem.FieldByName('_ObsProd').asString))>0) ,
                                  Prod.xProd+' '+Trim(XQueryItem.FieldByName('_ObsProd').asString) , Prod.xProd);
           Prod.xProd := IfThen((FIncluirCxsProd=true) and (XQueryItem.FieldByName('_qtdEmb').asFloat>1) ,
                                  Prod.xProd+' '+RetornaCaixas(Trim(XQueryItem.FieldByName('_Caixas').asString)), Prod.xProd);
         end;
         //Prod.xProd := XQueryItem.FieldByName('_xProd').asString;

      if not XQueryItem.FieldByName('_NCM').IsNull then
         Prod.NCM   := XQueryItem.FieldByName('_NCM').asString
      else
         Prod.NCM   := '99';
      Prod.CEST     := XQueryItem.FieldByName('_CEST').asString;
      Prod.CFOP     := XQueryItem.FieldByName('_CFOP').asString;
      Prod.uCom     := XQueryItem.FieldByName('_uCom').asString;
      Prod.cBenef   := XQueryItem.FieldByName('_cBenef').asString;
      Prod.qCom     := XQueryItem.FieldByName('_qCom').asFloat;
      Prod.vUnCom   := XQueryItem.FieldByName('_vUnCom').asFloat;
      Prod.vProd    := XQueryItem.FieldByName('_vProd').asFloat;
      Prod.uTrib    := XQueryItem.FieldByName('_uTrib').asString;
      Prod.qTrib    := XQueryItem.FieldByName('_qTrib').asFloat;
      Prod.vUnTrib  := XQueryItem.FieldByName('_vUnTrib').asFloat;
      if XQueryNota.FieldByName('_mod').AsInteger=55 then // NFe
         Prod.vFrete    := XQueryItem.FieldByName('_vFrete').asFloat;
      Prod.vSeg     := 0;
      Prod.vDesc    := XQueryItem.FieldByName('_vDesc').asFloat;
      Prod.vOutro   := XQueryItem.FieldByName('_vOutro').asFloat;
      Prod.IndTot   := StrToindTot(OK,IfThen(XQueryItem.FieldByName('_vProd').asFloat>0,'1','0'));
// Informações Adicionais do produto (Descrição Extendida)
      if XQueryItem.FieldByName('_InfAdProd').AsString <> '' then
         InfAdProd  :=  XQueryItem.FieldByName('_InfAdProd').asString;
// FCI - Ficha de Conteudo de Importacao
      if (XQueryItem.FieldByName('_nFCI').asString <> '') and
         (Length( Trim( StringReplace(XQueryItem.FieldByName('_nFCI').asString , '-' , '' , [rfReplaceAll, rfIgnoreCase]) ) ) = 32) then
         Prod.nFCI  := wquery.FieldByName('_nFCI').AsString;

      //Detalhamento especifico de veículo novos
{      if FDataSetDetalheVeiculo <> nil then
         begin
            wqueryDetalheVeiculo := TFDQuery(FDataSetDetalheVeiculo);
            with TFDQuery(FDataSetDetalheVeiculo) do
            begin
              DisableControls;
              Close;
              ParamByName('XNota').AsInteger := wquery.FieldByName('_codigoInternoItem').asInteger;
              Open;
              if RecordCount <> 0 then
                  begin
                     Prod.veicProd.tpOP         := StrTotpOp(OK, IntToStr(wqueryDetalheVeiculo.FieldByName('TipoOperacaoVeiculoItem').Value)); // StrTotpOp(OK, IntToStr(ZQueryDetalheVeiculoTipoOperacaoVeiculoItem.Value));
                     Prod.veicProd.chassi       := wqueryDetalheVeiculo.FieldByName('ChassiVeiculoItem').value;                                // ZQueryDetalheVeiculoChassiVeiculoItem.Value;
                     Prod.veicProd.cCor         := wqueryDetalheVeiculo.FieldByName('CodigoCorVeiculoItem').value;                             // ZQueryDetalheVeiculoCodigoCorVeiculoItem.Value;
                     Prod.veicProd.xCor         := wqueryDetalheVeiculo.FieldByName('DescricaoCorVeiculoItem').value;                          // ZQueryDetalheVeiculoDescricaoCorVeiculoItem.Value;
                     Prod.veicProd.cCorDENATRAN := RetornaCorDenatran(wqueryDetalheVeiculo.FieldByName('CodigoCorVeiculoItem').value);         // RetornaCorDenatran(ZQueryDetalheVeiculoCodigoCorVeiculoItem.Value); //ZQueryDetalheVeiculoDescricaoCorVeiculoItem.Value
                     Prod.veicProd.pot          := wqueryDetalheVeiculo.FieldByName('PotenciaMotorVeiculoItem').value;                         // ZQueryDetalheVeiculoPotenciaMotorVeiculoItem.Value;
                     Prod.veicProd.Cilin        := wqueryDetalheVeiculo.FieldByName('PotenciaCM3VeiculoItem').value;                           // ZQueryDetalheVeiculoPotenciaCM3VeiculoItem.Value;

                     Prod.veicProd.pesoL    := wqueryDetalheVeiculo.FieldByName('PesoLiquidoVeiculoItem').asString;                            // ZQueryDetalheVeiculoPesoLiquidoVeiculoItem.asString;
                     Prod.veicProd.pesoB    := wqueryDetalheVeiculo.FieldByName('PesoBrutoVeiculoItem').asString;                              // ZQueryDetalheVeiculoPesoBrutoVeiculoItem.asString;
                     Prod.veicProd.nSerie   := wqueryDetalheVeiculo.FieldByName('SerialVeiculoItem').Value;                                    // ZQueryDetalheVeiculoSerialVeiculoItem.Value;
                     Prod.veicProd.tpComb   := wqueryDetalheVeiculo.FieldByName('TipoCombustivelVeiculoItem').Value;                           // ZQueryDetalheVeiculoTipoCombustivelVeiculoItem.Value;
                     Prod.veicProd.nMotor   := wqueryDetalheVeiculo.FieldByName('NumeroMotorVeiculoItem').Value;                               // ZQueryDetalheVeiculoNumeroMotorVeiculoItem.Value;
                     Prod.veicProd.CMT      := wqueryDetalheVeiculo.FieldByName('CMKGVeiculoItem').Value;                                      // ZQueryDetalheVeiculoCMKGVeiculoItem.Value;

                     Prod.veicProd.dist     := wqueryDetalheVeiculo.FieldByName('DistanciaEntreEixoVeiculoItem').asString;                     // ZQueryDetalheVeiculoDistanciaEntreEixoVeiculoItem.asString;

                     Prod.veicProd.anoMod   := wqueryDetalheVeiculo.FieldByName('AnoModeloFabricacaoVeiculoItem').asInteger;                   // ZQueryDetalheVeiculoAnoModeloFabricacaoVeiculoItem.asInteger;
                     Prod.veicProd.anoFab   := wqueryDetalheVeiculo.FieldByName('AnoFabricacaoVeiculoItem').asInteger;                         // ZQueryDetalheVeiculoAnoFabricacaoVeiculoItem.asInteger;
                     Prod.veicProd.tpPint   := wqueryDetalheVeiculo.FieldByName('TipoPinturaVeiculoItem').Value;                               // ZQueryDetalheVeiculoTipoPinturaVeiculoItem.Value;
                     Prod.veicProd.tpVeic   := wqueryDetalheVeiculo.FieldByName('TipoVeiculoItem').asInteger;                                  // ZQueryDetalheVeiculoTipoVeiculoItem.asInteger;
                     Prod.veicProd.espVeic  := wqueryDetalheVeiculo.FieldByName('EspecieVeiculoItem').asInteger;                               // ZQueryDetalheVeiculoEspecieVeiculoItem.asInteger;
                     Prod.veicProd.VIN      := wqueryDetalheVeiculo.FieldByName('CondicaoVINVeiculoItem').Value;                               // ZQueryDetalheVeiculoCondicaoVINVeiculoItem.Value;
                     Prod.veicProd.condVeic := StrTocondVeic(OK, wqueryDetalheVeiculo.FieldByName('CondicaoVeiculoItem').Value);               // StrTocondVeic(OK, ZQueryDetalheVeiculoCondicaoVeiculoItem.Value);
                     Prod.veicProd.cMod     := wqueryDetalheVeiculo.FieldByName('CodigoMarcaModeloVeiculoItem').Value;                         // ZQueryDetalheVeiculoCodigoMarcaModeloVeiculoItem.Value;
                     Prod.veicProd.lota     := wqueryDetalheVeiculo.FieldByName('CapacidadeMaximaVeiculoItem').Value;                          // ZQueryDetalheVeiculoCapacidadeMaximaVeiculoItem.Value;
                     Prod.veicProd.tpRest   := wqueryDetalheVeiculo.FieldByName('RestricaoVeiculoItem').asInteger;                             // ZQueryDetalheVeiculoRestricaoVeiculoItem.AsInteger;
                  end;

              EnableControls;
            end;
         end;}

      //Detalhamento específico de combustíveis - Informado
{      if FDataSetDetalheCombustivel <> nil then
         begin
            wqueryDetalheCombustivel := TFDQuery(FDataSetDetalheCombustivel);
            with TFDQuery(FDataSetDetalheCombustivel) do
            begin
              DisableControls;
              Close;
              ParamByName('XNota').AsInteger :=  wquery.FieldByName('_codigoInternoItem').asInteger;
              Open;
              if RecordCount <> 0 then
                  begin
                    Prod.comb.cProdANP       := wqueryDetalheCombustivel.FieldByName('CodigoProdutoANPCombustivelItem').value;    // ZQueryDetalheCombustivelCodigoProdutoANPCombustivelItem.Value;     // 0;
                    Prod.comb.descANP        := wqueryDetalheCombustivel.FieldByName('DescANPCombustivelItem').value;    // ZQueryDetalheCombustivelCodigoProdutoANPCombustivelItem.Value;     // 0;
                    Prod.comb.pGLP           := wqueryDetalheCombustivel.FieldByName('PercentualGLPCombustivelItem').asFloat;
                    Prod.comb.pGNi           := wqueryDetalheCombustivel.FieldByName('PercentualGNiCombustivelItem').asFloat;
                    Prod.comb.pGNn           := wqueryDetalheCombustivel.FieldByName('PercentualGNnCombustivelItem').asFloat;
                    Prod.comb.vPart          := wqueryDetalheCombustivel.FieldByName('ValorPartidaCombustivelItem').asFloat;
//                    Prod.comb.CODIF          := wqueryDetalheCombustivel.FieldByName('CodAutorizacaoCombustivelItem').value;      // ZQueryDetalheCombustivelCodAutorizacaoCombustivelItem.Value;       //  '';
//                    Prod.comb.qTemp          := wqueryDetalheCombustivel.FieldByName('QtdeFatTempAmbienteCombustivelItem').value; // ZQueryDetalheCombustivelQtdeFatTempAmbienteCombustivelItem.Value;  //  0.00;
                    Prod.comb.UFcons         := wqueryDetalheCombustivel.FieldByName('UFConsumoCombustivelItem').value;           // ZQueryDetalheCombustivelUFConsumoCombustivelItem.Value;            //  '';
                    Prod.comb.CIDE.qBCProd   := wqueryDetalheCombustivel.FieldByName('BCQtdeCIDECombustivelItem').value;          // ZQueryDetalheCombustivelBCQtdeCIDECombustivelItem.Value;           //  0.00;
                    Prod.comb.CIDE.vAliqProd := wqueryDetalheCombustivel.FieldByName('ValorAliqCombustivelItem').value;           // ZQueryDetalheCombustivelValorAliqCombustivelItem.Value;            //  0.00;
                    Prod.comb.CIDE.vCIDE     := wqueryDetalheCombustivel.FieldByName('ValorCIDECombustivelItem').value;           // ZQueryDetalheCombustivelValorCIDECombustivelItem.Value;            //  0.00;
                  end;
              EnableControls;
            end;
         end;}

// Impostos
      with Imposto do
      begin
        begin
          vTotTrib          := Min_Round(XQueryItem.FieldByName('_vTotTribItem').asFloat,-2);  //ZProduto_vTotTribItem.Value; //0.0;
          FSomaVtotTribUnit := FSomaVtotTribUnit + Min_Round(XQueryItem.FieldByName('_vTotTribItem').asFloat,-2);
          // Se tiver algum tipo de imposto acrecenta ao produto
          if XQueryItem.FieldByName('_CST').asString <> '' then
             begin
              // Insere o imposto do ICMS
              with ICMS do
              begin
               // Caso a empresa seja optante pelo SIMPLES NACIONAL
               case XQueryNota.FieldByName('_EmpresaSimples').asInteger of
                 1: begin
                      //Teste criado para enganar o sistema e jogar o 202 da configuracao
                      //if (XQueryItem.FieldByName('_IncideST').AsBoolean) and (XQueryItem.FieldByName('_CFOP').asString = '5.405') and (XQueryItem.FieldByName('_mod').AsInteger = 65) then
                      if (XQueryItem.FieldByName('_IncideST').AsBoolean) and (XQueryItem.FieldByName('_CFOP').asString = '5.405') and (XQueryNota.FieldByName('_mod').AsInteger = 65) then
                         CSOSN := StrToCSOSNIcms(OK,'500')
                      else if (XQueryItem.FieldByName('_IncideST').AsBoolean) and (XQueryItem.FieldByName('_CFOP').asString = '5.405') then
                         CSOSN := StrToCSOSNIcms(OK,XQueryNota.FieldByName('_CSOSN_ST').asstring)
                      else
                      //Linha original
                         CSOSN := StrToCSOSNIcms(OK,XQueryNota.FieldByName('_CSOSN').asstring);

                      //Antigo teste que verifica apenas se InciteST e entra no icmssn500
                      //if ZProduto_IncideST.Value then
                      //if (XQueryItem.FieldByName('_IncideST').AsBoolean) and (XQueryNota.FieldByName('_CSOSN').asstring = '500') then
                      if (XQueryItem.FieldByName('_IncideST').AsBoolean) and (CSOSN = csosn500) then
                         begin
                           CSOSN := StrToCSOSNIcms(OK,XQueryNota.FieldByName('_CSOSN_ST').AsString);
                           with wqueryProdutoICMSSN500  do
                           begin
                             Connection := FConexao.FDConnectionApi;
                             DisableControls;
                             Close;
                             SQL.Clear;
                             Params.Clear;
                             SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicmssimples500(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                             SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_CSON" Character Varying(3),"_vBCST" numeric(15,2),"_vICMSST" numeric(15,2),');
                             SQL.Add('"_vBCSTRet" numeric(15,2),"_vICMSSTRet" numeric(15,2),"_pST" numeric(15,2),"_vICMSSubstituto" numeric(15,2),');
                             SQL.Add('"_vBCFCPSTRet" numeric(15,2),"_pFCPSTRet" numeric(15,2),"_vFCPSTRet" numeric(15,2)) ');
                             ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                             ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                             Open;
                             EnableControls;
                             ICMS.orig            := StrToOrig(OK,wqueryProdutoICMSSN500.FieldByName('_orig').asString);
                             ICMS.vBCST           := wqueryProdutoICMSSN500.FieldByName('_vBCST').asFloat; // V.1.0
                             ICMS.vICMSST         := wqueryProdutoICMSSN500.FieldByName('_vICMSST').asFloat; // V.1.0
                             ICMS.pST             := wqueryProdutoICMSSN500.FieldByName('_pST').asFloat;
                             ICMS.vBCSTRet        := wqueryProdutoICMSSN500.FieldByName('_vBCSTRet').asFloat;
                             ICMS.vICMSSTRet      := wqueryProdutoICMSSN500.FieldByName('_vICMSSTRet').asFloat;
                             ICMS.vICMSSubstituto := wqueryProdutoICMSSN500.FieldByName('_vICMSSubstituto').asFloat;
                             if (FICMSEfetivo) and not(ICMS.vBCSTRet>0) then
                                begin
                                  ICMS.pRedBCEfet := XQueryItem.FieldByName('_PercReduzST').asFloat;
                                  ICMS.vBCEfet    := XQueryItem.FieldByName('_vProd').asFloat - XQueryItem.FieldByName('_vDesc').asFloat;
                                  ICMS.pICMSEfet  := XQueryItem.FieldByName('_AliqST').asFloat;
  //                                ICMS.pICMSEfet  := 18;
  //                                ICMS.vICMSEfet  := (XQueryItem.FieldByName('_vProd').asFloat * 18)/100;
                                  ICMS.vICMSEfet  := (ICMS.vBCEfet * XQueryItem.FieldByName('_AliqST').asFloat)/100;
                                  if XQueryItem.FieldByName('_PercReduzST').asFloat>0 then
                                     ICMS.vICMSEfet  := (ICMS.vICMSEfet * XQueryItem.FieldByName('_PercReduzST').asFloat)/100;
                                end;
                             if FVersaoDF = ve400 then
                                begin
                                  ICMS.vBCFCP       := 0.00;
                                  ICMS.pFCP         := 0.00;
                                  ICMS.vFCP         := 0.00;

                                  ICMS.vBCFCPST     := 0.00;
                                  ICMS.pFCPST       := 0.00;
                                  ICMS.vFCPST       := 0.00;

                                  ICMS.vBCFCPSTRet  := wqueryProdutoICMSSN500.FieldByName('_vBCFCPSTRet').asFloat;
                                  ICMS.pFCPSTRet    := wqueryProdutoICMSSN500.FieldByName('_pFCPSTRet').asFloat;
                                  ICMS.vFCPSTRet    := wqueryProdutoICMSSN500.FieldByName('_vFCPSTRet').asFloat;

                                  FSomaFCPSTRet     := FSomaFCPSTRet + wqueryProdutoICMSSN500.FieldByName('_vFCPSTRet').asFloat;
                               end;

                           end;
                         end
                      else
                         begin
                           case CSOSN of
                             csosn101: with wQueryProdutoICMSSN101 do
                                       begin
                                         Connection := FConexao.FDConnectionApi;
                                         DisableControls;
                                         Close;
                                         SQL.Clear;
                                         Params.Clear;
                                         SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicmssimples101(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                                         SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),	"_pCredSN" Numeric(15, 2),	"_vCredICMSSN" Numeric(15, 2)) ');
                                         ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                                         ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                                         Open;
                                         ICMS.orig        := StrToOrig(OK,wQueryProdutoICMSSN101.FieldByName('_orig').asString);
                                         ICMS.pCredSN     := wQueryProdutoICMSSN101.FieldByName('_pCredSN').asFloat;
                                         ICMS.vCredICMSSN := wQueryProdutoICMSSN101.FieldByName('_vCredICMSSN').asFloat;
                                         if FVersaoDF = ve400 then
                                         begin
                                           ICMS.vBCFCP       := 0.00;
                                           ICMS.pFCP         := 0.00;
                                           ICMS.vFCP         := 0.00;

                                           ICMS.vBCFCPST     := 0.00;
                                           ICMS.pFCPST       := 0.00;
                                           ICMS.vFCPST       := 0.00;

                                           ICMS.vBCFCPSTRet  := 0.00;
                                           ICMS.pFCPSTRet    := 0.00;
                                           ICMS.vFCPSTRet    := 0.00;
                                         end;
                                       end;
                             csosn102,csosn103,csosn300,csosn400: with wQueryProdutoICMSSN102 do
                                                         begin
                                                           Connection := FConexao.FDConnectionApi;
                                                           DisableControls;
                                                           Close;
                                                           SQL.Clear;
                                                           Params.Clear;
                                                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicmssimples102(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                                                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_CSON" Character Varying(3)) ');
                                                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                                                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                                                           Open;
                                                           ICMS.orig  := StrToOrig(OK,wQueryProdutoICMSSN102.FieldByName('_orig').asString);
                                                           if FVersaoDF = ve400 then
                                                           begin
                                                             ICMS.vBCFCP       := 0.00;
                                                             ICMS.pFCP         := 0.00;
                                                             ICMS.vFCP         := 0.00;

                                                             ICMS.vBCFCPST     := 0.00;
                                                             ICMS.pFCPST       := 0.00;
                                                             ICMS.vFCPST       := 0.00;

                                                             ICMS.vBCFCPSTRet  := 0.00;
                                                             ICMS.pFCPSTRet    := 0.00;
                                                             ICMS.vFCPSTRet    := 0.00;
                                                           end;
                                                          end;
                             csosn201,csosn202: with wQueryProdutoICMSSN202 do
                                       begin
                                         Connection := FConexao.FDConnectionApi;
                                         DisableControls;
                                         Close;
                                         SQL.Clear;
                                         Params.Clear;
                                         SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicmssimples202(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                                         SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_CSON" Character Varying(3),"_modBCST" Integer,');
                                         SQL.Add('"_vBCST" numeric(15,2),"_pICMSST" numeric(15,2),"_vICMSST" numeric(15,2),"_vBCFCPST" numeric(15,2),"_pFCPST" numeric(15,2),"_vFCPST" numeric(15,2)) ');
                                         ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                                         ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                                         Open;
                                         ICMS.orig    := StrToOrig(OK,wQueryProdutoICMSSN202.FieldByName('_orig').asString);
                                         ICMS.CSOSN   := StrToCSOSNIcms(OK,XQueryNota.FieldByName('_CSOSN').asString);
                                         ICMS.modBCST := StrTomodBCST(OK, IntToStr(wQueryProdutoICMSSN202.FieldByName('_modBCST').asInteger));
                                         ICMS.vBCST   := wQueryProdutoICMSSN202.FieldByName('_vBCST').asFloat;
                                         ICMS.pICMSST := wQueryProdutoICMSSN202.FieldByName('_pICMSST').asFloat;
                                         ICMS.vICMSST := wQueryProdutoICMSSN202.FieldByName('_vICMSST').asFloat;
                                         if FVersaoDF = ve400 then
                                            begin
                                              ICMS.vBCFCP       := 0.00;
                                              ICMS.pFCP         := 0.00;
                                              ICMS.vFCP         := 0.00;

                                              ICMS.vBCFCPST     := wQueryProdutoICMSSN202.FieldByName('_vBCFCPST').asFloat;
                                              ICMS.pFCPST       := wQueryProdutoICMSSN202.FieldByName('_pFCPST').asFloat;
                                              ICMS.vFCPST       := wQueryProdutoICMSSN202.FieldByName('_vFCPST').asFloat;
                                              FSomaFCPST        := FSomaFCPST + wQueryProdutoICMSSN202.FieldByName('_vFCPST').asFloat;

                                              ICMS.vBCFCPSTRet  := 0.00;
                                              ICMS.pFCPSTRet    := 0.00;
                                              ICMS.vFCPSTRet    := 0.00;
                                            end;
                                       end;
                           end; // Fim do Case CSOSN
                         end;
                    end; // case Empresa = Simples
               else
                    begin
                      CST := StrToCSTICMS(OK,XQueryItem.FieldByName('_CST').asString);
                      if CST = cst00 then
                         with wQueryProdutoICMS00 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms00(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_modBC" Integer,"_vBC" Numeric(15, 2),');
                           SQL.Add('"_pICMS" Numeric(15, 2),"_vICMS" Numeric(15, 2),"_pFCP" numeric(15,2),"_vFCP" numeric(15,2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig   := StrToOrig(OK,wQueryProdutoICMS00.FieldByName('_orig').asString);
                           ICMS.modBC  := StrTomodBC(OK, IntToStr(wQueryProdutoICMS00.FieldByName('_modBC').asInteger));
                           ICMS.vBC    := wQueryProdutoICMS00.FieldByName('_vBC').asFloat;
                           ICMS.pICMS  := wQueryProdutoICMS00.FieldByName('_pICMS').asFloat;
                           ICMS.vICMS  := wQueryProdutoICMS00.FieldByName('_vICMS').asFloat;
                           EnableControls;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := 0.00;
                                ICMS.pFCP         := wQueryProdutoICMS00.FieldByName('_pFCP').asFloat;
                                ICMS.vFCP         := wQueryProdutoICMS00.FieldByName('_vFCP').asFloat;
                                FSomaFCP          := FSomaFCP + wQueryProdutoICMS00.FieldByName('_vFCP').asFloat;

                                ICMS.vBCFCPST     := 0.00;
                                ICMS.pFCPST       := 0.00;
                                ICMS.vFCPST       := 0.00;

                                ICMS.vBCFCPSTRet  := 0.00;
                                ICMS.pFCPSTRet    := 0.00;
                                ICMS.vFCPSTRet    := 0.00;
                              end;
                         end
                      else if CST = cst10 then
                         with wQueryProdutoICMS10 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms10(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_modBC" Integer,"_vBC" Numeric(15, 2),"_pICMS" Numeric(15, 2),');
                           SQL.Add('"_vICMS" Numeric(15, 2),"_modBCST" Integer,"_vBCST" Numeric(15, 2),"_vICMSST" Numeric(15, 2),"_pMVAST" numeric(15,2),');
                           SQL.Add('"_pRedBCST" numeric(15,2),"_pICMSST" numeric(15,2),"_vBCFCP" numeric(15,2),"_pFCP" numeric(15,2),');
                           SQL.Add('"_vFCP" numeric(15,2),"_vBCFCPST" numeric(15,2),"_pFCPST" numeric(15,2),"_vFCPST" numeric(15,2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig     := StrToOrig(OK,wQueryProdutoICMS10.FieldByName('_orig').asString);
                           ICMS.modBC    := StrTomodBC(OK, IntToStr(wQueryProdutoICMS10.FieldByName('_modBC').asInteger));
                           ICMS.vBC      := wQueryProdutoICMS10.FieldByName('_vBC').asFloat;
                           ICMS.pICMS    := wQueryProdutoICMS10.FieldByName('_pICMS').asFloat;
                           ICMS.vICMS    := wQueryProdutoICMS10.FieldByName('_vICMS').asFloat;
                           ICMS.modBCST  := StrTomodBCST(OK, IntToStr(wQueryProdutoICMS10.FieldByName('_modBCST').asInteger));
                           ICMS.pMVAST   := wQueryProdutoICMS10.FieldByName('_pMVAST').asFloat;
                           ICMS.pRedBCST := wQueryProdutoICMS10.FieldByName('_pRedBCST').AsFloat;
                           ICMS.vBCST    := wQueryProdutoICMS10.FieldByName('_vBCST').asFloat;
                           ICMS.pICMSST  := wQueryProdutoICMS10.FieldByName('_pICMSST').asFloat;
                           ICMS.vICMSST  := wQueryProdutoICMS10.FieldByName('_vICMSST').asFloat;
                           EnableControls;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := wQueryProdutoICMS10.FieldByName('_vBCFCP').asFloat;
                                ICMS.pFCP         := wQueryProdutoICMS10.FieldByName('_pFCP').asFloat;
                                ICMS.vFCP         := wQueryProdutoICMS10.FieldByName('_vFCP').asFloat;
                                FSomaFCP          := FSomaFCP + wQueryProdutoICMS10.FieldByName('_vFCP').asFloat;

                                ICMS.vBCFCPST     := wQueryProdutoICMS10.FieldByName('_vBCFCPST').asFloat;
                                ICMS.pFCPST       := wQueryProdutoICMS10.FieldByName('_pFCPST').asFloat;
                                ICMS.vFCPST       := wQueryProdutoICMS10.FieldByName('_vFCPST').asFloat;
                                FSomaFCPST        := FSomaFCPST + wQueryProdutoICMS10.FieldByName('_vFCPST').asFloat;

                                ICMS.vBCFCPSTRet  := 0.00;
                                ICMS.pFCPSTRet    := 0.00;
                                ICMS.vFCPSTRet    := 0.00;
                              end;
                         end
                      else if CST = cst20 then
                         with wQueryProdutoICMS20 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms20(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_modBC" Integer,"_vBC" Numeric(15, 2),"_pICMS" Numeric(15, 2),');
                           SQL.Add('"_vICMS" Numeric(15, 2),"_pRedBC" numeric(15,2),"_vBCFCP" numeric(15,2),"_pFCP" numeric(15,2),"_vFCP" numeric(15,2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig   := StrToOrig(OK,wQueryProdutoICMS20.FieldByName('_orig').asString);
                           ICMS.modBC  := StrTomodBC(OK, IntToStr(wQueryProdutoICMS20.FieldByName('_modBC').asInteger));
                           ICMS.pRedBC := wQueryProdutoICMS20.FieldByName('_pRedBC').asFloat;
                           ICMS.vBC    := wQueryProdutoICMS20.FieldByName('_vBC').asFloat;
                           ICMS.pICMS  := wQueryProdutoICMS20.FieldByName('_pICMS').asFloat;
                           ICMS.vICMS  := wQueryProdutoICMS20.FieldByName('_vICMS').asFloat;
                           EnableControls;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := wQueryProdutoICMS20.FieldByName('_vBCFCP').asFloat;
                                ICMS.pFCP         := wQueryProdutoICMS20.FieldByName('_pFCP').asFloat;
                                ICMS.vFCP         := wQueryProdutoICMS20.FieldByName('_vFCP').asFloat;
                                FSomaFCP          := FSomaFCP + wQueryProdutoICMS20.FieldByName('_vFCP').asFloat;

                                ICMS.vBCFCPST     := 0.00;
                                ICMS.pFCPST       := 0.00;
                                ICMS.vFCPST       := 0.00;

                                ICMS.vBCFCPSTRet  := 0.00;
                                ICMS.pFCPSTRet    := 0.00;
                                ICMS.vFCPSTRet    := 0.00;
                              end;
                         end
                      else if CST = cst30 then
                         with wQueryProdutoICMS30 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms30(:XCodigoInternoNota, :XCodigoInternoItem, :XEhSimples) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_modBCST" Integer,"_vBCST" Numeric(15, 2),"_vICMSST" Numeric(15, 2),');
                           SQL.Add('"_pMVA" numeric(15,2),"_pRedBCST" numeric(15,2),"_pICMSST" numeric(15,2),"_vBCFCPST" numeric(15,2),"_pFCPST" numeric(15,2),"_vFCPST" numeric(15,2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig     := StrToOrig(OK,wQueryProdutoICMS30.FieldByName('_orig').asString);
                           ICMS.modBCST  := StrTomodBCST(OK, IntToStr(wQueryProdutoICMS30.FieldByName('_modBCST').asInteger));
                           ICMS.pMVAST   := wQueryProdutoICMS30.FieldByName('_pMVA').asFloat;
                           ICMS.pRedBCST := wQueryProdutoICMS30.FieldByName('_pRedBCST').asFloat;
                           ICMS.vBCST    := wQueryProdutoICMS30.FieldByName('_vBCST').asFloat;
                           ICMS.pICMSST  := wQueryProdutoICMS30.FieldByName('_pICMSST').asFloat;
                           ICMS.vICMSST  := wQueryProdutoICMS30.FieldByName('_vICMSST').asFloat;
                           EnableControls;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := 0.00;
                                ICMS.pFCP         := 0.00;
                                ICMS.vFCP         := 0.00;

                                ICMS.vBCFCPST     := wQueryProdutoICMS30.FieldByName('_vBCFCPST').asFloat;
                                ICMS.pFCPST       := wQueryProdutoICMS30.FieldByName('_pFCPST').asFloat;
                                ICMS.vFCPST       := wQueryProdutoICMS30.FieldByName('_vFCPST').asFloat;
                                FSomaFCPST        := FSomaFCPST + wQueryProdutoICMS30.FieldByName('_vFCPST').asFloat;

                                ICMS.vBCFCPSTRet  := 0.00;
                                ICMS.pFCPSTRet    := 0.00;
                                ICMS.vFCPSTRet    := 0.00;
                              end;
                         end
                      else if (CST = cst40) or (CST = cst41) or (CST = cst50) then
                         with wQueryProdutoICMS40 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms40(:XCodigoInternoNota, :XCodigoInternoItem,:XEhSimples) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig       := StrToOrig(OK,wQueryProdutoICMS40.FieldByName('_orig').asString);
                           EnableControls;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := 0.00;
                                ICMS.pFCP         := 0.00;
                                ICMS.vFCP         := 0.00;

                                ICMS.vBCFCPST     := 0.00;
                                ICMS.pFCPST       := 0.00;
                                ICMS.vFCPST       := 0.00;

                                ICMS.vBCFCPSTRet  := 0.00;
                                ICMS.pFCPSTRet    := 0.00;
                                ICMS.vFCPSTRet    := 0.00;
                              end;
                         end
                      else if CST = cst51 then
                         with wQueryProdutoICMS51 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms51(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_modBC" Integer,"_vBC" Numeric(15, 2),"_pICMS" Numeric(15, 4),');
                           SQL.Add('"_vICMS" Numeric(15, 2),"_pDif" Numeric(15, 4),"_vICMSDif" Numeric(15, 2),"_vICMSop" Numeric(15, 2),"_vBCFCP" numeric(15,2),"_pFCP" numeric(15,4),"_vFCP" numeric(15,2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig     := StrToOrig(OK,wQueryProdutoICMS51.FieldByName('_orig').asString);
                           ICMS.modBC    := StrTomodBC(OK, IntToStr(wQueryProdutoICMS51.FieldByName('_modBC').asInteger));
                           ICMS.pRedBC   := 0.0;
                           ICMS.vBC      := wQueryProdutoICMS51.FieldByName('_vBC').asFloat;
                           ICMS.pICMS    := wQueryProdutoICMS51.FieldByName('_pICMS').asFloat;
                           ICMS.vICMS    := wQueryProdutoICMS51.FieldByName('_vICMS').asFloat;
                           ICMS.pDif     := wQueryProdutoICMS51.FieldByName('_pDif').asFloat;
                           ICMS.vICMSOp  := wQueryProdutoICMS51.FieldByName('_vICMSop').asFloat;
                           ICMS.vICMSDif := wQueryProdutoICMS51.FieldByName('_vICMSDif').asFloat;
                           EnableControls;
                           FDiferimento  := true;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := wQueryProdutoICMS51.FieldByName('_vBCFCP').asFloat;
                                ICMS.pFCP         := wQueryProdutoICMS51.FieldByName('_pFCP').asFloat;
                                ICMS.vFCP         := wQueryProdutoICMS51.FieldByName('_vFCP').asFloat;
                                FSomaFCP          := FSomaFCP + wQueryProdutoICMS51.FieldByName('_vFCP').asFloat;

                                ICMS.vBCFCPST     := 0.00;
                                ICMS.pFCPST       := 0.00;
                                ICMS.vFCPST       := 0.00;

                                ICMS.vBCFCPSTRet  := 0.00;
                                ICMS.pFCPSTRet    := 0.00;
                                ICMS.vFCPSTRet    := 0.00;
                              end;
                         end
                      else if CST = cst60 then
                         with wQueryProdutoICMS60 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms60(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_modBCST" Integer,"_vBCST" Numeric(15, 2),"_vICMSST" Numeric(15, 2),');
                           SQL.Add('"_vBCSTRet" numeric(15,2),"_vICMSSTRet" numeric(15,2),"_pST" numeric(15,2),"_vICMSSubstituto" numeric(15,2),');
                           SQL.Add('"_vBCFCPSTRet" numeric(15,2),"_pFCPSTRet" numeric(15,2),"_vFCPSTRet" numeric(15,2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig            := StrToOrig(OK,wQueryProdutoICMS60.FieldByName('_orig').asString);
                           ICMS.vBCSTRet        := wQueryProdutoICMS60.FieldByName('_vBCSTRet').asFloat;
                           ICMS.vBCST           := wQueryProdutoICMS60.FieldByName('_vBCST').asFloat; // V.1.0
                           ICMS.vICMSSTRet      := wQueryProdutoICMS60.FieldByName('_vICMSSTRet').asFloat;
                           ICMS.vICMSST         := wQueryProdutoICMS60.FieldByName('_vICMSST').asFloat; // V.1.0
                           ICMS.pST             := wQueryProdutoICMS60.FieldByName('_pST').asFloat;
                           ICMS.vICMSSubstituto := wQueryProdutoICMS60.FieldByName('_vICMSSubstituto').asFloat;

                           if (FICMSEfetivo) and not(ICMS.vBCSTRet>0) then
                              begin
                                ICMS.pRedBCEfet := XQueryItem.FieldByName('_PercReduzST').asFloat;
                                ICMS.vBCEfet    := XQueryItem.FieldByName('_vProd').asFloat - XQueryItem.FieldByName('_vDesc').asFloat;
                                ICMS.pICMSEfet  := XQueryItem.FieldByName('_AliqST').asFloat;
                                ICMS.vICMSEfet  := (ICMS.vBCEfet * XQueryItem.FieldByName('_AliqST').asFloat)/100;
                                if XQueryItem.FieldByName('_PercReduzST').asFloat>0 then
                                   ICMS.vICMSEfet  := (ICMS.vICMSEfet * XQueryItem.FieldByName('_PercReduzST').asFloat)/100;
                              end;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := 0.00;
                                ICMS.pFCP         := 0.00;
                                ICMS.vFCP         := 0.00;

                                ICMS.vBCFCPST     := 0.00;
                                ICMS.pFCPST       := 0.00;
                                ICMS.vFCPST       := 0.00;

                                ICMS.vBCFCPSTRet  := wQueryProdutoICMS60.FieldByName('_vBCFCPSTRet').asFloat;
                                ICMS.pFCPSTRet    := wQueryProdutoICMS60.FieldByName('_pFCPSTRet').asFloat;
                                ICMS.vFCPSTRet    := wQueryProdutoICMS60.FieldByName('_vFCPSTRet').asFloat;
                                FSomaFCPSTRet     := FSomaFCPSTRet + wQueryProdutoICMS60.FieldByName('_vFCPSTRet').asFloat;
                              end;
                           EnableControls;
                         end
                      else if CST = cst70 then
                         with wQueryProdutoICMS70 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms70(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_modBC" Integer,"_vBC" Numeric(15, 2),"_pICMS" Numeric(15, 2),');
                           SQL.Add('"_vICMS" Numeric(15, 2),"_modBCST" Integer,"_vBCST" Numeric(15, 2),"_vICMSST" Numeric(15, 2),"_pRedBC" numeric(15,2),"_pRedBCST" numeric(15,2),');
                           SQL.Add('"_pMVAST" numeric(15,2),"_pICMSST" numeric(15,2),"_vBCFCP" numeric(15,2),"_pFCP" numeric(15,2),"_vFCP" numeric(15,2),');
                           SQL.Add('"_vBCFCPST" numeric(15,2),"_pFCPST" numeric(15,2),"_vFCPST" numeric(15,2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig     := StrToOrig(OK,wQueryProdutoICMS70.FieldByName('_orig').asString);
                           ICMS.modBC    := StrTomodBC(OK, IntToStr(wQueryProdutoICMS70.FieldByName('_modBC').asInteger));
                           ICMS.pRedBC   := wQueryProdutoICMS70.FieldByName('_pRedBC').asFloat;
                           ICMS.vBC      := wQueryProdutoICMS70.FieldByName('_vBC').asFloat;
                           ICMS.pICMS    := wQueryProdutoICMS70.FieldByName('_pICMS').asFloat;
                           ICMS.vICMS    := wQueryProdutoICMS70.FieldByName('_vICMS').asFloat;
                           ICMS.modBCST  := StrTomodBCST(OK, IntToStr(wQueryProdutoICMS70.FieldByName('_modBCST').asInteger));
                           ICMS.pMVAST   := wQueryProdutoICMS70.FieldByName('_pMVAST').asFloat;
                           ICMS.pRedBCST := wQueryProdutoICMS70.FieldByName('_pRedBCST').asFloat;
                           ICMS.vBCST    := wQueryProdutoICMS70.FieldByName('_vBCST').AsFloat;
                           ICMS.pICMSST  := wQueryProdutoICMS70.FieldByName('_pICMSST').asFloat;
                           ICMS.vICMSST  := wQueryProdutoICMS70.FieldByName('_vICMSST').asFloat;
                           EnableControls;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := wQueryProdutoICMS70.FieldByName('_vBCFCP').asFloat;
                                ICMS.pFCP         := wQueryProdutoICMS70.FieldByName('_pFCP').asFloat;
                                ICMS.vFCP         := wQueryProdutoICMS70.FieldByName('_vFCP').asFloat;
                                FSomaFCP          := FSomaFCP + wQueryProdutoICMS70.FieldByName('_vFCP').asFloat;

                                ICMS.vBCFCPST     := wQueryProdutoICMS70.FieldByName('_vBCFCPST').asFloat;
                                ICMS.pFCPST       := wQueryProdutoICMS70.FieldByName('_pFCPST').asFloat;
                                ICMS.vFCPST       := wQueryProdutoICMS70.FieldByName('_vFCPST').asFloat;
                                FSomaFCPST        := FSomaFCPST + wQueryProdutoICMS70.FieldByName('_vFCPST').asFloat;

                                ICMS.vBCFCPSTRet  := 0.00;
                                ICMS.pFCPSTRet    := 0.00;
                                ICMS.vFCPSTRet    := 0.00;
                              end;
                         end
                      else if CST = cst90 then
                         with wQueryProdutoICMS90 do
                         begin
                           Connection := FConexao.FDConnectionApi;
                           DisableControls;
                           Close;
                           SQL.Clear;
                           Params.Clear;
                           SQL.Add('SELECT * FROM ts_nfe_retornaimpostoprodutoicms90(:XCodigoInternoNota, :XCodigoInternoItem) AS (');
                           SQL.Add('"_orig" Character Varying(1),"_CST" Character Varying(2),"_modBC" Integer,"_vBC" Numeric(15, 2),"_pICMS" Numeric(15, 2),');
                           SQL.Add('"_vICMS" Numeric(15, 2),"_modBCST" Integer,"_vBCST" Numeric(15, 2),"_vICMSST" Numeric(15, 2),"_vBCFCP" numeric(15,2),"_pFCP" numeric(15,2),');
                           SQL.Add('"_vFCP" numeric(15,2),"_vBCFCPST" numeric(15,2),"_pFCPST" numeric(15,2),"_vFCPST" numeric(15,2)) ');
                           ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
                           ParamByName('XCodigoInternoItem').AsInteger := XQueryItem.FieldByName('_codigoInternoItem').asInteger;
                           Open;
                           ICMS.orig     := StrToOrig(OK,wQueryProdutoICMS90.FieldByName('_orig').asString);
                           ICMS.modBC    := StrTomodBC(OK, IntToStr(wQueryProdutoICMS90.FieldByName('_modBC').asInteger));
                           ICMS.pRedBC   := 0.0;
                           ICMS.vBC      := wQueryProdutoICMS90.FieldByName('_vBC').asFloat;
                           ICMS.pICMS    := wQueryProdutoICMS90.FieldByName('_pICMS').asFloat;
                           ICMS.vICMS    := wQueryProdutoICMS90.FieldByName('_vICMS').asFloat;
                           ICMS.modBCST  := StrTomodBCST(OK, IntToStr(wQueryProdutoICMS90.FieldByName('_modBCST').asInteger));
                           ICMS.pMVAST   := 0.0;
                           ICMS.pRedBCST := 0.0;
                           ICMS.vBCST    := wQueryProdutoICMS90.FieldByName('_vBCST').asFloat;
                           ICMS.pICMSST  := StringToFloatDef('' ,0);
                           ICMS.vICMSST  := wQueryProdutoICMS90.FieldByName('_vICMSST').asFloat;
                           EnableControls;
                           if FVersaoDF = ve400 then
                              begin
                                ICMS.vBCFCP       := wQueryProdutoICMS90.FieldByName('_vBCFCP').asFloat;
                                ICMS.pFCP         := wQueryProdutoICMS90.FieldByName('_pFCP').asFloat;
                                ICMS.vFCP         := wQueryProdutoICMS90.FieldByName('_vFCP').asFloat;
                                FSomaFCP          := FSomaFCP + wQueryProdutoICMS90.FieldByName('_vFCP').asFloat;

                                ICMS.vBCFCPST     := wQueryProdutoICMS90.FieldByName('_vBCFCPST').asFloat;
                                ICMS.pFCPST       := wQueryProdutoICMS90.FieldByName('_pFCPST').asFloat;
                                ICMS.vFCPST       := wQueryProdutoICMS90.FieldByName('_vFCPST').asFloat;
                                FSomaFCPST        := FSomaFCPST + wQueryProdutoICMS90.FieldByName('_vFCPST').asFloat;

                                ICMS.vBCFCPSTRet  := 0.00;
                                ICMS.pFCPSTRet    := 0.00;
                                ICMS.vFCPSTRet    := 0.00;
                              end;
                         end;
                    end; // Fim with ICMS do
               end;
               if ACBrNFeApi.NotasFiscais.Items[0].NFe.Ide.indFinal = cfConsumidorFinal then
                  begin
                    if (XQueryNota.FieldByName('_identIEDest').asString = '9') and
                       (XQueryNota.FieldByName('_mod').asInteger = 55) and
                       (UpperCase(XQueryNota.FieldByName('_UFEmit').asString) <> UpperCase(XQueryNota.FieldByName('_UFDest').asString)) and
                       (UpperCase(XQueryNota.FieldByName('_UFDest').asString) <>'EX') and
                       (XQueryNota.FieldByName('_VendaPresencial').asBoolean = False) then
                       begin
                         ICMSUFDest.pFCPUFDest     := 0.00;
                         ICMSUFDest.vFCPUFDest     := 0.00;
                         ICMSUFDest.vBCUFDest      := ArredondaValorNew(XQueryItem.FieldByName('_vProd').asFloat - XQueryItem.FieldByName('_vDesc').asFloat,2); // 100.0;
//Alteracao proposta pelo Marcelo afim de somente carregar os valores da partilha sem efetuar o calculo atraves do uGerenciador
                         //{
                         ICMSUFDest.pICMSUFDest    := XQueryItem.FieldByName('_pICMSUFDest').asFloat;
                         ICMSUFDest.pICMSInter     := XQueryItem.FieldByName('_pICMSInter').asFloat;
                         ICMSUFDest.pICMSInterPart := XQueryItem.FieldByName('_pICMSInterPart').asFloat;
                         ICMSUFDest.vICMSUFDest    := XQueryItem.FieldByName('_vICMSUFDest').asFloat;
                         ICMSUFDest.vICMSUFRemet   := XQueryItem.FieldByName('_vICMSUFRemet').asFloat;
                         if FVersaoDF = ve400 then
                            ICMSUFDest.vBCFCPUFDest := 0.00;
                         FSomaICMSUFDest            := ArredondaValorNew(FSomaICMSUFDest  + ICMSUFDest.vICMSUFDest,2);
                         FSomaICMSUFRemet           := ArredondaValorNew(FSomaICMSUFRemet + ICMSUFDest.vICMSUFRemet,2);
                         //}
                         {
                        //Alterado para Marsou
                        //ICMSUFDest.pICMSUFDest    := 18.0;
                         ICMSUFDest.pICMSUFDest    := RetornaAliquotaDestino(UpperCase(XQueryNota.FieldByName('_UFDest').asString)); //18.0;
                         if ICMS.pICMS=4.00 then  // produto importado
                            ICMSUFDest.pICMSInter     := ICMS.pICMS //12.0;
                         else if (UpperCase(XQueryNota.FieldByName('_UFDest').asString)='SC') or
                                 (UpperCase(XQueryNota.FieldByName('_UFDest').asString)='PR') or
                                 (UpperCase(XQueryNota.FieldByName('_UFDest').asString)='SP') or
                                 (UpperCase(XQueryNota.FieldByName('_UFDest').asString)='RJ') or
                                 (UpperCase(XQueryNota.FieldByName('_UFDest').asString)='MG') then
                            ICMSUFDest.pICMSInter     := 12.0
                         else
                            ICMSUFDest.pICMSInter     := 7.0;

                         //ICMSUFDest.pICMSInterPart := 60.0;         //40.0;
                         //Os percentuais de ICMS Interestadual para a UF de destino serão:
                         if StrToInt(formatdatetime('yyyy',date)) = 2016 then        //40% em 2016;
                           ICMSUFDest.pICMSInterPart := 40.0
                         else if StrToInt(formatdatetime('yyyy',date)) = 2017 then   //60% em 2017;
                           ICMSUFDest.pICMSInterPart := 60.0
                         else if StrToInt(formatdatetime('yyyy',date)) = 2018 then   //80% em 2018;
                           ICMSUFDest.pICMSInterPart := 80.0
                         else if StrToInt(formatdatetime('yyyy',date)) >= 2019 then  //100% a partir de 2019
                           ICMSUFDest.pICMSInterPart := 100.0;

                         ICMSUFDest.vICMSUFDest    := ArredondaValorNew(((XQueryItem.FieldByName('_vProd').asFloat - XQueryItem.FieldByName('_vDesc').asFloat) * abs(ICMSUFDest.pICMSUFDest - ICMSUFDest.pICMSInter) * 0.6 ) / 100, 2 ); //40.00
                         ICMSUFDest.vICMSUFRemet   := ArredondaValorNew(((XQueryItem.FieldByName('_vProd').asFloat - XQueryItem.FieldByName('_vDesc').asFloat) * abs(ICMSUFDest.pICMSUFDest - ICMSUFDest.pICMSInter) * 0.4 ) / 100,2); //60.0;
                         FSomaICMSUFDest           := ArredondaValorNew(FSomaICMSUFDest  + ICMSUFDest.vICMSUFDest,2);
                         FSomaICMSUFRemet          := ArredondaValorNew(FSomaICMSUFRemet + ICMSUFDest.vICMSUFRemet,2);
                         }
                       end;
                  end;
              end; //Fim do With ICMS
             end; // Fim if ZProduto_CST.value <> '' then

          if (XQueryItem.FieldByName('_IPI_pIPI').asFloat > 0) then
             with IPI do
             begin
               CST      := StrToCSTIPI(OK, '50') ;
               clEnq    := '';
               CNPJProd := Trim(XQueryNota.FieldByName('_CNPJEmit').asString);
               cSelo    := '';
               qSelo    := 0;
               cEnq     := '999';
               vBC      := XQueryItem.FieldByName('_vBCIPI').asFloat;
               qUnid    := 0.0;
               vUnid    := 0.0;
               pIPI     := XQueryItem.FieldByName('_IPI_pIPI').asFloat;
               vIPI     := XQueryItem.FieldByName('_IPI_vIPI').asFloat;
             end
          else if copy(XQueryItem.FieldByName('_CFOP').asString,1,1)='3' then
             with IPI do
             begin
               CST      := StrToCSTIPI(OK, '02') ;
               clEnq    := '';
               CNPJProd := Trim(XQueryNota.FieldByName('_CNPJEmit').asString);
               cSelo    := '';
               qSelo    := 0;
               cEnq     := '301';  ////cEnq     := '999';
             end; // Fim if (ZProduto_pIPI > 0) then

         // Caso a empresa seja optante pelo SIMPLES NACIONAL
          if XQueryNota.FieldByName('_EmpresaSimples').asInteger = 1 then
             begin
               PIS.CST       := StrToCSTPIS(OK, '99');
               PIS.qBCProd   := 0.0;
               PIS.vAliqProd := 0.0;
               PIS.vPIS      := 0.0;
               COFINS.CST       := StrToCSTCOFINS(OK,'99');
               COFINS.qBCProd   := 0.0;
               COFINS.vAliqProd := 0.0;
               COFINS.vCOFINS   := 0.0;
             end
          else
             begin
               with PIS do
               begin
                 CST :=  StrToCSTPIS(OK, IfThen(XQueryItem.FieldByName('_PIS_CST').asString <> '05' ,XQueryItem.FieldByName('_PIS_CST').asString,'99') );
                 if (CST = pis01) or (CST = pis02) then
                    begin
                      PIS.vBC  := XQueryItem.FieldByName('_PIS_vBC').asFloat;
                      PIS.pPIS := XQueryItem.FieldByName('_PIS_pPIS').asFloat;
                      PIS.vPIS := XQueryItem.FieldByName('_PIS_vPIS').asFloat;
                    end
                 else if CST = pis03 then
                    begin
                      PIS.qBCProd   := XQueryItem.FieldByName('_PIS_qBCProd').asFloat;
                      PIS.vAliqProd := XQueryItem.FieldByName('_PIS_vAliqProd').asFloat;
                      PIS.vPIS      := XQueryItem.FieldByName('_PIS_vPIS').asFloat;
                    end
                 else if CST = pis99 then         //else if CST = pis05 then
                    begin
                      PIS.vBC       := XQueryItem.FieldByName('_PIS_vBC').asFloat;
                      PIS.pPIS      := XQueryItem.FieldByName('_PIS_pPIS').asFloat;
                      PIS.vPIS      := XQueryItem.FieldByName('_PIS_vPIS').asFloat;
                      PISST.vBC     := XQueryItem.FieldByName('_PIS_vBC').asFloat;
                      PISST.pPIS    := XQueryItem.FieldByName('_PIS_pPIS').asFloat;
                      PISST.vPIS    := XQueryItem.FieldByName('_PIS_vPIS').asFloat;
{fim alteracao}     end
                 else
                    begin
                      PIS.vBC       := XQueryItem.FieldByName('_PIS_vBC').asFloat;
                      PIS.pPIS      := XQueryItem.FieldByName('_PIS_pPIS').asFloat;
                      PIS.qBCProd   := 0;
                      PIS.vAliqProd := 0;
                      PIS.vPIS      := XQueryItem.FieldByName('_PIS_vPIS').asFloat;
                    end;
               end;
// PIS ST Não informado
               with COFINS do
               begin
                 CST := StrToCSTCOFINS(OK, IfThen(XQueryItem.FieldByName('_COFINS_CST').asString <> '05' ,XQueryItem.FieldByName('_COFINS_CST').asString,'99') );
                 if (CST = cof01) or (CST = cof02)   then
                    begin
                      COFINS.vBC     := XQueryItem.FieldByName('_COFINS_vBC').asFloat;
                      COFINS.pCOFINS := XQueryItem.FieldByName('_COFINS_pCOFINS').asFloat;
                      COFINS.vCOFINS := XQueryItem.FieldByName('_COFINS_vCOFINS').asFloat;
                    end
                 else if CST = cof03 then
                    begin
                      COFINS.qBCProd   := XQueryItem.FieldByName('_COFINS_qBCProd').asFloat;
                      COFINS.vAliqProd := XQueryItem.FieldByName('_COFINS_vAliqProd').asFloat;
                      COFINS.vCOFINS   := XQueryItem.FieldByName('_COFINS_vCOFINS').asFloat;
                    end
                 else if (CST = cof99) then     //else if (CST = cof05)   then
                    begin
                      COFINS.vBC       := XQueryItem.FieldByName('_COFINS_vBC').asFloat;
                      COFINS.pCOFINS   := XQueryItem.FieldByName('_COFINS_pCOFINS').asFloat;
                      COFINS.vCOFINS   := XQueryItem.FieldByName('_COFINS_vCOFINS').asFloat;
                      COFINSST.vBC     := XQueryItem.FieldByName('_COFINS_vBC').asFloat;
                      COFINSST.pCOFINS := XQueryItem.FieldByName('_COFINS_pCOFINS').asFloat;
                      COFINSST.vCOFINS := XQueryItem.FieldByName('_COFINS_vCOFINS').asFloat;
                    end
                 else
                    begin
                      COFINS.vBC       := XQueryItem.FieldByName('_COFINS_vBC').asFloat;
                      COFINS.pCOFINS   := XQueryItem.FieldByName('_COFINS_pCOFINS').asFloat;
                      COFINS.qBCProd   := 0;
                      COFINS.vAliqProd := 0;
                      COFINS.vCOFINS   := XQueryItem.FieldByName('_COFINS_vCOFINS').asFloat;
                    end;
               end;
             end;
        end;
      end; // Fim with Imposto do
    end;
    XQueryItem.Next;
  end;
  XQueryItem.First;
  XQueryItem.EnableControls;
end;

function TProviderServicoAutorizaNFe.Min_Round(const AValue: Double;
  const ADigit: TRoundToRange): Double;
var
  LFactor: Double;
begin
  LFactor := IntPower(10, ADigit);
  Result := Trunc((AValue / LFactor) - 0.5) * LFactor;
end;

function TProviderServicoAutorizaNFe.RetornaCaixas(XCaixas: string): string;
var wret: string;
    wpos: integer;
begin
  try
    wpos := Pos('=',XCaixas);
    wret := trim(copy(XCaixas,wpos+1,50));
    if strtointdef(wret,1)>1 then
       wret := '('+wret+' Caixas)'
    else
       wret := '('+wret+' Caixa)';
  except
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.ArredondaValorNew(XValor: double; XDecimal: integer): double;
var wint,wfrac,wvalor,wvalor2,wret: variant;
    wnegativo: boolean;
begin
  wnegativo := XValor < 0;
  wint    := abs(int(XValor));
  wfrac   := abs(frac(XValor));
  case XDecimal of
    2: begin
         wvalor  := int(wfrac*100);
         wvalor2 := frac(wfrac*100)*10;
       end;
    3: begin
         wvalor  := int(wfrac*1000);
         wvalor2 := frac(wfrac*1000)*10;
       end;
  end;
  if wvalor2 >= 4.99999 then
     case XDecimal of
       2: begin
            if wvalor = 99 then
               begin
                 inc(wint);
                 wvalor := 0;
               end
            else
               inc(wvalor);
          end;
       3: begin
            if wvalor = 999 then
               begin
                 inc(wint);
                 wvalor := 0;
               end
            else
               inc(wvalor);
          end;
     end;
  case XDecimal of
    2: wvalor  := wvalor/100;
    3: wvalor  := wvalor/1000;
  end;
  wret    := wint+wvalor;
  if wnegativo then
     wret := wret * -1;
  ArredondaValorNew := wret;
end;

function TProviderServicoAutorizaNFe.AssinaNota: boolean;
var wret: boolean;
begin
  try
    ACBrNFeAPi.NotasFiscais.Assinar;
    wret := true;
  except
    On E: Exception do
    begin
      wret      := false;
      wdescerro := 'Erro ao assinar NFe'+slinebreak+E.Message;
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.ValidaNota: boolean;
var wret: boolean;
begin
  try
    ACBrNFeAPi.NotasFiscais.Validar;
    wret := true;
  except
    On E: Exception do
    begin
      wret      := false;
      wdescerro := 'Erro ao validar NFe'+slinebreak+E.Message;
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.EnviaNota(XId: integer): boolean;
var wret: boolean;
begin
  try
    ACBrNFeAPi.Enviar(XId,true,false);
    wret := true;
  except
    On E: Exception do
    begin
      wret      := false;
      wdescerro := 'Erro ao enviar NFe'+slinebreak+E.Message;
    end;
  end;
  Result := wret;
end;


function TProviderServicoAutorizaNFe.RetornaSequence(XSequence,XTipo: string): integer;
var wret: integer;
    wseq: string;
    wqueryVerifica,wqueryCria,wquerySequence: TFDQuery;
begin
//verifica existência da sequence
   wseq           := XSequence;
   wqueryVerifica := TFDQuery.Create(nil);
   wqueryCria     := TFDQuery.Create(nil);
   wquerySequence := TFDQuery.Create(nil);
   while Pos('"',wseq)>0 do
   begin
     wseq := StringReplace(wseq,'"','',[]);
   end;
   with wqueryVerifica do
   begin
     Connection := FConexao.FDConnectionApi;
     DisableControls;
     Close;
     SQL.Clear;
     Params.Clear;
     SQL.Add('Select * from pg_class where relkind=''S'' and relname =:XSequence ');
     ParamByName('XSequence').AsString := wseq;
     Open;
     EnableControls;
   end;
//cria sequence
   if wqueryVerifica.RecordCount=0 then
      with wqueryCria do
      begin
        Connection := FConexao.FDConnectionApi;
        DisableControls;
        Close;
        SQL.Clear;
        SQL.Add('create sequence "'+wseq+'" ');
        ExecSQL;
        EnableControls;
      end;

  FConexao.FDConnectionApi.StartTransaction;
  with wquerySequence do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    if XTipo='P' then // Próxima
       SQL.Add('Select nextval('+QuotedStr(XSequence)+') as UltPed')
    else
       SQL.Add('Select last_value as UltPed from '+XSequence+' ');
    Open;
    EnableControls;
    wret := wquerySequence.FieldByName('ultped').Value;
  end;
  FConexao.FDConnectionApi.Commit;

  Result := wret;
end;

procedure TProviderServicoAutorizaNFe.GravaPagamento(XQueryNota: TFDQuery; XNum: integer);
var wqueryPagamento,wquery2: TFDQuery;
    ix: integer;
    OK: boolean;
    wsoma: double;
begin
  wqueryPagamento  := TFDQuery.Create(nil);
//  wquery2 := TFDQuery(FDataSetNota);
  wsoma   := 0;
  ix      := 0;
  with wqueryPagamento do
  begin
    Connection := Fconexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select cast("FormaPagamento"."ModalidadePagamento" as varchar(4)),');
    SQL.Add('cast(ts_retornanumerariotipo("FormaPagamento"."NumerarioFormaPagamento") as varchar(20)) as TipoPagamento,');
    SQL.Add('cast("FormaPagamento"."ValorRealPagamento" as  numeric(15,2)),cast("FormaPagamento"."ValorFormaPagamento" as  numeric(15,2)),');
    SQL.Add('cast("FormaPagamento"."ValorDescontoPagamento" as  numeric(15,2)),cast("FormaPagamento"."BandeiraPagamento" as varchar(5)),');
    SQL.Add('cast("FormaPagamento"."CodigoNSUPagamento" as varchar(6)) as CodigoNSUPagamento ');
    SQL.Add('from "FormaPagamento" where "CodigoNotaFormaPagamento"=:XCodigoInternoNota ');
    ParamByName('XCodigoInternoNota').AsInteger := XQueryNota.FieldByName('_codigoInternoNota').asInteger;
    Open;
    while not EOF do
    begin
      with ACBrNFeApi.NotasFiscais.Items[0].NFe.pag.Add do //PAGAMENTOS apenas para NFC-e
      begin
        if XNum>1 then
           indPag := TpcnIndicadorPagamento.ipPrazo
        else
           indPag := TpcnIndicadorPagamento.ipVista;
        if XNum>1 then
           tPag := fpDuplicataMercantil
        else if length(trim(wqueryPagamento.FieldByName('ModalidadePagamento').asString))>0 then
           begin
             if (Pos(Copy(wqueryPagamento.FieldByName('ModalidadePagamento').asString,1,2),'01') > 0) then
                tPag := fpCartaoDebito //Debito
             else if (Pos( Copy(wqueryPagamento.FieldByName('ModalidadePagamento').asString,1,2) , '02') > 0) then
                tPag := fpCartaoCredito //Credito
             else if (Pos( Copy(wqueryPagamento.FieldByName('ModalidadePagamento').asString,1,2) , '03') > 0) then
                tPag := fpCartaoDebito //Credito
             else
                tPag := fpOutro;         // Cartao
           end
        else
           Case AnsiIndexStr(wqueryPagamento.FieldByName('tipopagamento').asString, ['Dinheiro', 'Carnê', 'Cheque','Terceiros','Cartão','Convênio','Promissória','Ticket','Outros','Enterprise(R/P)','Bloqueto','Boleto','Pix']) of
                0  : tPag := fpDinheiro;      // Dinheiro
                1  : tPag := fpCreditoLoja;   // Carne        //fpOutro
                2  : tPag := fpCheque ;       // Cheque
                3  : tPag := fpCheque;        // Terceiros
                4  : tPag := fpOutro;         // Cartao
                5  : tPag := fpOutro;         // Convenio
                6  : tPag := fpOutro;         // Promissoria
                7  : tPag := fpValeRefeicao;  // Ticket
                8  : tPag := fpOutro;         // Outros
                9  : tPag := fpOutro;         // Enterprise(R/P)
                10 : tPag := fpCreditoLoja;   // Bloqueto
                11 : tPag := fpCreditoLoja;   // Boleto
                12 : tPag := fpPagamentoInstantaneo;   // PIX
                                  (*
                                  (fpDinheiro, fpCheque, fpCartaoCredito, fpCartaoDebito, fpCreditoLoja,
                                  fpValeAlimentacao, fpValeRefeicao, fpValePresente, fpValeCombustivel,
                                  fpOutro);
                                  *)
           end;
        if tPag = fpOutro then
           xPag  := wqueryPagamento.FieldByName('tipopagamento').asString;
        vPag  := wqueryPagamento.FieldByName('ValorRealPagamento').asFloat;
        wsoma := wsoma + vPag;
        if (tPag = fpCartaoCredito) or (tPag = fpCartaoDebito) then
           begin
             tpIntegra := StrTotpIntegra(ok,'1');  //[tiNaoInformado, tiPagIntegrado, tiPagNaoIntegrado]
             CNPJ      := ''; //'88318456000145';  //É necessario incluir CNPJ
             if (not(wqueryPagamento.FieldByName('ModalidadePagamento').IsNull)) or (wqueryPagamento.FieldByName('ModalidadePagamento').asString <> '') then
                begin
                  if (Pos( Copy(wqueryPagamento.FieldByName('BandeiraPagamento').asString,4,2) , '00') > 0) then
                     tBand := StrToBandeiraCartao(ok,'99')  //bcOutros
                  else if (Pos( Copy(wqueryPagamento.FieldByName('BandeiraPagamento').asString,4,2) , '01') > 0) then
                     tBand := StrToBandeiraCartao(ok,'01')  //bcVisa
                  else if (Pos( Copy(wqueryPagamento.FieldByName('BandeiraPagamento').asString,4,2) , '02') > 0) then
                     tBand := StrToBandeiraCartao(ok,'02')  //bcMasterCard
                  else if (Pos( Copy(wqueryPagamento.FieldByName('BandeiraPagamento').asString,4,2) , '04') > 0) then
                     tBand := StrToBandeiraCartao(ok,'03')  //bcAmericanExpress
                  else if (Pos( Copy(wqueryPagamento.FieldByName('BandeiraPagamento').asString,4,2) , '15') > 0) then
                     tBand := StrToBandeiraCartao(ok,'04')  //bcSorocred
                  else if (Pos(wqueryPagamento.FieldByName('BandeiraPagamento').asString, '00000') > 0) then
                     tBand := StrToBandeiraCartao(ok,'99')  //bcOutros
                  else
                     tBand := StrToBandeiraCartao(ok,'99'); //bcOutros
                  cAut  := wqueryPagamento.FieldByName('CodigoNSUPagamento').asString;
                end;
           end
        else
           begin
             tpIntegra := StrTotpIntegra(ok,'0');
             CNPJ      := '';
           end;
        //pag.vTroco := 0.00;
        //pag.vTroco := XQueryNota.FieldByName('_totalICMS_vTroco').AsFloat;
      end;
      Next;
    end;
    if (XQueryNota.FieldByName('_finNFe').Value = 3) or (XQueryNota.FieldByName('_finNFe').Value = 4) then
       begin
         with ACBrNFeApi.NotasFiscais.Items[0].NFe.pag.Add do
         begin
           tPag := fpSemPagamento;
           vPag := 0;
         end;
       end
    else if ArredondaValorNew(FSomaDesconto,2)>0.00 then
       begin
         with ACBrNFeApi.NotasFiscais.Items[0].NFe.pag.Add do
         begin
           tPag := TpcnFormaPagamento.fpOutro;
           xPag := 'Outro';
           vPag := FSomaDesconto;
         end;
         FSomaDesconto := 0;
       end
    else if ArredondaValorNew(XQueryNota.FieldByName('_totalICMS_vNF').asFloat,2) > ArredondaValorNew(wsoma,2) then
       begin
         with ACBrNFeApi.NotasFiscais.Items[0].NFe.pag.Add do
         begin
           tPag := TpcnFormaPagamento.fpOutro;
           xPag := 'Outro';
           vPag := XQueryNota.FieldByName('_totalICMS_vNF').asFloat - wsoma;
         end;
         FSomaDesconto := 0;
       end;

//Troco
    with ACBrNFeApi.NotasFiscais.Items[0].NFe.pag do
    begin
      vTroco := 0.00;
      //vTroco := XQueryNota.FieldByName('_totalICMS_vTroco').AsFloat;
    end;
  end;
end;

procedure TProviderServicoAutorizaNFe.AnalisaRetorno(XId,XStatus: integer; XMotivo: string);
begin
  try
    case XStatus of
      100: begin // Nota autorizada
             AtualizaNumeroDocumento(XId);
             AtualizaSequence;
           end;
      105,108,109: begin // Serviço paralizado sem previsão

                   end;
      110,302: begin // Uso denegado

               end;
      217,613: begin // Nota não enviada

               end;
    else

    end;
  except
    On E: Exception do
    begin
      wdescerro := 'Problema ao analisar retorno de envio'+slinebreak+E.Message;
    end;
  end;
end;

procedure TProviderServicoAutorizaNFe.AtualizaNumeroDocumento(XId: integer);
var wqueryAtualiza: TFDQuery;
    wdocumento,wchave: string;
begin
  wqueryAtualiza := TFDQuery.Create(nil);
  wdocumento     := '5'+
                    formatfloat('00',ACBrNFeApi.NotasFiscais.Items[0].NFe.Ide.serie)+
                    formatfloat('000000',ACBrNFeApi.NotasFiscais.Items[0].NFe.Ide.nNF);
  wchave         := copy(ACBrNFeApi.NotasFiscais.Items[0].NFe.infNFe.ID,4,44);

  Fconexao.FDConnectionApi.StartTransaction;
  with wqueryAtualiza do
  begin
    Connection := Fconexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('update "NotaFiscal" set "NumeroDocumentoNota"=:xdocumento, "IdNFeNota"=:xchave ');
    SQL.Add('where "CodigoInternoNota"=:xid ');
    ParamByName('xid').AsInteger       := XId;
    ParamByName('xchave').AsString     := wchave;
    ParamByName('xdocumento').AsString := wdocumento;
    ExecSQL;
    EnableControls;
  end;
  Fconexao.FDConnectionApi.Commit;
end;

procedure TProviderServicoAutorizaNFe.AtualizaSequence;
var wqueryUltimo,wqueryAtualiza: TFDQuery;
    wsequence,wult: string;
begin
  wqueryUltimo   := TFDQuery.Create(nil);
  wqueryAtualiza := TFDQuery.Create(nil);
  wsequence      := '"UltimoDocumentoTSFature_'+ IntToStr(77222)+'_0_seq"';
  with wqueryUltimo do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select last_value as "valor" from '+wsequence+' ');
    Open;
    EnableControls;
    wult := IntToStr(FieldByName('valor').AsInteger+1);
  end;

  with wqueryAtualiza do
  begin
    Connection := Fconexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select setval('''+wsequence+''','+wult+') ');
    Open;
    EnableControls;
  end;
end;

function TProviderServicoAutorizaNFe.RetornaChaveNFe(XIdNota: integer): string;
var wret: string;
    wqueryNota: TFDQuery;
begin
  try
   wqueryNota := TFDQuery.Create(nil);
   with wqueryNota do
   begin
     Connection := Fconexao.FDConnectionApi;
     DisableControls;
     Close;
     SQL.Clear;
     Params.Clear;
     SQL.Add('select "IdNFeNota" as chave from "NotaFiscal" where "CodigoInternoNota"=:xid ');
     ParamByName('xid').AsInteger := XIdNota;
     Open;
     EnableControls;
     wret := FieldByName('chave').AsString;
   end;
  except
    On E: Exception do
    begin
      wret := '';
    end;
  end;
  Result := wret;
end;

procedure TProviderServicoAutorizaNFe.AtualizaNumeroSituacaoNota(XIdNota: integer);
var wqueryAtualiza: TFDQuery;
begin
  try
    wqueryAtualiza := TFDQuery.Create(nil);
    Fconexao.FDConnectionApi.StartTransaction;
    with wqueryAtualiza do
    begin
      Connection := Fconexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('update "NotaFiscal" set "SituacaoNota"=''A'' ');
      SQL.Add('where "CodigoInternoNota"=:xid ');
      ParamByName('xid').AsInteger := XIdNota;
      ExecSQL;
      EnableControls;
    end;
    Fconexao.FDConnectionApi.Commit;
  except
    On E: Exception do
    begin
      Fconexao.FDConnectionApi.Rollback;
    end;
  end;
end;

procedure TProviderServicoAutorizaNFe.ApagaParcelasNota(XIdNota: integer);
var wqueryApaga: TFDQuery;
begin
  try
    wqueryApaga := TFDQuery.Create(nil);
    Fconexao.FDConnectionApi.StartTransaction;
    with wqueryApaga do
    begin
      Connection := Fconexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('delete from "Parcela" ');
      SQL.Add('where "CodigoDocFiscalParcela"=:xid ');
      ParamByName('xid').AsInteger := XIdNota;
      ExecSQL;
      EnableControls;
    end;
    Fconexao.FDConnectionApi.Commit;
  except
    On E: Exception do
    begin
      Fconexao.FDConnectionApi.Rollback;
    end;
  end;
end;

function TProviderServicoAutorizaNFe.ConsultaDFeUltimoNSU(XUltNSU: string): TJSONArray;
var wret: TJSONArray;
    wobj,wnewconsultado,wultimo: TJSONObject;
    ix: integer;
    wnsu,wultnsu,wmaxnsu,wchave,wultlote,wstatus,wtpevento: string;
    wxmlsalvo,wverificachave: boolean;
begin
  try
    wret := TJSONArray.Create;

// Configura DFe
    if not ConfiguraNFe then
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description',wdescerro);
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret.AddElement(wobj);
         Result := wret;
         exit;
       end;
  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description',wdescerro);
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret.AddElement(wobj);
         Result := wret;
         exit;
       end;

// Verifca Status do WebService
    if not VerificaStatusServicoNFe then
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description',wdescerro);
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret.AddElement(wobj);
         Result := wret;
         exit;
       end;

//    showmessage('flag0');
// Inicia Serviço WebService
    if not IniciaServico then
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description',wdescerro);
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret.AddElement(wobj);
         Result := wret;
         exit;
       end;

//    showmessage('flag1');
    if strtointdef(XUltNSU,0)=0 then
       try
//         showmessage('flag0');
//         showmessage('UFCodigo: '+inttostr(ACBrNFeAPI.Configuracoes.WebServices.UFCodigo));
//         showmessage('CNPJEmitente: '+FCNPJEmitente);
         ACBrNFeAPI.DistribuicaoDFePorUltNSU(ACBrNFeAPI.Configuracoes.WebServices.UFCodigo,FCNPJEmitente,inttostr(strtointdef(XUltNSU,0)));
         with ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt do
         begin
            wultnsu  := formatfloat('0000',strtointdef(ultNSU,0));
            wmaxnsu  := formatfloat('0000',strtointdef(maxNSU,0));
            wultlote := 'Não';
            wstatus  := IntToStr(cStat);
         end;
//         wultnsu := formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.ultNSU,0));
//         wmaxnsu := formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.maxNSU,0));
  //       showmessage('status: '+wstatus+' ultnsu: '+wultnsu+' maxnsu: '+wmaxnsu);
         wobj := TJSONObject.Create;
         wobj.AddPair('TipoDistribuicao','Retorna Último NSU');
         wobj.AddPair('UltimoLote','Sim');
         wobj.AddPair('UltimoNSUDistribuicao',formatfloat('0000',strtointdef(wultnsu,0)));
         wobj.AddPair('MaximoNSUDistribuicao',formatfloat('0000',strtointdef(wmaxnsu,0)));
         wobj.AddPair('NSUDistribuicao',' ');
         wobj.AddPair('XMLDistribuicao',' ');
         wobj.AddPair('ChaveNFeDistribuicao',' ');
         wobj.AddPair('CNPJEmitenteDistribuicao',' ');
         wobj.AddPair('NomeEmitenteDistribuicao',' ');
         wobj.AddPair('ProtocoloNFeDistribuicao',' ');
         wobj.AddPair('DataEmissaoDistribuicao',' ');
         wobj.AddPair('ValorNFeDistribuicao',' ');
         wobj.AddPair('status',wstatus);
         wobj.AddPair('description','Atenção! Consulta para recuperar primeiro NSU disponível');
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret.AddElement(wobj);
         Result := wret;
         exit;
       except
         On E: Exception do
         begin
//           showmessage('Erro: '+E.Message);
         end;
       end;

// Recupera Ultimo NSU do banco de dados
    wultimo := TJSONObject.Create;
    wultimo := dat.movDFeConsultados.RetornaUltimoNSU;
    wultimo.TryGetValue('UltNSU',wultnsu);
    wultimo.TryGetValue('MaxNSU',wmaxnsu);

{    while strtointdef(wultnsu,0) < strtointdef(wmaxnsu,0) do
    begin
      ACBrNFeAPI.DistribuicaoDFePorUltNSU(ACBrNFeAPI.Configuracoes.WebServices.UFCodigo,FCNPJEmitente,inttostr(strtointdef(wultnsu,0)));
      wultnsu := ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.ultNSU;
      wmaxnsu := ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.maxNSU;
      with ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt do
      begin
        wultlote := 'Não';
        wstatus  := IntToStr(cStat);
       // Caso não retorne registros, ocorra consumo indevido ou seja o último lote, gera alerta
        if ( ( cStat = 137 ) or ( cStat = 656 ) or ( ultNSU = maxNSU ) ) then
           begin
            // 656-Consumo indevido
             if cStat = 656 then
                begin
                  wobj := TJSONObject.Create;
                  wobj.AddPair('TipoDistribuicao','Consumo Indevido');
                  wobj.AddPair('StatusDistribuicao',wstatus);
                  wobj.AddPair('UltimoLote','');
                  wobj.AddPair('UltimoNSUDistribuicao','');
                  wobj.AddPair('MaximoNSUDistribuicao','');
                  wobj.AddPair('NSUDistribuicao','');
                  wobj.AddPair('XMLDistribuicao','');
                  wobj.AddPair('ChaveNFeDistribuicao','');
                  wobj.AddPair('CNPJEmitenteDistribuicao','');
                  wobj.AddPair('NomeEmitenteDistribuicao','');
                  wobj.AddPair('ProtocoloNFeDistribuicao','');
                  wobj.AddPair('DataEmissaoDistribuicao','');
                  wobj.AddPair('ValorNFeDistribuicao','');
                  wobj.AddPair('status',wstatus);
                  wobj.AddPair('description','Atenção! Consumo indevido. Tente novamente depois de 1h');
                  wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
                  wret.AddElement(wobj);
                  Result := wret;
                  break;
                end
            // 137-Nenhum documento localizado
             else if cStat = 137 then
                begin
                  wobj := TJSONObject.Create;
                  wobj.AddPair('TipoDistribuicao','Sem Registros Disponíveis');
                  wobj.AddPair('StatusDistribuicao',wstatus);
                  wobj.AddPair('UltimoLote','');
                  wobj.AddPair('UltimoNSUDistribuicao','');
                  wobj.AddPair('MaximoNSUDistribuicao','');
                  wobj.AddPair('NSUDistribuicao','');
                  wobj.AddPair('XMLDistribuicao','');
                  wobj.AddPair('ChaveNFeDistribuicao','');
                  wobj.AddPair('CNPJEmitenteDistribuicao','');
                  wobj.AddPair('NomeEmitenteDistribuicao','');
                  wobj.AddPair('ProtocoloNFeDistribuicao','');
                  wobj.AddPair('DataEmissaoDistribuicao','');
                  wobj.AddPair('ValorNFeDistribuicao','');
                  wobj.AddPair('status',wstatus);
                  wobj.AddPair('description','Atenção! Não existem mais registros disponíveis.');
                  wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
                  wret.AddElement(wobj);
                  Result := wret;
                  break;
                end;
           end
        else
           begin
             wultlote := 'Sim';
//                 wobj := TJSONObject.Create;
 //                wobj.AddPair('status','200');
 //                wobj.AddPair('description','Atenção! Este é o último lote de registros disponíveis para distribuição.');
 //                wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
 //                wret.AddElement(wobj);
           end;
      end;
      for ix := 0 to ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count-1 do
      begin
        wnsu := formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0));
        //Evento NFe
        if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocEventoNFe then // Evento NFe
           begin
             if length(trim(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.RetinfEvento.chDFe))> 0 then // notas emitidas
                begin
//                   wwClientDataSetEmitidos.Insert;
//                   wwClientDataSetEmitidosNSU.Value         := wnsu;
//                   wwClientDataSetEmitidosChaveNFe.Value    := ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.RetinfEvento.chDFe;
//                   wwClientDataSetEmitidosCNPJDestino.Value := ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.RetinfEvento.CNPJDest;
//                   wwClientDataSetEmitidosData.AsDateTime   := ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.dhEvento;
//                   wwClientDataSetEmitidosProtocolo.Value   := ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.RetinfEvento.nProt;
//                   wwClientDataSetEmitidos.Post;
                end;
           end
        else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schresNFe then // Resumo NFe
           begin
             wchave := ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.chDFe;
             wobj := TJSONObject.Create;
             wobj.AddPair('TipoDistribuicao','Resumo NFe');
             wobj.AddPair('StatusDistribuicao',wstatus);
             wobj.AddPair('UltimoLote',wultlote);
             wobj.AddPair('UltimoNSUDistribuicao',formatfloat('0000',strtointdef(wultnsu,0)));
             wobj.AddPair('MaximoNSUDistribuicao',formatfloat('0000',strtointdef(wmaxnsu,0)));
             wobj.AddPair('NSUDistribuicao',formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0)));
             wobj.AddPair('XMLDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].XML);
             wobj.AddPair('ChaveNFeDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.chDFe);
             wobj.AddPair('CNPJEmitenteDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.CNPJCPF);
             wobj.AddPair('NomeEmitenteDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.xNome);
             wobj.AddPair('ProtocoloNFeDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.nProt);
             wobj.AddPair('DataEmissaoDistribuicao',formatdatetime('yyyymmddhhnnss',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.dhEmi));
             wobj.AddPair('ValorNFeDistribuicao',formatfloat('#,0.00',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.vNF));
             wobj.AddPair('status',wstatus);
             wobj.AddPair('description','');
             wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
             wret.AddElement(wobj);
             // Inclui registros no banco de dados
             if (not dat.movDFeConsultados.VerificaChaveNFe(wchave)) and (length(trim(wchave))>0) then
                begin
                  wnewconsultado := TJSONObject.Create;
                  wnewconsultado := dat.movDFeConsultados.IncluiConsultado(wobj);
                end;
           end
        else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocNFe then // NFe Completa
           begin
             wchave := ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.chDFe;
             wobj := TJSONObject.Create;
             wobj.AddPair('TipoDistribuicao','NFe Completa');
             wobj.AddPair('StatusDistribuicao',wstatus);
             wobj.AddPair('UltimoLote',wultlote);
             wobj.AddPair('UltimoNSUDistribuicao',formatfloat('0000',strtointdef(wultnsu,0)));
             wobj.AddPair('MaximoNSUDistribuicao',formatfloat('0000',strtointdef(wmaxnsu,0)));
             wobj.AddPair('NSUDistribuicao',formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0)));
             wobj.AddPair('XMLDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].XML);
             wobj.AddPair('ChaveNFeDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.chDFe);
             wobj.AddPair('CNPJEmitenteDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.CNPJCPF);
             wobj.AddPair('NomeEmitenteDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.xNome);
             wobj.AddPair('ProtocoloNFeDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.nProt);
             wobj.AddPair('DataEmissaoDistribuicao',formatdatetime('yyyymmddhhnnss',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.dhEmi));
             wobj.AddPair('ValorNFeDistribuicao',formatfloat('#,0.00',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.vNF));
             wobj.AddPair('status',wstatus);
             wobj.AddPair('description','');
             wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
             wret.AddElement(wobj);
             // Altera registro no banco de dados (quando chega o xml da nota)
             if (dat.movDFeConsultados.VerificaChaveNFe(wchave)) and (length(trim(wchave))>0) then
                begin
                  wxmlsalvo := VerificaXMLNota(wchave);
                  dat.movDFeConsultados.AlteraArquivoConsultado(wchave,formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0)),wxmlsalvo);
                end;
           end;
         end;
      dat.movDFeConsultados.AtualizaUltimoNSU(StrToInt(wultnsu),StrToInt(wmaxnsu));
    end;}


//    if ACBrNFeAPI.DistribuicaoDFePorUltNSU(ACBrNFeAPI.Configuracoes.WebServices.UFCodigo,FCNPJEmitente,inttostr(strtointdef(XUltNSU,0))) then

    if ACBrNFeAPI.DistribuicaoDFePorUltNSU(ACBrNFeAPI.Configuracoes.WebServices.UFCodigo,FCNPJEmitente,inttostr(strtointdef(wultnsu,0))) then
       begin
         with ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt do
         begin
            wstatus  := IntToStr(cStat);
//            showmessage(wultnsu+' '+wstatus);
            wultnsu  := formatfloat('0000',strtointdef(ultNSU,0));
            wmaxnsu  := formatfloat('0000',strtointdef(maxNSU,0));
            wultlote := 'Não';
          // Caso não retorne registros, ocorra consumo indevido ou seja o último lote, gera alerta
            if ( ( cStat = 137 ) or ( cStat = 656 ) or ( ultNSU = maxNSU ) ) then
               begin
            // 656-Consumo indevido
                 if cStat = 656 then
                    begin
                      wobj := TJSONObject.Create;
                      wobj.AddPair('TipoDistribuicao','Consumo Indevido');
                      wobj.AddPair('StatusDistribuicao',wstatus);
                      wobj.AddPair('UltimoLote',' ');
                      wobj.AddPair('UltimoNSUDistribuicao',wultnsu);
                      wobj.AddPair('MaximoNSUDistribuicao',wmaxnsu);
                      wobj.AddPair('NSUDistribuicao',' ');
                      wobj.AddPair('XMLDistribuicao',' ');
                      wobj.AddPair('ChaveNFeDistribuicao',' ');
                      wobj.AddPair('CNPJEmitenteDistribuicao',' ');
                      wobj.AddPair('NomeEmitenteDistribuicao',' ');
                      wobj.AddPair('ProtocoloNFeDistribuicao',' ');
                      wobj.AddPair('DataEmissaoDistribuicao',' ');
                      wobj.AddPair('ValorNFeDistribuicao',' ');
                      wobj.AddPair('status',wstatus);
                      wobj.AddPair('description','Atenção! Consumo indevido. Tente novamente depois de 1h');
                      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
                      wret.AddElement(wobj);
                      Result := wret;
                      exit;
                    end
            // 137-Nenhum documento localizado
                 else if cStat = 137 then
                    begin
                      wobj := TJSONObject.Create;
                      wobj.AddPair('TipoDistribuicao','Sem Registros Disponíveis');
                      wobj.AddPair('StatusDistribuicao',wstatus);
                      wobj.AddPair('UltimoLote',' ');
                      wobj.AddPair('UltimoNSUDistribuicao',wultnsu);
                      wobj.AddPair('MaximoNSUDistribuicao',wmaxnsu);
                      wobj.AddPair('NSUDistribuicao',' ');
                      wobj.AddPair('XMLDistribuicao',' ');
                      wobj.AddPair('ChaveNFeDistribuicao',' ');
                      wobj.AddPair('CNPJEmitenteDistribuicao',' ');
                      wobj.AddPair('NomeEmitenteDistribuicao',' ');
                      wobj.AddPair('ProtocoloNFeDistribuicao',' ');
                      wobj.AddPair('DataEmissaoDistribuicao',' ');
                      wobj.AddPair('ValorNFeDistribuicao',' ');
                      wobj.AddPair('status',wstatus);
                      wobj.AddPair('description','Atenção! Não existem mais registros disponíveis.');
                      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
                      wret.AddElement(wobj);
                      Result := wret;
                      exit;
                    end;
            // ultNSU = maxNSU - Documentos Localizados, mas é o último lote
               end
            else
               begin
                 wultlote := 'Sim';
               end
         end;
         for ix := 0 to ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count-1 do
         begin
           wnsu   := formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0));
//           showmessage('ix: '+inttostr(ix)+'Count: '+inttostr(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count)+' NSU: '+wnsu);
           //Evento NFe

           if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocBPe then
//              showmessage('ix: '+inttostr(ix)+'schema: schprocBPe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocCTe then
//              showmessage('ix: '+inttostr(ix)+'schema: schprocCTe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocCTeOS then
//              showmessage('ix: '+inttostr(ix)+'schema: schprocCTeOS')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocEventoBPe then
//              showmessage('ix: '+inttostr(ix)+'schema: schprocEventoBPe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocEventoCTe then
//              showmessage('ix: '+inttostr(ix)+'schema: schprocEventoCTe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocEventoMDFe then
//              showmessage('ix: '+inttostr(ix)+'schema: schprocEventoMDFe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocGTVe then
//              showmessage('ix: '+inttostr(ix)+'schema: schprocGTVe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocMDFe then
//              showmessage('ix: '+inttostr(ix)+'schema: schprocMDFe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schresBPe then
//              showmessage('ix: '+inttostr(ix)+'schema: schresBPe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schresCTe then
//              showmessage('ix: '+inttostr(ix)+'schema: schresCTe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schresEvento then
              begin
                wchave    := ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resEvento.chDFe;
                wtpevento := GetEnumName(TypeInfo(TpcnTpEvento),integer(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resEvento.tpEvento));
  //              showmessage('ix: '+inttostr(ix)+'evento: '+wtpevento+' schema: schresEvento chave: '+wchave);
              end
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schresMDFe then
//              showmessage('ix: '+inttostr(ix)+'schema: schresMDFe')
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocEventoNFe then // Evento NFe
              begin
                wtpevento := GetEnumName(TypeInfo(TpcnTpEvento),integer(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.tpEvento));
                if length(trim(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.RetinfEvento.chDFe))> 0 then // notas emitidas
                   begin
//                     showmessage('ix: '+inttostr(ix)+'evento: '+wtpevento+' Minhas Notas');
//                          wwClientDataSetEmitidos.Insert;
//                          wwClientDataSetEmitidosNSU.Value         := wnsu;
//                          wwClientDataSetEmitidosChaveNFe.Value    := ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.RetinfEvento.chDFe;
//                          wwClientDataSetEmitidosCNPJDestino.Value := ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.RetinfEvento.CNPJDest;
//                          wwClientDataSetEmitidosData.AsDateTime   := ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.dhEvento;
//                          wwClientDataSetEmitidosProtocolo.Value   := ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].procEvento.RetinfEvento.nProt;
//                          wwClientDataSetEmitidos.Post;
                   end;
              end
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schresNFe then // Resumo NFe
              begin
//                MostraMensagem('Resumo NF');
                wchave := ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.chDFe;
                wobj := TJSONObject.Create;
                wobj.AddPair('TipoDistribuicao','Resumo NFe');
                wobj.AddPair('UltimoLote',wultlote);
                wobj.AddPair('UltimoNSUDistribuicao',formatfloat('0000',strtointdef(wultnsu,0)));
                wobj.AddPair('MaximoNSUDistribuicao',formatfloat('0000',strtointdef(wmaxnsu,0)));
                wobj.AddPair('NSUDistribuicao',formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0)));
                wobj.AddPair('XMLDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].XML);
                wobj.AddPair('ChaveNFeDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.chDFe);
                wobj.AddPair('CNPJEmitenteDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.CNPJCPF);
                wobj.AddPair('NomeEmitenteDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.xNome);
                wobj.AddPair('ProtocoloNFeDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.nProt);
                wobj.AddPair('DataEmissaoDistribuicao',formatdatetime('dd/mm/yyyy',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.dhEmi));
                wobj.AddPair('ValorNFeDistribuicao',formatfloat('#,0.00',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.vNF));
                wobj.AddPair('status',wstatus);
                wobj.AddPair('description',' ');
                wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
                wret.AddElement(wobj);
//                MostraMensagem('Resumo NF - Verifica Chave');
//                showmessage('verifica chave '+wchave);
                wverificachave := VerificaChaveNFe(wchave);
//                if wverificachave then
//                   showmessage('chave encontrada');
                if length(trim(wchave))>0 then
                   begin
                     wnewconsultado := TJSONObject.Create;
//                     showmessage('inclui novo registro');
                     if not(wverificachave) then
                        wnewconsultado := dat.movDFeConsultados.IncluiConsultado(wobj,'1')
                     else
                        dat.movDFeConsultados.AlteraArquivoConsultado(wchave,formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0)),'2',true);
//                     showmessage('novo registro incluido');
                   end;
              end
           else if ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip[ix].schema = TSchemaDFe.schprocNFe then // NFe Completa
              begin
//                showmessage('ix: '+inttostr(ix)+' NFe Completa');
//                MostraMensagem('NF Completa');
                wchave := ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.chDFe;
//                MostraMensagem('NF Completa - Chave: '+wchave);
                wobj := TJSONObject.Create;
                wobj.AddPair('TipoDistribuicao','NFe Completa');
                wobj.AddPair('UltimoLote',wultlote);
                wobj.AddPair('UltimoNSUDistribuicao',formatfloat('0000',strtointdef(wultnsu,0)));
                wobj.AddPair('MaximoNSUDistribuicao',formatfloat('0000',strtointdef(wmaxnsu,0)));
                wobj.AddPair('NSUDistribuicao',formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0)));
                wobj.AddPair('XMLDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].XML);
                wobj.AddPair('ChaveNFeDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.chDFe);
                wobj.AddPair('CNPJEmitenteDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.CNPJCPF);
                wobj.AddPair('NomeEmitenteDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.xNome);
                wobj.AddPair('ProtocoloNFeDistribuicao',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.nProt);
                wobj.AddPair('DataEmissaoDistribuicao',formatdatetime('dd/mm/yyyy',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.dhEmi));
                wobj.AddPair('ValorNFeDistribuicao',formatfloat('#,0.00',ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].resDFe.vNF));
                wobj.AddPair('status',wstatus);
                wobj.AddPair('description',' ');
                wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
                wret.AddElement(wobj);
  //              MostraMensagem('NF Completa - Verifica Chave');
                wverificachave := VerificaChaveNFe(wchave);
                if (length(trim(wchave))>0) and (wverificachave) then
                   begin
//                     showmessage('verifica xml');
//                     MostraMensagem('NF Completa - Verifica XML');
                     wxmlsalvo := VerificaXMLNota(wchave);
//                     MostraMensagem('NF Completa - Altera Registro');
//                     showmessage('altera registro');
                     dat.movDFeConsultados.AlteraArquivoConsultado(wchave,formatfloat('0000',strtointdef(ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[ix].NSU,0)),'2',wxmlsalvo);
//                     showmessage('registro alterado');
                   end
                else if (length(trim(wchave))>0) and (not(wverificachave)) then
                   begin
                     wnewconsultado := TJSONObject.Create;
//                     showmessage('inclui novo registro');
                     wnewconsultado := dat.movDFeConsultados.IncluiConsultado(wobj,'2');
//                     showmessage('novo registro incluido');
                   end;
              end;
         end;
         // Atualiza Numero do Ultimo NSU
//         MostraMensagem('Atualiza NSU');
         AtualizaListaXML;
         dat.movDFeConsultados.AtualizaUltimoNSU(StrToInt(wultnsu),StrToInt(wmaxnsu));
       end;
  except
    On E: Exception do
    begin
      with ACBrNFeAPI.WebServices.DistribuicaoDFe.retDistDFeInt do
      begin
        wultnsu  := formatfloat('0000',strtointdef(ultNSU,0));
        wmaxnsu  := formatfloat('0000',strtointdef(maxNSU,0));
        wultlote := 'Não';
        wstatus  := IntToStr(cStat);
      end;
      dat.movDFeConsultados.AtualizaUltimoNSU(StrToInt(wultnsu),StrToInt(wmaxnsu));
//      showmessage('erro');
//      wconexao.EncerraConexaoDB;
      wobj := TJSONObject.Create;
      wobj.AddPair('TipoDistribuicao','Erro');
      wobj.AddPair('StatusDistribuicao','500');
      wobj.AddPair('UltimoLote',' ');
      wobj.AddPair('UltimoNSUDistribuicao',wultnsu);
      wobj.AddPair('MaximoNSUDistribuicao',wmaxnsu);
      wobj.AddPair('NSUDistribuicao',' ');
      wobj.AddPair('XMLDistribuicao',' ');
      wobj.AddPair('ChaveNFeDistribuicao',' ');
      wobj.AddPair('CNPJEmitenteDistribuicao',' ');
      wobj.AddPair('NomeEmitenteDistribuicao',' ');
      wobj.AddPair('ProtocoloNFeDistribuicao',' ');
      wobj.AddPair('DataEmissaoDistribuicao',' ');
      wobj.AddPair('ValorNFeDistribuicao',' ');
      wobj.AddPair('status','500');
      wobj.AddPair('description',E.Message);
      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      wret.AddElement(wobj);
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.DarCienciaDFe(XChave: string): TJSONObject;
var wret: TJSONObject;
    wstatus: integer;
    wmotivo: string;
begin
  try
    wret := TJSONObject.Create;
// Configura DFe
    if not ConfiguraNFe then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

// Verifca Status do WebService
    if not VerificaStatusServicoNFe then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
        Result := wret;
        exit;
       end;

// Inicia Serviço WebService
    if not IniciaServico then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
        Result := wret;
        exit;
       end;

// Consulta Chave
{    ACBrNFeAPI.WebServices.Consulta.NFeChave := XChave;
    if not ACBrNFeAPI.WebServices.Consulta.Executar then
       begin
         wstatus := ACBrNFeAPI.WebServices.Consulta.cStat;
         wmotivo := ACBrNFeAPI.WebServices.Consulta.XMotivo;
         wret.AddPair('status','500');
         wret.AddPair('description','Não foi possível consultar nfe '+slinebreak+'Status: '+inttostr(wstatus)+slinebreak+'Motivo: '+wmotivo);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;}
    ACBrNFeAPI.EventoNFe.Evento.Clear;
    with ACBrNFeAPI.EventoNFe.Evento.Add do
    begin
       InfEvento.cOrgao   := 91;
       infEvento.chNFe    := XChave;
//       InfEvento.chNFe    := ACBrNFeAPI.WebServices.Consulta.NFeChave;
       infEvento.CNPJ     := FCNPJEmitente;
       infEvento.dhEvento := now;
       infEvento.tpEvento := teManifDestCiencia;

{       InfEvento.chNFe           := ACBrNFeAPI.WebServices.Consulta.NFeChave;
       InfEvento.CNPJ            := FCNPJEmitente;
       InfEvento.dhEvento        := ACBrNFeAPI.WebServices.Consulta.DhRecbto;
       InfEvento.tpEvento        := teCancelamento;
       InfEvento.detEvento.xJust := XJustificativa;
       InfEvento.detEvento.nProt := ACBrNFeAPI.WebServices.Consulta.Protocolo;}
    end;
    ACBrNFeAPI.EnviarEvento(1);
    wstatus := ACBrNFeAPI.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat;

    case wstatus of
      135: begin
             wret.AddPair('status','200');
             wret.AddPair('description','Evento executado com sucesso');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
             AtualizaStatus(XChave,'2');
           end;
      650: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível dar ciência do documento.'+slinebreak+'Documento cancelado pelo emitente');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
             AtualizaStatus(XChave,'4');
           end;
      573: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível dar ciência do documento.'+slinebreak+'Já foi dado ciência deste documento');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
             AtualizaStatus(XChave,'2');
           end;
      575: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível dar ciência do documento.'+slinebreak+'Autor do evento diverge do destinatário da nota');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      596: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível dar ciência do documento.'+slinebreak+'Evento apresentado fora do prazo');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
             AtualizaStatus(XChave,'0');
           end;
      655: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível dar ciência do documento.'+slinebreak+'Documento já manifestado');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
             AtualizaStatus(XChave,'3');
           end;
    else
      begin
        wret.AddPair('status','500');
        wret.AddPair('description','Não foi possível dar ciência do documento.'+slinebreak+'Status: '+inttostr(wstatus));
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end;
    end;
  except
    On E: Exception do
    begin
       wret.AddPair('status','500');
       wret.AddPair('description','Não foi possível dar ciência do documento.'+slinebreak+E.Message);
       wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

procedure TProviderServicoAutorizaNFe.AtualizaStatus(XChave,XStatus: string);
var wquery: TFDMemTable;
    wqueryUpdate: TFDQuery;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryUpdate := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryUpdate do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('update "DistribuicaoDocumentoFiscal" set "StatusDistribuicao"=:xstatus ');
           SQL.Add('where "CodigoEmpresaDistribuicao"=:xidempresa and "ChaveNFeDistribuicao"=:xchave and "StatusDistribuicao"=''1'' ');
           ParamByName('xchave').AsString      := XChave;
           ParamByName('xstatus').AsString     := XStatus;
           ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
           ExecSQL;
           EnableControls;
         end;
       end;
  finally
    wconexao.EncerraConexaoDB;
  end;
end;

function TProviderServicoAutorizaNFe.ConfirmaOperacao(XChave: string): TJSONObject;
var wret: TJSONObject;
    wstatus: integer;
    wmotivo: string;
begin
  try
    wret := TJSONObject.Create;
// Configura DFe
    if not ConfiguraNFe then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

// Verifca Status do WebService
    if not VerificaStatusServicoNFe then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
        Result := wret;
        exit;
       end;

// Inicia Serviço WebService
    if not IniciaServico then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
        Result := wret;
        exit;
       end;

// Consulta Chave
{    ACBrNFeAPI.WebServices.Consulta.NFeChave := XChave;
    if not ACBrNFeAPI.WebServices.Consulta.Executar then
       begin
         wstatus := ACBrNFeAPI.WebServices.Consulta.cStat;
         wmotivo := ACBrNFeAPI.WebServices.Consulta.XMotivo;
         wret.AddPair('status','500');
         wret.AddPair('description','Não foi possível consultar nfe '+slinebreak+'Status: '+inttostr(wstatus)+slinebreak+'Motivo: '+wmotivo);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;}
    ACBrNFeAPI.EventoNFe.Evento.Clear;
    with ACBrNFeAPI.EventoNFe.Evento.Add do
    begin
       InfEvento.cOrgao   := 91;
       infEvento.chNFe    := XChave;
       infEvento.CNPJ     := FCNPJEmitente;
       infEvento.dhEvento := now;
       infEvento.tpEvento := teManifDestConfirmacao;
    end;
    ACBrNFeAPI.EnviarEvento(1);
    wstatus := ACBrNFeAPI.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat;

    case wstatus of
      135: begin
             wret.AddPair('status','200');
             wret.AddPair('description','Evento executado com sucesso');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      650: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível confirmar operação.'+slinebreak+'Documento cancelado pelo emitente');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      573: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível confirmar operação.'+slinebreak+'Já foi confirmada operação deste documento');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      575: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível confirmar operação.'+slinebreak+'Autor do evento diverge do destinatário da nota');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      596: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível confirmar operação.'+slinebreak+'Evento apresentado fora do prazo');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      655: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível confirmar operação.'+slinebreak+'Documento já manifestado');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
    else
      begin
        wret.AddPair('status','500');
        wret.AddPair('description','Não foi possível confirmar operação.'+slinebreak+'Status: '+inttostr(wstatus));
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end;
    end;
  except
    On E: Exception do
    begin
       wret.AddPair('status','500');
       wret.AddPair('description','Não foi possível confirmar operação.'+slinebreak+E.Message);
       wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.DesconheceOperacao(XChave: string): TJSONObject;
var wret: TJSONObject;
    wstatus: integer;
    wmotivo: string;
begin
  try
    wret := TJSONObject.Create;
// Configura DFe
    if not ConfiguraNFe then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

// Verifca Status do WebService
    if not VerificaStatusServicoNFe then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
        Result := wret;
        exit;
       end;

// Inicia Serviço WebService
    if not IniciaServico then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
        Result := wret;
        exit;
       end;

// Consulta Chave
{    ACBrNFeAPI.WebServices.Consulta.NFeChave := XChave;
    if not ACBrNFeAPI.WebServices.Consulta.Executar then
       begin
         wstatus := ACBrNFeAPI.WebServices.Consulta.cStat;
         wmotivo := ACBrNFeAPI.WebServices.Consulta.XMotivo;
         wret.AddPair('status','500');
         wret.AddPair('description','Não foi possível consultar nfe '+slinebreak+'Status: '+inttostr(wstatus)+slinebreak+'Motivo: '+wmotivo);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;}
    ACBrNFeAPI.EventoNFe.Evento.Clear;
    with ACBrNFeAPI.EventoNFe.Evento.Add do
    begin
       InfEvento.cOrgao   := 91;
       infEvento.chNFe    := XChave;
       infEvento.CNPJ     := FCNPJEmitente;
       infEvento.dhEvento := now;
       infEvento.tpEvento := teManifDestDesconhecimento;
    end;
    ACBrNFeAPI.EnviarEvento(1);
    wstatus := ACBrNFeAPI.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat;

    case wstatus of
      135: begin
             wret.AddPair('status','200');
             wret.AddPair('description','Evento executado com sucesso');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      650: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível desconhecer operação.'+slinebreak+'Documento cancelado pelo emitente');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      573: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível desconhecer operação.'+slinebreak+'Operação já foi desconhecida');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      575: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível desconhecer operação.'+slinebreak+'Autor do evento diverge do destinatário da nota');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      596: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível desconhecer operação.'+slinebreak+'Evento apresentado fora do prazo');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      655: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível desconhecer operação.'+slinebreak+'Documento já manifestado');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
    else
      begin
        wret.AddPair('status','500');
        wret.AddPair('description','Não foi possível desconhecer operação.'+slinebreak+'Status: '+inttostr(wstatus));
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end;
    end;
  except
    On E: Exception do
    begin
       wret.AddPair('status','500');
       wret.AddPair('description','Não foi possível desconhecer operação.'+slinebreak+E.Message);
       wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.OperacaoNaoRealizada(XChave: string): TJSONObject;
var wret: TJSONObject;
    wstatus: integer;
    wmotivo: string;
begin
  try
    wret := TJSONObject.Create;
// Configura DFe
    if not ConfiguraNFe then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         wret.AddPair('status','500');
         wret.AddPair('description',wdescerro);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;

// Verifca Status do WebService
    if not VerificaStatusServicoNFe then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
        Result := wret;
        exit;
       end;

// Inicia Serviço WebService
    if not IniciaServico then
       begin
        wret.AddPair('status','500');
        wret.AddPair('description',wdescerro);
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
        Result := wret;
        exit;
       end;

// Consulta Chave
{    ACBrNFeAPI.WebServices.Consulta.NFeChave := XChave;
    if not ACBrNFeAPI.WebServices.Consulta.Executar then
       begin
         wstatus := ACBrNFeAPI.WebServices.Consulta.cStat;
         wmotivo := ACBrNFeAPI.WebServices.Consulta.XMotivo;
         wret.AddPair('status','500');
         wret.AddPair('description','Não foi possível consultar nfe '+slinebreak+'Status: '+inttostr(wstatus)+slinebreak+'Motivo: '+wmotivo);
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := wret;
         exit;
       end;}
    ACBrNFeAPI.EventoNFe.Evento.Clear;
    with ACBrNFeAPI.EventoNFe.Evento.Add do
    begin
       InfEvento.cOrgao   := 91;
       infEvento.chNFe    := XChave;
       infEvento.CNPJ     := FCNPJEmitente;
       infEvento.dhEvento := now;
       infEvento.tpEvento := teManifDestOperNaoRealizada;
    end;
    ACBrNFeAPI.EnviarEvento(1);
    wstatus := ACBrNFeAPI.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat;

    case wstatus of
      135: begin
             wret.AddPair('status','200');
             wret.AddPair('description','Evento executado com sucesso');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      650: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível negar operação.'+slinebreak+'Documento cancelado pelo emitente');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      573: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível negar operação.'+slinebreak+'Operação já foi negada');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      575: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível negar operação.'+slinebreak+'Autor do evento diverge do destinatário da nota');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      596: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível negar operação.'+slinebreak+'Evento apresentado fora do prazo');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
      655: begin
             wret.AddPair('status','500');
             wret.AddPair('description','Não foi possível negar operação.'+slinebreak+'Documento já manifestado');
             wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
           end;
    else
      begin
        wret.AddPair('status','500');
        wret.AddPair('description','Não foi possível negar operação.'+slinebreak+'Status: '+inttostr(wstatus));
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end;
    end;
  except
    On E: Exception do
    begin
       wret.AddPair('status','500');
       wret.AddPair('description','Não foi possível negar operação.'+slinebreak+E.Message);
       wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;

function TProviderServicoAutorizaNFe.VerificaXMLNota(XChave: string): boolean;
var wret: boolean;
    warquivo: string;
begin
  try
    warquivo := ACBrNFeAPI.Configuracoes.Arquivos.DownloadDFe.PathDownload+'\'+XChave+'-nfe.xml';
    wret := FileExists(warquivo);
  except
    On E: Exception do
    begin
      wret := false;
    end;
  end;
  Result := wret;
end;

procedure TProviderServicoAutorizaNFe.MostraMensagem(XMensagem: string);
begin
  THorse.Listen(9000, procedure (Horse: THorse)
   begin
     writeln(XMensagem);
   end
   );
end;

procedure TProviderServicoAutorizaNFe.AtualizaListaXML;
var achou: boolean;
    warquivo,wator,wlistax: string;
    procura: TSearchRec;
    wquery,wquery2: TFDQuery;
    wlista,wlista2: TStringList;
    ix: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao := TProviderDataModuleConexao.Create(nil);
    wlista   := TStringList.Create;
    wlista2  := TStringList.Create;
    wlistax  := '';
    warquivo := ACBrNFeAPI.Configuracoes.Arquivos.DownloadDFe.PathDownload+'\*-nfe.xml';
    achou    := FindFirst(warquivo,faArchive,procura) = 0;
    wquery   := TFDQuery.Create(nil);
    wquery2  := TFDQuery.Create(nil);
    wconexao.FDConnectionApi.StartTransaction;
    while achou do
    begin
      ACBrNFeAPI2.NotasFiscais.LoadFromFile(ACBrNFeAPI.Configuracoes.Arquivos.DownloadDFe.PathDownload+'\'+Procura.Name);
      if ACBrNFeAPI2.NotasFiscais.Items[0].NFe.Transp.Transporta.CNPJCPF=FCNPJEmitente then
         begin
           wator := 'Transportador';
           wlista2.Add(Procura.Name);
         end
      else
         wator := ifthen(ACBrNFeAPI2.NotasFiscais.Items[0].NFe.Dest.CNPJCPF=FCNPJEmitente,'Destinatário','Interessado');
      with wquery do
      begin
        Connection := wconexao.FDConnectionApi;
        DisableControls;
        Close;
        SQL.Clear;
        Params.Clear;
        SQL.Add('update "DistribuicaoDocumentoFiscal" set "ArquivoSalvoDistribuicao"=true, "AtorDistribuicao"=:xator ');
        SQL.Add('where "ChaveNFeDistribuicao"=:xchave ');
        ParambyName('xchave').AsString := copy(Procura.Name,1,44);
        ParambyName('xator').AsString  := wator;
        ExecSQL;
      end;
// verifica nfe já importada
      with wquery2 do
      begin
        Connection := wconexao.FDConnectionApi;
        DisableControls;
        Close;
        SQL.Clear;
        Params.Clear;
        SQL.Add('select coalesce(count(*),0) as cta from "NotaFiscal" ');
        SQL.Add('where "ChaveAcessoNFeNota"=:xchave ');
        ParambyName('xchave').AsString := copy(Procura.Name,1,44);
        Open;
        EnableControls;
        if wquery2.FieldByName('cta').AsInteger > 0 then
           wlista.Add(Procura.Name);
      end;
      Achou := (FindNext(Procura)=0);
    end;
    wconexao.FDConnectionApi.Commit;

    if wlista.Count>0 then
       begin
         wlista.SaveToFile(ACBrNFeAPI.Configuracoes.Arquivos.PathInu+'\ListaXMLJaImportado_'+formatdatetime('ddmmyyhhnn',now)+'.txt');
         for ix:=0 to wlista.Count-1 do
         begin
           wlistax  := wlistax+wlista.Strings[ix]+','+slinebreak;
           warquivo := ACBrNFeAPI.Configuracoes.Arquivos.DownloadDFe.PathDownload+'\'+wlista.Strings[ix];
           if FileExists(warquivo) then
              DeleteFile(warquivo);
         end;
//         messagedlg('Atenção! Sistema identificou xml(s) já importado(s): '+slinebreak+wlistax,mtinformation,[mbok],0);
       end;
// exclui xml de ator = transportador
    if wlista2.Count>0 then
       begin
         wlista.SaveToFile(ACBrNFeAPI.Configuracoes.Arquivos.PathInu+'\ListaXMLTransporte_'+formatdatetime('ddmmyyhhnn',now)+'.txt');
         for ix:=0 to wlista2.Count-1 do
         begin
           warquivo := ACBrNFeAPI.Configuracoes.Arquivos.DownloadDFe.PathDownload+'\'+wlista2.Strings[ix];
           if FileExists(warquivo) then
              DeleteFile(warquivo);
         end;
//         messagedlg('Atenção! Sistema identificou xml(s) de transporte(s): '+slinebreak+wlistax,mtinformation,[mbok],0);
       end;
  except
    On E: Exception do
    begin
      wconexao.FDConnectionApi.Rollback;
//      messagedlg('Problema ao atualizar lista de xml',mterror,[mbok],0);
    end;
  end;
end;
end.
