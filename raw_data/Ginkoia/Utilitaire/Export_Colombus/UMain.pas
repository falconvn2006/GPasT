UNIT UMain;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  // Uses perso
  IniFiles, Jpeg, ShellApi,
  // Fin Uses perso
  Dialogs, ExtCtrls, RzPanel, RzPanelRv, StdCtrls, LMDCustomButton,
  LMDButton, IB_Components, Db, IBDataset, Grids, Wwdbigrd, Wwdbgrid,
  wwDBGridRv, dxmdaset, RzLabel, Mask, DBCtrls, RzDBEdit, RzDBBnEd,
  RzDBButtonEditRv, wwDialog, wwidlg, wwLookupDialogRv, wwdbedit,
  wwDBEditRv, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, wwdbdatetimepicker,
  wwDBDateTimePickerRv, RzDBLbl, RzDBLabelRv;

TYPE tParams = RECORD
    sDBExport: STRING;
    sDBGinkoia: STRING;
    sMAGGinkoia: STRING;
    sVersion: STRING;
    cSeparateur: char;
    bLogActif: boolean;
    sForbiddenChars: STRING;
    cForbidReplaceChar: char;
  END;

TYPE
  TFrm_Main = CLASS(TForm)
    Pan_Down: TRzPanelRv;
    Pan_Center: TRzPanelRv;
    Pan_Up: TRzPanelRv;
    Nbt_ExportInit: TLMDButton;
    Nbt_ExportArt: TLMDButton;
    Nbt_Quitter: TLMDButton;
    BaseGinkoia: TIB_Connection;
    BaseCorrespondance: TIB_Connection;
    Que_GetMarques: TIBOQuery;
    IbC_Generateur: TIB_Cursor;
    Ds_Controle: TDataSource;
    Que_Fournisseurs: TIBOQuery;
    IbC_GetCodePays: TIB_Cursor;
    IbT_Correspondance: TIB_Transaction;
    IbT_Ginkoia: TIB_Transaction;
    Que_Classification: TIBOQuery;
    Que_GrilleTaille: TIBOQuery;
    Que_Tailles: TIBOQuery;
    Que_Articles: TIBOQuery;
    MemD_Couleurs: TdxMemData;
    MemD_CouleursCOU_ID: TStringField;
    Pan_CriteresArt: TRzPanelRv;
    Chp_SelFourn: TRzDBButtonEditRv;
    Lab_FOU_ID: TRzLabel;
    MemD_Params: TdxMemData;
    MemD_ParamsFOU_ID: TIntegerField;
    MemD_ParamsCOL_ID: TIntegerField;
    MemD_ParamsREF_ARTICLE: TStringField;
    MemD_ParamsMRK_ID: TIntegerField;
    MemD_ParamsDateCreation: TDateField;
    MemD_ParamsDateModif: TDateField;
    MemD_ParamsRAY_ID: TIntegerField;
    MemD_ParamsFAM_ID: TIntegerField;
    MemD_ParamsSSF_ID: TIntegerField;
    LK_SelCollections: TwwLookupDialogRV;
    Que_SelCollections: TIBOQuery;
    Que_SelFourn: TIBOQuery;
    Ds_Params: TDataSource;
    MemD_ParamsFOU_NOM: TStringField;
    LK_SelFourn: TwwLookupDialogRV;
    MemD_ParamsCOL_NOM: TStringField;
    Chp_SelCollection: TRzDBButtonEditRv;
    Lab_SelCollection: TRzLabel;
    Lab_RefArt: TRzLabel;
    Chp_RefArt: TwwDBEditRv;
    Lab_Titre: TRzLabel;
    Nbt_ReinitFiltres: TLMDSpeedButton;
    Pan_RappelCriteres: TRzPanelRv;
    Pan_Rapport: TRzPanelRv;
    Pan_Logs: TRzPanelRv;
    Pan_TestGrid: TRzPanelRv;
    Dbg_Controle: TwwDBGridRv;
    Pan_CriteresClassif: TRzPanelRv;
    Memo_Log: TMemo;
    Pan_CriteresDate: TRzPanelRv;
    Chp_DateCreation: TwwDBDateTimePickerRv;
    Chp_DateModif: TwwDBDateTimePickerRv;
    Lab_DateCreation: TRzLabel;
    Lab_DateModif: TRzLabel;
    Lab_Classification: TRzLabel;
    Nbt_Classification: TLMDButton;
    Nbt_DateCreation: TLMDSpeedButton;
    Nbt_DateModif: TLMDSpeedButton;
    Nbt_RefArt: TLMDSpeedButton;
    Nbt_Fournisseur: TLMDSpeedButton;
    Nbt_Collection: TLMDSpeedButton;
    Nbt_RemClassif: TLMDButton;
    MemD_ParamsRAY_NOM: TStringField;
    MemD_ParamsFAM_NOM: TStringField;
    MemD_ParamsSSF_NOM: TStringField;
    Lab_Criteres: TRzLabel;
    Lab_ListCrit: TRzLabel;
    MemD_ParamsMRK_NOM: TStringField;
    Lab_Marque: TRzLabel;
    Chp_Marque: TRzDBButtonEditRv;
    Nbt_Marque: TLMDSpeedButton;
    Que_SelMarque: TIBOQuery;
    LK_SelMarque: TwwLookupDialogRV;
    Que_SelMarqueFourn: TIBOQuery;
    Que_SelFournMarque: TIBOQuery;
    MemD_Articles: TdxMemData;
    MemD_ArticlesART_ID: TIntegerField;
    MemD_ArticlesTGF_ID: TIntegerField;
    Chp_Ray: TRzDBLabelRv;
    Chp_Fam: TRzDBLabelRv;
    Chp_SSF: TRzDBLabelRv;
    Lab_Help: TRzPanelRv;
    Image1: TImage;
    Pan_TrtLog: TRzPanelRv;
    Lab_TrtLog: TRzLabel;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE Nbt_QuitterClick(Sender: TObject);
    PROCEDURE Nbt_ExportInitClick(Sender: TObject);
    PROCEDURE Nbt_ExportArtClick(Sender: TObject);
    PROCEDURE Nbt_ReinitFiltresClick(Sender: TObject);
    PROCEDURE Nbt_DateCreationClick(Sender: TObject);
    PROCEDURE Nbt_DateModifClick(Sender: TObject);
    PROCEDURE Nbt_FournisseurClick(Sender: TObject);
    PROCEDURE Nbt_CollectionClick(Sender: TObject);
    PROCEDURE Nbt_RefArtClick(Sender: TObject);
    PROCEDURE MemD_ParamsChange(Sender: TField);
    PROCEDURE Nbt_MarqueClick(Sender: TObject);
    PROCEDURE Nbt_ClassificationClick(Sender: TObject);
    PROCEDURE Nbt_RemClassifClick(Sender: TObject);
  PRIVATE
    MyIniFile: TIniFile;
    FiCurNum: integer;
    PROCEDURE InitParam();
    FUNCTION GetiNextNum: integer;
    PROCEDURE SetiNextNum(CONST Value: integer);
    FUNCTION GetiCurNum: integer;
    PROCEDURE SetiCurNum(CONST Value: integer);
    FUNCTION ExportInit(): boolean;
    FUNCTION ExportArticles(): boolean;
    FUNCTION TraiterMarques(sFolder: STRING): boolean;
    FUNCTION TraiterFicInit(sFolder: STRING; AQuery: TIBOQuery; NomFic: STRING): boolean;
    FUNCTION TraiterFicArticle(sFolder: STRING; AQuery: TIBOQuery): boolean;
    {    FUNCTION TraiterClassification(sFolder: STRING): boolean;
        FUNCTION TraiterGrilleTaille(sFolder: STRING): boolean;}
    FUNCTION QueryVersFile(AEntete: STRING; AQuery: TIBOQuery; AFileName: STRING; bAddSeparateurOnEnd: boolean;
      Separateur: char = #9): boolean;
    FUNCTION ArticlesVersFile(AEntete: STRING; AQuery: TIBOQuery;
      AFolder, AArtFileName, ACoulFileName, APriceFileName: STRING; bAddSeparateurOnEnd: boolean;
      Separateur: char): boolean;
    FUNCTION GetCodePays(ANomPays: STRING): STRING;
    FUNCTION GetColombusID(AKtbID: integer; AID: STRING): STRING;
    FUNCTION GetEnteteStandard(sNomFic: STRING): STRING;
    PROCEDURE InitFiltre();
    PROCEDURE CreerFiltre(AQuery: TIBOQuery);
    PROCEDURE FiltreSauve(sExportFolder: STRING);
    //    FUNCTION GetNextNum() : integer;
        { Déclarations privées }
  PUBLIC
    MyParams: TParams;

    PROPERTY iNextNum: integer READ GetiNextNum WRITE SetiNextNum;
    PROPERTY iCurNum: integer READ GetiCurNum WRITE SetiCurNum;
    //    PROPERTY EnteteStandard: STRING READ GetEnteteStandard;

    FUNCTION GetNewFileName(NomFic: STRING): STRING;
    FUNCTION GetNewFolderName(): STRING;
    { Déclarations publiques }
  END;

VAR
  Frm_Main: TFrm_Main;
  ImageBureau: TPicture;

IMPLEMENTATION

USES UCommon, FileCtrl, UNomenk;

{$R *.DFM}


PROCEDURE TFrm_Main.InitParam;
BEGIN
  MyParams.sDBExport := MyIniFile.ReadString('BD_EXPORT', 'PATH', '');
  BaseCorrespondance.Close;
  BaseCorrespondance.DatabaseName := MyParams.sDBExport;
  BaseCorrespondance.Open;

  MyParams.sDBGinkoia := MyIniFile.ReadString('BD_GINKOIA', 'PATH', '');
  MyParams.sMAGGinkoia := MyIniFile.ReadString('BD_GINKOIA', 'MAG', '');
  BaseGinkoia.Close;
  BaseGinkoia.DatabaseName := MyParams.sDBGinkoia;
  BaseGinkoia.Open;

  MyParams.cSeparateur := #9;

  MyParams.bLogActif := MyIniFile.ReadBool('OPTIONS', 'LOGACTIF', True);

  MyParams.sForbiddenChars := MyIniFile.ReadString('BD_EXPORT', 'FORBIDCHARS', ',;&<>\?|*');
  MyParams.cForbidReplaceChar := MyIniFile.ReadString('BD_EXPORT', 'REPLACEFORBIDBY', '_')[1];

  InitForbiddenChars(MyParams.sForbiddenChars, MyParams.cForbidReplaceChar);

  //  MyParams.sVersion := Copy(MyIniFile.ReadString('OPTIONS', 'VERSION', '000.000'), 1, 7);

END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
BEGIN
  MyIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  ImageBureau := TPicture.Create();
  Memo_Log.Clear;
  Lab_ListCrit.Caption := '';
  InitFiltre();
  InitParam();
END;

PROCEDURE TFrm_Main.FormDestroy(Sender: TObject);
BEGIN
  MyIniFile.Free;
  ImageBureau.Free;
  MemD_Params.Close;
END;

FUNCTION TFrm_Main.GetEnteteStandard(sNomFic: STRING): STRING;
VAR
  sVersion: STRING;
BEGIN
  sVersion := MyIniFile.ReadString('OPTIONS', 'VERSION_' + sNomFic, '000.000');
  result := '<ENTETE>EXP  ' + sVersion + FormatDateTime('dd/mm/yyyyhh:mm:ss', Now()) + 'EXP  FREX         '
END;

FUNCTION TFrm_Main.GetiCurNum: integer;
BEGIN
  // Lecture du numéro
  FiCurNum := MyIniFile.ReadInteger('EXPORT', 'LAST_NUM', 0);

  Result := FiCurNum;
END;

FUNCTION TFrm_Main.GetiNextNum: integer;

BEGIN
  // Lecture du numéro
  FiCurNum := MyIniFile.ReadInteger('EXPORT', 'LAST_NUM', 0);

  // +1
  inc(FiCurNum);

  // Sauvegarde
  MyIniFile.WriteInteger('EXPORT', 'LAST_NUM', FiCurNum);

  Result := FiCurNum
END;

PROCEDURE TFrm_Main.SetiCurNum(CONST Value: integer);
BEGIN
  // Sauvegarde
  MyIniFile.WriteInteger('EXPORT', 'LAST_NUM', Value);

  // Lecture du numéro
  FiCurNum := MyIniFile.ReadInteger('EXPORT', 'LAST_NUM', 0);

END;

PROCEDURE TFrm_Main.SetiNextNum(CONST Value: integer);
BEGIN
  showmessage('Interdit de set le next num....');
END;

PROCEDURE TFrm_Main.Nbt_QuitterClick(Sender: TObject);
BEGIN
  Application.Terminate;
END;

FUNCTION TFrm_Main.GetNewFileName(NomFic: STRING): STRING;
VAR
  sFileName: STRING;
  GenResult: integer;
BEGIN
  GenResult := IbC_Generateur.Gen_ID(NomFic + '_GEN', 1);

  IF GenResult > 99999 THEN
  BEGIN
    // Erreur fin du générateur atteint
    sFileName := '';
  END
  ELSE BEGIN

    sFileName := NomFic + 'M' + Format('%.05d', [GenResult]) + '.paq';
  END;

  Result := sFileName;
END;

FUNCTION TFrm_Main.GetNewFolderName: STRING;
VAR
  sFolder: STRING;
BEGIN
  // Init du nom
  sFolder := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Export\' + FormatDateTime('yyyy-mm-dd', Date()) + '_' + IntToStr(iNextNum);
  sFolder := IncludeTrailingBackslash(sFolder);

  // Création
  ForceDirectories(sFolder);

  Result := sFolder;
END;


FUNCTION TFrm_Main.QueryVersFile(AEntete: STRING; AQuery: TIBOQuery;
  AFileName: STRING; bAddSeparateurOnEnd: boolean;
  Separateur: char = #9): boolean;
VAR
  tsExport: TStrings;
  i, j: integer;
  sLig: STRING;
  sChp: STRING;
  iKTB: integer;
  bIgnoreField: boolean;

BEGIN
  tsExport := TStringList.Create();
  TRY
    // Créer l'entete
    tsExport.Add(AEntete);
    j := 0;
    WHILE NOT AQuery.Eof DO
    BEGIN
      // Extraction
      sLig := '';
      FOR i := 0 TO AQuery.FieldCount - 1 DO
      BEGIN
        bIgnoreField := false;
        IF AQuery.Fields[i].FieldName = 'PAYS' THEN
        BEGIN
          // récupération du code
          sChp := GetCodePays(AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'FOU_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111385, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'GTF_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111364, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'TGF_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111371, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'COU_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111362, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'RAY_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111356, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'FAM_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111355, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'SSF_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111359, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'CODECLASSE' THEN
        BEGIN
          CASE AQuery.FieldByName('NIVEAU').AsInteger OF
            7: iKTB := -11111356;
            8: iKTB := -11111355;
            9: iKTB := -11111359;
          ELSE iKTB := 0;
          END;

          IF AQuery.Fields[i].AsString <> '' THEN
            sChp := GetColombusID(iKTB, AQuery.Fields[i].AsString)
          ELSE
            sChp := '';

        END
        ELSE IF AQuery.Fields[i].FieldName = 'CODECLASSEMERE' THEN
        BEGIN
          CASE AQuery.FieldByName('NIVEAU').AsInteger OF
            8: iKTB := -11111356; // KTB de la table RAYON
            9: iKTB := -11111355; // KTB de la table FAMILLE
          ELSE iKTB := 0;

          END;

          IF AQuery.Fields[i].AsString <> '' THEN
            sChp := GetColombusID(iKTB, AQuery.Fields[i].AsString)
          ELSE
            sChp := '';
        END
        ELSE BEGIN
          sChp := UpperAndRemoveForbiddenChars(AQuery.Fields[i].AsString)
        END;
        // Création de l'entete au premier passage
        IF NOT (bIgnoreField) THEN
        BEGIN
          IF i = 0 THEN
            sLig := sChp
          ELSE
            sLig := sLig + Separateur + sChp;
        END;
      END;
      IF bAddSeparateurOnEnd THEN
        sLig := sLig + Separateur;

      tsExport.Add(sLig);

      // ligne suivante
      AQuery.Next;

      // J suivant
      inc(j);
    END;
    tsExport.SaveToFile(AFileName);

    tsExport.Clear;

    LogAction('OK - Export du fichier ' + AFileName + ' terminé');

    result := true;
  EXCEPT
    ON E: Exception DO
    BEGIN
      LogAction('ERREUR - Export du fichier ' + AFileName + ' echoué : ' + E.Message);
      result := false;
    END;
  END;
  // Libération
  tsExport.Free;

END;

FUNCTION TFrm_Main.GetCodePays(ANomPays: STRING): STRING;
BEGIN
  TRY
    IbC_GetCodePays.Close;
    IbC_GetCodePays.ParamByName('PAY_NOM').AsString := ANomPays;
    IbC_GetCodePays.Open;
    Result := IbC_GetCodePays.Fields[0].AsString;
    IbC_GetCodePays.Close;
  EXCEPT
    ON e: exception DO
    BEGIN
      result := '';
      logaction(e.Message);
    END;

  END;
END;

FUNCTION TFrm_Main.GetColombusID(AKtbID: integer; AID: STRING): STRING;
BEGIN
  TRY
    IbC_Generateur.Close;
    IbC_Generateur.ParamByName('KTBID').AsInteger := AKtbID;
    IbC_Generateur.ParamByName('GINKID').AsString := AID;
    IbC_Generateur.Open;
    //    IbC_Generateur.First;
    Result := IbC_Generateur.Fields[0].AsString;
    IbC_Generateur.IB_Transaction.Commit;
    IbC_Generateur.Close;
  EXCEPT
    ON e: exception DO
    BEGIN
      IbC_Generateur.IB_Transaction.Rollback;
      result := '';
      logaction(e.Message);
    END;
  END;


END;

FUNCTION TFrm_Main.TraiterFicInit(sFolder: STRING; AQuery: TIBOQuery;
  NomFic: STRING): boolean;

// Traitement des fichiers d'initialisation, on passe la query a exécuter, et le nom du fichier (DM, FR, GD, etc....)
BEGIN
  result := false;
  TRY
    AQuery.Close;
    AQuery.Open;
    QueryVersFile(GetEnteteStandard(NomFic), AQuery, sFolder + GetNewFileName(NomFic), true, MyParams.cSeparateur);
    Update;
    AQuery.Close;

    result := true;
  EXCEPT
    ON E: Exception DO
    BEGIN
      AQuery.Close;
      LogAction(E.Message);
    END;
  END;

END;

FUNCTION TFrm_Main.TraiterMarques(sFolder: STRING): boolean;
// Traitement des marques
BEGIN
  result := false;

  TRY
    Que_GetMarques.Close;
    Que_GetMarques.Open;
    QueryVersFile(QueryGetEntete(Que_GetMarques), Que_GetMarques, sFolder + 'MARQUE.CSV', false, MyParams.cSeparateur);
    update;
    Que_GetMarques.Close;


    result := true;
  EXCEPT
    ON E: Exception DO
    BEGIN
      LogAction(E.Message);
    END;
  END;
END;

FUNCTION TFrm_Main.TraiterFicArticle(sFolder: STRING; AQuery: TIBOQuery): boolean;
// Traitement des fichiers d'articles, on passe la query a exécuter, et le nom du fichier (DM, FR, GD, etc....)
BEGIN
  result := false;
  TRY
    AQuery.Close;

    CreerFiltre(AQuery);

    AQuery.Open;

    ArticlesVersFile('', AQuery, sFolder, GetNewFileName('FA'), GetNewFileName('DM'), GetNewFileName('PV'), True, MyParams.cSeparateur);
    Update;
    AQuery.Close;

    result := true;
  EXCEPT
    ON E: Exception DO
    BEGIN
      AQuery.Close;
      LogAction(E.Message);
    END;
  END;

END;

FUNCTION TFrm_Main.ExportArticles: boolean;
VAR
  sExportFolder: STRING;
BEGIN
  InitParam();

  // Récupération du n° pour le dossier
  sExportFolder := GetNewFolderName;

  initLogFileName(Memo_Log, NIL, MyParams.bLogActif);

  LogAction('Fichier articles début');

  FiltreSauve(sExportFolder);

  IF TraiterFicArticle(sExportFolder, Que_Articles) THEN
  BEGIN
    LogAction('Fichier articles exporté');

    ShellExecute(0, PChar('open'), PChar(sExportFolder), NIL, NIL, SW_SHOWNORMAL);
  END;

END;

FUNCTION TFrm_Main.ExportInit: boolean;
VAR
  sExportFolder: STRING;

BEGIN

  InitParam();

  // Récupération du n° pour le dossier
  sExportFolder := GetNewFolderName;

  initLogFileName(Memo_Log, NIL, MyParams.bLogActif);

  IF TraiterMarques(sExportFolder) THEN
  BEGIN
    LogAction('Fichier marques exporté');
  END;

  IF TraiterFicInit(sExportFolder, Que_Fournisseurs, 'FR') THEN
  BEGIN
    LogAction('Fichier fournisseur exporté');
  END;

  IF TraiterFicInit(sExportFolder, Que_Classification, 'CM') THEN
  BEGIN
    LogAction('Fichier classification exporté');
  END;

  IF TraiterFicInit(sExportFolder, Que_GrilleTaille, 'GD') THEN
  BEGIN
    LogAction('Fichier grilles de tailles exporté');
  END;

  IF TraiterFicInit(sExportFolder, Que_Tailles, 'DM') THEN
  BEGIN
    LogAction('Fichier des tailles exporté');
  END;

  ShellExecute(0, PChar('open'), PChar(sExportFolder), NIL, NIL, SW_SHOWNORMAL);

END;

PROCEDURE TFrm_Main.Nbt_ExportInitClick(Sender: TObject);
BEGIN
  ExportInit();
END;

PROCEDURE TFrm_Main.Nbt_ExportArtClick(Sender: TObject);
BEGIN
  ExportArticles();
END;



FUNCTION TFrm_Main.ArticlesVersFile(AEntete: STRING; AQuery: TIBOQuery;
  AFolder, AArtFileName, ACoulFileName, APriceFileName: STRING; bAddSeparateurOnEnd: boolean;
  Separateur: char): boolean;
VAR
  tsPrix, tsCoul, tsExport: TStrings;
  i, j: integer;
  sLig: STRING;
  sLigNLK1, sLigNLK2, sLigNLK3: STRING;
  sChp: STRING;
  iKTB: integer;
  cSep: char;
  bIgnoreField: boolean;
  iCompteur, iCptCou, iCptTgf: integer;
  iArtID, iCouId, iTgfId: integer;
  sRefArt: STRING;
  bArtChanged: boolean;
BEGIN
  cSep := MyParams.cSeparateur;
  tsExport := TStringList.Create();
  tsCoul := TStringList.Create();
  tsPrix := TStringList.Create();
  TRY
    // Créer l'entete
    tsExport.Add(GetEnteteStandard('FA'));
    tsCoul.Add(GetEnteteStandard('DM'));
    tsPrix.Add(GetEnteteStandard('PV'));
    // Puis dans le Tstring que l'on va exporter
    tsCoul.Add('2' + cSep + 'M001' + cSep + 'UNICOLOR' + cSep);
    MemD_Couleurs.Open;
    MemD_Articles.Open;
    j := 0;
    iCompteur := 0;
    iArtID := 0;
    WHILE NOT AQuery.Eof DO
    BEGIN
      // Extraction
      sLig := '';

      bArtChanged := False;
      sRefArt := StringReplace(Que_Articles.FieldByName('REFPROD').AsString, ' ', '-', [rfReplaceAll]);
      FOR i := 0 TO AQuery.FieldCount - 1 DO
      BEGIN
        bIgnoreField := false;
        IF AQuery.Fields[i].FieldName = 'PAYS' THEN
        BEGIN
          // récupération du code
          sChp := GetCodePays(AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'FOU_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111385, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'GTF_ID' THEN
        BEGIN
          sChp := GetColombusID(-11111364, AQuery.Fields[i].AsString);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'TGF_ID' THEN
        BEGIN
          IF iTgfId <> AQuery.FieldByName('TGF_ID').AsInteger THEN
          BEGIN
            // Nouvelle couleur
            inc(iCptTgf);
            iTgfId := AQuery.FieldByName('TGF_ID').AsInteger;
          END;

          sChp := GetColombusID(-11111371, AQuery.Fields[i].AsString);

          // Verif si on a déjà exporté cette article/taille dans le fichier des prix
          // plus nécéssaire, car on exporte pour toutes les lignes
{          IF NOT (MemD_Articles.Locate('ART_ID;TGF_ID', VarArrayOf([AQuery.FieldByName('ART_ID').AsInteger, AQuery.FieldByName('TGF_ID').AsInteger]), [loCaseInsensitive])) THEN
          BEGIN
            MemD_Articles.Edit;
            MemD_Articles.Append;
            MemD_ArticlesART_ID.AsInteger := AQuery.FieldByName('ART_ID').AsInteger;
            MemD_ArticlesTGF_ID.AsInteger := AQuery.FieldByName('TGF_ID').AsInteger;
            MemD_Articles.Post;
            WITH AQuery DO
            BEGIN
              // On ajoute les ligne
              tsPrix.Add('PTF' + cSep + 'PB' + cSep + sRefArt + cSep + cSep + sChp + cSep + cSep + cSep + cSep + cSep + StringReplace(FloatToStrF(FieldByName('PTF').AsFloat, ffFixed, 9, 2), ',', '.', [rfReplaceAll]));
              tsPrix.Add('PAC' + cSep + 'PB' + cSep + sRefArt + cSep + cSep + sChp + cSep + cSep + cSep + cSep + cSep + StringReplace(FloatToStrF(FieldByName('PAC').AsFloat, ffFixed, 9, 2), ',', '.', [rfReplaceAll]));
              tsPrix.Add('PVC' + cSep + 'PB' + cSep + sRefArt + cSep + cSep + sChp + cSep + cSep + cSep + cSep + cSep + StringReplace(FloatToStrF(FieldByName('PVC').AsFloat, ffFixed, 9, 2), ',', '.', [rfReplaceAll]));
            END;
          END;}
          WITH AQuery DO
          BEGIN
            // On ajoute les ligne
            tsPrix.Add('PTF' + cSep + 'PB' + cSep + sRefArt + cSep + cSep + cSep + cSep + cSep + FieldByName('CODEBARRE').asString + cSep + cSep + StringReplace(FloatToStrF(FieldByName('PTF').AsFloat, ffFixed, 9, 2), ',', '.', [rfReplaceAll]));
            tsPrix.Add('PAC' + cSep + 'PB' + cSep + sRefArt + cSep + cSep + cSep + cSep + cSep + FieldByName('CODEBARRE').asString + cSep + cSep + StringReplace(FloatToStrF(FieldByName('PAC').AsFloat, ffFixed, 9, 2), ',', '.', [rfReplaceAll]));
            tsPrix.Add('PVC' + cSep + 'PB' + cSep + sRefArt + cSep + cSep + cSep + cSep + cSep + FieldByName('CODEBARRE').asString + cSep + cSep + StringReplace(FloatToStrF(FieldByName('PVC').AsFloat, ffFixed, 9, 2), ',', '.', [rfReplaceAll]));
          END;



        END
        ELSE IF AQuery.Fields[i].FieldName = 'COU_ID' THEN
        BEGIN
          IF iCouId <> AQuery.FieldByName('COU_ID').AsInteger THEN
          BEGIN
            // Nouvelle couleur
            inc(iCptCou);
            iCouId := AQuery.FieldByName('COU_ID').AsInteger;
            // Repasse le compteur de Tgf à 0
            iTgfId := 0;
            iCptTgf := 0;
          END;

          IF IsUnicolor(AQuery.FieldByName('COU_NOM').AsString) THEN
          BEGIN
            sChp := 'M001';
          END
          ELSE BEGIN
            sChp := GetColombusID(-11111362, AQuery.FieldByName('COU_NOM').AsString);
            // Modif pour gerer les couleurs par nom et non plus par ID
//            sChp := GetColombusID(-11111362, AQuery.Fields[i].AsInteger);
            IF NOT (MemD_Couleurs.Locate('COU_ID', sChp, [loCaseInsensitive])) THEN
            BEGIN
              // Pas encore ajouté, donc on stock dans le memd
              MemD_Couleurs.Edit;
              MemD_Couleurs.Append;
              MemD_CouleursCOU_ID.AsString := sChp;
              MemD_Couleurs.Post;

              // Puis dans le Tstring que l'on va exporter
              tsCoul.Add('2' + cSep + sChp + cSep + AQuery.FieldByName('COU_NOM').AsString + cSep);

            END;
          END;
        END
        ELSE IF (AQuery.Fields[i].FieldName = 'COU_NOM') THEN
        BEGIN
          bIgnoreField := True;
        END
        ELSE IF (AQuery.Fields[i].FieldName = 'ART_ID') THEN
        BEGIN
          bIgnoreField := True;
          IF iArtID <> AQuery.Fields[i].AsInteger THEN
          BEGIN
            IF iArtID <> 0 THEN
            BEGIN
              tsExport.Add(sLigNLK1);
              tsExport.Add(sLigNLK2);
              tsExport.Add(sLigNLK3);
            END;
            
            inc(j);
            // Repasse le compteur de Tgf et Cou à 0
            iCompteur := 0;
            iCptCou := 0;
            icptTgf := 0;
            iArtID := AQuery.Fields[i].AsInteger;
            iCouId := 0;
            iTgfId := 0;
          END
          ELSE BEGIN
            inc(iCompteur);
          END;
        END
        ELSE IF ((AQuery.Fields[i].FieldName = 'REFPROD') OR (AQuery.Fields[i].FieldName = 'NOM') OR (AQuery.Fields[i].FieldName = 'CODEFOU')) THEN
        BEGIN
          sChp := sRefArt;
        END
        ELSE IF (AQuery.Fields[i].FieldName = 'COUCPT') THEN
        BEGIN
          sChp := IntToStr(iCptCou);
        END
        ELSE IF (AQuery.Fields[i].FieldName = 'TGFCPT') THEN
        BEGIN
          sChp := IntToStr(iCptTgf);
        END
        ELSE IF (AQuery.Fields[i].FieldName = 'UVC') THEN
        BEGIN
          sChp := sRefArt + '/' + IntToStr(iCompteur);
        END
        ELSE IF AQuery.Fields[i].FieldName = 'RAY_ID' THEN
        BEGIN
          bIgnoreField := true;
          sChp := GetColombusID(-11111356, AQuery.Fields[i].AsString);
          sLigNLK1 := 'NCM' + cSep + sRefArt + cSep + '1' + cSep + '7' + cSep + sChp + cSep + '' + cSep
        END
        ELSE IF AQuery.Fields[i].FieldName = 'FAM_ID' THEN
        BEGIN
          bIgnoreField := true;
          sChp := GetColombusID(-11111355, AQuery.Fields[i].AsString);
          sLigNLK2 := 'NCM' + cSep + sRefArt + cSep + '1' + cSep + '8' + cSep + sChp + cSep + '' + cSep
        END
        ELSE IF AQuery.Fields[i].FieldName = 'SSF_ID' THEN
        BEGIN
          bIgnoreField := true;
          sChp := GetColombusID(-11111359, AQuery.Fields[i].AsString);
          sLigNLK3 := 'NCM' + cSep + sRefArt + cSep + '1' + cSep + '9' + cSep + sChp + cSep + '' + cSep
        END
        ELSE IF AQuery.Fields[i].FieldName = 'TVA' THEN
        BEGIN
          IF AQuery.Fields[i].AsString = '19,6' THEN
            sChp := '01'
          ELSE IF AQuery.Fields[i].AsString = '5,5' THEN
            sChp := '02'
          ELSE IF AQuery.Fields[i].AsString = '2,1' THEN
            sChp := '03'
          ELSE
            sChp := '';
        END
        ELSE IF AQuery.Fields[i].FieldName = 'CODECLASSE' THEN
        BEGIN
          CASE AQuery.FieldByName('NIVEAU').AsInteger OF
            7: iKTB := -11111356;
            8: iKTB := -11111355;
            9: iKTB := -11111359;
          ELSE iKTB := 0;
          END;

          IF AQuery.Fields[i].AsString <> '' THEN
            sChp := GetColombusID(iKTB, AQuery.Fields[i].AsString)
          ELSE
            sChp := '';

        END
        ELSE IF AQuery.Fields[i].FieldName = 'CODECLASSEMERE' THEN
        BEGIN
          CASE AQuery.FieldByName('NIVEAU').AsInteger OF
            8: iKTB := -11111356; // KTB de la table RAYON
            9: iKTB := -11111355; // KTB de la table FAMILLE
          ELSE iKTB := 0;

          END;

          IF AQuery.Fields[i].AsString <> '' THEN
            sChp := GetColombusID(iKTB, AQuery.Fields[i].AsString)
          ELSE
            sChp := '';
        END
        ELSE IF ((AQuery.Fields[i].FieldName = 'PTF') OR (AQuery.Fields[i].FieldName = 'PAC') OR (AQuery.Fields[i].FieldName = 'PVC')) THEN
        BEGIN
          bIgnoreField := True;
        END
        ELSE BEGIN
          sChp := AQuery.Fields[i].AsString
        END;
        // Suppression des caractères spéciaux
        sChp := UpperAndRemoveForbiddenChars(sChp);

        // Création de l'entete au premier passage
        IF NOT (bIgnoreField) THEN
        BEGIN
          IF sLig = '' THEN
            sLig := sChp
          ELSE
            sLig := sLig + Separateur + sChp;
        END;
      END;
      IF bAddSeparateurOnEnd THEN
        sLig := sLig + Separateur;



      tsExport.Add(sLig);

      // ligne suivante
      AQuery.Next;

      // J suivant
//      inc(j);
    END;
    //    showmessage(inttostr(j));
    // On exporte la nomenclature
    tsExport.Add(sLigNLK1);
    tsExport.Add(sLigNLK2);
    tsExport.Add(sLigNLK3);

    tsExport.SaveToFile(AFolder + AArtFileName);
    LogAction('OK - Export du fichier ' + AFolder + AArtFileName + ' terminé');

    // Sauvegarde du fichier couleurs
    tsCoul.SaveToFile(AFolder + ACoulFileName);
    LogAction('OK - Export du fichier ' + AFolder + ACoulFileName + ' terminé');

    tsPrix.SaveToFile(AFolder + APriceFileName);
    LogAction('OK - Export du fichier ' + AFolder + APriceFileName + ' terminé');

    tsExport.Clear;
    tsCoul.Clear;
    tsPrix.Clear;

    result := true;
  EXCEPT
    ON E: Exception DO
    BEGIN
      LogAction('ERREUR - Export des fichiers articles echoué : ' + E.Message);
      result := false;
    END;
  END;
  // Libération
  tsExport.Free;
  tsCoul.Free;
  tsPrix.Free;
  MemD_Couleurs.Close;
  MemD_Articles.Close;
END;

PROCEDURE TFrm_Main.InitFiltre;
BEGIN
  MemD_Params.Close;
  MemD_Params.Open;
  MemD_Params.Append;
END;

PROCEDURE TFrm_Main.Nbt_ReinitFiltresClick(Sender: TObject);
BEGIN
  InitFiltre();
END;

PROCEDURE TFrm_Main.Nbt_DateCreationClick(Sender: TObject);
BEGIN
  MemD_ParamsDateCreation.AsString := '';
END;

PROCEDURE TFrm_Main.Nbt_DateModifClick(Sender: TObject);
BEGIN
  MemD_ParamsDateModif.AsString := '';
END;

PROCEDURE TFrm_Main.Nbt_FournisseurClick(Sender: TObject);
BEGIN
  MemD_ParamsFOU_ID.AsString := '';
  MemD_ParamsFOU_NOM.AsString := '';
END;

PROCEDURE TFrm_Main.Nbt_CollectionClick(Sender: TObject);
BEGIN
  MemD_ParamsCOL_ID.AsString := '';
  MemD_ParamsCOL_NOM.AsString := '';

END;

PROCEDURE TFrm_Main.Nbt_RefArtClick(Sender: TObject);
BEGIN
  MemD_ParamsREF_ARTICLE.AsString := '';
END;

PROCEDURE TFrm_Main.CreerFiltre(AQuery: TIBOQuery);
BEGIN
  AQuery.Close;
  // Ajouter les paramètres d'export choisis...
  AQuery.SQLWhere.Text := 'WHERE ARF_ARCHIVER <> 1';

  Lab_ListCrit.Caption := '';

  IF MemD_ParamsREF_ARTICLE.AsString <> '' THEN
  BEGIN
    AQuery.SQLWHere.Add('AND ART_REFMRK LIKE ' + QuotedStr(MemD_ParamsREF_ARTICLE.AsString));
    Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Référence article : ' + MemD_ParamsREF_ARTICLE.AsString;
  END;

  IF MemD_ParamsMRK_ID.AsInteger > 0 THEN
  BEGIN
    AQuery.SQLWhere.Add('AND MRK_ID = ' + IntToStr(MemD_ParamsMRK_ID.AsInteger));
    Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Marque : ' + MemD_ParamsMRK_NOM.AsString;

    Que_SelFournMarque.ParamByName('MRKID').AsInteger := MemD_ParamsMRK_ID.AsInteger;
    LK_SelFourn.LookupTable := Que_SelFournMarque;
  END
  ELSE BEGIN
    LK_SelFourn.LookupTable := Que_SelFourn;
  END;

  IF MemD_ParamsFOU_ID.AsInteger > 0 THEN
  BEGIN
    AQuery.SQLWhere.Add('AND EXISTS (SELECT MRK_ID FROM ARTFOURN JOIN ARTMRKFOURN JOIN ARTMARQUE ON (FMK_MRKID = MRK_ID) ON (FOU_ID = FMK_FOUID) WHERE MRK_ID = ARTARTICLE.ART_MRKID AND FOU_ID = ' + IntToStr(MemD_ParamsFOU_ID.AsInteger) + ')');
    Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Fournisseur : ' + MemD_ParamsFOU_NOM.AsString;

    Que_SelMarqueFourn.ParamByName('FOUID').AsInteger := MemD_ParamsFOU_ID.AsInteger;
    LK_SelMarque.LookupTable := Que_SelMarqueFourn;
  END
  ELSE BEGIN
    LK_SelMarque.LookupTable := Que_SelMarque;
  END;

  IF MemD_ParamsCOL_ID.AsInteger > 0 THEN
  BEGIN
    AQuery.SQLWHere.Add('AND EXISTS (SELECT COL_ID FROM ARTCOLLECTION JOIN ARTCOLART ON (CAR_COLID = COL_ID) WHERE CAR_ARTID = ARTARTICLE.ART_ID AND COL_ID = ' + IntToStr(MemD_ParamsCOL_ID.AsInteger) + ')');
    Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Collection : ' + MemD_ParamsCOL_NOM.AsString;
  END;

  IF MemD_ParamsDateCreation.AsString <> '' THEN
  BEGIN
    AQuery.SQLWHere.Add('AND ARF_CREE >= :DATECREE');
    AQuery.ParamByName('DATECREE').AsDateTime := MemD_ParamsDateCreation.AsDateTime;
    Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Articles créés depuis le : ' + FormatDateTime('dd/mm/yyyy', MemD_ParamsDateCreation.AsDateTime);
  END;

  IF MemD_ParamsDateModif.AsString <> '' THEN
  BEGIN
    AQuery.SQLWHere.Add('AND KART.K_UPDATED >= :DATEMOD');
    AQuery.ParamByName('DATEMOD').AsDateTime := MemD_ParamsDateModif.AsDateTime;
    Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Articles modifiés depuis le : ' + FormatDateTime('dd/mm/yyyy', MemD_ParamsDateModif.AsDateTime);
  END;

  Chp_Ray.Visible := False;
  Chp_Fam.Visible := False;
  Chp_SSF.Visible := False;
  IF MemD_ParamsRAY_ID.AsInteger > 0 THEN
  BEGIN
    IF MemD_ParamsFAM_ID.AsInteger > 0 THEN
    BEGIN
      IF MemD_ParamsSSF_ID.AsInteger > 0 THEN
      BEGIN
        AQuery.SQLWHere.Add('AND SSF_ID = ' + MemD_ParamsSSF_ID.AsString);
        Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Sous-Famille : ' + MemD_ParamsSSF_NOM.AsString;
        Chp_Ray.Visible := True;
        Chp_Fam.Visible := True;
        Chp_SSF.Visible := True;
      END
      ELSE BEGIN
        AQuery.SQLWHere.Add('AND FAM_ID = ' + MemD_ParamsFAM_ID.AsString);
        Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Famille : ' + MemD_ParamsFAM_NOM.AsString;
        Chp_Ray.Visible := True;
        Chp_Fam.Visible := True;
      END;
    END
    ELSE BEGIN
      AQuery.SQLWHere.Add('AND RAY_ID = ' + MemD_ParamsRAY_ID.AsString);
      Lab_ListCrit.Caption := Lab_ListCrit.Caption + ', Rayon : ' + MemD_ParamsRAY_NOM.AsString;
      Chp_Ray.Visible := True;
    END;
  END;
  Lab_ListCrit.Caption := Copy(Lab_ListCrit.Caption, 3, Length(Lab_ListCrit.Caption));
END;

PROCEDURE TFrm_Main.MemD_ParamsChange(Sender: TField);
BEGIN
  CreerFiltre(Que_Articles);
END;

PROCEDURE TFrm_Main.Nbt_MarqueClick(Sender: TObject);
BEGIN
  MemD_ParamsMRK_ID.asString := '';
  MemD_ParamsMRK_NOM.asString := '';
END;

PROCEDURE TFrm_Main.Nbt_ClassificationClick(Sender: TObject);
VAR
  iRAYID, iFAMID, iSSFID: integer;
  sRAYNOM, sFAMNOM, sSSFNOM: STRING;
BEGIN
  IF ChoixNomenk(iRAYID, iFAMID, iSSFID, sRAYNOM, sFAMNOM, sSSFNOM) THEN
  BEGIN
    MemD_Params.DisableControls;
    MemD_ParamsRAY_ID.AsInteger := iRAYID;
    MemD_ParamsFAM_ID.AsInteger := iFAMID;
    MemD_ParamsSSF_ID.AsInteger := iSSFID;
    MemD_ParamsRAY_NOM.AsString := sRAYNOM;
    MemD_ParamsFAM_NOM.AsString := sFAMNOM;
    MemD_ParamsSSF_NOM.AsString := sSSFNOM;
    MemD_Params.EnableControls;
  END;
END;

PROCEDURE TFrm_Main.Nbt_RemClassifClick(Sender: TObject);
BEGIN
  MemD_Params.DisableControls;
  MemD_ParamsRAY_ID.AsInteger := 0;
  MemD_ParamsFAM_ID.AsInteger := 0;
  MemD_ParamsSSF_ID.AsInteger := 0;
  MemD_ParamsRAY_NOM.AsString := '';
  MemD_ParamsFAM_NOM.AsString := '';
  MemD_ParamsSSF_NOM.AsString := '';
  MemD_Params.EnableControls;
END;

PROCEDURE TFrm_Main.FiltreSauve(sExportFolder: STRING);
VAR
  ts: TStrings;
  ImageJPEG: TJPEGImage;
BEGIN

  // Sauvegarde des informations de filtre
  ImageBureau.Bitmap.Width := Frm_Main.Width - 8;
  ImageBureau.Bitmap.Height := Frm_Main.Height - 34;
  BitBlt(ImageBureau.Bitmap.Canvas.Handle, 0, 0, ImageBureau.Bitmap.Width, ImageBureau.Bitmap.Height,
    GetDC(Frm_Main.Handle), 0, 0, SrcCopy); //recopie l'image du desktop vers ImageBureau

  ImageJPEG := TJPEGImage.Create;
  TRY
    ImageJPEG.Assign(ImageBureau.Bitmap);
    ImageJPEG.SaveToFile(sExportFolder + 'Filtre.jpg');

    Image1.Picture.Bitmap := ImageBureau.Bitmap;
    Image1.Update;


  FINALLY
    ImageJPEG.Free;
  END;

  // Idem mais en fichier texte
  ts := TStringList.create;
  TRY
    ts.Add(Lab_ListCrit.Caption);
    ts.SaveToFile(sExportFolder + 'Filtre.txt');
  FINALLY
    ts.Free;
  END;
END;

END.

