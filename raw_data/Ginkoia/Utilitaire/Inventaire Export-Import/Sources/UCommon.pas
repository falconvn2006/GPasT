unit UCommon;

interface

uses SysUtils, Classes, Forms, StdCtrls;


procedure QuickSort(Liste: TStrings);
procedure LogAction(s: string);
procedure initLogFileName(AMemo: TMemo);
function GetLogFile: string;
function RemChrFromStr(sChr, sStr: string): string;
PROCEDURE Progress();


implementation


var
  sLogFile: string;
  mMemo: TMemo;

//renseigne un mémo et un fichier
PROCEDURE Progress();
begin
  mMemo.Lines[mMemo.Lines.Count-1] := mMemo.Lines[mMemo.Lines.Count-1] + '.';
  mMemo.Update;
END;

procedure LogAction(s: string);
var
  F: TextFile;
begin
  try
    AssignFile(F, sLogFile);
    if not FileExists(sLogFile) then
    begin
      Rewrite(F);
    end;
  // Se positionne à la fin du fichier
    Append(F);

    WriteLn(F, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + S);

    CloseFile(F);
    //complete le mémo
    mMemo.Lines.Add(FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + s);
    mMemo.Update;
  except
    // tantpis, pas de log
  end;
end;

procedure initLogFileName(AMemo: TMemo);
begin
  mMemo := AMemo;

  mMemo.clear;

  sLogFile := ExtractFilePath(Application.ExeName) + FormatDateTime('yyyy_mm_dd', Date) + '_' + ChangeFileExt(ExtractFileName(Application.ExeName), '.log');
end;

function GetLogFile: string;

begin
  result := sLogFile
end;

function RemChrFromStr(sChr, sStr: string): string;
begin

  while Pos(sChr, sStr) > 0 do
  begin
    delete(sStr, Pos(sChr, sStr), Length(sChr));
  end;

  result := sStr
end;


procedure QuickSort(Liste: TStrings);
     // FC : Procédure trouvée sur le Web, ne pas crier sur la facon de déclarer, merci...
  procedure RappelQuickSort(Liste: TStrings; Premier, Dernier: Integer);

     {Objectif : Procédure triant la liste de type TStrings reçu en paramètre.
                 Le trillage se fera avec le tri (Quick Sort).}

  var
    PremierTemp, DernierTemp: Integer;
    Milieu: string;

  begin
    PremierTemp := Premier;
    DernierTemp := Dernier;
    Milieu := Liste.Strings[(Dernier + Premier) div 2];

    repeat
      while Liste.Strings[PremierTemp] < Milieu do Inc(PremierTemp);
      while Liste.Strings[DernierTemp] > Milieu do Dec(DernierTemp);

      if PremierTemp <= DernierTemp then
      begin
        Liste.ExChange(PremierTemp, DernierTemp);
        Inc(PremierTemp);
        Dec(DernierTemp);
      end;

    until PremierTemp > DernierTemp;

    if DernierTemp > Premier then RappelQuickSort(Liste,
        Premier, DernierTemp);
    if PremierTemp < Dernier then RappelQuickSort(Liste,
        PremierTemp, Dernier);
  end;

begin
  IF Liste.Count > 0 THEN RappelQuickSort(Liste, 0, Liste.Count - 1);
end;

end.

