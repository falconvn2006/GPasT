unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, Spin;

type
  TFrm_Main = class(TForm)
    Btn_Quitter: TButton;
    Lab_CheminGinkoia: TLabel;
    Lab_CodeClt: TLabel;
    Ed_CodeClt: TEdit;
    Lab_NbCaisse: TLabel;
    Chp_NbCaisse: TSpinEdit;
    Gbx_Caisse: TGroupBox;
    Lab_RepertoireGinkoia: TLabel;
    Chk_LogAllTicket: TCheckBox;
    Chk_LogTPE: TCheckBox;
    Cbx_Caisse: TComboBox;
    Btn_Refresh: TButton;
    Chk_System: TCheckBox;
    Btn_GetLog: TButton;

    procedure FormCreate(Sender: TObject);

    procedure PosteChange(Sender: TObject);

    procedure Refresh(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
    procedure Chk_LogAllTicketClick(Sender: TObject);
    procedure Chk_LogTPEClick(Sender: TObject);
    procedure Btn_GetLogClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    CaisseIni : TIniFile;
    TPEIni : TIniFile;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  uSevenZip;

{$R *.dfm}

const
  FICHIER_INI_CAISSE = 'CaisseGinkoia.ini';
  SECTION_CAISSE = 'LOG';
  IDENT_CAISSE = 'LOGALLTICKET';

  FICHIER_INI_TPE = 'TPESERV.ini';
  SECTION_TPE = 'TPE';
  IDENT_TPE = 'OKTRACE';

const
  REPERTOIRE_LOG_BDC = 'BDC';
  REPERTOIRE_LOG_TPE = 'LOG_TPE';
  REPERTOIRE_LOG_CAISSE = 'LOG_CaisseGinkoia';
  REPERTOIRE_LOG_GINKOIA = 'LOG_Ginkoia';


procedure TFrm_Main.FormCreate(Sender: TObject);
var
  ZipDll : TResourceStream;
begin
  Refresh(nil);

  if not FileExists(ExtractFilePath(ParamStr(0)) + '7z.dll') then
  begin
    ZipDll := TResourceStream.Create(HInstance, 'ZipDll', RT_RCDATA);
    try
      ZipDll.SaveToFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
    finally
      FreeAndNil(ZipDll);
    end;
  end;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  if FileExists(ExtractFilePath(ParamStr(0)) + '7z.dll') then
    DeleteFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
end;

procedure TFrm_Main.PosteChange(Sender: TObject);
var
  i : integer;
begin
  Cbx_Caisse.Items.Clear();
  Cbx_Caisse.Items.Add('Localhost');
  for i := 1 to Chp_NbCaisse.Value do
    Cbx_Caisse.Items.Add('NC' + Ed_CodeClt.Text + '-' + IntToStr(i));
  Cbx_Caisse.ItemIndex := 0;
end;

procedure TFrm_Main.Refresh(Sender: TObject);
var
  Disk : Char;
begin
  Lab_CheminGinkoia.Caption := '';
  if Cbx_Caisse.ItemIndex = 0 then
  begin
    for Disk in ['C', 'D'] do
    begin
      if FileExists(Disk + ':\Ginkoia\' + FICHIER_INI_CAISSE ) then
      begin
        Lab_CheminGinkoia.Caption := Disk + ':\Ginkoia\';
        Break;
      end;
    end;
  end
  else
  begin
    if Chk_System.Checked then
    begin
      for Disk in ['C', 'D'] do
      begin
        if FileExists('\\' + Cbx_Caisse.Items[Cbx_Caisse.ItemIndex] + '\' + Disk + '$\Ginkoia\' + FICHIER_INI_CAISSE ) then
        begin
          Lab_CheminGinkoia.Caption := '\\' + Cbx_Caisse.Items[Cbx_Caisse.ItemIndex] + '\' + Disk + '$\Ginkoia\';
          Break;
        end;
      end;
    end
    else if FileExists('\\' + Cbx_Caisse.Items[Cbx_Caisse.ItemIndex] + '\Ginkoia\' + FICHIER_INI_CAISSE) then
      Lab_CheminGinkoia.Caption := '\\' + Cbx_Caisse.Items[Cbx_Caisse.ItemIndex] + '\' + Disk + '$\Ginkoia\';
  end;
  // pas de ginkoia ?
  if Lab_CheminGinkoia.Caption = '' then
  begin
    MessageDlg('Installation non trouver', mtError, [mbOK], 0);
    Chk_LogAllTicket.Checked := False;
    Chk_LogAllTicket.Enabled := False;
    Chk_LogTPE.Checked := False;
    Chk_LogTPE.Enabled := False;
  end
  else
  begin
    if FileExists(Lab_CheminGinkoia.Caption + FICHIER_INI_CAISSE) then
    begin
      Chk_LogAllTicket.Enabled := True;
      CaisseIni := TIniFile.Create(Lab_CheminGinkoia.Caption + FICHIER_INI_CAISSE);
      Chk_LogAllTicket.Checked := CaisseIni.ReadBool(SECTION_CAISSE, IDENT_CAISSE, false);
    end
    else
    begin
      Chk_LogAllTicket.Checked := False;
      Chk_LogAllTicket.Enabled := False;
    end;

    if FileExists(Lab_CheminGinkoia.Caption + FICHIER_INI_TPE) then
    begin
      Chk_LogTPE.Enabled := True;
      TPEIni := TIniFile.Create(Lab_CheminGinkoia.Caption + FICHIER_INI_TPE);
      Chk_LogTPE.Checked := TPEIni.ReadBool(SECTION_TPE, IDENT_TPE, false);
    end
    else
    begin
      Chk_LogTPE.Checked := False;
      Chk_LogTPE.Enabled := False;
    end;
  end;
end;

procedure TFrm_Main.Chk_LogAllTicketClick(Sender: TObject);
begin
  if Chk_LogAllTicket.Enabled then
  begin
    try
      CaisseIni.WriteBool(SECTION_CAISSE, IDENT_CAISSE, Chk_LogAllTicket.Checked);
    except
      on e : Exception do
        MessageDlg('Il semble que vous n''ayez pas les droit en écriture.'#13'(Erreur : ' + e.ClassName + ' - ' + e.Message + ')', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TFrm_Main.Chk_LogTPEClick(Sender: TObject);
begin
  if Chk_LogTPE.Enabled then
  begin
    try
      TPEIni.WriteBool(SECTION_TPE, IDENT_TPE, Chk_LogTPE. Checked);
    except
      on e : Exception do
        MessageDlg('Il semble que vous n''ayez pas les droit en écriture.'#13'(Erreur : ' + e.ClassName + ' - ' + e.Message + ')', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TFrm_Main.Btn_GetLogClick(Sender: TObject);
var
  Save : TSaveDialog;
  Zip : I7zOutArchive;
begin
  try
    Save := TSaveDialog.Create(Self);
    Save.Filter := 'Fichier 7Zip|*.7z';
    Save.FilterIndex := 0;
    Save.DefaultExt := '7z';
    Save.FileName := Cbx_Caisse.Text + '.7z';
    Save.InitialDir := ExtractFilePath(ParamStr(0));
    Save.Options := Save.Options + [ofOverwritePrompt];
    if Save.Execute() then
    begin
      if FileExists(Save.FileName) then
        DeleteFile(Save.FileName);
      try
        Cursor := crHourGlass;
        Zip := CreateOutArchive(CLSID_CFormat7z);
        // la BDC
        if DirectoryExists(Lab_CheminGinkoia.Caption + REPERTOIRE_LOG_BDC) then
          Zip.AddFiles(Lab_CheminGinkoia.Caption + REPERTOIRE_LOG_BDC, REPERTOIRE_LOG_BDC, '*.*', true);
        // log du TPE
        if DirectoryExists(Lab_CheminGinkoia.Caption + REPERTOIRE_LOG_TPE) then
          Zip.AddFiles(Lab_CheminGinkoia.Caption + REPERTOIRE_LOG_TPE, REPERTOIRE_LOG_TPE, '*.*', true);
        // les log de caisse
        if DirectoryExists(Lab_CheminGinkoia.Caption + REPERTOIRE_LOG_CAISSE) then
          Zip.AddFiles(Lab_CheminGinkoia.Caption + REPERTOIRE_LOG_CAISSE, REPERTOIRE_LOG_CAISSE, '*.*', true);
        // les log de Ginkoia
        if DirectoryExists(Lab_CheminGinkoia.Caption + REPERTOIRE_LOG_GINKOIA) then
          Zip.AddFiles(Lab_CheminGinkoia.Caption + REPERTOIRE_LOG_GINKOIA, REPERTOIRE_LOG_GINKOIA, '*.*', true);
        // enregistrement
        Zip.SaveToFile(Save.FileName);
      finally
        Zip := nil;
        Cursor := crDefault;
      end;
    end;
  finally
    FreeAndNil(Save);
  end;
end;

procedure TFrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

end.
