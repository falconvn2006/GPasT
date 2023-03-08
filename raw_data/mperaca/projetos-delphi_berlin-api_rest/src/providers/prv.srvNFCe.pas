unit prv.srvNFCe;

interface

uses
  System.SysUtils, System.Classes, ACBrBase, ACBrDFe, ACBrDFeSSL, ACBrNFe, IniFiles, VCL.Dialogs, System.JSON,
  pcnConversao, pcnConversaoNFe, ACBrDFeConfiguracoes ;


type
  TProviderServicoNFCe = class(TDataModule)
    ACBrNFeAPI: TACBrNFe;
    procedure DataModuleCreate(Sender: TObject);
  private
    function CarregaArquivoIni: boolean;
    function VerificaCertificadoDigital: boolean;
    function RetornaSSLLib(XSSLLib: string): TSSLLib;
    function VerificaStatusServicoNFCe: boolean;
    { Private declarations }
  public
    FIni : TIniFile;
    FAdicionarLiteral,FEmissaoPathNFe,FSalvarArquivos,FSalvarApenasNFeProcessadas,FSalvarEvento,FSepararPorCNPJ,FSepararPorMes,FSepararPorModelo,FIncluirRefProd,FUsaEANImpressao: boolean;
    FAjustaAguardaConsultaRet,FVisualizar,FVerificarValidade,FValidarDigest,FNaoEnviaNomeFantasia,FNaoEnviaCodigoBarra,FConsumidorFinal,FAutXMLAcess,FIncluirObsProd: boolean;
    FIniServicos,FCaminhoArquivoXML,FPathSchemas,FUF,FQuebradeLinha,FSSLType,FNumeroSerie,FSenha,FCaminhoCertificado,FCSRT,FCnpjAutXMLAcess: string;
    FCNPJRT,FXContatoRT,FEmailRT,FFoneRT,FCSC,FFormatoAlerta,FIdCSC,FCNPJEmitente,FSSLCryptLib,FSSLHttpLib,FSSLLib,FSSLXmlSignLib: string;
    FAtualizarXMLCancelado,FExibirErroSchema,FIncluirQRCodeXMLNFCe,FQRCodeLateral,FICMSEfetivo,FRetirarAcentos,FSalvarGeral,FCnpjAutSomenteVeiculo,FIncluirCxsProd,FIncluirLocProd: boolean;
    FAguardarConsultaRet, FIntervaloTentativas, FTentativas, FTimeOut,FidCSRT,FClienteConsumidor,FNumCaracLoc: integer;
    FAmbiente: TpcnTipoAmbiente;
    FFormaEmissao: TpcnTipoEmissao;
    FModeloDF: TpcnModeloDF;
    FVersaoDF: TpcnVersaoDF;
    FRetorno: TJSONObject;
//    FVersaoQrCode: TpcnVersaoQrCode;
    function ConfiguraNFCe: boolean;
    function CriaNFCe(XId: integer): TJSONObject;
    { Public declarations }
  end;

var
  ProviderServicoNFCe: TProviderServicoNFCe;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDataModule1 }

function TProviderServicoNFCe.CarregaArquivoIni: boolean;
var wret: boolean;
begin
  try
    if not FileExists(GetCurrentDir+'\Autorizador.ini') then
       begin
         FRetorno.AddPair('status','500');
         FRetorno.AddPair('description','Arquivo Autorizador.ini não localizado');
         FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := false;
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
    FSSLLib                   := FIni.ReadString('Geral','SSLLib','');
    FSSLXmlSignLib            := FIni.ReadString('Geral','SSLXmlSignLib','');
    FQRCodeLateral            := uppercase(FIni.ReadString('Geral','QrCodeLateral','Não'))='SIM';
    FICMSEfetivo              := uppercase(FIni.ReadString('Geral','ICMSEfetivo','Não'))='SIM';
//    FModeloDF                 := moNFe;
    FRetirarAcentos           := uppercase(FIni.ReadString('Geral','RetirarAcentos','Sim'))='SIM';
    FSalvarGeral              := uppercase(FIni.ReadString('Geral','Salvar','Sim'))='SIM';
//    FSSLLib                   := libCapicom;
    FValidarDigest            := uppercase(FIni.ReadString('Geral','ValidarDigest','Sim'))='SIM';
    if uppercase(FIni.ReadString('Geral','Versao','ve310'))='VE310' then
       FVersaoDF              := ve310
    else if uppercase(FIni.ReadString('Geral','Versao','ve310'))='VE400' then
       FVersaoDF              := ve400;
{    if uppercase(FIni.ReadString('Geral','VersaoQrCode','veqr100'))='VEQR100' then
       FVersaoQrCode          := TpcnVersaoQrCode.veqr100
    else if uppercase(FIni.ReadString('Geral','VersaoQrCode','veqr100'))='VEQR200' then
       FVersaoQrCode          := TpcnVersaoQrCode.veqr200;}
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
      FRetorno.AddPair('status','500');
      FRetorno.AddPair('description','Problema ao carregar arquivo Autorizador.Ini'+slinebreak+E.Message);
      FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      wret := false;
    end;
  end;
  Result := wret;
end;

function TProviderServicoNFCe.ConfiguraNFCe: boolean;
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
      PathEvento                  := FCaminhoArquivoXML+'\'+formatdatetime('yyyy',now)+'\'+formatdatetime('mmmm',now);
      PathInu                     := FCaminhoArquivoXML+'\'+formatdatetime('yyyy',now)+'\'+formatdatetime('mmmm',now);
      PathNFe                     := FCaminhoArquivoXML+'\'+formatdatetime('yyyy',now)+'\'+formatdatetime('mmmm',now);
      PathSalvar                  := FCaminhoArquivoXML+'\'+formatdatetime('yyyy',now)+'\'+formatdatetime('mmmm',now);
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
//   FACBrNFe.Configuracoes.Geral.SSLLib                         := FSSLLib;
      ValidarDigest                  := FValidarDigest;
      VersaoDF                       := FVersaoDF;
//      VersaoQRCode                   := FVersaoQrCode;
//      CamposFatObrigatorios          := true;

{      if FSSLCryptLib<>'' then
         SSLCryptLib                 := RetornaSSLCryptLib(FSSLCryptLib)
      else
         SSLCryptLib                 := TSSLCryptLib(2);     // TSSLCryptLib(cbCryptLib.ItemIndex);

      if FSSLHttpLib<>'' then
         SSLHttpLib                  := RetornaSSLHttpLib(FSSLHttpLib)
      else
         SSLHttpLib                  := TSSLHttpLib(1);      // TSSLHttpLib(cbHttpLib.ItemIndex);}
      if FSSLLib<>'' then
         SSLLib                      := RetornaSSLLib(FSSLLib)
      else
         SSLLib                      := TSSLLib(2);          // TSSLLib(cbSSLLib.ItemIndex);
{      if FSSLXmlSignLib<>'' then
         SSLXmlSignLib               := RetornaSSLXmlSignLib(FSSLXmlSignLib)
      else
         SSLXmlSignLib               := TSSLXmlSignLib(3);   // TSSLXmlSignLib(cbXmlSignLib.ItemIndex);}
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
{      if FSSLType<>'' then
         begin
          FACBrNFe.Configuracoes.WebServices.SSLType             := RetornaSSLType(FSSLType);
          FACBrNFe.SSL.SSLType                                   := RetornaSSLType(FSSLType);
        end
     else
        begin
          FACBrNFe.Configuracoes.WebServices.SSLType             := TSSLType(0);
          FACBrNFe.SSL.SSLType                                   := TSSLType(0);
        end;}
    end;

// Configura Responsável Técnico
{    with ACBrNFeAPI.Configuracoes.RespTec do
    begin
      CSRT                         := FCSRT;
      IdCSRT                       := FidCSRT;
    end;}

    wret := true;
  except
    On E: Exception do
    begin
      FRetorno.AddPair('status','500');
      FRetorno.AddPair('description','Problema ao configurar NFCe'+slinebreak+E.Message);
      FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      wret := false;
    end;
  end;
  Result := wret;
end;

function TProviderServicoNFCe.CriaNFCe(XId: integer): TJSONObject;
begin
  try
// Configura NFCe
    if not ConfiguraNFCe then
       begin
         FRetorno.AddPair('status','500');
         FRetorno.AddPair('description','Configuração da NFCe não realizada');
         FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := FRetorno;
         exit;
       end;
  // verifica Certificado Digital
    if not VerificaCertificadoDigital then
       begin
         FRetorno.AddPair('status','500');
         FRetorno.AddPair('description','Problema ao carregar certificado digital');
         FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Result := FRetorno;
         exit;
       end;

    if not VerificaStatusServicoNFCe then
       begin
{         FRetorno.AddPair('status','500');
         FRetorno.AddPair('description','Problema ao consultar status de serviço NFCe');
         FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));}
         Result := FRetorno;
         exit;
       end;

    FRetorno.AddPair('status','200');
    FRetorno.AddPair('description','NFCe autorizada com sucesso');
    FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
  except
    On E: Exception do
    begin
      FRetorno.AddPair('status','500');
      FRetorno.AddPair('description','Problema ao criar NFCe'+slinebreak+E.Message);
      FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := FRetorno;
end;

procedure TProviderServicoNFCe.DataModuleCreate(Sender: TObject);
begin
  FRetorno := TJSONObject.Create;
end;

function TProviderServicoNFCe.VerificaCertificadoDigital: boolean;
var wret: boolean;
begin
  try
    wret    := ACBrNFeAPI.Configuracoes.Certificados.NumeroSerie = ACBrNFeAPI.SSL.NumeroSerie;
  except
    wret := false;
  end;
  Result := wret;
end;

function TProviderServicoNFCe.RetornaSSLLib(XSSLLib: string): TSSLLib;
var wret: TSSLLib;
begin
  try
    if lowercase(XSSLLib)='libcapicom' then
       wret := TSSLLib.libCapicom
    else if lowercase(XSSLLib)='libcapicomdelphisoap' then
       wret := TSSLLib.libCapicomDelphiSoap
//    else if lowercase(XSSLLib)='libcustom' then
//       wret := TSSLLib.libCustom
    else if lowercase(XSSLLib)='libnone' then
       wret := TSSLLib.libNone
    else if lowercase(XSSLLib)='libopenssl' then
       wret := TSSLLib.libOpenSSL
//    else if lowercase(XSSLLib)='libwincrypt' then
//       wret := TSSLLib.libWinCrypt
    else
       wret := TSSLLib.libOpenSSL;
  except
  end;
  Result := wret;
end;

function TProviderServicoNFCe.VerificaStatusServicoNFCe: boolean;
var wret: boolean;
begin
  try
    wret := ACBrNFeAPI.WebServices.StatusServico.Executar;
  except
    On E: Exception do
    begin
      wret := false;
      FRetorno.AddPair('status','500');
      FRetorno.AddPair('description','Erro ao consultar status de serviço NFCe'+slinebreak+E.Message);
      FRetorno.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
  Result := wret;
end;
end.
