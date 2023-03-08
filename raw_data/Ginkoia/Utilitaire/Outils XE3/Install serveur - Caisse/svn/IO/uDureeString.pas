unit uDureeString;

interface

function GetStrDuree(Deb : TDateTime; Fin : TDateTime = 0) : string;

implementation

uses
{$IF CompilerVersion>=28}
  System.SysUtils,
  System.DateUtils;
{$ELSE}
  SysUtils,
  DateUtils;
{$ifend}

// libelle pour les durées

function GetStrDuree(Deb : TDateTime; Fin : TDateTime) : string;

  function GetStrDuree(var Duree : Cardinal; Diviseur : cardinal) : string;
  var
    Reste : Cardinal;
  begin
    Result := '';
    try
      Reste := Duree mod Diviseur;
      Result := Format('%.' + IntToStr(Length(IntToStr(Diviseur -1))) + 'd', [Reste]);
      Duree := Duree div Diviseur;
    except

    end;
  end;

var
  Duree : Cardinal;
begin
  Result := '';
  if Fin = 0 then
    Fin := Now();
  Duree := MilliSecondsBetween(Fin, Deb);

  // les milliseconde
  Result := GetStrDuree(Duree, 1000) + 'ms';
  if Duree = 0 then
    Exit;

  // les secondes
  Result := GetStrDuree(Duree, 60) + 's ' + Result;
  if Duree = 0 then
    Exit;

  // les Minutes
  Result := GetStrDuree(Duree, 60) + 'm ' + Result;
  if Duree = 0 then
    Exit;

  // les Heures
  Result := GetStrDuree(Duree, 24) + 'h ' + Result;
  if Duree = 0 then
    Exit;

  Result := IntToStr(Duree) + 'j ' + Result;
end;

end.
