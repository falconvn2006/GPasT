UNIT UNomenk;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, DB,
  IBODataset, RzDBLbl, RzDBLabelRv, dxTL, dxDBCtrl, dxDBGrid, dxCntner,
  dxDBGridHP, StdCtrls, RzLabel, LMDCustomButton, LMDButton, LMDControl,
  LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton,
  ExtCtrls, RzPanel, RzPanelRv;

TYPE
  TFrm_Nomenk = CLASS(TForm)
    Que_NKL: TIBOQuery;
    Ds_NKL: TDataSource;
    Pan_Bottom: TRzPanelRv;
    Pan_Top: TRzPanelRv;
    Pan_Client: TRzPanelRv;
    DBG_NKL: TdxDBGridHP;
    Lab_Titre: TRzLabel;
    Que_NKLRAY_ID: TIntegerField;
    Que_NKLRAY_NOM: TStringField;
    Que_NKLFAM_ID: TIntegerField;
    Que_NKLFAM_NOM: TStringField;
    Que_NKLSSF_ID: TIntegerField;
    Que_NKLSSF_NOM: TStringField;
    Que_NKLRAY_ORDREAFF: TIBOFloatField;
    Que_NKLFAM_ORDREAFF: TIBOFloatField;
    Que_NKLSSF_ORDREAFF: TIBOFloatField;
    DBG_NKLRAY_ID: TdxDBGridMaskColumn;
    DBG_NKLRAY_NOM: TdxDBGridMaskColumn;
    DBG_NKLFAM_ID: TdxDBGridMaskColumn;
    DBG_NKLFAM_NOM: TdxDBGridMaskColumn;
    DBG_NKLSSF_ID: TdxDBGridMaskColumn;
    DBG_NKLSSF_NOM: TdxDBGridMaskColumn;
    DBG_NKLRAY_ORDREAFF: TdxDBGridMaskColumn;
    DBG_NKLFAM_ORDREAFF: TdxDBGridMaskColumn;
    DBG_NKLSSF_ORDREAFF: TdxDBGridMaskColumn;
    Pan_Selection: TRzPanelRv;
    Nbt_OK: TLMDButton;
    Nbt_Cancel: TLMDButton;
    Chp_Sec: TRzDBLabelRv;
    Que_NKLSEC_ID: TIntegerField;
    Que_NKLSEC_NOM: TStringField;
    DBG_NKLSEC_ID: TdxDBGridMaskColumn;
    DBG_NKLSEC_NOM: TdxDBGridMaskColumn;
    RzPanelRv1: TRzPanelRv;
    Que_NKLNOMENK: TStringField;
    Lab_Secteur: TRzLabel;
    Chp_Nomenk: TRzDBLabelRv;
    Lab_Nomenk: TRzLabel;
    Lab_NotFound: TRzLabel;
    Chp_NotFound: TRzLabel;
    Nbt_Expand: TLMDSpeedButton;
    Nbt_Collapse: TLMDSpeedButton;
    Lab_Article: TRzLabel;
    Chp_Article: TRzLabel;
    Que_NKLSecteur: TStringField;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE DBG_NKLChangeNode(Sender: TObject; OldNode,
      Node: TdxTreeListNode);
    PROCEDURE Nbt_OKClick(Sender: TObject);
    PROCEDURE Nbt_CancelClick(Sender: TObject);
    PROCEDURE Nbt_ExpandClick(Sender: TObject);
    PROCEDURE Nbt_CollapseClick(Sender: TObject);
    PROCEDURE Que_NKLCalcFields(DataSet: TDataSet);
    PROCEDURE DBG_NKLKeyDown(Sender: TObject; VAR Key: Word;
      Shift: TShiftState);
    procedure DBG_NKLDblClick(Sender: TObject);
  PRIVATE
    { Déclarations privées }
  PUBLIC
    iRAYID, iFAMID, iSSFID: integer;
    sRAYNOM, sFAMNOM, sSSFNOM: STRING;
    { Déclarations publiques }
  END;

FUNCTION ChoixNomenk(VAR RAY_ID, FAM_ID, SSF_ID: integer; VAR RAY_NOM, FAM_NOM, SSF_NOM: STRING; OldNomenk, ArtName: STRING; SEC_ID: integer): boolean;

VAR
  Frm_Nomenk: TFrm_Nomenk;
  iSEC_ID: integer;

IMPLEMENTATION

{$R *.DFM}


FUNCTION ChoixNomenk(VAR RAY_ID, FAM_ID, SSF_ID: integer; VAR RAY_NOM, FAM_NOM, SSF_NOM: STRING; OldNomenk, ArtName: STRING; SEC_ID: integer): boolean;
BEGIN
  Result := false;
  iSEC_ID := SEC_ID;
  Frm_Nomenk := TFrm_Nomenk.Create(Application);
  TRY
    WITH Frm_Nomenk DO
    BEGIN
      Chp_Article.Caption := ArtName;
      Chp_NotFound.Caption := OldNomenk;
      IF ShowModal = MrOK THEN
      BEGIN
        Result := True;
        RAY_ID := iRAYID;
        FAM_ID := iFAMID;
        SSF_ID := iSSFID;
        RAY_NOM := sRAYNOM;
        FAM_NOM := sFAMNOM;
        SSF_NOM := sSSFNOM;
      END;
    END;
  FINALLY
    Frm_Nomenk.Release;
  END;
END;

PROCEDURE TFrm_Nomenk.FormCreate(Sender: TObject);
BEGIN
  Que_NKL.Close;
  Que_NKL.ParamByName('SECID').AsInteger := iSEC_ID;
  Que_NKL.Open;
  Que_NKL.First;
  DBG_NKL.FullCollapse;
END;

PROCEDURE TFrm_Nomenk.FormCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
BEGIN
  Que_NKL.Close;
END;

PROCEDURE TFrm_Nomenk.DBG_NKLChangeNode(Sender: TObject; OldNode,
  Node: TdxTreeListNode);
BEGIN
  Chp_Sec.Visible := True;
  Lab_Nomenk.Visible := Node.Level > 0;
  Chp_Nomenk.Visible := Node.Level > 0;
END;

PROCEDURE TFrm_Nomenk.Nbt_OKClick(Sender: TObject);
BEGIN
  CASE (DBG_NKL.FocusedNode.Level) OF
    2: BEGIN
        iRAYID := que_NKLRAY_ID.asInteger;
        sRAYNOM := que_NKLRAY_NOM.asString;
        iFAMID := que_NKLFAM_ID.asInteger;
        sFAMNOM := que_NKLFAM_NOM.asString;
        iSSFID := que_NKLSSF_ID.asInteger;
        sSSFNOM := que_NKLSSF_NOM.asString;
        ModalResult := mrOk;
      END;
  ELSE BEGIN
      Showmessage('Vous devez choisir une sous-famille.');
    END;
  END;
END;

PROCEDURE TFrm_Nomenk.Nbt_CancelClick(Sender: TObject);
BEGIN
  ModalResult := mrCancel;
END;

PROCEDURE TFrm_Nomenk.Nbt_ExpandClick(Sender: TObject);
BEGIN
  DBG_NKL.FullExpand;
END;

PROCEDURE TFrm_Nomenk.Nbt_CollapseClick(Sender: TObject);
BEGIN
  DBG_NKL.FullCollapse;
END;

PROCEDURE TFrm_Nomenk.Que_NKLCalcFields(DataSet: TDataSet);
BEGIN

  IF Trim(Que_NKLSEC_NOM.AsString) = '' THEN
    Que_NKLSecteur.AsString := '{ Secteur non défini... }'
  ELSE
    Que_NKLSecteur.AsString := Que_NKLSEC_NOM.asstring;

END;

PROCEDURE TFrm_Nomenk.DBG_NKLKeyDown(Sender: TObject; VAR Key: Word;
  Shift: TShiftState);
BEGIN
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
END;

procedure TFrm_Nomenk.DBG_NKLDblClick(Sender: TObject);
begin
  Nbt_OK.Click();
end;

END.

