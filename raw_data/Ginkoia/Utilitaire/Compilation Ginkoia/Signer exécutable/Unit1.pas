unit Unit1;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, uDefs, ExtCtrls, INIFiles, FileCtrl,
  StrUtils, Math, LaunchProcess;

type
  TMainForm = class(TForm)
    Nbt_Signer: TBitBtn;
    EditFichier: TLabeledEdit;
    EditCertificat: TLabeledEdit;
    EditServeurHorodatage: TLabeledEdit;
    Nbt_SelectionnerFichier: TBitBtn;
    Nbt_Certificat: TBitBtn;
    OpenDialogFichier: TOpenDialog;
    OpenDialogCertificat: TOpenDialog;
    EditRepertoire: TLabeledEdit;
    Nbt_SelectionnerRepertoire: TBitBtn;
    FileOpenDialog: TFileOpenDialog;
    Chk_ServeurHorodatage: TCheckBox;
    Chk_SHA256: TCheckBox;
    Chk_Details: TCheckBox;

    procedure Nbt_SignerClick(Sender: TObject);
    procedure Nbt_SelectionnerFichierClick(Sender: TObject);
    procedure Nbt_CertificatClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditFichierChange(Sender: TObject);
    procedure EditRepertoireChange(Sender: TObject);
    procedure Nbt_SelectionnerRepertoireClick(Sender: TObject);

  private
    _sMotDePasse: String;

    function SignerFichier(const sFichier, sCertificat, sMotDePasse, sURLServeurHorodatage: String): Boolean;

  public
    { Déclarations publiques }
  end;

var
  MainForm: TMainForm;

implementation

uses UnitMotDePasseCertificat;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  FichierINI: TIniFile;
begin
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'SignerFichier.ini');
  try
    EditFichier.Text := FichierINI.ReadString('Paramètres', 'Fichier', '');
    EditRepertoire.Text := FichierINI.ReadString('Paramètres', 'Répertoire', '');
    EditCertificat.Text := FichierINI.ReadString('Paramètres', 'Certificat', '');
    Chk_ServeurHorodatage.Checked := (FichierINI.ReadInteger('Paramètres', 'Serveur horodatage', 1) = 1);
    EditServeurHorodatage.Text := FichierINI.ReadString('Paramètres', 'URL serveur horodatage', '');
    Chk_SHA256.Checked := (FichierINI.ReadInteger('Paramètres', 'SHA 256', 1) = 1);
    Chk_Details.Checked := (FichierINI.ReadInteger('Paramètres', 'Détails', 1) = 1);
  finally
    FichierINI.Free;
  end;

  ForceCurrentDirectory := True;
end;

procedure TMainForm.Nbt_SelectionnerFichierClick(Sender: TObject);
begin
  if(EditFichier.Text <> '') and (FileExists(EditFichier.Text)) then
    OpenDialogFichier.InitialDir := ExtractFilePath(EditFichier.Text);

  if OpenDialogFichier.Execute then
    EditFichier.Text := OpenDialogFichier.FileName;
end;

procedure TMainForm.Nbt_SelectionnerRepertoireClick(Sender: TObject);
var
  sRepertoire: String;
begin
  if Win32MajorVersion >= 6 then
  begin
    FileOpenDialog.FileName := EditRepertoire.Text;
    if FileOpenDialog.Execute then
      EditRepertoire.Text := FileOpenDialog.FileName;
  end
  else
  begin
    sRepertoire := EditRepertoire.Text;
    if SelectDirectory(' Sélectionner le répertoire', '', sRepertoire, [sdNewFolder, sdShowEdit, sdShowShares, sdValidateDir]) then
      EditRepertoire.Text := sRepertoire;
  end;
end;

procedure TMainForm.Nbt_CertificatClick(Sender: TObject);
begin
  if(EditCertificat.Text <> '') and (FileExists(EditCertificat.Text)) then
    OpenDialogCertificat.InitialDir := ExtractFilePath(EditCertificat.Text);

  if OpenDialogCertificat.Execute then
    EditCertificat.Text := OpenDialogCertificat.FileName;
end;

procedure TMainForm.Nbt_SignerClick(Sender: TObject);
var
  sr: TSearchRec;
begin
  Nbt_Signer.Enabled := False;
  EditFichier.Enabled := False;
  Nbt_SelectionnerFichier.Enabled := False;
  EditRepertoire.Enabled := False;
  Nbt_SelectionnerRepertoire.Enabled := False;
  EditCertificat.Enabled := False;
  Nbt_Certificat.Enabled := False;
  Chk_ServeurHorodatage.Enabled := False;
  EditServeurHorodatage.Enabled := False;
  Chk_SHA256.Enabled := False;
  Chk_Details.Enabled := False;
  try
    // Si pas de fichier.
    if(EditFichier.Text = '') and (EditRepertoire.Text = '') then
    begin
      Application.MessageBox('Attention :  il faut sélectionner un fichier !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
      EditFichier.SetFocus;
      Exit;
    end;

    // Si le fichier n'existe pas.
    if((EditFichier.Text <> '') and (not FileExists(EditFichier.Text))) then
    begin
      Application.MessageBox('Attention :  il le fichier n''existe pas !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
      EditFichier.SetFocus;
      Exit;
    end;

    // Si le répertoire n'existe pas.
    if(EditRepertoire.Text <> '') and (not DirectoryExists(EditRepertoire.Text)) then
    begin
      Application.MessageBox('Attention :  le répertoire n''existe pas !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
      EditRepertoire.SetFocus;
      Exit;
    end;

    // Si pas de certificat.
    if(EditCertificat.Text = '') or (not FileExists(EditCertificat.Text)) then
    begin
      Application.MessageBox('Attention :  il faut sélectionner un certificat !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
      EditCertificat.SetFocus;
      Exit;
    end;
    
    // Si pas de serveur d'horodatage.
    if EditServeurHorodatage.Text = '' then
    begin
      Application.MessageBox('Attention :  il faut saisir un serveur d''horodatage !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
      EditServeurHorodatage.SetFocus;
      Exit;
    end;

    // Si mot de passe pas saisi.
    if _sMotDePasse = '' then
    begin
      if FrmMotDePasseCertificat.ShowModal = mrOk then
        _sMotDePasse := FrmMotDePasseCertificat.EditMotDePasse.Text
      else
        Exit;
    end;

    // Si répertoire.
    if EditRepertoire.Text <> '' then
    begin
      if SysUtils.FindFirst(IncludeTrailingPathDelimiter(EditRepertoire.Text) + '*.exe', faAnyFile, sr) = 0 then
      begin
        repeat
          if((sr.Attr and faDirectory) <> faDirectory) and (sr.Name <> '.') and (sr.Name <> '..') then
          begin
            // Signature du fichier.
            SignerFichier(IncludeTrailingPathDelimiter(EditRepertoire.Text) + sr.Name, EditCertificat.Text, _sMotDePasse, EditServeurHorodatage.Text);
          end;
        until FindNext(sr) <> 0;
        FindClose(sr);
      end;
    end
    else
    begin
      // Signature du fichier.
      SignerFichier(EditFichier.Text, EditCertificat.Text, _sMotDePasse, EditServeurHorodatage.Text);
    end;
  finally
    EditFichier.Enabled := True;
    Nbt_SelectionnerFichier.Enabled := True;
    EditRepertoire.Enabled := True;
    Nbt_SelectionnerRepertoire.Enabled := True;
    EditCertificat.Enabled := True;
    Nbt_Certificat.Enabled := True;
    Chk_ServeurHorodatage.Enabled := True;
    EditServeurHorodatage.Enabled := True;
    Chk_SHA256.Enabled := True;
    Chk_Details.Enabled := True;
    Nbt_Signer.Enabled := True;
  end;
end;

function TMainForm.SignerFichier(const sFichier, sCertificat, sMotDePasse, sURLServeurHorodatage: String): Boolean;
{$REGION 'SignerFichier'}
  procedure EcritLog(const sCommande: String);
  var
    F: TextFile;
  begin
    AssignFile(F, ExtractFilePath(Application.ExeName) + 'SignerFichier.log');
    try
      Rewrite(F);
      Writeln(F, sCommande);
    finally
      CloseFile(F);
    end;
  end;
{$ENDREGION}
var
  sCommande, sErreur, sSortie: String;
begin
//  sCommande := 'sign /a /v /fd SHA256 /f "' + sCertificat + '" /p ' + sMotDePasse + ' /t "' + sURLServeurHorodatage + '" "' + sFichier + '"';
  sCommande := 'sign ' + IfThen(Chk_Details.Checked, '/v ') + IfThen(Chk_SHA256.Checked, '/fd SHA256 ') + '/f "' + sCertificat + '" /p ' + sMotDePasse + IfThen(Chk_ServeurHorodatage.Checked, ' /t "' + sURLServeurHorodatage + '"') + ' "' + sFichier + '"';
  EcritLog('"' + ExtractFilePath(Application.ExeName) + 'signtool.exe" ' + sCommande);
  if ExecAndWaitProcess(sErreur, sSortie, '"' + ExtractFilePath(Application.ExeName) + 'signtool.exe"', sCommande, False, ExtractFilePath(Application.ExeName)) <> 0 then
  begin
    Application.MessageBox(PChar('Erreur :  la signature du fichier [' + ExtractFileName(sFichier) + '] a échoué !' + #13#10 + sErreur), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
    Result := False;
  end
  else
  begin
    Application.MessageBox(PChar('La signature du fichier [' + ExtractFileName(sFichier) + '] a été réalisée avec succès :' + #13#10#13#10 + sSortie), PChar(Caption + ' - message'), MB_ICONINFORMATION + MB_OK);
    Result := True;
  end;
end;

procedure TMainForm.EditFichierChange(Sender: TObject);
begin
  EditRepertoire.OnChange := nil;
  EditRepertoire.Text := '';
  EditRepertoire.OnChange := EditRepertoireChange;
end;

procedure TMainForm.EditRepertoireChange(Sender: TObject);
begin
  EditFichier.OnChange := nil;
  EditFichier.Text := '';
  EditFichier.OnChange := EditFichierChange;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  FichierINI: TIniFile;
begin
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'SignerFichier.ini');
  try
    FichierINI.WriteString('Paramètres', 'Fichier', EditFichier.Text);
    FichierINI.WriteString('Paramètres', 'Répertoire', EditRepertoire.Text);
    FichierINI.WriteString('Paramètres', 'Certificat', EditCertificat.Text);
    FichierINI.WriteInteger('Paramètres', 'Serveur horodatage', IfThen(Chk_ServeurHorodatage.Checked, 1, 0));
    FichierINI.WriteString('Paramètres', 'URL serveur horodatage', EditServeurHorodatage.Text);
    FichierINI.WriteInteger('Paramètres', 'SHA 256', IfThen(Chk_SHA256.Checked, 1, 0));
    FichierINI.WriteInteger('Paramètres', 'Détails', IfThen(Chk_Details.Checked, 1, 0));
  finally
    FichierINI.Free;
  end;
end;

end.

