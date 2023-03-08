unit CorrespondMag_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, IBODataset, Grids, DBGrids;

type
  TFrm_CorrespondMag = class(TForm)
    ScrollMag: TScrollBox;
    Panel1: TPanel;
    Nbt_Ok: TBitBtn;
    Nbt_Cancel: TBitBtn;
    Que_Mag: TIBOQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Nbt_OkClick(Sender: TObject);
  private
    { Déclarations privées }
    ListeMag: TStringList;
  public
    { Déclarations publiques }
    procedure InitEcr;
  end;

var
  Frm_CorrespondMag: TFrm_CorrespondMag;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_CorrespondMag.InitEcr;
var
  Y, H: integer;
  CtrlPan: TPanel;
  CtrlGrp: TGroupBox;
begin
  // liste des articles destinations
  Que_Mag.Open;
  while not(Que_Mag.Eof) do
  begin
    with Que_Mag do
    begin
      ListeMag.Add('ID: '+fieldbyname('MAG_ID').AsString+
                   ' - Adh: '+fieldbyname('MAG_CODEADH').AsString+
                   ' - Nom: '+fieldbyname('MAG_NOM').AsString+
                   ' - Enseigne: '+fieldbyname('MAG_ENSEIGNE').AsString);
    end;
    Que_Mag.Next;
  end;
  Que_Mag.Close;

  // correspondance
  H := 132;
  Y := 0;
  with Dm_Main.Cds_MagLiaison do
  begin
    First;
    while not(Eof) do
    begin
      CtrlPan := TPanel.Create(Self);
      With CtrlPan do
      begin
        Parent := ScrollMag;
        SetBounds(0, Y, ScrollMag.Width-22, H);
        Caption := '';
      end;
      CtrlGrp := TGroupBox.Create(Self);
      with CtrlGrp do
      begin
        Parent := CtrlPan;
        SetBounds(12, 8, CtrlPan.Width-24, 73);
        Caption := 'Origine';
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlGrp;
        Font.Style := [fsBold];
        Left := 12;
        Top := 14;
        Caption := 'Mag_ID:';
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlGrp;
        Font.Style := [fsBold];
        Left := 12;
        Top := 33;
        Caption := 'Nom:';
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlGrp;
        Font.Style := [fsBold];
        Left := 12;
        Top := 52;
        Caption := 'Enseigne:';
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlGrp;
        Font.Style := [fsBold];
        Left := 340;
        Top := 14;
        Caption := 'Code adhérent:';
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlGrp;
        Left := 79;
        Top := 14;
        Caption := Fieldbyname('ORI_MAGID').AsString;
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlGrp;
        Left := 79;
        Top := 33;
        Caption := Fieldbyname('ORI_MAGNOM').AsString;
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlGrp;
        Left := 79;
        Top := 52;
        Caption := Fieldbyname('ORI_MAGENSEIGNE').AsString;
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlGrp;
        Left := 438;
        Top := 14;
        Caption := Fieldbyname('ORI_CODEADH').AsString;
      end;
      with TLabel.Create(Self) do
      begin
        Parent := CtrlPan;
        Font.Style := [fsBold];
        Left := 12;
        Top := 84;
        Caption := 'Correspondance:';
      end;
      with TCombobox.Create(Self) do
      begin
        Parent := CtrlPan;
        SetBounds(12, 102, CtrlPan.Width-24, 21);
        Style := csDropDownList;
        Items.AddStrings(ListeMag);
        Name := 'cbs_Corres_'+Fieldbyname('ORI_MAGID').AsString;
      end;
      Y := Y+H;
      Next;
    end;
  end;
end;

procedure TFrm_CorrespondMag.FormCreate(Sender: TObject);
begin
  ListeMag := TStringList.Create;
end;

procedure TFrm_CorrespondMag.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ListeMag);
end;

procedure TFrm_CorrespondMag.Nbt_OkClick(Sender: TObject);
var
  LRet: integer;
  CtrlCombo: TComponent;
  sTemp: string;
  iDstMagId: integer;

  i: integer;
begin
  ModalResult := mrnone;
  with Dm_Main.Cds_MagLiaison do
  begin
    First;
    while not(Eof) do
    begin
      CtrlCombo := Frm_CorrespondMag.FindComponent('cbs_Corres_'+Fieldbyname('ORI_MAGID').AsString);
      if CtrlCombo=nil then
        raise Exception.Create('cbs_Corres_'+Fieldbyname('ORI_MAGID').AsString+' : Composant Combo non trouvé !');
      if not(CtrlCombo is TCombobox) then
        raise Exception.Create('Un autre composant du même nom a été trouvé !');

      iDstMagId := 0;
      LRet := TCombobox(CtrlCombo).ItemIndex;
      if LRet>=0 then
      begin
        sTemp := TCombobox(CtrlCombo).Items[lret];
        sTemp := Copy(sTemp, 5, Length(sTemp));
        if Pos(' - Adh', sTemp)>0 then
          sTemp := Copy(sTemp, 1, Pos(' - Adh', sTemp)-1);
        iDstMagId := StrToIntDef(sTemp, -1);
        Edit;
        fieldbyname('DST_MAGID').AsInteger := iDstMagId;
        Post;
      end
      else
        raise Exception.Create('Un ou plusieurs magasins ne sont pas affecté !');
      Next;
    end;
  end;
  ModalResult := mrok;
end;

end.
