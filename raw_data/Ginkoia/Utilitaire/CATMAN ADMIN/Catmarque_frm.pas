//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Catmarque_frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  AlgolStdFrm,
  LMDControl,
  LMDBaseControl,
  LMDBaseGraphicButton,
  LMDCustomSpeedButton,
  LMDSpeedButton,
  ExtCtrls,
  RzPanel,
  fcStatusBar,
  RzBorder,
  LMDCustomComponent,
  LMDWndProcComponent,
  LMDFormShadow,
  DB,
  ADODB,
  dxDBTLCl,
  dxGrClms,
  dxTL,
  dxDBCtrl,
  dxDBGrid,
  dxCntner,
  dxDBGridHP,
  Boxes,
  PanBtnDbgHP,
  dxmdaset;

TYPE
  TFrm_CatMarque = CLASS(TAlgolStdFrm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TLMDSpeedButton;
    Nbt_Post: TLMDSpeedButton;
    DBG: TdxDBGridHP;
    DS_param: TDataSource;
    Qparam: TADOQuery;
    Qparammpc_id: TAutoIncField;
    Qparammpc_actif: TWordField;
    Qparamcat_nom: TStringField;
    Qparammrk_nom: TStringField;
    Pan_Mag: TPanelDbg;
    MemD_: TdxMemData;
    MemD_mpc_id: TIntegerField;
    MemD_cat_nom: TStringField;
    MemD_mrk_nom: TStringField;
    DBGmpc_id: TdxDBGridMaskColumn;
    DBGcat_nom: TdxDBGridMaskColumn;
    DBGmrk_nom: TdxDBGridMaskColumn;
    DBGmpc_actif: TdxDBGridCheckColumn;
    MemD_mpc_actif: TWordField;
    Qmaj: TADOQuery;
    Qparamold: TWordField;
    MemD_old: TWordField;
    MemD_Achat: TFloatField;
    MemD_Marge: TStringField;
    achat: TdxDBGridMaskColumn;
    marge: TdxDBGridMaskColumn;
    MemD_mrk_id: TIntegerField;
    MemD_cat_id: TIntegerField;
    Qindic: TADOQuery;
    Qindicind_achat: TFloatField;
    Qindicind_marge: TFloatField;
    Qparammrk_id: TAutoIncField;
    Qparamcat_id: TAutoIncField;
    MemD_oldachat: TFloatField;
    MemD_oldmarge: TFloatField;
    QmajIndic: TADOQuery;
    PROCEDURE Nbt_PostClick(Sender: TObject);
    PROCEDURE Nbt_CancelClick(Sender: TObject);
    PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
      Shift: TShiftState);
    PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    PROCEDURE Pan_BtnEnter(Sender: TObject);
    PROCEDURE Pan_BtnExit(Sender: TObject);
    PROCEDURE QparamBeforePost(DataSet: TDataSet);
  PRIVATE
    UserCanModify, UserVisuMags: Boolean;
    magid, colid: integer;
    { Private declarations }
  PROTECTED
    { Protected declarations }
  PUBLIC
    { Public declarations }
  PUBLISHED

  END;

FUNCTION ExecuteCatmarque(mag_id: integer; col_id: integer): Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
  StdUtils,
  GinkoiaStd,
  GinkoiaResStr,
  Catmarque_dm;

FUNCTION ExecuteCatmarque(mag_id: integer; col_id: integer): Boolean;
VAR
  Frm_Catmarque: TFrm_Catmarque;
BEGIN
  Result := False;
  Application.createform(TFrm_Catmarque, Frm_Catmarque);
  WITH Frm_Catmarque DO
  BEGIN
    TRY
      colid := col_id;
      magid := mag_id;
      qparam.close;
      qparam.parameters[0].value := magid;
      qparam.parameters[1].value := colid;
      qparam.open;
      memd_.LoadFromDataSet(qparam);

      //Chargement des indicateurs magasins
      memd_.first;
      WHILE NOT memd_.eof DO
      BEGIN
        qindic.close;
        qindic.Parameters[0].Value := colid;
        qindic.Parameters[1].Value := MemD_cat_id.asinteger;
        qindic.Parameters[2].Value := MemD_mrk_id.asinteger;
        qindic.Parameters[3].Value := magid;
        qindic.Open;
        memd_.edit;
        MemD_Achat.asfloat := Qindicind_achat.asfloat;
        MemD_Marge.asfloat := Qindicind_marge.asfloat;
        MemD_oldAchat.asfloat := Qindicind_achat.asfloat;
        MemD_oldMarge.asfloat := Qindicind_marge.asfloat;
        memd_.Post;
        memd_.next;
      END;

      memd_.first;
      dbg.FullExpand;
      IF Showmodal = mrOk THEN
      BEGIN
        Result := True;
      END;
    FINALLY
      Free;
    END;
  END;
END;

PROCEDURE TFrm_CatMarque.AlgolStdFrmCreate(Sender: TObject);
BEGIN
  TRY
    screen.Cursor := crSQLWait;
    Hint := Caption;

  FINALLY
    screen.Cursor := crDefault;
  END;
END;

PROCEDURE TFrm_CatMarque.AlgolMainFrmKeyDown(Sender: TObject;
  VAR Key: Word; Shift: TShiftState);
BEGIN
  CASE key OF
    VK_ESCAPE: Nbt_CancelClick(Sender);
    VK_F12: Nbt_PostClick(Sender);
    VK_RETURN: IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
  END;
END;

PROCEDURE TFrm_CatMarque.Nbt_PostClick(Sender: TObject);
BEGIN
  memd_.first;
  WHILE NOT memd_.eof DO
  BEGIN
    //Maj actif o/N
    IF MemD_mpc_actif.asinteger <> MemD_old.asinteger THEN
    BEGIN
      qmaj.Parameters[0].Value := MemD_mpc_actif.asinteger;
      qmaj.Parameters[1].Value := MemD_mpc_id.asinteger;
      qmaj.ExecSQL;
    END;

    //Maj des indicateurs
    IF (MemD_Achat.asfloat <> MemD_oldAchat.asfloat) OR (MemD_marge.asfloat <> MemD_oldmarge.asfloat) THEN
    BEGIN
      qmajindic.close;
      qmajindic.Parameters[0].Value := MemD_achat.asfloat;
      qmajindic.Parameters[1].Value := MemD_Marge.asfloat;
      qmajindic.Parameters[2].Value := colid;
      qmajindic.Parameters[3].Value := MemD_cat_id.asinteger;
      qmajindic.Parameters[4].Value := MemD_mrk_id.asinteger;
      qmajindic.Parameters[5].Value := magid;
      qmajindic.ExecSQL;
    END;
    memd_.Next;
  END;

  ModalResult := mrOk;
END;

PROCEDURE TFrm_CatMarque.Nbt_CancelClick(Sender: TObject);
BEGIN
  ModalResult := mrCancel;
END;

PROCEDURE TFrm_CatMarque.Pan_BtnEnter(Sender: TObject);
BEGIN
  Nbt_Post.Font.style := [fsBold];
END;

PROCEDURE TFrm_CatMarque.Pan_BtnExit(Sender: TObject);
BEGIN
  Nbt_Post.Font.style := [];
END;

PROCEDURE TFrm_CatMarque.QparamBeforePost(DataSet: TDataSet);
BEGIN
  abort;
END;

END.

