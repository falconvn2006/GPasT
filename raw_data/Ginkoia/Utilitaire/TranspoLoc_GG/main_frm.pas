//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           : Page standard d'une application "Page"
// Auteur         :
// Historique     :
// 20/08/2000 - Hervé PULLUARD - v 1.0.0 : Création
//------------------------------------------------------------------------------

{***************************************************************
   CTRL+TAB pour passer d'un onglet à l'autre.
   Contrôle du changement de page :
       Les formes de chaque page au standard TAlgolstdFrm ont une propriété "StdTag"
       qui est utilisé ici.
       Si StdTag de la page courante est >= 0 le changement de page est interdit
       Il nous suffit donc d'agir sur cette propriété pour contrôler...
       Rem : cela ne sert que dans une forme utilisée comme "page" ailleurs
       StdTag est aussi utilisé de la même façon pour inhiber les boutons de menus.

       Exception : la MainForm d'un projet page utilise StdTag pour contrôler
       le nombre de pages Maximum autorisé. Cela n'a aucune incidence puisque
       dans ce contexte la MainForm n'est jamais la forme active
       (au plus bas niveau c'est l'écran de contrôle qui est actif).

   ATTENTION : lorsque "StdTag" de la forme est >= 0 les "boutons de menu"
       dont le tag est >= 0 sont inhibés.
       Nota :
           1. StdTag par defaut = -1 c'est pourquoi je considère une valeur >= 0
           2. Par défaut tout nouveau bouton menu posé est inhibé car son Tag = 0.
              (Les boutons de menu des projets "modèles" ont tous leur tag mis
              à = -1 sauf quitter. Ils restent ainsi toujours actifs 'aide, tip ...etc.
           3. Cette solution nous permet de continuer à utiliser des valeurs absolues
              significatives pour les Tags et donc d'effectuer nos tests sur celle-ci.
              Cela nous évite aussi de mémoriser des valeurs de Tags pour les restituer
              en fin de traitement. Il suffit de d'inverser le signe du Tag momentanément
              pour obtenir le résultat souhaité

   ON NE PEUT PAS NON PLUS QUITTER une application "page" tant qu'il y a encore
   des pages ouvertes hors écran de contrôle.

   NE PAS OUBLIER qu'il existe aussi une propriété STDSTR qui peut servir...

   INTERDIRE L'OUVERTURE DE PLUSIEURS OCCURRENCES D'UNE PAGE :
   (seulement pour les TAlgolStdFrm)
   Mettre la propriété "OnlyOneInstance" à TRUE

   Numérotation des pages automatique sur les instances d'un même module

   Nota : le système fonctionne sans que les pages aient à déclarer la MainForm
   dans sa clause Uses. Toutefois il est évident que cela pourra être nécessaire
   pour d'autres motifs.

   Les Events Key des pages n'interceptent pas les touches système (flêches par exemple)

   On peut aussi utiliser le composant WindowList de LMD pour gérer les pages
   Une fenêtre pour changer (c'est automatique)
   Une fenêtre pour détruire (en sortie si execute on tue la page sélectée)

   **************************************************************************

   ATTENTION :
   *********
   EVENTS STANDARDS NON EXECUTES par les Pages du composant dockpage de LMD.
   DONC A NE PAS UTILISER ou à des fins personnelles et qui donc doivent explicitement
   être appelées

   1. Form Deactivate
   2. Form Activate
   3. Form Close
   4. Form KeyDown
   *************************************************************************** }

unit main_frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  AlgolStdFrm,
  LMDControl,
  LMDBaseControl,
  LMDBaseGraphicButton,
  LMDCustomSpeedButton,
  LMDSpeedButton,
  ExtCtrls,
  RzPanel,
  StdCtrls,
  LMDCustomScrollBox,
  LMDScrollBox,
  LMDCustomButton,
  LMDButton,
  RzLabel, RzStatus, fcStatusBar, Db, Grids, DBGrids, IBDataset,
  RzPanelRv, Buttons, gwrlr, IB_Components, IBDatabase, IBCustomDataSet,
  IBQuery, Mask, wwdbedit, wwDBEditRv, dxmdaset, ActionRv;

type
  TFrm_Main = class(TAlgolStdFrm)
    Pan_Page: TRzPanel;
    RzPanelRv1: TRzPanelRv;
    RzPanelRv2: TRzPanelRv;
    Ds_BDLocArt: TDataSource;
    RzPanelRv3: TRzPanelRv;
    OD_IB: TOpenDialog;
    RzPanelRv4: TRzPanelRv;
    Que_BdRecherche: TIB_Cursor;
    Que_Creation: TIBOQuery;
    RzPanelRv7: TRzPanelRv;
    RzPanelRv8: TRzPanelRv;
    RzLabel1: TRzLabel;
    MemD_Categorie: TdxMemData;
    MemD_CategorieANCIEN: TStringField;
    MemD_CategorieNOUVEAU: TStringField;
    DS_BoLocArt: TDataSource;
    RzPanelRv9: TRzPanelRv;
    RzPanelRv10: TRzPanelRv;
    Lab_GridDest: TRzLabel;
    dbg_BDLocArt: TDBGrid;
    Lab_GridOri: TRzLabel;
    dbg_BOLocArt: TDBGrid;
    OD_CSV: TOpenDialog;
    Que_BdLocArt: TIBOQuery;
    Que_Statut: TIBOQuery;
    Que_TGF: TIBOQuery;
    Que_Categorie: TIBOQuery;
    Grd_close: TGroupDataRv;
    IBQue_BoLocArt: TIBOQuery;
    IBC_BaseOri: TIB_Connection;
    IBQue_BoRecherche: TIBOQuery;
    IBQue_Statut: TIBOQuery;
    IBQue_TGF: TIBOQuery;
    IBQue_Categorie: TIBOQuery;
    Que_BdLocArtARL_ID: TIntegerField;
    Que_BdLocArtARL_ARLID: TIntegerField;
    Que_BdLocArtARL_STAID: TIntegerField;
    Que_BdLocArtARL_MRKID: TIntegerField;
    Que_BdLocArtARL_TGFID: TIntegerField;
    Que_BdLocArtARL_CALID: TIntegerField;
    Que_BdLocArtARL_CDVID: TIntegerField;
    Que_BdLocArtARL_TKEID: TIntegerField;
    Que_BdLocArtARL_ICLID1: TIntegerField;
    Que_BdLocArtARL_ICLID2: TIntegerField;
    Que_BdLocArtARL_ICLID3: TIntegerField;
    Que_BdLocArtARL_ICLID4: TIntegerField;
    Que_BdLocArtARL_ICLID5: TIntegerField;
    Que_BdLocArtARL_CHRONO: TStringField;
    Que_BdLocArtARL_NOM: TStringField;
    Que_BdLocArtARL_DESCRIPTION: TStringField;
    Que_BdLocArtARL_NUMSERIE: TStringField;
    Que_BdLocArtARL_COMENT: TMemoField;
    Que_BdLocArtARL_SESSALOMON: TIntegerField;
    Que_BdLocArtARL_DATEACHAT: TDateTimeField;
    Que_BdLocArtARL_PRIXACHAT: TIBOFloatField;
    Que_BdLocArtARL_PRIXVENTE: TIBOFloatField;
    Que_BdLocArtARL_DATECESSION: TDateTimeField;
    Que_BdLocArtARL_PRIXCESSION: TIBOFloatField;
    Que_BdLocArtARL_DUREEAMT: TIntegerField;
    Que_BdLocArtARL_SOMMEAMT: TIBOFloatField;
    Que_BdLocArtARL_ARCHIVER: TIntegerField;
    Que_BdLocArtARL_VIRTUEL: TIntegerField;
    Que_BdLocArtARL_REFMRK: TStringField;
    Que_BdLocArtARL_TVATAUX: TIBOFloatField;
    Que_BdLocArtARL_LOUEAUFOURN: TIntegerField;
    Que_StatutSTA_ID: TIntegerField;
    Que_StatutSTA_NOM: TStringField;
    Que_StatutSTA_DISPOLOC: TIntegerField;
    Que_TGFTGF_ID: TIntegerField;
    Que_TGFTGF_GTFID: TIntegerField;
    Que_TGFTGF_IDREF: TIntegerField;
    Que_TGFTGF_TGFID: TIntegerField;
    Que_TGFTGF_NOM: TStringField;
    Que_TGFTGF_CORRES: TStringField;
    Que_TGFTGF_ORDREAFF: TIBOFloatField;
    Que_TGFTGF_STAT: TIntegerField;
    Nbt_Quitter: TLMDSpeedButton;
    LMDSpeedButton1: TLMDSpeedButton;
    Nbt_Transposer: TLMDSpeedButton;
    Nbt_ConnectBase: TLMDSpeedButton;
    RzPanelRv5: TRzPanelRv;
    RzPanelRv6: TRzPanelRv;
    Nbt_ODCSV: TSpeedButton;
    Nbt_ODIB: TSpeedButton;
    Chp_BaseOri: TwwDBEditRv;
    Chp_CvsCategorie: TwwDBEditRv;
    RzLabel2: TRzLabel;
    Lab_CheminInv: TRzLabel;
    Memo_Log: TMemo;
    RzLabel3: TRzLabel;
    Custom_Requete: TMemo;
    Chk_Statut: TCheckBox;
    Lab_LigneOk: TRzLabel;
    Chk_ChronoDouble: TCheckBox;
    Que_Chrono: TIBOQuery;
    Que_NewChrono: TIBOQuery;
    Que_NewChronoNEWNUM: TStringField;
    procedure Nbt_QuitClick(Sender: TObject);
    procedure AlgolStdFrmShow(Sender: TObject);
    procedure AlgolStdFrmCreate(Sender: TObject);
    procedure AlgolStdFrmCloseQuery(Sender: TObject;
      var CanClose: Boolean);
    procedure Nbt_ODIBClick(Sender: TObject);
    procedure boutons();
    procedure Nbt_ConnectBaseClick(Sender: TObject);
    function initialiserConnexion(base: TIBDatabase; DatabaseName: string): boolean;
    function transpoMarque(var mrkId: Integer): Boolean;
    function transpoStatus(var stsId: Integer): Boolean;
    function transpoTailleCouleur(var TGFId: Integer; var TGFNom: string): Boolean;
    function transpoCategorie(var calId: Integer): Boolean;
    function transpoChrono(chrono: string): Boolean;
    procedure Nbt_TransposerClick(Sender: TObject);
    procedure transposer();
    procedure GenerikAfterPost(DataSet: TDataSet);
    procedure GenerikNewRecord(DataSet: TDataSet);
    procedure GenerikUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    function findNewId(oldId: Integer; liste: TstringList): Integer;
    procedure LMDSpeedButton1Click(Sender: TObject);
    procedure Nbt_ODCSVClick(Sender: TObject);
    procedure GenerikAfterCancel(DataSet: TDataSet);
    procedure GenerikBeforeDelete(DataSet: TDataSet);
    procedure AlgolStdFrmClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_QuitterClick(Sender: TObject);
    procedure Custom_RequeteChange(Sender: TObject);
  private
    UserCanModify, UserVisuMags, wEncours: Boolean;
    listeNewId, listeNewChrono: TStringList;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }

  published
    { Published declarations }
  end;

var Frm_Main: TFrm_Main;

function ExecuteTranspo(mode: Integer): Boolean;

implementation

uses
  GinkoiaResStr,
  DlgStd_Frm, GinKoiaStd, Main_Dm, Ucommon;

{$R *.DFM}

function ExecuteTranspo(mode: Integer): Boolean;
var
  retour: Boolean;
begin
  retour := false;
  Application.CreateForm(TFrm_main, frm_main);
  with frm_main do
  begin
    try
      case mode of
        0:
          begin
            //TODO verbose
            retour := true;
          end;
        1:
          begin
            if Showmodal = mrOk then
            begin
              retour := true;
            end;
          end;
      end;
    finally
      //      Que_BDLocArt.close;
      //      IBQue_BoLocArt.close;
            //vérifier l'état de la connection à la base
      //      if IBC_BaseOri.Connected then
      //      begin
      //        //se déconnecter
      //        IBC_BaseOri.Close();
      //      end;
      result := retour;
    end;
  end;
end;


procedure TFrm_Main.AlgolStdFrmCreate(Sender: TObject);
begin

  try
    // pour si des fois qu'init longue car ouverture de tables ...etc
    screen.Cursor := crSQLWait;

    // contôle qui doit avoir le focus en entrée
    CurCtrl := Chp_BaseOri;

    wEncours := false;

    Hint := Caption;
    StdGinkoia.AffecteHintEtBmp(self);
    UserVisuMags := StdGinkoia.UserVisuMags;
    UserCanModify := StdGinkoia.UserCanModify('YES_PAR_DEFAUT');

    //ouvrir la base renseignée dans l'ini
    Que_BDLocArt.open;

    //initialiser une liste des lignes traitées
    listeNewId := TStringList.create;
    listeNewChrono := TStringList.create;

    //initialiser les boites de dialogue fichier
    //repertoire par défaut
    OD_CSV.InitialDir := GetCurrentDir;
    //options
    OD_CSV.Options := [ofFileMustExist];
    //filtre
    OD_CSV.Filter := 'Fichiers csv (*.csv)|*.csv';
    OD_CSV.FilterIndex := 1;

    OD_IB.InitialDir := GetCurrentDir;
    //options
    OD_IB.Options := [ofFileMustExist];
    //filtre
    OD_IB.Filter := 'Fichiers ib (*.ib)|*.ib';
    OD_IB.FilterIndex := 1;

    //nombre d'enregistrements
    Lab_GridDest.caption := Lab_GridDest.caption + ' ' + IntToStr(Que_BDLOCART.recordcount) + ' lignes.';
    //gestion des boutons
    boutons();

  finally
    screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Nbt_QuitClick(Sender: TObject);
var
  CanClose: Boolean;
begin
  //CanClose := True;
  AlgolStdFrmCloseQuery(Sender, CanClose);
  //if CanClose then
//  begin
//    ModalResult := Mrok;
//  end;
end;

procedure TFrm_Main.AlgolStdFrmCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := False;
  case CtrlCanClose of
    0: CanClose := True;
    1: WaitMessHP(ErrPgTab, 3, True, 0, 0, '');
    2:
      begin
        WaitMessHP(ErrPgFc, 3, True, 0, 0, '');
        ActiveFirstTagedFcPage; // active la page fc avec stdTag
      end;
  end;

end;

procedure TFrm_Main.AlgolStdFrmShow(Sender: TObject);
begin

  { Important :
    Ici ne pas toucher à l'aspect visuel des composants visuels de la forme car cela
    perturbe l'affichage -> Le maximized interne et nécessaire de la page dockée ne se
    fait fait plus ...

    Ici à la création de la forme et jusqu'au 1er show la propriété INit de la forme
    est toujours à False ! C'est aprés le "DoSwow" qu'elle est automatiquement mise à
    True ... Donc le 2ème entrée ici INit est théoriquement à False.
    Cette propriété est visible et gérable dans l'inspecteur d'objets.
    A noter que si la propriété InitTrueOnShow est mise à False ce qui est dit
    précèdemment n'est plus de rigueur...
  }

  if Init then
  begin
    { Ne passe donc pas ici lors de la création !}

    {
    A mettre impérativement si bouton de convertor
    Nbt_Convert.ControlConvertor;
    }

    { Attention ici faut peut être chaîner sur
      un traitement spécifique si on veut gérer
      les cas de "surConnection"
    UserVisuMags := StdGinkoia.UserVisuMags;
    UserCanModify := StdGinkoia.UserCanModify('xxx');
    }

  end;

end;

procedure TFrm_Main.Nbt_ODIBClick(Sender: TObject);
begin
  //si un fichier est sélectionné
  if OD_IB.Execute then
  begin
    //recopier son nom
    Chp_BaseOri.Text := OD_IB.FileName;
  end;
  //gestion des boutons
  boutons();
end;

procedure Tfrm_main.boutons();
begin
  //gestion de l'état des boutons
  Nbt_ConnectBase.Enabled := (Length(Chp_BaseOri.Text) > 0) and not wEncours and (Length(Custom_Requete.Lines.Text) > 0);
  Nbt_Transposer.enabled := (not Que_BDLOCART.EOF) and (not IBQue_BoLocArt.EOF) and (Length(Chp_CvsCategorie.Text) > 0) and not wEncours;
  Nbt_Quitter.Enabled := not wEncours;
end;

procedure TFrm_Main.Nbt_ConnectBaseClick(Sender: TObject);
begin
  //tester le chemin
  if FileExists(Chp_BaseOri.text) then
  begin
    try
      try
        // tester si déjà connecté sur une base
        if Ibc_BaseOri.Connected then
        begin
          //se déconnecter
          Ibc_BaseOri.Close;
        end;
        //initialiser le chemin de connection vers la base destinataire
        Ibc_BaseOri.DatabaseName := Chp_BaseOri.text;
        //connecter
        Ibc_BaseOri.Open();
        //tester si connection réussie
        if Ibc_BaseOri.Connected then
        begin
          IBQue_BoLocArt.SQL.text := trim(Custom_Requete.lines.text);
          //executer la requete
          IBQue_BoLocArt.open;
          IBQue_BoLocArt.FetchAll;
          Lab_GridOri.caption := 'Table de la base origine : ' + IntToStr(IBQue_BOLOCART.recordcount) + ' lignes.';
        end;
      except
        on E: Exception do
        begin
          LogAction('Erreur lors de l''initialisation de la connexion' + E.Message);
        end;
      end;
    finally
      //gestion des boutons
      boutons();
    end
  end;
end;

function Tfrm_main.initialiserConnexion(base: TIBDatabase; DatabaseName: string): boolean;
var
  retour: boolean;
begin
  //initialiser les paramètres de connexion à la base destination
  base.Params.clear;
  base.Params.Add('user_name=sysdba');
  base.Params.Add('password=masterkey');
  //initialiser le booléen
  retour := false;
  try
    // tester si déjà connecté sur une base
    if base.Connected then
    begin
      //se déconnecter
      base.Close;
    end;
    //initialiser le chemin de connection vers la base destinataire
    base.DatabaseName := DatabaseName;
    //connecter
    base.Open();
    //tester si connection réussie
    if base.Connected then
    begin
      //signaler le succès
      retour := true;
    end;
  except
    on E: Exception do
    begin
      //TODO LogAction('Erreur lors de l''initialisation de la connexion' + E.Message);
      Showmessage(e.message);
    end;
  end;
  result := retour;
end;

function TFrm_Main.transpoMarque(var mrkId: Integer): Boolean;
var
  mrkNom: string;
  retour: boolean;
  id: Integer;
begin
  retour := true;
  //vérifier l'existence de la marque
  if mrkId <> 0 then
  begin
    try
      //trouver le libelle associé à cet id : nom de  la marque
      IBQue_BoRecherche.ParamByName('mrkid').asinteger := mrkId;
      IBQue_BoRecherche.Open;
      mrkNom := IBQue_BoRecherche.FieldByName('MRK_NOM').value;
      IBQue_BoRecherche.close;
      //rechercher dans la base D
      Que_BdRecherche.close;
      Que_BdRecherche.ParamByName('mrknom').value := mrkNom;
      Que_BdRecherche.open;
      //vérifier la réponse
      ///si la marque existe
      if not Que_BdRecherche.Eof then
      begin
        //recopier son id
        mrkid := Que_BdRecherche.FieldByName('MRK_ID').value;
      end
      else /// si la marque n'existe pas
      begin
        ///créer la marque
        Que_Creation.close;
        Que_Creation.sql.text := 'Select ARTMARQUE.* from ARTMARQUE join K on (K_ID=MRK_ID and K_ENABLED=1) where MRK_ID=0';
        Que_Creation.KeyLinks.Text := 'MRK_ID';
        Que_Creation.KeyRelation := 'ARTMARQUE';
        Que_Creation.open;

        Que_Creation.Append;
        Que_Creation.FieldByName('MRK_IDREF').value := 0;
        Que_Creation.FieldByName('MRK_NOM').value := mrkNom;
        Que_Creation.Post;
        mrkid := Que_Creation.FieldByName('MRK_ID').value;

        ///creer un fournisseur ayant le nom de la marque
        //creer l'adresse
        Que_Creation.close;
        Que_Creation.sql.text := 'Select GENADRESSE.* from GENADRESSE join K on (K_ID=ADR_ID and K_ENABLED=1) where ADR_ID=0';
        Que_Creation.KeyLinks.Text := 'ADR_ID';
        Que_Creation.KeyRelation := 'GENADRESSE';
        Que_Creation.open;
        Que_Creation.Append;
        Que_Creation.FieldByName('ADR_VILID').value := 0;
        Que_Creation.FieldByName('ADR_COMMENT').value := 'TRANSPOSITION JUGLARET';
        Que_Creation.Post;
        //recopier cet id
        id := Que_Creation.FieldByName('ADR_ID').value;

        //creer artFourn
        Que_Creation.close;
        Que_Creation.sql.text := 'Select ARTFOURN.* from ARTFOURN join K on (K_ID=FOU_ID and K_ENABLED=1) where FOU_ID=0';
        Que_Creation.KeyLinks.Text := 'FOU_ID';
        Que_Creation.KeyRelation := 'ARTFOURN';
        Que_Creation.open;
        Que_Creation.Append;
        Que_Creation.FieldByName('FOU_IDREF').value := 0;
        Que_Creation.FieldByName('FOU_ADRID').value := id;
        Que_Creation.FieldByName('FOU_NOM').value := mrkNom;
        Que_Creation.Post;
        //recopier cet id
        id := Que_Creation.FieldByName('FOU_ID').value;

        //creer artFournDetail
        Que_Creation.close;
        Que_Creation.sql.text := 'Select ARTFOURNDETAIL.* from ARTFOURNDETAIL join K on (K_ID=FOD_ID and K_ENABLED=1) where FOD_ID=0';
        Que_Creation.KeyLinks.Text := 'FOD_ID';
        Que_Creation.KeyRelation := 'ARTFOURNDETAIL';
        Que_Creation.open;
        Que_Creation.Append;
        Que_Creation.FieldByName('FOD_FOUID').value := id;
        Que_Creation.FieldByName('FOD_MAGID').value := 0;
        Que_Creation.FieldByName('FOD_FTOID').value := 0;
        Que_Creation.FieldByName('FOD_MRGID').value := 0;
        Que_Creation.FieldByName('FOD_CPAID').value := 0;
        Que_Creation.Post;
        //associer les deux ARTMRKFOURN
        Que_Creation.close;
        Que_Creation.sql.text := 'Select ARTMRKFOURN.* from ARTMRKFOURN join K on (K_ID=FMK_ID and K_ENABLED=1) where FMK_ID=0';
        Que_Creation.KeyLinks.Text := 'FMK_ID';
        Que_Creation.KeyRelation := 'ARTMRKFOURN';
        Que_Creation.open;
        Que_Creation.Append;
        Que_Creation.FieldByName('FMK_FOUID').value := id;
        Que_Creation.FieldByName('FMK_MRKID').value := mrkId;
        Que_Creation.FieldByName('FMK_PRIN').value := 1;
        Que_Creation.Post;
      end;
    except on E: Exception do
      begin
        //TODO LogAction('Erreur lors de l''initialisation de la connexion' + E.Message);
        //errMrk := e.message;
        retour := false;
        IBQue_BoRecherche.close;
        Que_BdRecherche.close;
        Que_Creation.close;
      end;
    end;
  end;
  result := retour;

end;

function TFrm_Main.transpoStatus(var stsId: Integer): Boolean;
var
  staNom: string;
  retour: boolean;
  staDispoLoc: Integer;
begin
  retour := true;
  //vérifier l'existence du status
  if stsId <> 0 then
  begin
    try
      //trouver le libelle associé à cet id : nom de  la status
      IBQue_Statut.ParamByName('staid').asinteger := stsId;
      //recupèrer le libellé base O
      IBQue_Statut.Open;
      staNom := IBQue_Statut.FieldByName('STA_NOM').value;
      staDispoLoc := IBQue_Statut.FieldByName('STA_DISPOLOC').value;
      IBQue_Statut.close;
      //recherche dans Base D si equivalent
      Que_Statut.close;
      Que_Statut.ParamByName('stanom').asString := staNom;
      Que_Statut.Open;

      //s'il n'existe pas créer l'id
      if Que_Statut.EOF then
      begin
        Que_Statut.insert;
        Que_Statut.FieldByName('STA_NOM').value := staNom;
        Que_Statut.FieldByName('STA_DISPOLOC').value := staDispoLoc;
        Que_Statut.post;
      end;
      stsID := Que_Statut.FieldByName('STA_ID').value;

    except on E: Exception do
      begin
        //TODO LogAction('Erreur lors de l''initialisation de la connexion' + E.Message);
        //errSts := e.message;
        retour := false;
        IBQue_Statut.close;
        Que_Statut.close;
      end;
    end;
  end;
  result := retour;
end;

function TFrm_Main.transpoTailleCouleur(var TGFId: Integer; var TGFNom: string): Boolean;
var
  retour: boolean;
begin
  retour := true;
  //vérifier l'existence de la taille couleur
  if TGFId <> 0 then
  begin
    try
      //trouver le libelle associé à cet id
      IBQue_TGF.ParamByName('tgfid').asinteger := TGFId;
      //recupèrer le libellé base O
      IBQue_TGF.Open;
      TGFNom := IBQue_TGF.FieldByName('TGF_NOM').value;
      IBQue_TGF.close;
      //recherche dans Base D si l'id equivalent à le même libellé
      Que_TGF.close;
      Que_TGF.ParamByName('tgfid').asInteger := TGFId;
      Que_TGF.Open;

      //s'il n'existe pas créer l'id
      if Que_TGF.EOF then
      begin
        TGFId := 0;
      end
      else // sinon verifier si le libellé correspond
      begin
        if not (Que_TGF.FieldByName('TGF_NOM').asString = TGFNOM) then
        begin
          TGFId := 0;
        end;
      end;

    except on E: Exception do
      begin
        //TODO LogAction('Erreur lors de l''initialisation de la connexion' + E.Message);
        //errTGF := e.message;
        retour := false;
        IBQue_TGF.close;
        Que_TGF.close;
      end;
    end;
  end;
  result := retour;
end;

function TFrm_Main.transpoCategorie(var calId: Integer): Boolean;
var
  retour: boolean;
  calNom: string;
begin
  retour := true;
  //vérifier l'existence
  if calId <> 0 then
  begin
    try
      //trouver le libelle associé à cet id
      IBQue_Categorie.ParamByName('calid').asinteger := calId;
      //recupèrer le libellé base O
      IBQue_Categorie.Open;
      calNom := IBQue_Categorie.FieldByName('CAL_NOM').value;
      IBQue_Categorie.close;
      MemD_Categorie.DelimiterChar := ';';
      MemD_Categorie.LoadFromTextFile(OD_CSV.FileName);
      if MemD_Categorie.Locate('ANCIEN', calNOM, [loCaseInsensitive]) then
      begin
        //récupèrer le nom de son équivalent dans la base D
        calNom := MemD_Categorie.FieldByName('NOUVEAU').AsString;
        //recherche dans Base D si equivalent
        Que_Categorie.close;
        Que_Categorie.ParamByName('calnom').asString := calNom;
        Que_Categorie.Open;

        //s'il n'existe pas signaler l'erreur
        if Que_Categorie.EOF then
        begin
          LogAction('--> Categorie inexistante');
          calId := 0;
          retour := false;
        end
        else
        begin
          calId := Que_Categorie.FieldByName('CAL_ID').value;
        end;
      end
      else
      begin
        retour := False;
      end;

    except on E: Exception do
      begin
        //TODO LogAction('Erreur lors de l''initialisation de la connexion' + E.Message);
        LogAction('categorie : ' + IntToStr(calId) + '/' + calNom + ' : ' + e.message);
        retour := false;
        IBQue_Categorie.close;
      end;
    end;
  end;
  result := retour;
end;


procedure TFrm_Main.Nbt_TransposerClick(Sender: TObject);
begin
  //signaler que la transpo à commencée
  wEncours := true;
  //raffraichir l'état des boutons
  boutons();
  screen.cursor := crHourGlass;
  //Paint;
  Application.ProcessMessages;
  //initialiser le fichier et le memo log
  initLogFileName(Memo_Log, nil, true);
  LogAction('Début de la Transposition');
  //lancer la transpos
  transposer();
  //signaler que la transpo est fin
  wEncours := false;
  screen.cursor := crDefault;
  //raffraichir l'état des boutons
  boutons();
  //nombre d'enregistrements
  Lab_GridDest.caption := 'Table de la base de destination :' + ' ' + IntToStr(Que_BDLOCART.recordcount) + ' lignes.';
end;

procedure TFrm_Main.transposer;
var
  countLigneOk, IdRech, idStatut: Integer;
  taille: string;
begin
  try
    //Initialiser les compteurs
    countLigneOk := 0;
    IdRech := 0;

    //Lab_TotalLignes.caption := Lab_TotalLignes.caption + ' ' + IntToStr(IBQue_BoLocArt.RecordCount);
    //se placer sur le premier enregistrement
    IBQue_BoLocArt.First;

    //recherche l'id du statut transposé une seule fois si unique
    idRech := IBQue_BoLocArt.FieldByName('ARL_STAID').asInteger;
    if Chk_Statut.Checked then
    begin
      if not transpoStatus(idRech) then
      begin
        exit;
      end
      else
      begin
        idStatut := IdRech;
      end;
    end;
    //description log
    LogAction('Date' + ';' + 'Ligne O/D : n°' + ';' + 'ID_ORI' + ';' + 'ID_DEST');

    ///pour chaque ligne trouvées
    while not IBQue_BoLocArt.EOF do
    begin
      IdRech := 0;
      //creer une ligne vide dans la base D
      Que_BdLocArt.Insert;
      LogAction(IntToStr(countLigneOk + 1) + ';' + IBQue_BoLocArt.FieldByName('ARL_ID').asString + ';' + Que_BdLocArt.FieldByName('ARL_ID').asstring);

      ///en fonction du type de fiche
      //si c'est une fiche principale stocker la correspondace entre l'ancien et le nouvel id
      if (IBQue_BoLocArt.FieldByName('ARL_ID').asInteger = IBQue_BoLocArt.FieldByName('ARL_ARLID').asinteger) then
      begin
        //stocker sa valeur
        Que_BdLocArt.FieldByName('ARL_ARLID').asInteger := Que_BdLocArt.FieldByName('ARL_ID').asInteger;
        //stocker l'info
        listeNewId.add(';' + IBQue_BoLocArt.FieldByName('ARL_ID').asstring + ';/' + Que_BdLocArt.FieldByName('ARL_ID').asstring);
      end
      else //si c'est une fiche secondaire rechercher le nouvel id de sa fiche principale
      begin
        //stocker sa valeur
        Que_BdLocArt.FieldByName('ARL_ARLID').asInteger := findNewId(IBQue_BoLocArt.FieldByName('ARL_ARLID').asInteger, listeNewId);
        //enregistrer la ligne
      end;

      ///STATUT
      //recherche l'id du statut à chaque fois si on en transpose plusieur sinon une seule fois si unique
      idRech := IBQue_BoLocArt.FieldByName('ARL_STAID').asInteger;
      if not Chk_Statut.Checked then
      begin
        if not transpoStatus(idRech) then
        begin
          break;
        end
        else
        begin
          Que_BdLocArt.FieldByName('ARL_STAID').value := IdRech;
        end;
      end
      else //si statut unique
      begin
        Que_BdLocArt.FieldByName('ARL_STAID').value := idStatut;
      end;

      ///MARQUE
      idRech := IBQue_BoLocArt.FieldByName('ARL_MRKID').asInteger;
      if not transpoMarque(idRech) then
      begin
        break;
      end
      else
      begin
        Que_BdLocArt.FieldByName('ARL_MRKID').value := idRech;
      end;

      ///TGF
      idRech := IBQue_BoLocArt.FieldByName('ARL_TGFID').asInteger;
      if not transpoTailleCouleur(idRech, taille) then
      begin
        break;
      end
      else
      begin
        Que_BdLocArt.FieldByName('ARL_TGFID').value := idRech;
      end;

      ///CATEGORIE
      idRech := IBQue_BoLocArt.FieldByName('ARL_CALID').asInteger;
      if not transpoCategorie(idRech) then
      begin
        LogAction('Categorie : ' + IntToStr(idRech));
        break;
      end
      else
      begin
        Que_BdLocArt.FieldByName('ARL_CALID').value := idRech;
      end;

      ///CDVID
      Que_BdLocArt.FieldByName('ARL_CDVID').value := 0;

      ///TKEID
      Que_BdLocArt.FieldByName('ARL_TKEID').value := 0;

      ///ICLID1
      Que_BdLocArt.FieldByName('ARL_ICLID1').value := 173409624;

      ///ICLID2
      Que_BdLocArt.FieldByName('ARL_ICLID2').value := 0;

      ///ICLID3
      Que_BdLocArt.FieldByName('ARL_ICLID3').value := 0;

      ///ICLID4
      Que_BdLocArt.FieldByName('ARL_ICLID4').value := 0;

      ///ICLID5
      Que_BdLocArt.FieldByName('ARL_ICLID5').value := 0;

      ///CHRONO
      if Chk_ChronoDouble.checked then
      begin
        transpoChrono(IBQue_BoLocArt.FieldByName('ARL_CHRONO').asstring);
      end;
      Que_BdLocArt.FieldByName('ARL_CHRONO').value := IBQue_BoLocArt.FieldByName('ARL_CHRONO').asstring;

      ///ARL_NOM
      Que_BdLocArt.FieldByName('ARL_NOM').value := IBQue_BoLocArt.FieldByName('ARL_NOM').asstring;

      ///ARL_DESCRIPTION
      Que_BdLocArt.FieldByName('ARL_DESCRIPTION').value := IBQue_BoLocArt.FieldByName('ARL_DESCRIPTION').asstring;

      ///ARL_NUMSERIE
      Que_BdLocArt.FieldByName('ARL_NUMSERIE').value := IBQue_BoLocArt.FieldByName('ARL_NUMSERIE').asstring;

      ///COMENT
      Que_BdLocArt.FieldByName('ARL_COMENT').value := 'Taille : ' + taille + #13#10 + IBQue_BoLocArt.FieldByName('ARL_COMENT').asstring;

      ///ARL_SESSALOMON
      Que_BdLocArt.FieldByName('ARL_SESSALOMON').value := IBQue_BoLocArt.FieldByName('ARL_SESSALOMON').asinteger;

      ///ARL_DATEACHAT
      Que_BdLocArt.FieldByName('ARL_DATEACHAT').value := IBQue_BoLocArt.FieldByName('ARL_DATEACHAT').AsDateTime;

      ///ARL_PRIXACHAT
      Que_BdLocArt.FieldByName('ARL_PRIXACHAT').value := IBQue_BoLocArt.FieldByName('ARL_PRIXACHAT').asfloat;

      ///ARL_PRIXVENTE
      Que_BdLocArt.FieldByName('ARL_PRIXVENTE').value := IBQue_BoLocArt.FieldByName('ARL_PRIXVENTE').asfloat;

      ///ARL_DATECESSION
      Que_BdLocArt.FieldByName('ARL_DATECESSION').value := IBQue_BoLocArt.FieldByName('ARL_DATECESSION').AsDateTime;

      ///ARL_PRIXCESSION
      Que_BdLocArt.FieldByName('ARL_PRIXCESSION').value := IBQue_BoLocArt.FieldByName('ARL_PRIXCESSION').asfloat;

      ///ARL_DUREEAMT
      Que_BdLocArt.FieldByName('ARL_DUREEAMT').value := IBQue_BoLocArt.FieldByName('ARL_DUREEAMT').asinteger;

      ///ARL_SOMMEAMT
      Que_BdLocArt.FieldByName('ARL_SOMMEAMT').value := IBQue_BoLocArt.FieldByName('ARL_SOMMEAMT').asfloat;

      ///ARL_ARCHIVER
      Que_BdLocArt.FieldByName('ARL_ARCHIVER').value := IBQue_BoLocArt.FieldByName('ARL_ARCHIVER').asinteger;

      ///ARL_VIRTUEL
      Que_BdLocArt.FieldByName('ARL_VIRTUEL').value := IBQue_BoLocArt.FieldByName('ARL_VIRTUEL').asinteger;

      ///ARL_REFMRK
      Que_BdLocArt.FieldByName('ARL_REFMRK').value := IBQue_BoLocArt.FieldByName('ARL_REFMRK').asstring;

      ///ARL_TVATAUX
      Que_BdLocArt.FieldByName('ARL_TVATAUX').value := IBQue_BoLocArt.FieldByName('ARL_TVATAUX').asfloat;

      ///ARL_LOUEAUFOURN
      Que_BdLocArt.FieldByName('ARL_LOUEAUFOURN').value := IBQue_BoLocArt.FieldByName('ARL_LOUEAUFOURN').asinteger;


      //enregistrer les modifications
      Que_BdLocArt.Post;
      countLigneOk := countLigneOk + 1;
      //suivant
      IBQue_BoLocArt.next;
    end;
  except // annuler l'insersion et réouvrir la requete
    Que_BdLocArt.CancelUpdates;
    Que_BdLocArt.close;
    Que_BdLocArt.open;
  end;
  Lab_LigneOk.Caption := 'Transposée : ' + IntToStr(countLigneOk) + ' lignes.';
  //ajouter la liste de chrono modifiés
  LogAction('Chrono modifiés :');
  LogAction('ID' + ';' + 'Ancien chrono' + ';' + 'Nouveau chrono');
  LogAction(listeNewChrono.Text);
  LogAction('Fin de la Transposition');
end;

procedure TFrm_Main.GenerikAfterCancel(DataSet: TDataSet);
begin
  Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_Main.GenerikAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_Main.GenerikBeforeDelete(DataSet: TDataSet);
begin
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
end;

procedure TFrm_Main.GenerikNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_Main.GenerikUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;


function TFrm_Main.findNewId(oldId: Integer; liste: TstringList): Integer;
var
  id, i, index: Integer;
  strOldId, strNewId: string;
begin
  id := 0;
  i := 0;
  //Trouve l'occurence unique de l'ancien id dans la liste et retourne le nouvel id qui lui est associé, -1 s'il n'existe pas
  //créer la chaine à rechercher
  strOldId := ';' + intToStr(oldId) + ';';
  //Parcourir toute la liste et recopier le nouvel id
  for i := 0 to liste.Count - 1 do
  begin
    if pos(strOldId, liste[i]) <> 0 then
    begin
      index := Pos('/', Liste[i]);
      strNewId := copy(Liste[i], index + 1, length(Liste[i]));
      try
        id := StrToInt(strNewId);
        //sortir de la boucle for
        break;
      except
        id := 0;
      end;
    end;
  end;
  //recherche la chaine
  //si trouvée,recopier la valeur et arreter la recherche.
  result := id;
end;

procedure TFrm_Main.LMDSpeedButton1Click(Sender: TObject);
var
  i: Integer;
begin
  //

end;

procedure TFrm_Main.Nbt_ODCSVClick(Sender: TObject);
begin
  //si un fichier est sélectionné
  if OD_CSV.Execute then
  begin
    //recopier son nom
    Chp_CvsCategorie.Text := OD_CSV.FileName;
  end;
  //gestion des boutons
  boutons();
end;

procedure TFrm_Main.AlgolStdFrmClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //libérer les listes
  listeNewId.free;
  listeNewChrono.free;
  Grd_Close.Close;
  //se déconnecter
  if IBC_BaseOri.Connected then
  begin
    //se déconnecter
    IBC_BaseOri.Close();
  end;
end;

procedure TFrm_Main.Nbt_QuitterClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_Main.Custom_RequeteChange(Sender: TObject);
begin
  //gestion des boutons
  boutons();
end;

function TFrm_Main.transpoChrono(chrono: string): Boolean;
var
  retour: boolean;
begin
  retour := false;
  try
    //Vérifie si le chrono existe déjà, si oui le chrono existant prend la prochaine valeur du générateur
    //celui de la base d'origine garde sa valeur car ses articles ont des étiquettes pas pré-imprimées

    //trouver l'article ayant le même chrono
    Que_chrono.close;
    Que_chrono.ParamByName('arlchrono').value := chrono;
    Que_chrono.open;

    if not Que_chrono.Eof then
    begin
      // obtenir un nouveau numéro de chrono
      Que_NewChrono.Close;
      Que_NewChrono.Open;
      //garder la trace de la modification

      listeNewChrono.add(Que_chrono.FieldByName('arl_id').asstring + ';' + Que_chrono.FieldByName('arl_chrono').asstring + ';' + Que_NewChrono.FieldByName('NEWNUM').asstring);
      //changer la valeur
      que_chrono.edit;
      Que_chrono.FieldByName('arl_chrono').value := Que_NewChrono.FieldByName('NEWNUM').asstring;
      Que_chrono.post;
      retour := true;
    end;
  finally
    que_chrono.close;
    Que_NewChrono.Close;
    result := retour;
  end;
end;

end.

