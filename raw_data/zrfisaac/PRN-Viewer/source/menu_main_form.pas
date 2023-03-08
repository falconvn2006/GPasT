// # [ about ]
// # - author : Isaac Caires
// # . - email : zrfisaac@gmail.com
// # . - site : https://sites.google.com/view/zrfisaac-en

// # [ lazarus ]
unit menu_main_form;

{$mode objfpc}
{$H+}

interface

// # - library
uses
  // # : - lazarus
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  Menus,
  ComCtrls,
  LCLTranslator,
  // # : ./source/*
  model_base_form;

type

  { TMenuMainForm }

  TMenuMainForm = class(TModelBaseForm)
    imBack: TImage;
    miPrn: TMenuItem;
    miAbout: TMenuItem;
    miConfig: TMenuItem;
    miHelp: TMenuItem;
    miMenu: TMainMenu;
    sbStatus: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miConfigClick(Sender: TObject);
    procedure miPrnClick(Sender: TObject);
  public
    // # : - attribute
    pnMenu: TPanel;

    // # : - method
    procedure fnMenu(_pClass: TComponentClass; var _pReference; _pMenu: TMenuItem); overload;
    procedure fnMenu(_pClass: TComponentClass; var _pReference; _pMenu: TObject); overload;
  end;

var
  MenuMainForm: TMenuMainForm;

implementation

// # - library
uses
  splash_form,
  model_routine_form,
  menu_about_form,
  menu_config_form,
  menu_main_data,
  menu_prn_form;

{$R *.lfm}

{ TMenuMainForm }

procedure TMenuMainForm.FormCreate(Sender: TObject);
begin
  // # : - variable
  if (MenuMainForm = Nil) then
    MenuMainForm := Self;

  // # : - inheritance
  inherited;

  // # : - title
  Self.Caption := Application.Title;
end;

procedure TMenuMainForm.FormShow(Sender: TObject);
var
  _vI0: Integer;
  _vS0: String;
begin
  // # : - mode
  {$IFOPT D+}
  Application.Title := Application.Title + ' ' + '[DEBUG]';
  {$ELSE}
    {$IFDEF CPU386}
    Application.Title := Application.Title + ' ' + 'x32';
    {$ENDIF}
    {$IFDEF CPUX86_64}
    Application.Title := Application.Title + ' ' + 'x64';
    {$ENDIF}
  {$ENDIF}

  // # : - variable
  if (MenuMainForm = Nil) then
    MenuMainForm := Self;

  // # : - inheritance
  inherited;

  // # : - title
  Self.Caption := Application.Title;

  // # : - data
  if (MenuMainData = Nil) then
    TMenuMainData.Create(Application);

  // # : - config
  if (MenuConfigForm = Nil) then
    TMenuConfigForm.Create(Application);

  // # : - splash
  if (MenuConfigForm.ckMain_Splash.Checked) then
  begin
    if not(ParamCount > 0) then
    begin
      if (SplashForm = Nil) then
        SplashForm := TSplashForm.Create(Application);
      SplashForm.ShowModal;
      SplashForm := Nil;
    end;
  end;

  // # : - screen
  MenuConfigForm.fnScreen;
  Self.fnMenu(TMenuPrnForm, MenuPrnForm, Sender);

  // # : - parameter
  for _vI0 := 1 to ParamCount do
  begin
    if (ExtractFilePath(ParamStr(_vI0)) = '') then
      _vS0 := GetCurrentDir+'\'+ParamStr(_vI0)
    else
      _vS0 := ParamStr(_vI0);
    if (FileExists(_vS0)) then
    begin
      MenuPrnForm.cklbFile.Items.Add(_vS0);
      MenuPrnForm.cklbFile.Checked[MenuPrnForm.cklbFile.Items.Count - 1] := True;
    end;
  end;
  if (ParamCount > 0) then
  begin
    MenuPrnForm.fnFile_View;
    Application.Terminate;
  end;
end;

procedure TMenuMainForm.miAboutClick(Sender: TObject);
begin
  // # : - routine
  Self.fnMenu(TMenuAboutForm, MenuAboutForm, Sender);
end;

procedure TMenuMainForm.miConfigClick(Sender: TObject);
begin
  // # : - routine
  Self.fnMenu(TMenuConfigForm, MenuConfigForm, Sender);
end;

procedure TMenuMainForm.miPrnClick(Sender: TObject);
begin
  // # : - routine
  Self.fnMenu(TMenuPrnForm, MenuPrnForm, Sender);
end;

procedure TMenuMainForm.fnMenu(_pClass: TComponentClass; var _pReference; _pMenu: TMenuItem);
begin
  // # : - routine
  if (TModelRoutineForm(_pReference) = Nil) then
  begin
    TModelRoutineForm(_pReference) := TModelRoutineForm(_pClass.NewInstance);
    TModelRoutineForm(_pReference).Create(Self);
  end;
  if not(Self.pnMenu = Nil) then
    Self.pnMenu.Parent := TWinControl(Self.pnMenu.Owner);
  Self.pnMenu := TModelRoutineForm(_pReference).pnBack;
  Self.pnMenu.Parent := Self.pnBack;
  TModelRoutineForm(_pReference).pnTitle.Caption := TModelRoutineForm(_pReference).Caption;
end;

procedure TMenuMainForm.fnMenu(_pClass: TComponentClass; var _pReference; _pMenu: TObject);
begin
  // # : - routine
  Self.fnMenu(_pClass, _pReference, TMenuItem(_pMenu));
end;

end.

