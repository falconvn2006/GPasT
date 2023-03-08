unit HUtil32;

{$WARN SYMBOL_PLATFORM OFF}

 //============================================
 // Latest Update date : 1998 1
 // Add/Update Function and procedure :
 //     CaptureString
 //       Str_PCopy            (4/29)
 //      Str_PCopyEx         (5/2)
 //      memset          (6/3)
 //       SpliteBitmap         (9/3)
 //       ArrestString         (10/27)  {name changed}
 //       IsStringNumber       (98'1/1)
 //      GetDirList        (98'12/9)
 //       GetFileDate          (98'12/9)
 //       TimeIsOut            (99'2/4)
 //       CatchString          (99'2/4)
 //       DivString            (99'2/4)
 //       DivTailString        (99'2/4)
 //       SPos                 (99'2/9)
 //============================================


interface

uses
  Classes, SysUtils, WinTypes, WinProcs, Graphics, Messages, Dialogs;

type
  TDouble = record
    d: array[0..1] of longint;
  end;

  Str4096 = array [0..4096] of char;
  Str256  = array [0..256] of char;

  TyNameTable = record
    Name: string;
    varl: longint;
  end;

  TLRect = record
    Left, Top, Right, Bottom: longint;
  end;

const
  MAXDEFCOLOR = 16;
  ColorNames: array [1..MAXDEFCOLOR] of TyNameTable = (
    (Name: 'BLACK'; varl: clBlack),
    (Name: 'BROWN'; varl: clMaroon),
    (Name: 'MARGENTA'; varl: clFuchsia),
    (Name: 'GREEN'; varl: clGreen),
    (Name: 'LTGREEN'; varl: clOlive),
    (Name: 'BLUE'; varl: clNavy),
    (Name: 'LTBLUE'; varl: clBlue),
    (Name: 'PURPLE'; varl: clPurple),
    (Name: 'CYAN'; varl: clTeal),
    (Name: 'LTCYAN'; varl: clAqua),
    (Name: 'GRAY'; varl: clGray),
    (Name: 'LTGRAY'; varl: clsilver),
    (Name: 'YELLOW'; varl: clYellow),
    (Name: 'LIME'; varl: clLime),
    (Name: 'WHITE'; varl: clWhite),
    (Name: 'RED'; varl: clRed)
    );

  MAXLISTMARKER = 3;
  LiMarkerNames: array [1..MAXLISTMARKER] of TyNameTable = (
    (Name: 'DISC'; varl: 0),
    (Name: 'CIRCLE'; varl: 1),
    (Name: 'SQUARE'; varl: 2)
    );

  MAXPREDEFINE = 3;
  PreDefineNames: array [1..MAXPREDEFINE] of TyNameTable = (
    (Name: 'LEFT'; varl: 0),
    (Name: 'RIGHT'; varl: 1),
    (Name: 'CENTER'; varl: 2)
    );




function CountGarbage(paper: TCanvas; Src: PChar; TargWidth: longint): integer;
{garbage}
{[ArrestString]
      Result = Remain string,
      RsltStr = captured string
}
function ArrestString(Source, SearchAfter, ArrestBefore: string;
  const DropTags: array of string; var RsltStr: string): string;
{*}
function ArrestStringEx(Source, SearchAfter, ArrestBefore: string;
  var ArrestStr: string): string;
function CaptureString(Source: string; var rdstr: string): string;
procedure ClearWindow(aCanvas: TCanvas; aLeft, aTop, aRight, aBottom: longint;
  aColor: TColor);
function CombineDirFile(SrcDir, TargName: string): string;
{*}
function CompareLStr(src, targ: string; compn: integer): boolean;
function CompareBackLStr(src, targ: string; compn: integer): boolean;
function CreateMask(Src: PChar; TargPos: integer): string;
procedure DrawTileImage(Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
procedure DrawingGhost(Rc: TRect);
function ExtractFileNameOnly(const fname: string): string;
function FloatToString(F: real): string;
function FloatToStrFixFmt(fVal: double; prec, digit: integer): string;
function FileSize(const FName: string): longint;
{*}
function FileCopy(Source, dest: string): boolean;
function FileCopyEx(Source, dest: string): boolean;
function GetSpaceCount(Str: string): longint;
function RemoveSpace(str: string): string;
function GetFirstWord(Str: string; var sWord: string; var FrontSpace: longint): string;
function GetDefColorByName(Str: string): TColor;
function GetULMarkerType(Str: string): longint;
{*}
function GetValidStr3(Str: string; var Dest: string;
  const Divider: array of char): string;
function GetValidStr4(Str: string; var Dest: string;
  const Divider: array of char): string;
function GetValidStrVal(Str: string; var Dest: string;
  const Divider: array of char): string;
function GetValidStrCap(Str: string; var Dest: string;
  const Divider: array of char): string;
function GetStrToCoords(Str: string): TRect;
function GetValidStrNoVal(Str: string; var Dest: string): string;
function GetDefines(Str: string): longint;
function GetValueFromMask(Src: PChar; Mask: string): string;
procedure GetDirList(path: string; fllist: TStringList);
function GetFileDate(filename: string): integer; //DOS format file date..
function HexToIntEx(shap_str: string): longint;
function HexToInt(str: string): longint;
function IntToStrFill(num, len: integer; fill: char): string;
function IsInB(Src: string; Pos: integer; Targ: string): boolean;
function IsInRect(X, Y: integer; Rect: TRect): boolean;
function IsEnglish(Ch: char): boolean;
function IsEngNumeric(Ch: char): boolean;
function IsFloatNumeric(str: string): boolean;
function IsUniformStr(src: string; ch: char): boolean;
function IsStringNumber(str: string): boolean;
function KillFirstSpace(var Str: string): longint;
procedure KillGabageSpace(var Str: string);
function LRect(l, t, r, b: longint): TLRect;
procedure MemPCopy(Dest: PChar; Src: string);
procedure MemCpy(Dest, Src: PChar; Count: longint);                {PChar type}
procedure memcpy2(TargAddr, SrcAddr: longint; Count: integer);     {Longint type}
procedure memset(buffer: PChar; fillchar: char; Count: integer);
procedure PCharSet(P: PChar; n: integer; ch: char);
function ReplaceChar(src: string; srcchr, repchr: char): string;
function Str_ToDate(str: string): TDateTime;
function Str_ToTime(str: string): TDateTime;
function Str_ToInt(Str: string; def: longint): longint;
function Str_ToInt64(Str: string; def: longint): int64;
function Str_ToFloat(str: string): real;
function SkipStr(Src: string; const Skips: array of char): string;
procedure ShlStr(Source: PChar; Count: integer);
procedure ShrStr(Source: PChar; Count: integer);
procedure Str256PCopy(Dest: PChar; const Src: string);
function _StrPas(dest: PChar): string;
function Str_PCopy(dest: PChar; src: string): integer;
function Str_PCopyEx(dest: PChar; const src: string; buflen: longint): integer;
procedure SpliteBitmap(DC: HDC; X, Y: integer; bitmap: TBitmap; transcolor: TColor);
procedure TiledImage(Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
function Trim_R(const str: string): string;
function IsEqualFont(SrcFont, TarFont: TFont): boolean;
function CutHalfCode(Str: string): string;
function ConvertToShortName(Canvas: TCanvas; Source: string;
  WantWidth: integer): string;
function TimeIsOut(dtime: TDateTime; taghour, tagmin: integer): boolean;
{*}
function CatchString(Source: string; cap: char; var catched: string): string;
function DivString(Source: string; cap: char; var sel: string): string;
function DivTailString(Source: string; cap: char; var sel: string): string;
function SPos(substr, str: string): integer;
function NumCopy(str: string): integer;
function GetMonDay: string;
function BoolToStr(boo: boolean): string;
function BoolToInt(boo: boolean): integer;
function TimeStr(atime: TDateTime): string;
function PackDouble(d: double): TDouble;
function SolveDouble(d: TDouble): double;



function _MIN(n1, n2: integer): integer;
function _MAX(n1, n2: integer): integer;

// 일반 스트링을 쿼리에 적합하게 변경 : PDS
function StrToSQLSafe(str: string): string;
// 쿼리스트링을 일반 스트링으로 변경 : PDS
function SQLSafeToStr(sqlstr: string): string;
// 개행문자등을 삭제한 스트링으로 변경
function StrToVisibleOnly(str: string): string;
// 개행문자를 Hint 에 맞게 고침 
function StrToHint(str: string): string;

implementation


function PackDouble(d: double): TDouble;
begin
  Move(d, Result, 8);
end;

function SolveDouble(d: TDouble): double;
begin
  Move(d, Result, 8);
end;

 //var
 //  CSUtilLock: TRTLCriticalSection;

{ capture "double quote streams" }
function CaptureString(Source: string; var rdstr: string): string;
var
  st, et, c, len, i: integer;
begin
  if Source = '' then begin
    rdstr  := '';
    Result := '';
    exit;
  end;
  c   := 1;
  //et := 0;
  len := Length(Source);
  while Source[c] = ' ' do
    if c < len then
      Inc(c)
    else
      break;

  if (Source[c] = '"') and (c < len) then begin

    st := c + 1;
    et := len;
    for i := c + 1 to len do
      if Source[i] = '"' then begin
        et := i - 1;
        break;
      end;

  end else begin
    st := c;
    et := len;
    for i := c to len do
      if Source[i] = ' ' then begin
        et := i - 1;
        break;
      end;

  end;

  rdstr := Copy(Source, st, (et - st + 1));
  if len >= (et + 2) then
    Result := Copy(Source, et + 2, len - (et + 1))
  else
    Result := '';

end;


function CountUglyWhiteChar(sPtr: PChar): longint;
var
  Cnt, Killw: longint;
begin
  Killw := 0;
  for Cnt := (StrLen(sPtr) - 1) downto 0 do begin
    if sPtr[Cnt] = ' ' then begin
      Inc(KillW);
      {sPtr[Cnt] := #0;}
    end else
      break;
  end;
  Result := Killw;
end;


function CountGarbage(paper: TCanvas; Src: PChar; TargWidth: longint): integer;
  {garbage}
var
  gab, destWidth: integer;
begin

  gab    := CountUglyWhiteChar(Src);
  destWidth := paper.TextWidth(StrPas(Src)) - gab;
  Result := TargWidth - DestWidth + (gab * paper.TextWidth(' '));

end;


function GetSpaceCount(Str: string): longint;
var
  Cnt, Len, SpaceCount: longint;
begin
  SpaceCount := 0;
  Len := Length(Str);
  for Cnt := 1 to Len do
    if Str[Cnt] = ' ' then
      SpaceCount := SpaceCount + 1;
  Result := SpaceCount;
end;

function RemoveSpace(str: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(str) do
    if str[i] <> ' ' then
      Result := Result + str[i];
end;

function KillFirstSpace(var Str: string): longint;
var
  Cnt, Len: longint;
begin
  Result := 0;
  Len    := Length(Str);
  for Cnt := 1 to Len do
    if Str[Cnt] <> ' ' then begin
      Str    := Copy(Str, Cnt, Len - Cnt + 1);
      Result := Cnt - 1;
      break;
    end;
end;

procedure KillGabageSpace(var Str: string);
var
  Cnt, Len: longint;
begin
  Len := Length(Str);
  for Cnt := Len downto 1 do
    if Str[Cnt] <> ' ' then begin
      Str := Copy(Str, 1, Cnt);
      KillFirstSpace(Str);
      break;
    end;
end;

function GetFirstWord(Str: string; var sWord: string; var FrontSpace: longint): string;
var
  Cnt, Len, N: longint;
  DestBuf:     Str4096;
begin
  Len := Length(Str);
  if Len <= 0 then
    Result := ''
  else begin
    FrontSpace := 0;
    for Cnt := 1 to Len do begin
      if Str[Cnt] = ' ' then
        Inc(FrontSpace)
      else
        break;
    end;
    N := 0;
    for Cnt := Cnt to Len do begin
      if Str[Cnt] <> ' ' then
        DestBuf[N] := Str[Cnt]
      else begin
        DestBuf[N] := #0;
        sWord      := StrPas(DestBuf);
        Result     := Copy(Str, Cnt, Len - Cnt + 1);
        exit;
      end;
      Inc(N);
    end;
    DestBuf[N] := #0;
    sWord      := StrPas(DestBuf);
    Result     := '';
  end;
end;

function HexToIntEx(shap_str: string): longint;
begin
  Result := HexToInt(Copy(Shap_str, 2, Length(Shap_str) - 1));
end;

function HexToInt(str: string): longint;
var
  digit:    char;
  Count, i: integer;
  Cur, Val: longint;
begin
  Val   := 0;
  Count := Length(str);
  for i := 1 to Count do begin
    digit := str[i];
    if (digit >= '0') and (digit <= '9') then
      Cur := Ord(digit) - Ord('0')
    else if (digit >= 'A') and (digit <= 'F') then
      Cur := Ord(digit) - Ord('A') + 10
    else if (digit >= 'a') and (digit <= 'f') then
      Cur := Ord(digit) - Ord('a') + 10
    else
      Cur := 0;
    Val := Val + (Cur shl (4 * (Count - i)));
  end;
  Result := Val;
  //   Result := (Val and $0000FF00) or ((Val shl 16) and $00FF0000) or ((Val shr 16) and $000000FF);
end;

function Str_ToInt(Str: string; def: longint): longint;
begin
  Result := def;
  if Str <> '' then begin
    if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
      (str[1] = '+') or (str[1] = '-') then
      try
        Result := StrToInt(Str);
      except
      end;
  end;
end;

function Str_ToInt64(Str: string; def: longint): int64;
begin
  Result := def;
  if Str <> '' then begin
    if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
      (str[1] = '+') or (str[1] = '-') then
      try
        Result := StrToInt64(Str);
      except
      end;
  end;
end;

function Str_ToDate(Str: string): TDateTime;
begin
  if Trim(Str) = '' then
    Result := Date
  else
    Result := StrToDate(str);
end;

function Str_ToTime(Str: string): TDateTime;
begin
  if Trim(Str) = '' then
    Result := Time
  else
    Result := StrToTime(str);
end;

function Str_ToFloat(str: string): real;
begin
  if str <> '' then
    try
      Result := StrToFloat(str);
      exit;
    except
    end;
  Result := 0;
end;

procedure DrawingGhost(Rc: TRect);
var
  DC: HDC;
begin
  DC := GetDC(0);
  DrawFocusRect(DC, Rc);
  ReleaseDC(0, DC);
end;

function ExtractFileNameOnly(const fname: string): string;
var
  extpos:  integer;
  ext, fn: string;
begin
  ext := ExtractFileExt(fname);
  fn  := ExtractFileName(fname);
  if ext <> '' then begin
    extpos := pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end else
    Result := fn;
end;

function FloatToString(F: real): string;
begin
  Result := FloatToStrFixFmt(F, 5, 2);
end;

function FloatToStrFixFmt(fVal: double; prec, digit: integer): string;
var
  cnt, dest, Len, I, j: integer;
  fstr: string;
  Buf:  array[0..255] of char;
label
  end_conv;
begin
  cnt  := 0;
  dest := 0;
  fstr := FloatToStrF(fVal, ffGeneral, 15, 3);
  Len  := Length(fstr);
  for i := 1 to Len do begin
    if fstr[i] = '.' then begin
      Buf[dest] := '.';
      Inc(dest);
      cnt := 0;
      for j := i + 1 to Len do begin
        if cnt < digit then begin
          Buf[dest] := fstr[j];
          Inc(dest);
        end else begin
          goto end_conv;
        end;
        Inc(cnt);
      end;
      goto end_conv;
    end;
    if cnt < prec then begin
      Buf[dest] := fstr[i];
      Inc(dest);
    end;
    Inc(cnt);
  end;
  end_conv: Buf[dest] := char(0);
  Result := strPas(Buf);
end;


function FileSize(const FName: string): longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else
    Result := -1;
end;


function FileCopy(Source, dest: string): boolean;
var
  fSrc, fDst, len: integer;
  size:   longint;
  buffer: packed array [0..2047] of byte;
begin
  Result := False; { Assume that it WONT work }
  if Source <> dest then begin
    fSrc := FileOpen(Source, fmOpenRead);
    if fSrc >= 0 then begin
      size := FileSeek(fSrc, 0, 2);
      FileSeek(fSrc, 0, 0);
      fDst := FileCreate(dest);
      if fDst >= 0 then begin
        while size > 0 do begin
          len := FileRead(fSrc, buffer, sizeof(buffer));
          FileWrite(fDst, buffer, len);
          size := size - len;
        end;
{$IFDEF MSWINDOWS}
        FileSetDate(fDst, FileGetDate(fSrc));
{$ENDIF}
        FileClose(fDst);
{$IFDEF MSWINDOWS}
        FileSetAttr(dest, FileGetAttr(Source));
{$ENDIF}
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;

function FileCopyEX(Source, dest: string): boolean;
var
  fSrc, fDst, len: integer;
  size:   longint;
  buffer: array [0..512000] of byte;
begin
  Result := False; { Assume that it WONT work }
  if Source <> dest then begin
    fSrc := FileOpen(Source, fmOpenRead or fmShareDenyNone);
    if fSrc >= 0 then begin
      size := FileSeek(fSrc, 0, 2);
      FileSeek(fSrc, 0, 0);
      fDst := FileCreate(dest);
      if fDst >= 0 then begin
        while size > 0 do begin
          len := FileRead(fSrc, buffer, sizeof(buffer));
          FileWrite(fDst, buffer, len);
          size := size - len;
        end;
{$IFDEF MSWINDOWS}
        FileSetDate(fDst, FileGetDate(fSrc));
{$ENDIF}
        FileClose(fDst);
{$IFDEF MSWINDOWS}
        FileSetAttr(dest, FileGetAttr(Source));
{$ENDIF}
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;


function GetDefColorByName(Str: string): TColor;
var
  Cnt:     integer;
  COmpStr: string;
begin
  compStr := UpperCase(str);
  for Cnt := 1 to MAXDEFCOLOR do begin
    if CompStr = ColorNames[Cnt].Name then begin
      Result := TColor(ColorNames[Cnt].varl);
      exit;
    end;
  end;
  Result := $0;
end;

function GetULMarkerType(Str: string): longint;
var
  Cnt:     integer;
  COmpStr: string;
begin
  compStr := UpperCase(str);
  for Cnt := 1 to MAXLISTMARKER do begin
    if CompStr = LiMarkerNames[Cnt].Name then begin
      Result := LiMarkerNames[Cnt].varl;
      exit;
    end;
  end;
  Result := 1;
end;

function GetDefines(Str: string): longint;
var
  Cnt:     integer;
  COmpStr: string;
begin
  compStr := UpperCase(str);
  for Cnt := 1 to MAXPREDEFINE do begin
    if CompStr = PreDefineNames[Cnt].Name then begin
      Result := PreDefineNames[Cnt].varl;
      exit;
    end;
  end;
  Result := -1;
end;

procedure ClearWindow(aCanvas: TCanvas; aLeft, aTop, aRight, aBottom: longint;
  aColor: TColor);
begin
  with aCanvas do begin
    Brush.Color := aColor;
    Pen.Color   := aColor;
    Rectangle(0, 0, aRight - aLeft, aBottom - aTop);
  end;
end;


procedure DrawTileImage(Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
var
  I, J, ICnt, JCnt, BmWidth, BmHeight: integer;
begin

  BmWidth  := TileImage.Width;
  BmHeight := TileImage.Height;
  ICnt     := ((Rect.Right - Rect.Left) + BmWidth - 1) div BmWidth;
  JCnt     := ((Rect.Bottom - Rect.Top) + BmHeight - 1) div BmHeight;

  UnrealizeObject(Canv.Handle);
  SelectPalette(Canv.Handle, TileImage.Palette, False);
  RealizePalette(Canv.Handle);

  for J := 0 to JCnt do begin
    for I := 0 to ICnt do begin

        { if (I * BmWidth) < (Rect.Right-Rect.Left) then
            BmWidth := TileImage.Width else
            BmWidth := (Rect.Right - Rect.Left) - ((I-1) * BmWidth);

         if (
         BmWidth := TileImage.Width;
         BmHeight := TileImage.Height;  }

      BitBlt(Canv.Handle,
        Rect.Left + I * BmWidth,
        Rect.Top + (J * BmHeight),
        BmWidth,
        BmHeight,
        TileImage.Canvas.Handle,
        0,
        0,
        SRCCOPY);

    end;
  end;

end;


procedure TiledImage(Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
var
  I, J, ICnt, JCnt, BmWidth, BmHeight: integer;
  Rleft, RTop, RWidth, RHeight, BLeft, BTop: longint;
begin

  if Assigned(TileImage) then
    if TileImage.Handle <> 0 then begin

      BmWidth  := TileImage.Width;
      BmHeight := TileImage.Height;
      ICnt     := (Rect.Right + BmWidth - 1) div BmWidth - (Rect.Left div BmWidth);
      JCnt     := (Rect.Bottom + BmHeight - 1) div BmHeight - (Rect.Top div BmHeight);

      UnrealizeObject(Canv.Handle);
      SelectPalette(Canv.Handle, TileImage.Palette, False);
      RealizePalette(Canv.Handle);

      for J := 0 to JCnt do begin
        for I := 0 to ICnt do begin

          if I = 0 then begin
            BLeft  := Rect.Left - ((Rect.Left div BmWidth) * BmWidth);
            RLeft  := Rect.Left;
            RWidth := BmWidth;
          end else begin
            if I = ICnt then
              RWidth := Rect.Right - ((Rect.Right div BmWidth) * BmWidth)
            else
              RWidth := BmWidth;
            BLeft := 0;
            RLeft := (Rect.Left div BmWidth) + (I * BmWidth);
          end;


          if J = 0 then begin
            BTop    := Rect.Top - ((Rect.Top div BmHeight) * BmHeight);
            RTop    := Rect.Top;
            RHeight := BmHeight;
          end else begin
            if J = JCnt then
              RHeight := Rect.Bottom - ((Rect.Bottom div BmHeight) * BmHeight)
            else
              RHeight := BmHeight;
            BTop := 0;
            RTop := (Rect.Top div BmHeight) + (J * BmHeight);
          end;

          BitBlt(Canv.Handle,
            RLeft,
            RTop,
            RWidth,
            RHeight,
            TileImage.Canvas.Handle,
            BLeft,
            BTop,
            SRCCOPY);

        end;
      end;

    end;
end;


function GetValidStr3(Str: string; var Dest: string;
  const Divider: array of char): string;
const
  BUF_SIZE = 20480; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of char;
  BufCount, Count, SrcLen, I, ArrCount: longint;
  Ch:  char;
label
  CATCH_DIV;
begin
  try
    SrcLen := Length(Str);
    BufCount := 0;
    Count := 1;
    Ch := #0;

    if SrcLen >= BUF_SIZE - 1 then begin
      Result := '';
      Dest   := '';
      exit;
    end;

    if Str = '' then begin
      Dest   := '';
      Result := Str;
      exit;
    end;
    ArrCount := sizeof(Divider) div sizeof(char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for I := 0 to ArrCount - 1 do
          if Ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV: if (BufCount > 0) then begin
            if BufCount < BUF_SIZE - 1 then begin
              Buf[BufCount] := #0;
              Dest   := string(Buf);
              Result := Copy(Str, Count + 1, SrcLen - Count);
            end;
            break;
          end else begin
            if (Count > SrcLen) then begin
              Dest   := '';
              Result := Copy(Str, Count + 2, SrcLen - 1);
              break;
            end;
          end;
      end else begin
        if BufCount < BUF_SIZE - 1 then begin
          Buf[BufCount] := Ch;
          Inc(BufCount);
        end;// else
            //ShowMessage ('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  except
    Dest   := '';
    Result := '';
  end;
end;


// 구분문자가 나머지(Result)에 포함 된다.
function GetValidStr4(Str: string; var Dest: string;
  const Divider: array of char): string;
const
  BUF_SIZE = 18200; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of char;
  BufCount, Count, SrcLen, I, ArrCount: longint;
  Ch:  char;
label
  CATCH_DIV;
begin
  try
    //EnterCriticalSection (CSUtilLock);
    SrcLen := Length(Str);
    BufCount := 0;
    Count := 1;
    Ch := #0;

    if Str = '' then begin
      Dest   := '';
      Result := Str;
      exit;
    end;
    ArrCount := sizeof(Divider) div sizeof(char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for I := 0 to ArrCount - 1 do
          if Ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV: if (BufCount > 0) or (Ch <> ' ') then begin
            if BufCount <= 0 then begin
              Buf[0] := Ch;
              Buf[1] := #0;
              Ch     := ' ';
            end else
              Buf[BufCount] := #0;
            Dest := string(Buf);
            if Ch <> ' ' then
              Result := Copy(Str, Count, SrcLen - Count + 1)
            //remain divider in rest-string,
            else
              Result := Copy(Str, Count + 1, SrcLen - Count);   //exclude whitespace
            break;
          end else begin
            if (Count > SrcLen) then begin
              Dest   := '';
              Result := Copy(Str, Count + 2, SrcLen - 1);
              break;
            end;
          end;
      end else begin
        if BufCount < BUF_SIZE - 1 then begin
          Buf[BufCount] := Ch;
          Inc(BufCount);
        end else
          ShowMessage('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;


function GetValidStrVal(Str: string; var Dest: string;
  const Divider: array of char): string;
  //숫자를 분리해냄 ex) 12.30mV
const
  BUF_SIZE = 15600;
var
  Buf:     array[0..BUF_SIZE] of char;
  BufCount, Count, SrcLen, I, ArrCount: longint;
  Ch:      char;
  currentNumeric: boolean;
  hexmode: boolean;
label
  CATCH_DIV;
begin
  try
    //EnterCriticalSection (CSUtilLock);
    hexmode := False;
    SrcLen := Length(Str);
    BufCount := 0;
    Count := 1;
    currentNumeric := False;
    Ch := #0;

    if Str = '' then begin
      Dest   := '';
      Result := Str;
      exit;
    end;
    ArrCount := sizeof(Divider) div sizeof(char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for I := 0 to ArrCount - 1 do
          if Ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if not currentNumeric then begin
        if (Count + 1) < SrcLen then begin
          if (Str[Count] = '0') and (UpCase(Str[Count + 1]) = 'X') then begin
            Buf[BufCount]     := Str[Count];
            Buf[BufCount + 1] := Str[Count + 1];
            Inc(BufCount, 2);
            Inc(Count, 2);
            hexmode := True;
            currentNumeric := True;
            continue;
          end;
          if (Ch = '-') and (Str[Count + 1] >= '0') and (Str[Count + 1] <= '9') then
          begin
            currentNumeric := True;
          end;
        end;
        if (Ch >= '0') and (Ch <= '9') then begin
          currentNumeric := True;
        end;
      end else begin
        if hexmode then begin
          if not (((Ch >= '0') and (Ch <= '9')) or
            ((Ch >= 'A') and (Ch <= 'F')) or ((Ch >= 'a') and (Ch <= 'f')))
          then begin
            Dec(Count);
            goto CATCH_DIV;
          end;
        end else if ((Ch < '0') or (Ch > '9')) and (Ch <> '.') then begin
          Dec(Count);
          goto CATCH_DIV;
        end;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV: if (BufCount > 0) then begin
            Buf[BufCount] := #0;
            Dest   := string(Buf);
            Result := Copy(Str, Count + 1, SrcLen - Count);
            break;
          end else begin
            if (Count > SrcLen) then begin
              Dest   := '';
              Result := Copy(Str, Count + 2, SrcLen - 1);
              break;
            end;
          end;
      end else begin
        if BufCount < BUF_SIZE - 1 then begin
          Buf[BufCount] := Ch;
          Inc(BufCount);
        end else
          ShowMessage('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;

{" " capture => CaptureString (source: string; var rdstr: string): string;
 ** 처음에 " 는 항상 맨 처음에 있다고 가정
}
function GetValidStrCap(Str: string; var Dest: string;
  const Divider: array of char): string;
begin
  str := TrimLeft(str);
  if str <> '' then begin
    if str[1] = '"' then
      Result := CaptureString(str, dest)
    else begin
      Result := GetValidStr3(str, dest, divider);
    end;
  end else begin
    Result := '';
    Dest   := '';
  end;
end;


function IntToStrFill(num, len: integer; fill: char): string;
var
  i:   integer;
  str: string;
begin
  Result := '';
  str    := IntToStr(num);
  for i := 1 to len - Length(str) do
    Result := Result + fill;
  Result := Result + str;
end;

function IsInB(Src: string; Pos: integer; Targ: string): boolean;
var
  TLen, I: integer;
begin
  Result := False;
  TLen   := Length(Targ);
  if Length(Src) < Pos + TLen then
    exit;
  for I := 0 to TLen - 1 do
    if UpCase(Src[Pos + I]) <> UpCase(Targ[I + 1]) then
      exit;

  Result := True;
end;

function IsInRect(X, Y: integer; Rect: TRect): boolean;
begin
  if (X >= Rect.Left) and (X <= Rect.Right) and (Y >= Rect.Top) and
    (Y <= Rect.Bottom) then
    Result := True
  else
    Result := False;
end;

function IsStringNumber(str: string): boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(str) do
    if (byte(str[i]) < byte('0')) or (byte(str[i]) > byte('9')) then begin
      if i = 1 then
        if (str[i] = '+') or (str[i] = '-') then
          continue;
      Result := False;
      break;
    end;
end;


{Return : remain string}

function ArrestString(Source, SearchAfter, ArrestBefore: string;
  const DropTags: array of string; var RsltStr: string): string;
const
  BUF_SIZE = $7FFF;
var
  Buf: array [0..BUF_SIZE] of char;
  BufCount, SrcCount, SrcLen, {AfterLen, BeforeLen,} DropCount, I: integer;
  ArrestNow: boolean;
begin
  try
    //EnterCriticalSection (CSUtilLock);
    RsltStr := ''; {result string}
    SrcLen  := Length(Source);

    if SrcLen > BUF_SIZE then begin
      Result := '';
      exit;
    end;

    BufCount  := 0;
    SrcCount  := 1;
    ArrestNow := False;
    DropCount := sizeof(DropTags) div sizeof(string);

    if (SearchAfter = '') then
      ArrestNow := True;

    //GetMem (Buf, BUF_SIZE);

    while True do begin
      if SrcCount > SrcLen then
        break;

      if not ArrestNow then begin
        if IsInB(Source, SrcCount, SearchAfter) then
          ArrestNow := True;
      end else begin
        Buf[BufCount] := Source[SrcCount];
        if IsInB(Source, SrcCount, ArrestBefore) or (BufCount >= BUF_SIZE - 2) then
        begin
          BufCount := BufCount - Length(ArrestBefore);
          Buf[BufCount + 1] := #0;
          RsltStr  := string(Buf);
          BufCount := 0;
          break;
        end;

        for I := 0 to DropCount - 1 do begin
          if IsInB(Source, SrcCount, DropTags[I]) then begin
            BufCount := BufCount - Length(DropTags[I]);
            break;
          end;
        end;

        Inc(BufCount);
      end;
      Inc(SrcCount);
    end;

    if (ArrestNow) and (BufCount <> 0) then begin
      Buf[BufCount] := #0;
      RsltStr := string(Buf);
    end;

    Result := Copy(Source, SrcCount + 1, SrcLen - SrcCount); {result is remain string}
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;


function ArrestStringEx(Source, SearchAfter, ArrestBefore: string;
  var ArrestStr: string): string;
var
  BufCount, SrcCount, SrcLen: integer;
  GoodData, Fin, flag: boolean;
  i, n: integer;
begin
  ArrestStr := ''; {result string}
  if Source = '' then begin
    Result := '';
    exit;
  end;

  try
    SrcLen   := Length(Source);
    GoodData := False;
    if SrcLen >= 2 then
      if Source[1] = SearchAfter then begin
        Source   := Copy(Source, 2, SrcLen - 1);
        SrcLen   := Length(Source);
        GoodData := True;
      end else begin
        n := Pos(SearchAfter, Source);
        if n > 0 then begin
          Source   := Copy(Source, n + 1, SrcLen - (n));
          SrcLen   := Length(Source);
          GoodData := True;
        end;
      end;
    if GoodData then begin
      n := Pos(ArrestBefore, Source);
      if n > 0 then begin
        ArrestStr := Copy(Source, 1, n - 1);
        Result    := Copy(Source, n + 1, SrcLen - n);
      end else begin
        Result := SearchAfter + Source;
      end;
    end else begin
      n := Pos(ArrestBefore, Source);
      if n > 0 then begin
        Result := Copy(Source, n + 1, SrcLen - (n));
        //SrcLen := Length(Source);
        //GoodData := TRUE;
      end else
        Result := '';
         {for i:=1 to SrcLen do begin
            if Source[i] = SearchAfter then begin
               Result := Copy (Source, i, SrcLen-i+1);
               flag := TRUE;
               break;
            end;
         end;}
    end;
  except
    ArrestStr := '';
    Result    := '';
  end;
end;

function SkipStr(Src: string; const Skips: array of char): string;
var
  I, Len, C: integer;
  NowSkip:   boolean;
begin
  Len := Length(Src);
  //   Count := sizeof(Skips) div sizeof (Char);

  for I := 1 to Len do begin
    NowSkip := False;
    for C := Low(Skips) to High(Skips) do
      if Src[I] = Skips[C] then begin
        NowSkip := True;
        break;
      end;
    if not NowSkip then
      break;
  end;

  Result := Copy(Src, I, Len - I + 1);

end;


function GetStrToCoords(Str: string): TRect;
var
  Temp: string;
begin

  Str := GetValidStr3(Str, Temp, [',', ' ']);
  Result.Left := Str_ToInt(Temp, 0);
  Str := GetValidStr3(Str, Temp, [',', ' ']);
  Result.Top := Str_ToInt(Temp, 0);
  Str := GetValidStr3(Str, Temp, [',', ' ']);
  Result.Right := Str_ToInt(Temp, 0);
  GetValidStr3(Str, Temp, [',', ' ']);
  Result.Bottom := Str_ToInt(Temp, 0);

end;

//숫자열을 만나면 리턴
function GetValidStrNoVal(Str: string; var Dest: string): string;
var
  i:    integer;
  flag: boolean;
begin
  Dest   := '';
  Result := '';
  flag   := False;
  for i := 1 to Length(Str) do begin
    if (byte(Str[i]) >= byte('0')) and (byte(Str[i]) <= byte('9')) or
      (Str[i] = '-') then begin
      Dest   := Copy(Str, 1, i - 1);
      Result := Copy(Str, i, Length(Str));
      flag   := True;
      break;
    end;
  end;
  if not flag then begin
    Dest   := Str;
    Result := '';
  end;
end;

function CombineDirFile(SrcDir, TargName: string): string;
begin
  if (SrcDir = '') or (TargName = '') then begin
    Result := SrcDir + TargName;
    exit;
  end;
  if SrcDir[Length(SrcDir)] = '\' then
    Result := SrcDir + TargName
  else
    Result := SrcDir + '\' + TargName;
end;

function CompareLStr(src, targ: string; compn: integer): boolean;
var
  i: integer;
begin
  Result := False;
  if compn <= 0 then
    exit;
  if Length(src) < compn then
    exit;
  if Length(targ) < compn then
    exit;
  Result := True;
  for i := 1 to compn do
    if UpCase(src[i]) <> UpCase(targ[i]) then begin
      Result := False;
      break;
    end;
end;

function CompareBackLStr(src, targ: string; compn: integer): boolean;
var
  i, slen, tlen: integer;
begin
  Result := False;
  if compn <= 0 then
    exit;
  if Length(src) < compn then
    exit;
  if Length(targ) < compn then
    exit;
  slen   := Length(src);
  tlen   := Length(targ);
  Result := True;
  for i := 0 to compn - 1 do
    if UpCase(src[slen - i]) <> UpCase(targ[tlen - i]) then begin
      Result := False;
      break;
    end;
end;


function IsEnglish(Ch: char): boolean;
begin
  Result := False;
  if ((Ch >= 'A') and (Ch <= 'Z')) or ((Ch >= 'a') and (Ch <= 'z')) then
    Result := True;
end;

function IsEngNumeric(Ch: char): boolean;
begin
  Result := False;
  if IsEnglish(Ch) or ((Ch >= '0') and (Ch <= '9')) then
    Result := True;
end;

function IsFloatNumeric(str: string): boolean;
begin
  if Trim(str) = '' then begin
    Result := False;
    exit;
  end;
  try
    StrToFloat(str);
    Result := True;
  except
    Result := False;
  end;
end;

procedure PCharSet(P: PChar; n: integer; ch: char);
var
  I: integer;
begin
  for I := 0 to n - 1 do
    (P + I)^ := ch;
end;

function ReplaceChar(src: string; srcchr, repchr: char): string;
var
  i, len: integer;
begin
  if src <> '' then begin
    len := Length(src);
    for i := 0 to len - 1 do
      if src[i] = srcchr then
        src[i] := repchr;
  end;
  Result := src;
end;


function IsUniformStr(src: string; ch: char): boolean;
var
  i, len: integer;
begin
  Result := True;
  if src <> '' then begin
    len := Length(src);
    for i := 0 to len - 1 do
      if src[i] = ch then begin
        Result := False;
        break;
      end;
  end;
end;


function CreateMask(Src: PChar; TargPos: integer): string;

  function IsNumber(chr: char): boolean;
  begin
    if (Chr >= '0') and (Chr <= '9') then
      Result := True
    else
      Result := False;
  end;

var
  intFlag, Loop: boolean;
  Cnt, IntCnt, SrcLen: integer;
  Ch, Ch2: char;
begin
  intFlag := False;
  Loop    := True;
  Cnt     := 0;
  IntCnt  := 0;
  SrcLen  := StrLen(Src);

  while Loop do begin
    Ch := PChar(longint(Src) + Cnt)^;
    case Ch of
      #0: begin
        Result := '';
        break;
      end;
      ' ': begin
      end;
      else begin

        if not intFlag then begin { Now Reading char }
          if IsNumber(Ch) then begin
            intFlag := True;
            Inc(IntCnt);
          end;
        end else begin { If, now reading integer }
          if not IsNumber(Ch) then begin  { XXE+3 }
            case UpCase(Ch) of
              'E': begin
                if (Cnt >= 1) and (Cnt + 2 < SrcLen) then begin
                  Ch := PChar(longint(Src) + Cnt - 1)^;
                  if IsNumber(Ch) then begin
                    Ch  := PChar(longint(Src) + Cnt + 1)^;
                    Ch2 := PChar(longint(Src) + Cnt + 2)^;
                    if not ((Ch = '+') and (IsNumber(Ch2))) then begin
                      intFlag := False;
                    end;
                  end;
                end;
              end;
              '+': begin
                if (Cnt >= 1) and (Cnt + 1 < SrcLen) then begin
                  Ch  := PChar(longint(Src) + Cnt - 1)^;
                  Ch2 := PChar(longint(Src) + Cnt + 1)^;
                  if not ((UpCase(Ch) = 'E') and (IsNumber(Ch2))) then begin
                    intFlag := False;
                  end;
                end;
              end;
              '.': begin
                if (Cnt >= 1) and (Cnt + 1 < SrcLen) then begin
                  Ch  := PChar(longint(Src) + Cnt - 1)^;
                  Ch2 := PChar(longint(Src) + Cnt + 1)^;
                  if not ((IsNumber(Ch)) and (IsNumber(Ch2))) then begin
                    intFlag := False;
                  end;
                end;
              end;

              else
                intFlag := False;
            end;
          end;
        end; {end of case else}
      end;   {end of Case}
    end;
    if (IntFlag) and (Cnt >= TargPos) then begin
      Result := '%' + Format('%d', [IntCnt]);
      exit;
    end;
    Inc(Cnt);
  end;
end;

function GetValueFromMask(Src: PChar; Mask: string): string;

  function Positon(str: string): integer;
  var
    str2: string;
  begin
    str2   := Copy(str, 2, Length(str) - 1);
    Result := StrToIntDef(str2, 0);
    if Result <= 0 then
      Result := 1;
  end;

  function IsNumber(ch: char): boolean;
  begin
    case ch of
      '0'..'9': Result := True;
      else
        Result := False;
    end;
  end;

var
  IntFlag, Loop, Sign: boolean;
  Buf:     Str256;
  BufCount, Pos, LocCount, TargLoc, SrcLen: integer;
  Ch, Ch2: char;
begin
  SrcLen   := StrLen(Src);
  LocCount := 0;
  BufCount := 0;
  Pos      := 0;
  IntFlag  := False;
  Loop     := True;
  Sign     := False;

  if Mask = '' then
    Mask := '%1';
  TargLoc := Positon(Mask);

  while Loop do begin
    if Pos >= SrcLen then
      break;
    Ch := PChar(Src + Pos)^;
    if not IntFlag then begin {now reading chars}
      if LocCount < TargLoc then begin
        if IsNumber(Ch) then begin
          IntFlag  := True;
          BufCount := 0;
          Inc(LocCount);
        end else begin
          if not Sign then begin {default '+'}
            if Ch = '-' then
              Sign := True;
          end else begin
            if Ch <> ' ' then
              Sign := False;
          end;
        end;
      end else begin
        break;
      end;
    end;
    if IntFlag then begin {now reading numbers}
      Buf[BufCount] := Ch;
      Inc(BufCount);
      if not IsNumber(Ch) then begin
        case Ch of
          'E', 'e': begin
            if (Pos >= 1) and (Pos + 2 < SrcLen) then begin
              Ch := PChar(Src + Pos - 1)^;
              if IsNumber(Ch) then begin
                Ch  := PChar(Src + Pos + 1)^;
                Ch2 := PChar(Src + Pos + 2)^;
                if not ((Ch = '+') or (Ch = '-') and (IsNumber(Ch2))) then begin
                  Dec(BufCount);
                  IntFlag := False;
                end;
              end;
            end;
          end;
          '+', '-': begin
            if (Pos >= 1) and (Pos + 1 < SrcLen) then begin
              Ch  := PChar(Src + Pos - 1)^;
              Ch2 := PChar(Src + Pos + 1)^;
              if not ((UpCase(Ch) = 'E') and (IsNumber(Ch2))) then begin
                Dec(BufCount);
                IntFlag := False;
              end;
            end;
          end;
          '.': begin
            if (Pos >= 1) and (Pos + 1 < SrcLen) then begin
              Ch  := PChar(Src + Pos - 1)^;
              Ch2 := PChar(Src + Pos + 1)^;
              if not ((IsNumber(Ch)) and (IsNumber(Ch2))) then begin
                Dec(BufCount);
                IntFlag := False;
              end;
            end;
          end;
          else begin
            IntFlag := False;
            Dec(BufCount);
          end;
        end;
      end;
    end;
    Inc(Pos);
  end;
  if LocCount = TargLoc then begin
    Buf[BufCount] := #0;
    if Sign then
      Result := '-' + StrPas(Buf)
    else
      Result := StrPas(Buf);
  end else
    Result := '';
end;

procedure GetDirList(path: string; fllist: TStringList);
var
  SearchRec: TSearchRec;
begin
  if FindFirst(path, faAnyFile, SearchRec) = 0 then begin
    fllist.AddObject(SearchRec.Name, TObject(SearchRec.Time));
    while True do begin
      if FindNext(SearchRec) = 0 then begin
        fllist.AddObject(SearchRec.Name, TObject(SearchRec.Time));
      end else begin
        SysUtils.FindClose(SearchRec);
        break;
      end;
    end;
  end;
end;

function GetFileDate(filename: string): integer; //DOS format file date..
var
  SearchRec: TSearchRec;
begin
  Result := 0;
  if FindFirst(filename, faAnyFile, SearchRec) = 0 then begin
    Result := SearchRec.Time;
    SysUtils.FindClose(SearchRec);
  end;
end;




procedure ShlStr(Source: PChar; Count: integer);
var
  I, Len: integer;
begin
  Len := StrLen(Source);
  while (Count > 0) do begin
    for I := 0 to Len - 2 do
      Source[I] := Source[I + 1];
    Source[Len - 1] := #0;

    Dec(Count);
  end;
end;

procedure ShrStr(Source: PChar; Count: integer);
var
  I, Len: integer;
begin
  Len := StrLen(Source);
  while (Count > 0) do begin
    for I := Len - 1 downto 0 do
      Source[I + 1] := Source[I];
    Source[Len + 1] := #0;

    Dec(Count);
  end;
end;

function LRect(l, t, r, b: longint): TLRect;
begin
  Result.Left   := l;
  Result.Top    := t;
  Result.Right  := r;
  Result.Bottom := b;
end;

procedure MemPCopy(Dest: PChar; Src: string);
var
  i: integer;
begin
  for i := 0 to Length(Src) - 1 do
    Dest[i] := Src[i + 1];
end;

procedure MemCpy(Dest, Src: PChar; Count: longint);
var
  I: longint;
begin
  for I := 0 to Count - 1 do begin
    PChar(longint(Dest) + I)^ := PChar(longint(Src) + I)^;
  end;
end;

procedure memcpy2(TargAddr, SrcAddr: longint; Count: integer);
var
  I: integer;
begin
  for I := 0 to Count - 1 do
    PChar(TargAddr + I)^ := PChar(SrcAddr + I)^;
end;

procedure memset(buffer: PChar; fillchar: char; Count: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    buffer[i] := fillchar;
end;

procedure Str256PCopy(Dest: PChar; const Src: string);
begin
  StrPLCopy(Dest, Src, 255);
end;

function _StrPas(dest: PChar): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to length(dest) - 1 do
    if dest[i] <> chr(0) then
      Result := Result + dest[i]
    else
      break;
end;

function Str_PCopy(dest: PChar; src: string): integer;
var
  len, i: integer;
begin
  len := Length(src);
  for i := 1 to len do
    dest[i - 1] := src[i];
  dest[len] := #0;
  Result := len;
end;

function Str_PCopyEx(dest: PChar; const src: string; buflen: longint): integer;
var
  len, i: integer;
begin
  len := _MIN(Length(src), buflen);
  for i := 1 to len do
    dest[i - 1] := src[i];
  dest[len] := #0;
  Result := len;
end;

function Str_Catch(src, dest: string; len: integer): string; //Result is rests..
begin

end;

function Trim_R(const str: string): string;
var
  I, Len, tr: integer;
begin
  tr  := 0;
  Len := Length(str);
  for I := Len downto 1 do
    if str[I] = ' ' then
      Inc(tr)
    else
      break;
  Result := Copy(str, 1, Len - tr);
end;

function IsEqualFont(SrcFont, TarFont: TFont): boolean;
begin
  Result := True;
  if SrcFont.Name <> TarFont.Name then
    Result := False;
  if SrcFont.Color <> TarFont.Color then
    Result := False;
  if SrcFont.Style <> TarFont.Style then
    Result := False;
  if SrcFont.Size <> TarFont.Size then
    Result := False;
end;


function CutHalfCode(Str: string): string;
var
  pos, Len: integer;
begin

  Result := '';
  pos    := 1;
  Len    := Length(Str);

  while True do begin

    if pos > Len then
      break;

    if (Str[pos] > #127) then begin

      if ((pos + 1) <= Len) and (Str[pos + 1] > #127) then begin
        Result := Result + Str[pos] + Str[pos + 1];
        Inc(pos);
      end;

    end else
      Result := Result + Str[pos];

    Inc(pos);

  end;
end;


function ConvertToShortName(Canvas: TCanvas; Source: string;
  WantWidth: integer): string;
var
  I, Len: integer;
  Str:    string;
begin
  if Length(Source) > 3 then
    if Canvas.TextWidth(Source) > WantWidth then begin

      Len := Length(Source);
      for I := 1 to Len do begin

        Str := Copy(Source, 1, (Len - I));
        Str := Str + '..';

        if Canvas.TextWidth(Str) < (WantWidth - 4) then begin
          Result := CutHalfCode(Str);
          exit;
        end;

      end;

      Result := CutHalfCode(Copy(Source, 1, 2)) + '..';
      exit;

    end;

  Result := Source;

end;


function DuplicateBitmap(bitmap: TBitmap): HBitmap;
var
  hbmpOldSrc, hbmpOldDest, hbmpNew: HBitmap;
  hdcSrc, hdcDest: HDC;

begin
  hdcSrc  := CreateCompatibleDC(0);
  hdcDest := CreateCompatibleDC(hdcSrc);

  hbmpOldSrc := SelectObject(hdcSrc, bitmap.Handle);

  hbmpNew := CreateCompatibleBitmap(hdcSrc, bitmap.Width, bitmap.Height);

  hbmpOldDest := SelectObject(hdcDest, hbmpNew);

  BitBlt(hdcDest, 0, 0, bitmap.Width, bitmap.Height, hdcSrc, 0, 0,
    SRCCOPY);

  SelectObject(hdcDest, hbmpOldDest);
  SelectObject(hdcSrc, hbmpOldSrc);

  DeleteDC(hdcDest);
  DeleteDC(hdcSrc);

  Result := hbmpNew;
end;


procedure SpliteBitmap(DC: HDC; X, Y: integer; bitmap: TBitmap; transcolor: TColor);
var
  hdcMixBuffer, hdcBackMask, hdcForeMask, hdcCopy: HDC;
  hOld, hbmCopy, hbmMixBuffer, hbmBackMask, hbmForeMask: HBitmap;
  oldColor: TColor;
begin

  {UnrealizeObject (DC);}
(*   SelectPalette (DC, bitmap.Palette, FALSE);
   RealizePalette (DC);
  *)

  hbmCopy := DuplicateBitmap(bitmap);
  hdcCopy := CreateCompatibleDC(DC);
  hOld    := SelectObject(hdcCopy, hbmCopy);

  hdcBackMask  := CreateCompatibleDC(DC);
  hdcForeMask  := CreateCompatibleDC(DC);
  hdcMixBuffer := CreateCompatibleDC(DC);

  hbmBackMask  := CreateBitmap(bitmap.Width, bitmap.Height, 1, 1, nil);
  hbmForeMask  := CreateBitmap(bitmap.Width, bitmap.Height, 1, 1, nil);
  hbmMixBuffer := CreateCompatibleBitmap(DC, bitmap.Width, bitmap.Height);

  SelectObject(hdcBackMask, hbmBackMask);
  SelectObject(hdcForeMask, hbmForeMask);
  SelectObject(hdcMixBuffer, hbmMixBuffer);

  oldColor := SetBkColor(hdcCopy, transcolor); //clWhite);

  BitBlt(hdcForeMask, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0, SRCCOPY);

  SetBkColor(hdcCopy, oldColor);

  BitBlt(hdcBackMask, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0, NOTSRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, DC, X, Y, SRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0, SRCAND);

  BitBlt(hdcCopy, 0, 0, bitmap.Width, bitmap.Height, hdcBackMask, 0, 0, SRCAND);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0, SRCPAINT);

  BitBlt(DC, X, Y, bitmap.Width, bitmap.Height, hdcMixBuffer, 0, 0, SRCCOPY);

  {DeleteObject (hbmCopy);}
  DeleteObject(SelectObject(hdcCopy, hOld));
  DeleteObject(SelectObject(hdcForeMask, hOld));
  DeleteObject(SelectObject(hdcBackMask, hOld));
  DeleteObject(SelectObject(hdcMixBuffer, hOld));

  DeleteDC(hdcCopy);
  DeleteDC(hdcForeMask);
  DeleteDC(hdcBackMask);
  DeleteDC(hdcMixBuffer);

end;

function TimeIsOut(dtime: TDateTime; taghour, tagmin: integer): boolean;
var
  ayear, amon, aday, ahour, amin, asec, amsec: word;
  targdate: TDateTime;
begin
  DecodeDate(dtime, ayear, amon, aday);
  DecodeTime(dtime, ahour, amin, asec, amsec);

  amin := amin + tagmin;
  if amin >= 60 then begin
    ahour := ahour + 1;
    amin  := 0;
  end;
  ahour := ahour + taghour;
  while ahour >= 24 do begin
    aday  := aday + 1;
    ahour := ahour - 24;
  end;
  while aday > MonthDays[False][amon] do begin
    aday := aday - MonthDays[False][amon];
    amon := amon + 1;
  end;
  if amon > 12 then begin
    ayear := ayear + 1;
    amon  := 1;
  end;

  targdate := EncodeDate(ayear, amon, aday) + EncodeTime(ahour, amin, asec, amsec);

  if Now >= targdate then
    Result := True
  else
    Result := False;
end;

function TagCount(Source: string; tag: char): integer;
var
  i, tcount: integer;
begin
  tcount := 0;
  for i := 1 to Length(Source) do
    if Source[i] = tag then
      Inc(tcount);
  Result := tcount;
end;

{ "xxxxxx" => xxxxxx }
function TakeOffTag(src: string; tag: char; var rstr: string): string;
var
  i, n2: integer;
begin
  n2     := Pos(tag, Copy(src, 2, Length(src)));
  rstr   := Copy(src, 2, n2 - 1);
  Result := Copy(src, n2 + 2, length(src) - n2);
end;

function CatchString(Source: string; cap: char; var catched: string): string;
var
  n: integer;
begin
  Result  := '';
  catched := '';
  if Source = '' then
    exit;
  if Length(Source) < 2 then begin
    Result := Source;
    exit;
  end;
  if Source[1] = cap then begin
    if Source[2] = cap then   //##abc#
      Source := Copy(Source, 2, Length(Source));
    if TagCount(Source, cap) >= 2 then begin
      Result := TakeOffTag(Source, cap, catched);
    end else
      Result := Source;
  end else begin
    if TagCount(Source, cap) >= 2 then begin
      n      := Pos(cap, Source);
      Source := Copy(Source, n, Length(Source));
      Result := TakeOffTag(Source, cap, catched);
    end else
      Result := Source;
  end;
end;

 { GetValidStr3와 달리 식별자가 연속으로 나올경우 처리 안됨 }
 { 식별자가 없을 경우, nil 리턴.. }
function DivString(Source: string; cap: char; var sel: string): string;
var
  n: integer;
begin
  if Source = '' then begin
    sel    := '';
    Result := '';
    exit;
  end;
  n := Pos(cap, Source);
  if n > 0 then begin
    sel    := Copy(Source, 1, n - 1);
    Result := Copy(Source, n + 1, Length(Source));
  end else begin
    sel    := Source;
    Result := '';
  end;
end;

function DivTailString(Source: string; cap: char; var sel: string): string;
var
  i, n: integer;
begin
  if Source = '' then begin
    sel    := '';
    Result := '';
    exit;
  end;
  n := 0;
  for i := Length(Source) downto 1 do
    if Source[i] = cap then begin
      n := i;
      break;
    end;
  if n > 0 then begin
    sel    := Copy(Source, n + 1, Length(Source));
    Result := Copy(Source, 1, n - 1);
  end else begin
    sel    := '';
    Result := Source;
  end;
end;


function SPos(substr, str: string): integer;
var
  i, j, len, slen: integer;
  flag: boolean;
begin
  Result := -1;
  len    := Length(str);
  slen   := Length(substr);
  for i := 0 to len - slen do begin
    flag := True;
    for j := 1 to slen do begin
      if byte(str[i + j]) >= $B0 then begin
        if (j < slen) and (i + j < len) then begin
          if substr[j] <> str[i + j] then begin
            flag := False;
            break;
          end;
          if substr[j + 1] <> str[i + j + 1] then begin
            flag := False;
            break;
          end;
        end else
          flag := False;
      end else if substr[j] <> str[i + j] then begin
        flag := False;
        break;
      end;
    end;
    if flag then begin
      Result := i + 1;
      break;
    end;
  end;
end;

function NumCopy(str: string): integer;
var
  i:    integer;
  Data: string;
begin
  Data := '';
  for i := 1 to Length(str) do begin
    if (word('0') <= word(str[i])) and (word('9') >= word(str[i])) then begin
      Data := Data + str[i];
    end else
      break;
  end;
  Result := Str_ToInt(Data, 0);
end;

function GetMonDay: string;
var
  year, mon, day: word;
  str: string;
begin
  DecodeDate(Date, year, mon, day);
  str := IntToStr(year);
  if mon < 10 then
    str := str + '0' + IntToStr(mon)
  else
    str := IntToStr(mon);
  if day < 10 then
    str := str + '0' + IntToStr(day)
  else
    str := IntToStr(day);
  Result := str;
end;

function BoolToStr(boo: boolean): string;
begin
  if boo then
    Result := 'TRUE'
  else
    Result := 'FALSE';
end;

function BoolToInt(boo: boolean): integer;
begin
  if boo then
    Result := 1
  else
    Result := 0;
end;

function TimeStr(atime: TDateTime): string;
var
  hour, min, sec, msec: word;
begin
  DecodeTime(atime, hour, min, sec, msec);
  Result := IntToStr(hour) + '-' + IntToStr(min) + '-' + IntToStr(sec) +
    '-' + IntToStr(msec);
end;


function _MIN(n1, n2: integer): integer;
begin
  if n1 < n2 then
    Result := n1
  else
    Result := n2;
end;

function _MAX(n1, n2: integer): integer;
begin
  if n1 > n2 then
    Result := n1
  else
    Result := n2;
end;


 // 일반 스트링을 쿼리에 적합하게 변경 : PDS
 // ' = \A , " = \B , `= \C , /=\D , :=\E , ,=\F , %=\G , \=\H
function StrToSQLSafe(str: string): string;
var
  len:  integer;
  i:    integer;
  dest: string;
begin
  len  := Length(str);
  dest := '';
  for i := 1 to len do begin
    case str[i] of
      char(''''): dest := dest + '\A';
      char('"'): dest  := dest + '\B';
      char('`'): dest  := dest + '\C';
      char('/'): dest  := dest + '\D';
      char(':'): dest  := dest + '\E';
      char(','): dest  := dest + '\F';
      char('%'): dest  := dest + '\G';
      char('\'): dest  := dest + '\H';
      char($0D): dest  := dest + '\R';
      char($0A): dest  := dest + '\N';
      else
        dest := dest + str[i];
    end;
  end;

  Result := dest;
end;

// 쿼리스트링을 일반 스트링으로 변경 : PDS
function SQLSafeToStr(sqlstr: string): string;
var
  len:  integer;
  i:    integer;
  dest: string;
begin
  len := Length(sqlstr);
  i   := 1;
  while i <= len do begin
    if sqlstr[i] = '\' then begin
      Inc(i);
      case sqlstr[i] of
        char('A'): dest := dest + '''';
        char('B'): dest := dest + '"';
        char('C'): dest := dest + '`';
        char('D'): dest := dest + '/';
        char('E'): dest := dest + ':';
        char('F'): dest := dest + ',';
        char('G'): dest := dest + '%';
        char('H'): dest := dest + '\';
        char('R'): dest := dest + char($0D);
        char('N'): dest := dest + char($0A);
      end;
    end else begin
      dest := dest + sqlstr[i];
    end;

    Inc(i);
  end;

  Result := dest;
end;

// 개행문자등을 삭제한 스트링으로 변경
function StrToVisibleOnly(str: string): string;
var
  len:  integer;
  i:    integer;
  dest: string;
begin
  len := Length(str);
  i   := 1;
  while i <= len do begin
    if Ord(str[i]) < 128 then begin
      if Ord(str[i]) >= 20 then
        dest := dest + str[i];
    end else begin
      dest := dest + str[i];
      Inc(i);
      dest := dest + str[i];
    end;

    Inc(i);
  end;

  Result := dest;
end;

// 개행문자등을 삭제한 스트링으로 변경
function StrToHint(str: string): string;
var
  len:  integer;
  i:    integer;
  newline: integer;
  dest: string;
begin
  len := Length(str);
  i   := 1;
  newline := 0;
  while i <= len do begin
    if Ord(str[i]) < 128 then begin
      if Ord(str[i]) >= 20 then
        dest := dest + str[i]
      else begin
        if Ord(str[i]) = 10 then begin
          dest := dest + '\';
        end;

        newline := -1;
      end;
    end else begin
      dest := dest + str[i];
      Inc(i);
      dest := dest + str[i];
    end;

    Inc(i);
    Inc(newline);

    if (newline = 20) then begin
      dest    := dest + '\';
      newline := 0;
    end;
  end;

  Result := dest;
end;

end.
