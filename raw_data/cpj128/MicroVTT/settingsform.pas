{Copyright (c) 2023 Stephan Breer

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
}

unit SettingsForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TfmSettings }

  TfmSettings = class(TForm)
    bOk: TButton;
    bCancel: TButton;
    cbInitiativeOrder: TComboBox;
    cbLanguage: TComboBox;
    cbTokensStartInvisible: TCheckBox;
    eMapDirectory: TEdit;
    eTokenDirectory: TEdit;
    eOverlayDirectory: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    sbSelectMapDirectory: TSpeedButton;
    sbSelectTokenDirectory: TSpeedButton;
    sbSelectOverlayDirectory: TSpeedButton;
    procedure bCancelClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbSelectMapDirectoryClick(Sender: TObject);
    procedure sbSelectOverlayDirectoryClick(Sender: TObject);
    procedure sbSelectTokenDirectoryClick(Sender: TObject);
  private

  public

  end;

var
  fmSettings: TfmSettings;

implementation

{$R *.lfm}

uses
  ControllerForm,
  LangStrings;

{ TfmSettings }

procedure TfmSettings.sbSelectMapDirectoryClick(Sender: TObject);
var OutDir: string;
begin
  if SelectDirectory(GetString(LangStrings.LanguageID, 'SelectMapDirCaption'), eMapDirectory.Text, OutDir) then
    eMapDirectory.Text := OutDir;
end;

procedure TfmSettings.sbSelectOverlayDirectoryClick(Sender: TObject);
var OutDir: string;
begin
  if SelectDirectory(GetString(LangStrings.LanguageID, 'SelectOverlayDirCaption'), eOverlayDirectory.Text, OutDir) then
    eOverlayDirectory.Text := OutDir;
end;
    
procedure TfmSettings.sbSelectTokenDirectoryClick(Sender: TObject);
var OutDir: string;
begin
  if SelectDirectory(GetString(LangStrings.LanguageID, 'SelectTokenDirCaption'), eTokenDirectory.Text, OutDir) then
    eTokenDirectory.Text := OutDir;
end;

procedure TfmSettings.FormShow(Sender: TObject);
begin
  Caption := GetString(LangStrings.LanguageID, 'SettingsCaption');
  Label1.Caption := GetString(LangStrings.LanguageID, 'SettingsMapDir');
  Label2.Caption := GetString(LangStrings.LanguageID, 'SettingsTokenDir');  
  Label6.Caption := GetString(LangStrings.LanguageID, 'SettingsOverlayDir');
  Label3.Caption := GetString(LangStrings.LanguageID, 'SettingsInitiativeOrder');
  cbInitiativeOrder.Items[0] := GetString(LangStrings.LanguageID, 'SettingsInitiativeOrderHighest');
  cbInitiativeOrder.Items[1] := GetString(LangStrings.LanguageID, 'SettingsInitiativeOrderLowest');
  cbTokensStartInvisible.Caption := GetString(LangStrings.LanguageID, 'SettingsTokenStartInvisible');
  Label4.Caption := GetString(LangStrings.LanguageID, 'SettingsLanguage');
  Label5.Caption := GetString(LangStrings.LanguageID, 'SettingsLanguageHint');
  bCancel.Caption := GetString(LangStrings.LanguageID, 'ButtonCancel');
  bOk.Caption := GetString(LangStrings.LanguageID, 'ButtonOk');
end;

procedure TfmSettings.bOkClick(Sender: TObject);
begin
  fmController.SaveSettings;
  Close;
end;

procedure TfmSettings.bCancelClick(Sender: TObject);
begin
  Close;
end;

end.

