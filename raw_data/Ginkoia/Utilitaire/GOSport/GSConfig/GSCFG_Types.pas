unit GSCFG_Types;

interface

uses Sysutils, Classes, Inifiles;//, Windows;


type
  // Exception
  EERRORFILE = class(Exception); // Erreur quand il n'y a une erreur d'ouverture d'un fichier CSV

  TTypeSaisie = (tsNull, tsAjout, tsModif, tsSuppression);

  // Gestion du fichier Ini
  TIniStruct = record
      BasePath : String; // chemin de la base de données locale
      FTP : record // Configuration du FTP
        Host,
        UserName,
        PassWord : String;
        Port : Integer;
        Passif : Boolean;
        SSL : Boolean;
      end;
      FTPDir : record // Chemin d'acces aux FTP
        Mode : Integer;
        Principal,
        Test,
        Courir,
        GoSport,
        Envoi,
        reception : String;
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
    GCHEMINBASE : String;

    GTypeSaisie : TTypeSaisie;

    IniStruct : TIniStruct;

  // Permet de créer les répertoires s'il n'existe pas
  function DoDir(sDirName : String) : Boolean;


implementation

//uses
//  Windows;

procedure TIniStruct.LoadIni;
begin
  With TIniFile.Create(GAPPPATH + ChangeFileExt(GAPPNAME,'.ini')) do
  try
    BasePath         := ReadString('MAINDB','PATH','');

    FTP.Host         := ReadString('FTP','HOST','');
    FTP.UserName     := ReadString('FTP','USER','');
    FTP.PassWord     := ReadString('FTP','PWD','');
    FTP.Port         := ReadInteger('FTP','PORT',0);
    FTP.Passif       := ReadBool('FTP','PASSIF',False);
    FTP.SSL          := ReadBool('FTP','SSL',False);

    FTPDir.Mode      := ReadInteger('FTPDir','MODE',0);
    FTPDir.Principal := ReadString('FTPDir','PRINCIPAL','');
    FTPDir.Test      := ReadString('FTPDir','TEST','');
    FTPDir.Courir    := ReadString('FTPDir','COURIR','');
    FTPDir.GoSport   := ReadString('FTPDir','GOSPORT','');
    FTPDir.Envoi     := ReadString('FTPDir','ENVOI','');
    FTPDir.reception := ReadString('FTPDir','RECEPTION','');

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
  finally
    Free;
  end;
end;

procedure TIniStruct.SaveIni;
begin
  With TIniFile.Create(GAPPPATH + ChangeFileExt(GAPPNAME,'.ini')) do
  try
    WriteString('MAINDB','PATH',BasePath);

    WriteString('FTP','HOST',FTP.Host);
    WriteString('FTP','USER',FTP.UserName);
    WriteString('FTP','PWD',FTP.PassWord);
    WriteInteger('FTP','PORT',FTP.Port);
    WriteBool('FTP','PASSIF',FTP.Passif);
    WriteBool('FTP','SSL',FTP.SSL);

    WriteInteger('FTPDir','MODE',FTPDir.Mode);
    WriteString('FTPDir','PRINCIPAL',FTPDir.Principal);
    WriteString('FTPDir','TEST',FTPDir.Test);
    WriteString('FTPDir','COURIR',FTPDir.Courir);
    WriteString('FTPDir','GOSPORT',FTPDir.GoSport);
    WriteString('FTPDir','ENVOI',FTPDir.Envoi);
    WriteString('FTPDir','RECEPTION',FTPDir.reception);

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


end.
