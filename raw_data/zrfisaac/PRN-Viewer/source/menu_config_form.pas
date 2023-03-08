//# [ about ]
//# - author : Isaac Caires
//# . - email : zrfisaac@gmail.com
//# . - site : https://zrfisaac.github.io

//# [ lazarus ]
unit menu_config_form;

{$mode objfpc}
{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  ComCtrls,
  Buttons,
  StdCtrls,
  LCLTranslator,
  model_routine_form;

type

  { TMenuConfigForm }

  TMenuConfigForm = class(TModelRoutineForm)
    btMain_Close: TBitBtn;
    cbMain_Lang: TComboBox;
    ckMain_Splash: TCheckBox;
    lbMain_Lang: TLabel;
    pnMain_Footer: TPanel;
    pnMain_Footer01: TPanel;
    pnMain_Footer02: TPanel;
    pnMain_Footer03: TPanel;
    pnMain_Lang: TPanel;
    pnMain_Base: TPanel;
    sbMain: TScrollBox;
    tsMain: TTabSheet;
    procedure cbMain_LangChange(Sender: TObject);
    procedure ckMain_SplashChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure fnScreen;
  end;

var
  MenuConfigForm: TMenuConfigForm;

implementation

uses
  menu_about_form,
  menu_main_form,
  menu_main_data;

{$R *.lfm}

{ TMenuConfigForm }

procedure TMenuConfigForm.cbMain_LangChange(Sender: TObject);
begin
  // # : - routine
  MenuMainData.fnMain_Write;
  Self.fnScreen;
  if not(MenuAboutForm = Nil) then
    MenuAboutForm.fnScreen;
  Self.Caption := Application.Title;
end;

procedure TMenuConfigForm.ckMain_SplashChange(Sender: TObject);
begin
  // # : - routine
  MenuMainData.fnMain_Write;
end;

procedure TMenuConfigForm.FormCreate(Sender: TObject);
begin
  // # : - variable
  if (MenuConfigForm = Nil) then
    MenuConfigForm := Self;

  // # : - inheritance
  inherited;

  // # : - data
  if (MenuMainData = Nil) then
    MenuMainData := TMenuMainData.Create(Application);

  // # : - screen
  Self.fnScreen;
end;

procedure TMenuConfigForm.fnScreen;
begin
  // # : - routine
  if (Self.cbMain_Lang.ItemIndex = 0) then
    SetDefaultLang('en');
  if (Self.cbMain_Lang.ItemIndex = 1) then
    SetDefaultLang('pt');
  Self.pnTitle.Caption := Self.Caption;
  MenuMainData.fnMain_Write;
end;

end.

