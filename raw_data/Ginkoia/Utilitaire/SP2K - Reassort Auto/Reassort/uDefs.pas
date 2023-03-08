unit uDefs;

interface
uses Windows, Messages,SysUtils,Forms,Classes, DateUtils;

type
  TMode = (mStock,mVente);

//  TIniStruct = record
//    IsDevMode : Boolean;  //Mode : PRD = False et DEV = True
//
//    //Dev
//    ServerDev : String;   //Nom du serveur
//    LoginDev : String;    //Login SQL
//    PasswordDev : String; //Mot de passe
//    CatalogDev : String;  //Nom de la base de données
//
//    //Prd
//    ServerPrd : String;
//    LoginPrd : String;
//    PasswordPrd : String;
//    CatalogPrd : String;
//
//    Client : Integer;     //Client : 0 = Code par défault (Paramètre inéxistant)
//                          //         1 = Code pour Sport2000
//                          //         2 = Code pour Intersport
//
//    FTP : record
//      Host :String;
//      Port : Integer;
//      UserName : String;
//      PassWord : String;
//    end;
//  end;

  TKVersion = Record
    iKVERSION_TCK    : Integer;
    iKVERSION_NEGBL  : Integer;
    iKVERSION_NEGFCT : Integer;
    K_DATE           : TDateTime;
  End;


const
  CPASSWORD = 'ch@mon1x';

  CVERSION = '2.1';

  CETATOK = 1;
  CETATKO = 0;

  CTYPESTK = 1;
  CTYPEVTE = 2;

  CTBCODETCK = -11111423;
  CTBCODEBL  = -11111425;
  CTBCODEFCT = -11111429;

  CDIRPATH = 'DirPath.txt';
var
  GAPPPATH : String;
  GDIRTOSEND : String;
  GDIRARCHIV : String;
  GDIRFILES  : String;
  GDIRLOGS  : String;
  GFILELOG  : String;

//  IniStruct : TIniStruct;

  function DoDir (sDirName : String) : Boolean;
  procedure Wait(iSecond : Integer);

  // Permet de vérifier si au moins une des données dans la liste est présent dans le chemin
  function IsPathInList(ADirectory : String;ALst : TStrings) : Boolean;

  function AppVersion: String; inline;

implementation

function AppVersion: String;
const
  cFormat = '%d.%d.%d.%d';
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Exe := ParamStr( 0 );
  Size := GetFileVersionInfoSize( PChar( Exe ), Handle );
  if Size = 0 then
    RaiseLastOSError;
  SetLength( Buffer, Size );
  if not GetFileVersionInfo( PChar( Exe ), Handle, Size, Buffer ) then
    RaiseLastOSError;
  if not VerQueryValue( Buffer, '\', Pointer( FixedPtr ), Size ) then
    RaiseLastOSError;
  Result := Format(
    cFormat, [
      LongRec(FixedPtr.dwFileVersionMS).Hi,  //major
      LongRec(FixedPtr.dwFileVersionMS).Lo,  //minor
      LongRec(FixedPtr.dwFileVersionLS).Hi,  //release
      LongRec(FixedPtr.dwFileVersionLS).Lo   //build
    ]
  );
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

procedure Wait(iSecond : Integer);
var
  dDebut, dEncours : TDateTime;
begin
  dDebut := Now;
  dEncours := Now;

  while SecondsBetween(dDebut,dEncours) < iSecond do
  begin
    dEncours := Now;
    Application.ProcessMessages;
  end;
end;

function IsPathInList(ADirectory : String;ALst : TStrings) : Boolean;
var
  i: Integer;
begin
  Result := False;
  if not Assigned(ALst) then
    Exit;

  for i := 0 to ALst.Count -1 do
    if Trim(Alst[i]) <> '' then
      if Pos(UpperCase(Alst[i]),Uppercase(ADirectory)) > 0 then
      begin
        Result := true;
        Exit;
      end;
end;



end.
