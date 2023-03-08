unit AdminMag_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Mask, RzEdit, RzDBEdit, RzDBBnEd, RzDBButtonEditRv,
  RzLabel, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, ExtCtrls, RzPanel, RzPanelRv, ADODB,
  wwDialog, wwidlg, wwLookupDialogRv, dxGrClEx, dxDBTLCl, dxGrClms, dxTL,
  dxDBCtrl, dxDBGrid, dxCntner, dxDBGridHP, Boxes, PanBtnDbgHP, DBCtrls;

type
  TFrm_AdminMag = class(TForm)
    RzPanelRv1: TRzPanelRv;
    SBtn_Quit: TLMDSpeedButton;
    RzPanelRv2: TRzPanelRv;
    RzLabel1: TRzLabel;
    RzDBButtonEditRv1: TRzDBButtonEditRv;
    ds_qcol: TDataSource;
    Lab_: TRzLabel;
    Chp_: TRzDBButtonEditRv;
    LK_uni: TwwLookupDialogRV;
    Ds_uni: TDataSource;
    Ds_mag: TDataSource;
    Pan_Mag: TPanelDbg;
    DBG_Mag: TdxDBGridHP;
    DBG_Magmag_id: TdxDBGridMaskColumn;
    DBG_Magmag_code: TdxDBGridMaskColumn;
    DBG_Magmag_nom: TdxDBGridMaskColumn;
    DBG_Magmag_ville: TdxDBGridMaskColumn;
    DBG_Magmag_actif: TdxDBGridCheckColumn;
    DBG_Magmag_dateactivation: TdxDBGridButtonColumn;
    DBG_Magmag_cheminbase: TdxDBGridExtLookupColumn;
    DBG_MagColumn8: TdxDBGridMaskColumn;
    Lk_Col: TwwLookupDialogRV;
    RzLabel2: TRzLabel;
    RzDBButtonEditRv2: TRzDBButtonEditRv;
    RzPanel1: TRzPanel;
    Nbt_ins: TLMDSpeedButton;
    Nbt_modif: TLMDSpeedButton;
    procedure SBtn_QuitClick(Sender: TObject);
    procedure RzDBButtonEditRv1ButtonClick(Sender: TObject);
    procedure DBG_MagDblClick(Sender: TObject);
    procedure Chp_ButtonClick(Sender: TObject);
    procedure Nbt_insClick(Sender: TObject);
    procedure Nbt_modifClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_AdminMag: TFrm_AdminMag;

implementation

uses Catmarque_frm, Catmarque_dm, InsMag_frm;

{$R *.dfm}

procedure TFrm_AdminMag.Chp_ButtonClick(Sender: TObject);
begin

ds_uni.DataSet.last;
ds_uni.DataSet.first;
application.ProcessMessages;
lk_uni.execute;
end;

procedure TFrm_AdminMag.DBG_MagDblClick(Sender: TObject);
begin

ExecuteCatmarque(ds_mag.dataset.fieldbyname('mag_id').asinteger,ds_qcol.dataset.fieldbyname('col_id').asinteger);



end;

procedure TFrm_AdminMag.Nbt_insClick(Sender: TObject);
begin
executeInsmag(0);
ds_mag.dataset.Close;
ds_mag.dataset.open;

end;

procedure TFrm_AdminMag.Nbt_modifClick(Sender: TObject);
var id:integer;
begin

id:=ds_mag.dataset.fieldbyname('mag_id').asinteger;
executeInsmag(id);
ds_mag.dataset.Close;
ds_mag.dataset.open;
ds_mag.DataSet.Locate('mag_id',id,[]);

end;

procedure TFrm_AdminMag.RzDBButtonEditRv1ButtonClick(Sender: TObject);
begin

lk_col.execute;
end;

procedure TFrm_AdminMag.SBtn_QuitClick(Sender: TObject);
begin
  application.terminate;
end;

end.
