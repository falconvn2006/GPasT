unit Main_Frm;

interface

uses
  Constante_CBR, Erreur_CBR, SysUtils, StrUtils, SHELLAPI, FileCtrl,
  LMDCustomButton, LMDButton, Windows, Messages,Variants, Classes,
  //Début Uses Perso
  IB_Components, IBODataset, Contnrs,

  //Fin Uses Perso
  Graphics, Controls, Forms, ExtCtrls, Grids, IniFiles, Dialogs, StdCtrls,
  DBClient, MidasLib,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, LMDControl,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomMemo, LMDMemo, Buttons, DBGrids, cxPC, dxDBTLCl, dxGrClms, dxTL,
  dxDBCtrl, dxDBGrid, dxCntner, ComCtrls, DB;

type
  TFMain = class(TForm)
    Pan_Quitter: TPanel;
    opd_Fichier: TOpenDialog;
    Pgc_Traitement: TPageControl;
    Tab_Logold: TTabSheet;
    TabMaintenanceold: TTabSheet;
    Tab_MonitorConsolide: TTabSheet;
    Ds_Maintenance: TDataSource;
    Pan_Monitor: TPanel;
    DBG_Monitor: TdxDBGrid;
    lbl_NbMonitor: TLabel;
    DBG_MonitorSENDER_ID: TdxDBGridMaskColumn;
    DBG_MonitorSENDER_NAME: TdxDBGridMaskColumn;
    DBG_MonitorSENDER_DATA: TdxDBGridMemoColumn;
    DBG_MonitorFLD_ID: TdxDBGridMaskColumn;
    DBG_MonitorSENDER_INSTALL: TdxDBGridDateColumn;
    DBG_MonitorSENDER_MAGID: TdxDBGridMaskColumn;
    tesyellisold: TTabSheet;
    Ds_Yellis: TDataSource;
    Pan_Grille: TPanel;
    pct_GBA: TcxPageControl;
    tab_FichierIni: TcxTabSheet;
    Lab_NbIni: TLabel;
    Pan_Fichier: TPanel;
    sgr_Fichier: TStringGrid;
    Tab_Maintenance: TcxTabSheet;
    Lab_NbMaintenance: TLabel;
    Pan_Maintenance: TPanel;
    Pan_ActionMaintenance: TPanel;
    Nbt_ReinitialiserMaintenance: TLMDButton;
    Tab_Yellis: TcxTabSheet;
    Lab_NbYellis: TLabel;
    Pan_Yellis: TPanel;
    Tab_Log: TcxTabSheet;
    Pan_Log: TPanel;
    Pan_ActionLog: TPanel;
    Nbt_ReinitialiserLog: TLMDButton;
    mmo_Log: TLMDMemo;
    Ds_Debug: TDataSource;
    cbo_TableYellis: TComboBox;
    dbgridDebug: TDBGrid;
    cbo_TableMaintenance: TComboBox;
    DBG_Maintenance: TDBGrid;
    tab_ConsoMonitor: TcxTabSheet;
    Pan_ConsoMonitor: TPanel;
    DBG_ConsoMonitor: TDBGrid;
    Lab_NbConsoMonitor: TLabel;
    cbo_TableConsoMonitor: TComboBox;
    Ds_ConsoMonitor: TDataSource;
    Nbt_MigrationBase: TLMDButton;
    Pan_RaifraichirIni: TPanel;
    Nbt_RaifraichirIni: TLMDButton;
    Pan_RaifraichirConsoMonitor: TPanel;
    Nbt_RaifraichirConsoMonitor: TLMDButton;
    Pan_RappatrierYellis: TPanel;
    Nbt_Rappatrier: TLMDButton;
    Pan_BtnQuitter: TPanel;
    Btn_Quitter: TButton;
    chkAfficherOrphelin: TCheckBox;
    Lab_InfoRappatriement: TLabel;
    EdtSelectBase: TEdit;
    SpdBtnSelectBase: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_QuitterClick(Sender: TObject);
    procedure Nbt_MigrationBaseClick(Sender: TObject);
    procedure Nbt_ReinitialiserMaintenanceClick(Sender: TObject);
    procedure Nbt_OuvrirFichierClick(Sender: TObject);
    procedure pct_GBAChange(Sender: TObject);
    procedure Nbt_RappatrierClick(Sender: TObject);
    procedure Btn_RepertoireXMLClick(Sender: TObject);
    procedure Nbt_ReinitialiserLogClick(Sender: TObject);
    procedure cbo_TableYellisChange(Sender: TObject);
    procedure cbo_TableMaintenanceChange(Sender: TObject);
    procedure cbo_TableConsoMonitorChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgr_FichierDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Nbt_RaifraichirIniClick(Sender: TObject);
    procedure Nbt_RaifraichirConsoMonitorClick(Sender: TObject);
    procedure chkAfficherOrphelin_Click(Sender: TObject);
    procedure SpdBtnSelectBaseClick(Sender: TObject);
    procedure EdtSelectBaseKeyPress(Sender: TObject; var Key: Char);
  private
    FPathConsoMonitorBDD  : string;
    FPathMaintenanceBDD   : string;

    procedure PostTraitementALGOL;

    function  Esp(vpLargeur : Integer) : String;

    function  IntToBool(vpInteger : Integer) : Boolean;
    function  StrToBool(vpString  : String)  : Boolean;
    function  BoolToStr(vpBool    : Boolean) : String;

    procedure InitialiserGrilleIni;
    procedure InitialiserLesCombosTable;

    //procedure ChargerIni;
    procedure EcrireLog(vpTitre : String);
    procedure RemplirGrilleINI;
    procedure ChargerListeTable;

    procedure MigrerVersLaBaseMaintenance;

    function  IndiquerCheminDossierLOG : String;
    function  IndiquerCheminDossierXML : String;
    function  SupprimerContenuLeDuRepertoireXML(vpDossier: String): Boolean;
    procedure RappatrierBaseYellis;

    procedure ConnexionBase;
  public
    //
    property PathConsoMonitorBDD : string read FPathConsoMonitorBDD write FPathConsoMonitorBDD;
    property PathMaintenanceBDD : string read FPathMaintenanceBDD write FPathMaintenanceBDD;
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

uses
 CopierTable,
 Maintenance_DM,
 MonitorConsolide_DM,
 Yellis_DM,
 DM_Yellis;

procedure TFMain.FormCreate(Sender: TObject);
begin
  vgObjlTable := TObjectList.Create;
  vgObjlLog   := TObjectList.Create;

  pct_GBA.ActivePage := Tab_FichierIni;

  chkAfficherOrphelin.Checked := False;
  chkAfficherOrphelin.Visible := False;

  Lab_InfoRappatriement.Caption := '';

  vgRepertoire := ExtractFilePath(Application.ExeName);
  vgFichierIni := vgRepertoire + ExtractFileName(Application.ExeName);
  vgFichierIni := StringReplace(vgFichierIni, '.exe', '.ini', [rfReplaceAll, rfIgnoreCase]);

  vgIniFile := nil;
  if FileExists(vgFichierIni) then
  begin
    vgIniFile  := TIniFile.Create(vgFichierIni);  //SR : Free dans la FormClose

    PathMaintenanceBDD := vgIniFile.ReadString('PATH', 'MAINTENANCE', '');
    PathConsoMonitorBDD := vgIniFile.ReadString('PATH', 'CONSOMONITOR', '');

    InitialiserGrilleIni;
    ChargerListeTable;
    RemplirGrilleINI;
  end;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(vgObjlTable);
  FreeAndNil(vgObjlLog);

  if Assigned(vgIniFile) then
    FreeAndNil(vgIniFile);

  Action := CaFree;

  Application.Terminate;
end;

procedure TFMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_Escape then
    Close;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  if FileExists(FMaintenance_DM.IbC_Maintenance.DatabaseName) then
  begin
    EdtSelectBase.Text:= FMaintenance_DM.IbC_Maintenance.DatabaseName;
    FMaintenance_DM.IbC_Maintenance.Connect;
  end;

  // ouverture des tables
  if FileExists(FMonitorConsolide_DM.IbC_MonitorConsolide.DatabaseName) then
  begin
    FMonitorConsolide_DM.ChargerBaseConsoMonitor;
    FMaintenance_DM.RafraichirBaseMaintenance;
  end;

  // Une fois les DM instanciés, on indique le nom des composants dans les combos
  InitialiserLesCombosTable;

  // On rafraichi les combos pour qu'ils affichent la première table
  cbo_TableConsoMonitorChange(cbo_TableConsoMonitor);
  cbo_TableMaintenanceChange(cbo_TableMaintenance);
end;

//-----------------------------------------------> InitialiserLesCombosTable

procedure TFMain.InitialiserLesCombosTable;
var
  vIx : Integer;
begin
  // CBR - On va copier le nom des CDS ou des query de chaque DM et les mettre
  // dans les combos respectifs afin de pouvoir en afficher le contenu.
  // Pour optimiser l'affichage, on n'enlevera les préfixes ("que_" ou "CDS_")

  // On parcourt la fiche FMonitorConsolide_DM et pour chacun des ClientDataSet, on indique le libellé
  with FMonitorConsolide_DM do
  begin
    cbo_TableConsoMonitor.Items.BeginUpdate;
    cbo_TableConsoMonitor.Clear;

    for vIx := 0 to ComponentCount -1 do
      if Components[vIx] is TClientDataSet then
        cbo_TableConsoMonitor.Items.Add(Copy(Components[vIx].Name, 5, length(Components[vIx].Name)));

    cbo_TableConsoMonitor.Items.EndUpdate;
    cbo_TableConsoMonitor.ItemIndex := 0;
  end;

  // On parcourt la fiche FMaintenance_DM et pour chacun des query, on indique le libellé
  with FMaintenance_DM do
  begin
    cbo_TableMaintenance.Items.BeginUpdate;
    cbo_TableMaintenance.Clear;

    for vIx := 0 to ComponentCount -1 do
      if Components[vIx] is TIBOQuery then
        if LowerCase(Components[vIx].Name) <> 'que_class' then
          cbo_TableMaintenance.Items.Add(Copy(Components[vIx].Name, 5, length(Components[vIx].Name)));

    cbo_TableMaintenance.Items.EndUpdate;
    cbo_TableMaintenance.ItemIndex := 0;
  end;

  // On parcourt la fiche FYellis_DM et pour chacun des CDS, on indique le libellé
  with FYellis_DM do
  begin
    cbo_TableYellis.Items.BeginUpdate;
    cbo_TableYellis.Clear;

    for vIx := 0 to ComponentCount -1 do
      if Components[vIx] is TclientDataset then
        cbo_TableYellis.Items.Add(Copy(Components[vIx].Name, 5, length(Components[vIx].Name)));

    cbo_TableYellis.Items.EndUpdate;
    cbo_TableYellis.ItemIndex := 0;
  end;
end;

//------------------------------------------------------------------------------
//                                                               +-------------+
//                                                               |    Objet    |
//                                                               +-------------+
//------------------------------------------------------------------------------
{$REGION ' Objet '}
//------------------------------------------------------------------> Bouton

procedure TFMain.SpdBtnSelectBaseClick(Sender: TObject);
begin
  opd_Fichier.DefaultExt:= '';
  opd_Fichier.Filter:= '';
  opd_Fichier.InitialDir:= ExtractFilePath(EdtSelectBase.Text);
  opd_Fichier.FileName:= ExtractFileName(EdtSelectBase.Text);
  if opd_Fichier.Execute(Handle) then
    begin
      EdtSelectBase.Text:= opd_Fichier.FileName;
      ConnexionBase;
    end;
end;

procedure TFMain.Nbt_MigrationBaseClick(Sender: TObject);
begin
  // Précise le type de rappartriement. Ici, Rappatriement complet de la base
  Lab_InfoRappatriement.Caption := '(Rappatriement en fonction du fichier .ini) ';

  MigrerVersLaBaseMaintenance;

  EcrireLog('GBA_ImportMaintenance - ');
end;

procedure TFMain.Nbt_OuvrirFichierClick(Sender: TObject);
begin
//  DMYellis.CDS_FICHIERS.Active := False;
//  DMYEllis.OuvrirTables;
//
//  DMYellis.CDS_FICHIERS.SaveToFile('c:\CBR_test1.xml', dfXML);
//  DMYellis.CDS_FICHIERS.Active := True;
end;

procedure TFMain.Nbt_QuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TFMain.Nbt_RaifraichirConsoMonitorClick(Sender: TObject);
begin
  FMonitorConsolide_DM.ChargerBaseConsoMonitor;
end;

procedure TFMain.Nbt_RaifraichirIniClick(Sender: TObject);
begin
 InitialiserGrilleIni;
 ChargerListeTable;
 RemplirGrilleINI;
end;

procedure TFMain.Nbt_RappatrierClick(Sender: TObject);
begin
  // Précise le type de rappartriement. Ici, Rappatriement complet de la base
  Lab_InfoRappatriement.Caption := '(Rappatriement complet) ';

  RappatrierBaseYellis;

  EcrireLog('GBA_RappatriementYellis - ');
end;

procedure TFMain.Btn_RepertoireXMLClick(Sender: TObject);
var
  vChemin : string;
begin
  if SelectDirectory('Choisissez le dossier de destination XML','C:\', vChemin) then
    ShowMessage(vChemin)
  else
    ShowMessage('Annulation');
end;

procedure TFMain.Nbt_ReinitialiserLogClick(Sender: TObject);
begin
  mmo_Log.Lines.Clear;
end;

procedure TFMain.Nbt_ReinitialiserMaintenanceClick(Sender: TObject);
begin
  FMaintenance_DM.ViderBaseMaintenance;
  FMaintenance_DM.RafraichirBaseMaintenance;

  DBG_Maintenance.Refresh;
end;

//----------------------------------------------------------------> CheckBox

procedure TFMain.chkAfficherOrphelin_Click(Sender: TObject);
begin
  FMonitorConsolide_DM.CDS_SENDER.Filtered := False;

  // on n'affiche que les Orphelins
  if chkAfficherOrphelin.Checked then
  begin
    FMonitorConsolide_DM.CDS_SENDER.Filter   := 'EstOrphelin=' + QuotedStr('true');
    FMonitorConsolide_DM.CDS_SENDER.Filtered := True;
  end;

  FMonitorConsolide_DM.CDS_SENDER.Refresh;
  DBG_ConsoMonitor.Refresh;
  lab_NbConsoMonitor.Caption := IntToStr(DS_ConsoMonitor.DataSet.RecordCount);
end;

procedure TFMain.ConnexionBase;
begin
  FMaintenance_DM.IbC_Maintenance.Disconnect;
  FMaintenance_DM.IbC_Maintenance.DatabaseName      := AnsiString(EdtSelectBase.Text);
  FMaintenance_DM.IbC_Maintenance.Connect;

  FMaintenance_DM.RafraichirBaseMaintenance;

  Nbt_ReinitialiserMaintenance.Enabled:= FMaintenance_DM.IbC_Maintenance.Connected;
  Nbt_MigrationBase.Enabled:= FMaintenance_DM.IbC_Maintenance.Connected;
end;

//-------------------------------------------------------------------> Combo

procedure TFMain.cbo_TableConsoMonitorChange(Sender: TObject);
begin
  // Affiche le query indiqué
  DS_ConsoMonitor.DataSet := TClientDataSet(FMonitorConsolide_DM.FindComponent('CDS_' + cbo_TableConsoMonitor.Text));

  // Indique le Nb de lignes de la table
  lab_NbConsoMonitor.Caption := IntToStr(DS_ConsoMonitor.DataSet.RecordCount);

  // si le dataSet est que_Emetteur, on affiche la checkbox d'affichage des orphelins
   chkAfficherOrphelin.Visible := (DS_ConsoMonitor.DataSet = FMonitorConsolide_DM.CDS_SENDER);
end;

procedure TFMain.cbo_TableMaintenanceChange(Sender: TObject);
begin
  // Affiche le query indiqué
  DS_Maintenance.DataSet := TIBOQuery(FMaintenance_DM.FindComponent('Que_' + cbo_TableMaintenance.Text));

  // Indique le Nb de lignes de la table
  lab_NbMaintenance.Caption := IntToStr(DS_Maintenance.DataSet.RecordCount);
end;

procedure TFMain.cbo_TableYellisChange(Sender: TObject);
begin
  if cbo_TableYellis.Text = 'Choisir la table' then
    Exit;

  // Affiche le CDS indiqué
  Ds_Yellis.DataSet := TClientDataset(FYellis_DM.FindComponent('CDS_' + cbo_TableYellis.Text));

  // Indique le Nb de lignes de la table
  lab_NbYellis.Caption := IntToStr(Ds_Yellis.DataSet.RecordCount);
end;

//------------------------------------------------------------------> Grille

procedure TFMain.sgr_FichierDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
    Exit;

  if ACOL = 1 then
  with sgr_Fichier.Canvas do
  begin
    if Trim(LowerCase(sgr_Fichier.Cells[1, AROW])) = 'true' then
      Brush.Color := $00DCF5C0    // Couleur vert clair
    else
      Brush.Color := $009F9FFF;   // Couleur rouge clair

    Brush.Style := bsSolid;

    FillRect(Rect);
    TextOut(Rect.Left + 2, Rect.Top + 1, sgr_Fichier.Cells[ACOL, AROW]);
  end;
end;

//-------------------------------------------------------------> PageControl

procedure TFMain.pct_GBAChange(Sender: TObject);
begin
  tab_FichierIni.Highlighted   := False;
  tab_ConsoMonitor.Highlighted := False;
  tab_Maintenance.Highlighted  := False;
  tab_Yellis.Highlighted       := False;
  tab_Log.Highlighted          := False;

  pct_GBA.ActivePage.Highlighted := True;
end;


procedure TFMain.PostTraitementALGOL;
var
  vQryI, vQryS: TIBOQuery;
  vNewId, vNewIdVERSION, vNewIdFOLDER: integer;
begin
  vQryI:= FMaintenance_DM.GetNewQry;
  vQryS:= FMaintenance_DM.GetNewQry;
  try
    vQryI.SQL.Add('INSERT INTO EMETTEUR ');
    vQryI.SQL.Add(' (EMET_ID, EMET_NOM, EMET_DONNEES, DOS_ID, EMET_INSTALL, EMET_MAGID, ');
    vQryI.SQL.Add('  EMET_GUID, VER_ID, EMET_PATCH, EMET_VERSION_MAX, EMET_SPE_PATCH, ');
    vQryI.SQL.Add('  EMET_SPE_FAIT, EMET_BCKOK, EMET_DERNBCK, EMET_RESBCK)');
    vQryI.SQL.Add('VALUES');
    vQryI.SQL.Add(' (:PID, :PNOM, :PDONNEES, :PDOS_ID, :PINSTALL, :PMAGID, ');
    vQryI.SQL.Add('  :PGUID, :PVER_ID, :PPATCH, :PVERSION_MAX, :PSPE_PATCH, ');
    vQryI.SQL.Add('  :PSPE_FAIT, :PBCKOK, :PDERNBCK, :PRESBCK)');

    vQryS.SQL.Text:= 'SELECT EMET_GUID FROM EMETTEUR WHERE EMET_GUID=:PEMET_GUID';

//    FYellis_DM.cds_Clients.IndexName:= 'idx_Site_Nom';

    FYellis_DM.cds_Clients.First;
    while not FYellis_DM.cds_Clients.Eof do
      begin
        vQryS.Close;
        vQryS.Params[0].AsString:= FYellis_DM.cds_Clients.FieldByName('clt_guid').AsString;
        vQryS.Open;

        if (vQryS.Eof) and (FYellis_DM.cds_Clients.FieldByName('nompournous').AsString <> '') then
          begin
            vNewIdFOLDER:= 0;
            if FMonitorConsolide_DM.CDS_FOLDER.Locate('FLD_DATABASE', FYellis_DM.cds_Clients.FieldByName('nompournous').AsString, []) then
              vNewIdFOLDER:= FMonitorConsolide_DM.cds_FOLDER.FieldByName('NewId').AsInteger
            else
              begin
                FYellis_DM.cds_Clients.Next;
                Continue;
              end;

            vNewIdVERSION:= 0;
            // On recupérè les Id nouvellement crées
            if FYellis_DM.cds_Version.Locate('id', FYellis_DM.cds_Clients.FieldByName('version').AsInteger, []) then
              vNewIdVERSION := FYellis_DM.cds_Version.FieldByName('NewId').AsInteger;

            try
              if not vQryI.IB_Transaction.InTransaction then
                vQryI.IB_Transaction.StartTransaction;

              vNewId := GenID('EMETTEUR');

              // Champs ConsoMonitor
              vQryI.ParamByName('PID').AsInteger          := vNewId;
              vQryI.ParamByName('PNOM').AsString          := FYellis_DM.cds_Clients.FieldByName('nom').AsString;
              vQryI.ParamByName('PDONNEES').AsString      := '';
              vQryI.ParamByName('PDOS_ID').AsInteger      := vNewIdFOLDER;
              vQryI.ParamByName('PINSTALL').AsDateTime    := 0;
              vQryI.ParamByName('PMAGID').AsInteger       := 0;

              // Champs Yellis
              vQryI.ParamByName('PGUID').AsString         := FYellis_DM.cds_Clients.FieldByName('clt_guid').AsString;
              vQryI.ParamByName('PVER_ID').AsInteger      := vNewIdVERSION;
              vQryI.ParamByName('PPATCH').AsInteger       := FYellis_DM.cds_Clients.FieldByName('patch').AsInteger;
              vQryI.ParamByName('PVERSION_MAX').AsInteger := FYellis_DM.cds_Clients.FieldByName('version_max').AsInteger;
              vQryI.ParamByName('PSPE_PATCH').AsInteger   := FYellis_DM.cds_Clients.FieldByName('spe_patch').AsInteger;
              vQryI.ParamByName('PSPE_FAIT').AsInteger    := FYellis_DM.cds_Clients.FieldByName('spe_fait').AsInteger;
              vQryI.ParamByName('PBCKOK').AsDateTime      := FYellis_DM.cds_Clients.FieldByName('bckok').AsDateTime;
              vQryI.ParamByName('PDERNBCK').AsDateTime    := FYellis_DM.cds_Clients.FieldByName('dernbck').AsDateTime;
              vQryI.ParamByName('PRESBCK').AsString       := FYellis_DM.cds_Clients.FieldByName('resbck').AsString;

              vQryI.ExecSQL;

              vQryI.IB_Transaction.Commit;

              // on copie aussi le nouvel Id dans le CDS_clients de la base Yellis
              FYellis_DM.cds_Clients.Edit;
              FYellis_DM.cds_Clients.FieldByName('NewId').AsInteger := vNewId;
              FYellis_DM.cds_Clients.Post;
            except
              vQryI.IB_Transaction.Rollback;
            end;
          end;

        FYellis_DM.cds_Clients.Next;
      end;

    if not vQryS.IB_Transaction.InTransaction then
      vQryS.IB_Transaction.StartTransaction;

    vQryS.SQL.Text:= 'DELETE FROM EMETTEUR WHERE DOS_ID = 0';
    vQryS.ExecSQL;
    vQryS.IB_Transaction.Commit;

    vQryS.IB_Transaction.StartTransaction;
    vQryS.SQL.Text:= 'UPDATE SRV SET SRV_DOSEAI = ''D:\EAI'' WHERE (SRV_DOSEAI IS NULL) OR (SRV_DOSEAI LIKE '''')';
    vQryS.ExecSQL;
    vQryS.IB_Transaction.Commit;
  finally
    FYellis_DM.cds_Clients.Filter:= '';
    FYellis_DM.cds_Clients.Filtered:= False;
    FreeAndNil(vQryI);
    FreeAndNil(vQryS);
  end;
end;

{$ENDREGION ' Objet '}
//------------------------------------------------------------------------------
//                                                           +-----------------+
//                                                           |   Fichier INI   |
//                                                           +-----------------+
//------------------------------------------------------------------------------
{$REGION ' Fichier Ini '}
//-------------------------------------------------------> ChargerListeTable

//-------------------------------------------------------+
//   Charge en mémoire le fichier ini et dispatche les   |
//   tables dans un ObjectList                           |
//-------------------------------------------------------+

procedure TFMain.ChargerListeTable;
var
  vNomTable  : String;
  vIx        : Integer;
  vStrlTable : TSTringList;
  vMaTable   : TTypeMaTable;
begin
  vStrlTable := TSTringList.Create;
  try
    vStrlTable.Clear;
    vgObjlTable.Clear;

    vgIniFile.ReadSections(vStrlTable);

    with sgr_Fichier do
    begin
      for vIx := 0 to vStrlTable.Count - 1 do
      begin
        vNomTable := vStrlTable.Strings[vIx];

        vMaTable := TTypeMaTable.Create;

        vMaTable.Libelle    := vNomTable;
        vMaTable.ATraiter   := vgIniFile.ReadBool(vNomTable, 'TRAITERTABLE', False);
        vMaTable.MAJAuto    := vgIniFile.ReadBool(vNomTable, 'MAJAUTO', False);
        vMaTable.Last_Id    := vgIniFile.ReadInteger(vNomTable, 'LAST_ID', 0);
        vMaTable.Last_IdSVG := vgIniFile.ReadInteger(vNomTable, 'LAST_IDSVG', 0);

        // selon le nom de la table, on va indiquer le type de "Provenance"
        case AnsiIndexStr(LowerCase(vNomTable),
                          ['clients','fichiers','histo','plagemaj',
                           'specifique','version','sender','folder',
                           'grp','hdb','raison','srv' ]) of
          0  : vMaTable.TypeProvenance := tpClients;
          1  : vMaTable.TypeProvenance := tpFichiers;
          2  : vMaTable.TypeProvenance := tpHisto;
          3  : vMaTable.TypeProvenance := tpPlageMaj;
          4  : vMaTable.TypeProvenance := tpSpecifique;
          5  : vMaTable.TypeProvenance := tpVersion;
          6  : vMaTable.TypeProvenance := tpEmetteur;
          7  : vMaTable.TypeProvenance := tpDossier;
          8  : vMaTable.TypeProvenance := tpGrp;
          9  : vMaTable.TypeProvenance := tpHdb;
          10 : vMaTable.TypeProvenance := tpRaison;
          11 : vMaTable.TypeProvenance := tpSrv;
        end;

        // on indique si la table vient de la base Yellis ou ConsoMonitor
        if vMaTable.TypeProvenance in [tpClients, tpFichiers, tpHisto,
                                       tpPlageMaj, tpSpecifique, tpVersion] then
          vMaTable.TableOrigine := 'YELLIS'
        else
          vMaTable.TableOrigine := 'CONSOMONITOR';

        // on insert l'objet dans la liste d'objet
        vgObjlTable.Add(vMaTable);
      end;
    end;
  finally
    FreeAndNil(vStrlTable);   //SR : Ajout du Free ...
  end;
end;

//---------------------------------------------------------------> Formatage

//----> Ajoute des espaces dans un texte (utile dans une grille)
function TFMain.Esp(vpLargeur : Integer) : String;
var
  vIx : Integer;
begin
  Result := '';

  for vIx := 0 to vpLargeur do
    Result := Result + ' ';
end;

//----> Converti un entier en Boolean
function TFMain.IntToBool(vpInteger : Integer) : Boolean;
begin
  if vpInteger = 0 then
    Result := False
  else
    Result := True;
end;

//----> Converti un string en Boolean
function TFMain.StrToBool(vpString  : String)  : Boolean;
begin
  if ((vpString = 'T') or (vpString = 'True')) then
    Result := True
  else
    Result := False;
end;

//----> Converti un Boolean en string
function TFMain.BoolToStr(vpBool : Boolean) : String;
begin
  if vpBool = True then
    Result := 'True'
  else
    Result := 'False';
end;
{$ENDREGION ' Fichier Ini '}

{$REGION ' Grille '}
//----------------------------------------------------> InitialiserGrilleIni

procedure TFMain.InitialiserGrilleIni;
begin
  sgr_Fichier.Rows[0].Text := '';
  sgr_Fichier.RowCount     := 0;

  sgr_Fichier.Cells[0, 0] := Esp(14) + 'Nom de la Table';
  sgr_Fichier.Cells[1, 0] := Esp(5)  + 'Traiter';
  sgr_Fichier.Cells[2, 0] := Esp(5)  + 'Maj';
  sgr_Fichier.Cells[3, 0] := Esp(4)  + 'Last Id';
  sgr_Fichier.Cells[4, 0] := Esp(4)  + 'Last Id SE';
  sgr_Fichier.Cells[5, 0] := Esp(4)  + 'Origine';
  sgr_Fichier.Cells[6, 0] := Esp(4)  + 'Destination';

  sgr_Fichier.RowCount := 1;

  Lab_NbIni.Caption := '0';
end;

//--------------------------------------------------------> RemplirGrilleINI

procedure TFMain.RemplirGrilleINI;
var
  vChemin, vNomTable : String;
  vFichier  : TIniFile;
  vLig, vIx : Integer;
  vMaTable  : TTypeMaTable;
begin
  vChemin := '';
  vLig    := 0;

  InitialiserGrilleIni;

  with sgr_Fichier do
  begin
    for vIx := 0 to vgObjlTable.Count - 1 do
    begin
      vLig := vLig + 1;

      vMaTable := TTypeMaTable(vgObjlTable.Items[vIx]);

      Cells[0, vLig] := E2 + vMaTable.Libelle;
      Cells[1, vLig] := E2 + BoolToStr(vMaTable.ATraiter);
      Cells[2, vLig] := E2 + BoolToStr(vMaTable.MAJAuto);
      Cells[3, vLig] := E1 + IntToStr(vMaTable.Last_Id);
      Cells[4, vLig] := E1 + IntToStr(vMaTable.Last_IdSVG);
    end;

    RowCount := vLig + 1;
    Refresh;
  end;

  Lab_NbIni.Caption := IntToStr(vLig);
end;
{$ENDREGION ' Grille '}
//------------------------------------------------------------------------------
//                                                       +---------------------+
//                                                       |   Repertoire + Log  |
//                                                       +---------------------+
//------------------------------------------------------------------------------
{$REGION ' Répertoire '}
//------------------------------------------------> IndiquerCheminDossierXML

function TFMain.IndiquerCheminDossierXML : String;
var
  vDossierXML : string;
begin
  Result := '';

  vDossierXML := vgRepertoire + 'XML';

  // on verifie si le chemin existe
  if DirectoryExists(vDossierXML) then
  begin
    if not SupprimerContenuLeDuRepertoireXML(vDossierXML) then
    begin
      ShowMessage('Le répertoire : ' + chr(13) +
                   vDossierXML       + chr(13) +
                  'existe déjà. Veuillez recommencer.');
      Exit;
    end;
  end
  else
  // Si la création a échoué, on arrête le rappatriement
    if not CreateDir(vDossierXML) then
      begin
        ShowMessage('Erreur lors de la création du dossier XML : ' + chr(13) +
                     vDossierXML                                   + chr(13) +
                    'Veuillez recommencer.');
        Exit;
      end;

  Result := vDossierXML;
end;

//------------------------------------------------> IndiquerCheminDossierLOG

function TFMain.IndiquerCheminDossierLOG : String;
var
  vDossierLOG : string;
begin
  Result := '';

  vDossierLOG := vgRepertoire + 'LOG';

  // on verifie si le chemin existe
  if DirectoryExists(vDossierLOG) then
    Result := vDossierLOG
  else
    if not CreateDir(vDossierLOG) then
    begin
      ShowMessage('Erreur lors de la création du dossier de Log : '
                    + chr(13) + vDossierLOG + chr(13) +
                  'Veuillez recommencer.');
      Exit;
    end;

  Result := vDossierLOG;
end;

//---------------------------------------------------> SupprimeRepertoireXML

function TFMain.SupprimerContenuLeDuRepertoireXML(vpDossier: String): Boolean;
var
  fos : TSHFileOpStruct;
begin
  FillChar(fos, SizeOf(fos),0);

  with fos do
  begin
    wFunc  := FO_DELETE;
    pFrom  := PChar(vpDossier + '\*.*' + #0);
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
  end;

  result := (0 = ShFileOperation(fos));
end;

//---------------------------------------------------------------> EcrireLog

procedure TFMain.EcrireLog(vpTitre : String);
var
  vErreur   : TErreur;
  vIdx      : Integer;
  vLigneLog, vDossierLOG : string;
begin
  vDossierLOG := IndiquerCheminDossierLOG;

  if vDossierLOG = '' then
    Exit;

  vDossierLOG := vDossierLOG + '\' + vpTitre + FormatDateTime('YYYYMMDDHHmmsszzz', Now) + '.txt';

  try
    mmo_Log.Lines.Add('');
    mmo_Log.Lines.Add('-------------------------------------');
    mmo_Log.Lines.Add('             LOG d''erreur           ');
    mmo_Log.Lines.Add('-------------------------------------');
    mmo_Log.Lines.Add('');

    if vgObjlLog.Count = 0 then
      mmo_Log.Lines.Add(' Aucune erreur rencontrée.')
    else
      begin
      for vIdx := 0 to vgObjlLog.Count - 1 do
      begin
        vErreur   := TErreur(vgObjlLog.Items[vIdx]);
        vLigneLog := '';

        vLigneLog := vLigneLog + FormatDateTime('HHmmsszzz', vErreur.Heure);
        vLigneLog := vLigneLog + ' [Ref: ' + vErreur.NomTable;
        vLigneLog := vLigneLog + ' - '  + vErreur.RefErreur + ']';
        vLigneLog := vLigneLog + ' -> ' + vErreur.Text;

        mmo_Log.Lines.Add(vLigneLog);
      end;
    end;
  finally

    mmo_Log.Lines.Add('');
    mmo_Log.Lines.Add('-------------------------------------');
    mmo_Log.Lines.Add('         Fin du traitement           ');
    mmo_Log.Lines.Add('-------------------------------------');
    mmo_Log.Lines.Add('');

    mmo_Log.Lines.SaveToFile(vDossierLOG);
  end;
end;

procedure TFMain.EdtSelectBaseKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ConnexionBase;
end;

{$ENDREGION}
//------------------------------------------------------------------------------
//                                             +-------------------------------+
//                                             |   Rappatriement + Migration   |
//                                             +-------------------------------+
//------------------------------------------------------------------------------
{$REGION ' Rappatriement + Migration '}

//----------------------------------------------------> RappatrierBaseYellis

procedure TFMain.RappatrierBaseYellis;
var
  vIdx, vNbRec : Integer;
  vMaTable     : TTypeMaTable;
  vRepertoire        : String;
  vTimeDeb, vTimeFin : TTime;
begin
  // on indique le dossier de destination en local pour les fichiers XML
  vRepertoire := IndiquerCheminDossierXML;

  // si le repertoire n'existe pas, on sort
  if vRepertoire = '' then
    Exit;

  // on empêche la modification de la page active du PageControl
  pct_GBA.ActivePage := tab_Log;
  pct_GBAChange(pct_GBA);

  vTimeDeb := Time;

  mmo_Log.Lines.Clear;
  mmo_Log.Lines.Add('Début du rappatriement des paquets XML');
  mmo_Log.Lines.Add('-> ' + FormatDateTime('DD/MM/YYYY', Now) + ' - ' + TimeToStr(vTimeDeb));

  // on boucle sur toutes les tables du fichier provenant de la base Yellis
  // ATTENTION !!! on ne ramène que les tables et les lignes en fonction du fichier .ini
  for vIdx := 0 to vgObjlTable.Count - 1 do
  begin
    vMaTable := TTypeMaTable(vgObjlTable.Items[vIdx]);
    vNbRec   := 0;

    if vMaTable.TableOrigine = 'YELLIS' then
    begin
      if vMaTable.ATraiter then
      begin
        mmo_Log.Lines.Add('');
        mmo_Log.Lines.Add('Début d''import de la table : ' + vMaTable.Libelle);

        vNbRec := FYellis_DM.RecuperationXML(vRepertoire, vMaTable);

        mmo_Log.Lines.Add('Import de la table ' + vMaTable.Libelle + ' effectué. '
                         + '(' + IntToStr(vNbRec) + ' lignes ramenées)');
      end
      else
      begin
        mmo_Log.Lines.Add('');
        mmo_Log.Lines.Add('>> Table : ' + vMaTable.Libelle + ' non traitée. <<');
      end;
    end;
  end;

  mmo_Log.Lines.Add('');
  mmo_Log.Lines.Add('Fin du rappatriement des paquets XML');

  vTimeFin := Time;
  vTimeFin := vTimeFin - vTimeDeb;

  mmo_Log.Lines.Add('-> Durée : ' + TimeToStr(vTimeFin));
end;

//---------------------------------------------> MigrerVersLaBaseMaintenance

procedure TFMain.MigrerVersLaBaseMaintenance;
var
  vQueryTEMP : TIB_Cursor;
  vMaTable   : TTypeMaTable;
  vTimeDeb, vTimeFin : TTime;

    {$REGION ' IntegrerTable '}
    procedure IntegrerTable(vpTable : TTypeMaTable);
    begin
      // si la table n'a pas été trouvée dans la liste, on sort
      if vpTable = nil then
        Exit;

      if vpTable.ATraiter then
      begin
        // on traite la table et on ecrit dans le mémo
        vTimeDeb := Time;
        mmo_Log.Lines.Add('');
        mmo_Log.Lines.Add('Ecriture de la table ' + vpTable.Libelle + ' en cours');

        IntegrerLaTableVersMaintenance(vpTable, vQueryTEMP);

        vTimeFin := Time;
        vTimeFin := vTimeFin - vTimeDeb;

        mmo_Log.Lines.Add('-> Terminé en : ' + TimeToStr(vTimeFin));
      end
      else
      begin
        // on ne traite pas la table on on ecrit le log
        mmo_Log.Lines.Add('');
        mmo_Log.Lines.Add('Table ' + vpTable.Libelle + ' non traitée');

        RenseignerLog(vpTable.Libelle, 'Traitement', 'Table non traitée', 0, 0);
      end;
    end;
    {$ENDREGION ' IntegrerTable '}

    {$REGION ' IndiqueTypeTable '}
    function IndiqueTypeTable(vpTypeProvenance : TTypeTableProvenance) : TTypeMaTable;
    var
      vIdx : Integer;
    begin
      Result := nil;

      for vIdx := 0 to vgObjlTable.Count - 1 do
        if TTypeMaTable(vgObjlTable.Items[vIdx]).TypeProvenance = vpTypeProvenance then
        begin
          Result := TTypeMaTable(vgObjlTable.Items[vIdx]);
          Break;
        end;
    end;
    {$ENDREGION ' IndiqueTypeTable '}
begin
  // on commence d'abord par rappatrier la base Yellis
  RappatrierBaseYellis;

  {$REGION ' écriture du mémo '}
  mmo_Log.Lines.Add('');
  mmo_Log.Lines.Add('--------------------------------------------------------');
  mmo_Log.Lines.Add('--------------------------------------------------------');
  mmo_Log.Lines.Add('');
  mmo_Log.Lines.Add('Début de l''écriture de la base Maintenance');
  mmo_Log.Lines.Add('-> ' + FormatDateTime('DD/MM/YYYY', Now) + ' - ' + TimeToStr(Time));
  mmo_Log.Refresh;

  Application.ProcessMessages;
  {$ENDREGION ' écriture du mémo '}

  Pan_ActionMaintenance.Enabled := False;
  pct_GBA.Enabled := False;

  try
    // on instancie 1 vQueryTEMP pour pouvoir l'utiliser lors de la migration
    vQueryTEMP := TIB_Cursor.Create(self);

    vQueryTEMP.IB_Connection  := FMaintenance_DM.IbC_Maintenance;
    vQueryTEMP.IB_Transaction := FMaintenance_DM.IBT_Maj;

    // il faut suivre un ordre précis pour éviter d'avoir des clés étrangères fantômes
    // selon la provenance, on va indiquer la table du fichier ini correspondante
    // et l'intégrer à la base maintenance.

    IntegrerTable(IndiqueTypeTable(tpGRP));          // 1
    IntegrerTable(IndiqueTypeTable(tpSRV));          // 2
    IntegrerTable(IndiqueTypeTable(tpDossier));      // 3
    IntegrerTable(IndiqueTypeTable(tpRAISON));       // 4
    IntegrerTable(IndiqueTypeTable(tpVersion));      // 5
    IntegrerTable(IndiqueTypeTable(tpFichiers));     // 6
    IntegrerTable(IndiqueTypeTable(tpEmetteur));     // 7
    IntegrerTable(IndiqueTypeTable(tpPlageMAJ));     // 8
    IntegrerTable(IndiqueTypeTable(tpHDB));          // 9
    IntegrerTable(IndiqueTypeTable(tpSpecifique));   // 10
    IntegrerTable(IndiqueTypeTable(tpHisto));        // 11

    PostTraitementALGOL;
  finally
    FreeAndNil(vQueryTEMP);
  end;

  mmo_Log.Lines.Add('');
  mmo_Log.Lines.Add('Ecriture de la base Maintenance terminé');

  FMaintenance_DM.RafraichirBaseMaintenance;
  Pan_ActionMaintenance.Enabled := True;
  pct_GBA.Enabled := True;
end;

{$ENDREGION ' Rappatriement + Migration '}




end.

