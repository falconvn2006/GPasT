unit Integration.Thread.Lot1;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  System.StrUtils,
  System.Math,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.StorageXML,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Integration.Ressources,
  Integration.Methodes;

type
{$REGION 'Classes pour la vérification de la cohérence des modèles à intégrer'}
  TRaisonErreur = (RaiAucune, RaiEANManquant, RaiTropTailles, RaiArchive, RaiTaillesDoubles, RaiCouleursDoubles);

  TModeleErreur = class
    Chrono: string;
    Raison: TRaisonErreur;
  end;

  TListeModelesErreur = TObjectList<TModeleErreur>;

  TCouleur = class
  strict private
    { Déclarations privées }
    FCouleur: string;
    FEAN    : string;
    FCodeArt: string;
  published
    { Déclarations publiées }
    constructor Create(const ACouleur, AEAN, ACodeArt: string); reintroduce;
  public
    { Déclarations publiques }
    property Couleur: string
      read   FCouleur
      write  FCouleur;
    property EAN: string
      read   FEAN;
    property CodeArt: string
      read   FCodeArt;
  end;

  TTailleCouleurs = class
  strict private
    { Déclarations privées }
    FCouleurs: TObjectList<TCouleur>;
    FTaille  : string;
  published
    { Déclarations publiées }
    constructor Create(const ATaille: string); reintroduce;
    destructor Destroy(); override;
  public
    { Déclarations publiques }
    function AjouterCouleur(const ACouleur, AEAN, ACodeArt: string; const AModification: Boolean): Boolean;
    property Couleurs: TObjectList<TCouleur>
      read   FCouleurs;
    property Taille: string
      read   FTaille
      write  FTaille;
  end;

  TModele = class
  strict private
    { Déclarations privées }
    FTaillesCouleurs: TObjectList<TTailleCouleurs>;
    FChrono         : string;
    FArchive        : Boolean;
    FRaisonErreur   : TRaisonErreur;
  published
    { Déclarations publiées }
    constructor Create(const AChrono: string; const AArchive: Boolean = False); reintroduce;
    destructor Destroy(); override;
  public
    { Déclarations publiques }
    function AjouterTailleCouleur(ATaille, ACouleur, AEAN, ACodeArt: string; const AModification: Boolean): Boolean;
    property TaillesCouleurs: TObjectList<TTailleCouleurs>
      read   FTaillesCouleurs;
    property Chrono: string
      read   FChrono;
    property Archive: Boolean
      read   FArchive
      write  FArchive;
    property RaisonErreur: TRaisonErreur
      read   FRaisonErreur;
  end;

  TModeles = class
  strict private
    { Déclarations privées }
    FModeles: TObjectList<TModele>;
  published
    { Déclarations publiées }
    constructor Create(); reintroduce;
    destructor Destroy(); override;
  public
    { Déclarations publiques }
    function AjouterArticle(const AChrono, ATaille, ACouleur, AEAN, ACodeArt: string; const AModification: Boolean; const AArchive: Boolean = False): Boolean;
    function VerifierModeles(out AModelesErreur: TListeModelesErreur): Integer;
    property Modeles: TObjectList<TModele>
      read   FModeles;
  end;
{$ENDREGION 'Classes pour la vérification de la cohérence des modèles à intégrer'}

{$REGION 'Classes pour récupérer l’occurence des articles à l’intérieur des modèles'}

  TTailleCouleurSKU = class
  strict private
    { Déclarations privées }
    FTaille : string;
    FCouleur: string;
  published
    { Déclarations publiées }
    constructor Create(const ATaille, ACouleur: string); reintroduce;
  public
    { Déclarations publiques }
    property Taille: string
      read   FTaille;
    property Couleur: string
      read   FCouleur;
  end;

  TModeleSKU = class
  strict private
    { Déclarations privées }
    FTaillesCouleursSKU: TObjectList<TTailleCouleurSKU>;
    FChrono            : string;
  published
    { Déclarations publiées }
    constructor Create(const AChrono: string); reintroduce;
    destructor Destroy(); override;
  public
    { Déclarations publiques }
    function AjouterTailleCouleur(const ATaille, ACouleur: string): Boolean;
    property TaillesCouleursSKU: TObjectList<TTailleCouleurSKU>
      read   FTaillesCouleursSKU;
    property Chrono: string
      read   FChrono;
  end;

  TModelesSKU = class
  strict private
    { Déclarations privées }
    FModelesSKU: TObjectList<TModeleSKU>;
  published
    { Déclarations publiées }
    constructor Create(); reintroduce;
    destructor Destroy(); override;
  public
    { Déclarations publiques }
    function AjouterArticle(const AChrono, ATaille, ACouleur: string): Boolean;
    function OccurenceArticle(const AChrono, ATaille, ACouleur: string): Integer;
    property ModelesSKU: TObjectList<TModeleSKU>
      read   FModelesSKU;
  end;
{$ENDREGION 'Classes pour récupérer l’occurence des articles à l’intérieur des modèles'}

  TThreadLot1 = class(TThread)
  strict private
    { Déclarations privées }
    FIntegre    : Boolean;
    FDossier    : string;
    FCodeMagasin: string;
    procedure Journaliser(const AMessage: string; const ANiveau: TNiveau = NivTrace; const ASurcharge: Boolean = False);
  protected
    procedure Execute(); override;
  public
    { Déclarations publiques }
    BaseDonnees     : TFileName;
    FichierArticles : TFileName;
    LblProgression  : TLabel;
    PbProgression   : TProgressBar;
    ImgArticles     : TImage;
    iActId          : Integer;
    bSauvegarde     : Boolean;
    property Integre: Boolean
      read   FIntegre;
    property Dossier: string
      read   FDossier;
    property CodeMagasin: string
      read   FCodeMagasin;
  end;

implementation

uses
  Integration.Form.Principale;

{ TThreadLot1 }

procedure TThreadLot1.Execute();
var
  FDConnection        : TFDConnection;
  FDTransaction       : TFDTransaction;
  QueInfoDossier      : TFDQuery;
  QueIntegration      : TFDQuery;
  QueInfoModele       : TFDQuery;
  MemTFichier         : TFDMemTable;
  FDPhysIBDriverLink  : TFDPhysIBDriverLink;
  FDStanStorageXMLLink: TFDStanStorageXMLLink;
  cSeparateur         : Char;
  sSeparateur         : string;
  i, j                : Integer;
  slFichier           : TStringList;
  sdaLigne            : TStringDynArray;
  fsFrance            : TFormatSettings;
  flNombre            : Double;
  dtDate              : TDateTime;
  bErreurLigne        : Boolean;
  bErreurFloat        : Boolean;
  iRetour             : Integer;
  iRetourNKL          : Integer;
  iRetourEAN          : Integer;
  iNbErreur           : Integer;
  sRetourEAN          : string[6];
  sMessage            : string;
  sCheminDump         : string;
  Modeles             : TModeles;
  ModelesErreur       : TListeModelesErreur;
  ModelesSKU          : TModelesSKU;
  slListeChronos      : TStringList;
  sNomModele          : string;
begin
  // Récupère le séparateur
  if FindCmdLineSwitch('SEPARATEUR', sSeparateur) then
    cSeparateur := sSeparateur[1]
  else
    cSeparateur := SEPARATEUR;

  if FindCmdLineSwitch('VALIDER_ERREURS') then
    Journaliser(RS_VALIDE_ERREURS);

  FIntegre             := False;
  FDossier             := '';
  FCodeMagasin         := '';
  FDConnection         := TFDConnection.Create(nil);
  FDTransaction        := TFDTransaction.Create(nil);
  QueInfoDossier       := TFDQuery.Create(nil);
  QueIntegration       := TFDQuery.Create(nil);
  QueInfoModele        := TFDQuery.Create(nil);
  MemTFichier          := TFDMemTable.Create(nil);
  FDPhysIBDriverLink   := TFDPhysIBDriverLink.Create(nil);
  FDStanStorageXMLLink := TFDStanStorageXMLLink.Create(nil);
  slFichier            := TStringList.Create();
  slListeChronos       := TStringList.Create();

  // Charge les formats pour la France
  // -> http://msdn.microsoft.com/library/bb165625
  fsFrance := TFormatSettings.Create($40C);

  try
    PbProgression.Position := 0;

    LblProgression.Caption := Format(RS_CHARGEFICHIERLOT1, [ExtractFileName(FichierArticles)]);
    Journaliser(Format(RS_CHARGEFICHIERLOT1, [ExtractFileName(FichierArticles)]));

    // Initialise le nombre d'erreurs
    iNbErreur := 0;

    // Vérifie que le domaine d'activité est bien renseigné
    if iActId = 0 then
    begin
      Journaliser(RS_ERREUR_ACTIVITE, NivArret);
      Inc(iNbErreur);
      Exit;
    end;

{$REGION 'Connexion à la base de données'}
    try
      LblProgression.Caption := RS_CONNEXION;
      Journaliser(RS_CONNEXION);

      FDConnection.Params.Clear();
      FDConnection.Params.Add('DriverID=IB');
      FDConnection.Params.Add('User_Name=ginkoia');
      FDConnection.Params.Add('Password=ginkoia');
      FDConnection.Params.Add('Protocol=TCPIP');
      FDConnection.Params.Add('Server=localhost');
      FDConnection.Params.Add('Port=3050');
      FDConnection.Params.Add(Format('Database=%s', [BaseDonnees]));
      FDConnection.Transaction := FDTransaction;

      FDTransaction.Connection := FDConnection;

      QueInfoDossier.Connection  := FDConnection;
      QueInfoDossier.Transaction := FDTransaction;
      QueInfoDossier.SQL.Clear();
      QueInfoDossier.SQL.Add('SELECT BAS_NOMPOURNOUS, MAG_IDENT');
      QueInfoDossier.SQL.Add('FROM   GENBASES');
      QueInfoDossier.SQL.Add('  JOIN K KBAS       ON (KBAS.K_ID = BAS_ID AND KBAS.K_ENABLED = 1)');
      QueInfoDossier.SQL.Add('  JOIN GENPARAMBASE ON (BAS_IDENT = PAR_STRING AND PAR_NOM = ''IDGENERATEUR'')');
      QueInfoDossier.SQL.Add('  JOIN GENMAGASIN   ON (MAG_ID = BAS_MAGID)');
      QueInfoDossier.SQL.Add('  JOIN K KMAG       ON (KMAG.K_ID = MAG_ID AND KMAG.K_ENABLED = 1);');

      QueInfoDossier.Open();
      try
        if not(QueInfoDossier.IsEmpty()) then
        begin
          FDossier     := QueInfoDossier.FieldByName('BAS_NOMPOURNOUS').AsString;
          FCodeMagasin := QueInfoDossier.FieldByName('MAG_IDENT').AsString;
        end;
      finally
        QueInfoDossier.Close();
      end;

      Journaliser(RS_DEBUT, NivNotice, True);

      QueIntegration.Connection  := FDConnection;
      QueIntegration.Transaction := FDTransaction;
      QueIntegration.SQL.Clear();
      QueIntegration.SQL.Add('SELECT  RETOUR,');
      QueIntegration.SQL.Add('        RETOURNKL,');
      QueIntegration.SQL.Add('        RETOUREAN');
      QueIntegration.SQL.Add('FROM    EKOSPORT_INTEGRATION_LOT1(');
      QueIntegration.SQL.Add('          :IMPORT_MODE,');
      QueIntegration.SQL.Add('          :UUID,');
      QueIntegration.SQL.Add('          :EAN,');
      QueIntegration.SQL.Add('          :EAN_F1,');
      QueIntegration.SQL.Add('          :EAN_F2,');
      QueIntegration.SQL.Add('          :EAN_F3,');
      QueIntegration.SQL.Add('          :EAN_F4,');
      QueIntegration.SQL.Add('          :EAN_F5,');
      QueIntegration.SQL.Add('          :MARQUE,');
      QueIntegration.SQL.Add('          :REF_MARQUE,');
      QueIntegration.SQL.Add('          :ID_FOURNISSEUR,');
      QueIntegration.SQL.Add('          :FOURNISSEUR,');
      QueIntegration.SQL.Add('          :TAILLE,');
      QueIntegration.SQL.Add('          :ID_COULEUR,');
      QueIntegration.SQL.Add('          :COULEUR,');
      QueIntegration.SQL.Add('          :MASTER_ID,');
      QueIntegration.SQL.Add('          :MASTER_UUID,');
      QueIntegration.SQL.Add('          :MASTER_NAME,');
      QueIntegration.SQL.Add('          :COST_PRICE,');
      QueIntegration.SQL.Add('          :LIST_PRICE,');
      QueIntegration.SQL.Add('          :TAX_RATE,');
      QueIntegration.SQL.Add('          :DATE_CREATION,');
      QueIntegration.SQL.Add('          :CAT_ID_LEV1,');
      QueIntegration.SQL.Add('          :CAT_NAME_LEV1,');
      QueIntegration.SQL.Add('          :CAT_ID_LEV2,');
      QueIntegration.SQL.Add('          :CAT_NAME_LEV2,');
      QueIntegration.SQL.Add('          :CAT_ID_LEV3,');
      QueIntegration.SQL.Add('          :CAT_NAME_LEV3,');
      QueIntegration.SQL.Add('          :CAT_ID_LEV4,');
      QueIntegration.SQL.Add('          :CAT_NAME_LEV4,');
      QueIntegration.SQL.Add('          :PRIX_WEB,');
      QueIntegration.SQL.Add('          :PRIX_BRUT_FOURN,');
      QueIntegration.SQL.Add('          :ACTID,');
      QueIntegration.SQL.Add('          :NUM_OCCURENCE);');
      QueIntegration.Prepare();

      QueInfoModele.Connection  := FDConnection;
      QueInfoModele.Transaction := FDTransaction;
      QueInfoModele.SQL.Clear();
      QueInfoModele.SQL.Add('SELECT ARF_CHRONO, TGF_NOM, COU_NOM, CBI_CB, ARA_CODEART, ARF_ARCHIVER');
      QueInfoModele.SQL.Add('FROM   ARTREFERENCE');
      QueInfoModele.SQL.Add('  JOIN K KARF          ON (KARF.K_ID = ARF_ID AND KARF.K_ENABLED = 1 AND KARF.K_ID <> 0)');
      QueInfoModele.SQL.Add('  JOIN PLXTAILLESTRAV  ON (TTV_ARTID = ARF_ARTID)');
      QueInfoModele.SQL.Add('  JOIN K KTTV          ON (KTTV.K_ID = TTV_ID AND KTTV.K_ENABLED = 1)');
      QueInfoModele.SQL.Add('  JOIN PLXTAILLESGF    ON (TGF_ID = TTV_TGFID)');
      QueInfoModele.SQL.Add('  JOIN K KTGF          ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1 AND KTGF.K_ID <> 0)');
      QueInfoModele.SQL.Add('  JOIN PLXCOULEUR      ON (COU_ARTID = ARF_ARTID)');
      QueInfoModele.SQL.Add('  JOIN K KCOU          ON (KCOU.K_ID = COU_ID AND KCOU.K_ENABLED = 1 AND KCOU.K_ID <> 0)');
      QueInfoModele.SQL.Add('  JOIN ARTCODEBARRE    ON (CBI_ARFID = ARF_ID AND CBI_TGFID = TGF_ID AND CBI_COUID = COU_ID AND CBI_TYPE = 1)');
      QueInfoModele.SQL.Add('  JOIN K KCBI          ON (KCBI.K_ID = CBI_ID AND KCBI.K_ENABLED = 1 AND KCBI.K_ID <> 0)');
      QueInfoModele.SQL.Add('  JOIN ARTRELATIONART  ON (ARA_ARTID = ARF_ARTID AND ARA_TGFID = TGF_ID AND ARA_COUID = COU_ID)');
      QueInfoModele.SQL.Add('  JOIN K KARA          ON (KARA.K_ID = ARA_ID AND KARA.K_ENABLED = 1)');
      QueInfoModele.SQL.Add('WHERE  ARF_CHRONO = :CHRONO;');
      QueInfoModele.Prepare();
    except
      on e: Exception do
      begin
        Journaliser(Format(RS_ERREUR_CONNEXION, [e.ClassName, e.Message]), NivArret);
        FDTransaction.Rollback();
        Exit;
      end;
    end;

    // Arrête le thread si annulé
    if Self.Terminated then
      Exit;
{$ENDREGION 'Connexion à la base de données'}

{$REGION 'Création de la table en mémoire'}
    MemTFichier.FieldDefs.Clear();
    MemTFichier.FieldDefs.Add('IMPORT_MODE', ftString, 1, True);
    MemTFichier.FieldDefs.Add('UUID', ftString, 32, True);
    MemTFichier.FieldDefs.Add('SKU', ftString, 32, False);
    MemTFichier.FieldDefs.Add('EAN', ftString, 64, True);
    MemTFichier.FieldDefs.Add('EAN_F1', ftString, 64, False);
    MemTFichier.FieldDefs.Add('EAN_F2', ftString, 64, False);
    MemTFichier.FieldDefs.Add('EAN_F3', ftString, 64, False);
    MemTFichier.FieldDefs.Add('EAN_F4', ftString, 64, False);
    MemTFichier.FieldDefs.Add('EAN_F5', ftString, 64, False);
    MemTFichier.FieldDefs.Add('NOM', ftString, 64, False);
    MemTFichier.FieldDefs.Add('MARQUE', ftString, 64, True);
    MemTFichier.FieldDefs.Add('REF_MARQUE', ftString, 64, False);
    MemTFichier.FieldDefs.Add('ID_FOURNISSEUR', ftString, 32, True);
    MemTFichier.FieldDefs.Add('FOURNISSEUR', ftString, 64, True);
    MemTFichier.FieldDefs.Add('TAILLE', ftString, 64, True);
    MemTFichier.FieldDefs.Add('ID_COULEUR', ftString, 64, False);
    MemTFichier.FieldDefs.Add('COULEUR', ftString, 64, False);
    MemTFichier.FieldDefs.Add('MASTER_ID', ftString, 32, True);
    MemTFichier.FieldDefs.Add('MASTER_UUID', ftString, 32, True);
    MemTFichier.FieldDefs.Add('MASTER_NAME', ftString, 64, True);
    MemTFichier.FieldDefs.Add('COST_PRICE', ftFloat, 0, True);
    MemTFichier.FieldDefs.Add('LIST_PRICE', ftFloat, 0, False);
    MemTFichier.FieldDefs.Add('TAX_RATE', ftFloat, 0, True);
    MemTFichier.FieldDefs.Add('DATE_CREATION', ftDateTime, 0, False);
    MemTFichier.FieldDefs.Add('CAT_ID_LEV1', ftString, 32, False);
    MemTFichier.FieldDefs.Add('CAT_NAME_LEV1', ftString, 64, True);
    MemTFichier.FieldDefs.Add('CAT_ID_LEV2', ftString, 32, False);
    MemTFichier.FieldDefs.Add('CAT_NAME_LEV2', ftString, 64, True);
    MemTFichier.FieldDefs.Add('CAT_ID_LEV3', ftString, 32, False);
    MemTFichier.FieldDefs.Add('CAT_NAME_LEV3', ftString, 64, True);
    MemTFichier.FieldDefs.Add('CAT_ID_LEV4', ftString, 32, False);
    MemTFichier.FieldDefs.Add('CAT_NAME_LEV4', ftString, 64, True);
    MemTFichier.FieldDefs.Add('EMPL', ftString, 128, False);
    MemTFichier.FieldDefs.Add('PRIX_WEB', ftFloat, 0, False);
    MemTFichier.FieldDefs.Add('PRIX_BRUT_FOURN', ftFloat, 0, True);
    MemTFichier.FieldDefs.Add('ACTID', ftInteger, 0, True);
    MemTFichier.FieldDefs.Add('NUM_OCCURENCE', ftInteger, 0, False);
    MemTFichier.FieldDefs.Add('NUMLIGNE', ftInteger, 0, True);

    // Arrête le thread si annulé
    if Self.Terminated then
      Exit;
{$ENDREGION 'Création de la table en mémoire'}

{$REGION 'Chargement du fichier en mémoire'}
    Journaliser(Format(RS_CHARGEMENT_FICHIER, [ExtractFileName(FichierArticles)]), NivNotice);
    slFichier.LoadFromFile(FichierArticles);
    MemTFichier.Open();

    PbProgression.Max := slFichier.Count;

{$REGION 'Vérifie l’en-tête du fichier'}
    sdaLigne := SplitString(slFichier[0], cSeparateur);

    if Length(sdaLigne) <> MemTFichier.FieldDefs.Count - 3 then
      Journaliser(RS_ATTENTIONENTETELOT1_NBCHAMPS, NivNotice);

    for i := 0 to MemTFichier.FieldDefs.Count - 4 do
    begin
      if not(SameText(MemTFichier.FieldDefs[i].Name, sdaLigne[i])) then
      begin
        Journaliser(Format(RS_ERREURENTETELOT1_NOMCHAMP, [MemTFichier.FieldDefs[i].Name, sdaLigne[i]]), NivErreur);
        Exit;
      end;
    end;
{$ENDREGION 'Vérifie l’en-tête du fichier'}

    // Vérification des lignes du fichier
    ModelesSKU := TModelesSKU.Create();
    try
      PbProgression.Position := 0;
      PbProgression.Max      := slFichier.Count - 1;
      MemTFichier.BeginBatch();
      for i := 1 to slFichier.Count - 1 do
      begin
        PbProgression.Position := i;
        sdaLigne               := SplitString(slFichier[i], cSeparateur);
        bErreurLigne           := False;

{$REGION 'Vérifie de la validité de la ligne'}
        // Vérifie que les champs requis sont renseignés
        for j := 0 to Length(sdaLigne) - 2 do
        begin
          bErreurLigne := False;

          // Vérifie que le mode d'import est correct
          if SameText(MemTFichier.FieldDefs[j].Name, 'IMPORT_MODE')
            and not(AnsiMatchStr(sdaLigne[j], ['C', 'U', 'D'])) then
          begin
            Journaliser(Format(RS_ERREURLIGNELOT1_MODEIMPORT, [i]), NivErreur);

            // Arrête le thread si annulé
            if Self.Terminated then
              Exit;

            Inc(iNbErreur);
            bErreurLigne := True;
            Break;
          end;

          // Vérifie que le code-barres généré par DataSolution est correct
          if SameText(MemTFichier.FieldDefs[j].Name, 'EAN')
            and not(VerifEAN13(sdaLigne[j])) then
          begin
            Journaliser(Format(RS_ERREURLIGNELOT1_TAILLEEAN, [i, sdaLigne[j]]), NivErreur);

            // Arrête le thread si annulé
            if Self.Terminated then
              Exit;

            Inc(iNbErreur);
            bErreurLigne := True;
            Break;
          end;

          // Met un point par défaut pour la nomenclature si elle n'est pas renseignée
          if StartsText('CAT_NAME_LEV', MemTFichier.FieldDefs[j].Name)
            and (sdaLigne[j] = '') then
            sdaLigne[j] := '.';

          // Vérifie que le champ n'est pas vide
          if MemTFichier.FieldDefs[j].Required
            and (sdaLigne[j] = '') then
          begin
            Journaliser(Format(RS_ERREURLIGNELOT1_CHAMPREQUI, [i, MemTFichier.FieldDefs[j].Name]), NivErreur);
            Inc(iNbErreur);
            bErreurLigne := True;
            Break;
          end;

          // Vérifie que le format de données est correcte
          if sdaLigne[j] <> '' then
          begin
            case MemTFichier.FieldDefs[j].DataType of
              ftString:
                begin
                  // Vérifie la taille de la chaîne
                  if Length(sdaLigne[j]) > MemTFichier.FieldDefs[j].Size then
                  begin
                    Journaliser(Format(RS_ERREURLIGNELOT1_MVFORMAT, [i, MemTFichier.FieldDefs[j].Name, Format('STRING(%d)', [MemTFichier.FieldDefs[j].Size])]), NivErreur);
                    Inc(iNbErreur);
                    bErreurLigne := True;
                    Break;
                  end;
                end;
              ftFloat:
                begin
                  // Vérifie le format du nombre à virgule
                  bErreurFloat := not(TryStrToFloat(sdaLigne[j], flNombre, fsFrance));
                  if bErreurFloat
                    or not((-99999999999.9999999 <= flNombre) and (flNombre <= 99999999999.9999999)) then
                  begin
                    Journaliser(Format(RS_ERREURLIGNELOT1_MVFORMAT, [i, MemTFichier.FieldDefs[j].Name, 'NUMERIC(18,7)']), NivErreur);
                    Inc(iNbErreur);
                    bErreurLigne := True;
                    Break;
                  end;
                end;
              ftDateTime:
                begin
                  // Vérifie le format de la date
                  if not(TryIso8601BasicToDate(sdaLigne[j], dtDate)) then
                  begin
                    Journaliser(Format(RS_ERREURLIGNELOT1_MVFORMAT, [i, MemTFichier.FieldDefs[j].Name, 'AAAAMMJJ']), NivErreur);
                    Inc(iNbErreur);
                    bErreurLigne := True;
                    Break;
                  end;
                end;
            end;
          end;

          // Arrête le thread si annulé
          if Self.Terminated then
            Exit;
        end;
{$ENDREGION 'Vérifie de la validité de la ligne'}

{$REGION 'Ajoute la ligne à la table en mémoire'}
        if not(bErreurLigne) then
        begin
          MemTFichier.Append();

          MemTFichier.FieldByName('NUMLIGNE').AsInteger := Succ(i);

          for j := 0 to Length(sdaLigne) - 1 do
          begin
            case MemTFichier.Fields[j].DataType of
              ftString:
                begin
                  MemTFichier.Fields[j].AsString := sdaLigne[j];
                end;
              ftFloat:
                begin
                  MemTFichier.Fields[j].AsFloat := StrToFloat(sdaLigne[j], fsFrance);
                end;
              ftDateTime:
                begin
                  TryIso8601BasicToDate(sdaLigne[j], dtDate);
                  MemTFichier.Fields[j].AsDateTime := dtDate;
                end;
            end;
          end;

          MemTFichier.FieldByName('ACTID').AsInteger := iActId;

          // Ajout l'article à la liste déjà présente pour avoir son occurence
          ModelesSKU.AjouterArticle(
            MemTFichier.FieldByName('MASTER_ID').AsString,
            MemTFichier.FieldByName('TAILLE').AsString,
            MemTFichier.FieldByName('COULEUR').AsString);

          // Enregistre l'occurence de l'article
          MemTFichier.FieldByName('NUM_OCCURENCE').AsInteger := ModelesSKU.OccurenceArticle(
            MemTFichier.FieldByName('MASTER_ID').AsString,
            MemTFichier.FieldByName('TAILLE').AsString,
            MemTFichier.FieldByName('COULEUR').AsString);

          MemTFichier.Post();
        end;
{$ENDREGION 'Ajoute la ligne à la table en mémoire'}

        // Arrête le thread si annulé
        if Self.Terminated then
          Exit;
      end;
      MemTFichier.EndBatch();
    finally
      ModelesSKU.Free();
    end;

{$IFDEF DEBUG}
    if bSauvegarde then
    begin
      try
        sCheminDump := ChangeFileExt(FichierArticles, '.xml');
        Journaliser(Format(RS_VIDANGE, [sCheminDump]));
        MemTFichier.SaveToFile(sCheminDump, sfXML);
      except
        on e: Exception do
          Journaliser(Format(RS_ERREUR_VIDANGE, [e.ClassName, e.Message]), NivErreur);
      end;
    end;
{$ENDIF}

{$ENDREGION 'Chargement du fichier en mémoire'}

{$REGION 'Vérification de la cohérence des EAN à la taille/couleur'}
    Modeles := TModeles.Create();
    try
      PbProgression.Position := 0;
      LblProgression.Caption := Format(RS_VERIFICATION_COHERENCE, [1]);
      Journaliser(Format(RS_VERIFICATION_COHERENCE, [1]));

      // Récupère tout les modèles du MemTable
      PbProgression.Max := MemTFichier.RecordCount;
      MemTFichier.First();
      slListeChronos.Clear();

      while not(MemTFichier.Eof) do
      begin
        // Ajoute l'article de la ligne
        Modeles.AjouterArticle(
          MemTFichier.FieldByName('MASTER_ID').AsString,
          MemTFichier.FieldByName('TAILLE').AsString,
          MemTFichier.FieldByName('COULEUR').AsString,
          MemTFichier.FieldByName('EAN').AsString,
          MemTFichier.FieldByName('UUID').AsString,
          (MemTFichier.FieldByName('IMPORT_MODE').AsString = 'U'));

        // Ajoute le code chrono à la liste des codes à intégrer
        if (slListeChronos.IndexOf(MemTFichier.FieldByName('MASTER_ID').AsString) < 0) then
          slListeChronos.Add(MemTFichier.FieldByName('MASTER_ID').AsString);

        MemTFichier.Next();
        PbProgression.StepBy(1);

        // Arrête le thread si annulé
        if Self.Terminated then
          Exit;
      end;

      // Récupère le reste des modèles de la base de données
      PbProgression.Position := 0;
      PbProgression.Max      := slListeChronos.Count;
      LblProgression.Caption := Format(RS_VERIFICATION_COHERENCE, [2]);
      Journaliser(Format(RS_VERIFICATION_COHERENCE, [2]));

      for i := 0 to slListeChronos.Count - 1 do
      begin
        QueInfoModele.ParamByName('CHRONO').AsString := slListeChronos[i];
        QueInfoModele.Open();

        while not(QueInfoModele.Eof) do
        begin
          // Ajoute l'article de la base
          Modeles.AjouterArticle(
            QueInfoModele.FieldByName('ARF_CHRONO').AsString,
            QueInfoModele.FieldByName('TGF_NOM').AsString,
            QueInfoModele.FieldByName('COU_NOM').AsString,
            QueInfoModele.FieldByName('CBI_CB').AsString,
            QueInfoModele.FieldByName('ARA_CODEART').AsString,
            True,
            (QueInfoModele.FieldByName('ARF_ARCHIVER').AsInteger = 1));

          QueInfoModele.Next();

          // Arrête le thread si annulé
          if Self.Terminated then
            Exit;
        end;

        QueInfoModele.Close();
        PbProgression.StepBy(1);
      end;

      if Modeles.VerifierModeles(ModelesErreur) > 0 then
      begin
        MemTFichier.BeginBatch(True);

        for i := 0 to ModelesErreur.Count - 1 do
        begin
          while MemTFichier.LocateEx('MASTER_ID', ModelesErreur[i].Chrono, [lxoBackward, lxoCaseInsensitive], nil) do
          begin
            sNomModele := MemTFichier.FieldByName('MASTER_NAME').AsString;
            MemTFichier.Delete();
          end;

          case ModelesErreur[i].Raison of
            RaiEANManquant:
              begin
                Journaliser(Format(RS_ERREURARTICLE_EAN_MANQUANT, [ModelesErreur[i].Chrono, sNomModele]), NivErreur);
                Inc(iNbErreur);
              end;
            RaiTropTailles:
              begin
                Journaliser(Format(RS_ERREURARTICLE_TROP_TAILLES, [ModelesErreur[i].Chrono, sNomModele]), NivErreur);
                Inc(iNbErreur);
              end;
            RaiArchive:
              begin
                Journaliser(Format(RS_AVERTISSEMENT_ARCHIVE, [ModelesErreur[i].Chrono, sNomModele]), NivErreur);
              end;
            RaiTaillesDoubles:
              begin
                Journaliser(Format(RS_ERREURARTICLE_TAILLES_DOUBLES, [ModelesErreur[i].Chrono, sNomModele]), NivErreur);
                Inc(iNbErreur);
              end;
            RaiCouleursDoubles:
              begin
                Journaliser(Format(RS_ERREURARTICLE_COULEURS_DOUBLES, [ModelesErreur[i].Chrono, sNomModele]), NivErreur);
                Inc(iNbErreur);
              end;
          end;
        end;

        MemTFichier.EndBatch();
      end;

    finally
      ModelesErreur.Free();
      Modeles.Free();
    end;
{$ENDREGION 'Vérification de la cohérence des EAN à la taille/couleur'}

{$REGION 'Intégration des articles'}
    PbProgression.Position := 0;
    PbProgression.Max      := MemTFichier.RecordCount;
    LblProgression.Caption := Format(RS_LOT1_INTEGRATION, [0, MemTFichier.RecordCount, '', '', '', '']);
    MemTFichier.First();

    // Démarre la transaction
    FDTransaction.StartTransaction();

    // Parcours toutes les lignes récupérées du fichier
    while not(MemTFichier.Eof) do
    begin
      try
        // Prépare la procédure stockée pour l'intégration
        QueIntegration.Params.ClearValues();
        for i := 0 to QueIntegration.ParamCount - 1 do
        begin
          // Renseigne tous les paramètres de la procédure avec les valeurs du fichier
          QueIntegration.Params[i].Value := MemTFichier.FieldByName(QueIntegration.Params[i].Name).Value;
        end;

        // Exécute la procédure d'intégration
        if QueIntegration.Active then
          QueIntegration.Close();

        QueIntegration.Open();

        // Récupère les résultats de la procédure stockée
        iRetour    := QueIntegration.FieldByName('RETOUR').AsInteger;
        iRetourNKL := QueIntegration.FieldByName('RETOURNKL').AsInteger;
        iRetourEAN := QueIntegration.FieldByName('RETOUREAN').AsInteger;

{$REGION 'Interprète les retours'}
        // Retour de l'article
        if iRetour < 10 then
        begin
          // Valeurs de retours en création
          case iRetour of
            // État Ok
            CR_LOT1_OK:
              begin
                LblProgression.Caption := Format(RS_LOT1_INTEGRATION,
                  [MemTFichier.RecNo,
                   MemTFichier.RecordCount,
                   MemTFichier.FieldByName('UUID').AsString,
                   MemTFichier.FieldByName('MASTER_ID').AsString,
                   MemTFichier.FieldByName('MASTER_NAME').AsString,
                   MemTFichier.FieldByName('MASTER_UUID').AsString]);
                Journaliser(Format(RS_LOT1_INTEGRATION,
                  [MemTFichier.RecNo,
                   MemTFichier.RecordCount,
                   MemTFichier.FieldByName('UUID').AsString,
                   MemTFichier.FieldByName('MASTER_ID').AsString,
                   MemTFichier.FieldByName('MASTER_NAME').AsString,
                   MemTFichier.FieldByName('MASTER_UUID').AsString]));
              end;
            // Erreurs bloquantes
            CR_LOT1_MAUVAIS_MODE .. CR_LOT1_MODELE_NON_ARCHIVABLE:
              begin
                case AnsiIndexText(MemTFichier.FieldByName('IMPORT_MODE').AsString, ['C', 'U', 'D']) of
                  // Création
                  0:
                    sMessage := RS_ERREURARTICLE_CREATION;
                  // Modification
                  1:
                    sMessage := RS_ERREURARTICLE_MODIFICATION;
                  // Archivage
                  2:
                    sMessage := RS_ERREURARTICLE_ARCHIVAGE;
                end;

                LblProgression.Caption := Format(sMessage,
                  [MemTFichier.FieldByName('NUMLIGNE').AsInteger,
                   CR_LOT1_MESSAGES[iRetour],
                   MemTFichier.FieldByName('UUID').AsString,
                   MemTFichier.FieldByName('MASTER_ID').AsString,
                   MemTFichier.FieldByName('MASTER_NAME').AsString,
                   MemTFichier.FieldByName('MASTER_UUID').AsString]);
                Journaliser(Format(sMessage,
                  [MemTFichier.FieldByName('NUMLIGNE').AsInteger,
                   CR_LOT1_MESSAGES[iRetour],
                   MemTFichier.FieldByName('UUID').AsString,
                   MemTFichier.FieldByName('MASTER_ID').AsString,
                   MemTFichier.FieldByName('MASTER_NAME').AsString,
                   MemTFichier.FieldByName('MASTER_UUID').AsString]),
                  NivErreur);
                Inc(iNbErreur);
              end;
            // Avertissements
            CR_LOT1_MODELE_DEJA_ARCHIVE:
              begin
                case AnsiIndexText(MemTFichier.FieldByName('IMPORT_MODE').AsString, ['C', 'U', 'D']) of
                  // Création
                  0:
                    sMessage := RS_AVERTISSEMENTARTICLE_CREATION;
                  // Modification
                  1:
                    sMessage := RS_AVERTISSEMENTARTICLE_MODIFICATION;
                  // Archivage
                  2:
                    sMessage := RS_AVERTISSEMENTARTICLE_ARCHIVAGE;
                end;

                LblProgression.Caption := Format(sMessage,
                  [MemTFichier.FieldByName('NUMLIGNE').AsInteger,
                   CR_LOT1_MESSAGES[iRetour],
                   MemTFichier.FieldByName('UUID').AsString,
                   MemTFichier.FieldByName('MASTER_ID').AsString,
                   MemTFichier.FieldByName('MASTER_NAME').AsString,
                   MemTFichier.FieldByName('MASTER_UUID').AsString]);
                Journaliser(Format(sMessage,
                  [MemTFichier.FieldByName('NUMLIGNE').AsInteger,
                   CR_LOT1_MESSAGES[iRetour],
                   MemTFichier.FieldByName('UUID').AsString,
                   MemTFichier.FieldByName('MASTER_ID').AsString,
                   MemTFichier.FieldByName('MASTER_NAME').AsString,
                   MemTFichier.FieldByName('MASTER_UUID').AsString]));
              end;
          end;
        end
        else
        begin
          // Valeurs de retours en mise à jour
          iRetour := iRetour div 10;

          LblProgression.Caption := Format(RS_LOT1_INTEGRATION,
            [MemTFichier.RecNo,
             MemTFichier.RecordCount,
             MemTFichier.FieldByName('UUID').AsString,
             MemTFichier.FieldByName('MASTER_ID').AsString,
             MemTFichier.FieldByName('MASTER_NAME').AsString,
             MemTFichier.FieldByName('MASTER_UUID').AsString]);
          Journaliser(Format(RS_LOT1_INTEGRATION,
            [MemTFichier.RecNo,
             MemTFichier.RecordCount,
             MemTFichier.FieldByName('UUID').AsString,
             MemTFichier.FieldByName('MASTER_ID').AsString,
             MemTFichier.FieldByName('MASTER_NAME').AsString,
             MemTFichier.FieldByName('MASTER_UUID').AsString]));

          i := 1;
          while iRetour > 0 do
          begin
            if (iRetour and (1 shl 0) = (1 shl 0)) then
            begin
              case i of
                CR_LOT1_CHRONO_MAJ:
                  Journaliser(RS_LOT1_MAJ1);
                CR_LOT1_REFMRK_MAJ:
                  Journaliser(RS_LOT1_MAJ2);
                CR_LOT1_TAILLE_MAJ:
                  Journaliser(RS_LOT1_MAJ4);
                CR_LOT1_COULEUR_MAJ:
                  Journaliser(RS_LOT1_MAJ8);
                CR_LOT1_FOURN_MAJ:
                  Journaliser(RS_LOT1_MAJ16);
                CR_LOT1_TARIF_FOURN_MAJ:
                  Journaliser(RS_LOT1_MAJ32);
                CR_LOT1_MARQUE_MAJ:
                  Journaliser(RS_LOT1_MAJ64);
                CR_LOT1_LIST_PRICE_MAJ:
                  Journaliser(RS_LOT1_MAJ128);
                CR_LOT1_LIST_PRICE_SKU_MAJ:
                  Journaliser(RS_LOT1_MAJ256);
                CR_LOT1_PRIX_WEB_MAJ:
                  Journaliser(RS_LOT1_MAJ512);
                CR_LOT1_PRIX_WEB_SKU_MAJ:
                  Journaliser(RS_LOT1_MAJ1024);
                CR_LOT1_TVA_MAJ:
                  Journaliser(RS_LOT1_MAJ2048);
                CR_LOT1_LIBELLE_MAJ:
                  Journaliser(RS_LOT1_MAJ4096);
                CR_LOT1_CHANGE_MODE_IMPORT:
                  begin
                    case IndexText(MemTFichier.FieldByName('IMPORT_MODE').AsString, ['C', 'U']) of
                      // Création vers mise à jour
                      0:
                        Journaliser(RS_LOT1_MAJ8192_C_U);
                      // Mise à jour vers création
                      1:
                        Journaliser(RS_LOT1_MAJ8192_U_C);
                    end;
                  end;
                CR_LOT1_ARCHIVAGE_MODELE:
                  Journaliser(RS_LOT1_MAJ16384);
              end;
            end;

            iRetour := iRetour shr 1;
            i       := i * 2;
          end;
        end;

        // Retour de la nomenclature
        case iRetourNKL of
          CR_LOT1_NKL_ERREUR:
            begin
              Journaliser(Format(RS_MSG_LOT1_PREFIX_NKL, [RS_MSG_LOT1_NKL, iRetourNKL, RS_MSG_LOT1_NKL_ERREUR]), NivErreur);
              Inc(iNbErreur);
            end;
          CR_LOT1_NKL_RIEN:
            ; // On affiche rien
          CR_LOT1_NKL_CREATION:
            Journaliser(Format(RS_MSG_LOT1_PREFIX_NKL, [RS_MSG_LOT1_NKL, iRetourNKL, RS_MSG_LOT1_NKL_CREATION]));
          CR_LOT1_NKL_ASSOCIATION:
            Journaliser(Format(RS_MSG_LOT1_PREFIX_NKL, [RS_MSG_LOT1_NKL, iRetourNKL, RS_MSG_LOT1_NKL_ASSOCIATION]));
          CR_LOT1_NKL_CREATION_ASSOCIATION:
            Journaliser(Format(RS_MSG_LOT1_PREFIX_NKL, [RS_MSG_LOT1_NKL, iRetourNKL, RS_MSG_LOT1_NKL_CREATION_ASSOCIATION]));
          CR_LOT1_NKL_MODIFICATION:
            Journaliser(Format(RS_MSG_LOT1_PREFIX_NKL, [RS_MSG_LOT1_NKL, iRetourNKL, RS_MSG_LOT1_NKL_MODIFICATION]));
          CR_LOT1_NKL_CREATION_MODIFICATION:
            Journaliser(Format(RS_MSG_LOT1_PREFIX_NKL, [RS_MSG_LOT1_NKL, iRetourNKL, RS_MSG_LOT1_NKL_CREATION_MODIFICATION]));
          else
            begin
              Journaliser(Format(RS_MSG_LOT1_PREFIX_NKL, [RS_MSG_LOT1_NKL, iRetourNKL, Format(RS_MSG_LOT1_NKL_INCONNU, [iRetourNKL])]), NivErreur);
              Inc(iNbErreur);
            end;
        end;

        // Retour des EAN
        Str(iRetourEAN: 6, sRetourEAN);
        sRetourEAN := ReplaceStr(sRetourEAN, ' ', '0');

        // Boucle sur les EAN fournisseur
        j := 1;

        for i := 5 downto 1 do
        begin
          case sRetourEAN[i] of
            // Aucune modification EAN fournisseur
            '0':
              begin
                Journaliser(Format(RS_MSG_LOT1_PREFIX_EAN, [Format(RS_MSG_LOT1_EANF, [j]), sRetourEAN, RS_MSG_LOT1_EANF_0]));
              end;
            // Création de l'EAN fournisseur
            '1':
              begin
                Journaliser(Format(RS_MSG_LOT1_PREFIX_EAN, [Format(RS_MSG_LOT1_EANF, [j]), sRetourEAN, RS_MSG_LOT1_EANF_1]));
              end;
            // EAN fournisseur déjà existant sur un autre article
            '2':
              begin
                Journaliser(Format(RS_MSG_LOT1_PREFIX_EAN, [Format(RS_MSG_LOT1_EANF, [j]), sRetourEAN,
                  Format(RS_MSG_LOT1_EANF_2,
                    [MemTFichier.FieldByName(Format('EAN_F%d', [j])).AsString,
                     MemTFichier.FieldByName('NUMLIGNE').AsInteger])]),
                  NivErreur);
                Inc(iNbErreur);
              end;
          end;

          Inc(j);
        end;

        case sRetourEAN[6] of
          // Création de l'EAN principal
          '1':
            begin
              Journaliser(Format(RS_MSG_LOT1_PREFIX_EAN, [RS_MSG_LOT1_EANP, sRetourEAN, RS_MSG_LOT1_EANP_1]));
            end;
          // EAN principal différent déjà existant
          '2':
            begin
              Journaliser(Format(RS_MSG_LOT1_PREFIX_EAN, [RS_MSG_LOT1_EANP, sRetourEAN,
                Format(RS_MSG_LOT1_EANP_2,
                  [MemTFichier.FieldByName('EAN').AsString,
                   MemTFichier.FieldByName('NUMLIGNE').AsInteger])]),
                NivErreur);
              Inc(iNbErreur);
            end;
          // EAN principal non renseigné : ça ne doit pas arriver
          '3':
            begin
              Journaliser(Format(RS_MSG_LOT1_PREFIX_EAN, [RS_MSG_LOT1_EANP, sRetourEAN,
                Format(RS_MSG_LOT1_EANP_3, [MemTFichier.FieldByName('NUMLIGNE').AsInteger])]), NivErreur);
              Inc(iNbErreur);
            end;
          // EAN principal remplacé
          '4':
            begin
              Journaliser(Format(RS_MSG_LOT1_PREFIX_EAN, [RS_MSG_LOT1_EANP, sRetourEAN, RS_MSG_LOT1_EANP_4]));
            end;
        end;
{$ENDREGION 'Interprète les retours'}
      except
        on e: Exception do
        begin
          case AnsiIndexText(MemTFichier.FieldByName('IMPORT_MODE').AsString, ['C', 'U']) of
            // Erreur lors de la création
            0:
              begin
                Journaliser(Format(RS_ERREUR_INTEGRATION,
                  [MemTFichier.FieldByName('NUMLIGNE').AsInteger,
                   MemTFichier.FieldByName('UUID').AsString,
                   MemTFichier.FieldByName('MASTER_ID').AsString,
                   MemTFichier.FieldByName('MASTER_NAME').AsString,
                   e.ClassName,
                   e.Message]),
                  NivArret);
                Inc(iNbErreur);
              end;
            // Erreur lors de la modification
            1:
              begin
                Journaliser(Format(RS_ERREUR_MODIFICATION,
                  [MemTFichier.FieldByName('NUMLIGNE').AsInteger,
                   MemTFichier.FieldByName('UUID').AsString,
                   MemTFichier.FieldByName('MASTER_ID').AsString,
                   MemTFichier.FieldByName('MASTER_NAME').AsString,
                   e.ClassName,
                   e.Message]),
                  NivArret);
                Inc(iNbErreur);
              end;
          end;
        end;
      end;

      // Arrête le thread si annulé
      if Self.Terminated then
        Exit;

      // Ligne suivante
      PbProgression.Position := MemTFichier.RecNo;
      MemTFichier.Next();
    end;

    // Validation de l'intégration du fichier
    if (iNbErreur = 0) or (FindCmdLineSwitch('VALIDER_ERREURS')) then
    begin
      FDTransaction.Commit();
      FIntegre := True;
    end
    else
    begin
      // Annule les actions sur la base de données
      FDTransaction.Rollback();

      if iNbErreur = 1 then
        Journaliser(RS_ERREUR_FICHIER, NivArret)
      else
        Journaliser(Format(RS_ERREURS_FICHIER, [iNbErreur]), NivArret);
    end;
{$ENDREGION 'Intégration des articles'}
  finally
    // Si le thread a été arrêté : annuler la transaction
    if Self.Terminated then
      FDTransaction.Rollback();

    slListeChronos.Free();
    slFichier.Free();
    FDConnection.Free();
    FDTransaction.Free();
    QueInfoModele.Free();
    QueIntegration.Free();
    QueInfoDossier.Free();
    MemTFichier.Free();
    FDPhysIBDriverLink.Free();
    FDStanStorageXMLLink.Free();
  end;

  LblProgression.Caption := RS_TERMINEE;
  Journaliser(RS_TERMINEE, NivNotice, True);
end;

procedure TThreadLot1.Journaliser(const AMessage: string; const ANiveau: TNiveau = NivTrace; const ASurcharge: Boolean = False);
begin
  // Envoi un message au journal de l'application
  Synchronize(
    procedure
    begin
      FormPrincipale.Journaliser(AMessage, ANiveau, FDossier, FCodeMagasin, 'Articles', ASurcharge);
    end);
end;

{$REGION 'Méthodes pour la vérification de la cohérence des modèles à intégrer'}

{ TCouleur }

constructor TCouleur.Create(const ACouleur, AEAN, ACodeArt: string);
begin
  inherited Create();

  // Enregistre la couleur
  FCouleur := ACouleur;
  FEAN     := AEAN;
  FCodeArt := ACodeArt;
end;

{ TTailleCouleurs }

constructor TTailleCouleurs.Create(const ATaille: string);
begin
  inherited Create();

  // Créer la liste des couleurs
  FCouleurs := TObjectList<TCouleur>.Create();

  // Enregistre la taille
  FTaille := ATaille;
end;

destructor TTailleCouleurs.Destroy();
begin
  // Détruit la liste des couleurs
  FreeAndNil(FCouleurs);

  inherited;
end;

function TTailleCouleurs.AjouterCouleur(const ACouleur, AEAN, ACodeArt: string; const AModification: Boolean): Boolean;
var
  Couleur         : TCouleur;
  i, iIndexCouleur: Integer;
begin
  // Vérifie si la couleur existe déjà
  i             := 0;
  iIndexCouleur := -1;
  for Couleur in Couleurs do
  begin
    if SameText(Couleur.Couleur, ACouleur) then
    begin
      iIndexCouleur := i;
      Break;
    end;

    Inc(i);
  end;

  // Si la couleur n'a pas été trouvée, mais qu'il s'agit d'une modification
  if (iIndexCouleur < 0) and AModification then
  begin
    i             := 0;
    iIndexCouleur := -1;

    for Couleur in Couleurs do
    begin
      if SameText(Couleur.CodeArt, ACodeArt) then
      begin
        // Si l'identifiant unique a été trouvé
        // Change le libellé de la couleur
        Couleur.Couleur := ACouleur;
        iIndexCouleur   := i;
        Break;
      end;

      // Si l'identifiant unique a été trouvé : on arrête de chercher
      if iIndexCouleur > -1 then
        Break;

      Inc(i);
    end;
  end;

  // Si la couleur existe déjà : doublon !
  if iIndexCouleur > -1 then
  begin
    Result := SameText(Couleurs[iIndexCouleur].EAN, AEAN);
  end
  else
  begin
    // Si la couleur n'existe pas, on la créer
    Couleur := TCouleur.Create(ACouleur, AEAN, ACodeArt);
    Result  := (Couleurs.Add(Couleur) > -1);
  end;
end;

{ TModele }

constructor TModele.Create(const AChrono: string; const AArchive: Boolean = False);
begin
  inherited Create();

  // Créer la liste des tailles/couleurs
  FTaillesCouleurs := TObjectList<TTailleCouleurs>.Create();

  FChrono       := AChrono;
  FArchive      := AArchive;
  FRaisonErreur := RaiAucune;
end;

destructor TModele.Destroy();
begin
  // Détruit la liste des tailles/couleurs
  FreeAndNil(FTaillesCouleurs);

  inherited;
end;

function TModele.AjouterTailleCouleur(ATaille, ACouleur, AEAN, ACodeArt: string; const AModification: Boolean): Boolean;
var
  TailleCouleur                 : TTailleCouleurs;
  Couleur                       : TCouleur;
  i, iIndexTaille, iIndexCouleur: Integer;
begin
  // Vérifie si l'identifiant unique existe déjà
  if AModification then
  begin
    for TailleCouleur in TaillesCouleurs do
    begin
      for Couleur in TailleCouleur.Couleurs do
      begin
        if SameText(Couleur.CodeArt, ACodeArt) then
        begin
          // Vérifie si les libellés ont changés et si c'est le cas, les modifier
          if not(SameText(TailleCouleur.Taille, ATaille)) then
            ATaille := TailleCouleur.Taille;

          if not(SameText(Couleur.Couleur, ACouleur)) then
            ACouleur := Couleur.Couleur;
        end;
      end;
    end;
  end;

  // Vérifie si la taille existe déjà
  i            := 0;
  iIndexTaille := -1;
  for TailleCouleur in TaillesCouleurs do
  begin
    if SameText(TailleCouleur.Taille, ATaille) then
    begin
      iIndexTaille := i;
      Break;
    end;

    Inc(i);
  end;

  // Si la taille n'a pas été trouvée, mais qu'il s'agit d'une modification
  if (iIndexTaille < 0) and AModification then
  begin
    i            := 0;
    iIndexTaille := -1;

    for TailleCouleur in TaillesCouleurs do
    begin
      for Couleur in TailleCouleur.Couleurs do
      begin
        if SameText(Couleur.CodeArt, ACodeArt) then
        begin
          // Si l'identifiant unique a été trouvé
          // Change le libellé de la taille
          TailleCouleur.Taille := ATaille;
          iIndexTaille         := i;
          Break;
        end;
      end;

      // Si l'identifiant unique a été trouvé : on arrête de chercher
      if iIndexTaille > -1 then
        Break;

      Inc(i);
    end;
  end;

  if iIndexTaille > -1 then
  begin
    // Si la taille existe déjà, on ajoute la couleur
    Result := TaillesCouleurs[iIndexTaille].AjouterCouleur(ACouleur, AEAN, ACodeArt, AModification);

    if not(Result) then
      FRaisonErreur := RaiTaillesDoubles;
  end
  else
  begin
    // Si la taille n'existe pas, on la créer
    TailleCouleur := TTailleCouleurs.Create(ATaille);
    TailleCouleur.AjouterCouleur(ACouleur, AEAN, ACodeArt, AModification);
    Result := (TaillesCouleurs.Add(TailleCouleur) > -1);
  end;
end;

{ TModeles }

constructor TModeles.Create();
begin
  inherited Create();

  // Créer la liste des modèles
  FModeles := TObjectList<TModele>.Create();
end;

destructor TModeles.Destroy();
begin
  // Détruit le liste des modèles
  FreeAndNil(FModeles);

  inherited;
end;

function TModeles.AjouterArticle(const AChrono, ATaille, ACouleur, AEAN, ACodeArt: string; const AModification: Boolean; const AArchive: Boolean = False): Boolean;
var
  Modele         : TModele;
  i, iIndexModele: Integer;
begin
  // Vérifie si le modèle existe déjà
  i            := 0;
  iIndexModele := -1;
  for Modele in Modeles do
  begin
    if SameText(Modele.Chrono, AChrono) then
    begin
      iIndexModele := i;
      Break;
    end;

    Inc(i);
  end;

  if iIndexModele > -1 then
  begin
    // Si le modèle existe déjà, on ajoute la taille/couleur
    Result := Modeles[iIndexModele].AjouterTailleCouleur(ATaille, ACouleur, AEAN, ACodeArt, AModification);

    // On change l'état archivé
    if not Modeles[iIndexModele].Archive then
      Modeles[iIndexModele].Archive := AArchive;
  end
  else
  begin
    // Si le modèle n'existe pas, on le créer
    Modele := TModele.Create(AChrono, AArchive);
    Modele.AjouterTailleCouleur(ATaille, ACouleur, AEAN, ACodeArt, AModification);
    Result := (Modeles.Add(Modele) > -1);
  end;
end;

function TModeles.VerifierModeles(out AModelesErreur: TListeModelesErreur): Integer;
var
  ModeleErreur  : TModeleErreur;
  Modele        : TModele;
  TailleCouleur : TTailleCouleurs;
  Couleur       : TCouleur;
  i, iNbCouleurs: Integer;
  TaillesModele : TStringList;
  CouleursModele: TStringList;
begin
  // Créer la liste des modèles en erreur
  AModelesErreur               := TListeModelesErreur.Create();
  Result                       := 0;
  TaillesModele                := TStringList.Create();
  TaillesModele.CaseSensitive  := False;
  CouleursModele               := TStringList.Create();
  CouleursModele.CaseSensitive := False;

  try
    // Parcours la liste des modèles
    for Modele in Modeles do
    begin
      // Si le modèles à plusieurs tailles
      if (Modele.TaillesCouleurs.Count > 1)
        and (Modele.TaillesCouleurs.Count <= 26) then
      begin
        // Récupère le nombre de couleurs de la première taille
        iNbCouleurs := Modele.TaillesCouleurs[0].Couleurs.Count;

        for i := 1 to Modele.TaillesCouleurs.Count - 1 do
        begin
          if iNbCouleurs <> Modele.TaillesCouleurs[i].Couleurs.Count then
          begin
            // Ce modèle à un soucis au niveau du nombre de couleurs renseignées : on le rapporte
            ModeleErreur        := TModeleErreur.Create();
            ModeleErreur.Chrono := Modele.Chrono;
            ModeleErreur.Raison := RaiEANManquant;
            AModelesErreur.Add(ModeleErreur);
            Inc(Result);
            Break;
          end;
        end;
      end
      else if (Modele.TaillesCouleurs.Count > 26) then
      begin
        // Si le modèle a trop de taille on le retourne
        ModeleErreur        := TModeleErreur.Create();
        ModeleErreur.Chrono := Modele.Chrono;
        ModeleErreur.Raison := RaiTropTailles;
        AModelesErreur.Add(ModeleErreur);
        Inc(Result);
      end
      else if Modele.Archive then
      begin
        // Si le modèle est archivé
        ModeleErreur        := TModeleErreur.Create();
        ModeleErreur.Chrono := Modele.Chrono;
        ModeleErreur.Raison := RaiArchive;
        AModelesErreur.Add(ModeleErreur);
        Inc(Result);
      end;

      // Vérifie s'il y a des tailles/couleurs en double
      if Modele.RaisonErreur = RaiAucune then
      begin
        TaillesModele.Clear();

        for TailleCouleur in Modele.TaillesCouleurs do
        begin
          if TaillesModele.IndexOf(TailleCouleur.Taille) < 0 then
          begin
            TaillesModele.Add(TailleCouleur.Taille);
          end
          else
          begin
            // Le modèle a une taille en double
            ModeleErreur        := TModeleErreur.Create();
            ModeleErreur.Chrono := Modele.Chrono;
            ModeleErreur.Raison := RaiTaillesDoubles;
            AModelesErreur.Add(ModeleErreur);
            Inc(Result);
          end;

          CouleursModele.Clear();

          for Couleur in TailleCouleur.Couleurs do
          begin
            if CouleursModele.IndexOf(Couleur.Couleur) < 0 then
            begin
              CouleursModele.Add(Couleur.Couleur);
            end
            else
            begin
              // Le modèle a une taille en double
              ModeleErreur        := TModeleErreur.Create();
              ModeleErreur.Chrono := Modele.Chrono;
              ModeleErreur.Raison := RaiCouleursDoubles;
              AModelesErreur.Add(ModeleErreur);
              Inc(Result);
            end;
          end;
        end;
      end
      else
      begin
        // Le modèle a une erreur
        ModeleErreur        := TModeleErreur.Create();
        ModeleErreur.Chrono := Modele.Chrono;
        ModeleErreur.Raison := Modele.RaisonErreur;
        AModelesErreur.Add(ModeleErreur);
        Inc(Result);
      end;
    end;
  finally
    TaillesModele.Free();
    CouleursModele.Free();
  end;
end;

{$ENDREGION 'Méthodes pour la vérification de la cohérence des modèles à intégrer'}

{$REGION 'Méthodes pour récupérer l’occurence des articles à l’intérieur des modèles'}

{ TModelesSKU }

constructor TModelesSKU.Create();
begin
  inherited Create();

  // Créer la liste des modèles
  FModelesSKU := TObjectList<TModeleSKU>.Create();
end;

destructor TModelesSKU.Destroy();
begin
  // Détruit la liste des modèles
  FreeAndNil(FModelesSKU);

  inherited;
end;

function TModelesSKU.AjouterArticle(const AChrono, ATaille, ACouleur: string): Boolean;
var
  ModeleSKU         : TModeleSKU;
  i, iIndexModeleSKU: Integer;
begin
  // Vérifie si le modèle existe déjà
  i               := 0;
  iIndexModeleSKU := -1;

  for ModeleSKU in ModelesSKU do
  begin
    if SameText(ModeleSKU.Chrono, AChrono) then
    begin
      iIndexModeleSKU := i;
      Break;
    end;

    Inc(i);
  end;

  if iIndexModeleSKU > -1 then
  begin
    // Si le modèle existe déjà, on ajoute la taille/couleur
    Result := ModelesSKU[iIndexModeleSKU].AjouterTailleCouleur(ATaille, ACouleur);
  end
  else
  begin
    ModeleSKU := TModeleSKU.Create(AChrono);
    ModeleSKU.AjouterTailleCouleur(ATaille, ACouleur);
    Result := (ModelesSKU.Add(ModeleSKU) > -1);
  end;
end;

function TModelesSKU.OccurenceArticle(const AChrono, ATaille, ACouleur: string): Integer;
var
  ModeleSKU         : TModeleSKU;
  TailleCouleurSKU  : TTailleCouleurSKU;
  i, iIndexModeleSKU: Integer;
begin
  // Vérifie si le modèle en lui-même existe
  i               := 0;
  iIndexModeleSKU := -1;
  Result          := -1;

  for ModeleSKU in ModelesSKU do
  begin
    if SameText(ModeleSKU.Chrono, AChrono) then
    begin
      iIndexModeleSKU := i;
      Break;
    end;

    Inc(i);
  end;

  // Si le modèle a été trouvé
  if iIndexModeleSKU > -1 then
  begin
    // Vérifie si la taille/couleur existe
    i := 0;

    for TailleCouleurSKU in ModelesSKU[iIndexModeleSKU].TaillesCouleursSKU do
    begin
      if SameText(TailleCouleurSKU.Taille, ATaille) and SameText(TailleCouleurSKU.Couleur, ACouleur) then
      begin
        // Si la taille/couleur est bien présente : retourner sa position
        Result := i;
        Break;
      end;

      Inc(i);
    end;
  end;
end;

{ TModeleSKU }

constructor TModeleSKU.Create(const AChrono: string);
begin
  inherited Create();

  // Créer la liste des tailles/couleurs
  FTaillesCouleursSKU := TObjectList<TTailleCouleurSKU>.Create();

  // Enregistre le chrono
  FChrono := AChrono;
end;

destructor TModeleSKU.Destroy();
begin
  // Détruit la liste des tailles/couleurs
  FreeAndNil(FTaillesCouleursSKU);

  inherited;
end;

function TModeleSKU.AjouterTailleCouleur(const ATaille, ACouleur: string): Boolean;
var
  TailleCouleurSKU         : TTailleCouleurSKU;
  i, iIndexTailleCouleurSKU: Integer;
begin
  // Vérifie si la taille/couleur existe déjà
  i                      := 0;
  iIndexTailleCouleurSKU := -1;

  for TailleCouleurSKU in TaillesCouleursSKU do
  begin
    if SameText(TailleCouleurSKU.Taille, ATaille) and SameText(TailleCouleurSKU.Couleur, ACouleur) then
    begin
      iIndexTailleCouleurSKU := i;
      Break;
    end;

    Inc(i);
  end;

  // Si la taille/couleur existe déjà : un doublon qui sera traité ultérieurement par le programme !
  if iIndexTailleCouleurSKU > -1 then
  begin
    Result := False;
  end
  else
  begin
    // Si la taille/couleur n'existe pas : on la créer
    TailleCouleurSKU := TTailleCouleurSKU.Create(ATaille, ACouleur);
    Result           := (TaillesCouleursSKU.Add(TailleCouleurSKU) > -1);
  end;
end;

{ TTailleCouleurSKU }

constructor TTailleCouleurSKU.Create(const ATaille, ACouleur: string);
begin
  inherited Create();

  // Enregistre la taille/couleur
  FTaille  := ATaille;
  FCouleur := ACouleur;
end;

{$ENDREGION 'Méthodes pour récupérer l’occurence des articles à l’intérieur des modèles'}

end.
