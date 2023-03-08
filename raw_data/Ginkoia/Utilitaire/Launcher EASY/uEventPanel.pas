unit uEventPanel;

interface

uses Windows, Classes, SysUtils, Controls, StdCtrls, ExtCtrls, Graphics,
  uLog, Menus, Vcl.Dialogs;

type
  TMenuServiceAction = (MenuServiceStop, MenuServiceStart, MenuServiceRestart);
  TMenuExeAction = (MenuExeStop, MenuExeStart);

  TEventPanel = class(TCustomPanel)
  private
    lbTitle: TLabel;
    lbDetail: TLabel;
    imgIcon: TImage;

    FTitle: string;
    FID: string;
    FLevel: TLogLevel;
    FExeName: string;
    FDetail: string;
    FServiceName: string;
    FPasswordProtected: Boolean;
    FExeParams: string;
    FInfoValue1: string;
    FInfoValue2: string;
    FPopMenu: TPopupMenu;

    procedure SetTitle(const Value: string);
    procedure SetLevel(const Value: TLogLevel);
    // procedure SetIcon(const Value: TBitMap);
    function GetIcon: TIcon;
    function GetImage: TImage;
    function GetLblTitle: TLabel;
    function GetLblDetail: TLabel;

    procedure setDetail(const Value: string);
    procedure setInfoValue1(const Value: string);
    procedure setInfoValue2(const Value: string);
    procedure MenuServiceClick(Sender: TObject);
    procedure MenuExeClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetPopMenu(aServiceName: string; askPassword: Boolean = true);
    procedure SetPopMenuExe(aExeName: string; params: string = '');
  published
    property ID: string read FID write FID;
    property Title: string read FTitle write SetTitle;
    property LblTitle: TLabel read GetLblTitle;
    property LblDetail: TLabel read GetLblDetail;
    property PasswordProtected: Boolean read FPasswordProtected write FPasswordProtected;
    property InfoValue1: string read FInfoValue1 write setInfoValue1; // utilisé pour remonter une info au Main
    property InfoValue2: string read FInfoValue2 write setInfoValue2; // utilisé pour remonter une autre info au Main
    property ServiceName: string read FServiceName write FServiceName;
    property ExeName: string read FExeName write FExeName;
    property ExeParams: string read FExeParams write FExeParams;
    property Detail: string read FDetail write setDetail;
    property Icon: TIcon read GetIcon;
    property Image: TImage read GetImage;
    property Level: TLogLevel read FLevel write SetLevel;
    property PopMenu: TPopupMenu read FPopMenu write FPopMenu;
    property Align;
  end;

implementation

uses
  ServiceControler, ExeControler, uMainForm, uPasswordManager;

// ==============================================================================
{ TEventPanel }
// ==============================================================================
constructor TEventPanel.Create(AOwner: TComponent);
begin
  inherited;

  Width := 100;
  Height := 100;
  Padding.Left := 5;
  Padding.Right := 5;
  Padding.Top := 5;
  Padding.Bottom := 5;

  PopupMenu := nil;

  Margins.Right := 5;
  AlignWithMargins := true;

  BevelOuter := bvNone;
  ParentColor := false;
  ParentBackground := false;

  lbTitle := TLabel.Create(Self);
  lbTitle.Align := alBottom;
  lbTitle.Color := clWhite;
  lbTitle.Font.Name := 'Arial';
  lbTitle.Font.Size := 8;
  lbTitle.Font.Style := [fsBold];
  lbTitle.Alignment := taCenter;
  lbTitle.Font.Color := clWhite;
  lbTitle.ParentColor := true;
  lbTitle.Transparent := true;
  lbTitle.Parent := Self;

  lbDetail := TLabel.Create(Self);
  lbDetail.Align := alBottom;
  lbDetail.Color := clWhite;
  lbDetail.Font.Name := 'Arial';
  lbDetail.Font.Size := 7;
  lbDetail.Font.Style := [];
  lbDetail.Alignment := taCenter;
  lbDetail.Font.Color := clWhite;
  lbDetail.ParentColor := true;
  lbDetail.Transparent := true;
  lbDetail.Parent := Self;

  imgIcon := TImage.Create(Self);
  imgIcon.Top := 15;
  imgIcon.Left := 34;
  imgIcon.Width := 32;
  imgIcon.Height := 32;
  imgIcon.Parent := Self;
  imgIcon.Transparent := true;

  SetTitle('');
  setDetail('');
  setInfoValue1('');
  setInfoValue2('');
  SetLevel(logNone);
end;

// ------------------------------------------------------------------------------
destructor TEventPanel.Destroy;
begin
  lbTitle.Free;

  inherited;
end;

function TEventPanel.GetIcon: TIcon;
begin
  Result := imgIcon.Picture.Icon;
end;

function TEventPanel.GetImage: TImage;
begin
  Result := imgIcon;
end;

function TEventPanel.GetLblTitle: TLabel;
begin
  Result := lbTitle;
end;

function TEventPanel.GetLblDetail: TLabel;
begin
  Result := lbDetail;
end;

procedure TEventPanel.setInfoValue1(const Value: string);
begin
  FInfoValue1 := Value;
end;

procedure TEventPanel.setInfoValue2(const Value: string);
begin
  FInfoValue2 := Value;
end;

procedure TEventPanel.setDetail(const Value: string);
begin
  FDetail := Value;

  lbDetail.Visible := (FDetail <> '');
  lbDetail.Caption := FDetail;
  lbDetail.Top := Height - lbDetail.Height;
end;

// procedure TEventPanel.SetIcon(const Value: TBitMap);
// begin
// end;

procedure TEventPanel.SetLevel(const Value: TLogLevel);
begin
  FLevel := Value;
  Color := LogLevelColor[Ord(FLevel)];
end;

procedure TEventPanel.SetTitle(const Value: string);
begin
  FTitle := Value;
  lbTitle.Caption := FTitle;
end;

// *****************************************
// ***** POPUP menu pour les services ******
// *****************************************
procedure TEventPanel.SetPopMenu(aServiceName: string; askPassword: Boolean = true);
var
  aPopupMenu: TPopupMenu;
  ItemMenu: TMenuItem;
  i: integer;
begin
  ServiceName := aServiceName;
  PasswordProtected := askPassword;

  aPopupMenu := TPopupMenu.Create(Self);

  ItemMenu := TMenuItem.Create(aPopupMenu);
  ItemMenu.Caption := 'Arrêt du service';
  ItemMenu.Tag := 0;
  // ItemMenu.OnClick := MenuServiceClick;
  aPopupMenu.Items.Add(ItemMenu);

  ItemMenu := TMenuItem.Create(aPopupMenu);
  ItemMenu.Caption := 'Démarrage du service';
  ItemMenu.Tag := 1;
  aPopupMenu.Items.Add(ItemMenu);

  ItemMenu := TMenuItem.Create(aPopupMenu);
  ItemMenu.Caption := 'Redémarrage du service';
  ItemMenu.Tag := 2;
  aPopupMenu.Items.Add(ItemMenu);

  Self.PopupMenu := aPopupMenu;
  PopMenu := aPopupMenu;

  for i := 0 to PopupMenu.Items.Count - 1 do
  begin
    PopMenu.Items[i].OnClick := MenuServiceClick;
  end;
end;

procedure TEventPanel.MenuServiceClick(Sender: TObject);
var
  resultActionService, passCorrect: Boolean;
  password: string;
  TypeMenuClicked: TMenuServiceAction;
  test: AnsiString;
  retourPassword: TPasswordValidation;
begin
  passCorrect := true;
  TypeMenuClicked := TMenuServiceAction(TMenuItem(Sender).Tag);

  if (Self.PasswordProtected) and ((TypeMenuClicked = MenuServiceStop) OR (TypeMenuClicked = MenuServiceRestart)) then
  begin
    password := InputBox('Service Easy', #31'Mot de passe : ', '');

    PasswordManager.PasswordName := 'GestionServices';

    retourPassword := PasswordManager.ComparePassword(password);

    // si le fichier de mot de passe, ou la clé du mot de passe n'existe pas, on prend chamonix par défaut
    if (retourPassword = fileNotExist) or (retourPassword = PasswordNotExist) then
    begin
      if password <> 'ch@mon1x' then
        passCorrect := false;
    end
    else if retourPassword <> PassOk then
      passCorrect := false;

  end;

  if passCorrect then
  begin
    if (TypeMenuClicked = MenuServiceStop) then
    begin
      resultActionService := ServiceStop('', ServiceName);
    end;

    if (TypeMenuClicked = MenuServiceStart) then
    begin
      resultActionService := ServiceStart('', ServiceName);
    end;

    if (TypeMenuClicked = MenuServiceRestart) then
    begin
      resultActionService := ServiceRestart('', ServiceName);
    end;
  end;

  Frm_Launcher.tmWMITimer(Self);
end;

// *****************************************
// ***** POPUP menu pour les Exes **********
// *****************************************
procedure TEventPanel.SetPopMenuExe(aExeName: string; params: string = '');
var
  aPopupMenu: TPopupMenu;
  ItemMenu: TMenuItem;
  i: integer;
begin
  ExeName := aExeName;
  ExeParams := params;

  aPopupMenu := TPopupMenu.Create(Self);

  ItemMenu := TMenuItem.Create(aPopupMenu);
  ItemMenu.Caption := 'Arrêt du programme';
  ItemMenu.Tag := 0;
  // ItemMenu.OnClick := MenuServiceClick;
  aPopupMenu.Items.Add(ItemMenu);

  ItemMenu := TMenuItem.Create(aPopupMenu);
  ItemMenu.Caption := 'Démarrage du programme';
  ItemMenu.Tag := 1;
  aPopupMenu.Items.Add(ItemMenu);

  Self.PopupMenu := aPopupMenu;
  PopMenu := aPopupMenu;

  for i := 0 to PopupMenu.Items.Count - 1 do
  begin
    PopMenu.Items[i].OnClick := MenuExeClick;
  end;
end;


procedure TEventPanel.MenuExeClick(Sender: TObject);
var
  resultActionExe: Boolean;
begin
  if (TMenuExeAction(TMenuItem(Sender).Tag) = MenuExeStart) then
  begin
    resultActionExe := ExeStart(ExeName, ExeParams);
  end;

  if (TMenuExeAction(TMenuItem(Sender).Tag) = MenuExeStop) then
  begin
    resultActionExe := ExeStop(ExeName);
  end;

  Frm_Launcher.tmWMITimer(Self);
end;





// ==============================================================================
end.
