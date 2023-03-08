unit CFGExt_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, Main_DM, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue, cxCheckBox,
  cxDBEdit, AdvGlowButton, RzLabel, ExtCtrls, RzPanel, StdCtrls, Mask, DBCtrls,
  cxGroupBox, uCommon;

type
  Tfrm_CFGExt = class(TAlgolDialogForm)
    cxGB_TypeTransfert: TcxGroupBox;
    Lab_Extension: TLabel;
    DBEdit1: TDBEdit;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_Ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    cxDBCheckBox1: TcxDBCheckBox;
    cxDBCheckBox2: TcxDBCheckBox;
    cxDBCheckBox3: TcxDBCheckBox;
    cxDBCheckBox4: TcxDBCheckBox;
    Lab_ExtDesciption: TLabel;
    procedure AlgolDialogFormShow(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure AlgolDialogFormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Mode : TModeChx;
    ParentDirID : Integer;
  end;

var
  frm_CFGExt: Tfrm_CFGExt;

implementation

{$R *.dfm}

procedure Tfrm_CFGExt.AlgolDialogFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult <> mrOk then
    DM_BckMain.cds_ListExtensionFile.Cancel;
end;

procedure Tfrm_CFGExt.AlgolDialogFormShow(Sender: TObject);
begin
  case Mode of
    mdAdd: begin
      Caption := 'Ajouter une nouvelle extension';
      DM_BckMain.cds_ListExtensionFile.Append;
      DM_BckMain.cds_ListExtensionFile.FieldByName('Idx').AsInteger;
      DM_BckMain.cds_ListExtensionFile.FieldByName('sourceDelete').AsBoolean := False;
      DM_BckMain.cds_ListExtensionFile.FieldByName('DestZip').AsBoolean := False;
      DM_BckMain.cds_ListExtensionFile.FieldByName('SplitZip').AsBoolean := False;
      DM_BckMain.cds_ListExtensionFile.FieldByName('Versionning').AsBoolean := False;
    end;
    mdEdit: begin
     Caption := 'Modifier l''extention';
     DM_BckMain.cds_ListExtensionFile.Edit;
    end;
  end;
end;

procedure Tfrm_CFGExt.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_CFGExt.Nbt_PostClick(Sender: TObject);
begin
  DM_BckMain.cds_ListExtensionFile.Post;
  ModalResult := mrOk;
end;

end.
