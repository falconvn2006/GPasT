unit MainImport_DM;

interface

uses
  SysUtils, Classes, DB, DBClient, Midaslib, IBStoredProc, IBQuery,
  IBCustomDataSet, IBDatabase;

type
  TCBIdent = record
    OLD_CB ,
    NEW_CB : String;
    ART_ID ,
    TGF_ID ,
    COU_ID : Integer;
  end;


  TDM_MainImport = class(TDataModule)
    cds_Forfait: TClientDataSet;
    cds_ForfaitLigne: TClientDataSet;
    cds_PT1: TClientDataSet;
    cds_ForfaitFOR_ID: TIntegerField;
    cds_ForfaitFOR_NOM: TStringField;
    cds_ForfaitFOR_PRIX: TFloatField;
    cds_ForfaitFOR_DUREE: TFloatField;
    cds_ForfaitNEW_FORID: TIntegerField;
    cds_ForfaitLigneFOL_ID: TIntegerField;
    cds_ForfaitLigneCBI_CB: TStringField;
    cds_ForfaitLigneFOL_QTE: TIntegerField;
    cds_ForfaitLigneFOL_FORID: TIntegerField;
    cds_ForfaitLigneNEW_FOLID: TIntegerField;
    cds_PT2: TClientDataSet;
    cds_TauxH: TClientDataSet;
    cds_PT1PT1_ID: TIntegerField;
    cds_PT1PT1_PICTO: TStringField;
    cds_PT1PT1_ORDREAFF: TIntegerField;
    cds_PT1PT1_NOM: TStringField;
    cds_PT1NEW_PT1ID: TIntegerField;
    cds_PT2PT2_ID: TIntegerField;
    cds_PT2PT2_NOM: TStringField;
    cds_PT2PT2_FORFAIT: TIntegerField;
    cds_PT2PT2_FORID: TIntegerField;
    cds_PT2PT2_DUREE: TFloatField;
    cds_PT2PT2_PICTO: TStringField;
    cds_PT2PT2_ORDREAFF: TIntegerField;
    cds_PT2PT2_LIBELLE: TStringField;
    cds_PT2NEW_PT2ID: TIntegerField;
    cds_TauxHTXH_ID: TIntegerField;
    cds_TauxHTXH_NOM: TStringField;
    cds_TauxHTXH_PRIX: TFloatField;
    cds_TauxHNEW_TXHID: TIntegerField;
    cds_PT2PT2_PT1ID: TIntegerField;
    cds_SavTypMat: TClientDataSet;
    cds_SavMat: TClientDataSet;
    cds_SavMatMAT_ID: TIntegerField;
    cds_SavMatMAT_CLTID: TIntegerField;
    cds_SavMatMAT_MRKID: TIntegerField;
    cds_SavMatMAT_ARTID: TIntegerField;
    cds_SavMatMAT_NOM: TStringField;
    cds_SavMatMAT_SERIE: TStringField;
    cds_SavMatMAT_COULEUR: TStringField;
    cds_SavMatMAT_COMMENT: TStringField;
    cds_SavMatMAT_DATEACHAT: TDateTimeField;
    cds_SavMatMAT_ARCHIVER: TIntegerField;
    cds_SavMatMAT_REFMRK: TStringField;
    cds_SavMatMAT_CHRONO: TStringField;
    cds_SavMatNEW_MATID: TIntegerField;
    cds_SavTypMatTYM_ID: TIntegerField;
    cds_SavTypMatTYM_NOM: TStringField;
    cds_SavTypMatNEW_TYMID: TIntegerField;
    cds_SavFicheE: TClientDataSet;
    cds_SavFicheESAV_ID: TIntegerField;
    cds_SavFicheESAV_CLTID: TIntegerField;
    cds_SavFicheESAV_MATID: TIntegerField;
    cds_SavFicheESAV_CHRONO: TStringField;
    cds_SavFicheESAV_DTCREATION: TDateTimeField;
    cds_SavFicheESAV_DEBUT: TDateTimeField;
    cds_SavFicheESAV_FIN: TDateTimeField;
    cds_SavFicheESAV_REMNO: TFloatField;
    cds_SavFicheESAV_REMART: TFloatField;
    cds_SavFicheESAV_REM: TFloatField;
    cds_SavFicheESAV_IDENT: TStringField;
    cds_SavFicheESAV_USRID: TIntegerField;
    cds_SavFicheESAV_LIMITE: TDateTimeField;
    cds_SavFicheESAV_MAGID: TIntegerField;
    cds_SavFicheESAV_ETAT: TIntegerField;
    cds_SavFicheESAV_DATEREPRISE: TDateTimeField;
    cds_SavFicheESAV_DATEPLANNING: TDateTimeField;
    cds_SavFicheESAV_COMMENT: TStringField;
    cds_SavFicheESAV_ORDREAFF: TIntegerField;
    cds_SavFicheESAV_DUREEGLOB: TIntegerField;
    cds_SavFicheESAV_DUREE: TFloatField;
    cds_SavFicheESAV_PXTAUX: TFloatField;
    cds_SavFicheESAV_USRIDENCHARGE: TIntegerField;
    cds_SavFicheESAV_PLACE: TStringField;
    cds_SavFicheENEW_SAVID: TIntegerField;
    cds_SavType: TClientDataSet;
    cds_SavTypeSTY_ID: TIntegerField;
    cds_SavTypeSTY_NOM: TStringField;
    cds_SavTypeNEW_STYID: TIntegerField;
    cds_SavFicheL: TClientDataSet;
    cds_SavFicheLSAL_ID: TIntegerField;
    cds_SavFicheLSAL_SAVID: TIntegerField;
    cds_SavFicheLSAL_PT2ID: TIntegerField;
    cds_SavFicheLSAL_FORID: TIntegerField;
    cds_SavFicheLSAL_NOM: TStringField;
    cds_SavFicheLSAL_COMMENT: TStringField;
    cds_SavFicheLSAL_DUREE: TFloatField;
    cds_SavFicheLSAL_TXHID: TIntegerField;
    cds_SavFicheLSAL_REMISE: TFloatField;
    cds_SavFicheLSAL_PXTOT: TFloatField;
    cds_SavFicheLSAL_USRID: TIntegerField;
    cds_SavFicheLSAL_TERMINE: TIntegerField;
    cds_SavFicheLSAL_PXBRUT: TFloatField;
    cds_SavFicheLNEW_SALID: TIntegerField;
    cds_SavFicheArt: TClientDataSet;
    cds_SavFicheArtSAA_ID: TIntegerField;
    cds_SavFicheArtCBI_CB: TStringField;
    cds_SavFicheArtSAA_PU: TFloatField;
    cds_SavFicheArtSAA_REMISE: TFloatField;
    cds_SavFicheArtSAA_QTE: TIntegerField;
    cds_SavFicheArtSAA_SAVID: TIntegerField;
    cds_SavFicheArtSAA_PXTOT: TFloatField;
    cds_SavFicheArtSAA_SALID: TIntegerField;
    cds_SavFicheArtSAA_TYPID: TIntegerField;
    cds_SavFicheArtNEW_SAAID: TIntegerField;
    cds_SavFicheESAV_TXHID: TIntegerField;
    IBStProc_Tmp: TIBStoredProc;
    IBQue_Tmp: TIBQuery;
    cds_SavMatCBI_CB: TStringField;
    cds_PT2CBI_CB: TStringField;
    cds_SavMatMAT_TYMID: TIntegerField;
    cds_SavFicheESAV_STYID: TIntegerField;
    cds_PT2PT2_TXHID: TIntegerField;
    cds_SAVFICHEPC: TClientDataSet;
    cds_SAVPC: TClientDataSet;
    cds_SAVPCL: TClientDataSet;
    cds_SAVFICHEPCSPC_ID: TIntegerField;
    cds_SAVFICHEPCSPC_PCEID: TIntegerField;
    cds_SAVFICHEPCSPC_PCLID: TIntegerField;
    cds_SAVFICHEPCSPC_SAVID: TIntegerField;
    cds_SAVFICHEPCNEW_SPCID: TIntegerField;
    cds_SAVPCPCE_ID: TIntegerField;
    cds_SAVPCPCE_NOM: TStringField;
    cds_SAVPCPCE_ACTIF: TIntegerField;
    cds_SAVPCNEW_PCEID: TIntegerField;
    cds_SAVPCLPCL_ID: TIntegerField;
    cds_SAVPCLPCL_PCEID: TIntegerField;
    cds_SAVPCLPCL_NOM: TStringField;
    cds_SAVPCLNEW_PCLID: TIntegerField;
    cds_SavMatMRK_NOM: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    FDatabase: TIBDatabase;
    FTransaction: TIBTransaction;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property Database : TIBDatabase read FDatabase write FDatabase;
    property Transaction : TIBTransaction read FTransaction write FTransaction;


    function GetNewKID(ATableName : String) : Integer;
    function UpdateKId(AK_ID : Integer; ASupprime : integer = 0) : Boolean;
    function GetMrkId( AMRK_NOM : String) : Integer;

    function GetCbInfo(ACB : String) : TCBIdent; 

    function GetNewClientId(AOldIdClient : Integer) : Integer;
    function GetNewUsrId(AOldUSrId : Integer) : Integer;
  end;

var
  DM_MainImport: TDM_MainImport;

implementation

{$R *.dfm}

{ TDM_MainImport }

procedure TDM_MainImport.DataModuleCreate(Sender: TObject);
begin
  IBQue_Tmp.Database := FDatabase;
  IBStProc_Tmp.Database := FDatabase;
end;

function TDM_MainImport.GetCbInfo(ACB: String): TCBIdent;
begin
  With IBQue_Tmp do
  begin
    // Recherche du CB dans la base de données tremporaire
    try
      Close;
      Database := FDatabase;
      SQL.Clear;
      SQL.Add('Select NEW_CBICB from TMPIMPGENE_ART');
      SQL.Add('Where OLD_CBICB = :PCBICB');
      ParamCheck := True;
      ParamByName('PCBICB').AsString := Trim(ACB);
      Open;
    Except on E:Exception do
      raise Exception.Create('GetCbInfo TMP -> ' + E.Message);
    end;

    if RecordCount = 0 then
    try
      // On recherche si le CB existe pas déja en type 1 cas du référencement
      Close;
      SQL.Clear;
      SQL.Add('Select CBI_CB as NEW_CBICB from ARTCODEBARRE');
      SQL.Add('  join K on K_ID = CBI_ID and K_Enabled = 1');
      SQL.Add('Where CBI_CB = :PCBICB');
      SQL.ADd('  and CBI_TYPE = 1');
      ParamCheck := True;
      ParamByName('PCBICB').AsString := Trim(ACB);
      Open;

      if RecordCount = 0 then
        raise Exception.Create('Ancien code à barres non trouvé : ' + ACB);

    Except on E:Exception do
      raise Exception.Create('GetCbInfo ARTCB -> ' + E.Message);
    end;

    Result.NEW_CB := FieldByName('NEW_CBICB').AsString;

    // Récupération des informations sur le CB
    try
      Close;
      SQL.Clear;
      SQL.Add('Select ARF_ARTID, CBI_TGFID, CBI_COUID from ARTCODEBARRE');
      SQL.Add('  join K on K_ID = CBI_ID and K_Enabled = 1');
      SQL.Add('  join ARTREFERENCE on ARF_ID = CBI_ARFID');
      SQL.Add('Where CBI_TYPE = 1');
      sQL.Add('  and CBI_CB = :PCBICB');
      ParamCheck := True;
      ParamByName('PCBICB').AsString := Result.NEW_CB;
      Open;
    Except on E:Exception do
      raise Exception.Create('GetCbInfo FIND -> ' + E.Message);
    end;

    if RecordCount = 0 then
      raise Exception.Create('Nouveau code à barre non trouvé : ' + Result.NEW_CB);

    Result.ART_ID := FieldByName('ARF_ARTID').AsInteger;
    Result.TGF_ID := FieldByName('CBI_TGFID').AsInteger;
    Result.COU_ID := FieldByName('CBI_COUID').AsInteger;

  end;
end;

function TDM_MainImport.GetMrkId(AMRK_NOM: String): Integer;
begin
  if Trim(AMRK_NOM) <> '' then
  begin
    With IBQue_Tmp do
    begin
      Close;
      Database := FDatabase;
      SQL.Clear;
      SQL.Add('Select MRK_ID from ARTMARQUE');
      SQL.Add('  join K on K_ID = MRK_ID and K_Enabled = 1');
      SQL.Add('Where Upper(MRK_NOM) = :PMRKNOM');
      ParamCheck := True;
      ParamByName('PMRKNOM').AsString := UpperCase(AMRK_NOM);
      Open;
      if REcordCount > 0 then
        Result := FieldByName('MRK_ID').AsInteger
      else
        Result := -1;
    end;
  end
  else
    Raise Exception.Create('GetMrkId -> Pas de marque');
end;

function TDM_MainImport.GetNewClientId(AOldIdClient: Integer): Integer;
begin
  With IBQue_Tmp do
  begin
    Try
      Close;
      Database := FDatabase;
      SQL.Clear;
      SQL.Add('Select NEW_CLTID from TMPIMPGENE_CLIENT');
      SQL.Add('Where OLD_CLTID = :POLDCLTID');
      ParamCheck := True;
      ParamByName('POLDCLTID').AsInteger := AOldIdClient;
      Open;
    Except on E:Exception do
      raise Exception.Create('GetNewClientId -> ' + E.Message);
    end;

    if Recordcount = 0 then
      raise Exception.Create('Id client non trouvé ' + IntToStr(AOldIdClient));

    Result := FieldByName('NEW_CLTID').AsInteger;
  end;// with
end;

function TDM_MainImport.GetNewKID(ATableName: String): Integer;
begin
  With IBQue_Tmp do
  Try
    Close;
    Database := FDatabase;
  //  StoredProcName := 'PR_NEWK';
    SQL.Clear;
    SQL.Add('Select ID From PR_NEWK(:PTABLENAME)');
    ParamCheck := True;
    ParamByName('PTABLENAME').AsString := ATableName;
    Open;

    Result := FieldByName('ID').AsInteger;
    Close;
  Except on E:Exception do
    raise Exception.Create('GetNewKID -> ' + E.Message);
  End;
end;

function TDM_MainImport.GetNewUsrId(AOldUSrId: Integer): Integer;
begin
  if AOldUSrId = 0 then
  begin
    Result := 0;
    Exit;
  end;

  With IBQue_Tmp do
  try
    Close;
    Database := FDatabase;
    SQL.Clear;
    SQL.Add('Select NEW_USRID from TMPIMPGENE_USR');
    SQL.Add('Where OLD_USRID = :PUSRID');
    ParamCheck := True;
    ParamByName('PUSRID').AsInteger := AOldUSrId;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('NEW_USRID').AsInteger
    else
      raise Exception.Create('User non trouvé ' + IntToStr(AOldUSrId));
  Except on E:Exception do
    raise Exception.Create('GetNewUsrId -> ' + E.Message);
  end;
end;

function TDM_MainImport.UpdateKId(AK_ID, ASupprime: integer): Boolean;
begin
  Result := False;
  With IBQue_Tmp do
  try
    Close;
    Database := FDatabase;
    SQL.Clear;
    SQL.Add('Execute procedure PR_UPDATEK(:PKID,:PSUPP)');
    ParamCheck := True;
    ParamByName('PKID').AsInteger := AK_ID;
    ParamByName('PSUPP').AsInteger := ASupprime;
    ExecSQL;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('UpdateKId -> ' + E.Message);
  End;

end;

end.
