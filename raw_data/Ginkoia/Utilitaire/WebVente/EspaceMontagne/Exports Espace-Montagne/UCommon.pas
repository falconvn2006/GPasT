UNIT UCommon;

INTERFACE

USES SysUtils, Classes, Forms, FileCtrl, StdCtrls, Controls, LMDFileGrep, LMDFileCtrl;


PROCEDURE QuickSort(Liste: TStrings);
PROCEDURE LogAction(s: STRING);
PROCEDURE initLogFileName(AMemo: TMemo; AStatusLab: TLabel);
FUNCTION GetLogFile: STRING;
FUNCTION RemChrFromStr(sChr, sStr: STRING): STRING;
PROCEDURE Progress();
PROCEDURE Sablier(b: boolean; sender: TControl);
PROCEDURE PurgeOldLogs(bDelOldLogs: boolean = False; iDelOldLogAge : integer = 60);

IMPLEMENTATION


VAR
  sLogFile: STRING;
  mMemo: TMemo;
  lStatus: TLabel;
  //renseigne un mémo et un fichier

PROCEDURE Progress();
BEGIN
  mMemo.Lines[mMemo.Lines.Count - 1] := mMemo.Lines[mMemo.Lines.Count - 1] + '.';
  mMemo.Update;
END;

PROCEDURE LogAction(s: STRING);
VAR
  F: TextFile;
BEGIN
  TRY
    AssignFile(F, sLogFile);
    IF NOT FileExists(sLogFile) THEN
    BEGIN
      Rewrite(F);
    END;
    // Se positionne à la fin du fichier
    Append(F);

    WriteLn(F, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + S);

    CloseFile(F);
    //complete le mémo
    mMemo.Lines.Insert(0, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + s);

    lStatus.Caption := s;
    mMemo.Update;
    lStatus.Update;
  EXCEPT
    // tantpis, pas de log
  END;
END;

PROCEDURE PurgeOldLogs(bDelOldLogs: boolean = False; iDelOldLogAge : integer = 60);
VAR
  LogFiles: TLMDFileGrep;
  FileToDel: TLMDFileCtrl;
  i: integer;
begin
  IF bDelOldLogs THEN
  BEGIN
    LogFiles := TLMDFileGrep.Create(NIL);
    TRY
      FileToDel := TLMDFileCtrl.Create(NIL);
      TRY
        LogFiles.ThreadedSearch := False;
        LogFiles.Dirs := ExtractFilePath(Application.ExeName) + 'Logs';
        LogFiles.FileMasks := '*.*';
        LogFiles.RecurseSubDirs := false;
        LogFiles.ReturnValues := [rvDir, rvFileName];
        LogFiles.ReturnDelimiter := ';';
        LogFiles.CreatedBefore.DateTimeValue := (Now() - iDelOldLogAge);
        LogFiles.LookForDates := [lfCreateBefore];
        LogFiles.Grep;

        FileToDel.Options := [ffFilesOnly, ffNoActionConfirm];
        // Pour chaque dossier année du dossier Extract, on va Zipper, puis supprimer les XML
        FOR i := 0 TO LogFiles.Files.Count - 1 DO
        BEGIN
          // Récup le nom du dossier, sous la forme 'DossierContenant;NomDossierAnnee;'
          FileToDel.FileName := RemChrFromStr(';', LogFiles.Files[i]);
          IF FileToDel.DeleteFiles(FileToDel.FileName) THEN
          BEGIN
            LogAction('Suppression vieux log : ' + FileToDel.FileName);
          END;
        END;
      FINALLY
        FileToDel.Free;
      END;
    FINALLY
      LogFiles.Free;
    END;
  END;
END;

PROCEDURE initLogFileName(AMemo: TMemo; AStatusLab: TLabel);
BEGIN
  mMemo := AMemo;

  mMemo.clear;


  lStatus := AStatusLab;
  lStatus.Caption := 'Bienvenue dans ' + Application.Name;
  ForceDirectories(ExtractFilePath(Application.ExeName) + 'Logs\');
  sLogFile := ExtractFilePath(Application.ExeName) + 'Logs\' + FormatDateTime('yyyy_mm_dd', Date) + '_' + ChangeFileExt(ExtractFileName(Application.ExeName), '.log');
END;

FUNCTION GetLogFile: STRING;

BEGIN
  result := sLogFile
END;

FUNCTION RemChrFromStr(sChr, sStr: STRING): STRING;
BEGIN

  WHILE Pos(sChr, sStr) > 0 DO
  BEGIN
    delete(sStr, Pos(sChr, sStr), Length(sChr));
  END;

  result := sStr
END;


PROCEDURE QuickSort(Liste: TStrings);
// FC : Procédure trouvée sur le Web, ne pas crier sur la facon de déclarer, merci...
  PROCEDURE RappelQuickSort(Liste: TStrings; Premier, Dernier: Integer);

    {Objectif : Procédure triant la liste de type TStrings reçu en paramètre.
                Le trillage se fera avec le tri (Quick Sort).}

  VAR
    PremierTemp, DernierTemp: Integer;
    Milieu: STRING;

  BEGIN
    PremierTemp := Premier;
    DernierTemp := Dernier;
    Milieu := Liste.Strings[(Dernier + Premier) DIV 2];

    REPEAT
      WHILE Liste.Strings[PremierTemp] < Milieu DO Inc(PremierTemp);
      WHILE Liste.Strings[DernierTemp] > Milieu DO Dec(DernierTemp);

      IF PremierTemp <= DernierTemp THEN
      BEGIN
        Liste.ExChange(PremierTemp, DernierTemp);
        Inc(PremierTemp);
        Dec(DernierTemp);
      END;

    UNTIL PremierTemp > DernierTemp;

    IF DernierTemp > Premier THEN RappelQuickSort(Liste,
        Premier, DernierTemp);
    IF PremierTemp < Dernier THEN RappelQuickSort(Liste,
        PremierTemp, Dernier);
  END;

BEGIN
  IF Liste.Count > 0 THEN RappelQuickSort(Liste, 0, Liste.Count - 1);
END;


PROCEDURE sablier(b: boolean; sender: TControl);
BEGIN
  IF B THEN
  BEGIN
    screen.cursor := crHourGlass;
    // on désactive la fenetre
    sender.Enabled := false;
  END
  ELSE
  BEGIN
    screen.cursor := crDefault;
    sender.Enabled := True;
  END;
END;



END.

