unit GSData_Types;

interface

uses
  Windows, Sysutils, Classes, Inifiles, GSData_TErreur, Generics.Collections;


type
  // Exception
  EERRORFILE = class(Exception); // Erreur quand il n'y a une erreur d'ouverture d'un fichier CSV
  ENOTFIND = class(Exception);  // Paramètre inéxistant
  ECFGERROR = Class(Exception); // Valeur 0 dans le paramètre

  TTypeActionTable = (ttatNull, ttatInsert, ttatUpdate, ttatDelete);

  // Pour la récupération des informations CodeArticle
  TCodeArticle = record
    ART_ID,
    TGF_ID,
    COU_ID : Integer;
  end;

  // Gestion du fichier Ini
  TIniStruct = record
      DebugMode : Boolean;
      BasePath : String; // chemin de la base de données locale
      FTP: record // Configuration du FTP
        Host      ,
        UserName  ,
        PassWord  : String;
        Port      : Integer;
        Passif    : Boolean;
        SSL       : Boolean;
        Actif     : Boolean;
      end;
      FTPDir: record // Chemin d'acces aux FTP
        Mode      : Integer;
        Principal ,
        Test      ,
        Courir    ,
        GoSport   ,
        Envoi     ,
        Reception ,
        Referentiel : String;
        DeleteFileFromFTP : Boolean;
      end;
      SFTP: record // Configuration du SFTP
        Host      ,
        Username  ,
        Password  : String;
        Port      : Integer;
        Actif     : Boolean;
        Compression: Boolean;
        Attempts   : Integer;
        Timeout    : Integer;
      end;
      SFTPDir: record // Chemin d'acces au SFTP
        Mode      : Integer;
        Principal ,
        Test      ,
        Courir    ,
        GoSport   ,
        Envoi     ,
        Reception ,
        Referentiel : String;
        DeleteFileFromFTP : Boolean;
      end;
      Mail : record // Configuration du mail
        Host,
        UserName,
        Password : String;
        Port : Integer;
        SSL : Boolean;
      end;
      Others : record // autres paramètres
        IdGsData : String;
        Timer : Integer;
        MailList : TStringList;
        NoJeton : Boolean;
      end;
      Archivage : record
        NumJour : Integer;
        NbJours : Integer;
        Actif   : Boolean;
        NextArch : TDate;
      end;
    public
      procedure LoadIni;
      procedure SaveIni;
      procedure FreeObject;
  end;

Var
  // Variable Globale : Chemin d'accès, fichier ini etc ..
  GAPPPATH ,
  GAPPNAME ,
  GAPPFILE ,
  GAPPFTP  ,
  GLOGSPATH ,
  GLOGSNAME,
  GAPPRAPPORT ,
  GAPPDOSSIER ,
  GDIRDOSSIER ,
  GARCHIVAGEDIR : String;

  GSTARTTIME : TDateTime;
  GSTOPTIME  : Boolean;
  GWORKINPROGRESS : Boolean;

  GERREURS : TList<TErreur>;

  IniStruct : TIniStruct;

  // CBR pour les tests
  vgIteration : Integer;
  vgLigne     : String;

  DoCloseApp : Boolean;
  DoHideApp  : Boolean;


// Attente propre
procedure DoWait(AMillisecondes : Integer);

// Permet de créer les répertoires s'il n'existe pas
function DoDir(sDirName : String) : Boolean;

// Permet de récupérer la liste des fichiers d'un répertoire
Function GetFileFromDir (ADirectory, AFilter : String) : TStringList;

// Transforme un boolean en texte
function BoolToText(vpBool : Boolean) : String;
// Procédure de formatage de l'affichage de millisecondes
function FormatMS(MilliSecondes: Cardinal): string;

implementation

uses
  Forms;

procedure TIniStruct.LoadIni;
begin
  With TIniFile.Create(GAPPPATH + ChangeFileExt(GAPPNAME,'.ini')) do
  try
    DebugMode        := ReadInteger('GK','DEBUG',0) = 1;
    BasePath         := ReadString('MAINDB','PATH','');

    {$REGION 'Affectation des structures FTP'}
    FTP.Actif         := ReadBool( 'FTP', 'ACTIF', False );

    FTP.Host          := ReadString('FTP','HOST','');
    FTP.UserName      := ReadString('FTP','USER','');
    FTP.PassWord      := ReadString('FTP','PWD','');
    FTP.Port          := ReadInteger('FTP','PORT',0);
    FTP.Passif        := ReadBool('FTP','PASSIF',False);
    FTP.SSL           := ReadBool('FTP','SSL',False);

    FTPDir.Mode        := ReadInteger('FTPDir','MODE',0);
    FTPDir.Principal   := ReadString('FTPDir','PRINCIPAL','');
    FTPDir.Test        := ReadString('FTPDir','TEST','');
    FTPDir.Courir      := ReadString('FTPDir','COURIR','');
    FTPDir.GoSport     := ReadString('FTPDir','GOSPORT','');
    FTPDir.Envoi       := ReadString('FTPDir','ENVOI','');
    FTPDir.reception   := ReadString('FTPDir','RECEPTION','');
    FTPDir.Referentiel := ReadString('FTPDir','REFERENTIEL','');
    FTPDir.DeleteFileFromFTP := ReadBool('FTPDir','DELETEFILE',False);
    {$ENDREGION}

    {$REGION 'Affectation des structures SFTP'}
    SFTP.Actif        := ReadBool( 'SFTP', 'ACTIF', False );

    SFTP.Host         := ReadString ( 'SFTP', 'HOST', '' );
    SFTP.Username     := ReadString ( 'SFTP', 'USER', '' );
    SFTP.Password     := ReadString ( 'SFTP', 'PWD' , '' );
    SFTP.Port         := ReadInteger( 'SFTP', 'PORT',  0 );

    {$REGION 'Erreur lors d''envoi de fichier PutFileOnSFTP...'}
    SFTP.Compression  := ReadBool( 'SFTP', 'COMPRESSION', True );
    SFTP.Attempts     := ReadInteger( 'SFTP', 'ATTEMPTS', 3 );
    // Si ATTEMPTS a une valeur strictement négative, comme cela n'a pas de sens
    // on la met à0 (= tentative infinie (cf: PutFileOnSFTP))
    if SFTP.Attempts < 0 then
      SFTP.Attempts   := 0;
    SFTP.Timeout := ReadInteger( 'SFTP', 'TIMEOUT', 2000 );
    // Si TIMEOUT a une valeur strictement négative, comme cela n'a pas de sens
    // on la met à 0 (= aucun délai (cf: PutFileOnSFTP))
    if SFTP.Timeout < 0 then
      SFTP.Timeout := 0;
    {$ENDREGION 'Erreur lors d''envoi de fichier PutFileOnSFTP...'}

    SFTPDir.Mode        := ReadInteger( 'SFTPDir', 'MODE'     ,  0 );
    SFTPDir.Principal   := ReadString ( 'SFTPDir', 'PRINCIPAL', '' );
    SFTPDir.Test        := ReadString ( 'SFTPDir', 'TEST'     , '' );
    SFTPDir.Courir      := ReadString ( 'SFTPDir', 'COURIR'   , '' );
    SFTPDir.GoSport     := ReadString ( 'SFTPDir', 'GOSPORT'  , '' );
    SFTPDir.Envoi       := ReadString ( 'SFTPDir', 'ENVOI'    , '' );
    SFTPDir.Reception   := ReadString ( 'SFTPDir', 'RECEPTION', '' );
    SFTPDir.Referentiel := ReadString ( 'SFTPDir', 'REFERENTIEL','');
    SFTPDir.DeleteFileFromFTP := ReadBool('SFTPDir','DELETEFILE',False);
    {$ENDREGION}

    Mail.Host        := ReadString('Mail','HOST','');
    Mail.UserName    := ReadString('Mail','User','');
    Mail.Password    := ReadString('Mail','PWD','');
    Mail.Port        := ReadInteger('Mail','Port',0);
    Mail.SSL         := ReadBool('Mail','SSL',False);

    Others.IdGsData  := ReadString('OTHERS','IDGSDATA','');
    Others.Timer     := ReadInteger('OTHERS','TIMER',60);
    if not Assigned(Others.MailList) then
      Others.MailList := TStringList.Create;
    if FileExists(GAPPFILE + 'MailList.txt') then
      Others.MailList.LoadFromFile(GAPPFILE + 'MailList.txt');

    Others.NoJeton   := ReadBool('GK','NOJETON',False);

    Archivage.NumJour := ReadInteger('ARCHIVAGE','NUMJOUR',1);
    Archivage.NbJours := ReadInteger('ARCHIVAGE','NBJOURS',30);
    Archivage.Actif   := ReadBool('ARCHIVAGE','ACTIF',False);
    Archivage.NextArch := ReadDate('ARCHIVAGE','NEXT',Now);
  finally
    Free;
  end;
end;

procedure TIniStruct.SaveIni;
begin
  With TIniFile.Create(GAPPPATH + ChangeFileExt(GAPPNAME,'.ini')) do
  try
    WriteString('MAINDB','PATH',BasePath);

    {$REGION 'Sauvegarde des structures FTP'}
    WriteBool   ( 'FTP', 'ACTIF' , FTP.Actif    );

    WriteString ( 'FTP', 'HOST'  , FTP.Host     );
    WriteString ( 'FTP', 'USER'  , FTP.UserName );
    WriteString ( 'FTP', 'PWD'   , FTP.PassWord );
    WriteInteger( 'FTP', 'PORT'  , FTP.Port     );
    WriteBool   ( 'FTP', 'PASSIF', FTP.Passif   );
    WriteBool   ( 'FTP', 'SSL'   , FTP.SSL      );

    WriteInteger('FTPDir', 'MODE'     , FTPDir.Mode      );
    WriteString ('FTPDir', 'PRINCIPAL', FTPDir.Principal );
    WriteString ('FTPDir', 'TEST'     , FTPDir.Test      );
    WriteString ('FTPDir', 'COURIR'   , FTPDir.Courir    );
    WriteString ('FTPDir', 'GOSPORT'  , FTPDir.GoSport   );
    WriteString ('FTPDir', 'ENVOI'    , FTPDir.Envoi     );
    WriteString ('FTPDir', 'RECEPTION', FTPDir.reception );
    WriteString ('FTPDir', 'REFERENTIEL', FTPDir.Referentiel);
    WriteBool('FTPDIR','DELETEFILE',FTPDir.DeleteFileFromFTP);
    {$ENDREGION}

    {$REGION 'Sauvegarde des structures SFTP'}
    WriteBool   ( 'SFTP', 'ACTIF', SFTP.Actif   );

    WriteString ( 'SFTP', 'HOST', SFTP.Host     );
    WriteString ( 'SFTP', 'USER', SFTP.UserName );
    WriteString ( 'SFTP', 'PWD' , SFTP.PassWord );
    WriteInteger( 'SFTP', 'PORT', SFTP.Port     );

    WriteInteger( 'SFTPDir', 'MODE'     , SFTPDir.Mode      );
    WriteString ( 'SFTPDir', 'PRINCIPAL', SFTPDir.Principal );
    WriteString ( 'SFTPDir', 'TEST'     , SFTPDir.Test      );
    WriteString ( 'SFTPDir', 'COURIR'   , SFTPDir.Courir    );
    WriteString ( 'SFTPDir', 'GOSPORT'  , SFTPDir.GoSport   );
    WriteString ( 'SFTPDir', 'ENVOI'    , SFTPDir.Envoi     );
    WriteString ( 'SFTPDir', 'RECEPTION', SFTPDir.Reception );
    WriteString ( 'SFTPDir', 'REFERENTIEL', SFTPDir.Referentiel);
    WriteBool('SFTPDir','DELETEFILE',SFTPDir.DeleteFileFromFTP);
    {$ENDREGION}

    WriteString('Mail','HOST',Mail.Host);
    WriteString('Mail','User',Mail.UserName);
    WriteString('Mail','PWD',Mail.Password);
    WriteInteger('Mail','Port',Mail.Port);
    WriteBool('Mail','SSL',Mail.SSL);

    WriteString('OTHERS','IDGSDATA',Others.IdGsData);
    WriteInteger('OTHERS','TIMER',Others.Timer);
    if Assigned(Others.MailList) then
    begin
      if FileExists(GAPPFILE + 'MailList.txt') then
        DeleteFile(GAPPFILE + 'MailList.txt');
      Others.MailList.SaveToFile(GAPPFILE + 'MailList.txt');
    end;

    WriteBool('GK','NOJETON',Others.NoJeton);

    WriteInteger('ARCHIVAGE','NUMJOUR',Archivage.NumJour);
    WriteInteger('ARCHIVAGE','NBJOURS',Archivage.NbJours);
    WriteBool('ARCHIVAGE','ACTIF',Archivage.Actif);
    WriteDate('ARCHIVAGE','NEXT',Archivage.NextArch);

  finally
    Free;
  end;
end;

procedure TIniStruct.FreeObject;
begin
  if Assigned(Others.MailList) then
  begin
    Others.MailList.Clear;
    Others.MailList.Free;
  end;

end;

procedure DoWait(AMillisecondes : Integer);
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

Function GetFileFromDir (ADirectory, AFilter : String) : TStringList;
var
  Search : TSearchRec;
  i : Integer;
begin
  Result := TStringList.Create;

  i := FindFirst(ADirectory + AFilter,faAnyFile,Search);
  try
    while i = 0 do
    begin
      if not ((Search.Attr = faDirectory) or (Search.Name = '.') or (Search.Name = '..')) then
        Result.Add(Search.Name);

      i := FindNext(Search);
    end;
  finally
    SysUtils.FindClose(Search);
  end;

end;

function BoolToText(vpBool : Boolean) : String;
begin
  if vpBool then
    Result := 'True'
  else
    Result := 'False';
end;

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

end.
