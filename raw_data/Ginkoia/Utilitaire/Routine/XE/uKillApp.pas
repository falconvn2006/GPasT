unit uKillApp;
{-------------------------------------------------------------------------------
Unité commune aux logiciels : Launcher/Verification/Backup restore/Synchroportable

Commentaires : Cette unité permet générer un fichier avec la liste des applications
               qui devront être tuer (ex: lors du démarrage de la mise à jour de vérification)

Variables :
  - ListApp : Liste contenant les noms (seulement nom et pas nom + chemin) des applications à tuer

Procédures/Fonctions/Property :
  - Load : Charge la liste dans le fichier KLaunch.app du répertoire de l'application
  - Save : Sauvegarde la liste dans le fichier KLaunch.app du répertoire de l'application
  - Add : Permet d'ajouter un logiciel à la liste s'il n'existe pas encore (ne sauvegarde pas automatiquement dans le fichier)
  - Delete : Permet de supprimer un logiciel de la liste (Ne sauvegarde pas automatiquement dans le fichier)
             retourne Vrai s'il y a eu une suppression dans la liste sinon retourne Faux.

  - List[Index] : Permet d'avoir accès à la liste des fichiers
  - Count : Permet de connaitre le nombre de fichier dans la liste.
-------------------------------------------------------------------------------}

interface

uses Classes, SysUtils;

CONST
  CLISTNOTCREATED = 'Liste non créée, veuillez utiliser la procédure LOAD';

type
  TKillApp = record
    private
      ListApp : TStringList;
      function GetList(Index: Integer): String;
      procedure SetList(Index: Integer; const Value: String);
      function GetCount: Integer;
    public
      procedure Load;
      procedure Save;
      procedure Add(AAppName : String);
      function Delete(AAppName : String) : Boolean;

      property List[Index : Integer] : String read GetList write SetList;
      property Count : Integer read GetCount; 
  end;

var
  KillApp : TKillApp;
implementation

{ TKillApp }

procedure TKillApp.Add(AAppName: String);
begin
  if ListApp <> nil then
  begin
    if ListApp.IndexOf(AAppName) = -1 then
      ListApp.Add(AAppName);
  end;
end;

function TKillApp.Delete(AAppName: String) : boolean;
var
  iIndex : Integer;
begin
  Result := False;
  if ListApp <> nil then
  begin
    iIndex := ListApp.IndexOf(AAppName);
    if iIndex <> -1 then
    begin
      ListApp.Delete(iIndex);
      Result := true;
    end;
  end;
end;

function TKillApp.GetCount: Integer;
begin
  if ListApp <> nil then
    Result := ListApp.Count
  else
    raise Exception.Create(CLISTNOTCREATED);
end;

function TKillApp.GetList(Index: Integer): String;
begin
  if ListApp <> nil then
    Result := ListApp[index]
  else
    raise Exception.Create(CLISTNOTCREATED);
end;

procedure TKillApp.Load;
begin
  if ListApp = nil then
    ListApp := TStringList.Create;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'KLaunch.app') then
    ListApp.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'KLaunch.app');
end;

procedure TKillApp.Save;
begin
  if ListApp <> nil then
    ListApp.SaveToFile(ExtractFilePath(ParamStr(0)) + 'KLaunch.app');
end;

procedure TKillApp.SetList(Index: Integer; const Value: String);
begin
  if ListApp <> nil then
    ListApp[Index] := Value
  else
    raise Exception.Create(CLISTNOTCREATED);
end;

end.
