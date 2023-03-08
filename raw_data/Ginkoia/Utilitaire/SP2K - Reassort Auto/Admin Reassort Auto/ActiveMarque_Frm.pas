//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ActiveMarque_Frm;

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
    LMDFormShadow, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, dxDBGrid, dxCntner,
  dxDBGridHP, DB, dxmdaset,Variants, LMDBaseGraphicControl;

TYPE
    TFrm_ActiveMarque = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
    DBG_Marques: TdxDBGridHP;
    MemD_Marque: TdxMemData;
    MemD_MarqueRAM_MRKID: TIntegerField;
    MemD_MarqueMRK_NOM: TStringField;
    MemD_MarqueREM_ACTIF: TIntegerField;
    MemD_MarqueREM_DATEACTIV: TDateTimeField;
    Ds_Marque: TDataSource;
    DBG_MarquesRecId: TdxDBGridColumn;
    DBG_MarquesRAM_MRKID: TdxDBGridMaskColumn;
    DBG_MarquesMRK_NOM: TdxDBGridMaskColumn;
    DBG_MarquesREM_DATEACTIV: TdxDBGridDateColumn;
    DBG_MarquesREM_ACTIF: TdxDBGridCheckColumn;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE Nbt_CancelClick(Sender: TObject);
        PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    procedure Pan_BtnEnter(Sender: TObject);
    procedure Pan_BtnExit(Sender: TObject);
    PRIVATE
    { Private declarations }
    //Initialise la liste des marques du magasins sélectionné
    Procedure InitListeMarqueMag(MagId:Integer);
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED

    END;

FUNCTION ExecuteActiveMarque(Id:Integer): Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
    StdUtils, Main_Dm;

FUNCTION ExecuteActiveMarque(Id:Integer): Boolean;
VAR Frm_ActiveMarque: TFrm_ActiveMarque;
BEGIN
    Result := False;
    Application.createform(TFrm_ActiveMarque, Frm_ActiveMarque);
    WITH Frm_ActiveMarque DO
    BEGIN
        TRY
            //Initialisation
            InitListeMarqueMag(Id);
            IF Showmodal = mrOk THEN
            BEGIN
                Result := True;
            END;
        FINALLY
            Free;
        END;
    END;
END;

PROCEDURE TFrm_ActiveMarque.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_ActiveMarque.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: Nbt_CancelClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN : IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_ActiveMarque.Nbt_PostClick(Sender: TObject);
BEGIN
    //Enregistre les modifications
    MemD_Marque.First;
    while Not MemD_Marque.Eof do
    Begin
      //Affecte la date du jour si elle est vide
      if ((MemD_Marque.FieldByName('REM_DATEACTIV').asString = '') or (MemD_Marque.FieldByName('REM_DATEACTIV').asString = '30/12/1899')) and (MemD_Marque.FieldByName('REM_ACTIF').asInteger = 1) then
      Begin
        MemD_Marque.Edit;
        MemD_Marque.FieldByName('REM_DATEACTIV').AsDateTime := Now;
        MemD_Marque.Post;
      End;

      //Mise à jour d'un enregistrement
      if Dm_Main.Tbl_Magasin.Locate('REM_MAGID;REM_MRKID',VarArrayOf([Dm_Main.Que_LstMrkMagasin.Parameters.ParamByName('MAGID').Value,MemD_Marque.FieldByName('RAM_MRKID').AsInteger]),[]) then
      Begin
        //Insertion d'un nouvel enregistrement dans REAMAGASINHISTO
        if ((MemD_Marque.FieldByName('REM_ACTIF').AsInteger=1) and (Dm_Main.Tbl_Magasin.FieldByName('REM_ACTIF').asInteger=0)) or
           ((MemD_Marque.FieldByName('REM_ACTIF').AsInteger=1) and (Dm_Main.Tbl_Magasin.FieldByName('REM_DATEACTIV').AsDateTime<>MemD_Marque.FieldByName('REM_DATEACTIV').AsDateTime)) then
        Begin
          Dm_Main.Tbl_Histo.Insert;
          Dm_Main.Tbl_Histo.FieldByName('REH_MAGID').AsInteger          := Dm_Main.Que_LstMrkMagasin.Parameters.ParamByName('MAGID').Value;
          Dm_Main.Tbl_Histo.FieldByName('REH_MRKID').AsInteger          := MemD_Marque.FieldByName('RAM_MRKID').AsInteger;
          Dm_Main.Tbl_Histo.FieldByName('REH_DATE').AsDateTime          := MemD_Marque.FieldByName('REM_DATEACTIV').AsDateTime;
          Dm_Main.Tbl_Histo.FieldByName('REH_OK').AsInteger             := 1;
          Dm_Main.Tbl_Histo.FieldByName('REH_TYP').AsInteger            := 0;
          Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONTCK').AsInteger    := 0;
          Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONNEGBL').AsInteger  := 0;
          Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONNEGFCT').AsInteger := 0;
          Dm_Main.Tbl_Histo.FieldByName('REH_INSERTED').AsDateTime      := now;
          Dm_Main.Tbl_Histo.Post;
        End;
        //Mise à jour de la Table REAMagains
        Dm_Main.Tbl_Magasin.Edit;
        Dm_Main.Tbl_Magasin.FieldByName('REM_ACTIF').asInteger       := MemD_Marque.FieldByName('REM_ACTIF').AsInteger;
        if MemD_Marque.FieldByName('REM_ACTIF').AsInteger=1 then
          Dm_Main.Tbl_Magasin.FieldByName('REM_DATEACTIV').AsDateTime  := MemD_Marque.FieldByName('REM_DATEACTIV').AsDateTime
        else
          Dm_Main.Tbl_Magasin.FieldByName('REM_DATEACTIV').AsVariant   := Null;
        Dm_Main.Tbl_Magasin.Post;
      End
      else
      Begin
        //Insertion d'un nouvel enregistrement dans REAMAGASIN
        Dm_Main.Tbl_Magasin.Insert;
        Dm_Main.Tbl_Magasin.FieldByName('REM_MAGID').asInteger       := Dm_Main.Que_LstMrkMagasin.Parameters.ParamByName('MAGID').Value;
        Dm_Main.Tbl_Magasin.FieldByName('REM_MRKID').asInteger       := MemD_Marque.FieldByName('RAM_MRKID').AsInteger;
        Dm_Main.Tbl_Magasin.FieldByName('REM_ACTIF').asInteger       := MemD_Marque.FieldByName('REM_ACTIF').AsInteger;
        Dm_Main.Tbl_Magasin.FieldByName('REM_DATEACTIV').AsDateTime  := MemD_Marque.FieldByName('REM_DATEACTIV').AsDateTime;
        Dm_Main.Tbl_Magasin.Post;
        //Insertion d'un nouvel enregistrement dans REAMAGASINHISTO
        Dm_Main.Tbl_Histo.Insert;
        Dm_Main.Tbl_Histo.FieldByName('REH_MAGID').AsInteger          := Dm_Main.Que_LstMrkMagasin.Parameters.ParamByName('MAGID').Value;
        Dm_Main.Tbl_Histo.FieldByName('REH_MRKID').AsInteger          := MemD_Marque.FieldByName('RAM_MRKID').AsInteger;
        Dm_Main.Tbl_Histo.FieldByName('REH_DATE').AsDateTime          := MemD_Marque.FieldByName('REM_DATEACTIV').AsDateTime;
        Dm_Main.Tbl_Histo.FieldByName('REH_OK').AsInteger             := 1;
        Dm_Main.Tbl_Histo.FieldByName('REH_TYP').AsInteger            := 0;
        Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONTCK').AsInteger    := 0;
        Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONNEGBL').AsInteger  := 0;
        Dm_Main.Tbl_Histo.FieldByName('REH_KVERSIONNEGFCT').AsInteger := 0;
        Dm_Main.Tbl_Histo.FieldByName('REH_INSERTED').AsDateTime      := now;
        Dm_Main.Tbl_Histo.Post;
      End;
      MemD_Marque.Next;
    End;
    ModalResult := mrOk;
END;

PROCEDURE TFrm_ActiveMarque.Nbt_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrCancel;
END;

procedure TFrm_ActiveMarque.Pan_BtnEnter(Sender: TObject);
begin
     Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_ActiveMarque.Pan_BtnExit(Sender: TObject);
begin
     Nbt_Post.Font.style := [];
end;

Procedure TFrm_ActiveMarque.InitListeMarqueMag(MagId:Integer);
//Initialise la liste des marques du magasins sélectionné
Var
  Mem_MRKID   : Integer;    //Memorise la position du curseur de Que_LstMrkRea
Begin
  //Recherche de la liste des marques du magasin sélectionné
  Dm_Main.Que_LstMrkMagasin.Close;
  Dm_Main.Que_LstMrkMagasin.Parameters.ParamByName('MAGID').Value := MagId;
  Dm_Main.Que_LstMrkMagasin.Open;

  //Memorise la position du curseur de Que_LstMrkRea
  Mem_MRKID := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').asInteger;

  //Vide le MemData
  MemD_Marque.Close;
  MemD_Marque.Open;

  //Initialise le MemData
  Dm_Main.Que_LstMrkRea.First;
  while Not Dm_Main.Que_LstMrkRea.eof do
  Begin
    MemD_Marque.Insert;
    MemD_Marque.FieldByName('RAM_MRKID').asInteger      := Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').asInteger;
    MemD_Marque.FieldByName('MRK_NOM').asString         := Dm_Main.Que_LstMrkRea.FieldByName('Mrk_NOM').asString;
    IF Dm_Main.Que_LstMrkMagasin.Locate('REM_MRKID',Dm_Main.Que_LstMrkRea.FieldByName('RAM_MRKID').asInteger,[]) THEN
    BEGIN
      MemD_Marque.FieldByName('REM_ACTIF').asInteger      := Dm_Main.Que_LstMrkMagasin.FieldByName('REM_ACTIF').AsInteger;
      if Dm_Main.Que_LstMrkMagasin.FieldByName('REM_ACTIF').AsInteger = 1 then
        MemD_Marque.FieldByName('REM_DATEACTIV').AsDateTime := Dm_Main.Que_LstMrkMagasin.FieldByName('REM_DATEACTIV').AsDateTime
      else
        MemD_Marque.FieldByName('REM_DATEACTIV').AsString   := '';
    END
    ELSE
    BEGIN
      MemD_Marque.FieldByName('REM_ACTIF').asInteger      := 0;
      MemD_Marque.FieldByName('REM_DATEACTIV').AsString   := '';
    END;
    MemD_Marque.Post;
    Dm_Main.Que_LstMrkRea.Next;
  End;


  //Repositionne le curseur de Que_LstMrkRea à son emplacement
  Dm_Main.Que_LstMrkRea.Locate('RAM_MRKID',Mem_MRKID,[]);
End;
END.

