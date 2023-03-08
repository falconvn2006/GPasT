unit Main_Dm;

interface

uses
  SysUtils, Classes, IB_Components, DB, IBODataset, IB_Access;

type
  TDm_Main = class(TDataModule)
    Que_RechSession: TIBOQuery;
    Que_VerifSession: TIBOQuery;
    Que_Div: TIBOQuery;
    Que_Div2: TIBOQuery;
    Que_Div3: TIBOQuery;
    Ginkoia: TIBODatabase;
    Que_NomEncais: TIBOQuery;
    Que_SyntEncais: TIBOQuery;
    Que_SyntEncaisENC_MENID: TIntegerField;
    Que_SyntEncaisMEN_NOM: TStringField;
    Que_SyntEncaisMEN_TYPEMOD: TIntegerField;
    Que_SyntEncaisMNT: TIBOFloatField;
    Que_SyntEncaisBA: TIBOFloatField;
    Que_SyntEncaisTOT: TIBOFloatField;
    Que_SyntCli: TIBOQuery;
    Que_SyntCliCTE_ID: TIntegerField;
    Que_SyntCliCTE_CREDIT: TIBOFloatField;
    Que_SyntCliCTE_DEBIT: TIBOFloatField;
    Que_SyntCliTOT: TIBOFloatField;
    Que_SyntCliCTE_TYP: TIntegerField;
    Que_SyntFndCais: TIBOQuery;
    Que_SyntFndCaisFDC_TYP: TIntegerField;
    Que_SyntFndCaisMEN_NOM: TStringField;
    Que_SyntFndCaisMNT: TIBOFloatField;
    Que_LigFndCais: TIBOQuery;
    Que_LigFndCaisMEN_NOM: TStringField;
    Que_LigFndCaisFDC_ID: TIntegerField;
    Que_LigFndCaisFDC_MENID: TIntegerField;
    Que_LigFndCaisFDC_SESID: TIntegerField;
    Que_LigFndCaisFDC_ECHEANCE: TDateTimeField;
    Que_LigFndCaisFDC_DATE: TDateTimeField;
    Que_LigFndCaisFDC_LIBELLE: TStringField;
    Que_LigFndCaisFDC_MONTANT: TIBOFloatField;
    Que_LigFndCaisFDC_QTE: TIBOFloatField;
    Que_LigFndCaisFDC_TYP: TIntegerField;
    Que_LigFndCaisFDC_APPORT: TIntegerField;
    Que_LigFndCaisFDC_BCECFFID: TIntegerField;
    Que_LigFndCaisFDC_REFID: TIntegerField;
    Que_Coffre: TIBOQuery;
    Que_CoffreFCF_ID: TIntegerField;
    Que_CoffreFCF_MENID: TIntegerField;
    Que_CoffreFCF_CFFID: TIntegerField;
    Que_CoffreFCF_ECHEANCE: TDateTimeField;
    Que_CoffreFCF_DATE: TDateTimeField;
    Que_CoffreFCF_LIBELLE: TStringField;
    Que_CoffreFCF_MONTANT: TIBOFloatField;
    Que_CoffreFCF_LETTRAGE: TIntegerField;
    Que_CoffreFCF_TYPEMVT: TIntegerField;
    Que_CoffreFCF_IDREF: TIntegerField;
    Que_CoffreK_ID: TIntegerField;
    Que_CoffreKRH_ID: TIntegerField;
    Que_CoffreKTB_ID: TIntegerField;
    Que_CoffreK_VERSION: TIntegerField;
    Que_CoffreK_ENABLED: TIntegerField;
    Que_CoffreKSE_OWNER_ID: TIntegerField;
    Que_CoffreKSE_INSERT_ID: TIntegerField;
    Que_CoffreK_INSERTED: TDateTimeField;
    Que_CoffreKSE_DELETE_ID: TIntegerField;
    Que_CoffreK_DELETED: TDateTimeField;
    Que_CoffreKSE_UPDATE_ID: TIntegerField;
    Que_CoffreK_UPDATED: TDateTimeField;
    Que_CoffreKSE_LOCK_ID: TIntegerField;
    Que_CoffreKMA_LOCK_ID: TIntegerField;
    Que_SyntEncaisENC_DEPENSE: TIntegerField;
    queSeekField: TIBOQuery;
    queSeekFdcFromEnc: TIBOQuery;
    Que_Div4: TIBOQuery;
    Que_CashSession: TIBOQuery;
    Que_SyntEncaisTKE_TYPE: TIntegerField;

    function SessionIsCashSession(ASesid: integer): Boolean;
    function GetCashSessionDelta(ASesid: Integer) : Double;
    function GetTicketCASH_EmissionAcompte(ATkeId: integer): Double;
    function GetTicketCASH_EmissionCarteCadeau(ATkeId: integer): Double;
    function GetTicketCASH_BonAchatPercent(ATkeId: integer): Double;
    function GetTicketCASH_BonAchatValue(ATkeId: integer): Double;
    function GetTicketCASH_RemisePiedPercent(ATkeId: integer): Double;
  public
    { Déclarations publiques }
    procedure GetNomReglement(MEN_ID: integer;var MenNom: string;var ModeType: integer;var OkSupp: boolean);
    function GetBonReducIDBySession(SesNom: string): Integer;
    // recup de la session
    function GetSesIDFromTkeID(TkeID : integer) : Integer;
    // recup du magasin
    function GetMagIDFromSesID(SesId : integer) : integer;
    // Positionnement sur l'enreg de fond de caisse qui vas bien !
    function SeekFDCFromEnc(EncID : integer; MntToSuppr : Double) : Boolean;
    function SeekFDCFromMen(SesID, MenID : integer; MntToSuppr : Double; var FdcTrfDest : integer) : Boolean;
    // fortmat des dates
    function GetDateTimeForDB(value : TDateTime) : string;
    function GetDateForDB(value : TDate) : string;
    function GetTimeForDB(value : TTime) : string;
    function GetFloatForDB(value : Double) : string;
    // generation de requete
    function PreparerUnUpdate(NomTable, NomID: string; ADataSet: TDataSet; SeekField : boolean = false) : string; overload;
    function PreparerUnUpdate(NomTable, NomID: string; ADataSet: TDataSet; Colonnes, Values : array of string; SeekField : boolean = false) : string; overload;
    function ProcedureForCreate(NomTable, GestionId, requetes : string) : string;
    function CreerNouvLigne(NomTable, NomID: string; Colonnes, Values : array of string; GestionId : string = '') : string;
    function PreparerUneSupprLog(NomID: string; ADataSet: TDataSet) : string;
    function PreparerUneSupprPhy(NomTable, NomID: string; ADataSet: TDataSet) : string;
   // correction
    function CorrigeTicketAvecPxNNa0(aTKE_ID: Integer; var aMsg: string): Boolean;
    function CorrigeMenIDZero(aTKE_ID,aMENID: Integer; var aMsg: string): Boolean;
    function CorrigeTicketAvecBAGenerantDesPseudoRemise(aTKE_ID: Integer; var aMsg: string) : boolean;
    function CorrigeTicketRemiseFidSansBon(aTKE_ID: Integer; var aMsg: string) : boolean;
  end;

type
  ArrayOfColonne = array of string;

var
  Dm_Main: TDm_Main;
  ReperBase: string;

FUNCTION ArrondiA2(v: Double): Double;


procedure CopierIDAvecDesOR(NomID: string; ADataSet: TDataSet);
procedure PreparerLesUpdates(NomTable, NomID: string; ADataSet: TDataSet; SeekField : boolean = false);
procedure PreparerLesK_ENABLEDa1(NomID: string; ADataSet: TDataSet);
procedure PreparerLesSuppPhy(NomTable, NomID: string; ADataSet: TDataSet);
procedure CreerNouvLigne(NomTable, NomIndexID: string);

implementation

{$R *.dfm}

uses
  ClipBrd,
  StrUtils,
  Math;

function TDm_Main.GetSesIDFromTkeID(TkeID : integer) : Integer;
begin
  Result := 0;
  queSeekField.Close();
  queSeekField.SQL.Text := 'select tke_sesid '
                         + 'from cshticket join k on k_id = tke_id and k_enabled = 1 '
                         + 'where tke_id = ' + IntToStr(TkeID);
  queSeekField.Open();
  if not queSeekField.Eof then
    Result := queSeekField.FieldByName('tke_sesid').AsInteger;
  queSeekField.Close();
end;

function TDm_Main.GetMagIDFromSesID(SesId : integer) : integer;
begin
  Result := 0;
  queSeekField.Close();
  queSeekField.SQL.Text := 'select pos_magid '
                         + 'from genposte join k on k_id = pos_id and k_enabled = 1 '
                         + '  join cshsession join k on k_id = ses_id and k_enabled = 1 on ses_posid = pos_id '
                         + 'where ses_id = ' + IntToStr(SesId);
  queSeekField.Open();
  if not queSeekField.Eof then
    Result := queSeekField.FieldByName('pos_magid').AsInteger;
  queSeekField.Close();
end;

function TDm_Main.GetBonReducIDBySession(SesNom: string): Integer;
var
  quSelect: TIBOQuery;
begin
  Result := 0;
  quSelect := Dm_Main.Que_Div;
  try
    quSelect.SQL.Clear;
    quSelect.SQL.Add('select * from CSHMODEENC');

    quSelect.SQL.Add('join K on K_ID = MEN_ID and K_enabled=1');
    quSelect.SQL.Add('JOIN GENPOSTE on MEN_MAGID= POS_MAGID');
    quSelect.SQL.Add('JOIN CSHSESSION ON POS_ID = SES_POSID');
    quSelect.SQL.Add('WHERE MEN_NOM = :MEN_NOM');
    quSelect.ParamByName('MEN_NOM').AsString := 'BON DE REDUCTION';
    quSelect.SQL.Add('  AND MEN_REMISEOTO = 1');
    quSelect.SQL.Add('  AND SES_NUMERO = :SESNOM');
    quSelect.ParamByName('SESNOM').AsString := sesnom;
    quSelect.Open;
    if not quSelect.IsEmpty then
      Result := quSelect.FieldByName('MEN_ID').AsInteger;
  finally
    if quSelect.Active then
      quSelect.Close;
  end;
end;

function TDm_Main.GetCashSessionDelta(ASesid: Integer): Double;
var
  bIsCashSession: Boolean;
begin
  Result := 0;

  Que_CashSession.SQL.Clear;
  Que_CashSession.SQL.Text := 'SELECT RESULT FROM SESSIONISCASH(:SESID);';
  Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
  try
    Que_CashSession.Open;
    bIsCASHSession := Boolean(Que_CashSession.FieldByName('RESULT').AsInteger);
  finally
    Que_CashSession.Close;
  end;

  if bIsCashSession then
  begin
    //Récupération des prélèvements CASH
    Que_CashSession.SQL.Clear;
    Que_CashSession.SQL.Add('SELECT ');
    Que_CashSession.SQL.Add('  SUM(ENC_MONTANT) AS PRELEVEMENTS');
    Que_CashSession.SQL.Add('FROM ');
    Que_CashSession.SQL.Add('  CSHENCAISSEMENT JOIN K ON K.K_ID = ENC_ID AND K.K_ENABLED = 1 ');
    Que_CashSession.SQL.Add('  JOIN CSHTICKET ON TKE_ID = ENC_TKEID ');
    Que_CashSession.SQL.Add('WHERE ');
    Que_CashSession.SQL.Add('  TKE_SESID = :SESID ');
    Que_CashSession.SQL.Add('  AND TKE_TYPE = 7 ');
    Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
    try
      Que_CashSession.Open;
      if not Que_CashSession.FieldByName('PRELEVEMENTS').IsNull then
        Result := Result + Que_CashSession.FieldByName('PRELEVEMENTS').AsFloat;
    finally
      Que_CashSession.Close;
    end;

    //Récupération des apports CASH
    Que_CashSession.SQL.Clear;
    Que_CashSession.SQL.Add('SELECT ');
    Que_CashSession.SQL.Add('  SUM(ENC_MONTANT) AS APPORTS');
    Que_CashSession.SQL.Add('FROM ');
    Que_CashSession.SQL.Add('  CSHENCAISSEMENT JOIN K ON K.K_ID = ENC_ID AND K.K_ENABLED = 1 ');
    Que_CashSession.SQL.Add('  JOIN CSHTICKET ON TKE_ID = ENC_TKEID ');
    Que_CashSession.SQL.Add('WHERE ');
    Que_CashSession.SQL.Add('  TKE_SESID = :SESID ');
    Que_CashSession.SQL.Add('  AND TKE_TYPE = 6 ');
    Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
    try
      Que_CashSession.Open;
      if not Que_CashSession.FieldByName('APPORTS').IsNull then
        Result := Result + Que_CashSession.FieldByName('APPORTS').AsFloat;
    finally
      Que_CashSession.Close;
    end;

    //Récupération des ACOMPTES
    Que_CashSession.SQL.Clear;
    Que_CashSession.SQL.Add('SELECT ');
    Que_CashSession.SQL.Add('  SUM(AVR_VALEUR) AS ACOMPTES ');
    Que_CashSession.SQL.Add('FROM ');
    Que_CashSession.SQL.Add('  CSHTICKET ');
    Que_CashSession.SQL.Add('  JOIN AVOIR ON AVR_ORITKEID = TKE_ID JOIN K ON K.K_ID = AVR_ID AND K.K_ENABLED = 1 ');
    Que_CashSession.SQL.Add('WHERE ');
    Que_CashSession.SQL.Add('  TKE_SESID = :SESID ');
    Que_CashSession.SQL.Add('  AND AVR_ACOMPTE = 1 ');
    Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
    try
      Que_CashSession.Open;
      if not Que_CashSession.FieldByName('ACOMPTES').IsNull then
        Result := Result + Que_CashSession.FieldByName('ACOMPTES').AsFloat;
    finally
      Que_CashSession.Close;
    end;

    //Récupération des REMBOURSEMENTS d'ACOMPTES
    Que_CashSession.SQL.Clear;
    Que_CashSession.SQL.Add('SELECT ');
    Que_CashSession.SQL.Add('  SUM(AVR_VALEUR) AS ACOMPTES ');
    Que_CashSession.SQL.Add('FROM ');
    Que_CashSession.SQL.Add('  CSHTICKET ');
    Que_CashSession.SQL.Add('  JOIN AVOIR ON AVR_UTILTKEID = TKE_ID JOIN K ON K.K_ID = AVR_ID AND K.K_ENABLED = 1 ');
    Que_CashSession.SQL.Add('WHERE ');
    Que_CashSession.SQL.Add('  TKE_SESID = :SESID ');
    Que_CashSession.SQL.Add('  AND AVR_ACOMPTE = 1 AND (AVR_UTIL IN (2)) ');
    Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
    try
      Que_CashSession.Open;
      if not Que_CashSession.FieldByName('ACOMPTES').IsNull then
        Result := Result - Que_CashSession.FieldByName('ACOMPTES').AsFloat;
    finally
      Que_CashSession.Close;
    end;

    //Récupération des EMISSION CARTE CADEAU
    Que_CashSession.SQL.Clear;
    Que_CashSession.SQL.Add('SELECT ');
    Que_CashSession.SQL.Add('  SUM(AVR_VALEUR) AS EMISSIONS_CC ');
    Que_CashSession.SQL.Add('FROM ');
    Que_CashSession.SQL.Add('  CSHTICKET ');
    Que_CashSession.SQL.Add('  JOIN AVOIR ON AVR_ORITKEID = TKE_ID JOIN K ON K.K_ID = AVR_ID AND K.K_ENABLED = 1 ');
    Que_CashSession.SQL.Add('WHERE ');
    Que_CashSession.SQL.Add('  TKE_SESID = :SESID ');
    Que_CashSession.SQL.Add('  AND AVR_ACOMPTE = 2 ');
    Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
    try
      Que_CashSession.Open;
      if not Que_CashSession.FieldByName('EMISSIONS_CC').IsNull then
        Result := Result + Que_CashSession.FieldByName('EMISSIONS_CC').AsFloat;
    finally
      Que_CashSession.Close;
    end;

    //Récupération des UTILISATIONS CARTE CADEAU
    Que_CashSession.SQL.Clear;
    Que_CashSession.SQL.Add('SELECT ');
    Que_CashSession.SQL.Add('  SUM(AVR_USEDAMOUNT) AS UTILISATIONS_CC ');
    Que_CashSession.SQL.Add('FROM ');
    Que_CashSession.SQL.Add('  CSHTICKET ');
    Que_CashSession.SQL.Add('  JOIN AVOIR ON AVR_UTILTKEID = TKE_ID JOIN K ON K.K_ID = AVR_ID AND K.K_ENABLED = 1 ');
    Que_CashSession.SQL.Add('WHERE ');
    Que_CashSession.SQL.Add('  TKE_SESID = :SESID ');
    Que_CashSession.SQL.Add('  AND AVR_ACOMPTE = 2 ');
    Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
    try
      Que_CashSession.Open;
      if not Que_CashSession.FieldByName('UTILISATIONS_CC').IsNull then
        Result := Result - Que_CashSession.FieldByName('UTILISATIONS_CC').AsFloat;
    finally
      Que_CashSession.Close;
    end;

    //Récupération des EMISSION AVOIR
    {Que_CashSession.SQL.Clear;
    Que_CashSession.SQL.Add('SELECT ');
    Que_CashSession.SQL.Add('  SUM(AVR_VALEUR) AS EMISSION_AVOIR ');
    Que_CashSession.SQL.Add('FROM ');
    Que_CashSession.SQL.Add('  CSHTICKET ');
    Que_CashSession.SQL.Add('  JOIN AVOIR ON AVR_ORITKEID = TKE_ID JOIN K ON K.K_ID = AVR_ID AND K.K_ENABLED = 1 ');
    Que_CashSession.SQL.Add('WHERE ');
    Que_CashSession.SQL.Add('  TKE_SESID = :SESID ');
    Que_CashSession.SQL.Add('  AND AVR_ACOMPTE = 0 ');
    Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
    try
      Que_CashSession.Open;
      if not Que_CashSession.FieldByName('EMISSION_AVOIR').IsNull then
        Result := Result - Que_CashSession.FieldByName('EMISSION_AVOIR').AsFloat;
    finally
      Que_CashSession.Close;
    end;}

    //Récupération des REPRISES AVOIR
    {Que_CashSession.SQL.Clear;
    Que_CashSession.SQL.Add('SELECT ');
    Que_CashSession.SQL.Add('  SUM(AVR_VALEUR) AS REPRISES_AVOIR ');
    Que_CashSession.SQL.Add('FROM ');
    Que_CashSession.SQL.Add('  CSHTICKET ');
    Que_CashSession.SQL.Add('  JOIN AVOIR ON AVR_UTILTKEID = TKE_ID JOIN K ON K.K_ID = AVR_ID AND K.K_ENABLED = 1 ');
    Que_CashSession.SQL.Add('WHERE ');
    Que_CashSession.SQL.Add('  TKE_SESID = :SESID ');
    Que_CashSession.SQL.Add('  AND AVR_ACOMPTE = 0 AND AVR_UTIL = 1 ');
    Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesId;
    try
      Que_CashSession.Open;
      if not Que_CashSession.FieldByName('REPRISES_AVOIR').IsNull then
        Result := Result - Que_CashSession.FieldByName('REPRISES_AVOIR').AsFloat;
    finally
      Que_CashSession.Close;
    end;}
  end;
  Result := ArrondiA2(Result);
end;

function TDm_Main.SeekFDCFromEnc(EncID : integer; MntToSuppr : Double) : Boolean;
var
  MenID, TkeID, SesID, MenMod, MenDet, FdcTrfDest : Integer;
begin
  Result := False;

  // recuperation des info sur le mode de payement
  queSeekFdcFromEnc.Close();
  queSeekFdcFromEnc.SQL.Text := 'select men_id, enc_tkeid, men_typemod, men_rapido '
                              + 'from CSHENCAISSEMENT '
                              + 'join CSHMODEENC on men_id = enc_menid '
                              + 'where enc_id = ' + IntToStr(EncID) + ';';
  queSeekFdcFromEnc.Open();
  if not queSeekFdcFromEnc.Eof then
  begin
    MenID := queSeekFdcFromEnc.FieldByName('men_id').AsInteger;
    TkeID := queSeekFdcFromEnc.FieldByName('enc_tkeid').AsInteger;
    MenMod := queSeekFdcFromEnc.FieldByName('men_typemod').AsInteger;
    MenDet := queSeekFdcFromEnc.FieldByName('men_rapido').AsInteger;
    queSeekFdcFromEnc.Close();
    // session
    SesID := GetSesIDFromTkeID(TkeID);

    if (MenMod = 5) and (MenDet = 1) then
    begin
      // detail soit une ligne de fdc par encaissement
      queSeekFdcFromEnc.SQL.Text := 'select * '
                                  + 'from CSHFONDCAISSE '
                                  + 'where fdc_sesid = ' + IntToStr(SesID)
                                  + '  and fdc_menid = ' + IntToStr(MenID)
                                  + '  and fdc_refid = ' + IntToStr(EncID);
      queSeekFdcFromEnc.Open();
    end
    else
    begin
      // recherche selon le mode de reglement
      SeekFDCFromMen(SesID, MenID, MntToSuppr, FdcTrfDest);
    end;

    if not queSeekFdcFromEnc.Eof then
      Result := True;
  end;
end;

function TDm_Main.SeekFDCFromMen(SesID, MenID : integer; MntToSuppr : Double; var FdcTrfDest : integer) : Boolean;

  procedure SeekCentralisedFDC(SesId, MenID, FdcTrfDest, MenCfC : integer; MntToSuppr : Double; GereCentralisation : boolean);
  begin
    // recherche sur "FdcTrfDest"
    queSeekFdcFromEnc.SQL.Text := 'select fdc_id, fdc_montant '
                                        + 'from CSHFONDCAISSE '
                                        + 'where fdc_sesid = ' + IntToStr(SesID)
                                        + '  and fdc_menid = ' + IntToStr(MenID)
                                        + '  and fdc_bcecffid = ' + IntToStr(FdcTrfDest);
    queSeekFdcFromEnc.Open();

    if GereCentralisation then
    begin
      // si on centralise
      // et qu'il n'y a pas assez sur "FdcTrfDest"
      // on cherche sur "MenCfC"
      if queSeekFdcFromEnc.Eof or
         (queSeekFdcFromEnc.FieldByName('fdc_montant').AsFloat > MntToSuppr) then
      begin
        queSeekFdcFromEnc.SQL.Text := 'select fdc_id, fdc_montant '
                                            + 'from CSHFONDCAISSE '
                                            + 'where fdc_sesid = ' + IntToStr(SesID)
                                            + '  and fdc_menid = ' + IntToStr(MenID)
                                            + '  and fdc_bcecffid = ' + IntToStr(MenCfC);
        queSeekFdcFromEnc.Open();
      end;
    end;
  end;

var
  TkeID, MenTrf, MenMod, MenDet, MenBqe, MenCff, MenCfC : Integer;
begin
  Result := False;
  FdcTrfDest := 0;

  // recuperation des info sur le mode de payement
  queSeekFdcFromEnc.Close();
  queSeekFdcFromEnc.SQL.Text := 'select men_typetrf, men_typemod, men_rapido, men_bqeid, men_cffid, men_cffcentral '
                              + 'from CSHMODEENC '
                              + 'where men_id = ' + IntToStr(MenID) + ';';
  queSeekFdcFromEnc.Open();
  if not queSeekFdcFromEnc.Eof then
  begin
    MenTrf := queSeekFdcFromEnc.FieldByName('men_typetrf').AsInteger;
    MenMod := queSeekFdcFromEnc.FieldByName('men_typemod').AsInteger;
    MenDet := queSeekFdcFromEnc.FieldByName('men_rapido').AsInteger;
    MenBqe := queSeekFdcFromEnc.FieldByName('men_bqeid').AsInteger;
    MenCff := queSeekFdcFromEnc.FieldByName('men_cffid').AsInteger;
    MenCfC := queSeekFdcFromEnc.FieldByName('men_cffcentral').AsInteger;
    queSeekFdcFromEnc.Close();
    // destinataire du transfert
    if MenTrf = 0 then
      FdcTrfDest := MenCff
    else
      FdcTrfDest := MenBqe;
    // mode de reglement
    case MenMod of
      4 : // espece
        // jusqu'a deux lignes :
        // - au "men_cffcentral" jusqu'a un certain montant
        // - a la "FdcTrfDest" pour le reste
        SeekCentralisedFDC(SesID, MenID, FdcTrfDest, MenCfC, MntToSuppr, True);
      5 : // autre (CB, Cheque, ...)
        // meme gestion que les espece ...
        if not (MenDet = 1) then
          SeekCentralisedFDC(SesID, MenID, FdcTrfDest, MenCfC, MntToSuppr, True);
      else // 1 - Compte client
           // 2 - Devise
           // 3 - Remise
        // meme gestion que les espece ...
        // SAUF que pas de gestion de "men_cffcentral"
        SeekCentralisedFDC(SesID, MenID, FdcTrfDest, MenCfC, MntToSuppr, False);
    end;
    // resultat
    if not queSeekFdcFromEnc.Eof then
      Result := True;
  end;
end;

function TDm_Main.SessionIsCashSession(ASesid: integer): Boolean;
begin
  Result := False;

  Que_CashSession.SQL.Clear;
  Que_CashSession.SQL.Text := 'SELECT RESULT FROM SESSIONISCASH(:SESID);';
  Que_CashSession.Params.ParamByName('SESID').AsInteger := ASesid;
  try
    Que_CashSession.Open;
    Result := Boolean(Que_CashSession.FieldByName('RESULT').AsInteger);
  finally
    Que_CashSession.Close;
  end;
end;

// fortmat des dates

function TDm_Main.GetDateTimeForDB(value : TDateTime) : string;
begin
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', value));
end;

function TDm_Main.GetDateForDB(value : TDate) : string;
begin
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd', value));
end;

function TDm_Main.GetTicketCASH_BonAchatPercent(ATkeId: integer): Double;
var
  vBonAcahtCASH: Double;
begin
  Result := 1;
// Pour les sessions CASH les bon achats fidélités ne sont pas dans les encaissements
  vBonAcahtCASH := GetTicketCASH_BonAchatValue(ATkeId);

  if vBonAcahtCASH <> 0 then
  begin
    Que_Div3.Active:=false;
    Que_Div3.SQL.Clear;
    Que_Div3.SQL.Add('select sum(tkl_pxnet)');
    Que_Div3.SQL.Add('from cshticket ');
    Que_Div3.SQL.Add('  join cshticketl on tkl_tkeid = tke_id join k on k.k_id = tkl_id and k.k_enabled = 1 ');
    Que_Div3.SQL.Add('where tke_id = ' + inttostr(ATkeID));
    Que_Div3.SQL.Add('  and tkl_sstotal = 0 ');
    Que_Div3.Active := true;
    if Que_Div3.Fields[0].AsFloat <> 0 then
    begin
      Result := (Que_Div3.Fields[0].AsFloat - vBonAcahtCASH) / Que_Div3.Fields[0].AsFloat;
    end
    else
      Result := 1;
    Que_Div3.Active := false;
  end;
end;

function TDm_Main.GetTicketCASH_BonAchatValue(ATkeId: integer): Double;
begin
  Result := 0;
  Que_Div2.Active:=false;
  Que_Div2.SQL.Clear;
  Que_Div2.SQL.Add('select sum(BAC_MONTANT) as BA');
  Que_Div2.SQL.Add('from CLTBONACHAT ');
  Que_Div2.SQL.Add('join K on (K_ID = BAC_ID and K_enabled=1)');
  Que_Div2.SQL.Add('Where BAC_TKEID = ' + inttostr(ATkeID) );
  Que_Div2.SQL.Add('  AND BAC_USED = 1' );
  Que_Div2.Active:=true;
  if not Que_Div2.eof and (ArrondiA2(Que_Div2.fieldbyname('BA').AsFloat)<>0) then
  begin
    Result := Que_Div2.fieldbyname('BA').AsFloat;
  end;
  Que_Div2.Active:=false;
end;

function TDm_Main.GetTicketCASH_EmissionAcompte(ATkeId: integer): Double;
begin
  Result := 0;
  Que_CashSession.SQL.Clear;
  Que_CashSession.SQL.Add('SELECT ');
  Que_CashSession.SQL.Add('  SUM(AVR_VALEUR) AS ACOMPTES ');
  Que_CashSession.SQL.Add('FROM ');
  Que_CashSession.SQL.Add('  CSHTICKET ');
  Que_CashSession.SQL.Add('  JOIN AVOIR ON AVR_ORITKEID = TKE_ID JOIN K ON K.K_ID = AVR_ID AND K.K_ENABLED = 1 ');
  Que_CashSession.SQL.Add('WHERE ');
  Que_CashSession.SQL.Add('  TKE_ID = :TKEID ');
  Que_CashSession.SQL.Add('  AND AVR_ACOMPTE = 1 ');
  Que_CashSession.Params.ParamByName('TKEID').AsInteger := ATkeId;
  try
    Que_CashSession.Open;
    if not Que_CashSession.FieldByName('ACOMPTES').IsNull then
    begin
      Result := Que_CashSession.FieldByName('ACOMPTES').AsFloat;
    end;
  finally
    Que_CashSession.Close;
  end;
end;

function TDm_Main.GetTicketCASH_EmissionCarteCadeau(ATkeId: integer): Double;
begin
  Result := 0;

  //Récupération des EMISSION CARTE CADEAU
  Que_CashSession.SQL.Clear;
  Que_CashSession.SQL.Add('SELECT ');
  Que_CashSession.SQL.Add('  SUM(AVR_VALEUR) AS EMISSIONS_CC ');
  Que_CashSession.SQL.Add('FROM ');
  Que_CashSession.SQL.Add('  CSHTICKET ');
  Que_CashSession.SQL.Add('  JOIN AVOIR ON AVR_ORITKEID = TKE_ID JOIN K ON K.K_ID = AVR_ID AND K.K_ENABLED = 1 ');
  Que_CashSession.SQL.Add('WHERE ');
  Que_CashSession.SQL.Add('  TKE_ID = :TKEID ');
  Que_CashSession.SQL.Add('  AND AVR_ACOMPTE = 2 ');
  Que_CashSession.Params.ParamByName('TKEID').AsInteger := ATkeId;
  try
    Que_CashSession.Open;
    if not Que_CashSession.FieldByName('EMISSIONS_CC').IsNull then
    begin
      Result := Que_CashSession.FieldByName('EMISSIONS_CC').AsFloat;
    end;
  finally
    Que_CashSession.Close;
  end;
end;

function TDm_Main.GetTicketCASH_RemisePiedPercent(ATkeId: integer): Double;
begin
  Result := 1.0;
// Pour les sessions CASH il faut prendre en compte la remise pied de ticket.
  Dm_Main.Que_Div3.Active:=false;
  Dm_Main.Que_Div3.SQL.Clear;
  Dm_Main.Que_Div3.SQL.Add('select TKE_REMISE ');
  Dm_Main.Que_Div3.SQL.Add('from cshticket join K on (K_ID = TKE_ID and K_enabled=1) ');
  Dm_Main.Que_Div3.SQL.Add('Where ');
  Dm_Main.Que_Div3.SQL.Add('  TKE_ID='+inttostr(ATkeID));
  Dm_Main.Que_Div3.Active:=true;
  Dm_Main.Que_Div3.First;
  if not(Dm_Main.Que_Div3.Eof) and (ArrondiA2(Dm_Main.Que_Div3.fieldbyname('TKE_REMISE').AsFloat)<>0) then
    Result := 1-(ArrondiA2(Dm_Main.Que_Div3.fieldbyname('TKE_REMISE').AsFloat)/100);
  Dm_Main.Que_Div3.Active:=false;
end;

function TDm_Main.GetTimeForDB(value : TTime) : string;
begin
  Result := QuotedStr(FormatDateTime('hh:nn:ss.zzz', value));
end;

function TDm_Main.GetFloatForDB(value : Double) : string;
begin
  Result := StringReplace(FloatToStr(value), ',', '.', []);
end;

// generation de requetes

function TDm_Main.PreparerUnUpdate(NomTable, NomID: string; ADataSet: TDataSet; SeekField : boolean) : string;
begin
  Result := PreparerUnUpdate(NomTable, NomID, ADataSet, [], [], SeekField);
end;

function TDm_Main.PreparerUnUpdate(NomTable, NomID: string; ADataSet: TDataSet; Colonnes, Values : array of string; SeekField : boolean) : string;
var
  i, idx : integer;
begin
  Result := 'update ' + UpperCase(Nomtable) + ' set' + #13#10;
  if SeekField then
  begin
    queSeekField.Close();
    queSeekField.SQL.Text := 'select * from ' + Nomtable + ' where ' + NomID + ' = ' + inttostr(ADataSet.fieldbyname(NomID).AsInteger);
    queSeekField.Open();
    for i := 0 to queSeekField.Fields.Count -1 do
    begin
      idx := AnsiIndexText(queSeekField.Fields[i].FieldName, Colonnes);
      if (((Length(Colonnes) > 0) and (idx >= 0))                                              // Gestion de la liste des colonnes
          or (Length(Colonnes) = 0))                                                           // si pas de colonne spécifié
         and not (UpperCase(queSeekField.Fields[i].FieldName) = UpperCase(NomID)) then // pas de maj de l'identifiant
      begin
        Result := Result + '  ' + queSeekField.Fields[i].FieldName + ' = ';
        if (idx >= 0) and (idx < Length(Values)) then
        begin
          // Valeur arrivé en paramètre
          Result := Result + Values[idx] + ', ';
        end
        else if queSeekField.Fields[i].IsNull then
        begin
          // valeur null
          Result := Result + 'null, ';
        end
        else
        begin
          // reprise de la valeur depuis la BDD
          case queSeekField.Fields[i].DataType of
            ftString, ftMemo, ftWideString :
              Result := Result + QuotedStr(queSeekField.Fields[i].AsString) + ', ';
            ftSmallint, ftInteger, ftWord, ftLargeint :
              Result := Result + IntToStr(queSeekField.Fields[i].AsInteger) + ', ';
            ftBoolean :
              Result := Result + BoolToStr(queSeekField.Fields[i].AsBoolean, True) + ', ';
            ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftSingle :
              Result := Result + GetFloatForDB(queSeekField.Fields[i].AsFloat) + ', ';
            ftDateTime, ftTimeStamp :
              Result := Result + GetDateTimeForDB(queSeekField.Fields[i].AsDateTime) + ', ';
            ftDate :
              Result := Result + GetDateForDB(queSeekField.Fields[i].AsDateTime) + ', ';
            ftTime :
              Result := Result + GetTimeForDB(queSeekField.Fields[i].AsDateTime) + ', ';
            else
              Result := Result + '..., ';
          end;
        end;
        Result := Result + #13#10;
      end;
    end;
    queSeekField.Close();
    Result := LeftStr(Result, Length(Result) -4) + #13#10;
  end
  else
    Result := Result + '  ... = ...' + #13#10;
  Result := Result + 'where ' + UpperCase(NomID) + ' = ' + inttostr(ADataSet.fieldbyname(NomID).AsInteger) + ';' + #13#10
                   + 'execute procedure PR_UPDATEK(' + inttostr(ADataSet.fieldbyname(NomID).AsInteger) + ', 0);' + #13#10#13#10;
end;

function TDm_Main.ProcedureForCreate(NomTable, GestionId, requetes : string) : string;
begin
  Result := 'CREATE PROCEDURE CH_TMPCREE_' + NomTable + #13#10
          + 'AS' + #13#10
          + 'DECLARE VARIABLE ' + GestionId + ' INTEGER;' + #13#10
          + 'BEGIN' + #13#10
          + '  select id from PR_NEWK(' + QuotedStr(UpperCase(NomTable)) + ') into :' + GestionId + ';' + #13#10#13#10
          + requetes
          + 'end;' + #13#10
          + 'EXECUTE PROCEDURE CH_TMPCREE_' + NomTable + ';' + #13#10
          + 'DROP PROCEDURE CH_TMPCREE_' + NomTable + ';' + #13#10#13#10;
end;

function TDm_Main.CreerNouvLigne(NomTable, NomID: string; Colonnes, Values : array of string; GestionId : string) : string;
var
  i, idx : integer;
begin
  Result := 'insert into ' + UpperCase(Nomtable) + #13#10 + '  (';

  queSeekField.SQL.Text := 'select * from ' + Nomtable + ' where ' + NomID + ' = 0';
  queSeekField.Open();
  // recup du nom des champs
  for i := 0 to queSeekField.Fields.Count -1 do
    Result := Result + queSeekField.Fields[i].FieldName + ', ';
  Result := LeftStr(Result, Length(Result) -2) + ')' + #13#10 + 'values (' + #13#10;
  // set des valeurs ...
  for i := 0 to queSeekField.Fields.Count -1 do
  begin
    if UpperCase(queSeekField.Fields[i].FieldName) = UpperCase(NomID) then
    begin
      if Trim(GestionId) = '' then
        Result := Result + '  (select ID from PR_NEWK(' + QuotedStr(UpperCase(NomTable)) + ')) /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10
      else
        Result := Result + '  :' + GestionId + ' /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10
    end
    else
    begin
      idx := AnsiIndexText(queSeekField.Fields[i].FieldName, Colonnes);
      if (idx >= 0) and (idx < Length(Values)) then
      begin
        // il y une valeur pour la colonne dans la liste
        Result := Result + '  ' + Values[idx] + ' /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
      end
      else
      begin
        // pas de valeur
        case queSeekField.Fields[i].DataType of
          ftString, ftMemo, ftWideString :
            Result := Result + '  ' + QuotedStr('') + ' /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
          ftSmallint, ftInteger, ftWord, ftLargeint :
            Result := Result + '  0 /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
          ftBoolean :
            Result := Result + '  false /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
          ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftSingle :
            Result := Result + '  0.0 /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
          ftDateTime, ftTimeStamp :
            Result := Result + '  ''yyyy-mm-dd hh:nn:ss.zzz'' /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
          ftDate :
            Result := Result + '  ''yyyy-mm-dd'' /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
          ftTime :
            Result := Result + '  ''hh:nn:ss.zzz'' /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
          else
            Result := Result + '  ... /* ' + queSeekField.Fields[i].FieldName + ' */,' + #13#10;
        end;
      end;
    end;
  end;
  Result := LeftStr(Result, Length(Result) -3) + ');' + #13#10#13#10;
end;

function TDm_Main.PreparerUneSupprLog(NomID: string; ADataSet: TDataSet) : string;
begin
  Result := 'execute procedure PR_UPDATEK(' + inttostr(ADataSet.fieldbyname(NomID).AsInteger) + ', 1);' + #13#10#13#10;
end;

function TDm_Main.PreparerUneSupprPhy(NomTable, NomID: string; ADataSet: TDataSet) : string;
begin
  Result := 'delete from ' + Nomtable + ' where ' + NomID + ' = ' + inttostr(ADataSet.fieldbyname(NomID).AsInteger) + ';' + #13#10#13#10;
end;

// Fonction de correction directe

function TDm_Main.CorrigeMenIDZero(aTKE_ID, aMENID: Integer; var aMsg: string): Boolean;
var
  quSelect: TIBOQuery;
  quTicket: TIBOQuery;
  quUpdate: TIBOQuery;
  fSumPxNet, fMontant, fSomme: Extended;

  Procedure CorrigerUneLigne(aMontant: Extended);
  begin
    // on corrige
    quUpdate.SQL.Clear;
    quUpdate.SQL.Add('update CSHENCAISSEMENT set');
    quUpdate.SQL.Add('  ENC_MONTANT = 0, ');
    quUpdate.SQL.Add('ENC_BA = :VALEUR, ');
    quUpdate.SQL.Add('ENC_MENID = :MEN_ID ');
    quUpdate.SQL.Add('where ENC_ID = :ENC_ID');

    quUpdate.ParamByName('VALEUR').AsFloat := aMontant;
    quUpdate.ParamByName('MEN_ID').AsInteger := aMENID;
    quUpdate.ParamByName('ENC_ID').AsInteger := quSelect.FieldByName('ENC_ID').AsInteger;
    quUpdate.ExecSQL;

    // on met à jour
    quUpdate.SQL.Text := 'execute procedure PR_UPDATEK(:ENC_ID, 0)';
    quUpdate.ParamByName('ENC_ID').AsInteger := quSelect.FieldByName('ENC_ID').AsInteger;
    quUpdate.ExecSQL;
  end;

  Procedure CorrigerLigneTicket;
  var
    fPxBrut, fNewPxNN, fTVA, fTauxHT, fPxNNHT : Extended;
  begin
    fPxBrut := abs(quSelect.FieldByName('TKL_PXNET').AsFloat);

    fNewPxNN := quSelect.FieldByName('TKL_PXNN').AsFloat - fPxBrut*fMontant/fSumPxNet;


    fTVA := quSelect.FieldByName('TKL_TVA').AsFloat;
    fTauxHT := (100+fTVA)/100;
    // on corrige
    quUpdate.SQL.Clear;
    quUpdate.SQL.Add('Update CSHTICKETL');
    quUpdate.SQL.Add('SET TKL_PXNN = :PXNN,');
    quUpdate.SQL.Add('    TKL_PXNNHT = :PXNNHT');
    quUpdate.SQL.Add('WHERE TKL_ID = :TKLID');

    quUpdate.ParamByName('PXNN').AsFloat := fNewPxNN;
    fPxNNHT := fNewPxNN / fTauxHT;
    quUpdate.ParamByName('PXNNHT').AsFloat := fPxNNHT;
    quUpdate.ParamByName('TKLID').AsInteger := quSelect.FieldByName('TKL_ID').AsInteger;
    quUpdate.ExecSQL;

    // on met à jour
    quUpdate.SQL.Text := 'execute procedure PR_UPDATEK(:TKLID, 0)';
    quUpdate.ParamByName('TKLID').AsInteger := quSelect.FieldByName('TKL_ID').AsInteger;
    quUpdate.ExecSQL;
  end;

begin
  Result := False;
  aMsg := '';
  quSelect := Dm_Main.Que_Div;
  quTicket := Dm_Main.Que_Div2;
  quUpdate := Dm_Main.Que_Div3;

  if quSelect.Active then
    quSelect.Close;
  if quTicket.Active then
    quTicket.Close;
  if quUpdate.Active then
    quUpdate.Close;
  try
    fSomme:= 0;
    quSelect.SQL.Clear;
    quSelect.SQL.Add('select ENC_ID, ENC_MENID, ENC_MONTANT, ENC_BA, MEN_TYPEMOD, ENC_DEPENSE, ENC_MOTIF');
    quSelect.SQL.Add('from CSHENCAISSEMENT');
    quSelect.SQL.Add('join K on K_ID = ENC_ID and K_enabled=1');
    quSelect.SQL.Add('join CSHMODEENC on MEN_ID=ENC_MENID');
    quSelect.SQL.Add('Where ENC_TkeId= :TKE_ID');
    quSelect.SQL.Add('  and ENC_MENID = 0');
    quSelect.ParamByName('TKE_ID').AsInteger := aTKE_ID;

    quSelect.Open;
    if not quSelect.IsEmpty then
    begin
    // correction de l'encaissement
      Result := True;
      while not quSelect.Eof do
      begin
        fMontant := quSelect.FieldByName('ENC_MONTANT').AsFloat;
        CorrigerUneLigne(fMontant);
        fSomme := fSomme + fMontant;
        quSelect.Next;
      end;

      // combien a été réellement payé
      quTicket.SQL.Clear;
      quTicket.SQL.Add('SELECT TKE_TOTNETA1 as PxNet FROM CSHTICKET');
      quTicket.SQL.Add('WHERE TKE_ID= :TKE_ID');
      quTicket.ParamByName('TKE_ID').AsInteger := aTKE_ID;
      quTicket.Open;
      fSumPxNet := quTicket.FieldByName('PxNet').AsFloat;
      quTicket.Close;

    // on réparti le PXNN
      quSelect.Close;
      quSelect.SQL.Clear;
      quSelect.SQL.Add('SELECT * FROM CSHTICKETL');
      quSelect.SQL.Add('WHERE TKL_TKEID= :TKE_ID');
      quSelect.ParamByName('TKE_ID').AsInteger := aTKE_ID;
      quSelect.Open;

      while not quSelect.Eof do
      begin
        CorrigerLigneTicket;
        quSelect.Next;
      end;
    end;
  finally
    if quSelect.Active then
      quSelect.Close;
    if quTicket.Active then
      quTicket.Close;
    if quUpdate.Active then
      quUpdate.Close;
  end;
end;

function TDm_Main.CorrigeTicketAvecPxNNa0(aTKE_ID: Integer; var aMsg: string): Boolean;
var
  quSelect: TIBOQuery;
  quTicket: TIBOQuery;
  quUpdate: TIBOQuery;

  fSumOublis, fSumPxNN, fSumPxNet: Extended;
  bSousTotal: boolean;

  Procedure CorrigerUneLigne(aNewPxNN: Extended);
  var
    fTVA, fTauxHT, fPxNNHT : Extended;
  begin
    fTVA := quSelect.FieldByName('TKL_TVA').AsFloat;
    fTauxHT := (100+fTVA)/100;
    // on corrige
    quUpdate.SQL.Clear;
    quUpdate.SQL.Add('Update CSHTICKETL');
    quUpdate.SQL.Add('SET TKL_PXNN = :PXNN,');
    quUpdate.SQL.Add('    TKL_PXNNHT = :PXNNHT');
    quUpdate.SQL.Add('WHERE TKL_ID = :TKLID');

    quUpdate.ParamByName('PXNN').AsFloat := aNewPxNN;
    fPxNNHT := aNewPxNN / fTauxHT;
    quUpdate.ParamByName('PXNNHT').AsFloat := fPxNNHT;
    quUpdate.ParamByName('TKLID').AsInteger := quSelect.FieldByName('TKL_ID').AsInteger;
    quUpdate.ExecSQL;

    // on met à jour
    quUpdate.SQL.Text := 'execute procedure PR_UPDATEK(:TKLID, 0)';
    quUpdate.ParamByName('TKLID').AsInteger := quSelect.FieldByName('TKL_ID').AsInteger;
    quUpdate.ExecSQL;
  end;

begin
  Result := False;
  aMsg := '';
  quSelect := Dm_Main.Que_Div;
  quTicket := Dm_Main.Que_Div2;
  quUpdate := Dm_Main.Que_Div3;

  if quSelect.Active then
    quSelect.Close;
  if quTicket.Active then
    quTicket.Close;
  if quUpdate.Active then
    quUpdate.Close;

  quSelect.SQL.Clear;
  quSelect.SQL.Add('SELECT * FROM CSHTICKETL');
  quSelect.SQL.Add('WHERE TKL_TKEID= :TKE_ID');
  quSelect.SQL.Add('  AND TKL_ARTID <> 0');
  quSelect.SQL.Add('  AND TKL_PXNN = 0');
  quSelect.SQL.Add('  AND TKL_REMISE = 100');
  quSelect.SQL.Add('  AND TKL_PXBRUT <> 0');
  quSelect.ParamByName('TKE_ID').AsInteger := aTKE_ID;
  try
    quSelect.Open;
    if not quSelect.IsEmpty then
    begin
     // combien as t'on ventilé ?
      quTicket.SQL.Clear;
      quTicket.SQL.Add('SELECT sum(TKL_PXNN*Tkl_Qte) as PxNN FROM CSHTICKETL');
      quTicket.SQL.Add('WHERE TKL_TKEID= :TKE_ID');
      quTicket.SQL.Add('  AND TKL_ARTID <> 0');
      quTicket.ParamByName('TKE_ID').AsInteger := aTKE_ID;
      quTicket.Open;
      fSumPxNN := quTicket.FieldByName('PxNN').AsFloat;
      quTicket.Close;

      // combien a été réellement payé
      quTicket.SQL.Clear;
      quTicket.SQL.Add('SELECT TKE_TOTNETA1 as PxNet FROM CSHTICKET');
      quTicket.SQL.Add('WHERE TKE_ID= :TKE_ID');
      quTicket.ParamByName('TKE_ID').AsInteger := aTKE_ID;
      quTicket.Open;
      fSumPxNet := quTicket.FieldByName('PxNet').AsFloat;
      if fSumPxNN <> fSumPxNet then
      begin
        if quSelect.RecordCount > 1 then
        begin // c'est plus compliqué, on en a plusieurs,
          fSumOublis := 0;
          while not quSelect.Eof do
          begin
            fSumOublis := fSumOublis + quSelect.FieldByName('Tkl_PxBrut').AsFloat*quSelect.FieldByName('Tkl_Qte').AsFloat;
            quSelect.Next;
          end;
          if fSumOublis <> 0 then
          begin
            quSelect.First;
            while not quSelect.Eof do
            begin
              CorrigerUneLigne(quSelect.FieldByName('Tkl_Qte').AsFloat*quSelect.FieldByName('Tkl_PxBrut').AsFloat*(fSumPxNet-fSumPxNN)/fSumOublis);
              quSelect.Next;
            end;
            // on est content
            Result := True;
          end
          else aMsg := Format('%d articles sont potentiellement concernés. Impossible de ventiler correctement', [quSelect.RecordCount])
        end
        else if quSelect.RecordCount = 1 then
        begin
            CorrigerUneLigne(fSumPxNet - fSumPxNN);
          // on est content
            Result := True;
          end;
      end;
    end;
  finally
    if quSelect.Active then
      quSelect.Close;
    if quTicket.Active then
      quTicket.Close;
    if quUpdate.Active then
      quUpdate.Close;
  end;
end;

function TDm_Main.CorrigeTicketAvecBAGenerantDesPseudoRemise(aTKE_ID: Integer; var aMsg: string) : boolean;
var
  que_Entete, que_Lignes, que_MAJ : TIBOQuery;
  MntTotalTicket, MntTotalLoc, MntTotalCte, MntTotalEnc, MntTotalBA, MntTotalLignes : currency;
  coefba : double;
begin
  Result := false;
  aMsg := '';
  que_Entete := Que_Div;
  que_Lignes := Que_Div2;
  que_MAJ := Que_Div3;

  if que_Entete.Active then
    que_Entete.Close();
  if que_Lignes.Active then
    que_Lignes.Close();
  if que_MAJ.Active then
    que_MAJ.Close();

  try
    que_Entete.SQL.Text := 'select tke_id, tke_totneta1, tke_totneta2 from cshticket where tke_id = ' + IntToStr(aTKE_ID) + ';';
    que_Entete.Open();
    if not que_Entete.Eof then
    begin
      MntTotalTicket := que_Entete.FieldByName('tke_totneta1').AsCurrency;
      MntTotalLoc := que_Entete.FieldByName('tke_totneta2').AsCurrency;
      MntTotalCte := 0;
      MntTotalEnc := 0;
      MntTotalBA := 0;
      MntTotalLignes := 0;

      try
        que_Lignes.SQL.Text := 'select cte_credit - cte_debit as cte_montant from cltcompte join k on k_id = cte_id and k_enabled = 1 where cte_tkeid = ' + IntToStr(aTKE_ID) + ' and cte_typ in (1, 2, 3);';
        que_Lignes.Open();
        while not que_Lignes.Eof do
        begin
          MntTotalCte := MntTotalCte + que_Lignes.FieldByName('cte_montant').AsCurrency;
          que_Lignes.Next();
        end;
      finally
        que_Lignes.Close();
      end;

      try
        que_Lignes.SQL.Text := 'select enc_montant, enc_ba from cshencaissement join k on k_id = enc_id and k_enabled = 1 where enc_tkeid = ' + IntToStr(aTKE_ID) + ';';
        que_Lignes.Open();
        while not que_Lignes.Eof do
        begin
          MntTotalEnc := MntTotalEnc + que_Lignes.FieldByName('enc_montant').AsCurrency;
          MntTotalBA := MntTotalBA + que_Lignes.FieldByName('enc_ba').AsCurrency;
          que_Lignes.Next();
        end;
      finally
        que_Lignes.Close();
      end;

      try
        que_Lignes.SQL.Text := 'select tkl_id, tkl_qte, tkl_pxnn from cshticketl join k on k_id = tkl_id and k_enabled = 1 where tkl_tkeid = ' + IntToStr(aTKE_ID) + ';';
        que_Lignes.Open();
        while not que_Lignes.Eof do
        begin
          MntTotalLignes := MntTotalLignes + que_Lignes.FieldByName('tkl_qte').AsInteger * que_Lignes.FieldByName('tkl_pxnn').AsCurrency;
          que_Lignes.Next();
        end;

        // test des totaux :
        // - est ce que le problème est un pb d'application de la pseudo remise du BA

        // gestion des arrondi !
        MntTotalLignes := RoundTo(MntTotalLignes, -2);

        if (MntTotalBA > 0) and                                               // Il y a des BA sur le ticket
           (MntTotalTicket = MntTotalLignes) and                              // La somme des lignes de vente est egal a l'entete de vente (remise non appliqué)
           ((MntTotalEnc + MntTotalBA) = (MntTotalTicket + MntTotalLoc)) then // Les encaissements couvre au montant total du ticket
        begin
          // calcul du coef a appliqué sur les lignes !
          if MntTotalEnc + MntTotalBA <> 0 then
            coefba := 1 - (MntTotalBA / (MntTotalEnc + MntTotalBA))
          else
            coefba := 1;
          // parcours des lignes
          que_Lignes.First();
          while not que_Lignes.Eof do
          begin
            que_MAJ.SQL.Text := 'update cshticketl set tkl_pxnn = tkl_pxnn * ' + StringReplace(FloatToStr(coefba), DecimalSeparator, '.', []) + ' where tkl_id = ' + que_Lignes.FieldByName('tkl_id').AsString + ';';
            que_MAJ.ExecSQL();
            que_MAJ.SQL.Text := 'execute procedure pr_updatek(' + que_Lignes.FieldByName('tkl_id').AsString + ', 0);';
            que_MAJ.ExecSQL();

            que_Lignes.Next();
          end;

          // consignation dan la piste d'audit
          que_MAJ.SQL.Text := 'execute procedure LDF_CONSIGNATION_AUDIT(' + IntToStr(aTKE_ID) + ', 999, ''correction d''''un bug sur l valorisation de ligne de ticket n''''ayant pas tenu compte du bon de reduction'', 2, ''hotline'', 0);';
          que_MAJ.ExecSQL();

          Result := true;
        end
        else
          aMsg := Format('Pas de correspondance des montants (entête : A1 = %m; A2 = %m; Total des lignes = %m; Entaissement : Mnt = %m; BA = %m)',
                         [MntTotalTicket, MntTotalLoc, MntTotalLignes, MntTotalEnc, MntTotalBA]);
      finally
        que_Lignes.Close();
      end;
    end;
  finally
    que_Entete.Close();
  end;
end;

function TDm_Main.CorrigeTicketRemiseFidSansBon(aTKE_ID: Integer; var aMsg: string) : boolean;
var
  que_procedure : TIBOQuery;
begin
  Result := false;
  aMsg := '';
  que_procedure := Que_Div;

  if que_procedure.Active then
    que_procedure.Close();

  try
    // Création dela procedure !
    que_procedure.ParamCheck := false;
    que_procedure.SQL.Clear();
    que_procedure.SQL.Add('CREATE PROCEDURE TMP_CC_FIX_TKE (');
    que_procedure.SQL.Add('    TKEID INTEGER)');
    que_procedure.SQL.Add('AS');
    que_procedure.SQL.Add('DECLARE VARIABLE TKEDATE TIMESTAMP;');
    que_procedure.SQL.Add('DECLARE VARIABLE TKETOTNETA1_ORG NUMERIC(18,7);');
    que_procedure.SQL.Add('DECLARE VARIABLE TKETOTBRUTA1_NEW NUMERIC(18,7);');
    que_procedure.SQL.Add('DECLARE VARIABLE TKECLTID INTEGER;');
    que_procedure.SQL.Add('DECLARE VARIABLE CBICB VARCHAR(64);');
    que_procedure.SQL.Add('DECLARE VARIABLE TOTREMISEEURO NUMERIC(18,7);');
    que_procedure.SQL.Add('DECLARE VARIABLE REMISEPOUR NUMERIC(18,7);');
    que_procedure.SQL.Add('DECLARE VARIABLE TKLCOUNT INTEGER;');
    que_procedure.SQL.Add('DECLARE VARIABLE TKLID INTEGER;');
    que_procedure.SQL.Add('DECLARE VARIABLE TKLQTE INTEGER;');
    que_procedure.SQL.Add('DECLARE VARIABLE TKLPXNET NUMERIC(18,7);');
    que_procedure.SQL.Add('DECLARE VARIABLE CUMULTKLPXNN NUMERIC(18,7);');
    que_procedure.SQL.Add('DECLARE VARIABLE POSID INTEGER;');
    que_procedure.SQL.Add('DECLARE VARIABLE MAGID INTEGER;');
    que_procedure.SQL.Add('DECLARE VARIABLE NEWID INTEGER;');
    que_procedure.SQL.Add('DECLARE VARIABLE SESID INTEGER;');
    que_procedure.SQL.Add('DECLARE VARIABLE TKLPXNN NUMERIC(18,7);');
    que_procedure.SQL.Add('DECLARE VARIABLE TKLPXBRUT NUMERIC(18,7);');
    que_procedure.SQL.Add('DECLARE VARIABLE REMISEPOURL NUMERIC(18,7);');
    que_procedure.SQL.Add('BEGIN');
    que_procedure.SQL.Add('  /******************************************************************************/');
    que_procedure.SQL.Add('  /* Date        | Nom | Commentaire                                            */');
    que_procedure.SQL.Add('  /* 31-10-2021  | CC  | Mantis 7262 : procédure de correction                  */');
    que_procedure.SQL.Add('  /*                                                                            */');
    que_procedure.SQL.Add('  /*                                                                            */');
    que_procedure.SQL.Add('  /*                                                                            */');
    que_procedure.SQL.Add('  /******************************************************************************/');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  IF (:TKEID IS NULL) THEN');
    que_procedure.SQL.Add('    TKEID = 0;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  IF (:TKEID <= 0) THEN');
    que_procedure.SQL.Add('    EXIT;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  CUMULTKLPXNN = 0;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  SELECT TKE.TKE_DATE, TKE.TKE_TOTNETA1, TKE.TKE_CLTID, CBI.CBI_CB, SES.SES_POSID, POS.POS_MAGID, SES.SES_ID');
    que_procedure.SQL.Add('  FROM CSHTICKET TKE');
    que_procedure.SQL.Add('    JOIN K K1 ON K1.K_ID = TKE.TKE_ID AND K1.K_ENABLED = 1');
    que_procedure.SQL.Add('    /* AVEC CLIENT AVEC CARTE FID */');
    que_procedure.SQL.Add('    JOIN ARTCODEBARRE CBI');
    que_procedure.SQL.Add('    JOIN K K2 ON K2.K_ID = CBI.CBI_ID AND K2.K_ENABLED = 1 ON CBI.CBI_CLTID = TKE.TKE_CLTID AND CBI.CBI_TYPE = 5');
    que_procedure.SQL.Add('    JOIN CSHSESSION SES');
    que_procedure.SQL.Add('    JOIN K K3 ON K3.K_ID = SES.SES_ID AND K3.K_ENABLED = 1 ON SES.SES_ID = TKE.TKE_SESID');
    que_procedure.SQL.Add('    JOIN GENPOSTE POS ON POS.POS_ID = SES.SES_POSID');
    que_procedure.SQL.Add('  WHERE TKE.TKE_ID = :TKEID AND');
    que_procedure.SQL.Add('        /* PAS DE SOUS-TOTAL AVEC REDUCTION /!\*/');
    que_procedure.SQL.Add('        NOT EXISTS(SELECT TKL.TKL_ID');
    que_procedure.SQL.Add('                   FROM CSHTICKETL TKL');
    que_procedure.SQL.Add('                     JOIN K K4 ON K4.K_ID = TKL.TKL_ID AND K4.K_ENABLED = 1');
    que_procedure.SQL.Add('                   WHERE TKL.TKL_TKEID = TKE.TKE_ID AND');
    que_procedure.SQL.Add('                         TKL.TKL_SSTOTAL = 1 AND');
    que_procedure.SQL.Add('                         TKL.TKL_REMISE <> 0) AND');
    que_procedure.SQL.Add('        /* PAS DE MODE D''ENCAISSEMENT AVEC PSEUDO REMISE */');
    que_procedure.SQL.Add('        NOT EXISTS(SELECT ENC.ENC_ID');
    que_procedure.SQL.Add('                   FROM CSHENCAISSEMENT ENC');
    que_procedure.SQL.Add('                     JOIN K K5 ON K5.K_ID = ENC.ENC_ID AND K5.K_ENABLED = 1');
    que_procedure.SQL.Add('                     JOIN CSHMODEENC MEN ON ENC.ENC_MENID = MEN.MEN_ID AND MEN.MEN_REMISEOTO = 1');
    que_procedure.SQL.Add('                   WHERE ENC.ENC_TKEID = TKE.TKE_ID) AND');
    que_procedure.SQL.Add('        /* PAS DE TICKET AVEC OFR */');
    que_procedure.SQL.Add('        NOT EXISTS(SELECT OGE.OGE_ID');
    que_procedure.SQL.Add('                   FROM OFRGENETETE OGE');
    que_procedure.SQL.Add('                     JOIN K K6 ON K6.K_ID = OGE.OGE_ID AND K6.K_ENABLED = 1');
    que_procedure.SQL.Add('                   WHERE OGE.OGE_TKEID = TKE.TKE_ID)');
    que_procedure.SQL.Add('  INTO :TKEDATE, :TKETOTNETA1_ORG, :TKECLTID, :CBICB, :POSID, :MAGID, :SESID;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  IF (:SESID IS NULL) THEN');
    que_procedure.SQL.Add('    SESID = 0;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  IF (:SESID <= 0) THEN');
    que_procedure.SQL.Add('    EXIT;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  SELECT SUM(TKL.TKL_PXNET)');
    que_procedure.SQL.Add('  FROM CSHTICKETL TKL');
    que_procedure.SQL.Add('    JOIN K K1 ON K1.K_ID = TKL.TKL_ID AND K1.K_ENABLED = 1');
    que_procedure.SQL.Add('  WHERE TKL.TKL_TKEID = :TKEID');
    que_procedure.SQL.Add('  INTO :TKETOTBRUTA1_NEW;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  IF (:TKETOTBRUTA1_NEW = 0) THEN');
    que_procedure.SQL.Add('    EXIT;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  REMISEPOUR = 100 - ((:TKETOTNETA1_ORG / :TKETOTBRUTA1_NEW) * 100);');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  UPDATE CSHTICKET TKE');
    que_procedure.SQL.Add('  SET TKE.TKE_TOTBRUTA1 = :TKETOTBRUTA1_NEW,');
    que_procedure.SQL.Add('      TKE.TKE_REMISE = 0,');
    que_procedure.SQL.Add('      TKE.TKE_REMA1 = :REMISEPOUR');
    que_procedure.SQL.Add('  WHERE TKE.TKE_ID = :TKEID;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  TOTREMISEEURO = :TKETOTBRUTA1_NEW - :TKETOTNETA1_ORG;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  SELECT COUNT(TKL.TKL_ID)');
    que_procedure.SQL.Add('  FROM CSHTICKETL TKL');
    que_procedure.SQL.Add('    JOIN K K1 ON K1.K_ID = TKL.TKL_ID AND K1.K_ENABLED = 1');
    que_procedure.SQL.Add('  WHERE TKL.TKL_TKEID = :TKEID AND');
    que_procedure.SQL.Add('        TKL.TKL_ARTID > 0 AND');
    que_procedure.SQL.Add('        TKL.TKL_QTE <> 0');
    que_procedure.SQL.Add('  INTO :TKLCOUNT;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  FOR SELECT TKL.TKL_ID, TKL.TKL_QTE, TKL.TKL_PXNET, TKL.TKL_PXBRUT, TKL.TKL_REMISE');
    que_procedure.SQL.Add('      FROM CSHTICKETL TKL');
    que_procedure.SQL.Add('        JOIN K K1 ON K1.K_ID = TKL.TKL_ID AND K1.K_ENABLED = 1');
    que_procedure.SQL.Add('      WHERE TKL.TKL_TKEID = :TKEID AND');
    que_procedure.SQL.Add('            TKL.TKL_ARTID > 0 AND');
    que_procedure.SQL.Add('            TKL.TKL_QTE <> 0');
    que_procedure.SQL.Add('      ORDER BY TKL.TKL_ID ASC ROWS :TKLCOUNT - 1');
    que_procedure.SQL.Add('      INTO :TKLID, :TKLQTE, :TKLPXNET, :TKLPXBRUT, :REMISEPOURL');
    que_procedure.SQL.Add('  DO');
    que_procedure.SQL.Add('  BEGIN');
    que_procedure.SQL.Add('    /*TKLPXNN = (:TKLPXNET - ((:TKLPXNET / :TKETOTBRUTA1_NEW) * :TOTREMISEEURO)) / :TKLQTE;*/');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('    TKLPXNN = :TKLPXNET / :TKETOTBRUTA1_NEW;');
    que_procedure.SQL.Add('    TKLPXNN = :TKLPXNN * :TOTREMISEEURO;');
    que_procedure.SQL.Add('    TKLPXNN = :TKLPXNET - :TKLPXNN;');
    que_procedure.SQL.Add('    TKLPXNN = :TKLPXNN / :TKLQTE;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('    SELECT NBOUT');
    que_procedure.SQL.Add('    FROM ROUNDRV(:TKLPXNN, 2)');
    que_procedure.SQL.Add('    INTO :TKLPXNN;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('    IF ((:TKLPXBRUT <> 0) AND');
    que_procedure.SQL.Add('        (:TKLQTE <> 0)) THEN');
    que_procedure.SQL.Add('    BEGIN');
    que_procedure.SQL.Add('      /*REMISEPOURL = 100 - ((:TKLPXNET / (:TKLPXBRUT * :TKLQTE)) * 100);*/');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('      REMISEPOURL = :TKLPXBRUT * :TKLQTE;');
    que_procedure.SQL.Add('      REMISEPOURL = :TKLPXNET / :REMISEPOURL;');
    que_procedure.SQL.Add('      REMISEPOURL = :REMISEPOURL * 100;');
    que_procedure.SQL.Add('      REMISEPOURL = 100 - :REMISEPOURL;');
    que_procedure.SQL.Add('    END');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('    CUMULTKLPXNN = :CUMULTKLPXNN + (:TKLQTE * :TKLPXNN);');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('    UPDATE CSHTICKETL TKL');
    que_procedure.SQL.Add('    SET TKL.TKL_PXNN = :TKLPXNN,');
    que_procedure.SQL.Add('        TKL.TKL_REMISE = :REMISEPOURL');
    que_procedure.SQL.Add('    WHERE TKL.TKL_ID = :TKLID;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('    EXECUTE PROCEDURE PR_UPDATEK(:TKLID, 0);');
    que_procedure.SQL.Add('  END');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  SELECT TKL.TKL_ID, TKL.TKL_QTE, TKL.TKL_PXNET, TKL.TKL_PXBRUT, TKL.TKL_REMISE');
    que_procedure.SQL.Add('  FROM CSHTICKETL TKL');
    que_procedure.SQL.Add('    JOIN K K1 ON K1.K_ID = TKL.TKL_ID AND K1.K_ENABLED = 1');
    que_procedure.SQL.Add('  WHERE TKL.TKL_TKEID = :TKEID AND');
    que_procedure.SQL.Add('        TKL.TKL_ARTID > 0 AND');
    que_procedure.SQL.Add('        TKL.TKL_QTE <> 0');
    que_procedure.SQL.Add('  ORDER BY TKL.TKL_ID DESC ROWS 1');
    que_procedure.SQL.Add('  INTO :TKLID, :TKLQTE, :TKLPXNET, :TKLPXBRUT, :REMISEPOURL;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  TKLPXNN = (:TKETOTNETA1_ORG - :CUMULTKLPXNN) / :TKLQTE;');
    que_procedure.SQL.Add('  IF (:TKLPXNN < 0) THEN');
    que_procedure.SQL.Add('    TKLPXNN = :TKLPXNN * -1;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  IF ((:TKLPXBRUT <> 0) AND');
    que_procedure.SQL.Add('      (:TKLQTE <> 0)) THEN');
    que_procedure.SQL.Add('  BEGIN');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('    /*REMISEPOURL = 100 - ((:TKLPXNET / (:TKLPXBRUT * :TKLQTE)) * 100);*/');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('    REMISEPOURL = :TKLPXBRUT * :TKLQTE;');
    que_procedure.SQL.Add('    REMISEPOURL = :TKLPXNET / :REMISEPOURL;');
    que_procedure.SQL.Add('    REMISEPOURL = :REMISEPOURL * 100;');
    que_procedure.SQL.Add('    REMISEPOURL = 100 - :REMISEPOURL;');
    que_procedure.SQL.Add('  END');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  UPDATE CSHTICKETL TKL');
    que_procedure.SQL.Add('  SET TKL.TKL_PXNN = :TKLPXNN,');
    que_procedure.SQL.Add('      TKL.TKL_REMISE = :REMISEPOURL');
    que_procedure.SQL.Add('  WHERE TKL.TKL_ID = :TKLID;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  EXECUTE PROCEDURE PR_UPDATEK(:TKLID, 0);');
    que_procedure.SQL.Add('  EXECUTE PROCEDURE PR_UPDATEK(:TKEID, 0);');
    que_procedure.SQL.Add('  EXECUTE PROCEDURE LDF_CONSIGNATION_AUDIT(:TKEID, 999, ''Correction remise'', 3, NULL, NULL);');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  SELECT ID');
    que_procedure.SQL.Add('  FROM PR_NEWK(''FIDREPRISE'')');
    que_procedure.SQL.Add('  INTO :NEWID;');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('  INSERT INTO FIDREPRISE (FIR_ID, FIR_MAGID, FIR_CLTID, FIR_CARTEID, FIR_POSID, FIR_SESID, FIR_TRANSID, FIR_TKEID,');
    que_procedure.SQL.Add('                          FIR_DATE, FIR_TYPE, FIR_ENVOYE)');
    que_procedure.SQL.Add('  VALUES (:NEWID, :MAGID, :TKECLTID, :CBICB, :POSID, :SESID, 0, :TKEID, :TKEDATE, 0, 0);');
    que_procedure.SQL.Add('');
    que_procedure.SQL.Add('END;');
    que_procedure.ExecSQL();

    // execution sur l'ID fournis !
    que_procedure.SQL.Text := 'execute procedure TMP_CC_FIX_TKE(' + IntToStr(aTKE_ID) + ');';
    que_procedure.ExecSQL();
//    if que_procedure.RowsAffected > 0 then
      Result := true;
//    else
//      aMsg := 'No rows affected';

    // drop de la procedure
    que_procedure.SQL.Text := 'drop procedure TMP_CC_FIX_TKE;';
    que_procedure.ExecSQL();

    // gestion des paramètres
    que_procedure.ParamCheck := true;
  except
    on e : Exception do
    begin
      aMsg := e.ClassName + ' - ' + e.Message;
    end;
  end;
end;

//

procedure CopierIDAvecDesOR(NomID: string; ADataSet: TDataSet);
var
  OldPos : TBookmark;
  Script : string;
begin
  OldPos := ADataSet.GetBookmark();
  try
    Script := '';
    ADataSet.DisableControls();
    ADataSet.First;
    while not(ADataSet.Eof) do
    begin
      if Script <> '' then
        Script := Script + ' or ' + #13#10;
      Script := Script + NomID + ' = ' + inttostr(ADataSet.fieldbyname(NomID).AsInteger);
      ADataSet.Next();
    end;
    if Script <> '' then
      Clipboard.AsText := Script;
  finally
    ADataSet.GotoBookmark(OldPos);
    ADataSet.EnableControls();
  end;
end;

procedure PreparerLesUpdates(NomTable, NomID: string; ADataSet: TDataSet; SeekField : boolean = false);
var
  OldPos : TBookmark;
  Script : string;
begin
  OldPos := ADataSet.GetBookmark();
  try
    Script := '';
    ADataSet.DisableControls();
    ADataSet.First;
    while not(ADataSet.Eof) do
    begin
      Script := Script + Dm_Main.PreparerUnUpdate(NomTable, NomID, ADataSet, SeekField);
      ADataSet.Next;
    end;
    if Script <> '' then
      Clipboard.AsText := Script;
  finally
    ADataSet.GotoBookmark(OldPos);
    ADataSet.EnableControls();
  end;
end;

procedure PreparerLesK_ENABLEDa1(NomID: string; ADataSet: TDataSet);
var
  OldPos : TBookmark;
  Script : string;
begin
  OldPos := ADataSet.GetBookmark();
  try
    Script := '';
    ADataSet.DisableControls();
    ADataSet.First;
    while not(ADataSet.Eof) do
    begin
      Script := Script + Dm_Main.PreparerUneSupprLog(NomID, ADataSet);
      ADataSet.Next();
    end;
    if Script <> '' then
      Clipboard.AsText := Script;
  finally
    ADataSet.GotoBookmark(OldPos);
    ADataSet.EnableControls();
  end;
end;

procedure PreparerLesSuppPhy(NomTable, NomID: string; ADataSet: TDataSet);
var
  OldPos : TBookmark;
  Script : string;
begin
  OldPos := ADataSet.GetBookmark();
  try
    Script := '';
    ADataSet.DisableControls();
    ADataSet.First;
    while not(ADataSet.Eof) do
    begin
      Script := Script + Dm_Main.PreparerUneSupprPhy(NomTable, NomID, ADataSet);
      ADataSet.Next;
    end;
    if Script <> '' then
      Clipboard.AsText := Script;
  finally
    ADataSet.GotoBookmark(OldPos);
    ADataSet.EnableControls();
  end;
end;

procedure CreerNouvLigne(NomTable, NomIndexID: string);
begin
  Clipboard.AsText := Dm_Main.CreerNouvLigne(NomTable, NomIndexID, [], []);
end;


FUNCTION RoundRv(Value: Double; Precision: Integer): Double;
VAR
  i: integer;
  R: Int64;
BEGIN
  R := 1;
  IF precision > 0 THEN
    FOR i := 1 TO precision DO
      R := R * 10;

  IF Value > 0 THEN
  BEGIN
    TRY
      Result := Trunc((value * R) + 0.5) / R;
    EXCEPT
      Result := value;
    END;
  END
  ELSE BEGIN
    IF Value = 0 THEN
      Result := 0
    ELSE
      Result := -Trunc((Abs(Value) * R) + 0.5) / R;
  END;
  // Result := ( Round ( Value * R ) ) / R;
END;


//arrondi à 2 decimal après la virgule
//OBU 12/08/2019 : Retour à la version initiale de cette fonction
function ArrondiA2(v: Double): Double;
VAR
  TpV: Currency;
  v1: integer;
  s: STRING;
  Ecart: integer;
BEGIN
  TpV := v;
  s := inttostr(Trunc(TpV * 1000));
  Ecart := 0;
  TRY
    v1 := StrToInt(s[Length(s)]);
    IF v1 >= 5 THEN
    BEGIN
      IF v < 0 THEN
        Ecart := -1
      ELSE
        Ecart := 1;
    END;
  EXCEPT
  END;
  Result := (Trunc(TpV * 100) + Ecart) / 100;
end;


procedure TDm_Main.GetNomReglement(MEN_ID: integer;var MenNom: string;var ModeType: integer;var OkSupp: boolean);
begin
  MenNom := '';
  ModeType := 0;
  OkSupp := false;
  with Que_NomEncais do
  begin
    Active := false;
    ParamByName('MENID').AsInteger := MEN_ID;
    Active:=true;
    First;
    if not(Eof) then
    begin
      MenNom := fieldbyname('MEN_NOM').AsString;
      ModeType := fieldbyname('MEN_TYPEMOD').AsInteger;
      OkSupp := (fieldbyname('K_ENABLED').AsInteger<>1);
    end;
    Active := false;
  end;
end;

end.
