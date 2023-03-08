unit StatReplicLame_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  // Uses Perso
  AjoutDossier_Frm,
  SuppressionDossier_Frm,
  MonitorStat_Dm,
  // Fin Uses Perso
  Dialogs,
  cxStyles,
  cxCustomData,
  cxGraphics,
  cxFilter,
  cxData,
  cxDataStorage,
  cxGridExportLink,
  cxEdit,
  DateUtils,
  DB,
  cxDBData,
  StdCtrls,
  dxmdaset,
  cxGridLevel,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridDBTableView,
  cxClasses,
  cxControls,
  cxGridCustomView,
  cxGrid,
  RzTabs,
  ExtCtrls,
  RzPanel,
  Buttons,
  RzButton,
  IBCustomDataSet,
  IBQuery,
  RzRadChk,
  RzPrgres,
  RzLabel,
  RzRadGrp,
  ComCtrls,
  RzDTP,
  Menus;

type
  TFrm_StatReplicLame = class(TForm)
    Pan_GestDossier: TRzPanel;
    PGC_StatReplic: TRzPageControl;
    Tab_Dossier: TRzTabSheet;
    Tab_RepEchec: TRzTabSheet;
    Tab_BilanRepJours: TRzTabSheet;
    Tab_Export: TRzTabSheet;
    Tab_Jeton: TRzTabSheet;
    cxGrid_DossierClientDBTableView1: TcxGridDBTableView;
    cxGrid_DossierClientLevel1: TcxGridLevel;
    cxGrid_DossierClient: TcxGrid;
    cxGrid_ReplicJourneeDBTableView1: TcxGridDBTableView;
    cxGrid_ReplicJourneeLevel1: TcxGridLevel;
    cxGrid_ReplicJournee: TcxGrid;
    cxGrid_ExportDBTableView1: TcxGridDBTableView;
    cxGrid_ExportLevel1: TcxGridLevel;
    cxGrid_Export: TcxGrid;
    cxGrid_JetonsDBTableView1: TcxGridDBTableView;
    cxGrid_JetonsLevel1: TcxGridLevel;
    cxGrid_Jetons: TcxGrid;
    Pan_Rafraichir: TRzPanel;
    Ds_dossiers: TDataSource;
    cxGrid_DossierClientDBTableView1RecId: TcxGridDBColumn;
    cxGrid_DossierClientDBTableView1Client: TcxGridDBColumn;
    cxGrid_DossierClientDBTableView1CheminMonitor: TcxGridDBColumn;
    cxGrid_DossierClientDBTableView1CheminGinkoia: TcxGridDBColumn;
    Pan_Analyse: TRzPanel;
    Pan_DossierFond: TRzPanel;
    Pan_PageJeton: TRzPanel;
    Pan_ButtonJeton: TRzPanel;
    RzButton_Jeton: TRzButton;
    RzButton_JetonLame: TRzButton;
    Ds_ReplicEchec: TDataSource;
    IBQue_Stat: TIBQuery;
    cxGrid_ReplicEchecDBTableView1: TcxGridDBTableView;
    cxGrid_ReplicEchecLevel1: TcxGridLevel;
    cxGrid_ReplicEchec: TcxGrid;
    Ds_BilanReplicJournee: TDataSource;
    Ds_ExportComplet: TDataSource;
    Pan_Export: TRzPanel;
    Pan_PageExport: TRzPanel;
    RzButton_ExportCSV: TRzButton;
    cxGrid_ReplicJourneeDBTableView1RecId: TcxGridDBColumn;
    cxGrid_ReplicJourneeDBTableView1DOSSIER: TcxGridDBColumn;
    cxGrid_ReplicJourneeDBTableView1LOG_SENDER: TcxGridDBColumn;
    cxGrid_ReplicJourneeDBTableView1DER_TENTE: TcxGridDBColumn;
    cxGrid_ReplicJourneeDBTableView1DER_OK: TcxGridDBColumn;
    cxGrid_ReplicJourneeDBTableView1LAMOY: TcxGridDBColumn;
    cxGrid_ExportDBTableView1RecId: TcxGridDBColumn;
    cxGrid_ExportDBTableView1DOSSIER: TcxGridDBColumn;
    cxGrid_ExportDBTableView1LOG_DONE: TcxGridDBColumn;
    cxGrid_ExportDBTableView1LOG_SENDER: TcxGridDBColumn;
    cxGrid_ExportDBTableView1LOG_PROVIDER: TcxGridDBColumn;
    cxGrid_ExportDBTableView1COUNT: TcxGridDBColumn;
    cxGrid_JetonsDBTableView1RecId: TcxGridDBColumn;
    cxGrid_JetonsDBTableView1DOSSIER: TcxGridDBColumn;
    cxGrid_JetonsDBTableView1DERNIER_LECTURE: TcxGridDBColumn;
    cxGrid_JetonsDBTableView1HEURE_JETONS: TcxGridDBColumn;
    cxGrid_JetonsDBTableView1DERNIER_REFRESH: TcxGridDBColumn;
    cxGrid_JetonsDBTableView1CheminGinkoia: TcxGridDBColumn;
    RzPB_Traitement: TRzProgressBar;
    Pan_fenetre: TRzPanel;
    Pan_refresh: TRzPanel;
    BBtn_refresh: TRzBitBtn;
    BBtn_refreshJeton: TRzBitBtn;
    Ds_Jetons: TDataSource;
    Tim_GetRefresh: TTimer;
    Lab_AfficheInfo: TRzLabel;
    RzButton_ExportExcel: TRzButton;
    Pan_fenetreRepEchec: TRzPanel;
    Pan_RepEchecAnalyse: TRzPanel;
    BBtn_refresRepEchec: TRzBitBtn;
    BBtn_RefreshBilan: TRzBitBtn;
    BBtn_Ajout: TRzBitBtn;
    BBtn_Supprimer: TRzBitBtn;
    BBtn_Modifier: TRzBitBtn;
    BBtn_Monter: TRzBitBtn;
    BBtn_Descendre: TRzBitBtn;
    BBtn_AllSelect: TRzBitBtn;
    BBtn_DeselectAll: TRzBitBtn;
    BBtn_Analyse: TRzBitBtn;
    RzCG_OngletAnalyse: TRzCheckGroup;
    RzCB_ReplicEchec: TRzCheckBox;
    RzCB_BilanReplic: TRzCheckBox;
    RzCB_RecptionPaquet: TRzCheckBox;
    RzDT_DateExport2: TRzDateTimePicker;
    RzDT_DateExport1: TRzDateTimePicker;
    Lab_filtreDate: TRzLabel;
    Lab_Filtre2: TRzLabel;
    PopupMenu_SelectDossierEchec: TPopupMenu;
    AjoutSelect: TMenuItem;
    AnalyseSelect: TMenuItem;
    cxGrid_ReplicEchecDBTableView1RecId: TcxGridDBColumn;
    cxGrid_ReplicEchecDBTableView1DOSSIER: TcxGridDBColumn;
    cxGrid_ReplicEchecDBTableView1LOG_SENDER: TcxGridDBColumn;
    cxGrid_ReplicEchecDBTableView1LOG_OK: TcxGridDBColumn;
    cxGrid_ReplicEchecDBTableView1CheminMonitor: TcxGridDBColumn;
    procedure Btn_AjoutsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RzButton_ExportCSVClick(Sender: TObject);
    procedure cxGrid_DossierClientDBTableView1CanSelectRecord(Sender: TcxCustomGridTableView;
      ARecord: TcxCustomGridRecord; var AAllow: Boolean);
    procedure RzButton_JetonClick(Sender: TObject);
    procedure RzButton_JetonLameClick(Sender: TObject);
    procedure BBtn_refreshJetonClick(Sender: TObject);
    procedure Tim_GetRefreshTimer(Sender: TObject);
    procedure BBtn_refreshClick(Sender: TObject);
    procedure PGC_StatReplicChange(Sender: TObject);
    procedure RzButton_ExportExcelClick(Sender: TObject);
    procedure cxGrid_DossierClientDBTableView1DblClick(Sender: TObject);
    procedure cxGrid_JetonsDBTableView1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure RzButton_AllSelectsClick(Sender: TObject);
    procedure BBtn_refresRepEchecClick(Sender: TObject);
    procedure BBtn_RefreshBilanClick(Sender: TObject);
    procedure cxGrid_JetonsDBTableView1CustomDrawGroupCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableCellViewInfo; var ADone: Boolean);
    procedure BBtn_AjoutClick(Sender: TObject);
    procedure BBtn_SupprimerClick(Sender: TObject);
    procedure BBtn_ModifierClick(Sender: TObject);
    procedure BBtn_MonterClick(Sender: TObject);
    procedure BBtn_DescendreClick(Sender: TObject);
    procedure BBtn_AllSelectClick(Sender: TObject);
    procedure BBtn_AnalyseClick(Sender: TObject);
    procedure RzDT_DateExport1Change(Sender: TObject);
    procedure RzDT_DateExport2Change(Sender: TObject);
    procedure AjoutSelectClick(Sender: TObject);
    procedure AnalyseSelectClick(Sender: TObject);
    procedure BBtn_DeselectAllClick(Sender: TObject);
    procedure cxGrid_ReplicJourneeDBTableView1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

type
  TrecordLigne = record
    sDossier: string;
    sCheminMonitor: string;
    sCheminGinkoia: string;
  end;

type
  TSelectedDossier = record
    sDossier: string;
    sCheminMonitor: string;
    sCheminGinkoia: string;
  end;

var
  Frm_StatReplicLame: TFrm_StatReplicLame;
  gsCheminProg: string;

  //Requete
  sReqReplicEchec: string;
  sReqBilanReplicDay: string;
  sReqExportComplet: string;
  sReqJetons: string;

  //date du jour
  LastDate: TDateTime;
  tNowJeton: TDateTime;
  tTimeTimer: TDateTime;
  tTimeDAnalyse: TDateTime;
  tTimeEchecReplic: TDateTime;
  tRefreshBilanRep: TDateTime;
  tRefreshJeton: TDateTime;
  tTimeExport: TDateTime;
  tTimeZone: TTimeZoneInformation;

  sDateExport1: string;
  sDateExport2: string;

  tDossierSelected: array of TSelectedDossier;

  //Procedure connection base de donnee
procedure TraitementBilanReplic(const CNomDossier: string; const CcheminMonitor: string; const CcheminGinkoia: string);
procedure TraitementEchecReplic(const CNomDossier: string; const CcheminMonitor: string; const CcheminGinkoia: string);
procedure TraitementExportComplet(const CNomDossier: string; const CcheminMonitor: string; const CcheminGinkoia: string);
procedure EffaceCxGrid();
procedure QuiJeton(const CNomDossier: string; const CcheminGinkoia: string);
procedure AfficheOngletApresAnalyse();

//Bloquer l'utilisation de la souris lors des traitements
function BlockInput(fBlockInput: Boolean): DWORD; stdcall; external 'user32.DLL';

implementation

{$R *.dfm}

//Procedure traitement des donenees de la cxgrid Bilan replic jours

procedure TraitementBilanReplic(const CNomDossier: string; const CcheminMonitor: string; const CcheminGinkoia: string);
begin
  // Si le chemin de la base est bien un fichier IB ou not NULL
  if Pos('.IB', UpperCase(CcheminMonitor)) <> 0 then
  begin
    tRefreshBilanRep := Now;

    Dm_MonitorStat.IBDB_ConnetionStat.Connected := False;
    Dm_MonitorStat.IBDB_ConnetionStat.DatabaseName := CcheminMonitor;
    Dm_MonitorStat.IBDB_ConnetionStat.Connected := True;

    Frm_StatReplicLame.IBQue_Stat.Close;
    Frm_StatReplicLame.IBQue_Stat.SQL.Clear;
    Frm_StatReplicLame.IBQue_Stat.SQL.Add(sReqBilanReplicDay);
    Frm_StatReplicLame.IBQue_Stat.Open;

    while not Frm_StatReplicLame.IBQue_Stat.eof do begin
      Dm_MonitorStat.MemD_BilanReplicJournee.Append;
      Dm_MonitorStat.MemD_BilanReplicJourneeDOSSIER.AsString := CNomDossier;
      Dm_MonitorStat.MemD_BilanReplicJourneeLOG_SENDER.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('LOG_SENDER').AsString;
      Dm_MonitorStat.MemD_BilanReplicJourneeDER_TENTE.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('DER_TENTE').AsString;
      Dm_MonitorStat.MemD_BilanReplicJourneeDER_OK.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('DER_OK').AsString;
      Dm_MonitorStat.MemD_BilanReplicJourneeLAMOY.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('LAMOY').AsString;
      Dm_MonitorStat.MemD_BilanReplicJournee.Post;
      Frm_StatReplicLame.IBQue_Stat.Next;
    end;

  end;
  Frm_StatReplicLame.IBQue_Stat.Close;
end;

//Procedure traitement des donenees de la cxgrid Echec replic

procedure TraitementEchecReplic(const CNomDossier: string; const CcheminMonitor: string; const CcheminGinkoia: string);
begin

  if Pos('.IB', UpperCase(CcheminMonitor)) <> 0 then
  begin
    Dm_MonitorStat.IBDB_ConnetionStat.Connected := False;
    Dm_MonitorStat.IBDB_ConnetionStat.DatabaseName := CcheminMonitor;
    Dm_MonitorStat.IBDB_ConnetionStat.Connected := True;

    Frm_StatReplicLame.IBQue_Stat.Close;
    Frm_StatReplicLame.IBQue_Stat.SQL.Clear;
    Frm_StatReplicLame.IBQue_Stat.SQL.Add(sReqReplicEchec);
    Frm_StatReplicLame.IBQue_Stat.Open;

    while not Frm_StatReplicLame.IBQue_Stat.eof do begin
      Dm_MonitorStat.MemD_ReplicEchec.Append;
      Dm_MonitorStat.MemD_ReplicEchecDOSSIER.AsString := CNomDossier;
      Dm_MonitorStat.MemD_ReplicEchecLOG_SENDER.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('LOG_SENDER').AsString;
      Dm_MonitorStat.MemD_ReplicEchecLOG_OK.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('LOG_OK').AsString;
      Dm_MonitorStat.MemD_ReplicEchecCheminMonitor.AsString := CcheminMonitor;
      Dm_MonitorStat.MemD_ReplicEchec.Post;
      Frm_StatReplicLame.IBQue_Stat.Next;
    end;
  end;
  Frm_StatReplicLame.IBQue_Stat.Close;
end;

//Procedure traitement des donenees de la cxgrid Export complet

procedure TraitementExportComplet(const CNomDossier: string; const CcheminMonitor: string; const CcheminGinkoia: string);
var
  a: Integer;
  j: Integer;
  itest: Integer;
  ISTnbPaquet: array of string;
  ISTnomPaquet: array of string;
  ISTserveurPaquet: array of string;
begin

  a := 0;
  j := 0;

  //date du jours - 1 mois
  LastDate := Now() - 30;
  //Verification si chemin monitor correct puis traitement
  if Pos('.IB', UpperCase(CcheminMonitor)) <> 0 then
  begin
    Dm_MonitorStat.IBDB_ConnetionStat.Connected := False;
    Dm_MonitorStat.IBDB_ConnetionStat.DatabaseName := CcheminMonitor;
    Dm_MonitorStat.IBDB_ConnetionStat.Connected := True;

    Frm_StatReplicLame.IBQue_Stat.Close;
    Frm_StatReplicLame.IBQue_Stat.SQL.Clear;
    Frm_StatReplicLame.IBQue_Stat.SQL.Add('SELECT LOG_DONE, LOG_SENDER, LOG_PROVIDER, COUNT(LOG_ID)');
    Frm_StatReplicLame.IBQue_Stat.SQL.Add(' FROM STAT_SERVEUR WHERE LOG_DONE BETWEEN :DateExport1 AND :DateExport2');
    Frm_StatReplicLame.IBQue_Stat.SQL.Add(' GROUP BY LOG_DONE, LOG_SENDER, LOG_PROVIDER');
    Frm_StatReplicLame.IBQue_Stat.SQL.Add(' ORDER BY LOG_DONE');
    Frm_StatReplicLame.IBQue_Stat.Params.ParamByName('DateExport1').AsString := sDateExport1;
    Frm_StatReplicLame.IBQue_Stat.Params.ParamByName('DateExport2').AsString := sDateExport2;
    Frm_StatReplicLame.IBQue_Stat.Open;

    while not Frm_StatReplicLame.IBQue_Stat.eof do begin
      Dm_MonitorStat.MemD_ExportComplet.Append;
      Dm_MonitorStat.MemD_ExportCompletDOSSIER.AsString := CNomDossier;
      Dm_MonitorStat.MemD_ExportCompletLOG_DONE.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('LOG_DONE').AsString;
      Dm_MonitorStat.MemD_ExportCompletLOG_SENDER.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('LOG_SENDER').AsString;
      Dm_MonitorStat.MemD_ExportCompletLOG_PROVIDER.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('LOG_PROVIDER').AsString;
      Dm_MonitorStat.MemD_ExportCompletCOUNT.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('COUNT').AsString;

      SetLength(ISTnbPaquet, a + 1);
      SetLength(ISTnomPaquet, a + 1);
      SetLength(ISTserveurPaquet, a + 1);

      ISTserveurPaquet[a] := Frm_StatReplicLame.IBQue_Stat.FieldByName('LOG_SENDER').AsString;
      ISTnbPaquet[a] := Frm_StatReplicLame.IBQue_Stat.FieldByName('COUNT').AsString;
      ISTnomPaquet[a] := Frm_StatReplicLame.IBQue_Stat.FieldByName('LOG_PROVIDER').AsString;

      if ((a mod 2 <> 0) and (a >= 1)) then
      begin
        if ((ISTnbPaquet[a] = ISTnbPaquet[a - 1]) and (ISTnomPaquet[a] <> ISTnomPaquet[a - 1]) and (ISTserveurPaquet[a] = ISTserveurPaquet[a - 1])) then
        begin
          Dm_MonitorStat.MemD_ExportComplet.Edit;
          Dm_MonitorStat.MemD_ExportComplet.Prior;
          Dm_MonitorStat.MemD_ExportComplet.Delete;
          Dm_MonitorStat.MemD_ExportComplet.Next;
          Dm_MonitorStat.MemD_ExportComplet.Delete;
        end else
        begin
        end;
      end;

      a := a + 1;
      Frm_StatReplicLame.IBQue_Stat.Next;
    end;

    while not Dm_MonitorStat.MemD_ExportComplet.Eof do
    begin
      //on travail sur les nombres impaires
      if j mod 2 <> 0 then
      begin

      end;
      Inc(j, 1);
      Dm_MonitorStat.MemD_ExportComplet.Next;
    end;

  end;
  Frm_StatReplicLame.IBQue_Stat.Close;
end;

//Procedure pour effacer les cxgrid

procedure EffaceCxGrid();
begin
  // Effacer toutes les CxGrid
  with Dm_MonitorStat.MemD_ReplicEchec do
  begin
    Close;
    Open;
  end;

  with Dm_MonitorStat.MemD_BilanReplicJournee do
  begin
    Close;
    Open;
  end;

  with Dm_MonitorStat.MemD_ExportComplet do
  begin
    Close;
    Open;
  end;

  //  with Dm_MonitorStat.MemD_Jetons do
  //  begin
  //    Close;
  //    Open;
  //  end;
end;

//Procedure pour savoir qui a le jeton

procedure QuiJeton(const CNomDossier: string; const CcheminGinkoia: string);
var
  HeureGMT: TSystemTime;
  tHeureUTC: TDateTime;
  tHeureLocal: TSystemTime;
begin
  //Dans le cas ou le chemin ginkoia n'aurait pas été rempli
  if Pos('.IB', UpperCase(CcheminGinkoia)) <> 0 then
  begin
    Dm_MonitorStat.IBDB_ConnetionStat.Connected := False;
    Dm_MonitorStat.IBDB_ConnetionStat.DatabaseName := CcheminGinkoia;
    Dm_MonitorStat.IBDB_ConnetionStat.Connected := True;

    Frm_StatReplicLame.IBQue_Stat.Close;
    Frm_StatReplicLame.IBQue_Stat.SQL.Clear;
    Frm_StatReplicLame.IBQue_Stat.SQL.Add('SELECT BAS_IDENT||''-''||BAS_NOM AS JETON, JET_STAMP');
    Frm_StatReplicLame.IBQue_Stat.SQL.Add('FROM genjetons');
    Frm_StatReplicLame.IBQue_Stat.SQL.Add('join genbases on jet_basid = bas_id');
    Frm_StatReplicLame.IBQue_Stat.SQL.Add('WHERE JET_NOMPOSTE = ''WEBSERVICE''');

    tRefreshJeton := Now;
    tTimeTimer := Now;
    Frm_StatReplicLame.IBQue_Stat.Open;

    // si vide -> traiter le cas du jeton libre
    if Frm_StatReplicLame.IBQue_Stat.Eof then
    begin
      Dm_MonitorStat.MemD_Jetons.Edit;
      Dm_MonitorStat.MemD_JetonsDOSSIER.AsString := CNomDossier;
      Dm_MonitorStat.MemD_JetonsDERNIER_LECTURE.AsString := 'Jeton libre';
      Dm_MonitorStat.MemD_JetonsHEURE_JETONS.AsString := '';
      Dm_MonitorStat.MemD_JetonsDERNIER_REFRESH.AsString := FormatDateTime('dd/mm/yyyy hh:mm:ss', Now);
      Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString := CcheminGinkoia;
      Dm_MonitorStat.MemD_Jetons.Post;
    end else
    begin
      // sinon cas général
      //Parcours dans le cas si il y a plusieurs enrgistrements le dernier sera afficher
      while not Frm_StatReplicLame.IBQue_Stat.eof do begin
        Dm_MonitorStat.MemD_Jetons.Edit;

        if Frm_StatReplicLame.IBQue_Stat.FieldByName('JETON').AsString <> '' then
        begin
          Dm_MonitorStat.MemD_JetonsDOSSIER.AsString := CNomDossier;
          Dm_MonitorStat.MemD_JetonsDERNIER_LECTURE.AsString := Frm_StatReplicLame.IBQue_Stat.FieldByName('JETON').AsString;
          tHeureUTC := Frm_StatReplicLame.IBQue_Stat.FieldByName('JET_STAMP').AsDateTime;

          //convert UTC en HEURE LOCAL
          DateTimeToSystemTime(tHeureUTC, HeureGMT);

          case GetTimeZoneInformation(tTimeZone) of
            TIME_ZONE_ID_STANDARD:
              begin
                //tTimeZone.StandardName;
                tTimeZone.Bias := 1;
              end;
            TIME_ZONE_ID_DAYLIGHT:
              begin
                //tTimeZone.DaylightName;
                tTimeZone.Bias := 2;
              end;
          end;
          if SystemTimeToTzSpecificLocalTime(nil, HeureGMT, tHeureLocal) then
            // FIN CONVERTION

            Dm_MonitorStat.MemD_JetonsHEURE_JETONS.AsString := DateTimeToStr(SystemTimeToDateTime(tHeureLocal));

          Dm_MonitorStat.MemD_JetonsDERNIER_REFRESH.AsString := FormatDateTime('dd/mm/yyyy hh:mm:ss', Now);
          Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString := CcheminGinkoia;
          Dm_MonitorStat.MemD_Jetons.Post;
        end;
        Frm_StatReplicLame.IBQue_Stat.Next;
      end;
    end;
  end else
  begin
    Dm_MonitorStat.MemD_Jetons.Edit;
    Dm_MonitorStat.MemD_JetonsDERNIER_LECTURE.AsString := 'Base de donnée introuvable';
    Dm_MonitorStat.MemD_Jetons.Post;
  end;
  Frm_StatReplicLame.IBQue_Stat.Close;
end;

//Procedure qui permet d'afficher le bon onglet apres analyse

procedure AfficheOngletApresAnalyse();
begin
  if ((Frm_StatReplicLame.RzCB_ReplicEchec.Checked) and (Frm_StatReplicLame.RzCB_BilanReplic.Checked) and (Frm_StatReplicLame.RzCB_RecptionPaquet.Checked)) then
    Frm_StatReplicLame.Tab_RepEchec.Show;

  if ((Frm_StatReplicLame.RzCB_ReplicEchec.Checked = false) and (Frm_StatReplicLame.RzCB_BilanReplic.Checked) and (Frm_StatReplicLame.RzCB_RecptionPaquet.Checked)) then
    Frm_StatReplicLame.Tab_BilanRepJours.Show;

  if ((Frm_StatReplicLame.RzCB_ReplicEchec.Checked = false) and (Frm_StatReplicLame.RzCB_BilanReplic.Checked = false) and (Frm_StatReplicLame.RzCB_RecptionPaquet.Checked)) then
    Frm_StatReplicLame.Tab_Export.Show;

  if ((Frm_StatReplicLame.RzCB_ReplicEchec.Checked = false) and (Frm_StatReplicLame.RzCB_BilanReplic.Checked) and (Frm_StatReplicLame.RzCB_RecptionPaquet.Checked = False)) then
    Frm_StatReplicLame.Tab_BilanRepJours.Show;

  if ((Frm_StatReplicLame.RzCB_ReplicEchec.Checked) and (Frm_StatReplicLame.RzCB_BilanReplic.Checked) and (Frm_StatReplicLame.RzCB_RecptionPaquet.Checked = False)) then
    Frm_StatReplicLame.Tab_RepEchec.Show;

  if ((Frm_StatReplicLame.RzCB_ReplicEchec.Checked) and (Frm_StatReplicLame.RzCB_BilanReplic.Checked = False) and (Frm_StatReplicLame.RzCB_RecptionPaquet.Checked
    )) then
    Frm_StatReplicLame.Tab_RepEchec.Show;

  if ((Frm_StatReplicLame.RzCB_ReplicEchec.Checked) and (Frm_StatReplicLame.RzCB_BilanReplic.Checked = False) and (Frm_StatReplicLame.RzCB_RecptionPaquet.Checked = False)) then
    Frm_StatReplicLame.Tab_RepEchec.Show;
end;

//Rafraichir la cxgrid Bilan replic journee

procedure TFrm_StatReplicLame.AjoutSelectClick(Sender: TObject);
var
  i: Integer;
  j: Integer;
  iNbSeelctdossierEchec: Integer;
begin
  i := 0;
  j := 0;

  for i := low(tDossierSelected) to high(tDossierSelected) do
  begin
    j := j + 1;
  end;
  iNbSeelctdossierEchec := cxGrid_ReplicEchecDBTableView1.Controller.SelectedRecordCount;
  SetLength(tDossierSelected, iNbSeelctdossierEchec + j);

  with cxGrid_ReplicEchecDBTableView1.DataController.DataSet do
  begin
    First;
    while not EOF do
    begin
      if cxGrid_ReplicEchecDBTableView1.Controller.FocusedRecord.Selected then
      begin
        tDossierSelected[j].sDossier := Dm_MonitorStat.MemD_ReplicEchec.FieldByName('Dossier').AsString;
        tDossierSelected[j].sCheminMonitor := Dm_MonitorStat.MemD_ReplicEchec.FieldByName('CheminMonitor').AsString;
        j := j + 1;
      end;
      Next;
    end;
  end;

  //griser les tabs page controls
  Tab_BilanRepJours.TabEnabled := True;
  Tab_Export.TabEnabled := True;

end;

procedure TFrm_StatReplicLame.AnalyseSelectClick(Sender: TObject);
var
  i: Integer;
  j: Integer;
  iNbSeelctdossierEchec: Integer;
begin
  i := 0;
  j := 0;

  for i := low(tDossierSelected) to high(tDossierSelected) do
  begin
    tDossierSelected[j].sDossier := '';
    tDossierSelected[j].sCheminMonitor := '';
    tDossierSelected[j].sCheminGinkoia := '';
  end;

  iNbSeelctdossierEchec := cxGrid_ReplicEchecDBTableView1.Controller.SelectedRecordCount;
  SetLength(tDossierSelected, iNbSeelctdossierEchec);

  with cxGrid_ReplicEchecDBTableView1.DataController.DataSet do
  begin
    First;
    while not EOF do
    begin
      if cxGrid_ReplicEchecDBTableView1.Controller.FocusedRecord.Selected then
      begin
        tDossierSelected[j].sDossier := Dm_MonitorStat.MemD_ReplicEchec.FieldByName('Dossier').AsString;
        tDossierSelected[j].sCheminMonitor := Dm_MonitorStat.MemD_ReplicEchec.FieldByName('CheminMonitor').AsString;
        j := j + 1;
      end;
      Next;
    end;
  end;

  //griser les tabs page controls
  Tab_BilanRepJours.TabEnabled := True;
  Tab_Export.TabEnabled := True;

end;

procedure TFrm_StatReplicLame.BBtn_AjoutClick(Sender: TObject);
var
  sNom: string;
  sCheminMonitor: string;
  sCheminGinkoia: string;
begin
  sNom := '';
  sCheminMonitor := '';
  sCheminGinkoia := '';

  if ExecuteFormModif(sNom, sCheminMonitor, sCheminGinkoia) then
  begin
    Dm_MonitorStat.MemD_GestDossier.Append;
    Dm_MonitorStat.MemD_GestDossierClient.AsString := sNom;
    Dm_MonitorStat.MemD_GestDossierCheminMonitor.AsString := sCheminMonitor;
    Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString := sCheminGinkoia;
    Dm_MonitorStat.MemD_GestDossier.Post;
    Dm_MonitorStat.MemD_GestDossier.SaveToTextFile(gsCheminProg + '\Clients\ListeClients.csv');

    //Mis à jour du mem data jeton
    Dm_MonitorStat.MemD_Jetons.Open;
    Dm_MonitorStat.MemD_Jetons.Append;
    Dm_MonitorStat.MemD_JetonsDOSSIER.AsString := sNom;
    Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString := sCheminGinkoia;
    Dm_MonitorStat.MemD_Jetons.Post;
  end;
end;

//Sélection tout les dossiers

procedure TFrm_StatReplicLame.BBtn_AllSelectClick(Sender: TObject);
begin
  cxGrid_DossierClientDBTableView1.Controller.SelectAllRecords;
  cxGrid_DossierClient.SetFocus;
end;

//Analyse puis traitement SQL des dossier selectionner

procedure TFrm_StatReplicLame.BBtn_AnalyseClick(Sender: TObject);
var
  IstDossierSelect: array of string;
  iNbLigneSelect: Integer;
  i: Integer;
  j: integer;
begin
  if ((RzCB_ReplicEchec.Checked = False) and (RzCB_RecptionPaquet.Checked = False) and (RzCB_BilanReplic.Checked = False)) then
  begin
    MessageDlg('Veuillez sélectionner au moins un onglet a analyser', mtInformation, [mbOK], 0);
    Exit;
  end;

  if cxGrid_DossierClientDBTableView1.Controller.FocusedRecord.Selected then
  begin
    //efface cxGrid
    EffaceCxGrid;

    //griser les tabs page controls
    Tab_RepEchec.TabEnabled := False;
    Tab_BilanRepJours.TabEnabled := False;
    Tab_Export.TabEnabled := False;

    //timer
    Tim_GetRefresh.Enabled := False;

    //heure de la dernière analyse
    tTimeDAnalyse := now;
    tTimeEchecReplic := Now;
    tRefreshJeton := Now;
    tTimeExport := Now;

    //Variable pour la progress Bar
    iNbLigneSelect := cxGrid_DossierClientDBTableView1.Controller.SelectedRecordCount;
    i := 0;
    RzPB_Traitement.Percent := 0;

    j := 0;
    SetLength(tDossierSelected, iNbLigneSelect);

    //ouvrir mem DATA
    Dm_MonitorStat.MemD_ReplicEchec.Open;
    Dm_MonitorStat.MemD_BilanReplicJournee.Open;
    Dm_MonitorStat.MemD_ExportComplet.Open;
    Dm_MonitorStat.MemD_Jetons.Open;

    //rendre les pages control consultable

    Lab_AfficheInfo.Caption := '';

    SetLength(IstDossierSelect, cxGrid_DossierClientDBTableView1.Controller.SelectedRowCount);

    with cxGrid_DossierClientDBTableView1.DataController.DataSet do
    begin
      First;
      Screen.Cursor := crSQLWait;
      //BlockInput(True);
      RzPB_Traitement.Visible := True;
      RzPB_Traitement.Refresh;
      //Label les espaces sont pour laffichage
      Lab_AfficheInfo.Caption := 'Analyse et traitement SQL des clients en cours ...                                    ';
      while not EOF do
      begin
        if cxGrid_DossierClientDBTableView1.Controller.FocusedRecord.Selected then
        begin
          //remplissage du record des dossiers sélectionés pour utilisation ultérieur
          tDossierSelected[i].sDossier := Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString;
          tDossierSelected[i].sCheminMonitor := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminMonitor').AsString;
          tDossierSelected[i].sCheminGinkoia := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminGinkoia').AsString;

          try
            //traitement SQL
            if RzCB_ReplicEchec.Checked then
            begin
              TraitementEchecReplic(Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString, Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminMonitor').AsString, Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminGinkoia').AsString);
              Tab_RepEchec.TabEnabled := True;
            end;

            if RzCB_BilanReplic.Checked then
            begin
              TraitementBilanReplic(Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString, Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminMonitor').AsString, Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminGinkoia').AsString);
              Tab_BilanRepJours.TabEnabled := True;
            end;

            if RzCB_RecptionPaquet.Checked then
            begin
              TraitementExportComplet(Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString, Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminMonitor').AsString, Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminGinkoia').AsString);
              Tab_Export.TabEnabled := True;
            end;

          except on e: Exception do
            begin
              //affiche le nom du client + plus le message d'erreur à qui il s'adresse
              //Dans le IstDossierSelectEnlever enlever les clients sur lesquels le traitement c'est pas fait
              i := i - 1;
              //Message erreur
              MessageDlg(UpperCase(Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString) + ' ' + e.Message, mtInformation, [mbOK], 0);
            end;
          end;

          IstDossierSelect[i] := Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString;

          //Incrementation progress Bar
          i := i + 1;
          RzPB_Traitement.Percent := round((i / iNbLigneSelect) * 100);
        end;
        Next;
      end;
    end;
    Screen.Cursor := crDefault;
    RzPB_Traitement.Visible := False;
    Lab_AfficheInfo.Caption := '';
    AfficheOngletApresAnalyse();
  end else
  begin
    MessageDlg('Veuillez sélectionner au moins une base à analyser', mtInformation, [mbOK], 0);
  end;
end;

//Faire descendre la sélection cxgrid dossier

procedure TFrm_StatReplicLame.BBtn_DescendreClick(Sender: TObject);
var
  BmDescendre: TBookmark;
  Tligne1: TrecordLigne;
  Tligne2: TrecordLigne;

  iLigneSelect: Integer;
  nbLigne: Integer;
begin
  iLigneSelect := cxGrid_DossierClientDBTableView1.Controller.FocusedRecordIndex + 1;
  nbLigne := cxGrid_DossierClientDBTableView1.DataController.RecordCount;

  //ShowMessage(IntToStr(iLigneSelect)+' '+IntToStr(nbLigne));
  if iLigneSelect <= nbLigne - 1 then
  begin
    BmDescendre := Dm_MonitorStat.MemD_GestDossier.GetBookmark;

    //Ligne courante
    Dm_MonitorStat.MemD_GestDossier.GotoBookmark(BmDescendre);

    Tligne1.sDossier := Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString;
    Tligne1.sCheminMonitor := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminMonitor').AsString;
    Tligne1.sCheminGinkoia := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminGinkoia').AsString;

    //Ligne Suivante
    Dm_MonitorStat.MemD_GestDossier.Next;
    Tligne2.sDossier := Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString;
    Tligne2.sCheminMonitor := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminMonitor').AsString;
    Tligne2.sCheminGinkoia := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminGinkoia').AsString;

    //on revient a la ligne courante insertion
    Dm_MonitorStat.MemD_GestDossier.Prior;
    Dm_MonitorStat.MemD_GestDossier.Edit;
    Dm_MonitorStat.MemD_GestDossierClient.AsString := Tligne2.sDossier;
    Dm_MonitorStat.MemD_GestDossierCheminMonitor.AsString := Tligne2.sCheminMonitor;
    Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString := Tligne2.sCheminGinkoia;
    Dm_MonitorStat.MemD_GestDossier.Post;

    //on revient a la ligne courante insertion
    Dm_MonitorStat.MemD_GestDossier.Next;
    Dm_MonitorStat.MemD_GestDossier.Edit;
    Dm_MonitorStat.MemD_GestDossierClient.AsString := Tligne1.sDossier;
    Dm_MonitorStat.MemD_GestDossierCheminMonitor.AsString := Tligne1.sCheminMonitor;
    Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString := Tligne1.sCheminGinkoia;

    Dm_MonitorStat.MemD_GestDossier.Post;
    //enregistrement
    Dm_MonitorStat.MemD_GestDossier.SaveToTextFile(gsCheminProg + '\Clients\ListeClients.csv');
  end else
  begin
    MessageDlg('Modification de la position impossible', mtInformation, [mbOK], 0);
  end;
end;

procedure TFrm_StatReplicLame.BBtn_DeselectAllClick(Sender: TObject);
begin
  with cxGrid_DossierClientDBTableView1.DataController.DataSet do
  begin
    First;
    while not EOF do
    begin
      if cxGrid_DossierClientDBTableView1.Controller.FocusedRecord.Selected then
      begin
        cxGrid_DossierClientDBTableView1.Controller.FocusedRecord.Selected := False;
      end;
      Next;
    end;
  end;
end;

//Modifier la sélection cxgrid dossier

procedure TFrm_StatReplicLame.BBtn_ModifierClick(Sender: TObject);
var
  sNom: string;
  sCheminMonitor: string;
  sCheminGinkoia: string;
  iNbligneSelect: Integer;
begin
  iNbligneSelect := cxGrid_DossierClientDBTableView1.Controller.SelectedRecordCount;

  if iNbligneSelect = 1 then
  begin
    sNom := Dm_MonitorStat.MemD_GestDossierClient.AsString;
    sCheminMonitor := Dm_MonitorStat.MemD_GestDossierCheminMonitor.AsString;
    sCheminGinkoia := Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString;

    if ExecuteFormModif(sNom, sCheminMonitor, sCheminGinkoia) then
    begin
      Dm_MonitorStat.MemD_GestDossier.Edit;
      Dm_MonitorStat.MemD_GestDossierClient.AsString := sNom;
      Dm_MonitorStat.MemD_GestDossierCheminMonitor.AsString := sCheminMonitor;
      Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString := sCheminGinkoia;
      Dm_MonitorStat.MemD_GestDossier.Post;

      Dm_MonitorStat.MemD_Jetons.Edit;
      Dm_MonitorStat.MemD_JetonsDOSSIER.AsString := sNom;
      Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString := sCheminGinkoia;
      Dm_MonitorStat.MemD_Jetons.Post;

      Dm_MonitorStat.MemD_GestDossier.SaveToTextFile(gsCheminProg + '\Clients\ListeClients.csv');
    end;
  end else
  begin
    MessageDlg('Modification multiple impossible ', mtInformation, [mbOK], 0);
  end;
end;

//Faire remonter la selection cxgrid dossier

procedure TFrm_StatReplicLame.BBtn_MonterClick(Sender: TObject);
var
  BmMonter: TBookmark;
  Tligne1: TrecordLigne;
  Tligne2: TrecordLigne;

  iLigneSelect: Integer;
begin
  iLigneSelect := cxGrid_DossierClientDBTableView1.Controller.FocusedRecordIndex;
  if iLigneSelect > 0 then
  begin
    BmMonter := Dm_MonitorStat.MemD_GestDossier.GetBookmark;

    //Ligne courante
    Dm_MonitorStat.MemD_GestDossier.GotoBookmark(BmMonter);

    Tligne1.sDossier := Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString;
    Tligne1.sCheminMonitor := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminMonitor').AsString;
    Tligne1.sCheminGinkoia := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminGinkoia').AsString;

    //Ligne Suivante
    Dm_MonitorStat.MemD_GestDossier.Prior;
    Tligne2.sDossier := Dm_MonitorStat.MemD_GestDossier.FieldByName('Client').AsString;
    Tligne2.sCheminMonitor := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminMonitor').AsString;
    Tligne2.sCheminGinkoia := Dm_MonitorStat.MemD_GestDossier.FieldByName('CheminGinkoia').AsString;

    //on revient a la ligne courante insertion
    Dm_MonitorStat.MemD_GestDossier.Next;
    Dm_MonitorStat.MemD_GestDossier.Edit;
    Dm_MonitorStat.MemD_GestDossierClient.AsString := Tligne2.sDossier;
    Dm_MonitorStat.MemD_GestDossierCheminMonitor.AsString := Tligne2.sCheminMonitor;
    Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString := Tligne2.sCheminGinkoia;
    Dm_MonitorStat.MemD_GestDossier.Post;

    //on revient a la ligne courante insertion
    Dm_MonitorStat.MemD_GestDossier.Prior;
    Dm_MonitorStat.MemD_GestDossier.Edit;
    Dm_MonitorStat.MemD_GestDossierClient.AsString := Tligne1.sDossier;
    Dm_MonitorStat.MemD_GestDossierCheminMonitor.AsString := Tligne1.sCheminMonitor;
    Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString := Tligne1.sCheminGinkoia;

    Dm_MonitorStat.MemD_GestDossier.Post;
    //enregistrement
    Dm_MonitorStat.MemD_GestDossier.SaveToTextFile(gsCheminProg + '\Clients\ListeClients.csv');
  end else
  begin
    MessageDlg('Modification de la position impossible', mtInformation, [mbOK], 0);
  end;
end;

procedure TFrm_StatReplicLame.BBtn_RefreshBilanClick(Sender: TObject);
var
  i: Integer;
  j: Integer;
begin

  j := 0;
  //Efface le memD_Bilan replic
  with Dm_MonitorStat.MemD_ExportComplet do
  begin
    Close;
    Open;
  end;

  Screen.Cursor := crSQLWait;
  //BlockInput(True);
  Lab_AfficheInfo.Refresh;
  //Parcours du record des dossiers qui ont ete analyser
  for i := low(tDossierSelected) to high(tDossierSelected) do
  begin
    Lab_AfficheInfo.Caption := 'Traitement SQL des clients en cours ...                                                                       ';
    try
      TraitementExportComplet(tDossierSelected[j].sDossier, tDossierSelected[j].sCheminMonitor, tDossierSelected[j].sCheminGinkoia);
    Except on e: Exception do
      begin
        MessageDlg(e.Message, mtInformation, [mbOK], 0);
      end;
    end;
    Inc(j, 1);
    //TraitementExportComplet(tDossierSelected[i].sDossier, tDossierSelected[i].sCheminMonitor, tDossierSelected[i].sCheminGinkoia);
  end;

  tTimeExport := Now;
  Lab_AfficheInfo.Caption := 'Dernier rafraichissement des réceptions des paquets : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tTimeExport);
  Frm_StatReplicLame.Lab_AfficheInfo.Refresh;
  Screen.Cursor := crDefault;
  //BlockInput(False);
end;

procedure TFrm_StatReplicLame.BBtn_refreshClick(Sender: TObject);
var
  i: Integer;
  //Efface le memD_Bilan replic
begin
  with Dm_MonitorStat.MemD_BilanReplicJournee do
  begin
    Close;
    Open;
  end;

  Screen.Cursor := crSQLWait;
  BlockInput(True);
  Lab_AfficheInfo.Refresh;
  //Parcours du record des dossiers qui ont ete analyser
  for i := low(tDossierSelected) to high(tDossierSelected) do
  begin
    Lab_AfficheInfo.Caption := 'Traitement SQL des clients en cours ...                                                                       ';
    TraitementBilanReplic(tDossierSelected[i].sDossier, tDossierSelected[i].sCheminMonitor, tDossierSelected[i].sCheminGinkoia);
  end;
  tRefreshBilanRep := Now;
  Lab_AfficheInfo.Caption := 'Dernière analyse du Bilan journée : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tRefreshBilanRep);
  Frm_StatReplicLame.Lab_AfficheInfo.Refresh;
  Screen.Cursor := crDefault;
  BlockInput(False);
end;

//Rafraichir qui à le jeton des dossier selectionner

procedure TFrm_StatReplicLame.BBtn_refreshJetonClick(Sender: TObject);
begin
  Tim_GetRefresh.Enabled := True;
  Screen.Cursor := crSQLWait;
  BlockInput(True);
  with cxGrid_JetonsDBTableView1.DataController.DataSet do
  begin
    First;
    while not EOF do
    begin
      if cxGrid_JetonsDBTableView1.Controller.FocusedRecord.Selected then
      begin
        Lab_AfficheInfo.Caption := 'Traitement SQL des clients en cours ...                                                                       ';
        QuiJeton(Dm_MonitorStat.MemD_JetonsDOSSIER.AsString, Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString);
      end;
      Next;
    end;
  end;
  Lab_AfficheInfo.Caption := 'Dernière rafraîchissement : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tRefreshJeton);
  Screen.Cursor := crDefault;
  BlockInput(False);
end;

//Bouton pour rafraichir les replic en echec

procedure TFrm_StatReplicLame.BBtn_refresRepEchecClick(Sender: TObject);
var
  i: Integer;
begin
  with Dm_MonitorStat.MemD_ReplicEchec do
  begin
    Close;
    Open;
  end;
  Screen.Cursor := crSQLWait;
  BlockInput(True);
  Lab_AfficheInfo.Refresh;
  //Parcours du record des dossiers qui ont ete analyser
  for i := low(tDossierSelected) to high(tDossierSelected) do
  begin
    Lab_AfficheInfo.Caption := 'Traitement SQL des clients en cours ...                                                                       ';
    TraitementEchecReplic(tDossierSelected[i].sDossier, tDossierSelected[i].sCheminMonitor, tDossierSelected[i].sCheminGinkoia);
  end;
  tTimeEchecReplic := Now;
  Lab_AfficheInfo.Caption := 'Dernière analyse des réplications en ehec : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tTimeEchecReplic);
  Frm_StatReplicLame.Lab_AfficheInfo.Refresh;
  Screen.Cursor := crDefault;
  BlockInput(False);
end;

//Supression d'un element dans la liste des dossiers

procedure TFrm_StatReplicLame.BBtn_SupprimerClick(Sender: TObject);
var
  sNom: string;
  iNbligneSelect: Integer;
begin
  sNom := Dm_MonitorStat.MemD_GestDossierClient.AsString;
  iNbligneSelect := cxGrid_DossierClientDBTableView1.Controller.SelectedRecordCount;

  if (cxGrid_DossierClientDBTableView1.Controller.FocusedRecord.Selected) and (iNbligneSelect = 1) then
  begin
    if VerifSuppression(sNom) then
    begin
      cxGrid_DossierClientDBTableView1.DataController.BeginUpdate;
      cxGrid_DossierClientDBTableView1.DataController.DeleteFocused;
      cxGrid_DossierClientDBTableView1.DataController.EndUpdate;

      cxGrid_JetonsDBTableView1.DataController.BeginUpdate;
      cxGrid_JetonsDBTableView1.DataController.DeleteFocused;
      cxGrid_JetonsDBTableView1.DataController.EndUpdate;
      try
        Dm_MonitorStat.MemD_GestDossier.SaveToTextFile(gsCheminProg + '\Clients\ListeClients.csv');
      Except on e: Exception do
        begin
          MessageDlg(e.Message, mtInformation, [mbOK], 0);
        end;
      end;
      cxGrid_DossierClient.Refresh;
    end;
  end else
  begin
    MessageDlg('Suppression multiple impossible ', mtInformation, [mbOK], 0);
  end;

end;

//Ajout d'un nouveau client cxgrid dossier puis sauvegarde dans un fichier CSV

procedure TFrm_StatReplicLame.Btn_AjoutsClick(Sender: TObject);
var
  sNom: string;
  sCheminMonitor: string;
  sCheminGinkoia: string;
begin
  sNom := '';
  sCheminMonitor := '';
  sCheminGinkoia := '';

  if ExecuteFormModif(sNom, sCheminMonitor, sCheminGinkoia) then
  begin
    Dm_MonitorStat.MemD_GestDossier.Append;
    Dm_MonitorStat.MemD_GestDossierClient.AsString := sNom;
    Dm_MonitorStat.MemD_GestDossierCheminMonitor.AsString := sCheminMonitor;
    Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString := sCheminGinkoia;
    Dm_MonitorStat.MemD_GestDossier.Post;
    Dm_MonitorStat.MemD_GestDossier.SaveToTextFile(gsCheminProg + '\Clients\ListeClients.csv');

    //Mis à jour du mem data jeton
    Dm_MonitorStat.MemD_Jetons.Open;
    Dm_MonitorStat.MemD_Jetons.Append;
    Dm_MonitorStat.MemD_JetonsDOSSIER.AsString := sNom;
    Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString := sCheminGinkoia;
    Dm_MonitorStat.MemD_Jetons.Post;
  end;
end;

procedure TFrm_StatReplicLame.cxGrid_DossierClientDBTableView1CanSelectRecord(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; var AAllow: Boolean);
begin
  if not BBtn_Monter.Enabled then
  begin
    BBtn_Monter.Enabled := True;
    BBtn_Descendre.Enabled := True;
    BBtn_Supprimer.Enabled := True;
    BBtn_Modifier.Enabled := True;
    BBtn_Analyse.Enabled := True;
    BBtn_DeselectAll.Enabled := True;
  end;

end;

//lors du double clique sur la cxgrid_dossier acceder sur la modif

procedure TFrm_StatReplicLame.cxGrid_DossierClientDBTableView1DblClick(Sender: TObject);
begin
  if cxGrid_DossierClientDBTableView1.Controller.SelectedRecordCount > 0 then
  begin
    BBtn_Modifier.Click;
  end;
end;

//Procedure pour la colorisation de la cellule DERNIER_REFRESH de la Cxgrid_Jeton lorsque le refresh date de plus d'1mn

procedure TFrm_StatReplicLame.cxGrid_JetonsDBTableView1CustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  sMaStrDateTime: string;
  tMaDateTime: TDateTime;
  tAcutelTime: TDateTime;
begin

  if AViewInfo.Item.ID = 4 then
  begin
    //if ((Dm_MonitorStat.MemD_JetonsDERNIER_REFRESH.AsString <> '') and (AViewInfo.Text <> '')) then
    if (AViewInfo.Text <> '') then
    begin
      tAcutelTime := Now;
      tMaDateTime := StrToDateTime(AViewInfo.RecordViewInfo.GridRecord.Values[(sender as TcxGridDBTableView).GetColumnByFieldName('DERNIER_REFRESH').Index]);
      //tMaDateTime := StrToDateDef(sMaStrDateTime, Now());
      //sMaStrDateTime := DateTimeToStr(tMaDateTime);

       //ShowMessage(DateTimeToStr(tMaDateTime)+'  '+DateTimeToStr(IncMinute(tMaDateTime, 1)));
      //if Abs(tMaDateTime - tTimeTimer) > (1 / 1440) then

      if (tAcutelTime > (IncMinute(tMaDateTime, 1))) then
      begin
        ACanvas.Font.Color := clRed;
      end else
      begin
        //ACanvas.Font.Style := [];
      end;
    end;
    ADone := False;

  end;
end;

procedure TFrm_StatReplicLame.cxGrid_JetonsDBTableView1CustomDrawGroupCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableCellViewInfo; var ADone: Boolean);
var
  sMaStrDateTime: string;
  tMaDateTime: TDateTime;
  tAcutelTime: TDateTime;
begin

  if ((AViewInfo.Selected) and (AViewInfo.GridRecord.GridView.FindItemByName('DERNIER_REFRESH').Caption = 'DERNIER_REFRESH')) then
  begin
    if (AViewInfo.Text <> '') then
    begin
      tAcutelTime := Now;
      tMaDateTime := StrToDateTime(AViewInfo.RecordViewInfo.GridRecord.Values[(sender as TcxGridDBTableView).GetColumnByFieldName('DERNIER_REFRESH').Index]);

      if (tAcutelTime > (IncMinute(tMaDateTime, 1))) then
      begin
        ACanvas.Font.Color := clRed;
      end else
      begin
        //ACanvas.Font.Style := [];
      end;
    end;
    ADone := False;

  end;

end;

procedure TFrm_StatReplicLame.cxGrid_ReplicJourneeDBTableView1CustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  sValCellule: string;
  iValIntCell: Integer;
  tTimeCell : TDateTime;
begin
  if ((AViewInfo.Item.ID = 5) or (AViewInfo.Item.ID = 4) or (AViewInfo.Item.ID = 3) or (AViewInfo.Item.ID = 2)) then
  begin
    if (AViewInfo.Text <> '') then
    begin

      sValCellule := AViewInfo.RecordViewInfo.GridRecord.Values[(sender as TcxGridDBTableView).GetColumnByFieldName('LAMOY').Index];
      iValIntCell := AViewInfo.RecordViewInfo.GridRecord.Values[(sender as TcxGridDBTableView).GetColumnByFieldName('LAMOY').Index];
      Int(iValIntCell);

      if ((pos('-', sValCellule) <> 0) or (iValIntCell > 30)) then
      begin
        ACanvas.Font.Color := clRed;
      end else
      begin
        //ACanvas.Font.Style := [];
      end;
    end;
    ADone := False;
  end;

  if ((AViewInfo.Item.ID = 5) or (AViewInfo.Item.ID = 4) or (AViewInfo.Item.ID = 3) or (AViewInfo.Item.ID = 2)) then
  begin
    if AViewInfo.Text <> '' then
    begin
       tTimeCell := StrToDateTime(AViewInfo.RecordViewInfo.GridRecord.Values[(sender as TcxGridDBTableView).GetColumnByFieldName('DER_OK').Index]);

       if (tTimeCell < Now - 1) then
       begin
         ACanvas.Font.Color := clOlive;
       end;
    end;
    ADone := False;
  end;
  
end;

procedure TFrm_StatReplicLame.FormCreate(Sender: TObject);
begin
  Dm_MonitorStat.MemD_GestDossier.DelimiterChar := ';';
  Dm_MonitorStat.MemD_ExportComplet.DelimiterChar := ';';
  gsCheminProg := ExtractFilePath(ParamStr(0));

  //griser les boutons cxgrid Dossier
  BBtn_Monter.Enabled := False;
  BBtn_Descendre.Enabled := False;
  BBtn_Supprimer.Enabled := False;
  BBtn_Modifier.Enabled := False;
  BBtn_Analyse.Enabled := False;
  BBtn_DeselectAll.Enabled := False;

  //griser les tabs page controls
  Tab_RepEchec.TabEnabled := False;
  Tab_BilanRepJours.TabEnabled := False;
  Tab_Export.TabEnabled := False;

  Tab_Dossier.Show;

  //Requete SQL affectation
  sReqReplicEchec := 'SELECT * FROM SM_PAS_REPL_Jour';
  sReqBilanReplicDay := 'SELECT * FROM SM_BILAN_REPLIC';

  //checkGroupBox
  RzCB_ReplicEchec.Checked := True;
  RzCB_BilanReplic.Checked := True;
  RzCB_RecptionPaquet.Checked := True;

  //Valeur time par defaut export Complet
  sDateExport1 := FormatDateTime('dd/mm/yyyy', Now);
  RzDT_DateExport1.MaxDate := StrToDateTime(sDateExport1);
  RzDT_DateExport2.MaxDate := StrToDateTime(sDateExport1);
  RzDT_DateExport1.DateTime := StrToDateTime(FormatDateTime('dd/mm/yyyy', Now() - 1));
  StringReplace(sDateExport1, '/', '.', [rfReplaceAll, rfIgnoreCase]);

  sDateExport2 := FormatDateTime('dd/mm/yyyy', Now());
  RzDT_DateExport2.DateTime := StrToDateTime(sDateExport2);
  StringReplace(sDateExport2, '/', '.', [rfReplaceAll, rfIgnoreCase]);

end;

procedure TFrm_StatReplicLame.FormShow(Sender: TObject);
begin
  ForceDirectories(gsCheminProg + '\Clients');
  //creation dossier exports
  ForceDirectories(gsCheminProg + '\Export\');
  //label Affiche Info
  Lab_AfficheInfo.Caption := '';

  try
    if FileExists(gsCheminProg + '\Clients\ListeClients.csv') then
    begin
      Dm_MonitorStat.MemD_GestDossier.LoadFromTextFile(gsCheminProg + '\Clients\ListeClients.csv');

      //Remplissage memD_jeton
      with cxGrid_DossierClientDBTableView1.DataController.DataSet do
      begin
        First;
        while not EOF do
        begin
          Dm_MonitorStat.MemD_Jetons.Open;
          Dm_MonitorStat.MemD_Jetons.Append;
          Dm_MonitorStat.MemD_JetonsDOSSIER.AsString := Dm_MonitorStat.MemD_GestDossierClient.AsString;
          Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString := Dm_MonitorStat.MemD_GestDossierCheminGinkoia.AsString;
          Dm_MonitorStat.MemD_Jetons.Post;
          Next;
        end;
      end;
    end;
  except on e: Exception do
    begin
      MessageDlg(e.Message, mtWarning, [mbOK], 0);
    end;
  end;

end;

procedure TFrm_StatReplicLame.PGC_StatReplicChange(Sender: TObject);
begin
  //Changement du label affiche infos en fonction de la page Active

  if Tab_RepEchec.TabEnabled then
  begin
    case PGC_StatReplic.ActivePage.PageIndex of
      0: Lab_AfficheInfo.Caption := 'Dernière analyse complète : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tTimeDAnalyse);
      1: Lab_AfficheInfo.Caption := 'Dernière analyse des réplications en ehec : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tTimeDAnalyse);
      2: Lab_AfficheInfo.Caption := 'Dernière analyse du Bilan journée : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tRefreshBilanRep);
      3: Lab_AfficheInfo.Caption := 'Dernier rafraichissement des réceptions des paquets : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tTimeExport);
      4: Lab_AfficheInfo.Caption := 'Dernier rafraîchissement : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tRefreshJeton);
    end;
  end;
end;

//Selectionner tous les dossiers pour analyse

procedure TFrm_StatReplicLame.RzButton_AllSelectsClick(Sender: TObject);
begin
  cxGrid_DossierClientDBTableView1.Controller.SelectAllRecords;
end;

//Export en CSV de la grid Export

procedure TFrm_StatReplicLame.RzButton_ExportCSVClick(Sender: TObject);
begin
  //ExportGridToText(gsCheminProg + '\Export\ExportComplet' + FormatDateTime('-ddmmyyyy', Now)+'.csv',cxGrid_Export,True,True,';','','','csv');
  Dm_MonitorStat.MemD_ExportComplet.SaveToTextFile(gsCheminProg + '\Export\ExportComplet' + FormatDateTime('-ddmmyyyy', Now) + '.csv');
end;

//Export en Excel de la grid Export

procedure TFrm_StatReplicLame.RzButton_ExportExcelClick(Sender: TObject);
begin
  ExportGridToExcel(gsCheminProg + '\Export\ExportComplet' + FormatDateTime('-ddmmyyyy', Now), cxGrid_Export, False, True, True);
end;

//Savoir si selui sélectionner a le jeton

procedure TFrm_StatReplicLame.RzButton_JetonClick(Sender: TObject);
begin

  //Lancement timer
  Tim_GetRefresh.Enabled := True;

  Screen.Cursor := crSQLWait;
  BlockInput(True);
  QuiJeton(Dm_MonitorStat.MemD_JetonsDOSSIER.AsString, Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString);
  Lab_AfficheInfo.Caption := 'Dernier rafraîchissement : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tRefreshJeton);
  Screen.Cursor := crDefault;
  BlockInput(False);
  // cxGrid_Jetons.SetFocus;
end;

//procedure pour savoir qui a le jeton sur tout les clients présents

procedure TFrm_StatReplicLame.RzButton_JetonLameClick(Sender: TObject);
begin
  //Lancement timer
  Tim_GetRefresh.Enabled := True;

  //Selection de toute la cxgrid
  cxGrid_JetonsDBTableView1.Controller.SelectAllRecords;
  Screen.Cursor := crSQLWait;
  BlockInput(True);
  with cxGrid_JetonsDBTableView1.DataController.DataSet do
  begin
    First;
    while not EOF do
    begin
      if cxGrid_JetonsDBTableView1.Controller.FocusedRecord.Selected then
      begin
        try
          Lab_AfficheInfo.Caption := 'Traitement SQL des clients en cours ...                                                                       ';
          QuiJeton(Dm_MonitorStat.MemD_JetonsDOSSIER.AsString, Dm_MonitorStat.MemD_JetonsCheminGinkoia.AsString);
        except on e: Exception do
          begin
            Screen.Cursor := crDefault;
            MessageDlg(e.Message, mtInformation, [mbOK], 0);
          end;
        end;
      end;
      Next;
    end;
  end;
  Lab_AfficheInfo.Caption := 'Dernier rafraîchissement : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', tRefreshJeton);
  Screen.Cursor := crDefault;
  BlockInput(False);
end;

procedure TFrm_StatReplicLame.RzDT_DateExport1Change(Sender: TObject);
begin
  sDateExport1 := DateTimeToStr(RzDT_DateExport1.DateTime);
  StringReplace(sDateExport1, '/', '.', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TFrm_StatReplicLame.RzDT_DateExport2Change(Sender: TObject);
begin
  sDateExport2 := DateTimeToStr(RzDT_DateExport2.DateTime);
  StringReplace(sDateExport2, '/', '.', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TFrm_StatReplicLame.Tim_GetRefreshTimer(Sender: TObject);
begin
  Dm_MonitorStat.MemD_Jetons.Refresh;
  cxGrid_Jetons.Refresh;
end;

end.

