unit MSS_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Inifiles, MSS_Type, MSS_DM, StdCtrls, ComCtrls, CategoryButtons,
  ExtCtrls, DB, Grids, DBGrids, StrUtils, MSS_SizesClass, MSS_UniversCriteriaClass,
  MSS_FedasClass, MSS_CommandeClass, MSS_OpCommsClass, MSS_DMDbMag, MSS_CFGBases,
  MSS_CFGParams;

type
  Tfrm_MSSMain = class(TForm)
    Pgc_Main: TPageControl;
    CategoryButtons1: TCategoryButtons;
    Tab_Logs: TTabSheet;
    mmLogs: TMemo;
    Tim_MSS: TTimer;
    OD_Base: TOpenDialog;
    Gbx_Progress: TGroupBox;
    lab_Text: TLabel;
    pb_Encours: TProgressBar;
    Lab_Encours: TLabel;
    Tab_FileData: TTabSheet;
    Pan_Top: TPanel;
    cbo_File: TComboBox;
    Lab_Choix: TLabel;
    Ds_FileList: TDataSource;
    DBGrid1: TDBGrid;
    Pan_SSTable: TPanel;
    Lab_SSTable: TLabel;
    cbo_sstable: TComboBox;
    Tab_GroupData: TTabSheet;
    Pan_GroupTop: TPanel;
    Lab_GroupCxFile: TLabel;
    cbo_CxFileGroup: TComboBox;
    Lab_CxGroupTable: TLabel;
    cbo_CxGroupeTable: TComboBox;
    DBGrid2: TDBGrid;
    Ds_GroupData: TDataSource;
    Tab_CfgBases: TTabSheet;
    Tab_Params: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Tim_MSSTimer(Sender: TObject);
    procedure DoExecuteAllOnClick(Sender: TObject);
    procedure DoExecuteOneOnclick(Sender: TObject);
    procedure DoLoadFileFTPOnClick(Sender: TObject);
    procedure DoShowMasterFileOnClick(Sender: TObject);
    procedure cbo_FileSelect(Sender: TObject);
    procedure DoLoadFileLocalOnclick(Sender: TObject);
    procedure cbo_sstableSelect(Sender: TObject);
    procedure DoShowGroupFileOnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbo_CxFileGroupSelect(Sender: TObject);
    procedure CategoryButtons1CategoryCollapase(Sender: TObject;
      const Category: TButtonCategory);
    procedure DoParamsOnClick(Sender: TObject);
    procedure Pgc_MainChanging(Sender: TObject; var AllowChange: Boolean);
    procedure DoGestBaseClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_MSSMain: Tfrm_MSSMain;

implementation

uses UVersion;

{$R *.dfm}

procedure Tfrm_MSSMain.DoExecuteAllOnClick(Sender: TObject);
begin
  if not bEnTraitement then
  begin
    bEnTraitement := True;
    Tab_FileData.TabVisible := False;
    Tab_GroupData.TabVisible := False;
    Pgc_Main.ActivePageIndex := 0;
    DM_MSS.ExecuteProcess;
    bEnTraitement := False;
  end;
end;

procedure Tfrm_MSSMain.DoExecuteOneOnclick(Sender: TObject);
begin
  if not bEnTraitement then
  begin
    bEnTraitement := True;
    Tab_FileData.TabVisible := False;
    Tab_GroupData.TabVisible := False;
    Pgc_Main.ActivePageIndex := 0;
    if OD_Base.Execute then
      DM_MSS.ExecuteProcess(OD_Base.FileName);
    bEnTraitement := False;
  end;
end;

procedure Tfrm_MSSMain.DoGestBaseClick(Sender: TObject);
var
  bFound : Boolean;
begin
  if bEnTraitement then
    Exit;

  Tab_CfgBases.TabVisible := True;
  if  Tab_CfgBases.ComponentCount <= 0  then
  begin
    With Tfrm_CFGBases.Create(Tab_CfgBases) do
    begin
      Parent := Tab_CfgBases;
      Align := alClient;
      Visible := True;
    end;
  end;
  bEnTraitement := True;
  Pgc_Main.ActivePage := Tab_CfgBases;
end;

procedure Tfrm_MSSMain.DoLoadFileFTPOnClick(Sender: TObject);
begin
  if not bEnTraitement then
  With DM_MSS do
  Try
    bEnTraitement := True;
       // Ouverture du FTP master & récupération des fichiers
    if OpenFTP(IniStruct.FTP.MasterDataFTP) then
    begin
      // Vérification et récupération du fichier masterdata
      if CheckMasterData then
        // traitement du fichier masterdata et récupération des nouveaux fichier si nécessaire
        if DoMasterDataFile then
          GetMasterDataFiles;
      AddToMemo('Chargement manuel des données en mémoire Ok');
      IdFTP.Disconnect;

    end;
  finally
    bEnTraitement := False;
  end;
end;

procedure Tfrm_MSSMain.DoShowMasterFileOnClick(Sender: TObject);
var
  i : Integer;
begin
  if not bEnTraitement then
  try
    bEnTraitement := True;
    Tab_FileData.TabVisible := True;
    cbo_File.Clear;
    for i := Low(MasterData) to High(MasterData) do
      cbo_File.Items.Add(MAsterData[i].Title);
    Pgc_Main.ActivePage := Tab_FileData;
  finally
    bEnTraitement := False;
  end;
end;

procedure Tfrm_MSSMain.DoLoadFileLocalOnclick(Sender: TObject);
begin
  if not bEnTraitement then
  With DM_MSS do
  try
    bEnTraitement := True;
    // traitement du fichier masterdata et récupération des nouveaux fichier si nécessaire
    if DoMasterDataFile then
      GetMasterDataFiles(True);
    AddToMemo('Chargement manuel des données en mémoire Ok');
  finally
    bEnTraitement := False;
  end;
end;

procedure Tfrm_MSSMain.DoParamsOnClick(Sender: TObject);
var
  bFound : Boolean;
  bPass : String;
begin
  if bEnTraitement then
    Exit;

  if InputPassword('Sécurité','Veuillez saisir le mot de passe',bPass) then
  begin
    if Trim(bPass) <> DoUnCryptPass(DM_DbMAG.GetDbMagParam_Data(1)) then
    begin
      Showmessage('Mot de passe incorrect');
      Exit;
    end;
  end
  else
    Exit;

  Tab_Params.TabVisible := True;
  if  Tab_Params.ComponentCount <= 0  then
  begin
    With Tfrm_CFGParams.Create(Tab_Params) do
    begin
      Parent := Tab_Params;
      Align := alClient;
      Visible := True;
    end;
  end;
//  bEnTraitement := True;
  Pgc_Main.ActivePage := Tab_Params;
end;

procedure Tfrm_MSSMain.DoShowGroupFileOnClick(Sender: TObject);
var
  i : integer;
begin
  if not bEnTraitement then
  try

  Tab_GroupData.TabVisible := True;

  cbo_CxFileGroup.Clear;
  for i := Low(GroupData) to High(GroupData) do
    cbo_CxFileGroup.Items.Add(GroupData[i].Title);

  cbo_CxGroupeTable.Clear;
  cbo_CxGroupeTable.Items.Add('OrderList');
  cbo_CxGroupeTable.Items.Add('PositionList');
  cbo_CxGroupeTable.Items.Add('ItemList');
  cbo_CxGroupeTable.Items.Add('CatalogList');
  cbo_CxGroupeTable.Items.Add('ModelList');
  cbo_CxGroupeTable.Items.Add('ColorList');
  cbo_CxGroupeTable.Items.Add('ColorItemList');
  finally
    bEnTraitement := False;
  end;
end;

procedure Tfrm_MSSMain.CategoryButtons1CategoryCollapase(Sender: TObject;
  const Category: TButtonCategory);
begin
  case Category.Index of
    0,1: Category.Collapsed := False;
    else
      Category.Collapsed := True;
  end;
end;

procedure Tfrm_MSSMain.cbo_CxFileGroupSelect(Sender: TObject);
begin
  if (cbo_CxFileGroup.ItemIndex <> -1) and (cbo_CxGroupeTable.ItemIndex <> -1) then
  begin
    case cbo_CxGroupeTable.ItemIndex of
      0: Ds_GroupData.DataSet := GroupData[cbo_CxFileGroup.ItemIndex].MainData.ClientDataSet;
      1: Ds_GroupData.DataSet := TCommandeClass(GroupData[cbo_CxFileGroup.ItemIndex].MainData).PositionList.ClientDataSet;
      2: Ds_GroupData.DataSet := TCommandeClass(GroupData[cbo_CxFileGroup.ItemIndex].MainData).ItemList.ClientDataSet;
      3: Ds_GroupData.DataSet := TCommandeClass(GroupData[cbo_CxFileGroup.ItemIndex].MainData).CatalogList.ClientDataSet;
      4: Ds_GroupData.DataSet := TCommandeClass(GroupData[cbo_CxFileGroup.ItemIndex].MainData).ModelList.ClientDataSet;
      5: Ds_GroupData.DataSet := TCommandeClass(GroupData[cbo_CxFileGroup.ItemIndex].MainData).ColorList.ClientDataSet;
      6: Ds_GroupData.DataSet := TCommandeClass(GroupData[cbo_CxFileGroup.ItemIndex].MainData).ColorItemList.ClientDataSet;
    end;
  end;
end;

procedure Tfrm_MSSMain.cbo_FileSelect(Sender: TObject);
begin
  Pan_SSTable.Visible := False;
  if cbo_File.Items.Count > 0 then
  begin
    case AnsiIndexStr(UpperCase(MasterData[cbo_File.ItemIndex].Title),['BRANDS','FEDAS','SIZES','SUPPLIERS','UNIVERSCRITERIAS',
                                                        'COLLECTIONS','OPCOMMS', 'PERIODS']) of
      0,3,5,7 : begin
        Ds_FileList.DataSet := MasterData[cbo_File.ItemIndex].MainData.ClientDataSet;
      end;
      1: begin // Fedas
        Pan_SSTable.Visible := True;
        cbo_sstable.Items.Clear;
        cbo_sstable.Items.Add(TFedas(MasterData[cbo_File.ItemIndex].MainData).NKLSecteur.Title);
        cbo_sstable.Items.Add(TFedas(MasterData[cbo_File.ItemIndex].MainData).NKLRayon.Title);
        cbo_sstable.Items.Add(TFedas(MasterData[cbo_File.ItemIndex].MainData).NKLFamille.Title);
        cbo_sstable.Items.Add(TFedas(MasterData[cbo_File.ItemIndex].MainData).NKLSSFamille.Title);
      end;

      2: begin // Sizes
        Pan_SSTable.Visible := True;
        cbo_sstable.Items.Clear;
        cbo_sstable.Items.Add(TSizes(MasterData[cbo_File.ItemIndex].MainData).PLXTYPEGT.Title);
        cbo_sstable.Items.Add(TSizes(MasterData[cbo_File.ItemIndex].MainData).PLXGTF.Title);
        cbo_sstable.Items.Add(TSizes(MasterData[cbo_File.ItemIndex].MainData).PLXTAILLESGF.Title);
      end;
      4: begin // Universcriteria
        Pan_SSTable.Visible := True;
        cbo_sstable.Items.Clear;
        cbo_sstable.Items.Add(TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).NKLSecteur.Title);
        cbo_sstable.Items.Add(TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).NKLRayon.Title);
        cbo_sstable.Items.Add(TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).NKLFamille.Title);
        cbo_sstable.Items.Add(TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).NKLSSFamille.Title);
        cbo_sstable.Items.Add('FEDAS');
      end;
      6: begin // OPCOMMS
        Pan_SSTable.Visible := True;
        cbo_sstable.Items.Clear;
        cbo_sstable.Items.Add(TOpComms(MasterData[cbo_File.ItemIndex].MainData).Title);
        cbo_sstable.Items.Add(TOpComms(MasterData[cbo_File.ItemIndex].MainData).ItemListOpCode.Title);
        cbo_sstable.Items.Add(TOpComms(MasterData[cbo_File.ItemIndex].MainData).ItemListOpDepliant.Title);
      end;
    end;
  end;
end;

procedure Tfrm_MSSMain.cbo_sstableSelect(Sender: TObject);
begin
  case AnsiIndexStr(UpperCase(MasterData[cbo_File.ItemIndex].Title),['SIZES','UNIVERSCRITERIAS','FEDAS','OPCOMMS']) of
    0: begin
      case cbo_sstable.ItemIndex of
        0:  Ds_FileList.DataSet := TSizes(MasterData[cbo_File.ItemIndex].MainData).PLXTYPEGT.ClientDataSet;
        1:  Ds_FileList.DataSet := TSizes(MasterData[cbo_File.ItemIndex].MainData).PLXGTF.ClientDataSet;
        2:  Ds_FileList.DataSet := TSizes(MasterData[cbo_File.ItemIndex].MainData).PLXTAILLESGF.ClientDataSet;
      end;
    end;
    1: begin
      case cbo_sstable.ItemIndex of
        0:  Ds_FileList.DataSet := TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).NKLSecteur.ClientDataSet;
        1:  Ds_FileList.DataSet := TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).NKLRayon.ClientDataSet;
        2:  Ds_FileList.DataSet := TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).NKLFamille.ClientDataSet;
        3:  Ds_FileList.DataSet := TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).NKLSSFamille.ClientDataSet;
        4:  Ds_FileList.DataSet := TUniversCriteria(MasterData[cbo_File.ItemIndex].MainData).Fedas.ClientDataSet;
      end;
    end;
    2: begin
      case cbo_sstable.ItemIndex of
        0:  Ds_FileList.DataSet := TFedas(MasterData[cbo_File.ItemIndex].MainData).NKLSecteur.ClientDataSet;
        1:  Ds_FileList.DataSet := TFedas(MasterData[cbo_File.ItemIndex].MainData).NKLRayon.ClientDataSet;
        2:  Ds_FileList.DataSet := TFedas(MasterData[cbo_File.ItemIndex].MainData).NKLFamille.ClientDataSet;
        3:  Ds_FileList.DataSet := TFedas(MasterData[cbo_File.ItemIndex].MainData).NKLSSFamille.ClientDataSet;
      end;
    end;
    3: begin
         case cbo_sstable.ItemIndex of
          0:  Ds_FileList.DataSet := TOpComms(MasterData[cbo_File.ItemIndex].MainData).ClientDataSet;
          1:  Ds_FileList.DataSet := TOpComms(MasterData[cbo_File.ItemIndex].MainData).ItemListOpCode.ClientDataSet;
          2:  Ds_FileList.DataSet := TOpComms(MasterData[cbo_File.ItemIndex].MainData).ItemListOpDepliant.ClientDataSet;
         end;
      end;
  end;
end;

procedure Tfrm_MSSMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DM_DbMAG.Free;
  DM_MSS.Free;
end;

procedure Tfrm_MSSMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not bEnTraitement;
end;

procedure Tfrm_MSSMain.FormCreate(Sender: TObject);
begin
  //Affichage de la version
  frm_MSSMain.Caption := frm_MSSMain.Caption + ' - Version: ' + version;

  bEnTraitement := False;
  Pgc_Main.ActivePageIndex := 0;
  Tab_FileData.TabVisible  := False;
  Tab_GroupData.TabVisible := False;
  Tab_CfgBases.TabVisible  := False;
  Tab_Params.TabVisible    := False;
  // Initialisation
  DM_MSS               := TDM_MSS.Create(self);
  DM_MSS.Memo          := mmLogs;
  DM_MSS.ProgressLabel := Lab_Encours;
  DM_MSS.ProgressBar   := pb_Encours;

  GAPPPATH    := ExtractFilePath(Application.ExeName);
  GLOGSPATH   := GAPPPATH + 'Logs\' + FormatDateTime('YY\MM\',Now);
  GXMLMDPATH  := GAPPPATH + 'Master\';
  GXMLSCPATH  := GAPPPATH + 'GroupXml\';
  GARCHPATH   := GAPPPATH + 'Archive\' + FormatDateTime('YY\MM\',Now);
  GLOGSNAME   := FormatDateTime('YYYYMMDDhhmmss',Now) + '.txt';
  GFILESDIR   := GAPPPATH + 'Fichiers\';
  GAPPRAPPORT := GAPPPATH + 'Rapports\' + FormatDateTime('YY\MM\DD\',Now);

  // chargement des données du fichier ini
  IniStruct.LoadIni;

  DM_DbMAG := TDM_DbMAG.Create(Self);
  DM_DbMAG.ConnectToDbMag(GAPPPATH + '\DbMag\DbMag.Ib');

  // Création des répertoires s'ils n'existent pas
  DoDir(GLOGSPATH);
  DoDir(GXMLMDPATH);
  DoDir(GXMLSCPATH);
  DoDir(GARCHPATH);
  DoDir(GAPPRAPPORT);

  bAutoExec := False;
  if ParamCount > 0 then
  begin
    if UpperCase(ParamStr(1)) = 'AUTO' then
      bAutoExec := True;
  end;

  Tim_MSS.Enabled := bAutoExec;
end;

procedure Tfrm_MSSMain.Pgc_MainChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := not bEnTraitement;

  // Gestion de la fenêtre de paramétrage
  if Tab_Params.ComponentCount > 0 then
    AllowChange := not TFrm_CFGParams(Tab_Params.Components[0]).AutoValid;
end;

procedure Tfrm_MSSMain.Tim_MSSTimer(Sender: TObject);
begin
  Tim_MSS.Enabled := False;
  DM_MSS.ExecuteProcess;
end;

end.
