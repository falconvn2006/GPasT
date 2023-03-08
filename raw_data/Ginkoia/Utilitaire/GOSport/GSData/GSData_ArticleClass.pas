unit GSData_ArticleClass;

interface

uses GSData_MainClass, GSData_Types, GSDataImport_DM, Variants,
     GSData_TMarque, SysUtils, IBODataset, Db, GSData_TErreur, StrUtils, Math,
     Types, IdGlobalProtocols;

type
  TModele = record
    ART_ID,
    ARF_ID : Integer;
    Chrono : String;
    bCreer : Boolean;
  end;

  TModeArticle = (taStandard, taOther, taExit);

  TArticleClass = Class(TMainClass)
  private
    FMarque: TMainClass;
    FNomenclature: TMainClass;

    FArtArticle,
    FArtReference,
    FArtColArt ,
    FPLXTaillesGF,
    FArtRelartionArt,
    FPLXCouleur,
    FArtCodeBarre,
    FArtIdeal,
    FTarClgFourn,
    FTarPrixVente,
    FArtFournARTCODE,
    FArtfourn : TMainClass;
    DS_FArtArticle : TDataSource;

    FTVATable: TIboQuery;
    FCollectionTable: TIboQuery;

    FModeleFile, FArticlFile, FSfaFile : String;
    FMode : TModeArticle;
  public
    procedure import;override;
    function DoMajTable : Boolean;override;

    constructor Create;override;
    destructor Destroy;override;

    procedure CreateCdsField;

    // Création de la sous grille de taille
    function SetPLXGTF(AGTF_TGTID : Integer;AGTF_CODE, AGTF_NOM : String ; ACEN_CODE:Integer) : Integer;

    // Création du modèle
    function SetModele(AART_NOM : String; AART_MRKID : Integer;AART_REFMRK : String;
                       AART_GTFID, AART_GARID : Integer;AART_CODE : String; AART_ACTID : Integer;
                       AARF_TVAID, AARF_TCTID : Integer; AARF_UC, AARX_SSFID, AART_CENTRALE, AART_FDS, ANOUPDATE : Integer) : TModele;
    // Création de la relation entre la collection et le modèle
    function SetCollection(AART_ID, ACOL_ID : Integer) : Integer;

    // Création d'une taille (Si ATGF_ID = -1 Alors on est en création de la taille)
    function SetPlxTaillesGF(ACODE_ARTICLE : String; ATGF_GTFID : Integer;ATGF_NOM, ATGF_CODE : String; ACEN_CODE,ANoUpdate : Integer) : Integer;
    // création de la taille travaillé
    function SetPlxTailleTrav(AART_ID, ATGF_ID : Integer) : Integer;
    // Création des couleurs
    function SetPlxCouleur(ACODE_ARTICLE : String; ACOU_ARTID : Integer;ACOU_CODE, ACOU_NOM : String; ACEN_CODE: Integer ; ANoUpdate : Integer) : Integer;
    //  Création des codes à barres
    function SetArtCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID : Integer;ACBI_CB : String) : Integer;
    // Création d'un tarif d'achats
    function SetTARCLGFOURN(ACLG_FOUID, ACLG_ARTID, ACLG_TGFID, ACLG_COUID : Integer;ACLG_PX, ACLG_PXNEGO, ACLG_PXVI, ACLG_RA1, ACLG_RA2, ACLG_RA3, ACLG_TAXE : Currency; ACEN_CODE, AFOUPRINC, ANoUpdate : Integer) : Integer;
    // Création des stocks idéal d'un article
    function SetArtIdeal(ASTI_ARTID, ASTI_TGFID, ASTI_COUID, ASTI_MAGID : Integer;ASTI_QTE : Currency; ANoUpdate : Integer) : Integer;
    // Création de la relation article
    function SetARTRelationArt(AARA_CODEART : String; AARA_ARTID, AARA_TGFID, AARA_COUID : Integer) : Integer;
    // Création des tarifs de vente de l'article
    function SetTarPrixVente(APVT_TVTID, APVT_ARTID, APVT_TGFID, APVT_COUID : Integer; APVT_PX : Currency; APVT_CENTRALE : Integer) : Integer;
    // Création des fournisseurs
    function SetArtFourn(AFOU_CODE, AFOU_NOM : String; AFOU_TYPE, AFOU_GROS, AFOU_CENTRALE, AFOU_ACTIVE, AFOU_IDREF : Integer;
                         APAY_NOM, AVIL_NOM, AVIL_CP, AADR_LIGNE, AADR_TEL, AADR_FAX, AADR_EMAIL : String) : Integer;
    // Création de la liaison Marque/fournisseur
    function SetArtMrkfourn(AFOU_ID, AMRK_ID, ASETFMK_PRINC : Integer) : Integer;

  published
    property Marque          : TMainClass read FMarque          write FMarque;
    property Nomenclature    : TMainClass read FNomenclature    write FNomenclature;
    property TVATable        : TIboQuery  read FTVATable        write FTVATable;
    property CollectionTable : TIboQuery  read FCollectionTable write FCollectionTable;

    //Property MAG_ID : Integer read FMAGID write FMAGID; Défini dans la classe parent
    property Mode   : TModeArticle read FMode write FMode;

    // Accès au CDS
    property ArtArticle     : TMainClass read FArtArticle;
    property ArtReference   : TMainClass read FArtReference;
    property ArtColArt      : Tmainclass read FArtColArt;
    property PlxTailleGf    : TMainClass read FPLXTaillesGF;
    property ArtRelationArt : TMainClass read FArtRelartionArt;
    property PlxCouleur     : TMainClass read FPLXCouleur;
    property ArtCodeBarre   : TMainClass read FArtCodeBarre;
    property ArtIdeal       : TMainClass read FArtIdeal;
    property TarClgFourn    : TMainClass read FTarClgFourn;
    property TarPrixVente   : TMainClass read FTarPrixVente;
  End;

implementation

{ TArticleClass }

constructor TArticleClass.Create;
begin
  inherited Create;

  FMode := taStandard;

  FArtArticle    := TMainClass.Create;
  FArtReference  := TMainClass.Create;
  FArtColArt     := TMainClass.Create;
  DS_FArtArticle := TDataSource.Create(nil);
  DS_FArtArticle.DataSet := FArtArticle.ClientDataset;

  FPLXTaillesGF    := TMainClass.Create;
  FArtRelartionArt := TMainClass.Create;
  FPLXCouleur      := TMainClass.Create;
  FArtCodeBarre    := TMainClass.Create;
  FArtIdeal        := TMainClass.Create;
  FTarClgFourn     := TMainClass.Create;
  FTarPrixVente    := TMainClass.Create;
  FArtfourn        := TMainClass.Create;
  FArtFournARTCODE := TMainClass.Create;

  FModeleFile := '';
  FArticlFile := '';
  FSfaFile    := '';
end;

destructor TArticleClass.destroy;
begin
  FArtFournARTCODE.Free;
  FArtfourn.Free;
  FTarPrixVente.Free;
  FTarClgFourn.Free;
  FArtIdeal.Free;
  FArtCodeBarre.Free;
  FPLXCouleur.Free;
  DS_FArtArticle.Free;
  FPLXTaillesGF.Free;
  FArtRelartionArt.Free;
  FArtColArt.Free;
  FArtReference.Free;
  FArtArticle.Free;
  inherited;
end;


procedure TArticleClass.CreateCdsField;
var
  i : Integer;
  sPrefixe : String;
begin
  for i := Low(FilesPath) to High(FilesPath) do
  begin
    sPrefixe := Copy(FilesPath[i],1,6);
    case AnsiIndexStr(UpperCase(sPrefixe),['MODELE','ARTICL','MODSFA']) of
      0: FModeleFile := FilesPath[i];
      1: FArticlFile := FilesPath[i];
      2: FSfaFile    := FilesPath[i];
    end;
  end;

  // Table ARTARTICLE
  FArtArticle.CreateField(['ART_ID','ART_NOM','ART_MRKID','ART_REFMRK','ART_GTFID',
                           'ART_CODE', 'ART_CENTRALE', 'SSF_ID', 'ART_FDS', 'Error', 'Created', 'NOUPDATE'],
                          [ftInteger, ftString, ftInteger, ftString, ftInteger,
                           ftString, ftInteger, ftInteger, ftInteger, ftInteger, ftBoolean, ftInteger]);
  FArtArticle.ClientDataset.AddIndex('Idx','ART_CODE',[]);
  FArtArticle.ClientDataset.IndexName := 'Idx';

  // Table ARTREFERENCE
  FArtReference.CreateField(['ART_CODE','ARF_ID','ARF_TVAID','ARF_UC'],
                            [ftString,ftInteger,ftInteger,ftInteger]);
  FArtReference.ClientDataset.AddIndex('Idx','ART_CODE',[]);
  FArtReference.ClientDataset.IndexName := 'Idx';
  FArtReference.ClientDataset.MasterSource := DS_FArtArticle;
  FArtReference.ClientDataset.MasterFields := 'ART_CODE';

  // Table de liaison article/Collection
  FArtColArt.CreateField(['ART_CODE','CAR_COLID'],
                         [ftString,ftInteger]);
  FArtColArt.ClientDataset.AddIndex('Idx','ART_CODE',[]);
  FArtColArt.ClientDataset.IndexName := 'Idx';
  FArtColArt.ClientDataset.MasterSource := DS_FArtArticle;
  FArtColArt.ClientDataset.MasterFields := 'ART_CODE';

  // Table des tailles
  FPLXTaillesGF.CreateField(['TGF_ID','TGF_GTFID','TGF_NOM','TGF_CODE','CODE_ARTICLE','ART_CODE','TGF_CENTRALE'],
                            [ftInteger,ftInteger,ftString,ftString,ftString,ftString,ftInteger]);
  FPLXTaillesGF.ClientDataset.AddIndex('Idx','ART_CODE;CODE_ARTICLE',[]);
  FPLXTaillesGF.ClientDataset.IndexName := 'Idx';
  FPLXTaillesGF.ClientDataset.MasterSource := DS_FArtArticle;
  FPLXTaillesGF.ClientDataset.MasterFields := 'ART_CODE';

  // Table des codes articles GOSPORT
  FArtRelartionArt.CreateField(['ART_CODE','CODE_ARTICLE','ARA_ID','ARA_ARTID','ARA_TGFID','ARA_COUID'],
                               [ftString,ftString,ftInteger,ftInteger,ftInteger,ftInteger]);
  FArtRelartionArt.ClientDataset.AddIndex('Idx','ART_CODE;CODE_ARTICLE',[]);
  FArtRelartionArt.ClientDataset.IndexName := 'Idx';
  FArtRelartionArt.ClientDataset.MasterSource := DS_FArtArticle;
  FArtRelartionArt.ClientDataset.MasterFields := 'ART_CODE';

  // Couleur
  FPLXCouleur.CreateField(['ART_CODE','CODE_ARTICLE','COU_ID','COU_ARTID','COU_CODE','COU_NOM','COU_CENTRALE'],
                          [ftString, ftString,ftInteger,ftInteger,ftString,ftString,ftInteger]);
  FPLXCouleur.ClientDataset.AddIndex('Idx','ART_CODE;CODE_ARTICLE',[]);
  FPLXCouleur.ClientDataset.IndexName := 'Idx';
  FPLXCouleur.ClientDataset.MasterSource := DS_FArtArticle;
  FPLXCouleur.ClientDataset.MasterFields := 'ART_CODE';

  // Code à barres
  FArtCodeBarre.CreateField(['ART_CODE','CODE_ARTICLE','CBI_ID','CBI_TGFID','CBI_COUID','CBI_ARFID','CBI_CB'],
                            [ftString,ftString,ftInteger,ftInteger,ftInteger,ftInteger,ftString]);
  FArtCodeBarre.ClientDataset.AddIndex('Idx','ART_CODE;CODE_ARTICLE;CBI_CB',[]);
  FArtCodeBarre.ClientDataset.IndexName := 'Idx';
  FArtCodeBarre.ClientDataset.MasterSource := DS_FArtArticle;
  FArtCodeBarre.ClientDataset.MasterFields := 'ART_CODE';

  // Stock idéal
  FArtIdeal.CreateField(['ART_CODE','CODE_ARTICLE','STI_ARTID','STI_TGFID','STI_COUID','STI_MAGID','STI_QTE'],
                        [ftString, ftString,ftInteger,ftInteger,ftInteger,ftInteger,ftSingle]);
  FArtIdeal.ClientDataset.AddIndex('Idx','ART_CODE;CODE_ARTICLE',[]);
  FArtIdeal.ClientDataset.IndexName := 'Idx';
  FArtIdeal.ClientDataset.MasterSource := DS_FArtArticle;
  FArtIdeal.ClientDataset.MasterFields := 'ART_CODE';

  // tarif d'achat
  FTarClgFourn.CreateField(['ART_CODE','CODE_ARTICLE','CLG_ID', 'CLG_FOUID','CLG_ARTID', 'CLG_TGFID', 'CG_COUID', 'CLG_PX',
                            'CLG_PXNEGO','CLG_PXVI','CLG_RA1','CLG_RA2','CLG_RA3','CLG_TAXE','CLG_CENTRALE'],
                           [ftString,ftString,ftInteger,ftInteger,ftInteger,ftInteger,ftInteger,ftSingle,
                            ftSingle,ftSingle,ftSingle,ftSingle,ftSingle,ftSingle,ftInteger]);
  FTarClgFourn.ClientDataset.AddIndex('Idx','ART_CODE;CODE_ARTICLE',[]);
  FTarClgFourn.ClientDataset.IndexName := 'Idx';
  FTarClgFourn.ClientDataset.MasterSource := DS_FArtArticle;
  FTarClgFourn.ClientDataset.MasterFields := 'ART_CODE';

  // tarif de vente
  FTarPrixVente.CreateField(['ART_CODE','CODE_ARTICLE','PVT_ID','PVT_TVTID','PVT_ARTID','PVT_TGFID','PVT_COUID','PVT_PX'],
                            [ftString,ftString,ftInteger,ftInteger,ftInteger,ftInteger,ftInteger,ftSingle]);
  FTarPrixVente.ClientDataset.AddIndex('Idx','ART_CODE;CODE_ARTICLE',[]);
  FTarPrixVente.ClientDataset.IndexName := 'Idx';
  FTarPrixVente.ClientDataset.MasterSource := DS_FArtArticle;
  FTarPrixVente.ClientDataset.MasterFields := 'ART_CODE';

  // table de liaison entre un fournisseur et un article
  FArtFournARTCODE.CreateField(['ART_CODE', 'FOU_CODE', 'FOU_PRINC'],
                               [ftString, ftString, ftInteger]);
  FArtFournARTCODE.ClientDataset.AddIndex('Idx','ART_CODE',[]);
  FArtFournARTCODE.ClientDataset.IndexName := 'Idx';
  FArtFournARTCODE.ClientDataset.MasterSource := DS_FArtArticle;
  FArtFournARTCODE.ClientDataset.MasterFields := 'ART_CODE';

  // Table des fournisseurs
  FArtfourn.CreateField(['FOU_CODE', 'FOU_NOM', 'FOU_ID', 'FOU_TYPE', 'FOU_GROS', 'FOU_CENTRALE', 'FOU_ACTIVE','FOU_IDREF'],
                        [ftString, ftString, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger]);
  FArtfourn.ClientDataset.AddIndex('Idx','FOU_CODE',[]);
  FArtfourn.ClientDataset.IndexName := 'Idx';

end;

function TArticleClass.DoMajTable : Boolean;
var
  FOU_ID, GAR_ID, ACT_ID, TCT_ID, GTF_ID, TGT_ID, COL_ID, TGF_ID, COU_ID,
  TmpID : Integer;
  Modele : TModele;
  TmpMode : TModeArticle;
  Erreur : TErreur;
  iNoUpdate : integer ;
  iCentrale : integer ;
  iFirstFou : integer ;
begin
  Try
    // Initialisation

    // Récupération du fournisseur
    //  GetGenParam(16,9,FOU_ID);
    // Récupération de la garantie
    GetGenParam(16,4,GAR_ID,False);
    // Récupération du domaine
    GetGenParam(16,1,ACT_ID);
    // Récupération du type comptable
    GetGenParam(16,5,TCT_ID,False);
    // récupération du TGT_ID
    TGT_ID := GetIDFromTable('PLXTYPEGT','TGT_CODE','GTGSDATA','TGT_ID');

    {$REGION 'Traitement des fournisseurs'}
    With FArtfourn do
    begin
      First;
      while not EOF do
      begin
        if FieldByName('FOU_ID').AsInteger = 0 then
        begin
          try
            FIboQuery.IB_Transaction.StartTransaction;
            TmpID := SetArtFourn(
                                 FieldByName('FOU_CODE').AsString,      // AFOU_CODE,
                                 FieldByName('FOU_NOM').AsString,       // AFOU_NOM: String;
                                 FieldByName('FOU_TYPE').AsInteger,     // AFOU_TYPE,
                                 FieldByName('FOU_GROS').AsInteger,     // AFOU_GROS,
                                 FieldByName('FOU_CENTRALE').AsInteger, // AFOU_CENTRALE,
                                 1,                                     // AFOU_ACTIVE,
                                 1,                                     // AFOU_IDREF: Integer;
                                 '',                                    // APAY_NOM,
                                 '',                                    // AVIL_NOM,
                                 '',                                    // AVIL_CP,
                                 '',                                    // AADR_LIGNE,
                                 '',                                    // AADR_TEL,
                                 '',                                    // AADR_FAX,
                                 ''                                     // AADR_EMAIL: String
            );
            Edit;
            FieldByName('FOU_ID').AsInteger := TmpID;
            Post;
            FIboQuery.IB_Transaction.Commit;
          Except on E:Exception do
            begin
              FIboQuery.IB_Transaction.Rollback;
              Erreur := TErreur.Create;
              Erreur.AddError('','Intégration',Format('Fournisseur en erreur %s : %s',[FieldByName('FOU_CODE').AsString, E.Message]),0, teArticleInteg,0,'');
              GERREURS.Add(Erreur);
              IncError ;
            end;
          end;
        end;
        Next;
      end;
    end;
    {$ENDREGION}

    FArtArticle.First;
//    FArtArticle.ClientDataset.Filtered := False;
//    FArtArticle.ClientDataset.Filter := 'Error = 0';
//    FArtArticle.ClientDataset.Filtered := True;
    LabCaption('Création/Mise à jour des articles');
    while not FArtArticle.EOF do
    begin
      if FArtArticle.FieldByName('Error').AsInteger <> 0 then
      begin
        FArtArticle.Next;
        Continue;
      end;

      FIboQuery.IB_Transaction.StartTransaction;
      Try
        // Création/ Récupération de la grille de taille
        GTF_ID := SetPLXGTF(TGT_ID,FArtArticle.FieldByName('ART_CODE').AsString,FArtArticle.FieldByName('ART_CODE').AsString, FArtArticle.FieldByName('ART_CENTRALE').AsInteger) ;

        {$REGION 'Création du modèle'}
        Try
          Modele := SetModele(
                       FArtArticle.FieldByName('ART_NOM').AsString,      // AART_NOM: String;
                       FArtArticle.FieldByName('ART_MRKID').AsInteger,   // AART_MRKID: Integer;
                       FArtArticle.FieldByName('ART_REFMRK').AsString,   // AART_REFMRK: String;
                       GTF_ID,                                           // AART_GTFID,
                       GAR_ID,                                           // AART_GARID: Integer;
                       FArtArticle.FieldByName('ART_CODE').AsString,     // AART_CODE: String;
                       ACT_ID,                                           // AART_ACTID,
                       FArtReference.FieldByName('ARF_TVAID').AsInteger, // AARF_TVAID,
                       TCT_ID,                                           // AARF_TCTID: Integer;
                       FArtReference.FieldByName('ARF_UC').AsInteger,    // AARF_UC: String;
                       FArtArticle.FieldByName('SSF_ID').AsInteger,      // AARX_SSFID: Integer);
                       FArtArticle.FieldByName('ART_CENTRALE').AsInteger, // AART_CENTRALE,
                       FArtArticle.FieldByName('ART_FDS').AsInteger,       // AART_FDS : Integer
                       FArtArticle.FieldByName('NOUPDATE').AsInteger     // ANOUPDATE
                       );
          // Mise à jour des Cds
          FArtArticle.Edit;
          FArtArticle.FieldByName('ART_ID').AsInteger := Modele.ART_ID;
          FArtArticle.FieldByName('Created').AsBoolean := Modele.bCreer;
          FArtArticle.Post;

          FArtReference.Edit;
          FArtReference.FieldByName('ARF_ID').AsInteger := Modele.ARF_ID;
          FArtReference.Post;
        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s : %s',[FArtArticle.FieldByName('ART_CODE').AsString,E.Message]));
        End;
        {$ENDREGION}

        {$REGION 'Création relation MARQUE/Fournisseur'}
        if Modele.bCreer and (FArtFournARTCODE.ClientDataset.RecordCount = 0) then
          raise Exception.Create(Format('Modèle %s - Pas de fournisseur pour le modèle',[FArtArticle.FieldByName('ART_CODE').AsString]));
        Try
          FArtFournARTCODE.First;

          while not FArtFournARTCODE.EOF do
          begin
            if not FArtfourn.ClientDataset.Locate('FOU_CODE',FArtFournARTCODE.FieldByName('FOU_CODE').AsString,[loCaseInsensitive]) then
              raise Exception.Create(Format('Fournisseur non trouvé (%s-%s)',[FArtfourn.FieldByName('FOU_CODE').AsString,FArtfourn.FieldByName('FOU_NOM').AsString]));

            if FArtfourn.FieldByName('FOU_ID').AsInteger = 0 then
              raise Exception.Create(Format('ID Fournisseur à 0 (%s-%s)',[FArtfourn.FieldByName('FOU_CODE').AsString,FArtfourn.FieldByName('FOU_NOM').AsString]));

            case FmagType of
              mtCourir  : SetArtMrkfourn(FArtfourn.FieldByName('FOU_ID').AsInteger,FArtArticle.FieldByName('ART_MRKID').AsInteger, -1) ;
              mtGoSport : SetArtMrkfourn(FArtfourn.FieldByName('FOU_ID').AsInteger,FArtArticle.FieldByName('ART_MRKID').AsInteger, FArtFournARTCODE.FieldByName('FOU_PRINC').AsInteger) ;
            end;

            // TODO Requete de relation mrk/fourn

            FArtFournARTCODE.Next;
          end;
        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s - Fournisseur : %s',[FArtArticle.FieldByName('ART_CODE').AsString,E.Message]));
        End;
        {$ENDREGION}

        {$REGION 'Ajout des fournisseurs non présent du modèle'}
          // Sert pour mettre à jour tous les tarifs d'achats du modèle car on ne
          // sait pas s'il y aura tous les fournisseurs dans les ficheirs GOSPORT
          if not Modele.bCreer then
            With FIboQuery do
            begin
              Close;
              SQL.Clear;
              SQL.Add('SELECT FOU_ID, FOU_CODE, FOU_NOM, FOU_TYPE, CLG_PRINCIPAL from ARTFOURN');
              SQL.Add('  Join K on K_ID = FOU_ID and K_Enabled = 1');
              SQL.Add('  Join TARCLGFOURN on CLG_FOUID = FOU_ID');
              SQL.Add('  join K on K_ID = CLG_ID and K_Enabled = 1');
              SQL.Add('Where CLG_ARTID = :PARTID');
              SQL.Add('GROUP BY FOU_ID, FOU_CODE, FOU_NOM, FOU_TYPE, CLG_PRINCIPAL');
              ParamCheck := True;
              ParamByName('PARTID').AsInteger := Modele.ART_ID;
              Open;

              while not EOF do
              begin
                if not FArtfourn.ClientDataset.Locate('FOU_CODE',FieldByName('FOU_CODE').AsString,[loCaseInsensitive]) then
                begin
                  // Le fournisseur n'est pas présent dans la liste donc on l'ajoute
                  FArtFournARTCODE.Append;
                  FArtFournARTCODE.FieldByName('ART_CODE').AsString := FArtArticle.FieldByName('ART_CODE').AsString;
                  FArtFournARTCODE.FieldByName('FOU_CODE').AsString := FieldByName('FOU_CODE').AsString;
                  FArtFournARTCODE.FieldByName('FOU_PRINC').AsInteger := 0 ;
                  FArtFournARTCODE.Post;

                  FArtfourn.Append;
                  FArtfourn.FieldByName('FOU_CODE').AsString      := FieldByName('FOU_CODE').AsString;
                  FArtfourn.FieldByName('FOU_NOM').AsString       := FieldByName('FOU_NOM').AsString;
                  FArtfourn.FieldByName('FOU_ID').AsInteger       := FieldByName('FOU_ID').AsInteger;


                  FArtfourn.FieldByName('FOU_TYPE').AsInteger     := FieldByName('FOU_TYPE').AsInteger;

                  case FMagType of
                    mtCourir:   FArtfourn.FieldByName('FOU_CENTRALE').AsInteger := CTE_COURIR ;
                    mtGoSport:  FArtfourn.FieldByName('FOU_CENTRALE').AsInteger := CTE_GOSPORT ;
                  end;


                  FArtfourn.FieldByName('FOU_ACTIVE').AsInteger   := 1;
                  FArtfourn.FieldByName('FOU_IDREF').AsInteger    := 1;
                  FArtfourn.FieldByName('FOU_GROS').AsInteger     := 0;
                  FArtfourn.Post;
                end;
                Next;
              end;
            end;

        {$ENDREGION}

        {$REGION 'Gestion de la collection du modèle'}
        FArtColArt.First;
        while not FArtColArt.EOF do
        begin
          Try
            SetCollection(Modele.ART_ID,FArtColArt.FieldByName('CAR_COLID').AsInteger);
            FArtColArt.Next;
          Except on E:Exception do
            raise Exception.Create(Format('Modèle %s - Collection : %s',[FArtArticle.FieldByName('ART_CODE').AsString,E.Message]));
          End;
        end;
        {$ENDREGION}

        {$REGION 'Création des tailles du modèle'}
        if Modele.bCreer and (FPLXTaillesGF.ClientDataset.RecordCount = 0) then
          raise Exception.Create(Format('Modèle %s - Pas de taille pour le modèle',[FArtArticle.FieldByName('ART_CODE').AsString]));

        if (FPLXTaillesGF.ClientDataset.RecordCount > 1) and
           (FPLXTaillesGF.ClientDataset.Locate('TGF_CODE','UNIIND',[loCaseInsensitive])) then
        begin
          // Suppression de la taille unique s'il y a d'autres tailles pour le modèle.
          FPLXTaillesGF.ClientDataset.Delete;
        end;

        Try
          FPLXTaillesGF.First;
          while not FPLXTaillesGF.Eof do
          begin
            TGF_ID := SetPlxTaillesGF(FPLXTaillesGF.FieldByName('CODE_ARTICLE').AsString,
                                      GTF_ID,
                                      FPLXTaillesGF.FieldByName('TGF_NOM').AsString,
                                      FPLXTaillesGF.FieldByName('TGF_CODE').AsString,
                                      FPLXTaillesGF.FieldByName('TGF_CENTRALE').AsInteger,
                                      FArtArticle.FieldByName('NOUPDATE').AsInteger);

            // Taille travaillé
            SetPlxTailleTrav(Modele.ART_ID,TGF_ID);

            // Mise à jour des informations de tailles
            FPLXTaillesGF.Edit;
            FPLXTaillesGF.FieldByName('TGF_ID').AsInteger := TGF_ID;
            FPLXTaillesGF.FieldByName('TGF_GTFID').AsInteger := GTF_ID;
            FPLXTaillesGF.Post;

            // Mise à jour des informations de la table de relation article
            If FArtRelartionArt.ClientDataset.Locate('CODE_ARTICLE',FPLXTaillesGF.FieldByName('CODE_ARTICLE').AsString,[]) Then
            begin
              FArtRelartionArt.Edit;
              FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger := TGF_ID;
              FArtRelartionArt.Post;
            end;

            FPLXTaillesGF.Next;
          end;

          // si l'on a qu'une seule taille
          if FPLXTaillesGF.ClientDataset.RecordCount = 1 then
          begin
            // On met à jour l'ensemble des données du modèle
            FArtRelartionArt.ClientDataset.Filtered := False;
            FArtRelartionArt.ClientDataset.Filter := Format('ART_CODE = %s',[QuotedStr(FArtArticle.FieldByName('ART_CODE').AsString)]);
            FArtRelartionArt.ClientDataset.Filtered := True;
            try
              while not FArtRelartionArt.EOF do
              begin
                if FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger = 0 then
                begin
                  FArtRelartionArt.Edit;
                  FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger := TGF_ID; // Correcpond au code que l'on a traité plus tôt
                  FArtRelartionArt.Post;
                end;
                FArtRelartionArt.Next;
              end;
            finally
              FArtRelartionArt.ClientDataset.Filtered := False;
            end;
          end;
        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s - Taille %s : %s',[FArtArticle.FieldByName('ART_CODE').AsString,
                                                                      FPLXTaillesGF.FieldByName('TGF_CODE').AsString,
                                                                      E.Message]));
        End;
        {$ENDREGION}

        {$REGION 'Création des couleurs du modèle'}
        if Modele.bCreer and (FPLXCouleur.ClientDataset.RecordCount = 0) then
          raise Exception.Create(Format('Modèle %s - Pas de couleur pour le modèle',[FArtArticle.FieldByName('ART_CODE').AsString]));

        if (FPLXCouleur.ClientDataset.RecordCount > 1) and
           (FPLXCouleur.ClientDataset.Locate('COU_CODE','UNIIND',[loCaseInsensitive])) then
        begin
          // Suppression de la taille unique s'il y a d'autres tailles pour le modèle.
          FPLXCouleur.ClientDataset.Delete;
        end;

        Try
          FPLXCouleur.First;
          while not FPLXCouleur.EOF do
          begin
            COU_ID := SetPlxCouleur(FPLXCouleur.FieldByName('CODE_ARTICLE').AsString,
                                    Modele.ART_ID,
                                    FPLXCouleur.FieldByName('COU_CODE').AsString,
                                    FPLXCouleur.FieldByName('COU_NOM').AsString,
                                    FPLXCouleur.FieldByName('COU_CENTRALE').AsInteger,
                                    FArtArticle.FieldByName('NOUPDATE').AsInteger);

             FPLXCouleur.Edit;
             FPLXCouleur.FieldByName('COU_ID').AsInteger := COU_ID;
             FPLXCouleur.Post;

            // Mise à jour des informations de la table de relation article
            If FArtRelartionArt.ClientDataset.Locate('CODE_ARTICLE',FPLXCouleur.FieldByName('CODE_ARTICLE').AsString,[]) Then
            begin
              FArtRelartionArt.Edit;
              FArtRelartionArt.FieldByName('ARA_COUID').AsInteger := COU_ID;
              FArtRelartionArt.Post;
            end;

            FPLXCouleur.Next;
          end;

          // si l'on a qu'une seule couleur
          if FPLXCouleur.ClientDataset.RecordCount = 1 then
          begin
            // On met à jour l'ensemble des données du modèle
            FArtRelartionArt.ClientDataset.Filtered := False;
            FArtRelartionArt.ClientDataset.Filter := Format('ART_CODE = %s',[QuotedStr(FArtArticle.FieldByName('ART_CODE').AsString)]);
            FArtRelartionArt.ClientDataset.Filtered := True;
            FArtRelartionArt.First;
            try
              while not FArtRelartionArt.EOF do
              begin
                if FArtRelartionArt.FieldByName('ARA_COUID').AsInteger = 0 then
                begin
                  FArtRelartionArt.Edit;
                  FArtRelartionArt.FieldByName('ARA_COUID').AsInteger := COU_ID; // Correspond au code que l'on a traité plus tôt
                  FArtRelartionArt.Post;
                end;
                FArtRelartionArt.Next;
              end;
            finally
              FArtRelartionArt.ClientDataset.Filtered := False;
            end;
          end;
        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s - Couleur %s : %s',[FArtArticle.FieldByName('ART_CODE').AsString,
                                                                      FPLXCouleur.FieldByName('COU_CODE').AsString,
                                                                      E.Message]));
        End;
        {$ENDREGION}

        {$REGION 'Gestion des Codes à barres'}
        Try
          FArtCodeBarre.First;
          while not FArtCodeBarre.EOF do
          begin
            // Positionnement sur la relation article
            If FArtRelartionArt.ClientDataset.Locate('CODE_ARTICLE',FArtCodeBarre.FieldByName('CODE_ARTICLE').AsString,[]) Then
            begin
              SetArtCodeBarre(Modele.ARF_ID,
                              FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger,
                              FArtRelartionArt.FieldByName('ARA_COUID').AsInteger,
                              FArtCodeBarre.FieldByName('CBI_CB').AsString);

              FArtCodeBarre.Edit;
              FArtCodeBarre.FieldByName('CBI_ARFID').AsInteger := Modele.ARF_ID;
              FArtCodeBarre.FieldByName('CBI_TGFID').AsInteger := FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger;
              FArtCodeBarre.FieldByName('CBI_COUID').AsInteger :=  FArtRelartionArt.FieldByName('ARA_COUID').AsInteger;
              FArtCodeBarre.Post;
            end
            else begin
              // Erreur code_article non trouvé (ne devrait jamais se produire)
            end;
            FArtCodeBarre.Next;
          end;
        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s - CB %s : %s',[FArtArticle.FieldByName('ART_CODE').AsString,
                                                                      FArtCodeBarre.FieldByName('CBI_CB').AsString,
                                                                      E.Message]));
        End;
        {$ENDREGION}

        {$REGION 'Gestion des tarifs d''achats'}
        if Modele.bCreer and (FArtFournARTCODE.ClientDataset.RecordCount = 0) then
          raise Exception.Create(Format('Modèle %s - Pas de fournisseur pour le modèle',[FArtArticle.FieldByName('ART_CODE').AsString]));
        Try
          FArtFournARTCODE.First;
          while not FArtFournARTCODE.EOF do
          begin
            if not FArtfourn.ClientDataset.Locate('FOU_CODE',FArtFournARTCODE.FieldByName('FOU_CODE').AsString,[loCaseInsensitive]) then
              raise Exception.Create(Format('Fournisseur non trouvé (%s-%s)',[FArtfourn.FieldByName('FOU_CODE').AsString,FArtfourn.FieldByName('FOU_NOM').AsString]));

            if FArtfourn.FieldByName('FOU_ID').AsInteger = 0 then
              raise Exception.Create(Format('ID Fournisseur à 0 (%s-%s)',[FArtfourn.FieldByName('FOU_CODE').AsString,FArtfourn.FieldByName('FOU_NOM').AsString]));

            FTarClgFourn.First;
            while not FTarClgFourn.EOF do
            begin
              case FMagType of
                  mtCourir :  iNoUpdate := FArtArticle.FieldByName('NOUPDATE').AsInteger ;
                  mtGoSport : iNoUpdate := 1 ;
              end;

              If not FArtRelartionArt.ClientDataset.Locate('CODE_ARTICLE',FTarClgFourn.FieldByName('CODE_ARTICLE').AsString,[]) Then
              begin
                // Création du tarif de base
                SetTARCLGFOURN(
                               FArtfourn.FieldByName('FOU_ID').AsInteger,           // ACLG_FOUID
                               Modele.ART_ID,                                       // ACLG_ARTID,
                               0, // ACLG_TGFID
                               0, // ACLG_COUID
                               FTarClgFourn.FieldByName('CLG_PX').AsCurrency,         // ACLG_PX
                               FTarClgFourn.FieldByName('CLG_PXNEGO').AsCurrency,     // ACLG_PXNEGO
                               FTarClgFourn.FieldByName('CLG_PXVI').AsCurrency,       // ACLG_PXVI
                               FTarClgFourn.FieldByName('CLG_RA1').AsCurrency,        // ACLG_RA1
                               FTarClgFourn.FieldByName('CLG_RA2').AsCurrency,        // ACLG_RA2
                               FTarClgFourn.FieldByName('CLG_RA3').AsCurrency,        // ACLG_RA3
                               FTarClgFourn.FieldByName('CLG_TAXE').AsCurrency,       // ACLG_TAXE
                               FTarClgFourn.FieldByName('CLG_CENTRALE').AsInteger,    // ACEN_CODE
                               FArtFournARTCODE.FieldByName('FOU_PRINC').AsInteger,   // ASETFOUPRINC
                               iNoUpdate                                              // ANOUPDATE
                              );

              end
              else begin
                SetTARCLGFOURN(
                               FArtfourn.FieldByName('FOU_ID').AsInteger,           // ACLG_FOUID
                               Modele.ART_ID,                                       // ACLG_ARTID,
                               FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger, // ACLG_TGFID
                               FArtRelartionArt.FieldByName('ARA_COUID').AsInteger, // ACLG_COUID
                               FTarClgFourn.FieldByName('CLG_PX').AsCurrency,         // ACLG_PX
                               FTarClgFourn.FieldByName('CLG_PXNEGO').AsCurrency,     // ACLG_PXNEGO
                               FTarClgFourn.FieldByName('CLG_PXVI').AsCurrency,       // ACLG_PXVI
                               FTarClgFourn.FieldByName('CLG_RA1').AsCurrency,        // ACLG_RA1
                               FTarClgFourn.FieldByName('CLG_RA2').AsCurrency,        // ACLG_RA2
                               FTarClgFourn.FieldByName('CLG_RA3').AsCurrency,        // ACLG_RA3
                               FTarClgFourn.FieldByName('CLG_TAXE').AsCurrency,       // ACLG_TAXE
                               FTarClgFourn.FieldByName('CLG_CENTRALE').AsInteger,    // ACEN_CODE
                               FArtFournARTCODE.FieldByName('FOU_PRINC').AsInteger,   // ASETFOUPRINC
                               iNoUpdate                                              // ANOUPDATE
                              );
              end;

              FTarClgFourn.Next;
            end;

            FArtFournARTCODE.Next;
          end;

        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s - Tarif Achat : %s',[FArtArticle.FieldByName('ART_CODE').AsString,
                                                                      E.Message]));
        End;
        {$ENDREGION}

        {$REGION 'Gestion des tarifs de vente'}

        if Modele.bCreer then
        Try
          case FMagType of
            mtCourir:   iCentrale := CTE_COURIR ;
            mtGoSport:  iCentrale := CTE_GOSPORT ;
          end;

          // Création du tarifs de base
          case FMode of
            taStandard:
               SetTarPrixVente(
                                0,             // APVT_TVTID,
                                Modele.ART_ID, // APVT_ARTID,
                                0,             // APVT_TGFID,
                                0,             // APVT_COUID : Integer;
                                0,             // APVT_PX : Single
                                iCentrale      // APVT_CENTRALE : Integer;
                              );
            taOther: begin
              FTarPrixVente.First;
              while not FTarPrixVente.EOF do
              begin
                SetTarPrixVente(
                                FTarPrixVente.FieldByName('PVT_TVTID').AsInteger, // APVT_TVTID,
                                Modele.ART_ID,                                    // APVT_ARTID,
                                FTarPrixVente.FieldByName('PVT_TGFID').AsInteger, // APVT_TGFID,
                                FTarPrixVente.FieldByName('PVT_COUID').AsInteger, // APVT_COUID : Integer;
                                FTarPrixVente.FieldByName('PVT_PX').AsInteger,    // APVT_PX : Single
                                iCentrale                                         // APVT_CENTRALE : Integer
                               );

                FTarPrixVente.Next;
              end; // while
            end;
          end; // case
        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s - Tarif Vente : %s',[FArtArticle.FieldByName('ART_CODE').AsString,
                                                                      E.Message]));
        End;

        {$ENDREGION}

        {$REGION 'Gestion du stock mini'}
        Try
          FArtIdeal.First;
          while not FArtIdeal.EOF do
          begin
            // Positionnement sur la relation article
            If FArtRelartionArt.ClientDataset.Locate('CODE_ARTICLE',FArtIdeal.FieldByName('CODE_ARTICLE').AsString,[]) Then
            begin
              if FArtIdeal.FieldByName('STI_QTE').AsCurrency <> 0 then
                SetArtIdeal(
                             Modele.ART_ID,
                             FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger,
                             FArtRelartionArt.FieldByName('ARA_COUID').AsInteger,
                             FMAGID,
                             FArtIdeal.FieldByName('STI_QTE').AsCurrency,
                             FArtArticle.FieldByName('NOUPDATE').AsInteger
                           );
            end
            else begin
              // Erreur code_article non trouvé (ne devrait jamais se produire)
            end;

            FArtIdeal.Next;
          end;
        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s - StockMini : %s',[FArtArticle.FieldByName('ART_CODE').AsString,
                                                                      E.Message]));
        End;
        {$ENDREGION}

        {$REGION 'Gestion des informations de relation article'}
        Try
          FArtRelartionArt.First;
          while not FArtRelartionArt.EOF do
          begin
            if FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger = 0 then
              raise Exception.Create('Taille 0 incorrecte');

            if FArtRelartionArt.FieldByName('ARA_COUID').AsInteger = 0 then
              raise Exception.Create('Couleur 0 incorrecte');

            SetARTRelationArt(
                              FArtRelartionArt.FieldByName('CODE_ARTICLE').AsString,
                              Modele.ART_ID,
                              FArtRelartionArt.FieldByName('ARA_TGFID').AsInteger,
                              FArtRelartionArt.FieldByName('ARA_COUID').AsInteger
                             );
            FArtRelartionArt.Edit;
            FArtRelartionArt.FieldByName('ARA_ARTID').AsInteger := Modele.ART_ID;
            FArtRelartionArt.Post;
            FArtRelartionArt.Next;
          end;
        Except on E:Exception do
          raise Exception.Create(Format('Modèle %s - CODE ARTICLE %s : %s',[FArtArticle.FieldByName('ART_CODE').AsString,
                                                                            FArtRelartionArt.FieldByName('CODE_ARTICLE').AsString,
                                                                            E.Message]));
        End;
        {$ENDREGION}

        FIboQuery.IB_Transaction.Commit;
      Except on E:Exception do
        begin
          FArtArticle.Edit;
          FArtArticle.FieldByName('Error').AsInteger := 1;
          FArtArticle.Post;

          FIboQuery.IB_Transaction.Rollback;
          Erreur := TErreur.Create;
          Erreur.AddError('','Intégration',E.Message,0, teArticleInteg,0,'');
          GERREURS.Add(Erreur);
          IncError ;
        end;
      End;

      FArtArticle.Next;
      BarPosition(FArtArticle.ClientDataset.RecNo * 100 Div FArtArticle.ClientDataset.RecordCount);
    end;

    {$REGION 'Création des CB Type 1 Manquant'}
    LabCaption('Mise à jour des CB de type 1');
    With FIboQuery do
    begin
      IB_Transaction.StartTransaction;
      try
        Close;
        SQL.Clear;
        SQL.Add('EXECUTE PROCEDURE GOS_SETARTCODEBARRE_TYPE1');
        ExecSQL;
        IB_Transaction.Commit;
      except on E:Exception do
        begin
          IB_Transaction.Rollback;
          raise Exception.Create('SETARTCODEBARRE_TYPE1 -> ' + E.Message);
        end;
      end;
    end;
    {$ENDREGION}
  Except on E:Exception do
    begin
      FArtArticle.Edit;
      FArtArticle.FieldByName('Error').AsInteger := 1;
      FArtArticle.Post;
      IncError ;

      raise Exception.Create('TArticleClass -> ' + E.Message);
    end;
  End;

  FArtArticle.ClientDataset.Filtered := False;

end;


function TArticleClass.SetArtCodeBarre(ACBI_ARFID, ACBI_TGFID,
  ACBI_COUID: Integer; ACBI_CB: String): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETARTCODEBARRE(:PARFID, :PTGFID, :PCOUID, :PCBICB)');
    ParamCheck := True;
    ParamByName('PARFID').AsInteger := ACBI_ARFID;
    ParamByName('PTGFID').AsInteger := ACBI_TGFID;
    ParamByName('PCOUID').AsInteger := ACBI_COUID;
    ParamByName('PCBICB').AsString  := ACBI_CB;
    Open;

    if recordCount > 0 then
    begin
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajcount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('CBI_ID').AsInteger;
    end;

  Except on E:Exception do
    raise Exception.Create('SetArtCodeBarre -> ' + E.Message);
  end;
end;

function TArticleClass.SetArtFourn(AFOU_CODE, AFOU_NOM: String; AFOU_TYPE,
  AFOU_GROS, AFOU_CENTRALE, AFOU_ACTIVE, AFOU_IDREF: Integer; APAY_NOM,
  AVIL_NOM, AVIL_CP, AADR_LIGNE, AADR_TEL, AADR_FAX,
  AADR_EMAIL: String): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SetArtFourn(:PFOUCODE, :PFOUNOM, :PFOUTYPE, :PFOUGROS,');
    SQL.Add(' :PFOUCENTRALE, :PFOUACTIVE, :PFOUIDREF, :PPAYNOM, :PVILNOM, :PVILCP,');
    SQL.add(' :PADRLIGNE, :PADRTEL, :PADRFAX, :PADREMAIL)');
    ParamCheck := True;
    ParamByName('PFOUCODE').AsString      := AFOU_CODE;
    ParamByName('PFOUNOM').AsString       := AFOU_NOM;
    ParamByName('PFOUTYPE').AsInteger     := AFOU_TYPE;
    ParamByName('PFOUGROS').AsInteger     := AFOU_GROS;
    ParamByName('PFOUCENTRALE').AsInteger := AFOU_CENTRALE;
    ParamByName('PFOUACTIVE').AsInteger   := AFOU_ACTIVE;
    ParamByName('PFOUIDREF').AsInteger    := AFOU_IDREF;
    ParamByName('PPAYNOM').AsString       := APAY_NOM;
    ParamByName('PVILNOM').AsString       := AVIL_NOM;
    ParamByName('PVILCP').AsString        := AVIL_CP;
    ParamByName('PADRLIGNE').AsString     :=AADR_LIGNE;
    ParamByName('PADRTEL').AsString       := AADR_TEL;
    ParamByName('PADRFAX').AsString       := AADR_FAX;
    ParamByName('PADREMAIL').AsString     := AADR_EMAIL;
    Open;

    Result := FieldByName('FOU_ID').AsInteger;
    Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    Inc(FMajCount,FieldByName('FMAJ').AsInteger);
  Except on E:eXception do
    raise Exception.Create('SetArtFourn -> ' + E.Message);
  end;
end;

function TArticleClass.SetArtIdeal(ASTI_ARTID, ASTI_TGFID, ASTI_COUID,
  ASTI_MAGID: Integer; ASTI_QTE: Currency; ANoUpdate : Integer): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETARTIDEAL(:PARTID, :PTGFID, :PCOUID, :PMAGID, :PSTIQTE, :PNOUPDATE)');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := ASTI_ARTID;
    ParamByName('PTGFID').AsInteger := ASTI_TGFID;
    ParamByName('PCOUID').AsInteger := ASTI_COUID;
    ParamByName('PMAGID').AsInteger := ASTI_MAGID;
    ParamByName('PSTIQTE').AsCurrency := ASTI_QTE;
    ParamByName('PNOUPDATE').AsInteger := ANoUpdate;
    Open;

    If Recordcount > 0 then
    begin
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('STI_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('SetArtIdeal -> ' + E.Message);
  end;
end;

function TArticleClass.SetArtMrkfourn(AFOU_ID, AMRK_ID, ASETFMK_PRINC : Integer): Integer;
begin
  Result := -1;
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    if FBaseVersion = 1
      then SQL.Add('Select * from  GOS_SETARTMRKFOURN(:PFOUID, :PMRKID)');
    if FBaseVersion = 2
      then SQL.Add('Select * from  GOS_SETARTMRKFOURN(:PFOUID, :PMRKID, :PSETFMKPRINC)');
    ParamCheck := True;
    ParamByName('PFOUID').AsInteger := AFOU_ID;
    ParamByName('PMRKID').AsInteger := AMRK_ID;
    if FBaseVersion = 2
      then ParamByName('PSETFMKPRINC').AsInteger := ASETFMK_PRINC;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('FMK_ID').AsInteger;
  Except on E:Exception do
    raise Exception.Create('SetArtMrkfourn -> ' + E.Message);
  end;

end;

function TArticleClass.SetARTRelationArt(AARA_CODEART: String; AARA_ARTID,
  AARA_TGFID, AARA_COUID: Integer): Integer;
var
  sMajBin, sMessage : String;
  i : Integer;
begin
  With FIboQuery Do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETARTRELATIONART(:PCODEART, :PARTID, :PTGFID, :PCOUID)');
    ParamCheck := True;
    ParamByName('PCODEART').AsString := AARA_CODEART;
    ParamByName('PARTID').AsInteger  := AARA_ARTID;
    ParamByName('PTGFID').AsInteger  := AARA_TGFID;
    ParamByName('PCOUID').AsInteger  := AARA_COUID;
    Open;
    
    if RecordCount > 0 then
    begin
      Result := FieldByName('ARA_ID').AsInteger;
      Inc(FInsertcount,FieldbyName('FAJOUT').AsInteger);
      //Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      if FieldByName('FMAJ').AsInteger > 0 then
      begin
        // IntToBin retourne la valeur binaire de FMaj sur 32 bits
        sMajBin := Trim(inttobin(FieldByName('FMAJ').AsInteger));
        // Analyse des 3 derniers bits de la valeur pour connaitre les valeurs qui ont changées
        // dans la base de données Ex: 6 = 0000...110 indique que le modèle (bit 32 à 0) n'a pas
        // changé mais que la taille (Bit 31 à 1) et la couleur (Bit 30 à 1) ont été modifiées.
        sMessage := '';
        for i := 32 Downto 30 do
          if sMajBin[i] = '1' then
            case i of
              32: sMessage := sMessage + #13#10'- Modèle différent';
              31: sMessage := sMessage + #13#10'- Taille différente';
              30: sMessage := sMessage + #13#10'- Couleur différente';
            end;
        if Trim(sMessage) <> '' then
          raise Exception.Create(Format('Erreur lors de l''intrégration du Code article %s : %s',[AARA_CODEART, sMessage]));
      end;                                                                             
    end;

  Except on E:Exception do
    raise Exception.Create('SetARTRelationArt -> ' + E.Message);
  end;
end;

function TArticleClass.SetCollection(AART_ID, ACOL_ID: Integer): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETCOLLECTION(:PARTID, :PCOLID)');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AART_ID;
    ParamByName('PCOLID').AsInteger := ACOL_ID;
    Open;

    if RecordCount > 0 then
    begin
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Result := FieldByName('CAR_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('SetCollection -> ' + E.Message);
  end;
end;

function TArticleClass.SetModele(AART_NOM: String; AART_MRKID: Integer;
  AART_REFMRK: String; AART_GTFID, AART_GARID: Integer; AART_CODE: String;
  AART_ACTID, AARF_TVAID, AARF_TCTID: Integer; AARF_UC, AARX_SSFID, AART_CENTRALE, AART_FDS, ANOUPDATE : Integer): TModele;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETMODELE(:PARTNOM, :PARTMRKID, :PARTREFMRK, :PARTGTFID, :PARTGARID, :PARTCODE,');
    SQL.Add(':PARTACTID, :PARFTVAID, :PARFTCTID,:PARFUC, :PARXSSFID, :PARTCENTRALE, :PARTFDS, :PNOUPDATE)');
    ParamCheck := True;
    ParamByName('PARTNOM').AsString       := AART_NOM;
    ParamByName('PARTMRKID').AsInteger    := AART_MRKID;
    ParamByName('PARTREFMRK').AsString    := AART_REFMRK;
    ParamByName('PARTGTFID').AsInteger    := AART_GTFID;
    ParamByName('PARTGARID').AsInteger    := AART_GARID;
    ParamByName('PARTCODE').AsString      := AART_CODE;
    ParamByName('PARTACTID').AsInteger    := AART_ACTID;
    ParamByName('PARFTVAID').AsInteger    := AARF_TVAID;
    ParamByName('PARFTCTID').AsInteger    := AARF_TCTID;
    ParamByName('PARFUC').AsInteger       := AARF_UC;
    ParamByName('PARXSSFID').AsInteger    := AARX_SSFID;
    ParamByName('PARTCENTRALE').AsInteger := AART_CENTRALE;
    ParamByName('PARTFDS').AsInteger      := AART_FDS;
    ParamByName('PNOUPDATE').AsInteger     := ANOUPDATE;
    Open;

    if Recordcount > 0 then
    begin
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajcount,FieldByName('FMAJ').AsInteger);
      Result.ART_ID := FieldByName('ART_ID').AsInteger;
      Result.ARF_ID := FieldByName('ARF_ID').AsInteger;
      Result.bCreer := (FieldByName('FAJOUT').AsInteger > 0);
      Result.Chrono := FieldByName('ARF_CHRONO').AsString;
    end;
  Except on E:Exception do
    raise Exception.Create('SetModele -> ' + E.Message);
  end;
end;

function TArticleClass.SetPlxCouleur(ACODE_ARTICLE: String; ACOU_ARTID: Integer;
  ACOU_CODE, ACOU_NOM: String; ACEN_CODE : Integer ; ANoUpdate : Integer): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    if FBaseVersion = 1
      then SQL.Add('Select * from GOS_SETPLXCOULEUR(:PCODEARTICLE, :PARTID, :PCOUCODE, :PCOUNOM, :PNOUPDATE)');
    if FBaseVersion = 2
      then SQL.Add('Select * from GOS_SETPLXCOULEUR(:PCODEARTICLE, :PARTID, :PCOUCODE, :PCOUNOM, :CENCODE, :PNOUPDATE)');
    ParamCheck := true;
    ParamByName('PCODEARTICLE').AsString := ACODE_ARTICLE;
    ParamByName('PARTID').AsInteger      := ACOU_ARTID;
    ParamByName('PCOUCODE').AsString     := ACOU_CODE;
    ParamByName('PCOUNOM').AsString      := ACOU_NOM;
    if FBaseVersion = 2
      then ParamByName('CENCODE').AsInteger     := ACEN_CODE;
    ParamByName('PNOUPDATE').AsInteger   := ANoUpdate;
    Open;

    if RecordCount > 0 then
    begin
      Inc(FInsertcount,FieldbyName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('COU_ID').AsInteger;
    end;

  Except on E:Exception do
    raise Exception.Create('SetPlxCouleur -> ' + E.Message);
  end;
end;

function TArticleClass.SetPLXGTF(AGTF_TGTID: Integer;
  AGTF_CODE, AGTF_NOM : String ; ACEN_CODE:Integer): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    if FBaseVersion = 1
      then SQL.Add('Select * from GOS_SETPLXGTF(:PGTFTGTID,:PGTFCODE,:PGTFNOM)');
    if FBaseVersion = 2
      then SQL.Add('Select * from GOS_SETPLXGTF(:PGTFTGTID,:PGTFCODE,:PGTFNOM,:CENCODE)');
    ParamCheck := True;
    ParamByName('PGTFTGTID').AsInteger := AGTF_TGTID;
    ParamByName('PGTFCODE').AsString   := AGTF_CODE;
    ParamByName('PGTFNOM').AsString    := AGTF_NOM;
    if FBaseVersion = 2
      then ParamByName('CENCODE').AsInteger   := ACEN_CODE;
    Open;

    if Recordcount > 0 then
    begin
      Inc(FInsertcount,FieldbyName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('GTF_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('GetPLXGTF -> ' + E.Message);
  end;
end;

function TArticleClass.SetPlxTaillesGF(ACODE_ARTICLE : String; ATGF_GTFID: Integer; ATGF_NOM,
  ATGF_CODE: String; ACEN_CODE, ANoUpdate : Integer): Integer;
begin
  With FIboQuery do
   try
     Close;
     SQL.Clear;
     if FBaseVersion = 1
        then SQL.Add('Select * from GOS_SETPLXTAILLESGF(:PCODEARTICLE, :PGTFID,:PTGFNOM, :PTGFCODE, :PNOUPDATE)');
     if FBaseVersion = 2
        then SQL.Add('Select * from GOS_SETPLXTAILLESGF(:PCODEARTICLE, :PGTFID,:PTGFNOM, :PTGFCODE, :CENCODE, :PNOUPDATE)');
     ParamCheck := True;
     ParamByName('PCODEARTICLE').AsString := ACODE_ARTICLE;
     ParamByName('PGTFID').AsInteger      := ATGF_GTFID;
     ParamByName('PTGFNOM').AsString      := ATGF_NOM;
     ParamByName('PTGFCODE').AsString     := ATGF_CODE;
     if FBaseVersion = 2
        then ParamByName('CENCODE').AsInteger   := ACEN_CODE ;
     ParamByName('PNOUPDATE').AsInteger   := ANoUpdate;
     Open;

     if RecordCount > 0 then
     begin
       Inc(FInsertCount,FieldbyName('FAJOUT').AsInteger);
       Result := FieldByName('TGF_ID').AsInteger;
     end;
   Except on E:Exception do
     raise Exception.Create('SetPlxTaillesGF -> ' + E.Message);
   end;
end;

function TArticleClass.SetPlxTailleTrav(AART_ID, ATGF_ID: Integer): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETPLXTAILLTRAV(:PARTID,:PTGFID)');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AART_ID;
    ParamByName('PTGFID').AsInteger := ATGF_ID;
    Open;

    if recordCount > 0 then
    begin
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Result := FieldByName('TTV_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('SetPlxTailleTrav -> ' + E.Message);
  End;
end;

function TArticleClass.SetTARCLGFOURN(ACLG_FOUID, ACLG_ARTID, ACLG_TGFID,
  ACLG_COUID: Integer; ACLG_PX, ACLG_PXNEGO, ACLG_PXVI, ACLG_RA1, ACLG_RA2,
  ACLG_RA3, ACLG_TAXE : Currency; ACEN_CODE, AFOUPRINC, ANoUpdate : Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETTARCLGFOURN(:PFOUID, :PARTID, :PTGFID, :PCOUID,');
    if FBaseVersion = 1
      then SQL.Add(':PCLGPX, :PCLGPNEGO, :PCLGPXVI, :PCLGRA1, :PCLGRA2,:PCLGRA3, :PCLGTAXE, :PNOUPDATE)');
    if FBaseVersion = 2
      then SQL.Add(':PCLGPX, :PCLGPNEGO, :PCLGPXVI, :PCLGRA1, :PCLGRA2,:PCLGRA3, :PCLGTAXE, :CENCODE, :SETFOUPRINC, :PNOUPDATE)');
    ParamCheck := True;
    ParamByName('PFOUID').AsInteger   := ACLG_FOUID;
    ParamByName('PARTID').AsInteger   := ACLG_ARTID;
    ParamByName('PTGFID').AsInteger   := ACLG_TGFID;
    ParamByName('PCOUID').AsInteger   := ACLG_COUID;
    ParamByName('PCLGPX').AsCurrency    := ACLG_PX;
    ParamByName('PCLGPNEGO').AsCurrency := ACLG_PXNEGO;
    ParamByName('PCLGPXVI').AsCurrency  := ACLG_PXVI;
    ParamByName('PCLGRA1').AsCurrency   := ACLG_RA1;
    ParamByName('PCLGRA2').AsCurrency   := ACLG_RA2;
    ParamByName('PCLGRA3').AsCurrency   := ACLG_RA3;
    ParamByName('PCLGTAXE').AsCurrency  := ACLG_TAXE;
    if FBaseVersion = 2 then
    begin
        ParamByName('CENCODE').AsInteger        := ACEN_CODE ;
        ParamByName('SETFOUPRINC').AsInteger    := AFOUPRINC ;
    end;
    ParamByName('PNOUPDATE').AsInteger := ANoUpdate;
    Open;

    if recordCount > 0 then
    begin
      Inc(FInsertcount,FieldbyName('FAJOUT').AsInteger);
      Result := FieldByName('CLG_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('SetTARCLGFOURN -> ' + E.Message);
  End;
end;

function TArticleClass.SetTarPrixVente(APVT_TVTID, APVT_ARTID, APVT_TGFID,
  APVT_COUID: Integer; APVT_PX: Currency; APVT_CENTRALE : Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETTARPRIXVENTE(:PPVTTVTID,:PPVTARTID, :PPVTTGFID,:PPVTCOUID, :PPVTPX, :PCENTRALE)');
    ParamCheck := True;
    ParamByName('PPVTTVTID').AsInteger := APVT_TVTID;
    ParamByName('PPVTARTID').AsInteger := APVT_ARTID;
    ParamByName('PPVTTGFID').AsInteger := APVT_TGFID;
    ParamByName('PPVTCOUID').AsInteger := APVT_COUID;
    ParamByName('PPVTPX').AsCurrency     := APVT_PX;
    ParamByName('PCENTRALE').AsInteger := APVT_CENTRALE;
    Open;

    if RecordCount > 0 then
    begin
      Inc(FInsertcount,FieldbyName('FAJOUT').AsInteger);
      Result := FieldByName('PVT_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('SetTarPrixVente -> ' + E.Message);
  End;
end;

procedure TArticleClass.Import;
type
  TTailleCouleur = record
    Nom,
    Code : String;
  end;

var
  i : Integer;
  bContinue : Boolean;
  Erreur : TErreur;
  Taille, Couleur : TTailleCouleur;
  bContinueTaille1, bContinueTaille2 : Boolean;
  bContinueCouleur1, bContinueCouleur2 : Boolean;

  FOU_CODE, FOU_NOM : String;
  iPosition : Integer;
  iCentrale : Integer ;
  iNumFou   : Integer ;
  ColDefaut : String;

  {$REGION 'Fonction CheckTailleCouleur de traitement pour la taille'}
  function CheckTailleCouleur(AType, ANom, ACode : String) : TTailleCouleur;
  begin
    Result.Nom  := '';
    Result.Code := '';
    case AnsiIndexStr(Trim(AType),['1','0']) of
      0: begin
       if Trim(ANom) = '' then
       begin
         if Trim(ACode) = '' then
            Result.Nom := 'UNI'
         else
            Result.Nom := ACode;
       end
       else
          Result.Nom := ANom;

       if Trim(ACode) = '' then
       begin
         if Trim(ANom) = '' then
           Result.Code := 'UNI'
         else
           Result.Code := ANom;
       end
       else
         Result.Code := ACode;
      end;

      1: begin
        if Trim(ANom) = '' then
        begin
          if Trim(ACode) = '' then
             Result.Nom := 'UNIQUE'
          else
             Result.Nom := ACode;
        end
        else
           Result.Nom := ANom;

        if Trim(ACode) = '' then
        begin
          if Trim(ANom) = '' then
            Result.Code := 'UNI'
          else
            Result.Code := ANom;
        end
        else
          Result.Code := ACode;
      end;
      else
        raise Exception.Create('CheckTailleCouleur -> Type non reconnu : ' + AType);
    end; // case
  end;
  {$ENDREGION}

begin

  // Récupération de la Collection par Défaut
  GetGenParam(16,33,ColDefaut);

  // Créaton des tables et champs
  CreateCdsField;

  case FMagType of
    mtCourir:   iCentrale := CTE_COURIR ;
    mtGoSport:  iCentrale := CTE_GOSPORT ;
  end;

  // Vérification que l'on a bien la combinaison de deux fichiers disponible
  if  (FModeleFile = '') Xor (FSfaFile = '') then
  begin
    Erreur := TErreur.Create;
    if FModeleFile = '' then
      Erreur.AddError(FSfaFile,'Fichier',Format('Pas de fichier MODELE présent pour le fichier MODSFA %s',[FSfaFile]),0,teArticle,0,'');
    if FSfaFile = '' then
      Erreur.AddError(FModeleFile,'Fichier',Format('Pas de fichier MODSFA présent pour le fichier MODELE %s',[FModeleFile]),0,teArticle,0,'');
    GERREURS.Add(Erreur);
    IncError;
    Exit;
  end;


  // Création de la table article en mémoire
  With DM_GSDataImport do
  begin
    // Pour récupérer le nombre d'enregistrement
    FCount := cds_MODELE.recordcount + cds_ARTICL.RecordCount + cds_MODSFA.RecordCount;

    // Gestion du fichier MODELE
    LabCaption('Importation du fichier ' + FModeleFile);
    cds_MODELE.First;
    while not cds_MODELE.Eof do
    begin
      Try
        if not Assigned(FMarque) then
          raise Exception.Create('Pas de fichier de marque disponible');
        if not Assigned(FNomenclature) then
          raise Exception.Create('Pas de fichier de nomenclature disponible');

        // Vérifie l'unicité d'un CODE_MODELE
        if not FArtArticle.ClientDataset.Locate('ART_CODE',cds_MODELE.FieldByName('CODE_MODELE').AsString,[]) then
        begin
          With FArtArticle do
          begin
            Append;
            FieldByName('ART_ID').AsInteger       := 0;
            FieldByName('ART_NOM').AsString       := cds_MODELE.FieldByName('LMOD').AsString;
            FieldByName('ART_MRKID').AsInteger    := FMarque.GetIdByCode(cds_MODELE.FieldByName('CODE_MARQUE').AsString, iCentrale);
            FieldByName('ART_REFMRK').AsString    := '';
            FieldByName('ART_GTFID').AsInteger    := 0;
            FieldByName('ART_CODE').AsString      := cds_MODELE.FieldByName('CODE_MODELE').AsString;

            case FMagType of
              mtGoSport: FieldByName('ART_CENTRALE').AsInteger := CTE_INTERNATIONAL ;
              mtCourir:  FieldByName('ART_CENTRALE').AsInteger := CTE_COURIR ;
            end;

            FieldByName('ART_FDS').AsInteger      := 0;
            FieldByName('NOUPDATE').AsInteger     := 0;
            If cds_MODSFA.Locate('CODE_MODELE',cds_MODELE.FieldByName('CODE_MODELE').AsString,[loCaseInsensitive]) then
            begin
              FieldbyName('SSF_ID').AsInteger    := FNomenclature.GetIdByCode(cds_MODSFA.FieldByName('SFA').AsString, iCentrale);
              FieldByName('Error').AsInteger     := 0;
            end
            else begin
              FieldbyName('SSF_ID').AsInteger    := 0;
              FieldByName('Error').AsInteger     := 1;
              Erreur := TErreur.Create;
              Erreur.AddError(FSfaFile,'Nomenclature','Pas de nomenclature pour le modèle ' + cds_MODELE.FieldByName('CODE_MODELE').AsString,cds_MODELE.RecNo,teArticle,0,'');
              GERREURS.Add(Erreur);
              IncError;
            end;
            Post;
          end; // with

          With FArtReference do
          begin
            Append;
            FieldByName('ART_CODE').AsString   := cds_MODELE.FieldByName('CODE_MODELE').AsString;
            FieldByName('ARF_ID').AsInteger    := 0;
            FieldByName('ARF_TVAID').AsInteger := -1;
            FieldByName('ARF_UC').AsInteger    := 0;
            Post;
          end;

          With FArtColArt do
          begin
            Append;
            FieldByName('ART_CODE').AsString := cds_MODELE.FieldByName('CODE_MODELE').AsString;

            if CollectionTable.Locate('COL_CODE',cds_Modele.FieldByName('SAISON').AsString + cds_MODELE.FieldByName('ANNEE').AsString,[loCaseInsensitive]) then
              FieldbyName('CAR_COLID').AsInteger := CollectionTable.FieldByName('COL_ID').AsInteger
            else begin
              if CollectionTable.Locate('COL_CODE',ColDefaut,[loCaseInsensitive]) then
                FieldbyName('CAR_COLID').AsInteger := CollectionTable.FieldByName('COL_ID').AsInteger
              else
              begin
               Erreur := TErreur.Create;
               Erreur.AddError(FModeleFile,'Collection','Collection non trouvée : ' + cds_Modele.FieldByName('SAISON').AsString + cds_MODELE.FieldByName('ANNEE').AsString,cds_Modele.RecNo,teArticle,0,'');
               GErreurs.Add(Erreur);
               IncError;
              // Mise en erreur du modèle
              FArtArticle.Edit;
              FArtArticle.FieldByName('Error').AsInteger := 1;
              FArtArticle.Post;
              end;
            end;
          end;
        end; // if
      Except on E:Exception do
        begin
           Erreur := TErreur.Create;
           Erreur.AddError(FModeleFile,'Import',Format('Modèle %s - %s',[cds_MODELE.FieldByName('CODE_MODELE').AsString,E.Message]),cds_Modele.RecNo,teArticle,0,'');
           GErreurs.Add(Erreur);
           IncError;
          // Mise en erreur du modèle
          FArtArticle.Edit;
          FArtArticle.FieldByName('Error').AsInteger := 1;
          FArtArticle.Post;
        end;
      end;

      cds_MODELE.Next;
      BarPosition(cds_MODELE.RecNo * 100 Div Cds_MODELE.RecordCount);
    end; // while

    // Gestion du fichier ARTICL
    LabCaption('Importation du fichier ' + FArticlFile);
    cds_ARTICL.First;
    while not cds_ARTICL.Eof do
    begin
      Try
        bContinue := True;
        if cds_ARTICL.FieldByName('CODE_MODELE').AsString <> FArtArticle.FieldByName('ART_CODE').AsString then
        begin
          iNumFou := 0 ;
          if not FArtArticle.ClientDataset.Locate('ART_CODE',cds_ARTICL.FieldByName('CODE_MODELE').AsString,[]) then
          begin
            // recherche des informations de l'article dans la base de données
            With FIboQuery do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select ART_ID, ART_MRKID, ART_NOM, ART_REFMRK, ART_GTFID,');
              SQL.Add(' ARF_ID, ARF_TVAID, ARF_UC, ARX_SSFID, ART_CENTRALE from ARTARTICLE');
              SQL.Add('  Join K on K_ID = ART_ID and K_Enabled = 1');
              SQL.Add('  Join ARTREFERENCE ON ARF_ARTID = ART_ID');
              SQL.Add('  Join ARTRELATIONAXE on ARX_ARTID = ART_ID');
              SQL.Add('Where ART_CODE = :PARTCODE');
              ParamCheck := true;
              ParamByName('PARTCODE').AsString := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
              Open;

              if RecordCount = 0 then
              begin
                // Pas d'informations trouvées
                Erreur := TErreur.Create;
                Erreur.AddError(FArticlFile,'Article','Code modèle non trouvé : ' + cds_ARTICL.FieldByName('CODE_MODELE').AsString,cds_ARTICL.RecNo,teArticle,0,'');
                GErreurs.Add(Erreur);
                IncError;
                bContinue := False;
              end;
            end;

            if bContinue then
            begin
              With FArtArticle do
              begin
                // création des informations en mémoire
                Append;
                FieldByName('ART_ID').AsInteger       := FIboQuery.FieldByName('ART_ID').AsInteger;
                FieldByName('ART_NOM').AsString       := FIboQuery.FieldByName('ART_NOM').AsString;
                FieldByName('ART_MRKID').AsInteger    := FIboQuery.FieldByName('ART_MRKID').AsInteger;
                FieldByName('ART_REFMRK').AsString    := FIboQuery.FieldByName('ART_REFMRK').AsString;
                FieldByName('ART_GTFID').AsInteger    := FIboQuery.FieldByName('ART_GTFID').AsInteger;
                FieldByName('ART_CODE').AsString      := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                FieldByName('ART_CENTRALE').AsInteger := FIboQuery.FieldByName('ART_CENTRALE').AsInteger;
                FieldByName('ART_FDS').AsInteger      := 0;
                FieldByName('NOUPDATE').AsInteger     := 0;
                FieldbyName('SSF_ID').AsInteger       := FiboQuery.FieldByName('ARX_SSFID').AsInteger;
                FieldByName('Error').AsInteger        := 0;
                Post;
              end; // with

              With FArtReference do
              begin
                Append;
                FieldByName('ART_CODE').AsString   := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                FieldByName('ARF_ID').AsInteger    := FIboQuery.FieldByName('ARF_ID').AsInteger;
                FieldByName('ARF_TVAID').AsInteger := FIboQuery.FieldByName('ARF_TVAID').AsInteger;
                FieldByName('ARF_UC').AsInteger    := FIboQuery.FieldByName('ARF_UC').AsInteger;
                Post;
              end;
            end;
          end;
        end ;

        if bContinue then
        begin
          case AnsiIndexStr(cds_ARTICL.FieldByName('CODE_TYP_VAL').AsString,['1','15', '19', '31', '55', '44', '80', '81']) of
            0: begin // 1 - Gestion des codes à barres
              With FArtCodeBarre do
              begin
                if not ClientDataset.Locate('ART_CODE;CODE_ARTICLE;CBI_CB',
                                            VarArrayOf([cds_ARTICL.FieldByName('CODE_MODELE').AsString,
                                                        cds_ARTICL.FieldByName('CODE_ARTICLE').AsString,
                                                        cds_ARTICL.FieldByName('VALEUR').AsString]),
                                            [loCaseInsensitive]) then
                begin
                  Append;
                  FieldByName('ART_CODE').AsString  := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                  FieldByName('CODE_ARTICLE').AsString := cds_ARTICL.FieldByName('CODE_ARTICLE').AsString;
                  FieldByName('CBI_ID').AsInteger      := 0;
                  FieldByName('CBI_TGFID').AsInteger   := 0;
                  FieldByName('CBI_COUID').AsInteger   := 0;
                  FieldByName('CBI_ARFID').AsInteger   := 0;
                  FieldByName('CBI_CB').AsString       := cds_ARTICL.FieldByName('VALEUR').AsString;
                  Post;
                end;
              end;
            end;
            1: begin // 15 - Gestion ArtRefMrk
              FArtArticle.Edit;
              FArtArticle.FieldByName('ART_REFMRK').AsString := cds_ARTICL.FieldByName('VALEUR').AsString;
              FArtArticle.Post;
            end;
            2: begin // 19 - Gestion du Stock Ideal
              With FArtIdeal do
              begin
                if not ClientDataset.Locate('ART_CODE;CODE_ARTICLE',
                                            VarArrayOf([cds_ARTICL.FieldByName('CODE_MODELE').AsString,
                                                        cds_ARTICL.FieldByName('CODE_ARTICLE').AsString]),
                                            [loCaseInsensitive]) then
                begin
                  Append;
                  FieldByName('ART_CODE').AsString  := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                  FieldByName('CODE_ARTICLE').AsString := cds_ARTICL.FieldByName('CODE_ARTICLE').AsString;
                  FieldByName('STI_ARTID').AsInteger := 0;
                  FieldByName('STI_TGFID').AsInteger := 0;
                  FieldByName('STI_COUID').AsInteger := 0;
                  FieldByName('STI_MAGID').AsInteger := 0;
                  FieldByName('STI_QTE').AsCurrency    := cds_ARTICL.FieldByName('VALEUR').AsCurrency;
                  Post;
                end;
              end;
            end;
            3: begin // 31 - Gestion de la TVA
              if TVATable.Locate('TVA_CODE',cds_ARTICL.FieldByName('VALEUR').AsString,[]) then
              begin
                FArtReference.Edit;
                FArtReference.FieldByName('ARF_TVAID').AsInteger := TVATable.FieldByName('TVA_ID').AsInteger;
                FArtReference.Post;
              end
              else begin
                Erreur := TErreur.Create;
                Erreur.AddError(FArticlFile,'TVA','Code TVA non trouvé : ' + cds_ARTICL.FieldByName('VALEUR').AsString,cds_ARTICL.RecNo,teArticle,0,'');
                Gerreurs.Add(Erreur);
                IncError;
                // Mise en erreur du modèle
                FArtArticle.Edit;
                FArtArticle.FieldByName('Error').AsInteger := 1;
                FArtArticle.Post;
              end;
            end;
            4: begin // 55 - Gestion de l'UC
              FArtReference.Edit;
              FArtReference.FieldByName('ARF_UC').AsString  := cds_ARTICL.FieldByName('VALEUR').AsString;
              FArtReference.Post;
            end;

            5: begin // 44 - Tarif d'achats
              If not FTarClgFourn.ClientDataset.Locate('CODE_ARTICLE','',[]) then
              begin
                // Vérification qu'on a bien le tarif de base de l'article
                FTarClgFourn.Append;
                FTarClgFourn.FieldByName('ART_CODE').AsString     := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                FTarClgFourn.FieldByName('CODE_ARTICLE').AsString := '';
                FTarClgFourn.FieldByName('CLG_PX').AsCurrency        := StrToFloat(StringReplace(cds_ARTICL.FieldByName('VALEUR').AsString,'.',',',[]));
                FTarClgFourn.FieldByName('CLG_PXNEGO').AsCurrency    := StrToFloat(StringReplace(cds_ARTICL.FieldByName('VALEUR').AsString,'.',',',[]));
                FTarClgFourn.FieldByName('CLG_CENTRALE').AsInteger := iCentrale ;
                FTarClgFourn.Post;
              end
              else begin
                if CompareValue(StrToFloat(StringReplace(cds_ARTICL.FieldByName('VALEUR').AsString,'.',',',[])),FTarClgFourn.FieldByName('CLG_PX').AsCurrency,0.001) <> EqualsValue then
                begin
                  FTarClgFourn.Append;
                  FTarClgFourn.FieldByName('ART_CODE').AsString     := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                  FTarClgFourn.FieldByName('CODE_ARTICLE').AsString := cds_ARTICL.FieldByName('CODE_ARTICLE').AsString;
                  FTarClgFourn.FieldByName('CLG_PX').AsCurrency        := StrToFloat(StringReplace(cds_ARTICL.FieldByName('VALEUR').AsString,'.',',',[]));
                  FTarClgFourn.FieldByName('CLG_PXNEGO').AsCurrency    := StrToFloat(StringReplace(cds_ARTICL.FieldByName('VALEUR').AsString,'.',',',[]));
                  FTarClgFourn.FieldByName('CLG_CENTRALE').AsInteger := iCentrale ;
                  FTarClgFourn.Post;
                end;
              end;
            end;

            6: begin // 80 - Suivi magasin
              if cds_ARTICL.FieldByName('VALEUR').AsString = 'X' then
              begin
                FArtArticle.Edit;
                FArtArticle.FieldByName('NOUPDATE').AsInteger := 1;

                case FMagType of
                    mtCourir :   FArtArticle.FieldByName('ART_CENTRALE').AsInteger := CTE_NONE ;
                end;

                FArtArticle.Post;
              end;
            end;

            7: begin // 81 - fournisseur
               iPosition := Pos('-',cds_ARTICL.FieldByName('VALEUR').AsString);
               if iPosition > 0 then
               begin
                 FOU_CODE := Copy(cds_ARTICL.FieldByName('VALEUR').AsString,1,iPosition -1);
                 FOU_CODE := Copy(FOU_CODE,Length(FOU_CODE) - 6,Length(FOU_CODE));
                 if FOU_CODE[1] = '0'
                  then FOU_CODE := Copy(FOU_CODE, 2, Length(FOU_CODE)-1) ;

                 FOU_NOM := Copy(cds_ARTICL.FieldByName('VALEUR').AsString, iPosition + 1,Length(cds_ARTICL.FieldByName('VALEUR').AsString));

                 Inc(iNumFou) ;
                 if not FArtFournARTCODE.ClientDataset.Locate('ART_CODE;FOU_CODE',varArrayOf([cds_ARTICL.FieldByName('CODE_MODELE').AsString,FOU_CODE]),[]) then
                 begin
                   FArtFournARTCODE.Append;
                   FArtFournARTCODE.FieldByName('ART_CODE').AsString := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                   FArtFournARTCODE.FieldByName('FOU_CODE').AsString := FOU_CODE ;
                   if (iNumFou = 1)
                    then FArtFournARTCODE.FieldByName('FOU_PRINC').AsInteger := 1
                    else FArtFournARTCODE.FieldByName('FOU_PRINC').AsInteger := 0 ;

                   FArtFournARTCODE.Post;
                 end;

                 if not FArtfourn.ClientDataset.Locate('FOU_CODE',FOU_CODE,[]) then
                 begin
                   FArtfourn.Append;
                   FArtfourn.FieldByName('FOU_CODE').AsString      := FOU_CODE;
                   FArtfourn.FieldByName('FOU_NOM').AsString       := FOU_NOM;
                   FArtfourn.FieldByName('FOU_ID').AsInteger       := 0;

                   if (FOU_CODE = '9999999')
                     then FArtfourn.FieldByName('FOU_TYPE').AsInteger     := 1
                     else FArtfourn.FieldByName('FOU_TYPE').AsInteger     := 5;

                   FArtfourn.FieldByName('FOU_CENTRALE').AsInteger := iCentrale ;
                   FArtfourn.FieldByName('FOU_ACTIVE').AsInteger   := 1;
                   FArtfourn.FieldByName('FOU_IDREF').AsInteger    := 1;
                   FArtfourn.FieldByName('FOU_GROS').AsInteger     := 0;
                   FArtfourn.Post;
                 end;

                 if (FOU_CODE = '9999999') then
                 begin
                    case FMagType of
                      mtGoSport : begin
                                    FArtArticle.Edit;
                                    FArtArticle.FieldByName('ART_CENTRALE').AsInteger := CTE_GOSPORT ;
                                    FArtArticle.Post ;
                                  end ;
                    end;
                 end

               end
               else begin
                 Erreur := TErreur.Create;
                 Erreur.AddError(FArticlFile,'Fournisseur','Fournisseur incorrect : ' + cds_ARTICL.FieldByName('VALEUR').AsString,cds_ARTICL.RecNo,teArticle,0,'');
                 Gerreurs.Add(Erreur);
                 IncError;
                 // Mise en erreur du modèle
                 FArtArticle.Edit;
                 FArtArticle.FieldByName('Error').AsInteger := 1;
                 FArtArticle.Post;
               end;
            end;
          end; // case

          {$REGION 'Gestion de la grille de taille'}
          With FPLXTaillesGF do
          begin
            for i := 1 to 2 do
            begin
              bContinue := False;
              // Faux dans le CDC, le type doit être à 1 pour la couleur et à 0 pour la taille
              if Trim(cds_ARTICL.FieldByName('TYPE_PT' + IntToStr(i)).AsString) = '1' then
              begin
               Taille := CheckTailleCouleur(cds_ARTICL.FieldByName('TYPE_PT' + IntToStr(i)).AsString,cds_ARTICL.FieldByName('LIB_POINT' + IntToStr(i)).AsString,cds_ARTICL.FieldByName('CODE_POINT' + IntToStr(i)).AsString);
               bContinue := True;
              end;

              if (not ClientDataset.Locate('CODE_ARTICLE',cds_ARTICL.FieldByName('CODE_ARTICLE').AsString,[])) and bContinue then
              begin
                Append;
                FieldByName('TGF_ID').AsInteger      := 0;
                FieldByName('TGF_GTFID').AsInteger   := 0;
                FieldByName('TGF_NOM').AsString      := Taille.Nom;
                FieldByName('TGF_CODE').AsString     := Taille.Code;
                FieldByName('TGF_CENTRALE').AsInteger := iCentrale ;
                FieldByName('CODE_ARTICLE').AsString := cds_ARTICL.FieldByName('CODE_ARTICLE').AsString;
                FieldByName('ART_CODE').AsString  := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                Post;
              end;
            end; // for

            // S'il n'y a pas de taille de créée alors on crée la taille unique des articles individuels GOSPORT
            if ClientDataset.RecordCount = 0 then
            begin
              Append;
              FieldByName('TGF_ID').AsInteger      := 0;
              FieldByName('TGF_GTFID').AsInteger   := 0;
              FieldByName('TGF_NOM').AsString      := 'UNIQUE';
              FieldByName('TGF_CODE').AsString     := 'UNIIND';
              FieldByName('TGF_CENTRALE').AsInteger := iCentrale;
              FieldByName('CODE_ARTICLE').AsString := cds_ARTICL.FieldByName('CODE_ARTICLE').AsString;
              FieldByName('ART_CODE').AsString  := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
              Post;
            end;

          end; // with
          {$ENDREGION}

          {$REGION 'Gestion de la couleur'}
          With FPLXCouleur do
          begin
            for i := 1 to 2 do
            begin
              bContinue := False;
              // Faux dans le CDC, le type doit être à 1 pour la couleur et à 0 pour la taille
              if Trim(cds_ARTICL.FieldByName('TYPE_PT' + IntToStr(i)).AsString) = '0' then
              begin
               Couleur := CheckTailleCouleur(cds_ARTICL.FieldByName('TYPE_PT' + IntToStr(i)).AsString,cds_ARTICL.FieldByName('LIB_POINT' + IntToStr(i)).AsString,cds_ARTICL.FieldByName('CODE_POINT' + IntToStr(i)).AsString);
               bcontinue := True;
              end;

              if (not ClientDataset.Locate('CODE_ARTICLE',cds_ARTICL.FieldByName('CODE_ARTICLE').AsString,[])) and bContinue then
              begin
                Append;
                FieldByName('COU_ID').AsInteger      := 0;
                FieldByName('COU_ARTID').AsInteger   := 0;
                FieldByName('COU_NOM').AsString      := Couleur.Nom;
                FieldByName('COU_CODE').AsString     := Couleur.Code;
                FieldByName('COU_CENTRALE').AsInteger   := iCentrale ;
                FieldByName('CODE_ARTICLE').AsString := cds_ARTICL.FieldByName('CODE_ARTICLE').AsString;
                FieldByName('ART_CODE').AsString  := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
                Post;
              end;
            end; // for

            // S'il n'y a pas de couleur de créée alors on crée la couleur unique des articles individuels GOSPORT
            if ClientDataset.RecordCount = 0 then
            begin
              Append;
              FieldByName('COU_ID').AsInteger      := 0;
              FieldByName('COU_ARTID').AsInteger   := 0;
              FieldByName('COU_NOM').AsString      := 'UNICOLOR';
              FieldByName('COU_CODE').AsString     := 'UNIIND';
              FieldByName('COU_CENTRALE').AsInteger   := iCentrale ;
              FieldByName('CODE_ARTICLE').AsString := cds_ARTICL.FieldByName('CODE_ARTICLE').AsString;
              FieldByName('ART_CODE').AsString  := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
              Post;
            end;
          end; // with
          {$ENDREGION}

          {$REGION 'Gestion de la table ARTRELATIONART'}
          With FArtRelartionArt do
          begin
            if not FArtRelartionArt.ClientDataset.Locate('CODE_ARTICLE',cds_ARTICL.FieldByName('CODE_ARTICLE').AsString,[]) then
            begin
              Append;
              FieldByName('ART_CODE').AsString  := cds_ARTICL.FieldByName('CODE_MODELE').AsString;
              FieldByName('CODE_ARTICLE').AsString := cds_ARTICL.FieldByName('CODE_ARTICLE').AsString;
              FieldByName('ARA_ID').AsInteger      := 0;
              FieldByName('ARA_ARTID').AsInteger   := 0;
              FieldByName('ARA_TGFID').AsInteger   := 0;
              FieldByName('ARA_COUID').AsInteger   := 0;
              Post;
            end;
          end;
          {$ENDREGION}
        end; // continue
      Except on E:Exception do
        begin
           Erreur := TErreur.Create;
           Erreur.AddError(FArticlFile,'Import',Format('Modèle %s - %s',[cds_ARTICL.FieldByName('CODE_MODELE').AsString,E.Message]),cds_ARTICL.RecNo,teArticle,0,'');
           GErreurs.Add(Erreur);
           IncError;
          // Mise en erreur du modèle
          if cds_MODELE.Locate('CODE_MODELE',cds_ARTICL.FieldByName('CODE_MODELE').AsString,[loCaseInsensitive]) then
          begin
            FArtArticle.Edit;
            FArtArticle.FieldByName('Error').AsInteger := 1;
            FArtArticle.Post;
          end;
        end;
      end;
      cds_ARTICL.Next;
      BarPosition(cds_ARTICL.RecNo * 100 Div cds_ARTICL.RecordCount);
    end; // while

    // Libération des CDS
    cds_ARTICL.EmptyDataSet ;
    cds_MODELE.EmptyDataSet ;
    cds_MODSFA.EmptyDataSet ;

  end; // with
end;

end.
