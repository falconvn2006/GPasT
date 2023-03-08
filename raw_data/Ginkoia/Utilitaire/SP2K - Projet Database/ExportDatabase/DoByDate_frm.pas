unit DoByDate_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, Db, ExtCtrls, ComCtrls, AdvDateTimePicker,
  StdCtrls, AdvGlowButton, RzPanel, Grids, DBGrids, ADODB, dxTL, dxDBCtrl,
  dxDBGrid, dxCntner, Spin;

type
  TModeCheck = (mcAll, mcPartial);
  TTypeAction = (taDate, taKVersion);

  TOptionAction = (oaArticle, oaMvt, oaCB, oaFidelite, oaCorrMvt, oaStock);
  TOptionActions = set of TOptionAction;

  TOptionMvt = (om1, om2, om3, om4, om5, om6, om7, om8, om9, om10, om11, om12, om13, om14);
  ToptionMvts = set of TOptionMvt;

  Tfrm_DoByDate = class(TAlgolDialogForm)
    Gbx_Left: TGroupBox;
    Pan_Right: TPanel;
    Gbx_Date: TGroupBox;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    Lab_DateDebut: TLabel;
    Lab_DateFin: TLabel;
    adt_debut: TAdvDateTimePicker;
    adt_fin: TAdvDateTimePicker;
    Rgr_Choix: TRadioGroup;
    Ds_LstDossiers: TDataSource;
    dxDBGrid1: TdxDBGrid;
    dxDBGrid1Column1: TdxDBGridColumn;
    dxDBGrid1Column2: TdxDBGridColumn;
    dxDBGrid1Column3: TdxDBGridColumn;
    Gbx_ListActions: TGroupBox;
    Chk_MajArticle: TCheckBox;
    Chk_MajMouvement: TCheckBox;
    Chk_1: TCheckBox;
    Chk_2: TCheckBox;
    Chk_3: TCheckBox;
    Chk_4: TCheckBox;
    Chk_5: TCheckBox;
    Chk_6: TCheckBox;
    Chk_7: TCheckBox;
    Chk_8: TCheckBox;
    Chk_9: TCheckBox;
    Chk_10: TCheckBox;
    Chk_11: TCheckBox;
    Chk_12: TCheckBox;
    Chk_13: TCheckBox;
    Chk_14: TCheckBox;
    Gbx_SansPeriode: TGroupBox;
    Chk_Correctionfidelite: TCheckBox;
    GroupBox1: TGroupBox;
    Chk_MajCB: TCheckBox;
    Chk_CorrMvt: TCheckBox;
    chk_GestionStock: TCheckBox;
    dxDBGrid1Column4: TdxDBGridColumn;
    dxDBGrid1Column5: TdxDBGridColumn;
    rb_date: TRadioButton;
    rb_KVersion: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Chp_Debut: TSpinEdit;
    Chp_Fin: TSpinEdit;
    procedure Rgr_ChoixClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function DoByDateFormShow(ADataset : TADOQuery; var AModeCheck : TModeCheck;  var ATypeAction : TTypeAction; var ADebut, AFin : Variant; var AOptionActions : TOptionActions; var AOptionMvt : ToptionMvts) : TModalResult;
  end;

var
  frm_DoByDate: Tfrm_DoByDate;


implementation

{$R *.dfm}

{ TForm1 }
function Tfrm_DoByDate.DoByDateFormShow(ADataset : TADOQuery; var AModeCheck : TModeCheck; var ATypeAction : TTypeAction; var ADebut, AFin : Variant; var AOptionActions : TOptionActions; var AOptionMvt : ToptionMvts) : TModalResult;
var
  i: Integer;
begin
  Ds_LstDossiers.DataSet := ADataset;
  Result := ShowModal;

  if rb_date.Checked then
  begin
    ADebut := adt_debut.Date;
    AFin := adt_fin.Date;
    ATypeAction := taDate;
  end
  else begin
    ADebut := chp_Debut.Value;
    AFin := chp_fin.Value;
    ATypeAction := taKVersion;
  end;

  case Rgr_Choix.ItemIndex of
    0 : AModeCheck := mcAll;
    1 : AModeCheck := mcPartial;
  end;

  AOptionActions := [];

  if Chk_MajArticle.Checked then
    AOptionActions := AOptionActions + [oaArticle];

  if Chk_MajMouvement.Checked then
    AOptionActions := AOptionActions + [oaMvt];

  if Chk_MajCB.Checked then
    AOptionActions := AOptionActions + [oaCB];

  if Chk_Correctionfidelite.Checked then
    AOptionActions := AOptionActions + [oaFidelite];

  if Chk_CorrMvt.Checked then
    AOptionActions := AOptionActions + [oaCorrMvt];

  if chk_GestionStock.Checked then
    AOptionActions := AOptionActions + [oaStock];

  AOptionMvt := [];
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i].Tag > 0 then
    begin
      if Components[i] is TCheckBox and TCheckBox(Components[i]).Checked then
        AOptionMvt := AOptionMvt + [ToptionMvt(Ord(Components[i].Tag - 1))];
    end;
  end;


end;


procedure Tfrm_DoByDate.Rgr_ChoixClick(Sender: TObject);
begin
  case Rgr_Choix.ItemIndex of
    0: dxDBGrid1.OptionsBehavior := dxDBGrid1.OptionsBehavior - [edgoMultiSelect];
     else
      dxDBGrid1.OptionsBehavior := dxDBGrid1.OptionsBehavior + [edgoMultiSelect];
  end;

end;

end.
