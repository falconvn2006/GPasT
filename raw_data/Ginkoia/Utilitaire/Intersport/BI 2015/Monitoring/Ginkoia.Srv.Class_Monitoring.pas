unit Ginkoia.Srv.Class_Monitoring;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.Win.Registry,
  System.DateUtils,
  System.Math,
  System.StrUtils,
  Winapi.Windows,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.DApt,
  FireDAC.Comp.Client,
  Data.DB;

type
  TNiveauAlerte   = (nivOk, nivNotice, nivAttention, nivErreur,
                     nivHorsDelais, nivDoubleHorsDelais);
  TLogLevel       = (logNone, logDebug, logTrace, logInfo, logNotice, logWarning,
                     logError, logCritical, logEmergency);
  TPourcentsEtats = array[nivOk .. nivDoubleHorsDelais] of Single;

  TNbEtats = class
    nivOk               : Integer;
    nivNotice           : Integer;
    nivAttention        : Integer;
    nivErreur           : Integer;
    nivHorsDelais       : Integer;
    nivDoubleHorsDelais : Integer;
  end;

  TParametresConnection = class
    DLL             : string;
    Server          : string;
    Database        : string;
    User_Name       : string;
    Password        : string;
  end;

{******************************************************************************}
{ Types de base retournés par le WebService                                    }
{******************************************************************************}

  TVersion = class
    NomExe          : string;
    VersionExe      : string;
  end;
  TVersions = TObjectList<TVersion>;

  TElementErreur = class
    ErreurElement   : TNiveauAlerte;
    MagasinErreur   : string;
    DossierErreur   : string;
    ServeurErreur   : string;
    IPErreur        : string;
  end;
  TElementsErreur = TObjectList<TElementErreur>;

  TEvenement = class
    EtatEvenement       : TNiveauAlerte;
    HeureEvenement      : Int64;
    TypeEvenement       : string;
    DetailEvenement     : string;
    ServeurEvenement    : string;
    IPEvenement         : string;
  end;
  TEvenements = TObjectList<TEvenement>;

  TMagasin = class
    EtatMagasin     : TNiveauAlerte;
    NomMagasin      : string;
    DossierMagasin  : string;
    ServeurMagasin  : string;
    IPMagasin       : string;
    Versions        : TVersions;
  end;
  TMagasins = TObjectList<TMagasin>;

  TDossier = class
    PourcentEtat    : TPourcentsEtats;
    NomDossier      : string;
  end;
  TDossiers = TObjectList<TDossier>;

{******************************************************************************}
{ Types internes pour les traitements                                          }
{******************************************************************************}

  TiEvenement = class(TEvenement)
  strict private
    { Déclarations privées }
    function    GetEvenement(): TEvenement;
  published
    { Déclarations publiées }
    constructor Create(const AIdEvenement: Integer;
      const AEtatEvenement: TNiveauAlerte;
      const AHeureEvenement: Int64;
      const ATypeEvenement, ADetailEvenement, AServeurEvenement, AIPEvenement: string);
  public
    { Déclarations publiques }
    IdEvenement     : Integer;
    property    Evenement       : TEvenement    read GetEvenement;
  end;

  TiEvenements = class(TObjectList<TiEvenement>)
  strict private
    { Déclarations privées }
    function    GetEvenements(): TEvenements;
  published
    { Déclarations publiées }
    constructor Create(const ANomDossier, ANomMagasin, AType: string;
      const ADebut, AFin: Integer);
  public
    { Déclarations publiques }
    NbEvenements      : Integer;
    FreqEvenements    : Integer;
    ProchainEvenement : Int64;
    property    Evenements      : TEvenements   read GetEvenements;
  end;

  TiMagasin = class(TMagasin)
  strict private
    { Déclarations privées }
    FEvenementsStatus : TiEvenements;
    FEvenementsStock  : TiEvenements;
    function    GetMagasin(): TMagasin;
    function    GetEvenementsStatus(): TEvenements;
    function    GetEvenementsStock(): TEvenements;
  published
    { Déclarations publiées }   
    constructor Create(const ANomDossier, ANomMagasin: string);
    destructor Destroy();
  public
    { Déclarations publiques }
    property    Magasin         : TMagasin      read GetMagasin;
    property    EvenementsStatus: TEvenements   read GetEvenementsStatus;
    property    EvenementsStock : TEvenements   read GetEvenementsStock;
  end;

  TiMagasins = class(TObjectList<TiMagasin>)
  strict private
    { Déclarations privées }
    function    GetMagasins(): TMagasins;
  published
    { Déclarations publiées }
    constructor Create(const ANomDossier: string);
  public
    { Déclarations publiques }
    property    Magasins        : TMagasins      read GetMagasins;
  end;

  TiDossier = class(TDossier)
  strict private
    { Déclarations privées }
    FMagasins   : TiMagasins;
    function    GetDossier(): TDossier;
    function    GetMagasins(): TMagasins;
  published
    { Déclarations publiées }
    constructor Create(const ANomDossier: string);
  public
    { Déclarations publiques }
    property    Dossier         : TDossier       read GetDossier;
    property    Magasins        : TMagasins      read GetMagasins;
  end;

  TiDossiers = class(TObjectList<TiDossier>)
  strict private
    { Déclarations privées }
    function    GetDossiers(): TDossiers;
    function    GetElementsErreur(): TElementsErreur;
    function    GetEtatGlobal(): TNbEtats;
  published
    { Déclarations publiées }
    constructor Create();
  public
    { Déclarations publiques }
    property    Dossiers        : TDossiers       read GetDossiers;
    property    ElementsErreur  : TElementsErreur read GetElementsErreur;
    property    EtatGlobal      : TNbEtats        read GetEtatGlobal;
  end;

const
  NOM_APPLICATION = 'ExtractBI';
  CLE_REGISTRE    = 'Software\Ginkoia\MonitorBI\';

var
  FDConnection        : TFDConnection;
  FDPhysIBDriverLink  : TFDPhysMySQLDriverLink;
  sDatabaseParam      : string;

function Connecter(var AFDConnection: TFDConnection;
  var AFDPhysDriverLink: TFDPhysMySQLDriverLink): Boolean;

implementation

function Connecter(var AFDConnection: TFDConnection;
  var AFDPhysDriverLink: TFDPhysMySQLDriverLink): Boolean;
var
  regParametres: TRegistry;
begin
  // Effet de bord si la base est déjà connectée
  if AFDConnection.Connected then
    AFDConnection.Close();

  regParametres := TRegistry.Create(KEY_READ);
  try
    if regParametres.OpenKey(CLE_REGISTRE, True) then
    begin
      // Paramètre la connection
      AFDPhysDriverLink.VendorLib              := regParametres.ReadString('DLL');
      AFDConnection.Params.Clear();
      AFDConnection.Params.Values['DriverID']  := 'MySQL';
      AFDConnection.Params.Values['Server']    := regParametres.ReadString('Server');
      AFDConnection.Params.Values['Database']  := regParametres.ReadString('Database');
      AFDConnection.Params.Values['User_Name'] := regParametres.ReadString('User_Name');
      AFDConnection.Params.Values['Password']  := regParametres.ReadString('Password');

      sDatabaseParam                           := regParametres.ReadString('DatabaseParam');

      regParametres.CloseKey();

      // Ouvre la connection
      AFDConnection.Open();
    end;
  finally
    regParametres.Free();
  end;

  // Retourne le résultat de la connection
  Result := AFDConnection.Connected;
end;

{ TiEvenement }

constructor TiEvenement.Create(const AIdEvenement: Integer;
  const AEtatEvenement: TNiveauAlerte;
  const AHeureEvenement: Int64;
  const ATypeEvenement, ADetailEvenement, AServeurEvenement, AIPEvenement: string);
begin
  IdEvenement         := AIdEvenement;
  EtatEvenement       := AEtatEvenement;
  HeureEvenement      := AHeureEvenement;
  TypeEvenement       := ATypeEvenement;
  DetailEvenement     := ADetailEvenement;
  ServeurEvenement    := AServeurEvenement;
  IPEvenement         := AIPEvenement;
end;

function TiEvenement.GetEvenement(): TEvenement;
begin
  Result := TEvenement(Self);
end;

{ TiEvenements }

constructor TiEvenements.Create(const ANomDossier, ANomMagasin, AType: string;
  const ADebut, AFin: Integer);
var
  QueMagasin      : TFDQuery;
  QueNbEvenements : TFDQuery;
  QueEvenements   : TFDQuery;
  Evenement       : TiEvenement;
  EtatEvenement   : TNiveauAlerte;
  EtatMagasin     : TNiveauAlerte;
  iNbLogMagasin   : Integer;
begin
  try
    // Créer la requête
    QueMagasin                  := TFDQuery.Create(nil);
    QueMagasin.Connection       := FDConnection;
    QueNbEvenements             := TFDQuery.Create(nil);
    QueNbEvenements.Connection  := FDConnection;
    QueEvenements               := TFDQuery.Create(nil);
    QueEvenements.Connection    := FDConnection;

    // Connection à la base de données
    if FDConnection.Connected then
    begin
      // Requête pour avoir l'état du magasin
      QueMagasin.SQL.Clear();
      QueMagasin.SQL.Add('SELECT log_id, log_lvl, log_freq, log_update, log_srv, log_remoteip, log_key, log_date, log_val');
      QueMagasin.SQL.Add('FROM   log_log');
      QueMagasin.SQL.Add('WHERE  log_app = :NomApplication');
      QueMagasin.SQL.Add('  AND  log_dos = :NomDossier');
      QueMagasin.SQL.Add('  AND  log_ref = :NomMagasin');
      QueMagasin.SQL.Add('  AND  log_key = :TypeEvenement');
      QueMagasin.SQL.Add('ORDER  BY log_update DESC');
      QueMagasin.SQL.Add('LIMIT  1;');
      QueMagasin.ParamByName('NomApplication').AsString := NOM_APPLICATION;
      QueMagasin.ParamByName('NomDossier').AsString     := ANomDossier;
      QueMagasin.ParamByName('NomMagasin').AsString     := ANomMagasin;
      QueMagasin.ParamByName('TypeEvenement').AsString  := AType;

      // Requête pour avoir le nombre total d'événements
      QueNbEvenements.SQL.Clear();
      QueNbEvenements.SQL.Add('SELECT COUNT(*) NbEvenements');
      QueNbEvenements.SQL.Add('FROM   log_value');
      QueNbEvenements.SQL.Add('WHERE  val_logid = :LogId;');

      // Requête pour avoir les évenements du magasin
      QueEvenements.SQL.Clear();
      QueEvenements.SQL.Add('SELECT val_id, val_date, val_val, val_lvl, val_remoteip');
      QueEvenements.SQL.Add('FROM   log_value');
      QueEvenements.SQL.Add('WHERE  val_logid = :LogId');
      QueEvenements.SQL.Add('ORDER  BY val_id DESC');
      QueEvenements.SQL.Add('LIMIT  :Debut, :Fin;');

      QueMagasin.Open();

      iNbLogMagasin     := QueMagasin.RecordCount;
      NbEvenements      := 0;
      FreqEvenements    := 0;
      ProchainEvenement := 0;

      while not(QueMagasin.Eof) do
      begin
        FreqEvenements    := QueMagasin.FieldByName('log_freq').AsInteger;
        ProchainEvenement := DateTimeToUnix(IncSecond(QueMagasin.FieldByName('log_date').AsDateTime, FreqEvenements), False);

        try
          QueNbEvenements.ParamByName('LogId').AsInteger := QueMagasin.FieldByName('log_id').AsInteger;
          QueNbEvenements.Open();

          NbEvenements := NbEvenements + QueNbEvenements.FieldByName('NbEvenements').AsInteger;
        finally
          QueNbEvenements.Close();
        end;

        try
          QueEvenements.ParamByName('Debut').AsInteger := ADebut;
          QueEvenements.ParamByName('Fin').AsInteger   := AFin;
          QueEvenements.ParamByName('LogId').AsInteger := QueMagasin.FieldByName('log_id').AsInteger;
          QueEvenements.Open();

          // S'il reste des événements d'enregistrés, on les retourne
          if not(QueEvenements.IsEmpty()) then
          begin
            while not(QueEvenements.Eof) do
            begin
              case QueEvenements.FieldByName('val_lvl').AsInteger of
                1..3: EtatEvenement := nivOk;
                4:    EtatEvenement := nivNotice;
                5:    EtatEvenement := nivAttention;
                else
                  EtatEvenement := nivErreur;
              end;

              Evenement     := TiEvenement.Create(QueEvenements.FieldByName('val_id').AsInteger,
                EtatEvenement,
                DateTimeToUnix(QueEvenements.FieldByName('val_date').AsDateTime, False),
                QueMagasin.FieldByName('log_key').AsString,
                QueEvenements.FieldByName('val_val').AsString,
                QueMagasin.FieldByName('log_srv').AsString,
                QueEvenements.FieldByName('val_remoteip').AsString);

              Self.Add(Evenement);

              QueEvenements.Next();
            end;
          end
          else begin
            // S'il ne reste plus d'événements (ils ont été nettoyés), on retrourne une ligne avec le statut général
            case QueMagasin.FieldByName('log_lvl').AsInteger of
              1..3: EtatEvenement := nivOk;
              4:    EtatEvenement := nivNotice;
              5:    EtatEvenement := nivAttention;
              else
                EtatEvenement := nivErreur;
            end;

            Evenement     := TiEvenement.Create(MaxInt,
              EtatEvenement,
              DateTimeToUnix(QueMagasin.FieldByName('log_update').AsDateTime, False),
              QueMagasin.FieldByName('log_key').AsString,
              QueMagasin.FieldByName('log_val').AsString,
              QueMagasin.FieldByName('log_srv').AsString,
              QueMagasin.FieldByName('log_remoteip').AsString);

            Self.Add(Evenement);
          end;
        finally
          QueEvenements.Close();
        end;

        // Retourne le niveau d'erreur du magasin
        case QueMagasin.FieldByName('log_lvl').AsInteger of
          1..3: EtatMagasin := nivOk;
          4:    EtatMagasin := nivNotice;
          else
            EtatMagasin := nivErreur;
        end;

        // Si le magasin a un niveau d'erreur acceptable vérifie que la dernière
        // extraction n'est pas trop vieille
        if (EtatMagasin in [nivOk .. nivAttention])
          and (ADebut = 0) then
        begin
          // Si on n'a pas de réussite depuis plus de 2 cycles
          if not(WithinPastSeconds(Now(),
            QueMagasin.FieldByName('log_update').AsDateTime,
            (QueMagasin.FieldByName('log_freq').AsInteger * 2))) then
          begin
            EtatMagasin := nivDoubleHorsDelais;

            Evenement     := TiEvenement.Create(MaxInt, EtatMagasin,
              DateTimeToUnix(IncSecond(QueMagasin.FieldByName('log_update').AsDateTime,
                (QueMagasin.FieldByName('log_freq').AsInteger * 2)), False),
              AType,
              Format('Le traitement ne s''est pas effectué depuis plus de 2 cycles. La fréquence doit être de %g minutes.',
                [QueMagasin.FieldByName('log_freq').AsInteger / 60]),
              QueMagasin.FieldByName('log_srv').AsString,
              QueMagasin.FieldByName('log_remoteip').AsString);

            Self.Add(Evenement);
          end
          // Si on n'a pas de réussite depuis plus de 1 cycles
          else if not(WithinPastSeconds(Now(),
            QueMagasin.FieldByName('log_update').AsDateTime,
            (QueMagasin.FieldByName('log_freq').AsInteger))) then
          begin
            if SameText(AType, 'Stock') then
              EtatMagasin := nivDoubleHorsDelais
            else
              EtatMagasin := nivHorsDelais;

            Evenement     := TiEvenement.Create(MaxInt, EtatMagasin,
              DateTimeToUnix(IncSecond(QueMagasin.FieldByName('log_update').AsDateTime,
                (QueMagasin.FieldByName('log_freq').AsInteger)), False),
              AType,
              Format('Le traitement ne s''est pas effectué depuis plus d''un cycles. La fréquence doit être de %g minutes.',
                [QueMagasin.FieldByName('log_freq').AsInteger / 60]),
              QueMagasin.FieldByName('log_srv').AsString,
              QueMagasin.FieldByName('log_remoteip').AsString);

            Self.Add(Evenement);
          end;
        end;

        QueMagasin.Next();
      end;
    end;

    // Tri les évenements par date
    Self.TrimExcess();
    Self.Sort(
      TComparer<TiEvenement>.Construct(
        function (const ALigne1, ALigne2: TiEvenement): Integer
        begin
          Result := CompareValue(ALigne1.IdEvenement, ALigne2.IdEvenement) * -1;
        end
      )
    );
  finally
    QueEvenements.Free();
  end;
end;

function TiEvenements.GetEvenements(): TEvenements;
begin
  Result := TEvenements(Self);
end;

{ TiMagasin }

constructor TiMagasin.Create(const ANomDossier, ANomMagasin: string);
var
  QueMagasin, QueVersions : TFDQuery;
  Version: TVersion;
begin
  DossierMagasin    := ANomDossier;
  NomMagasin        := ANomMagasin;

  try
    // Créer la requête
    QueMagasin             := TFDQuery.Create(nil);
    QueMagasin.Connection  := FDConnection;
    QueVersions            := TFDQuery.Create(nil);
    QueVersions.Connection := FDConnection;

    // Connection à la base de données
    if FDConnection.Connected then
    begin
      // Requête pour avoir l'état du magasin
      QueMagasin.SQL.Clear();
      QueMagasin.SQL.Add('SELECT log_lvl, log_freq, log_update, log_srv, log_remoteip, log_key');
      QueMagasin.SQL.Add('FROM   log_log');
      QueMagasin.SQL.Add('WHERE  log_app = :NomApplication');
      QueMagasin.SQL.Add('  AND  log_dos = :NomDossier');
      QueMagasin.SQL.Add('  AND  log_ref = :NomMagasin');
      QueMagasin.SQL.Add('  AND  log_key in (''Status'', ''Stock'')');
      QueMagasin.SQL.Add('ORDER  BY log_update DESC');
      QueMagasin.SQL.Add('LIMIT  2;');
      QueMagasin.ParamByName('NomApplication').AsString := NOM_APPLICATION;
      QueMagasin.ParamByName('NomDossier').AsString     := ANomDossier;
      QueMagasin.ParamByName('NomMagasin').AsString     := ANomMagasin;
      QueMagasin.Open();

      // Requête pour avoir la version des exécutables
      QueVersions.SQL.Clear();
      QueVersions.SQL.Add('SELECT log_mdl, log_val');
      QueVersions.SQL.Add('FROM   log_log');
      QueVersions.SQL.Add('WHERE  log_app = :NomApplication');
      QueVersions.SQL.Add('  AND  log_dos = :NomDossier');
      QueVersions.SQL.Add('  AND  log_ref = :NomMagasin');
      QueVersions.SQL.Add('  AND  log_key = ''Version''');
//      QueVersions.SQL.Add('ORDER  BY log_update DESC');
//      QueVersions.SQL.Add('LIMIT  2;');
      QueVersions.SQL.Add('UNION');
      QueVersions.SQL.Add('SELECT log_key AS log_mdl, log_val');
      QueVersions.SQL.Add('FROM   log_log');
      QueVersions.SQL.Add('WHERE  log_app = :NomApplication');
      QueVersions.SQL.Add('  AND  log_dos = :NomDossier');
      QueVersions.SQL.Add('  AND  log_ref = :NomMagasin');
      QueVersions.SQL.Add('  AND  ((log_key IN (''GUID'', ''Sender''))');
      QueVersions.SQL.Add('   OR  (log_key LIKE ''IP%''));');
//      QueVersions.SQL.Add('ORDER  BY log_update DESC');
      QueVersions.ParamByName('NomApplication').AsString := NOM_APPLICATION;
      QueVersions.ParamByName('NomDossier').AsString     := ANomDossier;
      QueVersions.ParamByName('NomMagasin').AsString     := ANomMagasin;
      QueVersions.Open();

      EtatMagasin := nivOk;

      while not(QueMagasin.Eof) do
      begin
        // Recupère le serveur du magasin
        ServeurMagasin  := QueMagasin.FieldByName('log_srv').AsString;
        IPMagasin       := QueMagasin.FieldByName('log_remoteip').AsString;

        // Si le magasin a un niveau d'erreur acceptable vérifie que la dernière
        // extraction n'est pas trop vieille
        if EtatMagasin in [nivOk .. nivAttention] then
        begin
          // Retourne le niveau d'erreur du magasin
          case QueMagasin.FieldByName('log_lvl').AsInteger of
            1..3:
              EtatMagasin := nivOk;
            4:
              EtatMagasin := nivNotice;
            5:
              EtatMagasin := nivAttention;
            else
              EtatMagasin := nivErreur;
          end;

          // Si on est dans la période de fonctionnement
          if not(EtatMagasin in [nivErreur .. nivDoubleHorsDelais])  then
          begin
            // Si on n'a pas de réussite depuis plus de 1 cycles
            if not(WithinPastSeconds(Now(),
              QueMagasin.FieldByName('log_update').AsDateTime,
              (QueMagasin.FieldByName('log_freq').AsInteger))) then
            begin
              if SameText(QueMagasin.FieldByName('log_key').AsString, 'Stock') then
                EtatMagasin := nivDoubleHorsDelais
              else
                EtatMagasin := nivHorsDelais;
            end;

            // Si on n'a pas de réussite depuis plus de 2 cycles
            if not(WithinPastSeconds(Now(),
              QueMagasin.FieldByName('log_update').AsDateTime,
              (QueMagasin.FieldByName('log_freq').AsInteger * 2))) then
            begin
              EtatMagasin := nivDoubleHorsDelais;
            end;
          end;
        end;

        QueMagasin.Next();
      end;

      // Recupère les versions
      Versions := TVersions.Create();

      while not(QueVersions.Eof) do
      begin
        Version := TVersion.Create();
        Version.NomExe      := QueVersions.FieldByName('log_mdl').AsString;
        Version.VersionExe  := QueVersions.FieldByName('log_val').AsString;
        Versions.Add(Version);

        QueVersions.Next();
      end;
    end;
  finally
    QueMagasin.Free();
  end;
end;

destructor TiMagasin.Destroy();
begin
  FreeAndNil(Versions);

  inherited;
end;

function TiMagasin.GetMagasin(): TMagasin;
begin
  Result := TMagasin(Self);
end;

function TiMagasin.GetEvenementsStatus(): TEvenements;
begin
  Result := TEvenements(Self.FEvenementsStatus);
end;

function TiMagasin.GetEvenementsStock(): TEvenements;
begin
  Result := TEvenements(Self.FEvenementsStock);
end;

{ TiMagasins }

constructor TiMagasins.Create(const ANomDossier: string);
var
  QueMagasins : TFDQuery;
  Magasin     : TiMagasin;
begin
  try
    // Créer la requête
    QueMagasins            := TFDQuery.Create(nil);
    QueMagasins.Connection := FDConnection;

    // Connection à la base de données
    if FDConnection.Connected then
    begin
      // Requête pour récupérer la liste des magasins du dossier
      QueMagasins.SQL.Clear();
      QueMagasins.SQL.Add('SELECT DISTINCT log_ref');
      QueMagasins.SQL.Add('FROM   log_log');
      QueMagasins.SQL.Add('WHERE  log_app = :NomApplication');
      QueMagasins.SQL.Add('  AND  log_dos = :NomDossier');
      QueMagasins.SQL.Add('ORDER  BY log_ref;');
      QueMagasins.ParamByName('NomApplication').AsString  := NOM_APPLICATION;
      QueMagasins.ParamByName('NomDossier').AsString      := ANomDossier;
      QueMagasins.Open();

      while not(QueMagasins.Eof) do
      begin
        Magasin := TiMagasin.Create(ANomDossier, QueMagasins.FieldByName('log_ref').AsString);
        Self.Add(Magasin);

        QueMagasins.Next();
      end;

      Self.TrimExcess();
    end;
  finally
    QueMagasins.Free();
  end;
end;

function TiMagasins.GetMagasins(): TMagasins;
begin
  Result := TMagasins(Self);
end;

{ TiDossier }

constructor TiDossier.Create(const ANomDossier: string);
var
  Magasin         : TiMagasin;
  NbMagasins      : Integer;
  NbEtats         : array[nivOk .. nivDoubleHorsDelais] of Integer;
begin
  // Créer la liste des magasins du dossier
  FMagasins   := TiMagasins.Create(ANomDossier);
  NomDossier  := ANomDossier;

  // Calcul l'état du dossier
  NbMagasins  := FMagasins.Count;

  NbEtats[nivOk]               := 0;
  NbEtats[nivNotice]           := 0;
  NbEtats[nivAttention]        := 0;
  NbEtats[nivErreur]           := 0;
  NbEtats[nivHorsDelais]       := 0;
  NbEtats[nivDoubleHorsDelais] := 0;

  for Magasin in FMagasins do
  begin
    NbEtats[Magasin.EtatMagasin] := NbEtats[Magasin.EtatMagasin] + 1;
  end;

  PourcentEtat[nivOk]               := (100 / NbMagasins * NbEtats[nivOk]);
  PourcentEtat[nivNotice]           := (100 / NbMagasins * NbEtats[nivNotice]);
  PourcentEtat[nivAttention]        := (100 / NbMagasins * NbEtats[nivAttention]);
  PourcentEtat[nivErreur]           := (100 / NbMagasins * NbEtats[nivErreur]);
  PourcentEtat[nivHorsDelais]       := (100 / NbMagasins * NbEtats[nivHorsDelais]);
  PourcentEtat[nivDoubleHorsDelais] := (100 / NbMagasins * NbEtats[nivDoubleHorsDelais]);
end;

function TiDossier.GetDossier(): TDossier;
begin
  Result := TDossier(Self);
end;

function TiDossier.GetMagasins(): TMagasins;
begin
  Result := TMagasins(Self.FMagasins);
end;

{ TiDossiers }

constructor TiDossiers.Create();
var
  QueDossiers : TFDQuery;
  Dossier     : TiDossier;
begin
  try
    // Créer la requête
    QueDossiers             := TFDQuery.Create(nil);
    QueDossiers.Connection  := FDConnection;

    // Connection à la base de données
    if FDConnection.Connected then
    begin
      // Requête pour récupérer la liste des dossiers
      QueDossiers.SQL.Clear();
      QueDossiers.SQL.Add('SELECT DISTINCT log_dos');
      QueDossiers.SQL.Add('FROM   log_log');
      QueDossiers.SQL.Add('WHERE  log_app = :NomApplication');
      QueDossiers.SQL.Add('ORDER  BY log_dos;');
      QueDossiers.ParamByName('NomApplication').AsString  := NOM_APPLICATION;
      QueDossiers.Open();

      // Parcours la liste des dossiers
      while not(QueDossiers.Eof) do
      begin
        Dossier := TiDossier.Create(QueDossiers.FieldByName('log_dos').AsString);
        Self.Add(Dossier);

        QueDossiers.Next();
      end;

      Self.TrimExcess();
    end;
  finally
    QueDossiers.Free();
  end;
end;

function TiDossiers.GetDossiers(): TDossiers;
begin
  Result := TDossiers(Self);
end;

function TiDossiers.GetElementsErreur(): TElementsErreur;
var
  Dossier       : TiDossier;
  Magasin       : TMagasin;
  ElementErreur : TElementErreur;
begin
  Result := TElementsErreur.Create();

  // Parcours tous les dossiers
  for Dossier in Self do
  begin
    // Parcours tous les magasins du dossier
    for Magasin in Dossier.Magasins do
    begin
      // Si le magasin est en erreur
      if Magasin.EtatMagasin in [nivAttention .. nivDoubleHorsDelais] then
      begin
        // Ajout le magasin à la liste des erreurs
        ElementErreur := TElementErreur.Create();

        ElementErreur.ErreurElement := Magasin.EtatMagasin;
        ElementErreur.MagasinErreur := Magasin.NomMagasin;
        ElementErreur.DossierErreur := Magasin.DossierMagasin;
        ElementErreur.ServeurErreur := Magasin.ServeurMagasin;
        ElementErreur.IPErreur      := Magasin.IPMagasin;

        Result.Add(ElementErreur);
      end;
    end;
  end;

  Result.TrimExcess();
end;

function TiDossiers.GetEtatGlobal(): TNbEtats;
var
  Dossier   : TiDossier;
  Magasin   : TMagasin;
begin
  Result                      := TNbEtats.Create();
  Result.nivOk                := 0;
  Result.nivNotice            := 0;
  Result.nivAttention         := 0;
  Result.nivErreur            := 0;
  Result.nivHorsDelais        := 0;
  Result.nivDoubleHorsDelais  := 0;

  // Parcours tous les dossiers
  for Dossier in Self do
  begin
    // Parcours tous les magasins du dossier
    for Magasin in Dossier.Magasins do
    begin
      case Magasin.EtatMagasin of
        nivOk:
          Result.nivOk                := 1 + Result.nivOk;
        nivNotice:
          Result.nivNotice            := 1 + Result.nivNotice;
        nivAttention:
          Result.nivAttention         := 1 + Result.nivAttention;
        nivErreur:
          Result.nivErreur            := 1 + Result.nivErreur;
        nivHorsDelais:
          Result.nivHorsDelais        := 1 + Result.nivHorsDelais;
        nivDoubleHorsDelais:
          Result.nivDoubleHorsDelais  := 1 + Result.nivDoubleHorsDelais;
      end;
    end;
  end;
end;

initialization
  FDConnection        := TFDConnection.Create(nil);
  FDPhysIBDriverLink  := TFDPhysMySQLDriverLink.Create(nil);
  if not(Connecter(FDConnection, FDPhysIBDriverLink)) then
    Halt;

finalization
  FDPhysIBDriverLink.Free();
  FDConnection.Free();

end.

