unit cliUtil;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, WIL, {Grobal2,} StdCtrls, DirectX, DIB, HUtil32,
  wmutil; //, bmputil;


const
  MAXGRADE = 64;
  DIVUNIT  = 4;


type
  TColorEffect = (ceNone, ceGrayScale, ceBright, ceBlack, ceWhite,
    ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);

  TNearestIndexHeader = record
    Title: string[30];
    IndexCount: integer;
    desc: array[0..10] of byte;
  end;

function HasMMX: boolean;
procedure BuildColorLevels(ctable: TRGBQuads);
procedure BuildNearestIndex(ctable: TRGBQuads);
procedure SaveNearestIndex(flname: string);
function LoadNearestIndex(flname: string): boolean;
procedure DrawFog(ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
procedure DrawFog2(ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
procedure MakeDark(ssuf: TDirectDrawSurface; darklevel: integer);
procedure FogCopy(PSource: Pbyte; ssx, ssy, swidth, sheight: integer;
  PDest: Pbyte; ddx, ddy, dwidth, dheight, maxfog: integer);
procedure DrawBlend(dsuf: TDirectDrawSurface; x, y: integer;
  ssuf: TDirectDrawSurface; blendmode: integer);
procedure DrawBlendEx(dsuf: TDirectDrawSurface; x, y: integer;
  ssuf: TDirectDrawSurface; ssufleft, ssuftop, ssufwidth, ssufheight,
  blendmode: integer);
procedure SpriteCopy(DestX, DestY: integer; SourX, SourY: integer;
  Size: TPoint; Sour, Dest: TDirectDrawSurface);
procedure MMXBlt(ssuf, dsuf: TDirectDrawSurface);
procedure DrawEffect(x, y, Width, Height: integer; ssuf: TDirectDrawSurface;
  eff: TColorEffect);

var
  DarkLevel: integer;


implementation

var
  RgbIndexTable:    array[0..MAXGRADE - 1, 0..MAXGRADE - 1, 0..MAXGRADE - 1] of byte;
  Color256Mix:      array[0..255, 0..255] of byte;
  Color256Anti:     array[0..255, 0..255] of byte;
  HeavyDarkColorLevel: array[0..255, 0..255] of byte;
  LightDarkColorLevel: array[0..255, 0..255] of byte;
  DengunColorLevel: array[0..255, 0..255] of byte;
  BrightColorLevel: array[0..255] of byte;
  GrayScaleLevel:   array[0..255] of byte;
  RedishColorLevel: array[0..255] of byte;
  BlackColorLevel:  array[0..255] of byte;
  WhiteColorLevel:  array[0..255] of byte;
  GreenColorLevel:  array[0..255] of byte;
  YellowColorLevel: array[0..255] of byte;
  BlueColorLevel:   array[0..255] of byte;
  FuchsiaColorLevel: array[0..255] of byte;


function HasMMX: boolean;
var
  n: byte;
begin
  asm
           MOV     EAX, 1
           DB      $0F,$A2               /// CPUID
           TEST    EDX, 00800000H
           MOV     n, 1
           JNZ     @@Found
           MOV     n, 0
           @@Found:
  end;
  if n = 1 then
    Result := True
  else
    Result := False;
end;

procedure BuildNearestIndex(ctable: TRGBQuads);
var
  r, g, b, rr, gg, bb, color, MinDif, ColDif: integer;
  MatchColor: byte;
  pal0, pal1, pal2: TRGBQuad;

  procedure BuildMix;
  var
    i, j, n: integer;
  begin
    for i := 0 to 255 do begin
      pal0 := ctable[i];
      for j := 0 to 255 do begin
        pal1   := ctable[j];
        pal1.rgbRed := pal0.rgbRed div 2 + pal1.rgbRed div 2;
        pal1.rgbGreen := pal0.rgbGreen div 2 + pal1.rgbGreen div 2;
        pal1.rgbBlue := pal0.rgbBlue div 2 + pal1.rgbBlue div 2;
        MinDif := 768;
        MatchColor := 0;
        for n := 0 to 255 do begin
          pal2   := ctable[n];
          ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
            Abs(pal2.rgbGreen - pal1.rgbGreen) +
            Abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then begin
            MinDif     := ColDif;
            MatchColor := n;
          end;
        end;
        Color256Mix[i, j] := MatchColor;
      end;
    end;
  end;

  procedure BuildAnti;
  var
    i, j, n, ever: integer;
  begin
    for i := 0 to 255 do begin
      pal0 := ctable[i];
      for j := 0 to 255 do begin
        pal1   := ctable[j];
        ever   := _MAX(pal0.rgbRed, pal0.rgbGreen);
        ever   := _MAX(ever, pal0.rgbBlue);
        //            pal1.rgbRed := _MIN(255, Round (pal0.rgbRed  + (255-ever)/255 * pal1.rgbRed));
        //            pal1.rgbGreen := _MIN(255, Round (pal0.rgbGreen  + (255-ever)/255 * pal1.rgbGreen));
        //         pal1.rgbBlue := _MIN(255, Round (pal0.rgbBlue  + (255-ever)/255 * pal1.rgbBlue));
        pal1.rgbRed := _MIN(255, Round(pal0.rgbRed + (255 - pal0.rgbRed) /
          255 * pal1.rgbRed));
        pal1.rgbGreen := _MIN(255, Round(pal0.rgbGreen +
          (255 - pal0.rgbGreen) / 255 * pal1.rgbGreen));
        pal1.rgbBlue := _MIN(255, Round(pal0.rgbBlue +
          (255 - pal0.rgbBlue) / 255 * pal1.rgbBlue));
        MinDif := 768;
        MatchColor := 0;
        for n := 0 to 255 do begin
          pal2   := ctable[n];
          ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
            Abs(pal2.rgbGreen - pal1.rgbGreen) +
            Abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then begin
            MinDif     := ColDif;
            MatchColor := n;
          end;
        end;
        Color256Anti[i, j] := MatchColor;
      end;
    end;
  end;

  procedure BuildColorLevels;
  var
    n, i, j, rr, gg, bb: integer;
  begin
    for n := 0 to 30 do begin
      for i := 0 to 255 do begin
        pal1   := ctable[i];
        rr     := _MIN(Round(pal1.rgbRed * (n + 1) / 31) - 5, 255);
        //(n + (n-1)*3) / 121);
        gg     := _MIN(Round(pal1.rgbGreen * (n + 1) / 31) - 5, 255);
        //(n + (n-1)*3) / 121);
        bb     := _MIN(Round(pal1.rgbBlue * (n + 1) / 31) - 5, 255);
        //(n + (n-1)*3) / 121);
        pal1.rgbRed := _MAX(0, rr);
        pal1.rgbGreen := _MAX(0, gg);
        pal1.rgbBlue := _MAX(0, bb);
        MinDif := 768;
        MatchColor := 0;
        for j := 0 to 255 do begin
          pal2   := ctable[j];
          ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
            Abs(pal2.rgbGreen - pal1.rgbGreen) +
            Abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then begin
            MinDif     := ColDif;
            MatchColor := j;
          end;
        end;
        HeavyDarkColorLevel[n, i] := MatchColor;
      end;
    end;
    for n := 0 to 30 do begin
      for i := 0 to 255 do begin
        pal1   := ctable[i];
        pal1.rgbRed := _MIN(Round(pal1.rgbRed * (n * 3 + 47) / 140), 255);
        pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * (n * 3 + 47) / 140), 255);
        pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * (n * 3 + 47) / 140), 255);
        MinDif := 768;
        MatchColor := 0;
        for j := 0 to 255 do begin
          pal2   := ctable[j];
          ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
            Abs(pal2.rgbGreen - pal1.rgbGreen) +
            Abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then begin
            MinDif     := ColDif;
            MatchColor := j;
          end;
        end;
        LightDarkColorLevel[n, i] := MatchColor;
      end;
    end;
    for n := 0 to 30 do begin
      for i := 0 to 255 do begin
        pal1   := ctable[i];
        pal1.rgbRed := _MIN(Round(pal1.rgbRed * (n * 3 + 120) / 214), 255);
        pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * (n * 3 + 120) / 214), 255);
        pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * (n * 3 + 120) / 214), 255);
        MinDif := 768;
        MatchColor := 0;
        for j := 0 to 255 do begin
          pal2   := ctable[j];
          ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
            Abs(pal2.rgbGreen - pal1.rgbGreen) +
            Abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then begin
            MinDif     := ColDif;
            MatchColor := j;
          end;
        end;
        DengunColorLevel[n, i] := MatchColor;
      end;
    end;

      {for i:=0 to 255 do begin
         HeavyDarkColorLevel[0, i] := HeavyDarkColorLevel[1, i];
         LightDarkColorLevel[0, i] := LightDarkColorLevel[1, i];
         DengunColorLevel[0, i] := DengunColorLevel[1, i];
      end;}
    for n := 31 to 255 do
      for i := 0 to 255 do begin
        HeavyDarkColorLevel[n, i] := HeavyDarkColorLevel[30, i];
        LightDarkColorLevel[n, i] := LightDarkColorLevel[30, i];
        DengunColorLevel[n, i]    := DengunColorLevel[30, i];
      end;

  end;

begin
  BuildMix;
  BuildAnti;
  BuildColorLevels;
end;

procedure BuildColorLevels(ctable: TRGBQuads);
var
  n, i, j, MinDif, ColDif: integer;
  pal1, pal2: TRGBQuad;
  MatchColor: byte;
begin
  BrightColorLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    pal1.rgbRed := _MIN(Round(pal1.rgbRed * 1.3), 255);
    pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * 1.3), 255);
    pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * 1.3), 255);
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    BrightColorLevel[i] := MatchColor;
  end;
  GrayScaleLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    n      := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := n;   //Round(pal1.rgbRed * (n*3+25) / 118);
    pal1.rgbGreen := n; //Round(pal1.rgbGreen * (n*3+25) / 118);
    pal1.rgbBlue := n;  //Round(pal1.rgbBlue * (n*3+25) / 118);
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    GrayScaleLevel[i] := MatchColor;
  end;
  BlackColorLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    n      := Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3 * 0.6);
    pal1.rgbRed := n;   //_MAX(8, Round(pal1.rgbRed * 0.7));
    pal1.rgbGreen := n; //_MAX(8, Round(pal1.rgbGreen * 0.7));
    pal1.rgbBlue := n;  //_MAX(8, Round(pal1.rgbBlue * 0.7));
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    BlackColorLevel[i] := MatchColor;
  end;
  WhiteColorLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    n      := _MIN(Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3 * 1.6), 255);
    pal1.rgbRed := n;   //_MAX(8, Round(pal1.rgbRed * 0.7));
    pal1.rgbGreen := n; //_MAX(8, Round(pal1.rgbGreen * 0.7));
    pal1.rgbBlue := n;  //_MAX(8, Round(pal1.rgbBlue * 0.7));
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    WhiteColorLevel[i] := MatchColor;
  end;
  RedishColorLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    n      := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := n;
    pal1.rgbGreen := 0;
    pal1.rgbBlue := 0;
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    RedishColorLevel[i] := MatchColor;
  end;
  GreenColorLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    //n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 5;
    //pal1.rgbRed := 0;//_MIN(Round(n / 2), 255);
    //pal1.rgbGreen := _MIN(Round(n), 255);
    //pal1.rgbBlue := 0;//_MIN(Round(n / 2), 255);
    n      := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := 0;
    pal1.rgbGreen := n;
    pal1.rgbBlue := 0;
    //pal1.rgbRed := _MIN(Round (pal1.rgbRed / 3), 255);
    //pal1.rgbGreen := _MIN(Round (pal1.rgbGreen * 1.5), 255);
    //pal1.rgbBlue := _MIN(Round (pal1.rgbBlue / 3), 255);
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    GreenColorLevel[i] := MatchColor;
  end;
  YellowColorLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    n      := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := n;
    pal1.rgbGreen := n;
    pal1.rgbBlue := 0;
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    YellowColorLevel[i] := MatchColor;
  end;
  BlueColorLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    //n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 5;
    n      := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := 0;   //_MIN(Round(n*1.3), 255);
    pal1.rgbGreen := 0; //_MIN(Round(n), 255);
    pal1.rgbBlue := n;  //_MIN(Round(n*1.3), 255);
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    BlueColorLevel[i] := MatchColor;
  end;
  FuchsiaColorLevel[0] := 0;
  for i := 1 to 255 do begin
    pal1   := ctable[i];
    n      := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := n;
    pal1.rgbGreen := 0;
    pal1.rgbBlue := n;
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do begin
      pal2   := ctable[j];
      ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
        Abs(pal2.rgbGreen - pal1.rgbGreen) + Abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then begin
        MinDif     := ColDif;
        MatchColor := j;
      end;
    end;
    FuchsiaColorLevel[i] := MatchColor;
  end;
end;


procedure SaveNearestIndex(flname: string);
var
  nih:     TNearestIndexHeader;
  fhandle: integer;
begin
  nih.Title      := 'WEMADE Entertainment Inc.';
  nih.IndexCount := Sizeof(Color256Mix);
  if FileExists(flname) then begin
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone);
  end else
    fhandle := FileCreate(flname);
  if fhandle > 0 then begin
    FileWrite(fhandle, nih, sizeof(TNearestIndexHeader));
    FileWrite(fhandle, Color256Mix, sizeof(Color256Mix));
    FileWrite(fhandle, Color256Anti, sizeof(Color256Anti));
    FileWrite(fhandle, HeavyDarkColorLevel, sizeof(HeavyDarkColorLevel));
    FileWrite(fhandle, LightDarkColorLevel, sizeof(LightDarkColorLevel));
    FileWrite(fhandle, DengunColorLevel, sizeof(DengunColorLevel));
    FileClose(fhandle);
  end;
end;

function LoadNearestIndex(flname: string): boolean;
var
  nih: TNearestIndexHeader;
  fhandle, rsize: integer;
begin
  Result := False;
  if FileExists(flname) then begin
    fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileRead(fhandle, nih, sizeof(TNearestIndexHeader));
      if nih.IndexCount = Sizeof(Color256Mix) then begin
        Result := True;
        rsize  := 256 * 256;
        if rsize <> FileRead(fhandle, Color256Mix, sizeof(Color256Mix)) then
          Result := False;
        if rsize <> FileRead(fhandle, Color256Anti, sizeof(Color256Anti)) then
          Result := False;
        if rsize <> FileRead(fhandle, HeavyDarkColorLevel,
          sizeof(HeavyDarkColorLevel)) then
          Result := False;
        if rsize <> FileRead(fhandle, LightDarkColorLevel,
          sizeof(LightDarkColorLevel)) then
          Result := False;
        if rsize <> FileRead(fhandle, DengunColorLevel,
          sizeof(DengunColorLevel)) then
          Result := False;
      end;
      FileClose(fhandle);
    end;
  end;
end;

procedure FogCopy(PSource: Pbyte; ssx, ssy, swidth, sheight: integer;
  PDest: Pbyte; ddx, ddy, dwidth, dheight, maxfog: integer);
var
  i, j, n, k, row, srclen, scount, si, di, srcheight, spitch, dpitch: integer;
  sptr, dptr: PByte;
begin
  if (PSource = nil) or (pDest = nil) then
    exit;
  spitch := swidth;
  dpitch := dwidth;
  if ddx < 0 then begin
    ssx    := ssx - ddx;
    swidth := swidth + ddx;
    //dwidth := dwidth + ddx;
    ddx    := 0;
  end;
  if ddy < 0 then begin
    ssy     := ssy - ddy;
    sheight := sheight + ddy;
    //dheight := dheight + ddy;
    ddy     := 0;
  end;
  //if ssx+swidth > dwidth then swidth := dwidth - ssx;
  //if ssy+sheight > dheight then sheight := dheight - ssy;
  srclen    := _MIN(swidth, dwidth - ddx);
  srcheight := _MIN(sheight, dheight - ddy);
  if (srclen <= 0) or (srcheight <= 0) then
    exit;

  asm
           MOV     row, 0
           @@NextRow:
           MOV     EAX, row
           CMP     EAX, srcheight
           JAE     @@Finish

           MOV     ESI, psource
           MOV     EAX, ssy
           ADD     EAX, row
           MOV     EBX, spitch
           IMUL    EAX, EBX
           ADD     EAX, ssx
           ADD     ESI, EAX          //sptr

           MOV     EDI, pdest
           MOV     EAX, ddy
           ADD     EAX, row
           MOV     EBX, dpitch
           IMUL    EAX, EBX
           ADD     EAX, ddx
           ADD     EDI, EAX          //dptr

           MOV     EBX, srclen
           @@FogNext:
           CMP     EBX, 0
           JBE     @@FinOne
           CMP     EBX, 8
           JB      @@FinOne   //@@EageNext

           db $0F,$6F,$06                /// movq  mm0, [esi]
           DB      $0F,$6F,$0F           /// movq  mm1, [edi]
           DB      $0F,$FE,$C8           /// paddd mm1, mm0
           DB      $0F,$7F,$0F           /// movq [edi], mm1

           SUB     EBX, 8
           ADD     ESI, 8
           ADD     EDI, 8
           JMP     @@FogNext
      {@@EageNext:
         movzx eax, [esi].byte
         movzx ecx, [edi].byte
         add   eax, ecx
         mov   [edi].byte, al

         dec   ebx
         inc   esi
         inc   edi
         jmp   @@FogNext }
           @@FinOne:
           INC     row
           JMP     @@NextRow

           @@Finish:
           DB      $0F,$77               /// emms
  end;
end;

procedure DrawFog(ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
var
  i, j, idx, row, n, Count: integer;
  ddsd:     TDDSurfaceDesc;
  sptr, mptr, pmix: PByte;
  //source: array[0..910] of byte;
  bitindex, scount, dcount, srclen, destlen, srcheight: integer;
  lpitch:   integer;
  src, msk: array[0..7] of byte;
  pSrc, psource, pColorLevel: Pbyte;
begin
  if ssuf.Width > 900 then
    exit;
  case DarkLevel of
    1: pColorLevel := @HeavyDarkColorLevel;
    2: pColorLevel := @LightDarkColorLevel;
    3: pColorLevel := @DengunColorLevel;
    else
      exit;
  end;
  try
    ddsd.dwSize := SizeOf(ddsd);
    ssuf.Lock(TRect(nil^), ddsd);
    srclen    := _MIN(ssuf.Width, fogwidth);
    pSrc      := @src;
    srcheight := ssuf.Height;
    lpitch    := ddsd.lPitch;
    psource   := ddsd.lpSurface;

    asm
             MOV     row, 0
             @@NextRow:
             MOV     EBX, row
             MOV     EAX, srcheight
             CMP     EBX, EAX
             JAE     @@DrawFogFin

             MOV     ESI, psource      //esi = ddsd.lpSurface;
             MOV     EAX, lpitch
             MOV     EBX, row
             IMUL    EAX, EBX
             ADD     ESI, EAX

             MOV     EDI, fogmask      //edi = fogmask
             MOV     EAX, fogwidth
             MOV     EBX, row
             IMUL    EAX, EBX
             ADD     EDI, EAX

             MOV     ECX, srclen
             MOV     EDX, pColorLevel

             @@NextByte:
             CMP     ECX, 0
             JBE     @@Finish

             MOVZX   EAX, [EDI].byte   //fogmask
             ///cmp   eax, 30
             ///ja    @@SkipByte
             IMUL    EAX, 256
             MOVZX   EBX, [ESI].byte   //소스 ddsd.lpSurface;
             ADD     EAX, EBX
             MOV     AL, [EDX+EAX].byte //pColorLevel
             MOV     [ESI].byte, AL
             ///@@SkipByte:
             DEC     ECX
             INC     ESI
             INC     EDI
             JMP     @@NextByte

             @@Finish:
             INC     row
             JMP     @@NextRow

             @@DrawFogFin:
             DB      $0F,$77               /// emms
    end;
  finally
    ssuf.UnLock();
  end;
end;

procedure DrawFog2(ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
var
  i, j, n, scount, srclen, offsvalue: integer;
  sddsd:  TDDSurfaceDesc;
  sptr, fptr, pColorLevel: Pbyte;
  Source: array[0..810] of byte;
begin
  if ssuf.Width > 800 then
    exit;
  try
    sddsd.dwSize := SizeOf(sddsd);
    ssuf.Lock(TRect(nil^), sddsd);
    srclen := _MIN(ssuf.Width, fogwidth);
    case DarkLevel of
      0: pColorLevel := @HeavyDarkColorLevel;
      1: pColorLevel := @LightDarkColorLevel;
      2: pColorLevel := @DengunColorLevel;
    end;
    for i := 0 to ssuf.Height - 1 do begin
      sptr := PBYTE(integer(sddsd.lpSurface) + i * sddsd.lPitch);
      fptr := PBYTE(integer(fogmask) + i * fogwidth);
      asm
               MOV     scount, 0
               MOV     ESI, sptr
               LEA     EDI, source
               @@CopySource:
               MOV     EBX, scount        //ebx = scount
               CMP     EBX, srclen
               JAE     @@EndSourceCopy
               DB      $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               DB      $0F,$7F,$07           /// movq  [edi], mm0

               XOR     EBX, EBX
               @@Loop8:
               CMP     EBX, 8
               JZ      @@EndLoop8
               MOV     ECX, fptr
               ADD     ECX, scount
               ADD     ECX, EBX
               MOVZX   EAX, [ECX].byte
               CMP     EAX, 30
               JAE     @@Skip
               IMUL    EAX, 256
               MOV     ECX, EAX


               MOVZX   EAX, [EDI+EBX].byte
               MOV     EDX, pColorLevel
               ADD     EDX, ECX
               MOVZX   EAX, [EDX+EAX].byte
               MOV     [EDI+EBX], AL
               @@Skip:
               INC     EBX
               JMP     @@Loop8
               @@EndLoop8:
               MOV     EBX, scount
               DB      $0F,$6F,$07           /// movq  mm0, [edi]
               DB      $0F,$7F,$04,$1E       /// movq  [esi+ebx], mm0

               ADD     EDI, 8
               ADD     scount, 8
               JMP     @@CopySource
               @@EndSourceCopy:
               DB      $0F,$77               /// emms

      end;
    end;
  finally
    ssuf.UnLock();
  end;
end;


procedure MakeDark(ssuf: TDirectDrawSurface; darklevel: integer);
var
  i, j, idx, row, n, Count: integer;
  ddsd:     TDDSurfaceDesc;
  sptr, mptr, pmix: PByte;
  //source: array[0..910] of byte;
  bitindex, scount, dcount, srclen, destlen, srcheight: integer;
  lpitch:   integer;
  src, msk: array[0..7] of byte;
  pSrc, psource, pColorLevel: Pbyte;
begin
  if not darklevel in [1..30] then
    exit;
  if ssuf.Width > 900 then
    exit;
  try
    ddsd.dwSize := SizeOf(ddsd);
    ssuf.Lock(TRect(nil^), ddsd);
    srclen    := ssuf.Width;
    srcheight := ssuf.Height;
    pSrc      := @src;
    //if HeavyDark then pColorLevel := @HeavyDarkColorLevel
    //else pColorLevel := @LightDarkColorLevel;
    pColorLevel := @HeavyDarkColorLevel;
    lpitch    := ddsd.lPitch;
    psource   := ddsd.lpSurface;

    asm
             MOV     row, 0
             @@NextRow:
             MOV     EBX, row
             MOV     EAX, srcheight
             CMP     EBX, EAX
             JAE     @@DrawFogFin

             MOV     ESI, psource      //sptr
             MOV     EAX, lpitch
             MOV     EBX, row
             IMUL    EAX, EBX
             ADD     ESI, EAX

             MOV     EAX, srclen
             MOV     scount, EAX
             @@FogNext:
             MOV     EDX, pSrc     //pSrc = array[0..7]
             MOV     EBX, scount
             CMP     EBX, 0
             JBE     @@Finish
             CMP     EBX, 8
             JB      @@FogSmall

             DB      $0F,$6F,$06           /// movq  mm0, [esi]       //8바이트 읽음 sptr
             DB      $0F,$7F,$02           /// movq  [edx], mm0
             MOV     count, 8

             @@LevelChange:
             MOV     EAX, darklevel
             IMUL    EAX, 256
             MOVZX   EBX, [EDX].byte   //8바이트 묶음으로 읽은 데이터
             ADD     EAX, EBX
             MOV     EBX, pColorLevel
             MOV     AL, [EBX+EAX].byte
             MOV     [EDX].byte, AL

             @@Skip1:
             DEC     count
             INC     EDX
             INC     EDI
             CMP     count, 0
             JA      @@LevelChange
             SUB     EDX, 8

             DB      $0F,$6F,$02           /// movq  mm0, [edx]
             DB      $0F,$7F,$06           /// movq  [esi], mm0
             @@Skip_8Byte:
             SUB     scount, 8
             ADD     ESI, 8
             JMP     @@FogNext

             @@FogSmall:
             MOV     EAX, darklevel
             IMUL    EAX, 256
             MOVZX   EBX, [EDX].byte
             ADD     EAX, EBX
             MOV     EBX, pColorLevel
             MOV     AL, [EBX+EAX].byte
             MOV     [ESI].byte, AL

             @@Skip2:
             INC     EDI
             INC     ESI
             DEC     scount
             JMP     @@FogNext

             @@Finish:
             INC     row
             JMP     @@NextRow

             @@DrawFogFin:
             DB      $0F,$77               /// emms
    end;
  finally
    ssuf.UnLock();
  end;
end;

 //ssuf(system memory) -> dsuf(video memory)  : 이때만 사용할 것
 //넓이는 8의 배수
procedure MMXBlt(ssuf, dsuf: TDirectDrawSurface);
var
  n, m, aheight, awidth, spitch, dpitch: integer;
  sddsd, dddsd: TDDSurfaceDesc;
  sptr, dptr:   PByte;
begin
  try
    sddsd.dwSize := SizeOf(sddsd);
    ssuf.Lock(TRect(nil^), sddsd);
    dddsd.dwSize := Sizeof(dddsd);
    dsuf.Lock(TRect(nil^), dddsd);
    aheight := ssuf.Height - 1;
    awidth := ssuf.Width - 1;
    spitch := sddsd.lPitch;
    dpitch := dddsd.lPitch;
    sptr := sddsd.lpSurface; //esi
    dptr := dddsd.lpSurface; //edi
    m := -1; //height
    asm
             @@NextLine:
             INC     m
             MOV     EAX, m
             CMP     EAX, aheight
             JAE     @@end
             //sptr
             MOV     ESI, sptr
             MOV     EBX, spitch
             IMUL    EAX, EBX
             ADD     ESI, EAX
             //dptr
             MOV     EAX, m
             MOV     EDI, dptr
             MOV     EBX, dpitch
             IMUL    EAX, EBX
             ADD     EDI, EAX

             XOR     EAX, EAX
             @@CopyNext:
             CMP     EAX, awidth
             JAE     @@NextLine

             DB      $0F,$6F,$04,$06       /// movq  mm0, [esi+eax]
             DB      $0F,$7F,$04,$07       /// movq  [edi+eax], mm0

             ADD     EAX, 8
             JMP     @@CopyNext

             @@end:
             DB      $0F,$77               /// emms
    end;
  finally
    ssuf.UnLock();
    dsuf.UnLock();
  end;
end;

//ssurface + dsurface => dsurface
procedure DrawBlend(dsuf: TDirectDrawSurface; x, y: integer;
  ssuf: TDirectDrawSurface; blendmode: integer);
begin
  DrawBlendEx(dsuf, x, y, ssuf, 0, 0, ssuf.Width, ssuf.Height, blendmode);
end;

//ssurface + dsurface => dsurface
procedure DrawBlendEx(dsuf: TDirectDrawSurface; x, y: integer;
  ssuf: TDirectDrawSurface; ssufleft, ssuftop, ssufwidth, ssufheight,
  blendmode: integer);
var
  i, j, srcleft, srctop, srcwidth, srcbottom, sidx, didx: integer;
  sddsd, dddsd:     TDDSurfaceDesc;
  sptr, dptr, pmix: PByte;
  Source, dest:     array[0..910] of byte;
  bitindex, scount, dcount, srclen, destlen, wcount, awidth, bwidth: integer;
begin
  if (dsuf.canvas = nil) or (ssuf.canvas = nil) then
    exit;
  if x >= dsuf.Width then
    exit;
  if y >= dsuf.Height then
    exit;
  if x < 0 then begin
    srcleft := -x;
    srcwidth := ssufwidth + x;
    x := 0;
  end else begin
    srcleft  := ssufleft;
    srcwidth := ssufwidth;
  end;
  if y < 0 then begin
    srctop := -y;
    srcbottom := ssufheight;
    y := 0;
  end else begin
    srctop    := ssuftop;
    srcbottom := srctop + ssufheight;
  end;
  if srcleft + srcwidth > ssuf.Width then
    srcwidth := ssuf.Width - srcleft;
  if srcbottom > ssuf.Height then
    srcbottom := ssuf.Height;//-srcheight;
  if x + srcwidth > dsuf.Width then
    srcwidth := (dsuf.Width - x) div 4 * 4;
  if y + srcbottom - srctop > dsuf.Height then
    srcbottom := dsuf.Height - y + srctop;
  if (x + srcwidth) * (y + srcbottom - srctop) > dsuf.Width * dsuf.Height then //임시..
    srcbottom := srctop + (srcbottom - srctop) div 2;

  if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= ssuf.Width) or
    (srctop >= ssuf.Height) then
    exit;
  if srcWidth > 900 then
    exit;
  try
    sddsd.dwSize := SizeOf(sddsd);
    dddsd.dwSize := SizeOf(dddsd);
    ssuf.Lock(TRect(nil^), sddsd);
    dsuf.Lock(TRect(nil^), dddsd);
    awidth  := srcwidth div 4; //ssuf.Width div 4;
    bwidth  := srcwidth; //ssuf.Width;
    srclen  := srcwidth; //ssuf.Width;
    destlen := srcwidth; //ssuf.Width;
    case blendmode of
      0: pmix := @Color256Mix[0, 0];
      else
        pmix := @Color256Anti[0, 0];
    end;
    for i := srctop to srcbottom - 1 do begin
      sptr := PBYTE(integer(sddsd.lpSurface) + sddsd.lPitch * i + srcleft);
      dptr := PBYTE(integer(dddsd.lpSurface) + (y + i - srctop) * dddsd.lPitch + x);
      asm
               MOV     scount, 0
               MOV     ESI, sptr
               LEA     EDI, source
               MOV     EBX, scount        //ebx = scount
               @@CopySource:
               CMP     EBX, srclen
               JAE     @@EndSourceCopy
               DB      $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               DB      $0F,$7F,$04,$1F       /// movq  [edi+ebx], mm0
               ADD     EBX, 8
               JMP     @@CopySource
               @@EndSourceCopy:
               MOV     dcount, 0
               MOV     ESI, dptr
               LEA     EDI, dest
               MOV     EBX, dcount
               @@CopyDest:
               CMP     EBX, destlen
               JAE     @@EndDestCopy
               DB      $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               DB      $0F,$7F,$04,$1F       /// movq  [edi+ebx], mm0
               ADD     EBX, 8
               JMP     @@CopyDest
               @@EndDestCopy:
               LEA     ESI, source
               LEA     EDI, dest
               MOV     wcount, 0

               @@BlendNext:
               MOV     EBX, wcount
               CMP     [ESI+EBX].byte, 0     //if _src[bitindex] > 0
               JZ      @@EndBlend

               MOVZX   EAX, [ESI+EBX].byte     //sidx := _src[bitindex]
               SHL     EAX, 8                  //sidx * 256
               MOV     sidx, EAX

               MOVZX   EAX, [EDI+EBX].byte     //didx := _dest[bitindex]
               ADD     sidx, EAX

               MOV     EDX, pmix
               MOV     ECX, sidx
               MOVZX   EAX, [EDX+ECX].byte
               MOV     [EDI+EBX], AL

               @@EndBlend:
               INC     wcount
               MOV     EAX, bwidth
               CMP     wcount, EAX
               JB      @@BlendNext

               LEA     ESI, dest               //Move (_src, dptr^, 4)
               MOV     EDI, dptr
               MOV     ECX, awidth
               CLD
               REP     movsd

      end;
    end;
    asm
             DB      $0F,$77               /// emms
    end;

  finally
    ssuf.UnLock();
    dsuf.UnLock();
  end;
end;

procedure SpriteCopy(DestX, DestY: integer; SourX, SourY: integer;
  Size: TPoint; Sour, Dest: TDirectDrawSurface);
const
  TRANSPARENCY_VALUE = 0; // 투명색이 0번 인덱스이다.
var
  SourDesc, DestDesc: TDDSurfaceDesc;
  pSour, pDest, pMask: PByte;
  Transparency: array[1..8] of byte;
begin
  FillChar(Transparency, 8, TRANSPARENCY_VALUE);

  SourDesc.dwSize := SizeOf(TDDSurfaceDesc);
  Sour.Lock(TRect(nil^), SourDesc);
  DestDesc.dwSize := SizeOf(TDDSurfaceDesc);
  Dest.Lock(TRect(nil^), DestDesc);

  pSour := PByte(DWORD(SourDesc.lpSurface) + SourY * SourDesc.lPitch + SourX);
  pDest := PByte(DWORD(DestDesc.lpSurface) + DestY * DestDesc.lPitch + DestX);
  pMask := Pointer(@Transparency);

  asm
           PUSH    ESI
           PUSH    EDI

           MOV     ESI, pMask
           DB      $0F,$6F,$26       /// movq  mm4, [esi]
           //  mm4 에 투명색 번호를 넣는다
           MOV     ESI, pSour
           MOV     EDI, pDest

           MOV     ECX, Size.Y

           @@LOOP_Y:
           PUSH    ECX

           MOV     ECX, Size.X
           SHR     ECX, 3         // 동시에 8개의 점을 연산하므로


           @@LOOP_X:
           DB      $0F,$6F,$07       /// movq  mm0, [edi]
           //  mm0 은 Destination
           DB      $0F,$6F,$0E       /// movq  mm1, [esi]
           //  mm1 은 Source
           DB      $0F,$6F,$D1       /// movq  mm2, mm1
           //  mm2 에 Source 데이터를 복사
           DB      $0F,$74,$D4       /// pcmpeqb mm2, mm4
           //  mm2 에 투명색에 따른 마스크를 생성
           DB      $0F,$6F,$DA       /// movq  mm3, mm2
           //  mm3 에 마스크를 하나 더 복사
           DB      $0F,$DF,$D1       /// pandn mm2, mm1
           //  Source 스프라이트 부분만을 남김
           DB      $0F,$DB,$D8       /// pand  mm3, mm0
           //  Destination 의 갱신될 부분만 제거
           DB      $0F,$EB,$D3       /// por   mm2, mm3
           //  Source 와 Destination 을 결합
           DB      $0F,$7F,$17       /// movq  [edi], mm2
           //  Destination 에 결과를 씀

           ADD     ESI, 8
           //  한번에 8 bytes 를 동시에 처리했으므로
           ADD     EDI, 8

           LOOP    @@LOOP_X

           ADD     ESI, SourDesc.lPitch
           SUB     ESI, Size.X
           ADD     EDI, DestDesc.lPitch
           SUB     EDI, Size.X

           POP     ECX
           LOOP    @@LOOP_Y

           DB      $0F,$77              /// emms

           POP     EDI
           POP     ESI

  end;

  Sour.UnLock();
  Dest.UnLock();

end;

procedure DrawEffect(x, y, Width, Height: integer; ssuf: TDirectDrawSurface;
  eff: TColorEffect);
var
  i, j, n, scount, srclen: integer;
  sddsd:      TDDSurfaceDesc;
  sptr, peff: PByte;
  Source:     array[0..810] of byte;
begin
  if Width > 800 then
    exit;
  // TO TEST PDS
  if Width >= ssuf.Width then
    Width := ssuf.Width;
  if Height >= ssuf.Height then
    Height := ssuf.Height;

  if eff = ceNone then
    exit;
  peff := nil;
  case eff of
    ceGrayScale: peff := @GrayScaleLevel;
    ceBright: peff  := @BrightColorLevel;
    ceBlack: peff   := @BlackColorLevel;
    ceWhite: peff   := @WhiteColorLevel;
    ceRed: peff     := @RedishColorLevel;
    ceGreen: peff   := @GreenColorLevel;
    ceBlue: peff    := @BlueColorLevel;
    ceYellow: peff  := @YellowColorLevel;
    ceFuchsia: peff := @FuchsiaColorLevel;
    //else exit;
  end;
  if peff = nil then begin
    peff := nil;
    exit;
  end;
  try
    sddsd.dwSize := SizeOf(sddsd);
    ssuf.Lock(TRect(nil^), sddsd);
    srclen := Width;
    for i := 0 to Height - 1 do begin
      sptr := PBYTE(integer(sddsd.lpSurface) + (y + i) * sddsd.lPitch + x);
      asm
               MOV     scount, 0
               MOV     ESI, sptr
               LEA     EDI, source
               @@CopySource:
               MOV     EBX, scount        //ebx = scount
               CMP     EBX, srclen
               JAE     @@EndSourceCopy
               DB      $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               DB      $0F,$7F,$07           /// movq  [edi], mm0

               MOV     EBX, 0
               @@Loop8:
               CMP     EBX, 8
               JZ      @@EndLoop8
               MOVZX   EAX, [EDI+EBX].byte
               MOV     EDX, peff
               MOVZX   EAX, [EDX+EAX].byte
               MOV     [EDI+EBX], AL
               INC     EBX
               JMP     @@Loop8
               @@EndLoop8:
               MOV     EBX, scount
               DB      $0F,$6F,$07           /// movq  mm0, [edi]
               DB      $0F,$7F,$04,$1E       /// movq  [esi+ebx], mm0

               ADD     EDI, 8
               ADD     scount, 8
               JMP     @@CopySource
               @@EndSourceCopy:
               DB      $0F,$77               /// emms

      end;
    end;
  finally
    ssuf.UnLock();
  end;
end;


end.
