unit GSData_TPrixVente;

interface

uses GSData_MainClass, GSData_TErreur, GSData_Types, GSDataImport_DM, StrUtils,
     DBClient, SysUtils, IBODataset, Db, Variants, classes, Math, Types, DateUtils,
     GSData_TOpeCom, uLogFile ;

type
  TTypeActionVente = (ttavNull, ttavArticle, ttavOpeCom, ttavSolde, ttavRemise);

  TPrixVente = class(TMainClass)
    private
      FPrixVente : TMainClass;
      vgIdTypeSolde   : Integer;
      vgIdTypeRemise  : Integer;

      FMODELEVENTE     ,
      FTARPRIXVENTE    : TMainClass;
      FTARPRECO        : TMainClass;
      FTARVALID        : TMainClass;
      FTARPRECO_PAR    : TMainClass;
      FTARVALID_PAR    : TMainClass;

      FOCTETE          : TMainClass;
      FOCLIGNES        : TMainClass;
      FOCDETAIL        : TMainClass;

      DS_TARPRECO      ,
      DS_TARPRECO_PAR  ,
      DS_OCLIGNES      : TDataSource;

      FOpeCom          : TOpeCom;
      FArticleFichier  : TMainClass;
      FRelationArticle : TMainClass;

      FPRIXVENTE_File : String;

      procedure CreateCdsField;

      // function de création des tarifs de vente
      function SetTARPRIXVENTE(APVT_TVTID, APVT_ARTID, APVT_TGFID, APVT_COUID : Integer; APVT_PX : Currency; APVT_CENTRALE : Integer) : Integer;
      // fonction de création d'un tarif préco
      function SetTARPRECO(ATPO_ARTID : Integer; ATPO_DT : TDate; ATPO_PX : Currency; ATPO_ETAT : Integer) : Integer;
      // fonction de création du détail d'un tarif préco
      function SetTARVALID(ATVD_TPOID, ATVD_TVTID, ATVD_ARTID, ATVD_TGFID, ATVD_COUID : Integer; ATVD_PX : Currency; ATVD_DT : TDate; ATVD_ETAT, ACEN_CODE : Integer) :Integer;
      // procedure de mise à jour du suivi magasin d'un modèle
      procedure UpdARTFDS(AART_ID, AART_FDS : Integer);
      // fonction de création d'une ligne OC
      function SetOCLIGNES( AOCL_ARTID : Integer; AOCL_PXVTE : Currency; AOCL_OCTID, AOCL_LOTID : Integer) : Integer;
      // fonction de création de détail d'une ligne d'OC
      function SetOCDETAIL( AOCD_OCLID, AOCD_ARTID, AOCD_TGFID, AOCD_COUID : Integer; AOCD_PRIX : Currency; AOCD_ACTIVE, AOCD_CENTRALE : Integer) :Integer;
      // fonction de création de l'entete d'OC pour les soldes
      function setOCTETE_SOLDE( AOCT_NOM, AOCT_COMMENT : string; AOCT_DEBUT, AOCT_FIN : TDate; AOCT_TYPID, AOCT_WEB, AOCT_CENTRALE : Integer; AOCT_CODE : String;AOCT_TYPEPRIX : Integer) : Integer;
      // fonnction de liaison  de l'OC avec le magasin
      function SetOPECOMMAG( AOCT_ID, AMAG_ID : Integer) : Integer;
      // fonction qui permet de vérifier si le tarif de base de l'article est à 0
      function IsTarifZero(AART_ID : Integer) : Boolean;

    public
      procedure Import; override;
      function  DoMajTable : Boolean; override;

      Constructor Create; override;
      Destructor  Destroy; override;



    published
      property ArticleFichier  : TMainClass read FArticleFichier  write FArticleFichier;
      property RelationArticle : TMainClass read FRelationArticle write FRelationArticle;
      property OpeCom          : TOpeCom read FOpeCom          write FOpeCom;

  end;


implementation


uses GSDataMain_DM, uLog;


Constructor TPrixVente.Create;
begin
  Inherited;

  FPrixVente := TMainClass.Create;

  FMODELEVENTE     := TMainClass.Create;
  FTARPRIXVENTE    := TMainClass.Create;
  FTARPRECO        := TMainClass.Create;
  FTARVALID        := TMainClass.Create;

  FTARPRECO_PAR    := TMainClass.Create;
  FTARVALID_PAR    := TMainClass.Create;

  DS_TARPRECO      := TDataSource.Create(nil);
  DS_TARPRECO.DataSet := FTARPRECO.ClientDataset;
  DS_TARPRECO_PAR     := TDataSource.Create(nil);
  DS_TARPRECO_PAR.DataSet := FTARPRECO_PAR.ClientDataset;

  FOCTETE          := TMainClass.Create;
  FOCLIGNES        := TMainClass.Create;
  DS_OCLIGNES := TDataSource.Create(nil);
  DS_OCLIGNES.DataSet := FOCLIGNES.ClientDataset;
  FOCDETAIL        := TMainClass.Create;


end;

procedure TPrixVente.CreateCdsField;
begin
  FMODELEVENTE.CreateField(['CODE_MODELE','DateTarifBase', 'IsNewArt', 'TarifBase'],
                           [ftString, ftDate, ftBoolean, ftCurrency]);

  FTARPRIXVENTE.CreateField(['PVT_ID','PVT_TVTID', 'PVT_ARTID','PVT_TGFID','PVT_COUID',
                             'PVT_PX', 'PVT_CENTRALE', 'CODE_ARTICLE', 'CODE_MODELE',
                             'TarifBase', 'TarifDate', 'TarifTraite'],
                            [ftInteger, ftInteger, ftInteger, ftInteger, ftInteger,
                             ftFloat, ftInteger, ftString, ftString,
                             ftInteger, ftDate, ftBoolean]);

  FTARPRECO.CreateField(['CODE_MODELE', 'TPO_ID', 'TPO_ARTID', 'TPO_DT', 'TPO_PX', 'TPO_ETAT'],
                        [ftString, ftInteger, ftInteger, ftDate, ftCurrency, ftInteger]);
  FTARPRECO.ClientDataset.AddIndex('Idx','CODE_MODELE;TPO_DT',[]);
  FTARPRECO.ClientDataset.IndexName := 'Idx';

  FTARVALID.CreateField(['CODE_MODELE', 'CODE_ARTICLE', 'TPO_DT', 'TVD_ARTID', 'TVD_TGFID',
                         'TVD_COUID', 'TVD_TVTID', 'TVD_DT' , 'TVD_PX', 'TVD_ETAT', 'TVD_CENTRALE'],
                        [ftString, ftString, ftDate, ftInteger, ftInteger,
                         ftInteger, ftInteger, ftDate, ftCurrency, ftInteger, ftInteger]);
  FTARVALID.ClientDataset.AddIndex('Idx','CODE_MODELE;TPO_DT',[]);
  FTARVALID.ClientDataset.IndexName := 'Idx';
  FTARVALID.ClientDataset.MasterFields := 'CODE_MODELE;TPO_DT';
  FTARVALID.ClientDataset.MasterSource := DS_TARPRECO;

  FTARPRECO_PAR.CreateField(['CODE_MODELE', 'TPO_ID', 'TPO_ARTID', 'TPO_DT', 'TPO_PX', 'TPO_ETAT'],
                        [ftString, ftInteger, ftInteger, ftDate, ftCurrency, ftInteger]);
  FTARPRECO_PAR.ClientDataset.AddIndex('Idx','CODE_MODELE;TPO_DT',[]);
  FTARPRECO_PAR.ClientDataset.IndexName := 'Idx';

  FTARVALID_PAR.CreateField(['CODE_MODELE', 'CODE_ARTICLE', 'TPO_DT', 'TVD_ARTID', 'TVD_TGFID', 'TVD_COUID', 'TVD_DT' , 'TVD_PX', 'TVD_ETAT', 'TVD_CENTRALE'],
                        [ftString, ftString, ftDate, ftInteger, ftInteger, ftInteger, ftDate, ftCurrency, ftInteger, ftInteger]);
  FTARVALID_PAR.ClientDataset.AddIndex('Idx','CODE_MODELE;TPO_DT',[]);
  FTARVALID_PAR.ClientDataset.IndexName := 'Idx';
  FTARVALID_PAR.ClientDataset.MasterFields := 'CODE_MODELE;TPO_DT';
  FTARVALID_PAR.ClientDataset.MasterSource := DS_TARPRECO_PAR;


  FOCLIGNES.CreateField(['CODE_OPERATION', 'CODE_MODELE', 'OCL_ARTID', 'OCL_PXVTE',
                         'OCL_OCTID', 'OCL_LOTID','Error', 'NumOC', 'OCL_ID'],
                        [ftString, ftString, ftInteger, ftCurrency,
                         ftInteger, ftInteger, ftBoolean, ftInteger, ftInteger]);
  FOCLIGNES.ClientDataset.AddIndex('Idx','CODE_OPERATION;CODE_MODELE',[]);
  FOCLIGNES.ClientDataset.IndexName := 'Idx';

  FOCDETAIL.CreateField(['CODE_OPERATION', 'CODE_ARTICLE', 'OCD_OCLID', 'OCD_ARTID', 'CODE_MODELE',
                         'OCD_TGFID', 'OCD_COUID', 'OCD_PRIX', 'OCD_ACTIVE', 'OCD_CENTRALE'],
                        [ftString, ftString, ftInteger, ftInteger, ftString,
                        ftInteger, ftInteger, ftCurrency, ftInteger, ftInteger]);
  FOCDETAIL.ClientDataset.AddIndex('Idx','CODE_OPERATION;CODE_MODELE',[]);
  FOCDETAIL.ClientDataset.IndexName := 'Idx';
  FOCDETAIL.ClientDataset.MasterFields := 'CODE_OPERATION;CODE_MODELE';
  FOCDETAIL.ClientDataset.MasterSource := DS_OCLIGNES;

  FOCTETE.CreateField(['NUMOC', 'OCT_ID', 'OCT_NOM', 'OCT_COMMENT', 'OCT_DEBUT', 'OCT_FIN',
                       'OCT_TYPID', 'OCT_WEB', 'OCT_CENTRALE', 'OCT_CODE', 'OCT_TYPEPRIX'],
                      [ftInteger, ftInteger, ftString, ftString, ftDate, ftDate,
                       ftInteger, ftInteger , ftInteger, ftString, ftInteger]);
  FOCTETE.ClientDataset.AddIndex('Idx','NUMOC',[]);
  FOCTETE.ClientDataset.IndexName := 'Idx';

end;

Destructor TPrixVente.Destroy;
begin
  DS_TARPRECO.Free;
  DS_TARPRECO_PAR.Free;
  FTARPRIXVENTE.Free;
  FTARPRECO.Free;
  FTARPRECO_PAR.Free;
  FTARVALID.Free;
  FTARVALID_PAR.Free;
  DS_OCLIGNES.Free;
  FOCLIGNES.Free;
  FOCDETAIL.Free;
  FMODELEVENTE.Free;


  FPrixVente.Free;
  FOCTETE.Free;

  Inherited;
end;


//------------------------------------------------------------------------------
//                                                                 +-----------+
//                                                                 |   Import  |
//                                                                 +-----------+
//------------------------------------------------------------------------------

//------------------------------------------------------------------> Import

procedure TPrixVente.Import;
var
  i      : Integer;
  Article : TCodeArticle;
  Erreur  : TErreur;
  vTrouve  : Boolean;

  sPrefixe : String;

  sType, sMotif, sCodeOperation : string;
  dDateValeur, dDateFIN, dDateTarifBase : TDate;
  bArtNew, bIsTarifPreco, bIsBase, bVarBoolean : Boolean;
  NumOC : Integer;
  TYP_ID : Integer;
  fTarifBase, fPrix : Currency;

  Prems : boolean;

  iCentrale, vRejected: Integer ;
begin
  case FMagType of
    mtCourir:   iCentrale := CTE_COURIR ;
    mtGoSport:  iCentrale := CTE_GOSPORT ;
  end;

  NumOC := 1;
  vRejected := 0;
  dDateTarifBase := 0;
  // Mise du nom de fichier en variable générale
  for i := Low(FilesPath) to High(FilesPath) do
  begin
    sPrefixe := Copy(FilesPath[i],1,6);
    case AnsiIndexStr(UpperCase(sPrefixe),['PRXVTE']) of
      0 : FPRIXVENTE_File := FilesPath[i];
    end;
  end;
  // création des champs des CSD
  CreateCdsField;

  // Récupération du TYP_ID
  TYP_ID := GetIDFromTable('GENTYPCDV',['TYP_COD','TYP_CATEG'],[2,5],'TYP_ID');

  LabCaption('Importation des données de prix vente');
  With DM_GSDataImport.cds_PRXVTE do
  begin
    FCount := Recordcount;
    First;
    while not EOF do
    begin
      try
        If not Assigned(FArticleFichier) then
          raise Exception.Create('Pas de fichier article disponible');

        // On ne traite que les données ayant le TYPE_CONDITION = 45
        if FieldByName('TYPE_CONDITION').AsString = '45' then
        begin
          bArtNew := False;
          // Est ce que le modèle a été traitée précédement ?
          if FArticleFichier.ClientDataset.Active and FArticleFichier.ClientDataset.Locate('ART_CODE',FieldByName('CODE_MODELE').AsString,[loCaseInsensitive]) then
          begin
            // Oui, est ce que le modèle est valide ?
            if FArticleFichier.FieldByName('Error').AsInteger <> 0 then
            begin
            // Non, alors on passe à l'article suivant
              Next;
              Continue;
            end;

            // Est ce que l'article vient d'être créé
            bArtNew := FArticleFichier.FieldByName('Created').AsBoolean;

            // est ce que l'article a été traité précédement ?
            if FRelationArticle.ClientDataset.Locate('CODE_ARTICLE',FieldByName('CODE_ARTICLE').AsString,[loCaseInsensitive]) then
            begin
              // Oui, Alors on récupè les informations que l'article
              Article.ART_ID := FRelationArticle.FieldByName('ARA_ARTID').AsInteger;
              Article.TGF_ID := FRelationArticle.FieldByName('ARA_TGFID').AsInteger;
              Article.COU_ID := FRelationArticle.FieldByName('ARA_COUID').AsInteger;
            end
            else
            begin
              //Si Non on cherche directement dans la base de données
              Article := GetCodeArticle(FieldByName('CODE_ARTICLE').AsString);
            end;
          end
          else
          begin
            //Si Non on cherche directement dans la base de données
            Article := GetCodeArticle(FieldByName('CODE_ARTICLE').AsString);
          end;

          // Récupération des informations de traitement
          sType          := Trim(FieldByName('TYPE').AsString);
          sMotif         := Trim(FieldByName('MOTIF_CHGT_PRIX').AsString);
          sCodeOperation := Trim(FieldByName('CODE_OPERATION').AsString);
          dDateValeur    := FieldByName('DATE_VALEUR').AsDateTime;
          dDateFIN       := FieldByName('DATE_FIN').AsDateTime;
          fPrix          := StrToCurr(StringReplace(FieldByName('PRIX').AsString,'.',',',[]));

          // Est-ce un tarif de vente pour l'article
          if (sType = '') and (sMotif = '') and (sCodeOperation = '') then
          begin
            // Est-ce que l'article n'a pas déjà un prix de vente de base
            bIsBase := not FTARPRIXVENTE.ClientDataset.Locate('PVT_ARTID;TarifBase;TarifDate',VarArrayOf([Article.ART_ID,1,dDateValeur]),[]);

            if bIsBase and (CompareDate(dDateFIN, Date) <> GreaterThanValue) then
            begin
              Inc(vRejected);
              Next;
              Continue;
            end;

            // Est ce que le stock&ge de date du modèle existe ?
            if not FMODELEVENTE.ClientDataset.Locate('CODE_MODELE',FieldByName('CODE_MODELE').AsString,[loCaseInsensitive]) then
            begin
              FMODELEVENTE.Append;
              FMODELEVENTE.FieldByName('CODE_MODELE').AsString     := FieldByName('CODE_MODELE').AsString;
              FMODELEVENTE.FieldByName('DateTarifBase').AsDateTime := 0;
              FMODELEVENTE.FieldByName('TarifBase').AsCurrency     := fPrix;
              // Vérifie s'il le modèle vient d'être créer
              if bArtNew then
                FMODELEVENTE.FieldByName('IsNewArt').AsBoolean       := bArtNew
              else
                // Vérifie que le tarif de base de l'article est à 0, s'il est à 0 alors on va considérer que le
                // modèle est en création afin de mettre à jour le tarif de base.
                FMODELEVENTE.FieldByName('IsNewArt').AsBoolean       := IsTarifZero(Article.ART_ID);

              FMODELEVENTE.Post;
            end;

            // est ce que la date de valeur est > à la date du tarif de base
            // et est ce que la date de valeur est inférieur à la date du jour ?
            if not bIsBase then
            begin
              if (CompareDate(dDateValeur, FMODELEVENTE.FieldByName('DateTarifBase').AsDateTime) = GreaterThanValue) and
                 (CompareDate(dDateValeur, Now) = LessThanValue) then
              begin
                FMODELEVENTE.Edit;
                FMODELEVENTE.FieldByName('DateTarifBase').AsDateTime := dDateValeur;
                FMODELEVENTE.FieldByName('TarifBase').AsCurrency     := fPrix;
                FMODELEVENTE.Post;
              end;
            end
            else
            begin
              if CompareDate(dDateValeur, Date) <> GreaterThanValue then
              begin
                dDateValeur := Now;
              end;

              FMODELEVENTE.Edit;
              FMODELEVENTE.FieldByName('DateTarifBase').AsDateTime := dDateValeur;
              FMODELEVENTE.FieldByName('TarifBase').AsCurrency     := fPrix;
              FMODELEVENTE.Post;
            end;

            // Création du tarif de l'article
            if bIsBase Or (CompareValue(FMODELEVENTE.FieldByName('TarifBase').AsCurrency,fPrix,0.001) <> EqualsValue) then
            begin
              FTARPRIXVENTE.Append;
              FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger    := 0;
              FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency      := fPrix;
              FTARPRIXVENTE.FieldByName('PVT_CENTRALE').AsInteger := iCentrale ;
              FTARPRIXVENTE.FieldByName('CODE_MODELE').AsString   := FieldByName('CODE_MODELE').AsString;
              FTARPRIXVENTE.FieldByName('CODE_ARTICLE').AsString  := FieldByName('CODE_ARTICLE').AsString;
              FTARPRIXVENTE.FieldByName('PVT_ARTID').AsInteger    := Article.ART_ID;
              if bIsBase then
              begin
                FTARPRIXVENTE.FieldByName('TarifBase').AsInteger := 1;
                FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger    := 0;
                FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger    := 0;
              end
              else
              begin
                FTARPRIXVENTE.FieldByName('TarifBase').AsInteger := 0;
                FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger    := Article.TGF_ID;
                FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger    := Article.COU_ID;
              end;
              FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime   := dDateValeur;
              FTARPRIXVENTE.FieldByName('TarifTraite').AsBoolean  := False;
              FTARPRIXVENTE.Post;
            end;
          end
          else
          begin
            // Est ce un Prix d'opération commerciale ?
            if (sMotif = '') and (sCodeOperation <> '') and
               (CompareDate(dDateFIN,StrToDate('31/12/9999')) <> EqualsValue) then
            begin
              If not Assigned(FOpeCom) then
                raise Exception.Create('Pas de fichier opération commerciale disponible');

              Try
                if not FOCLIGNES.ClientDataset.Locate('CODE_OPERATION;CODE_MODELE',VarArrayOf([sCodeOperation,FieldByName('CODE_MODELE').AsString]),[loCaseInsensitive]) then
                begin
                  FOCLIGNES.Append;
                  FOCLIGNES.FieldByName('CODE_OPERATION').AsString := sCodeOperation;
                  FOCLIGNES.FieldByName('CODE_MODELE').AsString := FieldByName('CODE_MODELE').AsString;
                  FOCLIGNES.FieldByName('OCL_ARTID').AsInteger := Article.ART_ID;
                  FOCLIGNES.FieldByName('OCL_PXVTE').AsCurrency := fPrix;
                  FOCLIGNES.FieldByName('OCL_OCTID').AsInteger := FOpeCom.GetIdByCode(sCodeOperation, iCentrale);
                  FOCLIGNES.FieldByName('OCL_LOTID').AsInteger := 0;
                  FOCLIGNES.FieldByName('Error').AsBoolean := False;
                  FOCLIGNES.FieldByName('NumOC').AsInteger := 0;
                  FOCLIGNES.Post;
                end;

                FOCDETAIL.Append;
                FOCDETAIL.FieldByName('CODE_OPERATION').AsString := sCodeOperation;
                FOCDETAIL.FieldByName('CODE_ARTICLE').AsString := FieldByName('CODE_ARTICLE').AsString;
                FOCDETAIL.FieldByName('OCD_OCLID').AsInteger := 0;
                FOCDETAIL.FieldByName('OCD_ARTID').AsInteger := Article.ART_ID;
                FOCDETAIL.FieldByName('OCD_TGFID').AsInteger := Article.TGF_ID;
                FOCDETAIL.FieldByName('OCD_COUID').AsInteger := Article.COU_ID;
                FOCDETAIL.FieldbyName('OCD_PRIX').AsCurrency := fPrix;
                FOCDETAIL.FieldByName('OCD_ACTIVE').AsInteger := 1;
                FOCDETAIL.FieldByName('OCD_CENTRALE').AsInteger := iCentrale ;
                FOCDETAIL.Post;
              Except on E:Exception do
                begin
                  if FOCLIGNES.ClientDataset.State in [dsInsert] then
                    FOCLIGNES.ClientDataset.Cancel
                  else begin
                    FOCLIGNES.Edit;
                    FOCLIGNES.FieldByName('Error').AsBoolean := True;
                    FOCLIGNES.Post;
                  end;

                  if FOCDETAIL.ClientDataset.State in [dsInsert] then
                    FOCDETAIL.ClientDataset.Cancel;

                  raise Exception.Create(Format('Code Operation : %s - %s',[sCodeOperation,E.Message]));
                end;
              End;
            end
            else
            begin
              // Est-ce un prix des soldes ?
              if (sMotif = 'ZSB') and (CompareDate(dDateFIN,StrToDate('31/12/9999')) <> EqualsValue)  then
              begin
                if not FOCTETE.ClientDataset.Locate('OCT_DEBUT;OCT_FIN',VarArrayOf([FieldByName('DATE_VALEUR').AsDateTime, dDateFIN]),[]) then
                begin
                  FOCTETE.Append;
                  FOCTETE.FieldByName('NUMOC').AsInteger := NumOC;
                  FOCTETE.FieldByName('OCT_ID').AsInteger := 0;
                  FOCTETE.FieldByName('OCT_NOM').AsString := 'SOLDES CENTRALE';
                  FOCTETE.FieldByName('OCT_COMMENT').&AsString := '';
                  FOCTETE.FieldByName('OCT_DEBUT').AsDateTime := FieldByName('DATE_VALEUR').AsDateTime;
                  FOCTETE.FieldByName('OCT_FIN').AsDateTime := dDateFIN;
                  FOCTETE.FieldByName('OCT_TYPID').AsInteger := TYP_ID;
                  FOCTETE.FieldByName('OCT_WEB').AsInteger := 0;
                  FOCTETE.FieldByName('OCT_CENTRALE').AsInteger := iCentrale ;
                  FOCTETE.FieldByName('OCT_CODE').AsString := '';
                  FOCTETE.FieldByName('OCT_TYPEPRIX').AsInteger := 0;
                  FOCTETE.Post;

                  Inc(NumOC);
                end;

                if not FOCLIGNES.ClientDataset.Locate('NUMOC;CODE_MODELE',VarArrayOf([FOCTETE.FieldByName('NUMOC').AsInteger,FieldByName('CODE_MODELE').AsString]),[loCaseInsensitive]) then
                begin
                  FOCLIGNES.Append;
                  FOCLIGNES.FieldByName('CODE_OPERATION').AsString := 'CO_' + IntToStr(FOCTETE.FieldByName('NUMOC').AsInteger);
                  FOCLIGNES.FieldByName('CODE_MODELE').AsString := FieldByName('CODE_MODELE').AsString;
                  FOCLIGNES.FieldByName('OCL_ARTID').AsInteger := Article.ART_ID;
                  FOCLIGNES.FieldByName('OCL_PXVTE').AsCurrency := fPrix;
                  FOCLIGNES.FieldByName('OCL_OCTID').AsInteger := 0; //FOpeCom.GetIdByCode(sCodeOperation);
                  FOCLIGNES.FieldByName('OCL_LOTID').AsInteger := 0;
                  FOCLIGNES.FieldByName('Error').AsBoolean := False;
                  FOCLIGNES.FieldByName('NUMOC').AsInteger := FOCTETE.FieldByName('NUMOC').AsInteger;
                  FOCLIGNES.Post;
                end;

                FOCDETAIL.Append;
                FOCDETAIL.FieldByName('CODE_OPERATION').AsString := 'CO_' + IntToStr(FOCTETE.FieldByName('NUMOC').AsInteger);
                FOCDETAIL.FieldByName('CODE_MODELE').AsString := FieldByName('CODE_MODELE').AsString;
                FOCDETAIL.FieldByName('CODE_ARTICLE').AsString := FieldByName('CODE_ARTICLE').AsString;
                FOCDETAIL.FieldByName('OCD_OCLID').AsInteger := 0;
                FOCDETAIL.FieldByName('OCD_ARTID').AsInteger := Article.ART_ID;
                FOCDETAIL.FieldByName('OCD_TGFID').AsInteger := Article.TGF_ID;
                FOCDETAIL.FieldByName('OCD_COUID').AsInteger := Article.COU_ID;
                FOCDETAIL.FieldbyName('OCD_PRIX').AsCurrency := fPrix;
                FOCDETAIL.FieldByName('OCD_ACTIVE').AsInteger := 1;
                FOCDETAIL.FieldByName('OCD_CENTRALE').AsInteger :=  FOCTETE.FieldByName('OCT_CENTRALE').AsInteger ;
                FOCDETAIL.Post;
              end
              else
              begin
                // est-ce un prix d'article remisé ?
                if ((sType = 'P') or (sMotif = 'ZSB')) and (CompareDate(dDateFIN,StrToDate('31/12/9999')) = EqualsValue) then
                begin
                  if FTARVALID_PAR.ClientDataset.Locate('TVD_ARTID;TVD_TGFID;TVD_COUID;TVD_DT',
                                                        VarArrayOf([Article.ART_ID,
                                                                    0,
                                                                    0,
                                                                    FieldByName('DATE_VALEUR').AsDateTime]),
                                                        []) then
                  begin
                    Prems := false;
                    fTarifBase := FTARVALID_PAR.FieldByName('TVD_PX').AsCurrency;
                  end
                  else
                  begin
                    Prems := true;
                    fTarifBase := 0;
                  end;

                  if not FTARPRECO_PAR.ClientDataset.Locate('CODE_MODELE;TPO_DT;TPO_PX',
                                                 VarArrayOf([FieldByName('CODE_MODELE').AsString,
                                                             FieldByName('DATE_VALEUR').AsDateTime,
                                                             fTarifBase]),[locaseInsensitive]) then
                  begin
                    FTARPRECO_PAR.Append;
                    FTARPRECO_PAR.FieldByName('CODE_MODELE').AsString := FieldByName('CODE_MODELE').AsString;
                    FTARPRECO_PAR.FieldByName('TPO_ARTID').AsInteger := Article.ART_ID;
                    FTARPRECO_PAR.FieldByName('TPO_DT').AsDateTime := FieldByName('DATE_VALEUR').AsDateTime;
                    FTARPRECO_PAR.FieldByName('TPO_PX').AsCurrency := fPrix;
                    FTARPRECO_PAR.FieldByName('TPO_ETAT').AsInteger := 3;
                    FTARPRECO_PAR.Post;
                  end;

                  if not FTARVALID_PAR.ClientDataset.Locate('CODE_ARTICLE;TVD_DT;TVD_PX',
                                                             VarArrayOf([FieldByName('CODE_ARTICLE').AsString,
                                                                         FieldByName('DATE_VALEUR').AsDateTime,
                                                                         fPrix]),[]) then
                  begin
                    if prems or (fTarifBase <> fPrix) then
                    begin
                      FTARVALID_PAR.Append;
                      FTARVALID_PAR.FieldByName('CODE_MODELE').AsString  := FieldByName('CODE_MODELE').AsString;
                      FTARVALID_PAR.FieldByName('CODE_ARTICLE').AsString := FieldByName('CODE_ARTICLE').AsString;
                      FTARVALID_PAR.FieldByName('TVD_ARTID').AsInteger   := Article.ART_ID;
                      if prems then
                      begin
                        FTARVALID_PAR.FieldByName('TVD_TGFID').AsInteger   := 0;
                        FTARVALID_PAR.FieldByName('TVD_COUID').AsInteger   := 0;
                      end else begin
                        FTARVALID_PAR.FieldByName('TVD_TGFID').AsInteger   := Article.TGF_ID;
                        FTARVALID_PAR.FieldByName('TVD_COUID').AsInteger   := Article.COU_ID;
                      end;
                      FTARVALID_PAR.FieldByName('TPO_DT').AsDateTime     := FieldByName('DATE_VALEUR').AsDateTime;
                      FTARVALID_PAR.FieldByName('TVD_DT').AsDateTime     := FieldByName('DATE_VALEUR').AsDateTime;
                      FTARVALID_PAR.FieldByName('TVD_PX').AsCurrency     := fPrix;
                      FTARVALID_PAR.FieldByName('TVD_ETAT').AsInteger    := 0;
                      FTARVALID_PAR.FieldByName('TVD_CENTRALE').AsInteger := iCentrale;
                      FTARVALID_PAR.Post;
                    end;
                  end;

                end
                else
                  raise Exception.Create('Pas de traitement pour cette ligne');
              end;
            end;
          end;
        end;
      except on E:Exception do
        begin
          Erreur := TErreur.Create;
          Erreur.AddError(FPRIXVENTE_File,'Import',E.Message,RecNo,tePrixDeVente,0,'');
          GERREURS.Add(Erreur);
          IncError ;
        end;
      end;

      BarPosition(RecNo * 100 Div RecordCount);
      Next;
    end;
  end;

  {$REGION 'Traitement des Tarifs de vente'}
  LabCaption('Traitement des tarifs de ventes');
  With FMODELEVENTE do
  Try
    First;
    while not EOF do
    begin
      // Filtrage pour traiter les tarifs de chaque modèle
      FTARPRIXVENTE.ClientDataset.Filtered := False;
      FTARPRIXVENTE.ClientDataset.Filter := 'CODE_MODELE = ' + QuotedStr(FieldByName('CODE_MODELE').AsString);
      FTARPRIXVENTE.ClientDataset.Filtered := True;
      FTARPRIXVENTE.First;

      // est ce qu' l'on a une date de tarif de base ?
      if FieldByName('DateTarifBase').AsDateTime = 0 then
      begin
        // si non on cherche a plus petite date dans la liste
        dDateTarifBase := TDate(FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime);
        while not FTARPRIXVENTE.EOF do
        begin
          if CompareDate(FTARPRIXVENTE.FieldbyName('TarifDate').AsDateTime,dDateTarifBase) = LessThanValue then
            dDateTarifBase := TDate(FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime);
          FTARPRIXVENTE.Next;
        end;
        FMODELEVENTE.Edit;
        FMODELEVENTE.FieldByName('DateTarifBase').AsDateTime := dDateTarifBase;
        FMODELEVENTE.Post;
      end;

      // Dans tous les cas on supprime les tarifs qui sont inférieur à la DateTarifBase
      FTARPRIXVENTE.First;
      while not FTARPRIXVENTE.EOF do
      begin
        if CompareDate(FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime,FieldByName('DateTarifBase').AsDateTime) = LessThanValue then
          FTARPRIXVENTE.ClientDataset.Delete
        else
          FTARPRIXVENTE.Next;
      end;

      // On transfert en prix recommandé les modèles sont la date est supérieur à DateTarifBase
      // ou Si le modèle n'est pas nouveau
      // Et que la date est > à la date du jour
      FTARPRIXVENTE.First;
      while not FTARPRIXVENTE.EOF do
      begin
        if ((CompareDate(FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime,FieldByName('DateTarifBase').AsDateTime) = GreaterThanValue) or
            not FieldByName('IsNewArt').AsBoolean) then
        begin
          // Si la tarif est inférieur à la date du jour on le met à la date du jour + 1 (Modif du 15/01/2018)
          if (CompareDate(FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime,Now) < EqualsValue) then
          begin
            FTARPRIXVENTE.Edit;
            FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime := IncDay(Now);
            FTARPRIXVENTE.Post;
          end;

          // Transfert des données en prix recommandé à date
          // Il y a déjà un tarif de base ou le modèle n'est pas nouveau donc on va créer des tarifs préco
          if not FTARPRECO.ClientDataset.Locate('CODE_MODELE;TPO_DT;TPO_PX',
                                         VarArrayOf([FTARPRIXVENTE.FieldByName('CODE_MODELE').AsString,
                                                     FieldByName('DateTarifBase').AsDateTime,
                                                     FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency]),[locaseInsensitive]) then
          begin
            FTARPRECO.Append;
            FTARPRECO.FieldByName('CODE_MODELE').AsString := FTARPRIXVENTE.FieldByName('CODE_MODELE').AsString;
            FTARPRECO.FieldByName('TPO_ARTID').AsInteger  := FTARPRIXVENTE.FieldByName('PVT_ARTID').AsInteger;
            FTARPRECO.FieldByName('TPO_DT').AsDateTime    := FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime;
//            FTARPRECO.FieldByName('TPO_DT').AsDateTime    := FieldByName('DateTarifBase').AsDateTime;
            FTARPRECO.FieldByName('TPO_PX').AsCurrency    := FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency;
            FTARPRECO.FieldByName('TPO_ETAT').AsInteger   := 3;
            FTARPRECO.Post;
          end;

          if not FTARVALID.ClientDataset.Locate('CODE_ARTICLE;TVD_DT;TVD_PX',
                                                VarArrayOf([FTARPRIXVENTE.FieldByName('CODE_ARTICLE').AsString,
                                                            FieldByName('DateTarifBase').AsDateTime,
                                                            FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency]),[]) then
          begin
            FTARVALID.Append;
            FTARVALID.FieldByName('CODE_MODELE').AsString  := FTARPRIXVENTE.FieldByName('CODE_MODELE').AsString;
            FTARVALID.FieldByName('CODE_ARTICLE').AsString := FTARPRIXVENTE.FieldByName('CODE_ARTICLE').AsString;
            FTARVALID.FieldByName('TVD_ARTID').AsInteger   := FTARPRIXVENTE.FieldByName('PVT_ARTID').AsInteger;
            FTARVALID.FieldByName('TVD_TGFID').AsInteger   := FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger;
            FTARVALID.FieldByName('TVD_COUID').AsInteger   := FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger;
            FTARVALID.FieldByName('TPO_DT').AsDateTime     := FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime;
            FTARVALID.FieldByName('TVD_DT').AsDateTime     := FTARPRIXVENTE.FieldByName('TarifDate').AsDateTime;
            FTARVALID.FieldByName('TVD_PX').AsCurrency     := FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency;
            FTARVALID.FieldByName('TVD_ETAT').AsInteger    := 0;
            FTARVALID.FieldByName('TVD_CENTRALE').AsInteger    := FTARPRIXVENTE.FieldByName('PVT_CENTRALE').AsInteger;
            FTARVALID.Post;
          end;

          // Suppréssion de la données
          FTARPRIXVENTE.ClientDataset.Delete;
        end
        else
          // Si ce n'est pas un nouveau model on supprime la données de tarif
          if not FieldByName('IsNewArt').AsBoolean  then
            FTARPRIXVENTE.ClientDataset.Delete
          else
           FTARPRIXVENTE.Next;
      end;

      BarPosition(ClientDataSet.RecNo * 100 Div ClientDataSet.RecordCount);
      Next;
    end;
  finally
    if vRejected > 0 then
      DM_GSDataMain.AddToMemo(Format(' Nombre de lignes rejetées : %s', [IntToStr(vRejected)]));
    FTARPRIXVENTE.ClientDataset.Filtered := False;
  end; // with
  {$ENDREGION}

end;

function TPrixVente.SetOCDETAIL(AOCD_OCLID, AOCD_ARTID, AOCD_TGFID,
  AOCD_COUID: Integer; AOCD_PRIX: Currency; AOCD_ACTIVE,
  AOCD_CENTRALE: Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('SELECT * from  GOS_SETOCDETAIL(:POCLID, :PARTID, :PTGFID, :PCOUID, :POCDPRIX, :PACTIVE, :PCENTRALE)');
    ParamCheck := True;
    ParamByName('POCLID').AsInteger    := AOCD_OCLID;
    ParamByName('PARTID').AsInteger    := AOCD_ARTID;
    ParamByName('PTGFID').AsInteger    := AOCD_TGFID;
    ParamByName('PCOUID').AsInteger    := AOCD_COUID;
    ParamByName('POCDPRIX').AsCurrency := AOCD_PRIX;
    ParamByName('PACTIVE').AsInteger   := AOCD_ACTIVE;
    ParamByName('PCENTRALE').AsInteger := AOCD_CENTRALE;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('OCD_ID').AsInteger;
      Inc(FInsertCount,fieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;
  except on E: Exception do
    raise Exception.Create('SetOCDETAIL -> ' + E.Message);
  end;
end;

function TPrixVente.SetOCLIGNES(AOCL_ARTID: Integer; AOCL_PXVTE: Currency;
  AOCL_OCTID, AOCL_LOTID: Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM GOS_SETOCLIGNES(:PARTID, :POCLPXVTE, :POCTID, :PLOTID)');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AOCL_ARTID;
    ParamByName('POCLPXVTE').AsCurrency := AOCL_PXVTE;
    ParamByName('POCTID').AsInteger := AOCL_OCTID;
    ParamByName('PLOTID').AsInteger := AOCL_LOTID;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('OCL_ID').AsInteger;
      Inc(FInsertCount,fieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;

  except on E: Exception do
    raise Exception.Create('SetOCLIGNES -> ' + E.Message);
  end;
end;

function TPrixVente.setOCTETE_SOLDE(AOCT_NOM, AOCT_COMMENT: string; AOCT_DEBUT,
  AOCT_FIN: TDate; AOCT_TYPID, AOCT_WEB, AOCT_CENTRALE: Integer;
  AOCT_CODE: String; AOCT_TYPEPRIX: Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.add('SELECT * from GOS_SETOCTETE_SOLDE(:POCTNOM, :POCTCOMMENT, :POCTDEBUT,');
    SQL.Add(' :POCTFIN, :PTYPID, :POCTWEB, :PCENTRALE, :POCTCODE, :POCTTYPEPRIX)');
    ParamCheck := True;
    ParamByName('POCTNOM').AsString := AOCT_NOM;
    ParamByName('POCTCOMMENT').AsString := AOCT_COMMENT;
    ParamByName('POCTDEBUT').AsDate := AOCT_DEBUT;
    ParamByName('POCTFIN').AsDate := AOCT_FIN;
    ParamByName('PTYPID').AsInteger := AOCT_TYPID;
    ParamByName('POCTWEB').AsInteger := AOCT_WEB;
    ParamByName('PCENTRALE').AsInteger := AOCT_CENTRALE;
    ParamByName('POCTCODE').AsString := AOCT_CODE;
    ParamByName('POCTTYPEPRIX').AsInteger := AOCT_TYPEPRIX;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('OCT_ID').AsInteger;
      Inc(FInsertCount,fieldByName('FAJOUT').AsInteger);
    end;

  except on E: Exception do
  end;
end;

function TPrixVente.SetOPECOMMAG(AOCT_ID, AMAG_ID: Integer): Integer;
begin
  With FIboQuery do
  try
    close;
    SQL.Clear;
    SQL.Add('Select * from GOS_OPECOMMAG(:POCTID, :PMAGID)');
    ParamCheck := True;
    ParamByName('POCTID').AsInteger := AOCT_ID;
    ParamByName('PMAGID').AsInteger := AMAG_ID;
    Open ;
  except on E: Exception do
  end;
end;

function TPrixVente.SetTARPRECO(ATPO_ARTID: Integer; ATPO_DT: TDate;
  ATPO_PX: Currency; ATPO_ETAT: Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('SELECT * from GOS_SETTARPRECO(:PTPOARTID, :PTPODATE, :PTPOPX, :PTPOETAT)');
    ParamCheck := True;
    ParamByName('PTPOARTID').AsInteger := ATPO_ARTID;
    ParamByName('PTPODATE').AsDate     := ATPO_DT;
    ParamByName('PTPOPX').AsCurrency   := ATPO_PX;
    ParamByName('PTPOETAT').AsInteger  := ATPO_ETAT;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('TPO_ID').AsInteger;
      Inc(FInsertCount,fieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;
  except on E: Exception do
    raise Exception.Create('SetTARPRECO -> ' + E.Message);
  end;

end;

function TPrixVente.SetTARPRIXVENTE(APVT_TVTID, APVT_ARTID, APVT_TGFID,
  APVT_COUID: Integer; APVT_PX: Currency; APVT_CENTRALE: Integer): Integer;

begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('SELECT * from GOS_SETTARPRIXVENTE(:PTVTID, :PARTID, :PTGFID, :PCOUID, :PPVTPX, :PCENTRALE)');
    ParamCheck := True;
    ParamByName('PTVTID').AsInteger    := APVT_TVTID;
    ParamByName('PARTID').AsInteger    := APVT_ARTID;
    ParamByName('PTGFID').AsInteger    := APVT_TGFID;
    ParamByName('PCOUID').AsInteger    := APVT_COUID;
    ParamByName('PPVTPX').AsCurrency   := APVT_PX;
    ParamByName('PCENTRALE').AsInteger := APVT_CENTRALE;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('PVT_ID').AsInteger;
      Inc(FInsertCount,fieldByName('FAJOUT').AsInteger);
    end;

  Except on E:eXception do
    raise Exception.Create('SetTARPRIXVENTE -> ' + E.Message);
  end;
end;

function TPrixVente.SetTARVALID(ATVD_TPOID, ATVD_TVTID, ATVD_ARTID, ATVD_TGFID,
  ATVD_COUID: Integer; ATVD_PX: Currency; ATVD_DT: TDate;
  ATVD_ETAT, ACEN_CODE: Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    if FBaseVersion = 1
      then SQL.Add('SELECT * From GOS_SETTARVALID(:PTPOID, :PTTVTID, :PARTID, :PTGFID, :PCOUID, :PTVDPX, :PTVDDT, :PTVDETAT)');
    if FBaseVersion = 2
      then SQL.Add('SELECT * From GOS_SETTARVALID(:PTPOID, :PTTVTID, :PARTID, :PTGFID, :PCOUID, :PTVDPX, :PTVDDT, :PTVDETAT, :CENCODE)');

    ParamCheck := True;
    ParamByName('PTPOID').AsInteger   := ATVD_TPOID;
    ParamByName('PTTVTID').AsInteger  := ATVD_TVTID;
    ParamByName('PARTID').AsInteger   := ATVD_ARTID;
    ParamByName('PTGFID').AsInteger   := ATVD_TGFID;
    ParamByName('PCOUID').AsInteger   := ATVD_COUID;
    ParamByName('PTVDPX').AsCurrency  := ATVD_PX;
    ParamByName('PTVDDT').AsDate      := ATVD_DT;
    ParamByName('PTVDETAT').AsInteger := ATVD_ETAT;

    if FBaseVersion = 2
      then ParamByName('CENCODE').AsInteger := ACEN_CODE;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('TVD_ID').AsInteger;
      Inc(FInsertCount,fieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;
  except on E: Exception do
    raise Exception.Create('SetTARVALID -> ' + E.Message);
  end;
end;

function TPrixVente.IsTarifZero(AART_ID: Integer): Boolean;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select PVT_PX from TARPRIXVENTE');
    SQL.Add('  Join K on K_ID = PVT_ID and K_Enabled = 1');
    SQL.Add('Where PVT_ARTID = :PARTID');
    SQL.Add('  and PVT_TGFID = 0');
    SQL.Add('  and PVT_COUID = 0');
    SQL.Add('  and PVT_TVTID = 0');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AART_ID;
    Open;
    if not IsEmpty then
      Result := (CompareValue(FieldByName('PVT_PX').AsCurrency,0,0.001) = EqualsValue)
    else
      Result := False;

  Except on E:exception do
    raise Exception.Create('IsTarifZero -> ' + E.Message);
  End;
end;

function TPrixVente.DoMajTable : Boolean;
Var
   Erreur : TErreur;
   TVT_ID, TPO_ID, OCL_ID, OCT_ID, OCT_CENTRALE : Integer;
   bDataFound : Boolean;
begin
  // Récupération du TVT_ID GoSport
  case FMagType of
    mtCourir:   TVT_ID := GetIDFromTable('TARVENTE','TVT_CENTRALE',CTE_COURIR,'TVT_ID');
    mtGoSport:  TVT_ID := GetIDFromTable('TARVENTE','TVT_CENTRALE',CTE_GOSPORT,'TVT_ID');
  end;


  {$REGION 'Traitement des tarifs de vente'}
  LabCaption('Intégration (1/5) des prix de vente');

  With FTARPRIXVENTE do
  begin
    First;
    while not EOF do
    begin
      FIboQuery.IB_Transaction.StartTransaction;
      try
        // Tarif de vente standard
        SetTARPRIXVENTE(
                         FieldByName('PVT_TVTID').AsInteger, // APVT_TVTID,
                         FieldByName('PVT_ARTID').AsInteger, // APVT_ARTID,
                         FieldByName('PVT_TGFID').AsInteger, // APVT_TGFID,
                         FieldByName('PVT_COUID').AsInteger, // APVT_COUID: Integer;
                         FieldByName('PVT_PX').AsCurrency, // APVT_PX: Currency;
                         FieldByName('PVT_CENTRALE').AsInteger // APVT_CENTRALE: Integer
                        );

        // Tarif de vente GOSport
        SetTARPRIXVENTE(
                         TVT_ID, // APVT_TVTID,
                         FieldByName('PVT_ARTID').AsInteger, // APVT_ARTID,
                         FieldByName('PVT_TGFID').AsInteger, // APVT_TGFID,
                         FieldByName('PVT_COUID').AsInteger, // APVT_COUID: Integer;
                         FieldByName('PVT_PX').AsCurrency, // APVT_PX: Currency;
                         FieldByName('PVT_CENTRALE').AsInteger // APVT_CENTRALE: Integer
                        );
      FIboQuery.IB_Transaction.Commit;
      Except on E:Exception do
        begin
          FIboQuery.IB_Transaction.Rollback;

          Erreur := TErreur.Create;
          Erreur.AddError(FPRIXVENTE_File,'Intégration PX VTE',E.Message,0,tePrixDeVente,0,'');
          GERREURS.Add(Erreur);
          IncError ;
        end;
      end;
      BarPosition(ClientDataSet.RecNo * 100 Div ClientDataSet.RecordCount);
      Next;
    end;
  end;
  {$ENDREGION}

  {$REGION 'Traitement des tarifs préco'}
  LabCaption('Intégration (2/5) des tarifs préconisés');
  FTARPRECO.First;
  while not FTARPRECO.EOF do
  begin
    FIboQuery.IB_Transaction.StartTransaction;
    try
      TPO_ID := SetTARPRECO(
                   FTARPRECO.FieldByName('TPO_ARTID').AsInteger, // ATPO_ARTID: Integer;
                   FTARPRECO.FieldByName('TPO_DT').AsDateTime,   // ATPO_DT: TDate;
                   FTARPRECO.FieldByName('TPO_PX').AsCurrency,   // ATPO_PX: Currency;
                   FTARPRECO.FieldByName('TPO_ETAT').AsInteger   // TPO_ETAT : Integer
                  );

      FTARPRECO.Edit;
      FTARPRECO.FieldByName('TPO_ID').AsInteger := TPO_ID;
      FTARPRECO.Post;

      Log.Log( 'PrixVente', '', '', 'Log', 'Intégration : TPO_ID:'+IntToStr(TPO_ID)
        +' TPO_ARTID:'+IntToStr(FTARPRECO.FieldByName('TPO_ARTID').AsInteger)
        +' TPO_DT'+DateTimeToStr(FTARPRECO.FieldByName('TPO_DT').AsDateTime)
        +' TPO_PX'+CurrToStr(FTARPRECO.FieldByName('TPO_PX').AsCurrency), logDebug, False, 0, ltLocal);

      FTARVALID.First;
      while not FTARVALID.EOF do
      begin
        // Tarif général
        SetTARVALID(
                    TPO_ID,                                       // ATVD_TPOID,
                    FTARVALID.FieldByName('TVD_TVTID').AsInteger, // ATVD_TVTID,
                    FTARVALID.FieldByName('TVD_ARTID').AsInteger, // ATVD_ARTID,
                    FTARVALID.FieldByName('TVD_TGFID').AsInteger, // ATVD_TGFID,
                    FTARVALID.FieldByName('TVD_COUID').AsInteger, // ATVD_COUID: Integer;
                    FTARVALID.FieldByName('TVD_PX').AsCurrency,   // ATVD_PX: Currency;
                    FTARVALID.FieldByName('TVD_DT').AsDateTime,   // ATVD_DT: TDate;
                    FTARVALID.FieldByName('TVD_ETAT').AsInteger,   // ATVD_ETAT: Integer
                    FTARVALID.FieldByName('TVD_CENTRALE').AsInteger
                    );


        // Tarif Gosport
        SetTARVALID(
                    TPO_ID,                                       // ATVD_TPOID,
                    TVT_ID,                                       // ATVD_TVTID,
                    FTARVALID.FieldByName('TVD_ARTID').AsInteger, // ATVD_ARTID,
                    FTARVALID.FieldByName('TVD_TGFID').AsInteger, // ATVD_TGFID,
                    FTARVALID.FieldByName('TVD_COUID').AsInteger, // ATVD_COUID: Integer;
                    FTARVALID.FieldByName('TVD_PX').AsCurrency,   // ATVD_PX: Currency;
                    FTARVALID.FieldByName('TVD_DT').AsDateTime,   // ATVD_DT: TDate;
                    1,                                            // ATVD_ETAT: Integer
                    FTARVALID.FieldByName('TVD_CENTRALE').AsInteger
                    );

        Log.Log( 'PrixVente', '', '', 'Log', 'Intégration : TPO_ID:'+IntToStr(TPO_ID)
          +' TVD_ARTID:'+IntToStr( FTARVALID.FieldByName('TVD_ARTID').AsInteger )
          +' TVD_TGFID:'+IntToStr( FTARVALID.FieldByName('TVD_TGFID').AsInteger )
          +' TVD_COUID:'+IntToStr( FTARVALID.FieldByName('TVD_COUID').AsInteger )
          +' TVD_PX:'+CurrToStr( FTARVALID.FieldByName('TVD_PX').AsCurrency )
          +' TVD_DT:'+DateTimeToStr( FTARVALID.FieldByName('TVD_DT').AsDateTime ), logDebug, False, 0, ltLocal);


        FTARVALID.Next;
      end;

      // Remise en route d'un modèle (ART_FDS 1 -> 0)
      if FArticleFichier.ClientDataset.Active and FArticleFichier.ClientDataset.Locate('ART_CODE', FTARVALID.FieldByName('CODE_MODELE').AsString, [loCaseInsensitive]) then
      begin
        if FArticleFichier.FieldByName('ART_FDS').AsInteger = 1 then
          UpdARTFDS(FTARVALID.FieldByName('TVD_ARTID').AsInteger,0);
      end
      else
        UpdARTFDS(FTARVALID.FieldByName('TVD_ARTID').AsInteger,0);

      FIboQuery.IB_Transaction.Commit;

    Except on E:Exception do
      begin
        FIboQuery.IB_Transaction.Rollback;

        Erreur := TErreur.Create;
        Erreur.AddError(FPRIXVENTE_File,'Intégration Préco Date',E.Message,0,tePrixDeVente,0,'');
        GERREURS.Add(Erreur);
        IncError ;
      end;
    end;
    BarPosition(FTARPRECO.ClientDataSet.RecNo * 100 Div FTARPRECO.ClientDataSet.RecordCount);
    FTARPRECO.Next;
  end;
  {$ENDREGION}

  {$REGION 'Prix des opérations commerciales'}
  LabCaption('Intégration (3/5) des tarifs d''opérations commerciales');
  FOCLIGNES.ClientDataset.Filtered := False;
  FOCLIGNES.ClientDataset.Filter := 'Error = ' + BoolToStr(False) + ' and NumOC = 0';
  FOCLIGNES.ClientDataset.Filtered := True;

  // Traitement des lignes
  FOCLIGNES.First;
  while not FOCLIGNES.EOF do
  begin
     FIboQuery.IB_Transaction.StartTransaction;
    try
      OCL_ID := SetOCLIGNES(
                   FOCLIGNES.FieldByName('OCL_ARTID').AsInteger,  // AOCL_ARTID: Integer;
                   FOCLIGNES.FieldByName('OCL_PXVTE').AsCurrency, // AOCL_PXVTE: Currency;
                   FOCLIGNES.FieldByName('OCL_OCTID').AsInteger,  // AOCL_OCTID,
                   FOCLIGNES.FieldByName('OCL_LOTID').AsInteger   // AOCL_LOTID: Integer
                  );

      FOCLIGNES.Edit;
      FOCLIGNES.FieldByName('OCL_ID').AsInteger := OCL_ID;
      FOCLIGNES.Post;

      // Traitement des détails de lignes
      FOCDETAIL.First;
      while not FOCDETAIL.Eof do
      begin
        SetOCDETAIL(
                    OCL_ID, // AOCD_OCLID,
                    FOCDETAIL.FieldByName('OCD_ARTID').AsInteger,   // AOCD_ARTID,
                    FOCDETAIL.FieldByName('OCD_TGFID').AsInteger,   // AOCD_TGFID,
                    FOCDETAIL.FieldByName('OCD_COUID').AsInteger,   // AOCD_COUID: Integer;
                    FOCDETAIL.FieldByName('OCD_PRIX').AsCurrency,   // AOCD_PRIX: Currency;
                    FOCDETAIL.FieldByName('OCD_ACTIVE').AsInteger,  // AOCD_ACTIVE,
                    FOCDETAIL.FieldByName('OCD_CENTRALE').AsInteger // AOCD_CENTRALE: Integer
                    );

        FOCDETAIL.Next;
      end;

      FIboQuery.IB_Transaction.Commit;
    except on E: Exception do
      begin
        FIboQuery.IB_Transaction.Rollback;

        Erreur := TErreur.Create;
        Erreur.AddError(FPRIXVENTE_File,'Intégration Prix OC',E.Message,0,tePrixDeVente,0,'');
        GERREURS.Add(Erreur);
        IncError ;
      end;
    end;
    BarPosition(FOCLIGNES.ClientDataSet.RecNo * 100 Div FOCLIGNES.ClientDataSet.RecordCount);
    FOCLIGNES.Next;
  end;
  {$ENDREGION}

  {$REGION 'Prix des soldes à venir'}
  LabCaption('Intégration (4/5) des prix des soldes à venir');
  FOCTETE.First;
  while not FOCTETE.EOF do
  begin
    FIboQuery.IB_Transaction.StartTransaction;
    try
      // Recherche d'une entête correspondante
      With FIboQuery do
      begin
        // Récupération de toutes les OC correspondante
        Close;
        SQL.Clear;
        SQL.Add('SELECT OCT_ID, OCT_CENTRALE, OCT_DEBUT, OCT_FIN FROM OCTETE');
        SQL.Add('  Join K on K_ID = OCT_ID and K_Enabled = 1');
        SQL.Add('Where OCT_TYPID = :PTYPID');
        SQL.Add('  and OCT_CENTRALE = :PCENTRALE');
        SQL.Add('  and OCT_FIN = :POCTFIN');
        SQL.Add('  and OCT_DEBUT <= :POCTDEBUT');
        ParamCheck := True;
        ParamByName('PTYPID').AsInteger := FOCTETE.FieldByName('OCT_TYPID').AsInteger;
        ParamByName('PCENTRALE').AsInteger := FOCTETE.FieldByName('OCT_CENTRALE').AsInteger;
        ParamByName('POCTFIN').AsDate := FOCTETE.FieldByName('OCT_FIN').AsDateTime;
        ParamByName('POCTDEBUT').AsDate := FOCTETE.FieldByName('OCT_DEBUT').AsDateTime;
        Open;

        bDataFound := False;
        First;
        while not EOF and not bDataFound do
        begin
          // Est ce DATE_VALEUR (OCTETE->OCT_DEBUT) = OCT_DEBUT ?
          if CompareDate(FieldByName('OCT_DEBUT').AsDateTime,FOCTETE.FieldByName('OCT_DEBUT').AsDateTime) = EqualsValue  then
          begin
            bDataFound := True;
            OCT_ID := FieldByName('OCT_ID').AsInteger;
            OCT_CENTRALE := FieldByName('OCT_CENTRALE').AsInteger;
          end
          else begin
            // Est ce que DATE_VALEUR(OCT_TETE->OCT_DEBUT) <= à la date du jour et OCT_DEBUT <= Date du jour ?
            if (CompareDate(FOCTETE.FieldByName('OCT_DEBUT').AsDateTime,Now) <> GreaterThanValue) and
               (CompareDate(FieldByName('OCT_DEBUT').AsDateTime,Now) <> GreaterThanValue)  then
            begin
              bDataFound := True;
              OCT_ID := FieldByName('OCT_ID').AsInteger;
              OCT_CENTRALE := FieldByName('OCT_CENTRALE').AsInteger;
            end;
          end;
          Next;
        end;
      end;

      if not bDataFound then
      begin
        // création d'une entête
        OCT_CENTRALE := FOCTETE.FieldByName('OCT_CENTRALE').AsInteger ;
        OCT_ID := SetOCTETE_SOLDE(
                        FOCTETE.FieldByName('OCT_NOM').AsString,       // AOCT_NOM,
                        FOCTETE.FieldByName('OCT_COMMENT').AsString,   // AOCT_COMMENT: string;
                        FOCTETE.FieldByName('OCT_DEBUT').AsDateTime,   // AOCT_DEBUT,
                        FOCTETE.FieldByName('OCT_FIN').AsDateTime,     // AOCT_FIN: TDate;
                        FOCTETE.FieldByName('OCT_TYPID').AsInteger,    // AOCT_TYPID,
                        FOCTETE.FieldByName('OCT_WEB').AsInteger,      // AOCT_WEB,
                        FOCTETE.FieldByName('OCT_CENTRALE').AsInteger, // AOCT_CENTRALE: Integer;
                        FOCTETE.FieldByName('OCT_CODE').AsString,      //  AOCT_CODE: String;
                        FOCTETE.FieldByName('OCT_TYPEPRIX').AsInteger  // AOCT_TYPEPRIX: Integer
                        );
      end;

      FOCTETE.Edit;
      FOCTETE.FieldByName('OCT_ID').AsInteger := OCT_ID;
      FOCTETE.Post;

      // Traitement des lignes de cette OC
      FOCLIGNES.ClientDataset.Filtered := False;
      FOCLIGNES.ClientDataset.Filter := 'NUMOC = ' + FOCTETE.FieldByName('NUMOC').AsString;
      FOCLIGNES.ClientDataset.Filtered := True;

      FOCLIGNES.First;
      while not FOCLIGNES.EOF do
      begin
        OCL_ID := SetOCLIGNES(
                     FOCLIGNES.FieldByName('OCL_ARTID').AsInteger,  // AOCL_ARTID: Integer;
                     FOCLIGNES.FieldByName('OCL_PXVTE').AsCurrency, // AOCL_PXVTE: Currency;
                     OCT_ID,  // AOCL_OCTID,
                     FOCLIGNES.FieldByName('OCL_LOTID').AsInteger   // AOCL_LOTID: Integer
                    );

        FOCLIGNES.Edit;
        FOCLIGNES.FieldByName('OCL_ID').AsInteger := OCL_ID;
        FOCLIGNES.Post;

        // Traitement des détails de lignes
        FOCDETAIL.First;
        while not FOCDETAIL.Eof do
        begin
          SetOCDETAIL(
                      OCL_ID, // AOCD_OCLID,
                      FOCDETAIL.FieldByName('OCD_ARTID').AsInteger,   // AOCD_ARTID,
                      FOCDETAIL.FieldByName('OCD_TGFID').AsInteger,   // AOCD_TGFID,
                      FOCDETAIL.FieldByName('OCD_COUID').AsInteger,   // AOCD_COUID: Integer;
                      FOCDETAIL.FieldByName('OCD_PRIX').AsCurrency,   // AOCD_PRIX: Currency;
                      FOCDETAIL.FieldByName('OCD_ACTIVE').AsInteger,  // AOCD_ACTIVE,
                      FOCDETAIL.FieldByName('OCD_CENTRALE').AsInteger // AOCD_CENTRALE: Integer
                      );

          FOCDETAIL.Next;
          LabCaption(Format('Lignes : %d/%d - Details : %d/%d',
                            [FOCLIGNES.ClientDataset.RecNo,FOCLIGNES.ClientDataset.RecordCount,
                             FOCDETAIL.ClientDataset.RecNo,FOCDETAIL.ClientDataset.RecordCount]));

        end;

        FOCLIGNES.Next;
      end;

      // Liaison de l'enete avec le magasin
//CAF
      if MAG_MODE = mtCAF then
//      if OCT_CENTRALE = CTE_COURIR then
        SetOPECOMMAG(OCT_ID,MAG_ID);

      FIboQuery.IB_Transaction.Commit;
    Except on E:Exception do
      begin
        FIboQuery.IB_Transaction.Rollback;

        Erreur := TErreur.Create;
        Erreur.AddError(FPRIXVENTE_File,'Intégration PRIX SOLDE',E.Message,0,tePrixDeVente,0,'');
        GERREURS.Add(Erreur);
        IncError ;
      end;
    end;
    BarPosition(FOCTETE.ClientDataSet.RecNo * 100 Div FOCTETE.ClientDataSet.RecordCount);
    FOCTETE.Next;
  end;
  {$ENDREGION}

  {$REGION 'Prix d''article remisé'}
  FTARPRECO_PAR.First;
  LabCaption('Intégration (5/5) des prix d''articles remisés');
  while not FTARPRECO_PAR.EOF do
  begin
    FIboQuery.IB_Transaction.StartTransaction;
    try
      TPO_ID := SetTARPRECO(
                   FTARPRECO_PAR.FieldByName('TPO_ARTID').AsInteger, // ATPO_ARTID: Integer;
                   FTARPRECO_PAR.FieldByName('TPO_DT').AsDateTime,   // ATPO_DT: TDate;
                   FTARPRECO_PAR.FieldByName('TPO_PX').AsCurrency,   // ATPO_PX: Currency;
                   FTARPRECO_PAR.FieldByName('TPO_ETAT').AsInteger   // TPO_ETAT : Integer
                  );

      Log.Log( 'PrixVente', '', '', 'Log', 'Intégration : TPO_ID:'+IntToStr(TPO_ID)
        +' TPO_ARTID:'+IntToStr(FTARPRECO_PAR.FieldByName('TPO_ARTID').AsInteger)
        +' TPO_DT'+DateTimeToStr(FTARPRECO_PAR.FieldByName('TPO_DT').AsDateTime)
        +' TPO_PX'+CurrToStr(FTARPRECO_PAR.FieldByName('TPO_PX').AsCurrency), logDebug, False, 0, ltLocal);

      FTARPRECO_PAR.Edit;
      FTARPRECO_PAR.FieldByName('TPO_ID').AsInteger := TPO_ID;
      FTARPRECO_PAR.Post;


      FTARVALID_PAR.First;
      while not FTARVALID_PAR.EOF do
      begin
        // Tarif général
        SetTARVALID(
                    TPO_ID,                                           // ATVD_TPOID,
                    0,                                                // ATVD_TVTID,
                    FTARVALID_PAR.FieldByName('TVD_ARTID').AsInteger, // ATVD_ARTID,
                    FTARVALID_PAR.FieldByName('TVD_TGFID').AsInteger, // ATVD_TGFID,
                    FTARVALID_PAR.FieldByName('TVD_COUID').AsInteger, // ATVD_COUID: Integer;
                    FTARVALID_PAR.FieldByName('TVD_PX').AsCurrency,   // ATVD_PX: Currency;
                    FTARVALID_PAR.FieldByName('TVD_DT').AsDateTime,   // ATVD_DT: TDate;
                    FTARVALID_PAR.FieldByName('TVD_ETAT').AsInteger,   // ATVD_ETAT: Integer
                    FTARVALID_PAR.FieldByName('TVD_CENTRALE').AsInteger
                    );


        // Tarif Gosport
        SetTARVALID(
                    TPO_ID,                                           // ATVD_TPOID,
                    TVT_ID,                                   // ATVD_TVTID,
                    FTARVALID_PAR.FieldByName('TVD_ARTID').AsInteger, // ATVD_ARTID,
                    FTARVALID_PAR.FieldByName('TVD_TGFID').AsInteger, // ATVD_TGFID,
                    FTARVALID_PAR.FieldByName('TVD_COUID').AsInteger, // ATVD_COUID: Integer;
                    FTARVALID_PAR.FieldByName('TVD_PX').AsCurrency,   // ATVD_PX: Currency;
                    FTARVALID_PAR.FieldByName('TVD_DT').AsDateTime,   // ATVD_DT: TDate;
                    1,                                                // ATVD_ETAT: Integer
                    FTARVALID_PAR.FieldByName('TVD_CENTRALE').AsInteger
                    );

        Log.Log( 'PrixVente', '', '', 'Log', 'Intégration : TPO_ID:'+IntToStr(TPO_ID)
          +' TVD_ARTID:'+IntToStr( FTARVALID_PAR.FieldByName('TVD_ARTID').AsInteger )
          +' TVD_TGFID:'+IntToStr( FTARVALID_PAR.FieldByName('TVD_TGFID').AsInteger )
          +' TVD_COUID:'+IntToStr( FTARVALID_PAR.FieldByName('TVD_COUID').AsInteger )
          +' TVD_PX:'+CurrToStr( FTARVALID_PAR.FieldByName('TVD_PX').AsCurrency )
          +' TVD_DT:'+DateTimeToStr( FTARVALID_PAR.FieldByName('TVD_DT').AsDateTime ), logDebug, False, 0, ltLocal);


        FTARVALID_PAR.Next;
      end;

      FIboQuery.IB_Transaction.Commit;

    Except on E:Exception do
      begin
        FIboQuery.IB_Transaction.Rollback;

        Erreur := TErreur.Create;
        Erreur.AddError(FPRIXVENTE_File,'Intégration Prix remisé',E.Message,0,tePrixDeVente,0,'');
        GERREURS.Add(Erreur);
        IncError ;
      end;
    end;
    BarPosition(FTARPRECO_PAR.ClientDataSet.RecNo * 100 Div FTARPRECO_PAR.ClientDataSet.RecordCount);

    FTARPRECO_PAR.Next;
  end;
  {$ENDREGION}
end;

procedure TPrixVente.UpdARTFDS(AART_ID, AART_FDS: Integer);
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.add('Select * from GOS_UPDARTFDS(:PARTID, :PARTFDS)');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AART_ID;
    ParamByName('PARTFDS').AsInteger := AART_FDS;
    Open;

    if RecordCount > 0 then
    begin
      Inc(FMajCount, FieldByName('FMAJ').AsInteger);
    end;
  except on E: Exception do
    raise Exception.Create('UpdARTFDS -> ' + E.Message);
  end;
end;

end.
