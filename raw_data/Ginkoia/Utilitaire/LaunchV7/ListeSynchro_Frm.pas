//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ListeSynchro_Frm;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    AlgolStdFrm,
    Dialogs,
    Db,
    IBCustomDataSet, IBQuery, Grids, DBGrids, ExtCtrls,
    LMDControl, LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
    LMDSpeedButton, RzPanel;
    
TYPE
    TFrm_BoiteDeDialogue = CLASS(TAlgolStdFrm)
    Pan_Btn: TRzPanel;
    Nbt_Post: TLMDSpeedButton;
    Pan_Synchro: TPanel;
    Custom_Synchro: TDBGrid;
    IBQue_Synchro: TIBQuery;
    Ds_Synchro: TDataSource;
    IBQue_SynchroBAS_NOM: TIBStringField;
    IBQue_SynchroPRM_STRING: TIBStringField;
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

FUNCTION ExecuteListeSynchro() :Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
    StdUtils,
    LaunchV7_Dm;
    
FUNCTION ExecuteListeSynchro(): Boolean;
VAR Frm_BoiteDeDialogue: TFrm_BoiteDeDialogue;
BEGIN
    Result := False;
    Application.createform(TFrm_BoiteDeDialogue, Frm_BoiteDeDialogue);
    WITH Frm_BoiteDeDialogue DO
    BEGIN
        TRY
           IBQue_Synchro.Close;
           IBQue_Synchro.Open;
           //tester le nombre de réponses :
           //si aucune ne pas afficher un tableau vide mais seulement un message
           IF IBQue_Synchro.recordCount=0 then
           begin
                custom_synchro.visible := false;
                Pan_Synchro.caption := 'Pas de bases associées';
           END;
            IF Showmodal = mrOk THEN
            BEGIN
                Result := True;
            END;
        FINALLY
           IBQue_Synchro.Close;
            Free;
        END;
    END;
END;

PROCEDURE TFrm_BoiteDeDialogue.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
        Dm_LaunchV7.AffecteHintEtBmp(self);
    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_BoiteDeDialogue.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: Nbt_PostClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN : IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_BoiteDeDialogue.Nbt_PostClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_BoiteDeDialogue.Nbt_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrCancel;
END;

procedure TFrm_BoiteDeDialogue.Pan_BtnEnter(Sender: TObject);
begin
     Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_BoiteDeDialogue.Pan_BtnExit(Sender: TObject);
begin
     Nbt_Post.Font.style := [];
end;

END.

