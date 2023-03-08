unit fmBase;

{$INCLUDE XCompilerOptions.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.Registry, XHelpers, dmMain, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue,
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
  dxSkinXmas2008Blue, cxCheckGroup, cxCheckBox, cxGridTableView, cxGridDBTableView, cxGrid;

const
  MY_APP_REGISTRY_KEY = 'SOFTWARE\MyApplications\';

type
  TBaseForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure DefLabelOnClick(Sender: TObject);

    function  GetRegistryKey: String; virtual;
    function  GetDM: TMainDataModule;
  protected
    function  GetAppName: String;
    function  GetStrFieldValue(TableView: TcxGridDBTableView; const FieldName: String; RecIndex: Integer = -1): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    procedure InitForm; virtual;
    procedure SetupLabelBehavior(Component: TComponent);

    procedure SaveFormParams;
    procedure LoadFormParams;

    procedure SaveToRegistry(R: TRegistry); virtual;
    procedure LoadFromRegistry(R: TRegistry); virtual;
    procedure LoadFromRegistryError(E: Exception); virtual;

    property  DM: TMainDataModule read GetDM;
    property  RegistryKey: String read GetRegistryKey;
  end;

implementation

{$R *.dfm}

uses
  XUtils;

constructor TBaseForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitForm;
end;

destructor TBaseForm.Destroy;
begin
  inherited;
end;

procedure TBaseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormParams;
  inherited;
end;

procedure TBaseForm.FormCreate(Sender: TObject);
begin
  inherited;
  LoadFormParams;
end;

procedure TBaseForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F1) and (ssCtrl in Shift) and (ssShift in Shift) then begin
    ShowFormInfo(Self);
    Key := 0;
  end;
end;

function TBaseForm.GetAppName: String;
begin
  Result := StringReplace(ExtractFileName(Application.ExeName), ExtractFileExt(Application.ExeName), '', [rfReplaceAll]);
end;

function TBaseForm.GetDM: TMainDataModule;
begin
  Result := MainDataModule;
end;

function TBaseForm.GetRegistryKey: String;
begin
  Result := MY_APP_REGISTRY_KEY + GetAppName + '\' + Self.Name;
end;

function TBaseForm.GetStrFieldValue(TableView: TcxGridDBTableView; const FieldName: String; RecIndex: Integer): String;
begin
  with TableView.DataController do
    if RecordCount > 0 then begin
      if RecIndex = -1 then
        RecIndex := GetFocusedRecordIndex;
      Result := VarToStr(Values[RecIndex, TableView.GetColumnByFieldName(FieldName).Index]);
    end else
      Result := '';
end;

procedure TBaseForm.InitForm;
begin
  EnumComponents(SetupLabelBehavior);
end;

procedure TBaseForm.SetupLabelBehavior(Component: TComponent);
begin
  if Component is TLabel then
    with TLabel(Component) do begin
      Transparent := True;
      if Assigned(TLabel(Component).FocusControl) and (not Assigned(TLabel(Component).OnClick)) then begin
        Cursor  := crHandPoint;
        OnClick := DefLabelOnClick;
      end;
    end;

  if Component is TcxCheckBox then
    with TcxCheckBox(Component) do begin
      Transparent := True;
    end;
end;

procedure TBaseForm.DefLabelOnClick(Sender: TObject);
begin
  if (Sender is TLabel) then
    if Assigned(TLabel(Sender).FocusControl) and TLabel(Sender).FocusControl.CanFocus then
      TLabel(Sender).FocusControl.SetFocus;
end;

procedure TBaseForm.SaveFormParams;
var
  R: TRegistry;
begin
  R := TRegistry.Create;
  try
    R.RootKey := HKEY_CURRENT_USER;
    if R.OpenKey(RegistryKey, True) then
      SaveToRegistry(R);
  finally
    FreeAndNil(R);
  end;
end;

procedure TBaseForm.LoadFormParams;
var
  R: TRegistry;
begin
  R := TRegistry.Create;
  try
    R.RootKey := HKEY_CURRENT_USER;
    if R.OpenKeyReadOnly(RegistryKey) then
      try
        LoadFromRegistry(R);
      except
        on E: Exception do
          LoadFromRegistryError(E);
      end;
  finally
    FreeAndNil(R);
  end;
end;

procedure TBaseForm.SaveToRegistry(R: TRegistry);
begin
  R.WriteInteger('Left', Left);
  R.WriteInteger('Top', Top);
  if BorderStyle <> bsDialog then begin
    R.WriteInteger('Width', Width);
    R.WriteInteger('Height', Height);

    R.WriteInteger('State', Ord(WindowState));
  end;
end;

procedure TBaseForm.LoadFromRegistry(R: TRegistry);
begin
  Left := R.ReadInteger('Left', Left);
  Top  := R.ReadInteger('Top', Top);
  if BorderStyle <> bsDialog then begin
    Width  := R.ReadInteger('Width', Width);
    Height := R.ReadInteger('Height', Height);

    WindowState := TWindowState(R.ReadInteger('State', 0));
  end;
end;

procedure TBaseForm.LoadFromRegistryError(E: Exception);
begin
  { ... }
end;

end.
