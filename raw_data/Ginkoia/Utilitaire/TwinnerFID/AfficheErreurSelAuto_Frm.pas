unit AfficheErreurSelAuto_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, GinkoiaStyle_dm, AdvGlowButton, ExtCtrls, RzPanel,
  DB, dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP, Boxes, PanBtnDbgHP;

type
  TFrm_AfficheErreurSelAuto = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Nbt_Post: TAdvGlowButton;
    Pan_Grille: TRzPanel;
    DBG_LstErr: TdxDBGridHP;
    Ds_LstErr: TDataSource;
    DBG_LstErrRecId: TdxDBGridColumn;
    DBG_LstErrNo: TdxDBGridMaskColumn;
    DBG_LstErrCodeAd: TdxDBGridMaskColumn;
    DBG_LstErrInfoErr: TdxDBGridMaskColumn;
    PanelDbg1: TPanelDbg;
    procedure Nbt_PostClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_AfficheErreurSelAuto: TFrm_AfficheErreurSelAuto;

implementation

uses
  Twinner_Dm;

{$R *.dfm}

procedure TFrm_AfficheErreurSelAuto.Nbt_PostClick(Sender: TObject);
begin
  Close;
end;

end.
