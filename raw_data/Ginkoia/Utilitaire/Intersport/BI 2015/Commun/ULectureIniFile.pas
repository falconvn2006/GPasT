unit ULectureIniFile;

interface

uses
  System.Classes;

function ReadIniBaseConf(out Serveur, Base : string) : boolean;
function WriteIniBaseConf(Serveur, Base : string) : boolean;

function ReadIniShowMagasin(out ShowMagasin : boolean) : boolean;
function WriteIniShowMagasin(ShowMagasin : boolean) : boolean;

function ReadIniOnlyServeur(out OnlyServeur : boolean) : boolean;
function WriteIniOnlyServeur(OnlyServeur : boolean) : boolean;

function ReadIniColonneListeMagasin(out Code, Nom, Enseigne : boolean) : boolean;
function WriteIniColonneListeMagasin(Code, Nom, Enseigne : boolean) : boolean;
function ReadIniColonneParametrage(out Code, Nom, Enseigne : boolean) : boolean;
function WriteIniColonneParametrage(Code, Nom, Enseigne : boolean) : boolean;
function ReadIniDefautAction(out DefautAction : integer) : boolean;
function WriteIniDefautAction(DefautAction : integer) : boolean;

implementation

uses
  Vcl.Forms,
  System.SysUtils,
  System.IniFiles;

function ReadIniBaseConf(out Serveur, Base : string) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  // Init
  Serveur := 'magmdc.no-ip.org';
  Base := 'F:\IF_CONFIG\DbMag\DBMAG.IB';

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        Serveur := IniFile.ReadString('DATABASE', 'SERVEUR', Serveur);
        Base := IniFile.ReadString('DATABASE', 'FILENAME', Base);
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

function WriteIniBaseConf(Serveur, Base : string) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      IniFile := TIniFile.Create(IniName);
      // fichier de base
      IniFile.WriteString('DATABASE', 'SERVEUR', Serveur);
      IniFile.WriteString('DATABASE', 'FILENAME', Base);
      // ok !
      Result := true;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniShowMagasin(out ShowMagasin : boolean) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  // Init
  ShowMagasin := true;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        ShowMagasin := IniFile.ReadBool('SHOW', 'MAGASIN', ShowMagasin);
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

function WriteIniShowMagasin(ShowMagasin : boolean) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      IniFile := TIniFile.Create(IniName);
      // fichier de base
      IniFile.WriteBool('SHOW', 'MAGASIN', ShowMagasin);
      // ok !
      Result := true;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniOnlyServeur(out OnlyServeur : boolean) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  // Init
  OnlyServeur := true;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        OnlyServeur := IniFile.ReadBool('SHOW', 'ONLYSERVEUR', OnlyServeur);
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

function WriteIniOnlyServeur(OnlyServeur : boolean) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      IniFile := TIniFile.Create(IniName);
      // fichier de base
      IniFile.WriteBool('SHOW', 'ONLYSERVEUR', OnlyServeur);
      // ok !
      Result := true;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniColonneListeMagasin(out Code, Nom, Enseigne : boolean) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  // Init
  Code := true;
  Nom := true;
  Enseigne := true;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        Code := IniFile.ReadBool('LISTEMAGASINS', 'CODE', Code);
        Nom := IniFile.ReadBool('LISTEMAGASINS', 'NOM', Nom);
        Enseigne := IniFile.ReadBool('LISTEMAGASINS', 'ENSEIGNE', Enseigne);
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

function WriteIniColonneListeMagasin(Code, Nom, Enseigne : boolean) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      IniFile := TIniFile.Create(IniName);
      // fichier de base
      IniFile.WriteBool('LISTEMAGASINS', 'CODE', Code);
      IniFile.WriteBool('LISTEMAGASINS', 'NOM', Nom);
      IniFile.WriteBool('LISTEMAGASINS', 'ENSEIGNE', Enseigne);
      // ok !
      Result := true;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniColonneParametrage(out Code, Nom, Enseigne : boolean) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  // Init
  Code := true;
  Nom := true;
  Enseigne := true;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        Code := IniFile.ReadBool('PARAMETRAGE', 'CODE', Code);
        Nom := IniFile.ReadBool('PARAMETRAGE', 'NOM', Nom);
        Enseigne := IniFile.ReadBool('PARAMETRAGE', 'ENSEIGNE', Enseigne);
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

function WriteIniColonneParametrage(Code, Nom, Enseigne : boolean) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      IniFile := TIniFile.Create(IniName);
      // fichier de base
      IniFile.WriteBool('PARAMETRAGE', 'CODE', Code);
      IniFile.WriteBool('PARAMETRAGE', 'NOM', Nom);
      IniFile.WriteBool('PARAMETRAGE', 'ENSEIGNE', Enseigne);
      // ok !
      Result := true;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function ReadIniDefautAction(out DefautAction : integer) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  // Init
  DefautAction := 1;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      if FileExists(IniName) then
      begin
        IniFile := TIniFile.Create(IniName);
        // fichier de base
        DefautAction := IniFile.ReadInteger('DEFAUT', 'ACTION', DefautAction);
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

function WriteIniDefautAction(DefautAction : integer) : boolean;
var
  IniName : string;
  IniFile : TIniFile;
begin
  Result := false;
  IniFile := nil;

  IniName := ChangeFileExt(Application.ExeName, '.ini');
  try
    try
      IniFile := TIniFile.Create(IniName);
      // fichier de base
      IniFile.WriteInteger('DEFAUT', 'ACTION', DefautAction);
      // ok !
      Result := true;
    except
//      on e : Exception do
//        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

end.
