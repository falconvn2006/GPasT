unit Main_DM;

interface

uses
  SysUtils, Classes, xmldom, XMLIntf, IB_Components, msxmldom, XMLDoc, Dialogs,
  uTypes, ComCtrls, uDefs, StdCtrls, DB, DBClient, Midas, Xml_unit, IcXmlParser, forms,
  Variants, IBODataset,Math,Types,StrUtils
  ;

type
  TDM_Main = class(TDataModule)
    XMLDoc: TXMLDocument;
    IbC_MainCnx: TIB_Connection;
    Que_TmpEvent: TIBOQuery;
    IBOTransaction: TIBOTransaction;
    Que_NEWK: TIBOQuery;
    Que_ListTVA: TIBOQuery;
    Que_ListGarantie: TIBOQuery;
    Que_ListTypeComptable: TIBOQuery;
    Que_ChronoArticle: TIBOQuery;
    Que_ListUnivers: TIBOQuery;
    Que_ListTVATVA_ID: TIntegerField;
    Que_ListTVATVA_TAUX: TIBOFloatField;
    Que_ListTVATVA_CODE: TStringField;
    Que_ListTVATVA_COMPTA: TStringField;
    cdsFedas: TClientDataSet;
    ibs_UPDATEK: TIBOStoredProc;
    Que_ListExerciceCommercial: TIBOQuery;
    Que_ListArtCollection: TIBOQuery;
    Que_ListUilUsers: TIBOQuery;
  private
    { Déclarations privées }
    // retourne un nouveau K
    function GetNewKId(sTableName : String) : Integer;
    // Met à jour la table K
    function UpdateKId(K_ID, Suppression : Integer) : Boolean;
    // retourne un nouveau Chrono Article
    function GetChronoArticle : String;

    // Retourne l'Id Pays (Si le pays n'existe pas la fonction va le créer)
    function GetPaysId(sNomPays : String) : Integer;
    // Retourne l'id de la ville, (si la ville/cp n'existe pas, la fonction va les créer)
    function GetVilleId(sNomVille, sCP : String; iPayID : Integer) : integer;
    // Retourne l'id de l'adresse (si elle n'existe pas elle est créée)
    Function GetAdresseId(ADR_LIGNE : String;ADR_VILID : Integer;ADR_TEL,ADR_FAX,ADR_GSM,ADR_EMAIL,ADR_COMMENT : String) : Integer;
    // Création d'un fournisseur dans Ginkoia
    Function SetFournisseur(FOU_IDREF : integer;FOU_NOM : String;FOU_ADRID : integer;FOU_TEL,FOU_FAX,FOU_EMAIL : String;FOU_REMISE : single; FOU_GROS : integer;FOU_CDTCDE,FOU_CODE,FOU_TEXTCDE : String;FOU_MAGIDPF : integer) : integer;
    // Création du détail fournisseur
    function SetFournisseurDetails(FOD_FOUID,FOD_MAGID : Integer;FOD_NUMCLIENT,FOD_COMENT : String;FOD_FTOID,FOD_MRGID,FOD_CPAID : Integer;FOD_ENCOURSA : single;FOD_COMPTA : String;FOD_FRANCOPORT : Single) : Integer;

    // Retourne l'id d'un secteur (il est créé s'il n'existe pas )
    function GetSecteurId(SEC_IDREF : integer;SEC_NOM : String;SEC_UNIID,SEC_TYPE : integer) : Integer;
    function UpdateSecteur(SEC_ID,SEC_IDREF : integer;SEC_NOM : String;SEC_UNIID,SEC_TYPE : integer) : Boolean;

    // Retourne l'id d'un Rayon (il est créé s'il n'existe pas )
    function GetRayonId(RAY_UNIID,RAY_IDREF : integer;RAY_NOM : String;RAY_ORDREAFF : single;RAY_VISIBLE,RAY_SECID : Integer) : Integer;
    function UpdateRayon(RAY_ID,RAY_UNIID,RAY_IDREF : integer;RAY_NOM : String;RAY_ORDREAFF : single;RAY_VISIBLE,RAY_SECID : Integer) : Boolean;

    // retourne l'id famille(il est créé s'il n'existe pas)
    function GetFamilleId(FAM_RAYID,FAM_IDREF : integer;FAM_NOM : String;FAM_ORDREAFF : single;FAM_VISIBLE,FAM_CTFID : integer) : integer;
    function UpdateFamille(FAM_ID,FAM_RAYID,FAM_IDREF : integer;FAM_NOM : String;FAM_ORDREAFF : single;FAM_VISIBLE,FAM_CTFID : integer) : Boolean;

    // retourne l'id d'une sous famille (il est crée s'il n'existe pas)
    function GetSsFamileID(SSF_FAMID,SSF_IDREF : integer;SSF_NOM : String;SSF_ORDREAFF : single;SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID : integer) : Integer;
    function UpdateSsFamille(SSF_ID,SSF_FAMID,SSF_IDREF : integer;SSF_NOM : String;SSF_ORDREAFF : single;SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID : integer) : Boolean;
    function GetNomenclatureBySSFID(SSF_ID : integer) : TNomenclature;

    // Retourne l'id d'une marque (elle est créé si elle n'existe pas)
    function GetMarqueId(MRK_IDREF : integer;MRK_NOM,MRK_CONDITION,MRK_CODE : String) : integer;

    // retourn l'id article(L'article est créé s'il n'existe pas )
    function GetArticleId(ART_IDREF : integer;ART_NOM : String;ART_ORIGINE : integer;
                          ART_DESCRIPTION :String;ART_MRKID : integer;ART_REFMRK : String;
                          ART_SSFID,ART_PUB,ART_GTFID : integer;ART_SESSION : String;
                          ART_GREID : integer;ART_THEME,ART_GAMME,ART_CODECENTRALE,ART_TAILLES,ART_POS,ART_GAMPF,ART_POINT,ART_GAMPRODUIT : String;
                          ART_SUPPRIME,ART_REFREMPLACE,ART_GARID,ART_CODEGS : integer;
                          ART_COMENT1,ART_COMENT2,ART_COMENT3,ART_COMENT4,ART_COMENT5,ART_CPTANA : String) : Integer;
    // retourn l'id article référence(L'article est créé s'il n'existe pas
    function GetArticleRefID(ARF_ARTID,ARF_CATID,ARF_TVAID,ARF_TCTID,ARF_ICLID1,ARF_ICLID2,ARF_ICLID3,ARF_ICLID4,ARF_ICLID5 : Integer;
                             ARF_CREE,ARF_MODIF : TDateTime;
                             ARF_DIMENSION,ARF_VIRTUEL,ARF_SERVICE : Integer;ARF_COEFT,ARF_STOCKI : Single;
                             ARF_VTFRAC,ARF_CDNMT : Integer;ARF_CDNMTQTE : Single;ARF_UNITE : String;
                             ARF_CDNMTOBLI,ARF_GUELT :Integer;ARF_CPFA : Single;ARF_FIDELITE,ARF_ARCHIVER : integer;
                             ARF_FIDPOINT : single;ARF_FIDDEBUT,ARF_FIDFIN : TDateTime;ARF_DEPTAUX : single;
                             ARF_CGTID : integer;ARF_GLTMONTANT,ARF_GLTPXV,ARF_GLTMARGE : Single;
                             ARF_GLTDEBUT,ARF_GLTFIN : TDateTime;ARF_MAGORG,ARF_CATALOG,ARF_UC : integer) : Integer;

    // Retourne l'id d'une couleur(elle est créé si elle n'existe pas)
    function GetCouleurId(COU_ARTID, COU_IDREF, COU_GCSID : Integer;COU_CODE, COU_NOM : String) : Integer;

    // retourne l'id d'un type de taille (Elle est créé si elle n'existe pas)
    function GetTailleGTFId(GTF_IDREF : Integer;GTF_NOM : String;GTF_TGTID : Integer;GTF_ORDREAFF : single;GTF_IMPORT : Integer) : Integer;
    // Retourne l'id PLXTAILLESGF (Elle est créé si elle n'existe pas)
    function GetTailleGFId(TGF_GTFID,TGF_IDREF,TGF_TGFID : integer;TGF_NOM,TGF_CORRES : String;TGF_ORDREAFF : single;TGF_STAT : integer) : Integer;
    // Création/ récupération de l'id GEnre
    function GetGenreId(GRE_IDREF : integer;GRE_NOM : String;GRE_SEXE : integer) : integer;
    // Retourne l'idTVA
    function GetTVAId(TVA_TAUX : single;TVA_CODE : String = '') : integer;
    // récupère l'id de la catégorie, sinon elle est créée
    function GetCategorieID(CTF_NOM : String;CTF_UNIID : integer) : Integer;
    // Récupère l'id de la sous catégorie, elle est créée si elle n'existe pas
    function GetSsCategorieID(CAT_NOM : String;CAT_UNIID : integer) : Integer;

    // Création de la relation/Article Taille
    function SetTailleTrav(TTV_ARTID,TTV_TGFID : Integer) : Integer;

    // function de Création des codes à barres
    function SetCBArticle(CBI_ARFID,CBI_TGFID,CBI_COUID : integer;CBI_CB : String;CBI_TYPE : integer;CBI_CLTID,CBI_ARLID,CBI_LOC : integer) : Integer;

    // fonction qui génère les prix de vente des articles
    function SetArtPrixVente(PVT_TVTID,PVT_ARTID,PVT_TGFID : Integer;PVT_PX : single) : Integer;
    // fonction qui génère les prix d'acaht des articles
    function SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL : integer) : Integer;
    //  création de la jointure fournisseur/marque
    function SetMrkFour(FMK_FOUID,FMK_MRKID,FMK_PRIN : integer) : Integer;


    // fonction qui retourne l'Id sous famille et créer l'arborescence si elle n'existe pas
    function CreateSsFamille(ListTbHF : TListTableHF;CodeModele : String) : TNomenclature;
    // Création d'un fournisseur et retourne l'id (créer le forunisseur s'il n'existe pas
    function CreateFournisseur(ListTbHF : TListTableHF;CodeFRN : String) : Integer;
    // création des marques
    function CreateMarques(ListTbHF : TListTableHF;CodeMarque : String) : Integer;
    // Création des courleus
    function CreateCouleurs(ListTbHF : TListTableHF;IdArticle : Integer;CodeMode,MrkCode,ColCode : String) : Integer;
    // création des tailles
    function CreateTaille(ListTbHF : TListTableHF;IdArticle : Integer;CodeSize : String): TTailleId;
    // Création du genre du modèle
    function CreateGenre(ListTbHF : TListTableHF;CodeGroupe : String) : Integer;

    function IsIdRefExist(IdREF : Integer;TableName,sFieldName, sRefField : String) : Integer;
    function GetGenImportId(IMP_KTIBID,IMP_GINKOIA,IMP_REF,IMP_NUM : Integer;IMP_REFSTR : String) : TGENIMPORT;

    // fonction d'insertion des commandes
    function GetCommandeId (CDE_NUMERO : String;CDE_SAISON,CDE_EXEID,CDE_CPAID,CDE_MAGID,CDE_FOUID : Integer;
                            CDE_NUMFOURN : String;CDE_DATE : TDateTime;CDE_REMISE,CDE_TVAHT1,CDE_TVATAUX1,CDE_TVA1,
                            CDE_TVAHT2,CDE_TVATAUX2,CDE_TVA2,CDE_TVAHT3,CDE_TVATAUX3,CDE_TVA3,
                            CDE_TVAHT4,CDE_TVATAUX4,CDE_TVA4,CDE_TVAHT5,CDE_TVATAUX5,CDE_TVA5 : single;
                            CDE_FRANCO,CDE_MODIF : Integer;CDE_LIVRAISON : TDateTime;CDE_OFFSET : integer;
                            CDE_REMGLO : single;CDE_ARCHIVE : integer;CDE_REGLEMENT : TDateTime;CDE_TYPID,
                            CDE_NOTVA,CDE_USRID : integer;CDE_COMENT : String; CDE_COLID : integer) : Integer;
    function GetCommandeLigneId(CDL_CDEID,CDL_ARTID,CDL_TGFID,CDL_COUID : integer;CDL_QTE,CDL_PXCTLG,CDL_REMISE1,
                                CDL_REMISE2,CDL_REMISE3,CDL_PXACHAT,CDL_TVA,CDL_PXVENTE : single;CDL_OFFSET : integer;
                                CDL_LIVRAISON : TDateTime;CDL_TARTAILLE : integer;CDL_VALREMGLO : single) : Integer;
  public
    { Déclarations publiques }
    // fonction qui charge le fichier Fedas en mémoire
    function LoadFedasData(ListTbHF : TListTableHF) : Boolean;

    // Ouvre la base de données et les requêtes nécessaires
    function OpenDataBase(sFileName :String) : Boolean;
    // Fonction qui vérifie la liste des champs dans les xml et charge les fichiers en mémoire
    function CheckFieldList(ListTbHF : TListTableHF) : Boolean;
    // Fonction principale de traitement des données mis en mémoire
    function DoTraitement(ListTbHF : TListTableHF) : Boolean;

    // retourne l'id d'un Type Taille GT
    function GetTailleTypeGT(TGT_NOM : String;TGT_ORDREAFF : single) : Integer;
  end;

var
  DM_Main: TDM_Main;

implementation

{$R *.dfm}

{ TDM_Main }

function TDM_Main.CheckFieldList(ListTbHF : TListTableHF): Boolean;
var
  i, j, k,iProg : integer;
  nXmlBase : IXmlNode;
  eXmlNode : IXmlNode;
  bFound : Boolean;
begin
  Result := False;
  try
    for i := 0 to ListTbHF.Count - 1 do
    begin
      // chargement du fichier XML
      AddToMemo(ListTbHF.Memo,'  Chargement du fichier ' + UpperCase(ListTbHF.Items[i].TableName));

      Try
        XMLDoc.Active := False;
        XMLDoc.LoadFromFile(GPATHFILETMP + ListTbHF.Items[i].TableName + '.xml');
        XMLDoc.Active := True;
      Except on E:Exception do
        begin
          AddToMemo(ListTbHF.Memo,'  Erreur lors de l''ouverture du fichier XML : ' + ListTbHF.Items[i].TableName + '.xml');
          AddToMemo(ListTbHF.Memo,E.Message);
          Exit;
        end;
      End;

      // vérification que les champs nécessaires sont tous présent dans le fichier xml
      With XMLDoc.DocumentElement do
      begin
        With ChildNodes['Data'] do
        begin
          for j := 0 to  ListTbHF.Items[i].FieldList.Count - 1 do
          begin
            if Trim(ListTbHF.Items[i].FieldList[j]) <> '' then
            begin
              if ListTbHF.Items[i].FieldList[j][1] <> '+' then
              begin
                bFound := False;
                for k :=  0 to ChildNodes.Count - 1 do
                begin
                  if ChildNodes[k].NodeName = ListTbHF.Items[i].FieldList[j] then
                    bFound := True;
                end;
                if not bFound then
                begin
                  AddToMemo(ListTbHF.Memo,'  Le champ [' + ListTbHF.Items[i].FieldList[j] + '] n''existe pas dans le fichier ' + UpperCase(ListTbHF.Items[i].TableName));
                  Exit;
                end;
              end;
            end;
          end; // for j
        end;
      end;

      AddToMemo(ListTbHF.Memo,'  Structure Fichier ' + UpperCase(ListTbHF.Items[i].TableName) + ' >> OK');

      // Transfert dans le Dataset
      if not ListTbHF.Items[i].CDataSet.Active then
        ListTbHF.Items[i].CDataSet.Active := True;

      ListTbHF.Lab.Caption := 'Copie des données en mémoire de : ' + ListTbHF.Items[i].TableName;
      iProg := 1;
      nXmlBase := XMLDoc.DocumentElement;
      With nXmlBase do
      begin
        eXmlNode := ChildNodes['Data'];
        while eXmlNode <> nil do
        begin
          ListTbHF.Items[i].CDataSet.Append;
          for j := 0 to ListTbHF.Items[i].FieldList.Count - 1 do
          begin
            if Trim(ListTbHF.Items[i].FieldList[j]) <> '' then
              if not VarIsNull(eXmlNode.ChildValues[ListTbHF.Items[i].FieldList[j]]) then
              begin
                ListTbHF.Items[i].CDataSet.FieldByName(ListTbHF.Items[i].FieldList[j]).AsString := Trim(eXmlNode.ChildNodes[ListTbHF.Items[i].FieldList[j]].NodeValue);
              end;
          end;
          ListTbHF.Items[i].CDataSet.Post;

          eXmlNode := eXmlNode.NextSibling; // nXmlBase.ChildNodes['Data'];
          ListTbHF.Progress.Position := iProg * 100 DIV nXmlBase.ChildNodes.Count;
          inc(iProg);
          Application.processmessages;
        end;
        AddToMemo(ListTbHF.Memo,'  Copie des données de ' + UpperCase(ListTbHF.Items[i].TableName) + ' >> OK');
      end; // with
    end; // for i
    Result := True;
  finally
  end;
end;

function TDM_Main.CreateCouleurs(ListTbHF: TListTableHF;IdArticle : Integer;CodeMode,MrkCode,ColCode : String): Integer;
var
  TbCouleur : TTableHF;
  IdCouleur : Integer;
begin
  TbCouleur := ListTbHF.GetTable('COULEURCDE');

  if TbCouleur = nil then
    raise Exception.Create('Table couleur non trouvée');

  With TbCouleur do
  Try
    IdCouleur := 0;
    if TbCouleur.NLocate('CDCMODCODE;CDCMRKCODE;CDCCODECOL',VarArrayOf([CodeMode,MrkCode,ColCode]),[loCaseInsensitive]) then
    begin
      IdCouleur := CDataSet.FieldByName('COU_ID').AsInteger;
      if IdCouleur = 0 then
      begin
        IdCouleur := GetCouleurId(IdArticle,0,0,'',NFieldByName('CDCLIBCOL').AsString);
        CDataSet.Edit;
        CDataSet.FieldByName('COU_ID').AsInteger := IdCouleur;
        CDataSet.Post;
        inc(ListTbHF.iCptCouleur);
      end;
    end;
  Except
    raise;
  end; // with
  Result := IdCouleur;
end;

function TDM_Main.CreateFournisseur(ListTbHF: TListTableHF;CodeFRN : String) : Integer;
var
  IdPays  : Integer;
  IdVille : Integer;
  IdAdr   : Integer;
  IdFournisseur : Integer;
  i : integer;
  TbFournis : TTableHF;
begin
  Result := 0;
  
  TbFournis := ListTbHF.GetTable('FOURNISSEUR');
  if TbFournis = nil then
    raise Exception.Create('Table fournisseur non trouvée');

  With TbFournis do
  try
    IdFournisseur := 0;
    if NLocate('FRNCODE',CodeFRN,[loCaseInsensitive]) then
    begin
      IdFournisseur := NFieldByName('FOU_ID').AsInteger;
      if IdFournisseur = 0 then
      begin
        // récupération/création du pays
        IdPays  := GetPaysId(NFieldByName('FRNPAYS').AsString);
        // récupération / Création de la ville
        IdVille := GetVilleId(NFieldByName('FRNVILLE').AsString,NFieldByName('FRNCP').AsString,IdPays);

        // Récupération / Création de l'adresse du fournisseur
        IdAdr   := GetAdresseId(
                                NFieldByName('FRNADR').AsString,
                                IdVille,
                                '',
                                '',
                                '',
                                '',
                                ''
                               );
        // Création du fournisseur
        IdFournisseur := SetFournisseur(
                        0,
                        NFieldByName('FRNNOM').AsString,
                        IdAdr,
                        '',
                        '',
                        '',
                        0,
                        0,
                        '',
                        NFieldByName('FRNCODE').AsString,
                        '',
                        0
                      );

        // création du détails fournisseur par défault
        SetFournisseurDetails(IdFournisseur,0,'','',0,0,0,0,'',0);

        CDataSet.Edit;
        CDataSet.FieldByName('FOU_ID').AsInteger := IdFournisseur;
        CDataSet.Post;
        inc(ListTbHF.iCptFournisseur);
      end; // if
    end; // if
  Except
    raise;
  end; // with
  
  Result := IdFournisseur;
end;

function TDM_Main.CreateGenre(ListTbHF: TListTableHF; CodeGroupe: String): Integer;
var
  TbJoinCritere ,
  TbCritere     : TTableHF;
  IdGenre       : integer;
begin
  TbJoinCritere := ListTbHF.GetTable('JOINMOD_GENRE');
  TbCritere     := ListTbHF.GetTable('GENRE');

  if TbJoinCritere = nil then
    raise Exception.Create('Table de jointure genre non trouvée');

  if TbCritere = nil then
    raise Exception.Create('Table Genre non trouvée');

  try
    IdGenre := 0;
    if TbJoinCritere.NLocate('GRPPK',CodeGroupe,[loCaseInsensitive]) then
    begin
      if TbCritere.NLocate('CRIPK',TbJoinCritere.NFieldByName('GRPCRIPK').AsString,[loCaseInsensitive]) then
      begin
        IdGenre := TbCritere.CDataSet.FieldByName('GRE_ID').AsInteger;
        if IdGenre = 0 then
        begin
          IdGenre := GetGenreId(0,TbCritere.NFieldByName('CRILIB').AsString,0);

          With TbCritere.CDataSet do
          begin
            Edit;
            FieldByName('GRE_ID').AsInteger := IdGenre;
            Post;
          end;
        end;
      end;
    end;
    Result := IdGenre;
  Except
    Raise;
  end;
end;

function TDM_Main.CreateTaille(ListTbHF: TListTableHF;IdArticle : Integer;CodeSize : String): TTailleId;
var
  TbTailleGF : TTableHF;
  TbTailleGTF : TTableHF;

  IdTailleGF   ,
  IdTailleGTF  ,
  IdTailleTrav : Integer;

begin
  TbTailleGF  := ListTbHF.GetTable('TAILLEGF');
  TbTailleGTF := ListTbHF.GetTable('TAILLEGTF');

  if (TbTailleGF = nil) then
    raise Exception.Create('Table TailleGF non trouvée');

  if (TbTailleGTF = nil) then
    raise Exception.Create('Table TailleGTF non trouvée');


  IdTailleGF   := 0;
  idTailleGTF  := 0;
  IdTailleTrav := 0;

  Try
    if TbTailleGF.NLocate('SIZEIDX',CodeSize,[loCaseInsensitive]) then
      if TbTailleGTF.NLocate('SIRACODEMAIN;SIRACODERANGE',VarArrayOf([TbTailleGF.NFieldByName('SIZECODEMAIN').AsString,TbTailleGF.NFieldByName('SIZECODERANGE').AsString]),[loCaseInsensitive]) then
      begin
        // Création/récupération de la Taille GTF
        idTailleGTF := GetTailleGTFId(0,TbTailleGTF.NFieldByName('SIRANOM').AsString,ListTbHF.IdTypeGT,0,0);

        // Création/ récupération des tailles
        IdTailleGF := GetTailleGFId(idTailleGTF,0,0,TbTailleGF.NFieldByName('SIZENOM').AsString,'',0,0);

        // Création de la rélation Taille/Article
        IdTailleTrav := SetTailleTrav(IdArticle,IdTailleGF);

        inc(ListTbHF.iCptTaille);
      end;
    Result.TGF_ID := IdTailleGF;
    Result.GTF_ID := idTailleGTF;
    Result.TTV_ID := IdTailleTrav;
  Except
    raise;
  End;
end;

function TDM_Main.CreateMarques(ListTbHF: TListTableHF;CodeMarque : String): Integer;
var
  TbMarque : TTableHF;
  IdMarque : Integer;
begin
  TbMarque := ListTbHF.GetTable('MARQUE');

  if TbMarque = nil then
    raise Exception.Create('Table marque non trouvé');

  With TbMarque do
  Try
    idMarque := 0;
    if NLocate('MRKCODE',CodeMarque,[loCaseInsensitive]) then
    begin
      // On récupère l'ID Marque Ginkoia dans le dataset
      idMarque := CDataSet.FieldByName('MRK_ID').AsInteger;
      if idMarque = 0 then
      begin
        // Si = 0, alors on le recherche dans la base ginkoia et s'il n'existe pas on le créé
        idMarque := GetMarqueId(0,NFieldByName('MRKNOM').AsString,'',NFieldByName('MRKCODE').AsString);
        // enregistrement de l'IDMarque dans le dataset
        CDataSet.Edit;
        CDataSet.FieldByName('MRK_ID').AsInteger := idMarque;
        CDataSet.Post;
        inc(ListTbHF.iCptMarque);
      end;
    end;
  Except
    Raise;
  end; // if
  Result := idMarque;
end;

function TDM_Main.DoTraitement(ListTbHF: TListTableHF): Boolean;
var
  TbArticleCDE   ,
  TbCouleurCDE   ,
  TbModeleCDE    ,
  TbCDE          ,
  TbCDEMAG       ,
  TbCDEMAGCAD    ,
  TbCDEAMC       : TTableHF;

  idMarque       ,
  idFournisseur  : Integer;
  IdGenre        ,
  IdArticle      ,
  IdArticleRef   ,
  IdTVA          ,
  IdCouleur      ,
  IdCBI          ,
  IdPrixVte      ,
  IdPrixAch      : Integer;

  IdTaille       : TTailleId;
  IdNomenclature : TNomenclature;

  sNomArticle    : String;
  iOldArt        : Integer;
  sOldMag        : String;
  fTVA           ,
  fPrixVente     ,
  fPrixAchat     : single;
  i : integer;

  ListCMD     : TListCommande;
  bAddTVA     : Boolean;
begin
  // ---- Traitement des tables ----
  AddToMemo(ListTbHF.Memo,' .1 - Création des modèles');

  ListTbHF.Lab.Caption := 'Génération des articles';

  TbArticleCDE   := ListTbHF.GetTable('ARTICLECDE');
  TbCouleurCDE   := ListTbHF.GetTable('COULEURCDE');
  TbModeleCDE    := ListTbHF.GetTable('MODELECDE');
  TbCDE          := ListTbHF.GetTable('COMMANDE');
  TbCDEMAG       := ListTbHF.GetTable('CMDMAG');
  TbCDEMAGCAD    := ListTbHF.GetTable('CMDMAGCAD');
  TbCDEAMC       := ListTbHF.GetTable('CMDAMC');

  if TbArticleCDE = nil then
    raise Exception.Create('Table COULEURCDE inexistante');
  if TbCouleurCDE = nil then
    raise Exception.Create('Table ARTICLECDE inexistante');
  if TbModeleCDE = nil then
    raise Exception.Create('Table MODELECDE inexistante');
  if TbCDE = nil then
    raise Exception.Create('Table COMMANDE inexistante');
  if TbCDEMAG = nil then
    raise Exception.Create('Table CMDMAG inexistante');
  if TbCDEMAGCAD = nil then
    raise Exception.Create('Table CMDMAGCAD inexistante');
  if TbCDEAMC = nil then
    raise Exception.Create('Table CMDAMC inexistante');

  IBOTransaction.StartTransaction;
  // ---------------------
  // Gestion des articles
  // ---------------------
  With TbArticleCDE do
  Try
    CDataSet.First;
    iOldArt := 0;
    i := 1;
    while not CDataSet.Eof do
    begin
      // Création/ récupération de l'ID Marque du modèle
      idMarque := CreateMarques(ListTbHF,NFieldByName('CDEMRKPCES').AsString);

      // Positionnement sur le modele correspondant à ArticleCDE
      if TbModeleCDE.NLocate('CDMMODCODE',NFieldByName('CDEMODCODE').AsString,[loCaseInsensitive]) then
      begin
        // Création/ Récupération de L'Id fournisseurs du modèle
        idFournisseur := CreateFournisseur(ListTbHF,TbModeleCDE.NFieldByName('CDMCODEFRN').AsString);

        SetMrkFour(idFournisseur,idMarque,0);

        // Création/ génération de la nomenclature du modèle
        IdNomenclature := CreateSsFamille(ListTbHF,TbModeleCDE.NFieldByName('CDMSGROUPE').AsString);
      end; // if Positionnement

      // récupération du genre
      IdGenre := 0;
      IdGenre := CreateGenre(ListTbHF,TbModeleCDE.NFieldByName('CDMSGROUPE').AsString);
      
      // Création de l'article
      IdArticle    := CDataSet.FieldByName('ART_ID').AsInteger;
      IdArticleRef := CDataSet.FieldByName('ARF_ID').AsInteger;
      if IdArticle = 0 then
      begin
          IdArticle := GetArticleId(
                                    0, //ART_IDREF: integer;
                                    TbModeleCDE.NFieldByName('CDMLIB').AsString, // ART_NOM: String;
                                    0, //  ART_ORIGINE: integer;
                                    '', // ART_DESCRIPTION: String;
                                    IdMarque, // ART_MRKID: integer;
                                    TbModeleCDE.NFieldByName('CDMMODCODE').AsString, //  ART_REFMRK: String;
                                    IdNomenclature.SSF_ID, // ART_SSFID,
                                    0, // ART_PUB,
                                    0, // ART_GTFID: integer;
                                    '', //  ART_SESSION: String;
                                    0, // ART_GREID: integer;
                                    '', // ART_THEME,
                                    '', // ART_GAMME,
                                    '', // ART_CODECENTRALE,
                                    '', // ART_TAILLES,
                                    '', // ART_POS,
                                    '', // ART_GAMPF,
                                    '', // ART_POINT,
                                    '', // ART_GAMPRODUIT: String;
                                    0, // ART_SUPPRIME,
                                    0, // ART_REFREMPLACE,
                                    ListTbHF.idGarId, // ART_GARID,
                                    0, // ART_CODEGS: integer;
                                    '', // ART_COMMENT1,
                                    '', // ART_COMMENT2,
                                    '', // ART_COMMENT3,
                                    '', // ART_COMMENT4,
                                    '', // ART_COMMENT5,
                                    '' // ART_CPTANA: String): Integer;
                                   );
          // récupération de la TVA de l'article
          fTVA := XmlStrToFloat(TbModeleCDE.NFieldByName('CDMTXTVA').AsString);
          IdTVA := GetTVAId(fTVA);
          // Si la TVA n'a pas été trouvée on prend celle sélectionner par défaut
          if IdTVA = 0 then
            IdTVA := ListTbHF.IdTVAID;
          IdArticleRef := GetArticleRefID(
                                           IdArticle, // ARF_ARTID,
                                           IdNomenclature.CAT_ID, // ARF_CATID,
                                           IdTVA, // ARF_TVAID,
                                           ListTbHF.IdTCTID, // ARF_TCTID,
                                           0, // ARF_ICLID1,
                                           0, // ARF_ICLID2,
                                           0, // ARF_ICLID3,
                                           0, // ARF_ICLID4,
                                           0, // ARF_ICLID5: Integer;
                                           Now, // ARF_CREE,
                                           Now, // ART_MODIF: TDateTime;
                                           0, // ARF_DIMENSION,
                                           0, // ARF_VIRTUEL,
                                           0, // ARF_SERVICE: Integer;
                                           0, // ARF_COEFT,
                                           0, // ARF_STOCKI: Single;
                                           0, // ARF_VTFRAC,
                                           0, // ARF_CDNMT: Integer;
                                           0, // ARF_CDNMTQTE: Single;
                                           '', // ARF_UNITE: String;
                                           0, // ARF_CDNMTOBLI,
                                           0, // ARF_GUELT: Integer;
                                           0, // ARF_CPFA: Single;
                                           0, // ARF_FIDELITE,
                                           0, // ARF_ARCHIVER: integer;
                                           0, // ARF_FIDPOINT: single;
                                           0, // ARF_FIDDEBUT,
                                           0, // ARF_FIDFIN: TDateTime;
                                           0, // ARF_DEPTAUX: single;
                                           0, // ART_CGTID: integer;
                                           0, // ART_GLTMONTANT,
                                           0, // ARF_GLTPXV,
                                           0, // ARF_GLTMARGE: Single;
                                           0, // ART_GLTDEBUT,
                                           0, // ARF_GLTFIN: TDateTime;
                                           0, // ARF_MAGORG,
                                           0, // ARF_CATALOG,
                                           0  // ARF_UC: integer
                                          );
        CDataSet.Edit;
        CDataSet.FieldByName('ART_ID').AsInteger := IdArticle;
        CDataSet.FieldByName('ARF_ID').AsInteger := IdArticleRef;
        CDataSet.Post;

        inc(ListTbHF.iCptArticle);
      end; // if

      // Création des couleurs
      IdCouleur := CreateCouleurs(ListTbHF,IdArticle,NFieldByName('CDEMODCODE').AsString,NFieldByName('CDEMRKPCES').AsString,NFieldByName('CDECODECOLPCES').AsString);
      if CDataSet.FieldByName('COU_ID').AsInteger = 0 then
      begin
        CDataSet.Edit;
        CDataSet.FieldByName('COU_ID').AsInteger := IdCouleur;
        CDataSet.Post;
      end;

      // Création des tailles
      IdTaille := CreateTaille(ListTbHF,IdArticle,NFieldByName('CDEIDXSIZE').AsString);
      CDataSet.Edit;
      CDataSet.FieldByName('TGF_ID').AsInteger := IdTaille.TGF_ID;
      CDataSet.FieldByName('GTF_ID').AsInteger := IdTaille.GTF_ID;
      CDataSet.FieldByName('TTV_ID').AsInteger := IdTaille.TTV_ID;
      CDataSet.Post;

      // création du CB fournisseur
      IdCBI := SetCBArticle(IdArticleRef,IdTaille.TGF_ID,IdCouleur,NFieldByName('CDEEANARTPCES').AsString,3,0,0,0);

      // création des tarifs de l'article
      // si l'ancien Idarticle et différent du nouveau Alors on créé un nouveau tarif par défaut.
      fPrixVente := XmlStrToFloat(NFieldByName('PX_VENTE_ART_PCES').AsString);
      fPrixAchat := XmlStrToFloat(NFieldByName('PX_ACHAT_ART_PCES').AsString);
      if iOldArt <> IdArticle then
      begin
        IdPrixVte := SetArtPrixVente(0,IdArticle,0,fPrixVente);

        IdPrixAch := SetArtPrixAchat(IdArticle,idFournisseur,0,fPrixAchat,0,0,0,0,0,0,0);
        iOldArt := IdArticle;
      end;
      // Création du tarifs pour la taille en cours de l'article
      IdPrixVte := SetArtPrixVente(0,IdArticle,IdTaille.TGF_ID,fPrixVente);
      IdPrixAch := SetArtPrixAchat(IdArticle,idFournisseur,IdTaille.TGF_ID,fPrixAchat,fPrixAchat,0,0,0,0,0,0);

      CDataSet.Next;
      ListTbHF.Progress.Position := i * 100 Div CDataSet.RecordCount;
      Application.ProcessMessages;
      inc(i);
    end; // while

  Except on E:Exception do
    begin
      IBOTransaction.Rollback;
      raise Exception.Create('Erreur de transfert des données : ' + E.Message);
    end;
  end; // with

  // ---------------------
  // Gestion des commandes
  // ---------------------
  // remise à 0 de la liste
  SetLength(ListCMD,0);

 // récupération des données des commandes
  With TbCDE do
  Try
    // Positionnemen sur la première commande
    CDataSet.First;
    while not CDataSet.Eof do
    begin
      SetLength(ListCMD,Length(ListCMD) + 1);
      With ListCMD[Length(ListCMD) -1] do
      begin
        CDE_NUMFOURN := NFieldByName('CDEID').AsString;
        CDE_COMENT   := CDE_COMENT + 'Libellé : ' + NFieldByName('CDELIB').AsString + #13#10;
        CDE_DATE     := XmlStrToDate(NFieldByName('CDEDATE').AsString);
        // Récupértation du code acheteur
        // A FAIRE
        // CDE_USRID := ;
      end;

      // positionnement sur le premier magasin de la commande
      if TbCDEMAG.NLocate('CMGIDCDE',NFieldByName('CDEID').AsString,[loCaseInsensitive]) then
      begin
        sOldMag := TbCDEMAG.NFieldByName('CMGCODEMAG').AsString;
        // récupération du n° de magasin
        // A FAIRE
        // ListCMD[Length(ListCMD) -1].CDE_MAGID := ;

        while not TbCDEMAG.CDataSet.EOF do
        begin
          // On ne traite que les magasins de la commande (on parcours tout au cas ou cela soit mélangé)
          if NFieldByName('CDEID').AsString = TbCDEMAG.NFieldByName('CMGIDCDE').AsString then
          begin
            // Positionnement sur  le premier CDE_MAG_CAD qui correspond a la commande
            if TbCDEMAGCAD.NLocate('CMCIDCDE;CMCMAGIDCDE',VarArrayOf([NFieldByName('CDEID').AsString,TbCDEMAG.NFieldByName('CMGMAGIDCDE').AsString]),[loCaseInsensitive]) then
            begin
              while not TbCDEMAGCAD.CDataSet.Eof do
              begin
                if NFieldByName('CDEID').AsString = TbCDEMAGCAD.NFieldByName('CMCIDCDE').AsString then
                  if TbCDEMAG.NFieldByName('CMGMAGIDCDE').AsString = TbCDEMAGCAD.NFieldByName('CMCMAGIDCDE').AsString then
                  begin
                    // Positionnement sur le Premier CDE_ART_MAG_CAD.
                    if TbCDEAMC.NLocate('AMCCDEID;AMCMAGCDEID',VarArrayof([NFieldByName('CDEID').AsString,TbCDEMAGCAD.NFieldByName('CMCMAGADIDCDE').AsString]),[loCaseInsensitive]) then
                    begin
                      while not TbCDEAMC.CDataSet.Eof do
                      begin
                        if TbCDEAMC.NFieldByName('AMCCDEID').AsString = NFieldByName('CDEID').AsString then
                          if TbCDEAMC.NFieldByName('AMCMAGCDEID').AsString = TbCDEMAGCAD.NFieldByName('CMCMAGADIDCDE').AsString then
                          begin
                            // Début du traitement des lignes de la commande
                            SetLength(ListCMD[Length(ListCMD) -1].Lignes,Length(ListCMD[Length(ListCMD) -1].Lignes) + 1);
                            // Positionner la table CDE_ART et CDE_MOD pour récupérer certaines informations
                            if TbArticleCDE.NLocate('CDEARTCODE;CDEMODCODE;CDEMRKPCES;CDECODECOLPCES',
                                                    VarArrayof([
                                                                TbCDEAMC.NFieldByName('AMCARTCODE').AsString,
                                                                TbCDEAMC.NFieldByName('AMCMODCODE').AsString,
                                                                TbCDEAMC.NFieldByName('AMCMRKCODE').AsString,
                                                                TbCDEAMC.NFieldByName('AMCCOLCODE').AsString
                                                               ]),[loCaseInsensitive])
                            then
                            begin
                              if TbModeleCDE.NLocate('CDMMODCODE',TbArticleCDE.NFieldByName('CDEMODCODE').AsString,[loCaseInsensitive]) then
                              begin
                                bAddTVA := False;
                                With ListCMD[Length(ListCMD) -1] do
                                begin
                                  // données de l'article
                                  With Lignes[Length(Lignes) -1] do
                                  begin
                                    CDL_CDEID     := 0;
                                    CDL_ARTID     := TbArticleCDE.CDataSet.FieldByName('ART_ID').AsInteger;
                                    CDL_TGFID     := TbArticleCDE.CDataSet.FieldByName('TGF_ID').AsInteger;
                                    CDL_COUID     := TbArticleCDE.CDataSet.FieldByName('COU_ID').AsInteger;
                                    CDL_QTE       := TbArticleCDE.NFieldByName('CDEARTQTE').AsInteger;
                                    CDL_PXACHAT   := XmlStrToFloat(TbArticleCDE.NFieldByName('CDEPXACHPCES').AsString);
                                    CDL_TVA       := XmlStrToFloat(TbModeleCDE.NFieldByName('CDMTXTVA').AsString);
                                    CDL_PXVENTE   := XmlStrToFloat(TbArticleCDE.NFieldByName('CDEPXVTEPCES').AsString);
                                    CDL_LIVRAISON := XmlStrToDate(TbCDEMAGCAD.NFieldByName('CMCDTAMAG').AsString);
                                  end; // with

                                  // traitement des données TVA
                                  if Length(TVALignes) = 0 then
                                    bAddTVA := True
                                  else begin
                                    bAddTVA := True;
                                    for i  := Low(TVALignes) to High(TVALignes) do
                                    begin
                                      if TVALignes[i].CDE_TVATAUX = Lignes[Length(Lignes) -1].CDL_TVA then
                                      begin
                                        bAddTVA := False;
                                        With TVALignes[i] do
                                        begin
                                          CDE_TVAHT := CDE_TVAHT + Lignes[Length(Lignes)-1].CDL_PXACHAT;
                                          CDE_TVA   := CDE_TVA + (Lignes[Length(Lignes)-1].CDL_PXACHAT * Lignes[Length(Lignes)-1].CDL_TVA / 100);
                                        end;
                                      end;
                                    end;
                                  end;

                                  if bAddTVA then
                                  begin
                                    SetLength(TVALignes,Length(TVALignes) + 1);
                                    With TVALignes[Length(TVALignes) -1] do
                                    begin
                                      CDE_TVAHT := Lignes[Length(Lignes )-1].CDL_PXACHAT;
                                      CDE_TVA   := (Lignes[Length(Lignes)-1].CDL_PXACHAT * Lignes[Length(Lignes)-1].CDL_TVA / 100);
                                      CDE_TVATAUX := Lignes[Length(Lignes)-1].CDL_TVA;
                                    end;
                                  end; // bAddTVA
                                end; // with
                              end; //if TbModeleCDE
                            end; //if TbArticleCDE

                          end; // if TbCDEAMC
                        TbCDEAMC.CDataSet.Next;
                      end; // while
                    end; // if TbCDEAMC

                  end; //if TbCDEMAG

                TbCDEMAGCAD.CDataSet.Next;
              end; // while
            end; // if TbCDEMAGCAD

          end; // if
          TbCDEMAG.CDataSet.Next;
        end; // while
        


      end;

      CDataSet.Next;
    end;
  Except on E:Exception do
    begin
      IBOTransaction.Rollback;
      raise Exception.Create('Erreur lors de la génération des commandes : ' + E.Message);
    end;
  end; // with
  
  // si tout ce passe  bien on valide l'intégralité des données
  IBOTransaction.Commit;

end;

function TDM_Main.GetAdresseId(ADR_LIGNE: String; ADR_VILID: Integer; ADR_TEL,
  ADR_FAX, ADR_GSM, ADR_EMAIL, ADR_COMMENT: String): Integer;
var
  iAdrId : integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from GENADRESSE');
      SQL.Add(' join k on k_id = ADR_ID and k_enabled = 1');
      SQL.Add('Where ADR_LIGNE = :PADRLIGNE');
      SQL.Add('  and ADR_VILID = :PADRVILID');
      ParamCheck := True;
      ParamByName('PADRLIGNE').AsString  := UpperCase(ADR_LIGNE);
      ParamByName('PADRVILID').AsInteger := ADR_VILID;
      Open;

      if Recordcount <= 0 then
      begin
        iAdrId := GetNewKId('GENADRESSE');
        Close;
        SQL.Clear;
        SQL.Add('Insert into GENADRESSE');
        SQL.Add('(ADR_ID,ADR_LIGNE,ADR_VILID,ADR_TEL,ADR_FAX,ADR_GSM,ADR_EMAIL,ADR_COMMENT)');
        SQL.Add('Values(:PADRID,:PADRLIGNE,:PADRVILID,:PADRTEL,:PADRFAX,:PADRGSM,:PADREMAIL,:PADRCOMMENT)');
        ParamCheck := True;
        ParamByName('PADRID').AsInteger     := iAdrId;
        ParamByName('PADRLIGNE').AsString   := UpperCase(ADR_LIGNE);
        ParamByName('PADRVILID').AsInteger  := ADR_VILID;
        ParamByName('PADRTEL').AsString     := ADR_TEL;
        ParamByName('PADRFAX').AsString     := ADR_FAX;
        ParamByName('PADRGSM').AsString     := ADR_GSM;
        ParamByName('PADREMAIL').AsString   := ADR_EMAIL;
        ParamByName('PADRCOMMENT').AsString := ADR_COMMENT;
        ExecSQL;
      end else
        iAdrId := FieldByName('ADR_ID').AsInteger;

      Result := iAdrId;
    end;
  except
    raise;
  End;
end;

function TDM_Main.GetArticleId(ART_IDREF: integer; ART_NOM: String;
  ART_ORIGINE: integer; ART_DESCRIPTION: String; ART_MRKID: integer;
  ART_REFMRK: String; ART_SSFID, ART_PUB, ART_GTFID: integer;
  ART_SESSION: String; ART_GREID: integer; ART_THEME, ART_GAMME,
  ART_CODECENTRALE, ART_TAILLES, ART_POS, ART_GAMPF, ART_POINT,
  ART_GAMPRODUIT: String; ART_SUPPRIME, ART_REFREMPLACE, ART_GARID,
  ART_CODEGS: integer; ART_COMENT1, ART_COMENT2, ART_COMENT3, ART_COMENT4,
  ART_COMENT5, ART_CPTANA: String): Integer;
var
  iART_ID : Integer;
begin
  With Que_TmpEvent do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from ARTARTICLE');
    SQL.Add('  join k on k_id = ART_ID and k_enabled = 1');
    SQL.Add('Where ART_NOM = :PARTNOM');
    ParamCheck := True;
    ParamByName('PARTNOM').AsString := UpperCase(ART_NOM);
    Open;

    if Recordcount <= 0 then
    begin
      iART_ID := GetNewKId('ARTARTICLE');

      Close;
      SQL.Clear;
      SQL.Add('Insert into ARTARTICLE');
      SQL.Add('(ART_ID,ART_IDREF,ART_NOM,ART_ORIGINE,ART_DESCRIPTION,ART_MRKID,ART_REFMRK,ART_SSFID,');
      SQL.Add('ART_PUB,ART_GTFID,ART_GTFID,ART_SESSION,ART_GREID,ART_THEME,ART_GAMME,ART_CODECENTRALE,');
      SQL.Add('ART_TAILLES,ART_POS,ART_GAMPF,ART_POINT,ART_GAMPRODUIT,ART_SUPPRIME,ART_REFREMPLACE,ART_GARID,');
      SQL.Add('ART_CODEGS,ART_COMENT1,ART_COMENT2,ART_COMENT3,ART_COMENT4,ART_COMENT5,ART_CPTANA)');
      SQL.Add('Values(:PARTID,:PARTIDREF,:PARTNOM,:PARTORIGINE,:PARTDESCRIPTION,:PARTMRKID,:PARTREFMRK,:PARTSSFID,');
      SQL.Add(':PARTPUB,:PARTGTFID,:PARTGTFID,:PARTSESSION,:PARTGREID,:PARTTHEME,:PARTGAMME,:PARTCODECENTRALE,');
      SQL.Add(':PARTTAILLES,:PARTPOS,:PARTGAMPF,:PARTPOINT,:PARTGAMPRODUIT,:PARTSUPPRIME,:PARTREFREMPLACE,:PARTGARID,');
      SQL.Add(':PARTCODEGS,:PARTCOMENT1,:PARTCOMENT2,:PARTCOMENT3,:PARTCOMENT4,:PARTCOMENT5,:PARTCPTANA)');
      ParamCheck := True;
      ParamByName('PARTID').AsInteger          := iART_ID;
      ParamByName('PARTIDREF').AsInteger       := ART_IDREF;
      ParamByName('PARTNOM').AsString          := UpperCase(ART_NOM);
      ParamByName('PARTORIGINE').AsInteger     := ART_ORIGINE;
      ParamByName('PARTDESCRIPTION').AsString  := ART_DESCRIPTION;
      ParamByName('PARTMRKID').AsInteger       := ART_MRKID;
      ParamByName('PARTREFMRK').AsString       := ART_REFMRK;
      ParamByName('PARTSSFID').AsInteger       := ART_SSFID;
      ParamByName('PARTPUB').AsInteger         := ART_PUB;
      ParamByName('PARTGTFID').AsInteger       := ART_GTFID;
      ParamByName('PARTSESSION').AsString      := ART_SESSION;
      ParamByName('PARTGREID').AsInteger       := ART_GREID;
      ParamByName('PARTTHEME').AsString        := ART_THEME;
      ParamByName('PARTGAMME').AsString        := ART_GAMME;
      ParamByName('PARTCODECENTRALE').AsString := ART_CODECENTRALE;
      ParamByName('PARTTAILLES').AsString      := ART_TAILLES;
      ParamByName('PARTPOS').AsString          := ART_POS;
      ParamByName('PARTGAMPF').AsString        := ART_GAMPF;
      ParamByName('PARTPOINT').AsString        := ART_POINT;
      ParamByName('PARTGAMPRODUIT').AsString   := ART_GAMPRODUIT;
      ParamByName('PARTSUPPRIME').AsInteger    := ART_SUPPRIME;
      ParamByName('PARTREFREMPLACE').AsInteger := ART_REFREMPLACE;
      ParamByName('PARTGARID').AsInteger       := ART_GARID;
      ParamByName('PARTCODEGS').AsInteger      := ART_CODEGS;
      ParamByName('PARTCOMENT1').AsString     := ART_COMENT1;
      ParamByName('PARTCOMENT2').AsString     := ART_COMENT2;
      ParamByName('PARTCOMENT3').AsString     := ART_COMENT3;
      ParamByName('PARTCOMENT4').AsString     := ART_COMENT4;
      ParamByName('PARTCOMENT5').AsString     := ART_COMENT5;
      ParamByName('PARTCPTANA').AsString      := ART_CPTANA;
      ExecSQL;
    end
    else
      iART_ID := FieldByName('ART_ID').AsInteger;

    Result := iART_ID;
  Except
    Raise;
  end;
end;

function TDM_Main.GetArticleRefID(ARF_ARTID, ARF_CATID, ARF_TVAID, ARF_TCTID,
  ARF_ICLID1, ARF_ICLID2, ARF_ICLID3, ARF_ICLID4, ARF_ICLID5: Integer; ARF_CREE,
  ARF_MODIF: TDateTime; ARF_DIMENSION, ARF_VIRTUEL,
  ARF_SERVICE: Integer; ARF_COEFT, ARF_STOCKI: Single; ARF_VTFRAC,
  ARF_CDNMT: Integer; ARF_CDNMTQTE: Single; ARF_UNITE: String; ARF_CDNMTOBLI,
  ARF_GUELT: Integer; ARF_CPFA: Single; ARF_FIDELITE, ARF_ARCHIVER: integer;
  ARF_FIDPOINT: single; ARF_FIDDEBUT, ARF_FIDFIN: TDateTime;
  ARF_DEPTAUX: single; ARF_CGTID: integer; ARF_GLTMONTANT, ARF_GLTPXV,
  ARF_GLTMARGE: Single; ARF_GLTDEBUT, ARF_GLTFIN: TDateTime; ARF_MAGORG,
  ARF_CATALOG, ARF_UC: integer): Integer;
var
  iARF_ID : Integer;
begin
  With Que_TmpEvent do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from ARTREFERENCE');
    SQL.Add(' join k on k_id = ARF_ID and k_enabled = 1');
    SQL.Add('Where ARF_ARTID = :PARFARTID');
    ParamCheck := True;
    ParamByName('PARFARTID').AsInteger := ARF_ARTID;
    Open;

    if Recordcount <= 0 then
    begin
      iARF_ID := GetNewKId('ARTREFERENCE');

      Close;
      SQL.Clear;
      SQL.Add('Insert into ARTREFERENCE');
      SQL.Add('(ARF_ID,ARF_ARTID,ARF_CATID,ARF_TVAID,ARF_TCTID,ARF_ICLID1,ARF_ICLID2,ARF_ICLID3,');
      SQL.Add('ARF_ICLID4,ARF_ICLID5,ARF_CREE,ARF_MODIF,ARF_CHRONO,ARF_DIMENSION,ARF_VIRTUEL,');
      SQL.Add('ARF_SERVICE,ARF_COEFT,ARF_STOCKI,ARF_VTFRAC,ARF_CDNMT,ARF_CDNMTQTE,ARF_UNITE,');
      SQL.Add('ARF_CDNMTOBLI,ARF_GUELT,ARF_CPFA,ARF_FIDELITE,ARF_ARCHIVER,ARF_FIDPOINT,ARF_FIDDEBUT,ARF_FIDFIN,');
      SQL.Add('ARF_DEPTAUX,ARF_CGTID,ARF_GLTMONTANT,ARF_GLTPXV,ARF_GLTMARGE,ARF_GLTDEBUT,ARF_GLTFIN,');
      SQL.Add('ARF_MAGORG,ARF_CATALOG,ARF_UC)');
      SQL.Add('Values(:PARFID,:PARFARTID,:PARFCATID,:PARFTVAID,:PARFTCTID,:PARFICLID1,:PARFICLID2,:PARFICLID3,');
      SQL.Add(':PARFICLID4,:PARFICLID5,:PARFCREE,:PARFMODIF,:PARFCHRONO,:PARFDIMENSION,:PARFVIRTUEL,');
      SQL.Add(':PARFSERVICE,:PARFCOEFT,:PARFSTOCKI,:PARFVTFRAC,:PARFCDNMT,:PARFCDNMTQTE,:PARFUNITE,');
      SQL.Add(':PARFCDNMTOBLI,:PARFGUELT,:PARFCPFA,:PARFFIDELITE,:PARFARCHIVER,:PARFFIDPOINT,:PARFFIDDEBUT,:PARFFIDFIN,');
      SQL.Add(':PARFDEPTAUX,:PARFCGTID,:PARFGLTMONTANT,:PARFGLTPXV,:PARFGLTMARGE,:PARFGLTDEBUT,:PARFGLTFIN,');
      SQL.Add(':PARFMAGORG,:PARFCATALOG,:PARFUC)');
      ParamCheck := True;
      ParamByName('PARFID').AsInteger        := iARF_ID;
      ParamByName('PARFARTID').AsInteger     := ARF_ARTID;
      ParamByName('PARFCATID').AsInteger     := ARF_CATID;
      ParamByName('PARFTVAID').AsInteger     := ARF_TVAID;
      ParamByName('PARFTCTID').AsInteger     := ARF_TCTID;
      ParamByName('PARFICLID1').AsInteger    := ARF_ICLID1;
      ParamByName('PARFICLID2').AsInteger    := ARF_ICLID2;
      ParamByName('PARFICLID3').AsInteger    := ARF_ICLID3;
      ParamByName('PARFICLID4').AsInteger    := ARF_ICLID4;
      ParamByName('PARFICLID5').AsInteger    := ARF_ICLID5;
      ParamByName('PARFCREE').AsDate         := ARF_CREE;
      ParamByName('PARFMODIF').AsDate        := ARF_MODIF;
      ParamByName('PARFCHRONO').AsString     := GetChronoArticle;
      ParamByName('PARFDIMENSION').AsInteger := ARF_DIMENSION;
      ParamByName('PARFVIRTUEL').AsInteger   := ARF_VIRTUEL;
      ParamByName('PARFSERVICE').AsInteger   := ARF_SERVICE;
      ParamByName('PARFCOEFT').AsFloat       := ARF_COEFT;
      ParamByName('PARFSTOCKI').AsFloat      := ARF_STOCKI;
      ParamByName('PARFVTFRAC').AsInteger    := ARF_VTFRAC;
      ParamByName('PARFCDNMT').AsInteger     := ARF_CDNMT;
      ParamByName('PARFCDNMTQTE').AsFloat    := ARF_CDNMTQTE;
      ParamByName('PARFUNITE').AsString      := ARF_UNITE;
      ParamByName('PARFCDNMTOBLI').AsInteger := ARF_CDNMTOBLI;
      ParamByName('PARFGUELT').AsInteger     := ARF_GUELT;
      ParamByName('PARFCPFA').AsFloat        := ARF_CPFA;
      ParamByName('PARFFIDELITE').AsInteger  := ARF_FIDELITE;
      ParamByName('PARFARCHIVER').AsInteger  := ARF_ARCHIVER;
      ParamByName('PARFFIDPOINT').AsFloat    := ARF_FIDPOINT;
      ParamByName('PARFFIDDEBUT').AsDate     := ARF_FIDDEBUT;
      ParamByName('PARFFIDFIN').AsDate       := ARF_FIDFIN;
      ParamByName('PARFDEPTAUX').AsFloat     := ARF_DEPTAUX;
      ParamByName('PARFCGTID').AsInteger     := ARF_CGTID;
      ParamByName('PARFGLTMONTANT').AsFloat  := ARF_GLTMONTANT;
      ParamByName('PARFGLTPXV').AsFloat      := ARF_GLTPXV;
      ParamByName('PARFGLTMARGE').AsFloat    := ARF_GLTMARGE;
      ParamByName('PARFGLTDEBUT').AsDate     := ARF_GLTDEBUT;
      ParamByName('PARFGLTFIN').AsDate       := ARF_GLTFIN;
      ParamByName('PARFMAGORG').AsInteger    := ARF_MAGORG;
      ParamByName('PARFCATALOG').AsInteger   := ARF_CATALOG;
      ParamByName('PARFUC').AsInteger        := ARF_UC;
      ExecSQL;
    end else
     iARF_ID := FieldByName('ARF_ID').AsInteger;

    Result := iARF_ID;
  Except
    Raise;
  end;
end;

function TDM_Main.GetCategorieID(CTF_NOM: String; CTF_UNIID: integer): Integer;
var
  iCTFId : Integer;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from NKLCATFAMILLE');
      SQL.Add(' join k on K_ID = CTF_ID and k_enabled = 1');
      SQL.Add('Where CTF_NOM = :PCTFNOM');
      SQL.Add('  and CTF_UNIID = :PUNIID');
      ParamCheck := True;
      ParamByName('PCTFNOM').AsString := UpperCase(CTF_NOM);
      ParamByName('PUNIID').AsInteger := CTF_UNIID;
      Open;

      if RecordCount = 0 then
      begin
        iCTFId := GetNewKId('NKLCATFAMILLE');
        Close;
        SQL.Clear;
        SQL.Add('Insert into NKLCATFAMILLE');
        SQL.Add('(CTF_ID,CTF_NOM,CTF_UNIID)');
        SQL.Add('Values(:PCTFID,:PCTFNOM,:PUNIID)');
        ParamCheck := True;
        ParamByName('PCTFID').AsInteger := iCTFId;
        ParamByName('PCTFNOM').AsString := UpperCase(CTF_NOM);
        ParamByName('PUNIID').AsInteger := CTF_UNIID;
        ExecSQL;
      end else
        iCTFId := FieldByName('CTF_ID').AsInteger;
      Result := iCTFId; 
    end;
  except
    raise;
  end;
end;

function TDM_Main.GetChronoArticle: String;
begin
  With Que_ChronoArticle do
  begin
    Close;
    Open;

    Result := FieldByName('NewNum').AsString;
  end;  
end;

function TDM_Main.GetCommandeId(CDE_NUMERO: String; CDE_SAISON, CDE_EXEID,
  CDE_CPAID, CDE_MAGID, CDE_FOUID: Integer; CDE_NUMFOURN: String;
  CDE_DATE: TDateTime; CDE_REMISE, CDE_TVAHT1, CDE_TVATAUX1, CDE_TVA1,
  CDE_TVAHT2, CDE_TVATAUX2, CDE_TVA2, CDE_TVAHT3, CDE_TVATAUX3, CDE_TVA3,
  CDE_TVAHT4, CDE_TVATAUX4, CDE_TVA4, CDE_TVAHT5, CDE_TVATAUX5,
  CDE_TVA5: single; CDE_FRANCO, CDE_MODIF: Integer; CDE_LIVRAISON: TDateTime;
  CDE_OFFSET: integer; CDE_REMGLO: single; CDE_ARCHIVE: integer;
  CDE_REGLEMENT: TDateTime; CDE_TYPID, CDE_NOTVA, CDE_USRID: integer;
  CDE_COMENT: String; CDE_COLID: integer): Integer;
var
  iCDEId : Integer;
begin

  With Que_TmpEvent do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from COMBCDE');
    SQL.Add(' join k on K_ID = CDE_ID and k_enabled = 1');
    SQL.Add('Where CDE_NUMERO = :PCDENUMERO');
    SQL.Add('  and CDE_EXEID  = :PEXEID');
    SQL.Add('  and CDE_MAGID  = :PMAGID');
    ParamCheck := True;
    ParamByName('PCDENUMERO').AsString := CDE_NUMERO;
    ParamByName('PEXEID').AsInteger    := CDE_EXEID;
    ParamByName('PMAGID').AsInteger    := CDE_MAGID;
    Open;

    if RecordCount <= 0 then
    begin
      iCDEId := GetNewKId('COMBCDE');

      Close;
      SQL.Clear;
      SQL.Add('Insert into COMBCDE');
      SQL.Add('(CDE_ID,CDE_NUMERO,CDE_SAISON,CDE_EXEID,CDE_CPAID,CDE_MAGID,CDE_FOUID,');
      SQL.Add('CDE_NUMFOURN, CDE_DATE,CDE_REMISE, CDE_TVAHT1, CDE_TVATAUX1, CDE_TVA1,');
      SQL.Add('CDE_TVAHT2, CDE_TVATAUX2, CDE_TVA2, CDE_TVAHT3, CDE_TVATAUX3, CDE_TVA3,');
      SQL.Add('CDE_TVAHT4, CDE_TVATAUX4, CDE_TVA4, CDE_TVAHT5, CDE_TVATAUX5,');
      SQL.Add('CDE_TVA5,CDE_FRANCO,CDE_MODIF,CDE_LIVRAISON,CDE_OFFSET,CDE_REMGLO,CDE_ARCHIVE,');
      SQL.Add('CDE_REGLEMENT,CDE_TYPID, CDE_NOTVA, CDE_USRID,CDE_COMENT,CDE_COLID)');
      SQL.Add('Values(:PCDEID,:PCDENUMERO,:PCDESAISON,:PCDEEXEID,:PCDECPAID,:PCDEMAGID,:PCDEFOUID,');
      SQL.Add(':PCDENUMFOURN,:PCDEDATE,:PCDEREMISE,:PCDETVAHT1,:PCDETVATAUX1,:PCDETVA1,');
      SQL.Add(':PCDETVAHT2,:PCDETVATAUX2,:PCDETVA2,:PCDETVAHT3,:PCDETVATAUX3,:PCDETVA3,');
      SQL.Add(':PCDETVAHT4,:PCDETVATAUX4,:PCDETVA4,:PCDETVAHT5,:PCDETVATAUX5,');
      SQL.Add(':PCDETVA5,:PCDEFRANCO,:PCDEMODIF,:PCDELIVRAISON,:PCDEOFFSET,:PCDEREMGLO,:PCDEARCHIVE,');
      SQL.Add(':PCDEREGLEMENT,:PCDETYPID,:PCDENOTVA,:PCDEUSRID,:PCDECOMENT,:PCDECOLID)');
      ParamCheck := True;
      ParamByName('CDE_ID').AsInteger      := iCDEId;
      ParamByName('PCDENUMERO').AsString   := CDE_NUMERO;
      ParamByName('PCDESAISON').AsInteger  := CDE_SAISON;
      ParamByName('PCDEEXEID').AsInteger   := CDE_EXEID;
      ParamByName('PCDECPAID').AsInteger   := CDE_CPAID;
      ParamByName('PCDEMAGID').AsInteger   := CDE_MAGID;
      ParamByName('PCDEFOUID').AsInteger   := CDE_FOUID;
      ParamByName('PCDENUMFOURN').AsString := CDE_NUMFOURN;
      ParamByName('PCDEDATE').AsDate       := CDE_DATE;
      ParamByName('PCDEREMISE').AsFloat    := CDE_REMISE;
      ParamByName('PCDETVAHT1').AsFloat    := CDE_TVAHT1;
      ParamByName('PCDETVATAUX1').AsFloat  := CDE_TVATAUX1;
      ParamByName('PCDETVA1').AsFloat      := CDE_TVA1;
      ParamByName('PCDETVAHT1').AsFloat    := CDE_TVAHT2;
      ParamByName('PCDETVATAUX1').AsFloat  := CDE_TVATAUX2;
      ParamByName('PCDETVA1').AsFloat      := CDE_TVA2;
      ParamByName('PCDETVAHT1').AsFloat    := CDE_TVAHT3;
      ParamByName('PCDETVATAUX1').AsFloat  := CDE_TVATAUX3;
      ParamByName('PCDETVA1').AsFloat      := CDE_TVA3;
      ParamByName('PCDETVAHT1').AsFloat    := CDE_TVAHT4;
      ParamByName('PCDETVATAUX1').AsFloat  := CDE_TVATAUX4;
      ParamByName('PCDETVA1').AsFloat      := CDE_TVA4;
      ParamByName('PCDETVAHT1').AsFloat    := CDE_TVAHT5;
      ParamByName('PCDETVATAUX1').AsFloat  := CDE_TVATAUX5;
      ParamByName('PCDETVA1').AsFloat      := CDE_TVA5;
      ParamByName('PCDEFRANCO').AsInteger  := CDE_FRANCO;
      ParamByName('PCDEMODIF').AsInteger   := CDE_MODIF;
      ParamByName('PCDELIVRAISON').AsDate  := CDE_LIVRAISON;
      ParamByName('PCDEOFFSET').AsInteger  := CDE_OFFSET;
      ParamByName('PCDEREMGLO').AsFloat    := CDE_REMGLO;
      ParamByName('PCDEARCHIVE').AsInteger := CDE_ARCHIVE;
      ParamByName('PCDEREGLEMENT').AsDate  := CDE_REGLEMENT;
      ParamByName('PCDETYPID').AsInteger   := CDE_TYPID;
      ParamByName('PCDENOTVA').AsInteger   := CDE_NOTVA;
      ParamByName('PCDEUSRID').AsInteger   := CDE_USRID;
      ParamByName('PCDECOMENT').AsString   := CDE_COMENT;
      ParamByName('PCDECOLID').AsInteger   := CDE_COLID;
      ExecSQL;
    end else
      iCDEId := FieldByName('CDE_ID').AsInteger;

    Result := iCDEId;
  Except
    raise;
  end;
end;

function TDM_Main.GetCommandeLigneId(CDL_CDEID, CDL_ARTID, CDL_TGFID,
  CDL_COUID: integer; CDL_QTE, CDL_PXCTLG, CDL_REMISE1, CDL_REMISE2,
  CDL_REMISE3, CDL_PXACHAT, CDL_TVA, CDL_PXVENTE: single; CDL_OFFSET: integer;
  CDL_LIVRAISON: TDateTime; CDL_TARTAILLE: integer;
  CDL_VALREMGLO: single): Integer;
var
  iCDLId : integer;
begin
  With Que_TmpEvent do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from COMBCDEL');
    SQL.Add(' join K on K_ID = CDL_ID and k_enabled = 1');
    SQL.Add('Where CDL_CDEID = :PCDEID');
    SQL.Add('  and CDL_ARTID = :PARTID');
    SQL.Add('  and CDL_TGFID = :PTGFID');
    SQL.Add('  and CDL_COUID = :PCOUID');
    ParamCheck := True;
    ParamByName('PCDEID').AsInteger := CDL_CDEID;
    ParamByName('PARTID').AsInteger := CDL_ARTID;
    ParamByName('PTGFID').AsInteger := CDL_TGFID;
    ParamByName('PCOUID').AsInteger := CDL_COUID;
    Open;

    if Recordcount <= 0 then
    begin
      iCDLId := GetNewKId('COMBCDEL');
      Close;
      SQL.Clear;
      SQL.Add('insert into COMBCDEL');
      SQL.Add('(CDL_ID,CDL_CDEID, CDL_ARTID, CDL_TGFID,CDL_COUID,CDL_QTE,CDL_PXCTLG,CDL_REMISE1,');
      SQL.Add('CDL_REMISE2,CDL_REMISE3,CDL_PXACHAT,CDL_TVA,CDL_PXVENTE,CDL_OFFSET,');
      SQL.Add('CDL_LIVRAISON,CDL_TARTAILLE,CDL_VALREMGLO)');
      SQL.Add('Values(:PCDLID,:PCDLCDEID,:PCDLARTID,:PCDLTGFID,:PCDLCOUID,:PCDLQTE,:PCDLPXCTLG,:PCDLREMISE1,');
      SQL.Add(':PCDLREMISE2,:PCDLREMISE3,:PCDLPXACHAT,:PCDLTVA,:PCDLPXVENTE,:PCDLOFFSET,');
      SQL.Add(':PCDLLIVRAISON,:PCDLTARTAILLE,:PCDLVALREMGLO)');
      ParamCheck := True;
      ParamByName(':PCDLID').AsInteger       := iCDLId;
      ParamByName('PCDLCDEID').AsInteger     := CDL_CDEID;
      ParamByName('PCDLARTID').AsInteger     := CDL_ARTID;
      ParamByName('PCDLTGFID').AsInteger     := CDL_TGFID;
      ParamByName('PCDLCOUID').AsInteger     := CDL_COUID;
      ParamByName('PCDLQTE').AsFloat         := CDL_QTE;
      ParamByName('PCDLPXCTLG').AsFloat      := CDL_PXCTLG;
      ParamByName('PCDLREMISE1').AsFloat     := CDL_REMISE1;
      ParamByName('PCDLREMISE2').AsFloat     := CDL_REMISE2;
      ParamByName('PCDLREMISE3').AsFloat     := CDL_REMISE3;
      ParamByName('PCDLPXACHAT').AsFloat     := CDL_PXACHAT;
      ParamByName('PCDLTVA').AsFloat         := CDL_TVA;
      ParamByName('PCDLPXVENTE').AsFloat     := CDL_PXVENTE;
      ParamByName('PCDLOFFSET').AsInteger    := CDL_OFFSET;
      ParamByName('PCDLLIVRAISON').AsDate    := CDL_LIVRAISON;
      ParamByName('PCDLTARTAILLE').AsInteger := CDL_TARTAILLE;
      ParamByName('PCDLVALREMGLO').AsFloat   := CDL_VALREMGLO;
      ExecSQL;
    end else
      iCDLId := FieldByName('CDL_ID').AsInteger;

    Result := iCDLId;
  Except
    Raise;
  end;
end;

function TDM_Main.GetCouleurId(COU_ARTID, COU_IDREF, COU_GCSID: Integer;
  COU_CODE, COU_NOM: String): Integer;
var
  iCOUId : Integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from PLXCOULEUR');
      SQL.Add(' join k on k_id = COU_ID and k_enabled = 1');
      SQL.Add('Where COU_ARTID = :PCOUARTID');
      SQL.Add('  and COU_NOM   = :PCOUNOM');
      ParamCheck := True;
      ParamByName('PCOUARTID').AsInteger := COU_ARTID;
      ParamByName('PCOUNOM').AsString    := UpperCase(COU_NOM);
      Open;

      if Recordcount <= 0 then
      begin
        iCOUId := GetNewKId('PLXCOULEUR');
        Close;
        SQL.Clear;
        SQL.Add('Insert into PLXCOULEUR');
        SQL.Add('(COU_ID,COU_ARTID,COU_IDREF,COU_GCSID,COU_CODE,COU_NOM)');
        SQL.Add('Values(:PCOUID,:PCOUARTID,:PCOUIDREF,:PCOUGCSID,:PCOUCODE,:PCOUNOM)');
        ParamCheck := True;
        ParamByName('PCOUID').AsInteger    := iCOUId;
        ParamByName('PCOUARTID').AsInteger := COU_ARTID;
        ParamByName('PCOUIDREF').AsInteger := COU_IDREF;
        ParamByName('PCOUGCSID').AsInteger := COU_GCSID;
        ParamByName('PCOUCODE').AsString   := UpperCase(COU_CODE);
        ParamByName('PCOUNOM').AsString    := COU_NOM;
        ExecSQL;
      end else
        iCOUId := FieldByName('COU_ID').AsInteger;

      Result := iCOUId;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.GetFamilleId(FAM_RAYID, FAM_IDREF: integer; FAM_NOM: String;
  FAM_ORDREAFF: single; FAM_VISIBLE, FAM_CTFID: integer): integer;
var
  iFAMId : Integer;
  bUpdate : Boolean;
begin
  Try
    bUpdate := False;
    With Que_TmpEvent do
    begin
      // recherche par IdRef
      Close;
      SQL.Clear;
      SQL.Add('Select * from NKLFAMILLE');
      SQL.Add(' join k on k_id = FAM_ID and k_enabled = 1');
      SQL.Add('Where FAM_IDREF = :PFAMIDREF');
      SQL.Add('  and FAM_RAYID = :PRAYID');
      ParamCheck := True;
      ParamByName('PFAMIDREF').AsInteger := FAM_IDREF;
      ParamByName('PRAYID').AsInteger := FAM_RAYID;
      Open;

      if RecordCount <= 0 then
      begin
        // recherche par nom
        Close;
        SQL.Clear;
        SQL.Add('Select * from NKLFAMILLE');
        SQL.Add(' join k on k_id = FAM_ID and k_enabled = 1');
        SQL.Add('Where FAM_NOM = :PFAMNOM');
        SQL.Add('  and FAM_RAYID = :PRAYID');
        ParamCheck := True;
        ParamByName('PFAMNOM').AsString := UpperCase(FAM_NOM);
        ParamByName('PRAYID').AsInteger := FAM_RAYID;
        Open;

        if RecordCount <= 0 then
        begin

          iFAMId := GetNewKId('NKLFAMILLE');
          Close;
          SQL.Clear;
          SQL.Add('Insert into NKLFAMILLE');
          SQL.Add('(FAM_ID,FAM_RAYID,FAM_IDREF,FAM_NOM,FAM_ORDREAFF,FAM_VISIBLE,FAM_CTFID)');
          SQL.Add('values(:PFAMID,:PFAMRAYID,:PFAMIDREF,:PFAMNOM,:PFAMORDREAFF,:PFAMVISIBLE,:PFAMCTFID)');
          ParamCheck := True;
          ParamByName('PFAMID').AsInteger      := iFAMId;
          ParamByName('PFAMRAYID').AsInteger   := FAM_RAYID;
          ParamByName('PFAMIDREF').AsInteger   := FAM_IDREF;
          ParamByName('PFAMNOM').AsString      := UpperCase(FAM_NOM);
          ParamByName('PFAMORDREAFF').AsFloat  := FAM_ORDREAFF;
          ParamByName('PFAMVISIBLE').AsInteger := FAM_VISIBLE;
          ParamByName('PFAMCTFID').AsInteger   := FAM_CTFID;
          ExecSQL;
        end else
          bUpdate := True;
      end else
        bUpdate := True;

      if bUpdate then
      begin
        iFAMId := FieldByName('FAM_ID').AsInteger;
        UpdateFamille(iFAMId,FAM_RAYID,FAM_IDREF,FAM_NOM,FAM_ORDREAFF,FAM_VISIBLE,FAM_CTFID);
      end;

      Result := iFAMId;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.GetGenImportId(IMP_KTIBID, IMP_GINKOIA, IMP_REF,
  IMP_NUM: Integer; IMP_REFSTR: String): TGENIMPORT;
begin
  Result.IMP_ID := 0;
  With Que_TmpEvent do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GENIMPORT');
    SQL.Add(' join k on K_ID = IMP_ID and k_enabled = 1');
    SQL.Add('Where IMP_KTBID  = :PIMPKTBID');
    SQL.Add('  and IMP_REFSTR = :PIMPREFSTR');
    SQL.Add('  and IMP_NUM    = :PIMPNUM');
    ParamCheck := True;
    ParamByName('PIMPKTBID').AsInteger := IMP_KTIBID;
    ParamByName('PIMPREFSTR').AsString := IMP_REFSTR;
    ParamByName('PIMPNUM').AsInteger   := IMP_NUM;
    Open;

    if RecordCount > 0 then
    begin
      Result.IMP_ID      := FieldByName('IMP_ID').AsInteger;
      Result.IMP_KTIBID  := FieldByName('IMP_KTIBID').AsInteger;
      Result.IMP_GINKOIA := FieldByName('IMP_GINKOIA').AsInteger;
      Result.IMP_REF     := FieldByName('IMP_REF').AsInteger;
      Result.IMP_NUM     := FieldByName('IMP_NUM').AsInteger;
      Result.IMP_REFSTR  := FieldByName('IMP_REFSTR').AsString;
    end;
  Except
    Raise;
  end;
end;

function TDM_Main.IsIdRefExist(IdREF: Integer; TableName,
  sFieldName, sRefField: String): Integer;
begin
  Result := 0;
  With Que_TmpEvent do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ' + TABLENAME);
    SQL.Add(' join k on K_ID = ' + sRefField + ' and k_enabled = 1');
    SQL.Add('Where ' + sFieldName + ' = :PFIELDATA');
    ParamCheck := True;
    ParamByName('PFIELDATA').AsInteger := IdREF;
    Open;

    if RecordCount > 0 then
      Result := FieldByName(sRefField).AsInteger;
  end;
end;


function TDM_Main.GetGenreId(GRE_IDREF: integer; GRE_NOM: String;
  GRE_SEXE: integer): integer;
var
  IdGenre : Integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.add('Select * from ARTGENRE');
      SQL.Add('  join k on k_id = GRE_ID and k_enabled = 1');
      SQL.Add('Where GRE_NOM = :PGRENOM');
      ParamCheck := True;
      ParamByName('PGRENOM').AsString := UpperCase(GRE_NOM);
      Open;

      if RecordCount = 0 then
      begin
        IdGenre := GetNewKId('ARTGENRE');

        Close;
        SQL.CLear;
        SQL.Add('insert into ARTGENRE');
        SQL.Add('(GRE_ID,GRE_IDREF,GRE_NOM,GRE_SEXE)');
        SQL.Add('Values(:PGREID,:PGREIDREF,:PGRENOM,:PGRESEXE)');
        ParamCheck := True;
        ParamByName('PGREID').AsInteger    := IdGenre;
        ParamByName('PGREIDREF').AsInteger := GRE_IDREF;
        ParamByName('PGRENOM').AsString    := UpperCase(GRE_NOM);
        if GRE_SEXE = 0 then
          case AnsiIndexStr(UpperCase(GRE_NOM),['HOMME','FEMME','ENFANT']) of
            0: ParamByName('PGRESEXE').AsInteger := 1;
            1: ParamByName('PGRESEXE').AsInteger := 2;
            2: ParamByName('PGRESEXE').AsInteger := 3;
            else begin
              ParamByName('PGRESEXE').AsInteger := 3;
            end;
          end// case
        else
          ParamByName('PGRESEXE').AsInteger := GRE_SEXE;
      end // if
      else
        IdGenre := FieldByName('GRE_ID').AsInteger;
    end; // with
    Result := IdGenre;
  Except
    Raise;
  End;
end;

function TDM_Main.CreateSsFamille(ListTbHF : TListTableHF;CodeModele: String) : TNomenclature;
var
  TbSsFamille    ,
  TbFamille      ,
  TbRayon        ,
  TbSecteur      ,
  TbJoinModSsFam ,
  TbSsCategorie  ,
  TbCategorie    : TTableHF;

  IdSsFamille   ,
  IdFamille     ,
  IdRayon       ,
  IdSecteur     ,
  IdCategorie   ,
  IdSsCategorie : Integer;
  GenImportData : TGENIMPORT;
  bUpdate       : Boolean;
  Nomenclature  : TNomenclature;
begin
  // récupération des tables
  TbSecteur      := ListTbHF.GetTable('SECTEUR');
  TbRayon        := ListTbHF.GetTable('RAYON');
  TbFamille      := ListTbHF.GetTable('FAMILLE');
  TbSsFamille    := ListTbHF.GetTable('SOUSFAMILLE');
  TbJoinModSsFam := ListTbHF.GetTable('JOINMOD_SSFAMILLE');
  TbSsCategorie  := ListTbHF.GetTable('SOUSCATEGORIE');
  TbCategorie    := ListTbHF.GetTable('CATEGORIE');

  if TbSecteur = nil then
    raise Exception.Create('Table secteur non trouvée');
  if TbRayon = nil then
    raise Exception.Create('Table rayon non trouvée');
  if TbFamille = nil then
    raise Exception.Create('Table famille non trouvée');
  if TbSsFamille = nil then
    raise Exception.Create('Table sous famille non trouvée');
  if TbJoinModSsFam = nil then
    raise Exception.Create('Table de jointure non trouvée');
  if TbSsCategorie = nil then
    raise Exception.Create('Table de sous categorie non trouvée');
  if TbCategorie = nil then
    raise Exception.Create('Table catégorie non trouvée');

  IdSsFamille := 0;
  try
    // récupération des ID catégorie et Id sous catégorie
    IdCategorie := 0;
    IdSsCategorie := 0;
    if TbSsCategorie.NLocate('GRPPK',CodeModele,[loCaseInsensitive]) then
      if TbCategorie.NLocate('CATCODE',TbSsCategorie.NFieldByName('GRPCATCODE').AsString,[loCaseInsensitive]) then
      begin
        IdCategorie := TbCategorie.CDataSet.FieldByName('CTF_ID').AsInteger;
        if IdCategorie = 0 then
        begin
          IdCategorie := GetCategorieID(TbCategorie.NFieldByName('CATNOM').AsString,ListTbHF.IdUNIID);
          With TbCategorie.CDataSet do
          begin
            Edit;
            FieldByName('CTF_ID').AsInteger := IdCategorie;
            Post;
          end;
        end;
        IdSsCategorie := TbSsCategorie.CDataSet.FieldByName('CAT_ID').AsInteger;
        if IdSsCategorie = 0 then
        begin
          IdSsCategorie := GetSsCategorieID(TbSsCategorie.NFieldByName('GRPNOM').AsString,ListTbHF.IdUNIID);
          With TbSsCategorie.CDataSet do
          begin
            Edit;
            FieldByName('CAT_ID').AsInteger := IdSsCategorie;
            Post;
          end;
        end;
      end;

    // positionnement sur les différents dataset de la nomeclature
    if TbJoinModSsFam.NLocate('GRPPK',CodeModele,[loCaseInsensitive]) then
      if TbSsFamille.NLocate('SFMPK',TbJoinModSsFam.NFieldByName('GRPSFMPK').AsString,[loCaseInsensitive]) then
        if TbFamille.NLocate('FAMPK',TbSsFamille.NFieldByName('SFMCODEFAMPK').AsString,[loCaseInsensitive]) then
          if TbRayon.NLocate('RAYPK',TbFamille.NFieldByName('FAMSEGCODEPK').AsString,[loCaseInsensitive]) then
            if TbSecteur.NLocate('SECCODE',TbRayon.NFieldByName('RAYSECCODE').AsString,[loCaseInsensitive]) then
            begin
              IdSsFamille := TbSsFamille.CDataSet.FieldByName('SSF_ID').AsInteger;
              bUpdate := False;
              // SSF_ID existe déjà c'est qu'on a déjà récupérer les données dans la base de données
              if IdSsFamille = 0 then
              begin
                // est ce que l'IdRef de la sous famille existe dans la base de données ?
                IdSsFamille := IsIdRefExist(TbSsFamille.NFieldByName('SFMPK').AsInteger,'NKLSSFAMILLE','SSF_IDREF','SSF_ID');
                if IdSsFamille = 0 then
                begin
                  // non, alors on cherche le code fedas associé
                  if cdsFedas.Locate('int_code',TbSsFamille.NFieldByName('SFMPK').AsString,[loCaseInsensitive]) then
                  begin
                    GenImportData := GetGenImportId(-11111359,0,cdsFedas.FieldByName('int_id').AsInteger,10,'');

                    if GenImportData.IMP_ID = 0 then
                    begin
                      // On a rien trouvé dasn GenImport donc on va tout créer
                      IdSecteur := TbSecteur.CDataSet.FieldByName('SEC_ID').AsInteger;
                      if (IdSecteur = 0) or (IsIdRefExist(TbSecteur.NFieldByName('SECCODE').AsInteger,'NKLSECTEUR','SEC_IDREF','SEC_ID') = 0) then
                      begin
                        // gestion du secteur
                        IdSecteur := GetSecteurId(TbSecteur.NFieldByName('SECCODE').AsInteger,TbSecteur.NFieldByName('SECNOM').AsString,ListTbHF.IdUNIID,1);
                        // Sauvegarde de l'id dans le dataset
                        With TbSecteur.CDataSet do
                        begin
                          Edit;
                          FieldByName('SEC_ID').AsInteger := IdSecteur;
                          Post;
                        end;
                      end;

                      IdRayon := TbRayon.CDataSet.FieldByName('RAY_ID').AsInteger;
                      if (IdRayon = 0) or (IsIdRefExist(TbRayon.NFieldByName('RAYPK').AsInteger,'NLKRAYON','RAY_IDREF','RAY_ID') = 0) then
                      begin
                        // Gestion du rayon
                        IdRayon := GetRayonId(ListTbHF.IdUNIID,TbRayon.NFieldByName('RAYPK').AsInteger,TbRayon.NFieldByName('RAYNOM').AsString,0,1,IdSecteur);
                        // Sauvegarde de l'id dans le dataset
                        With TbRayon.CDataSet do
                        begin
                          Edit;
                          FieldByName('RAY_ID').AsInteger := IdRayon;
                          Post;
                        end;
                      end;

                      // si la sous famille n'existe pas alors on va la créer
                      IdFamille := TbFamille.CDataSet.FieldByName('FAM_ID').AsInteger;
                      if (IdFamille = 0) or (IsIdRefExist(TbFamille.NFieldByName('FAMPK').AsInteger,'NKLFAMILLE','FAM_IDREF','FAM_ID') = 0) then
                      begin
                        IdFamille := GetFamilleId(IdRayon,TbFamille.NFieldByName('FAMPK').AsInteger,TbFamille.NFieldByName('FAMNOM').AsString,0,1,IdCategorie);
                        // Sauvegarde de l'id dans le dataset
                        With TbFamille.CDataSet do
                        begin
                          Edit;
                          FieldByName('FAM_ID').AsInteger := IdFamille;
                          Post;
                        end;
                      end;

                      IdSsFamille := GetSsFamileID(IdFamille,TbSsFamille.NFieldByName('SFMPK').AsInteger,TbSsFamille.NFieldByName('SFMNOM').AsString,0,1,IdSsCategorie,0,0);
                      // Sauvegarde de l'id dans le dataset
                      With TbSsFamille.CDataSet do
                      begin
                        Edit;
                        FieldByName('SSF_ID').AsInteger := IdSsFamille;
                        Post;
                      end;
                    end // if genimportdata
                    else begin
                      IdSsFamille := GenImportData.IMP_GINKOIA;
                      bUpdate := True;
                    end;
                  end; // if locate
                end else // if refexist
                  bUpdate := True;

                Nomenclature.SEC_ID := IdSecteur;
                Nomenclature.RAY_ID := IdRayon;
                Nomenclature.FAM_ID := IdFamille;
                Nomenclature.SSF_ID := IdSsFamille;
                Nomenclature.CTF_ID := IdCategorie;
                Nomenclature.CAT_ID := IdSsCategorie;
                // dans le cas ou l'id ssfamille est trouvé on met à jours son arborescense.
                if bUpdate then
                begin
                  Nomenclature.SSF_ID := IdSsFamille;
                  Nomenclature := GetNomenclatureBySSFID(IdSsFamille);
                  UpdateSecteur(Nomenclature.SEC_ID,TbSecteur.NFieldByName('SECCODE').AsInteger,TbSecteur.NFieldByName('SECNOM').AsString,ListTbHF.IdUNIID,1);
                  UpdateRayon(Nomenclature.RAY_ID,ListTbHF.IdUNIID,TbRayon.NFieldByName('RAYPK').AsInteger,TbRayon.NFieldByName('RAYNOM').AsString,0,1,Nomenclature.SEC_ID);
                  UpdateFamille(Nomenclature.FAM_ID,Nomenclature.RAY_ID,TbFamille.NFieldByName('FAMPK').AsInteger,TbFamille.NFieldByName('FAMNOM').AsString,0,1,Nomenclature.CTF_ID);
                  UpdateSsFamille(Nomenclature.SSF_ID,Nomenclature.FAM_ID,TbSsFamille.NFieldByName('SFMPK').AsInteger,TbSsFamille.NFieldByName('SFMNOM').AsString,0,1,Nomenclature.CAT_ID,0,0);
                end;
              end; // if idssfam
            end; // if locate

    Result := Nomenclature;
  Except
    raise;
  end;
end;

function TDM_Main.GetMarqueId(MRK_IDREF: integer; MRK_NOM, MRK_CONDITION,
  MRK_CODE: String): integer;
var
  iMRKId : Integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from ARTMARQUE');
      SQL.Add(' join k on k_id = MRK_ID and k_enabled = 1');
      SQL.Add('Where MRK_NOM = :PMRKNOM');
      ParamCheck := True;
      ParamByName('PMRKNOM').AsString := UpperCase(MRK_NOM);
      Open;

      if RecordCount <= 0 then
      begin
        iMRKId := GetNewKId('ARTMARQUE');
        Close;
        SQL.Clear;
        SQL.add('Insert into ARTMARQUE');
        SQL.Add('(MRK_ID,MRK_IDREF,MRK_NOM,MRK_CONDITION,MRK_CODE)');
        SQL.Add('values(:PMRKID,:PMRKIDREF,:PMRKNOM,:PMRKCONDITION,:PMRKCODE)');
        ParamCheck := True;
        ParamByName('PMRKID').AsInteger       := iMRKId;
        ParamByName('PMRKIDREF').AsInteger    := MRK_IDREF;
        ParamByName('PMRKNOM').AsString       := UpperCase(MRK_NOM);
        ParamByName('PMRKCONDITION').AsString := MRK_CONDITION;
        ParamByName('PMRKCODE').AsString      := MRK_CODE;
        ExecSQL;
      end
      else
        iMRKId := FieldByName('MRK_ID').AsInteger;

      Result := iMRKId;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.GetNewKId(sTableName: String): Integer;
begin
  With Que_NEWK do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PTBNAME').AsString := UpperCase(sTableName);
    Open;

    Result := FieldByName('ID').AsInteger;
  end;
end;

function TDM_Main.GetPaysId(sNomPays: String): Integer;
var
  iPayId : integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select genpays.* from genpays');
      SQL.Add(' join k on k_id=pay_id and k_enabled=1');
      SQL.Add('Where PAY_NOM = :PNom');
      ParamCheck := True;
      ParamByName('PNom').AsString := UpperCase(sNomPays);
      Open;

      if Recordcount <= 0 then
      begin
        iPayId := GetNewKId('GENPAYS');
        Close;
        SQL.Clear;
        SQL.Add('insert into genpays(PAY_ID,PAY_NOM)');
        SQL.Add('Values(:PPAYID,:PPayNOM)');
        ParamCheck := True;
        ParamByName('PPAYID').AsInteger := iPayId;
        ParamByName('PPayNOM').AsString := UpperCase(sNomPays);
        ExecSQL;

      end else
        iPayId := FieldByName('Pay_ID').AsInteger;

      Result := iPayId;
    end;
  Except
    raise;
  End;
end;

function TDM_Main.GetRayonId(RAY_UNIID, RAY_IDREF: integer; RAY_NOM: String;
  RAY_ORDREAFF: single; RAY_VISIBLE, RAY_SECID: Integer): Integer;
var
  iRayId : integer;
  bUpdate : Boolean;
begin
  Try
    bUpdate := False;
    With Que_TmpEvent do
    begin
      // recherche par idRef
      Close;
      SQL.Clear;
      SQL.Add('Select * from NKLRAYON');
      SQL.Add(' join k on k_id = RAY_ID and k_enabled = 1');
      SQL.Add('Where RAY_IDREF = :PRAYIDREF');
      SQL.Add('  and RAY_SECID = :PSECID');
      ParamCheck := True;
      ParamByName('PRAYIDREF').AsInteger := RAY_IDREF;
      ParamByName('PSECID').AsInteger    := RAY_SECID;
      Open;

      if Recordcount <= 0 then
      begin
        // recherche par nom
        Close;
        SQL.Clear;
        SQL.Add('Select * from NKLRAYON');
        SQL.Add(' join k on k_id = RAY_ID and k_enabled = 1');
        SQL.Add('Where RAY_NOM = :PRAYNOM');
        SQL.Add('  and RAY_SECID = :PSECID');
        ParamCheck := True;
        ParamByName('PRAYNOM').AsString := RAY_NOM;
        ParamByName('PSECID').AsInteger  := RAY_SECID;
        Open;

        if recordCount <= 0 then
        begin
          // création du rayon
          iRayId := GetNewKId('NKLRAYON');
          Close;
          SQL.Clear;
          SQL.Add('insert into NKLRAYON');
          SQL.Add('(RAY_ID,RAY_UNIID,RAY_IDREF,RAY_NOM,RAY_ORDREAFF,RAY_VISIBLE,RAY_SECID)');
          SQL.Add('values(:PRAYID,:PRAYUNIID,:PRAYIDREF,:PRAYNOM,:PRAYORDREAFF,:PRAYVISIBLE,:PRAYSECID)');
          ParamCheck := True;
          ParamByName('PRAYID').AsInteger      := iRayId;
          ParamByName('PRAYUNIID').AsInteger   := RAY_UNIID;
          ParamByName('PRAYIDREF').AsInteger   := RAY_IDREF;
          ParamByName('PRAYNOM').AsString      := RAY_NOM;
          ParamByName('PRAYORDREAFF').AsFloat  := RAY_ORDREAFF;
          ParamByName('PRAYVISIBLE').AsInteger := RAY_VISIBLE;
          ParamByName('PRAYSECID').AsInteger   := RAY_SECID;
          execSQL;
        end else
          bUpdate := True;
      end
      else
        bUpdate := True;

      if bUpdate then
      begin
        iRayId := FieldByName('RAY_ID').AsInteger;
        UpdateRayon(iRayId,RAY_UNIID,RAY_IDREF,RAY_NOM,RAY_ORDREAFF,RAY_VISIBLE,RAY_SECID);
      end;

      Result := iRayId;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.GetSecteurId(SEC_IDREF: integer; SEC_NOM: String; SEC_UNIID,
  SEC_TYPE: integer): Integer;
var
  iSECId : integer;
  bUpdate : Boolean;
begin
  Try
    bUpdate := False;
    With Que_TmpEvent do
    begin
      // recherche sur l'idREf
      Close;
      SQL.Clear;
      SQL.Add('Select * from NKLSECTEUR');
      SQL.Add(' Join k on k_id = SEC_ID and k_enabled = 1');
      SQL.Add('Where SEC_IDREF = :PSECIDREF');
      ParamCheck := True;
      ParamByName('PSECIDREF').AsInteger := SEC_IDREF;
      Open;

      if Recordcount <=0 then
      begin
        // recherche sur le nom
        Close;
        SQL.Clear;
        SQL.Add('Select * from NKLSECTEUR');
        SQL.Add(' Join k on k_id = SEC_ID and k_enabled = 1');
        SQL.Add('Where SEC_NOM = :PSECNOM');
        ParamCheck := True;
        ParamByName('PSECNOM').AsString := SEC_NOM;
        Open;

        if RecordCount <= 0 then
        begin
          // Création du secteur
          iSECId := GetNewKId('NKLSECTEUR');
          Close;
          SQL.Clear;
          SQL.Add('insert into NKLSECTEUR');
          SQL.Add('(SEC_ID,SEC_IDREF,SEC_NOM,SEC_UNIID,SEC_TYPE)');
          SQL.Add('Values(:PSECID,:PSECIDREF,:PSECNOM,:PSECUNIID,:PSECTYPE)');
          ParamCheck := True;
          ParamByName('PSECID').AsInteger    := iSECId;
          ParamByName('PSECIDREF').AsInteger := SEC_IDREF;
          ParamByName('PSECNOM').AsString    := UpperCase(SEC_NOM);
          ParamByName('PSECUNIID').AsInteger := SEC_UNIID;
          ParamByName('PSECTYPE').AsInteger  := SEC_TYPE;
          execSQL;
        end
        else
          bUpdate := True;
      end
      else
       bUpdate := True;


      if bUpdate then
      begin
         iSECId := FieldByName('SEC_ID').AsInteger;
         UpdateSecteur(iSECId,SEC_IDREF,SEC_NOM,SEC_UNIID,SEC_TYPE);
      end;

      Result := iSECId;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.GetSsCategorieID(CAT_NOM: String;
  CAT_UNIID: integer): Integer;
var
  iCatId : integer;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from NKLCATEGORIE');
      SQL.Add(' join k on K_ID = CAT_ID and k_enabled = 1');
      SQL.Add('Where CAT_NOM = :PCATNOM');
      SQL.Add('  and CAT_UNIID = :PUNIID');
      ParamCheck := True;
      ParamByName('PCATNOM').AsString := UpperCase(CAT_NOM);
      ParamByName('PUNIID').AsInteger := CAT_UNIID;
      Open;

      if RecordCount = 0 then
      begin
        iCatId := GetNewKId('NKLCATEGORIE');
        Close;
        SQL.Clear;
        SQL.Add('Insert into NKLCATEGORIE');
        SQL.Add('(CAT_ID,CAT_NOM,CAT_UNIID)');
        SQL.Add('Values(:PCATID,:PCATNOM,:PUNIID)');
        ParamCheck := True;
        ParamByName('PCATID').AsInteger := iCatId;
        ParamByName('PCATNOM').AsString := UpperCase(CAT_NOM);
        ParamByName('PUNIID').AsInteger := CAT_UNIID;
        ExecSQL;
      end else
        iCatId := FieldByName('CAT_ID').AsInteger;
      Result := iCatId;
    end;
  except
    raise;
  end;
end;

function TDM_Main.GetSsFamileID(SSF_FAMID, SSF_IDREF: integer; SSF_NOM: String;
  SSF_ORDREAFF: single; SSF_VISIBLE, SSF_CATID, SSF_TVAID,
  SSF_TCTID: integer): Integer;
var
  iSSFId : Integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from NKLSSFAMILLE');
      SQL.Add(' join k on k_ID = SSF_ID and k_enabled = 1');
      SQL.Add('Where SSF_NOM = :PSSFNOM');
      SQL.Add('  and SSF_FAMID = :PFAMID');
      ParamCheck := True;
      ParamByName('PSSFNOM').AsString := UpperCase(SSF_NOM);
      ParamByName('PFAMID').AsInteger := SSF_FAMID;
      Open;

      if Recordcount <= 0  then
      begin
        iSSFId := GetNewKId('NKLSSFAMILLE');
        Close;
        SQL.Clear;
        SQL.Add('Insert into NKLSSFAMILLE');
        SQL.Add('(SSF_ID,SSF_FAMID,SSF_IDREF,SSF_NOM,SSF_ORDREAFF,SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID)');
        SQL.Add('Values(:PSSFID,:PSSFFAMID,:PSSFIDREF,:PSSFNOM,:PSSFORDREAFF,:PSSFVISIBLE,:PSSFCATID,:PSSFTVAID,:PSSFTCTID)');
        ParamCheck := True;
        ParamByName('PSSFID').AsInteger      := iSSFId;
        ParamByName('PSSFFAMID').AsInteger   := SSF_FAMID;
        ParamByName('PSSFIDREF').AsInteger   := SSF_IDREF;
        ParamByName('PSSFNOM').AsString      := UpperCase(SSF_NOM);
        ParamByName('PSSFORDREAFF').AsFloat  := SSF_ORDREAFF;
        ParamByName('PSSFVISIBLE').AsInteger := SSF_VISIBLE;
        ParamByName('PSSFCATID').AsInteger   := SSF_CATID;
        ParamByName('PSSFTVAID').AsInteger   := SSF_TVAID;
        ParamByName('PSSFTCTID').AsInteger   := SSF_TCTID;
        ExecSQL;
      end
      else
        iSSFId := FieldByName('SSF_ID').AsInteger;

      Result := iSSFId;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.GetNomenclatureBySSFID(SSF_ID: integer): TNomenclature;
begin
  With Que_TmpEvent do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from NKLSSFAMILLE');
    SQL.Add(' join k on K_ID = SSF_ID and k_enabled = 1');
    SQL.Add('Where SSF_ID = :PSSFID');
    ParamCheck := True;
    ParamByName('PSSFID').AsInteger := SSF_ID;
    Open;

    Result.FAM_ID := FieldByName('SSF_FAMID').AsInteger;
    Result.CAT_ID := FieldByName('SSF_CATID').AsInteger;

    Close;
    SQL.Clear;
    SQL.Add('Select * from NKLFAMILLE');
    SQL.Add(' join k on K_ID = FAM_ID and k_enabled = 1');
    SQL.Add('Where FAM_ID = :PFAMID');
    ParamCheck := True;
    ParamByName('PFAMID').AsInteger := Result.FAM_ID;
    Open;

    Result.RAY_ID := FieldByName('FAM_RAYID').AsInteger;
    Result.CTF_ID := FieldByName('FAM_CTFID').AsInteger;

    Close;
    SQL.Clear;
    SQL.Add('Select * from NKLRAYON');
    SQL.Add(' join k on K_ID = RAY_ID and k_enabled = 1');
    SQL.Add('Where RAY_ID = :PRAYID');
    ParamCheck := True;
    ParamByName('PRAYID').AsInteger := Result.FAM_ID;
    Open;

    Result.SEC_ID := FieldByName('RAY_SECID').AsInteger;
  end;
end;

function TDM_Main.GetTailleTypeGT(TGT_NOM: String;
  TGT_ORDREAFF: single): Integer;
var
  iTGTId : integer;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from PLXTYPEGT');
      SQL.Add('  join k on K_ID = TGT_ID and k_enabled = 1');
      SQL.Add('Where TGT_NOM = :PTGTNOM');
      ParamCheck := True;
      ParamByName('PTGTNOM').AsString := UpperCase(TGT_NOM);
      Open;

      if Recordcount <= 0 then
      begin
        iTGTId := GetNewKId('PLXTYPEGT');
        Close;
        SQL.Clear;
        SQL.Add('Insert into PLXTYPEGT');
        SQL.Add('(TGT_ID,TGT_NOM,TGT_ORDREAFF)');
        SQL.Add('values(:PTGTID,:PTGTNOM,:PTGTORDREAFF)');
        ParamCheck := True;
        ParamByName('PTGTID').AsInteger     := iTGTId;
        ParamByName('PTGTNOM').AsString     := UpperCase(TGT_NOM);
        ParamByName('PTGTORDREAFF').AsFloat := TGT_ORDREAFF;
        ExecSQL;
      end else
        iTGTId := FieldByName('TGT_ID').AsInteger;

      Result := iTGTId;
    end; // With
  except
    raise;
  end;
end;


function TDM_Main.GetTVAId(TVA_TAUX: single; TVA_CODE: String): integer;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from ARTTVA');
      SQL.Add('  join k on k_id = TVA_ID and k_enabled = 1');
      SQL.Add('Where TVA_TAUX = :PTVATAUX');
      if Trim(TVA_CODE) <> '' then
        SQL.Add('and TVA_CODE = :PTVACODE');
      ParamCheck := True;
      ParamByName('PTVATAUX').AsString  := FormatFloat('0.00',TVA_TAUX);
      if Trim(TVA_CODE) <> '' then
        ParamByName('PTVACODE').AsString := TVA_CODE;
      Open;

      Result := FieldByName('TVA_ID').AsInteger;
    end;
  except
    raise
  end;
end;

function TDM_Main.GetTailleGFId(TGF_GTFID, TGF_IDREF, TGF_TGFID: integer;
  TGF_NOM, TGF_CORRES: String; TGF_ORDREAFF: single;
  TGF_STAT: integer): Integer;
var
  iTGFId : integer;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from PLXTAILLESGF');
      SQL.Add(' join k on K_ID = TGF_ID and k_enabled = 1');
      SQL.Add('Where TGF_GTFID = :PGTFID');
      SQL.Add('  and TGF_NOM   = :PTGFNOM');
      ParamCheck := True;
      ParamByName('PGTFID').AsInteger := TGF_GTFID;
      ParamByName('PTGFNOM').AsString := UpperCase(TGF_NOM);
      open;

      if RecordCount <= 0 then
      begin
        iTGFId := GetNewKId('PLXTAILLESGF');
        Close;
        SQL.Clear;
        SQL.Add('Insert into PLXTAILLESGF');
        SQL.Add('(TGF_ID,TGF_IDREF,TGF_TGFID,TGF_NOM,TGF_CORRES,TGF_ORDREAFF,TGF_STAT)');
        SQL.Add('values(:PTGFID,:PTGFIDREF,:PTGFTGFID,:PTGFNOM,:PTGFCORRES,:PTGFORDREAFF,:PTGFSTAT)');
        ParamCheck := True;
        ParamByName('PTGFID').AsInteger     := iTGFId;
        ParamByName('PTGFIDREF').AsInteger  := TGF_IDREF;
        ParamByName('PTGFTGFID').AsInteger  := TGF_TGFID;
        ParamByName('PTGFNOM').AsString     := TGF_NOM;
        ParamByName('PTGFCORRES').AsString  := TGF_CORRES;
        ParamByName('PTGFORDREAFF').AsFloat := TGF_ORDREAFF;
        ParamByName('PTGFSTAT').AsInteger   := TGF_STAT;
        ExecSQL;
      end
      else
        iTGFId := FieldByName('TGF_ID').AsInteger;

      Result := iTGFId;
    end; // With
  except
    raise;
  end;

end;

function TDM_Main.GetTailleGTFId(GTF_IDREF: Integer; GTF_NOM: String;
  GTF_TGTID: Integer; GTF_ORDREAFF: single; GTF_IMPORT: Integer): Integer;
var
  iGTFId : integer;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from PLXGTF');
      SQL.Add(' join k on K_ID = GTF_ID and k_enabled = 1');
      SQL.Add('Where GTF_TGTID = :PGTFTGTID');
      SQL.Add('  and GTF_NOM   = :PGTFNOM');
      ParamCheck := True;
      ParamByName('PGTFTGTID').AsInteger := GTF_TGTID;
      ParamByName('PGTFNOM').AsString    := UpperCase(GTF_NOM);
      Open;

      If Recordcount <=0 then
      begin
        iGTFId := GetNewKId('PLXGTF');
        Close;
        SQL.Clear;
        SQL.Add('Insert into PLXGTF');
        SQL.Add('(GTF_ID,GTF_IDREF,GTF_NOM,GTF_TGTID,GTF_ORDREAFF,GTF_IMPORT)');
        SQL.Add('values(:PGTFID,:PGTFIDREF,:PGTFNOM,:PGTFTGTID,:PGTFORDREAFF,:PGTFIMPORT)');
        ParamCheck := True;
        ParamByName('PGTFID').AsInteger     := iGTFId;
        ParamByName('PGTFIDREF').AsInteger  := GTF_IDREF;
        ParamByName('PGTFNOM').AsString     := UpperCase(GTF_NOM);
        ParamByName('PGTFTGTID').AsInteger  := GTF_TGTID;
        ParamByName('PGTFORDREAFF').AsFloat := GTF_ORDREAFF;
        ParamByName('PGTFIMPORT').AsInteger := GTF_IMPORT;
        ExecSQL;
      end
      else
        iGTFId := FieldByName('GTF_ID').AsInteger;

      Result := iGTFId;
    end; // With
  except
    raise;
  end;
end;

function TDM_Main.SetTailleTrav(TTV_ARTID, TTV_TGFID: Integer): Integer;
var
  iTTVId : Integer;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from PLXTAILLESTRAV');
      SQL.Add('  join k on K_ID = TTV_ID and k_enabled = 1');
      SQL.Add('where TTV_ARTID = :PARTID');
      SQL.Add('  and TTV_TGFID = :PTGFID');
      ParamCheck := True;
      ParamByName('PARTID').AsInteger := TTV_ARTID;
      ParamByName('PTGFID').AsInteger := TTV_TGFID;
      Open;

      if RecordCount <= 0 then
      begin
        iTTVId := GetNewKId('PLXTAILLESTRAV');
        Close;
        SQL.Clear;
        SQL.Add('Insert into PLXTAILLESTRAV');
        SQL.Add('(TTV_ID,TTV_ARTID,TTV_TGFID)');
        SQL.Add('values(:PTTVID,:PTTVARTID,:PTTVTGFID)');
        ParamCheck := True;
        ParamByName('PTTVID').AsInteger    := iTTVId;
        ParamByName('PTTVARTID').AsInteger := TTV_ARTID;
        ParamByName('PTTVTGFID').AsInteger := TTV_TGFID;
        execSQL;
      end
      else
        iTTVId := FieldByName('TTV_ID').AsInteger;

      Result := iTTVId;
    end; // With
  except
    raise;
  end;
end;


function TDM_Main.UpdateFamille(FAM_ID, FAM_RAYID, FAM_IDREF: integer;
  FAM_NOM: String; FAM_ORDREAFF: single; FAM_VISIBLE,
  FAM_CTFID: integer): Boolean;
begin
  Result := False;
  With Que_TmpEvent do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from NKLFAMILLE');
    SQL.Add(' join k on k_id = FAM_ID and k_enabled = 1');
    SQL.Add('Where FAM_ID = :PFAMID');
    ParamCheck := True;
    ParamByName('PFAMID').AsInteger := FAM_ID;
    Open;

    if (FieldByName('FAM_IDREF').AsInteger = 0) or
       (FieldByName('FAM_NOM').AsString <> FAM_NOM) then
    begin
      Close;
      SQL.Clear;
      SQL.Add('update NKLFAMILLE set');
      SQL.Add('FAM_RAYID    = :PFAMRAYID,');
      SQL.Add('FAM_IDREF    = :PFAMIDREF,');
      SQL.Add('FAM_NOM      = :PFAMNOM,');
      SQL.Add('FAM_ORDREAFF = :PFAMORDREAFF,');
      SQL.Add('FAM_VISIBLE  = :PFAMVISIBLE,');
      SQL.Add('FAM_CTFID    = :PFAMCTFID');
      SQL.Add('Where FAM_ID = :PFAMID');
      ParamCheck := True;
      ParamByName('PFAMID').AsInteger      := FAM_ID;
      ParamByName('PFAMRAYID').AsInteger   := FAM_RAYID;
      ParamByName('PFAMIDREF').AsInteger   := FAM_IDREF;
      ParamByName('PFAMNOM').AsString      := UpperCase(FAM_NOM);
      ParamByName('PFAMORDREAFF').AsFloat  := FAM_ORDREAFF;
      ParamByName('PFAMVISIBLE').AsInteger := FAM_VISIBLE;
      ParamByName('PFAMCTFID').AsInteger   := FAM_CTFID;
      ExecSQL;

      UpdateKId(FAM_ID,0);
    end;
    Result := True;
  Except
    Raise;
  End;
end;

function TDM_Main.UpdateKId(K_ID, Suppression: Integer): Boolean;
begin
  Result := False;
  With ibs_UPDATEK do
  Try
    Close;
    ParamByName('K_ID').AsInteger := K_ID;
    ParamByName('SUPRESSION').AsInteger := Suppression;
    ExecSQL;
  Except
    raise;
  end;
  Result := True;
end;

function TDM_Main.UpdateRayon(RAY_ID, RAY_UNIID, RAY_IDREF: integer;
  RAY_NOM: String; RAY_ORDREAFF: single; RAY_VISIBLE,
  RAY_SECID: Integer): Boolean;
begin
  Result := False;
  With Que_TmpEvent do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from NKLRAYON');
    SQL.Add(' join k on k_id = RAY_ID and k_enabled = 1');
    SQL.Add('Where RAY_ID = :PRAYID');
    ParamCheck := True;
    ParamByName('PRAYID').AsInteger := RAY_ID;
    Open;

    if (FieldByName('RAY_IDREF').AsInteger <> RAY_IDREF) or
       (FieldByName('RAY_NOM').AsString <> RAY_NOM) then
    begin
      Close;
      SQL.Clear;
      SQL.Add('Update NKLRAYON set');
      SQL.Add('  RAY_UNIID    = :PRAYUNIID,');
      sQL.Add('  RAY_IDREF    = :PRAYIDREF,');
      SQL.Add('  RAY_NOM      = :PRAYNOM,');
      SQL.Add('  RAY_ORDREAFF = :PRAYORDREAFF,');
      SQL.Add('  RAY_VISIBLE  = :PRAYVISIBLE,');
      SQL.Add('  RAY_SECID    = :PRAYSECID');
      SQL.Add('Where RAY_ID = :PRAYID');
      ParamCheck := True;
      ParamByName('PRAYID').AsInteger      := RAY_ID;
      ParamByName('PRAYUNIID').AsInteger   := RAY_UNIID;
      ParamByName('PRAYIDREF').AsInteger   := RAY_IDREF;
      ParamByName('PRAYNOM').AsString      := RAY_NOM;
      ParamByName('PRAYORDREAFF').AsFloat  := RAY_ORDREAFF;
      ParamByName('PRAYVISIBLE').AsInteger := RAY_VISIBLE;
      ParamByName('PRAYSECID').AsInteger   := RAY_SECID;
      ExecSQL;

      UpdateKId(RAY_ID,0);
    end;
    Result := True;
  except on E:Exception do
    raise Exception.Create('Update Rayon erreur - ' + E.Message);
  end;
end;

function TDM_Main.UpdateSecteur(SEC_ID, SEC_IDREF: integer; SEC_NOM: String;
  SEC_UNIID, SEC_TYPE: integer): Boolean;
begin
  Result := False;
  With Que_TmpEvent do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from NKLSECTEUR');
    SQL.Add(' Join k on k_id = SEC_ID and k_enabled = 1');
    SQL.Add('Where SEC_ID = :PSECID');
    ParamCheck := True;
    ParamByName('PSECID').AsInteger := SEC_ID;
    Open;

     if (FieldByName('SEC_IDREF').AsInteger = 0) or
        (FieldByName('SEC_NOM').AsString <> SEC_NOM) then
     begin
       Close;
       SQL.Clear;
       SQL.Add('Update NKLSECTEUR set');
       SQL.Add('SEC_IDREF = :PSECIDREF,');
       SQL.Add('SEC_NOM   = :PSECNOM,');
       SQL.Add('SEC_UNIID = :PSECUNIID,');
       SQL.Add('SEC_TYPE  = :PSECTYPE');
       SQL.Add('Where SEC_ID = :PSECID');
       ParamCheck := True;
       ParamByName('PSECID').AsInteger    := SEC_ID;
       ParamByName('PSECIDREF').AsInteger := SEC_IDREF;
       ParamByName('PSECNOM').AsString    := UpperCase(SEC_NOM);
       ParamByName('PSECUNIID').AsInteger := SEC_UNIID;
       ParamByName('PSECTYPE').AsInteger  := SEC_TYPE;
       ExecSQL;

       UpdateKId(SEC_ID,0);
     end;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('Update Secteur erreur - ' + E.Message);
  End;
end;

function TDM_Main.UpdateSsFamille(SSF_ID, SSF_FAMID, SSF_IDREF: integer;
  SSF_NOM: String; SSF_ORDREAFF: single; SSF_VISIBLE, SSF_CATID, SSF_TVAID,
  SSF_TCTID: integer): Boolean;
begin
  With Que_TmpEvent do
  Try
    Result := False;
    Close;
    SQL.Clear;
    SQL.Add('Select * from NKLSSFAMILLE');
    SQL.Add(' join k on k_ID = SSF_ID and k_enabled = 1');
    SQL.Add('Where SSF_ID = :PSSFID');
    ParamCheck := True;
    ParamByName('PSSFID').AsInteger := SSF_ID;
    Open;

    if Recordcount <= 0  then
    begin
      Close;
      SQL.Clear;
      SQL.Add('Update NKLSSFAMILLE set');
      SQL.Add('  SSF_FAMID    = :PSSFFAMID,');
      SQL.Add('  SSF_IDREF    = :PSSFIDREF,');
      SQL.Add('  SSF_NOM      = :PSSFNOM,');
      SQL.Add('  SSF_ORDREAFF = :PSSFORDREAFF,');
      SQL.Add('  SSF_VISIBLE  = :PSSFVISIBLE,');
      SQL.Add('  SSF_CATID    = :PSSFCATID,');
      SQL.Add('  SSF_TVAID    = :PSSFTVAID,');
      SQL.Add('  SSF_TCTID    = :PSSFTCTID');
      SQL.Add('Where SSF_ID = :PSSFID');
      ParamCheck := True;
      ParamByName('PSSFID').AsInteger      := SSF_ID;
      ParamByName('PSSFFAMID').AsInteger   := SSF_FAMID;
      ParamByName('PSSFIDREF').AsInteger   := SSF_IDREF;
      ParamByName('PSSFNOM').AsString      := UpperCase(SSF_NOM);
      ParamByName('PSSFORDREAFF').AsFloat  := SSF_ORDREAFF;
      ParamByName('PSSFVISIBLE').AsInteger := SSF_VISIBLE;
      ParamByName('PSSFCATID').AsInteger   := SSF_CATID;
      ParamByName('PSSFTVAID').AsInteger   := SSF_TVAID;
      ParamByName('PSSFTCTID').AsInteger   := SSF_TCTID;
      ExecSQL;

      UpdateKId(SSF_ID,0);
    end;
    Result := True;
  Except
    Raise;
  End;

end;

function TDM_Main.GetVilleId(sNomVille, sCP: String; iPayID: Integer): integer;
var
  iVilId : Integer;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select genville.* from genville');
      SQL.Add(' join k on k_id=vil_id and k_enabled=1');
      SQL.Add('Where VIL_NOM = :PNom');
      SQL.Add('  And VIL_CP  = :PCp');
      SQL.Add('  And VIL_PAYID = :PIdPays');
      ParamCheck := True;
      ParamByName('PNom').AsString := UpperCase(sNomVille);
      ParamByName('PCp').AsString  := UpperCase(sCP);
      ParamByName('PidPays').AsInteger := iPayID;
      Open;

      if RecordCount <= 0 then
      begin
        iVilId := GetNewKId('GENVILLE');
        Close;
        SQL.Clear;
        SQL.Add('Insert into  GENVILLE');
        SQL.Add('(VIL_ID,VIL_NOM,VIL_CP,VIL_PAYID)');
        SQL.Add('Values(:PVILID,:PVILNOM,:PVILCP,:PVILPAYID)');
        ParamCheck := True;
        ParamByName('PVILID').AsInteger    := iVilId;
        ParamByName('PVILNOM').AsString    := UpperCase(sNomVille);
        ParamByName('PVILCP').AsString     := UpperCase(sCP);
        ParamByName('PVILPAYID').AsInteger := iPayID;
        ExecSQL;
      end
      else
        iVilId := FieldByName('VIL_ID').AsInteger;

      Result := iVilId;
    end; // With
  except
    raise;
  end;
end;

function TDM_Main.LoadFedasData(ListTbHF : TListTableHF): Boolean;
var
  LstFile  ,
  lstLigne : TStringList;
  i,j : integer;
begin
  Result   := False;
  if not FileExists(GFILEFEDAS) then
    raise Exception.Create('Fichier FEDAS inéxistant');

  LstFile  := TStringList.Create;
  lstLigne := TStringList.Create;
  try

    if cdsFedas.Active then
      cdsFedas.Active := False;
    cdsFedas.Active := True;;
    cdsFedas.EmptyDataSet;
    ListTbHF.Lab.Caption := 'Chargement du fichier FEDAS';
    lstFile.LoadFromFile(GFILEFEDAS);
    With DM_Main do
      for i := 0 to lstFile.Count - 1 do
      begin
        lstLigne.Text := StringReplace(LstFile[i],';',#13#10,[rfReplaceAll]);
        try
          cdsFedas.Append;
          for j := 0 to lstLigne.Count - 1 do
          begin
            if (j <= cdsFedas.FieldCount) then
              if (Trim(lstLigne[j]) <> '') then
                cdsFedas.Fields.Fields[j].AsString := Trim(lstLigne[j]);
          end;
          cdsFedas.Post;
          ListTbHF.Progress.Position := (i + 1) * 100 Div LstFile.Count;
          Application.ProcessMessages;
        Except on E:Exception do
          raise Exception.Create('Erreur insertion Fedas : ' + E.Message);
        end;
      end;
    Result := True;
  finally
    ListTbHF.Lab.Caption := '';
    LstFile.Free;
    lstLigne.Free;
  end;
end;

function TDM_Main.OpenDataBase(sFileName: String): Boolean;
begin
  With IbC_MainCnx do
  begin
    Disconnect;
    DatabaseName := sFileName;
    try
      Connect;

      Que_ListTVA.Close;
      Que_ListTVA.Open;

      Que_ListGarantie.Close;
      Que_ListGarantie.Open;

      Que_ListTypeComptable.Close;
      Que_ListTypeComptable.Open;

      Que_ListUnivers.Close;
      Que_ListUnivers.Open;

      Que_ListExerciceCommercial.Close;
      Que_ListExerciceCommercial.Open;

      Que_ListArtCollection.Close;
      Que_ListArtCollection.Open;

      Que_ListUilUsers.Close;
      Que_ListUilUsers.Open;

      Result := True;
    Except on E:Exception do
      begin
        Result := False;
        ShowMessage('  Erreur de connexion à la base de données ' + #13#10 + E.Message);
      end;
    end;
  end;
end;

function TDM_Main.SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID: Integer;
  CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3, CLG_TAXE: Single;
  CLG_PRINCIPAL: integer): Integer;
var
  iCLGId : integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from TARCLGFOURN');
      SQL.Add(' join k on K_ID = CLG_ID and k_enabled = 1');
      SQL.Add('Where CLG_ARTID = :PARTID');
      SQL.Add('  and CLG_FOUID = :PFOUID');
      SQL.Add('  and CLG_TGFID = :PTGFID');
      ParamCheck := True;
      ParamByName('PARTID').AsInteger := CLG_ARTID;
      ParamByName('PFOUID').AsInteger := CLG_FOUID;
      ParamByName('PTGFID').AsInteger := CLG_TGFID;
      Open;

      if RecordCount <= 0 then
      begin
        iCLGId := GetNewKId('TARCLGFOURN');
        Close;
        SQL.Clear;
        SQL.Add('Insert into TARCLGFOURN');
        SQL.Add('(CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,CLG_PXNEGO,CLG_PXVI,');
        SQL.Add('CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE,CLG_PRINCIPAL)');
        SQL.Add('Values(:PCLGID,:PCLGARTID,:PCLGFOUID,:PCLGTGFID,:PCLGPX,:PCLGPXNEGO,:PCLGPXVI,');
        SQL.Add(':PCLGRA1,:PCLGRA2,:PCLGRA3,:PCLGTAXE,:PCLGPRINCIPAL)');
        ParamCheck := True;
        ParamByName('PCLGID').AsInteger        := iCLGId;
        ParamByName('PCLGARTID').AsInteger     := CLG_ARTID;
        ParamByName('PCLGFOUID').AsInteger     := CLG_FOUID;
        ParamByName('PCLGTGFID').AsInteger     := CLG_TGFID;
        ParamByName('PCLGPX').AsFloat          := CLG_PX;
        ParamByName('PCLGPXNEGO').AsFloat      := CLG_PXNEGO;
        ParamByName('PCLGPXVI').AsFloat        := CLG_PXVI;
        ParamByName('PCLGRA1').AsFloat         := CLG_RA1;
        ParamByName('PCLGRA2').AsFloat         := CLG_RA2;
        ParamByName('PCLGRA3').AsFloat         := CLG_RA3;
        ParamByName('PCLGTAXE').AsFloat        := CLG_TAXE;
        ParamByName('PCLGPRINCIPAL').AsInteger := CLG_PRINCIPAL;
        ExecSQL;
      end
      else begin
        iCLGId := FieldByName('CLG_ID').AsInteger;
        // Si le prix est différent on met à jours juste le prix nego

        if CompareValue(FieldByName('CLG_PX').AsFloat,CLG_PX) = GreaterThanValue then
        begin
          Close;
          SQL.Clear;
          SQL.Add('Update TARCLGFOURN set');
          SQL.Add('  CLG_PXNEGO = :PCLGPXNEGO');
          SQL.Add('Where CLG_ID = :PCLGID');
          ParamCheck := True;
          ParamByName('PCLGPXNEGO').AsFloat := CLG_PX;
          ParamByName('PCLGID').AsInteger   := iCLGId;
          ExecSQL;
        end;
      end;

      Result := iCLGId;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.SetArtPrixVente(PVT_TVTID, PVT_ARTID, PVT_TGFID: Integer;
  PVT_PX: single): Integer;
var
  iPVTID : Integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.add('Select * from TARPRIXVENTE');
      SQL.Add('  join k on K_ID = PVT_ID and k_enabled = 1');
      SQL.Add('where PVT_ARTID = :PARTID');
      SQL.Add('  and PVT_TGFID = :PTGFID');
      ParamCheck := True;
      ParambyName('PARTID').AsInteger := PVT_ARTID;
      ParamByName('PTGFID').AsInteger := PVT_TGFID;
      Open;

      if RecordCount <= 0 then
      begin
        iPVTID := GetNewKId('TARPRIXVENTE');
        Close;
        SQL.Clear;
        SQL.Add('Insert into TARPRIXVENTE');
        SQL.Add('(PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX)');
        SQL.Add('Values(:PPVTID,:PTVTID,:PARTID,:PTGFID,:PPVTPX)');
        ParamCheck := True;
        ParamByName('PPVTID').AsInteger := iPVTID;
        ParamByName('PTVTID').AsInteger := PVT_TVTID;
        ParamByName('PARTID').AsInteger := PVT_ARTID;
        ParamByName('PTGFID').AsInteger := PVT_TGFID;
        ParamByName('PPVTPX').AsFloat   := PVT_PX;
        ExecSQL;
      end
      else begin
        iPVTID := FieldByName('PVT_ID').AsInteger;
      end;

      Result := iPVTID;
    end;
  Except
    Raise;
  End;

end;

function TDM_Main.SetCBArticle(CBI_ARFID, CBI_TGFID, CBI_COUID: integer;
  CBI_CB: String; CBI_TYPE, CBI_CLTID, CBI_ARLID, CBI_LOC: integer): Integer;
var
  iCBIId : Integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from ARTCODEBARRE');
      SQL.Add('  join k on K_ID = CBI_ID and K_enabled = 1');
      SQL.Add('Where CBI_ARFID = :PARFID');
      SQL.Add('  and CBI_TGFID = :PTGFID');
      SQL.Add('  and CBI_COUID = :PCOUID');
      ParamCheck := True;
      ParamByName('PARFID').AsInteger := CBI_ARFID;
      ParamByName('PTGFID').AsInteger := CBI_TGFID;
      ParamByName('PCOUID').AsInteger := CBI_COUID;
      Open;

      if Recordcount <= 0 then
      begin
        iCBIId := GetNewKId('ARTCODEBARRE');
        Close;
        SQL.Clear;
        SQL.Add('Insert into ARTCODEBARRE');
        SQL.Add('(CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC)');
        SQL.Add('Values(:PCBIID,:PCBIARFID,:PCBITGFID,:PCBICOUID,:PCBICB,:PCBITYPE,:PCBICLTID,:PCBIARLID,:PCBILOC)');
        ParamCheck := True;
        ParamByName('PCBIID').AsInteger    := iCBIId;
        ParamByName('PCBIARFID').AsInteger := CBI_ARFID;
        ParamByName('PCBITGFID').AsInteger := CBI_TGFID;
        ParamByName('PCBICOUID').AsInteger := CBI_COUID;
        ParamByName('PCBICB').AsString     := Uppercase(CBI_CB);
        ParamByName('PCBITYPE').AsInteger  := CBI_TYPE;
        ParamByName('PCBICLTID').AsInteger := CBI_CLTID;
        ParamByName('PCBIARLID').AsInteger := CBI_ARLID;
        ParamByName('PCBILOC').AsInteger   := CBI_LOC;
        ExecSQL;
      end
      else
        iCBIId := FieldByName('CBI_ID').AsInteger;

      Result := iCBIId;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.SetFournisseur(FOU_IDREF: integer; FOU_NOM: String;
  FOU_ADRID: integer; FOU_TEL, FOU_FAX, FOU_EMAIL: String; FOU_REMISE: single;
  FOU_GROS: integer; FOU_CDTCDE, FOU_CODE, FOU_TEXTCDE: String;
  FOU_MAGIDPF: integer): integer;
var
  iFOUID : integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from ARTFOURN');
      SQL.Add(' join k on k_id = FOU_ID and k_enabled = 1');
      SQL.Add('Where FOU_ADRID = :PADRID');
      SQL.Add('  and FOU_NOM   = :PFOUNOM');
      Open;

      if Recordcount <= 0 then
      begin
        iFOUID := GetNewKId('ARTFOURN');
        Close;
        SQL.Clear;
        SQL.Add('Insert into ARTFOURN');
        SQL.Add('(FOU_ID,FOU_IDREF,FOU_NOM,FOU_ADRID,FOU_TEL,FOU_FAX,FOU_EMAIL,');
        SQL.Add('FOU_REMISE,FOU_GROS,FOU_CDTCDE,FOU_CODE,FOU_TEXTCDE,FOU_MAGIDPF)');
        SQL.Add('Values(:PFOUID,:PFOUIDREF,:PFOUNOM,:PFOUADRID,:PFOUTEL,:PFOUFAX,:PFOUEMAIL,');
        SQL.Add(':PFOUREMISE,:PFOUGROS,:PFOUCDTCDE,:PFOUCODE,:PFOUTEXTCDE,:PFOUMAGIDPF)');
        ParamCheck := True;
        ParamByName('PFOUID').AsInteger      := iFOUID;
        ParamByName('PFOUIDREF').AsInteger   := FOU_IDREF;
        ParamByName('PFOUNOM').AsString      := UpperCase(FOU_NOM);
        ParamByName('PFOUADRID').AsInteger   := FOU_ADRID;
        ParamByName('PFOUTEL').AsString      := FOU_TEL;
        ParamByName('PFOUFAX').AsString      := FOU_FAX;
        ParamByName('PFOUEMAIL').AsString    := FOU_EMAIL;
        ParamByName('PFOUREMISE').AsFloat    := FOU_REMISE;
        ParamByName('PFOUGROS').AsInteger    := FOU_GROS;
        ParamByName('PFOUCDTCDE').AsString   := FOU_CDTCDE;
        ParamByName('PFOUCODE').AsString     := FOU_CODE;
        ParamByName('PFOUTEXTCDE').AsString  := FOU_TEXTCDE;
        ParamByName('PFOUMAGIDPF').AsInteger := FOU_MAGIDPF;
        ExecSQL;
      end
      else
        iFOUID := FieldByName('FOU_ID').AsInteger;
         
      Result := iFOUID;
    end;
  Except
    Raise;
  End;
end;

function TDM_Main.SetFournisseurDetails(FOD_FOUID, FOD_MAGID: Integer;
  FOD_NUMCLIENT, FOD_COMENT: String; FOD_FTOID, FOD_MRGID, FOD_CPAID: Integer;
  FOD_ENCOURSA: single; FOD_COMPTA: String; FOD_FRANCOPORT: Single): Integer;
var
  IdFOD : integer;
begin
  Try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from ARTFOURNDETAIL');
      SQL.Add('  join k on K_ID = FOD_ID and k_enabled = 1');
      SQL.Add('Where FOD_FOUID = :PFOUID');
      ParamCheck := True;
      ParamByName('PFOUID').AsInteger := FOD_FOUID;
      Open;

      If RecordCount  = 0 then
      begin
        IdFod := GetNewKId('ARTFOURNDETAIL');
        Close;
        SQL.Clear;
        SQL.Add('Insert into ARTFOURNDETAIL');
        SQL.Add('(FOD_ID,FOD_FOUID,FOD_MAGID,FOD_NUMCLIENT,FOD_COMENT,FOD_FTOID,FOD_MRGID,FOD_CPAID,FOD_ENCOURSA,FOD_COMPTA)');
        SQL.Add('Values(:PFODID,:PFODFOUID,:PFODMAGID,:PFODNUMCLIENT,:PFODCOMENT,:PFODFTOID,:PFODMRGID,:PFODCPAID,:PFODENCOURSA,:PFODCOMPTA)');
        ParamCheck := True;
        ParamByName('PFODID').AsInteger       := IdFod;
        ParamByName('PFODFOUID').AsInteger    := FOD_FOUID;
        ParamByName('PFODMAGID').AsInteger    := FOD_MAGID;
        ParamByName('PFODNUMCLIENT').AsString := FOD_NUMCLIENT;
        ParamByName('PFODCOMENT').AsString    := FOD_COMENT;
        ParamByName('PFODFTOID').AsInteger    := FOD_FTOID;
        ParamByName('PFODMRGID').AsInteger    := FOD_MRGID;
        ParamByName('PFODCPAID').AsInteger    := FOD_CPAID;
        ParamByName('PFODENCOURSA').AsFloat   := FOD_ENCOURSA;
        ParamByName('PFODCOMPTA').AsFloat     := FOD_FRANCOPORT;
        ExecSQL;
      end
      else
        IdFod := FieldByName('FOD_ID').AsInteger;
    end;
    
    Result := IdFOD;
  Except
    raise;
  End;
end;

function TDM_Main.SetMrkFour(FMK_FOUID, FMK_MRKID, FMK_PRIN: integer): Integer;
var
  idMrkFOU : integer;
  bPrinExist : Boolean;
begin
  try
    With Que_TmpEvent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from ARTMRKFOURN');
      SQL.Add('  Join k on K_ID = FMK_ID and k_enabled = 1');
      SQL.Add('Where FMK_FOUID = :PFOUID');
      SQL.Add('  and FMK_MRKID = :PMRKID');
      ParamCheck := True;
      ParamByName('PFOUID').AsInteger := FMK_FOUID;
      ParamByName('PMRKID').AsInteger := FMK_MRKID;
      Open;

      if Recordcount = 0 then
      begin
        idMrkFOU := GetNewKId('ARTMRKFOURN');
        // vérification si la marque a déjà un fournisseur par défaut
        Close;
        SQL.Clear;
        SQL.Add('Select * from ARTMRKFOURN');
        SQL.Add(' join k on k_id = FMK_ID and k_enabled = 1');
        SQL.Add('Where FMK_MRKID = :PMRKID');
        SQL.Add('  and FMK_PRIN = 1');
        ParamCheck := True;
        ParamByName('PMRKID').AsInteger := FMK_MRKID;
        Open;
        bPrinExist := (RecordCount >= 1);


        Close;
        SQL.Clear;
        SQL.Add('insert into ARTMRKFOURN');
        SQL.Add('(FMK_ID, FMK_FOUID,FMK_MRKID,FMK_PRIN)');
        SQL.Add('Values(:PFMKID,:PFMKFOUID,:PFMKMRKID,:PFMKPRIN)');
        ParamCheck := True;
        ParamByName('PFMKID').AsInteger    := idMrkFOU;
        ParamByName('PFMKFOUID').AsInteger := FMK_FOUID;
        ParamByName('PFMKMRKID').AsInteger := FMK_MRKID;
        if bPrinExist then
          ParamByName('PFMKPRIN').AsInteger  := 0
        else
          ParamByName('PFMKPRIN').AsInteger  := 1;

        ExecSQL;
      end else
        idMrkFOU := FieldByName('FMK_ID').AsInteger;
    end;
    Result := idMrkFOU;
  Except
    raise;
  end;
end;

end.
