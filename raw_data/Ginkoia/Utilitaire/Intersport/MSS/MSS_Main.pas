unit MSS_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Inifiles, StdCtrls, ComCtrls, CategoryButtons, ExtCtrls, DB, Grids,
  DBGrids, StrUtils, DateUtils,
  MSS_Type,
  MSS_DM,
  MSS_SizesClass,
  MSS_UniversCriteriaClass,
  MSS_FedasClass,
  MSS_CommandeClass,
  MSS_OpCommsClass,
  MSS_DMDbMag,
//  MSS_CFGBases,
  MSS_SDUpdateClass,
  MSS_CFGParams, Buttons, Mask, RzEdit, RzDBEdit, RzDBBnEd,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxDBData, cxCheckBox, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView,
  cxGrid, Menus, ImgList, ShellApi;

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
    Tab_ModifData: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    Ds_Catalog: TDataSource;
    Ds_Model: TDataSource;
    Ds_Color: TDataSource;
    Lab_Time: TLabel;
    Ds_Dossiers: TDataSource;
    cxg_DosListDBTableView1: TcxGridDBTableView;
    cxg_DosListLevel1: TcxGridLevel;
    cxg_DosList: TcxGrid;
    cxg_DosListDBTableView1DOS_NOM: TcxGridDBColumn;
    cxg_DosListDBTableView1DOS_GROUPE: TcxGridDBColumn;
    cxg_DosListDBTableView1DOS_BASEPATH: TcxGridDBColumn;
    cxg_DosListDBTableView1DOS_ACTIF: TcxGridDBColumn;
    TrayIcon: TTrayIcon;
    popMenu: TPopupMenu;
    mnuOpen: TMenuItem;
    mnuClose: TMenuItem;
    N1: TMenuItem;
    Lim_Tray: TImageList;
    Tim_Auto: TTimer;
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
    procedure CategoryButtons1Categories2Items0Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure DoAutoExecClick(Sender: TObject);
    procedure DoStopAutoExecClick(Sender: TObject);
    procedure Nbt_Click(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure Tim_AutoTimer(Sender: TObject);
    procedure DoStopCycle(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    AppHandle : THandle;

    function IsPrevInstance: Boolean;
  end;

var
  frm_MSSMain: Tfrm_MSSMain;

implementation

uses UVersion, uLog;

{$R *.dfm}

function Tfrm_MSSMain.IsPrevInstance: Boolean;
var
  Erreur: Integer;
begin
  Result := False;
  SetLastError(NO_ERROR);
  AppHandle := CreateMutex (nil, False, PWideChar(Application.Title));
  Erreur := GetLastError;
  if ( Erreur = ERROR_ALREADY_EXISTS ) or ( Erreur = ERROR_ACCESS_DENIED ) then
    Exit;
  Result := True;
end;


procedure Tfrm_MSSMain.DoExecuteAllOnClick(Sender: TObject);
var
  i : Integer;
  sParam : String;
begin
  if not bEnTraitement then
  begin
    // Initialisation des compos et variables
    Tim_MSS.Enabled := False;
    Lab_Time.Visible := False;
    mmLogs.Clear;
    bEnTraitement := True;
    GSTOPCYCLE := False;
    GSTARTTIME := Now;
    Tab_FileData.TabVisible := False;
    Tab_GroupData.TabVisible := False;
    Pgc_Main.ActivePageIndex := 0;
    Gbx_Progress.Visible := True;
    cxg_DosList.Enabled := false;
    TrayIcon.Animate := True;
    bDoRestart := False;
    try
      // exécution du process
      try
        DM_MSS.ExecuteProcess( '', True );

      // remise à zéro des compos/variables
      finally
        With DM_DbMAG do
        begin
          Que_DOSSIERS.Filtered := False;
          Que_DOSSIERS.Filter := Format('DOS_IDMDC = ''%s''',[IniStruct.IDMDC]);
          Que_DOSSIERS.Filtered := True;
        end;

        TrayIcon.Animate := False;
        // Il est nécessaire après un animate de remettre l'icone puis de le rendre invisible
        // pour qu'il y ai un rafraichissement dans la barre des taches
        TrayIcon.Icon := frm_MSSMain.Icon;
        TrayIcon.Visible := False;
        TrayIcon.Visible := not frm_MSSMain.Visible;

        bEnTraitement := False;
        Gbx_Progress.Visible := False;
        Tim_MSS.Enabled := not GSTOPTIME and not GSTOPCYCLE;
        cxg_DosList.Enabled := True;

        if GSTOPCYCLE then
        begin
          Lab_Time.Visible := True;
          Lab_Time.Caption := 'Cycle arrêté !';
        end;

        if ((GetAppMemory(Application.Handle) Div 1024 > 350000) and not bAutoExec) or bDoRestart then
        begin
          // Démarrage d'une novuelle instance du logiciel
          sParam := ' RESTART';
          for i := 1 to ParamCount do
            sParam := sParam + ' ' + ParamStr(i);

          ShellExecute(0,'OPEN',PWideChar(ParamStr(0)),PWideChar(sParam),PWideChar(ExtractFilePath(ParamStr(0))),SW_SHOW);
          Application.Terminate;
        end;
      end;
    Except on E:Exception do
      DM_MSS.AddToMemo(E.Message);
    end;
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

procedure Tfrm_MSSMain.DoAutoExecClick(Sender: TObject);
begin
  if bEnTraitement then
    Exit;

  GSTOPTIME := False;
  Tim_MSS.Enabled := True;
end;

procedure Tfrm_MSSMain.DoStopAutoExecClick(Sender: TObject);
begin
  GSTOPTIME := True;
  Tim_MSS.Enabled := False;
  Lab_Time.Visible := True;
  Lab_Time.Caption := 'Déclenchenement automatique stoppé';
end;

procedure Tfrm_MSSMain.DoStopCycle(Sender: TObject);
begin
  if bEnTraitement then
  begin
    GSTOPCYCLE := True;
    Lab_Time.Visible := True;
    Lab_Time.Caption := 'Arret du cycle en cours ...';
  end;
end;

procedure Tfrm_MSSMain.CategoryButtons1Categories2Items0Click(Sender: TObject);
var
  i : integer;
begin
  ComboBox1.Clear;
  for i := Low(ModifData) to High(ModifData) do
    ComboBox1.Items.Add(ModifData[i].MainData.Title);
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

procedure Tfrm_MSSMain.ComboBox1Click(Sender: TObject);
begin
  With TSDUpdate(ModifData[ComboBox1.ItemIndex].MainData) do
  begin
    Ds_Catalog.DataSet := CatalogList.ClientDataSet;
    Ds_Model.DataSet   := ModelList.ClientDataSet;
    Ds_Color.DataSet   := ColorList.ClientDataSet;
  end;
end;

procedure Tfrm_MSSMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DM_DbMAG.Free;
  DM_MSS.Free;
  CloseHandle(AppHandle);
end;

procedure Tfrm_MSSMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TrayIcon.Hint := Format('MDC - ID : %s',[IniStruct.IDMDC]);
  TrayIcon.Visible := True;
  Hide;
  CanClose := not bEnTraitement and DoCloseApp;
end;

procedure Tfrm_MSSMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  DoCloseApp := False;
  bEnTraitement := False;

  Pgc_Main.ActivePageIndex := 0;
  Tab_FileData.TabVisible  := False;
  Tab_GroupData.TabVisible := False;
  Tab_CfgBases.TabVisible  := False;
  Tab_Params.TabVisible    := False;
  Tab_ModifData.TabVisible := False;

  // chargement des données du fichier ini
  IniStruct.LoadIni;

  // Initialisation
  GSTOPCYCLE := False;

  DM_MSS               := TDM_MSS.Create(self); { Initialization du monitoring }
  DM_MSS.Memo          := mmLogs;
  DM_MSS.ProgressLabel := Lab_Encours;
  DM_MSS.ProgressBar   := pb_Encours;

  Log.Log( 'Main', '', '', 'Version', GetNumVersionSoft, logInfo, True, 0, DM_MSS.LogType );

  GAPPPATH      := ExtractFilePath(Application.ExeName);
  GLOGSPATH     := GAPPPATH + 'Logs\' + FormatDateTime('YY\MM\',Now);
  GXMLMDPATH    := GAPPPATH + 'Master\';
  GXMLSCPATH    := GAPPPATH + 'GroupXml\';
  GLOGSNAME     := FormatDateTime('YYYYMMDDhhmmss',Now) + '.txt';
  GFILESDIR     := GAPPPATH + 'Fichiers\';
  GAPPRAPPORT   := GAPPPATH + 'Rapports\' + FormatDateTime('YY\MM\DD\',Now);
  GARCHMAINPATH := GAPPPATH + 'Archives\';

  // Création des répertoires s'ils n'existent pas
  DoDir(GLOGSPATH);
  DoDir(GXMLMDPATH);
  DoDir(GXMLSCPATH);
  DoDir(GAPPRAPPORT);
  DoDir(GARCHMAINPATH);

  try
    DM_DbMAG := TDM_DbMAG.Create(Self);
    With DM_DbMAG do
    begin
      if ConnectToDbMag(IniStruct.Database) then
      begin
        Que_DOSSIERS.Filtered := false;
        Que_DOSSIERS.Filter := Format('DOS_IDMDC = ''%s''',[IniStruct.IDMDC]);
        Que_DOSSIERS.Filtered := True;
      end
    end;
  except
    on E: Exception do
       Log.Log( 'Main', '', '', 'Status', E.Message, logError, False, 0, DM_MSS.LogType );
  end;

  bAutoExec := False;
  DoHideApp := False;
  bAutoRestart := False;
  if  ParamCount > 0 then
  begin
    for i := 1 to ParamCount do
    begin
      if UpperCase(ParamStr(i)) = 'AUTO' then
        bAutoExec := True;
      if UpperCase(ParamStr(i)) = 'HIDE' then
        DoHideApp := True;
      if UpperCase(ParamStr(i)) = 'RESTART' then
      begin
        bAutoRestart := True;
        DoHideApp := True;
        Log.Log( 'Main', '', '', 'Status', 'Redémarrage', logWarning, False, 0, DM_MSS.LogType );
      end;
    end;
  end;

  GSTARTTIME := Now;
  GSTOPTIME  := False;
  Tim_MSS.Enabled := True and not bAutoExec;
  Tim_Auto.Enabled := bAutoExec;
  TrayIcon.Icon := Icon;

  //Affichage de la version
  frm_MSSMain.Caption := frm_MSSMain.Caption + ' - Id : ' + IniStruct.IDMDC + ' - Version: ' + GetNumVersionSoft;
  Application.Title := frm_MSSMain.Caption;
  if not IsPrevInstance then
    if Not bAutoRestart then
    begin
      DoCloseApp := True;
      Application.Terminate;
    end;
end;

procedure Tfrm_MSSMain.Nbt_Click(Sender: TObject);
begin
  DoShowGroupFileOnClick(Nil);
end;

procedure Tfrm_MSSMain.mnuOpenClick(Sender: TObject);
begin
  Show;
  TrayIcon.Visible := False;
end;

procedure Tfrm_MSSMain.Pgc_MainChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := not bEnTraitement;

  // Gestion de la fenêtre de paramétrage
  if Tab_Params.ComponentCount > 0 then
    AllowChange := not TFrm_CFGParams(Tab_Params.Components[0]).AutoValid;
end;

procedure Tfrm_MSSMain.mnuCloseClick(Sender: TObject);
begin
  DoCloseApp := True;
  Close;
end;

procedure Tfrm_MSSMain.Tim_AutoTimer(Sender: TObject);
begin
  Tim_Auto.Enabled := False;

  try
    With DM_DbMAG do
    begin
      if ConnectToDbMag(IniStruct.Database) then
      begin
        Ds_Dossiers.DataSet := nil;
        Que_DOSSIERS.Filtered := false;
        Que_DOSSIERS.Filter := Format('DOS_IDMDC = ''%s''',[IniStruct.IDMDC]);
        Que_DOSSIERS.Filtered := True;
        Ds_Dossiers.DataSet := Que_DOSSIERS;

        DoExecuteAllOnClick(Self);
      end
    end;
  except
    on E: Exception do
       Log.Log( 'Main', '', '', 'Status', E.Message, logError, False, 0, DM_MSS.LogType );
  end;

  Application.Terminate;
end;

procedure Tfrm_MSSMain.Tim_MSSTimer(Sender: TObject);
var
  iMn : Integer;
  iMl : Int64;
begin

  try
    With DM_DbMAG do
    begin
      if ConnectToDbMag(IniStruct.Database) then
      begin
        Ds_Dossiers.DataSet := nil;
        Que_DOSSIERS.Filtered := false;
        Que_DOSSIERS.Filter := Format('DOS_IDMDC = ''%s''',[IniStruct.IDMDC]);
        Que_DOSSIERS.Filtered := True;
        Ds_Dossiers.DataSet := Que_DOSSIERS;
      end
    end;
  except
    on E: Exception do
    begin
       Log.Log( 'Main', '', '', 'Status', E.Message, logError, False, 0, DM_MSS.LogType );
       Exit;
    end;
  end;

  if DoHideApp then
  begin
    Close;
    DoHideApp := False;
  end;

  iMn := MinutesBetween(GSTARTTIME,Now);
  iMl := MilliSecondsBetween(GSTARTTIME,Now);
  if iMn >= IniStruct.Time then
  begin
    GSTARTTIME := Now;
    Lab_Time.Visible := False;
    Tim_MSS.Enabled := False;
    DoExecuteAllOnClick(Nil);
//    DM_MSS.ExecuteProcess;
    Tim_MSS.Enabled := not GSTOPTIME;
  end
  else begin
    Lab_Time.Caption := Format('Prochain déclenchement dans : %s', [LeftStr(FormatMS((IniStruct.Time * 60 * 1000) - iMl),8)]);
    TrayIcon.Hint := Format('MDC - ID : %s - %s',[IniStruct.IDMDC, Lab_Time.Caption]);
    Lab_Time.Visible := True;
    Application.ProcessMessages;
  end;
end;

procedure Tfrm_MSSMain.TrayIconDblClick(Sender: TObject);
begin
  Show;
  TrayIcon.Visible := False;
end;

end.
