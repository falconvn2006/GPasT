unit MSS_Type;

interface

uses  SysUtils, MSS_MainClass, Windows, Forms, Inifiles, Classes, StdCtrls,
      Dialogs, Graphics, Controls, Consts, psApi;

type
  ENOTFIND = class(Exception);
  ECFGERROR = Class(Exception);
  EMODELERROR = class(Exception);
  EERRORANDCANCEL = Class(Exception);

  TTarifAchat = Record
    bFound : Boolean;
    CLG_PX,
    CLG_PXNEGO,
    CLG_PXVI,
    CLG_RA1,
    CLG_RA2,
    CLG_RA3,
    CLG_TAXE : Currency;
    CLG_PRINCIPAL,
    CLG_CENTRALE : Integer;
  end;

  TArtArticle = record
    ART_ID ,
    ARF_ID ,
    GTF_ID ,
    MRK_ID ,
    SSF_ID ,
    ACT_ID ,
    FOU_ID ,
    COL_ID ,
    ART_FUSARTID,
    FAjout ,
    FMaj   : Integer;
    Chrono : String;
  end;

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
    GroupDirRecept    : String;
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
    Database : String;
    IDMDC : String;

    IsDebugMode : Boolean;
    // Utilise ce paramètrage en mode débug
    dbDebugMode : String;
    lgDebugMode : String;
    pwDebugMode : String;
    cgDebugMode : String;
    // Paramètrage de la base sql serveur
    LoginDb : String;
    PasswordDb : String;
    CatalogueDb : String;
    FTP : TMainFTPStruct;
    // Paramétrage Mail
    Mail : TMailStruct;
    LoopMax : Integer;
    RenameFtpFile : Boolean;
    DeleteFtpfile : Boolean;
    Time : Integer;
    NoJeton : Boolean;
    SdUpdatePeriode : Integer;
    LogSdUpdate : Boolean;
    SdUpdateActif : Boolean;
    Periode : record
      HDebut,
      HFin : TTime;
    end;
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
  CVERSION                  = '1.0';
  CPRMTYPE                  = 12;
  CPRMCODE_BRANDS           = 50;
  CPRMCODE_SIZES            = 51;
  CPRMCODE_SUPPLIERS        = 52;
  CPRMCODE_UNIVERSCRITERIAS = 53;
  CPRMCODE_COLLECTIONS      = 54;
  CPRMCODE_OPCOMMS          = 55;
  CPRMCODE_PERIODS          = 56;
  CPMCODE_FEDAS             = 57;
  CPRMCODE_CORRESP          = 58;
  CPRMCODE_FEDASUNIVERS     = 59;
  CPRMCODE_SDUPDATECOMMUN   = 60;

  CKTBID_MARQUE       = -11111392;
  CKTBID_COLLECTIONS  = -11111381;
  CKTBID_SUPPLIERS    = -11111385;
  CKTBID_PERIODS      = -11111339;
  CKTBID_OCTETE       = -11111525;
  CKTBID_OCLIGNE      = -11111526;

  CKTBID_PLXTYPEGT    = -11111374;
  CKTBID_PLXGTF       = -11111364;
  CKTBID_PLXTAILLESGF = -11111371;
  CKTBID_PLXGTS       = -11111365;
  CKTBID_PLXTAILLESGS = -11111372;

  CKTBID_NKLSECTEUR   = -11111357;
  CKTBID_NKLRAYON     = -11111356;
  CKTBID_NKLFAMILLE   = -11111355;
  CKTBID_NKLSSFAMILLE = -11111512;

  CKTBID_ARTARTICLE   = -11111375;
  CKTBID_COMBCDE      = -11111435;

  CIMPNUM       = 24;
  CIMPNUM_FEDAS = 25;
var
  IniStruct  : TIniStruct;
  MasterData : Array of TMasterDataField;
  GroupData  : Array of TMasterDataField;
  ModifData  : Array of TMasterDataField;
  RecepData  : Array of TMasterDataField;
  GAPPPATH   ,
  GLOGSPATH  ,
  GXMLMDPATH ,
  GXMLSCPATH ,
  GFILESDIR ,
  GARCHMAINPATH,
  GARCHPATHOK,
  GARCHPATHKO,
  GARCHPATHMASTER,
  GLOGSNAME,
  GAPPRAPPORT : String;

  bDoRestart : Boolean;

  GSTOPCYCLE : Boolean;
  GSTARTTIME : TDateTime;
  GSTOPTIME : Boolean;
  bAutoExec  : Boolean;
  bEnTraitement : Boolean;
  DoCloseApp : Boolean;
  DoHideApp  : Boolean;
  bAutoRestart : Boolean;
  TVALignes  : Array of TTVA;

  function InputPassword(const ACaption, APrompt: string;
    var Value: string): Boolean;

  function DoDir (sDirName : String) : Boolean;
  function DeleteFileIfExist(AFileName : String) : Boolean;

  function MoveFileOrRename(ASource, ADestination, AFileName, AExt : String; ASyncFile : Boolean = True) : Boolean;

  function DoArchiveFileList(ADataField : Array of TMasterDataField) : Boolean;
  function DoArchiveGroupList(ADataField : Array of TMasterDataField;AGroup : String) : Boolean;

  function DoCryptPass(APass : String) : String;
  function DoUnCryptPass(APass : String) : String;

  function FormatMS(MilliSecondes: Cardinal): string;

  function GetAppMemory(Hnd : HWND) : Cardinal;

  function DoWait(AMillisecondes : Integer) : Boolean;

  // Type de fichier
  type TFileKind = ( fkCOMMANDE, fkORD_DELETE, fkMODIF_ARTICLE, fkBL );
  // Retourne le nom du répertoire spécifié sans les caractères interdits
  // ('\/:*?"<>|' par défaut) et avec un delimiteur "/" de fin
  function GetDirectoryClean(const Name: String;
    const RemoveChars: String = '\/:*?"<>|'): String;
  // Retourne le répertoire en absolu (avec le délimiteur de fin) pour le groupe
  // le type de fichier. Concatène le nom du fichier s'il est spécifié.
  function GetFTPLocalPath(const Group: String; const FileKind: TFileKind;
    const FileName: TFileName = ''): TFileName;
  // Créer l'arborescence des répertoires pour le groupe spécifié
  function DoMakeXmlGroup(const CodeGroup: String): Boolean;
  // Supprime l'arborescence des répertoires pour le groupe spécifié (si non vide)
  function DoDeleteXmlGroup(const CodeGroup: String): Boolean;

implementation

function FormatMS(MilliSecondes: Cardinal): string;
var
  Hour, Min, Sec: Cardinal;
begin
  Hour := MilliSecondes div 3600000;
  MilliSecondes := MilliSecondes mod 3600000;
  Min := MilliSecondes div 60000;
  MilliSecondes := MilliSecondes mod 60000;
  Sec := MilliSecondes div 1000;
  MilliSecondes := MilliSecondes mod 1000;
  Result := Format('%.2d:%.2d:%.2d:%.3d', [Hour, Min, Sec, MilliSecondes]);
end;


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

function MoveFileOrRename(ASource, ADestination, AFileName, AExt : String; ASyncFile : Boolean) : Boolean;
var
  sFileNum : String;
  i : integer;
begin
  i := 0;
  sFileNum := '';
  while FileExists(ADestination + AFileName + sFileNum +  AExt) do
  begin
    Inc(i);
    sFileNum := '_' + IntToStr(i);
  end;

  Result := MoveFileEx(PWideChar(ASource + AFileName + AExt),PWideChar(ADestination + AFileName + sFileNum + AExt),MOVEFILE_REPLACE_EXISTING);
  if ASyncFile then
    CopyFile(PWideChar(GFILESDIR + 'emptyfile.txt'), PWideChar(ADestination + AFileName + sFileNum + AExt + '.SYNC'),False);
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
      DeleteFileIfExist(GARCHPATHMASTER + ADataField[i].MainData.Filename);
      MoveFile(PWideChar(ADataField[i].MainData.Path + ADataField[i].MainData.Filename),PWideChar(GARCHPATHMASTER + ADataField[i].MainData.Filename));
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
  sPathArch :=  Format(GARCHPATHOK, [AGROUP]); // GARCHPATH + StringReplace(AGROUP,'/','\',[rfReplaceAll]) + '\';

  for i := Low(ADataField) to High(ADataField) do
  begin
    if (IncludeTrailingPathDelimiter(ADataField[i].MainData.Path) <> GAPPPATH) and (Trim(ADataField[i].MainData.Path) <> '') then
    begin
      iFile := FindFirst(ADataField[i].MainData.Path + ADataField[i].MainData.Filename + '*.*',faAnyFile,Search);
      while iFile = 0 do
      begin
        if not ((Search.Attr = faDirectory) or (Search.Name = '.') or (Search.Name = '..')) then
          if FileExists(ADataField[i].MainData.Path + Search.Name) then
          begin
          //  DeleteFileIfExist(sPathArch + Search.Name);
          //  MoveFile(PWideChar(ADataField[i].MainData.Path + Search.Name),PWideChar(sPathArch + Search.Name));
            DoDir(sPathArch);
            MoveFileOrRename(ADataField[i].MainData.Path, sPathArch,ChangeFileExt(Search.Name, ''),ExtractFileExt(Search.Name),False);
          end;

        iFile := FindNext(Search);
      end;
      SysUtils.FindClose(Search);
    end;
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
      Database := ReadString('DIR','DATABASE','');

      FTP.MasterDataFTP.Host              := ReadString('MASTERFTP','HOST','');
      FTP.MasterDataFTP.UserName          := ReadString('MASTERFTP','USER','');
      FTP.MasterDataFTP.Password          := DoUnCryptPass(ReadString('MASTERFTP','PWD',''));
      FTP.MasterDataFTP.Port              := ReadInteger('MASTERFTP','PORT',21);
      FTP.MasterDataFTP.Dossier           := ReadString('MASTERFTP','DIR','');

      FTP.MasterDataFTP.MasterDataVersion := ReadString('FTPDIR','MASTERVERSION','');
      FTP.MasterDataFTP.MasterDataDatas   := ReadString('FTPDIR','MASTERDATAS','');
      FTP.MasterDataFTP.GroupDirCommande  := ReadString('FTPDIR','GRPCOMMANDE','');
      FTP.MasterDataFTP.GroupDirModif     := ReadString('FTPDIR','GRPMODIF','');
      FTP.MasterDataFTP.GroupDirRecept    := ReadString('FTPDIR','GRPRECEPT','');

      NoJeton := ReadInteger('GK','NOJETON',0) = 1;

      LoopMax := ReadInteger('LOOP','MAX',750);
      RenameFtpFile := ReadBool('GENFTP','RENAME',False);
      DeleteFtpfile := ReadBool('GENFTP','DELETE',False);
      Time := ReadInteger('ACTION','TIME',60);

      SdUpdatePeriode := ReadInteger('COMMON','SDUPDATE',7);
      LogSdUpdate     := ReadBool('COMMON','LOGSDUPDATE',FALSE);
      SdUpdateActif   := ReadBool('COMMON','SDUPDATEACTIF',TRUE);

      Periode.HDebut := ReadTime('PERIODE','HDEBUT',StrToTime('04:15:00'));
      Periode.HFin := ReadTime('PERIODE','HFIN',StrToTime('19:30:00'));
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
      WriteString('DIR','DATABASE',Database);

      WriteString('MASTERFTP','HOST',FTP.MasterDataFTP.Host);
      WriteString('MASTERFTP','USER',FTP.MasterDataFTP.UserName);
      WriteString('MASTERFTP','PWD',DoCryptPass(FTP.MasterDataFTP.Password));
      WriteInteger('MASTERFTP','PORT',FTP.MasterDataFTP.Port);
//      WriteString('MASTERFTP','DIR',FTP.MasterDataFTP.Dossier);
      WriteString('FTPDIR','MASTERVERSION',FTP.MasterDataFTP.MasterDataVersion);
      WriteString('FTPDIR','MASTERDATAS',FTP.MasterDataFTP.MasterDataDatas);
      WriteString('FTPDIR','GRPCOMMANDE',FTP.MasterDataFTP.GroupDirCommande);
      WriteString('FTPDIR','GRPMODIF',FTP.MasterDataFTP.GroupDirModif);
      WriteString('FTPDIR','GRPRECEPT',FTP.MasterDataFTP.GroupDirRecept);

      WriteBool('GENFTP','RENAME',RenameFtpFile);
      WriteBool('GENFTP','DELETE',DeleteFtpfile);

      WriteInteger('ACTION','TIME',Time);
      WriteInteger('COMMON','SDUPDATE',SdUpdatePeriode);
      WriteBool('COMMON','LOGSDUPDATE',LogSdUpdate);
      WriteBool('COMMON','SDUPDATEACTIF',SdUpdateActif);

      WriteTime('PERIODE','HDEBUT',Periode.HDebut);
      WriteTime('PERIODE','HFIN',Periode.HFin);
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

function GetAppMemory(Hnd : HWND) : Cardinal;
var
  MemSize : Cardinal;
  pPMC : PPROCESS_MEMORY_COUNTERS;
  nProcID, TmpHandle : HWND;
begin
  MemSize := SizeOf(PROCESS_MEMORY_COUNTERS);
  GetMem(pPMC, MemSize);
  pPmc^.cb := MemSize;
  GetWindowThreadProcessId(Hnd, @nProcID);
  TmpHandle := OpenProcess(PROCESS_ALL_ACCESS, False, nProcID);

  try
    if GetProcessMemoryInfo(TmpHandle,pPMC,MemSize) then
      Result := pPMC^.WorkingSetSize
    else
      Result := 0;
  finally
    FreeMem(pPMC);
  end;

end;

function DoWait(AMillisecondes : Integer) : Boolean;
var
  Start, Encours : Integer;
begin
  Start := GetTickCount;
  Encours := Start;
  while Encours <= Start + AMillisecondes do
  begin
    EnCours := GetTickCount;
    Application.ProcessMessages;
  end;
end;


function GetDirectoryClean(const Name: String;
  const RemoveChars: String = '\/:*?"<>|'): String;
var
  i: Integer;
begin
  Result := Name;
  for i := 1 to Length( RemoveChars ) do
    Result := StringReplace( Result, RemoveChars[ i ], '', [ rfReplaceAll ] );
  Result := IncludeTrailingPathDelimiter( Result );
end;

function GetFTPLocalPath(const Group: String; const FileKind: TFileKind;
  const FileName: TFileName = ''): TFileName;
var
  sFileKind: String;
begin
  Result := GXMLSCPATH{XmlGroup\} + GetDirectoryClean( Group ){<Group>\};

  case FileKind of
    fkCOMMANDE: Result := Result{XmlGroup\<Group>\} + IncludeTrailingPathDelimiter( 'COMMANDE' ){COMMANDE\};
    fkORD_DELETE: Result := Result{XmlGroup\<Group>\} + IncludeTrailingPathDelimiter( 'ORD_DELETE' ){ORD_DELETE\};
    fkMODIF_ARTICLE: Result := Result{XmlGroup\<Group>\} + IncludeTrailingPathDelimiter( 'MODIF_ARTICLE' ){MODIF_ARTICLE\};
    fkBL: Result := Result{XmlGroup\<Group>\} + IncludeTrailingPathDelimiter( 'BL' ){BL\};
  end;

  Result := Result{XmlGroup\<Group>\[BL|COMMANDE|MODIF_ARTICLE]\} + FileName{<FileName>};
end;

function DoMakeXmlGroup(const CodeGroup: String): Boolean;
var
  FileKind: TFileKind;
begin
  Result := DoDir( GXMLSCPATH{XmlGroup\} + GetDirectoryClean( CodeGroup ){<Group>\} );

  for FileKind := Low( TFileKind ) to High( TFileKind ) do
    Result := Result and DoDir( GetFTPLocalPath( CodeGroup, FileKind ) );
end;

function DoDeleteXmlGroup(const CodeGroup: String): Boolean;
var
  FileKind: TFileKind;
begin
  // default
  Result := True;

  // Suppression des sous-dossiers s'ils sont vides
  for FileKind := Low( TFileKind ) to High( TFileKind ) do
    Result := Result and RemoveDir( GetFTPLocalPath( CodeGroup, FileKind ) );

  // Suppression du groupe s'il est vide
  Result := Result and RemoveDir( GXMLSCPATH{XmlGroup\} + GetDirectoryClean( CodeGroup ){<Group>\} );
end;

end.
