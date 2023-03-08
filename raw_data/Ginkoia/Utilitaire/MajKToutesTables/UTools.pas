unit UTools;

interface

uses
  SysUtils,
  IniFiles;

var
  iNbLog: integer;

PROCEDURE LogAction(s: STRING; ANiveau: integer = 0);
PROCEDURE initLogFileName(ANiveau: integer = 0; AppPath: string = ''; AFormatDateTime: string = 'yyyy_mm_dd');
FUNCTION RemChrFromStr(sChr, sStr: STRING): STRING;
PROCEDURE PurgeOldLogs(AppPath: string = ''; iDelOldLogAge: integer = 60);
function GetIniName: string;
function GetDatabaseFile: string;
function GetNiveauLog: integer;

implementation

VAR
  sLogFile    : STRING;
  gNiveauToLog: integer;

function GetIniName: string;
var
  sDllFile: string;
  sIniFile: string;

begin
  Result   := '';

  sDllFile := GetModuleName(hInstance);
  // UNC issue in Vista.
  if Pos('\\?\', sDllFile) = 1 then
    Delete(sDllFile, 1, 4);

  sIniFile := ChangeFileExt(sDllFile, '.ini');
  if FileExists(sIniFile) then
  begin
    Result := sIniFile;
  end
end;

function GetDatabaseFile: string;
var
  sIniFile : string;
  sIniPath : string;
  ifIniFile: TIniFile;

begin
  Result   := 'No ini file';
  sIniFile := GetIniName;
  sIniPath := IncludeTrailingPathDelimiter(ExtractFilePath(sIniFile));

  if sIniFile <> '' then
  begin
    ifIniFile := TIniFile.Create(sIniFile);
    try
      Result  := sIniPath + ifIniFile.ReadString('DATABASES', 'FILENAME', '');
    finally
      ifIniFile.Free;
    end;
  end;
end;

function GetNiveauLog: integer;
var
  sIniFile : string;
  sIniPath : string;
  ifIniFile: TIniFile;

begin
  Result   := 4;
  sIniFile := GetIniName;
  sIniPath := IncludeTrailingPathDelimiter(ExtractFilePath(sIniFile));

  if sIniFile <> '' then
  begin
    ifIniFile := TIniFile.Create(sIniFile);
    try
      Result  := ifIniFile.ReadInteger('LOGS', 'NIVEAU', 4);
    finally
      ifIniFile.Free;
    end;
  end;
end;

PROCEDURE LogAction(s: STRING; ANiveau: integer = 0);
// Niveau d'activation de log : 0 = Erreurs critiques, 1 = Erreurs normales, 2 = Informations, 3 = Debug
VAR
  F: TextFile;
BEGIN
  TRY
    AssignFile(F, sLogFile);
    IF NOT FileExists(sLogFile) THEN
    BEGIN
      Rewrite(F);
      CloseFile(F);
    END;
    IF ANiveau <= gNiveauToLog THEN
    BEGIN
      // Log effectué dans le fichier
      Inc(iNbLog);

      // Se positionne à la fin du fichier
      Append(F);

      WriteLn(F, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + s);

      CloseFile(F);
    END;

  EXCEPT
    // tantpis, pas de log
  END;
END;

FUNCTION RemChrFromStr(sChr, sStr: STRING): STRING;
BEGIN

  WHILE Pos(sChr, sStr) > 0 DO
  BEGIN
    Delete(sStr, Pos(sChr, sStr), Length(sChr));
  END;

  Result := sStr
END;

PROCEDURE PurgeOldLogs(AppPath: string = ''; iDelOldLogAge: integer = 60);
VAR
  trsFichier: TSearchRec;
  i         : integer;
BEGIN
  try
    IF FindFirst(ExtractFilePath(AppPath) + 'Logs\', faAnyFile, trsFichier) = 0 THEN
    BEGIN
      repeat
        if Pos(ChangeFileExt(ExtractFileName(AppPath), '.log'), trsFichier.Name) > 0 then
        begin
          // Supprimer le fichier s'il est trop vieux
          IF trsFichier.TimeStamp < (Now() - iDelOldLogAge) THEN
          BEGIN
            DeleteFile(trsFichier.Name);
            LogAction('Suppression vieux log : ' + trsFichier.Name, 0);
          END;
        end;
      until FindNext(trsFichier) <> 0;
    END;
    FindNext(trsFichier);
    // LogFiles.ThreadedSearch              := False;
    // LogFiles.Dirs                        := ExtractFilePath(AppPath) + 'Logs';
    // LogFiles.FileMasks                   := '*.*';
    // LogFiles.RecurseSubDirs              := False;
    // LogFiles.ReturnValues                := [rvDir, rvFileName];
    // LogFiles.ReturnDelimiter             := ';';
    // LogFiles.CreatedBefore.DateTimeValue := (Now() - iDelOldLogAge);
    // LogFiles.LookForDates                := [lfCreateBefore];
    // LogFiles.Grep;
    //
    // FileToDel.Options := [ffFilesOnly, ffNoActionConfirm];
    // FOR i             := 0 TO LogFiles.Files.Count - 1 DO
    // BEGIN
    // // Récup le nom du dossier, sous la forme 'DossierContenant;NomDossierAnnee;'
    // FileToDel.FileName := RemChrFromStr(';', LogFiles.Files[i]);
    // IF FileToDel.DeleteFiles(FileToDel.FileName) THEN
    // BEGIN
    // // On ne compte pas ce log
    // Dec(iNbLog)
    // END;
    // END;
    // FINALLY
    // FileToDel.Free;
    // END;
    // FINALLY
    //
    // END;
  except
    // En cas d'erreur on fait rien
  end;
END;

PROCEDURE initLogFileName(ANiveau: integer = 0; AppPath: string = ''; AFormatDateTime: string = 'yyyy_mm_dd');
// Objet de la procédure : initialiser les logs
// Chemin du log, mémo de compte rendu (si non, mettre nil), Label de compte rendu (si non, mettre nil)
// Niveau d'activation de log : 0 = Erreurs critiques, 1 = Erreurs normales, 2 = Informations, 3 = Debug
var
  sPath       : string;
  sAppFileName: string;
BEGIN
  iNbLog := 0;

  // On active le log pour ce niveau et ceux plus importants
  gNiveauToLog := ANiveau;

  sAppFileName := AppPath;

  sPath        := ExtractFilePath(sAppFileName) + 'Logs\';
  ForceDirectories(sPath);

  sLogFile := sPath + FormatDateTime(AFormatDateTime, Now) + '_' + ChangeFileExt(ExtractFileName(sAppFileName), '.log');
END;

end.
