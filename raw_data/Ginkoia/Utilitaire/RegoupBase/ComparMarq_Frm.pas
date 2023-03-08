unit ComparMarq_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Boxes, PanBtnDbgHP, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, dxCntner, dxTL, dxDBCtrl, dxDBGrid,
  dxDBGridHP, RzLabel, RzPanel, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider,
  dxPSFillPatterns, dxPSEdgePatterns, dxPSCore, dxComponentPrinterHP, dxPSdxTLLnk, dxPSdxDBCtrlLnk, dxPSdxDBGrLnk, DB;
     
const
  WM_EXCELREPORT = WM_USER + 1001;

type
  TFrm_ComparMarq = class(TForm)
    DBG_Marq: TdxDBGridHP;
    Pan_bas: TPanel;
    Nbt_Close: TLMDButton;
    Pan_DbgMarq: TPanelDbg;
    dxPtr_Marq: TdxComponentPrinterHP;
    dxPtr_MarqLink1: TdxDBGridReportLink;
    Ds_Marq: TDataSource;
    DBG_MarqRecId: TdxDBGridColumn;
    DBG_MarqNomMarque: TdxDBGridMaskColumn;
    DBG_MarqMarqueBase1: TdxDBGridMaskColumn;
    DBG_MarqMarqueBase2: TdxDBGridMaskColumn;
    procedure DBG_MarqButtonGestionBeforeAction(Sender: TObject; ComponentName: string; var Allow: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }  
    EtatFiche: boolean;   
    FicExcel: string;
    procedure WmExportExcel(var m:TMessage); message WM_EXCELREPORT;
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    procedure SetInit(ANomBase1, ANomBase2: string);
  end;

var
  Frm_ComparMarq: TFrm_ComparMarq;

implementation  

uses
  Main_Dm, ShellApi, ExportExcelConfirm_Frm;

{$R *.dfm}

procedure TFrm_ComparMarq.WmExportExcel(var m:TMessage);
var
  sFileName: string;
  Flag: boolean;
  bOk: boolean;
  bOuvreExcel: boolean;
begin
  if FicExcel='' then
    exit;
  sFileName := ReperBase+'Exports\';
  if not(DirectoryExists(sFileName)) then
    ForceDirectories(sFileName);
  sFileName := sFileName+FicExcel;

  bOuvreExcel := false;
  bOk := false;
  Frm_ExportExcelConfirm := TFrm_ExportExcelConfirm.Create(Self);
  try
    Frm_ExportExcelConfirm.SetInit(sFilename);
    bOk := (Frm_ExportExcelConfirm.ShowModal = mrok);
    bOuvreExcel := Frm_ExportExcelConfirm.Chk_OuvrirExcel.Checked;
  finally
    Frm_ExportExcelConfirm.Free;
    Frm_ExportExcelConfirm:=nil;
  end;
  if not(bOk) then
    exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Flag := False;
  if (DBG_Marq.HPAddOn.Groupes.SummaryGroupOnTop and DBG_Marq.ShowRowFooter) then
  begin
    Flag := True;
    DBG_Marq.HpAddon.Groupes.SummaryGroupOnTop := false;
  end;
  DBG_Marq.BeginUpdate;
  try
    DBG_Marq.SaveToXLS(sFileName, true);
  finally
    if Flag then
      DBG_Marq.HpAddon.Groupes.SummaryGroupOnTop := true;

    DBG_Marq.EndUpdate;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

  if bOuvreExcel then
    ShellExecute(0, 'open', PChar(sFileName), nil, nil, SW_SHOW);
end;

procedure TFrm_ComparMarq.DBG_MarqButtonGestionBeforeAction(Sender: TObject; ComponentName: string; var Allow: Boolean);
begin   
  if UpperCase(ComponentName)='NBT_EXCEL' then
  begin
    Allow := false;
    PostMessage(Handle, WM_EXCELREPORT, 0, 0);
    exit;
  end;
end;

procedure TFrm_ComparMarq.FormActivate(Sender: TObject);
begin 
  if EtatFiche then
    exit;

  EtatFiche := true;
  Application.ProcessMessages;
  Align := AlNone;
  Application.ProcessMessages;
  ReAlign;    
  Application.ProcessMessages;
end;

procedure TFrm_ComparMarq.FormCreate(Sender: TObject);
begin   
  EtatFiche := false;
end;

procedure TFrm_ComparMarq.SetInit(ANomBase1, ANomBase2: string);
var
  d: TDateTime;
begin
  d := Now;
  FicExcel := 'Comparaison marque du '+
              FormatDateTime('dd-mm-yyyy', d)+' '+
              FormatDateTime('hh.nn.ss', d)+'.xls';

  dxPtr_MarqLink1.PrinterPage.PageHeader.CenterTitle.Text := 'Comparaison marque du '+
                                                               FormatDateTime('dd/mm/yyyy', d)+' '+
                                                               FormatDateTime('hh:nn:ss', d);
  DBG_MarqMarqueBase1.Caption := 'Marque Base '+ANomBase1;
  DBG_MarqMarqueBase2.Caption := 'Marque Base '+ANomBase2;
  
  if Dm_Main.MemD_Marque.Active then
    Dm_Main.MemD_Marque.First;
end;

procedure TFrm_ComparMarq.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin  
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

end.
