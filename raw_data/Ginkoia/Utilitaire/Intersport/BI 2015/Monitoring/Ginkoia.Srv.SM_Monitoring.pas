unit Ginkoia.Srv.SM_Monitoring;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.DateUtils,
  System.Win.Registry,
  Winapi.Windows,
  Datasnap.DSServer,
  Datasnap.DSAuth,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.DApt,
  FireDAC.Comp.Client,
  Data.DB,
  Ginkoia.Srv.Class_Monitoring,
  Ginkoia.Srv.Class_MotPasse;

type
{$METHODINFO ON}
  TSM_Monitoring = class(TComponent)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function GetParametresConnection(const ACle: string): TParametresConnection;
    function SetParametresConnection(const ACle, ADLL, AServer, ADatabase,
      AUser_Name, APassword: string): Boolean;
    function GetEtatGlobal(): TNbEtats;
    function GetListeErreurs(): TElementsErreur;
    function GetEtatDossier(const ADossier: string): TDossier;
    function GetListeDossiers(): TDossiers;
    function GetListeTousMagasins(): TMagasins;
    function GetListeMagasins(const ADossier: string): TMagasins;
    function GetEtatMagasin(const ADossier, AMagasin: string): ShortInt;
    function GetVersionsMagasin(const ADossier, AMagasin: string): TVersions;
    function GetListeStatus(const ADossier, AMagasin: string;
      const ADebut, AFin: Integer): TEvenements;
    function GetListeStock(const ADossier, AMagasin: string;
      const ADebut, AFin: Integer): TEvenements;
    function GetHeure(): Int64;
  end;
{$METHODINFO OFF}

implementation

function TSM_Monitoring.GetParametresConnection(const ACle: string): TParametresConnection;
var
  regParametres: TRegistry;
begin
  Result := TParametresConnection.Create();
  if IsValidPassword(ACle) then
  begin
    regParametres := TRegistry.Create(KEY_READ);
    try
      if regParametres.OpenKey(CLE_REGISTRE, True) then
      begin
        Result.DLL        := regParametres.ReadString('DLL');
        Result.Server     := regParametres.ReadString('Server');
        Result.Database   := regParametres.ReadString('Database');
        Result.User_Name  := regParametres.ReadString('User_Name');
        Result.Password   := regParametres.ReadString('Password');

        regParametres.CloseKey();
      end;
    finally
      regParametres.Free();
    end;
  end;
end;

function TSM_Monitoring.SetParametresConnection(const ACle, ADLL, AServer,
  ADatabase, AUser_Name, APassword: string): Boolean;
var
  regParametres: TRegistry;
begin
  Result := False;
  if IsValidPassword(ACle) then
  begin
    regParametres := TRegistry.Create(KEY_WRITE);
    try
      if regParametres.OpenKey(CLE_REGISTRE, True) then
      begin
        regParametres.WriteString('DLL', ADLL);
        regParametres.WriteString('Server', AServer);
        regParametres.WriteString('Database', ADatabase);
        regParametres.WriteString('User_Name', AUser_Name);
        regParametres.WriteString('Password', APassword);
        regParametres.CloseKey();
        Result := True;
      end;
    finally
      regParametres.Free();
    end;
  end;
end;

// Retourne l'état global des extractions.
function TSM_Monitoring.GetEtatGlobal(): TNbEtats;
var
  Dossiers: TiDossiers;
begin
  Dossiers  := TiDossiers.Create();
  Result    := Dossiers.EtatGlobal;
end;

// Retourne les éléments en erreur.
function TSM_Monitoring.GetListeErreurs(): TElementsErreur;
var
  Dossiers: TiDossiers;
begin
  Dossiers  := TiDossiers.Create();
  Result    := Dossiers.ElementsErreur;
end;

// Retourne l'état d'un dossier.
function TSM_Monitoring.GetEtatDossier(const ADossier: string): TDossier;
var
  Dossier: TiDossier;
begin
  Dossier := TiDossier.Create(ADossier);
  Result  := Dossier.Dossier;
end;

// Retourne la liste des dossiers avec leurs états.
function TSM_Monitoring.GetListeDossiers(): TDossiers;
var
  Dossiers: TiDossiers;
begin
  Dossiers  := TiDossiers.Create();
  Result    := Dossiers.Dossiers;
end;

// Retourne la liste de tous les magasins avec leurs états.
function TSM_Monitoring.GetListeTousMagasins(): TMagasins;
var
  Dossiers  : TiDossiers;
  Dossier   : TiDossier;
  Magasin   : TMagasin;
begin
  Dossiers := TiDossiers.Create();
  Result   := TMagasins.Create();

  for Dossier in Dossiers do
  begin
    for Magasin in Dossier.Magasins do
    begin
      Result.Add(Magasin);
    end;
  end;

  Result.TrimExcess();
end;

// Retourne la liste des magasins d'un dossier avec leurs états.
function TSM_Monitoring.GetListeMagasins(const ADossier: string): TMagasins;
var
  Dossier: TiDossier;
begin
  Dossier := TiDossier.Create(ADossier);
  Result  := Dossier.Magasins;
end;

// Retourne l'état d'un magasin.
function TSM_Monitoring.GetEtatMagasin(const ADossier, AMagasin: string): ShortInt;
var
  Magasin: TiMagasin;
begin
  Magasin := TiMagasin.Create(ADossier, AMagasin);
  Result  := ShortInt(Magasin.EtatMagasin);
end;

// Retourne les versions des exécutables
function TSM_Monitoring.GetVersionsMagasin(const ADossier,
  AMagasin: string): TVersions;
var
  Magasin: TiMagasin;
begin
  Magasin := TiMagasin.Create(ADossier, AMagasin);
  Result  := Magasin.Versions;
end;

// Retourne la liste des événements "Status" sur un magasin.
function TSM_Monitoring.GetListeStatus(const ADossier, AMagasin: string;
  const ADebut, AFin: Integer): TEvenements;
var
  Evenements: TiEvenements;
begin
  Evenements := TiEvenements.Create(ADossier, AMagasin, 'Status', ADebut, AFin);
  Result     := Evenements.Evenements;
end;

// Retourne la liste des événements "Stock" sur un magasin.
function TSM_Monitoring.GetListeStock(const ADossier, AMagasin: string;
  const ADebut, AFin: Integer): TEvenements;
var
  Evenements: TiEvenements;
begin
  Evenements := TiEvenements.Create(ADossier, AMagasin, 'Stock', ADebut, AFin);
  Result     := Evenements.Evenements;
end;

function TSM_Monitoring.GetHeure(): Int64;
begin
  Result := DateTimeToUnix(Now(), False);
end;

end.


