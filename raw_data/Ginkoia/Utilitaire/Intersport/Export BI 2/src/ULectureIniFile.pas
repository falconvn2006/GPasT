unit ULectureIniFile;

interface

uses
  System.Classes,
  GestionEMail;

function ReadIniBase(out BaseConf : string) : boolean;
function ReadIniVerifCA(out NbJour : integer) : boolean;
function ReadIniLogs(out NiveauLog : integer) : boolean;
function ReadIniFTP(out Server, Username, Password, Directory : string; out Port : integer) : boolean;
function ReadIniMail(out Server, Username, Password, Sender : string; out Port : integer; out Securite : SecuriteMail; out Destinataire : TStringList) : boolean;

function ReadIniFiltreDossier(out FilterDossier : string) : boolean;
function ReadIniFiltreMagasin(out FilterMagasin : string) : boolean;

implementation

uses
  Vcl.Forms,
  System.SysUtils,
  System.IniFiles;

function ReadIniBase(out BaseConf : string) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;

  // Init
  BaseConf := '';

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        BaseConf := IniFile.ReadString('DATABASE', 'PATH', '');
        // ok !
        Result := true;
      end;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniLogs(out NiveauLog : integer) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;

  // Init
  NiveauLog := 0;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        NiveauLog := IniFile.ReadInteger('LOGS', 'NIVEAU', 6);
        // ok !
        Result := true;
      end;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniVerifCA(out NbJour : integer) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;

  // Init
  NbJour := 0;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        NbJour := IniFile.ReadInteger('VERIFCA', 'NBJOUR', 30);
        // ok !
        Result := true;
      end;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniFTP(out Server, Username, Password, Directory : string; out Port : integer) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;

  // information FPT
  Server := '';
  Port := 0;
  Username := '';
  Password := '';
  Directory := '';

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // infos ftp
        Server := IniFile.ReadString('FTP', 'URL', '');
        Port := IniFile.ReadInteger('FTP', 'PORT', 0);
        Username := IniFile.ReadString('FTP', 'USER', '');
        Password := IniFile.ReadString('FTP', 'PWD', '');
        Directory := IniFile.ReadString('FTP', 'FOLDER', '');
        // ok !
        Result := true;
      end;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniMail(out Server, Username, Password, Sender : string; out Port : integer; out Securite : SecuriteMail; out Destinataire : TStringList) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;

  // information Mail
  Server := '';
  Port := 0;
  Username := '';
  Password := '';
  Securite := tsm_Aucun;
  Sender := '';
  if Assigned(Destinataire) then
    Destinataire.Clear()
  else
  begin
    Destinataire := TStringList.Create();
    Destinataire.Delimiter := ';';
  end;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // infos mail
        Server := IniFile.ReadString('MAIL', 'SERVER', '');
        Port := IniFile.ReadInteger('MAIL', 'PORT', 0);
        Username := IniFile.ReadString('MAIL', 'USER', '');
        Password := IniFile.ReadString('MAIL', 'PWD', '');
        Securite := SecuriteMail(IniFile.ReadInteger('MAIL', 'SECU', 0));
        Sender := IniFile.ReadString('MAIL', 'SENDER', '');
        Destinataire.DelimitedText := IniFile.ReadString('MAIL', 'DEST', '');
        // ok !
        Result := true;
      end;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniFiltreDossier(out FilterDossier : string) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;

  // Init
  FilterDossier := '';

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        FilterDossier := IniFile.ReadString('FILTER', 'DOSSIER', '');
        // ok !
        Result := true;
      end;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniFiltreMagasin(out FilterMagasin : string) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;

  // Init
  FilterMagasin := '';

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        FilterMagasin := IniFile.ReadString('FILTER', 'MAGASIN', '');
        // ok !
        Result := true;
      end;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

end.
