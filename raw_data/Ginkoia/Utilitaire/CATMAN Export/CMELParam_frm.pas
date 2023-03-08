unit CMELParam_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, Spin, StdCtrls, ExtCtrls, ComCtrls, LMDCustomButton, LMDButton, uDefs;

type
  Tfrm_CMELParam = class(TForm)
    Pgc_Param: TPageControl;
    Tab_Mail: TTabSheet;
    Tab_FTP: TTabSheet;
    Pan_Bottom: TPanel;
    Lab_EmailExpediteur: TLabel;
    edt_MailExp: TEdit;
    Lab_SMTP: TLabel;
    Lab_SMTPPassword: TLabel;
    Lab_SMTPPort: TLabel;
    edt_SMTP: TEdit;
    Chp_Port: TSpinEdit;
    Chp_SMTPPW: TMaskEdit;
    Nbt_Valider: TLMDButton;
    Annuler: TLMDButton;
    Lab_User: TLabel;
    Lab_Password: TLabel;
    Lab_Host: TLabel;
    edt_FTPHost: TEdit;
    edt_FTPUSR: TEdit;
    Chp_FTPPW: TMaskEdit;
    Lab_Directory: TLabel;
    edt_FTPDIR: TEdit;
    Tab_CDE: TTabSheet;
    Lab_MontantMini: TLabel;
    edtMontantMini: TEdit;
    procedure Nbt_ValiderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtMontantMiniKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_CMELParam: Tfrm_CMELParam;

implementation

{$R *.dfm}

procedure Tfrm_CMELParam.edtMontantMiniKeyPress(Sender: TObject; var Key: Char);
begin
  if  not (Key in ['0'..'9']) then
    Key := #0;
end;

procedure Tfrm_CMELParam.FormCreate(Sender: TObject);
begin
  Pgc_Param.ActivePageIndex := 0;
  
  With MainCFG do
  begin
    With EMail do
    begin
      edt_MailExp.Text := ExpMail;
      Chp_SMTPPW.Text  := Password;
      edt_SMTP.Text    := AdrSMTP;
      Chp_Port.Value   := Port;
    end;

    With FTP do
    begin
      edt_FTPHost.Text := Host;
      edt_FTPUSR.Text  := UserName;
      Chp_FTPPW.Text   := Password;
      edt_FTPDIR.Text  := Dir;
    end;

    edtMontantMini.Text := FloatToStr(MntMiniCde);
  end;
end;

procedure Tfrm_CMELParam.Nbt_ValiderClick(Sender: TObject);
begin
  With MainCFG do
  begin
    With EMail do
    begin
      ExpMail  := edt_MailExp.Text;
      Password := Chp_SMTPPW.Text;
      AdrSMTP  := edt_SMTP.Text;
      Port     := Chp_Port.Value;
    end;

    With FTP do
    begin
      Host     := edt_FTPHost.Text;
      UserName := edt_FTPUSR.Text;
      Password := Chp_FTPPW.Text;
      Dir      := edt_FTPDIR.Text;
    end;
    MntMiniCde := StrToFloatDef(edtMontantMini.Text,500);
  end;

  ModalResult := mrOk;
end;

end.
