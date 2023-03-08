unit uCommon;

interface

uses
  SysUtils, Classes, Windows, uMdlMaintenance;


function GetNowToStr: String;
function DOSS_CHEMINToUNC(Const ASRV_NOM, ADOSS_CHEMIN: String): String;
function DOSS_CHEMINToDirectory(Const ADOSS_CHEMIN: String): String;
function GetPathEmetteur(Const AEMETTEUR: TEmetteur; Const APath: String): String;

implementation

uses uConst;


function DOSS_CHEMINToUNC(Const ASRV_NOM, ADOSS_CHEMIN: String): String;
begin
  Result:= '\\' + ASRV_NOM + DOSS_CHEMINToDirectory(ADOSS_CHEMIN);
end;

function DOSS_CHEMINToDirectory(Const ADOSS_CHEMIN: String): String;
var
  i, vIdx: integer;
  Buffer: String;
begin
  Result:= '';

  if Pos('.', ADOSS_CHEMIN) <> 0 then
    Buffer:= ExtractFilePath(ADOSS_CHEMIN)
  else
    Buffer:= ADOSS_CHEMIN;

  if (Length(ADOSS_CHEMIN) in [1..3]) and (Pos(':', Buffer) <> 0) then
    begin
      Result:= '\' + Copy(Buffer, 1, Pos(':', Buffer)-1);
      Exit;
    end;

  for i:= Length(Buffer) Downto 1 do
    begin
      if Buffer[i] = ':' then
        begin
          vIdx:= i;
          Break;
        end;
    end;

  Result:= ExcludeTrailingBackslash(Copy(Buffer, vIdx +1, Length(Buffer) - vIdx));
end;

function GetPathEmetteur(Const AEMETTEUR: TEmetteur; Const APath: String): String;
var
  vIdx: integer;
begin
  Result:= APath;
  vIdx:= Pos(cDB_FileName_GINKOIA, Result);
  if vIdx <> 0 then
    Delete(Result, vIdx, 10);
  Result:= ExcludeTrailingBackslash(APath);
  Result:= Result + '\' + AEMETTEUR.ADossier.AGroupe.GROU_NOM + '\' + AEMETTEUR.ADossier.DOSS_DATABASE + '\' + AEMETTEUR.EMET_NOM;
end;

function GetNowToStr: String;
begin
  Result:= '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + '] ';
end;

end.

