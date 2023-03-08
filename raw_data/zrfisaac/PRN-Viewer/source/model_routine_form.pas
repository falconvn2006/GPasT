// # [ about ]
// # - copyright
// # . - name : Isaac Caires
// # . - email : zrfisaac@gmail.com
// # . - site : https://sites.google.com/view/zrfisaac-en

// # [ lazarus ]
unit model_routine_form;

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
  ComCtrls,
  // # : ./source/*
  model_base_form;

type

  { TModelRoutineForm }

  TModelRoutineForm = class(TModelBaseForm)
    pcBack: TPageControl;
    pnTitle: TPanel;
    procedure bt_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  ModelRoutineForm: TModelRoutineForm;

implementation

{$R *.lfm}

{ TModelRoutineForm }

procedure TModelRoutineForm.bt_CloseClick(Sender: TObject);
begin
  // # : - routine
  if (Self.pnBack.Parent = Self) then
    Self.Close
  else
    Self.pnBack.Parent := Self;
end;

procedure TModelRoutineForm.FormCreate(Sender: TObject);
begin
  // # : - inheritance
  inherited;

  // # : - page control
  if (Self.pcBack.PageCount > 1) then
    Self.pcBack.TabIndex := 0;
end;

end.

