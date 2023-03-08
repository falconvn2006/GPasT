unit Parametres_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Spin, ComCtrls, UThreadEnvoiCourriel;

type
  TFrm_Parametres = class(TForm)
    Pan_Boutons: TPanel;
    Nbt_Ok: TBitBtn;
    Nbt_Annuler: TBitBtn;
    Pan_Banniere: TPanel;
    Lab_Titre: TLabel;
    Lab_Chemin: TLabel;
    Txt_Chemin: TEdit;
    Lab_NbThreads: TLabel;
    Chp_NbThreads: TSpinEdit;
    Lab_PlageHoraire: TLabel;
    Dtp_HeureDebut: TDateTimePicker;
    Lab_HeureDebut: TLabel;
    Dtp_HeureFin: TDateTimePicker;
    Lab_HeureFin: TLabel;
    Nbt_Parcourir: TBitBtn;
    Lab_DossiersExclus: TLabel;
    Txt_DossiersExclus: TMemo;
    OD_Chemin: TOpenDialog;
    Lab_Utilisateur: TLabel;
    Txt_Utilisateur: TEdit;
    Lab_MotPasse: TLabel;
    Txt_MotPasse: TEdit;
    Gbx_Courriel: TGroupBox;
    Lab_ServeurSMTP: TLabel;
    Txt_ServeurSMTP: TEdit;
    Lab_UtilisateurSMTP: TLabel;
    Txt_UtilisateurSMTP: TEdit;
    Lab_MotPasseSMTP: TLabel;
    Txt_MotPasseSMTP: TEdit;
    Chk_TLSSMTP: TCheckBox;
    Lab_PortSMTP: TLabel;
    Chp_PortSMTP: TSpinEdit;
    Lab_AdresseExpediteurSMTP: TLabel;
    Lab_AdresseDestinataireSMTP: TLabel;
    Txt_AdresseExpediteurSMTP: TEdit;
    Txt_AdresseDestinataireSMTP: TEdit;
    Nbt_TestSMTP: TBitBtn;
    Chk_EnvoiSMTP: TCheckBox;
    procedure Nbt_ParcourirClick(Sender: TObject);
    procedure Nbt_TestSMTPClick(Sender: TObject);
    // Procédure exécuté à la fin de l'envoi du courriel
    procedure FinCourriel(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Parametres: TFrm_Parametres;

implementation

uses ResStr;

{$R *.dfm}

procedure TFrm_Parametres.Nbt_ParcourirClick(Sender: TObject);
begin
  OD_Chemin.FileName := Txt_Chemin.Text;
  OD_Chemin.InitialDir := ExtractFilePath(Txt_Chemin.Text);
  if OD_Chemin.Execute() then
    Txt_Chemin.Text := OD_Chemin.FileName;
end;

procedure TFrm_Parametres.Nbt_TestSMTPClick(Sender: TObject);
var
  ThsEnvoiCourriel: TThreadEnvoiCourriel;
begin
  {$REGION 'Exécution du thread d’envoi du courriel'}
  Nbt_TestSMTP.Enabled            := False;
  Nbt_TestSMTP.Caption            := 'Veuillez patienter'#133;

  ThsEnvoiCourriel                := TThreadEnvoiCourriel.Create(True);
  ThsEnvoiCourriel.Hote           := Txt_ServeurSMTP.Text;
  ThsEnvoiCourriel.Utilisateur    := Txt_UtilisateurSMTP.Text;
  ThsEnvoiCourriel.MotPasse       := Txt_MotPasseSMTP.Text;
  ThsEnvoiCourriel.Port           := Chp_PortSMTP.Value;
  ThsEnvoiCourriel.TLS            := Chk_TLSSMTP.Checked;
  ThsEnvoiCourriel.Expediteur     := Txt_AdresseExpediteurSMTP.Text;
  ThsEnvoiCourriel.Destinataires  := Txt_AdresseDestinataireSMTP.Text;
  ThsEnvoiCourriel.Objet          := Format(RS_COURRIEL_TEST_TITRE, [GetEnvironmentVariable('COMPUTERNAME')]);
  ThsEnvoiCourriel.Contenu        := Format(RS_COURRIEL_TEST_MESSAGE, [GetEnvironmentVariable('COMPUTERNAME')]);
  ThsEnvoiCourriel.OnTerminate    := FinCourriel;
  ThsEnvoiCourriel.Start();
  {$ENDREGION 'Exécution du thread d’envoi du courriel'}
end;

// Procédure exécuté à la fin de l'envoi du courriel
procedure TFrm_Parametres.FinCourriel(Sender: TObject);
begin
  // Confirme le bon envoye du courriel
  if not(TThreadEnvoiCourriel(Sender).Erreur) then
    MessageDlg(RS_INFO_COURRIEL_TEST, mtInformation, [mbOk], 0)
  else
    MessageDlg(Format(RS_ERR_COURRIEL_TEST, [TThreadEnvoiCourriel(Sender).MessageErreur]), mtError, [mbOk], 0);

  Nbt_TestSMTP.Enabled            := True;
  Nbt_TestSMTP.Caption            := 'Tester';
end;

end.
