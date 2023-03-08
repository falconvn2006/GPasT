UNIT UCommon;

INTERFACE

USES SysUtils, Classes, Forms, StdCtrls, Controls, Windows;


PROCEDURE QuickSort(Liste: TStrings);
PROCEDURE LogAction(s: STRING);
PROCEDURE initLogFileName(AMemo: TMemo; AStatusLab: TLabel);
FUNCTION GetLogFile: STRING;
FUNCTION RemChrFromStr(sChr, sStr: STRING): STRING;
PROCEDURE Progress();
PROCEDURE Sablier(b: boolean; sender: TControl);
Function GetNumVersionSoft:string;

IMPLEMENTATION


VAR
  sLogFile: STRING;
  mMemo: TMemo;
  lStatus: TLabel;
  //renseigne un mémo et un fichier

PROCEDURE Progress();
BEGIN
  IF mMemo <> NIL THEN
  BEGIN
    mMemo.Lines[mMemo.Lines.Count - 1] := mMemo.Lines[mMemo.Lines.Count - 1] + '.';
    mMemo.Update;
  END;
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
    IF mMemo <> NIL THEN
    BEGIN
      mMemo.Lines.Insert(0, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + s);
      mMemo.Update;
    END;
    IF lStatus <> NIL THEN
    BEGIN
      lStatus.Caption := s;
      lStatus.Update;
    END;
  EXCEPT
    // tantpis, pas de log
  END;
END;

PROCEDURE initLogFileName(AMemo: TMemo; AStatusLab: TLabel);
BEGIN
  mMemo := AMemo;

  IF mMemo <> NIL THEN
    mMemo.clear;


  lStatus := AStatusLab;
  IF lStatus <> NIL THEN
    lStatus.Caption := 'Bienvenue dans ' + Application.Name;

  sLogFile := ExtractFilePath(Application.ExeName) + FormatDateTime('yyyy_mm_dd', Date) + '_' + ChangeFileExt(ExtractFileName(Application.ExeName), '.log');
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

Function GetNumVersionSoft:string;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  {Deux solutions : }
  if VerInfoSize <> 0 then
  {- Les info de version sont inclues }
  begin
    {On alloue de la mémoire pour un pointeur sur les info de version : }
    GetMem(VerInfo, VerInfoSize);
    {On récupère ces informations : }
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    {On traite les informations ainsi récupérées : }
    with VerValue^ do
    begin
      Result := IntTostr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntTostr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntTostr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntTostr(dwFileVersionLS and $FFFF);
    end;

    {On libère la place précédemment allouée : }
    FreeMem(VerInfo, VerInfoSize);
  end

  else
    {- Les infos de version ne sont pas inclues }
    {On déclenche une exception dans le programme : }
    raise EAccessViolation.Create('Les informations de version de sont pas inclues');
end;

END.

