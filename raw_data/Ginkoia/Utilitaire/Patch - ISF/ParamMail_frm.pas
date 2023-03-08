unit ParamMail_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, classDossier, uThreadProc, GestionEMail;

type
  TFrm_ParamMail = class(TForm)
    Pan_Corps: TPanel;
    Btn_Annuler: TButton;
    Btn_Valider: TButton;
    Pan_ParamMail: TPanel;
    Lab_Exp: TLabel;
    Lab_Mdp: TLabel;
    Lab_Port: TLabel;
    Lab_SMTP: TLabel;
    Edit_Exp: TEdit;
    Edit_Mdp: TEdit;
    Edit_Port: TEdit;
    Edit_SMTP: TEdit;
    Rgr_Security: TRadioGroup;
    Btn_TestMail: TButton;
    Pan_TestMail: TPanel;
    Memo1: TMemo;
    Chk_log: TCheckBox;
    procedure Btn_AnnulerClick(Sender: TObject);
    procedure Btn_ValiderClick(Sender: TObject);
    procedure Btn_TestMailClick(Sender: TObject);
  private
    { Déclarations privées }
    sExpediteur : String;
    sMDP : String;
    sSMTP : String;
    sPort : String;
    sSecurite : String;
    sDestinataire : string;
    procedure testSendMail;
    procedure onLog(Sender: TObject; aMsg: string);
  public
    { Déclarations publiques }

  end;

var
  Frm_ParamMail: TFrm_ParamMail;


function ExecuteParamMail(var Options : TOptions) : Boolean ;

implementation

uses ExecuteScript_frm;

{$R *.dfm}

function ExecuteParamMail(var Options : TOptions) : Boolean ;
var
  ParamMail: TFrm_ParamMail;
begin
  Result := false ;
  try
    Application.createform(TFrm_ParamMail, ParamMail);
    ParamMail.Edit_SMTP.Text := Options.Ini_Opt_Mail_SMTP;
    ParamMail.Edit_Port.Text := inttostr(Options.Ini_Opt_Mail_Port);
    ParamMail.Edit_Exp.Text := Options.Ini_Opt_Mail_Exp;
    ParamMail.Edit_Mdp.Text := Options.Ini_Opt_Mail_Pwd;
    ParamMail.Rgr_Security.ItemIndex := Options.Ini_Opt_Mail_Security;
    ParamMail.Pan_ParamMail.Visible := true;
    ParamMail.Pan_TestMail.Visible := false;
    ParamMail.sDestinataire := Options.Ini_Opt_Mail;
    ParamMail.Chk_log.Checked := (Options.Ini_Opt_Mail_Log = 1);
    ParamMail.Pan_Corps.Color := clWebLightBlue;
    ParamMail.Pan_ParamMail.Color := clWebLightBlue;
    ParamMail.Pan_TestMail.Color := clWebLightBlue;
    if ParamMail.ShowModal = mrOk then
    begin
      Options.Ini_Opt_Mail_SMTP := ParamMail.Edit_SMTP.Text;
      Options.Ini_Opt_Mail_Port := StrToIntDef(ParamMail.Edit_Port.Text, 0);
      Options.Ini_Opt_Mail_Exp := ParamMail.Edit_Exp.Text;
      Options.Ini_Opt_Mail_Pwd := ParamMail.Edit_Mdp.Text;
      Options.Ini_Opt_Mail_Security := ParamMail.Rgr_Security.ItemIndex;
      if ParamMail.Chk_log.Checked then
        Options.Ini_Opt_Mail_Log := 1
      else
        Options.Ini_Opt_Mail_Log := 0;
      Result := true;

    end ;
  except
    Result := false ;
  end;
end;

procedure TFrm_ParamMail.Btn_AnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_ParamMail.Btn_TestMailClick(Sender: TObject);
var
  Msg : string;
begin
  Pan_ParamMail.Visible := false;
  Pan_TestMail.Visible := true;
  Btn_Valider.Enabled := false;
  Btn_Annuler.Enabled := false;
  try
    memo1.lines.clear;
    testSendMail;
  finally
    Pan_ParamMail.Visible := true;
    Pan_TestMail.Visible := false;
    Btn_Valider.Enabled := true;
    Btn_Annuler.Enabled := true;
  end;
end;

procedure TFrm_ParamMail.onLog(Sender: TObject; aMsg: string);
begin
  memo1.lines.add(aMsg);
end;

procedure TFrm_ParamMail.Btn_ValiderClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrm_ParamMail.testSendMail;
var
  sServeur, sLogin, sPwd, sExp, sTitre, sDest, sText : string;
  iPort: integer;
  Security : SecuriteMail;
  PJ, slDest : TStringList;
  email : TMailManager;
  Msg : string;
begin
  TThreadProc.RunInThread(
    procedure
    var
      i : integer;
    begin
      Msg := '';
      sServeur := Edit_SMTP.Text;
      iPort := strtointdef(Edit_Port.Text,25);
      sLogin := Edit_Exp.Text;
      sPwd  := Edit_Mdp.Text;
      Security := SecuriteMail(Rgr_Security.ItemIndex);
      sExp := Edit_Exp.Text;
      sDest := sDestinataire;
      sTitre := 'Test';
      sText := 'Test';
      memo1.lines.add('      - Serveur : ' + sServeur);
      memo1.lines.add('      - Port : ' + inttostr(iPort));
      memo1.lines.add('      - Login : ' + sLogin);
      memo1.lines.add('      - Pwd : ' + sPwd);
      memo1.lines.add('      - Expéditeur : ' + sExp);
      memo1.lines.add('      - Destinataire : ' + sDest);
      PJ := TStringList.Create;
      slDest := TStringList.create;
      slDest.Delimiter := ';';
      slDest.DelimitedText := sDest;
      for I := 0 to slDest.Count - 1 do
        memo1.lines.add('      - Destinataire[' + inttostr(i) + '] : ' + slDest[i]);
      try
        email := TMailManager.Create;
        try
          email.onLog := onLog;
          email.serveur := sServeur;
          email.port := iPort;
          email.Login := sLogin;
          email.Password := sPwd;
          email.Securite := Security;
          email.expediteur := sExp;
          email.destinataires := slDest;
          email.titre := sTitre;
          email.text := sText;
          email.PiecesJointes := pj;
          try
            memo1.lines.add('Test : Send Try');
            email.doSendEmail;
            memo1.lines.add('Test : Send ok');
            Msg := 'Test : ok';
          except
            On E:Exception do
            begin
              Msg := 'Test : Echec (' + e.Message + ')';
            end;
          end;
        finally
          email.free;
        end;
      finally
        PJ.free;
      end;
    end
  ).whenError(
    procedure(aException : Exception)
    begin
      Msg := 'Test : Echec (' + aException.Message + ')';
    end
  ).RunAndWait ;

  if Msg <> '' then
    showmessage(Msg)
  else
    showmessage('Problème !');
end;

end.
