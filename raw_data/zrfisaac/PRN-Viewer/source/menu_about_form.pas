// # [ about ]
// # - author : Isaac Caires
// # . - email : zrfisaac@gmail.com
// # . - site : https://sites.google.com/view/zrfisaac-en

// # [ lazarus ]
unit menu_about_form;

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
  model_routine_form;

type

  { TMenuAboutForm }

  TMenuAboutForm = class(TModelRoutineForm)
    btAbout_Close: TBitBtn;
    lbAbout_Page: TLabel;
    edAbout_Name: TEdit;
    edAbout_Email: TEdit;
    imAbout_Logo: TImage;
    edAbout_Page: TEdit;
    lbAbout_Name: TLabel;
    lbAbout_Email: TLabel;
    meLicense_En: TMemo;
    meVersion: TMemo;
    meLicense_Pt: TMemo;
    pnAbout_Author01: TPanel;
    pnAbout_Author: TPanel;
    pnAbout_Logo: TPanel;
    pnAbout_Footer01: TPanel;
    pnAbout_Footer02: TPanel;
    pnAbout_Footer03: TPanel;
    pnAbout_Footer: TPanel;
    sbAbout: TScrollBox;
    tsVersion: TTabSheet;
    tsLicense: TTabSheet;
    tsAbout: TTabSheet;
    procedure FormCreate(Sender: TObject);
  public
    procedure fnScreen;
  end;

var
  MenuAboutForm: TMenuAboutForm;

implementation

uses
  menu_config_form;

{$R *.lfm}

{ TMenuAboutForm }

procedure TMenuAboutForm.FormCreate(Sender: TObject);
begin
  // # : - inheritance
  inherited;

  // # : - screen
  Self.fnScreen;
end;

procedure TMenuAboutForm.fnScreen;
begin
  // # : - license
  Self.meLicense_En.Visible := False;
  Self.meLicense_En.Align := alClient;
  Self.meLicense_Pt.Visible := False;
  Self.meLicense_Pt.Align := alClient;
  Self.meVersion.Visible := True;
  Self.meVersion.Align := alClient;
  if (MenuConfigForm = Nil) then
    TMenuConfigForm.Create(Application);
  case MenuConfigForm.cbMain_Lang.ItemIndex of
    0:
    begin
      Self.meLicense_En.Visible := True;
    end;
    1:
    begin
      Self.meLicense_Pt.Visible := True;
    end;
  end;
end;

end.

