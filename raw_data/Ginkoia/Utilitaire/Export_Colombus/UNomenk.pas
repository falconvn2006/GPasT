UNIT UNomenk;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP, Db, IBDataset, ExtCtrls,
  RzPanel, RzPanelRv, StdCtrls, RzLabel, UMain, RzDBLbl, RzDBLabelRv,
  LMDCustomButton, LMDButton;

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
    Chp_Ray: TRzDBLabelRv;
    Chp_Fam: TRzDBLabelRv;
    Chp_SF: TRzDBLabelRv;
    Nbt_OK: TLMDButton;
    Nbt_Cancel: TLMDButton;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE DBG_NKLChangeNode(Sender: TObject; OldNode,
      Node: TdxTreeListNode);
    PROCEDURE Nbt_OKClick(Sender: TObject);
    PROCEDURE Nbt_CancelClick(Sender: TObject);
  PRIVATE
    { Déclarations privées }
  PUBLIC
    iRAYID, iFAMID, iSSFID: integer;
    sRAYNOM, sFAMNOM, sSSFNOM: STRING;
    { Déclarations publiques }
  END;

FUNCTION ChoixNomenk(VAR RAY_ID, FAM_ID, SSF_ID: integer; VAR RAY_NOM, FAM_NOM, SSF_NOM: STRING): boolean;

VAR
  Frm_Nomenk: TFrm_Nomenk;


IMPLEMENTATION

{$R *.DFM}

FUNCTION ChoixNomenk(VAR RAY_ID, FAM_ID, SSF_ID: integer; VAR RAY_NOM, FAM_NOM, SSF_NOM: STRING): boolean;
BEGIN
  Result := false;
  Frm_Nomenk := TFrm_Nomenk.Create(Application);
  TRY
    WITH Frm_Nomenk DO
    BEGIN
      IF Frm_Nomenk.ShowModal = MrOK THEN
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
  Que_NKL.Open;
END;

PROCEDURE TFrm_Nomenk.FormCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
BEGIN
  Que_NKL.Free;
END;

PROCEDURE TFrm_Nomenk.DBG_NKLChangeNode(Sender: TObject; OldNode,
  Node: TdxTreeListNode);
BEGIN
  Chp_Ray.Visible := true;
  Chp_Fam.Visible := Node.Level > 0;
  Chp_SF.Visible := Node.Level > 1;
END;

PROCEDURE TFrm_Nomenk.Nbt_OKClick(Sender: TObject);
BEGIN
  CASE (DBG_NKL.FocusedNode.Level) OF
    0: BEGIN
        iRAYID := que_NKLRAY_ID.asInteger;
        sRAYNOM := que_NKLRAY_NOM.asString;
        iFAMID := 0;
        sFAMNOM := '';
        iSSFID := 0;
        sSSFNOM := '';
      END;
    1: BEGIN
        iRAYID := que_NKLRAY_ID.asInteger;
        sRAYNOM := que_NKLRAY_NOM.asString;
        iFAMID := que_NKLFAM_ID.asInteger;
        sFAMNOM := que_NKLFAM_NOM.asString;
        iSSFID := 0;
        sSSFNOM := '';
      END;
    2: BEGIN
        iRAYID := que_NKLRAY_ID.asInteger;
        sRAYNOM := que_NKLRAY_NOM.asString;
        iFAMID := que_NKLFAM_ID.asInteger;
        sFAMNOM := que_NKLFAM_NOM.asString;
        iSSFID := que_NKLSSF_ID.asInteger;
        sSSFNOM := que_NKLSSF_NOM.asString;
      END;
  END;
  ModalResult := mrOk;
END;

PROCEDURE TFrm_Nomenk.Nbt_CancelClick(Sender: TObject);
BEGIN
  ModalResult := mrCancel;
END;

END.

