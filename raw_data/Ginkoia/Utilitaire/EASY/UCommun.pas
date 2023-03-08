/// <summary>
/// Unité Commune à EASY
/// </summary>
unit uCommun;

interface

Uses  Windows, Messages, SysUtils, Variants, Classes, StdCtrls, magwmi, magsubs1, Registry,
      ShellAPi,inifiles,Tlhelp32, WinSvc,Forms, StrUtils, IOUtils,ServiceControler, Controls,
      FireDAC.Comp.Client,IdText, IdFTP, IdFTPCommon, IdExplicitTLSClientServerBase, IdAllFTPListParsers,
      IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,Vcl.ComCtrls,
      IdHashMessageDigest, idHash,ShlObj;

const
      MAJ_URLPATH          = 'http://lame2.no-ip.com/algol/SRV_DEV/products/EASY/';
      MAJ_InformationsFile = 'easy.txt';

      CST_MAX_PORTS=2000; //

      MSG_CC_INSTALL = 'Début Installation EasyCC...';
      MSG_CC_INSTALL_OK = 'Installation EasyCC OK';
      MSG_CC_INSTALL_ERROR = 'Installation en ERREUR';
      MSG_CC_INSTALL_JAVA  = 'Installation de JAVA';
      MSG_CC_INSTALL_SYMDS = 'Installation de SymmetricDS';
      MSG_CC_INSTALL_START_SERVICE  = 'Démarrage du service';
      MSG_CC_INSTALL_TRIGGERS_BEGIN = 'Début Installation des Triggers';
      MSG_CC_INSTALL_TRIGGERS     = 'Installation des Triggers (%d/%d)';
      MSG_CC_INSTALL_TRIGGERS_END = 'Fin Installation des Triggers';
      MSG_CC_INSTALL_END   = 'Fin Installation EasyCC';

      MSG_SPLIT = 'Mini split en cours...';
      MSG_SPLIT_OK = 'Mini split terminé OK';
      MSG_SPLIT_ERROR = 'Mini split en ERREUR';
      MSG_SPLIT_END   = 'Fin Mini split';

type

  TStatusMessageCall = Procedure (const info:String) of object;
  TProgressMessageCall = Procedure (const position:integer) of object;
  TLogMessageCall = Procedure (const info:string) of object;
  // Pour faire passer 2 chose dans le Synchronize
  TInfosMessageCall  = Procedure (const Info:Integer) of object;


  TGENParam = record
    PRM_ID      : Integer;    //
    PRM_STRING  : string;
  public
//    Procedure Init;
  end;

  TGEnParams = array of TGENParam;



  TInfosDelosEASY = record
    // PRM_TYPE = 80 et PRM_CODE=2
    BAS_ID      : Integer;    //
    GUID        : string;
    SENDER      : string;
    BAS_MAGID   : integer;
    BAS_IDENT   : string;
    DatePassage : TDateTime;  // PRM_FLOAT
    Etat        : Integer;    // PRM_INTEGER
    Dossier     : string;     // PRM_STRING
  public
    Procedure Init;
  end;


  /// <summary>
  /// Informations sur un Noeud
  /// </summary>
  TEtatNoeud = record
    NODE_ID        : string;
    SYNC_ENABLED   : integer;
    SYNC_URL       : string;
    HEARTBEAT_TIME : string;
//    SYNC_MOD       : Integer;  // 0 inconnu : 1 Normal / 2 Mode Offline
    NODE_GROUP_ID  : string;
  end;

  TInfosReplication = record
    NomBase             : string;
    ServeurReplication  : string;
  end;

  /// <summary>
  /// Informations sur SymmetricDS
  /// </summary>
  TSymmetricDS = record
    Nom         : string;
    Repertoire  : string;
    http        : integer;
    https       : integer;
    jmx         : integer;
    agent       : integer;
    server_java : Boolean;
    memory      : Integer;
    IsLame      : Boolean;   // LAME ou pas ?
  end;


function Application_Hidden():boolean;
function Application_Deploy_Hidden() : boolean;
function Application_Download():boolean;
function Application_Install() : boolean;
function GetSpecialFolder(const CSIDL: integer) : string;
function GetTempDirectory: String;
function SaveStrToFile(AfileName:string;astring:string):boolean;
function CreateUniqueGUIDFileName(sPath, sPrefix, sExtension : string) : string;
function GetTmpDir:string;
procedure GetDatabases;
function GetComputerNetName: string;
function SecondsIdle: DWord;
function ParseJDBC(ajdbcStr:string):string;
procedure GetJavaInfos;
procedure MyCreateParams(var Params: TCreateParams);
function FileSize(const aFilename: String): Int64;
function CaseOfString(s: string; a: array of string): Integer;
procedure CreationRessources;
function GetLevelCompression(index:integer):cardinal;
function GetTypeArchive(index:integer):TGUID;
function DownloadHTTP(const AUrl, FileName : string) : boolean;
procedure GetSQLInfo(Text : string; out Table, Champ, Cond : string);
procedure DecodePlage(S: string; var Deb, fin: integer);
procedure RecupMaxValeur(Query : TFDQuery; SQL, Cond : string; var Valeur : integer);
function GetFileVersion(exeName : string): string;
function FileVersion(const FileName: TFileName): String;
function Sender_To_Node(aSender:string):string;
function SupprimerFichier(NomFichier: String): Boolean;
// Function ReadTextFile(const FileName: String; NumRows : Integer): String;
procedure SaveFilePos(aServiceName:string;aPosition:integer);
function LoadFilePos(aServiceName:string):integer;
Function ISO8601ToDateTime(Value: String):TDateTime;
function NewGUID:string;
function PoseUDF(InterbasePath:string):Boolean;
procedure Unzip7zFile (zipFullFname:string;outDir:string);
function JAVAInstalled(aType:Integer):Boolean;  // 0:Lame  1:MAGASIN
function InstallJAVA(aType:Integer):Boolean;  // 0:Lame  1:MAGASIN
//procedure SendFileToFTP(Const AUserName, APassword, AHost, ARemoteDir,
procedure SendFileToFTP(Const AUserName, APassword, AHost, ARemoteDir,
  ALocalPathAndFileName: String; Const AProxySettings: TIdFtpProxySettings;
  Const DeleteAfterSend: Boolean; Const APort: integer; Const AUseTLS: TIdUseTLS);
function MD5File(const FileName: string): string;

function LoadStrFromIniFile(aSection:string;aKey:string):string;
function LoadIntFromIniFile(aSection:string;aKey:string):integer;
function LoadBoolFromIniFile(aSection:string;aKey:string):boolean;
procedure SaveStrToIniFile(aSection:string;aKey:string;aValue:string);
procedure SaveIntToIniFile(aSection:string;aKey:string;aValue:integer);
function SecondToTime(const Seconds: double): String;
Function KillProcess(const ProcessName : string) : boolean;
function ProcessIsRunning(Const exeFileName: string): Boolean;
function LanceAppliAttenteFin(cmd:string):boolean;
function scShellMoveFile(FormHandle : THandle; StrFrom, StrTo : string;
  BlnSilent : Boolean = False) : Boolean;
function FTPPut(a7ZFile:TFileName;aPort:Integer;aHost,aUserName,aPassword,aLame,aDossier:string):Boolean;
procedure DeleteFiles(APath, AFileSpec: string);
function CompareVersion(left, right: string): Integer;
function GetInfo(Const Ressource:String): String;
function SplitString(src: string; delim: string; var dest1: string; var dest2: string): Boolean;
procedure EasyDecodePlage(S: string; var Deb, fin: integer);

implementation

Uses UWMI,uSevenZip,uDownloadHTTP,ComObj, ActiveX,SymmetricDS.Commun, IdFTPList,IdSSLOpenSSL;




procedure EasyDecodePlage(S: string; var Deb, fin: integer);
var
  S1: string;
begin
  while not CharInSet(S[1], ['0'..'9']) do
    delete(s, 1, 1);
  S1 := '';
  while CharInSet(S[1], ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    delete(s, 1, 1);
  end;
  deb := Strtoint(S1);
  while not CharInSet(S[1], ['0'..'9']) do
    delete(s, 1, 1);
  S1 := '';
  while CharInSet(S[1], ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    delete(s, 1, 1);
  end;
  fin := Strtoint(S1);
end;


function GetInfo(Const Ressource:String): String;
//     ReadFileInfo(Application.ExeName,Ressource);
var VerInfoSize: DWord;
    VerInfo: Pointer;
    VerValueSize: DWord;
    VerValue: PVSFixedFileInfo;
    Dummy: DWord;
begin
     result:='';
     VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
     if VerInfoSize <> 0
        then
            begin
                 GetMem(VerInfo, VerInfoSize);
                 GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
                 if Ressource='Version'
                    then
                        begin
                             VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
                             with VerValue^ do
                                  begin
                                       result := IntTostr(dwFileVersionMS shr 16);
                                       result := result+'.'+ IntTostr(dwFileVersionMS and $FFFF);
                                       result := result+'.'+ IntTostr(dwFileVersionLS shr 16);
                                       result := result+'.'+ IntTostr(dwFileVersionLS and $FFFF);
                                  end;
                        end;
                 if Ressource='LegalCopyright'
                    then
                        begin
                             {$IFDEF VER150}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\LegalCopyright'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(Pointer(VerValue));
                             {$ENDIF}
                             {$IFDEF VER210}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\LegalCopyright'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(PWideChar(VerValue));
                             {$ENDIF}
                        end;
                 if Ressource='InternalName'
                    then
                        begin
                             {$IFDEF VER150}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\InternalName'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(Pointer(VerValue));
                             {$ENDIF}
                             {$IF CompilerVersion>=22}
                             VerQueryValue(VerInfo, PChar('\StringFileInfo\040C04E4\InternalName'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(PWideChar(VerValue));
                             {$IFEND}
                        end;
                 //   then
                 //       begin
                 //            VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\LegalCopyright'),Pointer(VerValue), VerValueSize);
                 //            Result:=StrPas(Pointer(VerValue));
                 //       end;
                 FreeMem(VerInfo, VerInfoSize);
            end
        else result:='';
end;


function SplitString(src: string; delim: string; var dest1: string; var dest2: string): Boolean;
var min, c, j: integer;
begin
	min := 0;
  for c := 1 to length(delim) do
    begin
      j := Pos(delim[c], src);
      if ((j < min) or (min = 0)) and (j > 0) then min := j;
    end;

  if min > 0 then
    begin
      dest1 := Copy(src, 1, min - 1);
      dest2 := Copy(src, min + 1, Length(src));
      SplitString := true;
    end
  else
    begin
      dest1 := src;
      dest2 := '';
      SplitString := false;
    end;
end;


function CompareVersion(left, right: string): Integer;
var leftpart, rightpart : string;
	lpos, rpos : integer;
begin
	result := CompareText(left, right);
  while  (left <> '') and (right <> '') do
    begin
      SplitString(left, '.', leftpart, left);
      SplitString(right, '.', rightpart, right);
      // Justify the numbers
      lpos := LastDelimiter('0123456789*', leftpart);
      rpos := LastDelimiter('0123456789*', rightpart);
      while (lpos > rpos) do begin
        rightpart := ' ' + rightpart;
        inc(rpos);
      end;
      while (rpos > lpos) do begin
        leftpart := ' ' + leftpart;
        inc(lpos);
      end;
      if (leftpart = '*') or (rightpart = '*') then break;
      result := CompareText(leftpart, rightpart);

      if (result <> 0) then break;
    end;
end;


procedure DeleteFiles(APath, AFileSpec: string);
var
  lSearchRec:TSearchRec;
  lPath:string;
begin
  lPath := IncludeTrailingPathDelimiter(APath);

  if FindFirst(lPath+AFileSpec,faAnyFile,lSearchRec) = 0 then
  begin
    try
      repeat
        SysUtils.DeleteFile(lPath+lSearchRec.Name);
      until SysUtils.FindNext(lSearchRec) <> 0;
    finally
      SysUtils.FindClose(lSearchRec);  // Free resources on successful find
    end;
  end;
end;


function FTPPut(a7ZFile:TFileName;aPort:Integer;aHost,aUserName,aPassword,aLame,aDossier:string):Boolean;
var vIdFTP:TIdFTP;
    v:string;
    i:Integer;
    vDirExist : Boolean;
    vIdSSLIOHandler : TIdSSLIOHandlerSocketOpenSSL;
    x:string;
begin
    if FileExists(a7ZFile) then
      begin
          vIdSSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
          vIdFTP:= TIdFTP.Create(nil);
          vIdFTP.IOHandler:=vIdSSLIOHandler;
          try
             vIdFTP.Username := aUsername;
             vIdFTP.Password := aPassword;
             vIdFTP.Host     := aHost;
             vIdFTP.Port     := aPort;
             // vIdFTP.UseTLS   := utNoTLSSupport;
             vIdFTP.UseTLS   := utUseExplicitTLS;
             vIdFTP.DataPortProtection := ftpdpsPrivate;
             vIdFTP.TransferType := ftBinary;
             try
               vIdFTP.Passive := True;   // problème sur replic3 sans cette ligne ça ne fonctionne pas
                                            // Sur mon poste ca fonctionne pas non plus  ??
               // vIdFTP.Passive := False;
               vIdFTP.Connect;
               vIdFTP.ChangeDir(UpperCase('/'+aLame));
               vIDFTP.List;
               vDirExist := false;
               for I := 0 to vIdFTP.DirectoryListing.Count-1 do
                 begin
                    if (vIDFTP.DirectoryListing[I].ItemType=ditDirectory)
                      and (vIDFTP.DirectoryListing[I].FileName=aDossier)
                     then
                       begin
                         vDirExist := True;
                         break;
                       end;
                      end;
                 If not(vDirExist)
                    then vIdFTP.MakeDir(aDossier);
                    vIdFTP.ChangeDir(aDossier);
               vIdFTP.Put(a7ZFile,ExtractFileName(a7ZFile));
               // peut etre voir si le fichier est bien présent...
               result:=true;
             except
                  On E:Exception do
                    begin
                      x := E.Message;
                      result:=false;
                    end;
              end;
          finally
             if vIdFTP.Connected then
               vIdFTP.Disconnect;
            FreeAndNil(vIdFTP);
            // FreeAndNil(vIdSSLIOHandler);
          end;
      end;
end;

// ----------------------------------------------------------------
// Move files
// ----------------------------------------------------------------
function scShellMoveFile(FormHandle : THandle; StrFrom, StrTo : string;
  BlnSilent : Boolean = False) : Boolean;
var
  F : TShFileOpStruct;
  a : Cardinal;
begin
  F.Wnd:=FormHandle;
  F.wFunc:=FO_MOVE;
  F.pFrom:=PChar(StrFrom+#0);
  F.pTo:=PChar(StrTo+#0);                         // FOF_RENAMEONCOLLISION est important pour le moment - Mais ca fait une copie >>> sinon on a pas de sauve
  F.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_RENAMEONCOLLISION
              or FOF_NOCOPYSECURITYATTRIBS; // Test V1.0.0.7
  if BlnSilent then
    F.fFlags := F.fFlags or FOF_SILENT;
  if ShFileOperation(F) <> 0 then
    begin
      a:=GetLastError;
      result:=False;
    end
  else
    result:=True;
end;


function LanceAppliAttenteFin(cmd:string):boolean;
Var  StartInfo   : TStartupInfo;
     ProcessInfo : TProcessInformation;
     Fin         : Boolean;
begin
  { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo,SizeOf(StartInfo),#0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb     := SizeOf(StartInfo);

  { Lancement de la ligne de commande }
  If CreateProcess(Nil, PWideChar(cmd), Nil, Nil, False,
                0, Nil, Nil, StartInfo,ProcessInfo) Then
  Begin
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    Fin:=False;
    Repeat
      { On attend la fin de l'application }
      Case WaitForSingleObject(ProcessInfo.hProcess, 200)Of
        WAIT_OBJECT_0 :Fin:=True; { L'application est terminée, on sort }
        WAIT_TIMEOUT  :;          { elle n'est pas terminée, on continue d'attendre }
      End;
      { Mise à jour de la fenêtre pour que l'application ne paraisse pas bloquée. }
      Application.ProcessMessages;
    Until Fin;
    { C'est fini }
    // ShowMessage('Terminé');
  End
  Else RaiseLastOSError;
End;





procedure TInfosDelosEASY.Init;
begin
    BAS_ID      :=0;
    BAS_IDENT   :='';
    BAS_MAGID   :=0;
    SENDER      :='';
    GUID        :='';
    DatePassage :=0;
    Etat        :=0;
    Dossier     :=''
end;


function MD5File(const FileName: string): string;
var
  IdMD5: TIdHashMessageDigest5;
  FS: TFileStream;
begin
 IdMD5 := TIdHashMessageDigest5.Create;
 FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
 try
   Result := IdMD5.HashStreamAsHex(FS)
 finally
   FS.Free;
   IdMD5.Free;
 end;
end;


function PoseUDF(InterbasePath:string):Boolean;
var ResDLL  : TResourceStream;

begin
    result:=false;
    if not(FileExists(InterbasePath+'\UDF\sym_udf.dll'))
     then
        begin
          try
            // CopyFile(PWideChar(VGSE.ExePath+'res\symmetric-pro-3.7.36-setup.jar'),PWideChar(sProgInstall),true);
            { on sort l'install qui prend trop de place }
            ResDLL := TResourceStream.Create(HInstance, 'sym_udf', RT_RCDATA);
            try
              ResDLL.SaveToFile(InterbasePath+'\UDF\sym_udf.dll');
              result:=true;
            finally
              ResDLL.Free();
            end;
          except
            on e: Exception do
            begin
              Result := False;
              Exit;
            end;
          end;
        end
     else result:=true;
end;


function NewGUID:string;
var ID:TGUID;
begin
  Result := '';
  if CoCreateGuid(ID) = S_OK then
     result:= GUIDToString(ID);
end;


function LoadBoolFromIniFile(aSection:string;aKey:string):boolean;
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    result:=false;
    try
      result := appINI.ReadBool(aSection,aKey,false) ;
      finally
      appINI.Free;
    end;
end;

function LoadIntFromIniFile(aSection:string;aKey:string):integer;
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    result:=0;
    try
      result := appINI.ReadInteger(aSection,aKey,0) ;
      finally
      appINI.Free;
    end;
end;

function LoadStrFromIniFile(aSection:string;aKey:string):string;
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    result:='';
    try
      result := appINI.Readstring(aSection,aKey,'') ;
      finally
      appINI.Free;
    end;
end;

procedure SaveStrToIniFile(aSection:string;aKey:string;aValue:string);
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    try
      appINI.Writestring(aSection,aKey,aValue) ;
      finally
      appINI.Free;
    end;
end;

procedure SaveIntToIniFile(aSection:string;aKey:string;aValue:integer);
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    try
      appINI.WriteInteger(aSection,aKey,aValue) ;
      finally
      appINI.Free;
    end;
end;



function LoadFilePos(aServiceName:string):integer;
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    result:=0;
    try
      result := appINI.ReadInteger(aServiceName,'LOG_POSITION',0) ;
      finally
      appINI.Free;
    end;
end;

Function ISO8601ToDateTime(Value: String):TDateTime;
var FormatSettings: TFormatSettings;
    vValue:string;
begin
    try
      vValue := Copy(Value,1,19);
      GetLocaleFormatSettings(GetThreadLocale, FormatSettings);
      FormatSettings.DateSeparator := '-';
      FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
      FormatSettings.LongTimeFormat :='hh:nn:ss';
      Result := StrToDateTime(Value, FormatSettings);
    Except
      On E:Exception
        do raise;// rien
    end;
end;

procedure SaveFilePos(aServiceName:string;aPosition:integer);
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    try
       appINI.WriteInteger(aServiceName,'LOG_POSITION',aPosition) ;
      finally
      appINI.Free;
    end;
end;


{
procedure TForm1.Analyse;
begin

    vFileStream := TFileStream.Create('C:\Embarcadero\InterBase\interbase.log', fmOpenRead or fmShareDenyNone);
    try
      Analyse_Lignes;
    finally
      vFileStream.Free;
    end;
end;

Function ReadTextFile(const FileName: String; NumRows : Integer):boolean;
var vFileStream: TFileStream;
begin
     if not(Assigned(FFileList))
       then FFileList := TStringList.Create
       else FFileList.Clear;

     vFileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);

     FFileList.LoadFromStream(vFileStream);


     BlockSize   := MAXLINELENGTH;
     Hash13Found := 0;
     CharCount   := 0;
     Repeat
         Stream.Seek(CharCount, soBeginning);  // SoEnd = depuis la fin
         Stream.Read(Buffer[CharCount], 1);
         Result := result + AnsiString(Buffer[CharCount]) ;
         if Buffer[CharCount] =#13
          then Inc(Hash13Found);
         Inc(CharCount);
     Until (Hash13Found>NumRows) or (CharCount >= BlockSize);
end;
}

function SupprimerFichier(NomFichier: String): Boolean;
var
  fos: TSHFileOpStruct;
begin
  FillChar(fos, SizeOf(fos), 0);
  with fos do
  begin
    wFunc  := FO_DELETE;
    pFrom  := Pchar(NomFichier + #0);
    fFlags := FOF_NOCONFIRMATION or FOF_SILENT;
  end;
  Result := (0 = ShFileOperation(fos));
end;



// Transforme un Serveur en un Node valide pour SymmetricDS (pas plus de 30 caractères)
// Attention il y a des problèmes (pas d'unicté) avec les chaines trop longues et les "SEC"
// Exemple : SERVEUR_ROCHE-SUR-FORON_000105_FLAMMIER  ==> s_roche-sur-foron_000105_flamm
//           SERVEUR_ROCHE-SUR-FORON_000105_FLAMMIER-SEC ==> s_roche-sur-foron_000105_flamm
// il faut modifier Si -sec trouvé à la fin il faudrait faire
// SERVEUR_ROCHE-SUR-FORON_000105_FLAMMIER-SEC => sec_roche-sur-foron_000105_fla

function Sender_To_Node(aSender:string):string;
var tmp:string;
begin
     tmp:=LowerCase(aSender);
     if RightStr(tmp,4)='-sec' then
      begin
        tmp := StringReplace(tmp,'serveur','',[]);
        tmp :='sec'+tmp;
      end;
     tmp := StringReplace(tmp,'serveur','s',[]);
     tmp := StringReplace(tmp,'portable','p',[]);
     tmp := StringReplace(tmp,'-sync','-s',[]);
     tmp := Copy(tmp, 1, 30);
     result:=tmp;
end;

function FileVersion(const FileName: TFileName): String;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do
          Result := Format('%d.%d.%d.%d', [
            HiWord(dwFileVersionMS), //Major
            LoWord(dwFileVersionMS), //Minor
            HiWord(dwFileVersionLS), //Release
            LoWord(dwFileVersionLS)]); //Build
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;


function GetFileVersion(exeName : string): string;
const
  c_StringInfo = 'StringFileInfo\040904E4\FileVersion';
var
  n, Len : cardinal;
  Buf, Value : PChar;
begin
  Result := '';
  n := GetFileVersionInfoSize(PChar(exeName),n);
  if n > 0 then begin
    Buf := AllocMem(n);
    try
      GetFileVersionInfo(PChar(exeName),0,n,Buf);
      if VerQueryValue(Buf,PChar(c_StringInfo),Pointer(Value),Len) then begin
        Result := Trim(Value);
      end;
    finally
      FreeMem(Buf,n);
    end;
  end;
end;

procedure GetSQLInfo(Text : string; out Table, Champ, Cond : string);
begin
  Table := copy(Text, 1, pos(';', Text) -1);
  delete(Text, 1, pos(';', Text));
  if pos(';', Text) > 0 then
  begin
    Champ := copy(Text, 1, pos(';', Text) -1);
    delete(Text, 1, pos(';', Text));
    Cond := Text;
  end
  else
  begin
    Champ := Text;
    Cond := '';
  end;
end;

procedure RecupMaxValeur(Query : TFDQuery; SQL, Cond : string; var Valeur : integer);
begin
  try
    query.sql.text := SQL;
    if not (Trim(Cond) = '') then
    begin
      if Pos('WHERE', UpperCase(query.sql.text)) > 0 then
        query.sql.text := query.sql.text + ' and ' + Cond
      else
        query.sql.text := query.sql.text + ' where ' + Cond;
    end;
    query.Open();
    if (not query.eof) and (not query.fields[0].IsNull) and (query.fields[0].Asinteger > Valeur) then
      Valeur := query.fields[0].Asinteger;
    query.Close();
  except
  end;
end;



procedure DecodePlage(S: string; var Deb, fin: integer);
var
  S1: string;
begin
  while not CharInSet(S[1], ['0'..'9']) do
    delete(s, 1, 1);
  S1 := '';
  while CharInSet(S[1], ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    delete(s, 1, 1);
  end;
  deb := Strtoint(S1);
  while not CharInSet(S[1], ['0'..'9']) do
    delete(s, 1, 1);
  S1 := '';
  while CharInSet(S[1], ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    delete(s, 1, 1);
  end;
  fin := Strtoint(S1);
end;


{===============================================================================
 Procedure    : SendFileToFTP
 Description  : permet d'envoyer un fichier sur un serveur FTP.
===============================================================================}
procedure SendFileToFTP(Const AUserName, APassword, AHost, ARemoteDir,
  ALocalPathAndFileName: String; Const AProxySettings: TIdFtpProxySettings;
  Const DeleteAfterSend: Boolean; Const APort: integer; Const AUseTLS: TIdUseTLS);
var
  vIdFTP: TIdFTP;
begin
  vIdFTP:= TIdFTP.Create(nil);
  try
    vIdFTP.Username:= AUserName;
    vIdFTP.Password:= APassword;
    vIdFTP.Host:= AHost;
    vIdFTP.Port:= APort;
    vIdFTP.UseTLS:= AUseTLS;
    if AProxySettings <> nil then
      vIdFTP.ProxySettings:= AProxySettings;
    vIdFTP.Connect;
    if not vIdFTP.Connected then
      Raise Exception.Create('Connexion FTP impossible.');
    vIdFTP.ChangeDir(ARemoteDir);
    vIdFTP.Put(ALocalPathAndFileName, ExtractFileName(ALocalPathAndFileName));
    if (DeleteAfterSend) and (FileExists(ALocalPathAndFileName)) then
      DeleteFile(ALocalPathAndFileName);
  finally
    if vIdFTP.Connected then
      vIdFTP.Disconnect;
    FreeAndNil(vIdFTP);
  end;
end;



function GetTypeArchive(index:integer):TGUID;
begin
    case index of
      0:result := CLSID_CFormat7z;
      1:result := CLSID_CFormatZip;
    else
      result   := CLSID_CFormat7z;
    end;
end;


function GetLevelCompression(index:integer):cardinal;
begin
    case index of
      0:result:=0;
      1:result:=1;
      2:result:=3;
      3:result:=5;
      4:result:=7;
      5:result:=9;
    else
      result:=5;
    end;
end;


procedure CreationRessources;
var ResScripts:TResourceStream;
    Fichier:TFileName;
begin
    Fichier := IncludeTrailingPathDelimiter(VGSE.ExePath)+'7z.dll';
    ResScripts := TResourceStream.Create(HInstance, '7zipdll', RT_RCDATA);
    try
      if not(FileExists(Fichier)) then
        ResScripts.SaveToFile(Fichier);
      finally
      ResScripts.Free();
    end;
end;

function CaseOfString(s: string; a: array of string): Integer;
begin
Result := 0;
while (Result < Length(a)) and (a[Result] <> s) do
Inc(Result);
if a[Result] <> s then
Result := -1;
end;


function SecondsIdle: DWord;
var
   liInfo: TLastInputInfo;
begin
   liInfo.cbSize := SizeOf(TLastInputInfo) ;
   GetLastInputInfo(liInfo) ;
   Result := (GetTickCount - liInfo.dwTime) DIV 1000;
end;

function FileSize(const aFilename: String): Int64;
var
  AttributeData: TWin32FileAttributeData;
begin
  if GetFileAttributesEx(PChar(aFileName), GetFileExInfoStandard, @AttributeData) then
  begin
    Int64Rec(Result).Lo := AttributeData.nFileSizeLow;
    Int64Rec(Result).Hi := AttributeData.nFileSizeHigh;
  end
  else
    Result := -1;
end;

procedure GetDatabases;
var i,j:integer;
    searchResult : TSearchRec;
    bFound : boolean;
begin
    Setlength(VGIB,0);
    for i:=0 to length(VGSYMDS)-1 do
    begin
       SetCurrentDir(VGSYMDS[i].Directory + '\engines');
       bFound:=FindFirst('*.properties', faAnyFile, searchResult) = 0;
       While bFound do
            begin
                j:=Length(VGIB);
                Setlength(VGIB,j+1);
                VGIB[j].ServiceName:=VGSYMDS[i].ServiceName;
                with TStringList.Create do
                  try
                    VGIB[j].PropertiesFile:=GetCurrentDir + '\' + searchResult.Name;
                    LoadFromFile(VGIB[j].PropertiesFile);
                    VGIB[j].Nom          := Values['engine.name'];
                    VGIB[j].DatabaseFile := ParseJDBC(Values['db.url']);
                  finally
                   Free;
                  end;
                bFound := FindNext(searchResult) = 0;
            end;
          // Must free up resources used by these successful finds
     FindClose(searchResult);
     end;
end;

function DownloadHTTP(const AUrl, FileName : string) : boolean;
begin
  Result := false;
  try
    Result := uDownloadHTTP.DownloadHTTP(AUrl, FileName);
  except
//    on e : Exception do
//      FLogs.Add('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;


function GetTempDirectory: String;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

// Seulement pour Application_Deploy_Hidden
function Application_Deploy_Hidden() : boolean;
var i: Integer;
begin
    Result := false;
    for i := 1 to ParamCount do
      begin
        if UpperCase(ParamStr(i))='HIDE' then result:=true;
      end;
end;


function Application_Hidden() : boolean;
var i: Integer;
begin
    Result := false;
    for i := 1 to ParamCount do
      begin
        if LowerCase(ParamStr(i))='/hide' then result:=true;
      end;
end;

function Application_Install() : boolean;
var i: Integer;
begin
    Result := false;
    for i := 1 to ParamCount do
      begin
        if LowerCase(ParamStr(i))='/install' then result:=true;
      end;
end;

function Application_Download() : boolean;
var i: Integer;
begin
    Result := false;
    for i := 1 to ParamCount do
      begin
        if LowerCase(ParamStr(i))='/download' then result:=true;
      end;
end;



function GetSpecialFolder(const CSIDL: integer) : string;
var
  RecPath : PWideChar;
begin
  RecPath := StrAlloc(MAX_PATH);
    try
    FillChar(RecPath^, MAX_PATH, 0);
    if SHGetSpecialFolderPath(0, RecPath, CSIDL, false)
      then result := RecPath
      else result := '';
    finally
      StrDispose(RecPath);
    end;
end;

function GetTmpDir:string;
var Path : Array[0..MAX_PATH] Of Char ;
begin
     // Récupération du répertoire temporaire (éventuellement, celui de l'application).
     If (GetTempPath(MAX_PATH,@Path)=0) Then
        StrCopy(@Path,PChar(ExtractFileDir(Application.ExeName)));
     result:=Path;
end;


function CreateNewFileName(BaseFileName: String; Ext: String;
  AlwaysUseNumber: Boolean = True): String;
var
  DocIndex: Integer;
  FileName: String;
  FileNameFound: Boolean;
begin
  DocIndex := 1;
  Filenamefound := False;
  if not(AlwaysUseNumber) and (not(fileexists(BaseFilename + ext))) then
  begin
    Filename := BaseFilename + ext;
    FilenameFound := true;
  end;
  while not (FileNameFound) do
  begin
    filename := BaseFilename + inttostr(DocIndex) + Ext;
    if fileexists(filename) then
      inc(DocIndex)
    else
      FileNameFound := true;
  end;
  Result := filename;
end;



function CreateUniqueGUIDFileName(sPath, sPrefix, sExtension : string) : string;
   var sFileName : string;
        Guid : TGUID;
begin
  Result := '';
  repeat
   SFileName := '';
   CreateGUID(Guid);
   SFileName := sPath + sPrefix + GUIDtoString(GUID);
   Result := ChangeFileExt(sFileName, sExtension)
  until not FileExists(Result);
end;

function SaveStrToFile(AfileName:string;astring:string):boolean;
var MyText : TStringlist;
    fs     : TFileStream;
begin
  MyText := TStringlist.create;
  fs     := TFileStream.Create(AfileName,fmCreate);
  try
    try
      MyText.Text:=astring;
      MyText.SaveToStream(fs, TEncoding.ANSI);
      fs.Size := fs.Size - Length(System.sLineBreak);
      result:=true;
    Except
      result:=false;
    end;
  finally
    MyText.Free;
    fs.Free;
  end;
end;

function ParseJDBC(ajdbcStr:string):string;
var tmp:string;
    a:integer;
begin
    result:='';
    tmp:=ajdbcStr;
    tmp:=ReplaceText(tmp,'\','');
    if Pos('jdbc:interbase://',tmp)=1
      then
      begin
          tmp:=Copy(tmp,18,length(tmp));
          a:=Pos('/',tmp);
          if (a>1) then
             begin
               tmp:=Copy(tmp,a+1,length(tmp));
               result:=ReplaceText(tmp,'/','\');
             end;
      end;
end;

function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

procedure Unzip7zFile(zipFullFname:string;outDir:string);
begin
  with CreateInArchive(CLSID_CFormat7z) do
    begin
      OpenFile(zipFullFname);
      ForceDirectories(outDir);
      ExtractTo(outDir);
    end;
end;


function JAVAInstalled(aType:Integer):Boolean;  // 0:Lame  1:MAGASIN
var vJavaExe  : string;
    vJavaHome : string;
    vPathGinkoiaDir :string;
begin
   Result := false;
   // La c'est sur une LAME
   if aType=0 then
    begin
       vJavaExe  := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'JAVA\jre1.8.0_131\bin\java.exe';
       vJavaHome := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'JAVA\jre1.8.0_131';
       if FileExists(vJavaExe) then
        begin
            Result := True;
            VGSE.JavaPath := vJavaHome;
            VGSE.Javaversion := '1.8.0_131';
        end;
    end
   // sinon c'est en Mag donc relativement au registre "base0"
   else
    begin
      vPathGinkoiaDir := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(Readbase0)));
      vJavaExe  := IncludeTrailingPathDelimiter(vPathGinkoiaDir) + 'JAVA\jre1.8.0_131\bin\java.exe';
      vJavaHome := IncludeTrailingPathDelimiter(vPathGinkoiaDir) + 'JAVA\jre1.8.0_131';
      if FileExists(vJavaExe) then
        begin
            Result := True;
            VGSE.JavaPath := vJavaHome;
            VGSE.Javaversion := '1.8.0_131';
        end;
    end;
end;

function InstallJAVA(aType:Integer):Boolean;  // 0:Lame  1:MAGASIN
var ResInstallateur   : TResourceStream;
    vJAVA7z : string;
    vPathGinkoiaDir :string;
begin
    If aType=0  then
      begin
        try
          vJAVA7z  := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'JAVA.7z';
          ResInstallateur := TResourceStream.Create(HInstance, 'JAVA', RT_RCDATA);
          try
            ResInstallateur.SaveToFile(vJAVA7z);
          finally
            ResInstallateur.Free();
          end;
          Sleep(150);
          Unzip7zFile(vJAVA7z,'');
          Sleep(150);
          Result := JAVAInstalled(aType);
          DeleteFile(vJAVA7z);
        except
          on e: Exception do
          begin
            // Impossible d'extraire les ressources
            // Journaliser('Impossible d’extraire les ressources.', NivErreur);
            Result := False;
            Exit;
          end;
        end;
        // Extraction et pose
      end
    else   // Pour le moment c'est pareil
      begin
        try
          vJAVA7z  := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'JAVA.7z';
          { réunion du 16/10/2017 : on sort de l'install JAVA : il doit déjà etre présent
          ResInstallateur := TResourceStream.Create(HInstance, 'JAVA', RT_RCDATA);
          try
            ResInstallateur.SaveToFile(vJAVA7z);
            // Journaliser('Programme d’installation extrait.');
          finally
            ResInstallateur.Free();
          end;
          }
          Sleep(150);
          // C'est par rapport à Base0
          vPathGinkoiaDir := IncludeTrailingPathDelimiter(ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(Readbase0))));
          Unzip7zFile(vJAVA7z, IncludeTrailingPathDelimiter(vPathGinkoiaDir+'JAVA'));
          Sleep(150);
          Result := JAVAInstalled(aType);
          // DeleteFile(vJAVA7z); on ne delete pas...
        except
          on e: Exception do
          begin
            // Impossible d'extraire les ressources
            // Journaliser('Impossible d’extraire les ressources.', NivErreur);
            Result := False;
            Exit;
          end;
        end;
      end;
end;

procedure GetJavaInfos;
const REGJAVA = '\Software\JavaSoft\Java Runtime Environment';
var Registre          : TRegistry;
begin
  Registre      := TRegistry.Create(KEY_READ OR KEY_WOW64_64KEY);
  try
    Registre.RootKey  := HKEY_LOCAL_MACHINE;
    if Registre.OpenKey(REGJAVA, False) then
      begin
        VGSE.Javaversion := Registre.ReadString('CurrentVersion');
        if Registre.OpenKey(Format('%s\%s',[REGJAVA,VGSE.Javaversion]), False) then
          begin
              VGSE.JavaPath  := Registre.ReadString('JavaHome');
          end;
      end;
  finally
    Registre.Free();
  end;

  if VGSE.JavaPath='' then
    begin
        Registre      := TRegistry.Create(KEY_READ OR KEY_WOW64_32KEY);
        try
          Registre.RootKey  := HKEY_LOCAL_MACHINE;
          if Registre.OpenKey(REGJAVA, False) then
            begin
              VGSE.Javaversion := Registre.ReadString('CurrentVersion');
              if Registre.OpenKey(Format('%s\%s',[REGJAVA,VGSE.Javaversion]), False) then
                begin
                    VGSE.JavaPath  := Registre.ReadString('JavaHome');
                end;
            end;
        finally
          Registre.Free();
        end;
    end;



end;

procedure MyCreateParams(var Params: TCreateParams);
var LShadow: boolean;
begin
     // Pas de Shadow en remotesession
    // If IsRemoteSession then exit;
     if (Win32Platform = VER_PLATFORM_WIN32_NT)
        and ((Win32MajorVersion > 5)
        or ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1)))
       then
          begin
              //Win XP or higher
              if SystemParametersInfo(SPI_GETDROPSHADOW, 0, @LShadow, 0)
                and LShadow
              then Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW
              else Params.WindowClass.Style := Params.WindowClass.Style and not CS_DROPSHADOW;
              // If Var_Glob.Debug then WriteOnDebugFile('MyCreateParams  (XP ou +)');
          end;
end;


function SecondToTime(const Seconds: double): String;
var ms, ss, mm, hh, dd: integer;
    sec :Integer;
begin
  sec := Trunc(Seconds);
  dd :=  sec div SecsPerDay;
  hh := (sec mod SecsPerDay) div 3600;
  mm := ((sec mod SecsPerDay) mod 3600) div 60;
  ss := ((sec mod SecsPerDay) mod 3600) mod 60;
  //  ms := Round(Frac(Seconds)*1000);
  if hh>0
    then result := Format('%.2d:%.2d:%.2d',[hh,mm,ss])
    else result := Format('%.2d:%.2d',[mm,ss]);
end;


function ProcessIsRunning(Const exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(string(FProcessEntry32.szExeFile))) =
      UpperCase(ExtractFileName(ExeFileName))) or (UpperCase(string(FProcessEntry32.szExeFile)) =
      UpperCase(ExtractFileName(ExeFileName)))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

Function KillProcess(const ProcessName : string) : boolean;
var
  ProcessEntry32  : TProcessEntry32;
  HSnapShot,
  HProcess        : THandle;
begin
  Result := true;  // S'il ne tourne pas faut répondre true
  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then exit;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
  repeat
    if CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 then
    begin
      Result := false;  // il a été trouvé... on passe à False
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        Result := TerminateProcess(HProcess, 0);
        // le result repasse à true si on arrive a le tuer...
        CloseHandle(HProcess);
      end;
      Break;
    end;
  until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

end.
