UNIT LaunchV7_Dm;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    TypInfo,
    rxStrHlder, IBDatabase, Db, IBCustomDataSet, IBQuery,
  ListBitMap;

TYPE
    TDm_LaunchV7 = CLASS(TDataModule)
        RVIML_Small: TlistImageRV;
        Str_CodesBtn: TStrHolder;
        data_: TIBDatabase;
        Tran_: TIBTransaction;
        IBQue_NbMag: TIBQuery;
    IB_ModifK: TIBQuery;
    Tran_Commit: TIBTransaction;
    PRIVATE
    function NewK(Table: string): integer;
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        FUNCTION ConnectDataBase(Base: STRING): boolean;
        PROCEDURE CloseDataBase;
        PROCEDURE AffecteHintEtBmp(Panel: TWinControl);
        FUNCTION NbMag: Integer;

        procedure DeleteK(Clef: Integer);
        procedure ModifK(Clef: Integer);
        procedure ReactiveK(Clef: Integer);

    END;

VAR
    Dm_LaunchV7: TDm_LaunchV7;

IMPLEMENTATION

USES
    GinkoiaResStr;

{$R *.DFM}

FUNCTION TDm_LaunchV7.ConnectDataBase(Base: STRING): boolean;
BEGIN
    TRY
        data_.Close;
        data_.databaseName := Base;
        data_.open;
        Tran_.active := True;
        result := True;
    EXCEPT
        result := false;
        data_.Close;
        Tran_.active := false;
    END;
END;

//---------------------------------------------------------------
// Récupération d'un nouvel ID
//---------------------------------------------------------------
FUNCTION TDm_LaunchV7.NewK(Table: String) : integer;
BEGIN
  IB_ModifK.Close;
  IB_ModifK.Sql.Clear;
  IB_ModifK.Sql.Text := 'SELECT ID FROM PR_NEWK(' + Table +')';
  try
    IB_ModifK.Open;
    Result := IB_ModifK.Fields[0].AsInteger;
  except
    Result := 0;
  end;
  IB_ModifK.Close;
  IB_ModifK.Sql.Clear;
END;

//---------------------------------------------------------------
// Modification du K -> réactivation d'un k_enabled = 0
//---------------------------------------------------------------
procedure TDm_LaunchV7.ReactiveK(Clef: Integer);
begin
  IB_ModifK.Close;
  IB_ModifK.Sql.CLEAR;
  IB_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 2)';
  IB_ModifK.ExecSQL;
  IB_ModifK.Sql.Clear;
end;

//---------------------------------------------------------------
// Modification du K
//---------------------------------------------------------------
PROCEDURE TDm_LaunchV7.ModifK(Clef: Integer);
BEGIN
  IB_ModifK.Close;
  IB_ModifK.Sql.CLEAR;
  IB_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 0)';
  IB_ModifK.ExecSQL;
  IB_ModifK.Sql.Clear;
END;

//---------------------------------------------------------------
// suppression du K
//---------------------------------------------------------------

PROCEDURE TDm_LaunchV7.DeleteK(Clef: Integer);
BEGIN
  IB_ModifK.Close;
  IB_ModifK.Sql.CLEAR;
  IB_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 1)';
  IB_ModifK.ExecSql;
  IB_ModifK.Sql.CLEAR;
END;

PROCEDURE TDm_LaunchV7.ClosedataBase;
BEGIN
    Tran_.active := false;
    data_.Close;
END;

FUNCTION TDm_LaunchV7.NbMag: Integer;
BEGIN
    IBQue_NbMag.Open;
    Result := IBQue_NbMag.RecordCount;
    IBQue_NbMag.Close;
END;

PROCEDURE TDm_LaunchV7.AffecteHintEtBmp(Panel: TWinControl);
VAR
    TC: TControl;
    LH, S: STRING;
    PropInfo: PPropInfo;
    i, k, z: Integer;
    _bt: TBitmap;
BEGIN
    _bt := TBitmap.Create;
    TRY
        FOR i := 0 TO Panel.ControlCount - 1 DO
        BEGIN
            k := -1;
            S := '';
            LH := '';

            Tc := Panel.Controls[i];
            PropInfo := GetPropInfo(Tc, 'OnClick');
            IF PropInfo <> NIL THEN
            BEGIN
                PropInfo := GetPropInfo(Tc, 'Glyph');
                IF PropInfo <> NIL THEN
                BEGIN
                    k := 1000;
                    FOR z := 0 TO Str_CodesBtn.Strings.Count - 1 DO
                    BEGIN
                        IF Pos(Uppercase(Str_CodesBtn.Strings[z]), Uppercase(TC.Name)) > 0 THEN
                        BEGIN
                            LH := GetStrProp(Tc, GetPropInfo(Tc, 'Hint'));
                            k := z;
                            BREAK;
                        END;
                    END;
                    CASE K OF
                        0: S := 'Filter';
                        1:
                            BEGIN
                                S := 'Filtre';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintVoirFiltre);
                            END;
                        2:
                            BEGIN
                                S := 'Autowidth';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintAutoWidth);
                            END;
                        3:
                            BEGIN
                                S := 'Calcbleu';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBasculeGrpFoot);
                            END;
                        4:
                            BEGIN
                                S := 'Calcgris';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnShowFooterRow);
                            END;
                        5:
                            BEGIN
                                S := 'Calcjaune';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnShowFooter);
                            END;
                        6:
                            BEGIN
                                S := 'Preview';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnPreview);
                            END;
                        7, 8:
                            BEGIN
                                S := 'Openlevel';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintExpandLevel);
                            END;
                        9:
                            BEGIN
                                S := 'Arbreplus';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintFullExpand);
                            END;
                        10, 11:
                            BEGIN
                                S := 'Closelevel';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintCollapseLevel);
                            END;
                        12:
                            BEGIN
                                S := 'Arbremoins';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintFullCollapse);
                            END;
                        13:
                            BEGIN
                                S := 'Print1';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintEditInterne);
                            END;
                        14:
                            BEGIN
                                S := 'Print1';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnPrintDbg);
                            END;
                        15:
                            BEGIN
                                S := 'Calendar';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintPeriodeEtude);
                            END;
                        16:
                            BEGIN
                                S := 'Sovecmz';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnSoveCmz);
                            END;
                        17:
                            BEGIN
                                S := 'Cmz';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnCmzDbg);
                            END;
                        18:
                            BEGIN
                                S := 'DiskFrom';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnLoadCmz);
                            END;
                        19:
                            BEGIN
                                S := 'Filteroff';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnClearFilterDbg);
                            END;
                        20:
                            BEGIN
                                S := 'Grouppanel';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnShowGroupPanel);
                            END;
                        21:
                            BEGIN
                                S := 'Excel';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnExcelDbg);
                            END;
                        22:
                            BEGIN
                                S := 'Prior';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintPriorRec);
                            END;
                        23:
                            BEGIN
                                S := 'Next';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintNextRec);
                            END;
                        24:
                            BEGIN
                                S := 'Outils';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnPopup);
                            END;
                        25:
                            BEGIN
                                S := 'Refresh';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnRefresh);
                            END;
                        26:
                            BEGIN
                                S := 'Cancel';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnCancel);
                            END;
                        27:
                            BEGIN
                                S := 'Post';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnPost);
                            END;
                        28:
                            BEGIN
                                S := 'Edit';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnEdit);
                            END;
                        29:
                            BEGIN
                                S := 'Delete';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnDelete);
                            END;
                        30:
                            BEGIN
                                S := 'Insert';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnInsert);
                            END;
                        31: S := 'Quitter';
                        32: IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnConvert);
                        33:
                            BEGIN
                                S := 'UndoCmz';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnUndo);
                            END;
                        34:
                            BEGIN
                                S := 'Preco';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintPreco);
                            END;
                        35:
                            BEGIN
                                S := 'AutoHeight';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintAutoHeight);
                            END;
                        36:
                            BEGIN
                                S := 'GrandA';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnGroupart);
                            END;
                        37:
                            BEGIN
                                S := 'PanelLeft';
                                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintAffChx);
                            END;
                    END;
                    IF S <> '' THEN
                    BEGIN
                        RVIML_Small.AssignImagesByName(S, _bt);
                        SetObjectProp(Tc, 'Glyph', _Bt);
                    END;
                END;
            END;
            IF (k = -1) AND (tc IS TWinControl) THEN
                AffecteHintEtBmp(TWinControl(TC))
        END;
    FINALLY
        _bt.Free;
    END;
END;

END.

 