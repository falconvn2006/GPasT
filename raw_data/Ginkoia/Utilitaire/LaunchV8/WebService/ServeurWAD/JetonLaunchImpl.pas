{ Fichier d'implémentation invocable pour TJetonLaunch implémentant IJetonLaunch }

unit JetonLaunchImpl;

interface

uses InvokeRegistry,
  Types,
  XSBuiltIns,
  // Uses perso
  Dialogs,
  Forms,
  SysUtils,
  DateUtils,
  // Fin uses perso
  JetonLaunchIntf;

type

  { TJetonLaunch }
  TJetonLaunch = class(TInvokableClass, IJetonLaunch)
  public
    function echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
    function echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
    function echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
    function echoDouble(const Value: Double): Double; stdcall;
    function GetToken(const ANomClient, ASender: string): string; stdcall;
    procedure FreeToken(const ANomClient, ASender: string); stdcall;
  private
  end;

implementation

uses Ginkoia_Dm;

function TJetonLaunch.echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
begin
  { TODO : Implémenter la méthode echoEnum }
  Result := Value;
end;

function TJetonLaunch.echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
begin
  { TODO : Implémenter la méthode echoDoubleArray }
  Result := Value;
end;

function TJetonLaunch.echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
begin
  { TODO : Implémenter la méthode echoMyEmployee }
  Result := TMyEmployee.Create;
end;

procedure TJetonLaunch.FreeToken(const ANomClient, ASender: string);
var
  dmGinkoia: TDm_Ginkoia; // Pointeur vers le Dm_Ginkoia instancié pour la connexion
  sPathDB  : String;      // Chemin vers la base de donnée à connecter
  sMessage : string;      // Message d'erreur en cas d'erreur
begin
  dmGinkoia := TDm_Ginkoia.Create(Nil);
  try
    // Se connecter a la base
    if dmGinkoia.ConnectDB(ANomClient, ASender, sMessage) >= 0 then
    begin
      // On libère le jeton
      dmGinkoia.DelToken
    end;
    dmGinkoia.DisconnectDB;
  finally
    FreeAndNil(dmGinkoia);
  end;
end;

function TJetonLaunch.GetToken(const ANomClient, ASender: string): string;
var
  dmGinkoia: TDm_Ginkoia; // Pointeur vers le Dm_Ginkoia instancié pour la connexion
  sPathDB  : String;      // Chemin vers la base de donnée à connecter
  sMessage : string;      // Message d'erreur en cas d'erreur
//  iBasJetons : integer;   // Contient
begin
  dmGinkoia := TDm_Ginkoia.Create(Nil);
  try
    // Se connecter a la base
    if dmGinkoia.ConnectDB(ANomClient, ASender, sMessage) >= 0 then
    begin
      // On est connecté on peut utiliser les query
      IF dmGinkoia.BasID <> 0 THEN
      BEGIN
        // On vérifie si on peut prendre un jeton
        if dmGinkoia.CanGetToken then
        begin
          // Jeton pris ou rafraichi
          Result := 'OK';
        end
        else begin
          // Occupé
          Result := 'ERR-OQP';
        end;
      END
      else begin
        // Normalement impossible, il y'a donc un pb de config du launcher ou du fichier provider on logge
        Result := 'ERR-PRM';
      end;
      dmGinkoia.DisconnectDB;
    end
    else begin
      // Erreur de connexion
      Result := 'ERR-CNX';
    end;
  finally
    FreeAndNil(dmGinkoia);
  end;

end;

function TJetonLaunch.echoDouble(const Value: Double): Double; stdcall;
begin
  { TODO : Implémenter la méthode echoDouble }
  Result := Value;
end;

initialization

{ Les classes invocables doivent être enregistrées }
InvRegistry.RegisterInvokableClass(TJetonLaunch);

end.
