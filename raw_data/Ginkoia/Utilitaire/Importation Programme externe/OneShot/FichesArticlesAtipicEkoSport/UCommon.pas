UNIT UCommon;

INTERFACE

USES SysUtils,
  Classes,
  Forms,
  FileCtrl,
  StdCtrls,
  Controls,
  LMDFileGrep,
  LMDFileCtrl
{$IFDEF DEBUG}
  ,
  Dialogs
{$ENDIF}
  ;

PROCEDURE QuickSort(Liste: TStrings);
PROCEDURE LogAction(s: STRING; ANiveau: integer = 0);
PROCEDURE initLogFileName(AMemo: TMemo; AStatusLab: TLabel; ANiveau: integer = 0; AAscendant: Boolean = True);
FUNCTION GetLogFile: STRING;
FUNCTION RemChrFromStr(sChr, sStr: STRING): STRING;
PROCEDURE Progress();
PROCEDURE Sablier(b: boolean; sender: TControl);
PROCEDURE PurgeOldLogs(bDelOldLogs: boolean = False; iDelOldLogAge: integer = 60);
FUNCTION StringToFloat(s: STRING): double;
PROCEDURE gTrace(S: STRING);
PROCEDURE DelCurrentLog;
FUNCTION ArrondiMonetaire(x: double): double;

VAR
  iNbLog: integer;

IMPLEMENTATION

VAR
  sLogFile: STRING;
  gNiveauToLog: integer;
  mMemo: TMemo;
  lStatus: TLabel;
  bMemo, bStatus: boolean;
  bAsc: Boolean;
  //renseigne un mémo et un fichier

FUNCTION StringToFloat(s: STRING): double;
VAR
  SvgDecSep: Char;
BEGIN
  SvgDecSep := DecimalSeparator;
  TRY
    // On teste avec un .
    DecimalSeparator := '.';
    Result := StrToFloat(S);
  EXCEPT
    TRY
      // On teste avec une ,
      DecimalSeparator := ',';
      Result := StrToFloat(S);
    EXCEPT
      Result := 0;
    END;
  END;
  DecimalSeparator := SvgDecSep;
END;

PROCEDURE Progress();
BEGIN
  mMemo.Lines[mMemo.Lines.Count - 1] := mMemo.Lines[mMemo.Lines.Count - 1] + '.';
  mMemo.Update;
END;

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

      WriteLn(F, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + S);

      CloseFile(F);
    END;

    //complete le mémo
    IF bMemo THEN
    BEGIN
      IF bAsc THEN
        mMemo.Lines.Add(FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + s)
      ELSE
        mMemo.Lines.Insert(0, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + s);
        
      mMemo.Update;
    END;

    IF bStatus THEN
    BEGIN
      lStatus.Caption := s;
      lStatus.Update;
    END;

  EXCEPT
    // tantpis, pas de log
  END;
END;

PROCEDURE DelCurrentLog;
VAR
  FileToDel: TLMDFileCtrl;
BEGIN
  FileToDel := TLMDFileCtrl.Create(NIL);
  TRY
    FileToDel.Options := [ffFilesOnly, ffNoActionConfirm];
    FileToDel.FileName := sLogFile;
    IF FileExists(FileToDel.FileName) THEN
    BEGIN
      IF FileToDel.DeleteFiles(FileToDel.FileName) THEN
      BEGIN
        //
      END;
    END;
  FINALLY
    FileToDel.Free;
  END;
END;

PROCEDURE PurgeOldLogs(bDelOldLogs: boolean = False; iDelOldLogAge: integer = 60);
VAR
  LogFiles: TLMDFileGrep;
  FileToDel: TLMDFileCtrl;
  i: integer;
BEGIN
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
        FOR i := 0 TO LogFiles.Files.Count - 1 DO
        BEGIN
          // Récup le nom du dossier, sous la forme 'DossierContenant;NomDossierAnnee;'
          FileToDel.FileName := RemChrFromStr(';', LogFiles.Files[i]);
          IF FileToDel.DeleteFiles(FileToDel.FileName) THEN
          BEGIN
            LogAction('Suppression vieux log : ' + FileToDel.FileName, 0);
            // On ne compte pas ce log
            Dec(iNbLog)
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

PROCEDURE initLogFileName(AMemo: TMemo; AStatusLab: TLabel; ANiveau: integer = 0; AAscendant: Boolean = True);
// Objet de la procédure : initialiser les logs
// Chemin du log, mémo de compte rendu (si non, mettre nil), Label de compte rendu (si non, mettre nil)
// Niveau d'activation de log : 0 = Erreurs critiques, 1 = Erreurs normales, 2 = Informations, 3 = Debug
BEGIN
  iNbLog := 0;
  bAsc := AAscendant;

  IF AMemo <> NIL THEN
  BEGIN
    mMemo := AMemo;
    mMemo.clear;
    bMemo := True;
  END
  ELSE
    bMemo := False;

  IF AStatusLab <> NIL THEN
  BEGIN
    lStatus := AStatusLab;
    lStatus.Caption := 'Bienvenue dans ' + Application.Name;
    bStatus := True;
  END
  ELSE
    bStatus := False;

  // On active le log pour ce niveau et ceux plus importants
  gNiveauToLog := ANiveau;

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

PROCEDURE gTrace(S: STRING);
BEGIN
{$IFDEF DEBUG}
  Showmessage(S);
{$ENDIF}

END;

FUNCTION ArrondiMonetaire(X: double): double;
BEGIN
  TRY
    Result := Round(X * 100) / 100;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := 0;
    END;
  END;

END;

END.

