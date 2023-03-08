unit uMigrationLaignel;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  System.StrUtils;

{$REGION 'Définition des types "TFile"...}
type
  TFile = (
    fiVEGAPROD, fiVEGAFOUR, fiVEGAGRIL, fiVEGASTOC, fiEXPORAYO,
    fiEXPOFAM1, fiEXPOFAM2, fiEXPOCLIE, fiEXPOTICK, fiGENRE, fiTVA, fiLIENFAM,
    foMODELE, foARTICLE_AXE, foCOULEUR, foGENRE, foAXE, foAXE_NIVEAU1,
    foMARQUE, foFOUMARQUE, foFOURN, foFOUCONTACT, foFOUCONDITION,
    foDOMAINE_COMMERCIAL, foCOLLECTION, foARTICLE_COLLECTION,
    foPRIX_VENTE_INDICATIF, foMODELEDEPRECIE, foGR_TAILLE, foGR_TAILLE_LIG,
    foAXE_NIVEAU2, foAXE_NIVEAU3, foAXE_NIVEAU4, foARTICLE, foPRIX,
    foPRIXMAG, foSTOCK, foCLIENT, foCAISSE, foCONSODIV
  );
  TFileKind = (fkInput, fkOutput);
  TFileOption = (fioOptional);
  TFileOptions = set of TFileOption;
  TFileRec = record
    Name: string; // nom du fichier
    Kind: TFileKind; // fichier d'entrée/de sortie
    Options: TFileOptions;
    constructor CreateInput(const Name: string; const Options: TFileOptions = []; const Extension: string = '.CSV');
    constructor CreateOutput(const Name: string; const Extension: string = '.CSV');
  end;
  TFiles = class(TDictionary<TFile,TFileRec>);
var
  Files: TFiles;
{$ENDREGION}

type
  TStepStyle = (styleNormal, styleMarquee);
  TStepState = (stateNormal, stateError, stateWarning);

  TStepEvent = reference to procedure(const Text: string;
    const State: TStepState; const Style: TStepStyle;
    const Index, Count: Integer);
  TTerminateEvent = reference to procedure(const ErrorsCount: Integer);

  TThreadMigrationLaignel = class(TThread)
  private type
    // Exceptions internes
    EAbort = class(Exception);
    EBadFormat = class(Exception);
    EProcessException = class(Exception);
  private
    // Répertoire des fichiers d'entrée et de sortie
    FDirectory, FOutputDirectory: string;

    // Permet de stocker un stream par fichier
    FFileStreams: TObjectDictionary<TFile,TStream>;
    // Permet de stocker des exceptions par fichier
    FFileExceptions: TObjectDictionary<TFile,TStringList>;

    // Propriétés envoyées lors de l'evenement OnStep
    FStepIndex, FStepCount: Integer;
    FStepState: TStepState;
    FStepStyle: TStepStyle;

    // Evenements
    class var FOnStep: TStepEvent;
    class var FOnTerminate: TTerminateEvent;
  strict private
    {$REGION 'Routines facilitant le parcours des TFile, TStringList,...'}
    // Pour chacun des fichiers...
    procedure ForEachFile(const Proc: TProc<TFile,TFileRec>);
    // Pour chacun des champs d'un texte séparé par des ';'...
    procedure ForEachField(const Line: string; const Proc: TProc<TStringList>);
    // Pour chacune des lignes (délimité par des ';') de fichier...
    // Le numéro de la ligne ainsi que le nombre de ligne total sont fournis
    procedure ForEachLine(const F: TFile;
      const Proc: TProc<TStringList,Integer,Integer>); overload;
    // Pour travaillé avec un dictionnaire <clé/lignes> pour un fichier...
    procedure ForDictionary(const F: TFile;
      const Func: TFunc<TStringList,string>;
      const Proc: TProc<TObjectDictionary<string,TStringList>>);
    // Permet d'ajouter du texte dans un fichier (sans #13#10)...
    procedure AddToStream(const F: TFile; const Text: string); overload;
    // Permet d'ajouter une ligne dans un fichier (champs séparés par des ';'
    // avec #13#10 à la fin...
    procedure AddToStream(const F: TFile;
      const Items: array of string); overload;
    // Ajoute une exception dans l'objet permettant de gérer des exceptions par
    // fichier...
    procedure AddException(const F: TFile; const Text: string);
    // Pour chacune des exceptions liées à des fichiers...
    procedure ForEachException(const Proc: TProc<TFile,TFileRec,string>);
    {$ENDREGION}
  protected
    // Evenements
    procedure DoStep(const Format: string; const Args: array of const;
      const Inc: Integer = 0); overload;
    procedure DoStep(const Text: string; const Inc: Integer = 0); overload;
    procedure DoTerminate(const ErrorsCount: Integer); reintroduce;

    procedure Execute; override;
    // Création des fichies d'entrée
    procedure CreateInputStreams;
    // Création du repertoire ainsi que dee fichiers de sortie
    procedure CreateOutputDirectory;
    procedure CreateOutputStreams;
    // Remplissage des fichiesr d'entrée optionnel avec des valeurs par défaut
    procedure FillOptionalInputStreams;
    // Contrôle du contenu des fichiers d'entrée et de sortie
    procedure CheckInputStreams;
    procedure CheckOutputStreams;
  private
    {$REGION 'Gestion des fichiers d''entrée'}
    procedure FillOutputStreamsFromVEGAPROD(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromVEGASTOC(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromEXPOTICK(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromEXPOFAM2(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromEXPOFAM1(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromVEGAFOUR(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromVEGAGRIL(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromEXPORAYO(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromEXPOCLIE(const RaiseErrors: Boolean = False);
    procedure FillOutputStreamsFromOthers(const RaiseErrors: Boolean = False);
    {$ENDREGION}
  public
    constructor Create(const Directory: string);
    destructor Destroy; override;
    // Indique le repértoire des fichiers de sortie
    property OutputDirectory: string read FOutputDirectory;
    // Evenements
    class property OnStep: TStepEvent read FOnStep write FOnStep;
    class property OnTerminate: TTerminateEvent read FOnTerminate
      write FOnTerminate;
  end;

implementation

procedure InitFiles;
begin
  Files := TFiles.Create;
  Files.Add(fiVEGAPROD, TFileRec.CreateInput('VEGAPROD'));
  Files.Add(fiVEGAFOUR, TFileRec.CreateInput('VEGAFOUR'));
  Files.Add(fiVEGAGRIL, TFileRec.CreateInput('VEGAGRIL'));
  Files.Add(fiVEGASTOC, TFileRec.CreateInput('VEGASTOC'));
  Files.Add(fiEXPORAYO, TFileRec.CreateInput('EXPORAYO'));
  Files.Add(fiEXPOFAM1, TFileRec.CreateInput('EXPOFAM1'));
  Files.Add(fiEXPOFAM2, TFileRec.CreateInput('EXPOFAM2'));
  Files.Add(fiEXPOCLIE, TFileRec.CreateInput('EXPOCLIE'));
  Files.Add(fiEXPOTICK, TFileRec.CreateInput('EXPOTICK'));
  Files.Add(fiGENRE, TFileRec.CreateInput('GENRE', [fioOptional]));
  Files.Add(fiTVA, TFileRec.CreateInput('TVA', [fioOptional]));
  Files.Add(fiLIENFAM, TFileRec.CreateInput('LIENFAM'));
  Files.Add(foMODELE, TFileRec.CreateOutput('MODELE'));
  Files.Add(foARTICLE_AXE, TFileRec.CreateOutput('ARTICLE_AXE'));
  Files.Add(foCOULEUR, TFileRec.CreateOutput('COULEUR'));
  Files.Add(foGENRE, TFileRec.CreateOutput('GENRE'));
  Files.Add(foAXE, TFileRec.CreateOutput('AXE'));
  Files.Add(foAXE_NIVEAU1, TFileRec.CreateOutput('AXE_NIVEAU1'));
  Files.Add(foMARQUE, TFileRec.CreateOutput('MARQUE'));
  Files.Add(foFOUMARQUE, TFileRec.CreateOutput('FOUMARQUE'));
  Files.Add(foFOURN, TFileRec.CreateOutput('FOURN'));
  Files.Add(foFOUCONTACT, TFileRec.CreateOutput('FOUCONTACT'));
  Files.Add(foFOUCONDITION, TFileRec.CreateOutput('FOUCONDITION'));
  Files.Add(foDOMAINE_COMMERCIAL, TFileRec.CreateOutput('DOMAINE_COMMERCIAL'));
  Files.Add(foCOLLECTION, TFileRec.CreateOutput('COLLECTION'));
  Files.Add(foARTICLE_COLLECTION, TFileRec.CreateOutput('ARTICLE_COLLECTION'));
  Files.Add(foPRIX_VENTE_INDICATIF, TFileRec.CreateOutput('PRIX_VENTE_INDICATIF'));
  Files.Add(foMODELEDEPRECIE, TFileRec.CreateOutput('MODELEDEPRECIE'));
  Files.Add(foGR_TAILLE, TFileRec.CreateOutput('GR_TAILLE'));
  Files.Add(foGR_TAILLE_LIG, TFileRec.CreateOutput('GR_TAILLE_LIG'));
  Files.Add(foAXE_NIVEAU2, TFileRec.CreateOutput('AXE_NIVEAU2'));
  Files.Add(foAXE_NIVEAU3, TFileRec.CreateOutput('AXE_NIVEAU3'));
  Files.Add(foAXE_NIVEAU4, TFileRec.CreateOutput('AXE_NIVEAU4'));
  Files.Add(foARTICLE, TFileRec.CreateOutput('ARTICLE'));
  Files.Add(foPRIX, TFileRec.CreateOutput('PRIX'));
  Files.Add(foPRIXMAG, TFileRec.CreateOutput('PRIXMAG'));
  Files.Add(foSTOCK, TFileRec.CreateOutput('STOCK'));
  Files.Add(foCLIENT, TFileRec.CreateOutput('CLIENT'));
  Files.Add(foCAISSE, TFileRec.CreateOutput('CAISSE'));
  Files.Add(foCONSODIV, TFileRec.CreateOutput('consodiv'));
end;


{ TThreadMigrationLaignel }

procedure TThreadMigrationLaignel.AddToStream(const F: TFile;
  const Text: string);
var
  StreamWriter: TStreamWriter;
begin
  StreamWriter := TStreamWriter.Create(FFileStreams[F], TEncoding.ANSI);
  try
    StreamWriter.Write(Text);
  finally
    StreamWriter.Free;
  end;
end;

procedure TThreadMigrationLaignel.AddException(const F: TFile;
  const Text: string);
begin
  if not FFileExceptions.ContainsKey(F) then
    FFileExceptions.Add(F, TStringList.Create);

  FFileExceptions[F].Add(Text);
end;

procedure TThreadMigrationLaignel.AddToStream(const F: TFile;
  const Items: array of string);
var
  StringBuilder: TStringBuilder;
  Item: string;
begin
  StringBuilder := TStringBuilder.Create;
  try
    for Item in Items do
      StringBuilder.Append(Item+';');
    StringBuilder.AppendLine;

    AddToStream(F, StringBuilder.ToString);
  finally
    StringBuilder.Free;
  end;
end;

procedure TThreadMigrationLaignel.CheckInputStreams;
begin
  { TODO : Vérifier le contenu des fichiers d'entrée }
end;

procedure TThreadMigrationLaignel.CheckOutputStreams;
begin
  { TODO : Vérifier le contenu des fichiers de sortie }
end;

constructor TThreadMigrationLaignel.Create(const Directory: string);
begin
  FStepIndex := 0;
  FStepCount := 100;
  FStepState := stateNormal;
  FStepStyle := styleNormal;

  FFileStreams := TObjectDictionary<TFile,TStream>.Create([doOwnsValues]);
  FFileExceptions := TObjectDictionary<TFile,TStringList>.Create([doOwnsValues]);

  FDirectory := IncludeTrailingPathDelimiter(Trim(Directory));
  FOutputDirectory := FDirectory;

  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TThreadMigrationLaignel.CreateInputStreams;
const
  C_OPEN_MODE = fmOpenRead or fmShareDenyWrite;
begin
  ForEachFile(
    procedure(F: TFile; R: TFileRec)
    var
      FileName: string;
    begin
      if R.Kind = fkInput then
      begin
        FileName := FDirectory + R.Name;
        if ((fioOptional in R.Options) and FileExists(FileName))
        or (not(fioOptional in R.Options)) then
          try
            FFileStreams.Add(F, TFileStream.Create( FileName, C_OPEN_MODE ));
          except
            on E: Exception do
              AddException(F, E.Message);
          end;
      end;
    end
  );
  if FFileExceptions.Count > 0 then
    raise EProcessException.Create('CreateInputStreams');
end;

procedure TThreadMigrationLaignel.CreateOutputDirectory;
var
  DateTimeStr: string;
begin
  DateTimeToString(DateTimeStr, 'yyyymmddhhnnsszzz', Now);
  FOutputDirectory := IncludeTrailingPathDelimiter(FDirectory + 'Generation du ' + DateTimeStr);
  if not ForceDirectories(FOutputDirectory) then
    raise EProcessException.Create('CreateOutputDirectory');
end;

procedure TThreadMigrationLaignel.CreateOutputStreams;
const
  C_OPEN_MODE = fmCreate or fmShareDenyWrite;
begin
  ForEachFile(
    procedure(F: TFile; R: TFileRec)
    begin
      if R.Kind = fkOutput then
      begin
        try
          FFileStreams.Add(F, TFileStream.Create(FOutputDirectory + R.Name, C_OPEN_MODE));
        except
          on E: Exception do
            AddException(F, E.Message);
        end;
      end;
    end
  );
  if FFileExceptions.Count > 0 then
    raise EProcessException.Create('CreateOutputStreams');
end;

destructor TThreadMigrationLaignel.Destroy;
begin
  FFileStreams.Free;
  FFileExceptions.Free;
  inherited;
end;

procedure TThreadMigrationLaignel.DoStep(const Text: string;
  const Inc: Integer);
begin
  Synchronize(
    procedure
    begin
      if Assigned(FOnStep) then
        FOnStep(Text, FStepState, FStepStyle, FStepIndex, FStepCount);
    end
  );
  System.Inc(FStepIndex,Inc);
end;

procedure TThreadMigrationLaignel.DoStep(const Format: string;
  const Args: array of const; const Inc: Integer);
begin
  DoStep(System.SysUtils.Format(Format,Args), Inc);
end;

procedure TThreadMigrationLaignel.DoTerminate(const ErrorsCount: Integer);
begin
  Synchronize(
    procedure
    begin
      if Assigned(FOnTerminate) then
        FOnTerminate(ErrorsCount);
    end
  );
end;

procedure TThreadMigrationLaignel.Execute;
begin
  try
    FStepCount := 28;
    DoStep('Démarrage du traitement...');

    DoStep('Création des streams d''entrée...',1);
    CreateInputStreams;

    DoStep('Génération du contenu des streams facultatifs...',1);
    FillOptionalInputStreams;

    DoStep('Vérification du contenu des fichiers d''entrée...',1);
    CheckInputStreams;

    DoStep('Création du répertoire des streams de sortie...',1);
    CreateOutputDirectory;

    DoStep('Création des streams de sortie...',1);
    CreateOutputStreams;

    DoStep('Génération du contenu des fichiers...');

    DoStep('  VEGAPROD: Génération des fichiers: MODELE, ARTICLE_AXE, COULEUR...',3);
    FillOutputStreamsFromVEGAPROD;

    DoStep('  VEGASTOC: Génération des fichiers: *PRIX, ARTICLE, PRIXMAG, STOCK, CLIENT...',5);
    FillOutputStreamsFromVEGASTOC;

    DoStep('  EXPOTICK: Génération du fichier: *CAISSE, CONSODIV...',1);
    FillOutputStreamsFromEXPOTICK(False);

    DoStep('  EXPOFAM2: Génération du fichier: AXE_NIVEAU4...',1);
    FillOutputStreamsFromEXPOFAM2;

    DoStep('  EXPOFAM1: Génération du fichier: *AXE_NIVEAU3...',1);
    FillOutputStreamsFromEXPOFAM1;

    DoStep('  VEGAFOUR: Génération des fichiers: MARQUE, FOUMARQUE, FOURN...',3);
    FillOutputStreamsFromVEGAFOUR;

    DoStep('  VEGAGRIL: Génération des fichiers: GR_TAILLE, GR_TAILLE_LIG...',3);
    FillOutputStreamsFromVEGAGRIL;

    DoStep('  EXPORAYO: Génération du fichier: AXE_NIVEAU2...',1);
    FillOutputStreamsFromEXPORAYO;

    DoStep('  EXPOCLIE: Génération du fichier: CLIENT...',1);
    FillOutputStreamsFromEXPOCLIE;

    DoStep('Génération des fichier: GENRE, AXE, AXE_NIVEAU1...',3);
    FillOutputStreamsFromOthers;

    DoStep('Vérification du contenu des fichiers de sortie',1);
    CheckOutputStreams;


    ForEachException(
      procedure(F: TFile; R: TFileRec; Message: string)
      begin
        FStepState := stateWarning;
        DoStep('%s : %s', [R.Name, Message]);
      end
    );
    FFileExceptions.Clear;

    FStepState := stateNormal;
    DoStep('Traitement terminé');
    DoTerminate(0);
  except
    on E: EAbort do
    begin
      DoStep('Traitement annulé');
      DoTerminate(-1);
    end;
    on E: Exception do
    begin
      FStepState := stateError;
      if E is EProcessException then
        ForEachException(
          procedure(F: TFile; R: TFileRec; Message: string)
          begin
            DoStep('[%s] %s'#13#10'%s', [E.Message, R.Name, Message]);
          end
        )
      else
        DoStep(E.Message);
      FStepState := stateNormal;
      DoStep('Traitement échoué');
      DoTerminate(1);
    end;
  end;
end;

procedure TThreadMigrationLaignel.FillOptionalInputStreams;
{$REGION}
type
  TGenreRec = record
    Code, Libelle, CodeSexe: string;
  end;
  TTVARec = record
    Code, Taux, Libelle: string;
  end;
const
  C_GENRE: array[0..7] of TGenreRec = (
    (Code: '1'; Libelle: 'Baby'; CodeSexe: '3'),
    (Code: '2'; Libelle: 'Femme'; CodeSexe: '2'),
    (Code: '3'; Libelle: 'Fille'; CodeSexe: '3'),
    (Code: '4'; Libelle: 'Garçon'; CodeSexe: '3'),
    (Code: '5'; Libelle: 'Homme'; CodeSexe: '1'),
    (Code: '6'; Libelle: 'Unisexe adulte'; CodeSexe: '1'),
    (Code: '7'; Libelle: 'Unisexe junior'; CodeSexe: '3'),
    (Code: '0'; Libelle: 'Non significatif'; CodeSexe: '1')
  );
  C_TVA: array[0..9] of TTVARec = (
    (Code: '1'; Taux: '5,50'; Libelle: ''),
    (Code: '2'; Taux: '20'; Libelle: ''),
    (Code: '3'; Taux: '20'; Libelle: ''),
    (Code: '4'; Taux: '20'; Libelle: ''),
    (Code: '5'; Taux: '20'; Libelle: ''),
    (Code: '6'; Taux: '20'; Libelle: ''),
    (Code: '7'; Taux: '20'; Libelle: ''),
    (Code: '8'; Taux: '20'; Libelle: ''),
    (Code: '9'; Taux: '20'; Libelle: ''),
    (Code: '0'; Taux: '20'; Libelle: '')
  );
{$ENDREGION}
begin
  ForEachFile(
    procedure(F: TFile; R: TFileRec)
    var
      Genre: TGenreRec;
      TVA: TTVARec;
    begin
      if FFileStreams.ContainsKey(F) or not(fioOptional in R.Options) then
        Exit;
      try
        FFileStreams.Add(F, TStringStream.Create);
        case F of
          fiGENRE:
            for Genre in C_GENRE do
              AddToStream(
                F, [
                  {1:CODE} Genre.Code,
                  {2:LIBELLE} Genre.Libelle,
                  {3:CODE SEXE} Genre.CodeSexe
                ]
              );
          fiTVA:
            for TVA in C_TVA do
              AddToStream(
                F, [
                  {1:CODE} TVA.Code,
                  {2:TAUX} TVA.Taux,
                  {3:LIBELLE} TVA.Libelle
                ]
              );
        end;
        FFileStreams[F].Position := 0;
      except
        on E: Exception do
          AddException(F, E.Message);
      end;
    end
  );
  if FFileExceptions.Count > 0 then
    raise EProcessException.Create('FillOptionalInputStreams');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromEXPOCLIE(
  const RaiseErrors: Boolean);
begin
  {$REGION '<<< EXPOCLIE'}
  ForEachLine(
    fiEXPOCLIE,
    procedure(Fields: TStringList; Index, Count: Integer)
    begin
      {$REGION 'EXPOCLIE: Liste des champs'}
      // 0: CODE CLIENT
      // 1: NOM
      // 2: RUE
      // 3: COMPLEMENT ADRESSE
      // 4: CODE POSTAL
      // 5: VILLE
      // 6: TELEPHONE
      // 7: CHIFFRE D'AFFAIRE
      {$ENDREGION}
      {$REGION '>>> CLIENT'}
      if Index = 1 then
        Exit;
      AddToStream(
        foCLIENT, [
          {1:CODE} Fields[0].Trim,
          {2:TYPE} '0',
          {3:NOM_RS1} Fields[1].Trim,
          {4:PREN_RS2} '',
          {5:CIV} '',
          {6:ADR1} Fields[2].Trim,
          {7:ADR2} Fields[3].Trim,
          {8:ADR3} '',
          {9:CP} Fields[4].Trim,
          {10:VILLE} Fields[5].Trim,
          {11:PAYS} '',
          {12:CODE_COMPTABLE} '',
          {13:COM} Format('Chiffre d''affaire du client avant migration : %s', [Fields[7].Trim]),
          {14:TEL} Fields[6].Trim,
          {15:FAX_TTRAV} '',
          {16:PORTABLE} '',
          {17:EMAIL} '',
          {18:CB_NATIONAL} '',
          {19:CLASS1} '',
          {20:CLASS2} '',
          {21:CLASS3} '',
          {22:CLASS4} '',
          {23:CLASS5} '',
          {24:CB_INTERNE} '',
          {25:CLI_NUMERO} '',
          {26:CODE_MAG} ''
        ]
      );
      {$ENDREGION}
    end
  );
  {$ENDREGION}
  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromEXPOCLIE');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromEXPOFAM1(
  const RaiseErrors: Boolean);
var
  OrdreAff: TDictionary<string,integer>;
begin
  OrdreAff := TDictionary<string,integer>.Create;
  try
    ForDictionary(
      fiEXPOFAM1,
      function(Fields: TStringList): string
      begin
        {$REGION 'EXPOFAM1: Liste des champs'}
          // 0: CODE FAMILLE
          // 1: DESIGNATION
        {$ENDREGION}
        Result := Fields[0].Trim;
      end,
      procedure(DictionaryEXPOFAM1: TObjectDictionary<string,TStringList>)
      var
        Dico : TStringList;
      begin
        Dico := TStringList.create;
        Dico.Sorted := True;
        {$REGION '<<< EXPOFAM2'}
          ForEachLine(
            fiEXPOFAM2,
            procedure(Fields: TStringList; Index, Count: Integer)
            begin
              {$REGION 'EXPOFAM2: Liste des champs'}
              // 0: CODE SOUS-FAMILLE
              // 1: DESIGNATION
              // 2: CORRESPONDANCE FAMILLE
              // 3: CORRESPONDANCE RAYON
              {$ENDREGION}

                if not DictionaryEXPOFAM1.ContainsKey(Fields[2].Trim) then
                  AddException(fiEXPOFAM1,Format('Ligne %d: ID "%s" non trouvé dans EXPOFAM1',[Index,Fields[0].Trim]))
                else
                begin
                  {$REGION '>>> *AXE_NIVEAU3'}
                  if not OrdreAff.ContainsKey(Fields[3].Trim) then
                    OrdreAff.Add(Fields[3].Trim, 1)
                  else
                    OrdreAff[Fields[3].Trim] := OrdreAff[Fields[3].Trim] + 1;

                  if (Dico.IndexOf(Fields[2].Trim + ';' + Fields[3].Trim) < 0) then
                  begin
                    AddToStream(
                      foAXE_NIVEAU3, [
                        {1:CODEN2} Fields[3].Trim,
                        {2:CODE} Fields[2].Trim,
                        {3:NOM} DictionaryEXPOFAM1[Fields[2].Trim]{CODE FAMILLE->DESIGNATION}[1].Trim,
                        {4:CODEIS} '',
                        {5:VISIBLE} '1',
                        {6:CENTRALE} '0',
                        {7:ORDREAFF} OrdreAff[Fields[3].Trim].ToString,
                        {8:CODENIV} ''
                      ]
                    );
                    Dico.Add(Fields[2].Trim + ';' + Fields[3].Trim);
                  end;
                  {$ENDREGION}
                end;
              end
            );
            {$ENDREGION}
          end
        );
  finally
    OrdreAff.Free;
  end;
  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromEXPOFAM1');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromEXPOFAM2(
  const RaiseErrors: Boolean);
var
  OrdreAff: TDictionary<string,integer>;
begin
  OrdreAff := TDictionary<string,integer>.Create;
  try
    {$REGION '<<< EXPOFAM2'}
    ForEachLine(
      fiEXPOFAM2,
      procedure(Fields: TStringList; Index, Count: Integer)
      begin
        {$REGION 'EXPOFAM2: Liste des champs'}
        // 0: CODE SOUS-FAMILLE
        // 1: DESIGNATION
        // 2: CORRESPONDANCE FAMILLE
        // 3: CORRESPONDANCE RAYON
        {$ENDREGION}
        {$REGION '>>> AXE_NIVEAU4'}
        if not OrdreAff.ContainsKey(Fields[2].Trim) then
          OrdreAff.Add(Fields[2].Trim, 1)
        else
          OrdreAff[Fields[2].Trim] := OrdreAff[Fields[2].Trim] + 1;

        AddToStream(
          foAXE_NIVEAU4, [
            {1:CODEN3} Fields[2].Trim,
            {2:CODE} Fields[0].Trim,
            {3:NOM} Fields[1].Trim,
            {4:CODEIS} '',
            {5:VISIBLE} '1',
            {6:CENTRALE} '0',
            {7:ORDREAFF} OrdreAff[Fields[2].Trim].ToString,
            {8:CODENIV} '',
            {9:CODEFINAL} '',
            {10:TVA} '20',
            {11:TYPECOMPTABLE} 'PRODUIT'
          ]
        );
        {$ENDREGION}
      end
    );
    {$ENDREGION}
  finally
    OrdreAff.Free
  end;
  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromEXPOFAM2');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromEXPORAYO(
  const RaiseErrors: Boolean);
var
  OrdreAff: TDictionary<string,integer>;
begin
  OrdreAff := TDictionary<string,integer>.Create;
  try
    {$REGION '<<< EXPORAYO'}
    ForEachLine(
      fiEXPORAYO,
      procedure(Fields: TStringList; Index, Count: Integer)
      begin
        if not OrdreAff.ContainsKey(Fields[0].Trim) then
          OrdreAff.Add(Fields[0].Trim, 1)
        else
          OrdreAff[Fields[0].Trim] := OrdreAff[Fields[0].Trim] + 1;
        {$REGION '>>> AXE_NIVEAU2'}
        AddToStream(
          foAXE_NIVEAU2, [
            {1:CODEN1} '1',
            {2:CODE} Fields[0].Trim,
            {3:NOM} Fields[1].Trim,
            {4:CODEIS} '',
            {5:VISIBLE} '1',
            {6:CENTRALE} '0',
            {7:ORDREAFF} OrdreAff[Fields[0].Trim].ToString,
            {8:CODENIV} ''
          ]
        );
        {$ENDREGION}
      end
    );
    {$ENDREGION}
  finally
    OrdreAff.Free;
  end;
  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromEXPORAYO');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromEXPOTICK(
  const RaiseErrors: Boolean);
var
  sCodeTaille: string;
  ConsoDiv: TDictionary<string,integer>;
  dPXNET,
  dPXBRUT : Double;
begin
  ConsoDiv := TDictionary<string,integer>.Create;
  try
    ForDictionary(
      fiVEGAPROD,
      function(Fields: TStringList): string
      begin
        {$REGION 'VEGAPROD: Liste des champs'}
        // 0: CODE FOURNISSEUR
        // 1: CODE PRODUIT
        // 2: DESIGNATION
        // 3: CODE RAYON
        // 4: CODE FAMILLE 1
        // 5: CODE FAMILLE 2
        // 6: CODE GRILLE DE TAILLE
        // 7: CODE MARQUE
        // 8: DATE DE CREATION
        // 9: CODE GESTION PRODUIT
        // 10: CODE TVA
        // 11: CODE GESTION ETIQUETTE
        // 12: COEFFICIENT DE VENTE
        // 13: CODE PRODUIT DE REMPLACEMENT
        // 14: TABLE DES MAGASINS GERES EN STOCKS
        // 15: CODE FORMAT ETIQUETTE
        // 16: UNITE DE VENTE
        // 17: STOCK MINIMUM
        // 18: CODE FOURNISSEUR EXTERNE
        // 19: STATUS PRODUIT
        // 20: CODE GENRE
        // 21: CODE COLLECTION
        // 22: GESTION STOCK
        {$ENDREGION}
        Result := Fields[0].TrimRight + Fields[1].TrimRight; { DONE : Fix le lien entre les VEGASTOC et VEGAPROD }
      end,
      procedure(DictionaryVEGAPROD: TObjectDictionary<string,TStringList>)
      begin
        ForDictionary(
          fiTVA,
          function(Fields: TStringList): string
          begin
            {$REGION 'TVA: Liste des champs'}
            // 0: CODE
            // 1: TAUX
            // 2: LIBELLE
            {$ENDREGION}
            Result := Fields[0].Trim;
          end,
          procedure(DictionaryTVA: TObjectDictionary<string,TStringList>)
          begin
            ForDictionary(
              fiVEGASTOC,
              function(Fields: TStringList): string
              begin
                {$REGION 'VEGASTOC: Liste des champs'}
                // 0: CODE PRODUIT
                // 1: CODE MAGASIN
                // 2: INDICE TAILLE
                // 3: CODE GRILLE TAILLE
                // 4: QUANTITES EN STOCK
                // 5: PRIX D'ACHAT HT
                // 6: P.A.M.P
                // 7: COEFFICIENT DE VENTE
                // 8: PRIX DE VENTE TTC
                // 9: CODE TVA
                // 10: QUANTITES EN COMMANDE
                // 11: CODE EAN13
                // 12: LIBELLE TAILLE
                {$ENDREGION}
                Result := Fields[0].Trim;
              end,
              procedure(DictionaryVEGASTOC: TObjectDictionary<string,TStringList>)
              begin
                {$REGION '<<< EXPOTICK''}
                ForEachLine(
                  fiEXPOTICK,
                  procedure(Fields: TStringList; Index, Count: Integer)
                  begin
                    {$REGION 'EXPOTICK: Liste des champs'}
                    // 0: DATE DE VENTE
                    // 1: CODE PRODUIT
                    // 2: CODE TAILLE
                    // 3: LIBELLE TAILLE
                    // 4: CODE MAGASIN
                    // 5: CODE CAISSE
                    // 6: QUANTITE VENDUE
                    // 7: VALEUR VENTE TTC
                    // 8: Valeur HT           //SR - Ajout presta
                    // 9: MONTANT REMISE
                    // 10: MONTANT DE LA MARGE HT
                    // 11: NUMERO DU TICKET
                    // 12: CODE DU VENDEUR
                    // 13: CODE RAYON
                    // 14: CODE FAMILLE 1
                    // 15: CODE FAMILLE 2
                    // 16: CODE COLLECTION
                    // 17: CODE GENRE
                    // 18: CODE GRILLE DE TAILLE
                    {$ENDREGION}
                    {$REGION '>>> *CAISSE'}
                    if not DictionaryVEGASTOC.ContainsKey(Fields[1].Trim) then
                      AddException(foCAISSE,Format('Ligne %d: ID "%s" non trouvé dans VEGASTOC',[Index,Fields[1].Trim]))
                    else
                      if not DictionaryTVA.ContainsKey(DictionaryVEGASTOC[Fields[1].Trim]{CODE PRODUIT->CODE TVA}[9].Trim) then
                        AddException(foCAISSE,Format('Ligne %d: ID "%s" non trouvé dans TVA',[Index,DictionaryVEGASTOC[Fields[1].Trim]{CODE PRODUIT->CODE TVA}[9].Trim]))
                      else
                        if not DictionaryVEGAPROD.ContainsKey(Fields[1].Trim) then
                          AddException(foCAISSE,Format('Ligne %d: ID "%s" non trouvé dans TVA',[Index,Fields[1].Trim]))
                        else
                        begin
                          sCodeTaille := Fields[2].Trim;
                          if sCodeTaille = '' then
                            sCodeTaille := '00';    //SR - Unitaille

                          if not ConsoDiv.ContainsKey(
                            Fields[1].Trim + ';' +
                            Fields[18].Trim + '-' + sCodeTaille + ';' +
                            '1' + ';') then
                            ConsoDiv.Add(
                              Fields[1].Trim + ';' +
                              Fields[18].Trim + '-' + sCodeTaille + ';' +
                              '1' + ';',
                              StrToInt(Fields[6].Trim) {QTE})
                          else
                            ConsoDiv[
                              Fields[1].Trim + ';' +
                              Fields[18].Trim + '-' + sCodeTaille + ';' +
                              '1' + ';']
                              := ConsoDiv[Fields[1].Trim + ';' +
                                Fields[18].Trim + '-' + sCodeTaille + ';' +
                                '1' + ';'] + StrToInt(Fields[6].Trim);

                          if StrToInt(Fields[6].Trim) <> 0 then     //SR - 16/06/2016 - évite division par 0
                          begin
                            dPXBRUT := Abs((StrToFloat(Fields[7].Trim) + StrToFloat(Fields[9].Trim))/StrToInt(Fields[6].Trim));
                            dPXNET := Abs((StrToFloat(Fields[7].Trim)/StrToInt(Fields[6].Trim)));
                          end
                          else
                          begin
                            dPXBRUT := Abs(StrToFloat(Fields[7].Trim) + StrToFloat(Fields[9].Trim));
                            dPXNET := Abs(StrToFloat(Fields[7].Trim));
                          end;

                          AddToStream(
                            foCAISSE, [
                              {1:CODE_ART} Fields[1].Trim, //DictionaryVEGAPROD[Fields[1].Trim]{CODE PRODUIT CONCATENE->CODE PRODUIT}[1].Trim, { DONE : Fix le lien entre PRIX/PRIXMAG/MODELE/CAISSE }
                              {2:CODE_TAILLE} Fields[18].Trim + '-' + sCodeTaille,      //SR - 25/05/2016 - Modification pour avoir code unique
                              {3:CODE_COUL} '1', { DONE : Remplacer la valeur "UNICOULEUR" par la valeur "1" }
                              {4:EAN} DictionaryVEGASTOC[Fields[1].Trim]{CODE PRODUIT->CODE EAN13}[11].Trim,
                              {5:CODE_MAG} '00744/000', { DONE : Remplacer le champ CODE_MAG par la valeur "00744/000" }
                              {6:CODE_POSTE} '',
                              {7:CODE_SESSION} '',
                              {8:DATE} Fields[0].Trim,
                              {9:HEURE} '00:00',
                              {10:NUM_TICKET} Fields[11].Trim,
                              {11:PXBRUT} FloatToStr(dPXBRUT),
                              {12:PXNET} FloatToStr(dPXNET),
                              {13:TVA} DictionaryTVA[DictionaryVEGASTOC[Fields[1].Trim]{CODE PRODUIT->CODE TVA}[9].Trim][1].Trim, { DONE : Renseigner le libellé de la TVA }
                              {14:QTE} Fields[6].Trim,
                              {15:TYPEVTE} '1',
                              {16:CODE_CLIENT} '',
                              {17:PUMP} ''
                            ]
                          );
                        end;
                    {$ENDREGION}
                  end
                );
                {$ENDREGION}
              end
            );
          end
        );
      end
    );

    ForDictionary(
      fiVEGAPROD,
      function(Fields: TStringList): string
      begin
        {$REGION 'VEGAPROD: Liste des champs'}
        // 0: CODE FOURNISSEUR
        // 1: CODE PRODUIT
        // 2: DESIGNATION
        // 3: CODE RAYON
        // 4: CODE FAMILLE 1
        // 5: CODE FAMILLE 2
        // 6: CODE GRILLE DE TAILLE
        // 7: CODE MARQUE
        // 8: DATE DE CREATION
        // 9: CODE GESTION PRODUIT
        // 10: CODE TVA
        // 11: CODE GESTION ETIQUETTE
        // 12: COEFFICIENT DE VENTE
        // 13: CODE PRODUIT DE REMPLACEMENT
        // 14: TABLE DES MAGASINS GERES EN STOCKS
        // 15: CODE FORMAT ETIQUETTE
        // 16: UNITE DE VENTE
        // 17: STOCK MINIMUM
        // 18: CODE FOURNISSEUR EXTERNE
        // 19: STATUS PRODUIT
        // 20: CODE GENRE
        // 21: CODE COLLECTION
        // 22: GESTION STOCK
        {$ENDREGION}
      Result := Fields[0].TrimRight + Fields[1].TrimRight; { DONE : Fix le lien entre les VEGASTOC et VEGAPROD }
      end,
      procedure(DictionaryVEGAPROD: TObjectDictionary<string,TStringList>)
      var
        Value: Integer;
      begin
        {$REGION '<<< VEGASTOC''}
        ForEachLine(
          fiVEGASTOC,
          procedure(Fields: TStringList; Index, Count: Integer)
          begin
            {$REGION 'VEGASTOC: Liste des champs'}
            // 0: CODE PRODUIT
            // 1: CODE MAGASIN
            // 2: INDICE TAILLE
            // 3: CODE GRILLE TAILLE
            // 4: QUANTITES EN STOCK
            // 5: PRIX D'ACHAT HT
            // 6: P.A.M.P
            // 7: COEFFICIENT DE VENTE
            // 8: PRIX DE VENTE TTC
            // 9: CODE TVA
            // 10: QUANTITES EN COMMANDE
            // 11: CODE EAN13
            // 12: LIBELLE TAILLE
            {$ENDREGION}
            {$REGION '>>> CONSODIV'}
            if not DictionaryVEGAPROD.ContainsKey(Fields[0].Trim) then
              AddException(foCONSODIV,Format('Ligne %d: ID "%s" non trouvé dans VEGAPROD',[Index,Fields[0].Trim]))
            else
            begin
              Value := 0;
              if ConsoDiv.ContainsKey(
                Fields[0].Trim + ';' +
                Fields[3].Trim + '-' + Fields[2].Trim + ';' +
                '1' + ';') then
                Value := ConsoDiv[Fields[0].Trim + ';' +
                          Fields[3].Trim + '-' + Fields[2].Trim + ';' +
                          '1' + ';'] + StrToInt(Integer.Parse(Double.Parse(Fields[4].Trim).ToString).ToString)
              else
                Value := StrToInt(Integer.Parse(Double.Parse(Fields[4].Trim).ToString).ToString);

              if Value <> 0 then
                AddToStream(
                  foCONSODIV, [
                    {1:CODE_ART} Fields[0].Trim, //DictionaryVEGAPROD[Fields[0].Trim]{CODE FOURNISSEUR+CODE PRODUIT CONCATENE->CODE PRODUIT}[1].Trim, { DONE : Fix le lien entre les PRIX/PRIXMAG/MODELE }
                    {2:CODE_TAILLE} Fields[3].Trim + '-' + Fields[2].Trim,      //SR - 25/05/2016 - Modification pour avoir code unique
                    {3:CODE_COUL} '1',
                    {5:EAN} Fields[11].Trim,
                    {6:CODE_MAG} '00744/000', { DONE : Remplacer le champ CODE_MAG par la valeur "00744/000" }
                    {7:DATE} '01/01/2014',
                    {8:TYPE} '7',
                    {9:TYPEGINKOIA} '20',
                    {10:QTE} '-' + IntToStr(Value),
                    {11:MOTIF} 'INIT MIGRATION',
                    {12:PUMP} Double.Parse(Fields[6].Trim).ToString { DONE : PX_ACHAT -> PAMP }
                  ]
                );
            end;
            {$ENDREGION}
          end
        );
        {$ENDREGION}
      end
    );
  finally
    ConsoDiv.Free
  end;
  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromEXPOTICK');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromOthers(
  const RaiseErrors: Boolean);
begin
  {$REGION '>>> GENRE'}
  ForEachLine(
    fiGENRE,
    procedure(Fields: TStringList; Index, Count: Integer)
    begin
      AddToStream(
        foGENRE, [
          {1:CODE} Fields[0].Trim,
          {2:NOM} Fields[1].Trim,
          {3:CODESEXE} Fields[2].Trim
        ]
      );
    end
  );
  {$ENDREGION}
  {$REGION '>>> AXE'}
  AddToStream(
    foAXE, [
      {1:?} '1',
      {2:?} '4',
      {3:?} 'MIGRATION DIODON ',
      {4:?} '',
      {5:?} '1',
      {6:?} 'Univers',
      {7:?} 'Rayon',
      {8:?} 'Famille',
      {9:?} 'Sous-Famille',
      {10:?} '1'
    ]
  );
  {$ENDREGION}
  {$REGION '>>> AXE_NIVEAU1'}
  AddToStream(
    foAXE_NIVEAU1, [
      {1:?} '1',
      {2:?} '1',
      {3:?} 'SECTEUR NON DÉFINI',
      {4:?} '',
      {5:?} '1',
      {6:?} '1',
      {7:?} '0',
      {8:?} ''
    ]
  );
  {$ENDREGION}

  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromOthers');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromVEGAFOUR(
  const RaiseErrors: Boolean);
begin
  {$REGION '<<< VEGAFOUR'}
  ForEachLine(
    fiVEGAFOUR,
    procedure(Fields: TStringList; Index, Count: Integer)
    begin
      {$REGION '>>> MARQUE'}
      AddToStream(
        foMARQUE, [
          {1:CODE} Fields[0].Trim,
          {2:NOM} Fields[4].Trim,
          {3:CODEIS} '',
          {4:ACTIF} '1',
          {5:PROPRE} '1',
          {6:CENTRALE} '1'
        ]
      );
      {$ENDREGION}
      {$REGION '>>> FOUMARQUE'}
      AddToStream(
        foFOUMARQUE, [
          {1:CODE_MARQUE} Fields[0].Trim,
          {2:CODE_FOU} Fields[0].Trim,
          {3:FOU_PRINC} '1'
        ]
      );
      {$ENDREGION}
      {$REGION '>>> FOURN'}
      AddToStream(
        foFOURN, [
          {1:CODE} Fields[0].Trim,
          {2:NOM} Fields[4].Trim,
          {3:CODEIS} '',
          {4:ADR1} Fields[5].Trim,
          {5:ADR2} Fields[6].Trim,
          {6:ADR3} '',
          {7:CP} Fields[7].Trim,
          {8:VILLE} Fields[8].Trim,
          {9:PAYS} Fields[9].Trim,
          {10:TEL} Fields[10].Trim,
          {11:FAX} Fields[13].Trim,
          {12:PORTABLE} '',
          {13:EMAIL} Fields[11].Trim,
          {14:COMMENTAIRE} Format('%s + %s', [Fields[12].Trim, Fields[16].Trim]),
          {15:NUM_CLT} Fields[17].Trim,
          {16:NUM_COMPTA} '',
          {17:ACTIF} '1',
          {18:CENTRALE} '0',
          {19:ILN} ''
        ]
      );
      {$ENDREGION}
    end
  );
  {$ENDREGION}

  {$REGION '>>> MARQUE'}
  { DONE : Ajouter au fichier MARQUE la ligne "00;SANS MARQUE;;1;1;1;" }
  AddToStream(
    foMARQUE, [
      {1:CODE} '00',
      {2:NOM} 'SANS MARQUE',
      {3:CODEIS} '',
      {4:ACTIF} '1',
      {5:PROPRE} '1',
      {6:CENTRALE} '1'
    ]
  );
  {$ENDREGION}

  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromVEGAFOUR');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromVEGAGRIL(
  const RaiseErrors: Boolean);
var
  Tailles: TDictionary<string,string>;
  OrdreAff: TDictionary<string,integer>;
begin
  OrdreAff := TDictionary<string,integer>.Create;
  try
    Tailles := TDictionary<string,string>.Create;
    try
      {$REGION '<<< VEGAGRIL'}
      ForEachLine(
        fiVEGAGRIL,
        procedure(Fields: TStringList; Index, Count: Integer)
        var
          I: Integer;
          CODE, NOM: string;
        begin
          {$REGION 'VEGAGRIL: Liste des champs'}
          // 0: CODE GRILLE
          // 1: LIBELLE DE LA GRILLE
          // 2: TABLE DES TAILLES
          {$ENDREGION}
          {$REGION '>>> GR_TAILLE'}
          AddToStream(
            foGR_TAILLE, [
              {1:CODE} Fields[0].Trim,
              {2:NOM} IfThen( Fields[1].Trim = '', 'Sans nom-'+Fields[0].Trim, Fields[1].Trim ), { DONE : Remplacer les champs NOM vide par la valeur "Sans nom-CODE" }
              {3:CODEIS} '',
              {4:TYPE_GRILLE} '',
              {5:CODE_TYPEGT} '',
              {6:CODEIS_TYPEGT} '',
              {7:CENTRALE_TYPEGT} '0',
              {8:CENTRALE} '0'
            ]
          );
          {$ENDREGION}
          {$REGION '>>> GR_TAILLE_LIG'}
          I := 2;
          while I < Pred(Fields.Count) do
          begin
            try
              CODE := Fields[I].Trim;
              NOM := Fields[I+1].Trim;
              if (CODE = '00') and (NOM = '') then
                Continue;

              if not OrdreAff.ContainsKey(CODE) then
                OrdreAff.Add(CODE, 1)
              else
                OrdreAff[CODE] := OrdreAff[CODE] + 1;

              AddToStream(
                foGR_TAILLE_LIG, [
                  {1:CODE_GT} Fields[0].Trim,
                  {2:NOM} IfThen( NOM = '', 'Sans nom-'+CODE, NOM ), { DONE : Remplacer les champs NOM vide par la valeur "Sans nom-CODE" }
                  {3:CODEIS} '',
                  {4:CODE} Fields[0].Trim + '-' + CODE,    //SR - 25/05/2016 - Modification pour avoir code unique
                  {5:CENTRALE} '0',
                  {6:CORRES} '',
                  {7:ORDREAFF} OrdreAff[CODE].ToString,
                  {8:ACTIF} '1'
                ]
              );
            finally
              Inc(I,2);
            end;
          end;
          {$ENDREGION}
        end
      );
      {$ENDREGION}
    finally
      Tailles.Free;
    end;
  finally
    OrdreAff.Free;
  end;
  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromVEGAGRIL');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromVEGAPROD(
  const RaiseErrors: Boolean);
var
  FileTVA: TObjectDictionary<string,TStringList>;
begin
  ForDictionary(
    fiTVA,
    function(Fields: TStringList): string
    begin
      {$REGION 'TVA: Liste des champs'}
      // 0: CODE
      // 1: TAUX
      // 2: LIBELLE
      {$ENDREGION}
      Result := Fields[0].Trim;
    end,
    procedure(DictionaryTVA: TObjectDictionary<string,TStringList>)
    begin
      ForDictionary(
        fiEXPOFAM2,
        function(Fields: TStringList): string
        begin
          {$REGION 'EXPOFAM2: Liste des champs'}
          // 0: CODE SOUS-FAMILLE
          // 1: DESIGNATION
          // 2: CORRESPONDANCE FAMILLE
          // 3: CORRESPONDANCE RAYON
          {$ENDREGION}
          Result := Fields[0].Trim;
        end,
        procedure(DictionaryEXPOFAM2: TObjectDictionary<string,TStringList>)
        begin
          ForDictionary(
            fiEXPOFAM1,
            function(Fields: TStringList): string
            begin
              {$REGION 'EXPOFAM1: Liste des champs'}
              // 0: CODE FAMILLE
              // 1: DESIGNATION
              {$ENDREGION}
              Result := Fields[0].Trim;
            end,
            procedure(DictionaryEXPOFAM1: TObjectDictionary<string,TStringList>)
            begin
              ForDictionary(
                fiEXPORAYO,
                function(Fields: TStringList): string
                begin
                  {$REGION 'EXPORAYO: Liste des champs'}
                  // 0: CODE RAYON
                  // 1: DESIGNATION
                  {$ENDREGION}
                  Result := Fields[0].Trim;
                end,
                procedure(DictionaryEXPORAYO: TObjectDictionary<string,TStringList>)
                begin
                  ForDictionary(
                    fiLIENFAM,
                    function(Fields: TStringList): string
                    begin
                      {$REGION 'LIENFAM: Liste des champs'}
                      // 0: RAYON
                      // 1: FAMILLE
                      // 2: SOUS FAMILLE
                      // 3: RAYON DEST
                      // 4: FAMILLE DEST
                      // 5: SOUS FAMILLE DEST
                      // 6: ID SOUS FAMILLE DEST
                      {$ENDREGION}
                      Result := Fields[2].Trim + ';' + Fields[1].Trim + ';' + Fields[0].Trim;
                    end,
                    procedure(DictionaryLIENFAM: TObjectDictionary<string,TStringList>)
                    begin
                      {$REGION '<<< VEGAPROD'}
                      ForEachLine(
                        fiVEGAPROD,
                        procedure(Fields: TStringList; Index, Count: Integer)
                        begin
                          {$REGION 'VEGAPROD: Liste des champs'}
                          // 0: CODE FOURNISSEUR
                          // 1: CODE PRODUIT
                          // 2: DESIGNATION
                          // 3: CODE RAYON
                          // 4: CODE FAMILLE 1
                          // 5: CODE FAMILLE 2
                          // 6: CODE GRILLE DE TAILLE
                          // 7: CODE MARQUE
                          // 8: DATE DE CREATION
                          // 9: CODE GESTION PRODUIT
                          // 10: CODE TVA
                          // 11: CODE GESTION ETIQUETTE
                          // 12: COEFFICIENT DE VENTE
                          // 13: CODE PRODUIT DE REMPLACEMENT
                          // 14: TABLE DES MAGASINS GERES EN STOCKS
                          // 15: CODE FORMAT ETIQUETTE
                          // 16: UNITE DE VENTE
                          // 17: STOCK MINIMUM
                          // 18: CODE FOURNISSEUR EXTERNE
                          // 19: STATUS PRODUIT
                          // 20: CODE GENRE
                          // 21: CODE COLLECTION
                          // 22: GESTION STOCK
                          {$ENDREGION}
                          {$REGION '>>> MODELE'}
                          if not DictionaryTVA.ContainsKey(Fields[10].Trim) then
                            AddException(foMODELE,Format('Ligne %d: ID "%s" non trouvé dans TVA',[Index,Fields[10].Trim]))
                          else
                          begin
                            AddToStream(
                              foMODELE, [
                                {1:CODE} Fields[0].Trim + Fields[1].Trim,
                                {2:CODE_MRQ} Fields[7].Trim,
                                {3:CODE_GT} Fields[6].Trim,
                                {4:CODE_FOURN} Fields[1].Trim, { DONE : CODE_FOURN -> CODE }
                                {5:NOM} Fields[2].Trim,
                                {6:CODEIS} '',
                                {7:CODEFEDAS} '',
                                {8:DESCRIPTION} '',
                                {9:CLASS1} '',
                                {10:CLASS2} '',
                                {11:CLASS3} '',
                                {12:CLASS4} '',
                                {13:CLASS5} '',
                                {14:CLASS6} '',
                                {15:FIDELITE} '1',
                                {16:DATECREATION} FormatDateTime( 'dd/mm/yy', EncodeDate(
                                  StrToInt(Fields[8][1]+Fields[8][2]+Fields[8][3]+Fields[8][4]),
                                  StrToInt(Fields[8][5]+Fields[8][6]),
                                  StrToInt(Fields[8][7]+Fields[8][8])) ),
                                {17:COMENT1} '',
                                {18:COMENT2} '',
                                {19:TVA} DictionaryTVA[Fields[10]]{CODE TVA->CODE}[1], { DONE : Renseigner le libellé de la TVA }
                                {20:PSEUDO} '0',
                                {21:ARCHIVER} Fields[19].Trim,
                                {22:CODE_GENRE} Fields[20].Trim,
                                {23:CODE_DOMAINE} '1',            //SR - 02-06-2016 - ISF
                                {24:CENTRALE} '0',
                                {25:TYPECOMPTABLE} 'PRODUIT',
                                {26:FLAGMODELE} '1',
                                {27:STKIDEAL} Fields[17].Trim
                              ]
                            );
                          end;
                          {$ENDREGION}
                          {$REGION '>>> ARTICLE_AXE'}
                          if not DictionaryEXPOFAM2.ContainsKey(Fields[5].Trim) then
                            AddException(foARTICLE_AXE,Format('Ligne %d: ID "%s" non trouvé dans EXPOFAM2',[Index,Fields[5].Trim]))
                          else
                            if not DictionaryEXPOFAM1.ContainsKey(DictionaryEXPOFAM2[Fields[5].Trim]{CODE FAMILLE}[2].Trim) then
                              AddException(foARTICLE_AXE,Format('Ligne %d: ID "%s" non trouvé dans EXPOFAM1',[Index,DictionaryEXPOFAM2[Fields[5].Trim]{CODE FAMILLE}[2].Trim]))
                            else
                              if not DictionaryEXPORAYO.ContainsKey(DictionaryEXPOFAM2[Fields[5].Trim]{CODE RAYON}[3].Trim) then
                                AddException(foARTICLE_AXE,Format('Ligne %d: ID "%s" non trouvé dans EXPORAYO',[Index,DictionaryEXPOFAM2[Fields[5].Trim]{CODE RAYON}[3].Trim]))
                              else
                                if not DictionaryLIENFAM.ContainsKey(
                                  DictionaryEXPOFAM2[Fields[5].Trim]{CODE FAMILLE 2->DESIGNATION}[1].Trim + ';' +
                                  DictionaryEXPOFAM1[DictionaryEXPOFAM2[Fields[5].Trim]{CODE FAMILLE}[2].Trim]{CODE FAMILLE 1->DESIGNATION}[1].Trim + ';' +
                                  DictionaryEXPORAYO[DictionaryEXPOFAM2[Fields[5].Trim]{CODE RAYON}[3].Trim]{CODE RAYON->DESIGNATION}[1].Trim) then
                                  AddException(foARTICLE_AXE,Format('Ligne %d: ID "%s" non trouvé dans LIENFAM',[Index,
                                    DictionaryEXPOFAM2[Fields[5].Trim]{CODE FAMILLE 2->DESIGNATION}[1].Trim + ';' +
                                    DictionaryEXPOFAM1[DictionaryEXPOFAM2[Fields[5].Trim]{CODE FAMILLE}[2].Trim]{CODE FAMILLE 1->DESIGNATION}[1].Trim + ';' +
                                    DictionaryEXPORAYO[DictionaryEXPOFAM2[Fields[5].Trim]{CODE RAYON}[3].Trim]{CODE RAYON->DESIGNATION}[1].Trim]))
                                else
                                begin
                                  AddToStream(
                                    foARTICLE_AXE, [
                                      {1:CODE_ART} Fields[0].Trim + Fields[1].Trim,
                                      {2:CODE_N4} Fields[5].Trim,
                                      {3:CODE_AXE} '1'
                                    ]
                                  );
//                                  AddToStream(
//                                    foARTICLE_AXE, [
//                                      {1:CODE_ART} Fields[0].Trim + Fields[1].Trim,
//                                      {2:CODE_N4} DictionaryLIENFAM[
//                                        DictionaryEXPOFAM2[Fields[5].Trim]{CODE FAMILLE 2->DESIGNATION}[1].Trim + ';' +
//                                        DictionaryEXPOFAM1[DictionaryEXPOFAM2[Fields[5].Trim]{CODE FAMILLE}[2].Trim]{CODE FAMILLE 1->DESIGNATION}[1].Trim + ';' +
//                                        DictionaryEXPORAYO[DictionaryEXPOFAM2[Fields[5].Trim]{CODE RAYON}[3].Trim]{CODE RAYON->DESIGNATION}[1].Trim][6].Trim,
//                                      {3:CODE_AXE} '999'
//                                    ]
//                                  );
                                end;
                          {$ENDREGION}
                          {$REGION '>>> COULEUR'}
                          AddToStream(
                            foCOULEUR, [
                              {1:CODE_ART} Fields[0].Trim + Fields[1].Trim,
                              {2:COU_NOM} 'UNICOULEUR',
                              {3:COU_CODE} '1',
                              {4:CODEIS} '',
                              {5:COU_CENT} '0',
                              {6:COU_SMU} '0',
                              {7:COU_TDSC} '0'
                            ]
                          );
                          {$ENDREGION}
                        end
                      );
                      {$ENDREGION}
                    end
                  );
                end
              );
            end
          );
        end
      );
    end
  );
  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromVEGAPROD');
end;

procedure TThreadMigrationLaignel.FillOutputStreamsFromVEGASTOC(
  const RaiseErrors: Boolean);
begin
  ForDictionary(
    fiVEGAPROD,
    function(Fields: TStringList): string
    begin
      {$REGION 'VEGAPROD: Liste des champs'}
      // 0: CODE FOURNISSEUR
      // 1: CODE PRODUIT
      // 2: DESIGNATION
      // 3: CODE RAYON
      // 4: CODE FAMILLE 1
      // 5: CODE FAMILLE 2
      // 6: CODE GRILLE DE TAILLE
      // 7: CODE MARQUE
      // 8: DATE DE CREATION
      // 9: CODE GESTION PRODUIT
      // 10: CODE TVA
      // 11: CODE GESTION ETIQUETTE
      // 12: COEFFICIENT DE VENTE
      // 13: CODE PRODUIT DE REMPLACEMENT
      // 14: TABLE DES MAGASINS GERES EN STOCKS
      // 15: CODE FORMAT ETIQUETTE
      // 16: UNITE DE VENTE
      // 17: STOCK MINIMUM
      // 18: CODE FOURNISSEUR EXTERNE
      // 19: STATUS PRODUIT
      // 20: CODE GENRE
      // 21: CODE COLLECTION
      // 22: GESTION STOCK
      {$ENDREGION}
      Result := Fields[0].TrimRight + Fields[1].TrimRight; { DONE : Fix le lien entre les VEGASTOC et VEGAPROD }
    end,
    procedure(DictionaryVEGAPROD: TObjectDictionary<string,TStringList>)
    var
      IDList_PRIX, IDList_PRIXMAG: TObjectDictionary<string,TStringList>;
      ID_Exists: Boolean;
      Key, Value: string;
    begin
      IDList_PRIX := TObjectDictionary<string,TStringList>.Create([doOwnsValues]);
      IDList_PRIXMAG := TObjectDictionary<string,TStringList>.Create([doOwnsValues]);
      try
        {$REGION '<<< VEGASTOC''}
        ForEachLine(
          fiVEGASTOC,
          procedure(Fields: TStringList; Index, Count: Integer)
          begin
            {$REGION 'VEGASTOC: Liste des champs'}
            // 0: CODE PRODUIT
            // 1: CODE MAGASIN
            // 2: INDICE TAILLE
            // 3: CODE GRILLE TAILLE
            // 4: QUANTITES EN STOCK
            // 5: PRIX D'ACHAT HT
            // 6: P.A.M.P
            // 7: COEFFICIENT DE VENTE
            // 8: PRIX DE VENTE TTC
            // 9: CODE TVA
            // 10: QUANTITES EN COMMANDE
            // 11: CODE EAN13
            // 12: LIBELLE TAILLE
            {$ENDREGION}
            {$REGION '>>> *PRIX'}
            if not DictionaryVEGAPROD.ContainsKey(Fields[0].Trim) then
              AddException(foPRIX,Format('Ligne %d: ID "%s" non trouvé dans VEGAPROD',[Index,Fields[0].Trim]))
            else
            begin
              Key := Fields[0].Trim;
              Value := DictionaryVEGAPROD[Fields[0].Trim]{CODE PRODUIT->CODE FOURNISSEUR}[0].Trim;

              if not IDList_PRIX.ContainsKey(Key) then
                IDList_PRIX.Add(Key, TStringList.Create);
              ID_Exists := IDList_PRIX[Key].IndexOf(Value) >= 0;

              { DONE : Fix prix de base dans PRIX.CSV }
              if not ID_Exists then
                AddToStream(
                  foPRIX, [
                    {1:CODE_ART} Fields[0].Trim, //DictionaryVEGAPROD[Fields[0].Trim]{CODE FOURNISSEUR+CODE PRODUIT CONCATENE->CODE PRODUIT}[1].Trim, { DONE : Fix le lien entre les PRIX/PRIXMAG/MODELE }
                    {2:CODE_TAILLE} '0',
                    {3:CODE_COUL} '0',
                    {4:CODE_FOU} DictionaryVEGAPROD[Fields[0].Trim]{CODE PRODUIT->CODE FOURNISSEUR}[0].Trim,
                    {5:PXCATALOGUE} Double.Parse(Fields[5].Trim).ToString,
                    {6:PX_ACHAT} Double.Parse(Fields[6].Trim).ToString, { DONE : PX_ACHAT -> PAMP }
                    {7:FOU_PRINCIPAL} '1',
                    {8:PXDEBASE} '1'
                  ]
                );

              AddToStream(
                foPRIX, [
                  {1:CODE_ART} Fields[0].Trim, //DictionaryVEGAPROD[Fields[0].Trim]{CODE FOURNISSEUR+CODE PRODUIT CONCATENE->CODE PRODUIT}[1].Trim, { DONE : Fix le lien entre les PRIX/PRIXMAG/MODELE }
                  {2:CODE_TAILLE} Fields[3].Trim + '-' + Fields[2].Trim,      //SR - 25/05/2016 - Modification pour avoir code unique
                  {3:CODE_COUL} '1',
                  {4:CODE_FOU} DictionaryVEGAPROD[Fields[0].Trim]{CODE PRODUIT->CODE FOURNISSEUR}[0].Trim,
                  {5:PXCATALOGUE} Double.Parse(Fields[5].Trim).ToString,
                  {6:PX_ACHAT} Double.Parse(Fields[6].Trim).ToString, { DONE : PX_ACHAT -> PAMP }
                  {7:FOU_PRINCIPAL} '1',
                  {8:PXDEBASE} '0'
                ]
              );
              if not ID_Exists then
                IDList_PRIX[Key].Add(Value);
            end;
            {$ENDREGION}
            {$REGION '>>> ARTICLE'}
            AddToStream(
              foARTICLE, [
                {1:CODE_ART} Fields[0].Trim, //DictionaryVEGAPROD[Fields[0].Trim]{CODE FOURNISSEUR+CODE PRODUIT CONCATENE->CODE PRODUIT}[1].Trim, { DONE : Fix le lien entre les PRIX/PRIXMAG/MODELE }
                {2:CODE_TAILLE} Fields[3].Trim + '-' + Fields[2].Trim,       //SR - 25/05/2016 - Modification pour avoir code unique
                {3:CODE_COUL} '1',
                {4:EAN} Fields[11].Trim,
                {5:TYPE} '3'
              ]
            );
            {$ENDREGION}
            {$REGION '>>> PRIXMAG'}
            Key := Fields[0].Trim;
            Value := Fields[1].Trim;

            if not IDList_PRIXMAG.ContainsKey(Key) then
              IDList_PRIXMAG.Add(Key, TStringList.Create);
            ID_Exists := IDList_PRIXMAG[Key].IndexOf(Value) >= 0;

            { DONE : Fix prix de base dans PRIXMAG.CSV }
            if not ID_Exists then
              AddToStream(
                foPRIXMAG, [
                  {1:CODE_ART} Fields[0].Trim, //DictionaryVEGAPROD[Fields[0].Trim]{CODE FOURNISSEUR+CODE PRODUIT CONCATENE->CODE PRODUIT}[1].Trim, { DONE : Fix le lien entre les PRIX/PRIXMAG/MODELE }
                  {2:CODE_TAILLE} '0',
                  {3:CODE_COUL} '0',
                  {4:NOMTAR} '00744/000', //Fields[1].Trim,
                  {5:PX_VENTE} Double.Parse(Fields[8].Trim).ToString,
                  {6:PXDEBASE} '1'
                ]
              );

            AddToStream(
              foPRIXMAG, [
                {1:CODE_ART} Fields[0].Trim, //DictionaryVEGAPROD[Fields[0].Trim]{CODE FOURNISSEUR+CODE PRODUIT CONCATENE->CODE PRODUIT}[1].Trim, { DONE : Fix le lien entre les PRIX/PRIXMAG/MODELE }
                {2:CODE_TAILLE} Fields[3].Trim + '-' + Fields[2].Trim,    //SR - 25/05/2016 - Modification pour avoir code unique
                {3:CODE_COUL} '1',
                {4:NOMTAR} '00744/000', //Fields[1].Trim,
                {5:PX_VENTE} Double.Parse(Fields[8].Trim).ToString,
                {6:PXDEBASE} '0'
              ]
            );
            if not ID_Exists then
              IDList_PRIXMAG[Key].Add(Value);
            {$ENDREGION}
            {$REGION '>>> STOCK'}
            try
              if Integer.Parse(Double.Parse(Fields[4].Trim).ToString).ToString <> '0' then
                AddToStream(
                  foSTOCK, [
                    {1:EAN} Fields[11].Trim,
                    {2:QTE} Integer.Parse(Double.Parse(Fields[4].Trim).ToString).ToString { DONE : Conversion float en integer }
                  ]
                );
            except
              on E: Exception do
                AddException(foSTOCK, Format('Ligne %d: %s',[Index, E.Message]));
            end;
            {$ENDREGION}
          end
        );
        {$ENDREGION}
      finally
        IDList_PRIX.Free;
        IDList_PRIXMAG.Free;
      end;
    end
  );
  if RaiseErrors and (FFileExceptions.Count > 0) then
    raise EProcessException.Create('FillOutputStreamsFromVEGASTOC');
end;

procedure TThreadMigrationLaignel.ForDictionary(const F: TFile;
  const Func: TFunc<TStringList, string>;
  const Proc: TProc<TObjectDictionary<string,TStringList>>);
var
  FileDictionary: TObjectDictionary<string,TStringList>;
begin
  FileDictionary := TObjectDictionary<string,TStringList>.Create([doOwnsValues]);
  try
    ForEachLine(
      F,
      procedure(Fields: TStringList; Index, Count: Integer)
      var
        Key: string;
      begin
        Key := Func(Fields);
        if FileDictionary.ContainsKey(Key) then
          Exit;
        FileDictionary.Add(Key, TStringList.Create);
        FileDictionary[Key].AddStrings(Fields);
      end
    );
    Proc(FileDictionary);
  finally
    FileDictionary.Free;
  end;
end;

procedure TThreadMigrationLaignel.ForEachException(
  const Proc: TProc<TFile,TFileRec,string>);
begin
  ForEachFile(
    procedure(F: TFile; R: TFileRec)
    var
      S: string;
    begin
      if FFileExceptions.ContainsKey(F) then
        for S in FFileExceptions[F] do
        begin
          if Terminated then
            raise EAbort.Create('<aborted>');
          Proc(F, R, S);
        end;
    end
  )
end;

procedure TThreadMigrationLaignel.ForEachField(const Line: string;
  const Proc: TProc<TStringList>);
var
  Fields: TStringList;
begin
  if Terminated then
    raise EAbort.Create('<aborted>');
  Fields := TStringList.Create;
  try
    Fields.StrictDelimiter := True;
    Fields.Delimiter := ';';
    Fields.DelimitedText := Line;
    Proc(Fields);
  finally
    Fields.Free;
  end;
end;

procedure TThreadMigrationLaignel.ForEachFile(
  const Proc: TProc<TFile, TFileRec>);
var
  F: TFile;
begin
  for F := Low(TFile) to High(TFile) do
  begin
    if Terminated then
      raise EAbort.Create('<aborted>');
    Proc(F,Files[F]);
  end;
end;

procedure TThreadMigrationLaignel.ForEachLine(const F: TFile;
  const Proc: TProc<TStringList, Integer, Integer>);
var
  StringList: TStringList;
  Count, I: Integer;
begin
  StringList := TStringList.Create;
  try
    FFileStreams[F].Position := 0;
    StringList.LoadFromStream(FFileStreams[F], TEncoding.ANSI);
    Count := StringList.Count;
    for I := 1 to Count do
    begin
      if Terminated then
        raise EAbort.Create('<aborted>');
      ForEachField(
        StringList[Pred(I)],
        procedure(Fields: TStringList)
        begin
          try
            Proc(Fields, I, Count);
          except
            on E: Exception do
              AddException(F, E.Message);
          end;
        end
      );
    end;
  finally
    StringList.Free;
  end;
end;

{ TFileRec }

constructor TFileRec.CreateInput(const Name: string;
  const Options: TFileOptions; const Extension: string);
begin
  Self.Kind := fkInput;
  Self.Name := TrimLeft(Name) + TrimRight(Extension);
  Self.Options := Options;
end;

constructor TFileRec.CreateOutput(const Name, Extension: string);
begin
  Self.Kind := fkOutput;
  Self.Name := TrimLeft(Name) + TrimRight(Extension);
  Self.Options := [];
end;

initialization
  InitFiles;

finalization
  Files.Free;

end.
