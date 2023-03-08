unit TraiteAuto_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LMDCustomButton, LMDButton, dxTL, dxDBCtrl, dxDBGrid, dxCntner, dxDBGridHP, DB, RzLabel;

type
  TFrm_TraiteAuto = class(TForm)
    Lab_ChxBase: TRzLabel;
    Ds_Base: TDataSource;
    DBG_SiteVtePriv: TdxDBGridHP;
    DBG_SiteVtePrivInd: TdxDBGridMaskColumn;
    DBG_SiteVtePrivNom: TdxDBGridMaskColumn;
    DBG_SiteVtePrivBase: TdxDBGridMaskColumn;
    Lab_Info1: TLabel;
    Lab_Info2: TLabel;
    Chk_Analyse: TCheckBox;
    Chk_Rech: TCheckBox;
    Chk_Recal: TCheckBox;
    Lab_Resultat: TLabel;
    EResultat: TEdit;
    Nbt_Close: TLMDButton;
    procedure FormCreate(Sender: TObject);
    procedure Ds_BaseDataChange(Sender: TObject; Field: TField);
    procedure Chk_AnalyseClick(Sender: TObject);
    procedure EResultatEnter(Sender: TObject);
    procedure EResultatMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    procedure DoResultat;
  public
    { Déclarations publiques }
  end;

var
  Frm_TraiteAuto: TFrm_TraiteAuto;

implementation

uses
  Main_Dm; 

{$R *.dfm}

procedure TFrm_TraiteAuto.Chk_AnalyseClick(Sender: TObject);
begin
  DoResultat;
end;

procedure TFrm_TraiteAuto.DoResultat;
var
  sParam: string;
  bAnalyse: integer;
  bRech: integer;
  bCalc: integer;
begin
  sParam:='/BASE=';
  if Dm_Main.Cds_Base.RecordCount>0 then
    sParam := sParam+Dm_Main.Cds_Base.fieldbyname('Nom').AsString;

  if Chk_Analyse.Checked then
    bAnalyse := 1
  else
    bAnalyse := 0;
  if Chk_Rech.Checked then
    bRech := 1
  else
    bRech := 0;
  if Chk_Recal.Checked then
    bCalc := 1
  else
    bCalc := 0;
  sParam := sParam+' /ANALYSE='+inttostr(bAnalyse)+' /RECH='+inttostr(bRech)+' /RECALC='+inttostr(bCalc);
  EResultat.Text := sParam;
end;

procedure TFrm_TraiteAuto.Ds_BaseDataChange(Sender: TObject; Field: TField);
begin
  DoResultat;
end;

procedure TFrm_TraiteAuto.EResultatEnter(Sender: TObject);
begin
  EResultat.SelectAll;
end;

procedure TFrm_TraiteAuto.EResultatMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin  
  EResultat.SelectAll;
end;

procedure TFrm_TraiteAuto.FormCreate(Sender: TObject);
begin
  DoResultat;
end;

end.
