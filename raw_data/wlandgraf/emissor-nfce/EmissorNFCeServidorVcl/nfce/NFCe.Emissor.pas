unit NFCe.Emissor;

{$I EmissorNFCeServidorVcl.inc}

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Math,

  ACBrNFe,
  ACBrDFeSSL,
  ACBrNFeWebServices,
  ACBrDFeConfiguracoes,
  ACBrNFeConfiguracoes,
  ACBrNFeNotasFiscais,
  ACBrLibXml2,
  ACBrUtil.Strings,

  ACBrDFeReport,
  ACBrDFeDANFeReport,
  ACBrNFeDANFEClass,

  {$IFDEF NUVEM_FASTREPORT}
    ACBrNFeDANFEFR,
  {$ENDIF}
  {$IFDEF NUVEM_FORTESREPORT}
    ACBrDANFCeFortesFr,
  {$ENDIF}

  pcnConversao,
  pcnConversaoNFe,
  pcnEnvEventoNFe,
  pcnRetEnvEventoNFe,
  pcnEventoNFe,
  pcnRetConsSitNFe,
  blcksock,
  pcnNFe,

  Server.Config,

  Common.Exceptions,
  NFCe.DTO;

type
  TEmissorNFCe = class
  strict private
    FACBrNFe: TACBrNFe;
    FConfig: TServerConfig;
    procedure ConfigurarComponente(ACBrNFe: TACBrNFe); overload;
    procedure ConfigurarComponente(ACertificado: TCertificadosConf); overload;
    procedure ConfigurarComponente(AGeral: TGeralConfNFe); overload;
    procedure ConfigurarComponente(AWebServices: TWebServicesConf); overload;
    procedure ConfigurarComponente(AArquivos: TArquivosConfNFe); overload;
    function CriarComponenteDANFE: TACBrNFeDANFCEClass;
    procedure BindingRetornoEvento(ToObj: TRetornoEventoNFeDTO;
      FromObj: TRetInfEvento);
    function GetDetalheEvento(TipoEvento: TpcnTpEvento; DetEvento: TDetEvento): TDetEventoDTO;
    function XmlFileName(chNFe: string): string;
  public
    constructor Create(AConfig: TServerConfig);
    destructor Destroy; override;
    function StatusServico: TRetornoStatusServicoDTO;
    function Enviar(Nota: TNFCeDTO): TRetornoEnvioNFCeDTO;
    function Consultar(chNFe: string): TRetornoConsultaNFCeDTO;
    function Cancelar(chNFe: string; idLote: Integer; nProt, xJust: string): TRetornoEnvioEventoNFeDTO;
    function DownloadXml(chNFe: string): TBytes;
    function DownloadPdf(chNFe: string): TBytes;
    function InutilizarNumeracao(ano: Integer; serie: Integer;
      nIni, nFin: integer; xJust: string): TRetornoInutilizacaoNFCeDTO;
  end;

  EEmissorNFCeException = class(ENuvemFiscalException)
  strict private
    FStatusCode: integer;
  public
    constructor Create(AStatusCode: Integer; AMsg: string);
    property StatusCode: Integer read FStatusCode;
  end;

implementation

{ TEmissorNFCe }

procedure TEmissorNFCe.ConfigurarComponente(ACBrNFe: TACBrNFe);
begin
  ConfigurarComponente(ACBrNFe.Configuracoes.Certificados);
  ACBrNFe.SSL.DescarregarCertificado;
  ConfigurarComponente(ACBrNFe.Configuracoes.Geral);
  ConfigurarComponente(ACBrNFe.Configuracoes.WebServices);
  ACBrNFe.SSL.SSLType := TSSLType.LT_all;
  ConfigurarComponente(ACBrNFe.Configuracoes.Arquivos);
end;

procedure TEmissorNFCe.ConfigurarComponente(ACertificado: TCertificadosConf);
begin
  ACertificado.ArquivoPFX := FConfig.Certificado.ArquivoPFX;
  ACertificado.Senha := AnsiString(FConfig.Certificado.Senha);
  ACertificado.NumeroSerie := FConfig.Certificado.NumeroSerie;
end;

procedure TEmissorNFCe.ConfigurarComponente(AGeral: TGeralConfNFe);
begin
  AGeral.ModeloDF         := TpcnModeloDF.moNFCe;
  AGeral.VersaoDF         := TpcnVersaoDF.ve400;
  AGeral.IdCSC            := FConfig.NFCe.IdCSC;
  AGeral.CSC              := FConfig.NFCe.CSC;
  AGeral.VersaoQRCode     := TpcnVersaoQrCode.veqr200;

  AGeral.SSLLib := TSSLLib.libWinCrypt;
  AGeral.SSLCryptLib := TSSLCryptLib.cryWinCrypt;
  AGeral.SSLHttpLib := TSSLHttpLib.httpWinHttp;
  AGeral.SSLXmlSignLib := TSSLXmlSignLib.xsLibXml2;

  AGeral.AtualizarXMLCancelado := True;
  AGeral.ExibirErroSchema := True;
  AGeral.RetirarAcentos   := True;
  AGeral.FormatoAlerta    := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.';
  AGeral.FormaEmissao     := TpcnTipoEmissao.teNormal;

  AGeral.Salvar           := False;
end;

procedure TEmissorNFCe.ConfigurarComponente(AWebServices: TWebServicesConf);
begin
  AWebServices.UF := FConfig.Emitente.UF;

  if FConfig.Producao then
    AWebServices.Ambiente := TpcnTipoAmbiente.taProducao
  else
    AWebServices.Ambiente := TpcnTipoAmbiente.taHomologacao;

  AWebServices.Visualizar := False;
  AWebServices.Salvar     := False;
  AWebServices.AjustaAguardaConsultaRet := False;
  AWebServices.AguardarConsultaRet := 5000;
  AWebServices.Tentativas := 5;
  AWebServices.IntervaloTentativas := 3000;
  AWebServices.TimeOut := 5000;
  AWebServices.ProxyHost := '';
  AWebServices.ProxyPort := '';
  AWebServices.ProxyUser := '';
  AWebServices.ProxyPass := '';
end;

constructor TEmissorNFCe.Create(AConfig: TServerConfig);
begin
  FConfig := AConfig;
  FACBrNFe := TACBrNFe.Create(nil);
  ConfigurarComponente(FACBrNFe);
end;

function TEmissorNFCe.CriarComponenteDANFE: TACBrNFeDANFCEClass;
begin
  {$IFDEF NUVEM_FASTREPORT}
    Result := TACBrNFeDANFCEFR.Create(nil);
    TACBrNFeDANFCEFR(Result).FastFile := FConfig.NFCe.DANFEFastFile;
  {$ENDIF}
  {$IFDEF NUVEM_FORTESREPORT}
    Result := TACBrNFeDANFCeFortes.Create(nil);
  {$ENDIF}

  {$IFNDEF NUVEM_FASTREPORT}
  {$IFNDEF NUVEM_FORTESREPORT}
      raise EEmissorNFCeException.Create(500, 'O gerenciador de relatório não está configurado no servidor.');
  {$IFEND}
  {$IFEND}

  Result.ACBrNFe := FACBrNFe;
  Result.Sistema := 'Nuvem Fiscal - https://nuvemfiscal.dev/';
end;

destructor TEmissorNFCe.Destroy;
begin
  if Assigned(FACBrNFe) then
    FACBrNFe.Free;
  inherited;
end;

function TEmissorNFCe.DownloadPdf(chNFe: string): TBytes;
var
  DANFE: TACBrNFeDANFCEClass;
begin
  if not TFile.Exists(XmlFileName(chNFe)) then
    raise EEmissorNFCeException.Create(400, Format('Arquivo XML da NFCe %s não localizado',
      [chNFe]));

  DANFE := CriarComponenteDANFE;
  try
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromFile(XmlFileName(chNFe), False);
    DANFE.PathPDF := TPath.GetTempPath;
    DANFE.ImprimirDANFEPDF(FACBrNFe.NotasFiscais.Items[0].NFe);
    try
      Result := TFile.ReadAllBytes(DANFE.ArquivoPDF);
    finally
      TFile.Delete(DANFE.ArquivoPDF);
    end;
  finally
    DANFE.Free;
  end;
end;

function TEmissorNFCe.DownloadXml(chNFe: string): TBytes;
begin
  if not TFile.Exists(XmlFileName(chNFe)) then
    raise EEmissorNFCeException.Create(400, Format('Arquivo XML da NFCe %s não localizado',
      [chNFe]));

  Result := TFile.ReadAllBytes(XmlFileName(chNFe));
end;

function TEmissorNFCe.Enviar(Nota: TNFCeDTO): TRetornoEnvioNFCeDTO;
var
  NFe: TNFe;
  ItemDTO: TDadosDetalheDTO;
  detPagItem: TDetalhamentoPagamentoDTO;
  Det: TDetCollectionItem;
  NFeRecepcao: TNFeRecepcao;
  TotalProdutos: double;
begin
  Result := TRetornoEnvioNFCeDTO.Create;
  try
    FACBrNFe.NotasFiscais.Clear;

    NFe := FACBrNFe.NotasFiscais.Add.NFe;

    //NFe.Ide.cNF       := StrToInt(NumNFe); //Caso não seja preenchido será gerado um número aleatório pelo componente
    NFe.Ide.natOp     := Nota.natOp;
    NFe.Ide.indPag    := ipVista;
    NFe.Ide.modelo    := 65;  // NFCe
    NFe.Ide.serie     := Nota.serie;
    NFe.Ide.nNF       := Nota.nNF;

    if Nota.dhEmi = 0 then
      NFe.Ide.dEmi := Now
    else
      NFe.Ide.dEmi := Nota.dhEmi;

    NFe.Ide.dSaiEnt   := Now;
    NFe.Ide.hSaiEnt   := Now;
    NFe.Ide.tpNF      := tnSaida;

    case Nota.idDest of
      1: NFe.Ide.idDest := TpcnDestinoOperacao.doInterna;
      2: NFe.Ide.idDest := TpcnDestinoOperacao.doInterestadual;
      3: NFe.Ide.idDest := TpcnDestinoOperacao.doExterior;
    else
      raise EEmissorNFCeException.Create(400, 'idDest inválido');
    end;

    NFe.Ide.tpEmis    := TpcnTipoEmissao.teNormal;

    if FConfig.Producao then
      NFe.Ide.tpAmb     := taProducao
    else
      NFe.Ide.tpAmb     := taHomologacao;

    NFe.Ide.cUF       := UFtoCUF(FConfig.Emitente.UF);
    NFe.Ide.cMunFG    := FConfig.Emitente.CodCidade;
    NFe.Ide.finNFe    := fnNormal;
    NFe.Ide.tpImp     := tiNFCe;
    NFe.Ide.indFinal  := cfConsumidorFinal;
    NFe.Ide.verProc  := 'Nuvem Fiscal';

    case Nota.indPres of
      0: NFe.Ide.indPres := TpcnPresencaComprador.pcNao;
      1: NFe.Ide.indPres := TpcnPresencaComprador.pcPresencial;
      2: NFe.Ide.indPres := TpcnPresencaComprador.pcInternet;
      3: NFe.Ide.indPres := TpcnPresencaComprador.pcTeleatendimento;
      4: NFe.Ide.indPres := TpcnPresencaComprador.pcEntregaDomicilio;
      5: NFe.Ide.indPres := TpcnPresencaComprador.pcPresencialForaEstabelecimento;
      9: NFe.Ide.indPres := TpcnPresencaComprador.pcOutros;
    end;

    NFe.Emit.CNPJCPF           := FConfig.Emitente.CNPJ;
    NFe.Emit.IE                := FConfig.Emitente.InscricaoEstadual;
    NFe.Emit.xNome             := FConfig.Emitente.RazaoSocial;
    NFe.Emit.xFant             := FConfig.Emitente.Fantasia;

    NFe.Emit.EnderEmit.fone    := FConfig.Emitente.Fone;
    NFe.Emit.EnderEmit.CEP     := StrToInt(FConfig.Emitente.CEP);
    NFe.Emit.EnderEmit.xLgr    := FConfig.Emitente.Logradouro;
    NFe.Emit.EnderEmit.nro     := FConfig.Emitente.Numero;
    NFe.Emit.EnderEmit.xCpl    := FConfig.Emitente.Complemento;
    NFe.Emit.EnderEmit.xBairro := FConfig.Emitente.Bairro;
    NFe.Emit.EnderEmit.cMun    := FConfig.Emitente.CodCidade;
    NFe.Emit.EnderEmit.xMun    := FConfig.Emitente.Cidade;
    NFe.Emit.EnderEmit.UF      := FConfig.Emitente.UF;
    NFe.Emit.enderEmit.cPais   := 1058;
    NFe.Emit.enderEmit.xPais   := 'BRASIL';

    NFe.Emit.IEST              := '';

    NFe.Emit.CRT               := crtRegimeNormal;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)

    if Nota.dest <> nil then
    begin
      NFe.Dest.CNPJCPF           := Nota.dest.CpfCnpj;
      NFe.Dest.xNome             := Nota.dest.xNome;
      NFe.Dest.Email             := Nota.dest.Email;
      NFe.Dest.indIEDest         := TpcnindIEDest.inNaoContribuinte;
    end;

    TotalProdutos := 0;
    for ItemDTO in Nota.det do
    begin
      TotalProdutos := TotalProdutos + ItemDTO.vProd;

      Det := NFe.Det.New;

      Det.Prod.nItem    := ItemDTO.nItem;
      Det.Prod.cProd    := ItemDTO.cProd;
      Det.Prod.cEAN     := ItemDTO.cEAN;
      Det.Prod.xProd    := ItemDTO.xProd;
      Det.Prod.NCM      := ItemDTO.NCM; // Tabela NCM disponível em  http://www.receita.fazenda.gov.br/Aliquotas/DownloadArqTIPI.htm
      Det.Prod.EXTIPI   := '';
      Det.Prod.CFOP     := ItemDTO.CFOP;
      Det.Prod.uCom     := ItemDTO.uCom;
      Det.Prod.qCom     := ItemDTO.qCom;
      Det.Prod.vUnCom   := ItemDTO.vUnCom;
      Det.Prod.vProd    := ItemDTO.vProd;

      Det.Prod.cEANTrib  := ItemDTO.cEANTrib;
      Det.Prod.uTrib     := ItemDTO.uTrib;
      Det.Prod.qTrib     := ItemDTO.qTrib;
      Det.Prod.vUnTrib   := ItemDTO.vUnTrib;

      Det.Prod.vFrete    := 0;
      Det.Prod.vSeg      := 0;
      Det.Prod.vDesc     := ItemDTO.vDesc;
      Det.Prod.vOutro    := ItemDTO.vOutro;

      Det.Prod.CEST := '1111111';

      // lei da transparencia nos impostos
      Det.Imposto.vTotTrib := 0;

      Det.Imposto.ICMS.CST     := cst00;
      Det.Imposto.ICMS.orig    := oeNacional;
      Det.Imposto.ICMS.modBC   := dbiValorOperacao;
      Det.Imposto.ICMS.vBC     := ItemDTO.vProd;
      Det.Imposto.ICMS.pICMS   := 18;
      Det.Imposto.ICMS.vICMS   := ItemDTO.vProd * 0.18;
      Det.Imposto.ICMS.modBCST := dbisMargemValorAgregado;
      Det.Imposto.ICMS.pMVAST  := 0;
      Det.Imposto.ICMS.pRedBCST:= 0;
      Det.Imposto.ICMS.vBCST   := 0;
      Det.Imposto.ICMS.pICMSST := 0;
      Det.Imposto.ICMS.vICMSST := 0;
      Det.Imposto.ICMS.pRedBC  := 0;

      // partilha do ICMS e fundo de probreza
      Det.Imposto.ICMSUFDest.vBCUFDest      := 0.00;
      Det.Imposto.ICMSUFDest.pFCPUFDest     := 0.00;
      Det.Imposto.ICMSUFDest.pICMSUFDest    := 0.00;
      Det.Imposto.ICMSUFDest.pICMSInter     := 0.00;
      Det.Imposto.ICMSUFDest.pICMSInterPart := 0.00;
      Det.Imposto.ICMSUFDest.vFCPUFDest     := 0.00;
      Det.Imposto.ICMSUFDest.vICMSUFDest    := 0.00;
      Det.Imposto.ICMSUFDest.vICMSUFRemet   := 0.00;
    end;

    NFe.Total.ICMSTot.vBC     := TotalProdutos;
    NFe.Total.ICMSTot.vICMS   := TotalProdutos * 0.18;
    NFe.Total.ICMSTot.vBCST   := 0;
    NFe.Total.ICMSTot.vST     := 0;

    NFe.Total.ICMSTot.vProd   := TotalProdutos;

    NFe.Total.ICMSTot.vFrete  := 0;
    NFe.Total.ICMSTot.vSeg    := 0;
    NFe.Total.ICMSTot.vDesc   := 0;
    NFe.Total.ICMSTot.vII     := 0;
    NFe.Total.ICMSTot.vIPI    := 0;
    NFe.Total.ICMSTot.vPIS    := 0;
    NFe.Total.ICMSTot.vCOFINS := 0;
    NFe.Total.ICMSTot.vOutro  := 0;
    NFe.Total.ICMSTot.vNF     := TotalProdutos;

    // partilha do icms e fundo de probreza
    NFe.Total.ICMSTot.vFCPUFDest   := 0.00;
    NFe.Total.ICMSTot.vICMSUFDest  := 0.00;
    NFe.Total.ICMSTot.vICMSUFRemet := 0.00;

    NFe.Total.ISSQNtot.vServ   := 0;
    NFe.Total.ISSQNTot.vBC     := 0;
    NFe.Total.ISSQNTot.vISS    := 0;
    NFe.Total.ISSQNTot.vPIS    := 0;
    NFe.Total.ISSQNTot.vCOFINS := 0;

    NFe.Transp.modFrete := mfSemFrete; // NFC-e não pode ter FRETE

    NFe.pag.vTroco := Nota.pag.vTroco;
    for detPagItem in Nota.pag.detPag do
    begin
      with NFe.pag.New do
      begin
        case detPagItem.tPag of
          1: tPag := TpcnFormaPagamento.fpDinheiro;
          2: tPag := TpcnFormaPagamento.fpCheque;
          3: tPag := TpcnFormaPagamento.fpCartaoCredito;
          4: tPag := TpcnFormaPagamento.fpCartaoDebito;
          5: tPag := TpcnFormaPagamento.fpCreditoLoja;
          10: tPag := TpcnFormaPagamento.fpValeAlimentacao;
          11: tPag := TpcnFormaPagamento.fpValeRefeicao;
          12: tPag := TpcnFormaPagamento.fpValePresente;
          13: tPag := TpcnFormaPagamento.fpValeCombustivel;
          14: tPag := TpcnFormaPagamento.fpDuplicataMercantil;
          15: tPag := TpcnFormaPagamento.fpBoletoBancario;
          90: tPag := TpcnFormaPagamento.fpSemPagamento;
          99: tPag := TpcnFormaPagamento.fpOutro;
        else
          raise EEmissorNFCeException.Create(400, 'detPagItem.tPag inválido');
        end;
        vPag := detPagItem.vPag;

        if detPagItem.card <> nil then
        begin
          case detPagItem.card.tpIntegra of
            0:  tpIntegra := TtpIntegra.tiNaoInformado;
            1:  tpIntegra := TtpIntegra.tiPagIntegrado;
            2:  tpIntegra := TtpIntegra.tiPagNaoIntegrado;
          else
            raise EEmissorNFCeException.Create(400, 'detPagItem.card.tpIntegra inválido');
          end;

          CNPJ := detPagItem.card.CNPJ;

          case detPagItem.card.tBand of
            1: tBand := TpcnBandeiraCartao.bcVisa;
            2: tBand := TpcnBandeiraCartao.bcMasterCard;
            3: tBand := TpcnBandeiraCartao.bcAmericanExpress;
            4: tBand := TpcnBandeiraCartao.bcSorocred;
            5: tBand := TpcnBandeiraCartao.bcDinersClub;
            6: tBand := TpcnBandeiraCartao.bcElo;
            7: tBand := TpcnBandeiraCartao.bcHipercard;
            8: tBand := TpcnBandeiraCartao.bcAura;
            9: tBand := TpcnBandeiraCartao.bcCabal;
            99: tBand := TpcnBandeiraCartao.bcOutros;
          else
            raise EEmissorNFCeException.Create(400, 'detPagItem.card.tBand inválido');
          end;

          cAut := detPagItem.card.cAut;
        end;
      end;
    end;

    NFe.InfAdic.infCpl     :=  '';
    NFe.InfAdic.infAdFisco :=  '';

    if ServerConfig.NFCe.ResponsavelTecnicoEmissao <> nil then
    begin
      NFe.infRespTec.CNPJ := ServerConfig.NFCe.ResponsavelTecnicoEmissao.CNPJ;
      NFe.infRespTec.xContato := ServerConfig.NFCe.ResponsavelTecnicoEmissao.Contato;
      NFe.infRespTec.email := ServerConfig.NFCe.ResponsavelTecnicoEmissao.Email;
      NFe.infRespTec.fone := ServerConfig.NFCe.ResponsavelTecnicoEmissao.Fone;
    end;

    FACBrNFe.NotasFiscais.GerarNFe;

    FACBrNFe.WebServices.Enviar.Clear;
    FACBrNFe.WebServices.Retorno.Clear;
    FACBrNFe.NotasFiscais.Assinar;
    FACBrNFe.NotasFiscais.Validar;

    NFeRecepcao := FACBrNFe.WebServices.Enviar;

    NFeRecepcao.Lote := '1';
    NFeRecepcao.Sincrono := True;
    NFeRecepcao.Zipado := True;

    if not NFeRecepcao.Executar then
      raise EEmissorNFCeException.Create(400, NFeRecepcao.Msg);

    Result.cStat := NFeRecepcao.cStat;
    Result.xMotivo := NFeRecepcao.xMotivo;
    Result.versao := NFeRecepcao.versao;

    case NFeRecepcao.tpAmb of
      taProducao: Result.tpAmb := 'Producao';
      taHomologacao: Result.tpAmb := 'Homologacao';
    end;

    Result.verAplic := NFeRecepcao.verAplic;
    Result.cUF := NFeRecepcao.cUF;

    if NFe.procNFe <> nil then
    begin
      FACBrNFe.NotasFiscais.Items[0].GravarXML(XmlFileName(NFe.procNFe.chNFe));

      Result.protNFe := TProtocoloNFCeDTO.Create;
      try
        Result.protNFe.chNFe := NFe.procNFe.chNFe;
        Result.protNFe.dhRecbto := NFe.procNFe.dhRecbto;
        Result.protNFe.nProt := NFe.procNFe.nProt;
        Result.protNFe.digVal := NFe.procNFe.digVal;
        Result.protNFe.cStat := NFe.procNFe.cStat;
        Result.protNFe.xMotivo := NFe.procNFe.xMotivo;
      except
        Result.protNFe.Free;
        raise;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TEmissorNFCe.GetDetalheEvento(TipoEvento: TpcnTpEvento;
  DetEvento: TDetEvento): TDetEventoDTO;
begin
  case TipoEvento of
    teCancelamento:
    begin
      Result := TDetEventoCancelamentoDTO.Create;
      try
        TDetEventoCancelamentoDTO(Result).nProt := DetEvento.nProt;
        TDetEventoCancelamentoDTO(Result).xJust := DetEvento.xJust;
      except
        Result.Free;
        raise;
      end;
    end;
  else
    Result := nil;
  end;
end;

function TEmissorNFCe.InutilizarNumeracao(ano, serie, nIni, nFin: integer;
  xJust: string): TRetornoInutilizacaoNFCeDTO;
var
  NFeInutilizacao: TNFeInutilizacao;
begin
  Result := TRetornoInutilizacaoNFCeDTO.Create;
  try
    NFeInutilizacao := FACBrNFe.WebServices.Inutilizacao;
    NFeInutilizacao.CNPJ := OnlyNumber(FConfig.Emitente.CNPJ);
    NFeInutilizacao.Modelo := 65; //NFCe
    NFeInutilizacao.Serie := serie;
    NFeInutilizacao.Ano := ano;
    NFeInutilizacao.NumeroInicial := nIni;
    NFeInutilizacao.NumeroFinal := nFin;
    NFeInutilizacao.Justificativa := xJust;

    if not NFeInutilizacao.Executar then
      raise EEmissorNFCeException.Create(400, NFeInutilizacao.Msg);

    Result.cStat := NFeInutilizacao.cStat;
    Result.xMotivo := NFeInutilizacao.xMotivo;
    Result.versao := NFeInutilizacao.versao;
    case NFeInutilizacao.tpAmb of
      taProducao: Result.tpAmb := 'Producao';
      taHomologacao: Result.tpAmb := 'Homologacao';
    end;
    Result.verAplic := NFeInutilizacao.verAplic;
    Result.cUF := NFeInutilizacao.cUF;
    Result.dhRecbto := NFeInutilizacao.dhRecbto;
    Result.nProt := NFeInutilizacao.Protocolo;
  except
    Result.Free;
    raise;
  end;
end;

function TEmissorNFCe.StatusServico: TRetornoStatusServicoDTO;
var
  NFeStatusServico: TNFeStatusServico;
begin
  Result := TRetornoStatusServicoDTO.Create;
  try
    NFeStatusServico := FACBrNFe.WebServices.StatusServico;
    if not NFeStatusServico.Executar then
      raise EEmissorNFCeException.Create(400, NFeStatusServico.Msg);

    Result.cStat := NFeStatusServico.cStat;
    Result.xMotivo := NFeStatusServico.xMotivo;
    Result.versao := NFeStatusServico.versao;

    case NFeStatusServico.tpAmb of
      taProducao: Result.tpAmb := 'Producao';
      taHomologacao: Result.tpAmb := 'Homologacao';
    end;

    Result.verAplic := NFeStatusServico.verAplic;
    Result.cUF := NFeStatusServico.cUF;
    Result.dhRecbto := NFeStatusServico.dhRecbto;
    Result.xObs := NFeStatusServico.xObs;
  except
    Result.Free;
    raise;
  end;
end;

function TEmissorNFCe.XmlFileName(chNFe: string): string;
begin
  Result := TPath.Combine(FConfig.NFCe.PathArquivos, Format('%s-procNfe.xml',
    [chNFe]));
end;

procedure TEmissorNFCe.BindingRetornoEvento(ToObj: TRetornoEventoNFeDTO;
  FromObj: TRetInfEvento);
begin
  ToObj.Id := FromObj.Id;

  case FromObj.tpAmb of
    taProducao: ToObj.tpAmb := 'Producao';
    taHomologacao: ToObj.tpAmb := 'Homologacao';
  end;

  ToObj.verAplic := FromObj.verAplic;
  ToObj.cOrgao := FromObj.cOrgao;
  ToObj.cStat := FromObj.cStat;
  ToObj.xMotivo := FromObj.xMotivo;
  ToObj.chNFe := FromObj.chNFe;
  ToObj.tpEvento := TpcnTpEventoString[Integer(FromObj.tpEvento)];
  ToObj.xEvento := FromObj.xEvento;
  ToObj.nSeqEvento := FromObj.nSeqEvento;
  ToObj.CNPJDest := FromObj.CNPJDest;
  ToObj.emailDest := FromObj.emailDest;
  ToObj.cOrgaoAutor := FromObj.cOrgaoAutor;
  ToObj.dhRegEvento := FromObj.dhRegEvento;
  ToObj.nProt := FromObj.nProt;
end;

function TEmissorNFCe.Cancelar(chNFe: string; idLote: Integer; nProt,
  xJust: string): TRetornoEnvioEventoNFeDTO;
var
  Cancelamento: TInfEventoCollectionItem;
  EventoRetorno: TRetEventoNFe;
  RetInfEvento: TRetInfEvento;
begin
  Result := TRetornoEnvioEventoNFeDTO.Create;
  try
    FACBrNFe.EventoNFe.Evento.Clear;

    Cancelamento := FACBrNFe.EventoNFe.Evento.New;
    Cancelamento.infEvento.chNFe := chNFe;
    Cancelamento.infEvento.dhEvento := now;
    Cancelamento.infEvento.tpEvento := teCancelamento;
    Cancelamento.infEvento.detEvento.xJust := xJust;
    Cancelamento.infEvento.detEvento.nProt := nProt;

    if not FACBrNFe.EnviarEvento(idLote) then
      raise EEmissorNFCeException.Create(400, FACBrNFe.WebServices.EnvEvento.Msg);

    EventoRetorno := FACBrNFe.WebServices.EnvEvento.EventoRetorno;
    Result.cStat := EventoRetorno.cStat;
    Result.xMotivo := EventoRetorno.xMotivo;
    Result.idLote := EventoRetorno.idLote;

    case EventoRetorno.tpAmb of
      taProducao: Result.tpAmb := 'Producao';
      taHomologacao: Result.tpAmb := 'Homologacao';
    end;

    Result.verAplic := EventoRetorno.verAplic;
    Result.cOrgao := EventoRetorno.cOrgao;

    RetInfEvento := EventoRetorno.retEvento[0].RetInfEvento;
    if RetInfEvento <> nil then
    begin
      Result.retEvento := TRetornoEventoNFeDTO.Create;
      try
        BindingRetornoEvento(Result.retEvento, RetInfEvento);
      except
        Result.retEvento.Free;
        raise;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TEmissorNFCe.ConfigurarComponente(AArquivos: TArquivosConfNFe);
begin
  AArquivos.Salvar             := False;
  AArquivos.SepararPorMes      := True;
  AArquivos.AdicionarLiteral   := True;
  AArquivos.EmissaoPathNFe     := True;
  AArquivos.SalvarEvento       := True;
  AArquivos.SepararPorCNPJ     := False;
  AArquivos.SepararPorModelo   := True;
  AArquivos.PathSchemas        := FConfig.NFCe.PathSchemas;
  AArquivos.PathSalvar         := FConfig.NFCe.PathArquivos;
  AArquivos.PathNFe            := TPath.Combine(FConfig.NFCe.PathArquivos, 'NFe');
  AArquivos.PathInu            := TPath.Combine(FConfig.NFCe.PathArquivos, 'Inutilizacao');
  AArquivos.PathEvento         := TPath.Combine(FConfig.NFCe.PathArquivos, 'Evento');

  if not DirectoryExists(FConfig.NFCe.PathSchemas) then
    raise ENuvemFiscalException.CreateFmt(
      'Diretório com os schemas não existe: %s',
      [FConfig.NFCe.PathSchemas]);

  if not DirectoryExists(FConfig.NFCe.PathArquivos) then
    raise ENuvemFiscalException.CreateFmt(
      'Diretório para salvar os arquivos XML não existe: %s',
      [FConfig.NFCe.PathArquivos]);
end;

function TEmissorNFCe.Consultar(chNFe: string): TRetornoConsultaNFCeDTO;
var
  NFeConsulta: TNFeConsulta;
  Evento: TRetEventoNFeCollectionItem;
  ProtocoloEvento: TProtocoloEventoNFeDTO;
  I: integer;
begin
  Result := TRetornoConsultaNFCeDTO.Create;
  try
    FACBrNFe.NotasFiscais.Clear;
    NFeConsulta := FACBrNFe.WebServices.Consulta;
    NFeConsulta.NFeChave := chNFe;

    if not NFeConsulta.Executar then
      raise EEmissorNFCeException.Create(400, NFeConsulta.Msg);

    Result.cStat := NFeConsulta.cStat;
    Result.xMotivo := NFeConsulta.xMotivo;
    Result.versao := NFeConsulta.versao;

    case NFeConsulta.tpAmb of
      taProducao: Result.tpAmb := 'Producao';
      taHomologacao: Result.tpAmb := 'Homologacao';
    end;

    Result.verAplic := NFeConsulta.verAplic;
    Result.cUF := NFeConsulta.cUF;
    Result.dhRecbto := NFeConsulta.DhRecbto;
    Result.chNFe := chNFe;

    if NFeConsulta.protNFe <> nil then
    begin
      Result.protNFe := TProtocoloNFCeDTO.Create;
      try
        Result.protNFe.chNFe := NFeConsulta.protNFe.chNFe;
        Result.protNFe.dhRecbto := NFeConsulta.protNFe.dhRecbto;
        Result.protNFe.nProt := NFeConsulta.protNFe.nProt;
        Result.protNFe.digVal := NFeConsulta.protNFe.digVal;
        Result.protNFe.cStat := NFeConsulta.protNFe.cStat;
        Result.protNFe.xMotivo := NFeConsulta.protNFe.xMotivo;
      except
        Result.protNFe.Free;
        raise;
      end;
    end;

    for I := 0 to NFeConsulta.procEventoNFe.Count - 1 do
    begin
      Evento := NFeConsulta.procEventoNFe[I];

      ProtocoloEvento := TProtocoloEventoNFeDTO.Create;
      ProtocoloEvento.evento := TEventoNFeDTO.Create;
      ProtocoloEvento.retEvento := TRetornoEventoNFeDTO.Create;
      try
        ProtocoloEvento.evento.id := Evento.RetEventoNFe.InfEvento.id;
        ProtocoloEvento.evento.cOrgao := Evento.RetEventoNFe.InfEvento.cOrgao;

        case Evento.RetEventoNFe.InfEvento.tpAmb of
          taProducao: ProtocoloEvento.evento.tpAmb := 'Producao';
          taHomologacao: ProtocoloEvento.evento.tpAmb := 'Homologacao';
        end;

        ProtocoloEvento.evento.CNPJ := Evento.RetEventoNFe.InfEvento.CNPJ;
        ProtocoloEvento.evento.chNFe := Evento.RetEventoNFe.InfEvento.chNFe;
        ProtocoloEvento.evento.dhEvento := Evento.RetEventoNFe.InfEvento.dhEvento;
        ProtocoloEvento.evento.tpEvento := TpcnTpEventoString[Integer(Evento.RetEventoNFe.InfEvento.tpEvento)];
        ProtocoloEvento.evento.nSeqEvento := Evento.RetEventoNFe.InfEvento.nSeqEvento;
        ProtocoloEvento.evento.versaoEvento := Evento.RetEventoNFe.InfEvento.versaoEvento;
        ProtocoloEvento.evento.DescEvento := Evento.RetEventoNFe.InfEvento.DescEvento;
        ProtocoloEvento.evento.TipoEvento := Evento.RetEventoNFe.InfEvento.TipoEvento;
        ProtocoloEvento.evento.detEvento := GetDetalheEvento(
          Evento.RetEventoNFe.InfEvento.tpEvento,
          Evento.RetEventoNFe.InfEvento.detEvento
        );

        BindingRetornoEvento(ProtocoloEvento.retEvento,
          Evento.RetEventoNFe.retEvento.Items[0].RetInfEvento);

        Result.procEventoNFe.Add(ProtocoloEvento);
      except
        ProtocoloEvento.evento.Free;
        ProtocoloEvento.retEvento.Free;
        ProtocoloEvento.Free;
        raise;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

{ EEmissorNFCeException }

constructor EEmissorNFCeException.Create(AStatusCode: Integer; AMsg: string);
begin
  FStatusCode := AStatusCode;
  inherited Create(AMsg);
end;

initialization
  InitLibXml2Interface;

end.
