unit frmSettingsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, nppplugin, plugin, NppForms, NppDockingForms,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmSettings = class(TNppForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    cbAutoJumpToResult: TCheckBox;
    cbAdjustToDarkMode: TCheckBox;
    cbRememberState: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

end.
