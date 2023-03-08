//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT InitDate_Frm;

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
    LMDFormShadow, StdCtrls, RzLabel, Mask, wwdbedit, wwDBEditRv, ComCtrls;

RESOURCESTRING
  RS_TXT_INITOK  = 'ATTENTION, cette fonction réinitialise tous les magasins actifs à la date choisie.'+#13#10+'Voulez vous poursuivre le traitement ?';
TYPE
    TFrm_InitDate = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
    Chp_Marque: TwwDBEditRv;
    Lab_Marque: TRzLabel;
    DTP_DateActiv: TDateTimePicker;
    Lab_Date: TRzLabel;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE Nbt_CancelClick(Sender: TObject);
        PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    procedure Pan_BtnEnter(Sender: TObject);
    procedure Pan_BtnExit(Sender: TObject);
    PRIVATE
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED

    END;

FUNCTION ExecuteFrm_InitDate: Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
    StdUtils, Main_Dm;

FUNCTION ExecuteFrm_InitDate: Boolean;
VAR Frm_InitDate: TFrm_InitDate;
BEGIN
    Result := False;
    Application.createform(TFrm_InitDate, Frm_InitDate);
    WITH Frm_InitDate DO
    BEGIN
        TRY
            IF Showmodal = mrOk THEN
            BEGIN
                Result := True;
            END;
        FINALLY
            Free;
        END;
    END;
END;

PROCEDURE TFrm_InitDate.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_InitDate.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: Nbt_CancelClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN : IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_InitDate.Nbt_PostClick(Sender: TObject);
BEGIN
    //Message
    if MessageDlg(RS_TXT_INITOK,mtInformation,[mbYes,mbNo],0,mbNo)=mryes then
    Begin
      Dm_Main.Tbl_Magasin.Close;
      Dm_Main.Que_UpdateMrkMag.Close;
      Dm_Main.Que_UpdateMrkMag.Parameters.ParamByName('NewDate').Value  := DTP_DateActiv.DateTime;
      Dm_Main.Que_UpdateMrkMag.Parameters.ParamByName('MRKID').Value    := Dm_Main.Que_LstMarques.FieldByName('RAM_MRKID').asInteger;
      Dm_Main.Que_UpdateMrkMag.ExecSQL;
      Dm_Main.Tbl_Magasin.Open;

      //Ecriture de la table histo
      Dm_Main.Que_LstMagInit.Close;
      Dm_Main.Que_LstMagInit.Parameters.ParamByName('MRKID').Value  := Dm_Main.Que_LstMarques.FieldByName('RAM_MRKID').asInteger;
      Dm_Main.Que_LstMagInit.Open;
      Dm_Main.Que_LstMagInit.First;
      while Not  Dm_Main.Que_LstMagInit.eof do
      Begin
        Dm_Main.Tbl_Histo.Append;
        Dm_Main.Tbl_Histo.FieldByName('REH_MAGID').AsInteger          := Dm_Main.Que_LstMagInit.FieldByName('REM_MAGID').asInteger;
        Dm_Main.Tbl_Histo.FieldByName('REH_MRKID').AsInteger          := Dm_Main.Que_LstMarques.FieldByName('RAM_MRKID').asInteger;
        Dm_Main.Tbl_Histo.FieldByName('REH_DATE').AsDateTime          := DTP_DateActiv.DateTime;
        Dm_Main.Tbl_Histo.FieldByName('REH_OK').AsInteger             := 1;
        Dm_Main.Tbl_Histo.FieldByName('REH_TYP').AsInteger            := 0;
        Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONTCK').AsInteger    := 0;
        Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONNEGBL').AsInteger  := 0;
        Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONNEGFCT').AsInteger := 0;
        Dm_Main.Tbl_Histo.FieldByName('REH_INSERTED').AsDatetime      := Now;
        Dm_Main.Tbl_Histo.Post;
      End;
    End;
    ModalResult := mrOk;
END;

PROCEDURE TFrm_InitDate.Nbt_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrCancel;
END;

procedure TFrm_InitDate.Pan_BtnEnter(Sender: TObject);
begin
     Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_InitDate.Pan_BtnExit(Sender: TObject);
begin
     Nbt_Post.Font.style := [];
end;

END.

