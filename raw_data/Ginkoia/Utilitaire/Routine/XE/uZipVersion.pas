unit uZipVersion;

interface

uses Classes, Windows, Types, SysUtils, uJSON, idHTTP, uSevenZip ;

const
  URL_SERVEUR = 'yellis.ginkoia.net';

type
//==============================================================================
  TZipVersionStatus = (vsNone, vsList, vsVerifying, vsZip, vsFinished, vsError) ;
//==============================================================================
  TVersionFiles = class(TPersistent)
  private
    FVersion  : string;
    FFiles    : TStringDynArray;
  published
    property version : string         read FVersion   write FVersion ;
    property files : TStringDynArray  read FFiles     write FFiles ;
  end ;
//==============================================================================
  TZipVersion = class(TThread)
  private
    HTTP      : TIdHTTP ;
    Zip       : I7zOutArchive ;
    FileList  : TStringList ;

    FVersion  : string;
    FBasePath : string;
    FFileName : string ;

    FStatus   : TZipVersionStatus ;
    FRunning  : boolean ;
    FError    : string;

    function doBuildVersion  : boolean ;
    function getFileList : boolean ;
    function addLocalFiles : boolean ;
    function checkFiles : boolean ;
    function zipFiles : boolean ;
  protected

  public
    constructor Create;
    destructor Destroy; override ;

    procedure Execute ; override ;

    function BuildVersion(aFileName : String) : boolean ;

    class function ExplainStatus(aStatus : TZipVersionStatus) : string ;
  published
    property Version  : string    read FVersion   write FVersion ;
    property BasePath : string    read FBasePath  write FBasePath ;

    property Status     : TZipVersionStatus    read FStatus ;
    property Error      : string    read FError  write FError ;
  end;
//==============================================================================
implementation
//==============================================================================
{ TZipVersion }
//==============================================================================
function TZipVersion.addLocalFiles: boolean;
var
  vSR : TSearchRec ;
  vALGPath  : string ;
  vFileName : string ;
  vRelativeName : string ;
begin
  FStatus := vsList ;
  Result := False ;

  try
    vALGPath := IncludeTrailingPathDelimiter(FBasePath) + 'Liveupdate\' ;

    if FindFirst(vALGPath + '*.ALG' , faNormal, vSr) = 0 then
    begin
      repeat
        vFileName := ExpandFileName(vALGPath + vSr.Name) ;
        if pos('.ALG', UpperCase(vFileName)) > 0 then
        begin
          vRelativeName := ExtractRelativePath(FBasePath, vFileName) ;
          FileList.Add( vRelativeName ) ;
        end;
      until FindNext(vSr) <> 0 ;

      FindClose(vSr) ;
    end;

    Result := true ;
  except
  end ;
end;

function TZipVersion.BuildVersion(aFileName: String): boolean;
begin
  Result := false ;
  if FRunning then Exit ;

  FFileName := aFileName ;
  resume ;
  Result := true ;
end;

function TZipVersion.checkFiles: boolean;
var
  vFileName : string ;
  vError    : integer ;
begin
  FStatus := vsVerifying ;

  vError := 0 ;
  for vFileName in FileList do
  begin
    if not FileExists(IncludeTrailingPathDelimiter(FBasePath) + vFileName) then
    begin
      Inc(vError) ;
    end;
  end;

  if vError > 0 then
  begin
    FError := 'Version incomplète : ' + IntToStr(vError) + ' fichiers sont manquants' ;
    Exit ;
  end;

  Result := True ;
end;

constructor TZipVersion.Create;
begin
  inherited Create(true) ;

  FStatus := vsNone ;
  FRunning := false ;
  
  FileList := TStringList.Create ;
  resume ;

  sleep(100) ;
end;

destructor TZipVersion.Destroy;
begin
  Terminate ; Resume ; WaitFor ;

  FileList.Free ;

  inherited;
end;

function TZipVersion.doBuildVersion: boolean;
begin
  Result := false ;

  if FFileName = '' then
  begin
    FStatus := vsError ;
    FError  := 'ZIP Filename invalide' ;
    Exit ;
  end;

  if not getFileList then
  begin
    FStatus := vsError ;
    Exit ;
  end;

  if not addLocalFiles then
  begin
    FStatus := vsError ;
    Exit ;
  end;

  if not checkFiles  then
  begin
    FStatus := vsError ;
    Exit ;
  end;

  if not zipFiles then
  begin
    FStatus := vsError ;
    Exit ;
  end;

  FStatus := vsFinished ;
end;

procedure TZipVersion.Execute;
begin
  while not Terminated do
  begin
    suspend ;

    if not Terminated then
    begin
      FRunning := true ;

      try
        doBuildVersion ;
      except
      end;

      FRunning := false ;
    end;
  end;

  inherited;
end;

class function TZipVersion.ExplainStatus(aStatus: TZipVersionStatus): string;
begin
  case aStatus of
    vsNone      : Result := '' ;
    vsList      : Result := 'Récupération de la liste des fichiers ...' ;
    vsVerifying : Result := 'Vérification des fichiers ...' ;
    vsZip       : Result := 'Archivage des fichiers ...'  ;
    vsFinished  : Result := 'Traitement terminé' ;
    vsError     : Result := 'Traitement échoué' ;
  end;
end;

function TZipVersion.getFileList : boolean ;
var
  vUrl   : string ;
  vJson  : string ;
  vVersionFiles : TVersionFiles ;
  ia     : integer ;
  vStream : TStringStream ;
begin
  FStatus := vsList ;

  Result := false ;

  if (FVersion = '') then
  begin
    FError := 'Version invalide' ;
    Exit ;
  end;

  vUrl := 'http://' + URL_SERVEUR + '/admin/get_fichier_version.php?version=' + FVersion ;

  HTTP := TIdHTTP.Create ;
  HTTP.ReadTimeout    := 15000 ;
  HTTP.ConnectTimeout := 15000 ;

  vStream := TStringStream.Create('') ;

  try
    try
      HTTP.Get(vUrl, vStream);
    except
      on E:Exception do
      begin
        FError := 'Récupération de la liste sur Yellis impossible : ' + E.Message ;
        Exit ;
      end;
    end;

    if HTTP.ResponseCode <> 200 then
    begin
      FError := 'Récupération de la liste sur Yellis impossible : ' + HTTP.ResponseText ;
      Exit ;
    end;

    vJson := vStream.DataString ;

  finally
    vStream.Free ;
    HTTP.Free ;
  end;

  if vJson = '' then
  begin
    FError := 'Récupération de la liste sur Yellis impossible : Aucune réponse' ;
    Exit ;
  end;

  vVersionFiles := TVersionFiles.Create ;
  TJSON.JSONToObject(vJson, vVersionFiles) ;

  if vVersionFiles.version <> FVersion then
  begin
    FError := 'Récupération de la liste sur Yellis impossible : La version ne correspond pas.' ;
    Exit ;
  end;

  FileList.Clear ;

  if Length(vVersionFiles.files) < 1 then
  begin
    FError := 'Récupération de la liste sur Yellis impossible : Aucun fichiers récupérés.' ;
    Exit ;
  end;

  for ia := 0 to Length(vVersionFiles.files) - 1 do
  begin
    FileList.Add(vVersionFiles.files[ia]) ;
  end;

  Result := true ;
end;

function TZipVersion.zipFiles: boolean;
var
  vFile : string ;
  vFileName : string ;
  vRelativeFileName : string ;
  vBasePath : string ;
  vCaseMatch  : TFilenameCaseMatch ;
  ia         : integer ;
  vFileCount : Integer ;
  vStreamVersion : TStringStream ;
begin
  FStatus := vsZip ;
  Result := false ;

  try
    Zip := CreateOutArchive(CLSID_CFormatZip) ;
    vBasePath := IncludeTrailingPathDelimiter(FBasePath) ;

    vStreamVersion := TStringStream.Create ;
    vStreamVersion.WriteString(FVersion + #13#10) ;

    Zip.AddStream(vStreamVersion, TStreamOwnership.soReference, faNormal, DateTimeToFileTime(now), DateTimeToFileTime(now), 'version.txt' ,false, false);

    ia := 0 ;
    for vFile in FileList do
    begin
      vFileName := ExpandFileNameCase(vBasePath + vFile, vCaseMatch) ;
      vRelativeFileName := ExtractRelativePath(vBasePath, vFileName) ;

      Zip.AddFile(vFileName, vRelativeFileName);
      Inc(ia) ;
    end;

    try
      if FileExists(FFileName)
        then DeleteFile(FFileName) ;
    except
    end;

    Zip.SaveToFile(FFileName);

    vStreamVersion.Free ;
  except
    on E:Exception do
    begin
      FError := 'Création de l''archive impossible : ' + E.Message  ;
      Exit ;
    end;
  end;

  Result := true ;
end;

//==============================================================================
end.
