//# [ about ]
//# - author : Isaac Caires
//# . - email : zrfisaac@gmail.com
//# . - site : https://zrfisaac.github.io

//# [ lazarus ]
unit menu_main_data;

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
  LCLType,
  IniFiles,
  StdCtrls,
  model_base_data;

type

  { TMenuMainData }

  TMenuMainData = class(TModelBaseData)
    procedure DataModuleCreate(Sender: TObject);
  public
    // # : - attribute - config
    vConfig_Path: String;
    vConfig_Section: String;

    // # : - method - config
    function fnConfig_Read(_pPath, _pSection, _pProperty, _pValue : String): String; overload;
    function fnConfig_Read(_pSection, _pProperty, _pValue : String): String; overload;
    function fnConfig_Read(_pProperty, _pValue : String): String; overload;
    function fnConfig_Read(_pProperty: String): String; overload;
    function fnConfig_Read(_pPath, _pSection, _pProperty : String; _pValue : Boolean): Boolean; overload;
    function fnConfig_Read(_pSection, _pProperty : String; _pValue : Boolean): Boolean; overload;
    function fnConfig_Read(_pProperty : String; _pValue : Boolean): Boolean; overload;
    procedure fnConfig_Read(_pPath, _pSection, _pProperty : String; _pValue : TComboBox); overload;
    procedure fnConfig_Read(_pSection, _pProperty : String; _pValue : TComboBox); overload;
    procedure fnConfig_Read(_pProperty : String; _pValue : TComboBox); overload;
    function fnConfig_Read(_pPath, _pSection, _pProperty : String; _pValue : TCheckBox): Boolean; overload;
    function fnConfig_Read(_pSection, _pProperty : String; _pValue : TCheckBox): Boolean; overload;
    function fnConfig_Read(_pProperty : String; _pValue : TCheckBox): Boolean; overload;
    function fnConfig_Write(_pPath, _pSection, _pProperty, _pValue : String): String; overload;
    function fnConfig_Write(_pSection, _pProperty, _pValue : String): String; overload;
    function fnConfig_Write(_pProperty, _pValue : String): String; overload;
    function fnConfig_Write(_pProperty : String): String; overload;
    function fnConfig_Write(_pPath, _pSection, _pProperty : String; _pValue : Boolean): Boolean; overload;
    function fnConfig_Write(_pSection, _pProperty : String; _pValue : Boolean): Boolean; overload;
    function fnConfig_Write(_pProperty : String; _pValue : Boolean): Boolean; overload;
    procedure fnConfig_Write(_pPath, _pSection, _pProperty : String; _pValue : TComboBox); overload;
    procedure fnConfig_Write(_pSection, _pProperty : String; _pValue : TComboBox); overload;
    procedure fnConfig_Write(_pProperty : String; _pValue : TComboBox); overload;
    function fnConfig_Write(_pPath, _pSection, _pProperty : String; _pValue : TCheckBox): Boolean; overload;
    function fnConfig_Write(_pSection, _pProperty : String; _pValue : TCheckBox): Boolean; overload;
    function fnConfig_Write(_pProperty : String; _pValue : TCheckBox): Boolean; overload;

    // # : - method - main
    procedure fnMain_Read;
    procedure fnMain_Write;
  end;

var
  MenuMainData: TMenuMainData;

implementation

uses
  menu_config_form;

{$R *.lfm}

procedure TMenuMainData.DataModuleCreate(Sender: TObject);
begin
  // # : - variable
  if (MenuMainData = Nil) then
    MenuMainData := Self;

  // # : - inheritance
  inherited;

  // # : - menu config form
  if (MenuConfigForm = Nil) then
    TMenuConfigForm.Create(Application);

  // # : - config
  Self.vConfig_Path := ExtractFilePath(Application.ExeName) + 'config.ini';
  Self.vConfig_Section := 'main';
  Self.fnMain_Read;
end;

function TMenuMainData.fnConfig_Read(_pPath, _pSection, _pProperty, _pValue: String): String;
var
  _vReturn: String;
  _vIniFile: TIniFile;
begin
  // # : - variable
  _vReturn := '';

  // # : - routine
  _vIniFile := TIniFile.Create(_pPath);
  _vReturn := _vIniFile.ReadString(_pSection, _pProperty, _pValue);
  _vIniFile.WriteString(_pSection, _pProperty, _vReturn);
  _vIniFile.Free;
  _vIniFile := Nil;

  // # : - return
  Result := _vReturn;
end;

function TMenuMainData.fnConfig_Read(_pSection, _pProperty, _pValue: String): String;
begin
  // # : - return
  Result := Self.fnConfig_Read(Self.vConfig_Path, _pSection, _pProperty, _pValue);
end;

function TMenuMainData.fnConfig_Read(_pProperty, _pValue: String): String;
begin
  // # : - return
  Result := Self.fnConfig_Read(Self.vConfig_Path, Self.vConfig_Section, _pProperty, _pValue);
end;

function TMenuMainData.fnConfig_Read(_pProperty: String): String;
begin
  // # : - return
  Result := Self.fnConfig_Read(Self.vConfig_Path, Self.vConfig_Section, _pProperty, '');
end;

function TMenuMainData.fnConfig_Read(_pPath, _pSection, _pProperty: String; _pValue: Boolean): Boolean;
var
  _vValue: String;
begin
  // # : - variable
  if (_pValue) then
    _vValue := '1'
  else
    _vValue := '0';

  // # : - return
  Result := (Self.fnConfig_Read(_pPath, _pSection, _pProperty, _vValue) = '1');
end;

function TMenuMainData.fnConfig_Read(_pSection, _pProperty: String; _pValue: Boolean): Boolean;
var
  _vValue: String;
begin
  // # : - variable
  if (_pValue) then
    _vValue := '1'
  else
    _vValue := '0';

  // # : - return
  Result := (Self.fnConfig_Read(_pSection, _pProperty, _vValue) = '1');
end;

function TMenuMainData.fnConfig_Read(_pProperty: String; _pValue: Boolean): Boolean;
var
  _vValue: String;
begin
  // # : - variable
  if (_pValue) then
    _vValue := '1'
  else
    _vValue := '0';

  // # : - return
  Result := (Self.fnConfig_Read(_pProperty, _vValue) = '1');
end;

procedure TMenuMainData.fnConfig_Read(_pPath, _pSection, _pProperty: String; _pValue: TComboBox);
begin
  _pValue.ItemIndex := StrToIntDef(Self.fnConfig_Read(_pPath, _pSection, _pProperty, IntToStr(_pValue.ItemIndex)), 0);
end;

procedure TMenuMainData.fnConfig_Read(_pSection, _pProperty: String; _pValue: TComboBox);
begin
  _pValue.ItemIndex := StrToIntDef(Self.fnConfig_Read(_pSection, _pProperty, IntToStr(_pValue.ItemIndex)), 0);
end;

procedure TMenuMainData.fnConfig_Read(_pProperty: String; _pValue: TComboBox);
begin
  _pValue.ItemIndex := StrToIntDef(Self.fnConfig_Read(_pProperty, IntToStr(_pValue.ItemIndex)), 0);
end;

function TMenuMainData.fnConfig_Read(_pPath, _pSection, _pProperty: String; _pValue: TCheckBox): Boolean;
begin
  _pValue.Checked := Self.fnConfig_Read(_pPath, _pSection, _pProperty, _pValue.Checked);
  Result := _pValue.Checked;
end;

function TMenuMainData.fnConfig_Read(_pSection, _pProperty: String; _pValue: TCheckBox): Boolean;
begin
  _pValue.Checked := Self.fnConfig_Read(_pSection, _pProperty, _pValue.Checked);
  Result := _pValue.Checked;
end;

function TMenuMainData.fnConfig_Read(_pProperty: String; _pValue: TCheckBox): Boolean;
begin
  _pValue.Checked := Self.fnConfig_Read(_pProperty, _pValue.Checked);
  Result := _pValue.Checked;
end;

function TMenuMainData.fnConfig_Write(_pPath, _pSection, _pProperty, _pValue: String): String;
var
  _vReturn: String;
  _vIniFile: TIniFile;
begin
  // # : - variable
  _vReturn := '';

  // # : - routine
  _vIniFile := TIniFile.Create(_pPath);
  _vIniFile.WriteString(_pSection, _pProperty, _pValue);
  _vReturn := _vIniFile.ReadString(_pSection, _pProperty, _pValue);
  _vIniFile.Free;
  _vIniFile := Nil;

  // # : - return
  Result := _vReturn;
end;

function TMenuMainData.fnConfig_Write(_pSection, _pProperty, _pValue: String): String;
begin
  // # : - return
  Result := Self.fnConfig_Write(Self.vConfig_Path, _pSection, _pProperty, _pValue);
end;

function TMenuMainData.fnConfig_Write(_pProperty, _pValue: String): String;
begin
  // # : - return
  Result := Self.fnConfig_Write(Self.vConfig_Path, Self.vConfig_Section, _pProperty, _pValue);
end;

function TMenuMainData.fnConfig_Write(_pProperty: String): String;
begin
  // # : - return
  Result := Self.fnConfig_Write(Self.vConfig_Path, Self.vConfig_Section, _pProperty, '');
end;

function TMenuMainData.fnConfig_Write(_pPath, _pSection, _pProperty: String; _pValue: Boolean): Boolean;
var
  _vValue: String;
begin
  // # : - variable
  if (_pValue) then
    _vValue := '1'
  else
    _vValue := '0';

  // # : - return
  Result := (Self.fnConfig_Write(_pPath, _pSection, _pProperty, _vValue) = '1');
end;

function TMenuMainData.fnConfig_Write(_pSection, _pProperty: String; _pValue: Boolean): Boolean;
var
  _vValue: String;
begin
  // # : - variable
  if (_pValue) then
    _vValue := '1'
  else
    _vValue := '0';

  // # : - return
  Result := (Self.fnConfig_Write(_pSection, _pProperty, _vValue) = '1');
end;

function TMenuMainData.fnConfig_Write(_pProperty: String; _pValue: Boolean): Boolean;
var
  _vValue: String;
begin
  // # : - variable
  if (_pValue) then
    _vValue := '1'
  else
    _vValue := '0';

  // # : - return
  Result := (Self.fnConfig_Write(_pProperty, _vValue) = '1');
end;

procedure TMenuMainData.fnConfig_Write(_pPath, _pSection, _pProperty: String; _pValue: TComboBox);
begin
  Self.fnConfig_Write(_pPath, _pSection, _pProperty, IntToStr(_pValue.ItemIndex));
end;

procedure TMenuMainData.fnConfig_Write(_pSection, _pProperty: String; _pValue: TComboBox);
begin
  Self.fnConfig_Write(_pSection, _pProperty, IntToStr(_pValue.ItemIndex));
end;

procedure TMenuMainData.fnConfig_Write(_pProperty: String; _pValue: TComboBox);
begin
  Self.fnConfig_Write(_pProperty, IntToStr(_pValue.ItemIndex));
end;

function TMenuMainData.fnConfig_Write(_pPath, _pSection, _pProperty: String; _pValue: TCheckBox): Boolean;
begin
  Result := Self.fnConfig_Write(_pPath, _pSection, _pProperty, _pValue.Checked);
end;

function TMenuMainData.fnConfig_Write(_pSection, _pProperty: String; _pValue: TCheckBox): Boolean;
begin
  Result := Self.fnConfig_Write(_pSection, _pProperty, _pValue.Checked);
end;

function TMenuMainData.fnConfig_Write(_pProperty: String; _pValue: TCheckBox): Boolean;
begin
  Result := Self.fnConfig_Write(_pProperty, _pValue.Checked);
end;

procedure TMenuMainData.fnMain_Read;
begin
  // # : - routine
  Self.vConfig_Section := 'main';
  Self.fnConfig_Read('lang', MenuConfigForm.cbMain_Lang);
  Self.fnConfig_Read('splash', MenuConfigForm.ckMain_Splash);
end;

procedure TMenuMainData.fnMain_Write;
begin
  // # : - routine
  Self.vConfig_Section := 'main';
  Self.fnConfig_Write('lang', MenuConfigForm.cbMain_Lang);
  Self.fnConfig_Write('splash', MenuConfigForm.ckMain_Splash);
end;

end.

