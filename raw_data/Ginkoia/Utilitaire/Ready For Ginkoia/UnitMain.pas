//------------------------------------------------------------------------------
// Nom de l'unité :   UnitMain
// Rôle           :   Fiche principale de l'installation automatique de Ginkoia
// Auteur         :   Laurent BERNE
// Historique     :
// 05/10/2001-Laurent BERNE - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT UnitMain;

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
   AlgolStdFrm,
   dxfColorButton,
   StdCtrls,
   Registry,
   ComCtrls,
   ExtCtrls,
   dxfProgressBar,
   dxfBackGround,
   Buttons,
   ArtLabel,
   dxfCheckBox,
   inifiles,
   FileCtrl,
   abfComponents,
   Probleme_frm,
   LMDCustomComponent,
   LMDContainerComponent,
   lmdmsg;

TYPE
   TFrmBase = CLASS ( TForm )
      Memo1: TMemo;
      Panel1: TPanel;
      ProgressBar1: TProgressBar;
      dxfBackGround1: TdxfBackGround;
      SpeedButton1: TSpeedButton;
      ArtLabel1: TArtLabel;
      Panel2: TPanel;
      GroupBox1: TGroupBox;
      CheckLog: TdxfCheckBox;
      CheckPopUp: TdxfCheckBox;
      Save: TSaveDialog;
      Open: TOpenDialog;
      DriveComboBox1: TDriveComboBox;
      Label1: TLabel;
      shtDwn_Arret: TabfShutdown;
      Msg: TLMDMessageBoxDlg;
      PROCEDURE Action ( Sender: TObject ) ;
      PROCEDURE AlgolStdFrmActivate ( Sender: TObject ) ;
   Private
      PROCEDURE Regression;
    { Private declarations }
   Protected
    { Protected declarations }
   Public
    { Public declarations }
   Published
    { Published declarations }
   END;

VAR
   FrmBase: TFrmBase;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION

USES UnitObject;

//USES ConstStd;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrmBase.Regression;

   PROCEDURE Copier ( Disk: STRING ) ;
   VAR
      S,
         SrcF, Desf,
         Src, Dst: STRING;
      F: TSearchRec;
      ini: Tinifile;
      i: integer;
   BEGIN
      dst := Disk + ':\GINKOIA\';
      Src := Disk + ':\GINBCKUP\';
      ForceDirectories ( Dst ) ;
      IF findfirst ( Src + '*.Exe', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            SrcF := Src + F.Name;
            DesF := Dst + F.Name;
            CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) ;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      IF findfirst ( Src + '*.INI', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            SrcF := Src + F.Name;
            DesF := Dst + F.Name;
            CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) ;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      dst := Disk + ':\GINKOIA\EAI\XML\';
      Src := Disk + ':\GINBCKUP\EAI\XML\';
      ForceDirectories ( Dst ) ;
      IF findfirst ( Src + '*.*', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            IF ( F.name <> '.' ) AND ( F.name <> '..' ) THEN
            BEGIN
               IF F.Attr AND faDirectory <> faDirectory THEN
               BEGIN
                  SrcF := Src + F.Name;
                  DesF := Dst + F.Name;
                  CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) ;
               END;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      dst := Disk + ':\GINKOIA\EAI\';
      Src := Disk + ':\GINBCKUP\EAI\';
      ForceDirectories ( Dst ) ;
      IF findfirst ( Src + '*.*', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            IF ( F.name <> '.' ) AND ( F.name <> '..' ) THEN
            BEGIN
               IF F.Attr AND faDirectory <> faDirectory THEN
               BEGIN
                  IF uppercase ( extractfileext ( F.Name ) ) <> '.EXE' THEN
                  BEGIN
                     SrcF := Src + F.Name;
                     DesF := Dst + F.Name;
                     CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) ;
                  END;
               END;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      dst := Disk + ':\GINKOIA\DATA\RAPPORT\';
      Src := Disk + ':\GINBCKUP\DATA\RAPPORT\';
      ForceDirectories ( Dst ) ;
      IF findfirst ( Src + '*.*', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            IF ( F.name <> '.' ) AND ( F.name <> '..' ) THEN
            BEGIN
               IF F.Attr AND faDirectory <> faDirectory THEN
               BEGIN
                  SrcF := Src + F.Name;
                  DesF := Dst + F.Name;
                  CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) ;
               END;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      dst := Disk + ':\GINKOIA\BPL\';
      Src := Disk + ':\GINBCKUP\BPL\';
      ForceDirectories ( Dst ) ;
      IF findfirst ( Src + '*.*', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            IF ( F.name <> '.' ) AND ( F.name <> '..' ) THEN
            BEGIN
               IF F.Attr AND faDirectory <> faDirectory THEN
               BEGIN
                  SrcF := Src + F.Name;
                  DesF := Dst + F.Name;
                  CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) ;
               END;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      dst := Disk + ':\GINBCKUP\';
      ini := Tinifile.create ( Disk + ':\GINKOIA\Ginkoia.ini' ) ;
      TRY
         i := 0;
         REPEAT
            s := ini.readString ( 'DATABASE', 'PATH' + inttostr ( i ) , '' ) ;
            inc ( i ) ;
            IF s <> '' THEN
            BEGIN
               desf := S;
               delete ( S, 1, pos ( '\', S ) ) ;
               delete ( S, 1, pos ( '\', S ) ) ;
               srcf := dst + S;
               ForceDirectories ( extractfilepath ( desf ) ) ;
               CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) ;
            END;
         UNTIL s = '';
      FINALLY
         ini.free;
      END;
   END;

VAR
   S : STRING;
BEGIN
   Memo1.Lines.Add ( 'Récupération de l''ancienne version' ) ;
   Update;
   S := Copy ( DriveComboBox1.items[DriveComboBox1.itemindex], 1, 1 ) ;
   IF fileexists ( S + ':\GINBCKUP\ginkoia.exe' ) THEN
      Copier ( S ) ;
   Application.CreateForm ( TDial_Probleme, Dial_Probleme ) ;
   TRY
      Dial_Probleme.ShowModal;
   FINALLY
      Dial_Probleme.free;
   END;
   Close;
END;

FUNCTION Enumerate ( hwnd: HWND; Param: LPARAM ) : Boolean; Stdcall; Far;
VAR
   lpClassName: ARRAY[0..999] OF Char;
   lpClassName2: ARRAY[0..999] OF Char;
   Handle: DWORD;
   // lpdwProcessId: Pointer;
BEGIN
   result := true;
   Windows.GetClassName ( hWnd, lpClassName, 500 ) ;
   IF Uppercase ( StrPas ( lpClassName ) ) = 'TAPPLICATION' THEN
   BEGIN
      Windows.GetWindowText ( hWnd, lpClassName2, 500 ) ;
      IF StrPas ( lpClassName2 ) = 'Le Launcher' THEN
      BEGIN
         GetWindowThreadProcessId ( hWnd, @Handle ) ;
         TerminateProcess ( OpenProcess ( PROCESS_ALL_ACCESS, False, Handle ) , 0 ) ;
         result := False;
      END;
   END;
END;

PROCEDURE TFrmBase.Action ( Sender: TObject ) ;
VAR
   OldRelease: TGNKReleaseLB;
   NewRelease: TGNKReleaseLB;
   Migration: TGNKMigrationLB;
   OldParams: TGNKInstallModuleParamsLB;
   NewParams: TGNKInstallModuleParamsLB;
    // iComponent: integer;
   OldReleasePath: STRING;
   NewReleasePath: STRING;
   Reg: TRegistry;
   F : TsearchRec;
   nb: integer;
   FaireLaCopy: Boolean;

   AncienReg,
      PathPass,
      PathAppli: STRING;

   FF: TextFile;
   erreur: TErrorMigration;

   // Param: LPARAM;

   Letemps :Dword ;
BEGIN
   AncienReg := '';
   IF Sender <> NIL THEN
   BEGIN
      IF NOT ( ( ParamCount > 0 ) AND ( ParamStr ( 1 ) = 'MANU' ) ) THEN
      BEGIN
         IF Msg.Execute ( 'Relancer le système',
            #10#13' Pour une installation sans problème, ' +
            #10#13'   Votre machine doit être relancée'#10#13 +
            #10#13'Vous devez sortir de toutes les caisses'#10#13 +
            'Vous ne devez pas travailler sur Ginkoia'#10#13 +
            #10#13'                ATTENTION' +
            #10#13'Votre réplication ou une sauvegarde sur ZIP' +
            #10#13'       doit être faite et à jour' +
            #10#13'   Voulez-vous relancer la machine ?'#10#13
            ,
            [], [MBOK, MbCancel], Ord ( mtConfirmation ) , 0, 0, 0, 1 ) = MrOk THEN
         BEGIN

            Reg := TRegistry.Create;
            TRY
               Reg.RootKey := HKEY_LOCAL_MACHINE;
               IF Reg.OpenKey ( '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False ) THEN
               BEGIN
                  AncienReg := Reg.ReadString ( 'Launch_Replication' ) ;
                  IF AncienReg <> '' THEN
                  BEGIN
                     AssignFile ( FF, 'C:\Launch.~~~' ) ;
                     rewrite ( ff ) ;
                     Writeln ( ff, AncienReg ) ;
                     Closefile ( FF ) ;
                     AncienReg := '';
                  END;
               END;
               Reg.CloseKey;
               Reg.RootKey := HKEY_CURRENT_USER;
               IF Reg.OpenKey ( '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce', True ) THEN
               BEGIN
                  Reg.WriteString ( 'ALGOL', Application.ExeName + ' Automatique' ) ;
               END;
               Reg.RootKey := HKEY_LOCAL_MACHINE;
               Reg.CloseKey;
               IF Reg.OpenKey ( '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False ) THEN
               BEGIN
                  Reg.DeleteValue ( 'Launch_Replication' ) ;
               END;
            FINALLY
               Reg.CloseKey;
               Reg.Free;
            END;
            shtDwn_Arret.execute;
         END;
         Close;
         exit;
      END;
   END;
   Screen.Cursor := CrHourGlass;
   TRY
      IF ( ParamCount > 0 ) AND ( ParamStr ( 1 ) = 'Automatique' ) THEN
      BEGIN
         IF FileExists ( 'C:\Launch.~~~' ) THEN
         BEGIN
            AssignFile ( FF, 'C:\Launch.~~~' ) ;
            TRY
               reset ( ff ) ;
               ReadLn ( ff, AncienReg ) ;
               Closefile ( FF ) ;
               deletefile ( 'C:\Launch.~~~' ) ;
               Reg := TRegistry.Create;
               TRY
                  Reg.RootKey := HKEY_LOCAL_MACHINE;
                  IF Reg.OpenKey ( '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False ) THEN
                  BEGIN
                     Reg.WriteString ( 'Launch_Replication', AncienReg ) ;
                  END;
               FINALLY
                  Reg.CloseKey;
                  Reg.Free;
               END;
            EXCEPT
            END;
         END;
      END;


    // Arret du Launcher
      speedButton1.enabled := false ;
      Letemps := GetTickCount+10000 ;
      While Letemps>GetTickCount do
        Application.processMessages ;
      speedButton1.enabled := true ;

      EnumWindows ( @Enumerate, 0 ) ;

      Reg := TRegistry.Create;
      TRY
         Reg.RootKey := HKEY_CURRENT_USER;
         IF Reg.OpenKey ( '\Software\Agol\Ginkoia\Current Version', True ) THEN
            OldReleasePath := Reg.ReadString ( 'Path' ) ;
      FINALLY
         Reg.CloseKey;
         Reg.Free;
      END;

      PathAppli := ExtractFileDir ( Application.ExeName ) ;
      IF PathAppli[length ( PathAppli ) ] <> '\' THEN
         PathAppli := PathAppli + '\';

      Memo1.Lines.Clear ( ) ;
      Open.InitialDir := PathAppli;
      nb := 0;
      IF findfirst ( PathAppli + '*.XML', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            inc ( nb ) ;
            NewReleasePath := PathAppli + F.Name;
         UNTIL findNext ( f ) <> 0;
      END;
      findclose ( f ) ;
      IF nb <> 1 THEN
      BEGIN
         IF Open.Execute ( ) THEN
         BEGIN
            NewReleasePath := Open.FileName;
         END
         ELSE
            exit;
      END;

      IF ChangeFileExt ( extractfilename ( OldReleasePath ) , '' ) =
         ChangeFileExt ( extractfilename ( NewReleasePath ) , '' ) THEN
         FaireLaCopy := false
      ELSE
         FaireLaCopy := true;

    // Première install
      IF trim ( OldReleasePath ) = '' THEN
         OldReleasePath := Copy ( DriveComboBox1.items[DriveComboBox1.itemindex], 1, 1 ) +
            ':\ginkoia\ginkoia.xxx';

      NewParams.Drive := Copy ( DriveComboBox1.items[DriveComboBox1.itemindex], 1, 1 ) + ':';
      NewParams.GinkoiaInstallPath := NewParams.Drive + '\ginkoia\';
      NewParams.Source := PathAppli;

      PathPass := ExtractFileDir ( OldReleasePath ) ;
      IF PathPass[Length ( PathPass ) ] <> '\' THEN
         PathPass := PathPass + '\';
      OldParams.Drive := ExtractFileDrive ( OldReleasePath ) ;
      OldParams.GinkoiaInstallPath := PathPass;
      OldRelease := TGNKReleaseLB.Create ( OldReleasePath, OldParams, Memo1 ) ;

      NewRelease := TGNKReleaseLB.Create ( NewReleasePath, NewParams, Memo1 ) ;
      Migration := TGNKMigrationLB.Create ( OldRelease, NewRelease ) ;

      Memo1.Lines.Add ( 'Début de l''installation de Ginkoia version : ' + NewRelease.ReleaseNumber ) ;
      Update;
      Migration.PopUpOnError := CheckPopUp.Checked;
      Migration.AssignGauge ( ProgressBar1 ) ;
      Migration.AssignMemo ( Memo1 ) ;

      Erreur := Migration.Execute ( NewReleasePath, FaireLaCopy ) ;
      Update;

      PathPass := ExtractFileDir ( OldReleasePath ) ;
      IF PathPass[Length ( PathPass ) ] <> '\' THEN
         PathPass := PathPass + '\';

      CopyFile ( PChar ( NewReleasePath ) , PChar ( PathPass + ExtractFileName ( NewReleasePath ) ) , false )        ;

      IF Erreur = emNoError THEN
        Begin
         Memo1.Lines.Add ( 'Installation terminée ! ' ) ;
          Reg := TRegistry.Create;
          TRY
             Reg.RootKey := HKEY_CURRENT_USER;
             IF Reg.OpenKey ( '\Software\Agol\Ginkoia\Current Version', True ) THEN
             BEGIN
                Reg.WriteString ( 'Path', NewParams.GinkoiaInstallPath + ChangeFileExt ( ExtractFileName (
                   NewReleasePath ) , '.IST' ) ) ;
             END
             ELSE
             BEGIN
                Memo1.Lines.Add ( 'Erreur pendant l''installation ! ' ) ;
                Memo1.Lines.Add ( 'Impossible d''ouvrir \Software\Agol\Ginkoia\Current Version' ) ;
                Memo1.Lines.Add ( 'Contacter ALGOL ' ) ;
             END;
          FINALLY
             Reg.CloseKey;
             Reg.Free;
          END;
       end 
      ELSE
      BEGIN
         Memo1.Lines.Add ( 'Erreur pendant l''installation ! ' ) ;
         Memo1.Lines.Add ( 'Contacter ALGOL ' ) ;
      END;

      IF CheckLog.Checked THEN
      BEGIN
         TRY
            Memo1.lines.SaveToFile ( OldParams.GinkoiaInstallPath + 'Log.txt' ) ;
         EXCEPT
            Memo1.lines.Add ( 'Problème de sauvegarde du Log' ) ;
            RAISE;
         END;
      END;

      OldRelease.Free ( ) ;
      NewRelease.Free ( ) ;
      Migration.Free ( ) ;
      IF Erreur = emNoError THEN
      BEGIN
         Winexec ( 'Script.exe Auto', 0 ) ;
         Close;
      END
      ELSE
         Regression;
   FINALLY
      screen.cursor := CrDefault;
   END;
END;

PROCEDURE TFrmBase.AlgolStdFrmActivate ( Sender: TObject ) ;
VAR
   i : integer;
BEGIN
  //
   FOR i := 0 TO DriveComboBox1.items.count - 1 DO
   BEGIN
      DriveComboBox1.itemindex := i;
      IF TDriveType ( GetDriveType ( PChar ( Copy ( DriveComboBox1.items[i], 1, 2 ) + '\' ) ) ) = dtFixed
         THEN
      BEGIN
         IF fileexists ( Copy ( DriveComboBox1.items[i], 1, 2 ) + '\ginkoia\ginkoia.exe' ) THEN
            break
      END;
   END;
   IF fileexists ( Copy ( DriveComboBox1.items[i], 1, 2 ) + '\ginkoia\ginkoia.exe' ) THEN
   BEGIN
      IF ( ParamCount > 0 ) AND ( ParamStr ( 1 ) = 'Automatique' ) THEN
         Action ( NIL )
      ELSE IF ( ParamCount > 0 ) AND ( ParamStr ( 1 ) = 'Regression' ) THEN
         Regression;
   END;
END;

END.

