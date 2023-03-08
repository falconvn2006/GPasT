UNIT Unit_geneBackup;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db,
  //rxfileUtil,
  //Uses Perso
  registry,
  //Fin Uses Perso
  dxmdaset, VCLUnZip, VCLZip, IBDatabaseInfo, IBCustomDataSet, ScktComp, IBQuery,
  IBDatabase, ExtCtrls, uBackup;

TYPE
  TOnFait = PROCEDURE(Sender: TObject; S: STRING) OF OBJECT;
  TDm_BckGene = CLASS(TDataModule)
    Timer1: TTimer;
    Qry: TIBQuery;
    tran: TIBTransaction;
    Database: TIBDatabase;
    Client: TClientSocket;
    qry_tables: TIBQuery;
    Ib_LesBases: TIBQuery;
    Ib_LesBasesREP_PLACEEAI: TIBStringField;
    Ib_LesBasesREP_PLACEBASE: TIBStringField;
    IBDatabaseInfo: TIBDatabaseInfo;
    zip: TVCLZip;
    MemD_BasesTraite: TdxMemData;
    MemD_BasesTraiteCHEMIN: TStringField;
    MemD_BasesTraiteDATE: TDateTimeField;
    PROCEDURE DataModuleCreate(Sender: TObject);
    PROCEDURE DataModuleDestroy(Sender: TObject);
  PRIVATE
    fOnFait: TOnFait;
    FNomMachine: STRING;
    { Déclarations privées }
    FUNCTION MarqueLesTables(NomDeBase: STRING): Boolean;
    PROCEDURE ArretBase(NomDeBase: STRING);
    PROCEDURE ArretBaseSeul(NomDeBase: STRING);
    PROCEDURE DemareBase(NomDeBase: STRING);
    PROCEDURE delete123;
//    FUNCTION Backup(NomDeBase: STRING): Boolean;
    FUNCTION RenomeBase(NomDeBase: STRING): Boolean;
    FUNCTION RenomeBaseEx(NomDeBase, NouveauNom: STRING): Boolean;
//    FUNCTION Restore(NomDeBase: STRING): boolean;
    FUNCTION VerifBase(NomDeBase: STRING): Boolean;
    PROCEDURE ValideNvBck(NomDeBase: STRING);
    FUNCTION NouvelleSauvegarde(NomDeBase: STRING): STRING;
    PROCEDURE marqueBase(OK: Boolean; tipe: Integer; NomDeBase: STRING);
    PROCEDURE OptimiseBase(NomDeBase: STRING);
    PROCEDURE recupAncBase(NomDeBase: STRING);
    PROCEDURE SetfOnFait(CONST Value: TOnFait);
    FUNCTION GetNomMachine: STRING;
    FUNCTION usersConnected(NomDeBase: STRING): Integer;
    PROCEDURE zipperBase(NomDeBase,NomBaseOrigine: STRING; Use7z : boolean = false);
    procedure SetSQL_qry_tables(const MajorVersion: Word);
  PUBLIC
    { Déclarations publiques }
    PathBorlBin: STRING;
    un, deux, trois: STRING;
    Path: STRING;
    log: TStringList;
    logIncident: TStringList;
    pathLogIncident: STRING;
    PathLogBasesTraite: STRING;
    function CheckReadOnlyFile(FileName : String) : Boolean;
    PROCEDURE Arret_IIS;
    PROCEDURE Lance_IIS;
    FUNCTION Sauvegarde(NomDeBase: STRING; ABufferSize : Integer = 0;APageSize : Integer = 0; ASweepVal : Integer = 0): Boolean;
    FUNCTION formatMessage(sMessage: STRING): STRING;
    PROCEDURE DoFait(S: STRING);
    PROPERTY OnFait: TOnFait READ fOnFait WRITE SetfOnFait;
    PROPERTY NomMachine: STRING READ GetNomMachine;
  END;

VAR
  Dm_BckGene: TDm_BckGene;

IMPLEMENTATION

Uses
  Unit_Backup,
  uSevenZip;

{$R *.DFM}

FUNCTION PlaceDeInterbase: STRING;
VAR
  Reg: Tregistry;
BEGIN
  reg := Tregistry.Create;
  TRY
    reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    IF trim(result) = '' THEN
    BEGIN
      Reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db', False);
      result := Reg.ReadString('ServerDirectory');
    END;
    result := IncludeTrailingPathDelimiter(Reg.ReadString('ServerDirectory'));
  FINALLY
    reg.free;
  END;
END;

FUNCTION TDm_BckGene.Sauvegarde(NomDeBase: STRING; ABufferSize : Integer = 0;APageSize : Integer = 0; ASweepVal : Integer = 0): Boolean;
VAR
  PathLog: STRING;
  bRenomme: boolean;
  sNomBaseOrigine : String;
BEGIN
  TRY
    DoFait('Initialisation');
    PathBorlBin := PlaceDeInterbase;
    result := false;
    Log := TStringList.Create;
    PathLog := IncludeTrailingBackslash(ExtractFilePath(NomDebase)) + 'BackupRestor.log';
    Path := IncludeTrailingBackslash(ExtractFilePath(NomDebase));
    IF fileexists(NomDeBase) THEN
    BEGIN
      IF NOT Fileexists(ExtractFilePath(NomDebase) +'GinkBackUpPantin.ib') THEN
      BEGIN
        Log.Add(DateTimeToStr(Now) + '  Début sauvegarde ' + NomDeBase);
        Log.SaveToFile(PathLog);
        // suppression de l'ancienne tentative de restore ...
        if FileExists(ExtractFilePath(NomDebase) +'Gink.ib') then
          DeleteFile(ExtractFilePath(NomDebase) +'Gink.ib');
        //vérifier le nombre de user connectés pour s'assurer que nous sommes les seuls à travailler avec cette base
        Log.Add(DateTimeToStr(Now) + '  Contrôle des connections à la base ');
        log.SaveToFile(Pathlog);
        DoFait('Contrôle des connections à la base');
        sNomBaseOrigine := ExtractFileName(NomDeBase);
        IF usersConnected(NomDeBase) = 0 THEN
        BEGIN
          Log.Add(DateTimeToStr(Now) + '  Arrêt de la base ');
          log.SaveToFile(Pathlog);
          DoFait('Arret de la base');
          TRY
            ArretBaseSeul(NomDeBase);
            Log.Add(DateTimeToStr(Now) + '  Renomage de la base ');
            log.SaveToFile(Pathlog);
            DoFait('Renomage de la base');
            IF RenomeBaseEx(NomDeBase, Path + 'GinkBackUpPantin.ib') THEN
            BEGIN
              NomdeBase := Path + 'GinkBackUpPantin.ib';
              Log.Add(DateTimeToStr(Now) + '  Rollback transactions et Arrêt de la base ');
              log.SaveToFile(Pathlog);
              DoFait('Rollback transactions et Arrêt de la base');
              ArretBase(NomDeBase);
              Log.Add(DateTimeToStr(Now) + '  Marque les tables ');
              Log.SaveToFile(PathLog);
              DoFait('Marquage des tables');
              IF MarqueLesTables(NomDeBase) THEN
              BEGIN
                Log.Add(DateTimeToStr(Now) + '  Backup de la base ');
                log.SaveToFile(Pathlog);
                DoFait('Backup de la base');
                try
                  IF Backup(NomDeBase,ExtractFilePath(NomDeBase) + 'SV.GBK',Nil,False,'LocalHost',ABufferSize) THEN
                  BEGIN
                    NomdeBase := Path + 'Gink.ib';
                    Log.Add(DateTimeToStr(Now) + '  Restauration de la base ');
                    log.SaveToFile(Pathlog);
                    DoFait('Restore de la base');
                    IF RestoreGBak(PathBorlBin, NomDeBase,ExtractFilePath(NomDeBase) + 'SV.GBK',APageSize,ABufferSize,ASweepVal) THEN
                    BEGIN
                      DoFait('Verification de la base');
                      IF VerifBase(NomDeBase) THEN
                      BEGIN
                        DoFait('Optimisation de la base');
                        OptimiseBase(NomDeBase);
                        DoFait('Marquage de la base');
                        marqueBase(true, 0, NomDeBase);
                        DoFait('Zippage de la base');
                        zipperBase(NomDeBase, sNomBaseOrigine, FileExists(ExtractFilePath(ParamStr(0)) + '7z.dll'));
                        result := true;
                      END
                      ELSE
                      BEGIN
                        Log.Add(DateTimeToStr(Now) + '  Base mal restaurée ');
                        log.SaveToFile(Pathlog);
                        DoFait('récupération de l''ancienne base');
                        //recupAncBase(NomDeBase);
                        DoFait('marquage de la base');
                        marqueBase(False, 2, NomDeBase);
                      END;
                    END
                    ELSE
                    BEGIN
                      Log.Add(DateTimeToStr(Now) + '  Restauration planté ');
                      log.SaveToFile(Pathlog);
                      DoFait('récupération de l''ancienne  base');
                      //recupAncBase(NomDeBase);
                      DoFait('Marquage de la base');
                      marqueBase(False, 3, NomDeBase);
                    END;
                  END
                  ELSE
                  BEGIN
                    Log.Add(DateTimeToStr(Now) + '  Backup pas OK ');
                    log.SaveToFile(Pathlog);
                    DoFait('marquage de la base ');
                    marqueBase(False, 4, NomDeBase);
                  END;
                finally
                  // dans tous les cas ici, on supprime le fichier GBK
                  IF fileexists(Path + sNomBaseOrigine) THEN
                    deletefile(Path + 'SV.GBK');
                end;
              END
              ELSE
              BEGIN
                Log.Add(DateTimeToStr(Now) + '  Ne peut même pas marquer les tables ');
                log.SaveToFile(Pathlog);
              END;
            END;
          FINALLY
            //si ginkoia n'existe pas, il y a eu un problème : revenir à la version d'avant :
            //renommer ginkBackUpPantin.ib en Ginkoia.ib et redémarrer la base
            bRenomme := true;
            IF NOT FileExists(Path + sNomBaseOrigine) THEN
            BEGIN
              IF NOT RenomeBaseEx(Path + 'GinkBackUpPantin.ib', Path + sNomBaseOrigine) THEN
              BEGIN
                bRenomme := false;
              END;
            END;
            DoFait('Demarrage de la base');
            DemareBase(Path + 'Ginkoia');
            //effacer la base ginkBackUpPantin sauf si ginkoia n'existe pas et qu'on ne peut pas renommer ginkBackUpPantin.ib en ginkoia.ib
            IF FileExists(Path + 'GinkBackUpPantin.ib') AND bRenomme THEN
              deletefile(Path + 'GinkBackUpPantin.ib');
          END;
        END
        ELSE
        BEGIN
          Log.Add(DateTimeToStr(Now) + '  Back up abandonné car user connecté ou problème de connection ');
          log.SaveToFile(Pathlog);
        END;
        log.SaveToFile(Pathlog);
        IF result THEN
        BEGIN
          Log.Add(DateTimeToStr(Now) + '  Backup/restore OK ');
          log.SaveToFile(Pathlog);
        END;
      END
      ELSE
      BEGIN
        LogIncident.Add(DateTimeToStr(Now) + #9 + 'Un Fichier ginkBackUpPantin.ib existe' + #9 + 'LOCALISATION BASE' + #9 + copy(NomDeBase, 1, 127));
        LogIncident.saveToFile(PathLogIncident);
      END;
    END
    ELSE
    BEGIN
      LogIncident.Add(DateTimeToStr(Now) + #9 + 'Base non trouvée ' + #9 + 'LOCALISATION BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  FINALLY
    log.free;
  END;
END;

PROCEDURE TDm_BckGene.Arret_IIS;
BEGIN
  Winexec('IISRESET /STOP', 0);
  Sleep(15000);
END;

PROCEDURE TDm_BckGene.Lance_IIS;
BEGIN
  Winexec('IISRESET /START', 0);
  Sleep(15000);
END;

PROCEDURE TDm_BckGene.ArretBase(NomDeBase: STRING);
VAR
  tsl: tstringlist;
  i: integer;
  debut: TDateTime;
BEGIN
  TRY
    tsl := tstringlist.Create;
    TRY
      delete123;
      tsl.add('"' + PathBorlBin + 'gfix.exe" -rollback all "' + NomDeBase + '" -user sysdba -password masterkey ');
      tsl.add('"' + PathBorlBin + 'gfix.exe" -shut -force 0 -user sysdba -password masterkey "' + NomDeBase + '" ');
      tsl.add('Dir c:\*.* > "' + un + '"');
      tsl.add('exit ');
      tsl.savetofile(Path + 'go.bat');
      IF Winexec(Pchar(Path + 'GO.BAT'), 0) <= 31 THEN
      BEGIN
        exit;
      END;
      FOR i := 1 TO 15 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
      debut := now;
      WHILE NOT fileexists(Un) DO
      BEGIN
        IF (Now - debut) > 0.2 THEN
        BEGIN
          Exit;
        END;
        application.processmessages;
        sleep(100);
      END;

      FOR i := 1 TO 15 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
    FINALLY
      tsl.free;
      // suppression des fichiers !
      delete123;
      DeleteFile(Path + 'go.bat');
    END;
  EXCEPT ON Stan: Exception DO
    BEGIN
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'ARRET / ROLLBACK BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
END;

PROCEDURE TDm_BckGene.ArretBaseSeul(NomDeBase: STRING);
VAR
  tsl: tstringlist;
  i: integer;
  debut: TDateTime;
BEGIN
  TRY
    tsl := tstringlist.Create;
    TRY
      delete123;
      tsl.add('"' + PathBorlBin + 'gfix.exe" -shut -force 0 -user sysdba -password masterkey "' + NomDeBase + '" ');
      tsl.add('Dir c:\*.* > "' + un + '"');
      tsl.add('exit ');
      tsl.savetofile(Path + 'go.bat');
      IF Winexec(Pchar(Path + 'GO.BAT'), 0) <= 31 THEN
      BEGIN
        exit;
      END;
      FOR i := 1 TO 15 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
      debut := now;
      WHILE NOT fileexists(Un) DO
      BEGIN
        IF (Now - debut) > 0.2 THEN
        BEGIN
          Exit;
        END;
        application.processmessages;
        sleep(100);
      END;

      FOR i := 1 TO 15 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
    FINALLY
      tsl.free;
      // suppression des fichiers !
      delete123;
      DeleteFile(Path + 'go.bat');
    END;
  EXCEPT ON Stan: Exception DO
    BEGIN
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'ARRET BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
END;

PROCEDURE TDm_BckGene.delete123;
VAR
  i: integer;
BEGIN
  TRY
    deletefile(Path + 'Un.txt');
    IF Fileexists(Path + 'Un.txt') THEN
    BEGIN
      i := 0;
      REPEAT
        inc(i);
        Un := Path + 'Un' + Inttostr(i) + '.txt';
        deletefile(Un);
      UNTIL NOT Fileexists(Un);
    END
    ELSE Un := Path + 'Un.txt'
  EXCEPT
  END;
  TRY
    deletefile(Path + 'Deux.txt');
    IF Fileexists(Path + 'Deux.txt') THEN
    BEGIN
      i := 0;
      REPEAT
        inc(i);
        Deux := Path + 'Deux' + Inttostr(i) + '.txt';
        deletefile(Deux);
      UNTIL NOT Fileexists(Deux);
    END
    ELSE Deux := Path + 'Deux.txt'
  EXCEPT
  END;
  TRY
    deletefile(Path + 'Trois.txt');
    IF Fileexists(Path + 'Trois.txt') THEN
    BEGIN
      i := 0;
      REPEAT
        inc(i);
        Trois := Path + 'Trois' + Inttostr(i) + '.txt';
        deletefile(Trois);
      UNTIL NOT Fileexists(Trois);
    END
    ELSE Trois := Path + 'Trois.txt'
  EXCEPT
  END;
END;

PROCEDURE TDm_BckGene.DemareBase(NomDeBase: STRING);
VAR
  tsl: tstringlist;
  i: integer;
  debut: TDateTime;
BEGIN
  TRY
    tsl := tstringlist.Create;
    TRY
      delete123;
      tsl.add('"' + PathBorlBin + 'gfix.exe" -online -user sysdba -password masterkey "' + NomDeBase + '" ');
      tsl.add('Dir c:\*.* > "' + Un + '"');
      tsl.add('exit ');
      tsl.savetofile(Path + 'go.bat');
      IF Winexec(Pchar(Path + 'GO.BAT'), 0) <= 31 THEN
        exit;
      FOR i := 1 TO 30 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
      debut := now;
      WHILE NOT fileexists(Un) DO
      BEGIN
        IF Now - debut > 0.05 THEN
        BEGIN
          Break;
        END;
        application.processmessages;
        sleep(100);
      END;
      FOR i := 1 TO 30 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
    FINALLY
      tsl.free;
      // suppression des fichiers !
      delete123;
      DeleteFile(Path + 'go.bat');
    END;
  EXCEPT ON Stan: Exception DO
    BEGIN
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'DEMARRAGE BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
END;

//FUNCTION TDm_BckGene.Backup(NomDeBase: STRING): Boolean;
//VAR
//  tsl: tstringlist;
//  i: integer;
//  debut: TDateTime;
//BEGIN
//  IF fileexists(NomDeBase) THEN
//  BEGIN
//    TRY
//      deletefile(Path + 'SV.gbk');
//      tsl := tstringlist.Create;
//      TRY
//        delete123;
//        tsl.add('"' + PathBorlBin + 'gbak.exe " "' + NomDeBase + '" "' + Path + 'SV.GBK" -user sysdba -password masterkey -B -L -NT -Y "' + un + '"');
//        tsl.add('Copy "' + un + '" "' + trois + '"');
//        tsl.add('exit');
//        tsl.SaveToFile(Path + 'GO.BAT');
//
//        IF Winexec(Pchar(Path + 'GO.BAT'), 0) <= 31 THEN
//        BEGIN
//          result := false;
//          exit;
//        END;
//        FOR i := 1 TO 30 DO
//        BEGIN
//          application.processmessages;
//          sleep(100);
//        END;
//        debut := Now;
//        WHILE NOT fileexists(trois) DO
//        BEGIN
//          application.processmessages;
//          sleep(100);
//          IF Now - debut > 0.1 THEN
//          BEGIN
//            result := False;
//            Exit;
//          END;
//        END;
//
//        FOR i := 1 TO 25 DO
//        BEGIN
//          application.processmessages;
//          sleep(100);
//        END;
//
//        tsl.loadfromfile(trois);
//        IF tsl.count > 1 THEN
//        BEGIN
//          result := false;
//          tsl.Savetofile(Path + 'prob.txt');
//        END
//        ELSE
//        BEGIN
//          result := true;
//        END;
//
//      FINALLY
//        tsl.free;
//      END;
//    EXCEPT ON Stan: Exception DO
//      BEGIN
//        result := false;
//        LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'BACK UP BASE' + #9 + copy(NomDeBase, 1, 127));
//        LogIncident.saveToFile(PathLogIncident);
//      END;
//    END;
//  END
//  ELSE
//  BEGIN
//    result := false;
//  END;
//END;

FUNCTION TDm_BckGene.RenomeBase(NomDeBase: STRING): Boolean;
BEGIN
  TRY
    IF fileexists(NomDeBase) THEN
    BEGIN
      result := renamefile(NomDeBase, ChangeFileExt(NomDeBase, '.Old'));
    END
    ELSE
      result := false;
  EXCEPT ON Stan: Exception DO
    BEGIN
      result := false;
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'RENOMMAGE BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
END;

FUNCTION TDm_BckGene.RenomeBaseEx(NomDeBase, NouveauNom: STRING): Boolean;
BEGIN
  // fonction qui renomme la base NomDeBase en NouveauNom
  TRY
    IF fileexists(NomDeBase) THEN
    BEGIN
      result := renamefile(NomDeBase, NouveauNom);
    END
    ELSE
      result := false;
  EXCEPT ON Stan: Exception DO
    BEGIN
      result := false;
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'RENOMMAGE BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
END;

FUNCTION TDm_BckGene.VerifBase(NomDeBase: STRING): Boolean;
VAR
  li, lli: Integer;
  MajorVersion: Word;
BEGIN
  result := true;
  TRY
    GetDBVersionMajor( NomDeBase, MajorVersion );
    database.Close;
    database.DatabaseName := NomDeBase;
    SetSQL_qry_tables( MajorVersion );
    qry_tables.open;
    qry_tables.first;
    li := 0;
    WHILE NOT qry_tables.eof DO
    BEGIN
      Qry.sql.text := 'Select count(*) from ' + qry_tables.Fields[0].AsString;
      Qry.Open;
      lli := Qry.Fields[0].AsInteger;
      Qry.Close;

      if MajorVersion > 13 then
        Qry.SQL.Text := Format( 'select TBR_FIELDSCOUNT from TMPBACKUPRESTORE where TBR_ID = %d', [ li ] )
      else
        Qry.SQL.Text := Format( 'select TMP_ARTID from TMPSTAT where TMP_ID = 0 and TMP_MAGID = %d', [ li ] );
      Qry.Open;
      IF lli <> Qry.fields[0].AsInteger THEN
      BEGIN
        Log.Add(DateTimeToStr(Now) + '  Table ' + qry_tables.Fields[0].AsString + ' Diff ');
        database.Connected := false;
        result := false;
        Break;
      END;
      Qry.Close;
      inc(li);
      qry_tables.next;
    END;
  EXCEPT ON Stan: Exception DO
    BEGIN
      result := false;
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'VERIFICATION BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
  TRY
    database.Close;
  EXCEPT
  END;
END;

procedure TDm_BckGene.zipperBase(NomDeBase, NomBaseOrigine : string; Use7z : boolean);

  function MakeZip(NomDeBase, NomBaseOrigine : string; out NomZip : string) : boolean;
  var
    nomDeDossier : string;
    i : integer;
  begin
    Result := false;

    //procedure permettant de zipper la base restorée en NomDeDossier.zip puis de renommer si tout va bien gink.ib en ginkoia.ib
    TRY
      nomDeDossier := NomDeBase;
      i := Pos('\DATA\', uppercase(nomDeDossier));
      //récupèrer la partie avant
      nomDeDossier := Copy(nomDeDossier, 1, i - 1);
      //localiser le dernier '\'
      i := LastDelimiter('\', nomDeDossier);
      nomDeDossier := Copy(nomDeDossier, i + 1, length(nomDeDossier) - i) + '.zip';
      NomZip := ExtractFilePath(NomDeBase) + nomDeDossier;
      //si un zip existe déjà, le renommer le temps du zippage
      IF FileExists(NomZip) THEN
        RenameFile(NomZip, ExtractFilePath(NomDeBase) + 'zip.old');
      zip.FilesList.Clear;
      zip.FilesList.Add(NomDeBase);
      zip.ZipName := NomZip;
      Zip.Zip;
      Result := true;
    EXCEPT ON Stan: Exception DO
      BEGIN
        LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'ZIPPAGE BASE' + #9 + copy(NomDeBase, 1, 127));
        LogIncident.saveToFile(PathLogIncident);
        //rétablir l'ancien zip
        RenameFile(ExtractFilePath(NomDeBase) + 'zip.old', NomZip);
      END;
    END;
  end;

  function Make7z(NomDeBase, NomBaseOrigine : string; out NomZip : string) : boolean;
  var
    Zip : I7zOutArchive;
    nomDeDossier : string;
    i : integer;
  begin
    Result := false;

    //procedure permettant de zipper la base restorée en NomDeDossier.zip puis de renommer si tout va bien gink.ib en ginkoia.ib
    try
      nomDeDossier := NomDeBase;
      i := Pos('\DATA\', uppercase(nomDeDossier));
      //récupèrer la partie avant
      nomDeDossier := Copy(nomDeDossier, 1, i - 1);
      //localiser le dernier '\'
      i := LastDelimiter('\', nomDeDossier);
      nomDeDossier := Copy(nomDeDossier, i + 1, length(nomDeDossier) - i) + '.7z';
      NomZip := ExtractFilePath(NomDeBase) + nomDeDossier;
      //si un zip existe déjà, le renommer le temps du zippage
      IF FileExists(NomZip) THEN
        RenameFile(NomZip, ExtractFilePath(NomDeBase) + 'zip.old');
      try
        Zip := CreateOutArchive(CLSID_CFormat7z);
        Zip.AddFiles(ExtractFilePath(NomDeBase), '', ExtractFileName(NomDeBase), false);
        Zip.SaveToFile(NomZip);
        Result := true;
      finally
        Zip := nil;
      end;
    except
      on e : Exception do
      begin
        LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(e.Message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'ZIPPAGE BASE' + #9 + copy(NomDeBase, 1, 127));
        LogIncident.saveToFile(PathLogIncident);
        //rétablir l'ancien zip
        RenameFile(ExtractFilePath(NomDeBase) + 'zip.old', NomZip);
      end;
    end;
  end;

var
  NomZip : string;
  bZippe : boolean;
begin
  //procedure permettant de zipper la base restorée en NomDeDossier.zip puis de renommer si tout va bien gink.ib en ginkoia.ib
  if Use7z then
    bZippe := Make7z(NomDeBase, NomBaseOrigine, NomZip)
  else
    bZippe := MakeZip(NomDeBase, NomBaseOrigine, NomZip);

  // renommer gink.ib en ginkoia.ib
  RenomeBaseEx(Path + 'gink.ib', Path + NomBaseOrigine);
  deletefile(Path + 'Gink.IB');
  //si le zippage c'est bien passé Ajouter la base à la liste des base à archiver
  IF bZippe THEN
  BEGIN
    TRY
      //supprimer l'ancien zip
      IF FileExists(ExtractFilePath(NomDeBase) + 'zip.old') THEN
        deleteFile(ExtractFilePath(NomDeBase) + 'zip.old');
      //rechercher la base dans le log pour mettre à jour la date de back up ou la créer
      IF MemD_BasesTraite.Locate('CHEMIN', NomZip, []) THEN
      BEGIN
        MemD_BasesTraite.edit;
        MemD_BasesTraite.FieldbyName('DATE').AsDateTime := Now;
      END
      ELSE
      BEGIN
        MemD_BasesTraite.Append();
        MemD_BasesTraite.FieldByName('CHEMIN').asString := NomZip;
      END;
      MemD_BasesTraite.FieldByName('DATE').AsDateTime := Now;
      MemD_BasesTraite.post;
    FINALLY
      if CheckReadOnlyFile(PathLogBasesTraite) then
        MemD_BasesTraite.SaveToTextFile(PathLogBasesTraite);
    END;
  END;
END;

PROCEDURE TDm_BckGene.ValideNvBck(NomDeBase: STRING);
VAR
  S: STRING;
BEGIN
  TRY
    // copier de SV.GBK
    BEGIN
      S := Path + 'SV.GBK';
      delete(s, 1, pos(':', s));
      s := Frm_BackupPt.RepSave + 'DBck\' + NomMachine + S;
      ForceDirectories(extractfilepath(s));
      copyfile(pchar(Path + 'SV.GBK'), pchar(S), False);
    END;

    renamefile(Path + 'SV.GBK', NouvelleSauvegarde(Path));
    // faire la copie ailleur ?
    IF fileexists(NomDeBase) THEN
    BEGIN
      S := Path + 'SV.GBK';
      DeleteFile(S);
      S := ChangeFileext(NomDeBase, '.Old');
      deletefile(S);
    END;
  EXCEPT ON Stan: Exception DO
    BEGIN
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'VALIDE NV BACKUP BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
END;

FUNCTION TDm_BckGene.NouvelleSauvegarde(NomDeBase: STRING): STRING;
BEGIN
  IF FileExists(Path + 'Sauve1.gbk') THEN
  BEGIN
    IF FileExists(Path + 'Sauve2.gbk') THEN
    BEGIN
      IF FileExists(Path + 'Sauve3.gbk') THEN
      BEGIN
        IF FileExists(Path + 'Sauve4.gbk') THEN
        BEGIN
          deletefile(Path + 'Sauve1.gbk');
          deletefile(Path + 'Sauve2.gbk');
          result := Path + 'Sauve1.gbk';
        END
        ELSE
        BEGIN
          result := Path + 'Sauve4.gbk';
          deletefile(Path + 'Sauve1.gbk');
        END;
      END
      ELSE
      BEGIN
        result := Path + 'Sauve3.gbk';
        deletefile(Path + 'Sauve4.gbk');
      END;
    END
    ELSE
    BEGIN
      result := Path + 'Sauve2.gbk';
      deletefile(Path + 'Sauve3.gbk');
    END;
  END
  ELSE
  BEGIN
    result := Path + 'Sauve1.gbk';
    deletefile(Path + 'Sauve2.gbk');
  END;
END;

PROCEDURE TDm_BckGene.OptimiseBase(NomDeBase: STRING);
VAR
  tsl: tstringlist;
  i: integer;
  debut: TDateTime;
BEGIN
  TRY
    tsl := tstringlist.Create;
    TRY
      delete123;
      tsl.add('"' + PathBorlBin + 'gfix.exe" -Buffers 4096 -user sysdba -password masterkey "' + NomDeBase + '" ');
      tsl.add('Dir c:\*.* > "' + Un + '"');
      tsl.add('exit ');
      tsl.savetofile(Path + 'go.bat');
      IF Winexec(Pchar(Path + 'GO.BAT'), 0) <= 31 THEN
        exit;
      FOR i := 1 TO 30 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
      debut := now;
      WHILE NOT fileexists(un) DO
      BEGIN
        IF Now - debut > 0.1 THEN
          Exit;
        application.processmessages;
        sleep(100);
      END;
      FOR i := 1 TO 30 DO
      BEGIN
        application.processmessages;
        sleep(1000);
      END;
    FINALLY
      tsl.free;
      // suppression des fichiers !
      delete123;
      DeleteFile(Path + 'go.bat');
    END;
  EXCEPT ON Stan: Exception DO
    BEGIN
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'OPTIMISATION BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
END;

PROCEDURE TDm_BckGene.marqueBase(OK: Boolean; tipe: Integer;
  NomDeBase: STRING);
VAR
  F: STRING;
  num: STRING;
  idVersion,
    id: STRING;
  empty: Boolean;
BEGIN
  TRY
    Database.Connected := false;
    Database.DatabaseName := NomDeBase;
    IF ok THEN
      F := '1'
    ELSE
      F := '0';
    Qry.Sql.Clear;
    Qry.Sql.Add('select Cast(PAR_STRING as Integer) Numero');
    Qry.Sql.Add('from genparambase');
    Qry.Sql.Add('Where PAR_NOM=''IDGENERATEUR''');
    Qry.Open;
    num := Qry.Fields[0].AsString;
    Log.Add(DateTimeToStr(Now) + ' récup de l''ID ' + num);
    Log.SaveToFile(Path + 'BackupRestor.Log');
    Qry.Close;
    Qry.Sql.Clear;
    Qry.Sql.Add('select Bas_ID');
    Qry.Sql.Add('from GenBases');
    Qry.Sql.Add('where BAS_ID<>0');
    Qry.Sql.Add('AND BAS_IDENT=''' + Num + '''');
    Qry.Open;
    num := Qry.Fields[0].AsString;
    Log.Add(DateTimeToStr(Now) + ' récup de Base ID ' + num);
    Log.SaveToFile(Path + 'BackupRestor.Log');
    Qry.Close;

    Qry.Sql.Clear;
    Qry.Sql.Add('Select DOS_ID ');
    Qry.Sql.Add('from GenDossier ');
    Qry.Sql.Add('Where DOS_NOM = ''B-' + NUM + '''');
    Qry.Sql.Add('  And DOS_FLOAT = ' + f);
    Qry.Open;
    empty := Qry.IsEmpty;
    IF NOT Empty THEN
    BEGIN
      Id := Qry.Fields[0].AsString;
    END;
    Qry.Close;
    Qry.Sql.Clear;
    Qry.Sql.Add('Select NewKey ');
    Qry.Sql.Add('From PROC_NEWKEY');
    Qry.Open;
    IF empty THEN
    BEGIN
      Id := Qry.Fields[0].AsString;
      IdVersion := Id;
    END
    ELSE
      IdVersion := Qry.Fields[0].AsString;
    Qry.Close;

    IF empty THEN
    BEGIN
      Log.Add(DateTimeToStr(Now) + ' Création de l''enregistrement ' + Id);
      Log.SaveToFile(Path + 'BackupRestor.Log');
      Qry.Sql.Clear;
      Qry.Sql.Add('Insert Into GenDossier');
      Qry.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING, DOS_FLOAT)');
      Qry.Sql.Add('VALUES (');
      Qry.Sql.Add(Id + ',''B-' + Num + ''',''' + DateTimeToStr(now) + ' ' + Inttostr(tipe) + ''',' + f);
      Qry.Sql.Add(')');
      Qry.ExecSQL;
      Qry.Sql.Clear;
      Qry.Sql.Add('Insert Into K');
      Qry.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
      Qry.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID )');
      Qry.Sql.Add('VALUES (');
      Qry.Sql.Add(ID + ',-101,-11111338,' + IdVersion + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
      Qry.ExecSQL;
      IF Qry.Transaction.InTransaction THEN
        Qry.Transaction.commit;
    END
    ELSE
    BEGIN
      Log.Add(DateTimeToStr(Now) + ' Modification de l''enregistrement ' + Id);
      Log.SaveToFile(Path + 'BackupRestor.Log');
      Qry.Sql.Clear;
      Qry.Sql.Add('Update GenDossier');
      Qry.Sql.Add('SET DOS_STRING = ''' + DateTimeToStr(now) + ' - ' + Inttostr(tipe) + ''', DOS_FLOAT=' + f);
      Qry.Sql.Add('Where DOS_ID=' + id);
      Qry.ExecSQL;
      Qry.Sql.Clear;
      Qry.Sql.Add('Update K');
      Qry.Sql.Add('SET K_Version = ' + IdVersion);
      Qry.Sql.Add('Where K_ID=' + id);
      Qry.ExecSQL;
      IF Qry.Transaction.InTransaction THEN
        Qry.Transaction.commit;
    END;
    Database.Connected := False;
  EXCEPT ON Stan: Exception DO
    BEGIN
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'MARQUAGE BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
      Log.Add(DateTimeToStr(Now) + ' Problème de connexion à la base ');
      OK := false;
    END;
  END;
END;

PROCEDURE TDm_BckGene.recupAncBase(NomDeBase: STRING);
BEGIN
  TRY
    IF FileExists(ChangeFileExt(NomDeBase, '.Old')) THEN
    BEGIN
      DeleteFile(Path + 'SV.GBK');
      deletefile(NomDeBase);
      renamefile(ChangeFileExt(NomDeBase, '.Old'), NomDeBase);
    END
  EXCEPT ON Stan: Exception DO
    BEGIN
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'RECUPERATION ANCIENNE BASE' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
END;

PROCEDURE TDm_BckGene.SetfOnFait(CONST Value: TOnFait);
BEGIN
  fOnFait := Value;
END;

procedure TDm_BckGene.SetSQL_qry_tables(const MajorVersion: Word);
begin
  if qry_tables.Active then
    qry_tables.Close;

  qry_tables.SQL.Clear;
  qry_tables.SQL.Add('select RDB$RELATION_NAME nom');
  qry_tables.SQL.Add('from RDB$RELATIONS');
  qry_tables.SQL.Add('where RDB$FLAGS = 1'); // 1 = persistent & no system
  if MajorVersion > 13 then
    qry_tables.SQL.Add('and RDB$RELATION_NAME <> ''TMPBACKUPRESTORE''')
  else
    qry_tables.SQL.Add('and RDB$RELATION_NAME <> ''TMPSTAT''');
  qry_tables.SQL.Add('order by 1');
end;

FUNCTION TDm_BckGene.MarqueLesTables(NomDeBase: STRING): Boolean;
VAR
  S: STRING;
  li: Integer;
  MajorVersion: Word;
BEGIN
  TRY
    GetDBVersionMajor( NomDeBase, MajorVersion );

    DataBase.Close;
    DataBase.DataBaseName := NomDeBase;
    DataBase.Open;
    Tran.active := true;
    result := true;
    if MajorVersion > 13 then
      Qry.SQL.Text := 'delete from TMPBACKUPRESTORE'
    else
      Qry.SQL.Text := 'delete from TMPSTAT';
    qry.ExecSQL;
    Application.ProcessMessages;
    SetSQL_qry_tables( MajorVersion );
    qry_tables.Open;
    qry_tables.first;
    li := 0;
    WHILE NOT qry_tables.eof DO
    BEGIN
      qry.SQL.text := 'Select count(*) from ' + qry_tables.Fields[0].AsString;
      Qry.Open;
      S := Qry.Fields[0].AsString;
      Qry.Close;
      if MajorVersion > 13 then
        Qry.SQL.Text := Format( 'insert into TMPBACKUPRESTORE ( TBR_ID, TBR_FIELDSCOUNT ) Values ( %d, %s )', [ Li, s ] )
      else
        Qry.SQL.Text := Format( 'insert into TMPSTAT ( TMP_ID, TMP_ARTID, TMP_MAGID ) Values ( 0, %s, %d )', [ s, Li ] );
      inc(li);
      Qry.execSql;
      qry_tables.next;
      Application.ProcessMessages;
    END;
    qry_tables.Close;
  EXCEPT ON Stan: Exception DO
    BEGIN
      result := false;
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'MARQUAGE DES TABLES' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
    END;
  END;
  database.Connected := false;
END;

FUNCTION TDm_BckGene.usersConnected(NomDeBase: STRING): Integer;
VAR
  i: Integer;
BEGIN
  //retourne le nombre d'utilisateurs connectés à la NomDeBase (sans notre connection pour évaluer ce nombre)
  i := -1;
  TRY
    DataBase.Close;
    DataBase.DataBaseName := NomDeBase;
    DataBase.Open;
    Tran.active := true;
    i := IBDatabaseInfo.UserNames.Count - 1; //connection  - nous
  EXCEPT ON Stan: Exception DO
    BEGIN
      i := -1;
      LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'CONTROLE CONNECTION' + #9 + copy(NomDeBase, 1, 127));
      LogIncident.saveToFile(PathLogIncident);
      Tran.active := false;
      DataBase.Close;
    END;
  END;
  Tran.active := false;
  DataBase.Close;
  result := i;
END;

PROCEDURE TDm_BckGene.DoFait(S: STRING);
BEGIN
  IF assigned(fonfait) THEN
    onfait(self, s);
END;

FUNCTION TDm_BckGene.formatMessage(sMessage: STRING): STRING;
VAR
  newString: STRING;
BEGIN
  // supprimer les caratères CR , LF du message qui gênent son chargement ensuite dans un MEMDATA
  // supprimer les caratères CR , LF du message qui gênent son chargement ensuite dans un MEMDATA
  newString := '';
  newString := StringReplace(sMessage, #13#10, ' ', [rfReplaceAll]);
  newString := StringReplace(sMessage, #9, ' ', [rfReplaceAll]);
  result := newString;
END;

FUNCTION TDm_BckGene.GetNomMachine: STRING;
VAR
  Compt: ARRAY[0..256] OF Char;
  Lasize: DWord;
BEGIN
  IF FNomMachine = '' THEN
  BEGIN
    Lasize := 255;
    getcomputername(@compt, Lasize);
    FNomMachine := STRING(compt);
  END;
  result := FNomMachine;
END;

PROCEDURE TDm_BckGene.DataModuleCreate(Sender: TObject);
VAR
  LogBasesTraite: TstringList;
BEGIN
  FNomMachine := '';
  TRY
    //initialiser le log des bases traitées
    PathLogBasesTraite := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorTraite.log';
    LogBasesTraite := TStringList.Create;
    IF NOT FileExists(PathLogBasesTraite) THEN
    BEGIN
      LogBasesTraite.add('DATE' + #9 + 'CHEMIN');

      if CheckReadOnlyFile(PathLogBasesTraite) then
        LogBasesTraite.SaveToFile(PathLogBasesTraite);

    END;
    MemD_BasesTraite.LoadFromTextFile(PathLogBasesTraite);
    //initialiser le log des incidents
    PathLogIncident := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorIncidents.log';
    LogIncident := TStringList.Create;
    IF FileExists(PathLogIncident) THEN
    BEGIN
      LogIncident.LoadFromFile(PathLogIncident);
    END
    ELSE
    BEGIN
      LogIncident.add('DATE' + #9 + 'MESSAGE' + #9 + 'ACTION' + #9 + 'CHEMIN');
      LogIncident.SaveToFile(PathLogIncident);
    END;
  FINALLY
    LogBasesTraite.free;
  END;
END;

PROCEDURE TDm_BckGene.DataModuleDestroy(Sender: TObject);
BEGIN
  LogIncident.free;
  if CheckReadOnlyFile(PathLogBasesTraite) then
    MemD_BasesTraite.saveToTextFile(PathLogBasesTraite);
  MemD_BasesTraite.close;
END;

function TDm_BckGene.CheckReadOnlyFile(FileName: String): Boolean;
const
  CMAX = 300;
var
  iTempMax : Integer;
  bReadOnly : Boolean;
begin
  bReadOnly := False;
  iTempMax := 0;
  // boucle tant que le fichier est en readonly
  if FileExists(FileName) then
  begin
    // Attention sous XP FileIsReadOnly renvoi True si le fichier n'existe pas
    repeat
      bReadOnly := FileIsReadonly(FileName);
      inc(iTempMax);
      sleep(1000);
    until (not bReadOnly or (iTempMax > CMAX));
  end;

  Result := (iTempMax <= CMAX) or not bReadOnly;
end;


END.

