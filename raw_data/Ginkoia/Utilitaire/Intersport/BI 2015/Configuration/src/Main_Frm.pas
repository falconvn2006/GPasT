unit Main_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Menus;

type
  Tfrm_Main = class(TForm)
    lbl_Serveur: TLabel;
    edt_Serveur: TEdit;
    lbl_Database: TLabel;
    edt_Database: TEdit;
    pnl_Sep1: TPanel;
    lv_ListeDossiers: TListView;
    btn_Lister: TButton;
    btn_Fixe: TButton;
    pnl_Sep2: TPanel;
    btn_Quitter: TButton;
    btn_Parametrer: TButton;
    chk_AffMagasin: TCheckBox;
    pb_Dossiers: TProgressBar;
    btn_Refresh: TButton;
    pm_ListeDossier: TPopupMenu;
    btn_ListeMagasin: TButton;
    mni_Parametrer: TMenuItem;
    mni_ListeMagasins: TMenuItem;
    btn_ForceParam: TButton;
    mni_ForceParam: TMenuItem;
    mni_Refresh: TMenuItem;
    lbl_infosDossiers: TLabel;
    btn_Rapport: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure edt_ServeurExit(Sender: TObject);
    procedure edt_DatabaseExit(Sender: TObject);

    procedure lv_ListeDossiersColumnClick(Sender: TObject; Column: TListColumn);
    procedure lv_ListeDossiersCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lv_ListeDossiersChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure lv_ListeDossiersDblClick(Sender: TObject);
    procedure lv_ListeDossiersKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure pm_ListeDossierPopup(Sender: TObject);
    procedure mni_ParametrerClick(Sender: TObject);
    procedure mni_ListeMagasinsClick(Sender: TObject);
    procedure mni_ForceParamClick(Sender: TObject);
    procedure mni_RefreshClick(Sender: TObject);

    procedure btn_ListerClick(Sender: TObject);
    procedure btn_ParametrerClick(Sender: TObject);
    procedure btn_ListeMagasinClick(Sender: TObject);
    procedure btn_ForceParamClick(Sender: TObject);
    procedure btn_RefreshClick(Sender: TObject);
    procedure btn_RapportClick(Sender: TObject);

    procedure btn_FixeClick(Sender: TObject);
    procedure btn_QuitterClick(Sender: TObject);
  private
    { Déclarations privées }

    // chargement
    FLoading : boolean;
    // mode debug ?
    FIsDebug : boolean;
    // gestion du tri !
    FSortIdx : integer;

    // sauvegarde des nombres
    FNbDossier, FNbMagasin : integer;

    // traitement du programme !
    function TraitementListe(out error : string) : boolean;
    function TraitementFixe(out error : string) : boolean;
    //refresh d'un dossier
    function DoRefreshDossier(Item : TListItem; Nom, Serveur, FileBase : string; LstMag : boolean) : integer;
    // Init sur un dossier ?
    function HasInitDossier(Nom, Serveur, FileBase : string; All : boolean = false) : string;

    // affichage des totaux
    procedure ShowTotaux();
    // activation
    procedure GestionInterface(Enabled : Boolean);
    // acces BDD
    function CanConnect(Serveur, DataBaseFile : string) : boolean;

    // boite de dialogue
    function MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : Integer;
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses
  System.Math,
  System.StrUtils,
  System.UITypes,
  Winapi.ShellAPI,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait,
  IdGlobal,
  UpdateurFrm,
  Param_Frm,
  ListeMagasins_Frm,
  ForceParam_Frm,
  UGestionBDD,
  VersionInfo,
  ULectureIniFile;

{$R *.dfm}

const
  CST_DOMAINE = '.no-ip.org';
  CST_ACCESSIBLE = 'Accessible';
  CST_INACCESSIBLE = 'Inaccessible';
  // colonnes
  CST_COLONNE_NOM = 'Nom Groupe';
  CST_COLONNE_NBMAG = 'Nb Magasin';
  CST_COLONNE_INACTIF = 'Inactif';
  CST_COLONNE_AFFECTE = 'Non affecté';
  CST_COLONNE_SERVEUR = 'Serveur';
  CST_COLONNE_FICHIER = 'Fichier Base';

procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  i : integer;
  Serveur, Base : string;
  ShowMagasin : boolean;
begin
  FSortIdx := 0;
  FLoading := false;

  // version ?
  Caption := Caption + ' (v' + ReadFileVersion() + ')';
  // verification de la version sur la lame2 !
  VerificationMAJ(True);

  // valeur des Edits
  if ReadIniBaseConf(Serveur, Base) then
  begin
    edt_Serveur.Text := Serveur;
    edt_Database.Text := Base
  end;
  // nombre de magasin ou bien ?
  if ReadIniShowMagasin(ShowMagasin) then
    chk_AffMagasin.Checked := ShowMagasin;

  FIsDebug := false;
  for i := 1 to ParamCount() do
  begin
    if UpperCase(Trim(ParamStr(i))) = 'DEBUG' then
      FIsDebug := true;
  end;
{$IFDEF DEBUG}
  FIsDebug := true;
{$ENDIF}
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  btn_Lister.SetFocus();
  btn_Fixe.Visible := FIsDebug;
end;

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btn_Quitter.Enabled;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  WriteIniBaseConf(edt_Serveur.Text, edt_Database.Text);
  WriteIniShowMagasin(chk_AffMagasin.Checked);
end;

//

procedure Tfrm_Main.edt_ServeurExit(Sender: TObject);
begin
//  GestionInterface(True);
end;

procedure Tfrm_Main.edt_DatabaseExit(Sender: TObject);
begin
//  GestionInterface(True);
end;

//

procedure Tfrm_Main.lv_ListeDossiersColumnClick(Sender: TObject; Column: TListColumn);
begin
  try
    lv_ListeDossiers.SortType := stNone;
    if (Column.Index +1 = FSortIdx) then
      FSortIdx := -FSortIdx
    else
      FSortIdx := Column.Index +1;
  finally
    lv_ListeDossiers.SortType := stBoth;
  end;
end;

procedure Tfrm_Main.lv_ListeDossiersCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if FSortIdx = 0 then
    Compare := 0
  else
  begin
    if Abs(FSortIdx) = 1 then
      Compare := Sign(FSortIdx) * CompareStr(Item1.Caption, Item2.Caption)
    else
    begin
      if IsNumeric(Item1.SubItems[Abs(FSortIdx) -2]) and IsNumeric(Item2.SubItems[Abs(FSortIdx) -2]) then
        Compare := Sign(FSortIdx) * CompareValue(StrToFloat(Item1.SubItems[Abs(FSortIdx) -2]), StrToFloat(Item2.SubItems[Abs(FSortIdx) -2]))
      else
        Compare := Sign(FSortIdx) * CompareStr(Item1.SubItems[Abs(FSortIdx) -2], Item2.SubItems[Abs(FSortIdx) -2]);
    end;
  end;
end;

procedure Tfrm_Main.lv_ListeDossiersChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
  IdxAccessible : integer;
begin
  IdxAccessible := lv_ListeDossiers.Columns.Count -1;

  btn_Parametrer.Enabled := (lv_ListeDossiers.SelCount > 0) and (lv_ListeDossiers.Items[lv_ListeDossiers.ItemIndex].SubItems[IdxAccessible] = CST_ACCESSIBLE);
  btn_ListeMagasin.Enabled := (lv_ListeDossiers.SelCount > 0) and (lv_ListeDossiers.Items[lv_ListeDossiers.ItemIndex].SubItems[IdxAccessible] = CST_ACCESSIBLE);
  btn_ForceParam.Enabled := (lv_ListeDossiers.SelCount > 0) and (lv_ListeDossiers.Items[lv_ListeDossiers.ItemIndex].SubItems[IdxAccessible] = CST_ACCESSIBLE);
  btn_Refresh.Enabled := (lv_ListeDossiers.SelCount > 0);
  btn_Rapport.Enabled := (lv_ListeDossiers.SelCount > 0) and (lv_ListeDossiers.Items[lv_ListeDossiers.ItemIndex].SubItems[IdxAccessible] = CST_ACCESSIBLE);

  ShowTotaux();
end;

procedure Tfrm_Main.lv_ListeDossiersDblClick(Sender: TObject);
var
  DefautAction : integer;
begin
  ReadIniDefautAction(DefautAction);
  case DefautAction of
    1 : btn_ListeMagasinClick(Sender);
    2 : btn_ParametrerClick(Sender);
  end;
end;

procedure Tfrm_Main.lv_ListeDossiersKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lv_ListeDossiersDblClick(Sender)
  else if (Key = Ord('A')) and (Shift = [ssCtrl]) then
    lv_ListeDossiers.SelectAll();
end;

procedure Tfrm_Main.pm_ListeDossierPopup(Sender: TObject);
begin
  mni_Parametrer.Enabled := btn_Parametrer.Enabled;
  mni_ListeMagasins.Enabled := btn_ListeMagasin.Enabled;
  mni_ForceParam.Enabled := btn_ForceParam.Enabled;
  mni_Refresh.Enabled := btn_Refresh.Enabled;
end;

procedure Tfrm_Main.mni_ParametrerClick(Sender: TObject);
begin
  if btn_Parametrer.Enabled then
    btn_ParametrerClick(Sender);
end;

procedure Tfrm_Main.mni_ListeMagasinsClick(Sender: TObject);
begin
  if btn_ListeMagasin.Enabled then
    btn_ListeMagasinClick(Sender);
end;

procedure Tfrm_Main.mni_ForceParamClick(Sender: TObject);
begin
  if mni_ForceParam.Enabled then
    mni_ForceParamClick(Sender);
end;

procedure Tfrm_Main.mni_RefreshClick(Sender: TObject);
begin
  if mni_Refresh.Enabled then
    mni_RefreshClick(Sender);
end;

procedure Tfrm_Main.btn_ListerClick(Sender: TObject);
var
  error : string;
begin
  try
    GestionInterface(false);
    if TraitementListe(error) then
      lv_ListeDossiersColumnClick(lv_ListeDossiers, lv_ListeDossiers.Columns[0])
    else
      MessageDlg('Erreur lors du traitement : ' + error, mtError, [mbOK]);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_ParametrerClick(Sender: TObject);
var
  i, IdxDossier, IdxAccessible, IdxServer, IdxFichier : integer;
  HasMag, HasToRefresh : boolean;
  Item : TListItem;
begin
  try
    GestionInterface(false);
    IdxAccessible := lv_ListeDossiers.Columns.Count -1;
    IdxServer := lv_ListeDossiers.Columns.Count;
    IdxFichier := lv_ListeDossiers.Columns.Count +1;
    HasMag := false;

    if lv_ListeDossiers.SelCount > 0 then
    begin
      for i := 0 to lv_ListeDossiers.Columns.Count -1 do
        if IndexStr(lv_ListeDossiers.Columns[i].Caption, [CST_COLONNE_NBMAG, CST_COLONNE_INACTIF, CST_COLONNE_AFFECTE]) > 0 then
        begin
          HasMag := true;
          break
        end;

      try
        lv_ListeDossiers.Items.BeginUpdate();
        for IdxDossier := 0 to lv_ListeDossiers.Items.Count -1 do
        begin
          Item := lv_ListeDossiers.Items[IdxDossier];
          if Item.Selected then
          begin
            if (Item.SubItems[IdxAccessible] = CST_INACCESSIBLE) then
              MessageDlg('Dossier inaccessible', mtWarning, [mbOK])
            else
            begin
              DoParametrage(Self, Item.SubItems[IdxServer], Item.SubItems[IdxFichier], HasToRefresh);
              if HasMag and HasToRefresh then
                DoRefreshDossier(Item, Item.Caption, Item.SubItems[IdxServer], Item.SubItems[IdxFichier], HasMag);
            end;
          end;
        end;
      finally
        lv_ListeDossiers.Items.EndUpdate();
      end;
    end
    else
      MessageDlg('Pas de dossier sélectionné.', mtWarning, [mbOK]);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_ListeMagasinClick(Sender: TObject);
var
  i, IdxDossier, IdxAccessible, IdxServer, IdxFichier : integer;
  HasMag, HasToRefresh : boolean;
  Item : TListItem;
begin
  try
    GestionInterface(false);
    IdxAccessible := lv_ListeDossiers.Columns.Count -1;
    IdxServer := lv_ListeDossiers.Columns.Count;
    IdxFichier := lv_ListeDossiers.Columns.Count +1;
    HasMag := false;

    if lv_ListeDossiers.SelCount > 0 then
    begin
      for i := 0 to lv_ListeDossiers.Columns.Count -1 do
        if IndexStr(lv_ListeDossiers.Columns[i].Caption, [CST_COLONNE_NBMAG, CST_COLONNE_INACTIF, CST_COLONNE_AFFECTE]) > 0 then
        begin
          HasMag := true;
          break
        end;

      try
        lv_ListeDossiers.Items.BeginUpdate();
        for IdxDossier := 0 to lv_ListeDossiers.Items.Count -1 do
        begin
          Item := lv_ListeDossiers.Items[IdxDossier];
          if Item.Selected then
          begin
            if (Item.SubItems[IdxAccessible] = CST_INACCESSIBLE) then
              MessageDlg('Dossier inaccessible', mtWarning, [mbOK])
            else
            begin
              ShowListeMagasins(Self, Item.SubItems[IdxServer], Item.SubItems[IdxFichier], HasToRefresh);
              if HasMag and HasToRefresh then
                DoRefreshDossier(Item, Item.Caption, Item.SubItems[IdxServer], Item.SubItems[IdxFichier], HasMag);
            end;
          end;
        end;
      finally
        lv_ListeDossiers.Items.EndUpdate();
      end;
    end
    else
      MessageDlg('Pas de dossier sélectionné.', mtWarning, [mbOK]);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_ForceParamClick(Sender: TObject);
var
  IdxDossier, IdxAccessible, IdxServer, IdxFichier : integer;
  Fiche : Tfrm_ForceParam;
  Item : TListItem;
begin
  try
    GestionInterface(false);
    IdxAccessible := lv_ListeDossiers.Columns.Count -1;
    IdxServer := lv_ListeDossiers.Columns.Count;
    IdxFichier := lv_ListeDossiers.Columns.Count +1;

    if lv_ListeDossiers.SelCount > 0 then
    begin
      try
        Fiche := Tfrm_ForceParam.Create(Self);
        if Fiche.ShowModal() = mrOk then
        begin
          try
            lv_ListeDossiers.Items.BeginUpdate();
            for IdxDossier := 0 to lv_ListeDossiers.Items.Count -1 do
            begin
              Item := lv_ListeDossiers.Items[IdxDossier];
              if Item.Selected and (Item.SubItems[IdxAccessible] = CST_ACCESSIBLE) then
                Fiche.SaveForceParam(Item.SubItems[IdxServer], Item.SubItems[IdxFichier]);
            end;
          finally
            lv_ListeDossiers.Items.EndUpdate();
          end;
          MessageDlg('Traitement effectué.', mtConfirmation, [mbOK]);
        end;
      finally
        FreeAndNil(Fiche);
      end;
    end
    else
      MessageDlg('Pas de dossier sélectionné.', mtWarning, [mbOK]);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_RefreshClick(Sender: TObject);
var
  i, IdxDossier, IdxServer, IdxFichier : integer;
  HasMag : boolean;
  Item : TListItem;
begin
  try
    GestionInterface(false);
    IdxServer := lv_ListeDossiers.Columns.Count;
    IdxFichier := lv_ListeDossiers.Columns.Count +1;
    HasMag := false;

    if lv_ListeDossiers.SelCount > 0 then
    begin
      for i := 0 to lv_ListeDossiers.Columns.Count -1 do
        if IndexStr(lv_ListeDossiers.Columns[i].Caption, [CST_COLONNE_NBMAG, CST_COLONNE_INACTIF, CST_COLONNE_AFFECTE]) > 0 then
        begin
          HasMag := true;
          break
        end;

      try
        lv_ListeDossiers.Items.BeginUpdate();
        for IdxDossier := 0 to lv_ListeDossiers.Items.Count -1 do
        begin
          Item := lv_ListeDossiers.Items[IdxDossier];
          if Item.Selected then
            DoRefreshDossier(Item, Item.Caption, Item.SubItems[IdxServer], Item.SubItems[IdxFichier], HasMag);
        end;
      finally
        lv_ListeDossiers.Items.EndUpdate();
      end;
    end
    else
      MessageDlg('Pas de dossier sélectionné.', mtWarning, [mbOK]);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_RapportClick(Sender: TObject);
var
  IdxDossier, IdxAccessible, IdxServer, IdxFichier : integer;
  Rapport : TStringList;
  DoAll : boolean;
  Item : TListItem;
  Resultat : string;
  Save : TSaveDialog;
begin
  try
    GestionInterface(false);
    IdxAccessible := lv_ListeDossiers.Columns.Count -1;
    IdxServer := lv_ListeDossiers.Columns.Count;
    IdxFichier := lv_ListeDossiers.Columns.Count +1;

    if lv_ListeDossiers.SelCount > 0 then
    begin
      DoAll := MessageDlg('Voulez-vous tous les magasins ?', mtConfirmation, [mbYes, mbNo]) = mrYes;
      try
        Rapport := TStringList.Create();

        for IdxDossier := 0 to lv_ListeDossiers.Items.Count -1 do
        begin
          Item := lv_ListeDossiers.Items[IdxDossier];
          if Item.Selected and (Item.SubItems[IdxAccessible] = CST_ACCESSIBLE) then
          begin
            Resultat := HasInitDossier(Item.Caption, Item.SubItems[IdxServer], Item.SubItems[IdxFichier], DoAll);
            if not (trim(Resultat) = '') then
              Rapport.Add(Trim(Resultat));
          end;
        end;

        if Rapport.Count > 0 then
        begin
          Save := TSaveDialog.Create(Self);
          Save.FileName := 'EtatInit.csv';
          Save.Filter := 'Fichier CSV';
          Save.DefaultExt := 'CSV';
          if Save.Execute() then
          begin
            Rapport.Insert(0, 'Dossier;Code Adherent;Nom;Enseigne;Actif;Modification du paramètre;;Sera initialisé le;;');
            Rapport.Insert(1, ';;;;;Date;Heure;Date;Heure;');
            Rapport.SaveToFile(Save.FileName);
            if MessageDlg('Voulez-vous ouvrir le fichier ?', mtConfirmation, [mbYes, mbNo]) = mrYes then
              ShellExecute(0, 'open', PChar(Save.FileName), '', '', SW_SHOW);
          end;
        end
        else
          MessageDlg('Pas d''initialisation programmé.', mtWarning, [mbOK]);
      finally
        FreeAndNil(Rapport);
      end;
    end
    else
      MessageDlg('Pas de dossier sélectionné.', mtWarning, [mbOK]);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_FixeClick(Sender: TObject);
var
  error : string;
begin
  try
    GestionInterface(false);
    if TraitementFixe(error) then
      MessageDlg('Traitement effectué correctement.', mtInformation, [mbOK])
    else
      MessageDlg('Erreur lors du traitement : ' + error, mtError, [mbOK]);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

// Traitement !

function Tfrm_Main.TraitementListe(out error : string) : boolean;
var
  Colonne : TListColumn;
  ConnexionMdc : TMyConnection;
  QueryMdc : TMyQuery;
  Serveur, FileBase : string;
  Item : TListItem;
begin
  result := false;
  error := '';
  lv_ListeDossiers.Items.Clear();
  lv_ListeDossiers.Columns.Clear();
  lv_ListeDossiers.SortType := stNone;
  FSortIdx := 0;
  // init des compteur
  FNbDossier := 0;
  FNbMagasin := 0;

  ConnexionMdc := nil;
  QueryMdc := nil;

  pb_Dossiers.Style := pbstMarquee;
  Application.ProcessMessages();

  try
    FLoading := true;
    lv_ListeDossiers.Items.BeginUpdate();

    // recréation de la liste des colonne !
    Colonne := lv_ListeDossiers.Columns.Add();
    Colonne.Caption := CST_COLONNE_NOM;
    Colonne.Width := 75;
    if chk_AffMagasin.Checked then
    begin
      Colonne := lv_ListeDossiers.Columns.Add();
      Colonne.Caption := CST_COLONNE_NBMAG;
      Colonne.Width := 70;
      Colonne := lv_ListeDossiers.Columns.Add();
      Colonne.Caption := CST_COLONNE_INACTIF;
      Colonne.Width := 50;
      Colonne := lv_ListeDossiers.Columns.Add();
      Colonne.Caption := CST_COLONNE_AFFECTE;
      Colonne.Width := 50;
    end;
    Colonne := lv_ListeDossiers.Columns.Add();
    Colonne.Caption := CST_COLONNE_SERVEUR;
    Colonne.Width := 50;
    Colonne := lv_ListeDossiers.Columns.Add();
    Colonne.Caption := CST_COLONNE_FICHIER;
    Colonne.Width := 70;

    try
      ConnexionMdc := GetNewConnexion(edt_Serveur.Text, edt_Database.Text, CST_BASE_LOGIN, CST_BASE_PASSWORD, false);
      try
        QueryMdc := GetNewQuery(ConnexionMdc);
        try
          ConnexionMdc.Open();
          QueryMdc.SQL.Text := 'select dos_nom, '
                             + 'upper(f_left(dos_basepath, f_substr('':'', dos_basepath))) as server, '
                             + 'upper(f_right(dos_basepath, f_stringlength(dos_basepath) - f_substr('':'', dos_basepath) -1)) as datafile '
                             + 'from dossiers '
                             + 'order by 2, 1' {$IFDEF DEBUG} + ' rows 5' {$ENDIF} + ';';
          QueryMdc.Open();
          if not QueryMdc.Eof then
          begin
            // pour le max !
            QueryMdc.Last();
            QueryMdc.First();

            pb_Dossiers.Style := pbstNormal;
            pb_Dossiers.Max := QueryMdc.RecordCount;
            Application.ProcessMessages();

            while not QueryMdc.Eof do
            begin
              pb_Dossiers.Hint := QueryMdc.FieldByName('dos_nom').AsString;
              Application.ProcessMessages();

              if Length(QueryMdc.FieldByName('server').AsString) = 1 then
              begin
                Serveur := edt_Serveur.Text;
                FileBase := QueryMdc.FieldByName('server').AsString + ':' + QueryMdc.FieldByName('datafile').AsString;
              end
              else
              begin
                Serveur := QueryMdc.FieldByName('server').AsString + CST_DOMAINE;
                FileBase := QueryMdc.FieldByName('datafile').AsString;
              end;

              Item := lv_ListeDossiers.Items.Add();
              Inc(FNbDossier);
              Inc(FNbMagasin, DoRefreshDossier(Item, QueryMdc.FieldByName('dos_nom').AsString, Serveur, FileBase, chk_AffMagasin.Checked));

              QueryMdc.Next();
              pb_Dossiers.StepIt();
              Application.ProcessMessages();
            end;
          end;

          Result := true;
        finally
          FreeAndNil(QueryMdc);
        end;
      finally
        FreeAndNil(ConnexionMdc);
      end;
    except
      on e : Exception do
        error := 'exception : "' + e.ClassName + '" - "' + e.Message + '"';
    end;
  finally
    pb_Dossiers.Style := pbstNormal;
    pb_Dossiers.Position := 0;
    lv_ListeDossiers.Items.EndUpdate();
    FLoading := false;
    ShowTotaux();
  end;
end;

function Tfrm_Main.TraitementFixe(out error : string) : boolean;
var
  ConnexionMdc : TMyConnection;
  TransactionMdc : TMyTransaction;
  QueryMdc : TMyQuery;
begin
  Result := false;
  try
    ConnexionMdc := GetNewConnexion(edt_Serveur.Text, edt_Database.Text, 'sysdba', 'masterkey', false);
    try
      TransactionMdc := GetNewTransaction(ConnexionMdc, false);
      try
        QueryMdc := GetNewQuery(ConnexionMdc, TransactionMdc);
        try
          ConnexionMdc.Open();
          TransactionMdc.StartTransaction();

          try

            QueryMdc.SQL.Clear();
            QueryMdc.SQL.Add('DECLARE EXTERNAL FUNCTION F_LEFT');
            QueryMdc.SQL.Add('    CSTRING(254),');
            QueryMdc.SQL.Add('    INTEGER');
            QueryMdc.SQL.Add('RETURNS CSTRING(254)');
            QueryMdc.SQL.Add('ENTRY_POINT ''Left'' MODULE_NAME ''FreeUDFLib.dll'';');
            QueryMdc.ExecSQL();

            QueryMdc.SQL.Clear();
            QueryMdc.SQL.Add('DECLARE EXTERNAL FUNCTION F_RIGHT');
            QueryMdc.SQL.Add('    CSTRING(254),');
            QueryMdc.SQL.Add('    INTEGER');
            QueryMdc.SQL.Add('RETURNS CSTRING(254)');
            QueryMdc.SQL.Add('ENTRY_POINT ''Right'' MODULE_NAME ''FreeUDFLib.dll'';');
            QueryMdc.ExecSQL();

            QueryMdc.SQL.Clear();
            QueryMdc.SQL.Add('DECLARE EXTERNAL FUNCTION F_SUBSTR');
            QueryMdc.SQL.Add('    CSTRING(254),');
            QueryMdc.SQL.Add('    CSTRING(254)');
            QueryMdc.SQL.Add('RETURNS INTEGER BY VALUE');
            QueryMdc.SQL.Add('ENTRY_POINT ''SubStr'' MODULE_NAME ''FreeUDFLib.dll'';');
            QueryMdc.ExecSQL();

            QueryMdc.SQL.Clear();
            QueryMdc.SQL.Add('DECLARE EXTERNAL FUNCTION F_STRINGLENGTH');
            QueryMdc.SQL.Add('    CSTRING(254)');
            QueryMdc.SQL.Add('RETURNS INTEGER BY VALUE');
            QueryMdc.SQL.Add('ENTRY_POINT ''StringLength'' MODULE_NAME ''FreeUDFLib.dll'';');
            QueryMdc.ExecSQL();

            TransactionMdc.Commit();
            Result := true;
          except
            TransactionMdc.Rollback();
            raise;
          end;
        finally
          FreeAndNil(QueryMdc);
        end;
      finally
        FreeAndNil(TransactionMdc);
      end;
    finally
      FreeAndNil(ConnexionMdc);
    end;
  except
    on e : Exception do
      error := 'exception : "' + e.ClassName + '" - "' + e.Message + '"';
  end;
end;

function Tfrm_Main.DoRefreshDossier(Item : TListItem; Nom, Serveur, FileBase : string; LstMag : boolean) : integer;
const
  marge = 14;
var
  i, NbMagActif, NbMagAffect : integer;
  ConnexionSym : TMyConnection;
  QuerySym : TMyQuery;
begin
  Result := 0;
  NbMagActif := 0;
  NbMagAffect := 0;

  QuerySym := nil;
  ConnexionSym := nil;

  Item.SubItems.Clear();

  if LstMag then
  begin
    // avec list de magasin
    try
      ConnexionSym := GetNewConnexion(Serveur, FileBase, 'sysdba', 'masterkey', false);
      try
        QuerySym := GetNewQuery(ConnexionSym);
        try
          ConnexionSym.Open();
          QuerySym.SQL.Text := 'select mag_id, prmaffect.prm_integer as affect, prmactif.prm_integer as actif, prmactif.prm_float as init '
                             + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                             + 'join genparam prmaffect join k on k_id = prmaffect.prm_id and k_enabled = 1 on prmaffect.prm_magid = mag_id and prmaffect.prm_type = 25 and prmaffect.prm_code = 2 '
                             + 'join genparam prmactif join k on k_id = prmactif.prm_id and k_enabled = 1 on prmactif.prm_magid = mag_id and prmactif.prm_type = 25 and prmactif.prm_code = 1 '
                             + 'where mag_id != 0 and mag_codeadh != '''';';
          QuerySym.Open();
          while not QuerySym.Eof do
          begin
            Inc(Result);
            if (QuerySym.FieldByName('actif').AsInteger > 0) or (QuerySym.FieldByName('init').AsFloat > 2) then
              Inc(NbMagActif);
            if (QuerySym.FieldByName('affect').AsInteger > 0) then
              Inc(NbMagAffect);
            QuerySym.Next();
          end;
          Item.Caption := Nom; // nom dossier
          Item.SubItems.Add(IfThen(Result > 0, IntToStr(Result), 'Nan')); // Nb Magasin
          Item.SubItems.Add(IfThen(Result > 0, IntToStr(Result - NbMagActif), 'Nan')); // Nb Magasin inactif
          Item.SubItems.Add(IfThen(Result > 0, IntToStr(Result - NbMagAffect), 'Nan')); // Nb Magasin non affecté
          Item.SubItems.Add(Serveur); // pour affichage : serveur
          Item.SubItems.Add(FileBase); // pour affichage : fichier
          // pour traitement
          Item.SubItems.Add(CST_ACCESSIBLE); // pour traitement : accessible ou non
          Item.SubItems.Add(Serveur); // pour traitement : serveur
          Item.SubItems.Add(FileBase); // pour traitement : fichier
        finally
          FreeAndNil(QuerySym);
        end;
      finally
        FreeAndNil(ConnexionSym);
      end;
    except
      on e : Exception do
      begin
        Result := 0;
        Item.Caption := Nom; // nom dossier
        Item.SubItems.Add('Nan'); // Nb Magasin
        Item.SubItems.Add('Nan'); // Nb Magasin inactif
        Item.SubItems.Add('Nan'); // Nb Magasin non affecté
        Item.SubItems.Add(CST_INACCESSIBLE); // pour affichage : Inacssesible
        Item.SubItems.Add(e.Message); // pour affichage : libelle erreur
        // pour traitement
        Item.SubItems.Add(CST_INACCESSIBLE); // pour traitement : accessible ou non
        Item.SubItems.Add(Serveur); // pour traitement : serveur
        Item.SubItems.Add(FileBase); // pour traitement : fichier
      end;
    end;
  end
  else
  begin
    // sans liste de magasin
    if CanConnect(Serveur, FileBase) then
    begin
      Item.Caption := Nom; // nom dossier
      Item.SubItems.Add(Serveur); // serveur
      Item.SubItems.Add(FileBase); // fichier
      // pour traitement
      Item.SubItems.Add(CST_ACCESSIBLE); // pour traitement : accessible ou non
      Item.SubItems.Add(Serveur); // pour traitement : serveur
      Item.SubItems.Add(FileBase); // pour traitement : fichier
    end
    else
    begin
      Item.Caption := Nom; // nom dossier
      Item.SubItems.Add(CST_INACCESSIBLE); // serveur
      Item.SubItems.Add(CST_INACCESSIBLE); // fichier
      // pour traitement
      Item.SubItems.Add(CST_INACCESSIBLE); // pour traitement : accessible ou non
      Item.SubItems.Add(Serveur); // pour traitement : serveur
      Item.SubItems.Add(FileBase); // pour traitement : fichier
    end;
  end;

  // redimentionnement !
  lv_ListeDossiers.Columns[0].Width := Max(lv_ListeDossiers.Columns[0].Width, lv_ListeDossiers.Canvas.TextWidth(Item.Caption) + marge);
  for i := 1 to lv_ListeDossiers.Columns.Count -1 do
    lv_ListeDossiers.Columns[i].Width := Max(lv_ListeDossiers.Columns[i].Width, lv_ListeDossiers.Canvas.TextWidth(Item.SubItems[i -1]) + marge);
end;

function Tfrm_Main.HasInitDossier(Nom, Serveur, FileBase : string; All : boolean) : string;
var
  ConnexionSym : TMyConnection;
  QuerySym : TMyQuery;
begin
  Result := '';
  try
    ConnexionSym := GetNewConnexion(Serveur, FileBase, 'sysdba', 'masterkey', false);
    try
      QuerySym := GetNewQuery(ConnexionSym);
      try
        ConnexionSym.Open();
        QuerySym.SQL.Text := 'select mag_codeadh, mag_nom, mag_enseigne, prmactif.prm_integer as actif, prmactif.prm_float as initialisation, kactif.k_updated '
                           + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                           + 'join genparam prmaffect on prmaffect.prm_magid = mag_id and prmaffect.prm_type = 25 and prmaffect.prm_code = 2 join k kaffect on k_id = prmaffect.prm_id and k_enabled = 1 '
                           + 'join genparam prmactif on prmactif.prm_magid = mag_id and prmactif.prm_type = 25 and prmactif.prm_code = 1 join k kactif on k_id = prmactif.prm_id and k_enabled = 1 '
                           + 'where mag_id != 0;';
        QuerySym.Open();
        while not QuerySym.Eof do
        begin
          if (QuerySym.FieldByName('actif').AsInteger = 0) and (QuerySym.FieldByName('initialisation').AsFloat > 0) then // les initialisation de prevu
          begin
            Result := Result
                    + Nom + ';'
                    + QuerySym.FieldByName('mag_codeadh').AsString + ';'
                    + QuerySym.FieldByName('mag_nom').AsString + ';'
                    + QuerySym.FieldByName('mag_enseigne').AsString + ';'
                    + IfThen(QuerySym.FieldByName('actif').AsInteger = 0, 'non', 'oui') + ';'
                    + FormatDateTime('yyyy-mm-dd;hh:nn:ss', TDateTime(QuerySym.FieldByName('k_updated').AsFloat)) + ';'
                    + FormatDateTime('yyyy-mm-dd;hh:nn:ss', TDateTime(QuerySym.FieldByName('initialisation').AsFloat)) + ';'
                    + #13 + #10;
          end
          else if all then
          begin
            Result := Result
                    + Nom + ';'
                    + QuerySym.FieldByName('mag_codeadh').AsString + ';'
                    + QuerySym.FieldByName('mag_nom').AsString + ';'
                    + QuerySym.FieldByName('mag_enseigne').AsString + ';'
                    + IfThen(QuerySym.FieldByName('actif').AsInteger = 0, 'non', 'oui') + ';'
                    + IfThen(QuerySym.FieldByName('actif').AsInteger = 0, ';', FormatDateTime('yyyy-mm-dd;hh:nn:ss', TDateTime(QuerySym.FieldByName('k_updated').AsFloat))) + ';'
                    + ';;'
                    + #13 + #10;
          end;
          QuerySym.Next();
        end;
      finally
        FreeAndNil(QuerySym);
      end;
    finally
      FreeAndNil(ConnexionSym);
    end;
  except
    on e : Exception do
    begin
      Result := '';
    end;
  end;
end;

// fonctions utilitaires

procedure Tfrm_Main.ShowTotaux();
begin
  if not FLoading then
    if lv_ListeDossiers.SelCount > 0 then
      if FNbMagasin = 0 then
        lbl_infosDossiers.Caption := IntToStr(FNbDossier) + ' dossiers (' + IntToStr(lv_ListeDossiers.SelCount) + ' sélectionnés)'
      else
        lbl_infosDossiers.Caption := IntToStr(FNbMagasin) + ' magasins pour ' + IntToStr(FNbDossier) + ' dossiers (' + IntToStr(lv_ListeDossiers.SelCount) + ' sélectionnés)'
    else
      if FNbMagasin = 0 then
        lbl_infosDossiers.Caption := IntToStr(FNbDossier) + ' dossiers'
      else
        lbl_infosDossiers.Caption := IntToStr(FNbMagasin) + ' magasins pour ' + IntToStr(FNbDossier) + ' dossiers';
end;

procedure Tfrm_Main.GestionInterface(Enabled : Boolean);
var
  IdxAccessible : integer;
  CanDo : boolean;
begin
  if not Enabled then
    Screen.Cursor := crHourGlass;
  Application.ProcessMessages();

  IdxAccessible := lv_ListeDossiers.Columns.Count -1;

  try
    // blocage temporaire
    Self.Enabled := False;

    lbl_Serveur.Enabled := Enabled;
    edt_Serveur.Enabled := Enabled;

    lbl_Database.Enabled := Enabled;
    edt_Database.Enabled := Enabled;
    chk_AffMagasin.Enabled := Enabled;

    CanDo := Enabled and
             (Trim(edt_Serveur.Text) <> '') and
             ((Trim(edt_Database.Text) <> '') and CanConnect(edt_Serveur.Text, edt_Database.Text));

    btn_Lister.Enabled := CanDo;
    btn_Parametrer.Enabled := CanDo and (lv_ListeDossiers.SelCount > 0) and (lv_ListeDossiers.Items[lv_ListeDossiers.ItemIndex].SubItems[IdxAccessible] = CST_ACCESSIBLE);
    btn_ListeMagasin.Enabled := CanDo and (lv_ListeDossiers.SelCount > 0) and (lv_ListeDossiers.Items[lv_ListeDossiers.ItemIndex].SubItems[IdxAccessible] = CST_ACCESSIBLE);
    btn_ForceParam.Enabled := CanDo and (lv_ListeDossiers.SelCount > 0) and (lv_ListeDossiers.Items[lv_ListeDossiers.ItemIndex].SubItems[IdxAccessible] = CST_ACCESSIBLE);
    btn_Refresh.Enabled := CanDo and (lv_ListeDossiers.SelCount > 0);

    btn_Rapport.Enabled := CanDo and (lv_ListeDossiers.SelCount > 0);

    btn_Fixe.Enabled := CanDo;

    btn_Quitter.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;

function Tfrm_Main.CanConnect(Serveur, DataBaseFile : string) : boolean;
var
  Connexion : TMyConnection;
begin
  Result := false;

  Connexion := nil;

  if (Trim(Serveur) <> '') and (Trim(DataBaseFile) <> '') then
  begin
    try
      Connexion := GetNewConnexion(Serveur, DataBaseFile, 'sysdba', 'masterkey', false);
      try
        Connexion.Open();
        if Connexion.Connected then
          Result := true;
      finally
        FreeAndNil(Connexion);
      end;
    except
      Result := false;
    end;
  end;
end;

// dialogue

function Tfrm_Main.MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons): Integer;
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
