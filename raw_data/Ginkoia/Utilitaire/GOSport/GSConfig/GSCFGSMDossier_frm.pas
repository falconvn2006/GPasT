unit GSCFGSMDossier_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, Buttons, ExtCtrls, DB, IBODataset, Grids,
  DBGrids, ComCtrls, FileCtrl, DateUtils, IniFiles;

type
  TFsmDossier = class(TForm)
    Pan_Haut: TPanel;
    Gbx_ParametreGeneraux: TGroupBox;
    Lab_Domaine: TLabel;
    Lab_Axe: TLabel;
    Lab_TVA: TLabel;
    Lab_Garantie: TLabel;
    Lab_TypeComptable: TLabel;
    Pan_Gauche: TPanel;
    Gbx_Informations: TGroupBox;
    Lab_Dossier: TLabel;
    Lab_DB: TLabel;
    Lab_IDGS: TLabel;
    Nbt_DBLan: TBitBtn;
    Nbt_CheminBase: TBitBtn;
    Gbx_Commentaires: TGroupBox;
    Lab_Active: TLabel;
    Pan_Bottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    txt_Dossier: TEdit;
    txt_Chemin: TEdit;
    txt_IdGS: TEdit;
    Rgr_Active: TRadioGroup;
    mmo_Commentaire: TMemo;
    opd_Base: TOpenDialog;
    cbo_Domaine: TComboBox;
    cbo_Axe: TComboBox;
    cbo_TVA: TComboBox;
    cbo_TypeComptable: TComboBox;
    cbo_Garantie: TComboBox;
    Pan_Magasin: TPanel;
    Gbx_Magasin: TGroupBox;
    Ds_Magasin: TDataSource;
    dbg_Magasin: TDBGrid;
    Pan_Connexion: TPanel;
    Gbx_BaseExtract: TGroupBox;
    Chk_BeActive: TCheckBox;
    Gbx_InteOffreReduc: TGroupBox;
    Chp_CheminDeposeFic: TEdit;
    Lab_CheminDepFichier: TLabel;
    Nbt_DeposeFic: TBitBtn;
    Lab_IdExtract: TLabel;
    Chp_IdExtraction: TEdit;
    Lab_LastDateExtraction: TLabel;
    Dtp_LasDatetExtraction: TDateTimePicker;
    Lab_RecupFic: TLabel;
    Chp_CheminRecupFichier: TEdit;
    Nbt_RecupFichier: TBitBtn;
    Lab_LastInt: TLabel;
    Dtp_LastDateIntegration: TDateTimePicker;
    Chk_Initialisation: TCheckBox;
    Dtp_DateInitialisation: TDateTimePicker;
    Lab_DateInit: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure txt_IdGSKeyPress(Sender: TObject; var Key: Char);
    procedure cbo_DomaineChange(Sender: TObject);
    procedure dbg_MagasinDblClick(Sender: TObject);
    procedure Nbt_CheminBaseClick(Sender: TObject);
    procedure Nbt_DBLanClick(Sender: TObject);
    procedure Chk_BeActiveClick(Sender: TObject);
    procedure Nbt_DeposeFicClick(Sender: TObject);
    procedure Nbt_RecupFichierClick(Sender: TObject);
  private
    vgStrlIdDomaine     : TStringList;
    vgStrlIdAxe         : TStringList;
    vgStrlIdTva         : TStringList;
    vgStrlIdGarantie    : TStringList;
    vgStrlIdComptable   : TStringList;
    vgStrlIdFournisseur : TStringList;

    procedure Initialiser;

    function  ConnexionALaBaseGinkoia(vpChemin : String): Boolean;
    function  BaseGinkoia : Boolean;
    procedure AffichageSelonLaConnexion;

    procedure AfficherRenseignement;
    procedure AfficherParametre;
    procedure AfficherInfoMagasin;

    function  IndiqueIndexParametre(vpStrl : TStringList; vpType, vpCode : Integer) : Integer;
    procedure RemplirCDS_Magasin;

    procedure InitialiserComboBox(vpCombo : TComboBox; vpStrl : TStringList);
    procedure InitialiserTousLesComboBox;

    procedure RemplirTousLesComboBox;

    function  OnContinue : Boolean;
    function  ToutEstRenseigne : Boolean;
    function  EstUnique : Boolean;

    function  DB_INSERT_Dossier(var vIdDossier : integer) : Boolean;
    function  DB_UPDATE_Dossier(var vIdDossier : integer) : Boolean;

    function  Enregistrer_TousLesParametres : Boolean;
    function  Enregistrer_InfoMagasin       : Boolean;

    function  DB_UPDATE_Parametre(vpType, vpCode, vpIdTable : Integer) : Boolean;
    function  DB_UPDATE_Magasin_Numero_User : Boolean;
    function  DB_UPDATE_Magasin_Type : Boolean;
//CAF
    function  DB_UPDATE_Magasin_Mode : Boolean;
//
    function VerificationDesPrerequis : Boolean;
  public
    function  GenID : Integer;

    procedure RemplirComboBox(vpQuery : TIBOQuery; vpCombo : TComboBox; vpStrl :TStringList);
    Procedure AfficheInfoOffreReduc;
    Procedure GetEditExtract(Val : Boolean);
    Function  SavParamOffreReduc(vIdDossier : integer) : Boolean;
  end;

var
  FsmDossier: TFsmDossier;

implementation

{$R *.dfm}

uses GSCFGMain_DM, GSCFG_Types, GSCFGSMMagasin_Frm;

procedure TFsmDossier.FormCreate(Sender: TObject);
begin
  Initialiser;
end;

procedure TFsmDossier.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  vgStrlIdDomaine.Clear;
  vgStrlIdAxe.Clear;
  vgStrlIdTva.Clear;
  vgStrlIdGarantie.Clear;
  vgStrlIdComptable.Clear;
  vgStrlIdFournisseur.Clear;

  vgStrlIdDomaine.Free;
  vgStrlIdAxe.Free;
  vgStrlIdTva.Free;
  vgStrlIdGarantie.Free;
  vgStrlIdComptable.Free;
  vgStrlIdFournisseur.Free;

  Action := CaFree;
end;

procedure TFsmDossier.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key) = VK_Escape then
    Close;
end;

function TFsmDossier.VerificationDesPrerequis: Boolean;
var
  sResult, CEN_NOM :String;
  CEN_ID, CEN_CODE, ACT_ID : Integer;
begin
  Result := True;
  sResult := '';
  With FMain_DM.Que_Select_Ginkoia do
  begin
    // Verification du dossier
    Close ;
    SQL.Clear ;
    SQL.Add('SELECT DOS_STRING FROM GENDOSSIER') ;
    SQL.Add('JOIN K ON K_ID = DOS_ID AND K_ENABLED=1') ;
    SQL.Add('WHERE DOS_NOM = ''CENTRALE''') ;
    Open;
    CEN_NOM := FieldByName('DOS_STRING').AsString ;
    if ((CEN_NOM <> 'GOSPORT') and (CEN_NOM <> 'COURIR')) then
    begin
        sResult := '- La base n''est pas liée a une centrale GOSPORT ou COURIR' ;
        Result := false ;
    end;

    // Vérification de la présence de la centrale GOSport
    Close;
    SQL.Clear;
    SQL.Add('Select CEN_ID, CEN_CODE from GENCENTRALE');
    SQL.Add('  Join K on K_ID = CEN_ID and K_enabled = 1');
    SQL.Add('Where (CEN_NOM = :PCENNOM)');
    SQL.Add('GROUP BY CEN_ID, CEN_CODE');
    ParamCheck := True;
    ParamByName('PCENNOM').AsString := CEN_NOM ;
    Open;

    CEN_ID   := FieldbyName('CEN_ID').AsInteger;
    CEN_CODE := FieldbyName('CEN_CODE').AsInteger;
    if ((CEN_CODE <> 6) and (CEN_CODE <> 7)) then
    begin
      sResult := '- La centrale GOSPORT ou COURIR n''est pas présente'#13#10;
      Result := False;
    end;

    // vérification de la présence du domaine GOSPORT
    Close;
    SQL.Clear;
    SQL.Add('Select ACT_ID, count(*) as Resultat from NKLACTIVITE');
    SQL.Add('  Join K on K_ID = ACT_ID and K_Enabled = 1');
    SQL.Add('Where ACT_CENID = :PCENID and ACT_CENID <> 0');
    SQL.Add('GROUP BY ACT_ID');
    ParamCheck := True;
    ParamByName('PCENID').AsInteger := CEN_ID;
    Open;
    ACT_ID := FieldByName('ACT_ID').AsInteger;
    if FieldByName('Resultat').AsInteger = 0 then
    begin
      sResult := sResult + '- Pas de domaine GOSPORT présent'#13#10;
      Result := False;
    end;

    // vérification de la présence de l'univers GOSPORT
    Close;
    SQL.Clear;
    SQL.Add('Select count(*) as resultat from NKLUNIVERS');
    SQL.Add('  Join K on K_ID = UNI_ID and K_Enabled = 1');
    SQL.Add('Where UNI_ACTID = :PACTID and (UNI_CENTRALE = :PCENCODE)');
    ParamCheck := True;
    ParamByName('PACTID').AsInteger := ACT_ID;
    ParamByName('PCENCODE').AsInteger := CEN_CODE;
    Open;
    if FieldByName('Resultat').AsInteger = 0 then
    begin
      sResult := sResult + '- Pas d''univers GOSPORT ou COURIR Présent'#13#10;
      Result := False;
    end;

    // Vérification de la présence du fournisseur GOSPORT
    Close;
    SQL.Clear;
    SQL.Add('Select count(*) as Resultat FROM ARTFOURN');
    SQL.Add('  Join K on K_ID = FOU_ID and K_Enabled = 1');
    SQL.Add('Where FOU_CODE = ''9999999'' and (FOU_CENTRALE = :PCENCODE)');
    ParamCheck := True;
    ParamByName('PCENCODE').AsInteger := CEN_CODE;
    Open;
    if FieldByName('Resultat').AsInteger = 0 then
    begin
      sResult := sResult + '- Pas de fournisseur GOSPORT ou COURIR présent'#13#10;
      Result := False;
    end;

    // Vérification que le tarif de vente GOSPORT est présent
    Close;
    SQL.Clear;
    SQL.Add('Select count(*) as Resultat from TARVENTE');
    SQL.Add('  Join K on K_ID = TVT_ID and K_Enabled = 1');
    SQL.Add('Where (TVT_CENTRALE = :PCENCODE)');
    ParamCheck := True;
    ParamByName('PCENCODE').AsInteger := CEN_CODE;
    Open;
    if FieldByName('Resultat').AsInteger = 0 then
    begin
      sResult := sResult + '- Pas de tarif de vente GOSPORT ou COURIR présent'#13#10;
      Result := False;
    end;

    if not Result then
    begin
      sResult := 'Il manque des données nécessaire au fonctionnement du logiciel GSDATA'#13#10#13#10 + sResult +
                 #13#10'Veuillez mettre à jour la base avant de créer/mettre à jour un dossier';
      ShowMessage(Trim(sResult));
    end;
  end;
end;


//-------------------------------------------------------------> Initialiser

procedure TFsmDossier.Initialiser;
Var
  FicIni : TIniFile;
  DirIni : String;
begin
  vgStrlIdDomaine     := TStringList.Create;
  vgStrlIdAxe         := TStringList.Create;
  vgStrlIdTva         := TStringList.Create;
  vgStrlIdGarantie    := TStringList.Create;
  vgStrlIdComptable   := TStringList.Create;
  vgStrlIdFournisseur := TStringList.Create;

  pan_Connexion.Color := $009F9FFF;  // Couleur rouge
  FMain_DM.cds_Magasin.EmptyDataSet;

  InitialiserTousLesComboBox;

  if GTypeSaisie = tsAjout then
  begin
    GetEditExtract(Chk_BeActive.Checked);

    //On a créer un nouveau dossier on va donc charger les dossiers par defaut
    DirIni := ExtractFilePath(Application.ExeName)
             + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');
    try
      FicIni := TIniFile.Create(DirIni);

      //Verification si la section existe
      if FicIni.SectionExists('DOSSIER EXTRACT') then
      begin
        Chp_CheminDeposeFic.Text := IncludeTrailingPathDelimiter(FicIni.ReadString('DOSSIER EXTRACT', 'CHEMIN DEPOSE FICHIER', 'C:\'));
      end;

      if FicIni.SectionExists('DOSSIER INTEGRE') then
      begin
        Chp_CheminRecupFichier.Text := IncludeTrailingPathDelimiter(FicIni.ReadString('DOSSIER INTEGRE', 'CHEMIN RECUP FICHIER', 'C:\'));
      end;
    finally
      FicIni.Free;
    end;
  end;

  if GTypeSaisie = tsModif then
  begin
    AfficherRenseignement;
    AfficheInfoOffreReduc;
  end;

end;

//------------------------------------------------------------------------------
//                                                           +-----------------+
//                                                           |    AFFICHAGE    |
//                                                           +-----------------+
//------------------------------------------------------------------------------

//---------------------------------------------------> AfficherRenseignement

procedure TFsmDossier.AfficherRenseignement;
begin
  with FMain_DM do
  begin
    txt_Dossier.Text           := cds_DossierDOS_NOM.AsString;
    txt_Chemin.Text            := cds_DossierDOS_PATH.AsString;
    txt_IdGS.Text              := cds_DossierDOS_IDGS.AsString;
    rgr_Active.ItemIndex       := cds_DossierDOS_ACTIVE.AsInteger;
    mmo_Commentaire.Lines.Text := cds_DossierDOS_COMENT.AsString;

    AffichageSelonLaConnexion;
    FMain_DM.cds_Magasin.EmptyDataSet;

    if txt_Chemin.Text <> '' then
      if ConnexionALaBaseGinkoia(txt_Chemin.Text) then
        if baseGinkoia then
        begin
          RemplirTousLesComboBox;
          RemplirCDS_Magasin;

          AfficherParametre;
          AfficherInfoMagasin;
        end;
  end;
end;

 //-------------------------------------------------------> AfficherParametre

procedure TFsmDossier.AfficherParametre;
begin
  cbo_Domaine.ItemIndex := IndiqueIndexParametre(vgStrlIdDomaine, 16, 1);
                                  // On rafraichit le combo des axes en fonction
                                  // du domaine
  RemplirComboBox(FMain_DM.que_ListeAxe, cbo_Axe, vgStrlIdAxe);

  cbo_Axe.ItemIndex           := IndiqueIndexParametre(vgStrlIdAxe,         16, 2);
  cbo_TVA.ItemIndex           := IndiqueIndexParametre(vgStrlIdTVA,         16, 3);
  cbo_Garantie.ItemIndex      := IndiqueIndexParametre(vgStrlIdGarantie,    16, 4);
  cbo_TypeComptable.ItemIndex := IndiqueIndexParametre(vgStrlIdComptable,   16, 5);
//  cbo_Fournisseur.ItemIndex   := IndiqueIndexParametre(vgStrlIdFournisseur, 16, 9);

  Nbt_Post.Enabled := VerificationDesPrerequis;
end;

//---------------------------------------------------> IndiqueIndexParametre

function TFsmDossier.IndiqueIndexParametre(vpStrl : TStringList;
vpType, vpCode : Integer) : Integer;
var
  vIdParametre, vIndex : Integer;
begin
  vIdParametre := 0;
  vIndex       := 0;
                                  // On va chercher les informations liées à ce paramètre
  with FMain_DM.Que_Select_Ginkoia do
  begin
    SQL.Clear;

    try
      Close;

      SQL.Add(' select PRM_INTEGER ');
      SQL.Add(' from GENPARAM ');
      SQL.Add(' join K on K_ID = PRM_Id and K_ENABLED = 1');
      SQL.Add(' where PRM_TYPE = :PPRMTYPE');
      SQL.Add(' and   PRM_CODE = :PPRMCODE');

      ParamByName('PPRMTYPE').AsInteger := vpType;
      ParamByName('PPRMCODE').AsInteger := vpCode;

      Open;

      if not IsEmpty then
        vIdParametre := FieldByName('PRM_INTEGER').AsInteger;

      Close;
    except
      ShowMessage('Erreur d''accès à la table GENPARAM');
    end;
  end;
                                  // on regarde dans la StringList l'index correspondant
  if vIdParametre <> 0 then
  begin
    vIndex :=  vpStrl.IndexOf(IntToStr(vIdParametre));
                                  // si index non trouvé, on se replace sur la 1ère ligne
    if vIndex = -1 then
      vIndex := 0;
  end;

  Result := vIndex;
end;

//-----------------------------------------------------> AfficherInfoMagasin

procedure TFsmDossier.AfficheInfoOffreReduc;
begin
  //porcedure permettant d'afficher les informations sur les parties base d'extraction et integration offre de réduction
  with FMain_DM do
  begin
    try

      //Extraction
      Chk_BeActive.Checked             := (Cds_DossierDOS_EXTRACT.AsInteger = 1);
      Chp_CheminDeposeFic.Text         := Cds_DossierDOS_EXTRACTDIR.AsString;
//JB
//      Chp_CheminRecupFichier.Text      := Cds_DossierDOS_INTEGREDIR.AsString;
//      Chp_IdExtraction.Text            := IntToStr(Cds_DossierDOS_EXTRACT.AsInteger);
      Chp_IdExtraction.Text            := cds_DossierDOS_EXTRACTID.AsString;
//
      Dtp_LasDatetExtraction.DateTime  := Cds_DossierDOS_EXTRACTLASTDATE.AsDateTime;

      //Integration offre de réduction
      Chp_CheminRecupFichier.Text      := Cds_DossierDOS_INTEGREDIR.AsString;
      Dtp_LastDateIntegration.DateTime := Cds_DossierDOS_INTEGRELASTDATE.AsDateTime;
      Chk_Initialisation.Checked       := (Cds_DossierDOS_INTEGREINIT.AsInteger = 1);
      Dtp_DateInitialisation.DateTime  := Cds_DossierDOS_INTEGREINITDATE.AsDateTime;
//JB      Chp_IdExtraction.Text            := cds_DossierDOS_EXTRACTID.AsString;

      GetEditExtract(Chk_BeActive.Checked);

    Except on e : Exception do
      begin
        ShowMessage('Erreur d''accès à la table Dossier');
      end;
    end;
  end;
end;

procedure TFsmDossier.AfficherInfoMagasin;
begin
  with FMain_DM.Que_InfoMagasin do
  begin
    try
      Close;
      ParamByName('MAGID').AsInteger := FMain_DM.cds_MagasinIdMagasin.AsInteger;
      Open;

      if not IsEmpty then
      begin
        FMain_DM.cds_Magasin.Edit;

        FMain_DM.cds_MagasinNumero.AsString         := FieldByName('NUMERO').AsString;
        FMain_DM.cds_MagasinIdUtilisateur.AsInteger := FieldByName('IDUSER').AsInteger;
        FMain_DM.cds_MagasinUtilisateur.AsString    := FieldByName('USERNAME').AsString;
        FMain_DM.cds_MagasinType.AsInteger          := FieldByName('LETYPE').AsInteger;
//CAF
        FMain_DM.cds_MagasinMode.AsInteger          := FieldByName('LEMODE').AsInteger;

        case FMain_DM.cds_MagasinMode.AsInteger of
          1: FMain_DM.cds_MagasinLibelleMode.AsString := 'Affilié';
          2: FMain_DM.cds_MagasinLibelleMode.AsString := 'CAF';
        end;
//
        case FMain_DM.cds_MagasinType.AsInteger of
          1: FMain_DM.cds_MagasinLibelleType.AsString := 'GoSport';
          2: FMain_DM.cds_MagasinLibelleType.AsString := 'Courir';
        end;

        FMain_DM.cds_Magasin.Post;
      end;

      Close;
    except
      ShowMessage('Erreur d''accès à la table GENPARAM');
    end;
  end;
end;

//------------------------------------------------------------------------------
//                                                               +-------------+
//                                                               |    OBJET    |
//                                                               +-------------+
//------------------------------------------------------------------------------

//------------------------------------------------------------------> Bouton

procedure TFsmDossier.Nbt_CheminBaseClick(Sender: TObject);
var
  vChemin : String;
begin
  vChemin := '';

  if opd_Base.Execute then
    begin
      vChemin := opd_Base.FileName;
      txt_Chemin.Text := vChemin;

      AffichageSelonLaConnexion;
      FMain_DM.cds_Magasin.EmptyDataSet;

      if Trim(vChemin) = '' then
        Exit;

      if ConnexionALaBaseGinkoia(vChemin) then
        if BaseGinkoia then
        begin
          RemplirTousLesComboBox;
          RemplirCDS_Magasin;

          AfficherParametre;
          AfficherInfoMagasin;
        end;
    end;
end;

procedure TFsmDossier.Nbt_DBLanClick(Sender: TObject);
begin
  AffichageSelonLaConnexion;
  FMain_DM.cds_Magasin.EmptyDataSet;

  if Trim(txt_chemin.Text) = '' then
    Exit;

  if ConnexionALaBaseGinkoia(Trim(txt_chemin.Text)) then
    if baseGinkoia then
    begin
      RemplirTousLesComboBox;
      RemplirCDS_Magasin;

      AfficherParametre;
      AfficherInfoMagasin;
    end;
end;

procedure TFsmDossier.Nbt_DeposeFicClick(Sender: TObject);
var
  CheminDepose : String;
begin
  if SelectDirectory(CheminDepose, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    if not (CheminDepose[Length(CheminDepose)] = '\') then
          CheminDepose := CheminDepose + '\';

    Chp_CheminDeposeFic.Text := CheminDepose;
  end;
end;

procedure TFsmDossier.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFsmDossier.Nbt_PostClick(Sender: TObject);
var
  vRecOk : Boolean;
  vIdDossier : Integer;

begin                            // Si toutes les conditions ne sont pas réunis, on sort
  if not OnContinue then
    Exit;
                                  // Selon le type de saisie, on insert ou on udptate
  case GTypeSaisie of
    tsAjout : vRecOk := DB_INSERT_Dossier(vIdDossier);
    tsModif : vRecOk := DB_UPDATE_Dossier(vIdDossier);
  else
    vRecOk := False;
  end;
                                  // si l'enregistrement a réussi, on sort de la fiche
  if vRecOk then
  begin

    if FMain_DM.idb_GoSport.Connected then
    begin
      if not SavParamOffreReduc(vIdDossier) then
      begin
        ShowMessage('Erreur durant l''enregistrement des paramètres d''offres de réduction');
      end;
    end;

    if FMain_DM.idb_Ginkoia.Connected then
      if not Enregistrer_TousLesParametres then
      begin
        ShowMessage('Erreur durant l''enregistrement des paramètres');
        Exit;
      end;

    FMain_DM.OuvrirTable;
    Close;
  end;
end;

procedure TFsmDossier.Nbt_RecupFichierClick(Sender: TObject);
var
  CheminRecup : String;
begin
  if SelectDirectory(CheminRecup, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    if not (CheminRecup[Length(CheminRecup)] = '\') then
          CheminRecup := CheminRecup + '\';

    Chp_CheminRecupFichier.Text := CheminRecup;
  end;
end;

//-------------------------------------------------------------------> Combo

procedure TFsmDossier.cbo_DomaineChange(Sender: TObject);
begin
  RemplirComboBox(FMain_DM.que_ListeAxe, cbo_Axe, vgStrlIdAxe);
end;

//--------------------------------------------------------------------> Edit

procedure TFsmDossier.txt_IdGSKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9'])
  and    (ord(Key) <> VK_Back)
  and    (ord(Key) <> VK_Return) then
    Key := chr(0);
end;

//------------------------------------------------------------------> Grille

procedure TFsmDossier.dbg_MagasinDblClick(Sender: TObject);
begin
  if FMain_DM.Que_Magasin.RecordCount = 0 then
    Exit;

  FsmMagasin := TFsmMagasin.Create(self);
  FsmMagasin.ShowModal;
end;

//------------------------------------------------------------------------------
//                                                           +-----------------+
//                                                           |  REMPLIR COMBO  |
//                                                           +-----------------+
//------------------------------------------------------------------------------

//-----------------------------------------------------> InitialiserComboBox

procedure TFsmDossier.InitialiserComboBox(vpCombo : TComboBox;
vpStrl : TStringList);
begin
  vpCombo.Clear;
  vpStrl.Clear;

  vpCombo.Items.Add('<Choisir>');
  vpStrl.Add('0');

  vpCombo.ItemIndex := 0;
end;

//----------------------------------------------> InitialiserTousLesComboBox

procedure TFsmDossier.InitialiserTousLesComboBox;
begin
  InitialiserComboBox(cbo_Domaine, vgStrlIdDomaine);
  InitialiserComboBox(cbo_Axe, vgStrlIdAxe);
  InitialiserComboBox(cbo_Tva, vgStrlIdTva);
  InitialiserComboBox(cbo_Garantie, vgStrlIdGarantie);
  InitialiserComboBox(cbo_TypeComptable, vgStrlIdComptable);
//  InitialiserComboBox(cbo_Fournisseur, vgStrlIdFournisseur);

  Chp_IdExtraction.Text := '0';

  //Initialisation des dates
  Dtp_LasDatetExtraction.DateTime  := DateUtils.DayOfTheYear(Now);
  Dtp_LastDateIntegration.DateTime := DateUtils.DayOfTheYear(Now);
  Dtp_DateInitialisation.DateTime  := DateUtils.DayOfTheYear(Now);
end;

//--------------------------------------------------> RemplirTousLesComboBox

procedure TFsmDossier.RemplirTousLesComboBox;
begin
  RemplirComboBox(FMain_DM.que_ListeDomaine, cbo_Domaine, vgStrlIdDomaine);
  RemplirComboBox(FMain_DM.que_ListeAxe, cbo_Axe, vgStrlIdAxe);
  RemplirComboBox(FMain_DM.que_ListeTva, cbo_Tva, vgStrlIdTva);
  RemplirComboBox(FMain_DM.que_ListeGarantie, cbo_Garantie, vgStrlIdGarantie);
  RemplirComboBox(FMain_DM.que_ListeTypeComptable, cbo_TypeComptable, vgStrlIdComptable);
//  RemplirComboBox(FMain_DM.que_ListeFournisseur, cbo_Fournisseur, vgStrlIdFournisseur);
end;

function TFsmDossier.SavParamOffreReduc(vIdDossier : integer): Boolean;
begin
  //Fonction qui permet de sauvegarder les paramètre lier au offre de réduction
  with FMain_DM do
  begin
    try
//JB
      Ibc_Maj_GoSport.IB_Transaction.StartTransaction();
//
      IbC_Maj_GoSport.SQL.Clear;

      //Sauvegarde des parametre lier à l'integration des offres de réduction
      IbC_Maj_GoSport.SQL.Text   := 'UPDATE DOSSIERS SET ' +
                                    'DOS_EXTRACTDIR = :DOSEXTRACTDIR, DOS_EXTRACTID = :DOSEXTRACTID, ' +
                                    'DOS_EXTRACTLASTDATE = :DOSEXTRACTLASTDATE, DOS_INTEGREDIR = :DOSINTEGREDIR, ' +
                                    'DOS_INTEGREINIT = :DOSINTEGREINIT, DOS_INTEGREINITDATE = :DOSINTEGREINITDATE, ' +
                                    'DOS_INTEGRELASTDATE = :DOSINTEGRELASTDATE, DOS_EXTRACT = :DOSEXTRACT '+
                                    'WHERE DOS_ID = :DOSID';
      IbC_Maj_GoSport.ParamCheck := True;
      IbC_Maj_GoSport.ParamByName('DOSEXTRACTDIR').AsString         := Chp_CheminDeposeFic.Text;
      IbC_Maj_GoSport.ParamByName('DOSEXTRACTID').AsString          := Chp_IdExtraction.Text;
      IbC_Maj_GoSport.ParamByName('DOSEXTRACTLASTDATE').AsDateTime  := Dtp_LasDatetExtraction.DateTime;

      IbC_Maj_GoSport.ParamByName('DOSINTEGREDIR').AsString         := Chp_CheminRecupFichier.Text;
      IbC_Maj_GoSport.ParamByName('DOSINTEGRELASTDATE').AsDateTime  := Dtp_LastDateIntegration.DateTime;
      if Chk_Initialisation.Checked then
      begin
        IbC_Maj_GoSport.ParamByName('DOSINTEGREINIT').AsInteger     := 1;
      end else
      begin
        IbC_Maj_GoSport.ParamByName('DOSINTEGREINIT').AsInteger     := 0;
      end;
      IbC_Maj_GoSport.ParamByName('DOSINTEGREINITDATE').AsDateTime  := Dtp_DateInitialisation.DateTime;

      if Chk_BeActive.Checked then
      begin
        IbC_Maj_GoSport.ParamByName('DOSEXTRACT').AsInteger         := 1;
      end else
      begin
        IbC_Maj_GoSport.ParamByName('DOSEXTRACT').AsInteger         := 0;
      end;

      IbC_Maj_GoSport.ParamByName('DOSID').AsInteger                := vIdDossier;
      IbC_Maj_GoSport.ExecSQL;

      IbC_Maj_GoSport.IB_Transaction.Commit;

      Result := True;
    except on e : Exception do
      begin
        IbC_Maj_GoSport.IB_Transaction.Rollback;
        ShowMessage(e.Message);
        Result := False;
      end;
    end;
  end;
end;

//---------------------------------------------------------> RemplirComboBox

procedure TFsmDossier.RemplirComboBox(vpQuery : TIBOQuery;
vpCombo : TComboBox; vpStrl :TStringList);
var
  vIdDomaine : Integer;
begin
  vpCombo.Items.BeginUpdate;

  InitialiserComboBox(vpCombo, vpStrl);
                                  // Si la query est l'axe, on doit avoir l'id du domaine
  if  (vpQuery = FMain_DM.Que_ListeAxe)
  and (cbo_Domaine.ItemIndex = 0) then
  begin
    vpCombo.Items.EndUpdate;
    Exit;
  end;

  with vpQuery do
  begin
    try
      Close;
                                  // Si la query est l'axe, on passe l'IdDomaine en paramètre
      if vpQuery = FMain_DM.Que_ListeAxe then
      begin
        vIdDomaine := StrToInt(vgStrlIdDomaine.strings[cbo_Domaine.ItemIndex]);

        ParamByName('ACTID').AsInteger := vIdDomaine;
      end;

      Open;

      //On rajoute le TVA Code pour le combo box TVA
      if vpQuery = FMain_DM.Que_ListeTVA then
      begin
        while not EoF do
        begin
          vpCombo.Items.Add(Fields[1].AsString +'       '+Fields[2].AsString);   // indique le nom
          vpStrl.Add(Fields[0].AsString);          // indique l'ID
          Next;
        end;
      end else
      begin
        while not EoF do
        begin
          vpCombo.Items.Add(Fields[1].AsString);   // indique le nom
          vpStrl.Add(Fields[0].AsString);          // indique l'ID

          Next;
        end;
      end;

    except
      ShowMessage('Erreur d''accès à la table lors du chargement de : ' + vpCombo.Hint);

      InitialiserComboBox(vpCombo, vpStrl);
    end;
  end;

  vpCombo.ItemIndex := 0;
  vpCombo.Items.EndUpdate;
end;

//------------------------------------------------------------------------------
//                                                         +-------------------+
//                                                         |  REMPLIR MAGASIN  |
//                                                         +-------------------+
//------------------------------------------------------------------------------

//------------------------------------------------------> RemplirCDS_Magasin

procedure TFsmDossier.RemplirCDS_Magasin;
begin
  with FMain_DM do
  begin
    try
      cds_Magasin.EmptyDataSet;
      cds_Magasin.DisableControls;

      que_Magasin.Close;
      que_Magasin.open;

      Que_GoSport_ReUsable.SQL.Text := 'select * from mag;';
      Que_GoSport_ReUsable.Open();

      while not que_Magasin.EoF do
      begin
        cds_Magasin.Append;

        cds_MagasinNomMagasin.AsString     := que_MagasinMAGASIN.AsString;
        cds_MagasinIdMagasin.AsInteger     := que_MagasinMAG_ID.AsInteger;
        cds_MagasinVille.AsString          := que_MagasinVILLE.AsString;
        cds_MagasinNumero.AsString         := que_MagasinNUMERO.AsString;
        cds_MagasinIdUtilisateur.AsInteger := que_MagasinIDUSER.AsInteger;
        cds_MagasinUtilisateur.AsString    := que_MagasinNOMUSER.AsString;
        cds_MagasinType.AsInteger          := que_MagasinLETYPE.AsInteger;
//CAF
        cds_MagasinMode.AsInteger          := Que_MagasinLEMODE.AsInteger;
//
        cds_MagasinIdParametre6.AsInteger  := que_MagasinIDPARAMETRE6.AsInteger;
        cds_MagasinIdParametre7.AsInteger  := que_MagasinIDPARAMETRE7.AsInteger;
//CAF
        cds_MagasinIdParametre8.AsInteger  := que_MagasinIDPARAMETRE8.AsInteger;
        case cds_MagasinMode.AsInteger of
          1: cds_MagasinLibelleMode.AsString := 'Affilié';
          2: cds_MagasinLibelleMode.AsString := 'CAF';
          3: cds_MagasinLibelleMode.AsString := 'Mandat d''achat';
        end;
//
        case cds_MagasinType.AsInteger of
          1: cds_MagasinLibelleType.AsString := 'GoSport';
          2: cds_MagasinLibelleType.AsString := 'Courir';
        end;
//JB
        if Que_GoSport_ReUsable.Locate('mag_idginkoia;mag_dosid',varArrayOf([que_Magasin.FieldByName('MAG_ID').AsInteger,cds_Dossier.FieldByName('DOS_ID').AsInteger]),[]) then
//        if Que_GoSport_ReUsable.Locate('mag_idginkoia',que_Magasin.FieldByName('MAG_ID').AsInteger,[]) then
        begin
          cds_Magasin.FieldByName('import').AsBoolean := Que_GoSport_ReUsable.FieldByName('mag_doimp').AsBoolean;
          cds_Magasin.FieldByName('export').AsBoolean := Que_GoSport_ReUsable.FieldByName('mag_doexp').AsBoolean;
        end
        else
        begin
          cds_Magasin.FieldByName('import').AsBoolean := False;
          cds_Magasin.FieldByName('export').AsBoolean := false;
        end;

        cds_Magasin.post;

        que_Magasin.Next;
      end;
      Que_GoSport_ReUsable.Close();
    finally
      cds_Magasin.EnableControls;
    end;
  end;
end;

//------------------------------------------------------------------------------
//                                                        +--------------------+
//                                                        |   CONNEXION BASE   |
//                                                        +--------------------+
//------------------------------------------------------------------------------

//-------------------------------------------------> ConnexionALaBaseGinkoia

procedure TFsmDossier.Chk_BeActiveClick(Sender: TObject);
begin
  GetEditExtract(Chk_BeActive.Checked);
end;

function TFsmDossier.ConnexionALaBaseGinkoia(vpChemin : String): Boolean;
begin
  Result := False;


  With FMain_DM.idb_Ginkoia do
  begin
    Disconnect;

    DatabaseName := vpChemin;

    try
      Connect;
      Result := Connected;

    except on E:Exception do
      raise Exception.Create('Erreur de connexion à la base de données :' + E.Message);
    end;
  end;
end;

//-------------------------------------------------------------> BaseGinkoia

function TFsmDossier.BaseGinkoia : Boolean;
begin
  Result := False;

  // On va tester si la base est bien une base ginkoia
  if FMain_DM.idb_Ginkoia.Connected then
    with FMain_DM.Que_Select_Ginkoia do
    begin
      SQL.Clear;

      try
        SQL.Add(' select count(*)');
        SQL.Add(' from GENPARAM');

        Open;
        Close;

        Result := True;
      except
        FMain_DM.idb_Ginkoia.Disconnect;

        ShowMessage('La base n''est pas une base Ginkoia correcte.');
      end;
    end;

  AffichageSelonLaConnexion;
end;

//-----------------------------------------------> AffichageSelonLaConnexion

procedure TFsmDossier.AffichageSelonLaConnexion;
begin
  if FMain_DM.idb_Ginkoia.Connected then
    pan_Connexion.Color := $00DCF5C0     // Couleur verte
  else
    pan_Connexion.Color := $009F9FFF;    // Couleur rouge
end;

//------------------------------------------------------------------------------
//                                                          +------------------+
//                                                          |   VERIFICATION   |
//                                                          +------------------+
//------------------------------------------------------------------------------

//--------------------------------------------------------> ToutEstRenseigne

function TFsmDossier.ToutEstRenseigne : Boolean;
begin
  Result := False;

  // Si un des combos n'est pas renseigné, on sort
  if (cbo_Domaine.ItemIndex = 0)
  or (cbo_Axe.ItemIndex = 0)
  or (cbo_TVA.ItemIndex = 0)
  {or (cbo_Fournisseur.ItemIndex = 0)} then
    Exit;

  Result := True;

  // Si un des magasins n'est pas complétement renseigné, on sort
  with FMain_DM.cds_Magasin do
  begin
    First;

    while not EoF do
    begin
      // si le numéro est renseigné, alors l'utilisateur doit l'être aussi
      if  (Trim(FieldByName('Numero').AsString) <> '')
      and (FieldByName('IdUtilisateur').AsInteger = 0) then
      begin
        Result := False;
        Break;
      end;

      // si l'utilisateur est renseigné, alors le numéro doit l'être aussi
      if  (FieldByName('IdUtilisateur').AsInteger <> 0)
      and (Trim(FieldByName('Numero').AsString) = '') then
      begin
        Result := False;
        Break;
      end;

      Next;
    end;
  end;
end;

//--------------------------------------------------------------> OnContinue

function TFsmDossier.OnContinue : Boolean;
begin
  Result := False;

  txt_Dossier.Text := Trim(txt_Dossier.Text);
  txt_Chemin.Text  := Trim(txt_Chemin.Text);
  txt_IdGS.Text    := Trim(txt_IdGS.Text);

  // on verifie que le nom du dossier est renseigné
  if txt_Dossier.Text = '' then
  begin
    txt_Dossier.SetFocus;
    ShowMessage('Le nom de dossier est obligatoire');
    Exit;
  end;

  // on verifie que le chemin du dossier est renseigné
  if txt_Dossier.Text = '' then
  begin
    txt_Dossier.SetFocus;
    ShowMessage('Le chemin du dossier est obligatoire');
    Exit;
  end;

  // on verifie que l'IDGS du dossier est renseigné
  if txt_IdGS.Text = '' then
  begin
    txt_IdGS.SetFocus;
    ShowMessage('L''IdGS ne peut pas être une valeur nulle');
    Exit;
  end;

  // on verifie l'unicité du nom de dossier et de la base
  if not EstUnique then
    Exit;

  // si tout n'est pas renseigné, le dossier ne peut pas êtr actif
  if not ToutEstRenseigne then
    begin

      MessageDlg('Toutes les informations nécessaires à la '          + chr(13) +
                 'configuration du dossier ne sont pas renseignées.' + chr(13) + chr(13) +
                 'Ce dossier ne peut donc pas être enregistré.', mtError, [MBOK], 0);
      Exit;
    end;

  // Si tout est ok, alors on peut enregistrer
  Result := True;
end;

//---------------------------------------------------------------> EstUnique

function TFsmDossier.EstUnique : Boolean;
var
  vBKM       : TBookMark;
  vIdDossier : Integer;
begin
  Result := False;
  vBKM   := FMain_DM.cds_Dossier.GetBookmark;

  if GTypeSaisie = tsModif then
  begin
    vIdDossier := FMain_DM.cds_DossierDOS_ID.AsInteger;

    // On verifie que le nom du dossier n'existe pas
    if FMain_DM.cds_Dossier.Locate('DOS_NOM', txt_Dossier.text, []) then
      if FMain_DM.cds_DossierDOS_ID.AsInteger <> vIdDossier then
      begin
        txt_Dossier.SetFocus;
        ShowMessage('Ce nom de dossier existe déjà');
        FMain_DM.cds_Dossier.GotoBookmark(vBKM);
        Exit;
      end;
  end
  else
  if GTypeSaisie = tsAjout then
  begin
    // On verifie que le nom du dossier n'existe pas
    if FMain_DM.cds_Dossier.Locate('DOS_NOM', txt_Dossier.text, []) then
    begin
      txt_Dossier.SetFocus;
      ShowMessage('Nom existe déjà');
      FMain_DM.cds_Dossier.GotoBookmark(vBKM);
      Exit;
    end;
  end;

  FMain_DM.cds_Dossier.GotoBookmark(vBKM);
  Result := True;
end;

//------------------------------------------------------------------------------
//                                                    +------------------------+
//                                                    |  ACTION TABLE DOSSIER  |
//                                                    +------------------------+
//------------------------------------------------------------------------------

//-------------------------------------------------------------------> GenID

function TFsmDossier.GenID : Integer;
begin
  Result := 0;

  try
    with FMain_DM do
    begin
      stp_NewId.Close;
      stp_NewId.DatabaseName := idb_Ginkoia.DatabaseName;
      stp_NewId.ParamByName('TABLENAME').AsString := 'GENPARAM';
      stp_NewId.Prepared     := True;
      stp_NewId.ExecProc;

      Result := stp_NewId.FieldByName('ID').AsInteger;

      stp_NewId.Close;
      stp_NewId.Unprepare;
    end;
  except
    ShowMessage('Impossible d''executer GenID');
    Result := -1;
  end;
end;


procedure TFsmDossier.GetEditExtract(Val: Boolean);
begin
  //Procedure qui permettra de rendre éditable certains champ de la partie extraction
  if Val then
  begin
    Chp_CheminDeposeFic.Enabled    := True;
    Chp_IdExtraction.Enabled       := True;
    Dtp_LasDatetExtraction.Enabled := True;
    Nbt_DeposeFic.Enabled          := True;
  end else
  begin
    Chp_CheminDeposeFic.Enabled    := False;
    Chp_IdExtraction.Enabled       := False;
    Dtp_LasDatetExtraction.Enabled := False;
    Nbt_DeposeFic.Enabled          := False;
  end;
end;

//-------------------------------------------------------> DB_INSERT_Dossier

function TFsmDossier.DB_INSERT_Dossier(var vIdDossier : integer) : Boolean;
var
  DateCreate : TDAteTime;
begin
  Result := False;
  DateCreate := Now();
  vIdDossier := 0;

  try
    FMain_DM.Ibc_Maj_GoSport.IB_Transaction.StartTransaction();

    FMain_DM.Ibc_Maj_GoSport.SQL.Clear();
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' INSERT INTO DOSSIERS ');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' (DOS_NOM, DOS_PATH, DOS_IDGS, DOS_IDMAGASIN, DOS_COMENT ');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' ,DOS_ACTIVE, DOS_ENABLED, DOS_DTCREATE)');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' VALUES ');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' (:PDOSNOM, :PDOSPATH, :PDOSIDGS, :PDOSIDMAGASIN, :PDOSCOMENT ');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' ,:PDOSACTIVE, :PDOSENABLED, :PDOSDTCREATE) ');

    FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSNOM').AsString        := Trim(txt_Dossier.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSPATH').AsString       := Trim(txt_Chemin.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSIDGS').AsInteger      := StrToInt(txt_idGS.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSIDMAGASIN').AsInteger := 0;
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSCOMENT').AsString     := Trim(mmo_Commentaire.Lines.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSACTIVE').AsInteger    := rgr_Active.ItemIndex;
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSENABLED').AsInteger   := 1;
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSDTCREATE').AsDateTime := DateCreate;

    FMain_DM.Ibc_Maj_GoSport.ExecSQL();

    FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'select dos_id from dossiers where dos_nom = :pdosnom and dos_dtcreate = :pdosdtcreate;';
    FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
    FMain_DM.Ibc_Maj_GoSport.ParamByName('pdosnom').AsString := Trim(txt_Dossier.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('pdosdtcreate').AsDateTime := DateCreate;
    try
      FMain_DM.Ibc_Maj_GoSport.Open();
      if not FMain_DM.Ibc_Maj_GoSport.Eof then
        vIdDossier := FMain_DM.Ibc_Maj_GoSport.FieldByName('dos_id').AsInteger
      else
        Raise Exception.Create('');
    finally
      FMain_DM.Ibc_Maj_GoSport.Close();
    end;

    FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'insert into mag (mag_dosid, mag_idginkoia, mag_doimp, mag_doexp) values (:iddossier, :idginkoia, :doimp, :doexp);';
    FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;

    FMain_DM.cds_Magasin.First();
    while not FMain_DM.cds_Magasin.Eof do
    begin
      FMain_DM.Ibc_Maj_GoSport.ParamByName('iddossier').AsInteger := vIdDossier;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('idginkoia').AsInteger := FMain_DM.cds_Magasin.FieldByName('idmagasin').AsInteger;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('doimp').AsBoolean := FMain_DM.cds_Magasin.FieldByName('import').AsBoolean;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('doexp').AsBoolean := FMain_DM.cds_Magasin.FieldByName('export').AsBoolean;
      FMain_DM.Ibc_Maj_GoSport.ExecSQL();

      FMain_DM.cds_Magasin.Next();
    end;

    FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Commit();

    Result := True;
  except
    FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Rollback();
    ShowMessage('Erreur d''insertion');
  end;
end;

//-------------------------------------------------------> DB_UPDATE_Dossier

function TFsmDossier.DB_UPDATE_Dossier(var vIdDossier : integer) : Boolean;
begin
  Result := False;

  vIdDossier := FMain_DM.cds_DossierDOS_ID.AsInteger;

  try
    FMain_DM.Ibc_Maj_GoSport.IB_Transaction.StartTransaction();

    FMain_DM.Ibc_Maj_GoSport.SQL.Clear;
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' UPDATE DOSSIERS SET');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add('  DOS_NOM      = :PDOSNOM');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' ,DOS_PATH     = :PDOSPATH');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' ,DOS_IDGS     = :PDOSIDGS');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' ,DOS_ACTIVE   = :PDOSACTIVE');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' ,DOS_COMENT   = :PDOSCOMENT');
    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' ,DOS_DTUPDATE = :PDOSDTUPDATE');

    FMain_DM.Ibc_Maj_GoSport.SQL.Add(' WHERE DOS_ID = ' + IntToStr(vIdDossier));

    FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSNOM').AsString        := Trim(txt_Dossier.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSPATH').AsString       := Trim(txt_Chemin.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSIDGS').AsInteger      := StrToInt(txt_idGS.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSCOMENT').AsString     := Trim(mmo_Commentaire.Lines.Text);
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSACTIVE').AsInteger    := rgr_Active.ItemIndex;
    FMain_DM.Ibc_Maj_GoSport.ParamByName('PDOSDTUPDATE').AsDateTime := now;

    FMain_DM.Ibc_Maj_GoSport.ExecSQL;

    FMain_DM.Que_GoSport_ReUsable.SQL.Text := 'select * from mag where mag_dosid = ' + IntToStr(vIdDossier) + ';';
    try
      FMain_DM.Que_GoSport_ReUsable.Open();

      FMain_DM.cds_Magasin.First();
      while not FMain_DM.cds_Magasin.Eof do
      begin
        if FMain_DM.Que_GoSport_ReUsable.Locate('mag_idginkoia', FMain_DM.cds_Magasin.FieldByName('idmagasin').AsInteger, []) then
        begin
          FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'update mag set mag_doimp = :doimp, mag_doexp = :doexp where mag_dosid = :iddossier and mag_idginkoia = :idginkoia;';
          FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
        end
        else
        begin
          FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'insert into mag (mag_dosid, mag_idginkoia, mag_doimp, mag_doexp) values (:iddossier, :idginkoia, :doimp, :doexp);';
          FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
        end;
        FMain_DM.Ibc_Maj_GoSport.ParamByName('iddossier').AsInteger := vIdDossier;
        FMain_DM.Ibc_Maj_GoSport.ParamByName('idginkoia').AsInteger := FMain_DM.cds_Magasin.FieldByName('idmagasin').AsInteger;
        FMain_DM.Ibc_Maj_GoSport.ParamByName('doimp').AsBoolean := FMain_DM.cds_Magasin.FieldByName('import').AsBoolean;
        FMain_DM.Ibc_Maj_GoSport.ParamByName('doexp').AsBoolean := FMain_DM.cds_Magasin.FieldByName('export').AsBoolean;
        FMain_DM.Ibc_Maj_GoSport.ExecSQL();

        FMain_DM.cds_Magasin.Next();
      end;
    finally
      FMain_DM.Que_GoSport_ReUsable.Close();
    end;

    FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Commit;

    Result := True;
  except
    FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Rollback();
    ShowMessage('Erreur durant l''update');
  end;
end;

//------------------------------------------------------------------------------
//                                                        +--------------------+
//                                                        |   ENREGISTREMENT   |
//                                                        +--------------------+
//------------------------------------------------------------------------------

//-------------------------------------------> Enregistrer_TousLesParametres

function TFsmDossier.Enregistrer_TousLesParametres : Boolean;
var
  vMonId : Integer;
begin
  Result := False;
                                  // paramètre Domaine
  vMonId := StrToInt(vgStrlIdDomaine.Strings[cbo_Domaine.ItemIndex]);
  if not DB_UPDATE_Parametre(16, 1, vMonId) then
    Exit;
                                  // paramètre Axe
  vMonId := StrToInt(vgStrlIdAxe.Strings[cbo_Axe.ItemIndex]);
  if not DB_UPDATE_Parametre(16, 2, vMonId) then
    Exit;
                                  // paramètre TVA
  vMonId := StrToInt(vgStrlIdTVA.Strings[cbo_TVA.ItemIndex]);
  if not DB_UPDATE_Parametre(16, 3, vMonId) then
    Exit;
                                  // paramètre Garantie
  vMonId := StrToInt(vgStrlIdGarantie.Strings[cbo_Garantie.ItemIndex]);
  if not DB_UPDATE_Parametre(16, 4, vMonId) then
    Exit;
                                  // paramètre TypeComptable
  vMonId := StrToInt(vgStrlIdComptable.Strings[cbo_TypeComptable.ItemIndex]);
  if not DB_UPDATE_Parametre(16, 5, vMonId) then
    Exit;
                                  // paramètre Fournisseur
//  vMonId := StrToInt(vgStrlIdFournisseur.Strings[cbo_Fournisseur.ItemIndex]);
//  if not DB_UPDATE_Parametre(16, 9, vMonId) then
//    Exit;

  Result := Enregistrer_InfoMagasin;
end;

//-------------------------------------------------> Enregistrer_InfoMagasin

function TFsmDossier.Enregistrer_InfoMagasin : Boolean;
var
  vRecOk : Boolean;
begin
  Result := False;
  FMain_DM.cds_Magasin.First;

  while not FMain_DM.cds_Magasin.Eof do
  begin
    vRecOk := False;

    if DB_UPDATE_Magasin_Numero_User then
      if DB_UPDATE_Magasin_Type then
//CAF
        if DB_UPDATE_Magasin_Mode then
//
          vRecOk := True;

    // si enregistrement echoué, on sort
    if not vRecOk then
      Exit;

    FMain_DM.cds_Magasin.Next;
  end;

  Result := True;
end;

//------------------------------------------------------------------------------
//                                                         +-------------------+
//                                                         |   ACTION  TABLE   |
//                                                         +-------------------+
//------------------------------------------------------------------------------

//-----------------------------------------------------> DB_UPDATE_Parametre

function TFsmDossier.DB_UPDATE_Parametre(vpType, vpCode,
vpIdTable : Integer) : Boolean;
begin
  with FMain_DM.Ibc_Maj_Ginkoia do
  begin
    SQL.Clear;

    try
//JB
      IB_Transaction.StartTransaction();
//
      SQL.Add(' UPDATE GENPARAM SET');
      SQL.Add('  PRM_INTEGER = :PID');
      SQL.Add(' WHERE PRM_TYPE = :PPRMTYPE');
      SQL.Add(' AND   PRM_CODE = :PPRMCODE');

      ParamCheck := True;
      ParamByName('PID').AsInteger := vpIdTable;
      ParamByName('PPRMTYPE').AsInteger := vpType;
      ParamByName('PPRMCODE').AsInteger := vpCode;

      ExecSQL;

      IB_Transaction.Commit;

      Result := True;
    except
      Result := False;
      IB_Transaction.Rollback();
      ShowMessage('Erreur durant l''update');
    end;
  end;
end;

//-------------------------------------------> DB_UPDATE_Magasin_Numero_User

function TFsmDossier.DB_UPDATE_Magasin_Numero_User : Boolean;
begin
  with FMain_DM.Ibc_Maj_Ginkoia do
  begin
    SQL.Clear;

    try
//JB
      IB_Transaction.StartTransaction();
//
      SQL.Add(' UPDATE GENPARAM SET');
      SQL.Add('  PRM_STRING =  :PNUMERO');
      SQL.Add(' ,PRM_INTEGER = :PIdUSER');
      SQL.Add(' WHERE PRM_ID = :PPRMID');

      ParamCheck := True;
      ParamByName('PNUMERO').AsString  := FMain_DM.cds_MagasinNumero.AsString;
      ParamByName('PIdUSER').AsInteger := FMain_DM.cds_MagasinIdUtilisateur.AsInteger;
      ParamByName('PPRMID').AsInteger  := FMain_DM.cds_MagasinIdParametre6.AsInteger;

      ExecSQL;

      SQL.Clear;

      SQL.Add(' EXECUTE PROCEDURE PR_UPDATEK(:PID, 0)');

      ParamCheck := True;
      ParamByName('PID').AsInteger := FMain_DM.cds_MagasinIdParametre6.AsInteger;

      ExecSQL;

      IB_Transaction.Commit;

      Result := True;
    except
      Result := False;
      IB_Transaction.Rollback();
      ShowMessage('Erreur durant l''update');
    end;
  end;
end;

//--------------------------------------------------> DB_UPDATE_Magasin_Type

function TFsmDossier.DB_UPDATE_Magasin_Type : Boolean;
begin
  with FMain_DM.Ibc_Maj_Ginkoia do
  begin
    SQL.Clear;

    try
//JB
      IB_Transaction.StartTransaction();
//
      SQL.Add(' UPDATE GENPARAM SET');
      SQL.Add('  PRM_INTEGER = :PLETYPE');
      SQL.Add(' WHERE PRM_ID = :PPRMID');

      ParamCheck := True;
      ParamByName('PLETYPE').AsInteger := FMain_DM.cds_MagasinType.AsInteger;
      ParamByName('PPRMID').AsInteger  := FMain_DM.cds_MagasinIdParametre7.AsInteger;

      ExecSQL;

      SQL.Clear;

      SQL.Add(' EXECUTE PROCEDURE PR_UPDATEK(:PID, 0)');

      ParamCheck := True;
      ParamByName('PID').AsInteger := FMain_DM.cds_MagasinIdParametre7.AsInteger;

      ExecSQL;

      IB_Transaction.Commit;

      Result := True;
    except
      Result := False;
      IB_Transaction.Rollback();
      ShowMessage('Erreur durant l''update');
    end;
  end;
end;

//--------------------------------------------------> DB_UPDATE_Magasin_Mode
//CAF
function TFsmDossier.DB_UPDATE_Magasin_Mode : Boolean;
begin
  with FMain_DM.Ibc_Maj_Ginkoia do
  begin
    SQL.Clear;

    try
      IB_Transaction.StartTransaction();
      SQL.Add(' UPDATE GENPARAM SET');
      SQL.Add('  PRM_INTEGER = :PLETYPE');
      SQL.Add(' WHERE PRM_ID = :PPRMID');

      ParamCheck := True;
      ParamByName('PLETYPE').AsInteger := FMain_DM.cds_MagasinMode.AsInteger;
      ParamByName('PPRMID').AsInteger  := FMain_DM.cds_MagasinIdParametre8.AsInteger;

      ExecSQL;

      SQL.Clear;

      SQL.Add(' EXECUTE PROCEDURE PR_UPDATEK(:PID, 0)');

      ParamCheck := True;
      ParamByName('PID').AsInteger := FMain_DM.cds_MagasinIdParametre8.AsInteger;

      ExecSQL;

      IB_Transaction.Commit;

      Result := True;
    except
      Result := False;
      IB_Transaction.Rollback();
      ShowMessage('Erreur durant l''update');
    end;
  end;
end;
//

end.
