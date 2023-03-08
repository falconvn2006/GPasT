unit Main_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  StrUtils, stdActns, System.Types,
  //Début Uses Perso
  DBClient,
  DB,
  uDefs,
  UVersion,
  MidasLib,
  uCreateCsv,
  U_Modele,
  uMigrationLaignel,
  //Fin Uses
  Vcl.Buttons, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ImgList,
  System.Generics.Collections, System.RegularExpressions, System.RegularExpressionsCore,
  Vcl.Grids, Vcl.DBGrids, Vcl.CheckLst, FireDAC.Phys.IBDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.IB, FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.DApt,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, System.ImageList;

type
  TArtInfo = class
    FartID : string;
    FtgfID : string;
    FcouID : string;
  end;

  TFrm_Main = class(TForm)
    pc_Traitement: TPageControl;
    ts_NettoyageMagasin: TTabSheet;
    Lbl_Etat_NettoyageMagasin: TLabel;
    Gb_ListeMag: TGroupBox;
    btn_AjoutMag: TSpeedButton;
    btn_SupMag: TSpeedButton;
    Lbx_CodeMag: TListBox;
    Gb_ListeFichier: TGroupBox;
    cbx_Client: TCheckBox;
    cbx_Comptes: TCheckBox;
    cbx_ConditionFournisseur: TCheckBox;
    cbx_Caisse: TCheckBox;
    cbx_Reception: TCheckBox;
    cbx_RetourFournisseur: TCheckBox;
    cbx_Commande: TCheckBox;
    cbx_Consodiv: TCheckBox;
    cbx_Prixdeventeindicatif: TCheckBox;
    cbx_Transfert: TCheckBox;
    Btn_Clean: TButton;
    ts_Fidelite: TTabSheet;
    btn_traitement: TButton;
    lbl_Etat_Fid: TLabel;
    ts_CoupeFile: TTabSheet;
    Btn_Couper: TButton;
    Bed_PathFile: TButtonedEdit;
    Ed_NbLigne: TEdit;
    Cb_Entete: TCheckBox;
    Lab_NbLigne: TLabel;
    Lab_PathFile: TLabel;
    Img_List: TImageList;
    Btn_Close: TButton;
    lbl_: TLabel;
    Bed_PathFile_Fid: TButtonedEdit;
    Bed_PathFile_Clean: TButtonedEdit;
    Label1: TLabel;
    ts_TransfertConso: TTabSheet;
    Bed_TransferConso: TButtonedEdit;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Ed_CodeAdh: TEdit;
    Pb_Etat: TProgressBar;
    cbx_Toc: TCheckBox;
    Lbl_BaseGinkoia: TLabel;
    Bed_BaseNosymag: TButtonedEdit;
    Lbl_TypeTranspo: TLabel;
    cb_TypeMigration: TComboBox;
    cbx_PrixdeVente: TCheckBox;
    ts_NettoyageDoublons: TTabSheet;
    Pnl_PathFileCleaner: TPanel;
    Lbl_PathFileCleaner: TLabel;
    Bed_PathFileCleaner: TButtonedEdit;
    Pnl_RegexCleaner: TPanel;
    Lbl_RegexBeginOfKey: TLabel;
    Gb_SampleCleaner: TGroupBox;
    Pnl_SampleTextCleaner: TPanel;
    Lbl_SampleTextCleaner: TLabel;
    Ed_SampleTextCleaner: TEdit;
    Pnl_SampleKeyCleaner: TPanel;
    Lbl_SampleKeyCleaner: TLabel;
    Pnl_SampleValueCleaner: TPanel;
    Lbl_SampleValueCleaner: TLabel;
    Ed_RegexKey: TEdit;
    Ed_SampleKeyCleaner: TEdit;
    Ed_SampleValueCleaner: TEdit;
    Lbl_RegexCleanerError: TLabel;
    Lbl_RegexCleaner: TLabel;
    Lbl_RegexEndOfValue: TLabel;
    Ed_RegexDelimiterEOL: TEdit;
    Ed_RegexValue: TEdit;
    Lbl_RegexBeginOfValue: TLabel;
    Ed_RegexDelimiter: TEdit;
    Lbl_RegexEndOfKey: TLabel;
    Lbl_RegexEOL: TLabel;
    ts_HistoVenteGoSport: TTabSheet;
    Pnl_Base_HistoVenteGoSport: TPanel;
    Lbl_Base_HistoVenteGoSport: TLabel;
    Bed_Base_HistoVenteGoSport: TButtonedEdit;
    Pnl_Etat_HistoVenteGoSport: TPanel;
    Lbl_Etat_HistoVenteGoSport: TLabel;
    Btn_Traitement_HistoVenteGoSport: TButton;
    Pb_Cleaner: TProgressBar;
    Btn_Cleaner: TButton;
    Pnl_Date_HistoVenteGoSport: TPanel;
    Lbl_Date_HistoVenteGoSport: TLabel;
    Dtp_Date_HistoVenteGoSport: TDateTimePicker;
    Pnl_PathFile_HistoVenteGoSport: TPanel;
    Lbl_PathFile_HistoVenteGoSport: TLabel;
    Bed_PathFile_HistoVenteGoSport: TButtonedEdit;
    Pb_HistoVenteGoSport: TProgressBar;
    Cb_GenerateCaisseCSV_HistoVenteGoSport: TCheckBox;
    Cb_FixEAN_HistoVenteGoSport: TCheckBox;
    Re_Log_HistoVenteGoSport: TRichEdit;
    Lbl_Errors_HistoVenteGoSport: TLabel;
    ts_CompilCsv: TTabSheet;
    Pnl_CSV_Fournisseurs: TPanel;
    Lbl_CSV_Fournisseurs: TLabel;
    Bed_CSV_Fournisseurs: TButtonedEdit;
    Pnl_CSV_Marques: TPanel;
    Lbl_CSV_Marques: TLabel;
    Bed_CSV_Marques: TButtonedEdit;
    Pnl_CSV_Articles: TPanel;
    Lbl_CSV_Articles: TLabel;
    Bed_CSV_Articles: TButtonedEdit;
    Pnl_CSV_Sources: TPanel;
    Panel1: TPanel;
    Pnl_CSV_Destinations: TPanel;
    Pnl_CSV_DestFourn: TPanel;
    lbl_CSV_DestFourn: TLabel;
    Bed_CSV_DestFourn: TButtonedEdit;
    Pnl_CSV_DestMarque: TPanel;
    lbl_CSV_DestMarque: TLabel;
    bed_CSV_DestMarque: TButtonedEdit;
    Pnl_CSV_Destinationstxt: TPanel;
    Pnl_CSV_Button: TPanel;
    Btn_CSV_Execute: TButton;
    Pnl_CSV_DestArtOrph: TPanel;
    lbl_CSV_DestArtOrph: TLabel;
    Bed_CSV_DestArtOrph: TButtonedEdit;
    pb_CSV: TProgressBar;
    ts_RempFEDAS: TTabSheet;
    pnl_Modele: TPanel;
    lbl_Modele: TLabel;
    bed_Modele: TButtonedEdit;
    pnl_GrilleFamille: TPanel;
    lbl_GrilleFamille: TLabel;
    bed_GrilleFamille: TButtonedEdit;
    Panel4: TPanel;
    pnl_RempBouton: TPanel;
    btn_ExecuteRempCode: TButton;
    pb_RempCB: TProgressBar;
    lbl_Titre_Grille: TLabel;
    ts_Guillemets: TTabSheet;
    pnl_Gui_Top: TPanel;
    lbl_Gui_CSV: TLabel;
    lbl_Gui_Titre: TLabel;
    bed_Gui_CSV: TButtonedEdit;
    pnl_Gui_Bottom: TPanel;
    btn_Gui_Execute: TButton;
    pb_Gui: TProgressBar;
    rg_Gui: TRadioGroup;
    ts_Couleur: TTabSheet;
    pnl_Cou_Bottom: TPanel;
    btn_cou_execute: TButton;
    pb_couleur: TProgressBar;
    pnl_Cou_Top: TPanel;
    pnl_cou_reception: TPanel;
    lbl_cou_reception: TLabel;
    bed_cou_reception: TButtonedEdit;
    pnl_cou_caisse: TPanel;
    lbl_cou_caisse: TLabel;
    bed_cou_caisse: TButtonedEdit;
    pnl_cou_consodiv: TPanel;
    lbl_cou_consodiv: TLabel;
    bed_cou_consodiv: TButtonedEdit;
    pnl_cou_source: TPanel;
    pnl_cou_codebarre: TPanel;
    lbl_cou_codebarre: TLabel;
    bed_cou_codebarre: TButtonedEdit;
    pnl_cou_prixachat: TPanel;
    lbl_cou_prixachat: TLabel;
    bed_cou_prixachat: TButtonedEdit;
    pnl_cou_client: TPanel;
    pnl_cou_couleur: TPanel;
    lbl_cou_couleur: TLabel;
    pnl_cou_dest: TPanel;
    pb_cou_fichier: TProgressBar;
    cds_Art: TClientDataSet;
    cds_ArtART_CODE: TStringField;
    cds_ArtCOU_CODE: TStringField;
    cds_couleur: TClientDataSet;
    cds_couleurART_CODE: TStringField;
    cds_couleurCOU_CODE: TStringField;
    ds_couleur: TDataSource;
    lbl_cou_quit: TLabel;
    bed_cou_couleur: TButtonedEdit;
    ts_PrixAchat: TTabSheet;
    pnl_PA_Top: TPanel;
    pnl_PA_src: TPanel;
    pnl_PA_Source: TPanel;
    lbl_PA_PrixAchat: TLabel;
    bed_PA_PrixAchat: TButtonedEdit;
    pnl_PA_Bottom: TPanel;
    btn_PA_Exec: TButton;
    pb_PA: TProgressBar;
    cds_PrixAchat: TClientDataSet;
    cds_PrixAchatID: TStringField;
    cds_PrixAchatCOULEUR: TStringField;
    cds_PrixAchatTAILLE: TStringField;
    cds_PrixAchatX1: TStringField;
    cds_PrixAchatX2: TStringField;
    cds_PrixAchatX3: TStringField;
    cds_PrixAchatX4: TStringField;
    cds_PrixAchatPXBASE: TStringField;
    cds_PrixAchatFinal: TClientDataSet;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    DS_PrixAchat: TDataSource;
    lbl_PA_Quit: TLabel;
    ts_TGF: TTabSheet;
    Bed_PathFile_GTF: TButtonedEdit;
    Label5: TLabel;
    Memo1: TMemo;
    Btn_GTF: TButton;
    Ed_Type_GTF: TEdit;
    Label6: TLabel;
    Ed_CodeType_GTF: TEdit;
    Label7: TLabel;
    ts_RefGeneGinkoia: TTabSheet;
    Bed_PathRefGeneGinkoia: TButtonedEdit;
    Lbl_PathRefGeneGinkoia: TLabel;
    Btn_RefGeneGinkoia: TButton;
    ts_TraitementFedas: TTabSheet;
    Bed_PathFile_FEDAS_POST_ISF_Origine: TButtonedEdit;
    Lbl_Model_Avt: TLabel;
    Btn_TraitementFDAS_PostISF: TButton;
    Bed_PathFile_FEDAS_POST_ISF_Dest: TButtonedEdit;
    Lbl_Model_Apr: TLabel;
    Btn_Gui_Execute_All: TButton;
    ts_PrixVente: TTabSheet;
    Bed_PV_PrixVente: TButtonedEdit;
    Btn_AddPrixVente_PV: TButton;
    Lbl_PrixVente: TLabel;
    Btn_SupprimerFEDAS: TButton;
    Ed_FEDAS_REMPLACEMENT: TEdit;
    Lbl_FEDAS_REMPLACEMENT: TLabel;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    Base: TFDConnection;
    Transaction: TFDTransaction;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    ts_jeeves: TTabSheet;
    Bed_TJ_PathFile: TButtonedEdit;
    Btn_TJ_Traitement: TButton;
    Lbl_TJ_PathFile: TLabel;
    ckbMarques: TCheckBox;
    ed_CodeAdh_RG: TEdit;
    ed_Bon_reception_RG: TEdit;
    ed_Saison_RG: TEdit;
    Lbl_CodeAdh: TLabel;
    lbl_Bon_Reception_RG: TLabel;
    lbl_Saison_RG: TLabel;
    ckb_Code_Couleur_RG: TCheckBox;
    Ed_Secteur_RG: TEdit;
    Ed_Rayon_RG: TEdit;
    Lbl_Secteur_RG: TLabel;
    Lbl_Rayon_RG: TLabel;
    Lbl_Famille_RG: TLabel;
    Ed_Famille_RG: TEdit;
    Ed_SousFamille_RG: TEdit;
    Lbl_SousFamille_RG: TLabel;
    Btn_Ctrl_Stock_RG: TButton;
    Btn_TF_Jeeves: TButton;
    Btn_DelPrixVente_PV: TButton;
    Lbl_DelPrixVente_PV: TLabel;
    Ed_DelPrixVente_PV: TEdit;
    cbx_Artideal: TCheckBox;
    ts_MigrationLaignel: TTabSheet;
    Pnl_MigrationLaignel_Path: TPanel;
    Lbl_MigrationLaignel_Path: TLabel;
    Bed_MigrationLaignel_Path: TButtonedEdit;
    AxMgr_MigrationLaignel: TActionManager;
    Ax_MigrationLaignel_Execute: TAction;
    Pnl_MigrationLaignel_Process: TPanel;
    Btn_MigrationLaignel_Process: TButton;
    Pb_MigrationLaignel_Process: TProgressBar;
    Lbl_MigrationLaignel_Process: TLabel;
    RE_MigrationLaignel_Log: TRichEdit;
    cbx_BonAchats: TCheckBox;
    cbx_Fidelite: TCheckBox;
    ts_MigrationDano: TTabSheet;
    Pnl_MigrationDano_Path: TPanel;
    Lbl_FichierArticle: TLabel;
    Lbl_MigrationDano_PatchClient: TLabel;
    Btn_MigrationDano_Process: TButton;
    PB_Dano: TProgressBar;
    Lbl_MigrationDano_Process: TLabel;
    Bed_MigrationDano_PatchArticle: TButtonedEdit;
    Bed_MigrationDano_PatchClient: TButtonedEdit;
    Chk_MigrationDano_Entete: TCheckBox;
    cbx_Avoir: TCheckBox;
    Btn_Sep_Execute_All: TButton;
    chkDefautEAN: TCheckBox;
    edtDefautEAN: TEdit;
    cbbDefautEANType: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Btn_CleanClick(Sender: TObject);
    procedure btn_AjoutMagClick(Sender: TObject);
    procedure btn_SupMagClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_CouperClick(Sender: TObject);
    procedure Ed_NbLigneKeyPress(Sender: TObject; var Key: Char);
    procedure Bed_PathFileRightButtonClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure Bed_TransferConsoRightButtonClick(Sender: TObject);
    procedure Ed_CodeAdhKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Bed_BaseNosymagRightButtonClick(Sender: TObject);
    procedure Btn_CleanerClick(Sender: TObject);
    procedure Bed_PathFileCleanerRightButtonClick(Sender: TObject);
    procedure RegExCleanerValidate(Sender: TObject);
    procedure RegExCleanerEvaluate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Bed_PathFileCleanerChange(Sender: TObject);
    procedure Bed_Base_HistoVenteGoSportRightButtonClick(Sender: TObject);
    procedure Btn_Traitement_HistoVenteGoSportClick(Sender: TObject);
    procedure btn_traitementClick(Sender: TObject);
    procedure Bed_PathFile_HistoVenteGoSportRightButtonClick(Sender: TObject);
    procedure Bed_Base_HistoVenteGoSportChange(Sender: TObject);
    procedure Bed_CSV_RightButtonClick(Sender: TObject);
    procedure Bed_CSV_DestRightButtonClick(Sender: TObject);
    procedure Btn_CSV_ExecuteClick(Sender: TObject);
    procedure btn_ExecuteRempCodeClick(Sender: TObject);
    procedure btn_Gui_ExecuteClick(Sender: TObject);
    procedure btn_cou_executeClick(Sender: TObject);
    procedure btn_PA_ExecClick(Sender: TObject);
    procedure Bed_PathFolder_RightButtonClick(Sender: TObject);
    procedure Btn_GTFClick(Sender: TObject);
    procedure Btn_RefGeneGinkoiaClick(Sender: TObject);
    procedure Bed_PathFile_RightButtonClick(Sender: TObject);
    procedure Btn_TraitementFDAS_PostISFClick(Sender: TObject);
    procedure Btn_Gui_Execute_AllClick(Sender: TObject);
    procedure Btn_AddPrixVente_PVClick(Sender: TObject);
    procedure Btn_SupprimerFEDASClick(Sender: TObject);
    procedure Btn_TJ_TraitementClick(Sender: TObject);
    procedure Btn_Ctrl_Stock_RGClick(Sender: TObject);
    procedure Btn_TF_JeevesClick(Sender: TObject);
    procedure Btn_DelPrixVente_PVClick(Sender: TObject);
    procedure Ax_MigrationLaignel_ExecuteUpdate(Sender: TObject);
    procedure Ax_MigrationLaignel_ExecuteExecute(Sender: TObject);
    procedure Bed_MigrationLaignel_PathRightButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function AjoutEntete(AFile: string; tab_Col: array of string; nom_File: string; ARetirePtVirg: boolean):boolean;
    procedure Btn_MigrationDano_ProcessClick(Sender: TObject);
    procedure Btn_Sep_Execute_AllClick(Sender: TObject);
    procedure chkDefautEANClick(Sender: TObject);
  strict private
    FuseDefautEAN : Boolean;
    FdefautEAN : string;
    FdefautEANType : Integer;
  private
    { Déclarations privées }
    List_Tmp : TStringList;
    sFile : string;
    iNumFichier : Integer;
    ThreadCleaner, ThreadHistoVente: TThread;
    ThreadMigrationLaignel: TThreadMigrationLaignel;


    function GetHeader(aTab:array of string):string;
    procedure CoupeFile(aFile:string;iNbLignes:Integer);
    procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String;const Delimiter: Char = ';');
    function LoadDataSet(aMsg:string;aPathFile:string;aCle:string;aCDS:TclientDataSet):Boolean;

    procedure ProcLockingFile(const Proc: TProc< TFileStream>;
      const Filename: String; const Mode: Word); overload;
    procedure ProcLockingFile(const Proc: TProc< TFileStream, TFileStream >;
      const Filename, TemporaryFilename: String;
      const Replace: Boolean; const Mode, TemporaryMode: Word); overload;
    procedure ProcLockingFile(const Proc: TProc< TFileStream, TFileStream, TFileStream >;
      const Filename, TemporaryFilename1, TemporaryFilename2: String;
      const Mode, TemporaryMode1, TemporaryMode2: Word; const Manage2: Boolean); overload;
    procedure FileStreamToDictionary( const Thread: TThread;
      const FileStream: TFileStream;
      const Dictionary: TDictionary<String,Variant>;
      const Pattern: String; const Options: TRegExOptions);
    procedure DictionaryToFileStream(const Thread: TThread;
      const Dictionary: TDictionary<String,Variant>;
      const FileStream: TFileStream);
    function GetRegexCleaner: String;
    function GetCommonEANLength: Integer;

    procedure MigrationLaignel_OnStep(const Text: string;
      const State: TStepState; const Style: TStepStyle; 
      const Index, Count: Integer);
    procedure MigrationLaignel_OnTerminate(const ErrorsCount: Integer);
    procedure MigrationLaignel_Log(const Text: string; const State: TStepState);
    Procedure MigrationDano_RechercheClient(DirArticle : String);
    Procedure Csv_Add_Ligne(Fichier,Texte:String);
    function CountFilesInFolder ( path: string ): integer;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;
  Compteur      : Integer=0;          //Compte le nombre de matériel traité
  NbLigne       : Integer;            //Nombre de ligne à traité

implementation

{$R *.dfm}

procedure TFrm_Main.Bed_PathFolder_RightButtonClick(Sender: TObject);
begin
  with TBrowseForFolder.Create(nil) do
  try
    Category := 'Base';
    Caption := 'Browse...';
    DialogCaption := 'Sélectionnez le répertoire des fichiers à traiter';
    BrowseOptions := [bifUseNewUI];
    if Execute then
      TButtonedEdit(Sender).Text := Folder;
  finally
    Free;
  end;
end;

procedure TFrm_Main.Bed_PathFile_RightButtonClick(
  Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Texte|*.txt;*.csv;*.sql|Tous|*.*';
    odTemp.Title := 'Choix du Fichier';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      TButtonedEdit(Sender).Text := odTemp.FileName;
  finally
    odTemp.Free;
  end;
end;

procedure TFrm_Main.Bed_PathFile_HistoVenteGoSportRightButtonClick(
  Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Texte|*.txt;*.csv;*.sql|Tous|*.*';
    odTemp.Title := 'Choix Historique des ventes GoSport Fichier';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      Bed_PathFile_HistoVenteGoSport.Text := odTemp.FileName;
  finally
    odTemp.Free;
  end;
end;

function TFrm_Main.AjoutEntete(AFile: string; tab_Col: array of string;
  nom_File: string; ARetirePtVirg: boolean): boolean;
var
    ij: integer;
    TmpListe: TStringList;
    sPremier: string;
    sLigne: string;
    bFaire: boolean;
  begin
    Result := false;

    TmpListe := TStringList.Create;
    try
      bFaire := false;
      TmpListe.LoadFromFile(AFile);
      sPremier := '';
      if TmpListe.Count>0 then
        sPremier := TmpListe[0];

      if Pos(';', sPremier)>0 then
        sPremier := Copy(sPremier, 1, pos(';', sPremier)-1);

      sPremier := UpperCase(sPremier);
      if High(tab_Col)>0 then
      begin
        if UpperCase(sPremier)<>UpperCase(tab_Col[0]) then
          bFaire := true;
      end;

      if bFaire then
      begin
        sLigne := '';
        for ij := 0 to High(tab_col) do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          sLigne := sLigne+tab_col[ij];
        end;
        if ARetirePtVirg then
          sLigne := sLigne+';';

        if TmpListe.Count>0 then
          TmpListe.Insert(0, sLigne)
        else
          TmpListe.Add(sLigne);

        TmpListe.SaveToFile(AFile);
      end;
      Result := true;
    finally
      FreeAndNil(TmpListe);
    end;
end;

procedure TFrm_Main.Ax_MigrationLaignel_ExecuteExecute(Sender: TObject);
begin
  // Si le thread est déjà en cours, on le stop
  if Assigned(ThreadMigrationLaignel) then
    ThreadMigrationLaignel.Terminate
  else
  begin
    RE_MigrationLaignel_Log.Clear;
    TThreadMigrationLaignel.OnStep := MigrationLaignel_OnStep;
    TThreadMigrationLaignel.OnTerminate := MigrationLaignel_OnTerminate;
    ThreadMigrationLaignel := TThreadMigrationLaignel.Create(
      Bed_MigrationLaignel_Path.Text);    
  end
  
//
end;

procedure TFrm_Main.Ax_MigrationLaignel_ExecuteUpdate(Sender: TObject);
begin
  (Sender as TAction).Caption := IfThen(Assigned(ThreadMigrationLaignel),'Abort','Execute');
end;

procedure TFrm_Main.Bed_BaseNosymagRightButtonClick(Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'InterBase|*.ib';
    odTemp.Title := 'Choix de la base de données';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
    begin
      Bed_BaseNosymag.Text := odTemp.FileName;
      // Ouverture de la base GINKOIA
      if Bed_BaseNosymag.Text <> '' then
      begin
        Base.Close;
        Base.Params.Database := Bed_BaseNosymag.Text;
        Base.Params.Add('user_name=GINKOIA');
        Base.Params.Add('password=ginkoia');
        try
          Base.Open;
          ShowMessage('Connexion à la base de données réussie.');
        Except on E:Exception do
          begin
            ShowMessage('Problème de connexion à la base de données : ' + E.Message);
          end;
        end;
      end;
    end;
  finally
    odTemp.Free;
  end;
end;

procedure TFrm_Main.Bed_PathFileCleanerChange(Sender: TObject);
var
  StreamReader: TStreamReader;
begin
  if not FileExists( Bed_PathFileCleaner.Text ) then
    exit;

  ProcLockingFile(
    procedure(FileStreamSource: TFileStream)
    var
      StreamReader: TStreamReader;
      ReadLine: String;
    begin
      StreamReader := TStreamReader.Create( FileStreamSource );
      try
        while ( not StreamReader.EndOfStream ) do begin
          ReadLine := StreamReader.ReadLine;
          if Trim( ReadLine ) <> '' then begin
            Ed_SampleTextCleaner.Text := ReadLine;
            Break;
          end;
        end;
      finally
        StreamReader.Free;
      end;
    end,
    Bed_PathFileCleaner.Text,
    fmOpenRead or fmShareExclusive
  );
end;

procedure TFrm_Main.Bed_PathFileCleanerRightButtonClick(Sender: TObject);
begin
  with TOpenDialog.Create( Self ) do begin
    Filter  := 'Fichier Texte|*.txt;*.csv;*.sql|Tous|*.*';
    Title   := 'Choix Fichier';
    Options := [ ofHideReadOnly{, ofAllowMultiSelect}, ofPathMustExist,
      ofFileMustExist, ofNoReadOnlyReturn, ofEnableSizing{, ofForceShowHidden} ];
    if Execute then
      Bed_PathFileCleaner.Text := FileName;
    Free;
  end;
end;

procedure TFrm_Main.Bed_PathFileRightButtonClick(Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Texte|*.txt;*.csv;*.sql|Tous|*.*';
    odTemp.Title := 'Choix Gros Fichier';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
    begin
      Bed_PathFile.Text := odTemp.FileName;
      sFile := Bed_PathFile.Text;
    end;
  finally
    odTemp.Free;
  end;
end;

procedure TFrm_Main.btn_AjoutMagClick(Sender: TObject);
var
  sTmp : string;
begin
  sTmp := InputBox('Ajout d''un magasin', 'Veuillez saisir le code magasin :', '');
  Lbx_CodeMag.Items.Add(sTmp);
end;

procedure TFrm_Main.Btn_TJ_TraitementClick(Sender: TObject);
var
  cdsOldCouleur,
  cdsNewCouleur : TClientDataSet;
  I : Integer;
  slOldCouleur,
  slNewCouleur,
  slPatch,
  slProcedure : TStringList;
  sTmp,
  sCodeCouleur,
  sCodeTaille,
  sTarif,
  sNom,
  sTVA,
  sTypeComptable,
  sFilePath : string;
begin
  //Chemin
  sFilePath := Bed_TJ_PathFile.Text;

  slPatch := TStringList.Create;

  slPatch := TStringList.Create;
  slOldCouleur := TStringList.Create;
  slNewCouleur := TStringList.Create;
  slProcedure := TStringList.Create;
  cdsOldCouleur := TClientDataSet.Create(nil);
  cdsNewCouleur := TClientDataSet.Create(nil);
  try
    slOldCouleur.Add('COU_CODE;COU_ID;ART_ID');
    slNewCouleur.Add('COU_CODE;COU_ID;ART_ID');
    slPatch.LoadFromFile(sFilePath + '\Patch New.txt');

    for I := 0 to slPatch.Count-1 do
    begin
      sTmp := slPatch.Strings[I];
      if sTmp[1] = '-' then
      begin
        slOldCouleur.Add(Copy(sTmp,25,9) + ';' + Copy(sTmp,34,9) + ';' + Copy(sTmp,44,9));
      end
      else
        if sTmp[1] = '+' then
        begin
          slNewCouleur.Add(Copy(sTmp,25,9) + ';' + Copy(sTmp,34,9) + ';' + Copy(sTmp,44,9));
        end
    end;

    slOldCouleur.SaveToFile(sFilePath + '\OldCouleur.txt');
    slNewCouleur.SaveToFile(sFilePath + '\NewCouleur.txt');

    LoadDataSet('Old Couleur',
                sFilePath + '\OldCouleur.txt',
                'COU_CODE', cdsOldCouleur);

    LoadDataSet('New Couleur',
                sFilePath + '\NewCouleur.txt',
                'COU_CODE', cdsNewCouleur);

    cdsOldCouleur.First;
    while not cdsOldCouleur.Eof do
    begin
      if cdsNewCouleur.Locate('COU_CODE',cdsOldCouleur.FieldByName('COU_CODE').AsString,[]) then
        slProcedure.Add('INSERT INTO SR_TMPCONTROLE(SRP_ARTID, SRP_OLDCOUID, SRP_NEWCOUID, SRP_TRAITE) VALUES (' +
                      cdsNewCouleur.FieldByName('ART_ID').AsString + ',' +
                      cdsOldCouleur.FieldByName('COU_ID').AsString + ',' +
                      cdsNewCouleur.FieldByName('COU_ID').AsString + ',' +
                      '0);')
      else
        sleep(10);
      cdsOldCouleur.Next;
    end;

    slProcedure.SaveToFile(sFilePath + '\Procedure Correction Dos Santos.sql');

    slProcedure.Clear;
    cdsNewCouleur.First;
    while not cdsNewCouleur.Eof do
    begin
      if slProcedure.IndexOf(cdsNewCouleur.FieldByName('ART_ID').AsString) = -1 then
        slProcedure.Add(cdsNewCouleur.FieldByName('ART_ID').AsString);
      cdsNewCouleur.Next;
    end;

    slProcedure.SaveToFile(sFilePath + '\Procedure Controle Article Dos Santos.sql');

    // Récupération de artid Allier
    slOldCouleur.Clear;
    slOldCouleur.Add('ART_ID_ALLIER;ART_ID');
    slPatch.Clear;
    slPatch.LoadFromFile(sFilePath + '\ArticleID.ID');

    for I := 0 to slPatch.Count-1 do
    begin
      slOldCouleur.Add(trim(Copy(slPatch.Strings[I],24,9)) + ';' + Copy(slPatch.Strings[I],33,9));
    end;

    slOldCouleur.SaveToFile(sFilePath + '\Article_ID.txt');

    FreeAndNil(cdsOldCouleur);
    cdsOldCouleur := TClientDataSet.Create(nil);

    LoadDataSet('Article ID',
                sFilePath + '\Article_ID.txt',
                'ART_ID', cdsOldCouleur);
    slPatch.Clear;
    slPatch.LoadFromFile(sFilePath + '\ArticleID-Dos Santos.txt');
    slProcedure.Clear;
    for I := 0 to slPatch.Count-1 do
    begin
      if cdsOldCouleur.Locate('ART_ID',slPatch.Strings[I],[]) then
        slProcedure.Add('INSERT INTO SR_TMPCONTROLE(SRP_ARTID, SRP_OLDCOUID, SRP_NEWCOUID, SRP_TRAITE) VALUES (' +
                      cdsOldCouleur.FieldByName('ART_ID_ALLIER').AsString + ',0,0,0);')
      else
        sleep(10);
      cdsOldCouleur.Next;
    end;

    slProcedure.SaveToFile(sFilePath + '\Insert Allier.sql');
  finally
    FreeAndNil(slPatch);
    FreeAndNil(slOldCouleur);
    FreeAndNil(slNewCouleur);
    FreeAndNil(slProcedure);
    FreeAndNil(cdsOldCouleur);
    FreeAndNil(cdsNewCouleur);
  end;
  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.Btn_CleanClick(Sender: TObject);
var
  sPath : string;
  cdsTmp,
  cdsKeep,
  cdsDel,
  cdsConsoDiv,
  slToc  : TStringList;
  cdsClient,
  cdsOcMag,
  cdsOcTmp,
  cdsTransfert : TClientDataSet;
  iBoucle : Integer;

  sCodeMagO,
  sCodeMagD,
  sLigne    : string;

  function GetHeader(aTab:array of string):string;
  var
    i : Integer;
  begin
    Result := '';
    for i := 0 to Length(aTab) - 1 do
      if Result = '' then
        Result := aTab[i]
      else
        Result := Result + ';' + aTab[i];
  end;

  procedure Traitement(aCSV : string);
  var
    i   : Integer;
    j   : Integer;
    bOk : Boolean;
    sFilePath : string;
    iNumFile : Integer;
  begin
    iNumFile := 0;
    sFilePath := sPath + aCSV;
    while FileExists(sFilePath) do
    begin
      cdsTmp.Clear;
      cdsKeep.Clear;
      cdsDel.Clear;

      cdsTmp.LoadFromFile(sFilePath);

      j := 0;
      while j < cdsTmp.Count do
      begin
        bOk := False;
        i := 0;
        while (i < Lbx_CodeMag.Count) and (not bOk) do
        begin
          if aCSV = ArtIdeal_CSV then
          begin
            if POS(UpperCase(Lbx_CodeMag.Items.Strings[i]) + ';', UpperCase(cdsTmp.Strings[j])) <> 0 then
            begin
              cdsKeep.Add(cdsTmp.Strings[j]);
              bOk := True;
            end;
          end
          else
          begin
            if POS(UpperCase(';' + Lbx_CodeMag.Items.Strings[i]) + ';', UpperCase(cdsTmp.Strings[j])) <> 0 then
            begin
              cdsKeep.Add(cdsTmp.Strings[j]);
              bOk := True;
            end;
          end;
          Inc(i);
        end;

        if not bOk then
          cdsDel.Add(cdsTmp.Strings[j]);

        Inc(j);
      end;
      if iNumFile = 0 then
      begin
        cdsKeep.SaveToFile(sPath + 'Keep\' + aCSV);
        cdsDel.SaveToFile(sPath + 'Del\' + aCSV);
      end
      else
      begin
        if aCSV = Caisse_CSV then
        begin
          cdsKeep.SaveToFile(sPath + 'Keep\' + 'caisse' + IntToStr(iNumFile) + '.csv');
          cdsDel.SaveToFile(sPath + 'Del\' + 'caisse' + IntToStr(iNumFile) + '.csv');
        end
        else
          if aCSV = Reception_CSV then
          begin
            cdsKeep.SaveToFile(sPath + 'Keep\' + 'reception' + IntToStr(iNumFile) + '.csv');
            cdsDel.SaveToFile(sPath + 'Del\' + 'reception' + IntToStr(iNumFile) + '.csv');
          end
          else
            if aCSV = Prix_Vente_Indicatif_CSV then
            begin
              cdsKeep.SaveToFile(sPath + 'Keep\' + 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv');
              cdsDel.SaveToFile(sPath + 'Del\' + 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv');
            end;
      end;

      Inc(iNumFile);

      if aCSV = Caisse_CSV then
        sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'caisse' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase])
      else
        if aCSV = Reception_CSV then
          sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'reception' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase])
        else
          if aCSV = Prix_Vente_Indicatif_CSV then
            sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase])
          else
            sFilePath := '';
    end;
  end;

  procedure Traitement_GS(aCSV : string; AFieldPosition : Integer);
  var
    i   : Integer;
    j   : Integer;
    bOk : Boolean;
    sFilePath : string;
    iNumFile : Integer;
    lstTmp : TStringList;
  begin
    lstTmp := TStringList.Create;
    try
      iNumFile := 0;
      sFilePath := sPath + aCSV;
      while FileExists(sFilePath) do
      begin
        cdsTmp.Clear;
        cdsKeep.Clear;
        cdsDel.Clear;

        cdsTmp.LoadFromFile(sFilePath);

        j := 0;
        while j < cdsTmp.Count do
        begin
          lstTmp.Text := StringReplace(cdsTmp[j],';',#13#10,[rfReplaceAll]);
          bOk := False;
          i := 0;
          while (i < Lbx_CodeMag.Count) and (not bOk) do
          begin
            if lstTmp[AFieldPosition] = Lbx_CodeMag.Items.Strings[i] then
            begin
              cdsKeep.Add(cdsTmp.Strings[j]);
              bOk := True;
            end;
            Inc(i);
          end;

          if not bOk then
            cdsDel.Add(cdsTmp.Strings[j]);

          Inc(j);
        end;
        if iNumFile = 0 then
        begin
          cdsKeep.SaveToFile(sPath + 'Keep\' + aCSV);
          cdsDel.SaveToFile(sPath + 'Del\' + aCSV);
        end
        else
        begin
          if aCSV = Caisse_CSV then
          begin
            cdsKeep.SaveToFile(sPath + 'Keep\' + 'caisse' + IntToStr(iNumFile) + '.csv');
            cdsDel.SaveToFile(sPath + 'Del\' + 'caisse' + IntToStr(iNumFile) + '.csv');
          end
          else
            if aCSV = Reception_CSV then
            begin
              cdsKeep.SaveToFile(sPath + 'Keep\' + 'reception' + IntToStr(iNumFile) + '.csv');
              cdsDel.SaveToFile(sPath + 'Del\' + 'reception' + IntToStr(iNumFile) + '.csv');
            end
            else
              if aCSV = Prix_Vente_Indicatif_CSV then
              begin
                cdsKeep.SaveToFile(sPath + 'Keep\' + 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv');
                cdsDel.SaveToFile(sPath + 'Del\' + 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv');
              end;
        end;

        Inc(iNumFile);

        if aCSV = Caisse_CSV then
          sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'caisse' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase])
        else
          if aCSV = Reception_CSV then
            sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'reception' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase])
          else
            if aCSV = Prix_Vente_Indicatif_CSV then
              sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase])
            else
              sFilePath := '';
      end;
    finally
      lstTmp.DisposeOf;
    end;
  end;

  // returns file size in bytes or -1 if not found.
  function FileSize(fileName : wideString) : Int64;
  var
   sr : TSearchRec;
  begin
    if FindFirst(fileName, faAnyFile, sr ) = 0 then
      result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
    else
      result := -1;

    FindClose(sr) ;
  end;

  procedure TraitementToc(aCSV : string; aCol : array of string);
  var
    i   : Integer;
  begin
    cdsOcTmp := TClientDataSet.Create(nil);
    try
      cdsKeep.Clear;
      cdsDel.Clear;

      cdsTmp.Clear;
      cdsTmp.LoadFromFile(sPath + aCSV);         //Chargement du fichier
      cdsTmp.Insert(0,GetHeader(aCol));          //Ajout de l'en-tête
      cdsTmp.SaveToFile(sPath + 'Tmp\' + aCSV);  //Enregistrement du fichier
      LoadDataSet('Toc',
                  sPath + 'Tmp\' + aCSV,
                  'TOC_CODE',
                  cdsOcTmp);

      cdsOcTmp.First;
      while not cdsOcTmp.Eof do
      begin
        if (slToc.IndexOf(cdsOcTmp.FieldByName('TOC_CODE').AsString) <> -1) then
        begin
          sLigne := '';
          for i := 0 to cdsOcTmp.Fields.Count - 1 do
            sLigne := sLigne + cdsOcTmp.Fields.Fields[i].AsString + ';';
          cdsKeep.Add(sLigne);
        end
        else
        begin
          sLigne := '';
          for i := 0 to cdsOcTmp.Fields.Count - 1 do
            sLigne := sLigne + cdsOcTmp.Fields.Fields[i].AsString + ';';
          cdsDel.Add(sLigne);
        end;
        cdsOcTmp.Next;
      end;
      cdsKeep.SaveToFile(sPath + 'Keep\' + aCSV);
      cdsDel.SaveToFile(sPath + 'Del\' + aCSV);
      DeleteFileW(PWideChar(sPath + 'Tmp\' + aCSV));
    finally
      FreeAndNil(cdsOcTmp);
    end;
  end;

  function VerrifierCodeAdh:Boolean;
  var
    i : Integer;
    Que_Tmp : TFDQuery;
  begin
    Que_tmp := TFDQuery.Create(nil);
    try
      Que_Tmp.Close;
      Que_Tmp.Connection := Base;
      Que_tmp.SQL.Clear;
      Que_tmp.SQL.Add('SELECT MAG_CODEADH FROM GENMAGASIN JOIN K ON (K_ID = MAG_ID AND K_ENABLED = 1) WHERE MAG_ID <> 0 AND MAG_CODEADH = :PMAGCODEADH');

      Result := True;

      i := 0;
      while (i < Lbx_CodeMag.Count) and (Result) do
      begin
        Que_Tmp.Close;
        Que_Tmp.ParamByName('PMAGCODEADH').AsString := Lbx_CodeMag.Items.Strings[i];
        Que_Tmp.Open;
        if Que_Tmp.Eof then
          Result := False;
        Inc(i);
      end;

    finally
      FreeAndNil(Que_Tmp);
    end;
  end;

  procedure TraitementPrixdeVente(aCSV : string);
  var
    i   : Integer;
    j   : Integer;
    bOk : Boolean;
    sFilePath : string;
    Que_Tmp : TFDQuery;
    slTarifdeVente : TStringList;
  begin
    Que_tmp := TFDQuery.Create(nil);
    slTarifdeVente := TStringList.Create;
    try
      Que_Tmp.Close;
      Que_Tmp.Connection := Base;
      Que_tmp.SQL.Clear;
      Que_tmp.SQL.Add('SELECT TVT_NOM FROM TARVENTE JOIN K ON (K_ID = TVT_ID AND K_ENABLED = 1) ' +
                        ' JOIN GENMAGASIN ON (MAG_TVTID = TVT_ID) WHERE MAG_ID <> 0 AND MAG_CODEADH = :PMAGCODEADH');

      i := 0;
      slTarifdeVente.Clear;
      while (i < Lbx_CodeMag.Count) do
      begin
        if cb_TypeMigration.ItemIndex in [1, 4] then   //Si c'est une Ginkoia / Nosymag
        begin
          Que_Tmp.Close;
          Que_Tmp.ParamByName('PMAGCODEADH').AsString := Lbx_CodeMag.Items.Strings[i];
          Que_Tmp.Open;
          Que_Tmp.First;
          while Not Que_Tmp.Eof do
          begin
            if slTarifdeVente.IndexOf(Que_Tmp.FieldByName('TVT_NOM').AsString) = -1 then
              slTarifdeVente.Add(Que_Tmp.FieldByName('TVT_NOM').AsString);
            Que_Tmp.Next;
          end;
        end
        else
        begin
          slTarifdeVente.Add(Lbx_CodeMag.Items.Strings[i]);
        end;
        Inc(i);
      end;
    finally
      FreeAndNil(Que_Tmp);
    end;

    if slTarifdeVente.IndexOf('GENERAL') = -1 then
      slTarifdeVente.Add('GENERAL');
    if slTarifdeVente.IndexOf('WEB') = -1 then
      slTarifdeVente.Add('WEB');

    sFilePath := sPath + aCSV;
    if FileExists(sFilePath) then
    begin
      cdsTmp.Clear;
      cdsKeep.Clear;
      cdsDel.Clear;

      cdsTmp.LoadFromFile(sFilePath);

      j := 0;
      while j < cdsTmp.Count do
      begin
        bOk := False;
        i := 0;
        while (i < slTarifdeVente.Count) and (not bOk) do
        begin
          if POS(UpperCase(';' + slTarifdeVente.Strings[i]) + ';', UpperCase(cdsTmp.Strings[j])) <> 0 then
          begin
            cdsKeep.Add(cdsTmp.Strings[j]);
            bOk := True;
          end;
          Inc(i);
        end;

        if not bOk then
          cdsDel.Add(cdsTmp.Strings[j]);

        Inc(j);
      end;
      cdsKeep.SaveToFile(sPath + 'Keep\' + aCSV);
      cdsDel.SaveToFile(sPath + 'Del\' + aCSV);
    end;
  end;
begin
  if Lbx_CodeMag.Items.IndexOf('GENERAL') <> -1 then
    Lbx_CodeMag.Items.Delete(Lbx_CodeMag.Items.IndexOf('GENERAL'));

  if cb_TypeMigration.ItemIndex <= 0 then
  begin
    ShowMessage('Choisir un type de migration.');
    Exit;
  end;

  //Test de présence des codes adhérents
  if not VerrifierCodeAdh then
  begin
    ShowMessage('Problème de code adhérent dans la base.');
    Exit;
  end;

  //Partie Traitement des fichiers
  sPath := Bed_PathFile_Clean.Text + '\';

  //Création des dossiers
  if not System.SysUtils.DirectoryExists(sPath + 'Del') then
    CreateDir(sPath + 'Del');
  if not System.SysUtils.DirectoryExists(sPath + 'Keep') then
    CreateDir(sPath + 'Keep');
  if not System.SysUtils.DirectoryExists(sPath + 'Tmp') then
    CreateDir(sPath + 'Tmp');

  //Construction du filtre avec la liste des Magasins.
  if Pos('GENERAL',Lbx_CodeMag.Items.Text) = 0 then
    Lbx_CodeMag.Items.Add('GENERAL');

  cdsTmp  := TStringList.Create;
  cdsKeep := TStringList.Create;
  cdsDel  := TStringList.Create;
  cdsConsoDiv  := TStringList.Create;
  cdsClient := TClientDataSet.Create(nil);
  cdsTransfert := TClientDataSet.Create(nil);
  try
    //Client
    if cbx_Client.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Client';
      Application.ProcessMessages;

      cdsTmp.Clear;
      cdsKeep.Clear;
      cdsDel.Clear;

      cdsTmp.LoadFromFile(sPath + Clients_CSV);         //Chargement du fichier
      cdsTmp.Insert(0,GetHeader(Clients_COL));          //Ajout de l'en-tête
      cdsTmp.SaveToFile(sPath + 'Tmp\' + Clients_CSV);  //Enregistrement du fichier

      LoadDataSet('Client',
                  sPath + 'Tmp\' + Clients_CSV,
                  'CODE',
                  cdsClient);

      cdsClient.First;
      while not cdsClient.Eof do
      begin
        sCodeMagO := cdsClient.FieldByName('CODE_MAG').AsString;

        if (Lbx_CodeMag.Items.IndexOf(sCodeMagO) <> -1) or (sCodeMagO = '') then
        begin
          sLigne := '';
          for iBoucle := 0 to cdsClient.Fields.Count - 1 do
            sLigne := sLigne + cdsClient.Fields.Fields[iBoucle].AsString + ';';
          cdsKeep.Add(sLigne);
        end
        else
        begin
          sLigne := '';
          for iBoucle := 0 to cdsClient.Fields.Count - 1 do
              sLigne := sLigne + cdsClient.Fields.Fields[iBoucle].AsString + ';';
            cdsDel.Add(sLigne);
        end;
        cdsClient.Next;
      end;
      cdsKeep.SaveToFile(sPath + 'Keep\' + Clients_CSV);
      cdsDel.SaveToFile(sPath + 'Del\' + Clients_CSV);
      DeleteFileW(PWideChar(sPath + 'Tmp\' + Clients_CSV));
    end;

    //Comptes
    if cbx_Comptes.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Comptes';
      Application.ProcessMessages;
      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(Comptes_CSV,7);
        else
          Traitement(Comptes_CSV);
      end;
    end;

    //Condition fournisseur
    if cbx_ConditionFournisseur.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Condition Fournisseur';
      Application.ProcessMessages;
      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(FouCondition_CSV,1);
        else
          Traitement(FouCondition_CSV);
      end;
    end;

    //Caisse
    if cbx_Caisse.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Caisse';
      Application.ProcessMessages;

      if FileSize(sPath + Caisse_CSV) > 104857600 then
        CoupeFile(sPath + Caisse_CSV, 900000);

      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(Caisse_CSV,4);
        else
          Traitement(Caisse_CSV);
      end;
    end;

    //Réception
    if cbx_Reception.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Réception';
      Application.ProcessMessages;

      if FileSize(sPath + Reception_CSV) > 104857600 then
        CoupeFile(sPath + Reception_CSV, 800000);

      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(Reception_CSV,4);
        else
          Traitement(Reception_CSV);
      end;
    end;

    //Consodiv
    if cbx_Consodiv.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Consodiv';
      Application.ProcessMessages;

      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(Consodiv_CSV,4);
        else
          Traitement(Consodiv_CSV);
      end;
    end;

    //Commande
    if cbx_Commande.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Commande';
      Application.ProcessMessages;

      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(Commandes_CSV,4);
        else
          Traitement(Commandes_CSV);
      end;
    end;

    //Retour Fournisseur
    if cbx_RetourFournisseur.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Fournisseur';
      Application.ProcessMessages;

      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(RetourFou_CSV,4);
        else
          Traitement(RetourFou_CSV);
      end;
    end;

    // Artideal
    if cbx_Artideal.checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Article idéal';
      Application.ProcessMessages;

      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(ArtIdeal_CSV,0);
        else
          Traitement(ArtIdeal_CSV);
      end;
    end;

    //Prix de vente
    if cbx_PrixdeVente.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Prix de vente';
      Application.ProcessMessages;

      TraitementPrixdeVente(Prix_Vente_CSV);
    end;

    //Prix de vente indicatif
    if cbx_Prixdeventeindicatif.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Prix de vente indicatif';
      Application.ProcessMessages;

      if FileSize(sPath + Prix_Vente_Indicatif_CSV) > 104857600 then
        CoupeFile(sPath + Prix_Vente_Indicatif_CSV, 900000);

      Traitement(Prix_Vente_Indicatif_CSV);
    end;

    //Oc
    if cbx_Toc.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : TOC';
      Application.ProcessMessages;

      if fileExists(sPath + OcMag_CSV) then
      begin
        cdsOcMag := TClientDataSet.Create(nil);
        slToc := TStringList.Create;
        try
          cdsKeep.Clear;
          cdsDel.Clear;
          slToc.Clear;

          cdsTmp.Clear;
          cdsTmp.LoadFromFile(sPath + OcMag_CSV);         //Chargement du fichier
          cdsTmp.Insert(0,GetHeader(OcMag_COL));          //Ajout de l'en-tête
          cdsTmp.SaveToFile(sPath + 'Tmp\' + OcMag_CSV);  //Enregistrement du fichier
          LoadDataSet('OcMag',
                      sPath + 'Tmp\' + OcMag_CSV,
                      'TOC_CODE',
                      cdsOcMag);

          cdsOcMag.First;
          while not cdsOcMag.Eof do
          begin
            sCodeMagO := cdsOcMag.FieldByName('CODE_MAG').AsString;

            if (Lbx_CodeMag.Items.IndexOf(sCodeMagO) <> -1) then
            begin
              sLigne := '';
              for iBoucle := 0 to cdsOcMag.Fields.Count - 1 do
                sLigne := sLigne + cdsOcMag.Fields.Fields[iBoucle].AsString + ';';
              cdsKeep.Add(sLigne);
              slToc.Add(cdsOcMag.FieldByName('TOC_CODE').AsString);
            end
            else
            begin
              sLigne := '';
              for iBoucle := 0 to cdsOcMag.Fields.Count - 1 do
                sLigne := sLigne + cdsOcMag.Fields.Fields[iBoucle].AsString + ';';
              cdsDel.Add(sLigne);
            end;
            cdsOcMag.Next;
          end;
          cdsKeep.SaveToFile(sPath + 'Keep\' + OcMag_CSV);
          cdsDel.SaveToFile(sPath + 'Del\' + OcMag_CSV);
          DeleteFileW(PWideChar(sPath + 'Tmp\' + OcMag_CSV));
        finally
          FreeAndNil(cdsOcMag);
        end;
        TraitementToc(OcTete_CSV,OcTete_COL);
        TraitementToc(OcLignes_CSV,OcLignes_COL);
        TraitementToc(OcDetail_CSV,OcDetail_COL);
      end;
    end;

    //Transfert
    if cbx_Transfert.Checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Transfert';
      Application.ProcessMessages;

      if FileExists(sPath + Transfert_CSV) then
      begin
        cdsTmp.Clear;
        cdsKeep.Clear;
        cdsDel.Clear;

        cdsConsoDiv.LoadFromFile(sPath + 'Keep\' + Consodiv_CSV);

        cdsTmp.LoadFromFile(sPath + Transfert_CSV);         //Chargement du fichier
        cdsTmp.Insert(0,GetHeader(Transfert_COL));          //Ajout de l'en-tête
        cdsTmp.SaveToFile(sPath + 'Tmp\' + Transfert_CSV);  //Enregistrement du fichier

        LoadDataSet('Transfert',
                    sPath + 'Tmp\' + Transfert_CSV,
                    'CODE_ART;CODE_TAILLE;CODE_COUL;EAN;CODE_MAGO;CODE_MAGD;DATE',
                    cdsTransfert);

        cdsTransfert.First;
        while not cdsTransfert.Eof do
        begin
          sCodeMagO := cdsTransfert.FieldByName('CODE_MAGO').AsString;
          sCodeMagD := cdsTransfert.FieldByName('CODE_MAGD').AsString;

          if (Lbx_CodeMag.Items.IndexOf(sCodeMagO) <> -1) AND (Lbx_CodeMag.Items.IndexOf(sCodeMagD) <> -1) then
          begin
            sLigne := '';
            for iBoucle := 0 to cdsTransfert.Fields.Count - 1 do
              sLigne := sLigne + cdsTransfert.Fields.Fields[iBoucle].AsString + ';';
            cdsKeep.Add(sLigne);
          end
          else
            if (Lbx_CodeMag.Items.IndexOf(sCodeMagO) = -1) AND (Lbx_CodeMag.Items.IndexOf(sCodeMagD) = -1) then
            begin
              sLigne := '';
              for iBoucle := 0 to cdsTransfert.Fields.Count - 1 do
                sLigne := sLigne + cdsTransfert.Fields.Fields[iBoucle].AsString + ';';
              cdsDel.Add(sLigne);
            end
            else
            begin
              if (Lbx_CodeMag.Items.IndexOf(sCodeMagD) = -1) then
              begin
                cdsConsoDiv.Add(cdsTransfert.FieldByName('CODE_ART').AsString + ';' +
                                cdsTransfert.FieldByName('CODE_TAILLE').AsString + ';' +
                                cdsTransfert.FieldByName('CODE_COUL').AsString + ';' +
                                cdsTransfert.FieldByName('EAN').AsString + ';' +
                                sCodeMagO + ';' +
                                cdsTransfert.FieldByName('DATE').AsString + ';' +
                                '7' + ';' +
                                '20' + ';' +
                                cdsTransfert.FieldByName('QTE').AsString + ';' +
                                'Rélarisation de stock Suite Transpo Ginkoia/Nosymag' + ';' +
                                '0' + ';');
              end
              else
              begin
                cdsConsoDiv.Add(cdsTransfert.FieldByName('CODE_ART').AsString + ';' +
                                cdsTransfert.FieldByName('CODE_TAILLE').AsString + ';' +
                                cdsTransfert.FieldByName('CODE_COUL').AsString + ';' +
                                cdsTransfert.FieldByName('EAN').AsString + ';' +
                                sCodeMagD + ';' +
                                cdsTransfert.FieldByName('DATE').AsString + ';' +
                                '7' + ';' +
                                '20' + ';' +
                                '-' + cdsTransfert.FieldByName('QTE').AsString + ';' +
                                'Rélarisation de stock Suite Transpo Ginkoia/Nosymag' + ';' +
                                '0' + ';');
              end;
            end;
          cdsTransfert.Next;
        end;
        cdsKeep.SaveToFile(sPath + 'Keep\' + Transfert_CSV);
        cdsDel.SaveToFile(sPath + 'Del\' + Transfert_CSV);
        cdsConsoDiv.SaveToFile(sPath + 'Keep\' + Consodiv_CSV);
        DeleteFileW(PWideChar(sPath + 'Tmp\' + Transfert_CSV));
      end;
    end;

    // Bons achats
    if cbx_BonAchats.checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Bons achats';
      Application.ProcessMessages;

      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(BonAchats_CSV,0);
        else
          Traitement(BonAchats_CSV);
      end;
    end;

    // Fidelite
    if cbx_Fidelite.checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Fidélité';
      Application.ProcessMessages;

      case cb_TypeMigration.ItemIndex of
        3: Traitement_GS(Fidelite_CSV,0);
        else
          Traitement(Fidelite_CSV);
      end;
    end;

    // Avoir
    if cbx_Avoir.checked then
    begin
      Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : Avoir';
      Application.ProcessMessages;

      Traitement(Avoir_CSV);
    end;
  finally
    FreeAndNil(cdsTmp);
    FreeAndNil(cdsKeep);
    FreeAndNil(cdsDel);
    FreeAndNil(cdsConsoDiv);
    FreeAndNil(cdsClient);
    FreeAndNil(cdsTransfert);
  end;

  Lbl_Etat_NettoyageMagasin.Caption := 'Traitement :';
  Application.ProcessMessages;
  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.Btn_CloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrm_Main.Btn_CouperClick(Sender: TObject);
var
  Delai: DWord;

  iMaxProgress: Int64;
  iProgress: Int64;

  Nb_Ligne : Integer;

  i: Integer;
  sLigne: string;
  sLire: String;
  Stream: TFileStream;
  StrStream: TStringStream;
  SizeLu: Int64;
  SizeALire: Int64;
  TailleMax: Int64;

  procedure TraitementDeLaLigne(ALigne: string);
  begin
    if Nb_Ligne < StrToInt(Ed_NbLigne.Text) then
    begin
      List_Tmp.Add(ALigne);
      Inc(Nb_Ligne);
    end
    else
    begin
      List_Tmp.SaveToFile(ExtractFilePath(sFile) +
                          ChangeFileExt(ExtractFileName(sFile),'') + IntToStr(iNumFichier) +
                          ExtractFileExt(sFile));
      List_Tmp.Clear;
      Inc(iNumFichier);
      List_Tmp.Add(ALigne);
      Nb_Ligne := 1;
    end;
  end;

begin
  if sFile='' then
    exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    //On désactive la saisie
    Ed_NbLigne.Enabled    := False;
    Btn_Couper.Enabled    := False;
    Btn_Close.Enabled     := False;
    Bed_PathFile.Enabled  := False;
    Cb_Entete.Enabled     := False;

    //On vide la string list et initialise le nb de ligne à zéro
    Nb_Ligne := 0;
    iNumFichier := 0;
    List_Tmp.Clear;

    Delai := 0;
    sLire := '';
    TailleMax := 1024;
    Stream := TFileStream.Create(sFile, fmOpenRead);
    iMaxProgress := Stream.Size;
    Pb_Etat.Max := iMaxProgress;
    StrStream := TStringStream.Create('');
    try
      i := 0;
      Stream.Seek(0, soFromBeginning);
      if Stream.Size-Stream.Position>TailleMax then
        SizeALire := TailleMax
      else
        SizeALire := Stream.Size-Stream.Position;
      Sizelu := StrStream.CopyFrom(Stream, SizeALire);
      sLire := StrStream.DataString;
      iProgress := Sizelu;
      while (Sizelu=TailleMax) do
      begin
        while Pos(#13#10, sLire)>0 do
        begin
          inc(i);
          sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
          sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
          // traitement de la ligne
          if ((i>1) and (Cb_Entete.Checked)) or ((i>=1) and (Cb_Entete.Checked = False))  then
          begin
            TraitementDeLaLigne(sLigne);
          end;

        end;
        if Stream.Size-Stream.Position>TailleMax then
          SizeALire := TailleMax
        else
          SizeALire := Stream.Size-Stream.Position;

        // progression
        iProgress := iProgress+SizeALire;
        if (GetTickCount-Delai)>=250 then
        begin
          Pb_Etat.Position := iProgress;
          Pb_Etat.Update;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;

        StrStream.Clear;
        Sizelu := StrStream.CopyFrom(Stream, SizeALire);
        sLire := sLire+StrStream.DataString;
      end;
      if sLire<>'' then
      begin
        while Pos(#13#10, sLire)>0 do
        begin
          inc(i);
          sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
          sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
          // traitement de la ligne
          if i>1 then
          begin
            TraitementDeLaLigne(sLigne);
          end;
          // fin traitement
          if (GetTickCount-Delai)>=250 then
          begin
            Pb_Etat.Position := iProgress;
            Pb_Etat.Update;
            Delai := GetTickCount;
            Application.ProcessMessages;
          end;
        end;
        if sLire<>'' then
        begin
          inc(i);
          sLigne := sLire;
          // traitement de la ligne
          if i>1 then
          begin
            TraitementDeLaLigne(sLigne);
          end;
        end;
      end;
      Pb_Etat.Position := iProgress;
      Pb_Etat.Update;
    finally
      FreeAndNil(Stream);
      FreeAndNil(StrStream);
    end;
  finally
    List_Tmp.SaveToFile(ExtractFilePath(sFile) +
                        ChangeFileExt(ExtractFileName(sFile),'') + IntToStr(iNumFichier) +
                        ExtractFileExt(sFile));
    List_Tmp.Clear;
    Ed_NbLigne.Enabled    := True;
    Btn_Couper.Enabled    := True;
    Btn_Close.Enabled     := True;
    Bed_PathFile.Enabled  := True;
    Cb_Entete.Enabled     := True;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
    ShowMessage('Traitement terminé.');
  end;
end;

procedure TFrm_Main.btn_cou_executeClick(Sender: TObject);
var
  lList, lListCouleur, lListSep, lListSepCou: TStringList;
  iFichier, iList, iCouleur: integer;
  lCsv: TExportHeaderOL;
begin
  try
  //btn_cou_execute.Enabled := false;
  ts_Couleur.Enabled := false;
  lListCouleur := TStringList.Create;
  lListCouleur.LoadFromFile(bed_cou_couleur.Text);
  lList := TStringList.Create;
  lListSep := TStringList.Create;
  lListSep.StrictDelimiter := true;
  lListSep.Delimiter := ';';
  lListSepCou := TStringList.Create;
  lListSepCou.StrictDelimiter := true;
  lListSepCou.Delimiter := ';';

  cds_couleur.DisableControls;
  for iCouleur := 0 to lListCouleur.Count -1 do
  begin
    lListSepCou.DelimitedText := lListCouleur[iCouleur];
    cds_couleur.Append;
    cds_couleur.FieldByName('ART_CODE').AsString := lListSepCou[0];
    cds_couleur.FieldByName('COU_CODE').AsString := lListSepCou[2];
    cds_couleur.Post;
  end;
  cds_couleur.EnableControls;

  for iFichier := 0 to 4 do
  begin
    pb_cou_fichier.Position := 0;
    //lList.Clear;
    try
      case iFichier of
        0: lList.LoadFromFile(bed_cou_codebarre.Text);
        1: lList.LoadFromFile(bed_cou_prixachat.Text);
        2: lList.LoadFromFile(bed_cou_caisse.Text);
        3: lList.LoadFromFile(bed_cou_reception.Text);
        4: lList.LoadFromFile(bed_cou_consodiv.Text);
      end;
    except
      Continue;
    end;
    //remplissage du dataset
    cds_Art.DisableControls;
    cds_Art.EmptyDataSet;
    for iList := 0 to lList.Count -1 do
    begin
      lListSep.DelimitedText := lList[iList];
      cds_Art.Append;
      cds_Art.FieldByName('ART_CODE').AsString := lListSep[0];
      cds_Art.FieldByName('COU_CODE').AsString := lListSep[2];
      cds_Art.Post;
    end;
    cds_Art.EnableControls;
    cds_Art.First;
    
    while not cds_Art.Eof do
    begin
      if cds_couleur.RecordCount = 0 then
      begin
        cds_couleur.Append;
        cds_couleur.FieldByName('ART_CODE').AsString := cds_Art.FieldByName('ART_CODE').AsString;
        cds_couleur.FieldByName('COU_CODE').AsString := cds_Art.FieldByName('COU_CODE').AsString;
        cds_couleur.Post;
      end;
      pb_cou_fichier.Position := ((cds_Art.RecNo+1)*100) div cds_Art.RecordCount;
      pb_couleur.Position := iFichier*20 + (pb_cou_fichier.Position div 5);
      Application.ProcessMessages;
      cds_Art.Next;
    end;
  end;

  
 
  //on libère le CDS pour l'enregistrement
  cds_couleur.MasterSource := nil;
  cds_couleur.MasterFields := '';
  cds_couleur.first;
  
  lCsv := TExportHeaderOL.Create;
  lCsv.Add('ART_CODE');
  lCsv.Add('COU_CODE');
  lCsv.Add('COU_CODE');
  lCsv.Separator := ';';
  lCsv.bWriteHeader := False;
  lCsv.ConvertToCsv(cds_couleur,bed_cou_couleur.Text);
  
  //cds_couleur.MasterFields := 'ART_CODE;COU_CODE';
  //cds_couleur.MasterSource := ds_couleur;
  
  pb_couleur.Position := 0;
  pb_cou_fichier.Position := 0;
  
  finally
    lList.Free;
    lListCouleur.Free;
    lListSep.Free;
    lListSepCou.Free;
    lCsv.Free;
    
    ts_Couleur.Enabled := true;
    btn_cou_execute.Enabled := false;
    lbl_cou_quit.Visible := true;
  end;
end;

procedure TFrm_Main.Btn_CSV_ExecuteClick(Sender: TObject);
var
  listArticle, listMarque,
  listFournisseur,
  listDestMarque, listDestFournisseur,
  listDestArtOrph                       : TStringList;
  iMarque, iFournisseur, iArticle,
  NbModele                              : integer;
  Code, Nom, Ville, Pays, ArtCode       : string;
begin
  listArticle     := TStringList.Create;
  listMarque      := TStringList.Create;
  listFournisseur := TStringList.Create;
  listDestMarque  := TStringList.Create;
  listDestFournisseur  := TStringList.Create;
  listDestArtOrph  := TStringList.Create;

  try
    Btn_CSV_Execute.Enabled := false;
    Btn_CSV_Execute.Caption := 'Running ...';
    listArticle.LoadFromFile(Bed_CSV_Articles.Text);
    listMarque.LoadFromFile(Bed_CSV_Marques.Text);
    listFournisseur.LoadFromFile(Bed_CSV_Fournisseurs.Text);
    pb_CSV.Max := 2*(listArticle.Count*listMarque.Count) + listFournisseur.Count*listArticle.Count;
    //recherche des articles orphelins
    for iArticle := 0 to listArticle.Count -1 do
    begin
      ArtCode := copy(listArticle[iArticle],1,pos(';',listArticle[iArticle])-1);
      //on vire la 1ere colone (code article)
      Code := copy(listArticle[iArticle],pos(';',listArticle[iArticle])+1,length(listArticle[iArticle])-pos(';',listArticle[iArticle])-1);
      //code marque dans la 2e colonne
      Code := copy(Code,1,pos(';',Code)-1);
      NbModele := 0;
      for iMarque := 0 to listMarque.Count -1 do
      begin
        // si c'est la bonne marque on compte
        if code = copy(listMarque[iMarque],1,pos(';',listMarque[iMarque])-1) then
          inc(NbModele);
      end;
      //si pas de marque trouvé dans la liste on note l'article
      if NbModele = 0 then
        listDestArtOrph.Add(ArtCode);
      pb_CSV.StepBy(listMarque.Count);
    end;
    listDestArtOrph.SaveToFile(Bed_CSV_DestArtOrph.Text);

    for iMarque := 0 to listMarque.Count -1 do
    begin
      //code dans la première colonne
      Code := copy(listMarque[iMarque],1,pos(';',listMarque[iMarque])-1);
      listMarque[iMarque] := copy(listMarque[iMarque],pos(';',listMarque[iMarque])+1,length(listMarque[iMarque])-pos(';',listMarque[iMarque])-1);
      //nom dans la 2e colonne
      Nom := copy(listMarque[iMarque],1,pos(';',listMarque[iMarque])-1);
      NbModele := 0;
      for iArticle := 0 to listArticle.Count -1 do
      begin
        //on vire la 1ere colonne (code article)
        ArtCode := listArticle[iArticle];
        ArtCode := Copy(ArtCode,pos(';',ArtCode)+1,length(ArtCode)-pos(';',ArtCode));
        // on récupère le code marque de l'article (2eme colonne)
        ArtCode := Copy(ArtCode,1,pos(';',ArtCode)-1);
        // si c'est la bonne marque on compte
        if ArtCode = Code then
          inc(NbModele);
      end;
      listDestMarque.Add(Code+';'+Nom+';'+IntToStr(NbModele)+';');
      pb_CSV.StepBy(listArticle.Count);
    end;
    listDestMarque.SaveToFile(bed_CSV_DestMarque.Text);

    for iFournisseur := 0 to listFournisseur.Count -1 do
    begin
      //code dans la première colonne
      Code := copy(listFournisseur[iFournisseur],1,pos(';',listFournisseur[iFournisseur])-1);
      listFournisseur[iFournisseur] := copy(listFournisseur[iFournisseur],pos(';',listFournisseur[iFournisseur])+1,length(listFournisseur[iFournisseur])-pos(';',listFournisseur[iFournisseur])-1);
      //nom dans la 2e colonne
      Nom := copy(listFournisseur[iFournisseur],1,pos(';',listFournisseur[iFournisseur])-1);
      listFournisseur[iFournisseur] := copy(listFournisseur[iFournisseur],pos(';',listFournisseur[iFournisseur])+1,length(listFournisseur[iFournisseur])-pos(';',listFournisseur[iFournisseur])-1);
      //on vire la 3eme colonne (CodeIS)
      listFournisseur[iFournisseur] := copy(listFournisseur[iFournisseur],pos(';',listFournisseur[iFournisseur])+1,length(listFournisseur[iFournisseur])-pos(';',listFournisseur[iFournisseur])-1);
      //on vire la 4eme colonne (Adr1)
      listFournisseur[iFournisseur] := copy(listFournisseur[iFournisseur],pos(';',listFournisseur[iFournisseur])+1,length(listFournisseur[iFournisseur])-pos(';',listFournisseur[iFournisseur])-1);
      //on vire la 5eme colonne (Adr2)
      listFournisseur[iFournisseur] := copy(listFournisseur[iFournisseur],pos(';',listFournisseur[iFournisseur])+1,length(listFournisseur[iFournisseur])-pos(';',listFournisseur[iFournisseur])-1);
      //on vire la 6eme colonne (Adr3)
      listFournisseur[iFournisseur] := copy(listFournisseur[iFournisseur],pos(';',listFournisseur[iFournisseur])+1,length(listFournisseur[iFournisseur])-pos(';',listFournisseur[iFournisseur])-1);
      //on vire la 7eme colonne (CP)
      listFournisseur[iFournisseur] := copy(listFournisseur[iFournisseur],pos(';',listFournisseur[iFournisseur])+1,length(listFournisseur[iFournisseur])-pos(';',listFournisseur[iFournisseur])-1);
      //Ville dans la 8e colonne
      Ville := copy(listFournisseur[iFournisseur],1,pos(';',listFournisseur[iFournisseur])-1);
      listFournisseur[iFournisseur] := copy(listFournisseur[iFournisseur],pos(';',listFournisseur[iFournisseur])+1,length(listFournisseur[iFournisseur])-pos(';',listFournisseur[iFournisseur])-1);
      //Pays dans la 9e colonne
      Pays := copy(listFournisseur[iFournisseur],1,pos(';',listFournisseur[iFournisseur])-1);
      NbModele := 0;
      for iArticle := 0 to listArticle.Count -1 do
      begin
        ArtCode := listArticle[iArticle];
        //on vire la 1ere colone (code article)
        ArtCode := Copy(ArtCode,pos(';',ArtCode)+1,length(ArtCode)-pos(';',ArtCode));
        //on vire la 2eme colone (code marque)
        ArtCode := Copy(ArtCode,pos(';',ArtCode)+1,length(ArtCode)-pos(';',ArtCode));
        //on vire la 3eme colone (code taille)
        ArtCode := Copy(ArtCode,pos(';',ArtCode)+1,length(ArtCode)-pos(';',ArtCode));
        // on récupère le code fournisseur de l'article (4eme colonne)
        ArtCode := Copy(ArtCode,1,pos(';',ArtCode)-1);
        // si c'est le bon fournisseur on compte
        if ArtCode = Code then
          inc(NbModele);
      end;
      //listDestFournisseur.Add(Code+';'+Nom+';'+Ville+';'+Pays+';'+IntToStr(NbModele));
      listDestFournisseur.Add(Code+';'+Nom+';'+Ville+';'+Pays+';0;');
      pb_CSV.StepBy(listArticle.Count);
    end;
    listDestFournisseur.SaveToFile(Bed_CSV_DestFourn.Text);
  except
    on E:Exception do MessageDlg('Erreur dans le traitement :'+#13+E.Message,mtError,[mbOK],0);
  end;
  listArticle.Free;
  listMarque.Free;
  listFournisseur.Free;
  listDestMarque.Free;
  listDestFournisseur.Free;
  listDestArtOrph.Free;
  pb_CSV.Position := 0;
  Btn_CSV_Execute.Enabled := true;
  Btn_CSV_Execute.Caption := 'Execute';
end;

procedure TFrm_Main.Btn_Ctrl_Stock_RGClick(Sender: TObject);
var
  bLocate : Boolean;
  sPath : string;
  sCodeBarre : string;
  cdsStock : TClientDataSet;
  cdsArticle : TClientDataSet;
  slTmp : TStringList;
  slLog : TStringList;
begin
  //Chemin
  sPath := Bed_PathRefGeneGinkoia.Text + '\';

  slTmp := TStringList.Create;
  try
    //Ligne de Taille
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + 'Article.csv');   //Chargement du fichier
    slTmp.Insert(0,'A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V');     //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + 'Article.csv');      //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  slTmp := TStringList.Create;
  try
    //Ligne de Taille
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + 'Stock.csv');   //Chargement du fichier
    slTmp.Insert(0,'CB;QTE;T');     //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + 'Stock.csv');      //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsArticle := TClientDataSet.Create(nil);
  cdsStock := TClientDataSet.Create(nil);

  slTmp := TStringList.Create;
  slLog := TStringList.Create;
  try
    LoadDataSet('Article',
                sPath + 'Article.csv',
                'S', cdsArticle);

    LoadDataSet('Stock',
                sPath + 'Stock.csv',
                'CB', cdsStock);

    cdsStock.First;
    bLocate := False;
    while not cdsStock.Eof do
    begin
      sCodeBarre := cdsStock.FieldByName('CB').AsString;
      bLocate := cdsArticle.Locate('S',sCodeBarre,[]);

      if not bLocate then
      begin
        slLog.Add(cdsStock.FieldByName('CB').AsString + ';' +
                  cdsStock.FieldByName('QTE').AsString);
      end;

      cdsStock.Next;
    end;

    if FileExists(sPath + 'LogStock.csv') then
      DeleteFile(sPath + 'LogStock.csv');
    slLog.SaveToFile(sPath + 'LogStock.csv');

  finally
    if slTmp <> nil then
      FreeAndNil(slTmp);

    if slLog <> nil then
      FreeAndNil(slLog);

    if cdsStock <> nil then
      FreeAndNil(cdsStock);

    if cdsArticle <> nil then
      FreeAndNil(cdsArticle);
  end;
  //-----------------------------------
end;

procedure TFrm_Main.btn_ExecuteRempCodeClick(Sender: TObject);
var
  lListModele, lListGrille: TStringList;
  lArrayGrille: array of TStringDynArray;
  lArrayModele: TStringDynArray;
  iModele,iGrille,iLigne: integer;
begin
  btn_ExecuteRempCode.Enabled := false;
  bed_Modele.Enabled := false;
  bed_GrilleFamille.Enabled := false;
  lListGrille := TStringList.Create;

  lListGrille.LoadFromFile(bed_GrilleFamille.Text);

  SetLength(lArrayGrille,lListGrille.Count);
  for iGrille := 0 to lListGrille.Count - 1 do
  begin
    lArrayGrille[iGrille] := SplitString(lListGrille[iGrille],';');
  end;
  lListGrille.Free;

  lListModele := TStringList.Create;
  lListModele.LoadFromFile(bed_Modele.Text);
  for iModele := 0 to lListModele.Count - 1 do
  begin
    lArrayModele := SplitString(lListModele[iModele],';');
    for iGrille := 0 to Length(lArrayGrille) - 1 do
    begin
      //si on trouve le code bar et que le code correspondant n'est pas vide on remplace
      //on remplace directement dans la stringlist (ligne complete) : plus simple pour sauvegarder
      if (pos(lArrayGrille[iGrille][4],lArrayModele[6]) > 0) AND (lArrayGrille[iGrille][6] <> '') then
      begin
        lArrayModele[6] := lArrayGrille[iGrille][6];
        for iLigne := 0 to Length(lArrayModele) - 1 do
        begin
          if iLigne = 0 then
            lListModele[iModele] := lArrayModele[iLigne]
          else
            lListModele[iModele] := lListModele[iModele] + ';' + lArrayModele[iLigne];
        end;
        break;
      end;
    end;
    pb_RempCB.Position := ((iModele+1)*100) div lListModele.Count;
  end;
  lListModele.SaveToFile(bed_Modele.Text);
  lListModele.Free;
  pb_RempCB.Position := 0;
  btn_ExecuteRempCode.Enabled := true;
  bed_Modele.Enabled := true;
  bed_GrilleFamille.Enabled := true;
end;

procedure TFrm_Main.Btn_GTFClick(Sender: TObject);
var
  bLocate : Boolean;
  sPath : string;
  slTmp : TStringList;
  cdsGrilleTaille : TClientDataSet;
  cdsArticle : TClientDataSet;
  cdsTaille : TClientDataSet;
  cdsCodeBarre : TClientDataSet;
  cdsPrixAchat : TClientDataSet;
  cdsPrixVente : TClientDataSet;
  cdsPrixVenteIndicatif : TClientDataSet;
  sPxCatalogue : string;
begin
  //Chemin
  sPath := Bed_PathFile_GTF.Text + '\';

  slTmp  := TStringList.Create;
  try
    //Ligne de Taille
    slTmp.Clear;
    slTmp.LoadFromFile(sPath  + GrTailleLig_CSV);   //Chargement du fichier
    slTmp.Insert(0,GetHeader(GrTailleLig_COL));     //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + GrTailleLig_CSV);      //Enregistrement du fichier
    //Article
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + Article_CSV);  //Chargement du fichier
    slTmp.Insert(0,GetHeader(Article_COL));   //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + Article_CSV);    //Enregistrement du fichier
    //Code Barre
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + CodeBarre_CSV);  //Chargement du fichier
    slTmp.Insert(0,GetHeader(CodeBarre_COL));   //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + CodeBarre_CSV);    //Enregistrement du fichier
    //Prix Achat
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + Prix_Achat_CSV);  //Chargement du fichier
    slTmp.Insert(0,GetHeader(Prix_Achat_COL));   //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + Prix_Achat_CSV);    //Enregistrement du fichier
    //Prix Vente
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + Prix_Vente_CSV);  //Chargement du fichier
    slTmp.Insert(0,GetHeader(Prix_Vente_COL));   //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + Prix_Vente_CSV);    //Enregistrement du fichier
    //Prix de Vente Indicatif
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + Prix_Vente_Indicatif_CSV);  //Chargement du fichier
    slTmp.Insert(0,GetHeader(Prix_Vente_Indicatif_COL));   //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + Prix_Vente_Indicatif_CSV);    //Enregistrement du fichier
    //Grille de Taille
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + GrTaille_CSV);   //Chargement du fichier
    slTmp.Insert(0,GetHeader(GrTaille_COL));    //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + GrTaille_CSV);     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  //Traitement du fichier Ligne de Taille
  cdsTaille := TClientDataSet.Create(nil);
  try
    LoadDataSet('Ligne de Taille',
                sPath + GrTailleLig_CSV,
                'CODE_GT;CODE',cdsTaille);

    slTmp  := TStringList.Create;
    try
      cdsTaille.First;
      while not cdsTaille.Eof do
      begin
        if cdsTaille.FieldByName('CODE_GT').AsString <> 'CODE_GT' then
          slTmp.Add(cdsTaille.FieldByName('CODE_GT').AsString + ';' +
                    cdsTaille.FieldByName('NOM').AsString + ';' +
                    cdsTaille.FieldByName('CODEIS').AsString + ';' +
                    cdsTaille.FieldByName('CODE_GT').AsString + '-' + cdsTaille.FieldByName('CODE').AsString + ';' +
                    cdsTaille.FieldByName('CENTRALE').AsString + ';' +
                    cdsTaille.FieldByName('CORRES').AsString + ';' +
                    cdsTaille.FieldByName('ORDREAFF').AsString + ';' +
                    cdsTaille.FieldByName('ACTIF').AsString + ';');
        cdsTaille.Next;
      end;
    finally
      if FileExists(sPath + GrTailleLig_CSV) then
        DeleteFile(sPath + GrTailleLig_CSV);

      slTmp.SaveToFile(sPath + GrTailleLig_CSV);
      FreeAndNil(slTmp);
    end;
  finally
    FreeAndNil(cdsTaille);
  end;
  //------------------------------------------


  cdsArticle := TClientDataSet.Create(nil);
  try
    LoadDataSet('Article',
                sPath + Article_CSV,
                'CODE', cdsArticle);
    cdsArticle.First;
    //Traitement du fichier Code Barre
    cdsCodeBarre := TClientDataSet.Create(nil);
    try
      LoadDataSet('Code Barre',
                  sPath + CodeBarre_CSV,
                  'CODE_ART;CODE_TAILLE;CODE_COUL', cdsCodeBarre);
      slTmp  := TStringList.Create;
      try
        cdsCodeBarre.First;
        bLocate := cdsArticle.Locate('CODE',cdsCodeBarre.FieldByName('CODE_ART').AsString,[]);
        while not cdsCodeBarre.Eof do
        begin
          if cdsCodeBarre.FieldByName('CODE_ART').AsString <> 'CODE_ART' then
          begin
            if cdsCodeBarre.FieldByName('CODE_ART').AsString <> cdsArticle.FieldByName('CODE').AsString then
              bLocate := cdsArticle.Locate('CODE',cdsCodeBarre.FieldByName('CODE_ART').AsString,[]);

            if bLocate then
              slTmp.Add(cdsCodeBarre.FieldByName('CODE_ART').AsString + ';' +
                        cdsArticle.FieldByName('CODE_GT').AsString + '-' + cdsCodeBarre.FieldByName('CODE_TAILLE').AsString + ';' +
                        cdsCodeBarre.FieldByName('CODE_COUL').AsString + ';' +
                        cdsCodeBarre.FieldByName('EAN').AsString + ';' +
                        cdsCodeBarre.FieldByName('TYPE').AsString + ';')
            else
              slTmp.Add('Article non trouvé : ' + cdsCodeBarre.FieldByName('CODE_ART').AsString);
          end;
          cdsCodeBarre.Next;
        end;
      finally
        if FileExists(sPath + CodeBarre_CSV) then
          DeleteFile(sPath + CodeBarre_CSV);

        slTmp.SaveToFile(sPath + CodeBarre_CSV);
        FreeAndNil(slTmp);
      end;
    finally
      FreeAndNil(cdsCodeBarre);
    end;
    //-----------------------------------

    //Traitement du fichier Prix Achat
    cdsPrixAchat := TClientDataSet.Create(nil);
    try
      LoadDataSet('Prix achat',
                  sPath + Prix_Achat_CSV,
                  'CODE_ART;CODE_TAILLE;CODE_COUL;CODE_FOU', cdsPrixAchat);
      slTmp  := TStringList.Create;
      try
        cdsPrixAchat.First;
        bLocate := cdsArticle.Locate('CODE',cdsPrixAchat.FieldByName('CODE_ART').AsString,[]);
        while not cdsPrixAchat.Eof do
        begin
          if cdsPrixAchat.FieldByName('CODE_ART').AsString <> 'CODE_ART' then
          begin
            if cdsPrixAchat.FieldByName('CODE_ART').AsString <> cdsArticle.FieldByName('CODE').AsString then
              bLocate := cdsArticle.Locate('CODE',cdsPrixAchat.FieldByName('CODE_ART').AsString,[]);

            if bLocate then
            begin
              if cdsPrixAchat.FieldByName('PXCATALOGUE').AsString = '0' then
                sPxCatalogue := cdsPrixAchat.FieldByName('PX_ACHAT').AsString
              else
                sPxCatalogue := cdsPrixAchat.FieldByName('PXCATALOGUE').AsString;

              if cdsPrixAchat.FieldByName('PXDEBASE').AsString = '1' then
                slTmp.Add(cdsPrixAchat.FieldByName('CODE_ART').AsString + ';' +
                        cdsPrixAchat.FieldByName('CODE_TAILLE').AsString + ';' +
                        cdsPrixAchat.FieldByName('CODE_COUL').AsString + ';' +
                        cdsPrixAchat.FieldByName('CODE_FOU').AsString + ';' +
                        sPxCatalogue + ';' +
                        cdsPrixAchat.FieldByName('PX_ACHAT').AsString + ';' +
                        cdsPrixAchat.FieldByName('FOU_PRINCIPAL').AsString + ';' +
                        cdsPrixAchat.FieldByName('PXDEBASE').AsString + ';')
              else
                slTmp.Add(cdsPrixAchat.FieldByName('CODE_ART').AsString + ';' +
                        cdsArticle.FieldByName('CODE_GT').AsString + '-' + cdsPrixAchat.FieldByName('CODE_TAILLE').AsString + ';' +
                        cdsPrixAchat.FieldByName('CODE_COUL').AsString + ';' +
                        cdsPrixAchat.FieldByName('CODE_FOU').AsString + ';' +
                        sPxCatalogue + ';' +
                        cdsPrixAchat.FieldByName('PX_ACHAT').AsString + ';' +
                        cdsPrixAchat.FieldByName('FOU_PRINCIPAL').AsString + ';' +
                        cdsPrixAchat.FieldByName('PXDEBASE').AsString + ';')
            end
            else
              slTmp.Add('Article non trouvé : ' + cdsPrixAchat.FieldByName('CODE_ART').AsString);
          end;
          cdsPrixAchat.Next;
        end;
      finally
        if FileExists(sPath + Prix_Achat_CSV) then
          DeleteFile(sPath + Prix_Achat_CSV);

        slTmp.SaveToFile(sPath + Prix_Achat_CSV);
        FreeAndNil(slTmp);
      end;
    finally
      FreeAndNil(cdsPrixAchat);
    end;
    //---------------------------------

    //Traitement du fichier Prix de Vente
    cdsPrixVente := TClientDataSet.Create(nil);
    try
      LoadDataSet('Prix de vente',
                  sPath + Prix_Vente_CSV,
                  'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR', cdsPrixVente);
      slTmp  := TStringList.Create;
      try
        cdsPrixVente.First;
        bLocate := cdsArticle.Locate('CODE',cdsPrixVente.FieldByName('CODE_ART').AsString,[]);
        while not cdsPrixVente.Eof do
        begin
          if cdsPrixVente.FieldByName('CODE_ART').AsString <> 'CODE_ART' then
          begin
            if cdsPrixVente.FieldByName('CODE_ART').AsString <> cdsArticle.FieldByName('CODE').AsString then
              bLocate := cdsArticle.Locate('CODE',cdsPrixVente.FieldByName('CODE_ART').AsString,[]);

            if bLocate then
              slTmp.Add(cdsPrixVente.FieldByName('CODE_ART').AsString + ';' +
                        cdsArticle.FieldByName('CODE_GT').AsString + '-' + cdsPrixVente.FieldByName('CODE_TAILLE').AsString + ';' +
                        cdsPrixVente.FieldByName('CODE_COUL').AsString + ';' +
                        cdsPrixVente.FieldByName('NOMTAR').AsString + ';' +
                        cdsPrixVente.FieldByName('PX_VENTE').AsString + ';' +
                        cdsPrixVente.FieldByName('PXDEBASE').AsString + ';')
            else
              slTmp.Add('Article non trouvé : ' + cdsPrixVente.FieldByName('CODE_ART').AsString);
          end;
          cdsPrixVente.Next;
        end;
      finally
        if FileExists(sPath + Prix_Vente_CSV) then
          DeleteFile(sPath + Prix_Vente_CSV);

        slTmp.SaveToFile(sPath + Prix_Vente_CSV);
        FreeAndNil(slTmp);
      end;
    finally
      FreeAndNil(cdsPrixVente);
    end;
    //---------------------------------

    //Traitement du fichier Prix de Vente Indicatif
    cdsPrixVenteIndicatif := TClientDataSet.Create(nil);
    try
      LoadDataSet('Prix de vente indicatif',
                  sPath + Prix_Vente_Indicatif_CSV,
                  'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR', cdsPrixVenteIndicatif);
      slTmp  := TStringList.Create;
      try
        cdsPrixVenteIndicatif.First;
        bLocate := cdsArticle.Locate('CODE',cdsPrixVenteIndicatif.FieldByName('CODE_ART').AsString,[]);
        while not cdsPrixVenteIndicatif.Eof do
        begin
          if cdsPrixVenteIndicatif.FieldByName('CODE_ART').AsString <> 'CODE_ART' then
          begin
            if cdsPrixVenteIndicatif.FieldByName('CODE_ART').AsString <> cdsArticle.FieldByName('CODE').AsString then
              bLocate := cdsArticle.Locate('CODE',cdsPrixVenteIndicatif.FieldByName('CODE_ART').AsString,[]);

            if bLocate then
              slTmp.Add(cdsPrixVenteIndicatif.FieldByName('CODE_ART').AsString + ';' +
                        cdsArticle.FieldByName('CODE_GT').AsString + '-' + cdsPrixVenteIndicatif.FieldByName('CODE_TAILLE').AsString + ';' +
                        cdsPrixVenteIndicatif.FieldByName('CODE_COUL').AsString + ';' +
                        cdsPrixVenteIndicatif.FieldByName('NOMTAR').AsString + ';' +
                        cdsPrixVenteIndicatif.FieldByName('PX_VTE_INDIC').AsString + ';' +
                        cdsPrixVenteIndicatif.FieldByName('PX_VTE_INDIC_DATE').AsString + ';' +
                        cdsPrixVenteIndicatif.FieldByName('PX_VTE_AVENIR').AsString + ';' +
                        cdsPrixVenteIndicatif.FieldByName('PX_VTE_AVENIR_DATE').AsString + ';' +
                        cdsPrixVenteIndicatif.FieldByName('PXDEBASE').AsString + ';')
            else
              slTmp.Add('Article non trouvé : ' + cdsPrixVenteIndicatif.FieldByName('CODE_ART').AsString);
          end;
          cdsPrixVenteIndicatif.Next;
        end;
      finally
        if FileExists(sPath + Prix_Vente_Indicatif_CSV) then
          DeleteFile(sPath + Prix_Vente_Indicatif_CSV);

        slTmp.SaveToFile(sPath + Prix_Vente_Indicatif_CSV);
        FreeAndNil(slTmp);
      end;
    finally
      FreeAndNil(cdsPrixVenteIndicatif);
    end;
    //---------------------------------
    cdsArticle.First;
    slTmp  := TStringList.Create;
    try
      while not cdsArticle.Eof do
      begin
        slTmp.Add(cdsArticle.FieldByName('CODE').AsString + ';' +           //CODE
                  cdsArticle.FieldByName('CODE_MRQ').AsString + ';' +       //CODE_MRQ
                  cdsArticle.FieldByName('CODE_GT').AsString + ';' +        //CODE_GT
                  cdsArticle.FieldByName('CODE_FOURN').AsString + ';' +     //CODE_FOURN
                  cdsArticle.FieldByName('NOM').AsString + ';' +            //NOM
                  cdsArticle.FieldByName('CODEIS').AsString + ';' +         //CODEIS
                  cdsArticle.FieldByName('CODEFEDAS').AsString + ';' +      //CODEFEDAS
                  cdsArticle.FieldByName('DESCRIPTION').AsString + ';' +    //DESCRIPTION
                  cdsArticle.FieldByName('CLASS1').AsString + ';' +         //CLASS1
                  cdsArticle.FieldByName('CLASS2').AsString + ';' +         //CLASS2
                  cdsArticle.FieldByName('CLASS3').AsString + ';' +         //CLASS3
                  cdsArticle.FieldByName('CLASS4').AsString + ';' +         //CLASS4
                  cdsArticle.FieldByName('CLASS5').AsString + ';' +         //CLASS5
                  cdsArticle.FieldByName('CLASS6').AsString + ';' +         //CLASS6
                  cdsArticle.FieldByName('FIDELITE').AsString + ';' +       //FIDELITE
                  cdsArticle.FieldByName('DATECREATION').AsString + ';' +   //DATECREATION
                  cdsArticle.FieldByName('COMENT1').AsString + ';' +        //COMENT1
                  cdsArticle.FieldByName('COMENT2').AsString + ';' +        //COMENT2
                  cdsArticle.FieldByName('TVA').AsString + ';' +            //TVA
                  cdsArticle.FieldByName('PSEUDO').AsString + ';' +         //PSEUDO
                  cdsArticle.FieldByName('ARCHIVER').AsString + ';' +       //ARCHIVER
                  cdsArticle.FieldByName('CODE_GENRE').AsString + ';' +     //CODE_GENRE
                  cdsArticle.FieldByName('CODE_DOMAINE').AsString + ';' +   //CODE_DOMAINE
                  cdsArticle.FieldByName('CENTRALE').AsString + ';' +       //CENTRALE
                  cdsArticle.FieldByName('TYPECOMPTABLE').AsString + ';' +  //TYPECOMPTABLE
                  cdsArticle.FieldByName('FLAGMODELE').AsString + ';' +     //FLAGMODELE
                  cdsArticle.FieldByName('STKIDEAL').AsString + ';');       //STKIDEAL
        cdsArticle.Next;
      end;
    finally
      if FileExists(sPath + Article_CSV) then
        DeleteFile(sPath + Article_CSV);

      slTmp.SaveToFile(sPath + Article_CSV);
      FreeAndNil(slTmp);
    end;
  finally
    FreeAndNil(cdsArticle);
  end;

  //Traitement du fichier Grille de Taille
  cdsGrilleTaille := TClientDataSet.Create(nil);
  try
    LoadDataSet('Grille de Taille',
                sPath + GrTaille_CSV,
                'CODE', cdsGrilleTaille);
    slTmp  := TStringList.Create;
    try
      cdsGrilleTaille.First;
      while not cdsGrilleTaille.Eof do
      begin
        if cdsGrilleTaille.FieldByName('CODE').AsString <> 'CODE' then
        begin
          if cdsGrilleTaille.FieldByName('TYPE_GRILLE').AsString = '' then
            slTmp.Add(cdsGrilleTaille.FieldByName('CODE').AsString + ';' +
                      cdsGrilleTaille.FieldByName('NOM').AsString + ';' +
                      cdsGrilleTaille.FieldByName('CODEIS').AsString + ';' +
                      Ed_Type_GTF.Text + ';' +
                      Ed_CodeType_GTF.Text + ';' +
                      cdsGrilleTaille.FieldByName('CODEIS_TYPEGT').AsString + ';' +
                      cdsGrilleTaille.FieldByName('CENTRALE_TYPEGT').AsString + ';' +
                      cdsGrilleTaille.FieldByName('CENTRALE').AsString + ';')
          else
            slTmp.Add(cdsGrilleTaille.FieldByName('CODE').AsString + ';' +
                      cdsGrilleTaille.FieldByName('NOM').AsString + ';' +
                      cdsGrilleTaille.FieldByName('CODEIS').AsString + ';' +
                      cdsGrilleTaille.FieldByName('TYPE_GRILLE').AsString + ';' +
                      cdsGrilleTaille.FieldByName('CODE_TYPEGT').AsString + ';' +
                      cdsGrilleTaille.FieldByName('CODEIS_TYPEGT').AsString + ';' +
                      cdsGrilleTaille.FieldByName('CENTRALE_TYPEGT').AsString + ';' +
                      cdsGrilleTaille.FieldByName('CENTRALE').AsString + ';');
        end;
        cdsGrilleTaille.Next;
      end;
    finally
      if FileExists(sPath + GrTaille_CSV) then
        DeleteFile(sPath + GrTaille_CSV);

      slTmp.SaveToFile(sPath + GrTaille_CSV);
      FreeAndNil(slTmp);
    end;
  finally
    FreeAndNil(cdsGrilleTaille);
  end;
  //---------------------------------

  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.btn_Gui_ExecuteClick(Sender: TObject);
var
  lList: TStringList;
  lTab: TStringDynArray;
  iList, iCol: integer;
  p1,p2,p3: Integer;

  function UpdateCSV(S : string):string;
  begin
    p1 := Pos('"', S, 1);
    if p1 > 0 then
    begin
      p2 := Pos('"', S, p1+1);
      p3 := Pos(';', S, p1+1);
      while (p3 < p2) AND (p3 > p1) do
      begin
        Delete(S, p3, 1);
        Insert('.',S, p3);
        p3 := Pos(';', S, p1+1);
      end;

      Delete(S, p2, 1);
      Delete(S, p1, 1);

      Result := UpdateCSV(S);
    end
    else
      Result := S;
  end;
begin
  btn_Gui_Execute.Enabled := false;
  Btn_Gui_Execute_All.Enabled := False;
  bed_Gui_CSV.Enabled := false;
  rg_Gui.Enabled := false;
  lList := TStringList.Create;
  lList.LoadFromFile(bed_Gui_CSV.Text);

  case rg_Gui.ItemIndex of
    0 :
    begin
      for iList := 0 to lList.Count -1 do
      begin
        lList[iList] := System.SysUtils.StringReplace(lList[iList],'"','',[System.SysUtils.rfReplaceAll]);
        pb_Gui.Position := ((iList+1)*100) div lList.Count;
      end;
    end;
    1 :
    begin
      for iList := 0 to lList.Count -1 do
      begin
        lTab := SplitString(lList[iList],';');
        for iCol := 0 to Length(lTab) -1 do
        begin
          //on recherche si le premier ou le dernier caractère est un guillemet
          if Length(lTab[iCol]) > 0 then
          begin
            if lTab[iCol][Length(lTab[iCol])] = '"' then
              lTab[iCol] := Copy(lTab[iCol],1,Length(lTab[iCol])-1);
            if lTab[iCol][1] = '"' then
              lTab[iCol] := Copy(lTab[iCol],2,Length(lTab[iCol])-1);
          end;
          //on reconstruit la ligne du stringlist

          if iCol = 0 then
            lList[iList] := lTab[iCol]
          else
            lList[iList] := lList[iList] + ';' + lTab[iCol];
        end;
        pb_Gui.Position := ((iList+1)*100) div lList.Count;
      end;
    end;
    2 :
    begin
      for iList := 0 to lList.Count -1 do
      begin
        lList[iList] := UpdateCSV(lList[iList]);
        pb_Gui.Position := ((iList+1)*100) div lList.Count;
      end;
    end;
  end;
  lList.SaveToFile(bed_Gui_CSV.Text);
  lList.Free;
  pb_Gui.Position := 0;
  bed_Gui_CSV.Enabled := true;
  rg_Gui.Enabled := true;
  btn_Gui_Execute.Enabled := true;
end;

procedure TFrm_Main.Btn_Gui_Execute_AllClick(Sender: TObject);
var
  sPathFolder : string;
  Ch : TSearchRec;
  Nb : Integer;
  procedure Retirecotcote(sPahtFile : string);
  var
    lList: TStringList;
    lTab: TStringDynArray;
    iList, iCol: integer;
  begin
    if FileExists(sPahtFile) then
    begin
      lList := TStringList.Create;
      try
        lList.LoadFromFile(sPahtFile);
        if rg_Gui.ItemIndex = 0 then
        begin
          for iList := 0 to lList.Count -1 do
          begin
            lList[iList] := System.SysUtils.StringReplace(lList[iList],'"','',[System.SysUtils.rfReplaceAll]);
            pb_Gui.Position := ((iList+1)*100) div lList.Count;
          end;
        end
        else
        begin
          for iList := 0 to lList.Count -1 do
          begin
            lTab := SplitString(lList[iList],';');
            for iCol := 0 to Length(lTab) -1 do
            begin
              //on recherche si le premier ou le dernier caractère est un guillemet
              if Length(lTab[iCol]) > 0 then
              begin
                if lTab[iCol][Length(lTab[iCol])] = '"' then
                  lTab[iCol] := Copy(lTab[iCol],1,Length(lTab[iCol])-1);
                if lTab[iCol][1] = '"' then
                  lTab[iCol] := Copy(lTab[iCol],2,Length(lTab[iCol])-1);
              end;
              //on reconstruit la ligne du stringlist
              if iCol = 0 then
                  lList[iList] := lTab[iCol]
                else
                  lList[iList] := lList[iList] + ';' + lTab[iCol];
            end;
            pb_Gui.Position := ((iList+1)*100) div lList.Count;
          end;
        end;
        lList.SaveToFile(sPahtFile);
      finally
        lList.Free;
      end;
    end;
  end;
begin
  btn_Gui_Execute.Enabled := False;
  Btn_Gui_Execute_All.Enabled := False;
  Btn_Sep_Execute_All.Enabled := False;
  bed_Gui_CSV.Enabled := false;
  rg_Gui.Enabled := false;

  sPathFolder := ExtractFilePath(bed_Gui_CSV.Text);

  Nb:=FindFirst(sPathFolder+'*.*',faAnyFile,Ch);
  While Nb=0 do
  begin
    if (Ch.Attr and faDirectory)=0 then
      Retirecotcote(sPathFolder + Ch.Name);
    Nb:=FindNext(Ch);
  end;
  FindClose(Ch);

  pb_Gui.Position := 0;
  bed_Gui_CSV.Enabled := true;
  rg_Gui.Enabled := true;
  btn_Gui_Execute.Enabled := true;
  Btn_Gui_Execute_All.Enabled := True;
  Btn_Sep_Execute_All.Enabled := True;
end;

procedure TFrm_Main.Btn_MigrationDano_ProcessClick(Sender: TObject);

  const cNomMirgation = 'Migration Dano';

 function FindCouleur(aCouleur:string;aTabCouleur:Array of String):Boolean;
  var
    i : Integer;
  begin
    Result := False;
    i := 0;
    While (i < 40) do
    begin
      if (aCouleur = aTabCouleur[i]) then
      begin
        Result := True;
        Exit;
      end;

      Inc(i);
    end;
  end;
var
 sPathArticle : string;
 sPathClient  : string;
 StlArticle   : TStringList;
 StlClient    : TStringList;
 sLogDano     : TStringList;
 sArtEntete   : TStringList;

 SL_Article    : TStringList; 
 SL_CodeBarre  : TStringList;  
 SL_Prix       : TStringList;  
 SL_Marque     : TStringList;
 SL_Grille     : TStringList;
 SL_GrilleLig  : TStringList;
 SL_StockInv   : TStringList;
 SL_GrTaille   : TStringList;
 SL_GrTailleLig: TStringList;
 SL_Fourn      : TStringList;

 SL_Client     : TStringList;
 SL_Compte     : TStringList;
 SL_Fid        : TStringList;
 

 sDirArticle  : String;
 sDirClient   : String;
 sDirExport   : String;

 sCodeModPrev : string;
 sCodeModele  : string;
 sSFamille    : string;
 sFamille     : string;
 sTVA         : string;
 sCodeTaille  : string;
 sNomGrille   : string;
 sTaille      : string;
 sCodeMarque  : string;
 sCouleur     : string;
 sFournisseur : string;
 sEAN         : string;
 sCategorie   : string;
 sNomArticle  : string;
 sDate        : string;
 sSecteur     : string;
 sRayon       : string;
 sGenre       : string;
 sFidelite    : string;
 sCollection  : string;
 sQte         : string;
 sPrixCatal   : String;
 sPrixAchat   : String;
 sPrixVente   : String;
 sRefFourn    : String;
 sDateNaissance : String;

 nbPoint : Integer;

 SavePlace: TBookmark;


 NbligneArt   : Integer;
 NbCompteur   : Integer;
 I,J          : Integer;

 TabCouleur   : Array [1..40] of String;  //Couleur de l'article

 //All
 cds_Dano_Article  : TClientDataSet;
 cds_Dano_Client   : TClientDataSet;

 //Article
 cdsArticle   : TClientDataSet;
 cdsCodeBarre : TClientDataSet;
 cdsPrix      : TClientDataSet;
 cdsStock     : TClientDataSet;
 //Client
 cdsClients   : TClientDataSet;
 cdsComptes   : TClientDataSet;
 cdsFidelite  : TClientDataSet;
 //Etc
 cdsFourn     : TClientDataSet;
 cdsMarque    : TClientDataSet;
 //GrilleTailles
 cdsGrille    : TClientDataSet;
 cdsGrilleLig : TClientDataSet;

begin
  //Traitement du fichier article

  //TstringList Article
  SL_Article    := TStringList.Create;  
  SL_CodeBarre  := TStringList.Create;  
  SL_Prix       := TStringList.Create;  
  SL_Marque     := TStringList.Create;
  SL_Grille     := TStringList.Create;
  SL_GrilleLig  := TStringList.Create;
  SL_StockInv   := TStringList.Create;
  SL_GrTaille   := TStringList.Create;
  SL_GrTailleLig:= TStringList.Create;
  SL_Fourn      := TStringList.Create;

  //TstringList Client
  SL_Client     := TStringList.Create;
  SL_Fid        := TStringList.Create;

  //Log
  sLogDano     := TStringList.Create;

  try
    //Chargemenet du fichier article
    Lbl_MigrationDano_Process.Caption := 'Chargement du fichier Article en cours';    
    sLogDano.Add('Début du traitement ...');

    sDirArticle := Bed_MigrationDano_PatchArticle.Text;
    sDirClient  := Bed_MigrationDano_PatchClient.Text;

    //Vérifie si le fichier existe bien
    if FileExists(sDirArticle) then
    begin
      //Création du dossier ou il y aura tous les fichiers d'export
      sDirExport := ExtractFileDir(sDirArticle);

      if not DirectoryExists(sDirExport + '\Export') then
      begin
        if not CreateDir(sDirExport + '\Export') then
        begin
          sLogDano.Add('Impossible de créer le dossier des fichiers de sortie');
          Exit;
        end;
      end;

      sDirExport := sDirExport + '\Export\';
      
      cds_Dano_Article := TClientDataSet.Create(Nil);

      //Chargement du Dataset en mémoire
      if not LoadDataSet('Fichier article', sDirArticle,'Code Modèle', cds_Dano_Article) then
        Exit;

      //Suppression des anciens fichier si il y a
      if CountFilesInFolder(sDirExport) <> 0 then
      begin
        if MessageDlg('Fichiers détectés : Voulez-vous les supprimer ?', mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
        begin
          if FileExists(sDirExport+'Articles.csv') then
            DeleteFile(sDirExport+'Articles.csv');

          if FileExists(sDirExport+'Code_barre.csv') then
            DeleteFile(sDirExport+'Code_barre.csv');

          if FileExists(sDirExport+'Prix.csv') then
            DeleteFile(sDirExport+'Prix.csv');

          if FileExists(sDirExport+'Stock_inventaire.csv ') then
            DeleteFile(sDirExport+'Stock_inventaire.csv ');

          if FileExists(sDirExport+'Fourn.csv ') then
            DeleteFile(sDirExport+'Fourn.csv ');

          if FileExists(sDirExport+'Fidelite.csv ') then
            DeleteFile(sDirExport+'Fidelite.csv ');

          if FileExists(sDirExport+'Marque.csv ') then
            DeleteFile(sDirExport+'Marque.csv ');

          if FileExists(sDirExport+'Gr_Taille.csv ') then
            DeleteFile(sDirExport+'Gr_Taille.csv ');

          if FileExists(sDirExport+'Gr_Taille_Lig.csv ') then
            DeleteFile(sDirExport+'Gr_Taille_Lig.csv ');

          if FileExists(sDirExport+'Fidelite.csv ') then
            DeleteFile(sDirExport+'Fidelite.csv ');

          if FileExists(sDirExport+'Clients.csv ') then
            DeleteFile(sDirExport+'Clients.csv ');
        end;
      end;

      cds_Dano_Article.First;
      NbligneArt := cds_Dano_Article.RecordCount;
      NbCompteur := 0;

      //Ajout des entêtes
      SL_Article.Add('CODE;' +
                        'CODE_MRQ;' +
                        'CODE_GT;' +
                        'CODE_FOURN;' +
                        'NOM;' +
                        'DESCRIPTION;' +
                        'ACTIVITE;' +
                        'UNIVERS;' +
                        'SECTEUR;' +
                        'RAYON;' +
                        'FAMILLE;' +
                        'SS_FAM;' +
                        'GENRE;' +
                        'CLASS1;' +
                        'CLASS2;' +
                        'CLASS3;' +
                        'CLASS4;' +
                        'CLASS5;' +
                        'IDREF_SSFAM;' +
                        'COUL1;' +
                        'COUL2;' +
                        'COUL3;' +
                        'COUL4;' +
                        'COUL5;' +
                        'COUL6;' +
                        'COUL7;' +
                        'COUL8;' +
                        'COUL9;' +
                        'COUL10;' +
                        'COUL11;' +
                        'COUL12;' +
                        'COUL13;' +
                        'COUL14;' +
                        'COUL15;' +
                        'COUL16;' +
                        'COUL17;' +
                        'COUL18;' +
                        'COUL19;' +
                        'COUL20;' +
                        'FIDELITE;' +
                        'DATECREATION;' +
                        'COLLECTION;' +
                        'COMENT1;' +
                        'COMENT2;' +
                        'TVA;');

      SL_CodeBarre.Add('CODE_ART;' +
                          'TAILLE;' +
                          'COULEUR;' +
                          'EAN;' +
                          'QTE;');

      SL_Prix.Add('CODE_ART;' +
                  'TAILLE;' +
                  'PXCATALOGUE;' +
                  'PX_ACHAT;' +
                  'PX_VENTE;' +
                  'CODE_FOU;'  +
                  'COULEUR;');

      SL_Marque.Add('CODE;' +
                    'CODE_FOU;' +
                    'NOM;');


      SL_Fourn.Add('CODE;' +
                   'NOM;' +
                   'LIGNE1;' +
                   'LIGNE2;' +
                   'LIGNE3;' +
                   'CP;' +
                   'VILLE;' +
                   'PAYS;' +
                   'TEL;' +
                   'FAX;' +
                   'PORTABLE;' +
                   'EMAIL;' +
                   'COMMENTAIRE;' +
                   'NUM_CLT_FOU;' +
                   'COND_PAIE;');

      SL_Grille.Add('CODE;' +
                    'NOM;' +
                    'TYPE_GRILLE;');

      SL_GrilleLig.Add('CODE_GT;' +
                       'NOM;');

      SL_StockInv.Add('CODE;' +
                      'ART_ID;' +
                      'CHRONO;' +
                      'TGF_ID;' +
                      'TAILLE;' +
                      'COU_ID;' +
                      'COULEUR;' +
                      'EAN;' +
                      'QTTE;');

      PB_Dano.Min := 0;
      PB_Dano.Max := cds_Dano_Article.RecordCount;
      PB_Dano.Position := 0;
      PB_Dano.Step     := 1;
                    
      //Creation du fichier article
      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Traitement des lignes en cours...';
      cds_Dano_Article.First;
      while not (cds_Dano_Article.Eof) do
      begin         
        sCodeModele := cds_Dano_Article.FieldByName('Code Modèle').AsString;

        //Marque
        if ((cds_Dano_Article.FieldByName('Marque').AsString = '') or (cds_Dano_Article.FieldByName('Marque').AsString = 'SANS')) then
          sCodeMarque := 'SANS_MARQUE'
        else
          sCodeMarque := cds_Dano_Article.FieldByName('Marque').AsString;

        //Grille de taille
        if cds_Dano_Article.FieldByName('ID grille de taille').AsString = '' then
          sCodeTaille := '0'
        else
          sCodeTaille := cds_Dano_Article.FieldByName('ID grille de taille').AsString;

        //Fournisseur
        sFournisseur := cds_Dano_Article.FieldByName('Fournisseur').AsString;

        //Nom Article 
        sNomArticle := cds_Dano_Article.FieldByName('Modèle').AsString;
        sSecteur    := cNomMirgation;
        sRayon      := cds_Dano_Article.FieldByName('Univers').AsString;
        sFamille    := cds_Dano_Article.FieldByName('Segment').AsString;
        sSFamille   := cds_Dano_Article.FieldByName('Famille').AsString;  //cds_Dano_Article.FieldByName('Sous-Famille').AsString;
        sGenre      := cds_Dano_Article.FieldByName('Genre').AsString;
        sCollection := cds_Dano_Article.FieldByName('Saison').AsString;
        sTVA        := cds_Dano_Article.FieldByName('Taux TVA').AsString;
        sEAN        := cds_Dano_Article.FieldByName('Code Barre').AsString;
        sTaille     := StringReplace(cds_Dano_Article.FieldByName('Taille').AsString, '', 'UNIQUE', [rfReplaceAll,rfIgnoreCase]);
        sCouleur    := StringReplace(cds_Dano_Article.FieldByName('Nom de la couleur').AsString, '"', 'UNICOLOR', [rfReplaceAll,rfIgnoreCase]);
        sRefFourn   := cds_Dano_Article.FieldByName('Référence Fournisseur').AsString;

        sPrixCatal  := StringReplace(cds_Dano_Article.FieldByName('Prix Achat Article Brut HT').AsString, '', '0', [rfReplaceAll,rfIgnoreCase]);
        sPrixAchat  := StringReplace(cds_Dano_Article.FieldByName('Prix Achat Article Net HT').AsString, '', '0', [rfReplaceAll,rfIgnoreCase]);
        sPrixVente  := StringReplace(cds_Dano_Article.FieldByName('Prix Vente Article Brut TTC').AsString, '', '0', [rfReplaceAll,rfIgnoreCase]);

        sQte        := StringReplace(cds_Dano_Article.FieldByName('Qté en Stock').AsString, '', '0', [rfReplaceAll,rfIgnoreCase]);

        if sSFamille = '' then
        begin
          if sFamille = '' then
          begin
            if sRayon = '' then
            begin
              sSFamille := cNomMirgation;
            end
            else
            begin
              sSFamille := sRayon;
            end;
          end
          else
          begin
            sSFamille := sFamille;
          end;
        end;

        if sFamille = '' then
        begin
          if sRayon = '' then
          begin
            sFamille := cNomMirgation;
          end
          else
          begin
            sFamille := sRayon;
          end;
        end;

        if sRayon = '' then
        begin
          sRayon := cNomMirgation;
        end;

        //Gestion des couleurs
        if sCodeModele <> sCodeModPrev then
        begin
          //je filtre sur l'article pour partir à la recherche de toute les couleurs
          SavePlace := cds_Dano_Article.GetBookmark;
          cds_Dano_Article.DisableControls;
          try
            cds_Dano_Article.Filtered  := False;
            cds_Dano_Article.Filter    := '[Code Modèle] = '+ QuotedStr(sCodeModele);
            cds_Dano_Article.Filtered  := True;
            cds_Dano_Article.FindFirst;

            //je parcours les lignes
            for I := 1 to 41 do
            TabCouleur[I] := '';

            I := 1;
            J := 1;

            While (J <> cds_Dano_Article.RecordCount) do
            Begin
              if cds_Dano_Article.FieldByName('Nom de la couleur').asString <> '' then
                if not FindCouleur(cds_Dano_Article.FieldByName('Nom de la couleur').asString, TabCouleur) then
                begin
                  if (I <=41) then
                  begin
                    TabCouleur[I] := cds_Dano_Article.FieldByName('Nom de la couleur').asString;
                    inc(I);
                  end;

                  if I >= 21 then
                    sLogDano.Add('Code modèle : '+sCodeModele+' -> Couleur peut-être manquante' + cds_Dano_Article.FieldByName('Nom de la couleur').asString);
                end;


              cds_Dano_Article.FindNext;
              Inc(J);
            End;

            //je reviens dans la position ou j'étais initialement dans le fichier
            cds_Dano_Article.Filtered  := False;
          finally
            cds_Dano_Article.EnableControls;
            cds_Dano_Article.GotoBookmark(SavePlace);
            cds_Dano_Article.FreeBookmark(SavePlace);
          end;

          sTVA := '20';
          //Enregistrement de la ligne de modèle
          SL_Article.Add(sCodeModele + ';' +                                        //CODE
                        sCodeMarque + ';' +                                         //CODE_MRQ
                        sCodeTaille + ';' +                                         //CODE_GT
                        sRefFourn + ';' +                                           //CODE_FOURN
                        sNomArticle + ';' +                                         //NOM
                        '' + ';' +                                                  //DESCRIPTION
                        'Domaine principale' + ';' +                                //ACTIVITE
                        cNomMirgation + ';' +                                       //UNIVERS
                        sSecteur + ';' +                                            //SECTEUR
                        sRayon + ';' +                                              //RAYON
                        sFamille + ';' +                                            //FAMILLE
                        sSFamille + ';' +                                           //SS_FAM
                        sGenre + ';' +                                              //GENRE
                        '' + ';' +                                                  //CLASS1
                        '' + ';' +                                                  //CLASS2
                        '' + ';' +                                                  //CLASS3
                        '' + ';' +                                                  //CLASS4
                        '' + ';' +                                                  //CLASS5
                        '0' + ';' +                                                 //IDREF_SSFAM
                        TabCouleur[1] + ';' +                                       //COUL1
                        TabCouleur[2] + ';' +                                       //COUL2
                        TabCouleur[3] + ';' +                                       //COUL3
                        TabCouleur[4] + ';' +                                       //COUL4
                        TabCouleur[5] + ';' +                                       //COUL5
                        TabCouleur[6] + ';' +                                       //COUL6
                        TabCouleur[7] + ';' +                                       //COUL7
                        TabCouleur[8] + ';' +                                       //COUL8
                        TabCouleur[9] + ';' +                                       //COUL9
                        TabCouleur[10] + ';' +                                      //COUL10
                        TabCouleur[11] + ';' +                                      //COUL11
                        TabCouleur[12] + ';' +                                      //COUL12
                        TabCouleur[13] + ';' +                                      //COUL13
                        TabCouleur[14] + ';' +                                      //COUL14
                        TabCouleur[15] + ';' +                                      //COUL15
                        TabCouleur[16] + ';' +                                      //COUL16
                        TabCouleur[17] + ';' +                                      //COUL17
                        TabCouleur[18] + ';' +                                      //COUL18
                        TabCouleur[19] + ';' +                                      //COUL19
                        TabCouleur[20] + ';' +                                      //COUL20
                        '1' + ';' +                                                 //FIDELITE
                        datetostr(date()) + ';' +                                   //DATECREATION
                        '' + ';' +                                                  //COLLECTION
                        '' + ';' +                                                  //COMENT1
                        sCollection + ';' +                                         //COMENT2
                        sTVA + ';');                                                //TVA
        end;
                   
        //Marque
        if SL_Marque.IndexOf(sCodeMarque+';'+sFournisseur+';'+sCodeMarque) = -1 then
        begin
          SL_Marque.Add(sCodeMarque + ';' +
                      sFournisseur + ';' +
                      sCodeMarque + ';');
        end;

        //Fournisseur
        if SL_Fourn.IndexOf(sFournisseur + ';' + sFournisseur + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';') = -1 then
        begin
          SL_Fourn.Add(sFournisseur + ';' +
                     sFournisseur + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';' +
                     '' + ';');
        end;

        //Grille de taile
        //Grille
        sNomGrille := cds_Dano_Article.FieldByName('Nom grille de taille').AsString;
        if sNomGrille = '' then
          sNomGrille := cNomMirgation;

        if SL_Grille.IndexOf( sCodeTaille + ';' +
                              cNomMirgation + ';' +
                              cNomMirgation + ';') = -1 then
        begin
          SL_Grille.Add(sCodeTaille + ';' +
                        cNomMirgation + ';' +
                        cNomMirgation + ';');
        end;

        //Ligne
        if SL_GrilleLig.IndexOf(sCodeTaille+';'+sTaille + ';') = -1 then
        begin
          SL_GrilleLig.Add(sCodeTaille + ';' +
                         sTaille + ';');
        end;

        //Code-Barre
        if SL_CodeBarre.IndexOf(sCodeModele + ';' + sTaille + ';' + sCouleur + ';' + sEAN + ';' + '0' + ';') = -1 then
        begin
          SL_CodeBarre.Add(sCodeModele + ';' +
                         sTaille + ';' +
                         sCouleur + ';' +
                         sEAN + ';' +
                         '0' + ';');
        end;

        //Prix
        if SL_Prix.IndexOf(sCodeModele+';'+sTaille+';'+sPrixCatal+';'+sPrixAchat+';'+sPrixVente+';'+sFournisseur+';'+sCouleur + ';') = -1 then
        begin
          SL_Prix.add(sCodeModele + ';' +
                    sTaille + ';' +
                    sPrixCatal + ';' +
                    sPrixAchat + ';' +
                    sPrixVente + ';' +
                    sFournisseur + ';' +
                    sCouleur + ';');
        end;

        //Stock
        if sQte <> '0' then
        begin
          if SL_StockInv.IndexOf(sCodeModele + ';;;;;;;' + sEAN+';'+sQte + ';') = -1 then
          begin
            SL_StockInv.Add(sCodeModele + ';;;;;;;' +
                            sEAN + ';' +
                            sQte + ';')
          end
          else
            SL_StockInv.Add(sCodeModele + ';XXXX;;;;;;' +
                            sEAN + ';' +
                            sQte + ';');
        end;

        PB_Dano.StepIt;
        PB_Dano.Update;

        sCodeModPrev := sCodeModele;
        cds_Dano_Article.Next;  
      end;        
        
      //Sauvegarde des différents fichiers
      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Création du fichier articles.csv ...';
      SL_Article.SaveToFile(sDirExport+'Articles.csv');

      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Création du fichier Code_barre.csv ...';
      SL_CodeBarre.SaveToFile(sDirExport+'Code_barre.csv');

      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Création du fichier Prix.csv ...';
      SL_Prix.SaveToFile(sDirExport+'Prix.csv');

      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Création du fichier stock_inventaire.csv ...';
      SL_StockInv.SaveToFile(sDirExport+'stock_inventaire.csv');

      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Création du fichier Marque.csv ...';
      SL_Marque.SaveToFile(sDirExport+'Marque.csv');

      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Création du fichier Fourn.csv ...';
      SL_Fourn.SaveToFile(sDirExport+'Fourn.csv');

      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Création du fichier Gr_Taille.csv ...';
      SL_Grille.SaveToFile(sDirExport+'Gr_Taille.csv');

      application.ProcessMessages;
      Lbl_MigrationDano_Process.Caption := 'Création du fichier Gr_Taille_Lig.csv ...';
      SL_GrilleLig.SaveToFile(sDirExport+'Gr_Taille_Lig.csv');

      FreeAndNil(SL_Article);
      FreeAndNil(SL_CodeBarre);
      FreeAndNil(SL_Prix);
      FreeAndNil(SL_StockInv);
      FreeAndNil(SL_Marque);
      FreeAndNil(SL_Fourn);
      FreeAndNil(SL_Grille);
      FreeAndNil(SL_GrilleLig);
    end;
  except on e : Exception do
    begin
      ShowMessage('Erreur lors du traitement des articles : ' + E.Message);
      Exit;
    end
  end;

  //traitement des clients
  try
    Lbl_MigrationDano_Process.Caption := 'Chargement du fichier client ...';

    cds_Dano_Client  := TClientDataSet.Create(Nil);

    //chargement du Dataset client en mémoire
    if not LoadDataSet('Fichier Client', sDirClient,'Code tiers', cds_Dano_Client) then
      Exit;

    //Ajout entête client
    SL_Client.Add('CODE;' +
                  'TYP;' +
                  'NOM_RS1;' +
                  'PREN_RS2;' +
                  'CIV;' +
                  'ADR1;' +
                  'ADR2;' +
                  'ADR3;' +
                  'CP;' +
                  'VILLE;' +
                  'PAYS;' +
                  'CODE_COMPTABLE;' +
                  'COM;' +
                  'TEL;' +
                  'FAX_TTRAV;' +
                  'PORTABLE;' +
                  'EMAIL;' +
                  'CB_NATIONAL;' +
                  'CLASS1;' +
                  'CLASS2;' +
                  'CLASS3;' +
                  'CLASS4;' +
                  'CLASS5;' +
                  'CHRONO;' +
                  'CHRONOPRO;' +
                  'DATE_NAISSANCE;' +
                  'DATE_CREATION;');

    SL_Fid.Add('CODE;' +
               'POINTS;' +
               'DATE;' +
               'FID_MANUELLE;');

    PB_Dano.Position := 0;
    PB_Dano.Max := cds_Dano_Client.RecordCount;

    cds_Dano_Client.First;
    while not cds_Dano_Client.eof do
    begin
      //parcours du fichier

      if (cds_Dano_Client.FieldByName('Jour de naissance').AsString = '0') AND
         (cds_Dano_Client.FieldByName('Mois de naissance').AsString = '0') AND
         (cds_Dano_Client.FieldByName('Année de naissance').AsString = '0') then
        sDateNaissance := ''
      else
        sDateNaissance := cds_Dano_Client.FieldByName('Jour de naissance').AsString + '/' +
                          cds_Dano_Client.FieldByName('Mois de naissance').AsString + '/' +
                          cds_Dano_Client.FieldByName('Année de naissance').AsString;

      //client
      //Clients
      SL_Client.Add(cds_Dano_Client.FieldByName('Code tiers').AsString +';'+           //CIV
                    'PART'         +';'+                                               //
                    cds_Dano_Client.FieldByName('Raison sociale').AsString +';'+       //
                    cds_Dano_Client.FieldByName('Prénom').AsString +';'+               //
                    ''     +';'+                                                       //
                    cds_Dano_Client.FieldByName('Adresse 1').AsString   +';'+          //
                    cds_Dano_Client.FieldByName('Adresse 2').AsString   +';'+          //
                    cds_Dano_Client.FieldByName('Adresse 3').AsString   +';'+          //
                    cds_Dano_Client.FieldByName('Code postal').AsString +';'+          //
                    cds_Dano_Client.FieldByName('Ville').AsString       +';'+          //
                    '' +';'+                                                           //PAYS
                    '' +';'+                                                           //CODE COMPTABLE
                    '' +';'+                                                           //COMMENTAIRE
                    cds_Dano_Client.FieldByName('Téléphone n°1').AsString +';'+        //
                    cds_Dano_Client.FieldByName('Téléphone n°2').AsString +';'+        //
                    cds_Dano_Client.FieldByName('Téléphone n°3').AsString +';'+        //
                    cds_Dano_Client.FieldByName('Adresse messagerie').AsString +';'+   //
                    cds_Dano_Client.FieldByName('Numéro carte interne').AsString +';'+ //
                    ''  +';'+                                                          // CLASS1
                    ''  +';'+                                                          // CLASS2
                    ''  +';'+                                                          // CLASS3
                    ''  +';'+                                                          // CLASS4
                    ''  +';'+                                                          // CLASS5
                    ''  +';'+                                                          // CHRONO
                    ''  +';'+                                                          //
                    sDateNaissance + ';' +                                             //Date de naissance
                    cds_Dano_Client.FieldByName('Date ouverture fidélité').AsString + ';');


      //Comptes
      //Vide - pas utilisé

      if cds_Dano_Client.FieldByName('Nb points').AsString <> '' then
      begin
        if TryStrToInt(cds_Dano_Client.FieldByName('Nb points').AsString, nbPoint) then
          nbPoint := cds_Dano_Client.FieldByName('Nb points').AsInteger
        else
        begin
          sLogDano.Add('Fidélité : '+ cds_Dano_Client.FieldByName('Code tiers').AsString +' -> Nb de point : ' + cds_Dano_Client.FieldByName('Nb points').AsString);
          nbPoint := 0;
        end;
      end
      else
        nbPoint := 0;

      //Fidélité
      if SL_Fid.IndexOf(cds_Dano_Client.FieldByName('Code tiers').AsString + ';' +
                   IntToStr(nbPoint) + ';' +
                   datetostr(date()) + ';' +
                   '1' + ';') = -1 then
      begin
        SL_Fid.Add(cds_Dano_Client.FieldByName('Code tiers').AsString + ';' +
                 IntToStr(nbPoint) + ';' +
                 datetostr(date()) + ';' +
                 '1' + ';');
      end;


      PB_Dano.StepIt;
      PB_Dano.Update;

      cds_Dano_Client.next;
    end;


    //Sauvegarde partie client
    Application.ProcessMessages;
    Lbl_MigrationDano_Process.Caption := 'Création du fichier Clients.csv ...';
    SL_Client.SaveToFile(sDirExport+'Clients.csv');

    Application.ProcessMessages;
    Lbl_MigrationDano_Process.Caption := 'Création du fichier Fidelite.csv ...';
    SL_Fid.SaveToFile(sDirExport+'Fidelite.csv');

    sLogDano.SaveToFile('Logs.csv');

    FreeAndNil(SL_Client);
    FreeAndNil(SL_Fid);
    FreeAndNil(cds_Dano_Article);
    FreeAndNil(cds_Dano_Client);
    FreeAndNil(sLogDano);

    Lbl_MigrationDano_Process.Caption := '';
    ShowMessage('Traitement terminé');
    PB_Dano.Position := 0;
  except on e : Exception do
    begin
      sLogDano.Add('Erreur lors du traitement du fichier client : ' + E.Message);
      Exit;
    end
  end;

end;

procedure TFrm_Main.btn_PA_ExecClick(Sender: TObject);
var
  lListPrixAchat: TStringList;
  lListPrixAchatSep: TStringList;
  iList: integer;
  lCsv: TExportHeaderOL;

  sFilePath : string;
  cdsPrixAchat : TClientDataSet;
  slTmp : TStringList;

  procedure AddData;
  begin
    cds_PrixAchatFinal.Append;
    cds_PrixAchatFinal.FieldByName('ID').AsString := cds_PrixAchat.FieldByName('ID').AsString;
    cds_PrixAchatFinal.FieldByName('TAILLE').AsString := cds_PrixAchat.FieldByName('TAILLE').AsString;
    cds_PrixAchatFinal.FieldByName('COULEUR').AsString := cds_PrixAchat.FieldByName('COULEUR').AsString;
    cds_PrixAchatFinal.FieldByName('X1').AsString := cds_PrixAchat.FieldByName('X1').AsString;
    cds_PrixAchatFinal.FieldByName('X2').AsString := cds_PrixAchat.FieldByName('X2').AsString;
    cds_PrixAchatFinal.FieldByName('X3').AsString := cds_PrixAchat.FieldByName('X3').AsString;
    cds_PrixAchatFinal.FieldByName('X4').AsString := cds_PrixAchat.FieldByName('X4').AsString;
    cds_PrixAchatFinal.FieldByName('PXBASE').AsString := cds_PrixAchat.FieldByName('PXBASE').AsString;
    cds_PrixAchatFinal.Post;
  end;
begin
  try
    bed_PA_PrixAchat.Enabled := false;
    btn_PA_Exec.Enabled := false;

    lListPrixAchat := TStringList.Create;
    lListPrixAchat.LoadFromFile(bed_PA_PrixAchat.Text);
    lListPrixAchatSep := TStringList.Create;
    lListPrixAchatSep.StrictDelimiter := true;
    lListPrixAchatSep.Delimiter := ';';

    (*lDSPrixAchat.FieldDefs.Add('ID',ftString);
    lDSPrixAchat.FieldDefs.Add('TAILLE',ftString);
    lDSPrixAchat.FieldDefs.Add('COULEUR',ftString);
    lDSPrixAchat.FieldDefs.Add('X1',ftString);
    lDSPrixAchat.FieldDefs.Add('X2',ftString);
    lDSPrixAchat.FieldDefs.Add('X3',ftString);
    lDSPrixAchat.FieldDefs.Add('X4',ftString);
    lDSPrixAchat.FieldDefs.Add('PXBASE',ftString); *)

    for iList := 0 to lListPrixAchat.Count -1 do
    begin
      lListPrixAchatSep.DelimitedText := lListPrixAchat[iList];
      cds_PrixAchat.Append;
      cds_PrixAchat.FieldByName('ID').AsString := lListPrixAchatSep[0];
      cds_PrixAchat.FieldByName('TAILLE').AsString := lListPrixAchatSep[1];
      cds_PrixAchat.FieldByName('COULEUR').AsString := lListPrixAchatSep[2];
      cds_PrixAchat.FieldByName('X1').AsString := lListPrixAchatSep[3];
      cds_PrixAchat.FieldByName('X2').AsString := lListPrixAchatSep[4];
      cds_PrixAchat.FieldByName('X3').AsString := lListPrixAchatSep[5];
      cds_PrixAchat.FieldByName('X4').AsString := lListPrixAchatSep[6];
      cds_PrixAchat.FieldByName('PXBASE').AsString := lListPrixAchatSep[7];
      cds_PrixAchat.Post;
    end;
    cds_PrixAchat.First;
    while not cds_PrixAchat.Eof do
    //for iList := 0 to cds_PrixAchat.RecordCount -1 do
    begin
      if (cds_PrixAchat.FieldByName('PXBASE').AsString = '1')
          AND (cds_PrixAchat.FieldByName('TAILLE').AsString <> '0')
          AND (cds_PrixAchat.FieldByName('COULEUR').AsString <> '0') then
      begin
        cds_PrixAchat.Edit;
        cds_PrixAchat.FieldByName('PXBASE').AsString := '0';
        cds_PrixAchat.Post;
        //on ajoute la ligne avec PXBASE à 0
        AddData;
        //on passe la taille/couleur à 0 pour le prix de base
        cds_PrixAchat.Edit;
        cds_PrixAchat.FieldByName('TAILLE').AsString := '0';
        cds_PrixAchat.FieldByName('COULEUR').AsString := '0';
        cds_PrixAchat.FieldByName('PXBASE').AsString := '1';
        cds_PrixAchat.Post;
        //si la ligne n'est pas déja présente
        if cds_PrixAchatFinal.RecordCount = 0 then
        begin
          AddData;
        end;
      end
      else
        //si pas le prix de base on fait une simple copie
        AddData;
      pb_PA.Position := ((cds_PrixAchat.RecNo+1)*100) div cds_PrixAchat.RecordCount;
      Application.ProcessMessages;
      cds_PrixAchat.Next;
    end;

    //on libère le CDS pour l'enregistrement
    cds_PrixAchatFinal.MasterSource := nil;
    cds_PrixAchatFinal.MasterFields := '';
    cds_PrixAchatFinal.first;

    lCsv := TExportHeaderOL.Create;
    lCsv.Add('ID');
    lCsv.Add('TAILLE');
    lCsv.Add('COULEUR');
    lCsv.Add('X1');
    lCsv.Add('X2');
    lCsv.Add('X3');
    lCsv.Add('X4');
    lCsv.Add('PXBASE');
    lCsv.Separator := ';';
    lCsv.bWriteHeader := False;
    lCsv.ConvertToCsv(cds_PrixAchatFinal,bed_PA_PrixAchat.Text);

  finally
    pb_PA.Position := 0;
    //bed_PA_PrixAchat.Enabled := true;
    //btn_PA_Exec.Enabled := true;
    lbl_PA_Quit.Visible := true;

    lListPrixAchat.Free;
    lListPrixAchatSep.Free;
    lCsv.Free;
  end;

  //Chemin
  sFilePath := bed_PA_PrixAchat.Text;

  slTmp := TStringList.Create;
  try
    slTmp.Clear;
    slTmp.LoadFromFile(sFilePath);   //Chargement du fichier
    slTmp.Insert(0,'CODE_ART;CODE_TAILLE;CODE_COUL;CODE_FOU;PXCATALOGUE;PX_ACHAT;FOU_PRINCIPAL;PXDEBASE');     //Ajout de l'en-tête
    slTmp.SaveToFile(sFilePath);     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsPrixAchat := TClientDataSet.Create(nil);
  slTmp := TStringList.Create;
  try
    LoadDataSet('Prix d''Achat',
                sFilePath,
                'CODE_ART;CODE_TAILLE;CODE_COUL;CODE_FOU;PXDEBASE', cdsPrixAchat);

    cdsPrixAchat.First;
    while not cdsPrixAchat.Eof do
    begin
      if ((cdsPrixAchat.FieldByName('PXCATALOGUE').AsString = '') or (cdsPrixAchat.FieldByName('PXCATALOGUE').AsString = '0')) then
      begin
        slTmp.Add(cdsPrixAchat.FieldByName('CODE_ART').AsString + ';' +         //CODE_ART
                  cdsPrixAchat.FieldByName('CODE_TAILLE').AsString + ';' +      //CODE_TAILLE
                  cdsPrixAchat.FieldByName('CODE_COUL').AsString + ';' +        //CODE_COUL
                  cdsPrixAchat.FieldByName('CODE_FOU').AsString + ';' +         //CODE_FOU
                  cdsPrixAchat.FieldByName('PX_ACHAT').AsString + ';' +         //PXCATALOGUE
                  cdsPrixAchat.FieldByName('PX_ACHAT').AsString + ';' +         //PX_ACHAT
                  cdsPrixAchat.FieldByName('FOU_PRINCIPAL').AsString + ';' +    //FOU_PRINCIPAL
                  cdsPrixAchat.FieldByName('PXDEBASE').AsString + ';');         //PXDEBASE
      end
      else
      begin
        slTmp.Add(cdsPrixAchat.FieldByName('CODE_ART').AsString + ';' +         //CODE_ART
                  cdsPrixAchat.FieldByName('CODE_TAILLE').AsString + ';' +      //CODE_TAILLE
                  cdsPrixAchat.FieldByName('CODE_COUL').AsString + ';' +        //CODE_COUL
                  cdsPrixAchat.FieldByName('CODE_FOU').AsString + ';' +         //CODE_FOU
                  cdsPrixAchat.FieldByName('PXCATALOGUE').AsString + ';' +         //PXCATALOGUE
                  cdsPrixAchat.FieldByName('PX_ACHAT').AsString + ';' +         //PX_ACHAT
                  cdsPrixAchat.FieldByName('FOU_PRINCIPAL').AsString + ';' +    //FOU_PRINCIPAL
                  cdsPrixAchat.FieldByName('PXDEBASE').AsString + ';');         //PXDEBASE
      end;
      cdsPrixAchat.Next;
    end;
  finally
    if FileExists(sFilePath) then
      DeleteFile(sFilePath);

    slTmp.SaveToFile(sFilePath);

    FreeAndNil(slTmp);
  end;
  //-----------------------------------
  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.btn_SupMagClick(Sender: TObject);
var
  i : Integer;
begin
  i := 0;
  while (i <= Lbx_CodeMag.Count - 1)  do
  begin
    if Lbx_CodeMag.Selected[i] then
      Lbx_CodeMag.Items.Delete(i);
    Inc(i);
  end;

end;

procedure TFrm_Main.Btn_SupprimerFEDASClick(Sender: TObject);
var
  sFile : string;
  cdsArticle : TClientDataSet;
  slTmp : TStringList;
  slTmp2 : TStringList;
  sTVA : string;
begin
  //Chemin
  sFile := Bed_PathFile_FEDAS_POST_ISF_Origine.Text;

  slTmp := TStringList.Create;
  try
    //Fichier Origine
    slTmp.Clear;
    slTmp.LoadFromFile(sFile);   //Chargement du fichier
    slTmp.Insert(0,'CODE;CODE_MRQ;CODE_GT;CODE_FOURN;NOM;CODEIS;CODEFEDAS;DESCRIPTION;CLASS1;CLASS2;CLASS3;CLASS4;CLASS5;CLASS6;FIDELITE;DATECREATION;COMENT1;COMENT2;TVA;PSEUDO;ARCHIVER;CODE_GENRE;CODE_DOMAINE;CENTRALE;TYPECOMPTABLE;FLAGMODELE;STKIDEAL');     //Ajout de l'en-tête
    slTmp.SaveToFile(sFile);     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsArticle := TClientDataSet.Create(nil);
  slTmp := TStringList.Create;
  //slTmp2 := TStringList.Create;
  try
    LoadDataSet('Article',
                sFile,
                'CODE', cdsArticle);

    cdsArticle.First;
    while not cdsArticle.Eof do
    begin
      sTVA := cdsArticle.FieldByName('TVA').AsString;
      if sTVA = '' then
        sTVA := '20';

      slTmp.Add(cdsArticle.FieldByName('CODE').AsString + ';' +           //CODE
                cdsArticle.FieldByName('CODE_MRQ').AsString + ';' +       //CODE_MRQ
                cdsArticle.FieldByName('CODE_GT').AsString + ';' +        //CODE_GT
                cdsArticle.FieldByName('CODE_FOURN').AsString + ';' +     //CODE_FOURN
                cdsArticle.FieldByName('NOM').AsString + ';' +            //NOM
                cdsArticle.FieldByName('CODEIS').AsString + ';' +         //CODEIS
                Ed_FEDAS_REMPLACEMENT.Text + ';' +                        //CODEFEDAS
                cdsArticle.FieldByName('DESCRIPTION').AsString + ';' +    //DESCRIPTION
                cdsArticle.FieldByName('CLASS1').AsString + ';' +         //CLASS1
                cdsArticle.FieldByName('CLASS2').AsString + ';' +         //CLASS2
                cdsArticle.FieldByName('CLASS3').AsString + ';' +         //CLASS3
                cdsArticle.FieldByName('CLASS4').AsString + ';' +         //CLASS4
                cdsArticle.FieldByName('CLASS5').AsString + ';' +         //CLASS5
                cdsArticle.FieldByName('CLASS6').AsString + ';' +         //CLASS6
                cdsArticle.FieldByName('FIDELITE').AsString + ';' +       //FIDELITE
                cdsArticle.FieldByName('DATECREATION').AsString + ';' +   //DATECREATION
                cdsArticle.FieldByName('COMENT1').AsString + ';' +        //COMENT1
                cdsArticle.FieldByName('COMENT2').AsString + ';' +        //COMENT2
                sTVA + ';' +            //TVA
                cdsArticle.FieldByName('PSEUDO').AsString + ';' +         //PSEUDO
                cdsArticle.FieldByName('ARCHIVER').AsString + ';' +       //ARCHIVER
                cdsArticle.FieldByName('CODE_GENRE').AsString + ';' +     //CODE_GENRE
                cdsArticle.FieldByName('CODE_DOMAINE').AsString + ';' +   //CODE_DOMAINE
                cdsArticle.FieldByName('CENTRALE').AsString + ';' +       //CENTRALE
                cdsArticle.FieldByName('TYPECOMPTABLE').AsString + ';' +  //TYPECOMPTABLE
                cdsArticle.FieldByName('FLAGMODELE').AsString + ';' +     //FLAGMODELE
                cdsArticle.FieldByName('STKIDEAL').AsString + ';');       //STKIDEAL

//      slTmp2.Add( cdsArticle.FieldByName('CODE').AsString + ';' +           //CODE
//                  cdsArticle.FieldByName('AXE4').AsString + ';' +           //AXENIVEAU4
//                  cdsArticle.FieldByName('AXE1').AsString + ';');           //AXENIVEAU1

      cdsArticle.Next;
    end;
  finally
    slTmp.SaveToFile(sFile + '2.csv');
    //slTmp2.SaveToFile(sFile + '_AXE.csv');

    FreeAndNil(slTmp);
    //FreeAndNil(slTmp2);
    FreeAndNil(cdsArticle);
  end;
  //-----------------------------------
  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.btn_traitementClick(Sender: TObject);
var
  sPath : string;
  cdsClient,
  cdsCompte : TClientDataSet;
  cdsKeep,
  Tmp_SL  : TStringList;

  function GetHeader(aTab:array of string):string;

  var
    i : Integer;
  begin
    Result := '';
    for i := 0 to Length(aTab) - 1 do
      if Result = '' then
        Result := aTab[i]
      else
        Result := Result + ';' + aTab[i];
  end;
begin
  //Partie Traitement des fichiers
  sPath := Bed_PathFile_Fid.Text + '\';

  //Création des dossiers
  if not System.SysUtils.DirectoryExists(sPath + 'Fidélité') then
    CreateDir(sPath + 'Fidélité');

  cdsClient := TClientDataSet.Create(nil);
  cdsCompte := TClientDataSet.Create(nil);
  cdsKeep   := TStringList.Create;
  try
    //Client
    Lbl_Etat_Fid.Caption := 'Traitement : Chargement des clients';
    Application.ProcessMessages;
    if FileExists(sPath + Clients_CSV) then
    begin
      Tmp_SL := TStringList.Create;
      try
        Tmp_SL.LoadFromFile(sPath + Clients_CSV);      //Chargement du fichier
        Tmp_SL.Insert(0,GetHeader(Clients_COL));          //Ajout de l'en-tête
        Tmp_SL.SaveToFile(sPath + Clients_CSV);        //Enregistrement du fichier
      finally
      FreeAndNil(Tmp_SL);
      end;
      LoadDataSet('Clients', sPath + Clients_CSV, 'CODE',cdsClient);
    end;

    //Comptes
    Lbl_Etat_Fid.Caption := 'Traitement : Chargement des comptes';
    Application.ProcessMessages;
    if FileExists(sPath + Comptes_CSV) then
    begin
      Tmp_SL := TStringList.Create;
      try
        Tmp_SL.LoadFromFile(sPath + Comptes_CSV);      //Chargement du fichier
        Tmp_SL.Insert(0,GetHeader(Comptes_COL));          //Ajout de l'en-tête
        Tmp_SL.SaveToFile(sPath + Comptes_CSV);        //Enregistrement du fichier
      finally
      FreeAndNil(Tmp_SL);
      end;
      LoadDataSet('Comptes', sPath + Comptes_CSV, 'CODE',cdsCompte);
    end;

    cdsCompte.First;
    while not cdsCompte.Eof do
    begin
      if cdsClient.Locate('CODE',cdsCompte.FieldByName('CODE').AsString,[]) then
      begin
        cdsKeep.Add(cdsCompte.FieldByName('CODE').AsString + ';' +
                    cdsCompte.FieldByName('LIBELLE').AsString + ';' +
                    cdsCompte.FieldByName('DATE').AsString + ';' +
                    cdsCompte.FieldByName('CREDIT').AsString + ';' +
                    cdsCompte.FieldByName('DEBIT').AsString + ';' +
                    cdsCompte.FieldByName('LETTRAGE').AsString + ';' +
                    cdsCompte.FieldByName('LETNUM').AsString + ';' +
                    cdsClient.FieldByName('CODE_MAG').AsString + ';' +
                    cdsCompte.FieldByName('ORIGINE').AsString + ';');
      end;
      cdsCompte.Next;
    end;
    cdsKeep.SaveToFile(sPath + 'Fidélité\' + Comptes_CSV);
  finally
    FreeAndNil(cdsClient);
    FreeAndNil(cdsCompte);
    FreeAndNil(cdsKeep);
  end;

  lbl_Etat_Fid.Caption := 'Traitement :';
  Application.ProcessMessages;
  ShowMessage('Traitement terminé.');
end;

function TFrm_Main.LoadDataSet(aMsg, aPathFile, aCle: string;
  aCDS: TclientDataSet):Boolean;
begin
  try
    if FileExists(aPathFile) then
    begin
      CSV_To_ClientDataSet(aPathFile,aCDS,aCle);
      Result := True
    end
    else
    begin
      Result := False;
    end;
  except
    on E:Exception do
    begin
      Result := False;
    end;
  end;
end;

procedure TFrm_Main.MigrationDano_RechercheClient(DirArticle: String);
var
  OldDir       : String;
  SearchClient : TSearchRec;
begin
  OldDir     := '';

  if DirArticle <> '' then
  begin
    if DirArticle[DirArticle.Length] <> '\' then
      DirArticle := IncludeTrailingPathDelimiter(DirArticle);

    if FindFirst(DirArticle + '*csv.*', faAnyFile, SearchClient) = 0 then
    begin
      repeat
        Application.ProcessMessages;
        if (String(SearchClient.Name).Contains('client')) then
          Bed_MigrationDano_PatchClient.Text := DirArticle + SearchClient.Name;
      until FindNext(SearchClient) <> 0;
    end
  end
end;

procedure TFrm_Main.MigrationLaignel_Log(const Text: string;
  const State: TStepState);
var
  DateTimeStr: string;
begin
  DateTimeToString(DateTimeStr,'hh:nn:ss(zzz)', Now);

  RE_MigrationLaignel_Log.Lines.BeginUpdate;
  try
    RE_MigrationLaignel_Log.SelAttributes.Style := [];
    RE_MigrationLaignel_Log.SelText := DateTimeStr;

    RE_MigrationLaignel_Log.SelAttributes.Style := [];
    RE_MigrationLaignel_Log.SelText := #9;
    case State of
      stateNormal: RE_MigrationLaignel_Log.SelAttributes.Color := clWindowText;
      stateError: RE_MigrationLaignel_Log.SelAttributes.Color := clRed;
      stateWarning: RE_MigrationLaignel_Log.SelAttributes.Color := $0167E5;
    end;
    RE_MigrationLaignel_Log.SelText := Text + #13#10;

  //  RE_MigrationLaignel_Log.Lines.Add(Format('%s : %s', [DateTimeStr, Text]));
    SendMessage(RE_MigrationLaignel_Log.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  finally
    RE_MigrationLaignel_Log.Lines.EndUpdate;
  end;
end;

procedure TFrm_Main.MigrationLaignel_OnStep(const Text: string;
  const State: TStepState; const Style: TStepStyle; const Index, Count: Integer);
begin
  MigrationLaignel_Log(Text, State);
  Lbl_MigrationLaignel_Process.Caption := Text;
  Pb_MigrationLaignel_Process.Max := Count;
  Pb_MigrationLaignel_Process.Position := Index;
  Pb_MigrationLaignel_Process.State := TProgressBarState(Ord(State));
  Pb_MigrationLaignel_Process.Style :=  TProgressBarStyle(Ord(Style));
end;

procedure TFrm_Main.MigrationLaignel_OnTerminate(const ErrorsCount: Integer);
begin
  try
    RE_MigrationLaignel_Log.PlainText := True;
    RE_MigrationLaignel_Log.Lines.SaveToFile(
      ThreadMigrationLaignel.OutputDirectory
      + ChangeFileExt(ExtractFileName(Application.ExeName), '.log')
    );
  except
  end;
  ThreadMigrationLaignel := nil;
end;

procedure TFrm_Main.ProcLockingFile(const Proc: TProc< TFileStream>;
  const Filename: String; const Mode: Word);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create( Filename, Mode );
  try
    Proc( FileStream );
  finally
    FileStream.Free;
  end;
end;

procedure TFrm_Main.ProcLockingFile(const Proc: TProc<TFileStream, TFileStream>;
  const Filename, TemporaryFilename: String; const Replace: Boolean; const Mode, TemporaryMode: Word);
var
  Filestream, TemporaryFilestream: TFileStream;
begin
  try
    Filestream := TFileStream.Create( Filename, Mode, 0 );
    TemporaryFilestream := TFileStream.Create( TemporaryFilename, TemporaryMode, 0 );
    try
      Proc( Filestream, TemporaryFilestream );
    finally
      TemporaryFilestream.Free;
      Filestream.Free;
    end;
    if Replace and ( not MoveFileEx( PWideChar( TemporaryFilename ), PWideChar( Filename ), MOVEFILE_REPLACE_EXISTING or MOVEFILE_WRITE_THROUGH ) ) then
      RaiseLastOSError;
  except
    raise
  end;
end;

procedure TFrm_Main.RegExCleanerEvaluate(Sender: TObject);
begin
  try
    Ed_SampleKeyCleaner.Text := '';
    Ed_SampleValueCleaner.Text := '';
    with TRegEx.Match( Ed_SampleTextCleaner.Text, GetRegexCleaner, [] ) do begin
      if not Success then
        exit;
      Ed_SampleKeyCleaner.Text := Groups[ 1 ].Value;
      Ed_SampleValueCleaner.Text := Groups[ 2 ].Value;
    end;
  except
  end
end;

procedure TFrm_Main.RegExCleanerValidate(Sender: TObject);
begin
  Gb_SampleCleaner.Hide;
  Lbl_RegexCleanerError.Hide;
  Btn_Cleaner.Enabled := False;
  try
    TRegEx.IsMatch( '', GetRegexCleaner, [] );
    RegExCleanerEvaluate( nil );
    Gb_SampleCleaner.Show;
    Btn_Cleaner.Enabled := True;
  except
    on E: ERegularExpressionError do begin
      Lbl_RegexCleanerError.Caption := E.Message;
      Lbl_RegexCleanerError.Show;
    end;
    on E: Exception do
      ShowMessage( E.Message );
  end;
end;

function TFrm_Main.GetCommonEANLength: Integer;
var
  IBQuery: TFDQuery;
begin
  try
    IBQuery := TFDQuery.Create( nil );
    try
      IBQuery.Connection := Base;
      {$REGION 'Vérification de la longueur générale des EANS'}
      IBQuery.SQL.Add( 'select distinct f_stringlength( ARA_CODEART )' );
      IBQuery.SQL.Add( 'from ARTRELATIONART' );
      IBQuery.SQL.Add( 'where ARA_ID != 0;' );
      IBQuery.Open;
      Exit( StrToIntDef( IBQuery.Fields[0].AsString, -1 ) );
      IBQuery.Close;
      {$ENDREGION}
    finally
      IBQuery.Free;
    end;
  except
    Exit( -2 );
  end
end;

function TFrm_Main.GetHeader(aTab: array of string): string;
var
  i : Integer;
begin
  Result := '';
  for i := 0 to Length(aTab) - 1 do
    if Result = '' then
      Result := aTab[i]
    else
      Result := Result + ';' + aTab[i];
end;

function TFrm_Main.CountFilesInFolder(path: string): integer;
var
  tsr: TSearchRec;
begin
  path := IncludeTrailingPathDelimiter ( path );
  result := 0;
  if FindFirst ( path + '*.*', faAnyFile and not faDirectory, tsr ) = 0 then begin
    repeat
      inc ( result );
    until FindNext ( tsr ) <> 0;
    FindClose ( tsr );
  end;
end;

procedure TFrm_Main.CoupeFile(aFile: string;iNbLignes:Integer);
var
  Nb_Ligne : Integer;

  i: Integer;
  sLigne: string;
  sLire: String;
  Stream: TFileStream;
  StrStream: TStringStream;
  SizeLu: Int64;
  SizeALire: Int64;
  TailleMax: Int64;

  procedure TraitementDeLaLigne(ALigne: string;ANbLigne: Integer);
  begin
    if Nb_Ligne < ANbLigne then
    begin
      List_Tmp.Add(ALigne);
      Inc(Nb_Ligne);
    end
    else
    begin
      List_Tmp.SaveToFile(ExtractFilePath(sFile) +
                          ChangeFileExt(ExtractFileName(sFile),'') + IntToStr(iNumFichier) +
                          ExtractFileExt(sFile));
      List_Tmp.Clear;
      Inc(iNumFichier);
      List_Tmp.Add(ALigne);
      Nb_Ligne := 1;
    end;
  end;

begin
  sFile := aFile;
  if aFile='' then
    exit;

  try
    //On vide la string list et initialise le nb de ligne à zéro
    Nb_Ligne := 0;
    iNumFichier := 0;
    List_Tmp.Clear;

    sLire := '';
    TailleMax := 1024;
    Stream := TFileStream.Create(sFile, fmOpenRead);
    StrStream := TStringStream.Create('');
    try
      i := 0;
      Stream.Seek(0, soFromBeginning);
      if Stream.Size-Stream.Position>TailleMax then
        SizeALire := TailleMax
      else
        SizeALire := Stream.Size-Stream.Position;
      Sizelu := StrStream.CopyFrom(Stream, SizeALire);
      sLire := StrStream.DataString;
      while (Sizelu=TailleMax) do
      begin
        while Pos(#13#10, sLire)>0 do
        begin
          inc(i);
          sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
          sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
          // traitement de la ligne
          if ((i>1) and (Cb_Entete.Checked)) or ((i>=1) and (Cb_Entete.Checked = False))  then
          begin
            TraitementDeLaLigne(sLigne, iNbLignes);
          end;

        end;
        if Stream.Size-Stream.Position>TailleMax then
          SizeALire := TailleMax
        else
          SizeALire := Stream.Size-Stream.Position;

        StrStream.Clear;
        Sizelu := StrStream.CopyFrom(Stream, SizeALire);
        sLire := sLire+StrStream.DataString;
      end;
      if sLire<>'' then
      begin
        while Pos(#13#10, sLire)>0 do
        begin
          inc(i);
          sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
          sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
          // traitement de la ligne
          if i>1 then
          begin
            TraitementDeLaLigne(sLigne, iNbLignes);
          end;
        end;
        if sLire<>'' then
        begin
          inc(i);
          sLigne := sLire;
          // traitement de la ligne
          if i>1 then
          begin
            TraitementDeLaLigne(sLigne, iNbLignes);
          end;
        end;
      end;
    finally
      FreeAndNil(Stream);
      FreeAndNil(StrStream);
    end;
  finally
    List_Tmp.SaveToFile(ExtractFilePath(sFile) +
                        ChangeFileExt(ExtractFileName(sFile),'') + IntToStr(iNumFichier) +
                        ExtractFileExt(sFile));
    List_Tmp.Clear;

    RenameFile( aFile,
                ExtractFilePath(aFile) +
                ChangeFileExt(ExtractFileName(aFile),'') + '-Init' + ExtractFileExt(aFile));

    RenameFile( ExtractFilePath(aFile) +
                ChangeFileExt(ExtractFileName(aFile),'') + '0' + ExtractFileExt(aFile),
                ExtractFilePath(aFile) +
                ChangeFileExt(ExtractFileName(aFile),'') + ExtractFileExt(aFile));
  end;
end;

procedure TFrm_Main.Csv_Add_Ligne(Fichier, Texte: String);
Var
  FileCsv       : TextFile;   //Variable d'accès au fichier
  ChemCsv       : String;     //Chemin du fichier csv
  FileCsvName   : String;     //Nom du fichier de csv
Begin
  ChemCsv       := IncludeTrailingPathDelimiter(ExtractFilePath(Fichier));
  FileCsvName   := Fichier;
  ForceDirectories(ChemCsv);
  AssignFile(FileCsv,FileCsvName);
  if Not FileExists(FileCsvName) then
    ReWrite(FileCsv)
  else
    Append(FileCsv);
  try
    Writeln(FileCsv,Texte);
  finally
    CloseFile(FileCsv);
  end;
End;

Procedure TFrm_Main.CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String;
  const Delimiter: Char);
//Transfert le contenu du CSV dans un clientdataset en prenant la ligne d'entête pour la création des champs
Var
  Donnees	  : TStringList;    //Charge le fichier csv
  InfoLigne : TStringList;    //Découpe la ligne en cours de traitement
  I,J       : Integer;        //Variable de boucle
  Chaine    : String;         //Variable de traitement des lignes
Begin
  try
    //Création des variables
    Donnees   := TStringList.Create;
    InfoLigne := TStringList.Create;

    //Chargement du csv
    Donnees.LoadFromFile(FichCsv);

    //Initialisation de variable
    NbLigne   := Donnees.Count;
    Compteur  := 0;

    //Traitement de la ligne d'entête
    InfoLigne.Clear;
    InfoLigne.Delimiter := Delimiter;
    InfoLigne.StrictDelimiter := True;
    InfoLigne.DelimitedText := Donnees.Strings[0];
    for I := 0 to InfoLigne.Count - 1 do
      Begin
        CDS.FieldDefs.Add(Trim(InfoLigne.Strings[I]),ftString,255);
      End;
    CDS.CreateDataSet;
    //CDS.AddIndex('idx', Index, []);

    //Traitement des lignes de données
    CDS.Open;

    for I := 1 to Donnees.Count - 1 do
      begin
        InfoLigne.Clear;
        InfoLigne.Delimiter := Delimiter;
        InfoLigne.QuoteChar := '''';
        Chaine  := LeftStr(QuotedStr(Donnees.Strings[I]),length(QuotedStr(Donnees.Strings[I]))-1);
        Chaine  := ReplaceStr( Chaine, Delimiter, '''' + Delimiter + '''' );  
        Chaine  := Chaine + '''';

        InfoLigne.DelimitedText := Chaine;
        CDS.Append;
        for J := 0 to CDS.FieldCount - 1 do
          Begin
            CDS.Fields[J].AsString  := InfoLigne.Strings[J];
          End;
        CDS.Post;
        Inc(Compteur);
      end;
    //CDS.Close;

    CDS.AddIndex('idx', Index, []);
    CDS.IndexName := 'idx';

    //Suppression des variables en mémoire
    Donnees.free;
    InfoLigne.Free;
  except
    on E:Exception do
    begin
      Exit;
    end;
  end;
End;

procedure TFrm_Main.DictionaryToFileStream(const Thread: TThread;
  const Dictionary: TDictionary<String,Variant>; const FileStream: TFileStream);
var
  StreamWriter: TStreamWriter;
  Key: String;
begin
  StreamWriter := TStreamWriter.Create( FileStream );
  try
    Pb_Cleaner.Min := 0;
    Pb_Cleaner.Max := Dictionary.Count;
    Pb_Cleaner.Position := 0;
    for Key in Dictionary.Keys do begin

      if Thread.CheckTerminated then
        raise EAbort.Create( 'Aborted' );
      StreamWriter.WriteLine( Format( '%s%s%s%s', [ Key, Ed_RegexDelimiter.Text, Dictionary[ Key ], Ed_RegexDelimiterEOL.Text ] ) );
      Pb_Cleaner.Position := Pb_Cleaner.Position + 1;
    end;
  finally
    StreamWriter.Free;
  end;
end;

procedure TFrm_Main.Ed_CodeAdhKeyPress(Sender: TObject; var Key: Char);
begin
  If not CharInSet(key, ['1','2','3','4','5','6','7','8','9','0','/']) then
    key := #0;
end;

procedure TFrm_Main.Ed_NbLigneKeyPress(Sender: TObject; var Key: Char);
begin
  If not CharInSet(key, ['1','2','3','4','5','6','7','8','9','0']) then
    key := #0;
end;

procedure TFrm_Main.Btn_TraitementFDAS_PostISFClick(Sender: TObject);
var
  sFileOrigine : string;
  sFileDest : string;
  sCode_Article : string;
  bLocate : Boolean;

  cdsArticleOrigine : TClientDataSet;
  cdsArticleDest : TClientDataSet;
  slTmp : TStringList;
  slLog : TStringList;
begin
  //Chemin
  sFileOrigine := Bed_PathFile_FEDAS_POST_ISF_Origine.Text;
  sFileDest := Bed_PathFile_FEDAS_POST_ISF_Dest.Text;

  slTmp := TStringList.Create;
  try
    //Fichier Origine
    slTmp.Clear;
    slTmp.LoadFromFile(sFileOrigine);   //Chargement du fichier
    slTmp.Insert(0,'CODE;CODE_MRQ;CODE_GT;CODE_FOURN;NOM;CODEIS;CODEFEDAS;DESCRIPTION;CLASS1;CLASS2;CLASS3;CLASS4;CLASS5;CLASS6;FIDELITE;DATECREATION;COMENT1;COMENT2;TVA;PSEUDO;ARCHIVER;CODE_GENRE;CODE_DOMAINE;CENTRALE;TYPECOMPTABLE;FLAGMODELE;STKIDEAL');     //Ajout de l'en-tête
    slTmp.SaveToFile(sFileOrigine);     //Enregistrement du fichier

    //Fichier destination
    slTmp.Clear;
    slTmp.LoadFromFile(sFileDest);   //Chargement du fichier
    slTmp.Insert(0,'CODE;CODE_MRQ;CODE_GT;CODE_FOURN;NOM;CODEIS;CODEFEDAS;DESCRIPTION;CLASS1;CLASS2;CLASS3;CLASS4;CLASS5;CLASS6;FIDELITE;DATECREATION;COMENT1;COMENT2;TVA;PSEUDO;ARCHIVER;CODE_GENRE;CODE_DOMAINE;CENTRALE;TYPECOMPTABLE;FLAGMODELE;STKIDEAL');     //Ajout de l'en-tête
    slTmp.SaveToFile(sFileDest);     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsArticleOrigine := TClientDataSet.Create(nil);
  cdsArticleDest := TClientDataSet.Create(nil);
  slTmp := TStringList.Create;
  slLog := TStringList.Create;
  try
    LoadDataSet('Article Origine',
                sFileOrigine,
                'CODE', cdsArticleOrigine);

    LoadDataSet('Article Dest',
                sFileDest,
                'CODE', cdsArticleDest);

    cdsArticleDest.First;
    bLocate := False;
    while not cdsArticleDest.Eof do
    begin
      sCode_Article := cdsArticleDest.FieldByName('CODE').AsString;
      bLocate := cdsArticleOrigine.Locate('CODE',sCode_Article,[]);

      if bLocate then
      begin
        slTmp.Add(cdsArticleDest.FieldByName('CODE').AsString + ';' +           //CODE
                  cdsArticleDest.FieldByName('CODE_MRQ').AsString + ';' +       //CODE_MRQ
                  cdsArticleDest.FieldByName('CODE_GT').AsString + ';' +        //CODE_GT
                  cdsArticleDest.FieldByName('CODE_FOURN').AsString + ';' +     //CODE_FOURN
                  cdsArticleDest.FieldByName('NOM').AsString + ';' +            //NOM
                  cdsArticleDest.FieldByName('CODEIS').AsString + ';' +         //CODEIS
                  cdsArticleOrigine.FieldByName('CODEFEDAS').AsString + ';' +   //CODEFEDAS
                  cdsArticleDest.FieldByName('DESCRIPTION').AsString + ';' +    //DESCRIPTION
                  cdsArticleDest.FieldByName('CLASS1').AsString + ';' +         //CLASS1
                  cdsArticleDest.FieldByName('CLASS2').AsString + ';' +         //CLASS2
                  cdsArticleDest.FieldByName('CLASS3').AsString + ';' +         //CLASS3
                  cdsArticleDest.FieldByName('CLASS4').AsString + ';' +         //CLASS4
                  cdsArticleDest.FieldByName('CLASS5').AsString + ';' +         //CLASS5
                  cdsArticleDest.FieldByName('CLASS6').AsString + ';' +         //CLASS6
                  cdsArticleDest.FieldByName('FIDELITE').AsString + ';' +       //FIDELITE
                  cdsArticleDest.FieldByName('DATECREATION').AsString + ';' +   //DATECREATION
                  cdsArticleDest.FieldByName('COMENT1').AsString + ';' +        //COMENT1
                  cdsArticleDest.FieldByName('COMENT2').AsString + ';' +        //COMENT2
                  cdsArticleDest.FieldByName('TVA').AsString + ';' +            //TVA
                  cdsArticleDest.FieldByName('PSEUDO').AsString + ';' +         //PSEUDO
                  cdsArticleDest.FieldByName('ARCHIVER').AsString + ';' +       //ARCHIVER
                  cdsArticleDest.FieldByName('CODE_GENRE').AsString + ';' +     //CODE_GENRE
                  cdsArticleDest.FieldByName('CODE_DOMAINE').AsString + ';' +   //CODE_DOMAINE
                  cdsArticleDest.FieldByName('CENTRALE').AsString + ';' +       //CENTRALE
                  cdsArticleDest.FieldByName('TYPECOMPTABLE').AsString + ';' +  //TYPECOMPTABLE
                  cdsArticleDest.FieldByName('FLAGMODELE').AsString + ';' +     //FLAGMODELE
                  cdsArticleDest.FieldByName('STKIDEAL').AsString + ';');       //STKIDEAL
      end
      else
      begin
        slLog.Add(sCode_Article + ' : Non trouvé dans les articles d''origine');
      end;
      cdsArticleDest.Next;
    end;
  finally
    if FileExists(sFileDest + '2.csv') then
      DeleteFile(sFileDest + '2.csv');
    if FileExists(sFileDest + 'LogArticle.csv') then
      DeleteFile(sFileDest + 'LogArticle.csv');

    slLog.SaveToFile(sFileDest + 'LogArticle.csv');
    slTmp.SaveToFile(sFileDest + '2.csv');

    FreeAndNil(slTmp);
    FreeAndNil(cdsArticleOrigine);
    FreeAndNil(cdsArticleDest);
    FreeAndNil(slLog);
  end;
  //-----------------------------------
end;

procedure TFrm_Main.Btn_Traitement_HistoVenteGoSportClick(Sender: TObject);
begin
  try
    if ( Trim( Bed_PathFile_HistoVenteGoSport.Text ) = '' ) or ( Trim( Bed_Base_HistoVenteGoSport.Text ) = '' ) or (
      not ( FileExists( Bed_PathFile_HistoVenteGoSport.Text ) and ( FileExists( Bed_Base_HistoVenteGoSport.Text ) ) )
    ) then
      exit;

    Btn_Traitement_HistoVenteGoSport.Enabled := False;
    FuseDefautEAN := chkDefautEAN.Checked;
    FdefautEAN := edtDefautEAN.Text;
    FdefautEANType := cbbDefautEANType.ItemIndex;

    if Assigned( ThreadHistoVente ) then
      ThreadHistoVente.Free;
    ThreadHistoVente := TThread.CreateAnonymousThread(
      procedure
      var
        iErrors: Integer;
      begin
        iErrors := 0;
        Re_Log_HistoVenteGoSport.Clear;
        Lbl_Errors_HistoVenteGoSport.Caption := '';
        try
          ThreadHistoVente.Synchronize(
            ThreadHistoVente,
            procedure
            begin
              Lbl_Etat_HistoVenteGoSport.Caption := 'Traitement : Historique des ventes...';
            end
          );
          ProcLockingFile(
            procedure(FileStreamSource, FileStreamConso, FileStreamCaisse: TFileStream)
              function GetFormattedHeader(const Items: array of String): String;
              var
                Item: String;
              begin
                Result := '';
                for Item in Items do
                  Result := Result + Item + ';';
              end;

              function chargeDataFromDB(out aEANListe : TObjectDictionary<string, TArtInfo>; out aCLTListe : TDictionary<string, string>) : Boolean;
              var
                vQuery : TFDQuery;
                vArt : TArtInfo;
                vType : string;
              begin
                Result := true;
                vQuery := TFDQuery.Create(nil);
                try
                  try
                    Re_Log_HistoVenteGoSport.Lines.Add('Chargement des Articles...');
                    vQuery.Connection := Base;
                    vQuery.SQL.Text := 'select ARA_CODEART, ARA_ARTID, ARA_TGFID, ARA_COUID '
                                    + 'from ARTRELATIONART join K on K_ID = ARA_ID and K_ENABLED = 1 '
                                    + 'where ARA_CODEART<> '''' and ARA_ARTID <> 0 '
                                    + 'order by ARA_CODEART, k_inserted desc';
                    vQuery.Open();

                    while not vQuery.Eof do
                    begin
                      if not aEANListe.ContainsKey(vQuery.FieldByName('ARA_CODEART').AsString) then
                      begin
                        vArt := TArtInfo.Create();
                        vArt.FartID := vQuery.FieldByName('ARA_ARTID').AsString;
                        vArt.FtgfID := vQuery.FieldByName('ARA_TGFID').AsString;
                        vArt.FcouID := vQuery.FieldByName('ARA_COUID').AsString;

                        aEANListe.Add(vQuery.FieldByName('ARA_CODEART').AsString, vArt);
                      end;

                      vQuery.Next();
                    end;
                    vQuery.Close();

                    Re_Log_HistoVenteGoSport.Lines.Add('Chargement terminé');


                    if FuseDefautEAN then
                    begin
                      Re_Log_HistoVenteGoSport.Lines.Add('Chargement EAN par défaut...');
                      case FdefautEANType of
                        0: vType := '1,3';
                        1: vType := '1';
                        2: vType := '3';
                      end;
                      vQuery.SQL.Text := 'select arf_artid, cbi_tgfid, cbi_couid from artcodebarre '
                                      + 'join k on k_id=cbi_id and k_enabled=1 '
                                      + 'join artreference on arf_id=cbi_arfid '
                                      + 'join k on k_id=arf_id and k_enabled=1 '
                                      + 'where cbi_cb=:CB and cbi_type in(' + vType + ')';
                      vQuery.ParamByName('CB').AsString := FdefautEAN;

                      vQuery.Open();

                      if not vQuery.Eof then
                      begin
                        if not aEANListe.ContainsKey(FdefautEAN) then
                        begin
                          vArt := TArtInfo.Create();
                          vArt.FartID := vQuery.FieldByName('arf_artid').AsString;
                          vArt.FtgfID := vQuery.FieldByName('cbi_tgfid').AsString;
                          vArt.FcouID := vQuery.FieldByName('cbi_couid').AsString;

                          aEANListe.Add(FdefautEAN, vArt);
                        end
                        else
                        begin
                          aEANListe[FdefautEAN].FartID := vQuery.FieldByName('arf_artid').AsString;
                          aEANListe[FdefautEAN].FtgfID := vQuery.FieldByName('cbi_tgfid').AsString;
                          aEANListe[FdefautEAN].FcouID := vQuery.FieldByName('cbi_couid').AsString;
                        end;

                        vQuery.Next();
                        if not vQuery.Eof then
                        begin
                          Re_Log_HistoVenteGoSport.Lines.Add(Format('EAN par défaut en DOUBLON : %s', [FdefautEAN]));
                          Re_Log_HistoVenteGoSport.Lines.Add('Traitement interrompu');
                          Result := False;
                          Exit;
                        end;
                      end
                      else
                      begin
                        Re_Log_HistoVenteGoSport.Lines.Add(Format('EAN par défaut non présent en base : %s', [FdefautEAN]));
                        Re_Log_HistoVenteGoSport.Lines.Add('Traitement interrompu');
                        Result := False;
                        Exit;
                      end;
                    end;


                    Re_Log_HistoVenteGoSport.Lines.Add('Chargement des clients...');
                    vQuery.SQL.Text := 'select clt_numero, clt_id '
                                      + 'from cltclient join k on k_id=clt_id and k_enabled=1 '
                                      + 'where clt_numero <> '''' and clt_id <> 0 '
                                      + 'order by clt_numero, k_inserted desc';
                    vQuery.Open();

                    while not vQuery.Eof do
                    begin
                      if not aCLTListe.ContainsKey(vQuery.FieldByName('clt_numero').AsString) then
                      begin
                        aCLTListe.Add(vQuery.FieldByName('clt_numero').AsString, vQuery.FieldByName('clt_id').AsString);
                      end;

                      vQuery.Next();
                    end;
                    vQuery.Close();

                    Re_Log_HistoVenteGoSport.Lines.Add('Chargement terminé');

                  except
                    on E: Exception do
                    begin
                      Result := False;
                      Re_Log_HistoVenteGoSport.Lines.Add(Format('Erreur récupération data : %s', [E.Message]));
                      Re_Log_HistoVenteGoSport.Lines.Add('Traitement interrompu');
                    end;
                  end;


                finally
                  freeAndnil(vQuery);
                end;
              end;
            var
              StreamWriterConso, StreamWriterCaisse, vSWLog: TStreamWriter;
              vLogFilestream : TFileStream;
              StringListLines, StringListFields: TStringList;
              i, CommonEANLength: Integer;
              vClientId : string;
              vEANErreur: TStringList;
              vErreurClient : TStringList;
              vTicket : TStringList;
              vConso : TStringList;
              vTicketErreur : TStringList;
              vErreur : Boolean;
              vLastTicket : string;
              vTmp : string;
              vEANListe : TObjectDictionary<string, TArtInfo>;
              vCLTListe : TDictionary<string, string>;

              vPourcent : Integer;
              vLastPourcent : Integer;
              vCurrentEAN : string;
            begin
              try
                StringListLines := TStringList.Create;
                vEANErreur := TStringList.Create;
                vErreurClient := TStringList.Create;
                vTicket := TStringList.Create;
                vConso := TStringList.Create;
                vTicketErreur := TStringList.Create;
                vLastTicket := '';

                vEANListe := TObjectDictionary<string, TArtInfo>.Create([doOwnsValues]);
                vCLTListe := TDictionary<string, string>.Create();
                try
                  StringListLines.LoadFromStream( FileStreamSource );
                  if StringListLines.Count = 0 then begin
                    Re_Log_HistoVenteGoSport.Lines.Add( Format( 'Fichier "%s" vide', [ FileStreamSource.FileName ] ) );
                    exit; //fichier vide
                  end;

                  if not chargeDataFromDB(vEANListe, vCLTListe) then
                    Exit;

                  if FuseDefautEAN then
                  begin
                    if not vEANListe.ContainsKey(FdefautEAN) then
                    begin
                      Re_Log_HistoVenteGoSport.Lines.Add(Format( 'EAN par défaut non valide : "%s"', [FdefautEAN]));
                      Re_Log_HistoVenteGoSport.Lines.Add('Traitement interrompu');
                      Exit;
                    end;
                  end;

                  StreamWriterConso := TStreamWriter.Create( FileStreamConso );
                  if Assigned( FileStreamCaisse ) then
                    StreamWriterCaisse:= TStreamWriter.Create( FileStreamCaisse );
                  StringListFields := TStringList.Create;


                  vtmp := ExtractFilePath(Application.ExeName) + 'logs\' + FormatDateTime('yyyy-mm-dd', now) + '.log';
                  ForceDirectories(ExtractFilePath(vtmp)) ;

                  vLogFilestream := TFileStream.Create(vtmp, fmCreate,0);
                  vSWLog := TStreamWriter.Create(vLogFilestream);


                  Pb_HistoVenteGoSport.Min := 0;
                  Pb_HistoVenteGoSport.Max := 100;
                  Pb_HistoVenteGoSport.Position := 0;
                  vLastPourcent := 0;

                  try
                    StreamWriterConso.WriteLine( GetFormattedHeader( Consodiv_COL ) );
                    if Assigned( FileStreamCaisse ) then
                      StreamWriterCaisse.WriteLine( GetFormattedHeader( Caisse_COL ) );

                    StringListFields.Delimiter := '|';
                    StringListFields.StrictDelimiter := True;

                    if Cb_GenerateCaisseCSV_HistoVenteGoSport.Checked then
                      CommonEANLength := GetCommonEANLength;
                    for i := 0 to StringListLines.Count - 1 do begin
                      if ThreadHistoVente.CheckTerminated then
                        raise EAbort.Create( 'Aborted' );

                      StringListFields.DelimitedText := StringListLines[ i ];
                      if StringListFields.Count <> Length( Caisse_COL ) then begin
                        Re_Log_HistoVenteGoSport.Lines.Add( Format( 'Ligne %d : nombre de champ non valide (attendu : %d, present : %d), "%s"', [ i+1, Length(Caisse_COL), StringListFields.Count, StringListLines[ i ] ] ) );
                        continue;
                      end
                      else if (i = 0) and (string.join('|', Caisse_COL) = StringListLines[ i ]) then
                      begin
                        Re_Log_HistoVenteGoSport.Lines.Add('Le fichier ne doit pas avoir de ligne d''entete !');
                        Re_Log_HistoVenteGoSport.Lines.Add('Traitement interrompu');
                        Exit;
                      end;

                      // Correction de l'EAN ?
                      if ( Cb_GenerateCaisseCSV_HistoVenteGoSport.Checked )
                      and( CommonEANLength > 0 ) and ( CommonEANLength > Length( StringListFields[ 03 ] ) ) then
                        StringListFields[ 03 ] := StringOfChar( '0', CommonEANLength - Length( StringListFields[ 03 ] ) ) + StringListFields[ 03 ];

                      vCurrentEAN := IfThen(vEANListe.ContainsKey(StringListFields[03]), StringListFields[03], FdefautEAN);

                      if ((vEANListe.ContainsKey(StringListFields[03])) or (FuseDefautEAN)) then
                      begin
                        vTmp := vEANListe[vCurrentEAN].FartID + ';'
                              + vEANListe[vCurrentEAN].FtgfID + ';'
                              + vEANListe[vCurrentEAN].FcouID + ';'
                              + vCurrentEAN + ';'
                              + StringListFields[04] + ';'
                              + DateToStr(Dtp_Date_HistoVenteGoSport.DateTime) + ';'
                              + '7' + ';' // TYPE
                              + '20' + ';' // TYPEGINKOIA
                              + IntToStr(-1 * StrToInt(StringListFields[13]))+ ';'
                              + 'Régularisation' + ';'
                              + StringListFields[16] + ';';
                        vErreur := False;

                        if (FuseDefautEAN and (vCurrentEAN <> StringListFields[03]) and (vEANErreur.IndexOf(StringListFields[03]) < 0)) then
                        begin
                          vEANErreur.Add(StringListFields[03]);
                        end;
                      end
                      else
                      begin
                        Inc(iErrors);
                        if iErrors mod 500 = 0 then
                          Lbl_Errors_HistoVenteGoSport.Caption := Format('%d erreur(s)', [iErrors]);
                        if vEANErreur.IndexOf(StringListFields[03]) < 0 then
                        begin
//                          Re_Log_HistoVenteGoSport.Lines.Add(Format('code EAN "%s" : non valide', [StringListFields[03]]));
                          vEANErreur.Add(StringListFields[03]);
                        end;
                        vErreur := True;
                      end;

                      if Assigned(FileStreamCaisse) then
                      begin
                        if vErreur then
                        begin
//                          Re_Log_HistoVenteGoSport.Lines.Add(Format('ticket ignoré : %s (ligne %d)', [StringListFields[9], i+1]));
//                          if vTicketErreur.IndexOf(StringListFields[9]) < 0 then
                            if (vTicketErreur.Count = 0) or (vTicketErreur.Strings[vTicketErreur.Count-1] <> StringListFields[9]) then
                            vTicketErreur.Add(StringListFields[9]);
                          if vLastTicket = StringListFields[9] then
                           vConso.Clear();
                        end
                        else
                        begin
//                          if vTicketErreur.IndexOf(StringListFields[9]) < 0 then
                          if (vTicketErreur.Count = 0) or (vTicketErreur.Strings[vTicketErreur.Count-1] <> StringListFields[9]) then
                          begin
                            if (vLastTicket <> StringListFields[9]) and (vLastTicket <> '') and (vConso.Count >0) then
                            begin
                              StreamWriterConso.Write(vConso.Text);
                              vConso.Clear();
                            end;

                            vConso.Add(vTmp);
                          end;
                        end;
                      end
                      else if not vErreur then
                        StreamWriterConso.WriteLine(vTmp);

                      {$REGION 'fichier CAISSE'}
                      if Assigned( FileStreamCaisse ) then
                      begin
                        if vErreur then
                        begin
                          if vLastTicket = StringListFields[9] then
                           vTicket.Clear();
                        end
                        else
                        begin
//                          if vTicketErreur.IndexOf(StringListFields[9]) < 0 then
                          if (vTicketErreur.Count = 0) or (vTicketErreur.Strings[vTicketErreur.Count-1] <> StringListFields[9]) then
                          begin
                            if (vLastTicket <> StringListFields[9]) and (vLastTicket <> '') and (vTicket.Count >0) then
                            begin
                              StreamWriterCaisse.Write(vTicket.Text);
                              vTicket.Clear();
                            end;

                            {$REGION 'recuperation lien client'}


                            if (StringListFields[15] <> '') and (StringListFields[15] <> '0') then
                            begin
                              if vCLTListe.ContainsKey(StringListFields[15]) then
                                vClientId := vCLTListe[StringListFields[15]]
                              else
                              begin
                                vClientId := '';
                                if vErreurClient.IndexOf(StringListFields[15]) < 0 then
                                begin
                                  vErreurClient.Add(StringListFields[15]);
//                                  Re_Log_HistoVenteGoSport.Lines.Add(Format('code client non trouvé pour le clt_numcb suivant : %s (ligne %d)', [StringListFields[15], i+1]));
                                end;
                              end;
                            end
                            else
                              vClientId := '';
                            {$ENDREGION}

                            vTicket.Add(
                              StringListFields[ 00 ] + ';' +
                              StringListFields[ 01 ] + ';' +
                              StringListFields[ 02 ] + ';' +
                              vCurrentEAN + ';' +
                              StringListFields[ 04 ] + ';' +
                              StringListFields[ 05 ] + ';' +
                              StringListFields[ 06 ] + ';' +
                              StringListFields[ 07 ] + ';' +
                              StringListFields[ 08 ] + ';' +
                              StringListFields[ 09 ] + ';' +
                              StringListFields[ 10 ] + ';' +
                              StringListFields[ 11 ] + ';' +
                              StringListFields[ 12 ] + ';' +
                              StringListFields[ 13 ] + ';' +
                              StringListFields[ 14 ] + ';' +
                              vClientId + ';' +
                              StringListFields[ 16 ] + ';')
                          end;
                        end;
                      end;
                      {$ENDREGION}
                      vLastTicket := StringListFields[9];

                      vPourcent := Round(((I+1)*100)/StringListLines.Count);
                      if vPourcent > 100 then vPourcent := 100;

                      if vPourcent <> vLastPourcent then
                      begin
                        vLastPourcent := vPourcent;
                        TThread.Synchronize(
                          nil,
                          procedure
                          begin
                            Pb_HistoVenteGoSport.Position := vLastPourcent;
                          end
                        );
                      end;
                    end;

                    if vConso.Count > 0 then
                      StreamWriterConso.Write(vConso.Text);

                    if (Assigned(FileStreamCaisse)) and (vTicket.Count > 0) then
                      StreamWriterCaisse.Write(vTicket.Text);

                    Re_Log_HistoVenteGoSport.Lines.Add('---------------------------------------------');
                    Re_Log_HistoVenteGoSport.Lines.Add(Format('code EAN %s : %d', [ifthen(FuseDefautEAN, 'remplacé par "' + FdefautEAN + '"', 'en erreur'), vEANErreur.Count]));
                    Re_Log_HistoVenteGoSport.Lines.Add(Format('code client non trouvé : %d', [vErreurClient.Count]));
                    Re_Log_HistoVenteGoSport.Lines.Add(Format('ticket ignoré : %d', [vTicketErreur.Count]));

                    Re_Log_HistoVenteGoSport.Lines.Add('---------------------------------------------');
                    Re_Log_HistoVenteGoSport.Lines.Add('Ecriture des logs...');

                    if (vEANErreur.Count > 0) then
                    begin
                      for I := 0 to vEANErreur.Count - 1 do
                      begin
                        vSWLog.WriteLine(Format('code EAN "%s" : %s', [vEANErreur[I], ifthen(FuseDefautEAN, 'remplacé par "' + FdefautEAN + '"', 'non valide')]));
                      end;
                    end;

                    if (vErreurClient.Count > 0) then
                    begin
                      for I := 0 to vErreurClient.Count - 1 do
                      begin
                        vSWLog.WriteLine(Format('code client non trouvé pour le clt_numcb suivant : "%s"', [vErreurClient[I]]));
                      end;
                    end;

                    if (vTicketErreur.Count > 0) then
                    begin
                      for I := 0 to vTicketErreur.Count - 1 do
                      begin
                        vSWLog.WriteLine(Format('ticket ignoré : "%s"', [vTicketErreur[I]]));
                      end;
                    end;

                    Lbl_Errors_HistoVenteGoSport.Caption := Format('%d erreur(s)', [iErrors]);
                  finally
                    StringListFields.Free;
                    StreamWriterConso.Free;
                    if Assigned( FileStreamCaisse ) then
                      StreamWriterCaisse.Free;

                    FreeAndNil(vSWLog);
                    FreeAndNil(vLogFilestream);
                  end;
                finally
                  StringListLines.Free;
                  FreeAndNil(vEANErreur);
                  vErreurClient.Free;
                  FreeAndNil(vTicket);
                  FreeAndNil(vConso);
                  FreeAndNil(vTicketErreur);
                  FreeAndNil(vEANListe);
                  FreeAndNil(vCLTListe);
                end;
              except
                on E: EAbort do begin
                  // Silence is golden
                end;
                on E: Exception do
                  Re_Log_HistoVenteGoSport.Lines.Add( Format( 'Ligne:%d  --> "%s"', [ i, E.Message ] ) );
              end;
            end,
            Bed_PathFile_HistoVenteGoSport.Text,
            ExtractFilePath( Bed_PathFile_HistoVenteGoSport.Text ) + ConsoDiv_CSV,
            ExtractFilePath( Bed_PathFile_HistoVenteGoSport.Text ) + Caisse_CSV,
            fmShareExclusive or fmOpenRead,
            fmShareExclusive or fmCreate,
            fmShareExclusive or fmCreate,
            Cb_GenerateCaisseCSV_HistoVenteGoSport.Checked
          );
          {$REGION 'Update UI'}
          ThreadHistoVente.Synchronize(
            ThreadHistoVente,
            procedure
            begin
              Lbl_Etat_HistoVenteGoSport.Caption :=
                Format(
                  'Traitement : Terminé (%s%s)', [
                    ConsoDiv_CSV,
                    IfThen(
                      Cb_GenerateCaisseCSV_HistoVenteGoSport.Checked,
                      ',' + Caisse_CSV
                    )
                  ]
                );
              ShowMessage('Traitement terminé.');
              Btn_Traitement_HistoVenteGoSport.Enabled := True;
            end
          );
          {$ENDREGION}
        except
          on E: EAbort do begin
            // Silence is golden
          end;
          on E: Exception do
          begin
            Re_Log_HistoVenteGoSport.Lines.Add('Except : ' + E.Message );
          end;
        end;
      end
    );
    ThreadHistoVente.FreeOnTerminate := False;
    ThreadHistoVente.Start;
  except
    on E: Exception do
      ShowMessage( E.Message );
  end;
end;


procedure TFrm_Main.Btn_TF_JeevesClick(Sender: TObject);
var
  sPath : string;
  sFile : string;
  cdsArticle : TClientDataSet;
  cdsMarque : TClientDataSet;
  cdsFournisseur : TClientDataSet;
  slTmp : TStringList;
  slTmp2 : TStringList;
  sTVA : string;
  iCodeMarque : Integer;
  sCodeMarque : string;
  iCodeFournisseur : Integer;
  iTmp : Integer;
begin
  iCodeMarque := 123450000;
  iCodeFournisseur := 123450000;
  //Chemin
  sFile := Bed_PathFile_FEDAS_POST_ISF_Origine.Text;
  sPath := ExtractFilePath(sFile);

  slTmp := TStringList.Create;
  try
    //Fichier Origine
    slTmp.Clear;
    slTmp.LoadFromFile(sFile);   //Chargement du fichier
    slTmp.Insert(0,'CODE;CODE_MRQ;CODE_GT;CODE_FOURN;NOM;CODEIS;CODEFEDAS;DESCRIPTION;CLASS1;CLASS2;CLASS3;CLASS4;CLASS5;CLASS6;FIDELITE;DATECREATION;COMENT1;COMENT2;TVA;PSEUDO;ARCHIVER;CODE_GENRE;CODE_DOMAINE;CENTRALE;TYPECOMPTABLE;FLAGMODELE;STKIDEAL;AXE1;AXE2;AXX3;AXE4');     //Ajout de l'en-tête
    slTmp.SaveToFile(sFile);     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  slTmp := TStringList.Create;
  try
    //Fichier Origine
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + 'MARQUE.csv');   //Chargement du fichier
    slTmp.Insert(0,'CODE;MRQ_NOM;NB');          //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + 'MARQUE.csv');     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  slTmp := TStringList.Create;
  try
    //Fichier Origine
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + 'FOURN.csv');      //Chargement du fichier
    slTmp.Insert(0,'CODE;FOU_NOM;VILLE;PAYS;NB'); //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + 'FOURN.csv');        //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsArticle := TClientDataSet.Create(nil);
  cdsMarque := TClientDataSet.Create(nil);
  cdsFournisseur := TClientDataSet.Create(nil);
  slTmp := TStringList.Create;
  slTmp2 := TStringList.Create;
  try
    LoadDataSet('Article',
                sFile,
                'CODE', cdsArticle);

    LoadDataSet('Marque',
                sPath + 'MARQUE.csv',
                'CODE;MRQ_NOM', cdsMarque);

    LoadDataSet('Fournisseur',
                sPath + 'Fourn.csv',
                'CODE;FOU_NOM', cdsFournisseur);

    cdsArticle.First;
    while not cdsArticle.Eof do
    begin
      if TryStrToInt(cdsArticle.FieldByName('CODE_MRQ').AsString,iTmp) then    //Si c'est un entier
      begin
        if not cdsMarque.Locate('CODE', cdsArticle.FieldByName('CODE_MRQ').AsString,[]) then  //Si n'est pas présent dans les marques
        begin
          cdsMarque.Insert;
          cdsMarque.Fields[0].AsString := cdsArticle.FieldByName('CODE_MRQ').AsString;
          cdsMarque.Fields[1].AsString := 'Sans NOM' + cdsArticle.FieldByName('CODE_MRQ').AsString;
          cdsMarque.Fields[2].AsInteger := 1;
          cdsMarque.Post;
        end;
        sCodeMarque := cdsArticle.FieldByName('CODE_MRQ').AsString
      end
      else
      begin
        if not cdsMarque.Locate('MRQ_NOM', cdsArticle.FieldByName('CODE_MRQ').AsString,[]) then
        begin
          cdsMarque.Insert;
          cdsMarque.Fields[0].AsInteger := iCodeMarque;
          cdsMarque.Fields[1].AsString := cdsArticle.FieldByName('CODE_MRQ').AsString;
          cdsMarque.Fields[2].AsInteger := 1;
          cdsMarque.Post;
          sCodeMarque := IntToStr(iCodeMarque);
          Inc(iCodeMarque);
        end
        else
        begin
          cdsMarque.Locate('MRQ_NOM', cdsArticle.FieldByName('CODE_MRQ').AsString,[]);
          sCodeMarque := cdsMarque.FieldByName('CODE').AsString;
        end;
      end;

      sTVA := cdsArticle.FieldByName('TVA').AsString;
      if (sTVA = '') or (sTVA = '0') then
        sTVA := '20';

      slTmp.Add(cdsArticle.FieldByName('CODE').AsString + ';' +           //CODE
                sCodeMarque + ';' +                                       //CODE_MRQ
                cdsArticle.FieldByName('CODE_GT').AsString + ';' +        //CODE_GT
                cdsArticle.FieldByName('CODE_FOURN').AsString + ';' +     //CODE_FOURN
                cdsArticle.FieldByName('NOM').AsString + ';' +            //NOM
                cdsArticle.FieldByName('CODEIS').AsString + ';' +         //CODEIS
                Ed_FEDAS_REMPLACEMENT.Text + ';' +                        //CODEFEDAS
                cdsArticle.FieldByName('DESCRIPTION').AsString + ';' +    //DESCRIPTION
                cdsArticle.FieldByName('CLASS1').AsString + ';' +         //CLASS1
                cdsArticle.FieldByName('CLASS2').AsString + ';' +         //CLASS2
                cdsArticle.FieldByName('CLASS3').AsString + ';' +         //CLASS3
                cdsArticle.FieldByName('CLASS4').AsString + ';' +         //CLASS4
                cdsArticle.FieldByName('CLASS5').AsString + ';' +         //CLASS5
                cdsArticle.FieldByName('CLASS6').AsString + ';' +         //CLASS6
                cdsArticle.FieldByName('FIDELITE').AsString + ';' +       //FIDELITE
                cdsArticle.FieldByName('DATECREATION').AsString + ';' +   //DATECREATION
                cdsArticle.FieldByName('COMENT1').AsString + ';' +        //COMENT1
                cdsArticle.FieldByName('COMENT2').AsString + ';' +        //COMENT2
                sTVA + ';' +            //TVA
                cdsArticle.FieldByName('PSEUDO').AsString + ';' +         //PSEUDO
                cdsArticle.FieldByName('ARCHIVER').AsString + ';' +       //ARCHIVER
                cdsArticle.FieldByName('CODE_GENRE').AsString + ';' +     //CODE_GENRE
                cdsArticle.FieldByName('CODE_DOMAINE').AsString + ';' +   //CODE_DOMAINE
                cdsArticle.FieldByName('CENTRALE').AsString + ';' +       //CENTRALE
                cdsArticle.FieldByName('TYPECOMPTABLE').AsString + ';' +  //TYPECOMPTABLE
                cdsArticle.FieldByName('FLAGMODELE').AsString + ';' +     //FLAGMODELE
                cdsArticle.FieldByName('STKIDEAL').AsString + ';');       //STKIDEAL

      slTmp2.Add( cdsArticle.FieldByName('CODE').AsString + ';' +           //CODE
                  cdsArticle.FieldByName('AXE4').AsString + ';' +           //AXENIVEAU4
                  cdsArticle.FieldByName('AXE1').AsString + ';');           //AXENIVEAU1

      cdsArticle.Next;
    end;
    //Modèle
    if FileExists(ExtractFilePath(sFile) + 'Modele.csv') then
      DeleteFile(ExtractFilePath(sFile) + 'Modele.csv');
    slTmp.SaveToFile(ExtractFilePath(sFile) + 'Modele.csv');

    if FileExists(ExtractFilePath(sFile) + 'ModeleAxe.csv') then
      DeleteFile(ExtractFilePath(sFile) + 'ModeleAxe.csv');
    slTmp2.SaveToFile(ExtractFilePath(sFile) + 'ModeleAxe.csv');

    FreeAndNil(slTmp);
    FreeAndNil(slTmp2);

    slTmp := TStringList.Create;
    try
      //Fichier Origine
      slTmp.Clear;
      cdsMarque.First;
      while not cdsMarque.Eof do
      begin
        slTmp.Add(cdsMarque.FieldByName('CODE').AsString + ';' +
                  cdsMarque.FieldByName('MRQ_NOM').AsString + ';' +
                  cdsMarque.FieldByName('NB').AsString + ';');
        cdsMarque.Next;
      end;
      if FileExists(sPath + 'MARQUE.csv') then
        DeleteFile(sPath + 'MARQUE.csv');

      slTmp.SaveToFile(sPath + 'MARQUE.csv');        //Enregistrement du fichier
    finally
      FreeAndNil(slTmp);
    end;

    slTmp := TStringList.Create;
    try
      //Fichier Origine
      slTmp.Clear;
      cdsFournisseur.First;
      while not cdsFournisseur.Eof do
      begin
        slTmp.Add(cdsFournisseur.FieldByName('CODE').AsString + ';' +
                  cdsFournisseur.FieldByName('FOU_NOM').AsString + ';' +
                  cdsFournisseur.FieldByName('VILLE').AsString + ';' +
                  cdsFournisseur.FieldByName('PAYS').AsString + ';' +
                  cdsFournisseur.FieldByName('NB').AsString + ';');
        cdsFournisseur.Next;
      end;

      if FileExists(sPath + 'FOURN.csv') then
        DeleteFile(sPath + 'FOURN.csv');

      slTmp.SaveToFile(sPath + 'FOURN.csv');        //Enregistrement du fichier
    finally
      FreeAndNil(slTmp);
    end;
  finally
    FreeAndNil(cdsArticle);
    FreeAndNil(cdsMarque);
    FreeAndNil(cdsFournisseur);
  end;
  //-----------------------------------
  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.Button1Click(Sender: TObject);
var
  sFileInit : string;
  cdsInit   : TClientDataSet;
  cdsConso,
  Tmp_SL    : TStringList;

  function GetHeader(aTab:array of string):string;
  var
    i : Integer;
  begin
    Result := '';
    for i := 0 to Length(aTab) - 1 do
      if Result = '' then
        Result := aTab[i]
      else
        Result := Result + ';' + aTab[i];
  end;
begin
  //Partie Traitement des fichiers
  sFileInit := Bed_TransferConso.Text;

  cdsInit   := TClientDataSet.Create(nil);
  cdsConso  := TStringList.Create;
  try
    //Transfert IniterMagasin
    if FileExists(sFileInit) then
    begin
      Tmp_SL := TStringList.Create;
      try
        Tmp_SL.LoadFromFile(sFileInit);      //Chargement du fichier
        Tmp_SL.Insert(0,GetHeader(Transfert_COL));          //Ajout de l'en-tête
        Tmp_SL.SaveToFile(sFileInit);        //Enregistrement du fichier
      finally
      FreeAndNil(Tmp_SL);
      end;
      LoadDataSet('Transfert', sFileInit, 'CODE_ART',cdsInit);
    end;

    cdsInit.First;
    while not cdsInit.Eof do
    begin
      if cdsInit.FieldByName('CODE_MAGD').AsString = Ed_CodeAdh.Text then
      begin
        cdsConso.Add( cdsInit.FieldByName('CODE_ART').AsString + ';' +
                      cdsInit.FieldByName('CODE_TAILLE').AsString + ';' +
                      cdsInit.FieldByName('CODE_COUL').AsString + ';' +
                      cdsInit.FieldByName('EAN').AsString + ';' +
                      cdsInit.FieldByName('CODE_MAGO').AsString + ';' +
                      cdsInit.FieldByName('DATE').AsString + ';' +
                      '7' + ';' +
                      '20' + ';' +
                      cdsInit.FieldByName('QTE').AsString + ';' +
                      'Régularisation de stock Suite Transpo Ginkoia/Nosymag' + ';' +
                      '0' + ';');
      end
      else
      begin
        cdsConso.Add( cdsInit.FieldByName('CODE_ART').AsString + ';' +
                      cdsInit.FieldByName('CODE_TAILLE').AsString + ';' +
                      cdsInit.FieldByName('CODE_COUL').AsString + ';' +
                      cdsInit.FieldByName('EAN').AsString + ';' +
                      cdsInit.FieldByName('CODE_MAGD').AsString + ';' +
                      cdsInit.FieldByName('DATE').AsString + ';' +
                      '7' + ';' +
                      '20' + ';' +
                      '-' + cdsInit.FieldByName('QTE').AsString + ';' +
                      'Régularisation de stock Suite Transpo Ginkoia/Nosymag' + ';' +
                      '0' + ';');
      end;

      cdsInit.Next;
    end;
    cdsConso.SaveToFile(ExtractFilePath(sFileInit) + 'ConsoDiv_Transfert.csv');
  finally
    FreeAndNil(cdsInit);
    FreeAndNil(cdsConso);
  end;

  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.chkDefautEANClick(Sender: TObject);
begin
  edtDefautEAN.Enabled := chkDefautEAN.Checked;
  cbbDefautEANType.Enabled := chkDefautEAN.Checked;
end;

procedure TFrm_Main.Btn_Sep_Execute_AllClick(Sender: TObject);
var
  sPathFolder : string;
  Ch : TSearchRec;
  Nb : Integer;
  procedure ChangeSep(sPahtFile : string);
  var
    lList: TStringList;
    lTab: TStringDynArray;
    iList, iCol: integer;
  begin
    if FileExists(sPahtFile) then
    begin
      lList := TStringList.Create;
      try
        lList.LoadFromFile(sPahtFile);
        if rg_Gui.ItemIndex = 0 then
        begin
          for iList := 0 to lList.Count -1 do
          begin
            lList[iList] := System.SysUtils.StringReplace(lList[iList],',',';',[System.SysUtils.rfReplaceAll]);
            pb_Gui.Position := ((iList+1)*100) div lList.Count;
          end;
        end
        else
        begin
          for iList := 0 to lList.Count -1 do
          begin
            lTab := SplitString(lList[iList],';');
            for iCol := 0 to Length(lTab) -1 do
            begin
              //on recherche si le premier ou le dernier caractère est un guillemet
              if Length(lTab[iCol]) > 0 then
              begin
                if lTab[iCol][Length(lTab[iCol])] = '"' then
                  lTab[iCol] := Copy(lTab[iCol],1,Length(lTab[iCol])-1);
                if lTab[iCol][1] = '"' then
                  lTab[iCol] := Copy(lTab[iCol],2,Length(lTab[iCol])-1);
              end;
              //on reconstruit la ligne du stringlist
              if iCol = 0 then
                  lList[iList] := lTab[iCol]
                else
                  lList[iList] := lList[iList] + ';' + lTab[iCol];
            end;
            pb_Gui.Position := ((iList+1)*100) div lList.Count;
          end;
        end;
        lList.SaveToFile(sPahtFile);
      finally
        lList.Free;
      end;
    end;
  end;
begin
  btn_Gui_Execute.Enabled := False;
  Btn_Gui_Execute_All.Enabled := False;
  Btn_Sep_Execute_All.Enabled := False;
  bed_Gui_CSV.Enabled := false;
  rg_Gui.Enabled := false;

  sPathFolder := ExtractFilePath(bed_Gui_CSV.Text);

  Nb:=FindFirst(sPathFolder+'*.*',faAnyFile,Ch);
  While Nb=0 do
  begin
    if (Ch.Attr and faDirectory)=0 then
      ChangeSep(sPathFolder + Ch.Name);
    Nb:=FindNext(Ch);
  end;
  FindClose(Ch);

  pb_Gui.Position := 0;
  bed_Gui_CSV.Enabled := true;
  rg_Gui.Enabled := true;
  btn_Gui_Execute.Enabled := true;
  Btn_Gui_Execute_All.Enabled := True;
  Btn_Sep_Execute_All.Enabled := True;
end;

procedure TFrm_Main.Btn_DelPrixVente_PVClick(Sender: TObject);
var
  sFilePath : string;
  cdsPrixVente,
  cdsPrixVenteKeep,
  cdsPrixVenteDel : TClientDataSet;
  slTmp,
  slTmpKeep,
  slTmpDel : TStringList;
  SearchList: Variant;
begin
  //Chemin
  sFilePath := Bed_PV_PrixVente.Text;

  slTmp := TStringList.Create;
  try
    slTmp.Clear;
    slTmp.LoadFromFile(sFilePath);   //Chargement du fichier
    slTmp.Insert(0,'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR;PX_VENTE;PXDEBASE');     //Ajout de l'en-tête
    slTmp.SaveToFile(sFilePath);     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsPrixVente := TClientDataSet.Create(nil);
  slTmpKeep := TStringList.Create;
  slTmpDel := TStringList.Create;
  try
    LoadDataSet('Prix de Vente',
                sFilePath,
                'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR;PX_VENTE;PXDEBASE', cdsPrixVente);

    cdsPrixVente.First;
    while not cdsPrixVente.Eof do
    begin
      if cdsPrixVente.FieldByName('NOMTAR').AsString = Ed_DelPrixVente_PV.Text then
        slTmpKeep.Add(cdsPrixVente.FieldByName('CODE_ART').AsString + ';' +           //CODE_ART
                      cdsPrixVente.FieldByName('CODE_TAILLE').AsString + ';' +        //CODE_TAILLE
                      cdsPrixVente.FieldByName('CODE_COUL').AsString + ';' +          //CODE_COUL
                      cdsPrixVente.FieldByName('NOMTAR').AsString + ';' +             //NOMTAR
                      cdsPrixVente.FieldByName('PX_VENTE').AsString + ';' +           //PX_VENTE
                      cdsPrixVente.FieldByName('PXDEBASE').AsString + ';')            //PXDEBASE
      else
        slTmpDel.Add( cdsPrixVente.FieldByName('CODE_ART').AsString + ';' +           //CODE_ART
                      cdsPrixVente.FieldByName('CODE_TAILLE').AsString + ';' +        //CODE_TAILLE
                      cdsPrixVente.FieldByName('CODE_COUL').AsString + ';' +          //CODE_COUL
                      cdsPrixVente.FieldByName('NOMTAR').AsString + ';' +             //NOMTAR
                      cdsPrixVente.FieldByName('PX_VENTE').AsString + ';' +           //PX_VENTE
                      cdsPrixVente.FieldByName('PXDEBASE').AsString + ';');           //PXDEBASE
      cdsPrixVente.Next;
    end;

    if FileExists(ExtractFilePath(sFilePath) + 'prix_vente_keep.csv') then
      DeleteFile(ExtractFilePath(sFilePath) + 'prix_vente_keep.csv');

    if FileExists(ExtractFilePath(sFilePath) + 'prix_vente_del.csv') then
      DeleteFile(ExtractFilePath(sFilePath) + 'prix_vente_del.csv');

    slTmpKeep.SaveToFile(ExtractFilePath(sFilePath) + 'prix_vente_keep.csv');
    slTmpDel.SaveToFile(ExtractFilePath(sFilePath) + 'prix_vente_del.csv');
  finally
    FreeAndNil(slTmpKeep);
    FreeAndNil(slTmpDel);
    FreeAndNil(cdsPrixVente);
  end;

  slTmp := TStringList.Create;
  try
    slTmp.Clear;
    slTmp.LoadFromFile(ExtractFilePath(sFilePath) + 'prix_vente_del.csv');   //Chargement du fichier
    slTmp.Insert(0,'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR;PX_VENTE;PXDEBASE');     //Ajout de l'en-tête
    slTmp.SaveToFile(ExtractFilePath(sFilePath) + 'prix_vente_del.csv');     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  slTmp := TStringList.Create;
  try
    slTmp.Clear;
    slTmp.LoadFromFile(ExtractFilePath(sFilePath) + 'prix_vente_keep.csv');   //Chargement du fichier
    slTmp.Insert(0,'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR;PX_VENTE;PXDEBASE');     //Ajout de l'en-tête
    slTmp.SaveToFile(ExtractFilePath(sFilePath) + 'prix_vente_keep.csv');     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsPrixVenteKeep := TClientDataSet.Create(nil);
  cdsPrixVenteDel := TClientDataSet.Create(nil);
  slTmpKeep := TStringList.Create;
  slTmpDel := TStringList.Create;
  SearchList := VarArrayCreate([0, 2], VarVariant);
  try
    LoadDataSet('Prix de Vente Keep',
                ExtractFilePath(sFilePath) + 'prix_vente_keep.csv',
                'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR;PX_VENTE;PXDEBASE', cdsPrixVenteKeep);

    LoadDataSet('Prix de Vente Del',
                ExtractFilePath(sFilePath) + 'prix_vente_del.csv',
                'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR;PX_VENTE;PXDEBASE', cdsPrixVenteDel);

    cdsPrixVenteDel.First;
    while not cdsPrixVenteDel.Eof do
    begin
      SearchList[0] := cdsPrixVenteDel.FieldByName('CODE_ART').AsString;
      SearchList[1] := cdsPrixVenteDel.FieldByName('CODE_TAILLE').AsString;
      SearchList[2] := cdsPrixVenteDel.FieldByName('CODE_COUL').AsString;
      if cdsPrixVenteKeep.Locate('CODE_ART;CODE_TAILLE;CODE_COUL', SearchList,[]) then
      begin
        slTmpDel.Add( cdsPrixVenteDel.FieldByName('CODE_ART').AsString + ';' +           //CODE_ART
                      cdsPrixVenteDel.FieldByName('CODE_TAILLE').AsString + ';' +        //CODE_TAILLE
                      cdsPrixVenteDel.FieldByName('CODE_COUL').AsString + ';' +          //CODE_COUL
                      cdsPrixVenteDel.FieldByName('NOMTAR').AsString + ';' +             //NOMTAR
                      cdsPrixVenteDel.FieldByName('PX_VENTE').AsString + ';' +           //PX_VENTE
                      cdsPrixVenteDel.FieldByName('PXDEBASE').AsString + ';');           //PXDEBASE
      end
      else
      begin
        if cdsPrixVenteDel.FieldByName('NOMTAR').AsString = 'GENERAL' then
          slTmpKeep.Add(cdsPrixVenteDel.FieldByName('CODE_ART').AsString + ';' +           //CODE_ART
                        cdsPrixVenteDel.FieldByName('CODE_TAILLE').AsString + ';' +        //CODE_TAILLE
                        cdsPrixVenteDel.FieldByName('CODE_COUL').AsString + ';' +          //CODE_COUL
                        Ed_DelPrixVente_PV.Text + ';' +                                    //NOMTAR
                        cdsPrixVenteDel.FieldByName('PX_VENTE').AsString + ';' +           //PX_VENTE
                        cdsPrixVenteDel.FieldByName('PXDEBASE').AsString + ';')            //PXDEBASE
        else
          slTmpDel.Add( cdsPrixVenteDel.FieldByName('CODE_ART').AsString + ';' +           //CODE_ART
                        cdsPrixVenteDel.FieldByName('CODE_TAILLE').AsString + ';' +        //CODE_TAILLE
                        cdsPrixVenteDel.FieldByName('CODE_COUL').AsString + ';' +          //CODE_COUL
                        cdsPrixVenteDel.FieldByName('NOMTAR').AsString + ';' +             //NOMTAR
                        cdsPrixVenteDel.FieldByName('PX_VENTE').AsString + ';' +           //PX_VENTE
                        cdsPrixVenteDel.FieldByName('PXDEBASE').AsString + ';');           //PXDEBASE
      end;
      cdsPrixVenteDel.Next;
    end;

    cdsPrixVenteKeep.First;
    while not cdsPrixVenteKeep.Eof do
    begin
      slTmpKeep.Add(cdsPrixVenteKeep.FieldByName('CODE_ART').AsString + ';' +           //CODE_ART
                    cdsPrixVenteKeep.FieldByName('CODE_TAILLE').AsString + ';' +        //CODE_TAILLE
                    cdsPrixVenteKeep.FieldByName('CODE_COUL').AsString + ';' +          //CODE_COUL
                    cdsPrixVenteKeep.FieldByName('NOMTAR').AsString + ';' +             //NOMTAR
                    cdsPrixVenteKeep.FieldByName('PX_VENTE').AsString + ';' +           //PX_VENTE
                    cdsPrixVenteKeep.FieldByName('PXDEBASE').AsString + ';');           //PXDEBASE
      cdsPrixVenteKeep.Next;
    end;

    if FileExists(ExtractFilePath(sFilePath) + 'prix_vente_keep_2.csv') then
      DeleteFile(ExtractFilePath(sFilePath) + 'prix_vente_keep_2.csv');

    if FileExists(ExtractFilePath(sFilePath) + 'prix_vente_del_2.csv') then
      DeleteFile(ExtractFilePath(sFilePath) + 'prix_vente_del_2.csv');

    slTmpKeep.SaveToFile(ExtractFilePath(sFilePath) + 'prix_vente_keep_2.csv');
    slTmpDel.SaveToFile(ExtractFilePath(sFilePath) + 'prix_vente_del_2.csv');

  finally
    FreeAndNil(slTmpKeep);
    FreeAndNil(slTmpDel);
    FreeAndNil(cdsPrixVenteKeep);
    FreeAndNil(cdsPrixVenteDel);
  end;

  slTmp := TStringList.Create;
  try
    slTmp.Clear;
    slTmp.LoadFromFile(ExtractFilePath(sFilePath) + 'prix_vente_keep_2.csv');   //Chargement du fichier
    slTmp.Insert(0,'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR;PX_VENTE;PXDEBASE');     //Ajout de l'en-tête
    slTmp.SaveToFile(ExtractFilePath(sFilePath) + 'prix_vente_keep_2.csv');     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsPrixVenteKeep := TClientDataSet.Create(nil);
  slTmpKeep := TStringList.Create;
  try
    LoadDataSet('Prix de Vente Keep',
                ExtractFilePath(sFilePath) + 'prix_vente_keep_2.csv',
                'CODE_ART;CODE_TAILLE;CODE_COUL;NOMTAR;PX_VENTE;PXDEBASE', cdsPrixVenteKeep);

    with cdsPrixVenteKeep.IndexDefs.AddIndexDef do
    begin
      Name := 'CODEARTIDX';
      Fields := 'CODE_ART;PXDEBASE';
      Options := [ixDescending, ixCaseInsensitive];
    end;
    cdsPrixVenteKeep.IndexName := 'CODEARTIDX';
    cdsPrixVenteKeep.First;
    while not cdsPrixVenteKeep.Eof do
    begin
      slTmpKeep.Add(cdsPrixVenteKeep.FieldByName('CODE_ART').AsString + ';' +           //CODE_ART
                    cdsPrixVenteKeep.FieldByName('CODE_TAILLE').AsString + ';' +        //CODE_TAILLE
                    cdsPrixVenteKeep.FieldByName('CODE_COUL').AsString + ';' +          //CODE_COUL
                    cdsPrixVenteKeep.FieldByName('NOMTAR').AsString + ';' +             //NOMTAR
                    cdsPrixVenteKeep.FieldByName('PX_VENTE').AsString + ';' +           //PX_VENTE
                    cdsPrixVenteKeep.FieldByName('PXDEBASE').AsString + ';');           //PXDEBASE
      cdsPrixVenteKeep.Next;
    end;

    if FileExists(ExtractFilePath(sFilePath) + 'prix_vente_keep_3.csv') then
      DeleteFile(ExtractFilePath(sFilePath) + 'prix_vente_keep_3.csv');

    slTmpKeep.SaveToFile(ExtractFilePath(sFilePath) + 'prix_vente_keep_3.csv');
  finally
    FreeAndNil(slTmpKeep);
    FreeAndNil(cdsPrixVenteKeep);
  end;

  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.Btn_AddPrixVente_PVClick(Sender: TObject);
var
  sFilePath : string;
  cdsPrixVente : TClientDataSet;
  slTmp : TStringList;
begin
  //Chemin
  sFilePath := Bed_PV_PrixVente.Text;

  slTmp := TStringList.Create;
  try
    slTmp.Clear;
    slTmp.LoadFromFile(sFilePath);   //Chargement du fichier
    slTmp.Insert(0,'CODE_ART;CODE_TAILLE;CODE_COUL;CODE_FOU;PXCATALOGUE;PX_ACHAT;FOU_PRINCIPAL;PXDEBASE');     //Ajout de l'en-tête
    slTmp.SaveToFile(sFilePath);     //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsPrixVente := TClientDataSet.Create(nil);
  slTmp := TStringList.Create;
  try
    LoadDataSet('Prix de Vente',
                sFilePath,
                'CODE_ART;CODE_TAILLE;CODE_COUL;CODE_FOU;PXDEBASE', cdsPrixVente);

    cdsPrixVente.First;
    while not cdsPrixVente.Eof do
    begin
      slTmp.Add(cdsPrixVente.FieldByName('CODE_ART').AsString + ';' +           //CODE_ART
                cdsPrixVente.FieldByName('CODE_TAILLE').AsString + ';' +        //CODE_TAILLE
                cdsPrixVente.FieldByName('CODE_COUL').AsString + ';' +          //CODE_COUL
                'GENERAL' + ';' +                                               //NOMTAT
                cdsPrixVente.FieldByName('PX_ACHAT').AsString + ';' +           //PX_VENTE
                cdsPrixVente.FieldByName('PXDEBASE').AsString + ';');           //PXDEBASE
      cdsPrixVente.Next;
    end;
  finally
    if FileExists(sFilePath) then
      DeleteFile(sFilePath);

    slTmp.SaveToFile(sFilePath);

    FreeAndNil(slTmp);
  end;
  //-----------------------------------
  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.Btn_RefGeneGinkoiaClick(Sender: TObject);
var
  bLocate : Boolean;
  sPath : string;
  sCodeArticle : string;
  sNomCouleur : string;
  iCodeCouleur : Integer;
  sMarque : string;
  sFournisseur : string;
  sRefFourn : string;
  cdsRelationMarque : TClientDataSet;
  cdsMarque : TClientDataSet;
  cdsArticle : TClientDataSet;
  cdsLog : TClientDataSet;
  slTmp : TStringList;
  slLog : TStringList;
begin
  //Chemin
  sPath := Bed_PathRefGeneGinkoia.Text + '\';

  slTmp := TStringList.Create;
  try
    //Ligne de Taille
    slTmp.Clear;
    slTmp.LoadFromFile(sPath + 'Article.csv');   //Chargement du fichier
    slTmp.Insert(0,'A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V');     //Ajout de l'en-tête
    slTmp.SaveToFile(sPath + 'Article.csv');      //Enregistrement du fichier
  finally
    FreeAndNil(slTmp);
  end;

  cdsArticle := TClientDataSet.Create(nil);
  cdsMarque := TClientDataSet.Create(nil);
  cdsLog := TClientDataSet.Create(nil);
  cdsLog.FieldDefs.Add('Marque',ftString,255);
  cdsLog.CreateDataSet;

  if ckbMarques.Checked then
    cdsRelationMarque := TClientDataSet.Create(nil);
  slTmp := TStringList.Create;
  slLog := TStringList.Create;
  try
    LoadDataSet('Article',
                sPath + 'Article.csv',
                'A;S', cdsArticle);

    LoadDataSet('Marque',
                sPath + 'Marque.csv',
                'MRK_NOM;FOU_NOM', cdsMarque);

    if ckbMarques.Checked then
      LoadDataSet('MarqueRelation',
                  sPath + 'RelationMarques.csv',
                  'MarqueAS;MarqueNosymag', cdsRelationMarque);

    cdsArticle.First;
    bLocate := False;
    sMarque := '';
    while not cdsArticle.Eof do
    begin
      if sMarque <> cdsArticle.FieldByName('E').AsString then
      begin
        sMarque := cdsArticle.FieldByName('E').AsString;
        bLocate := cdsMarque.Locate('MRK_NOM',sMarque,[]);
        sFournisseur := cdsMarque.FieldByName('FOU_NOM').AsString;
      end;

      if not bLocate then
      begin
        if ckbMarques.Checked then
          bLocate := cdsRelationMarque.Locate('MarqueAS',sMarque,[]);

        if not bLocate then
        begin
          //slLog.Add(cdsArticle.FieldByName('A').AsString + ';' +
          //          cdsArticle.FieldByName('B').AsString + ';' +
          //          cdsArticle.FieldByName('C').AsString + ';' +
          //          cdsArticle.FieldByName('E').AsString);
          sMarque := 'SANSMARQUE';
          sFournisseur := 'GFOURNISSEUR';
          bLocate := cdsLog.Locate('Marque',cdsArticle.FieldByName('E').AsString,[]);
          if not bLocate then
          begin
            cdsLog.Insert;
            cdsLog.Fields[0].AsString := cdsArticle.FieldByName('E').AsString;
            cdsLog.Post;
          end;
        end
        else
        begin
          if ckbMarques.Checked then
            sMarque := cdsRelationMarque.FieldByName('MarqueNosymag').AsString;
          bLocate := cdsMarque.Locate('MRK_NOM',sMarque,[]);
          sFournisseur := cdsMarque.FieldByName('FOU_NOM').AsString;
          if not bLocate then
          begin
            //slLog.Add(cdsArticle.FieldByName('A').AsString + ';' +
            //          cdsArticle.FieldByName('B').AsString + ';' +
            //          cdsArticle.FieldByName('C').AsString + ';' +
            //          cdsArticle.FieldByName('E').AsString);
            sMarque := 'SANSMARQUE';
            sFournisseur := 'GFOURNISSEUR';
            bLocate := cdsLog.Locate('Marque',cdsArticle.FieldByName('E').AsString,[]);
            if not bLocate then
            begin
              cdsLog.Insert;
              cdsLog.Fields[0].AsString := cdsArticle.FieldByName('E').AsString;
              cdsLog.Post;
            end;
          end;
        end;
      end;

      if cdsArticle.FieldByName('B').AsString = '' then
        sRefFourn := cdsArticle.FieldByName('A').AsString
      else
        sRefFourn := cdsArticle.FieldByName('B').AsString;

      slTmp.Add(ed_CodeAdh_RG.Text + ';' +                                              //A : Identifiant du magasin
                ed_Bon_reception_RG.Text + ';' +                                        //B : Numéro du bon de réception
                ed_Saison_RG.Text + ';' +                                               //C : Saison
                ';' +                                                                   //D : Nom de la collection
                ';' +                                                                   //E : Frais de port HT
                ';' +                                                                   //F : Taux de TVA sur Frais de port
                cdsArticle.FieldByName('A').AsString + ';' +                            //G : Identifiant unique
                sRefFourn + ';' +                                                       //H : Référence Fournisseur
                cdsArticle.FieldByName('C').AsString + ';' +                            //I : Nom du modèle
                Ed_Secteur_RG.Text + ';' +                                              //J : Secteur
                Ed_Rayon_RG.Text + ';' +                                                //K : Rayon
                Ed_Famille_RG.Text + ';' +                                              //L : Famille
                Ed_SousFamille_RG.Text + ';' +                                          //M : Sous Famille
                sMarque + ';' +                                                         //N : Nom de la marque
                sFournisseur + ';' +                                                    //O : Nom du fournisseur
                cdsArticle.FieldByName('G').AsString + ';' +                            //P : Genre
                cdsArticle.FieldByName('H').AsString + ';' +                            //Q : Taux de tva
                cdsArticle.FieldByName('I').AsString + ';' +                            //R : Prix d’achat catalogue
                cdsArticle.FieldByName('J').AsString + ';' +                            //S : Prix d’achat net
                cdsArticle.FieldByName('K').AsString + ';' +                            //T : Prix de vente
                'UNITAILLE' + ';' +                                                     //U : ID Grille de taille
                'UNITAILLE' + ';' +                                                     //V : Nom grille de taille
                cdsArticle.FieldByName('O').AsString + ';' +                            //W : ID taille
                cdsArticle.FieldByName('O').AsString + ';' +                            //X : Nom de la taille
                cdsArticle.FieldByName('P').AsString + ';' +                            //Y : ID couleur
                cdsArticle.FieldByName('Q').AsString + ';' +                            //Z : Code de la couleur
                cdsArticle.FieldByName('R').AsString + ';' +                            //AA : Nom de la couleur
                cdsArticle.FieldByName('S').AsString + ';' +                            //AB : Code barre
                cdsArticle.FieldByName('T').AsString + ';' +                            //AC : Prix achat catalogue taille
                cdsArticle.FieldByName('U').AsString + ';' +                            //AD : Prix achat net taille
                cdsArticle.FieldByName('V').AsString + ';' +                            //AE : Prix de vente taille
                '0;' +                                                                  //AF : Qté réceptionnée
                ';' +                                                                   //AG : Classement 1
                ';' +                                                                   //AH : Classement 2
                ';' +                                                                   //AI : Classement 3
                ';' +                                                                   //AJ : Classement 4
                ';' +                                                                   //AK : Classement 5
                '');                                                                    //AL : Modèle CC
      cdsArticle.Next;
    end;

    if FileExists(sPath + 'LogMarque.csv') then
      DeleteFile(sPath + 'LogMarque.csv');
    if FileExists(sPath + 'Article_2.csv') then
      DeleteFile(sPath + 'Article_2.csv');
    slLog.SaveToFile(sPath + 'LogMarque.csv');
    slTmp.SaveToFile(sPath + 'Article_2.csv');

    slLog.Clear;
    cdsLog.First;
    while not cdsLog.Eof do
    begin
      slLog.Add(cdsLog.FieldByName('Marque').AsString);
      cdsLog.Next;
    end;
    slLog.SaveToFile(sPath + 'Marque_Manquante.csv');

    if slTmp <> nil then
      FreeAndNil(slTmp);

    if slLog <> nil then
      FreeAndNil(slLog);

    if cdsMarque <> nil then
      FreeAndNil(cdsMarque);

    if cdsLog <> nil then
      FreeAndNil(cdsLog);

    if cdsArticle <> nil then
      FreeAndNil(cdsArticle);

    if cdsRelationMarque <> nil then
      FreeAndNil(cdsRelationMarque);

    if ckb_Code_Couleur_RG.Checked then
    begin
      slTmp := TStringList.Create;
      try
        //Ligne de Taille
        slTmp.Clear;
        slTmp.LoadFromFile(sPath + 'Article_2.csv');   //Chargement du fichier
        slTmp.Insert(0,'A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;AA;AB;AC;AD;AE;AF;AG;AH;AI;AJ;AK;AL');     //Ajout de l'en-tête
        slTmp.SaveToFile(sPath + 'Article_2.csv');      //Enregistrement du fichier
      finally
        FreeAndNil(slTmp);
      end;

      if cdsArticle <> nil then
        FreeAndNil(cdsArticle);
      cdsArticle := TClientDataSet.Create(nil);

      slTmp := TStringList.Create;
      try
        LoadDataSet('Article',
                    sPath + 'Article_2.csv',
                    'G;AA', cdsArticle);

        cdsArticle.IndexDefs.Add('INDX', 'G;AA', []);
        cdsArticle.First;
        sCodeArticle := '';
        iCodeCouleur := 0;
        sNomCouleur := '';
        while not cdsArticle.eof do
        begin
          if (sCodeArticle = '') or (sCodeArticle <> cdsArticle.FieldByName('G').AsString) then
          begin
            iCodeCouleur := 0;
            sCodeArticle := cdsArticle.FieldByName('G').AsString;
            sNomCouleur := cdsArticle.FieldByName('AA').AsString;
          end
          else
          begin
            if (sNomCouleur <> cdsArticle.FieldByName('AA').AsString) then
            begin
              Inc(iCodeCouleur);
              sNomCouleur := cdsArticle.FieldByName('AA').AsString;
            end;
          end;

          slTmp.Add(cdsArticle.FieldByName('A').AsString + ';' +                //A : Identifiant du magasin
                    cdsArticle.FieldByName('B').AsString + ';' +                //B : Numéro du bon de réception
                    cdsArticle.FieldByName('C').AsString + ';' +                //C : Saison
                    cdsArticle.FieldByName('D').AsString + ';' +                //D : Nom de la collection
                    cdsArticle.FieldByName('E').AsString + ';' +                //E : Frais de port HT
                    cdsArticle.FieldByName('F').AsString + ';' +                //F : Taux de TVA sur Frais de port
                    cdsArticle.FieldByName('G').AsString + ';' +                //G : Identifiant unique
                    cdsArticle.FieldByName('H').AsString + ';' +                //H : Référence Fournisseur
                    cdsArticle.FieldByName('I').AsString + ';' +                //I : Nom du modèle
                    cdsArticle.FieldByName('J').AsString + ';' +                //J : Secteur
                    cdsArticle.FieldByName('K').AsString + ';' +                //K : Rayon
                    cdsArticle.FieldByName('L').AsString + ';' +                //L : Famille
                    cdsArticle.FieldByName('M').AsString + ';' +                //M : Sous Famille
                    cdsArticle.FieldByName('N').AsString + ';' +                //N : Nom de la marque
                    cdsArticle.FieldByName('O').AsString + ';' +                //O : Nom du fournisseur
                    cdsArticle.FieldByName('P').AsString + ';' +                //P : Genre
                    cdsArticle.FieldByName('Q').AsString + ';' +                //Q : Taux de tva
                    cdsArticle.FieldByName('R').AsString + ';' +                //R : Prix d’achat catalogue
                    cdsArticle.FieldByName('S').AsString + ';' +                //S : Prix d’achat net
                    cdsArticle.FieldByName('T').AsString + ';' +                //T : Prix de vente
                    cdsArticle.FieldByName('U').AsString + ';' +                //U : ID Grille de taille
                    cdsArticle.FieldByName('V').AsString + ';' +                //V : Nom grille de taille
                    cdsArticle.FieldByName('W').AsString + ';' +                //W : ID taille
                    cdsArticle.FieldByName('X').AsString + ';' +                //X : Nom de la taille
                    cdsArticle.FieldByName('Y').AsString + ';' +                //Y : ID couleur
                    RightStr(Concat('00', IntToStr(iCodeCouleur)), 3) + ';' +   //Z : Code de la couleur
                    cdsArticle.FieldByName('AA').AsString + ';' +               //AA : Nom de la couleur
                    cdsArticle.FieldByName('AB').AsString + ';' +               //AB : Code barre
                    cdsArticle.FieldByName('AC').AsString + ';' +               //AC : Prix achat catalogue taille
                    cdsArticle.FieldByName('AD').AsString + ';' +               //AD : Prix achat net taille
                    cdsArticle.FieldByName('AE').AsString + ';' +               //AE : Prix de vente taille
                    cdsArticle.FieldByName('AF').AsString + ';' +               //AF : Qté réceptionnée
                    cdsArticle.FieldByName('AG').AsString + ';' +               //AG : Classement 1
                    cdsArticle.FieldByName('AH').AsString + ';' +               //AH : Classement 2
                    cdsArticle.FieldByName('AI').AsString + ';' +               //AI : Classement 3
                    cdsArticle.FieldByName('AJ').AsString + ';' +               //AJ : Classement 4
                    cdsArticle.FieldByName('AK').AsString + ';' +               //AK : Classement 5
                    cdsArticle.FieldByName('AL').AsString + ';');               //AL : Modèle CC
          cdsArticle.Next;
        end;
      finally
        if FileExists(sPath + 'Article_3.csv') then
          DeleteFile(sPath + 'Article_3.csv');
        slTmp.SaveToFile(sPath + 'Article_3.csv');
      end;
    end;
  finally
    if slTmp <> nil then
      FreeAndNil(slTmp);

    if slLog <> nil then
      FreeAndNil(slLog);

    if cdsMarque <> nil then
      FreeAndNil(cdsMarque);

    if cdsLog <> nil then
      FreeAndNil(cdsLog);

    if cdsArticle <> nil then
      FreeAndNil(cdsArticle);

    if cdsRelationMarque <> nil then
      FreeAndNil(cdsRelationMarque);
  end;
  //-----------------------------------
end;

procedure TFrm_Main.Bed_Base_HistoVenteGoSportChange(Sender: TObject);
begin
  if not FileExists( Bed_Base_HistoVenteGoSport.Text ) then
    exit;

  if Base.Connected then
    exit;

  Base.Close;
  Base.Params.Database := Bed_Base_HistoVenteGoSport.Text;  //Format( '127.0.0.1/3050:%s', [ Bed_Base_HistoVenteGoSport.Text ] );
  Base.Params.Add( 'user_name=SYSDBA' );
  Base.Params.Add( 'password=masterkey' );
  Base.Open;

  Cb_FixEAN_HistoVenteGoSport.Enabled := GetCommonEANLength > 0;
end;

procedure TFrm_Main.Bed_Base_HistoVenteGoSportRightButtonClick(Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'InterBase|*.ib';
    odTemp.Title := 'Choix de la base de données';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
    begin
      Bed_Base_HistoVenteGoSport.Text := odTemp.FileName;
      // Ouverture de la base GINKOIA
      if Trim( Bed_Base_HistoVenteGoSport.Text ) <> '' then
      begin
        Base.Close;
        Base.Params.Database := Bed_Base_HistoVenteGoSport.Text; //Format( '127.0.0.1/3050:%s', [ Bed_Base_HistoVenteGoSport.Text ] );
        Base.Params.Add('user_name=sysdba');
        Base.Params.Add('password=masterkey');
        try
          Base.Open;
          ShowMessage('Connexion à la base de données réussie.');
        Except on E:Exception do
          begin
            ShowMessage('Problème de connexion à la base de données : ' + E.Message);
          end;
        end;
      end;
    end;
  finally
    odTemp.Free;
  end;
end;


procedure TFrm_Main.Bed_CSV_DestRightButtonClick(Sender: TObject);
var
  sdTemp : TSaveDialog;
begin
  sdTemp := TSaveDialog.Create(self);
  try
    sdTemp.Filter := 'Fichier CSV|*.csv|Tous|*.*';
    sdTemp.Title := 'Choix du fichier CSV de destination';
    sdTemp.Options := [ofOverwritePrompt,ofPathMustExist,ofEnableSizing];
    sdTemp.DefaultExt := 'csv';
    if sdTemp.Execute then
      (Sender as TButtonedEdit).Text := sdTemp.FileName;
  finally
    sdTemp.Free;
  end;
end;

procedure TFrm_Main.Bed_CSV_RightButtonClick(Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Texte|*.txt;*.csv|Tous|*.*';
    odTemp.Title := 'Choix du fichier CSV Correspondant';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      (Sender as TButtonedEdit).Text := odTemp.FileName;
  finally
    odTemp.Free;
  end;
end;

procedure TFrm_Main.Bed_MigrationLaignel_PathRightButtonClick(Sender: TObject);
begin
  with TBrowseForFolder.Create(nil) do
  try
    Category := 'Base';
    Caption := 'Browse...';
    DialogCaption := 'Sélectionnez le répertoire des fichiers à traiter';
    BrowseOptions := [bifUseNewUI];
    if Execute and (Folder<>'') then
      TButtonedEdit(Sender).Text := Folder;
  finally
    Free;
  end;
end;

procedure TFrm_Main.Btn_CleanerClick(Sender: TObject);
begin
  try
    {$REGION 'Process Cleaning'}
    Btn_Cleaner.Enabled := False;
    if Assigned( ThreadCleaner ) then
      ThreadCleaner.Free;
    ThreadCleaner := TThread.CreateAnonymousThread(
      procedure
      begin
        try
          ProcLockingFile(
            procedure(FileStreamSource, FileStreamDest: TFileStream)
            var
              Dictionary: TDictionary<String,Variant>;
            begin
              Dictionary := TDictionary<String,Variant>.Create;
              try
                FileStreamToDictionary( ThreadCleaner, FileStreamSource, Dictionary, GetRegexCleaner, [] );
                DictionaryToFileStream( ThreadCleaner, Dictionary, FileStreamDest );
              finally
                Dictionary.Free;
              end;
            end,
            Bed_PathFileCleaner.Text,
            ChangeFileExt( Bed_PathFileCleaner.Text, '.tmp' ),
            True,
            fmShareExclusive or fmOpenReadWrite,
            fmShareExclusive or fmCreate
          );
          {$REGION 'Update UI'}
          ThreadCleaner.Synchronize(
            ThreadCleaner,
            procedure
            begin
              ShowMessage('Traitement terminé.');
              Btn_Cleaner.Enabled := True;
            end
          );
          {$ENDREGION}
        except
          // Silence is golden
        end
      end
    );
    ThreadCleaner.FreeOnTerminate := False;
    ThreadCleaner.Start;
    {$ENDREGION 'Process Cleaning'}
  except
    on E: Exception do
      ShowMessage( E.Message );
  end;
end;

procedure TFrm_Main.Bed_TransferConsoRightButtonClick(Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Texte|*.txt;*.csv;*.sql|Tous|*.*';
    odTemp.Title := 'Choix Transfert/Conso Fichier';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
    begin
      Bed_TransferConso.Text := odTemp.FileName;
      sFile := Bed_TransferConso.Text;
    end;
  finally
    odTemp.Free;
  end;
end;

procedure TFrm_Main.FileStreamToDictionary(const Thread: TThread;
  const FileStream: TFileStream; const Dictionary: TDictionary<String,Variant>;
  const Pattern: String; const Options: TRegExOptions);
var
  StreamReader: TStreamReader;
  Match: TMatch;
begin
  StreamReader := TStreamReader.Create( FileStream );
  try
    while not StreamReader.EndOfStream do begin
      if Thread.CheckTerminated then
        raise EAbort.Create( 'Aborted' );

      Match := TRegEx.Match( StreamReader.ReadLine, Pattern, Options );
      if not Match.Success then
        continue;
      if Dictionary.ContainsKey( Match.Groups[ 1 ].Value ) then
        Dictionary[ Match.Groups[ 1 ].Value ] := Dictionary[ Match.Groups[ 1 ].Value ] or Match.Groups[ 2 ].Value
      else
        Dictionary.Add( Match.Groups[ 1 ].Value, Match.Groups[ 2 ].Value );
    end;
  finally
    StreamReader.Free;
  end;
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Lbx_CodeMag.Items.SaveToFile(ChangeFileExt(Application.ExeName, '.lst'));
  FreeAndNil(List_Tmp);
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True; // par défaut
  if Assigned(ThreadMigrationLaignel) then
  begin
    MessageDlg(
      Format('Traitement "%s" en cours...'#13#10'Veuillez l''annuler ou attendre qu''il se termine pour terminer l''application.', [ts_MigrationLaignel.Caption]),
      mtError, [mbOk], 0);
    pc_Traitement.ActivePage := ts_MigrationLaignel;
    CanClose := False;
  end;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  Lbx_CodeMag.Items.Clear;
  Lbx_CodeMag.Items.LoadFromFile(ChangeFileExt(Application.ExeName, '.lst'));
  Caption := Caption +' - Version '+ GetNumVersionSoft();
  Lbl_Etat_NettoyageMagasin.Caption := 'Traitement : ';
  lbl_Etat_Fid.Caption := 'Traitement : ';
  Dtp_Date_HistoVenteGoSport.Date := Now;

  List_Tmp := TStringList.Create;
  sFile := '';

  pc_Traitement.ActivePageIndex := 0;

  edtDefautEAN.Text := '';
  edtDefautEAN.Enabled := chkDefautEAN.Checked;
  cbbDefautEANType.Enabled := chkDefautEAN.Checked;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  if Assigned( ThreadCleaner ) then begin
    ThreadCleaner.Terminate;
    ThreadCleaner.WaitFor;
    ThreadCleaner.Free;
  end;
  if Assigned( ThreadHistoVente ) then begin
    ThreadHistoVente.Terminate;
    ThreadHistoVente.WaitFor;
    ThreadHistoVente.Free;
  end;
end;

function TFrm_Main.GetRegexCleaner: String;
begin
  Result := Concat(
    Lbl_RegexBeginOfKey.Caption,
    Ed_RegexKey.Text,
    Lbl_RegexEndOfKey.Caption,
    Ed_RegexDelimiter.Text,
    Lbl_RegexBeginOfValue.Caption,
    Ed_RegexValue.Text,
    Lbl_RegexEndOfValue.Caption,
    Ed_RegexDelimiterEOL.Text,
    Lbl_RegexEOL.Caption
  );
end;

procedure TFrm_Main.ProcLockingFile(const Proc: TProc<TFileStream, TFileStream, TFileStream>;
  const Filename, TemporaryFilename1, TemporaryFilename2: String; const Mode,
  TemporaryMode1, TemporaryMode2: Word; const Manage2: Boolean);
var
  Filestream, TemporaryFilestream1, TemporaryFilestream2: TFileStream;
begin
  try
    Filestream := TFileStream.Create( Filename, Mode, 0 );
    TemporaryFilestream1 := TFileStream.Create( TemporaryFilename1, TemporaryMode1, 0 );
    if Manage2 then
      TemporaryFilestream2 := TFileStream.Create( TemporaryFilename2, TemporaryMode2, 0 )
    else
      TemporaryFilestream2 := nil;
    try
      Proc( Filestream, TemporaryFilestream1, TemporaryFilestream2 );
    finally
      TemporaryFilestream1.Free;
      if Assigned( TemporaryFilestream2 ) then
        TemporaryFilestream2.Free;
      Filestream.Free;
    end;
  except
    raise
  end;
end;

end.
