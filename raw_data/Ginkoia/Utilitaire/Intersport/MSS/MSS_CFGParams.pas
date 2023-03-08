unit MSS_CFGParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvGlowButton, RzLabel, RzPanel, ExtCtrls, Spin, MSS_Type,
  ComCtrls, Buttons, TypInfo,

  // Cette unité doit toujours être mise à la fin
  MSS_ClassSurcharge;

type

  Tfrm_CFGParams = class(TForm)
    Pan_MainParam: TPanel;
    Pan_ParamBottom: TPanel;
    Pan_ParamTop: TPanel;
    Pan_ParamClient: TPanel;
    Pan_TopLeft: TPanel;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_Ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Gbx_FTP: TGroupBox;
    Lab_Host: TLabel;
    Lab_User: TLabel;
    Lab_Password: TLabel;
    Lab_Port: TLabel;
    edt_FTPHost: TEdit;
    edt_FTPUser: TEdit;
    edt_FTPPwd: TEdit;
    se_FTPPort: TSpinEdit;
    Pan_TopLeftFTPMode: TPanel;
    Rgr_FTPMode: TRadioGroup;
    Pan_DirFtp: TRzPanel;
    Gbx_DirFtp: TGroupBox;
    Lab_MasterDir: TLabel;
    edt_MasterVersion: TEdit;
    Lab_MDVersion: TLabel;
    Lab_MDData: TLabel;
    edt_MasterDatas: TEdit;
    Lab_Groupe: TLabel;
    Lab_GrpCommande: TLabel;
    Lab_GrpModifArt: TLabel;
    edt_GrpCommande: TEdit;
    edt_GrpModification: TEdit;
    Pan_Admin: TRzPanel;
    Gbx_Admin: TGroupBox;
    Lab_OldMdp: TLabel;
    Lab_NewMdp: TLabel;
    Lab_CfmMdp: TLabel;
    edt_OldMdp: TEdit;
    edt_NewMdp: TEdit;
    edt_CfmMdp: TEdit;
    OD_FileIB: TOpenDialog;
    Pan_Top: TPanel;
    Gbx_Base: TGroupBox;
    Lab_Base: TLabel;
    edt_Base: TEdit;
    Nbt_FileDir: TBitBtn;
    Gbx_Others: TGroupBox;
    Lab_IDMDC: TLabel;
    edt_IdMdc: TEdit;
    Lab_Timer: TLabel;
    Chp_TimMn: TSpinEdit;
    Lab_mn: TLabel;
    Lab_Reception: TLabel;
    edt_GrpReception: TEdit;
    Lab_SdUpdate: TLabel;
    Chp_SdUpdate: TSpinEdit;
    Chk_LogSdUpdate: TCheckBox;
    Chk_SdUpdateDes: TCheckBox;
    Pan_Left: TPanel;
    Pan_Right: TPanel;
    Gbx_ParamPeriode: TGroupBox;
    Lab_HDebut: TLabel;
    Lab_HFin: TLabel;
    dtp_hDebut: TDateTimePicker;
    dtp_hFin: TDateTimePicker;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Nbt_FileDirClick(Sender: TObject);
  private
    { Déclarations privées }
    function CheckData : Boolean;
  public
    { Déclarations publiques }
    function AutoValid : Boolean;
  end;

var
  frm_CFGParams: Tfrm_CFGParams;

implementation

{$R *.dfm}

uses MSS_DMDbMag;

function Tfrm_CFGParams.AutoValid: Boolean;
var
  bSave : Boolean;
  i : Integer;
begin
  bSave := False;

  for i := 0 to ComponentCount -1 do
  begin
    if Components[i].InheritsFrom(TEdit) then
    begin
      if not bSave   then
      begin
        bSave := TEdit(Components[i]).IsDifferent;
      end;
    end;

    if Components[i].InheritsFrom(TSpinEdit) then
      if not bSave   then
      begin
        bSave := TSpinEdit(Components[i]).IsDifferent;
      end;

    if Components[i].InheritsFrom(TRadioGroup) then
      if not bSave   then
      begin
        bSave := TRadioGroup(Components[i]).IsDifferent;
      end;
  end;

  if bSave then
    ShowMessage('Des données de paramétrage ont été changées, veuillez les valider');

  Result := bSave;
end;

function Tfrm_CFGParams.CheckData: Boolean;
var
  sOldMdp : String;

begin
  Result := False;
  // base de données
  if Trim(edt_Base.Text) = '' then
  begin
    Showmessage('Veuillez saisir un chemin vers la base de données de configuration');
    edt_Base.SetFocus;
    Exit;
  end;

  // Id MDC
  if Trim(edt_IdMdc.Text) = '' then
  begin
    Showmessage('Veuillez saisir un ID MDC');
    edt_IdMdc.SetFocus;
    Exit;
  end;

  // Vérification que l'ancien mdp Correspond
  if Trim(edt_OldMdp.Text) <> '' then
    With DM_DbMAG do
    begin
      sOldMdp := DoUnCryptPass(GetDbMagParam_Data(1));

      if Trim(sOldMdp) <> Trim(edt_OldMdp.Text) then
      begin
        edt_OldMdp.SetFocus;
        ShowMessage('Ancien mot de passe incorrect');
        Exit;
      end;

      if Trim(edt_NewMdp.Text) = '' then
      begin
        edt_NewMdp.SetFocus;
        ShowMessage('Veuillez saisir un nouveau mot de passe');
        Exit;
      end;

      if Trim(edt_CfmMdp.Text) = '' then
      begin
        edt_CfmMdp.SetFocus;
        ShowMessage('Veuillez saisir la confirmation du nouveau mot de passe');
        Exit;
      end;

      if Trim(edt_NewMdp.Text) <> Trim(edt_CfmMdp.Text) then
      begin
        edt_NewMdp.SetFocus;
        ShowMessage('Confirmation du nouveau mot de passe incorrecte');
        Exit;
      end;
    end; // with
  Result := True;
end;

procedure Tfrm_CFGParams.FormShow(Sender: TObject);
begin
  With IniStruct do
  begin
    edt_Base.OldValue    := Database;
    edt_IdMdc.OldValue   := IDMDC;
    Chp_TimMn.OldValue   := Time;

    edt_FTPHost.OldValue := FTP.MasterDataFTP.Host;
    edt_FTPUser.OldValue := FTP.MasterDataFTP.UserName;
    edt_FTPPwd.OldValue  := FTP.MasterDataFTP.Password;
    se_FTPPort.OldValue  := FTP.MasterDataFTP.Port;

    edt_MasterVersion.OldValue   := FTP.MasterDataFTP.MasterDataVersion;
    edt_MasterDatas.OldValue     := FTP.MasterDataFTP.MasterDataDatas;
    edt_GrpCommande.OldValue     := FTP.MasterDataFTP.GroupDirCommande;
    edt_GrpModification.OldValue := FTP.MasterDataFTP.GroupDirModif;
    edt_GrpReception.OldValue    := FTP.MasterDataFTP.GroupDirRecept;

    Rgr_FTPMode.ItemIndex := 0;
    if RenameFtpFile then
      Rgr_FTPMode.ItemIndex := 1
    else
      if DeleteFtpfile then
        Rgr_FTPMode.ItemIndex := 2;

    Chp_SdUpdate.Value := SdUpdatePeriode;
    Chk_LogSdUpdate.Checked := LogSdUpdate;
    Chk_SdUpdateDes.Checked := not SdUpdateActif;

    dtp_hDebut.Time := Periode.HDebut;
    dtp_hFin.Time := Periode.HFin;

  end;
end;

procedure Tfrm_CFGParams.Nbt_CancelClick(Sender: TObject);
begin
  if Parent is TTabsheet then
    TTabSheet(Parent).tabVisible := False;
  if Parent = nil then
    ModalResult := mrCancel;

  bEnTraitement := False;
end;

procedure Tfrm_CFGParams.Nbt_PostClick(Sender: TObject);
begin
  if CheckData then
  begin
    // Sauvegarde des données FTP
    With IniStruct do
    begin
      Database                   := edt_Base.Text;

      FTP.MasterDataFTP.Host     := edt_FTPHost.Text;
      FTP.MasterDataFTP.UserName := edt_FTPUser.Text;
      FTP.MasterDataFTP.Password := edt_FTPPwd.Text;
      FTP.MasterDataFTP.Port     := se_FTPPort.Value;

      FTP.MasterDataFTP.MasterDataVersion := edt_MasterVersion.Text;
      FTP.MasterDataFTP.MasterDataDatas   := edt_MasterDatas.Text;
      FTP.MasterDataFTP.GroupDirCommande  := edt_GrpCommande.Text;
      FTP.MasterDataFTP.GroupDirModif     := edt_GrpModification.Text;
      FTP.MasterDataFTP.GroupDirRecept    := edt_GrpReception.Text;

      RenameFtpFile := (Rgr_FTPMode.ItemIndex = 1);
      DeleteFtpfile := (Rgr_FTPMode.ItemIndex = 2);

      IDMDC         := edt_IdMdc.Text;
      Time          := Chp_TimMn.Value;

      SdUpdatePeriode := Chp_SdUpdate.Value;
      LogSdUpdate     := Chk_LogSdUpdate.Checked;
      SdUpdateActif   := not Chk_SdUpdateDes.Checked;
      Periode.HDebut  := dtp_hDebut.Time;
      Periode.HFin    := dtp_hFin.Time;
    end;
    IniStruct.SaveIni;

    // Pour réinitialiser l'affichage et les données. Car la fenêtre n'est pas détruite après.
    FormShow(Self);

    // Sauvegarde du mot de passe d'administration
    if Trim(edt_OldMdp.Text) <> '' then
    begin
      With DM_DbMAG do
        SetDbMagParam_Data(1,DoCryptPass(edt_NewMdp.Text));
    end;

    edt_OldMdp.Text := '';
    edt_NewMdp.Text := '';
    edt_CfmMdp.Text := '';
    if Parent is TTabSheet then
      TTabSheet(Parent).tabVisible := False;
    if Parent = nil then
      ModalResult := mrOk;

    bEnTraitement := False;
  end;
end;

procedure Tfrm_CFGParams.Nbt_FileDirClick(Sender: TObject);
begin
  if OD_FileIB.Execute then
    edt_Base.Text := OD_FileIB.FileName;
end;

end.
