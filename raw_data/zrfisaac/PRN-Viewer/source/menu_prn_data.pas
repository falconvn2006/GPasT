// # [ about ]
// # - author : Isaac Caires
// # . - email : zrfisaac@gmail.com
// # . - site : https://sites.google.com/view/zrfisaac-en

// # [ lazarus ]
unit menu_prn_data;

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
  ExtDlgs, Menus,
  model_routine_data;

type

  { TMenuPrnData }

  TMenuPrnData = class(TModelRoutineData)
    dgFile_En: TOpenDialog;
    dgFile_Pt: TOpenDialog;
    miFile_Add: TMenuItem;
    miFile_Delete: TMenuItem;
    MenuItem2: TMenuItem;
    miFile_Invert: TMenuItem;
    miFile_Uncheck: TMenuItem;
    miFile_Check: TMenuItem;
    pmFile: TPopupMenu;
    procedure DataModuleCreate(Sender: TObject);
    procedure miFile_AddClick(Sender: TObject);
  end;

var
  MenuPrnData: TMenuPrnData;

implementation

uses
  menu_prn_form;

{$R *.lfm}

{ TMenuPrnData }

procedure TMenuPrnData.DataModuleCreate(Sender: TObject);
begin
  // # : - variable
  if (MenuPrnData = Nil) then
    MenuPrnData := Self;

  // # : - inheritance
  inherited;
end;

procedure TMenuPrnData.miFile_AddClick(Sender: TObject);
begin
  // # : - routine
  MenuPrnForm.fnFile_Add;
end;

end.

