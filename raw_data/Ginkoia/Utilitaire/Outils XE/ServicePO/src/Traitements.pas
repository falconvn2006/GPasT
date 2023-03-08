unit Traitements;

interface

uses
  IniFiles;

type
  TTraitement = Class;

  TTraitementClass = Class of TTraitement;

  TTraitement = class(TObject)
  private
    { Déclarations privées }
    FName : string;
    FPathSrc, FPathDest : string;
  public
    { Déclarations publiques }
    constructor Create(Name : string); reintroduce; overload;
    constructor Create(Name, PathSrc, PathDest : string); overload;

    function Execute() : boolean; virtual; abstract;

    Class function GetTraitementClass(Tipe : integer) : TTraitementClass;

    property PathSrc : string read FPathSrc write FPathSrc;
    property PathDest : string read FPathDest write FPathDest;
  end;

  TDirTraitement = class(TTraitement)
  private
    { Déclarations privées }
    FExtention : string;
    FNbFile : integer;
  public
    { Déclarations publiques }
    constructor Create(Name, PathSrc, PathDest, Extention : string; NbFile : integer); reintroduce;

    function Execute() : boolean; override;

    property Extention : string read FExtention write FExtention;
    property NbFile : integer read FNbFile write FNbFile;
  end;

  TFileTraitement = class(TTraitement)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute() : boolean; override;
  end;

  TZipTraitement = class(TTraitement)
  private
    { Déclarations privées }
    FNbFile : integer;
  public
    { Déclarations publiques }
    constructor Create(Name, PathSrc, PathDest : string; NbFile : integer); reintroduce;

    function Execute() : boolean; override;

    property NbFile : integer read FNbFile write FNbFile;
  end;

implementation

uses
  Windows,
  Classes,
  SysUtils,
  GestionLog,
  uSevenZip;

{ TTraitement }

constructor TTraitement.Create(Name : string);
begin
  Inherited Create();
  FName := Name;
  Log_Write('  Traitement ' + FName + ' (pas de paramètre)', el_Debug);
end;

constructor TTraitement.Create(Name, PathSrc, PathDest : string);
begin
  Inherited Create();
  FPathSrc := PathSrc;
  FPathDest := PathDest;
  Log_Write('  Traitement ' + FName, el_Debug);
  Log_Write('    Repertoire source : ' + FPathSrc, el_Debug);
  Log_Write('    Repertoire destination : ' + FPathDest, el_Debug);
end;

Class function TTraitement.GetTraitementClass(Tipe : integer) : TTraitementClass;
begin
  case tipe of
    1 : Result := TDirTraitement;
    2 : Result := TFileTraitement;
    3 : Result := TZipTraitement;
    else Raise Exception.Create('Type de traitement non géré.');
  end;
end;

{ TDirTraitement }

constructor TDirTraitement.Create(Name, PathSrc, PathDest, Extention : string; NbFile : integer);
begin
  Inherited Create(Name, PathSrc, PathDest);
  FExtention := Extention;
  FNbFile := NbFile;
  Log_Write('    Extention : ' + FExtention, el_Debug);
  Log_Write('    Nombre de fichier : ' + IntToStr(FNbFile), el_Debug);
end;

function TDirTraitement.Execute() : boolean;
var
  res, j : integer;
  FindInfo : TSearchRec;
  FileList : TStringList;
begin
  Result := false;

  if (FPathSrc = '') or
     (FPathDest = '') or
     (FExtention = '') or
     (FNbFile = 0) then
  begin
    Log_Write('Traitement non comletement renseigné', el_Warning);
  end
  else
  begin
    try
      // creation de la liste des fichier trier
      FileList := TStringList.Create();
      FileList.Sorted := true;
      FileList.Duplicates := dupIgnore;
      // recherche des fichiers
      try
        res := FindFirst(IncludeTrailingPathDelimiter(FPathSrc) + '*.' + FExtention, faAnyFile - faDirectory, FindInfo);
        while res = 0 do
        begin
          FileList.Add(FindInfo.Name);
          res := FindNext(FindInfo);
        end;
      finally
        FindClose(FindInfo);
      end;
      Log_Write(IntToStr(FileList.Count) + ' fichiers trouvés', el_debug);
      // ne garder que les 3 dernier
      While FileList.Count > FNbFile do
        FileList.Delete(0);
      // recherche de fichier dand la destination
      // pour ne garder que les x dernier fichier
      try
        res := FindFirst(IncludeTrailingPathDelimiter(FPathDest) + '*.' + FExtention, faAnyFile - faDirectory, FindInfo);
        while res = 0 do
        begin
          if FileList.IndexOf(FindInfo.Name) < 0 then
          begin
            Log_Write('Ancien fichier a supprimé : ' + FindInfo.Name, el_debug);
            DeleteFile(IncludeTrailingPathDelimiter(FPathDest) + FindInfo.Name);
          end;
          res := FindNext(FindInfo);
        end;
      finally
        FindClose(FindInfo);
      end;
      // copy !
      for j := 0 to FileList.Count -1 do
      begin
        if not FileExists(IncludeTrailingPathDelimiter(FPathDest) + FileList[j]) then
        begin
          Log_Write('Nouveau fichier : ' + FileList[j], el_debug);
          if not CopyFile(PChar(IncludeTrailingPathDelimiter(FPathSrc) + FileList[j]), PChar(IncludeTrailingPathDelimiter(FPathDest) + FileList[j]), true) then
            Raise Exception.Create(SysErrorMessage(GetLastError()));
        end;
      end;
      // oki tt vas bien !
      Result := true;
    finally
      FreeAndNil(FileList);
    end;
  end;
end;

{ TFileTraitement }

function TFileTraitement.Execute() : boolean;
var
  FileName : String;
  DateSource, DateDest : TDateTime;
begin
  Result := false;

  if (FPathSrc = '') or
     (FPathDest = '') then
  begin
    Log_Write('Traitement non comletement renseigné', el_Warning);
  end
  else if FileExists(FPathSrc) then
  begin
    FileName := ExtractFileName(FPathSrc);
    DateSource := FileDateToDateTime(FileAge(FPathSrc));
    if FileExists(IncludeTrailingPathDelimiter(FPathDest) + FileName) then
      DateDest := FileDateToDateTime(FileAge(IncludeTrailingPathDelimiter(FPathDest) + FileName))
    else
      DateDest := 0;
    if DateSource > DateDest then
    begin
      DeleteFile(IncludeTrailingPathDelimiter(FPathDest) + FileName);
      if not CopyFile(PChar(FPathSrc), PChar(IncludeTrailingPathDelimiter(FPathDest) + FileName), true) then
        Raise Exception.Create(SysErrorMessage(GetLastError()));
    end;
  end
  else
  begin
    Log_Write('Fichier inexistant', el_Warning);
  end;
end;

{ TZipTraitement }

constructor TZipTraitement.Create(Name, PathSrc, PathDest : string; NbFile : integer);
begin
  Inherited Create(Name, PathSrc, PathDest);
  FNbFile := NbFile;
  Log_Write('    Nombre de fichier : ' + IntToStr(FNbFile), el_Debug);
end;

function TZipTraitement.Execute() : boolean;
var
  ZipOut : I7zOutArchive;
  res, j : integer;
  FindInfo : TSearchRec;
  FileList : TStringList;
begin
  Result := false;

  if (FPathSrc = '') or
     (FPathDest = '') or
     (FNbFile = 0) then
  begin
    Log_Write('Traitement non comletement renseigné', el_Warning);
  end
  else if DirectoryExists(FPathSrc) then
  begin
    // suppression des vieux fichiers ...
    try
      // creation de la liste des fichier trier
      FileList := TStringList.Create();
      FileList.Sorted := true;
      FileList.Duplicates := dupIgnore;
      // recherche des fichiers
      try
        res := FindFirst(IncludeTrailingPathDelimiter(FPathDest) + '*.7z', faAnyFile - faDirectory, FindInfo);
        while res = 0 do
        begin
          FileList.Add(IncludeTrailingPathDelimiter(FPathDest) + FindInfo.Name);
          res := FindNext(FindInfo);
        end;
      finally
        FindClose(FindInfo);
      end;
      // suppression des vieux
      for j := 0 to FileList.Count -NbFile do
        DeleteFile(FileList[j]);
    finally
      FreeAndNil(FileList);
    end;
    // zippage du repertoire !
    try
      ZipOut := CreateOutArchive(CLSID_CFormat7z); // T7zOutArchive.Create(FormatDateTime('yyyy-mm-dd-hh-nn-ss', Now()) + '.7z', FPathSrc, FPathDest);
      ZipOut.AddFiles(FPathSrc, '', '*.*', true);
      ZipOut.SaveToFile(IncludeTrailingPathDelimiter(FPathDest) + FormatDateTime('yyyy-mm-dd-hh-nn-ss', Now()) + '.7z');
    finally
      ZipOut := nil;
    end;
  end
  else
  begin
    Log_Write('Repertoire inexistant', el_Warning);
  end;
end;

end.
