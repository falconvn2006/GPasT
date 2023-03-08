unit unGlobals;

interface

uses
  Math, Registry, cxDropDownEdit, XHelpers;

type
  PAppSettings = ^TAppSettings;
  TAppSettings = record
    EditorPath  : string;
    SaveOptions : record
      Dir             : string;
      Ext             : string;
      CreateOwnerDir  : Boolean;
      CreateTypeDir   : Boolean;
      OwnerInFileName : Boolean;
      TypeInFileName  : Boolean;
    end;
  end;

var
  AppSettings: TAppSettings;

procedure SaveComboBox(R: TRegistry; Combo: TcxComboBox; SortItems: Boolean = True; ComboName: string = '');
procedure LoadComboBox(R: TRegistry; Combo: TcxComboBox; ComboName: string = '');

implementation

uses
  unConsts;

const
  S_LIST_SUFFIX = '.List';

procedure SaveComboBox(R: TRegistry; Combo: TcxComboBox; SortItems: Boolean; ComboName: string);
var
  i: Integer;
begin
  if ComboName = '' then
    ComboName := Combo.Name;
  if ComboName = '' then
    Exit;

  i := Combo.Properties.Items.IndexOf(Combo.Text);
  if (i <> -1) and SortItems then begin
    Combo.Text := Combo.Properties.Items[i];
    Combo.Properties.Items.Delete(i);
  end;

  Combo.Properties.Items.Insert(0, Combo.Text);
  R.WriteString(ComboName + S_LIST_SUFFIX, Combo.Properties.Items.DelimitedText);
end;

procedure LoadComboBox(R: TRegistry; Combo: TcxComboBox; ComboName: string);
begin
  if ComboName = '' then
    ComboName := Combo.Name;
  if ComboName = '' then
    Exit;

  Combo.Properties.Items.DelimitedText := R.ReadString(ComboName + S_LIST_SUFFIX, Combo.Properties.Items.DelimitedText);
  Combo.ItemIndex                      := Min(0, Combo.Properties.Items.Count - 1);
  if Combo.ItemIndex = -1 then
    Combo.Text := '';
end;

initialization
  FillChar(AppSettings, SizeOf(AppSettings), #0);

end.
