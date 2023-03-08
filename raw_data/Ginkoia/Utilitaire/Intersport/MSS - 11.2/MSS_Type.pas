unit MSS_Type;

interface

uses  SysUtils, MSS_MainClass, Windows, Forms, Inifiles, Classes, StdCtrls,
      Dialogs, Graphics, Controls, Consts;

type
  TFTPCFG = record
    Host     : String;
    UserName : String;
    Password : String;
    Port     : Integer;
    Dossier  : String;
    BaseDir  : String;

    MasterDataVersion : String;
    MasterDataDatas   : String;
    GroupDirCommande  : String;
    GroupDirModif     : String;
  end;

  TMailStruct = record
    Host : String;
    Port : Integer;
    UserName : String;
    PassWord : String;
  end;

  TMainFTPStruct = record
    MasterDataFTP  : TFTPCFG;
    BaseEnCoursFTP : TFTPCFG;
  end;

  TIniStruct = record
//    Database : String;
    IDMDC : String;
    IsDebugMode : Boolean;
    // Utilise ce paramètrage en mode débug
    dbDebugMode : String;
    lgDebugMode : String;
    pwDebugMode : String;
    cgDebugMode : String;
    FTP : TMainFTPStruct;
    // Paramétrage Mail
    Mail : TMailStruct;
    LoopMax : Integer;
    RenameFtpFile : Boolean;
    DeleteFtpfile : Boolean;
  public
    Procedure LoadIni;
    Procedure SaveIni;
  end;

  TMasterDataField = record
    Title : String;
    Path  : String;
    MainData : TMainClass;
  end;

  TTVA = record
    CDE_TVAHT   ,
    CDE_TVATAUX ,
    CDE_TVA     : currency;
  end;

const
  CVERSION = '1.0';
  CPRMTYPE = 12;
  CPRMCODE_BRANDS = 50;
  CPRMCODE_SIZES  = 51;
  CPRMCODE_SUPPLIERS = 52;
  CPRMCODE_UNIVERSCRITERIAS = 53;
  CPRMCODE_COLLECTIONS = 54;
  CPRMCODE_OPCOMMS = 55;
  CPRMCODE_PERIODS = 56;
  CPMCODE_FEDAS    = 57;
  CPRMCODE_CORRESP = 58;

  CKTBID_MARQUE = -11111392;
  CKTBID_COLLECTIONS = -11111381;
  CKTBID_SUPPLIERS = -11111385;
  CKTBID_PERIODS   = -11111339;
  CKTBID_OCTETE    = -11111525;
  CKTBID_OCLIGNE   = -11111526;

  CKTBID_PLXTYPEGT = -11111374;
  CKTBID_PLXGTF    = -11111364;
  CKTBID_PLXTAILLESGF = -11111371;
  CKTBID_PLXGTS       = -11111365;
  CKTBID_PLXTAILLESGS = -11111372;

  CKTBID_NKLSECTEUR = -11111357;
  CKTBID_NKLRAYON   = -11111356;
  CKTBID_NKLFAMILLE = -11111355;
  CKTBID_NKLSSFAMILLE = -11111512;

  CKTBID_ARTARTICLE = -11111375;
  CKTBID_COMBCDE    = -11111435;

  CIMPNUM = 24;
  CIMPNUM_FEDAS = 25;
var
  IniStruct  : TIniStruct;
  MasterData : Array of TMasterDataField;
  GroupData  : Array of TMasterDataField;
  ModifData  : Array of TMasterDataField;
  GAPPPATH   ,
  GLOGSPATH  ,
  GXMLMDPATH ,
  GXMLSCPATH ,
  GFILESDIR ,
  GARCHPATH  ,
  GLOGSNAME,
  GAPPRAPPORT : String;
  bAutoExec  : Boolean;
  bEnTraitement : Boolean;
  TVALignes  : Array of TTVA;

  function InputPassword(const ACaption, APrompt: string;
    var Value: string): Boolean;

  function DoDir (sDirName : String) : Boolean;
  function  DeleteFileIfExist(AFileName : String) : Boolean;

  function DoArchiveFileList(ADataField : Array of TMasterDataField) : Boolean;
  function DoArchiveGroupList(ADataField : Array of TMasterDataField;AGroup : String) : Boolean;

  function DoCryptPass(APass : String) : String;
  function DoUnCryptPass(APass : String) : String;

implementation

function InputPassword(const ACaption, APrompt: string;
  var Value: string): Boolean;

  function GetAveCharSize(Canvas: TCanvas): TPoint;
  {$IF DEFINED(CLR)}
  var
    I: Integer;
    Buffer: string;
    Size: TSize;
  begin
    SetLength(Buffer, 52);
    for I := 0 to 25 do Buffer[I + 1] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 27] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, Size);
    Result.X := Size.cx div 52;
    Result.Y := Size.cy;
  end;
  {$ELSE}
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;
  {$IFEND}

var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      PopupMode := pmAuto;
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        PasswordChar := '*';
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgOK;
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgCancel;
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function DoDir(sDirName : String) : Boolean;
begin
  Result := False;
  Try
    if not DirectoryExists(sDirName) then
      ForceDirectories(sDirName);
    Result := True;
  Except on E:Exception do
    raise Exception.Create('DoDir -> ' + E.Message);
  End;
end;

function DeleteFileIfExist(AFileName : String) : Boolean;
begin
  Result := False;
  if FileExists(AFileName) then
  begin
    DeleteFile(PWideChar(AFileName));
    Result := True;
  end;
end;

function DoArchiveFileList(ADataField : Array of TMasterDataField) : Boolean;
var
  i : Integer;
begin
  Result := False;
  for i := Low(ADataField) to High(ADataField) do
  begin
    if FileExists(ADataField[i].MainData.Path + ADataField[i].MainData.Filename) then
    begin
      DeleteFileIfExist(GARCHPATH + ADataField[i].MainData.Filename);
      MoveFile(PWideChar(ADataField[i].MainData.Path + ADataField[i].MainData.Filename),PWideChar(GARCHPATH + ADataField[i].MainData.Filename));
    end;
  end;
  Result := True;
end;

function DoArchiveGroupList(ADataField : Array of TMasterDataField;AGroup : String) : Boolean;
var
  i, iFile : Integer;
  Search : TSearchRec;
  sPathArch : String;
begin
  Result := False;
  sPathArch := GARCHPATH + AGROUP + '\';
  DoDir(sPathArch);

  for i := Low(ADataField) to High(ADataField) do
  begin
    iFile := FindFirst(ADataField[i].MainData.Path + ADataField[i].MainData.Filename + '*.*',faAnyFile,Search);
    while iFile = 0 do
    begin
      if not ((Search.Attr = faDirectory) or (Search.Name = '.') or (Search.Name = '..')) then
        if FileExists(ADataField[i].MainData.Path + Search.Name) then
        begin
          DeleteFileIfExist(sPathArch + Search.Name);

          MoveFile(PWideChar(ADataField[i].MainData.Path + Search.Name),PWideChar(sPathArch + Search.Name));
        end;
      iFile := FindNext(Search);
    end;
    SysUtils.FindClose(Search);


  end; // for
  Result := True;
end;


{ TIniStruct }

procedure TIniStruct.LoadIni;
begin
  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    With IniStruct do
    begin
      // Debug (0 inactf, 1 actif)
      IsDebugMode := (ReadInteger('DEBUG','MODE',0) = 1);

      IDMDC    := ReadString('ID','MDC','');
//      Database := ReadString('DIR','DATABASE','');

      FTP.MasterDataFTP.Host              := ReadString('MASTERFTP','HOST','');
      FTP.MasterDataFTP.UserName          := ReadString('MASTERFTP','USER','');
      FTP.MasterDataFTP.Password          := DoUnCryptPass(ReadString('MASTERFTP','PWD',''));
      FTP.MasterDataFTP.Port              := ReadInteger('MASTERFTP','PORT',21);
      FTP.MasterDataFTP.Dossier           := ReadString('MASTERFTP','DIR','');

      FTP.MasterDataFTP.MasterDataVersion := ReadString('FTPDIR','MASTERVERSION','');
      FTP.MasterDataFTP.MasterDataDatas   := ReadString('FTPDIR','MASTERDATAS','');
      FTP.MasterDataFTP.GroupDirCommande  := ReadString('FTPDIR','GRPCOMMANDE','');
      FTP.MasterDataFTP.GroupDirModif     := ReadString('FTPDIR','GRPMODIF','');


      LoopMax := ReadInteger('LOOP','MAX',750);
      RenameFtpFile := ReadBool('GENFTP','RENAME',False);
      DeleteFtpfile := ReadBool('GENFTP','DELETE',False);
    end;
  finally
    Free;
  end;
end;

procedure TIniStruct.SaveIni;
begin
  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    With IniStruct do
    begin
      WriteString('ID','MDC', IDMDC);
//      WriteString('DIR','DATABASE',Database);
      WriteString('MASTERFTP','HOST',FTP.MasterDataFTP.Host);
      WriteString('MASTERFTP','USER',FTP.MasterDataFTP.UserName);
      WriteString('MASTERFTP','PWD',DoCryptPass(FTP.MasterDataFTP.Password));
      WriteInteger('MASTERFTP','PORT',FTP.MasterDataFTP.Port);
//      WriteString('MASTERFTP','DIR',FTP.MasterDataFTP.Dossier);
      WriteString('FTPDIR','MASTERVERSION',FTP.MasterDataFTP.MasterDataVersion);
      WriteString('FTPDIR','MASTERDATAS',FTP.MasterDataFTP.MasterDataDatas);
      WriteString('FTPDIR','GRPCOMMANDE',FTP.MasterDataFTP.GroupDirCommande);
      WriteString('FTPDIR','GRPMODIF',FTP.MasterDataFTP.GroupDirModif);

      WriteBool('GENFTP','RENAME',RenameFtpFile);
      WriteBool('GENFTP','DELETE',DeleteFtpfile);
    end;
  finally
    Free;
  end;
end;

function DoCryptPass(APass : String) : String;
var
  i : Integer;
begin
  Result := '';
  for i  := 1 to Length(APass) do
    Result := Result +IntToHex(Ord(APass[i]),2) + IntToHex(Random(255),2);
end;

function DoUnCryptPass(APass : String) : String;
var
  i : Integer;
begin
  Result := '';
  for i  := 1 to (Length(APass) Div 4) do
    Result := Result + Chr(StrToInt('$' + APass[(i - 1)* 4 + 1] + APass[(i -1) * 4 + 2]));
end;


end.
