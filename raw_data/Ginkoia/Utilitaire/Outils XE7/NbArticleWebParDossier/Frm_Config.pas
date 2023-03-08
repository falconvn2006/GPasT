unit Frm_Config;

interface

uses
  System.SysUtils, System.StrUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Layouts, FMX.Memo,
  FMX.ListBox, IdExplicitTLSClientServerBase, IdSSLOpenSSL, System.TypInfo,
  FMX.ScrollBox, FMX.Controls.Presentation;

type
  TConfig_Frm = class(TForm)
    gb_Email: TGroupBox;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    lo_Boutons: TLayout;
    cb_Email: TCheckBox;
    gb_Config: TGroupBox;
    lo_Email: TLayout;
    lo_Config: TLayout;
    edt_Base: TEdit;
    lbl_Base: TLabel;
    lbl_Log: TLabel;
    edt_Log: TEdit;
    lbl_Csv: TLabel;
    edt_Csv: TEdit;
    ebBase: TEditButton;
    eb_Log: TEditButton;
    eb_Csv: TEditButton;
    memo_email: TMemo;
    Label1: TLabel;
    gb_Smtp: TGroupBox;
    edt_SmtpFromAdr: TEdit;
    lbl_smtpFromAdr: TLabel;
    edt_SmtpHost: TEdit;
    lbl_SmtpPort: TLabel;
    edt_SmtpPort: TEdit;
    lbl_SmtpHost: TLabel;
    edt_SmtpUser: TEdit;
    lbl_SmtpUser: TLabel;
    edt_SmtpPwd: TEdit;
    lbl_SmtpPwd: TLabel;
    cb_SmtpUseTls: TComboBox;
    lbl_SmtpUseTls: TLabel;
    cb_SmtpSSLVersion: TComboBox;
    lbl_SmtpSSLVersion: TLabel;
    lblMonitoring: TLabel;
    edt_Monitoring: TEdit;
    btn_TestEmail: TButton;
    procedure ebBaseClick(Sender: TObject);
    procedure eb_LogClick(Sender: TObject);
    procedure eb_CsvClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edt_MonitoringKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btn_TestEmailClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    procedure SetBtnEmail(aEnabled: boolean);
  end;

var
  Config_Frm: TConfig_Frm;

implementation

uses Frm_Main;

{$R *.fmx}

procedure TConfig_Frm.btn_TestEmailClick(Sender: TObject);
begin
  SetBtnEmail(false);
  Main_Frm.TestEmail;
end;

procedure TConfig_Frm.ebBaseClick(Sender: TObject);
var
  lDialog: TOpenDialog;
begin
  lDialog := TOpenDialog.Create(nil);
  lDialog.Filter := ' (*.ib)|*.ib';
  if lDialog.Execute then
  begin
    edt_Base.Text := lDialog.FileName;
  end;
  lDialog.Free;
end;

procedure TConfig_Frm.eb_CsvClick(Sender: TObject);
var
  lPath : string;
begin
  if SelectDirectory('Choisissez le dossier de stockage des CSV',ExtractFilePath(ParamStr(0)),lPath) then
    edt_Csv.Text := lPath;
end;

procedure TConfig_Frm.eb_LogClick(Sender: TObject);
var
  lPath : string;
begin
  if SelectDirectory('Choisissez le dossier de stockage des Logs',ExtractFilePath(ParamStr(0)),lPath) then
    edt_Log.Text := lPath;
end;

procedure TConfig_Frm.edt_MonitoringKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  lText: string;
begin
  if not(KeyChar in ['0' .. '9']) then
  begin
    KeyChar := #0;
  end
  else if (Sender as TEdit).SelLength > 0 then
  begin
    try
      lText := Copy((Sender as TEdit).Text,0,(Sender as TEdit).SelStart);
      lText := lText + KeyChar;
      lText := lText + Copy((Sender as TEdit).Text,(Sender as TEdit).SelStart + (Sender as TEdit).SelLength +1,(Sender as TEdit).Text.Length - ((Sender as TEdit).SelStart + (Sender as TEdit).SelLength));
      StrToInt(lText);
    except
      KeyChar := #0;
    end;
  end
  else
  begin
    try
      StrToInt((Sender as TEdit).Text + KeyChar);
    except
      KeyChar := #0;
    end;
  end;
end;

procedure TConfig_Frm.FormCreate(Sender: TObject);
var
  iUseTLS: TIdUseTLS;
  iSSLVersion: TIdSSLVersion;
begin
   for iUseTLS := Low(TIdUseTLS) to High(TIdUseTLS) do
      cb_SmtpUseTls.Items.add(GetEnumName(TypeInfo(TIdUseTLS), ord(iUseTLS)));
   for iSSLVersion := Low(TIdSSLVersion) to High(TIdSSLVersion) do
      cb_SmtpSSLVersion.Items.add(GetEnumName(TypeInfo(TIdSSLVersion), ord(iSSLVersion)));
end;

procedure TConfig_Frm.SetBtnEmail(aEnabled: boolean);
begin
  btn_TestEmail.Enabled := aEnabled;
end;

end.
