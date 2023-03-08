//$Log:
// 2    Utilitaires1.1         26/09/2006 11:02:54    pascal          rendu des
//      modifs
// 1    Utilitaires1.0         25/11/2005 08:09:39    pascal          
//$
//$NoKeywords$
//
unit UInstCltCst;

interface
uses
   SysUtils,
   Classes;

const
   k_Dossier = '-11111338';
   K_Base = '-11111334';
   K_Soc = '-11111350';
   K_Mag = '-11111344';
   K_Poste = '-11111349';
   K_Adresse = '-11111333';
   K_GENMAGGESTIONCLT = '-11111346';
   K_GENMAGGESTIONCF = '-11111345';
   K_GENMAGGESTIONCLTCPT = '-11111459';
   K_GENPARAM = '-11111454';
   K_BQE = '-11111407';
   K_CFFID = '-11111410';
   K_MENID = '-11111418';
   K_MEDID = '-11111420';

type
   TUnSite = class
      // Dans genBase
      // Bas_Nom = SERVEUR_"nom"-"IdCourtClient"
      // Secourt -- > = SERVEUR_"nom"-"IdCourtClient"_SEC
      // NoteBook --> NB"numero"_"nom"-"IdCourtClient"
      VraiNom : String ;
      Ident : String ;
      PLage : String ;
      Existe : Boolean ;
      id     : integer ;

      Nom: string;
      Jetons: integer;
      NoteBook: integer;
      CA: Boolean;
      function ToXml(Dec: string): string;
      constructor Create;
      destructor destroy; override;
   end;

   TunDroit = class
      Nom: string;
      Actif: boolean;
      constructor Create;
      destructor destroy; override;
   end;

   Tposte = class
      nom: string;
      Existe : Boolean ;
      id     : integer ;
      function ToXml(Dec: string): string;
      constructor Create;
      destructor destroy; override;
   end;

   TMagasin = class
   private
      function GetPostes(X: Integer): Tposte;
      procedure SetPostes(X: Integer; const Value: Tposte);
   public
      Existe : Boolean ;
      nom: string;
      IdCourt: string;
      Location: Boolean;
      LesPostes: Tlist;
      ID         :Integer ;
      function ToXml(Dec: string): string;
      constructor Create;
      destructor destroy; override;
      PROCEDURE clear ;
      property Postes[X: Integer]: Tposte read GetPostes write SetPostes;
   end;

   TSociete = class
   private
      function GetMagasins(X: Integer): TMagasin;
      procedure SetMagasins(X: Integer; const Value: TMagasin);
   public
      Nom: string;
      LesMagasins: Tlist;
      Existe : Boolean ;
      ID         :Integer ;
      PROCEDURE clear ;
      function ToXml(Dec: string): string;
      property Magasins[X: Integer]: TMagasin read GetMagasins write SetMagasins;
      constructor Create;
      destructor destroy; override;
   end;

   TUneInstall = class
   private
      function GetDroits(X: Integer): TunDroit;
      procedure SetDroits(X: Integer; const Value: TunDroit);
      function GetSites(X: Integer): TUnSite;
      procedure SetSites(X: Integer; const Value: TUnSite);
      function GetSocietes(X: Integer): TSociete;
      procedure SetSocietes(X: Integer; const Value: TSociete);
   public
      BD_ref: string;
      Rep_Dest: string;
      Version: string;
      Eai: string;
      Rep_Site: string;
      Nom_Clt: string;
      Id_court: string;
      LesDroits: TList;
      LesSites: Tlist;
      LesSociete: Tlist;
      Copie:Boolean ;
      Centrale:String ;
      PROCEDURE clear ;
      constructor Create;
      destructor destroy; override;
      function ToXml(Dec: string): string;
      property Droits[X: Integer]: TunDroit read GetDroits write SetDroits;
      property Sites[X: Integer]: TUnSite read GetSites write SetSites;
      property Societes[X: Integer]: TSociete read GetSocietes write SetSocietes;
   end;

implementation

{ TUneInstall }

procedure TUneInstall.clear;
var
   i: integer;
begin
   for i := 0 to LesDroits.count - 1 do
      droits[i].free;
   LesDroits.Clear;
   for i := 0 to LesSites.count - 1 do
      Sites[i].free;
   LesSites.Clear;
   for i := 0 to LesSociete.count - 1 do
      Societes[i].free;
   LesSociete.Clear;
end;

constructor TUneInstall.Create;
begin
   inherited;
   LesDroits := TList.Create;
   LesSites := Tlist.Create;
   LesSociete := Tlist.Create;
end;

destructor TUneInstall.destroy;
var
   i: integer;
begin
   for i := 0 to LesDroits.count - 1 do
      droits[i].free;
   LesDroits.free;
   for i := 0 to LesSites.count - 1 do
      Sites[i].free;
   LesSites.free;
   for i := 0 to LesSociete.count - 1 do
      Societes[i].free;
   LesSociete.free;
   inherited;
end;

function TUneInstall.GetDroits(X: Integer): TunDroit;
begin
   result := TunDroit(lesdroits[x]);
end;

function TUneInstall.GetSites(X: Integer): TUnSite;
begin
   result := TunSite(LesSites[x]);
end;

function TUneInstall.GetSocietes(X: Integer): TSociete;
begin
   result := TSociete(LesSociete[x]);
end;

procedure TUneInstall.SetDroits(X: Integer; const Value: TunDroit);
begin
   lesdroits[x] := Value;
end;

procedure TUneInstall.SetSites(X: Integer; const Value: TUnSite);
begin
   LesSites[x] := Value;
end;

procedure TUneInstall.SetSocietes(X: Integer; const Value: TSociete);
begin
   LesSociete[x] := Value;
end;

function TUneInstall.ToXml(Dec: string): string;
var
   i: integer;
   S : String ;
begin
   result := Dec + '<CLIENT>'#13#10;
   result := result + dec + '  <VER_XML>2</VER_XML>'#13#10;
   result := result + dec + '  <LABASE>' + BD_ref + '</LABASE>'#13#10;
   result := result + dec + '  <LEREP>' + Rep_Dest + '</LEREP>'#13#10;
   result := result + dec + '  <VERSION>' + Version + '</VERSION>'#13#10;
   result := result + dec + '  <VERSIONEAI>' + Eai + '</VERSIONEAI>'#13#10;
   result := result + dec + '  <PANTIN>' + Rep_Site + '</PANTIN>'#13#10;
   result := result + dec + '  <NOM>' + Nom_Clt + '</NOM>'#13#10;
   result := result + dec + '  <IDCOURT>' + Id_court + '</IDCOURT>'#13#10;
   IF Copie then
      result := result + dec + '  <COPIE>OUI</COPIE>'#13#10
   else
      result := result + dec + '  <COPIE>NON</COPIE>'#13#10 ;
   result := result + dec + '  <CENTRALE>'+Centrale+'</CENTRALE>'#13#10 ;
   for i := 0 to LesDroits.count - 1 do
   begin
      S := Droits[i].Nom ;
      WHILE pos(' ',S)>0 do
        S[pos(' ',S)] := '_' ;
      if Droits[i].Actif then
         result := result + dec + '  <' + S + '>1</' + S + '>'#13#10
      else
         result := result + dec + '  <' + S + '>0</' + S + '>'#13#10
   end;
   result := result + dec + '  <BASES>'#13#10;
   for i := 0 to LesSites.count - 1 do
   begin
      result := result + dec + Sites[i].ToXml(dec + '    ');
   end;
   result := result + dec + '  </BASES>'#13#10;
   result := result + dec + '  <SOCIETES>'#13#10;
   for i := 0 to LesSociete.count - 1 do
   begin
      result := result + dec + Societes[i].ToXml(dec + '    ');
   end;
   result := result + dec + '  </SOCIETES>'#13#10;
   result := result + Dec + '</CLIENT>'#13#10;
end;

{ TunDroit }

constructor TunDroit.Create;
begin
   inherited;
end;

destructor TunDroit.destroy;
begin
   inherited;

end;

{ TUnSite }

constructor TUnSite.Create;
begin
   inherited;
   VraiNom := '' ;
   Ident := '' ;
   PLage := '' ;

end;

destructor TUnSite.destroy;
begin
   inherited;

end;

function TUnSite.ToXml(Dec: string): string;
begin
   result := Dec + '<BASE>'#13#10;
   result := result + Dec + '  <NOM>' + Nom + '</NOM>'#13#10;
   result := result + Dec + '  <JETONS>' + Inttostr(Jetons) + '</JETONS>'#13#10;
   result := result + Dec + '  <NOTEBOOK>' + Inttostr(NoteBook) + '</NOTEBOOK>'#13#10;
   result := result + Dec + '  <ID>' + Inttostr(ID) + '</ID>'#13#10;
   if CA then
      result := result + Dec + '  <SECOUR>OUI</SECOUR>'#13#10
   else
      result := result + Dec + '  <SECOUR>NON</SECOUR>'#13#10;
   IF VraiNom<>'' then
      result := result + Dec + '  <VRAINOM>' + VraiNom + '</VRAINOM>'#13#10;
   IF Ident<>'' then
      result := result + Dec + '  <IDENT>' + Ident + '</IDENT>'#13#10;
   IF Plage<>'' then
      result := result + Dec + '  <PLAGE>' + Plage + '</PLAGE>'#13#10;

   result := result + Dec + '</BASE>'#13#10;
end;

{ TSociete }

procedure TSociete.clear;
var
   i: integer;
begin
   for i := 0 to LesMagasins.Count - 1 do
      Magasins[i].free;
   LesMagasins.Clear;
end;

constructor TSociete.Create;
begin
   inherited;
   LesMagasins := Tlist.create;
end;

destructor TSociete.destroy;
var
   i: integer;
begin
   for i := 0 to LesMagasins.Count - 1 do
      Magasins[i].free;
   LesMagasins.free;
   inherited;
end;

function TSociete.GetMagasins(X: Integer): TMagasin;
begin
   result := TMagasin(LesMagasins[x]);
end;

procedure TSociete.SetMagasins(X: Integer; const Value: TMagasin);
begin
   LesMagasins[x] := Value;
end;

function TSociete.ToXml(Dec: string): string;
var
   i: integer;
begin
   result := Dec + '<SOCIETE>'#13#10;
   result := result + Dec + '  <NOM>' + Nom + '</NOM>'#13#10;
   result := result + Dec + '  <ID>'+Inttostr(ID)+'</ID>'#13#10;
   result := result + Dec + '  <MAGASINS>'#13#10;
   for i := 0 to LesMagasins.Count - 1 do
   begin
      result := result + dec + Magasins[i].ToXml(dec + '    ');
   end;
   result := result + Dec + '  </MAGASINS>'#13#10;
   result := result + Dec + '</SOCIETE>'#13#10;
end;

{ TMagasin }

procedure TMagasin.clear;
Var
 i : integer ;
begin
   for i := 0 to LesPostes.Count - 1 do
      Postes[i].free;
   LesPostes.Clear;
end;

constructor TMagasin.Create;
begin
   inherited;
   LesPostes := Tlist.create;
end;

destructor TMagasin.destroy;
var
   i: integer;
begin
   for i := 0 to LesPostes.Count - 1 do
      Postes[i].free;
   LesPostes.free;
   inherited;
end;

function TMagasin.GetPostes(X: Integer): Tposte;
begin
   result := Tposte(LesPostes[x]);
end;

procedure TMagasin.SetPostes(X: Integer; const Value: Tposte);
begin
   LesPostes[x] := Value;
end;

function TMagasin.ToXml(Dec: string): string;
var
   i: integer;
begin
   result := '    <MAGASIN>'#13#10;
   result := result + Dec + '  <NOM>' + Nom + '</NOM>'#13#10;
   result := result + Dec + '  <IDCOURT>' + IdCourt + '</IDCOURT>'#13#10;
   result := result + Dec + '  <ID>' + Inttostr(Id) + '</ID>'#13#10;
   if Location then
      result := result + Dec + '  <LOCATION>OUI</LOCATION>'#13#10
   else
      result := result + Dec + '  <LOCATION>NON</LOCATION>'#13#10;
   result := result + Dec + '  <POSTES>'#13#10;
   for i := 0 to LesPostes.Count - 1 do
   begin
      result := result + dec + Postes[i].ToXml(dec + '    ');
   end;
   result := result + Dec + '  </POSTES>'#13#10;
   result := result + Dec + '</MAGASIN>'#13#10;
end;

{ Tposte }

constructor Tposte.Create;
begin
   inherited;
end;

destructor Tposte.destroy;
begin
   inherited;

end;

function Tposte.ToXml(Dec: string): string;
begin
   result := '    <POSTE>'#13#10;
   result := result + Dec + '  <NOM>' + Nom + '</NOM>'#13#10;
   result := result + Dec + '  <ID>' + Inttostr(ID) + '</ID>'#13#10;
   result := result + Dec + '</POSTE>'#13#10;
end;

end.

