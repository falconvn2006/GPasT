unit untDtmRelatorios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ppCtrls, ppPrnabl, ppClass, ppBands, ppDB, ppCache, ppDesignLayer,
  ppParameter, DB, IBCustomDataSet, ppProd, ppReport, ppComm, ppRelatv,
  ppDBPipe, IBQuery, ppVar, ppModule, raCodMod, ppStrtch, ppRegion, ppMemo,
  ppSubRpt;

type
  TfrmDtmRelatorios = class(TForm)
    qryRelArara: TIBQuery;
    dtsRelArara: TDataSource;
    pipRelArara: TppDBPipeline;
    rbiRelArara: TppReport;
    qryRelAraraCODIGO: TIntegerField;
    qryRelAraraDATAREGISTRO: TDateField;
    qryRelAraraCODIGOAGENDA: TIntegerField;
    qryRelAraraDATA: TDateField;
    qryRelAraraHORA: TTimeField;
    qryRelAraraPERFIL: TIBStringField;
    qryRelAraraEVENTO: TIBStringField;
    qryRelAraraTIPOCONVIDADO: TIBStringField;
    qryRelAraraPRODUTO: TIBStringField;
    qryRelAraraURLFOTO: TMemoField;
    ppParameterList1: TppParameterList;
    qryRelAraraFOTOPERFIL: TIBStringField;
    ppHeaderBand1: TppHeaderBand;
    ppShape1: TppShape;
    ppShape4: TppShape;
    ppLabel14: TppLabel;
    ppLabel1: TppLabel;
    ppDBText1: TppDBText;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppDBText2: TppDBText;
    ppLine1: TppLine;
    ppLabel4: TppLabel;
    ppShape2: TppShape;
    ppLabel5: TppLabel;
    ppLine2: TppLine;
    ppLabel6: TppLabel;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppLabel7: TppLabel;
    ppDBText5: TppDBText;
    ppLabel8: TppLabel;
    ppLine3: TppLine;
    ppLine4: TppLine;
    ppLine5: TppLine;
    ppLabel9: TppLabel;
    ppDBText6: TppDBText;
    ppLabel10: TppLabel;
    ppShape3: TppShape;
    ppImage1: TppImage;
    ppLabel11: TppLabel;
    ppDBText7: TppDBText;
    ppLabel12: TppLabel;
    ppDBText8: TppDBText;
    ppLabel13: TppLabel;
    ppDBText9: TppDBText;
    ppColumnHeaderBand1: TppColumnHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppShape5: TppShape;
    ppDBText10: TppDBText;
    ppImage2: TppImage;
    ppLabel15: TppLabel;
    ppLine6: TppLine;
    ppLine7: TppLine;
    ppLine8: TppLine;
    ppLine9: TppLine;
    ppLine10: TppLine;
    ppLine11: TppLine;
    ppLine12: TppLine;
    ppLine13: TppLine;
    ppShape6: TppShape;
    ppColumnFooterBand1: TppColumnFooterBand;
    ppFooterBand1: TppFooterBand;
    ppSystemVariable1: TppSystemVariable;
    ppLine17: TppLine;
    ppSystemVariable2: TppSystemVariable;
    ppLabel16: TppLabel;
    raCodeModule1: TraCodeModule;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    qryOrdemServico: TIBQuery;
    dtsOrdemServico: TDataSource;
    pipOrdemServico: TppDBPipeline;
    rbiOrdemServico: TppReport;
    ppParameterList2: TppParameterList;
    ppDesignLayers2: TppDesignLayers;
    ppDesignLayer2: TppDesignLayer;
    ppDetailBand2: TppDetailBand;
    ppFooterBand2: TppFooterBand;
    qryOrdemServicoCODIGO: TIntegerField;
    qryOrdemServicoPERFIL: TIBStringField;
    qryOrdemServicoSERVICO: TIBStringField;
    qryOrdemServicoDETALHAMENTO: TIBStringField;
    qryOrdemServicoNUMEROPRESTADOR: TIBStringField;
    qryOrdemServicoDATA: TDateField;
    qryOrdemServicoDATAINICIO: TDateField;
    qryOrdemServicoHORAINICIO: TTimeField;
    qryOrdemServicoDATAFIM: TDateField;
    qryOrdemServicoHORAFIM: TTimeField;
    qryOrdemServicoSITUACAO: TIBStringField;
    qryOrdemServicoCODIGOPRODUTO: TIntegerField;
    qryOrdemServicoDESCRICAO: TIBStringField;
    qryOrdemServicoVALORSERVICO: TIBBCDField;
    ppSystemVariable3: TppSystemVariable;
    ppLabel35: TppLabel;
    ppSystemVariable4: TppSystemVariable;
    ppLine20: TppLine;
    qryOrdemServicoOBSERVACOES: TMemoField;
    qryOrdemServicoENDERECO: TIBStringField;
    qryOrdemServicoTELEFONES: TIBStringField;
    qryOrdemServicoEMAIL1: TIBStringField;
    ppDBOrcamentoDetalhe: TppDBPipeline;
    ppDBOrcamento: TppDBPipeline;
    rbiOrcamento: TppReport;
    ppDetailBand3: TppDetailBand;
    ppDesignLayers3: TppDesignLayers;
    ppDesignLayer3: TppDesignLayer;
    ppParameterList3: TppParameterList;
    dtsOrcamento: TDataSource;
    qryOrcamento: TIBQuery;
    qryOrcamentoCODIGO: TIntegerField;
    qryOrcamentoDATACADASTRO: TDateField;
    qryOrcamentoCODIGOUSUARIO: TIntegerField;
    qryOrcamentoCODIGOCLIENTE: TIntegerField;
    qryOrcamentoOBSERVACOES: TIBStringField;
    qryOrcamentoCODIGOSITUACAO: TIntegerField;
    qryOrcamentoCODIGOPEDIDO: TIntegerField;
    qryOrcamentoNOMCLIENTE: TIBStringField;
    qryOrcamentoDetalhe: TIBQuery;
    qryOrcamentoDetalheCODIGO: TIntegerField;
    qryOrcamentoDetalheID: TIntegerField;
    qryOrcamentoDetalheCODIGOPRODUTO: TIntegerField;
    qryOrcamentoDetalheVALOR: TIBBCDField;
    dtsOrcamentoDetalhe: TDataSource;
    qryOrcamentoUSERNAME: TIBStringField;
    qryOrcamentoDetalheNOMEPRODUTO: TIBStringField;
    qryOrcamentoTELEFONE: TIBStringField;
    qryBoleto: TIBQuery;
    qryBoletoDetalhe: TIBQuery;
    dtsBoletoDetalhe: TDataSource;
    dtsBoleto: TDataSource;
    pipBoleto: TppDBPipeline;
    pipBoletoDetalhe: TppDBPipeline;
    rbiBoleto: TppReport;
    ppTitleBand2: TppTitleBand;
    ppLine50: TppLine;
    ppLine51: TppLine;
    ppLine52: TppLine;
    ppLine53: TppLine;
    ppLabel48: TppLabel;
    ppHeaderBand4: TppHeaderBand;
    ppDetailBand4: TppDetailBand;
    ppFooterBand4: TppFooterBand;
    ppSummaryBand2: TppSummaryBand;
    ppDesignLayers4: TppDesignLayers;
    ppDesignLayer4: TppDesignLayer;
    ppParameterList4: TppParameterList;
    qryBoletoCODIGO: TIntegerField;
    qryBoletoDATA: TDateField;
    qryBoletoCODIGOCLIENTE: TIntegerField;
    qryBoletoNOMECLIENTE: TIBStringField;
    qryBoletoCPF: TIBStringField;
    qryBoletoCODIGOBANCO: TIntegerField;
    qryBoletoNOMEBANCO: TIBStringField;
    qryBoletoOPERACAO_CONTA: TIBStringField;
    qryBoletoAGENCIA: TIBStringField;
    qryBoletoNUMERO_CONTA: TIBStringField;
    qryBoletoVALOR: TIBBCDField;
    qryBoletoDetalheCODIGOCONTRATO: TIntegerField;
    qryBoletoDetalheCODIGOPRODUTO: TIntegerField;
    qryBoletoDetalheNOMEPRODUTO: TIBStringField;
    qryBoletoDetalheVALOR: TIBBCDField;
    ppSubReport1: TppSubReport;
    ppChildReport1: TppChildReport;
    ppDesignLayers5: TppDesignLayers;
    ppDesignLayer5: TppDesignLayer;
    ppTitleBand3: TppTitleBand;
    ppDetailBand5: TppDetailBand;
    ppSummaryBand3: TppSummaryBand;
    ppLine54: TppLine;
    ppLine55: TppLine;
    ppLine64: TppLine;
    ppLine80: TppLine;
    ppDBText35: TppDBText;
    ppDBText36: TppDBText;
    ppDBText37: TppDBText;
    ppLine81: TppLine;
    ppLine82: TppLine;
    ppLine83: TppLine;
    ppLine85: TppLine;
    ppLine86: TppLine;
    ppLine88: TppLine;
    ppLine89: TppLine;
    ppLine90: TppLine;
    ppLabel50: TppLabel;
    ppLabel51: TppLabel;
    ppLabel52: TppLabel;
    ppLine91: TppLine;
    ppLabel49: TppLabel;
    ppDBText34: TppDBText;
    ppLabel53: TppLabel;
    ppDBText38: TppDBText;
    ppLabel54: TppLabel;
    ppLabel55: TppLabel;
    ppLabel56: TppLabel;
    ppLabel57: TppLabel;
    ppLabel58: TppLabel;
    ppLabel59: TppLabel;
    ppDBText39: TppDBText;
    ppDBText40: TppDBText;
    ppDBText41: TppDBText;
    ppDBText42: TppDBText;
    ppDBText43: TppDBText;
    ppDBText44: TppDBText;
    ppLabel60: TppLabel;
    qryContratoTerceiro: TIBQuery;
    dtsContratoTerceiro: TDataSource;
    pipContratoTerceiro: TppDBPipeline;
    rbiContratoTerceiro: TppReport;
    ppTitleBand4: TppTitleBand;
    ppLine56: TppLine;
    ppLine57: TppLine;
    ppLine58: TppLine;
    ppLine59: TppLine;
    ppLabel61: TppLabel;
    ppHeaderBand5: TppHeaderBand;
    ppLine60: TppLine;
    ppLabel62: TppLabel;
    ppDBText45: TppDBText;
    ppLabel64: TppLabel;
    ppDBText47: TppDBText;
    ppLine62: TppLine;
    ppLine63: TppLine;
    ppLine65: TppLine;
    ppLine66: TppLine;
    ppLine67: TppLine;
    ppLine68: TppLine;
    ppLine69: TppLine;
    ppLine70: TppLine;
    ppLabel66: TppLabel;
    ppLabel67: TppLabel;
    ppLabel68: TppLabel;
    ppLabel69: TppLabel;
    ppLine71: TppLine;
    ppLabel70: TppLabel;
    ppDBText49: TppDBText;
    ppDetailBand6: TppDetailBand;
    ppLine72: TppLine;
    ppLine73: TppLine;
    ppLine74: TppLine;
    ppDBText50: TppDBText;
    ppLine75: TppLine;
    ppLine76: TppLine;
    ppDBText51: TppDBText;
    ppDBText52: TppDBText;
    ppDBText53: TppDBText;
    ppLine77: TppLine;
    ppLine78: TppLine;
    ppFooterBand5: TppFooterBand;
    ppSummaryBand4: TppSummaryBand;
    ppDesignLayers6: TppDesignLayers;
    ppDesignLayer6: TppDesignLayer;
    ppParameterList5: TppParameterList;
    qryContratoTerceiroCODIGO: TIntegerField;
    qryContratoTerceiroVERSAO: TIntegerField;
    qryContratoTerceiroCODIGOFORNECEDOR: TIntegerField;
    qryContratoTerceiroNOMEFORNECEDOR: TIBStringField;
    qryContratoTerceiroCPF: TIBStringField;
    qryContratoTerceiroTELEFONE: TIBStringField;
    qryContratoTerceiroDATAAQUISICAO: TDateField;
    qryContratoTerceiroCODIGOPRODUTO: TIntegerField;
    qryContratoTerceiroNOMEPRODUTO: TIBStringField;
    qryContratoTerceiroVALORALUGUEL1: TIBBCDField;
    ppLabel72: TppLabel;
    ppLabel63: TppLabel;
    ppLabel65: TppLabel;
    ppDBText46: TppDBText;
    ppDBText48: TppDBText;
    ppDBText54: TppDBText;
    ppMemo1: TppMemo;
    ppDBText55: TppDBText;
    ppMemo2: TppMemo;
    ppLabel71: TppLabel;
    ppLabel73: TppLabel;
    ppLine61: TppLine;
    ppLabel74: TppLabel;
    ppDBText56: TppDBText;
    ppLabel76: TppLabel;
    ppLine79: TppLine;
    qryOrdemServicoPESSOARECADO: TIBStringField;
    ppSubReport2: TppSubReport;
    ppChildReport2: TppChildReport;
    ppDesignLayers8: TppDesignLayers;
    ppDesignLayer8: TppDesignLayer;
    ppTitleBand6: TppTitleBand;
    ppDetailBand8: TppDetailBand;
    ppSummaryBand6: TppSummaryBand;
    ppLine28: TppLine;
    ppLine27: TppLine;
    ppLine29: TppLine;
    ppLine30: TppLine;
    ppLine31: TppLine;
    ppLine32: TppLine;
    ppLine33: TppLine;
    ppLine34: TppLine;
    ppLabel42: TppLabel;
    ppLabel43: TppLabel;
    ppLabel44: TppLabel;
    ppLabel45: TppLabel;
    ppLine36: TppLine;
    ppLine37: TppLine;
    ppLine38: TppLine;
    ppDBText30: TppDBText;
    ppLine39: TppLine;
    ppLine40: TppLine;
    ppDBText31: TppDBText;
    ppDBText32: TppDBText;
    ppDBText33: TppDBText;
    ppLine41: TppLine;
    ppLine42: TppLine;
    ppDBCalc2: TppDBCalc;
    ppLine47: TppLine;
    ppLine48: TppLine;
    ppLine49: TppLine;
    ppLine21: TppLine;
    ppLine22: TppLine;
    ppLine23: TppLine;
    ppLine24: TppLine;
    ppLabel37: TppLabel;
    ppImage3: TppImage;
    ppLabel34: TppLabel;
    ppDBText59: TppDBText;
    ppLine25: TppLine;
    ppLine26: TppLine;
    ppLabel38: TppLabel;
    ppDBText25: TppDBText;
    ppLabel39: TppLabel;
    ppDBText26: TppDBText;
    ppLabel40: TppLabel;
    ppDBText27: TppDBText;
    ppLabel41: TppLabel;
    ppDBText28: TppDBText;
    ppLabel46: TppLabel;
    ppDBText29: TppDBText;
    ppLabel47: TppLabel;
    ppDBMemo4: TppDBMemo;
    ppLine111: TppLine;
    ppRegion2: TppRegion;
    ppLine43: TppLine;
    ppMemo3: TppMemo;
    ppLine44: TppLine;
    ppSubReport3: TppSubReport;
    ppChildReport3: TppChildReport;
    ppDesignLayers7: TppDesignLayers;
    ppDesignLayer7: TppDesignLayer;
    ppDetailBand7: TppDetailBand;
    ppSummaryBand1: TppSummaryBand;
    ppHeaderBand3: TppHeaderBand;
    ppLabel28: TppLabel;
    ppLabel29: TppLabel;
    ppLabel30: TppLabel;
    ppLine15: TppLine;
    ppDBText11: TppDBText;
    ppDBText12: TppDBText;
    ppDBText13: TppDBText;
    ppLabel31: TppLabel;
    ppLine16: TppLine;
    ppDBCalc1: TppDBCalc;
    ppLine14: TppLine;
    ppLabel17: TppLabel;
    ppLabel18: TppLabel;
    ppLabel19: TppLabel;
    ppDBText14: TppDBText;
    ppDBText15: TppDBText;
    ppLabel36: TppLabel;
    ppDBText22: TppDBText;
    ppShape7: TppShape;
    ppLabel20: TppLabel;
    ppLabel21: TppLabel;
    ppLabel22: TppLabel;
    ppLabel23: TppLabel;
    ppDBText16: TppDBText;
    ppDBText23: TppDBText;
    ppDBText24: TppDBText;
    ppDBMemo3: TppDBMemo;
    ppLabel75: TppLabel;
    ppDBText57: TppDBText;
    ppShape8: TppShape;
    ppLabel25: TppLabel;
    ppDBMemo2: TppDBMemo;
    ppLabel27: TppLabel;
    ppLabel26: TppLabel;
    ppDBText18: TppDBText;
    ppDBText19: TppDBText;
    ppDBText20: TppDBText;
    ppDBText21: TppDBText;
    ppRegion1: TppRegion;
    ppLine18: TppLine;
    ppLabel33: TppLabel;
    ppDBText58: TppDBText;
    ppLine19: TppLine;
    ppLabel32: TppLabel;
    ppDBMemo1: TppDBMemo;
    ppLine35: TppLine;
    ppLabel77: TppLabel;
    ppDBText60: TppDBText;
    ppImage4: TppImage;
    ppFooterBand3: TppFooterBand;
    ppSystemVariable5: TppSystemVariable;
    ppLabel78: TppLabel;
    ppSystemVariable6: TppSystemVariable;
    qryOS: TIBQuery;
    dtsOS: TDataSource;
    pipOS: TppDBPipeline;
    qryOSCODIGO: TIntegerField;
    qryOSCODIGOUSUARIO: TIntegerField;
    qryOSSITUACAO: TIntegerField;
    qryOSNUMEROPRESTADOR: TIBStringField;
    qryOSDATA: TDateField;
    qryOSCODIGOPERFIL: TIntegerField;
    qryOSCODIGOSERVICO: TIntegerField;
    qryOSDATAINICIO: TDateField;
    qryOSHORAINICIO: TTimeField;
    qryOSDATAFIM: TDateField;
    qryOSHORAFIM: TTimeField;
    qryOSOBSERVACOES: TMemoField;
    qryOSCODIGOAGENDA: TIntegerField;
    ppRegion3: TppRegion;
    ppLine45: TppLine;
    qryAluguelTerceiros: TIBQuery;
    dtsAluguelTerceiros: TDataSource;
    pipAluguelTerceiros: TppDBPipeline;
    rbiAluguelTerceiros: TppReport;
    ppTitleBand1: TppTitleBand;
    ppLine46: TppLine;
    ppLine84: TppLine;
    ppLine87: TppLine;
    ppLine92: TppLine;
    ppLabel79: TppLabel;
    ppHeaderBand2: TppHeaderBand;
    ppLine93: TppLine;
    ppLabel80: TppLabel;
    ppDBText61: TppDBText;
    ppLabel81: TppLabel;
    ppDBText62: TppDBText;
    ppLine102: TppLine;
    ppLabel87: TppLabel;
    ppLabel88: TppLabel;
    ppLabel89: TppLabel;
    ppDBText64: TppDBText;
    ppDBText65: TppDBText;
    ppDBText66: TppDBText;
    ppDetailBand9: TppDetailBand;
    ppSummaryBand5: TppSummaryBand;
    ppDesignLayers9: TppDesignLayers;
    ppDesignLayer9: TppDesignLayer;
    ppParameterList6: TppParameterList;
    qryPagamentoAluguel: TIBQuery;
    dtsPagamentoAluguel: TDataSource;
    pipPagamentoAluguel: TppDBPipeline;
    qryPagamentoAluguelDATAVENCIMENTO: TDateField;
    ppLabel86: TppLabel;
    ppDBText63: TppDBText;
    ppLine94: TppLine;
    ppMemo4: TppMemo;
    ppLabel82: TppLabel;
    ppLine95: TppLine;
    ppDBMemo5: TppDBMemo;
    ppSubReport4: TppSubReport;
    ppChildReport4: TppChildReport;
    ppDesignLayers10: TppDesignLayers;
    ppDesignLayer10: TppDesignLayer;
    ppDetailBand10: TppDetailBand;
    ppTitleBand5: TppTitleBand;
    ppHeaderBand6: TppHeaderBand;
    ppLine97: TppLine;
    ppLine98: TppLine;
    ppLabel83: TppLabel;
    ppLine101: TppLine;
    ppLine106: TppLine;
    ppLabel84: TppLabel;
    ppDBText67: TppDBText;
    ppLine107: TppLine;
    ppLine108: TppLine;
    qryAluguelTerceirosCODIGOFORNECEDOR: TIntegerField;
    qryAluguelTerceirosNOMEFORNECEDOR: TIBStringField;
    qryAluguelTerceirosCPF: TIBStringField;
    qryAluguelTerceirosTELCELULAR: TIBStringField;
    qryAluguelTerceirosEMAIL: TIBStringField;
    qryAluguelTerceirosDATA: TDateField;
    qryAluguelTerceirosNOMEPRODUTO: TMemoField;
    qryAluguelTerceirosCODIGOCONTRATO: TIntegerField;
    ppLine96: TppLine;
    qryPagamentoAluguelVALOR: TIBBCDField;
    ppLabel85: TppLabel;
    ppLine99: TppLine;
    ppLine100: TppLine;
    ppDBText68: TppDBText;
    ppFooterBand6: TppFooterBand;
    ppLine103: TppLine;
    ppDBCalc3: TppDBCalc;
    rbiAraraSemFoto: TppReport;
    ppHeaderBand7: TppHeaderBand;
    ppShape9: TppShape;
    ppShape10: TppShape;
    ppShape11: TppShape;
    ppLabel90: TppLabel;
    ppLabel91: TppLabel;
    ppDBText69: TppDBText;
    ppLabel92: TppLabel;
    ppLabel93: TppLabel;
    ppDBText70: TppDBText;
    ppLine104: TppLine;
    ppLabel94: TppLabel;
    ppLabel95: TppLabel;
    ppLine105: TppLine;
    ppLabel96: TppLabel;
    ppDBText71: TppDBText;
    ppDBText72: TppDBText;
    ppLabel97: TppLabel;
    ppDBText73: TppDBText;
    ppLabel98: TppLabel;
    ppLine109: TppLine;
    ppLine110: TppLine;
    ppLine112: TppLine;
    ppLabel99: TppLabel;
    ppDBText74: TppDBText;
    ppLabel100: TppLabel;
    ppShape12: TppShape;
    ppImage5: TppImage;
    ppLabel101: TppLabel;
    ppDBText75: TppDBText;
    ppLabel102: TppLabel;
    ppDBText76: TppDBText;
    ppLabel103: TppLabel;
    ppDBText77: TppDBText;
    ppColumnHeaderBand2: TppColumnHeaderBand;
    ppDetailBand11: TppDetailBand;
    ppShape14: TppShape;
    ppColumnFooterBand2: TppColumnFooterBand;
    ppFooterBand7: TppFooterBand;
    ppSystemVariable7: TppSystemVariable;
    ppLine121: TppLine;
    ppSystemVariable8: TppSystemVariable;
    ppLabel105: TppLabel;
    raCodeModule2: TraCodeModule;
    ppDesignLayers11: TppDesignLayers;
    ppDesignLayer11: TppDesignLayer;
    ppParameterList7: TppParameterList;
    ppDBMemo6: TppDBMemo;
    ppLabel104: TppLabel;
    ppDBText78: TppDBText;
    ppLine113: TppLine;
    procedure ppImage2Print(Sender: TObject);
    procedure ppImage1Print(Sender: TObject);
    procedure ppLabel47GetText(Sender: TObject; var Text: string);
    procedure rbiOrcamentoPreviewFormCreate(Sender: TObject);
    procedure rbiOrcamentoBeforePrint(Sender: TObject);
    procedure rbiOrdemServicoBeforePrint(Sender: TObject);
  private
    vUrlFoto : String;
    { Private declarations }
  public

    procedure ImprimirArara(iCodigo: Integer; iSemFoto: Boolean);
    procedure ImprimirOS(iCodigo: Integer);
    procedure ImprimirOrcamento(iCodigo: Integer);
    procedure ImprimirBoleto(iCodigo: Integer);
    procedure ImprimirContratoTerceiro(iCodigo: Integer);
    Function ImprimirAluguelTerceiros(iCodigo, iCodigoPerfil: Integer;SalvarPDF:Boolean=False; cTextoPadrao: String = ''; QtdDiasPagamento:Integer = 0):String;

    { Public declarations }

  end;

var
  frmDtmRelatorios: TfrmDtmRelatorios;

implementation

uses untDados;

{$R *.dfm}

Function TfrmDtmRelatorios.ImprimirAluguelTerceiros(iCodigo, iCodigoPerfil: Integer;SalvarPDF:Boolean=False; cTextoPadrao: String = ''; QtdDiasPagamento:Integer = 0):String;
var
  Arquivo, Caminho: String;
begin

  Result := '';

  qryAluguelTerceiros.Close;
  qryAluguelTerceiros.SQL.Strings[qryAluguelTerceiros.SQL.IndexOf('--AND')+1] := ' AND D.CODIGO =0'+intToStr(iCodigo)+
                                                                                 ' AND PE.CODIGO ='+intToStr(iCodigoPerfil);
  qryAluguelTerceiros.Open;

  qryPagamentoAluguel.Close;
  qryPagamentoAluguel.SQL.Strings[qryPagamentoAluguel.SQL.IndexOf('--DIAS')+1] := intToStr(QtdDiasPagamento);
  qryPagamentoAluguel.SQL.Strings[qryPagamentoAluguel.SQL.IndexOf('--AND')+1] := ' AND C.CODIGO =0'+intToStr(iCodigo) +
                                                                                 ' AND PE.CODIGO ='+intToStr(iCodigoPerfil);;
  qryPagamentoAluguel.Open;

  ppMemo4.Lines.Text := cTextoPadrao;

  if SalvarPDF then
  begin

    Caminho := ExtractFilePath(Application.ExeName)+'\ContratosTerceiros\Perfil_'+intToStr(iCodigoPerfil);

    if not DirectoryExists(Caminho) then
      ForceDirectories(Caminho);

    Arquivo := Caminho+'\CONTRATO_'+intToStr(iCodigo)+'.pdf';

    Dados.ImprimirPDF(rbiAluguelTerceiros,Arquivo);

    Result := Arquivo;
    
  end
  else
  begin
    rbiAluguelTerceiros.DeviceType := 'Screen';
    rbiAluguelTerceiros.Print;
  end;
end;

procedure TfrmDtmRelatorios.ImprimirArara(iCodigo: Integer; iSemFoto: Boolean);
begin

  vUrlFoto := Dados.ValidaURL(tuProduto);

  qryRelArara.Close;
  qryRelArara.Params[0].AsInteger := iCodigo;
  qryRelArara.Open;

  if iSemFoto then
    rbiAraraSemFoto.Print
  else
    rbiRelArara.Print;
end;

procedure TfrmDtmRelatorios.ImprimirBoleto(iCodigo: Integer);
begin
  qryBoleto.Close;
  qryBoleto.Params[0].AsInteger := iCodigo;
  qryBoleto.Open;

  qryBoletoDetalhe.Close;
  qryBoletoDetalhe.Params[0].AsInteger := iCodigo;
  qryBoletoDetalhe.Open;

  rbiBoleto.Print;
end;

procedure TfrmDtmRelatorios.ImprimirContratoTerceiro(iCodigo: Integer);
begin
  qryContratoTerceiro.Close;
  qryContratoTerceiro.Params[0].AsInteger := iCodigo;
  qryContratoTerceiro.Open;
  rbiContratoTerceiro.Print;
end;

procedure TfrmDtmRelatorios.ImprimirOrcamento(iCodigo: Integer);
begin
  qryOrcamento.Close;
  qryOrcamento.Params[0].AsInteger := iCodigo;
  qryOrcamento.Open;
  rbiOrcamento.Print;
end;

procedure TfrmDtmRelatorios.ImprimirOS(iCodigo: Integer);
begin

  qryOS.Close;
  qryOS.Params[0].AsInteger := iCodigo;
  qryOS.Open;

  qryOrdemServico.Close;
  qryOrdemServico.Params[0].AsInteger := iCodigo;
  qryOrdemServico.Open;
  rbiOrdemServico.Print;
end;

procedure TfrmDtmRelatorios.ppImage1Print(Sender: TObject);
begin
  try
    ppImage1.Clear;
    if qryRelAraraFOTOPERFIL.AsString <> '' then
      ppImage1.Picture.LoadFromFile(qryRelAraraFOTOPERFIL.AsString);
  Except

  end;
end;

procedure TfrmDtmRelatorios.ppImage2Print(Sender: TObject);
begin
  try
    ppImage2.Clear;
    if qryRelAraraURLFOTO.AsString  <> '' then
      ppImage2.Picture.LoadFromFile(vUrlFoto+qryRelAraraURLFOTO.AsString);
  Except

  end;
end;
procedure TfrmDtmRelatorios.ppLabel47GetText(Sender: TObject; var Text: string);
begin
  Text := 'Orçamento válido até o dia '+FormatDateTime('DD/MM/YYYY',qryOrcamentoDATACADASTRO.AsDateTime + 5);
end;

procedure TfrmDtmRelatorios.rbiOrcamentoBeforePrint(Sender: TObject);
begin
  ppDetailBand3.BandsPerRecord := 2;
  //rbiOrcamento.PrinterSetup.Copies := 2;
end;

procedure TfrmDtmRelatorios.rbiOrcamentoPreviewFormCreate(Sender: TObject);
begin
	Dados.AjustaRelatorio(Sender);
end;

procedure TfrmDtmRelatorios.rbiOrdemServicoBeforePrint(Sender: TObject);
begin
  ppDetailBand2.BandsPerRecord := 1;
  rbiOrdemServico.PrinterSetup.Copies := 2;
end;

end.
