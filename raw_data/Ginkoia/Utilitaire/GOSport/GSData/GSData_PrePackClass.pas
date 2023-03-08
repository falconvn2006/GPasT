unit GSData_PrePackClass;

interface

uses GSData_MainClass, GSData_Types, GSDataImport_DM, Variants,
     SysUtils, IBODataset, Db, GSData_TErreur, StrUtils, GSData_ArticleClass;

type
  TPrePackClass = Class(TMainClass)
  private
    FArticle : TArticleClass;


//    FGTF_ID : Integer;
    FNomenclature,
    FMarque ,
    FCdsEntete,
    FCdsPrepackLgTmp : TMainClass;
    FTVATable: TIboQuery;
    FCollectionTable: TIboQuery;

    procedure FSetTVATable(Value : TIboQuery);
    procedure FSetCollectionTable(Value : TIboQuery);
  public
    procedure import;override;
    function DoMajTable : Boolean;override;

    constructor Create;override;
    destructor Destroy;override;

    // Fonction de création/Maj des entetes de prépack
    function SetPrePackEntete(APPE_CODE, APPE_NOM : String;APPE_SSFID : Integer;APPE_CODEBARRE : String;APPE_MRKID : Integer;APPE_PRIX : Single) : Integer;
    // Fonction de création/Maj des lignes de prepack
    function SetPrePackLigne(APPL_PPARTID, APPL_ARTID, APPL_TGFID, APPL_COUID, APPL_QTE : Integer) : Integer;
    procedure GetPrepackLigne(APPL_PPEID : Integer);
  published
    property Marque : TMainClass read FMarque write FMarque;
    property Nomenclature : TMainClass read FNomenclature write FNomenclature;

    property TVATable        : TIboQuery  read FTVATable        write FSetTVATable;
    property CollectionTable : TIboQuery  read FCollectionTable write FSetCollectionTable;

  End;


implementation

{ TPrePackClass }

constructor TPrePackClass.Create;
begin
  inherited Create;

//  FArticle := TArticleClass.Create;
//  FArticle.Mode := taPrepack;
//  FArticle.CreateCdsField;
  FCdsPrepackLgTmp := TMainClass.Create;
  FCdsEntete       := TMainClass.Create;
end;

destructor TPrePackClass.Destroy;
begin
  FCdsEntete.Free;
  FCdsPrepackLgTmp.Free;
//  FArticle.Free;
  inherited;
end;

function TPrePackClass.DoMajTable: Boolean;
var
  PPL_ID, PPE_ID : Integer;
begin

 // Création des articles
// FArticle.DoMajTable;

 // Génération des lignes
// FArticle.ArtArticle.First;
// while not FArticle.ArtArticle.EOF do
// begin
//   if FArticle.ArtArticle.FieldByName('Error').AsInteger = 0 then
//   begin
  FCdsEntete.First;
  while not FCdsEntete.EOF do
  begin
     // Création/Mise à jour de l'entete
     PPE_ID := SetPrePackEntete(
                                FCdsEntete.FieldByName('PPE_CODE').AsString,      // APPE_CODE,
                                FCdsEntete.FieldByName('PPE_NOM').AsString,       // APPE_NOM: String;
                                FCdsEntete.FieldByName('PPE_SSFID').AsInteger,    // APPE_SSFID: Integer;
                                FCdsEntete.FieldByName('PPE_CODEBARRE').AsString, //  APPE_CODEBARRE: String;
                                FCdsEntete.FieldByName('PPE_MRKID').AsInteger,    // APPE_MRKID: Integer;
                                FCdsEntete.FieldByName('PPE_PRIX').AsSingle       // APPE_PRIX: Single
                               );

     // récupératon de la liste des lignes du prépack
     GetPrepackLigne(PPE_ID);

     ClientDataset.Filtered := False;
     ClientDataset.Filter := 'PPE_CODE = ' + QuotedStr(FCdsEntete.FieldByName('PPE_CODE').AsString);
     ClientDataset.Filtered := True;

     First;
     while not EOF do
     begin
       PPL_ID := SetPrePackLigne(
                       FArticle.ArtArticle.FieldByName('ART_ID').AsInteger, // APPL_PPARTID,
                       FieldByName('PPL_ARTID').AsInteger,                  // APPL_ARTID,
                       FieldByName('PPL_TGFID').AsInteger,                  // APPL_TGFID,
                       FieldByName('PPL_COUID').AsInteger,                  // APPL_COUID,
                       FieldByName('PPL_QTE').AsInteger                     // APPL_QTE : Integer
                      );
       // Recherche dans la liste des ligne du prépack si elle existe déjà ?
       if FCdsPrepackLgTmp.ClientDataset.Locate('PPL_ID',FieldByName('PPL_ID').AsInteger,[]) then
       begin
         FCdsPrepackLgTmp.Edit;
         FCdsPrepackLgTmp.FieldByName('Delete').AsInteger := 0;
         FCdsPrepackLgTmp.Post;
       end;
       Next;
//     end;
//     FArticle.ArtArticle.Next;
    end; // while

    {$REGION 'Suppression des lignes non présente dans les fichiers Prépack'}
    FCdsPrepackLgTmp.ClientDataset.Filtered := False;
    FCdsPrepackLgTmp.ClientDataset.Filter := 'Deleted = 1';
    FCdsPrepackLgTmp.ClientDataset.Filtered := True;

    FCdsPrepackLgTmp.First;
    while not FCdsPrepackLgTmp.EOF do
    begin
      With FIboQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PPLID,1)');
        ParamCheck := True;
        ParamByName('PPLID').AsInteger := FCdsPrepackLgTmp.FieldByName('PPL_ID').AsInteger;
        ExecSQL;
      end;

      FCdsPrepackLgTmp.Next;
    end;
    {$ENDREGION}

    FCdsEntete.Next;
  end; // while
  ClientDataset.Filtered := False;

end;

procedure TPrePackClass.FSetCollectionTable(Value: TIboQuery);
begin
//  FCollectionTable := Value;
//  FArticle.CollectionTable := Value;
end;

procedure TPrePackClass.FSetTVATable(Value: TIboQuery);
begin
//  FTVATable := Value;
//  FArticle.TVATable := Value;
end;

procedure TPrePackClass.GetPrepackLigne(APPL_PPEID: Integer);
begin
  FCdsPrepackLgTmp.ClientDataset.EmptyDataSet;
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from PREPACKLIGNES');
    SQL.Add('  Join K on K_ID = PPL_ID and K_Enabled = 1');
    SQL.Add('Where PPL_PPEID = :PPPEID');
    ParamCheck := True;
    ParamByName('PPPEID').AsInteger := APPL_PPEID;
    Open;

    while not EOF do
    begin
      FCdsPrepackLgTmp.Append;
      FCdsPrepackLgTmp.FieldByName('PPL_ID').AsInteger      := FieldByName('PPL_ID').AsInteger;
      FCdsPrepackLgTmp.FieldByName('PPL_PPEID').AsInteger   := FieldByName('PPL_PPEID').AsInteger;
      FCdsPrepackLgTmp.FieldByName('PPL_ARTID').AsInteger   := FieldByName('PPL_ARTID').AsInteger;
      FCdsPrepackLgTmp.FieldByName('PPL_TGFID').AsInteger   := FieldByName('PPL_TGFID').AsInteger;
      FCdsPrepackLgTmp.FieldByName('PPL_COUID').AsInteger   := FieldByName('PPL_COUID').AsInteger;
      FCdsPrepackLgTmp.FieldByName('PPL_QTE').AsInteger     := FieldByName('PPL_QTE').AsInteger;
      FCdsPrepackLgTmp.FieldByName('deleted').AsInteger     := 1;
      FCdsPrepackLgTmp.Post;

      Next;
    end;
  end;
end;

procedure TPrePackClass.import;
var
//  TGT_ID, FOU_ID : Integer;
  CodeArticle : TCodeArticle;
  iCentrale : integer ;
begin
  case FMagType of
    mtCourir:   iCentrale := CTE_COURIR ;
    mtGoSport:  iCentrale := CTE_GOSPORT ;
  end;

  // génératon des colonnes pour l'entete
  FCdsEntete.CreateField(['PPE_ID','PPE_CODE','PPE_NOM','PPE_SSFID','PPE_CODEBARRE','PPE_MRKID','PPE_PRIX'],
                         [ftInteger, ftString,ftString,ftInteger,ftString,ftInteger,ftSingle]);

  // Génération des colonnes du CDS de base  pour gérer les lignes
  CreateField(['PPE_CODE','PPL_ID','PPL_PPEID','PPL_ARTID','PPL_TGFID','PPL_COUID','PPL_QTE'],
              [ftString, ftInteger,ftInteger,ftInteger,ftInteger,ftInteger, ftInteger]);

  FCdsPrepackLgTmp.CreateField(['PPL_ID','PPL_PPEID','PPL_ARTID','PPL_TGFID','PPL_COUID','PPL_QTE','Deleted'],
              [ftInteger,ftInteger,ftInteger,ftInteger,ftInteger, ftinteger, ftInteger]);

//  // récupération du TGT_ID
//  TGT_ID := GetIDFromTable('PLXTYPEGT','TGT_CODE','GTGSDATA','TGT_ID');
//  // Récupération du fournisseur
//  GetGenParam(16,9,FOU_ID,True);
//
//  // Génération / récupération du la grille de taille des prepack
//  FGTF_ID := Farticle.SetPLXGTF(TGT_ID,'GTGSPREPACK','GRILLE PREPACK');

  With DM_GSDataImport do
  begin
    // traitement de l'entête
    while Not cds_PACKENT.Eof do
    begin
      FCdsEntete.Append;
      FCdsEntete.FieldByName('PPE_ID').AsInteger       := 0;
      FCdsEntete.FieldByName('PPE_CODE').AsString      := cds_PACKENT.FieldByName('CODE').AsString;
      FCdsEntete.FieldByName('PPE_NOM').AsString       := cds_PACKENT.FieldByName('NOM').AsString;
      FCdsEntete.FieldByName('PPE_SSFID').AsInteger    := FNomenclature.GetIdByCode(cds_PACKENT.FieldByName('SFA').AsString, iCentrale);
      FCdsEntete.FieldByName('PPE_CODEBARRE').AsString := cds_PACKENT.FieldByName('CODEBARRE').AsString;
      FCdsEntete.FieldByName('PPE_MRKID').AsInteger    := FMarque.GetIdByCode(cds_PACKENT.FieldByName('CODE_MARQUE').AsString, iCentrale);
      FCdsEntete.FieldByName('PPE_PRIX').AsSingle      := StrToFloat(cds_PACKENT.FieldByName('PRIX').AsString);
      FCdsEntete.Post;

//      FArticle.ArtArticle.Append;
//      FArticle.ArtArticle.FieldByName('ART_ID').AsInteger      := 0;
//      FArticle.ArtArticle.FieldByName('ART_NOM').AsString      := cds_PACKENT.FieldByName('NOM').AsString;
//      FArticle.ArtArticle.FieldByName('ART_MRKID').AsInteger   := FMarque.GetIdByCode(cds_PACKENT.FieldByName('CODE_MARQUE').AsString);
//      FArticle.ArtArticle.FieldByName('ART_REFMRK').AsString   := cds_PACKENT.FieldByName('CODE').AsString;
//      FArticle.ArtArticle.FieldByName('ART_GTFID').AsInteger   := FGTF_ID;
//      FArticle.ArtArticle.FieldByName('ART_CODE').AsString     := cds_PACKENT.FieldByName('CODE').AsString;
//      FArticle.ArtArticle.FieldByName('ART_PREPACK').AsInteger := 1;
//      FArticle.ArtArticle.FieldByName('SSF_ID').AsInteger      := FNomenclature.GetIdByCode(cds_PACKENT.FieldByName('SFA').AsString);
//      FArticle.ArtArticle.FieldByName('Error').AsInteger       := 0;
//      FArticle.ArtArticle.Post;
//
//      FArticle.ArtReference.Append;
//      FArticle.ArtArticle.FieldByName('ART_CODE').AsString   := cds_PACKENT.FieldByName('CODE').AsString;
//      FArticle.ArtArticle.FieldByName('ARF_ID').AsInteger    := 0;
//      FArticle.ArtArticle.FieldByName('ARF_TVAID').AsInteger := 0;
//      FArticle.ArtArticle.FieldByName('ARF_UC').AsString     := '';
//      FArticle.ArtArticle.Post;

      cds_PACKLIG.Filtered := False;
      cds_PACKLIG.Filter := 'CODEENTETE = ' + QuotedStr(cds_PACKENT.FieldByName('CODE').AsString);
      cds_PACKLIG.Filtered := True;

      // Traitement des lignes
      cds_PACKLIG.First;
      while not cds_PACKLIG.Eof do
      begin
        // récupération des informations CODE_ARTICLE
        CodeArticle := GetCodeArticle(cds_PACKLIG.FieldByName('CODE_ARTICLE').AsString);

        Append;
        FieldByName('PPE_CODE').AsString     := cds_PACKENT.FieldByName('CODE').AsString;
        FieldbyName('PPL_ID').AsInteger      := 0;
        FieldbyName('PPL_PPEID').AsInteger   := 0;
        FieldbyName('PPL_ARTID').AsInteger   := CodeArticle.ART_ID;
        FieldbyName('PPL_TGFID').AsInteger   := CodeArticle.TGF_ID;
        FieldbyName('PPL_COUID').AsInteger   := CodeArticle.COU_ID;
        FieldbyName('PPL_QTE').AsInteger     := cds_PACKLIG.FieldByName('QUANTITE').AsInteger;
        Post;

//        // Mise en place de la taille pour l'article. (Une seule fois par modèle prépack)
//        // Assignation du premier CODE_ARTICLE afin de le retrouver dans la création des articles
//        if not FArticle.PlxTailleGf.ClientDataset.Locate('ART_CODE',cds_PACKENT.FieldByName('CODE').AsString,[]) then
//        begin
//          FArticle.PlxTailleGf.Append;
//          FArticle.PlxTailleGf.FieldByName('TGF_ID').AsInteger      := 0;
//          FArticle.PlxTailleGf.FieldByName('TGF_GTFID').AsInteger   := FGTF_ID;
//          FArticle.PlxTailleGf.FieldByName('TGF_NOM').AsString      := 'UNITAILLE ';
//          FArticle.PlxTailleGf.FieldByName('TGF_CODE').AsString     := 'GSPPUNIT';
//          FArticle.PlxTailleGf.FieldByName('CODE_ARTICLE').AsString := cds_PACKLIG.FieldByName('CODE_ARTICLE').AsString;
//          FArticle.PlxTailleGf.FieldByName('ART_CODE').AsString     := cds_PACKENT.FieldByName('CODE').AsString;
//          FArticle.PlxTailleGf.Post;
//        end;
//
//        // Mise en place de la couleur pour l'article (Une seule fois par modèle prépack)
//        // Assignation du premier CODE_ARTICLE afin de le retrouver dans la création des articles
//        if not FArticle.PlxCouleur.ClientDataset.Locate('ART_CODE',cds_PACKENT.FieldByName('CODE').AsString,[]) then
//        begin
//          FArticle.PlxCouleur.Append;
//          FArticle.PlxCouleur.FieldByName('ART_CODE').AsString     := cds_PACKENT.FieldByName('CODE').AsString;
//          FArticle.PlxCouleur.FieldByName('CODE_ARTICLE').AsString := cds_PACKLIG.FieldByName('CODE_ARTICLE').AsString;
//          FArticle.PlxCouleur.FieldByName('COU_ID').AsInteger      := 0;
//          FArticle.PlxCouleur.FieldByName('COU_ARTID').AsInteger   := 0;
//          FArticle.PlxCouleur.FieldByName('COU_CODE').AsString     := 'GSPPUNIC';
//          FArticle.PlxCouleur.FieldByName('COU_NOM').AsString      := 'UNICOLOR ';
//          FArticle.PlxCouleur.Post;
//        end;
//
//        // Mise en place du tarif d'achat pour l'article (une seule fois par modèle prépack)
//        // Assignation du premier CODE_ARTICLE afin de le retrouver dans la création des articles
//        if not FArticle.TarClgFourn.ClientDataset.Locate('ART_CODE',cds_PACKENT.FieldByName('CODE').AsString,[]) then
//        begin
//          FArticle.TarClgFourn.Append;
//          FArticle.TarClgFourn.FieldByName('ART_CODE').AsString     := cds_PACKENT.FieldByName('CODE').AsString;
//          FArticle.TarClgFourn.FieldByName('CODE_ARTICLE').AsString := cds_PACKLIG.FieldByName('CODE_ARTICLE').AsString;
//          FArticle.TarClgFourn.FieldByName('CLG_ID').AsInteger      := 0;
//          FArticle.TarClgFourn.FieldByName('CLG_FOUID').AsInteger   := FOU_ID;
//          FArticle.TarClgFourn.FieldByName('CLG_ARTID').AsInteger   := 0;
//          FArticle.TarClgFourn.FieldByName('CLG_TGFID').AsInteger   := 0;
//          FArticle.TarClgFourn.FieldByName('CG_COUID').AsInteger    := 0;
//          FArticle.TarClgFourn.FieldByName('CLG_PX').AsSingle       := StrToFloat(cds_PACKENT.FieldByName('PRIX').AsString);
//          FArticle.TarClgFourn.FieldByName('CLG_PXNEGO').AsSingle   := 0;
//          FArticle.TarClgFourn.FieldByName('CLG_PXVI').AsSingle     := 0;
//          FArticle.TarClgFourn.FieldByName('CLG_RA1').AsSingle      := 0;
//          FArticle.TarClgFourn.FieldByName('CLG_RA2').AsSingle      := 0;
//          FArticle.TarClgFourn.FieldByName('CLG_RA3').AsSingle      := 0;
//          FArticle.TarClgFourn.FieldByName('CLG_TAXE').AsSingle     := 0;
//          FArticle.TarClgFourn.Post;
//        end;
//
//        // Mise en place du Code à barre pour l'article (Une seule fois par modèle prepack)
//        // Assignation du premier CODE_ARTICLE afin de le retrouver dans la création des articles
//        if not Farticle.ArtCodeBarre.ClientDataset.Locate('ART_CODE',cds_PACKENT.FieldByName('CODE').AsString,[]) then
//        begin
//          Farticle.ArtCodeBarre.Append;
//          Farticle.ArtCodeBarre.FieldByName('ART_CODE').AsString     := cds_PACKENT.FieldByName('CODE').AsString;
//          Farticle.ArtCodeBarre.FieldByName('CODE_ARTICLE').AsString := cds_PACKLIG.FieldByName('CODE_ARTICLE').AsString;
//          Farticle.ArtCodeBarre.FieldByName('CBI_ID').AsInteger      := 0;
//          Farticle.ArtCodeBarre.FieldByName('CBI_TGFID').AsInteger   := 0;
//          Farticle.ArtCodeBarre.FieldByName('CBI_COUID').AsInteger   := 0;
//          Farticle.ArtCodeBarre.FieldByName('CBI_ARFID').AsInteger   := 0;
//          Farticle.ArtCodeBarre.FieldByName('CBI_CB').AsString       := cds_PACKENT.FieldByName('CODEBARRE').AsString;
//          Farticle.ArtCodeBarre.Post;
//        end;

        cds_PACKLIG.Next;
      end; // while

      cds_PACKENT.Next;
    end; // while
  end; // with
end;

function TPrePackClass.SetPrePackEntete(APPE_CODE, APPE_NOM: String;
  APPE_SSFID: Integer; APPE_CODEBARRE: String; APPE_MRKID: Integer;
  APPE_PRIX: Single): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETPREPACKENTETE(:PPECODE, :PPENOM, :PPESSFID, :PPECODEBARRE, :PPEMRKID, :PPEPRIX)');
    ParamCheck := True;
    ParamByName('PPECODE').AsString      := APPE_CODE;
    ParamByName('PPENOM').AsString       := APPE_NOM;
    ParamByName('PPESSFID').AsInteger    := APPE_SSFID;
    ParamByName('PPECODEBARRE').AsString := APPE_CODEBARRE;
    ParamByName('PPEMRKID').AsInteger    := APPE_MRKID;
    ParamByName('PPEPRIX').AsSingle      := APPE_PRIX;
    Open;

    if RecordCount > 0 then
    begin
      Inc(FInsertcount,FieldbyName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('PPE_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('SetPrePackLigne -> ' + E.Message);
  End;

end;

function TPrePackClass.SetPrePackLigne(APPL_PPARTID, APPL_ARTID, APPL_TGFID,
  APPL_COUID, APPL_QTE: Integer): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from GOS_SETPREPACKLIGNE(:PPPARTID, :PARTID, :PTGFID, :PCOUID, :PPPLQTE)');
    ParamCheck := True;
    ParamByName('PPPARTID').AsInteger := APPL_PPARTID;
    ParamByName('PARTID').AsInteger   := APPL_ARTID;
    ParamByName('PTGFID').AsInteger   := APPL_TGFID;
    ParamByName('PCOUID').AsInteger   := APPL_COUID;
    ParamByName('PPPLQTE').AsInteger  := APPL_QTE;
    Open;

    if RecordCount > 0 then
    begin
      Inc(FInsertcount,FieldbyName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('PPL_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('SetPrePackLigne -> ' + E.Message);
  End;
end;

end.
