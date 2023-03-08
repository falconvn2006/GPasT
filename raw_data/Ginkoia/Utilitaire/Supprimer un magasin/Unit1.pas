unit Unit1;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI, Vcl.ComCtrls, System.StrUtils, System.IOUtils,
  FireDAC.Phys.IBWrapper, System.IniFiles, VCL.uThreadProc, System.Math;

const
   VERSION_BASE_MIN = 18.1;

type
  TFormMain = class(TForm)
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysIBDriverLink: TFDPhysIBDriverLink;
    OpenDialogBase: TOpenDialog;
    Panel: TPanel;
    RichEdit: TRichEdit;
    EditBDD: TLabeledEdit;
    BtnSelectionnerBase: TBitBtn;
    LabelMagasin: TLabel;
    FDTransaction: TFDTransaction;
    FDIBBackup: TFDIBBackup;
    FDIBRestore: TFDIBRestore;
    EditProcedures: TLabeledEdit;
    BtnSupprimer: TBitBtn;
    BtnSelectionnerProcedures: TBitBtn;
    OpenDialogProcedures: TFileOpenDialog;
    PanelMagasin: TPanel;
    GroupBoxGUID: TGroupBox;
    RadioButtonPasVider: TRadioButton;
    RadioButtonViderGUIDMagasin: TRadioButton;
    RadioButtonViderTousGUID: TRadioButton;
    LabelGUID: TLabel;
    CheckBoxViderMagCode: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnSelectionnerProceduresClick(Sender: TObject);
    procedure BtnSelectionnerBaseClick(Sender: TObject);
    procedure PanelMagasinClick(Sender: TObject);
    procedure BtnSupprimerClick(Sender: TObject);
    procedure FDIBBackupProgress(ASender: TFDPhysDriverService; const AMessage: string);
    procedure FDIBRestoreProgress(ASender: TFDPhysDriverService; const AMessage: string);

  private
    _bTraitementEnCours, _bBackupEnCours, _bAnnuler: Boolean;
    _szFichierLog: String;

    function Login: Boolean;
    procedure ConnexionBDD;
    function GetVersion: Double;
    function TailleDisqueSuffisante: Boolean;
    procedure GestionInterface(const bActiver: Boolean);
    function GestionGUID: Integer;
    procedure AjoutTexte(const sTexte: String; const bLog: Boolean = False);
    procedure AjoutLog(const szLigne: String);
    function CreerProcedure(const sFichier: String): Boolean;
    function ExecuterProcedure(const sProcedure: String; const nIDMag: Integer): Boolean;
    function ExecuterProcedureSupprimerUnMag(const sProcedure: String; const nIDMag, nViderGUID: Integer; const bViderMagCode: Boolean): Boolean;
    procedure DropProcedures(const sProcedure: String);

  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses UnitLogin, UnitMagasins;

procedure TFormMain.FormCreate(Sender: TObject);
var
   FichierINI: TIniFile;
begin
   EditProcedures.Text := ExtractFilePath(Application.ExeName) + 'Procédures\';

   FichierINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
   try
      EditProcedures.Text := IncludeTrailingPathDelimiter(FichierINI.ReadString('Paramètres', 'Procédures', ''));
//      EditBDD.Text := FichierINI.ReadString('Paramètres', 'BDD', '');
   finally
      FichierINI.Free;
   end;

   _bTraitementEnCours := False;
   _bBackupEnCours := False;
   _bAnnuler := False;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
//   if EditBDD.Text <> '' then
//      Login;
end;

procedure TFormMain.BtnSelectionnerProceduresClick(Sender: TObject);
var
   FichierINI: TIniFile;
begin
   // Si validation.
   if OpenDialogProcedures.Execute then
   begin
      EditProcedures.Text := IncludeTrailingPathDelimiter(OpenDialogProcedures.FileName);

      FichierINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
      try
         FichierINI.WriteString('Paramètres', 'Procédures', EditProcedures.Text);
      finally
         FichierINI.Free;
      end;
   end;
end;

procedure TFormMain.BtnSelectionnerBaseClick(Sender: TObject);
begin
   EditBDD.Text := '';
   PanelMagasin.Enabled := False;      PanelMagasin.Caption := '';      PanelMagasin.Tag := 0;
   BtnSupprimer.Enabled := False;

   // Si validation.
   if OpenDialogBase.Execute then
   begin
      // Si fichier incorrect.
      if LowerCase(ExtractFileName(OpenDialogBase.FileName)) = 'ginkoia.ib' then
      begin
         Application.MessageBox(PChar('Attention :  le traitement n''est pas possible sur cette base !'), PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
         Exit;
      end;

      EditBDD.Text := OpenDialogBase.FileName;
      if Login then
         PanelMagasinClick(Sender);
   end;
end;

function TFormMain.Login: Boolean;
var
   FichierINI: TIniFile;
begin
   Result := False;
   ConnexionBDD;

   // Si version inférieure.
   if GetVersion < VERSION_BASE_MIN then
   begin
      Application.MessageBox(PChar('Attention :  la base n''est pas en version minimum [' + StringReplace(FloatToStr(VERSION_BASE_MIN), ',', '.', []) + '] !'), PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
      Exit;
   end;

   // Si connexion.
   if FormLogin.ShowModal = mrOk then
   begin
      PanelMagasin.Enabled := True;
      FichierINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
      try
         FichierINI.WriteString('Paramètres', 'BDD', EditBDD.Text);
      finally
         FichierINI.Free;
      end;

      Result := True;
   end
   else
   begin
      PanelMagasin.Enabled := False;
      BtnSupprimer.Enabled := False;
   end;
end;

procedure TFormMain.ConnexionBDD;
begin
   PanelMagasin.Enabled := False;      PanelMagasin.Caption := '';      PanelMagasin.Tag := 0;
   BtnSupprimer.Enabled := False;

   if(EditBDD.Text <> '') and (FileExists(EditBDD.Text)) then
   begin
      // Connexion.
      FDConnection.Close;
      FDConnection.Params.Database := EditBDD.Text;
      try
         FDConnection.Open;
      except
         on E: Exception do
         begin
            Application.MessageBox(Pchar('Erreur :  la connexion à [' + FDConnection.Params.Database + '] a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
            Exit;
         end;
      end;
   end;
end;

procedure TFormMain.PanelMagasinClick(Sender: TObject);
begin
   PanelMagasin.Caption := '';      PanelMagasin.Tag := 0;
   BtnSupprimer.Enabled := False;

   // Si validation.
   if FormMagasins.ShowModal = mrOk then
   begin
      PanelMagasin.Caption := FormMagasins.FDQuery.FieldByName('MAG_ID').AsString + ' - ' + FormMagasins.FDQuery.FieldByName('MAG_NOM').AsString + ' - ' + FormMagasins.FDQuery.FieldByName('MAG_CODEADH').AsString + ' - ' + FormMagasins.FDQuery.FieldByName('MAG_ENSEIGNE').AsString + ' - ' + FormMagasins.FDQuery.FieldByName('VIL_NOM').AsString;
      PanelMagasin.Hint := PanelMagasin.Caption;
      PanelMagasin.Tag := FormMagasins.FDQuery.FieldByName('MAG_ID').AsInteger;
      BtnSupprimer.Enabled := True;
      BtnSupprimer.SetFocus;
   end
   else
      PanelMagasin.SetFocus;
end;

function TFormMain.GetVersion: Double;
begin
   Result := 0;

   // Recherche de la version.
   FDQuery.Close;
   FDQuery.SQL.Clear;
   FDQuery.SQL.Add('select VER_VERSION');
   FDQuery.SQL.Add('from GENVERSION');
   FDQuery.SQL.Add('where VER_DATE = (select max(VER_DATE) from GENVERSION)');
   try
      FDQuery.Open;
   except
      on E: Exception do
      begin
         AjoutTexte('Erreur :  la recherche de la version a échoué !' + #13#10 + E.Message);
         Exit;
      end;
   end;
   if not FDQuery.IsEmpty then
      TryStrToFloat(StringReplace(LeftStr(FDQuery.FieldByName('VER_VERSION').AsString, 4), '.', FormatSettings.DecimalSeparator, []), Result);
end;

function TFormMain.TailleDisqueSuffisante: Boolean;
{$REGION 'TailleDisqueSuffisante'}
   function GetTailleFichier(const szFichier: String): Int64;
   var
      sr: TSearchRec;
   begin
      Result := 0;
      if FindFirst(szFichier, faAnyFile, sr) = 0 then
      begin
         try
            Result := Int64(sr.FindData.nFileSizeHigh) shl 32 + sr.FindData.nFileSizeLow;
         finally
            FindClose(sr);
         end;
      end;
   end;
{$ENDREGION}
var
   szLecteur: String;
   nLibre, nFichier: Int64;
begin
   Result := True;
   szLecteur := ExtractFileDrive(EditBDD.Text);
   if(Length(szLecteur) > 0) and (szLecteur[1] <> '\') then
   begin
      nLibre := DiskFree(Ord(szLecteur[1]) - 64);
      nFichier := GetTailleFichier(EditBDD.Text);
      if(nFichier * 2.5) >= nLibre then
      begin
         Result := False;
         AjoutTexte('Taille espace libre :  ' + FormatFloat(',##0', nLibre) + IfThen(nLibre > 1, ' octets.', ' octet.'));
         AjoutTexte('Taille base :  ' + FormatFloat(',##0', nFichier) + IfThen(nFichier > 1, ' octets.', ' octet.'));
      end;
   end;
end;

procedure TFormMain.GestionInterface(const bActiver: Boolean);
begin
   EditProcedures.Enabled := bActiver;
   BtnSelectionnerProcedures.Enabled := bActiver;
   EditBDD.Enabled := bActiver;
   BtnSelectionnerBase.Enabled := bActiver;
   LabelMagasin.Enabled := bActiver;
   PanelMagasin.Enabled := bActiver;
   LabelGUID.Enabled := bActiver;
   GroupBoxGUID.Enabled := bActiver;
   CheckBoxViderMagCode.Enabled := bActiver;
end;

function TFormMain.GestionGUID: Integer;
begin
   Result := 0;
   if RadioButtonPasVider.Checked then
      Result := 0
   else if RadioButtonViderGUIDMagasin.Checked then
      Result := 1
   else if RadioButtonViderTousGUID.Checked then
      Result := 2;
end;

procedure TFormMain.BtnSupprimerClick(Sender: TObject);
var
   dVersion: Double;
   sFichierSauvegarde: String;
begin
   // Si traitement en cours.
   if _bTraitementEnCours then
   begin
      // Demande d'annulation.
      _bAnnuler := True;
      BtnSupprimer.Enabled := False;
      if _bBackupEnCours then
         AjoutTexte('Annulation du traitement après la fin du backup ...', True);
      Application.ProcessMessages;
   end
   else
   begin
      // Vérifications.
      RichEdit.Clear;
      if EditProcedures.Text = '' then
      begin
         BtnSelectionnerProceduresClick(Sender);
         Exit;
      end;
      EditProcedures.Text := IncludeTrailingPathDelimiter(EditProcedures.Text);
      if EditBDD.Text = '' then
      begin
         BtnSelectionnerBaseClick(Sender);
         Exit;
      end;
      if not FDConnection.Connected then
      begin
         Login;
         Exit;
      end;
      if PanelMagasin.Tag = 0 then
      begin
         PanelMagasinClick(nil);
         Exit;
      end;

      // Si version inférieure.
      dVersion := GetVersion;
      if dVersion < VERSION_BASE_MIN then
      begin
         Application.MessageBox(PChar('Attention :  la base n''est pas en version minimum [' + StringReplace(FloatToStr(VERSION_BASE_MIN), ',', '.', []) + '] !'), PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
         Exit;
      end;

      // Si espace disque faible.
      if not TailleDisqueSuffisante then
      begin
         if Application.MessageBox(PChar('Attention :  l''espace disque restant peut être insuffisant !' + #13#10 + 'Voulez-vous continuer ?'), PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_YESNO + MB_DEFBUTTON2) = ID_NO then
            Exit;
      end;

      _szFichierLog := '';
      if ForceDirectories(ExtractFilePath(Application.ExeName) + 'Logs') then
         _szFichierLog := ExtractFilePath(Application.ExeName) + 'Logs\SupprimerUnMagasin ' + FormatDateTime('yyyy-mm-dd hh-nn-ss', Now) + '.log';
      AjoutTexte('Version base :  ' + StringReplace(FloatToStr(dVersion), ',', '.', []), True);
      AjoutTexte('Magasin à supprimer :  ' + PanelMagasin.Caption, True);

      // Traitement.
      GestionInterface(False);
      BtnSupprimer.Caption := '&Annuler';
      _bAnnuler := False;
      _bTraitementEnCours := True;
      try
         AjoutTexte('Début traitement.', True);
         DropProcedures('SUPPRIMER_UN_MAG');
         DropProcedures('NETTOIE_ATELIER');
         DropProcedures('NETTOIE_NEGOCE');
         DropProcedures('NETTOIE_RECEPTION');
         DropProcedures('NETTOIE_COMMANDE');
         DropProcedures('NETTOIE_CONSODIV');
         DropProcedures('NETTOIE_TIM');
         DropProcedures('NETTOIE_STOCK');
         DropProcedures('NETTOIE_CAISSE');
         DropProcedures('NETTOIE_LOCATION');
         DropProcedures('NETTOIE_CLIENT');
         DropProcedures('NETTOIE_ENTREPOT');
         DropProcedures('NETTOIE_DEPOTVENTE');
         DropProcedures('NETTOIE_INVENTAIRE');
         AjoutTexte('', True);
         if _bAnnuler then
            Exit;

         // Création.
         if not CreerProcedure(EditProcedures.Text + '01_NETTOIE_ATELIER.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '02_NETTOIE_NEGOCE.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '03_NETTOIE_RECEPTION.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '04_NETTOIE_COMMANDE.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '05_NETTOIE_CONSODIV.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '06_NETTOIE_TIM.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '07_NETTOIE_STOCK.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '08_NETTOIE_CAISSE.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '09_NETTOIE_LOCATION.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '10_NETTOIE_CLIENT.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '11_NETTOIE_ENTREPOT.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '12_NETTOIE_DEPOTVENTE.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + '13_NETTOIE_INVENTAIRE.sql') then
            Exit;
         if not CreerProcedure(EditProcedures.Text + 'SUPPRIMER_UN_MAG.sql') then
            Exit;
         AjoutTexte('', True);
         if _bAnnuler then
            Exit;

         // Traitement.
         FDTransaction.StartTransaction;
         if not ExecuterProcedure('NETTOIE_ATELIER', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_NEGOCE', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_RECEPTION', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_COMMANDE', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_CONSODIV', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_TIM', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_STOCK', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_CAISSE', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_LOCATION', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_CLIENT', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_ENTREPOT', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_DEPOTVENTE', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedure('NETTOIE_INVENTAIRE', PanelMagasin.Tag) then
            Exit;
         if _bAnnuler then
            Exit;
         if not ExecuterProcedureSupprimerUnMag('SUPPRIMER_UN_MAG', PanelMagasin.Tag, GestionGUID, CheckBoxViderMagCode.Checked) then
            Exit;
         FDTransaction.Commit;
         AjoutTexte('', True);
         if _bAnnuler then
            Exit;

         // Suppression.
         DropProcedures('SUPPRIMER_UN_MAG');
         DropProcedures('NETTOIE_ATELIER');
         DropProcedures('NETTOIE_NEGOCE');
         DropProcedures('NETTOIE_RECEPTION');
         DropProcedures('NETTOIE_COMMANDE');
         DropProcedures('NETTOIE_CONSODIV');
         DropProcedures('NETTOIE_TIM');
         DropProcedures('NETTOIE_STOCK');
         DropProcedures('NETTOIE_CAISSE');
         DropProcedures('NETTOIE_LOCATION');
         DropProcedures('NETTOIE_CLIENT');
         DropProcedures('NETTOIE_ENTREPOT');
         DropProcedures('NETTOIE_DEPOTVENTE');
         DropProcedures('NETTOIE_INVENTAIRE');
         AjoutTexte('', True);
         if _bAnnuler then
            Exit;

         // Backup.
         _bBackupEnCours := True;
         AjoutTexte('Backup en cours ...', True);
         FDConnection.Close;
         sFichierSauvegarde := ExtractFilePath(EditBDD.Text) + TPath.GetFileNameWithoutExtension(EditBDD.Text) + '.gbk';
         FDIBBackup.Database := EditBDD.Text;
         FDIBBackup.BackupFiles.Clear;
         FDIBBackup.BackupFiles.Add(sFichierSauvegarde);
         try
            FDIBBackup.Backup;
         except
            on E: Exception do
            begin
               AjoutTexte('Erreur :  le backup a échoué !' + #13#10 + E.Message, True);
               Exit;
            end;
         end;
         AjoutTexte('Backup terminé.', True);
         _bBackupEnCours := False;
         AjoutTexte('', True);
         if _bAnnuler then
            Exit;
         BtnSupprimer.Enabled := False;
         Application.ProcessMessages;

         // Restauration.
         AjoutTexte('Restauration en cours ...', True);
         FDIBRestore.Database := EditBDD.Text;
         FDIBRestore.BackupFiles.Clear;
         FDIBRestore.BackupFiles.Add(sFichierSauvegarde);
         try
            FDIBRestore.Restore;
         except
            on E: Exception do
            begin
               AjoutTexte('Erreur :  la restauration a échoué !' + #13#10 + E.Message, True);
               Exit;
            end;
         end;
         AjoutTexte('Restauration terminée.', True);

         // Suppression du fichier 'gbk'.
         if FileExists(ChangeFileExt(EditBDD.Text, '.gbk')) then
         begin
            AjoutTexte('', True);
            if DeleteFile(ChangeFileExt(EditBDD.Text, '.gbk')) then
               AjoutTexte('Suppression du fichier [' + ChangeFileExt(EditBDD.Text, '.gbk') + '].', True)
            else
               AjoutTexte('Erreur :  la suppression du fichier [' + ChangeFileExt(EditBDD.Text, '.gbk') + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError), True);
         end;

         AjoutTexte('Traitement terminé.', True);
      finally
         GestionInterface(True);

         _bTraitementEnCours := False;      _bBackupEnCours := False;
         BtnSupprimer.Caption := '&Supprimer';
         BtnSupprimer.Enabled := True;
         PanelMagasin.SetFocus;
      end;
   end;
end;

procedure TFormMain.AjoutTexte(const sTexte: String; const bLog: Boolean);
begin
   RichEdit.Lines.Add('[' + FormatDateTime('hh:nn:ss:zzz', Now) + ']  ' + sTexte);
   RichEdit.Perform(WM_VSCROLL, SB_BOTTOM, 0);
   Application.ProcessMessages;

   if bLog then
      AjoutLog('[' + FormatDateTime('hh:nn:ss:zzz', Now) + ']  ' + sTexte);
end;

procedure TFormMain.AjoutLog(const szLigne: String);
var
   F: TextFile;
begin
   if _szFichierLog = '' then
      Exit;

   AssignFile(F, _szFichierLog);
   try
      if FileExists(_szFichierLog) then
         Append(F)
      else
         Rewrite(F);

      Writeln(F, szLigne);
   finally
      CloseFile(F);
   end;
end;

procedure TFormMain.FDIBBackupProgress(ASender: TFDPhysDriverService; const AMessage: string);
begin
   AjoutTexte(AMessage);
end;

procedure TFormMain.FDIBRestoreProgress(ASender: TFDPhysDriverService; const AMessage: string);
begin
   AjoutTexte(AMessage);
end;

function TFormMain.CreerProcedure(const sFichier: String): Boolean;
var
   Script: TStringList;
   F: TextFile;
   sLigne: String;
begin
   Result := False;
   if not FileExists(sFichier) then
   begin
      AjoutTexte('Erreur :  le fichier [' + sFichier + '] n''existe pas !', True);
      Exit;
   end;

   Script := TStringList.Create;
   try
      // Chargement du fichier.
      AssignFile(F, sFichier);
      try
         Reset(F);
         while not Eof(F) do
         begin
            Readln(F, sLigne);
            Script.Add(sLigne);
         end;
      finally
         CloseFile(F);
      end;

      FDTransaction.StartTransaction;

      // Création de la procédure.
      FDQuery.Close;
      FDQuery.SQL.Clear;
      FDQuery.SQL.AddStrings(Script);
      try
         FDQuery.ExecSQL;
      except
         on E: Exception do
         begin
            FDTransaction.Rollback;
            AjoutTexte('Erreur :  la création de la procédure [' + ExtractFileName(sFichier) + '] a échoué !' + #13#10 + E.Message, True);
            Exit;
         end;
      end;

      FDTransaction.Commit;
      AjoutTexte('Procédure [' + ExtractFileName(sFichier) + '] créée.', True);
      Result := True;
   finally
      Script.Free;
   end;
end;

function TFormMain.ExecuterProcedure(const sProcedure: String; const nIDMag: Integer): Boolean;
var
   bResultat: Boolean;
begin
   bResultat := True;
   AjoutTexte('Procédure [' + sProcedure + '] en cours ...');

   TThreadProc.RunInThread(
      procedure
      begin
         // Exécution de la procédure.
         FDQuery.Close;
         FDQuery.SQL.Clear;
         FDQuery.SQL.Add('execute procedure ' + sProcedure + '(:MAGID)');
         try
            FDQuery.ParamByName('MAGID').AsInteger := nIDMag;
            FDQuery.ExecSQL;
         except
            on E: Exception do
            begin
               FDTransaction.Rollback;
               RichEdit.Lines.Delete(RichEdit.Lines.Count - 1);
               AjoutTexte('Erreur :  l''exécution de la procédure [' + sProcedure + '] a échoué !' + #13#10 + E.Message, True);
               bResultat := False;
            end;
         end;
      end
   ).RunAndWait;

   if bResultat then
   begin
      RichEdit.Lines.Delete(RichEdit.Lines.Count - 1);
      AjoutTexte('Procédure [' + sProcedure + '] exécutée.', True);
   end;
   Result := bResultat;
end;

function TFormMain.ExecuterProcedureSupprimerUnMag(const sProcedure: String; const nIDMag, nViderGUID: Integer; const bViderMagCode: Boolean): Boolean;
var
   bResultat: Boolean;
begin
   bResultat := True;
   AjoutTexte('Procédure [' + sProcedure + '] en cours ...');

   TThreadProc.RunInThread(
      procedure
      begin
         // Exécution de la procédure.
         FDQuery.Close;
         FDQuery.SQL.Clear;
         FDQuery.SQL.Add('execute procedure ' + sProcedure + '(:MAGID, :VIDER_GUID, :VIDER_MAG_CODE)');
         try
            FDQuery.ParamByName('MAGID').AsInteger := nIDMag;
            FDQuery.ParamByName('VIDER_GUID').AsInteger := nViderGUID;
            FDQuery.ParamByName('VIDER_MAG_CODE').AsInteger := IfThen(bViderMagCode, 1, 0);
            FDQuery.ExecSQL;
         except
            on E: Exception do
            begin
               FDTransaction.Rollback;
               RichEdit.Lines.Delete(RichEdit.Lines.Count - 1);
               AjoutTexte('Erreur :  l''exécution de la procédure [' + sProcedure + '] a échoué !' + #13#10 + E.Message, True);
               bResultat := False;
            end;
         end;
      end
   ).RunAndWait;

   if bResultat then
   begin
      RichEdit.Lines.Delete(RichEdit.Lines.Count - 1);
      AjoutTexte('Procédure [' + sProcedure + '] exécutée.', True);
   end;
   Result := bResultat;
end;

procedure TFormMain.DropProcedures(const sProcedure: String);
begin
   // Recherche de la procédure.
   FDQuery.Close;
   FDQuery.SQL.Clear;
   FDQuery.SQL.Add('select count(*)');
   FDQuery.SQL.Add('from RDB$PROCEDURES');
   FDQuery.SQL.Add('where upper(RDB$PROCEDURE_NAME) = upper(:NomProcedure)');
   try
      FDQuery.ParamByName('NomProcedure').AsString := sProcedure;
      FDQuery.Open;
   except
      on E: Exception do
      begin
         AjoutTexte('Erreur :  la recherche de la procédure [' + sProcedure + '] a échoué !' + #13#10 + E.Message, True);
         Exit;
      end;
   end;
   if FDQuery.Fields[0].AsInteger > 0 then
   begin
      // Suppression de la procédure.
      FDQuery.Close;
      FDQuery.SQL.Clear;
      FDQuery.SQL.Add('drop procedure ' + sProcedure);
      try
         FDQuery.ExecSQL;
      except
         on E: Exception do
         begin
            AjoutTexte('Erreur :  la suppression de la procédure [' + sProcedure + '] a échoué !' + #13#10 + E.Message, True);
            Exit;
         end;
      end;

      AjoutTexte('Procédure [' + sProcedure + '] supprimée.', True);
   end;
end;

end.

