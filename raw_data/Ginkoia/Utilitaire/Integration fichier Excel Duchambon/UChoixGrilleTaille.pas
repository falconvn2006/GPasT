UNIT UChoixGrilleTaille;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, IBODataset, StdCtrls, RzLabel, RzDBLbl, RzDBLabelRv, ExtCtrls,
  RzPanel, RzPanelRv, dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP,
  LMDCustomButton, LMDButton, UMain, dxDBTLCl, dxGrClms, Boxes, PanBtnDbgHP,
  LMDControl, LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, ActionRv, ComCtrls;

TYPE
  TFrm_GTF = CLASS(TForm)
    Que_GrilleTailles: TIBOQuery;
    Que_NKL: TIBOQuery;
    Ds_GrilleTailles: TDataSource;
    Ds_NKL: TDataSource;
    Pan_Down: TRzPanelRv;
    Nbt_Cancel: TLMDButton;
    Nbt_OK: TLMDButton;
    Pan_Up: TRzPanelRv;
    Pan_Client: TRzPanelRv;
    Pan_DBG: TRzPanelRv;
    Pan_Selection: TRzPanelRv;
    Chp_Nomenk: TRzDBLabelRv;
    Chp_Sec: TRzDBLabelRv;
    Lab_Titre: TRzLabel;
    Que_GrilleTaillesTGTNOM: TStringField;
    Que_GrilleTaillesGTFID: TIntegerField;
    Que_GrilleTaillesGTFNOM: TStringField;
    Que_GrilleTaillesGTFTAILLES: TMemoField;
    Lab_Secteur: TRzLabel;
    Nbt_Expand: TLMDSpeedButton;
    Nbt_Collapse: TLMDSpeedButton;
    Que_NKLSEC_NOM: TStringField;
    Que_NKLNOMENK: TStringField;
    Lab_Nomenk: TRzLabel;
    Lab_Article: TRzLabel;
    Chp_Article: TRzLabel;
    Que_NKLSecteur: TStringField;
    Lab_Genre: TRzLabel;
    Chp_Genre: TRzDBLabelRv;
    Que_Genre: TIBOQuery;
    Ds_Genre: TDataSource;
    Grd_Close: TGroupDataRv;
    Que_ModeleTailles: TIBOQuery;
    Ds_ModeleTailles: TDataSource;
    Pgc_Tailles: TPageControl;
    Tab_GTF: TTabSheet;
    Tab_MTT: TTabSheet;
    DBG_GTF: TdxDBGridHP;
    DBG_GTFTGTNOM: TdxDBGridMaskColumn;
    DBG_GTFGTFNOM: TdxDBGridMaskColumn;
    DBG_GTFGTFTAILLES: TdxDBGridMemoColumn;
    DBG_GTFGTFID: TdxDBGridMaskColumn;
    DBG_MTT: TdxDBGridHP;
    dxDBGridMaskColumn1: TdxDBGridMaskColumn;
    dxDBGridMaskColumn2: TdxDBGridMaskColumn;
    dxDBGridMemoColumn1: TdxDBGridMemoColumn;
    dxDBGridMaskColumn3: TdxDBGridMaskColumn;
    Que_ModeleTaillesTGTNOM: TStringField;
    Que_ModeleTaillesGTFID: TIntegerField;
    Que_ModeleTaillesGTFNOM: TStringField;
    Que_ModeleTaillesGTFTAILLES: TMemoField;
    LMDSpeedButton1: TLMDSpeedButton;
    LMDSpeedButton2: TLMDSpeedButton;
    PROCEDURE Nbt_OKClick(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE refresh();
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_ExpandClick(Sender: TObject);
    procedure Nbt_CollapseClick(Sender: TObject);
    procedure Que_NKLCalcFields(DataSet: TDataSet);
    procedure DBG_GTFKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBG_GTFDblClick(Sender: TObject);
    procedure LMDSpeedButton2Click(Sender: TObject);
    procedure LMDSpeedButton1Click(Sender: TObject);
  PRIVATE
    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
    iGTFID, iGTFType, iSSFID, iGREID: integer;
    sGTFNOM, sARTNOM : String;
  END;

FUNCTION ChoixGTF(ASSFID, AGREID: Integer; AArtNOM: string): tTaille;

VAR
  Frm_GTF: TFrm_GTF;

IMPLEMENTATION

USES UCommon;

{$R *.DFM}

FUNCTION ChoixGTF(ASSFID, AGreId: Integer; AArtNOM: string): tTaille;
BEGIN
  Result.iID := 0;
  Result.iType := 0;

  Frm_GTF := TFrm_GTF.Create(Application);
  TRY
    WITH Frm_GTF DO
    BEGIN
      iSSFID := ASSFID;
      sARTNOM := AArtNom;
      iGREID := AGREID;

      Refresh();
      IF ShowModal = MrOK THEN
      BEGIN
        IF iGTFType = 1 THEN
          LogAction('  -> Grille de tailles choisie : ' + sGTFNOM)
        ELSE
          LogAction('  -> Modèle de tailles choisi : ' + sGTFNOM);
          
        Result.iID := iGTFID;
        Result.iType := iGTFType;
      END;
    END;
  FINALLY
    Frm_GTF.Release;
  END;
END;


PROCEDURE TFrm_GTF.Nbt_OKClick(Sender: TObject);
BEGIN
  iGTFType := Pgc_Tailles.ActivePageIndex;

  case iGTFType of
   0 : begin
     CASE (DBG_GTF.FocusedNode.Level) OF
       1: BEGIN
         iGTFID := Que_GrilleTaillesGTFID.AsInteger;
         sGTFNOM := Que_GrilleTaillesGTFNOM.AsString;
         ModalResult := mrOk;
       END;
       ELSE BEGIN
         Showmessage('Vous devez choisir une grille de tailles');
       END;
     END;
   end;
   1 : begin
     CASE (DBG_MTT.FocusedNode.Level) OF
       1: BEGIN
         iGTFID := Que_ModeleTaillesGTFID.AsInteger;
         sGTFNOM := Que_ModeleTaillesGTFNOM.AsString;
         ModalResult := mrOk;
       END;
       ELSE BEGIN
         Showmessage('Vous devez choisir un modèle de tailles');
       END;
     END;
   end;
   ELSE begin
     Showmessage('Vous devez choisir un modèle de tailles');
   end;
 end;
END;

PROCEDURE TFrm_GTF.FormCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
BEGIN
  Grd_Close.Close;
END;

procedure TFrm_GTF.LMDSpeedButton1Click(Sender: TObject);
begin
  Pgc_Tailles.ActivePageIndex := 1;
end;

procedure TFrm_GTF.LMDSpeedButton2Click(Sender: TObject);
begin
  Pgc_Tailles.ActivePageIndex := 0;
end;

PROCEDURE TFrm_GTF.refresh;
BEGIN
  // Par défaut : les modèles
  Pgc_Tailles.ActivePageIndex := 1;
//  Pgc_Tailles.ActivePage.TabVisible := True;

  Que_NKL.ParamByName('SSFID').AsInteger := iSSFID;
  Que_NKL.Open;
  Que_NKL.First;

  Chp_Article.Caption := sARTNOM;

  Que_Genre.ParamByName('GREID').AsInteger := iGREID;
  Que_Genre.Open;
  Que_Genre.First;

  Que_GrilleTailles.Open;
  Que_ModeleTailles.Open;

  DBG_GTF.FullCollapse();
END;

procedure TFrm_GTF.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_GTF.Nbt_ExpandClick(Sender: TObject);
begin
  DBG_GTF.FullExpand;
  DBG_MTT.FullExpand;
end;

procedure TFrm_GTF.Nbt_CollapseClick(Sender: TObject);
begin
  DBG_GTF.FullCollapse;
  DBG_MTT.FullCollapse;
end;

procedure TFrm_GTF.Que_NKLCalcFields(DataSet: TDataSet);
begin

 IF Trim(Que_NKLSEC_NOM.AsString) = '' THEN
        Que_NKLSecteur.AsString := '{ Secteur non défini... }'
    ELSE
        Que_NKLSecteur.AsString := Que_NKLSEC_NOM.asstring;

end;

procedure TFrm_GTF.DBG_GTFKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CASE Key OF
    VK_ESCAPE:
      BEGIN
        Nbt_Cancel.Click();
      END;
    VK_RETURN:
      BEGIN
        Nbt_OK.Click();
      END;
  END;

end;

procedure TFrm_GTF.DBG_GTFDblClick(Sender: TObject);
begin
  Nbt_OK.Click();
end;

END.

