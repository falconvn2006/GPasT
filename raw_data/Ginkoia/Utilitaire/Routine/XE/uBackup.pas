unit uBackup;

interface
  uses windows, SysUtils, Classes, IBServices, DbClient, Db, IBDatabase, IBQuery,
       StdCtrls, ComCtrls, Forms, MidasLib, Dialogs, uToolsXE, Shlobj;

const
  CDEFAULTPAGESIZE = 4096;
  CDEFAULTBUFFERS  = 4096;

type
  EGBACKEXCEPTION = class(Exception);

  TBackupCfg = record
    BufferSize : Int64;
    PageSize   : Int64;
  end;


var
  IbBackup : TIBBackupService;
  IbRestore : TIBRestoreService;
  Cds_Backup : TClientDataset;
  Cds_Restore : TClientDataset;

function CalcRestoreMemory(AGBKFile : String) : TBackupCfg;
function CalcBackUpMemory(AIBFile : String) : TBackupCfg;

// Permet de démarrer le backup
function Backup(AIBFile, AGBKFile : string;ALstLogs : TStringList = nil; AClearGarbage : Boolean = False; AServerName : String ='Localhost'; ABufferSize : Int64 = 0;ALogin : String = 'sysdba'; APassword : String = 'masterkey') : Boolean;
// function d'initialisation des CDS
function InitCds(ACds : TClientDataSet) : Boolean;
// fonction de récupération des données d'intégrité de la base
function GetDataDb(AIbFile : String; ACds : TClientDataSet; ALabel : TLabel = nil; AProgressB : TProgressBar = nil) : Boolean;

// Permet de démarrer le restore
function Restore(AIBFile, AGBKFile : string;ALstLogs : TStringList = nil; AServerName : String ='127.0.0.1'; APageSize : Int64 = 0;ABufferSize : Int64 = 0;ALogin : String = 'sysdba'; APassword : String = 'masterkey') : Boolean;
function RestoreGBak(ADirGBak,AIBFile, AGBKFile : string;APageSize : Int64 = 0;ABufferSize : Int64 = 0;ASweep : Int64 = 0;ALstLogs : TStringList = nil; AServerName : String ='127.0.0.1'; ALogin : String = 'sysdba'; APassword : String = 'masterkey') : Boolean;

procedure GetDBVersion(const DatabaseName: String; out Major, Minor, Release, Build: Word);
procedure GetDBVersionMajor(const DatabaseName: String; out Major: Word);
procedure GetDBVersionMinor(const DatabaseName: String; out Minor: Word);
procedure GetDBVersionRelease(const DatabaseName: String; out Release: Word);
procedure GetDBVersionBuild(const DatabaseName: String; out Build: Word);

implementation

Uses BackRest_Frm;

function CalcRestoreMemory(AGBKFile : String) : TBackupCfg;

  {$REGION 'FileSize'}
  function FileSize(const APath: string): int64;
  var
    Sr : TSearchRec;
  begin
    if FindFirst(APath,faAnyFile,Sr)=0 then
    try
      Result := Int64(Sr.FindData.nFileSizeHigh) shl 32 + Sr.FindData.nFileSizeLow;
    finally
      FindClose(Sr);
    end
    else
      Result := 0;
  end;
  {$ENDREGION}

var
  {$IFDEF VER180}
  MemoryStatus : TMemoryStatus;
  {$ELSE}
  MemoryStatus : TMemoryStatusEx;
  {$ENDIF}
  iFileSize : Int64;
  MemText:TStringlist;
begin
  MemText:= TStringlist.create;
  try
  Try
    // récupération de la mémoire installer sur le poste
    if FileExists(ExtractFilePath(ExtractFilepath(AGBKFile)) + 'mem.log') then
       DeleteFile(ExtractFilePath(ExtractFilepath(AGBKFile)) + 'mem.log');

    {$IFDEF VER180}
    GlobalMemoryStatus(MemoryStatus);
    {$ELSE}
      FillChar(MemoryStatus, SizeOf(MemoryStatus), 0);
      MemoryStatus.dwLength := SizeOf(MemoryStatus);
      Win32Check(GlobalMemoryStatusEx(MemoryStatus));
      // GlobalMemoryStatusEx(MemoryStatus);
    {$ENDIF}

    {$IFDEF VER180}
    MemText.Add('dwTotalPhys : ' + UIntToStr(MemoryStatus.dwTotalPhys));
    {$ELSE}
    MemText.Add('ullTotalPhys : ' + UIntToStr(MemoryStatus.ullTotalPhys));
    {$ENDIF}

    // Récupération de la taille du fichier
    iFileSize := FileSize(AGBKFile);
    MemText.Add('iFileSize : ' + UIntToStr(iFileSize));
    MemText.Add('iFileSize div 450000 : ' + UIntToStr(iFileSize div 450000));

    Result.PageSize   := CDEFAULTPAGESIZE;  // C'est toujours 4096 la taille d'une page !
    Result.BufferSize := CDEFAULTBUFFERS;   // Par defaut

    case (iFileSize div 450000) of  // Nous donnera environ la Taille de la base Finale en Mo
      0.. 100    : Result.BufferSize := CDEFAULTBUFFERS;
      101.. 200  : Result.BufferSize :=   8192;
      201.. 400  : Result.BufferSize :=  16384;
      401.. 800  : Result.BufferSize :=  32768;
      801.. 1600 : Result.BufferSize :=  65536;
      1601.. 3200: Result.BufferSize := 131072;
    else Result.BufferSize := 262144;
    end;

    MemText.Add('BufferSize :' + IntToStr(Result.BufferSize));
    {$IFDEF VER180}
    while (MemoryStatus.dwTotalPhys * 10 div 7) < (Result.BufferSize * Result.PageSize) do
    {$ELSE}
    while (MemoryStatus.ullTotalPhys * 10 div 7) < (Result.BufferSize * Result.PageSize) do
    {$ENDIF}
      BEGIN
          Result.BufferSize := Result.BufferSize - 1024;
          // MemText.Add('10 div 7 : ' + UIntToStr(MemoryStatus.ullTotalPhys * 10 div 7));
          // MemText.Add('BufferSize New : ' + UIntToStr(Result.BufferSize));
      END;

    MemText.Add('BufferSize Final :' + IntToStr(Result.BufferSize));
    MemText.SaveToFile(ExtractFilePath(ExtractFilepath(AGBKFile)) + 'mem.log');
  Except on E:exception do
    raise Exception.Create('CalcBackUpMemory -> ' + E.Message);
  End;
  finally
    MemText.Free;
  end;
end;

function CalcBackUpMemory(AIBFile : String) : TBackupCfg;

  {$REGION 'FileSize'}
  function FileSize(const APath: string): int64;
  var
    Sr : TSearchRec;
  begin
    if FindFirst(APath,faAnyFile,Sr)=0 then
    try
      Result := Int64(Sr.FindData.nFileSizeHigh) shl 32 + Sr.FindData.nFileSizeLow;
    finally
      FindClose(Sr);
    end
    else
      Result := 0;
  end;
  {$ENDREGION}

var
  {$IFDEF VER180}
  MemoryStatus : TMemoryStatus;
  {$ELSE}
  MemoryStatus : TMemoryStatusEx;
  {$ENDIF}
  fs : TFileStream;
  iFileSize : Int64;
begin
  Try
    // récupération de la mémoire installer sur le poste
    {$IFDEF VER180}
    GlobalMemoryStatus(MemoryStatus);
    {$ELSE}
    GlobalMemoryStatusEx(MemoryStatus);
    {$ENDIF}

    // Récupération de la taille du fichier
    iFileSize := FileSize(AIBFile);

    case (iFileSize div 1000) of
      1.. 524288: begin
        Result.BufferSize := CDEFAULTBUFFERS;
        Result.PageSize   := CDEFAULTPAGESIZE;
      end;
      524289.. 2097152: begin
        Result.BufferSize := 32768;
        Result.PageSize   := CDEFAULTPAGESIZE;
      end;
      else begin
        Result.BufferSize := 262144;
        Result.PageSize   := CDEFAULTPAGESIZE;
      end;
    end;

    {$IFDEF VER180}
    while (MemoryStatus.dwTotalPhys * 100 div 70) < (Result.BufferSize * Result.PageSize) do
    {$ELSE}
    while (MemoryStatus.ullTotalPhys * 100 div 70) < (Result.BufferSize * Result.PageSize) do
    {$ENDIF}
      Result.BufferSize := Result.BufferSize - 1024;

  Except on E:exception do
    raise Exception.Create('CalcBackUpMemory -> ' + E.Message);
  End;
end;


function Backup(AIBFile, AGBKFile : string;ALstLogs : TStringList = nil; AClearGarbage : Boolean = False; AServerName : String ='Localhost'; ABufferSize : Int64 = 0;ALogin : String = 'sysdba'; APassword : String = 'masterkey') : Boolean;
var
  BackupCfg : TBackupCfg;
  sLigne : String;

begin
  Result := False;
  Try
    if ABufferSize = 0 then
    begin
      BackupCfg := CalcBackUpMemory(AIBFile);
      ABufferSize := BackupCfg.BufferSize;
    end;
    IbBackup := TIBBackupService.Create(nil);
    try
      if FileExists(AGBKFile) then
        DeleteFile(AGBKFile);

      With IbBackup do
      begin

        Active  := False;
        // ServerName := AServerName;
        // Protocol := Local;
        Protocol := TCP;
        ServerName := 'localhost';
        LoginPrompt := False;
        Params.Add('user_name=' + ALogin);
        Params.Add('password=' + APassword);
        BackupFile.Clear;
        BackupFile.Add(AGBKFile);
        DatabaseName := AIBFile;
        BufferSize := CDEFAULTBUFFERS;
        Verbose    := True;

        if AClearGarbage then
          Options := Options + [NoGarbageCollection];
        Active := True;

        ServiceStart;

        while IsServiceRunning do
        begin
          sLigne := GetNextLine;
          if ALstLogs <> nil then
            ALstLogs.Add(sLigne);
          if Pos('gbak: ERROR',sLigne) > 0 then
            raise EGBACKEXCEPTION.Create('Erreur lors du Backup' + sLigne);
          Application.ProcessMessages;
        end;
      end;
      Result := True;
    finally
      FreeAndNil(IbBackup);
    end;
  Except on E:exception do
    raise Exception.Create('Backup -> ' + E.Message);
  End;
end;

function InitCds(ACds : TClientDataSet) : Boolean;
begin
  Result := False;
  With ACds do
  begin
    FieldDefs.Add('Type',ftInteger);
    FieldDefs.Add('Name',ftString,64);
    FieldDefs.Add('Nb',ftInteger);
    CreateDataSet;
  end;
  Result := True;
end;

function GetDataDb(AIbFile : String; ACds : TClientDataSet; ALabel : TLabel = nil; AProgressB : TProgressBar = nil) : Boolean;

  procedure LabelCaption(AText : string);
  begin
    if Assigned(ALabel) then
    begin
      ALabel.Caption := AText;
      Application.processMessages;
    end;
  end;

  procedure PbPosition(APosition : Integer);
  begin
    if Assigned(AProgressB) then
    begin
      AProgressB.Position := APosition;
      Application.processMessages;
    end;
  end;
var
  IbConnect : TIBDatabase;
  TransSac : TIBTransaction;
  QueTmp : TIBQuery;
  MajorVersion: Word;
begin
  Try
    IbConnect := TIBDatabase.Create(nil);
    TransSac := TIBTransaction.Create(IbConnect);
    // connexion à la base de données
    try
      IbConnect.DefaultTransaction := TransSac;
      IbConnect.DatabaseName := AIbFile;
      IbConnect.LoginPrompt := False;
      IbConnect.Params.Add('user_name=sysdba');
      IbConnect.Params.Add('password=masterkey');
      LabelCaption('Connexion à la base de données');
      IbConnect.Connected := true;

      GetDBVersionMajor( AIbFile, MajorVersion );

      QueTmp := TIBQuery.Create(IbConnect);
      With QueTmp do
      Try
        // récupération de la liste des tables
        Database := IbConnect;
        Close;
        SQL.Clear;
        SQL.Add('select RDB$RELATION_NAME nom');
        SQL.Add('from RDB$RELATIONS');
        SQL.Add('where RDB$FLAGS = 1'); // 1 = persistent & no system
        if MajorVersion > 13 then
          SQL.Add('and RDB$RELATION_NAME <> ''TMPBACKUPRESTORE''')
        else
          SQL.Add('and RDB$RELATION_NAME <> ''TMPSTAT''');
        SQL.Add('order by 1');
        {$REGION 'Ancienne requête de récupération des tables'}(*
        SQL.Add('Select distinct rdb$Relation_Name nom');
        SQL.Add('from   rdb$relation_fields');
        SQL.Add('where Not rdb$field_Name like ''RDB$%''');
        SQL.Add(' and rdb$Relation_Name<>''TMPSTAT''');
        SQL.Add('  and rdb$system_flag=0');
        SQL.Add('order by rdb$Relation_Name');*)
        {$ENDREGION}
        Open;
        while not EOF do
        begin

          ACds.Append;
          ACds.FieldByName('Type').AsInteger := 1; // Table
          ACds.FieldByName('Name').AsString := FieldbyName('nom').AsString;
          ACds.FieldByName('Nb').AsInteger := 0;
          Acds.Post;

          Next;
        end;

        // Récupération du nombre d'enregisterment par table;
        Acds.First;
        while not ACds.Eof do
        begin
          LabelCaption('Traitement de la table : ' + ACds.FieldbyName('Name').AsString);

          Close;
          SQL.Clear;
          SQL.Add('Select count(*) as Nb from ' + ACds.FieldByName('Name').AsString);
          Open;
          ACds.Edit;
          ACds.FieldByName('Nb').AsInteger := FieldByName('Nb').AsInteger;
          ACds.Post;

          ACds.Next;
          PbPosition(ACds.RecNo * 100 Div ACds.RecordCount);
        end;

        // Récupération de la liste des procédure stockées
        Close;
        SQL.Clear;
        SQL.Add('Select Distinct RDB$PROCEDURE_NAME Nom from RDB$PROCEDURES');
        Open;

        while not EOF do
        begin
          LabelCaption('Traitement de la procédure stockée : ' + FieldbyName('nom').AsString);

          ACds.Append;
          ACds.FieldByName('Type').AsInteger := 2; // Procédure stockée
          ACds.FieldByName('Name').AsString := FieldByName('Nom').AsString;
          ACds.FieldByName('Nb').AsInteger := 0;
          ACds.Post;

          Next;
          PbPosition(RecNo * 100 Div RecordCount);
        end;
      finally
        FreeAndNil(QueTmp);
      End;
    finally
      FreeAndNil(TransSac);
      FreeAndNil(IbConnect);
    end;
  Except on E:Exception do
    raise Exception.Create('CheckDataDb -> ' + E.Message);
  End;
end;

function Restore(AIBFile, AGBKFile : string;ALstLogs : TStringList = nil; AServerName : String ='127.0.0.1'; APageSize : Int64 = 0;ABufferSize : Int64 = 0;ALogin : String = 'sysdba'; APassword : String = 'masterkey') : Boolean;
var
  BackupCfg : TBackupCfg;
  sLigne : String;

begin
  Result := False;
  IbRestore := TIBRestoreService.Create(nil);
  Try
    Try
      if (ABufferSize = 0) or (APageSize = 0) then
      begin
        BackupCfg := CalcBackUpMemory(AIBFile);
        ABufferSize := BackupCfg.BufferSize;
        APageSize := BackupCfg.PageSize;
      end;

      With IbRestore do
      begin
        Active  := False;
        ServerName := AServerName;
        Protocol := Local;
        LoginPrompt := False;
        Params.Add('user_name=' + ALogin);
        Params.Add('password=' + APassword);
        BackupFile.Text := AGBKFile;
        DatabaseName.Text := AIBFile;
        BufferSize := ABufferSize;
        PageBuffers := APageSize;
        Verbose    := True;
        try
          Active := True;
        except on e:Exception do
          raise Exception.Create(Format(' -> Active'#13#10'Server %s'#13#10'GBK : %s'#13#10'IB : %s'#13#10'Login %s'#13#10'Password %s'#13#10'Error %s',[AServerName,AGBKFile,AIBFile,ALogin,APassword,E.Message]));
        end;

        try
          ServiceStart;
        Except on e:Exception do
          raise Exception.Create(' ServiceStart ' + E.Message);
        end;

        while not Eof do
        begin
          sLigne := GetNextLine;
          if ALstLogs <> nil then
            ALstLogs.Add(sLigne);
          if Pos('gbak: ERROR',sLigne) > 0 then
            raise EGBACKEXCEPTION.Create('Erreur lors du restore' + sLigne);
          Application.ProcessMessages;
        end;
      end;
      Result := True;
    Except on E:exception do
      raise Exception.Create('Restore -> ' + E.Message);
    End;
  Finally
    FreeAndNil(IbRestore);
  End;
end;


function RestoreGBak(ADirGBak, AIBFile, AGBKFile : string;APageSize : Int64 = 0;ABufferSize : Int64 = 0;ASweep : Int64 = 0;ALstLogs : TStringList = nil; AServerName : String ='127.0.0.1'; ALogin : String = 'sysdba'; APassword : String = 'masterkey') : Boolean;
var
  BackupCfg : TBackupCfg;
  iResult : Integer;
  bFreeLst : Boolean;
  i : int64;
  sCommande, sParam : String;
  sPathIB, sFileIB, sPathGBK, sFileGBK : String;
  MyText: TStringlist;
begin
  Result := False;
  MyText:= TStringlist.create;
  try
    Try
      if FileExists(ExtractFilePath(ExtractFilepath(AGBKFile)) + 'gbakgfix.log') then
         DeleteFile(ExtractFilePath(ExtractFilepath(AGBKFile)) + 'gbakgfix.log');

      if (ABufferSize = 0) or (APageSize = 0) then
      begin
        BackupCfg := CalcRestoreMemory(AGBKFile);
        ABufferSize := BackupCfg.BufferSize;
        APageSize := BackupCfg.PageSize;
      end;

      if ABufferSize = 0 then
        ABufferSize := CDEFAULTBUFFERS;
      if APageSize = 0 then
        APageSize   := CDEFAULTPAGESIZE;

      sPathIB := ExtractFilePath(ExtractFilePath(AIBFile));
      sFileIB := sPathIB + ExtractFileName(AIBFile);

      sPathGBK := ExtractFilePath(ExtractFilePath(AGBKFile));
      sFileGBK := sPathGBK + ExtractFileName(AGBKFile);

      if FileExists(ExtractFilePath(ExtractFilepath(AGBKFile)) + 'RestoreLogs.txt') then
        DeleteFile(ExtractFilePath(ExtractFilepath(AGBKFile)) + 'RestoreLogs.txt');

      // Spaces in Program Path + parameters with spaces:
      // CMD /c ""c:\batch files\demo.cmd" "Parameter 1 with space" "Parameter2 with space""

      sCommande := SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe';
      sParam := Format(' /c ""%sgbak.exe" -o -se localhost:service_mgr "%s" "%s" -user sysdba -password masterkey -C -G',[IncludeTrailingPathDelimiter(ExtractFilePath(ADirGBak)),sFileGBK,sFileIB]);

      if ABufferSize <> -1 then
        sParam := sParam + Format(' -BU %d',[ABufferSize]);
      if APageSize <> -1 then
        sParam := sParam + format(' -P %d',[APageSize]);
      sParam := sParam + Format(' -V -Y "%sRestoreLogs.txt""',[ExtractFilePath(ExtractFilepath(AGBKFile))]);

      MyText.Add('gbak : '+sParam);
      MyText.SaveToFile(Format('%sgbakgfix.log',[ExtractFilePath(ExtractFilepath(AGBKFile))]));

      iResult := ExecuteAndWait(sCommande,sParam);
      if (iResult = 0) and FileExists(ExtractFilepath(AGBKFile) + 'RestoreLogs.txt') then
      begin
        bFreeLst := not Assigned(ALstLogs);
        if bFreeLst then
          ALstLogs := TStringList.Create;
        try
          ALstLogs.LoadFromFile(ExtractFilepath(AGBKFile) + 'RestoreLogs.txt');
          if ALstLogs.Count > 0 then
          begin
            Result := True;
            i := 0;
            while (i <= ALstLogs.Count -1) and Result do
            begin
              if Pos('GBAK: ERROR', Uppercase(ALstLogs[i]))>0 then
                Result := False;
              inc(i);
            end;
          end;

          // Gfix pour mettre le Sweep à 0
          // et le async (non supporté en IB7 dans le gbak, transfert ici)
          if Result then
          begin
            if ASweep <> -1
              then sParam := Format(' /c "%sgfix.exe" -w async -h %d %s -user sysdba -password masterkey',[IncludeTrailingPathDelimiter(ExtractFilePath(ADirGBak)),ASweep,sFileIB])
              else sParam := Format(' /c "%sgfix.exe" -w async %s -user sysdba -password masterkey',[IncludeTrailingPathDelimiter(ExtractFilePath(ADirGBak)),sFileIB]);

            MyText.Add('gfix : '+sParam);
            MyText.SaveToFile(Format('%sgbakgfix.log',[ExtractFilePath(ExtractFilepath(AGBKFile))]));

            iResult := ExecuteAndWait(sCommande,sParam);
          end;
        finally
          if bFreeLst then
            ALstLogs.Free;
        end;
      end;
    Except on E:Exception do
        raise Exception.Create('RestoreGBak -> ' + E.Message + #13#10 + sCommande + sParam);
    End;
  finally
     MyText.Free
  end;
end;

procedure GetDBVersion(const DatabaseName: String; out Major, Minor, Release, Build: Word);
var
  IBDatabase : TIBDatabase;
  IBTransaction : TIBTransaction;
  IBQuery : TIBQuery;
  i, dot: Integer;
  version: String;
begin
  try
    try
      IBDatabase := TIBDatabase.Create( nil );
      IBTransaction := TIBTransaction.Create( IBDatabase );

      IBDatabase.DefaultTransaction := IBTransaction;
      IBDatabase.DatabaseName := DatabaseName;
      IBDatabase.LoginPrompt := False;
      IBDatabase.Params.Add('user_name=sysdba');
      IBDatabase.Params.Add('password=masterkey');
      IBDatabase.Open;
      
      IBQuery := TIBQuery.Create( IBDatabase );
      try
        IBQuery.Database := IBDatabase;
        IBQuery.SQL.Add( 'select VER_VERSION,' );
        IBQuery.SQL.Add( '( select count(*) from GENVERSION where VER_VERSION = core.VER_VERSION and VER_VERSION like ''%_.%_.%_.%_'' ),' );
        IBQuery.SQL.Add( '( select f_stringlength( VER_VERSION ) - f_stringlength( f_stripstring( lower( VER_VERSION ), ''abcdefghijklmnopqrstuvwxyz'' ) ) from GENVERSION where VER_VERSION = core.VER_VERSION )' );
        IBQuery.SQL.Add( 'from GENVERSION core order by VER_DATE desc rows 1' );

        IBQuery.Open;

        if IBQuery.IsEmpty then
          raise Exception.Create( 'Empty table' );

        version := IBQuery.Fields[ 0 ].AsString;

        if ( IBQuery.Fields[ 1 ].AsInteger(* mask validation *) = 0 ) then
          raise Exception.CreateFmt( '"%s" -> Bad mask', [ version ] );
        if ( IBQuery.Fields[ 2 ].AsInteger(* char validation *) > 0 ) then
          raise Exception.CreateFmt( '"%s" -> Forbidden character detected', [ version ] );

        {$REGION 'Parsing du VER_VERSION courant'}
        dot := 0;
        for i := 1 to 4 do begin
          dot := Pos( '.', version );
          case i of
            1: Major   := StrToIntDef( Copy( version, 1, dot - 1 ), 0 );
            2: Minor   := StrToIntDef( Copy( version, 1, dot - 1 ), 0 );
            3: Release := StrToIntDef( Copy( version, 1, dot - 1 ), 0 );
            4: Build   := StrToIntDef( version, 0 );
          end;
          Delete( version, 1, dot );
        end;
        {$ENDREGION}
      finally
        IBQuery.Free;
      end;
    finally
      IBTransaction.Free;
      IBDatabase.Free;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt( 'GetDBVersion(%s): %s', [ DatabaseName, E.Message ] );
  end;
end;

procedure GetDBVersionMajor(const DatabaseName: String; out Major: Word);
var
  Minor, Release, Build: Word;
begin
  GetDBVersion( DatabaseName, Major, Minor, Release, Build );
end;

procedure GetDBVersionMinor(const DatabaseName: String; out Minor: Word);
var
  Major, Release, Build: Word;
begin
  GetDBVersion( DatabaseName, Major, Minor, Release, Build );
end;

procedure GetDBVersionRelease(const DatabaseName: String; out Release: Word);
var
  Major, Minor, Build: Word;
begin
  GetDBVersion( DatabaseName, Major, Minor, Release, Build );
end;

procedure GetDBVersionBuild(const DatabaseName: String; out Build: Word);
var
  Major, Minor, Release: Word;
begin
  GetDBVersion( DatabaseName, Major, Minor, Release, Build );
end;

initialization
  Cds_Backup := TClientDataSet.Create(nil);
  InitCds(Cds_Backup);
  Cds_Restore := TClientDataSet.Create(nil);
  InitCds(Cds_Restore);
finalization
  FreeAndNil(Cds_Backup);
  FreeAndNil(Cds_Restore);
end.
