unit ParamLogiciel_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons, ExtCtrls, LMDIniCtrl;

type
  Tfrm_ParamLogiciel = class(TForm)
    Gbx_Chemin: TGroupBox;
    Gbx_FTP: TGroupBox;
    Pan_Bottom: TPanel;
    Nbt_Valider: TBitBtn;
    Nbt_Annuler: TBitBtn;
    Lab_Magasin: TLabel;
    Lab_Semaine: TLabel;
    edt_lstMag: TEdit;
    edt_lstSemaine: TEdit;
    Nbt_lstMag: TBitBtn;
    Nbt_lstSemaine: TBitBtn;
    Lab_host: TLabel;
    Lab_user: TLabel;
    Lab_pass: TLabel;
    Lab_port: TLabel;
    Lab_passive: TLabel;
    Chp_FTPPORT: TSpinEdit;
    Chk_FTPPassive: TCheckBox;
    edt_FTPHost: TEdit;
    edt_FTPUser: TEdit;
    edt_FTPPass: TEdit;
    OD_LstMag: TOpenDialog;
    OD_LstSemaine: TOpenDialog;
    Lab_FTPDir: TLabel;
    edt_FTPDir: TEdit;
    Lab_Comment: TLabel;
    procedure Nbt_lstMagClick(Sender: TObject);
    procedure Nbt_lstSemaineClick(Sender: TObject);
  private
    { Déclarations privées }
    FAINI : TLMDIniCtrl;
    FAPPPATH : String;
  public
    { Déclarations publiques }
    procedure LoadIni;
    procedure SaveIni;
  end;

var
  frm_ParamLogiciel: Tfrm_ParamLogiciel;

  procedure ExecuteParamLogiciel(AIni : TLMDIniCtrl);


implementation

{$R *.dfm}

procedure ExecuteParamLogiciel(AIni : TLMDIniCtrl);
begin
  With Tfrm_ParamLogiciel.Create(nil) do
  try
    FAINI := AIni;
    FAPPPATH := ExtractFilePath(Application.ExeName);
    LoadIni;
    if ShowModal = mrOk then
      SaveIni;
  finally
    Release;
  end;
end;


{ TForm1 }

procedure Tfrm_ParamLogiciel.LoadIni;
begin
  edt_lstMag.Text        := FAINI.ReadString('DIR','LSTMAG',FAPPPATH + 'magasin.csv');
  edt_lstSemaine.Text    := FAINI.ReadString('DIR','LSTSEMAINE',FAPPPATH + 'semaine.csv');

  edt_FTPHost.Text       := FAINI.ReadString('FTP', 'host', '');
  edt_FTPUser.Text       := FAINI.ReadString('FTP', 'user', '');
  edt_FTPPass.Text       := FAINI.ReadString('FTP', 'mp', '');
  Chp_FTPPORT.Value      := FAINI.ReadInteger('FTP','PORT',21);
  Chk_FTPPassive.Checked := FAINI.ReadBool('FTP','PASSIVE',True);
  edt_FTPDir.Text        := FAINI.ReadString('FTP','dest','');
end;

procedure Tfrm_ParamLogiciel.Nbt_lstMagClick(Sender: TObject);
begin
  if OD_LstMag.Execute then
    edt_lstMag.Text := OD_LstMag.FileName;
end;

procedure Tfrm_ParamLogiciel.Nbt_lstSemaineClick(Sender: TObject);
begin
  if OD_LstSemaine.Execute then
    edt_lstSemaine.Text := OD_LstSemaine.FileName;
end;

procedure Tfrm_ParamLogiciel.SaveIni;
begin
  FAINI.WriteString('DIR','LSTMAG',edt_lstMag.Text);
  FAINI.WriteString('DIR','LSTSEMAINE',edt_lstSemaine.Text);

  FAINI.WriteString('FTP', 'host', edt_FTPHost.Text);
  FAINI.WriteString('FTP', 'user', edt_FTPUser.Text);
  FAINI.WriteString('FTP', 'mp', edt_FTPPass.Text);
  FAINI.WriteInteger('FTP','PORT',Chp_FTPPORT.Value);
  FAINI.WriteBool('FTP','PASSIVE',Chk_FTPPassive.Checked);
  FAINI.WriteString('FTP','dest',edt_FTPDir.Text);
end;

end.
