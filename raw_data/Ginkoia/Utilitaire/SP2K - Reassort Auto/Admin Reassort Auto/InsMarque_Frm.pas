//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT InsMarque_Frm;

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
    LMDFormShadow, StdCtrls, DBCtrls, wwDialog, wwidlg, wwLookupDialogRv,
  wwdbedit, wwDBEditRv, Mask, RzEdit, RzDBEdit, RzDBBnEd, RzDBButtonEditRv,
  RzLabel;

RESOURCESTRING
    RS_TXT_DBLMRK   = 'Cet marque fait déjà partie de la liste des marques en réassort automatique.';

TYPE
    TFrm_InsMarque = CLASS(TForm)
        Pan_Btn: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
    Lab_Marque: TRzLabel;
    Chp_Marque: TRzDBButtonEditRv;
    Lab_LibMrk: TRzLabel;
    Chp_libelle: TwwDBEditRv;
    LK_Mrk: TwwLookupDialogRV;
    Chp_Actif: TDBCheckBox;
    Chp_Stock: TDBCheckBox;
    Chp_Vente: TDBCheckBox;
    Chp_FTP: TwwDBEditRv;
    Lab_RepFTP: TRzLabel;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE Nbt_CancelClick(Sender: TObject);
        PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    procedure Pan_BtnEnter(Sender: TObject);
    procedure Pan_BtnExit(Sender: TObject);
    procedure Chp_MarqueButtonClick(Sender: TObject);
    PRIVATE
        UserCanModify, UserVisuMags: Boolean;
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED

    END;

FUNCTION ExecuteFrm_InsMarque(Id:Integer): Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
    StdUtils,
    Main_Dm;

FUNCTION ExecuteFrm_InsMarque(Id:Integer): Boolean;
VAR Frm_InsMarque: TFrm_InsMarque;
BEGIN
    Result := False;
    Application.createform(TFrm_InsMarque, Frm_InsMarque);
    WITH Frm_InsMarque DO
    BEGIN
        TRY
          IF Id <> 0 THEN
          BEGIN
            Dm_Main.Tbl_Marque.locate('RAM_MRKID', Id, []);
            Dm_Main.Que_MrkSP2000.locate('MRK_ID', Id, []);
            Dm_Main.Tbl_Marque.Edit;
            Chp_Marque.ReadOnly   := true;
          END
          ELSE
          BEGIN
            Dm_Main.Tbl_Marque.insert;
            Dm_Main.Tbl_Marque.FieldByName('RAM_ACTIF').asInteger  := 1;
            Dm_Main.Tbl_Marque.FieldByName('RAM_STK').asInteger    := 1;
            Dm_Main.Tbl_Marque.FieldByName('RAM_VTE').asInteger    := 1;
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

PROCEDURE TFrm_InsMarque.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;

    FINALLY
        screen.Cursor := crDefault;
    END;
END;

procedure TFrm_InsMarque.Chp_MarqueButtonClick(Sender: TObject);
begin
  if Not Chp_Marque.ReadOnly then
    LK_Mrk.Execute;
end;

PROCEDURE TFrm_InsMarque.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: Nbt_CancelClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN : IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_InsMarque.Nbt_PostClick(Sender: TObject);
BEGIN
  //Contrôle que la marque n'est pas déjà dans la liste
  if (Not Chp_Marque.ReadOnly) and Dm_Main.Que_LstMarques.Locate('RAM_MRKID',Dm_Main.Que_MrkSP2000.Fieldbyname('MRK_ID').AsInteger,[]) then
  Begin
    MessageDlg(RS_TXT_DBLMRK,mtInformation,[mbOK],0);
    Exit;
  End;

  //Enregistre l'ajout de la marque
  Dm_Main.Tbl_Marque.FieldByName('RAM_MRKID').AsInteger := Dm_Main.Que_MrkSP2000.Fieldbyname('MRK_ID').AsInteger;
  Dm_Main.Tbl_Marque.post;
  ModalResult := mrOk;
END;

PROCEDURE TFrm_InsMarque.Nbt_CancelClick(Sender: TObject);
BEGIN
  //Annule les modifications
  Dm_Main.Tbl_Marque.Cancel;
  ModalResult := mrCancel;
END;

procedure TFrm_InsMarque.Pan_BtnEnter(Sender: TObject);
begin
     Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_InsMarque.Pan_BtnExit(Sender: TObject);
begin
     Nbt_Post.Font.style := [];
end;

END.

