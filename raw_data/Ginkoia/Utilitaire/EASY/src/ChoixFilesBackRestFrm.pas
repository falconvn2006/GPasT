unit ChoixFilesBackRestFrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons;

type
  Tfrm_ChoixFilesBackRest = class(TForm)
    lbl_BaseFile: TLabel;
    edt_BaseFile: TEdit;
    btn_BaseFile: TSpeedButton;
    lbl_BackupFile: TLabel;
    edt_BackupFile: TEdit;
    btn_BackupFile: TSpeedButton;
    Btn_Annuler: TButton;
    Btn_Valider: TButton;
    chk_UseVerifFile: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure btn_BaseFileClick(Sender: TObject);
    procedure btn_BackupFileClick(Sender: TObject);
    procedure edt_BaseFileChange(Sender: TObject);
    procedure edt_BackupFileChange(Sender: TObject);
  private
    { Déclarations privées }

    //accesseur
    function GetBaseFile() : string;
    procedure SetBaseFile(Value : string);
    function GetBackupFile() : string;
    procedure SetBackupFile(Value : string);
    function GetUseVerifFile() : boolean;
    procedure SetUseVerifFile(Value : boolean);
  public
    { Déclarations publiques }

    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;

    // boite de dialogue
    function MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : Integer;

    // propriete
    property BaseFile : string read GetBaseFile write SetBaseFile;
    property BackupFile : string read GetBackupFile write SetBackupFile;
    property UseVerifFile : boolean read GetUseVerifFile write SetUseVerifFile;
  end;

function SelectFilesForBackRest(ParentFrm : TForm; var BaseFile, BackupFile : string; var UseVerifFile : boolean) : boolean;

implementation

uses
  Winapi.ShellAPI,
  System.StrUtils,
  UInfosBase,
  uGestionBDD;

{$R *.dfm}

function SelectFilesForBackRest(ParentFrm : TForm; var BaseFile, BackupFile : string; var UseVerifFile : boolean) : boolean;
var
  Fiche : Tfrm_ChoixFilesBackRest;
begin
  Result := false;
  try
    Fiche := Tfrm_ChoixFilesBackRest.Create(ParentFrm);
    if not (trim(BaseFile) = '') then
      Fiche.BaseFile := BaseFile;
    if not (trim(BackupFile) = '') then
      Fiche.BackupFile := BackupFile;
    Fiche.UseVerifFile := UseVerifFile;
    if Fiche.ShowModal() = mrOK then
    begin
      Result := (not ((Trim(Fiche.BaseFile) = '') or (Trim(Fiche.BackupFile) = '')))
                and (FileExists(Fiche.BaseFile) or FileExists(Fiche.BackupFile));
      if Result then
      begin
        BaseFile := Fiche.BaseFile;
        BackupFile := Fiche.BackupFile;
        UseVerifFile := Fiche.UseVerifFile;
      end;
    end;
  finally
    FreeAndNil(Fiche);
  end;
end;

{ Tfrm_ChoixFilesBackRest }

procedure Tfrm_ChoixFilesBackRest.FormCreate(Sender: TObject);
begin
  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);
end;

procedure Tfrm_ChoixFilesBackRest.edt_BaseFileChange(Sender: TObject);
var
  Version, Nom, GUID, BasSender, error : string;
  DateVersion : TDateTime;
  Generateur : integer;
  Recalcul : boolean;
begin
  if FileExists(edt_BaseFile.Text) then
  begin
    if CanConnect(CST_BASE_SERVEUR, edt_BaseFile.Text, CST_BASE_LOGIN, CST_BASE_PASSWORD, CST_BASE_PORT, error) then
    begin
      if GetInfosBase(CST_BASE_SERVEUR, edt_BaseFile.Text, CST_BASE_LOGIN, CST_BASE_PASSWORD, CST_BASE_PORT, Version, Nom, GUID, BasSender, DateVersion, Generateur, Recalcul, error) then
      begin
        if (Trim(edt_BackupFile.text) = '') then
          edt_BackupFile.text := ExtractFilePath(edt_BaseFile.Text) + Nom + FormatDateTime('-yyyy-mm-dd', Now()) + '.7z';
      end
      else if (Trim(edt_BackupFile.text) = '') then
        edt_BackupFile.text := ExtractFilePath(edt_BaseFile.Text) + 'GINKOIA-' + FormatDateTime('yyyy-mm-dd', Now()) + '.7z';
    end
    else
    begin
      MessageDlg('Fichier de base de donnée invalide', mtError, [mbOK]);
      edt_BaseFile.Text := '';
    end;
  end;
  Btn_Valider.Enabled := not ((Trim(edt_BaseFile.Text) = '') or (Trim(edt_BackupFile.text) = ''));
end;

procedure Tfrm_ChoixFilesBackRest.btn_BaseFileClick(Sender: TObject);
var
  Save : TSaveDialog;
begin
  try
    Save := TSaveDialog.Create(Self);
    Save.Title := 'Sélection du fichier de base';
    Save.FileName := ExtractFileName(edt_BaseFile.Text);
    Save.InitialDir := ExtractFilePath(IfThen(Trim(edt_BaseFile.Text) = '', edt_BackupFile.Text, edt_BaseFile.Text));
    Save.Filter := 'IB Database|*.IB';
    Save.FilterIndex := 0;
    Save.DefaultExt := 'IB';
    if Save.Execute() then
    begin
      edt_BaseFile.Text := '';
      edt_BaseFile.Text := Save.FileName;
    end;
  finally
    FreeAndNil(Save);
  end;
end;

procedure Tfrm_ChoixFilesBackRest.edt_BackupFileChange(Sender: TObject);
begin
  if (Trim(edt_BaseFile.Text) = '') then
    edt_BaseFile.Text := ExtractFilePath(edt_BackupFile.text) + 'GINKOIA.IB';
  Btn_Valider.Enabled := not ((Trim(edt_BaseFile.Text) = '') or (Trim(edt_BackupFile.text) = ''));
end;

procedure Tfrm_ChoixFilesBackRest.btn_BackupFileClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TSaveDialog.Create(Self);
    Open.Title := 'Sélection du fichier de backup';
    Open.FileName := ExtractFileName(edt_BackupFile.Text);
    Open.InitialDir := ExtractFilePath(IfThen(Trim(edt_BackupFile.Text) = '', edt_BaseFile.Text, edt_BackupFile.Text));
    Open.Filter := 'Fichier 7z|*.7Z|Fichier zip|*.ZIP|Fichier ZBK|*.ZBK|Fichier IBK|*.IBK|Fichier GBK|*.GBK';
    Open.FilterIndex := 0;
    Open.DefaultExt := '7Z';
    if Open.Execute() then
    begin
      edt_BackupFile.Text := '';
      edt_BackupFile.Text := Open.FileName;
    end;
  finally
    FreeAndNil(Open);
  end;
end;

// accesseurs

function Tfrm_ChoixFilesBackRest.GetBaseFile() : string;
begin
  Result := edt_BaseFile.Text
end;

procedure Tfrm_ChoixFilesBackRest.SetBaseFile(Value : string);
begin
  if not (Trim(edt_BaseFile.Text) = Trim(Value)) then
  begin
    edt_BaseFile.Text := Trim(Value);
    edt_BaseFile.Enabled := (Trim(edt_BaseFile.Text) = '');
    btn_BaseFile.Enabled := (Trim(edt_BaseFile.Text) = '');
  end;
end;

function Tfrm_ChoixFilesBackRest.GetBackupFile() : string;
begin
  Result := edt_BackupFile.Text
end;

procedure Tfrm_ChoixFilesBackRest.SetBackupFile(Value : string);
begin
  if not (Trim(edt_BackupFile.Text) = Trim(Value)) then
  begin
    edt_BackupFile.Text := Trim(Value);
    edt_BackupFile.Enabled := (Trim(edt_BackupFile.Text) = '');
    btn_BackupFile.Enabled := (Trim(edt_BackupFile.Text) = '');
  end;
end;

function Tfrm_ChoixFilesBackRest.GetUseVerifFile() : boolean;
begin
  Result := chk_UseVerifFile.Checked;
end;

procedure Tfrm_ChoixFilesBackRest.SetUseVerifFile(Value : boolean);
begin
  if not chk_UseVerifFile.Checked = Value then
    chk_UseVerifFile.Checked := value;
end;

// fonctions utilitaires

procedure Tfrm_ChoixFilesBackRest.MessageDropFiles(var msg : TWMDropFiles);
const
  MAXFILENAME = 255;
var
  i, Count : integer;
  FileName : array [0..MAXFILENAME] of char;
  FileExt : string;
begin
  try
    // le nb de fichier
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);
    // Recuperation des fichier (nom)
    for i := 0 to Count -1 do
    begin
      DragQueryFile(msg.Drop, i, FileName, MAXFILENAME);
      FileExt := UpperCase(ExtractFileExt(FileName));
      if FileExt = '.IB' then
      begin
        if edt_BaseFile.Enabled then
        begin
          edt_BaseFile.Text := '';
          edt_BaseFile.Text := FileName;
        end;
      end
      else
      begin
        if edt_BackupFile.Enabled then
        begin
          edt_BackupFile.Text := '';
          edt_BackupFile.Text := FileName;
        end;
      end;
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

// dialogue

function Tfrm_ChoixFilesBackRest.MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : Integer;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
    try
      Position := poOwnerFormCenter;
      Result := ShowModal();
    finally
      Free;
    end;
end;

end.
