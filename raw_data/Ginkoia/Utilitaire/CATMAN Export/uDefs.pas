unit uDefs;

interface

uses Windows, Messages, SysUtils,Classes,dxmdaset, StrUtils, ADODB, Contnrs, IdFTP, IdComponent;

const
  CTYPESTOCK = 1;
  CTYPEVENTE = 2;
  CTYPECMD   = 3;
  CETATOK    = 1;
  CETATKO    = 0;

  MODESTOCK = 1;
  MODEVENTE = 2;
  MODECMD   = 3;

  CVERSION = '1.09 Avec Limitation CDE/mail sur champ MAG_CMDLEVIS';

type
  TKVersion = record
    IdKvTicket ,
    IdKvBL     ,
    IdKvFact   : Integer;
  end;

  TTVALignes = array of record
    CDE_TVAHT   ,
    CDE_TVATAUX ,
    CDE_TVA     : currency;
  end;

  TCFG = record
    Debug : Boolean;
    DebugMagCode : String;
    DebugMagID   : Integer;
    DebugKIdCDE  : Integer;
    EMail : Record
      ExpMail  ,
      Password ,
      AdrSMTP  : String;
      Port : Integer;
    end;
    FTP : Record
      Host     ,
      UserName ,
      Password : String;
      Dir      : String;
    End;
    MntMiniCde : Double;
  end;

  var
  GAPPPATH  : String;
  GPATHQRY  : String;
  GPATHSAVE : String;
  GPATHIMG  : String;
  GBASEPATHDEBUG : String;
  GPATHARCHIV : String;
  MainCFG   : TCFG;

  function CryptPW(sPW : String) : String;
  function DeCryptPW(sPW : String) : String;

  function SendFileToFTP(sFileName : String) : Boolean;
  function ArchiveFile(sFileName : String) : Boolean;

implementation

function CryptPW(sPW : String) : String;
var
  i : Integer;
begin
  Result := '';
  if Trim(sPW) <> '' then
    for i := 1 to Length(sPW) do
      Result := Result + IntToHex(Ord(sPW[i]),2);
end;

function DeCryptPW(sPW : String) : String;
var
  i : integer;
begin
  Result := '';
  if Trim(sPW) <> '' then
  begin

    i := 1;
    while i < Length(sPW) do
    begin
      Result := Result + Chr(StrToInt('$' + Copy(sPW,i,2)));
      inc(i,2);
    end;
  end;
end;

function SendFileToFTP(sFileName : String) : Boolean;
var
  lst : TStringList;
  i : integer;
begin
  Result := False;

//  if MainCFG.Debug then
//    Exit;

  if Trim(MainCFG.FTP.Host) = '' then
    raise Exception.Create('Send FTP -> Configuration incorrecte');

  With TIdFTP.Create(nil) do
  try
    Username := MainCFG.FTP.UserName;
    Password := MainCFG.FTP.Password;
    Host     := MainCFG.FTP.Host;
    Passive  := True;

//    TransferTimeout := 5000;

    try
      Connect;

      if Trim(MainCFG.FTP.Dir) <> '' then
      begin
        lst := TStringList.Create;

        try
          lst.Text := StringReplace(MainCFG.FTP.Dir,'/',#13#10,[rfReplaceAll]);
          for i := 0 to Lst.Count - 1 do
          begin
            if Trim(lst[i]) <> '' then
              ChangeDir(Trim(lst[i]));
              Sleep(50);
          end;
        finally
          lst.free;
        end;
      end;

      // Si le fichier existe deja on le supprime
      if Size(ExtractFileName(sFileName)) <> -1 then
        Delete(ExtractFileName(sFileName));

      Put(sFileName, ExtractFileName(sFileName));

      Result := True;
    Except on E:Exception do
      raise Exception.create('Send FTP -> ' + E.Message);
    end;
  finally
    Disconnect;
    Free;
  end;
end;

function ArchiveFile(sFileName : String) : Boolean;
begin
  Try
    Result := CopyFile(PChar(sFileName),PChar(GPATHARCHIV + ExtractFileName(sFileName)),False);
    if Result then
      Result := DeleteFile(sFileName);
  Except on E:Exception do
    raise Exception.Create('ArchiveFile -> ' + E.Message);
  End;
end;

end.
