unit uSearchTG;

{===============================================================================
 Unit      : uSearchTG
 Création  : 06/10/2005
 Auteur(s) : Gregory Ben Hamza

--- Description ----------------------------------------------------------------
  Unit regroupant les outils de recherche, manipulation(copier, supprimer) de
  fichiers sans utiliser l'API de windows
===============================================================================}

interface

uses
  Windows, SysUtils, Classes;

type
  TInfoSearch = record
    PathFolder: String;
    Name: String;
    PathAndName: ShortString;
    Size: integer;
    Time: Integer;
		Attr: Integer;
  end;

  TInfoSearching = array of TInfoSearch;

  TComtainerInfSearch = class(TObject)
  private
    FAInfoSearch: TInfoSearch;
  public
    property AInfoSearch: TInfoSearch read FAInfoSearch write FAInfoSearch;
  end;

  TCustomSearching = Class
  private
    FSortSearching: Boolean;
    FPathLog: string;
    FSLLog: TStringList;
    function GetFListFileNamesForSL: String;
    function GetFListPathAndFileNamesForSL: String;
    function GetFListPathForSL: String;
  protected
    FNbFilesFound: integer;
    FNbFoldersFound: integer;
    FTotalOctetsSize: integer;
    FTotalKoSize: integer;
    FRootFolder: ShortString;
    FTabInfoSearch: TInfoSearching;
    function ExtractFolder(Const Path: String): String; virtual;
    procedure AppendInfoSearch(ASearchRec: TSearchRec; Const DirFile: String = '';
                               Const IsFolder: Boolean = False; Const ARootFolder: String = ''); virtual;
    procedure FileSearching(Const Directory, FileExt: ShortString); virtual;
    procedure DirectorySearching(Const RootFolder, FileExt: ShortString; OneLevel: Boolean); virtual;
    procedure P_Sort; virtual;
  public
    constructor Create(Const Path: string); virtual;
    destructor Destroy; override;
    function FilesExist(Const Folder: String): Boolean; virtual;
    procedure Searching(RootFolder: ShortString; const FileExt: ShortString;
                        const Recursive: boolean; OneLevel: Boolean = False); virtual;
    procedure CopySearch(Const FolderDest: String); virtual;
    procedure DeleteSearch; virtual;
    property TotalOctetsSize: integer read FTotalKoSize;
    property TotalKoSize: integer read FTotalKoSize;
    property NbFilesFound: integer read FNbFilesFound;
    property NbFoldersFound: integer read FNbFoldersFound;
    property TabInfoSearch: TInfoSearching read FTabInfoSearch;
    property ListFileNamesForSL: String read GetFListFileNamesForSL;
    property ListPathForSL: String read GetFListPathForSL;
    property ListPathAndFileNamesForSL: String read GetFListPathAndFileNamesForSL;
    property SortSearching: Boolean read FSortSearching write FSortSearching;
  end;

  TSearching = Class(TCustomSearching)
  end;


procedure CopyFileTG(Const FileSource, FileCible: String);


implementation

uses Math, DateUtils;

procedure CopyFileTG(const FileSource, FileCible: String);
var
  FromF, ToF: file;
  NumRead, NumWritten: integer;
  Buf: array[1..2048] of Char;
begin
  if AnsiUpperCase(FileSource) <> AnsiUpperCase(FileCible) then
  begin
    AssignFile(FromF, FileSource);
    Reset(FromF, 1);
    AssignFile(ToF, FileCible);
    Rewrite(ToF, 1);
    try
      repeat
        BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
        BlockWrite(ToF, Buf, NumRead, NumWritten);
      until (NumRead = 0) or (NumWritten <> NumRead);
    finally
      CloseFile(FromF);
      CloseFile(ToF);
    end;
  end;
end;

{ TCustomSearching }

constructor TCustomSearching.Create(Const Path: string);
begin
  SetLength(FTabInfoSearch, 0);
  FNbFilesFound:= 0;
  FNbFoldersFound:= 0;
  FTotalOctetsSize:= 0;
  FTotalKoSize:= 0;
  FRootFolder:= '';
  FSortSearching:= False;
  FPathLog:= Path + 'Log_SearchTG_' + FormatDateTime('hh_nn_ss_zzz', Now) + '.log';
  FSLLog:= TStringList.Create;
end;

destructor TCustomSearching.Destroy;
begin
  if FSLLog.Count > 0 then
  begin
    if DirectoryExists(ExtractFilePath(FPathLog)) then
      FSLLog.SaveToFile(FPathLog)
    else
      { Permet la creation d'un fichier quand le chemin n'existe pas }
      FSLLog.SaveToFile('C:\' + ExtractFileName(FPathLog));
  end;
  FreeAndNil(FSLLog);

  Finalize(FTabInfoSearch);
  inherited Destroy;
end;

procedure TCustomSearching.AppendInfoSearch(ASearchRec: TSearchRec;
  Const DirFile: String = ''; Const IsFolder: Boolean = False;
  Const ARootFolder: String = '');
var
  Buffer: String;
begin
  try
    SetLength(FTabInfoSearch, Length(FTabInfoSearch)+1);
    if DirFile <> '' then
      begin
        FTabInfoSearch[High(FTabInfoSearch)].PathAndName:= DirFile + ASearchRec.Name;
        Buffer:= DirFile;
        if Buffer[Length(Buffer)] = '\' then
          Buffer:= copy(Buffer, 1, Length(Buffer)-1);
        FTabInfoSearch[High(FTabInfoSearch)].PathFolder:= Buffer;
        Inc(FNbFilesFound);
      end
    else
      if IsFolder then
        begin
          FTabInfoSearch[High(FTabInfoSearch)].PathFolder:= ARootFolder {FRootFolder} + ASearchRec.Name;
          Inc(FNbFoldersFound);
        end;

    FTabInfoSearch[High(FTabInfoSearch)].Name:= ASearchRec.Name;
    FTabInfoSearch[High(FTabInfoSearch)].Size:= ASearchRec.Size;
    FTabInfoSearch[High(FTabInfoSearch)].Time:= ASearchRec.Time;
    FTabInfoSearch[High(FTabInfoSearch)].Attr:= ASearchRec.Attr;
  except
    on E: Exception do
      begin
        FSLLog.Add('TCustomSearching.AppendInfoSearch :' + E.Message);
      end;
  end;
end;

procedure TCustomSearching.DirectorySearching(const RootFolder, FileExt: ShortString;
  OneLevel: Boolean);
var
  SearchDirRec : TSearchRec;
  FolderFound : String;
begin
  try
    try
      FindFirst(RootFolder + '*', faDirectory, SearchDirRec);
      if (SearchDirRec.Name <> '.') and (SearchDirRec.Name <> '..') and
         ((SearchDirRec.Attr and faDirectory) > 0) then
        FolderFound:= RootFolder + SearchDirRec.Name;

      while FindNext(SearchDirRec) = 0 do
        begin
          if (SearchDirRec.Name <> '.') and (SearchDirRec.Name <> '..') and
             ((SearchDirRec.Attr and faDirectory) > 0)then
            begin
              AppendInfoSearch(SearchDirRec, '', True, RootFolder);
              if not OneLevel then
                begin
                  FolderFound:= RootFolder + SearchDirRec.Name + '\';
                  FileSearching(FolderFound, FileExt);
                  DirectorySearching(FolderFound, FileExt, OneLevel);
                end;
            end;
        end;
    except
      on E: Exception do
        begin
          FSLLog.Add('TCustomSearching.DirectorySearching :' + E.Message);
        end;
    end;
  finally
    FindClose(SearchDirRec);
  end;
end;

procedure TCustomSearching.FileSearching(const Directory, FileExt: ShortString);
var
  SearchFileRec: TSearchRec;
begin
  try
    try
      if FindFirst(string(Directory) + string(FileExt), faAnyFile, SearchFileRec) = 0 then
        begin
          if (SearchFileRec.Name <> '.') and (SearchFileRec.Name <> '..') and
             ((SearchFileRec.Attr and faDirectory) = 0) then
            AppendInfoSearch(SearchFileRec, string(Directory));
          while FindNext(SearchFileRec) = 0 do
            begin
              if (SearchFileRec.Name <> '.') and (SearchFileRec.Name <> '..') and
                 ((SearchFileRec.Attr and faDirectory) = 0) then
                AppendInfoSearch(SearchFileRec, string(Directory));
            end;
        end;
    except
      on E: Exception do
        begin
          FSLLog.Add('TCustomSearching.FileSearching :' + E.Message);
        end;
    end;
  finally
    FindClose(SearchFileRec);
  end;
end;

procedure TCustomSearching.Searching(RootFolder: ShortString;
  const FileExt: ShortString; const Recursive: boolean; OneLevel: Boolean);
var
  i: integer;
begin
  try
    SetLength(FTabInfoSearch, 0);
    FRootFolder:= RootFolder;
    FNbFilesFound:= 0;
    FNbFoldersFound:= 0;
    FTotalOctetsSize:= 0;
    FTotalKoSize:= 0;
    if FRootFolder[Length(FRootFolder)] <> '\' then
      FRootFolder:= FRootFolder + '\';
    //if OneLevel then //if not OneLevel then
    FileSearching(FRootFolder, FileExt);
    if Recursive then
      DirectorySearching(FRootFolder, FileExt, OneLevel);
    if Length(TabInfoSearch) > 0 then
      begin
        for i:= 0 to High(TabInfoSearch) do
          FTotalOctetsSize:= FTotalOctetsSize + TabInfoSearch[i].Size;
        FTotalKoSize:= FTotalOctetsSize div 1024;
      end;
    if SortSearching then
      P_Sort;
  except
    on E: Exception do
      begin
        FSLLog.Add('TCustomSearching.Searching :' + E.Message);
      end;
  end;
end;

function TCustomSearching.GetFListFileNamesForSL: String;
var
  i: integer;
begin
  Result:= '';
  if Length(TabInfoSearch) = 0 then
    Exit;
  for i:= 0 to High(TabInfoSearch) do
    begin
      if Trim(TabInfoSearch[i].Name) <> '' then
        Result:= Result + TabInfoSearch[i].Name + #13#10;
    end;
end;

function TCustomSearching.GetFListPathAndFileNamesForSL: String;
var
  i: integer;
begin
  Result:= '';
  if Length(TabInfoSearch) = 0 then
    Exit;
  for i:= 0 to High(TabInfoSearch) do
    begin
      if Trim(string(TabInfoSearch[i].PathAndName)) <> '' then
        Result:= Result + string(TabInfoSearch[i].PathAndName) + #13#10;
    end;
end;

procedure TCustomSearching.P_Sort;
var
  i: integer;
  vContInfoSearch: TComtainerInfSearch;
  vSL: TStringList;
begin
  vSL:= TStringList.Create;
  try
    for i:= Low(FTabInfoSearch) to High(FTabInfoSearch) do
      begin
        vContInfoSearch:= TComtainerInfSearch.Create;
        vContInfoSearch.AInfoSearch:= FTabInfoSearch[i];
        vSL.AddObject(IntToStr(FTabInfoSearch[i].Time), vContInfoSearch);
      end;
    vSL.Sort;
    Finalize(FTabInfoSearch);
    SetLength(FTabInfoSearch, 0);
    for i:= 0 to vSL.Count -1 do
      begin
        SetLength(FTabInfoSearch, Length(FTabInfoSearch) +1);
        FTabInfoSearch[High(FTabInfoSearch)]:=  TComtainerInfSearch(vSL.Objects[i]).AInfoSearch;
        vContInfoSearch:= TComtainerInfSearch(vSL.Objects[i]);
        FreeAndNil(vContInfoSearch);
      end;
  finally
    FreeAndNil(vSL);
  end;
end;

function TCustomSearching.GetFListPathForSL: String;
var
  i, Idx: integer;
  vSL: TStringList;
begin
  Result:= '';
  if Length(TabInfoSearch) = 0 then
    Exit;
  vSL:= TStringList.Create;
  try
    for i:= 0 to High(TabInfoSearch) do
      begin
        if Trim(TabInfoSearch[i].PathFolder) <> '' then
          begin
            Idx:= vSL.IndexOf(TabInfoSearch[i].PathFolder);
            if Idx = -1 then
              vSL.Append(TabInfoSearch[i].PathFolder);
          end;
      end;
    Result:= vSL.Text;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TCustomSearching.CopySearch(const FolderDest: String);
var
  i: integer;
  vSL: TStringList;
  BufferDest: String;
  vSearch: TCustomSearching;
begin
  if Length(TabInfoSearch) <> 0 then
    begin
      vSL:= TStringList.Create;
      vSearch:= TCustomSearching.Create(ExtractFilePath(FPathLog));
      try
        vSL.Text:= ListPathAndFileNamesForSL;
        for i:= 0 to vSL.Count -1 do
          begin
            BufferDest:= FolderDest + '\' + ExtractFileName(vSL.Strings[i]);
            CopyFileTG(vSL.Strings[i], BufferDest);
          end;
        vSL.Text:= ListPathForSL;
        if Trim(vSL.Text) <> '' then
          begin
            for i:= 0 to vSL.Count -1 do
              begin
                BufferDest:= FolderDest + ExtractFolder(vSL.Strings[i]);
                if not DirectoryExists(BufferDest) then
                  ForceDirectories(BufferDest);
                vSearch.Searching(vSL.Strings[i], '*.*', True);
                CopySearch(BufferDest);
              end;
          end;
      finally
        FreeAndNil(vSL);
        FreeAndNil(vSearch);
      end;
    end;
end;

procedure TCustomSearching.DeleteSearch;
var
  i: integer;
  vSL: TStringList;
  vSearch: TCustomSearching;
begin
  if Length(TabInfoSearch) <> 0 then
    begin
      vSL:= TStringList.Create;
      vSearch:= TCustomSearching.Create(ExtractFilePath(FPathLog));
      try
        vSL.Text:= ListPathAndFileNamesForSL;
        for i:= 0 to vSL.Count -1 do
          begin
            if FileExists(vSL.Strings[i]) then
              DeleteFile(vSL.Strings[i]);
          end;
        {$I-}
        RmDir(copy(FRootFolder, 1, Length(FRootFolder)-1));
        vSL.Text:= ListPathForSL;
        if Trim(vSL.Text) <> '' then
          begin
            for i:= 0 to vSL.Count -1 do
              begin
                vSearch.Searching(vSL.Strings[i], '*.*', True);
                vSearch.DeleteSearch;
                RmDir(vSL.Strings[i]);
              end;
          end;
      finally
        FreeAndNil(vSL);
        FreeAndNil(vSearch);
      end;
    end;
end;

function TCustomSearching.FilesExist(const Folder: String): Boolean;
var
  vSearch: TCustomSearching;
begin
  vSearch:= TCustomSearching.Create(ExtractFilePath(FPathLog));
  try
    try
      vSearch.Searching(Folder, '*.*', False);
      Result:= vSearch.NbFilesFound <> 0;
    except
      on E: Exception do
        begin
          FSLLog.Add('TCustomSearching.FilesExist :' + E.Message);
        end;
    end;
  finally
    FreeAndNil(vSearch);
  end;
end;

function TCustomSearching.ExtractFolder(const Path: String): String;
var
  i: integer;
begin
  for i:= Length(Path) Downto 1 do
    begin
      if Path[i] = '\' then
        Result:= copy(Path, i, Length(Path) -i);
    end;
end;

end.
