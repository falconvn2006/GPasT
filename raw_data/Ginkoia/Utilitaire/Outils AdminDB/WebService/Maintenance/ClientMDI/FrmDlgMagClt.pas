unit FrmDlgMagClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, Grids, DBGrids, StdCtrls, Mask, DBCtrls, DBClient,
  Buttons, ExtCtrls, DB, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dmdClient, FrameToolBar, cxDropDownEdit, cxCheckBox, cxTextEdit,
  dblookup;

type
  TDlgMagCltFrm = class(TCustomGinkoiaDlgFrm)
    DsMagasin: TDataSource;
    pnlTop: TPanel;
    DBText1: TDBText;
    Lab_5: TLabel;
    PgCtrlMag: TcxPageControl;
    TbShtMag: TcxTabSheet;
    TbShtModuleActif: TcxTabSheet;
    Lab_1: TLabel;
    Lab_2: TLabel;
    Lab_3: TLabel;
    DBEDT_MAGIDENTCOURT: TDBEdit;
    DBEDT_MAGNOM: TDBEdit;
    DBEDT_MAGENSEIGNE: TDBEdit;
    DsModuleActif: TDataSource;
    cxGrid1: TcxGrid;
    cxGridTWModuleActif: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    cxGridTWModuleActifMODU_ID: TcxGridDBColumn;
    cxGridTWModuleActifMODU_NOM: TcxGridDBColumn;
    cxGridTWModuleActifMMAG_EXPDATE: TcxGridDBColumn;
    TlBrFrameModules: TToolBarFrame;
    TbShtSaisieParLot: TcxTabSheet;
    cxGridSaisieParLot: TcxGrid;
    cxGridSaisieParLotDBTableViewSaisieParLot: TcxGridDBTableView;
    cxGridSaisieParLotDBTableViewSaisieParLotMAGA_NOM: TcxGridDBColumn;
    cxGridSaisieParLotDBTableViewSaisieParLotMAG_IDENT: TcxGridDBColumn;
    cxGridSaisieParLotDBTableViewSaisieParLotMAGA_ENSEIGNE: TcxGridDBColumn;
    cxGridSaisieParLotDBTableViewSaisieParLotMAG_IDENTCOURT: TcxGridDBColumn;
    cxGridSaisieParLotDBTableViewSaisieParLotMAG_NATURE: TcxGridDBColumn;
    cxGridSaisieParLotDBTableViewSaisieParLotMAG_SS: TcxGridDBColumn;
    cxGridSaisieParLotLevel1: TcxGridLevel;
    DsSociete: TDataSource;
    ChkBxSiegeSociale: TCheckBox;
    RdGrpNature: TRadioGroup;
    Lab_MagaCodeAdh: TLabel;
    DBEDT_MAGACODEADH: TDBEdit;
    Lab_GroupPump: TLabel;
    DsGrpPump: TDataSource;
    Cb_GroupPump: TComboBox;
    Chk_GrpPump: TCheckBox;
    cxGridSaisieParLotDBTableViewSaisieParLotMAGA_CODEADH: TcxGridDBColumn;
    Lab_Base: TLabel;
    Cb_Mag_Basid: TComboBox;
    DsEmetteur: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TbShtModuleActifShow(Sender: TObject);
    procedure cxGridTWModuleActifDblClick(Sender: TObject);
    procedure TlBrFrameModulesActInsertExecute(Sender: TObject);
    procedure TlBrFrameModulesActUpdateExecute(Sender: TObject);
    procedure TlBrFrameModulesActDeleteExecute(Sender: TObject);
    procedure SpdBtnOkClick(Sender: TObject);
    procedure Chk_GrpPumpClick(Sender: TObject);
    procedure Cb_GroupPumpChange(Sender: TObject);
    procedure Cb_GroupPumpKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBEDT_MAGNOMExit(Sender: TObject);
    procedure cxGridSaisieParLotDBTableViewSaisieParLotEditValueChanged(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure DBEDT_MAGENSEIGNEClick(Sender: TObject);
  private
    FdmClient: TdmClient;
    FCDS_ListMAG: TClientDataSet;
    FIsSaisieParLot: Boolean;
    procedure ShowDetailModuleActif(const AAction: TUpdateKind);
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
    property IsSaisieParLot: Boolean read FIsSaisieParLot write FIsSaisieParLot;
  end;

var
  DlgMagCltFrm: TDlgMagCltFrm;

implementation

uses FrmDlgModClt, dmdClients, FrmClients, uConst, uTool;

{$R *.dfm}

procedure TDlgMagCltFrm.Cb_GroupPumpChange(Sender: TObject);
begin
  inherited;
  if Cb_GroupPump.ItemIndex <> -1 then
  begin
    Chk_GrpPump.Enabled := False;
  end
  else
    Chk_GrpPump.Enabled := True;
end;

procedure TDlgMagCltFrm.Cb_GroupPumpKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_DELETE then
  begin
    Cb_GroupPump.ItemIndex:= -1;
    Chk_GrpPump.Enabled := True;
  end;
end;

procedure TDlgMagCltFrm.Chk_GrpPumpClick(Sender: TObject);
begin
  inherited;
  if(Chk_GrpPump.Checked)then
    Cb_GroupPump.Enabled := False
  else
    Cb_GroupPump.Enabled := True;
end;

procedure TDlgMagCltFrm.cxGridSaisieParLotDBTableViewSaisieParLotEditValueChanged(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  inherited;
//  if AItem.EditValue = '' then
//    DBEDT_MAGENSEIGNE.Text := DBEDT_MAGNOM.Text;
end;

procedure TDlgMagCltFrm.cxGridTWModuleActifDblClick(Sender: TObject);
begin
  inherited;
  TlBrFrameModules.ActUpdate.Execute;
end;

procedure TDlgMagCltFrm.DBEDT_MAGENSEIGNEClick(Sender: TObject);
begin
  inherited;
  if DBEDT_MAGENSEIGNE.Text = '' then
  begin
    DsMagasin.DataSet.FieldByName('MAGA_ENSEIGNE').AsString := DBEDT_MAGNOM.Text;
  end;
end;

procedure TDlgMagCltFrm.DBEDT_MAGNOMExit(Sender: TObject);
begin
  inherited;
  if DBEDT_MAGENSEIGNE.Text = '' then
  begin
    DsMagasin.DataSet.FieldByName('MAGA_ENSEIGNE').AsString := DBEDT_MAGNOM.Text;
  end;
end;

procedure TDlgMagCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
  FIsSaisieParLot:= False;
  TlBrFrameModules.ConfirmDelete:= True;
  RdGrpNature.Items.Text:= dmClient.GetListMAG_NATURE;
  RdGrpNature.ItemIndex:= -1;
end;

procedure TDlgMagCltFrm.FormShow(Sender: TObject);
var
  vGen: TGenerique;
begin
  inherited;
  DsSociete.DataSet:= FdmClient.CDS_SOC;
  DsMagasin.DataSet:= FdmClient.CDS_MAG;
  DsModuleActif.DataSet:= FdmClient.CDSModuleActif;
  cxGridSaisieParLotDBTableViewSaisieParLot.DataController.DataSource:= nil;

  { Chargement de la liste des groupes de Pump }
  dmClients.XmlToList('GroupPump?DOSS_ID=' + DsSociete.DataSet.FieldByName('DOSS_ID').AsString, 'GCP_NOM', 'GCP_ID', Cb_GroupPump.Items, Self);
  { Chargement de la liste des bases associées au magasin }

  // on parcourt les emetteur et on prends ceux qui ont le bas_magid du magasin sur lequel on est
  //dmClients.XmlToList('GroupPump?DOSS_ID=' + DsSociete.DataSet.FieldByName('DOSS_ID').AsString, 'GCP_NOM', 'GCP_ID', Cb_GroupPump.Items, Self);

  //ShowMessage(IntToStr(DsMagasin.DataSet.FieldByName('MAGA_MAGID_GINKOIA').AsInteger));

  // on propose les sites associés uniquement si c'est une modification

  if (AAction = ukModify) then
  begin
    DsEmetteur.DataSet.First;
    while not DsEmetteur.DataSet.Eof do
    begin
      if (DsEmetteur.DataSet.FieldByName('EMET_MAGID').AsInteger = DsMagasin.DataSet.FieldByName('MAGA_ID').AsInteger) then
      begin
        vGen:= TGenerique.Create(Self);
        vGen.Libelle:= DsEmetteur.DataSet.FieldByName('EMET_NOM').AsString;
        vGen.ID:= DsEmetteur.DataSet.FieldByName('EMET_BASID_GINKOIA').AsInteger;
        Cb_Mag_Basid.AddItem(vGen.Libelle, Pointer(vGen));

        if DsMagasin.DataSet.FieldByName('MAGA_BASID').AsInteger = DsEmetteur.DataSet.FieldByName('EMET_BASID_GINKOIA').AsInteger then
          Cb_Mag_Basid.ItemIndex := Cb_Mag_Basid.Items.IndexOfObject(vGen);

        //Cb_GroupPump.ItemIndex:= dmClients.IndexOfByID(DsMagasin.DataSet.FieldByName('MPU_GCPID').AsInteger, Cb_GroupPump.Items);
      end;

      DsEmetteur.DataSet.Next;
    end;
  end;

  case AAction of
    ukModify:
      begin
        DsMagasin.DataSet.Edit;
        TbShtSaisieParLot.TabVisible:= False;
        RdGrpNature.ItemIndex:= DsMagasin.DataSet.FieldByName('MAG_NATURE').AsInteger;
        ChkBxSiegeSociale.Checked:= DsMagasin.DataSet.FieldByName('MAG_SS').AsInteger = 1;

        //Groupe de Pump
        if DsMagasin.DataSet.FieldByName('MPU_GCPID').AsInteger <> -1 then
        begin
          Chk_GrpPump.Checked := False;
          Chk_GrpPump.Enabled := False;
          Cb_GroupPump.Enabled := True;
          Cb_GroupPump.ItemIndex:= dmClients.IndexOfByID(DsMagasin.DataSet.FieldByName('MPU_GCPID').AsInteger, Cb_GroupPump.Items);
        end
        else
        begin
          Chk_GrpPump.Checked := True;
          Chk_GrpPump.Enabled := True;
          Cb_GroupPump.Enabled := False;
          Cb_GroupPump.ItemIndex:= dmClients.IndexOfByID(-1, Cb_GroupPump.Items);
        end;
      end;
    ukInsert:
      begin
        PgCtrlMag.HideTabs:= True;

        if FIsSaisieParLot then
          begin
            FCDS_ListMAG:= TClientDataSet.Create(Self);
            CloneClientDataSet(FdmClient.CDS_MAG, FCDS_ListMAG, False);
            FCDS_ListMAG.OnNewRecord:= FdmClient.CDS_MAGNewRecord;
            FCDS_ListMAG.FieldByName('MAG_NATURE').OnGetText:= FdmClient.CDS_MAG_MAG_NATUREGetText;
            FCDS_ListMAG.FieldByName('MAG_NATURE').OnSetText:= FdmClient.CDS_MAG_MAG_NATURESetText;
            FCDS_ListMAG.Append;
            FCDS_ListMAG.Post;

            DsMagasin.DataSet:= FCDS_ListMAG;

            TcxComboBoxProperties(cxGridSaisieParLotDBTableViewSaisieParLotMAG_NATURE.Properties).Items.Text:= FdmClient.GetListMAG_NATURE;
            cxGridSaisieParLotDBTableViewSaisieParLot.DataController.DataSource:= DsMagasin;
            PgCtrlMag.ActivePageIndex:= 2;

            //Groupe de Pump
            Chk_GrpPump.Checked := True;
            Cb_GroupPump.Enabled := False;
            Cb_GroupPump.ItemIndex:= dmClients.IndexOfByID(-1, Cb_GroupPump.Items);
          end
        else
          DsMagasin.DataSet.Append;
      end;
    ukDelete: ;
  end;

  if not PgCtrlMag.Pages[0].TabVisible then
    BtnExit:= True;
end;

function TDlgMagCltFrm.PostValues: Boolean;
var
  vSL: TStringList;
begin
  Result:= inherited PostValues;
  vSL:= TStringList.Create;
  try
    try
      vSL.Append('DOSS_ID');
      vSL.Append('MAGA_ID');
      vSL.Append('MAGA_NOM');
      vSL.Append('MAG_SOCID');
      vSL.Append('MAG_IDENT');
      vSL.Append('MAGA_ENSEIGNE');
      vSL.Append('MAGA_MAGID_GINKOIA');
      vSL.Append('MAGA_BASID');
      vSL.Append('MAG_NATURE');
      vSL.Append('MAG_SS');
      vSL.Append('MAGA_CODEADH');
      vSL.Append('MPU_GCPID');
      vSL.Append('ACTION');

      if Trim(DsMagasin.DataSet.FieldByName('MAGA_NOM').AsString) = '' then
        Raise Exception.Create('Le nom du magasin est obligatoire.');

      if Cb_GroupPump.ItemIndex <> -1 then
        DsMagasin.DataSet.FieldByName('MPU_GCPID').AsInteger:= TGenerique(Cb_GroupPump.Items.Objects[Cb_GroupPump.ItemIndex]).ID
      else
        DsMagasin.DataSet.FieldByName('MPU_GCPID').Value:= null;

      //mag_basid
      if Cb_Mag_Basid.ItemIndex <> -1 then
        DsMagasin.DataSet.FieldByName('MAGA_BASID').AsInteger:= TGenerique(Cb_Mag_Basid.Items.Objects[Cb_Mag_Basid.ItemIndex]).ID
      else
        DsMagasin.DataSet.FieldByName('MAGA_BASID').Value:= 0;

      if Chk_GrpPump.Checked then
        DsMagasin.DataSet.FieldByName('MPU_GCPID').Value:= -2;

      if AAction = ukInsert then
        begin
          if DsMagasin.DataSet.State = dsBrowse then
            DsMagasin.DataSet.Edit;

          DsMagasin.DataSet.FieldByName('DOSS_ID').AsInteger:= DsSociete.DataSet.FieldByName('DOSS_ID').AsInteger;
          DsMagasin.DataSet.FieldByName('MAG_SOCID').AsInteger:= DsSociete.DataSet.FieldByName('SOC_ID').AsInteger;
        end;

      DsMagasin.DataSet.FieldByName('MAG_NATURE').AsInteger:= RdGrpNature.ItemIndex;
      DsMagasin.DataSet.FieldByName('MAG_SS').AsInteger:= Integer(ChkBxSiegeSociale.Checked);

      case AAction of     //SR :
        ukModify : DsMagasin.DataSet.FieldByName('ACTION').AsInteger:= cActionModify;
        ukInsert : DsMagasin.DataSet.FieldByName('ACTION').AsInteger:= cActionInsert;
        ukDelete : DsMagasin.DataSet.FieldByName('ACTION').AsInteger:= cActionDelete;
      end;

      dmClients.PostRecordToXml('Magasin', 'TMagasin', TClientDataSet(DsMagasin.DataSet), vSL);
      DsMagasin.DataSet.Post;

      if (AAction = ukInsert) and (FIsSaisieParLot) then
        begin
          DsMagasin.DataSet.Next;
          if DsMagasin.DataSet.Eof then
            begin
              Result:= True;
              Exit;
            end;
          Result:= PostValues;
        end
      else
        Result:= True;

    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TDlgMagCltFrm.ShowDetailModuleActif(const AAction: TUpdateKind);
var
  vDlgModCltFrm: TDlgModCltFrm;
begin
  vDlgModCltFrm:= TDlgModCltFrm.Create(nil);
  try
    vDlgModCltFrm.AAction:= AAction;
    vDlgModCltFrm.AdmClient:= FdmClient;

    if AAction = ukDelete then
      begin
        dmClients.XmlToDataSet('ModuleGinkoia?DOSS_ID=' + FdmClient.CDS_MAG.FieldByName('DOSS_ID').AsString +
                               '&MAGA_MAGID_GINKOIA=' + FdmClient.CDS_MAG.FieldByName('MAGA_MAGID_GINKOIA').AsString +
                               '&ALL=1', FdmClient.CDSModuleDisponible);
        if FdmClient.CDSModuleDisponible.Locate('MODU_ID', FdmClient.CDSModuleActif.FieldByName('MODU_ID').AsInteger, []) then
          begin
            dmClients.DeleteRecordByRessource('ModuleGinkoia?DOSS_ID=' + FdmClient.CDSModuleDisponible.FieldByName('DOSS_ID').AsString +
                                              '&UGM_MAGID=' + FdmClient.CDSModuleDisponible.FieldByName('UGM_MAGID').AsString +
                                              '&UGG_ID=' +  FdmClient.CDSModuleDisponible.FieldByName('UGG_ID').AsString);
            FdmClient.CDSModuleActif.Delete;
          end;
      end
    else
      begin
        if vDlgModCltFrm.ShowModal = mrOk then
          begin
            //-->
          end
        else
          if FdmClient.CDSModuleActif.State <> dsBrowse then
            FdmClient.CDSModuleActif.Cancel;
      end;
  finally
    FreeAndNil(vDlgModCltFrm);
    GIsBrowse:= False;
  end;
end;

procedure TDlgMagCltFrm.SpdBtnOkClick(Sender: TObject);
begin
  inherited;
  if (AAction = ukInsert) and (FIsSaisieParLot) then
    begin
      if DsMagasin.DataSet.State <> dsBrowse then
        DsMagasin.DataSet.Post;

      DsMagasin.DataSet.First;
    end;
end;

procedure TDlgMagCltFrm.TbShtModuleActifShow(Sender: TObject);
begin
  inherited;
  if (FdmClient.CDSModuleActif.RecordCount = 0) and (AAction <> ukInsert) and
     (FdmClient.CDS_MAG.FieldByName('MAGA_ID').AsInteger <> -1) then
    dmClients.XmlToDataSet('Module?MAGA_ID=' + FdmClient.CDS_MAG.FieldByName('MAGA_ID').AsString +
                           '&DOSS_ID=' + FdmClient.CDS_MAG.FieldByName('DOSS_ID').AsString, FdmClient.CDSModuleActif);
end;

procedure TDlgMagCltFrm.TlBrFrameModulesActDeleteExecute(Sender: TObject);
begin
  inherited;
  TlBrFrameModules.ActDeleteExecute(Sender);
  ShowDetailModuleActif(ukDelete);
end;

procedure TDlgMagCltFrm.TlBrFrameModulesActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailModuleActif(ukInsert);
end;

procedure TDlgMagCltFrm.TlBrFrameModulesActUpdateExecute(Sender: TObject);
begin
  inherited;
  ShowDetailModuleActif(ukModify);
end;

end.
