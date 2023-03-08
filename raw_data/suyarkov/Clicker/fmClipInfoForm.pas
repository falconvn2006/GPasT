unit fmClipInfoForm;

interface

uses
  uLanguages,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TClipInfoForm = class(TForm)
    MemoClipInfo: TMemo;
    ButtonOk: TButton;
    EditClipName: TEdit;
    Label1: TLabel;
    LabelClipInfo: TLabel;
    ButtonCancel: TButton;
    EditCountNameLetters: TEdit;
    EditCountInfoLetters: TEdit;
    LanguageComboBox: TComboBox;
    Label2: TLabel;
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure EditClipNameChange(Sender: TObject);
    procedure MemoClipInfoChange(Sender: TObject);
    //procedure SetLanguageComboBox(pListLanguages: TListLanguages; pMainLanguage: String);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  ClipInfoForm: TClipInfoForm;

implementation

{$R *.dfm}

procedure TClipInfoForm.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TClipInfoForm.ButtonOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TClipInfoForm.EditClipNameChange(Sender: TObject);
var
  countLetters: integer;
  i: integer;
begin
  countLetters := Length(EditClipName.Text);
  EditCountNameLetters.Text := IntToStr(countLetters);

end;

procedure TClipInfoForm.MemoClipInfoChange(Sender: TObject);
var
  countLetters: integer;
  i: integer;
begin
  countLetters := 0;
  for i := 0 To MemoClipInfo.Lines.Count - 1 Do
  begin
    countLetters := countLetters + Length(MemoClipInfo.Lines.Strings[i]);
  end;

  EditCountInfoLetters.Text := IntToStr(countLetters);

end;

procedure SetLanguageComboBox(var pListLanguages: TListLanguages; pMainLanguage : String);
var
  i: integer;
  vNumberLanguage: integer;
begin
  vNumberLanguage := 0;
  // наполняем box значениями
  for i := 1 to 1000 do
  begin
    // пустые уже не добавляем
    if pListLanguages[i].LnCode = '' then
      break;

    ClipInfoForm.LanguageComboBox.Items.add(pListLanguages[i].LnCode + ' | ' +
      pListLanguages[i].NameForRead);
    // Запомним тот который активен
    if pListLanguages[i].LnCode = pMainLanguage then
      vNumberLanguage := ClipInfoForm.LanguageComboBox.Items.Count - 1;
    // потому как индекс с -1

  end;

  if vNumberLanguage > 0 then
    ClipInfoForm.LanguageComboBox.ItemIndex := vNumberLanguage;
end;

end.
