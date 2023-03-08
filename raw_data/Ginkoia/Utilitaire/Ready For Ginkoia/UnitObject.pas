
//------------------------------------------------------------------------------
// Nom de l'unité :   UnitObject
// Rôle           :   Unité contenant le code des objets
// Auteur         :   Laurent BERNE
// Historique     :
// 06/10/2001-Laurent BERNE - v 1.0.0 : Création
//08/11/2001 -Modification de TGNKRELEASE avec ajout des propriétés chemin par défaut
//08/11/2001 -Modification de TGNKInstallComponentLB : ajout de la propriété FileName
//09/11/2001 -Création du type de recode : TGNKInstallModuleParamsLB
//26/11/2001 - Divers modifications et amèliorations
//------------------------------------------------------------------------------

UNIT UnitObject;

INTERFACE

USES FileCtrl,
   Windows,
   ComCtrls,
   ShellApi,
   XMLCursor,
   StdXML_TLB,
   Sysutils,
   classes,
   stdCtrls,
   inifiles,
   Forms,
   Math;

TYPE
   TMigrationType = ( mtUndefined, mtUpgrade, mtRegression, mtNew, mtRepair, mtRemove ) ;

   TInstallType = ( itCopy, itExecute, itModule ) ;

   TComparedRelease = ( crLower, crEqual, crHigher ) ;

   TErrorMigration = ( emNoError, emStandardError ) ;

   TGNKInstallComponentLB = RECORD
      Executer: Boolean;

      PereName: STRING;
      PereRelease: STRING;
      PereDate: STRING;

      Name: STRING; //(nom du module)
      Release: STRING; //  Numéro de version
      FileName: STRING; // nom du fichier
      Date: TDateTime; // Date et heure de création du module
      InstallPath: STRING; // chemin d'arrivée du sous module d'install
      SourcePath: STRING; // chemin d'origine
      InstallType: TInstallType; // Type d'installation du module
   END;

   pTGNKInstallComponentLB = ^TGNKInstallComponentLB; // pointeur pour la TList

   TGNKInstallModuleParamsLB = RECORD
      Drive: STRING; // lecteur cible
      GinkoiaInstallPath: STRING; // chemin d'install de Ginkoia
      Source: STRING; //répertoire d'execution de RFG
   END;

   TGNKInstallModuleLB = CLASS
   Private
    { Private declarations }
      FComponents: TList;
      FName: STRING; //(nom du module)
      FRelease: STRING; //  Numéro de version
      FDate: TDateTime; // Date et heure de création du module
      FDefaultComponentsSourcePath: STRING; // Chemin source par défaut
      FDefaultComponentsInstallPath: STRING;
      FUNCTION ReadComponent ( AValue: integer ) : TGNKInstallComponentLB;
      FUNCTION GetComponentsCount ( ) : integer;
    //function DefaultComponentsInstallPath: string;

   Protected
    { Protected declarations }
   Public
    { Public declarations }
      PROPERTY Name: STRING Read FName; //(nom du module)
      PROPERTY Release: STRING Read FRelease; //  Numéro de version
      PROPERTY Date: TDateTime Read FDate; // Date et heure de création du module
      PROPERTY DefaultComponentsSourcePath: STRING Read FDefaultComponentsSourcePath;  // Chemin source par défaut
      PROPERTY DefaultComponentsInstallPath: STRING Read FDefaultComponentsInstallPath;  // Chemin install par défaut
      PROPERTY Components[AValue: integer]: TGNKInstallComponentLB Read ReadComponent;  // chemin du sous module d'install
      PROPERTY ComponentsCount: integer Read GetComponentsCount; // nombre de components
      CONSTRUCTOR Create ( ) ; Overload;
      CONSTRUCTOR Create ( AName: STRING; ARelease: STRING; ADate: TDateTime; ADefaultComponentsSourcePath:
         STRING; ADefautltComponentsInstallPath:
         STRING ) ; Overload;
      DESTRUCTOR Destroy ( ) ; Override;
      PROCEDURE AddComponent ( AComponent: pTGNKInstallComponentLB ) ;
   END;

//type pTGNKInstallModuleLB  = ^TGNKInstallModuleLB;

   TGNKReleaseLB = CLASS
   Private
    { Private declarations }
      FReleaseNumber: STRING; // Numéro de Release
      FBackUpPath: STRING; // chemin du backup de la version précédente
      FDataPath: STRING; // chemin du backup de la version précédente
      FStDate: STRING;
      FModules: TList; // contient les records de TGNKInstallModuleLB
      FParams: TGNKInstallModuleParamsLB;
      FUNCTION ReadModule ( AValue: integer ) : TGNKInstallModuleLB; // permet de lire le tableau
      FUNCTION GetModulesCount: integer;
      FUNCTION DecodePath ( ARelativePath: STRING ) : STRING;

   Protected
    { Protected declarations }
   Public
    { Public declarations }
      PROPERTY ReleaseNumber: STRING Read FReleaseNumber; // donne le numéro de Release read only
      PROPERTY BackUpPath: STRING Read FBackUpPath;
      PROPERTY DataPath: STRING Read FDataPath;
      PROPERTY StDate: STRING Read FStDate;
      PROPERTY Modules[AValue: integer]: TGNKInstallModuleLB Read ReadModule;
      PROPERTY ModulesCount: integer Read GetModulesCount;
      CONSTRUCTOR Create ( ) ; Overload; // instancie un objet vide
      CONSTRUCTOR Create ( APath: STRING; Params: TGNKInstallModuleParamsLB; FLog: Tmemo ) ; Overload;  // ouvre un fichier XML
      DESTRUCTOR Destroy ( ) ; Override; // libère l'objet
      PROCEDURE AddModule ( AModule: TGNKInstallModuleLB ) ;

   Published
    { Published declarations }

   END;

   TGNKMigrationLB = CLASS
   Private
    { Private declarations }
      FType: TMigrationType;
      FComponents: TList; // contient les records de TGNKInstallModuleLB
      FBackUpPath: STRING; // chemin du backup
      FDataPath: STRING; // chemin du backup
      FLog: Tmemo;
      FProgress: integer;
      FGauge: TProgressBar;

      FReleaseNumber: STRING; // Numéro de Release
      FStDate: STRING;

      FUNCTION ReadComponent ( AValue: integer ) : TGNKInstallComponentLB;
      FUNCTION GetComponentsCount ( ) : integer;
        // PROCEDURE AddComponent ( AComponent: pTGNKInstallComponentLB ) ;
      FUNCTION CompareRelease ( AOld, ANew: STRING ) : TComparedRelease;
      FUNCTION BackUpDataBase ( ) : TErrorMigration;
      FUNCTION RestoreDataBase ( ) : TErrorMigration;

   Protected
    { Protected declarations }
   Public
    { Public declarations }

      PopupOnError: boolean;
      PROPERTY MigrationType: TMigrationType Read FType; // donne le type de migration read only
      PROPERTY BackUpPath: STRING Read FBackUpPath;
      PROPERTY DataPath: STRING Read FDataPath;
      PROPERTY Progress: integer Read FProgress;
      PROPERTY Components[AValue: integer]: TGNKInstallComponentLB Read ReadComponent;
      PROPERTY ComponentsCount: integer Read GetComponentsCount;

      CONSTRUCTOR Create ( AOld, ANew: TGNKReleaseLB ) ; // Constructeur de l'objet
      DESTRUCTOR Destroy ( ) ; Override;
      FUNCTION Execute ( FileName: STRING; FaireLaCopie: boolean ) : TErrorMigration;
      PROCEDURE AssignGauge ( Gauge: TProgressBar ) ;
      PROCEDURE AssignMemo ( Memo: TMemo ) ;

   Published
    { Published declarations }
   END;

IMPLEMENTATION

{ TGNKReleaseLB }
 /////////////////////////////////////////////////////////////////////////////////////////////////////////
 // implémentation class TGNKReleaseLB

FUNCTION TGNKReleaseLB.DecodePath ( ARelativePath: STRING ) : STRING;
VAR
   NewString: STRING;
   buffer: STRING;
   ShortName: ARRAY[0..999] OF Char;
BEGIN
   fillchar ( ShortName, sizeof ( ShortName ) , #00 ) ;
   NewString := '';
   NewString := trim ( StringReplace ( ARelativePath, '[GINKOIA]', FParams.GinkoiaInstallPath, [rfReplaceAll,
      rfIgnoreCase] ) ) ;
   NewString := trim ( StringReplace ( NewString, '[DRIVE]', FParams.Drive, [rfReplaceAll, rfIgnoreCase] ) )
      ;
   NewString := trim ( StringReplace ( NewString, '[SOURCE]', FParams.Source, [rfReplaceAll, rfIgnoreCase] )
      ) ;
   IF NewString <> '' THEN
   BEGIN
      GetShortPathName ( PChar ( NewString ) , // points to a null-terminated path string
         ShortName, // points to a buffer to receive the null-terminated short form of the path
         999 ) ;    // specifies the size of the buffer pointed to by lpszShortPath
      buffer := StrPas ( ShortName ) ;
      IF buffer <> '' THEN
         result := buffer
      ELSE
         result := NewString;
   END
   ELSE             //}
      result := NewString;
END;

CONSTRUCTOR TGNKReleaseLB.Create ( ) ;
BEGIN
   INHERITED;
   FModules := TList.Create ( ) ;
END;

PROCEDURE TGNKReleaseLB.AddModule ( AModule: TGNKInstallModuleLB ) ;
BEGIN
   FModules.Add ( AModule ) ;
END;

CONSTRUCTOR TGNKReleaseLB.Create ( APath: STRING; Params: TGNKInstallModuleParamsLB; FLog: Tmemo ) ;
VAR

   Document: IXMLCursor; // Cursor qui contient l'intégralité du XML
   ReleaseCursor: IXMLCursor; // Cursor de la section 'Release'
   ModulesCursor: IXMLCursor;
   ModuleCursor: IXMLCursor;
   ComponentCursor: IXMLCursor;
   Buffer: TStringList;
   ARecordModule: TGNKInstallModuleLB;
   AComponentBuffer: pTGNKInstallComponentLB;

   FStRelease: STRING;
   FstDate: STRING;
   LStType,
      Fsttype: STRING;

 //ARecordModule : pTGNKInstallModuleLB;
BEGIN

   FModules := TList.Create;
   Buffer := TStringList.Create ( ) ;
   FParams := Params;

   Document := TXMLCursor.Create;
   IF fileexists ( APath ) THEN
   BEGIN
      Buffer.LoadFromFile ( APath ) ;
      Document.LoadXML ( Buffer.Text ) ;
   END;
   ReleaseCursor := Document.Select ( 'RELEASE' ) ;
   FReleaseNumber := ReleaseCursor.GetValue ( 'NUMBER' ) ;
   FBackUpPath := DecodePath ( ReleaseCursor.GetValue ( 'BACKUPPATH' ) ) ;
   FDataPath := DecodePath ( ReleaseCursor.GetValue ( 'DATAPATH' ) ) ;

    // Sauvegarde par defaut pour la prem install
   IF trim ( FDataPath ) = '' THEN
   BEGIN
      FDataPath := Params.GinkoiaInstallPath + 'DATA\';
      FBackUpPath := Params.GinkoiaInstallPath + 'BCKUP';
   END;

   self.FStDate := ReleaseCursor.GetValue ( 'DATE' ) ;

   ModulesCursor := ReleaseCursor.Select ( 'MODULES/MODULE' ) ;
   WHILE NOT ModulesCursor.EOF DO
   BEGIN
      ModuleCursor := Document.Select ( 'MODULE' ) ;
      ARecordModule := TGNKInstallModuleLB.Create ( ModulesCursor.GetValue ( 'NAME' ) ,
         ModulesCursor.GetValue ( 'RELEASE' ) ,
         StrToDateTime ( ModulesCursor.GetValue ( 'DATE' ) ) ,
         DecodePath ( ModulesCursor.GetValue ( 'DEFAULTCOMPONENTSSOURCEPATH' ) ) ,
         DecodePath ( ModulesCursor.GetValue ( 'DEFAULTCOMPONENTSINSTALLPATH' ) )
         ) ;

      WHILE ( ModuleCursor.GetValue ( 'NAME' ) <> ARecordModule.Name ) AND ( NOT ModuleCursor.EOF ) DO
         ModuleCursor.Next ( ) ;

        // La release, la date et le type peuvent être par défaut

      FStRelease := ModuleCursor.GetValue ( 'RELEASE' ) ;
      FstDate := ModuleCursor.GetValue ( 'DATE' ) ;
      Fsttype := ModuleCursor.GetValue ( 'TYPE' ) ;

      ComponentCursor := ModuleCursor.Select ( 'COMPONENTS/COMPONENT' ) ;
      WHILE NOT ComponentCursor.EOF DO
      BEGIN
         new ( AComponentBuffer ) ;

         AComponentBuffer^.PereName := ARecordModule.Name;
         AComponentBuffer^.PereRelease := ARecordModule.Release;
         AComponentBuffer^.PereDate := DateToStr ( ARecordModule.Date ) ;

                   //(nom du module)
         AComponentBuffer^.Name := ComponentCursor.GetValue ( 'NAME' ) ;
         AComponentBuffer^.FileName := ComponentCursor.GetValue ( 'FILENAME' ) ;
         IF AComponentBuffer^.Name = '' THEN AComponentBuffer^.Name := AComponentBuffer^.FileName;

         AComponentBuffer^.Release := ComponentCursor.GetValue ( 'RELEASE' ) ; //  Numéro de version
         IF trim ( AComponentBuffer^.Release ) = '' THEN
            AComponentBuffer^.Release := FStRelease;

         IF trim ( ComponentCursor.GetValue ( 'DATE' ) ) = '' THEN
            AComponentBuffer^.Date := StrToDate ( FstDate )
         ELSE
            AComponentBuffer^.Date := StrToDate ( ComponentCursor.GetValue ( 'DATE' ) ) ;  // Date et heure de création du module

         AComponentBuffer^.InstallPath := ComponentCursor.GetValue ( 'INSTALLPATH' ) ;  // chemin du sous module d'install
         IF trim ( AComponentBuffer^.InstallPath ) = '' THEN
            AComponentBuffer^.InstallPath := ARecordModule.DefaultComponentsInstallPath;
         AComponentBuffer^.InstallPath := DecodePath ( AComponentBuffer^.InstallPath +
            AComponentBuffer^.FileName ) ;

         AComponentBuffer^.SourcePath := ComponentCursor.GetValue ( 'SOURCEPATH' ) ;  // chemin du sous module d'install
         IF trim ( AComponentBuffer^.SourcePath ) = '' THEN
            AComponentBuffer^.SourcePath := ARecordModule.DefaultComponentsSourcePath;
         AComponentBuffer^.SourcePath := DecodePath ( AComponentBuffer^.SourcePath +
            AComponentBuffer^.FileName ) ;

            // Type d'installation du module

         LStType := ComponentCursor.GetValue ( 'TYPE' ) ;
         IF lStType = '' THEN
            lStType := FStType;

         IF lStType = 'MODULE' THEN AComponentBuffer^.InstallType := itModule;
         IF lStType = 'EXECUTABLE' THEN AComponentBuffer^.InstallType := itExecute;
         IF lStType = 'FILE' THEN AComponentBuffer^.InstallType := itCopy;

         ARecordModule.AddComponent ( AComponentBuffer ) ;
         ComponentCursor.Next ( ) ;
      END;
      FModules.Add ( ARecordModule ) ; //}
      ModulesCursor.Next ( ) ;
   END;

   Buffer.free;
   Document := NIL;
   ReleaseCursor := NIL;
   ModulesCursor := NIL;
   ModuleCursor := NIL;
   ComponentCursor := NIL;
   Document := NIL;

END;

DESTRUCTOR TGNKReleaseLB.Destroy ( ) ;
VAR
   i : integer;
BEGIN
   INHERITED;
   FOR i := 0 TO FModules.Count - 1 DO
      Dispose ( FModules.Items[i] ) ;
   FModules.Clear ( ) ; //
   FModules.Free ( ) ;
END;

FUNCTION TGNKReleaseLB.ReadModule ( AValue: integer ) : TGNKInstallModuleLB;
VAR
   ThisModule: TGNKInstallModuleLB;
BEGIN
   ThisModule := FModules.items[AValue];
   result := ThisModule;
END;

FUNCTION TGNKReleaseLB.GetModulesCount: integer;
BEGIN
   result := FModules.Count;
END;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
{ TTGNKMigrationLB }

{
PROCEDURE TGNKMigrationLB.AddComponent ( AComponent: pTGNKInstallComponentLB ) ;
BEGIN
    FComponents.Add ( AComponent ) ;
END;
}

FUNCTION TGNKMigrationLB.BackUpDataBase ( ) : TErrorMigration;
BEGIN
   result := emNoError;
    {
    IF NOT CopyFile ( PChar ( DataPath ) , PChar ( BackupPath ) , false ) THEN
    BEGIN

        IF PopupOnError THEN MessageBox ( 0, 'Erreur pendant la sauvegarde du fichier Interbase', 'Erreur d''installation', MB_OK OR MB_ICONSTOP ) ;
        result := emStandardError;
        FLog.Lines.Add ( 'Erreur pendant la sauvegarde du fichier Interbase' ) ;
        Flog.Update ;
    END
    ELSE
      Begin
        FLog.Lines.Add ( 'Sauvegarde de la base au chemin :' + BackUpPath ) ;
        Flog.Update ;
      End ;
    }
END;

FUNCTION TGNKMigrationLB.RestoreDataBase: TErrorMigration;
BEGIN
   result := emNoError;
  {
    IF NOT CopyFile ( PChar ( BackupPath ) , PChar ( DataPath ) , false ) THEN
    BEGIN

        IF PopupOnError THEN
            MessageBox ( 0, 'Erreur pendant la restauration du fichier Interbase', 'Erreur d''installation', MB_OK OR MB_ICONSTOP ) ;

        FLog.Lines.Add ( 'Erreur pendant la restauration du fichier Interbase' ) ;
        result := emStandardError;
    END
    ELSE
        FLog.Lines.Add ( 'Restauration de la base à partir du chemin : ' + BackUpPath ) ;
  Flog.Update ;
  }
END;

FUNCTION TGNKMigrationLB.CompareRelease ( AOld, ANew: STRING ) : TComparedRelease;
VAR
   ANewBuffer: TStringList;
   AOldBuffer: TStringList;
   Rank: integer;
   ANewValueBuffer: integer;
   AOldValueBuffer: integer;
   ThisResult: TComparedRelease;
BEGIN
   ANewBuffer := TStringList.Create ( ) ;
   AOldBuffer := TStringList.Create ( ) ;
   Rank := 0;
   IF ( ANew <> '' ) THEN
      ANewBuffer.CommaText := StringReplace ( ANew, '.', ',', [rfReplaceAll] )
   ELSE
      ANewBuffer.CommaText := '0,0,0,0';
   IF ( AOld <> '' ) THEN
      AOldBuffer.CommaText := StringReplace ( AOld, '.', ',', [rfReplaceAll] )
   ELSE
      AOldBuffer.CommaText := '0,0,0,0';

   REPEAT
      IF ( Rank < ANewBuffer.Count ) THEN
         ANewValueBuffer := StrToIntDef ( ANewBuffer.Strings[Rank], -666 )
      ELSE
         ANewValueBuffer := -666;
      IF ( Rank < AOldBuffer.Count ) THEN
         AOldValueBuffer := StrToIntDef ( AOldBuffer.Strings[Rank], -666 )
      ELSE
         AOldValueBuffer := -666;

      IF ANewValueBuffer > AOldValueBuffer THEN
         ThisResult := crHigher
      ELSE IF ANewValueBuffer < AOldValueBuffer THEN
         ThisResult := crLower
      ELSE
         ThisResult := crEqual;
      inc ( Rank ) ;
   UNTIL ( Rank >= min ( ANewBuffer.Count, AOldBuffer.Count ) ) OR ( ThisResult <> crEqual ) ;

   result := ThisResult;

END;

CONSTRUCTOR TGNKMigrationLB.Create ( AOld, ANew: TGNKReleaseLB ) ;
VAR
   iNewModule: integer;
   iOldModule: integer;
   Found: boolean;
   iComponent: integer;
   pComponentBuffer: pTGNKInstallComponentLB;

BEGIN
   FComponents := TList.Create ( ) ;
   PopupOnError := true;

   FReleaseNumber := ANew.FReleaseNumber;
   FBackUpPath := ANew.FBackUpPath;
   FDataPath := ANew.FDataPath;
   FStDate := ANew.FStDate;

   IF AOld <> NIL THEN
      CASE CompareRelease ( AOld.ReleaseNumber, ANew.ReleaseNumber ) OF
         crEqual: FType := mtRepair;
         crHigher:
            BEGIN
               FType := mtUpgrade;
               FBackUpPath := ANew.BackUpPath;
               FDataPath := AOld.DataPath;
            END;
         crLower:
            BEGIN
               FType := mtRegression;
               FBackUpPath := AOld.BackUpPath;
               FDataPath := ANew.DataPath;
            END;
      END;

   IF AOld.ReleaseNumber = '' THEN FType := mtNew;
   IF ANew = NIL THEN FType := mtRemove;

   FOR iNewModule := 0 TO ( ANew.ModulesCount - 1 ) DO
   BEGIN
      Found := false;
      FOR iOldModule := 0 TO ( AOld.ModulesCount - 1 ) DO
      BEGIN
         IF ANew.Modules[iNewModule].Name = AOld.Modules[iOldModule].Name THEN
         BEGIN
            IF CompareRelease ( AOld.Modules[iOldModule].Release, ANew.Modules[iNewModule].Release ) <>
               crEqual THEN
               FOR iComponent := 0 TO ( ANew.Modules[iNewModule].ComponentsCount - 1 ) DO
               BEGIN
                  new ( pComponentBuffer ) ;
                  pComponentBuffer^ := ANew.Modules[iNewModule].Components[iComponent];
                  pComponentBuffer^.Executer := true;
                  FComponents.Add ( pComponentBuffer ) ;
               END
            ELSE
               FOR iComponent := 0 TO ( ANew.Modules[iNewModule].ComponentsCount - 1 ) DO
               BEGIN
                  new ( pComponentBuffer ) ;
                  pComponentBuffer^ := ANew.Modules[iNewModule].Components[iComponent];
                  pComponentBuffer^.Executer := False;
                  FComponents.Add ( pComponentBuffer ) ;
               END;

            Found := true;
         END;
      END;
      IF ( NOT Found ) THEN
         FOR iComponent := 0 TO ( ANew.Modules[iNewModule].ComponentsCount - 1 ) DO
         BEGIN
            new ( pComponentBuffer ) ;
            pComponentBuffer^ := ANew.Modules[iNewModule].Components[iComponent];
            pComponentBuffer^.Executer := true;
            FComponents.Add ( pComponentBuffer ) ;
         END;
   END;
END;

DESTRUCTOR TGNKMigrationLB.Destroy ( ) ;
VAR
   i : integer;
BEGIN
   INHERITED;
   FOR i := 0 TO FComponents.Count - 1 DO
      Dispose ( FComponents.Items[i] ) ;
   FComponents.Free ( ) ;
END;

PROCEDURE TGNKMigrationLB.AssignGauge ( Gauge: TProgressBar ) ;
BEGIN
   FGauge := Gauge;
END;

FUNCTION TGNKMigrationLB.Execute ( FileName: STRING; FaireLaCopie: boolean ) : TErrorMigration;
VAR
   iComponent: integer;
   LaSauvegarde,
      ErrorMessage: STRING;

   Erreur: Boolean;

   Release,
      Document,
      lComponents,
      Component,
      Modules,
      Module,
      NewDocument: IXMLCursor;

    {
    SrcF,
    DesF: STRING;
    ShortSrcF, ShortDesF: ARRAY[0..MAX_PATH] OF Char;
    }

    // Copier : Les Exe, Les Ini,
    // Le rep EAI\XML
    // Le rep DATA\RAPPORT
    // Le Rep BPL
    // et les GDB deffinis dans ginkoia.ini

   PROCEDURE ViderRepertoire ( Dst: STRING ) ;
   VAR
      F: TSearchRec;
      DesF: STRING;
   BEGIN
      IF findfirst ( Dst + '*.*', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            IF ( F.Name <> '.' ) AND ( F.Name <> '..' ) THEN
            BEGIN
               DesF := Dst + F.Name;
               IF F.Attr = faDirectory THEN
               BEGIN
                  DesF := DesF + '\';
                  ViderRepertoire ( DesF ) ;
               END
               ELSE
               BEGIN
                  FileSetAttr ( DesF, 0 ) ;
                  if not deletefile ( DesF ) then
                    BEGIN
                       MessageBox ( 0,
                          #10#13'La Sauvegarde de votre précédente version ne peut être faite' +
                          #10#13'Veuillez contacter algol pour installer Ginkoia',
                          'Problème', MB_OK OR
                          MB_ICONSTOP
                          ) ;
                       Application.Terminate;
                       Abort;
                    END;
               END;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
   END;

   PROCEDURE Copier ( Disk: STRING ) ;
   VAR
      S,
         SrcF, Desf,
         Src, Dst: STRING;
      F: TSearchRec;
      ini: Tinifile;
      i: integer;
   BEGIN
      Src := Disk + ':\GINKOIA\';
      dst := Disk + ':\GINBCKUP\';

      ForceDirectories ( Dst ) ;
      ViderRepertoire ( Dst ) ;

      IF findfirst ( Src + '*.Exe', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            SrcF := Src + F.Name;
            DesF := Dst + F.Name;
            IF NOT CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) THEN
            BEGIN
               MessageBox ( 0,
                  #10#13'La Sauvegarde de votre précédente version ne peut être faite' +
                  #10#13'Veuillez contacter algol pour installer Ginkoia',
                  'Problème', MB_OK OR
                  MB_ICONSTOP
                  ) ;
               Application.Terminate;
               Abort;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      IF findfirst ( Src + '*.INI', FaAnyFile, F ) = 0 THEN
      BEGIN
         REPEAT
            SrcF := Src + F.Name;
            DesF := Dst + F.Name;
            IF NOT CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) THEN
            BEGIN
               MessageBox ( 0,
                  #10#13'La Sauvegarde de votre précédente version ne peut être faite' +
                  #10#13'Veuillez contacter algol pour installer Ginkoia',
                  'Problème', MB_OK OR
                  MB_ICONSTOP
                  ) ;
               Application.Terminate;
               Abort;
            END;

         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      Src := Disk + ':\GINKOIA\EAI\XML\';
      dst := Disk + ':\GINBCKUP\EAI\XML\';
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
                  IF NOT CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) THEN
                  BEGIN
                     MessageBox ( 0,
                        #10#13'La Sauvegarde de votre précédente version ne peut être faite' +
                        #10#13'Veuillez contacter algol pour installer Ginkoia',
                        'Problème', MB_OK OR
                        MB_ICONSTOP
                        ) ;
                     Application.Terminate;
                     Abort;
                  END;
               END;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      Src := Disk + ':\GINKOIA\EAI\';
      dst := Disk + ':\GINBCKUP\EAI\';
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
                     IF NOT CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) THEN
                     BEGIN
                        MessageBox ( 0,
                           #10#13'La Sauvegarde de votre précédente version ne peut être faite' +
                           #10#13'Veuillez contacter algol pour installer Ginkoia',
                           'Problème', MB_OK OR
                           MB_ICONSTOP
                           ) ;
                        Application.Terminate;
                        Abort;
                     END;
                  END;
               END;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      Src := Disk + ':\GINKOIA\DATA\RAPPORT\';
      dst := Disk + ':\GINBCKUP\DATA\RAPPORT\';
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
                  IF NOT CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) THEN
                  BEGIN
                     MessageBox ( 0,
                        #10#13'La Sauvegarde de votre précédente version ne peut être faite' +
                        #10#13'Veuillez contacter algol pour installer Ginkoia',
                        'Problème', MB_OK OR
                        MB_ICONSTOP
                        ) ;
                     Application.Terminate;
                     Abort;
                  END;
               END;
            END;
         UNTIL findNext ( F ) <> 0;
      END;
      FindClose ( F ) ;
      Src := Disk + ':\GINKOIA\BPL\';
      dst := Disk + ':\GINBCKUP\BPL\';
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
                  IF NOT CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) THEN
                  BEGIN
                     MessageBox ( 0,
                        #10#13'La Sauvegarde de votre précédente version ne peut être faite' +
                        #10#13'Veuillez contacter algol pour installer Ginkoia',
                        'Problème', MB_OK OR
                        MB_ICONSTOP
                        ) ;
                     Application.Terminate;
                     Abort;
                  END;
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
               srcf := S;
               IF fileexists ( srcf ) THEN
               BEGIN
                  delete ( S, 1, pos ( '\', S ) ) ;
                  delete ( S, 1, pos ( '\', S ) ) ;
                  desf := dst + S;
                  ForceDirectories ( extractfilepath ( desf ) ) ;
                  IF NOT CopyFile ( Pchar ( srcf ) , Pchar ( desf ) , false ) THEN
                  BEGIN
                     MessageBox ( 0,
                        #10#13'La Sauvegarde de votre précédente version ne peut être faite' +
                        #10#13'Veuillez contacter algol pour installer Ginkoia',
                        'Problème', MB_OK OR
                        MB_ICONSTOP
                        ) ;
                     Application.Terminate;
                     Abort;
                  END;
               END;
            END;
         UNTIL s = '';
      FINALLY
         ini.free;
      END;
   END;

BEGIN
   result := emNoError;
   CASE MigrationType OF
      mtRegression: RestoreDataBase;
      mtUpgrade: BackUpDataBase;
      mtNew: ;
   END;
   FProgress := 0;
   FGauge.Position := 0;

   NewDocument := TXMLCursor.Create;
   Document := NewDocument.AppendChild ( 'Document', '' ) ;
   Release := Document.AppendChild ( 'RELEASE', '' ) ;

   Release.SetValue ( 'NUMBER', FReleaseNumber ) ;
   Release.SetValue ( 'DATE', FStDate ) ;
   Release.SetValue ( 'BACKUPPATH', FBackUpPath ) ;
   Release.SetValue ( 'DATAPATH', FDataPath ) ;
   Modules := Release.AppendChild ( 'MODULES', '' ) ;

    // copier la totalité du rep ginkoia sur bckup

   IF FaireLaCopie THEN
   BEGIN
      FLog.Lines.Add ( 'Sauvegarde de l''ancienne Version ' ) ;
      FLog.Update;
      Copier ( Copy ( FDataPath, 1, 1 ) ) ;
   END;

   FOR iComponent := 0 TO ( ComponentsCount - 1 ) DO
   BEGIN
      Erreur := false;
      FProgress := ( ComponentsCount DIV ( iComponent + 1 ) ) * 100;
      IF Assigned ( FGauge ) THEN FGauge.Position := FProgress;
      IF Components[iComponent].Executer THEN
      BEGIN
         CASE Components[iComponent].InstallType OF
            itCopy:
               BEGIN
                  FileSetAttr ( Components[iComponent].InstallPath, 0 ) ;
                  forcedirectories ( extractfilepath ( Components[iComponent].InstallPath ) ) ;
                  IF NOT CopyFile ( PChar ( Components[iComponent].SourcePath ) , PChar (
                     Components[iComponent].InstallPath ) , false ) THEN
                  BEGIN
                     ErrorMessage := 'Erreur pendant l''installation du composant : ' +
                        Components[iComponent].Name;
                     IF PopupOnError THEN
                        MessageBox ( 0, PChar ( ErrorMessage ) , 'Erreur d''installation', MB_OK OR
                           MB_ICONSTOP
                           ) ;
                     FLog.Lines.Add ( 'Erreur pendant l''installation du composant : ' +
                        Components[iComponent].Name ) ;
                     result := emStandardError;
                     Erreur := true;
                  END
                  ELSE
                  BEGIN
                            // FLog.Lines.Add ( 'Installation du composant : ' + Components[iComponent].Name ) ;
                     FileSetAttr ( Components[iComponent].InstallPath, 0 ) ;
                  END;
               END;
            itExecute:
               BEGIN
                  IF ShellExecute ( 0, NIL, PChar ( Components[iComponent].SourcePath ) , NIL, NIL,
                     SW_SHOWNORMAL ) <= 32 THEN
                  BEGIN
                     ErrorMessage := 'Erreur pendant l''execution de l''installation du composant : ' +
                        Components[iComponent].Name;
                     IF PopupOnError THEN
                        MessageBox ( 0, PChar ( ErrorMessage ) , 'Erreur d''installation', MB_OK OR
                           MB_ICONSTOP
                           ) ;
                     FLog.Lines.Add ( 'Erreur pendant l''execution de l''installation du composant : ' +
                        Components[iComponent].Name ) ;
                     result := emStandardError;
                     Erreur := true;
                  END
                  ELSE
                  BEGIN
                            // FLog.Lines.Add ( 'Execution de l''installation du composant : ' + Components[iComponent].Name ) ;
                  END;
               END;
         END;
      END;
      Flog.Update;
      IF NOT Erreur THEN
      BEGIN
         Module := Modules.Select ( 'MODULE' ) ;
         WHILE ( NOT Module.EOF ) AND
            ( Module.GetValue ( 'NAME' ) <> Components[iComponent].PereName ) DO
            Module.Next;
         IF Module.EOF THEN
         BEGIN
            Module := Modules.AppendChild ( 'MODULE', '' ) ;
            Module.SetValue ( 'NAME', Components[iComponent].PereName ) ;
            Module.SetValue ( 'RELEASE', Components[iComponent].PereRelease ) ;
            Module.SetValue ( 'DATE', Components[iComponent].PereDate ) ;
         END;

         Module := Document.Select ( 'MODULE' ) ;
         WHILE ( NOT Module.EOF ) AND
            ( Module.GetValue ( 'NAME' ) <> Components[iComponent].PereName ) DO
            Module.Next;
         IF Module.EOF THEN
         BEGIN
            Module := Document.AppendChild ( 'MODULE', '' ) ;
            Module.SetValue ( 'NAME', Components[iComponent].PereName ) ;
            Module.SetValue ( 'RELEASE', Components[iComponent].PereRelease ) ;
            Module.SetValue ( 'DATE', Components[iComponent].PereDate ) ;
            lComponents := Module.AppendChild ( 'COMPONENTS', '' ) ;
         END
         ELSE
            lComponents := Module.Select ( 'COMPONENTS' ) ;

         Component := lComponents.AppendChild ( 'COMPONENT', '' ) ;
         Component.SetValue ( 'NAME', Components[iComponent].Name ) ;
         Component.SetValue ( 'RELEASE', Components[iComponent].Release ) ;
         Component.SetValue ( 'FILENAME', Components[iComponent].FileName ) ;
         Component.SetValue ( 'INSTALLPATH', Components[iComponent].InstallPath ) ;
         Component.SetValue ( 'SOURCEPATH', Components[iComponent].SourcePath ) ;
      END;
   END;
   IF FDataPath <> '' THEN
   BEGIN
      IF NOT Erreur THEN
      BEGIN
          LaSauvegarde := Copy ( FDataPath, 1, 3 ) + 'GINKOIA\' + ChangeFileExt ( ExtractFileName ( FileName ) ,
             '.IST' ) ;
          TRY
             NewDocument.Save ( LaSauvegarde ) ;
          EXCEPT
             Flog.Lines.Add ( 'Problème pour executer la sauvegarde de : ' + Copy ( FDataPath, 1, 3 ) + 'GINKOIA\'
                + ChangeFileExt ( ExtractFileName ( FileName ) , '.IST' ) ) ;
             Flog.Update;
             result := emStandardError;
          END;
      END ;
      NewDocument := NIL;
   END;
END;

FUNCTION TGNKMigrationLB.GetComponentsCount ( ) : integer;
BEGIN
   result := FComponents.Count;
END;

FUNCTION TGNKMigrationLB.ReadComponent ( AValue: integer ) : TGNKInstallComponentLB;
VAR
   ThisComponent: pTGNKInstallComponentLB;
BEGIN
   ThisComponent := FComponents.items[AValue];
   result := ThisComponent^;
END;

//////////////////////////////////////////////////////////////////////////////////////////////////////////
{ TGNKInstallModuleLB }

PROCEDURE TGNKInstallModuleLB.AddComponent ( AComponent: pTGNKInstallComponentLB ) ;
BEGIN
   FComponents.Add ( AComponent ) ;
END;

CONSTRUCTOR TGNKInstallModuleLB.Create ( ) ;
BEGIN
   FComponents := TList.Create ( ) ;
END;

CONSTRUCTOR TGNKInstallModuleLB.Create ( AName: STRING; ARelease: STRING; ADate: TDateTime;
   ADefaultComponentsSourCePath: STRING; ADefautltComponentsInstallPath: STRING ) ;
BEGIN
   FComponents := TList.Create ( ) ;
   FName := AName;
   FRelease := ARelease;
   FDate := ADate;
   FDefaultComponentsSourcePath := ADefaultComponentsSourCePath;
   FDefaultComponentsInstallPath := ADefautltComponentsInstallPath;
END;

DESTRUCTOR TGNKInstallModuleLB.Destroy ( ) ;
VAR
   i : integer;
BEGIN
   INHERITED;
   FOR i := 0 TO FComponents.Count - 1 DO
      Dispose ( FComponents.Items[i] ) ;
   FComponents.Free ( ) ;
END;

FUNCTION TGNKInstallModuleLB.GetComponentsCount ( ) : integer;
BEGIN
   result := FComponents.Count;
END;

FUNCTION TGNKInstallModuleLB.ReadComponent ( AValue: integer ) : TGNKInstallComponentLB;
VAR
   ThisComponent: pTGNKInstallComponentLB;
BEGIN
   ThisComponent := FComponents.Items[AValue];
   result := ThisComponent^;
END;

PROCEDURE TGNKMigrationLB.AssignMemo ( Memo: TMemo ) ;
BEGIN
   FLog := Memo;
END;

END.

