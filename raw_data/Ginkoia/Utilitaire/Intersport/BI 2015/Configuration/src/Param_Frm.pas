unit Param_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Samples.Spin,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.Menus,
  FireDAC.Comp.Client,
  uGestionBDD;

type
  TInfosSite = class
  protected
    FId : integer;
    FIdent, FNom, FGUID : string;
    FActifH1, FActifH2, FActifBck : boolean;
    FHeure1, FHeure2, FBackup : TTime;
    FPLaceBase : string;
    // infosYellis
    FFound : boolean;
    FSpeDate : TDate;
    FSpeAFaire : boolean;
    procedure SetSpeAFaire(Value : boolean);
  public
    constructor Create(Id : integer; Ident, Nom, GUID : string; ActifH1, ActifH2, ActifBck : boolean; Heure1, Heure2, Backup : TTime; PLaceBase : string); reintroduce;
    procedure InitYellis(SpeDate : TDate);
    procedure FoundYellis();

    property Id : integer read FId;
    property Ident : string read FIdent;
    property Nom : string read FNom;
    property GUID : string read FGUID;
    property ActifH1 : boolean read FActifH1;
    property ActifH2 : boolean read FActifH2;
    property ActifBck : boolean read FActifBck;
    property Heure1 : TTime read FHeure1;
    property Heure2 : TTime read FHeure2;
    property Backup : TTime read FBackup;
    property PLaceBase : string read FPLaceBase;

    property Found : boolean read FFound;
    property SpeDate : TDate read FSpeDate;
    property SpeAFaire : boolean read FSpeAFaire write SetSpeAFaire;
  end;

  TInfosMag = class
  protected
    FId : integer;
    FCodeAdh, FNom, FEnseigne : string;

    FBasId : integer;
    FActif : boolean;
    FDateInit : TDateTime;
    FBaseTpn : string;
    FSpecif : string;
    // pour memoire !
    FIsModified : boolean;
    // accesseur
    procedure SetBasId(Value : integer);
    procedure SetActif(Value : boolean);
    procedure SetDateInit(Value : TDateTime);
    procedure SetBaseTpn(Value : string);
    procedure SetSpecif(Value : string);
  public
    constructor Create(Id : integer; CodeAdh, Nom, Enseigne : string; BasId : integer; Actif : boolean; DateInit : TDateTime; BaseTpn, Specif : string); reintroduce;
    procedure Reinit();

    property Id : integer read FId;
    property CodeAdh : string read FCodeAdh;
    property Nom : string read FNom;
    property Enseigne : string read FEnseigne;

    property BasId : integer read FBasId write SetBasId;
    property Actif : boolean read FActif write SetActif;
    property DateInit : TDateTime read FDateInit write SetDateInit;
    property BaseTpn : string read FBaseTpn write SetBaseTpn;
    property Specif : string read FSpecif write SetSpecif;

    property IsModified : boolean read FIsModified;
  end;

type
  Tfrm_Param = class(TForm)
    btn_Quitter: TButton;
    grp_Generaux: TGroupBox;
    lbl_Intervalle: TLabel;
    sed_Intervalle: TSpinEdit;
    lbl_ResetStock: TLabel;
    dtp_ResetStock: TDateTimePicker;
    lbl_NiveauLog: TLabel;
    cbx_NiveauLog: TComboBox;
    grp_SiteReplic: TGroupBox;
    pnl_Affectation: TGridPanel;
    pnl_NonAffecte: TPanel;
    lbl_NonAffecte: TLabel;
    lst_MagasinsNonAffecte: TListBox;
    pnl_Active: TPanel;
    lbl_Active: TLabel;
    lst_MagasinsActive: TListBox;
    pnl_Affecte: TPanel;
    lbl_Affecte: TLabel;
    lst_MagasinsAffecte: TListBox;
    pnl_CtrlActivation: TPanel;
    btn_UnActive: TSpeedButton;
    btn_DoActive: TSpeedButton;
    pnl_CtrlAffectation: TPanel;
    btn_UnAffecte: TSpeedButton;
    btn_DoAffecte: TSpeedButton;
    lbl_Magasins: TLabel;
    cbx_SiteReplic: TComboBox;
    grp_Initialisation: TGroupBox;
    pnl_DateInit: TGridPanel;
    dtp_DateInit: TDateTimePicker;
    dtp_TimeInit: TDateTimePicker;
    lbl_DateInit: TLabel;
    lbl_BaseTampon: TLabel;
    edt_BaseTampon: TEdit;
    btn_BaseTampon: TSpeedButton;
    chk_Initialisation: TCheckBox;
    btn_Save: TButton;
    lbl_HeuresReplication: TLabel;
    lbl_HeureBackup: TLabel;
    chk_CodeAdh: TCheckBox;
    chk_Nom: TCheckBox;
    chk_Enseigne: TCheckBox;
    pnl_YellisAlg: TPanel;
    chk_YellisAlg: TCheckBox;
    pm_ListeMags: TPopupMenu;
    mni_InitialiserMag: TMenuItem;
    mni_TrtSpecifiqueMag: TMenuItem;
    lbl_PlageStop: TLabel;
    GridPanel1: TGridPanel;
    dtp_PlageStopFin: TDateTimePicker;
    dtp_PlageStopDeb: TDateTimePicker;
    N1: TMenuItem;
    mni_Supprimer: TMenuItem;
    pnl_OnlyServeur: TPanel;
    chk_OnlyServeur: TCheckBox;
    grp_Rapprochement: TGroupBox;
    lbl_SiteRappro: TLabel;
    cbx_SiteRappro: TComboBox;
    chk_Rapprochement: TCheckBox;
    GroupBox1: TGroupBox;
    lbl_DureeVte: TLabel;
    lbl_DureeMvt: TLabel;
    lbl_DureeCmd: TLabel;
    lbl_DureeRap: TLabel;
    lbl_DureeStk: TLabel;
    se_DureeVte: TSpinEdit;
    se_DureeMvt: TSpinEdit;
    se_DureeCmd: TSpinEdit;
    se_DureeRap: TSpinEdit;
    se_DureeStk: TSpinEdit;
    btn_TrtDossier: TButton;
    pm_TrtDossier: TPopupMenu;
    mni_InitialiserDos: TMenuItem;
    mni_TrtSpecifiqueDos: TMenuItem;
    pnl_ForceCreate: TPanel;
    chk_ForceCreate: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure chk_OnlyServeurClick(Sender: TObject);
    procedure cbx_SiteReplicChange(Sender: TObject);
    procedure chk_LibelleMagClick(Sender: TObject);

    procedure btn_DoAffecteClick(Sender: TObject);
    procedure btn_DoActiveClick(Sender: TObject);
    procedure btn_UnActiveClick(Sender: TObject);
    procedure btn_UnAffecteClick(Sender: TObject);
    procedure chk_InitialisationClick(Sender: TObject);
    procedure chk_YellisAlgClick(Sender: TObject);
    procedure dtp_DateTimeInitChange(Sender: TObject);
    procedure edt_BaseTamponChange(Sender: TObject);
    procedure edt_BaseTamponKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btn_BaseTamponClick(Sender: TObject);
    procedure sed_IntervalleChange(Sender: TObject);
    procedure dtp_ResetStockChange(Sender: TObject);
    procedure cbx_NiveauLogChange(Sender: TObject);
    procedure dtp_PlageStopDebChange(Sender: TObject);
    procedure dtp_PlageStopFinChange(Sender: TObject);
    procedure cbx_SiteRapproChange(Sender: TObject);
    procedure se_DureeVteChange(Sender: TObject);
    procedure se_DureeMvtChange(Sender: TObject);
    procedure se_DureeCmdChange(Sender: TObject);
    procedure se_DureeRapChange(Sender: TObject);
    procedure se_DureeStkChange(Sender: TObject);

    procedure pm_ListeMagsPopup(Sender: TObject);
    procedure mni_InitialiserMagClick(Sender: TObject);
    procedure mni_TrtSpecifiqueMagClick(Sender: TObject);
    procedure mni_SupprimerClick(Sender: TObject);

    procedure btn_SaveClick(Sender: TObject);
    procedure btn_QuitterClick(Sender: TObject);
    procedure chk_RapprochementClick(Sender: TObject);
    procedure mni_InitialiserDosClick(Sender: TObject);
    procedure mni_TrtSpecifiqueDosClick(Sender: TObject);
    procedure btn_TrtDossierClick(Sender: TObject);
    procedure chk_ForceCreateClick(Sender: TObject);
  private
    { Déclarations privées }
  protected
    FServeur, FDatabase : string;
    // param de la base
    FCurrentBasID : Integer;
    FBasNomPourNous : string;
    // paramètre de site de rappro
    FSiteRappro : integer;
    // les Listes
    FInfosSite : TObjectDictionary<integer, TInfosSite>;
    FInfosMag : TObjectDictionary<integer, TInfosMag>;
    // en cours de chargement
    FLoading : boolean;
    // les paramètre existe t'il ?
    FHasParam6, FHasParam7, FHasParam8 : boolean;
    // refresh ??
    FHasToRefresh : boolean;

    function GetServeur() : string;
    procedure SetServeur(Value : string);
    function GetDataBase() : string;
    procedure SetDataBase(Value : string);

    function GetBestDateInit(InfosSite : TInfosSite) : TDateTime;
    function GetMagasinLibelle(InfosMag : TInfosMag) : string;

    procedure Load();
    procedure Save();

    procedure ShowBases();
    procedure ShowSites(InfosSite : TInfosSite);

    // boite de dialogue
    function MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : Integer;
  public
    { Déclarations publiques }
    property Serveur : string read GetServeur write SetServeur;
    property DataBase : string read GetDataBase write SetDataBase;
    property HasToRefresh : boolean read FHasToRefresh;
  end;

procedure DoParametrage(ParentFrm : TForm; BaseGnk : string; out HasToRefresh : boolean); overload;
procedure DoParametrage(ParentFrm : TForm; Serveur, BaseGnk : string; out HasToRefresh : boolean); overload;

implementation

uses
  System.Math,
  System.UITypes,
  System.DateUtils,
  System.StrUtils,
  FireDAC.Comp.Script,
  UPostXE7,
  DateChooser_Frm,
  TrtChooser_Frm,
  ULectureIniFile,
  uLog;

{$R *.dfm}

const
  LBL_HEURE_REPLIC_2 = 'Horaires de replication : %s et %s';
  LBL_HEURE_REPLIC_1 = 'Horaire de replication : %s';
  LBL_HEURE_REPLIC_0 = 'Pas d''heure de replication programmé';
  LBL_HEURE_BACKUP = 'Horaire du backup : %s';
  HINT_PLACE_BASE = 'Chemin de la base ginkoia : %s (CTRL + P  pour utiliser ce chemin)';

procedure DoParametrage(ParentFrm : TForm; BaseGnk : string; out HasToRefresh : boolean);
begin
  DoParametrage(ParentFrm, CST_BASE_SERVEUR, BaseGnk, HasToRefresh);
end;

procedure DoParametrage(ParentFrm : TForm; Serveur, BaseGnk : string; out HasToRefresh : boolean);
var
  Fiche : Tfrm_Param;
begin
  try
    Fiche := Tfrm_Param.Create(ParentFrm);
    Fiche.Serveur := Serveur;
    Fiche.DataBase := BaseGnk;
    Fiche.ShowModal();
    HasToRefresh := Fiche.HasToRefresh;
  finally
    FreeAndNil(Fiche);
  end;
end;

{ TInfosSite }

procedure TInfosSite.SetSpeAFaire(Value : boolean);
begin
  if (FSpeDate < 2) and not (FSpeAFaire = Value) then
    FSpeAFaire := Value;
end;

constructor TInfosSite.Create(Id : integer; Ident, Nom, GUID : string; ActifH1, ActifH2, ActifBck : boolean; Heure1, Heure2, Backup : TTime; PLaceBase : string);
begin
  inherited Create();
  FId := Id;
  FIdent := Ident;
  FNom := Nom;
  FGUID := GUID;
  FActifH1 := ActifH1;
  FActifH2 := ActifH2;
  FActifBck := ActifBck;
  FHeure1 := Frac(Heure1);
  FHeure2 := Frac(Heure2);
  FBackup := Frac(Backup);
  FPLaceBase := PLaceBase;

  FFound := false;
  FSpeDate := -1;
  FSpeAFaire := false;
end;

procedure TInfosSite.InitYellis(SpeDate : TDate);
begin
  FFound := true;
  FSpeDate := SpeDate;
end;

procedure TInfosSite.FoundYellis();
begin
  FFound := true;
end;

{ TInfosMag }

procedure TInfosMag.SetActif(Value : boolean);
begin
  if not (FActif = Value) then
  begin
    FActif := Value;
    FIsModified := true;
  end;
end;

procedure TInfosMag.SetDateInit(Value : TDateTime);
begin
  if not (FDateInit = Value) then
  begin
    FDateInit := Value;
    FIsModified := true;
  end;
end;

procedure TInfosMag.SetBaseTpn(Value : string);
begin
  if not (FBaseTpn = Value) then
  begin
    FBaseTpn := Value;
    FIsModified := true;
  end;
end;

procedure TInfosMag.SetSpecif(Value : string);
begin
  if not (FSpecif = Value) then
  begin
    FSpecif := Value;
    FIsModified := true;
  end;
end;

procedure TInfosMag.SetBasId(Value : integer);
begin
  if not (FBasId = Value) then
  begin
    FBasId := Value;
    FIsModified := true;
  end;
end;

constructor TInfosMag.Create(Id : integer; CodeAdh, Nom, Enseigne : string; BasId : integer; Actif : boolean; DateInit : TDateTime; BaseTpn, Specif : string);
begin
  inherited Create();
  FId := Id;
  FCodeAdh := CodeAdh;
  FNom := Nom;
  FEnseigne := Enseigne;
  // modifiable
  FBasId := BasId;
  FActif := Actif;
  FDateInit := DateInit;
  FBaseTpn := BaseTpn;
  FSpecif := Specif;
  // pour memoire
  FIsModified := false;
end;

procedure TInfosMag.Reinit();
begin
  FIsModified := false;
end;

{ Tfrm_Param }

procedure Tfrm_Param.FormCreate(Sender: TObject);
var
  Code, Nom, Enseigne, OnlyServeur : boolean;
begin
  FServeur := 'localhost';
  FDatabase := '';
  FCurrentBasID := 0;
  FBasNomPourNous := '';
  FSiteRappro := 0;
  FInfosSite := TObjectDictionary<integer, TInfosSite>.Create([doOwnsValues]);
  FInfosMag := TObjectDictionary<integer, TInfosMag>.Create([doOwnsValues]);
  FLoading := false;

  dtp_DateInit.Date := 0;
  dtp_DateInit.Time := EncodeTime(0, 0, 0, 1);
  dtp_TimeInit.Date := 0;
  dtp_TimeInit.Time := EncodeTime(0, 0, 0, 1);

  FHasParam6 := false;
  FHasParam7 := false;
  FHasParam8 := false;

  FHasToRefresh := false;

  // valeur par defaut d'affichage
  if ReadIniColonneParametrage(Code, Nom, Enseigne) then
  begin
    chk_CodeAdh.Checked := Code;
    chk_Nom.Checked := Nom;
    chk_Enseigne.Checked := Enseigne;
  end;
  if ReadIniOnlyServeur(OnlyServeur) then
    chk_OnlyServeur.Checked := OnlyServeur;
end;

procedure Tfrm_Param.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FInfosSite);
  FreeAndNil(FInfosMag);
  WriteIniColonneParametrage(chk_CodeAdh.Checked, chk_Nom.Checked, chk_Enseigne.Checked);
  WriteIniOnlyServeur(chk_OnlyServeur.Checked);
end;

// selection des infos

procedure Tfrm_Param.chk_OnlyServeurClick(Sender: TObject);
begin
  ShowBases();
end;

procedure Tfrm_Param.cbx_SiteReplicChange(Sender: TObject);
var
  InfosSite : TInfosSite;
begin
  if (cbx_SiteReplic.ItemIndex < 0) or (cbx_SiteReplic.ItemIndex >= cbx_SiteReplic.Items.Count) then
  begin
    FCurrentBasID := 0;
    lst_MagasinsActive.Items.Clear();
    lst_MagasinsAffecte.Items.Clear();
    lst_MagasinsNonAffecte.Items.Clear();
  end
  else
  begin
    InfosSite := TInfosSite(cbx_SiteReplic.Items.Objects[cbx_SiteReplic.ItemIndex]);
    if not (FCurrentBasID = InfosSite.Id) then
      ShowSites(InfosSite);
  end;
end;

procedure Tfrm_Param.chk_LibelleMagClick(Sender: TObject);
begin
  if not (chk_CodeAdh.Checked or chk_Nom.Checked or chk_Enseigne.Checked) then
    chk_Nom.Checked := true;
  if FInfosSite.ContainsKey(FCurrentBasID) then
    ShowSites(FInfosSite[FCurrentBasID]);
end;

// gestion des infos

procedure Tfrm_Param.btn_DoAffecteClick(Sender: TObject);
var
  InfosMag : TInfosMag;
  i, Res : integer;
  tmpDate : TDateTime;
begin
  if not btn_DoAffecte.Enabled then
    Exit;
  if FCurrentBasID = 0 then
    Exit;

  if lst_MagasinsNonAffecte.SelCount > 0 then
  begin
    // questions ;)
    if lst_MagasinsActive.Count > 0 then
    begin
      Res := MessageDlg('Vous ajoutez des magasins a un site déjà actif.'#13#10'Voulez-vous initialiser ces magasins ?', mtConfirmation, [mbYes, mbNo, mbCancel]);
      if Res = mrYes then
      begin
        tmpDate := GetBestDateInit(FInfosSite[FCurrentBasID]);
        if not SelectDate(tmpDate) then
          Res := mrCancel;
      end;
    end
    else
      Res := mrNo;

    // annulation ?
    if Res = mrCancel then
      Exit;

    // traitement
    for i := 0 to lst_MagasinsNonAffecte.Count -1 do
    begin
      if lst_MagasinsNonAffecte.Selected[i] then
      begin
        // recup du magasin
        InfosMag := TInfosMag(lst_MagasinsNonAffecte.Items.Objects[i]);
        if Trim(InfosMag.CodeAdh) = '' then
          MessageDlg('Vous ne pouvez pas affecter un magasin qui n''a pas de code adhérent.', mtError, [mbOK])
        else
        begin
          // doit on l'initialisé ?
          case Res of
            mrYes :
              begin
                InfosMag.BasId := FCurrentBasID;
                InfosMag.DateInit := tmpDate;
                InfosMag.BaseTpn := edt_BaseTampon.Text;
                btn_Save.Enabled := true;
              end;
            mrNo :
              begin
                InfosMag.BasId := FCurrentBasID;
                InfosMag.BaseTpn := edt_BaseTampon.Text;
                btn_Save.Enabled := true;
              end;
          end;
        end;
      end;
    end;
  end;
  ShowSites(FInfosSite[FCurrentBasID]);
end;

procedure Tfrm_Param.btn_DoActiveClick(Sender: TObject);
var
  InfosMag : TInfosMag;
  i, Res : integer;
  tmpDate : TDateTime;
begin
  if not btn_DoActive.Enabled then
    Exit;
  if FCurrentBasID = 0 then
    Exit;

  if Trim(edt_BaseTampon.Text) = '' then
  begin
    MessageDlg('Il n''y a de base tampon configurée pour ce site.'#13#10'veuillez configuré une base tampon avant d''activer des magasin.', mtError, [mbOK])
  end
  else
  begin
    if lst_MagasinsAffecte.SelCount > 0 then
    begin
      // questions ;)
      Res := MessageDlg('Les magasins que vous activés n''ont (peut-être) pas été initialisés.'#13#10'Voulez-vous initialiser ces magasins ?', mtConfirmation, [mbYes, mbNo, mbCancel]);
      if Res = mrYes then
      begin
        tmpDate := GetBestDateInit(FInfosSite[FCurrentBasID]);
        if not SelectDate(tmpDate) then
          Res := mrCancel;
      end;

      // annulation ?
      if Res = mrCancel then
        Exit;

      // traitement
      for i := 0 to lst_MagasinsAffecte.Count -1 do
      begin
        if lst_MagasinsAffecte.Selected[i] then
        begin
          // recup du magasin
          InfosMag := TInfosMag(lst_MagasinsAffecte.Items.Objects[i]);
          if Trim(InfosMag.CodeAdh) = '' then
            MessageDlg('Vous ne pouvez pas activer un magasin qui n''a pas de code adhérent.', mtError, [mbOK])
          else
          begin
            case Res of
              mrYes :
                begin
                  InfosMag.DateInit := tmpDate;
                  InfosMag.BaseTpn := edt_BaseTampon.Text;
                  btn_Save.Enabled := true;
                end;
              mrNo :
                begin
                  InfosMag.Actif := true;
                  InfosMag.DateInit := 0;
                  InfosMag.BaseTpn := edt_BaseTampon.Text;
                  btn_Save.Enabled := true;
                end;
            end;
          end;
        end;
      end;
    end;
    ShowSites(FInfosSite[FCurrentBasID]);
  end;
end;

procedure Tfrm_Param.btn_UnActiveClick(Sender: TObject);
var
  InfosMag : TInfosMag;
  i : integer;
begin
  if not btn_UnActive.Enabled then
    Exit;
  if FCurrentBasID = 0 then
    Exit;

  if lst_MagasinsActive.SelCount > 0 then
  begin
    for i := 0 to lst_MagasinsActive.Count -1 do
    begin
      if lst_MagasinsActive.Selected[i] then
      begin
        InfosMag := TInfosMag(lst_MagasinsActive.Items.Objects[i]);
        InfosMag.Actif := false;
        InfosMag.DateInit := 0;
        InfosMag.Specif := '';
      end;
    end;
  end;
  btn_Save.Enabled := true;
  ShowSites(FInfosSite[FCurrentBasID]);
end;

procedure Tfrm_Param.btn_UnAffecteClick(Sender: TObject);
var
  InfosMag : TInfosMag;
  i : integer;
begin
  if not btn_UnAffecte.Enabled then
    Exit;
  if FCurrentBasID = 0 then
    Exit;

  if lst_MagasinsAffecte.SelCount > 0 then
  begin
    for i := 0 to lst_MagasinsAffecte.Count -1 do
    begin
      if lst_MagasinsAffecte.Selected[i] then
      begin
        InfosMag := TInfosMag(lst_MagasinsAffecte.Items.Objects[i]);
        InfosMag.FBasId := 0;
        InfosMag.DateInit := 0;
        InfosMag.BaseTpn := '';
        InfosMag.Specif := '';
      end;
    end;
  end;
  btn_Save.Enabled := true;
  ShowSites(FInfosSite[FCurrentBasID]);
end;

procedure Tfrm_Param.chk_InitialisationClick(Sender: TObject);
var
  InfosMag : TInfosMag;
  tmpDate : TTime;
begin
  if FLoading then
  begin
    case chk_Initialisation.State of
      cbGrayed : grp_Initialisation.Color := clBtnShadow;
      else       grp_Initialisation.Color := clBtnFace;
    end;
    chk_YellisAlg.Repaint();
    chk_ForceCreate.Repaint();
  end
  else
  begin
    if chk_Initialisation.Checked then
    begin
      chk_ForceCreate.checked := false;
      chk_ForceCreate.Enabled := true;
      lbl_DateInit.Enabled := true;
      dtp_DateInit.Enabled := true;
      dtp_TimeInit.Enabled := true;
      if dtp_DateInit.Date + dtp_TimeInit.Time < 1 then
      begin
        tmpDate := GetBestDateInit(FInfosSite[FCurrentBasID]);
        dtp_DateInit.Date := Trunc(tmpDate);
        dtp_TimeInit.Time := Frac(tmpDate);
      end;
      lbl_BaseTampon.Enabled := true;
      edt_BaseTampon.Enabled := true;
      btn_BaseTampon.Enabled := true;
      if edt_BaseTampon.Text = '' then
        edt_BaseTampon.Text := ExtractFilePath(FInfosSite[FCurrentBasID].PLaceBase) + 'Tampon.ib';
      // marquage des base
      for InfosMag in FInfosMag.Values do
      begin
        if InfosMag.BasId = FCurrentBasID then
        begin
          InfosMag.Actif := false;
          InfosMag.DateInit := dtp_DateInit.Date + dtp_TimeInit.Time;
          InfosMag.Specif := '';
        end;
      end;
    end
    else
    begin
      chk_ForceCreate.checked := false;
      chk_ForceCreate.Enabled := false;
      lbl_DateInit.Enabled := false;
      dtp_DateInit.Enabled := false;
      dtp_TimeInit.Enabled := false;
      dtp_DateInit.Date := 0;
      dtp_TimeInit.Time := EncodeTime(0, 0, 0, 1);
      lbl_BaseTampon.Enabled := false;
      edt_BaseTampon.Enabled := false;
      btn_BaseTampon.Enabled := false;
      // marquage des base
      for InfosMag in FInfosMag.Values do
      begin
        if InfosMag.BasId = FCurrentBasID then
          InfosMag.DateInit := 0;
      end;
    end;
    btn_Save.Enabled := true;
    ShowSites(FInfosSite[FCurrentBasID]);
  end;
end;

procedure Tfrm_Param.chk_ForceCreateClick(Sender: TObject);
var
  InfosMag : TInfosMag;
begin
  if not FLoading then
  begin
    if chk_Initialisation.Checked then
    begin
      // marquage des base
      for InfosMag in FInfosMag.Values do
      begin
        if (InfosMag.BasId = FCurrentBasID) and not InfosMag.Actif and (InfosMag.DateInit > 2) then
        begin
          InfosMag.Specif := IfThen(chk_ForceCreate.Checked, '-CreateBase', '');
        end;
      end;
      btn_Save.Enabled := true;
      ShowSites(FInfosSite[FCurrentBasID]);
    end;
  end;
end;

procedure Tfrm_Param.chk_YellisAlgClick(Sender: TObject);
begin
  if FLoading then
    Exit;

  if chk_YellisAlg.Checked then
  begin
    if MessageDlg('Êtes vous sur de vouloir programmer l''ALG pour se site ?', mtConfirmation, [mbYes, mbNo]) = mrYes then
    begin
      FInfosSite[FCurrentBasID].SpeAFaire := true;
      btn_Save.Enabled := true;
    end;
  end
  else
  begin
    FInfosSite[FCurrentBasID].SpeAFaire := false;
  end;
end;

procedure Tfrm_Param.dtp_DateTimeInitChange(Sender: TObject);
var
  InfosMag : TInfosMag;
begin
  if FLoading then
    Exit;

  for InfosMag in FInfosMag.Values do
  begin
    if InfosMag.BasId = FCurrentBasID then
    begin
      if chk_Initialisation.Checked then
        InfosMag.DateInit := dtp_DateInit.Date + dtp_TimeInit.Time
      else
        InfosMag.DateInit := 0;
    end;
  end;
  btn_Save.Enabled := true;
  ShowSites(FInfosSite[FCurrentBasID]);
end;

procedure Tfrm_Param.edt_BaseTamponChange(Sender: TObject);
var
  InfosMag : TInfosMag;
begin
  if FLoading then
    Exit;

  for InfosMag in FInfosMag.Values do
  begin
    if InfosMag.BasId = FCurrentBasID then
      InfosMag.BaseTpn := edt_BaseTampon.Text;
  end;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.edt_BaseTamponKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and ((Key = Ord('P')) or (Key = Ord('p'))) then
    edt_BaseTampon.Text := ExtractFilePath(FInfosSite[FCurrentBasID].PLaceBase) + 'Tampon.ib';
end;

procedure Tfrm_Param.btn_BaseTamponClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_BaseTampon.Text);
    Open.InitialDir := ExtractFilePath(edt_BaseTampon.Text);
    Open.Filter := 'IB Database|*.IB';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'IB';
    edt_BaseTampon.Text := '';
    if Open.Execute() then
      edt_BaseTampon.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Param.sed_IntervalleChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.dtp_ResetStockChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.cbx_NiveauLogChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.dtp_PlageStopDebChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.dtp_PlageStopFinChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.chk_RapprochementClick(Sender: TObject);
begin
  if FLoading then
  begin
    case chk_Rapprochement.State of
      cbGrayed : grp_Rapprochement.Color := clBtnShadow;
      else       grp_Rapprochement.Color := clBtnFace;
    end;
  end
  else
  begin
    if chk_Rapprochement.Checked then
    begin
      lbl_SiteRappro.Enabled := true;
      cbx_SiteRappro.Enabled := true;
    end
    else
    begin
      lbl_SiteRappro.Enabled := false;
      cbx_SiteRappro.Enabled := false;
    end;
    btn_Save.Enabled := true;
    ShowSites(FInfosSite[FCurrentBasID]);
  end;
end;

procedure Tfrm_Param.cbx_SiteRapproChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.se_DureeVteChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.se_DureeMvtChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.se_DureeCmdChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.se_DureeRapChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

procedure Tfrm_Param.se_DureeStkChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  btn_Save.Enabled := true;
end;

// popup !

procedure Tfrm_Param.pm_ListeMagsPopup(Sender: TObject);
var
  UsedList : TListBox;
  i : integer;
  InfosMag : TInfosMag;
begin
  if FHasParam6 then
  begin
    if (pm_ListeMags.PopupComponent is TListBox) then
    begin
      UsedList := (pm_ListeMags.PopupComponent as TListBox);
      if UsedList.SelCount > 0 then
      begin
        pm_ListeMags.Tag := Integer(Pointer(UsedList));
        mni_InitialiserMag.Visible := (UsedList = lst_MagasinsActive) or (UsedList = lst_MagasinsAffecte);
        mni_TrtSpecifiqueMag.Visible := (UsedList = lst_MagasinsActive);
        // bouton de suppression ?
        for i := 0 to UsedList.Count -1 do
        begin
          if UsedList.Selected[i] then
          begin
            InfosMag := TInfosMag(UsedList.Items.Objects[i]);
            if (not InfosMag.Actif and (InfosMag.DateInit > 2) and (Trim(InfosMag.Specif) = '')) or // init
               (InfosMag.Actif and not (Trim(InfosMag.Specif) = '')) then                           // specif
            begin
              mni_Supprimer.Visible := true;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure Tfrm_Param.mni_InitialiserMagClick(Sender: TObject);
var
  UsedList : TListBox;
  i : integer;
  InfosMag : TInfosMag;
  tmpDate : TDateTime;
  Todo : boolean;
begin
  try
    if (pm_ListeMags.Tag <> 0)  then
    begin
      UsedList := TListBox(Pointer(pm_ListeMags.Tag));
      for i := 0 to UsedList.Count -1 do
      begin
        if UsedList.Selected[i] then
        begin
          InfosMag := TInfosMag(UsedList.Items.Objects[i]);
          tmpDate := GetBestDateInit(FInfosSite[FCurrentBasID]);
          Todo := true;
          // si un spécif programmé ?
          if InfosMag.Actif and not (Trim(InfosMag.Specif) = '') then
            Todo := MessageDlg('Un traitement spécifique est programmé pour ce magasin (' + GetMagasinLibelle(InfosMag) + ').'#13#10'Voulez-vous écraser ce traitement et faire l''initialisation ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
          // si une init programmé ?
          if not InfosMag.Actif and (InfosMag.DateInit > 2) and (Trim(InfosMag.Specif) = '') then
          begin
            Todo := MessageDlg('Une initialisation est déjà programmé pour ce magasin (' + GetMagasinLibelle(InfosMag) + ').'#13#10'Voulez-vous la modifier ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
            tmpDate := InfosMag.DateInit; // reprise de la date d'init !
          end;
          // a faire ?
          if Todo then
          begin
            if SelectDate(tmpDate) then
            begin
              InfosMag.BasId := FCurrentBasID;
              InfosMag.Actif := false;
              InfosMag.DateInit := tmpDate;
              InfosMag.BaseTpn := edt_BaseTampon.Text;
              InfosMag.Specif := '';
              btn_Save.Enabled := true;
            end;
          end;
        end;
      end;
    end;
  finally
    pm_ListeMags.Tag := 0;
    mni_InitialiserMag.Visible := false;
    mni_TrtSpecifiqueMag.Visible := false;
    mni_Supprimer.Visible := false;
  end;
  ShowSites(FInfosSite[FCurrentBasID]);
end;

procedure Tfrm_Param.mni_TrtSpecifiqueMagClick(Sender: TObject);
var
  UsedList : TListBox;
  i : integer;
  InfosMag : TInfosMag;
  tmpParams : string;
  tmpDate : TDateTime;
  Todo : boolean;
begin
  try
    if (pm_ListeMags.Tag <> 0) then
    begin
      UsedList := TListBox(Pointer(pm_ListeMags.Tag));
      for i := 0 to UsedList.Count -1 do
      begin
        if UsedList.Selected[i] then
        begin
          InfosMag := TInfosMag(UsedList.Items.Objects[i]);
          tmpParams := '';
          tmpDate := 0;
          Todo := true;
          // si une init programmé ?
          if not InfosMag.Actif and (InfosMag.DateInit > 2) and (Trim(InfosMag.Specif) = '') then
            Todo := MessageDlg('Une initialisation est programmé pour ce magasin (' + GetMagasinLibelle(InfosMag) + ').'#13#10'Voulez-vous supprimer cette initialisation et faire le traitement ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
          // si un spécif programmé ?
          if InfosMag.Actif and not (Trim(InfosMag.Specif) = '') then
          begin
            Todo := MessageDlg('Un traitement spécifique est déjà programmé pour ce magasin (' + GetMagasinLibelle(InfosMag) + ').'#13#10'Voulez-vous le modifier ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
            tmpParams := InfosMag.Specif; // reprise du traitement programmé !
            tmpDate := InfosMag.DateInit; // reprise de la date programmé !
          end;
          // a faire ?
          if Todo then
          begin
            if SelectTraitement(tmpParams, tmpDate) then
            begin
              InfosMag.DateInit := tmpDate;
              InfosMag.Specif := tmpParams;
              btn_Save.Enabled := true;
            end;
          end;
        end;
      end;
    end;
  finally
    pm_ListeMags.Tag := 0;
    mni_InitialiserMag.Visible := false;
    mni_TrtSpecifiqueMag.Visible := false;
    mni_Supprimer.Visible := false;
  end;
  ShowSites(FInfosSite[FCurrentBasID]);
end;

procedure Tfrm_Param.mni_SupprimerClick(Sender: TObject);
var
  UsedList : TListBox;
  i : integer;
  InfosMag : TInfosMag;
begin
  try
    if (pm_ListeMags.Tag <> 0) then
    begin
      UsedList := TListBox(Pointer(pm_ListeMags.Tag));
      for i := 0 to UsedList.Count -1 do
      begin
        if UsedList.Selected[i] then
        begin
          InfosMag := TInfosMag(UsedList.Items.Objects[i]);
          InfosMag.DateInit := 0;
          InfosMag.Specif := '';
          btn_Save.Enabled := true;
        end;
      end;
    end;
  finally
    pm_ListeMags.Tag := 0;
    mni_InitialiserMag.Visible := false;
    mni_TrtSpecifiqueMag.Visible := false;
    mni_Supprimer.Visible := false;
  end;
  ShowSites(FInfosSite[FCurrentBasID]);
end;

procedure Tfrm_Param.btn_TrtDossierClick(Sender: TObject);
var
  pt : TPoint;
begin
  pt.X := btn_TrtDossier.Left;
  pt.Y := btn_TrtDossier.Top + btn_TrtDossier.Height;
  pt := ClientToScreen(Pt);
  btn_TrtDossier.DropDownMenu.Popup(pt.x, pt.y);
end;

procedure Tfrm_Param.mni_InitialiserDosClick(Sender: TObject);
var
  InfosMag : TInfosMag;
  Todo, AskedSpe, AskedInit : boolean;
begin
  // init
  Todo := true;
  AskedSpe := false;
  AskedInit := false;

  // Question pour savoir si on continue
  for InfosMag in FInfosMag.Values do
  begin
    if InfosMag.Actif and not (Trim(InfosMag.Specif) = '') and AskedSpe then
    begin
      AskedSpe := true;
      Todo := MessageDlg('Un traitement spécifique est programmé pour ce magasin (' + GetMagasinLibelle(InfosMag) + ').'#13#10'Voulez-vous écraser ce traitement et faire l''initialisation ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
    end;
    // si une init programmé ?
    if not InfosMag.Actif and (InfosMag.DateInit > 2) and (Trim(InfosMag.Specif) = '') and AskedInit then
    begin
      AskedInit := true;
      Todo := MessageDlg('Une initialisation est déjà programmé pour ce magasin (' + GetMagasinLibelle(InfosMag) + ').'#13#10'Voulez-vous la modifier ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
    end;
    // si déja une reponse alors ..
    if not Todo then
      Break;
  end;

  if Todo then
  begin
    for InfosMag in FInfosMag.Values do
    begin
      InfosMag.Actif := false;
      InfosMag.DateInit := GetBestDateInit(FInfosSite[InfosMag.FBasId]);
      if Trim(InfosMag.BaseTpn) = '' then
        InfosMag.BaseTpn := ExtractFilePath(FInfosSite[FCurrentBasID].PLaceBase) + 'Tampon.ib';
      InfosMag.Specif := '';
    end;
    btn_Save.Enabled := true;
    ShowSites(FInfosSite[FCurrentBasID]);
  end;
end;

procedure Tfrm_Param.mni_TrtSpecifiqueDosClick(Sender: TObject);
var
  InfosMag : TInfosMag;
  tmpParams : string;
  tmpDate : TDateTime;
  Todo, AskedSpe, AskedInit : boolean;
begin
  // init
  Todo := true;
  AskedSpe := false;
  AskedInit := false;

  // Question pour savoir si on continue
  for InfosMag in FInfosMag.Values do
  begin
    // si une init programmé ?
    if not InfosMag.Actif and (InfosMag.DateInit > 2) and (Trim(InfosMag.Specif) = '') and AskedInit then
    begin
      AskedInit := true;
      Todo := MessageDlg('Une initialisation est programmé pour ce magasin (' + GetMagasinLibelle(InfosMag) + ').'#13#10'Voulez-vous supprimer cette initialisation et faire le traitement ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
    end;
    if InfosMag.Actif and not (Trim(InfosMag.Specif) = '') and AskedSpe then
    begin
      AskedSpe := true;
      Todo := MessageDlg('Un traitement spécifique est déjà programmé pour ce magasin (' + GetMagasinLibelle(InfosMag) + ').'#13#10'Voulez-vous le modifier ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
    end;
    // si déja une reponse alors ..
    if not Todo then
      Break;
  end;

  if Todo then
  begin
    if SelectTraitement(tmpParams, tmpDate) then
    begin
      for InfosMag in FInfosMag.Values do
      begin
        InfosMag.DateInit := tmpDate;
        InfosMag.Specif := tmpParams;
        btn_Save.Enabled := true;
      end;
    end;
    btn_Save.Enabled := true;
    ShowSites(FInfosSite[FCurrentBasID]);
  end;
end;

// boutons !

procedure Tfrm_Param.btn_SaveClick(Sender: TObject);
begin
  Save();
  Load();
end;

procedure Tfrm_Param.btn_QuitterClick(Sender: TObject);
var
  Ret : integer;
begin
  if btn_Save.Enabled then
  begin
    ret := MessageDlg('Vous avez des modifications en cours.'#13#10'Voulez-vous les enregistrées ?', mtInformation, [mbYes, mbNo, mbCancel]);
    if ret = mrYes then
      Save();
    if ret <> mrCancel then
      Close();
  end
  else
    Close();
end;

// accesseur

function Tfrm_Param.GetServeur() : string;
begin
  result := FServeur;
end;

procedure Tfrm_Param.SetServeur(Value : string);
begin
  if not (FServeur = Value) then
  begin
    FServeur := Value;

    if not ((Trim(FServeur) = '') or (Trim(FDatabase) = '')) then
      Load();
  end;
end;

function Tfrm_Param.GetDataBase() : string;
begin
  result := FDatabase;
end;

procedure Tfrm_Param.SetDataBase(Value : string);
begin
  if not (FDataBase = Value) then
  begin
    FDataBase := Value;

    if not ((Trim(FServeur) = '') or (Trim(FDatabase) = '')) then
      Load();
  end;
end;

// utilitaire

function Tfrm_Param.GetBestDateInit(InfosSite : TInfosSite) : TDateTime;
begin
  Result := 0;
  if InfosSite.ActifBck then
    Result := Frac(Max(Result, IncHour(InfosSite.Backup, 4)))
  else if InfosSite.ActifH1 then
    Result := Frac(Max(Result, IncHour(InfosSite.Heure1, 4)));
  if InfosSite.ActifH2 then
  begin
    if MinutesBetween(Result, InfosSite.Heure2) < 120 then
      Result := Frac(Max(Result, IncMinute(InfosSite.Heure2, 15)));
  end;
  if Result = 0 then
    Result := EncodeTime(4, 0, 0, 0);
  Result := Trunc(IncDay(Now())) + Result;
end;

function Tfrm_Param.GetMagasinLibelle(InfosMag : TInfosMag) : string;
begin
  Result := '';
  if chk_CodeAdh.Checked then
    if Result = '' then
      Result := InfosMag.CodeAdh
    else
      Result := Result + ' - ' + InfosMag.CodeAdh;
  if chk_Nom.Checked then
    if Result = '' then
      Result := InfosMag.Nom
    else
      Result := Result + ' - ' + InfosMag.Nom;
  if chk_Enseigne.Checked then
    if Result = '' then
      Result := InfosMag.Enseigne
    else
      Result := Result + ' - ' + InfosMag.Enseigne;
end;

// Base de données

procedure Tfrm_Param.Load();
var
  Connexion : TMyConnection;
  Query : TMyQuery;
  BaseIdent : string;
  InfosSite : TInfosSite;
  InfosMag : TInfosMag;
  Yellis : Tconnexion;
  Res : TStringList;
  i, IdSite : integer;
  tmpTimes : string;
  RapproAll, RapproOne : boolean;
begin
  try
    FLoading := true;
    BaseIdent := '';
    InfosSite := nil;
    Res := nil;
    tmpTimes := '';

    btn_Save.Enabled := false;
    cbx_SiteReplic.Items.Clear();
    cbx_SiteRappro.Items.Clear();
    FInfosSite.Clear();
    FInfosMag.Clear();

    // init !
    sed_Intervalle.Value := 15;
    dtp_ResetStock.Date := 0;
    dtp_ResetStock.Time := EncodeTime(21,30, 0, 0);
    cbx_NiveauLog.ItemIndex := 4;

    try
      //=========================================================================
      // recup des information de la base !

      Connexion := GetNewConnexion(FServeur, FDatabase, 'sysdba', 'masterkey', false);
      try
        Query := GetNewQuery(Connexion);
        try
          Connexion.Open();

          // la base en cours
          Query.SQL.Text := 'select par_string from genparambase where par_nom = ''IDGENERATEUR'';';
          try
            Query.Open();
            if not Query.Eof then
              BaseIdent := Query.FieldByName('par_string').AsString;
          finally
            Query.Close();
          end;

          // nom du dossier
          Query.SQL.Text := 'select bas_nompournous, count(*) from genbases join k on k_id = bas_id and k_enabled = 1 where bas_id != 0 group by bas_nompournous order by 2 rows 1;';
          try
            Query.Open();
            if not Query.Eof then
              FBasNomPourNous := Query.FieldByName('bas_nompournous').AsString;
          finally
            Query.Close();
          end;

          // Paramètre globaux (intervalle pour l'extraction, Niveau de log, horraire de stop, site pour le rapprochement auto, durées de rétention !)
          Query.SQL.Text := 'select prm_code, prm_integer, prm_float, prm_string '
                          + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                          + 'where prm_type = 25 and prm_code in (3, 4, 7, 8, 9, 10, 11, 12, 13);';
          try
            Query.Open();
            if Query.Eof then
              raise Exception.Create('Pas de paramètre trouver')
            else
            begin
              while not Query.Eof do
              begin
                case Query.FieldByName('prm_code').AsInteger of
                  03 :
                    begin
                      sed_Intervalle.Value := Query.FieldByName('prm_integer').AsInteger;
                      dtp_ResetStock.DateTime := Frac(TDateTime(Query.FieldByName('prm_float').AsFloat));
                    end;
                  04 :
                    begin
                      cbx_NiveauLog.ItemIndex := Query.FieldByName('prm_integer').AsInteger;
                    end;
                  07 :
                    begin
                      tmpTimes := Query.FieldByName('prm_string').AsString;
                      dtp_PlageStopDeb.DateTime := EncodeTime(StrToInt(Copy(tmpTimes, 1, 2)), StrToInt(Copy(tmpTimes, 4, 2)), 0, 0);
                      dtp_PlageStopFin.DateTime := EncodeTime(StrToInt(Copy(tmpTimes, 7, 2)), StrToInt(Copy(tmpTimes, 10, 2)), 0, 0);
                    end;
                  08 :
                    begin
                      FHasParam8 := true;
                      FSiteRappro := Query.FieldByName('prm_integer').AsInteger;
                    end;
                  09 : se_DureeVte.Value := Query.FieldByName('prm_integer').AsInteger;
                  10 : se_DureeMvt.Value := Query.FieldByName('prm_integer').AsInteger;
                  11 : se_DureeCmd.Value := Query.FieldByName('prm_integer').AsInteger;
                  12 : se_DureeRap.Value := Query.FieldByName('prm_integer').AsInteger;
                  13 : se_DureeStk.Value := Query.FieldByName('prm_integer').AsInteger;
                end;
                Query.Next()
              end;
            end;
          finally
            Query.Close();
          end;

          // gestion du rapprochement
          RapproAll := true;
          RapproOne := false;
          Query.SQL.Text := 'select mag_id, kugm.k_enabled '
                          + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                          + 'left join (uilgrpginkoiamag join k kugm on kugm.k_id = ugm_id '
                          + '           join uilgrpginkoia join k kugg on kugg.k_id = ugg_id and kugg.k_enabled = 1 on ugg_id = ugm_uggid '
                          + '          ) on ugm_magid = mag_id and ugg_nom = ''RAPPROCHEMENT AUTO'' '
                          + 'where mag_id != 0;';
          try
            Query.Open();
            while not Query.Eof do
            begin
              if Query.FieldByName('k_enabled').IsNull or (Query.FieldByName('k_enabled').AsInteger = 0) then
                RapproAll := false
              else
                RapproOne := true;
              Query.Next();
            end;
          finally
            Query.Close();
          end;
          if RapproAll then
            chk_Rapprochement.State := cbChecked
          else if RapproOne then
            chk_Rapprochement.State := cbGrayed
          else
            chk_Rapprochement.State := cbUnchecked;

          // pas de paramètre 7 ??
          if Trim(tmpTimes) = '' then
          begin
            FHasParam7 := false;
            dtp_PlageStopDeb.DateTime := dtp_ResetStock.DateTime;
            dtp_PlageStopFin.DateTime := EncodeTime(7, 0, 0, 0);
          end
          else
            FHasParam7 := true;

          // Liste des site de replic
          Query.SQL.Text := 'select bas_id, bas_ident, bas_nom, bas_guid, lau_h1, lau_h2, lau_back, lau_heure1, lau_heure2, lau_backtime, rep_placebase '
                          + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                          + 'left join genlaunch join k on k_id = lau_id and k_enabled = 1 on lau_basid = bas_id '
                          + 'left join genreplication join k on k_id = rep_id and k_enabled = 1 on rep_lauid = lau_id and rep_ordre > 0 '
                          + 'where bas_id != 0;';
          try
            Query.Open();
            while not Query.Eof do
            begin
              if not FInfosSite.ContainsKey(Query.FieldByName('bas_id').AsInteger) then
              begin
                InfosSite := TInfosSite.Create(Query.FieldByName('bas_id').AsInteger,
                                               Query.FieldByName('bas_ident').AsString,
                                               Query.FieldByName('bas_nom').AsString,
                                               Query.FieldByName('bas_guid').AsString,
                                               (Query.FieldByName('lau_h1').AsInteger = 1),
                                               (Query.FieldByName('lau_h2').AsInteger = 1),
                                               (Query.FieldByName('lau_back').AsInteger = 1),
                                               Frac(Query.FieldByName('lau_heure1').AsDateTime),
                                               Frac(Query.FieldByName('lau_heure2').AsDateTime),
                                               Frac(Query.FieldByName('lau_backtime').AsDateTime),
                                               Query.FieldByName('rep_placebase').AsString);
                FInfosSite.Add(InfosSite.Id, InfosSite);
              end;
              Query.Next();
              // site en cours ?
              if InfosSite.Ident = BaseIdent then
                FCurrentBasID := InfosSite.Id;
            end;
          finally
            Query.Close();
          end;

          // Liste des magasins
          Query.SQL.Text := 'select mag_id, mag_codeadh, mag_nom, mag_enseigne, prmactif.prm_integer as actif, prmactif.prm_float as dateinit, prmspecif.prm_string as specif, prmbase.prm_string as basetpn, prmaffect.prm_integer as bas_id '
                          + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                          + 'join genparam prmactif join k on k_id = prmactif.prm_id and k_enabled = 1 on prmactif.prm_type = 25 and prmactif.prm_code = 1 and prmactif.prm_magid = mag_id '
                          + 'join genparam prmaffect join k on k_id = prmaffect.prm_id and k_enabled = 1 on prmaffect.prm_type = 25 and prmaffect.prm_code = 2 and prmaffect.prm_magid = mag_id '
                          + 'join genparam prmbase join k on k_id = prmbase.prm_id and k_enabled = 1 on prmbase.prm_type = 25 and prmbase.prm_code = 5 and prmbase.prm_magid = mag_id '
                          + 'left join genparam prmspecif join k on k_id = prmspecif.prm_id and k_enabled = 1 on prmspecif.prm_type = 25 and prmspecif.prm_code = 6 and prmspecif.prm_magid = mag_id '
                          + 'where mag_id != 0;';
          try
            Query.Open();
            while not Query.Eof do
            begin
              if not ((Query.FieldByName('bas_id').AsInteger = 0) and (Trim(Query.FieldByName('mag_codeadh').AsString) = '')) then
              begin
                if Query.FieldByName('specif').IsNull then
                begin
                  FHasParam6 := false;
                  InfosMag := TInfosMag.Create(Query.FieldByName('mag_id').AsInteger,
                                               Query.FieldByName('mag_codeadh').AsString,
                                               Query.FieldByName('mag_nom').AsString,
                                               Query.FieldByName('mag_enseigne').AsString,
                                               Query.FieldByName('bas_id').AsInteger,
                                               (Query.FieldByName('actif').AsInteger = 1),
                                               TDateTime(Query.FieldByName('dateinit').AsFloat),
                                               Query.FieldByName('basetpn').AsString,
                                               '');
                end
                else
                begin
                  FHasParam6 := true;
                  InfosMag := TInfosMag.Create(Query.FieldByName('mag_id').AsInteger,
                                               Query.FieldByName('mag_codeadh').AsString,
                                               Query.FieldByName('mag_nom').AsString,
                                               Query.FieldByName('mag_enseigne').AsString,
                                               Query.FieldByName('bas_id').AsInteger,
                                               (Query.FieldByName('actif').AsInteger = 1),
                                               TDateTime(Query.FieldByName('dateinit').AsFloat),
                                               Query.FieldByName('basetpn').AsString,
                                               Query.FieldByName('specif').AsString);
                end;
                FInfosMag.Add(InfosMag.Id, InfosMag);
              end;
              Query.Next();
            end;
          finally
            Query.Close();
          end;
        finally
          FreeAndNil(Query);
        end;
      finally
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
        MessageDlg('Exception lors du chargement des paramètres : ' + #10#13 + e.ClassName + ' - ' + e.Message, mtError, [mbOK]);
        Exit;
      end;
    end;

    //=========================================================================
    // recup des information Yellis
    try
      try
        Yellis := Tconnexion.Create();
        try
          Res := Yellis.Select('select clients.id, clients.nom, clients.nompournous, clients.site, clients.clt_guid, coalesce(cast(spe_date as char), ''NULL'') as spe_date '
                             + 'from clients left join specifique on specifique.spe_cltid = clients.id and specifique.spe_fichier like ''OUTILSBI.ALG'' '
                             + 'where nompournous like ' + QuotedStr(FBasNomPourNous) + ';');
          for i := 0 to Yellis.recordCount(Res) -1 do
          begin
            for IdSite in FInfosSite.Keys do
            begin
              if FInfosSite[IdSite].GUID = Yellis.UneValeur(Res, 'clt_guid', i) then
              begin
                if (Yellis.UneValeur(Res, 'spe_date', i) = 'NULL') then
                  FInfosSite[IdSite].FoundYellis()
                else
                  FInfosSite[IdSite].InitYellis(ISO8601ToDate(Yellis.UneValeur(Res, 'spe_date', i)));
                Break;
              end;
            end;
          end;
        finally
          Yellis.FreeResult(Res);
        end;
      finally
        FreeAndNil(Yellis);
      end;
    except
      on e : Exception do
        MessageDlg('Exception lors de la récupération des information Yellis : ' + #10#13 + e.ClassName + ' - ' + e.Message, mtError, [mbOK]);
    end;

    //=========================================================================
    // affichage du libelle !
    if Trim(FBasNomPourNous) = '' then
      Self.Caption := 'Paramétrage'
    else
      Self.Caption := 'Paramétrage (Dossier : ' + FBasNomPourNous + ')';
  finally
    FLoading := false;
  end;

  // affichage
  ShowBases();
end;

procedure Tfrm_Param.Save();
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  Querylst, QueryMaj : TMyQuery;
  InfosSite : TInfosSite;
  InfosMag : TInfosMag;
  PrmId, UggId, UgmId : integer;
  Yellis : Tconnexion;
begin
  FHasToRefresh := true;
  PrmId := 0;
  UggId := 0;

  //===========================================================================
  // Sauvegarde du paramétrage base !
  Connexion := GetNewConnexion(FServeur, FDatabase, CST_BASE_LOGIN, CST_BASE_PASSWORD, false);
  try
    Transaction := GetNewTransaction(Connexion, false);
    try
      Connexion.Open();
      Transaction.StartTransaction();
      try
        PrmId := 0;
        QueryMaj := GetNewQuery(Connexion, Transaction);
        Querylst := GetNewQuery(Connexion, Transaction);

        try
{$REGION '          Paramètres du BI '}
          // Gestion du BI
          Querylst.SQL.Text := 'select prm_id, prm_magid, prm_code, prm_integer, prm_float, prm_string '
                             + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                             + 'where prm_type = 25;';
          try
            // liste des paramètre
            Querylst.Open();
            if Querylst.Eof then
              MessageDlg('Les paramètres n''existe pas pour ce dossier !!', mtWarning, [mbOK])
            else
            begin
              while not Querylst.Eof do
              begin
                // ID
                PrmId := Querylst.FieldByName('prm_id').AsInteger;
                // general ou au magasin ?
                if Querylst.FieldByName('prm_magid').AsInteger = 0 then
                begin
{$REGION '                  Paramètre généraux '}
                  // paramètre généraux
                  case Querylst.FieldByName('prm_code').AsInteger of
                    03 : // Intervalle de temps entre deux export + heure d'export de stock
                      if not ((sed_Intervalle.Value = Querylst.FieldByName('prm_integer').AsInteger) and (dtp_ResetStock.DateTime = TDateTime(Querylst.FieldByName('prm_code').AsFloat))) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(sed_Intervalle.Value) + ', prm_float = ' + StringReplace(FloatToStr(Double(dtp_ResetStock.Time)), FormatSettings.DecimalSeparator, '.', []) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                    04 : // Niveau de log
                      if not (cbx_NiveauLog.ItemIndex = Querylst.FieldByName('prm_integer').AsInteger) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(cbx_NiveauLog.ItemIndex) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                    07 : // plage d'arret
                      if not (FormatDateTime('hh:nn', dtp_PlageStopDeb.Time) + '|' + FormatDateTime('hh:nn', dtp_PlageStopFin.Time) = Querylst.FieldByName('prm_string').AsString) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_string = ' + QuotedStr(FormatDateTime('hh:nn', dtp_PlageStopDeb.Time) + '|' + FormatDateTime('hh:nn', dtp_PlageStopFin.Time)) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                    08 : // site pour le rapprochement
                      if (cbx_SiteRappro.ItemIndex >= 0) and not (TInfosSite(cbx_SiteRappro.Items.Objects[cbx_SiteRappro.ItemIndex]).Id = Querylst.FieldByName('prm_integer').AsInteger) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(TInfosSite(cbx_SiteRappro.Items.Objects[cbx_SiteRappro.ItemIndex]).Id) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                    09 : // Durée de rétention (vente)
                      if not (se_DureeVte.Value = Querylst.FieldByName('prm_integer').AsInteger) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(se_DureeVte.Value) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                    10 : // Durée de rétention (mouvement)
                      if not (se_DureeMvt.Value = Querylst.FieldByName('prm_integer').AsInteger) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(se_DureeMvt.Value) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                    11 : // Durée de rétention (cross-canal)
                      if not (se_DureeCmd.Value = Querylst.FieldByName('prm_integer').AsInteger) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(se_DureeCmd.Value) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                    12 : // Durée de rétention (rapprochement)
                      if not (se_DureeRap.Value = Querylst.FieldByName('prm_integer').AsInteger) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(se_DureeRap.Value) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                    13 : // Durée de rétention (stock)
                      if not (se_DureeStk.Value = Querylst.FieldByName('prm_integer').AsInteger) then
                      begin
                        QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(se_DureeStk.Value) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                        QueryMaj.ExecSQL();
                        QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                        QueryMaj.ExecSQL();
                      end;
                  end;
{$ENDREGION}
                end
                else if FInfosMag.ContainsKey(Querylst.FieldByName('prm_magid').AsInteger) then
                begin
{$REGION '                  Paramètre magasin '}
                  // paramètre magasin !
                  InfosMag := FInfosMag[Querylst.FieldByName('prm_magid').AsInteger];
                  if Assigned(InfosMag) and InfosMag.IsModified then
                  begin
                    case Querylst.FieldByName('prm_code').AsInteger of
                      1 : // activation et date d'initialisation
                        if not ((InfosMag.Actif = (Querylst.FieldByName('prm_integer').AsInteger = 1)) and
                                (InfosMag.DateInit = TDateTime(Querylst.FieldByName('prm_float').AsFloat))) then
                        begin
                          QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IfThen(InfosMag.Actif, '1', '0') + ', prm_float = ' + StringReplace(FloatToStr(Double(InfosMag.DateInit)), FormatSettings.DecimalSeparator, '.', []) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                          QueryMaj.ExecSQL();
                          QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                          QueryMaj.ExecSQL();

                          if InfosMag.DateInit > 2 then
                          begin
                            // trame de log pour l'init !
                            try
                              Log.readIni();
                              Log.Srv := Log.Host;
                              Log.App := 'ExtractBI';
                              Log.MaxItems := 10000;
                              Log.Deboublonage := false;
                              log.SendOnClose := true;
                              Log.Open();
                              log.Doss := FBasNomPourNous;
                              Log.Log('Main', FInfosSite[InfosMag.BasId].GUID, IntToStr(InfosMag.ID), 'Status', 'En attente initialisation (le ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', InfosMag.DateInit) + ')', logInfo, true, SecondsBetween(Now(), InfosMag.DateInit), ltServer);
                              Log.Log('BI', FInfosSite[InfosMag.BasId].GUID, IntToStr(InfosMag.ID), 'Status', 'En attente initialisation (le ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', InfosMag.DateInit) + ')', logInfo, true, SecondsBetween(Now(), InfosMag.DateInit), ltServer);
                              Log.Log('Stock', FInfosSite[InfosMag.BasId].GUID, IntToStr(InfosMag.ID), 'Status', 'En attente initialisation (le ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', InfosMag.DateInit) + ')', logInfo, true, SecondsBetween(Now(), InfosMag.DateInit), ltServer);
                              Log.Log('Commandes', FInfosSite[InfosMag.BasId].GUID, IntToStr(InfosMag.ID), 'Status', 'En attente initialisation (le ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', InfosMag.DateInit) + ')', logInfo, true, SecondsBetween(Now(), InfosMag.DateInit), ltServer);
                              if FHasParam8 and (FSiteRappro = FInfosSite[InfosMag.BasId].ID) then
                                Log.Log('RapprAuto', FInfosSite[InfosMag.BasId].GUID, IntToStr(InfosMag.ID), 'Status', 'En attente initialisation (le ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', InfosMag.DateInit) + ')', logInfo, true, SecondsBetween(Now(), InfosMag.DateInit), ltServer);
                            finally
                              Log.Close();
                            end;
                          end;
                        end;
                      2 : // affectation avec le bas_id
                        if not (InfosMag.BasId = Querylst.FieldByName('prm_integer').AsInteger) then
                        begin
                          QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(InfosMag.BasId) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                          QueryMaj.ExecSQL();
                          QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                          QueryMaj.ExecSQL();
                        end;
                      5 : // chemin de la base tampon
                        if not (InfosMag.BaseTpn = Querylst.FieldByName('prm_string').AsString) then
                        begin
                          QueryMaj.SQL.Text := 'update genparam set prm_string = ' + QuotedStr(InfosMag.BaseTpn) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                          QueryMaj.ExecSQL();
                          QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                          QueryMaj.ExecSQL();
                        end;
                      6 : // traitement specifique
                        if not (InfosMag.Specif = Querylst.FieldByName('prm_string').AsString) then
                        begin
                          QueryMaj.SQL.Text := 'update genparam set prm_string = ' + QuotedStr(InfosMag.Specif) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                          QueryMaj.ExecSQL();
                          QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                          QueryMaj.ExecSQL();
                        end;
                    end;
                  end;
{$ENDREGION}
                end;
                Querylst.Next();
              end;
            end;
          finally
            Querylst.Close();
          end;
{$ENDREGION}

{$REGION '          Activation du rapprochement '}
          // Recuperation de l'ID du module
          QueryMaj.SQL.Text := 'select ugg_id from uilgrpginkoia join k on k_id = ugg_id and k_enabled = 1 where ugg_nom = ''RAPPROCHEMENT AUTO'';';
          try
            QueryMaj.open();
            if not QueryMaj.Eof then
              UggId := QueryMaj.FieldByName('ugg_id').AsInteger;
          finally
            QueryMaj.Close();
          end;

          if (UggId > 0) then
          begin
{$REGION '            Affectation du module aux magasins '}
            // Gestion du rapprochement
            Querylst.SQL.Text := 'select mag_id, ugm_id, kugm.k_enabled '
                               + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                               + 'left join (uilgrpginkoiamag join k kugm on kugm.k_id = ugm_id '
                               + '           join uilgrpginkoia join k kugg on kugg.k_id = ugg_id and kugg.k_enabled = 1 on ugg_id = ugm_uggid '
                               + '          ) on ugm_magid = mag_id and ugg_nom = ''RAPPROCHEMENT AUTO'' '
                               + 'where mag_id != 0;';
            try
              Querylst.Open();
              if Querylst.Eof then
                MessageDlg('Les paramètres n''existe pas pour ce dossier !!', mtWarning, [mbOK])
              else
              begin
                if chk_Rapprochement.Checked then
                begin
                  // on doit activé le module pour tous les magasin
                  while not Querylst.Eof do
                  begin
                    if Querylst.FieldByName('k_enabled').IsNull then
                    begin
                      UgmId := 0;
                      // créer le lien
                      QueryMaj.SQL.Text := 'select id from pr_newk(''UILGRPGINKOIAMAG'');';
                      try
                        QueryMaj.open();
                        if not QueryMaj.Eof then
                          UgmId := QueryMaj.FieldByName('id').AsInteger;
                      finally
                        QueryMaj.Close();
                      end;
                      if (UgmId > 0) then
                      begin
                        QueryMaj.SQL.Text := 'insert into uilgrpginkoiamag (ugm_id, ugm_magid, ugm_uggid, ugm_date) '
                                           + 'values (' + IntToStr(UgmId) + ', ' + Querylst.FieldByName('mag_id').AsString + ', ' + IntToStr(UggId) + ', ''2100-01-01'');';
                        QueryMaj.ExecSQL();
                      end;
                    end
                    else if (Querylst.FieldByName('k_enabled').AsInteger = 0) then
                    begin
                      // reactivé le lien
                      QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + Querylst.FieldByName('ugm_id').AsString + ', 2);';
                      QueryMaj.ExecSQL();
                    end;
                    Querylst.Next();
                  end;
                end
                else
                begin
                  // on doit desactivé le module pour tous les magasin
                  while not Querylst.Eof do
                  begin
                    if not Querylst.FieldByName('k_enabled').IsNull and (Querylst.FieldByName('k_enabled').AsInteger = 1) then
                    begin
                      // desactivé le lien
                      QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + Querylst.FieldByName('ugm_id').AsString + ', 1);';
                      QueryMaj.ExecSQL();
                    end;
                    Querylst.Next();
                  end;
                end;
              end;
            finally
              Querylst.Close();
            end;
{$ENDREGION}

{$REGION '            Les permissions '}
            // on rend visible les perimission
            if chk_Rapprochement.Checked then
            begin
              Querylst.SQL.Text := 'select ugl_perid, per_visible '
                                 + 'from uilgrpginkoial join k on k_id = ugl_id and k_enabled = 1 '
                                 + 'join uilpermissions join k on k_id = per_id and k_enabled = 1 on per_id = ugl_perid '
                                 + 'where ugl_uggid = ' + IntToStr(UggId) + ';';
              try
                Querylst.Open();
                while not Querylst.Eof do
                begin
                  if Querylst.FieldByName('per_visible').AsInteger = 1 then
                  begin
                    QueryMaj.SQL.Text := 'update uilpermissions set per_visible = 0 where per_id = ' + Querylst.FieldByName('ugl_perid').AsString + ';';
                    QueryMaj.ExecSQL();
                    QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + Querylst.FieldByName('ugl_perid').AsString + ', 0);';
                    QueryMaj.ExecSQL();
                  end;
                  Querylst.Next();
                end;
              finally
                Querylst.Close();
              end;
            end;
{$ENDREGION}
          end;
{$ENDREGION}
        finally
          FreeAndNil(Querylst);
          FreeAndNil(QueryMaj);
        end;

        // ici ? commit !
        Transaction.Commit();
      except
        on e : Exception do
        begin
          Transaction.Rollback();
          MessageDlg('Erreur lors de l''enregistrement des paramètre (prm_id = ' + IntToStr(PrmId) + ') : ' + #13#10 + e.ClassName + ' - ' + e.Message, mtError, [mbOK]);
          Exit;
        end;
      end;
    finally
      FreeAndNil(Transaction);
    end;
  finally
    FreeAndNil(Connexion);
  end;

  //===========================================================================
  // Sauvegarde du paramétrage YELLIS !
  try
    try
      Yellis := Tconnexion.Create();

      for InfosSite in FInfosSite.Values do
      begin
        if InfosSite.SpeAFaire then
        begin
          Yellis.ordre('insert into specifique (spe_cltid, spe_fichier, spe_fait, spe_date) '
                     + 'select id, ''OutilsBI.ALG'', 0, ''1899-12-30'' '
                     + 'from clients '
                     + 'where clt_guid = ' + QuotedStr(InfosSite.GUID) + ';');
        end;
      end;
    finally
      FreeAndNil(Yellis);
    end;
  except
    on e : Exception do
    begin
      MessageDlg('Erreur lors de l''enregistrement des paramètre (prm_id = ' + IntToStr(PrmId) + ') : ' + #13#10 + e.ClassName + ' - ' + e.Message, mtError, [mbOK]);
      Exit;
    end;
  end;
end;

// affichage

procedure Tfrm_Param.ShowBases();

  function GetIsServeur(InfosSite : TInfosSite) : boolean;
  begin
    Result := ((Copy(InfosSite.Nom, 1, 8) = 'SERVEUR_') and not (Copy(InfosSite.Nom, Length(InfosSite.Nom) -3, 4) = '-SEC'))
           or (InfosSite.Ident = '0');
  end;

var
  InfosSite : TInfosSite;
begin
  cbx_SiteReplic.Items.Clear();
  cbx_SiteRappro.Items.Clear();
  for InfosSite in FInfosSite.Values do
  begin
    if (not chk_OnlyServeur.Checked) or GetIsServeur(InfosSite) then
      cbx_SiteReplic.AddItem(InfosSite.Nom, InfosSite);
    if (not chk_OnlyServeur.Checked) or GetIsServeur(InfosSite) then
      cbx_SiteRappro.AddItem(InfosSite.Nom, InfosSite);
  end;
  if FCurrentBasID <> 0 then
    ShowSites(FInfosSite[FCurrentBasID]);
  if FSiteRappro <> 0 then
    cbx_SiteRappro.ItemIndex := cbx_SiteRappro.Items.IndexOfObject(FInfosSite[FSiteRappro]);
end;

procedure Tfrm_Param.ShowSites(InfosSite : TInfosSite);
var
  InfosMag : TInfosMag;
  tmpTpnActif, tmpTpnAffect : string;
  tmpDateInit : TDateTime;
  nbMag, nbInit, nbCreate, nbSpecif : integer;
begin
  try
    // init
    FLoading := true;
    lst_MagasinsActive.Items.Clear();
    lst_MagasinsAffecte.Items.Clear();
    lst_MagasinsNonAffecte.Items.Clear();

    chk_Initialisation.Checked := false;
    dtp_DateInit.DateTime := EncodeTime(0, 0, 0, 1);
    dtp_TimeInit.DateTime := EncodeTime(0, 0, 0, 1);
    edt_BaseTampon.Text := '';

    chk_RapprochementClick(nil);

    cbx_SiteReplic.ItemIndex := cbx_SiteReplic.Items.IndexOfObject(InfosSite);
    FCurrentBasID := InfosSite.Id;

    tmpTpnActif := '';
    tmpTpnAffect := '';
    tmpDateInit := 0;
    nbMag := 0;
    nbInit := 0;
    nbSpecif := 0;

    // les horaires de replic
    if InfosSite.ActifH1 and InfosSite.ActifH2 then
      lbl_HeuresReplication.Caption := Format(LBL_HEURE_REPLIC_2, [FormatDateTime('hh:nn:ss', InfosSite.Heure1), FormatDateTime('hh:nn:ss', InfosSite.Heure2)])
    else if InfosSite.ActifH1 then
      lbl_HeuresReplication.Caption := Format(LBL_HEURE_REPLIC_1, [FormatDateTime('hh:nn:ss', InfosSite.Heure1)])
    else if InfosSite.ActifH2 then
      lbl_HeuresReplication.Caption := Format(LBL_HEURE_REPLIC_1, [FormatDateTime('hh:nn:ss', InfosSite.Heure2)])
    else
      lbl_HeuresReplication.Caption := LBL_HEURE_REPLIC_0;
    // l'horaire du backup ?
    if InfosSite.ActifBck then
      lbl_HeureBackup.Caption := Format(LBL_HEURE_BACKUP, [FormatDateTime('hh:nn:ss', InfosSite.Backup)])
    else
      lbl_HeureBackup.Caption := '';
    // listing des magasin
    for InfosMag in FInfosMag.Values do
    begin
      // remplissage des listes
      if (InfosMag.BasId = FCurrentBasID) and InfosMag.Actif then
      begin
        Inc(nbMag);
        if not (Trim(InfosMag.Specif) = '') then
          Inc(nbSpecif);
        lst_MagasinsActive.AddItem(GetMagasinLibelle(InfosMag), InfosMag);
        tmpTpnActif := InfosMag.BaseTpn;
      end
      else if (InfosMag.BasId = FCurrentBasID) then
      begin
        Inc(nbMag);
        if InfosMag.DateInit > 2 then
          Inc(nbInit);
        if InfosMag.Specif = '-CreateBase' then
          Inc(nbCreate);
        lst_MagasinsAffecte.AddItem(GetMagasinLibelle(InfosMag), InfosMag);
        tmpTpnAffect := InfosMag.BaseTpn;
        tmpDateInit := InfosMag.DateInit;
      end
      else if (InfosMag.BasId = 0) and (Trim(InfosMag.CodeAdh) <> '') then
        lst_MagasinsNonAffecte.AddItem(GetMagasinLibelle(InfosMag), InfosMag);
    end;
    // chemin de base
    if not (Trim(tmpTpnActif) = '') then
      edt_BaseTampon.Text := tmpTpnActif
    else if not (Trim(tmpTpnAffect) = '') then
      edt_BaseTampon.Text := tmpTpnAffect;
    // init prevu ?
    if nbMag = nbInit then
    begin
      chk_Initialisation.Checked := ((tmpDateInit) > 2);
      chk_ForceCreate.Checked := (nbCreate > 0);
      dtp_DateInit.Date := Trunc(tmpDateInit);
      dtp_TimeInit.Time := Max(Frac(tmpDateInit), EncodeTime(0, 0, 0, 1));
    end
    else if (nbInit + nbSpecif > 0) then
      chk_Initialisation.State := cbGrayed
    else
      chk_Initialisation.Checked := false;
    // activation des items
    chk_ForceCreate.Enabled := chk_Initialisation.Checked;
    lbl_DateInit.Enabled := chk_Initialisation.Checked;
    dtp_DateInit.Enabled := chk_Initialisation.Checked;
    dtp_TimeInit.Enabled := chk_Initialisation.Checked;
    lbl_BaseTampon.Enabled := chk_Initialisation.Checked;
    edt_BaseTampon.Enabled := chk_Initialisation.Checked;
    btn_BaseTampon.Enabled := chk_Initialisation.Checked;
    // chemin de base ???
    edt_BaseTampon.Hint := Format(HINT_PLACE_BASE, [InfosSite.PLaceBase]);
    // Info YELLIS
    if InfosSite.Found then
    begin
      if InfosSite.SpeAFaire then
      begin
        chk_YellisAlg.Enabled := true;
        chk_YellisAlg.Checked := true;
      end
      else
      begin
        chk_YellisAlg.Enabled := InfosSite.SpeDate < 0;
        chk_YellisAlg.Checked := InfosSite.SpeDate >= 0;
      end;
    end
    else
    begin
      chk_YellisAlg.Enabled := false;
      chk_YellisAlg.Checked := false;
    end;
    // activations !
    lbl_PlageStop.Enabled := FHasParam7;
    dtp_PlageStopDeb.Enabled := FHasParam7;
    dtp_PlageStopFin.Enabled := FHasParam7;
    grp_Rapprochement.Enabled := FHasParam8;
    cbx_SiteRappro.Enabled := chk_Rapprochement.Checked;
    // base pantin ???
    btn_DoAffecte.Enabled := not (InfosSite.Ident = '0');
    btn_DoActive.Enabled := not (InfosSite.Ident = '0');
    btn_UnActive.Enabled := not (InfosSite.Ident = '0');
    btn_UnAffecte.Enabled := not (InfosSite.Ident = '0');
    chk_Initialisation.Enabled := not (InfosSite.Ident = '0');
    chk_YellisAlg.Enabled := chk_YellisAlg.Enabled and not (InfosSite.Ident = '0');
  finally
    FLoading := false;
  end;
end;

// dialogue

function Tfrm_Param.MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons): Integer;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
    try
      Position := poOwnerFormCenter;
      Result := ShowModal();
    finally
      Free;
    end;
end;

end.
