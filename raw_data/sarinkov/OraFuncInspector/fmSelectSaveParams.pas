unit fmSelectSaveParams;

{$INCLUDE XCompilerOptions.inc}
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Registry,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fmBaseDialog, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin,
  dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, dxBevel, Vcl.ComCtrls, RzTreeVw, RzFilSys, Vcl.FileCtrl, cxControls, cxContainer, cxEdit, cxCheckBox,
  cxGroupBox, cxTextEdit, cxMaskEdit, cxDropDownEdit;

type
  TSelectSaveParamsForm = class(TBaseDialogForm)
    gbxSaveOptions: TcxGroupBox;
    chbOwnerDir: TcxCheckBox;
    chbTypeDir: TcxCheckBox;
    chbOwnerInName: TcxCheckBox;
    chbTypeInName: TcxCheckBox;
    edtDir: TcxTextEdit;
    cbxFileExt: TcxComboBox;
    lblFileExt: TLabel;
    lblDir: TLabel;
    btnClearTextList: TcxButton;
    gbxDirTree: TcxGroupBox;
    dtrDirTree: TRzDirectoryTree;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dtrDirTreeChange(Sender: TObject; Node: TTreeNode);
    procedure btnClearFileExtListClick(Sender: TObject);
  private
    function  GetDirectory: string;
    procedure SetDirectory(const Value: string);
    function  GetFileExt: string;
  public
    procedure SaveToRegistry(R: TRegistry); override;
    procedure LoadFromRegistry(R: TRegistry); override;

    property  Directory: string read GetDirectory write SetDirectory;
    property  FileExt: string read GetFileExt;
  end;

function  SelectSaveParams: Boolean;

implementation

{$R *.dfm}

uses
  Math, XHelpers, XUtils, unConsts, unGlobals;

function  SelectSaveParams: Boolean;
var
  F: TSelectSaveParamsForm;
begin
  F := TSelectSaveParamsForm.Create(Application);
  try
    Result := F.ShowModal = mrOk;
  finally
    FreeAndNil(F);
  end;
end;

procedure TSelectSaveParamsForm.btnClearFileExtListClick(Sender: TObject);
begin
  inherited;
  cbxFileExt.Properties.Items.Clear;
end;

procedure TSelectSaveParamsForm.dtrDirTreeChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  edtDir.Text := dtrDirTree.Directory;
end;

procedure TSelectSaveParamsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if ModalResult = mrOk then
    with AppSettings.SaveOptions do begin
      Dir             := Directory;
      Ext             := FileExt;
      CreateOwnerDir  := chbOwnerDir.Checked;
      CreateTypeDir   := chbTypeDir.Checked;
      OwnerInFileName := chbOwnerInName.Checked;
      TypeInFileName  := chbTypeInName.Checked;
    end;
end;

procedure TSelectSaveParamsForm.FormCreate(Sender: TObject);
begin
  edtDir.Text      := '';

  inherited;

  gbxDirTree.Align := alClient;
  Height           := Trunc(Screen.Height * 2/3);
  Width            := Trunc(Screen.Width  * 1/3);
  edtDir.Width     := gbxSaveOptions.ClientWidth - edtDir.Left - lblDir.Left;
end;

function TSelectSaveParamsForm.GetDirectory: string;
begin
  Result := IncludeTrailingPathDelimiter(edtDir.Text);
end;

procedure TSelectSaveParamsForm.SetDirectory(const Value: string);
begin
  dtrDirTree.Directory := Value;
end;

function TSelectSaveParamsForm.GetFileExt: string;
begin
  if pos('.', cbxFileExt.Text) = 0 then Result := cbxFileExt.Text
                                   else Result := StringReplace(cbxFileExt.Text, '.', '', [rfReplaceAll]);
end;

procedure TSelectSaveParamsForm.SaveToRegistry(R: TRegistry);
begin
  inherited;
  if ModalResult = mrOk then begin
    R.WriteString(S_SAVE_OPTIONS + '.' + S_DIRECTORY, Directory);
    SaveComboBox(R, cbxFileExt);

    R.WriteBool(S_SAVE_OPTIONS + '.' + S_OWNER_DIR, chbOwnerDir.Checked);
    R.WriteBool(S_SAVE_OPTIONS + '.' + S_TYPE_DIR, chbTypeDir.Checked);
    R.WriteBool(S_SAVE_OPTIONS + '.' + S_OWNER_IN_NAME, chbOwnerInName.Checked);
    R.WriteBool(S_SAVE_OPTIONS + '.' + S_TYPE_IN_NAME, chbTypeInName.Checked);
  end;
end;

procedure TSelectSaveParamsForm.LoadFromRegistry(R: TRegistry);
begin
  inherited;
  Directory              := R.ReadString(S_SAVE_OPTIONS + '.' + S_DIRECTORY, Directory);
  LoadComboBox(R, cbxFileExt);

  chbOwnerDir.Checked    := R.ReadBool(S_SAVE_OPTIONS + '.' + S_OWNER_DIR, chbOwnerDir.Checked);
  chbTypeDir.Checked     := R.ReadBool(S_SAVE_OPTIONS + '.' + S_TYPE_DIR, chbTypeDir.Checked);
  chbOwnerInName.Checked := R.ReadBool(S_SAVE_OPTIONS + '.' + S_OWNER_IN_NAME, chbOwnerInName.Checked);
  chbTypeInName.Checked  := R.ReadBool(S_SAVE_OPTIONS + '.' + S_TYPE_IN_NAME, chbTypeInName.Checked);
end;
{$WARN SYMBOL_DEPRECATED ON}

end.
