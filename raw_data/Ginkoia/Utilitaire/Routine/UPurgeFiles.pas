unit UPurgeFiles;

interface

procedure PurgeFiles(Path, Extention : string; nbDays : integer = 30; Recursif : boolean = false; FailOnError : boolean = false);

implementation

uses
  Classes,
  SysUtils,
  DateUtils;

type
  TPurgeThread = class(TThread)
  private
    FPath, FExtention : string;
    FnbDays : integer;
    FRecursif, FFailOnError : boolean;

    function Purge(Path, Extention : string; nbDays : integer; Recursif : boolean; FailOnError : boolean) : integer;
  protected
    procedure Execute(); override;
  public
    constructor Create(Path, Extention : string; nbDays : integer; Recursif, FailOnError, CreateSuspended : Boolean); reintroduce;
    destructor Destroy(); override;
  end;

procedure PurgeFiles(Path, Extention : string; nbDays : integer; Recursif : boolean; FailOnError : boolean);
begin
  TPurgeThread.Create(Path, Extention, nbDays, Recursif, FailOnError, false);
end;

{ TPurgeThread }

function TPurgeThread.Purge(Path, Extention : string; nbDays : integer; Recursif : boolean; FailOnError : boolean) : integer;
var
  RechFile : TSearchRec;
  ret : integer;
  DelDate : TDateTime;
  Error : string;
begin
  Result := 0;
  DelDate := IncDay(Date, -Abs(nbDays));
  Path := IncludeTrailingPathDelimiter(Path);
  if Extention[1] <> '.' then
    Extention := '.' + Extention;

  try
    ret := FindFirst(Path + '*', faAnyFile, RechFile);
    // Itterate thru files found with mask
    while ret = 0 do
    begin
      if Terminated then
        Exit;

      if ((RechFile.Name = '.') or (RechFile.Name = '..')) then
      begin
        // gestion des repertoire spéciaux
        // rien en fait...
      end
      else if (RechFile.Attr and faDirectory = faDirectory) then
      begin
        // en cas de repertoire, voir si recursif
        if Recursif then
          Inc(Result, Purge(Path + RechFile.Name, Extention, nbDays, Recursif, FailOnError));
      end
      else
      begin
        // plus vieux ?
        if (ExtractFileExt(RechFile.Name) = Extention) and (FileDateToDateTime(RechFile.Time) < DelDate) then
        begin
          // suppression et gestion de l'erreur
          if not DeleteFile(Path + RechFile.Name) and FailOnError then
          begin
            Error := 'PurgFiles() Failed on file : ' + Path + RechFile.Name + #13 + 'Error : ' + SysErrorMessage(GetLastError());
            raise Exception.Create(Error);
          end;
          Inc(Result);
        end;
      end;
      ret := FindNext(RechFile);
    end;
  finally
    FindClose(RechFile);
  end;
end;

procedure TPurgeThread.Execute();
begin
  ReturnValue := Purge(FPath, FExtention, FnbDays, FRecursif, FFailOnError);
end;

constructor TPurgeThread.Create(Path, Extention : string; nbDays : integer; Recursif, FailOnError, CreateSuspended : Boolean);
begin
  Inherited Create(CreateSuspended);

  FreeOnTerminate := true;

  FPath := Path;
  FExtention := Extention;
  FnbDays := nbDays;
  FRecursif := Recursif;
  FFailOnError := FailOnError;
end;

destructor TPurgeThread.Destroy();
begin
  // qqchose a faire ?
end;

end.
