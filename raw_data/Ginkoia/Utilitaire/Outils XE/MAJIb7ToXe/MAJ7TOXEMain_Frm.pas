unit MAJ7TOXEMain_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, CategoryButtons, StdCtrls, Buttons, ComCtrls, uLogs,
  ActnList, MAJ7TOXE_Defs,  uToolsXE, Registry,
  LMDPNGImage, ShlObj, StrUtils, ShellAPI, IniFiles, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdBaseComponent, IdMessage, IdAttachmentFile, IdEmailAddress, DateUtils
  {$IFDEF POSTESERVEUR}
  ,DbClient,MAJ7TOXE_DM,uBackup,Db, Spin
  {$ENDIF}
  ;

type


  Tfrm_MajIb7ToXEMain = class(TForm)
    GridPanel1: TGridPanel;
    CategoryButtons1: TCategoryButtons;
    Pgc_ShowEtape: TPageControl;
    Tab_Etape1: TTabSheet;
    Gbx_BackupTop: TGroupBox;
    Gbx_BackupClient: TGroupBox;
    Gbx_BackupBottom: TGroupBox;
    edt_BackUpSource: TEdit;
    edt_BackupDestination: TEdit;
    Lab_BackUpSource: TLabel;
    Lab_BackUpDestination: TLabel;
    Nbt_BackUpSource: TBitBtn;
    Nbt_BackUpDestination: TBitBtn;
    Nbt_BackupDemarrer: TBitBtn;
    mmBackup_Logs: TMemo;
    ActLst_Etape: TActionList;
    Ax_E1Backup: TAction;
    Gbx_Progression: TGroupBox;
    Lab_Progression: TLabel;
    PBar_Main: TProgressBar;
    OD_Source: TOpenDialog;
    OD_Destination: TOpenDialog;
    Tab_Initialisation: TTabSheet;
    Ax_E0Initialisation: TAction;
    Gbx_Initialisation: TGroupBox;
    Pan_E0Client: TPanel;
    GP_Initialisation: TGridPanel;
    Pan_InitL1: TPanel;
    Lab_IB7: TLabel;
    Img_IB7: TImage;
    Pan_InitL2: TPanel;
    Lab_IBXE: TLabel;
    Img_IBXE: TImage;
    Pan_InitL3: TPanel;
    Lab_IbIsStarted: TLabel;
    Img_IBIsStarted: TImage;
    Pan_InitL4: TPanel;
    Lab_JavaPresent: TLabel;
    Img_JavePresent: TImage;
    Gbx_InitialisationLogs: TGroupBox;
    mmE0_Logs: TMemo;
    Tim_StartAuto: TTimer;
    Tab_MAJIBToXE: TTabSheet;
    Gbx_E2Top: TGroupBox;
    Gbx_E2client: TGroupBox;
    Img_Valid: TImage;
    Img_Cancel: TImage;
    GP_E2: TGridPanel;
    Pan_E2UnInstIB7: TPanel;
    Pan_E2InstXE: TPanel;
    Pan_E2InstPatchXE: TPanel;
    Img_E2UnInstIB7: TImage;
    Img_E2InstXE: TImage;
    Img_E2InstPatchXE: TImage;
    Lab_E2UnInstIb7: TLabel;
    Lab_E2InstXE: TLabel;
    Lab_E2InstPatchXE: TLabel;
    Ax_E2Install: TAction;
    mmMigre_Logs: TMemo;
    Tab_E3Restore: TTabSheet;
    Ax_E3Restore: TAction;
    Gbx_E3Dir: TGroupBox;
    Gbx_E3Memo: TGroupBox;
    Gbx_E3Actions: TGroupBox;
    Lab_E3Destination: TLabel;
    Lab_E3Source: TLabel;
    edt_E3Source: TEdit;
    edt_E3Destination: TEdit;
    nbt_E3Source: TBitBtn;
    nbt_E3Destination: TBitBtn;
    mmRestore_Logs: TMemo;
    Nbt_E3Actions: TBitBtn;
    Tim_StartEtape22: TTimer;
    Ax_E2Install22: TAction;
    Tab_E4Divers: TTabSheet;
    Ax_E4Divers: TAction;
    Gbx_E4Top: TGroupBox;
    Gbx_E4Logs: TGroupBox;
    GridPanel2: TGridPanel;
    Pan_E41: TPanel;
    Pan_E42: TPanel;
    Pan_E43: TPanel;
    Pan_E44: TPanel;
    Pan_E45: TPanel;
    Pan_E46: TPanel;
    Pan_E47: TPanel;
    Pan_E48: TPanel;
    Lab_E4Compare: TLabel;
    Img_E4Compare: TImage;
    Lab_E4Utilisateurs: TLabel;
    Img_E4Utilisateur: TImage;
    mmDivers_Logs: TMemo;
    Lab_E4Netoyage: TLabel;
    Img_E4Netoyage: TImage;
    Lab_Alert: TLabel;
    Tim_Alert: TTimer;
    IdMessage1: TIdMessage;
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_BackupDemarrerClick(Sender: TObject);
    procedure Ax_E1BackupExecute(Sender: TObject);
    procedure Nbt_BackUpSourceClick(Sender: TObject);
    procedure Nbt_BackUpDestinationClick(Sender: TObject);
    procedure Ax_E0InitialisationExecute(Sender: TObject);
    procedure Tim_StartAutoTimer(Sender: TObject);
    procedure Ax_E2InstallExecute(Sender: TObject);
    procedure nbt_E3SourceClick(Sender: TObject);
    procedure nbt_E3DestinationClick(Sender: TObject);
    procedure Ax_E3RestoreExecute(Sender: TObject);
    procedure Nbt_E3ActionsClick(Sender: TObject);
    procedure Tim_StartEtape22Timer(Sender: TObject);
    procedure Ax_E2Install22Execute(Sender: TObject);
    procedure Ax_E4DiversExecute(Sender: TObject);
    procedure Tim_AlertTimer(Sender: TObject);
    procedure CategoryButtons1Categories5Items0Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
    procedure ExecuteProcess(AMode : TModeRun; Etape : Integer = E0Initialisation);
    procedure StopAppAndServices;

    procedure LockComponents;

    procedure SendMail(AMessage : TIdMessage);
  public
    { Déclarations publiques }
  end;

var
  frm_MajIb7ToXEMain: Tfrm_MajIb7ToXEMain;

implementation

{$R *.dfm}

procedure Tfrm_MajIb7ToXEMain.Ax_E0InitialisationExecute(Sender: TObject);
var
  Reg : TRegistry;
  PFDirectory : string;
  bJavaPresent : Boolean;
  iResult : Integer;
  Res : TResourceStream;

  bIb7Present, bIbXEPresent : Boolean;
  sFileVersionPath, sFileVersionAttendu, sFileVersionEnCours : String;
begin
  // Initialisation
  Logs.Path := GAPPLOGS;
  Logs.FileName := Format('E0-Initialisation%s.log',[FormatDateTime('YYYYMMDDhhmmss',Now)]);
  Logs.Memo := mmE0_Logs;

  Logs.AddToLogs('----------------------------------------');
  Logs.AddToLogs('Etape - Initialisation');
  Logs.AddToLogs('----------------------------------------');
  Logs.AddToLogs('');
  Pgc_ShowEtape.ActivePage := Tab_Initialisation;
  Application.ProcessMessages;

  {$IFDEF POSTESERVEUR}
  DM_MajIb7ToXE := TDM_MajIb7ToXE.Create(Self);
  {$ENDIF}

  {$REGION 'Vérification que IB7 est bien présent'}
  Logs.AddToLogs('--- Vérification de la présence IB7 ---');
  bIb7Present := False;
  Reg := TRegistry.Create(KEY_READ);
  Try
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.KeyExists('\Software\Borland\Interbase\CurrentVersion') then
      begin
        bIb7Present := True;
        Img_IB7.Picture := Img_Valid.Picture;
        Logs.AddToLogs('  -> Interbase 7 Présent');
        Application.ProcessMessages;
      end
      else
        Logs.AddToLogs('  -> Interbase 7 non trouvé');
    Except on E:Exception do
      begin
        Logs.AddToLogs('  -> Erreur : ' + E.Message);
        Img_IB7.Picture := Img_Cancel.Picture;
        raise EIB7NOTPRESENT.Create('  -> Erreur : ' + E.Message);
      end;
    end;
  Finally
    Reg.Free;
  End;
  Logs.AddToLogs('');
  {$ENDREGION}

  {$REGION 'Vérification que IBXe n''est pas installé'}
  Logs.AddToLogs('--- Vérification qu''IBXE n''est pas installé sur le poste ---');
  bIbXEPresent := False;
  Reg := TRegistry.Create(KEY_READ);
  Try
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if not Reg.KeyExists('\Software\Borland\Interbase\Servers\gds_db') then
      begin
        Img_IBXE.Picture := Img_Valid.Picture;
        Logs.AddToLogs('  -> IBXE non trouvé');
        Application.ProcessMessages;
      end
      else begin
        bIbXEPresent := True;
        // Récupération du chemin d'installation d'interbase XE
        {$IFDEF POSTESERVEUR}
        Reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db', false);
        sFileVersionPath := Reg.ReadString('ServerDirectory');
        if Trim(sFileVersionPath) = '' then
        begin
          sFileVersionPath := 'c:\Embarcadera\Interbase\bin\gds32.dll';
          if not FileExists(sFileVersionPath) then
          begin
            sFileVersionPath := 'd:\Embarcadera\Interbase\bin\gds32.dll';
            if not FileExists(sFileVersionPath) then
              raise Exception.Create('IB XE -> DLL Introuvable');
          end;
        end
        else begin
          sFileVersionPath := IncludeTrailingPathDelimiter(sFileVersionPath) + 'gds32.dll';
        end;
        {$ELSE}
        sFileVersionPath := SpecialFolder(CSIDL_SYSTEM) + '\gds32.dll';
        if not FileExists(sFileVersionPath) then
        begin
          Logs.AddToLogs('Chemin de recherche : ' + sFileVersionPath);
          raise Exception.Create('IB XE -> DLL Introuvable');
        end;
        {$ENDIF}
        Logs.AddToLogs('  -> IB XE Présent');
      end;
    Except on E:Exception do
      begin
        Img_IBXE.Picture := Img_Cancel.Picture;
        raise EIBXEPRESENT.Create('  -> Erreur : ' + E.Message);
      end;
    end;
  Finally
    Reg.Free;
  End;
  Logs.AddToLogs('');
  {$ENDREGION}

  {$REGION 'Traitement des différents Cas'}
  // IB7 Ok, pas IBXE = fonctionnement normal
  GIBINSTALL := ibComplet;

  // Pas IB7, pas IBXE = erreur poste à vérifier
  // IB7 Ok, IBXE Ok = erreur poste à vérifier
  if (bIb7Present and bIbXEPresent) or (not bIb7Present and not bIbXEPresent) then
    raise Exception.Create('Incohérence sur l''installation d''interbase, veuillez vérifier le poste');

  // Pas Ib7, IbXE Ok = Vérifier la version d'ibXE
  if not bIb7Present and bIbXEPresent then
  begin
    sFileVersionEnCours := InfoSurExe(sFileVersionPath).FileVersion;
    sFileVersionAttendu := 'WI-V10.0.5.595';
    Logs.AddToLogs(Format('Version en cours %s - Version attendue %s',[sFileVersionEnCours,sFileVersionAttendu]));
    if sFileVersionAttendu <> sFileVersionEnCours then
    begin
      GIBINSTALL := ibPatchOnly;
    end
    else
      raise EIBXEPRESENT.Create('  -> Poste déjà à jour');
  end;
  {$ENDREGION}

  {$REGION 'Arrêt des applications et services'}
  StopAppAndServices;
  {$ENDREGION}

  {$IFDEF POSTESERVEUR}
  {$REGION 'Service IB démarré ?'}
  if bIb7Present then
  begin
    Logs.AddToLogs('--- Vérification si le serveur est démarré ---');
    Try
      DM_MajIb7ToXE.IBServerProperties.Active := False;
      DM_MajIb7ToXE.IBServerProperties.Active := True;
      Img_IBIsStarted.Picture := Img_Valid.Picture;
      Logs.AddToLogs('  -> Serveur Ok');
      Application.ProcessMessages;
    Except on E:Exception do
      begin
        Img_IBIsStarted.Picture := Img_Cancel.Picture;
        Logs.AddToLogs('  -> Serveur IB7 non démarré :' + E.Message);

        raise EIB7NOTSTARTED.Create('IB7 non démarré : ' + E.Message);
      end;
    End;
    Logs.AddToLogs('');
  end;
  {$ENDREGION}
  {$ENDIF}

  {$REGION  'Java 1.2 Présent'}
  if bIb7Present then
  begin
    Try
      Logs.AddToLogs('--- Vérification de la présence de Java 1.2');
      bJavaPresent := False;
      PFDirectory := IncludeTrailingPathDelimiter(SpecialFolder(CSIDL_PROGRAM_FILES));
      Logs.AddToLogs('  -> Recherche dans : ' + PFDirectory);
      if FileExists(PFDirectory + 'JavaSoft\JRE\1.2\bin\JAVA.EXE') then
      begin
        Logs.AddToLogs('    - Java 1.2 Présent désintallation IB7 possible');
        bJavaPresent := True;
      end
      else begin
        PFDirectory := IncludeTrailingPathDelimiter(SpecialFolder(CSIDL_PROGRAM_FILESX86));
        Logs.AddToLogs('  -> Recherche dans : ' + PFDirectory);
        if FileExists(PFDirectory + 'JavaSoft\JRE\1.2\bin\JAVA.EXE') then
        begin
          Logs.AddToLogs('    - Java 1.2 Présent désintallation IB7 possible');
          bJavaPresent := True;
        end;
      end;

      Logs.AddToLogs('');
      if not bJavaPresent then
      begin
        Logs.AddToLogs('--- Installation de Java 1.2 ---');
        Logs.AddToLogs('  -> Extraction de l''exécutable');
        Res := TResourceStream.Create(HInstance,'JAVA_1',RT_RCDATA);
        Try
          Res.SaveToFile(GAPPTOOL + 'Java1.2.7z');
        Finally
          Res.Free;
        End;
        DoDir(GAPPTEMP + '\Java1.2');
        UnzipFile(GAPPTOOL + 'Java1.2.7z',GAPPTEMP + '\Java1.2');

        Logs.AddToLogs('  -> Installation de Java 1.2');
        Logs.AddToLogs(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe ' + '/c ' + GAPPTEMP + 'Java1.2\Setup.exe' + ' ' + Format('/s /v /f1"%ssetup.iss"',[GAPPTEMP + 'Java1.2\']));
        iResult := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe','/c ' + GAPPTEMP + 'Java1.2\Setup.exe' + Format(' /s /f1"%ssetup.iss"',[GAPPTEMP + 'Java1.2\']));
        Logs.AddToLogs(Format('Retour d''installation : %d',[iResult]));
        Logs.AddToLogs('');
      end;
      Img_JavePresent.Picture := Img_Valid.Picture;
      Application.ProcessMessages;
    except on E:Exception do
      begin
        Img_JavePresent.Picture := Img_Cancel.Picture;
        Logs.AddToLogs('  -> Erreur d''installation : ' + E.Message);
        raise EJAVAERRORINST.Create('Erreur d''installation : ' + E.Message);

      end;
    End;
  End;
 {$ENDREGION}

  Logs.AddToLogs('----------------------------------------');
  Logs.AddToLogs('Etape - Initialisation - Terminé');
  Logs.AddToLogs('----------------------------------------');
end;

procedure Tfrm_MajIb7ToXEMain.Ax_E1BackupExecute(Sender: TObject);

  {$REGION 'CallBackCopyFile'}
  function CallBackCopyFile(
    TotalFileSize: LARGE_INTEGER;          // Taille totale du fichier en octets
    TotalBytesTransferred: LARGE_INTEGER;  // Nombre d'octets déjàs transférés
    StreamSize: LARGE_INTEGER;             // Taille totale du flux en cours
    StreamBytesTransferred: LARGE_INTEGER; // Nombre d'octets déjà tranférés dans ce flus
    dwStreamNumber: DWord;                 // Numéro de flux actuem
    dwCallbackReason: DWord;               // Raison de l'appel de cette fonction
    hSourceFile: THandle;                  // handle du fichier source
    hDestinationFile: THandle;             // handle du fichier destination
    ProgressBar : TProgressBar             // paramètre passé à la fonction qui est une
                                           // recopie du paramètre passé à CopyFile Ex
                                           // Il sert à passer l'adresse du progress bar à
                                           // mettre à jour pour la copie. C'est une
                                           // excellente idée de DelphiProg
    ): DWord; far; stdcall;
  var
    EnCours: Int64;
  begin
    // Calcul de la position du progresbar en pourcent, le calcul doit être effectué dans
    // une variable intermédiaire de type Int64. Pour éviter les débordement de calcul
    // dans la propriété Position de type integer.
    if TotalFileSize.QuadPart <> 0 then
      EnCours := TotalBytesTransferred.QuadPart * 100 div TotalFileSize.QuadPart;
    If ProgressBar<>Nil Then ProgressBar.Position := EnCours;
    // La fonction doit définir si la copie peut être continuée.
  //  Application.ProcessMessages;
    Result := PROGRESS_CONTINUE;
    Application.ProcessMessages;
  end;
  {$ENDREGION}
var
  lpBool : PBool;
  sLigne : String;
  Lst : TStringList;
begin
  {$IFDEF POSTESERVEUR}
  Try
    if not (GIBINSTALL = ibComplet) then
      Exit;

    // Initialisation du logs
    Logs.Path := GAPPLOGS;
    Logs.FileName := Format('E1-Backup%s.log',[FormatDateTime('YYYYMMDDHHMMSS',Now)]);
    Logs.Memo := mmBackup_Logs;

    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape - 1 - Backup de la base de données');
    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('');
    Pgc_ShowEtape.ActivePage := Tab_Etape1;
    Application.ProcessMessages;

    // Sauvegarde de la base de données
    Logs.AddToLogs('Sauvegarde de la base de données');
    Lab_Progression.Caption := Format('Copie de %s vers %s',[edt_BackUpSource.Text,GAPPSAVE + ExtractFileName(edt_BackUpSource.Text)]);
    if FileExists(GAPPSAVE + ExtractFileName(edt_BackUpSource.Text)) then
      DeleteFile(GAPPSAVE + ExtractFileName(edt_BackUpSource.Text));
    Gbx_Progression.Visible := True;
    try
      CopyFileEx(PWideChar(edt_BackUpSource.Text),PWideChar(GAPPSAVE + ExtractFileName(edt_BackUpSource.Text)),@CallBackCopyFile,PBar_Main,lpBool, COPY_FILE_FAIL_IF_EXISTS);
    finally
      Gbx_Progression.Visible := False;
    end;
    Logs.AddToLogs('  -> Copie terminée');
    Logs.AddToLogs('');

    Logs.AddToLogs('--- Début du backup ---');
    Lst := TStringList.Create;
    try
      Logs.AddToLogs('  -> Démarrage du backup');
      Backup(edt_BackUpSource.Text,edt_BackupDestination.Text,Lst,True);
      Lst.SaveToFile(GAPPLOGS + ChangeFileExt(Logs.FileName,'') + '-GBack.log');
      Logs.AddToLogs('--- Backup terminé ---');
    finally
      Lst.Free;
    end;

    Logs.AddToLogs('');
    Logs.AddToLogs('--- Récupération des informations d''intégritées ---');
    Logs.AddToLogs('');
    Logs.AddToLogs('  -> Traitement des tables & procédures stockées');
    // Récupération de la liste des table
    Cds_Backup.EmptyDataSet;
    Gbx_Progression.Visible := True;
    try
      GetDataDb(edt_BackUpSource.Text,Cds_Backup,Lab_Progression,PBar_Main);
    finally
      Gbx_Progression.Visible := False;
    end;
    Logs.AddToLogs('  -> Sauvegade dans : ' + GAPPSAVE + 'E1-BackupData.Xml');
    Cds_Backup.SaveToFile(GAPPSAVE + 'E1-BackupData.Xml',dfXml);

    Logs.AddToLogs('');
    Logs.AddToLogs('--- Récupération des informations de la base de données');
    InfoBase := DM_MajIb7ToXE.GetInfoBase(edt_BackUpSource.Text);

    if Assigned(DM_MajIb7ToXE) then
      DM_MajIb7ToXE.Free;
    DoWait(2000);

    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape 1 - Terminé');
    Logs.AddToLogs('----------------------------------------');

  Except
    on E:EGBACKEXCEPTION do
      begin
        Logs.AddToLogs('Ax_E1BackupExecute -> ' + E.Message);
        raise Exception.Create('Ax_E1BackupExecute -> ' + E.Message);
      end;
    on E:Exception do
      begin
        Logs.AddToLogs('Ax_E1BackupExecute -> ' + E.Message);
        raise Exception.Create('Ax_E1Backup Execute -> ' + E.Message);
      end;
  End;
  {$ENDIF}
end;

procedure Tfrm_MajIb7ToXEMain.Ax_E2InstallExecute(Sender: TObject);
var
  Reg : TRegistry;
  Res : TResourceStream;
  iResult : Integer;
  lst : TStringList;
  i : Integer;
begin
  Try
  // Initialisation
    // Initialisation du logs
    Logs.Path := GAPPLOGS;
    Logs.FileName := Format('E2-Install%s.log',[FormatDateTime('YYYYMMDDHHMMSS',Now)]);
    Logs.Memo := mmMigre_Logs;

    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape - 2 - 1/2- Migration de IB7 ver IbXE');
    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('');
    Pgc_ShowEtape.ActivePage := Tab_MAJIBToXE;
    Application.ProcessMessages;

    {$REGION 'Désintallation IB7'}
    if GIBINSTALL = ibComplet then
    try
      Logs.AddToLogs('--- Désintallation d''IB7 ---');

      Logs.AddToLogs('  -> Arrêt du service interbase');
      ServiceStop('','InterBaseServer');
      ServiceStop('','InterbaseGuardian');

      Logs.AddToLogs('  -> Arrêt Ibguard');
      KillProcessus('ibguard.exe');
      KillProcessus('ibguard.exe');  // dans le cas où plusieurs instances ont été lancées

      Logs.AddToLogs('  -> Arrêt Ibserver');
      KillProcessus('ibserver.exe');
      KillProcessus('ibserver.exe'); // dans le cas où plusieurs instances ont été lancées

      {$REGION 'Récupération du chemin d''installation d''interbase 7'}
      Logs.AddToLogs('  -> Récupération du chemin d''interbase');
      Reg := TRegistry.Create(KEY_READ);
      try
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        if Reg.KeyExists('\Software\Borland\Interbase\CurrentVersion') then
        begin
          Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
          INTERBASE7ROOTDIR := IncludeTrailingPathDelimiter(Reg.ReadString('RootDirectory'));
          Logs.AddToLogs('  -> Chemin : ' + INTERBASE7ROOTDIR);
        end
        else
          raise EIB7DIRNOTFOUND.Create('Problème lors de la recherche dans la base de registre d''interbase');
      finally
        Reg.Free;
      end;
      {$ENDREGION}

      {$REGION 'Suppression du démarrage auto d''IBGuard'}
      Logs.AddToLogs('  -> Suppression du Run d''IbGuard');
      Reg := TRegistry.Create(KEY_ALL_ACCESS);
      Try
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        lst := TStringList.Create;
        try
          if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then
          begin
            Reg.GetValueNames(lst);
            for i := 0 to Lst.Count -1 do
            begin
              Logs.AddToLogs('BR : ' + lst[i]);
              if Pos('ibguard', LowerCase(Reg.ReadString(lst[i]))) > 0 then
              begin
                Reg.DeleteValue(lst[i]);
                Logs.AddToLogs('Suppression de la clé de registre : ' + lst[i]);
              end;
            end;
            Reg.CloseKey;
          end
          else
            Logs.AddToLogs('ouverture impossible de la clé de registre : \Software\Microsoft\Windows\CurrentVersion\Run');
        finally
          lst.Free;
        end;
      finally
        Reg.Free;
      end;
      {$ENDREGION}

      if FileExists(INTERBASE7ROOTDIR + 'UninstallerData\Uninstall InterBase 7.1 .exe') then
      begin
       Logs.AddToLogs(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe' + ' /c "' + INTERBASE7ROOTDIR + 'UninstallerData\Uninstall InterBase 7.1 .exe" -i silent');
       iResult := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "' + INTERBASE7ROOTDIR + 'UninstallerData\Uninstall InterBase 7.1 .exe" -i silent');
       Logs.AddToLogs('  -> Désintallation Ok');
       Logs.AddToLogs(Format('    - Retour d''installation : %d',[iresult]));
       if iResult <> -1 then
         raise Exception.Create('Erreur de désintallation d''IB 7');

       Img_E2UnInstIB7.Picture := Img_Valid.Picture;
       Application.ProcessMessages;
      end
      else
        raise EIB7ROOTNOTFOUND.Create(Format('Fichier de désintallation non trouvé : %sUninstallerData\Uninstall InterBase 7.1 .exe',[INTERBASE7ROOTDIR]));
      Logs.AddToLogs('');
    Except on E:Exception do
      begin
        Logs.AddToLogs('  -> Erreur : ' + E.Message);
        Img_E2UnInstIB7.Picture := Img_Cancel.Picture;
        raise Exception.Create('Désintallation IB7 Erreur -> ' + E.Message);
      end;
    end;
    {$ENDREGION}

    Logs.AddToLogs('  -> Extraction d''IBXE');
    Res := TResourceStream.Create(HInstance,'IBXE',RT_RCDATA);
    Try
      Res.SaveToFile(GAPPTOOL + 'IbXe.7z');
    Finally
      Res.Free;
    End;

    Logs.AddToLogs('  -> Décompression du fichier');
    UnzipFile(GAPPTOOL + 'IbXe.7z',GAPPTEMP);


    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape 2 - 1/2 - Terminé');
    Logs.AddToLogs('----------------------------------------');

   Except on E:exception do
    raise Exception.Create('Ax_E2InstallExecute -> ' + E.Message);
  End;
end;

procedure Tfrm_MajIb7ToXEMain.Ax_E2Install22Execute(Sender: TObject);
var
  Reg : TRegistry;
  Res : TResourceStream;
  iResult : Integer;
begin
    // Initialisation du logs
    Logs.Path := GAPPLOGS;
    Logs.FileName := Format('E2-Install%s.log',[FormatDateTime('YYYYMMDDHHMMSS',Now)]);
    Logs.Memo := mmMigre_Logs;

    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape - 2 -2/2- Migration de IB7 ver IbXE');
    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('');
    Pgc_ShowEtape.ActivePage := Tab_MAJIBToXE;
    Img_E2UnInstIB7.Picture := Img_Valid.Picture;
    Application.ProcessMessages;

    {$IFDEF POSTESERVEUR}
    {$REGION 'Arrêt des applications et services'}
    StopAppAndServices;
    {$ENDREGION}
    {$ENDIF}

    {$IFNDEF POSTESERVEUR}

    {$REGION 'Installation IBXE'}
    if GIBINSTALL = ibComplet then
    begin
      Logs.AddToLogs('--- Installation d''interbase XE ---');
      try
        Logs.AddToLogs('  -> Extraction d''IBXE');
        Res := TResourceStream.Create(HInstance,'IBXE',RT_RCDATA);
        Try
          Res.SaveToFile(GAPPTOOL + 'IbXe.7z');
        Finally
          Res.Free;
        End;

        Logs.AddToLogs('  -> Décompression du fichier');
        UnzipFile(GAPPTOOL + 'IbXe.7z',GAPPTEMP);

        Logs.AddToLogs('  -> Installation d''IBXE');
        case GINSTALLMODE of
          mrServer : iResult := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "' + GAPPTEMP + 'ib_install.exe' + Format(' /s /m=%sinstallsrv.txt /Log=%sibxeinstall.txt"',[GAPPTEMP, GAPPLOGS]));
          mrClient : iResult := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "' + GAPPTEMP + 'ib_install.exe' + Format(' /s /m=%sinstallclt.txt /Log=%sibxeinstall.txt"',[GAPPTEMP, GAPPLOGS]));
        end;
        Logs.AddToLogs('  -> intallation Ok');
        Logs.AddToLogs(Format('    - Retour d''installation : %d',[iResult]));

        if iResult <> 0 then
          raise Exception.Create('Erreur d''installation d''interbase XE');

        Img_E2InstXE.Picture := Img_Valid.Picture;
        Logs.AddToLogs('');
        Application.ProcessMessages;
      Except on E:Exception do
        begin
          Logs.AddToLogs('  -> Erreur : ' + E.Message);
          Img_E2InstXE.Picture := Img_Cancel.Picture;
          raise Exception.Create('Installation IBXE Erreur -> ' + E.Message);
        end;
      end;
    end;
    {$ENDREGION}

    {$REGION 'Installation du patch XE'}
    Logs.AddToLogs('--- Installation Patch d''interbase XE ---');
    try
      Logs.AddToLogs('  -> Arrêt du service interbase');
      ServiceStop('','IBG_gds_db');

      Logs.AddToLogs('  -> Arrêt Ibguard');
      KillProcessus('ibguard.exe');

      Logs.AddToLogs('  -> Arrêt Ibserver');
      KillProcessus('ibserver.exe');

      Logs.AddToLogs('  -> Installation du patch');
      case GINSTALLMODE of // SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe'
//        mrServer : iResult := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "' + GAPPTEMP + 'SetupIbUpdate.exe /VERYSILENT /SUPPRESSMSGBOXES /COMPONENTS=Serveur /LOG=install.log"');
        mrClient : iResult := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "ECHO N | ' + GAPPTEMP + Format('IBXE32Update.exe /s /m=%sPatchClt.txt"',[GAPPTEMP]));
      end;

      Logs.AddToLogs('  -> intallation Ok');
      Logs.AddToLogs(Format('    - Retour d''installation : %d',[iResult]));
//      if iResult <> 0 then
//        raise Exception.Create('Erreur d''installation du Patch Interbase XE');

      Img_E2InstPatchXE.Picture := Img_Valid.Picture;
      Logs.AddToLogs('');

      Application.ProcessMessages;
    Except on E:Exception do
      begin
        Logs.AddToLogs('  -> Erreur : ' + E.Message);
        Img_E2InstPatchXE.Picture := Img_Cancel.Picture;
        raise Exception.Create('Installation IBXE Erreur -> ' + E.Message);
      end;
    end;
    {$ENDREGION}
    {$ENDIF}

    {$REGION 'Copie des UDF'}
    case GINSTALLMODE of
      mrServer: begin
        Logs.AddToLogs('--- Copie des UDF ---');
        Reg := TRegistry.Create(KEY_READ);
        Try
          try
            Reg.RootKey := HKEY_LOCAL_MACHINE;
            if Reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db',False) then
            begin
              INTERBASEXEBINDIR := IncludeTrailingPathDelimiter(Reg.ReadString('ServerDirectory'));
              INTERBASEXEROOTDIR := IncludeTrailingPathDelimiter(Reg.ReadString('RootDirectory'));
            end
            else
                raise Exception.Create('IB XE n''est pas présent sur le poste');
          Except on E:Exception do
            begin
              Img_IBXE.Picture := Img_Cancel.Picture;
              raise EIBXEPRESENT.Create('  -> Erreur : ' + E.Message);
            end;
          end;
        Finally
          Reg.Free;
        End;

        Res := TResourceStream.Create(HInstance,'UDF1',RT_RCDATA);
        Try
          Res.SaveToFile(INTERBASEXEROOTDIR + 'UDF\BlobUDFLib.dll');
        Finally
          Res.Free;
        End;

        Res := TResourceStream.Create(HInstance,'UDF2',RT_RCDATA);
        Try
          Res.SaveToFile(INTERBASEXEROOTDIR + 'UDF\FreeUDFLib.dll');
        Finally
          Res.Free;
        End;
      end;
    end;
    {$ENDREGION}

    {$REGION 'Redémarrage du service'}
    Logs.AddToLogs('--- Redémarrage du service interbase');
    ServiceStart('','IBG_gds_db');
    {$ENDREGION}

    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape 2 - 2/2 - Terminé');
    Logs.AddToLogs('----------------------------------------');
end;

procedure Tfrm_MajIb7ToXEMain.Ax_E3RestoreExecute(Sender: TObject);
var
  lst : TStringList;
  SearchGBK, SearchIB : TSearchRec;
begin
  {$IFDEF POSTESERVEUR}
  if not (GIBINSTALL = ibComplet) then
    Exit;

  Try
    // Initialisation du logs
    Logs.Path := GAPPLOGS;
    Logs.FileName := Format('E3-Restore%s.log',[FormatDateTime('YYYYMMDDHHMMSS',Now)]);
    Logs.Memo := mmRestore_Logs;

    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape - 3 - Restore de la base en IB XE');
    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('');
    Pgc_ShowEtape.ActivePage := Tab_E3Restore;
    Application.ProcessMessages;

    Logs.AddToLogs('--- Vérification des dates des fichiers IB et GBK ---' );
    Logs.AddToLogs('  -> Fichier GBK : ' + edt_E3Source.Text);
    if FindFirst(edt_E3Source.Text,faAnyFile,SearchGBK) = 0 then
    begin
      Logs.AddToLogs('  -> Date Heure : ' + FormatDateTime('DD/MM/YYYY hh:mm:ss',SearchGBK.TimeStamp));
    end;

    Logs.AddToLogs('  -> Fichier IB : ' + edt_E3Destination.Text);
    if FindFirst(edt_E3Destination.Text,faAnyFile,SearchIB) = 0 then
    begin
      Logs.AddToLogs('  -> Date Heure : ' + FormatDateTime('DD/MM/YYYY hh:mm:ss',SearchIB.TimeStamp));
    end;

    if SearchGBK.TimeStamp < SearchIB.TimeStamp then
      if  SecondsBetween(SearchGBK.TimeStamp,SearchIB.TimeStamp) > 300 then
      begin
        if MessageDlg('La base de données semble plus récente que le fichier de backup,'#13#10'Etes vous sûr de vouloir continuer le traitement ?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
        begin
          Logs.AddToLogs('  - Fichier IB plus rescent, Annulation du traitement');
          Abort;
        end;
      end;
    Logs.AddToLogs('');

    Logs.AddToLogs('--- Restoration de la base de données ---');
//    Logs.AddToLogs('  -> Redémarrage du service interbase XE');
//    ServiceStart('','IBG_gds_db');
//    Logs.AddToLogs('  -> Redémarrage IbGuard');
//    Logs.AddToLogs(INTERBASEXEBINDIR);
//    ShellExecute(0,'OPEN',PWideChar(INTERBASEXEBINDIR + 'ibguard.exe'),' -a',PWideChar(INTERBASEXEBINDIR), SW_NORMAL);
//    DoWait(5000);

    if FileExists(GINKOIAIB) then
      DeleteFile(GINKOIAIB);

    Lst := TStringList.Create;
    try
      Logs.AddToLogs('  -> Démarrage du restore');
      Logs.AddToLogs('   - Source : ' + edt_E3Source.Text);
      Logs.AddToLogs('   - Destination : ' + edt_E3Destination.Text);
      DM_MajIb7ToXE := TDM_MajIb7ToXE.Create(Self);
      RestoreGBak(INTERBASEXEBINDIR,edt_E3Destination.Text,edt_E3Source.Text,0,0,0,Lst);
      Lst.SaveToFile(GAPPLOGS + ChangeFileExt(Logs.FileName,'') + '-GRest.log');
      Logs.AddToLogs('  -> Restore terminé');
    finally
      Lst.Free;
    end;

    Logs.AddToLogs('');
    Logs.AddToLogs('--- Récupération des informations d''intégritées ---');
    Logs.AddToLogs('');
    Logs.AddToLogs('  -> Traitement des tables & procédures stockées');
    // Récupération de la liste des table
    Cds_Restore.EmptyDataSet;
    Gbx_Progression.Visible := True;
    try
      GetDataDb(edt_E3Destination.Text,Cds_Restore,Lab_Progression,PBar_Main);
    finally
      Gbx_Progression.Visible := False;
    end;
    Logs.AddToLogs('  -> Sauvegade dans : ' + GAPPSAVE + 'E3-RestoreData.Xml');
    Cds_Restore.SaveToFile(GAPPSAVE + 'E3-RestoreData.Xml',dfXml);

    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape 3 - Terminé');
    Logs.AddToLogs('----------------------------------------');
  Except
    on E:EGBACKEXCEPTION do
      begin
        Logs.AddToLogs('Ax_E3RestoreExecute -> ' + E.Message);
        raise Exception.Create('Ax_E3RestoreExecute -> ' + E.Message);
      end;
    on E:Exception do
      begin
        Logs.AddToLogs('Ax_E3RestoreExecute -> ' + E.Message);
        raise Exception.Create('Ax_E3RestoreExecute -> ' + E.Message);
      end;
  End;
  {$ENDIF}
end;

procedure Tfrm_MajIb7ToXEMain.Ax_E4DiversExecute(Sender: TObject);
var
  bNotFound : Boolean;
  iResult : Integer;
  BaseGinDir : string;
  bErrorOnGenHisto : Boolean;
  iErrorOnGenhistoCount : Integer;
  bIsOnError : Boolean;
begin
    // Initialisation du logs
    Logs.Path := GAPPLOGS;
    Logs.FileName := Format('E4-Divers%s.log',[FormatDateTime('YYYYMMDDHHMMSS',Now)]);
    Logs.Memo := mmDivers_Logs;
    Pgc_ShowEtape.ActivePage := Tab_E4Divers;
    Application.ProcessMessages;

    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('Etape - 4 - Divers');
    Logs.AddToLogs('----------------------------------------');
    Logs.AddToLogs('');

    {$IFDEF POSTESERVEUR}
    if (GIBINSTALL = ibComplet) then
    begin
      {$REGION 'Comparaison des données'}
      Logs.AddToLogs('--- Comparaison des données ---');
      bNotFound := False;
      bErrorOnGenHisto := False;
      iErrorOnGenhistoCount := 0;
      Cds_Backup.First;

      Gbx_Progression.Visible := True;
      try
        Try
          Lab_Progression.Caption := 'Comparaison';
          PBar_Main.Position := 0;
          while not Cds_Backup.Eof do
          begin
            if not Cds_Restore.Locate('Type;Name',VarArrayOf([Cds_Backup.FieldByName('Type').AsInteger,Cds_Backup.FieldByName('Name').AsString]),[locaseinsensitive]) then
            begin
              bNotFound := True;
              Logs.AddToLogs('  -X Non trouvé : ' + Cds_Backup.FieldByName('Name').AsString);
            end
            else begin
              if Cds_Backup.FieldByName('Nb').AsInteger <> Cds_Restore.FieldByName('Nb').AsInteger then
              begin
                bIsOnError := True;
                // Cas avec GENHISTOEVT
                if Cds_Backup.FieldByName('Name').AsString = 'GENHISTOEVT' then
                begin
                  Logs.AddToLogs(Format('  - X Nombre d''enregistrements différent(Gestion automatique de l''erreur) - %s B:%d R:%d ',[Cds_Backup.FieldByName('Name').AsString,Cds_Backup.FieldByName('Nb').AsInteger,Cds_Restore.FieldByName('Nb').AsInteger]));
                  bErrorOnGenHisto := True;
                  iErrorOnGenhistoCount := Abs(Cds_Backup.FieldByName('Nb').AsInteger - Cds_Restore.FieldByName('Nb').AsInteger);
                  bIsOnError := False;
                end
                else begin
                  if (Cds_Backup.FieldByName('Name').AsString = 'K') and bErrorOnGenHisto then
                  begin
                    if Abs(Cds_Backup.FieldByName('Nb').AsInteger - Cds_Restore.FieldByName('Nb').AsInteger) = iErrorOnGenhistoCount then
                    begin
                      Logs.AddToLogs(Format('  - X Nombre d''enregistrements différent(Gestion automatique de l''erreur) - %s B:%d R:%d ',[Cds_Backup.FieldByName('Name').AsString,Cds_Backup.FieldByName('Nb').AsInteger,Cds_Restore.FieldByName('Nb').AsInteger]));
                      bIsOnError := False;
                    end;
                  end;
                end;

                if bIsOnError then
                begin
                  bNotFound := True;
                  Logs.AddToLogs(Format('  - X Nombre d''enregistrements différent - %s B:%d R:%d ',[Cds_Backup.FieldByName('Name').AsString,Cds_Backup.FieldByName('Nb').AsInteger,Cds_Restore.FieldByName('Nb').AsInteger]));
                end;
              end;
            end;

            Cds_Backup.Next;
            PBar_Main.Position := Cds_Backup.RecNo * 100 Div Cds_Backup.RecordCount;
            Application.ProcessMessages;
          end;

          if bNotFound then
            raise Exception.Create('Erreur lors de la comparaison des données');
          Img_E4Compare.Picture := Img_Valid.Picture;
          Application.ProcessMessages;
        Except on E:Exception do
          begin
            Img_E4Compare.Picture := Img_Cancel.Picture;
            Application.ProcessMessages;
            raise Exception.Create(E.Message);
          end;
        End;
      finally
        Gbx_Progression.Visible := False;
      end;
      {$ENDREGION}

      {$REGION 'Création des utilisateurs'}
      Logs.AddToLogs('--- Création des utilisateurs ---');
      iResult := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "' + INTERBASEXEBINDIR + 'gsec.exe -user sysdba -password masterkey -add ginkoia -pw ginkoia"');
      Logs.AddToLogs(Format('    - Retour d''installation : %d',[iResult]));
      {$ENDREGION}
    end;
    {$ENDIF}

    {$REGION 'Netoyage des répertoires'}
    Logs.AddToLogs('--- Suppression du répertoire d''interbase 7');
     Logs.AddToLogs('  -> Menu');
    if DelDirectory('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Ginkoia\Interbase') then
      Logs.AddToLogs('   - Suppression Ok')
    else
      Logs.AddToLogs('   - Suppression Erreur : C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Ginkoia\Interbase');

    Logs.AddToLogs('  -> Supression du répertoire IB7');
    if DelDirectory(ExcludeTrailingPathDelimiter(INTERBASE7ROOTDIR)) then
      Logs.AddToLogs('    - Suppression Ok')
    else
      Logs.AddToLogs('   - Suppression Echec : ' + ExcludeTrailingPathDelimiter(INTERBASE7ROOTDIR));

    Logs.AddToLogs('  -> Supression du répertoire outils');
    if DelDirectory(ExcludeTrailingPathDelimiter(GAPPTOOL)) then
      Logs.AddToLogs('    - Suppression Ok')
    else
      Logs.AddToLogs('   - Suppression Echec : ' + ExcludeTrailingPathDelimiter(GAPPTOOL));

    Logs.AddToLogs('  -> Supression du répertoire Temporaire');
    if DelDirectory(ExcludeTrailingPathDelimiter(GAPPTEMP)) then
      Logs.AddToLogs('    - Suppression Ok')
    else
      Logs.AddToLogs('   - Suppression Echec : ' + ExcludeTrailingPathDelimiter(GAPPTEMP));
    {$ENDREGION}

    {$IFDEF POSTESERVEUR}
    if (GIBINSTALL = ibComplet) then
    begin
      {$REGION 'Copie de la base pour restauration XE'}
  {
      nom du fichier de base : GINKOIAIB;
      Repertoir du fichier de base : GINKOIAIBDIR;
      Repertoire de ginkoia : ExtractFilePath(ExcludeTrailingPathDelimiter(GINKOIAIBDIR));
  }
      BaseGinDir := ExtractFilePath(ExcludeTrailingPathDelimiter(GINKOIAIBDIR));
      try
        Logs.AddToLogs('  -> Remplacement du fichier de sauvegarde de Patch.exe');
        if DirectoryExists(BaseGinDir + 'Sauve\') then
        begin
          if FileExists(BaseGinDir + 'Sauve\ib7_BASES.IB') then
            DeleteFile(BaseGinDir + 'Sauve\ib7_BASES.IB');
          if FileExists(BaseGinDir + 'Sauve\BASES.IB') then
            RenameFile(BaseGinDir + 'Sauve\BASES.IB', BaseGinDir + 'Sauve\ib7_BASES.IB');
          if CopyFile(PChar(GINKOIAIB), PChar(BaseGinDir + 'Sauve\BASES.IB'),false) then
            Logs.AddToLogs('   - Remplacement OK')
          else
          begin
            // La copie n'a pas réussi retour en arrière
            DeleteFile(BaseGinDir + 'Sauve\BASES.IB');
            RenameFile(BaseGinDir + 'Sauve\ib7_BASES.IB',BaseGinDir + 'Sauve\BASES.IB');

            Logs.AddToLogs('   - Remplacement KO');
            Logs.AddToLogs('');
            Logs.AddToLogs('ATTENTION : le remplacement de la base IB7 par la base XE dans les sauvegarde de patch n''a pas été fait !');
            Logs.AddToLogs('            Si patch ne fonctionne pas le retour en arriere ne sera pas fonctionnel !');
            Logs.AddToLogs('');
          end;
        end
        else
          Logs.AddToLogs('   - Pas de repertoire de sauvegarde de Patch.exe');
      except
        on e: exception do
        begin
          Logs.AddToLogs('   - Remplacement KO (' + e.ClassName + ' - ' + e.Message + ')');
          Logs.AddToLogs('');
          Logs.AddToLogs('ATTENTION : le remplacement de la base IB7 par la base XE dans les sauvegarde de patch n''a pas été fait !');
          Logs.AddToLogs('            Si patch ne fonctionne pas le retour en arriere ne sera pas fonctionnel !');
          Logs.AddToLogs('');
        end;
      end;
      {$ENDREGION}
    end;
    {$ENDIF}
end;

procedure Tfrm_MajIb7ToXEMain.CategoryButtons1Categories5Items0Click(
  Sender: TObject);
begin
  Logs.FileName := 'Test.txt';
  Logs.Path := GAPPLOGS;
  IdMessage1.Body.Clear;
  IdMessage1.Body.Add('--- Migration du poste ---');
  IdMessage1.From.Text := 'Admin@ginkoia.fr';
  IdMessage1.Recipients.EMailAddresses := 'thierry.fleisch@ginkoia.fr, migrationxe@ginkoia.fr, adminginkoia@gmail.com';
  IdMessage1.Subject := 'test d''envoi';
    // Envoi du mail
  SendMail(IdMessage1);

end;

procedure Tfrm_MajIb7ToXEMain.ExecuteProcess(AMode: TModeRun; Etape : Integer = E0Initialisation);
var
  ModeStr : string;
  Res : TResourceStream;
  bOnError : Boolean;
  sMailSubject, sGinkoiaDir, sDirTmp : String;
  lst : TStringList;
  i : Integer;
  Search : TSearchRec;
  Mail : TIdEMailAddressItem;
  IniFile : string;
begin
  bOnError := False;
  IsAppWorking := True;
  try
    while Etape <> EExit do
    begin
      case Etape of
        E0Initialisation : begin
          CategoryButtons1.Categories.Items[0].Color := clYellow;
          try
            Ax_E0Initialisation.Execute;
            Etape := E1BackUp;
            CategoryButtons1.Categories.Items[0].Color := clGreen;
          Except on  E:Exception do
            begin
              CategoryButtons1.Categories.Items[0].Color := clRed;
              {$IFDEF POSTESERVEUR}
              if not Assigned(DM_MajIb7ToXE) then
                DM_MajIb7ToXE := TDM_MajIb7ToXE.Create(Self);
              DM_MajIb7ToXE.GetInfoBase(GINKOIAIB);
              {$ENDIF}
              raise;
            end;
          end;
        end; // E0Initialisation

        E1BackUp: begin
          CategoryButtons1.Categories.Items[1].Color := clYellow;
          try
            if GINSTALLMODE = mrServer then
            begin
              edt_BackUpSource.Text := GINKOIAIB;
              edt_BackupDestination.Text := GAPPSAVE + ChangeFileExt(ExtractFileName(GINKOIAIB),'.gbk');

              Ax_E1Backup.Execute;
            end;
            Etape := E2Installation12;
            CategoryButtons1.Categories.Items[1].Color := clGreen;
          Except on  E:Exception do
            begin
              CategoryButtons1.Categories.Items[1].Color := clRed;
              raise;
            end;
          end;
        end; // E1BackUp

        E2Installation12: begin
          CategoryButtons1.Categories.Items[2].Color := clYellow;
          try
            Ax_E2Install.Execute;

            case GINSTALLMODE of
              mrServer : ModeStr := 'SERVEUR';
              mrClient : ModeStr := 'CLIENT';
            end;

            if GINSTALLMODE = mrServer then
            begin
              // Sauvegarde du répertoire du logs pour récupération arpès le reboot
              with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
              try
                WriteString('LASTLOGS','LOGSPATH',GAPPLOGS);
                WriteString('DIR','IB7PATH',INTERBASE7ROOTDIR);
              finally
                Free;
              end;

              // Sauvegarde des données de la base
              InfoBase.SaveIni;

              case GIBINSTALL of
                ibComplet: begin
                  // reboot de l'application
                  Res := TResourceStream.Create(HInstance,'REBOOT',RT_RCDATA);
                  Try
                    Res.SaveToFile(GAPPTEMP + 'Reboot.bat');
                  Finally
                    Res.Free;
                  End;
                  Logs.AddToLogs('RunOnce : ' + SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe /c "' + GAPPTEMP + Format('Reboot.bat %s %s %s"',[GAPPPATH,SpecialFolder(CSIDL_SYSTEM),GAPPTEMP])); //Format('%s %s %s',[Application.ExeName,ModeStr,'ETAPE22']));
                  RestartAndRunOnce(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe /c "' + GAPPTEMP + Format('Reboot.bat %s %s %s"',[GAPPPATH,SpecialFolder(CSIDL_SYSTEM),GAPPTEMP])); //Format('%s %s %s',[Application.ExeName,ModeStr,'ETAPE22']));
                end;
                ibPatchOnly: begin
                  // reboot de l'application
                  Res := TResourceStream.Create(HInstance,'PatchOnly',RT_RCDATA);
                  Try
                    Res.SaveToFile(GAPPTEMP + 'RebootPatchOnly.bat');
                  Finally
                    Res.Free;
                  End;

                  Logs.AddToLogs('RunOnce : ' + SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe /c "' + GAPPTEMP + Format('RebootPatchOnly.bat %s %s %s"',[GAPPPATH,SpecialFolder(CSIDL_SYSTEM),GAPPTEMP])); //Format('%s %s %s',[Application.ExeName,ModeStr,'ETAPE22']));
                  RestartAndRunOnce(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe /c "' + GAPPTEMP + Format('RebootPatchOnly.bat %s %s %s"',[GAPPPATH,SpecialFolder(CSIDL_SYSTEM),GAPPTEMP])); //Format('%s %s %s',[Application.ExeName,ModeStr,'ETAPE22']));
                end;
              end;
            end
            else
              Etape := E2Installation22;
          Except on  E:Exception do
            begin
              CategoryButtons1.Categories.Items[2].Color := clRed;
              raise;
            end;
          end;
        end; // E2Installation12

        E2Installation22: begin
          CategoryButtons1.Categories.Items[2].Color := clYellow;
          try
            Ax_E2Install22.Execute;
            CategoryButtons1.Categories.Items[2].Color := clGreen;
            Etape := E3Restore;
          Except on  E:Exception do
            begin
              CategoryButtons1.Categories.Items[2].Color := clRed;
              raise;
            end;
          end;
        end; // E2Installation22

        E3Restore: begin
          CategoryButtons1.Categories.Items[3].Color := clYellow;
          try
            if GINSTALLMODE = mrServer then
            begin
              edt_E3Source.Text := GAPPSAVE + ChangeFileExt(ExtractFileName(GINKOIAIB),'.gbk');
              edt_E3Destination.Text := GINKOIAIB;
              Ax_E3Restore.Execute;
            end;
            CategoryButtons1.Categories.Items[3].Color := clGreen;
           Etape := E4Divers;
          Except on  E:Exception do
            begin
              CategoryButtons1.Categories.Items[3].Color := clRed;
              raise;
            end;
          end;

   //       raise Exception.Create('Juste pour qu''il y ai une erreur');
        end; // E3Restore

        E4Divers: begin
          CategoryButtons1.Categories.Items[4].Color := clYellow;
          try
            Ax_E4Divers.Execute;
            CategoryButtons1.Categories.Items[4].Color := clGreen;
           Etape := EExit;
          Except on  E:Exception do
            begin
              CategoryButtons1.Categories.Items[4].Color := clRed;
              raise;
            end;
          end;
        end;  // E4Divers

      end; // case
    end;
  Except on E:Exception do
    begin
      Logs.AddToLogs(E.Message);
      bOnError := True;
    end;
  end;

  Logs.AddToLogs('');

  {$REGION 'Gestion du mail'}
  // Création du corps du mail
  IdMessage1.Body.Clear;
  IdMessage1.Body.Add('--- Migration du poste ---');
  IdMessage1.From.Text := 'Admin@ginkoia.fr';

  Mail := IdMessage1.Recipients.Add;
  Mail.Address := 'thierry.fleisch@ginkoia.fr';

  Mail := IdMessage1.Recipients.Add;
  Mail.Address := 'adminginkoia@gmail.com';

  if bOnError then
    sMailSubject := 'Echec'
  else
    sMailSubject := 'Réussie';

  case GINSTALLMODE of
    mrClient: begin
      sGinkoiaDir := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

      IniFile := sGinkoiaDir + 'CaisseGinkoia.ini';
      If not FileExists(IniFile) then
        IniFile := sGinkoiaDir + 'Ginkoia.ini';

      With TIniFile.Create(IniFile) do
      try
        IdMessage1.Subject := Format('Migration IB 7 vers IbXE -> Client %s : %s - %s',[sMailSubject,ReadString('NOMMAGS','MAG0',''),ReadString('NOMPOSTE','POSTE0','')]);
        lst := TStringList.Create;
        try
          IdMessage1.Body.Add('Bonjour,');
          IdMessage1.Body.Add('');
          ReadSections('NOMMAGS',Lst);
          IdMessage1.Body.Add('[NOMMAGS]');
          for i := 0 to lst.Count -1 do
            IdMessage1.Body.Add(lst[i]);
          IdMessage1.Body.Add('');
          IdMessage1.Body.Add('[NOMPOSTE]');
          ReadSections('NOMPOSTE',Lst);
          for i := 0 to lst.Count -1 do
            IdMessage1.Body.Add(lst[i]);
          IdMessage1.Body.Add('');
          IdMessage1.Body.Add('[NOMBASE]');
          ReadSections('NOMBASE',Lst);
          for i := 0 to lst.Count -1 do
            IdMessage1.Body.Add(lst[i]);
          IdMessage1.Body.Add('');
          IdMessage1.Body.Add('Bonne recherche...');
        finally
          Lst.Free;
        end;
      finally
        Free;
      end;
    end; // mrClient

    mrServer: begin
      IdMessage1.Subject := Format('Migration IB 7 vers IbXE -> Serveur %s : %s - %s',[sMailSubject,InfoBase.CodeTiers,InfoBase.NomBase]);
      IdMessage1.Body.Add('');
      IdMessage1.Body.Add('Code Tiers : ' + InfoBase.CodeTiers);
      IdMessage1.Body.Add('Magasin : ' + InfoBase.Magasin);
      IdMessage1.Body.Add('Adresse : ' + InfoBase.Infos.Adresse);
      IdMessage1.Body.Add(Format('CP/Ville : %s / %s',[InfoBase.Infos.CodePostal,InfoBase.Infos.Ville]));
      IdMessage1.Body.Add('Téléphone : ' + InfoBase.Infos.Telephone);
    end;  // mrServer
  end; // Case

  // Gestion des pièces jointes
  if bOnError then
  begin
    // Récupération de la liste des fichiers de logs si on est en erreur (E*.*)
    Logs.AddToLogs(GAPPLOGS + '*.*');
    i := FindFirst(GAPPLOGS + '*.*',faAnyFile,Search);
    try
      while i = 0 do
      begin
       if (Search.Name <> '.') and (Search.Name <> '..') then
         if Pos('-G',Search.Name) = 0  then
         begin
           Logs.AddToLogs('Envoi du fichier :' + Search.Name);
           TIdAttachmentFile.Create(IdMessage1.MessageParts,GAPPLOGS + Search.Name);
         end;
        i := FindNext(Search);                
      end;
    finally
      FindClose(Search);
    end;
  end;

  IsAppWorking := False;
  // Envoi du mail
  SendMail(IdMessage1);
  {$ENDREGION}

  {$IFDEF POSTESERVEUR}
  if IsLaunchVerifAuto then
  begin
    // Demarrage de vérification en auto
     sDirTmp := 'c:\ginkoia\verification.exe';
     if not FileExists(sDirTmp) then
       sDirTmp := 'd:\ginkoia\verification.exe';

    ShellExecute(Handle,'OPEN',PWideChar(sDirTmp),PWideChar(' AUTO'),PWideChar(ExtractFilePath(sDirTmp)),SW_NORMAL);
    {$ENDIF}
  end;

  Application.Terminate;
end;

procedure Tfrm_MajIb7ToXEMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not IsAppWorking;
end;

procedure Tfrm_MajIb7ToXEMain.FormCreate(Sender: TObject);
var
  Reg : TRegistry;
  Res : TResourceStream;
  i,j   : Integer;
  bAutoStart, bAutoStart22 : Boolean;
  bParamFound : Boolean;
  sPassValue : String;
begin
  IsAppWorking := False;
  // Gestion des paramètres
  {$IFDEF POSTESERVEUR}
  GINSTALLMODE := mrServer;
  {$ELSE}
  GINSTALLMODE := mrClient;
  {$ENDIF}
  bAutoStart := False;
  bAutoStart22 := False;
  IsLaunchVerifAuto := True;

  bParamFound := False;
  for i := 1 to ParamCount do
  begin
    case AnsiIndexStr(UpperCase(ParamStr(i)),['SERVER', 'CLIENT', 'ETAPE22', 'AUTO', 'NOVERIF']) of
      0: begin // SERVER
        GINSTALLMODE := mrServer;
      end; // 0- SERVER

      1: begin // CLIENT
        GINSTALLMODE := mrClient;
      end; // 0- CLIENT

      2: begin  // ETAPE22
        LockComponents;
        for j := 0 to CategoryButtons1.Categories.Count -1 do
        begin
          CategoryButtons1.Categories.Items[j].Collapsed := True;
          if j < 2 then
            CategoryButtons1.Categories.Items[j].Color := clGreen;
        end;

        for j := 0 to Pgc_ShowEtape.PageCount -1 do
          Pgc_ShowEtape.Pages[j].TabVisible := False;

        bAutoStart22 := True;
        Lab_Alert.Visible := True;
        Tim_Alert.Enabled := True;
        bParamFound := True;
      end; // ETAPE22

      3: begin // AUTO
        LockComponents;
        for j := 0 to CategoryButtons1.Categories.Count -1 do
          CategoryButtons1.Categories.Items[j].Collapsed := True;

        for j := 0 to Pgc_ShowEtape.PageCount -1 do
          Pgc_ShowEtape.Pages[j].TabVisible := False;

        bAutoStart := True;
        Lab_Alert.Visible := True;
        Tim_Alert.Enabled := True;
        bParamFound := True;
        end;
        4: begin
          IsLaunchVerifAuto := False;
        end;
    end; // case
  end; // for

  {$REGION 'Gestion du mot de passe'}
  if not bParamFound then
    if InputPassword('Veuillez saisir le mot de passe','',sPassValue) then
      if UpperCase(sPassValue) = 'GINKOIA1082' then
        bParamFound := True;

  if not bParamFound then
    Application.Terminate;
  {$ENDREGION}
  
  // Initialisation
  GAPPPATH := ExtractFilePath(Application.ExeName);
  GAPPTEMP := GAPPPATH + 'Tmp\';
  GAPPSAVE := GAPPPATH + 'Save\';
  GAPPTOOL := GAPPPATH + 'Outils\';

  DoDir(GAPPTEMP);
  DoDir(GAPPSAVE);
  DoDir(GAPPTOOL);

  // Si un fichier ini est présent c'est qu'on a rebooté
  if (GINSTALLMODE = mrServer) and FileExists(ChangeFileExt(Application.ExeName,'.ini')) then
  begin
    // récupération du répertoire de logs
    with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      GAPPLOGS := ReadString('LASTLOGS','LOGSPATH','');
      INTERBASE7ROOTDIR := ReadString('DIR','IB7PATH','');
    finally
      Free;
    end;
    // Récupération des informations de la base de données
    InfoBase.LoadIni;

    // Suppression du fichier ini
    DeleteFile(ChangeFileExt(Application.ExeName,'.ini'));

    {$IFDEF POSTESERVEUR}
    // chargement du fichier de comparaison du backup pour la suite
    if FileExists(GAPPSAVE + 'E1-BackupData.Xml') then
      Cds_Backup.LoadFromFile(GAPPSAVE + 'E1-BackupData.Xml');
    {$ENDIF}
  end
  else  begin
    GAPPLOGS := GAPPPATH + 'Logs\' + FormatDateTime('YYYYMMDDHHMMSS',Now) + '\';
    DoDir(GAPPLOGS);
  end;

  // Récupération du répertoire de ginkoia
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Algol\Ginkoia', False);
    GINKOIAIBDIR := ExtractFilePath(reg.ReadString('Base0'));
    GINKOIAIB := reg.ReadString('Base0');
  finally
    reg.free;
  end;

  // Extraction de la DLL 7z
  if not FileExists(GAPPPATH + '7z.dll') then
  begin
    Res := TResourceStream.Create(HInstance,'7ZDLL',RT_RCDATA);
    try
      Res.SaveToFile(GAPPPATH + '7z.dll');
    finally
      Res.Free;
    end;
  end;

  {$IFDEF POSTESERVEUR}
  // Attendre que patch.exe ne soit plus en mémoire
  while IsProcessInMemory('Patch.exe') do
  begin
    Sleep(1000);
    Application.ProcessMessages;
  end;
  {$ENDIF}

  if bAutoStart then
    Tim_StartAuto.Enabled := True;

  if bAutoStart22 then
    Tim_StartEtape22.Enabled := True;

  case GINSTALLMODE of
    mrServer : Caption := Caption + ' - Mode Serveur';
    mrClient : Caption := Caption + ' - Mode Client';
  end;

end;

procedure Tfrm_MajIb7ToXEMain.LockComponents;
begin
  CategoryButtons1.Enabled := False;
  Pgc_ShowEtape.Enabled := False;
  Gbx_BackupBottom.Visible := False;
  Nbt_BackUpSource.Visible := False;
  Nbt_BackUpDestination.Visible := False;
  nbt_E3Source.Visible := False;
  nbt_E3Destination.Visible := False;
  Gbx_E3Actions.Visible := False;

end;

procedure Tfrm_MajIb7ToXEMain.Nbt_BackupDemarrerClick(Sender: TObject);
begin
  if trim(edt_BackUpSource.Text) = '' then
  begin
    ShowMessage('Veuillez sélectionner un fichier IB');
    edt_BackUpSource.SetFocus;
    Exit;
  end;

  if trim(edt_BackupDestination.Text) = '' then
  begin
    ShowMessage('Veuillez saisir un chemin et un nom pour le fichier de backup');
    edt_BackupDestination.SetFocus;
    Exit;
  end;

  Ax_E1Backup.Execute;
end;

procedure Tfrm_MajIb7ToXEMain.Nbt_BackUpDestinationClick(Sender: TObject);
begin
  With OD_Destination do
  begin
    InitialDir := GINKOIAIBDIR;
    Filter := 'Base de données|*.Gbk';
    FileName := 'Ginkoia.Gbk';
    Title := 'Veuillez indiquer le chemin et le nom du fichier backup';
    if Execute then
      edt_BackupDestination.Text := FileName;
  end;
end;

procedure Tfrm_MajIb7ToXEMain.Nbt_BackUpSourceClick(Sender: TObject);
begin
  With OD_Source do
  begin
    InitialDir := GINKOIAIBDIR;
    Filter := 'Base de données|*.Ib';
    Title := 'Veuillez sélectionner une base de données';
    if Execute then
      edt_BackUpSource.Text := FileName;
  end;
end;

procedure Tfrm_MajIb7ToXEMain.Nbt_E3ActionsClick(Sender: TObject);
begin
  Ax_E3Restore.Execute;
end;

procedure Tfrm_MajIb7ToXEMain.nbt_E3DestinationClick(Sender: TObject);
begin
  With OD_Destination do
  begin
    InitialDir := GINKOIAIBDIR;
    FileName := 'Ginkoia.Ib';
    Filter := 'Base de données|*.Ib';
    Title := 'Veuillez indiquer le chemin et le nom du fichier base de données';
    if Execute then
      edt_E3Destination.Text := FileName;
  end;
end;

procedure Tfrm_MajIb7ToXEMain.nbt_E3SourceClick(Sender: TObject);
begin
  With OD_Source do
  begin
    InitialDir := GAPPSAVE;
    Filter := 'Base de données|*.Gbk';
    FileName := 'Ginkoia.Gbk';
    Title := 'Veuillez sélectionner une fichier backup';
    if Execute then
      edt_E3Source.Text := FileName;
  end;
end;

procedure Tfrm_MajIb7ToXEMain.SendMail(AMessage: TIdMessage);
begin
  with IdSMTP1 do
  try
    Disconnect();
    Host     := 'pod51015.outlook.com';
    Username := 'Admin@ginkoia.fr';
    Password := 'Duda7196741';
    Try
      Port := 587;
      Logs.AddToLogs('Test Port 587');
      Connect;
    Except on E:Exception do
      begin
        try
        Port := 25;
        Logs.AddToLogs('Test Port 25');
        Connect;
        Except on E:Exception do
          raise Exception.Create('SendMailList Connexion -> ' + E.Message);
        end;
      end;
    End;
    Logs.AddToLogs('Tentative envoi du mail');
    Send(AMessage);
    Logs.AddToLogs('Mail envoyé');
  Except on E:Exception do
    begin
      Logs.Memo := nil;
      Logs.Path := GAPPLOGS;
      Logs.FileName := 'MailSend.txt';
      Logs.AddToLogs(E.Message);
    end;
  end;
end;

procedure Tfrm_MajIb7ToXEMain.StopAppAndServices;
const
  ginkoia     = 'ginkoia.exe';
  Caisse      = 'CaisseGinkoia.exe';
  Script      = 'Script.exe';
  PICCO       = 'Piccolink.exe';
  LauncherV7  = 'LaunchV7.exe';
  SyncWeb     = 'SyncWeb.exe';
begin
  Logs.AddToLogs('--- Arrêt des applications et services ---');
  Logs.AddToLogs('  -> Maj Windows');
  ServiceStop('','wuauserv');
  Logs.AddToLogs('  -> Launcher');
  KillProcessus(LauncherV7);
  Logs.AddToLogs('  -> Ginkoia');
  KillProcessus(ginkoia);
  Logs.AddToLogs('  -> Caisse');
  KillProcessus(Caisse);
  Logs.AddToLogs('  -> Script');
  KillProcessus(Script);
  Logs.AddToLogs('  -> Piccolink');
  KillProcessus(PICCO);
  Logs.AddToLogs('  -> SyncWeb');
  KillProcessus(SyncWeb);
end;

procedure Tfrm_MajIb7ToXEMain.Tim_AlertTimer(Sender: TObject);
begin
  if Lab_Alert.Font.Color = clred then
    Lab_Alert.Font.Color := clMaroon
  else
    Lab_Alert.Font.Color := clRed;
  Application.ProcessMessages;
end;

procedure Tfrm_MajIb7ToXEMain.Tim_StartAutoTimer(Sender: TObject);
begin
  Tim_StartAuto.Enabled := False;
  ShowWindow(Handle,SW_SHOWNORMAL);
  ExecuteProcess(GINSTALLMODE);

end;

procedure Tfrm_MajIb7ToXEMain.Tim_StartEtape22Timer(Sender: TObject);
begin
  Tim_StartEtape22.Enabled := False;
  ShowWindow(Handle,SW_SHOWNORMAL);
  ExecuteProcess(GINSTALLMODE,E2Installation22);
end;

end.
