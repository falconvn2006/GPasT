unit UMain_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmMain = class(TForm)
    PnlParam: TPanel;
    LblIbFile: TLabel;
    LblIbCopyFile: TLabel;
    LblIbBackupFile: TLabel;
    LblIbRestoreFile: TLabel;
    LblLogFile: TLabel;
    EdtIbFile: TEdit;
    EdtIbCopyFile: TEdit;
    EdtIbBackupFile: TEdit;
    EdtIbRestoreFile: TEdit;
    EdtLogFile: TEdit;
    BtnIbFile: TSpeedButton;
    BtnIbCopyFile: TSpeedButton;
    BtnIbBackupFile: TSpeedButton;
    BtnIbRestoreFile: TSpeedButton;
    BtnLogFile: TSpeedButton;
    RdgTypeTraitement: TRadioGroup;
    PnlActions: TPanel;
    BtnStart: TBitBtn;
    BtnClose: TBitBtn;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    GbxOptions: TGroupBox;
    ChkReboot: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnIbFileClick(Sender: TObject);
    procedure BtnIbCopyFileClick(Sender: TObject);
    procedure BtnIbBackupFileClick(Sender: TObject);
    procedure BtnIbRestoreFileClick(Sender: TObject);
    procedure BtnLogFileClick(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure EdtIbFileChange(Sender: TObject);
    procedure RdgTypeTraitementClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure CheckControls;
    procedure InitParams;
    procedure UpdateOthersParams;
  public
    { Déclarations publiques }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  System.UITypes,
  UConstants, UParams, UUtils, UTraitement_Frm;

{$R *.dfm}

procedure TFrmMain.BtnStartClick(Sender: TObject);
begin
  if not FileExists(EdtIbFile.Text) then
  begin
    MessageDlg(DB_NOT_EXIST, mtWarning, [mbCancel], 0);
    Exit;
  end;
  // Confirmation du lancement du traitement automatique
  if (RdgTypeTraitement.ItemIndex = 0) and
     (MessageDlg('Démarrer le traitement automatique ?', mtConfirmation, [mbNo, mbYes], 0) <> mrYes) then
    Exit;

  //
  with TFrmTraitement.Create(Self) do
  begin
    ModeAuto := RdgTypeTraitement.ItemIndex = 0;
    RebootAuto := ModeAuto and ChkReboot.Checked;
    DatabaseName := EdtIbFile.Text;
    DatabaseNameCopy := EdtIbCopyFile.Text;
    BackupFileName := EdtIbBackupFile.Text;
    RestoreFileName := EdtIbRestoreFile.Text;
    LogFileName := EdtLogFile.Text;
    //
    Left := Self.Left;
    Top := Self.Top;
    Self.Hide;
    try
      ShowModal;
    finally
      Self.Show;
    end;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  Caption := Caption + ' - ' + 'V ' + GetExeFileVersion(Application.ExeName);
  //
  EdtIbFile.Clear;
  EdtIbCopyFile.Clear;
  EdtIbBackupFile.Clear;
  EdtIbRestoreFile.Clear;
  EdtLogFile.Clear;

  InitParams;
end;

procedure TFrmMain.InitParams;
begin
  // Emplacement de la base de données
  if DirectoryExists('C:' + IB_DATABASE_DIR) then
  begin
    if FileExists('C:' + IB_DATABASE_DIR + IB_DATABASE_NAME + '.IB') then
      EdtIbFile.Text := 'C:' + IB_DATABASE_DIR + IB_DATABASE_NAME + '.IB'
    else if FileExists('C:' + IB_DATABASE_DIR + IB_DATABASE_NAME + '.GDB') then
      EdtIbFile.Text := 'C:' + IB_DATABASE_DIR + IB_DATABASE_NAME + '.GDB';
    OpenDlg.InitialDir := 'C:' + IB_DATABASE_DIR;
  end
  else if DirectoryExists('D:' + IB_DATABASE_DIR) then
  begin
    if FileExists('D:' + IB_DATABASE_DIR + IB_DATABASE_NAME + '.IB') then
      EdtIbFile.Text := 'D:' + IB_DATABASE_DIR + IB_DATABASE_NAME + '.IB'
    else if FileExists('D:' + IB_DATABASE_DIR + IB_DATABASE_NAME + '.GDB') then
      EdtIbFile.Text := 'D:' + IB_DATABASE_DIR + IB_DATABASE_NAME + '.GDB';
    OpenDlg.InitialDir := 'D:' + IB_DATABASE_DIR;
  end;
  // Traitement en mode automatique par défaut
  RdgTypeTraitement.ItemIndex := 0;
  //
  if EdtIbFile.Text <> '' then
    UpdateOthersParams
  else
    CheckControls;
end;

procedure TFrmMain.RdgTypeTraitementClick(Sender: TObject);
begin
  CheckControls;
end;

procedure TFrmMain.UpdateOthersParams;
begin
  // Noms de fichier par défaut
  EdtIbBackupFile.Text := ChangeFileExt(EdtIbFile.Text, '.gbk');
  EdtIbRestoreFile.Text := EdtIbFile.Text;
  EdtLogFile.Text := ChangeFileExt(EdtIbFile.Text, FormatDateTime('-YYYYMMDD-hhmm', Now) + '.log');
  EdtIbCopyFile.Text := '';
  //
  CheckControls;
end;

procedure TFrmMain.BtnIbFileClick(Sender: TObject);
begin
  OpenDlg.Title := IB_DATABASE;
  OpenDlg.Filter := IB_DATABASE + '|*.ib;*.gdb';
  OpenDlg.FileName := '*.ib';
  if OpenDlg.Execute then
  begin
    EdtIbFile.Text := OpenDlg.FileName;
    UpdateOthersParams;
  end;
end;

procedure TFrmMain.BtnIbCopyFileClick(Sender: TObject);
begin
  SaveDlg.Title := IB_COPY;
  SaveDlg.Filter := IB_DATABASE + '|*.ib;*.gdb';
  SaveDlg.InitialDir := ExtractFileDir(OpenDlg.FileName);
  SaveDlg.FileName := ChangeFileExt(ExtractFileName(OpenDlg.FileName), SUFFIXE_COPIE + ExtractFileExt(OpenDlg.FileName));
  if SaveDlg.Execute then
  begin
    if SaveDlg.FileName = OpenDlg.FileName then
      MessageDlg(IB_DIFF_NAME, mtError, [mbCancel], 0)
    else
      EdtIbCopyFile.Text := SaveDlg.FileName;
  end;
end;

procedure TFrmMain.BtnIbBackupFileClick(Sender: TObject);
begin
  SaveDlg.Title := IB_LOCATION;
  SaveDlg.Filter := IB_BACKUP + '|*.gbk';
  SaveDlg.InitialDir := ExtractFileDir(OpenDlg.FileName);
  SaveDlg.FileName := ChangeFileExt(OpenDlg.FileName, '.gbk');
  if SaveDlg.Execute then
  begin
    EdtIbBackupFile.Text := SaveDlg.FileName;
  end;
end;

procedure TFrmMain.BtnIbRestoreFileClick(Sender: TObject);
begin
  SaveDlg.Title := IB_RESTORE;
  SaveDlg.Filter := IB_BACKUP + '|*.gbk';
  SaveDlg.InitialDir := ExtractFileDir(OpenDlg.FileName);
  SaveDlg.FileName := OpenDlg.FileName;
  if SaveDlg.Execute then
  begin
    EdtIbRestoreFile.Text := SaveDlg.FileName;
  end;
end;

procedure TFrmMain.BtnLogFileClick(Sender: TObject);
begin
  SaveDlg.Title := LOG_FILE_LOCATION;
  SaveDlg.Filter := LOG_FILE + '|*.log';
  SaveDlg.InitialDir := ExtractFileDir(OpenDlg.FileName);
  SaveDlg.FileName := ChangeFileExt(OpenDlg.FileName, FormatDateTime('-YYYYMMDD-hhmm', Now) + '.log');
  if SaveDlg.Execute then
  begin
    EdtLogFile.Text := SaveDlg.FileName;
  end;
end;

procedure TFrmMain.CheckControls;
begin
  if FileExists(EdtIbFile.Text) then
  begin
    BtnIbCopyFile.Enabled := True;
    BtnIbBackupFile.Enabled := True;
    BtnIbRestoreFile.Enabled := True;
    BtnLogFile.Enabled := True;
    BtnStart.Enabled := True;
  end
  else
  begin
    BtnIbCopyFile.Enabled := False;
    BtnIbBackupFile.Enabled := False;
    BtnIbRestoreFile.Enabled := False;
    BtnLogFile.Enabled := False;
    BtnStart.Enabled := False;
  end;
  //
  GbxOptions.Visible := (RdgTypeTraitement.ItemIndex = 0) and
                        (SRepareBase.RebootAllowed);
end;

procedure TFrmMain.EdtIbFileChange(Sender: TObject);
begin
  CheckControls;
end;

end.

