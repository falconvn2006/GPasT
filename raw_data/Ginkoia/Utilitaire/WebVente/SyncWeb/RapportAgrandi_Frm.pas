unit RapportAgrandi_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
  dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSCore, dxPSdxTLLnk,
  dxPSdxDBCtrlLnk, dxPSdxDBGrLnk, dxComponentPrinterHP, DB, dxmdaset, StdCtrls,
  RzLabel, dxDBTLCl, dxGrClms, dxDBCtrl, dxDBGrid, dxTL, dxCntner, dxDBGridHP,
  Boxes, PanBtnDbgHP, LMDBaseControl, LMDBaseGraphicControl,
  LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton, ExtCtrls, RzPanel;

type
  TFrm_RapportAgrandi = class(TForm)
    Pan_Bas: TRzPanel;
    Nbt_Quitter: TLMDSpeedButton;
    Pan_RappGrand: TPanelDbg;
    MemD_RappGrand: TdxMemData;
    MemD_RappGrandNOLIGNE: TIntegerField;
    MemD_RappGrandFICHIER: TStringField;
    MemD_RappGrandJDATE: TDateField;
    MemD_RappGrandJTIME: TTimeField;
    MemD_RappGrandLIGERR: TIntegerField;
    MemD_RappGrandLIBERR: TStringField;
    MemD_RappGrandNUMCOM: TStringField;
    MemD_RappGrandNUMART: TStringField;
    Ds_RappGrand: TDataSource;
    DBG_RappGrang: TdxDBGridHP;
    DxPrt_RappGrand: TdxComponentPrinterHP;
    DBG_RappGrangRecId: TdxDBGridColumn;
    DBG_RappGrangNOLIGNE: TdxDBGridMaskColumn;
    DBG_RappGrangFICHIER: TdxDBGridMaskColumn;
    DBG_RappGrangJDATE: TdxDBGridDateColumn;
    DBG_RappGrangJTIME: TdxDBGridTimeColumn;
    DBG_RappGrangLIGERR: TdxDBGridMaskColumn;
    DBG_RappGrangLIBERR: TdxDBGridMaskColumn;
    DBG_RappGrangNUMCOM: TdxDBGridMaskColumn;
    DBG_RappGrangNUMART: TdxDBGridMaskColumn;
    DxImp_RappGrand: TdxDBGridReportLink;
    MemD_RappGrandDATECOM: TStringField;
    MemD_RappGrandLIBPROD: TStringField;
    DBG_RappGrangDATECOM: TdxDBGridMaskColumn;
    DBG_RappGrangLIBPROD: TdxDBGridMaskColumn;
    Pan_Haut: TRzPanel;
    Lab_Tit: TRzLabel;
    Lab_DRapp: TRzLabel;
    procedure Nbt_QuitterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
    EtatFiche: boolean;
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Déclarations publiques }
    procedure InitEcr(AFileName, AFic: string; DRapport:TDateTime);
  end;

var
  Frm_RapportAgrandi: TFrm_RapportAgrandi;

implementation

{$R *.dfm}

procedure TFrm_RapportAgrandi.InitEcr(AFileName, AFic: string; DRapport:TDateTime);
begin
  Lab_Tit.Caption := 'Rapport Fichier : ' + AFic;
  DxImp_RappGrand.PrinterPage.PageHeader.LeftTitle.Text:='Rapport Fichier : '+AFic;
  DxImp_RappGrand.PrinterPage.PageHeader.RightTitle.Text:=Format('Date de l''import: %s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',DRapport)]);
  MemD_RappGrand.Active := false;
  MemD_RappGrand.DelimiterChar := ';';
  if not (FileExists(AFileName)) then
    exit;
  MemD_RappGrand.Active := true;
  MemD_RappGrand.LoadFromTextFile(AFileName);
  Lab_DRapp.Caption:=Format('Date de l''import: %s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',DRapport)]);
end;

procedure TFrm_RapportAgrandi.CMDialogKey(var M: TCMDialogKey);
begin
  if m.CharCode = VK_ESCAPE then begin
    m.Result := 1;
    Close;
  end;
  inherited;
end;

procedure TFrm_RapportAgrandi.FormActivate(Sender: TObject);
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

procedure TFrm_RapportAgrandi.FormCreate(Sender: TObject);
begin
  EtatFiche := false;
end;

procedure TFrm_RapportAgrandi.Nbt_QuitterClick(Sender: TObject);
begin
  Close;
end;

end.

