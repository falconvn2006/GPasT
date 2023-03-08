unit IntroScn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, StdCtrls, Controls, Forms, Dialogs,
  ExtCtrls, DXDraws, DXClass, FState, Grobal2, cliUtil, clFunc, SoundUtil,
  DXSounds, HUtil32, ButtonListBox, EdCode, NPGameDLL;

const
  SELECTEDFRAME = 16;
  FREEZEFRAME   = 13;
  EFFECTFRAME   = 14;

type
  TLoginState = (lsLogin, lsNewid, lsNewidRetry, lsChgpw, lsCloseAll);
  TSceneType  = (stIntro, stLogin, stSelectCountry, stSelectChr, stNewChr, stLoading,
    stLoginNotice, stPlayGame);

  TSelChar = record
    Valid:      boolean;
    UserChr:    TUserCharacterInfo;
    Selected:   boolean;
    //FreezeState: boolean; //TRUE:얼은상태 FALSE:녹은상태  SEAN - 29/12/08 - No longer necessary
    //Unfreezing: boolean;  //녹고 있는 상태인가?  SEAN - 29/12/08 - No longer necessary
    Freezing:   boolean;  //얼고 있는 상태?
    AniIndex:   integer;  //녹는(어는) 애니메이션
    DarkLevel:  integer;
    EffIndex:   integer;  //효과 애니메이션
    starttime:  longword;
    moretime:   longword;
    startefftime: longword;
  end;

  TScene = class
  private
  public
    SceneType: TSceneType;
    constructor Create(scenetype: TSceneType);
    procedure Initialize; dynamic;
    procedure Finalize; dynamic;
    procedure OpenScene; dynamic;
    procedure CloseScene; dynamic;
    procedure OpeningScene; dynamic;
    procedure KeyPress(var Key: char); dynamic;
    procedure KeyDown(var Key: word; Shift: TShiftState); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); dynamic;
    procedure PlayScene(MSurface: TDirectDrawSurface); dynamic;
  end;

  TIntroScene = class(TScene)
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
  end;

  TLoginScene = class(TScene)
    //LbServerList: TButtonListBox;

  private
    EdId:     TEdit;
    EdPasswd: TEdit;

    EdNewId:     TEdit;
    EdNewPasswd: TEdit;
    EdConfirm:   TEdit;
    EdYourName:  TEdit;
    EdSSNo:      TEdit;
    EdBirthDay:  TEdit;
    EdQuiz1:     TEdit;
    EdAnswer1:   TEdit;
    EdQuiz2:     TEdit;
    EdAnswer2:   TEdit;
    EdPhone:     TEdit;
    EdMobPhone:  TEdit;
    EdEMail:     TEdit;

    EdChgId:     TEdit;
    EdChgCurrentpw: TEdit;
    EdChgNewPw:  TEdit;
    EdChgRepeat: TEdit;

    CurFrame, MaxFrame: integer;
    StartTime:     longword;  //한 프래임당 시간
    NowOpening:    boolean;
    BoOpenFirst:   boolean;
    NewIdRetryUE:  TUserEntryInfo;
    NewIdRetryAdd: TUserEntryAddInfo;

    procedure EdLoginIdKeyPress(Sender: TObject; var Key: char);
    procedure EdLoginPasswdKeyPress(Sender: TObject; var Key: char);
    procedure EdNewIdKeyPress(Sender: TObject; var Key: char);
    procedure EdNewOnEnter(Sender: TObject);
    function CheckUserEntrys: boolean;
    function NewIdCheckNewId: boolean;
    function NewIdCheckSSno: boolean;
    function NewIdCheckBirthDay: boolean;

    // 20003-09-05 Encrypt LoginId,PasswordmCharName
    function GetLoginId: string;
    procedure SetLogId(id: string);
    function GetLoginPasswd: string;
    procedure SetLoginPasswd(pw: string);

  public
    BoUpdateAccountMode: boolean;
    //LoginId, LoginPasswd: string;
    //2003-09-05 Encrypt LoginID & Password
    EncLoginId, EncLoginPasswd: string;
    property LoginId: string Read GetLoginId Write SetLogId;
    property LoginPasswd: string Read GetLoginPasswd Write SetLoginPasswd;

    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    procedure ChangeLoginState(state: TLoginState);
    procedure NewClick;
    procedure NewIdRetry(boupdate: boolean);
    procedure UpdateAccountInfos(ue: TUserEntryInfo);
    procedure OkClick;
    procedure ChgPwClick;
    procedure NewAccountOk;
    procedure NewAccountClose;
    procedure ChgpwOk;
    procedure ChgpwCancel;
    procedure HideLoginBox;
    procedure OpenLoginDoor;
    procedure PassWdFail;
  end;

  TSelectChrScene = class(TScene)
  private
    SoundTimer:    TTimer;
    CreateChrMode: boolean;
    EdChrName:     TEdit;
    procedure SoundOnTimer(Sender: TObject);
    procedure MakeNewChar(index: integer);
    procedure EdChrnameKeyPress(Sender: TObject; var Key: char);
    function GetJobName(job: integer): string;
  public
    NewIndex: integer;
    ChrArr:   array[0..1] of TSelChar;
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    procedure SelChrSelect1Click;
    procedure SelChrSelect2Click;
    procedure SelChrStartClick;
    procedure SelChrNewChrClick;
    procedure SelChrEraseChrClick;
    procedure SelChrCreditsClick;
    procedure SelChrExitClick;
    procedure SelChrNewClose;
    procedure SelChrNewJob(job: integer);
    procedure SelChrNewSex(sex: integer);
    procedure SelChrNewPrevHair;
    procedure SelChrNewNextHair;
    procedure SelChrNewOk;
    procedure ClearChrs;
    procedure AddChr(uname: string; job, hair, level, sex: integer);
    procedure SelectChr(index: integer);
  end;

  TLoginNotice = class(TScene)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;


implementation

uses
  ClMain;

constructor TScene.Create(scenetype: TSceneType);
begin
  SceneType := scenetype;
end;

procedure TScene.Initialize;
begin
end;

procedure TScene.Finalize;
begin
end;

procedure TScene.OpenScene;
begin
  ;
end;

procedure TScene.CloseScene;
begin
  ;
end;

procedure TScene.OpeningScene;
begin
end;

procedure TScene.KeyPress(var Key: char);
begin
end;

procedure TScene.KeyDown(var Key: word; Shift: TShiftState);
begin
end;

procedure TScene.MouseMove(Shift: TShiftState; X, Y: integer);
begin
end;

procedure TScene.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
end;

procedure TScene.PlayScene(MSurface: TDirectDrawSurface);
begin
  ;
end;


{------------------- TIntroScene ----------------------}


constructor TIntroScene.Create;
begin
  inherited Create(stIntro);
end;

destructor TIntroScene.Destroy;
begin
  inherited Destroy;
end;

procedure TIntroScene.OpenScene;
begin
end;

procedure TIntroScene.CloseScene;
begin
end;

procedure TIntroScene.PlayScene(MSurface: TDirectDrawSurface);
begin
end;


{--------------------- Login ----------------------}

// 20003-09-05 Encrypt LoginId,PasswordmCharName
function TLoginScene.GetLoginId: string;
begin
  Result := DecodeString(EncLoginId);
end;

procedure TLoginScene.SetLogId(id: string);
begin
  EncLoginId := EncodeString(id);
end;

function TLoginScene.GetLoginPasswd: string;
begin
  Result := DecodeString(EncLoginPasswd);
end;

procedure TLoginScene.SetLoginPasswd(pw: string);
begin
  EncLoginPasswd := EncodeString(pw);
end;

constructor TLoginScene.Create;
var
  nx, ny: integer;
begin
  inherited Create(stLogin);
  //로그인 아이디 입력
  EdId := TEdit.Create(FrmMain.Owner);
  with EdId do begin
    // 2003/04/01 최대 LoginID 길이 증가 10->20 (미르3계정 포함)
    Parent := FrmMain;
    Color := clBlack;
    Font.Color := clWhite;
    Font.Size := 10;
    MaxLength := 20;
    BorderStyle := bsNone;
    OnKeyPress := EdLoginIdKeyPress;
    Visible := False;
    Tag := 10;
  end;
  //로그인 패스워드 입력
  EdPasswd := TEdit.Create(FrmMain.Owner);
  with EdPasswd do begin
    Parent := FrmMain;
    Color := clBlack;
    Font.Size := 10;
    MaxLength := 10;
    Font.Color := clWhite;
    BorderStyle := bsNone;
    PasswordChar := '*';
    OnKeyPress := EdLoginPasswdKeyPress;
    Visible := False;
    Tag := 10;
  end;

  nx := SCREENWIDTH div 2 - 320;
  ny := SCREENHEIGHT div 2 - 238;
  EdNewId := TEdit.Create(FrmMain.Owner);
  with EdNewId do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 116;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdNewPasswd := TEdit.Create(FrmMain.Owner);
  with EdNewPasswd do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 137;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdConfirm := TEdit.Create(FrmMain.Owner);
  with EdConfirm do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 158;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdYourName := TEdit.Create(FrmMain.Owner);
  with EdYourName do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 187;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 20;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdSSNo := TEdit.Create(FrmMain.Owner);
  with EdSSNo do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 207;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 14;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdBirthDay := TEdit.Create(FrmMain.Owner);
  with EdBirthDay do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 227;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdQuiz1 := TEdit.Create(FrmMain.Owner);
  with EdQuiz1 do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 163;
    Left    := nx + 161;
    Top     := ny + 256;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 20;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdAnswer1 := TEdit.Create(FrmMain.Owner);
  with EdAnswer1 do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 163;
    Left    := nx + 161;
    Top     := ny + 276;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 12;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdQuiz2 := TEdit.Create(FrmMain.Owner);
  with EdQuiz2 do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 163;
    Left    := nx + 161;
    Top     := ny + 297;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 20;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdAnswer2 := TEdit.Create(FrmMain.Owner);
  with EdAnswer2 do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 163;
    Left    := nx + 161;
    Top     := ny + 317;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 12;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdPhone := TEdit.Create(FrmMain.Owner);
  with EdPhone do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 347;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 14;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdMobPhone := TEdit.Create(FrmMain.Owner);
  with EdMobPhone do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 368;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 13;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;
  EdEMail := TEdit.Create(FrmMain.Owner);
  with EdEMail do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 116;
    Left    := nx + 161;
    Top     := ny + 388;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 40;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 11;
  end;

  nx      := 192;
  ny      := 150;
  EdChgId := TEdit.Create(FrmMain.Owner);
  with EdChgId do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 137;
    Left    := nx + 239;
    Top     := ny + 117;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 12;
  end;
  EdChgCurrentPw := TEdit.Create(FrmMain.Owner);
  with EdChgCurrentPw do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 137;
    Left    := nx + 239;
    Top     := ny + 149;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 12;
  end;
  EdChgNewPw := TEdit.Create(FrmMain.Owner);
  with EdChgNewPw do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 137;
    Left    := nx + 239;
    Top     := ny + 176;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 12;
  end;
  EdChgRepeat := TEdit.Create(FrmMain.Owner);
  with EdChgRepeat do begin
    Parent  := FrmMain;
    Height  := 16;
    Width   := 137;
    Left    := nx + 239;
    Top     := ny + 208;
    BorderStyle := bsNone;
    Color   := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    Tag     := 12;
  end;

   {LbServerList := TButtonListBox.Create (FrmMain.Owner);
   with LbServerList do begin
      Parent := FrmMain; Height := 18 * 13 + 7; Width := 183;
      Left := (SCREENWIDTH - Width) div 2 - 13;
      Top := (SCREENHEIGHT - Height) div 2 - 14;
      ItemHeight := 32;
      Depth := 3;
      NormalFontColor := clBlack;
      SelectFontColor := clNavy; //Yellow;
      //BorderStyle := bsNone;
      //Color := clBlack;
      //Font.Color := clWhite;
      Font.Size := 11;
      Style := lbOwnerDrawFixed;
      Visible := FALSE;
   end; }
end;

destructor TLoginScene.Destroy;
begin
  inherited Destroy;
end;

procedure TLoginScene.OpenScene;
var
  i: integer;
  d: TDirectDrawSurface;
begin
  CurFrame    := 0;
  MaxFrame    := 17;
  LoginId     := '';
  LoginPasswd := '';
  with EdId do begin
    Left    := 329;
    Top     := 259;
    Height  := 16;
    Width   := 137;
    Visible := False;
  end;
  with EdPasswd do begin
    Left    := 329;
    Top     := 290;
    Height  := 16;
    Width   := 137;
    Visible := False;
  end;
  BoOpenFirst := True;

  FrmDlg.DLogin.Visible := True;
  FrmDlg.DNewAccount.Visible := False;
  NowOpening := False;
  PlayBGM(bmg_intro);
end;

procedure TLoginScene.CloseScene;
begin
  EdId.Visible     := False;
  EdPasswd.Visible := False;
  FrmDlg.DLogin.Visible := False;
  SilenceSound;
end;

procedure TLoginScene.EdLoginIdKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then begin
    Key     := #0;
    LoginId := LowerCase(EdId.Text);
    if LoginId <> '' then begin
      EdPasswd.SetFocus;
    end;
  end;
end;

procedure TLoginScene.EdLoginPasswdKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = '~') or (Key = '''') then
    Key := '_';
  if Key = #13 then begin
    Key     := #0;
    LoginId := LowerCase(EdId.Text);
    LoginPasswd := EdPasswd.Text;

    if not BoCompileMode then begin
      SendUserIDToGameMonA(PChar(LoginId)); //GameGuard @@@@
    end;

    if (LoginId <> '') and (LoginPasswd <> '') then begin
      //계정으로 로그인 한다.
      FrmMain.SendLogin(LoginId, LoginPasswd);
      EdId.Text     := '';
      EdPasswd.Text := '';
      EdId.Visible  := False;
      EdPasswd.Visible := False;
    end else if (EdId.Visible) and (EdId.Text = '') then
      EdId.SetFocus;
  end;
end;

procedure TLoginScene.PassWdFail;
begin
  EdId.Visible     := True;
  EdPasswd.Visible := True;
  EdId.SetFocus;
end;


function TLoginScene.NewIdCheckNewId: boolean;
begin
  Result := True;
  EdNewId.Text := Trim(EdNewId.Text);
  if Length(EdNewId.Text) < 3 then begin
    //FrmDlg.DMessageDlg ('The ID on account should be at least 3 letters.', [mbOk]);
    Beep;
    EdNewId.SetFocus;
    Result := False;
  end;
end;

function TLoginScene.NewIdCheckSSno: boolean;
var
  str, t1, t2, t3, syear, smon, sday: string;
  ayear, amon, aday, sex: integer;
  flag: boolean;
begin
  Result := True;
  str    := EdSSNo.Text;
  str    := GetValidStr3(str, t1, ['-']);
  GetValidStr3(str, t2, ['-']);
  flag := True;
  if (Length(t1) = 6) and (Length(t2) = 7) then begin
    smon := Copy(t1, 3, 2);
    sday := Copy(t1, 5, 2);
    amon := Str_ToInt(smon, 0);
    aday := Str_ToInt(sday, 0);
    if (amon <= 0) or (amon > 12) then
      flag := False;
    if (aday <= 0) or (aday > 31) then
      flag := False;
    sex := Str_ToInt(Copy(t2, 1, 1), 0);
    if (sex <= 0) or (sex > 2) then
      flag := False;
  end else
    flag := False;
  if not flag then begin
    Beep;
    EdSSNo.SetFocus;
    Result := False;
  end;
end;

function TLoginScene.NewIdCheckBirthDay: boolean;
var
  str, t1, t2, t3, syear, smon, sday: string;
  ayear, amon, aday, sex: integer;
  flag: boolean;
begin
  Result := True;
  flag   := True;
  str    := EdBirthDay.Text;
  str    := GetValidStr3(str, syear, ['/']);
  str    := GetValidStr3(str, smon, ['/']);
  str    := GetValidStr3(str, sday, ['/']);
  ayear  := Str_ToInt(syear, 0);
  amon   := Str_ToInt(smon, 0);
  aday   := Str_ToInt(sday, 0);
  if (ayear <= 1890) or (ayear > 2101) then
    flag := False;
  if (amon <= 0) or (amon > 12) then
    flag := False;
  if (aday <= 0) or (aday > 31) then
    flag := False;
  if not flag then begin
    Beep;
    EdBirthDay.SetFocus;
    Result := False;
  end;
end;

procedure TLoginScene.EdNewIdKeyPress(Sender: TObject; var Key: char);
var
  str, t1, t2, t3, syear, smon, sday: string;
  ayear, amon, aday, sex: integer;
  flag: boolean;
begin
  if (Sender = EdNewPasswd) or (Sender = EdChgNewPw) or (Sender = EdChgRepeat) then
    if (Key = '~') or (Key = '''') or (Key = ' ') then
      Key := #0;
  if Key = #13 then begin
    Key := #0;
    if Sender = EdNewId then begin
      if not NewIdCheckNewId then
        exit;
    end;
    if Sender = EdNewPasswd then begin
      if Length(EdNewPasswd.Text) < 4 then begin
        //FrmDlg.DMessageDlg ('Password should be over 4 letters.', [mbOk]);
        Beep;
        EdNewPasswd.SetFocus;
        exit;
      end;
    end;
    if Sender = EdConfirm then begin
      if EdNewPasswd.Text <> EdConfirm.Text then begin
        //FrmDlg.DMessageDlg ('Password confirmation is wrong. Please input again.', [mbOk]);
        Beep;
        EdConfirm.SetFocus;
        exit;
      end;
    end;
    if (Sender = EdYourName) or (Sender = EdQuiz1) or (Sender = EdAnswer1) or
      (Sender = EdQuiz2) or (Sender = EdAnswer2) or (Sender = EdPhone) or
      (Sender = EdMobPhone) or (Sender = EdEMail) then begin
      TEdit(Sender).Text := Trim(TEdit(Sender).Text);
      if TEdit(Sender).Text = '' then begin
        Beep;
        TEdit(Sender).SetFocus;
        exit;
      end;
    end;
    if (Sender = EdSSNo) and (KoreanVersion) then begin
      //한국인 경우.. 주민등록번호 간략 채크
      if not NewIdCheckSSno then
        exit;
    end;
    if Sender = EdBirthDay then begin
      if not NewIdCheckBirthDay then
        exit;
    end;
    if TEdit(Sender).Text <> '' then begin
      if Sender = EdNewId then
        EdNewPasswd.SetFocus;
      if Sender = EdNewPasswd then
        EdConfirm.SetFocus;
      if Sender = EdConfirm then
        EdYourName.SetFocus;
      if Sender = EdYourName then
        EdSSNo.SetFocus;
      if Sender = EdSSNo then
        EdBirthDay.SetFocus;
      if Sender = EdBirthDay then
        EdQuiz1.SetFocus;
      if Sender = EdQuiz1 then
        EdAnswer1.SetFocus;
      if Sender = EdAnswer1 then
        EdQuiz2.SetFocus;
      if Sender = EdQuiz2 then
        EdAnswer2.SetFocus;
      if Sender = EdAnswer2 then
        EdPhone.SetFocus;
      if Sender = EdPhone then
        EdMobPhone.SetFocus;
      if Sender = EdMobPhone then
        EdEMail.SetFocus;
      if Sender = EdEMail then begin
        if EdNewId.Enabled then
          EdNewId.SetFocus
        else if EdNewPasswd.Enabled then
          EdNewPasswd.SetFocus;
      end;

      if Sender = EdChgId then
        EdChgCurrentPw.SetFocus;
      if Sender = EdChgCurrentPw then
        EdChgNewPw.SetFocus;
      if Sender = EdChgNewPw then
        EdChgRepeat.SetFocus;
      if Sender = EdChgRepeat then
        EdChgId.SetFocus;
    end;
  end;
end;

procedure TLoginScene.EdNewOnEnter(Sender: TObject);
var
  hx, hy: integer;
begin
  //힌트
  FrmDlg.NAHelps.Clear;
  hx := TEdit(Sender).Left + TEdit(Sender).Width + 10;
  hy := TEdit(Sender).Top + TEdit(Sender).Height - 18;
  if Sender = EdNewId then begin
    FrmDlg.NAHelps.Add('Your ID can be a combination of');
    FrmDlg.NAHelps.Add('characters and numbers and');
    FrmDlg.NAHelps.Add('it must be a minimum of 4 letters.');
    FrmDlg.NAHelps.Add('Your ID is not your character');
    FrmDlg.NAHelps.Add('name in the game, Choose your ID');
    FrmDlg.NAHelps.Add('carefully, because it is essential');
    FrmDlg.NAHelps.Add(' to use all our services.');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('We suggest you use a different');
    FrmDlg.NAHelps.Add('name from the one you would like');
    FrmDlg.NAHelps.Add('to use for your character.');
  end;
  if Sender = EdNewPasswd then begin
    FrmDlg.NAHelps.Add('Your password can be a');
    FrmDlg.NAHelps.Add('combination of characters');
    FrmDlg.NAHelps.Add('and numbers and it must be a');
    FrmDlg.NAHelps.Add('minimum of 4 letters.');
    FrmDlg.NAHelps.Add('Remember that your password is');
    FrmDlg.NAHelps.Add('essential to play our game,');
    FrmDlg.NAHelps.Add('so be sure to make a note of it.');
    FrmDlg.NAHelps.Add('We advise you to not use');
    FrmDlg.NAHelps.Add('a simple password');
    FrmDlg.NAHelps.Add('to avoid the risk');
    FrmDlg.NAHelps.Add('of account hacking.');
  end;
  if Sender = EdConfirm then begin
    FrmDlg.NAHelps.Add('type password again');
    FrmDlg.NAHelps.Add('for confirmation.');
  end;
  if Sender = EdYourName then begin
    FrmDlg.NAHelps.Add('type your full name.');
  end;
  if Sender = EdSSNo then begin
    FrmDlg.NAHelps.Add('Not used');
    FrmDlg.NAHelps.Add('at this time.');
  end;
  if Sender = EdBirthDay then begin
    FrmDlg.NAHelps.Add('Please type your birth date, month,');
    FrmDlg.NAHelps.Add('years. ex)1975/08/21)');
  end;
  if Sender = EdQuiz1 then begin
    FrmDlg.NAHelps.Add('Please type a question only');
    FrmDlg.NAHelps.Add('you know the answer to.');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = EdAnswer1 then begin
    FrmDlg.NAHelps.Add('please type an answer to the');
    FrmDlg.NAHelps.Add('above question.');
  end;
  if Sender = EdQuiz2 then begin
    FrmDlg.NAHelps.Add('Please type a question only');
    FrmDlg.NAHelps.Add('you know the answer to.');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = EdAnswer2 then begin
    FrmDlg.NAHelps.Add('please type an answer to the');
    FrmDlg.NAHelps.Add('above question.');
  end;
  if (Sender = EdYourName) or (Sender = EdSSNo) or (Sender = EdQuiz1) or
    (Sender = EdQuiz2) or (Sender = EdAnswer1) or (Sender = EdAnswer2) then begin
    FrmDlg.NAHelps.Add('You are solely responsible');
    FrmDlg.NAHelps.Add('for the information you give us');
    FrmDlg.NAHelps.Add('if you use false information,');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('You will not be able to use');
    FrmDlg.NAHelps.Add('all our services.');
    FrmDlg.NAHelps.Add('Your account may be removed');
    FrmDlg.NAHelps.Add('if you provide ');
    FrmDlg.NAHelps.Add('false information.');
  end;

  if Sender = EdPhone then begin
    FrmDlg.NAHelps.Add('Please type in your telephone');
    FrmDlg.NAHelps.Add('number(compulsory).');
  end;
  if Sender = EdMobPhone then begin
    FrmDlg.NAHelps.Add('Your mobile telephone number');
  end;
  if Sender = EdEMail then begin
    FrmDlg.NAHelps.Add('Please type your E-mail address.');
    FrmDlg.NAHelps.Add('Your E-mail will be used to access');
    FrmDlg.NAHelps.Add('some of our services. You can');
    FrmDlg.NAHelps.Add('receive latest update information.');
  end;
end;

procedure TLoginScene.HideLoginBox;
begin
  //EdId.Visible := FALSE;
  //EdPasswd.Visible := FALSE;
  //FrmDlg.DLogin.Visible := FALSE;
  ChangeLoginState(lsCloseAll);
end;

procedure TLoginScene.OpenLoginDoor;
begin
  NowOpening := True;
  StartTime  := GetTickCount;
  HideLoginBox;
  PlaySound(s_rock_door_open);
end;

procedure TLoginScene.PlayScene(MSurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  //if not ServerConnected then exit;
  if BoOpenFirst then begin
    BoOpenFirst      := False;
    EdId.Visible     := True;
    EdPasswd.Visible := True;
    EdId.SetFocus;
  end;
  d := FrmMain.WChrSel.Images[0];
  if d <> nil then begin
    MSurface.Draw ((SCREENWIDTH - 800) div 2, (SCREENHEIGHT - 600) div 2, d.ClientRect, d, FALSE);
  end;
  if NowOpening then begin
    if GetTickCount - StartTime > 130 then begin
      StartTime := GetTickCount;
      Inc(CurFrame);
    end;
    if CurFrame >= MaxFrame - 1 then begin
      CurFrame := MaxFrame - 1;
      if not DoFadeOut and not DoFadeIn then begin
        DoFadeOut := True;
        DoFadeIn  := True;
        FadeIndex := 29;
      end;
    end;
    d := FrmMain.WChrSel.Images[CurFrame+1];
    if d <> nil then
      MSurface.Draw (0, 0, d.ClientRect, d, TRUE);

    if DoFadeOut then begin
      if FadeIndex <= 1 then begin
        FrmMain.WProgUse.ClearCache;
        FrmMain.WChrSel.ClearCache;
        DScreen.ChangeScene(stSelectChr);
        //서버에서 캐릭터 정보가 오면 선택창으로 넘어간다.
      end;
    end;
  end;
end;

procedure TLoginScene.ChangeLoginState(state: TLoginState);
var
  i, focus: integer;
  c: TControl;
begin
  focus := -1;
  case state of
    lsLogin: focus    := 10;
    lsNewIdRetry, lsNewId: focus := 11;
    lsChgpw: focus    := 12;
    lsCloseAll: focus := -1;
  end;
  with FrmMain do begin  //login
    for i := 0 to ControlCount - 1 do begin
      c := Controls[i];
      if c is TEdit then begin
        if c.Tag in [10..12] then begin
          if c.Tag = focus then begin
            c.Visible     := True;
            TEdit(c).Text := '';
          end else begin
            c.Visible     := False;
            TEdit(c).Text := '';
          end;
        end;
      end;
    end;
    if not KoreanVersion then  //영문버전은 주민등록번호 입력을 안한다.
      EdSSNo.Visible := False;

    case state of
      lsLogin: begin
        FrmDlg.DNewAccount.Visible := False;
        FrmDlg.DChgPw.Visible      := False;
        FrmDlg.DLogin.Visible      := True;
        if EdId.Visible then
          EdId.SetFocus;
      end;
      lsNewIdRetry,
      lsNewId: begin
        if BoUpdateAccountMode then
          EdNewId.Enabled := False
        else
          EdNewId.Enabled := True;
        FrmDlg.DNewAccount.Visible := True;
        FrmDlg.DChgPw.Visible := False;
        FrmDlg.DLogin.Visible := False;
        if EdNewId.Visible and EdNewId.Enabled then begin
          EdNewId.SetFocus;
        end else begin
          if EdConfirm.Visible and EdConfirm.Enabled then
            EdConfirm.SetFocus;
        end;
      end;
      lsChgpw: begin
        FrmDlg.DNewAccount.Visible := False;
        FrmDlg.DChgPw.Visible      := True;
        FrmDlg.DLogin.Visible      := False;
        if EdChgId.Visible then
          EdChgId.SetFocus;
      end;
      lsCloseAll: begin
        FrmDlg.DNewAccount.Visible := False;
        FrmDlg.DChgPw.Visible      := False;
        FrmDlg.DLogin.Visible      := False;
      end;
    end;
  end;
end;

procedure TLoginScene.NewClick;
begin
  BoUpdateAccountMode    := False;
  FrmDlg.NewAccountTitle := '';
  ChangeLoginState(lsNewId);
end;

procedure TLoginScene.NewIdRetry(boupdate: boolean);
begin
  BoUpdateAccountMode := boupdate;
  ChangeLoginState(lsNewidRetry);
  EdNewId.Text     := NewIdRetryUE.LoginId;
  EdNewPasswd.Text := NewIdRetryUE.Password;
  EdYourName.Text  := NewIdRetryUE.UserName;
  EdSSNo.Text      := NewIdRetryUE.SSNo;
  EdQuiz1.Text     := NewIdRetryUE.Quiz;
  EdAnswer1.Text   := NewIdRetryUE.Answer;
  EdPhone.Text     := NewIdRetryUE.Phone;
  EdEMail.Text     := NewIdRetryUE.EMail;
  EdQuiz2.Text     := NewIdRetryAdd.Quiz2;
  EdAnswer2.Text   := NewIdRetryAdd.Answer2;
  EdMobPhone.Text  := NewIdRetryAdd.MobilePhone;
  EdBirthDay.Text  := NewIdRetryAdd.BirthDay;
end;

procedure TLoginScene.UpdateAccountInfos(ue: TUserEntryInfo);
begin
  NewIdRetryUE := ue;
  FillChar(NewIdRetryAdd, sizeof(TUserEntryAddInfo), #0);
  BoUpdateAccountMode := True; //기존에 있는 정보를 재입력하는 경우
  NewIdRetry(True);
  FrmDlg.NewAccountTitle :=
    '(Please complete all the required fields of the account information)';
end;

procedure TLoginScene.OkClick;
var
  key: char;
begin
  key := #13;
  EdLoginPasswdKeyPress(self, key);
end;

procedure TLoginScene.ChgPwClick;
begin
  ChangeLoginState(lsChgPw);
end;

function TLoginScene.CheckUserEntrys: boolean;
begin
  Result := False;
  EdNewId.Text := Trim(EdNewId.Text);
  EdQuiz1.Text := Trim(EdQuiz1.Text);
  EdYourName.Text := Trim(EdYourName.Text);
  if not NewIdCheckNewId then
    exit;

  if KoreanVersion then begin //영문 버전에서는 체크안함
    if not NewIdCheckSSNo then
      exit;
  end;

  if not NewIdCheckBirthday then
    exit;
  if Length(EdNewId.Text) < 3 then begin
    EdNewId.SetFocus;
    exit;
  end;
  if Length(EdNewPasswd.Text) < 3 then begin
    EdNewPasswd.SetFocus;
    exit;
  end;
  if EdNewPasswd.Text <> EdConfirm.Text then begin
    EdConfirm.SetFocus;
    exit;
  end;
  if Length(EdQuiz1.Text) < 1 then begin
    EdQuiz1.SetFocus;
    exit;
  end;
  if Length(EdAnswer1.Text) < 1 then begin
    EdAnswer1.SetFocus;
    exit;
  end;
  if Length(EdQuiz2.Text) < 1 then begin
    EdQuiz2.SetFocus;
    exit;
  end;
  if Length(EdAnswer2.Text) < 1 then begin
    EdAnswer2.SetFocus;
    exit;
  end;
  if Length(EdYourName.Text) < 1 then begin
    EdYourName.SetFocus;
    exit;
  end;
  if KoreanVersion then begin //영문 버전에서는 체크안함
    if Length(EdSSNo.Text) < 1 then begin
      EdSSNo.SetFocus;
      exit;
    end;
  end;
  Result := True;
end;

procedure TLoginScene.NewAccountOk;
var
  ue: TUserEntryInfo;
  ua: TUserEntryAddInfo;
begin
  if CheckUserEntrys then begin
    FillChar(ue, sizeof(TUserEntryInfo), #0);
    FillChar(ua, sizeof(TUserEntryAddInfo), #0);

    //2003-09-05 delete... PDS
    ue.LoginId  := '';//LowerCase(EdNewId.Text);
    ue.Password := '';//EdNewPasswd.Text;
    ue.UserName := '';//EdYourName.Text;


    if KoreanVersion then
      ue.SSNo := EdSSNo.Text
    else
      ue.SSNo := '650101-1455111';

    ue.Quiz   := EdQuiz1.Text;
    ue.Answer := Trim(EdAnswer1.Text);
    ue.Phone  := EdPhone.Text;
    ue.EMail  := Trim(EdEMail.Text);

    ua.Quiz2    := EdQuiz2.Text;
    ua.Answer2  := Trim(EdAnswer2.Text);
    ua.Birthday := EdBirthday.Text;
    ua.MobilePhone := EdMobPhone.Text;

    NewIdRetryUE  := ue;    //재시도때 사용
    NewIdRetryUE.LoginId := '';
    NewIdRetryUE.Password := '';
    NewIdRetryAdd := ua;

    if not BoUpdateAccountMode then
      FrmMain.SendNewAccount(ue, ua)
    else
      FrmMain.SendUpdateAccount(ue, ua);
    BoUpdateAccountMode := False;
    NewAccountClose;
  end;
end;

procedure TLoginScene.NewAccountClose;
begin
  if not BoUpdateAccountMode then
    ChangeLoginState(lsLogin);
end;

procedure TLoginScene.ChgpwOk;
var
  uid, passwd, newpasswd: string;
begin
  if EdChgNewPw.Text = EdChgRepeat.Text then begin
    uid    := EdChgId.Text;
    passwd := EdChgCurrentPw.Text;
    newpasswd := EdChgNewPw.Text;
    FrmMain.SendChgPw(uid, passwd, newpasswd);
    ChgpwCancel;
  end else begin
    FrmDlg.DMessageDlg('Password confirmation is not correct.', [mbOK]);
    EdChgNewPw.SetFocus;
  end;
end;

procedure TLoginScene.ChgpwCancel;
begin
  ChangeLoginState(lsLogin);
end;


{-------------------- TSelectChrScene ------------------------}

constructor TSelectChrScene.Create;
begin
  CreateChrMode := False;
  FillChar(ChrArr, sizeof(TSelChar) * 2, #0);
  //ChrArr[0].FreezeState := True; //기본이 얼어 있는 상태
  //ChrArr[1].FreezeState := True;
  NewIndex  := 0;
  EdChrName := TEdit.Create(FrmMain.Owner);
  with EdChrName do begin
    Parent     := FrmMain;
    Height     := 16;
    Width      := 137;
    BorderStyle := bsNone;
    Color      := clBlack;
    Font.Color := clWhite;
    ImeMode    := LocalLanguage;
    MaxLength  := 14;
    Visible    := False;
    OnKeyPress := EdChrnameKeyPress;
  end;
  SoundTimer := TTimer.Create(FrmMain.Owner);
  with SoundTimer do begin
    OnTimer  := SoundOnTimer;
    Interval := 1;
    Enabled  := False;
  end;
  inherited Create(stSelectChr);
end;

destructor TSelectChrScene.Destroy;
begin
  inherited Destroy;
end;

procedure TSelectChrScene.OpenScene;
begin
  FrmDlg.DSelectChr.Visible := True;
  SoundTimer.Enabled  := True;
  SoundTimer.Interval := 1;
end;

procedure TSelectChrScene.CloseScene;
begin
  SilenceSound;
  FrmDlg.DSelectChr.Visible := False;
  SoundTimer.Enabled := False;
end;

procedure TSelectChrScene.SoundOnTimer(Sender: TObject);
begin
  PlayBGM(bmg_select);
  SoundTimer.Enabled := False;
  //SoundTimer.Interval := 38 * 1000;
end;

procedure TSelectChrScene.SelChrSelect1Click;
begin
  if (not ChrArr[0].Selected) and (ChrArr[0].Valid) then begin
    ChrArr[0].Selected     := True;
    ChrArr[1].Selected     := False;
    //ChrArr[0].Unfreezing   := True;
    ChrArr[0].AniIndex     := 0;
    ChrArr[0].DarkLevel    := 0;
    ChrArr[0].EffIndex     := 0;
    ChrArr[0].StartTime    := GetTickCount;
    ChrArr[0].MoreTime     := GetTickCount;
    ChrArr[0].StartEffTime := GetTickCount;
    PlaySound(s_meltstone);
  end;
end;

procedure TSelectChrScene.SelChrSelect2Click;
begin
  if (not ChrArr[1].Selected) and (ChrArr[1].Valid) then begin
    ChrArr[1].Selected     := True;
    ChrArr[0].Selected     := False;
    //ChrArr[1].Unfreezing   := True;
    ChrArr[1].AniIndex     := 0;
    ChrArr[1].DarkLevel    := 0;
    ChrArr[1].EffIndex     := 0;
    ChrArr[1].StartTime    := GetTickCount;
    ChrArr[1].MoreTime     := GetTickCount;
    ChrArr[1].StartEffTime := GetTickCount;
    PlaySound(s_meltstone);
  end;
end;

procedure TSelectChrScene.SelChrStartClick;
var
  chrname: string;
begin
  chrname := '';
  if ChrArr[0].Valid and ChrArr[0].Selected then begin
    if ChrArr[0].UserChr.EncName = DecodeString(ChrArr[0].UserChr.EncEncName) then
      chrname := ChrArr[0].UserChr.EncName
    else
      Exit;
  end;
  if ChrArr[1].Valid and ChrArr[1].Selected then begin
    if ChrArr[1].UserChr.EncName = DecodeString(ChrArr[1].UserChr.EncEncName) then
      chrname := ChrArr[1].UserChr.EncName
    else
      Exit;
  end;

  if chrname <> '' then begin
    if not DoFadeOut and not DoFadeIn then begin
      DoFastFadeOut := True;
      FadeIndex     := 29;
    end;
    FrmMain.SendSelChr(chrname);
  end else
    FrmDlg.DMessageDlg(
      'At first you should make new character .\If you select <NEW CHARACTER> you can make a new character.',
      [mbOK]);
end;

procedure TSelectChrScene.SelChrNewChrClick;
begin
  if not ChrArr[0].Valid or not ChrArr[1].Valid then begin
    if not ChrArr[0].Valid then
      MakeNewChar(0)
    else
      MakeNewChar(1);
  end else
    FrmDlg.DMessageDlg(
      'You can have up to 2 characters per server for every single account.', [mbOK]);
end;

procedure TSelectChrScene.SelChrEraseChrClick;
var
  n: integer;
  charname: string;
begin
  n := 0;
  if ChrArr[0].Valid and ChrArr[0].Selected then
    n := 0;
  if ChrArr[1].Valid and ChrArr[1].Selected then
    n := 1;
  charname := DecodeString(ChrArr[n].UserChr.EncName);
  if (ChrArr[n].Valid) and (charname <> '') then begin
    //경고 메세지를 보낸다.
    if mrYes = FrmDlg.DMessageDlg('"' + charName +
      '" Removed characters may not be restored.\You will not be able to use the same charcter name for a while.\Are you sure you want to delete character?', [mbYes, mbNo, mbCancel]) then
      FrmMain.SendDelChr(ChrArr[n].UserChr.EncName);
  end;
end;

procedure TSelectChrScene.SelChrCreditsClick;
begin
end;

procedure TSelectChrScene.SelChrExitClick;
begin
  FrmMain.Close;
end;

procedure TSelectChrScene.ClearChrs;
begin
  FillChar(ChrArr, sizeof(TSelChar) * 2, #0);
  //ChrArr[0].FreezeState := False;
  //ChrArr[1].FreezeState := True; //기본이 얼어 있는 상태
  ChrArr[0].Selected    := True;
  ChrArr[1].Selected    := False;
  ChrArr[0].UserChr.EncName := '';
  ChrArr[1].UserChr.EncName := '';
end;

procedure TSelectChrScene.AddChr(uname: string; job, hair, level, sex: integer);
var
  n: integer;
begin
  if not ChrArr[0].Valid then
    n := 0
  else if not ChrArr[1].Valid then
    n := 1
  else
    exit;
  ChrArr[n].UserChr.EncName := EncodeString(uname);
  ChrArr[n].UserChr.Job := job;
  ChrArr[n].UserChr.Hair := hair;
  ChrArr[n].UserChr.Level := level;
  ChrArr[n].UserChr.Sex := sex;
  ChrArr[n].Valid := True;
  ChrArr[n].UserChr.EncEncName := EncodeString(EncodeString(uname));
end;

procedure TSelectChrScene.MakeNewChar(index: integer);
begin
  CreateChrMode := True;
  NewIndex      := index;
  {if index = 0 then begin
    FrmDlg.DCreateChr.Left := 75;
    FrmDlg.DCreateChr.Top  := 15;
  end else begin}
    FrmDlg.DCreateChr.Left := 75;
    FrmDlg.DCreateChr.Top  := 15;
  //end;
  FrmDlg.DCreateChr.Visible := True;
  ChrArr[NewIndex].Valid := True;
  //ChrArr[NewIndex].FreezeState := False;
  EdChrName.Left    := FrmDlg.DCreateChr.Left + 387;
  EdChrName.Top     := FrmDlg.DCreateChr.Top + 140;
  EdChrName.Visible := True;
  EdChrName.SetFocus;
  SelectChr(NewIndex);
  FillChar(ChrArr[NewIndex].UserChr, sizeof(TUserCharacterInfo), #0);
end;

procedure TSelectChrScene.EdChrnameKeyPress(Sender: TObject; var Key: char);
begin

end;

function TSelectChrScene.GetJobName(job: integer): string;
begin
  Result := '';
  case job of
    0: Result := 'Warrior';
    1: Result := 'Wizard';
    2: Result := 'Taoist';
    3: Result := 'Assassin'; // SEAN - 29/12/08 - Future usage
  end;
end;

procedure TSelectChrScene.SelectChr(index: integer);
begin
  ChrArr[index].Selected  := True;
  ChrArr[index].DarkLevel := 30;
  ChrArr[index].starttime := GetTickCount;
  ChrArr[index].Moretime  := GetTickCount;
  if index = 0 then
    ChrArr[1].Selected := False
  else
    ChrArr[0].Selected := False;
end;

procedure TSelectChrScene.SelChrNewClose;
begin
  ChrArr[NewIndex].Valid := False;
  CreateChrMode     := False;
  FrmDlg.DCreateChr.Visible := False;
  EdChrName.Visible := False;
  if NewIndex = 1 then begin
    ChrArr[0].Selected    := True;
    //ChrArr[0].FreezeState := False;
  end;
end;

procedure TSelectChrScene.SelChrNewOk;
var
  chrname, shair, sjob, ssex: string;
begin
  chrname := Trim(EdChrName.Text);
  if chrname <> '' then begin
    ChrArr[NewIndex].Valid := False;
    CreateChrMode     := False;
    FrmDlg.DCreateChr.Visible := False;
    EdChrName.Visible := False;
    if NewIndex = 1 then begin
      ChrArr[0].Selected    := True;
      //ChrArr[0].FreezeState := False;
    end;

    shair := IntToStr(1 + Random(5));
    //////****IntToStr(ChrArr[NewIndex].UserChr.Hair);
    sjob  := IntToStr(ChrArr[NewIndex].UserChr.Job);
    ssex  := IntToStr(ChrArr[NewIndex].UserChr.Sex);
    FrmMain.SendNewChr(FrmMain.LoginId, chrname, shair, sjob, ssex);
    //새 캐릭터를 만든다.
  end;
end;

procedure TSelectChrScene.SelChrNewJob(job: integer);
begin
  if (job in [0..3]) and (ChrArr[NewIndex].UserChr.Job <> job) then begin
    ChrArr[NewIndex].UserChr.Job := job;
    SelectChr(NewIndex);
  end;
end;

procedure TSelectChrScene.SelChrNewSex(sex: integer);
begin
  if sex <> ChrArr[NewIndex].UserChr.Sex then begin
    ChrArr[NewIndex].UserChr.Sex := sex;
    SelectChr(NewIndex);
  end;
end;

procedure TSelectChrScene.SelChrNewPrevHair;
begin
end;

procedure TSelectChrScene.SelChrNewNextHair;
begin
end;

procedure TSelectChrScene.PlayScene(MSurface: TDirectDrawSurface);
var
  n, bx, by, ex, ey, fx, fy, img: integer;
  d, e, dd: TDirectDrawSurface;
  svname:   string;
begin
  d := FrmMain.WProgUse.Images[65];
  if d <> nil then begin
    MSurface.Draw ((SCREENWIDTH - d.Width) div 2,(SCREENHEIGHT - d.Height) div 2, d.ClientRect, d, FALSE);
  end;

  SetBkMode(MSurface.Canvas.Handle, TRANSPARENT);

  if (ChrArr[0].Selected) then begin
    BoldTextOut(MSurface, 200 - MSurface.Canvas.TextWidth(DecodeString(ChrArr[0].UserChr.EncName)) div 2,
                          465, clWhite, clBlack, DecodeString(ChrArr[0].UserChr.EncName));
    FrmDlg.DscSelect1.SetImgIndex(FrmMain.WProgUse, 94 + ChrArr[0].UserChr.Job);
  end else if (ChrArr[0].Valid) then
    FrmDlg.DscSelect1.SetImgIndex(FrmMain.WProgUse, 90 + ChrArr[0].UserChr.Job)
  else
    FrmDlg.DscSelect1.SetImgIndex(FrmMain.WProgUse, 44);

  if (ChrArr[1].Selected) then begin
    BoldTextOut(MSurface, 200 - MSurface.Canvas.TextWidth(DecodeString(ChrArr[1].UserChr.EncName)) div 2,
                          465, clWhite, clBlack, DecodeString(ChrArr[1].UserChr.EncName));
    FrmDlg.DscSelect2.SetImgIndex(FrmMain.WProgUse, 94 + ChrArr[1].UserChr.Job);
  end else if (ChrArr[1].Valid) then
    FrmDlg.DscSelect2.SetImgIndex(FrmMain.WProgUse, 90 + ChrArr[1].UserChr.Job)
  else
    FrmDlg.DscSelect2.SetImgIndex(FrmMain.WProgUse, 44);

  FrmDlg.DscSelect3.SetImgIndex(FrmMain.WProgUse, 45);
  FrmDlg.DscSelect4.SetImgIndex(FrmMain.WProgUse, 45);

  MSurface.Canvas.Release;

  // First char
  d := FrmMain.WProgUse.Images[FrmDlg.DscSelect1.FaceIndex];
  if d <> nil then
    MSurface.Draw(FrmDlg.DscSelect1.Left,
                  FrmDlg.DscSelect1.Top, d.ClientRect, d, True);

  // Second char
  d := FrmMain.WProgUse.Images[FrmDlg.DscSelect2.FaceIndex];
  if d <> nil then
    MSurface.Draw(FrmDlg.DscSelect2.Left,
                  FrmDlg.DscSelect2.Top, d.ClientRect, d, True);

  // Third char
  d := FrmMain.WProgUse.Images[FrmDlg.DscSelect3.FaceIndex];
  if d <> nil then
    MSurface.Draw(FrmDlg.DscSelect3.Left,
                  FrmDlg.DscSelect3.Top, d.ClientRect, d, True);

  for n := 0 to 1 do begin
    if ChrArr[n].Valid then begin
      {ex := (SCREENWIDTH - 800) div 2 + 90;
      ey := (SCREENHEIGHT - 600) div 2 + 58;
      bx := 0;
      by := 0;
      fx := 0;
      fy := 0;
      case ChrArr[n].UserChr.Job of
        0: begin
          if ChrArr[n].UserChr.Sex = 0 then begin
            bx := (SCREENWIDTH - 800) div 2 + 138;
            by := (SCREENHEIGHT - 600) div 2 + 211;
            fx := bx;
            fy := by;
          end else begin
            bx := (SCREENWIDTH - 800) div 2 + 121;
            by := (SCREENHEIGHT - 600) div 2 + 197;
            fx := bx;
            fy := by;
          end;
        end;
        1: begin
          if ChrArr[n].UserChr.Sex = 0 then begin
            bx := (SCREENWIDTH - 800) div 2 + 130;
            by := (SCREENHEIGHT - 600) div 2 + 200;
            fx := bx;
            fy := by;
          end else begin
            bx := (SCREENWIDTH - 800) div 2 + 135;
            by := (SCREENHEIGHT - 600) div 2 + 217;
            fx := bx;
            fy := by;
          end;
        end;
        2: begin
          if ChrArr[n].UserChr.Sex = 0 then begin
           bx := (SCREENWIDTH - 800) div 2 + 138;
           by := (SCREENHEIGHT - 600) div 2 + 205;
           fx := bx;
           fy := by;
          end else begin
           bx := (SCREENWIDTH - 800) div 2 + 130;
           by := (SCREENHEIGHT - 600) div 2 + 229;
           fx := bx;
           fy := by;
          end;
        end;
      end;
      if n = 1 then begin
        ex := (SCREENWIDTH - 800) div 2;
        ey := (SCREENHEIGHT - 600) div 2;
        bx := bx + 240*n;
        by := by;
        fx := fx + 240*n;
        fy := fy ;
      end;
      if ChrArr[n].Unfreezing then begin //녹고 있는 중
        img := 40 + ChrArr[n].UserChr.Job * 40 + ChrArr[n].UserChr.Sex * 120;
        d   := FrmMain.WChrSel.Images[img + ChrArr[n].aniIndex];
        e   := FrmMain.WChrSel.Images[4 + ChrArr[n].effIndex];
        if d <> nil then
          MSurface.Draw(bx, by, d.ClientRect, d, True);
        if e <> nil then
          DrawBlend(MSurface, ex, ey, e, 1);
        if GetTickCount - ChrArr[n].starttime > 120 then begin
          ChrArr[n].starttime := GetTickCount;
          ChrArr[n].aniIndex  := ChrArr[n].aniIndex + 1;
        end;
        if GetTickCount - ChrArr[n].startefftime > 110 then begin
          ChrArr[n].startefftime := GetTickCount;
          ChrArr[n].effIndex     := ChrArr[n].effIndex + 1;
          //if ChrArr[n].effIndex > EFFECTFRAME-1 then
          //   ChrArr[n].effIndex := EFFECTFRAME-1;
        end;
        if ChrArr[n].aniIndex > FREEZEFRAME - 1 then begin
          ChrArr[n].Unfreezing  := False; //다 녹았음
          ChrArr[n].FreezeState := False;
          ChrArr[n].aniIndex    := 0;
        end;
      end else if not ChrArr[n].Selected and
        (not ChrArr[n].FreezeState and not ChrArr[n].Freezing) then begin
        //선택되지 않았는데 녹아있으면
        ChrArr[n].Freezing  := True;
        ChrArr[n].aniIndex  := 0;
        ChrArr[n].starttime := GetTickCount;
      end;
      if ChrArr[n].Freezing then begin //얼고 있는 중
        img := 140 - 80 + ChrArr[n].UserChr.Job * 40 + ChrArr[n].UserChr.Sex * 120;
        d   := FrmMain.WChrSel.Images[img + FREEZEFRAME - ChrArr[n].aniIndex - 1];
        if d <> nil then
          MSurface.Draw(bx, by, d.ClientRect, d, True);
        if GetTickCount - ChrArr[n].starttime > 50 then begin
          ChrArr[n].starttime := GetTickCount;
          ChrArr[n].aniIndex  := ChrArr[n].aniIndex + 1;
        end;
        if ChrArr[n].aniIndex > FREEZEFRAME - 1 then begin
          ChrArr[n].Freezing    := False; //다 얼었음
          ChrArr[n].FreezeState := True;
          ChrArr[n].aniIndex    := 0;
        end;
      end;
      if not ChrArr[n].Unfreezing and not ChrArr[n].Freezing then begin
        if not ChrArr[n].FreezeState then begin  //녹아있는상태
          img := 120 - 80 + ChrArr[n].UserChr.Job * 40 +
            ChrArr[n].aniIndex + ChrArr[n].UserChr.Sex * 120;
          d   := FrmMain.WChrSel.Images[img];
          if d <> nil then begin
            if ChrArr[n].DarkLevel > 0 then begin
              dd := TDirectDrawSurface.Create(FrmMain.DXDraw1.DDraw);
              dd.SystemMemory := True;
              dd.SetSize(d.Width, d.Height);
              dd.Draw(0, 0, d.ClientRect, d, False);
              MakeDark(dd, 30 - ChrArr[n].DarkLevel);
              MSurface.Draw(fx, fy, dd.ClientRect, dd, True);
              dd.Free;
            end else
              MSurface.Draw(fx, fy, d.ClientRect, d, True);

          end;
        end else begin      //얼어있는상태
          img := 140 - 80 + ChrArr[n].UserChr.Job * 40 +
            ChrArr[n].UserChr.Sex * 120;
          d   := FrmMain.WChrSel.Images[img];
          if d <> nil then
            MSurface.Draw(bx, by, d.ClientRect, d, True);
        end;
        if ChrArr[n].Selected then begin
          if GetTickCount - ChrArr[n].starttime > 300 then begin
            ChrArr[n].starttime := GetTickCount;
            ChrArr[n].aniIndex  := ChrArr[n].aniIndex + 1;
            if ChrArr[n].aniIndex > SELECTEDFRAME - 1 then
              ChrArr[n].aniIndex := 0;
          end;
          if GetTickCount - ChrArr[n].moretime > 25 then begin
            ChrArr[n].moretime := GetTickCount;
            if ChrArr[n].DarkLevel > 0 then
              ChrArr[n].DarkLevel := ChrArr[n].DarkLevel - 1;
          end;
        end;
      end;
      }
      if ChrArr[n].UserChr.EncName <> '' then begin
        with MSurface do begin

          SetBkMode(Canvas.Handle, TRANSPARENT);

          case n of
            0 : begin

              BoldTextOut(MSurface, FrmDlg.DscSelect1.Left + 114,
                                    FrmDlg.DscSelect1.Top + 10, clWhite, clBlack,
                DecodeString(ChrArr[n].UserChr.EncName));
              BoldTextOut(MSurface, FrmDlg.DscSelect1.Left + 118,
                                    FrmDlg.DscSelect1.Top + 33, clWhite, clBlack,
                IntToStr(ChrArr[n].UserChr.Level));
              BoldTextOut(MSurface, FrmDlg.DscSelect1.Left + 194,
                                    FrmDlg.DscSelect1.Top + 33, clWhite, clBlack,
                GetJobName(ChrArr[n].UserChr.Job));
              end;
            1 : begin
              BoldTextOut(MSurface, FrmDlg.DscSelect2.Left + 114,
                                    FrmDlg.DscSelect2.Top + 10, clWhite, clBlack,
                DecodeString(ChrArr[n].UserChr.EncName));
              BoldTextOut(MSurface, FrmDlg.DscSelect2.Left + 118,
                                    FrmDlg.DscSelect2.Top + 33, clWhite, clBlack,
                IntToStr(ChrArr[n].UserChr.Level));
              BoldTextOut(MSurface, FrmDlg.DscSelect2.Left + 194,
                                    FrmDlg.DscSelect2.Top + 33, clWhite, clBlack,
                GetJobName(ChrArr[n].UserChr.Job));
              end;
          end;

          Canvas.Release;

        end;
      end;

      { SEAN - 29/12/08 - Repeated code... replaced with the case statement above.
      if n = 0 then begin
        if ChrArr[n].UserChr.EncName <> '' then begin
          with MSurface do begin
            SetBkMode(Canvas.Handle, TRANSPARENT);
            BoldTextOut(MSurface, 117, 492 + 2, clWhite, clBlack,
              DecodeString(ChrArr[n].UserChr.EncName));
            BoldTextOut(MSurface, 117, 523, clWhite, clBlack,
              IntToStr(ChrArr[n].UserChr.Level));
            BoldTextOut(MSurface, 117, 553, clWhite, clBlack,
              GetJobName(ChrArr[n].UserChr.Job));
            Canvas.Release;
          end;
        end;
      end else begin
        if ChrArr[n].UserChr.EncName <> '' then begin
          with MSurface do begin
            SetBkMode(Canvas.Handle, TRANSPARENT);
            BoldTextOut(MSurface, 671, 492 + 4, clWhite, clBlack,
              DecodeString(ChrArr[n].UserChr.EncName));
            BoldTextOut(MSurface, 671, 525, clWhite, clBlack,
              IntToStr(ChrArr[n].UserChr.Level));
            BoldTextOut(MSurface, 671, 555, clWhite, clBlack,
              GetJobName(ChrArr[n].UserChr.Job));
            Canvas.Release;
          end;
        end;
      end;}

    end;
  end;

  with MSurface do begin
    SetBkMode(Canvas.Handle, TRANSPARENT);
    if BO_FOR_TEST then
      svname := 'testserver '
    else
      svname := ServerName;
    BoldTextOut(MSurface, 400 - Canvas.TextWidth(svname) div 2, 7,
      clWhite, clBlack, svname);
    Canvas.Release;
  end;
end;


{--------------------------- TLoginNotice ----------------------------}

constructor TLoginNotice.Create;
begin
  inherited Create(stLoginNotice);
end;

destructor TLoginNotice.Destroy;
begin
  inherited Destroy;
end;


end.
