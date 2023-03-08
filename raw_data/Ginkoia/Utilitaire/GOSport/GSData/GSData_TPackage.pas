unit GSData_TPackage;

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
  TArtLot       = record
    LOT_ID      : Integer;
    LOT_NUMERO  : String;
    bCreer      : Boolean;
  end;

  TArtLotMag    = record
    LMG_ID      : Integer;
    LMG_LOTID   : Integer;
    bCreer      : Boolean;
  end;

  TArtLotGroupe = record
    LOG_ID      : Integer;
    LOG_LOTID   : Integer;
    LOG_NUMGRP  : String;
    bCreer      : Boolean;
  end;

  TArtLotLigne  = record
    LOL_ID      : Integer;
    LOL_LOTID   : Integer;
    LOL_LOGID   : Integer;
    bCreer      : Boolean;
  end;

  TArtLotDetail = record
    LCT_ID      : Integer;
    LCT_LOLID   : Integer;
    bCreer      : Boolean;
  end;

  TPackage = class (TMainClass)
  private
    FFileImport         : String;

    FArtLot             : TMainClass;
    FArtLotMag          : TMainClass;
    FArtLotGroupe       : TMainClass;
    FArtLotLigne        : TMainClass;
    FArtLotDetail       : TMainClass;

    FArtLotLigneLoad    : TMainClass;
    FArtLotDetailLoad   : TMainClass;

    FArtLotLignePurge   : TMainClass;
    FArtLotDetailPurge  : TMainClass;

    DS_FArtLot          : TDataSource;
    DS_FArtLotGroupe    : TDataSource;

    // Création dans ARTLOT
    function SetArtLot(ALOT_NOM, ALOT_NUMERO, ALOT_LIBELLE: String;
      ALOT_PERM: Integer; ALOT_DEBUT, ALOT_FIN: TDate; ALOT_PV: Double;
      ALOT_TYPID, ALOT_QTEVENTE, ALOT_PXCENTRALE: Integer): TArtLot;

    // Création dans ARTLOTMAG
    function SetArtLotMag(ALOT_NUMERO: String; ALMG_LOTID, ALMG_MAGID: Integer): TArtLotMag;

    // Création dans ARTLOTGROUPE
    function SetArtLotGroupe(ALOT_NUMERO: String; ALOG_LOTID: Integer;
      ALOG_NUMGRP, ALOG_LIBGRP: String; ALOG_QTEGRP: Integer): TArtLotGroupe;

    // Création dans ARTLOTLIGNE
    function SetArtLotLigne(ALOG_NUMGRP: String;
      ALOL_LOTID, ALOL_LOGID, ALOL_ARTID: Integer): TArtLotLigne;

    // Création dans ARTLOTDETAIL
    function SetArtLotDetail(ALOG_NUMGRP: String;
      ALCT_LOLID, ALCT_COUID, ALCT_TGFID: Integer): TArtLotDetail;

    // Supprime une ligne d'un lot
    procedure DelArtLotLigne(ALOL_ID: Integer);

    // Supprime un détail d'un lot
    procedure DelArtLotDetail(ALCT_ID: Integer);
  public
    procedure Import(); override;
    function DoMajTable(): Boolean; override;

    constructor Create(); override;
    destructor Destroy(); override;

    // Création des champs dans les ClientDataSets
    procedure CreateCdsField();
  published
    // Accès aux ClientsDataSets
    property ArtLot       : TMainClass  read FArtLot;
    property ArtLotMag    : TMainClass  read FArtLotMag;
    property ArtLotGroupe : TMainClass  read FArtLotGroupe;
    property ArtLotLigne  : TMainClass  read FArtLotLigne;
    property ArtLotDetail : TMainClass  read FArtLotDetail;
  end;


implementation

{ TPackage }

constructor TPackage.Create();
begin
  inherited Create();

  // Création des ClientDataSets pour les tables
  FArtLot                   := TMainClass.Create();
  FArtLotMag                := TMainClass.Create();
  FArtLotGroupe             := TMainClass.Create();
  FArtLotLigne              := TMainClass.Create();
  FArtLotDetail             := TMainClass.Create();

  FArtLotLigneLoad          := TMainClass.Create();
  FArtLotDetailLoad         := TMainClass.Create();

  FArtLotLignePurge         := TMainClass.Create();
  FArtLotDetailPurge        := TMainClass.Create();

  DS_FArtLot                := TDataSource.Create(nil);
  DS_FArtLot.DataSet        := FArtLot.ClientDataset;
  DS_FArtLotGroupe          := TDataSource.Create(nil);
  DS_FArtLotGroupe.DataSet  := FArtLotGroupe.ClientDataset;
end;

destructor TPackage.Destroy();
begin
  // Destruction des ClientDataSets
  FArtLot.Free();
  FArtLotMag.Free();
  FArtLotGroupe.Free();
  FArtLotLigne.Free();
  FArtLotDetail.Free();

  FArtLotLigneLoad.Free();
  FArtLotDetailLoad.Free();

  FArtLotLignePurge.Free();
  FArtLotDetailPurge.Free();

  DS_FArtLot.Free();
  DS_FArtLotGroupe.Free();

  inherited Destroy();
end;

// Création des champs dans les ClientDataSets
procedure TPackage.CreateCdsField();
begin
  // Table ARTLOT
  FArtLot.CreateField(['LOT_ID', 'LOT_NOM', 'LOT_NUMERO', 'LOT_LIBELLE',
    'LOT_PERM', 'LOT_DEBUT', 'LOT_FIN', 'LOT_PV', 'LOT_TYPID', 'LOT_QTEVENTE',
    'LOT_PXCENTRALE', 'Error', 'Created'],
    [ftInteger, ftString, ftString, ftString, ftInteger, ftDate, ftDate,
      ftFloat, ftInteger, ftInteger, ftInteger, ftInteger, ftBoolean]);
  FArtLot.ClientDataset.AddIndex('IDX', 'LOT_NUMERO', []);
  FArtLot.ClientDataset.IndexName           := 'IDX';

  // Table ARTLOTMAG
  FArtLotMag.CreateField(['LOT_NUMERO', 'LMG_ID', 'LMG_LOTID', 'LMG_MAGID', 'Error', 'Created'],
    [ftString, ftInteger, ftInteger, ftInteger, ftInteger, ftBoolean]);
  FArtLotMag.ClientDataset.AddIndex('IDX', 'LOT_NUMERO', []);
  FArtLotMag.ClientDataset.IndexName        := 'IDX';
  FArtLotMag.ClientDataset.MasterSource     := DS_FArtLot;
  FArtLotMag.ClientDataset.MasterFields     := 'LOT_NUMERO';

  // Table ARTLOTGROUPE
  FArtLotGroupe.CreateField(['LOT_NUMERO', 'LOG_ID', 'LOG_LOTID', 'LOG_NUMGRP',
    'LOG_LIBGRP', 'LOG_QTEGRP', 'Error', 'Created'],
    [ftString, ftInteger, ftInteger, ftString, ftString, ftInteger, ftInteger, ftBoolean]);
  FArtLotGroupe.ClientDataset.AddIndex('IDX', 'LOT_NUMERO', []);
  FArtLotGroupe.ClientDataset.IndexName     := 'IDX';
  FArtLotGroupe.ClientDataset.MasterSource  := DS_FArtLot;
  FArtLotGroupe.ClientDataset.MasterFields  := 'LOT_NUMERO';

  // Table ARTLOTLIGNE
  FArtLotLigne.CreateField(['LOG_NUMGRP', 'LOL_ID', 'LOL_LOTID', 'LOL_LOGID',
    'LOL_ARTID', 'Error', 'Created'],
    [ftString, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftBoolean]);
  FArtLotLigne.ClientDataset.AddIndex('IDX', 'LOG_NUMGRP', []);
  FArtLotLigne.ClientDataset.IndexName      := 'IDX';
  FArtLotLigne.ClientDataset.MasterSource   := DS_FArtLotGroupe;
  FArtLotLigne.ClientDataset.MasterFields   := 'LOG_NUMGRP';

  FArtLotLigneLoad.CreateField(['LOL_ID', 'LOL_LOGID', 'CANDELETE'],
    [ftInteger, ftInteger, ftInteger]);
  FArtLotLigneLoad.ClientDataset.AddIndex('IDX', 'LOL_ID', []);
  FArtLotLigneLoad.ClientDataset.IndexName  := 'IDX';

  FArtLotLignePurge.CreateField(['LOL_ID', 'LOL_LOGID', 'CANDELETE'],
    [ftInteger, ftInteger, ftInteger]);
  FArtLotLignePurge.ClientDataset.AddIndex('IDX', 'LOL_ID', []);
  FArtLotLignePurge.ClientDataset.IndexName := 'IDX';

  // Table ARTLOTDETAIL
  FArtLotDetail.CreateField(['LOG_NUMGRP', 'LCT_ID', 'LCT_LOLID', 'LCT_COUID',
    'LCT_TGFID', 'Error', 'Created'],
    [ftString, ftInteger, ftInteger, ftInteger, ftInteger, ftInteger, ftBoolean]);
  FArtLotDetail.ClientDataset.AddIndex('IDX', 'LOG_NUMGRP', []);
  FArtLotDetail.ClientDataset.IndexName     := 'IDX';
  FArtLotDetail.ClientDataset.MasterSource  := DS_FArtLotGroupe;
  FArtLotDetail.ClientDataset.MasterFields  := 'LOG_NUMGRP';

  FArtLotDetailLoad.CreateField(['LCT_ID', 'LCT_LOLID', 'CANDELETE'],
    [ftInteger, ftInteger, ftInteger]);
  FArtLotDetailLoad.ClientDataset.AddIndex('IDX', 'LCT_ID', []);
  FArtLotDetailLoad.ClientDataset.IndexName := 'IDX';

  FArtLotDetailPurge.CreateField(['LCT_ID', 'LCT_LOLID', 'CANDELETE'],
    [ftInteger, ftInteger, ftInteger]);
  FArtLotDetailPurge.ClientDataset.AddIndex('IDX', 'LCT_ID', []);
  FArtLotDetailPurge.ClientDataset.IndexName := 'IDX';
end;

// Création dans ARTLOT
function TPackage.SetArtLot(ALOT_NOM, ALOT_NUMERO, ALOT_LIBELLE: String;
  ALOT_PERM: Integer; ALOT_DEBUT, ALOT_FIN: TDate; ALOT_PV: Double;
  ALOT_TYPID, ALOT_QTEVENTE, ALOT_PXCENTRALE: Integer): TArtLot;
begin
  with FIboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('SELECT LOT_ID, FAJOUT, FMAJ');
      SQL.Add('FROM   GOS_SETARTLOT(:PLOTNOM, :PLOTNUMERO, :PLOTLIBELLE, :PLOTPERM, :PLOTDEBUT,');
      SQL.Add('  :PLOTFIN, :PLOTPV, :PLOTTYPID, :PLOTQTEVENTE, :PLOTPXCENTRALE)');
      ParamCheck := True;
      ParamByName('PLOTNOM').AsString         := ALOT_NOM;
      ParamByName('PLOTNUMERO').AsString      := ALOT_NUMERO;
      ParamByName('PLOTLIBELLE').AsString     := ALOT_LIBELLE;
      ParamByName('PLOTPERM').AsInteger       := ALOT_PERM;
      ParamByName('PLOTDEBUT').AsDate         := ALOT_DEBUT;
      ParamByName('PLOTFIN').AsDate           := ALOT_FIN;
      ParamByName('PLOTPV').AsFloat           := ALOT_PV;
      ParamByName('PLOTTYPID').AsInteger      := ALOT_TYPID;
      ParamByName('PLOTQTEVENTE').AsInteger   := ALOT_QTEVENTE;
      ParamByName('PLOTPXCENTRALE').AsInteger := ALOT_PXCENTRALE;
      ExecSQL();

      if RecordCount > 0 then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,    FieldByName('FMAJ').AsInteger);
        Result.LOT_ID     := FieldByName('LOT_ID').AsInteger;
        Result.LOT_NUMERO := ALOT_NUMERO;
        Result.bCreer     := (FieldByName('FAJOUT').AsInteger > 0);
      end;
    except
      on E: Exception do
        raise Exception.Create(Format('SetArtLot -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Création dans ARTLOTMAG
function TPackage.SetArtLotMag(ALOT_NUMERO: String; ALMG_LOTID, ALMG_MAGID: Integer): TArtLotMag;
begin
  with FIboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('SELECT LMG_ID, FAJOUT, FMAJ');
      SQL.Add('FROM   GOS_SETARTLOTMAG(:PLMGLOTID, :PLMGMAGID);');
      ParamCheck := True;
      ParamByName('PLMGLOTID').AsInteger      := ALMG_LOTID;
      ParamByName('PLMGMAGID').AsInteger      := ALMG_MAGID;
      ExecSQL();

      if RecordCount > 0 then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,    FieldByName('FMAJ').AsInteger);
        Result.LMG_ID     := FieldByName('LMG_ID').AsInteger;
        Result.LMG_LOTID  := ALMG_LOTID;
        Result.bCreer     := (FieldByName('FAJOUT').AsInteger > 0);
      end;
    except
      on E: Exception do
        raise Exception.Create(Format('SetArtLotMag -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Création dans ARTLOTGROUPE
function TPackage.SetArtLotGroupe(ALOT_NUMERO: String; ALOG_LOTID: Integer;
  ALOG_NUMGRP, ALOG_LIBGRP: String; ALOG_QTEGRP: Integer): TArtLotGroupe;
begin
  with FIboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('SELECT LOG_ID, FAJOUT, FMAJ');
      SQL.Add('FROM   GOS_SETARTLOTGROUPE(:PLOGLOTID, :PLOGNUMGRP, :PLOGLIBGRP, :PLOGQTEGRP)');
      ParamCheck := True;
      ParamByName('PLOGLOTID').AsInteger      := ALOG_LOTID;
      ParamByName('PLOGNUMGRP').AsString      := ALOG_NUMGRP;
      ParamByName('PLOGLIBGRP').AsString      := ALOG_LIBGRP;
      ParamByName('PLOGQTEGRP').AsInteger     := ALOG_QTEGRP;
      ExecSQL();

      if RecordCount > 0 then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,    FieldByName('FMAJ').AsInteger);
        Result.LOG_ID     := FieldByName('LOG_ID').AsInteger;
        Result.LOG_LOTID  := ALOG_LOTID;
        Result.LOG_NUMGRP := ALOG_NUMGRP;
        Result.bCreer     := (FieldByName('FAJOUT').AsInteger > 0);
      end;
    except
      on E: Exception do
        raise Exception.Create(Format('SetArtLotGroupe -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Création dans ARTLOTLIGNE
function TPackage.SetArtLotLigne(ALOG_NUMGRP: String;
  ALOL_LOTID, ALOL_LOGID, ALOL_ARTID: Integer): TArtLotLigne;
begin
  with FIboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('SELECT LOL_ID, FAJOUT, FMAJ');
      SQL.Add('FROM   GOS_SETARTLOTLIGNE(:PLOLLOTID, :PLOLLOGID, :PLOLARTID)');
      ParamCheck := True;
      ParamByName('PLOLLOTID').AsInteger      := ALOL_LOTID;
      ParamByName('PLOLLOGID').AsInteger      := ALOL_LOGID;
      ParamByName('PLOLARTID').AsInteger      := ALOL_ARTID;
      ExecSQL();

      if RecordCount > 0 then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,    FieldByName('FMAJ').AsInteger);
        Result.LOL_ID     := FieldByName('LOL_ID').AsInteger;
        Result.LOL_LOGID  := ALOL_LOGID;
        Result.bCreer     := (FieldByName('FAJOUT').AsInteger > 0);
      end;
    except
      on E: Exception do
        raise Exception.Create(Format('SetArtLotLigne -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Création dans ARTLOTDETAIL
function TPackage.SetArtLotDetail(ALOG_NUMGRP: String;
  ALCT_LOLID, ALCT_COUID, ALCT_TGFID: Integer): TArtLotDetail;
begin
  with FIboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('SELECT LCT_ID, FAJOUT, FMAJ');
      SQL.Add('FROM   GOS_SETARTLOTDETAIL(:PLCTLOLID, :PLCTCOUID, :PLCTTGFID)');
      ParamCheck := True;
      ParamByName('PLCTLOLID').AsInteger      := ALCT_LOLID;
      ParamByName('PLCTCOUID').AsInteger      := ALCT_COUID;
      ParamByName('PLCTTGFID').AsInteger      := ALCT_TGFID;
      ExecSQL();

      if RecordCount > 0 then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,    FieldByName('FMAJ').AsInteger);
        Result.LCT_ID     := FieldByName('LCT_ID').AsInteger;
        Result.bCreer     := (FieldByName('FAJOUT').AsInteger > 0);
      end;
    except
      on E: Exception do
        raise Exception.Create(Format('SetArtLotDetail -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Supprime une ligne d'un lot
procedure TPackage.DelArtLotLigne(ALOL_ID: Integer);
begin
  with IboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('EXECUTE PROCEDURE GOS_DELARTLOTLIGNE(:PLOLID)');
      ParamCheck := True;
      ParamByName('PLOLID').AsInteger         := ALOL_ID;
      ExecSQL();
    except
      on E: Exception do
        raise Exception.Create(Format('DelArtLotLigne -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

// Supprime un détail d'un lot
procedure TPackage.DelArtLotDetail(ALCT_ID: Integer);
begin
  with IboQuery do
    try
      Close();
      SQL.Clear();
      SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PLCTID, 1)');
      ParamCheck := True;
      ParamByName('PLCTID').AsInteger         := ALCT_ID;
      ExecSQL();
    except
      on E: Exception do
        raise Exception.Create(Format('DelArtLotDetail -> [%s] : %s', [E.ClassName, E.Message]));
    end;
end;

procedure TPackage.Import();
var
  Erreur    : TErreur;
  i         : Integer;
  sPrefixe  : String;
  Article   : TCodeArticle;
begin
  // Création des tables et champs
  CreateCdsField();

  // Récupération du nom du fichier
  for i := Low(FilesPath) to High(FilesPath) do
  begin
    sPrefixe := Copy(FilesPath[i], 1, 6);
    case AnsiIndexStr(UpperCase(sPrefixe),['PACKAG']) of
      0:
        FFileImport := FilesPath[i];
    end;
  end;

  LabCaption(Format('Importation du fichier %s', [FFileImport]));

  // Import des données dans le ClientDataSet
  with DM_GSDataImport do
  begin
    cds_PACKAG.First();

    while not cds_PACKAG.Eof do
    begin
      try
      {$REGION 'Table ARTLOT'}
      // Vérification de l'unicité du lot
      if not FArtLot.ClientDataset.Locate('LOT_NUMERO',
        cds_PACKAG.FieldByName('CODE_PACK').AsString, []) then
      begin
        FArtLot.Append();
        FArtLot.FieldByName('LOT_ID').AsInteger         := 0;
        FArtLot.FieldByName('LOT_NOM').AsString         := cds_PACKAG.FieldByName('LPACK').AsString;
        FArtLot.FieldByName('LOT_NUMERO').AsString      := cds_PACKAG.FieldByName('CODE_PACK').AsString;
        FArtLot.FieldByName('LOT_LIBELLE').AsString     := cds_PACKAG.FieldByName('LPACK').AsString;
        if ConvertDate(cds_PACKAG.FieldByName('DATE_FIN').AsString) = ConvertDate('31/12/9999') then
          FArtLot.FieldByName('LOT_PERM').AsInteger     := 1
        else
          FArtLot.FieldByName('LOT_PERM').AsInteger     := 0;
        FArtLot.FieldByName('LOT_DEBUT').AsDateTime     := ConvertDate(cds_PACKAG.FieldByName('DATE_DEB').AsString);
        FArtLot.FieldByName('LOT_FIN').AsDateTime       := ConvertDate(cds_PACKAG.FieldByName('DATE_FIN').AsString);
        FArtLot.FieldByName('LOT_PV').AsFloat           := ConvertFloat(cds_PACKAG.FieldByName('PVPACK').AsString);
        {TODO -oLP -cImport :Créer un nouveau type de lot (champ LOT_TYPID)}
        FArtLot.FieldByName('LOT_QTEVENTE').AsInteger   := 1;
        FArtLot.FieldByName('LOT_PXCENTRALE').AsInteger := Round(ConvertFloat(cds_PACKAG.FieldByName('PVPACK').AsString));
        FArtLot.Post();
      end
      else begin
        FArtLot.Edit();
        FArtLot.FieldByName('LOT_NOM').AsString         := cds_PACKAG.FieldByName('LPACK').AsString;
        FArtLot.FieldByName('LOT_LIBELLE').AsString     := cds_PACKAG.FieldByName('LPACK').AsString;
        if ConvertDate(cds_PACKAG.FieldByName('DATE_FIN').AsString) = ConvertDate('31/12/9999') then
          FArtLot.FieldByName('LOT_PERM').AsInteger     := 1
        else
          FArtLot.FieldByName('LOT_PERM').AsInteger     := 0;
        FArtLot.FieldByName('LOT_DEBUT').AsDateTime     := ConvertDate(cds_PACKAG.FieldByName('DATE_DEB').AsString);
        FArtLot.FieldByName('LOT_FIN').AsDateTime       := ConvertDate(cds_PACKAG.FieldByName('DATE_FIN').AsString);
        FArtLot.FieldByName('LOT_PV').AsFloat           := ConvertFloat(cds_PACKAG.FieldByName('PVPACK').AsString);
        FArtLot.FieldByName('LOT_QTEVENTE').AsInteger   := 1;
        FArtLot.FieldByName('LOT_PXCENTRALE').AsInteger := Round(ConvertFloat(cds_PACKAG.FieldByName('PVPACK').AsString));
        FArtLot.Post();
      end;
      {$ENDREGION 'Table ARTLOT'}

      {$REGION 'Table ARTLOTMAG'}
      if not FArtLotMag.ClientDataset.Locate('LOT_NUMERO;LMG_MAGID',
        VarArrayOf([cds_PACKAG.FieldByName('CODE_PACK').AsString, MAG_ID]), []) then
      begin
        FArtLotMag.Append();
        FArtLotMag.FieldByName('LOT_NUMERO').AsString   := cds_PACKAG.FieldByName('CODE_PACK').AsString;
        FArtLotMag.FieldByName('LMG_MAGID').AsInteger   := MAG_ID;
        FArtLotMag.Post();
      end;
      {$ENDREGION 'Table ARTLOTMAG'}

      {$REGION 'Table ARTLOTGROUPE'}
      if not FArtLotGroupe.ClientDataset.Locate('LOT_NUMERO;LOG_NUMGRP',
        VarArrayOf([cds_PACKAG.FieldByName('CODE_PACK').AsString, cds_PACKAG.FieldByName('CODE_POSTE').AsString]), []) then
      begin
        FArtLotGroupe.Append();
        FArtLotGroupe.FieldByName('LOG_NUMGRP').AsString  := cds_PACKAG.FieldByName('CODE_POSTE').AsString;
        FArtLotGroupe.FieldByName('LOG_LIBGRP').AsString  := cds_PACKAG.FieldByName('LPOST').AsString;
        FArtLotGroupe.FieldByName('LOG_QTEGRP').AsInteger := cds_PACKAG.FieldByName('NBART').AsInteger;
        FArtLotGroupe.Post();
      end
      else begin
        FArtLotGroupe.Edit();
        FArtLotGroupe.FieldByName('LOG_QTEGRP').AsInteger := FArtLotGroupe.FieldByName('LOG_QTEGRP').AsInteger
          + cds_PACKAG.FieldByName('NBART').AsInteger;
        FArtLotGroupe.Post();
      end;
      {$ENDREGION 'Table ARTLOTGROUPE'}

      // Récupère les informations sur l'article de la ligne
      Article := GetCodeArticle(cds_PACKAG.FieldByName('CODEARTSAP').AsString);

      {$REGION 'Table ARTLOTLIGNE'}
      if not FArtLotLigne.ClientDataset.Locate('LOG_NUMGRP',
        cds_PACKAG.FieldByName('CODE_POSTE').AsString, []) then
      begin
        FArtLotLigne.Append();
        FArtLotLigne.FieldByName('LOG_NUMGRP').AsString   := cds_PACKAG.FieldByName('CODE_POSTE').AsString;
        FArtLotLigne.FieldByName('LOL_LOTID').AsInteger   := 0;
        FArtLotLigne.FieldByName('LOL_ARTID').AsInteger   := Article.ART_ID;
        FArtLotLigne.Post();
      end
      else begin
        FArtLotLigne.Edit();
        FArtLotLigne.FieldByName('LOL_ARTID').AsInteger   := Article.ART_ID;
        FArtLotLigne.Post();
      end;
      {$ENDREGION 'Table ARTLOTLIGNE'}

      {$REGION 'Table ARTLOTDETAIL'}
      if not FArtLotDetail.ClientDataset.Locate('LOG_NUMGRP',
         cds_PACKAG.FieldByName('CODE_POSTE').AsString, []) then
      begin
        FArtLotDetail.Append();
        FArtLotDetail.FieldByName('LOG_NUMGRP').AsString  := cds_PACKAG.FieldByName('CODE_POSTE').AsString;
        FArtLotDetail.FieldByName('LCT_COUID').AsInteger  := Article.COU_ID;
        FArtLotDetail.FieldByName('LCT_TGFID').AsInteger  := Article.TGF_ID;
        FArtLotDetail.Post();
      end
      else begin
        FArtLotDetail.Edit();
        FArtLotDetail.FieldByName('LCT_COUID').AsInteger  := Article.COU_ID;
        FArtLotDetail.FieldByName('LCT_TGFID').AsInteger  := Article.TGF_ID;
        FArtLotDetail.Post();
      end;
      {$ENDREGION 'Table ARTLOTDETAIL'}

      except
        on E: Exception do
        begin
          FCds.Cancel();
          Erreur := TErreur.Create();
          Erreur.AddError(FFileImport, 'Importation',
            Format('[%s] : %s', [E.ClassName, E.Message]),
          cds_PACKAG.RecNo, tePackage, 0, '');
          GERREURS.Add(Erreur);
          IncError ;
        end;
      end;

      cds_PACKAG.Next();
      BarPosition(cds_PACKAG.RecNo * 100 div cds_PACKAG.RecordCount);
    end;
  end;
end;

function TPackage.DoMajTable(): Boolean;
var
  ArtLot        : TArtLot;
  ArtLotMag     : TArtLotMag;
  ArtLotGroupe  : TArtLotGroupe;
  ArtLotLigne   : TArtLotLigne;
  ArtLotDetail  : TArtLotDetail;
  Erreur        : TErreur;
  i, iIndex     : Integer;
begin
  {$REGION 'Traitement des lots'}
  FArtLot.First();
  while not FArtLot.EOF() do
  begin
    FIboQuery.IB_Transaction.StartTransaction();
    try
      {$REGION 'Table ARTLOT'}
      try
        ArtLot := SetArtLot(
          FArtLot.FieldByName('LOT_NOM').AsString,
          FArtLot.FieldByName('LOT_NUMERO').AsString,
          FArtLot.FieldByName('LOT_LIBELLE').AsString,
          FArtLot.FieldByName('LOT_PERM').AsInteger,
          FArtLot.FieldByName('LOT_DEBUT').AsDateTime,
          FArtLot.FieldByName('LOT_FIN').AsDateTime,
          FArtLot.FieldByName('LOT_PV').AsFloat,
          FArtLot.FieldByName('LOT_TYPID').AsInteger,
          FArtLot.FieldByName('LOT_QTEVENTE').AsInteger,
          FArtLot.FieldByName('LOT_PXCENTRALE').AsInteger);
      except
        on E: Exception do
          raise Exception.Create(Format('Lots (ARTLOT) %s - [%s] : %s',
            [FArtLot.FieldByName('LOT_NUMERO').AsString, E.ClassName, E.Message]));
      end;
      {$ENDREGION 'Table ARTLOT'}

      {$REGION 'Table ARTLOTMAG'}
      FArtLotMag.First();
      while not FArtLotMag.EOF() do
      begin
        try
          ArtLotMag := SetArtLotMag(
            FArtLotMag.FieldByName('LOT_NUMERO').AsString,
            ArtLot.LOT_ID,
            FArtLotMag.FieldByName('LMG_MAGID').AsInteger);

          // Met à jour le ClientDataSet
          FArtLotMag.Edit();
          FArtLotMag.FieldByName('LMG_ID').AsInteger          := ArtLotMag.LMG_ID;
          FArtLotMag.FieldByName('LMG_LOTID').AsInteger       := ArtLotMag.LMG_LOTID;
          FArtLotMag.FieldByName('Created').AsBoolean         := ArtLotMag.bCreer;
          FArtLotMag.Post();
        except
          on E: Exception do
            raise Exception.Create(Format('Lots (ARTLOTMAG) %s - [%s] : %s',
              [FArtLot.FieldByName('LOT_NUMERO').AsString, E.ClassName, E.Message]));
        end;

        FArtLotMag.Next();
      end;
      {$ENDREGION 'Table ARTLOTMAG'}

      {$REGION 'Tables ARTLOTGROUPE, ARTLOTLIGNE et ARTLOTDETAIL'}
      FArtLotGroupe.First();
      while not FArtLotGroupe.EOF() do
      begin
        try
          ArtLotGroupe := SetArtLotGroupe(
            FArtLotGroupe.FieldByName('LOT_NUMERO').AsString,
            ArtLot.LOT_ID,
            FArtLotGroupe.FieldByName('LOG_NUMGRP').AsString,
            FArtLotGroupe.FieldByName('LOG_LIBGRP').AsString,
            FArtLotGroupe.FieldByName('LOG_QTEGRP').AsInteger);

          // Met à jour le ClientDataSet
          FArtLotGroupe.Edit();
          FArtLotGroupe.FieldByName('LOG_ID').AsInteger       := ArtLotGroupe.LOG_ID;
          FArtLotGroupe.FieldByName('LOG_LOTID').AsInteger    := ArtLotGroupe.LOG_LOTID;
          FArtLotGroupe.FieldByName('LOG_NUMGRP').AsString    := ArtLotGroupe.LOG_NUMGRP;
          FArtLotGroupe.FieldByName('Created').AsBoolean      := ArtLotGroupe.bCreer;
          FArtLotGroupe.Post();


          {$REGION 'Tables ARTLOTLIGNE et ARTLOTDETAIL'}
          FArtLotLigne.First();
          while not FArtLotLigne.EOF() do
          begin
            try
              {$REGION 'Mise en mémoire des lignes'}
              with FIboQuery do
              begin
                Close();
                SQL.Clear();
                SQL.Add('SELECT LOL_ID, LOL_LOGID');
                SQL.Add('FROM   ARTLOTLIGNE');
                SQL.Add('  JOIN K ON (K_ID = LOL_ID AND K_ENABLED = 1)');
                SQL.Add('WHERE  LOL_LOGID = :PLOLLOGID');
                ParamCheck := True;
                ParamByName('PLOLLOGID').AsInteger  := ArtLotGroupe.LOG_ID;
                ExecSQL();

                FArtLotLigneLoad.ClientDataset.EmptyDataSet();
                while not EOF do
                begin
                  FArtLotLigneLoad.Append();
                  FArtLotLigneLoad.FieldByName('LOL_ID').AsInteger      := FieldByName('LOL_ID').AsInteger;
                  FArtLotLigneLoad.FieldByName('LOL_LOGID').AsInteger   := FieldByName('LOL_LOGID').AsInteger;
                  FArtLotLigneLoad.FieldByName('CANDELETE').AsInteger   := 1;
                  FArtLotLigneLoad.Post();
                  Next();
                end;
              end;
              {$ENDREGION 'Mise en mémoire des lignes'}

              ArtLotLigne := SetArtLotLigne(
                ArtLotGroupe.LOG_NUMGRP,
                ArtLotGroupe.LOG_LOTID,
                ArtLotGroupe.LOG_ID,
                FArtLotLigne.FieldByName('LOL_ARTID').AsInteger);

              // Met à jour le ClientDataSet
              FArtLotLigne.Edit();
              FArtLotLigne.FieldByName('LOL_ID').AsInteger      := ArtLotLigne.LOL_ID;
              FArtLotLigne.FieldByName('LOL_LOTID').AsInteger   := ArtLotLigne.LOL_LOTID;
              FArtLotLigne.FieldByName('LOL_LOGID').AsInteger   := ArtLotLigne.LOL_LOGID;
              FArtLotLigne.FieldByName('Created').AsBoolean     := ArtLotLigne.bCreer;
              FArtLotLigne.Post();
              
              // Indique qu'il ne faut pas supprimer la ligne
              if FArtLotLigneLoad.ClientDataset.Locate('LOL_ID', ArtLotLigne.LOL_ID, []) then
              begin
                FArtLotLigneLoad.Edit();
                FArtLotLigneLoad.FieldByName('CANDELETE').AsInteger  := 0;
                FArtLotLigneLoad.Post();
              end;              

              {$REGION 'Table ARTLOTDETAIL'}
              FArtLotDetail.First();
              while not FArtLotDetail.EOF() do
              begin
                try
                  {$REGION 'Mise en mémoire des détails'}
                  with FIboQuery do
                  begin
                    Close();
                    SQL.Clear();
                    SQL.Add('SELECT LCT_ID, LCT_LOLID');
                    SQL.Add('FROM   ARTLOTDETAIL');
                    SQL.Add('  JOIN K ON (K_ID = LCT_ID AND K_ENABLED = 1)');
                    SQL.Add('WHERE  LCT_LOLID = :PLCTLOGID');
                    ParamCheck := True;
                    ParamByName('PLCTLOGID').AsInteger  := ArtLotLigne.LOL_ID;
                    ExecSQL();

                    FArtLotDetailLoad.ClientDataset.EmptyDataSet();
                    while not EOF do
                    begin
                      FArtLotDetailLoad.Append();
                      FArtLotDetailLoad.FieldByName('LCT_ID').AsInteger      := FieldByName('LCT_ID').AsInteger;
                      FArtLotDetailLoad.FieldByName('LCT_LOLID').AsInteger   := FieldByName('LCT_LOLID').AsInteger;
                      FArtLotDetailLoad.FieldByName('CANDELETE').AsInteger   := 1;
                      FArtLotDetailLoad.Post();
                      Next();
                    end;
                  end;
                  {$ENDREGION 'Mise en mémoire des détails'}

                  ArtLotDetail := SetArtLotDetail(
                    ArtLotGroupe.LOG_NUMGRP,
                    ArtLotLigne.LOL_ID,
                    FArtLotDetail.FieldByName('LCT_COUID').AsInteger,
                    FArtLotDetail.FieldByName('LCT_TGFID').AsInteger);

                  // Met à jour le ClientDataSet
                  FArtLotDetail.Edit();
                  FArtLotDetail.FieldByName('LCT_ID').AsInteger     := ArtLotDetail.LCT_ID;
                  FArtLotDetail.FieldByName('LCT_LOLID').AsInteger  := ArtLotDetail.LCT_LOLID;
                  FArtLotDetail.FieldByName('Created').AsBoolean    := ArtLotDetail.bCreer;
                  FArtLotDetail.Post();

                  // Indique qu'il ne faut pas supprimer le détail
                  if FArtLotDetailLoad.ClientDataset.Locate('LCT_ID', ArtLotDetail.LCT_ID, []) then
                  begin
                    FArtLotDetailLoad.Edit();
                    FArtLotDetailLoad.FieldByName('CANDELETE').AsInteger  := 0;
                    FArtLotDetailLoad.Post();
                  end;
                except
                  on E: Exception do
                    raise Exception.Create(Format('Lots (ARTLOTDETAIL) %s - [%s] : %s',
                      [FArtLot.FieldByName('LOT_NUMERO').AsString, E.ClassName, E.Message]));
                end;

                FArtLotDetail.Next();
              end;

              {$REGION 'Mise en purge des détails'}
              with FArtLotDetailLoad do
              begin
                // Parcours tous les détails à supprimer
                First();
                ClientDataset.Filtered  := False;
                ClientDataset.Filter    := 'CANDELETE = 1';
                ClientDataset.Filtered  := True;

                while not EOF() do
                begin
                  FArtLotDetailPurge.Append();
                  for i := 0 to ClientDataset.FieldCount - 1 do
                  begin
                    // Copie le champ d'un ClientDataSet à l'autre en vérifiant s'il existe dans le CDS de destination
                    iIndex := FArtLotDetailPurge.ClientDataset.FieldList.IndexOf(ClientDataset.Fields[i].FieldName);
                    if iIndex > -1 then
                      FArtLotDetailPurge.ClientDataset.Fields[iIndex] := ClientDataset.Fields[i];
                  end;
                  FArtLotDetailPurge.Post();
                  Next();
                end;

                ClientDataset.Filtered  := False;
              end;
              {$ENDREGION 'Mise en purge des détails'}
              {$ENDREGION 'Table ARTLOTDETAIL'}
            except
              on E: Exception do
                raise Exception.Create(Format('Lots (ARTLOTLIGNE) %s - [%s] : %s',
                  [FArtLot.FieldByName('LOT_NUMERO').AsString, E.ClassName, E.Message]));
            end;

            FArtLotLigne.Next();
          end;

          {$REGION 'Mise en purge des lignes'}
          with FArtLotLigneLoad do
          begin
            // Parcours toutes les lignes à supprimer
            First();
            ClientDataset.Filtered  := False;
            ClientDataset.Filter    := 'CANDELETE = 1';
            ClientDataset.Filtered  := True;

            while not EOF() do
            begin
              FArtLotLignePurge.Append();
              for i := 0 to ClientDataset.FieldCount - 1 do
              begin
                // Copie le champ d'un ClientDataSet à l'autre en vérifiant s'il existe dans le CDS de destination
                iIndex := FArtLotLignePurge.ClientDataset.FieldList.IndexOf(ClientDataset.Fields[i].FieldName);
                if iIndex > -1 then
                  FArtLotLignePurge.ClientDataset.Fields[iIndex] := ClientDataset.Fields[i];
              end;
              FArtLotLignePurge.Post();
              Next();
            end;
          end;
          {$ENDREGION 'Mise en purge des lignes'}
          {$ENDREGION 'Tables ARTLOTLIGNE et ARTLOTDETAIL'}
        except
          on E: Exception do
            raise Exception.Create(Format('Lots (ARTLOTGROUPE) %s - [%s] : %s',
              [FArtLot.FieldByName('LOT_NUMERO').AsString, E.ClassName, E.Message]));
        end;

        FArtLotGroupe.Next();
      end;

      {$ENDREGION 'Tables ARTLOTGROUPE, ARTLOTLIGNE et ARTLOTDETAIL'}

      FIboQuery.IB_Transaction.Commit();
    except
      on E: Exception do
      begin
        FIboQuery.IB_Transaction.Rollback();
        Erreur := TErreur.Create();
        Erreur.AddError('', 'Intégration', Format('[%s] : %s', [E.ClassName, E.Message]),
          0, tePackage, 0, '');
        GERREURS.Add(Erreur);
        IncError ;
      end;
    end;

    FArtLot.Next();
    BarPosition(FArtLot.ClientDataset.RecNo * 100 div FArtLot.ClientDataset.RecordCount);
  end;

  {$REGION 'Purge des données'}
  // Suppression des détails
  LabCaption('Purge des données : Détails des lots');
  with FArtLotDetailPurge do
  begin
    First();
    BarPosition(0);

    while not EOF() do
    begin
      DelArtLotDetail(FieldByName('LCT_ID').AsInteger);
      Next();
      BarPosition(ClientDataset.RecNo * 100 div ClientDataset.RecordCount);
    end;
  end;

  // Suppression des lignes
  LabCaption('Purge des données : Lignes des lots');
  with FArtLotLignePurge do
  begin
    First();
    BarPosition(0);

    while not EOF() do
    begin
      DelArtLotLigne(FieldByName('LOL_ID').AsInteger);
      Next();
      BarPosition(ClientDataset.RecNo * 100 div ClientDataset.RecordCount);
    end;
  end;
  {$ENDREGION 'Purge des données'}

  {$ENDREGION 'Traitement des lots'}
end;

end.
