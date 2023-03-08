unit ImportClient_Dm;

interface

uses
  SysUtils, Classes, uCommon, DB, ADODB, IBCustomDataSet, IBQuery, Math, uLog;

type
  TDm_ImportClient = class(TDataModule)
    QueClient: TIBQuery;
    QueClientCLT_ID: TIntegerField;
    QueClientCLT_NOM: TIBStringField;
    QueClientCLT_PRENOM: TIBStringField;
    QueClientCIV_NOM: TIBStringField;
    QueClientADR1: TIBStringField;
    QueClientADR2: TIBStringField;
    QueClientADR3: TIBStringField;
    QueClientVIL_CP: TIBStringField;
    QueClientVIL_NOM: TIBStringField;
    QueClientPAY_NOM: TIBStringField;
    QueClientADR_TEL: TIBStringField;
    QueClientADR_GSM: TIBStringField;
    QueClientADR_FAX: TIBStringField;
    QueClientADR_EMAIL: TIBStringField;
    QueClientCLT_OPINSMS: TIntegerField;
    QueClientCLT_OPTINEMAIL: TIntegerField;
    QueClientCLT_NIVEXPLOIT: TIntegerField;
    QueClientFIDELITE: TIntegerField;
    AdQueClient: TADOQuery;
    AdQueClientCLT_ID: TAutoIncField;
    AdQueClientCLT_DOSID: TIntegerField;
    AdQueClientCLT_IDORIGINE: TIntegerField;
    AdQueClientCLT_CIV: TStringField;
    AdQueClientCLT_NOM: TStringField;
    AdQueClientCLT_PRENOM: TStringField;
    AdQueClientCLT_ADR1: TStringField;
    AdQueClientCLT_ADR2: TStringField;
    AdQueClientCLT_ADR3: TStringField;
    AdQueClientCLT_CP: TStringField;
    AdQueClientCLT_VILLE: TStringField;
    AdQueClientCLT_PAYS: TStringField;
    AdQueClientCLT_TEL1: TStringField;
    AdQueClientCLT_TEL2: TStringField;
    AdQueClientCLT_TEL3: TStringField;
    AdQueClientCLT_MAIL: TStringField;
    AdQueClientCLT_OPTINSMS: TIntegerField;
    AdQueClientCLT_OPTINMAIL: TIntegerField;
    AdQueClientCLT_TRAITE: TIntegerField;
    AdQueClientCLT_AUTORISATION: TIntegerField;
    AdQueTmp: TADOQuery;
    queTmp: TIBQuery;
    QueClientK_ENABLED: TIntegerField;
    Ps_Client: TADOStoredProc;
    QueClientKVERSION: TIntegerField;
    QueClientKV1: TIntegerField;
    QueClientKV2: TIntegerField;
    QueClientKV3: TIntegerField;
    QueClientKV4: TIntegerField;
    QueClientKV5: TIntegerField;
    QueClientKCB: TIntegerField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function doImportClient(aBasePath, aMagCodeAdh: String; aDossId, aDbMagId, aExtractLastK: Int64): boolean;
  end;

var
  Dm_ImportClient: TDm_ImportClient;

implementation

{$R *.dfm}

uses ExtractDatabase_Dm ;

function TDm_ImportClient.doImportClient(aBasePath, aMagCodeAdh: String; aDossId, aDbMagId, aExtractLastK: Int64): boolean;
var
  vCltId : Int64 ;
  vExtractLastK, vMaxK, vCheckK : Int64 ;
  AString1, AString2 : String;
  I, J, K, L : Integer;
  IsOK : Boolean;

  procedure doInsertHisto(aMsg : string) ;
  begin
    Dm_ExtractDatabase.ADODatabase.BeginTrans;
    try
      Dm_ExtractDatabase.InsertHisto(0, ADbMagId, 0, 0, 0, 0, Now(), Now(), aMsg);
      Dm_ExtractDatabase.ADODatabase.CommitTrans;
    except
      Dm_ExtractDatabase.ADODatabase.RollbackTrans ;
    end;
  end;

begin
  Result := False ;

  LogAction('Import des Clients', logInfo);

  if aBasePath = '' then
  begin
    doInsertHisto('Base Ginkoia non paramétrée') ;
    Exit;
  end;

  LogAction('Connexion base Ginkoia ' + aBasePAth, logInfo);
  Dm_ExtractDatabase.Ginkoia.Close;
  Dm_ExtractDatabase.Ginkoia.DatabaseName := aBasePath ;
  try
    Dm_ExtractDatabase.Ginkoia.Open;
  except
    LogAction(AMagCodeAdh + ' : Connection Ginkoia échouée - ' + aBasePath, logError);
    doInsertHisto('Connexion à la base Ginkoia impossible : ' + aBasePath) ;
    Exit ;
  end;

  {$REGION 'Vérification de l''existance des tables'}
  queTmp.Close;
  queTmp.SQL.Clear;
  queTmp.SQL.Add('select distinct count(*) as Resultat from rdb$RELATION_FIELDS');
  queTmp.SQL.Add('where RDB$VIEW_CONTEXT is null');
  queTmp.SQL.Add('and RDB$SYSTEM_FLAG = 0');
  queTmp.SQL.Add('and RDB$RELATION_NAME = ''CLTCLIENT''');
  queTmp.SQL.Add('GROUP BY  RDB$RELATION_NAME;');
  queTmp.Open;

  if queTmp.FieldByName('Resultat').AsInteger = 0 then
  begin
    LogAction('Annulation du traitement : Table client non présente en base ???', logInfo);
    Exit;
  end;

  {$ENDREGION}


  {$REGION 'Vérification de la version base , doit etre >= 15.2'}
  queTmp.Close;
  queTmp.SQL.Clear;
  queTmp.SQL.Add('SELECT VER_VERSION FROM GENVERSION' +
                 ' WHERE VER_DATE = (SELECT max(Ver_DATE) from GENVERSION)');
  queTmp.Open;
  IsOK := True;
  AString1 := queTmp.FieldByName('VER_VERSION').AsString;
  I := Pos('.',AString1);
  AString2 := copy(AString1,I+1,length(AString1)-I);
  J := Pos('.',AString2);

  K := StrToIntDef(Copy(AString1,1,I-1),0);
  L := StrToIntDef(Copy(AString2,1,J-1),0);

  if K < 15
  then IsOK := False
  else
    if (K = 15) and (L < 2)
    then IsOK := False;

  if IsOK = False then
  begin
    LogAction('Annulation du traitement : version Base < 15.2', logInfo);
    Exit;
  end;
  {$ENDREGION}



  try
    // Récupération des Clients d'un magasin lame base client (ceux qui ont leur K_Version > aExtractLastK)
    // Les clients en retours sont ordrés suivant le K_Version par ordre croissant
    queClient.Close ;
    queClient.ParamByName('MAGCODEADH').asString := aMagCodeAdh ;
    queClient.ParamByName('EXTRACTLASTK').asInteger := aExtractLastK;
    queClient.Open ;

    // Ajouts / modifs de Clients
    // récupération du dernier K_Version mémorisé dans le serveur SP2K (champ MAG_EXTRACTCLTLASTK)
    vExtractLastK := aExtractLastK;
    // On balaie les clients du magasin
    while not QueClient.Eof do
    begin

      vCheckK := MaxIntValue([QueClient.FieldByName('KV1').AsInteger,QueClient.FieldByName('KV2').AsInteger,
                              QueClient.FieldByName('KV3').AsInteger,QueClient.FieldByName('KV4').AsInteger,
                              QueClient.FieldByName('KV5').AsInteger, QueClient.FieldByName('KCB').AsInteger]);

      // si le K_VERSION du clients est plus récent (valeur plus grande) que celui mémorisé, on traite ce client
      if vCheckK > vExtractLastK then
      begin
        vCltId  := queClient.FieldByName('CLT_ID').AsInteger ;
        // Ce client a-til déjà été importé dans le serveur base SP2K, si oui on récupère le CLT_ID
        AdQueClient.Close ;
        AdQueClient.ParamCheck := true ;
        AdQueClient.Parameters.ParamValues['DOSID'] := aDossId ;
        AdQueClient.Parameters.ParamValues['IDORIGINE'] := vCltId ;
        AdQueClient.Open ;
        if not AdQueClient.Eof
        then Ps_Client.Parameters.ParamByName('@R_CLTID').Value := AdQueClient.FieldByName('CLT_ID').AsInteger
        else Ps_Client.Parameters.ParamByName('@R_CLTID').Value := 0;
        Ps_Client.Parameters.ParamByName('@P_CLTDOSID').Value := aDossId;
        // Ce champ mémorise le CLT_ID de la lame base client ginkoia
        Ps_Client.Parameters.ParamByName('@P_CLTIDORIGINE').Value := vCltId;
        Ps_Client.Parameters.ParamByName('@P_CLTCIV').Value := queClient.FieldByName('CIV_NOM').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTNOM').Value := queClient.FieldByName('CLT_NOM').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTPRENOM').Value := queClient.FieldByName('CLT_PRENOM').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTADR1').Value := queClient.FieldByName('ADR1').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTADR2').Value := queClient.FieldByName('ADR2').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTADR3').Value := queClient.FieldByName('ADR3').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTCP').Value := queClient.FieldByName('VIL_CP').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTVILLE').Value := queClient.FieldByName('VIL_NOM').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTPAYS').Value := queClient.FieldByName('PAY_NOM').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTTEL1').Value := queClient.FieldByName('ADR_TEL').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTTEL2').Value := queClient.FieldByName('ADR_GSM').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTTEL3').Value := queClient.FieldByName('ADR_FAX').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTMAIL').Value := queClient.FieldByName('ADR_EMAIL').AsString;
        Ps_Client.Parameters.ParamByName('@P_CLTOPTINSMS').Value := QueClient.FieldByName('CLT_OPINSMS').AsInteger;
        Ps_Client.Parameters.ParamByName('@P_CLTOPTINMAIL').Value := QueClient.FieldByName('CLT_OPTINEMAIL').AsInteger;
        // Le K_ENABLED du client est passé à la procédure stockée dans le paramètre P_CLTAUTORISATION
        Ps_Client.Parameters.ParamByName('@P_CLTAUTORISATION').Value := QueClient.FieldByName('K_ENABLED').AsInteger;
        Ps_Client.Parameters.ParamByName('@P_FIDELITE').Value := QueClient.FieldByName('FIDELITE').AsInteger;
        Ps_Client.Parameters.ParamByName('@P_CLTNIVEXPLOIT').Value := QueClient.FieldByName('CLT_NIVEXPLOIT').AsInteger;

        try
          Ps_Client.ExecProc;
          Ps_Client.Close;
          // Le client a été traité, on mémorise son KVERSION dans le serveur SP2K (champ MAG_EXTRACTCLTLASTK)
          vExtractLastK := vCheckK;
        except on E:Exception do
          begin
            LogAction('CLIENT_UPDATE_OR_INSERT -> ' + E.Message, logError);
          end;
        end ;
      end;
      // Client suivant
      QueClient.Next;
    end;
  finally
    if vExtractLastK > aExtractLastK then
    begin
      // Des clients ont été traités, on mémorise le dernier KVERSION dans
      AdQueTmp.Connection.BeginTrans ;
      try
        //
        AdQueTmp.SQL.Clear;
        AdQueTmp.SQL.Add('Update magasin '
                       + ' set mag_extractCLTLastK = ' + IntToStr(vExtractLastK)
                       + ' where mag_id = ' + IntToStr(aDbMagId));
        AdQueTmp.ExecSQL ;

        AdQueTmp.Connection.CommitTrans ;
      except
        AdQueTmp.Connection.RollbackTrans ;
      end ;
    end;
    queClient.Close ;
    AdQueClient.Close ;
    Dm_ExtractDatabase.Ginkoia.Close ;
  end ;
end;

end.
