unit VersionFrm;

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
  Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TFrm_Version = class(TForm)
    Btn_Valider: TButton;
    Btn_Annuler: TButton;
    rg_TypeVersion: TRadioGroup;
    pnl_TypeVersion: TGridPanel;
    pnl_Version: TPanel;
    pnl_Fichier: TPanel;
    cbx_Version: TComboBox;
    edt_Fichier: TEdit;
    btn_Fichier: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure rg_TypeVersionClick(Sender: TObject);
    procedure btn_FichierClick(Sender: TObject);
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    function GetVersion() : string;

    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;
  public
    { Déclarations publiques }
    property Version : string read GetVersion;
  end;

function SelectVersion(ParentFrm : TForm; Versions : TStringList) : string;

implementation

uses
  Winapi.ShellAPI;

{$R *.dfm}

function SelectVersion(ParentFrm : TForm; Versions : TStringList) : string;
var
  Fiche : TFrm_Version;
begin
  Result := '';
  try
    Fiche := TFrm_Version.Create(ParentFrm);
    Fiche.cbx_Version.Items.AddStrings(Versions);
    if Fiche.ShowModal() = mrOk then
      Result := Fiche.Version;
  finally
    FreeAndNil(Fiche);
  end;
end;

procedure TFrm_Version.FormCreate(Sender: TObject);
begin
  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);

  rg_TypeVersion.ItemIndex := 0;
end;

procedure TFrm_Version.rg_TypeVersionClick(Sender: TObject);
begin
  cbx_Version.Enabled := false;
  edt_Fichier.Enabled := false;
  btn_Fichier.Enabled := false;

  case rg_TypeVersion.ItemIndex of
    0 :
      begin
        cbx_Version.Enabled := true;
        edt_Fichier.Text := '';
      end;
    1 :
      begin
        cbx_Version.ItemIndex := -1;
        edt_Fichier.Enabled := true;
        btn_Fichier.Enabled := true;
      end;
  end;
end;

procedure TFrm_Version.btn_FichierClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    if Trim(edt_Fichier.Text) = '' then
    begin
      if DirectoryExists('C:\Developpement\Ginkoia\Script en cours\') then
        Open.InitialDir := 'C:\Developpement\Ginkoia\Script en cours\'
      else if DirectoryExists('D:\Ginkoia\') then
        Open.InitialDir := 'D:\Ginkoia\'
      else if DirectoryExists('C:\Ginkoia\') then
        Open.InitialDir := 'C:\Ginkoia\';
      Open.FileName := 'script.SCR';
    end
    else
    begin
      Open.FileName := ExtractFileName(edt_Fichier.Text);
      Open.InitialDir := ExtractFilePath(edt_Fichier.Text);
    end;
    Open.Filter := 'Fichier script SCR|*.SCR|Fichier script SQL|*.SQL';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'SCR';
    if Open.Execute() then
    begin
      edt_Fichier.Text := '';
      edt_Fichier.Text := Open.FileName;
    end;
  finally
    FreeAndNil(Open);
  end;
end;

function TFrm_Version.GetVersion() : string;
begin
  case rg_TypeVersion.ItemIndex of
    0 : Result := cbx_Version.Items[cbx_Version.ItemIndex];
    1 : Result := edt_Fichier.Text;
    else Result := '';
  end;
end;

procedure TFrm_Version.MessageDropFiles(var msg : TWMDropFiles);
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
      if (FileExt = '.SCR') or (FileExt = '.SQL') then
      begin
        rg_TypeVersion.ItemIndex := 1;
        edt_Fichier.Text := FileName;
      end;
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

end.
