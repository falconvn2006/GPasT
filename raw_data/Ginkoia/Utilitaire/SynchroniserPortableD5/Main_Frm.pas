UNIT Main_Frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  //début uses
  FileCtrl,
  registry,
  Ucommon,
  UCrc,
  //fin uses
  IB_Components,
  Db,
  IBODataset,
  ExtCtrls,
  LMDCustomComponent,
  RzLabel,
  RzPanel,
  RzPanelRv,
  shellApi,
  LMDFileCtrl,
  ComCtrls;

TYPE
  TFrm_Main = CLASS(TForm)
    RzPanelRv1: TRzPanelRv;
    lab_etape: TRzLabel;
    //DistB_Synchro: TDistractBar;
    Database: TIB_Connection;
    Que_NomGenerateur: TIBOQuery;
    IB_Transaction: TIB_Transaction;
    Que_ExportGenerator: TIBOQuery;
    Que_NomGenerateurRDBGENERATOR_NAME: TStringField;
    Que_NomGenerateurRDBGENERATOR_ID: TSmallintField;
    Que_NomGenerateurRDBSYSTEM_FLAG: TSmallintField;
    Que_CheminServeur: TIBOQuery;
    Que_CheminServeurPRM_STRING: TStringField;
    Set_Generators: TIB_DSQL;
    Tim_Process: TTimer;
    Que_CheminServeurPRM_INTEGER: TIntegerField;
    Que_CheminServeurPRM_FLOAT: TIBOFloatField;
    Que_BaseIdent: TIBOQuery;
    Que_BaseIdentPAR_STRING: TStringField;
    Tim_Progression: TTimer;
    ProgressBar: TProgressBar;
    PROCEDURE FormCreate(Sender: TObject);
    FUNCTION copyFichier(strSource, strDestination: STRING; trials: Integer): Boolean;
    FUNCTION executerProcess(cmdLine: STRING; timeout: integer): boolean;
    FUNCTION recupererGenerateurs(strPathBase: STRING): Boolean;
    PROCEDURE Tim_ProcessTimer(Sender: TObject);
    PROCEDURE synchroniser();
    FUNCTION arreterBase(strPathBase: STRING): boolean;
    FUNCTION demarrerBase(strPathBase: STRING): boolean;
    FUNCTION trouverInterbase: STRING;
    FUNCTION configBase(strPathBaseNb: STRING; numBase: Integer): boolean;
    PROCEDURE Tim_ProgressionTimer(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);

  PRIVATE
    { Déclarations privées }
    strPathBaseNb: STRING; //chemin base notebook
    strPathBaseServ: STRING; //chemin base seveur
    strErreur: STRING; //message d'erreur
    isPortableSynchro: Boolean;

  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_Main: TFrm_Main;

IMPLEMENTATION
VAR
  Lapplication: STRING;
CONST
  _launcher = 'LE LAUNCHER';

{$R *.DFM}

FUNCTION Enumerate(hwnd: HWND; Param: LPARAM): Boolean; STDCALL; FAR;
VAR
  lpClassName: ARRAY[0..999] OF Char;
  lpClassName2: ARRAY[0..999] OF Char;
  Handle: DWORD;
BEGIN
  result := true;
  Windows.GetClassName(hWnd, lpClassName, 500);
  IF Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' THEN
  BEGIN
    Windows.GetWindowText(hWnd, lpClassName2, 500);
    IF Uppercase(StrPas(lpClassName2)) = Lapplication THEN
    BEGIN
      GetWindowThreadProcessId(hWnd, @Handle);
      TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, False, Handle), 0);
      result := False;
    END;
  END;
END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
BEGIN
  // récupèrer les paramètres de la ligne de commandes
  IF (ParamCount = 1) THEN //en test IF (ParamCount = 0) THEN
  BEGIN
    TRY
      strPathBaseNb := trim(paramstr(1));//en test 'C:\Developpement\Ginkoia\Data\Ginkoia.ib'; //trim(paramstr(1));
      //connecter la base de donnée
      Database.Params.Values['USER NAME'] := 'SYSDBA';
      Database.Params.Values['PASSWORD'] := 'masterkey';
      Database.SQLDialect := 3;
      Database.DatabaseName := strPathBaseNb;
      Database.Open;
      TRY
        //verifier s'il s'agit d'un serveur dont le paramétre de la synchro est actif
        Que_CheminServeur.open;
        IF (Que_CheminServeur.RecordCount = 1) THEN
        BEGIN
          isPortableSynchro := (Que_CheminServeurPRM_INTEGER.asInteger = 1) AND (Que_CheminServeurPRM_String.asString <> '')
            AND (Que_CheminServeurPRM_Float.asinteger <> 0);
          //lire param dans la base, table genparam
          strPathBaseServ := Que_CheminServeurPrm_string.asstring;
        END
        ELSE //sinon prévenir que le paramétre initial ne pas été créé dans genparam
        BEGIN
          MessageDlg('Base pas initialisée pour la synchronisation', mtWarning, [mbOk], 0);
        END;
      FINALLY
        Que_CheminServeur.Close;
      END;
    EXCEPT ON e: exception DO
      BEGIN
        strPathBaseNb := '';
        strErreur := e.message;
      END
    END;
  END;
  //passer à la suite quoi qu'il arrive
  Tim_Process.Interval := 500;
END;

PROCEDURE TFrm_Main.FormShow(Sender: TObject);
BEGIN
  Tim_Progression.enabled := true;
END;

FUNCTION TFrm_Main.copyFichier(strSource, strDestination: STRING; trials: Integer): Boolean;
VAR
  i: integer;
  boolCrc: boolean; //résult du test de validité du fichier copié
  intCrcSrc, intCrcDest: LongWord;
  FileCtrl: TLMDFileCtrl;
  boolRetour: boolean;
BEGIN
  //lab effectue une copie d'un fichier
  //retourne true si ok
  //supprime la copie si elle n'est pas valide

  //initialisation optimiste du retour
  boolRetour := false;
  TRY
    FileCtrl := TLMDFileCtrl.Create(Application);
    FileCtrl.Options := [ffFilesOnly, ffNoActionConfirm, ffNoMKDIRConfirm];
    screen.Cursor := crHourGlass;
    IF FileCtrl.CopyFiles(strSource, strDestination) THEN
    BEGIN
      boolRetour := true;
    END;
  EXCEPT ON Stan: Exception DO
    BEGIN
      boolRetour := false;
      screen.Cursor := crDefault;
      Filectrl.free;
      LogAction(stan.message);
    END;
  END;
  //tester le compte rendu : si copy non valide, supprimer la copy
  IF (boolRetour = false) THEN
  BEGIN
    if fileExists(strDestination) then
      FileCtrl.DeleteFiles(strDestination);
  END;
  screen.Cursor := crDefault;

  result := boolRetour;
END;

FUNCTION TFrm_Main.executerProcess(cmdLine: STRING; timeout: integer): boolean;
VAR
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  fin: Boolean;
BEGIN
  //fonction qui crée un process cmdline et attends sa fin ou celle du timeout pour rend la main et signaler le résultat
  //renvoi true si fini ok ou false si fini car timeout
  //timeout -1 signifie que l'on n'attends pas la fin de l'execution du process, mais seulement la fin de sa création
      { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb := SizeOf(StartInfo);
  Screen.Cursor := crHourGlass;
  { Lancement de la ligne de commande }
  IF CreateProcess(NIL, Pchar(cmdLine), NIL, NIL, False,
    0, NIL, NIL, StartInfo, ProcessInfo) THEN
  BEGIN
    Fin := True;
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    IF timeout <> -1 THEN
    BEGIN
      Fin := False;
      //Application.ProcessMessages;
      CASE WaitForSingleObject(ProcessInfo.hProcess, timeout) OF
        WAIT_OBJECT_0: Fin := True;
        WAIT_TIMEOUT: ;
      END;
    END;
  END;
  result := fin;
END;

PROCEDURE TFrm_Main.Tim_ProcessTimer(Sender: TObject);
BEGIN
  //a usage unique lance la synchronisation
  Tim_Process.enabled := false;
  //initialiser le log
  ForceDirectories(ExtractFilePath(Application.exename) + 'Log');
  initLogFileName(NIL, lab_etape, true);
  //lancer la synchro
  synchroniser();
  //fermer l'application
  Frm_Main.close;
END;

PROCEDURE TFrm_Main.Tim_ProgressionTimer(Sender: TObject);
BEGIN
  ProgressBar.position := ProgressBar.position + 1;
  ProgressBar.Update;
END;

PROCEDURE TFrm_Main.synchroniser;
VAR
  success: boolean;
  strNewName, strPathLauncher, nomBase: STRING;
  numBase: integer;
  newRep: STRING;
BEGIN
  success := false;
  TRY
    //vérifier la validité du chemin de la base du notebook
    IF FileExists(strPathBaseNb) THEN
    BEGIN
      LogAction(#13#10 + 'Début de la synchronisation');
      LogAction('Chemin de la base du portable : ' + strPathBaseNb);
      //tuer le launcher
      LogAction('Arrêt du launcher');
      Lapplication := _launcher;
      EnumWindows(@Enumerate, 0);
      //lancer la récupération des générateurs
      IF recupererGenerateurs(strPathBaseNb) THEN
      BEGIN
        LogAction('Création du fichier des générateurs réussie');
        IF isPortableSynchro THEN
        BEGIN
          //tester le chemin
          IF FileExists(strPathBaseServ) THEN
          BEGIN
            LogAction('Chemin de la base du serveur : ' + strPathBaseServ);
            //créer le nom de la copie
            strNewName := ExtractFilePath(strPathBaseNb) + 'Synchro_' + FormatDateTime('yyyy_mm_dd', Date) + '_' + ExtractFileName(strPathBaseNb);
            LogAction('Début du transfert de la base du serveur : ' + strPathBaseServ);
            IF copyFichier(strPathBaseServ, strNewName, 3) THEN
            BEGIN
              LogAction('La base du serveur a été transférée :' + strNewName);
              //arreter les connexions sur la base ginkoia du notebook
              DataBase.close;
              IF arreterBase(strPathBaseNb) THEN
              BEGIN
                //effacer l'ancienne copie '.toto' et renommer ginkoia.ib en '.toto'
                deleteFile(ChangeFileExt(strPathBaseNb, '.toto'));
                IF renameFile(strPathBaseNb, ChangeFileExt(strPathBaseNb, '.toto')) THEN
                BEGIN
                  //reconfigurer la base
                  IF configBase(strNewName, numBase) THEN
                  BEGIN
                    LogAction('Configuration de la base réussie.');
                    //renommer la base transférée copy en GINKOIA.IB
                    renameFile(strNewName, strPathBaseNb);
                    //démarrer ginkoia.ib
                    IF demarrerBase(strPathBaseNb) THEN
                    BEGIN
                      LogAction('Connexion à la base rétablie.');
                      //prévenir que le programme se ferme et que la suite dépend de vérification auto
                      MessageDlg('Synchronisation Terminé, lancement de ''Launcher.exe'' et de ''Verification.exe''' + #13#10 + 'Veuillez attendre la fin de ''Verification.exe'' avant de poursuivre.', mtInformation, [mbOk], 0);
                      //relancer le launcher
                      strPathLauncher := copy(ExtractFilePath(strPathBaseNb), 0, length(ExtractFilePath(strPathBaseNb)) - 5) + 'LaunchV7.exe';
                      IF executerProcess(strPathLauncher, -1) THEN
                      BEGIN
                        //lancer verification auto
                        IF executerProcess('"Verification.exe" "AUTO"', -1) THEN
                        BEGIN
                          success := true;
                          //effacer le transfert
                          DeleteFile(strNewName);
                          //créer le répertoire 'backup' s'il n'existe pas
                          newRep := IncludeTrailingBackslash(ExtractFilePath(strPathBaseNb)) + 'backup\';
                          ForceDirectories(newRep);
                          //déplacer la copie
                          IF FileExists(newRep + 'GINKOIA.toto') THEN
                          BEGIN
                            DeleteFile(newRep + 'GINKOIA.toto');
                          END;
                          MoveFile(Pchar(ChangeFileExt(strPathBaseNb, '.toto')), Pchar(newRep + 'GINKOIA.toto'));
                        END
                        ELSE
                        BEGIN
                          LogAction('Echec de la synchronisation : Erreur lors de l''execution de Verification.exe "AUTO"');
                          Tim_Progression.enabled := false;
                        END;
                      END
                      ELSE
                      BEGIN
                        LogAction('Echec de la synchronisation : Erreur lors de l''execution du launcher');
                        Tim_Progression.enabled := false;
                      END;
                    END;
                  END
                  ELSE
                  BEGIN
                    LogAction('Echec de la synchronisation : Erreur lors de la configuration de la base');
                    Tim_Progression.enabled := false;
                  END;
                END
                ELSE
                BEGIN
                  LogAction('Echec de la synchronisation : Erreur lors du renommage de la base GINKOIA.IB');
                  Tim_Progression.enabled := false;
                END;
              END;
            END
            ELSE
            BEGIN
              LogAction('Echec de la synchronisation : Erreur lors du remplacement de la base');
              Tim_Progression.enabled := false;
            END;
          END
          ELSE
          BEGIN
            LogAction('Echec de la synchronisation : Impossible de trouver la base du serveur');
            Tim_Progression.enabled := false;
          END;
        END
        ELSE
        BEGIN
          LogAction('Echec de la synchronisation : la base ' + nomBase + ' n''est pas un notebook.');
          Tim_Progression.enabled := false;
        END;
      END
      ELSE
      BEGIN
        LogAction('Echec de la synchronisation : Impossible de récupèrer les générateurs');
        Tim_Progression.enabled := false;
      END
    END
    ELSE
    BEGIN
      LogAction('Arrêt de l''application : erreur de paramétres :' + strErreur);
      Tim_Progression.enabled := false;
    END;
  FINALLY
    //vérifier le booléan du déroulement des opérations
    IF success = false THEN
    BEGIN
      //Todo : que faire avec la base renommée ?
      LogAction('La synchronisation a échoué');
      //informer l'utilisateur avant de refermé le programme
      MessageDlg('Echec de la synchronisation : veuillez contacter GINKOIA.', mtWarning, [mbOk], 0);
      demarrerBase(strPathBaseNb);
      screen.Cursor := crDefault;
    END
    ELSE
    BEGIN
      LogAction('La synchronisation a réussi');
    END;
    Tim_Progression.enabled := false;
  END;
END;

FUNCTION TFrm_Main.recupererGenerateurs(strPathBase: STRING): Boolean;
VAR
  tsExportSql: TStringList;
  retour: boolean;
BEGIN
  // Fonction qui récupère les générateurs de la base strPathBase et les stockent dans un fichier sql enregistré à coté de la base
  // retourne vrai si le fichier sql est bien créé.

  retour := false;
  TRY
    //créer le mémo pour stocker les lignes des générateurs
    tsExportSql := TStringList.create;
    //commencer par le numéro de la base
    Que_BaseIdent.close;
    Que_BaseIdent.Open;
    tsExportSql.Add('update genparambase set par_string=''' + Que_BaseIdentPAR_String.asString + ''' where Par_nom=''IDGENERATEUR'';');
    //récupèrer le nom de chaque générateur
    Que_NomGenerateur.open;
    Que_NomGenerateur.first;
    //pour chaque générateur non system récupérer sa valeur sous la forme d'une ligne d'exportation set generator to 'val'
    WHILE NOT Que_NomGenerateur.eof DO
    BEGIN
      IF Que_NomGenerateurRDBSYSTEM_FLAG.asinteger <> 1 THEN
      BEGIN
        Que_ExportGenerator.sql.text := 'select ''set generator ''|| F_RTRIM(RDB$GENERATOR_NAME) ||'' to ''||GEN_ID(' + Que_NomGenerateurRDBGENERATOR_NAME.asString + ',0)  from rdb$Generators where RDB$GENERATOR_NAME=UPPER(''' + Que_NomGenerateurRDBGENERATOR_NAME.asString + ''')';
        Que_ExportGenerator.Open;
        tsExportSql.Add(Que_ExportGenerator.fields[0].asString + ';');
      END;
      Que_NomGenerateur.next;
    END;
    //sauver le résultat
    tsExportSql.SaveToFile(ExtractFilePath(strPathbase) + 'generateursSynchro.sql');
    retour := true;
  FINALLY
    tsExportSql.free;
    Que_BaseIdent.close;
    Que_NomGenerateur.close;
    Que_ExportGenerator.close;
  END;
  result := retour;
END;

FUNCTION TFrm_Main.arreterBase(strPathBase: STRING): boolean;
VAR
  retour: boolean;
  cmdline: STRING;
BEGIN
  //Arrete la base strPathBase
  //retourne vrai si executé
  retour := false;
  TRY
    cmdline := '"' + trouverInterbase + 'gfix.exe" -rollback all "' + strPathBase + '" -user sysdba -password masterkey';
    IF executerProcess(cmdline, 10000) THEN
    BEGIN
      cmdline := '"' + trouverInterbase + 'gfix.exe" -shut -force 0 -user sysdba -password masterkey "' + strPathBase + '"';
      IF executerProcess(cmdline, 15000) THEN
      BEGIN
        retour := true;
      END;
    END;
  EXCEPT
  END;
  result := retour;
END;

FUNCTION TFrm_Main.trouverInterbase: STRING;
VAR
  Reg: Tregistry;
BEGIN
  reg := Tregistry.Create;
  TRY
    reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    result := Reg.ReadString('ServerDirectory');
  FINALLY
    reg.free;
  END;
END;

FUNCTION TFrm_Main.demarrerBase(strPathBase: STRING): boolean;
VAR
  retour: boolean;
BEGIN
  //démarre la base strPathBase
  //retourne vrai si executé
  retour := false;
  TRY
    IF executerProcess('"' + trouverInterbase + 'gfix.exe" -online -user sysdba -password masterkey "' + strPathBase + '"', 1000) THEN
    BEGIN
      retour := true;
    END;
  EXCEPT
  END;
  result := retour;

END;

FUNCTION TFrm_Main.configBase(strPathBaseNb: STRING; numBase: Integer): boolean;
VAR
  tsl: Tstringlist;
  retour: boolean;
  i: integer;
BEGIN
  retour := false;
  i := 0;
  TRY
    Database.Path := strPathBaseNb;
    DataBase.Connect;
    tsl := TStringList.create();
    tsl.loadfromFile(ExtractFilePath(strPathBaseNb) + 'generateursSynchro.sql');

    //changer les générateurs ligne par ligne
    WHILE (i <= tsl.count - 1) DO
    BEGIN
      //initialiser le requete
      Set_Generators.sql.clear;
      //passer le script des générateurs
      Set_Generators.SQL.Text := tsl.Strings[i];
      Set_Generators.ExecSQL;
      //augmenter le compteur
      inc(i);
    END;
    LogAction('Générateurs de la base changés');
    retour := true;
  FINALLY
    tsl.free;
    DataBase.Disconnect;
  END;
  result := retour;
END;

END.

