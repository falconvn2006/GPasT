UNIT UMain;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  // uses perso
  IniFiles,
  // fin uses perso

  Dialogs, dxDBCtrl, dxDBGrid, dxTL, dxCntner, dxDBGridHP, StdCtrls, wwcheckbox,
  wwCheckBoxRV, RzEdit, RzDBEdit, RzDBBnEd, RzDBButtonEditRv, Mask, wwdbedit,
  wwDBEditRv, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, CheckLst, ComCtrls, RzShellDialogs,
  ActionRv, DB, IBODataset, wwDialog, wwidlg, wwLookupDialogRv, IB_Components,
  dxmdaset, LMDCustomButton, LMDButton, ExtCtrls, RzPanel, RzPanelRv, RzLabel,
  ActnList;

TYPE tParams = RECORD
    sDBExport: STRING;
    sDBGinkoia: STRING;
    bLogActif: boolean;
  END;

TYPE tTaille = RECORD
    iId : integer;
    iType : integer; // 0 = GTF, 1 = MTT
  END;
  
TYPE
  TFrm_Main = CLASS(TForm)
    BaseGinkoia: TIB_Connection;
    MemD_LoadFic: TdxMemData;
    OD_Path: TOpenDialog;
    RzPanelRv1: TRzPanelRv;
    RzPanelRv2: TRzPanelRv;
    RzPanelRv3: TRzPanelRv;
    Gax_DBConnected: TActionGroupRv;
    Ds_AffFic: TDataSource;
    MemD_LoadFicRayon: TStringField;
    MemD_LoadFicFamille: TStringField;
    MemD_LoadFicSSFamille: TStringField;
    MemD_LoadFicGenre: TStringField;
    MemD_LoadFicNom: TStringField;
    MemD_LoadFicRef: TStringField;
    MemD_LoadFicCouleur: TStringField;
    MemD_LoadFicPA: TStringField;
    MemD_LoadFicRemise: TStringField;
    MemD_LoadFicPxVte: TStringField;
    MemD_LoadFicmois1: TStringField;
    MemD_LoadFicmois2: TStringField;
    MemD_LoadFicmois3: TStringField;
    MemD_LoadFicmois4: TStringField;
    MemD_LoadFicmois5: TStringField;
    MemD_LoadFicmois6: TStringField;
    MemD_LoadFicQteTotale: TStringField;
    MemD_LoadFicBA: TStringField;
    Lab_PathCSV: TRzLabel;
    Gax_Files: TActionGroupRv;
    BaseCorrespondance: TIB_Connection;
    IbT_Select: TIB_Transaction;
    IbT_Insert: TIB_Transaction;
    LK_Genre: TwwLookupDialogRV;
    Que_LkGenre: TIBOQuery;
    Que_NKL: TIBOQuery;
    Que_NKLSSF_ID: TIntegerField;
    IbT_CorrespSelect: TIB_Transaction;
    Grd_Close: TGroupDataRv;
    LK_GetArticle: TwwLookupDialogRV;
    Que_GetArticle: TIBOQuery;
    Que_GetArticleART_ID: TIntegerField;
    Que_GetArticleARF_ID: TIntegerField;
    Que_GetArticleART_NOM: TStringField;
    Que_GetArticleART_REFMRK: TStringField;
    Que_GetArticleARF_CHRONO: TStringField;
    Que_ArticleCre: TIBOQuery;
    Lab_Titre: TRzLabel;
    LK_TCTID: TwwLookupDialogRV;
    LK_TVAID: TwwLookupDialogRV;
    Que_TVAID: TIBOQuery;
    Que_TCTID: TIBOQuery;
    MemD_Params: TdxMemData;
    MemD_ParamsTCT_ID: TIntegerField;
    MemD_ParamsTVA_ID: TIntegerField;
    Ds_Params: TDataSource;
    LK_NKL: TwwLookupDialogRV;
    Que_NKLSEC_NOM: TStringField;
    Que_NKLRAY_NOM: TStringField;
    Que_NKLFAM_NOM: TStringField;
    Que_NKLSSF_NOM: TStringField;
    Nbt_Quit: TLMDButton;
    LK_Secteur: TwwLookupDialogRV;
    Que_LKSecteur: TIBOQuery;
    Que_LKSecteurSEC_ID: TIntegerField;
    Que_LKSecteurSEC_NOM: TStringField;
    MemD_ParamsSEC_ID: TIntegerField;
    IbC_Select: TIBOQuery;
    IbC_Insert: TIBOQuery;
    IbC_CoulCre: TIBOQuery;
    IbC_NewK: TIBOQuery;
    IbC_CorrespGTF: TIBOQuery;
    IbC_InsCorGTF: TIBOQuery;
    RepDlg_SelectFolder: TRzSelectFolderDialog;
    Pgc_Main: TPageControl;
    Tab_Traitements: TTabSheet;
    Tab_Params: TTabSheet;
    Tab_Visu: TTabSheet;
    Memo_Log: TMemo;
    Lab_Rapport: TRzLabel;
    Lbx_Files: TCheckListBox;
    Nbt_ChargerFichier: TLMDButton;
    Nbt_Actualiser: TLMDSpeedButton;
    Nbt_CheckAll: TLMDSpeedButton;
    Chp_PathCSV: TwwDBEditRv;
    Lab_ChoixFolder: TRzLabel;
    Lab_ListeFichiers: TRzLabel;
    RzPanelRv4: TRzPanelRv;
    Lab_PathDB: TRzLabel;
    Nbt_PathDB: TLMDSpeedButton;
    Chp_PathDB: TwwDBEditRv;
    Nbt_ConnectDB: TLMDButton;
    RzPanelRv5: TRzPanelRv;
    Lab_TCTID: TRzLabel;
    Lab_CodeTVA: TRzLabel;
    RzLabel1: TRzLabel;
    Chp_TCTID: TRzDBButtonEditRv;
    Chp_CodeTVA: TRzDBButtonEditRv;
    Chp_Secteur: TRzDBButtonEditRv;
    RzPanelRv6: TRzPanelRv;
    Chp_ActiveLog: TwwCheckBoxRV;
    dxDBGridHP1: TdxDBGridHP;
    dxDBGridHP1RecId: TdxDBGridColumn;
    dxDBGridHP1Rayon: TdxDBGridMaskColumn;
    dxDBGridHP1Famille: TdxDBGridMaskColumn;
    dxDBGridHP1SSFamille: TdxDBGridMaskColumn;
    dxDBGridHP1Genre: TdxDBGridMaskColumn;
    dxDBGridHP1Nom: TdxDBGridMaskColumn;
    dxDBGridHP1Ref: TdxDBGridMaskColumn;
    dxDBGridHP1Couleur: TdxDBGridMaskColumn;
    dxDBGridHP1PA: TdxDBGridMaskColumn;
    dxDBGridHP1Remise: TdxDBGridMaskColumn;
    dxDBGridHP1PxVte: TdxDBGridMaskColumn;
    dxDBGridHP1mois1: TdxDBGridMaskColumn;
    dxDBGridHP1mois2: TdxDBGridMaskColumn;
    dxDBGridHP1mois3: TdxDBGridMaskColumn;
    dxDBGridHP1mois4: TdxDBGridMaskColumn;
    dxDBGridHP1mois5: TdxDBGridMaskColumn;
    dxDBGridHP1mois6: TdxDBGridMaskColumn;
    dxDBGridHP1QteTotale: TdxDBGridMaskColumn;
    dxDBGridHP1BA: TdxDBGridMaskColumn;
    Nbt_SelectFolder: TLMDSpeedButton;
    IbC_MajDB: TIBOQuery;
    BaseCorMAJ: TIB_Connection;
    IbT_CorMAJ: TIB_Transaction;
    PROCEDURE Nbt_PathDBClick(Sender: TObject);
    PROCEDURE Nbt_ConnectDBClick(Sender: TObject);
    FUNCTION DBReconnect(): boolean;
    FUNCTION TraiterFichier(sPathFic: STRING; TS: TStrings): boolean;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Nbt_SelectFolderClick(Sender: TObject);
    PROCEDURE ListerFichier();
    PROCEDURE Nbt_CheckAllClick(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE Chp_PathCSVChange(Sender: TObject);
    PROCEDURE Nbt_ChargerFichierClick(Sender: TObject);
    FUNCTION GetNewK(NomTable: STRING): Integer;
    FUNCTION GetOrInsertCollection(sNomColl: STRING): integer;
    FUNCTION GetFouID(sNomMrk: STRING; VAR iFOU_ID, iMRK_ID: integer): boolean;
    FUNCTION GetGenre(sGenre: STRING): Integer;
    FUNCTION GetNLK(sRAY_NOM, sFAM_NOM, sSSF_NOM, sARTNOM: STRING): Integer;
    FUNCTION ArfArtIDExists(VAR iARTID: integer; VAR iARFID: integer; iGRE_ID: integer; sNomMrk, sRef, sNom: STRING): integer;
    FUNCTION GetGTF(iSSFID, iMRKID, iGREID: integer; AArtNOM: STRING): tTaille;
    FUNCTION SetPV(iARTID: integer; sPxV: STRING): boolean;
    FUNCTION SetPA(iARTID, iFOU_ID: integer; sPxA, sRemise: STRING): boolean;
    FUNCTION SetCOL(iARTID, iCOLID: integer): boolean;
    PROCEDURE ParamSave(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE FormPaint(Sender: TObject);
    PROCEDURE Nbt_QuitClick(Sender: TObject);
    procedure Nbt_ActualiserClick(Sender: TObject);
   
  PRIVATE
    { Déclarations privées }
    MyIniFile: TIniFile;
    PROCEDURE InitParam();
    PROCEDURE DoMAJ();
  PUBLIC
    MyParams: TParams;
    bClosing: boolean
      { Déclarations publiques }
  END;

VAR
  Frm_Main: TFrm_Main;

IMPLEMENTATION


USES UCommon, UNomenk, UChoixGrilleTaille;
{$R *.DFM}

PROCEDURE TFrm_Main.Nbt_PathDBClick(Sender: TObject);
BEGIN
  OD_Path.Filter := 'DB Interbase (*.ib,*.gdb)|*.ib;*.gdb|Tous (*.*)|*.*';
  OD_Path.InitialDir := 'c:\ginkoia\data';
  IF OD_Path.Execute THEN
  BEGIN
    Chp_PathDB.Text := OD_Path.FileName;
    DBReconnect();
  END;

END;

PROCEDURE TFrm_Main.Nbt_ConnectDBClick(Sender: TObject);
BEGIN
  DBReconnect();
END;

FUNCTION TFrm_Main.DBReconnect: boolean;
BEGIN

  Result := False;
  Gax_DBConnected.Enabled := False;

{  IF FileExists(Chp_PathDB.Text) THEN
  BEGIN}

    IF FileExists(MyParams.sDBExport) THEN
    BEGIN

      BaseGinkoia.Close;
      BaseGinkoia.DatabaseName := Chp_PathDB.Text;
      TRY
        BaseGinkoia.Open;
        IF BaseGinkoia.Connected THEN
        BEGIN
          // Svg Params
          ParamSave(NIL);

          // base de correspondance
          BaseCorrespondance.Close;
          BaseCorrespondance.DatabaseName := MyParams.sDBExport;
          TRY
            BaseCorrespondance.Open;
            IF BaseCorrespondance.Connected THEN
            BEGIN
              Result := True;
            END
            ELSE BEGIN
              Result := False;
              LogAction('Erreur de connection à la base de données (1): ' + MyParams.sDBExport, True);

            END;
          EXCEPT
            ON E: Exception DO
            BEGIN
              LogAction('Erreur de connection à la base de données (2): ' + MyParams.sDBExport, True);
              Result := False;
            END;
          END;

        END
        ELSE BEGIN
          LogAction('Erreur de connection à la base de données (3): ' + Chp_PathDB.Text, True);
          Result := False;
        END;

      EXCEPT
        ON E: Exception DO
        BEGIN
          LogAction('Erreur de connection à la base de données (4) : ' + Chp_PathDB.Text, True);
          Result := False;
        END;
      END;

      IF Result = False THEN
        LogAction('Erreur de connection à la base de données (5) : ' + Chp_PathDB.Text, True);

    END
    ELSE BEGIN
      LogAction('Erreur de connection à la base de données (6) : ' + MyParams.sDBExport, True);
    END;
    Gax_DBConnected.Enabled := Result;

END;

procedure TFrm_Main.DoMAJ;
var
  srMyFile : TSearchRec;
  sFolder : string;
  sFiles: string;
begin
  sFolder := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
  sFiles := sFolder + 'MAJCorresp*.sql';
  if FindFirst(sFiles, faAnyFile, srMyFile) = 0 then
    begin
      BaseCorMAJ.Close;
      BaseCorMAJ.Database := BaseCorrespondance.DataBase;
      TRY
        BaseCorMAJ.Username := 'SYSDBA';
        BaseCorMAJ.Password := 'masterkey';
        BaseCorMAJ.Open;
        repeat
          if (srMyFile.Attr and faAnyFile) = srMyFile.Attr then
          begin
            // Traiter ce fichier
            TRY
              IbC_MajDB.SQL.LoadFromFile(sFolder + srMyFile.Name);
              IbC_MajDB.Prepare;
              IbC_MajDB.ExecSQL;
              IbC_MajDB.UnPrepare;
              LogAction('Mise à jour de la base de donnée effectuée : ' + ExtractFileName(srMyFile.Name));
              RenameFile(sFolder + srMyFile.Name,sFolder + 'Done_' + srMyFile.Name)

            except on E: Exception do
              begin
                LogAction('Erreur de mise à jour de la base de donnée : ' + ExtractFileName(srMyFile.Name));
                RenameFile(sFolder + srMyFile.Name,sFolder + 'Error_' + srMyFile.Name)
              end;
            end;
          end;
        until FindNext(srMyFile) <> 0;
        FindClose(srMyFile);
      FINALLY
        BaseCorMAJ.Close;
      END;
    end;
end;

FUNCTION TFrm_Main.TraiterFichier(sPathFic: STRING; TS: TStrings): boolean;
VAR
  MyEntete: STRING;
  i, j: integer;
  sData, sVal: STRING;
  iCOL_ID, iFOU_ID, iMRK_ID: integer;
  sREFMRK, sMRKNOM, sCOLNOM: STRING;
  sCOUNOM, sARTNOM: STRING;
  sChrono: STRING;
  iART_ID, iARF_ID: integer;
  stGTF : tTaille;
  iGRE_ID, iSSF_ID: integer;
  bErreurFatale: boolean;
  iResFct: integer;

BEGIN
  // Init des variables
  iCOL_ID := 0; iFOU_ID := 0; iMRK_ID := 0; iART_ID := 0; iARF_ID := 0; iSSF_ID := 0; iGRE_ID := 0; iResFct := 0;
  stGTF.iId := 0; stGTF.iType := 1;
  SREFMRK := ''; sMRKNOM := ''; sCOLNOM := ''; sCOUNOM := ''; sARTNOM := ''; sChrono := ''; SREFMRK := '';
  bErreurFatale := False;

  Result := False;
  IF FileExists(sPathFic) THEN
  BEGIN
    FOR i := 1 TO (MemD_LoadFic.FieldCount - 1) DO
    BEGIN
      MyEntete := MyEntete + ';' + MemD_LoadFic.Fields[i].FieldName;
    END;
    // Supp du premier ';'
    Delete(MyEntete, 1, 1);

    // On ajoute les ; à la fin...
    MyEntete := MyEntete + ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;';

    TRY
      TS.LoadFromFile(sPathFic);
    EXCEPT
      LogAction('Erreur lors de l''ouverture du fichier, vérifiez qu''il n''est pas déjà ouvert par un autre programme',True);
      Result := False;
      EXIT;
    END;
    // Traitement de l'entete dans un premier temps.
    FOR i := 1 TO 7 DO
    BEGIN
      // Récupération de la donnée entre le début, et le premier ';'
      sData := Copy(TS[0], 0, Pos(';', TS[0]) - 1);
      // Récupération de la valeur entre le premier ';' et le deuxieme ';', je sais, la formule n'est pas lisible... désolé !
      sVal := Copy(TS[0], Pos(';', TS[0]) + 1, Pos(';', Copy(TS[0], Pos(';', TS[0]) + 1, Length(TS[0]))) - 1);
      CASE i OF
        1:
          BEGIN
            // coll
            IF UpperCase(sData) <> 'COLLECTION' THEN
            BEGIN
              // Erreur
              iCOL_ID := 0;
              LogAction('Erreur - Le fichier ne commence pas par le mot COLLECTION', True);
            END
            ELSE BEGIN
              iCOL_ID := GetOrInsertCollection(sVal);
              sCOLNOM := sVal;
            END;

            IF iCOL_ID = 0 THEN
            BEGIN
              LogAction('Erreur - Erreur lors de la lecture de la collection', True);
              // Erreur à traiter, collection impossible à ajouter
              Result := False;
              sCOLNOM := '';
              // Fin de boucle
              EXIT;
            END;
          END;
        4:
          BEGIN
            // Marque
            sMRKNOM := UpperCase(sVal);
            IF NOT GetFouID(sVal, iFOU_ID, iMRK_ID) THEN
            BEGIN
              LogAction('Erreur - Erreur lors de la lecture du fournisseur', True);
              // Erreur à traiter, collection impossible à ajouter
              Result := False;
              // Fin de boucle
              EXIT;
            END;
          END;
        7:
          BEGIN
            // 7èeme ligne, si on a excel, on doit trouver le mot 'Totale' au début, si ce n'est pas le cas, c'est qu'on est sous open office
            // et donc, on ne vire pas la ligne, et donc, on sort simplement de la boucle
            IF Pos('totale',sData) <= 0 THEN
            BEGIN
              BREAK;
            END;
          END;
      ELSE
        BEGIN
        END;
      END;
      TS.Delete(0);
    END;

    // il y'a eu une erreur dans le traitement de l'entete, on annule tout.
    IF bErreurFatale THEN
    BEGIN
      EXIT;
    END;

    LogAction('*****************************');
    LogAction('Collection lue : COL_NOM=' + sCOLNOM + ',COL_ID=' + inttostr(iCOL_ID));
    LogAction('Marque lue : MRK_NOM=' + sMRKNOM + ', FOU_ID=' + inttostr(iFOU_ID));
    LogAction('*****************************');
    LogAction('');


    TS.Insert(0, MyEntete);
    TS.SaveToFile(ChangeFileExt(sPathFic, '.tmp'));

    sARTNOM := '';
    // Chargement du memdata
    Memd_LoadFic.LoadFromTextFile(ChangeFileExt(sPathFic, '.tmp'));

    Memd_LoadFic.First;
    // Traitement des lignes
    WHILE NOT Memd_LoadFic.Eof DO
    BEGIN

      // on traite cette ligne s'il y'a une info dans rayon et dans famille, les autres lignes sont ignorées
      IF (MemD_LoadFicRayon.AsString <> '') AND (MemD_LoadFicFamille.AsString <> '') THEN // IF 1
      BEGIN
        sCOUNOM := MemD_LoadFicCouleur.AsString;
        // Si on a pas changé d'article on ne traitera que la couleur, si on a changé d'article, on vérifiera si il existe déjà ou pas.
        IF (MemD_LoadFicNom.AsString <> '') OR (MemD_LoadFicRef.AsString <> '') THEN // IF 2
        BEGIN
          IF sARTNOM <> '' THEN
          BEGIN
            LogAction('Fin du traitement de l''article : ' + sREFMRK + '-' + sARTNOM);
            LogAction('');
          END;

          // petit correction, si le nom de l'article ne termine pas par la collection, on l'ajoute
          sARTNOM := MemD_LoadFicNom.AsString;
          IF copy(sARTNOM, Length(sARTNOM) - Length(sCOLNOM) + 1, Length(sCOLNOM)) <> sCOLNOM THEN
            sARTNOM := MemD_LoadFicNom.AsString + ' ' + sCOLNOM;

          sREFMRK := MemD_LoadFicRef.AsString;

          LogAction('Traitement de l''article : ' + sREFMRK + '-' + sARTNOM);

          // le GENRE,
          //   ->
          iGRE_ID := GetGenre(MemD_LoadFicGenre.AsString);
          IF iGRE_ID = 0 THEN
          BEGIN
            Result := False;
            LogAction('  -> Genre incorrect, arrêt de la procédure', True);
            EXIT;
          END;


          // On a changé d'article
          iResFct := ArfArtIDExists(iART_ID, iARF_ID, iGRE_ID, sMRKNOM, sREFMRK, sARTNOM);
          IF iResFct = -1 THEN
          BEGIN
            // Erreur
            LogAction('  -> Erreur sur l''article ' + sARTNOM, True);
            Result := False;
            EXIT;
          END;

          IF iResFct = 0 THEN
          BEGIN
            // non trouvé, on passe en mode ajout.
            // On doit traiter :

            // La SSF
            //   ->
            iSSF_ID := GetNLK(MemD_LoadFicRayon.AsString, MemD_LoadFicFamille.AsString, MemD_LoadFicSSFamille.AsString, sARTNOM);
            IF iSSF_ID = 0 THEN
            BEGIN
              LogAction('  -> Sous-Famille incorrecte, arrêt de la procédure', True);
              Result := False;
              EXIT;
            END;

            // Le GTF
            //   ->
            stGTF := GetGTF(iSSF_ID, iMRK_ID, iGRE_ID, sARTNOM);
            IF stGTF.iId = 0 THEN
            BEGIN
              LogAction('  -> Grille de taille incorrecte, arrêt de la procédure', True);
              Result := False;
              EXIT;
            END;

            // Ok, on a toutes les infos maintenant
            // On peut créer l'article
            Que_ArticleCre.Close;
            Que_ArticleCre.ParamByName('ARTNOM').AsString := sARTNOM;
            Que_ArticleCre.ParamByName('MRKID').AsInteger := iMRK_ID;
            Que_ArticleCre.ParamByName('REFMRK').AsString := sREFMRK;
            Que_ArticleCre.ParamByName('SSFID').AsInteger := iSSF_ID;
            Que_ArticleCre.ParamByName('GTFID').AsInteger := stGTF.iId;
            Que_ArticleCre.ParamByName('GREID').AsInteger := iGRE_ID;
            Que_ArticleCre.ParamByName('COLID').AsInteger := iCOL_ID;
            Que_ArticleCre.ParamByName('DFLT_TCTID').AsInteger := MemD_ParamsTCT_ID.AsInteger;
            Que_ArticleCre.ParamByName('DFLT_TVAID').AsInteger := MemD_ParamsTVA_ID.AsInteger;
            Que_ArticleCre.ParamByName('TTYPE').AsInteger := stGTF.iType;

            TRY
              Que_ArticleCre.IB_Transaction.StartTransaction;
              Que_ArticleCre.Open;
              IF Que_ArticleCre.FieldByName('ARTID').AsInteger > 0 THEN
              BEGIN
                // Ok, on récup ARTID ARFID
                iART_ID := Que_ArticleCre.FieldByName('ARTID').AsInteger;
                iARF_ID := Que_ArticleCre.FieldByName('ARFID').AsInteger;
                sChrono := Que_ArticleCre.FieldByName('ARFCHRONO').AsString;
                Que_ArticleCre.Close;

                LogAction('  -> Ajout de l''article : (' + sChrono + ') ' + sARTNOM);

                Que_ArticleCre.IB_Transaction.Commit;
              END
              ELSE BEGIN
                // Erreur
                Que_ArticleCre.IB_Transaction.Rollback;
                LogAction('  -> Erreur à la création de l''article', True);
                Result := False;
                EXIT;
              END;
            EXCEPT
              ON E: Exception DO
              BEGIN
                Que_ArticleCre.IB_Transaction.Rollback;
                LogAction('  -> Erreur à la création de l''article : ' + E.Message, True);
                Result := False;
                EXIT;
              END;
            END;

          END
          ELSE BEGIN
            // Article trouvé, on ne fait rien
            LogAction('  -> Article déjà existant : ' + sARTNOM);
          END;

          SetCol(iART_ID, iCOL_ID);

          SetPV(iART_ID, MemD_LoadFicPxVte.AsString);

          SetPA(iART_ID, iFOU_ID, MemD_LoadFicPA.AsString, MemD_LoadFicRemise.AsString);

        END; // Fin IF 2


        // Création de la couleur (si inexistante)
        IbC_CoulCre.Close;
        IbC_CoulCre.ParamByName('ARTID').AsInteger := iART_ID;
        IbC_CoulCre.ParamByName('ARFID').AsInteger := iARF_ID;
        IbC_CoulCre.ParamByName('GTFID').AsInteger := stGTF.iId;
        IbC_CoulCre.ParamByName('COUNOM').AsString := sCOUNOM;
        IbC_CoulCre.ParamByName('TTYPE').AsInteger := stGTF.iType;

        TRY
          IbC_CoulCre.IB_Transaction.StartTransaction;
          IbC_CoulCre.Open;
          IF IbC_CoulCre.Fields[0].AsInteger > 0 THEN
          BEGIN
            IbC_CoulCre.Close;
            LogAction('  -> Couleur traitée : ' + sCOUNOM);
            IbC_CoulCre.IB_Transaction.Commit;
          END
          ELSE BEGIN
            // Erreur
            IbC_CoulCre.IB_Transaction.Rollback;
            Result := False;
            LogAction('  -> Erreur à la création de la couleur', True);
            EXIT;
          END;
        EXCEPT
          ON E: Exception DO
          BEGIN
            IbC_CoulCre.IB_Transaction.Rollback;
            Result := False;
            LogAction('  -> Erreur à la création de la couleur', True);
            EXIT;
          END;
        END;


      END; // Fin IF 1
      Memd_LoadFic.Next;
    END; // Fin while

    IF sARTNOM <> '' THEN
    BEGIN
      LogAction('Fin du traitement de l''article : (' + sREFMRK + ') ' + sARTNOM);
      LogAction('');
    END;
    Result := True;
  END
  ELSE BEGIN
    bErreurFatale := True;
  END;

  if bErreurFatale then
    LogAction('Une erreur fatale est survenue');
END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
BEGIN
  bClosing := True;

  MyIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  InitParam();

  // MAJ Auto
  DoMAJ();

  Pgc_Main.ActivePageIndex := 0;

  // pour tests
//  Chp_PathCSV.Text := 'c:\temp';

END;

PROCEDURE TFrm_Main.Nbt_SelectFolderClick(Sender: TObject);
BEGIN
  WITH RepDlg_SelectFolder DO
  BEGIN
    IF Execute THEN
    BEGIN
      Chp_PathCSV.Text := SelectedFolder.PathName;
      // sauvegarde auto dans l'ini
      MyIniFile.WriteString('IMPORT', 'PATH', Chp_PathCSV.Text);
    END;
  END;
END;

PROCEDURE TFrm_Main.ListerFichier;
VAR
  MyFile: TSearchRec;
  ErrCode: Integer;
BEGIN
  Lbx_Files.clear;
  IF Chp_PathCSV.Text <> '' THEN
  BEGIN
    // On cherche le premier fichier texte
    ErrCode := FindFirst(IncludeTrailingBackSlash(Chp_PathCSV.text) + '*.csv', faAnyFile, MyFile);

    WHILE ErrCode = 0 DO
    BEGIN
      IF (MyFile.Name <> '.') AND (MyFile.Name <> '..') THEN
      BEGIN
        // On utilise le resultat
        Lbx_Files.Items.Add(MyFile.Name);
        Lbx_Files.Checked[Lbx_Files.items.count - 1] := False;

        //        CheckListBox1.Items.Add(MyFile.Name);

      END;
      // On passe au fichier suivant
      ErrCode := FindNext(MyFile);

    END;

    IF Lbx_Files.Items.Count > 0 THEN
    BEGIN
      // On affiche la liste
      Lab_ListeFichiers.Caption := 'Liste des fichiers : ';
      Gax_Files.Visible := true;
    END
    ELSE
    BEGIN
      Lab_ListeFichiers.Caption := 'Aucun fichier dans ce dossier (' + Chp_PathCSV.Text + ')';
      Gax_Files.Visible := False;
    END;
  END
  ELSE
  BEGIN
    Lab_ListeFichiers.Caption := 'Aucun fichier dans ce dossier (' + Chp_PathCSV.Text + ')';
    Gax_Files.Visible := False;
  END;
END;

PROCEDURE TFrm_Main.Nbt_CheckAllClick(Sender: TObject);
VAR
  i: integer;
BEGIN
  FOR i := 0 TO (Lbx_Files.Items.Count - 1) DO
  BEGIN
    Lbx_Files.Checked[i] := True;
  END;
END;

PROCEDURE TFrm_Main.ParamSave(Sender: TObject);
BEGIN
  IF bClosing THEN
    EXIT;

  // Sauvegarde des paramètres

  // sauvegarde des données saisies
  MyIniFile.WriteString('BD_GINKOIA', 'PATH', Chp_PathDB.Text);
  MyParams.sDBGinkoia := Chp_PathDB.Text;

  MyIniFile.WriteString('IMPORT', 'PATH', Chp_PathCSV.Text);

  MyIniFile.WriteInteger('IMPORT', 'TCTID', MemD_ParamsTCT_ID.AsInteger);
  MyIniFile.WriteInteger('IMPORT', 'TVAID', MemD_ParamsTVA_ID.AsInteger);
  MyIniFile.WriteInteger('IMPORT', 'SECID', MemD_ParamsSEC_ID.AsInteger);

  MyIniFile.WriteBool('OPTIONS', 'LOGACTIF', Chp_ActiveLog.Checked);
  MyParams.bLogActif := Chp_ActiveLog.Checked;
  initLogFileName(Memo_Log, NIL, MyParams.bLogActif);

END;


PROCEDURE TFrm_Main.InitParam;
BEGIN

  // Activation des logs
  MyParams.bLogActif := MyIniFile.ReadBool('OPTIONS', 'LOGACTIF', True);
  Chp_ActiveLog.Checked := MyParams.bLogActif;
  initLogFileName(Memo_Log, NIL, MyParams.bLogActif);

  MemD_LoadFic.DelimiterChar := ';';

  MyParams.sDBExport := IncludeTrailingBackSlash(ExtractFilePath(Application.Exename)) + 'Correspondance.ib';

  MyParams.sDBGinkoia := MyIniFile.ReadString('BD_GINKOIA', 'PATH', '');
  Chp_PathDB.Text := MyParams.sDBGinkoia;
  DBReconnect();


  Chp_PathCSV.Text := MyIniFile.ReadString('IMPORT', 'PATH', '');

  RepDlg_SelectFolder.SelectedFolder.PathName := Chp_PathCSV.Text;


  MemD_Params.Close;
  MemD_Params.Open;
  MemD_Params.Append;

  MemD_ParamsTCT_ID.AsInteger := MyIniFile.ReadInteger('IMPORT', 'TCTID', 0);
  MemD_ParamsTVA_ID.AsInteger := MyIniFile.ReadInteger('IMPORT', 'TVAID', 0);
  MemD_ParamsSEC_ID.AsInteger := MyIniFile.ReadInteger('IMPORT', 'SECID', 0);


END;

PROCEDURE TFrm_Main.FormDestroy(Sender: TObject);
BEGIN
  MyIniFile.Free;
  Grd_Close.Close;
  BaseGinkoia.Close;
  BaseCorrespondance.Close;
END;

PROCEDURE TFrm_Main.Chp_PathCSVChange(Sender: TObject);
BEGIN
  ListerFichier();

END;

PROCEDURE TFrm_Main.Nbt_ChargerFichierClick(Sender: TObject);
VAR
  TS: TStrings;
  i: integer;
  sFic: STRING;
BEGIN
  TS := TStringList.Create;
  TRY
    Screen.Cursor := crHourGlass;
    Frm_Main.Enabled := False;
    // sauvegarde auto dans l'ini
    MyIniFile.WriteString('IMPORT', 'PATH', Chp_PathCSV.Text);
    FOR i := 0 TO (Lbx_Files.Items.Count - 1) DO
    BEGIN
      IF Lbx_Files.Checked[i] THEN
      BEGIN
        sFic := includeTrailingBackSlash(Chp_PathCSV.Text) + Lbx_Files.Items[i];
        LogAction('**********************************************************************');
        LogAction('Début du fichier : ' + sFic);
        LogAction('**********************************************************************');
        LogAction('');
        TS.Clear;
        IF TraiterFichier(sFic, TS) THEN
        BEGIN
          LogAction('**********************************************************************');
          LogAction('Fin du fichier : ' + sFic);
          LogAction('**********************************************************************');
          LogAction('');
        END
        ELSE BEGIN
          LogAction('**********************************************************************');
          LogAction('Erreur lors du traitement du fichier : ' + sFic);
          LogAction('*******                  Abandon du traitement                   *****');
          LogAction('**********************************************************************');
          LogAction('');
          BREAK;
        END;
      END;
    END;
  FINALLY
    TS.Free;
    Screen.Cursor := crDefault;
    Frm_Main.Enabled := True;

  END;
END;

FUNCTION TFrm_Main.GetNewK(NomTable: STRING): Integer;
BEGIN
  Result := 0;

  IbC_NewK.Close;
  TRY
    IbC_NewK.ParamByName('TBLNAME').AsString := NomTable;
    IbC_NewK.Open;
    IF IbC_NewK.Fields[0].AsInteger > 0 THEN
    BEGIN
      Result := IbC_NewK.Fields[0].AsInteger;
    END
    ELSE BEGIN
      LogAction('  -> Impossible de créer le K sur la table : ' + NomTable);
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      LogAction('  -> Exception sur création du K sur la table ' + NomTable + ' : ' + E.Message);
    END;
  END;
  IbC_NewK.Close;
END;

FUNCTION TFrm_Main.GetOrInsertCollection(sNomColl: STRING): integer;
VAR
  iID: integer;
BEGIN
  iID := 0;
  // si la collection n'existe pas, on la crée
  IbC_Select.SQL.Text := 'SELECT MIN(COL_ID) FROM ARTCOLLECTION JOIN K ON (K_ID = COL_ID AND K_ENABLED = 1) WHERE COL_NOM=' + QuotedStr(UpperCase(sNomColl));
  IbC_Select.Open;
  IF IbC_Select.Fields[0].AsInteger <> 0 THEN
  BEGIN
    // on a trouvé une collection, on stocke l'id pour plus tard
    iID := IbC_Select.Fields[0].AsInteger;
  END
  ELSE BEGIN
    IbT_Insert.StartTransaction;
    TRY
      iID := GetNewK('ARTCOLLECTION');
      IF iID <= 0 THEN
      BEGIN
        iID := 0;
        IbT_Insert.Rollback;
      END
      ELSE BEGIN
        IbC_Insert.SQL.Clear;
        IbC_Insert.SQL.Add('INSERT INTO ARTCOLLECTION (');
        IbC_Insert.SQL.Add('COL_ID, COL_NOM, COL_NOVISIBLE, COL_REFDYNA');
        IbC_Insert.SQL.Add(') VALUES (');
        IbC_Insert.SQL.Add(IntToStr(iID) + ',' + QuotedStr(UpperCase(sNomColl)) + ',0,0)');
        IbC_Insert.ExecSQL;
        IbC_Insert.Close;
        LogAction('  -> Collection créée : ' + sNomColl + ' (ID=' + IntToStr(iID) + ')');
        IbT_Insert.Commit;
      END;

    EXCEPT
      ON E: Exception DO
      BEGIN
        IbT_Insert.Rollback;
        LogAction('  -> Exception sur la création de la collection : ' + E.Message);
        iID := 0;
      END;
    END;
  END;
  result := iID;
END;

FUNCTION TFrm_Main.GetFouID(sNomMrk: STRING; VAR iFOU_ID, iMRK_ID: integer): boolean;
BEGIN
  IbC_Select.SQL.Clear;
  IbC_Select.SQL.Add('  SELECT FMK_MRKID, MIN (FMK_FOUID)');
  IbC_Select.SQL.Add('    FROM ARTMARQUE');
  IbC_Select.SQL.Add('         JOIN K ON (K_ID = MRK_ID AND K_ENABLED = 1)');
  IbC_Select.SQL.Add('         JOIN ARTMRKFOURN ON (MRK_ID=FMK_MRKID AND FMK_PRIN = 1)');
  IbC_Select.SQL.Add('   WHERE MRK_NOM = ' + QuotedStr(UpperCase(sNomMrk)));
  IbC_Select.SQL.Add('   GROUP BY FMK_MRKID');

  IbC_Select.Open;
  IF IbC_Select.RecordCount = 1 THEN
  BEGIN
    // on a trouvé le fournisseur, on stocke l'id pour plus tard
    iMRK_ID := IbC_Select.Fields[0].AsInteger;
    iFOU_ID := IbC_Select.Fields[1].AsInteger;
    result := True;
  END
  ELSE BEGIN
    // Erreur
    result := false;
    LogAction('  -> Impossible de trouver le fournisseur pour la marque : ' + sNomMrk);
  END;

END;

FUNCTION TFrm_Main.ArfArtIDExists(VAR iARTID: integer; VAR iARFID: integer; iGRE_ID: integer; sNomMrk, sRef, sNom: STRING): integer;

BEGIN
  Que_GetArticle.Close;
  Que_GetArticle.ParamByName('MRKNOM').AsString := sNomMrk;
  Que_GetArticle.ParamByName('REF').AsString := sRef;
  Que_GetArticle.ParamByName('NOM').AsString := sNom;
  Que_GetArticle.ParamByName('GREID').AsInteger := iGRE_ID;
  TRY
    Que_GetArticle.Open;
    CASE Que_GetArticle.RecordCount OF
      0:
        BEGIN
          // Erreur
          iARTID := 0;
          iARFID := 0;
          LogAction('  -> Impossible de trouver l''article : ' + sRef + '-' + sNom + ', Création...');
          Result := 0;
        END;

      1:
        BEGIN
          // on a trouvé l'article, on stocke l'id pour plus tard
          WITH Que_GetArticle DO
          BEGIN
            iARTID := Que_GetArticle.FieldByName('ART_ID').AsInteger;
            iARFID := Que_GetArticle.FieldByName('ARF_ID').AsInteger;
            LogAction('  -> Acticle trouvé : (' + FieldByName('ARF_CHRONO').AsString + ') ' + FieldByName('ART_REFMRK').AsString + '-' + FieldByName('ART_NOM').AsString);
          END;
          Result := 1;
        END
    ELSE
      BEGIN
        // On en a trouvé plusieurs, on demande
        IF LK_GetArticle.Execute THEN
        BEGIN
          WITH Que_GetArticle DO
          BEGIN
            // on a trouvé l'article, on stocke l'id pour plus tard
            iARTID := FieldByName('ART_ID').AsInteger;
            iARFID := FieldByName('ARF_ID').AsInteger;

            // ART_NOM, ART_REFMRK, ARF_CHRONO
            LogAction('  -> Acticle choisi par utilisateur : (' + FieldByName('ARF_CHRONO').AsString + ') ' + FieldByName('ART_REFMRK').AsString + '-' + FieldByName('ART_NOM').AsString);
          END;
          Result := 1;
        END
        ELSE BEGIN
          LogAction('  -> Erreur lors de la recherche de l''article : Annulé par l''utilisateur');
          iARTID := 0;
          iARFID := 0;
          Result := 0;
        END;
      END;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      iARTID := -1;
      iARFID := -1;
      Result := -1;
      LogAction('  -> Erreur lors de la recherche de l''article : ' + sNom + ' (' + sRef + ')');
    END;
  END;
END;



FUNCTION TFrm_Main.GetGenre(sGenre: STRING): Integer;
VAR
  iID: integer;
BEGIN
  iID := 0;

  // si le genre n'existe pas, on le demande
  IbC_Select.SQL.Text := 'SELECT MIN(GRE_ID) FROM ARTGENRE JOIN K ON (K_ID = GRE_ID AND K_ENABLED = 1) WHERE GRE_NOM=' + QuotedStr(UpperCase(sGenre));
  IbC_Select.Open;
  IF IbC_Select.Fields[0].AsInteger <> 0 THEN
  BEGIN
    // on a trouvé un genre, on stocke l'id pour plus tard
    iID := IbC_Select.Fields[0].AsInteger;
    LogAction('  -> Genre trouvé dans la base : ' + sGenre);
  END
  ELSE BEGIN
    TRY
      LK_Genre.Caption := 'Genre non trouvé : ' + sGenre;
      // on le demande du coup, si on a l'a pas trouvé
      IF LK_Genre.Execute THEN
      BEGIN
        iID := Que_LkGenre.FieldByName('GRE_ID').AsInteger;
        LogAction('  -> Genre choisi par l''utilisateur : ' + Que_LKGenre.FieldByName('GRE_NOM').AsString);
      END
      ELSE BEGIN
        iID := 0;
        LogAction('  -> Action annulée par l''utilisateur');
      END;

    EXCEPT
      ON E: Exception DO
      BEGIN
        LogAction('  -> Exception lors de la sélection du genre : ' + E.Message);
        iID := 0;
      END;
    END;
  END;
  result := iID;
END;

FUNCTION TFrm_Main.GetNLK(sRAY_NOM, sFAM_NOM, sSSF_NOM, sARTNOM: STRING): Integer;
VAR
  RAY_ID, FAM_ID, SSF_ID: integer;
  iID: integer;
  bAsk: boolean;
BEGIN
  iID := 0;

  // si le genre n'existe pas, on le demande
//  IbC_Select.SQL.Text := Copy(Que_NKL.SQL.Text,0,Length(Que_NKL.SQL.Text)-1);
  Que_NKL.Close;
  Que_NKL.ParamByName('RAYNOM').AsString := sRAY_NOM;
  Que_NKL.ParamByName('FAMNOM').AsString := sFAM_NOM;
  Que_NKL.ParamByName('SSFNOM').AsString := sSSF_NOM;
  Que_NKL.ParamByName('SECID').AsInteger := MemD_ParamsSEC_ID.AsInteger;
  Que_NKL.Open;
  IF Que_NKL.RecordCount = 1 THEN
  BEGIN

    // on a trouvé un genre, on stocke l'id pour plus tard
    iID := Que_NKL.FieldByName('SSF_ID').AsInteger;
    logaction('  -> Nomenclature trouvée : ' + sRAY_NOM + '/' + sFAM_NOM + '/' + ' - ' + inttostr(Que_NKL.RecordCount));
  END
  ELSE BEGIN
    bAsk := True;
    IF Que_NKL.RecordCount > 1 THEN
    BEGIN
      IF LK_NKL.Execute THEN
      BEGIN
        bAsk := False;
        iId := Que_NKL.FieldByName('SSF_ID').AsInteger;
        Logaction('  -> Choix utilisateur : ' + Que_NKL.FieldByName('SEC_NOM').AsString + '/' + Que_NKL.FieldByName('RAY_NOM').AsString + '/' + Que_NKL.FieldByName('FAM_NOM').AsString + '/' + Que_NKL.FieldByName('SSF_NOM').AsString + ' - ' + inttostr(Que_NKL.RecordCount));
      END;
    END;

    IF bAsk THEN
    BEGIN
      TRY
        // demander
        LogAction('  -> Nomenclature innexistante : ' + sRAY_NOM + '/' + sFAM_NOM + '/' + sSSF_NOM + ' - ' + inttostr(Que_NKL.RecordCount));

        IF ChoixNomenk(RAY_ID, FAM_ID, SSF_ID, sRAY_NOM, sFAM_NOM, sSSF_NOM, sRAY_NOM + '/' + sFAM_NOM + '/' + sSSF_NOM, sARTNOM, StrToInt(Chp_Secteur.Text)) THEN
        BEGIN
          logaction('  -> Choix utilisateur : ' + sRAY_NOM + '/' + sFAM_NOM + '/' + sSSF_NOM + ' - ' + inttostr(Que_NKL.RecordCount));
          iID := SSF_ID;
        END
        ELSE BEGIN
          iID := 0;
          LogAction('  -> Choix nomenclature annulé par l''utilisateur');
        END;
      EXCEPT
        ON E: Exception DO
        BEGIN
          LogAction('  -> Exception lors de la sélection de la sous-famille : ' + E.Message);
          iID := 0;
        END;
      END;
    END;
  END;
  result := iID;
END;



FUNCTION TFrm_Main.GetGTF(iSSFID, iMRKID, iGREID: integer; AArtNOM: STRING): tTaille;
BEGIN
  Result.iId := 0;
  Result.iType := 0;

  IbC_CorrespGTF.Close;
  IbC_CorrespGTF.ParamByName('MRKID').AsInteger := iMRKID;
  IbC_CorrespGTF.ParamByName('SSFID').AsInteger := iSSFID;
  IbC_CorrespGTF.ParamByName('GREID').AsInteger := iGREID;
  IbC_CorrespGTF.Open;
  IF IbC_CorrespGTF.Fields[0].AsInteger > 0 THEN
  BEGIN
    Result.iId := IbC_CorrespGTF.Fields[0].AsInteger;
    Result.iType := IbC_CorrespGTF.Fields[1].AsInteger;
  END
  ELSE BEGIN
    // on a pas trouvé de GTFID, on demande
    Result := ChoixGTF(iSSFID, iGreId, AArtNOM);
    IF Result.iId > 0 THEN
    BEGIN
      //      LogAction('  -> Insertion dans la base de correspondance');
      IbC_InsCorGTF.Close;
      IbC_InsCorGTF.ParamByName('NKT_ID').AsInteger := 0;
      IbC_InsCorGTF.ParamByName('NKT_SSFID').AsInteger := iSSFID;
      IbC_InsCorGTF.ParamByName('NKT_MRKID').AsInteger := iMRKID;
      IbC_InsCorGTF.ParamByName('NKT_GTFID').AsInteger := Result.iId;
      IbC_InsCorGTF.ParamByName('NKT_TTYPE').AsInteger := Result.iType;
      IbC_InsCorGTF.ParamByName('NKT_GREID').AsInteger := iGREID;
      TRY
        IbC_InsCorGTF.IB_Transaction.StartTransaction;
        IbC_InsCorGTF.ExecSQL;
        IbC_InsCorGTF.Close;
        IbC_InsCorGTF.IB_Transaction.Commit;
      EXCEPT
        ON E: Exception DO
        BEGIN
          IbC_InsCorGTF.IB_Transaction.Rollback;
          LogAction('  -> Erreur lors de l''insertion dans la base de correspondance GTF_ID=' + inttostr(Result.iId) + ', MRK_ID=' + inttostr(iMRKID) + ', SSFID=' + inttostr(iSSFID));
          Result.iId := 0;
          Result.iType := 0;
        END;
      END;

      // on stock dans la bdd de corresp du coup
    END
    ELSE BEGIN
      // on sort avec erreur
      LogAction('  -> Choix grille de tailles abandonné par l''utilisteur');
      Result.iId := 0;
      Result.iType := 0;
    END;
  END;
  IbC_CorrespGTF.Close;
END;

FUNCTION TFrm_Main.SetPA(iARTID, iFOU_ID: integer; sPxA, sRemise: STRING): boolean;
VAR
  dPxA, dRemise, dPxAR: double;
  iCLG_ID: integer;
  iK : integer;
BEGIN
  // conversion du PA
  TRY
{    dPxAR := StrToFloat(Trim(StringReplace(sPxA, '€', '', [rfReplaceAll])));
    dRemise := StrToFloat(Trim(StringReplace(sRemise, '%', '', [rfReplaceAll])));
    IF dRemise <> 100 THEN
      dPxA := (dPxAR * 100) / (100 - dRemise);}
    // FC 22/12/2008 changement : le prix dans le fichier excel est le prix brut, et non le prix net
    // Changement de la méthode de calcul donc
    // Prix d'achat brut dans le fichier
    IF sPxA = '' THEN
      dPxA := 0
    ELSE
      dPxA := StrToFloat(Trim(StringReplace(sPxA, '€', '', [rfReplaceAll])));
    // Remise dans le fichier
    IF sRemise = '' THEN
      dRemise := 0
    ELSE
      dRemise := StrToFloat(Trim(StringReplace(sRemise, '%', '', [rfReplaceAll])));
      
    // Prix d'achat remisé = Px Nego
    dPxAR := dPxA * ((100 - dRemise)/100);

  EXCEPT
    ON E: Exception DO
    BEGIN
      Logaction('  -> Erreur conversion PxAchat' + e.message);
      dPxAR := 0;
      dPxA := 0;
      dRemise := 0;
    END;
  END;
  IF dPxA >= 0 THEN
  BEGIN
    // Mise à jour du PxA (TARCLGFOURN)
    IbC_Select.Close;
    IbC_Select.SQL.Clear;
    IbC_Select.SQL.Add('SELECT MIN(CLG_ID)');
    IbC_Select.SQL.Add('  FROM TARCLGFOURN');
    IbC_Select.SQL.Add('       JOIN K ON (K_ID = CLG_ID AND K_ENABLED = 1)');
    IbC_Select.SQL.Add(' WHERE CLG_FOUID = ' + IntToStr(iFOU_ID));
    IbC_Select.SQL.Add('   AND CLG_TGFID = 0');
    IbC_Select.SQL.Add('   AND CLG_ARTID = ' + IntToStr(iARTID));
    IbC_Select.SQL.Add('   AND CLG_PRINCIPAL = 1');
    IbC_Select.Open;

    iCLG_ID := IbC_Select.Fields[0].AsInteger;
    IF iCLG_ID = 0 THEN
    BEGIN
      iCLG_ID := GetNewK('TARCLGFOURN');

      // création du prix d'achat
      IbC_Insert.Close;
      IbC_Insert.SQL.Clear;
      IbC_Insert.SQL.Add('INSERT INTO TARCLGFOURN');
      IbC_Insert.SQL.Add('(CLG_ID, CLG_ARTID, CLG_FOUID, ');
      IbC_Insert.SQL.Add(' CLG_TGFID, CLG_PX, CLG_PXNEGO, CLG_PRINCIPAL)');
      IbC_Insert.SQL.Add('VALUES');
      IbC_Insert.SQL.Add('(' + IntToStr(iCLG_ID) + ',' + IntToStr(iARTID) + ',' + IntToStr(iFOU_ID));
      IbC_Insert.SQL.Add(',0,:PXA,:PXR, 1)');

      IbC_Insert.ParamByName('PXA').AsFloat := dPxA;
      IbC_Insert.ParamByName('PXR').AsFloat := dPxAR;

      IbC_Insert.IB_Transaction.StartTransaction;
      TRY
        IbC_Insert.ExecSQL;
        IbC_Insert.Close;
        LogAction('  -> Prix d''achat crée : ' + sPxA);
        IbC_Insert.IB_Transaction.Commit;
      EXCEPT
        LogAction('  -> Erreur création prix d''achat : ' + sPxA);
        IbC_Insert.IB_Transaction.Rollback;
      END;
    END
    ELSE BEGIN
      // Maj du prix d'achat
      IbC_Insert.Close;
      IbC_Insert.SQL.Clear;
      IbC_Insert.SQL.Add('UPDATE TARCLGFOURN');
      IbC_Insert.SQL.Add('SET  ');
      IbC_Insert.SQL.Add('    CLG_PX=:PXA');
      IbC_Insert.SQL.Add('  , CLG_PXNEGO=:PXR');
      IbC_Insert.SQL.Add(' WHERE CLG_ID=' + IntToStr(iCLG_ID));

      IbC_Insert.ParamByName('PXA').AsFloat := dPxA;
      IbC_Insert.ParamByName('PXR').AsFloat := dPxAR;

      LogAction('  -> Prix d''achat mis à jour : ' + sPxA);

      IbC_Insert.IB_Transaction.StartTransaction;
      TRY
        IbC_Insert.ExecSQL;
        IbC_Insert.Close;
        IbC_Insert.IB_Transaction.Commit;
      EXCEPT
        IbC_Insert.IB_Transaction.Rollback;
      END;

      // Maj du K
      IbC_Insert.Close;
      IbC_Insert.SQL.Clear;
      IbC_Insert.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:K_ID,0)');
      IbC_Insert.ParamByName('K_ID').AsFloat := iCLG_ID;

      LogAction('  -> Prix d''achat : K mouvementé');

      IbC_Insert.IB_Transaction.StartTransaction;
      TRY
        IbC_Insert.ExecSQL;
        IbC_Insert.Close;
        IbC_Insert.IB_Transaction.Commit;
      EXCEPT
        IbC_Insert.IB_Transaction.Rollback;
      END;

    END;
  END;
END;

FUNCTION TFrm_Main.SetPV(iARTID: integer; sPxV: STRING): boolean;
VAR
  dPxV: double;

BEGIN
  // conversion du PV
  TRY
    dPxV := StrToFloat(Trim(StringReplace(sPxV, '€', '', [rfReplaceAll])));
  EXCEPT
    ON E: Exception DO
    BEGIN
      Logaction('  -> Erreur conversion PxVente' + e.message);
      dPxV := 0;
    END;
  END;
  IF dPxV >= 0 THEN
  BEGIN
    // Mise à jour du PV si inexistant (TARPRIXVENTE)
    IbC_Select.Close;
    IbC_Select.SQL.Clear;
    IbC_Select.SQL.Add('SELECT COUNT (*)');
    IbC_Select.SQL.Add('  FROM TARPRIXVENTE');
    IbC_Select.SQL.Add('       JOIN K ON (K_ID = PVT_ID AND K_ENABLED = 1)');
    IbC_Select.SQL.Add(' WHERE PVT_TVTID = 0');
    IbC_Select.SQL.Add('   AND PVT_TGFID = 0');
    IbC_Select.SQL.Add('   AND PVT_ARTID =' + IntToStr(iARTID));
    IbC_Select.Open;
    IF IbC_Select.Fields[0].AsInteger = 0 THEN
    BEGIN
      // Maj du prix de vente
      IbC_Insert.Close;
      IbC_Insert.SQL.Clear;
      IbC_Insert.SQL.Add('INSERT INTO TARPRIXVENTE');
      IbC_Insert.SQL.Add('(PVT_ID, PVT_TVTID, PVT_ARTID, PVT_TGFID, PVT_PX) ');
      IbC_Insert.SQL.Add('VALUES');
      IbC_Insert.SQL.Add('(' + IntToStr(GetNewK('TARPRIXVENTE')) + ',0,' + IntToStr(iARTID) + ',0,:PXV)');

      IbC_Insert.ParamByName('PXV').AsFloat := dPxV;

      LogAction('  -> Prix de vente crée : ' + sPxV);

      IbC_Insert.IB_Transaction.StartTransaction;
      TRY
        IbC_Insert.ExecSQL;
        IbC_Insert.Close;
        IbC_Insert.IB_Transaction.Commit;
      EXCEPT
        IbC_Insert.IB_Transaction.Rollback;
      END;

    END
    ELSE BEGIN
      LogAction('  -> Prix de vente déjà existant, prix ignoré');
    END;
  END;
END;


FUNCTION TFrm_Main.SetCOL(iARTID, iCOLID: integer): boolean;
BEGIN
  // Vérif attibution de la collection
  IbC_Select.SQL.Text := 'SELECT COUNT(*) FROM ARTCOLART JOIN K ON (K_ID=CAR_ID AND K_ENABLED=1) WHERE CAR_COLID=:COLID AND CAR_ARTID=:ARTID';
  IbC_Select.ParamByName('ARTID').AsInteger := iARTID;
  IbC_Select.ParamByName('COLID').AsInteger := iCOLID;
  IbC_Select.Open;
  IF IbC_Select.Fields[0].AsInteger = 0 THEN
  BEGIN
    TRY
      // On ajoute la collection
      IbC_Insert.SQL.Text := 'INSERT INTO ARTCOLART (CAR_ID, CAR_ARTID, CAR_COLID) VALUES (:CAR_ID, :CAR_ARTID, :CAR_COLID)';
      IbC_Insert.ParamByName('CAR_ID').AsInteger := GetNewK('ARTCOLART');
      IbC_Insert.ParamByName('CAR_ARTID').AsInteger := iARTID;
      IbC_Insert.ParamByName('CAR_COLID').AsInteger := iCOLID;
      IbC_Insert.IB_Transaction.StartTransaction;
      IbC_Insert.ExecSQL;
      IbC_Insert.Close;
      LogAction('  -> Collection ajoutée : ' + IntToStr(iCOLID));
      IbC_Insert.IB_Transaction.Commit;
    EXCEPT
      IbC_Insert.IB_Transaction.Rollback;
    END;
  END;
END;

PROCEDURE TFrm_Main.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
BEGIN
  bClosing := True;

END;

PROCEDURE TFrm_Main.FormPaint(Sender: TObject);
BEGIN
  bClosing := False;

END;

PROCEDURE TFrm_Main.Nbt_QuitClick(Sender: TObject);
BEGIN
  ParamSave(Nil);
  Close;
END;

procedure TFrm_Main.Nbt_ActualiserClick(Sender: TObject);
begin
  ListerFichier();
end;


END.

