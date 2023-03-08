UNIT UArchivageMain_Frm;

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
  //début uses
  IniFiles,
  //fin uses
  StdCtrls,
  DB,
  dxmdaset,
  ExtCtrls, ComCtrls; //LMDCustomComponent, LMDIniCtrl;

TYPE
  TFrm_ArchivageMain = CLASS(TForm)
    Pan_Top: TPanel;
    Lab_Encours: TLabel;
    Lab_TitreEnCours: TLabel;
    Btn_Demarrer: TButton;
    Btn_Arret: TButton;
    MemD_BasesTraite: TdxMemData;
    MemD_BasesTraiteDATE: TDateTimeField;
    MemD_BasesTraiteCHEMIN: TStringField;
    Tim_ArchivageBackUp: TTimer;
    pbCopy: TProgressBar;
    Memo1: TMemo;
    PROCEDURE Btn_DemarrerClick(Sender: TObject);
    PROCEDURE Btn_ArretClick(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Tim_ArchivageBackUpTimer(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
  PRIVATE
    { Déclarations privées }
    FFILELOG : String;
    bArreterArchivage: boolean;
    PROCEDURE archivageBackUpRestoreLames();
    procedure AddToMemo(sText : String);

  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_ArchivageMain: TFrm_ArchivageMain;

IMPLEMENTATION

{$R *.dfm}

{ TFrm_ArchivageMain }

function CopyCallBack(
  TotalFileSize: LARGE_INTEGER;          // Taille totale du fichier en octets
  TotalBytesTransferred: LARGE_INTEGER;  // Nombre d'octets déjàs transférés
  StreamSize: LARGE_INTEGER;             // Taille totale du flux en cours
  StreamBytesTransferred: LARGE_INTEGER; // Nombre d'octets déjà tranférés dans ce flus
  dwStreamNumber: DWord;                 // Numéro de flux actuel
  dwCallbackReason: DWord;               // Raison de l'appel de cette fonction
  hSourceFile: THandle;                  // handle du fichier source
  hDestinationFile: THandle;             // handle du fichier destination
  progressBar : TProgressBar
  ): DWord; far; stdcall;

begin
  // Calcul de la position en % :
  ProgressBar.position := TotalBytesTransferred.QuadPart * 100 Div TotalFileSize.QuadPart;
  // La fonction doit définir si la copie peut être continuée.
  Result := PROGRESS_CONTINUE;
  Application.ProcessMessages;
end;


procedure TFrm_ArchivageMain.AddToMemo(sText: String);
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

PROCEDURE TFrm_ArchivageMain.archivageBackUpRestoreLames;
VAR
  sPathOri, sPathLog, sPathDest, sPathReseau, sPathSv : STRING;
  nbLame, I: Integer;
  iniCtrl: TIniFile;

  lpCancel: pointer;
  flag : integer;

BEGIN
  Try
    //charger le paramétrage dans l'ini
    TRY
      IniCtrl := tIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
      nbLame := IniCtrl.ReadInteger('BACKUP_PANTIN', 'NBLAME', 0);
      //pour chaque lame tant que pas arrêt demandé
      WHILE NOT bArreterArchivage DO
      BEGIN
        FOR I := 1 TO nbLame DO
        BEGIN
          Application.ProcessMessages;
          sPathOri := '';
          sPathDest := '';
          //lire le chemin
          sPathReseau := IniCtrl.ReadString('BACKUP_PANTIN', 'EMPLACEMENT_RESEAU' + intToStr(i), '');
          sPathLog := IniCtrl.ReadString('BACKUP_PANTIN', 'CHEMIN' + intToStr(i), '');
          IF (sPathLog <> '') AND (sPathReseau <> '') THEN
          BEGIN
            TRY
              if FileExists(sPathReseau + sPathLog) then
                while FileIsReadOnly(sPathReseau + sPathLog) do
                begin
                  Sleep(1000);
                  Application.ProcessMessages;
                end;

              //se connecter au fichier
              MemD_BasesTraite.LoadFromTextFile(sPathReseau + sPathLog);
              //vérifier si 1 nouveau backUp a archiver : ssi un fichier a archiver à l'emplacement décrit dans la colonne chemin
              MemD_BasesTraite.First;
              WHILE NOT MemD_BasesTraite.Eof DO
              BEGIN
                IF FileExists(sPathReseau + StringReplace(MemD_BasesTraiteCHEMIN.AsString, ':', '$', [rfReplaceAll, rfIgnoreCase])) THEN
                BEGIN
                  sPathOri := MemD_BasesTraiteCHEMIN.AsString;
                  MemD_BasesTraite.Last;
                END
                ELSE
                  MemD_BasesTraite.next;
              END;
            EXCEPT on E:Exception do
              AddToMemo('Erreur : ' + E.Message);
            END;
            //si une base à transferer
            IF (sPathOri <> '') THEN
            BEGIN
              //fabriquer le chemin de destination
              sPathDest := StringReplace(sPathOri, 'EAI\', '', [rfReplaceAll, rfIgnoreCase]);
              sPathDest := StringReplace(sPathDest, 'DATA\', '', [rfReplaceAll, rfIgnoreCase]);
              sPathDest := IniCtrl.ReadString('BACKUP_PANTIN', 'DEST_ARCHIVE', '')
                + StringReplace(sPathReseau, '\\', '', [rfReplaceAll, rfIgnoreCase]) + Copy(sPathDest, 4, length(sPathDest) - 3);
              //            //finaliser le chemin réseau d'origine
              //            sPathOri := sPathReseau + StringReplace(sPathOri, ':', '$', [rfReplaceAll, rfIgnoreCase]);

              //archiver
              //renommer la destination si elle existe déjà
              ForceDirectories(ExtractFilePath(sPathDest));
              IF FileExists(sPathDest) THEN
                RenameFile(sPathDest, sPathDest + '~~~');
              //copier
              Lab_Encours.caption := sPathOri;
              Application.ProcessMessages;

              lpCancel := nil;
              flag     := 0;

              IF CopyfileEx(pchar(sPathReseau + StringReplace(sPathOri, ':', '$', [])), pchar(sPathDest), @CopyCallBack,pbCopy, lpCancel,flag) THEN
              BEGIN
                if not DeleteFile(sPathReseau + StringReplace(sPathOri, ':', '$', [])) then
                  AddToMemo('Echec de la suppression : ' + sPathReseau + StringReplace(sPathOri, ':', '$', []))
                else
                begin // il faut aussi supprimer le SV.GBK
                      // exp:  sPathOri = D:\EAI\SPORT2000\GIROUX\DATA\Bck_GIROUX.IB
                  sPathSv := copy(sPathOri,0, (pos('\DATA\',sPathOri)+6))+'SV.GBK';
                  if not DeleteFile(sPathSv) then
                    AddToMemo('Echec de la suppressiom : '+ sPathSv);
                end;
                //supprimer la sauvegarde plus ancienne
                IF FileExists(sPathDest + '~~~') THEN
                  deleteFile(sPathDest + '~~~');
                Lab_Encours.caption := '';
              END
              ELSE
              BEGIN
                //rétablir la sauvegarde plus ancienne
                IF FileExists(sPathDest + '~~~') THEN
                  RenameFile(sPathDest, StringReplace(sPathDest, '~~~', '', [rfReplaceAll, rfIgnoreCase]));
              END;
            END //sinon temporiser un peu
            ELSE
            BEGIN
              Lab_Encours.caption := '';
              Application.ProcessMessages;
              Sleep(1000);
              Lab_Encours.caption := 'pas de base à traiter pour l''instant';
              Application.ProcessMessages;
              Sleep(1000);
            END;
          END;
        END;
      END;
    FINALLY
      iniCtrl.free;
      btn_demarrer.enabled := true;
    END;
  Except on E:Exception do
    AddToMemo('Erreur Générale : ' + E.Message);
  End;
END;

PROCEDURE TFrm_ArchivageMain.Btn_ArretClick(Sender: TObject);
BEGIN
  bArreterArchivage := true;
  Btn_Arret.enabled := false;
  btn_demarrer.enabled := false;
END;

PROCEDURE TFrm_ArchivageMain.Btn_DemarrerClick(Sender: TObject);
BEGIN
  bArreterArchivage := false;
    btn_demarrer.enabled := false;
  Btn_Arret.enabled := true;
  archivageBackUpRestoreLames;
END;

PROCEDURE TFrm_ArchivageMain.FormClose(Sender: TObject;
  VAR Action: TCloseAction);
BEGIN
  Btn_Arret.click;
END;

PROCEDURE TFrm_ArchivageMain.FormCreate(Sender: TObject);
BEGIN
  // gestion du ficheri de log
  FFILELOG := changeFileExt(Application.ExeName,'.log');

  if FileExists(FFILELOG) then
    DeleteFile(FFILELOG);


  bArreterArchivage := false;
  btn_demarrer.enabled := false;
END;

PROCEDURE TFrm_ArchivageMain.FormShow(Sender: TObject);
BEGIN
  Tim_ArchivageBackUp.Enabled := true;
END;

PROCEDURE TFrm_ArchivageMain.Tim_ArchivageBackUpTimer(Sender: TObject);
BEGIN
  Tim_ArchivageBackUp.enabled := false;
  Application.ProcessMessages;
  archivageBackUpRestoreLames;
END;

END.

