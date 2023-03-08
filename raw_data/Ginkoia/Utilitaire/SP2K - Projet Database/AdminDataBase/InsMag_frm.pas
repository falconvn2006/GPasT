// ------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
// ------------------------------------------------------------------------------

UNIT InsMag_frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  // uses perso
  GinkoiaStyle_Dm,
  AlgolDialogForms,
  Main_Dm,
  DB,
  // fin uses perso
  Controls,
  Forms,
  Dialogs, wwDialog, wwidlg, wwLookupDialogRv, AdvEdit, DBAdvEd, ComCtrls,
  AdvDateTimePicker, GinAdvDBDateTimePickers, StdCtrls, DBCtrls, Mask, RzEdit,
  RzDBEdit, RzDBBnEd, RzDBButtonEditRv, AdvGlowButton, ExtCtrls, RzPanel,
  RzLabel, AdvCombo, AdvDBComboBox, GestionEMail,IniCfg_Frm;

TYPE
  TFrm_InsMag = CLASS(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Lab_: TRzLabel;
    Chp_doss: TRzDBButtonEditRv;
    Lab_code: TRzLabel;
    Lab_nom: TRzLabel;
    Lab_Ville: TRzLabel;
    Lab_type: TRzLabel;
    LK_dos: TwwLookupDialogRV;
    Lab_reg: TRzLabel;
    LK_reg: TwwLookupDialogRV;
    Chp_reg: TRzDBButtonEditRv;
    Chp_Database: TDBCheckBox;
    Chp_DtbDateActivation: TGinAdvDBDateTimePicker;
    Chp_code: TDBAdvEdit;
    Chp_RS: TDBAdvEdit;
    Chp_Ville: TDBAdvEdit;
    Nbt_Post: TAdvGlowButton;
    Nbt_Cancel: TRzLabel;
    Lab_Activation: TRzLabel;
    Lab_Ou: TRzLabel;
    Chp_typ: TAdvDBComboBox;
    Chp_ExtractionClient: TDBCheckBox;
    PROCEDURE Nbt_PostClick(Sender: TObject);
    PROCEDURE Nbt_CancelClick(Sender: TObject);
    PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
      Shift: TShiftState);
    PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    PROCEDURE Pan_BtnEnter(Sender: TObject);
    PROCEDURE Pan_BtnExit(Sender: TObject);
    procedure Chp_dossButtonClick(Sender: TObject);
    procedure Chp_DatabaseClick(Sender: TObject);
  PRIVATE
    UserCanModify, UserVisuMags: Boolean;
    magid, colid: integer;
    InsertMode : Boolean;
    { Private declarations }
  PROTECTED
    { Protected declarations }
  PUBLIC
    { Public declarations }
  PUBLISHED

  END;

FUNCTION ExecuteInsMag(mag_id: integer): integer;

IMPLEMENTATION

{$R *.DFM}

USES
  StdUtils;

FUNCTION ExecuteInsMag(mag_id: integer): integer;
VAR
  Frm_InsMag: TFrm_InsMag;
  sMailtext : String;
BEGIN
  Result := -1;
  Application.createform(TFrm_InsMag, Frm_InsMag);
  WITH Frm_InsMag DO
  BEGIN
    TRY
      magid := mag_id;
      if Dm_Main.Ds_TMag.DataSet.Active then
      begin
        Dm_Main.Ds_TMag.DataSet.Close;
        Dm_Main.Ds_TMag.DataSet.Open;
      end;
      IF magid <> 0 THEN
      BEGIN
        Dm_Main.ds_Tmag.DataSet.locate('mag_id', magid, []);
        Dm_Main.ds_dos.DataSet.locate('dos_id',
          Dm_Main.ds_Tmag.DataSet.FieldByName('mag_dosid').AsInteger, []);
        Dm_Main.ds_reg.DataSet.locate('reg_id',
          Dm_Main.ds_Tmag.DataSet.FieldByName('mag_regid').AsInteger, []);
        Dm_Main.ds_Tmag.Edit;
        Chp_doss.ReadOnly := true;
      END
      ELSE
      BEGIN
        Dm_Main.ds_Tmag.DataSet.insert;
        Dm_Main.ds_Tmag.DataSet.FieldByName('mag_catman').AsInteger := 1;
        Dm_Main.Ds_TMag.DataSet.FieldByName('mag_tymid').AsInteger := 1;
      END;
      IF Showmodal = mrOk THEN
      BEGIN
        Result := Dm_Main.ds_Tmag.DataSet.FieldByName('mag_id').AsInteger;

        if InsertMode and IniCfg.SendMail then
        begin
          // Génération du mail
          sMailText := Format('Dossier : %s'#13#10'Code Magasin : %s'#13#10'Raison sociale : %s'#13#10'Ville : %s',[chp_doss.Text,chp_code.Text,chp_RS.Text,chp_ville.Text]);
          // envoi du mail
          SendMail('pod51015.outlook.com',587,'dev@ginkoia.fr','Toru682674',tsm_TLS,'dev@ginkoia.fr','admin@ginkoia.fr','AdminDatabase création de dossier',sMailText,'');
        end;
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

    Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
    Chp_DtbDateActivation.Enabled := False; // 16/12/2011 : rendu inactif tout le temps

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

procedure TFrm_InsMag.Chp_DatabaseClick(Sender: TObject);
begin
  if Dm_Main.ds_Tmag.DataSet.State in [dsEdit, dsInsert] then
  begin
    if Chp_Database.Checked then
    begin
      if Dm_Main.ds_Tmag.DataSet.FieldByName('mag_dtbdateactivation')
        .AsDateTime = 0 then
      begin
        // On init au 1er juin 2011 sur demande client. Mais dateinit est paramétrable dans l'ini si besoin de le changer
        Dm_Main.ds_Tmag.DataSet.FieldByName('mag_dtbdateactivation').AsDateTime := Dm_Main.dtDateInit;
        //Chp_DtbDateActivation.Date := Dm_Main.dtDateInit;
        //Chp_DtbDateActivation.MinDate := Dm_Main.dtDateInit;
//        Chp_DtbDateActivation.Enabled := False; // 16/12/2011 : rendu inactif tout le temps
      end;
    end;
  end;

end;

PROCEDURE TFrm_InsMag.AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
  Shift: TShiftState);
BEGIN
  CASE Key OF
    VK_ESCAPE:
      Nbt_CancelClick(Sender);
    VK_F12:
      Nbt_PostClick(Sender);
    VK_RETURN:
      IF Pan_Btn.Focused THEN
        Nbt_PostClick(Sender);
  END;
END;

PROCEDURE TFrm_InsMag.Nbt_PostClick(Sender: TObject);
BEGIN
  InsertMode := (Dm_Main.ds_Tmag.State in [dsInsert]);

  Dm_Main.ds_Tmag.DataSet.FieldByName('mag_dosid').AsInteger :=
    Dm_Main.ds_dos.DataSet.FieldByName('dos_id').AsInteger;
  Dm_Main.ds_Tmag.DataSet.FieldByName('mag_regid').AsInteger :=
    Dm_Main.ds_reg.DataSet.FieldByName('reg_id').AsInteger;
  Dm_Main.ds_Tmag.DataSet.post;
  ModalResult := mrOk;
END;

PROCEDURE TFrm_InsMag.Nbt_CancelClick(Sender: TObject);
BEGIN
  Chp_DtbDateActivation.MinDate := -1;
  Dm_Main.ds_Tmag.DataSet.cancel;
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
