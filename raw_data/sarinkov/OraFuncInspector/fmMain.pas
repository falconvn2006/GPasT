unit fmMain;

{$INCLUDE XCompilerOptions.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fmBase, cxClasses, cxLookAndFeels, dxSkinsForm, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinCaramel, dxSkinMoneyTwins, Vcl.StdCtrls, Vcl.ExtCtrls, cxGraphics, cxControls,
  cxLookAndFeelPainters, dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCoffee, dxSkinDarkroom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin,
  dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxContainer, cxEdit, cxProgressBar, dxStatusBar, Vcl.Menus, cxButtons, System.ImageList, Vcl.ImgList, cxImageList,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, System.Win.Registry, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, cxCheckBox, cxSplitter, cxStyles, cxCustomData, cxDataStorage, cxNavigator,
  cxDBData, cxGridLevel, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxGroupBox, dxBarBuiltInMenu, cxPC, SynEdit, SynMemo, SynEditMiscClasses, SynEditSearch,
  SynEditHighlighter, SynHighlighterSQL, cxFilter, cxData, dxDateRanges, dxScrollbarAnnotations, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Vcl.Buttons;

type
  TMainForm = class(TBaseForm)
    StatusBar: TdxStatusBar;
    pbcProgress: TdxStatusBarContainerControl;
    prbStPB: TcxProgressBar;
    pnlTop: TPanel;
    pnlFilter: TPanel;
    btnSearch: TcxButton;
    ActMgr: TActionManager;
    actSearch: TAction;
    actSaveItemsToDisk: TAction;
    ilsActions16x16: TcxImageList;
    ilsActions24x24: TcxImageList;
    ilsActions32x32: TcxImageList;
    cbxOwner: TcxComboBox;
    lblOwner: TLabel;
    cbxText: TcxComboBox;
    lblText: TLabel;
    actExternalEdit: TAction;
    pnlTools: TPanel;
    btnSave: TcxButton;
    btnExternalEdit: TcxButton;
    actSettings: TAction;
    btnSettings: TcxButton;
    pnlMain: TPanel;
    pnlGrid: TPanel;
    Splitter: TcxSplitter;
    pnlProgressBar: TPanel;
    prbPB: TcxProgressBar;
    qryMain: TFDQuery;
    dsMain: TDataSource;
    fldMain_OWNER: TStringField;
    fldMain_NAME: TStringField;
    fldMain_TYPE: TStringField;
    fldMain_TYPE_ID: TFMTBCDField;
    tvMain: TcxGridDBTableView;
    glvMainLevel1: TcxGridLevel;
    grdMain: TcxGrid;
    clmOwner: TcxGridDBColumn;
    clmName: TcxGridDBColumn;
    clmType: TcxGridDBColumn;
    pnlText: TPanel;
    gbxSource: TcxGroupBox;
    fldMain_REC_COUNT: TFMTBCDField;
    pgcPackage: TcxPageControl;
    tsSpec: TcxTabSheet;
    tsBody: TcxTabSheet;
    mmoBody: TSynMemo;
    mmoSpec: TSynMemo;
    mmoSource: TSynMemo;
    qrySource: TFDQuery;
    hlSQL: TSynSQLSyn;
    pnlSearch: TPanel;
    serSource: TSynEditSearch;
    chbPackages: TcxCheckBox;
    chbTypes: TcxCheckBox;
    chbJavaSources: TcxCheckBox;
    chbProcedures: TcxCheckBox;
    chbFunctions: TcxCheckBox;
    chbTriggers: TcxCheckBox;
    btnClearTextList: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure actRefresh(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure dsMainDataChange(Sender: TObject; Field: TField);
    procedure qryMainAfterOpen(DataSet: TDataSet);
    procedure actSaveItemsToDiskExecute(Sender: TObject);
    procedure actExternalEditExecute(Sender: TObject);
    procedure ActMgrUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure btnClearTextListClick(Sender: TObject);
    procedure MemoPaint(Sender: TObject; Canvas: TCanvas; TransientType: TTransientType);
    procedure SearchOnEnter(Sender: TObject; var Key: Char);
  private
    FTextForSearch: string;

    function  GetText: string;
    function  GetOwnerName: string;
    function  GetRecordCount: Integer;
    function  GetCurOwner: string;
    function  GetCurName: string;
    function  GetCurType: string;
    function  GetCurTypeID: Integer;

    function  SetScreenCursor(ACursor: TCursor): TCursor;

    function  TryToConnect: Boolean;
    procedure ShowProgressBar(AMin, AMax: Integer);
    procedure HideProgressBar;
    procedure TextToDropDownList(const Text: string);

    procedure DoRefresh;
    procedure DoSaveItemsToDisk;
    procedure SaveSource(const AOwner, AName, AType: string);
    procedure SourceToFile(const FileName: string; const AOwner, AName, AType: string);
    procedure DoExternalEdit;
    procedure DoSettings;
    procedure SourceToStrings(const AOwner, AName, AType: string; Lines: TStrings; ClearLines: Boolean = True);
    procedure ShowSource(const AOwner, AName, AType: string);
    function  GetSelectedCount: Integer;
  public
    procedure InitForm; override;
    procedure SaveToRegistry(R: TRegistry); override;
    procedure LoadFromRegistry(R: TRegistry); override;

    property  TextForSearch: string read FTextForSearch write FTextForSearch;
    property  Text: string read GetText;
    property  OwnerName: string read GetOwnerName;
    property  CurOwner: string read GetCurOwner;
    property  CurName: string read GetCurName;
    property  CurType: string read GetCurType;
    property  CurTypeID: Integer read GetCurTypeID;
    property  RecordCount: Integer read GetRecordCount;
    property  SelectedCount: Integer read GetSelectedCount;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Winapi.ShlObj, Winapi.ShellAPI, System.Math, SynEditTypes,
  XHelpers, XUtils, XStrUtils, dmMain, fmLogin, fmSelectSaveParams, fmSettings, unConsts, unGlobals;

const
  MAX_TEXT_ITEMS     = 25;

  SB_CONNECTION_INFO = 0;
  SB_RECORDS_INFO    = 1;
  SB_PRB             = 2;

  S_WIDTH            = 'Width';
  S_INDEX            = 'Index';

procedure TMainForm.actExternalEditExecute(Sender: TObject);
begin
  DoExternalEdit;
end;

procedure TMainForm.actSaveItemsToDiskExecute(Sender: TObject);
begin
  DoSaveItemsToDisk;
end;

procedure TMainForm.ActMgrUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  inherited;
  actSaveItemsToDisk.Enabled := qryMain.Active and (SelectedCount > 0);
  actExternalEdit.Enabled    := actSaveItemsToDisk.Enabled and ((mmoSpec.Text <> '') or (mmoSource.Text <> ''));
end;

procedure TMainForm.actRefresh(Sender: TObject);
begin
  inherited;

  TextToDropDownList(Text);
  DoRefresh;
end;

procedure TMainForm.actSettingsExecute(Sender: TObject);
begin
  inherited;

  DoSettings;
  SaveFormParams;
end;

procedure TMainForm.btnClearTextListClick(Sender: TObject);
begin
  inherited;
  cbxText.Properties.Items.Clear;
end;

procedure TMainForm.SearchOnEnter(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then begin
    actSearch.Execute;
    Key := #0;
  end;
end;

procedure TMainForm.DoSettings;
var
  F: TSettingsForm;
begin
  F := TSettingsForm.Create(Self);
  try
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure TMainForm.dsMainDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  if RecordCount > 0
    then gbxSource.Caption := Format('%s (%s)', [fldMain_NAME.AsString, fldMain_TYPE.AsString])
    else gbxSource.Caption := '';
  ShowSource(CurOwner, CurName, CurType);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  if not TryToConnect then
    Application.Terminate;

  HideProgressBar;
  Caption                := Application.Title;
  pnlMain.Align          := alClient;
  grdMain.Align          := alClient;
  pnlText.Align          := alClient;
  gbxSource.Align          := alClient;
  gbxSource.Caption        := #32;

  pgcPackage.Align       := alClient;
  pgcPackage.Visible     := False;
  mmoSpec.Align          := alClient;
  mmoBody.Align          := alClient;
  mmoSpec.Text           := '';
  mmoBody.Text           := '';

  mmoSource.Text         := '';
  mmoSource.Align        := alClient;
  mmoSource.Visible      := False;

  FTextForSearch         := '';

  HideProgressBar;
  with StatusBar do begin
    Panels[SB_CONNECTION_INFO].Text := Format('Соединение: %s@%s', [DM.Connection.Params.UserName, DM.Connection.Params.Database]);
    Panels[SB_RECORDS_INFO].Text    := '';
    Panels[SB_PRB].Visible          := False;
  end;

  cbxText.Properties.Items.Delimiter := #10;
  if cbxText.ItemIndex = -1 then
    cbxText.Text := '';

  DoRefresh;
end;

procedure TMainForm.FormResize(Sender: TObject);
var
  W: Integer;
  i: Integer;
begin
  inherited;
  W := ClientWidth div StatusBar.Panels.Count;
  for i := 0 to StatusBar.Panels.Count - 2 do
    StatusBar.Panels[i].Width := W;

  with pnlGrid.Constraints do begin
    MaxWidth := ClientWidth div 2;
    MinWidth := Min(MinWidth, MaxWidth);
  end;
  pnlGrid.Width := Min(pnlGrid.Width, pnlGrid.Constraints.MaxWidth);
  pnlGrid.Width := Max(pnlGrid.Width, pnlGrid.Constraints.MinWidth);
end;

procedure TMainForm.HideProgressBar;
begin
  pnlProgressBar.Visible           := False;
  StatusBar.Panels[SB_PRB].Visible := False;
end;

procedure TMainForm.InitForm;

  procedure LoadOwners;
  var
    Q: TFDQuery;
    R: TRegistry;
  begin
    Q := DM.CreateQuery;
    try
      try
        Q.Open(
          'SELECT u.username'#13
        + '  FROM all_users u'#13
        + ' ORDER BY u.username'
        );
        cbxOwner.Properties.Items.Clear;
        Q.First;
        while not Q.EOF do begin
          cbxOwner.Properties.Items.Add(Q.FieldByName('username').AsString);
          Q.Next;
        end;
      except
      end;

      R := TRegistry.Create;
      try
        R.RootKey := HKEY_CURRENT_USER;
        if R.OpenKey(RegistryKey, True) then
          cbxOwner.Text := R.ReadString(S_OWNER, '');
      finally
        FreeAndNil(R);
      end;
    finally
      FreeAndNil(Q);
    end;
  end;

begin
  inherited;

  LoadOwners;
end;

procedure TMainForm.DoRefresh;
begin
  TextToDropDownList(Text);
  FTextForSearch := Text;

  with qryMain do begin
    DisableControls;

    gbxSource.Caption  := '';
    mmoSource.Visible  := False;
    pgcPackage.Visible := False;

    Close;
    Params.ClearValues();
    ParamByName('owner').AsString           := OwnerName;
    ParamByName('text').AsString            := Self.Text;
    ParamByName('p_functions').AsInteger    := ord(chbFunctions.Checked);
    ParamByName('p_procedures').AsInteger   := ord(chbProcedures.Checked);
    ParamByName('p_triggers').AsInteger     := ord(chbTriggers.Checked);
    ParamByName('p_packages').AsInteger     := ord(chbPackages.Checked);
    ParamByName('p_types').AsInteger        := ord(chbTypes.Checked);
    ParamByName('p_java_sources').AsInteger := ord(chbJavaSources.Checked);
    try
      Open;
    except
      on E: Exception do
        MsgBox('Ошибка выполненния', E.Message, MB_OK + MB_ICONERROR);
    end;

    EnableControls;
  end;
end;

procedure TMainForm.DoExternalEdit;

  function  GetTempDir: string;
  var
    Path: array [0..255] of char;
  begin
    SHGetSpecialFolderPath(0, @Path[0], CSIDL_PERSONAL, False);
    Result := IncludeTrailingPathDelimiter(Path);
  end;

var
  FileName: string;
begin
  if AppSettings.EditorPath = '' then begin
    MsgBox('Не указан редактор', 'В настройках не указан внешний редактор.', MB_ICONSTOP + MB_OK);
    Exit;
  end;

  FileName := GetTempDir + Format('%s.%s.sql', [CurOwner, CurName]);
  SourceToFile(FileName, CurOwner, CurName, CurType);
  ShellExecute(Handle, 'open', PChar('"' + AppSettings.EditorPath + '"'), PChar('"' + FileName + '"'), nil, SW_SHOWNORMAL);
end;

procedure TMainForm.DoSaveItemsToDisk;
var
  i        : Integer;
  SelCount : Integer;
  ACursor  : TCursor;

  RowIdx   : Integer;
  RowInfo  : TcxRowInfo;

  AOwner   : string;
  AName    : string;
  AType    : string;
begin
  inherited;

  if not SelectSaveParams then
    Exit;

  with tvMain.DataController do begin
    BeginUpdate;

    SelCount  := SelectedCount;
    ACursor   := SetScreenCursor(crHourGlass);
    ShowProgressBar(Min(1, SelCount), SelCount);
    try
      for i := 0 to SelCount - 1 do begin
        Application.ProcessMessages;

        RowIdx  := GetSelectedRowIndex(i);
        RowInfo := GetRowInfo(RowIdx);

        if RowInfo.Level >= Groups.GroupingItemCount then begin
          AOwner := GetStrFieldValue(tvMain, 'owner', RowInfo.RecordIndex);
          AType  := GetStrFieldValue(tvMain, 'type',  RowInfo.RecordIndex);
          AName  := GetStrFieldValue(tvMain, 'name',  RowInfo.RecordIndex);

          try
            SaveSource(AOwner, AName, AType);
          except
            on E: Exception do begin
              MsgBox('Ошибка', 'Ошибка сохранения:'#13 + E.Message, MB_OK + MB_ICONERROR);
              Exit;
            end;
          end;

          with prbStPB do begin
            Position        := Position + 1;
            {
            Properties.Text := Format('%s.%s (%d%%)', [AOwner, AName, Trunc((i + 1) * 100 / SelCount)]);
            }
          end;
          with prbPB do begin
              Position        := Position + 1;
          end;
        end;
      end;
    finally
      HideProgressBar;
      SetScreenCursor(ACursor);

      EndUpdate;
    end;
  end;
end;

procedure TMainForm.SaveSource(const AOwner, AName, AType: string);

  function  CreateDir(const Name: string): Boolean;
  begin
    if DirectoryExists(Name)
      then Result := True
      else Result := ForceDirectories(Name);
  end;

var
  Current: string;
begin
  // Каталог
  with AppSettings.SaveOptions do begin
    Current := Dir;
    if CreateOwnerDir then
      Current := IncludeTrailingPathDelimiter(Current + AOwner);
    if CreateTypeDir then
      Current := IncludeTrailingPathDelimiter(Current + StringReplace(AType, #32, '_', [rfReplaceAll]));
  end;
  if not CreateDir(Current) then
    raise Exception.Create('Не получилось создать каталог'#13 + Current);
  // Имя файла
  with AppSettings.SaveOptions do begin
    if OwnerInFileName then
      Current := Current + AOwner + '.';
    Current := Current + AName;
    if TypeInFileName then
      Current := Current + '.' + StringReplace(AType, #32, '_', [rfReplaceAll]);
    Current := Current + '.' + Ext;
  end;

  SourceToFile(Current, AOwner, AName, AType);
end;

procedure TMainForm.SaveToRegistry(R: TRegistry);
var
  i: Integer;

  procedure SaveSourceParams;
  begin
    R.WriteString(S_SOURCE_AREA + '.' + S_FONT_NAME, mmoSource.Font.Name);
    R.WriteInteger(S_SOURCE_AREA + '.' + S_FONT_SIZE, mmoSource.Font.Size);
    R.WriteBool(S_SOURCE_AREA + '.' + S_LINE_NUMBERS, mmoSource.Gutter.ShowLineNumbers);
    R.WriteInteger(S_SOURCE_AREA + '.' + S_COLOR, mmoSource.Color);
    hlSQL.SaveToRegistry(R.RootKey, IncludeTrailingBackslash(R.CurrentPath) + S_SQL_SYNTAX);
  end;

begin
  inherited;

  with cbxText.Properties do
    while Items.Count > MAX_TEXT_ITEMS do
      Items.Delete(Items.Count - 1);

  SaveComboBox(R, cbxText);
  R.WriteString(S_OWNER, cbxOwner.Text);

  R.WriteBool(S_OBJECTS_TYPES + '.' + S_FUNCTION, chbFunctions.Checked);
  R.WriteBool(S_OBJECTS_TYPES + '.' + S_PROCEDURE, chbProcedures.Checked);
  R.WriteBool(S_OBJECTS_TYPES + '.' + S_TRIGGER, chbTriggers.Checked);
  R.WriteBool(S_OBJECTS_TYPES + '.' + S_PACKAGE, chbPackages.Checked);
  R.WriteBool(S_OBJECTS_TYPES + '.' + S_TYPE, chbTypes.Checked);
  R.WriteBool(S_OBJECTS_TYPES + '.' + S_JAVA_SOURCE, chbJavaSources.Checked);

  R.WriteInteger(S_GRID_WIDTH, pnlGrid.Width);

  with tvMain do
    for i := 0 to ColumnCount - 1 do begin
      R.WriteInteger(Columns[i].Name + '.' + S_WIDTH, Columns[i].Width);
      R.WriteInteger(Columns[i].Name + '.' + S_INDEX, Columns[i].Index);
    end;

  R.WriteString(S_EDITOR_PATH, AppSettings.EditorPath);
  SaveSourceParams;
end;

procedure TMainForm.LoadFromRegistry(R: TRegistry);
var
  i: Integer;

  procedure LoadMemo(Memo: TSynMemo);
  begin
    Memo.Font.Name              := R.ReadString(S_SOURCE_AREA + '.' + S_FONT_NAME, Memo.Font.Name);
    Memo.Font.Size              := R.ReadInteger(S_SOURCE_AREA + '.' + S_FONT_SIZE, Memo.Font.Size);
    Memo.Gutter.ShowLineNumbers := R.ReadBool(S_SOURCE_AREA + '.' + S_LINE_NUMBERS, Memo.Gutter.ShowLineNumbers);
    Memo.Color                  := R.ReadInteger(S_SOURCE_AREA + '.' + S_COLOR, Memo.Color);
  end;

  procedure LoadSourceParams;
  begin
    LoadMemo(mmoSource);
    LoadMemo(mmoSpec);
    LoadMemo(mmoBody);

    hlSQL.LoadFromRegistry(R.RootKey, IncludeTrailingBackslash(R.CurrentPath) + S_SQL_SYNTAX);
    hlSQL.PLSQLAttri.AssignColorAndStyle(hlSQL.KeyAttri);
    hlSQL.SQLPlusAttri.AssignColorAndStyle(hlSQL.KeyAttri);
    hlSQL.SymbolAttri.AssignColorAndStyle(hlSQL.IdentifierAttri);
  end;

begin
  inherited;
  LoadComboBox(R, cbxText);

  chbFunctions.Checked   := R.ReadBool(S_OBJECTS_TYPES + '.' + S_FUNCTION, chbFunctions.Checked);
  chbProcedures.Checked  := R.ReadBool(S_OBJECTS_TYPES + '.' + S_PROCEDURE, chbProcedures.Checked);
  chbTriggers.Checked    := R.ReadBool(S_OBJECTS_TYPES + '.' + S_TRIGGER, chbTriggers.Checked);
  chbPackages.Checked    := R.ReadBool(S_OBJECTS_TYPES + '.' + S_PACKAGE, chbPackages.Checked);
  chbTypes.Checked       := R.ReadBool(S_OBJECTS_TYPES + '.' + S_TYPE, chbTypes.Checked);
  chbJavaSources.Checked := R.ReadBool(S_OBJECTS_TYPES + '.' + S_JAVA_SOURCE, chbJavaSources.Checked);

  pnlGrid.Width := R.ReadInteger(S_GRID_WIDTH, pnlGrid.Width);

  with tvMain do
    for i := 0 to ColumnCount - 1 do begin
      Columns[i].Width := R.ReadInteger(Columns[i].Name + '.' + S_WIDTH, Columns[i].Width);
      Columns[i].Index := R.ReadInteger(Columns[i].Name + ',' + S_INDEX, Columns[i].Index);
    end;

  AppSettings.EditorPath := R.ReadString(S_EDITOR_PATH, AppSettings.EditorPath);
  LoadSourceParams;
end;

procedure TMainForm.MemoPaint(Sender: TObject; Canvas: TCanvas; TransientType: TTransientType);
var
  Memo      : TSynMemo;
  Key, S, T : string;
  i, k      : Integer;
  dc        : TDisplayCoord;
  p         : TPoint;
  R         : TRect;
begin
  if not (Sender is TSynMemo)
    then Exit
    else Memo := Sender as TSynMemo;
  if Trim(FTextForSearch) = ''
    then Exit
    else Key  := LowerCase(FTextForSearch);

  for i := Memo.TopLine to Memo.TopLine + Memo.LinesInWindow do begin
    S := Memo.Lines[i - 1];
    k := Pos(Key, LowerCase(S));
    while k <> 0 do begin
      dc := Memo.BufferToDisplayPos(BufferCoord(k, i));
      p  := Memo.RowColumnToPixels(dc);
      T  := Copy(S, k, Length(Key));
      k  := Pos(Key, LowerCase(S), k + Length(Key));

      with Memo.Canvas do begin
        {
        Brush.Color := Memo.Color;
        Font.Color  := hlSQL.IdentifierAttri.Foreground;
        }
        Brush.Color := clYellow;
        Font.Color  := clRed;
        Pen.Color   := hlSQL.IdentifierAttri.Foreground;

        R.Left      := p.X - 2;
        R.Top       := p.Y - 1;
        R.Right     := p.X + TextWidth(T)  + 2;
        R.Bottom    := p.Y + TextHeight(T) + 1;

        Rectangle(R);
        TextOut(p.X, p.Y, T);
      end;
    end;
  end;
end;

function TMainForm.SetScreenCursor(ACursor: TCursor): TCursor;
begin
  Result        := Screen.Cursor;
  Screen.Cursor := ACursor;
end;

procedure TMainForm.qryMainAfterOpen(DataSet: TDataSet);
begin
  inherited;

  if qryMain.RecordCount > 0
    then StatusBar.Panels[SB_RECORDS_INFO].Text := Format('Найдено: %d', [qryMain.FieldByName('rec_count').AsInteger])
    else StatusBar.Panels[SB_RECORDS_INFO].Text := 'Не найдено';
end;

procedure TMainForm.ShowProgressBar(AMin, AMax: Integer);
begin
  pnlProgressBar.Visible           := False;
  StatusBar.Panels[SB_PRB].Visible := False;

  with prbStPB do begin
    Properties.Min  := AMin;
    Properties.Max  := AMax;
    Position        := Properties.Min;
  end;

  with prbPB do begin
    Properties.Min  := AMin;
    Properties.Max  := AMax;
    Position        := Properties.Min;
  end;
  {
  StatusBar.Panels[SB_PRB].Visible := True;
  }
  pnlProgressBar.Visible           := True;
end;

procedure TMainForm.ShowSource(const AOwner, AName, AType: string);

  procedure SetTopLine(Memo: TSynMemo);
  var
    i, f: Integer;
  begin
    i := 0;
    f := -1;
    while (i < Memo.Lines.Count) and (f = -1) do
      if Pos(LowerCase(FTextForSearch), LowerCase(Memo.Lines[i])) <> 0
        then f := i
        else i := i + 1;

    if f <> -1 then
      Memo.TopLine := Min(f + 1, Memo.Lines.Count);
  end;

var
  Memo : TSynMemo;
begin
  pgcPackage.Visible := (AType = S_PACKAGE) or (AType = S_TYPE);
  mmoSource.Visible  := not pgcPackage.Visible;

  mmoSource.Clear;
  mmoSpec.Clear;
  mmoBody.Clear;

  if (AType = S_PACKAGE) or (AType = S_TYPE)
    then Memo := mmoSpec
    else Memo := mmoSource;

  SourceToStrings(AOwner, AName, AType, Memo.Lines);
  SetTopLine(Memo);
  if (AType = S_PACKAGE) or (AType = S_TYPE) then begin
    SourceToStrings(AOwner, AName, AType + ' BODY', mmoBody.Lines);
    SetTopLine(mmoBody);

    pgcPackage.ActivePageIndex := 0;

    if mmoBody.Lines.Count = 0 then begin
      mmoSource.Lines.Clear;
      mmoSource.Lines.AddStrings(mmoSpec.Lines);

      pgcPackage.Visible := False;
      mmoSource.Visible  := True;
    end;
  end;
end;

procedure TMainForm.SourceToFile(const FileName: string; const AOwner, AName, AType: string);

  procedure PreprocessLines(L: TStrings);
  var
    i: Integer;
  begin
    for i := 0 to L.Count - 1 do
      if Copy(L[i], Length(L[i]), 1) = #$A then
        L[i] := Copy(L[i], 1, Length(L[i]) - 1);
  end;

var
  Lines: TStrings;
begin
  Lines := TStringList.Create;
  try
    SourceToStrings(AOwner, AName, AType, Lines);
    if (AType = S_PACKAGE) or (AType = S_TYPE) then begin
      Lines.Add('/');
      SourceToStrings(AOwner, AName, AType + ' BODY', Lines, False);
    end;
    PreprocessLines(Lines);
    Lines.SaveToFile(FileName);
  finally
    FreeAndNil(Lines);
  end;
end;

procedure TMainForm.SourceToStrings(const AOwner, AName, AType: string; Lines: TStrings; ClearLines: Boolean);
var
  S: string;
  i: Integer;
begin
  if not Assigned(Lines) then
    Exit;

  if ClearLines then
    Lines.Clear;
  with qrySource do begin
    Close;
    Params.ClearValues();
    Params.ParamByName('owner').AsString := AOwner;
    Params.ParamByName('name').AsString  := AName;
    Params.ParamByName('type').AsString  := AType;
    try
      try
        Open;
        First;
        i := 0;
        while not EOF do begin
          S :=  FieldByName('text').AsString;
          if (pos(S_WRAPPED, UpperCase(S)) > 0) and (i = 0) then begin
            Lines.Add(S_WRAPPED);
            Break;
          end;

          Lines.Add(S);
          i := i + 1;
          Next;
        end;
      except
      end;
    finally
      Close;
    end;
  end;
end;

procedure TMainForm.TextToDropDownList(const Text: string);
var
  i: Integer;
begin
  with cbxText.Properties do begin
    i := Items.IndexOf(Text);
    if i <> -1 then
      Items.Delete(i);

    Items.Insert(0, Text);
    cbxText.ItemIndex := 0;
  end;
end;

function TMainForm.TryToConnect: Boolean;
var
  F: TLoginForm;
begin
  F := TLoginForm.Create(Application);
  try
    Result := F.ShowModal = mrOk;
  finally
    FreeAndNil(F);
  end;
end;

function TMainForm.GetOwnerName: string;
begin
  Result := Trim(cbxOwner.Text);
end;

function TMainForm.GetText: string;
begin
  Result := cbxText.Text;
end;

function TMainForm.GetRecordCount: Integer;
begin
  if qryMain.Active and (qryMain.RecordCount > 0)
    then Result := qryMain.FieldByName('rec_count').AsInteger
    else Result := 0;
end;

function TMainForm.GetSelectedCount: Integer;
begin
  Result := tvMain.DataController.GetSelectedCount;
end;

function TMainForm.GetCurName: string;
begin
  if qryMain.Active and (qryMain.RecordCount > 0)
    then Result := qryMain.FieldByName('name').AsString
    else Result := '';
end;

function TMainForm.GetCurOwner: string;
begin
  if qryMain.Active and (qryMain.RecordCount > 0)
    then Result := qryMain.FieldByName('owner').AsString
    else Result := '';
end;

function TMainForm.GetCurType: string;
begin
  if qryMain.Active and (qryMain.RecordCount > 0)
    then Result := qryMain.FieldByName('type').AsString
    else Result := '';
end;

function TMainForm.GetCurTypeID: Integer;
begin
  if qryMain.Active and (qryMain.RecordCount > 0)
    then Result := qryMain.FieldByName('type_id').AsInteger
    else Result := 0;
end;

end.
