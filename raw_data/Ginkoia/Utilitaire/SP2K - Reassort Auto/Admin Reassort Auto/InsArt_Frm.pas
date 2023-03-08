//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT InsArt_Frm;

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
    LMDFormShadow, StdCtrls, Mask, wwdbedit, wwDBEditRv, RzLabel;

RESOURCESTRING
    RS_TXT_DBLEAN   = 'Le code EAN que vous avez saisi est déjà utilisé pour un autre article.';

TYPE
    TFrm_InsArt = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
    Lab_LibArt: TRzLabel;
    Chp_libArt: TwwDBEditRv;
    Lab_Ref: TRzLabel;
    Chp_Ref: TwwDBEditRv;
    Chp_Taille: TwwDBEditRv;
    Lab_Taille: TRzLabel;
    Chp_Couleur: TwwDBEditRv;
    Lab_Couleur: TRzLabel;
    Lab_Divers1: TRzLabel;
    Chp_Divers2: TwwDBEditRv;
    Lab_Divers2: TRzLabel;
    Chp_EAN: TwwDBEditRv;
    Lab_EAN: TRzLabel;
    Chp_Divers1: TwwDBEditRv;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE Nbt_CancelClick(Sender: TObject);
        PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    procedure Pan_BtnEnter(Sender: TObject);
    procedure Pan_BtnExit(Sender: TObject);
    PRIVATE
        UserCanModify, UserVisuMags: Boolean;
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED

    END;

FUNCTION ExecuteFrm_InsArt(Id:Integer): Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
    StdUtils, Main_Dm;

FUNCTION ExecuteFrm_InsArt(Id:Integer): Boolean;
VAR Frm_InsArt: TFrm_InsArt;
BEGIN
    Result := False;
    Application.createform(TFrm_InsArt, Frm_InsArt);
    WITH Frm_InsArt DO
    BEGIN
        TRY
          IF Id <> 0 THEN
          BEGIN
            Dm_Main.Tbl_Article.locate('REA_ID', Id, []);
            Dm_Main.Tbl_Article.Edit;
          END
          ELSE
          BEGIN
            Dm_Main.Tbl_Article.insert;
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

PROCEDURE TFrm_InsArt.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_InsArt.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: Nbt_CancelClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN : IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_InsArt.Nbt_PostClick(Sender: TObject);
BEGIN
  //Contrôle que le code EAN n'est pas déjà utilisé
  if Dm_Main.Que_LstArticle.Locate('REA_EAN',Chp_EAN.Text,[]) and
     (Dm_Main.Que_LstArticle.FieldByName('REA_ID').asInteger <> Dm_Main.Tbl_Article.FieldByName('REA_ID').asInteger) then
  Begin
    MessageDlg(RS_TXT_DBLEAN,mtInformation,[mbOK],0);
    Exit;
  End;

  //Enregistre l'ajout de la marque
  Dm_Main.Tbl_Article.FieldByName('REA_MRKID').AsInteger := Dm_Main.Que_LstMrkRea.Fieldbyname('RAM_MRKID').AsInteger;
  Dm_Main.Tbl_Article.post;
  ModalResult := mrOk;
END;

PROCEDURE TFrm_InsArt.Nbt_CancelClick(Sender: TObject);
BEGIN
  //Annule les modifications
  Dm_Main.Tbl_Article.Cancel;
  ModalResult := mrCancel;
END;

procedure TFrm_InsArt.Pan_BtnEnter(Sender: TObject);
begin
     Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_InsArt.Pan_BtnExit(Sender: TObject);
begin
     Nbt_Post.Font.style := [];
end;

END.

