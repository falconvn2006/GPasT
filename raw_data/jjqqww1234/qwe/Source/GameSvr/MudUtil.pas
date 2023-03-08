unit mudutil;

interface

uses
  Classes, SysUtils, Grobal2, HUtil32, IniFiles;

type
  TIdInfo = record
    uid:   string[20];
    uname: string[30];
    ridx:  integer;
  end;
  PTIdInfo = ^TIdInfo;

  TQuickList = class(TStringList)
  public
    CaseSensitive: boolean;
    constructor Create; dynamic;
    function QAdd(str: string): boolean;
    function QAddObject(str: string; obj: TObject): boolean;
    function FFind(str: string): integer;
  end;

  TFindList = class(TStringList)
  public
    CaseSensitive: boolean;
    constructor Create(csensitive: boolean); dynamic;
    function FFind(str: string): integer;
    function FindObject(str: string; obj: TObject): integer;
  end;

  TQuickIdList = class(TStringList)
  public
    procedure QAdd(uid, uname: string; idx: integer);
    function FFind(str: string; var findlist: TList): integer;
    procedure DDelete(n: integer; uname: string);
  end;


var
  AbusiveList: TStringList;


procedure QuickSortStrListCase(list: TStringList; L, R: integer);
procedure QuickSortStrListNoCase(list: TStringList; L, R: integer);
function fmStr(str: string; len: integer): string;
function fmStr2(str: string; len: integer): string;
procedure LoadItemNameList(flname: string; nmlist: TStringList);
function GetDistanceHour(aaday, aatime: TDateTime): integer;
function LeftDir(dir: integer): integer;
function RightDir(dir: integer): integer;
function GetPower(power, trainrate: integer): integer;
function Get5Power(power, trainrate: integer): integer;
function IsValidExName(str: string): boolean;
function IsValidUserName(str: string): boolean;
function IsValidFileName(str: string): boolean;
function IsValidTaiwanFileName(str: string): boolean;
function CharCount(str: string; chr: char): integer;
function CheckValidUserName(uname: string): boolean;
procedure CheckValidFormat(var str: string);
procedure CheckListValid(alist: TStringList);
procedure CheckListValidTrim(alist: TStringList);
function ShortDateToDate(datestr: string): TDateTime;
function CalcDay(day: TDateTime; plus: integer): TDateTime;
function GetGoldLooks(Count: integer): integer;
function GetRandomLook(looks, rand: integer): integer;
function LoadAbusiveList(flname: string): boolean;
function ChangeAbusiveText(var str: string): boolean;
function SafeLoadFromFile(flname: string; strlist: TStringList): boolean;
function ReplaceNewLine(Source: string): string;  //  \n -> char($a) 로 변경 시킴


implementation


procedure QuickSortStrListCase(list: TStringList; L, R: integer);
var
  I, J: integer;
  P:    string;
begin
  repeat
    I := L;
    J := R;
    P := List[(L + R) shr 1];
    repeat
      while CompareStr(list[I], P) < 0 do
        Inc(I);
      while CompareStr(list[J], P) > 0 do
        Dec(J);
      if I <= J then begin
        List.Exchange(I, J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSortStrListCase(list, L, J);
    L := I;
  until I >= R;
end;

procedure QuickSortStrListNoCase(list: TStringList; L, R: integer);
var
  I, J: integer;
  P:    string;
begin
  if list.Count <= 0 then
    exit;
  repeat
    I := L;
    J := R;
    P := List[(L + R) shr 1];
    repeat
      while CompareText(list[I], P) < 0 do
        Inc(I);
      while CompareText(list[J], P) > 0 do
        Dec(J);
      if I <= J then begin
        List.Exchange(I, J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSortStrListNoCase(list, L, J);
    L := I;
  until I >= R;
end;


{    TQuickList    }

constructor TQuickList.Create;
begin
  CaseSensitive := False;
  inherited Create;
end;

{같은 이름은 추가될 수 없다.}
function TQuickList.QAddObject(str: string; obj: TObject): boolean;
var
  t, b, n, i: integer;
begin
  Result := True;
  if Count = 0 then begin
    AddObject(str, obj);
    exit;
  end;
  if CaseSensitive then begin
    if Count = 1 then begin
      n := CompareStr(str, Strings[0]);
      if n > 0 then
        AddObject(str, obj)
      else if n < 0 then
        InsertObject(0, str, obj);
      exit;
    end;
    t := 0;
    b := Count - 1;
    n := t + (b - t) div 2;
    while True do begin
      if b - t = 1 then begin
        n := CompareStr(str, Strings[b]);
        if n > 0 then begin
          InsertObject(b + 1, str, obj);
          break;
        end;
        n := CompareStr(str, Strings[t]);
        if n > 0 then begin
          InsertObject(t + 1, str, obj);
          break;
        end else if n < 0 then begin
          InsertObject(t, str, obj);
          break;
        end;
        Result := False;
        break;
      end;
      i := CompareStr(str, Strings[n]);
      if i > 0 then begin  //str은 더 뒤로..
        t := n;
        n := t + (b - t) div 2;
      end else if i < 0 then begin //str은 더 위로..
        b := n;
        n := t + (b - t) div 2;
      end else begin
        {fail...}
        Result := False;
        break;
      end;
    end;
  end else begin
    if Count = 1 then begin
      n := CompareText(str, Strings[0]);
      if n > 0 then
        AddObject(str, obj)
      else if n < 0 then
        InsertObject(0, str, obj);
      exit;
    end;
    t := 0;
    b := Count - 1;
    n := t + (b - t) div 2;
    while True do begin
      if b - t = 1 then begin
        n := CompareText(str, Strings[b]);
        if n > 0 then begin
          InsertObject(b + 1, str, obj);
          break;
        end;
        n := CompareText(str, Strings[t]);
        if n > 0 then begin
          InsertObject(t + 1, str, obj);
          break;
        end else if n < 0 then begin
          InsertObject(t, str, obj);
          break;
        end;
        Result := False;
        break;
      end;
      i := CompareText(str, Strings[n]);
      if i > 0 then begin  //str은 더 뒤로..
        t := n;
        n := t + (b - t) div 2;
      end else if i < 0 then begin //str은 더 위로..
        b := n;
        n := t + (b - t) div 2;
      end else begin
        {fail...}
        Result := False;
        break;
      end;
    end;
  end;
end;

function TQuickList.QAdd(str: string): boolean;
begin
  Result := QAddObject(str, nil);
end;

{ -1 : fail }
function TQuickList.FFind(str: string): integer;
var
  t, b, n, i: integer;
begin
  Result := -1;
  if Count = 0 then
    exit;
  if CaseSensitive then begin
    if Count = 1 then begin
      if CompareStr(str, Strings[0]) = 0 then
        Result := 0;
      exit;
    end;
    t := 0;
    b := Count - 1;
    n := t + (b - t) div 2;
    while True do begin
      if b - t = 1 then begin
        if CompareStr(str, Strings[b]) = 0 then
          Result := b;
        if CompareStr(str, Strings[t]) = 0 then
          Result := t;
        break;
      end;
      i := CompareStr(str, Strings[n]);
      if i > 0 then begin  //str은 더 뒤로..
        t := n;
        n := t + (b - t) div 2;
      end else if i < 0 then begin //str은 더 위로..
        b := n;
        n := t + (b - t) div 2;
      end else begin
        {success}
        Result := n;
        break;
      end;
    end;
  end else begin
    if Count = 1 then begin
      if CompareText(str, Strings[0]) = 0 then
        Result := 0;
      exit;
    end;
    t := 0;
    b := Count - 1;
    n := t + (b - t) div 2;
    while True do begin
      if b - t = 1 then begin
        if CompareText(str, Strings[b]) = 0 then
          Result := b;
        if CompareText(str, Strings[t]) = 0 then
          Result := t;
        break;
      end;
      i := CompareText(str, Strings[n]);
      if i > 0 then begin  //str은 더 뒤로..
        t := n;
        n := t + (b - t) div 2;
      end else if i < 0 then begin //str은 더 위로..
        b := n;
        n := t + (b - t) div 2;
      end else begin
        {success}
        Result := n;
        break;
      end;
    end;
  end;
end;

//------------------------------------------------------------

procedure TQuickIdList.QAdd(uid, uname: string; idx: integer);
var
  t, b, n, i, k: integer;
  pid:  PTIdInfo;
  list: TList;
begin
  new(pid);
  pid.uid   := uid;
  pid.uname := uname;
  pid.ridx  := idx;
  if Count = 0 then begin
    list := TList.Create;
    list.Add(pid);
    AddObject(uid, list);
    exit;
  end;
  if Count = 1 then begin
    n := CompareStr(uid, Strings[0]);
    if n > 0 then begin
      list := TList.Create;
      list.Add(pid);
      AddObject(uid, list);
    end else if n < 0 then begin
      list := TList.Create;
      list.Add(pid);
      InsertObject(0, uid, list);
    end else begin
      list := TList(Objects[0]);
      list.Add(pid);
    end;
    exit;
  end;
  t := 0;
  b := Count - 1;
  n := t + (b - t) div 2;
  while True do begin
    if b - t = 1 then begin
      k := CompareStr(uid, Strings[b]);
      if k > 0 then begin
        list := TList.Create;
        list.Add(pid);
        InsertObject(b + 1, uid, list);
        break;
      end;
      if CompareStr(uid, Strings[b]) = 0 then begin
        list := TList(Objects[b]);
        list.Add(pid);
      end else begin
        k := CompareStr(uid, Strings[t]);
        if k > 0 then begin
          list := TList.Create;
          list.Add(pid);
          InsertObject(t + 1, uid, list);
        end else if k < 0 then begin
          list := TList.Create;
          list.Add(pid);
          InsertObject(t, uid, list);
        end else begin //같으면
          list := TList(Objects[k]);
          list.Add(pid);
        end;
      end;
      break;
    end;
    i := CompareStr(uid, Strings[n]);
    if i > 0 then begin  //str은 더 뒤로..
      t := n;
      n := t + (b - t) div 2;
    end else if i < 0 then begin //str은 더 위로..
      b := n;
      n := t + (b - t) div 2;
    end else begin // 같으면
      list := TList(Objects[n]);
      list.Add(pid);
      break;
    end;
  end;
end;

function TQuickIdList.FFind(str: string; var findlist: TList): integer;
var
  t, b, n, i, rr: integer;
begin
  Result := -1;
  if Count = 0 then
    exit;
  if Count = 1 then begin
    if CompareStr(str, Strings[0]) = 0 then begin
      findlist := TList(Objects[0]);
      Result   := 0;
    end;
    exit;
  end;
  t  := 0;
  b  := Count - 1;
  n  := t + (b - t) div 2;
  rr := -1;
  while True do begin
    if b - t = 1 then begin
      if CompareStr(str, Strings[b]) = 0 then begin
        rr := b;
      end;
      if CompareStr(str, Strings[t]) = 0 then
        rr := t;
      break;
    end;
    i := CompareStr(str, Strings[n]);
    if i > 0 then begin  //str은 더 뒤로..
      t := n;
      n := t + (b - t) div 2;
    end else if i < 0 then begin //str은 더 위로..
      b := n;
      n := t + (b - t) div 2;
    end else begin
      {success}
      rr := n;
      break;
    end;
  end;
  if rr <> -1 then begin
    findlist := TList(Objects[rr]);
  end;
  Result := rr;
end;

procedure TQuickIdList.DDelete(n: integer; uname: string);
var
  i:    integer;
  list: TList;
begin
  if n > Count - 1 then
    exit;
  list := TList(Objects[n]);
  for i := 0 to list.Count - 1 do begin
    if (uname = '') or (uname = PTIdInfo(List[i]).uname) then begin
      Dispose(list[i]);
      list.Delete(i);
      break;
    end;
  end;
  if list.Count = 0 then begin
    list.Free;
    inherited Delete(n);
  end;
end;


//------------------------------------------------------------

constructor TFindList.Create(csensitive: boolean);
begin
  inherited Create;
  CaseSensitive := csensitive;
end;

function TFindList.FFind(str: string): integer;
var
  i: integer;
begin
  Result := -1;
  if CaseSensitive then begin
    for i := 0 to Count - 1 do begin
      if str = Strings[i] then begin
        Result := i;
        break;
      end;
    end;
  end else begin
    for i := 0 to Count - 1 do begin
      if CompareText(str, Strings[i]) = 0 then begin
        Result := i;
        break;
      end;
    end;
  end;
end;

function TFindList.FindObject(str: string; obj: TObject): integer;
var
  i: integer;
begin
  Result := -1;
  if CaseSensitive then begin
    for i := 0 to Count - 1 do begin
      if obj = Objects[i] then
        if str = Strings[i] then begin
          Result := i;
          break;
        end;
    end;
  end else begin
    for i := 0 to Count - 1 do begin
      if obj = Objects[i] then
        if CompareText(str, Strings[i]) = 0 then begin
          Result := i;
          break;
        end;
    end;
  end;
end;


//------------------------------------------------------------


function fmStr(str: string; len: integer): string;
var
  i: integer;
begin
  try
    Result := str + ' ';
    for i := 1 to len - Length(str) - 1 do
      Result := Result + ' ';
  except
    Result := str + ' ';
  end;
end;

function fmStr2(str: string; len: integer): string;
var
  i: integer;
begin
  try
    if str = '' then
      str := '.';
    Result := str + ' ';
    for i := 1 to len - Length(str) - 1 do
      Result := Result + ' ';
  except
    Result := str + ' ';
  end;
end;


procedure LoadItemNameList(flname: string; nmlist: TStringList);
var
  i: integer;
begin
  nmlist.LoadFromFile(flname);
  i := 0;
  while True do begin
    if i >= nmlist.Count then
      break;
    if Trim(nmlist[i]) = '' then begin
      nmlist.Delete(i);
      continue;
    end;
    Inc(i);
  end;
end;

function GetDistanceHour(aaday, aatime: TDateTime): integer;
var
  ayear, amonth, aday, ahour, amin, asec, amsec: word;
  oyear, omonth, oday, ohour, omin, osec, omsec: word;
begin
  DecodeDate(aaday, oyear, omonth, oday);   {갖힌 날}
  DecodeDate(Date, ayear, amonth, aday);    {현재 날}
  Result := (ayear - oyear) * 24 * 30 * 12 + (amonth - omonth) *
    24 * 30 + (aday - oday) * 24;
  DecodeTime(aatime, ohour, omin, osec, omsec); {갖힌 시간}
  DecodeTime(Time, ahour, amin, asec, amsec);   {현재 시간}
  if ahour >= ohour then begin
    Result := Result + (ahour - ohour);
  end else begin
    Result := Result - ohour + ahour;
  end;
end;

function LeftDir(dir: integer): integer;
begin
  Result := 0;
  case dir of
    0: Result := 4;
    1: Result := 5;
    2: Result := 6;
    3: Result := 7;
    4: Result := 3;
    5: Result := 0;
    6: Result := 1;
    7: Result := 2;
  end;
end;

function RightDir(dir: integer): integer;
begin
  Result := 0;
  case dir of
    0: Result := 5;
    1: Result := 6;
    2: Result := 7;
    3: Result := 4;
    4: Result := 0;
    5: Result := 1;
    6: Result := 2;
    7: Result := 3;
  end;
end;


function GetPower(power, trainrate: integer): integer;
begin
  Result := Round((10 + trainrate * 0.9) * (power / 100));
end;

function Get5Power(power, trainrate: integer): integer;
begin
  Result := Round((50 + trainrate * 0.5) * (power / 100));
end;


function IsValidExName(str: string): boolean;
begin
  Result := True;
  if Pos('{', str) > 0 then
    Result := False;
  if Pos('<', str) > 0 then
    Result := False;
  if Pos('>', str) > 0 then
    Result := False;
end;

function IsValidUserName(str: string): boolean;
var
  i, len: integer;
begin
  Result := False;
  if str = '' then
    exit;
  Result := True;
  len    := Length(str);
  i      := 1;
  while True do begin
    if i > len then
      break;
    if ((byte(str[i]) < 48) or (byte(str[i]) > 122)) then begin
      Result := False;
      if (byte(str[i]) >= $B0) and (byte(str[i]) <= $C8) then begin
        Inc(i);
        if i <= len then
          if (byte(str[i]) >= $A1) and (byte(str[i]) <= $FE) then
            Result := True;
      end;
      if not Result then
        break;
    end;
    Inc(i);
  end;
end;

function IsValidFileName(str: string): boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(str) do begin
    if (byte(str[i]) < byte('0')) or (byte(str[i]) = byte('/')) or
      (byte(str[i]) = byte('\')) or (byte(str[i]) = byte(':')) or
      (byte(str[i]) = byte('<')) or (byte(str[i]) = byte('|')) or
      (byte(str[i]) = byte('?')) or (byte(str[i]) = byte('>')) then begin
      //sonmg(2004/02/06) (' '는 이미 포함되어 추가할 필요가 없음)
      Result := False;
      break;
    end;
  end;
end;

function IsValidTaiwanFileName(str: string): boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(str) do begin
    if (byte(str[i]) < byte('0')) or (byte(str[i]) = byte('/')) or
      //(byte(str[i]) = byte('\')) or
      (byte(str[i]) = byte(':')) or (byte(str[i]) = byte('<')) or
      (byte(str[i]) = byte('|')) or (byte(str[i]) = byte('?')) or
      (byte(str[i]) = byte('>')) then begin
      Result := False;
      break;
    end;
  end;
end;


(*function IsValidUserName (str: string): Boolean;
var
   i, len: integer;
begin
   Result := TRUE;
   len := Length(str);
   i := 1;
   while TRUE do begin
      if i > len then break;
      if (word(str[i]) >= $A0) and (i < len) then begin
         if (word(str[i]) < $B0) or (word(str[i]) > $C8) then begin
            Result := FALSE;
            break;
         end;
         Inc (i);
      end;
      Inc (i);
   end;
end; *)


function CharCount(str: string; chr: char): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 1 to Length(str) do
    if str[i] = chr then
      Inc(Result);
end;


function CheckValidUserName(uname: string): boolean;
var
  i: integer;
  han, ch: byte;
begin
  Result := True;
  han    := 0;
  for i := 1 to Length(uname) do begin
    ch := byte(uname[i]);
    if han = 1 then begin
      if (ch < $A1) then
        Result := False;
      han := 0;
    end else begin
      if (ch >= $B0) and (ch <= $C8) then begin
        han := 1; //한글
      end else if not ((ch >= byte('0')) and (ch <= byte('9')) or
        (ch >= byte('a')) and (ch <= byte('z')) or (ch >= byte('A')) and
        (ch <= byte('Z'))) then
        Result := False;
    end;
    if not Result then
      break;
  end;
end;

{function CheckValidUserName (uname: string): Boolean;
var
   i: integer;
begin
   Result := TRUE;
   for i:=1 to Length(uname) do
      if i mod 2 = 1 then begin
         if not (((byte(uname[i]) >= byte('1')) and ((byte(uname[i]) <= byte('z')))) or (byte(uname[i]) >= $B0)) then begin
            Result := FALSE;
            break;
         end;
      end;
end;}

procedure CheckValidFormat(var str: string);
var
  i: integer;
begin
  for i := 1 to Length(str) do begin
    if (str[i] = '<') or (str[i] = '>') or ((str[i] = '[') and (i = 1)) then
      str[i] := '?';
  end;
end;

procedure CheckListValid(alist: TStringList);
var
  i: integer;
begin
  i := 0;
  while True do begin
    if i >= alist.Count - 1 then
      break;
    if Trim(alist[i]) = '' then begin
      alist.Delete(i);
      continue;
    end;
    Inc(i);
  end;
end;

procedure CheckListValidTrim(alist: TStringList);
var
  i: integer;
begin
  i := 0;
  while True do begin
    if i >= alist.Count - 1 then
      break;
    alist[i] := Trim(alist[i]);
    if alist[i] = '' then begin
      alist.Delete(i);
      continue;
    end;
    Inc(i);
  end;
end;


function ShortDateToDate(datestr: string): TDateTime; // 99-11-30
var
  year, mon, day: integer;
  str: string;
begin
  datestr := GetValidStr3(datestr, str, ['/', '-']);
  year    := Str_ToInt(str, 0);
  if year >= 90 then
    year := 1900 + year
  else
    year := 2000 + year;
  datestr := GetValidStr3(datestr, str, ['/', '-']);
  mon := Str_ToInt(str, 0);
  if not (mon in [1..12]) then
    mon := 1;
  day := Str_ToInt(datestr, 0);
  if not (day in [1..31]) then
    day := 1;
  Result := EncodeDate(year, mon, day);
end;

function CalcDay(day: TDateTime; plus: integer): TDateTime;
var
  ayear, amon, aday: word;
begin
  if plus > 0 then begin
    plus := plus - 1;
    DecodeDate(day, ayear, amon, aday);
    while True do begin
      if aday + plus > MonthDays[False][amon] then begin
        plus := aday + plus - MonthDays[False][amon] - 1;
        aday := 1;
        if amon <= 11 then
          Inc(amon)
        else begin
          amon := 1;
          if ayear = 99 then
            ayear := 2000
          else
            Inc(ayear);
        end;
      end else begin
        aday := aday + plus;
        break;
      end;
    end;
    Result := EncodeDate(ayear, amon, aday);
  end else
    Result := day;
end;


function GetGoldLooks(Count: integer): integer;
begin
  Result := 112;
  if Count >= 30 then
    Result := 113;
  if Count >= 70 then
    Result := 114;
  if Count >= 300 then
    Result := 115;
  if Count >= 1000 then
    Result := 116;
end;

function GetRandomLook(looks, rand: integer): integer;
begin
  Result := looks + Random(rand);
end;

function LoadAbusiveList(flname: string): boolean;
begin
  Result := False;
  if FileExists(flname) then begin
    AbusiveList.LoadFromFile(flname);
    CheckListValid(AbusiveList);
    Result := True;
  end;
end;

function ChangeAbusiveText(var str: string): boolean;

  function strstr(elementptr, dptr: PChar; elen, dlen: integer): PChar;
  var
    old: integer;
    eptr:   PChar;
  begin
    Result := nil;
    old    := elen;
    while True do begin
      if dlen <= 0 then
        break;
      if byte(dptr^) = byte(elementptr^) then begin
        eptr   := elementptr;
        Result := dptr;
        elen   := old;
        while True do begin
          if byte(dptr^) <> byte(eptr^) then begin
            Result := nil;
            break;
          end;
          Dec(dlen);
          Dec(elen);
          if (dlen <= 0) or (elen <= 0) then begin
            if elen > 0 then
              Result := nil;
            exit;
          end;
          dptr := PChar(integer(dptr) + 1);
          eptr := PChar(integer(eptr) + 1);
        end;
      end else begin
        if byte(dptr^) >= $B0 then begin
          dptr := PChar(integer(dptr) + 1);
          Dec(dlen);
        end;
      end;
      dptr := PChar(integer(dptr) + 1);
      Dec(dlen);
    end;
  end;

var
  i, slen, dlen, pl, dl: integer;
  dptr, pstr, fptr: PChar;
begin
  Result := False;
  dlen   := Length(str);
  for i := 0 to AbusiveList.Count - 1 do begin
    slen := Length(AbusiveList[i]);
    if slen <= dlen then begin
      pstr := @(AbusiveList[i][1]);
      dptr := @(str[1]);
      pl   := Length(AbusiveList[i]);
      dl   := Length(str);
      while True do begin
        fptr := strstr(pstr, dptr, pl, dl);
        if fptr <> nil then begin
          FillChar(fptr^, pl, '*');
          Result := True;
        end else
          break;
      end;
    end;
  end;
end;


function SafeLoadFromFile(flname: string; strlist: TStringList): boolean;
var
  f:   TextFile;
  str: string;
begin
  Result := False;   // added by sonmg
   {$I-}
  AssignFile(f, flname);
  FileMode := 0;
  Reset(f);
  if IOResult = 0 then begin
    while not EOF(f) do begin
      ReadLn(f, str);
      strlist.Add(str);
      Result := True;   // added by sonmg
    end;
  end;
  CloseFile(f);
   {$I+}
end;

function ReplaceNewLine(Source: string): string;
var
  i, len: integer;
begin
  len    := Length(Source);
  Result := '';
  if len >= 2 then begin
    i := 1;
    while True do begin
      if i = len then
        Result := Result + Source[i];
      if i >= len then
        break;
      if (Source[i] = '\') and (Source[i + 1] = 'n') then begin
        Result := Result + char($a);
        Inc(i);
      end else
        Result := Result + Source[i];
      Inc(i);
    end;
  end else
    Result := Source;
end;


initialization
  begin
    AbusiveList := TStringList.Create;
  end;

finalization
  begin
    AbusiveList.Free;
  end;

end.
