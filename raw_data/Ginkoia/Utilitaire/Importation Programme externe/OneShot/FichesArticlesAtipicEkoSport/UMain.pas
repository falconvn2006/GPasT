UNIT UMain;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  IB_Components,
  DB,
  dxmdaset,
  StdCtrls,
  RzLabel,
  Mask,
  RzEdit,
  RzBtnEdt,
  ExtCtrls,
  RzPanel,
  RzRadGrp,
  LMDCustomButton,
  LMDButton,
  RzShellDialogs,
  IBODataset,
  RzDBBnEd,
  wwDialog,
  wwidlg,
  wwLookupDialogRv,
  RzDBEdit,
  Grids,
  DBGrids;

TYPE
  TInfoArt = RECORD
    iArtId, iMagId: Integer;
    sArwDetail, sArwComposition: STRING;

  END;

TYPE
  TGesProc = (gpAdd, gpDel);

TYPE
  TFrm_Main = CLASS(TForm)
    Ginkoia: TIB_Connection;
    IbT_Default: TIB_Transaction;
    MemD_FichierCSV: TdxMemData;
    MemD_FichierCSVid_produit: TIntegerField;
    MemD_FichierCSVtechno_fr_fix: TStringField;
    MemD_FichierCSVtechno_fr_ski: TStringField;
    MemD_FichierCSVdescription_fr_fix: TStringField;
    MemD_FichierCSVdescription_fr_ski: TStringField;
    Chp_FicImport: TRzButtonEdit;
    Lab_FicImport: TRzLabel;
    Memo1: TMemo;
    GRb_NivLog: TRzRadioGroup;
    Chp_DB: TRzButtonEdit;
    Lab_db: TRzLabel;
    Nbt_Go: TLMDButton;
    Lab_Log: TRzLabel;
    OD_GetFile: TRzOpenDialog;
    Que_ArtIsWeb: TIBOQuery;
    Chp_Mag: TRzDBButtonEdit;
    Lab_Mag: TRzLabel;
    Que_Mags: TIBOQuery;
    Ds_Mags: TDataSource;
    LK_Mags: TwwLookupDialogRV;
    Que_MagsMAG_ID: TIntegerField;
    Que_MagsMAG_ENSEIGNE: TStringField;
    IbT_Params: TIB_Transaction;
    Que_ExecProc: TIBOQuery;
    Que_Proc: TIB_DSQL;
    Que_ExecProcRESULT: TIntegerField;
    Nbt_Quit: TLMDButton;
    Lab_InfoDB: TRzLabel;
    PROCEDURE Nbt_GoClick(Sender: TObject);
    PROCEDURE Chp_DBButtonClick(Sender: TObject);
    PROCEDURE Chp_FicImportButtonClick(Sender: TObject);
    PROCEDURE Chp_MagButtonClick(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Chp_DBChange(Sender: TObject);
    PROCEDURE Chp_FicImportChange(Sender: TObject);
    PROCEDURE Chp_MagChange(Sender: TObject);
    PROCEDURE Nbt_QuitClick(Sender: TObject);
  PRIVATE
    { Déclarations privées }
    PROCEDURE GesAff();
    FUNCTION DBReconnect: Boolean;
    FUNCTION GesProc(AType: TGesProc; bAffMess: Boolean = True): Boolean;
    FUNCTION OuvreFichier(sPath: STRING): Boolean;
    FUNCTION ArticleDejaWeb(AProdId: Integer): Boolean;
  PUBLIC
    { Déclarations publiques }
    FUNCTION DoTraitement(): boolean;
  END;

VAR
  Frm_Main: TFrm_Main;

IMPLEMENTATION

{$R *.dfm}

USES UCommon;
{ TFrm_Main }

PROCEDURE TFrm_Main.Chp_FicImportButtonClick(Sender: TObject);
BEGIN
  // Récup du fichier Database
  OD_GetFile.Options := [osoFileMustExist, osoNoChangeDir];
  OD_GetFile.InitialDir := ExtractFilePath(Application.exeName);
  OD_GetFile.Filter := 'Fichiers CSV|*.CSV|Tous|*.*';
  OD_GetFile.FileName := Chp_FicImport.Text;
  IF OD_GetFile.Execute THEN
  BEGIN
    Chp_FicImport.Text := OD_GetFile.FileName;
  END;
END;

PROCEDURE TFrm_Main.Chp_FicImportChange(Sender: TObject);
BEGIN
  GesAff;
END;

FUNCTION TFrm_Main.GesProc(AType: TGesProc; bAffMess: Boolean = True): Boolean;
VAR
  sPath, sFic: STRING;
  sLib1, sLib2, sLib3: STRING;

BEGIN
  IF AType = gpAdd THEN // création
  BEGIN
    sLib1 := 'Création';
    sLib2 := 'créée';
    sFic := 'AddProc.sql';

    // On commence par un del
    GesProc(gpDel, False);
  END
  ELSE IF AType = gpDel THEN
  BEGIN // suppression
    sLib1 := 'Suppression';
    sLib2 := 'supprimée';
    sFic := 'DelProc.sql';
  END
  ELSE
    Exit;

  Result := False;
  IF bAffMess THEN LogAction('***********************************************************', 2);
  TRY
    sPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
    sPath := sPath + sFic;

    IF bAffMess THEN LogAction(sLib1 + ' de la procédure d''ajout des articles', 2);
    IF FileExists(sPath) THEN
    BEGIN
      TRY
        Que_Proc.IB_Transaction.StartTransaction;
        Que_Proc.SQL.LoadFromFile(sPath);
        Que_Proc.Prepare;
        Que_Proc.ExecSQL;
      FINALLY
        Que_Proc.Unprepare;
        Que_Proc.IB_Transaction.Commit;
      END;

      IF bAffMess THEN LogAction('Procédure ' + sLib2, 2);
      Result := True;
    END
    ELSE
      IF bAffMess THEN LogAction('Erreur, fichier inexistant : ' + sPath, 0);

  EXCEPT ON e: Exception DO
    BEGIN
      IF bAffMess THEN LogAction('Erreur, exception : ' + E.Message, 0);
    END;
  END;
  IF bAffMess THEN LogAction('***********************************************************', 2);
END;

FUNCTION TFrm_Main.DBReconnect: Boolean;
BEGIN
  Result := False;
  IF Ginkoia.Database <> Chp_DB.Text THEN
  BEGIN
    Que_Mags.Close;
    Ginkoia.Close;
    Ginkoia.Database := Chp_DB.Text;
  END;

  IF FileExists(Chp_DB.Text) THEN
  BEGIN
    TRY
      IF NOT Ginkoia.Connected THEN
      BEGIN
        Ginkoia.Open;
        Que_Mags.Open;
        Que_Mags.First;
      END;
      Result := True;
    FINALLY
    END;
  END;
END;

FUNCTION TFrm_Main.DoTraitement: boolean;
VAR
  iSvgId: Integer;
  stArticle: TInfoArt;
BEGIN
  Result := False;

  IF MessageDlg('Merci de confirmer l''import des articles dans le magasin :' + #13 + #10 + Que_MagsMAG_ENSEIGNE.AsString, mtConfirmation, [mbYes, mbNo], 0) = mrNo THEN
    Exit;

  initLogFileName(Memo1, NIL, GRb_NivLog.ItemIndex);
  LogAction('***********************************************************', 2);
  LogAction('****************     DEBUT TRAITEMENT      ****************', 2);
  LogAction('***********************************************************', 2);

  stArticle.iMagId := Que_MagsMAG_ID.AsInteger;

  // on charge le fichier
  IF OuvreFichier(Chp_FicImport.Text) THEN
  BEGIN
    TRY
      // création de la procédrure
      IF GesProc(gpAdd) THEN
      BEGIN
        // on parcours le fichier
        MemD_FichierCSV.First;
        WHILE NOT MemD_FichierCSV.EOF DO
        BEGIN
          // Traitement de l'article
          stArticle.iArtId := MemD_FichierCSVid_produit.AsInteger;

          IF NOT ArticleDejaWeb(stArticle.iArtId) THEN
          BEGIN
            // dans ce cas, on traite
            stArticle.sArwDetail := Copy(MemD_FichierCSVdescription_fr_fix.AsString + #13#10 + MemD_FichierCSVdescription_fr_ski.AsString, 0, 512);
            stArticle.sArwComposition := Copy(MemD_FichierCSVtechno_fr_fix.AsString + #13#10 + MemD_FichierCSVtechno_fr_ski.AsString, 0, 512);

            TRY
              Que_ExecProc.ParamByName('MAGID').AsInteger := stArticle.iMagId;
              Que_ExecProc.ParamByName('ARTID').AsInteger := stArticle.iArtId;
              Que_ExecProc.ParamByName('ARWDETAIL').AsString := stArticle.sArwDetail;
              Que_ExecProc.ParamByName('ARWCOMPO').AsString := stArticle.sArwComposition;

              Que_ExecProc.IB_Transaction.StartTransaction;
              Que_ExecProc.Open;
              Que_ExecProc.First;

              // la proc renvoie le arwid, si c'est 0 c'est une erreur
              IF Que_ExecProc.Fields[0].AsInteger > 0 THEN
              BEGIN
                Que_ExecProc.Close;
                Que_ExecProc.IB_Transaction.Commit;
                LogAction('Article traité : ' + IntToStr(stArticle.iArtId), 2);
              END
              ELSE BEGIN
                Que_ExecProc.Close;
                Que_ExecProc.IB_Transaction.Rollback;
                LogAction('Erreur traitement article : ' + IntToStr(stArticle.iArtId), 0);
              END;

            EXCEPT ON E: Exception DO
              BEGIN
                Que_ExecProc.Close;
                Que_ExecProc.IB_Transaction.Rollback;
                LogAction('Erreur traitement article : ' + IntToStr(stArticle.iArtId), 0);
                LogAction(E.Message, 0);
              END;
            END;
          END
          ELSE
            LogAction('Article non traité, déjà WEB : ' + IntToStr(stArticle.iArtId), 2);

          WHILE ((stArticle.iArtId = MemD_FichierCSVid_produit.AsInteger) AND NOT MemD_FichierCSV.Eof) DO
          BEGIN
            // Passage au produit id suivant
            MemD_FichierCSV.Next;
          END;
        END;
        MemD_FichierCSV.Close;
        Result := True;
      END;
      GesProc(gpDel);
    EXCEPT ON E: Exception DO
      BEGIN
        Result := False;
      END;
    END;
  END;

  LogAction('***********************************************************', 2);
  LogAction('****************      FIN TRAITEMENT       ****************', 2);
  LogAction('***********************************************************', 2);

END;

PROCEDURE TFrm_Main.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
BEGIN
  Que_Mags.Close;
  Ginkoia.Close;
END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
BEGIN
  DBReconnect;
  GesAff;
END;

PROCEDURE TFrm_Main.GesAff;
BEGIN
  // affichage du label de connexcion à la DB
  IF (Ginkoia.Connected) THEN
    Lab_InfoDB.Visible := False
  ELSE
    Lab_InfoDB.Visible := True;

  // affichage du bouton go
  IF (Ginkoia.Connected) AND (Chp_FicImport.Text <> '') AND (Chp_Mag.Text <> '') THEN
    Nbt_Go.Enabled := True
  ELSE
    Nbt_Go.Enabled := False;
END;

PROCEDURE TFrm_Main.Nbt_GoClick(Sender: TObject);
BEGIN
  IF DoTraitement() THEN
    ShowMessage('Traitement OK')
  ELSE
    ShowMessage('Erreur lors du traitement, consultez le log');
END;

PROCEDURE TFrm_Main.Nbt_QuitClick(Sender: TObject);
BEGIN
  Close;
END;

FUNCTION TFrm_Main.OuvreFichier(sPath: STRING): Boolean;
BEGIN
  LogAction('***********************************************************', 2);
  LogAction('Chargement du fichier : ' + sPath, 2);
  IF NOT FileExists(sPath) THEN
  BEGIN
    LogAction('Erreur chargement : Fichier inexistant', 0);
  END
  ELSE BEGIN
    TRY
      MemD_FichierCSV.DelimiterChar := ';';
      MemD_FichierCSV.LoadFromTextFile(sPath);
      LogAction('Chargement du fichier réussi', 2);
      Result := True;
    EXCEPT ON E: Exception DO
      BEGIN
        LogAction('Erreur chargement (Exception) : ' + E.Message, 0);
      END;
    END;
  END;
  LogAction('***********************************************************', 2);

END;

PROCEDURE TFrm_Main.Chp_MagButtonClick(Sender: TObject);
BEGIN
  IF DBReconnect() THEN
  BEGIN
    LK_Mags.Execute;
  END;
END;

PROCEDURE TFrm_Main.Chp_MagChange(Sender: TObject);
BEGIN
  GesAff;
END;

FUNCTION TFrm_Main.ArticleDejaWeb(AProdId: Integer): Boolean;
BEGIN
  Result := True; // dans le cas d'une erreur, on renvoie qu'il est déjà web, pour ne pas traiter l'article
  TRY
    Que_ArtIsWeb.ParamByName('ARTID').AsInteger := AProdId;
    Que_ArtIsWeb.Open;

    IF Que_ArtIsWeb.Fields[0].AsInteger > 0 THEN
    BEGIN
      Result := True;
    END
    ELSE BEGIN
      Result := False;
    END;
  FINALLY
    Que_ArtIsWeb.Close;
  END;
END;

PROCEDURE TFrm_Main.Chp_DBButtonClick(Sender: TObject);
BEGIN
  // Récup du fichier Database
  OD_GetFile.Options := [osoFileMustExist, osoNoChangeDir];
  OD_GetFile.InitialDir := 'C:\Ginkoia\Data';
  OD_GetFile.Filter := 'Interbase DB|*.IB;*.GDB|Tous|*.*';
  OD_GetFile.FileName := Chp_DB.Text;
  IF OD_GetFile.Execute THEN
  BEGIN
    Chp_DB.Text := OD_GetFile.FileName;
  END;

END;

PROCEDURE TFrm_Main.Chp_DBChange(Sender: TObject);
BEGIN
  DbReconnect;
  GesAff;
END;

END.

