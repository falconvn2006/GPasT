unit GSDataCFG_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, ExtCtrls, StdCtrls, Buttons,
  GSData_Types, ComCtrls, DateUtils;

type
  Tfrm_GSDataCfg = class(TForm)
    Pan_BtnBottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    Pan_Top: TPanel;
    Pan_client: TPanel;
    Gbx_Base: TGroupBox;
    Lab_Base: TLabel;
    edt_Base: TEdit;
    Nbt_Base: TBitBtn;
    OD_BasePath: TOpenDialog;
    Pgc_Cfg: TPageControl;
    Tab_Pg1: TTabSheet;
    GridPanel1: TGridPanel;
    Tab_Pg2: TTabSheet;
    GridPanel2: TGridPanel;
    Gbx_Archivage: TGroupBox;
    Chk_ArchActif: TCheckBox;
    Rgr_ArchDay: TRadioGroup;
    Chp_ArchNbDays: TSpinEdit;
    Lab_ArchNbDays: TLabel;
    Pgc_ConfigFTP: TPageControl;
    Tab_FTP: TTabSheet;
    Tab_SFTP: TTabSheet;
    GridPanel4: TGridPanel;
    Gbx_1: TGroupBox;
    lab_MailHost: TLabel;
    Lab_MailUser: TLabel;
    Lab_MailPwd: TLabel;
    Lab_MailPort: TLabel;
    edt_MailHost: TEdit;
    edt_MailUser: TEdit;
    edt_MailPwd: TEdit;
    Chp_MailPort: TSpinEdit;
    Chk_MailSSL: TCheckBox;
    Gbx_Others: TGroupBox;
    Lab_IDGS: TLabel;
    Lab_Timer: TLabel;
    Lab_Minutes: TLabel;
    Lab_LstMail: TLabel;
    edt_IDGS: TEdit;
    Chp_Timer: TSpinEdit;
    mmMail: TMemo;
    GridPanel3: TGridPanel;
    Chk_FTPActif: TCheckBox;
    Gbx_FTP: TGroupBox;
    Lab_FTPHost: TLabel;
    Lab_FTPUser: TLabel;
    Lab_FTPPwd: TLabel;
    Lab_FTPPort: TLabel;
    edt_FTPHost: TEdit;
    edt_FTPUser: TEdit;
    edt_FTPPwd: TEdit;
    Chp_FTPPort: TSpinEdit;
    Chk_FTPPassif: TCheckBox;
    Chk_FTPSSL: TCheckBox;
    Gbx_FTPDir: TGroupBox;
    Lab_FTPMain: TLabel;
    Lab_FTPDirCourrir: TLabel;
    Lab_FTPDirGOSport: TLabel;
    Envoi: TLabel;
    Lab_FTPDirRecep: TLabel;
    Lab_Test: TLabel;
    edt_FTPDirMain: TEdit;
    edt_FTPDIRCourrir: TEdit;
    edt_FTPDirGOSPORT: TEdit;
    edt_FTPDirEnvoi: TEdit;
    edt_FTPDirRecep: TEdit;
    Chk_TestMode: TCheckBox;
    edt_FTPDirTest: TEdit;
    Chk_SFTPActif: TCheckBox;
    Gbx_SFTP: TGroupBox;
    Lab_SFTPHost: TLabel;
    Lab_SFTPUser: TLabel;
    Lab_SFTPPwd: TLabel;
    Lab_SFTPPort: TLabel;
    edt_SFTPHost: TEdit;
    edt_SFTPUser: TEdit;
    edt_SFTPPwd: TEdit;
    Chp_SFTPPort: TSpinEdit;
    Gbx_SFTPDir: TGroupBox;
    Lab_SFTPMain: TLabel;
    Lab_SFTPDirCourrir: TLabel;
    Lab_SFTPDirGOSport: TLabel;
    Lab_SFTPDIREnvoi: TLabel;
    Lab_SFTPDirRecep: TLabel;
    Lab_SFTPTest: TLabel;
    edt_SFTPDirMain: TEdit;
    edt_SFTPDIRCourrir: TEdit;
    edt_SFTPDirGOSPORT: TEdit;
    edt_SFTPDirEnvoi: TEdit;
    edt_SFTPDirRecep: TEdit;
    Chk_SFTPTestMode: TCheckBox;
    edt_SFTPDirTest: TEdit;
    Chk_FTPDelFileFrom: TCheckBox;
    Chk_sFTPDeleteFrom: TCheckBox;
    Lab_SFTPReferentiel: TLabel;
    edt_SFTPReferentiel: TEdit;
    Lab_FTPReferentiel: TLabel;
    edt_FTPReferentiel: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_BaseClick(Sender: TObject);
  private
    { Déclarations privées }
    function CheckData : Boolean;

  public
    { Déclarations publiques }
  end;

var
  frm_GSDataCfg: Tfrm_GSDataCfg;

implementation

uses Math;

{$R *.dfm}

function Tfrm_GSDataCfg.CheckData: Boolean;
begin
  Result := False;
  if Trim(edt_Base.Text) = '' then
  begin
    ShowMessage('Veuillez sélectionner la base de configuration');
    Exit;
  end;

  // Il faut 'au moins' le FTP ou le SFTP d'actif
  if not ( Chk_FTPActif.Checked or Chk_SFTPActif.Checked ) then
  begin
    ShowMessage('Veuillez au moins activer le FTP ou le SFTP');
    Exit;
  end;

  {$REGION 'Vérification des champs FTP si actif'}
  if Chk_FTPActif.Checked then
  begin

    // FTP
    if Trim(edt_FTPHost.Text) = '' then
    begin
      ShowMessage('Veuillez saisir un host pour le FTP');
      Exit;
    end;

    if trim(edt_FTPUser.Text) = '' then
    begin
      ShowMessage('Veuillez saisir un user pour le FTP');
      Exit;
    end;

    if trim(edt_FTPPwd.Text) = '' then
    begin
      ShowMessage('Veuillez saisir un password pour le FTP');
      Exit;
    end;

    // chemin FTP
    if trim(edt_FTPDirMain.Text) ='' then
    begin
      ShowMessage('Veuillez saisir le Dossier principal du FTP');
      Exit;
    end;

    if trim(edt_FTPDIRCourrir.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données COURIR');
      Exit;
    end;

    if trim(edt_FTPDirGOSPORT.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données GOSPORT');
      Exit;
    end;

    if trim(edt_FTPDirEnvoi.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données d''envoi');
      Exit;
    end;

    if trim(edt_FTPDirRecep.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données de reception');
      Exit;
    end;

    if trim(edt_FTPReferentiel.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données de référentiel');
      Exit;
    end;
  end;
  {$ENDREGION}

  {$REGION 'Vérification des champs SFTP si actif'}
  if Chk_SFTPActif.Checked then
  begin

    // SFTP
    if Trim(edt_SFTPHost.Text) = '' then
    begin
      ShowMessage('Veuillez saisir un host pour le SFTP');
      Exit;
    end;

    if trim(edt_SFTPUser.Text) = '' then
    begin
      ShowMessage('Veuillez saisir un user pour le SFTP');
      Exit;
    end;

    if trim(edt_SFTPPwd.Text) = '' then
    begin
      ShowMessage('Veuillez saisir un password pour le SFTP');
      Exit;
    end;

    // chemin FTP
    if trim(edt_SFTPDirMain.Text) ='' then
    begin
      ShowMessage('Veuillez saisir le Dossier principal du SFTP');
      Exit;
    end;

    if trim(edt_SFTPDIRCourrir.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données COURIR');
      Exit;
    end;

    if trim(edt_SFTPDirGOSPORT.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données GOSPORT');
      Exit;
    end;

    if trim(edt_SFTPDirEnvoi.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données d''envoi');
      Exit;
    end;

    if trim(edt_SFTPDirRecep.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données de reception');
      Exit;
    end;

    if trim(edt_SFTPReferentiel.Text) = '' then
    begin
      ShowMessage('Veuillez saisir le dossier des données de référentiel');
      Exit;
    end;
  end;
  {$ENDREGION}

  // Mail
  if Trim(edt_MailHost.Text) = '' then
  begin
    ShowMessage('Veuillez saisir un host pour le mail');
    Exit;
  end;

//  if trim(edt_MailUser.Text) = '' then
//  begin
//    ShowMessage('Veuillez saisir un user pour le mail');
//    Exit;
//  end;
//
//  if trim(edt_MailPwd.Text) = '' then
//  begin
//    ShowMessage('Veuillez saisir un password pour le mail');
//    Exit;
//  end;

  // 2016-07-12 : Prise en compte de l'absence de login/password pour FL.
  if (Trim(edt_MailUser.Text) = '')
  or (Trim(edt_MailPwd.Text) = '') then
  begin
    if MessageDlg('Vous n''avez pas complétement saisi le compte mail (username+password), voulez-vous poursuivre quand même ?', mtConfirmation, [mbYes,MbNo], 0) = mrNo then
      Exit;
  end;

  // Others
  if trim(edt_IDGS.Text) = '' then
  begin
    ShowMessage('Veuillez saisir un identifiant GSData');
    Exit;
  end;

  if Trim(mmMail.Text) = '' then
  begin
    if MessageDlg('Vous n''avez pas saisi d''adresse mail, voulez vous poursuivre quand même ?',mtConfirmation,[mbYes,MbNo],0) = mrNo then
      Exit;
  end;

  Result := True;
end;

procedure Tfrm_GSDataCfg.FormCreate(Sender: TObject);
begin
  Pgc_Cfg.ActivePageIndex := 0;

  IniStruct.LoadIni;

  With IniStruct do
  begin
    // base
    edt_Base.Text := BasePath;
    {$REGION 'Chargement de la config FTP (GsData.ini)'}
    // FTP
    Chk_FTPActif.Checked    := FTP.Actif;
    edt_FTPHost.Text        := FTP.Host;
    edt_FTPUser.Text        := FTP.UserName;
    edt_FTPPwd.Text         := FTP.PassWord;
    Chp_FTPPort.Value       := FTP.Port;
    Chk_FTPPassif.Checked   := FTP.Passif;
    Chk_FTPSSL.Checked      := FTP.SSL;

    // FTPDir
    edt_FTPDirMain.Text     := FTPDir.Principal;
    edt_FTPDirTest.Text     := FTPDir.Test;
    edt_FTPDIRCourrir.Text  := FTPDir.Courir;
    edt_FTPDirGOSPORT.Text  := FTPDir.GoSport;
    edt_FTPDirEnvoi.Text    := FTPDir.Envoi;
    edt_FTPDirRecep.Text    := FTPDir.reception;
    edt_FTPReferentiel.Text := FTPDir.Referentiel;
    Chk_TestMode.Checked    := (FTPDir.Mode = 1);
    Chk_FTPDelFileFrom.Checked := FTPDir.DeleteFileFromFTP;
    {$ENDREGION}

    {$REGION 'Chargement de la config SFTP (GsData.ini)'}
    // SFTP
    Chk_SFTPActif.Checked    := SFTP.Actif;
    edt_SFTPHost.Text        := SFTP.Host;
    edt_SFTPUser.Text        := SFTP.UserName;
    edt_SFTPPwd.Text         := SFTP.PassWord;
    Chp_SFTPPort.Value       := SFTP.Port;

    // SFTPDir
    edt_SFTPDirMain.Text     := SFTPDir.Principal;
    edt_SFTPDirTest.Text     := SFTPDir.Test;
    edt_SFTPDIRCourrir.Text  := SFTPDir.Courir;
    edt_SFTPDirGOSPORT.Text  := SFTPDir.GoSport;
    edt_SFTPDirEnvoi.Text    := SFTPDir.Envoi;
    edt_SFTPDirRecep.Text    := SFTPDir.reception;
    edt_SFTPReferentiel.Text := SFTPDir.Referentiel;
    Chk_SFTPTestMode.Checked := SFTPDir.Mode = 1;
    Chk_sFTPDeleteFrom.Checked := SFTPDir.DeleteFileFromFTP;
    {$ENDREGION}

    // Mail
    edt_MailHost.Text := Mail.Host;
    edt_MailUser.Text := Mail.UserName;
    edt_MailPwd.Text := Mail.Password;
    Chp_MailPort.Value := Mail.Port;
    Chk_MailSSL.Checked := Mail.SSL;

    // Others
    edt_IDGS.Text := Others.IdGsData;
    Chp_Timer.Value := Others.Timer;
    mmMail.Text := Others.MailList.Text;

    Chk_ArchActif.Checked := Archivage.Actif;
    Rgr_ArchDay.ItemIndex := Archivage.NumJour - 1; // -1 car les constantes de jours vont de 1 à 7
    Chp_ArchNbDays.Value  := Archivage.NbJours;
  end;
end;

procedure Tfrm_GSDataCfg.Nbt_BaseClick(Sender: TObject);
begin
  if OD_BasePath.Execute then
    edt_Base.Text := OD_BasePath.FileName;
end;

procedure Tfrm_GSDataCfg.Nbt_CancelClick(Sender: TObject);
begin
  IniStruct.LoadIni;
end;

procedure Tfrm_GSDataCfg.Nbt_PostClick(Sender: TObject);
begin
  if CheckData then
  begin
   With IniStruct do
    begin
      // base
      BasePath := edt_Base.Text;

      {$REGION 'Affectation des structures FTP'}
      // FTP
      FTP.Actif         := Chk_FTPActif.Checked;
      FTP.Host          := edt_FTPHost.Text;
      FTP.UserName      := edt_FTPUser.Text;
      FTP.PassWord      := edt_FTPPwd.Text;
      FTP.Port          := Chp_FTPPort.Value;
      FTP.Passif        := Chk_FTPPassif.Checked;
      FTP.SSL           := Chk_FTPSSL.Checked;

      // FTPDir
      FTPDir.Principal  := edt_FTPDirMain.Text;
      FTPDir.Test       := edt_FTPDirTest.Text;
      FTPDir.Courir     := edt_FTPDIRCourrir.Text;
      FTPDir.GoSport    := edt_FTPDirGOSPORT.Text;
      FTPDir.Envoi      := edt_FTPDirEnvoi.Text;
      FTPDir.reception  := edt_FTPDirRecep.Text;
      FTPDir.Referentiel := edt_FTPReferentiel.Text;
      FTPDir.DeleteFileFromFTP := Chk_FTPDelFileFrom.Checked;
      if Chk_TestMode.Checked then
        FTPDir.Mode := 1
      else
        FTPDir.Mode := 0;
      {$ENDREGION}

      {$REGION 'Affectation des structures SFTP'}
      // SFTP
      SFTP.Actif        := Chk_SFTPActif.Checked;
      SFTP.Host         := edt_SFTPHost.Text;
      SFTP.Username     := edt_SFTPUser.Text;
      SFTP.Password     := edt_SFTPPwd.Text;
      SFTP.Port         := Chp_SFTPPort.Value;
      // SFTPDir
      SFTPDir.Principal := edt_SFTPDirMain.Text;
      SFTPDir.Test      := edt_SFTPDirTest.Text;
      SFTPDir.Courir    := edt_SFTPDIRCourrir.Text;
      SFTPDir.GoSport   := edt_SFTPDirGOSPORT.Text;
      SFTPDir.Envoi     := edt_SFTPDirEnvoi.Text;
      SFTPDir.reception := edt_SFTPDirRecep.Text;
      SFTPDir.Referentiel := edt_SFTPReferentiel.Text;
      SFTPDir.Mode      := IfThen( Chk_SFTPTestMode.Checked, 1, 0 );
      SFTPDir.DeleteFileFromFTP := Chk_sFTPDeleteFrom.Checked;
      {$ENDREGION}

      // Mail
      Mail.Host := edt_MailHost.Text;
      Mail.UserName := edt_MailUser.Text;
      Mail.Password := edt_MailPwd.Text;
      Mail.Port := Chp_MailPort.Value;
      Mail.SSL := Chk_MailSSL.Checked;

      // Others
      Others.IdGsData := edt_IDGS.Text;
      Others.Timer := Chp_Timer.Value;
      Others.MailList.Text := mmMail.Text;

      Archivage.Actif :=  Chk_ArchActif.Checked;
      Archivage.NumJour := Rgr_ArchDay.ItemIndex + 1; // +1 car les constantes de jours vont de 1 à 7
      Archivage.NbJours := Chp_ArchNbDays.Value;

      // calcul du prochain déclenchement de l'archivage
      Archivage.NextArch := Now;
      while DayOfTheWeek(Archivage.NextArch) <> Archivage.NumJour do
        Archivage.NextArch := IncDay(Archivage.NextArch,1);

    end;

    IniStruct.SaveIni;

    ModalResult := mrOk;
  end;
end;

end.
