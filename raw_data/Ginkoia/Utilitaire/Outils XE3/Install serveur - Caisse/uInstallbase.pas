
unit uInstallbase;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShlObj, Winapi.ActiveX, System.SysUtils,
  System.Variants, System.Classes, System.Types, System.IOutils, System.Win.registry,
  System.StrUtils, System.Win.ComObj, Vcl.Forms, Vcl.ComCtrls, shellAPI, Dialogs,
  System.IniFiles, System.Math,
  // Uses Perso
  uFunctions, uLog, uRessourcestr, HTTPApp, IdHTTP,
  // Fin Uses
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Factory, FireDAC.Stan.Def, FireDAC.DApt,
  FireDAC.Stan.Async, FireDAC.Stan.Error, FireDAC.Phys.IB, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Script, FireDAC.Comp.ScriptCommands, System.Generics.Collections; // supprimer dialog

const
  URLRECUPBASEINI = 'http://lame2.ginkoia.eu/maj/GINKOIA/';
  FILENAMERECUPBASEINI = 'recupbase.ini';
  cDossierCASH = 'CASH';
  cParamCASH = 'Tools\CashSettings.exe';

type
  TAddShop = reference to procedure(sMagasin: string; aMagID: Integer);

  TAddPoste = reference to procedure(sPoste: string; aPosID: Integer);
  // on pourrait utiliser Taddshop

  TTypePoste = (TypeServeur, TypePortable, TypeCaisseSec, TypeCaisseSimple);

  TTypeParam = (PRM_STRING, PRM_INTEGER);

  TGenParam = record
    prm_string: string;
    prm_integer: integer;
  end;

  Tinstall = class(Tobject)
  private
    Fpath: string;
    FdatabasePath: string;
    FBplPath: string;
    Fbase: string;
    Fserveur: string;
    FDrive: string;
    FPathBdd: string;
    FConnexion: string;
    Ferrormsg: string;
    FInfo: string;
    ptAddShop: TAddShop;
    ptAddPoste: TAddPoste;
    ptAddPosteSecours: TAddPoste;
    fNoInit: boolean;
    FMagasinSurServeur: string;
    FplageMagasin: string;
    FNumMagasin: string;
    FBasSender: string;
    procedure DecodePlage(S: string; var Deb, fin: integer);
    procedure GetSQLInfo(Text: string; out Table, Champ, Cond: string);
    type
      TBase = class(Tobject)
      private
        Ferror: string;
        procedure ConnectToHost(aHost: string; aBdd: string; Master: boolean);
      protected
        Data: TFDConnection;
        Qry: TFDQuery;
      // SQL: TIBSQL;
        Tran: TFDTransaction;
      public
        constructor Create;
        destructor Destroy;
        procedure ConnectTo(BddName: string; Master: boolean);
        procedure Disconnect;
        property Error: string read Ferror write Ferror;
      end;
    type
      TRecupbase = class(Tobject)
        Fdestination: string;
        FSource: string;
        Ferrorbase: string;
      public
        constructor Create(sDestination, sSource: string);
        destructor Free;
        function MoveDatabase: boolean;
        function MoveEAI: boolean;
      end;
    type
      TMachine = class(Tobject)
        var
          Ferrormsg: string;
      private

      public
        function CreateShortcut(Nom, Fichier, Description, Repertoire, Icon: string; Index: integer = 0): Boolean;
        function CreateRaccourciAndIniCASH(aGinkoiaPath: string; aType: TTypePoste; aServeurHost: string; aCaisseSecHost: String): Boolean;
        function NomDuPoste: string;
        function BuildIni(aGinkoiaPath: String; aTypePoste: TTypePoste; aServeurHost, aCaisseSecHost: String): boolean;
        property Error: string read Ferrormsg write Ferrormsg;
      end;
    type
      TBaseSender = class(Tobject)
      private
        Fbas_id: integer;
        Fbas_nom: string;
        Fbas_guid: string;
        Fbas_dossier: string;
        constructor Create(); overload;
      public
        property bas_id: integer read Fbas_id write Fbas_id;
        property bas_nom: string read Fbas_nom write Fbas_nom;
        property bas_guid: string read Fbas_guid write Fbas_guid;
        property bas_dossier: string read Fbas_dossier write Fbas_dossier;
      end;
    type
      TLangue = class(Tobject)
      private
        FimgIndex: integer;
        Fname: string;
        FupdateRegionals: boolean;
        constructor Create();
      public
        property ImgIndex: integer read FimgIndex write FimgIndex;
        property Name: string read Fname write Fname;
        property UpdateRegionals: boolean read FupdateRegionals write FupdateRegionals;
      end;
  public
    Database: TBase;
    Recupbase: TRecupbase;
    Machine: TMachine;
    PathBasetest: string;
    PathWebService: string;
    GUIID: string;
    BaseSenderSelected: TBaseSender;
    Language: TLangue;
    constructor Create(sPath: string; sPathBaseDistant: string = ''); overload;
    //constructor Create(sPath: string; bMachine: boolean); overload;
    destructor Destroy();
    destructor Free;
    function Referencement: boolean;
    function SetPathBPL: boolean;
    function Connect(IfMaster: boolean): boolean;
    procedure GetShop;
    function GetMainShop: string;
    procedure GetPoste(sMag: string);
    procedure GetPosteSecours(sMag: string);
    function GetMagPortable(sMag: string): TStringList;
    function PosteExist(sPoste: string; bSelection: array of string): string;
    function SetRecupBase(sDestination, sSource: string): boolean;
    function GetMagasinSurServeur: boolean;
    function GetMagasinSurServeurSecours: boolean;
    function OpenServeur(Master: boolean = False): boolean;
    function DoRecupBase(aBasNom: String; IsEasy: Boolean): boolean;
    function SetBaseSenderFromDatabase: boolean;
    procedure CreateIniServeur(magasin, Poste: string);
    procedure CreateIniPoste(magasin, Poste: string);
    procedure CreateIniPortable(magasin, Poste, ServNom, letterDirDis: string; bSelection: array of string; LstServAdd: TStringList = nil);
    procedure CreateIniCaisseSecours(LetterDir, LocalServer, ServSecours, magasin, Poste, PosteSecour, DirDistantSec: string; IsServeur: boolean);
    function GetNameServ(magasin: string): string;
    function GetDirServ(magasin: string): string;
    function GetServPrin(aDirServ, aMag: string): string;
    function UpdatePatchInstall(LetterDir, PathBase, MagNom: string): boolean;
    function UpdateLetterDir(GinkoiaDirectory: string): boolean;
    function DelFilesDir(Directory: string): boolean;
    procedure SetLanguage();   // procédure pour récupérer la langue dans la base et set l'objet Tlangue
    function GetModules: TstringList; // récupère les modules pour le magasin actif en base (bas_magid dans genbases)
    function GetGENPARAM(aType, aCode: Integer; ATypeParam: TTypeParam): Variant;
    procedure SetGENPARAM(aType, aCode, aMaGid, aPosID: Integer; aParam: TGenParam);
    function GetBasIdFromMagID(aMagID: Integer): Integer;
    procedure ConnectBestMethode();

    // WebService
    function GetUrlWebService(DirGinkoia: string): boolean;
    function GetFromWebService(PatchWebService, GUID, UserLogged, TypeAction: string; var ResponseWebService: string): boolean;
    function SetFromWebService(PatchWebService, GUID, UserLogged, TypeAction: string; var ResponseWebService: string): boolean;

    // Cash
    function CanInstallCash: Boolean;

    // Easy
    function IsEasy: boolean;
    procedure GetListeBases(aTypePoste: TTypePoste; var ListBases: TObjectList<Tobject>);
    function GetSenderName(aSender: Tobject): string;
    function GetSenderID(aSender: Tobject): integer;
    procedure SetBaseSenderSelected(aSender: Tobject);
    function PosteInBase(aSender: TBaseSender): boolean;
    function DROP_SYMDS(aProgressBar: TProgressBar = Nil): boolean;
    function GRANT_FOR_EASY(): boolean;
    property AddShop: TAddShop write ptAddShop;
    property AddPoste: TAddPoste write ptAddPoste;
    property AddPosteSecours: TAddPoste write ptAddPosteSecours;
    property ErrorMsg: string read Ferrormsg write Ferrormsg;
    property Info: string read FInfo write FInfo;
    property NoInit: boolean read fNoInit write fNoInit;
    // pour empêcher l'écrasement du fichier par un fichier malformé

    property Server: string read Fserveur write Fserveur;
    // pour installation caisse de forme NOM:
    property Drive: string read FDrive write FDrive;
    property PathBdd: string read FPathBdd write FPathBdd;
    property Connexion: string read FConnexion write FConnexion;
    property MagasinSurServeur: string read FMagasinSurServeur write FMagasinSurServeur;
    property PlageMagasin: string read FplageMagasin write FplageMagasin;
    property NumMagasin: string read FNumMagasin write FNumMagasin;
    property BasSender: string read FBasSender write FBasSender;
  end;

implementation

uses
  Main_Dm, uToolsXE;

{ ****************************Recupbase***************************************** }
constructor Tinstall.TRecupbase.Create(sDestination: string; sSource: string);
begin
  Fdestination := sDestination; // le chemin de ginkoia\data
  FSource := sSource; // le chemin où le fichier zip a été désinstallé
end;

destructor Tinstall.TRecupbase.Free;
begin
  TDirectory.Delete(FSource);
end;

function Tinstall.TRecupbase.MoveDatabase: boolean;
var
  sFile, sOlderBase: string;
begin
  result := True;
  sOlderBase := IncludeTrailingPathDelimiter(Fdestination) + 'GINKOIA.IB';
  if Tfile.Exists(sOlderBase) then
  begin
    try
      Tfile.Delete(sOlderBase);
    except
      on E: Exception do
      begin
        Ferrorbase := E.Message;
        exit(False);
      end;
    end;
  end;

  sFile := IncludeTrailingPathDelimiter(FSource) + 'GINKOIA.IB';
  try
    Tfile.Move(sFile, sOlderBase);
  except
    on E: Exception do
    begin
      Ferrorbase := E.Message;
      exit(False);
    end;
  end;

end;

function Tinstall.TRecupbase.MoveEAI: boolean;
// var af : Tstringdynarray ;
// fs, fms, fEAI : string ;
// bok : boolean ;
begin
  result := True;
  { * fEAI := Tdirectory.GetParent(Fdestination) ;
    fEAI := IncludeTrailingPathDelimiter(fEAI)+'EAI\' ;
    af := TDirectory.GetFiles(Fsource, '*.xml')  ;
    for fs in af do
    begin
    bok  := True ;
    fms := fEAI+Tpath.GetFileName(fs)  ;
    Try
    if Tinstall.Noinit  = True then
    begin
    if fms.Contains('InitParams') = True then
    if Tinstall.nOinit then bok := False ;
    end;
    if bok = True then
    Tfile.Move(fs, fms);
    Except
    ON E: Exception do
    begin
    result := False ;
    Ferrorbase := E.Message ;
    end;

    End;
    end;  * }

end;

// fonction qui fait le traitement de récup base pour mettre à jour les générateurs
function Tinstall.DoRecupBase(aBasNom: String; IsEasy: Boolean): boolean;
var
  vResultProcess : Integer;
  VPath, vLogRecup: string;

begin
  Result := False;
  VPath := IncludeTrailingBackslash(FdatabasePath);

  if not Assigned(BaseSenderSelected) then
  begin
    ErrorMsg := 'Vous devez choisir le poste à installer';
    exit;
  end;

  if not FileExists(VPath + 'RecupBase.exe') then
  begin
    ErrorMsg := 'Impossible de trouver RecupBase.exe dans ' + VPath;
    exit;
  end;


  // on lance le récup base et on attends le code de retour
  if IsEasy then
    vResultProcess := ExecuteAndWait(VPath + 'RecupBase.exe', '"' + VPath + 'RecupBase.exe' + '"' + ' auto="' + VPath + 'GINKOIA.IB' + '" GENERATEUR BASNOM="' + BaseSenderSelected.bas_nom)
  else
    vResultProcess := ExecuteAndWait(VPath + 'RecupBase.exe', '"' + VPath + 'RecupBase.exe' + '"' + ' auto="' + VPath + 'GINKOIA.IB' + '" BASNOM="' + BaseSenderSelected.bas_nom);

  if vResultProcess <> 0 then
  begin
    vLogRecup := VPath + IntToStr(vResultProcess) + '.log';

    ErrorMsg := 'Erreur lors de la mise à jour des identifiants de base, ' + #13#10 + ' les logs de RecupBase peuvent être consultés à cet emplacement : ' + vLogRecup;

    Exit;
  end
  else
    Result := True;
end;

procedure Tinstall.DecodePlage(S: string; var Deb, fin: integer);
var
  S1: string;
begin
  while not (S[1] in ['0'..'9']) do
    Delete(S, 1, 1);
  S1 := '';
  while (S[1] in ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    Delete(S, 1, 1);
  end;
  Deb := StrToInt(S1);
  while not (S[1] in ['0'..'9']) do
    Delete(S, 1, 1);
  S1 := '';
  while (S[1] in ['0'..'9']) do
  begin
    S1 := S1 + S[1];
    Delete(S, 1, 1);
  end;
  fin := StrToInt(S1);
end;

procedure Tinstall.GetSQLInfo(Text: string; out Table, Champ, Cond: string);
begin
  Table := copy(Text, 1, Pos(';', Text) - 1);
  Delete(Text, 1, Pos(';', Text));
  if Pos(';', Text) > 0 then
  begin
    Champ := copy(Text, 1, Pos(';', Text) - 1);
    Delete(Text, 1, Pos(';', Text));
    Cond := Text;
  end
  else
  begin
    Champ := Text;
    Cond := '';
  end;
end;

{ **************************************Tbase******************************************* }

constructor Tinstall.TBase.Create;
begin
  // Data := TIBDatabase.Create(nil) ;
  // Data.SQLDialect := 3;
  // Data.LoginPrompt := false;
  // Tran := TIBTransaction.Create(Nil);
  // Tran.DefaultDatabase := Data;
  // Data.DefaultTransaction := Tran;
  // SQL := TIBSQL.Create(Nil);
  // Sql.Database := Data;
  // Sql.Transaction := Tran;
  // Qry := TIBQuery.Create(Nil);
  // Qry.Database := Data;
  // Qry.Transaction := Tran;

  Data := TFDConnection.Create(nil);
  Data.DriverName := 'IB';
  Data.Params.Clear();
  Data.Params.Add('Server=localhost');
  Data.Params.Add('Protocol=TCPIP');
  Data.Params.Add('DriverID=IB');
  Tran := TFDTransaction.Create(Nil);
  Tran.Connection := Data;
  Qry := TFDQuery.Create(Nil);
  Qry.Connection := Data;
  Qry.Transaction := Tran;
end;

destructor Tinstall.TBase.Destroy;
begin
  FreeAndNil(Tran);

  // Sql.Close;
  // FreeAndNil(SQL);

  Qry.Close;
  FreeAndNil(Qry);

  // Data.CloseDataSets ;
  Data.Close;
  FreeAndNil(Data);
end;

procedure Tinstall.TBase.Disconnect;
begin
  if Tran.Active then
    Tran.Rollback;
  if Data.Connected then
    Data.Connected := False;
end;

procedure Tinstall.TBase.ConnectTo(BddName: string; Master: boolean);
begin

  Data.Params.Clear();
  Data.DriverName := 'IB';
  Data.Params.Add('Server=127.0.0.1/3050');

  if Master = True then
  begin
    Data.Params.Values['user_name'] := 'sysdba';
    Data.Params.Values['password'] := 'masterkey';
  end
  else
  begin
    Data.Params.Values['user_name'] := 'ginkoia';
    Data.Params.Values['password'] := 'ginkoia';
  end;
  try

    Data.Params.Add('Database=' + BddName);
    Data.Params.Add('Protocol=TCPIP');
    Data.Params.Add('DriverID=IB');
    Data.Open;

    Tran.StartTransaction;
  except
    on E: Exception do
    begin
      Error := E.Message;
    end;
  end;
end;

procedure Tinstall.TBase.ConnectToHost(aHost: string; aBdd: string; Master: boolean);
begin

  Data.Params.Clear();
  Data.DriverName := 'IB';
  Data.Params.Add('Server=' + aHost);

  if Master = True then
  begin
    Data.Params.Values['user_name'] := 'sysdba';
    Data.Params.Values['password'] := 'masterkey';
  end
  else
  begin
    Data.Params.Values['user_name'] := 'ginkoia';
    Data.Params.Values['password'] := 'ginkoia';
  end;
  try

    Data.Params.Add('Database=' + aBdd);
    Data.Params.Add('Protocol=TCPIP');
    Data.Params.Add('DriverID=IB');
    Data.Open;

    Tran.StartTransaction;
  except
    on E: Exception do
    begin
      Error := E.Message;
    end;
  end;
end;

{ ****************************************TMachine*********************************** }
function Tinstall.TMachine.NomDuPoste: string;
var
  pass: array[0..255] of char;
  size: dword;
begin
  size := 250;
  getcomputername(pass, size);
  result := string(pass);
end;

function Tinstall.TMachine.CreateShortcut(Nom: string; Fichier: string; Description: string; Repertoire: string; Icon: string; Index: integer = 0): boolean;
var
  ShellLink: IShellLink;
  registre: Tregistry;
  chem_bureau: string;
begin
  registre := Tregistry.Create(KEY_READ);
  registre.RootKey := HKEY_CURRENT_USER;
  registre.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False);
  chem_bureau := IncludeTrailingBackslash(registre.readString('DeskTop'));
  registre.Free;

  ShellLink := CreateComObject(CLSID_ShellLink) as IShellLink;
  ShellLink.SetDescription(Pchar(Description));
  ShellLink.SetWorkingDirectory(Pchar(Repertoire));
  ShellLink.SetPath(Pchar(Fichier));
  ShellLink.SetShowCmd(SW_SHOW);
  ShellLink.SetIconLocation(Pchar(Icon), Index);
  Result := ((ShellLink as IpersistFile).Save(StringToOleStr(chem_bureau + Nom + '.lnk'), True) = S_OK);
end;

function Tinstall.TMachine.CreateRaccourciAndIniCASH(aGinkoiaPath: string; aType: TTypePoste; aServeurHost: string; aCaisseSecHost: String): Boolean;
var
  AnObj    : IUnknown;
  ShLink   : IShellLink;
  PFile    : IPersistFile;
  LinkName : WideString;
  SFolder  : pItemIDList;
  DeskTop  : array[0..MAX_PATH] of Char;
  Target   : string;
  vCASH, vParam: String;
  sFichierIcone : string;
begin
  Result := False;

  aGinkoiaPath := IncludeTrailingPathDelimiter(aGinkoiaPath);

  // Raccourci de la caisse CASH
  vCASH := IncludeTrailingPathDelimiter(aGinkoiaPath + cDossierCASH) + 'Caisse.exe';
  sFichierIcone := IncludeTrailingPathDelimiter(aGinkoiaPath) + 'Images\ICONE_CAISSE_SECOURS_GINKOIA.ico';
  if FileExists(vCASH) then
  begin
    SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, SFolder);
    SHGetPathFromIDList(SFolder, DeskTop);
    Target := Concat(StrPas(DeskTop), '\');
    AnObj  := CreateComObject(CLSID_ShellLink);
    ShLink := AnObj as IShellLink;
    PFile  := AnObj as IPersistFile;
    ShLink.SetPath(PChar(vCASH));
    ShLink.SetArguments(PChar('/connectTo Connexion'));
    ShLink.SetWorkingDirectory(PChar(ExtractFilePath(vCASH)));
    LinkName := ChangeFileExt('Caisse', '.lnk');
    Result := (PFile.Save(PWChar(Target + LinkName), False) = S_OK);

    if aType = TypeCaisseSec then
    begin
      SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, SFolder);
      SHGetPathFromIDList(SFolder, DeskTop);
      Target := Concat(StrPas(DeskTop), '\');
      AnObj  := CreateComObject(CLSID_ShellLink);
      ShLink := AnObj as IShellLink;
      PFile  := AnObj as IPersistFile;
      ShLink.SetPath(PChar(vCASH));
      ShLink.SetArguments(PChar('/connectTo Connexion_sec'));
      if FileExists(sFichierIcone) then
        ShLink.SetIconLocation(PChar(sFichierIcone), 0);
      ShLink.SetWorkingDirectory(PChar(ExtractFilePath(vCASH)));
      LinkName := ChangeFileExt('CaisseSec', '.lnk');
      Result := (PFile.Save(PWChar(Target + LinkName), False) = S_OK);
    end;
  end;

    // Raccourci du paramétrage
  if (aType = TypeServeur) then
  begin
    vParam := IncludeTrailingPathDelimiter(aGinkoiaPath + cDossierCASH) + cParamCASH;
    if FileExists(vParam) then
    begin
      SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, SFolder);
      SHGetPathFromIDList(SFolder, DeskTop);
      Target := Concat(StrPas(DeskTop), '\');
      AnObj  := CreateComObject(CLSID_ShellLink);
      ShLink := AnObj as IShellLink;
      PFile  := AnObj as IPersistFile;
      ShLink.SetPath(PChar(vParam));
      ShLink.SetWorkingDirectory(PChar(ExtractFilePath(vParam)));
      LinkName := ChangeFileExt('CashSettings', '.lnk');
      Result := (PFile.Save(PWChar(Target + LinkName), False) = S_OK);
    end;
  end;

  // création de l'ini de la caisse
  Result := (Result and BuildIni(aGinkoiaPath, aType, aServeurHost, aCaisseSecHost));
end;

function Tinstall.TMachine.BuildIni(aGinkoiaPath: String; aTypePoste: TTypePoste; aServeurHost, aCaisseSecHost: String) : boolean;
var
  vCASH : string;
  vIni : TIniFile;
begin
  result := false;

  vCASH := IncludeTrailingPathDelimiter(aGinkoiaPath+ cDossierCASH) + 'Caisse.ini';
  vIni := TIniFile.Create(vCASH);
  try
    vIni.WriteString('Connexion', 'Host', aServeurHost);
    vIni.WriteInteger('Connexion', 'Port', 7401 );

    if (aTypePoste = TypeCaisseSec) and (aCaisseSecHost <> '')  then
    begin
      vIni.WriteString('Connexion_sec', 'Host', aCaisseSecHost);
      vIni.WriteInteger('Connexion_sec', 'Port', 7401);
    end
  finally
    freeandnil(vIni);
  end;

  result := True;
end;

{ ****************************************TBaseSender*********************************** }
constructor Tinstall.TBaseSender.Create();
begin
  bas_id := -1;
  bas_nom := '-';
  bas_guid := '';
  bas_dossier := '';
end;

{ ****************************************Tlangue*********************************** }
constructor Tinstall.TLangue.Create();
begin
  ImgIndex := 0;
  Name := 'FRA';
  UpdateRegionals := False;
end;

{ ****************************************Tinstall*********************************** }

constructor Tinstall.Create(sPath: string; sPathBaseDistant: string = '');
var
  FpathOnlyBpl: string;
begin
  FpathOnlyBpl := IncludeTrailingBackslash(sPath);
  Fpath := IncludeTrailingBackslash(sPath);

  // cas ou la base distante n'est pas la base locale (installation d'une caisse par exe)
  if sPathBaseDistant <> '' then
    FdatabasePath := sPathBaseDistant
  else
    FdatabasePath := Fpath + 'Data';

  Log.Log('InstallBase', 'Tinstall.Create', 'FdatabasePath : ' + FdatabasePath, logInfo, True, 0, ltLocal);

  FConnexion := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.ib';
  FBplPath := FpathOnlyBpl + 'BPL';
  BaseSenderSelected := TBaseSender.Create;
  // création de l'objet  base de données
  Database := Tinstall.TBase.Create;
  Language := Tinstall.TLangue.Create;
  Machine := TMachine.Create;
end;

//constructor Tinstall.Create(sPath: string; bMachine: boolean);
//begin
//  Fpath := IncludeTrailingBackslash(sPath);
//  FdatabasePath := Fpath + 'Data';
//  FConnexion := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.ib';
//  FBplPath := Fpath + 'BPL';
//  BaseSenderSelected := TBaseSender.Create;
//
//  // création de l'objet base de données
//  Database := Tinstall.TBase.Create;
//
//  // peu impore la valeur de bBMachine
//  Machine := TMachine.Create;
//  Language := Tinstall.TLangue.Create;
//end;

destructor Tinstall.Destroy();
begin
  FreeAndNil(Database);
  FreeAndNil(BaseSenderSelected);
  FreeAndNil(Language);
end;

destructor Tinstall.Free;
begin
  if Assigned(Recupbase) then
  begin
    Recupbase.Free;
    Recupbase := nil;
  end;
  FreeAndNil(Database);
  Fpath := '';
  FdatabasePath := '';
  if Assigned(Machine) then
    Machine.Destroy;
end;

function Tinstall.OpenServeur(Master: boolean = False): boolean;
begin
  if (FDrive <> '') and (FPathBdd <> '') then
    Database.ConnectToHost(Fserveur, FDrive + ':' + FPathBdd, Master)
  else
    Database.ConnectTo(FConnexion, False);
  // Database.ConnectTo('127.0.0.1/3050:' + FConnexion, False);
end;

function Tinstall.PosteExist(sPoste: string; bSelection: array of string): string;
var
  i: integer;
  Lst: string;
  sBase: string;
begin
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';
  Lst := '';

  // database.ConnectTo('127.0.0.1/3050:' + sBase, false);
  Database.ConnectTo(sBase, False);

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'PosteExist', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'PosteExist', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  result := '';
  try
    // Vérifie si le poste exist pour un magasin donnée
    for i := Low(bSelection) to High(bSelection) do
    begin

      Database.Qry.Close;
      Database.Qry.SQL.Clear;
      with Database.Qry do
      begin
        SQL.Add('SELECT POS_ID ');
        SQL.Add('FROM GENPOSTE ');
        SQL.Add(' JOIN K ON (K_ID = POS_ID AND K_ENABLED = 1) ');
        SQL.Add(' JOIN GENMAGASIN ON (MAG_ID = POS_MAGID) ');
        SQL.Add('WHERE POS_NOM = :POSTE AND MAG_NOM = :MAGASIN');
        // ParamCheck := True;
        ParamByName('POSTE').AsString := sPoste;
        ParamByName('MAGASIN').AsString := bSelection[i];
        Open;

        if RecordCount > 0 then
        begin
          if Lst = '' then
          begin
            Lst := Concat(Lst, bSelection[i]);
          end
          else
          begin
            Lst := Concat(Lst, ' - ' + bSelection[i]);
          end;
        end;
      end;
    end;

  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;

  result := Lst;
end;

function Tinstall.CanInstallCash(): Boolean;
var
  vVersion, sBase: String;
  vVersionNumber: Integer;
  hasModule: Boolean;
begin
  Result := False;
  hasModule := False;
  vVersionNumber := 0;

  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  Database.ConnectTo(sBase, False);

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'CanInstallCash', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'CanInstallCash', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    // On vérifie la version de la base, doit être supérieur ou égale à à 21
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    Database.Qry.SQL.Add('SELECT VER_VERSION');
    Database.Qry.SQL.Add('FROM GENVERSION');
    Database.Qry.SQL.Add('ORDER BY VER_DATE DESC ');
    Database.Qry.SQL.Add('ROWS 1');
    // ParamCheck := True;
    Database.Qry.Open;

    if Database.Qry.RecordCount > 0 then
    begin
      vVersion := Database.Qry.FieldByName('VER_VERSION').AsString;
      //vVersion := '19.248';
      TryStrToInt(vVersion.Substring(0, Pos('.', vVersion)), vVersionNumber);
    end;

    // On vérifie que le module Cash est actif
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    Database.Qry.SQL.Add('SELECT COUNT(*)');
    Database.Qry.SQL.Add('FROM UILGRPGINKOIAMAG');
    Database.Qry.SQL.Add('JOIN K KUGM ON (KUGM.K_ID = UGM_ID AND KUGM.K_ENABLED = 1)');
    Database.Qry.SQL.Add('JOIN UILGRPGINKOIA ON (UGG_ID = UGM_UGGID)');
    Database.Qry.SQL.Add('JOIN K KUGG ON (KUGG.K_ID = UGG_ID AND KUGG.K_ENABLED = 1)');
    Database.Qry.SQL.Add('JOIN GENBASES ON UGM_MAGID = BAS_MAGID');
    Database.Qry.SQL.Add('JOIN K KBAS ON KBAS.K_ID = BAS_ID AND KBAS.K_ENABLED = 1');
    Database.Qry.SQL.Add('JOIN GENPARAMBASE ON BAS_IDENT = PAR_STRING AND PAR_NOM = ''IDGENERATEUR''');
    Database.Qry.SQL.Add('WHERE UGG_ID <> 0 AND UGG_NOM = ''CAISSE CASH''');
    // ParamCheck := True;
    Database.Qry.Open;
    if Database.Qry.Fields[0].AsInteger > 0 then
    begin
      hasModule := True;
    end;


  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;

  result := (hasModule and (vVersionNumber >= 21));
end;

function Tinstall.GetDirServ(magasin: string): string;
var
  sBase: string;
begin
  // function qui a pour but de retourner le chemin de la base de donnée  depuis le GENREPLICATION
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  result := '';

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetDirServ', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetDirServ', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('select rep_placebase ');
      SQL.Add('from genlaunch ');
      SQL.Add(' join k on k_id = lau_id and k_enabled = 1 ');
      SQL.Add(' join genreplication on rep_lauid = lau_id ');
      SQL.Add('  join k on k_id = rep_id and k_enabled = 1 ');
      SQL.Add(' join genbases on bas_id = lau_basid ');
      SQL.Add(' join genmagasin on mag_id = bas_magid ');
      SQL.Add('  join k on k_id = mag_id and k_enabled = 1 ');
      SQL.Add('where mag_nom = :MAGREF ');
      // ParamCheck := True;
      ParamByName('MAGREF').AsString := magasin;
      Open;

      if RecordCount > 0 then
      begin
        result := FieldByName('REP_PLACEBASE').AsString;
      end;
    end;

  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;

end;

function Tinstall.GetFromWebService(PatchWebService, GUID, UserLogged, TypeAction: string; var ResponseWebService: string): boolean;
var
  WebService: TIdHTTP;
  SQL: string;
  Response: string;
begin
  if PatchWebService = '' then
  begin
    ResponseWebService := '0';
    result := True;
    exit;
  end;

  // function used for know if a desk or a till have already been installed
  result := False;
  try
    try
      WebService := TIdHTTP.Create();

      ResponseWebService := WebService.Get(PatchWebService + '/GetSiteInstall?aGUID=' + GUIID);

      if WebService.ResponseCode <> 200 then
      begin
        result := False;
        exit;
      end
      else
      begin
        result := True;
      end;

    finally
      WebService.Destroy;
    end;
  except
    on E: Exception do
    begin
      /// Log.Log(E.Message, logError);
      Log.Log('InstallBase', 'GetFromWebService', 'Erreur : ' + E.Message, logError, True, 0, ltBoth);
    end;
  end;
end;

function Tinstall.GetMagasinSurServeur: boolean;
var
  Tsl: TStringList;
begin
  result := False;
  if not FileExists('\\' + Server + '\' + Fpath + 'magasin.txt') then
    // Disk + '\GINKOIA\magasin.txt'
    exit;
  Tsl := TStringList.Create;
  Tsl.LoadFromFile('\\' + Server + '\' + Fpath + 'magasin.txt');
  MagasinSurServeur := Trim(Tsl.Values['magasin']);
  result := MagasinSurServeur <> '';
  Tsl.Free;
end;

function Tinstall.GetMagasinSurServeurSecours: boolean;
var
  Tsl: TStringList;
begin
  result := False;
  if not FileExists(Fpath + 'magasin.txt') then
    // Disk + '\GINKOIA\magasin.txt'
    exit;
  Tsl := TStringList.Create;
  Tsl.LoadFromFile(Fpath + 'magasin.txt');
  MagasinSurServeur := Trim(Tsl.Values['magasin']);
  result := MagasinSurServeur <> '';
  Tsl.Free;
end;

function Tinstall.GetMagPortable(sMag: string): TStringList;
var
  S: string;
  sBase, sDir: string;
begin
  if sMag = '' then
    exit;

  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  result := TStringList.Create;
  // Pour l'affichage des magasins  pour 'Portable'
  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetMagPortable', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetMagPortable', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT MAG_NOM');
      SQL.Add('FROM GENMAGASIN');
      SQL.Add(' JOIN K ON (K_ID = MAG_ID AND K_ENABLED = 1)');
      SQL.Add(' JOIN GENBASES ON (BAS_MAGID = MAG_ID)');
      SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1)');
      SQL.Add(' JOIN GENPARAM ON (BAS_ID = PRM_INTEGER AND PRM_TYPE = 3 AND PRM_CODE = 110 AND PRM_STRING <> '''')');
      SQL.Add('WHERE MAG_NOM <> :PMAGREF AND BAS_MAGID <> 0');
      // ParamCheck := True;
      ParamByName('PMAGREF').AsString := sMag;
      Open;
      First;
      while not (eof) do
      begin
        result.Add(FieldByName('MAG_NOM').AsString);
        Next;
      end;
    end;

  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

function Tinstall.SetRecupBase(sDestination: string; sSource: string): boolean;
begin
  Recupbase := Tinstall.TRecupbase.Create(sDestination, sSource);
end;

function Tinstall.UpdateLetterDir(GinkoiaDirectory: string): boolean;
var
  SQL: string;
begin
  // Function used for update the right ginkoia install letter's directory
  // Result := False;
  //
  // if PathBase <> '' then
  // database.ConnectTo(PathBase, false);
  //
  // if Database.Data.Connected = False then
  // begin
  // Log.Log('Erreur de connexion à la base didstante : '+PathBase);
  // exit;
  // end;

end;

function Tinstall.GetBasIdFromMagID(aMagID: Integer): Integer;
var
  sBase: string;
begin
  Result := 0;

  // function qui a pour but retourner la liste des bases d'un type, avec leur bas_id
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetBasIdFromMagID', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetBasIdFromMagID', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;

    Database.Qry.SQL.Add('SELECT MAG_BASID FROM GENMAGASIN WHERE MAG_ID = :magid');
    Database.Qry.ParamByName('magid').AsInteger := aMagID;
    Database.Qry.Open;

    if not Database.Qry.IsEmpty then
      Result := Database.Qry.FieldByName('MAG_BASID').AsInteger;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

function Tinstall.GetGENPARAM(aType, aCode: Integer; ATypeParam: TTypeParam): Variant;
var
  sBase: string;
begin

  case ATypeParam of
    PRM_STRING:
      Result := '';
    PRM_INTEGER:
      Result := 0;
  end;

  // function qui a pour but retourner la liste des bases d'un type, avec leur bas_id
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetGENPARAM', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetGENPARAM', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT prm_string, prm_integer FROM GENPARAM');
      SQL.Add('JOIN K ON (k_id = prm_id AND k_enabled = 1)');
      SQL.Add('WHERE prm_type = :prmtype AND prm_code = :prmcode');

      ParamByName('prmtype').AsInteger := aType;
      ParamByName('prmcode').AsInteger := aCode;
      Open;

      if not IsEmpty then
      begin
        case ATypeParam of
          PRM_STRING:
            Result := FieldByName('prm_string').AsString;
          PRM_INTEGER:
            Result := FieldByName('prm_integer').AsInteger;
        end;
      end;
    end;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

procedure Tinstall.SetGENPARAM(aType, aCode, aMaGid, aPosID: Integer; aParam: TGenParam);
var
  sBase: string;
  sqlAdd: string;
  vPRM_ID: Integer;
begin
  vPRM_ID := 0;
  sqlAdd := '';
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'SetGENPARAM', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'SetGENPARAM', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;

    // on récupère l'ID du GENPARAM
    Database.Qry.SQL.Add('SELECT PRM_ID');
    Database.Qry.SQL.Add('FROM GENPARAM');
    Database.Qry.SQL.Add('WHERE prm_type = :prmtype AND prm_code = :prmcode AND prm_magid = :prmmagid AND prm_pos = :prmpos');
    Database.Qry.ParamByName('prmtype').AsInteger := aType;
    Database.Qry.ParamByName('prmcode').AsInteger := aCode;
    Database.Qry.ParamByName('prmmagid').AsInteger := aMaGid;
    Database.Qry.ParamByName('prmpos').AsInteger := aPosID;
    Database.Qry.Open;

    if Database.Qry.RecordCount > 0 then
    begin
      vPRM_ID := Database.Qry.FieldByName('PRM_ID').AsInteger;
    end;

    Database.Qry.Close;
    Database.Qry.SQL.Clear;

    if vPRM_ID = 0 then
      Exit;

    //********************************
    // *** MISE a jour du genparam ***
    //********************************
    if aParam.prm_string <> ''  then
      sqlAdd := 'PRM_STRING = :PMRSTR';

    if aParam.prm_integer <> 0 then
    begin
      if sqlAdd <> '' then
        sqlAdd := sqlAdd + ', ';
      sqlAdd := sqlAdd + 'PRM_INTEGER = :PMRINT';
    end;

    Database.Qry.SQL.Add('UPDATE GENPARAM');
    Database.Qry.SQL.Add('SET');
    Database.Qry.SQL.Add(sqlAdd);
    Database.Qry.SQL.Add('WHERE prm_id = :prmid');
    Database.Qry.ParamByName('prmid').AsInteger := vPRM_ID;

    if aParam.prm_string <> ''  then
      Database.Qry.ParamByName('PMRSTR').AsString := aParam.prm_string;

    if aParam.prm_integer <> 0  then
      Database.Qry.ParamByName('PMRINT').AsInteger := aParam.prm_integer;

    Database.Qry.ExecSQL;

    //********************************
    // ******* MISE a jour du K ******
    //********************************

    Database.Qry.SQL.Clear;
    Database.Qry.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PID, 0);');
    Database.Qry.ParamByName('PID').AsInteger := vPRM_ID;
    Database.Qry.ExecSQL();


    Database.Tran.Commit;
    Database.Tran.StartTransaction;

  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

function Tinstall.UpdatePatchInstall(LetterDir, PathBase, MagNom: string): boolean;
var
  SQL, BASIDENT: string;
  REPID, PRMID: integer;
  REPBASE, REP_PLACEEAI, Tmp: string;
  Alphabet: set of'A'..'Z';
  Letter: char;
begin
  // Update database install path
  result := False;

  Letter := LetterDir[1];
  Alphabet := ['A'..'Z'];

  if not (Letter in Alphabet) then
  begin
    // Log.Log('Lettre d''instalation de ginkoia invalide');
    Log.Log('InstallBase', 'UpdatePatchInstall', 'Lettre d''installation de Ginkoia invalide', logTrace, True, 0, ltBoth);
    exit;
  end;

  if not FileExists(PathBase) then
    exit;

  if PathBase <> '' then
    Database.ConnectTo(PathBase, True);

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'UpdatePatchInstall', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'UpdatePatchInstall', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    try
      Database.Qry.Close;
      Database.Qry.SQL.Clear;

      // looking for the bas_ident
      with Database.Qry do
      begin
        SQL.Add('select Par_String from genparambase where Par_nom=''IDGENERATEUR''');
        Open;

        if FieldByName('Par_String').AsString <> '' then
          BASIDENT := FieldByName('Par_String').AsString
        else
          exit;
      end;

      Database.Qry.Close;
      Database.Qry.SQL.Clear;

      with Database.Qry do
      begin
        SQL.Add('SELECT REP_ID, REP_PLACEBASE, REP_PLACEEAI');
        SQL.Add('FROM GENBASES');
        SQL.Add('JOIN K ON K_ID = BAS_ID AND K_ENABLED = 1');
        SQL.Add('JOIN GENLAUNCH ON LAU_BASID = BAS_ID');
        SQL.Add('JOIN GENREPLICATION ON REP_LAUID = LAU_ID');
        SQL.Add('WHERE BAS_IDENT = :BASIDENT');
        ParamByName('BASIDENT').AsString := BASIDENT;
      end;
      Database.Qry.Open;
      Database.Qry.First;

      if Database.Qry.FieldByName('REP_ID').Asinteger <> 0 then
      begin
        REPID := Database.Qry.FieldByName('REP_ID').Asinteger;
        REPBASE := Database.Qry.FieldByName('REP_PLACEBASE').AsString;
        REP_PLACEEAI := Database.Qry.FieldByName('REP_PLACEEAI').AsString;

        // update letter dir in the current line
        Tmp := RightStr(REPBASE, Length(REPBASE) - 1);
        REPBASE := LetterDir + Tmp;

        Tmp := RightStr(REP_PLACEEAI, Length(REP_PLACEEAI) - 1);
        REP_PLACEEAI := LetterDir + Tmp;

        Database.Qry.Close;
        Database.Qry.SQL.Clear;

        // REP_PLACEBASE
        with Database.Qry do
        begin
          SQL.Add('UPDATE GENREPLICATION SET REP_PLACEBASE = :PLACEBASE, REP_PLACEEAI = :PLACEEAI  WHERE REP_ID = :REPID');
          // ParamCheck := True;
          ParamByName('PLACEBASE').AsString := REPBASE;
          ParamByName('PLACEEAI').AsString := REP_PLACEEAI;
          ParamByName('REPID').Asinteger := REPID;
          ExecSQL;
          // Log.Log('REP_ID : ' + Inttostr(REPID) + ' New path : ' + REPBASE);
          Log.Log('InstallBase', 'UpdatePatchInstall', 'REP_ID : ' + Inttostr(REPID) + ' New path : ' + REPBASE, logTrace, True, 0, ltBoth);
          SQL.Clear;

          SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:ID,0)';
          ParamByName('ID').AsLargeInt := REPID;
          ExecSQL;
        end;

        Database.Tran.Commit;
        Database.Tran.StartTransaction;

        // PRM_INFO
        with Database.Qry do
        begin
          SQL.Clear;
          SQL.Add('SELECT PRM_ID ');
          SQL.Add('FROM GENPARAM');
          SQL.Add(' JOIN K ON K_ID = PRM_ID AND K_ENABLED = 1 ');
          SQL.Add(' JOIN GENBASES ON (BAS_ID = PRM_INTEGER)');
          SQL.Add('  JOIN K ON K_ID = BAS_ID AND K_ENABLED = 1 ');
          SQL.Add('WHERE PRM_TYPE = 3  AND PRM_CODE = 110 AND BAS_IDENT = :BASIDENT');
          ParamByName('BASIDENT').AsString := BASIDENT;
          Open;

          if FieldByName('PRM_ID').Asinteger <> 0 then
          begin
            PRMID := FieldByName('PRM_ID').Asinteger;

            Close;
            SQL.Clear;

            SQL.Add('UPDATE GENPARAM SET PRM_INFO = :LETTER WHERE PRM_ID = :PRMID');
            // ParamCheck := True;
            ParamByName('LETTER').AsString := LetterDir;
            ParamByName('PRMID').Asinteger := PRMID;
            ExecSQL;
            // Log.Log('PRM_ID : ' + Inttostr(PRMID) + ' New path : ' + REPBASE);
            Log.Log('InstallBase', 'UpdatePatchInstall', 'PRM_ID : ' + Inttostr(PRMID) + ' New path : ' + REPBASE, logTrace, True, 0, ltBoth);

            SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:ID,0)';
            ParamByName('ID').AsLargeInt := PRMID;
            ExecSQL;
          end;
        end;
      end;

    finally
      Database.Tran.Commit;
      result := True;
    end;
  except
    on E: Exception do
    begin
      ErrorMsg := E.Message;
      result := False;
    end;
  end;

end;

function Tinstall.Referencement: boolean;
var
  Reg: Tregistry;
begin
  result := True;
  Fbase := IncludeTrailingPathDelimiter(FdatabasePath) + 'GINKOIA.IB';
  if Tfile.Exists(Fbase) = False then
  begin
    Ferrormsg := ERRORNOBASE + #10 + Fbase;
    exit(False);
  end;
  try
    Reg := Tregistry.Create(KEY_ALL_ACCESS);
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if Reg.OpenKey('SOFTWARE\Algol\Ginkoia\', True) then
    begin
      try
        Reg.WriteString('Base0', Fbase);
        result := True;
      except
        on E: Exception do
        begin
          Ferrormsg := E.Message;
          result := False;
        end;
      end;
    end
    else
    begin
      Ferrormsg := ERROROPENKEY;
      result := False;
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
    Reg := nil;
  end;
end;

function Tinstall.SetFromWebService(PatchWebService, GUID, UserLogged, TypeAction: string; var ResponseWebService: string): boolean;
var
  WebService: TIdHTTP;
  SQL: string;
  Response: string;
begin
  // function used for know if a desk or a till have already been installed
  result := False;
  try
    try
      WebService := TIdHTTP.Create();

      ResponseWebService := WebService.Get(PatchWebService + '/SetSiteInstall?aGUID=' + GUIID);

      if WebService.ResponseCode <> 200 then
      begin
        result := False;
        exit;
      end
      else
      begin
        result := True;
      end;

    finally
      WebService.Destroy;
    end;
  except
    on E: Exception do
    begin
      // Log.Log(E.Message, logError);
      Log.Log('InstallBase', 'SetFromWebService', 'Erreur : ' + E.Message, logError, True, 0, ltBoth);
    end;
  end;
end;

function Tinstall.SetPathBPL;
var
  OldPath: string;
begin
  result := True;

  OldPath := GetEnvironmentVariable('PATH');

  if Pos(FBplPath, OldPath) < 1 then
  begin
    OldPath := OldPath + ';' + FBplPath;
    // OldPath := FBplPath + ';' + OldPath;
    result := SetEnvironmentVariable(Pchar('PATH'), Pchar(OldPath));
    SendMessageTimeoutA(HWND_BROADCAST, WM_SETTINGCHANGE, 0, integer(Pchar('Environment')), SMTO_ABORTIFHUNG, 5000, Nil);
  end;

  // Log.Log('SetPathBPL', logInfo);
  Log.Log('InstallBase', 'SetPathBPL', 'SetPathBPL', logInfo, True, 0, ltBoth);

end;

function Tinstall.Connect(IfMaster: boolean): boolean;
begin
  try
    if Database.Data.Connected then
      Database.Data.Close;

    Database.Data.Params.Clear();
    Database.Data.DriverName := 'IB';
    Database.Data.Params.Add('Server=127.0.0.1/3050');

    if IfMaster = True then
    begin
      Database.Data.Params.Values['user_name'] := 'sysdba';
      Database.Data.Params.Values['password'] := 'masterkey';
    end
    else
    begin
      Database.Data.Params.Values['user_name'] := 'ginkoia';
      Database.Data.Params.Values['password'] := 'ginkoia';
    end;

    Database.Data.Params.Add('Database=' + Fbase);
    Database.Data.Params.Add('Protocol=TCPIP');
    Database.Data.Params.Add('DriverID=IB');
    Database.Data.Open;

    result := Database.Data.Connected;
  except
    on E: Exception do
    begin
      ErrorMsg := E.Message;
    end;
  end;
end;

procedure Tinstall.ConnectBestMethode;
begin
  if (Fdrive <> '') and (FPathBdd <> '') and (Fserveur <> '') then
  begin
    Log.Log('InstallBase', 'ConnectBestMethode', 'ConnectToHost = FDrive : ' + Fdrive + ', FPathBdd : ' + FPathBdd + ', Fserveur: ' + Fserveur, logInfo, True, 0, ltLocal);
    Database.ConnectToHost(Fserveur, Fdrive + ':' + FPathBdd, False);
  end
  else if (FConnexion <> '') then
  begin
    Log.Log('InstallBase', 'ConnectBestMethode', ' ConnectTo FConnexion : ' + FConnexion, logInfo, True, 0, ltLocal);    Database.ConnectToHost(Fserveur, FDrive + ':' + FPathBdd, False);
    Database.ConnectTo(FConnexion, False);
  end;
end;

function Tinstall.GetServPrin(aDirServ, aMag: string): string;
var
  SQL, sMag: string;
begin
  // Funtion for getting the main serv
  result := '';
  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetServPrin', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetServPrin', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('select prm_string');
      SQL.Add('from genparam');
      SQL.Add('Join K on (K_ID=PRM_ID and k_enabled=1)');
      SQL.Add('where prm_code=33');
      SQL.Add('and prm_pos=(select Par_String from genparambase where Par_nom=''IDGENERATEUR'')');
    end;
    Database.Qry.Open;
    Database.Qry.First;

    if Database.Qry.FieldByName('prm_string').AsString <> '' then
      result := Database.Qry.FieldByName('prm_string').AsString;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;

end;

procedure Tinstall.GetShop;
var
  SQL, sMag: string;
  sID: Integer;
begin
  Log.Log('InstallBase', 'GetShop', 'Entrée dans GetShop', logInfo, True, 0, ltLocal);

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetShop', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetShop', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  if Assigned(ptAddShop) = False then
    exit;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('Select MAG_NOM, mag_id ');
      SQL.Add('from genmagasin join k on (k_id=mag_id and k_enabled=1) ');
      SQL.Add('where MAG_ID<>0');
    end;
    Database.Qry.Open;
    Database.Qry.First;

    while Database.Qry.eof = False do
    begin
      sMag := Database.Qry.FieldByName('MAG_NOM').AsString;
      sID := Database.Qry.FieldByName('mag_id').AsInteger;

      ptAddShop(sMag, sID);
      Database.Qry.Next;
    end;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

function Tinstall.GetUrlWebService(DirGinkoia: string): boolean;
var
  SQL, idGenerateur: string;
begin
  // function used for have the web service url
  result := False;

  if DirGinkoia <> '' then
    Database.ConnectTo(DirGinkoia, False);

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetUrlWebService', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetUrlWebService', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    try
      Database.Qry.Close;
      Database.Qry.SQL.Clear;
      with Database.Qry do
      begin
        SQL.Add('SELECT PAR_STRING ');
        SQL.Add('FROM GENPARAMBASE ');
        SQL.Add('WHERE PAR_NOM = ''IDGENERATEUR'' ');
        Open;

        if FieldByName('PAR_STRING').AsString <> '' then
          idGenerateur := FieldByName('PAR_STRING').AsString
        else
          exit;

        SQL.Clear;

        // Get the GUID
        SQL.Add('SELECT BAS_GUID ');
        SQL.Add('FROM GENBASES ');
        SQL.Add('WHERE BAS_IDENT = :IDGENERATEUR ');
        ParamByName('IDGENERATEUR').AsString := idGenerateur;
        Open;

        if FieldByName('BAS_GUID').AsString <> '' then
          GUIID := FieldByName('BAS_GUID').AsString
          // GUIID := '{46528D50-E150-4483-819C-611C181097EF}'
        else
          exit;

        SQL.Clear;

        // URL WEBSERVICE
        SQL.Add('SELECT PRM_STRING ');
        SQL.Add('FROM GENPARAM ');
        SQL.Add('WHERE PRM_TYPE = 3 AND PRM_CODE = 121 ');
        Open;

        if isEmpty then
        begin
          result := True; // On ne peut pas valider
          exit;
        end;

        if FieldByName('PRM_STRING').AsString <> '' then
          PathWebService := FieldByName('PRM_STRING').AsString
        else
          exit;

        result := True;

        SQL.Clear;
      end;
    finally
      if Database.Data.Connected then
        Database.Disconnect;
    end;
  except
    on E: Exception do
    begin
      result := False;
      // Log.Log(E.Message, logError, 'Erreur dans la récupération du chemin du Webservice ');
      Log.Log('InstallBase', 'GetUrlWebService', 'Erreur dans la récupération du chemin du Webservice', logError, True, 0, ltBoth);
    end;
  end;

end;

function Tinstall.GetMainShop: string;
var
  S: string;
begin
  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetMainShop', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetMainShop', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    S := 'ALGOL';
    with Database.Qry do
    begin
      SQL.Add('SELECT BAS_MAGID, MAG_NOM FROM GENBASES ');
      SQL.Add('JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
      SQL.Add('JOIN GENMAGASIN ON MAG_ID=BAS_MAGID ');
      SQL.Add('WHERE BAS_NOM=' + QuotedStr(S));
    end;
    Database.Qry.Open;
    Database.Qry.First;
    result := Database.Qry.FieldByName('MAG_NOM').AsString;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

function Tinstall.GetNameServ(magasin: string): string;
var
  sBase: string;
begin
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';
  result := '';

  if magasin = '' then
    exit;
  try
    // database.ConnectTo('127.0.0.1/3050:' + sBase , false);
    Database.ConnectTo(sBase, False);
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    Database.Qry.SQL.Add('SELECT PRM_STRING ');
    Database.Qry.SQL.Add('FROM GENBASES ');
    Database.Qry.SQL.Add(' JOIN GENMAGASIN ON (BAS_MAGID = MAG_ID) ');
    Database.Qry.SQL.Add(' JOIN K ON (K_ID = MAG_ID AND K_ENABLED = 1) ');
    Database.Qry.SQL.Add('  JOIN GENBASES ON (BAS_MAGID = MAG_ID) ');
    Database.Qry.SQL.Add(' JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1) ');
    Database.Qry.SQL.Add(' JOIN GENPARAM ON (BAS_ID = PRM_INTEGER AND PRM_TYPE = 3 AND PRM_CODE = 110) ');
    Database.Qry.SQL.Add('WHERE MAG_NOM = :MAGNOM ');
    // database.qry.ParamCheck := True;
    Database.Qry.ParamByName('MAGNOM').AsString := magasin;
    Database.Qry.Open;

    result := Database.Qry.fields[0].AsString + ':' + IncludeTrailingBackslash(FdatabasePath);
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

procedure Tinstall.GetPoste(sMag: string);
begin
  Log.Log('InstallBase', 'GetPoste', 'Entrée dans GetPoste', logInfo, True, 0, ltLocal);

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetPoste', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetPoste', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  if Assigned(ptAddPoste) = False then
    exit;

  try
    sMag := UpperCase(sMag);
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT POS_NOM, POS_ID');
      SQL.Add('FROM GENMAGASIN JOIN K ON (K_ID= MAG_ID AND K_ENABLED=1)');
      SQL.Add('     JOIN GENPOSTE JOIN k ON (K_ID = POS_ID AND K_ENABLED=1)');
      SQL.Add('     ON (POS_MAGID=MAG_ID)');
      SQL.Add('WHERE POS_ID<>0');
      SQL.Add('  AND UPPER(MAG_NOM)=' + QuotedStr(sMag));
    end;
    Database.Qry.Open;
    Database.Qry.First;
    while Database.Qry.eof = False do
    begin
      ptAddPoste(Database.Qry.FieldByName('POS_NOM').AsString, Database.Qry.FieldByName('POS_ID').AsInteger);
      Database.Qry.Next;
    end;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

procedure Tinstall.GetPosteSecours(sMag: string);
begin
  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetPosteSecours', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetPosteSecours', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  if Assigned(ptAddPoste) = False then
    exit;
  if Assigned(ptAddPosteSecours) = False then
    exit;
  try
    sMag := UpperCase(sMag);
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT POS_NOM, POS_ID');
      SQL.Add('FROM GENMAGASIN JOIN K ON (K_ID= MAG_ID AND K_ENABLED=1)');
      SQL.Add('     JOIN GENPOSTE JOIN k ON (K_ID = POS_ID AND K_ENABLED=1)');
      SQL.Add('     ON (POS_MAGID=MAG_ID)');
      SQL.Add('WHERE POS_ID<>0');
      SQL.Add('  AND UPPER(MAG_NOM)=' + QuotedStr(sMag));
    end;
    Database.Qry.Open;
    Database.Qry.First;
    while Database.Qry.eof = False do
    begin
      ptAddPoste(Database.Qry.FieldByName('POS_NOM').AsString, Database.Qry.FieldByName('POS_ID').AsInteger);
      ptAddPosteSecours(Database.Qry.FieldByName('POS_NOM').AsString, Database.Qry.FieldByName('POS_ID').AsInteger);
      Database.Qry.Next;
    end;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

procedure Tinstall.CreateIniCaisseSecours(LetterDir, LocalServer, ServSecours, magasin, Poste, PosteSecour, DirDistantSec: string; IsServeur: boolean);
var
  TsElementIni: TStringList;
  sBase: string;
  sDir: string;
  sServerName: string;
begin
  // Creating Ini file 'Emergency Checkout'
  TsElementIni := nil;
  try
    try
      if IsServeur then
      begin
        // GINKOIA
        // Log.Log('IsServer', logInfo);
        Log.Log('InstallBase', 'CreateIniCaisseSecours', 'IsServeur', logInfo, True, 0, ltBoth);
        sDir := LetterDir + ':\GINKOIA\';
        ForceDirectories(sDir);
        TsElementIni := TStringList.Create;
        TsElementIni.Add('[GENERAL]');
        TsElementIni.Add('Tip_Main_ShowAtStartup=False');
        // si la langue est différente de français, on ajoute la ligne dans l'ini
        if Language.Name <> 'FRA' then
          TsElementIni.Add('LNG=' + Language.Name);

        // Section chemin bdd
        TsElementIni.Add('[DATABASE]');
        TsElementIni.Add('PATH0=' + ServSecours);
        TsElementIni.Add('PATH1=');

        // Section magasin
        TsElementIni.Add('[NOMMAGS]');
        TsElementIni.Add('MAG0=' + magasin);
        TsElementIni.Add('MAG1=');

        // Section nom poste
        TsElementIni.Add('[NOMPOSTE]');
        TsElementIni.Add('POSTE0=' + Poste);
        TsElementIni.Add('POSTE1=');

        TsElementIni.Add('[NOMBASES]');
        TsElementIni.Add('ITEM0=' + magasin);
        TsElementIni.Add('ITEM1=');

        TsElementIni.SaveToFile(sDir + 'GINKOIA.INI');
        TsElementIni.Clear;
        TsElementIni.Free;

        // CAISSEGINKOIA
        sDir := LetterDir + ':\GINKOIA\';
        ForceDirectories(sDir);
        TsElementIni := TStringList.Create;
        TsElementIni.Add('[GENERAL]');
        TsElementIni.Add('Tip_Main_ShowAtStartup=False');
        // si la langue est différente de français, on ajoute la ligne dans l'ini
        if Language.Name <> 'FRA' then
          TsElementIni.Add('LNG=' + Language.Name);

        // Section chemin bdd
        TsElementIni.Add('[DATABASE]');
        TsElementIni.Add('PATH0=' + ServSecours);
        TsElementIni.Add('PATH1=*');
        TsElementIni.Add('PATH2=' + LocalServer);

        // Section magasin
        TsElementIni.Add('[NOMMAGS]');
        TsElementIni.Add('MAG0=' + magasin);
        TsElementIni.Add('MAG1=');
        TsElementIni.Add('MAG2=' + magasin);

        // Section nom poste
        TsElementIni.Add('[NOMPOSTE]');
        TsElementIni.Add('POSTE0=' + Poste);
        TsElementIni.Add('POSTE1=');
        TsElementIni.Add('POSTE2=' + PosteSecour);

        TsElementIni.Add('[NOMBASES]');
        TsElementIni.Add('ITEM0=' + magasin);
        TsElementIni.Add('ITEM1=******************************');
        TsElementIni.Add('ITEM2=SECOURS ' + magasin);

        TsElementIni.SaveToFile(sDir + 'Caisseginkoia.ini');
        TsElementIni.Clear;
        TsElementIni.Add('magasin=' + magasin);
        TsElementIni.SaveToFile(sDir + 'magasin.txt');
      end
      else
      begin
        // Log.Log('not IsServer', logInfo);
        Log.Log('InstallBase', 'CreateIniCaisseSecours', 'Not IsServer - DirDistantSEc = ' + DirDistantSec, logInfo, True, 0, ltBoth);
        // Log.Log('DirDistantSec = ' + DirDistantSec, logInfo);
        if DirDistantSec = '' then
          exit;

        // GINKOIA
        sDir := LetterDir + ':\GINKOIA\';
        ForceDirectories(sDir);
        TsElementIni := TStringList.Create;
        TsElementIni.Add('[GENERAL]');
        TsElementIni.Add('Tip_Main_ShowAtStartup=False');
        // si la langue est différente de français, on ajoute la ligne dans l'ini
        if Language.Name <> 'FRA' then
          TsElementIni.Add('LNG=' + Language.Name);

        // Section chemin bdd
        TsElementIni.Add('[DATABASE]');
        TsElementIni.Add('PATH0=' + ServSecours);
        TsElementIni.Add('PATH1=');

        // Section magasin
        TsElementIni.Add('[NOMMAGS]');
        TsElementIni.Add('MAG0=' + magasin);
        TsElementIni.Add('MAG1=');

        // Section nom poste
        TsElementIni.Add('[NOMPOSTE]');
        TsElementIni.Add('POSTE0=' + Poste);
        TsElementIni.Add('POSTE1=');

        TsElementIni.Add('[NOMBASES]');
        TsElementIni.Add('ITEM0=' + magasin);
        TsElementIni.Add('ITEM1=');

        TsElementIni.SaveToFile(sDir + 'GINKOIA.INI');
        TsElementIni.Clear;
        TsElementIni.Free;

        // CAISSEGINKOIA
        sDir := LetterDir + ':\GINKOIA\';
        ForceDirectories(sDir);
        TsElementIni := TStringList.Create;
        TsElementIni.Add('[GENERAL]');
        TsElementIni.Add('Tip_Main_ShowAtStartup=False');
        // si la langue est différente de français, on ajoute la ligne dans l'ini
        if Language.Name <> 'FRA' then
          TsElementIni.Add('LNG=' + Language.Name);

        // Section chemin bdd
        TsElementIni.Add('[DATABASE]');
        TsElementIni.Add('PATH0=' + ServSecours);
        TsElementIni.Add('PATH1=*');
        TsElementIni.Add('PATH2=' + DirDistantSec);

        // Section magasin
        TsElementIni.Add('[NOMMAGS]');
        TsElementIni.Add('MAG0=' + magasin);
        TsElementIni.Add('MAG1=');
        TsElementIni.Add('MAG2=' + magasin);

        // Section nom poste
        TsElementIni.Add('[NOMPOSTE]');
        TsElementIni.Add('POSTE0=' + Poste);
        TsElementIni.Add('POSTE1=');
        TsElementIni.Add('POSTE2=' + PosteSecour);

        TsElementIni.Add('[NOMBASES]');
        TsElementIni.Add('ITEM0=' + magasin);
        TsElementIni.Add('ITEM1=******************************');
        TsElementIni.Add('ITEM2=SECOURS ' + magasin);

        TsElementIni.SaveToFile(sDir + 'Caisseginkoia.ini');
        TsElementIni.Clear;
        TsElementIni.Add('magasin=' + magasin);
        TsElementIni.SaveToFile(sDir + 'magasin.txt');
      end;
    except
      on E: Exception do
      begin
        // Log.Log(E.Message, logError, 'Creation du fichier .ini');
        Log.Log('InstallBase', 'CreateIniCaisseSecours', 'Erreur lors de la création du fichier ini : ' + E.Message, logError, True, 0, ltBoth);
      end;
    end;

  finally
    if Assigned(TsElementIni) then
      TsElementIni.Free;
  end;
end;

procedure Tinstall.CreateIniPortable(magasin, Poste, ServNom, letterDirDis: string; bSelection: array of string; LstServAdd: TStringList = nil);
var
  TsElementIni: TStringList;
  S: string;
  sBase: string;
  sDir: string;
  i: integer;
  NomServeur: string;
  MagID: integer;
  sDirServeur: string;
  j, l: integer;
begin
  // Procedure de création de Init pour une base portable
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';
  sDir := IncludeTrailingBackslash(Fpath);
  ForceDirectories(sDir);
  TsElementIni := TStringList.Create;
  TsElementIni.Add('[GENERAL]');
  TsElementIni.Add('Tip_Main_ShowAtStartup=False');
  // si la langue est différente de français, on ajoute la ligne dans l'ini
  if Language.Name <> 'FRA' then
    TsElementIni.Add('LNG=' + Language.Name);

  j := 0;
  // Section chemin bdd
  TsElementIni.Add('[DATABASE]');
  // TsElementIni.Add('PATH0=' + GetDirServ(magasin));
  TsElementIni.Add('PATH' + Inttostr(j) + '=' + StringReplace(ServNom, '\\', '', [rfReplaceAll, rfIgnoreCase]) + ':' + letterDirDis + ':\Ginkoia\Data\Ginkoia.IB');
  TsElementIni.Add('PATH' + Inttostr(j + 1) + '=' + sBase);

  if Assigned(LstServAdd) then
  begin
    j := 2;
    for l := 0 to LstServAdd.Count - 1 do
    begin
      TsElementIni.Add('PATH' + Inttostr(j + l) + '=' + LstServAdd.Strings[l]);
    end;
  end;

  if PathBasetest <> '' then // la base test a été créée
  begin
    S := IncludeTrailingBackslash(PathBasetest) + 'TEST.IB';

    if Assigned(LstServAdd) then
      TsElementIni.Add('PATH' + Inttostr(j + l) + '=' + S)
    else
      TsElementIni.Add('PATH' + Inttostr(j + 2) + '=' + S);

    // TsElementIni.add('PATH'+IntToStr(j+L)+'=' + s);
  end;

  // Section magasin
  j := 0;
  TsElementIni.Add('[NOMMAGS]');
  TsElementIni.Add('MAG' + Inttostr(j) + '=' + magasin);
  TsElementIni.Add('MAG' + Inttostr(j + 1) + '=' + magasin);

  if Assigned(LstServAdd) then
  begin
    j := 2;
    for l := 0 to LstServAdd.Count - 1 do
    begin
      TsElementIni.Add('MAG' + Inttostr(j + l) + '=' + magasin);
    end;
  end;

  if PathBasetest <> '' then // la base test a été créée
  begin
    // connection à la base réel pour récup le magID
    Database.ConnectTo(sBase, False);
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    Database.Qry.SQL.Add('SELECT MAG_ID ');
    Database.Qry.SQL.Add('FROM GENMAGASIN ');
    Database.Qry.SQL.Add(' JOIN K ON (K_ID = MAG_ID AND K_ENABLED = 1) ');
    Database.Qry.SQL.Add('WHERE MAG_NOM = :MAGNOM ');
    Database.Qry.ParamByName('MAGNOM').AsString := magasin;
    Database.Qry.Open;

    if Database.Qry.RecordCount > 0 then
    begin
      MagID := Database.Qry.FieldByName('MAG_ID').Asinteger;

      // connection à la base de test pour récupérer le MAG_NOM
      Database.ConnectTo(IncludeTrailingBackslash(PathBasetest) + 'TEST.IB', False);
      Database.Qry.Close;
      Database.Qry.SQL.Clear;
      Database.Qry.SQL.Add('SELECT MAG_NOM ');
      Database.Qry.SQL.Add('FROM GENMAGASIN ');
      Database.Qry.SQL.Add(' JOIN K ON (K_ID = MAG_ID AND K_ENABLED = 1) ');
      Database.Qry.SQL.Add('WHERE MAG_ID = :MAGID ');
      Database.Qry.ParamByName('MAGID').Asinteger := MagID;
      Database.Qry.Open;

      if Database.Qry.RecordCount > 0 then
        TsElementIni.Add('MAG' + Inttostr(i + 2) + '=' + Database.Qry.FieldByName('MAG_NOM').AsString);
    end;
  end;

  // Section nom poste
  j := 0;
  TsElementIni.Add('[NOMPOSTE]');
  TsElementIni.Add('POSTE' + Inttostr(j) + '=' + Poste);
  TsElementIni.Add('POSTE' + Inttostr(j + 1) + '=' + Poste);

  if Assigned(LstServAdd) then
  begin
    j := 2;
    for l := 0 to LstServAdd.Count - 1 do
    begin
      TsElementIni.Add('POSTE' + Inttostr(j + l) + '=' + Poste)
    end;
  end;

  if PathBasetest <> '' then // la base test a été créée
  begin
    if Assigned(LstServAdd) then
      TsElementIni.Add('POSTE' + Inttostr(j + l) + '=' + Poste)
    else
      TsElementIni.Add('POSTE' + Inttostr(j + 2) + '=' + Poste);

  end;

  j := 0;
  TsElementIni.Add('[NOMBASES]');
  TsElementIni.Add('ITEM' + Inttostr(j) + '=' + 'MAGASIN ' + magasin);
  TsElementIni.Add('ITEM' + Inttostr(j + 1) + '=' + 'BASE PORTABLE ' + magasin);

  if Assigned(LstServAdd) then
  begin
    j := 2;
    for l := 0 to LstServAdd.Count - 1 do
    begin
      TsElementIni.Add('ITEM' + Inttostr(j + l) + '=' + 'MAGASIN ' + magasin);
    end;
  end;

  if PathBasetest <> '' then
  begin
    if Assigned(LstServAdd) then
      TsElementIni.Add('ITEM' + Inttostr(j + l) + '=' + 'Base TEST')
    else
      TsElementIni.Add('ITEM' + Inttostr(j + 2) + '=' + 'Base TEST');

    // TsElementIni.Add('ITEM' +IntToStr(j+L)+'=' +'Base TEST');
  end;

  TsElementIni.SaveToFile(sDir + 'GINKOIA.INI');
  TsElementIni.SaveToFile(sDir + 'Caisseginkoia.ini');
  TsElementIni.Clear;
  TsElementIni.Add('magasin=' + magasin);
  TsElementIni.SaveToFile(sDir + 'magasin.txt');
  TsElementIni.Free;
end;

procedure Tinstall.CreateIniPoste(magasin: string; Poste: string);
var
  Tsl: TStringList;
  S: string;
  Base: string;
begin
  ForceDirectories(Fpath);
  Tsl := TStringList.Create;
  // transformation du chemin de la base
  if Server <> '' then
  begin
    S := Server + ':' + Drive + ':' + StringReplace(PathBdd, 'ginkoia.ib', 'TEST\TEST.IB', [rfReplaceAll, rfIgnoreCase]);
    // modifié par RD
  end
  else
  begin
    S := IncludeTrailingBackslash(FdatabasePath) + '\TEST\TEST.IB'
  end;

  if Server <> '' then
  begin
    Base := Server + ':' + Drive + ':' + StringReplace(PathBdd, 'ginkoia.ib', 'GINKOIA.IB', [rfReplaceAll, rfIgnoreCase]);
    Database.ConnectToHost(Server, Drive + ':' + StringReplace(PathBdd, 'ginkoia.ib', 'GINKOIA.IB', [rfReplaceAll, rfIgnoreCase]), False);
  end
  else
  begin
    Base := IncludeTrailingBackslash(FdatabasePath) + 'GINKOIA.IB';
    Database.ConnectTo(Base, False);
  end;

  Tsl.Add('[GENERAL]');
  Tsl.Add('Tip_Main_ShowAtStartup=False');
  // si la langue est différente de français, on ajoute la ligne dans l'ini
  if Language.Name <> 'FRA' then
    Tsl.Add('LNG=' + Language.Name);
  Tsl.Add('[DATABASE]');
  Tsl.Add('PATH0=' + Base);
  Tsl.Add('PATH1=' + S);
  Tsl.Add('[NOMMAGS]');
  Tsl.Add('MAG0=' + magasin);
  Tsl.Add('MAG1=MAGASIN1');
  Tsl.Add('[NOMPOSTE]');

  Database.Qry.Close;
  Database.Qry.SQL.Clear;
  Database.Qry.SQL.Add('Select POS_NOM, MAG_ENSEIGNE ');
  Database.Qry.SQL.Add('from genmagasin join k on (k_id=mag_id and k_enabled=1)');
  Database.Qry.SQL.Add('     join GenPoste join k on (k_id=POS_id and k_enabled=1)');
  Database.Qry.SQL.Add('     on (POS_MAGID=MAG_ID)');
  Database.Qry.SQL.Add('where POS_ID<>0');
  Database.Qry.SQL.Add('And   MAG_NOM=' + QuotedStr(magasin));
  Database.Qry.SQL.Add('  and POS_NOM=' + QuotedStr(Poste));
  Database.Qry.Open;
  Tsl.Add('POSTE0=' + Database.Qry.fields[0].AsString);
  Tsl.Add('POSTE1=' + Database.Qry.fields[0].AsString);
  Tsl.Add('[NOMBASES]');
  Tsl.Add('ITEM0=' + Database.Qry.fields[1].AsString);
  Database.Qry.Close;
  Database.Data.Close;
  Tsl.Add('ITEM1=Base TEST');
  Tsl.SaveToFile(Fpath + 'GINKOIA.INI');
  Tsl.SaveToFile(Fpath + 'Caisseginkoia.ini');
  Tsl.Free;
end;

procedure Tinstall.CreateIniServeur(magasin: string; Poste: string);
var
  Tsl: TStringList;
  S: string;
  Base: string;
  ou: string;
begin
  Base := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';
  ou := IncludeTrailingBackslash(Fpath);
  ForceDirectories(ou);
  Tsl := TStringList.Create;
  Tsl.Add('[GENERAL]');
  Tsl.Add('Tip_Main_ShowAtStartup=False');
  // si la langue est différente de français, on ajoute la ligne dans l'ini
  if Language.Name <> 'FRA' then
    Tsl.Add('LNG=' + Language.Name);
  Tsl.Add('[DATABASE]');
  Tsl.Add('PATH0=' + Base);
  // s := IncludeTrailingBackslash(ExtractFilePath(base)) + 'TEST.IB';  // mais pourquoi la base test est construite dans data\test ?

  // 28/1/2013 après discssion avec Julien la base test est dans Ginkoia/data/test/
  if PathBasetest <> '' then // la base test a été créée
  begin
    S := IncludeTrailingBackslash(PathBasetest) + 'TEST.IB';
    Tsl.Add('PATH1=' + S);
  end
  else
  begin
    // pas de base test
    Tsl.Add('PATH1=');
  end;
  Tsl.Add('[NOMMAGS]');
  Tsl.Add('MAG0=' + magasin);
  if PathBasetest <> '' then
  begin
    Tsl.Add('MAG1=MAGASIN TEST 1');
  end
  else
  begin
    Tsl.Add('MAG1=');
  end;
  Tsl.Add('[NOMPOSTE]');

  Database.ConnectTo(Base, False);
  Database.Qry.SQL.Clear;
  Database.Qry.SQL.Add('Select POS_NOM, MAG_ENSEIGNE ');
  Database.Qry.SQL.Add('from genmagasin join k on (k_id=mag_id and k_enabled=1)');
  Database.Qry.SQL.Add('     join GenPoste join k on (k_id=POS_id and k_enabled=1)');
  Database.Qry.SQL.Add('     on (POS_MAGID=MAG_ID)');
  Database.Qry.SQL.Add('where POS_ID<>0');
  Database.Qry.SQL.Add('And   MAG_NOM=' + QuotedStr(magasin));
  Database.Qry.SQL.Add('  and POS_NOM=' + QuotedStr(Poste));
  Database.Qry.Open;

  Tsl.Add('POSTE0=' + Poste);
  if PathBasetest <> '' then
  begin
    Tsl.Add('POSTE1=' + Poste);
  end
  else
  begin
    Tsl.Add('POSTE1=');
  end;

  Tsl.Add('[NOMBASES]');
  Tsl.Add('ITEM0=' + Database.Qry.fields[1].AsString);
  Database.Qry.Close;
  Database.Qry.Close;
  if PathBasetest <> '' then
  begin
    Tsl.Add('ITEM1=Base TEST');
  end
  else
  begin
    Tsl.Add('ITEM1=');
  end;
  Tsl.SaveToFile(ou + 'GINKOIA.INI');
  Tsl.SaveToFile(ou + 'Caisseginkoia.ini');
  Tsl.Clear;
  Tsl.Add('magasin=' + magasin);
  Tsl.SaveToFile(ou + 'magasin.txt');
  Tsl.Free;
end;

function Tinstall.DelFilesDir(Directory: string): boolean;
var
  FileOp: TSHFileOpStruct;
begin
  // Del all files in a folder
  FillChar(FileOp, SizeOf(FileOp), 0);
  FileOp.wFunc := FO_DELETE;
  FileOp.pFrom := Pchar(Directory + #0); // double zero-terminated
  FileOp.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
  SHFileOperation(FileOp);
end;

function Tinstall.IsEasy(): boolean;
var
  sBase, sDir: string;
begin
  result := False;

  // function qui a pour but de retourner le chemin de la base de donnée  depuis le GENREPLICATION
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';
  sDir := IncludeTrailingBackslash(Fpath);

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'IsEasy', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'IsEasy', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT * FROM GENPARAM');
      SQL.Add('JOIN K ON K_ID = PRM_ID');
      SQL.Add('WHERE PRM_TYPE = 80 AND PRM_CODE = 1 AND K_ENABLED = 1 AND prm_string <> ''''');
      Open;

      if not eof then
      begin
        result := True;
      end;
    end;

  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;

end;

function Tinstall.DROP_SYMDS(aProgressBar: TProgressBar = Nil): boolean;
var
  sBase: string;
  // sdirectory: string;
  sProgUninstall: string;
  vScript: TFDScript;
  vScriptFile: string;
  // BufferSQL: string;
  // I: integer;
  // chaine: string;
  // vCnx: TFDConnection;
  // vQuery: TFDQuery;
  // vTransaction: TFDTransaction;
  ResInstallateur: TResourceStream;
  TraitementOk: Boolean;
  Cpt: integer;
begin
  result := True;
  TraitementOk := False;
  Cpt := 0;
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  if Assigned(aProgressBar) then
  begin
    aProgressBar.Position := 0;
    aProgressBar.Max := 100;
    aProgressBar.Visible := True;
    Application.ProcessMessages;
  end;

  // on se connecte en sysdba pour pouvoir exécuter le script
  while not (TraitementOk) and (Cpt < 5) do
  begin
//    if Database.Data.Connected then
//      Database.Disconnect;
//    Database.ConnectTo(sBase, True);
    Inc(Cpt);

    try
      try
        // on test si les triggers sont présents avant nettoyage
//        Database.Qry.Close;
//        Database.Qry.SQL.Clear;
//        Database.Qry.SQL.Add('SELECT RDB$TRIGGER_NAME');
//        Database.Qry.SQL.Add('FROM RDB$TRIGGERS');
//        Database.Qry.SQL.Add('WHERE ((RDB$SYSTEM_FLAG = 0) OR (RDB$SYSTEM_FLAG IS NULL))');
//        Database.Qry.SQL.Add('AND lower(RDB$TRIGGER_NAME) LIKE ''sym_%'';');
//        Database.Qry.Open;
//        // triggers trouvés, donc on fait le traitement de nettoyage
//        if not Database.Qry.eof then
//        begin
          // on ouvre une nouvelle connexion / transaction pour éviter les deadlocks
          Database.Disconnect;
          Database.ConnectTo(sBase, True);

          vScriptFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'drop_symds2.sql';
          if FileExists(vScriptFile) then
            deletefile(vScriptFile);

          ResInstallateur := TResourceStream.Create(HInstance, 'drop_symds2', RT_RCDATA);
          try
            ResInstallateur.SaveToFile(vScriptFile);
          finally
            ResInstallateur.Free();
          end;

          vScript := TFDScript.Create(nil);
          try
            vScript.Connection := Database.Data;
            // vScript.Transaction := Database.Tran;

            vScript.SQLScriptFileName := vScriptFile;
            vScript.ScriptOptions.CommandSeparator := '^';
            vScript.ScriptOptions.MacroExpand := False;
            vScript.ScriptOptions.BreakOnError := False;
            vScript.ExecuteAll;

//            if vScript.TotalErrors > 0 then
//            begin
//              Database.Data.Rollback;
//              ErrorMsg := 'nombre d''erreurs : ' + Inttostr(vScript.TotalErrors);
//              result := False;
//            end
//            else
//            begin
//              Database.Data.Commit;
//            end;

            Database.Data.Commit;

            if vScript.TotalErrors <= 0 then
              TraitementOk := True;

          finally

            FreeAndNil(vScript);
          end;

          deletefile(vScriptFile);
//        end
//        else // plus de triggers : ok
//          TraitementOk := True;

        if Assigned(aProgressBar) then
        begin
          aProgressBar.Position := 33;
          Application.ProcessMessages;
        end;

        // on test si il reste des tables de symetricDS avant nettoyage
        Database.Qry.Close;
        Database.Qry.SQL.Clear;
        Database.Qry.SQL.Add('SELECT RDB$RELATION_NAME');
        Database.Qry.SQL.Add('FROM RDB$RELATIONS');
        Database.Qry.SQL.Add('WHERE ((RDB$SYSTEM_FLAG = 0) OR (RDB$SYSTEM_FLAG IS NULL)) AND');
        Database.Qry.SQL.Add('(RDB$VIEW_SOURCE IS NULL)');
        Database.Qry.SQL.Add('AND RDB$RELATION_NAME = ''SYM_DATA'';');
        Database.Qry.Open;
        // tables trouvées, donc on fait le traitement de nettoyage
        if not Database.Qry.eof then
        begin
          Sleep(5000);
          // on supprime les tables restantes qui ne peuvent l'être dans le script car utilisées
          // SYM_DATA
          // on créé une nouvelle connexion sinon la table reste "utilisée"
          Database.Disconnect;
          Database.ConnectTo(sBase, True);
          Database.Qry.Close;
          Database.Qry.SQL.Clear;
          Database.Qry.SQL.Add('DROP TABLE SYM_DATA;');
          Database.Qry.ExecSQL;
          Database.Tran.Commit;

          if Assigned(aProgressBar) then
          begin
            aProgressBar.Position := 66;
            Application.ProcessMessages;
          end;
        end;

        // on test si il reste des tables de symetricDS avant nettoyage
        Database.Qry.Close;
        Database.Qry.SQL.Clear;
        Database.Qry.SQL.Add('SELECT RDB$RELATION_NAME');
        Database.Qry.SQL.Add('FROM RDB$RELATIONS');
        Database.Qry.SQL.Add('WHERE ((RDB$SYSTEM_FLAG = 0) OR (RDB$SYSTEM_FLAG IS NULL)) AND');
        Database.Qry.SQL.Add('(RDB$VIEW_SOURCE IS NULL)');
        Database.Qry.SQL.Add('AND RDB$RELATION_NAME = ''SYM_CONTEXT'';');
        Database.Qry.Open;
        // tables trouvées, donc on fait le traitement de nettoyage
        if not Database.Qry.eof then
        begin
          Sleep(5000);
          // SYM_CONTEXT
          Database.Disconnect;
          Database.ConnectTo(sBase, True);
          Database.Qry.Close;
          Database.Qry.SQL.Clear;
          Database.Qry.SQL.Add('DROP TABLE SYM_CONTEXT;');
          Database.Qry.ExecSQL;
          Database.Tran.Commit;

          if Assigned(aProgressBar) then
          begin
            aProgressBar.Position := 100;
            Application.ProcessMessages;
          end;
        end;

      finally
        if Assigned(aProgressBar) then
        begin
          aProgressBar.Position := 0;
          aProgressBar.Visible := False;
        end;
      end;
    except
      on E: Exception do
      begin
        if Cpt >= 5  then
        begin
          ErrorMsg := 'Impossible de passer le script de suppression des triggers (' + E.Message + ')';
          result := False;
        end;
      end;
    end;
  end;

  if not TraitementOk then
    Result := False;
end;

function Tinstall.GRANT_FOR_EASY(): boolean;
var
  sBase: string;
  // sdirectory: string;
  sProgUninstall: string;
  vScript: TFDScript;
  vScriptFile: string;
begin
  result := False;

  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  // on se connecte en sysdba pour pouvoir exécuter le script
  try
    // on ouvre une nouvelle connexion / transaction pour éviter les deadlocks
    Database.Disconnect;
    Database.ConnectTo(sBase, True);

    vScriptFile := ExtractFilePath(ExtractFilePath(FdatabasePath)) + 'EASY\grants.sql';

    vScript := TFDScript.Create(nil);
    try
      vScript.Connection := Database.Data;
      // vScript.Transaction := Database.Tran;

      vScript.SQLScriptFileName := vScriptFile;
      vScript.ScriptOptions.CommandSeparator := ';';
      vScript.ScriptOptions.MacroExpand := False;
      vScript.ScriptOptions.BreakOnError := False;
      vScript.ExecuteAll;

      if vScript.TotalErrors <= 0 then
      begin
        Result := True;
        Database.Data.Commit;
      end;

    finally
      FreeAndNil(vScript);
    end;
  except
    on E: Exception do
    begin
      ErrorMsg := 'Impossible de passer le script de Grant des droits à Easy (' + E.Message + ')';
      result := False;
    end;
  end;
end;

procedure Tinstall.GetListeBases(aTypePoste: TTypePoste; var ListBases: TObjectList<Tobject>);
var
  sBase, queryLike: string;
  VbaseSender: TBaseSender;
begin

  // recherche en fonction du type de poste
  case aTypePoste of
    TypeServeur:
      queryLike := 'serveur%';
    TypePortable:
      queryLike := '%portable%';
    // queryLike := '%-sec';
    TypeCaisseSec:
      queryLike := '%-sec%';
  end;

  // function qui a pour but retourner la liste des bases d'un type, avec leur bas_id
  sBase := IncludeTrailingBackslash(FdatabasePath) + 'Ginkoia.Ib';

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetListeBases', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetListeBases', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT bas_id, bas_nom, bas_guid, bas_nompournous FROM genbases');
      SQL.Add('JOIN K ON (k_id = bas_id AND k_enabled = 1)');
      SQL.Add('WHERE lower(bas_nom) LIKE ''' + queryLike + '''');

      if aTypePoste = TypePortable then
        SQL.Add('OR lower(bas_nom) LIKE ''%np%''');

      SQL.Add('ORDER BY bas_nom');
      Open;
      First;

      while not eof do
      begin
        VbaseSender := TBaseSender.Create;
        VbaseSender.bas_id := FieldByName('bas_id').Asinteger;
        VbaseSender.bas_nom := FieldByName('bas_nom').AsString;
        VbaseSender.bas_guid := FieldByName('bas_guid').AsString;
        VbaseSender.bas_dossier := FieldByName('bas_nompournous').AsString;
        ListBases.Add(VbaseSender);

        Next;
      end;
    end;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

function Tinstall.PosteInBase(aSender: TBaseSender): boolean;
var
  sBase, queryLike: string;
  VbaseSender: TBaseSender;
begin
  result := False;

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'PosteInBase', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'PosteInBase', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT * FROM genbases');
      SQL.Add('JOIN K ON (k_id = bas_id AND k_enabled = 1)');
      // SQL.Add('WHERE lower(bas_nom) LIKE ''%portable%''');
      SQL.Add('WHERE bas_nom = :POSTENAME AND bas_id = :POSTEID');
      ParamByName('POSTENAME').AsString := aSender.bas_nom;
      ParamByName('POSTEID').Asinteger := aSender.bas_id;
      Open;
      if not eof then
        result := True
      else
        ErrorMsg := 'Impossible de trouver le site de réplication dans la base de données distante';
    end;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

function Tinstall.GetSenderName(aSender: Tobject): string;
begin
  result := TBaseSender(aSender).bas_nom;
end;

function Tinstall.GetSenderID(aSender: Tobject): integer;
begin
  result := TBaseSender(aSender).bas_id;
end;

procedure Tinstall.SetBaseSenderSelected(aSender: Tobject);
begin
  BaseSenderSelected := TBaseSender(aSender);

  // mise à jour des informations de log
  Log.Ref := BaseSenderSelected.bas_guid;
  Log.Doss:= BaseSenderSelected.bas_dossier;
end;

// fonction pour set le base sender à partir de la base connectée plutot qu'en passant un Tobject
function Tinstall.SetBaseSenderFromDatabase(): boolean;
var
  sBase: string;
  VbaseSender: TBaseSender;
begin
  result := False;
  // function qui a pour but retourner la liste des bases d'un type, avec leur bas_id
  sBase := FConnexion;

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'SetBaseSenderFromDatabase', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'SetBaseSenderFromDatabase', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT bas_id, bas_nom, bas_guid, bas_nompournous FROM genbases');
      SQL.Add('JOIN K ON (k_id = bas_id AND k_enabled = 1)');
      SQL.Add('JOIN GENPARAMBASE ON par_string = bas_ident   ');
      SQL.Add('WHERE par_nom = ''IDGENERATEUR''');
      Open;

      if not eof then
      begin
        BaseSenderSelected.bas_id := FieldByName('bas_id').Asinteger;
        BaseSenderSelected.bas_nom := FieldByName('bas_nom').AsString;
        BaseSenderSelected.bas_guid := FieldByName('bas_guid').AsString;
        BaseSenderSelected.bas_dossier := FieldByName('bas_nompournous').AsString;

        // mise à jour des informations de log
        Log.Ref := BaseSenderSelected.bas_guid;
        Log.Doss:= BaseSenderSelected.bas_dossier;

        result := True;
      end;
    end;
  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

procedure Tinstall.SetLanguage();
var
  prm_lang: string;
begin
  prm_lang := 'NTV'; // native (français), valeur par défaut

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'SetLanguage', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'SetLanguage', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
    with Database.Qry do
    begin
      SQL.Add('SELECT prm_string FROM GENPARAM');
      SQL.Add('JOIN K ON (K_ID = PRM_ID and K_ENABLED = 1)');
      SQL.Add('JOIN GENBASES ON bas_magid = prm_magid');
      SQL.Add('JOIN GENPARAMBASE ON bas_ident = par_string');
      SQL.Add('WHERE PAR_NOM = ''IDGENERATEUR'' AND PRM_TYPE = 3 AND PRM_CODE = 148');
      Open;
      First;

      if not eof then
      begin
        prm_lang := FieldByName('prm_string').AsString;
      end;
    end;

    // si on est pas en français, on vérifie que les 2 procédures stockées des langues existent
    if prm_lang <> 'NTV' then
    begin
      Database.Qry.Close;
      Database.Qry.SQL.Clear;
      with Database.Qry do
      begin
        SQL.Add('SELECT COUNT(*) FROM RDB$PROCEDURES');
        SQL.Add('WHERE ((RDB$SYSTEM_FLAG = 0) OR (RDB$SYSTEM_FLAG IS NULL))');
        SQL.Add('AND lower(RDB$PROCEDURE_NAME) IN (''trad_langue_base'', ''trad_traduire'');');
        Open;
        // si on n'a pas trouvé les deux procédures, on repasse en français
        if fields[0].Asinteger <> 2 then
        begin
          // Log.Log('Procédure stockées de langue non trouvées');
          Log.Log('InstallBase', 'SetLanguage', 'Procédure stockées de langue non trouvées', logError, True, 0, ltBoth);
          prm_lang := 'NTV';
        end;
      end;
    end;

    // on ne change les paramètres que si autres que FR car les paramètres sont initialisé comme il faut à la création de l'objet Tlangue
    if prm_lang = 'NLB' then // français
    begin
      Language.ImgIndex := 1;
      Language.Name := 'NLB';
      Language.UpdateRegionals := True;
    end;

  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

function Tinstall.GetModules(): TstringList;
begin
  Result := TStringList.Create;

  if Database.Data.Connected = False then
  begin
    Log.Log('InstallBase', 'GetModules', 'Erreur de connexion à la base : ' + FConnexion + ', tentative de reconnexion', logInfo, True, 0, ltLocal);
    ConnectBestMethode;

    if Database.Data.Connected = False then
    begin
      Log.Log('InstallBase', 'GetModules', 'Impossible de se connecter à la base :' + FConnexion, logInfo, True, 0, ltLocal);
      Exit;
    end;
  end;

  try
    Database.Qry.Close;
    Database.Qry.SQL.Clear;

    Database.Qry.SQL.Add('SELECT DISTINCT UGG_NOM FROM genbases');
    Database.Qry.SQL.Add('JOIN genparambase ON bas_ident = par_string');
    Database.Qry.SQL.Add('JOIN uilgrpginkoiamag ON bas_magid = ugm_magid');
    Database.Qry.SQL.Add('JOIN uilgrpginkoia ON ugm_uggid = ugg_id');
    Database.Qry.SQL.Add('WHERE par_nom = ''IDGENERATEUR''');
    Database.Qry.Open;
    Database.Qry.First;

    while not Database.Qry.eof do
    begin
      Result.Add(Database.Qry.FieldByName('UGG_NOM').AsString);

      Database.Qry.Next;
    end;

  finally
    Database.Qry.Close;
    Database.Qry.SQL.Clear;
  end;
end;

end.

