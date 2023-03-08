unit UGinIBUtilsThread;

interface

uses
  System.Classes,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  UBaseThread,
  UIBUtilsThread,
  uCreateProcess;

type
  TGinBackRestThread = class(TBaseBackRestThread)
  protected
    FNom : string;
    FGUID : string;
    FGenerateur : integer;
    FDoMaj : boolean;

    function DoMajBase(State : integer; DateFinBck : TDateTime) : boolean; virtual;
    function DoMajYellis(State : integer; DateFinBck : TDateTime) : boolean; virtual;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Nom, GUID : string; Generateur : integer; DoMaj : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
  end;

  TGinRestoreIntoBaseThread = class(TGinBackRestThread)
  protected
    FBackupFile : string;
    FUseVerifFile : boolean;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; UseVerifFile : boolean; BackupFile, Nom, GUID : string; Generateur : integer; DoMaj : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

  TGinCreateFromBackupThread = class(TGinBackRestThread)
  protected
    FBackupFile : string;
    FUseVerifFile : boolean;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; UseVerifFile : boolean; BackupFile : string; DoMaj : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.Math,
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBWrapper,
  FireDAC.Phys.IBBase,
  uSevenZip,
  uYellis,
  UVerificationBase,
  UFileUtils,
  UInfosBase,
  uGestionBDD;

{ TGinBackRestThread }

function TGinBackRestThread.DoMajBase(State : integer; DateFinBck : TDateTime) : boolean;
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  Query : TMyQuery;
  IdBase, IdDos, IdNew, BckOK, ResBck : integer;
begin
  Result := false;

  try
    IdBase := 0;
    IdDos := 0;
    IdNew := 0;
    case State of
      0 :
        begin
          BckOK := 1;
          ResBck := 0;
        end;
      3 :
        begin
          BckOK := 0;
          ResBck := 5;
        end;
      8, 9, 10 :
        begin
          BckOK := 0;
          ResBck := 3;
        end;
      11 :
        begin
          BckOK := 0;
          ResBck := 2;
        end;
      else
        begin
          BckOK := 0;
          ResBck := 4;
        end;
    end;

    try
      Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
      Transaction := GetNewTransaction(Connexion, false);

      Connexion.Open();
      Transaction.StartTransaction();

      try
        Query := GetNewQuery(Connexion, Transaction);

        // recup du ID Base
        Query.SQL.Text := 'select bas_id from genbases where bas_ident = ' + QuotedStr(IntToStr(FGenerateur)) + ';';;
        try
          Query.Open();
          if Query.Eof then
            Raise Exception.Create('Identifiant de base non trouvé.')
          else
            IdBase := Query.FieldByName('bas_id').AsInteger;
        finally
          Query.Close();
        end;

        // Recup de l'enreg de backup
        Query.SQL.Text := 'select dos_id from gendossier where dos_nom = ' + QuotedStr('B-' + IntToStr(IdBase)) + ' and dos_float = ' + IntToStr(BckOK) + ';';
        try
          Query.Open();
          if not Query.Eof then
            IdDos := Query.FieldByName('dos_id').AsInteger;
        finally
          Query.Close();
        end;

        // recup d'un nouvel ID
        Query.SQL.Text := 'select newkey from proc_newkey;';
        try
          Query.Open();
          if not Query.Eof then
            IdNew := Query.FieldByName('newkey').AsInteger;
        finally
          Query.Close();
        end;

        if IdDos = 0 then
        begin
          // pas encore d'enreg de ce type, a créer !!
          Query.Sql.Text := 'insert into gendossier (dos_id, dos_nom, dos_string, dos_float) '
                          + 'values (' + IntToStr(IdNew) + ', ' + QuotedStr('B-' + IntToStr(IdBase)) + ', ' + QuotedStr(DateTimeToStr(DateFinBck) + ' - ' + Inttostr(ResBck)) + ', ' + IntToStr(BckOK) + ')';
          Query.ExecSQL();
          Query.Sql.Text := 'insert into k (k_id, krh_id, ktb_id, k_version, k_enabled, kse_owner_id, kse_insert_id, k_inserted, kse_delete_id, k_deleted, kse_update_id, k_updated, kse_lock_id, kma_lock_id) '
                          + 'values (' + IntToStr(IdNew) + ', -101, -11111338, ' + IntToStr(IdNew) + ', 1, -1, -1, Current_date, 0, Current_date, -1, Current_date, 0, 0)';
          Query.ExecSQL();
        end
        else
        begin
          // mettre a jour !
          Query.Sql.Text := 'update gendossier set dos_string = ' + QuotedStr(DateTimeToStr(DateFinBck) + ' - ' + Inttostr(ResBck)) + ', dos_float = ' + IntToStr(BckOK) + ' where dos_id = ' + IntToStr(IdDos) + ';';
          Query.ExecSQL();
          Query.Sql.Text := 'update k set k_version = ' + IntToStr(IdNew) + ' where k_id = ' + IntToStr(IdDos) + ';';
          Query.ExecSQL();
        end;

        Transaction.Commit();
        Result := true;
      except
        Transaction.Rollback();
        raise;
      end;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TGinBackRestThread.DoMajYellis(State : integer; DateFinBck : TDateTime) : boolean;
var
  Connexion : TMyConnection;
  Query : TMyQuery;
  IdBase : integer;
  Yellis : Tconnexion;
  Res : TStringList;
  ResBck : string;
begin
  Result := false;
  Res := nil;
  IdBase := 0;

  try
    if FDoMaj then
    begin
      try
        Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, false);
        Query := GetNewQuery(Connexion);

        Connexion.Open();

        if State = 0 then
        begin
          try
            Yellis := Tconnexion.Create();
            Res := Yellis.Select('select id from clients where clt_guid = ' + QuotedStr(FGUID) + ';');
            Yellis.ordre('Update clients set bckok = "' + Yellis.DateTime(DateFinBck) + '", dernbck = "' + Yellis.DateTime(DateFinBck) + '", resbck = "Pas de prob", dernbckok = 1 where id=' + Yellis.UneValeur(Res, 'id'));
            Result := true;
          finally
            Yellis.FreeResult(Res);
            FreeAndNil(Yellis);
          end;
        end
        else
        begin
          // recup du ID Base
          Query.SQL.Text := 'select bas_id from genbases where bas_ident = ' + QuotedStr(IntToStr(FGenerateur)) + ';';;
          try
            Query.Open();
            if Query.Eof then
              Raise Exception.Create('Identifiant de base non trouvé.')
            else
              IdBase := Query.FieldByName('bas_id').AsInteger;
          finally
            Query.Close();
          end;

          // Recup des 'enreg de backup
          Query.SQL.Text := 'select dos_string from gendossier where dos_nom = ' + QuotedStr('B-' + IntToStr(IdBase)) + ' and dos_float = 1;';
          try
            Query.Open();
            if Query.Eof then
              Raise Exception.Create('Dernier backup reussit non trouvé.')
            else
              ResBck := Query.FieldByName('dos_string').AsString
          finally
            Query.Close();
          end;

          // Mise a jour de Yellis
          try
            Yellis := Tconnexion.Create();
            Res := Yellis.Select('select id from clients where clt_guid = ' + QuotedStr(FGUID) + ';');
            case State of
              // 0 n'est pas ici ...
              3 :
                Yellis.ordre('Update clients set bckok = "' + Yellis.DateTime(Strtodatetime(Copy(ResBck, 1, Pos('-', ResBck) -2))) + '", dernbck = "' + Yellis.DateTime(DateFinBck) + '", resbck = "Pas de place", dernbckok = 0 where id=' + Yellis.UneValeur(Res, 'id'));
              8, 9, 10 :
                Yellis.ordre('Update clients set bckok = "' + Yellis.DateTime(Strtodatetime(Copy(ResBck, 1, Pos('-', ResBck) -2))) + '", dernbck = "' + Yellis.DateTime(DateFinBck) + '", resbck = "Pas de restore", dernbckok = 0 where id=' + Yellis.UneValeur(Res, 'id'));
              11 :
                Yellis.ordre('Update clients set bckok = "' + Yellis.DateTime(Strtodatetime(Copy(ResBck, 1, Pos('-', ResBck) -2))) + '", dernbck = "' + Yellis.DateTime(DateFinBck) + '", resbck = "Restore OK mais base mauvaise", dernbckok = 0 where id=' + Yellis.UneValeur(Res, 'id'));
              else
                Yellis.ordre('Update clients set bckok = "' + Yellis.DateTime(Strtodatetime(Copy(ResBck, 1, Pos('-', ResBck) -2))) + '", dernbck = "' + Yellis.DateTime(DateFinBck) + '", resbck = "Pas de backup", dernbckok = 0 where id=' + Yellis.UneValeur(Res, 'id'));
            end;
            Result := true;
          finally
            Yellis.FreeResult(Res);
            FreeAndNil(Yellis);
          end;
        end;
      finally
        FreeAndNil(Query);
        FreeAndNil(Connexion);
      end;
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

procedure TGinBackRestThread.Execute();
// code de retour :
//  0 - reussite
//  1 - pas de GUID
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
  DateFinBck : TDateTime;
begin
  if not (Trim(FGUID) = '') then
  begin
    Inherited Execute();

    // MAJ !
    DoLog('/******************************************************************************/');
    DoLog('Marquage de la mise-à-jour');
    DoLog('');
    DateFinBck := Now();
    DoMajBase(ReturnValue, DateFinBck);
    DoMajYellis(ReturnValue, DateFinBck);
  end
  else
    ReturnValue := 1;
end;

constructor TGinBackRestThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Nom, GUID : string; Generateur : integer; DoMaj : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, DoValidate, PageBuffers, DoContinue, Progress, StepLbl, CreateSuspended);
  FNom := Nom;
  FGUID := GUID;
  FGenerateur := Generateur;
  FDoMaj := DoMaj;
end;

{ TGinRestoreIntoBaseThread }

procedure TGinRestoreIntoBaseThread.Execute();
// code de retour :
//  0 - reussite
//  1 - Erreur de fichier
//  2 - pas de GUID
//  3 - Pas assez d'espace
//  4 - Shutdown de base
//  5 - Erreur lors du dézippage
//  6 - Erreur de restauration
//  7 - GFix
//  8 - Erreur lors de la vérification de la restauration
//  9 - Erreur lors de la recup des infos base
// 10 - Pas la même base !!!!!!
// 11 - Erreur de validation
// 12 - Restart de base
// 13 - Exception
// 14 - Autre erreur
var
  Verif : TDataBaseVerif;
  ResVerif : TStringList;
  OldName, NewName, DestPath : string;
  FileExt, SvgName, VrfName : string;
  FileSize : int64;
  RetFind : integer;
  FindStruc : TSearchRec;
  Version, nom, GUID, BasSender : string;
  DateVersion : TDateTime;
  Generateur : integer;
  Recalcul : boolean;
  DateFinBck : TDateTime;
  error : string;
begin
  ReturnValue := 14;
  ProgressStyle(pbstMarquee);
  OldName := ChangeFileExt(FDataBase, '.OLD');
  NewName := ChangeFileExt(FDataBase, '.NEW');
  FileExt := '';
  SvgName := '';
  VrfName := '';

  try
    CoInitialize(nil);
    if FileExists(FDataBase) and FileExists(FBackupFile) then
    begin
      if not (Trim(FGUID) = '') then
      begin
        if FileExists(OldName) then
          DeleteFile(OldName);
        if FileExists(NewName) then
          DeleteFile(NewName);

        try
          ProgressInit(10);

          try
            DestPath := GetTempDirectory(ExtractFilePath(FDataBase));
            ForceDirectories(DestPath);

            // recherche de la taille...
            FileSize := GetFileSize(FDataBase);

            // verification de taille !
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Vérification de l''espace disque...');
            DoLog('');
            if CharInSet(ExtractFileDrive(FDataBase)[1], ['A'..'Z', 'a'..'z']) then
            begin
              if (GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1]) < (FileSize * 2)) then
              begin
                DoLog('Disque : ' + ExtractFileDrive(FDataBase)[1]);
                DoLog('  -> espace dispo : ' + IntToStr(GetDiskFreeSpace(ExtractFileDrive(FDataBase)[1])));
                DoLog('  -> espace voulu : ' + IntToStr(Trunc(FileSize * 2.0)));
                ReturnValue := 3;
                Exit;
              end;
            end
            else
              DoLog('  -> sur le réseau, on ne vérifie pas...');
            ProgressStepIt();

            try
              // shutdown
              DoLog('/******************************************************************************/');
              ProgressStepLbl('Shutdown de la base...');
              DoLog('');
              if not DoActivation(false) then
              begin
                ReturnValue := 4;
                Exit;
              end;
              ProgressStepIt();

              try
                // renommage du fichier
                DoLog('/******************************************************************************/');
                ProgressStepLbl('renommage du fichier');
                DoLog('');
                MoveFile(PWideChar(FDataBase), PWideChar(OldName));
                ProgressStepIt();

                // Gestion du Zip ou pas !
                DoLog('/******************************************************************************/');
                ProgressStepLbl('Décompression/Copie');
                DoLog('');
                FileExt := UpperCase(ExtractFileExt(FBackupFile));
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
                else if (FileExt = '.7Z') or (FileExt = '.ZIP') then
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
                      findClose(FindStruc);
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

                // vérification bis
                DoLog('/******************************************************************************/');
                ProgressStepLbl('Recupération des informations base');
                DoLog('');
                if not GetInfosBase(FServeur, NewName, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, Version, Nom, GUID, BasSender, DateVersion, Generateur, Recalcul, error) then
                begin
                  ReturnValue := 9;
                  Exit;
                end
                else if (Nom <> FNom) or (GUID <> FGUID) then
                begin
                  ReturnValue := 10;
                  Exit;
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
                begin
                  DeleteFile(OldName);
                  MoveFile(PWideChar(NewName), PWideChar(FDataBase));
                end
                else
                begin
                  DeleteFile(NewName);
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
                  ReturnValue := 12;
              ProgressStepIt();
            end;

            // MAJ !
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Marquage de la mise-à-jour');
            DoLog('');
            DateFinBck := Now();
            DoMajBase(ReturnValue, DateFinBck);
            DoMajYellis(ReturnValue, DateFinBck);
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
        ReturnValue := 2;
    end
    else
      ReturnValue := 1;
  finally
    CoUninitialize();
  end;
end;

constructor TGinRestoreIntoBaseThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; UseVerifFile : boolean; BackupFile, Nom, GUID : string; Generateur : integer; DoMaj : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Nom, GUID, Generateur, DoMaj, DoValidate, PageBuffers, DoContinue, Progress, StepLbl, CreateSuspended);
  FBackupFile := BackupFile;
  FUseVerifFile := UseVerifFile;
end;

function TGinRestoreIntoBaseThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
     0 : Result := 'Traitement effectué correctement.';
     1 : Result := 'Fichier non trouvé.';
     2 : Result := 'GUID non trouvé.';
     3 : Result := 'Pas assez de place (base * 2 + sur C).';
     4 : Result := 'Erreur lors du shutdown de la base.';
     5 : Result := 'Erreur lors du dézippage/copy de la sauvegarde';
     6 : Result := 'Erreur lors de la restauration.';
     7 : Result := 'Erreur lors du GFix de la base.';
     8 : Result := 'Vérification non conforme.';
     9 : Result := 'Erreur lors de la recup des infos base.';
    10 : Result := 'Pas la même base !!!!.';
    11 : Result := 'Erreur lors de la validation de la base.';
    12 : Result := 'Erreur lors du restart de la base.';
    13 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

{ TGinCreateFromBackupThread }

procedure TGinCreateFromBackupThread.Execute();
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
//  9 - Erreur lors de la recup des infos base
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
  Version, BasSender : string;
  DateVersion : TDateTime;
  Recalcul : boolean;
  DateFinBck : TDateTime;
  error : string;
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
        DeleteFile(FDataBase);
      if FileExists(NewName) then
        DeleteFile(NewName);

      try
        ProgressInit(8);

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
                findClose(FindStruc);
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

            // vérification bis
            DoLog('/******************************************************************************/');
            ProgressStepLbl('Recupération des informations base');
            DoLog('');
            if not GetInfosBase(FServeur, NewName, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, Version, FNom, FGUID, BasSender, DateVersion, FGenerateur, Recalcul, error) then
            begin
              ReturnValue := 9;
              Exit;
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
              DeleteFile(NewName);
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

          // MAJ !
          DoLog('/******************************************************************************/');
          ProgressStepLbl('Marquage de la mise-à-jour');
          DoLog('');
          DateFinBck := Now();
          DoMajBase(ReturnValue, DateFinBck);
          DoMajYellis(ReturnValue, DateFinBck);
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

constructor TGinCreateFromBackupThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; UseVerifFile : boolean; BackupFile : string; DoMaj : boolean; DoValidate: boolean; PageBuffers : cardinal; DoContinue : TAskReply; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, '', '', -1, DoMaj, DoValidate, PageBuffers, DoContinue, Progress, StepLbl, CreateSuspended);
  FBackupFile := BackupFile;
  FUseVerifFile := UseVerifFile;
end;

function TGinCreateFromBackupThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
     0 : Result := 'Traitement effectué correctement.';
     1 : Result := 'Fichier non trouvé.';
     2 : Result := 'Pas assez de place (svg * X + sur C).';
     3 : Result := 'Erreur lors du dézippage/copy de la sauvegarde';
     4 : Result := 'Erreur lors de la restauration.';
     5 : Result := 'Erreur lors du GFix de la base.';
     6 : Result := 'Vérification non conforme.';
     7 : Result := 'Erreur lors de la validation de la base.';
     8 : Result := 'Erreur lors de la recup des infos base.';
     9 : Result := 'Erreur lors du restart de la base.';
    10 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

end.
