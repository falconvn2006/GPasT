unit Analyse_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, DB, RzLabel, RzPanel, dxCntner, dxTL, dxDBCtrl, dxDBGrid,
  dxDBGridHP, dxDBTLCl, dxGrClms, Boxes, PanBtnDbgHP, Grids, DBGrids, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd,
  dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSCore, dxPSdxTLLnk, dxPSdxDBCtrlLnk,
  dxPSdxDBGrLnk, dxComponentPrinterHP;
     
const
  WM_EXCELREPORT = WM_USER + 1001;

type
  TFrm_Analyse = class(TForm)
    Pan_Haut: TRzPanel;
    Lab_Tit: TRzLabel;
    Ds_DetailArt: TDataSource;
    Pan_bas: TPanel;
    Nbt_Close: TLMDButton;
    Pan_LstArt: TPanelDbg;
    DBG_DetArt: TdxDBGridHP;
    DBG_DetArtRecId: TdxDBGridColumn;
    DBG_DetArtMAGID: TdxDBGridMaskColumn;
    DBG_DetArtARTID: TdxDBGridMaskColumn;
    DBG_DetArtMAGENSEIGNE: TdxDBGridMaskColumn;
    DBG_DetArtARF_CHRONO: TdxDBGridMaskColumn;
    DBG_DetArtARTNOM: TdxDBGridMaskColumn;
    DBG_DetArtLibArt: TdxDBGridMaskColumn;
    DBG_DetArtRDATE: TdxDBGridDateColumn;
    DBG_DetArtRQTE: TdxDBGridMaskColumn;
    DBG_DetArtRSTOCKFIN: TdxDBGridMaskColumn;
    DBG_DetArtRNUMERO: TdxDBGridMaskColumn;
    DBG_DetArtRCATEG: TdxDBGridMaskColumn;
    dxPtr_DetArt: TdxComponentPrinterHP;
    dxPtr_DetArtLink1: TdxDBGridReportLink;
    Nbt_ReperErreur: TLMDButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBG_DetArtButtonGestionBeforeAction(Sender: TObject; ComponentName: string; var Allow: Boolean);
  private
    { Déclarations privées }
    EtatFiche: boolean;   
    FicExcel: string;     
    procedure WmExportExcel(var m:TMessage); message WM_EXCELREPORT;
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    procedure InitEcr(sFic, ANom: string);
  end;

var
  Frm_Analyse: TFrm_Analyse;

implementation

uses
  Main_Dm, ShellApi, ExportExcelConfirm_Frm;

{$R *.dfm}

procedure TFrm_Analyse.WmExportExcel(var m:TMessage);
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
  if (DBG_DetArt.HPAddOn.Groupes.SummaryGroupOnTop and DBG_DetArt.ShowRowFooter) then
  begin
    Flag := True;
    DBG_DetArt.HpAddon.Groupes.SummaryGroupOnTop := false;
  end;
  DBG_DetArt.BeginUpdate;
  try
    DBG_DetArt.SaveToXLS(sFileName, true);
  finally
    if Flag then
      DBG_DetArt.HpAddon.Groupes.SummaryGroupOnTop := true;

    DBG_DetArt.EndUpdate;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

  if bOuvreExcel then
    ShellExecute(0, 'open', PChar(sFileName), nil, nil, SW_SHOW);
end;

procedure TFrm_Analyse.InitEcr(sFic, ANom: string);
var
  d: TDatetime;
begin
  Dm_Main.MemD_DetailArt.Close;
  Dm_Main.MemD_DetailArt.Open;
  Dm_Main.MemD_DetailArt.LoadFromTextFile(sFic);

  d := FileDateToDateTime(FileAge(sFic));

  Lab_Tit.Caption := 'Analyse article du '+
                     FormatDateTime('dd/mm/yyyy', d)+' '+
                     FormatDateTime('hh:nn:ss', d);

  dxPtr_DetArtLink1.PrinterPage.PageHeader.CenterTitle.Text:=Lab_Tit.Caption;

  FicExcel := ANom+'_'+
              'Analyse article du '+
              FormatDateTime('dd-mm-yyyy', d)+' '+
              FormatDateTime('hh.nn.ss', d)+'.xls';
end;

procedure TFrm_Analyse.WMSysCommand(var Msg: TWMSyscommand);
begin  
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

procedure TFrm_Analyse.DBG_DetArtButtonGestionBeforeAction(Sender: TObject; ComponentName: string; var Allow: Boolean);
begin   
  if UpperCase(ComponentName)='NBT_EXCEL' then
  begin
    Allow := false;
    PostMessage(Handle, WM_EXCELREPORT, 0, 0);
    exit;
  end;
end;

procedure TFrm_Analyse.FormActivate(Sender: TObject);
begin
  if EtatFiche then
    exit;

  EtatFiche := true;
  Application.ProcessMessages;
  Align := AlNone;
  Application.ProcessMessages;
  ReAlign;
end;

procedure TFrm_Analyse.FormCreate(Sender: TObject);
begin
  EtatFiche := false;
end;

end.
