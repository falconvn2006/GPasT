{Copyright (c) 2023 Stephan Breer

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
}

unit InitiativeForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Buttons;

type

  { TfmSetInitiative }

  TfmSetInitiative = class(TForm)
    bOk: TButton;
    bCancel: TButton;
    eBaseInitiative: TEdit;
    eRolledInitiative: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sbRoll6: TSpeedButton;
    sbRoll20: TSpeedButton;
    udBaseInitiative: TUpDown;
    udRolledInitiative: TUpDown;
    procedure bCancelClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbRoll6Click(Sender: TObject);
  private

  public
    TokenName, TokenPath: string;
  end;

var
  fmSetInitiative: TfmSetInitiative;

implementation

{$R *.lfm}

uses
  ControllerForm,
  LangStrings;

{ TfmSetInitiative }

procedure TfmSetInitiative.sbRoll6Click(Sender: TObject);
begin
  udRolledInitiative.Position := Random(TComponent(Sender).Tag) + 1;
end;

procedure TfmSetInitiative.bOkClick(Sender: TObject);
begin
  fmController.AddToInitiative(TokenName, TokenPath, udBaseInitiative.Position + udRolledInitiative.Position);
  Close;
end;

procedure TfmSetInitiative.FormShow(Sender: TObject);
begin
  Caption := GetString(LangStrings.LanguageID, 'InitiativeCaption');
  Label1.Caption := GetString(LangStrings.LanguageID, 'InitiativeBaseValue');
  Label3.Caption := GetString(LangStrings.LanguageID, 'InitiativeRolledValue');
  bOk.Caption := GetString(LangStrings.LanguageID, 'ButtonOk');
  bCancel.Caption := GetString(LangStrings.LanguageID, 'ButtonCancel');
end;

procedure TfmSetInitiative.bCancelClick(Sender: TObject);
begin
  Close;
end;

end.

