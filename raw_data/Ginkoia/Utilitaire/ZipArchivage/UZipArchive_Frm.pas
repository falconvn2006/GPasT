UNIT UZipArchive_Frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  //debut uses
  sevenZip,
  //fin uses
  StdCtrls,
  ExtCtrls,
  LMDCustomComponent,
  LMDFileGrep, LMDOneInstance,
  IniFiles;

TYPE
  TFrm_ZipArchivage = CLASS(TForm)
    Tim_ZipBackUp: TTimer;
    LMDFileGrep: TLMDFileGrep;
    LMDOneInstance1: TLMDOneInstance;
    Memo1: TMemo;
    Pan_Top: TPanel;
    Lab_Encours: TLabel;
    Lab_TitreEnCours: TLabel;
    Btn_Demarrer: TButton;
    Btn_Arret: TButton;
    PROCEDURE Btn_DemarrerClick(Sender: TObject);
    PROCEDURE Btn_ArretClick(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Tim_ArchivageBackUpTimer(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
  PRIVATE
    { Déclarations privées }
    FFILELOG : String;
    sScanPath : String;
    bArreterZipArchivage: Boolean;
    PROCEDURE zipArchiveBackUP;

    procedure AddToMemo(sText : String);
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_ZipArchivage: TFrm_ZipArchivage;

IMPLEMENTATION

{$R *.dfm}

PROCEDURE TFrm_ZipArchivage.Btn_ArretClick(Sender: TObject);
BEGIN
  bArreterZipArchivage := true;
  Btn_Arret.enabled := false;
  btn_demarrer.enabled := true;
END;

PROCEDURE TFrm_ZipArchivage.Btn_DemarrerClick(Sender: TObject);
BEGIN
  bArreterZipArchivage := false;
  btn_demarrer.enabled := false;
  Btn_Arret.enabled := true;
  zipArchiveBackUP;
END;

PROCEDURE TFrm_ZipArchivage.FormClose(Sender: TObject;
  VAR Action: TCloseAction);
BEGIN
  Btn_Arret.click;
  UnloadSevenZipDLL;
END;

PROCEDURE TFrm_ZipArchivage.FormCreate(Sender: TObject);
BEGIN
  // Récupération du chemin à scanner
  With TIniFile.Create(ExtractFilePath(Application.ExeName)+ changeFileExt(ExtractFileName(Application.ExeName),'.ini')) do
  begin
    sScanPath := ReadString('DIRS','SCANPATH','D:\BackUp\');
  end;

  // gestion du ficheri de log
  FFILELOG := changeFileExt(Application.ExeName,'.log');

  if FileExists(FFILELOG) then
    DeleteFile(FFILELOG);

  //  Initialisation
  bArreterZipArchivage := false;
  btn_demarrer.enabled := false;
  LoadSevenZipDLL;
END;

PROCEDURE TFrm_ZipArchivage.FormShow(Sender: TObject);
BEGIN
  Tim_ZipBackUp.Enabled := true;
END;

PROCEDURE TFrm_ZipArchivage.Tim_ArchivageBackUpTimer(Sender: TObject);
VAR
  sPathBase: STRING;
  i : integer;
BEGIN
  Tim_ZipBackUp.enabled := false;
 // Application.ProcessMessages;
 // zipArchiveBackUP;
 Try
      //parcourir récursivement les dossiers dans \\backUp\ pour zip les fichiers qui ne le sont pas encore
      WITH LMDFileGrep DO
      BEGIN
        Dirs := sScanPath; // 'D:\BackUp\';
        FileMasks := '*.ib;*.gdb';
        RecurseSubDirs := true;
        Grep;
        IF Files.Count = 0 THEN //temporiser
        BEGIN
          lab_encours.caption := 'pas de base à traiter pour l''instant';
          application.ProcessMessages;
          Sleep(1000);
          lab_encours.caption := '';
          application.ProcessMessages;
          Sleep(1000);
        END
        ELSE //sinon zipper
        BEGIN
          FOR i := Files.Count - 1 DOWNTO 0 DO
          BEGIN
            //récupèrer chemin + nom fichier
            sPathBase := StringReplace(Files[i], ';', '', [rfReplaceAll]);
            //            //renommer l'ancien zip
            //            if FileExists(ChangeFileExt(sPathBase, '.7z')) then
            //              RenameFile(ChangeFileExt(sPathBase, '.7z'),ChangeFileExt(sPathBase, '.old'));
            lab_encours.caption := sPathBase;
            //zipper dès que libre
            if FileExists(sPathBase) then
              WHILE FileIsReadOnly (sPathBase) do // RenameFile(sPathBase, sPathBase) DO
              BEGIN
                Sleep(1000);
                application.ProcessMessages;
              END;
            AddToMemo('Compression de :' + AnsiQuotedStr(ExtractFileName(sPathBase), '"'));
            AddToMemo('Vers : ' + ChangeFileExt(ExtractFileName(sPathBase), '.zip'));
            AddToMemo('Répertoire : ' + ExtractFilePath(sPathBase));

           IF SevenZipCreateArchive(Application.Handle,
              ChangeFileExt(ExtractFileName(sPathBase), '.zip'), //nom de l'archive
              ExtractFilePath(sPathBase), //répertoire
              ExtractFileName(sPathBase), //fichier à zipper AnsiQuotedStr(ExtractFileName(sPathBase), '"')
              True,
              9,
              True, // Laisser à true sinon erreur lors de la compression en .zip
              false,
              '',
              true) = 0 THEN
            BEGIN
              AddToMemo('Compression réussit');
              //supprimer le fichier non zipper après le zippage  et l'ancien zip
              if DeleteFile(sPathBase) then
                AddToMemo('Suppression réussit du fichier : ' + sPathBase)
              else
                AddToMemo('Echec de suppression du fichier : ' + sPathBase);
            END
            else begin
              AddToMemo('Echec de compression du fichier : ' + sPathBase);
            end;
          END;
        END;
      END;
    Tim_ZipBackUp.enabled := True;
  EXCEPT on E:Exception do
    begin
      AddToMemo('Erreur générale : ' + E.Message);
      UnloadSevenZipDLL;
    end;
  END;


END;

PROCEDURE TFrm_ZipArchivage.zipArchiveBackUP;
VAR
  sPathBase: STRING;
  i : integer;
BEGIN
  TRY
    WHILE NOT bArreterZipArchivage DO
    BEGIN
      //parcourir récursivement les dossiers dans \\backUp\ pour zip les fichiers qui ne le sont pas encore
      WITH LMDFileGrep DO
      BEGIN
        Dirs := sScanPath; // 'D:\BackUp\';
        FileMasks := '*.ib;*.gdb';
        RecurseSubDirs := true;
        Grep;
        IF Files.Count = 0 THEN //temporiser
        BEGIN
          lab_encours.caption := 'pas de base à traiter pour l''instant';
          application.ProcessMessages;
          Sleep(1000);
          lab_encours.caption := '';
          application.ProcessMessages;
          Sleep(1000);
        END
        ELSE //sinon zipper
        BEGIN
          FOR i := Files.Count - 1 DOWNTO 0 DO
          BEGIN
            //récupèrer chemin + nom fichier
            sPathBase := StringReplace(Files[i], ';', '', [rfReplaceAll]);
            //            //renommer l'ancien zip
            //            if FileExists(ChangeFileExt(sPathBase, '.7z')) then
            //              RenameFile(ChangeFileExt(sPathBase, '.7z'),ChangeFileExt(sPathBase, '.old'));
            lab_encours.caption := sPathBase;
            //zipper dès que libre
            if FileExists(sPathBase) then
              WHILE FileIsReadOnly (sPathBase) do // RenameFile(sPathBase, sPathBase) DO
              BEGIN
                Sleep(1000);
                application.ProcessMessages;
              END;
            AddToMemo('Compression de :' + AnsiQuotedStr(ExtractFileName(sPathBase), '"'));
            AddToMemo('Vers : ' + ChangeFileExt(ExtractFileName(sPathBase), '.zip'));
            AddToMemo('Répertoire : ' + ExtractFilePath(sPathBase));

           IF SevenZipCreateArchive(Application.Handle,
              ChangeFileExt(ExtractFileName(sPathBase), '.zip'), //nom de l'archive
              ExtractFilePath(sPathBase), //répertoire
              ExtractFileName(sPathBase), //fichier à zipper AnsiQuotedStr(ExtractFileName(sPathBase), '"')
              True,
              9,
              True, // Laisser à true sinon erreur lors de la compression en .zip
              false,
              '',
              true) = 0 THEN
            BEGIN
              AddToMemo('Compression réussit');
              //supprimer le fichier non zipper après le zippage  et l'ancien zip
              if DeleteFile(sPathBase) then
                AddToMemo('Suppression réussit du fichier : ' + sPathBase)
              else
                AddToMemo('Echec de suppression du fichier : ' + sPathBase);
            END
            else begin
              AddToMemo('Echec de compression du fichier : ' + sPathBase);
            end;

          END;
        END;
      END;
    END;
  EXCEPT on E:Exception do
    begin
      AddToMemo('Erreur générale : ' + E.Message);
      UnloadSevenZipDLL;
    end;
  END;
END;

procedure TFrm_ZipArchivage.AddToMemo(sText: String);
var
  FFile : TextFile;
  sLigne : String;
begin
  sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] -> ',Now) + sText;

  while Memo1.Lines.Count > 500 do
    Memo1.Lines.Delete(0);
  Memo1.Lines.Add(sLigne);

  Try
    AssignFile(FFile, FFILELOG);
    try
      if FileExists(FFILELOG) then
       Append(FFile)
      else
        Rewrite(FFile);
      Writeln(FFile,sLigne);
    finally
      CloseFile(FFile);
    end;
  Except
  End;
end;


END.

