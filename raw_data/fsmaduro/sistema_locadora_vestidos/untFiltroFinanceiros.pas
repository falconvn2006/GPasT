unit untFiltroFinanceiros;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Mask, RxLookup, DB, IBCustomDataSet,
  IBQuery, ExtCtrls, rxToolEdit, DBTables, ppDB, ppDBPipe, ppComm, ppRelatv,
  ppProd, ppClass, ppReport, ppVar, ppBands, ppCtrls, ppPrnabl, ppCache, ppChrt,
  ppChrtDP, TeEngine, TeeFunci, wwdbdatetimepicker, Funcao, ppStrtch, ppRegion,
  ppModule, raCodMod, ppSubRpt, ppParameter, ppDBBDE,ppMemo, ppDevice, wwdblook,
  Wwdbdlg, Grids, Wwdbigrd, Wwdbgrid, Menus, TeeProcs, Chart, DBChart, Series,
  ppDesignLayer;

type
  rDadosGrafico = record
    MesAno: String;
    Valor: Currency;
end;

type
  TfrmFiltroFinanceiros = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btn_ok: TSpeedButton;
    btn_sair: TSpeedButton;
    rbAgrupamento: TRadioGroup;
    rbOrdem: TRadioGroup;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    dtsDizimista: TDataSource;
    qryDizimista: TIBQuery;
    qryDizimistaCODIGO: TIntegerField;
    cmbDizimista: TRxDBLookupCombo;
    Label3: TLabel;
    Label4: TLabel;
    cmbServo: TRxDBLookupCombo;
    Label5: TLabel;
    cmbTurno: TRxDBLookupCombo;
    cmbTipo: TComboBox;
    dtsServo: TDataSource;
    qryServo: TIBQuery;
    qryServoCODIGO: TIntegerField;
    dtsTurno: TDataSource;
    qryTurno: TIBQuery;
    qryTurnoCODIGO: TIntegerField;
    qryDizimistaNOME: TIBStringField;
    lblDtFinal: TLabel;
    qryTurnoNOME: TIBStringField;
    SpeedButton1: TSpeedButton;
    pipRelGeralMensal: TppDBPipeline;
    qryRelGeralMensal: TIBQuery;
    dtsRelGeralMensal: TDataSource;
    qryRelGeralMensalQTDCONTRIBUICOES: TIntegerField;
    qryRelGeralMensalVALORCONTRIBUICOES: TIBBCDField;
    qryRelGeralMensalVALORCONTRIBUICOESANO: TIBBCDField;
    qryRelGeralMensalVALORCONTRIBUICOESMESANTERIOR: TIBBCDField;
    qryRelGeralMensalVALORCONTRIBUICOESMESANOANTERIO: TIBBCDField;
    qryRelGeralMensalVALORCONTRIBUICOESANOANTERIOR: TIBBCDField;
    qryRelGeralMensalQTDINSCRICOESMES: TIntegerField;
    qryRelGeralMensalVALORINSCRICOESMES: TIBBCDField;
    qryRelGeralMensalQTDPENDENTESMES: TIntegerField;
    qryRelGeralMensalVALORPENDENTESMES: TIBBCDField;
    qryRelGeralMensalQTDAFASTADOSMES: TIntegerField;
    qryRelGeralMensalVALORAFASTADOSMES: TIBBCDField;
    qryRelGeralMensalACUMULADOAFASTADOS: TIntegerField;
    qryRelGeralMensalVALOROFERTASCOMUNIDADE: TIBBCDField;
    qryRelGeralMensalVALOROFERTASESPECIAIS: TIBBCDField;
    qryRelGeralMensalVALOROUTRASOFERTAS: TIBBCDField;
    rbiRelGeralMensal: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppImage1: TppImage;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppLine1: TppLine;
    ppLine2: TppLine;
    OME: TppLabel;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppLine4: TppLine;
    ppSystemVariable1: TppSystemVariable;
    ppSystemVariable2: TppSystemVariable;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppLabel7: TppLabel;
    ppLabel8: TppLabel;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    ppLabel11: TppLabel;
    ppLine3: TppLine;
    ppDBText12: TppDBText;
    ppDBText13: TppDBText;
    ppDBText14: TppDBText;
    ppDBText16: TppDBText;
    ppDBText17: TppDBText;
    ppDBText18: TppDBText;
    ppDBText19: TppDBText;
    ppLabel12: TppLabel;
    ppLabel13: TppLabel;
    ppLabel14: TppLabel;
    ppLabel15: TppLabel;
    ppLabel16: TppLabel;
    ppLine5: TppLine;
    ppDBText15: TppDBText;
    ppDBText20: TppDBText;
    ppDBText21: TppDBText;
    ppLabel17: TppLabel;
    ppLabel18: TppLabel;
    ppVariable1: TppVariable;
    ppVariable2: TppVariable;
    ppVariable3: TppVariable;
    ppVariable4: TppVariable;
    ppVariable5: TppVariable;
    qryServoNOME: TIBStringField;
    GraficoRelGeral: TppTeeChart;
    edtDtInicial: TwwDBDateTimePicker;
    edtDtFinal: TwwDBDateTimePicker;
    rbiMensalDetalhado: TppReport;
    qryRelMensalDetalhadoD: TIBQuery;
    pipRelMensalDetalhadoD: TppDBPipeline;
    dtsRelMensalDetalhadoD: TDataSource;
    qryRelMensalDetalhadoO: TIBQuery;
    pipRelMensalDetalhadoO: TppDBPipeline;
    dtsRelMensalDetalhadoO: TDataSource;
    qryRelMensalDetalhadoDCODIGOREGISTRO: TIntegerField;
    qryRelMensalDetalhadoDCODIGOTURNO: TIntegerField;
    qryRelMensalDetalhadoDNOMETURNO: TIBStringField;
    qryRelMensalDetalhadoDNOMEDIZIMISTA: TIBStringField;
    qryRelMensalDetalhadoDCODIGORECEBEDOR: TIntegerField;
    qryRelMensalDetalhadoDNOMERECEBEDOR: TIBStringField;
    qryRelMensalDetalhadoDDATARECEBIMENTO: TDateField;
    qryRelMensalDetalhadoDDATAREFERENCIA: TDateField;
    qryRelMensalDetalhadoDVALOR: TIBBCDField;
    qryRelMensalDetalhadoDOBSERVACOES: TMemoField;
    ppParameterList1: TppParameterList;
    qryRelMensalDetalhadoOCODIGOREGISTRO: TIntegerField;
    qryRelMensalDetalhadoOCODIGOTURNO: TIntegerField;
    qryRelMensalDetalhadoONOMETURNO: TIBStringField;
    qryRelMensalDetalhadoOCODIGORECEBEDOR: TIntegerField;
    qryRelMensalDetalhadoONOMERECEBEDOR: TIBStringField;
    qryRelMensalDetalhadoODATARECEBIMENTO: TDateField;
    qryRelMensalDetalhadoODATAREFERENCIA: TDateField;
    qryRelMensalDetalhadoOVALOR: TIBBCDField;
    qryRelMensalDetalhadoOESPECIFICACAO: TIBStringField;
    qryRelMensalDetalhadoOCEO: TIBStringField;
    dtsEtiqueta: TDataSource;
    qryEtiqueta: TIBQuery;
    ppHeaderBand2: TppHeaderBand;
    ppImage2: TppImage;
    ppDBText9: TppDBText;
    ppDBText10: TppDBText;
    ppDBText11: TppDBText;
    ppLine6: TppLine;
    ppLine7: TppLine;
    ppLabel19: TppLabel;
    ppDBText22: TppDBText;
    ppDBText23: TppDBText;
    ppLine8: TppLine;
    ppLabel27: TppLabel;
    ppRegion2: TppRegion;
    ppLabel26: TppLabel;
    ppLabel25: TppLabel;
    ppLabel24: TppLabel;
    ppLabel23: TppLabel;
    ppLabel22: TppLabel;
    ppLabel21: TppLabel;
    ppLabel20: TppLabel;
    ppDetailBand2: TppDetailBand;
    ppDBText25: TppDBText;
    ppDBText26: TppDBText;
    ppDBText27: TppDBText;
    ppDBText28: TppDBText;
    ppDBText29: TppDBText;
    ppDBText30: TppDBText;
    ppDBText31: TppDBText;
    ppFooterBand2: TppFooterBand;
    ppLine9: TppLine;
    ppSystemVariable3: TppSystemVariable;
    ppSystemVariable4: TppSystemVariable;
    ppSummaryBand1: TppSummaryBand;
    ppSubReport1: TppSubReport;
    ppChildReport1: TppChildReport;
    ppTitleBand1: TppTitleBand;
    ppLine10: TppLine;
    ppLabel36: TppLabel;
    ppRegion3: TppRegion;
    ppLabel29: TppLabel;
    ppLabel30: TppLabel;
    ppLabel31: TppLabel;
    ppLabel35: TppLabel;
    ppDetailBand3: TppDetailBand;
    ppDBText33: TppDBText;
    ppDBText34: TppDBText;
    ppDBText35: TppDBText;
    ppDBText36: TppDBText;
    ppSummaryBand2: TppSummaryBand;
    ppLabel38: TppLabel;
    ppDBCalc4: TppDBCalc;
    ppLine14: TppLine;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppLabel32: TppLabel;
    ppDBText32: TppDBText;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppLabel37: TppLabel;
    ppDBCalc3: TppDBCalc;
    ppLine13: TppLine;
    raCodeModule1: TraCodeModule;
    ppLabel34: TppLabel;
    ppDBCalc2: TppDBCalc;
    ppLine12: TppLine;
    ppRegion1: TppRegion;
    ppLabel39: TppLabel;
    ppVariable6: TppVariable;
    ppGroup2: TppGroup;
    ppGroupHeaderBand2: TppGroupHeaderBand;
    ppLabel28: TppLabel;
    ppDBText24: TppDBText;
    ppGroupFooterBand2: TppGroupFooterBand;
    ppLabel33: TppLabel;
    ppDBCalc1: TppDBCalc;
    ppLine11: TppLine;
    raCodeModule2: TraCodeModule;
    qryRelMensalDetalhadoDCODIGODIZIMISTA: TIBStringField;
    rbiDemonstrativoAnoDizimista: TppReport;
    ppHeaderBand3: TppHeaderBand;
    ppImage3: TppImage;
    ppDBText37: TppDBText;
    ppDBText38: TppDBText;
    ppDBText39: TppDBText;
    ppLine15: TppLine;
    ppLine16: TppLine;
    ppLabel40: TppLabel;
    ppLine17: TppLine;
    ppDBText40: TppDBText;
    ppDBText41: TppDBText;
    ppDetailBand4: TppDetailBand;
    ppFooterBand3: TppFooterBand;
    ppLine18: TppLine;
    ppSystemVariable5: TppSystemVariable;
    ppSystemVariable6: TppSystemVariable;
    pipDemontrativoAnoDizimista: TppDBPipeline;
    dtsDemontrativoAnoDizimista: TDataSource;
    qryDemontrativoAnoDizimista: TIBQuery;
    qryDemontrativoAnoDizimistaCODIGO: TIntegerField;
    qryDemontrativoAnoDizimistaREFERENCIA: TIBStringField;
    qryDemontrativoAnoDizimistaNOME: TIBStringField;
    qryDemontrativoAnoDizimistaSITUACAO: TIntegerField;
    qryDemontrativoAnoDizimistaMES1: TIBBCDField;
    qryDemontrativoAnoDizimistaMES2: TIBBCDField;
    qryDemontrativoAnoDizimistaMES3: TIBBCDField;
    qryDemontrativoAnoDizimistaMES4: TIBBCDField;
    qryDemontrativoAnoDizimistaMES5: TIBBCDField;
    qryDemontrativoAnoDizimistaMES6: TIBBCDField;
    qryDemontrativoAnoDizimistaMES7: TIBBCDField;
    qryDemontrativoAnoDizimistaMES8: TIBBCDField;
    qryDemontrativoAnoDizimistaMES9: TIBBCDField;
    qryDemontrativoAnoDizimistaMES10: TIBBCDField;
    qryDemontrativoAnoDizimistaMES11: TIBBCDField;
    qryDemontrativoAnoDizimistaMES12: TIBBCDField;
    ppLabel41: TppLabel;
    ppLabel42: TppLabel;
    ppLabel43: TppLabel;
    Mes01: TppLabel;
    Mes02: TppLabel;
    Mes03: TppLabel;
    Mes04: TppLabel;
    Mes07: TppLabel;
    Mes08: TppLabel;
    Mes06: TppLabel;
    Mes05: TppLabel;
    Mes11: TppLabel;
    Mes12: TppLabel;
    Mes10: TppLabel;
    Mes09: TppLabel;
    ppDBText42: TppDBText;
    ppDBText43: TppDBText;
    ppDBText44: TppDBText;
    ppDBText45: TppDBText;
    ppDBText46: TppDBText;
    ppDBText47: TppDBText;
    ppDBText48: TppDBText;
    ppDBText49: TppDBText;
    ppDBText50: TppDBText;
    ppDBText51: TppDBText;
    ppDBText52: TppDBText;
    ppDBText53: TppDBText;
    ppDBText54: TppDBText;
    ppDBText55: TppDBText;
    ppDBText56: TppDBText;
    ppDBText57: TppDBText;
    ppLabel56: TppLabel;
    qryDemontrativoAnoDizimistaDATASITUACAO: TDateField;
    ppLine19: TppLine;
    qryEtiquetaCODIGO: TIntegerField;
    qryEtiquetaDATACADASTRO: TDateField;
    qryEtiquetaNOME: TIBStringField;
    qryEtiquetaNOMEPAI: TIBStringField;
    qryEtiquetaNOMEMAE: TIBStringField;
    qryEtiquetaSEXO: TIBStringField;
    qryEtiquetaNASCIMENTO: TDateField;
    qryEtiquetaCODIGOMUNICIPIONATURALIDADE: TIntegerField;
    qryEtiquetaESTADOCIVIL: TIntegerField;
    qryEtiquetaCODIGOPROFISSAO: TIntegerField;
    qryEtiquetaCODIGOTIPODOCUMENTO: TIntegerField;
    qryEtiquetaNUMERODOCUMENTO: TIBStringField;
    qryEtiquetaORGAOEMISSOR: TIBStringField;
    qryEtiquetaUFDOCUMENTO: TIBStringField;
    qryEtiquetaCPF: TIBStringField;
    qryEtiquetaCEP: TIBStringField;
    qryEtiquetaNUMERO: TIntegerField;
    qryEtiquetaCOMPLEMENTO: TIBStringField;
    qryEtiquetaTELRESIDENCIAL: TIBStringField;
    qryEtiquetaTELCELULAR: TIBStringField;
    qryEtiquetaTELCOMERCIAL: TIBStringField;
    qryEtiquetaTELRECADO: TIBStringField;
    qryEtiquetaPESSOARECADO: TIBStringField;
    qryEtiquetaEMAIL1: TIBStringField;
    qryEtiquetaEMAIL2: TIBStringField;
    qryEtiquetaOBSERVACAO: TMemoField;
    qryEtiquetaESCOLARIDADE: TIntegerField;
    qryEtiquetaCODIGOESTABELECIMENTO: TIntegerField;
    qryEtiquetaCODIGOSERIE: TIntegerField;
    qryEtiquetaSITUACAO: TIntegerField;
    qryEtiquetaDATASITUACAO: TDateField;
    qryEtiquetaCONJUGEDIZIMISTA: TIntegerField;
    qryEtiquetaNOMECONJUGE: TIBStringField;
    qryEtiquetaNASCIMENTOCONJUGE: TDateField;
    qryEtiquetaCODIGOCONJUGEDIZIMISTA: TIntegerField;
    qryEtiquetaINICIOCONTRIBUICAO: TDateField;
    qryEtiquetaVALORCONTRIBUICAO: TIBBCDField;
    qryEtiquetaDATACASAMENTO: TDateField;
    qryEtiquetaREFERENCIA: TIBStringField;
    qryEtiquetaENDERECO: TIBStringField;
    qryEtiquetaBAIRRO: TIBStringField;
    qryEtiquetaCIDADE: TIBStringField;
    qryEtiquetaUF: TIBStringField;
    qryEtiquetaCONJUGE: TIBStringField;
    qryEtiquetaNOMECASAL: TStringField;
    qryFinanceiroGeralDiario: TIBQuery;
    qryFinanceiroGeralDiarioD: TIBQuery;
    pipFinanceiroGeralDiarioD: TppDBPipeline;
    pipFinanceiroGeralDiario: TppDBPipeline;
    dtsFinanceiroGeralDiario: TDataSource;
    dtsFinanceiroGeralDiarioD: TDataSource;
    rbiFinanceiroGeralDiario: TppReport;
    ppParameterList2: TppParameterList;
    qryFinanceiroGeralDiarioVALORCONTRIBUICOES: TIBBCDField;
    qryFinanceiroGeralDiarioVALOROFERTASCOMUNIDADE: TIBBCDField;
    qryFinanceiroGeralDiarioVALORDOACOES: TIBBCDField;
    qryFinanceiroGeralDiarioVALORFESTAPADROEIRO: TIBBCDField;
    qryFinanceiroGeralDiarioVALORFESTAS: TIBBCDField;
    qryFinanceiroGeralDiarioVALORDOACOESESPECIFICAS: TIBBCDField;
    qryFinanceiroGeralDiarioVALORTAXAS: TIBBCDField;
    qryFinanceiroGeralDiarioDNOME: TIBStringField;
    qryFinanceiroGeralDiarioDVALORCOLETA: TIBBCDField;
    ppHeaderBand4: TppHeaderBand;
    ppSubReport2: TppSubReport;
    ppChildReport2: TppChildReport;
    ppDetailBand6: TppDetailBand;
    ppShape22: TppShape;
    ppShape23: TppShape;
    ppDBText80: TppDBText;
    ppDBText81: TppDBText;
    ppLabel87: TppLabel;
    ppLabel88: TppLabel;
    ppDBText82: TppDBText;
    ppDBText83: TppDBText;
    raCodeModule3: TraCodeModule;
    ppRegion4: TppRegion;
    ppLabel63: TppLabel;
    ppLabel64: TppLabel;
    ppLabel65: TppLabel;
    ppLabel66: TppLabel;
    ppLabel67: TppLabel;
    ppShape6: TppShape;
    ppShape7: TppShape;
    ppShape8: TppShape;
    ppShape9: TppShape;
    ppShape10: TppShape;
    ppLine27: TppLine;
    ppLine29: TppLine;
    ppLabel68: TppLabel;
    ppLabel69: TppLabel;
    ppLine28: TppLine;
    ppLabel78: TppLabel;
    ppLabel79: TppLabel;
    ppLabel80: TppLabel;
    ppLabel81: TppLabel;
    ppLabel82: TppLabel;
    ppShape16: TppShape;
    ppShape17: TppShape;
    ppShape18: TppShape;
    ppShape19: TppShape;
    ppShape20: TppShape;
    ppLine31: TppLine;
    ppLine32: TppLine;
    ppLabel83: TppLabel;
    ppLabel84: TppLabel;
    ppDBText74: TppDBText;
    ppDBText75: TppDBText;
    ppDBText76: TppDBText;
    ppDBText77: TppDBText;
    ppDBText78: TppDBText;
    ppDBText79: TppDBText;
    ppVariable11: TppVariable;
    ppVariable12: TppVariable;
    ppVariable13: TppVariable;
    ppVariable14: TppVariable;
    ppImage4: TppImage;
    ppDBText58: TppDBText;
    ppDBText59: TppDBText;
    ppDBText60: TppDBText;
    ppLine20: TppLine;
    ppLabel44: TppLabel;
    ppDBText61: TppDBText;
    ppLine21: TppLine;
    ppLabel45: TppLabel;
    ppLabel46: TppLabel;
    ppLabel47: TppLabel;
    ppLabel48: TppLabel;
    ppLine24: TppLine;
    ppImage5: TppImage;
    ppDBText62: TppDBText;
    ppDBText63: TppDBText;
    ppDBText64: TppDBText;
    ppLabel49: TppLabel;
    ppDBText65: TppDBText;
    ppLabel50: TppLabel;
    ppLabel51: TppLabel;
    ppLabel52: TppLabel;
    ppLabel53: TppLabel;
    ppLine22: TppLine;
    ppLine26: TppLine;
    ppLabel61: TppLabel;
    ppLabel62: TppLabel;
    ppLabel54: TppLabel;
    ppLabel55: TppLabel;
    ppLabel57: TppLabel;
    ppLabel58: TppLabel;
    ppLabel59: TppLabel;
    ppLabel60: TppLabel;
    ppShape1: TppShape;
    ppShape2: TppShape;
    ppShape3: TppShape;
    ppShape4: TppShape;
    ppShape5: TppShape;
    ppLabel70: TppLabel;
    ppLabel71: TppLabel;
    ppLabel72: TppLabel;
    ppLabel73: TppLabel;
    ppLabel74: TppLabel;
    ppLabel75: TppLabel;
    ppShape11: TppShape;
    ppShape12: TppShape;
    ppShape13: TppShape;
    ppShape14: TppShape;
    ppShape15: TppShape;
    ppLabel76: TppLabel;
    ppLabel77: TppLabel;
    ppShape21: TppShape;
    ppLine25: TppLine;
    ppDBText66: TppDBText;
    ppDBText67: TppDBText;
    ppDBText68: TppDBText;
    ppDBText69: TppDBText;
    ppDBText70: TppDBText;
    ppDBText71: TppDBText;
    ppDBText72: TppDBText;
    ppDBText73: TppDBText;
    ppVariable9: TppVariable;
    ppVariable10: TppVariable;
    ppDBText84: TppDBText;
    ppDBText85: TppDBText;
    ppDetailBand5: TppDetailBand;
    raCodeModule4: TraCodeModule;
    ppLabel85: TppLabel;
    ppLabel86: TppLabel;
    qryDizimistaSELECT: TIntegerField;
    qryServoSELECT: TIntegerField;
    qryTurnoSELECT: TIntegerField;
    grdDizimistas: TwwDBGrid;
    PopupMenu1: TPopupMenu;
    SelecionarTodos1: TMenuItem;
    DesfazerSeleo1: TMenuItem;
    ProcurarRegistro1: TMenuItem;
    grdServos: TwwDBGrid;
    grdTurnos: TwwDBGrid;
    qryDizimistaREFERENCIA: TIBStringField;
    qryServoREFERENCIA: TIBStringField;
    GroupBox2: TGroupBox;
    chbAtivo: TCheckBox;
    chbInativo: TCheckBox;
    chbFalecido: TCheckBox;
    CheckBox4: TCheckBox;
    chbAusente: TCheckBox;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cmbTipoChange(Sender: TObject);
    procedure ppVariable3Print(Sender: TObject);
    procedure ppVariable4Print(Sender: TObject);
    procedure ppVariable5Print(Sender: TObject);
    procedure ppVariable1Print(Sender: TObject);
    procedure ppVariable2Print(Sender: TObject);
    procedure OMEPrint(Sender: TObject);
    procedure ppImage1Print(Sender: TObject);
    procedure qryRelGeralMensalBeforeOpen(DataSet: TDataSet);
    procedure GraficoRelGeralPrint(Sender: TObject);
    procedure qryRelMensalDetalhadoDBeforeOpen(DataSet: TDataSet);
    procedure qryRelMensalDetalhadoOBeforeOpen(DataSet: TDataSet);
    procedure ppImage2Print(Sender: TObject);
    procedure qryEtiquetaBeforeOpen(DataSet: TDataSet);
    procedure ppVariable6Print(Sender: TObject);
    procedure ppLabel19Print(Sender: TObject);
    procedure ppDBText57GetText(Sender: TObject; var Text: string);
    procedure ppImage3Print(Sender: TObject);
    procedure ppDBText57DrawCommandCreate(Sender, aDrawCommand: TObject);
    procedure ppDBText57DrawCommandClick(Sender, aDrawCommand: TObject);
    procedure ppDBText42DrawCommandClick(Sender, aDrawCommand: TObject);
    procedure qryDemontrativoAnoDizimistaBeforeOpen(DataSet: TDataSet);
    procedure Mes01Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbAgrupamentoClick(Sender: TObject);
    procedure qryEtiquetaCalcFields(DataSet: TDataSet);
    procedure qryFinanceiroGeralDiarioBeforeOpen(DataSet: TDataSet);
    procedure qryFinanceiroGeralDiarioDBeforeOpen(DataSet: TDataSet);
    procedure rbiFinanceiroGeralDiarioBeforePrint(Sender: TObject);
    procedure ppImage4Print(Sender: TObject);
    procedure ppImage5Print(Sender: TObject);
    procedure ppDBText65GetText(Sender: TObject; var Text: string);
    procedure SelecionarTodos1Click(Sender: TObject);
    procedure DesfazerSeleo1Click(Sender: TObject);
    procedure cmbDizimistaEnter(Sender: TObject);
    procedure cmbServoEnter(Sender: TObject);
    procedure cmbTurnoEnter(Sender: TObject);
    procedure ProcurarRegistro1Click(Sender: TObject);
    procedure edtDtInicialDblClick(Sender: TObject);
  private
    Mes: array [1..12] of String;
    DadosGrafico: array of rDadosGrafico;
    FiltroServos,
    FiltroDizimista,
    FiltroDataContribuicao,
    FiltroDataOferta,
    FiltroDataCadastroDizimista,
    FiltroTurno,
    OrdenacaoContribuica,
    OrdenacaoOferta,
    OrdemDizimista,
    FiltroAuxiliar: String;
    FiltroTotalizadorDetalhadoDizimos,
    FiltroTotalizadorDetalhadoOfertas: String;
    procedure PreparaDadosGrafico;
    procedure CriarFiltros;
    Function  DataFormatoSQL(Data: TDate): String;
    Function  PrepararFiltroMultiSelecao(Tipo: String {D = Dizimista; S = Servo; T = Turno}): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFiltroFinanceiros: TfrmFiltroFinanceiros;

implementation

uses untRelLog, untDados;

{$R *.dfm}

Function TfrmFiltroFinanceiros.DataFormatoSQL(Data: TDate): String;
begin
  Result := #39+FormatDateTime('MM/DD/YYYY',Data)+#39 ;
end;

procedure TfrmFiltroFinanceiros.DesfazerSeleo1Click(Sender: TObject);
begin
  if grdDizimistas.Visible then
    grdDizimistas.UnselectAll
  else if grdServos.Visible then
    grdServos.UnselectAll
  else
    grdTurnos.UnselectAll;
end;

procedure TfrmFiltroFinanceiros.edtDtInicialDblClick(Sender: TObject);
begin
  GraficoRelGeral.Chart.Show;
end;

procedure TfrmFiltroFinanceiros.CriarFiltros;
begin
  FiltroServos := PrepararFiltroMultiSelecao('S');
  FiltroDizimista := PrepararFiltroMultiSelecao('D');
  FiltroTurno :=  PrepararFiltroMultiSelecao('T');

  FiltroDataContribuicao := '';
  FiltroDataOferta := '';
  FiltroDataCadastroDizimista := '';
  OrdenacaoContribuica := '';
  OrdenacaoOferta := '';
  OrdemDizimista := '';

  if FiltroServos <> '' then
    FiltroServos := ' and  S.codigo in (' + FiltroServos + ')'
  else if cmbServo.KeyValue > 0 then
    FiltroServos := ' and  S.codigo = ' + cmbServo.KeyValue;

  if FiltroDizimista <> '' then
    FiltroDizimista := ' and  D.codigo in (' + FiltroDizimista + ')'
  else if cmbDizimista.KeyValue > 0 then
    FiltroDizimista := ' and D.codigo = ' + cmbDizimista.KeyValue;

  if chbAtivo.checked then
    FiltroDizimista := ' and D.Situacao = 1';
  if chbInativo.checked then
    FiltroDizimista := ' and D.Situacao = 2';
  if chbFalecido.checked then
    FiltroDizimista := ' and D.Situacao = 3';
  if chbAusente.checked then
    FiltroDizimista := ' and D.Situacao = 4';

  if FiltroTurno <> '' then
    FiltroTurno := ' and  T.codigo in (' + FiltroTurno + ')'
  else if cmbTurno.KeyValue > 0 then
    FiltroTurno := ' and T.codigo = ' + cmbTurno.KeyValue;

  if (edtDtInicial.text <> '') and (edtDtFinal.text <> '') then
  begin
    FiltroDataContribuicao := ' and C.DataRegisto between '+DataFormatoSQL(edtDtInicial.Date)+' and '+ DataFormatoSQL(edtDtFinal.Date);
    FiltroDataOferta := ' and O.DataRegisto between '+DataFormatoSQL(edtDtInicial.Date)+' and '+ DataFormatoSQL(edtDtFinal.Date);
    FiltroDataCadastroDizimista := ' and D.DataCadastro between '+DataFormatoSQL(edtDtInicial.Date)+' and '+ DataFormatoSQL(edtDtFinal.Date);
  end;

  if ((edtDtInicial.text = '') and (edtDtFinal.text <> '')) or
     ((edtDtInicial.text <> '') and (edtDtFinal.text = '')) then
  begin
    if (edtDtFinal.text <> '') then
    begin
      FiltroDataContribuicao := ' and C.DataRegisto = '+ DataFormatoSQL(edtDtFinal.Date);
      FiltroDataOferta := ' and O.DataRegisto = '+ DataFormatoSQL(edtDtFinal.Date);
      FiltroDataCadastroDizimista := ' and D.DataCadastro = '+ DataFormatoSQL(edtDtFinal.Date);
    end;

    if (edtDtInicial.text <> '') then
    begin
      FiltroDataContribuicao := ' and C.DataRegisto = '+ DataFormatoSQL(edtDtInicial.Date);
      FiltroDataOferta := ' and O.DataRegisto = '+ DataFormatoSQL(edtDtInicial.Date);
      FiltroDataCadastroDizimista := ' and D.DataCadastro = '+ DataFormatoSQL(edtDtInicial.Date);
    end;
  end;

  if cmbTipo.ItemIndex = 1 then
  begin
    case rbOrdem.ItemIndex of
      0: OrdenacaoContribuica := ', C.Codigo';
      1: OrdenacaoOferta := ', D.Codigo';
      2: begin
           OrdenacaoOferta := ', S.Nome';
           OrdenacaoContribuica := ', S.Nome';
         end;
      3: OrdenacaoContribuica := ', C.DataRecebimento';
      4: begin
           OrdenacaoOferta := ', O.DataRegisto';
           OrdenacaoContribuica := ', C.DataRegisto';
         end;
    end;
  end
  else if cmbTipo.ItemIndex in [3,4,5] then
  begin
    case rbOrdem.ItemIndex of
      0: OrdemDizimista := 'order by 4';
      1: begin
           OrdemDizimista := 'order by D.Nome';
           if cmbTipo.itemindex = 4 then
             OrdemDizimista := 'order by E.Nome';
         end;
      2: OrdemDizimista := 'order by D.Cep';
      3: OrdemDizimista := 'order by C.Bairro';
      4: OrdemDizimista := 'order by M.Nome';
    end;
  end
  else if cmbTipo.ItemIndex in [6..14] then
  begin
    case rbOrdem.ItemIndex of
      0: OrdemDizimista := 'order by CODIGO';
      1: OrdemDizimista := 'order by NOME';
      2: OrdemDizimista := 'order by DATACADASTRO';
      3: OrdemDizimista := 'order by NASCIMENTO';
      4: OrdemDizimista := 'order by REFERENCIA';
      5: OrdemDizimista := 'order by 3';
    end;
  end;


end;

procedure TfrmFiltroFinanceiros.btn_okClick(Sender: TObject);
var
  Sql: String;
  vAux: String;
  vOriginal, vAlterado: String;
begin
  CriarFiltros;

  case cmbTipo.ItemIndex of
    0: begin
         qryRelGeralMensal.Close;
         qryRelGeralMensal.Open;

         rbiRelGeralMensal.Print;
       end;//GERAL;
    1: begin
         qryRelMensalDetalhadoD.Close;
         qryRelMensalDetalhadoD.Open;

         qryRelMensalDetalhadoO.Close;
         qryRelMensalDetalhadoO.Open;

         ppDetailBand2.Visible := True;
         ppDetailBand3.Visible := True;

         ppRegion2.Visible := True;
         ppRegion3.Visible := True;

         rbiMensalDetalhado.Print;
       end;//Detalhado;
    2: begin
         qryRelMensalDetalhadoD.Close;
         qryRelMensalDetalhadoD.Open;

         qryRelMensalDetalhadoO.Close;
         qryRelMensalDetalhadoO.Open;

         ppDetailBand2.Visible := False;
         ppDetailBand3.Visible := False;

         ppRegion2.Visible := False;
         ppRegion3.Visible := False;

         rbiMensalDetalhado.Print;
       end;//Resumido;
    3,4,5: begin
         if cmbTipo.ItemIndex = 4 then
           FiltroAuxiliar := ' and ((D.nomeconjuge is not null) or (E.nome is not null))'
         else
           FiltroAuxiliar := '';

         qryEtiqueta.Close;
         qryEtiqueta.Open;

//         if cmbTipo.ItemIndex = 3 then
//         begin
//           if rbAgrupamento.ItemIndex = 2 then
//             qr_etiq.QRDBText1.DataField := 'NOMECASAL'
//           else
//             qr_etiq.QRDBText1.DataField := 'Nome';
//           qr_etiq.preview
//         end
//         else if cmbTipo.ItemIndex = 4 then
//           qr_etiq_conj.preview
//         else if cmbTipo.ItemIndex = 5 then
//           tiras.preview;

       end;//Etiqueta Postal Dizimista / tiras Sorteio;
    6: begin
         Sql := 'select codigo, nome from tabdizimista D  '+
                'where 1=1  '+ FiltroDizimista + FiltroDataCadastroDizimista + OrdemDizimista;

         dados.ListaUniversal('Lista de Dizimistas sem Valor',
                              'Código',
                              'codigo',
                              'Nome',
                              'nome','','',sql);
       end;
    7: begin
         Sql := 'select codigo,  nome, valorcontribuicao from tabdizimista D  '+
                'where 1=1  '+ FiltroDizimista + FiltroDataCadastroDizimista  + OrdemDizimista;

         dados.ListaUniversal('Lista de Dizimistas com Valor',
                              'Código',
                              'codigo',
                              'Nome',
                              'nome',
                              'Valor',
                              'valorcontribuicao',sql,true,true);
       end;
    8: begin
         Sql := 'select codigo,  nome, datacadastro from tabdizimista D  '+
                'where 1=1  '+ FiltroDizimista + FiltroDataCadastroDizimista + OrdemDizimista;

         dados.ListaUniversal('Lista de Dizimistas com Data de Cadastro',
                              'Código',
                              'codigo',
                              'Nome',
                              'nome',
                              'Data de Cadastro',
                              'datacadastro',sql,true,False,true);
       end;
    9: begin
         Sql := 'select codigo,  nome, NASCIMENTO from tabdizimista D  '+
                'where 1=1  '+ FiltroDizimista + FiltroDataCadastroDizimista + OrdemDizimista;

         dados.ListaUniversal('Lista de Dizimistas com Data de Nascimento',
                              'Código',
                              'codigo',
                              'Nome',
                              'nome',
                              'Data de Nascimento',
                              'NASCIMENTO',sql,true,False,true);
       end;
    10: begin
         Sql := 'select codigo,  nome, ' +
                '(case when d.situacao = 1 then ''ATIVO'' else ' +
                'case when d.situacao = 2 then ''INATIVO'' else ' +
                'case when d.situacao = 3 then ''FALECIDO'' else  ' +
                'case when d.situacao = 4 then ''AUSENTE'' else '''' end end end end) AS SITUACAO from tabdizimista D  '+
                'where 1=1  '+ FiltroDizimista + FiltroDataCadastroDizimista  + OrdemDizimista;

         dados.ListaUniversal('Lista de Dizimistas com Situação',
                              'Código',
                              'codigo',
                              'Nome',
                              'nome',
                              'Situação',
                              'SITUACAO',sql,true);
       end;
    11: begin
         Sql := 'select codigo,  nome, referencia from tabdizimista D  '+
                'where 1=1  '+ FiltroDizimista + FiltroDataCadastroDizimista  + OrdemDizimista;

         dados.ListaUniversal('Lista de Dizimistas com Referencia',
                              'Código',
                              'codigo',
                              'Nome',
                              'nome',
                              'Referência',
                              'referencia',sql,true);
       end;
    12: begin
         if edtDtInicial.Text = '' then
         begin
           Application.MessageBox('Campo Data Inicial Obrigatório!'+#13+
                                  'Será definida a Data Atual.',
                                  'Campo Obrigatório',MB_OK+MB_ICONEXCLAMATION);
           edtDtInicial.Date := Date;
         end;

         Sql := 'select Coalesce(Referencia, Codigo) as codigo,nome, extract(Day from nascimento) as NASCIMENTO from tabdizimista D  '+
                'where 1=1 ' +
                'and extract(month from nascimento) = ' + FormatDateTime('mm', edtDtInicial.Date) + OrdemDizimista;

         case StrToInt(FormatDateTime('mm', edtDtInicial.Date)) of
           1: vAux := 'Janeiro';
           2: vAux := 'Fevereiro';
           3: vAux := 'Março';
           4: vAux := 'Abril';
           5: vAux := 'Maio';
           6: vAux := 'Junho';
           7: vAux := 'Julho';
           8: vAux := 'Agosto';
           9: vAux := 'Setembro';
           10: vAux := 'Outubro';
           11: vAux := 'Novembro';
           12: vAux := 'Dezembro';
         end;

         dados.ListaUniversal('Lista de Dizimistas Aniversariantes em ' + vAux,
                              'Referência',
                              'codigo',
                              'Nome',
                              'nome',
                              'Dia de Aniversario',
                              'NASCIMENTO',sql,true,False,False);
       end;
    13: begin
         if edtDtInicial.Text = '' then
         begin
           Application.MessageBox('Campo Data Inicial Obrigatório!'+#13+
                                  'Será definida a Data Atual.',
                                  'Campo Obrigatório',MB_OK+MB_ICONEXCLAMATION);
           edtDtInicial.Date := Date;
         end;

         Sql := 'select Coalesce(Referencia, Codigo) as codigo, nome || '' e '' || NOMECONJUGE as nome, DATACASAMENTO from tabdizimista D  '+
                'where 1=1 ' +
                'and extract(month from DATACASAMENTO) = ' + FormatDateTime('mm', edtDtInicial.Date) + OrdemDizimista;

         case StrToInt(FormatDateTime('mm', edtDtInicial.Date)) of
           1: vAux := 'Janeiro';
           2: vAux := 'Fevereiro';
           3: vAux := 'Março';
           4: vAux := 'Abril';
           5: vAux := 'Maio';
           6: vAux := 'Junho';
           7: vAux := 'Julho';
           8: vAux := 'Agosto';
           9: vAux := 'Setembro';
           10: vAux := 'Outubro';
           11: vAux := 'Novembro';
           12: vAux := 'Dezembro';
         end;

         dados.ListaUniversal('Lista de Dizimistas Aniversariantes de Casamento em ' + vAux,
                              'Referência',
                              'codigo',
                              'Casal',
                              'nome',
                              'Dia de Casamento',
                              'DATACASAMENTO',sql,true,False,True);
       end;
    14: begin
         if edtDtInicial.Text = '' then
         begin
           Application.MessageBox('Campo Data Inicial Obrigatório!'+#13+
                                  'Será definido o primeiro dia do Ano.',
                                  'Campo Obrigatório',MB_OK+MB_ICONEXCLAMATION);
           edtDtInicial.Date := StrToDate('01/01/'+FormatDateTime('yyyy',Date));
         end;

         qryDemontrativoAnoDizimista.Close;
         qryDemontrativoAnoDizimista.Open;

         rbiDemonstrativoAnoDizimista.Print;
       end;//Resumido;
    15: begin
          if edtDtInicial.Text = '' then
          begin
            Application.MessageBox('Campo Data Inicial Obrigatório!'+#13+
                                   'Será definida a Data Atual.',
                                   'Campo Obrigatório',MB_OK+MB_ICONEXCLAMATION);
            edtDtInicial.Date := Date;
          end;

//          vOriginal := IntToStr(dados.tblConfigSEQUENCIADEMONSTRATIVORECEITA.AsInteger + 1);

          if dados.tblConfigNAOALTERASEQDEMORECIMPRESSAO.AsInteger = 1 then
            vAlterado := vOriginal
          else
          begin
            case application.messagebox('Deseja Informar o Numero do Demonstrativo?', 'Pergunta', MB_YESNOCANCEL + MB_ICONQUESTION) of
              IDYES : vAlterado := Dados.DigitarValor('Numero do Recibo:', vOriginal);
              IDNO  : vAlterado := vOriginal;
            ELSE
              Abort;
            end;
          end;

          if vAlterado = '' then
            Abort;

          if vOriginal = vAlterado then
          begin
            dados.tblConfig.Edit;
              dados.tblConfigSEQUENCIADEMONSTRATIVORECEITA.AsInteger := dados.tblConfigSEQUENCIADEMONSTRATIVORECEITA.AsInteger + 1;
            dados.tblConfig.Post;
          end
          else
          begin
            dados.tblConfig.Edit;
              dados.tblConfigSEQUENCIADEMONSTRATIVORECEITA.AsInteger := strtoint(vAlterado);
            dados.tblConfig.Post;
          end;

          qryFinanceiroGeralDiario.Close;
          qryFinanceiroGeralDiario.Open;

          qryFinanceiroGeralDiarioD.Close;
          qryFinanceiroGeralDiarioD.Open;

          rbiFinanceiroGeralDiario.Print;

          if vOriginal <> vAlterado then
          begin
            dados.tblConfig.Edit;
              dados.tblConfigSEQUENCIADEMONSTRATIVORECEITA.AsInteger := strtoint(vOriginal)-1;
            dados.tblConfig.Post;
          end;

       end;
  end;
end;

procedure TfrmFiltroFinanceiros.PreparaDadosGrafico;
var
  Mes,
  Ano,
  i, y: Integer;
  DtInicial,
  DtFinal: TDate;
begin
  Mes := StrToInt(FormatDateTime('mm', edtDtInicial.Date)) + 1;
  Ano := StrToInt(FormatDateTime('yyyy', edtDtInicial.Date)) - 1;

  if mes = 13 then
  begin
    mes := 1;
    Ano := Ano + 1;
  end;

  y := 0 ;

  for i := 0 to 11 do
  begin
    DtInicial := StrToDate('01/'+IntToStr(mes)+'/'+IntToStr(Ano));
    DtFinal   := Data_Ultimo_Dia_Mes(DtInicial);

    dados.Geral.close;
    dados.Geral.sql.Text := 'Select sum(c.valor) as Valor '+
                            ' from tabcontribuicao c '+
                            ' where c.datarecebimento between '+#39+FormatDateTime('mm/dd/yyyy', DtInicial)+#39+' and '+#39+FormatDateTime('mm/dd/yyyy', DtFinal)+#39;
    dados.Geral.Open;
    if dados.Geral.FieldByName('Valor').AsCurrency > 0 then
    begin
      inc(y);
      SetLength(DadosGrafico, y);
      DadosGrafico[y-1].MesAno := FormatDateTime('mm/yyyy', DtInicial);
      DadosGrafico[y-1].Valor  := dados.Geral.FieldByName('Valor').Value;
    end;
    dados.Geral.close;

    inc(Mes);
    if mes = 13 then
    begin
      mes := 1;
      Ano := Ano + 1;
    end;
  end;
end;

procedure TfrmFiltroFinanceiros.ProcurarRegistro1Click(Sender: TObject);
var
  Digitado: String;
  Campo: String;
  Resultado: Boolean;
begin
  Campo := 'NOME';

  if grdDizimistas.Visible then
    Digitado := Dados.DigitarValor('Digite o Dizimista. Obs.: Inicie com #R para Ref.', '')
  else if grdServos.visible then
    Digitado := Dados.DigitarValor('Digite o Servo. Obs.: Inicie com #R para Ref.', '')
  else
    Digitado := Dados.DigitarValor('Digite o Turno. Obs.: Inicie com #C para Cód.', '');

  if COPY(Digitado,1,2) = '#C' then
  begin
    Campo := 'CODIGO';
    Digitado := COPY(Digitado,3, length(Digitado)-1);
  end
  else if COPY(Digitado,1,2) = '#R' then
  begin
    Campo := 'REFERENCIA';
    Digitado := COPY(Digitado,3, length(Digitado)-1);
  end;

  if grdDizimistas.Visible then
  begin
    Resultado := qryDizimista.LocateNext(Campo, Digitado, []);
    if not Resultado then
      Resultado := qryDizimista.Locate(Campo, Digitado, []);
  end
  else if grdServos.Visible then
  begin
    Resultado := qryServo.LocateNext(Campo, Digitado, []);
    if not Resultado then
      Resultado := qryServo.Locate(Campo, Digitado, []);
  end
  else
  begin
    Resultado := qryTurno.LocateNext(Campo, Digitado, []);
    if not Resultado then
      Resultado := qryTurno.Locate(Campo, Digitado, []);
  end;

  if not Resultado then
    Application.MessageBox('Registro não encontrado!', 'Consulta', MB_OK + MB_ICONEXCLAMATION);

end;

procedure TfrmFiltroFinanceiros.OMEPrint(Sender: TObject);
begin
  OME.Caption :=  'Relatório de recebimento do Dízimo no mês: ' + FormatDateTime('mm/yyyy', edtDtInicial.Date);
end;

procedure TfrmFiltroFinanceiros.ppDBText42DrawCommandClick(Sender,
  aDrawCommand: TObject);
begin
  Dados.AbrirCadastroDizimista(StrToInt(TppDrawCommand(aDrawCommand).ExpansionKey));
end;

procedure TfrmFiltroFinanceiros.ppDBText57DrawCommandClick(Sender,
  aDrawCommand: TObject);
begin
  Dados.AlteraSituacaoDizimista(TppDrawCommand(aDrawCommand).ExpansionKey);
end;

procedure TfrmFiltroFinanceiros.ppDBText57DrawCommandCreate(Sender,
  aDrawCommand: TObject);
begin
  TppDrawCommand(aDrawCommand).ExpansionKey := qryDemontrativoAnoDizimistaCODIGO.Text;
end;

procedure TfrmFiltroFinanceiros.ppDBText57GetText(Sender: TObject;
  var Text: string);
begin
  case StrToInt(Text) of
    1 : Text := 'AT';
    2 : Text := 'IN';
    3 : Text := 'FA';
    4 : Text := 'AU';
  end; 
end;

procedure TfrmFiltroFinanceiros.ppDBText65GetText(Sender: TObject;
  var Text: string);
begin
  Text := 'CNPJ.: ' + Text;
end;

procedure TfrmFiltroFinanceiros.ppImage1Print(Sender: TObject);
begin
  Dados.GetImage(ppImage1);
end;

procedure TfrmFiltroFinanceiros.ppImage2Print(Sender: TObject);
begin
  Dados.GetImage(ppImage2);
end;

procedure TfrmFiltroFinanceiros.ppImage3Print(Sender: TObject);
begin
  Dados.GetImage(ppImage3);
end;

procedure TfrmFiltroFinanceiros.ppImage4Print(Sender: TObject);
begin
  Dados.GetImage(ppImage4);
end;

procedure TfrmFiltroFinanceiros.ppImage5Print(Sender: TObject);
begin
  Dados.GetImage(ppImage5);
end;

procedure TfrmFiltroFinanceiros.ppLabel19Print(Sender: TObject);
var TestoComplementar: String;
begin
  if (edtDtInicial.text <> '') and (edtDtFinal.text <> '') then
    TestoComplementar := ' - Periodo: '+ edtDtInicial.text + ' à ' + edtDtFinal.text
  else if ((edtDtInicial.text = '') and (edtDtFinal.text <> '')) or
     ((edtDtInicial.text <> '') and (edtDtFinal.text = '')) then
  begin
    if (edtDtFinal.text <> '') then
      TestoComplementar := ' - Data: '+ edtDtFinal.text
    else if (edtDtInicial.text <> '') then
      TestoComplementar := ' - Data: '+ edtDtInicial.text;
  end;
  ppLabel19.Caption := 'Relatório detalhado dos recebimentos'+ TestoComplementar
end;

procedure TfrmFiltroFinanceiros.Mes01Print(Sender: TObject);
begin
  try
    (Sender as TppLabel).Caption := Mes[StrToInt(Copy((Sender as TppLabel).Name,4,2))];
  except

  end;
end;

procedure TfrmFiltroFinanceiros.ppVariable1Print(Sender: TObject);
begin
  ppVariable1.value := qryRelGeralMensalVALOROFERTASCOMUNIDADE.AsCurrency +
                       qryRelGeralMensalVALOROFERTASESPECIAIS.AsCurrency +
                       qryRelGeralMensalVALOROUTRASOFERTAS.AsCurrency;
end;

procedure TfrmFiltroFinanceiros.ppVariable2Print(Sender: TObject);
begin
  ppVariable2.value := (qryRelGeralMensalVALOROFERTASCOMUNIDADE.AsCurrency +
                       qryRelGeralMensalVALOROFERTASESPECIAIS.AsCurrency +
                       qryRelGeralMensalVALOROUTRASOFERTAS.AsCurrency)+qryRelGeralMensalVALORCONTRIBUICOES.AsCurrency;
end;

procedure TfrmFiltroFinanceiros.ppVariable3Print(Sender: TObject);
begin
  try
    ppVariable3.Value := qryRelGeralMensalVALORCONTRIBUICOES.AsCurrency * 100 / qryRelGeralMensalVALORCONTRIBUICOESMESANTERIOR.AsCurrency;
  except
    ppVariable3.Value := 0;
  end;
end;

procedure TfrmFiltroFinanceiros.ppVariable4Print(Sender: TObject);
begin
  try
    ppVariable4.Value := qryRelGeralMensalVALORCONTRIBUICOES.AsCurrency * 100 / qryRelGeralMensalVALORCONTRIBUICOESMESANOANTERIO.AsCurrency;
  except
    ppVariable4.Value := 0;
  end;
end;

procedure TfrmFiltroFinanceiros.ppVariable5Print(Sender: TObject);
begin
  try
    ppVariable5.Value := qryRelGeralMensalVALORCONTRIBUICOESANO.AsCurrency * 100 / qryRelGeralMensalVALORCONTRIBUICOESANOANTERIOR.AsCurrency;
  except
    ppVariable5.Value := 0;
  end;
end;

procedure TfrmFiltroFinanceiros.ppVariable6Print(Sender: TObject);
begin
  Dados.Geral.Close;
  Dados.Geral.Sql.Text := 'Select ( '+
                          '  Select  ' +
                          '  sum(c.valor) '+
                          '  from tabcontribuicao C  '+
                          '  left join tabdizimista D on C.codigodizimista = D.codigo  '+
                          '  left join tabdizimista S on S.eServo = 1 and C.codigorecebedor = S.codigo  '+
                          '  left join tabturnos T on C.turno = T.codigo  '+
                          '  where 1=1 '+
                          FiltroTotalizadorDetalhadoDizimos +
                          '  ) + ( ' +
                          '  Select ' +
                          '  sum(o.valor) ' +
                          '  from tabofertas O  ' +
                          '  left join tabdizimista S on S.eServo = 1 and O.codigoservo = S.codigo ' +
                          '  left join tabturnos T on o.turno = T.codigo ' +
                          '  where 1=1 '+
                          FiltroTotalizadorDetalhadoOfertas +
                          '  ) as Total ' +
                          '  from RDB$DATABASE';
  Dados.Geral.Open;
  ppVariable6.Value :=  Dados.Geral.FieldByName('Total').Value;
end;

procedure TfrmFiltroFinanceiros.qryDemontrativoAnoDizimistaBeforeOpen(
  DataSet: TDataSet);
var
  I : Integer;
  DataCorrente : TDateTime;
begin
  DataCorrente := edtDtInicial.Date;

  for I := 1 to 12 do
   Mes[I] := '';

  for I := 1 to 12 do
  begin
    Mes[I] := FormatDateTime('mm/yyyy', DataCorrente);
    qryDemontrativoAnoDizimista.SQL.Strings[I + 5] :=
    '(Select sum(c.valor) from tabcontribuicao c where c.codigodizimista = D.codigo '+
    'and c.datarecebimento between '#39+FormatDateTime('mm', DataCorrente)+'/01/'+FormatDateTime('yyyy', DataCorrente)+ #39+
    ' and '+#39+FormatDateTime('mm/dd/yyyy', Data_Ultimo_Dia_Mes(DataCorrente))+#39+') as Mes'+IntToStr(I)+iif(I = 12,'',',');

    DataCorrente := DataCorrente + 31;
  end;                                                                                                         
  qryDemontrativoAnoDizimista.SQL.Strings[qryDemontrativoAnoDizimista.SQL.IndexOf('where 1=1')+1] := FiltroDizimista;
  qryDemontrativoAnoDizimista.SQL.Strings[qryDemontrativoAnoDizimista.SQL.IndexOf('where 1=1')+2] := OrdemDizimista;
end;

procedure TfrmFiltroFinanceiros.qryEtiquetaBeforeOpen(DataSet: TDataSet);
var
  FiltroData, FiltroAuxiliar2: String;
begin

  if (rbAgrupamento.ItemIndex in [1,2]) and (edtDtInicial.text <> '') then
  begin
    if cmbTipo.ItemIndex in [3,5] then
    begin
      if rbAgrupamento.ItemIndex = 2 then
        FiltroData :=  'and extract(month from d.DATACASAMENTO) = ' + FormatDateTime('mm', edtDtInicial.Date)
      else
        FiltroData :=  'and extract(month from d.nascimento) = ' + FormatDateTime('mm', edtDtInicial.Date);
    end
    else if cmbTipo.ItemIndex = 4 then
      FiltroData :=  'and extract(month from d.NASCIMENTOCONJUGE) = ' + FormatDateTime('mm', edtDtInicial.Date);
  end
  else
    FiltroData := FiltroDataCadastroDizimista;

  if rbAgrupamento.ItemIndex = iif(cmbTipo.ItemIndex = 3,3,2) then
    FiltroAuxiliar2 := ' and d.SITUACAO = 1 '
  else if rbAgrupamento.ItemIndex = iif(cmbTipo.ItemIndex = 3,4,3) then
    FiltroAuxiliar2 := ' and d.SITUACAO = 2 '
  else
    FiltroAuxiliar2 := '';

  qryEtiqueta.SQL.Strings[qryEtiqueta.SQL.IndexOf('where 1=1')+1] := FiltroDizimista +
                                                                     FiltroData +
                                                                     FiltroAuxiliar+
                                                                     FiltroAuxiliar2;

  qryEtiqueta.SQL.Strings[qryEtiqueta.SQL.IndexOf('--order')+1] := OrdemDizimista;
end;

procedure TfrmFiltroFinanceiros.qryEtiquetaCalcFields(DataSet: TDataSet);
begin
  qryEtiquetaNOMECASAL.text := Copy(qryEtiquetaNOME.text,1,Pos(' ',qryEtiquetaNOME.text)-1) + ' e ' + Copy(qryEtiquetaCONJUGE.text,1,Pos(' ',qryEtiquetaCONJUGE.text)-1);
end;

procedure TfrmFiltroFinanceiros.qryFinanceiroGeralDiarioBeforeOpen(
  DataSet: TDataSet);
begin
  qryFinanceiroGeralDiario.ParamByName('data').AsDateTime := edtDtInicial.DateTime;
end;

procedure TfrmFiltroFinanceiros.qryFinanceiroGeralDiarioDBeforeOpen(
  DataSet: TDataSet);
begin
  qryFinanceiroGeralDiarioD.ParamByName('data').AsDateTime := edtDtInicial.DateTime;
end;

procedure TfrmFiltroFinanceiros.qryRelGeralMensalBeforeOpen(DataSet: TDataSet);
var
  MesAnterior: String;
begin
  if StrToInt(FormatDateTime('mm',edtDtInicial.Date)) = 1 then
    MesAnterior := '12'
  else
    MesAnterior := IntToStr(StrToInt(FormatDateTime('mm',edtDtInicial.Date)) - 1);

  qryRelGeralMensal.ParamByName('DTINICIOPERIODO').AsDate := DataValida(edtDtInicial.Text);
  qryRelGeralMensal.ParamByName('DTFIMPERIODO'   ).AsDate := DataValida(edtDtFinal.Text);
  qryRelGeralMensal.ParamByName('DTINICIOANO'    ).AsDate := StrToDate('01/01/'+FormatDateTime('yyyy',edtDtInicial.Date));

  qryRelGeralMensal.ParamByName('DTINICIOMESANTERIOR'   ).AsDate := DataValida(FormatDateTime('dd',edtDtInicial.Date)+'/'+
                                                                               MesAnterior+'/'+
                                                                               FormatDateTime('yyyy',edtDtInicial.Date));

  qryRelGeralMensal.ParamByName('DTFIMMESANTERIOR'      ).AsDate := DataValida(FormatDateTime('dd',edtDtFinal.Date)+'/'+
                                                                               MesAnterior+'/'+
                                                                               FormatDateTime('yyyy',edtDtFinal.Date));

  qryRelGeralMensal.ParamByName('DTINICIOMESANOANTERIOR').AsDate := DataValida(FormatDateTime('DD/MM',edtDtInicial.Date)+'/'+INTTOSTR(STRTOINT(FormatDateTime('yyyy',edtDtInicial.Date))-1));
  qryRelGeralMensal.ParamByName('DTFIMMESANOANTERIOR'   ).AsDate := DataValida(FormatDateTime('DD/MM',edtDtFinal.Date)+'/'+INTTOSTR(STRTOINT(FormatDateTime('yyyy',edtDtFinal.Date))-1));
  qryRelGeralMensal.ParamByName('DTINICIOANOANTERIOR').AsDate := StrToDate('01/01/'+INTTOSTR(STRTOINT(FormatDateTime('yyyy',edtDtInicial.Date))-1));
  qryRelGeralMensal.ParamByName('DTFIMANOANTERIOR'   ).AsDate := StrToDate('01/12/'+INTTOSTR(STRTOINT(FormatDateTime('yyyy',edtDtFinal.Date))-1));
  qryRelGeralMensal.ParamByName('COMUNIDADE'         ).Value := Dados.CodigoComunidadeCorrente;
end;

procedure TfrmFiltroFinanceiros.qryRelMensalDetalhadoDBeforeOpen(
  DataSet: TDataSet);
begin
  qryRelMensalDetalhadoD.SQL.Strings[qryRelMensalDetalhadoD.SQL.IndexOf('--Filtro')+1] := FiltroDizimista +
                                                                                          FiltroServos +
                                                                                          FiltroDataContribuicao +
                                                                                          FiltroTurno;

  qryRelMensalDetalhadoD.SQL.Strings[qryRelMensalDetalhadoD.SQL.IndexOf('--order')+1] := OrdenacaoContribuica;

  FiltroTotalizadorDetalhadoDizimos := FiltroDizimista +
                                       FiltroServos +
                                       FiltroDataContribuicao +
                                       FiltroTurno;
end;

procedure TfrmFiltroFinanceiros.qryRelMensalDetalhadoOBeforeOpen(
  DataSet: TDataSet);
begin
  qryRelMensalDetalhadoO.SQL.Strings[qryRelMensalDetalhadoO.SQL.IndexOf('--Filtro')+1] := FiltroServos +
                                                                                          FiltroDataOferta +
                                                                                          FiltroTurno;

  qryRelMensalDetalhadoO.SQL.Strings[qryRelMensalDetalhadoO.SQL.IndexOf('--order')+1] := OrdenacaoOferta;

  FiltroTotalizadorDetalhadoOfertas := FiltroServos +
                                       FiltroDataOferta +
                                       FiltroTurno;
end;

procedure TfrmFiltroFinanceiros.rbAgrupamentoClick(Sender: TObject);
begin
  lblDtFinal.Enabled := not (
                             ((cmbTipo.ItemIndex in [4,5]) and (rbAgrupamento.ItemIndex = 1))
                             or
                             ((cmbTipo.ItemIndex = 3) and (rbAgrupamento.ItemIndex in [1,2]))
                            );
  edtDtFinal.Enabled := lblDtFinal.Enabled;
end;

procedure TfrmFiltroFinanceiros.rbiFinanceiroGeralDiarioBeforePrint(
  Sender: TObject);
begin
  pplabel85.Caption := edtDtInicial.text;
  pplabel86.Caption := edtDtInicial.text;
end;

procedure TfrmFiltroFinanceiros.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFiltroFinanceiros.FormCreate(Sender: TObject);
begin
  cmbTipo.Items.Add('00 - Geral');
  cmbTipo.Items.Add('01 - Relatório Detalhado dos Recebimentos');
  cmbTipo.Items.Add('02 - Relatório Resumido dos Recebimentos');
  cmbTipo.Items.Add('03 - Etiqueta Postal do Dizimista');
  cmbTipo.Items.Add('04 - Etiqueta Postal do Conjuge');
  cmbTipo.Items.Add('05 - Tiras para Sorteio');
  cmbTipo.Items.Add('06 - Lista de Dizimistas sem Valor');
  cmbTipo.Items.Add('07 - Lista de Dizimistas com Valor');
  cmbTipo.Items.Add('08 - Lista de Dizimistas com Data de Cadastro');
  cmbTipo.Items.Add('09 - Lista de Dizimistas com Data de Nascimento');
  cmbTipo.Items.Add('10 - Lista de Dizimistas com Situação');
  cmbTipo.Items.Add('11 - Lista de Dizimistas com Referência');
  cmbTipo.Items.Add('12 - Lista de Dizimistas Aniversariantes');
  cmbTipo.Items.Add('13 - Lista de Dizimistas Aniversariantes de Casamento');
  cmbTipo.Items.Add('14 - Demosntrativo Anual do Dizimista');
  cmbTipo.Items.Add('15 - Demosntrativo da Receita');
  width := 857;
end;

procedure TfrmFiltroFinanceiros.FormShow(Sender: TObject);
begin
  try
    qryDizimista.Close;
    qryDizimista.Open;
    qryServo.Close;
    qryServo.Open;
    qryTurno.Close;
    qryTurno.Open;
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmFiltroFinanceiros.GraficoRelGeralPrint(Sender: TObject);
var
  i : integer;
begin
  PreparaDadosGrafico;
  GraficoRelGeral.Chart.Series[0].Clear;
  for I := 0 to length(DadosGrafico)-1 do
    GraficoRelGeral.Chart.Series[0].Add(DadosGrafico[I].Valor,DadosGrafico[I].MesAno)
end;

procedure TfrmFiltroFinanceiros.SelecionarTodos1Click(Sender: TObject);
begin
  if grdDizimistas.Visible then
    grdDizimistas.SelectAll
  else if grdServos.Visible then
    grdServos.SelectAll
  else
    grdTurnos.SelectAll;
end;

procedure TfrmFiltroFinanceiros.SpeedButton1Click(Sender: TObject);
begin
  edtDtInicial.Clear;
  edtDtFinal.Clear;
end;

procedure TfrmFiltroFinanceiros.cmbDizimistaEnter(Sender: TObject);
begin
  grdDizimistas.Visible := True;
  grdServos.Visible := False;
  grdTurnos.Visible := False;
end;

procedure TfrmFiltroFinanceiros.cmbServoEnter(Sender: TObject);
begin
  grdDizimistas.Visible := False;
  grdServos.Visible := True;
  grdTurnos.Visible := False;
  grdServos.left := grdDizimistas.left;
end;

procedure TfrmFiltroFinanceiros.cmbTipoChange(Sender: TObject);
begin

  lblDtFinal.Enabled := not (cmbTipo.ItemIndex in [12,13,14,15]);
  EdtDtFinal.Enabled := not (cmbTipo.ItemIndex in [12,13,14,15]);

  rbAgrupamento.Caption := iif(cmbTipo.ItemIndex in [3,4,5], ' Modelo ', ' Agrupamento ');
  rbAgrupamento.Enabled := cmbTipo.ItemIndex in [3,4,5];
  rbOrdem.Enabled       := cmbTipo.ItemIndex > 0;
  //untDados.RelParcFinanceiroLiquidados := cmbTipo.ItemIndex = 0;
  //edtDtInicial.Enabled    := cmbTipo.ItemIndex <> 2;
  if cmbTipo.itemindex = 1 then
  begin
    rbOrdem.Items.Clear;
    rbOrdem.Items.Add('Código');
    rbOrdem.Items.Add('Dizimista');
    rbOrdem.Items.Add('Operador');
    rbOrdem.Items.Add('Data Venc.');
    rbOrdem.Items.Add('Data Rec.');
  end
  else if cmbTipo.itemindex in [3,4,5] then
  begin
    rbOrdem.Items.Clear;
    rbOrdem.Items.Add('Código');
    rbOrdem.Items.Add('Nome');
    rbOrdem.Items.Add('Cep');
    rbOrdem.Items.Add('Bairro');
    rbOrdem.Items.Add('Cidade');

    rbAgrupamento.Items.Clear;
    rbAgrupamento.Items.Add('Todos Dizimistas');
    rbAgrupamento.Items.Add('Aniversariantes');
    if cmbTipo.itemindex = 3 then
      rbAgrupamento.Items.Add('Aniv. Casamento');
    rbAgrupamento.Items.Add('Todos Ativos');
    rbAgrupamento.Items.Add('Todos Inativos');

  end
  else if cmbTipo.ItemIndex in [6..14] then
  begin
    rbOrdem.Items.Clear;
    rbOrdem.Items.Add('Código');
    rbOrdem.Items.Add('Nome');
    rbOrdem.Items.Add('Data Cadastro');
    rbOrdem.Items.Add('Data Nascimento');
    rbOrdem.Items.Add('Referência');
    if cmbTipo.ItemIndex = 13 then
      rbOrdem.Items.Add('Data Casamento')
    else
      rbOrdem.Items.Add('Situação');
  end;


  rbOrdem.ItemIndex := 0;
end;

procedure TfrmFiltroFinanceiros.cmbTurnoEnter(Sender: TObject);
begin
  grdDizimistas.Visible := False;
  grdServos.Visible := False;
  grdTurnos.Visible := True;
  grdTurnos.left := grdDizimistas.left;
end;

Function TfrmFiltroFinanceiros.PrepararFiltroMultiSelecao(Tipo: String {D = Dizimista; S = Servo; T = Turno}): String;
Var
  Filtro: String;
  i : Integer;
begin
  Filtro := '';
  if Tipo = 'D' then
  begin
    with grdDizimistas, qryDizimista do
    begin
      DisableControls;
      for i := 0 to SelectedList.Count - 1 do
      begin
        GotoBookmark(SelectedList.items[i]);
        Freebookmark(SelectedList.items[i]);
        Filtro := Filtro +iif(Filtro <> '', ',', '')+ qryDizimistaCODIGO.Text;
      end;
      //UnselectAll;
      SelectedList.Clear;
      EnableControls;
    end;
  end
  else if Tipo = 'S' then
  begin
    with grdServos, qryServo do
    begin
      DisableControls;
      for i := 0 to SelectedList.Count - 1 do
      begin
        GotoBookmark(SelectedList.items[i]);
        Freebookmark(SelectedList.items[i]);
        Filtro := Filtro +iif(Filtro <> '', ',', '')+ qryServoCODIGO.Text;
      end;
      //UnselectAll;
      SelectedList.Clear;
      EnableControls;
    end;
  end
  else if Tipo = 'T' then
  begin
    with grdTurnos, qryTurno do
    begin
      DisableControls;
      for i := 0 to SelectedList.Count - 1 do
      begin
        GotoBookmark(SelectedList.items[i]);
        Freebookmark(SelectedList.items[i]);
        Filtro := Filtro +iif(Filtro <> '', ',', '')+ qryTurnoCODIGO.Text;
      end;
      //UnselectAll;
      SelectedList.Clear;
      EnableControls;
    end;
  end;
  Result := Filtro;
end;

end.
