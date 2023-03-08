unit GSData_ReceptionClass;

interface

uses
  GSData_MainClass,
  GSData_TErreur,
  GSData_Types,
  GSDataImport_DM,
  StrUtils,
  DBClient,
  SysUtils,
  IBODataset,
  Db,
  Variants,
  Classes;

type
  TRecAuto = record
    BLA_ID      : Integer;
    BLA_NUMERO  : String;
    bCreer      : Boolean;
  end;

  TRecAutoP = record
    BLP_ID      : Integer;
    BLP_NUMERO  : String;
    bCreer      : Boolean;
  end;

  TRecAutoL = record
    LPA_ID      : Integer;
    LPA_PREPACK  : String;
    bCreer      : Boolean;
  end;

  TReceptionClass = class (TMainClass)
  private
    FFileImport           : String;

    FRecAuto              : TMainClass;
    FRecAutoP             : TMainClass;
    FRecAutoL             : TMainClass;
    FArtFourn             : TMainClass;      
    FArtRelationArt       : TMainClass;
    FBArtRelationArt      : Boolean;
    
    DS_FRecAuto           : TDataSource;
    DS_FRecAutoP          : TDataSource;

    Fcds_ReceptionImport  : TClientDataSet;

    // Supprime un bon de livraison des DataSets
    procedure SupprimeBL(ANumeroBL: String);
  private type
    TRecAutoLRec = record
      LPA_QTE, LPA_CDLID: Integer;
    end;
    TRecAutoLRecArray = array of TRecAutoLRec;
  private
    Fcds_Ral: TClientDataSet;
    function CreateCdsRal: TClientDataSet;
    procedure GetGlobalRAL;
    procedure GetSpecificRAL(const CodeCommandeSAP, CodeArticleSAP: String);
    procedure AddCombination(var RecAutoLRecArray: TRecAutoLRecArray;
      const LPA_QTE, LPA_CDLID: Integer);
    function IsCodeCommandeSAPValid(const CodeCommandeSAP: String): Boolean;
    function GetCombinationRAL(const CodeCommandeSAP,
      CodeArticleSAP: String; const Quantity: Integer): TRecAutoLRecArray;
  public
    procedure Import(); override;
    function DoMajTable(): Boolean; override;

    constructor Create(); override;
    destructor Destroy(); override;

    // Création des champs dans les ClientDataSets
    procedure CreateCdsField();

    // Création du bon de livraison
    function SetRecAuto(ABLA_NUMERO: String; ABLA_DATE: TDate; ABLA_FOUID: Integer;
      ABLA_TRANS: String; ABLA_MAGID: Integer; ABLA_COMENT: String;
      ABLA_ETAT, ABLA_NBPAL, ABLA_NBPAQ, ABLA_NBART: Integer): TRecAuto;

    // Création du carton dans le bon de livraison
    function SetRecAutoP(ABLA_NUMERO: String; ABLP_BLAID: Integer;
      ABLP_NUMERO, ABLP_PALETTE: String; ABLP_QTE: Integer; ABLP_UNIVERS: String;
      ABLP_SCAN, ABLP_ETAT, ABLP_BREID: Integer): TRecAutoP;

    // Création des articles dans les cartons livrés
    function SetRecAutoL(ABLA_NUMERO, ABLP_NUMERO: String;
      ALPA_BLPID, ALPA_ARTID, ALPA_TGFID, ALPA_COUID, ALPA_CDLID, ALPA_QTE, ALPA_PREETIK: Integer;
      ALPA_COMENT: String; ALPA_PA, ALPA_PV: Double; ALPA_INCONU: Integer;
      ALPA_EAN, ALPA_PREPACK: String): TRecAutoL;

    // Récupére le prix de vente en magasin d'un article
    function GetPvMagasin(ARTID, TGFID, COUID: Integer): Double;

    // Récupére le prix d'achat en magasin d'un article
    function GetPaMagasin(const MAGID, ARTID, TGFID, COUID, CDLID: Integer): Double;
  published
    // Accès aux ClientDataSets
    property RecAuto              : TMainClass      read FRecAuto;
    property RecAutoP             : TMainClass      read FRecAutoP;
    property RecAutoL             : TMainClass      read FRecAutoL;
    property ArtFourn             : TMainClass      read FArtFourn;            
    property ArtRelationArt       : TMainClass      read FArtRelationArt      write FArtRelationArt;
    property BArtRelationArt      : Boolean         read FBArtRelationArt     write FBArtRelationArt;
    
    // ClientDataSet utilisé pour l'import
    property cds_ReceptionImport  : TClientDataSet  read Fcds_ReceptionImport write Fcds_ReceptionImport;
  end;

implementation

uses GSDataExport_DM, GSDataMain_DM;

{ TReceptionClass }

procedure TReceptionClass.GetGlobalRAL;
var
  lpa_qte, brl_qte: Integer;
begin
  try
    FIboQuery.Close;
    try
      {$REGION 'Récupération de la liste des commandes ayant du RAL'}
      FIboQuery.SQL.Text := 'select combcde.cde_numfourn, artrelationart.ara_codeart, combcdel.cdl_id, ' +
                            '  agrral.ral_qte, sum( recautol.lpa_qte ) lpa_qte, sum( recbrl.brl_qte ) brl_qte ' +
                            'from combcde ' +
                            'join k kcde on kcde.k_id = combcde.cde_id and kcde.k_enabled = 1 ' +
                            'join combcdel on combcdel.cdl_cdeid = combcde.cde_id ' +
                            'join k kcdl on kcdl.k_id = combcdel.cdl_id and kcdl.k_enabled = 1 ' +
                            'join artrelationart on artrelationart.ara_artid = combcdel.cdl_artid ' +
                            '                   and artrelationart.ara_tgfid = combcdel.cdl_tgfid ' +
                            '                   and artrelationart.ara_couid = combcdel.cdl_couid ' +
                            'join agrral on agrral.ral_cdlid = combcdel.cdl_id ' +
                            'left join recautol on recautol.lpa_cdlid = combcdel.cdl_id ' +
                            '                  and recautol.lpa_artid = combcdel.cdl_artid ' +
                            '                  and recautol.lpa_tgfid = combcdel.cdl_tgfid ' +
                            '                  and recautol.lpa_couid = combcdel.cdl_couid ' +
                            'left join k klpa on klpa.k_id = recautol.lpa_id and klpa.k_enabled = 1 ' +
                            'left join recbrl on recbrl.brl_cdlid = combcdel.cdl_id ' +
                            '                and recbrl.brl_artid = combcdel.cdl_artid ' +
                            '                and recbrl.brl_tgfid = combcdel.cdl_tgfid ' +
                            '                and recbrl.brl_couid = combcdel.cdl_couid ' +
                            'left join k kbrl on kbrl.k_id = recbrl.brl_id and kbrl.k_enabled = 1 ' +
                            'where combcde.cde_id != 0 ' +
                            'group by combcde.cde_numfourn, artrelationart.ara_codeart, combcdel.cdl_id, agrral.ral_qte ' +
                            'having ( agrral.ral_qte != sum( recautol.lpa_qte ) ) ' +
                            '    or ( sum( recautol.lpa_qte ) is null ) ' +
                            'order by combcde.cde_numfourn asc, combcdel.cdl_livraison asc, combcdel.cdl_id asc ';
      FIboQuery.FetchAll;
      FIboQuery.First;
      {$ENDREGION}

      // Nettoyage de la liste des RAL
      Fcds_Ral.EmptyDataSet;
      while not FIboQuery.Eof do
      begin
        try
          Fcds_Ral.Append;
          Fcds_Ral.FieldByName( 'ID' ).AsInteger := FIboQuery.RecNo;
          Fcds_Ral.FieldByName( 'CODE_COMMANDE_SAP' ).AsVariant := FIboQuery.FieldByName( 'CDE_NUMFOURN' ).AsVariant;
          Fcds_Ral.FieldByName( 'CODE_ARTICLE_SAP' ).AsVariant := FIboQuery.FieldByName( 'ARA_CODEART' ).AsVariant;
          Fcds_Ral.FieldByName( 'CDL_ID' ).AsVariant := FIboQuery.FieldByName( 'CDL_ID' ).AsVariant;

          if FIboQuery.FieldByName( 'LPA_QTE' ).IsNull then
            lpa_qte := 0
          else
            lpa_qte := FIboQuery.FieldByName( 'LPA_QTE' ).AsInteger;

          if FIboQuery.FieldByName( 'BRL_QTE' ).IsNull then
            brl_qte := 0
          else
            brl_qte := FIboQuery.FieldByName( 'BRL_QTE' ).AsInteger;

          Fcds_Ral.FieldByName( 'RAL' ).AsInteger := FIboQuery.FieldByName( 'RAL_QTE' ).AsInteger - ( lpa_qte - brl_qte );
          Fcds_Ral.Post;
        except
          Fcds_Ral.Cancel;
          raise;
        end;
        FIboQuery.Next;
      end;
    finally
      FIboQuery.Close;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt( 'GetGlobalRAL -> %s', [ E.Message ] );
  end;
end;

procedure TReceptionClass.AddCombination(
  var RecAutoLRecArray: TRecAutoLRecArray; const LPA_QTE, LPA_CDLID: Integer);
var
  I: Integer;
begin
  // Récupération de la taille du tableau
  I := Length( RecAutoLRecArray );
  // Ajout d'un élément
  SetLength( RecAutoLRecArray, Succ( I ) );
  // Définition de l'élément
  RecAutoLRecArray[ I ].LPA_QTE := LPA_QTE;
  RecAutoLRecArray[ I ].LPA_CDLID := LPA_CDLID;
end;

constructor TReceptionClass.Create();
begin
  inherited Create();

  // Création des ClientDataSets pour les tables
  FRecAuto              := TMainClass.Create();
  FRecAutoP             := TMainClass.Create();
  FRecAutoL             := TMainClass.Create();
  FArtFourn             := TMainClass.Create();
  DS_FRecAuto           := TDataSource.Create(Nil);
  DS_FRecAuto.DataSet   := FRecAuto.ClientDataset;
  DS_FRecAutoP          := TDataSource.Create(Nil);
  DS_FRecAutoP.DataSet  := FRecAutoP.ClientDataset;

  Fcds_Ral              := CreateCdsRal;
end;

destructor TReceptionClass.Destroy();
begin
  // Destruction des ClientDataSets
  FRecAuto.Free();
  FRecAutoP.Free();
  FRecAutoL.Free();
  FArtFourn.Free();
  DS_FRecAuto.Free();
  DS_FRecAutoP.Free();

  Fcds_ral.Free;

  inherited;
end;

procedure TReceptionClass.CreateCdsField();
begin
  // Table RECAUTO
  FRecAuto.CreateField(['BLA_ID', 'BLA_NUMERO', 'BLA_DATE', 'BLA_FOUID',
    'BLA_TRANS', 'BLA_MAGID', 'BLA_COMENT', 'BLA_ETAT', 'BLA_NBPAL', 'BLA_NBPAQ',
    'BLA_NBART', 'Error', 'Created'],
    [ftInteger, ftString, ftDate, ftInteger, ftString, ftInteger, ftString,
    ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftBoolean]);
  FRecAuto.ClientDataset.AddIndex('IDX', 'BLA_NUMERO', []);
  FRecAuto.ClientDataset.IndexName        := 'IDX';

  // Table RECAUTOP
  FRecAutoP.CreateField(['BLA_NUMERO', 'BLP_ID', 'BLP_BLAID', 'BLP_NUMERO',
    'BLP_PALETTE', 'BLP_QTE', 'BLP_UNIVERS', 'BLP_SCAN', 'BLP_ETAT', 'BLP_BREID',
    'Error', 'Created'],
    [ftString, ftInteger, ftInteger, ftString, ftString, ftInteger, ftString,
    ftInteger, ftInteger, ftInteger, ftInteger, ftBoolean]);
  FRecAutoP.ClientDataset.AddIndex('IDX', 'BLA_NUMERO;BLP_NUMERO', []);
  FRecAutoP.ClientDataset.IndexName       := 'IDX';
  FRecAutoP.ClientDataset.MasterSource    := DS_FRecAuto;
  FRecAutoP.ClientDataset.MasterFields    := 'BLA_NUMERO';
  FRecAutoP.ClientDataset.IndexFieldNames := 'BLA_NUMERO';

  // Table RECAUTOL
  FRecAutoL.CreateField(['BLA_NUMERO', 'BLP_NUMERO', 'LPA_ID', 'LPA_BLPID', 'LPA_ARTID',
    'LPA_TGFID', 'LPA_COUID', 'LPA_CDLID', 'LPA_QTE', 'LPA_PREETIK', 'LPA_COMENT',
    'LPA_PA', 'LPA_PV', 'LPA_INCONU', 'LPA_EAN', 'LPA_PREPACK', 'Error', 'Created'],
    [ftString, ftString, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger,
    ftInteger, ftInteger, ftString, ftFloat, ftFloat, ftInteger, ftString, ftString,
    ftInteger, ftBoolean]);
  FRecAutoL.ClientDataset.AddIndex('IDX', 'BLA_NUMERO;BLP_NUMERO', []);
  FRecAutoL.ClientDataset.IndexName       := 'IDX';
  FRecAutoL.ClientDataset.MasterSource    := DS_FRecAutoP;
  FRecAutoL.ClientDataset.MasterFields    := 'BLA_NUMERO;BLP_NUMERO';
  FRecAutoL.ClientDataset.IndexFieldNames := 'BLA_NUMERO;BLP_NUMERO';

  // Table ARTFOURN
  FArtFourn.CreateField(['FOU_ID', 'FOU_CODE'], [ftInteger, ftString]);
  FArtFourn.ClientDataset.AddIndex('IDX', 'FOU_CODE', []);
  FArtFourn.ClientDataset.IndexName       := 'IDX';
end;

function TReceptionClass.CreateCdsRal: TClientDataSet;
begin
  // Création de l'objet
  Result := TClientDataSet.Create( nil );
  // Nettoyage des FieldDefs (dans le doute)
  Result.FieldDefs.Clear;
  // Création des FieldDefs: CODE_COMMANDE_SAP, CODE_ARTICLE_SAP, CDL_ID, RAL_QTE, LPA_QTE
  Result.FieldDefs.Add( 'ID', ftInteger, 0, True );
  Result.FieldDefs.Add( 'CODE_COMMANDE_SAP', ftString, 32 );
  Result.FieldDefs.Add( 'CODE_ARTICLE_SAP', ftString, 32 );
  Result.FieldDefs.Add( 'CDL_ID', ftInteger );
  Result.FieldDefs.Add( 'RAL', ftInteger );
  // Création d'un index
  Result.IndexDefs.Add( 'Idx', 'ID', [] );
//  Result.IndexFieldNames := 'ID';
  // Création de l'ensemble des données
  Result.CreateDataSet;
  Result.LogChanges := False; // Fix: Bug MDC
  Result.Open;
end;

// Création du bon de livraison
function TReceptionClass.SetRecAuto(ABLA_NUMERO: String; ABLA_DATE: TDate;
  ABLA_FOUID: Integer; ABLA_TRANS: String; ABLA_MAGID: Integer; ABLA_COMENT: String;
  ABLA_ETAT, ABLA_NBPAL, ABLA_NBPAQ, ABLA_NBART: Integer): TRecAuto;
begin
  with FIboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('SELECT BLA_ID, FAJOUT, FMAJ, ETAT');
      SQL.Add('FROM   GOS_SETRECAUTO(:PBLANUMERO, :PBLADATE, :PBLAFOUID, :PBLATRANS,');
      SQL.Add('  :PBLAMAGID, :PBLACOMENT, :PBLAETAT, :PBLANBPAL, :PBLANBPAQ, :PBLANBART)');
      ParamCheck := True;
      ParamByName('PBLANUMERO').AsString  := ABLA_NUMERO;
      ParamByName('PBLADATE').AsDate      := ABLA_DATE;
      ParamByName('PBLAFOUID').AsInteger  := ABLA_FOUID;
      ParamByName('PBLATRANS').AsString   := ABLA_TRANS;
      ParamByName('PBLAMAGID').AsInteger  := ABLA_MAGID;
      ParamByName('PBLACOMENT').AsString  := ABLA_COMENT;
      ParamByName('PBLAETAT').AsInteger   := ABLA_ETAT;
      ParamByName('PBLANBPAL').AsInteger  := ABLA_NBPAL;
      ParamByName('PBLANBPAQ').AsInteger  := ABLA_NBPAQ;
      ParamByName('PBLANBART').AsInteger  := ABLA_NBART;
      ExecSQL();

      if RecordCount > 0 then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount, FieldByName('FMAJ').AsInteger);
        Result.BLA_ID     := FieldByName('BLA_ID').AsInteger;
        Result.BLA_NUMERO := ABLA_NUMERO;
        Result.bCreer     := (FieldByName('FAJOUT').AsInteger > 0);
      end;
    except
      on E: Exception do
        raise Exception.Create(Format('SetRecAuto -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Création du carton dans le bon de livraison
function TReceptionClass.SetRecAutoP(ABLA_NUMERO: String; ABLP_BLAID: Integer;
  ABLP_NUMERO, ABLP_PALETTE: String; ABLP_QTE: Integer; ABLP_UNIVERS: String;
  ABLP_SCAN, ABLP_ETAT, ABLP_BREID: Integer): TRecAutoP;
begin
  with FIboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('SELECT BLP_ID, FAJOUT, FMAJ, ETAT');
      SQL.Add('FROM   GOS_SETRECAUTOP(:PBLPBLAID, :PBLPNUMERO, :PBLPPALETTE,');
      SQL.Add('  :PBLPQTE, :PBLPUNIVERS, :PBLPSCAN, :PBLPETAT,');
      SQL.Add('  :PBLPBREID)');
      ParamCheck := True;
      ParamByName('PBLPBLAID').AsInteger  := ABLP_BLAID;
      ParamByName('PBLPNUMERO').AsString  := ABLP_NUMERO;
      ParamByName('PBLPPALETTE').AsString := ABLP_PALETTE;
      ParamByName('PBLPQTE').AsInteger    := ABLP_QTE;
      ParamByName('PBLPUNIVERS').AsString := ABLP_UNIVERS;
      ParamByName('PBLPSCAN').AsInteger   := ABLP_SCAN;
      ParamByName('PBLPETAT').AsInteger   := ABLP_ETAT;
      ParamByName('PBLPBREID').AsInteger  := ABLP_BREID;
      ExecSQL();

      if RecordCount > 0 then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount, FieldByName('FMAJ').AsInteger);
        Result.BLP_ID     := FieldByName('BLP_ID').AsInteger;
//        Result.BLP_NUMERO := FieldByName('BLP_NUMERO').AsString;
        Result.BLP_NUMERO := ABLP_NUMERO;
        Result.bCreer     := (FieldByName('FAJOUT').AsInteger > 0);
      end;
    except
      on E: Exception do
        raise Exception.Create(Format('SetRecAutoP -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Supprime un bon de livraison des DataSets
procedure TReceptionClass.SupprimeBL(ANumeroBL: String);
begin
  // Supprime les paquets lié au bon de livraison
  RecAutoP.ClientDataset.Filter   := Format('BLA_NUMERO=''%s''', [ANumeroBL]);
  RecAutoP.ClientDataset.Filtered := True;
  RecAutoP.ClientDataset.Last();
  while not RecAutoP.ClientDataset.Bof do
  begin
    RecAutoP.ClientDataset.Delete();
    RecAutoP.ClientDataset.Prior();
  end;
  RecAutoP.ClientDataset.Filtered := False;
  RecAutoP.ClientDataset.Filter   := '';

  // Supprime le bon de livraison
  RecAuto.ClientDataset.Filter    := Format('BLA_NUMERO=''%s''', [ANumeroBL]);
  RecAuto.ClientDataset.Filtered  := True;
  RecAuto.ClientDataset.Last();
  while not RecAuto.ClientDataset.Bof do
  begin
    RecAuto.ClientDataset.Delete();
    RecAuto.ClientDataset.Prior();
  end;
  RecAuto.ClientDataset.Filtered  := False;
  RecAuto.ClientDataset.Filter    := '';
end;

// Création des articles dans les cartons livrés
function TReceptionClass.SetRecAutoL(ABLA_NUMERO, ABLP_NUMERO: String;
  ALPA_BLPID, ALPA_ARTID, ALPA_TGFID, ALPA_COUID, ALPA_CDLID, ALPA_QTE, ALPA_PREETIK: Integer;
  ALPA_COMENT: String; ALPA_PA, ALPA_PV: Double; ALPA_INCONU: Integer;
  ALPA_EAN, ALPA_PREPACK: String): TRecAutoL;
begin
  with FIboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('SELECT LPA_ID, FAJOUT, FMAJ');
      SQL.Add('FROM   GOS_SETRECAUTOL(:PLPABLPID, :PLPAARTID, :PLPATGFID,');
      SQL.Add('  :PLPACOUID, :PLPACDLID, :PLPAQTE, :PLPAPREETIK, :PLPACOMENT,');
      SQL.Add('  :PLPAPA, :PLPAPV, :PLPAINCONU, :PLPAEAN, :PLPAPREPACK)');
      ParamCheck := True;
      ParamByName('PLPABLPID').AsInteger    := ALPA_BLPID;
      ParamByName('PLPAARTID').AsInteger    := ALPA_ARTID;
      ParamByName('PLPATGFID').AsInteger    := ALPA_TGFID;
      ParamByName('PLPACOUID').AsInteger    := ALPA_COUID;
      ParamByName('PLPACDLID').AsInteger    := ALPA_CDLID;
      ParamByName('PLPAQTE').AsInteger      := ALPA_QTE;
      ParamByName('PLPAPREETIK').AsInteger  := ALPA_PREETIK;
      ParamByName('PLPACOMENT').AsString    := ALPA_COMENT;
      ParamByName('PLPAPA').AsFloat         := ALPA_PA;
      ParamByName('PLPAPV').AsFloat         := ALPA_PV;
      ParamByName('PLPAINCONU').AsInteger   := ALPA_INCONU;
      ParamByName('PLPAEAN').AsString       := ALPA_EAN;
      ParamByName('PLPAPREPACK').AsString    := ALPA_PREPACK;
      ExecSQL();

      if RecordCount > 0 then
      begin
        {DONE -oJO : Ajout du correctif de Clément CESSIN (2016-04-07)}
        if (FieldByName('FAJOUT').AsInteger = 0) and (FieldByName('FMAJ').AsInteger = 0) then
          raise Exception.Create('Impossible d''insérer le produit ' + IntToStr(ALPA_ARTID));

        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount, FieldByName('FMAJ').AsInteger);
        Result.LPA_ID     := FieldByName('LPA_ID').AsInteger;
//        Result.LPA_PREPACK := FieldByName('LPA_PREPACK').AsString;
        Result.LPA_PREPACK := ALPA_PREPACK;
        Result.bCreer     := (FieldByName('FAJOUT').AsInteger > 0);
      end;
    except
      on E: Exception do
        raise Exception.Create(Format('SetRecAutoL -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Récupére le prix d'achat en magasin d'un article
function TReceptionClass.GetPaMagasin(const MAGID, ARTID, TGFID, COUID,
  CDLID: Integer): Double;
var
  PrmInteger: Integer;
  Erreur: TErreur;
begin
  try
    // Recherche de la centrale du magasin
//CAF
    PrmInteger := DM_GSDataExport.GetParamInteger( 16, 32, MAGID );
    case PrmInteger of
      Ord( TMagMode.mtCAF ): Result := 0; // backward compatibility
      Ord( TMagMode.mtAffilie ), Ord( TMagMode.mtMandat ):
//    PrmInteger := DM_GSDataExport.GetParamInteger( 16, 7, MAGID );
//    case PrmInteger of
//      Ord( TMagType.mtCourir ): Result := 0; // backward compatibility
//      Ord( TMagType.mtGoSport ):
      {$REGION 'Recherche du prix d''achat...'}
      begin
        FIboQuery.Close;
        try
          {$REGION 'Préparation de la requête...'}
          if CDLID = 0 then
          begin
            FIboQuery.SQL.Text := 'select cast( getpxachat.pxnego as numeric(18,7) ) prixachat ' +
                                  'from getpxachat( null, :ART_ID, :TGF_ID, :COU_ID) ';
            FIboQuery.ParamByName( 'ART_ID' ).AsInteger := ARTID;
            FIboQuery.ParamByName( 'TGF_ID' ).AsInteger := TGFID;
            FIboQuery.ParamByName( 'COU_ID' ).AsInteger := COUID;
          end
          else
          begin
            FIboQuery.SQL.Text := 'select combcdel.cdl_pxachat prixachat ' +
                                  'from combcdel ' +
                                  'join k kcdl on kcdl.k_id = combcdel.cdl_id/* and kcdl.k_enabled = 1*/ ' +
                                  'where combcdel.cdl_id = :CDL_ID ';
            FIboQuery.ParamByName( 'CDL_ID' ).AsInteger := CDLID;
          end;
          {$ENDREGION 'Préparation de la requête...'}
          {$REGION 'Execution de la requête, récupération du prix d''achat...'}
          FIboQuery.Open;
          case FIboQuery.RecordCount of
            1: // Prix d'achat trouvé, récupération...
              Result := FIboQuery.FieldByName('prixachat').AsFloat;
            else raise Exception.Create('prix dachat erreur');
          end;
          {$ENDREGION 'Execution de la requête, récupération du prix d''achat...'}
        finally
          FIboQuery.Close;
        end;
      end;{$ENDREGION 'Recherche du prix d''achat...'}
      else raise Exception.Create('centrale erreur');
    end;
  except
    Erreur := TErreur.Create();
    Erreur.AddError(FFileImport, 'Importation',
      Format('Article sans prix d''achat : %s', [cds_ReceptionImport.FieldByName('08_CODE_ARTICLE').AsString]),
      cds_ReceptionImport.RecNo, teReception, 0, '');
    GERREURS.Add(Erreur);
    IncError ;
  end;
end;

// Récupére le prix de vente en magasin d'un article
function TReceptionClass.GetPvMagasin(ARTID, TGFID, COUID: Integer): Double;
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
  begin
    Erreur := TErreur.Create();
    Erreur.AddError(FFileImport, 'Importation',
      Format('Article sans prix de vente : %s', [cds_ReceptionImport.FieldByName('08_CODE_ARTICLE').AsString]),
      cds_ReceptionImport.RecNo, teReception, 0, '');
    GERREURS.Add(Erreur);
    IncError ;
  end;

  Result := IboQuery.FieldByName('R_PRIX').AsFloat;
  IboQuery.Close();
end;

procedure TReceptionClass.GetSpecificRAL(const CodeCommandeSAP,
  CodeArticleSAP: String);
begin
  // Filtre les lignes de RAL sur la commande et l'article spécifié
  try
    Fcds_Ral.Filtered := False;
    Fcds_Ral.Filter := Format( 'CODE_COMMANDE_SAP = %s and CODE_ARTICLE_SAP = %s', [ QuotedStr( CodeCommandeSAP ), QuotedStr( CodeArticleSAP ) ] );
    Fcds_Ral.Filtered := True;
    Fcds_Ral.First;
    if Fcds_Ral.RecordCount = 0 then
      raise Exception.CreateFmt( 'Aucun RAL (RAL + Quantité BL non réceptionnée) trouvé pour la commande "%s" et l''article "%s"', [ CodeCommandeSAP, CodeArticleSAP ] );
  except
    on E: Exception do
      raise Exception.CreateFmt( 'GetSpecificRAL -> %s', [ E.Message ] );
  end;
end;

function TReceptionClass.GetCombinationRAL(const CodeCommandeSAP,
  CodeArticleSAP: String; const Quantity: Integer): TRecAutoLRecArray;
var
  ResultLength: Cardinal;
  RemainingQuantity: Integer;
begin
  try
    // Défaut
    ResultLength := 0;
    SetLength( Result, ResultLength );

    {$REGION 'Backward compatibility'}
    if not IsCodeCommandeSAPValid( CodeCommandeSAP ) then
    begin
      AddCombination( Result, Quantity, 0 );
      Exit;
    end;
    {$ENDREGION}

    try
      // Récupération des lignes de RAL portant sur la commande et l'article
      GetSpecificRAL( CodeCommandeSAP, CodeArticleSAP );

      if ( Quantity <= 0 ) then
        Exit;
    except
      // En cas d'erreur, on créer le BL quand même qu'importe l'article,
      // qu'importe le RAL de la commande
      AddCombination( Result, Quantity, 0 );
      Exit;
    end;

    RemainingQuantity := Quantity;
    while not Fcds_Ral.Eof do
    begin
      if Fcds_Ral.FieldByName( 'RAL' ).AsInteger >= RemainingQuantity then
      begin
        AddCombination( Result, RemainingQuantity, Fcds_Ral.FieldByName( 'CDL_ID' ).AsInteger );
        RemainingQuantity := Fcds_Ral.FieldByName( 'RAL' ).AsInteger - RemainingQuantity;
        if RemainingQuantity = 0 then
          Fcds_Ral.Delete
        else
        begin
          Fcds_Ral.Edit;
          Fcds_Ral.FieldByName( 'RAL' ).AsInteger := RemainingQuantity;
          Fcds_Ral.Post;
        end;
        Exit;
      end
      else
      begin
        AddCombination( Result, Fcds_Ral.FieldByName( 'RAL' ).AsInteger, Fcds_Ral.FieldByName( 'CDL_ID' ).AsInteger );
        Dec( RemainingQuantity, Fcds_Ral.FieldByName( 'RAL' ).AsInteger );
        Fcds_Ral.Delete;
      end;
    end;
    if RemainingQuantity > 0 then
      AddCombination( Result, RemainingQuantity, 0 )
  except
    on E: Exception do
      raise Exception.CreateFmt( 'GetCombinationRAL -> %s', [ E.Message ] );
  end;
end;

function TReceptionClass.DoMajTable(): Boolean;
var
  RecAuto   : TRecAuto;
  RecAutoP  : TRecAutoP;
  RecAutoL  : TRecAutoL;
  Erreur    : TErreur;
begin
  // Intégration des bons de livraison

  {$REGION 'Traitement des bons de livraisons'}
  FRecAuto.First();
  while not FRecAuto.EOF() do
  begin
    FIboQuery.IB_Transaction.StartTransaction();
    try
      {$REGION 'Création du bon de livraison'}
      try
        RecAuto := SetRecAuto(FRecAuto.FieldByName('BLA_NUMERO').AsString,
          FRecAuto.FieldByName('BLA_DATE').AsDateTime,
          FRecAuto.FieldByName('BLA_FOUID').AsInteger,
          FRecAuto.FieldByName('BLA_TRANS').AsString,
          FRecAuto.FieldByName('BLA_MAGID').AsInteger,
          FRecAuto.FieldByName('BLA_COMENT').AsString,
          FRecAuto.FieldByName('BLA_ETAT').AsInteger,
          FRecAuto.FieldByName('BLA_NBPAL').AsInteger,
          FRecAuto.FieldByName('BLA_NBPAQ').AsInteger,
          FRecAuto.FieldByName('BLA_NBART').AsInteger);

        // Met à jour le ClientDataSet
        FRecAuto.Edit();
        FRecAuto.FieldByName('BLA_ID').AsInteger  := RecAuto.BLA_ID;
        FRecAuto.FieldByName('Created').AsBoolean := RecAuto.bCreer;
        FRecAuto.Post();
      except
        on E: Exception do
          raise Exception.Create(Format('Bon de livraison %s - [%s] : %s',
            [FRecAuto.FieldByName('BLA_NUMERO').AsString, E.ClassName, E.Message]));
      end;
      {$ENDREGION}

      if RecAuto.bCreer then
      begin
        {$REGION 'Création du carton dans le bon de livraison'}
        FRecAutoP.First();
        while not FRecAutoP.EOF() do
        begin
          try
            RecAutoP := SetRecAutoP(FRecAutoP.FieldByName('BLA_NUMERO').AsString,
              RecAuto.BLA_ID,
              FRecAutoP.FieldByName('BLP_NUMERO').AsString,
              FRecAutoP.FieldByName('BLP_PALETTE').AsString,
              FRecAutoP.FieldByName('BLP_QTE').AsInteger,
              FRecAutoP.FieldByName('BLP_UNIVERS').AsString,
              FRecAutoP.FieldByName('BLP_SCAN').AsInteger,
              FRecAutoP.FieldByName('BLP_ETAT').AsInteger,
              FRecAutoP.FieldByName('BLP_BREID').AsInteger);

            // Met à jour le ClientDataSet
            FRecAutoP.Edit();
            FRecAutoP.FieldByName('BLP_BLAID').AsInteger  := RecAuto.BLA_ID;
            FRecAutoP.FieldByName('BLP_ID').AsInteger     := RecAutoP.BLP_ID;
            FRecAutoP.FieldByName('Created').AsBoolean    := RecAutoP.bCreer;
            FRecAutoP.Post();

            if RecAutoP.bCreer then
            begin

              {$REGION 'Création des articles dans les cartons livrés'}
              FRecAutoL.First();
              while not FRecAutoL.EOF() do
              begin
                try
                  RecAutoL := SetRecAutoL(FRecAutoL.FieldByName('BLA_NUMERO').AsString,
                    FRecAutoL.FieldByName('BLP_NUMERO').AsString,
                    RecAutoP.BLP_ID,
                    FRecAutoL.FieldByName('LPA_ARTID').AsInteger,
                    FRecAutoL.FieldByName('LPA_TGFID').AsInteger,
                    FRecAutoL.FieldByName('LPA_COUID').AsInteger,
                    FRecAutoL.FieldByName('LPA_CDLID').AsInteger,
                    FRecAutoL.FieldByName('LPA_QTE').AsInteger,
                    FRecAutoL.FieldByName('LPA_PREETIK').AsInteger,
                    FRecAutoL.FieldByName('LPA_COMENT').AsString,
                    FRecAutoL.FieldByName('LPA_PA').AsFloat,
                    FRecAutoL.FieldByName('LPA_PV').AsFloat,
                    FRecAutoL.FieldByName('LPA_INCONU').AsInteger,
                    FRecAutoL.FieldByName('LPA_EAN').AsString,
                    FRecAutoL.FieldByName('LPA_PREPACK').AsString);

                  // Met à jour le ClientDataSet
                  FRecAutoL.Edit();
                  FRecAutoL.FieldByName('LPA_BLPID').AsInteger  := RecAutoP.BLP_ID;
                  FRecAutoL.FieldByName('LPA_ID').AsInteger     := RecAutoL.LPA_ID;
                  FRecAutoL.FieldByName('Created').AsBoolean    := RecAutoL.bCreer;
                  FRecAutoL.Post();
                except
                  on E: Exception do
                  begin
//                    raise Exception.Create(Format('Bon de livraison (article) %s - [%s] : %s',
//                      [FRecAutoL.FieldByName('LPA_PREPACK').AsString, E.ClassName, E.Message]));
                    Erreur := TErreur.Create();
                    Erreur.AddError('', 'Intégration', Format('[%s] : %s', [E.ClassName, E.Message]),
                      0, teReception, 0, '');
                    GERREURS.Add(Erreur);
                    IncError ;
                  end;
                end;

                FRecAutoL.Next();
              end;
              {$ENDREGION}              
            end;          
            except
            on E: Exception do
              raise Exception.Create(Format('Bon de livraison (carton) %s - [%s] : %s',
                [FRecAutoP.FieldByName('BLP_NUMERO').AsString, E.ClassName, E.Message]));
          end;

          FRecAutoP.Next();
        end;
        {$ENDREGION}        
      end;

      FIboQuery.IB_Transaction.Commit();
    except
      on E: Exception do
      begin
        FIboQuery.IB_Transaction.Rollback();
        Erreur := TErreur.Create();
        Erreur.AddError('', 'Intégration', Format('[%s] : %s', [E.ClassName, E.Message]),
          0, teReception, 0, '');
        GERREURS.Add(Erreur);
        IncError ;
      end;
    end;

    FRecAuto.Next();

    BarPosition(FRecAuto.ClientDataset.RecNo * 100 div FRecAuto.ClientDataset.RecordCount);
  end;
  {$ENDREGION}
end;

procedure TReceptionClass.Import();
var
  Erreur          : TErreur;
  i               : Integer;
  sPrefixe        : String;
  sNumBT          : String;
  Article         : TCodeArticle;
  iFOU_ID         : Integer;
  // Liste des bons de livraisons en erreur
  slListeBLBloque : TStringList;
  // Liste des numéros de cartons par bon de livraison
  slListeBLCarton : TStringList;
  LigneCommande   : Integer;
  RecAutoLRec     : TRecAutoLRec;
  RecAutoLRecArray: TRecAutoLRecArray;
  vPAValid        : Boolean;
  vPAValue        : Double;
begin
   // Création des tables et champs
   CreateCdsField();

   GetGlobalRAL;

   // Récupération du nom de fichier
  for i := Low(FilesPath) to High(FilesPath) do
  begin
    sPrefixe := Copy(FilesPath[i], 1, 6);
    case AnsiIndexStr(UpperCase(sPrefixe), ['EXPCAF', 'CESMAG']) of
      0, 1:
        FFileImport := FilesPath[i];
    end;
  end;

  LabCaption(Format('Importation du fichier %s', [FFileImport]));

  // Créer la liste des bons de livraisons qui seront en erreur
  slListeBLBloque := TStringList.Create();

  // Créer la liste des numéros de cartons
  slListeBLCarton := TStringList.Create();
  try
    slListeBLBloque.CaseSensitive := False;

    // Import des données dans le ClientDataSet
    cds_ReceptionImport.First();
    FCount := cds_ReceptionImport.RecordCount;

    while not cds_ReceptionImport.Eof do
    begin
      try
        // Vérifie si le bon de livraison n'est pas en erreur avant de continuer à le traiter
        sNumBT := cds_ReceptionImport.FieldByName('02_NUM_BT').AsString;

        if (slListeBLBloque.IndexOf(sNumBT) = -1) then
        begin
          {$REGION 'Importation des données des bons de livraisons'}
          // Vérifie l'unicité d'un bon de livraison
          if not FRecAuto.ClientDataset.Locate('BLA_NUMERO', sNumBT, []) then
          begin
            FRecAuto.Append();
            FRecAuto.FieldByName('BLA_ID').AsInteger    := 0;
            FRecAuto.FieldByName('BLA_NUMERO').AsString := sNumBT;
            FRecAuto.FieldByName('BLA_DATE').AsDateTime := ConvertDate(cds_ReceptionImport.FieldByName('05_DATE_LIVRAISON').AsString);

            if not FArtFourn.ClientDataset.Locate('FOU_CODE', cds_ReceptionImport.FieldByName('01_CODE_EXPEDITEUR').AsString, [loCaseInsensitive]) then
            begin
              FArtFourn.Append();
              FArtFourn.FieldByName('FOU_ID').AsInteger   := GetIDFromTable('ARTFOURN', 'FOU_CODE', cds_ReceptionImport.FieldByName('01_CODE_EXPEDITEUR').AsString, 'FOU_ID');
              FArtFourn.FieldByName('FOU_CODE').AsString  := cds_ReceptionImport.FieldByName('01_CODE_EXPEDITEUR').AsString;
              FArtFourn.Post();
            end;

            iFOU_ID := FArtFourn.FieldByName('FOU_ID').AsInteger;

            if iFOU_ID > -1 then
            begin
              FRecAuto.FieldByName('BLA_FOUID').AsInteger := iFOU_ID;
              FRecAuto.FieldByName('Error').AsInteger     := 0;
            end
            else begin
              // Mise en erreur du code fournisseur
              FRecAuto.FieldByName('BLA_FOUID').AsInteger := 0;
              FRecAuto.FieldByName('Error').AsInteger     := 1;
              Erreur                                      := TErreur.Create();
              Erreur.AddError(FFileImport, 'Fournisseur',
                Format('Pas de fournisseur pour le bon de livraison %s', [sNumBT]),
                  cds_ReceptionImport.RecNo, teReception, 0, '');
              GERREURS.Add(Erreur);
              IncError ;
            end;

            FRecAuto.FieldByName('BLA_TRANS').AsString := '';

            if (cds_ReceptionImport.FieldByName('03_DIVISION_DEST').AsString = MAG_CODEADH) then
            begin
              FRecAuto.FieldByName('BLA_MAGID').AsInteger := MAG_ID;
            end
            else begin
              // Mise en erreur du code magasin
              FRecAuto.FieldByName('Error').AsInteger := 1;
              Erreur                                  := TErreur.Create();
              Erreur.AddError(FFileImport, 'Magasin',
                Format('Pas de magasin pour le bon de livraison %s',
                  [cds_ReceptionImport.FieldByName('02_NUM_BT').AsString]),
                  cds_ReceptionImport.RecNo, teReception, 0, '');
              GERREURS.Add(Erreur);
              IncError ;

              // On importe pas la ligne
              FRecAuto.ClientDataset.Cancel();
              raise ECFGERROR.Create(Format('Le magasin du bon de livraison n°%s n''est pas le bon.', [sNumBT]));
            end;
            FRecAuto.FieldByName('BLA_COMENT').AsString := FFileImport;
            FRecAuto.FieldByName('BLA_ETAT').AsInteger  := 0;
            FRecAuto.FieldByName('BLA_NBPAL').AsInteger := 1;
            // Initialise le nombre de cartons
            FRecAuto.FieldByName('BLA_NBPAQ').AsInteger := 1;
            slListeBLCarton.Add(Format('%s=%s',
              [cds_ReceptionImport.FieldByName('02_NUM_BT').AsString,
                cds_ReceptionImport.FieldByName('07_NUM_CARTON').AsString]));
            // Ajoute la quantité du premier carton
            FRecAuto.FieldByName('BLA_NBART').AsInteger := cds_ReceptionImport.FieldByName('10_QTE').AsInteger;
            FRecAuto.Post();
          end
          else begin
            FRecAuto.Edit();
            // Incrémente le nombre de cartons à chaque nouveau carton
            if (slListeBLCarton.IndexOf(Format('%s=%s',
              [cds_ReceptionImport.FieldByName('02_NUM_BT').AsString,
                cds_ReceptionImport.FieldByName('07_NUM_CARTON').AsString])) = -1) then
            begin
              FRecAuto.FieldByName('BLA_NBPAQ').AsInteger := Succ(FRecAuto.FieldByName('BLA_NBPAQ').AsInteger);
              slListeBLCarton.Add(Format('%s=%s',
                [cds_ReceptionImport.FieldByName('02_NUM_BT').AsString,
                  cds_ReceptionImport.FieldByName('07_NUM_CARTON').AsString]));
            end;
            // Ajoute la quantité du nouveau carton
            FRecAuto.FieldByName('BLA_NBART').AsInteger := FRecAuto.FieldByName('BLA_NBART').AsInteger + cds_ReceptionImport.FieldByName('10_QTE').AsInteger;
            FRecAuto.Post();
          end;
          {$ENDREGION}

          {$REGION 'Importation des données sur les cartons livrés'}
          // Vérifie l'unicité du carton
          if not FRecAutoP.ClientDataset.Locate('BLA_NUMERO;BLP_NUMERO',
            VarArrayOf([sNumBT, cds_ReceptionImport.FieldByName('07_NUM_CARTON').AsString]), []) then
          begin
            FRecAutoP.Append();
            FRecAutoP.FieldByName('BLA_NUMERO').AsString  := sNumBT;
            FRecAutoP.FieldByName('BLP_ID').AsInteger     := 0;
            FRecAutoP.FieldByName('BLP_BLAID').AsInteger  := 0;
            FRecAutoP.FieldByName('BLP_NUMERO').AsString  := cds_ReceptionImport.FieldByName('07_NUM_CARTON').AsString;
            FRecAutoP.FieldByName('BLP_PALETTE').AsString := cds_ReceptionImport.FieldByName('07_NUM_CARTON').AsString;
            FRecAutoP.FieldByName('BLP_QTE').AsInteger    := cds_ReceptionImport.FieldByName('10_QTE').AsInteger;
            FRecAutoP.FieldByName('BLP_UNIVERS').AsString := '';
            FRecAutoP.FieldByName('BLP_SCAN').AsInteger   := 0;
            FRecAutoP.FieldByName('BLP_ETAT').AsInteger   := 0;
            FRecAutoP.FieldByName('BLP_BREID').AsInteger  := 0;
            FRecAutoP.Post();
          end
          else begin
            FRecAutoP.Edit();
            FRecAutoP.FieldByName('BLP_QTE').AsInteger    := FRecAutoP.FieldByName('BLP_QTE').AsInteger + cds_ReceptionImport.FieldByName('10_QTE').AsInteger;
            FRecAutoP.Post();
          end;
          {$ENDREGION}

          {$REGION 'Importation des données sur les articles dans les cartons'}
          Try
            if BArtRelationArt then
            begin
              if (FArtRelationArt.ClientDataset.Active)
              and (FArtRelationArt.ClientDataset.Locate('CODE_ARTICLE', cds_ReceptionImport.FieldByName('08_CODE_ARTICLE').AsString, [])) then
              begin
                Article.ART_ID := FArtRelationArt.FieldByName('ARA_ARTID').AsInteger;
                Article.TGF_ID := FArtRelationArt.FieldByName('ARA_TGFID').AsInteger;
                Article.COU_ID := FArtRelationArt.FieldByName('ARA_COUID').AsInteger;
              end
              else begin
                  Article := GetCodeArticle(cds_ReceptionImport.FieldByName('08_CODE_ARTICLE').AsString);
              end;
            end
            else begin
              Article := GetCodeArticle(cds_ReceptionImport.FieldByName('08_CODE_ARTICLE').AsString);
            end;

            RecAutoLRecArray := GetCombinationRAL(
              cds_ReceptionImport.FieldByName( '12_COMMANDE_SAP' ).AsString,
              cds_ReceptionImport.FieldByName( '08_CODE_ARTICLE' ).AsString,
              cds_ReceptionImport.FieldByName( '10_QTE' ).AsInteger
            );

          except on E:Exception do
            begin
              Erreur := TErreur.Create();
              Erreur.AddError(FFileImport, 'Importation', Format('[%s] : %s', [E.ClassName, E.Message]),
                cds_ReceptionImport.RecNo, teReception, 0, '');
              GERREURS.Add(Erreur);
              cds_ReceptionImport.Next;
              Continue;
            end;
          End;

          if not cds_ReceptionImport.FieldByName('13_PRIX_ACHAT').IsNull then
          begin
            vPAValid := True;
            try
              vPAValue := StrToCurr(StringReplace(cds_ReceptionImport.FieldByName('13_PRIX_ACHAT').AsString,'.',',',[]));
            except
              on E: Exception do
              begin
                vPAValid := False;
                DM_GSDataMain.AddToMemo(' - Erreur conversion prix d''achat [' + E.Message + ']');
                raise Exception.Create('Erreur conversion prix d''achat [' + E.Message + ']');
              end;
            end;
          end
          else
            vPAValid := False;

          for RecAutoLRec in RecAutoLRecArray do begin
            Try
              FRecAutoL.Append();
              FRecAutoL.FieldByName('BLA_NUMERO').AsString    := sNumBT;
              FRecAutoL.FieldByName('LPA_ID').AsInteger       := 0;
              FRecAutoL.FieldByName('LPA_BLPID').AsInteger    := 0;
              FRecAutoL.FieldByName('LPA_ARTID').AsInteger    := Article.ART_ID;
              FRecAutoL.FieldByName('LPA_TGFID').AsInteger    := Article.TGF_ID;
              FRecAutoL.FieldByName('LPA_COUID').AsInteger    := Article.COU_ID;
              FRecAutoL.FieldByName('LPA_CDLID').AsInteger    := RecAutoLRec.LPA_CDLID;
              FRecAutoL.FieldByName('LPA_QTE').AsInteger      := RecAutoLRec.LPA_QTE;
              FRecAutoL.FieldByName('LPA_PREETIK').AsInteger  := 0;
              FRecAutoL.FieldByName('LPA_COMENT').AsString    := '';
              if vPAValid then
                FRecAutoL.FieldByName('LPA_PA').AsFloat       := vPAValue
              else
                FRecAutoL.FieldByName('LPA_PA').AsFloat       := GetPaMagasin( MAG_ID, Article.ART_ID, Article.TGF_ID, Article.COU_ID, RecAutoLRec.LPA_CDLID );
              FRecAutoL.FieldByName('LPA_PV').AsFloat         := GetPvMagasin(Article.ART_ID, Article.TGF_ID, Article.COU_ID);
              FRecAutoL.FieldByName('LPA_INCONU').AsInteger   := 0;
              FRecAutoL.FieldByName('LPA_EAN').AsString       := cds_ReceptionImport.FieldByName('09_EAN_ARTICLE').AsString;
              FRecAutoL.FieldByName('LPA_PREPACK').AsString   := cds_ReceptionImport.FieldByName('11_CODE_ART_PREPACK').AsString;
              FRecAutoL.Post();
            except on E:Exception do
              begin
                Erreur := TErreur.Create();
                Erreur.AddError(FFileImport, 'Importation', Format('[%s] Article : %s - %s', [E.ClassName, cds_ReceptionImport.FieldByName('08_CODE_ARTICLE').AsString, E.Message]),
                  cds_ReceptionImport.RecNo, teReception, 0, '');
                GERREURS.Add(Erreur);
                FRecAutoL.ClientDataset.Cancel;
              end;
            End;
          end;
          {$ENDREGION}
        end;
      except
        on E: Exception do
        begin
          // Ajout le bon de livraison en cour à la liste des bons de livraisons en erreur
          slListeBLBloque.Add(sNumBT);

          // Annule toutes les modifications en cours
          FCds.Cancel();
          FRecAuto.ClientDataset.Cancel();
          FRecAutoP.ClientDataset.Cancel();
          FRecAutoL.ClientDataset.Cancel();

          // Supprime le bon de livraison en cours des DataSets
          SupprimeBL(sNumBT);

          // Ajout les messages d'erreurs au rapport
          Erreur := TErreur.Create();
          Erreur.AddError(FFileImport, 'Importation', Format('[%s] : %s', [E.ClassName, E.Message]),
            cds_ReceptionImport.RecNo, teReception, 0, '');
          GERREURS.Add(Erreur);
          Erreur := TErreur.Create();
          Erreur.AddError(FFileImport, 'Importation', Format('Le bon de livraison %s n''a pas été intégré. Les erreurs suivantes de ce bon ont été ignorées.', [sNumBT]),
            cds_ReceptionImport.RecNo, teReception, 0, '');
          GERREURS.Add(Erreur);
          IncError ;
        end;
      end;

      cds_ReceptionImport.Next();
      BarPosition(cds_ReceptionImport.RecNo * (100 div cds_ReceptionImport.RecordCount));
    end;
  finally
    slListeBLBloque.Free();
    slListeBLCarton.Free();
  end;
end;

function TReceptionClass.IsCodeCommandeSAPValid(
  const CodeCommandeSAP: String): Boolean;
var
  S: String;  // version sans espace (trim) du CodeCommandeSAP
  I: Integer; // conversion du CodeCommandeSAP en entier
  E: Integer; // retour erreur de la conversion en entier
begin
  (*
    Cette function permet de définir si la chaine en paramètre correspond bien à
    un "Code de commande SAP" valide.
  *)
  S := Trim( CodeCommandeSAP );
  Val( S, I, E ); // E = 0 ? <succeed> : <failed>
  Result := ( ( E = 0 ) and ( I <> 0 ) )
         or ( ( E <> 0 ) and ( S <> '' ) );
end;

end.
