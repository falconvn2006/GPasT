unit ParamEntree_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, StdCtrls, GinkoiaStyle_Dm, AdvGlowButton, RzLabel,
  ExtCtrls, RzPanel, DB, Grids, DBGrids;

type
  TFrm_ParamEntree = class(TAlgolDialogForm)
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
    procedure AlgolDialogFormDestroy(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
  private
    { Déclarations privées }
    LstNumParam: TStringList;
  public
    { Déclarations publiques }
  end;

var
  Frm_ParamEntree: TFrm_ParamEntree;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_ParamEntree.AlgolDialogFormCreate(Sender: TObject);
var
  LstParam: TStringList;
  X1, X2: integer;
  DecalY: integer;
  Y: integer;
  iTag: integer;
  LIndex: integer;
begin
  X1 := Lab_TitIn.Left;
  X2 := Lab_TitParam.Left;
  Y := 33;    // label = +3
  DecalY := 35;
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
    cds_EntreeIn.First;
    while not(cds_EntreeIn.Eof) do
    begin
      With TLabel.Create(Self) do
      begin
        Parent := SBx_Scroll;
        Left := X1;
        Top := y +3;
        Caption := cds_EntreeIn.FieldByName('NomParam').AsString;
      end;
      With TCombobox.Create(Self) do
      begin
        Parent := SBx_Scroll;
        Left := X2;
        Top := y;
        Width := 250;
        Items.AddStrings(LstParam);
        Tag := iTag;
        Style := csDropDownList;
        LIndex := LstNumParam.IndexOf(IntToStr(cds_EntreeIn.FieldByName('NumParam').AsInteger));
        if LIndex<0 then
          LIndex := 0;
        ItemIndex := LIndex;
      end;
      inc(iTag);
      y := y+DecalY;
      cds_EntreeIn.Next;
    end;

  end;


end;

procedure TFrm_ParamEntree.AlgolDialogFormDestroy(Sender: TObject);
begin
  FreeAndNil(LstNumParam);
end;

procedure TFrm_ParamEntree.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_ParamEntree.Nbt_PostClick(Sender: TObject);
var
  i: integer;
  iTag: integer;
  LIndex: integer;
  LNumParam: integer;
begin
  for i := 1 to SBx_Scroll.ControlCount do
  begin
    if (SBx_Scroll.Controls[i-1] is TCombobox) then
    begin
      iTag := TCombobox(SBx_Scroll.Controls[i-1]).Tag;
      if iTag>0 then
      begin
        LIndex := TCombobox(SBx_Scroll.Controls[i-1]).ItemIndex;
        LNumParam := StrtoIntDef(LstNumParam[LIndex], 0);
        Dec(iTag);
        Dm_Main.cds_EntreeIn.First;
        if iTag>0 then
          Dm_Main.cds_EntreeIn.MoveBy(iTag);
        Dm_Main.cds_EntreeIn.Edit;
        Dm_Main.cds_EntreeIn.fieldbyname('NumParam').AsInteger := LNumParam;
        Dm_Main.cds_EntreeIn.Post;
      end;
    end;
  end;
  ModalResult := mrOk;
end;

end.
