//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ListeArtErr_Frm;

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
    LMDFormShadow, StdCtrls,
    Printers;

RESOURCESTRING
  RS_TEXT_LstArt  = 'Liste des articles non importés';
TYPE
    TFrm_ListeArtErr = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
    Nbt_Imp: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
    Pan_Fond: TRzPanel;
    Memo_Err: TMemo;
    PD_LstErr: TPrintDialog;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE Nbt_ImpClick(Sender: TObject);
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

FUNCTION ExecuteFrm_ListeArtErr(LstErr:TStringList): Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
    StdUtils;

FUNCTION ExecuteFrm_ListeArtErr(LstErr:TStringList): Boolean;
VAR Frm_ListeArtErr: TFrm_ListeArtErr;
BEGIN
    Result := False;
    Application.createform(TFrm_ListeArtErr, Frm_ListeArtErr);
    WITH Frm_ListeArtErr DO
    BEGIN
        TRY
            Memo_Err.Lines  := LstErr;
            IF Showmodal = mrOk THEN
            BEGIN
                Result := True;
            END;
        FINALLY
            Free;
        END;
    END;
END;

PROCEDURE TFrm_ListeArtErr.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_ListeArtErr.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN : IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_ListeArtErr.Nbt_PostClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_ListeArtErr.Nbt_ImpClick(Sender: TObject);
Var
  I   : Integer;    //Variable de boucle
BEGIN
  If PD_LstErr.Execute(Memo_Err.Handle) then
  Begin
    Printer.Title := RS_TEXT_LstArt;
    Printer.BeginDoc;
    for I := 0 to Memo_Err.Lines.Count - 1 do
    Begin
      if (80*(I+1))-((Printer.PageNumber-1)*6400)>6400 then
        Printer.NewPage;
      Printer.Canvas.TextOut(40,(80*(I+1))-((Printer.PageNumber-1)*6400),Memo_Err.Lines.Strings[I]);
    End;
    Printer.EndDoc;
  End;
END;

procedure TFrm_ListeArtErr.Pan_BtnEnter(Sender: TObject);
begin
     Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_ListeArtErr.Pan_BtnExit(Sender: TObject);
begin
     Nbt_Post.Font.style := [];
end;

END.

