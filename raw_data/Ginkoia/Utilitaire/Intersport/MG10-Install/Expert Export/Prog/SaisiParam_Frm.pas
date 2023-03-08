unit SaisiParam_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, StdCtrls, GinkoiaStyle_Dm, AdvGlowButton, RzLabel,
  ExtCtrls, RzPanel, DB, Grids, DBGrids, RzButton, RzRadChk, ComCtrls;

type
  TFrm_SaisiParam = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    SBx_Scroll: TScrollBox;
    Lab_TitIn: TLabel;
    Lab_TitParam: TLabel;
    procedure Nbt_CancelClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure ChkStringChange(Sender: TObject);
    procedure ChkChange(Sender: TObject);
    procedure EdtIntegerKeyPress(Sender: TObject; var Key: Char);
    procedure EdtFloatKeyPress(Sender: TObject; var Key: Char);
    procedure EdtStringChange(Sender: TObject);
    procedure EdtChange(Sender: TObject);
    function GetChk(ATag: integer): TRzCheckBox;
    function GetEdt(ATag: integer): TEdit;
    function GetDtPickDate(ATag: integer): TDateTimePicker;
    function GetDtPickTime(ATag: integer): TDateTimePicker;
  public
    { Déclarations publiques }
  end;

var
  Frm_SaisiParam: TFrm_SaisiParam;

implementation

uses
  Main_Dm;

{$R *.dfm}

function TFrm_SaisiParam.GetChk(ATag: integer): TRzCheckBox;
var
  bOk: boolean;
  i: integer;
begin
  Result := nil;
  bOk := false;
  i := 1;
  while not(bOk) and (i<=SBx_Scroll.ControlCount) do
  begin
    if (SBx_Scroll.Controls[i-1] is TRzCheckBox)
         and (TRzCheckBox(SBx_Scroll.Controls[i-1]).Tag = ATag) then
      Result := TRzCheckBox(SBx_Scroll.Controls[i-1]);
    Inc(i);
  end;
end;

function TFrm_SaisiParam.GetEdt(ATag: integer): TEdit;
var
  bOk: boolean;
  i: integer;
begin
  Result := nil;
  bOk := false;
  i := 1;
  while not(bOk) and (i<=SBx_Scroll.ControlCount) do
  begin
    if (SBx_Scroll.Controls[i-1] is TEdit)
         and (TEdit(SBx_Scroll.Controls[i-1]).Tag = ATag) then
      Result := TEdit(SBx_Scroll.Controls[i-1]);
    Inc(i);
  end;
end;

function TFrm_SaisiParam.GetDtPickDate(ATag: integer): TDateTimePicker;
var
  bOk: boolean;
  i: integer;
begin
  Result := nil;
  bOk := false;
  i := 1;
  while not(bOk) and (i<=SBx_Scroll.ControlCount) do
  begin
    if (SBx_Scroll.Controls[i-1] is TDateTimePicker)
         and (TDateTimePicker(SBx_Scroll.Controls[i-1]).Tag = ATag)
         and (TDateTimePicker(SBx_Scroll.Controls[i-1]).Kind = dtkDate) then
      Result := TDateTimePicker(SBx_Scroll.Controls[i-1]);
    Inc(i);
  end;
end;

function TFrm_SaisiParam.GetDtPickTime(ATag: integer): TDateTimePicker;
var
  bOk: boolean;
  i: integer;
begin
  Result := nil;
  bOk := false;
  i := 1;
  while not(bOk) and (i<=SBx_Scroll.ControlCount) do
  begin
    if (SBx_Scroll.Controls[i-1] is TDateTimePicker)
         and (TDateTimePicker(SBx_Scroll.Controls[i-1]).Tag = ATag)
         and (TDateTimePicker(SBx_Scroll.Controls[i-1]).Kind = dtkTime) then
      Result := TDateTimePicker(SBx_Scroll.Controls[i-1]);
    Inc(i);
  end;
end;

procedure TFrm_SaisiParam.ChkStringChange(Sender: TObject);
var
  EdtTmp: TEdit;
begin
  if not(TRzCheckBox(Sender).Focused) then
    exit;

  if TRzCheckBox(Sender).Checked then
  begin
    EdtTmp := GetEdt(TRzCheckBox(Sender).Tag);
    if EdtTmp<>nil then
      EdtTmp.Text := '';
  end;
end;

procedure TFrm_SaisiParam.ChkChange(Sender: TObject);
var
  EdtTmp: TEdit;
begin
  if not(TRzCheckBox(Sender).Focused) then
    exit;

  if TRzCheckBox(Sender).Checked then
  begin
    EdtTmp := GetEdt(TRzCheckBox(Sender).Tag);
    if EdtTmp<>nil then
      EdtTmp.Text := '';
  end
  else
  begin
    EdtTmp := GetEdt(TRzCheckBox(Sender).Tag);
    if EdtTmp<>nil then
      EdtTmp.Text := '0';
  end;
end;

procedure TFrm_SaisiParam.EdtIntegerKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key)>=32) and not(CharInSet(Key , ['0'..'9'])) then
    Key := chr(7);
end;

procedure TFrm_SaisiParam.EdtFloatKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key=',') or (Key='.') then
    Key := FormatSettings.DecimalSeparator;

  if (Ord(Key)>=32) and not(CharInSet(Key , ['0'..'9', ',', '.'])) then
    Key := chr(7);
end;

procedure TFrm_SaisiParam.EdtStringChange(Sender: TObject);
var
  ChkTmp: TRzCheckBox;
begin
  if TEdit(Sender).Text='' then
    exit;

  ChkTmp := GetChk(TEdit(Sender).Tag);
  if ChkTmp<>nil then
    ChkTmp.Checked := false;
end;

procedure TFrm_SaisiParam.EdtChange(Sender: TObject);
var
  bCheck: boolean;
  ChkTmp: TRzCheckBox;
begin
  bCheck := (TEdit(Sender).Text='');

  ChkTmp := GetChk(TEdit(Sender).Tag);
  if ChkTmp<>nil then
    ChkTmp.Checked := bCheck;
end;

procedure TFrm_SaisiParam.AlgolDialogFormCreate(Sender: TObject);
var
  X1, X2, X3: integer;
  DecalY: integer;
  Y: integer;
  iTag: integer;
  Chk_Null: TRzCheckBox;
begin
  X1 := Lab_TitIn.Left;
  X2 := Lab_TitParam.Left;
  X3 := X2+52;
  Y := 33;    // label = +3
  DecalY := 35;

  with Dm_Main do
  begin
    // liste des paramètres de l'appli
    cds_Param.First;
    while not(cds_Param.Eof) do
    begin
      if (cds_Param.FieldByName('Saisi').AsInteger>0)
            and (cds_Param.FieldByName('Tipe').AsInteger>0) then
      begin
        iTag := cds_Param.FieldByName('Num').AsInteger;
        With TRzLabel.Create(Self) do
        begin
          Parent := SBx_Scroll;
          Tag := iTag;
          Left := X1;
          Top := y +3;
          AutoSize := false;
          Width := X2-X1-10;
          CondenseCaption := ccAtEnd;
          Caption := cds_Param.FieldByName('Nom').AsString;
        end;

        Chk_Null := TRzCheckBox.Create(Self);
        with Chk_Null do
        begin
          Parent := SBx_Scroll;
          Tag := iTag;
          Left := X2;
          Top := y +3;
          AutoSize := false;
          Width := 46;
          Caption := 'Null';
          Enabled := (cds_Param.FieldByName('Saisi').AsInteger=1);
        end;

        if cds_Param.FieldByName('Tipe').AsInteger<>4 then
        begin
          with TEdit.Create(Self) do
          begin
            Parent := SBx_Scroll;
            Tag := iTag;
            Left := X3;
            Top := y;
            Width := 180;
            Enabled := (cds_Param.FieldByName('Saisi').AsInteger=1);
            case cds_Param.FieldByName('Tipe').AsInteger of
              1:
              begin
                Chk_Null.Checked := false;
                Text := cds_Param.FieldByName('ValString').AsString;
                if Enabled then
                begin
                  OnChange := EdtStringChange;
                  Chk_Null.OnClick := ChkStringChange;
                end;
              end;
              2:
              begin
                if cds_Param.FieldByName('ValInteger').IsNull then
                begin
                  Chk_Null.Checked := true;
                  Text := '';
                end
                else
                begin
                  Chk_Null.Checked := false;
                  Text := inttostr(cds_Param.FieldByName('ValInteger').AsInteger);
                end;
                if Enabled then
                begin
                  OnChange := EdtChange;
                  OnKeyPress := EdtIntegerKeyPress;
                  Chk_Null.OnClick := ChkChange;
                end;
              end;
              3:
              begin
                if cds_Param.FieldByName('ValFloat').IsNull then
                begin
                  Chk_Null.Checked := true;
                  Text := '';
                end
                else
                begin
                  Chk_Null.Checked := false;
                  Text := FloatToStr(cds_Param.FieldByName('ValFloat').AsFloat);
                end;
                if Enabled then
                begin
                  OnChange := EdtChange;
                  OnKeyPress := EdtFloatKeyPress;
                  Chk_Null.OnClick := ChkChange;
                end;
              end;
            end;

          end;
        end
        else
        begin
          with TDateTimePicker.Create(Self) do
          begin
            Parent := SBx_Scroll;
            Tag := iTag;
            Left := X3;
            Top := y;
            Width := 110;
            Enabled := (cds_Param.FieldByName('Saisi').AsInteger=1);
            Kind := dtkDate;
            if cds_Param.FieldByName('ValDateTime').IsNull then
            begin
              Chk_Null.Checked := true;
              Date := SysUtils.Date
            end
            else
            begin
              Chk_Null.Checked := false;
              Date := cds_Param.FieldByName('ValDateTime').AsDateTime;
            end
          end;
          with TDateTimePicker.Create(Self) do
          begin
            Parent := SBx_Scroll;
            Tag := iTag;
            Left := X3+118;
            Top := y;
            Width := 110;
            Enabled := (cds_Param.FieldByName('Saisi').AsInteger=1);
            Kind := dtkTime;
            if cds_Param.FieldByName('ValDateTime').IsNull then
            begin
              Chk_Null.Checked := true;
              Time := SysUtils.Time
            end
            else
            begin
              Chk_Null.Checked := false;
              Time := cds_Param.FieldByName('ValDateTime').AsDateTime;
            end;
          end;
        end;  // if tipe=4
        if cds_Param.FieldByName('Saisi').AsInteger=2 then
        begin
          Y := Y+24;
          with TLabel.Create(Self) do
          begin
            Parent := SBx_Scroll;
            Tag := iTag;
            Left := X2;
            Top := Y;
            Caption := cds_Param.FieldByName('FicProc').AsString;
            Font.Style := [fsItalic];
          end;
        end;
        Y := Y+DecalY;

      end;
      cds_Param.Next;
    end;
  end;
end;

procedure TFrm_SaisiParam.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_SaisiParam.Nbt_PostClick(Sender: TObject);
var
  bOk: boolean;
  vInteger: integer;
  vFloat: Double;
  dt1, dt2: TDateTime;
  iTag: integer;
  bNull: boolean;
  ChkTmp: TRzCheckBox;
  EdtTmp: TEdit;
begin
  // Ctrl des entiers et des float
  bOk := true;
  With Dm_Main do
  begin
    cds_Param.First;
    while not(cds_Param.Eof) do
    begin
      if (cds_Param.FieldByName('Saisi').AsInteger=1)
           and ((cds_Param.FieldByName('Tipe').AsInteger=2)
                or (cds_Param.FieldByName('Tipe').AsInteger=3)) then
      begin
        iTag := cds_Param.FieldByName('Num').AsInteger;
        // test si le check est à null
        bNull := true;
        ChkTmp := GetChk(iTag);
        if ChkTmp<>nil then
          bNull := ChkTmp.Checked;

        if not(bNull) then
        begin
          EdtTmp := GetEdt(iTag);
          // test des entiers
          if (cds_Param.FieldByName('Tipe').AsInteger=2) then
          begin
            try
              vInteger := StrToInt(EdtTmp.Text);
            except
              bOk := false;
              MessageDlg('Valeur entière invalide !', mterror, [mbok],0);
              EdtTmp.SetFocus;
              EdtTmp.SelectAll;
            end;
          end;

          // test des float
          if (cds_Param.FieldByName('Tipe').AsInteger=3) then
          begin
            try
              vFloat := StrToFloat(EdtTmp.Text);
            except
              bOk := false;
              MessageDlg('Valeur float invalide !', mterror, [mbok],0);
              EdtTmp.SetFocus;
              EdtTmp.SelectAll;
            end;
          end;
        end;
      end;
      cds_Param.Next;
    end;
  end;
  if not(bOk) then
    exit;

  // affectation
  With Dm_Main do
  begin
    cds_Param.First;
    while not(cds_Param.Eof) do
    begin
      if (cds_Param.FieldByName('Saisi').AsInteger=1)
           and (cds_Param.FieldByName('Tipe').AsInteger>0) then
      begin
        iTag := cds_Param.FieldByName('Num').AsInteger;
        case cds_Param.FieldByName('Tipe').AsInteger of
          1:  // string
          begin
            EdtTmp := GetEdt(iTag);
            cds_Param.Edit;
            cds_Param.FieldByName('ValString').AsString := GetEdt(iTag).Text;
            cds_Param.Post;
          end;
          2:  // integer
          begin
            ChkTmp := GetChk(iTag);
            cds_Param.Edit;
            if ChkTmp.Checked then
              cds_Param.FieldByName('ValInteger').Value := null
            else
              cds_Param.FieldByName('ValInteger').AsInteger := StrToInt(GetEdt(iTag).Text);
            cds_Param.Post;
          end;
          3:  // float
          begin
            ChkTmp := GetChk(iTag);
            cds_Param.Edit;
            if ChkTmp.Checked then
              cds_Param.FieldByName('ValFloat').Value := null
            else
              cds_Param.FieldByName('ValFloat').AsFloat := StrToFloat(GetEdt(iTag).Text);
            cds_Param.Post;
          end;
          4:  // datetime
          begin
            ChkTmp := GetChk(iTag);
            cds_Param.Edit;
            if ChkTmp.Checked then
              cds_Param.FieldByName('ValDateTime').Value := null
            else
            begin
              dt1 := GetDtPickDate(iTag).Date;
              dt2 := GetDtPickTime(iTag).Time;
              cds_Param.FieldByName('ValDateTime').AsDateTime := Trunc(dt1)+Frac(dt2);
            end;
            cds_Param.Post;
          end;
        end;  // case
      end;
      cds_Param.Next;
    end;  // while
  end;  // with

  ModalResult := mrOk;
end;

end.
