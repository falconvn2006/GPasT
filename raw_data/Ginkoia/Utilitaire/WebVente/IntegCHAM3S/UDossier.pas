unit UDossier;

interface

uses UBddDossier, System.Classes, System.SysUtils, System.StrUtils;

type
  TDossier = class(Tobject)
    private
      FGestBdd    : TBddDossier;
      FNom        : string;
      FID         : integer;
      FURL        : string;
      FPort       : integer;
      FUser       : string;
      FPassword   : string;
      FRepertoire : string;
      FPriorite   : integer;
      procedure SetNom(pNom: string);
      procedure SetURL(pURL: string);
      procedure SetPort(pPort: integer);
      procedure SetUser(pUser: string);
      procedure SetPassword(pPassword: string);
      procedure SetRepertoire(pRepertoire: string);
      procedure SetPriorite(pPriorite: integer);
      procedure SaveAllParams;
      procedure ReadAllParams;
      function GetNom: string;
      function GetURL: string;
      function GetPort: integer;
      function GetUser: string;
      function GetPassword: string;
      function GetRepertoire: string;
      function GetPriorite: integer;
    public
      constructor Create(AID: integer; pBdd: TBddDossier); reintroduce;
      destructor Destroy; reintroduce;
      property Nom        : string  read FNom Write SetNom;
      property ID         : integer read FID;
      property URL        : string  read FURL Write SetURL;
      property Port       : integer read FPort Write SetPort;
      property User       : string  read FUser Write SetUser;
      property Password   : string  read FPassword Write SetPassword;
      property Repertoire : string  read FRepertoire Write SetRepertoire;
      property Priorite   : integer read FPriorite write SetPriorite;
  end;

implementation

{ TDossier }

constructor TDossier.Create(AID: integer; pBdd: TBddDossier);
begin
  inherited Create;
  FGestBdd := pBdd;
  FID := AID;
  ReadAllParams;
end;

destructor TDossier.Destroy;
begin
  inherited Destroy;
end;

function TDossier.GetNom: string;
begin
  Result := FGestBdd.GetParamDossier(FID,ptNom);
end;

function TDossier.GetPassword: string;
begin
  Result := FGestBdd.GetParamDossier(FID,ptPassword);
end;

function TDossier.GetPort: integer;
begin
  Result := StrToInt(FGestBdd.GetParamDossier(FID,ptPort));
end;

function TDossier.GetPriorite: integer;
begin
  Result := StrToInt(FGestBdd.GetParamDossier(FID,ptPriorite));
end;

function TDossier.GetRepertoire: string;
begin
   Result := FGestBdd.GetParamDossier(FID,ptRepertoire);
end;

function TDossier.GetURL: string;
begin
  Result := FGestBdd.GetParamDossier(FID,ptURL);
end;

function TDossier.GetUser: string;
begin
  Result := FGestBdd.GetParamDossier(FID,ptUser);
end;

procedure TDossier.ReadAllParams;
begin
  FNom        := GetNom;
  FURL        := GetURL;
  FPort       := GetPort;
  FUser       := GetUser;
  FPassword   := GetPassword;
  FRepertoire := GetRepertoire;
  FPriorite   := GetPriorite;
end;

procedure TDossier.SaveAllParams;
begin
  SetNom(FNom);
  SetURL(FURL);
  SetPort(FPort);
  SetUser(FUser);
  SetPassword(FPassword);
  SetRepertoire(FRepertoire);
  SetPriorite(FPriorite);
end;

procedure TDossier.SetNom(pNom: string);
begin
  if FGestBdd.SetParamDossier(ID,ptNom,pNom) then
    FNom := pNom;
end;

procedure TDossier.SetPassword(pPassword: string);
begin
  if FGestBdd.SetParamDossier(ID,ptPassword,pPassword) then
    FPassword := pPassword;
end;

procedure TDossier.SetPort(pPort: integer);
begin
  if FGestBdd.SetParamDossier(ID,ptPort,inttostr(pPort)) then
    FPort := pPort;
end;

procedure TDossier.SetPriorite(pPriorite: integer);
begin
  if FGestBdd.SetParamDossier(ID,ptPriorite,inttostr(pPriorite)) then
    FPriorite := pPriorite;
end;

procedure TDossier.SetRepertoire(pRepertoire: string);
begin
  if pRepertoire[1] = '/' then
    pRepertoire := RightStr(pRepertoire,Length(pRepertoire)-1);

  if FGestBdd.SetParamDossier(ID,ptRepertoire,pRepertoire) then
    FRepertoire := pRepertoire;
end;

procedure TDossier.SetURL(pURL: string);
begin
  if FGestBdd.SetParamDossier(ID,ptURL,pURL) then
    FURL := pURL;
end;

procedure TDossier.SetUser(pUser: string);
begin
  if FGestBdd.SetParamDossier(ID,ptUser,pUser) then
    FUser := pUser;
end;

end.
