unit ParamSortie_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, StdCtrls, GinkoiaStyle_Dm, AdvGlowButton, RzLabel,
  ExtCtrls, RzPanel, DB, Grids, DBGrids;

const
  WM_SUPPR_OUT = WM_USER+100;

type
  TFrm_ParamSortie = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    SBx_Scroll: TScrollBox;
    Lab_TitIn: TLabel;
    Lab_TitParam: TLabel;
    BtAjout: TAdvGlowButton;
    procedure Nbt_CancelClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure AlgolDialogFormDestroy(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure BtAjoutClick(Sender: TObject);
  private
    { Déclarations privées }
    LstNumParam: TStringList;
    LstParam: TStringList;
    procedure WmSupprOut(var m:TMessage); message WM_SUPPR_OUT;
    procedure BtSupprClick(Sender: TObject);
    procedure EdtChampKeyPress(Sender: TObject; var Key: Char);
    procedure AjoutComposant(ATag: integer; AChamp: string; ANumParam: integer);
  public
    { Déclarations publiques }
  end;

var
  Frm_ParamSortie: TFrm_ParamSortie;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_ParamSortie.EdtChampKeyPress(Sender: TObject; var Key: Char);
begin
  Key := UpCase(Key);
  if (Ord(Key)>=32) and not(CharInSet(Key , ['0'..'9','A'..'Z'])) then
    Key := chr(7);
end;

procedure TFrm_ParamSortie.WmSupprOut(var m:TMessage);
var
  AWinControl: TWinControl;
  i: integer;
  DecalY: integer;
  iTag: integer;
begin
  DecalY := 35;
  iTag := m.WParam;
  for i := SBx_Scroll.ControlCount downto 1 do
  begin
    AWinControl := TWinControl(SBx_Scroll.Controls[i-1]);
    if AWinControl.Tag = iTag then
      FreeAndNil(AWinControl)
    else
    begin
      if AWinControl.Tag > iTag then
        AWinControl.Top := AWinControl.Top-DecalY;
    end
  end;
  BtAjout.Top := BtAjout.Top-DecalY;
end;

procedure TFrm_ParamSortie.BtAjoutClick(Sender: TObject);
var
  iTag: integer;
  i: integer;
begin
  iTag := 0;
  for i := SBx_Scroll.ControlCount downto 1 do
  begin
    if TWinControl(SBx_Scroll.Controls[i-1]).Tag>iTag then
      iTag := TWinControl(SBx_Scroll.Controls[i-1]).Tag;
  end;
  Inc(iTag);
  AjoutComposant(iTag, '', 0);
end;

procedure TFrm_ParamSortie.BtSupprClick(Sender: TObject);
begin
  // la suppression doit se faire après le click car on supprime ce bouton
  PostMessage(Handle, WM_SUPPR_OUT, TAdvGlowButton(Sender).Tag, 0);
end;

procedure TFrm_ParamSortie.AjoutComposant(ATag: integer; AChamp: string; ANumParam: integer);
var
  X1, X2: integer;
  DecalY: integer;
  Y: integer;
  LIndex: integer;
begin
  X1 := Lab_TitIn.Left;
  X2 := Lab_TitParam.Left;
  DecalY := 35;
  Y := BtAjout.Top;

  with TAdvGlowButton.Create(Self) do
  begin
    Parent := SBx_Scroll;
    SetBounds(15, Y, 27, 26);
    OnClick := BtSupprClick;
    Caption := '';
    Images := Dm_GinkoiaStyle.Img_Boutons;
    ImageIndex := 2;
    Tag := ATag;
  end;
  With TEdit.Create(Self) do
  begin
    Parent := SBx_Scroll;
    Left := X1;
    Top := y+3;
    Width := 190;
    CharCase := ecUpperCase;
    Text := UpperCase(AChamp);
    Tag := ATag;
    OnKeyPress := EdtChampKeyPress;
  end;
  With TCombobox.Create(Self) do
  begin
    Parent := SBx_Scroll;
    Left := X2;
    Top := Y+3;
    Width := 250;
    Items.AddStrings(LstParam);
    Style := csDropDownList;
    LIndex := LstNumParam.IndexOf(IntToStr(ANumParam));
    if LIndex<0 then
      LIndex := 0;
    ItemIndex := LIndex;
    Tag := ATag;
  end;
  BtAjout.Top := BtAjout.Top+DecalY;
end;

procedure TFrm_ParamSortie.AlgolDialogFormCreate(Sender: TObject);
var
  iTag: integer;
begin
  BtAjout.Top := 30;

  iTag := 1;
  LstNumParam := TStringList.Create;
  LstParam := TStringList.Create;
  with Dm_Main do
  begin
    // liste des paramètres de l'appli
    LstNumParam.Add('0');
    LstParam.Add('Aucun Paramètre associé');
    cds_Param.First;
    while not(cds_Param.Eof) do
    begin
      LstNumParam.Add(IntToStr(cds_Param.FieldByName('Num').AsInteger));
      LstParam.Add(cds_Param.FieldByName('Nom').AsString);
      cds_Param.Next;
    end;

    // paramètre d'entrée
    with Dm_Main do
    begin
      iTag := 1;
      cds_SortieOut.First;
      while not(cds_SortieOut.Eof) do
      begin
        inc(iTag);
        AjoutComposant(iTag, cds_SortieOut.fieldbyname('NomChamp').AsString,
                             cds_SortieOut.fieldbyname('NumParam').AsInteger);
        cds_SortieOut.Next;
      end;
    end;

  end;

end;

procedure TFrm_ParamSortie.AlgolDialogFormDestroy(Sender: TObject);
begin
  FreeAndNil(LstNumParam);
  FreeAndNil(LstParam);
end;

procedure TFrm_ParamSortie.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_ParamSortie.Nbt_PostClick(Sender: TObject);
var
  i, j: integer;
  iTag: integer;
  sChamp: string;
  bOk: boolean;
  LIndex: integer;
  LNumParam: integer;
begin
  i := 1;
  bOk := true;
  while bOk and (i<=SBx_Scroll.ControlCount) do
  begin
    if (SBx_Scroll.Controls[i-1] is TEdit)
        and (TEdit(SBx_Scroll.Controls[i-1]).Tag>0)
        and (Trim(TEdit(SBx_Scroll.Controls[i-1]).Text)='') then
    begin
      bOk := false;
      TEdit(SBx_Scroll.Controls[i-1]).SetFocus;
      TEdit(SBx_Scroll.Controls[i-1]).SelectAll;
      MessageDlg('Champ obligatoire !', mterror, [mbok], 0);
    end;
    inc(i);
  end;
  if not(bOk) then
  begin
    ModalResult := mrnone;
    exit;
  end;

  With Dm_Main do
  begin
    cds_SortieOut.EmptyDataSet;
    for i:= 1 to SBx_Scroll.ControlCount do
    begin
      if (SBx_Scroll.Controls[i-1] is TEdit)
          and (TEdit(SBx_Scroll.Controls[i-1]).Tag>0) then
      begin
        iTag := TEdit(SBx_Scroll.Controls[i-1]).Tag;
        sChamp := TEdit(SBx_Scroll.Controls[i-1]).Text;
        bOk := false;
        LNumParam := 0;
        j := 1;
        while not(bOk) and (i<=SBx_Scroll.ControlCount) do
        begin
          if (SBx_Scroll.Controls[j-1] is TCombobox)
              and (TCombobox(SBx_Scroll.Controls[j-1]).Tag=iTag) then
          begin
            LIndex := TCombobox(SBx_Scroll.Controls[j-1]).ItemIndex;
            LNumParam := StrtoIntDef(LstNumParam[LIndex], 0);
            bOk := true;
          end;
          Inc(j);
        end;
        cds_SortieOut.Append;
        cds_SortieOut.FieldByName('NomChamp').AsString := sChamp;
        cds_SortieOut.FieldByName('NumParam').AsInteger := LNumParam;
        cds_SortieOut.Post;
      end;
    end;
  end;

  ModalResult := mrOk;
end;

end.
