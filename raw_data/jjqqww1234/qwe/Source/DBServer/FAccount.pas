unit FAccount;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, FeeDb, HUtil32;

type
  TFrmAccountForm = class(TForm)
    EdID:      TEdit;
    EdChrName: TEdit;
    Label1:    TLabel;
    Label2:    TLabel;
    Label3:    TLabel;
    CbFeeMode: TComboBox;
    Label4:    TLabel;
    EdYear:    TEdit;
    EdMon:     TEdit;
    EdDay:     TEdit;
    Label5:    TLabel;
    Label6:    TLabel;
    Label7:    TLabel;
    EdCount:   TEdit;
    Label8:    TLabel;
    Label9:    TLabel;
    EdMemo:    TEdit;
    Label10:   TLabel;
    Button1:   TButton;
    Button2:   TButton;
    EdOwner:   TEdit;
    Label11:   TLabel;
    EdDupCount: TEdit;
    Label12:   TLabel;
    procedure FormShow(Sender: TObject);
    procedure EdChrNameKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    function DoExecute: boolean;
  public
    FeeInfo: TFeeInfo;
    function Execute: boolean;
    function ExecuteAdd: boolean;
  end;

var
  FrmAccountForm: TFrmAccountForm;

implementation

{$R *.DFM}

const
  MAXCOMP = 10;

function TFrmAccountForm.Execute: boolean;
begin
  EdId.Enabled := False;
  EdChrName.Enabled := False;
  Result := DoExecute;
end;

function TFrmAccountForm.ExecuteAdd: boolean;
begin
  EdId.Enabled := True;
  EdChrName.Enabled := True;
  Result := DoExecute;
end;

function TFrmAccountForm.DoExecute: boolean;
var
  ayear, amon, aday: word;
begin
  EdId.Text      := FeeInfo.UserKey;
  EdChrName.Text := FeeInfo.GroupKey;
  EdOwner.Text   := FeeInfo.OwnerName;
  if not (FeeInfo.AccountMode in [0..2]) then
    FeeInfo.AccountMode := 0;
  EdDupCount.Text := IntToStr(FeeInfo.DupCOunt);
  CbFeeMode.ItemIndex := FeeInfo.AccountMode;
  DecodeDate(FeeInfo.EntryDate, ayear, amon, aday);
  EdYear.Text  := IntToStr(ayear);
  EdMon.Text   := IntToStr(amon);
  EdDay.Text   := IntToStr(aday);
  EdCount.Text := IntToStr(FeeInfo.NCount);
  EdMemo.Text  := FeeInfo.Memo;
  if mrOk = ShowModal then begin
    FeeInfo.UserKey := Trim(EdId.Text);
    FeeInfo.GroupKey := Trim(EdChrName.Text);
    FeeInfo.OwnerName := Trim(EdOwner.Text);
    FeeInfo.AccountMode := CbFeeMode.ItemIndex;
    FeeInfo.DupCOunt := Str_ToInt(EdDupCount.Text, 1);
    ayear := Str_ToInt(EdYear.Text, 1998);
    amon  := Str_ToInt(EdMon.Text, 1);
    aday  := Str_ToInt(EdDay.Text, 1);
    try
      FeeInfo.EntryDate := EncodeDate(ayear, amon, aday);
    except
      ShowMessage('Input data for date is not correct.');
    end;
    FeeInfo.NCount := Str_ToInt(EdCount.Text, 0);
    FeeInfo.Memo := EdMemo.Text;
    Result := True;
  end else
    Result := False;
end;

procedure TFrmAccountForm.FormShow(Sender: TObject);
begin
  if EdID.Enabled then begin
    EdId.SetFocus;
  end else
    CbFeeMode.SetFocus;
end;

procedure TFrmAccountForm.EdChrNameKeyPress(Sender: TObject; var Key: char);
var
  i, t:  integer;
  compo: TWinControl;
begin
  if Key = #13 then begin
    Key := #0;
    t   := 1;
    for i := 0 to ComponentCount - 1 do begin
      compo := TWinControl(Components[i]);
      if compo = Sender then begin
        if compo.Tag < MAXCOMP then
          t := compo.Tag + 1
        else
          t := 1;
        break;
      end;
    end;
    for i := 0 to ComponentCount - 1 do begin
      compo := TWinControl(Components[i]);
      if compo.Tag = t then begin
        if compo.Visible and compo.Enabled then begin
          compo.SetFocus;
          break;
        end;
        t := t + 1;
      end;
    end;
  end;
end;

procedure TFrmAccountForm.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then begin
    Key := #0;
    ModalResult := mrCancel;
    Close;
  end;
end;

procedure TFrmAccountForm.FormKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then begin
    ModalResult := mrOk;
    //Close;
  end;
end;

end.
