{Copyright (c) 2023 Stephan Breer

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
}

unit GridSettingsForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, SpinEx;

type

  { TfmGridSettings }

  TfmGridSettings = class(TForm)
    bOk: TButton;
    bCancel: TButton;
    cdGridColor: TColorDialog;
    cbGridType: TComboBox;
    fseGridOffsetY: TFloatSpinEditEx;
    fseGridSizeY: TFloatSpinEditEx;
    fseGridSizeX: TFloatSpinEditEx;
    fseGridOffsetX: TFloatSpinEditEx;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    pGridColor: TPanel;
    procedure bCancelClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fseGridSizeXChange(Sender: TObject);
    procedure pGridColorClick(Sender: TObject);
  private

  public

  end;

var
  fmGridSettings: TfmGridSettings;

implementation

{$R *.lfm}

uses
  ControllerForm,
  RPGTypes,
  LangStrings;

{ TfmGridSettings }

procedure TfmGridSettings.pGridColorClick(Sender: TObject);
begin
  cdGridColor.Color := pGridColor.Color;
  if cdGridColor.Execute then
  begin
    pGridColor.Color := cdGridColor.Color;
    fmController.GridColor := cdGridColor.Color;
    fmController.pbViewport.Invalidate;
  end;
end;

procedure TfmGridSettings.FormShow(Sender: TObject);
begin
  Caption := GetString(LangStrings.LanguageID, 'GridSettingsCaption');
  Label6.Caption := GetString(LangStrings.LanguageID, 'GridSettingsType');
  Label1.Caption := GetString(LangStrings.LanguageID, 'GridSettingsSizeX'); 
  Label5.Caption := GetString(LangStrings.LanguageID, 'GridSettingsSizeY');
  Label2.Caption := GetString(LangStrings.LanguageID, 'GridSettingsOffsetX');
  Label3.Caption := GetString(LangStrings.LanguageID, 'GridSettingsOffsetY');
  Label4.Caption := GetString(LangStrings.LanguageID, 'GridSettingsColor');
  cbGridType.Items[0] := GetString(LangStrings.LanguageID, 'GridSettingsType0');
  cbGridType.Items[1] := GetString(LangStrings.LanguageID, 'GridSettingsType1');
  cbGridType.Items[2] := GetString(LangStrings.LanguageID, 'GridSettingsType2');
  bCancel.Caption := GetString(LangStrings.LanguageID, 'ButtonCancel');
  bOk.Caption := GetString(LangStrings.LanguageID, 'ButtonOk');
end;

procedure TfmGridSettings.bOkClick(Sender: TObject);
begin
  fmController.SaveGridData;
  fmController.SnapAllTokensToGrid;
  Close;
end;

procedure TfmGridSettings.bCancelClick(Sender: TObject);
begin
  fmController.RestoreGridData;
  Close;
end;

procedure TfmGridSettings.fseGridSizeXChange(Sender: TObject);
begin
  fmController.GridSizeX   := fseGridSizeX.Value;
  fmController.GridSizeY   := fseGridSizeY.Value;
  fmController.GridOffsetX := fseGridOffsetX.Value;
  fmController.GridOffsetY := fseGridOffsetY.Value;
  fmController.GridType    := TGridType(cbGridType.ItemIndex);
  fmController.pbViewport.Invalidate;
end;

end.

