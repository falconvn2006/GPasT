unit UIBUtilsThread;

interface

uses
  System.Classes,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  UBaseThread,
  uCreateProcess,
  System.IOUtils,
  ServiceControler,
  FireDAC.Phys.IBWrapper,
  UCommun,
  System.RegularExpressionsCore;


const
  CST_PAGE_BUFFER_LAME = 4096;
  CST_PAGE_BUFFER_MAGASIN = 131072;

type
  T7zFile = record
    FileName : string;
    CreateDateTime : TDateTime;
  end;
  T7zFiles = array of T7zFile;

  TGFixThread = class(TBaseIBThread)
  protected
    FPageBuffers : cardinal;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; PageBuffers : cardinal; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TShutdownThread = class(TBaseIBThread)
  protected
    procedure Execute(); override;
  public
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TRestartThread = class(TBaseIBThread)
  protected
    procedure Execute(); override;
  public
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TStatisticsThread = class(TBaseIBThread)
  protected
    procedure Execute(); override;
  public
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TRecompileThread = class(TBaseIBThread)
  protected
    procedure Execute(); override;
  public
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TBaseBackRestThread = class(TGFixThread)
  protected
    FDoValidate : boolean;
    FContinue : TAskReply;
    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
    procedure GetContinue();
  end;

  TBaseBackupThread = class(TBaseBackRestThread)
  protected
    FBackupFile : string;
    FUseVerifFile : boolean;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; BackupFile : string; UseVerifFile : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TBaseRetoreThread = class(TBaseBackRestThread)
  protected
    FBackupFile : string;
    FUseVerifFile : boolean;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; BackupFile : string; UseVerifFile : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
  end;

  TBaseBackRestLameThread = class(TGFixThread)
  protected
    FDoValidate  : boolean;
    FEasyService : string;
    FBACKUP_MAX  : Integer;
    FBackup_Dir  : string;
    F7zFiles     : T7zFiles;
    FBACKUP_WITH_OLD_IB : integer;
    FBACKUP_Compression_7Z : integer;
    FPropertiesFile : string;
    Procedure CleanDirBackup(aDir:string);
    procedure GetFileList(inDir, Extension : String );
    function Compress7z(aFiles:TstringList;a7zFile:string):integer;
    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream;
        FileLog,
        EasyService , Serveur, DataBase : string; Port : integer;
        DoValidate: boolean; PageBuffers : cardinal;
        BACKUP_Max  : Integer;
        Backup_Dir  : string;
        BACKUP_WITH_OLD_IB : integer;
        BACKUP_Compression_7Z : integer;
        PropertiesFile : string;
        Progress : TProgressBar; StepLbl : TLabel;
        CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  Procedure Order(var Tab:T7zFiles);




implementation

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.Math,
  System.StrUtils,
  System.SysUtils,
  System.UITypes,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBBase,
  Vcl.Dialogs,
  uVerificationBase,
  uFileUtils,
  uGestionBDD,
  uSevenZip;

{ TGFixThread }

procedure TGFixThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Shutdown base
// 2 - Erreur de validation
// 3 - GFix
// 4 - Restart base
// 5 - Exception
// 6 - Autre erreur
begin
  ReturnValue := 6;
  ProgressStyle(pbstMarquee);

  try
    ProgressStyle(pbstNormal);
    ProgressInit(4);

    try
      // shutdown
      DoLog('/******************************************************************************/');
      ProgressStepLbl('Shutdown de la base');
      DoLog('');
      if not DoActivation(false) then
      begin
        ReturnValue := 1;
        Exit;
      end;
      ProgressStepIt();

      // validation de la base
      DoLog('/******************************************************************************/');
      ProgressStepLbl('Validation de la base');
      DoLog('');
      if not DoValidate(FDataBase) then
      begin
        ReturnValue := 2;
        Exit;
      end;
      ProgressStepIt();

      // petit GFIX ??
      DoLog('/******************************************************************************/');
      ProgressStepLbl('GFix de la base');
      DoLog('');
      if not DoGFix(FDataBase) then
      begin
        ReturnValue := 3;
        Exit;
      end;
      ProgressStepIt();

      // OK ??
      ReturnValue := 0;
    finally
      // Restart
      DoLog('/******************************************************************************/');
      ProgressStepLbl('Restart de la base');
      DoLog('');
      if not DoActivation(true) then
        if ReturnValue = 0 then
          ReturnValue := 4;
      ProgressStepIt();
    end;
  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 5;
    end;
  end;
end;

constructor TGFixThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; PageBuffers : cardinal; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Progress, StepLbl, CreateSuspended);
  FPageBuffers := PageBuffers;
end;

function TGFixThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Erreur lors du shutdown de la base.';
    2 : Result := 'Erreur lors de la validation de la base.';
    3 : Result := 'Erreur lors du GFix de la base.';
    4 : Result := 'Erreur lors du restart de la base.';
    5 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TShutdownThread }

procedure TShutdownThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Restart base
// 2 - Exception
// 3 - Autre erreur
begin
  ReturnValue := 3;
  ProgressStyle(pbstMarquee);

  try
    ProgressInit(1);

    // Restart
    DoLog('/******************************************************************************/');
    ProgressStepLbl('shutdown de la base');
    DoLog('');
    if DoActivation(false) then
      ReturnValue := 0;
    ProgressStepIt();
  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 2;
    end;
  end;
end;

function TShutdownThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Erreur lors du shutdown de la base.';
    2 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TRestartThread }

procedure TRestartThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Restart base
// 2 - Exception
// 3 - Autre erreur
begin
  ReturnValue := 3;
  ProgressStyle(pbstMarquee);

  try
    ProgressInit(1);

    // Restart
    DoLog('/******************************************************************************/');
    ProgressStepLbl('Restart de la base');
    DoLog('');
    if DoActivation(true) then
      ReturnValue := 0;
    ProgressStepIt();
  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 2;
    end;
  end;
end;

function TRestartThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Erreur lors du restart de la base.';
    2 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TStatisticsThread }

procedure TStatisticsThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Exception
// 2 - Autre erreur
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  QueryLst, QueryUpd : TMyQuery;
begin
  ReturnValue := 2;
  ProgressStyle(pbstMarquee);

  try
    try
      Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
      Transaction := GetNewTransaction(Connexion, false);

      Connexion.Open();
      Transaction.StartTransaction();

      try
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Recuperation de la liste des index');
        DoLog('');

        QueryLst := GetNewQuery(Connexion, Transaction);
        QueryLst.SQL.Text := 'select rdb$index_name as name from rdb$indices where rdb$system_flag = 0 or rdb$system_flag is null;';
        QueryLst.Open();
        QueryLst.FetchAll();

        // init progress bar !
        ProgressInit(QueryLst.RecordCount);

        DoLog('/******************************************************************************/');
        ProgressStepLbl('Recalcul des index');
        DoLog('');

        QueryUpd := GetNewQuery(Connexion, Transaction);

        while not QueryLst.Eof do
        begin
          ProgressStepLbl('Traitement de l''index "' + QueryLst.FieldByName('name').AsString + '"...');
          QueryUpd.SQL.Text := 'set statistics index ' + QueryLst.FieldByName('name').AsString + ';';
          QueryUpd.ExecSQL();
          QueryLst.Next();
          ProgressStepIt();
        end;

        ProgressStepLbl('Commit');
        Transaction.Commit();
        ReturnValue := 0;
      except
        Transaction.Rollback();
        raise;
      end;
    finally
      FreeAndNil(QueryLst);
      FreeAndNil(QueryUpd);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 1;
    end;
  end;
end;

function TStatisticsThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TRecompileThread }

procedure TRecompileThread.Execute();

  function GetTextArguments(Name : string; Query : TMyQuery) : string;
  var
    sIn, sOut : string;
  begin
    Result := '';
    sIn := '';
    sOut := '';

    Query.SQL.Text := Format(SQL_ASK_PROCPARAM, [QuotedStr(Name)]);
    try
      Query.Open();
      while not Query.Eof do
      begin
        case Query.FieldByName('in_or_out').AsInteger of
          0 : // in
            begin
              if sIn = '' then
                sIn := ' (' + #13#10 + '    "' + Query.FieldByName('parameter_name').AsString + '" ' + GetTypeFromDB(Query)
              else
                sIn := sIn + ',' + #13#10 + '    "' + Query.FieldByName('parameter_name').AsString + '" ' + GetTypeFromDB(Query)
            end;
          1 : // out
            begin
              if sOut = '' then
                sOut := 'returns (' + #13#10 + '    "' + Query.FieldByName('parameter_name').AsString + '" ' + GetTypeFromDB(Query)
              else
                sOut := sOut + ',' + #13#10 + '    "' + Query.FieldByName('parameter_name').AsString + '" ' + GetTypeFromDB(Query)
            end;
        end;
        Query.Next();
      end;

      if Trim(sIn) <> '' then
        Result := sIn + ')';
      if Trim(sOut) <> '' then
        Result := Result + #13#10 + sOut + ')';
    finally
      Query.Close();
    end;
  end;

  function GetTextProcedure(Name : string; Query : TMyQuery; Term : string = '^') : string;
  var
    sAlter, sArgs, sBody : string;
    nbIn, nbOut : integer;
  begin
    Result := '';
    sAlter := '';
    sArgs := '';
    sBody := '';

    Query.SQL.Text := Format(SQL_ASK_PROCEDURE, [QuotedStr(Name)]);
    try
      Query.Open();
      if not Query.Eof then
      begin
        sAlter := 'alter procedure "' + Query.FieldByName('rdb$procedure_name').AsString + '"';
        sBody := Trim(Query.FieldByName('rdb$procedure_source').AsString);
        nbIn := Query.FieldByName('rdb$procedure_inputs').AsInteger;
        nbOut := Query.FieldByName('rdb$procedure_outputs').AsInteger;
      end;
    finally
      Query.Close();
    end;
    if nbIn + nbOut > 0 then
      sArgs := GetTextArguments(Name, Query);

    if Trim(sBody) <> '' then
      Result := sAlter + sArgs + #13#10 + 'as' + #13#10 + sBody + ';' + Term;
  end;

  function GetTextTrigger(Name : string; Query : TMyQuery; Term : string = '^') : string;
  var
    sAlter, sBody : string;
  begin
    Result := '';

    Query.SQL.Text := Format(SQL_ASK_TRIGGER, [QuotedStr(Name)]);
    try
      Query.Open();
      if not Query.Eof then
      begin
//      if qryTriggers.FieldByName('RDB$FLAGS').AsInteger <> 1 then  {do not localize}
//        SList.Add('/* ');   {do not localize}
        sAlter := 'alter trigger ' + Name + #13#10
                + IfThen((Query.FieldByName('rdb$trigger_inactive').IsNull or (Query.FieldByName('rdb$trigger_inactive').AsInteger = 1)), 'inactive ', 'active ')
                + TriggerTypes[Query.FieldByName('rdb$trigger_type').AsInteger]
                + ' position ' + Query.FieldByName('rdb$trigger_sequence').Asstring;
        sBody := Trim(Query.FieldByName('rdb$trigger_source').AsString);
//      if qryTriggers.FieldByName('RDB$FLAGS').AsInteger <> 1 then  {do not localize}
//        SList.Add(' */');         {do not localize}
      end;
    finally
      Query.Close();
    end;

    if Trim(sBody) <> '' then
      Result := sAlter + #13#10 + sBody + ';' + Term;
  end;

// code de retour :
// 0 - reussite
// 1 - Exception
// 2 - Autre erreur
var
  Connexion : TMyConnection;
  TransactionLst, TransactionUpd : TMyTransaction;
  QueryLst, QueryDet, QueryUpd : TMyQuery;
begin
  ReturnValue := 2;
  ProgressStyle(pbstMarquee);

  try
    try
      Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
      TransactionLst := GetNewTransaction(Connexion, false);
      TransactionUpd := GetNewTransaction(Connexion, false);

      Connexion.Open();
      TransactionLst.StartTransaction();

      try
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Recuperation de la liste des procedures et triggers');
        DoLog('');

        QueryLst := GetNewQuery(Connexion, TransactionLst);
        QueryLst.SQL.Text := SQL_ASK_RECOMPILE;
        QueryLst.Open();
        QueryLst.FetchAll();

        // init progress bar !
        ProgressInit(QueryLst.RecordCount);

        DoLog('/******************************************************************************/');
        ProgressStepLbl('Recompilation des procedures');
        DoLog('');

        QueryDet := GetNewQuery(Connexion, TransactionUpd);
        QueryUpd := GetNewQuery(Connexion, TransactionUpd);

        while not QueryLst.Eof do
        begin
          try
            TransactionUpd.StartTransaction();

            case IndexText(QueryLst.FieldByName('type').AsString, ['trigger', 'procedure']) of
              0 :
                begin
                  ProgressStepLbl('Traitement du trigger "' + QueryLst.FieldByName('name').AsString + '"...');
                  QueryUpd.SQL.Text := GetTextTrigger(QueryLst.FieldByName('name').AsString, QueryDet, '');
                  QueryUpd.ExecSQL();
                end;
              1 :
                begin
                  ProgressStepLbl('Traitement de la procedure "' + QueryLst.FieldByName('name').AsString + '"...');
                  QueryUpd.SQL.Text := GetTextProcedure(QueryLst.FieldByName('name').AsString, QueryDet, '');
                  QueryUpd.ExecSQL();
                end;
            end;

            TransactionUpd.Commit();
          except
            TransactionUpd.Rollback();
            raise;
          end;
          QueryLst.Next();
          ProgressStepIt();
        end;

        ProgressStepLbl('Commit');
        TransactionLst.Commit();
        ReturnValue := 0;
        DoLog('');
        DoLog('Traitement terminé avec succès.');
      except
        TransactionLst.Rollback();
        raise;
      end;
    finally
      FreeAndNil(QueryLst);
      FreeAndNil(QueryDet);
      FreeAndNil(QueryUpd);
      FreeAndNil(TransactionLst);
      FreeAndNil(TransactionUpd);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 1;
    end;
  end;
end;

function TRecompileThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TBaseBackRestThread }

procedure TBaseBackRestThread.Execute();
// code de retour :
//  0 - reussite
// ...
//  2 - Pas assez d'espace
//  3 - Shutdown base
//  4 - Erreur de validation
//  5 - Erreur lors de la creation de verif
//  6 - Erreur de backup
//  7 - Erreur de restauration
//  8 - GFix
//  9 - Verification nok
// 10 - Restart base
// 11 - Exception
// 12 - Autre erreur
var
  Verif : TDataBaseVerif;
  ResVerif : TStringList;
  SvgName, OldName, NewName : string;
  FileSize : int64;
begin
  ReturnValue := 12;
  ProgressStyle(pbstMarquee);
  SvgName := ChangeFileExt(FDataBase, '.TMP');
  OldName := ChangeFileExt(FDataBase, '.OLD');
  NewName := ChangeFileExt(FDataBase, '.NEW');

  try
    CoInitialize(nil);

    if FileExists(SvgName) then
      TFile.Delete(SvgName);
    if FileExists(OldName) then
      TFile.Delete(OldName);
    if FileExists(NewName) then
      TFile.Delete(NewName);

    try
      ProgressInit(10);

      // recherche de la taille...
      FileSize := GetFileSize(FDataBase);

      // verification de taille !
      DoLog('/******************************************************************************/');
      ProgressStepLbl('Vérification de l''espace disque');
      DoLog('');
      if CharInSet(ExtractFileDrive(FDataBase)[1], ['A'..'Z', 'a'..'z']) then
      begin
        if not (GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1]) > (FileSize * 2)) then // que deux fois car la base est déjà dessus en fait ... donc 3 avec le déjà present
        begin
          DoLog('Disque : ' + ExtractFileDrive(FDataBase)[1]);
          DoLog('  -> espace dispo : ' + IntToStr(GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1])));
          DoLog('  -> espace voulu : ' + IntToStr(Trunc(FileSize * 2.0)));
          ReturnValue := 2;
          Exit;
        end;
      end
      else
        DoLog('  -> sur le réseau, on ne vérifie pas...');
      ProgressStepIt();

      try
        // shutdown
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Shutdown de la base');
        DoLog('');
        if not DoActivation(false) then
        begin
          ReturnValue := 3;
          Exit;
        end;
        ProgressStepIt();

        try
          // renommage du fichier
          MoveFile(PWideChar(FDataBase), PWideChar(OldName));
          ProgressStepIt();

          // validation de la base
          if FDoValidate then
          begin
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Validation de la base');
            DoLog('');
            if not DoValidate(OldName) then
            begin
              ReturnValue := 4;
              Exit;
            end;
          end;
          ProgressStepIt();

          try
            Verif := TDataBaseVerif.Create();

            // Chargement de la verification
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Préparation de la vérification');
            DoLog('');
            if not Verif.FillFromDatabase(FServeur, OldName, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort) then
            begin
              ReturnValue := 5;
              Exit;
            end;
            ProgressStepIt();

            try
              // backup
              DoLog('/******************************************************************************/');
              ProgressStepLbl('Backup de la base');
              DoLog('');
              //
              if not DoBackup(OldName, SvgName, [boNoGarbageCollect, boNonTransportable, boExpand]) then
              begin
                ReturnValue := 6;
                Exit;
              end;
              ProgressStepIt();

              // retore
              DoLog('/******************************************************************************/');
              ProgressStepLbl('Restauration de la base');
              DoLog('');
              //
              if not DoRestore(NewName, SvgName, [roNoShadow, roNoValidity, roReplace ,roOneAtATime]
              {[}, 4096, 4096) then
              begin
                ReturnValue := 7;
                Exit;
              end;
              ProgressStepIt();

              // petit GFIX ??
              DoLog('/******************************************************************************/');
              ProgressStepLbl('GFix de la base');
              DoLog('');
              if not DoGFix(NewName) then
              begin
                ReturnValue := 8;
                Exit;
              end;
              ProgressStepIt();

              // verification de la retoration
              try
                DoLog('/******************************************************************************/');
                ProgressStepLbl('Vérification de la base');
                DoLog('');
                ResVerif := Verif.CompareWithDatabase(FServeur, NewName, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort);
                if ResVerif.Count = 0 then
                  ReturnValue := 0
                else
                begin
                  if FContinue = ear_Unknown then
                    Synchronize(GetContinue);
                  if FContinue = ear_Yes then
                  begin
                    DoLog(ResVerif);
                    ReturnValue := 0;
                  end
                  else
                  begin
                    DoLog(ResVerif);
                    ReturnValue := 9;
                  end;
                end;
                ProgressStepIt();
              finally
                FreeAndNil(ResVerif);
              end;
            finally
              TFile.Delete(SvgName);
            end;
          finally
            FreeAndNil(Verif);
          end;
        finally
          if ReturnValue = 0 then
          begin
            TFile.Delete(OldName);
            MoveFile(PWideChar(NewName), PWideChar(FDataBase));
          end
          else
          begin
            TFile.Delete(NewName);
            MoveFile(PWideChar(OldName), PWideChar(FDataBase));
          end;
        end;
      finally
        // Restart
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Restart de la base');
        DoLog('');
        if not DoActivation(true) then
          if ReturnValue = 0 then
            ReturnValue := 10;
        ProgressStepIt();
      end;
    except
      on e : Exception do
      begin
        DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        ReturnValue := 11;
      end;
    end;
  finally
    CoUninitialize();
  end;
end;

constructor TBaseBackRestThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, PageBuffers, Progress, StepLbl, CreateSuspended);
  FDoValidate := DoValidate;
  FContinue := DoContinue;
end;

function TBaseBackRestThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
     0 : Result := 'Traitement effectué correctement.';
     1 : Result := 'GUID non trouvé.';
     2 : Result := 'Pas assez de place (base * 3).';
     3 : Result := 'Erreur lors du shutdown de la base.';
     4 : Result := 'Erreur lors de la validation de la base.';
     5 : Result := 'Erreur lors de la creation de la structure de vérification.';
     6 : Result := 'Erreur lors du backup.';
     7 : Result := 'Erreur lors de la restauration.';
     8 : Result := 'Erreur lors du GFix de la base.';
     9 : Result := 'Vérification non conforme.';
    10 : Result := 'Erreur lors du restart de la base.';
    11 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

procedure TBaseBackRestThread.GetContinue();
begin
  if FContinue = ear_Unknown then
  begin
    case MessageDlg('Erreur de vérification des nombres d''enregistrement...'#13'Voulez vous contuinuer ?', mtConfirmation, [mbYes, mbNo], 0) of
      mrYes : FContinue := ear_Yes;
      else    FContinue := ear_No;
    end;
  end;
end;

{ TBaseBackupThread }

procedure TBaseBackupThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Pas assez d'espace
// 2 - Erreur lors de la creation de verif
// 3 - Erreur de backup
// 4 - Erreur de Zip
// 5 - Exception
// 6 - Autre erreur
var
  Verif : TDataBaseVerif;
  FilesTo7z : TStringList;
  DestPath, SvgName, VrfName : string;
  FileSize : int64;
begin
  ReturnValue := 6;
  ProgressStyle(pbstMarquee);

  try
    CoInitialize(nil);

    if FileExists(FBackupFile) then
      TFile.Delete(FBackupFile);

    try
      ProgressInit(5);

      try
        DestPath := GetTempDirectory(ExtractFilePath(FBackupFile));
        ForceDirectories(DestPath);
        SvgName := DestPath + ChangeFileExt(ExtractFileName(FBackupFile), '.GBK');
        VrfName := DestPath + ChangeFileExt(ExtractFileName(FBackupFile), '.XML');

        // recherche de la taille...
        FileSize := GetFileSize(FDataBase);

        // verification de taille !
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Vérification de l''espace disque');
        DoLog('');
        if CharInSet(ExtractFileDrive(FDataBase)[1], ['A'..'Z', 'a'..'z']) then
        begin
          if (GetDiskFreeSpace(ExtractFileDrive(FBackupFile)[1]) < (FileSize * 2)) then
          begin
            DoLog('Disque : ' + ExtractFileDrive(FDataBase)[1]);
            DoLog('  -> espace dispo : ' + IntToStr(GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1])));
            DoLog('  -> espace voulu : ' + IntToStr(Trunc(FileSize * 2.0)));
            ReturnValue := 1;
            Exit;
          end;
        end
        else
          DoLog('  -> sur le réseau, on ne vérifie pas...');
        ProgressStepIt();

        try
          Verif := TDataBaseVerif.Create();

          // Chargement de la verification
          DoLog('/******************************************************************************/');
          ProgressStepLbl('Préparation de la vérification');
          DoLog('');
          if FUseVerifFile then
          begin
            if not Verif.FillFromDatabase(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort) then
            begin
              ReturnValue := 2;
              Exit;
            end;
          end;
          ProgressStepIt();

          try
            // backup
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Backup de la base');
            DoLog('');
            if not DoBackup(FDataBase, SvgName) then
            begin
              ReturnValue := 3;
              Exit;
            end;
            ProgressStepIt();

            try
              // sauvegarde du fichier de verif
              DoLog('/******************************************************************************/');
              ProgressStepLbl('Enregistrement du fichier de verif');
              DoLog('');
              if FUseVerifFile then
                Verif.SaveToXml(VrfName);
              ProgressStepIt();

              // zip de la base
              DoLog('/******************************************************************************/');
              ProgressStepLbl('Création du fichier 7z');
              DoLog('');
              try
                FilesTo7z := TStringList.Create();
                FilesTo7z.Add(SvgName);
                if FUseVerifFile then
                  FilesTo7z.Add(VrfName);

                if Do7Zip(FilesTo7z, FBackupFile) then
                  ReturnValue := 0
                else
                begin
                  ReturnValue := 4;
                  Exit;
                end
              finally
                FreeAndNil(FilesTo7z);
              end;
              ProgressStepIt();
            finally
              TFile.Delete(VrfName);
            end;
          finally
            TFile.Delete(SvgName);
          end;
        finally
          FreeAndNil(Verif);
        end;
      finally
        DelTree(DestPath);
      end;
    except
      on e : Exception do
      begin
        DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        ReturnValue := 5;
      end;
    end;
  finally
    CoUninitialize();
  end;
end;

constructor TBaseBackupThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; BackupFile : string; UseVerifFile : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, DoValidate, PageBuffers, DoContinue, Progress, StepLbl, CreateSuspended);
  FBackupFile := BackupFile;
  FUseVerifFile := UseVerifFile;
end;

function TBaseBackupThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Fichier non trouvé.';
    2 : Result := 'Pas assez de place (base * 3).';
    3 : Result := 'Erreur lors de la creation de la structure de vérification.';
    4 : Result := 'Erreur lors du backup.';
    5 : Result := 'Erreur lors de la création du fichier 7z.';
    6 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TBaseRetoreThread }

procedure TBaseRetoreThread.Execute();
// code de retour :
//  0 - reussite
//  1 - Erreur de fichier
// ...
//  3 - Pas assez d'espace
// ...
//  5 - Erreur lors du dézippage
//  6 - Erreur de restauration
//  7 - GFix
//  8 - Erreur lors de la vérification de la restauration
// ...
// ...
// 11 - Erreur de validation
// 12 - Restart de base
// 13 - Exception
// 14 - Autre erreur
var
  Verif : TDataBaseVerif;
  ResVerif : TStringList;
  NewName, DestPath : string;
  FileExt, SvgName, VrfName : string;
  FileSize : int64;
  RetFind : integer;
  FindStruc : TSearchRec;
begin
  ReturnValue := 14;
  ProgressStyle(pbstMarquee);
  NewName := ChangeFileExt(FDataBase, '.NEW');
  FileExt := '';
  SvgName := '';
  VrfName := '';

  try
    CoInitialize(nil);
    if FileExists(FBackupFile) then
    begin
      if FileExists(FDataBase) then
        TFile.Delete(FDataBase);
      if FileExists(NewName) then
        TFile.Delete(NewName);

      try
        ProgressInit(7);

        try
          DestPath := GetTempDirectory(ExtractFilePath(FDataBase));
          ForceDirectories(DestPath);

          // recherche de la taille... (approximatif, estamation Ainoux)
          FileExt := UpperCase(ExtractFileExt(FBackupFile));
          if (FileExt = '.GBK') or (FileExt = '.IBK') then
            FileSize := Round(GetFileSize(FBackupFile) * 2.2)
          else if (FileExt = '.7Z') or (FileExt = '.ZBK') then
            FileSize := Round(GetFileSize(FBackupFile) * 25.5)
          else if (FileExt = '.ZIP') then
            FileSize := Round(GetFileSize(FBackupFile) * 13.5)
          else
            FileSize := 0;

          // verification de taille !
          DoLog('/******************************************************************************/');
          ProgressStepLbl('Vérification de l''espace disque');
          DoLog('');
          if CharInSet(ExtractFileDrive(FDataBase)[1], ['A'..'Z', 'a'..'z']) then
          begin
            if (GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1]) < Trunc(FileSize * 1.5)) then
            begin
              DoLog('Disque : ' + ExtractFileDrive(FDataBase)[1]);
              DoLog('  -> espace dispo : ' + IntToStr(GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1])));
              DoLog('  -> espace voulu : ' + IntToStr(Trunc(FileSize * 1.5)));
              ReturnValue := 3;
              Exit;
            end;
          end
          else
            DoLog('  -> sur le réseau, on ne vérifie pas...');
          ProgressStepIt();

          // Gestion du Zip ou pas !
          DoLog('/******************************************************************************/');
          ProgressStepLbl('Décompression/Copie');
          DoLog('');
          if (FileExt = '.GBK') or (FileExt = '.IBK') then
          begin
            SvgName := DestPath + ExtractFileName(FBackupFile);
            CopyFile(PWideChar(FBackupFile), PWideChar(SvgName), true);
            if FileExists(ChangeFileExt(FBackupFile, '.xml')) then
            begin
              VrfName := DestPath + ChangeFileExt(ExtractFileName(FBackupFile), '.xml');
              CopyFile(PWideChar(ChangeFileExt(FBackupFile, '.xml')), PWideChar(VrfName), true);
            end;
          end
          else if (FileExt = '.7Z') or (FileExt = '.ZBK') or (FileExt = '.ZIP') then
          begin
            if DoUn7Zip(DestPath, FBackupFile) then
            begin
              try
                RetFind := FindFirst(DestPath + '*.*', faanyfile, FindStruc);
                while RetFind = 0 do
                begin
                  FileExt := UpperCase(ExtractFileExt(FindStruc.Name));
                  if (FileExt = '.GBK') or (FileExt = '.IBK') then
                    SvgName := DestPath + FindStruc.Name
                  else if (FileExt = '.XML') then
                    VrfName := DestPath + FindStruc.Name;
                  RetFind := FindNext(FindStruc);
                end;
              finally
                // findClose(FindStruc);
              end;
            end
            else
            begin
              ReturnValue := 5;
              Exit;
            end;
          end;
          // est ce que le fichier de sauvegarde est la ?
          if SvgName = '' then
          begin
            ReturnValue := 1;
            Exit;
          end;
          ProgressStepIt();

          try
            // retore
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Restauration de la base');
            DoLog('');
            if not DoRestore(NewName, SvgName) then
            begin
              ReturnValue := 6;
              Exit;
            end;
            ProgressStepIt();

            // petit GFIX ??
            DoLog('/******************************************************************************/');
            ProgressStepLbl('GFix de la base');
            DoLog('');
            if not DoGFix(NewName) then
            begin
              ReturnValue := 7;
              Exit;
            end;
            ProgressStepIt();

            // verification
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Vérification de la base');
            DoLog('');
            if FUseVerifFile and (VrfName <> '') then
            begin
              try
                Verif := TDataBaseVerif.Create();
                Verif.LoadFromXml(VrfName);
                ResVerif := Verif.CompareWithDatabase(FServeur, NewName, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort);
                if ResVerif.Count > 0 then
                begin
                  ResVerif.SaveToFile(ExtractFilePath(FDataBase) + 'VerifBakRest.log');
                  ReturnValue := 8;
                  Exit;
                end;
              finally
                FreeAndNil(Verif);
              end;
            end;
            ProgressStepIt();

            // validation de la base
            if FDoValidate then
            begin
              DoLog('/******************************************************************************/');
              ProgressStepLbl('Validation de la base');
              DoLog('');
              if not DoValidate(NewName) then
              begin
                ReturnValue := 11;
                Exit;
              end;
            end;
            ProgressStepIt();

            // ok terminé ??
            ReturnValue := 0;
          finally
            if ReturnValue = 0 then
              MoveFile(PWideChar(NewName), PWideChar(FDataBase))
            else
              TFile.Delete(NewName);
          end;

          // Restart
          DoLog('/******************************************************************************/');
          ProgressStepLbl('Restart de la base');
          DoLog('');
          if not DoActivation(true) then
          begin
            ReturnValue := 12;
            Exit;
          end;
          ProgressStepIt();
        finally
          DelTree(DestPath);
        end;
      except
        on e : Exception do
        begin
          DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
          ReturnValue := 13;
        end;
      end;
    end
    else
      ReturnValue := 1;
  finally
    CoUninitialize();
  end;
end;

constructor TBaseRetoreThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; BackupFile : string; UseVerifFile : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, DoValidate, PageBuffers, DoContinue, Progress, StepLbl, CreateSuspended);
  FBackupFile := BackupFile;
  FUseVerifFile := UseVerifFile;
end;

constructor TBaseBackRestLameThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, EasyService, Serveur, DataBase : string; Port : integer; DoValidate: boolean; PageBuffers : cardinal;
        BACKUP_Max  : Integer;
        Backup_Dir  : string;
        BACKUP_WITH_OLD_IB : integer;
        BACKUP_Compression_7Z : integer;
        PropertiesFile : string;
        Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, PageBuffers, Progress, StepLbl, CreateSuspended);
  FEASYService := EasyService;
  FBACKUP_MAX  := BACKUP_Max;
  FBACKUP_Dir  := BACKUP_Dir;
  FBACKUP_WITH_OLD_IB := BACKUP_WITH_OLD_IB;
  FBACKUP_Compression_7Z := BACKUP_Compression_7Z;

  FPropertiesFile := PropertiesFile;
  FDoValidate  := DoValidate;
end;


function TBaseBackRestLameThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
     0 : Result := 'Traitement effectué correctement.';
     1 : Result := 'GUID non trouvé.';
     2 : Result := 'Pas assez de place (base * 3).';
     3 : Result := 'Erreur lors du shutdown de la base.';
     4 : Result := 'Erreur lors du renommage du fichier ib';
     5 : Result := 'Erreur lors de la validation de la base.';
     6 : Result := 'Erreur lors du backup.';
     7 : Result := 'Erreur lors de la restauration.';
     8 : Result := 'Erreur lors du GFix de la base.';
     9 : Result := 'Vérification non conforme.';
    10 : Result := 'Erreur lors du restart de la base.';
    11 : Result := 'Exception lors du traitement.';
    12 : Result := 'Exception lors du traitement.';
    13 : Result := 'Erreur à l''arrêt du Service EASY.';
    14 : Result := 'Erreur au redémarrage du Service EASY.';
    15 : Result := 'Erreur le Fichier .ib n''est pas présent.';
    16 : Result := 'Fichier de Travail (TMP, NEW ou OLD) déjà présent.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

procedure TBaseBackRestLameThread.GetFileList(inDir, Extension : String );
procedure ProcessSearchRec( aSearchRec : TSearchRec );
var  st: TSystemTime;
     sDate :string;
     i :integer;
begin
  if ( aSearchRec.Attr and faDirectory ) <> 0 then
    begin
      if ( aSearchRec.Name <> '.' ) and
      ( aSearchRec.Name <> '..' ) then
      begin
        GetFileList(Extension, InDir + '\' + aSearchRec.Name );
      end;
     end
      else
        begin
          FileTimeToSystemTime(aSearchRec.FindData.ftCreationTime,st);
          i := Length(F7zFiles);
          SetLength(F7zFiles,i+1);
          F7zFiles[i].FileName       := aSearchRec.Name;
          F7zFiles[i].CreateDateTime := SystemTimeToDateTime(st);
        end;
end;

var CurDir : String;
    aSearchRec : TSearchRec;
begin
  CurDir := inDir + '\*.' + Extension;
  if FindFirst( CurDir, faAnyFile, aSearchRec ) = 0 then
    begin
      ProcessSearchRec( aSearchRec );
      while FindNext( aSearchRec ) = 0 do
      ProcessSearchRec( aSearchRec );
    end;
    FindClose(aSearchRec);
end;

Procedure TBaseBackRestLameThread.CleanDirBackup(aDir:string);
var i:Integer;
begin
    SetLength(F7zFiles,0);
    try
       GetFileList(aDir,'7z');
       Order(F7zFiles);
       for i:=High(F7zFiles)-FBACKUP_MAX downto Low(F7zFiles) do
        begin
          TFile.Delete(aDir+F7zFiles[i].FileName);
        end;
      SetLength(F7zFiles,0);
    finally
      //
    end;
end;

procedure TBaseBackRestLameThread.Execute();
// code de retour :
//  0 - reussite
// ...
//  2 - Pas assez d'espace
//  3 - Shutdown base
//  4 - Erreur deplacement fichier
//  5 - Erreur de validation
//  6 - Erreur de backup
//  7 - Erreur de restauration
//  8 - GFix
//  9 - Verification nok
// 10 - Restart base
// 11 - Exception
// 12 - Autre erreur
// 13 - Erreur à l'arret du Service EASY_XXX
// 14 - Erreur au Restart du Service EASY_XXX
// 15 - Fichier IB Absent !!
// 16 - Fichier TMP, NEW Ou OLD déjà présent au debut !!
// 17 - Erreur à la compression..
// 18 - Impossible de déplacer le fichier 7z.

var
  // Verif : TDataBaseVerif;
  // ResVerif : TStringList;
  TMPName, OldName, NewName,GBKName, ZipName : string;
  vDestPropertiesFile : String;
  FileSize : int64;
  vRunOnBegin : boolean;
  vRes7Z   : integer;
  vboucle  : Integer;
  vFiles   : TStringList;
  vCheminFinal7z : string;
  vDossier       : string;
  vSource      :string;
  vDestination :string;
  regExp : TPerlRegEx;
  vIsFTP : Boolean;
  vHost     :string;
  vUserName :string;
  vPassword :string;
  vPort     :integer;
  vLame     :string;


begin
  ReturnValue := 12;
  ProgressStyle(pbstMarquee);

  vDossier        := ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath(FDataBase)));

  vHost     := '';
  vUserName := '';
  vPassword := '';
  vPort     := 21;
  vLame     := '';

  vIsFTP    := false;
  // Si nous sommes en mode "FTP"
  if Pos('ftp://',FBackup_Dir)=1
    then
       begin
          vIsFTP := true;
          regExp := TPerlRegEx.Create;
          try
            regExp.RegEx := 'ftp:\/\/(.*)?:([0-9]*)\/(.*)\/(.*)\/';
            regExp.Subject  := FBackup_Dir;
            // regExp.Options  := [preCaseLess];
            If (regExp.Match())
              then
                begin
                   vHost     :=  regExp.Groups[1];
                   vUserName := 'backup';
                   vPassword := 'ch@mon1x';
                   vPort     := StrToIntDef(regExp.Groups[2],21);
                   vLame     := regExp.Groups[3];
                end;
          finally
            regExp.Free;
          end;
       end
    else
      begin
         vCheminFinal7z  := ExcludeTrailingPathDelimiter(StringReplace(FBackup_Dir,'<DOSSIER>',vDossier,[rfIgnoreCase]));
         ForceDirectories(vCheminFinal7z);
         vCheminFinal7z  := IncludeTrailingPathDelimiter(vCheminFinal7z);
      end;


  TMPName := ChangeFileExt(FDataBase, '.TMP');
  GBKName := IncludeTrailingPathDelimiter(ExtractFilePath(FDataBase)+ 'backup') + 'SAV.GBK';
      //              + 'SAV_'+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.GBK';
  ForceDirectories(ExtractFileDir(GBKName));
  OldName := ChangeFileExt(FDataBase, '.OLD');
  NewName := ChangeFileExt(FDataBase, '.NEW');

  vFiles := TStringList.Create;
  ZipName := IncludeTrailingPathDelimiter(ExtractFilePath(FDataBase)+ 'backup')
             + 'SAV_'+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.7z';
  vDestPropertiesFile := IncludeTrailingPathDelimiter(ExtractFilePath(FDataBase)+ 'backup') +
        extractfilename(FPropertiesFile);

  try
    CoInitialize(nil);

    // Si le fichier .ib n'existe pas : On ne fait RIEN !!!!
    // il ne faut surtout pas virer le moindre fichier....
    //
    if Not(FileExists(FDataBase))
      then
        begin
          ReturnValue := 15;
          Exit;
        end;

    // si les anciens fichier TMP,OLD,NEW sont présents c'est pas normal non plus
    // on ne les supprime pas non plus ==> Erreur 16
    {
    if FileExists(TMPName) then
      DeleteFile(TMPName);
    if FileExists(GBKName) then
      DeleteFile(GBKName);
    if FileExists(OldName) then
      DeleteFile(OldName);
    if FileExists(NewName) then
      DeleteFile(NewName);
    }
    if (FileExists(TMPName) or FileExists(GBKName) or FileExists(OldName) or FileExists(NewName))
      then
        begin
            ReturnValue := 16;
            exit;
        end;


    try
      ProgressInit(10);
      vRunOnBegin := False;
      if FEASYService<>''
        then
          begin
            // ProgressStepLbl('Arrêt Service ' + FEASYService);
            if ServiceGetStatus(PChar(FServeur),Pchar(FEaSyService))=4 then
              begin
                 ServiceStop(FServeur,FEASYService);
                 vRunOnBegin := True;
              end;
            vBoucle:=0;
            while (ServiceGetStatus(PChar(FServeur),Pchar(FEaSyService))<>1) and (vboucle<50) do
              begin
                 Inc(vBoucle);
                 Sleep(100);
              end;
            // s'il n'est pas arrêter ==> Erreur
            if (ServiceGetStatus(PChar(FServeur),Pchar(FEaSyService))<>1) then
              begin
                ReturnValue := 13;
                Exit;
              end;
          end;
      ProgressStepIt();
      // recherche de la taille...
      FileSize := GetFileSize(FDataBase);

      // verification de taille !
      DoLog('/******************************************************************************/');
      ProgressStepLbl('Vérification de l''espace disque');
      DoLog('');
      if CharInSet(ExtractFileDrive(FDataBase)[1], ['A'..'Z', 'a'..'z']) then
      begin
        if not (GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1]) > (FileSize * 2)) then // que deux fois car la base est déjà dessus en fait ... donc 3 avec le déjà present
        begin
          DoLog('Disque : ' + ExtractFileDrive(FDataBase)[1]);
          DoLog('  -> espace dispo : ' + IntToStr(GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1])));
          DoLog('  -> espace voulu : ' + IntToStr(Trunc(FileSize * 2.0)));
          ReturnValue := 2;
          Exit;
        end;
      end
      else
        DoLog('  -> sur le réseau, on ne vérifie pas...');
      ProgressStepIt();

      try
        // shutdown
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Shutdown de la base');
        DoLog('');
        if not DoActivation(false) then
        begin
          ReturnValue := 3;
          Exit;
        end;
        ProgressStepIt();

        try
          // renommage du fichier
          try
            MoveFile(PWideChar(FDataBase), PWideChar(OldName));
          Except
            ReturnValue := 4;
            exit;
          end;
          ProgressStepIt();

          // validation de la base
          if FDoValidate then
          begin
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Validation de la base');
            DoLog('');
            if not DoValidate(OldName) then
            begin
              ReturnValue := 5;
              Exit;
            end;
          end;
          ProgressStepIt();

          try
            {
            Verif := TDataBaseVerif.Create();
            // Chargement de la verification
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Préparation de la vérification');
            DoLog('');
            if not Verif.FillFromDatabase(FServeur, OldName, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort) then
            begin
              ReturnValue := 5;
              Exit;
            end;
            }
            ProgressStepIt();

            try
              // backup
              DoLog('/******************************************************************************/');
              ProgressStepLbl('Backup de la base');
              DoLog('');
              //  boNonTransportable, boExpand
              if not DoBackup(OldName, TMPName, [boNoGarbageCollect]) then
              begin
                ReturnValue := 6;
                Exit;
              end;
              ProgressStepIt();

              // retore
              DoLog('/******************************************************************************/');
              ProgressStepLbl('Restauration de la base');
              DoLog('');
              // roNoShadow, roNoValidity,
              if not DoRestore(NewName, TMPName, [roReplace ,roOneAtATime]
              {[}, 4096, 4096) then
              begin
                ReturnValue := 7;
                Exit;
              end;
              ProgressStepIt();

              // petit GFIX ??
              DoLog('/******************************************************************************/');
              ProgressStepLbl('GFix de la base');
              DoLog('');
              if not DoGFix(NewName) then
              begin
                ReturnValue := 8;
                Exit;
              end;
              ProgressStepIt();


              ReturnValue := 0;

              // verification de la retoration
              {
              try
                DoLog('/******************************************************************************/');
                ProgressStepLbl('Vérification de la base');
                DoLog('');
                ResVerif := Verif.CompareWithDatabase(FServeur, NewName, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort);
                if ResVerif.Count = 0 then
                  ReturnValue := 0
                else
                begin
                  if FContinue = ear_Unknown then
                    Synchronize(GetContinue);
                  if FContinue = ear_Yes then
                  begin
                    DoLog(ResVerif);
                    ReturnValue := 0;
                  end
                  else
                  begin
                    DoLog(ResVerif);
                    ReturnValue := 9;
                  end;
                end;
                ProgressStepIt();
              finally
                FreeAndNil(ResVerif);
              end;
              }
              ProgressStepIt();
            finally
              // On le Delete pas on le deplace vers /backup
              TFile.Move(TMPName,GBKName);
              vFiles.Add(GBKName);

              // on copie le .properties dans backup
              TFile.Copy(FPropertiesFile,vDestPropertiesFile);
              vFiles.Add(vDestPropertiesFile);
            end;
          finally
            // FreeAndNil(Verif);
          end;
        finally
          if ReturnValue = 0 then
          begin
            // deplacer aussi le .ib dans /Backup?
            // Ca sera une Option par defaut OUI... Mais sur les Gros dossiers
            if FBACKUP_WITH_OLD_IB=1 then
              begin
                  TFile.Move(OldName,ExtractFilePath(GBKName)+'GINKOIA.OLD');
                  vFiles.Add(ExtractFilePath(GBKName)+'GINKOIA.OLD');
              end
            else DeleteFile(OldName);

            //  le .NEW devient le .IB
            MoveFile(PWideChar(NewName), PWideChar(FDataBase));

            // Compresssion des fichiers .IB, .GBK et .Properties....
            //  en . 7z
            // donc x+1 fichiers
            ProgressStepLbl('Compression 7z');
            vRes7z := Compress7z(vFiles,ZipName);
            if vRes7Z<>0
              then ReturnValue:=17
              else
               begin
                  Sleep(100);
                  vSource      := ZipName;
                  vDestination := vCheminFinal7z + ExtractFileName(ZipName);
                  if not(vIsFTP)
                    then
                      begin
                         If not(MoveFileEx(PChar(vSource), PChar(vDestination),MOVEFILE_COPY_ALLOWED or MOVEFILE_WRITE_THROUGH))
                          then
                            begin
                                ReturnValue:=18;
                            end
                          else
                           // Nettoyage des fichiers .7z finalement on redescend à x fichiers
                           CleanDirBackup(vCheminFinal7z);
                      end
                    else
                     begin
                        ProgressStepLbl('Dépôt FTP');
                        if Not(FTPPut(vSource,vPort,vHost,vUserName,vPassword,vLame,vDossier))
                          then
                            begin
                              ReturnValue:=18;
                            end
                          else
                        DeleteFile(vSource);
                     end;
               end;
          end
          else
          begin
            DeleteFile(NewName);
            // On remet le .OLD
            MoveFile(PWideChar(OldName), PWideChar(FDataBase));
          end;
        end;
      finally
        // Restart
        DoLog('/******************************************************************************/');
        ProgressStepLbl('Restart de la base');
        DoLog('');
        if not DoActivation(true) then
          if ReturnValue = 0 then
            ReturnValue := 10;

        // On restart uniquement s'il etait démarrer au debut !
        if (ReturnValue=0) and (FEASYService<>'') and (vRunOnBegin)
          then
            begin
              ProgressStepLbl('Restart du Service');
              ServiceStart(FServeur,FEASYService);
              vBoucle:=0;
              while (ServiceGetStatus(PChar(FServeur),Pchar(FEaSyService))<>4) and (vboucle<50) do
                begin
                   Inc(vBoucle);
                   Sleep(100);
                end;
              // s'il n'est pas démarré ==> Erreur
              if (ServiceGetStatus(PChar(FServeur),Pchar(FEaSyService))<>4) then
                begin
                  ReturnValue := 14;
                end;
            end;
        // ---------------------------------------------------------------------
        ProgressStepIt();
      end;
    except
      on e : Exception do
      begin
        DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        ReturnValue := 11;
      end;
    end;
  finally
    vFiles.DisposeOf;
    CoUninitialize();
  end;
end;


function TBaseBackRestLameThread.Compress7z(aFiles:TstringList;a7zFile:string):integer;
var Arch : I7zOutArchive;
    i:integer;
begin
  Arch := CreateOutArchive(CLSID_CFormat7z);
  try
    try
      for i:=0 to aFiles.Count-1 do
        begin
            Arch.AddFile(aFiles.Strings[i],ExtractFileName(aFiles.Strings[i]));
        end;

      //-----------------------------------
      // SetMultiThreading(Arch,4);
      SetCompressionLevel(Arch,FBACKUP_Compression_7Z); // 0=Store 1=faster ? 3=

      Arch.SaveToFile(a7zFile);
      for i:=0 to aFiles.Count-1 do
        begin
           TFile.Delete(aFiles.Strings[i]);
        end;
      result:=0;
      Except on E:Exception do
        begin
          result := 1;
        end;
    end;
  finally
    // FreeAndNil(Arch);
    // Arch._Release;
  end;
end;





Procedure Order(var Tab:T7zFiles);
Var i,j:Integer;
    t:T7zFile;
Begin
  For i:=Low(Tab) To High(Tab)-1 Do
    For j:=i+1 To High(Tab) Do
      If Tab[i].CreateDateTime>Tab[j].CreateDateTime
        then
            Begin
              t:=Tab[i];
              Tab[i]:=Tab[j];
              Tab[j]:=t;
            End;
End;

end.

