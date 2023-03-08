unit GSData_TNomenclature;

interface

uses GSData_MainClass, GSData_TErreur, GSData_Types,
     GSDataImport_DM, ComCtrls,  strUtils, Dialogs,
     DBClient, SysUtils, IBODataset, Db, Variants;

Type
  TNomenclature = class(TMainClass)
    private
      vgMax, vgIdx : Integer;
      vgNiveauMax  : Integer;

      FARBCAFTmp   ,
      FGRPCAFTmp   : TMainClass;

      FNomenclature     : TMainClass;
      FNomenclatureTEMP : TMainClass;

      FNomFils      : TMainClass;
      FPereFils     : TMainClass;

      FDepartement  : TMainClass;
      FSousRayon    : TMainClass;
      FSegment      : TMainClass;
      FSousFamille  : TMainClass;

      FDepartementLoad  : TMainClass;
      FSousRayonLoad    : TMainClass;
      FSegmentLoad      : TMainClass;
      FSousFamilleLoad  : TMainClass;
      
      FSousRayonPurge    : TMainClass;
      FSegmentPurge      : TMainClass;
      FSousFamillePurge  : TMainClass;

      Ds_Departement : TDataSource;
      Ds_SousRayon   : TDataSource;
      Ds_Segment     : TDataSource;

      FGRPCAF_File ,
      FARBCAF_File : String;

      procedure CreateCds;
      
      function SetNKLSECTEUR(ASEC_CODE, ASEC_NOM : String; ASEC_UNIID, ASEC_CENTRALE : integer) : integer;
      function SetNKLRAYON( ARAY_SECID, ARAY_UNIID : integer; ARAY_CODE, ARAY_NOM : string; ARAY_CENTRALE : integer) : Integer;
      function SetNKLFAMILLE(AFAM_RAYID : Integer; AFAM_CODE, AFAM_NOM: string; AFAM_CENTRALE : integer) : integer;
      function SetNKLSSFAMILLE( ASSF_FAMID : integer; ASSF_CODE, ASSF_NOM : string; ASSF_TVAID, ASSF_TCTID, ASSF_CENTRALE : integer): integer;

      procedure DelNKLSSFAMILLE(ASSF_ID, ACEN_CODE : Integer);
      procedure DelNKLFAMILLE(AFAM_ID, ACEN_CODE : Integer);
      procedure DelNKLRayon(ARAY_ID , ACEN_CODE: integer);
      procedure DelNKLSECTEUR(ASEC_ID , ACEN_CODE: Integer);

      procedure DoAssignIDToCode(ACode : string;AID : Integer);

      
      procedure ConstruireArborescence;

      procedure ConstruireSousRayon(vpCodePere : String ; vpCentrale : Integer);
      procedure ConstruireSegment(vpCodePere : String ; vpCentrale : Integer);
      procedure ConstruireSousFamille(vpCodePere : String ; vpCentrale : Integer);

      function  IndiqueDepartement(vpCode : String) : String;
      function  RechercheNoeudPere(vpArbre : TTreeView) : TTreeNode;
      procedure InsererLeNoeud(vpCodePere, vpCodeFils : String;
                               vpNiveau, vpCentrale : Integer; vpMAJ_Flag : Boolean = True);
      procedure ActiverFiltre(vpCodePere : String);

      procedure CDS_IndiqueLesNoms;
      procedure CDS_RendreTousLesEnfantsInactifs;
      procedure CDS_DesactiverEnfant(vpCodePere : String);

      procedure Arbre_RemplacerCodeParNom(vpArbre : TTreeView);

      procedure ChargerNomenclatureGinkoia;
      procedure CDS_DupliquerNomenclature;
      procedure CDS_MettreAjourIdPere(vpCode : String; vpNewId : Integer);
      procedure ChargerDepuisTable(vpTable, vpPrefixe, vpIdParent : String; vpCDS : TClientDataSet);

      function  CodeExiste: Boolean;
      function  IndiqueLeCDS(vpNiveau : Integer) : TClientDataSet;
      function  IndiqueIdParent(vpCode : String) : Integer;
      function  DB_INSERT_Nomenclature : Boolean;
      function  DB_UPDATE_Nomenclature(vpNiveau, vpIdFils : Integer; vpNom : String) : Boolean;

      procedure PurgerLaNomenclature;
    public
      procedure AfficherArborescence(vpArbre : TTreeView);

      procedure Import; override;
      function  DoMajTable : Boolean; override;

      function  GetIdByCode(ACode : String ; ACenCode : Integer) : Integer; override;

      Constructor Create; override;
      Destructor  Destroy; override;

      function CheckLevel(ACds : TClientDataSet; AValue : String) : Integer;
  end;


implementation

uses GSDataMain_DM;

Constructor TNomenclature.Create;
begin
  Inherited;

  vgNiveauMax := 4;

  FNomenclature     := TMainClass.Create;
  FNomenclatureTEMP := TMainClass.Create;

  FNomFils      := TMainClass.Create;
  FPereFils     := TMainClass.Create;

  FDepartement  := TMainClass.Create;
  FSousRayon    := TMainClass.Create;
  FSegment      := TMainClass.Create;
  FSousFamille  := TMainClass.Create;
  FDepartementLoad  := TMainClass.Create;
  FSousRayonLoad    := TMainClass.Create;
  FSegmentLoad      := TMainClass.Create;
  FSousFamilleLoad  := TMainClass.Create;
  FSousRayonPurge    := TMainClass.Create;
  FSegmentPurge      := TMainClass.Create;
  FSousFamillePurge  := TMainClass.Create;

  
  Ds_Departement := TDataSource.Create(nil);
  Ds_Departement.DataSet := FDepartement.ClientDataset;
  Ds_SousRayon   := TDataSource.Create(nil);
  Ds_SousRayon.DataSet := FSousRayon.ClientDataset;
  Ds_Segment     := TDataSource.Create(nil);
  Ds_Segment.DataSet := FSegment.ClientDataset;

  FARBCAFTmp := TMainClass.Create;
  FGRPCAFTmp := TMainClass.Create;
end;

procedure TNomenclature.CreateCds;
begin
  // Cds Departement
  FDepartement.CreateField(['SEC_ID','SEC_NOM','SEC_CODE','SEC_CENTRALE'],
                           [ftInteger,ftString,ftString,ftInteger]);
  FDepartement.ClientDataset.AddIndex('Idx','SEC_CODE',[]);
  FDepartement.ClientDataset.IndexName := 'Idx';

  FDepartementLoad.CreateField(['SEC_ID','SEC_NOM','SEC_CENTRALE','CANDELETE'],
                               [ftInteger,ftString,ftInteger,ftInteger]);
  FDepartementLoad.ClientDataset.AddIndex('Idx','SEC_ID',[]);
  FDepartementLoad.ClientDataset.IndexName := 'Idx';
  
  // création du CDS SousRayon
  FSousRayon.CreateField(['SEC_CODE','RAY_ID','RAY_SECID','RAY_NOM','RAY_CENTRALE','RAY_CODE'],
                         [ftString, ftInteger,ftInteger,ftString,ftInteger,ftString]);
  FSousRayon.ClientDataset.AddIndex('Idx','SEC_CODE;RAY_CODE',[]);
  FSousRayon.ClientDataset.IndexName := 'Idx';
  FSousRayon.ClientDataset.MasterSource := Ds_Departement;
  FSousRayon.ClientDataset.MasterFields := 'SEC_CODE';

  FSousRayonLoad.CreateField(['RAY_ID','RAY_SECID','RAY_NOM','RAY_CENTRALE','CANDELETE'],
                             [ftInteger,ftInteger,ftString,ftInteger,ftInteger]);
  FSousRayonLoad.ClientDataset.AddIndex('Idx','RAY_ID',[]);
  FSousRayonLoad.ClientDataset.IndexName := 'Idx';

  FSousRayonPurge.CreateField(['RAY_ID','RAY_SECID','RAY_NOM','RAY_CENTRALE','CANDELETE'],
                              [ftInteger,ftInteger,ftString,ftInteger,ftInteger]);
  FSousRayonPurge.ClientDataset.AddIndex('Idx','RAY_ID',[]);
  FSousRayonPurge.ClientDataset.IndexName := 'Idx';

  // création du CDS Segment
  FSegment.CreateField(['FAM_ID','FAM_RAYID','FAM_NOM','FAM_CODE','FAM_CENTRALE','RAY_CODE'],
                       [ftInteger,ftInteger,ftString,ftString,ftInteger,ftString]);
  FSegment.ClientDataset.AddIndex('Idx','RAY_CODE;FAM_CODE',[]);
  FSegment.ClientDataset.IndexName := 'Idx';
  FSegment.ClientDataset.MasterSource := Ds_SousRayon;
  FSegment.ClientDataset.MasterFields := 'RAY_CODE';

  FSegmentLoad.CreateField(['FAM_ID','FAM_RAYID','FAM_NOM','FAM_CENTRALE','CANDELETE'],
                       [ftInteger,ftInteger,ftString,ftInteger,ftInteger]);
  FSegmentLoad.ClientDataset.AddIndex('Idx','FAM_ID',[]);
  FSegmentLoad.ClientDataset.IndexName := 'Idx';

  FSegmentPurge.CreateField(['FAM_ID','FAM_RAYID','FAM_NOM','FAM_CENTRALE','CANDELETE'],
                       [ftInteger,ftInteger,ftString,ftInteger,ftInteger]);
  FSegmentPurge.ClientDataset.AddIndex('Idx','FAM_ID',[]);
  FSegmentPurge.ClientDataset.IndexName := 'Idx';
  
  // création du CDS SousFamille
  FSousFamille.CreateField(['SSF_ID','SSF_FAMID','SSF_NOM','SSF_CODE','SSF_CENTRALE','FAM_CODE'],
                           [ftInteger,ftInteger,ftString,ftString,ftInteger,ftString]);
  FSousFamille.ClientDataset.AddIndex('Idx','FAM_CODE;SSF_CODE',[]);
  FSousFamille.ClientDataset.IndexName := 'Idx';
  FSousFamille.ClientDataset.MasterSource := Ds_Segment;
  FSousFamille.ClientDataset.MasterFields := 'FAM_CODE';

  FSousFamilleLoad.CreateField(['SSF_ID','SSF_FAMID','SSF_NOM','SSF_CENTRALE','CANDELETE'],
                           [ftInteger,ftInteger,ftString,ftInteger,ftInteger]);
  FSousFamilleLoad.ClientDataset.AddIndex('Idx','SSF_ID',[]);
  FSousFamilleLoad.ClientDataset.IndexName := 'Idx';

  FSousFamillePurge.CreateField(['SSF_ID','SSF_FAMID','SSF_NOM','SSF_CENTRALE','CANDELETE'],
                           [ftInteger,ftInteger,ftString,ftInteger,ftInteger]);
  FSousFamillePurge.ClientDataset.AddIndex('Idx','SSF_ID',[]);
  FSousFamillePurge.ClientDataset.IndexName := 'Idx';
  // Copie du CDS contenant l'arborescence dans un autre CDS
//  FARBCAFTmp.ClientDataset.CloneCursor(DM_GSDataImport.cds_ARBCAF, False, False);

  // Création d'un nouveau Cds temporaire contenant les données du GRPCAF
  FGRPCAFTmp.CreateField(['CODE_LANGUE', 'CODE_GROUPE', 'LIBELLE_GROUPE','NIVEAU', 'ID', 'CEN_CODE'],
                         [ftString, ftString, ftString, ftInteger, ftInteger, ftInteger]);
  FGRPCAFTmp.ClientDataset.AddIndex('Idx','CODE_GROUPE',[]);
  FGRPCAFTmp.ClientDataset.IndexName := 'Idx';
end;

procedure TNomenclature.DelNKLFAMILLE(AFAM_ID, ACEN_CODE: Integer);
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    if FBaseVersion = 1
      then SQL.Add('EXECUTE PROCEDURE GOS_DELNKLFAMILLE(:PFAMID)');
    if FBaseVersion = 2
      then SQL.Add('EXECUTE PROCEDURE GOS_DELNKLFAMILLE(:PFAMID, :CENCODE)');
    ParamCheck := True;
    ParamByName('PFAMID').AsInteger := AFAM_ID;
    if FBaseVersion = 2
      then ParamByName('CENCODE').AsInteger := ACEN_CODE;
    ExecSQL;
  Except on E:eXception do
    raise Exception.Create('DelNKLFAMILLE -> ' + E.Message);
  end;
end;

procedure TNomenclature.DelNKLRayon(ARAY_ID, ACEN_CODE: integer);
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    if FBaseVersion = 1
      then SQL.Add('EXECUTE PROCEDURE GOS_DELNKLRAYON(:PRAYID)');
    if FBaseVersion = 2
      then SQL.Add('EXECUTE PROCEDURE GOS_DELNKLRAYON(:PRAYID, :CENCODE)');
    ParamCheck := True;
    ParamByName('PRAYID').AsInteger := ARay_ID;
    if FBaseVersion = 2
      then ParamByName('CENCODE').AsInteger := ACEN_CODE;
    ExecSQL;
  Except on E:eXception do
    raise Exception.Create('DelNKLRayon -> ' + E.Message);
  end;

end;

procedure TNomenclature.DelNKLSECTEUR(ASEC_ID, ACEN_CODE: Integer);
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    if FBaseVersion = 1
      then SQL.Add('EXECUTE PROCEDURE GOS_DELNKLSECTEUR(:PSECID)');
    if FBaseVersion = 2
      then SQL.Add('EXECUTE PROCEDURE GOS_DELNKLSECTEUR(:PSECID, :CENCODE)');
    ParamCheck := True;
    ParamByName('PSECID').AsInteger := ASEC_ID;
    if FBaseVersion = 2
      then ParamByName('CENCODE').AsInteger := ACEN_CODE;
    ExecSQL;
  Except on E:eXception do
    raise Exception.Create('DelNKLSECTEUR -> ' + E.Message);
  end;

end;

procedure TNomenclature.DelNKLSSFAMILLE(ASSF_ID, ACEN_CODE: Integer);
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    if FBaseVersion = 1
      then SQL.Add('EXECUTE PROCEDURE GOS_DELNKLSSFAMILLE(:PSSFID)');
    if FBaseVersion = 2
      then SQL.Add('EXECUTE PROCEDURE GOS_DELNKLSSFAMILLE(:PSSFID, :CENCODE)');
    ParamCheck := True;
    ParamByName('PSSFID').AsInteger  := ASSF_ID;
    if FBaseVersion = 2
      then ParamByName('CENCODE').AsInteger := ACEN_CODE;
    ExecSQL;
  Except on E:eXception do
    raise Exception.Create('DelNKLSSFAMILLE -> ' + E.Message);
  end;
end;

Destructor TNomenclature.Destroy;
begin
  FARBCAFTmp.Free;
  FGRPCAFTmp.Free;

  FNomenclature.Free;
  FNomenclatureTEMP.Free;
  FNomFils.Free;
  FPereFils.Free;

  FDepartement.Free;
  FSousRayon.Free;
  FSegment.Free;
  FSousFamille.Free;
  FDepartementLoad.Free;
  FSousRayonLoad.Free;
  FSegmentLoad.Free;
  FSousFamilleLoad.Free;
  FSousRayonPurge.Free;
  FSegmentPurge.Free;
  FSousFamillePurge.Free;

  Inherited;
end;


//------------------------------------------------------------------------------
//                                             +-------------------------------+
//                                             |   Construction Arborescence   |
//                                             +-------------------------------+
//------------------------------------------------------------------------------

//--------------------------------------------------> ConstruireArborescence

procedure TNomenclature.ConstruireArborescence;
  {$REGION 'Rafraichissement du filtre'}
  procedure RafraichirFiltre;
  begin
    with FPereFils.ClientDataset do
    begin
      Filtered := False;
      Filter   := 'NPF_UTILISE=0';
      Filtered := True;

      First;
    end;
  end;
  {$ENDREGION 'Rafraichissement du filtre'}
var
  vCodeFils : String;
  vCentrale : Integer ;
begin
  case FMagType of
    mtCourir:   vCentrale := CTE_COURIR ;
    mtGoSport:  vCentrale := CTE_GOSPORT ;
  end;

  FNomenclature.ClientDataset.EmptyDataSet;

  with FPereFils.ClientDataset do
  begin
    vgMax := RecordCount + 1;
    vgIdx := 1;

    LabCaption('Reconstruction de la nomenclature en mémoire');
    BarPosition(0);

    RafraichirFiltre;

    while not Eof do
    begin
      vCodeFils := IndiqueDepartement(FieldByName('NPF_CODEPERE').AsString);

      // Insert le noeud département
      InsererLeNoeud('', vCodeFils, 1, vCentrale, False);
      ConstruireSousRayon(vCodeFils, vCentrale);

      RafraichirFiltre;

      vgIdx := vgIdx + 1;
      BarPosition(vgIdx * 100 Div vgMax);
    end;

    Filtered := False;
  end;

  FNomenclature.ClientDataset.Filtered := False;
  FPereFils.ClientDataset.Filtered     := False;

  CDS_IndiqueLesNoms;
end;

//-----------------------------------------------------> ConstruireSousRayon

procedure TNomenclature.ConstruireSousRayon(vpCodePere : String ; vpCentrale : Integer);
var
  vCodeFils : String;
begin
  with FPereFils.ClientDataset do
  begin
    // Activation du filtre pour que seul les noeuds concernés soient affichés
    ActiverFiltre(vpCodePere);

    while not EoF do
    begin
      vCodeFils := FieldByName('NPF_CODEFILS').AsString;

      InsererLeNoeud(vpCodePere, vCodeFils , 2, vpCentrale);
      ConstruireSegment(vCodeFils, vpCentrale);

      ActiverFiltre(vpCodePere);

      vgIdx := vgIdx + 1;
      BarPosition(vgIdx * 100 Div vgMax + 1);
    end;
  end;
end;

//-------------------------------------------------------> ConstruireSegment

procedure TNomenclature.ConstruireSegment(vpCodePere : String ; vpCentrale : Integer);
var
  vCodeFils : String;
begin
  with FPereFils.ClientDataset do
  begin
    // Activation du filtre pour que seul les noeuds concernés soient affichés
    ActiverFiltre(vpCodePere);

    while not Eof do
    begin
      vCodeFils := FieldByName('NPF_CODEFILS').AsString;

      InsererLeNoeud(vpCodePere, vCodeFils , 3, vpCentrale);
      ConstruireSousFamille(vCodeFils, vpCentrale);

      ActiverFiltre(vpCodePere);

      vgIdx := vgIdx + 1;
      BarPosition(vgIdx * 100 Div vgMax);
    end;
  end;
end;

//---------------------------------------------------> ConstruireSousFamille

procedure TNomenclature.ConstruireSousFamille(vpCodePere : String ; vpCentrale : Integer);
begin
  with FPereFils.ClientDataset do
  begin
    // Activation du filtre pour que seul les noeuds concernés soient affichés
    ActiverFiltre(vpCodePere);

    while not Eof do
    begin
      InsererLeNoeud(vpCodePere, FieldByName('NPF_CODEFILS').AsString, 4, vpCentrale);

      ActiverFiltre(vpCodePere);

      vgIdx := vgIdx + 1;
      BarPosition(vgIdx * 100 Div vgMax);
    end;
  end;
end;

//------------------------------------------------------------------------------
//                                                  +--------------------------+
//                                                  |   Outils Construction    |
//                                                  +--------------------------+
//------------------------------------------------------------------------------

//------------------------------------------------------> IndiqueDepartement

function TNomenclature.IndiqueDepartement(vpCode : String) : String;
var
  vCodeFils, vCodePere : String;
  vRacineTrouve : Boolean;
begin
  vCodeFils     := vpCode;
  vCodePere     := vpCode;
  vRacineTrouve := False;

  while not vRacineTrouve do
  begin
    // si aucun noeud père n'est trouvé, c'est que ce noeud est la racine
    if not FPereFils.ClientDataset.Locate('NPF_CODEFILS', vCodePere, [loCaseInsensitive]) then
      vRacineTrouve := True
    else
      vCodePere := FPereFils.ClientDataset.FieldByName('NPF_CODEPERE').AsString;
  end;

  Result := vCodePere;
end;

//----------------------------------------------------------> InsererLeNoeud

procedure TNomenclature.InsererLeNoeud(vpCodePere, vpCodeFils : String;
vpNiveau, vpCentrale : Integer; vpMAJ_Flag : Boolean);
begin
  with FPereFils.ClientDataset do
  begin
    {$REGION ' Insertion du noeud dans FNomenclature'}
    FNomenclature.ClientDataset.Append;

    FNomenclature.ClientDataset.FieldByName('NOM_ID').AsInteger        := 0;
    FNomenclature.ClientDataset.FieldByName('NOM_CODE').AsString       := vpCodeFils;
    FNomenclature.ClientDataset.FieldByName('NOM_NOM').AsString        := '';
    FNomenclature.ClientDataset.FieldByName('NOM_CODEPERE').AsString   := vpCodePere;
    FNomenclature.ClientDataset.FieldByName('NOM_NIVEAU').AsInteger    := vpNiveau;
    FNomenclature.ClientDataset.FieldByName('CEN_CODE').AsInteger      := vpCentrale;
    FNomenclature.ClientDataset.FieldByName('LIBELLEEXISTE').AsInteger := 1;

    FNomenclature.ClientDataset.Post;
    {$ENDREGION ' Insertion du noeud dans FNomenclature'}

    if vpMAJ_Flag then
    begin
      {$REGION ' Mise à jour du flag de FPereFils'}
      Edit;
      FieldByName('NPF_UTILISE').AsInteger := 1;
      Post;
      {$ENDREGION ' Insertion du noeud dans FNomenclature'}
    end;
  end;
end;

//-----------------------------------------------------------> ActiverFiltre

procedure TNomenclature.ActiverFiltre(vpCodePere : String);
begin
  with FPereFils.ClientDataset do
  begin
    Filtered := False;
    Filter   := 'NPF_CODEPERE=' + QuotedStr(vpCodePere) + ' and NPF_UTILISE=0';
    Filtered := True;

    First;
  end;
end;

//------------------------------------------------------> CDS_IndiqueLesNoms

procedure TNomenclature.CDS_IndiqueLesNoms;
var
  vCode, vLibelleCode : String;
begin
  with FNomenclature.ClientDataset do
  begin
    Filtered := False;
    First;

    LabCaption('Attribution des noms de la nomenclature en mémoire');
    BarPosition(0);

    while not Eof do
    begin
      vCode := FieldbyName('NOM_CODE').AsString;

      if FNomFils.ClientDataset.Locate('FIL_CODE', vCode, [loCaseInsensitive]) then
        vLibelleCode := FNomFils.ClientDataset.FieldbyName('FIL_NOM').AsString
      else
        vLibelleCode := '<Non trouvé>';

      Edit;
      FieldbyName('NOM_NOM').AsString := vLibelleCode;

      // si le libelle n'a pas été trouvé dans le fichier d'import
      if vLibelleCode = '<Non trouvé>' then
        FieldbyName('LIBELLEEXISTE').AsInteger := 0;

      Post;

      Next;
      BarPosition(RecNo * 100 Div (RecordCount + 1));
    end;
  end;

  CDS_RendreTousLesEnfantsInactifs;
end;

//----------------------------------------> CDS_RendreTousLesEnfantsInactifs

procedure TNomenclature.CDS_RendreTousLesEnfantsInactifs;
  {$REGION 'Rafraichissement du filtre'}
  procedure RafraichirFiltreParNiveau(vpNiveau : Integer);
  begin
    // on va filtrer par niveau et sur les noeuds n'ayant pas de nom trouvé
    with FNomenclature.ClientDataset do
    begin
      Filtered := False;
      Filter   := 'NOM_NIVEAU=' + IntToStr(vpNiveau);
      Filter   := Filter + ' and LIBELLEEXISTE=0';
      Filtered := True;

      First;
    end;
  end;
  {$ENDREGION 'Rafraichissement du filtre'}
var
  vNiveau, vIx : Integer;
  vCodePere    : String;
  vFinDeBoucle : Boolean;
begin
 // on va lire CDS_nomenclature par niveau
  with FNomenclature.ClientDataset do
  begin
    LabCaption('Désactiver les éléments de nomenclature n''ayant pas de nom');
    BarPosition(0);

    vIx          := 0;
    vNiveau      := 1;
    vFinDeBoucle := False;

    RafraichirFiltreParNiveau(vNiveau);
//    First;
    while not vFinDeBoucle do
    begin
      vCodePere := FieldByName('NOM_CODE').AsString;

      if vCodePere <> '' then
      begin
        // on indique pour tous ses enfants que le libellé n'existe pas
        CDS_DesactiverEnfant(vCodePere);

        // on rafraichi la liste et on se replace sur le bon noeud
        RafraichirFiltreParNiveau(vNiveau);
        Locate('NOM_CODE', vCodePere, [loCaseInsensitive]);
      end;

      Next;
      INC(vIx);
      BarPosition(vIx * 100 div (RecordCount + 1));

      {$REGION 'Tests et traitement de fin de boucle'}
      // Si on est sur le dernier niveau, le traiteùent est terminé
      if EoF then
      begin
        if vNiveau = vgNiveauMax then
          vFinDeBoucle := True
        else
        begin
          vNiveau := vNiveau + 1;
          RafraichirFiltreParNiveau(vNiveau);
        end
      end;
      {$ENDREGION 'Tests et traitement de fin de boucle'}
    end;
  end;
end;

//----------------------------------------------------> CDS_DesactiverEnfant

procedure TNomenclature.CDS_DesactiverEnfant(vpCodePere : String);
begin
  with FNomenclature.ClientDataset do
  begin
    Filtered := False;
    Filter   := 'NOM_CODEPERE=' + QuotedStr(vpCodePere);
    Filtered := True;

    First;

    while not EoF do
    begin
      Edit;
      FieldByName('LIBELLEEXISTE').AsInteger := 0;
      Post;

      Next;
    end;
  end;
end;

//-----------------------------------------------> CDS_DupliquerNomenclature

procedure TNomenclature.CDS_DupliquerNomenclature;
begin
  with FNomenclature.ClientDataset do
  begin
    Filtered := False;
    First;

    FNomenclatureTEMP.ClientDataset.EmptyDataSet;

    while not Eof do
    begin
      FNomenclatureTEMP.ClientDataset.Append;
      FNomenclatureTEMP.ClientDataset.FieldbyName('NOM_CODE').AsString     := FieldbyName('NOM_CODE').AsString;
      FNomenclatureTEMP.ClientDataset.FieldbyName('NOM_CODEPERE').AsString := FieldbyName('NOM_CODEPERE').AsString;
      FNomenclatureTEMP.ClientDataset.FieldbyName('NOM_IDPERE').AsInteger  := 0;
      FNomenclatureTEMP.ClientDataset.Post;

      Next;
    end;
  end;
end;

//------------------------------------------------------------------------------
//                                                  +--------------------------+
//                                                  |   Affichage de l'arbre   |
//                                                  +--------------------------+
//------------------------------------------------------------------------------

//----------------------------------------------------> AfficherArborescence

procedure TNomenclature.AfficherArborescence(vpArbre : TTreeView);
var
  vNiveau      : Integer;
  vFinDeBoucle : Boolean;
  vNoeudPere   : TTreeNode;
begin
  vpArbre.Items.BeginUpdate;
  vpArbre.Items.Clear;

  vFinDeBoucle := False;
  vNiveau      := 1;

  with FNomenclature.ClientDataset do
  begin
    Filtered := False;
    Filter   := 'NOM_NIVEAU=' + IntToStr(vNiveau);
    Filtered := True;

    First;
  end;

  while not vFinDeBoucle do
  begin
    with FNomenclature.ClientDataset do
    begin
      if FieldbyName('NOM_NIVEAU').AsInteger = vNiveau then
      begin
        vNoeudPere := RechercheNoeudPere(vpArbre);
        vpArbre.Items.AddChild(vNoeudPere, FieldbyName('NOM_CODE').AsString);
      end;

      Next;

      if EoF then
      begin
        if vNiveau = vgNiveauMax then
          vFinDeBoucle := True
        else
        begin
          vNiveau := vNiveau + 1;

          Filtered := False;
          Filter   := 'NOM_NIVEAU=' + IntToStr(vNiveau);
          Filtered := True;

          First;
        end;
      end;
    end;
  end;

  Arbre_RemplacerCodeParNom(vpArbre);

  vpArbre.Selected := vpArbre.TopItem;
  vpArbre.Items.EndUpdate;
end;

//------------------------------------------------------> RechercheNoeudPere

function TNomenclature.RechercheNoeudPere(vpArbre : TTreeView) : TTreeNode;
var
  vIx       : Integer;
  vCodePere : String;
begin
  if FNomenclature.ClientDataset.FieldbyName('NOM_NIVEAU').AsInteger = 1 then
  begin
    Result := nil;
    Exit;
  end;

  vCodePere := FNomenclature.ClientDataset.FieldbyName('NOM_CODEPERE').AsString;

  if vpArbre.Items.Count > 0 then
    for vIx := 0 to vpArbre.Items.Count do
      if vpArbre.Items.Item[vIx].Text = vCodePere then
      begin
        Result := vpArbre.Items.Item[vIx];
        Exit;
      end;

  Result := nil;
end;

function TNomenclature.SetNKLFAMILLE(AFAM_RAYID: Integer; AFAM_CODE,
  AFAM_NOM: string; AFAM_CENTRALE: integer): integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETNKLFAMILLE(:PRAYID, :PFAMCODE, :PFAMNOM, :PFAMCENTRALE)');
    ParamCheck := True;
    ParamByName('PRAYID').AsInteger       := AFAM_RAYID;
    ParamByName('PFAMCODE').AsString      := AFAM_CODE;
    ParamByName('PFAMNOM').AsString       := AFAM_NOM;
    ParamByName('PFAMCENTRALE').AsInteger := AFAM_CENTRALE;
    Open;
    
    if RecordCount > 0 then
    begin
      Result := FieldByName('FAM_ID').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;
  
  Except on E:Exception do
    raise Exception.Create('SetNKLFAMILLE -> ' + E.Message);
  end;
end;

function TNomenclature.SetNKLRAYON(ARAY_SECID, ARAY_UNIID: integer; ARAY_CODE,
  ARAY_NOM: string; ARAY_CENTRALE: integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETNKLRAYON(:PSECID, :PUNIID, :PRAYCODE, :PRAYNOM, :PRAYCENTRALE)');
    ParamCheck := True;
    ParamByName('PSECID').AsInteger       := ARAY_SECID;
    ParamByName('PUNIID').AsInteger       := ARAY_UNIID;
    ParamByName('PRAYCODE').AsString      := ARAY_CODE;
    ParamByName('PRAYNOM').AsString       := ARAY_NOM;
    ParamByName('PRAYCENTRALE').AsInteger := ARAY_CENTRALE;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('RAY_ID').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;
  Except on E:Exception do
    raise Exception.Create('SetNKLRAYON -> ' + E.Message);
  end;
end;

function TNomenclature.SetNKLSECTEUR(ASEC_CODE, ASEC_NOM: String; ASEC_UNIID,
  ASEC_CENTRALE: integer): integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETNKLSECTEUR(:PSECCODE, :PSECNOM, :PSECUNIID, :PSECCENTRALE)');
    ParamCheck := True;
    ParamByName('PSECCODE').AsString := ASEC_CODE;
    ParamByName('PSECNOM').AsString  := ASEC_NOM;
    ParamByName('PSECUNIID').AsInteger  := ASEC_UNIID;
    ParamByName('PSECCENTRALE').AsInteger := ASEC_CENTRALE;
    Open;

    if recordcount > 0 then
    begin
      Result := FieldByName('SEC_ID').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;
  Except on E:Exception do
    raise Exception.Create('SetNKLSECTEUR -> ' + E.Message);
  end;
end;

function TNomenclature.SetNKLSSFAMILLE(ASSF_FAMID: integer; ASSF_CODE,
  ASSF_NOM: string; ASSF_TVAID, ASSF_TCTID, ASSF_CENTRALE: integer): integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETNKLSSFAMILLE(:PFAMID, :PSSFCODE, :PSSFNOM, :PTVAID, :PTCTID, :PSSFCENTRALE)');
    ParamCheck := True;
    ParamByName('PFAMID').AsInteger := ASSF_FAMID;
    ParamByName('PSSFCODE').AsString := ASSF_CODE;
    ParamByName('PSSFNOM').AsString  := ASSF_NOM;
    ParamByName('PTVAID').AsInteger  := ASSF_TVAID;
    ParamByName('PTCTID').AsInteger  := ASSF_TCTID;
    ParamByName('PSSFCENTRALE').AsInteger := ASSF_CENTRALE;
    Open;

    if recordcount > 0 then
    begin
      Result := FieldByName('SSF_ID').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;
    
  Except on E:Exception do
    raise Exception.Create('SetNKLSSFAMILLE -> ' + E.Message);
  end;
end;

//-----------------------------------------------> Arbre_RemplacerCodeParNom

procedure TNomenclature.Arbre_RemplacerCodeParNom(vpArbre : TTreeView);
var
  vCode, vLibelleCode : String;
  vIx, vNbTotal : Integer;
begin
  vpArbre.Items.BeginUpdate;
  vNbTotal := vpArbre.Items.Count - 1;

  for vIx := 0 to vnbTotal do
  begin
    vCode := Trim(vpArbre.Items.Item[vIx].Text);

    if FNomFils.ClientDataset.Locate('FIL_CODE', vCode, [loCaseInsensitive]) then
      vLibelleCode := FNomFils.ClientDataset.FieldbyName('FIL_NOM').AsString
    else
      vLibelleCode := '<Non trouvé>';

    vpArbre.Items.Item[vIx].Text := vLibelleCode;
  end;

  vpArbre.Items.EndUpdate;
end;

//------------------------------------------------------------------------------
//                                                                 +-----------+
//                                                                 |   Import  |
//                                                                 +-----------+
//------------------------------------------------------------------------------

//------------------------------------------------------------------> Import

procedure TNomenclature.Import;
var
  sPrefixe : String;
  iNiveau, i : Integer;
begin

  // Mise du nom de fichier en variable générale
  for i := Low(FilesPath) to High(FilesPath) do
  begin
    sPrefixe := Copy(FilesPath[i],1,6);
    case AnsiIndexStr(UpperCase(sPrefixe),['GRPCAF','ARBCAF']) of
      0 : FGRPCAF_File := FilesPath[i];
      1 : FARBCAF_File := FilesPath[i];
    end;
  end;

  // Création des champs des divers cds utilisés
  CreateCds;
  
  // Copie des données du GRPCAF dans un nouveau CDS
  With DM_GSDataImport.cds_GRPCAF do
  begin
    FCount := RecordCount;
    First;
    while not EOF do
    begin
      // Recherche du niveau dans l'arborescence du code en cours.
      iNiveau := CheckLevel(DM_GSDataImport.cds_ARBCAF,FieldByName('CODE_GROUPE').AsString);

      if iNiveau > 4 then
        raise Exception.Create('Plus de 4 niveaux détectés fichier rejeté');

      FGRPCAFTmp.Append;
      FGRPCAFTmp.FieldByName('CODE_LANGUE').AsString    := FieldByName('CODE_LANGUE').AsString;
      FGRPCAFTmp.FieldByName('CODE_GROUPE').AsString    := FieldByName('CODE_GROUPE').AsString;
      FGRPCAFTmp.FieldByName('LIBELLE_GROUPE').AsString := FieldByName('LIBELLE_GROUPE').AsString;
      FGRPCAFTmp.FieldByName('NIVEAU').AsInteger        := iNiveau;
      FGRPCAFTmp.FieldByName('ID').AsInteger            := -1;
      case FMagType of
        mtCourir:  FGRPCAFTmp.FieldByName('CEN_CODE').AsInteger      := CTE_COURIR ;
        mtGoSport: FGRPCAFTmp.FieldByName('CEN_CODE').AsInteger      := CTE_GOSPORT ;
      end;
      FGRPCAFTmp.Post;
      Next;
    end;
  end;

  // Dispatch des données dans les différentes tables en mémoire
  for i := 1 to 4 do
  begin
    FGRPCAFTmp.ClientDataset.Filtered := False;
    FGRPCAFTmp.ClientDataset.Filter := 'NIVEAU = ' + IntToStr(i);
    FGRPCAFTmp.ClientDataset.Filtered := True;
    FGRPCAFTmp.First;

    case i of
      1: begin // traitement du département
        With FGRPCAFTmp do
          while not Eof do
          begin
            FDepartement.Append;
            FDepartement.FieldByName('SEC_NOM').AsString := FieldbyName('LIBELLE_GROUPE').AsString;
            FDepartement.FieldByName('SEC_CODE').AsString := FieldbyName('CODE_GROUPE').AsString;
            FDepartement.FieldByName('SEC_CENTRALE').AsInteger := FieldbyName('CEN_CODE').AsInteger;
            FDepartement.Post;
            Next;
          end;
      end;
      2: begin // traitement du SousRayon
        With FGRPCAFTmp do
          while not EOF do
          begin
            // Recherche du parent
            DM_GSDataImport.cds_ARBCAF.Locate('CGRP_F',FieldByName('CODE_GROUPE').AsString,[loCaseInsensitive]);

            FSousRayon.Append;
            FSousRayon.FieldByName('RAY_NOM').AsString := FieldByName('LIBELLE_GROUPE').AsString;
            FSousRayon.FieldByName('RAY_CODE').AsString := FieldByName('CODE_GROUPE').AsString;
            FSousRayon.FieldByName('SEC_CODE').AsString := DM_GSDataImport.cds_ARBCAF.fieldByName('CGRP_P').AsString;
            FSousRayon.FieldByName('RAY_CENTRALE').AsInteger := FieldByName('CEN_CODE').AsInteger ;
            FSousRayon.Post;
            Next;
          end;
      end;

      3: begin  // traitement du Segment
        With FGRPCAFTmp do
          while not EOF do
          begin
            // Recherche du parent
            DM_GSDataImport.cds_ARBCAF.Locate('CGRP_F',FieldByName('CODE_GROUPE').AsString,[loCaseInsensitive]);

            FSegment.Append;
            FSegment.FieldByName('FAM_NOM').AsString := FieldByName('LIBELLE_GROUPE').AsString;
            FSegment.FieldByName('FAM_CODE').AsString := FieldByName('CODE_GROUPE').AsString;
            FSegment.FieldByName('RAY_CODE').AsString := DM_GSDataImport.cds_ARBCAF.fieldByName('CGRP_P').AsString;
            FSegment.FieldByName('FAM_CENTRALE').AsInteger := FieldByName('CEN_CODE').AsInteger ;
            FSegment.Post;
            Next;
          end;
      end;

      4: begin  // traitement de la sousfamille
        With FGRPCAFTmp do
          while not EOF do
          begin
            // Recherche du parent
            DM_GSDataImport.cds_ARBCAF.Locate('CGRP_F',FieldByName('CODE_GROUPE').AsString,[loCaseInsensitive]);

            FSousFamille.Append;
            FSousFamille.FieldByName('SSF_NOM').AsString := FieldByName('LIBELLE_GROUPE').AsString;
            FSousFamille.FieldByName('SSF_CODE').AsString := FieldByName('CODE_GROUPE').AsString;
            FSousFamille.FieldByName('FAM_CODE').AsString := DM_GSDataImport.cds_ARBCAF.fieldByName('CGRP_P').AsString;
            FSousFamille.FieldByName('SSF_CENTRALE').AsInteger := FieldByName('CEN_CODE').AsInteger ;
            FSousFamille.Post;
            Next;
          end;
      end;
    end;
  end;



//  {$REGION 'Initialisation des CDS'}
//  // Création du CDS Nomenclature => pour construction de l'arborescence
//  FNomenclature.CreateField(['NOM_ID','NOM_CODE','NOM_NOM','NOM_CODEPERE', 'NOM_NIVEAU', 'LIBELLEEXISTE'],
//                             [ftInteger, ftString, ftString, ftString, ftInteger, ftInteger]);
//  FNomenclature.ClientDataset.AddIndex('Idx','NOM_CODE',[]);
//  FNomenclature.ClientDataset.IndexName := 'Idx';
//
//  // Création du CDS NomenclatureTEMP => pour stocker les ID crées et faire une recherche rapide
//  FNomenclatureTEMP.CreateField(['NOM_CODE','NOM_CODEPERE', 'NOM_IDPERE'],
//                                [ftString, ftString, ftInteger]);
//  FNomenclatureTEMP.ClientDataset.AddIndex('Idx','NOM_CODE',[]);
//  FNomenclatureTEMP.ClientDataset.IndexName := 'Idx';
//
//  // Création du CDS PereFils (venant du fichier) en mémoire
//  FPereFils.CreateField(['NPF_CODEPERE','NPF_CODEFILS','NPF_UTILISE'],
//                        [ftString, ftString, ftInteger]);
//  FPereFils.ClientDataset.AddIndex('Idx','NPF_CODEPERE',[]);
//  FPereFils.ClientDataset.IndexName := 'Idx';
//
//  // Création du CDS des noms de la nomenclature (venant du fichier) en mémoire
//  FNomFils.CreateField(['FIL_CODE','FIL_NOM'],
//                       [ftString, ftString]);
//  FNomFils.ClientDataset.AddIndex('Idx','FIL_CODE',[]);
//  FNomFils.ClientDataset.IndexName := 'Idx';
//
//  {$ENDREGION 'Initialisation des CDS'}
//
//  {$REGION 'Recopie dans FPereFils depuis le fichier'}
//  with DM_GSDataImport.cds_ARBCAF do
//  begin
//    First;
//
//    LabCaption('Importation du fichier ' + FGRPSFA_File);
//    BarPosition(0);
//
//    while not Eof do
//    begin
//      FPereFils.ClientDataset.Append;
//
//      FPereFils.ClientDataset.FieldByName('NPF_CODEPERE').AsString := FieldByName('CGRP_P').AsString;
//      FPereFils.ClientDataset.FieldByName('NPF_CODEFILS').AsString := FieldByName('CGRP_F').AsString;
//      FPereFils.ClientDataset.FieldByName('NPF_UTILISE').AsInteger := 0;
//
//      FPereFils.ClientDataset.Post;
//
//      Next;
//      BarPosition(RecNo * 100 Div (RecordCount + 1));
//    end;
//  end;
//  {$ENDREGION 'Recopie dans FPereFils depuis le fichier'}
//
//  {$REGION 'Recopie dans FNomFils depuis le fichier'}
//  with DM_GSDataImport.cds_GRPCAF do
//  begin
//    First;
//
//    LabCaption('Importation du fichier des noms');
//    BarPosition(0);
//
//    while not Eof do
//    begin
//      FNomFils.ClientDataset.Append;
//
//      FNomFils.ClientDataset.FieldByName('FIL_CODE').AsString := FieldByName('CODE_GROUPE').AsString;
//      FNomFils.ClientDataset.FieldByName('FIL_NOM').AsString  := FieldByName('LIBELLE_GROUPE').AsString;
//
//      FNomFils.ClientDataset.Post;
//
//      Next;
//      BarPosition(RecNo * 100 Div (RecordCount + 1));
//    end;
//  end;
//  {$ENDREGION 'Recopie dans FNomFils depuis le fichier'}
//
//  ConstruireArborescence;
end;

//------------------------------------------------------------------------------
//                                                              +--------------+
//                                                              |  Chargement  |
//                                                              +--------------+
//------------------------------------------------------------------------------

//----------------------------------------------> ChargerNomenclatureGinkoia

procedure TNomenclature.ChargerNomenclatureGinkoia;
begin
  {$REGION 'Initialisation de la nomenclature Ginkoia'}
  // création du CDS Departement
  FDepartement.CreateField(['SEC_ID','SEC_NOM','SEC_CODE','SEC_CENTRALE','SEC_UTILISE'],
                           [ftInteger,ftString,ftString,ftInteger,ftInteger]);
  FDepartement.ClientDataset.AddIndex('Idx','SEC_CODE',[]);
  FDepartement.ClientDataset.IndexName := 'Idx';

  // création du CDS SousRayon
  FSousRayon.CreateField(['RAY_ID','RAY_IDPARENT','RAY_NOM','RAY_CODE','RAY_CENTRALE','RAY_UTILISE'],
                         [ftInteger,ftInteger,ftString,ftString,ftInteger,ftInteger]);
  FSousRayon.ClientDataset.AddIndex('Idx','RAY_CODE',[]);
  FSousRayon.ClientDataset.IndexName := 'Idx';

  // création du CDS Segment
  FSegment.CreateField(['FAM_ID','FAM_IDPARENT','FAM_NOM','FAM_CODE','FAM_CENTRALE','FAM_UTILISE'],
                       [ftInteger,ftInteger,ftString,ftString,ftInteger,ftInteger]);
  FSegment.ClientDataset.AddIndex('Idx','FAM_CODE',[]);
  FSegment.ClientDataset.IndexName := 'Idx';

  // création du CDS SousFamille
  FSousFamille.CreateField(['SSF_ID','SSF_IDPARENT','SSF_NOM','SSF_CODE','SSF_CENTRALE','SSF_UTILISE'],
                           [ftInteger,ftInteger,ftString,ftString,ftInteger]);
  FSousFamille.ClientDataset.AddIndex('Idx','SSF_CODE',[]);
  FSousFamille.ClientDataset.IndexName := 'Idx';

  {$ENDREGION 'Initialisation de la nomenclature Ginkoia'}

  ChargerDepuisTable('NKLSECTEUR',   'SEC', '',          FDepartement.ClientDataset);
  ChargerDepuisTable('NKLRAYON',     'RAY', 'RAY_SECID', FSousRayon.ClientDataset);
  ChargerDepuisTable('NKLFAMILLE',   'FAM', 'FAM_RAYID', FSegment.ClientDataset);
  ChargerDepuisTable('NKLSSFAMILLE', 'SSF', 'SSF_FAMID', FSousFamille.ClientDataset);
end;

function TNomenclature.CheckLevel(ACds: TClientDataSet;
  AValue: String): Integer;
begin
  Result := 1;
  if ACds.Locate('CGRP_F',AValue,[loCaseInsensitive]) then
    Result := Result + CheckLevel(ACds,ACds.FieldByName('CGRP_P').AsString);
end;

//------------------------------------------------------> ChargerDepuisTable

procedure TNomenclature.ChargerDepuisTable(vpTable, vpPrefixe,
vpIdParent : String; vpCDS : TClientDataSet);
begin
  with FIboQuery do
  begin
    Close;
    vpCDS.EmptyDataSet;
    SQL.Clear;

    try
      SQL.Add(' select ');
      SQL.Add(vpPrefixe + '_ID   as ID, ');
      SQL.Add(vpPrefixe + '_NOM  as NOM,');
      SQL.Add(vpPrefixe + '_CODE as CODE');
      SQL.Add(vpPrefixe + '_CENTRALE as CENTRALE');

      if vpTable <> 'NKLSECTEUR' then
        SQL.Add(',' + vpIdParent + ' as IDPARENT');

      SQL.Add(' from ' + vpTable);
      SQL.Add(' join K on K_Id = ' + vpPrefixe + '_Id and K_ENABLED = 1');
      SQL.Add(' where ' + vpPrefixe + '_ID <> 0');
      SQL.Add(' and   ' + vpPrefixe + '_CENTRALE = 6');

      Open;

      while not EoF do
      begin
        vpCDS.Append;

        vpCDS.FieldByName(vpPrefixe + '_ID').AsInteger       := FieldByName('ID').AsInteger;
        vpCDS.FieldByName(vpPrefixe + '_NOM').AsString       := FieldByName('NOM').AsString;
        vpCDS.FieldByName(vpPrefixe + '_CODE').AsString      := FieldByName('CODE').AsString;
        vpCDS.FieldByName(vpPrefixe + '_CENTRALE').AsString  := FieldByName('CENTRALE').AsString;
        vpCDS.FieldByName(vpPrefixe + '_UTILISE').AsInteger  := 0;

        if vpTable <> 'NKLSECTEUR' then
          vpCDS.FieldByName(vpPrefixe + '_IDPARENT').AsInteger := FieldByName('IDPARENT').AsInteger;

        vpCDS.Post;

        Next;
      end;

      Close;

    except
      vpCDS.EmptyDataSet;
    end;
  end;
end;


//------------------------------------------------------------------------------
//                                                              +--------------+
//                                                              |  DoMajTable  |
//                                                              +--------------+
//------------------------------------------------------------------------------

//--------------------------------------------------------------> DoMajTable

procedure TNomenclature.DoAssignIDToCode(ACode: string; AID: Integer);
begin
  With FGRPCAFTmp do
  begin
    if ClientDataset.Locate('CODE_GROUPE',ACode,[loCaseInsensitive]) then
    begin
      Edit;
      FieldByName('ID').AsInteger := AID;
      Post;
    end;
  end;
end;

function TNomenclature.DoMajTable : Boolean;
var
  vNiveau, vMax, vIdx : Integer;
  vFinDeBoucle : Boolean;
  Erreur      : TErreur;

  i, iIndex : integer;
  UNI_ID, TVA_ID, TCT_ID, SEC_ID, RAY_ID, FAM_ID, SSF_ID : Integer;
begin
  Try
    // Récupération de l'univers par défaut
    GetGenParam(16,2,UNI_ID);
    // Récupération de la TVA par défaut
    GetGenParam(16,3,TVA_ID);
    // récupération du type comptable par défaut
    GetGenParam(16,5,TCT_ID);

    LabCaption('Génération de la nomenclature');
    BarPosition(0);
    FIboQuery.IB_Transaction.StartTransaction;

    {$REGION 'Récupération de la liste des secteurs de l''univers'}
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select SEC_ID, SEC_NOM, SEC_CENTRALE from NKLSECTEUR');
      SQL.Add('  Join K on K_ID = SEC_ID and K_Enabled = 1');
      SQL.Add('Where SEC_UNIID = :PUNIID');
      case FmagType of
        mtCourir: SQL.Add('  and SEC_CENTRALE = '+IntToStr(CTE_COURIR));
        mtGoSport: SQL.Add('  and SEC_CENTRALE = '+IntToStr(CTE_COURIR));
      end;
      ParamCheck := True;
      ParamByName('PUNIID').AsInteger := UNI_ID;
      Open;

      while not EOF do
      begin  
        FDepartementLoad.Append;
        FDepartementLoad.FieldByName('SEC_ID').AsInteger := FieldByName('SEC_ID').AsInteger;
        FDepartementLoad.FieldByName('SEC_NOM').AsString := FieldByName('SEC_NOM').AsString;
        FDepartementLoad.FieldByName('SEC_CENTRALE').AsInteger := FieldByName('SEC_CENTRALE').AsInteger;
        FDepartementLoad.FieldByName('CANDELETE').AsInteger := 1;
        FDepartementLoad.Post;
        Next;
      end;
    end;
    {$ENDREGION}

    FDepartement.First;
    while not FDepartement.EOF do
    begin
    
    
      // Création du département
      SEC_ID := SetNKLSECTEUR(
                               FDepartement.FieldByName('SEC_CODE').AsString, // ASEC_CODE,
                               FDepartement.FieldByName('SEC_NOM').AsString,  // ASEC_NOM: String;
                               UNI_ID,                                        // ASEC_UNIID,
                               FDepartement.FieldByName('SEC_CENTRALE').AsInteger  // ASEC_CENTRALE: integer)
                              );

      FDepartement.Edit;
      FDepartement.FieldByName('SEC_ID').AsInteger := SEC_ID;
      FDepartement.Post;
      
      DoAssignIDToCode(FDepartement.FieldByName('SEC_CODE').AsString,SEC_ID);

      if FDepartementLoad.ClientDataset.Locate('SEC_ID',SEC_ID,[]) then
      begin
        FDepartementLoad.Edit;
        FDepartementLoad.FieldByName('CANDELETE').AsInteger := 0;
        FDepartementLoad.Post;
      end;
    
      {$REGION 'Mise en mémoire des données du rayon'}
      With FIboQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select RAY_ID, RAY_NOM, RAY_CENTRALE from NKLRAYON');
        SQL.Add('  join K on K_ID = RAY_ID and K_Enabled = 1');
        SQL.Add('Where RAY_SECID = :PSECID');
        SQL.Add('  and RAY_UNIID = :PUNIID');
        SQL.Add('  and RAY_CENTRALE = :CENCODE');
        ParamCheck := True;
        ParamByName('PSECID').AsInteger := SEC_ID;
        ParamByName('PUNIID').AsInteger := UNI_ID;
        case FmagType of
          mtCourir: ParamByName('CENCODE').AsInteger := CTE_COURIR ;
          mtGoSport: ParamByName('CENCODE').AsInteger := CTE_GOSPORT ;
        end;
        Open;
        FSousRayonLoad.ClientDataset.EmptyDataSet;
        while not EOF do
        begin
          FSousRayonLoad.Append;
          FSousRayonLoad.FieldByName('RAY_ID').AsInteger := FieldByName('RAY_ID').AsInteger;
          FSousRayonLoad.FieldByName('RAY_NOM').AsString := FieldByName('RAY_NOM').AsString;
          FSousRayonLoad.FieldByName('RAY_CENTRALE').AsInteger := FieldByName('RAY_CENTRALE').AsInteger;
          FSousRayonLoad.FieldByName('RAY_SECID').AsInteger := SEC_ID;
          FSousRayonLoad.FieldByName('CANDELETE').AsInteger := 1;

          Next;
        end;
      end;
      {$ENDREGION}

      FSousRayon.First;
      while not FSousRayon.EOF do
      begin
        // Création du Rayon
        RAY_ID := SetNKLRAYON(
                              SEC_ID,                                           // ARAY_SECID,
                              0,                                                // ARAY_UNIID: integer;
                              FSousRayon.FieldByName('RAY_CODE').AsString,      // ARAY_CODE,
                              FSousRayon.FieldByName('RAY_NOM').AsString,       // ARAY_NOM: string;
                              FSousRayon.FieldByName('RAY_CENTRALE').AsInteger  // ARAY_CENTRALE: integer
                             );

        FSousRayon.Edit;
        FSousRayon.FieldByName('RAY_SECID').AsInteger := SEC_ID;
        FSousRayon.FieldByName('RAY_ID').AsInteger := RAY_ID;
        FSousRayon.Post;

        DoAssignIDToCode(FSousRayon.FieldByName('RAY_CODE').AsString,RAY_ID);
        
        if FSousRayonLoad.ClientDataset.Locate('RAY_ID',RAY_ID,[]) then
        begin
          FSousRayonLoad.Edit;
          FSousRayonLoad.FieldByName('CANDELETE').AsInteger := 0;
          FSousRayonLoad.Post;
        end;

        {$REGION 'Mise en mémoire des données de la famille'}
        With FIboQuery do
        Begin
          Close;
          SQL.Clear;
          SQL.Add('Select FAM_ID, FAM_NOM, FAM_CENTRALE from NKLFAMILLE');
          SQL.Add('  Join K on K_ID = FAM_ID and K_enabled = 1');
          SQL.Add('Where FAM_RAYID = :PRAYID');
          SQL.Add('  and FAM_CENTRALE = :CENCODE');
          ParamCheck := True;
          ParamByName('PRAYID').AsInteger := RAY_ID;
          case FMagType of
            mtCourir: ParamByName('CENCODE').AsInteger := CTE_COURIR ;
            mtGoSport: ParamByName('CENCODE').AsInteger := CTE_GOSPORT ;
          end;
          Open;

          FSegmentLoad.ClientDataset.EmptyDataSet;
          while not EOF do
          begin
            FSegmentLoad.Append;
            FSegmentLoad.FieldByName('FAM_ID').AsInteger := FieldByName('FAM_ID').AsInteger;
            FSegmentLoad.FieldByName('FAM_NOM').AsString := FieldByName('FAM_NOM').AsString;
            FSegmentLoad.FieldByName('FAM_CENTRALE').AsInteger := FieldByName('FAM_CENTRALE').AsInteger;
            FSegmentLoad.FieldByName('FAM_RAYID').AsInteger := RAY_ID;
            FSegmentLoad.FieldByName('CANDELETE').AsInteger := 1;
            FSegmentLoad.Post;
            
            Next;
          end;
        End;
        {$ENDREGION}

        FSegment.First;
        while not FSegment.EOF do
        begin
          // Création de la famille 
          FAM_ID := SetNKLFAMILLE(
                                  RAY_ID,                                    // AFAM_RAYID: Integer;
                                  FSegment.FieldByName('FAM_CODE').AsString, // AFAM_CODE,
                                  FSegment.FieldByName('FAM_NOM').AsString,  // AFAM_NOM: string;
                                  FSegment.FieldByName('FAM_CENTRALE').AsInteger // AFAM_CENTRALE: integer
                                 );
          FSegment.Edit;
          FSegment.FieldByName('FAM_RAYID').AsInteger := RAY_ID;
          FSegment.FieldByName('FAM_ID').AsInteger := FAM_ID;
          FSegment.Post;

          DoAssignIDToCode(FSegment.FieldByName('FAM_CODE').AsString,FAM_ID);
          
          if FSegmentLoad.ClientDataset.Locate('FAM_ID',FAM_ID,[]) then
          begin
            FSegmentLoad.Edit;
            FSegmentLoad.FieldByName('CANDELETE').AsInteger := 0;
            FSegmentLoad.Post;
          end;
          
          {$REGION 'Mise en mémoire de la sous famille'}
          With FIboQuery do
          begin
            Close;
            SQL.Clear;
            SQL.add('Select SSF_ID, SSF_NOM, SSF_CENTRALE from NKLSSFAMILLE');
            SQL.Add('  Join K on K_ID = SSF_ID and K_Enabled=1');
            SQL.Add('Where SSF_FAMID = :PFAMID');
            SQL.Add('  and SSF_CENTRALE = :CENCODE');
            ParamCheck := True;
            ParamByName('PFAMID').AsInteger := FAM_ID;
            case FMagType of
              mtCourir  : ParamByName('CENCODE').AsInteger := CTE_COURIR ;
              mtGoSport : ParamByName('CENCODE').AsInteger := CTE_GOSPORT ;
            end;
            Open;

//            FSousFamilleLoad.ClientDataset.EmptyDataSet;
            while not EOF do
            begin
              if not FSousFamilleLoad.ClientDataset.Locate('SSF_ID', FieldByName('SSF_ID').AsInteger,[]) then
              begin
                FSousFamilleLoad.Append;
                FSousFamilleLoad.FieldByName('SSF_ID').AsInteger := FieldByName('SSF_ID').AsInteger;
                FSousFamilleLoad.FieldByName('SSF_NOM').AsString := FieldByName('SSF_NOM').AsString;
                FSousFamilleLoad.FieldByName('SSF_CENTRALE').AsInteger := FieldByName('SSF_CENTRALE').AsInteger;
                FSousFamilleLoad.FieldByName('SSF_FAMID').AsInteger := FAM_ID;
                FSousFamilleLoad.FieldByName('CANDELETE').AsInteger := 1;
                FSousFamilleLoad.Post;
              end;
              Next;
            end;
          end;
          {$ENDREGION}

          FSousFamille.First;
          while not FSousFamille.EOF do
          begin
            // Création de la sousfamille
            SSF_ID := SetNKLSSFAMILLE(
                                      FAM_ID,                                        // ASSF_FAMID: integer;
                                      FSousFamille.FieldByName('SSF_CODE').AsString, // ASSF_CODE,
                                      FSousFamille.FieldByName('SSF_NOM').AsString,  // ASSF_NOM: string;
                                      TVA_ID,                                        // ASSF_TVAID, 
                                      TCT_ID,                                        // ASSF_TCTID,
                                      FSousFamille.FieldByName('SSF_CENTRALE').AsInteger  // ASSF_CENTRALE: integer
                                     );
            FSousFamille.Edit;
            FSousFamille.FieldByName('SSF_FAMID').AsInteger := FAM_ID;
            FSousFamille.FieldByName('SSF_ID').AsInteger := SSF_ID;
            FSousFamille.Post;

            DoAssignIDToCode(FSousFamille.FieldByName('SSF_CODE').AsString,SSF_ID);
            
            if FSousFamilleLoad.ClientDataset.Locate('SSF_ID',SSF_ID,[]) then
            begin
              FSousFamilleLoad.Edit;
              FSousFamilleLoad.FieldByName('CANDELETE').AsInteger := 0;
              FSousFamilleLoad.Post;
            end
            else begin
              FSousFamilleLoad.Append;
              FSousFamilleLoad.FieldByName('SSF_ID').AsInteger    := SSF_ID;
              FSousFamilleLoad.FieldByName('SSF_NOM').AsString    := FSousFamille.FieldByName('SSF_NOM').AsString;
              FSousFamilleLoad.FieldByName('SSF_FAMID').AsInteger := FAM_ID;
              case FMagType of
                mtCourir:   FSousFamilleLoad.FieldByName('SSF_CENTRALE').AsInteger := CTE_COURIR;
                mtGoSport:  FSousFamilleLoad.FieldByName('SSF_CENTRALE').AsInteger := CTE_GOSPORT;
              end;
              FSousFamilleLoad.FieldByName('CANDELETE').AsInteger := 0;
              FSousFamilleLoad.Post;
            end;

            FSousFamille.Next;
          end;

          FSegment.Next;
        end;

        {$REGION 'Mise en purge des familles non utilisées'}
        With FSegmentLoad do
        begin
          First;
          ClientDataset.Filtered := False;
          ClientDataset.Filter := 'CANDELETE = 1';
          ClientDataset.Filtered := True;

          while not EOF do
          begin
            FSegmentPurge.Append;
            for i := 0 to ClientDataset.FieldCount -1 do
            begin
              iIndex := FSegmentPurge.ClientDataset.FieldList.IndexOf(ClientDataset.Fields.Fields[i].FieldName);
              if iIndex <> -1 then
                FSegmentPurge.ClientDataset.Fields.Fields[iIndex] := ClientDataset.Fields.Fields[i];
            end;
            FSegmentPurge.Post;
               
            Next;
          end;

          ClientDataset.Filtered := False;
        end;
        {$ENDREGION}
                            
        FSousRayon.Next;
      end;

      {$REGION 'Mise en purge des rayons non utilisés'}
      With FSousRayonLoad do
      begin
        First;
        ClientDataset.Filtered := False;
        ClientDataset.Filter := 'CANDELETE = 1';
        ClientDataset.Filtered := True;

        while not EOF do
        begin
          FSousRayonPurge.Append;
          for i := 0 to ClientDataset.FieldCount -1 do
          begin
            iIndex := FSousRayonPurge.ClientDataset.FieldList.IndexOf(ClientDataset.Fields.Fields[i].FieldName);
            if iIndex <> -1 then
              FSousRayonPurge.ClientDataset.Fields.Fields[iIndex] := ClientDataset.Fields.Fields[i];
          end;
          FSousRayonPurge.Post;
               
          Next;
        end;

        ClientDataset.Filtered := False;
      end;
      {$ENDREGION}
      
      FDepartement.Next;
      BarPosition(FDepartement.ClientDataset.RecNo * 100 Div FDepartement.ClientDataset.RecordCount);
    end;

    {$REGION 'Mise en purge des sousfamilles non utilisées'}
    With FSousFamilleLoad do
    begin
      First;
//      ClientDataset.Filtered := False;
//      ClientDataset.Filter := 'CANDELETE = 1';
//      ClientDataset.Filtered := True;

      while not EOF do
      begin
        if FieldByName('CANDELETE').AsInteger = 1 then
        begin
          FSousFamillePurge.Append;
          for i := 0 to ClientDataset.FieldCount -1 do
          begin
            iIndex := FSousFamillePurge.ClientDataset.FieldList.IndexOf(ClientDataset.Fields.Fields[i].FieldName);
            if iIndex <> -1 then
              FSousFamillePurge.ClientDataset.Fields.Fields[iIndex] := ClientDataset.Fields.Fields[i];
          end;
          FSousFamillePurge.Post;
        end;

        Next;
      end;

      ClientDataset.Filtered := False;
    end;
    {$ENDREGION}

    {$REGION 'PURGE des données '}
    // Suppression des données de sousfamille
    LabCaption('Purge des données : SousFamille');
    With FSousFamillePurge do
    begin
      First;
      BarPosition(0);
      while not EOF do
      begin
        DelNKLSSFAMILLE(FieldByName('SSF_ID').AsInteger, FieldByName('SSF_CENTRALE').AsInteger);
        Next;
        BarPosition(ClientDataset.RecNo * 100 div ClientDataset.RecordCount);
      end;
    end;

    // Suppression des données de famille
    LabCaption('Purge des données : Famille');
    With FSegmentPurge do
    begin
      First;
      BarPosition(0);
      while not EOF do
      begin
        DelNKLFAMILLE(FieldByName('FAM_ID').AsInteger, FieldByName('FAM_CENTRALE').AsInteger) ;
        Next;
        BarPosition(ClientDataset.RecNo * 100 div ClientDataset.RecordCount);
      end;
    end;

    // Suppression des données de rayon
    LabCaption('Purge des données : Rayon');
    With FSousRayonPurge do
    begin
      First;
      BarPosition(0);
      while not EOF do
      begin
        DelNKLRayon(FieldByName('RAY_ID').AsInteger, FieldByName('RAY_CENTRALE').AsInteger);
        Next;
        BarPosition(ClientDataset.RecNo * 100 div ClientDataset.RecordCount);
      end;
    end;

    // suppression des données de secteur
    LabCaption('Purge des données : Secteur');
    With FDepartementLoad do
    begin
      ClientDataset.Filtered := False;
      ClientDataset.Filter := 'CANDELETE = 1';
      ClientDataset.Filtered := True;
      Try
        First;
        BarPosition(0);
        while not EOF do
        begin
          DelNKLSECTEUR(FieldByName('SEC_ID').AsInteger, FieldByName('SEC_CENTRALE').AsInteger);
          Next;
          BarPosition(ClientDataset.RecNo * 100 div ClientDataset.RecordCount);
        end;
      Finally
        ClientDataset.Filtered := False;
      End;
    end;
    {$ENDREGION}

    FIboQuery.IB_Transaction.Commit;

  Except on E:Exception do
    begin
      FIboQuery.IB_Transaction.Rollback;

      Erreur := TErreur.Create;
      Erreur.AddError(FARBCAF_File + #13#10 + FGRPCAF_File,'',E.Message,0,teNomenclature,0,'');
      GERREURS.Add(Erreur);
      IncError ;
    end;
  End;
//  LabCaption('DoMaj : Chargement de la nomenclature Ginkoia');
//  BarPosition(0);
//
//  // on charge toute la nomenclature depuis Ginkoia pour les tests
//  ChargerNomenclatureGinkoia;
//
//  // on duplique la nomenclature vers FNomenclatureTEMP pour les recherches d'id parent
//  CDS_DupliquerNomenclature;
//
//  // on va lire CDS_nomenclature par niveau
//  with FNomenclature.ClientDataset do
//  begin
//    LabCaption('Création/Mise à jour de la nomenclature');
//    BarPosition(0);
//
//    vMax         := RecordCount;
//    vIdx         := 0;
//    vNiveau      := 1;
//    vFinDeBoucle := False;
//
//    RafraichirFiltreParNiveau(vNiveau);
//
//    // Si aucun n'enregistrement n'est trouvé, on ne rentre pas dans la boucle
//    if RecordCount = 0 then
//      vFinDeBoucle := True;
//
//    while not vFinDeBoucle do
//    begin
//      // si le libelle n'a pas été indiqué dans le fichier, on n'enregistre pas
//      if FieldByName('LIBELLEEXISTE').AsInteger = 0 then
//      begin
//        {$REGION 'Gestion des erreurs'}
//        vErreur := TErreur.Create;
//        vErreur.AddError(FGRPSFA_File, 'Nomenclature',
//                         'Libelle Nomenclature non trouvé : (CODE =' + FieldByName('NOM_CODE').AsString + ')',
//                         0, teNomenclature, 0,'');
//        GErreurs.Add(vErreur);
//        {$ENDREGION 'Gestion des erreurs'}
//      end
//      else
//      begin
//        // on regarde si le code existe deja dans la nomenclature actuelle
//        // et si c'est le cas, on fait un traitement directement dans CodeExiste
//        if not CodeExiste then
//        begin
//          // si le code n'existe pas, on l'insert dans la base et on met à jour le CDS
//          DB_INSERT_Nomenclature;
//        end;
//      end;
//
//      Next;
//      vIdx := vIdx + 1;
//      BarPosition(vIdx * 100 Div (vMax + 1));
//
//      {$REGION 'Tests et traitement de fin de boucle'}
//      // Si on est sur le dernier niveau, le traiteùent est terminé
//      if EoF then
//      begin
//        if vNiveau = vgNiveauMax then
//          vFinDeBoucle := True
//        else
//        begin
//          vNiveau := vNiveau + 1;
//          RafraichirFiltreParNiveau(vNiveau);
//        end
//      end;
//      {$ENDREGION 'Tests et traitement de fin de boucle'}
//    end;
//  end;
//
//  PurgerLaNomenclature;
end;

//------------------------------------------------------------------------------
//                                                          +------------------+
//                                                          |   Action table   |
//                                                          +------------------+
//------------------------------------------------------------------------------


//--------------------------------------------------> DB_INSERT_Nomenclature

function TNomenclature.DB_INSERT_Nomenclature : Boolean;
var
  vErreur : TErreur;
  vCode, vNom : String;
  vIdPere, vNiveau, vCenCode : Integer;
begin

  {$REGION 'Initialisation des variables'}
  vNiveau  := FNomenclature.ClientDataset.FieldByName('NOM_NIVEAU').AsInteger;
  vCode    := FNomenclature.ClientDataset.FieldByName('NOM_CODE').AsString;
  vNom     := FNomenclature.ClientDataset.FieldByName('NOM_NOM').AsString;
  vCenCode := FNomenclature.ClientDataset.FieldByName('CEN_CODE').AsInteger;
  vIdPere  := IndiqueIdParent(vCode);
  {$ENDREGION 'Initialisation des variables'}

  with FIboQuery do
  begin
    IB_Transaction.StartTransaction;
    Close;
    SQL.Clear;

    try
      // Execution de la proc stockée et récupération de l'Id crée si on insert
      SQL.Add(' select * ');
      if FBaseVersion = 1
        then SQL.Add(' from GOS_INSERT_NOMENCLATURE(:NIVEAU, :IDPERE, :CODE, :NOM)');
      if FBaseVersion = 2
        then SQL.Add(' from GOS_INSERT_NOMENCLATURE(:NIVEAU, :IDPERE, :CODE, :NOM, :CENCODE)');

      ParamCheck := True;
      ParamByName('NIVEAU').AsInteger   := vNiveau;
      ParamByName('IDPERE').AsInteger   := vIdPere;
      ParamByName('CODE').AsString      := vCode;
      ParamByName('NOM').AsString       := vNom;
      if FBaseVersion = 2
        then ParamByName('CENCODE').AsInteger  := vCenCode;

      Open;

      if not IsEmpty then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);

        // mise à jour des id dans la nomenclature Temporaire
        CDS_MettreAJourIdPere(vCode, FieldByName('NEWID').AsInteger);

        FNomenclature.ClientDataset.Edit;
        FNomenclature.ClientDataset.FieldByName('NOM_ID').AsInteger := FieldByName('NEWID').AsInteger;
        FNomenclature.ClientDataset.Post;
      end;

      Close;

      Result := True;

      IB_Transaction.Commit;
    except on E:Exception do
      begin
        {$REGION ' Gestion des erreurs '}

        IB_Transaction.Rollback;
        Result := False;

        with FNomenclature.ClientDataset do
        begin
          vErreur := TErreur.Create;
          vErreur.AddError(FGRPCAF_File, 'Nomenclature',
                           'DB_INSERT_Nomenclature échouée : (CODE =' + vCode + ')',
                           RecNo, teNomenclature, 0,'');
          GErreurs.Add(vErreur);
          IncError ;
        end;
      {$ENDREGION 'Gestion des erreurs'}
      end;
    end;
  end;
end;

//--------------------------------------------------> DB_UPDATE_Nomenclature

function TNomenclature.DB_UPDATE_Nomenclature(vpNiveau, vpIdFils : Integer;
vpNom : String) : Boolean;
var
  vErreur : TErreur;
begin
  with FIboQuery do
  begin
    IB_Transaction.StartTransaction;
    Close;
    SQL.Clear;

    try
      // Execution de la proc stockée d'update
      SQL.Add(' select * ');
      SQL.Add(' from GOS_UPDATE_NOMENCLATURE(:NIVEAU, :IDFILS, :NOM)');

      ParamCheck := True;
      ParamByName('NIVEAU').AsInteger := vpNiveau;
      ParamByName('IDFILS').AsInteger := vpIdFils;
      ParamByName('NOM').AsString     := vpNom;

      Open;

      if not IsEmpty then
        Inc(FMajCount,  FieldByName('FMAJ').AsInteger);

      Close;

      Result := True;

      IB_Transaction.Commit;
    except on E:Exception do
      begin
       {$REGION ' Gestion des erreurs '}

        IB_Transaction.Rollback;

        Result := False;

        with FNomenclature.ClientDataset do
        begin
          vErreur := TErreur.Create;
          vErreur.AddError(FGRPCAF_File, 'Nomenclature',
                           'DB_UPDATE_Nomenclature échouée : (Id ='
                           + IntToStr(vpIdFils) + ')', RecNo, teNomenclature, 0,'');
          GErreurs.Add(vErreur);
          IncError ;
        end;
        {$ENDREGION 'Gestion des erreurs'}
      end;
    end;
  end;
end;


//--------------------------------------------------------------> CodeExiste

function TNomenclature.CodeExiste : Boolean;
var
  vCode, vPrefixe, vNom : String;
  vNiveau : Integer;
  vCDS    : TClientDataSet;
begin
  Result := False;

  {$REGION 'Initialiser les variables'}
  vCode    := FNomenclature.ClientDataset.FieldByName('NOM_CODE').AsString;
  vNiveau  := FNomenclature.ClientDataset.FieldByName('NOM_NIVEAU').AsInteger;
  vPrefixe := '';

  // On indique le ClientDataSet en fonction du niveau
  vCDS := IndiqueLeCDS(vNiveau);

  if vCDS = nil then
    Exit;

  // On indique le prefixe en fonction du niveau
  case vNiveau of
   1 : vPrefixe := 'SEC';
   2 : vPrefixe := 'RAY';
   3 : vPrefixe := 'FAM';
   4 : vPrefixe := 'SSF';
  end;
  {$ENDREGION 'Initialiser les variables'}

  Result := vCDS.Locate(vPrefixe + '_CODE', vCode, [loCaseInsensitive]);

  // Si le code est trouvé, on le flag à 1 pour ne pas le supprimer de la base
  // et on va update le nom en base
  if Result = True then
  begin
    {$REGION 'Flag du CDS correspondant + UPDATE du nom en base'}

    with vCDS do
    begin
      vNom := FNomenclature.ClientDataset.FieldByName('NOM_NOM').AsString;

      Edit;
      FieldByName(vPrefixe + '_UTILISE').AsInteger := 1;
      Post;

      // si le nom est différent, on va le mettre à jour dans la base
      if FieldByName(vPrefixe + '_NOM').AsString <> vNom then
        DB_UPDATE_NOMENCLATURE(vNiveau, FieldByName(vPrefixe + '_ID').AsInteger, vNom);
    end;

    {$ENDREGION 'Flag du CDS correspondant + UPDATE du nom en base'}
  end;
end;

//------------------------------------------------------------> IndiqueLeCDS

function TNomenclature.IndiqueLeCDS(vpNiveau : Integer) : TClientDataSet;
begin
  Result := nil;

  case vpNiveau of
   1 : Result := FDepartement.ClientDataset;
   2 : Result := FSousRayon.ClientDataset;
   3 : Result := FSegment.ClientDataset;
   4 : Result := FSousFamille.ClientDataset;
  end;
end;

//---------------------------------------------------------> IndiqueIdParent

function TNomenclature.IndiqueIdParent(vpCode : String) : Integer;
begin
  FNomenclatureTEMP.ClientDataset.Filtered := False;

  if FNomenclatureTEMP.ClientDataSet.Locate('NOM_CODE', vpCode, [loCaseInsensitive]) then
    Result := FNomenclatureTEMP.ClientDataSet.FieldByName('NOM_IDPERE').AsInteger
  else
    Result := 0;
end;

//---------------------------------------------------> CDS_MettreAJourIdPere

procedure TNomenclature.CDS_MettreAJourIdPere(vpCode : String;
vpNewId : Integer);
begin
  with FNomenclatureTEMP.ClientDataset do
  begin
    Filtered := False;
    Filter   := 'NOM_CODEPERE=' + QuotedStr(vpCode);
    Filtered := True;

    First;

    while not EoF do
    begin
      Edit;
      FieldByName('NOM_IDPERE').AsInteger := vpNewId;
      Post;

      Next;
    end;
  end;
end;

//-------------------------------------------------------------> GetIdByCode

function TNomenclature.GetIdByCode(ACode: String ; ACenCode : Integer): Integer;
begin
//  // on ne va faire la recherche que sur les sousFamille (de niveau 4)
//  FNomenclature.ClientDataset.Filtered := False;
//  FNomenclature.ClientDataset.Filter   := 'NOM_NIVEAU=4 and LIBELLEEXISTE=1';
//  FNomenclature.ClientDataset.Filtered := True;
//
//  Result := 0;
//
//  if FNomenclature.ClientDataset.locate('NOM_CODE', ACode, [loCaseInsensitive]) then
//    Result := FNomenclature.ClientDataset.FieldByName('NOM_ID').AsInteger;
//
//  if Result = 0 then
//  begin
//    FSousFamille.ClientDataset.Filtered := False;
//
//    if FSousFamille.ClientDataset.Locate('SSF_CODE', ACode, [loCaseInsensitive]) then
//      Result := FSousFamille.ClientDataset.FieldByName('SSF_ID').AsInteger
//    else
//      raise Exception.Create('Nomenclature non trouvée : ' + ACode);
//  end;
//
//  if Result = 0 then
//    raise Exception.Create('Nomenclature non trouvée : ' + ACode);

  // Recherche en mémoire des données
  With FGRPCAFTmp do
  begin
    ClientDataset.Filtered := False;
    ClientDataset.Filter := 'NIVEAU = 4';
    ClientDataset.Filtered := True;

    if ClientDataset.Active and ClientDataset.Locate('CODE_GROUPE',ACode,[loCaseInsensitive]) then
      if FieldByName('ID').AsInteger <> -1 then
      begin
        Result := FieldByName('ID').AsInteger;
        Exit;
      end;
  end;

  // recherche des donneés dans la base
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT SSF_ID FROM NKLSSFAMILLE');
    SQL.Add('  Join K on K_ID = SSF_ID and K_Enabled = 1');
    SQL.Add('Where SSF_CODE = :PSSFCODE');
    SQL.Add('  and SSF_CENTRALE = :CENCODE');
    ParamCheck := True;
      ParamByName('PSSFCODE').AsString := ACode;
      ParamByName('CENCODE').AsInteger := ACenCode ;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('SSF_ID').AsInteger
    else
      raise Exception.Create('GetIdByCode -> Pas de sousfamille pour le code ' + ACode);
  end;
end;


//------------------------------------------------------------------------------
//                                                                 +-----------+
//                                                                 |   Purge   |
//                                                                 +-----------+
//------------------------------------------------------------------------------

//----------------------------------------------------> PurgerLaNomenclature

procedure TNomenclature.PurgerLaNomenclature;
var
  vErreur : TErreur;
begin
  FIboQuery.Close;

  with FSousFamille.ClientDataSet do
  begin
    Filtered := False;
    Filter   := 'SSF_UTILISE=0';
    Filtered := True;

    First;

    LabCaption('Purge de la Nomenclature');
    BarPosition(0);

    while not EoF do
    begin
      // cette sous famille n'a pas été trouvée dans le fichier
      // elle doit donc être purgée

      FIboQuery.SQL.Clear;
      FIboQuery.IB_Transaction.StartTransaction;
      try
        // Execution de la proc stockée de purge
        FIboQuery.SQL.Add(' select *  ');
        FIboQuery.SQL.Add(' from GOS_PURGE_NOMENCLATURE(:SSFID, :FAMID)');

        FIboQuery.ParamCheck := True;
        FIboQuery.ParamByName('SSFID').AsInteger := FieldByName('SSF_ID').AsInteger;
        FIboQuery.ParamByName('FAMID').AsInteger := FieldByName('SSF_IDPARENT').AsInteger;

        FIboQuery.Open;

        if not FIboQuery.IsEmpty then
          Inc(FMajCount,  FIboQuery.FieldByName('FMAJ').AsInteger);

        FIboQuery.Close;

        FIboQuery.IB_Transaction.Commit;
      except on E:Exception do
        begin
          {$REGION ' Gestion des erreurs '}

          FIboQuery.IB_Transaction.Rollback;

          with FNomenclature.ClientDataset do
          begin
            vErreur := TErreur.Create;
            vErreur.AddError(FGRPCAF_File, 'Nomenclature',
                             'PURGE_Nomenclature échouée : (Id ='
                             + IntToStr(FieldByName('SSF_ID').AsInteger) + ')',
                             RecNo, teNomenclature, 0,'');
            GErreurs.Add(vErreur);
            IncError ;
          end;
          {$ENDREGION 'Gestion des erreurs'}
        end;
      end;

      Next;
      BarPosition(RecNo * 100 Div (RecordCount + 1));
    end;
  end;

end;


end.
