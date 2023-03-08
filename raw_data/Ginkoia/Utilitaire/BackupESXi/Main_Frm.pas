unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  //Uses Perso
  U_Common,
  UVersion,
  //Fin Uses Perso
  Dialogs, StdCtrls, Vcl.FileCtrl, Vcl.Buttons;

type
  TFrm_Main = class(TForm)
    Gbx_ServeurESXi: TGroupBox;
    Lab_IP_ESXi: TLabel;
    Lab_User_ESXi: TLabel;
    Lab_Password_ESXi: TLabel;
    Ed_IP_ESXi: TEdit;
    Ed_User_ESXi: TEdit;
    Ed_Password_ESXi: TEdit;
    Gbx_ListeVM: TGroupBox;
    Btn_Quitter: TButton;
    Btn_Save: TButton;
    Btn_Backup: TButton;
    Lbx_ListVM: TListBox;
    Lab_PathBck_ESXi: TLabel;
    Ed_PathBck_ESXi: TEdit;
    Gbx_BackupPath: TGroupBox;
    dlb_BackupPath: TDirectoryListBox;
    Btn_TestMail: TButton;
    DriveComboBox1: TDriveComboBox;
    Btn_Ajouter: TSpeedButton;
    Btn_Supprimer: TSpeedButton;
    procedure Btn_QuitterClick(Sender: TObject);
    procedure Btn_SaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_BackupClick(Sender: TObject);
    procedure Btn_TestMailClick(Sender: TObject);
    procedure Btn_AjouterClick(Sender: TObject);
    procedure Btn_SupprimerClick(Sender: TObject);
  private
    { Déclarations privées }
    MyBackup : TBackup;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

procedure TFrm_Main.Btn_AjouterClick(Sender: TObject);
var
  sTmp : string;
begin
  sTmp := InputBox('Ajout d''une VM', 'Veuillez saisir le nom de la VM :', '');
  Lbx_ListVM.Items.Add(sTmp);
end;

procedure TFrm_Main.Btn_BackupClick(Sender: TObject);
begin
  MyBackup.DoBackup;
end;

procedure TFrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Main.Btn_SaveClick(Sender: TObject);
begin
  MyBackup.SetESXi_IP(Ed_IP_ESXi.Text);
  MyBackup.SetESXI_User(Ed_User_ESXi.Text);
  MyBackup.SetESXi_Password(Ed_Password_ESXi.Text);
  MyBackup.SetESXi_PathBck(Ed_PathBck_ESXi.Text);
  MyBackup.SetLocal_PathBck(dlb_BackupPath.Directory);

  MyBackup.SaveIni(ChangeFileExt(Application.ExeName, '.ini'));

  Lbx_ListVM.Items.SaveToFile(ChangeFileExt(Application.ExeName, '.lst'));
end;

procedure TFrm_Main.Btn_SupprimerClick(Sender: TObject);
var
  i : Integer;
begin
  i := 0;
  while (i <= Lbx_ListVM.Count - 1)  do
  begin
    if Lbx_ListVM.Selected[i] then
      Lbx_ListVM.Items.Delete(i);
    Inc(i);
  end;
end;

procedure TFrm_Main.Btn_TestMailClick(Sender: TObject);
begin
  if MyBackup.SendEmail('Test Mail', 'Bonjour, il s''agit d''un test d''envoie d''Email.') then
    ShowMessage('Mail envoyé')
  else
    ShowMessage('Erreur à l''envoie');
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MyBackup.Free;
  Lbx_ListVM.Items.SaveToFile(ChangeFileExt(Application.ExeName, '.lst'));
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  MyBackup := TBackup.Create(Application.ExeName);

  MyBackup.LoadIni(ChangeFileExt(Application.ExeName, '.ini'));

  Ed_IP_ESXi.Text           := MyBackup.GetESXi_IP;
  Ed_User_ESXi.Text         := MyBackup.GetESXI_User;
  Ed_Password_ESXi.Text     := MyBackup.GetESXi_Password;
  Ed_PathBck_ESXi.Text      := MyBackup.GetESXi_PathBck;
  dlb_BackupPath.Directory  := MyBackup.GetLocal_PathBck;

  Lbx_ListVM.Items.Clear;
  Lbx_ListVM.Items.LoadFromFile(ChangeFileExt(Application.ExeName, '.lst'));

  if (ParamCount <> 0) And (ParamStr(1) = 'AUTO') then
  begin
    MyBackup.DoBackup;
    Application.Terminate;
  end;

  Caption := Caption +' - Version '+ GetNumVersionSoft;
end;

end.
