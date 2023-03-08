unit FrmMain;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, iniFiles, ComCtrls, DB, DBClient, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,

  cxGridBandedTableView, cxGridDBBandedTableView,
  cxHint, cxDBExtLookupComboBox, cxContainer, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxEditRepositoryItems, cxImage, cxImageComboBox, StdCtrls, Mask, SOAPHTTPClient,
  Buttons, uThrdImport, uThrdExport, ActiveX, Grids, DBGrids, Spin, ADODB,
  ShlObj, COMObj, Tabs, StrUtils,

  SBUtils, SBSimpleSftp, SBSSHKeyStorage, SBSSHConstants, SBSftpCommon, SBTypes,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, CheckLst;

const
  cRC = #13#10;
  cReceiveTimeoutWS = 600000; // 1000 * 60 * 10 => 10 min par defaut
  cFileMaxLines = 10000; // 10 000 lignes par defaut

  cSecParam       = 'PARAMS';
  cSecParamSFTP   = 'PARAMSFTP';
  cSecParamImport = 'PARAMIMPORT';
  cSecParamExport = 'PARAMEXPORT';

  cItmPASSWORDWS = 'PASSWORDWS';
  cItmURLDWS = 'URLWS';
  cItmTimeOutWS = 'TIMEOUTWS';
  cItmLOGIN = 'LOGIN';
  cItmPASSWORD = 'PASSWORD';
  cItmREPFTPDISTANTIMPGOS = 'REPFTPDISTANTIMPGOS';
  cItmREPFTPDISTANTEXPGOS = 'REPFTPDISTANTEXPGOS';
  cItmREPFTPDISTANTIMPCOU = 'REPFTPDISTANTIMPCOU';
  cItmREPFTPDISTANTEXPCOU = 'REPFTPDISTANTEXPCOU';
  cItmRepArchivage = 'REPARCHIVAGE';
  cItmSEARCHFILE = 'SEARCHFILE';
  cItmFILEOUT = 'FILEOUT';
  cItmLOCALDEST = 'LOCALDEST';
  cItmHOST = 'HOST';
  cItmPORT = 'PORT';
  cItmINTERVAL = 'INTERVAL';
  cItmDELAIITERATION = 'DELAIITERATION';
  cItmHEUREDEB = 'HEUREDEB';
  cItmHEUREFIN = 'HEUREFIN';
  cItmLASTDATEHEURE = 'LASTDATEHEURE';
  cItmLASTHEURE = 'LASTHEURE';
  cItmCLIENTS = 'CLIENTS';
  cItmPOINTS = 'POINTS';
  cItemDELETEFILE = 'DELETE_FILE';
  cItmFileMaxLines = 'MAXLINES';

  cFormatDTLog = 'dd/mm/yyyy hh:nn:ss';
  cFormatLogImport = '[%s] - %s : %s';
  cTeminate = 'Terminé';
  cEnCours = 'En cours';
  cErreur = 'Erreur';
  cAvertissement = 'Avertissement';
  cMsgLastExport = 'Le dernier export a été traité à : %s.';
  cMsgNextExport = ' Le prochain sera à %s';
//JB
  cRepBak = 'Archives\';
//

type
  TMainFrm = class(TForm)
    TimerExport: TTimer;
    TimerImport: TTimer;
    pnlMain: TPanel;
    PgctrlMain: TPageControl;
    TbshtParams: TTabSheet;
    TbshtImport: TTabSheet;
    TbshtExport: TTabSheet;
    DsParamExport: TDataSource;
    Pgc_1: TPageControl;
    TbshtParamImport: TTabSheet;
    TbshtParamExport: TTabSheet;
    cxGridParamExport: TcxGrid;
    cxGridDBBandedTVParamExport: TcxGridDBBandedTableView;
    cxGridLevel2: TcxGridLevel;
    cxGridParamImport: TcxGrid;
    cxGridDBBandedTVParamImport: TcxGridDBBandedTableView;
    cxGridLevel1: TcxGridLevel;
    DsParamImport: TDataSource;
    pnlParams: TPanel;
    BtnSave: TButton;
    BtnReload: TButton;
    EdtPasswordWS: TEdit;
    Lab_9: TLabel;
    cxGridExport: TcxGrid;
    cxGridTWExport: TcxGridDBTableView;
    cxGridLevel3: TcxGridLevel;
    CDSExportLog: TClientDataSet;
    DsExportLog: TDataSource;
    CDSExportLogEXP_HEURE: TStringField;
    CDSExportLogEXP_FICHIER: TStringField;
    CDSExportLogEXP_DATELASTEXPORT: TStringField;
    cxGridTWExportEXP_HEURE: TcxGridDBColumn;
    cxGridTWExportEXP_FICHIER: TcxGridDBColumn;
    cxGridTWExportEXP_DATELASTEXPORT: TcxGridDBColumn;
    pnlInfoNextExport: TPanel;
    GrpbxImport: TGroupBox;
    Lab_11: TLabel;
    TimerImportInterval: TTimer;
    SpdBtnRefreshExport: TSpeedButton;
    MemoImport: TMemo;
    pnlInfoImport: TPanel;
    SpdBtnImportClear: TSpeedButton;
    GrpBxExport: TGroupBox;
    Lab_14: TLabel;
    TbShtTestWs: TTabSheet;
    PgCtrlTestWS: TPageControl;
    TbShtInfoClientGet: TTabSheet;
    TbShtNbPointsClientGet: TTabSheet;
    TbShtInfoClientMaj: TTabSheet;
    TbShtBonReducUtilise: TTabSheet;
    TbShtPalierUtilise: TTabSheet;
    cxGridInfoClientGet: TcxGrid;
    cxGridDBTVInfoClientGet: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    DsInfoClientGet: TDataSource;
    Pan_1: TPanel;
    Btn_ExecuteInfoClientGet: TButton;
    Lab_15: TLabel;
    EdtNumCarteICG: TEdit;
    Lab_16: TLabel;
    EdtNomICG: TEdit;
    Lab_17: TLabel;
    EdtPrenomICG: TEdit;
    Lab_18: TLabel;
    EdtCPICG: TEdit;
    Lab_19: TLabel;
    EdtVilleICG: TEdit;
    Lab_20: TLabel;
    Pan_2: TPanel;
    Lab_22: TLabel;
    Lab_23: TLabel;
    BtnNbPointsClientGet: TButton;
    EdtNumCarteNbPtsCli: TEdit;
    MemoNbPointsClientGet: TMemo;
    Pan_3: TPanel;
    Lab_24: TLabel;
    Lab_25: TLabel;
    Lab_26: TLabel;
    Lab_27: TLabel;
    Lab_28: TLabel;
    Lab_29: TLabel;
    BtnInfoClientMaj: TButton;
    EdtNumCarteICM: TEdit;
    EdtNomICM: TEdit;
    EdtPrenomICM: TEdit;
    EdtCPICM: TEdit;
    EdtVilleICM: TEdit;
    CDSClientInfos: TClientDataSet;
    CDSClientInfosCLI_CIV: TStringField;
    CDSClientInfosCLI_NOM: TStringField;
    CDSClientInfosCLI_PRENOM: TStringField;
    CDSClientInfosCLI_ADR: TStringField;
    CDSClientInfosCLI_CP: TStringField;
    CDSClientInfosCLI_VILLE: TStringField;
    CDSClientInfosCLI_CODEPAYS: TStringField;
    CDSClientInfosCLI_TEL1: TStringField;
    CDSClientInfosCLI_TEL2: TStringField;
    CDSClientInfosCLI_DTNAISS: TDateField;
    CDSClientInfosCLI_EMAIL: TStringField;
    CDSClientInfosCLI_TOPSAL: TIntegerField;
    CDSClientInfosCLI_DTCREATION: TDateField;
    CDSClientInfosCLI_BLACKLIST: TIntegerField;
    CDSClientInfosCLI_TOPNPAI: TIntegerField;
    CDSClientInfosCLI_TOPVIB: TIntegerField;
    CDSClientInfosCLI_IDETO: TStringField;
    CDSClientInfosPTS_NBPOINTS: TFloatField;
    CDSClientInfosPTS_DATE: TDateField;
    cxGridDBTVInfoClientGetCLI_CIV: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_NOM: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_PRENOM: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_ADR: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_CP: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_VILLE: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_CODEPAYS: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_TEL1: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_TEL2: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_DTNAISS: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_EMAIL: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_TOPSAL: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_DTCREATION: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_BLACKLIST: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_TOPNPAI: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_TOPVIB: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_IDETO: TcxGridDBColumn;
    cxGridDBTVInfoClientGetPTS_NBPOINTS: TcxGridDBColumn;
    cxGridDBTVInfoClientGetPTS_DATE: TcxGridDBColumn;
    EdtTel1ICM: TEdit;
    EdtEmailICM: TEdit;
    EdtTel2ICM: TEdit;
    EdtCodePaysICM: TEdit;
    EdtCIVICM: TEdit;
    EdtCodeMagICM: TEdit;
    Lab_36: TLabel;
    Lab_35: TLabel;
    Lab_34: TLabel;
    Lab_33: TLabel;
    Lab_32: TLabel;
    Lab_31: TLabel;
    MemoAdrICM: TMemo;
    Lab_38: TLabel;
    BtnBonReducUtilise: TButton;
    Lab_37: TLabel;
    Lab_39: TLabel;
    Lab_40: TLabel;
    Lab_41: TLabel;
    Lab_42: TLabel;
    EdtNumCarteBRC: TEdit;
    EdtNumTicketBRC: TEdit;
    EdtNumBonBRC: TEdit;
    EdtCodeMagBRC: TEdit;
    Lab_47: TLabel;
    BtnCheckBonReducUtilise: TButton;
    BtnPalierUtilise: TButton;
    Lab_43: TLabel;
    Lab_44: TLabel;
    Lab_45: TLabel;
    EdtNumCartePU: TEdit;
    EdtCodeMagPU: TEdit;
    Lab_49: TLabel;
    DTPDateBRC: TDateTimePicker;
    DTPDateNaissICM: TDateTimePicker;
    DTPDateNaissICG: TDateTimePicker;
    CDSClientInfosCLI_DTSUP: TDateField;
    cxGridDBTVInfoClientGetCLI_DTSUP: TcxGridDBColumn;
    ChkBxDateNaissICG: TCheckBox;
    ChkBxDTNaissICM: TCheckBox;
    CDSClientInfosCLI_ENSID: TIntegerField;
    CDSClientInfosCLI_NUMCARTE: TStringField;
    cxGridDBTVInfoClientGetCLI_ENSID: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_NUMCARTE: TcxGridDBColumn;
    Gbx_1: TGroupBox;
    Lab_12: TLabel;
    Lab_13: TLabel;
    MskEdtImportHeureDeb: TMaskEdit;
    MskEdtImportHeureFin: TMaskEdit;
    Lab_10: TLabel;
    SpnEdtCentraleICG: TSpinEdit;
    SpnEdtCentraleNbPtsCli: TSpinEdit;
    SpnEdtCentraleICM: TSpinEdit;
    SpnEdtCentraleBRC: TSpinEdit;
    SpnEdtCentralePU: TSpinEdit;
    SpnEdtPalierPU: TSpinEdit;
    Btn_GetTime: TButton;
    EdtLoginSFTP: TEdit;
    EdtPasswordSFTP: TEdit;
    EdtPortSFTP: TEdit;
    EdtHostSFTP: TEdit;
    LabLoginSFTP: TLabel;
    LabPasswordSFTP: TLabel;
    LabPortSFTP: TLabel;
    LabHostSFTP: TLabel;
    LabRepLocalSFTP: TLabel;
    EdtRepLocalSFTP: TEdit;
    LabFileOutSFTP: TLabel;
    EdtFileOutSFTP: TEdit;
    ElSimpleSFTPClient: TElSimpleSFTPClient;
    Min: TLabel;
    seImportDelaiIteration: TSpinEdit;
    seImportInterval: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    seExportInterval: TSpinEdit;
    GroupBox1: TGroupBox;
    StatusBar1: TStatusBar;
    Nbt_LancementManuel: TSpeedButton;
    ti_App: TTrayIcon;
    Pgc_Centrale: TPageControl;
    Tab_GoSport: TTabSheet;
    Tab_Courir: TTabSheet;
    Lab_ImportGOS: TLabel;
    EdtRepDistantSFTPImpGOS: TEdit;
    EdtRepDistantSFTPExpGOS: TEdit;
    Lab_ExportGOS: TLabel;
    LabRepDistantSFTP: TLabel;
    Lab_ImportCOU: TLabel;
    EdtRepDistantSFTPImpCOU: TEdit;
    Lab_ExportCOU: TLabel;
    EdtRepDistantSFTPExpCOU: TEdit;
    Lab_Archivage: TLabel;
    edt_Archivage: TEdit;
    ComboBoxFilePathAndName: TComboBox;
    Nbt_TraitementFichierSelectionne: TSpeedButton;
    FileOpenDialogDefaultPath: TFileOpenDialog;
    CheckListBoxExtExport: TCheckListBox;
    Nbt_StartExports: TSpeedButton;
    Lab_InfoExport: TLabel;
    CDSClientInfosCLI_TYPEFID: TIntegerField;
    cxGridDBTVInfoClientGetCLI_TYPEFID: TcxGridDBColumn;
    Lab_TypeFid: TLabel;
    Chp_TypeFid: TSpinEdit;
    CheckBox1001: TCheckBox;
    CheckBox1002: TCheckBox;
    CheckBox4001: TCheckBox;
    CDSClientInfosCLI_CSTTEL: TStringField;
    CDSClientInfosCLI_CSTMAIL: TStringField;
    CDSClientInfosCLI_CSTCGV: TStringField;
    cxGridDBTVInfoClientGetCLI_CSTTEL: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_CSTMAIL: TcxGridDBColumn;
    cxGridDBTVInfoClientGetCLI_CSTCGV: TcxGridDBColumn;
    CDSClientInfosCLI_DESACTIVE: TIntegerField;
    cxGridDBTVInfoClientGetCLI_DESACTIVE: TcxGridDBColumn;

    procedure FormCreate(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnReloadClick(Sender: TObject);
    procedure TimerImportTimer(Sender: TObject);
    procedure TimerImportIntervalTimer(Sender: TObject);
    procedure SpdBtnRefreshExportClick(Sender: TObject);
    procedure SpdBtnImportClearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerExportTimer(Sender: TObject);
    procedure Btn_ExecuteInfoClientGetClick(Sender: TObject);
    procedure BtnNbPointsClientGetClick(Sender: TObject);
    procedure BtnInfoClientMajClick(Sender: TObject);
    procedure BtnBonReducUtiliseClick(Sender: TObject);
    procedure BtnCheckBonReducUtiliseClick(Sender: TObject);
    procedure BtnPalierUtiliseClick(Sender: TObject);
    procedure CDSClientInfosCLI_DTSUPGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure ChkBxDateNaissICGClick(Sender: TObject);
    procedure CDSClientInfosPTS_NBPOINTSGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure CDSClientInfosPTS_DATEGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure ChkBxDTNaissICMClick(Sender: TObject);
    procedure cxGridDBTVInfoClientGetDblClick(Sender: TObject);
    procedure Btn_GetTimeClick(Sender: TObject);
    procedure ElSimpleSFTPClientKeyValidate(Sender: TObject; ServerKey: TElSSHKey; var Validate: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Nbt_LancementManuelClick(Sender: TObject);
    procedure ti_AppDblClick(Sender: TObject);
    procedure ti_AppClick(Sender: TObject);
    procedure ti_AppBalloonClick(Sender: TObject);
    procedure MemoImportChange(Sender: TObject);
    procedure Nbt_TraitementFichierSelectionneClick(Sender: TObject);
    procedure ComboBoxFilePathAndNameDropDown(Sender: TObject);
    procedure CheckListBoxExtExportClickCheck(Sender: TObject);
    procedure Nbt_StartExportsClick(Sender: TObject);

  private
    FURLWS: String;
    FTimeOutWS : integer;
    FIsUseWSDL: Boolean;
    FThrdImport: TThrdImport;
    FThrdExport: TThrdExport;
    FCDSParamExport, FCDSParamImport: TClientDataSet;
    FListHoraireExport: TStringList;
    FListExtImport: TStringList;
    FImportStarted: Boolean;
    FExportStarted: Boolean;
    FLastHeureExport, FNextHeureExport: String;
    FMaxLinesFiles : integer;
//JB
    FileToTraiter : String;
    ListExtExport : String;
//
    procedure loadParams;
    procedure SaveParams;

    procedure LoadListExtImport;
    procedure LoadListHoraireExport;

    function IsListHoraireExportNow: String;
    procedure LoadLogExportInfo;

    procedure pOnTerminateExport(Sender: TObject);


    { ------------------------------- TEST WS -------------------------------- }
    procedure ExecuteInfoClientGet(Const ACentrale: Integer; Const ANumCarte,
                                   ANomClient, APrenomClient, AVilleClient,
                                   ACPClient, ADateNaiss: string);

    procedure NbPointsClientGet(Const ACentrale: Integer; Const ANumCarte: String);

    procedure ExecuteInfoClientMaj(const ACentrale: Integer; const ANumCarte, ACodeMag, ACiv, ANom, APrenom, AAdr, ACP, AVille, APays, ATel1, ATel2, ADateNaiss, AEmail: String; ATypeFid: Integer; const Atel, AMail, ACgv: String;ACDesactive : Integer);

    procedure ExecuteBonReducUtilise(Const ACentrale: integer; Const ANumCarte,
                                     ANumTicket, ACodeMag, ADate, ANumeroBon: String);

    procedure ExecuteCheckBonReducUtilise(Const ACentrale: integer; Const ANumCarte,
                                          ANumTicket, ACodeMag, ADate, ANumeroBon: String);

    procedure ExecutePalierUtilise(Const ACentrale, APalierUtilise: integer;
                                   Const ANumCarte, ACodeMag: String);

    procedure ThreadMessage(var Message: TMessage); message TH_MESSAGE;

  protected
    FLogFile : string;

  public
//JB
    function  FileNameToBak(const AFileName: String): String;
    procedure PostMessageNewThreadInfo(Amessage : String);
//
    procedure SetImport;
    procedure SetExport(Const AListExportToSend: String);

    function  IncludeTrailingSlash(const Path: String; const ReplaceBackslashes: Boolean = True): String;
    procedure DownloadBySFTP(Const AUserName, APassword, AHost, ARemoteDir, ALocalDest, AFilter: String;
                             Const DeleteAfterDownload: Boolean = False; Const AFileList: TStringList = nil;
                             Const APort: Integer = 22;
                             Const AProgress: TProgressBar = nil);
    procedure SendFileToSFTP(Const AUserName, APassword, AHost, ARemoteDir, ALocalPathAndFileName: String;
                             Const DeleteAfterSend: Boolean = False; Const APort: Integer = 22); overload ;
    procedure SendFileToSFTP(Const AUserName, APassword, AHost, ARemoteDir : string ;  AFileList : TStringList ;
                             Const DeleteAfterSend: Boolean = False; Const APort: Integer = 22); overload ;
  end;

var
  MainFrm: TMainFrm;

implementation

uses
  uTool,
  u_I_BaseClientNationale,
  MD5Api,
  uSearchTG,
  uGetSQLServer,
  DateUtils
  , uLog, Generics.Collections;

{$R *.dfm}

{ TMainFrm }

procedure TMainFrm.BtnBonReducUtiliseClick(Sender: TObject);
begin
  ExecuteBonReducUtilise(SpnEdtCentraleBRC.Value, EdtNumCarteBRC.Text,
                         EdtNumTicketBRC.Text, EdtCodeMagBRC.Text, DateToStr(DTPDateBRC.Date),
                         EdtNumBonBRC.Text);
end;

procedure TMainFrm.BtnCheckBonReducUtiliseClick(Sender: TObject);
begin
  ExecuteCheckBonReducUtilise(SpnEdtCentraleBRC.Value, EdtNumCarteBRC.Text,
                              EdtNumTicketBRC.Text, EdtCodeMagBRC.Text, DateToStr(DTPDateBRC.Date),
                              EdtNumBonBRC.Text);
end;

procedure TMainFrm.Btn_ExecuteInfoClientGetClick(Sender: TObject);
var
  Buffer: String;
begin
  Buffer:= '';
  if ChkBxDateNaissICG.Checked then
    Buffer:= DateToStr(DTPDateNaissICG.Date);

  ExecuteInfoClientGet(SpnEdtCentraleICG.Value, EdtNumCarteICG.Text,
                       EdtNomICG.Text, EdtPrenomICG.Text, EdtVilleICG.Text,
                       EdtCPICG.Text, Buffer);
end;

procedure TMainFrm.BtnReloadClick(Sender: TObject);
begin
  loadParams;
end;

procedure TMainFrm.BtnSaveClick(Sender: TObject);
begin
  SaveParams;
  LoadListExtImport;
  LoadListHoraireExport;
end;

procedure TMainFrm.Btn_GetTimeClick(Sender: TObject);
var
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  Buffer: String;
begin
  vRIO:= THTTPRIO.Create(nil);

  vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
  vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

  Buffer:= vI_BaseClientNationale.GetTime;

  ShowMessage(Buffer);
end;

procedure TMainFrm.CDSClientInfosCLI_DTSUPGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsDateTime = 0 then
    Text:= '';
end;

procedure TMainFrm.CDSClientInfosPTS_DATEGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsDateTime = 0 then
    Text:= '';
end;

procedure TMainFrm.CDSClientInfosPTS_NBPOINTSGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsFloat = -1 then
    Text:= '';
end;


procedure TMainFrm.CheckListBoxExtExportClickCheck(Sender: TObject);
var
  I, J : Integer;
begin
  J := CheckListBoxExtExport.ItemIndex;

  if (J = 0) and (CheckListBoxExtExport.Checked[0] = True) then
  begin
    CheckListBoxExtExport.Checked[1] := False;
    for I := 2 to CheckListBoxExtExport.Items.Count-1 do
       CheckListBoxExtExport.Checked[I] := True;
  end else

  if (J = 1) and (CheckListBoxExtExport.Checked[1] = True) then
  begin
    CheckListBoxExtExport.Checked[0] := False;
    for I := 2 to CheckListBoxExtExport.Items.Count-1 do
       CheckListBoxExtExport.Checked[I] := False;
  end else
  begin
    CheckListBoxExtExport.Checked[0] := False;
    CheckListBoxExtExport.Checked[1] := False;
  end;
end;

procedure TMainFrm.ChkBxDateNaissICGClick(Sender: TObject);
begin
  DTPDateNaissICG.Enabled:= ChkBxDateNaissICG.Checked;
end;

procedure TMainFrm.ChkBxDTNaissICMClick(Sender: TObject);
begin
  DTPDateNaissICM.Enabled:= ChkBxDTNaissICM.Checked;
end;

procedure TMainFrm.ComboBoxFilePathAndNameDropDown(Sender: TObject);
begin
  FileOpenDialogDefaultPath.Options := [];
  if FileOpenDialogDefaultPath.Execute then
  begin
    ComboBoxFilePathAndName.Text := FileOpenDialogDefaultPath.FileName;
    Abort;
  end;
end;

procedure TMainFrm.cxGridDBTVInfoClientGetDblClick(Sender: TObject);
begin
  SpnEdtCentraleICM.Value := CDSClientInfos.FieldByName('CLI_ENSID').AsInteger;
  EdtNumCarteICM.Text := CDSClientInfos.FieldByName('CLI_NUMCARTE').AsString;
  EdtCIVICM.Text := CDSClientInfos.FieldByName('CLI_CIV').AsString;
  EdtNomICM.Text := CDSClientInfos.FieldByName('CLI_NOM').AsString;
  EdtPrenomICM.Text := CDSClientInfos.FieldByName('CLI_PRENOM').AsString;
  MemoAdrICM.Lines.Text := CDSClientInfos.FieldByName('CLI_ADR').AsString;
  EdtCPICM.Text := CDSClientInfos.FieldByName('CLI_CP').AsString;
  EdtVilleICM.Text := CDSClientInfos.FieldByName('CLI_VILLE').AsString;
  EdtCodePaysICM.Text := CDSClientInfos.FieldByName('CLI_CODEPAYS').AsString;
  EdtTel1ICM.Text := CDSClientInfos.FieldByName('CLI_TEL1').AsString;
  EdtTel2ICM.Text := CDSClientInfos.FieldByName('CLI_TEL2').AsString;
  ChkBxDTNaissICM.Checked := CDSClientInfos.FieldByName('CLI_DTNAISS').AsDateTime <> 0;
  if ChkBxDTNaissICM.Checked then
    DTPDateNaissICM.DateTime := CDSClientInfos.FieldByName('CLI_DTNAISS').AsDateTime;
  EdtEmailICM.Text := CDSClientInfos.FieldByName('CLI_EMAIL').AsString;
  Chp_TypeFid.Value := CDSClientInfos.FieldByName('CLI_TYPEFID').AsInteger;
  CheckBox1001.Checked := (CDSClientInfos.FieldByName('CLI_CSTTEL').AsString = '1');
  CheckBox1002.Checked := (CDSClientInfos.FieldByName('CLI_CSTMAIL').AsString = '1');
  CheckBox4001.Checked := (CDSClientInfos.FieldByName('CLI_CSTCGV').AsString = '1');

  PgCtrlTestWS.ActivePage := TbShtInfoClientMaj;
end;

procedure TMainFrm.ThreadMessage(var Message: TMessage);
var
  NewThreadInfo: PThreadInfo;
//    ThreadIndex:Integer;
begin
  case Message.WParam of
  TH_NEWLINE:
    begin
      NewThreadInfo:= PThreadInfo(Message.LParam);
      MemoImport.Lines.Add(NewThreadInfo^.MemoLine);
    end;
  end
end;

procedure TMainFrm.DownloadBySFTP(const AUserName, APassword, AHost, ARemoteDir,
  ALocalDest, AFilter: String; const DeleteAfterDownload: Boolean = False;
  const AFileList: TStringList = nil; const APort: Integer = 22;
  const AProgress: TProgressBar = nil);
var
  lFileList: TList;        // Liste temporaire contenant le resultat de la méthode ListDirectory
  sFileName,               // = TElSftpFileInfo( lFileList[j] ).Name
  sRemoteDir,              // = IncludeTrailingSlash( ARemoteDir )
  sLocalDest: String;      // = IncludeTrailingBackSlash( ALocalDest )
  slExtensions,            // Liste temporaire contenant les extensions AFilter parsées
  slFileList: TStringList; // Liste contenant les fichiesr à télécharger
  i, j: Integer;           // Variables itératives
//  NewThreadInfo: PThreadInfo;
begin
  slFileList := TStringList.Create;
  try
    if AFileList <> nil then
      AFileList.Clear;

    {$REGION 'Connexion au serveur SFTP'}
    ElSimpleSFTPClient.Username := AUserName;
    ElSimpleSFTPClient.Password := APassword;
    ElSimpleSFTPClient.Address := AHost;
    ElSimpleSFTPClient.Port := APort;
    ElSimpleSFTPClient.CompressionAlgorithms[SSH_CA_ZLIB] := True;
    ElSimpleSFTPClient.AuthenticationTypes := ElSimpleSFTPClient.AuthenticationTypes and not SSH_AUTH_TYPE_PUBLICKEY;

    sRemoteDir := IncludeTrailingSlash(ARemoteDir);
    sLocalDest := IncludeTrailingBackSlash(ALocalDest);

    try
      ElSimpleSFTPClient.Open;
    except
      on E: Exception do
      begin
        PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog,Now()) + '] : Exception ' + E.Message);
        raise;
      end;
    end;

    if not ElSimpleSFTPClient.Active then
    begin
      PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog,Now()) + '] : Exception Connexion SFTP impossible');
      raise Exception.Create( 'Connexion SFTP impossible.' );
    end;
    {$ENDREGION}

    // Vérification de l'existence du répertoire distant
    if ElSimpleSFTPClient.FileExists( sRemoteDir ) then
    begin (* Le répertoire distant existe *)
      {$REGION 'Parsing des extensions (AFilter) et récupération des noms de fichiers à télécharger (slFileList)'}
      slExtensions := TStringList.Create;
      try
        slExtensions.Delimiter     := ';';
        slExtensions.DelimitedText := AFilter;
        lFileList := TList.Create;
        try
          for i := 0 to slExtensions.Count - 1 do
          begin (* Pour chacune des extensions *)
            // On liste les fichiers correspondant à cette extension
            ElSimpleSFTPClient.ListDirectory( ARemoteDir, lFileList, Trim( slExtensions[i] ), False, True, False );
            for j := 0 to lFileList.Count - 1 do
            begin (* Pour chacun des fichiers correspondant à cette extension *)
              sFileName := TElSftpFileInfo( lFileList[j] ).Name;
              // On ajoute le nom du fichier à la liste des fichiers à télécharger s'il n'est pas déjà présent
              if slFileList.IndexOf( sFileName ) < 0 then
                slFileList.Add( sFileName );
            end; // for .. lFileList
          end; //for .. slExtensions
        finally
          lFileList.Free;
          Application.ProcessMessages;
        end;
      finally
        slExtensions.Free;
      end;
      slFileList.Sort;
      {$ENDREGION}
      (* Parsing des extensions et récupération des fichiers terminées *)
      if slFileList.Count = 0 then
      begin
        Exit;
      end;

      if AProgress <> nil then
      begin
        AProgress.Position := 0;
        AProgress.Max      := slFileList.Count - 1;
      end;
      {$REGION 'Récupération des fichiers & traitements'}
      for i := 0 to slFileList.Count - 1 do
      begin
        PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog,Now()) + '] : Récuperation FTP (' + ARemoteDir + ') du fichier ' + slFileList[i]);

        ElSimpleSFTPClient.DownloadFile( sRemoteDir + slFileList[i], sLocalDest + slFileList[i] );

        if DeleteAfterDownload then
          ElSimpleSFTPClient.RemoveFile( sRemoteDir + slFileList[i] );

        if AFileList <> nil then
          AFileList.Append( IncludeTrailingPathDelimiter(ALocalDest) + slFileList[i] );

        if AProgress <> nil then
          AProgress.Position := AProgress.Position + 1;
        Application.ProcessMessages;
      end;
      {$ENDREGION}
    end;
  finally
    if ElSimpleSFTPClient.Active then
      ElSimpleSFTPClient.Close( True );
    Application.ProcessMessages;
    slFileList.Free;
  end;
end;

procedure TMainFrm.BtnPalierUtiliseClick(Sender: TObject);
begin
  ExecutePalierUtilise(SpnEdtCentralePU.Value, SpnEdtPalierPU.Value,
                       EdtNumCartePU.Text, EdtCodeMagPU.Text);
end;

procedure TMainFrm.ExecuteCheckBonReducUtilise(const ACentrale: integer;
  const ANumCarte, ANumTicket, ACodeMag, ADate, ANumeroBon: String);
var
  vDateTime, vPassword: string;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  vRemotableGnk: TRemotableGnk;
begin
  Screen.Cursor:= crHourGlass;
  vRIO:= THTTPRIO.Create(nil);
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

    vDateTime:= vI_BaseClientNationale.GetTime;
    vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));

    vRemotableGnk:= vI_BaseClientNationale.CheckBonReducUtilise(ACentrale, vDateTime, vPassword, ANumCarte,
                                                                ANumTicket, ACodeMag, ADate, ANumeroBon);

    MessageDlg(vRemotableGnk.sMessage, mtInformation, [mbOk], 0);

  finally
    FreeAndNil(vRemotableGnk);
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainFrm.BtnInfoClientMajClick(Sender: TObject);
var
  Buffer: String;
begin
  Buffer:= '';
  if ChkBxDTNaissICM.Checked then
    Buffer:= DateToStr(DTPDateNaissICG.Date);

  ExecuteInfoClientMaj(SpnEdtCentraleICM.Value, EdtNumCarteICM.Text,
                       EdtCodeMagICM.Text, EdtCIVICM.Text, EdtNomICM.Text,
                       EdtPrenomICM.Text, MemoAdrICM.Lines.Text, EdtCPICM.Text,
                       EdtVilleICM.Text, EdtCodePaysICM.Text, EdtTel1ICM.Text,
                       EdtTel2ICM.Text, Buffer, EdtEmailICM.Text, Chp_TypeFid.Value, IfThen(CheckBox1001.Checked, '1', '0'), IfThen(CheckBox1002.Checked, '1', '0'), IfThen(CheckBox4001.Checked, '1', '0'),0);
end;

procedure TMainFrm.BtnNbPointsClientGetClick(Sender: TObject);
begin
  NbPointsClientGet(SpnEdtCentraleNbPtsCli.Value, EdtNumCarteNbPtsCli.Text);
end;

procedure TMainFrm.ElSimpleSFTPClientKeyValidate(Sender: TObject;
  ServerKey: TElSSHKey; var Validate: Boolean);
begin
  Validate := True;
end;

procedure TMainFrm.ExecuteBonReducUtilise(const ACentrale: integer;
  const ANumCarte, ANumTicket, ACodeMag, ADate, ANumeroBon: String);
var
  vDateTime, vPassword: string;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  vRemotableGnk: TRemotableGnk;
begin
  Screen.Cursor:= crHourGlass;
  vRIO:= THTTPRIO.Create(nil);
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

    vDateTime:= vI_BaseClientNationale.GetTime;
    vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));

    vRemotableGnk:= vI_BaseClientNationale.BonReducUtilise(ACentrale, vDateTime, vPassword, ANumCarte,
                                                             ANumTicket, ACodeMag, ADate, ANumeroBon);

    MessageDlg(vRemotableGnk.sMessage, mtInformation, [mbOk], 0);

  finally
    FreeAndNil(vRemotableGnk);
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainFrm.ExecuteInfoClientGet(Const ACentrale: Integer;
  Const ANumCarte, ANomClient, APrenomClient, AVilleClient,
  ACPClient, ADateNaiss: string);
var
  vDateTime, vPassword: string;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  vInfoClients: TInfoClients;
  vClientInfos: TClientInfos;
begin
  Screen.Cursor:= crHourGlass;
  vRIO:= THTTPRIO.Create(nil);
  if not CDSClientInfos.Active then
    CDSClientInfos.Open;
  CDSClientInfos.EmptyDataSet;
  CDSClientInfos.DisableControls;
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

    vDateTime:= vI_BaseClientNationale.GetTime;
    vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));

    vInfoClients:= vI_BaseClientNationale.InfoClientGet(vDateTime, vPassword, ACentrale,
                                                        ANumCarte, ANomClient, APrenomClient,
                                                        AVilleClient, ACPClient, ADateNaiss);

    if vInfoClients.iErreur = 0 then
    begin
        if vInfoClients.iNbClients <> 0 then
        begin
            for vClientInfos in vInfoClients.stClientInfos do
            begin
              if ((ANumCarte<>'') or ((ANumCarte='') and (vClientInfos.iCltDesactive = 0))) then
              begin
                CDSClientInfos.Append;
                CDSClientInfos.FieldByName('CLI_ENSID').AsInteger:= vClientInfos.iCentrale;
                CDSClientInfos.FieldByName('CLI_NUMCARTE').AsString:= vClientInfos.sNumCarte;
                CDSClientInfos.FieldByName('CLI_CIV').AsString:= vClientInfos.sCiv;
                CDSClientInfos.FieldByName('CLI_NOM').AsString:= vClientInfos.sNom;
                CDSClientInfos.FieldByName('CLI_PRENOM').AsString:= vClientInfos.sPrenom;
                CDSClientInfos.FieldByName('CLI_ADR').AsString:= Trim(StringReplace(vClientInfos.sAdr, #$A, ' ', [rfReplaceAll]));
                CDSClientInfos.FieldByName('CLI_CP').AsString:= vClientInfos.sCP;
                CDSClientInfos.FieldByName('CLI_VILLE').AsString:= vClientInfos.sVille;
                CDSClientInfos.FieldByName('CLI_CODEPAYS').AsString:= vClientInfos.sPays;
                CDSClientInfos.FieldByName('CLI_TEL1').AsString:= vClientInfos.sTel1;
                CDSClientInfos.FieldByName('CLI_TEL2').AsString:= vClientInfos.sTel2;
                CDSClientInfos.FieldByName('CLI_DTNAISS').AsDateTime:= StrToDateDef(vClientInfos.sDateNaiss);
                CDSClientInfos.FieldByName('CLI_EMAIL').AsString:= vClientInfos.sEmail;
                CDSClientInfos.FieldByName('CLI_TOPSAL').AsInteger:= vClientInfos.iSalarie;
                CDSClientInfos.FieldByName('CLI_DTCREATION').AsDateTime:= StrToDateDef(vClientInfos.sDateCreation);
                CDSClientInfos.FieldByName('CLI_DTSUP').AsDateTime:= StrToDateDef(vClientInfos.sDateSuppression);
                CDSClientInfos.FieldByName('CLI_BLACKLIST').AsInteger:= vClientInfos.iBlackList;
                CDSClientInfos.FieldByName('CLI_TOPNPAI').AsInteger:= vClientInfos.iNPAI;
                CDSClientInfos.FieldByName('CLI_TOPVIB').AsInteger:= vClientInfos.iVIB;
                CDSClientInfos.FieldByName('CLI_IDETO').AsString:= vClientInfos.sIDREF;
                CDSClientInfos.FieldByName('PTS_NBPOINTS').AsFloat:= StrToFloatDef(vClientInfos.sSoldePts, 0);
                CDSClientInfos.FieldByName('PTS_DATE').AsDateTime:= StrToDateDef(vClientInfos.sDateSoldePts);
                CDSClientInfos.FieldByName('CLI_TYPEFID').AsInteger:= vClientInfos.iTypeFId;
                CDSClientInfos.FieldByName('CLI_CSTTEL').AsString := vClientInfos.iCstTel;
                CDSClientInfos.FieldByName('CLI_CSTMAIL').AsString := vClientInfos.iCstMail;
                CDSClientInfos.FieldByName('CLI_CSTCGV').AsString := vClientInfos.iCstCgv;
                CDSClientInfos.FieldByName('CLI_DESACTIVE').AsInteger := vClientInfos.iCltDesactive;
                CDSClientInfos.Post;
              end;
              end;
          end;
    end
    else
      MessageDlg('Centrale = ' + IntToStr(ACentrale) + #13#10 + vInfoClients.sMessage, mtInformation, [mbOk], 0);
  finally
    FreeAndNil(vInfoClients);
    CDSClientInfos.First;
    CDSClientInfos.EnableControls;
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainFrm.ExecuteInfoClientMaj(const ACentrale: Integer; const ANumCarte, ACodeMag, ACiv, ANom, APrenom, AAdr, ACP, AVille, APays, ATel1, ATel2, ADateNaiss, AEmail: String; ATypeFid: Integer; const Atel, AMail, ACgv: String;ACDesactive : Integer);
var
  vDateTime, vPassword: string;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  vRemotableGnk: TRemotableGnk;
begin
  Exit ;                              // Pour le moment : désactivé

  Screen.Cursor:= crHourGlass;
  vRIO:= THTTPRIO.Create(nil);
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

    vDateTime:= vI_BaseClientNationale.GetTime;
    vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));

    vRemotableGnk:= vI_BaseClientNationale.InfoClientMaj(ACentrale, vDateTime, vPassword,
                                                         ANumCarte, ACodeMag, ACiv, ANom, APrenom,
                                                         AAdr, ACP, AVille, APays, ATel1, ATel2,
                                                         ADateNaiss, AEmail, FormatDateTime('dd/mm/yyyy', Date), ATypeFid, Atel, AMail, ACgv, ACDesactive);

    MessageDlg(vRemotableGnk.sMessage, mtInformation, [mbOk], 0);
  finally
    FreeAndNil(vRemotableGnk);
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainFrm.ExecutePalierUtilise(const ACentrale,
  APalierUtilise: integer; const ANumCarte, ACodeMag: String);
var
  vDateTime, vPassword: string;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  vRemotableGnk: TRemotableGnk;
begin
  Screen.Cursor:= crHourGlass;
  vRIO:= THTTPRIO.Create(nil);
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

    vDateTime:= vI_BaseClientNationale.GetTime;
    vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));

    vRemotableGnk:= vI_BaseClientNationale.PalierUtilise(ACentrale, APalierUtilise, vDateTime,
                                                         vPassword, ANumCarte, ACodeMag);

    MessageDlg(vRemotableGnk.sMessage, mtInformation, [mbOk], 0);

  finally
    FreeAndNil(vRemotableGnk);
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Voulez-vous fermer l''application ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    CanClose:=not(FImportStarted or FExportStarted);
    if Not(CanClose) then
    begin
         MessageDlg('Impossible de fermer :  traitements en cours...', mtInformation, [mbOK], 0);
    end;
  end
  else
  begin
    CanClose := false;
    Hide();
    WindowState := wsMinimized;
    ti_App.Visible := true;
    ti_App.ShowBalloonHint();
  end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  Log.App := 'CltBaseClientNationale';
  Log.Inst := '1';
  Log.Open;
  Log.saveIni;

  FListHoraireExport:= TStringList.Create(True);
  FListExtImport:= TStringList.Create;
  FCDSParamExport:= nil;
  FCDSParamImport:= nil;
  FImportStarted:= False;
  FExportStarted:= False;

  DTPDateBRC.Date:= Now;
  DTPDateNaissICG.Date:= Now;
  DTPDateNaissICM.Date:= Now;

  ti_App.Icon.Assign(Application.Icon);
  ti_App.Visible := false;
  ti_App.Hint := Caption;
  ti_App.BalloonTitle := Caption;
  ti_App.BalloonHint := 'Double-cliquez pour afficher la fenêtre';
  ti_App.BalloonFlags := bfInfo;

  try
    FLogFile := ChangeFileExt(ParamStr(0), '.imp.log');
    if FileExists(FLogFile) then
    begin
      MemoImport.OnChange := nil;
      MemoImport.Lines.LoadFromFile(FLogFile);
      MemoImport.Lines.Add('==================================================');
      MemoImport.Lines.Add('Démarrage de l''application : ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()));
      SendMessage(MemoImport.Handle, EM_LINESCROLL, 0, MemoImport.Lines.Count);
      MemoImport.OnChange := MemoImportChange;
    end;
  except
    // ???
  end;

  loadParams;
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
//  if FImportStarted then FThrdImport.WaitFor;
//  if FExportStarted then FThrdExport.WaitFor;
  FreeAndNil(FListHoraireExport);
  FreeAndNil(FListExtImport);
end;

function TMainFrm.IncludeTrailingSlash(const Path: String; const ReplaceBackslashes: Boolean): String;
begin
  Result := IfThen(ReplaceBackslashes, StringReplace(Path, '\', '/', [rfReplaceAll]), Path);
  if Length(Result) > 0 then
    Result := Result + IfThen(Path[Length(Result)] <> '/', '/', '');
end;

function TMainFrm.IsListHoraireExportNow: String;
var
  vIdx: Integer;
  vT: TTime;
  vH, vM, vS, vZ: Word;
begin
  Result := '';
  FNextHeureExport := '';
  DecodeTime(Now, vH, vM, vS, vZ);
  vT := EncodeTime(vH, vM, 0, 0);
  vIdx := FListHoraireExport.IndexOf(FormatDateTime('hh:nn:ss', vT));
  if (vIdx <> -1) and (FLastHeureExport <> FListHoraireExport.Strings[vIdx]) then
  begin
      FLastHeureExport:= FListHoraireExport.Strings[vIdx];
      if(vIdx + 1) <= FListHoraireExport.Count -1 then
        FNextHeureExport := FListHoraireExport.Strings[vIdx + 1]
      else
        FNextHeureExport := FListHoraireExport.Strings[0];
      Result := TStringList(FListHoraireExport.Objects[vIdx]).Text;
  end;
end;

//List des extensions Imports
procedure TMainFrm.LoadListExtImport;
var
  i: integer;
begin
  FListExtImport.Clear;
  FCDSParamImport.First;
  while not FCDSParamImport.Eof do
  begin
      for i:= 0 to FCDSParamImport.FieldCount -1 do
      begin
          if FCDSParamImport.Fields[i].AsString <> '' then
          begin
              if FListExtImport.IndexOf(FCDSParamImport.Fields[i].AsString) = -1 then
                FListExtImport.Append(FCDSParamImport.Fields[i].AsString);
          end;
      end;

      FCDSParamImport.Next;
  end;

  FListExtImport.Sort;
end;

procedure TMainFrm.LoadListHoraireExport;
var
  i, vIdx: integer;
  vT: TTime;
  vSLExt: TStringList;
begin
  FListHoraireExport.Clear;
  FCDSParamExport.First;
  CheckListBoxExtExport.Clear;
  CheckListBoxExtExport.Columns := 2;
  CheckListBoxExtExport.Items.Add('Tous');
  CheckListBoxExtExport.Items.Add('Aucun');
  while not FCDSParamExport.Eof do
  begin
      for i:= 0 to FCDSParamExport.FieldCount -1 do
      begin
          if FCDSParamExport.Fields[i].AsString <> '' then
          begin
              vT:= EncodeTime(StrToInt(Copy(FCDSParamExport.Fields[i].AsString, 1, 2)),
                              StrToInt(Copy(FCDSParamExport.Fields[i].AsString, 4, 2)), 0, 0);

              vIdx:= FListHoraireExport.IndexOf(TimeToStr(vT));
              if vIdx = -1 then
              begin
                  vSLExt:= TStringList.Create;
                  vSLExt.Append(FCDSParamExport.Fields[i].FieldName);
                  if TStringList(CheckListBoxExtExport.Items).IndexOf(FCDSParamExport.Fields[i].FieldName) = -1 then
                  begin
                    CheckListBoxExtExport.Items.Add(FCDSParamExport.Fields[i].FieldName);
                    CheckListBoxExtExport.Columns := CheckListBoxExtExport.Columns + 1;
                  end;
                  FListHoraireExport.AddObject(TimeToStr(vT), vSLExt);
              end
              else
              begin
                  if TStringList(FListHoraireExport.Objects[vIdx]).IndexOf(FCDSParamExport.Fields[i].FieldName) = -1 then
                  begin
                    TStringList(FListHoraireExport.Objects[vIdx]).Append(FCDSParamExport.Fields[i].FieldName);
                    if TStringList(CheckListBoxExtExport.Items).IndexOf(FCDSParamExport.Fields[i].FieldName) = -1 then
                    begin
                      CheckListBoxExtExport.Items.Add(FCDSParamExport.Fields[i].FieldName);
                      CheckListBoxExtExport.Columns := CheckListBoxExtExport.Columns + 1;
                    end;
                  end;
              end;
          end;
      end;

      FCDSParamExport.Next;
  end;

  FListHoraireExport.Sort;
  CheckListBoxExtExport.left := CheckListBoxExtExport.left - 50 * (CheckListBoxExtExport.Items.Count - 5);
  CheckListBoxExtExport.width := CheckListBoxExtExport.width + 50 * (CheckListBoxExtExport.Items.Count - 5);
end;

procedure TMainFrm.LoadLogExportInfo;
var
  vDateTime, vPassword: String;
  vLogExports: TLogExports;
  vLogExportInfo: TLogExportInfo;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
begin
  vRIO:= THTTPRIO.Create(nil);
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

    CoInitialize(nil);
    vDateTime:= vI_BaseClientNationale.GetTime;
    vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));

    vLogExports:= vI_BaseClientNationale.LogExportGet(vDateTime, vPassword);

    if vLogExports.iErreur = 0 then
      begin
        if vLogExports.iNbLogExport <> 0 then
          begin
            CDSExportLog.EmptyDataSet;
            for vLogExportInfo in vLogExports.AListLogExport do
            begin
              CDSExportLog.Append;
              CDSExportLog.FieldByName('EXP_HEURE').AsString:= vLogExportInfo.sHeure;
              CDSExportLog.FieldByName('EXP_FICHIER').AsString:= vLogExportInfo.sFichier;
              CDSExportLog.FieldByName('EXP_DATELASTEXPORT').AsString:= vLogExportInfo.sDateLastExport;
              CDSExportLog.Post;
            end;
            CDSExportLog.First;
          end;
      end;

  finally
    if vLogExports <> nil then
      FreeAndNil(vLogExports);
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    CoUnInitialize;
  end;
end;

function SortStringDate(List: TStringList; Index1, Index2: Integer) : Integer;
var
  str1, str2 : string;
  Date1, Date2 : TDateTime;
  Pos1, Pos2 : Integer;
begin
  Result := 0;

  if Index1 = Index2 then
    Exit;

  str1 := ChangeFileExt(ExtractFileName(List[Index1]), '');
  str2 := ChangeFileExt(ExtractFileName(List[Index2]), '');

  Pos1 := Pos('-',str1);
  Pos2 := Pos('-',str2);
  if Pos1 = 0 then
    Pos1 := length(str1);
  if Pos2 = 0 then
    Pos2 := length(str2);


  if (Pos1 >= 14) and (Pos2 >= 14) then
  begin
    Date1 := EncodeDateTime(StrToInt(Copy(str1, 5, 4)), StrToInt(Copy(str1, 3, 2)), StrToInt(Copy(str1, 1, 2)),
                            StrToInt(Copy(str1, 9, 2)), StrToInt(Copy(str1, 11, 2)), StrToInt(Copy(str1, 13, 2)), 0);
    Date2 := EncodeDateTime(StrToInt(Copy(str2, 5, 4)), StrToInt(Copy(str2, 3, 2)), StrToInt(Copy(str2, 1, 2)),
                            StrToInt(Copy(str2, 9, 2)), StrToInt(Copy(str2, 11, 2)), StrToInt(Copy(str2, 13, 2)), 0);
    if Date1 > Date2 then
      Result := 1
    else if Date1 < Date2 then
      Result := -1;

    str1 := Copy(str1, 15, Length(str1));
    str2 := Copy(str2, 15, Length(str2));
  end
  else if (Pos1 >= 8) and (Pos2 >= 8) then
  begin
    Date1 := EncodeDate(StrToInt(Copy(str1, 5, 4)), StrToInt(Copy(str1, 3, 2)), StrToInt(Copy(str1, 1, 2)));
    Date2 := EncodeDate(StrToInt(Copy(str2, 5, 4)), StrToInt(Copy(str2, 3, 2)), StrToInt(Copy(str2, 1, 2)));
    Result := Trunc(Date1 - Date2);

    str1 := Copy(str1, 9, Length(str1));
    str2 := Copy(str2, 9, Length(str2));
  end;

  if Result = 0 then
    Result := CompareText(str1, str2);
end;


//JB
function TMainFrm.FileNameToBak(const AFileName: String): String;
var
  Buffer, aString, aExtension: String;
  Indice : Integer;
begin
  Buffer := FormatDateTime('yyyy\mm\dd\',now);
  aString:= ExtractFilePath(AFileName) + cRepBak + Buffer + ExtractFileName(AFileName);
  Buffer:= ExtractFilePath(aString);
  if not DirectoryExists(Buffer) then
    ForceDirectories(Buffer);

  Buffer := aString;
  aExtension := ExtractFileExt(Buffer);
  Indice := 1;
  aString := copy(Buffer,1,length(Buffer)-length(aExtension)) + '_';
  while FileExists(Buffer) do
  begin
    Buffer := aString + IntToStr(Indice) + aExtension;
    Inc(Indice);
  end;
  Result := Buffer;
end;
//

procedure TMainFrm.PostMessageNewThreadInfo(Amessage : String);
var
  NewThreadInfo : PThreadInfo;
begin
  New(NewThreadInfo);
  NewThreadInfo^.MemoLine := Amessage;
  PostMessage(MainFrm.Handle,TH_MESSAGE, TH_NEWLINE,Integer(NewThreadInfo));
end;

procedure TMainFrm.SetImport;

  function ExtractValFromFilename(const Filename: TFileName): String;
  const
    cSplitDelimiter: ShortString = '-';
  var
    iPos: Integer;
  begin
    Result := ChangeFileExt( ExtractFileName( Filename ), '' );
    iPos := Pos( cSplitDelimiter, Result );
    if iPos > 0 then
      Result := LeftStr( Result, Pred( iPos ) );
    Exit( Concat( Result, ExtractFileExt( Filename ) ) );
  end;

  procedure LogImport(const LogKey, LogVal: String;
    const LogLevel: TLogLevel; const Override: Boolean);
  var
    vLogMdl: String;
  begin
    case AnsiIndexText( LogKey, [ 'CLI7', 'CLI8', 'PTQ8', 'SFTP' ] ) of
      0: vLogMdl := 'COURIR';
      1, 2: vLogMdl := 'GOSPORT';
      3: vLogMdl := '';
      else Exit;
    end;

    {$IFDEF DEBUG}
    PostMessageNewThreadInfo(
      Format(
        '{"srv":"%s","mdl":"%s","dos":"%s","ref":"%s","key":"%s","val":"%s","lvl":%d,"ovl":%d}', [
          Log.Host, vLogMdl, 'IMPORT', '', LogKey, LogVal, Ord( LogLevel ), Ord( Override )
        ]
      )
    );
    {$ELSE}
    Log.Log( Log.Host, vLogMdl, 'IMPORT', '', '', LogKey, ExtractFileName( LogVal ), LogLevel, Override );
    {$ENDIF}
  end;

  function IsWatchedExtension(const Extension: String): Boolean; inline;
  begin
    Exit(
      IndexText( Extension, [ 'CLI7', 'CLI8', 'PTQ8' ] ) > -1
    );
  end;

var
  i, j, k: integer;
  Buffer, vDateTime, vPassword, vRepLocalSFTP: String;
  vSLListFilesOld, vSLListFilesNew, FileContentOld, FileContentNew : TStringList;
  vIniFile: TIniFile;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  vRemotableGnk: TRemotableGnk;
  vCDS: TClientDataSet;
  vTSearching: TSearching; //--> Pour test
  vLogLevel: TLogLevel;
  vLogVal, vPreviousLogVal: String;
  vLogOverload: Boolean;
begin
  FImportStarted:= True;
  vSLListFilesOld := TStringList.Create;
  vSLListFilesNew := TStringList.Create;
  vRIO:= THTTPRIO.Create(nil);
  vTSearching:= TSearching.Create;
  vCDS:= TClientDataSet.Create(nil);
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);
//JB
//    vRepLocal:= EdtRepLocalSFTP.Text + '\Import';
//    if not DirectoryExists(vRepLocal) then
//      ForceDirectories(vRepLocal);

    vRepLocalSFTP:= IncludeTrailingBackslash( EdtRepLocalSFTP.Text ) + 'Import';
    if not DirectoryExists( vRepLocalSFTP ) then
      ForceDirectories( vRepLocalSFTP );

//JB    New(NewThreadInfo);

    if FileToTraiter = '' then
    begin
      try
        LogImport( 'SFTP', '', TLogLevel.logInfo, True );
        for i:= 0 to FListExtImport.Count -1 do
        begin
          DownloadBySFTP(EdtLoginSFTP.Text, EdtPasswordSFTP.Text, EdtHostSFTP.Text,
                          EdtRepDistantSFTPImpGOS.Text, vRepLocalSFTP,
                          '*.' + FListExtImport.Strings[i], True,
                          vSLListFilesOld, StrToInt( EdtPortSFTP.Text ), nil);
          if vSLListFilesOld.Count = 0 then
            PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog,Now()) + '] : Aucun Fichier FTP transféré (' + EdtRepDistantSFTPImpGOS.Text + ') *.' + FListExtImport.Strings[i]);
          // Test si pas même chemin.
          if EdtRepDistantSFTPImpGOS.Text <> EdtRepDistantSFTPImpCOU.Text then
          begin
            DownloadBySFTP(EdtLoginSFTP.Text, EdtPasswordSFTP.Text, EdtHostSFTP.Text,
                           EdtRepDistantSFTPImpCOU.Text, vRepLocalSFTP,
                           '*.' + FListExtImport.Strings[i], True,
                           vSLListFilesOld, StrToInt( EdtPortSFTP.Text ), nil);
            if vSLListFilesOld.Count = 0 then
              PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog,Now()) + '] : Aucun Fichier FTP transféré (' + EdtRepDistantSFTPImpCOU.Text + ') *.' + FListExtImport.Strings[i]);
          end;
        end;
      except
        on E: Exception do
        begin
          PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog, Now) + '] - Exception lors du téléchargement : ' + E.ClassName + ' - ' + E.Message);
          LogImport( 'SFTP', '', TLogLevel.logError, False );
          Exit;
        end;
      end;

      // Récupérer les fichiers existants après le FTP
      // Récupérer que les fichiers dont l'extension est définie dans le fichier Ini
      for i:= 0 to FListExtImport.Count -1 do
      begin
        vTSearching.Searching(ShortString(vRepLocalSFTP), ShortString('*.' + FListExtImport.Strings[i]), False, True);
        if vTSearching.NbFilesFound <> 0 then
        begin
          // vSLListFiles.Text:= vSLListFiles.Text + vTSearching.ListPathAndFileNamesForSL;
          for j := 0 to Length(vTSearching.TabInfoSearch) -1 do
          begin
            if (vSLListFilesOld.IndexOf(String(vTSearching.TabInfoSearch[j].PathAndName)) < 0) then
              vSLListFilesOld.Add(String(vTSearching.TabInfoSearch[j].PathAndName));
          end;
        end;
      end;
    end
    else
    begin
      Buffer := vRepLocalSFTP + '\' + ExtractFileName(FileToTraiter);
      if LowerCase(Buffer) <> LowerCase(FileToTraiter) then
      begin
        PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog, Now) + '] - Fichier [' + Buffer + '] différent de [' + FileToTraiter + ']');
        if FileExists(Buffer) then
        begin
          PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog, Now) + '] - Suppression fichier [' + Buffer + ']');
          DeleteFile(Buffer);
        end;
        CopyFile(PChar(FileToTraiter), PChar(Buffer),False);
      end;
      vSLListFilesOld.Add(Buffer);
      FListExtImport.Add(StringReplace(ExtractFileExt(Buffer), '.', '', []));
      PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog, Now) + '] - Traitement fichier [' + Buffer + ']');
      FileToTraiter := '';
    end;

    try
      FileContentOld := TStringList.Create();
      FileContentNew := TStringList.Create();

      // decoupage des fichier en max 10 000 lignes
      for i := 0 to vSLListFilesOld.Count -1 do
      begin
//JB
        FileContentOld.DefaultEncoding:= TEncoding.UTF8;
        FileContentNew.DefaultEncoding:= TEncoding.UTF8;
//
        FileContentOld.LoadFromFile(vSLListFilesOld[i]);
        if FileContentOld.Count > FMaxLinesFiles then
        begin
          j := 1;
          while FileContentOld.Count > 0 do
          begin
            FileContentNew.Clear();
            while (FileContentOld.Count > 0) and (FileContentNew.Count < FMaxLinesFiles) do
            begin
              FileContentNew.Add(FileContentOld[0]);
              FileContentOld.Delete(0);
            end;
            FileContentNew.SaveToFile(ChangeFileExt(vSLListFilesOld[i], '') + '-' + Format('%0.3d', [j]) + ExtractFileExt(vSLListFilesOld[i]));
            vSLListFilesNew.Add(ChangeFileExt(vSLListFilesOld[i], '') + '-' + Format('%0.3d', [j]) + ExtractFileExt(vSLListFilesOld[i]));
            Inc(j);
          end;
          Buffer := FileNameToBak(vSLListFilesOld[i]);
          RenameFile(vSLListFilesOld[i],Buffer);
        end
        else
          vSLListFilesNew.Add(vSLListFilesOld[i]);
      end;
    finally
      FreeAndNil(FileContentOld);
      FreeAndNil(FileContentNew);
    end;

    vCDS.CloneCursor(FCDSParamImport, False);
    CoInitialize(nil);
    vSLListFilesNew.CustomSort(SortStringDate);

    PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog, Now) + '] - Début des imports');
    try
      vPreviousLogVal := ''; // Initialize
      for k := 0  to FListExtImport.Count - 1 do
      begin
        if IsWatchedExtension( FListExtImport[ k ] ) then
          LogImport( FListExtImport[ k ], 'Début de traitement', TLogLevel.logNotice, True );
        vLogOverload := True;
        for i:= 0 to vSLListFilesNew.Count -1 do
        begin
          if ExtractFileExt(vSLListFilesNew.Strings[i]) = '.' + FListExtImport.Strings[k] then
          begin
            vDateTime:= vI_BaseClientNationale.GetTime;
            vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));
            for j := 0 to vCDS.FieldCount -1 do
            begin
              Buffer := StringReplace(ExtractFileExt(vSLListFilesNew.Strings[i]), '.', '', [rfReplaceAll]);
              if vCDS.Locate(FCDSParamImport.Fields[j].FieldName, Buffer, [loCaseInsensitive]) then
              begin
                PostMessageNewThreadInfo(Format(cFormatLogImport, [FormatDateTime(cFormatDTLog, Now), cEnCours, ExtractFileName(vSLListFilesNew.Strings[i])]));

                vRemotableGnk := nil;
                if vCDS.Fields[j].FieldName = cItmCLIENTS then
                  vRemotableGnk := vI_BaseClientNationale.ImportClients(vDateTime, vPassword, vSLListFilesNew.Strings[i])
                else if vCDS.Fields[j].FieldName = cItmPOINTS then
                  vRemotableGnk := vI_BaseClientNationale.ImportPoints(vDateTime, vPassword, vSLListFilesNew.Strings[i]);

                case vRemotableGnk.iErreur of
                  0: {$REGION 'Succeed'}begin
                    PostMessageNewThreadInfo(
                      Format(
                        cFormatLogImport, [
                          FormatDateTime( cFormatDTLog, Now),
                          'WebService ' + cTeminate,
                          ExtractFileName( vSLListFilesNew.Strings[ i ] )
                        ]
                      )
                    );
                    vLogLevel := TLogLevel.logInfo;
                  end;{$ENDREGION 'Succeed'}
                  1: {$REGION 'Failed'}begin
                    PostMessageNewThreadInfo(
                      Format(
                        cFormatLogImport, [
                          FormatDateTime( cFormatDTLog, Now ),
                          'WebService ' + cErreur,
                          '-->'
                        ]
                      )
                      + vRemotableGnk.sMessage
                    );
                    vLogLevel := TLogLevel.logError;
                    vLogOverload := False;
                  end;{$ENDREGION 'Failed'}
                  2: {$REGION 'Warned'}begin
                    PostMessageNewThreadInfo(
                      Format(
                        cFormatLogImport, [
                          FormatDateTime( cFormatDTLog, Now ),
                          'WebService ' + cAvertissement,
                          '-->'
                        ]
                      )
                      + vRemotableGnk.sMessage
                    );
                    vLogLevel := TLogLevel.logWarning;
                    vLogOverload := False;
                  end;{$ENDREGION 'Warned'}
                  else {$REGION 'Unknown'}begin
                    vLogLevel := TLogLevel.logCritical;
                    vLogOverload := False;
                  end;{$ENDREGION 'Unknown'}
                end;
                if IsWatchedExtension( FListExtImport[ k ] ) then
                  LogImport( FListExtImport[ k ], ExtractFileName( vSLListFilesNew[ i ] ), vLogLevel, False );
                Break;
              end;
            end;
          end;
        end;
        if IsWatchedExtension( FListExtImport[ k ] ) then
          LogImport( FListExtImport[ k ], 'Fin de traitement', TLogLevel.logInfo, vLogOverload );
      end;
    except
      on E: Exception do
      begin
        PostMessageNewThreadInfo(Format(cFormatLogImport, [FormatDateTime(cFormatDTLog, Now), 'WebService exception ' + E.ClassName + ' - ' + E.Message, ExtractFileName(vSLListFilesNew.Strings[i])]));
      end;
    end;

    if vSLListFilesNew.Count <> 0 then
    begin
      vIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
      try
        vIniFile.WriteDateTime(cSecParamImport, cItmLASTDATEHEURE, Now);
      finally
        FreeAndNil(vIniFile);
      end;
    end;
    PostMessageNewThreadInfo('[' + FormatDateTime(cFormatDTLog, Now) + '] - Imports terminés');
    PostMessageNewThreadInfo(DupeString('-', 100));
//
  finally
    FreeAndNil(vTSearching);
    FreeAndNil(vSLListFilesOld);
    FreeAndNil(vSLListFilesNew);
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    pnlInfoImport.Caption:= '';
    CoUnInitialize;
    FreeAndNil(vCDS);
    FImportStarted:= False;
    Nbt_LancementManuel.Enabled := True;
    Nbt_TraitementFichierSelectionne.Enabled := True;
    Nbt_StartExports.Enabled := True;
    Btn_ExecuteInfoClientGet.Enabled := True;
  end;
end;

procedure TMainFrm.TimerExportTimer(Sender: TObject);
var
  Buffer: String;
begin
  if ListExtExport <> '' then
  begin
    Buffer := ListExtExport;
    ListExtExport := '';
  end
  else Buffer:= IsListHoraireExportNow;
  if (Buffer = '') or (FImportStarted) then
    Exit;

  FThrdExport:= TThrdExport.create(True);
  FThrdExport.OnTerminate:= pOnTerminateExport;
  FThrdExport.ListHoraireExportNow:= Buffer;
  FThrdExport.FreeOnTerminate:= True;
  FThrdExport.priority:= tpNormal;
  FThrdExport.Start;
end;

procedure TMainFrm.TimerImportIntervalTimer(Sender: TObject);
begin
  if (FExportStarted) or (FImportStarted) then
    Exit;

  FThrdImport:= TThrdImport.create(True);
  FThrdImport.FreeOnTerminate:= True;
  FThrdImport.priority:= tpNormal;
  FThrdImport.Start;
  Nbt_LancementManuel.Enabled := False;
  Nbt_TraitementFichierSelectionne.Enabled := False;
  Nbt_StartExports.Enabled := False;
  Btn_ExecuteInfoClientGet.Enabled := False;
end;

procedure TMainFrm.TimerImportTimer(Sender: TObject);
var
  vTimeDeb, vTimeFin, vTime: TTime;
begin
  vTimeDeb:= EncodeTime(StrToInt(Copy(MskEdtImportHeureDeb.Text, 1, 2)),
                        StrToInt(Copy(MskEdtImportHeureDeb.Text, 4, 2)), 0, 0);
  vTimeFin:= EncodeTime(StrToInt(Copy(MskEdtImportHeureFin.Text, 1, 2)),
                        StrToInt(Copy(MskEdtImportHeureFin.Text, 4, 2)), 0, 0);

  vTime:= Now - Trunc(Now);

  TimerImportInterval.Enabled:= (vTimeDeb <= vTime) and (vTime <= vTimeFin) { and (not TimerImportInterval.Enabled) };
end;

procedure TMainFrm.ti_AppBalloonClick(Sender: TObject);
begin
  ti_App.Visible := false;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TMainFrm.ti_AppClick(Sender: TObject);
begin
  ti_App.ShowBalloonHint();
end;

procedure TMainFrm.ti_AppDblClick(Sender: TObject);
begin
  ti_App.Visible := false;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TMainFrm.loadParams;
{$REGION 'loadParams'}
  procedure LoadParamToClientDataSet(Const AClienDataSet: TClientDataSet; ACxGridDBBandedTV: TcxGridDBBandedTableView; Const APrefixeSection: String);
  var
    i, j, k, h, vMaxValue, vPosBand: integer;
    vIniFile: TIniFile;
    vSL, vSLItm, vSLValue: TStrings;
    vBand: TCxGridBand;
    vCol: TcxGridDBBandedColumn;
    Buffer: String;
    vFileTypeItem : TFileTypeItem;
  begin
    vSL:= TStringList.Create;
    vSLItm:= TStringList.Create;
    vSLValue:= TStringList.Create;
    vIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
      vIniFile.ReadSections(vSL);
      vPosBand:= 0;
      for i:= 0 to vSL.Count -1 do
      begin
          if Copy(vSL.Strings[i], 1, 2) = APrefixeSection then
          begin
              vIniFile.ReadSection(vSL.Strings[i], vSLItm);
              vBand:= AddBand(ACxGridDBBandedTV, Copy(vSL.Strings[i], 3, Length(vSL.Strings[i])-2), 150 * vSLItm.Count, vPosBand);

              for j:= 0 to vSLItm.Count -1 do
              begin
                  vCol:= AddCol(ACxGridDBBandedTV, vSLItm.Strings[j], vSLItm.Strings[j]);
                  vCol.Position.BandIndex:= vBand.Index;

                  AClienDataSet.FieldDefs.Add(vSLItm.Strings[j], ftString, 10);
              end;

              Inc(vPosBand);
          end;
        end;

      ACxGridDBBandedTV.DataController.CreateAllItems;
      AClienDataSet.CreateDataSet;

      vMaxValue:= 0;
      vIniFile.ReadSections(vSL);
      FileOpenDialogDefaultPath.FileTypes.Clear;
      for i:= 0 to vSL.Count -1 do
      begin
          if Copy(vSL.Strings[i], 1, 2) = APrefixeSection then
          begin
              vIniFile.ReadSection(vSL.Strings[i], vSLItm);
              for j:= 0 to vSLItm.Count -1 do
              begin
                  Buffer:= vIniFile.ReadString(vSL.Strings[i], vSLItm.Strings[j], '');
                  vSLValue.Text:= StringReplace(Buffer, ';', #13#10, [rfReplaceAll]);
                  if vSLValue.Count > vMaxValue then
                    vMaxValue:= vSLValue.Count;
//JB
                  for k:= 0 to vSLValue.Count -1 do
                  begin
                    vFileTypeItem := FileOpenDialogDefaultPath.FileTypes.Add;
                    vFileTypeItem.FileMask := '*.' + vSLValue.Strings[k];
                  end;
//
              end;
          end;
      end;

      for i:= 0 to vMaxValue -1 do
      begin
          AClienDataSet.Append;
          AClienDataSet.Post;
      end;

      vIniFile.ReadSections(vSL);
      for i:= 0 to vSL.Count -1 do
      begin
          if Copy(vSL.Strings[i], 1, 2) = APrefixeSection then
          begin
              vIniFile.ReadSection(vSL.Strings[i], vSLItm);

              for j:= 0 to vSLItm.Count -1 do
              begin
                  Buffer:= vIniFile.ReadString(vSL.Strings[i], vSLItm.Strings[j], '');
                  vSLValue.Text:= StringReplace(Buffer, ';', #13#10, [rfReplaceAll]);

                  AClienDataSet.First;
                  for h:= 0 to vSLValue.Count -1 do
                  begin
                      AClienDataSet.Edit;
                      AClienDataSet.FieldByName(vSLItm.Strings[j]).AsString:= vSLValue.Strings[h];
                      AClienDataSet.Post;
                      AClienDataSet.Next;
                  end;
              end;
          end;
      end;
    finally
      FreeAndNil(vIniFile);
      FreeAndNil(vSL);
      FreeAndNil(vSLItm);
      FreeAndNil(vSLValue);
    end;
  end;
{$ENDREGION}
var
  vIniFile: TIniFile;
  vTimeDeb, vTimeFin: TTime;
begin
  DsParamExport.DataSet:= nil;
  cxGridDBBandedTVParamExport.ClearItems;
  cxGridDBBandedTVParamExport.Bands.Clear;
  cxGridDBBandedTVParamImport.ClearItems;
  cxGridDBBandedTVParamImport.Bands.Clear;

  if FCDSParamExport <> nil then
    FreeAndNil(FCDSParamExport);

  if FCDSParamImport <> nil then
    FreeAndNil(FCDSParamImport);

  FCDSParamExport:= TClientDataSet.Create(Self);
  FCDSParamImport:= TClientDataSet.Create(Self);

  LoadParamToClientDataSet(FCDSParamExport, cxGridDBBandedTVParamExport, 'E_');
  LoadParamToClientDataSet(FCDSParamImport, cxGridDBBandedTVParamImport, 'I_');

  DsParamExport.DataSet:= FCDSParamExport;
  DsParamImport.DataSet:= FCDSParamImport;

  vIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    FURLWS:= vIniFile.ReadString(cSecParam, cItmURLDWS, '');
    FTimeOutWS := vIniFile.ReadInteger(cSecParam, cItmTimeOutWS, cReceiveTimeoutWS);
    FIsUseWSDL:= FURLWS <> '';
    EdtPasswordWS.Text:= EncryptDecryptChaine(vIniFile.ReadString(cSecParam, cItmPASSWORDWS, ''));
    {$REGION 'Chargement des paramètres SFTP'}
    EdtLoginSFTP.Text     := vIniFile.ReadString( cSecParamSFTP, cItmLOGIN, '' );
    EdtPasswordSFTP.Text  := EncryptDecryptChaine( vIniFile.ReadString( cSecParamSFTP, cItmPASSWORD, '' ));
    EdtRepDistantSFTPImpGOS.Text:= vIniFile.ReadString( cSecParamSFTP, cItmREPFTPDISTANTIMPGOS, '' );
    EdtRepDistantSFTPImpCOU.Text:= vIniFile.ReadString( cSecParamSFTP, cItmREPFTPDISTANTIMPCOU, '' );
    EdtRepDistantSFTPExpGOS.Text:= vIniFile.ReadString( cSecParamSFTP, cItmREPFTPDISTANTEXPGOS, '' );
    EdtRepDistantSFTPExpCOU.Text:= vIniFile.ReadString( cSecParamSFTP, cItmREPFTPDISTANTEXPCOU, '' );
    EdtFileOutSFTP.Text   := vIniFile.ReadString( cSecParamSFTP, cItmFILEOUT, '' );
    EdtRepLocalSFTP.Text  := vIniFile.ReadString( cSecParamSFTP, cItmLOCALDEST, '' );
    EdtHostSFTP.Text      := vIniFile.ReadString( cSecParamSFTP, cItmHOST, '' );

    EdtPortSFTP.Text      := IntToStr( vIniFile.ReadInteger( cSecParamSFTP, cItmPORT, 22 ));
    edt_Archivage.Text    := vIniFile.ReadString( cSecParamSFTP, cItmRepArchivage, '');
    {$ENDREGION}

    vTimeDeb:= vIniFile.ReadTime(cSecParamImport, cItmHEUREDEB, Now);
    vTimeFin:= vIniFile.ReadTime(cSecParamImport, cItmHEUREFIN, Now);
    MskEdtImportHeureDeb.Text:= FormatDateTime('hh:nn', vTimeDeb);
    MskEdtImportHeureFin.Text:= FormatDateTime('hh:nn', vTimeFin);

    seImportInterval.value:= vIniFile.ReadInteger(cSecParamImport, cItmINTERVAL, 5);
    seImportDelaiIteration.Value:= vIniFile.ReadInteger(cSecParamImport, cItmDELAIITERATION, 5);
    FMaxLinesFiles := vIniFile.ReadInteger(cSecParamImport, cItmFileMaxLines, cFileMaxLines);
    seExportInterval.value:= vIniFile.ReadInteger(cSecParamExport, cItmINTERVAL, 5);


    TimerImport.Interval         := seImportInterval.Value*60*1000;        // En minutes
    TimerImportInterval.Interval := seImportDelaiIteration.Value*60*1000;
    TimerExport.Interval         := seExportInterval.value*1000;          // en secondes

    StatusBar1.Panels[0].Text := FURLWS;

    FLastHeureExport:= vIniFile.ReadString(cSecParamExport, cItmLASTHEURE, '');

    LoadListHoraireExport;
    LoadListExtImport;
  finally
    FreeAndNil(vIniFile);
  end;
end;

procedure TMainFrm.MemoImportChange(Sender: TObject);
begin
  try
    while MemoImport.Lines.Count > 10000 do
      MemoImport.Lines.Delete(1);
    MemoImport.Lines.SaveToFile(FLogFile);
    SendMessage(MemoImport.Handle, EM_LINESCROLL, 0, MemoImport.Lines.Count);
  except
    /// ???
  end;
end;

procedure TMainFrm.NbPointsClientGet(const ACentrale: Integer; const ANumCarte: String);
var
  vDateTime, vPassword: string;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  vNbPointsClient: TNbPointsClient;
begin
  Screen.Cursor:= crHourGlass;
  vRIO:= THTTPRIO.Create(nil);
  MemoNbPointsClientGet.Lines.Clear;
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

    vDateTime:= vI_BaseClientNationale.GetTime;
    vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));

    vNbPointsClient:= vI_BaseClientNationale.NbPointsClientGet(vDateTime, vPassword, ANumCarte, ACentrale);

    if vNbPointsClient.iErreur = 0 then
      begin
        if vNbPointsClient.sSoldePts <> '-1' then
          begin
            MemoNbPointsClientGet.Lines.Append('Solde points : ' + vNbPointsClient.sSoldePts);
            MemoNbPointsClientGet.Lines.Append('Date du solde points : ' + vNbPointsClient.sDateSoldePts);
          end
        else
          MemoNbPointsClientGet.Lines.Append('Aucune donnée');
      end
    else
      MemoNbPointsClientGet.Lines.Append('Erreur : ' + vNbPointsClient.sMessage);

  finally
    FreeAndNil(vNbPointsClient);
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainFrm.Nbt_TraitementFichierSelectionneClick(Sender: TObject);
begin
  if FileExists(ComboBoxFilePathAndName.Text) then
  begin
    FileToTraiter := ComboBoxFilePathAndName.Text;
    TimerImportIntervalTimer(Self);
  end
  else MessageDlg('Fichier inexistant',mtError,[mbOk],0);
end;

procedure TMainFrm.pOnTerminateExport(Sender: TObject);
begin
  LoadLogExportInfo;
end;

procedure TMainFrm.SpdBtnImportClearClick(Sender: TObject);
begin
  MemoImport.Lines.Clear;
end;

procedure TMainFrm.SpdBtnRefreshExportClick(Sender: TObject);
begin
  LoadLogExportInfo;
end;

procedure TMainFrm.Nbt_LancementManuelClick(Sender: TObject);
begin
  TimerImportIntervalTimer(Self);
end;

procedure TMainFrm.Nbt_StartExportsClick(Sender: TObject);
var
  I: Integer;
begin
  ListExtExport := '';
  for I := 2 to CheckListBoxExtExport.Items.Count-1 do
  begin
    if CheckListBoxExtExport.Checked[I] = True then
      ListExtExport := ListExtExport + CheckListBoxExtExport.Items[I] + cRC;
  end;
  TimerExportTimer(Self);
end;

procedure TMainFrm.SaveParams;

  procedure SaveParamToClientDataSet(Const AClienDataSet: TClientDataSet; ACxGridDBBandedTV: TcxGridDBBandedTableView; Const APrefixeSection: String);
  var
    i: integer;
    Buffer, vValue: String;
    vIniFile: TIniFile;
    vCol: TcxGridDBBandedColumn;
    vBM: TBookmark;
  begin
    vIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    vBM:= AClienDataSet.GetBookmark;
    AClienDataSet.DisableControls;
    try
      for i:= 0 to AClienDataSet.FieldCount -1 do
        begin
          Buffer:= '';
          vValue:= '';
          AClienDataSet.First;
          while not AClienDataSet.Eof do
            begin
              if AClienDataSet.Fields[i].AsString <> '' then
                begin
                  vValue:= vValue + Buffer + AClienDataSet.Fields[i].AsString;
                  Buffer:= ';';
                end;

              AClienDataSet.Next;
            end;

          if vValue <> '' then
            begin
              vCol:= ACxGridDBBandedTV.GetColumnByFieldName(AClienDataSet.Fields[i].FieldName);
              vIniFile.WriteString(APrefixeSection + vCol.Position.Band.Caption, AClienDataSet.Fields[i].FieldName, vValue);
            end;
        end;
    finally
      AClienDataSet.GotoBookmark(vBM);
      AClienDataSet.FreeBookmark(vBM);
      AClienDataSet.EnableControls;
      FreeAndNil(vIniFile);
    end;
  end;

var
  vIniFile: TIniFile;
begin
  SaveParamToClientDataSet(FCDSParamExport, cxGridDBBandedTVParamExport, 'E_');
  SaveParamToClientDataSet(FCDSParamImport, cxGridDBBandedTVParamImport, 'I_');

  vIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    vIniFile.WriteString(cSecParam, cItmPASSWORDWS, EncryptDecryptChaine(EdtPasswordWS.Text));
    {$REGION 'Sauvegarde des paramètres SFTP'}
    vIniFile.WriteString( cSecParamSFTP, cItmLOGIN, EdtLoginSFTP.Text );
    vIniFile.WriteString( cSecParamSFTP, cItmPASSWORD, EncryptDecryptChaine( EdtPasswordSFTP.Text ));
    vIniFile.WriteString( cSecParamSFTP, cItmREPFTPDISTANTIMPGOS, EdtRepDistantSFTPImpGOS.Text );
    vIniFile.WriteString( cSecParamSFTP, cItmREPFTPDISTANTIMPCOU, EdtRepDistantSFTPImpCOU.Text );
    vIniFile.WriteString( cSecParamSFTP, cItmREPFTPDISTANTEXPGOS, EdtRepDistantSFTPExpGOS.Text );
    vIniFile.WriteString( cSecParamSFTP, cItmREPFTPDISTANTEXPCOU, EdtRepDistantSFTPExpCOU.Text );
    vIniFile.WriteString( cSecParamSFTP, cItmFILEOUT, EdtFileOutSFTP.Text );
    vIniFile.WriteString( cSecParamSFTP, cItmLOCALDEST, EdtRepLocalSFTP.Text );
    vIniFile.WriteString( cSecParamSFTP, cItmHOST, EdtHostSFTP.Text );
    vIniFile.WriteInteger( cSecParamSFTP, cItmPORT, StrToInt( EdtPortSFTP.Text ));
    vIniFile.WriteString( cSecParamSFTP, cItmRepArchivage, edt_Archivage.Text);
    {$ENDREGION}

    vIniFile.WriteInteger(cSecParamImport, cItmINTERVAL, seImportInterval.Value);
    vIniFile.WriteInteger(cSecParamImport, cItmDELAIITERATION, seImportDelaiIteration.Value);
    vIniFile.WriteTime(cSecParamImport, cItmHEUREDEB, StrToTime(MskEdtImportHeureDeb.Text));
    vIniFile.WriteTime(cSecParamImport, cItmHEUREFIN, StrToTime(MskEdtImportHeureFin.Text));
    vIniFile.WriteString(cSecParamExport, cItmLASTHEURE, '');
    vIniFile.WriteInteger(cSecParamExport, cItmINTERVAL, seExportInterval.Value);

  finally
    FreeAndNil(vIniFile);
  end;
end;

procedure TMainFrm.SendFileToSFTP(const AUserName, APassword, AHost, ARemoteDir, ALocalPathAndFileName: String; const DeleteAfterSend: Boolean; const APort: Integer);
var
  ArchivePath : string;
begin
  try
    ElSimpleSFTPClient.Username := AUserName;
    ElSimpleSFTPClient.Password := APassword;
    ElSimpleSFTPClient.Address  := AHost;
    ElSimpleSFTPClient.Port     := APort;
    ElSimpleSFTPClient.CompressionAlgorithms[ SSH_CA_ZLIB ] := True;
    ElSimpleSFTPClient.AuthenticationTypes := ElSimpleSFTPClient.AuthenticationTypes and not SSH_AUTH_TYPE_PUBLICKEY;
    ElSimpleSFTPClient.Open;

    if not ElSimpleSFTPClient.Active then
      raise Exception.Create('Connexion SFTP impossible.');

    if FileExists( ALocalPathAndFileName ) and ElSimpleSFTPClient.FileExists( ARemoteDir ) then
    begin
      ElSimpleSFTPClient.UploadFile( ALocalPathAndFileName, IncludeTrailingSlash( ARemoteDir ) + ExtractFileName( ALocalPathAndFileName ) );
      if ElSimpleSFTPClient.FileExists( IncludeTrailingSlash( ARemoteDir ) + ExtractFileName( ALocalPathAndFileName ) ) then
      begin
        if Trim(edt_Archivage.Text) = '' then
        begin
          if DeleteAfterSend then
            DeleteFile(ALocalPathAndFileName);
        end
        else
        begin
//JB
//          if ALocalPathAndFileName[Length(ALocalPathAndFileName)] = '7' then
          ArchivePath := IncludeTrailingPathDelimiter(edt_Archivage.Text) + 'Export\' + FormatDateTime('yyyy\mm\dd\', Now());
//          ArchivePath := IncludeTrailingPathDelimiter(edt_Archivage.Text) + 'COURIR\' + FormatDateTime('yyyy\mm\dd\', Now());
//          else if ALocalPathAndFileName[Length(ALocalPathAndFileName)] = '8' then
//            ArchivePath := IncludeTrailingPathDelimiter(edt_Archivage.Text) + 'GOSPORT\' + FormatDateTime('yyyy\mm\dd\', Now())
//          else
//            ArchivePath := IncludeTrailingPathDelimiter(edt_Archivage.Text) + 'AUTRE\' + FormatDateTime('yyyy\mm\dd\', Now());
          ForceDirectories(ArchivePath);
          if DeleteAfterSend then
            MoveFile(PChar(ALocalPathAndFileName), PChar(ArchivePath + ExtractFileName(ALocalPathAndFileName)))
          else
            CopyFile(PChar(ALocalPathAndFileName), PChar(ArchivePath + ExtractFileName(ALocalPathAndFileName)), false);
        end;
      end;
    end;
  finally
    if ElSimpleSFTPClient.Active then
      ElSimpleSFTPClient.Close( True );
  end;
end;

procedure TMainFrm.SendFileToSFTP(const AUserName, APassword, AHost, ARemoteDir : String ; AFileList: TStringList; const DeleteAfterSend: Boolean; const APort: Integer);
var
  i : integer ;
  vFileName : string;
  ArchivePath : string;
begin
  if not Assigned(AFileList) then Exit ;

  try
    ElSimpleSFTPClient.Username := AUserName;
    ElSimpleSFTPClient.Password := APassword;
    ElSimpleSFTPClient.Address  := AHost;
    ElSimpleSFTPClient.Port     := APort;
    ElSimpleSFTPClient.CompressionAlgorithms[ SSH_CA_ZLIB ] := True;
    ElSimpleSFTPClient.AuthenticationTypes := ElSimpleSFTPClient.AuthenticationTypes and not SSH_AUTH_TYPE_PUBLICKEY;
    ElSimpleSFTPClient.Open;

    if not ElSimpleSFTPClient.Active then
      raise Exception.Create('Connexion SFTP impossible.');

    if ElSimpleSFTPClient.FileExists( ARemoteDir ) then
    begin
      for i:=0 to AFileList.Count - 1 do
      begin
        vFileName := AFileList[i] ;
        if ((vFileName <> '') and (FileExists(vFileName))) then
        begin
          ElSimpleSFTPClient.UploadFile( vFileName, IncludeTrailingSlash( ARemoteDir ) + ExtractFileName( vFileName ));
          if ElSimpleSFTPClient.FileExists( IncludeTrailingSlash( ARemoteDir ) + ExtractFileName( vfileName ) ) then
          begin
            if Trim(edt_Archivage.Text) = '' then
            begin
              if DeleteAfterSend then
                DeleteFile(vFileName);
            end
            else
            begin
//JB
              ArchivePath := IncludeTrailingPathDelimiter(edt_Archivage.Text) + 'Export\' + FormatDateTime('yyyy\mm\dd\', Now());
//              if vFileName[Length(vFileName)] = '7' then
//                ArchivePath := IncludeTrailingPathDelimiter(edt_Archivage.Text) + 'COURIR\' + FormatDateTime('yyyy\mm\dd\', Now())
//              else if vFileName[Length(vFileName)] = '8' then
//                ArchivePath := IncludeTrailingPathDelimiter(edt_Archivage.Text) + 'GOSPORT\' + FormatDateTime('yyyy\mm\dd\', Now())
//              else
//                ArchivePath := IncludeTrailingPathDelimiter(edt_Archivage.Text) + 'AUTRE\' + FormatDateTime('yyyy\mm\dd\', Now());
              ForceDirectories(ArchivePath);

              if DeleteAfterSend then
                MoveFile(PChar(vFileName), PChar(ArchivePath + ExtractFileName(vFileName)))
              else
                CopyFile(PChar(vFileName), PChar(ArchivePath + ExtractFileName(vFileName)), false);
            end;
          end

        end
      end;
    end ;

  finally
    if ElSimpleSFTPClient.Active then
      ElSimpleSFTPClient.Close( True );
  end;
end;

procedure TMainFrm.SetExport(Const AListExportToSend: String);

const
  cExtensionsCourir: array[ 0..2 ] of String = ( 'INS7', 'BRE7' ,'FRE7' );
  cExtensionsGosport: array[ 0..1 ] of String = ( 'INS8', 'BRE8' );

  procedure LogExport(const LogKey, LogVal: String;
    const LogLevel: TLogLevel; const Override: Boolean);
  var
    vLogMdl: String;
  begin
    case AnsiIndexText( LogKey, [ 'INS7', 'FRE7', 'INS8' ] ) of
      0, 1: vLogMdl := 'COURIR';
      2: vLogMdl := 'GOSPORT';
      else Exit;
    end;

    {$IFDEF DEBUG}
    PostMessageNewThreadInfo(
      Format(
        '{"srv":"%s","mdl":"%s","dos":"%s","ref":"%s","key":"%s","val":"%s","lvl":%d,"ovl":%d}', [
          Log.Host, vLogMdl, 'EXPORT', '', LogKey, ExtractFileName( LogVal ), Ord( LogLevel ), Ord( Override )
        ]
      )
    );
    {$ELSE}
    Log.Log( Log.Host, vLogMdl, 'EXPORT', '', '', LogKey, ExtractFileName( LogVal ), LogLevel, Override );
    {$ENDIF}
  end;

  function IsWatchedExtension(const Extension: String): Boolean; inline;
  begin
    Exit(
      IndexText( Extension, [ 'INS7', 'FRE7', 'INS8' ] ) > -1
    );
  end;

var
  i: integer;
  Buffer: String;
  vDateTime, vPassword, vRepLocal: String;
  vSLListExt, vSLLog: TStringList;
  vRemotableGnk: TRemotableGnk;
  vRIO: THTTPRIO;
  vI_BaseClientNationale: I_BaseClientNationale;
  vIniFile: TIniFile;
  vTSearching: TSearching;
  vFileList : TStringList;

  vInfoSearch: TInfoSearch;
  vExtensionOccurences: TDictionary< String{extension}, Cardinal{occurences}>;
  vExtension: String;
begin
  if AListExportToSend = '' then
    Exit;
  FExportStarted:= True;
  TimerExport.Enabled:= False;
  vSLListExt:= TStringList.Create;
  vSLLog:= TStringList.Create;
  vRIO:= THTTPRIO.Create(nil);
  vIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  vTSearching:= TSearching.Create;
  try
    vRIO.HTTPWebNode.ReceiveTimeout:= FTimeOutWS;
    vI_BaseClientNationale:= GetI_BaseClientNationale(FIsUseWSDL, FURLWS, vRIO);

    vRepLocal:= IncludeTrailingBackslash(EdtRepLocalSFTP.Text) + 'Export';
    if not DirectoryExists(vRepLocal) then
      ForceDirectories(vRepLocal);

    vSLListExt.Text:= AListExportToSend;

    CoInitialize(nil);
    for i:= 0 to vSLListExt.Count -1 do
      begin
        try
          vDateTime:= vI_BaseClientNationale.GetTime;
          vPassword:= MD5(Entrelacement(vDateTime, EdtPasswordWS.Text));

          if UpperCase(Copy(vSLListExt.Strings[i], 1, 2)) = 'BR' then
            vRemotableGnk:= vI_BaseClientNationale.ExportBonRepris(vDateTime, vPassword, vSLListExt.Strings[i], vRepLocal)
          else
          begin
            vRemotableGnk:= vI_BaseClientNationale.ExportClients(vDateTime, vPassword, vSLListExt.Strings[i], vRepLocal);
            if IsWatchedExtension( vSLListExt[ i ] ) then
              LogExport( UpperCase( vSLListExt[ i ] ), vRemotableGnk.sFilename, TLogLevel.logInfo, True );
          end;

          case vRemotableGnk.iErreur of
            0: {$REGION 'Succeed'}begin
            end;{$ENDREGION 'Succeed'}
            1: {$REGION 'Failed'}begin
              vSLLog.Append('Export : ' + vSLListExt.Strings[i] + cRC + '--> ' + vRemotableGnk.sMessage + cRC);
              if IsWatchedExtension( vSLListExt[ i ] ) then
                LogExport( UpperCase( vSLListExt[ i ] ), vRemotableGnk.sFilename, TLogLevel.logError, False );
            end;{$ENDREGION 'Failed'}
            else {$REGION 'Unknown'}begin
            end;{$ENDREGION 'Unknown'}
          end;
        except
          on E: Exception do
          begin
            vsLLog.Append('Exception : pendant l''export de ' + vSLListExt.Strings[i] + ' :  ' + E.Message);
            if IsWatchedExtension(vSLListExt[i]) then
              LogExport(UpperCase(vSLListExt[i]), E.Message, TLogLevel.logError, False);
          end;
        end;
      end;

    vIniFile.WriteString(cSecParamExport, cItmLASTHEURE, FLastHeureExport);
    Lab_InfoExport.Caption := Format(cMsgLastExport, [FLastHeureExport]);
    if FNextHeureExport <> '' then
      Lab_InfoExport.Caption := Lab_InfoExport.Caption + Format(cMsgNextExport, [FNextHeureExport]);

    vExtensionOccurences := TDictionary< String, Cardinal >.Create;
    try
  // FL :   - Optimisation pour eviter de fermer la connexion SFTP a chaque fichier.
  //        - Filtre pour n'envoyer que les extensions souhaitées et non tout le répertoire export.

      vFileList := TStringList.Create ;

      // Fichier Courir
      vFileList.Clear();

      for vExtension in cExtensionsCourir do
      begin
        vTSearching.Searching(ShortString(vRepLocal), ShortString(Concat('*.', vExtension)), False, True);
        for vInfoSearch in vTSearching.TabInfoSearch do
          vFileList.Add(String(vInfoSearch.PathAndName));
        vExtensionOccurences.Add( vExtension, vTSearching.NbFilesFound );
      end;

      if (vFileList.Count > 0) then
      begin
        try
          SendFileToSFTP( EdtLoginSFTP.Text, EdtPasswordSFTP.Text,
                        EdtHostSFTP.Text, EdtRepDistantSFTPExpCOU.Text,
                        vFileList, True, StrToInt( EdtPortSFTP.Text ));
          vSLLog.Append(IntToStr(vFileList.Count) + ' File(s) exported to SFTP');
        except
          on E:Exception do
            vSLLog.Append('SFTP Exception : ' + e.Message) ;
        end;
      end ;

      // Fichier GoSport
      vFileList.Clear();

      for vExtension in cExtensionsGosport do
      begin
        vTSearching.Searching(ShortString(vRepLocal), ShortString(Concat('*.', vExtension)), False, True);
        for vInfoSearch in vTSearching.TabInfoSearch do
          vFileList.Add(String(vInfoSearch.PathAndName));
        vExtensionOccurences.Add( vExtension, vTSearching.NbFilesFound );
      end;

      if (vFileList.Count > 0) then
      begin
        try
          SendFileToSFTP( EdtLoginSFTP.Text, EdtPasswordSFTP.Text,
                        EdtHostSFTP.Text, EdtRepDistantSFTPExpGOS.Text,
                        vFileList, True, StrToInt( EdtPortSFTP.Text ));
          vSLLog.Append(IntToStr(vFileList.Count) + ' File(s) exported to SFTP');
        except
          on E:Exception do
            vSLLog.Append('SFTP Exception : ' + e.Message) ;
        end;
      end ;


      vFileList.Free ;

      if vSLLog.Count <> 0 then
      begin
          Buffer:= vRepLocal + '\Log';
          if not DirectoryExists(Buffer) then
            ForceDirectories(Buffer);

          Buffer:= Buffer + '\' + FormatDateTime('yyyymmdd', Now) +
                   StringReplace(FLastHeureExport, ':', '', [rfReplaceAll]) + '.log';
          vSLLog.SaveToFile(Buffer);
      end;
    finally
      vExtensionOccurences.Free;
    end;


{
    vTSearching.Searching(vRepLocal, '*.*', False, True);
    if vTSearching.NbFilesFound <> 0 then
      begin
        for i:= 0 to vTSearching.NbFilesFound -1 do
          begin
            if vTSearching.TabInfoSearch[i].PathAndName <> '' then
              begin

                //--> Placer le code ici pour traiter l'envoi des fichiers

//                SendFileToFTP(EdtLoginFTP.Text, EdtPasswordFTP.Text, EdtHost.Text, EdtRepDistant.Text,
//                              vTSearching.TabInfoSearch[i].PathAndName, nil, True, StrToInt(EdtPort.Text));
                (* fyi: ElSimpleSFTPClient permet de faire un upload 'multi-fichiers' mais j'ai choisi de conserver cet mécanique ci-dessus *)

                SendFileToSFTP( EdtLoginSFTP.Text, EdtPasswordSFTP.Text,
                                EdtHostSFTP.Text, EdtRepDistantExpSFTP.Text,
                                vTSearching.TabInfoSearch[i].PathAndName, True, StrToInt( EdtPortSFTP.Text ));
              end;
          end;
      end;
}


  finally
    FreeAndNil(vIniFile);
    FreeAndNil(vSLListExt);
    FreeAndNil(vSLLog);
    FreeAndNil(vTSearching);
    if vI_BaseClientNationale = nil then
      FreeAndNil(vRIO);
    CoUnInitialize;
    TimerExport.Enabled:= True;
    FExportStarted:= False;
  end;
end;

initialization
  SetLicenseKey(
    '4003D46B2B8444C662FA106C95792805D3E87D27FC53D6E57C3050AEA3E7375A' +
    'E9D03CD909F3120E8E740B4510CEA0E5D3303E83DD28EFEB5862603B18E7EF46' +
    '2FA3CE11BDECA8DC271B63F7F53D6EEEA8709B45130709DC97A73B9EFD3A8D92' +
    'DF286D7B55C02D26322D76D4E0312936C177419931345AED6B3A298774A71B05' +
    'F4DE9D00FCF9DC55F907219D5AB67032F7D184F4CD069CE39F28E60AE4DA6034' +
    'B434939F74F61535C602116CFAEBF228F6477B7D20D7FC43D8502ADA45359169' +
    '3D708AFDAB7A08DD8A2D3092082466DA583EF082625E8C3820BE5EF5B48D45B2' +
    'F76D49B11FE99F2295F677A8F3BD84A4560E73C231803D74EAFE53105B38017F'
  );

end.

