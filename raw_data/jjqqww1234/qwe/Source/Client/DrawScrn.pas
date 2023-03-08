unit DrawScrn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, IntroScn, Actor, cliUtil, clFunc,
  HUtil32;

const
  MAXSYSLINE = 8;

  BOTTOMBOARD     = 1;
  VIEWCHATLINE    = 9;
  AREASTATEICONBASE = 150;
  HEALTHBAR_BLACK = 0;
  HEALTHBAR_RED   = 1;
  HEALTHBAR_BLUE  = 10;


type
  TDrawScreen = class
  private
    frametime, framecount, drawframecount: longword;
    SysMsg: TStringList;
  public
    CurrentScene: TScene;
    ChatStrs:     TStringList;
    ChatBks:      TList;
    ChatBoardTop: integer;

    HintList:  TStringList;
    HintX, HintY, HintWidth, HintHeight: integer;
    HintUp:    boolean;
    HintColor: TColor;

    constructor Create;
    destructor Destroy; override;
    procedure KeyPress(var Key: char);
    procedure KeyDown(var Key: word; Shift: TShiftState);
    procedure MouseMove(Shift: TShiftState; X, Y: integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure Initialize;
    procedure Finalize;
    procedure ChangeScene(scenetype: TSceneType);
    procedure DrawScreen(MSurface: TDirectDrawSurface);
    procedure DrawScreenTop(MSurface: TDirectDrawSurface);
    procedure AddSysMsg(msg: string);
    procedure AddChatBoardString(str: string; fcolor, bcolor: integer);
    procedure ClearChatBoard;

    procedure ShowHint(x, y: integer; str: string; color: TColor; drawup: boolean);
    procedure ClearHint;
    procedure DrawHint(MSurface: TDirectDrawSurface);
  end;


implementation

uses
  ClMain;

constructor TDrawScreen.Create;
var
  i: integer;
begin
  CurrentScene := nil;
  frametime := GetTickCount;
  framecount := 0;
  SysMsg   := TStringList.Create;
  ChatStrs := TStringList.Create;
  ChatBks  := TList.Create;
  ChatBoardTop := 0;

  HintList := TStringList.Create;

end;

destructor TDrawScreen.Destroy;
begin
  SysMsg.Free;
  ChatStrs.Free;
  ChatBks.Free;
  HintList.Free;
  inherited Destroy;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
end;

procedure TDrawScreen.KeyPress(var Key: char);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyPress(Key);
end;

procedure TDrawScreen.KeyDown(var Key: word; Shift: TShiftState);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyDown(Key, Shift);
end;

procedure TDrawScreen.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseMove(Shift, X, Y);
end;

procedure TDrawScreen.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseDown(Button, Shift, X, Y);
end;

procedure TDrawScreen.ChangeScene(scenetype: TSceneType);
begin
  if CurrentScene <> nil then
    CurrentScene.CloseScene;
  case scenetype of
    stIntro: CurrentScene := IntroScene;
    stLogin: CurrentScene := LoginScene;
    stSelectCountry: ;
    stSelectChr: CurrentScene := SelectChrScene;
    stNewChr: ;
    stLoading: ;
    stLoginNotice: CurrentScene := LoginNoticeScene;
    stPlayGame: CurrentScene    := PlayScene;
  end;
  if CurrentScene <> nil then
    CurrentScene.OpenScene;
end;

procedure TDrawScreen.AddSysMsg(msg: string);
begin
  if SysMsg.Count >= 10 then
    SysMsg.Delete(0);
  SysMsg.AddObject(msg, TObject(GetTickCount));
end;

procedure TDrawScreen.AddChatBoardString(str: string; fcolor, bcolor: integer);
var
  i, len, aline: integer;
  dline, temp:   string;
const
  BOXWIDTH = 374; //41;
begin
  len  := Length(str);
  temp := '';
  i    := 1;
  while True do begin
    if i > len then
      break;
    if byte(str[i]) >= 128 then begin
      temp := temp + str[i];
      Inc(i);
      if i <= len then
        temp := temp + str[i]
      else
        break;
    end else
      temp := temp + str[i];

    aline := FrmMain.DxDraw1.Surface.Canvas.TextWidth(temp);
    if aline > BOXWIDTH then begin
      ChatStrs.AddObject(temp, TObject(fcolor));
      ChatBks.Add(Pointer(bcolor));
      str  := Copy(str, i + 1, Len - i);
      temp := '';
      break;
    end;
    Inc(i);
  end;
  FrmMain.DxDraw1.Surface.Canvas.Release;

  if temp <> '' then begin
    ChatStrs.AddObject(temp, TObject(fcolor));
    ChatBks.Add(Pointer(bcolor));
    str := '';
  end;
  if ChatStrs.Count > 200 then begin
    ChatStrs.Delete(0);
    ChatBks.Delete(0);
    if ChatStrs.Count - ChatBoardTop < VIEWCHATLINE then
      Dec(ChatBoardTop);
  end else if (ChatStrs.Count - ChatBoardTop) > VIEWCHATLINE then begin
    Inc(ChatBoardTop);
  end;

  if str <> '' then
    AddChatBoardString(' ' + str, fcolor, bcolor);

end;

procedure TDrawScreen.ShowHint(x, y: integer; str: string; color: TColor;
  drawup: boolean);
var
  Data: string;
  w, h: integer;
begin
  ClearHint;
  HintX      := x;
  HintY      := y;
  HintWidth  := 0;
  HintHeight := 0;
  HintUp     := drawup;
  HintColor  := color;
  while True do begin
    if str = '' then
      break;
    str := GetValidStr3(str, Data, ['\']);
    w   := FrmMain.DxDraw1.Surface.Canvas.TextWidth(Data) + 4{여백} * 2;
    if w > HintWidth then
      HintWidth := w;
    if Data <> '' then
      HintList.Add(Data);
  end;
  FrmMain.DxDraw1.Surface.Canvas.Release;

  HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) * HintList.Count + 3{여백} * 2;
  if HintUp then
    HintY := HintY - HintHeight;
end;

procedure TDrawScreen.ClearHint;
begin
  HintList.Clear;
end;

procedure TDrawScreen.ClearChatBoard;
begin
  SysMsg.Clear;
  ChatStrs.Clear;
  ChatBks.Clear;
  ChatBoardTop := 0;
end;


procedure TDrawScreen.DrawScreen(MSurface: TDirectDrawSurface);

  procedure NameTextOut(surface: TDirectDrawSurface; x, y, fcolor, bcolor: integer;
    namestr: string);
  var
    i, row: integer;
    nstr:   string;
  begin
    row := 0;
    for i := 0 to 10 do begin
      if namestr = '' then
        break;
      namestr := GetValidStr3(namestr, nstr, ['\']);
      BoldTextOut(surface,
        x - surface.Canvas.TextWidth(nstr) div 2,
        y + row * 12,
        fcolor, bcolor, nstr);
      Inc(row);
    end;
  end;

var
  i, k, line, sx, sy, fcolor, bcolor: integer;
  actor: TActor;
  str, uname: string;
  dsurface: TDirectDrawSurface;
  d:  TDirectDrawSurface;
  rc: TRect;
begin
  MSurface.Fill(0);
  if CurrentScene <> nil then
    CurrentScene.PlayScene(MSurface);

  if GetTickCount - frametime > 1000 then begin
    frametime      := GetTickCount;
    drawframecount := framecount;
    framecount     := 0;
  end;
  Inc(framecount);


  //SetBkMode (MSurface.Canvas.Handle, TRANSPARENT);
  //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'c1 ' + IntToStr(DebugColor1));
  //BoldTextOut (MSurface, 0, 20, clWhite, clBlack, 'c2 ' + IntToStr(DebugColor2));
  //BoldTextOut (MSurface, 0, 40, clWhite, clBlack, 'c3 ' + IntToStr(DebugColor3));
  //BoldTextOut (MSurface, 0, 60, clWhite, clBlack, 'c4 ' + IntToStr(DebugColor4));
  //MSurface.Canvas.Release;


  if Myself = nil then
    exit;

  if CurrentScene = PlayScene then begin
    with MSurface do begin
      //머리위에 체력 표시 해야 하는 것들
      with PlayScene do begin
        for k := 0 to ActorList.Count - 1 do begin
          actor := ActorList[k];
          if (actor.BoOpenHealth or actor.BoInstanceOpenHealth) and
            not actor.Death then begin
            if actor.BoInstanceOpenHealth then
              if GetTickCount - actor.OpenHealthStart > actor.OpenHealthTime then
                actor.BoInstanceOpenHealth := False;
            d := FrmMain.WProgUse2.Images[HEALTHBAR_BLACK];
            if d <> nil then
              MSurface.Draw(actor.SayX - d.Width div 2,
                actor.SayY - 10, d.ClientRect, d, True);

            if actor.Race = 0 then
              d := FrmMain.WProgUse2.Images[HEALTHBAR_BLUE] // 2004/03/05 체력표시 차별화
            else
              d := FrmMain.WProgUse2.Images[HEALTHBAR_RED];
            if d <> nil then begin
              rc := d.ClientRect;
              if actor.Abil.MaxHP > 0 then
                rc.Right :=
                  Round((rc.Right - rc.Left) / actor.Abil.MaxHP * actor.Abil.HP);
              MSurface.Draw(actor.SayX - d.Width div 2,
                actor.SayY - 10, rc, d, True);
            end;
          end;
        end;
      end;

      //마우스로 대고 있는 캐릭터 이름 나오기
      SetBkMode(Canvas.Handle, TRANSPARENT);
      if (FocusCret <> nil) and PlayScene.IsValidActor(FocusCret) then begin
        //if FocusCret.Grouped then uname := char(7) + FocusCret.UserName

        if FocusCret.Race = 95 then begin //####1 이벤트나방
          if FocusCret.Death then
            FocusCret.UserName := 'Father'
          else
            FocusCret.UserName := 'WedgeMoth';
        end;

        uname := FocusCret.DescUserName + '\' + FocusCret.UserName;
        if (FocusCret.Race = 50) and (FocusCret.Appearance = 57) then
          uname := '';

        NameTextOut(MSurface,
          FocusCret.SayX, // - Canvas.TextWidth(uname) div 2,
          FocusCret.SayY + 30,
          FocusCret.NameColor, clBlack,
          uname);
      end;
      if BoSelectMyself then begin
        uname := Myself.DescUserName + '\' + Myself.UserName;
        NameTextOut(MSurface,
          Myself.SayX, // - Canvas.TextWidth(uname) div 2,
          Myself.SayY + 30,
          Myself.NameColor, clBlack,
          uname);
      end;

      Canvas.Font.Color := clWhite;

      //char saying
      with PlayScene do begin
        for k := 0 to ActorList.Count - 1 do begin
          actor := ActorList[k];
          if actor.Saying[0] <> '' then begin
            if GetTickCount - actor.SayTime < 4 * 1000 then begin
              for i := 0 to actor.SayLineCount - 1 do
                if actor.Death then
                  BoldTextOut(MSurface,
                    actor.SayX - (actor.SayWidths[i] div 2),
                    actor.SayY - (actor.SayLineCount * 16) + i * 14,
                    clGray, clBlack,
                    actor.Saying[i])
                else
                  BoldTextOut(MSurface,
                    actor.SayX - (actor.SayWidths[i] div 2),
                    actor.SayY - (actor.SayLineCount * 16) + i * 14,
                    clWhite, clBlack,
                    actor.Saying[i]);
            end else
              actor.Saying[0] := '';
          end;
        end;
      end;

      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(SendCount) + ' : ' + IntToStr(ReceiveCount));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'HITSPEED=' + IntToStr(Myself.HitSpeed));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'DupSel=' + IntToStr(DupSelection));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(LastHookKey));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
      //             IntToStr(
      //                int64(GetTickCount - LatestSpellTime) - int64(700 + MagicDelayTime)
      //                ));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(PlayScene.EffectList.Count));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
      //                  IntToStr(Myself.XX) + ',' + IntToStr(Myself.YY) + '  ' +
      //                  IntToStr(Myself.ShiftX) + ',' + IntToStr(Myself.ShiftY));

      //System Message
      //맵의 상태 표시 (임시 표시)
      if (AreaStateValue and $04) <> 0 then begin
        BoldTextOut(MSurface, 0, 0, clWhite, clBlack, 'WallConquestwarZone');
      end;

      Canvas.Release;


      //맵의 상태 표시
      k := 0;
      for i := 0 to 15 do begin
        if AreaStateValue and ($01 shr i) <> 0 then begin
          d := FrmMain.WProgUse.Images[AREASTATEICONBASE + i];
          if d <> nil then begin
            k := k + d.Width;
            MSurface.Draw(SCREENWIDTH - k, 0, d.ClientRect, d, True);
          end;
        end;
      end;

    end;
  end;
end;

procedure TDrawScreen.DrawScreenTop(MSurface: TDirectDrawSurface);
var
  i, sx, sy: integer;
  TempMsg:   string;
begin
  if Myself = nil then
    exit;

  if CurrentScene = PlayScene then begin
    with MSurface do begin
      SetBkMode(Canvas.Handle, TRANSPARENT);
      if SysMsg.Count > 0 then begin
        sx := 30;
        sy := 40;
        for i := 0 to SysMsg.Count - 1 do begin
          if Copy(SysMsg[i], 1, 8) = 'clYellow' then begin
            TempMsg := Copy(SysMsg[i], 9, Length(SysMsg[i]) - 8);
            BoldTextOut(MSurface, sx, sy, clYellow, clBlack, TempMsg);
          end else
            BoldTextOut(MSurface, sx, sy, clGreen, clBlack, SysMsg[i]);
          Inc(sy, 16);
        end;
        if GetTickCount - longword(SysMsg.Objects[0]) >= 3000 then
          SysMsg.Delete(0);
      end;
      Canvas.Release;
    end;
  end;
end;

procedure TDrawScreen.DrawHint(MSurface: TDirectDrawSurface);
var
  d:   TDirectDrawSurface;
  i, hx, hy, old: integer;
  bodrawhint: boolean;
  str: string;
begin
  bodrawhint := False;
  hx := 0;
  hy := 0;
  if HintList.Count > 0 then begin
    d := FrmMain.WProgUse.Images[394];
    if d <> nil then begin
      if HintWidth > d.Width then
        HintWidth := d.Width;
      if HintHeight > d.Height then
        HintHeight := d.Height;
      if HintX + HintWidth > SCREENWIDTH then
        hx := SCREENWIDTH - HintWidth
      else
        hx := HintX;
      if HintY < 0 then
        hy := 0
      else
        hy := HintY;
      if hx < 0 then
        hx := 0;

      DrawBlendEx(MSurface, hx, hy, d, 0, 0, HintWidth, HintHeight, 0);
      bodrawhint := True;
    end;
  end;
  with MSurface do begin
    SetBkMode(Canvas.Handle, TRANSPARENT);
    if bodrawhint then begin
      Canvas.Font.Color := HintColor;
      for i := 0 to HintList.Count - 1 do begin
        Canvas.TextOut(hx + 4, hy + 3 + (Canvas.TextHeight('A') + 1) * i, HintList[i]);
      end;
    end;

    if Myself <> nil then begin
{         if CheckBadMapMode then begin
              str := IntToStr(drawframecount) +  ' '
              + '  Mouse ' + IntToStr(MouseX) + ':' + IntToStr(MouseY) + '(' + IntToStr(MCX) + ':' + IntToStr(MCY) + ')'
              + '  HP' + IntToStr(Myself.Abil.HP) + '/' + IntToStr(Myself.Abil.MaxHP)
              + '  D0 ' + IntToStr(DebugCount)
              + ' D1 ' + IntToStr(DebugCount1) + ' D2 '
              + IntToStr(DebugCount2);
         end;}
      BoldTextOut(MSurface, 10, 0, clWhite, clBlack, str);
      //old := Canvas.Font.Size;
      //Canvas.Font.Size := 8;
      //BoldTextOut (MSurface, 8, SCREENHEIGHT-42, clWhite, clBlack, ServerName);
      if EffectNum = 3 then
        BoldTextOut(MSurface, 8, SCREENHEIGHT - 20, clWhite, clBlack, MapTitle)
      else
        BoldTextOut(MSurface, 8, SCREENHEIGHT - 20, clWhite, clBlack,
          MapTitle + ' ' + IntToStr(Myself.XX) + ':' + IntToStr(Myself.YY));
      //Canvas.Font.Size := old;
    end;
    //BoldTextOut (MSurface, 10, 20, clWhite, clBlack, IntToStr(DebugCount) + ' / ' + IntToStr(DebugCount1));

    Canvas.Release;
  end;
end;


end.
