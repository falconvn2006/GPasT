//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT InsMag_frm;

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
  dxmdaset,
  wwDialog,
  wwidlg,
  wwLookupDialogRv,
  StdCtrls,
  Mask,
  RzEdit,
  RzDBEdit,
  RzDBBnEd,
  RzDBButtonEditRv,
  RzLabel,
  Wwdotdot,
  Wwdbcomb,
  wwDBComboBoxRv,
  wwdbedit,
  wwDBEditRv,
  wwcheckbox,
  wwCheckBoxRV,
  DBCtrls;

TYPE
  TFrm_InsMag = CLASS(TAlgolStdFrm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TLMDSpeedButton;
    Nbt_Post: TLMDSpeedButton;
    Lab_: TRzLabel;
    Chp_doss: TRzDBButtonEditRv;
    Lab_code: TRzLabel;
    Lab_nom: TRzLabel;
    Lab_Ville: TRzLabel;
    Lab_type: TRzLabel;
    LK_dos: TwwLookupDialogRV;
    Chp_code: TwwDBEditRv;
    Chp_RS: TwwDBEditRv;
    Chp_Ville: TwwDBEditRv;
    Chp_typ: TwwDBComboBoxRv;
    Lab_reg: TRzLabel;
    LK_reg: TwwLookupDialogRV;
    Chp_reg: TRzDBButtonEditRv;
    DBCheckBox2: TDBCheckBox;
    PROCEDURE Nbt_PostClick(Sender: TObject);
    PROCEDURE Nbt_CancelClick(Sender: TObject);
    PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
      Shift: TShiftState);
    PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    PROCEDURE Pan_BtnEnter(Sender: TObject);
    PROCEDURE Pan_BtnExit(Sender: TObject);
    procedure Chp_dossButtonClick(Sender: TObject);
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

FUNCTION ExecuteInsMag(mag_id: integer): Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
  StdUtils,
  Main_Dm;

FUNCTION ExecuteInsMag(mag_id: integer): Boolean;
VAR
  Frm_InsMag: TFrm_InsMag;
BEGIN
  Result := False;
  Application.createform(TFrm_InsMag, Frm_InsMag);
  WITH Frm_InsMag DO
  BEGIN
    TRY
      magid := mag_id;
      IF magid <> 0 THEN
      BEGIN
        Dm_Main.ds_Tmag.DataSet.locate('mag_id', magid, []);
        Dm_Main.ds_dos.DataSet.locate('dos_id', Dm_Main.ds_Tmag.DataSet.FieldByName('mag_dosid').AsInteger, []);
        Dm_Main.ds_reg.DataSet.locate('reg_id', Dm_Main.ds_Tmag.DataSet.FieldByName('mag_regid').AsInteger, []);
        Dm_Main.ds_Tmag.Edit;
        Chp_doss.ReadOnly:=true;
      END
      ELSE
      BEGIN
        Dm_Main.ds_Tmag.dataset.insert;
        Dm_Main.ds_Tmag.DataSet.fieldbyname('mag_catman').AsInteger := 1;
      END;
      IF Showmodal = mrOk THEN
      BEGIN

        Result := True;
      END;
    FINALLY
      Free;
    END;
  END;
END;

PROCEDURE TFrm_InsMag.AlgolStdFrmCreate(Sender: TObject);
BEGIN
  TRY
    screen.Cursor := crSQLWait;
    Hint := Caption;

  FINALLY
    screen.Cursor := crDefault;
  END;
END;

procedure TFrm_InsMag.Chp_dossButtonClick(Sender: TObject);
begin
  if Not Chp_doss.ReadOnly then
    LK_dos.Execute;
end;

PROCEDURE TFrm_InsMag.AlgolMainFrmKeyDown(Sender: TObject;
  VAR Key: Word; Shift: TShiftState);
BEGIN
  CASE key OF
    VK_ESCAPE: Nbt_CancelClick(Sender);
    VK_F12: Nbt_PostClick(Sender);
    VK_RETURN: IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
  END;
END;

PROCEDURE TFrm_InsMag.Nbt_PostClick(Sender: TObject);
BEGIN
  Dm_Main.ds_Tmag.DataSet.fieldbyname('mag_dosid').AsInteger := Dm_Main.ds_dos.DataSet.fieldbyname('dos_id').AsInteger;
  Dm_Main.ds_Tmag.DataSet.fieldbyname('mag_regid').AsInteger := Dm_Main.ds_reg.DataSet.fieldbyname('reg_id').AsInteger;
  Dm_Main.ds_Tmag.dataset.post;
  ModalResult := mrOk;
END;

PROCEDURE TFrm_InsMag.Nbt_CancelClick(Sender: TObject);
BEGIN
  Dm_Main.ds_Tmag.dataset.cancel;
  ModalResult := mrCancel;
END;

PROCEDURE TFrm_InsMag.Pan_BtnEnter(Sender: TObject);
BEGIN
  Nbt_Post.Font.style := [fsBold];
END;

PROCEDURE TFrm_InsMag.Pan_BtnExit(Sender: TObject);
BEGIN
  Nbt_Post.Font.style := [];
END;

END.

