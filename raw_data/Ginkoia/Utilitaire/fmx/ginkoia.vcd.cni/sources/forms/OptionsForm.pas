unit OptionsForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.Objects, uEntropy.TForm.Constrained,
  uEntropy.TSpeedButton.Colored, uParameters;

type
  TFrm_Options = class(TForm)
    Lay_Wrapper: TLayout;
    Img_Background: TImage;
    Lay_Header: TLayout;
    Rec_Header: TRectangle;
    Lay_AppBar: TLayout;
    Lab_AppCaption: TLabel;
    Img_AppIcon: TImage;
    Lay_Footer: TLayout;
    SBtn_Close: TSpeedButton;
    Img_CloseBtn: TImage;
    SBtn_Ok: TSpeedButton;
    Img_OkBtn: TImage;
    Edt_Directory: TEdit;
    EllipsesEditButton1: TEllipsesEditButton;
    Lab_Directory: TLabel;
    Lab_Format: TLabel;
    CBox_DocumentFormat: TComboBox;
    Label1: TLabel;
    LBox_Permissions: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure EllipsesEditButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SBtn_OkClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Parameters: TParameters;
    procedure Load;
    procedure Save;
  end;

var
  Frm_Options: TFrm_Options;

implementation

uses
  System.IniFiles;

{$R *.fmx}

procedure TFrm_Options.EllipsesEditButton1Click(Sender: TObject);
var
  ChoosenDirectory: String;
begin
  if SelectDirectory( 'Répertoire de déstination...', Edt_Directory.Text, ChoosenDirectory ) then
    Edt_Directory.Text := IncludeTrailingPathDelimiter( ChoosenDirectory );
end;

procedure TFrm_Options.FormCreate(Sender: TObject);
begin
  {$REGION 'GUI'}
  SizeGrid.Visible := False;
  MinWidth := 372;
  MaxWidth := 372;
  MinHeight := 129;
  MaxHeight := 129;
  {$ENDREGION 'GUI'}
  Parameters := TParameters.Parse;
  Load;
end;

procedure TFrm_Options.FormDestroy(Sender: TObject);
begin
  Parameters.Free;{ TODO -cfix : fix? record>class pour destruction propre ? }
end;

procedure TFrm_Options.Load;
var
  IniFile: TIniFile;
  vDirectory: String;
begin
  IniFile := TIniFile.Create( ChangeFileExt( ParamStr( 0 ), '.ini' ) );
  try
    Parameters.Directory := IniFile.ReadString( 'Global', 'Directory', ExtractFilePath( ParamStr( 0 ) ) );
    { gui }
    Edt_Directory.Text := Parameters.Directory;
  finally
    IniFile.Free;
  end;
end;

procedure TFrm_Options.Save;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create( ChangeFileExt( ParamStr( 0 ), '.ini' ) );
  try
    IniFile.WriteString( 'Global', 'Directory', Edt_Directory.Text );
  finally
    IniFile.Free;
  end;
end;

procedure TFrm_Options.SBtn_OkClick(Sender: TObject);
begin
  Save;
end;

end.
