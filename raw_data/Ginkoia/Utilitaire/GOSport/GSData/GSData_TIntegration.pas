unit GSData_TIntegration;

interface

uses GSData_MainClass, GSData_TErreur, GSData_Types,
     GSDataImport_DM, ComCtrls,  strUtils, Dialogs,
     DBClient, SysUtils, IBODataset, Db, Variants,
     GSDataExtract_DM;

Type
    TOFRTETE = Record
    OFE_CHRONO       : String[32];
    OFE_NOM          : String[64];
    OFE_CODECENTRAL  : Integer;
    OFE_TYPE         : Integer;
    OFE_ACTIF        : Integer;
    OFE_CUMUL        : Integer;
    OFE_CENTRALE     : Integer;
    OFE_DATE         : TDateTime;
    OFE_CODTVALDEB   : TDateTime;
    OFE_CODTVALFIN   : TDateTime;
    OFE_COPERM       : Integer;
    OFE_COOPTYPDEC   : Integer;
    OFE_COOPCB       : String[32];
    OFE_COBRPREFIXE  : String[32];
    OFE_COBRLGVAL    : Integer;
    OFE_COBRLGDEC    : Integer;
    OFE_COCLTTYP     : Integer;
    OFE_COCLTFID     : Integer;
    OFE_COCLTCLA     : Integer;
    OFE_COPALIERFID  : Integer;
    OFE_COTYPVTEN    : Integer;
    OFE_COTYPVTES    : Integer;
    OFE_COTYPVTEP    : Integer;
    OFE_COREMMAX     : Extended;
    OFE_COMINPAN     : Extended;
    OFE_COMAXPAN     : Extended;
    OFE_COPERIMPAN   : Integer;
    OFE_COMINART     : Integer;
    OFE_COMAXART     : Integer;
    OFE_COPERIMART   : Integer;
    OFE_COPERIM      : Integer;
    OFE_COMODCONTRAC : Integer;
    OFE_COMODCOMPLE  : Integer;
    OFE_CACLTPERIM   : Integer;
    OFE_CATYPVTEN    : Integer;
    OFE_CATYPVTES    : Integer;
    OFE_CATYPVTEP    : Integer;
    OFE_CAREMMAX     : Extended;
    OFE_CAPXMIN      : Integer;
    OFE_CAMINPAN     : Extended;
    OFE_CAMAXPAN     : Extended;
    OFE_CAPERIMPAN   : Integer;
    OFE_CAMINART     : Integer;
    OFE_CAMAXART     : Integer;
    OFE_CAPERIMART   : Integer;
    OFE_CAPERIM      : Integer;
    OFE_CAMODCONTRAC : Integer;
    OFE_CAMODCOMPLE  : Integer;
    OFE_AVTYPLIGNE   : Integer;
    OFE_AVVALX       : Integer;
    OFE_AVTYPREM     : Integer;
    OFE_AVVAL1       : Extended;
    OFE_AVVAL2       : Extended;
    OFE_AVVAL3       : Extended;
    OFE_AVVAL4       : Extended;
    OFE_AVVAL5       : Extended;
//JB Ajout OFE_MARGECENTRALE
    OFE_MARGECENTRALE: Integer;
  End;

  TIntegration = class(TMainClass)
  private
    FOFRTETE             : TMainClass;
    FOFRMAGASIN          : TMainClass;
    FOFRIMPBR            : TMainClass;
    FOFRLIGNEBR          : TMainClass;
    FOFRPERIMETRE        : TMainClass;
    FOFRTYPCARTEFID      : TMainClass;

    FOFRTETEINIT         : TMainClass;
    FOFRETEVERIF         : TMainClass;
    FOFRMAGASINLOAD      : TMainClass;
    FOFRIMPBRLOAD        : TMainClass;
    FOFRLIGNEBRLOAD      : TMainClass;
    FOFRPERIMETRELOAd    : TMainClass;
    FOFRTYPCARTEFIDLOAD  : TMainClass;
    FGENTYPCARTEFIDLOAD  : TMainClass;

    FFournTemp           : TMainClass;

    Ds_Ofrtete           : TDataSource;

    Function  SetOFRTETE(AOFRTETE : TOFRTETE; InitMode : Boolean) : Integer;
    Function  SetOFRMAGASIN(OFEID, MAGID : Integer) : Integer;
    Function  SetOFRLIGNEBR(AOFEID, AREPART : Integer; ADTUTILDEB, ADTUTILFIN : TDateTime) : Integer ;
    Function  SetOFRIMPBR(AOFEID, ATYPLIGNE, ANUMLIGNE : Integer; AData : String) : Integer;
    Function  SetOFRPERIMETRE(AOFEID, ATYPPERIM, ATYPDATA, ALIGNEID, AINCLUEXCLU : Integer) : Integer;
    function  SetOFRTYPCARTEFID(AOFEID, ATCFTYPE, ATCFCENTRALE: Integer): Integer;

    Procedure LoadOFRTETERecord(AOFRTETE : TOFRTETE);
    Procedure DelID(ID : Integer);
  public
    ModeInitialisation : Boolean;
    OkAutreFic         : Boolean;

    Constructor Create;  override;
    Destructor  Destroy; override;

    Procedure CreateCds;

    Procedure Import;     override;
    Function  DoMajTable : Boolean; override;

    Function RemplirFcds( Cds, FCds : TClientDataset) : Boolean; //Fonction qui rempli les cds
    Function FiltreCds( Cds : TClientDataSet; Field : String; Valeur : Integer) : Boolean;

    Function MagExist( FouCode : String ) : Integer;

    Function  RempliLINEFOFR(cds, FCds: TClientDataSet): Boolean;
    Function  RempliFcdsMag (Cds, FCds: TClientDataSet): Boolean;
    Procedure RempliFOFRMAGetTETE(ACdsTETE, ACdsMAGASIN, AFcdsTETE, AFcdsMAGASIN, AFcdsTETEVERIF : TClientDataSet);
    Function  RemplirFcdsPerimetre(Cds, FCds: TClientDataset): Boolean;
    Function  GetLigneID(TypeData : Integer; Code, Nom : String) : Integer;

    Function LoadFCdsLoad(ATable, APrefix, AMFix: String; ACdsLoad: TClientDataSet; AOFEID : Integer) : Boolean;

    procedure RempliFcdsTypCarteFidLoad(ACdsLoad: TClientDataSet);

    Procedure ActiveMaitreDetail;
    Procedure DesactiveMaitreDetail;

    Procedure ClearCdsImport;
    Procedure ClearFcdsLoad;
    Procedure ClearFcds;

  published

  end;

  var
    NbOffreImport       : Integer;
    NbOffreDoMaj        : Integer;


implementation

uses GSDataMain_DM;

{ TIntegration }

procedure TIntegration.ActiveMaitreDetail;
begin
  with Dm_GSDataExtract do
  begin
  //cds_OFRMAGASIN
  cds_OFRMAGASIN.AddIndex('Idx','OFM_OFECHRONO',[]);
  cds_OFRMAGASIN.IndexName      := 'Idx';
  cds_OFRMAGASIN.MasterSource   := Ds_OFRTETE;
  cds_OFRMAGASIN.MasterFields   := 'OFE_CHRONO';

  //cds_OFRIMPBR
  cds_OFRIMPBR.AddIndex('Idx','OFI_OFECHRONO',[]);
  cds_OFRIMPBR.IndexName        := 'Idx';
  cds_OFRIMPBR.MasterSource     := Ds_OFRTETE;
  cds_OFRIMPBR.MasterFields     := 'OFE_CHRONO';

  //cds_OFRLIGNEBR
  cds_OFRLIGNEBR.AddIndex('Idx','OFL_OFECHRONO',[]);
  cds_OFRLIGNEBR.IndexName      := 'Idx';
  cds_OFRLIGNEBR.MasterSource   := Ds_OFRTETE;
  cds_OFRLIGNEBR.MasterFields   := 'OFE_CHRONO';

  //cds_OFRPERIMETRE
  cds_OFRPERIMETRE.AddIndex('Idx','OFP_OFECHRONO',[]);
  cds_OFRPERIMETRE.IndexName    := 'Idx';
  cds_OFRPERIMETRE.MasterSource := Ds_OFRTETE;
  cds_OFRPERIMETRE.MasterFields := 'OFE_CHRONO';

  //cds_GENTYPCARTEFID
  cds_OFRTYPCARTEFID.AddIndex('Idx','TCF_OFECHRONO',[]);
  cds_OFRTYPCARTEFID.IndexName    := 'Idx';
  cds_OFRTYPCARTEFID.MasterSource := Ds_OFRTETE;
  cds_OFRTYPCARTEFID.MasterFields := 'OFE_CHRONO';
  end;
end;

procedure TIntegration.ClearCdsImport;
begin
  //procedure qui permet de nettoyer les cds
  FOFRTETE.ClientDataset.EmptyDataSet;
  FOFRMAGASIN.ClientDataset.EmptyDataSet;
  FOFRIMPBR.ClientDataset.EmptyDataSet;
  FOFRLIGNEBR.ClientDataset.EmptyDataSet;
  FOFRPERIMETRE.ClientDataset.EmptyDataSet;
  FOFRTYPCARTEFID.ClientDataset.EmptyDataSet;

  FOFRETEVERIF.ClientDataset.EmptyDataSet;
  FOFRMAGASINLOAD.ClientDataset.EmptyDataSet;
  FOFRIMPBRLOAD.ClientDataset.EmptyDataSet;
  FOFRLIGNEBRLOAD.ClientDataset.EmptyDataSet;
  FOFRPERIMETRELOAd.ClientDataset.EmptyDataSet;
  FOFRTYPCARTEFIDLOAD.ClientDataset.EmptyDataSet;
  FGENTYPCARTEFIDLOAD.ClientDataset.EmptyDataSet;
  FOFRETEVERIF.ClientDataset.EmptyDataSet;
end;

procedure TIntegration.ClearFcds;
begin
  FOFRTETE.ClientDataset.EmptyDataSet;
  FOFRMAGASIN.ClientDataset.EmptyDataSet;
  FOFRIMPBR.ClientDataset.EmptyDataSet;
  FOFRLIGNEBR.ClientDataset.EmptyDataSet;
  FOFRPERIMETRE.ClientDataset.EmptyDataSet;
  FOFRTYPCARTEFID.ClientDataset.EmptyDataSet;
  FOFRETEVERIF.ClientDataset.EmptyDataSet;
end;

procedure TIntegration.ClearFcdsLoad;
begin
  //Procedure qui nettoie les Fcds..Load
  FOFRMAGASINLOAD.ClientDataset.EmptyDataSet;
  FOFRIMPBRLOAD.ClientDataset.EmptyDataSet;
  FOFRLIGNEBRLOAD.ClientDataset.EmptyDataSet;
  FOFRPERIMETRELOAd.ClientDataset.EmptyDataSet;
  FOFRTYPCARTEFIDLOAD.ClientDataset.EmptyDataSet;
  FGENTYPCARTEFIDLOAD.ClientDataset.EmptyDataSet;
end;

constructor TIntegration.Create;
begin
  inherited;

  FOFRTETE           := TMainClass.Create;
  FOFRMAGASIN        := TMainClass.Create;
  FOFRIMPBR          := TMainClass.Create;
  FOFRLIGNEBR        := TMainClass.Create;
  FOFRPERIMETRE      := TMainClass.Create;
  FOFRTYPCARTEFID    := TMainClass.Create;

  FOFRTETEINIT       := TMainClass.Create;
  FOFRETEVERIF       := TMainClass.Create;
  FOFRMAGASINLOAD    := TMainClass.Create;
  FOFRIMPBRLOAD      := TMainClass.Create;
  FOFRLIGNEBRLOAD    := TMainClass.Create;
  FOFRPERIMETRELOAd  := TMainClass.Create;
  FOFRTYPCARTEFIDLOAD:= TMainClass.Create;
  FGENTYPCARTEFIDLOAD:= TMainClass.Create;

  FFournTemp         := TMainClass.Create;

  Ds_Ofrtete         := TDataSource.Create(nil);
  Ds_Ofrtete.DataSet := FOFRTETE.ClientDataset;

  NbOffreImport      := 0;
  NbOffreDoMaj       := 0;
end;

procedure TIntegration.CreateCds;
begin
  //Procédure servant à la création des clientDatasets

  //OFRTETE
  FOFRTETE.CreateField(['OFE_CHRONO', 'OFE_NOM', 'OFE_CODECENTRAL', 'OFE_TYPE', 'OFE_ACTIF',
                       'OFE_CUMUL', 'OFE_CENTRALE', 'OFE_DATE', 'OFE_CODTVALDEB', 'OFE_CODTVALFIN',
                       'OFE_COPERM', 'OFE_COOPTYPDEC', 'OFE_COOPCB', 'OFE_COBRPREFIXE', 'OFE_COBRLGVAL',
                       'OFE_COBRLGDEC', 'OFE_COCLTTYP', 'OFE_COCLTFID', 'OFE_COCLTCLA', 'OFE_COPALIERFID',
                       'OFE_COTYPVTEN', 'OFE_COTYPVTES', 'OFE_COTYPVTEP', 'OFE_COREMMAX', 'OFE_COMINPAN',
                       'OFE_COMAXPAN', 'OFE_COPERIMPAN', 'OFE_COMINART', 'OFE_COMAXART', 'OFE_COPERIMART',
                       'OFE_COPERIM', 'OFE_COMODCONTRAC', 'OFE_COMODCOMPLE', 'OFE_CACLTPERIM',
                       'OFE_CATYPVTEN', 'OFE_CATYPVTES', 'OFE_CATYPVTEP', 'OFE_CAREMMAX', 'OFE_CAPXMIN',
                       'OFE_CAMINPAN', 'OFE_CAMAXPAN', 'OFE_CAPERIMPAN', 'OFE_CAMINART', 'OFE_CAMAXART',
                       'OFE_CAPERIMART', 'OFE_CAPERIM', 'OFE_CAMODCONTRAC', 'OFE_CAMODCOMPLE',
                       'OFE_AVTYPLIGNE', 'OFE_AVVALX', 'OFE_AVTYPREM', 'OFE_AVVAL1', 'OFE_AVVAL2',
//JB Ajout OFE_MARGECENTRALE
                       'OFE_AVVAL3', 'OFE_AVVAL4', 'OFE_AVVAL5', 'OFE_MARGECENTRALE'],
                      [ftString, ftString, ftString, ftInteger, ftInteger, ftInteger, ftInteger,
                       ftDateTime, ftDateTime, ftDateTime, ftInteger, ftInteger, ftString, ftString,
                       ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger,
                       ftInteger, ftFloat, ftFloat, ftFloat, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger,
                       ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftFloat, ftInteger, ftFloat,
                       ftFloat, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger,
                       ftInteger, ftInteger, ftFloat, ftFloat, ftFloat, ftFloat, ftFloat,ftInteger]);
  FOFRTETE.ClientDataset.AddIndex('Idx','OFE_CHRONO',[]);
  FOFRTETE.ClientDataset.IndexName := 'Idx';

  FOFRETEVERIF.CreateField(['OFE_CHRONO'], [ftString]);
  FOFRETEVERIF.ClientDataset.AddIndex('Idx','OFE_CHRONO',[]);
  FOFRETEVERIF.ClientDataset.IndexName := 'Idx';

  //OFRMAGASIN
  FOFRMAGASIN.CreateField(['OFM_OFECHRONO', 'OFM_FOUCODE', 'OFM_FOUNOM', 'OFM_FOUID'], [ftString, ftString, ftString, ftInteger]);
  FOFRMAGASIN.ClientDataset.AddIndex('Idx','OFM_OFECHRONO',[]);
  FOFRMAGASIN.ClientDataset.IndexName    := 'Idx';
  FOFRMAGASIN.ClientDataset.MasterSource := Ds_Ofrtete;
  FOFRMAGASIN.ClientDataset.MasterFields := 'OFE_CHRONO';

  FOFRMAGASINLOAD.CreateField(['OFM_ID', 'CANDELETE'], [ftInteger, ftInteger]);
  FOFRMAGASINLOAD.ClientDataset.AddIndex('Idx','OFM_ID', []);
  FOFRMAGASINLOAD.ClientDataset.IndexName := 'Idx';

  //OFRIMPBR
  FOFRIMPBR.CreateField(['OFI_OFECHRONO', 'OFI_TYPLIGNE', 'OFI_NUMLIGNE', 'OFI_DATA'], [ftString, ftInteger, ftInteger, ftString]);
  FOFRIMPBR.ClientDataset.AddIndex('Idx', 'OFI_OFECHRONO', []);
  FOFRIMPBR.ClientDataset.IndexName       := 'Idx';
  FOFRIMPBR.ClientDataset.MasterSource    := Ds_Ofrtete;
  FOFRIMPBR.ClientDataset.MasterFields    := 'OFE_CHRONO';

  FOFRIMPBRLOAD.CreateField(['OFI_ID', 'CANDELETE'], [ftInteger, ftInteger]);
  FOFRIMPBRLOAD.ClientDataset.AddIndex('Idx', 'OFI_ID', []);
  FOFRIMPBRLOAD.ClientDataset.IndexName := 'Idx';

  //OFRLIGNEBR
  FOFRLIGNEBR.CreateField(['OFL_OFECHRONO', 'OFL_DTUTILDEB', 'OFL_DTUTILFIN', 'OFL_REPART'], [ftString, ftDateTime, ftDateTime, ftInteger]);
  FOFRLIGNEBR.ClientDataset.AddIndex('Idx', 'OFL_OFECHRONO', []);
  FOFRLIGNEBR.ClientDataset.IndexName     := 'Idx';
  FOFRLIGNEBR.ClientDataset.MasterSource  := Ds_Ofrtete;
  FOFRLIGNEBR.ClientDataset.MasterFields  := 'OFE_CHRONO';

  FOFRLIGNEBRLOAD.CreateField(['OFL_ID', 'CANDELETE'], [ftInteger, ftInteger]);
  FOFRLIGNEBRLOAD.ClientDataset.AddIndex('Idx', 'OFL_ID', []);
  FOFRLIGNEBRLOAD.ClientDataset.IndexName := 'Idx';

  //OFRPERIMETRE
  FOFRPERIMETRE.CreateField(['OFP_OFECHRONO', 'OFP_TYPPERIM', 'OFP_TYPDATA', 'OFP_LIGNEID', 'OFP_INCLUEXCLU'], [ftString, ftInteger, ftInteger, ftInteger, ftInteger]);
  FOFRPERIMETRE.ClientDataset.AddIndex('Idx', 'OFP_OFECHRONO', []);
  FOFRPERIMETRE.ClientDataset.IndexName    := 'Idx';
  FOFRPERIMETRE.ClientDataset.MasterSource := Ds_Ofrtete;
  FOFRPERIMETRE.ClientDataset.MasterFields := 'OFE_CHRONO';


  FOFRPERIMETRELOAd.CreateField(['OFP_ID', 'CANDELETE'], [ftInteger, ftInteger]);
  FOFRPERIMETRELOAd.ClientDataset.AddIndex('Idx', 'OFP_ID', []);
  FOFRPERIMETRELOAd.ClientDataset.IndexName := 'Idx';


  {$REGION 'FOFRTYPCARTEFID'}
  FOFRTYPCARTEFID.CreateField(['TCF_OFECHRONO', 'TCF_TYPE', 'TCF_CENTRALE'], [ftString, ftInteger, ftInteger]);
  FOFRTYPCARTEFID.ClientDataset.AddIndex('Idx', 'TCF_OFECHRONO', []);
  FOFRTYPCARTEFID.ClientDataset.IndexName    := 'Idx';
  FOFRTYPCARTEFID.ClientDataset.MasterSource := Ds_Ofrtete;
  FOFRTYPCARTEFID.ClientDataset.MasterFields := 'OFE_CHRONO';

  FOFRTYPCARTEFIDLOAD.CreateField(['OFF_ID', 'CANDELETE'], [ftInteger, ftInteger]);
  FOFRTYPCARTEFIDLOAD.ClientDataset.AddIndex('Idx', 'OFF_ID', []);
  FOFRTYPCARTEFIDLOAD.ClientDataset.IndexName := 'Idx';

  FGENTYPCARTEFIDLOAD.CreateField(['TCF_ID', 'TCF_TYPE', 'TCF_CENTRALE'], [ftInteger, ftInteger, ftInteger]);
  FGENTYPCARTEFIDLOAD.ClientDataset.AddIndex('Idx', 'TCF_ID', []);
  FOFRTYPCARTEFIDLOAD.ClientDataset.IndexName := 'Idx';
  {$ENDREGION}

  //OFRTETEINIT     /* Utiliser lors du mode initialisation */
  FOFRTETEINIT.CreateField(['OFE_CHRONO'], [ftString]);
  FOFRTETEINIT.ClientDataset.AddIndex('Idx', 'OFE_CHRONO', []);
  FOFRTETEINIT.ClientDataset.IndexName := 'Idx';
end;

procedure TIntegration.DelID(ID: Integer);
begin
  with FIboQuery do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,1)');
      ParamCheck := True;
      ParamByName('ID').AsInteger := ID;
      ExecSQL;

    Except on e: Exception do
      begin
        raise Exception.Create('Delvaleur -> '+e.Message);
      end;
    end;
  end;
end;

procedure TIntegration.DesactiveMaitreDetail;
begin
  with Dm_GSDataExtract do
  begin
    //cds_OFRMAGASIN
    cds_OFRMAGASIN.MasterSource   := Nil;
    cds_OFRMAGASIN.MasterFields   := '';

    //cds_OFRIMPBR
    cds_OFRIMPBR.MasterSource     := Nil;
    cds_OFRIMPBR.MasterFields     := '';

    //cds_OFRLIGNEBR
    cds_OFRLIGNEBR.MasterSource   := Nil;
    cds_OFRLIGNEBR.MasterFields   := '';

    //cds_OFRPERIMETRE
    cds_OFRPERIMETRE.MasterSource := Nil;
    cds_OFRPERIMETRE.MasterFields := '';

    //cds_GENTYPCARTEFID
    cds_OFRTYPCARTEFID.MasterSource := Nil;
    cds_OFRTYPCARTEFID.MasterFields := '';
  end;
end;

destructor TIntegration.Destroy;
begin
  FOFRTETE.Free;
  FOFRMAGASIN.Free;
  FOFRIMPBR.Free;
  FOFRLIGNEBR.Free;
  FOFRPERIMETRE.Free;
  FOFRTYPCARTEFID.Free;

  FOFRTETEINIT.Free;
  FOFRETEVERIF.Free;
  FOFRMAGASINLOAD.Free;
  FOFRIMPBRLOAD.Free;
  FOFRLIGNEBRLOAD.Free;
  FOFRPERIMETRELOAd.Free;
  FOFRTYPCARTEFIDLOAD.Free;
  FGENTYPCARTEFIDLOAD.Free;

  FFournTemp.Free;

  Ds_Ofrtete.Free;

  NbOffreImport := 0;
  inherited;
end;

function TIntegration.DoMajTable: Boolean;
var
  OFRTETERECORD                            :  TOFRTETE;
  OFEID, OFMID, OFLID, OFIID, OFPID, OFFID, TCFID :  Integer;
begin
  //Procedure DoMajTable

  FOFRTETE.ClientDataset.First;

  while not FOFRTETE.ClientDataset.Eof do
  begin
    try
      ClearFcdsLoad;

      OkAutreFic := True;

      if not FIboQuery.IB_Transaction.Started then
        FIboQuery.IB_Transaction.StartTransaction;
      //ShowMessage(FIboQuery.IB_Connection.DatabaseName);

      {$REGION 'Partie OFRTETE'}
      OFEID := SetOFRTETE(OFRTETERECORD, ModeInitialisation);

      //Si OFEID égale à 0 on passe à la ligne suivante
      if OFEID = 0 then
      begin
        FOFRTETE.ClientDataset.Next;
        Continue;
      end;

      //Je traite ou non les autres fichiers
      if ModeInitialisation then
      begin
        if OkAutreFic = False then
        begin
          FOFRTETE.ClientDataset.Next;
          Continue;
        end;
      end;
      {$ENDREGION}

      {$REGION 'Récupération des offres en base client'}
      //RempliFcdsMag(FOFRMAGASIN.ClientDataset, FOFRETEVERIF.ClientDataset);
      LoadFCdsLoad('OFRMAGASIN', 'OFM', '', FOFRMAGASINLOAD.ClientDataset, OFEID);
      LoadFCdsLoad('OFRIMPBR', 'OFI', '', FOFRIMPBRLOAD.ClientDataset, OFEID);
      LoadFCdsLoad('OFRLIGNEBR', 'OFL', '', FOFRLIGNEBRLOAD.ClientDataset, OFEID);
      LoadFCdsLoad('OFRPERIMETRE', 'OFP', '', FOFRPERIMETRELOAd.ClientDataset, OFEID);
      LoadFCdsLoad('OFRTYPCARTEFID', 'OFF', '', FOFRTYPCARTEFIDLOAD.ClientDataset, OFEID);
      RempliFcdsTypCarteFidLoad(FGENTYPCARTEFIDLOAD.ClientDataset);
      {$ENDREGION}

      {$REGION 'Partie OFRMAGASIN'}
      FOFRMAGASIN.First;
      while not FOFRMAGASIN.EOF do
      begin
        OFMID := SetOFRMAGASIN(OFEID, FOFRMAGASIN.ClientDataset.FieldByName('OFM_FOUID').AsInteger);

        if FOFRMAGASINLOAD.ClientDataset.Locate('OFM_ID', OFMID, []) then
        begin
          FOFRMAGASINLOAD.Edit;
          FOFRMAGASINLOAD.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
          FOFRMAGASINLOAD.Post;
        end else
        begin
          FOFRMAGASINLOAD.Append;
          FOFRMAGASINLOAD.ClientDataset.FieldByName('OFM_ID').AsInteger    := OFMID;
          FOFRMAGASINLOAD.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
          FOFRMAGASINLOAD.Post;
        end;

        FOFRMAGASIN.ClientDataset.Next;
      end;
      {$ENDREGION}

      {$REGION 'Partie OFRLIGNEBR'}
      FOFRLIGNEBR.First;

      while not FOFRLIGNEBR.EOF do
      begin
        OFLID := SetOFRLIGNEBR(OFEID, FOFRLIGNEBR.ClientDataset.FieldByName('OFL_REPART').AsInteger,
                               FOFRLIGNEBR.ClientDataset.FieldByName('OFL_DTUTILDEB').AsDateTime,
                               FOFRLIGNEBR.ClientDataset.FieldByName('OFL_DTUTILFIN').AsDateTime);

        if FOFRLIGNEBRLOAD.ClientDataset.Locate('OFL_ID', OFLID, []) then
        begin
          FOFRLIGNEBRLOAD.Edit;
          FOFRLIGNEBRLOAD.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
          FOFRLIGNEBRLOAD.Post;
        end else
        begin
          FOFRLIGNEBRLOAD.Append;
          FOFRLIGNEBRLOAD.ClientDataset.FieldByName('OFL_ID').AsInteger    := OFLID;
          FOFRLIGNEBRLOAD.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
          FOFRLIGNEBRLOAD.Post;
        end;
        FOFRLIGNEBR.Next;
      end;
      {$ENDREGION}

      {$REGION 'Partie OFRIMPBR'}
      FOFRIMPBR.First;

      while not FOFRIMPBR.EOF do
      begin
        OFIID := SetOFRIMPBR(OFEID, FOFRIMPBR.ClientDataset.FieldByName('OFI_TYPLIGNE').AsInteger,
                            FOFRIMPBR.ClientDataset.FieldByName('OFI_NUMLIGNE').AsInteger,
                            FOFRIMPBR.ClientDataset.FieldByName('OFI_DATA').AsString);

        if FOFRIMPBRLOAD.ClientDataset.Locate('OFI_ID', OFIID, []) then
        begin
          FOFRIMPBRLOAD.Edit;
          FOFRIMPBRLOAD.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
          FOFRIMPBRLOAD.Post;
        end else
        begin
          FOFRIMPBRLOAD.Append;
          FOFRIMPBRLOAD.ClientDataset.FieldByName('OFI_ID').AsInteger    := OFIID;
          FOFRIMPBRLOAD.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
          FOFRIMPBRLOAD.Post;
        end;
        FOFRIMPBR.Next;
      end;

      {$ENDREGION}

      {$REGION 'Partie OFRPERIMETRE'}
      FOFRPERIMETRE.First;

      while not FOFRPERIMETRE.EOF do
      begin
        OFPID := SetOFRPERIMETRE(OFEID, FOFRPERIMETRE.ClientDataset.FieldByName('OFP_TYPPERIM').AsInteger,
                                 FOFRPERIMETRE.ClientDataset.FieldByName('OFP_TYPDATA').AsInteger,
                                 FOFRPERIMETRE.ClientDataset.FieldByName('OFP_LIGNEID').AsInteger,
                                 FOFRPERIMETRE.ClientDataset.FieldByName('OFP_INCLUEXCLU').AsInteger);

        if FOFRPERIMETRELOAd.ClientDataset.Locate('OFP_ID', OFPID, []) then
        begin
          FOFRPERIMETRELOAd.Edit;
          FOFRPERIMETRELOAd.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
          FOFRPERIMETRELOAd.Post;
        end else
        begin
          FOFRPERIMETRELOAd.Append;
          FOFRPERIMETRELOAd.ClientDataset.FieldByName('OFP_ID').AsInteger    := OFPID;
          FOFRPERIMETRELOAd.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
          FOFRPERIMETRELOAd.Post;
        end;
        FOFRPERIMETRE.Next;
      end;
      {$ENDREGION}

      {$REGION 'Partie OFRTYPCARTEFID'}
      FOFRTYPCARTEFID.First;

      while not FOFRTYPCARTEFID.EOF do
      begin
        OFFID := SetOFRTYPCARTEFID(OFEID,
          FOFRTYPCARTEFID.ClientDataset.FieldByName('TCF_TYPE').AsInteger,
          FOFRTYPCARTEFID.ClientDataset.FieldByName('TCF_CENTRALE').AsInteger
        );
        if FOFRTYPCARTEFIDLOAD.ClientDataset.Locate('OFF_ID', OFFID, []) then
        begin
          FOFRTYPCARTEFIDLOAD.Edit;
        end
        else
        begin
          FOFRTYPCARTEFIDLOAD.Append;
          FOFRTYPCARTEFIDLOAD.ClientDataset.FieldByName('OFF_ID').AsInteger := OFFID;
        end;
        FOFRTYPCARTEFIDLOAD.ClientDataset.FieldByName('CANDELETE').AsInteger := 0;
        FOFRTYPCARTEFIDLOAD.Post;

        FOFRTYPCARTEFID.Next;
      end;
      {$ENDREGION}

      FIboQuery.IB_Transaction.Commit;

      {$REGION 'Nettoyage FOFR..LOAD'}
      if not FIboQuery.IB_Transaction.Started then
        FIboQuery.IB_Transaction.StartTransaction;

      {$REGION 'FOFRMAGASINLAOD'}
      with FOFRMAGASINLOAD do
      begin
        FiltreCds(FOFRMAGASINLOAD.ClientDataset, 'CANDELETE', 1);
        First;

        while not EOF do
        begin
          DelID(FieldByName('OFM_ID').AsInteger);
          Next;
        end;
      end;
      {$ENDREGION}

      {$REGION 'FOFRMIMPLAOD'}
      with FOFRIMPBRLOAD do
      begin
        FiltreCds(FOFRIMPBRLOAD.ClientDataset, 'CANDELETE', 1);
        First;

        while not EOF do
        begin
          DelID(FieldByName('OFI_ID').AsInteger);
          Next;
        end;
      end;
      {$ENDREGION}

      {$REGION 'FOFRLIGNELAOD'}
      with FOFRLIGNEBRLOAD do
      begin
        FiltreCds(FOFRLIGNEBRLOAD.ClientDataset, 'CANDELETE', 1);
        First;

        while not EOF do
        begin
          DelID(FieldByName('OFL_ID').AsInteger);
          Next;
        end;
      end;
      {$ENDREGION}

      {$REGION 'FOFRPERIMETRELAOD'}
      with FOFRPERIMETRELOAd do
      begin
        FiltreCds(FOFRPERIMETRELOAd.ClientDataset, 'CANDELETE', 1);
        First;

        while not EOF do
        begin
          DelID(FieldByName('OFP_ID').AsInteger);
          Next;
        end;
      end;
      {$ENDREGION}

      {$REGION 'FOFRTYPCARTEFIDLOAD'}
      FiltreCds(FOFRTYPCARTEFIDLOAD.ClientDataset, 'CANDELETE', 1);
      FOFRTYPCARTEFIDLOAD.First;
      while not FOFRTYPCARTEFIDLOAD.EOF do
      begin
        DelID(FOFRTYPCARTEFIDLOAD.FieldByName('OFF_ID').AsInteger);
        FOFRTYPCARTEFIDLOAD.Next;
      end;
      {$ENDREGION}

      FIboQuery.IB_Transaction.Commit
      {$ENDREGION}

    except on e:Exception do
      begin
        FIboQuery.IB_Transaction.Rollback;
        raise Exception.Create(e.Message);
      end;
    end;

    FOFRTETE.ClientDataset.Next;
  end;

  {$REGION 'Traitement FOFRTETEVERIF'}
  if FOFRETEVERIF.ClientDataset.RecordCount > 0 then
  begin
    if not FIboQuery.IB_Transaction.Started then
        FIboQuery.IB_Transaction.StartTransaction;
    try
      with FIboQuery do
      begin
        //Parcours puis traitement des lignes de FOFRTETEVERIF
        FOFRETEVERIF.First;

        while not FOFRETEVERIF.EOF do
        begin
          Close;
          SQL.Clear;
          SQL.Add('EXECUTE PROCEDURE GOS_SETDESACTIVEOFFRE(:OFECHRONO)');
          ParamCheck := True;
          ParamByName('OFECHRONO').AsString := FOFRETEVERIF.FieldByName('OFE_CHRONO').AsString;
          ExecSQL;

          FOFRETEVERIF.Next;
        end;
        FIboQuery.IB_Transaction.Commit;
    end;
    Except on e: Exception do
      begin
        FIboQuery.IB_Transaction.Rollback;
        raise Exception.Create('GOS_SETDESACTIVEOFFRE -> '+e.Message);
      end;
    end;
  end;
  {$ENDREGION}

end;

function TIntegration.FiltreCds(Cds: TClientDataSet; Field: String; Valeur: Integer): Boolean;
begin
  Cds.Filtered := False;
  Cds.Filter   := Field + ' = ' + IntToStr(Valeur);
  Cds.Filtered := True;

  Cds.First;
end;

function TIntegration.GetLigneID(TypeData: Integer; Code, Nom: String): Integer;
var
  Table, prefix : string;
begin
  //Function qui permet d'avoir le LIGNEID pour OFRPERIMETRE
  Result := -1;

  case TypeData of
    0 : begin
        Table  := 'ARTARTICLE';
        prefix := 'ART';
    end;
    1 : begin
        Table  := 'NKLSSFAMILLE';
        prefix := 'SSF';
    end;
    2 : begin
        Table  := 'ARTMARQUE';
        prefix := 'MRK';
    end;
    3 : begin
        Table  := 'ARTGENRE';
        prefix := 'GRE';
    end;
    4 : begin
        Table  := 'ARTCOLLECTION';
        prefix := 'COL';
    end;
  end;
    
  with FIboQuery do
  begin
    Close;
    SQL.Clear;

    try
      SQL.Add('SELECT '+prefix+'_ID AS ID');
      SQL.Add('FROM '+Table);
      SQL.Add(' JOIN K ON K_ID = '+prefix+'_ID AND K_ENABLED = 1 ');
      SQL.Add(' WHERE '+prefix+'_CODE = :CODE AND '+prefix+'_NOM = :NOM');
      ParamCheck := True;
      ParamByName('CODE').AsString := Code;
      ParamByName('NOM').AsString  := Nom;

      Open;

      Result := FieldByName('ID').AsInteger;
    Except on e: Exception do
      begin
        raise Exception.Create(e.Message);
      end;
    end;
    
  end;
end;

function TIntegration.LoadFCdsLoad(ATable, APrefix, AMFix: String; ACdsLoad: TClientDataSet; AOFEID : Integer) : Boolean;
Var
  i, iFieldIndex, iFieldCAN : Integer;
begin
  //Procedure qui remplira les FOFOR...LOAD avec les valeurs existantes dans la base
  with FIboQuery do
  begin
    Close;
    ACdsLoad.EmptyDataSet;
    SQL.Clear;

    try
      SQL.Add('SELECT '+APrefix+'_ID AS ID ');
      SQL.Add('FROM '+ATable);
      SQL.Add('JOIN K ON K_ID = '+APrefix+'_ID AND K_ENABLED = 1');
      SQL.Add('WHERE '+APrefix+'_ID <> 0 AND '+APrefix+'_OFEID = :OFEID');
      ParamCheck := True;
      ParamByName('OFEID').AsInteger := AOFEID;

      Open;

      while not Eof do
      begin
        ACdsLoad.Append;
        ACdsLoad.FieldByName(APrefix+'_ID').AsInteger := FieldByName('ID').AsInteger;
        ACdsLoad.FieldByName('CANDELETE').AsInteger   := 1;
        ACdsLoad.Post;
        Next;
      end;

    except on e : Exception do
      begin
        raise Exception.Create(e.Message);
      end;
    end;
  end;
end;

procedure TIntegration.LoadOFRTETERecord(AOFRTETE : TOFRTETE);
begin
  //Procedure qui rempli le OFRTETERecord
  with AOFRTETE do
  begin
    OFE_CHRONO       := FOFRTETE.ClientDataset.FieldByName('OFE_CHRONO').AsString;
    OFE_NOM          := FOFRTETE.ClientDataset.FieldByName('OFE_NOM').AsString;
    OFE_CODECENTRAL  := FOFRTETE.ClientDataset.FieldByName('OFE_CODECENTRAL').AsInteger;
    OFE_TYPE         := FOFRTETE.ClientDataset.FieldByName('OFE_TYPE').AsInteger;
    OFE_ACTIF        := FOFRTETE.ClientDataset.FieldByName('OFE_ACTIF').AsInteger;
    OFE_CUMUL        := FOFRTETE.ClientDataset.FieldByName('OFE_CUMUL').AsInteger;
    OFE_CENTRALE     := FOFRTETE.ClientDataset.FieldByName('OFE_CENTRALE').AsInteger;
    OFE_DATE         := FOFRTETE.ClientDataset.FieldByName('OFE_DATE').AsDateTime;
    OFE_CODTVALDEB   := FOFRTETE.ClientDataset.FieldByName('OFE_CODTVALDEB').AsDateTime;
    OFE_CODTVALFIN   := FOFRTETE.ClientDataset.FieldByName('OFE_CODTVALFIN').AsDateTime;
    OFE_COPERM       := FOFRTETE.ClientDataset.FieldByName('OFE_COPERM').AsInteger;
    OFE_COOPTYPDEC   := FOFRTETE.ClientDataset.FieldByName('OFE_COOPTYPDEC').AsInteger;
    OFE_COOPCB       := FOFRTETE.ClientDataset.FieldByName('OFE_COOPCB').AsString;
    OFE_COBRPREFIXE  := FOFRTETE.ClientDataset.FieldByName('OFE_COBRPREFIXE').AsString;
    OFE_COBRLGVAL    := FOFRTETE.ClientDataset.FieldByName('OFE_COBRLGVAL').AsInteger;
    OFE_COBRLGDEC    := FOFRTETE.ClientDataset.FieldByName('OFE_COBRLGDEC').AsInteger;
    OFE_COCLTTYP     := FOFRTETE.ClientDataset.FieldByName('OFE_COCLTTYP').AsInteger;
    OFE_COCLTFID     := FOFRTETE.ClientDataset.FieldByName('OFE_COCLTFID').AsInteger;
    OFE_COCLTCLA     := FOFRTETE.ClientDataset.FieldByName('OFE_COCLTCLA').AsInteger;
    OFE_COPALIERFID  := FOFRTETE.ClientDataset.FieldByName('OFE_COPALIERFID').AsInteger;
    OFE_COTYPVTEN    := FOFRTETE.ClientDataset.FieldByName('OFE_COTYPVTEN').AsInteger;
    OFE_COTYPVTES    := FOFRTETE.ClientDataset.FieldByName('OFE_COTYPVTES').AsInteger;
    OFE_COTYPVTEP    := FOFRTETE.ClientDataset.FieldByName('OFE_COTYPVTEP').AsInteger;
    OFE_COREMMAX     := FOFRTETE.ClientDataset.FieldByName('OFE_COREMMAX').AsFloat;
    OFE_COMINPAN     := FOFRTETE.ClientDataset.FieldByName('OFE_COMINPAN').AsFloat;
    OFE_COMAXPAN     := FOFRTETE.ClientDataset.FieldByName('OFE_COMAXPAN').AsInteger;
    OFE_COPERIMPAN   := FOFRTETE.ClientDataset.FieldByName('OFE_COPERIMPAN').AsInteger;
    OFE_COMINART     := FOFRTETE.ClientDataset.FieldByName('OFE_COMINART').AsInteger;
    OFE_COMAXART     := FOFRTETE.ClientDataset.FieldByName('OFE_COMAXART').AsInteger;
    OFE_COPERIMART   := FOFRTETE.ClientDataset.FieldByName('OFE_COPERIMART').AsInteger;
    OFE_COPERIM      := FOFRTETE.ClientDataset.FieldByName('OFE_COPERIM').AsInteger;
    OFE_COMODCONTRAC := FOFRTETE.ClientDataset.FieldByName('OFE_COMODCONTRAC').AsInteger;
    OFE_COMODCOMPLE  := FOFRTETE.ClientDataset.FieldByName('OFE_COMODCOMPLE').AsInteger;
    OFE_CACLTPERIM   := FOFRTETE.ClientDataset.FieldByName('OFE_CACLTPERIM').AsInteger;
    OFE_CATYPVTEN    := FOFRTETE.ClientDataset.FieldByName('OFE_CATYPVTEN').AsInteger;
    OFE_CATYPVTES    := FOFRTETE.ClientDataset.FieldByName('OFE_CATYPVTES').AsInteger;
    OFE_CATYPVTEP    := FOFRTETE.ClientDataset.FieldByName('OFE_CATYPVTEP').AsInteger;
    OFE_CAREMMAX     := FOFRTETE.ClientDataset.FieldByName('OFE_CAREMMAX').AsFloat;
    OFE_CAPXMIN      := FOFRTETE.ClientDataset.FieldByName('OFE_CAPXMIN').AsInteger;
    OFE_CAMINPAN     := FOFRTETE.ClientDataset.FieldByName('OFE_CAMINPAN').AsFloat;
    OFE_CAMAXPAN     := FOFRTETE.ClientDataset.FieldByName('OFE_CAMAXPAN').AsFloat;
    OFE_CAPERIMPAN   := FOFRTETE.ClientDataset.FieldByName('OFE_CAPERIMPAN').AsInteger;
    OFE_CAMINART     := FOFRTETE.ClientDataset.FieldByName('OFE_CAMINART').AsInteger;
    OFE_CAMAXART     := FOFRTETE.ClientDataset.FieldByName('OFE_CAMAXART').AsInteger;
    OFE_CAPERIMART   := FOFRTETE.ClientDataset.FieldByName('OFE_CAPERIMART').AsInteger;
    OFE_CAPERIM      := FOFRTETE.ClientDataset.FieldByName('OFE_CAPERIM').AsInteger;
    OFE_CAMODCONTRAC := FOFRTETE.ClientDataset.FieldByName('OFE_CAMODCONTRAC').AsInteger;
    OFE_CAMODCOMPLE  := FOFRTETE.ClientDataset.FieldByName('OFE_CAMODCOMPLE').AsInteger;
    OFE_AVTYPLIGNE   := FOFRTETE.ClientDataset.FieldByName('OFE_AVTYPLIGNE').AsInteger;
    OFE_AVVALX       := FOFRTETE.ClientDataset.FieldByName('OFE_AVVALX').AsInteger;
    OFE_AVTYPREM     := FOFRTETE.ClientDataset.FieldByName('OFE_AVTYPREM').AsInteger;
    OFE_AVVAL1       := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL1').AsFloat;
    OFE_AVVAL2       := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL2').AsFloat;
    OFE_AVVAL3       := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL3').AsFloat;
    OFE_AVVAL4       := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL4').AsFloat;
    OFE_AVVAL5       := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL5').AsFloat;
//JB Ajout OFE_MARGECENTRALE
    OFE_MARGECENTRALE:= FOFRTETE.ClientDataset.FieldByName('OFE_MARGECENTRALE').AsInteger;
  end;
end;

procedure TIntegration.Import;
var
  OFE_CHRONO: string; {DONE -oJO : Modification de la clé: OFE_CODECENTRAL -> OFE_CHRONO (2016-04-07)}
begin
  //Procedure d'import d'offre
  with Dm_GSDataExtract do
  begin
     ClearFcds;

    //Parcours du cds_OFRTETE
    //Active Maitre-détail
    ActiveMaitreDetail;

    cds_OFRTETE.First;

    while not cds_OFRTETE.Eof do
    begin
      OFE_CHRONO := cds_OFRTETEOFE_CHRONO.AsString;

      {$REGION 'Rempli FOFRTETE et FOFRMAGASIN'}
      RempliFOFRMAGetTETE(cds_OFRTETE, cds_OFRMAGASIN, FOFRTETE.ClientDataset, FOFRMAGASIN.ClientDataset, FOFRETEVERIF.ClientDataset);
      {$ENDREGION}

      {$REGION 'Rempli FOFRIMPBR'}
      RemplirFcds(cds_OFRIMPBR, FOFRIMPBR.ClientDataset);
      {$ENDREGION}

      {$REGION 'Rempli FOFRLIGNEBR'}
      RemplirFcds(cds_OFRLIGNEBR, FOFRLIGNEBR.ClientDataset);
      {$ENDREGION}

      {$REGION 'Rempli FOFRPERIMETRE'}
      RemplirFcdsPerimetre(cds_OFRPERIMETRE, FOFRPERIMETRE.ClientDataset);
      {$ENDREGION}

      {$REGION 'Rempli FOFRTYPCARTEFID'}
      RemplirFcds(cds_OFRTYPCARTEFID, FOFRTYPCARTEFID.ClientDataset);
      {$ENDREGION}

      cds_OFRTETE.Next;
    end;

    //Désactive Maitre-détail
    DesactiveMaitreDetail;
  end;

end;

function TIntegration.MagExist(FouCode : String): Integer;
begin
 //
 Result := -1;

 FIboQuery.Close;
 FIboQuery.SQL.Clear;
 //FIboQuery.IB_Transaction.StartTransaction;

 try

  FIboQuery.SQL.Add(' SELECT *  ');
  FIboQuery.SQL.Add(' FROM GENMAGASIN ');
  FIboQuery.SQL.Add(' JOIN K ON K_ID = MAG_ID AND K_ENABLED = 1 ');
  FIboQuery.SQL.Add(' WHERE MAG_CODEADH = :FOUCODE ');
  FIboQuery.ParamCheck := True;
  FIboQuery.ParamByName('FOUCODE').AsString := FouCode;
  FIboQuery.Open;

  if FIboQuery.RecordCount <> 0 then
     Result := FIboQuery.FieldByName('MAG_ID').AsInteger;

 except on e : Exception do
  begin
    raise Exception.Create(e.Message);
  end;
 end;

end;

function TIntegration.RempliFcdsMag(Cds, FCds: TClientDataSet): Boolean;
var
  i, FieldIndex, MagIDIndex, MagID : Integer;
  FOUNOM, FOUCODE                  : String;
begin
  //Rempli le FOFRMAGASIN
  try
    while not Cds.Eof do
    begin
      I      := 0;
      FOUNOM := Cds.Fields[2].AsString;
      FOUCODE:= Cds.Fields[1].AsString;

      //Validatation si le magasin existe dans la base
      MagID := MagExist(FOUCODE);
      if MagID <> -1 then
      begin
        FCds.Append;
        MagIDIndex := FCds.FieldList.IndexOf('OFM_FOUID');
        FCds.FieldList.Fields[MagIDIndex].Value := MagID;
        FCds.Post;
      end;
      Cds.Next;
    end;
  except on e : Exception do
  begin
    raise Exception.Create('Chargement des données en mémoire ->' + E.Message);
  end;
  end;
end;

procedure TIntegration.RempliFcdsTypCarteFidLoad(ACdsLoad: TClientDataSet);
begin
  FIboQuery.Close;
  try
    ACdsLoad.EmptyDataSet;
    FIboQuery.SQL.Text := 'select * ' +
                         'from GENTYPCARTEFID ' +
                         'join K KTCF on KTCF.K_ID = GENTYPCARTEFID.TCF_ID and KTCF.K_ENABLED = 1';
    FIboQuery.Open;
    while not FIboQuery.Eof do
    begin
      ACdsLoad.Append;
      ACdsLoad.FieldByName('TCF_ID').AsInteger := FIboQuery.FieldByName('TCF_ID').AsInteger;
      ACdsLoad.FieldByName('TCF_TYPE').AsInteger := FIboQuery.FieldByName('TCF_TYPE').AsInteger;
      ACdsLoad.FieldByName('TCF_CENTRALE').AsInteger := FIboQuery.FieldByName('TCF_CENTRALE').AsInteger;
      ACdsLoad.Post;
      FIboQuery.Next;
    end;
  finally
    FIboQuery.Close;
  end;
end;

procedure TIntegration.RempliFOFRMAGetTETE(ACdsTETE, ACdsMAGASIN, AFcdsTETE, AFcdsMAGASIN, AFcdsTETEVERIF : TClientDataSet);
var
  i, FieldIndex, MagIDIndex, MAGID : Integer;
  bMagFound : boolean ;
  OFE_CHRONO: string; {DONE -oJO : Modification de la clé: OFE_CODECENTRAL -> OFE_CHRONO (2016-04-07)}
begin
  try
    //Procedure qui aura pour but de bien rempli FOFRTETE et FOFRMAGASIN
    //Pour l'offre en cours regarde si il y a des magasins associés dans cds_OFRMAGASIN

    if ACdsMAGASIN.RecordCount > 0 then
    begin
      ACdsMAGASIN.First;
      OFE_CHRONO := ACdsTETE.FieldByName('OFE_CHRONO').AsString;

      //Je parcours la liste des magasins
      bMagFound := False ;
      while not ACdsMAGASIN.Eof do
      begin
        MAGID := MagExist(ACdsMAGASIN.FieldByName('OFM_FOUCODE').AsString);
        if MAGID <> -1 then
        begin
          bMagFound := true ;

          if AFcdsTETE.Locate('OFE_CHRONO', OFE_CHRONO, []) = False then
          begin
            //Le magasin existe dans la base
            AFcdsTETE.Append;
            for I := 0 to ACdsTETE.FieldList.Count - 1 do
            begin
              FieldIndex := AFcdsTETE.FieldList.IndexOf(ACdsTETE.FieldList.Fields[i].FieldName);
              if FieldIndex <> -1 then
              begin
                AFcdsTETE.FieldList.Fields[FieldIndex].Value := ACdsTETE.FieldList.Fields[i].Value;
              end else
              begin
                FieldIndex := -1;
              end;
            end;
            AFcdsTETE.Post;
          end;

          //Ajout aussi de la ligne dans OFRMAGASIN
          I          := 0;
          FieldIndex := 0;
          AFcdsMAGASIN.Append;
          for I := 0 to ACdsMAGASIN.FieldList.Count - 1 do
          begin
            FieldIndex := AFcdsMAGASIN.FieldList.IndexOf(ACdsMAGASIN.FieldList.Fields[i].FieldName);
            if FieldIndex <> -1 then
            begin
              AFcdsMAGASIN.FieldList.Fields[FieldIndex].Value := ACdsMAGASIN.FieldList.Fields[i].Value;
            end else
            begin
              FieldIndex := -1;
            end;
          end;
          MagIDIndex := AFcdsMAGASIN.FieldList.IndexOf('OFM_FOUID');
          AFcdsMAGASIN.FieldList.Fields[MagIDIndex].Value := MAGID;
          AFcdsMAGASIN.Post;
        end ;

        ACdsMAGASIN.Next;
      end;

      if not bMagFound then
      begin
          if AFcdsTETEVERIF.Locate('OFE_CHRONO', ACdsTETE.FieldByName('OFE_CHRONO').AsString, []) = False then
          begin
            AFcdsTETEVERIF.Append;
            AFcdsTETEVERIF.FieldByName('OFE_CHRONO').AsString := ACdsTETE.FieldByName('OFE_CHRONO').AsString;
            AFcdsTETEVERIF.Post;
          end;
      end ;

    end else
    begin


      if AFcdsTETEVERIF.Locate('OFE_CHRONO', ACdsTETE.FieldByName('OFE_CHRONO').AsString, []) = False then
      begin
        //Pas de magasin associé à l'offre en cours, Ajout du code central dans FOFRTETEVERIF
        AFcdsTETEVERIF.Append;
        AFcdsTETEVERIF.FieldByName('OFE_CHRONO').AsString := ACdsTETE.FieldByName('OFE_CHRONO').AsString;
        AFcdsTETEVERIF.Post;
      end;

    end;



  Except on e:Exception do
    begin
      raise Exception.Create('Chargement des données en mémoire ->' + E.Message);
    end;
  end;

end;

function TIntegration.RempliLINEFOFR(cds, FCds: TClientDataSet): Boolean;
var
  i, FieldIndex : Integer;
begin
  try
    FCds.Append;
    for I := 0 to Cds.FieldList.Count - 1 do
    begin
      FieldIndex := FCds.FieldList.IndexOf(Cds.FieldList.Fields[i].FieldName);
      if FieldIndex <> -1 then
      begin
        FCds.FieldList.Fields[FieldIndex].Value := Cds.FieldList.Fields[i].Value;
      end else
      begin
        FieldIndex := -1;
      end;
    end;
    FCds.Post;
  except on e : Exception do
    begin
      raise Exception.Create('Chargement des données en mémoire ->' + E.Message);
    end;
  end;
end;

function TIntegration.RemplirFcds(Cds, FCds: TClientDataset): Boolean;
var
  i, FieldIndex   : Integer;
begin
  //Remplir les Fcds
  try
    while not Cds.Eof do
    begin
      I := 0;
      //je parcours tous les fields du cds
      FCds.Append;
      for I := 0 to Cds.FieldList.Count - 1 do
      begin
        FieldIndex := FCds.FieldList.IndexOf(Cds.FieldList.Fields[i].FieldName);
        if FieldIndex <> -1 then
        begin
          FCds.FieldList.Fields[FieldIndex].Value := Cds.FieldList.Fields[i].Value;
        end else
        begin
          FieldIndex := -1;
        end;
      end;
      FCds.Post;
      Cds.Next;
    end;
  except on e : Exception do
    begin
      raise Exception.Create('Chargement des données en mémoire ->' + E.Message);
    end;
  end;

end;

function TIntegration.RemplirFcdsPerimetre(Cds, FCds: TClientDataset): Boolean;
var
  i, FieldIndex, FieldIndexLigneID, LIGNEID   : Integer;
begin
  //Permet de remplir le FcdsPerimetre avec les bonnes valeurs
  try
    while not Cds.Eof do
    begin
      I := 0;
      //je parcours tous les fields du cds
      FCds.Append;
      for I := 0 to Cds.FieldList.Count - 1 do
      begin
        if Cds.FieldList.Fields[i].FieldName <> 'OFP_LIGNEID' then
        begin
          FieldIndex := FCds.FieldList.IndexOf(Cds.FieldList.Fields[i].FieldName);
          if FieldIndex <> -1 then
          begin
            FCds.FieldList.Fields[FieldIndex].Value := Cds.FieldList.Fields[i].Value;
          end else
          begin
            FieldIndex := -1;
          end;
        end;
      end;
      //Remplissage du LigneID
      FieldIndexLigneID                       := FCds.FieldList.IndexOf('OFP_LIGNEID');
      FCds.FieldList.Fields[FieldIndexLigneID].Value := GetLigneID(Cds.FieldByName('OFP_TYPDATA').AsInteger,
                                                            Cds.FieldByName('OFP_PERIMCODE').AsString,
                                                            Cds.FieldByName('OFP_PERIMNOM').AsString);       
      
      FCds.Post;

      if FCds.FieldList.Fields[FieldIndexLigneID].Value = -1 then
      begin
        DM_GSDataMain.AddToMemo('   -> Les valeurs suivantes n''ont pas été trouvées dans la base OFP_TYPDATA = '+IntToStr(Cds.FieldByName('OFP_TYPDATA').AsInteger)+
                                ' OFP_PERIMCODE = '+Cds.FieldByName('OFP_PERIMCODE').AsString+' OPF_PERIMNOM = '+ Cds.FieldByName('OFP_PERIMNOM').AsString);
      end;
      
      
      Cds.Next;
    end;
  except on e : Exception do
    begin
      raise Exception.Create('Chargement des données en mémoire ->' + E.Message);
    end;
  end;
end;

function TIntegration.SetOFRIMPBR(AOFEID, ATYPLIGNE, ANUMLIGNE: Integer; AData: String): Integer;
begin
  with FIboQuery do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM GOS_SETOFRIMPBR(:OFI_OFEID, :OFI_TYPLIGNE, :OFI_NUMLIGNE, :OFI_DATA)');
      ParamCheck := True;
      ParamByName('OFI_OFEID').AsInteger    := AOFEID;
      ParamByName('OFI_TYPLIGNE').AsInteger := ATYPLIGNE;
      ParamByName('OFI_NUMLIGNE').AsInteger := ANUMLIGNE;
      ParamByName('OFI_DATA').AsString      := AData;
      ExecSQL;

      if RecordCount > 0 then
      begin
        Result := FieldByName('OFI_ID').AsInteger;
        Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      end;
    Except on e: Exception do
      begin
        raise Exception.Create('SetOFRIMPBR -> '+e.Message);
      end;
    end;
  end;
end;

function TIntegration.SetOFRLIGNEBR(AOFEID, AREPART: Integer; ADTUTILDEB, ADTUTILFIN: TDateTime): Integer;
begin
  with FIboQuery do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM GOS_SETOFRLIGNEBR(:OFL_OFEID, :OFL_DTUTILDEB, :OFL_DTUTILFIN, :OFL_REPART)');
      ParamCheck := True;
      ParamByName('OFL_OFEID').AsInteger      := AOFEID;
      ParamByName('OFL_DTUTILDEB').AsDateTime := ADTUTILDEB;
      ParamByName('OFL_DTUTILFIN').AsDateTime := ADTUTILFIN;
      ParamByName('OFL_REPART').AsInteger     := AREPART;
      Open;

      if RecordCount > 0 then
      begin
        Result := FieldByName('OFL_ID').AsInteger;
        Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      end;
    Except on e: Exception do
      begin
        raise Exception.Create('SetOFRLIGNEBR -> '+e.Message);
      end;
    end;
  end;
end;

function TIntegration.SetOFRMAGASIN(OFEID, MAGID: Integer): Integer;
begin
  with FIboQuery do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM GOS_SETOFRMAGASIN(:OFEID, :MAGID)');
      ParamCheck := True;
      ParamByName('OFEID').AsInteger := OFEID;
      ParamByName('MAGID').AsInteger := MAGID;
      ExecSQL;

      if RecordCount > 0 then
      begin
        Result := FieldByName('OFM_ID').AsInteger;
        Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      end;

    Except on e: Exception do
      begin
        raise Exception.Create('SetOFRMAGASIN -> '+e.Message);
      end;
    end;
  end;
end;

function TIntegration.SetOFRPERIMETRE(AOFEID, ATYPPERIM, ATYPDATA, ALIGNEID, AINCLUEXCLU: Integer): Integer;
begin
  with FIboQuery do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM GOS_SETOFRPERIMETRE(:OFP_OFEID, :OFP_TYPPERIM, :OFP_TYPDATA, :OFP_LIGNEID, :OFP_INCLUEXCLU)');
      ParamCheck := True;
      ParamByName('OFP_OFEID').AsInteger      := AOFEID;
      ParamByName('OFP_TYPPERIM').AsInteger   := ATYPPERIM;
      ParamByName('OFP_TYPDATA').AsInteger    := ATYPDATA;
      ParamByName('OFP_LIGNEID').AsInteger    := ALIGNEID;
      ParamByName('OFP_INCLUEXCLU').AsInteger := AINCLUEXCLU;
      ExecSQL;

      if RecordCount > 0 then
      begin
        Result := FieldByName('OFP_ID').AsInteger;
        Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      end;

    except on e: Exception do
      begin
        raise Exception.Create('SetOFRPERIMETRE -> '+e.Message);
      end;
    end;
  end;
end;

function TIntegration.SetOFRTETE(AOFRTETE: TOFRTETE; InitMode : Boolean): Integer;
var
  Initialisation : Integer;
  NbParams : Integer;
begin
  try
    if InitMode then
    begin
      Initialisation := 1;
    end else
    begin
      Initialisation := 0;
    end;

    //Je vérifie si l'entête n'a pas déjà inserer avant en init , si oui je peux faire des mise à jours
    if (FOFRTETEINIT.ClientDataset.Locate('OFE_CHRONO', FOFRTETE.ClientDataset.FieldByName('OFE_CHRONO').AsString, [])) then
    begin
      Initialisation := 0;
    end;

//JB
    // Comptage du nombre de paramètre d'entrée de la procédure stockée GOS_SETOFRTETE
    // Si 58 paramètres au lieu de 57, l'évolution pour la gestion du champ OFE_MARGECENTRALE a été intégrée dans la procédure
    with FIboQuery do
    begin
      FIboQuery.Close;
      FIboQuery.SQL.Clear;
      FIboQuery.SQL.Add(' SELECT rdb$procedure_Inputs as NbParams FROM rdb$procedures where rdb$procedure_name = ''GOS_SETOFRTETE''');
      FIboQuery.ExecSQL;
      if FIboQuery.RecordCount > 0
      then NbParams := FIboQuery.FieldByName('NBPARAMS').AsInteger
      else NbParams := 57;
    end;
//
    with FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM GOS_SETOFRTETE(:OFE_CHRONO, :OFE_NOM, :OFE_CODECENTRAL, :OFE_TYPE, :OFE_ACTIF, :OFE_CUMUL, ');
      SQL.Add(':OFE_CENTRALE, :OFE_DATE, :OFE_CODTVALDEB, :OFE_CODTVALFIN, :OFE_COPERM, :OFE_COOPTYPDEC, :OFE_COOPCB, ');
      SQL.Add(':OFE_COBRPREFIXE, :OFE_COBRLGVAL, :OFE_COBRLGDEC, :OFE_COCLTTYP, :OFE_COCLTFID, :OFE_COCLTCLA, :OFE_COPALIERFID, ');
      SQL.Add(':OFE_COTYPVTEN, :OFE_COTYPVTES, :OFE_COTYPVTEP, :OFE_COREMMAX, :OFE_COMINPAN, :OFE_COMAXPAN, :OFE_COPERIMPAN, ');
      SQL.Add(':OFE_COMINART, :OFE_COMAXART, :OFE_COPERIMART, :OFE_COPERIM, :OFE_COMODCONTRAC, :OFE_COMODCOMPLE, :OFE_CACLTPERIM, ');
      SQL.Add(':OFE_CATYPVTEN, :OFE_CATYPVTES, :OFE_CATYPVTEP, :OFE_CAREMMAX, :OFE_CAPXMIN, :OFE_CAMINPAN, :OFE_CAMAXPAN, ');
      SQL.Add(':OFE_CAPERIMPAN, :OFE_CAMINART, :OFE_CAMAXART, :OFE_CAPERIMART, :OFE_CAPERIM, :OFE_CAMODCONTRAC, :OFE_CAMODCOMPLE, ');
      SQL.Add(':OFE_AVTYPLIGNE, :OFE_AVVALX, :OFE_AVTYPREM, :OFE_AVVAL1, :OFE_AVVAL2, :OFE_AVVAL3, :OFE_AVVAL4, :OFE_AVVAL5, ');
//JB Ajout OFE_MARGECENTRALE
      // Seulement si procédure stockée modifiée (58 paramètres d'entrée au lieu de 57
      if NbParams = 58
      then SQL.Add(':OFE_MARGECENTRALE, ');
      SQL.Add(':INITMODE)');
      ParamCheck := True;
      ParamByName('OFE_CHRONO').AsString         := FOFRTETE.ClientDataset.FieldByName('OFE_CHRONO').AsString;
      ParamByName('OFE_NOM').AsString            := FOFRTETE.ClientDataset.FieldByName('OFE_NOM').AsString;
      ParamByName('OFE_CODECENTRAL').AsInteger   := FOFRTETE.ClientDataset.FieldByName('OFE_CODECENTRAL').AsInteger;
      ParamByName('OFE_TYPE').AsInteger          := FOFRTETE.ClientDataset.FieldByName('OFE_TYPE').AsInteger;
      ParamByName('OFE_ACTIF').AsInteger         := FOFRTETE.ClientDataset.FieldByName('OFE_ACTIF').AsInteger;
      ParamByName('OFE_CUMUL').AsInteger         := FOFRTETE.ClientDataset.FieldByName('OFE_CUMUL').AsInteger;
      ParamByName('OFE_CENTRALE').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_CENTRALE').AsInteger;
      ParamByName('OFE_DATE').AsDateTime         := FOFRTETE.ClientDataset.FieldByName('OFE_DATE').AsDateTime;
      ParamByName('OFE_CODTVALDEB').AsDateTime   := FOFRTETE.ClientDataset.FieldByName('OFE_CODTVALDEB').AsDateTime;
      ParamByName('OFE_CODTVALFIN').AsDateTime   := FOFRTETE.ClientDataset.FieldByName('OFE_CODTVALFIN').AsDateTime;
      ParamByName('OFE_COPERM').AsInteger        := FOFRTETE.ClientDataset.FieldByName('OFE_COPERM').AsInteger;
      ParamByName('OFE_COOPTYPDEC').AsInteger    := FOFRTETE.ClientDataset.FieldByName('OFE_COOPTYPDEC').AsInteger;
      ParamByName('OFE_COOPCB').AsString         := FOFRTETE.ClientDataset.FieldByName('OFE_COOPCB').AsString;
      ParamByName('OFE_COBRPREFIXE').AsString    := FOFRTETE.ClientDataset.FieldByName('OFE_COBRPREFIXE').AsString;
      ParamByName('OFE_COBRLGVAL').AsInteger     := FOFRTETE.ClientDataset.FieldByName('OFE_COBRLGVAL').AsInteger;
      ParamByName('OFE_COBRLGDEC').AsInteger     := FOFRTETE.ClientDataset.FieldByName('OFE_COBRLGDEC').AsInteger;
      ParamByName('OFE_COCLTTYP').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_COCLTTYP').AsInteger;
      ParamByName('OFE_COCLTFID').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_COCLTFID').AsInteger;
      ParamByName('OFE_COCLTCLA').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_COCLTCLA').AsInteger;
      ParamByName('OFE_COPALIERFID').AsInteger   := FOFRTETE.ClientDataset.FieldByName('OFE_COPALIERFID').AsInteger;
      ParamByName('OFE_COTYPVTEN').AsInteger     := FOFRTETE.ClientDataset.FieldByName('OFE_COTYPVTEN').AsInteger;
      ParamByName('OFE_COTYPVTES').AsInteger     := FOFRTETE.ClientDataset.FieldByName('OFE_COTYPVTES').AsInteger;
      ParamByName('OFE_COTYPVTEP').AsInteger     := FOFRTETE.ClientDataset.FieldByName('OFE_COTYPVTEP').AsInteger;
      ParamByName('OFE_COREMMAX').AsFloat        := FOFRTETE.ClientDataset.FieldByName('OFE_COREMMAX').AsFloat;
      ParamByName('OFE_COMINPAN').AsFloat        := FOFRTETE.ClientDataset.FieldByName('OFE_COMINPAN').AsFloat;
      ParamByName('OFE_COMAXPAN').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_COMAXPAN').AsInteger;
      ParamByName('OFE_COPERIMPAN').AsInteger    := FOFRTETE.ClientDataset.FieldByName('OFE_COPERIMPAN').AsInteger;
      ParamByName('OFE_COMINART').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_COMINART').AsInteger;
      ParamByName('OFE_COMAXART').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_COMAXART').AsInteger;
      ParamByName('OFE_COPERIMART').AsInteger    := FOFRTETE.ClientDataset.FieldByName('OFE_COPERIMART').AsInteger;
      ParamByName('OFE_COPERIM').AsInteger       := FOFRTETE.ClientDataset.FieldByName('OFE_COPERIM').AsInteger;
      ParamByName('OFE_COMODCONTRAC').AsInteger  := FOFRTETE.ClientDataset.FieldByName('OFE_COMODCONTRAC').AsInteger;
      ParamByName('OFE_COMODCOMPLE').AsInteger   := FOFRTETE.ClientDataset.FieldByName('OFE_COMODCOMPLE').AsInteger;
      ParamByName('OFE_CACLTPERIM').AsInteger    := FOFRTETE.ClientDataset.FieldByName('OFE_CACLTPERIM').AsInteger;
      ParamByName('OFE_CATYPVTEN').AsInteger     := FOFRTETE.ClientDataset.FieldByName('OFE_CATYPVTEN').AsInteger;
      ParamByName('OFE_CATYPVTES').AsInteger     := FOFRTETE.ClientDataset.FieldByName('OFE_CATYPVTES').AsInteger;
      ParamByName('OFE_CATYPVTEP').AsInteger     := FOFRTETE.ClientDataset.FieldByName('OFE_CATYPVTEP').AsInteger;
      ParamByName('OFE_CAREMMAX').AsFloat        := FOFRTETE.ClientDataset.FieldByName('OFE_CAREMMAX').AsFloat;
      ParamByName('OFE_CAPXMIN').AsInteger       := FOFRTETE.ClientDataset.FieldByName('OFE_CAPXMIN').AsInteger;
      ParamByName('OFE_CAMINPAN').AsFloat        := FOFRTETE.ClientDataset.FieldByName('OFE_CAMINPAN').AsFloat;
      ParamByName('OFE_CAMAXPAN').AsFloat        := FOFRTETE.ClientDataset.FieldByName('OFE_CAMAXPAN').AsFloat;
      ParamByName('OFE_CAPERIMPAN').AsInteger    := FOFRTETE.ClientDataset.FieldByName('OFE_CAPERIMPAN').AsInteger;
      ParamByName('OFE_CAMINART').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_CAMINART').AsInteger;
      ParamByName('OFE_CAMAXART').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_CAMAXART').AsInteger;
      ParamByName('OFE_CAPERIMART').AsInteger    := FOFRTETE.ClientDataset.FieldByName('OFE_CAPERIMART').AsInteger;
      ParamByName('OFE_CAPERIM').AsInteger       := FOFRTETE.ClientDataset.FieldByName('OFE_CAPERIM').AsInteger;
      ParamByName('OFE_CAMODCONTRAC').AsInteger  := FOFRTETE.ClientDataset.FieldByName('OFE_CAMODCONTRAC').AsInteger;
      ParamByName('OFE_CAMODCOMPLE').AsInteger   := FOFRTETE.ClientDataset.FieldByName('OFE_CAMODCOMPLE').AsInteger;
      ParamByName('OFE_AVTYPLIGNE').AsInteger    := FOFRTETE.ClientDataset.FieldByName('OFE_AVTYPLIGNE').AsInteger;
      ParamByName('OFE_AVVALX').AsInteger        := FOFRTETE.ClientDataset.FieldByName('OFE_AVVALX').AsInteger;
      ParamByName('OFE_AVTYPREM').AsInteger      := FOFRTETE.ClientDataset.FieldByName('OFE_AVTYPREM').AsInteger;
      ParamByName('OFE_AVVAL1').AsFloat          := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL1').AsFloat;
      ParamByName('OFE_AVVAL2').AsFloat          := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL2').AsFloat;
      ParamByName('OFE_AVVAL3').AsFloat          := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL3').AsFloat;
      ParamByName('OFE_AVVAL4').AsFloat          := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL4').AsFloat;
      ParamByName('OFE_AVVAL5').AsFloat          := FOFRTETE.ClientDataset.FieldByName('OFE_AVVAL5').AsFloat;
//JB Ajout OFE_MARGECENTRALE
      // Seulement si procédure stockée modifiée (58 paramètres d'entrée au lieu de 57
      if NbParams = 58
      then ParamByName('OFE_MARGECENTRALE').AsInteger    := FOFRTETE.ClientDataset.FieldByName('OFE_MARGECENTRALE').AsInteger;
      ParamByName('INITMODE').AsInteger          := Initialisation;
      ExecSQL;

      if RecordCount > 0 then
      begin
        Result := FieldByName('OFE_ID').AsInteger;
        Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,FieldByName('FMAJ').AsInteger);

        if FieldByName('FAJOUT').AsInteger <> 0 then
          Inc(NbOffreImport, 1);

        if FieldByName('FMAJ').AsInteger <> 0 then
          Inc(NbOffreDoMaj, 1);

        if ((Initialisation = 1) and (FieldByName('FAJOUT').AsInteger <> 0)) then
        begin
          //J'ai ajouté la ligne en mode Initialisation je l'ajoute dans le codecentral FcdsTETEINIT , pour mise à jour éventuel plus tard
          FOFRTETEINIT.Append;
          FOFRTETEINIT.FieldByName('OFE_CHRONO').AsString := FOFRTETE.ClientDataset.FieldByName('OFE_CHRONO').AsString;
          FOFRTETEINIT.Post;
        end;

        if ((Initialisation = 1) and (FieldByName('FAJOUT').AsInteger = 0)) then
        begin
          OkAutreFic := False;
        end;

      end;
  end;
  Except on e:Exception do
    begin
      raise Exception.Create('SetOFRTETE -> '+e.Message);
    end;
  end;
end;

function TIntegration.SetOFRTYPCARTEFID(AOFEID, ATCFTYPE, ATCFCENTRALE: Integer): Integer;
begin
  {TODO -oJO : Facultatif: Définir un retour par défaut}
  try
    if not FGENTYPCARTEFIDLOAD.ClientDataset.Locate('TCF_TYPE;TCF_CENTRALE',
      VarArrayOf([ATCFTYPE, ATCFCENTRALE]), []) then
      raise Exception.CreateFmt('Type de carte non trouvé (type:%d, centrale:%d)', [ATCFTYPE, ATCFCENTRALE]);

    FIboQuery.Close;
    FIboQuery.SQL.Text := 'select * from GOS_SETOFRTYPCARTEFID(:OFF_OFEID, :OFF_TCFID)';
    FIboQuery.ParamCheck := True;
    FIboQuery.ParamByName('OFF_OFEID').AsInteger := AOFEID;
    FIboQuery.ParamByName('OFF_TCFID').AsInteger := FGENTYPCARTEFIDLOAD.ClientDataset.FieldByName('TCF_ID').AsInteger;
    FIboQuery.ExecSQL;

    if not FIboQuery.IsEmpty then
    begin
      Result := FIboQuery.FieldByName('OFF_ID').AsInteger;
      Inc(FInsertCount, FIboQuery.FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount, FIboQuery.FieldByName('FMAJ').AsInteger);
    end;
  except
    on E: Exception do
      raise Exception.Create('SetOFRTYPCARTEFID -> ' + E.Message);
  end;
end;

end.
