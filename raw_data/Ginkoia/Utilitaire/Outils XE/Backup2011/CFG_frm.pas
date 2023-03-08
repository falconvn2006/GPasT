unit CFG_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, GinPanel, AdvGlowButton, StdCtrls, RzLabel, Grids,
  AdvObj, BaseGrid, AdvGrid, DBAdvGrid, Main_DM, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, AdvOfficePager, uCommon, CFGDir_frm, CFGExt_frm,
  DBGrids, cxContainer, cxTextEdit, cxMaskEdit, cxSpinEdit, CFGExc_frm, IniFiles,
  cxCheckBox;

type
  Tfrm_CFG = class(TForm)
    GinPanel1: TGinPanel;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_Ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Pan_PRMMain: TRzPanel;
    Pan_PRMClient: TRzPanel;
    Pan_PRMBottom: TRzPanel;
    Pan_PRMLeft: TRzPanel;
    Pan_PRMRight: TRzPanel;
    GinPanel2: TGinPanel;
    GinPanel3: TGinPanel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxGrid2Level1: TcxGridLevel;
    cxGrid2: TcxGrid;
    cxGrid1DBTableView1Idx: TcxGridDBColumn;
    cxGrid1DBTableView1MainDirectory: TcxGridDBColumn;
    cxGrid1DBTableView1DestDirectory: TcxGridDBColumn;
    cxGrid2DBTableView1Idx: TcxGridDBColumn;
    cxGrid2DBTableView1ExtName: TcxGridDBColumn;
    cxGrid2DBTableView1SourceDelete: TcxGridDBColumn;
    cxGrid2DBTableView1DestZip: TcxGridDBColumn;
    Pan_DirEdit: TRzPanel;
    Pan_DirEdit2: TRzPanel;
    nbt_DirDel: TAdvGlowButton;
    Pan_ExtEdit: TRzPanel;
    Pan_ExtEdit2: TRzPanel;
    nbt_DirAdd: TAdvGlowButton;
    nbt_DirEdit: TAdvGlowButton;
    nbt_ExtAdd: TAdvGlowButton;
    nbt_ExtEdit: TAdvGlowButton;
    nbt_ExtDel: TAdvGlowButton;
    cxGrid1DBTableView1TypeTransfert: TcxGridDBColumn;
    cxGrid1DBTableView1TypeNom: TcxGridDBColumn;
    cxGrid2DBTableView1SplitZip: TcxGridDBColumn;
    cxGrid2DBTableView1Versionning: TcxGridDBColumn;
    Pan_Bottomright: TRzPanel;
    GinPanel5: TGinPanel;
    Pan_BottomLeft: TRzPanel;
    GinPanel4: TGinPanel;
    Lab_NbThread: TLabel;
    Lab_Aide: TLabel;
    cxse_NbThread: TcxSpinEdit;
    Pan_ExcludeBottom: TRzPanel;
    pan_Exclude: TRzPanel;
    nbt_ExcAdd: TAdvGlowButton;
    nbt_ExcEdit: TAdvGlowButton;
    nbt_ExcDel: TAdvGlowButton;
    cxGrid3DBTableView1: TcxGridDBTableView;
    cxGrid3Level1: TcxGridLevel;
    cxGrid3: TcxGrid;
    cxGrid3DBTableView1FileName: TcxGridDBColumn;
    chk_GkMode: TcxCheckBox;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure nbt_DirAddClick(Sender: TObject);
    procedure nbt_ExtAddClick(Sender: TObject);
    procedure nbt_ExcAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    procedure HideParentPage;
  public
    { Déclarations publiques }
  end;

var
  frm_CFG: Tfrm_CFG;

implementation

{$R *.dfm}

procedure Tfrm_CFG.nbt_DirAddClick(Sender: TObject);
begin
  case TControl(Sender).Tag of
    0,1: begin // bouton d'ajout et d'édition
      With Tfrm_CFGDir.Create(Self) do
      try
        case TControl(Sender).Tag of
          0: Mode := mdAdd;
          1: Mode := mdEdit;
        end;
        ShowModal;
      finally
        Release;
      end; // With/Try
    end; // 1
    2: begin // bouton de suppression
      With DM_BckMain do
      begin
       if MessageDlg('Etes vous sûr de vouloir supprimer cette configuration ? (Répertoire + Extension)',mtConfirmation,[mbYes,mbNo],0) = mrYes then
       begin
        cds_ListExtensionFile.First;
        while not cds_ListExtensionFile.Eof do
          if cds_ListExtensionFile.FieldByName('Idx').AsInteger = cds_ListDirectory.FieldByName('Idx').AsInteger then
            cds_ListExtensionFile.Delete
          else
            cds_ListExtensionFile.Next;

        cds_ListDirectory.Delete;
       end;
      end; // with
    end; // 2
  end; // case
end;

procedure Tfrm_CFG.nbt_ExcAddClick(Sender: TObject);
begin
  case TControl(Sender).Tag of
    0,1: begin // Gestion des boutons d'ajout et d'édition
      With Tfrm_CFGExc.Create(Self) do
        try
          case TControl(Sender).Tag of
            0: DM_BckMain.cds_ExcludeList.Append;
            1: DM_BckMain.cds_ExcludeList.Edit;
          end;
          if ShowModal = mrOk then
            DM_BckMain.cds_ExcludeList.Post
          else
            DM_BckMain.cds_ExcludeList.Cancel;
        finally
          Release;
        end; // With/Try
    end;
    2: begin // gestion du bouton de suppression
      With DM_BckMain do
      if MessageDlg('Etes vous sûr de vouloir supprimer cette exclusion (' + cds_ExcludeList.FieldByName('FileName').AsString + ') ?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
        cds_ExcludeList.Delete;
    end;
  end;
end;

procedure Tfrm_CFG.nbt_ExtAddClick(Sender: TObject);
begin
  case TControl(Sender).Tag of
    0, 1: begin // Gestion des boutons d'ajout et d'édition
      With Tfrm_CFGExt.Create(Self) do
        try
          case TControl(Sender).Tag of
            0: begin
              Mode := mdAdd;
              ParentDirID := DM_BckMain.cds_ListDirectory.FieldByName('Idx').AsInteger;
            end;
            1: Mode := mdEdit;
          end;
          ShowModal;
        finally
          Release;
        end; // With/Try
    end; // 0,1
    2: begin // gestion du bouton de suppression
      With DM_BckMain do
      if MessageDlg('Etes vous sûr de vouloir supprimer cette extension (' + cds_ListExtensionFile.FieldByName('ExtName').AsString + ') ?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
        cds_ListExtensionFile.Delete;
    end; // 2
  end; // case
end;

procedure Tfrm_CFG.FormShow(Sender: TObject);
begin
  cxse_NbThread.Value := MainCfg.NbThread;
  chk_GkMode.Checked  := MainCfg.GinkoiaMode;
end;

procedure Tfrm_CFG.HideParentPage;
begin
  FCanChangePage := True;
  if Self.parent.InheritsFrom(TAdvOfficePage) then
  begin
    TAdvOfficePage(Self.parent).TabVisible := False;
    TAdvOfficePager(TAdvOfficePage(Self.parent).Parent).ActivePageIndex := 0;
  end;
  FCanChangePage := False;
end;

procedure Tfrm_CFG.Nbt_CancelClick(Sender: TObject);
begin
  HideParentPage;
  DM_BckMain.LoadConfig;
  MainCfg.LoadConfig;
end;

procedure Tfrm_CFG.Nbt_PostClick(Sender: TObject);
begin
  HideParentPage;
  DM_BckMain.SaveConfig;
  MainCfg.NbThread :=  cxse_NbThread.Value;
  MainCfg.ginkoiaMode := chk_GkMode.Checked;
  MainCfg.SaveConfig;
end;

end.
