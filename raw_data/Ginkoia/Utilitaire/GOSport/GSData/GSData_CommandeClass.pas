unit GSData_CommandeClass;

interface

uses
  StrUtils, DBClient, SysUtils, IBODataset, Db, Variants,
  //Début Uses Perso
  GSData_MainClass,
  GSData_TErreur,
  GSData_Types,
  GSDataImport_DM,
  DateUtils,
  Types,
  Math,
  //Fin Uses Perso
  Classes;

type

  TCommandeClass = class(TMainClass)
  private
    FFileImport : String;

    FCommande,
    FCommandeLigne : TMainClass;
    DS_FCommande : TDataSource;

    FArtRelationArt: TMainClass;
    FFournisseur: TMainClass;
    FCollections: TIBOQuery;
    FArticleFichier: TMainClass;
    FFournisseurQuery: TIboQuery;

    procedure CreateCdsField;
    // fonction pour récupérer le CPA_ID d'un fournisseur pour un magasin
    function GetCPA_ID(aFouId, aMagId : Integer):Integer;
    // fonction pour récupérer le Taux de Tva d'un article
    function GetTva(aArtId : Integer) : Double;
    // fonction de liaison le larticle avec la collection
    function SetArtColArt(ART_ID, COL_ID : integer) : integer;
    // Récupére le prix de vente en magasin d'un article
    function GetPvMagasin(aCDS : TClientDataSet ; ARTID, TGFID, COUID: Integer): Double;
    // fonction permettant de creer les entetes de commande
    function SetCOMBCDE( ACDE_SAISON, ACDE_EXEID, ACDE_CPAID, ACDE_MAGID, ACDE_FOUID : Integer;
                         ACDE_NUMFOURN : String; ACDE_DATE : TDate; ACDE_TVAHT1, ACDE_TVATAUX1, ACDE_TVA1,
                         ACDE_TVAHT2, ACDE_TVATAUX2, ACDE_TVA2, ACDE_TVAHT3, ACDE_TVATAUX3, ACDE_TVA3,
                         ACDE_TVAHT4, ACDE_TVATAUX4, ACDE_TVA4, ACDE_TVAHT5, ACDE_TVATAUX5, ACDE_TVA5 :Currency;
                         ACDE_MODIF : Integer; ACDE_LIVRAISON : TDate; ACDE_ARCHIVE, ACDE_TYPID, ACDE_CENTRALE,
                         ACDE_USRID :Integer; ACDE_COMENT : string; ACDE_COLID, ACDE_CLOTURE : Integer; ACDE_TYPE : String) : Integer;
    // fonction permettant de traiter les lignes de la commande
    function SetCOMBCDEL( ACDL_CDEID, ACDL_ARTID, ACDL_TGFID, ACDL_COUID : Integer;
                          ACDL_QTE, ACDL_PXACHAT, ACDL_TVA, ACDL_PXVENTE : Currency;
                          ACDL_LIVRAISON : TDate; ACDL_CENTRALE, ACDL_COLID, ACDL_POSTE, ACDL_NUMECHEANCE, AEtat : Integer) : Integer;
    // Permet de récupérer le ART_FDS d'un modèle
    function GetFDSFromModele(AART_ID : Integer): Integer;

    procedure GetCollection (ACodeCol : String; var ACOLID, AEXEID : Integer);
  public
    procedure Import;override;
    function DoMajTable : Boolean;override;

    constructor Create;override;
    destructor Destroy;override;

  published
    // Accès au CDS
    property Commande       : TMainClass read FCommande;
    property CommandeLigne  : TMainClass read FCommandeLigne;

    // Accès aux Cds d'autres actions
    property Fournisseur : TMainClass read FFournisseur write FFournisseur;
    property ArticleFichier  : TMainClass read FArticleFichier  write FArticleFichier;
    property ArtRelationArt : TMainClass read FArtRelationArt write FArtRelationArt;
    // Accès aux Query Communes
    property Collections : TIBOQuery read FCollections write FCollections;
    property FournisseursQuery : TIboQuery read FFournisseurQuery write FFournisseurQuery;
  end;


implementation

{ TCommandeClass }

constructor TCommandeClass.Create;
begin
  inherited Create();

  // Création des ClientDataSets pour les tables
  FCommande := TMainClass.Create();
  FCommandeLigne := TMainClass.Create();
  DS_FCommande := TDataSource.Create(Nil);
  DS_FCommande.DataSet := FCommande.ClientDataset;
end;

procedure TCommandeClass.CreateCdsField;
begin
  // Table ARTARTICLE
  FCommande.CreateField([ 'CDE_ID', 'CDE_NUMERO', 'CDE_SAISON', 'CDE_EXEID',
                          'CDE_CPAID', 'CDE_MAGID', 'CDE_FOUID', 'CDE_NUMFOURN',
                          'CDE_DATE', 'CDE_TVAHT1', 'CDE_TVATAUX1', 'CDE_TVA1',
                          'CDE_TVAHT2', 'CDE_TVATAUX2', 'CDE_TVA2', 'CDE_TVAHT3',
                          'CDE_TVATAUX3', 'CDE_TVA3', 'CDE_TVAHT4', 'CDE_TVATAUX4',
                          'CDE_TVA4', 'CDE_TVAHT5', 'CDE_TVATAUX5', 'CDE_TVA5',
                          'CDE_MODIF', 'CDE_LIVRAISON', 'CDE_ARCHIVE', 'CDE_TYPID',
                          'CDE_CENTRALE', 'CDE_USRID', 'CDE_COMENT', 'CDE_COLID',
                          'CDE_CLOTURE', 'CDE_TYPE', 'Error', 'Created'],
                        [ ftInteger, ftString, ftInteger, ftInteger,
                          ftInteger, ftInteger, ftInteger, ftString,
                          ftDateTime, ftFloat, ftFloat, ftFloat,
                          ftFloat, ftFloat, ftFloat, ftFloat,
                          ftFloat, ftFloat, ftFloat, ftFloat,
                          ftFloat, ftFloat, ftFloat, ftFloat,
                          ftInteger, ftDateTime, ftInteger, ftInteger,
                          ftInteger, ftInteger, ftString, ftInteger,
                          ftInteger, ftString, ftInteger, ftBoolean]);
  FCommande.ClientDataset.AddIndex('Idx','CDE_NUMFOURN',[]);
  FCommande.ClientDataset.IndexName := 'Idx';

  // Table ARTREFERENCE
  FCommandeLigne.CreateField(['CDE_NUMFOURN', 'CDL_ID', 'CDL_CDEID', 'CDL_ARTID',
                              'CDL_TGFID', 'CDL_COUID', 'CDL_QTE', 'CDL_PXACHAT',
                              'CDL_TVA', 'CDL_PXVENTE', 'CDL_LIVRAISON',
                              'CDL_CENTRALE', 'CDL_COLID', 'CDL_POSTE',
                              'CDL_NUMECHEANCE' ,'Etat'],
                             [ftString, ftInteger, ftInteger, ftInteger,
                              ftInteger, ftInteger, ftFloat, ftFloat,
                              ftFloat, ftFloat, ftDateTime,
                              ftInteger, ftInteger, ftInteger,
                              ftInteger, ftInteger]);
  FCommandeLigne.ClientDataset.AddIndex('Idx','CDE_NUMFOURN',[]);
  FCommandeLigne.ClientDataset.IndexName := 'Idx';
  FCommandeLigne.ClientDataset.MasterSource := DS_FCommande;
  FCommandeLigne.ClientDataset.MasterFields := 'CDE_NUMFOURN';
end;

destructor TCommandeClass.Destroy;
begin
  FreeAndNil(FCommande);
  FreeAndNil(FCommandeLigne);
  FreeAndNil(DS_FCommande);

  inherited;
end;

function TCommandeClass.DoMajTable: Boolean;
var
  Erreur : TErreur;
  CDE_ID : Integer;
begin
  With FIboQueryTmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT *');
    SQL.Add('FROM GOS_SETCOMBCDEL(:PCDLCDEID, :PCDLARTID, :PCDLTGFID,');
    SQL.Add('  :PCDLCOUID, :PCDLQTE, :PCDLPXACHAT, :PCDLTVA,');
    SQL.Add('  :PCDLPXVENTE, :PCDLLIVRAISON, :PCDLCENTRALE,');
    SQL.Add('  :PCDLCOLID, :PCDLPOSTE, :PCDLNUMECHEANCE, :PEtat)');
    Prepared := True;
    ParamCheck := true;
  end;

  Result := True;
  // Intégration des données Commandes
  FCommande.ClientDataset.Filtered := False;
  FCommande.ClientDataset.Filter := 'Error = 0';
  FCommande.ClientDataset.Filtered := True;
  FCommande.First;

  LabCaption('Intégration des en-tête de commandes');
  while not FCommande.EOF do
  begin
    Try
      CDE_ID := SetCOMBCDE(
                 FCommande.FieldByName('CDE_SAISON').AsInteger,     // ACDE_SAISON,
                 FCommande.FieldByName('CDE_EXEID').AsInteger,      // ACDE_EXEID,
                 FCommande.FieldByName('CDE_CPAID').AsInteger,      // ACDE_CPAID,
                 FCommande.FieldByName('CDE_MAGID').AsInteger,      // ACDE_MAGID,
                 FCommande.FieldByName('CDE_FOUID').AsInteger,      // ACDE_FOUID: Integer;
                 FCommande.FieldByName('CDE_NUMFOURN').AsString,    // ACDE_NUMFOURN: String;
                 FCommande.FieldByName('CDE_DATE').AsDateTime,      // ACDE_DATE: TDate;
                 FCommande.FieldByName('CDE_TVAHT1').AsFloat,       // ACDE_TVAHT1,
                 FCommande.FieldByName('CDE_TVATAUX1').AsFloat,     // ACDE_TVATAUX1,
                 FCommande.FieldByName('CDE_TVA1').AsFloat,         // ACDE_TVA1,
                 FCommande.FieldByName('CDE_TVAHT2').AsFloat,       // ACDE_TVAHT2,
                 FCommande.FieldByName('CDE_TVATAUX2').AsFloat,     // ACDE_TVATAUX2,
                 FCommande.FieldByName('CDE_TVA2').AsFloat,         // ACDE_TVA2,
                 FCommande.FieldByName('CDE_TVAHT3').AsFloat,       // ACDE_TVAHT3,
                 FCommande.FieldByName('CDE_TVATAUX3').AsFloat,     // ACDE_TVATAUX3,
                 FCommande.FieldByName('CDE_TVA3').AsFloat,         // ACDE_TVA3,
                 FCommande.FieldByName('CDE_TVAHT4').AsFloat,       // ACDE_TVAHT4,
                 FCommande.FieldByName('CDE_TVATAUX4').AsFloat,     // ACDE_TVATAUX4,
                 FCommande.FieldByName('CDE_TVA4').AsFloat,         // ACDE_TVA4,
                 FCommande.FieldByName('CDE_TVAHT5').AsFloat,       // ACDE_TVAHT5,
                 FCommande.FieldByName('CDE_TVATAUX5').AsFloat,     // ACDE_TVATAUX5,
                 FCommande.FieldByName('CDE_TVA5').AsFloat,         // ACDE_TVA5: Currency;
                 FCommande.FieldByName('CDE_MODIF').AsInteger,      // ACDE_MODIF: Integer;
                 FCommande.FieldByName('CDE_LIVRAISON').AsDateTime, // ACDE_LIVRAISON: TDate;
                 FCommande.FieldByName('CDE_ARCHIVE').AsInteger,    // ACDE_ARCHIVE,
                 FCommande.FieldByName('CDE_TYPID').AsInteger,      // ACDE_TYPID,
                 FCommande.FieldByName('CDE_CENTRALE').AsInteger,   // ACDE_CENTRALE,
                 FCommande.FieldByName('CDE_USRID').AsInteger,      // ACDE_USRID: Integer;
                 FCommande.FieldByName('CDE_COMENT').AsString,      // ACDE_COMENT: string;
                 FCommande.FieldByName('CDE_COLID').AsInteger,      // ACDE_COLID,
                 FCommande.FieldByName('CDE_CLOTURE').AsInteger,    // ACDE_CLOTURE: Integer
                 FCommande.FieldByName('CDE_TYPE').AsString         // ACDE_TYPE: Integer
                 );

        FCommande.Edit;
        FCommande.FieldByName('CDE_ID').AsInteger := CDE_ID;
        FCommande.Post;

        if (CDE_ID > 0) then
        begin
          FCommandeLigne.ClientDataset.Filtered := False;
          FCommandeLigne.ClientDataset.Filter   := 'CDE_NUMFOURN = '''+ FCommande.FieldByName('CDE_NUMFOURN').AsString + '''';
          FCommandeLigne.ClientDataset.Filtered := True;
          FCommandeLigne.First;


          while not FCommandeLigne.EOF do
          begin
            FCommandeLigne.Edit;
            FCommandeLigne.FieldByName('CDL_CDEID').AsInteger := CDE_ID;
            FCommandeLigne.Post;
            FCommandeLigne.Next;
          end;
        end else begin
          raise Exception.Create('Commande du fournisseur '+ FCommande.FieldByName('CDE_NUMFOURN').AsString + ' archivée');
        end;

      IboQuery.IB_Transaction.Commit;

    Except on E:Exception do
      begin
        IboQuery.IB_Transaction.Rollback;
        Erreur := TErreur.Create;
        Erreur.AddError(FFileImport,'Intégration',E.Message,0,teCommande,0,'');
        GERREURS.Add(Erreur);
        IncError ;
        Result := False;
      end;
    end;
    FCommande.Next;
    BarPosition(FCommande.ClientDataset.RecNo * 100 Div FCommande.ClientDataset.RecordCount);
  end;

  // Intégration des lignes de Commandes
  FCommandeLigne.ClientDataset.MasterSource := nil ;
  FCommandeLigne.ClientDataset.Filter := 'CDL_CDEID <> 0' ;
  FCommandeLigne.First;

  LabCaption('Intégration des ' + IntToStr(FCommandeLigne.ClientDataset.RecordCount) + ' lignes de commandes');

  try
    while not FCommandeLigne.EOF do
    begin
      Try
        IboQuery.IB_Transaction.StartTransaction;
        if FCommandeLigne.FieldByName('CDL_CDEID').AsInteger > 0 then
        begin
          SetCOMBCDEL(
                      FCommandeLigne.FieldByName('CDL_CDEID').AsInteger, // ACDL_CDEID,
                      FCommandeLigne.FieldByName('CDL_ARTID').AsInteger, // ACDL_ARTID,
                      FCommandeLigne.FieldByName('CDL_TGFID').AsInteger, // ACDL_TGFID,
                      FCommandeLigne.FieldByName('CDL_COUID').AsInteger, // ACDL_COUID: Integer;
                      FCommandeLigne.FieldByName('CDL_QTE').AsFloat, // ACDL_QTE,
                      FCommandeLigne.FieldByName('CDL_PXACHAT').AsFloat, // ACDL_PXACHAT,
                      FCommandeLigne.FieldByName('CDL_TVA').AsFloat, // ACDL_TVA,
                      FCommandeLigne.FieldByName('CDL_PXVENTE').AsFloat, // ACDL_PXVENTE: Currency;
                      FCommandeLigne.FieldByName('CDL_LIVRAISON').AsDateTime, // ACDL_LIVRAISON: TDate;
                      FCommandeLigne.FieldByName('CDL_CENTRALE').AsInteger, // ACDL_CENTRALE,
                      FCommandeLigne.FieldByName('CDL_COLID').AsInteger, // ACDL_COLID,
                      FCommandeLigne.FieldByName('CDL_POSTE').AsInteger, // ACDL_POSTE,
                      FCommandeLigne.FieldByName('CDL_NUMECHEANCE').AsInteger, // ACDL_NUMECHEANCE,
                      FCommandeLigne.FieldByName('Etat').AsInteger // AEtat: Integer
                     );

          // Liaison du modèle avec la collection
          SetArtColArt(FCommandeLigne.FieldByName('CDL_ARTID').AsInteger, FCommandeLigne.FieldByName('CDL_COLID').AsInteger);
        end ;

        IboQuery.IB_Transaction.Commit;
      Except on E:Exception do
        begin
          IboQuery.IB_Transaction.Rollback;
          Erreur := TErreur.Create;
          Erreur.AddError(FFileImport,'Intégration Lignes',E.Message,0,teCommande,0,'');
           GERREURS.Add(Erreur);
          IncError ;
          Result := False;
        end;
      end;
      FCommandeLigne.Next;
      BarPosition(FCommandeLigne.ClientDataset.RecNo * 100 Div FCommandeLigne.ClientDataset.RecordCount);
    end;
  finally
    Fiboquery.Prepared := False;
  end;
end;

// Récupére le prix de vente en magasin d'un article
procedure TCommandeClass.GetCollection(ACodeCol: String; var ACOLID, AEXEID : Integer);
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COL_ID, COL_EXEID FROM ARTCOLLECTION');
    SQL.Add('  Join K on K_ID = COL_ID and K_Enabled = 1');
    SQL.Add('Where COL_CODE = :PCODE');
    SQL.Add('  and COL_ACTIVE = 1');
    ParamCheck := True;
    ParamByName('PCODE').AsString := ACodeCol;
    Open;

    case RecordCount of
      0: raise Exception.Create(Format('La collection %s n''a pas été trouvée',[ACodeCol]));
      1: begin
        ACOLID := FieldByName('COL_ID').AsInteger;
        AEXEID := FieldByName('COL_EXEID').AsInteger;
      end;
      else begin
        raise Exception.Create(Format('Plusieurs choix disponibles pour la collection %s',[ACodeCol]));
      end;
    end;
  end;
end;

function TCommandeClass.GetCPA_ID(aFouId, aMagId: Integer): Integer;
begin
  IboQuery.SQL.Clear();
  IboQuery.SQL.Add('SELECT  FOD_CPAID');
  IboQuery.SQL.Add('FROM    ARTFOURNDETAIL');
  IboQuery.SQL.Add('  JOIN  K ON (K_ID = FOD_ID AND K_ENABLED = 1)');
  IboQuery.SQL.Add('WHERE   FOD_FOUID = :FOUID');
  IboQuery.SQL.Add('AND     FOD_MAGID = :MAGID');
  IboQuery.ParamByName('FOUID').AsInteger := aFouId;
  IboQuery.ParamByName('MAGID').AsInteger := aMagId;
  IboQuery.ExecSQL();
  Result := IboQuery.FieldByName('FOD_CPAID').AsInteger;
  IboQuery.Close();
end;

function TCommandeClass.GetFDSFromModele(AART_ID: Integer): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('SELECT ART_FDS from ARTARTICLE');
    SQL.Add('  Join K on K_ID = ART_ID and K_Enabled = 1');
    SQL.Add('Where ART_ID = :PARTID');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AART_ID;
    Open;

    if Recordcount > 0 then
      Result := FieldByName('ART_FDS').AsInteger
    else
      raise ENOTFIND.Create('GetFDSFromModele -> Modèle non trouvée');
  except
    on E:ENOTFIND do
      raise ENOTFIND.Create(E.Message);
    on E: Exception do
      raise Exception.Create('GetFDSFromModele -> ' + E.Message);
  end;

end;

function TCommandeClass.GetPvMagasin(aCDS : TClientDataSet ; ARTID, TGFID, COUID: Integer): Double;
var
  iTVTID: Integer;
  Erreur: TErreur;
begin
  IboQuery.SQL.Clear();
  IboQuery.SQL.Add('SELECT MAG_TVTID');
  IboQuery.SQL.Add('FROM   GENMAGASIN');
  IboQuery.SQL.Add('  JOIN K ON (K_ID = MAG_ID AND K_ENABLED = 1)');
  IboQuery.SQL.Add('WHERE  MAG_ID = :MAGID');
  IboQuery.ParamByName('MAGID').AsInteger := MAG_ID;
  IboQuery.Open();

  iTVTID := IboQuery.FieldByName('MAG_TVTID').AsInteger;

  IboQuery.Close();
  IboQuery.SQL.Clear();
  IboQuery.SQL.Add('SELECT R_PRIX');
  IboQuery.SQL.Add('FROM   GETTVTPXVTE(:TVTID, :ARTID, :TGFID, :COUID)');
  IboQuery.ParamByName('TVTID').AsInteger := iTVTID;
  IboQuery.ParamByName('ARTID').AsInteger := ARTID;
  IboQuery.ParamByName('TGFID').AsInteger := TGFID;
  IboQuery.ParamByName('COUID').AsInteger := COUID;
  IboQuery.ExecSQL();

  if IboQuery.FieldByName('R_PRIX').IsNull then
    raise Exception.Create(Format('GetPvMagasin -> Article sans prix de vente : %s',[aCDS.FieldByName('09_CODE_ART_SAP').AsString]));

  Result := IboQuery.FieldByName('R_PRIX').AsFloat;
  IboQuery.Close();
end;

function TCommandeClass.GetTva(aArtId: Integer): Double;
begin
  IboQuery.SQL.Clear();
  IboQuery.SQL.Add('SELECT  TVA_TAUX');
  IboQuery.SQL.Add('FROM    ARTTVA');
  IboQuery.SQL.Add('  JOIN  K ON (K_ID = TVA_ID AND K_ENABLED = 1)');
  IboQuery.SQL.Add('  JOIN  ARTREFERENCE ON (TVA_ID = ARF_TVAID)');
  IboQuery.SQL.Add('WHERE   ARF_ARTID = :ARTID');
  IboQuery.ParamByName('ARTID').AsInteger := aArtId;
  IboQuery.ExecSQL();
  Result := IboQuery.FieldByName('TVA_TAUX').AsFloat;
  IboQuery.Close();
end;

procedure TCommandeClass.Import;
var
  Erreur: TErreur;
  i, iFound: Integer;
  sPrefixe: String;
  iUsrID,
  iTypID,
  iColID,
  iExeID,
  iFouID,
  ART_FDS : Integer;
  Article : TCodeArticle;
  bErreur ,
  bFound  : Boolean;
  iCentrale : Integer ;
  vCDS : TClientDataSet ;

begin
  vCDS := nil ;

  case FMagType of
    mtCourir:  iCentrale := CTE_COURIR ;
    mtGoSport: iCentrale := CTE_GOSPORT ;
  end;

  // Récupération du nom de fichier
  for i := Low(FilesPath) to High(FilesPath) do
  begin
    sPrefixe := Copy(FilesPath[i],1,6);
    case AnsiIndexStr(UpperCase(sPrefixe),['WCDEHA','CDEAFF']) of
      0:  begin
            FFileImport := FilesPath[i];
            vCDS := DM_GSDataImport.cds_WCDEHA ;
            FCount := DM_GSDataImport.cds_WCDEHA.RecordCount;
//CAF
            if (MAG_MODE = mtAffilie) or  (MAG_MODE = mtMandat) then
//            if iCentrale = CTE_GOSPORT then
            begin
              Erreur := TErreur.Create();
//CAF
              Erreur.AddError(FFileImport,
                              'Importation',
                              Format('Recu un fichier WCDEHA alors que la centrale est en mode %s', [IFTHEN(MAG_MODE = mtAffilie,'Affilié','Mandat d''achat')]) ,
                              0,
                              teCommande,
                              0,
                              '');
//              Erreur.AddError(FFileImport,'Importation','Recu un fichier WCDEHA alors que la centrale est GOSPORT',0,teCommande,0,'');
              GERREURS.Add(Erreur);
              IncError ;
              Exit ;
            end;
          end;
      1:  begin
            FFileImport := FilesPath[i];
            vCDS := DM_GSDataImport.cds_CDEAFF ;
            FCount := DM_GSDataImport.cds_CDEAFF.RecordCount;
//CAF
            if MAG_MODE = mtCAF then
//            if iCentrale = CTE_COURIR then
            begin
              Erreur := TErreur.Create();
//CAF
              Erreur.AddError(FFileImport,'Importation','Recu un fichier CDEAFF alors que la centrale est en mode CAF',0,teCommande,0,'');
//              Erreur.AddError(FFileImport,'Importation','Recu un fichier CDEAFF alors que la centrale est COURIR',0,teCommande,0,'');
              GERREURS.Add(Erreur);
              IncError ;
              Exit ;
            end;
          end;
    end;
  end;

  // Créaton des tables et champs
  CreateCdsField;

  LabCaption(Format('Importation du fichier %s', [FFileImport]));

  //Récupère l'utilisateur par défaut.
  GetGenParam(16,6,MAG_ID, iUsrID);

  if not Assigned(vCDS) then
  begin
    Erreur := TErreur.Create();
    Erreur.AddError(FFileImport,'Importation','Erreur interne : CDS non trouvé',0,teCommande,0,'');
    GERREURS.Add(Erreur);
    IncError ;
    Exit ;
  end;

  // Import des données dans le ClientDataSet
  InitCodeArticle;
  With vCDS do
  begin
    try
      Collections.Filter := 'COL_ACTIVE = 1';
      Collections.Filtered := True;
      First;
      while not EOF do
      begin
        try
          bErreur := False; //En cas d'erreur on le passera à true

          if not (FieldByName('05_CODE_DIVISION').AsString = MAG_CODEADH) then
          begin
            raise Exception.Create(Format('Le bon de commande %s  n''est pas pour ce magasin (Division %s - Code magasin %s)',
                                          [FieldByName('01_CDE_SAP').AsString,FieldByName('05_CODE_DIVISION').AsString,MAG_CODEADH]));
          end;

          {$REGION 'Récupération de la collection et de l''exercice commercial'}
          if Trim(FieldByName('14_COLLECTION').AsString) = '' then
          begin
            if not Collections.Active then
              Collections.Open;
            bFound := False;
            Collections.First;
            while not Collections.EOF and not bFound do
            begin
              if (CompareDate(ConvertDate(FieldByName('03_DATE_CREATION_CDE').AsString),Collections.FieldByName('COL_DTDEB').AsDateTime) <> LessThanValue) and
                 (CompareDate(ConvertDate(FieldByName('03_DATE_CREATION_CDE').AsString),Collections.FieldByName('COL_DTFIN').AsDateTime) <> GreaterThanValue)  then
              begin
                iColID := Collections.FieldByName('COL_ID').AsInteger;
                iExeID := Collections.FieldByName('COL_EXEID').AsInteger;
                bFound := True;
              end;

              Collections.Next;
            end;

            if not bFound then
            begin
              Erreur := TErreur.Create();
              Erreur.AddError(FFileImport, 'Collection','Pas de collections correspondante', RecNo, teCommande, 0, '');
              GERREURS.Add(Erreur);
              IncError ;
              bErreur := True;
            end;
          end
          else begin
            Try
              GetCollection(FieldByName('14_COLLECTION').AsString, iColID, iExeID);
            Except on E:Exception do
              begin
                Erreur := TErreur.Create();
                Erreur.AddError(FFileImport, 'Collection',E.Message, RecNo, teCommande, 0, '');
                GERREURS.Add(Erreur);
                IncError ;
                bErreur := True;
              end;
            End;
          end;
          {$ENDREGION}

          {$REGION 'Traitement du fournisseur'}
          Try
            if Assigned(FournisseursQuery) and FournisseursQuery.locate('FOU_CODE',FieldByName('04_CODE_FOURN_SAP').AsString,[loCaseInsensitive]) then
              iFouID := FournisseursQuery.FieldByName('FOU_ID').AsInteger
            else
              iFouID := FFournisseur.GetIdByCode(FieldByName('04_CODE_FOURN_SAP').AsString, iCentrale);
          Except on E:Exception do
            begin
              // Mise en erreur du code fournisseur
              iFouID := 0;
              Erreur := TErreur.Create();
              Erreur.AddError(FFileImport, 'Fournisseur', E.Message, RecNo, teCommande, 0, '');
              GERREURS.Add(Erreur);
              IncError ;
              bErreur := True;
            end;
          end;
          {$ENDREGION}

          {$REGION 'Traitement du code article'}
          Try
            if FArtRelationArt.ClientDataset.Active and FArtRelationArt.ClientDataset.Locate('CODE_ARTICLE', FieldByName('09_CODE_ART_SAP').AsString, [loCaseInsensitive]) then
            begin
              Article.ART_ID := FArtRelationArt.FieldByName('ARA_ARTID').AsInteger;
              Article.TGF_ID := FArtRelationArt.FieldByName('ARA_TGFID').AsInteger;
              Article.COU_ID := FArtRelationArt.FieldByName('ARA_COUID').AsInteger;

              if (Article.ART_ID = 0) or (Article.TGF_ID = 0) or (Article.COU_ID = 0) then
                Article := GetCodeArticle(FieldByName('09_CODE_ART_SAP').AsString, True);
            end
            else
              Article := GetCodeArticle(FieldByName('09_CODE_ART_SAP').AsString, True);

            if FArtRelationArt.ClientDataset.Active and FArticleFichier.ClientDataset.Locate('ART_ID',Article.ART_ID,[]) then
              ART_FDS := FArticleFichier.FieldByName('ART_FDS').AsInteger
            else begin
              ART_FDS := GetFDSFromModele(Article.ART_ID);
            end;
          Except on E:eXception do
            begin
              // Mise en erreur du code article
              Erreur := TErreur.Create();
              Erreur.AddError(FFileImport, 'Code article', E.Message, RecNo, teCommande, 0, '');
              GERREURS.Add(Erreur);
              IncError ;
              bErreur := True;
            end;
          end;
          {$ENDREGION}

          {$REGION 'Le type de commande.'}
          case AnsiIndexStr(Trim(FieldByName('02_TYPE_CDE_SAP').AsString),['ZCDI','ZCAI','ZCDR','ZCAR']) of
            0,1 : // ZCDI, ZCAI
              iTypID := GetIDFromTable('GENTYPCDV',['TYP_COD','TYP_CATEG'],[101,1],'TYP_ID'); // Pré-saison
//            2,3 : // ZCDR, ZCAR
//              iTypID := GetIDFromTable('GENTYPCDV',['TYP_COD','TYP_CATEG'],[102,1],'TYP_ID'); // réassort
            else begin
              iTypID := GetIDFromTable('GENTYPCDV',['TYP_COD','TYP_CATEG'],[102,1],'TYP_ID'); // réassort

//              Erreur := TErreur.Create();
//              Erreur.AddError(FFileImport, 'Type de commande', 'Le type de commande n''est pas reconnu : ' + FieldByName('02_TYPE_CDE_SAP').AsString, RecNo, teCommande, 0, '');
//              GERREURS.Add(Erreur);
//              IncError ;
//              bErreur := True;
            end;
          end;
          {$ENDREGION}

          if not bErreur then
          begin
            if not FCommande.ClientDataset.Locate('CDE_NUMFOURN',FieldByName('01_CDE_SAP').AsString, []) then
            begin
              FCommande.Append;
              FCommande.FieldByName('CDE_ID').AsInteger         := -1;
              FCommande.FieldByName('CDE_NUMERO').AsString      := '';
              FCommande.FieldByName('CDE_MAGID').AsInteger      := MAG_ID;
              FCommande.FieldByName('CDE_SAISON').AsInteger     := 0;
              FCommande.FieldByName('CDE_EXEID').AsInteger      := iExeID;
              FCommande.FieldByName('CDE_CPAID').AsInteger      := GetCPA_ID(iFouID,MAG_ID);
              FCommande.FieldByName('CDE_FOUID').AsInteger      := iFouID;
              FCommande.FieldByName('CDE_NUMFOURN').AsString    := FieldByName('01_CDE_SAP').AsString;
              FCommande.FieldByName('CDE_DATE').AsDateTime      := ConvertDate(FieldByName('03_DATE_CREATION_CDE').AsString);
              FCommande.FieldByName('CDE_TVAHT1').AsFloat       := 0;
              FCommande.FieldByName('CDE_TVATAUX1').AsFloat     := 0;
              FCommande.FieldByName('CDE_TVA1').AsFloat         := 0;
              FCommande.FieldByName('CDE_TVAHT2').AsFloat       := 0;
              FCommande.FieldByName('CDE_TVATAUX2').AsFloat     := 0;
              FCommande.FieldByName('CDE_TVA2').AsFloat         := 0;
              FCommande.FieldByName('CDE_TVAHT3').AsFloat       := 0;
              FCommande.FieldByName('CDE_TVATAUX3').AsFloat     := 0;
              FCommande.FieldByName('CDE_TVA3').AsFloat         := 0;
              FCommande.FieldByName('CDE_TVAHT4').AsFloat       := 0;
              FCommande.FieldByName('CDE_TVATAUX4').AsFloat     := 0;
              FCommande.FieldByName('CDE_TVA4').AsFloat         := 0;
              FCommande.FieldByName('CDE_TVAHT5').AsFloat       := 0;
              FCommande.FieldByName('CDE_TVATAUX5').AsFloat     := 0;
              FCommande.FieldByName('CDE_TVA5').AsFloat         := 0;
              FCommande.FieldByName('CDE_MODIF').AsInteger      := 0;
              FCommande.FieldByName('CDE_LIVRAISON').AsDateTime := ConvertDate(FieldByName('03_DATE_CREATION_CDE').AsString);
              FCommande.FieldByName('CDE_ARCHIVE').AsInteger    := 0;
              FCommande.FieldByName('CDE_TYPID').AsInteger      := iTypID;
              FCommande.FieldByName('CDE_CENTRALE').AsInteger   := iCentrale ;
              FCommande.FieldByName('CDE_USRID').AsInteger      := iUsrID;
              FCommande.FieldByName('CDE_COMENT').AsString      := '';
              FCommande.FieldByName('CDE_COLID').AsInteger      := iColID;
              FCommande.FieldByName('CDE_CLOTURE').AsInteger    := 1;
              FCommande.FieldByName('CDE_TYPE').AsString        := FieldByName('02_TYPE_CDE_SAP').AsString;
              FCommande.FieldByName('Error').AsInteger          := 0;
              FCommande.Post;
            end;

            if (ART_FDS = 0) or (FieldByName('11_POSTE_ANNULE').AsString = 'O') then
            begin
              FCommandeLigne.Append;
              FCommandeLigne.FieldByName('CDE_NUMFOURN').AsString     := FieldByName('01_CDE_SAP').AsString;
              FCommandeLigne.FieldByName('CDL_ID').AsInteger          := -1;
              FCommandeLigne.FieldByName('CDL_CDEID').AsInteger       := -1;
              FCommandeLigne.FieldByName('CDL_ARTID').AsInteger       := Article.ART_ID;
              FCommandeLigne.FieldByName('CDL_TGFID').AsInteger       := Article.TGF_ID;
              FCommandeLigne.FieldByName('CDL_COUID').AsInteger       := Article.COU_ID;
              FCommandeLigne.FieldByName('CDL_QTE').AsFloat           := FieldByName('10_QTE_COMMANDE').AsFloat;
              FCommandeLigne.FieldByName('CDL_CENTRALE').AsInteger    := iCentrale ;
              FCommandeLigne.FieldByName('CDL_LIVRAISON').AsDateTime  := ConvertDate(FieldByName('08_DATE_LIV_POSTE').AsString);

              if (FmagType = mtGosport) or (FmagType = mtCourir) then
              begin
                case FMagMode of
                  mtAffilie, mtMandat : begin
                    FCommandeLigne.FieldByName('CDL_PXACHAT').AsCurrency    := FieldByName('12_PRIX_ACHAT_NET').AsInteger / 100 ;
                  end;
                  mtCAF : begin
                    FCommandeLigne.FieldByName('CDL_PXACHAT').AsFloat       := 0 ;
                  end;
                  else begin
                    raise exception.Create('Le type de magasin est inconnu');
                  end;
                end;
              end;

              FCommandeLigne.FieldByName('CDL_TVA').AsFloat           := GetTva(Article.ART_ID);
              FCommandeLigne.FieldByName('CDL_PXVENTE').AsFloat       := GetPvMagasin(vCDS, Article.ART_ID, Article.TGF_ID, Article.COU_ID);
              FCommandeLigne.FieldByName('CDL_COLID').AsInteger       := iColID;
              FCommandeLigne.FieldByName('CDL_POSTE').AsInteger       := StrToInt(FieldByName('07_NUM_POSTE_CDE').AsString);
              FCommandeLigne.FieldByName('CDL_NUMECHEANCE').AsInteger := StrToIntDef(FieldByName('13_NUM_ECHEANCE').AsString,0);

              if FieldByName('11_POSTE_ANNULE').AsString = 'O' then
                FCommandeLigne.FieldByName('Etat').AsInteger := 1    //On supprimera la ligne
              else
                FCommandeLigne.FieldByName('Etat').AsInteger := 0;    //On concervera la ligne
              FCommandeLigne.Post;

              if FCommandeLigne.FieldByName('Etat').AsInteger = 0 then
              begin
                iFound := -1;

                for i := 1 to 5 do
                  if CompareValue(FCommande.FieldByName('CDE_TVATAUX' + IntToStr(i)).AsCurrency,
                                  FCommandeLigne.FieldByName('CDL_TVA').AsCurrency,0.001) = EqualsValue then
                    iFound := i;

                if iFound = -1 then
                begin
                  for i := 1 to 5 do
                    if (iFound = -1) and (CompareValue(FCommande.FieldByName('CDE_TVATAUX' + IntToStr(i)).AsCurrency,0,0.001) = EqualsValue) then
                      iFound := i;

                  if iFound <> -1 then
                  begin
                    FCommande.Edit;
                    FCommande.FieldByName('CDE_TVAHT'+ IntToStr(iFound)).AsFloat   := FCommandeLigne.FieldByName('CDL_PXACHAT').AsCurrency * FieldByName('10_QTE_COMMANDE').AsFloat;
                    FCommande.FieldByName('CDE_TVATAUX'+ IntToStr(iFound)).AsFloat := FCommandeLigne.FieldByName('CDL_TVA').AsCurrency;
                    FCommande.FieldByName('CDE_TVA'+ IntToStr(iFound)).AsFloat     := FCommandeLigne.FieldByName('CDL_PXACHAT').AsCurrency * FieldByName('10_QTE_COMMANDE').AsFloat * FCommandeLigne.FieldByName('CDL_TVA').AsCurrency / 100;
                    FCommande.Post;
                  end
                  else begin
                    raise Exception.Create('Trop de TVA différente');
                  end;

                end
                else begin
                  FCommande.Edit;
                  FCommande.FieldByName('CDE_TVAHT'+ IntToStr(iFound)).AsFloat   := FCommande.FieldByName('CDE_TVAHT'+ IntToStr(iFound)).AsFloat +
                                                                                    FCommandeLigne.FieldByName('CDL_PXACHAT').AsCurrency *
                                                                                    FieldByName('10_QTE_COMMANDE').AsFloat;
                  FCommande.FieldByName('CDE_TVATAUX'+ IntToStr(iFound)).AsFloat := FCommandeLigne.FieldByName('CDL_TVA').AsCurrency;
                  FCommande.FieldByName('CDE_TVA'+ IntToStr(iFound)).AsFloat     := FCommande.FieldByName('CDE_TVA'+ IntToStr(iFound)).AsFloat +
                                                                                    FCommandeLigne.FieldByName('CDL_PXACHAT').AsCurrency *
                                                                                    FieldByName('10_QTE_COMMANDE').AsFloat *
                                                                                    FCommandeLigne.FieldByName('CDL_TVA').AsCurrency / 100;
                  FCommande.Post;
                end;
              end;
            end;
          end;
        Except on E:Exception do
          begin
            if FCommande.ClientDataset.State in [dsInsert] then
              FCommande.ClientDataset.Cancel
            else begin
              if FCommande.ClientDataset.Locate('CDE_NUMFOURN',FieldByName('01_CDE_SAP').AsString,[loCaseInsensitive]) then
              begin
                FCommande.Edit;
                FCommande.FieldByName('Error').AsInteger := 1;
                FCommande.Post;
              end;
            end;

            if FCommandeLigne.ClientDataset.State in [dsInsert] then
              FCommandeLigne.ClientDataset.Cancel;

            Erreur := TErreur.Create();
            Erreur.AddError(FFileImport,'Importation',E.Message,RecNo,teCommande,0,'');
            GERREURS.Add(Erreur);
            IncError ;
          end;
        end;
        Next;
        BarPosition(RecNo * 100 Div Recordcount);
      end;
    finally
      Collections.Filtered := False;
    end;
  end; // With
End;

function TCommandeClass.SetArtColArt(ART_ID, COL_ID: integer): integer;
begin
//  IBOStoredProc.Close;
//  IBOStoredProc.StoredProcName := 'GOS_SETARTCOLART';
//  IBOStoredProc.ParamCheck := True;
//  IBOStoredProc.ParamByName('ART_ID').AsInteger := ART_ID;
//  IBOStoredProc.ParamByName('COL_ID').AsInteger := COL_ID;
//  IBOStoredProc.Open;
//  Result := IBOStoredProc.FieldByName('CAR_ID').AsInteger;

  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select CAR_ID from GOS_SETARTCOLART(:PARTID, :PCOLID)');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := ART_ID;
    ParamByName('PCOLID').AsInteger := COL_ID;
    Open;

    Result := FieldByName('CAR_ID').AsInteger;
  except on E:Exception do
    raise Exception.Create('SetArtColArt -> ' + E.Message);
  end;
end;

function TCommandeClass.SetCOMBCDE(ACDE_SAISON, ACDE_EXEID, ACDE_CPAID,
  ACDE_MAGID, ACDE_FOUID: Integer; ACDE_NUMFOURN: String; ACDE_DATE: TDate;
  ACDE_TVAHT1, ACDE_TVATAUX1, ACDE_TVA1, ACDE_TVAHT2, ACDE_TVATAUX2, ACDE_TVA2,
  ACDE_TVAHT3, ACDE_TVATAUX3, ACDE_TVA3, ACDE_TVAHT4, ACDE_TVATAUX4, ACDE_TVA4,
  ACDE_TVAHT5, ACDE_TVATAUX5, ACDE_TVA5: Currency; ACDE_MODIF: Integer;
  ACDE_LIVRAISON: TDate; ACDE_ARCHIVE, ACDE_TYPID, ACDE_CENTRALE,
  ACDE_USRID: Integer; ACDE_COMENT: string; ACDE_COLID,
  ACDE_CLOTURE: Integer; ACDE_TYPE : String): Integer;
begin
  Result := -1;
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('SELECT  *');
    SQL.Add('FROM    GOS_SETCOMBCDE(:PCDESAISON, :PCDEEXEID, :PCDECPAID,');
    SQL.Add('  :PCDEMAGID, :PCDEFOUID, :PCDENUMFOURN, :PCDEDATE,');
    SQL.Add('  :PCDETVAHT1, :PCDETVATAUX1, :PCDETVA1,');
    SQL.Add('  :PCDETVAHT2, :PCDETVATAUX2, :PCDETVA2,');
    SQL.Add('  :PCDETVAHT3, :PCDETVATAUX3, :PCDETVA3,');
    SQL.Add('  :PCDETVAHT4, :PCDETVATAUX4, :PCDETVA4,');
    SQL.Add('  :PCDETVAHT5, :PCDETVATAUX5, :PCDETVA5,');
    SQL.Add('  :PCDEMODIF, :PCDELIVRAISON, :PCDEARCHIVE, :PCDETYPID,');
    SQL.Add('  :PCDECENTRALE, :PCDEUSRID, :PCDECOMENT, :PCDECOLID,');
    SQL.Add('  :PCDECLOTURE, :PCDETYPE)');
    ParamCheck := True;
    ParamByName('PCDESAISON').AsInteger      := ACDE_SAISON;
    ParamByName('PCDEEXEID').AsInteger       := ACDE_EXEID;
    ParamByName('PCDECPAID').AsInteger       := ACDE_CPAID;
    ParamByName('PCDEMAGID').AsInteger       := ACDE_MAGID;
    ParamByName('PCDEFOUID').AsInteger       := ACDE_FOUID;
    ParamByName('PCDENUMFOURN').AsString     := ACDE_NUMFOURN;
    ParamByName('PCDEDATE').AsDateTime       := ACDE_DATE;
    ParamByName('PCDETVAHT1').AsFloat        := ACDE_TVAHT1;
    ParamByName('PCDETVATAUX1').AsFloat      := ACDE_TVATAUX1;
    ParamByName('PCDETVA1').AsFloat          := ACDE_TVA1;
    ParamByName('PCDETVAHT2').AsFloat        := ACDE_TVAHT2;
    ParamByName('PCDETVATAUX2').AsFloat      := ACDE_TVATAUX2;
    ParamByName('PCDETVA2').AsFloat          := ACDE_TVA2;
    ParamByName('PCDETVAHT3').AsFloat        := ACDE_TVAHT3;
    ParamByName('PCDETVATAUX3').AsFloat      := ACDE_TVATAUX3;
    ParamByName('PCDETVA3').AsFloat          := ACDE_TVA3;
    ParamByName('PCDETVAHT4').AsFloat        := ACDE_TVAHT4;
    ParamByName('PCDETVATAUX4').AsFloat      := ACDE_TVATAUX4;
    ParamByName('PCDETVA4').AsFloat          := ACDE_TVA4;
    ParamByName('PCDETVAHT5').AsFloat        := ACDE_TVAHT5;
    ParamByName('PCDETVATAUX5').AsFloat      := ACDE_TVATAUX5;
    ParamByName('PCDETVA5').AsFloat          := ACDE_TVA5;
    ParamByName('PCDEMODIF').AsInteger       := ACDE_MODIF;
    ParamByName('PCDELIVRAISON').AsDateTime  := ACDE_LIVRAISON;
    ParamByName('PCDEARCHIVE').AsInteger     := ACDE_ARCHIVE;
    ParamByName('PCDETYPID').AsInteger       := ACDE_TYPID;
    ParamByName('PCDECENTRALE').AsInteger    := ACDE_CENTRALE;
    ParamByName('PCDEUSRID').AsInteger       := ACDE_USRID;
    ParamByName('PCDECOMENT').AsString       := ACDE_COMENT;
    ParamByName('PCDECOLID').AsInteger       := ACDE_COLID;
    ParamByName('PCDECLOTURE').AsInteger     := ACDE_CLOTURE;
    ParamByName('PCDETYPE').AsString         := ACDE_TYPE;
    Open;

    if IboQuery.RecordCount > 0 then
    begin
      Inc(FInsertCount,IboQuery.FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,IboQuery.FieldByName('FMAJ').AsInteger);
      Result := FieldByName('CDE_ID').AsInteger;
    end;
  Except on E:Exception do
    raise Exception.Create('SetCOMBCDE -> ' + E.Message);
  end;
end;

function TCommandeClass.SetCOMBCDEL(ACDL_CDEID, ACDL_ARTID, ACDL_TGFID,
  ACDL_COUID: Integer; ACDL_QTE, ACDL_PXACHAT, ACDL_TVA, ACDL_PXVENTE: Currency;
  ACDL_LIVRAISON: TDate; ACDL_CENTRALE, ACDL_COLID, ACDL_POSTE, ACDL_NUMECHEANCE, AEtat: Integer): Integer;
begin
  With FIboQueryTmp do
  try
    Close;
//    SQL.Clear;
//    SQL.Add('SELECT *');
//    SQL.Add('FROM GOS_SETCOMBCDEL(:PCDLCDEID, :PCDLARTID, :PCDLTGFID,');
//    SQL.Add('  :PCDLCOUID, :PCDLQTE, :PCDLPXACHAT, :PCDLTVA,');
//    SQL.Add('  :PCDLPXVENTE, :PCDLLIVRAISON, :PCDLCENTRALE,');
//    SQL.Add('  :PCDLCOLID, :PEtat)');
//    ParamCheck := true;
    ParamByName('PCDLCDEID').AsInteger      := ACDL_CDEID;
    ParamByName('PCDLARTID').AsInteger      := ACDL_ARTID;
    ParamByName('PCDLTGFID').AsInteger      := ACDL_TGFID;
    ParamByName('PCDLCOUID').AsInteger      := ACDL_COUID;
    ParamByName('PCDLQTE').AsFloat          := ACDL_QTE;
    ParamByName('PCDLPXACHAT').AsFloat      := ACDL_PXACHAT;
    ParamByName('PCDLTVA').AsFloat          := ACDL_TVA;
    ParamByName('PCDLPXVENTE').AsFloat      := ACDL_PXVENTE;
    ParamByName('PCDLLIVRAISON').AsDateTime := ACDL_LIVRAISON;
    ParamByName('PCDLCENTRALE').AsInteger   := ACDL_CENTRALE;
    ParamByName('PCDLCOLID').AsInteger      := ACDL_COLID;
    ParamByName('PCDLPOSTE').AsInteger      := ACDL_POSTE;
    ParamByName('PCDLNUMECHEANCE').AsInteger:= ACDL_NUMECHEANCE;
    ParamByName('PEtat').AsInteger          := AEtat;
    Open;

    if RecordCount > 0 then
    begin
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('CDL_ID').AsInteger;
    end;
  except on E: Exception do
    raise Exception.Create('SetCOMBCDEL -> ' + E.Message);
  end;
end;

end.
