unit USendFTP;

interface

function DecryptPasswd(Value : string) : string;
function SendFileFTP(FileName : string) : boolean;

implementation

uses
  System.Classes,
  System.SysUtils,
  IdFTP,
  IdFTPCommon,
  IdException,
  ULectureIniFile,
  UResourceString;

function DecryptPasswd(Value : string) : string;
var
  i : integer;
begin
  Result := '';
  for i := (Length(Value) - 1) downto 1 do
    Result := Result + Value[i];
end;

function SendFileFTP(FileName : string) : boolean;
var
  IdFTP : TIdFTP;
  Server, Username, Password, Directory : string;
  Port : integer;
  FileTest : string;
  tmpFile : TStringList;
begin
  Result := false;

  try
    if not FileExists(FileName) then
      EXIT;
    // lecture des info de config
    if not ReadIniFTP(Server, Username, Password, Directory, Port) then
      Raise Exception.Create(rs_ExceptionReadIni);
    // fichier de verif
    FileTest := ChangeFileExt(FileName, '.txt');

    try
      IdFTP := TIdFTP.Create(nil);
      IdFTP.Host := Server;
      IdFTP.Port := Port;
      IdFTP.Username := Username;
      IdFTP.Password := DecryptPasswd(Password);;
      IdFTP.TransferType := ftBinary;

      IdFTP.Connect();
      if IdFTP.Connected then
      begin
        try
          IdFTP.Passive := True;
          if Directory <> '' then
            IdFTP.ChangeDir(Directory);
          IdFTP.Put(FileName);
          // Ajout d'un fichier texte avec juste 1 dedans
          try
            tmpFile := TStringList.Create();
            tmpFile.Text := '1';
            tmpFile.SaveToFile(FileTest);
            IdFTP.Put(FileTest);
            result := true;
          finally
            FreeAndNil(tmpFile);
            System.SysUtils.DeleteFile(FileTest);
          end;
        finally
          try
            IdFTP.Disconnect();
          except
            on e : EIdConnClosedGracefully do
              ;
            on e : Exception do
              Raise;
          end;
        end;
      end;
    finally
      FreeAndNil(IdFTP);
    end;
  except
    on e : Exception do
    begin
      e.Message := 'SendFileFTP : ' + e.Message;
      raise;
    end;
  end;
end;

end.
