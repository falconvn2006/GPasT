unit uIntervalText;

interface

function GetIntervalText(Milliseconds : cardinal) : string; overload;
function GetIntervalText(Deb, Fin : TDateTime) : string; overload;

implementation

uses
  System.SysUtils,
  System.DateUtils;

function GetIntervalText(Milliseconds : cardinal) : string;

  function GetDureeText(var Duree : Cardinal; Diviseur : cardinal) : string;
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
  Duree := Milliseconds;
  // les milliseconde
  Result := GetDureeText(Duree, 1000) + 'ms';
  if Duree = 0 then
    Exit;
  // les secondes
  Result := GetDureeText(Duree, 60) + 's ' + Result;
  if Duree = 0 then
    Exit;
  // les Minutes
  Result := GetDureeText(Duree, 60) + 'm ' + Result;
  if Duree = 0 then
    Exit;
  // les Heures
  Result := GetDureeText(Duree, 24) + 'h ' + Result;
  if Duree = 0 then
    Exit;
  // resultat
  Result := IntToStr(Duree) + 'j ' + Result;
end;

function GetIntervalText(Deb, Fin : TDateTime) : string;
begin
  Result := GetIntervalText(MilliSecondsBetween(Fin, Deb));
end;

end.
