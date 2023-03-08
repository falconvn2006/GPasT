{ Fichier d'implémentation invocable pour TJetonLaunch implémentant IJetonLaunch }

unit JetonLaunchImpl;

interface

uses
  InvokeRegistry, Types,
  // Uses perso
  Dialogs, Forms, SysUtils, DateUtils, IdHTTP, IdURI, Classes, IniFiles, StrUtils,
  // Fin uses perso
  JetonLaunchIntf;

type
  TJetonLaunch = class(TInvokableClass, IJetonLaunch)
  private
    procedure LectureParametres(out bRecyclage: Boolean; out sURL, sInstance: String);

  public
    function GetToken(const ANomClient, ASender: String): String;   stdcall;
    function GetVersionBdd(const ANomClient: String): String;   stdcall;
    procedure FreeToken(const ANomClient, ASender: String);   stdcall;
  end;

implementation

uses Ginkoia_Dm, UTools;

function TJetonLaunch.GetToken(const ANomClient, ASender: String): String;
var
  dmGinkoia: TDm_Ginkoia; // Pointeur vers le Dm_Ginkoia instancié pour la connexion
  sMessage : string;      // Message d'erreur en cas d'erreur
begin
  LogAction('---------------------------------------------', 3);
  LogAction('Appel à GetTOKEN : ' + ANomClient + ' - ' + ASender, 3);
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
  LogAction('Fin Appel à GetTOKEN : ' + Result, 3);
  LogAction('---------------------------------------------', 3);
  LogAction('', 3);
end;

function TJetonLaunch.GetVersionBdd(const ANomClient: String): String;
var
  dmGinkoia: TDm_Ginkoia; // Pointeur vers le Dm_Ginkoia instancié pour la connexion
  sMessage : string;      // Message d'erreur en cas d'erreur
begin
  LogAction('---------------------------------------------', 3);
  LogAction('Appel à GetVersion : ' + ANomClient, 3);
  dmGinkoia := TDm_Ginkoia.Create(Nil);
  try
    // Se connecter a la base
    IF dmGinkoia.ConnectDB(ANomClient, '', sMessage) >= 0 then
    begin
      // On récupère la version
      Result := dmGinkoia.GetVersion;
    end;
    dmGinkoia.DisconnectDB;
  finally
    FreeAndNil(dmGinkoia);
  end;
  LogAction('Fin Appel à GetVersion : ' + Result, 3);
  LogAction('---------------------------------------------', 3);
  LogAction('', 3);
end;

procedure TJetonLaunch.LectureParametres(out bRecyclage: Boolean; out sURL, sInstance: String);
var
  FichierINI: TIniFile;
  nIndex: Integer;
begin
  FichierINI := TIniFile.Create(GetIniName);
  try
    bRecyclage := (FichierINI.ReadInteger('Recyclage instance', 'Activee', 0) = 1);
    sURL := FichierINI.ReadString('Recyclage instance', 'URL', '');
    sInstance := FichierINI.ReadString('Recyclage instance', 'NomInstance', '');

    if not FichierINI.ValueExists('Recyclage instance', 'Activee') then
    begin
      FichierINI.WriteInteger('Recyclage instance', 'Activee', 0);
      LogAction('Génération paramètre activation recyclage instance = 0.', 3);
    end;

    if sURL = '' then
    begin
      sURL := 'http://localhost:7404/';
      FichierINI.WriteString('Recyclage instance', 'URL', sURL);
      LogAction('Génération paramètre URL :  ' + sURL, 3);
    end;
    if sURL[Length(sURL)] <> '/' then
      sURL := sURL + '/';

    if sInstance = '' then
    begin
      sInstance := ReverseString(ExcludeTrailingPathDelimiter(ExtractFilePath(GetIniName)));
      nIndex := Pos('\', sInstance);
      if nIndex > 0 then
      begin
        sInstance := ReverseString(LeftStr(sInstance, nIndex - 1));
        FichierINI.WriteString('Recyclage instance', 'NomInstance', sInstance);
        LogAction('Génération paramètre nom instance :  ' + sInstance, 3);
      end
      else
      begin
        LogAction('Erreur :  la génération du paramètre "NomInstance" a échoué !', 0);
        Exit;
      end;
    end;
  finally
    FichierINI.Free;
  end;
end;

procedure TJetonLaunch.FreeToken(const ANomClient, ASender: String);
var
  dmGinkoia: TDm_Ginkoia;   // Pointeur vers le Dm_Ginkoia instancié pour la connexion
  sMessage: String;      // Message d'erreur en cas d'erreur
  bRecyclage: Boolean;
  sURL, sInstance: String;
  IdHttp: TIdHttp;
  Reponse: TStringStream;
begin
  LogAction('---------------------------------------------', 3);
  LogAction('Appel à FreeTOKEN : ' + ANomClient + ' - ' + ASender, 3);
  dmGinkoia := TDm_Ginkoia.Create(nil);
  try
    // Se connecter a la base
    if dmGinkoia.ConnectDB(ANomClient, ASender, sMessage) >= 0 then
    begin
      // On libère le jeton
      dmGinkoia.DelToken;
    end;
    dmGinkoia.DisconnectDB;
  finally
    FreeAndNil(dmGinkoia);
  end;

  // Lecture des paramètres.
  LectureParametres(bRecyclage, sURL, sInstance);
  LogAction('Lecture des paramètres.', 3);

  // Si recyclage de l'instance de réplication.
  if bRecyclage then
  begin
    LogAction('Recyclage de l''instance de réplication activée.', 3);

    IdHttp := TIdHttp.Create(nil);
    try
      IdHttp.Request.Clear;
      IdHTTP.Request.Accept := 'application/json';
      IdHttp.Request.ContentType := 'application/json';
      IdHttp.Request.CharSet := 'UTF-8';

      Reponse := TStringStream.Create('');
      try
        LogAction('[' + sURL + 'datasnap/rest/TSM_IISManager/RecycleInstance/' + sInstance + ']', 3);

        // Demande de recyclage de l'instance de réplication (envoi GET).
        try
          IdHttp.Get(TIdURI.UrlEncode(sURL + 'datasnap/rest/TSM_IISManager/RecycleInstance/' + sInstance), Reponse);
        except
          on E: Exception do
          begin
            Reponse.WriteString(E.Message);
            Reponse.Seek(0, soFromBeginning);
            LogAction('# Erreur :  la demande de recyclage de l''instance [' + sInstance + '] a échoué !' + #13#10 + Reponse.DataString, 0);
            Exit;
          end;
        end;

        Reponse.Seek(0, soFromBeginning);
        if IdHttp.ResponseCode = 200 then
        begin
          if LowerCase(Reponse.DataString) = '{"result":["ok"]}' then
            LogAction('Recyclage de l''instance [' + sInstance + '] réussie :  ' + Reponse.DataString, 2)
          else
            LogAction('# Erreur :  échec du recyclage de l''instance [' + sInstance + ']:  ' + Reponse.DataString, 0);
        end
        else
          LogAction('# Erreur :  échec de la connexion pour demande de recyclage de l''instance [' + sInstance + ']:  [code retour ' + IntToStr(IdHttp.ResponseCode) + ']  ' + Reponse.DataString, 0);
      finally
        Reponse.Free;
      end;
    finally
      IdHttp.Free;
    end;
  end;
  
  LogAction('Fin Appel à FreeTOKEN', 3);
  LogAction('---------------------------------------------', 3);
  LogAction('', 3);
end;

initialization
  { Les classes invocables doivent être enregistrées }
  InvRegistry.RegisterInvokableClass(TJetonLaunch);

end.

