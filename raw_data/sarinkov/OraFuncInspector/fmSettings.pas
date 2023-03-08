unit fmSettings;

{$INCLUDE XCompilerOptions.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, System.UITypes,
  Controls, Forms, Dialogs, fmBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinMoneyTwins, dxSkinscxPCPainter,
  dxBarBuiltInMenu, cxPC, Menus, StdCtrls, cxButtons, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, SynEditHighlighter, SynHighlighterSQL,
  SynHighlighterPython, cxDropDownEdit, cxFontNameComboBox, cxSpinEdit,
  cxCheckBox, ExtCtrls, cxListBox, cxGroupBox, dxGDIPlusClasses, dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle,
  dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinOffice2019Black,
  dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dxBevel,
  SynEdit, SynMemo;

type
  TSettingsForm = class(TBaseForm)
    dlgOpen: TOpenDialog;
    pnlMain: TPanel;
    pgcPages: TcxPageControl;
    pgCommon: TcxTabSheet;
    lblEditorPath: TLabel;
    edtEditorPath: TcxButtonEdit;
    pgSrcArea: TcxTabSheet;
    lblFont: TLabel;
    lblFontSize: TLabel;
    cbbFontName: TcxFontNameComboBox;
    edtFontSize: TcxSpinEdit;
    chbLineNumbers: TcxCheckBox;
    grbSyntax: TcxGroupBox;
    edtBG: TcxButtonEdit;
    edtKeyAttr: TcxButtonEdit;
    edtStringAttr: TcxButtonEdit;
    edtNumberAttr: TcxButtonEdit;
    edtIdentAttr: TcxButtonEdit;
    edtDataTypeAttr: TcxButtonEdit;
    edtCommentAttr: TcxButtonEdit;
    edtFunctionAttr: TcxButtonEdit;
    imgKeys: TImage;
    btnCancel: TcxButton;
    btnOk: TcxButton;
    bvlButtonsBevel: TdxBevel;
    procedure FormCreate(Sender: TObject);
    procedure edtEditorPathPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SelectAttributes(Sender: TObject; AButtonIndex: Integer);
    procedure edtEditorPathPropertiesChange(Sender: TObject);
    procedure AttrDblClick(Sender: TObject);
  private
    procedure SetBGColor(C: TColor);

    procedure ReadAttr(E: TcxButtonEdit; A: TSynHighlighterAttributes);
    procedure WriteAttr(E: TcxButtonEdit; A: TSynHighlighterAttributes);
  public
  end;

implementation

{$R *.dfm}

uses
  unGlobals, fmMain, fmAttr;

procedure TSettingsForm.AttrDblClick(Sender: TObject);
begin
  inherited;
  if (Sender is TcxButtonEdit) then
    TcxButtonEdit(Sender).Properties.OnButtonClick(Sender, 0);
end;

procedure TSettingsForm.edtEditorPathPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  inherited;
  with dlgOpen do begin
    DefaultExt := 'exe';
    FileName   := edtEditorPath.Text;
    InitialDir := ExtractFilePath(edtEditorPath.Text);
    Filter     := 'Исполняемые файлы|*.exe|Командные файлы|*.cmd|Все файлы|*.*';
    Options    := Options + [ofPathMustExist, ofFileMustExist];
  end;

  if dlgOpen.Execute(Self.Handle) then
    edtEditorPath.Text := dlgOpen.FileName;
end;

procedure TSettingsForm.edtEditorPathPropertiesChange(Sender: TObject);
begin
  inherited;
  edtEditorPath.Hint := edtEditorPath.Text;
end;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);

  procedure SetMemoParams(Memo: TSynMemo);
  begin
    with Memo do begin
      Font.Name              := cbbFontName.Text;
      Font.Size              := edtFontSize.Value;
      Gutter.ShowLineNumbers := chbLineNumbers.Checked;
      Color                  := edtBG.Style.Color;
    end;
  end;

begin
  inherited;
  if ModalResult = mrOk then begin
    AppSettings.EditorPath := edtEditorPath.Text;

    SetMemoParams(MainForm.mmoSource);
    SetMemoParams(MainForm.mmoSpec);
    SetMemoParams(MainForm.mmoBody);

    with MainForm.hlSQL do begin
      WriteAttr(edtKeyAttr, KeyAttri);
      WriteAttr(edtKeyAttr, PLSQLAttri);
      WriteAttr(edtKeyAttr, SQLPlusAttri);

      WriteAttr(edtStringAttr, StringAttri);
      WriteAttr(edtNumberAttr, NumberAttri);
      WriteAttr(edtIdentAttr, IdentifierAttri);
      WriteAttr(edtIdentAttr, SymbolAttri);

      WriteAttr(edtDataTypeAttr, DataTypeAttri);
      WriteAttr(edtFunctionAttr, FunctionAttri);
      WriteAttr(edtCommentAttr, CommentAttri);
    end;
  end;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  inherited;
  pgcPages.ActivePage       := pgCommon;

  edtEditorPath.Text        := AppSettings.EditorPath;
  with MainForm do begin
    cbbFontName.Text        := mmoSource.Font.Name;
    edtFontSize.Value       := mmoSource.Font.Size;
    chbLineNumbers.Checked  := mmoSource.Gutter.ShowLineNumbers;
    edtBG.Style.Color       := mmoSource.Color;
  end;
  with MainForm.hlSQL do begin
    ReadAttr(edtKeyAttr, KeyAttri);
    ReadAttr(edtStringAttr, StringAttri);
    ReadAttr(edtNumberAttr, NumberAttri);
    ReadAttr(edtIdentAttr, IdentifierAttri);
    ReadAttr(edtDataTypeAttr, DataTypeAttri);
    ReadAttr(edtFunctionAttr, FunctionAttri);
    ReadAttr(edtCommentAttr, CommentAttri);
  end;
  SetBGColor(edtBG.Style.Color);
end;

procedure TSettingsForm.SelectAttributes(Sender: TObject; AButtonIndex: Integer);
var
  E: TcxButtonEdit;
  F: TAttrForm;
begin
  inherited;
  F := TAttrForm.Create(Self);
  if Sender is TcxButtonEdit then E := TcxButtonEdit(Sender)
                             else Exit;
  try
    with F do begin
      gbxAttr.Caption := E.Text;
      if E = edtBG then begin
        cbxColor.ColorValue := E.Style.Color;
        chkBold.Enabled     := False;
        chkItalic.Enabled   := False;
        chkBold.Checked     := False;
        chkItalic.Checked   := False;
      end else begin
        cbxColor.ColorValue := E.Style.TextColor;
        chkBold.Checked     := fsBold   in E.Style.Font.Style;
        chkItalic.Checked   := fsItalic in E.Style.Font.Style;
      end;

      if ShowModal = mrOk then begin
        if E = edtBG then begin
          SetBGColor(cbxColor.ColorValue);
          if cbxColor.ColorValue = clBlack
            then E.Style.TextColor := clWhite
            else E.Style.TextColor := clNone;
        end else
          E.Style.TextColor := cbxColor.ColorValue;
        E.Style.Font.Style := [];
        if chkBold.Checked   then E.Style.Font.Style := E.Style.Font.Style + [fsBold];
        if chkItalic.Checked then E.Style.Font.Style := E.Style.Font.Style + [fsItalic];
      end;
    end;
    E.SelLength := 0;
  finally
    FreeAndNil(F);
  end;
end;

procedure TSettingsForm.SetBGColor(C: TColor);
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
    if (Components[i] is TcxButtonEdit) and (TcxButtonEdit(Components[i]).Parent = grbSyntax) then
      TcxButtonEdit(Components[i]).Style.Color := C;
end;

procedure TSettingsForm.WriteAttr(E: TcxButtonEdit; A: TSynHighlighterAttributes);
begin
  A.Foreground := E.Style.TextColor;
  A.Background := clNone;
  A.Style      := [];
  if fsBold   in E.Style.Font.Style then A.Style := A.Style + [fsBold];
  if fsItalic in E.Style.Font.Style then A.Style := A.Style + [fsItalic];
end;

procedure TSettingsForm.ReadAttr(E: TcxButtonEdit; A: TSynHighlighterAttributes);
begin
  E.Style.Font.Style := A.Style;
  E.Style.Color      := edtBG.Style.Color;
  E.Style.TextColor  := A.Foreground;
end;

end.
