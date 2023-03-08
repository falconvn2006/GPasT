unit UVersion;

interface

uses StrUtils, Windows, SysUtils;

Type
  TProcedure = procedure;

Function GetNumVersionSoft:string;

procedure splitVersionString(aVersion : String ; var aMajor, aMinor, aRelease, aBuild : Word) ;
function compareVersionString(aVersion, bVersion: string) : integer ;

implementation

procedure splitVersionString(aVersion : String ; var aMajor, aMinor, aRelease, aBuild : Word) ;
var
  ia, ib, ic, id : integer ;
  sa, sb, sc, sd : string ;
begin
  ia := PosEx('.', aVersion, 1) ;
  ib := PosEx('.', aVersion, ia+1) ;
  ic := PosEx('.', aVersion, ib+1) ;
  id := Length(aVersion) ;

  sa := '' ;  sb := '' ; sc := '' ; sd := '' ;

  if ia = 0 then
  begin
    sa := aVersion ;
  end else begin
    sa := copy(aVersion, 1, ia-1) ;
    if ib = 0 then
    begin
      sb := copy(aVersion, ia+1, id-ia) ;
    end else begin
      sb := copy(aVersion, ia+1, ib-ia-1) ;
      if ic = 0 then
      begin
        sc := copy(aVersion, ib+1, id-ib) ;
      end else begin
        sc := copy(aVersion, ib+1, ic-ib-1) ;
        sd := copy(aVersion, ic+1, id-ic) ;
      end ;
    end ;
  end ;

  aMajor    := StrToIntDef(sa, 0) ;
  aMinor    := StrToIntDef(sb, 0) ;
  aRelease  := StrToIntDef(sc, 0) ;
  aBuild    := StrToIntDef(sd, 0) ;
end;

function compareVersionString(aVersion, bVersion : string) : integer ;
var
  vAMaj, vAMin, vARel, vABui : Word ;
  vBMaj, vBMin, vBRel, vBBui : Word ;
begin
  splitVersionString(aVersion, vAMaj, vAMin, vARel, vABui) ;
  splitVersionString(bVersion, vBMaj, vBMin, vBRel, vBBui) ;

  Result := 0 ;

  if vAMaj > vBMaj  then
  begin
    Result := 1 ; Exit ;
  end;
  if vAMaj < vBMaj  then
  begin
    Result := -1 ; Exit ;
  end;

  if vAMin > vBMin  then
  begin
    Result := 1 ; Exit ;
  end;
  if vAMin < vBMin  then
  begin
    Result := -1 ; Exit ;
  end;

  if vARel > vBRel  then
  begin
    Result := 1 ; Exit ;
  end;
  if vARel < vBRel  then
  begin
    Result := -1 ; Exit ;
  end;

  if vABui > vBBui  then
  begin
    Result := 1 ; Exit ;
  end;
  if vABui < vBBui  then
  begin
    Result := -1 ; Exit ;
  end;
end;

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

end.
