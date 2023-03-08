unit CFGDir_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,dxSkiniMaginary, cxGroupBox,
  cxRadioGroup, AdvGlowButton, StdCtrls, RzLabel, ExtCtrls, RzPanel, Mask,
  DBCtrls, Main_DM, FileCtrl, StdActns, uCommon, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, cxCheckBox, cxDBEdit;

type
  Tfrm_CFGDir = class(TAlgolDialogForm)
    cxRg_Transfert: TcxRadioGroup;
    cxGB_TypeTransfert: TcxGroupBox;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_Ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Lab_Source: TLabel;
    Lab_Dest: TLabel;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    cxDBCheckBox1: TcxDBCheckBox;
    Lab_LogonUser: TLabel;
    Lab_LogonPassword: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    procedure AlgolDialogFormShow(Sender: TObject);
    procedure cxRg_TransfertClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AlgolDialogFormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
     sDir : String;
     sCaption ,
     sRoot : String;
  public
    { Déclarations publiques }
    Mode : TModeChx;
  end;

var
  frm_CFGDir: Tfrm_CFGDir;

implementation

{$R *.dfm}

procedure Tfrm_CFGDir.AdvGlowButton1Click(Sender: TObject);
var
  bf : TBrowseForFolder;
begin
  bf := TBrowseForFolder.Create(Self);
  try
    bf.Caption := 'Sélectionner le répertoire source';
    bf.BrowseOptions := [bifNoTranslateTargets,bifNewDialogStyle]; // bifShareable
    if bf.Execute then
      DM_BckMain.cds_ListDirectory.FieldByName('MainDirectory').AsString := bf.Folder;
  finally
    bf.Free;
  end;
end;

procedure Tfrm_CFGDir.AdvGlowButton2Click(Sender: TObject);
var
  bf : TBrowseForFolder;
begin
  bf := TBrowseForFolder.Create(Self);
  try
    bf.Caption := 'Sélectionner le répertoire de destination';
    bf.BrowseOptions := [bifNoTranslateTargets,bifNewDialogStyle];
    if bf.Execute then
      DM_BckMain.cds_ListDirectory.FieldByName('DestDirectory').AsString := bf.Folder;
  finally
    bf.Free;
  end;
end;

procedure Tfrm_CFGDir.AlgolDialogFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult <> mrOk then
    DM_BckMain.cds_ListDirectory.Cancel;
end;

procedure Tfrm_CFGDir.AlgolDialogFormShow(Sender: TObject);
var
  iNum : Integer;
begin
  case Mode of
    mdAdd: begin
      Caption := 'Ajouter';
      DM_BckMain.cds_ListDirectory.DisableControls;
      iNum := 1;
      while DM_BckMain.cds_ListDirectory.Locate('Idx',iNum,[]) do
        Inc(iNum);
      DM_BckMain.cds_ListDirectory.EnableControls;

      DM_BckMain.cds_ListDirectory.Append;
      DM_BckMain.cds_ListDirectory.FieldByName('Idx').AsInteger := iNum;
      DM_BckMain.cds_ListDirectory.FieldByName('TypeTransfert').AsInteger := 0;
      DM_BckMain.cds_ListDirectory.FieldByName('TypeNom').AsString := cxGB_TypeTransfert.Caption;


    end;
    mdEdit: begin
     Caption := 'Modifier';
     DM_BckMain.cds_ListDirectory.Edit;
     cxRg_Transfert.ItemIndex := DM_BckMain.cds_ListDirectory.FieldByName('TypeTransfert').AsInteger;
     cxGB_TypeTransfert.Caption := DM_BckMain.cds_ListDirectory.FieldByName('TypeNom').AsString;
    end;
  end;
end;

procedure Tfrm_CFGDir.cxRg_TransfertClick(Sender: TObject);
begin
  cxGB_TypeTransfert.Caption := TcxRadioGroup(Sender).Properties.Items.Items[TcxRadioGroup(Sender).ItemIndex].Caption;
end;

procedure Tfrm_CFGDir.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_CFGDir.Nbt_PostClick(Sender: TObject);
begin
  With DM_BckMain do
  begin
    cds_ListDirectory.FieldByName('TypeTransfert').AsInteger := cxRg_Transfert.ItemIndex;
    cds_ListDirectory.FieldByName('TypeNom').AsString := cxGB_TypeTransfert.Caption;
    DM_BckMain.cds_ListDirectory.Post;
  end;
  ModalResult := mrOk;
end;

end.
