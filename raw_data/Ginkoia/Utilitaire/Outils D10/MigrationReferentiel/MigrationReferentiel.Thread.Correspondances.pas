unit MigrationReferentiel.Thread.Correspondances;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Win.ComObj,
  System.Variants,
  Winapi.ActiveX,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  Excel2010,
  MigrationReferentiel.Ressources;

type
  TThreadCorrespondances = class(TCustomMigrationThread)
  strict private
    { Déclarations strictement privées }
    FCorrespondances   : TCorrespondances;
    FValsBaseDonnees   : TCodesValeurs;
    FValsFichier       : TCodesValeurs;
    FValsBaseDonneesNkl: TCodesValeursNkl;
    FValsFichierNkl    : TCodesValeursNkl;
    // Charge le contenu du fichier
    function ChargerFichier(const AFichier: TFileName; const AChampCode, AChampNom: string;
      var ACodesValeurs: TCodesValeurs): Boolean;
    function ChargerFichierNkl(const AFichier: TFileName; const AChampUniCode, AChampUniNom, AChampSecCode,
      AChampSecNom, AChampRayCode, AChampRayNom, AChampFamCode, AChampFamNom, AChampSsfCode, AChampSsfNom,
      AChampCodeFinal: string; var ACodesValeursNkl: TCodesValeursNkl): Boolean;
    // Charge le contenu de la base de données
    function ChargerRequete(ADataSet: TFDQuery; const AChampCode, AChampNom: string;
      var ACodesValeurs: TCodesValeurs): Boolean;
    function ChargerRequeteNkl(ADataSet: TFDQuery; const AChampUniCode, AChampUniNom, AChampSecCode, AChampSecNom,
      AChampRayCode, AChampRayNom, AChampFamCode, AChampFamNom, AChampSsfCode, AChampSsfNom, AChampCodeFinal: string;
      var ACodesValeursNkl: TCodesValeursNkl): Boolean;
    // Calcul les correspondances entre le fichier et la BDD
    procedure CalculerCorrespondances();
    // Enregistre les correspondances dans un fichier Excel
    procedure EnregistrerCorrespondancesExcel();
    procedure EnregistrerCorrespondancesExcelNkl();
  protected
    { Déclarations protégées }
    procedure Execute(); override;
  public
    { Déclarations publiques }
    TypeReferentiel   : TTypeReferentiel;
    FichierReferentiel: TFileName;
    FichierExcelModele: TFileName;
    FichierExcel      : TFileName;
    constructor Create(CreateSuspended: Boolean); override;
    destructor Destroy(); override;
  end;

implementation

{ TThreadCorrespondances }

constructor TThreadCorrespondances.Create(CreateSuspended: Boolean);
begin
  inherited;

  // Initialise le message d'erreur
  FErreur    := False;
  FMsgErreur := '';

  // Créer les composants pour les requêtes SQL
  FDConnection                        := TFDConnection.Create(nil);
  FDConnection.UpdateOptions.ReadOnly := True;
  FDQuery                             := TFDQuery.Create(nil);
  FDQuery.Connection                  := FDConnection;
  FDQuery.UpdateOptions.ReadOnly      := True;

  // Création des listes
  FValsBaseDonnees    := TCodesValeurs.Create();
  FValsFichier        := TCodesValeurs.Create();
  FValsBaseDonneesNkl := TCodesValeursNkl.Create();
  FValsFichierNkl     := TCodesValeursNkl.Create();
  FCorrespondances    := TCorrespondances.Create();
end;

destructor TThreadCorrespondances.Destroy();
begin
  // Destruction des listes
  FreeAndNil(FValsBaseDonnees);
  FreeAndNil(FValsFichier);
  FreeAndNil(FValsBaseDonneesNkl);
  FreeAndNil(FValsFichierNkl);
  FreeAndNil(FCorrespondances);

  inherited;
end;

procedure TThreadCorrespondances.Execute();
begin
  try
    // Initialise le message d'erreur
    FErreur    := False;
    FMsgErreur := '';

    // Vérifie que Excel est installé
    if not ApplicationInstalled('Excel.Application') then
      raise EExcelManquant.Create(RS_ERREUR_EXCEL);

{$REGION 'Paramètrage de la connexion'}
    Progression(RS_MSG_PARAM_CONNECT, 0);
    Journaliser(Format(RS_MSG_PARAM_CONNECT_PARAMS, [Serveur, Port, BaseDonnees, Utilisateur, MotPasse]));

    if (Serveur = '') or (BaseDonnees = '') then
      raise EBaseDonnees.Create(RS_ERREUR_BASEDONNEES);

    FDConnection.Params.Clear();
    FDConnection.Params.Values['DriverID']  := 'IB';
    FDConnection.Params.Values['Protocol']  := 'TCPIP';
    FDConnection.Params.Values['User_Name'] := Utilisateur;
    FDConnection.Params.Values['Password']  := MotPasse;
    FDConnection.Params.Values['Server']    := Serveur;
    FDConnection.Params.Values['Port']      := IntToStr(Port);
    FDConnection.Params.Values['Database']  := BaseDonnees;

    FDQuery.Connection        := FDConnection;
    FDQuery.FetchOptions.Mode := fmAll;
{$ENDREGION 'Paramètrage de la connexion'}
    if Terminated then
      Exit;

{$REGION 'Lecture du fichier'}
    Progression(RS_MSG_LECTURE_FIC, 0);
    Journaliser(Format(RS_MSG_LECTURE_FIC_NOM, [FichierReferentiel]));

    case TypeReferentiel of
      trMarques:
        begin
          if not(ChargerFichier(FichierReferentiel, 'MRK_CODE', 'MRK_NOM', FValsFichier)) and not(Terminated) then
            raise EErreurFichierDSV.Create(RS_ERREUR_FICHIER_DSV);
        end;
      trFournisseurs:
        begin
          if not(ChargerFichier(FichierReferentiel, 'FOU_CODE', 'FOU_NOM', FValsFichier)) and not(Terminated) then
            raise EErreurFichierDSV.Create(RS_ERREUR_FICHIER_DSV);
        end;
      trNomenclature:
        begin
          { DONE 5 -oLP -cCode : Gérer le chargement du fichier de nomenclature. }
          if not(ChargerFichierNkl(FichierReferentiel, 'UNI_CODE', 'UNI_NOM', 'SEC_CODE', 'SEC_NOM', 'RAY_CODE',
              'RAY_NOM', 'FAM_CODE', 'FAM_NOM', 'SSF_CODE', 'SSF_NOM', 'SSF_CODEFINAL', FValsFichierNkl)) and
            not(Terminated) then
            raise EErreurFichierDSV.Create(RS_ERREUR_FICHIER_DSV);
        end;
    end;
{$ENDREGION 'Lecture du fichier'}
    if Terminated then
      Exit;

{$REGION 'Lecture de la base de données'}
    Progression(RS_MSG_LECTURE_BDD, 0);
    Journaliser(RS_MSG_LECTURE_BDD);

    try
      case TypeReferentiel of
        trMarques:
          begin
            FDQuery.SQL.Add('SELECT DISTINCT MRK_CODE, MRK_NOM');
            FDQuery.SQL.Add('FROM ARTMARQUE');
            FDQuery.SQL.Add('  JOIN K ON (K_ID = MRK_ID AND K_ENABLED = 1 AND K_ID != 0)');
            FDQuery.SQL.Add('ORDER BY MRK_NOM;');
            ChargerRequete(FDQuery, 'MRK_CODE', 'MRK_NOM', FValsBaseDonnees);
          end;
        trFournisseurs:
          begin
            FDQuery.SQL.Add('SELECT DISTINCT FOU_CODE, FOU_NOM');
            FDQuery.SQL.Add('FROM ARTFOURN');
            FDQuery.SQL.Add('  JOIN K ON (K_ID = FOU_ID AND K_ENABLED = 1 AND FOU_ID != 0)');
            FDQuery.SQL.Add('ORDER BY FOU_NOM;');
            ChargerRequete(FDQuery, 'FOU_CODE', 'FOU_NOM', FValsBaseDonnees);
          end;
        trNomenclature:
          begin
            FDQuery.SQL.Add('SELECT DISTINCT UNI_CODE, UNI_NOM, SEC_CODE, SEC_NOM, RAY_CODE, RAY_NOM,');
            FDQuery.SQL.Add('       FAM_CODE, FAM_NOM, SSF_CODE, SSF_NOM, SSF_CODEFINAL');
            FDQuery.SQL.Add('FROM NKLUNIVERS');
            FDQuery.SQL.Add('  JOIN K KUNI         ON (KUNI.K_ID = UNI_ID AND KUNI.K_ENABLED = 1 AND KUNI.K_ID != 0)');
            FDQuery.SQL.Add('  JOIN NKLSECTEUR     ON (SEC_UNIID = UNI_ID)');
            FDQuery.SQL.Add('  JOIN K KSEC         ON (KSEC.K_ID = SEC_ID AND KSEC.K_ENABLED = 1 AND KSEC.K_ID != 0)');
            FDQuery.SQL.Add('  JOIN NKLRAYON       ON (RAY_SECID = SEC_ID)');
            FDQuery.SQL.Add('  JOIN K KRAY         ON (KRAY.K_ID = RAY_ID AND KRAY.K_ENABLED = 1 AND KRAY.K_ID != 0)');
            FDQuery.SQL.Add('  JOIN NKLFAMILLE     ON (FAM_RAYID = RAY_ID)');
            FDQuery.SQL.Add('  JOIN K KFAM         ON (KFAM.K_ID = FAM_ID AND KFAM.K_ENABLED = 1 AND KFAM.K_ID != 0)');
            FDQuery.SQL.Add('  JOIN NKLSSFAMILLE   ON (SSF_FAMID = FAM_ID)');
            FDQuery.SQL.Add('  JOIN K KSSF         ON (KSSF.K_ID = SSF_ID AND KSSF.K_ENABLED = 1 AND KSSF.K_ID != 0)');
            FDQuery.SQL.Add('WHERE UNI_OBLIGATOIRE = 1');
            FDQuery.SQL.Add('ORDER BY UNI_NOM, SEC_NOM, RAY_NOM, FAM_NOM, SSF_NOM;');
            { DONE 5 -oLP -cCode : Gérer le chargement de nomenclature de la base de données. }
            ChargerRequeteNkl(FDQuery, 'UNI_CODE', 'UNI_NOM', 'SEC_CODE', 'SEC_NOM', 'RAY_CODE', 'RAY_NOM', 'FAM_CODE',
              'FAM_NOM', 'SSF_CODE', 'SSF_NOM', 'SSF_CODEFINAL', FValsBaseDonneesNkl);
          end;
      end;

      if Terminated then
        Exit;
    finally
      FDConnection.Close();
    end;
{$ENDREGION 'Lecture de la base de données'}

    // Calcul des correspondances
    Progression(RS_MSG_CALCUL_CORRESP, 0);
    Journaliser(RS_MSG_CALCUL_CORRESP);

    case TypeReferentiel of
      trMarques, trFournisseurs:
        CalculerCorrespondances();
    end;

    if Terminated then
      Exit;

    // Enregistre les correspondances dans le fichier Excel
    Progression(RS_MSG_ENR_CORRESP, 0);

    case TypeReferentiel of
      trMarques, trFournisseurs:
        EnregistrerCorrespondancesExcel();
      trNomenclature:
        { DONE 5 -oLP -cCode : Gérer l'enregistrement des nomenclatures dans le fichier Excel. }
        EnregistrerCorrespondancesExcelNkl();
    end;

    if Terminated then
      Exit;
  except
    on E: Exception do
    begin
      FErreur    := True;
      FMsgErreur := Format('%s'#160': %s.', [E.ClassName, E.Message]);
      Journaliser(RS_ERREUR_ENREGISTREMENT + sLineBreak + FMsgErreur, NivArret);
    end;
  end;
end;

// Charge le contenu du fichier
function TThreadCorrespondances.ChargerFichier(const AFichier: TFileName; const AChampCode, AChampNom: string;
  var ACodesValeurs: TCodesValeurs): Boolean;
var
  sLigne               : string;
  slLigne              : TStringList;
  tfFichier            : TextFile;
  CodeValeur           : TCodeValeur;
  iIndexCode, iIndexNom: Integer;
begin
  Result := False;

  // Vide la liste
  ACodesValeurs.Clear();

  // Charge le fichier à lire
  AssignFile(tfFichier, AFichier);

  if Terminated then
    Exit;

  // Ouvre le fichier
{$I-} // Évite les exceptions lors de la lecture du fichier
  Reset(tfFichier);
{$I+}
  try
    // Créer la liste des valeurs
    slLigne                 := TStringList.Create();
    slLigne.Delimiter       := ';';
    slLigne.QuoteChar       := '''';
    slLigne.StrictDelimiter := True;

    // Lit la première ligne
    Readln(tfFichier, sLigne);
    slLigne.DelimitedText := sLigne;
    iIndexCode            := slLigne.IndexOf(AnsiQuotedStr(AChampCode, '"'));
    iIndexNom             := slLigne.IndexOf(AnsiQuotedStr(AChampNom, '"'));

    if Terminated then
      Exit;

    if (iIndexCode > -1) and (iIndexNom > -1) then
    begin
      // Lit le fichier ligne par ligne
      while not(Eof(tfFichier)) do
      begin
        Readln(tfFichier, sLigne);
        slLigne.DelimitedText := sLigne;

        CodeValeur        := TCodeValeur.Create();
        CodeValeur.Code   := AnsiDequotedStr(slLigne[iIndexCode], '"');
        CodeValeur.Valeur := AnsiDequotedStr(slLigne[iIndexNom], '"');
        ACodesValeurs.Add(CodeValeur);

        if Terminated then
          Exit;
      end;

      Result := True;
    end;
  finally
    // Ferme le fichier
    CloseFile(tfFichier);

    FreeAndNil(slLigne);
  end;
end;

function TThreadCorrespondances.ChargerFichierNkl(const AFichier: TFileName;
  const AChampUniCode, AChampUniNom, AChampSecCode, AChampSecNom, AChampRayCode, AChampRayNom, AChampFamCode,
  AChampFamNom, AChampSsfCode, AChampSsfNom, AChampCodeFinal: string; var ACodesValeursNkl: TCodesValeursNkl): Boolean;
var
  sLigne                     : string;
  slLigne                    : TStringList;
  tfFichier                  : TextFile;
  CodeValeurNkl              : TCodeValeurNkl;
  iIndexUniCode, iIndexUniNom: Integer;
  iIndexSecCode, iIndexSecNom: Integer;
  iIndexRayCode, iIndexRayNom: Integer;
  iIndexFamCode, iIndexFamNom: Integer;
  iIndexSsfCode, iIndexSsfNom: Integer;
  iIndexCodeFinal            : Integer;
begin
  { DONE 5 -oLP -cCode : Chargement du fichier de nomenclature. }
  Result := False;

  // Vide la liste
  ACodesValeursNkl.Clear();

  // Charge le fichier à lire
  AssignFile(tfFichier, AFichier);

  if Terminated then
    Exit;

  // Ouvre le fichier
{$I-} // Évite les exceptions lors de la lecture du fichier
  Reset(tfFichier);
{$I+}
  try
    // Créer la liste des valeurs
    slLigne                 := TStringList.Create();
    slLigne.Delimiter       := ';';
    slLigne.QuoteChar       := '''';
    slLigne.StrictDelimiter := True;

    // Lit la première ligne
    Readln(tfFichier, sLigne);
    slLigne.DelimitedText := sLigne;
    iIndexUniCode         := slLigne.IndexOf(AnsiQuotedStr(AChampUniCode, '"'));
    iIndexUniNom          := slLigne.IndexOf(AnsiQuotedStr(AChampUniNom, '"'));
    iIndexSecCode         := slLigne.IndexOf(AnsiQuotedStr(AChampSecCode, '"'));
    iIndexSecNom          := slLigne.IndexOf(AnsiQuotedStr(AChampSecNom, '"'));
    iIndexRayCode         := slLigne.IndexOf(AnsiQuotedStr(AChampRayCode, '"'));
    iIndexRayNom          := slLigne.IndexOf(AnsiQuotedStr(AChampRayNom, '"'));
    iIndexFamCode         := slLigne.IndexOf(AnsiQuotedStr(AChampFamCode, '"'));
    iIndexFamNom          := slLigne.IndexOf(AnsiQuotedStr(AChampFamNom, '"'));
    iIndexSsfCode         := slLigne.IndexOf(AnsiQuotedStr(AChampSsfCode, '"'));
    iIndexSsfNom          := slLigne.IndexOf(AnsiQuotedStr(AChampSsfNom, '"'));
    iIndexCodeFinal       := slLigne.IndexOf(AnsiQuotedStr(AChampCodeFinal, '"'));

    if Terminated then
      Exit;

    if (iIndexUniCode > -1) and (iIndexUniNom > -1) and (iIndexSecCode > -1) and (iIndexSecNom > -1) and
      (iIndexRayCode > -1) and (iIndexRayNom > -1) and (iIndexFamCode > -1) and (iIndexFamNom > -1) and
      (iIndexSsfCode > -1) and (iIndexSsfNom > -1) and (iIndexCodeFinal > -1) then
    begin
      // Lit le fichier ligne par ligne
      while not(Eof(tfFichier)) do
      begin
        Readln(tfFichier, sLigne);
        slLigne.DelimitedText := sLigne;

        // Charge les différentes parties
        CodeValeurNkl             := TCodeValeurNkl.Create();
        CodeValeurNkl.Univers     := AnsiDequotedStr(slLigne[iIndexUniNom], '"');
        CodeValeurNkl.Secteur     := AnsiDequotedStr(slLigne[iIndexSecNom], '"');
        CodeValeurNkl.Rayon       := AnsiDequotedStr(slLigne[iIndexRayNom], '"');
        CodeValeurNkl.Famille     := AnsiDequotedStr(slLigne[iIndexFamNom], '"');
        CodeValeurNkl.SousFamille := AnsiDequotedStr(slLigne[iIndexSsfNom], '"');
        CodeValeurNkl.CodeFinal   := AnsiDequotedStr(slLigne[iIndexCodeFinal], '"');
        ACodesValeursNkl.Add(CodeValeurNkl);

        if Terminated then
          Exit;
      end;

      Result := True;
    end;
  finally
    // Ferme le fichier
    CloseFile(tfFichier);

    FreeAndNil(slLigne);
  end;
end;

// Charge le contenu de la base de données
function TThreadCorrespondances.ChargerRequete(ADataSet: TFDQuery; const AChampCode, AChampNom: string;
  var ACodesValeurs: TCodesValeurs): Boolean;
var
  CodeValeur: TCodeValeur;
begin
  Result := False;

  // Vide la liste
  ACodesValeurs.Clear();

  try
    // Parcours la requête
    if not(ADataSet.Active) then
      ADataSet.Open();

    if Terminated then
      Exit;

    Progression(RS_MSG_LECTURE_BDD, 0, ADataSet.RecordCount);
    Journaliser(RS_MSG_LECTURE_BDD);

    ADataSet.First();

    while not(ADataSet.Eof) do
    begin
      Progression(Format(RS_MSG_LECTURE_BDD_NB, [ADataSet.RecNo, ADataSet.RecordCount]), ADataSet.RecNo);

      CodeValeur        := TCodeValeur.Create();
      CodeValeur.Code   := ADataSet.FieldByName(AChampCode).AsString;
      CodeValeur.Valeur := ADataSet.FieldByName(AChampNom).AsString;
      ACodesValeurs.Add(CodeValeur);

      ADataSet.Next();

      if Terminated then
        Exit;
    end;

    Result := True;
  finally
    // Ferme la requête
    ADataSet.Close();
  end;
end;

function TThreadCorrespondances.ChargerRequeteNkl(ADataSet: TFDQuery; const AChampUniCode, AChampUniNom, AChampSecCode,
  AChampSecNom, AChampRayCode, AChampRayNom, AChampFamCode, AChampFamNom, AChampSsfCode, AChampSsfNom,
  AChampCodeFinal: string; var ACodesValeursNkl: TCodesValeursNkl): Boolean;
var
  CodeValeurNkl: TCodeValeurNkl;
begin
  { DONE 5 -oLP -cCode : Chargement de nomenclature de la base de données. }
  Result := False;

  // Vide la liste
  ACodesValeursNkl.Clear();

  try
    // Parcours la requête
    if not(ADataSet.Active) then
      ADataSet.Open();

    if Terminated then
      Exit;

    Progression(RS_MSG_LECTURE_BDD, 0, ADataSet.RecordCount);
    Journaliser(RS_MSG_LECTURE_BDD);

    ADataSet.First();

    while not(ADataSet.Eof) do
    begin
      Progression(Format(RS_MSG_LECTURE_BDD_NB, [ADataSet.RecNo, ADataSet.RecordCount]), ADataSet.RecNo);

      // Charge les différentes parties
      CodeValeurNkl             := TCodeValeurNkl.Create();
      CodeValeurNkl.Univers     := ADataSet.FieldByName(AChampUniNom).AsString;
      CodeValeurNkl.Secteur     := ADataSet.FieldByName(AChampSecNom).AsString;
      CodeValeurNkl.Rayon       := ADataSet.FieldByName(AChampRayNom).AsString;
      CodeValeurNkl.Famille     := ADataSet.FieldByName(AChampFamNom).AsString;
      CodeValeurNkl.SousFamille := ADataSet.FieldByName(AChampSsfNom).AsString;
      CodeValeurNkl.CodeFinal   := ADataSet.FieldByName(AChampCodeFinal).AsString;
      ACodesValeursNkl.Add(CodeValeurNkl);

      ADataSet.Next();

      if Terminated then
        Exit;
    end;

    Result := True;
  finally
    // Ferme la requête
    ADataSet.Close();
  end;
end;

// Calcul les correspondances entre le fichier et la BDD
procedure TThreadCorrespondances.CalculerCorrespondances();
var
  i, j, iIndexFichier: Integer;
  Fiabilite          : TFiabilite;
  Correspondance     : TCorrespondance;
begin
  Progression(RS_MSG_CALCUL_CORRESP, 0, FValsBaseDonnees.Count);
  Journaliser(RS_MSG_CALCUL_CORRESP);

  // Parcours les éléments récupérés de la base de données pour trouver leurs correspondances
  for i := 0 to FValsBaseDonnees.Count - 1 do
  begin
    Progression(Format(RS_MSG_CALCUL_CORRESP_NB, [i, FValsBaseDonnees.Count]), i);

    iIndexFichier := -1;
    Fiabilite     := fiabAucune;

    // Trouve la meilleur correspondance dans le fichier
    for j := 0 to FValsFichier.Count - 1 do
    begin
      if AnsiSameText(FValsBaseDonnees[i].Valeur, FValsFichier[j].Valeur) then
      begin
        Fiabilite     := fiabExacte;
        iIndexFichier := j;
      end;

      if AnsiSameText(FValsBaseDonnees[i].Code, FValsFichier[j].Code) and not(Fiabilite = fiabExacte) then
      begin
        Fiabilite     := fiabMemeCode;
        iIndexFichier := j;
      end;

      if Terminated then
        Exit;
    end;

    // Enregistre le résultat
    if Fiabilite <> fiabAucune then
    begin
      Correspondance := TCorrespondance.Create(FValsBaseDonnees[i].Code, FValsBaseDonnees[i].Valeur,
        FValsFichier[iIndexFichier].Code, FValsFichier[iIndexFichier].Valeur, Fiabilite);
    end
    else
    begin
      Correspondance := TCorrespondance.Create(FValsBaseDonnees[i].Code, FValsBaseDonnees[i].Valeur, '', '', Fiabilite);
    end;
    FCorrespondances.Add(Correspondance);

    if Terminated then
      Exit;
  end;
end;

// Enregistre les correspondances dans un fichier Excel
procedure TThreadCorrespondances.EnregistrerCorrespondancesExcel();
var
  XLSXApplication: Variant; // ExcelApplication;
  XLSXFichier    : Variant; // ExcelWorkbook;
  XLSXFeuille    : Variant; // ExcelWorksheet;
  XSLXCellule    : Variant; // ExcelRange;
  sCellule       : string;
  sPlageValid    : string;
  sPlageCorresp  : string;
  i              : Integer;
begin
  try
    try
      // Ouvre Excel
      CoInitialize(nil);
      XLSXApplication         := CreateOleObject('Excel.Application');
      XLSXApplication.Visible := False;

      if Terminated then
        Exit;

      // Ouvre le fichier
      XLSXFichier := XLSXApplication.Workbooks.Open(FichierExcelModele);

{$REGION 'Enregistre le référentiel'}
      Progression(Format(RS_MSG_ENR_CORRESP_FEUIL, ['Référentiel']), 0, FValsFichier.Count);
      Journaliser(Format(RS_MSG_ENR_CORRESP_FEUIL, ['Référentiel']));

      XLSXFeuille := XLSXFichier.WorkSheets['Référentiel'];

      for i := 0 to FValsFichier.Count - 1 do
      begin
        Progression(Format(RS_MSG_ENR_CORRESP_FEUIL_NB, ['Référentiel', i + 1, FValsFichier.Count]), i + 1);

        sCellule          := Format('A%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsFichier[i].Valeur;
        sCellule          := Format('B%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := '''' + FValsFichier[i].Code;

        if Terminated then
        begin
          XLSXFichier.Close(False);
          Exit;
        end;
      end;

      // Enregistre la plage des libellés
      sPlageValid := Format('=Référentiel!$A$%u:$A$%u', [2, FValsFichier.Count + 1]);

      // Protège la feuille
      XLSXFeuille.Protect(
        // Password
        'ch@mon1x',
        // DrawingObjects
        True,
        // Contents
        True,
        // Scenarios
        True,
        // UserInterfaceOnly
        True,
        // AllowFormattingCells
        False,
        // AllowFormattingColumns
        False,
        // AllowFormattingRows
        False,
        // AllowInsertingColumns
        False,
        // AllowInsertingRows
        False,
        // AllowInsertingHyperlinks
        False,
        // AllowDeletingColumns
        False,
        // AllowDeletingRows
        False,
        // AllowSorting
        True,
        // AllowFiltering
        True,
        // AllowUsingPivotTables
        False);
{$ENDREGION 'Enregistre le référentiel'}
{$REGION 'Enregistre les correspondances'}
      Progression(Format(RS_MSG_ENR_CORRESP_FEUIL, ['Correspondances']), 0, FCorrespondances.Count);
      Journaliser(Format(RS_MSG_ENR_CORRESP_FEUIL, ['Correspondances']));

      XLSXFeuille := XLSXFichier.WorkSheets['Correspondances'];

      for i := 0 to FCorrespondances.Count - 1 do
      begin
        Progression(Format(RS_MSG_ENR_CORRESP_FEUIL_NB, ['Correspondances', i + 1, FCorrespondances.Count]), i + 1);

        sCellule          := Format('A%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FCorrespondances[i].BaseDonnees.Valeur;

        sCellule          := Format('B%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := '''' + FCorrespondances[i].BaseDonnees.Code;

        sCellule          := Format('C%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FCorrespondances[i].Fichier.Valeur;

        if Terminated then
        begin
          XLSXFichier.Close(False);
          Exit;
        end;
      end;

      // Enregistre la plage des correspondances
      sPlageCorresp := Format('C%u:C%u', [2, FCorrespondances.Count + 1]);

      // Ajout la validation avec la plage des libellées
      XSLXCellule        := XLSXFeuille.Range[sPlageCorresp];
      XSLXCellule.Locked := False;
      XSLXCellule.Validation.Add(xlValidateList, xlValidAlertInformation, xlBetween, sPlageValid, '');

      // Protège la feuille
      XLSXFeuille.Protect(
        // Password
        'ch@mon1x',
        // DrawingObjects
        True,
        // Contents
        True,
        // Scenarios
        True,
        // UserInterfaceOnly
        True,
        // AllowFormattingCells
        False,
        // AllowFormattingColumns
        False,
        // AllowFormattingRows
        False,
        // AllowInsertingColumns
        False,
        // AllowInsertingRows
        False,
        // AllowInsertingHyperlinks
        False,
        // AllowDeletingColumns
        False,
        // AllowDeletingRows
        False,
        // AllowSorting
        True,
        // AllowFiltering
        True,
        // AllowUsingPivotTables
        False);
{$ENDREGION 'Enregistre les correspondances'}
      // Active l'onglet "Correspondances"
      XLSXFeuille := XLSXFichier.WorkSheets['Correspondances'];
      XLSXFeuille.Activate;

      // Enregistre et ferme le fichier
      Journaliser(Format(RS_MSG_ENR_FICHIER, [FichierExcel]));
      XLSXFichier.Close(True, FichierExcel);
    except
      XLSXFichier.Close(False);
      raise;
    end;
  finally
    XSLXCellule     := Unassigned;
    XLSXFeuille     := Unassigned;
    XLSXFichier     := Unassigned;
    XLSXApplication := Unassigned;
    CoUnInitialize();
  end;
end;

procedure TThreadCorrespondances.EnregistrerCorrespondancesExcelNkl();
var
  XLSXApplication: OleVariant; // ExcelApplication;
  XLSXFichier    : OleVariant; // ExcelWorkbook;
  XLSXFeuille    : OleVariant; // ExcelWorksheet;
  XSLXCellule    : OleVariant; // ExcelRange;
  sCellule       : string;
  sPlageValid    : string;
  sPlageCorresp  : string;
  sFormule       : string;
  i              : Integer;
begin
  { DONE 5 -oLP -cCode : Enregistrement des nomenclatures dans le fichier Excel. }
  try
    try
      // Ouvre Excel
      CoInitialize(nil);
      XLSXApplication         := CreateOleObject('Excel.Application');
      XLSXApplication.Visible := False;

      if Terminated then
        Exit;

      // Ouvre le fichier
      XLSXFichier := XLSXApplication.Workbooks.Open(FichierExcelModele);

{$REGION 'Enregistre le référentiel'}
      Progression(Format(RS_MSG_ENR_CORRESP_FEUIL, ['Référentiel']), 0, FValsFichierNkl.Count);
      Journaliser(Format(RS_MSG_ENR_CORRESP_FEUIL, ['Référentiel']));

      XLSXFeuille := XLSXFichier.WorkSheets['Référentiel'];

      for i := 0 to FValsFichierNkl.Count - 1 do
      begin
        Progression(Format(RS_MSG_ENR_CORRESP_FEUIL_NB, ['Référentiel', i + 1, FValsFichierNkl.Count]), i + 1);

        sCellule          := Format('A%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := '''' + FValsFichierNkl[i].CodeFinal;

        sCellule          := Format('B%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsFichierNkl[i].Univers;

        sCellule          := Format('C%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsFichierNkl[i].Secteur;

        sCellule          := Format('D%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsFichierNkl[i].Rayon;

        sCellule          := Format('E%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsFichierNkl[i].Famille;

        sCellule          := Format('F%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsFichierNkl[i].SousFamille;

        if Terminated then
        begin
          XLSXFichier.Close(False);
          Exit;
        end;
      end;

      // Enregistre la plage des libellés
      sPlageValid := Format('=Référentiel!$A$%u:$A$%u', [2, FValsFichierNkl.Count + 1]);

      // Protège la feuille
      XLSXFeuille.Protect(
        // Password
        'ch@mon1x',
        // DrawingObjects
        True,
        // Contents
        True,
        // Scenarios
        True,
        // UserInterfaceOnly
        True,
        // AllowFormattingCells
        False,
        // AllowFormattingColumns
        False,
        // AllowFormattingRows
        False,
        // AllowInsertingColumns
        False,
        // AllowInsertingRows
        False,
        // AllowInsertingHyperlinks
        False,
        // AllowDeletingColumns
        False,
        // AllowDeletingRows
        False,
        // AllowSorting
        True,
        // AllowFiltering
        True,
        // AllowUsingPivotTables
        False);
{$ENDREGION 'Enregistre le référentiel'}
{$REGION 'Enregistre les correspondances'}
      Progression(Format(RS_MSG_ENR_CORRESP_FEUIL, ['Correspondances']), 0, FValsBaseDonneesNkl.Count);
      Journaliser(Format(RS_MSG_ENR_CORRESP_FEUIL, ['Correspondances']));

      XLSXFeuille := XLSXFichier.WorkSheets['Correspondances'];

      for i := 0 to FValsBaseDonneesNkl.Count - 1 do
      begin
        Progression(Format(RS_MSG_ENR_CORRESP_FEUIL_NB, ['Correspondances', i + 1, FValsBaseDonneesNkl.Count]), i + 1);

        sCellule          := Format('A%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := '''' + FValsBaseDonneesNkl[i].CodeFinal;

        sCellule          := Format('B%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsBaseDonneesNkl[i].Univers;

        sCellule          := Format('C%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsBaseDonneesNkl[i].Secteur;

        sCellule          := Format('D%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsBaseDonneesNkl[i].Rayon;

        sCellule          := Format('E%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsBaseDonneesNkl[i].Famille;

        sCellule          := Format('F%u', [i + 2]);
        XSLXCellule       := XLSXFeuille.Range[sCellule];
        XSLXCellule.Value := FValsBaseDonneesNkl[i].SousFamille;

        if Terminated then
        begin
          XLSXFichier.Close(False);
          Exit;
        end;
      end;

      // Enregistre la plage des correspondances
      sPlageCorresp := Format('G%u:G%u', [2, FValsBaseDonneesNkl.Count + 1]);

      // Ajout la validation avec la plage des libellées
      XSLXCellule        := XLSXFeuille.Range[sPlageCorresp];
      XSLXCellule.Locked := False;
      XSLXCellule.Validation.Add(xlValidateList, xlValidAlertInformation, xlBetween, sPlageValid, '');

      // Protège la feuille
      XLSXFeuille.Protect(
        // Password
        'ch@mon1x',
        // DrawingObjects
        True,
        // Contents
        True,
        // Scenarios
        True,
        // UserInterfaceOnly
        True,
        // AllowFormattingCells
        False,
        // AllowFormattingColumns
        False,
        // AllowFormattingRows
        False,
        // AllowInsertingColumns
        False,
        // AllowInsertingRows
        False,
        // AllowInsertingHyperlinks
        False,
        // AllowDeletingColumns
        False,
        // AllowDeletingRows
        False,
        // AllowSorting
        True,
        // AllowFiltering
        True,
        // AllowUsingPivotTables
        False);
{$ENDREGION 'Enregistre les correspondances'}
      // Active l'onglet "Correspondances"
      XLSXFeuille := XLSXFichier.WorkSheets['Correspondances'];
      XLSXFeuille.Activate;

      // Enregistre et ferme le fichier
      Journaliser(Format(RS_MSG_ENR_FICHIER, [FichierExcel]));
      XLSXFichier.Close(True, FichierExcel);
    except
      XLSXFichier.Close(False);
      raise;
    end;
  finally
    XSLXCellule     := Unassigned;
    XLSXFeuille     := Unassigned;
    XLSXFichier     := Unassigned;
    XLSXApplication := Unassigned;
    CoUnInitialize();
  end;
end;

end.
