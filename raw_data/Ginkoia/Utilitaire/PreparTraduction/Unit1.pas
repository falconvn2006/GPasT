unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,FileCtrl,
  LMDCustomComponent, LMDFileGrep, LMDControl, LMDBaseControl,
  LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton,
  PBFolderDialog, VCLUtils, StdCtrls, PBPreview, LMDCustomControl,
  LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit, LMDCustomEdit,
  LMDCustomBrowseEdit, LMDCustomFileEdit, LMDFileOpenEdit;

type
  TForm1 = class(TForm)
    LMDSpeedButton1: TLMDSpeedButton;
    FileGrep_: TLMDFileGrep;
    RepDld_: TPBFolderDialog;
    LMDSpeedButton2: TLMDSpeedButton;
    LMDSpeedButton3: TLMDSpeedButton;
    Dir_Recup: TPBFolderDialog;
    FileGrep_Paquet: TLMDFileGrep;
    Memo1: TMemo;
    LMDSpeedButton4: TLMDSpeedButton;
    procedure LMDSpeedButton1Click(Sender: TObject);
    procedure LMDSpeedButton3Click(Sender: TObject);
    procedure LMDSpeedButton4Click(Sender: TObject);
    procedure LMDSpeedButton2Click(Sender: TObject);
  private
    { Déclarations privées }
    PROCEDURE RecopyFile(src,dest: STRING);
    PROCEDURE RecopyDir(src,dest: STRING);
    PROCEDURE RecopyDir_DPK(src,dest: STRING);
  public
    { Déclarations publiques }
    PROCEDURE AnalyseDir(Ch: String);
    PROCEDURE CreeDPR_CFG(Rep,Nom: String);
    PROCEDURE MajDPR_CFG(Rep,Nom: String);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

PROCEDURE TForm1.AnalyseDir(Ch: String);
var Rep,NomPaquet :String;
    max, i :Integer;
begin
     IF Ch[length(Ch)] <> '\' THEN
        FileGrep_.Dirs := ch+'\'
     ELSE FileGrep_.Dirs := ch;
     FileGrep_.Grep; // Liste des .gpk présent dans le repertoire et les sous-repertoires
     max := FileGrep_.found.Count;
     for i:= 0 to max-1 do
     BEGIN
          Rep := ExtractFilePath(FileGrep_.Files.Strings[i]);
          NomPaquet := StringReplace(ExtractFileName(FileGrep_.Files.Strings[i]), '.dpk', '',[rfIgnoreCase]);
          Delete(NomPaquet,1,1);
          Delete(NomPaquet,length(NomPaquet),1);
          IF UPPERCASE(NomPaquet) <> 'GINKOIANONBPL' then
          BEGIN
              if not DirectoryExists(Rep+NomPaquet) then
              BEGIN
                 if not CreateDir(Rep+NomPaquet) then
                    raise Exception.Create('Impossible de créer'+Rep+NomPaquet);
                 CreeDPR_CFG(Rep,NomPaquet);
              END
              ELSE // Mettre à jour les paquets
              BEGIN
                MajDPR_CFG(Rep,NomPaquet);
              END;
          END;
     END;

END;

PROCEDURE TForm1.CreeDPR_CFG(Rep,Nom: String);
var Fich, Fich_DPR, Fich_CFG, Fich_DOF: TStringList;
    L,LU, Dof_Pak: String;
    max, i: Integer;
    okRequire,okContains: Boolean;
begin

     TRY
        Fich := TStringList.Create;
        Fich.LoadFromFile(Rep+Nom+'.dpk');

        Fich_DPR := TStringList.Create;
        Fich_DPR.Add('program '+Nom+';');
        Fich_DPR.Add(' ');
        Fich_DPR.Add('uses');
        Fich_DPR.Add(' ');
        Fich_DPR.Add('  Forms,');
        Fich_DPR.Add('  LocUtils,');

        Fich_CFG := TStringList.Create;
        Fich_CFG.Add('-$A+');
        Fich_CFG.Add('-$B-');
        Fich_CFG.Add('-$C+');
        Fich_CFG.Add('-$D+');
        Fich_CFG.Add('-$E-');
        Fich_CFG.Add('-$F-');
        Fich_CFG.Add('-$G+');
        Fich_CFG.Add('-$H+');
        Fich_CFG.Add('-$I+');
        Fich_CFG.Add('-$J+');
        Fich_CFG.Add('-$K-');
        Fich_CFG.Add('-$L+');
        Fich_CFG.Add('-$M-');
        Fich_CFG.Add('-$N+');
        Fich_CFG.Add('-$O+');
        Fich_CFG.Add('-$P+');
        Fich_CFG.Add('-$Q+');
        Fich_CFG.Add('-$R+');
        Fich_CFG.Add('-$S-');
        Fich_CFG.Add('-$T-');
        Fich_CFG.Add('-$U-');
        Fich_CFG.Add('-$V+');
        Fich_CFG.Add('-$W-');
        Fich_CFG.Add('-$X+');
        Fich_CFG.Add('-$YD');
        Fich_CFG.Add('-$Z1');
        Fich_CFG.Add('-cg');
        Fich_CFG.Add('-AWinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;');
        Fich_CFG.Add('-H+');
        Fich_CFG.Add('-W+');
        Fich_CFG.Add('-M');
        Fich_CFG.Add('-$M16384,1048576');
        Fich_CFG.Add('-K$00400000');
        Fich_CFG.Add('-E"C:\Developpement\Ginkoia"');
        Fich_CFG.Add('-N"C:\Developpement\Ginkoia\Bin"');
        Fich_CFG.Add('-LE"c:\borland\delphi5\Projects\Bpl"');
        Fich_CFG.Add('-LN"c:\borland\delphi5\Projects\Bpl"');
        Fich_CFG.Add('-U"C:\DCU;C:\Developpement\Paquets Standards;C:\Developpement\Ginkoia\Source\Paquets;C:\Developpement\Ginkoia\Source\Caisse\Paquets"');
        Fich_CFG.Add('-O"C:\DCU;C:\Developpement\Paquets Standards;C:\Developpement\Ginkoia\Source\Paquets;C:\Developpement\Ginkoia\Source\Caisse\Paquets"');
        Fich_CFG.Add('-I"C:\DCU;C:\Developpement\Paquets Standards;C:\Developpement\Ginkoia\Source\Paquets;C:\Developpement\Ginkoia\Source\Caisse\Paquets"');
        Fich_CFG.Add('-R"C:\DCU;C:\Developpement\Paquets Standards;C:\Developpement\Ginkoia\Source\Paquets;C:\Developpement\Ginkoia\Source\Caisse\Paquets"');

        Fich_DOF:= TStringList.Create;
        Fich_DOF.Add('[Compiler]');
        Fich_DOF.Add('A=1');
        Fich_DOF.Add('B=0');
        Fich_DOF.Add('C=1');
        Fich_DOF.Add('D=1');
        Fich_DOF.Add('E=0');
        Fich_DOF.Add('F=0');
        Fich_DOF.Add('G=1');
        Fich_DOF.Add('H=1');
        Fich_DOF.Add('I=1');
        Fich_DOF.Add('J=1');
        Fich_DOF.Add('K=0');
        Fich_DOF.Add('L=1');
        Fich_DOF.Add('M=0');
        Fich_DOF.Add('N=1');
        Fich_DOF.Add('O=1');
        Fich_DOF.Add('P=1');
        Fich_DOF.Add('Q=1');
        Fich_DOF.Add('R=1');
        Fich_DOF.Add('S=0');
        Fich_DOF.Add('T=0');
        Fich_DOF.Add('U=0');
        Fich_DOF.Add('V=1');
        Fich_DOF.Add('W=0');
        Fich_DOF.Add('X=1');
        Fich_DOF.Add('Y=1');
        Fich_DOF.Add('Z=1');
        Fich_DOF.Add('ShowHints=1');
        Fich_DOF.Add('ShowWarnings=1');
        Fich_DOF.Add('UnitAliases=WinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;');
        Fich_DOF.Add('[Linker]');
        Fich_DOF.Add('MapFile=0');
        Fich_DOF.Add('OutputObjs=0');
        Fich_DOF.Add('ConsoleApp=1');
        Fich_DOF.Add('DebugInfo=0');
        Fich_DOF.Add('RemoteSymbols=0');
        Fich_DOF.Add('MinStackSize=16384');
        Fich_DOF.Add('MaxStackSize=1048576');
        Fich_DOF.Add('ImageBase=4194304');
        Fich_DOF.Add('ExeDescription=');
        Fich_DOF.Add('[Directories]');
        Fich_DOF.Add('OutputDir=C:\Developpement\Ginkoia');
        Fich_DOF.Add('UnitOutputDir=C:\Developpement\Ginkoia\Bin');
        Fich_DOF.Add('PackageDLLOutputDir=');
        Fich_DOF.Add('PackageDCPOutputDir=');
        Fich_DOF.Add('SearchPath=C:\DCU;C:\Developpement\Paquets Standards;C:\Developpement\Ginkoia\Source\Paquets;C:\Developpement\Ginkoia\Source\Caisse\Paquets');

        max := Fich.Count;
        okRequire := False;
        okContains := False;
        for i:= 0 to max-1 do
        BEGIN
             L := UpperCase(TRIM(Fich.Strings[i]));
             IF (L <> '') THEN
             BEGIN
                 IF ( L = 'END.') then
                 BEGIN
                      okRequire := False;
                      okContains := False;
                      Delete(LU, Length(LU),1);
                      Fich_CFG.Add(LU);
                      Delete(Dof_Pak, Length(Dof_Pak),1);
                      Fich_DOF.Add(Dof_Pak);
                 END;

                 IF okContains THEN
                 BEGIN
                      Fich_DPR.Add(L);
                 END;
                 IF not okContains and (L = 'CONTAINS') then
                 BEGIN
                      okRequire := False;
                      okContains := True;
                 END;

                 IF okRequire THEN
                 BEGIN
                      Delete(L, Length(L),1);
                      LU := LU+L+';';
                      Dof_Pak := Dof_Pak+L+';';
                 END;
                 IF not okRequire and (L = 'REQUIRES') then
                 BEGIN
                      okRequire := True;
                      LU := '-LU';
                      Dof_Pak := 'Packages=';
                 END;
             END;
        END;

        Fich_DPR.Add(' ');
        Fich_DPR.Add('{$R *.RES}');
        Fich_DPR.Add(' ');
        Fich_DPR.Add('begin ');
        Fich_DPR.Add('end. ');

        Fich_DOF.Add('Conditionals=');
        Fich_DOF.Add('DebugSourceDirs=');
        Fich_DOF.Add('UsePackages=1');
        Fich_DOF.Add('[Parameters]');
        Fich_DOF.Add('RunParams=');
        Fich_DOF.Add('HostApplication=');
        Fich_DOF.Add('[Version Info]');
        Fich_DOF.Add('IncludeVerInfo=1');
        Fich_DOF.Add('AutoIncBuild=0');
        Fich_DOF.Add('MajorVer=2');
        Fich_DOF.Add('MinorVer=0');
        Fich_DOF.Add('Release=0');
        Fich_DOF.Add('Build=2');
        Fich_DOF.Add('Debug=0');
        Fich_DOF.Add('PreRelease=0');
        Fich_DOF.Add('Special=0');
        Fich_DOF.Add('Private=0');
        Fich_DOF.Add('DLL=0');
        Fich_DOF.Add('Locale=1036');
        Fich_DOF.Add('CodePage=1252');
        Fich_DOF.Add('[Version Info Keys]');
        Fich_DOF.Add('CompanyName=');
        Fich_DOF.Add('FileDescription=');
        Fich_DOF.Add('FileVersion=2.0.0.2');
        Fich_DOF.Add('InternalName=');
        Fich_DOF.Add('LegalCopyright=');
        Fich_DOF.Add('LegalTrademarks=');
        Fich_DOF.Add('OriginalFilename=');
        Fich_DOF.Add('ProductName=');
        Fich_DOF.Add('ProductVersion=2.0.0');
        Fich_DOF.Add('Comments=Version 2.0.0');
        Fich_DOF.Add('[Excluded Packages]');
        Fich_DOF.Add('$(DELPHI)\Bin\dclado50.bpl=Composants Borland ADO DB');
        Fich_DOF.Add('C:\Developpement\Ginkoia\Source\FiltreGinkoia\GinkoiaNonBPL.bpl= Algol - Paquet ginkoia pas en bpl');
        Fich_DOF.Add('$(DELPHI)\Projects\Bpl\WinshoesPkgD4.bpl=Winshoes for D5');
        Fich_DOF.Add('c:\borland\cogisoft\DAC\dclDAC50.bpl=XMLComponents - Micro Kernel for Dynamic Loading of Middleware');
        Fich_DOF.Add('c:\borland\cogisoft\XMLComponents\Source\dclXML50.bpl=XMLComponents');
        Fich_DOF.Add('C:\Borland\ExpressPrintingSystem\Lib\dxPSdxFCLnkD5.bpl=ExpressPrinting System ReportLinks for ExpressFlowChart by Developer Express Inc.');
        Fich_DOF.Add('[HistoryLists\hlUnitAliases]');
        Fich_DOF.Add('Count=1');
        Fich_DOF.Add('Item0=WinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;');
        Fich_DOF.Add('[HistoryLists\hlSearchPath]');
        Fich_DOF.Add('Count=2');
        Fich_DOF.Add('Item0=C:\DCU;C:\Developpement\Paquets Standards;C:\Developpement\Ginkoia\Source\Paquets;C:\Developpement\Ginkoia\Source\Caisse\Paquets');
        Fich_DOF.Add('Item1=C:\Developpement\Ginkoia\Bin');
        Fich_DOF.Add('[HistoryLists\hlUnitOutputDirectory]');
        Fich_DOF.Add('Count=1');
        Fich_DOF.Add('Item0=C:\Developpement\Ginkoia\Bin');
        Fich_DOF.Add('[HistoryLists\hlOutputDirectorry]');
        Fich_DOF.Add('Count=1');
        Fich_DOF.Add('Item0=C:\Developpement\Ginkoia');

        Fich_DPR.SaveToFile(Rep+Nom+'\'+Nom+'.dpr');
        Fich_CFG.SaveToFile(Rep+Nom+'\'+Nom+'.cfg');
        Fich_DOF.SaveToFile(Rep+Nom+'\'+Nom+'.dof');

     FINALLY
        Fich.Free;
        Fich_DPR.Free;
        Fich_CFG.Free;
        Fich_DOF.Free;
     END;
END;

PROCEDURE TForm1.MajDPR_CFG(Rep,Nom: String);
var Fich, Fich_DPR, Fich_CFG, Fich_DOF: TStringList;
    L,LU, Dof_Pak: String;
    max, i, n_Dpr, n_Dof: Integer;
    okRequire,okContains: Boolean;
begin
//FileExists(const FileName: string): Boolean;
     TRY
        Fich := TStringList.Create;
        Fich.LoadFromFile(Rep+Nom+'.dpk');

        Fich_DPR := TStringList.Create;
        Fich_DPR.LoadFromFile(Rep+Nom+'\'+Nom+'.dpr');

        Fich_CFG := TStringList.Create;
        Fich_CFG.LoadFromFile(Rep+Nom+'\'+Nom+'.cfg');

        Fich_DOF:= TStringList.Create;
        Fich_DOF.LoadFromFile(Rep+Nom+'\'+Nom+'.dof');

        max := Fich.Count;
        okRequire := False;
        okContains := False;
        n_Dpr := 4;
        n_Dof := 46;
        try
            for i:= 0 to max-1 do
            BEGIN
                 L := UpperCase(TRIM(Fich.Strings[i]));
                 IF (L <> '') THEN
                 BEGIN
                     IF ( L = 'END.') then
                     BEGIN
                          okRequire := False;
                          okContains := False;
                          Delete(LU, Length(LU),1);
                          Fich_CFG.Delete(Fich_CFG.Count-1);
                          Fich_CFG.Add(LU);
                          Delete(Dof_Pak, Length(Dof_Pak),1);
                          IF Fich_DOF.Strings[n_Dof] <> Dof_Pak then
                          BEGIN
                             Fich_DOF.Strings[n_Dof] := Dof_Pak;
                             inc(n_Dof);
                          END;
                     END;

                     IF okContains THEN
                     BEGIN
                          IF Fich_DPR.Strings[n_Dpr] <> L then
                          BEGIN
                               IF Fich_DPR.Strings[n_Dpr] = '' then
                                  Fich_DPR.Insert(n_Dpr,L)
                               ELSE Fich_DPR.Strings[n_Dpr] := L;
                          END;
                          Inc(n_Dpr);
                     END;
                     IF not okContains and (L = 'CONTAINS') then
                     BEGIN
                          okRequire := False;
                          okContains := True;
                     END;

                     IF okRequire THEN
                     BEGIN
                          Delete(L, Length(L),1);
                          LU := LU+L+';';
                          Dof_Pak := Dof_Pak+L+';';
                     END;
                     IF not okRequire and (L = 'REQUIRES') then
                     BEGIN
                          okRequire := True;
                          LU := '-LU';
                          Dof_Pak := 'Packages=';
                     END;
                 END;
            END;
            Fich_DPR.SaveToFile(Rep+Nom+'\'+Nom+'.dpr');
            Fich_CFG.SaveToFile(Rep+Nom+'\'+Nom+'.cfg');
            Fich_DOF.SaveToFile(Rep+Nom+'\'+Nom+'.dof');
        EXCEPT
              MessageDlg('info : '+Rep+Nom+'\'+Nom+'.dof', mtWarning, [], 0);
        END;

     FINALLY
        Fich.Free;
        Fich_DPR.Free;
        Fich_CFG.Free;
        Fich_DOF.Free;
     END;
END;

procedure TForm1.LMDSpeedButton1Click(Sender: TObject);
begin
     RepDld_.Folder := 'C:\Developpement\Ginkoia\Source';
     IF RepDld_.Execute THEN
     BEGIN
        AnalyseDir(RepDld_.SelectedFolder);
        MessageDlg('Traitement terminé !', mtInformation, [mbOK], 0);
     END;
end;

PROCEDURE TForm1.RecopyFile(src,dest: STRING);
// attention ne gérer pas les sous-arborécences
VAR
    f: tsearchrec;
    FileOrg, FileDest: String;
BEGIN
    IF src[length(src)] <> '\' THEN
        src := src + '\';
    IF dest[length(dest)] <> '\' THEN
        dest := dest + '\';

    IF findfirst(src + '*.*', faanyfile, f) = 0 THEN
    BEGIN
        REPEAT
            IF (f.name <> '.') AND (f.name <> '..') AND (f.name <> 'vssver.scc')THEN
            BEGIN
                IF f.Attr AND faDirectory = 0 THEN
                BEGIN
                    fileSetAttr(src + f.Name, 0);
                    FileOrg := src + f.Name;
                    FileDest := dest + f.Name;
                    // Contrôler que les repertoire destination existe, sinon le créer
                    if not DirectoryExists(dest) then
                       if not CreateDir(dest) then
                          raise Exception.Create('Impossible de créer'+dest);
                    Try
                       copyfile(StringToPChar(FileOrg),StringToPChar(FileDest),False);
                       Memo1.Lines.Add(src+f.Name+' mis à jour dans '+Dest);
                    except
                       raise Exception.Create('Erreur lors de la copie des fichiers'+FileOrg);
                    END;
                END;
            END;
        UNTIL findnext(f) <> 0;
    END;
    findclose(f);
END;

PROCEDURE TForm1.RecopyDir(src,dest: STRING);
var f, f_dpk: tsearchrec;
    Rep: String;
BEGIN
    IF src[length(src)] <> '\' THEN
        src := src + '\';
    IF dest[length(dest)] <> '\' THEN
        dest := dest + '\';

    IF findfirst(src + '*.*', faanyfile, f) = 0 THEN
    BEGIN
        REPEAT
            // si c'est un repertoire qui se nomme PQT_*
           IF (f.Attr AND faDirectory	> 0) AND (Pos('PQT_',UPPERCASE(f.Name))=1) THEN
            BEGIN
               Rep := '';
               // Rechercher le PQT_*.dpk
               FileGrep_Paquet.FileMasks := f.Name+'.dpk';
               FileGrep_Paquet.Dirs := dest;
               FileGrep_Paquet.Grep;
               if FileGrep_Paquet.found.Count <> 1 then
     	           MessageDlg('Il y a plusieur '+f.Name+' sous '+dest, mtError, [mbOK], 0)
               ELSE Rep := ExtractFilePath(FileGrep_Paquet.Files.Strings[0])+f.Name;

               IF Rep <> '' then
                  RecopyFile(src+f.Name,Rep)
               ELSE Memo1.Lines.Add('ERREUR pour '+src+f.Name+' !');
            END;
        UNTIL findnext(f) <> 0;
    END;
    findclose(f);
END;

PROCEDURE TForm1.RecopyDir_DPK(src,dest: STRING);
var Rep,NomPaquet :String;
    max, i :Integer;
BEGIN
// chercher les "nom de dossier".dpk et mettre à jour le repertoire "nom de dossier" dans la traduction
    IF src[length(src)] <> '\' THEN
        src := src + '\';
    IF dest[length(dest)] <> '\' THEN
        dest := dest + '\';

     FileGrep_.Dirs := src;
     FileGrep_.Grep; // Liste des .gpk présent dans le repertoire et les sous-repertoires
     max := FileGrep_.found.Count;
     for i:= 0 to max-1 do
     BEGIN
          Rep := ExtractFilePath(FileGrep_.Files.Strings[i]);
          NomPaquet := StringReplace(ExtractFileName(FileGrep_.Files.Strings[i]), '.dpk', '',[rfIgnoreCase]);
          Delete(NomPaquet,1,1);
          Delete(NomPaquet,length(NomPaquet),1);
          IF UPPERCASE(NomPaquet) <> 'GINKOIANONBPL' then
          BEGIN
              if not DirectoryExists(Rep+NomPaquet) then
                  raise Exception.Create('Le repertoire '+Rep+NomPaquet+' est introuvable !')
              ELSE // Recopier les fichiers dans un sous-repertoire Languaging adéquoite
              BEGIN
                   if not DirectoryExists(dest+NomPaquet) then
                      if not CreateDir(dest+NomPaquet) then
                         raise Exception.Create('Impossible de créer '+dest+NomPaquet);
                   RecopyFile(Rep+NomPaquet,dest+NomPaquet);
              END;
          END;
     END;

END;

procedure TForm1.LMDSpeedButton3Click(Sender: TObject);
var DirTrad, DirSource : String;
begin
     // Parcourir C:\Developpement\Ginkoia\Source\Languaging\Italien et remettre le contenu de chaque répertoire
     // dans chaque repertoire C:\Developpement\Ginkoia\Source\Paquets correspondant
     Memo1.Clear;
     Dir_Recup.Folder := 'C:\Developpement\Ginkoia\Source\Languaging\Italien';
     IF Dir_Recup.Execute THEN
     BEGIN
        DirTrad := UPPERCASE(Dir_Recup.SelectedFolder);
        DirSource := copy(DirTrad,1,(length(DirTrad)-Pos('\SOURCE\',DirTrad)+7)); // 7 = longueur de /SOURCE/ - 1 car length(C) demarre à 1
        // Copier les fichiers à la racine *.* dans c:\Developpement\Ginkoia\Source\Caisse
        RecopyFile(DirTrad,DirSource+'Caisse');
        Memo1.Lines.Add(DirTrad+'*.* mis à jour dans '+DirSource+'Caisse');
        // Recupere le "nom de dossier" et chercher les "nom de dossier".dpk et mettre à jour le repertoire
        RecopyDir(DirTrad+'\Caisse',DirSource);
        RecopyDir(DirTrad+'\Ginkoia',DirSource);
        //RecopyDir(DirTrad+'\Paquets Standards',DirSource+'..\Paquets Standards');
        MessageDlg('Traitement terminé !', mtInformation, [mbOK], 0);
     END;
end;

procedure TForm1.LMDSpeedButton4Click(Sender: TObject);
var Fich, RS: TStringList;
    i, max, ind : Integer;
    ch: String;
begin
  try

    Fich := TStringList.Create;

    RS := TStringList.Create;
    RS.LoadFromFile('C:\Developpement\Ginkoia\Source\GinkoiaResStr.pas');
    i := 0;
    max := RS.Count-1;
    WHILE (i<= max) and (UPPERCASE(RS.Strings[i]) <> 'RESOURCESTRING')  do
         inc(i);

    Fich.Add('unit Unit_GRS;');
    Fich.Add('');
    Fich.Add('interface');
    Fich.Add('');
    Fich.Add('uses');
    Fich.Add('  Windows, Messages, SysUtils, Classes, Graphics, Controls,');
    Fich.Add('  Forms, Dialogs, AlgolStdFrm, PrjConst, LocUtils;');
    Fich.Add('');
    Fich.Add('type');
    Fich.Add('  TFrm_GRS = class(TAlgolStdFrm)');
    Fich.Add('    procedure AlgolStdFrmCreate(Sender: TObject);');
    Fich.Add('  private');
    Fich.Add('    { Private declarations }');
    Fich.Add('  protected');
    Fich.Add('    { Protected declarations }');
    Fich.Add('  public');
    Fich.Add('    { Public declarations }');
    Fich.Add('  published');
    Fich.Add('    { Published declarations }');
    Fich.Add('  end;');
    Fich.Add('');
    Fich.Add('var');
    Fich.Add('  Frm_GRS: TFrm_GRS;');
    Fich.Add('');
    Fich.Add('implementation');
    Fich.Add('uses GinkoiaResStr;');
    Fich.Add('{$R *.DFM}');
    Fich.Add('');
    Fich.Add('procedure TFrm_GRS.AlgolStdFrmCreate(Sender: TObject);');
    Fich.Add('begin');
    WHILE (i<= max) and (UPPERCASE(RS.Strings[i]) <> 'IMPLEMENTATION')  do
    BEGIN
         ind := pos('=',RS.Strings[i]);
         IF ind <> 0 then
         BEGIN
            ch := copy(RS.Strings[i],0,ind-1);
            IF (pos(#39,ch) = 0) and (pos('//',ch) =0) then
               Fich.Add('    Frm_GRS.Caption := '+ ch +';');
         END;
         inc(i);
    END;

    Fich.Add('end;');
    Fich.Add('');
    Fich.Add('end.');

    Fich.SaveToFile('C:\Developpement\Ginkoia\Source\Paquets\Pqt_Divers\Unit_GRS.pas');

  finally
    Fich.Free;
    RS.Free;
  END;
  MessageDlg('Traitement terminé !', mtInformation, [mbOK], 0);
end;

procedure TForm1.LMDSpeedButton2Click(Sender: TObject);
var DirTrad, DirSource : String;
begin
     // Parcourir C:\Developpement\Ginkoia\Source\Languaging\Italien et remettre le contenu de chaque répertoire
     // C:\Developpement\Ginkoia\Source\Paquets correspondant
     Memo1.Clear;
     Dir_Recup.Folder := 'C:\Developpement\Ginkoia\Source';
//     \Languaging\Italien
     IF Dir_Recup.Execute THEN
     BEGIN
        DirTrad := UPPERCASE(Dir_Recup.SelectedFolder)+'\Languaging\Italien';
        // Contôler que le repertoire existe, sinon le crée
        if not DirectoryExists(DirTrad) then
             if not CreateDir(DirTrad) then
                raise Exception.Create('Impossible de créer'+DirTrad);
        DirSource := UPPERCASE(Dir_Recup.SelectedFolder);

        // Copier les fichiers à la racine de c:\Developpement\Ginkoia\Source\Caisse\*.* dans C:\Developpement\Ginkoia\Source\Languaging\Italien
        RecopyFile(DirSource+'\Caisse',DirTrad);
        Memo1.Lines.Add(DirSource+'\Caisse''*.* mis à jour dans '+DirTrad);
        // chercher les "nom de dossier".dpk et mettre à jour le repertoire "nom de dossier" dans la traduction
        RecopyDir_DPK(DirSource+'\Paquets',DirTrad+'\Ginkoia');
        RecopyDir_DPK(DirSource+'\Caisse\Paquets',DirTrad+'\Caisse');
        //RecopyDir_DPK(DirSource+'..\Paquets Standards', DirTrad);
        MessageDlg('Traitement terminé !', mtInformation, [mbOK], 0);
     END;
end;

end.
