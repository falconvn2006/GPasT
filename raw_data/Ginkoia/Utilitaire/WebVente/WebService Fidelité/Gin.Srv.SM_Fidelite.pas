unit Gin.Srv.SM_Fidelite;

interface

uses  System.SysUtils, System.Classes, Windows, System.Json, System.DateUtils, System.Generics.Collections,
      REST.Json,
      Datasnap.DSServer, Datasnap.DSAuth,
      FireDAC.Comp.Client, FireDac.Dapt, FireDac.Stan.Async,
      Gin.Com.Log ;

type
//==============================================================================
  TReturnCode = class
  private
    FCode : Integer ;
    FMsg  : string  ;
  public
    constructor Create(aCode : integer ;  aMsg: string) ;
  published
    property Code : Integer     read FCode      write FCode ;
    property Msg  : string      read FMsg       write FMsg ;
  end;
//------------------------------------------------------------------------------
  TBonAchat = class
  private
    FId       : Int64;
    FMontant  : Currency;
    FCltId    : Int64;
    FTkeId    : Int64;
    FCbtId    : Int64;
    FUsed     : boolean ;
    FDateVal  : TDateTime ;
  published
    property Id : Int64           read FId        write FId ;
    property CltId : Int64        read FCltId     write FCltId ;
    property Montant : Currency   read FMontant   write FMontant ;
    property TkeId : Int64        read FTkeId     write FTkeId ;
    property CbtId : Int64        read FCbtId     write FCbtId ;
    property Used : boolean       read FUsed      write FUsed ;
    property DateVal : TDateTime  read FDateVal  write FDateVal ;
  end;
//------------------------------------------------------------------------------
  TBonAchats = Array of TBonAchat ;
//------------------------------------------------------------------------------
  TResultFid = class
  private
    FReturnCode : TReturnCode ;
    FBonsAchats : TBonAchats ;
    FTypeFid    : Integer ;
    FNbPts      : Integer ;
    FNbPass     : Integer ;
  public
    constructor Create ;
    destructor Destroy ; override ;
    procedure clearBonAchats ;
  published
    property ReturnCode: TReturnCode   read FReturnCode write FReturnCode ;
    property BonAchats : TBonAchats    read FBonsAchats write FBonsAchats ;
    property TypeFid   : integer       read FTypeFid    write FTypeFid ;
    property NbPts     : integer       read FNbPts      write FNbPts ;
    property NbPass    : integer       read FNbPass     write FNbPass ;
  end;
//------------------------------------------------------------------------------
  TResultUseBA = class
  private
    FReturnCode: TReturnCode ;
    FTransId   : Int64 ;
  public
    constructor Create ;
    destructor Destroy ; override ;
  published
    property ReturnCode: TReturnCode   read FReturnCode write FReturnCode ;
    property TransId   : Int64         read FTransId    write FTransId ;
  end;
//------------------------------------------------------------------------------
  TSecureKey = class
  private
    FCode : string ;
    FDate : TDateTime ;
    FHash : string ;
  published
    property Code  : string      read FCode      write FCode ;
    property Date  : TDateTime   read FDate      write FDate ;
    property Hash  : string      read FHash      write FHash ;
  end;
//------------------------------------------------------------------------------
  TSitePresta = class
  private
    FId: Int64;
    FNom: string;
    FCode: string;
    FKey: string;
    FSuperUser : boolean ;
  published
    property Id : Int64          read FId        write FId ;
    property Nom : string        read FNom       write FNom ;
    property Code : string       read FCode      write FCode ;
    property Key  : string       read FKey       write FKey ;
    property SuperUser : boolean read FSuperUser write FSuperUser ;
  end;
//------------------------------------------------------------------------------
{$METHODINFO ON}
  TSM_Fidelite = class(TComponent)
  private
    FConnection : TFDConnection ;

    function parseSecureKey(aSecureStr : string) : TSitePresta ;
    function interleaveStrings(str1, str2 : string) : string ;

    function doGetFidClient(aSecureStr: string; aCltId : Int64 ; aCltChrono : string ; aSiteCode : integer) : TResultFid ;

    function getDateTimeUTC : TDateTime ;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Test : TJSONObject ;
    function TestLogin(aSecureStr : string) : TJSONObject ;
    function getDateHeureGMT : string ;

    function getFidClientById(aSecureStr : string ; aSiteCode : integer ; aId : Int64) : TJSONObject ;
    function getFidClientByChrono(aSecureStr : string ; aSiteCode : integer ; aChrono : string) : TJSONObject ;

    function useBonAchatFid(aSecureStr : string ; ABAId : Int64) : TJSONObject ;
    function cancelBonAchatFid(aSecureStr : string ; ABAId, ATransId : Int64) : TJSONObject ;
    function confirmUseBonAchatFid(aSecureStr : string ;  ABAId : Int64) : TJSONObject ;
  end;
{$METHODINFO OFF}
//==============================================================================

implementation

uses Gin.Srv.DM_Main ;

//==============================================================================

//==============================================================================
{ TSM_Fidelite }
//==============================================================================
constructor TSM_Fidelite.Create(AOwner: TComponent);
begin
  inherited;

  FConnection := DM_Main.getNewConnexion ;
end;
//------------------------------------------------------------------------------
destructor TSM_Fidelite.Destroy;
begin
  FConnection.DisposeOf ;

  inherited;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.doGetFidClient(aSecureStr: string; aCltId: Int64 ;  aCltChrono : String ; aSiteCode : integer): TResultFid;
var
  vTrans : TFDTransaction ;
  vQuery : TFDQuery ;
  vSitePresta : TSitePresta ;
  vBonAchat : TBonAchat ;
  vMagId    : Int64 ;
  vCltFid   : Integer ;
  ia        : integer ;
begin
  Result := TResultFid.Create ;
  Result.ReturnCode.FCode := 500 ;
  Result.ReturnCode.FMsg  := 'Erreur interne' ;
  Result.TypeFid := 0 ;
  Result.FNbPts  := 0 ;
  Result.FNbPass := 0 ;

  try
    vSitePresta := parseSecureKey(aSecureStr) ;
  except
    on E:Exception do
    begin
      Result.ReturnCode.FCode := 403 ;
      Result.FReturnCode.FMsg := E.Message ;
      Exit ;
    end;
  end;


  if (aCltId < 0) and (aCltChrono = '')
    then Exit ;

  vTrans := DM_Main.getNewTransaction(FConnection) ;
  vQuery := DM_Main.getNewQuery(FConnection, vTrans) ;
  try
    vQuery.SQL.Text := 'SELECT POS_MAGID FROM ARTSITEWEB ' +
                       'JOIN K ON K_ID = ASS_ID AND K_ENABLED=1 ' +
                       'JOIN GENPOSTE ON POS_ID = ASS_POSID ' +
                       'JOIN K ON K_ID = POS_ID AND K_ENABLED=1  ' +
                       'WHERE ASS_CODE = :SITECODE' ;
    vQuery.ParamByName('SITECODE').AsInteger := aSiteCode ;
    vQuery.Open ;

    if vQuery.IsEmpty then
    begin
      Result.ReturnCode.FCode := 401 ;
      Result.ReturnCode.FMsg  := 'Code site invalide' ;
      Exit ;
    end;

    vMagId := vQuery.FieldByName('POS_MAGID').AsLargeInt ;

    if vMagId < 1 then
    begin
      Result.ReturnCode.FCode := 402 ;
      Result.ReturnCode.FMsg  := 'Magasin non trouvé' ;
      Exit ;
    end;

    if aCltId > 0 then
    begin
      vQuery.SQL.Text := 'SELECT CLT_ID, CLT_FIDELITE FROM CLTCLIENT ' +
                         'JOIN K ON K_ID = CLT_ID AND K_ENABLED=1 ' +
                         'WHERE CLT_ID = :CLTID' ;
      vQuery.ParamByName('CLTID').AsLargeInt := aCltId ;
    end else begin
      vQuery.SQL.Text := 'SELECT CLT_ID, CLT_FIDELITE FROM CLTCLIENT ' +
                         'JOIN K ON K_ID = CLT_ID AND K_ENABLED=1 ' +
                         'WHERE CLT_NUMERO = :CLTNUMERO' ;
      vQuery.ParamByName('CLTNUMERO').AsString := aCltChrono ;
    end;
    vQuery.Open ;
    if not vQuery.IsEmpty then
    begin
      aCltId  := vQuery.FieldByName('CLT_ID').AsLargeInt ;
      vCltFid := vQuery.FieldByName('CLT_FIDELITE').AsLargeInt ;
    end else begin
      Result.ReturnCode.FCode := 403 ;
      Result.ReturnCode.FMsg  := 'Client non trouvé' ;
      Exit ;
    end;

    // Bon d'achats
    vQuery.SQL.Text := 'SELECT BAC_ID, BAC_CLTID, BAC_MONTANT, BAC_TKEID, BAC_CBTID, BAC_USED, F_ADDMONTH(fid_date, ctf_validiteba) BAC_DATEVAL FROM CLTBONACHAT ' +
                       'JOIN K ON K_ID = BAC_ID AND K_ENABLED=1 ' +
                       'JOIN CLTFIDELITE ON FID_BACID = BAC_ID ' +
                       'JOIN K ON K_ID = FID_ID AND K_ENABLED=1 ' +
                       'JOIN GENMAGGESTIONCF MCF1 ON FID_MAGID = MCF1.MCF_MAGID ' +
                       'JOIN K ON K_ID = MCF1.MCF_ID AND K_ENABLED=1 ' +
                       'JOIN GENMAGGESTIONCF MCF2 ON MCF2.MCF_GCFID = MCF2.MCF_GCFID ' +
                       'JOIN K ON K_ID = MCF2.mcf_id AND K_ENABLED=1 ' +
                       'JOIN CSHPARAMCF ON CTF_GCFID = MCF1.MCF_GCFID ' +
                       'JOIN K ON K_ID = CTF_ID AND K_ENABLED=1 ' +
                       'WHERE MCF2.MCF_MAGID=:MAGID AND BAC_CLTID = :CLTID AND BAC_TKEID=0 AND BAC_USED=0 AND F_ADDMONTH(fid_date, ctf_validiteba) >= CURRENT_DATE' ;
    vQuery.ParamByName('CLTID').AsLargeInt := aCltId ;
    vQuery.ParamByName('MAGID').AsLargeInt := vMagId ;
    vQuery.Open ;

    while not vQuery.Eof do
    begin
      vBonAchat := TBonAchat.Create ;
      DM_Main.fillObjectWithQuery(vBonAchat, vQuery, 'BAC') ;

      ia := Length( Result.FBonsAchats ) ;
      setLength(Result.FBonsAchats, ia+1) ;
      Result.FBonsAchats[ia] := vBonAchat ;

      vQuery.Next ;
    end;

    // Fid
    vQuery.SQL.Text := 'SELECT NBPASS, SOLDEFID FROM PR_CLTDERNPASS(:CLTID, :MAGID)' ;
    vQuery.ParamByName('CLTID').AsLargeInt := aCltId ;
    vQuery.ParamByName('MAGID').AsLargeInt := vMagId ;
    vQuery.Open ;

    if not vQuery.IsEmpty then
    begin
      Result.FTypeFid := vCltFid ;
      Result.NbPass  := vQuery.FieldByName('NBPASS').AsInteger ;
      Result.NbPts   := vQuery.FieldByName('SOLDEFID').AsInteger ;
    end;

    Result.ReturnCode.FCode := 200 ;
    Result.ReturnCode.FMsg  := 'OK' ;
  finally
    vQuery.Free ;
    vTrans.Free ;
  end;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.getFidClientByChrono(aSecureStr: string; aSiteCode : integer ;
  aChrono: string): TJSONObject;
var
  vResultFid : TResultFid ;
begin
  Result := nil ;

  vResultFid := doGetFidClient(aSecureStr, 0, aChrono, aSiteCode) ;
  Result := TJson.ObjectToJsonObject(vResultFid) ;

  vResultFid.clearBonAchats ;
  vResultFid.Free ;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.getFidClientById(aSecureStr: string; aSiteCode : Integer ;
  aId: Int64): TJSONObject;
var
  vResultFid : TResultFid ;
begin
  Result := nil ;

  vResultFid := doGetFidClient(aSecureStr, aId, '', aSiteCode) ;
  Result := TJson.ObjectToJsonObject(vResultFid) ;

  vResultFid.clearBonAchats ;
  vResultFid.Free ;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.useBonAchatFid(aSecureStr : string ;  ABAId: Int64): TJSONObject;
var
  vTrans     : TFDTransaction ;
  vQuery     : TFDQuery ;
  vSitePresta: TSitePresta ;
  vBonAchat  : TBonAchat ;
  vResultUseBA  : TResultUseBA ;
  vNewId     : Int64 ;
  vReturnCode  : TReturnCode ;
begin
  vResultUseBA := TResultUseBA.Create ;
  vResultUseBA.FReturnCode.FCode := 500 ;
  vResultUseBA.FReturnCode.FMsg  := 'Erreur interne' ;
  vResultUseBA.FTransId          := 0 ;

  vTrans := DM_Main.getNewTransaction(FConnection) ;
  vQuery := DM_Main.getNewQuery(FConnection, vTrans) ;
  try

    vSitePresta := nil ;
    try
      vSitePresta := parseSecureKey(aSecureStr) ;
    except
      on E:Exception do
      begin
        vReturnCode := TReturnCode.Create(403, 'Authentification invalide : ' + E.Message );
        vResultUseBA.FReturnCode.FCode := vReturnCode.FCode ;
        vResultUseBA.FReturnCode.FMsg  := vReturnCode.FMsg ;
        vReturnCode.Free ;
        Exit ;
      end;
    end;

    if aBAId < 1 then
    begin
        vResultUseBA.ReturnCode.FCode := 404 ;
        vResultUseBA.ReturnCode.FMsg  := 'Bon d''Achat invalide' ;
        Exit ;
    end;

    vTrans.StartTransaction ;

    // Recuperation du bon d'achat
    vQuery.SQL.Text := 'SELECT BAC_ID, BAC_CLTID, BAC_MONTANT, BAC_TKEID, BAC_CBTID, BAC_USED FROM CLTBONACHAT  ' +
                       'JOIN K ON K_ID = BAC_ID AND K_ENABLED=1 ' +
                       'WHERE BAC_ID = :BACID' ;
    vQuery.ParamByName('BACID').AsLargeInt := aBAId ;
    vQuery.Open ;

    if not vQuery.IsEmpty then
    begin
      vBonAchat := TBonAchat.Create ;
      DM_Main.fillObjectWithQuery(vBonAchat, vQuery, 'BAC');
    end else begin
      vResultUseBA.ReturnCode.FCode := 401 ;
      vResultUseBA.ReturnCode.FMsg  := 'Bon d''Achat non trouvé' ;
      Exit ;
    end;
    vQuery.Close ;

    try
      vResultUseBA.ReturnCode.FCode := 200 ;
      vResultUseBa.ReturnCode.FMsg  := 'OK' ;

      if vBonAchat.FCbtId <> 0 then
      begin
        vResultUseBA.ReturnCode.FCode := 302 ;
        vResultUseBa.ReturnCode.FMsg  := 'Bon d''achat déja réservé' ;
        vResultUseBA.FTransId         := vBonAchat.FCbtId ;
      end;

      if (vBonAchat.FTkeId <> 0) or vBonAchat.FUsed then
      begin
        vResultUseBA.ReturnCode.FCode := 301 ;
        vResultUseBa.ReturnCode.FMsg  := 'Bon d''achat déja utilisé' ;
        vResultUseBA.FTransId         := 0 ;
      end;


      // Creation de la transaction
      try
        vTrans.StartTransaction ;

        vNewId := DM_Main.getNewK('CLTBATRANS', FConnection, vTrans) ;
        if vResultUseBA.ReturnCode.FCode = 200 then
        begin

          vQuery.SQL.Text := 'UPDATE CLTBONACHAT SET BAC_CBTID=:CBTID ' +
                             'WHERE BAC_ID=:BACID' ;
          vQuery.ParamByName('BACID').AsLargeInt := vBonAchat.FId ;
          vQuery.ParamByName('CBTID').AsLargeInt := vNewId ;
          vQuery.ExecSQL ;

          DM_Main.updateK(vBonAchat.FId, TGinKAction.gkaUpdate, FConnection, vTrans);
          vResultUseBA.FTransId         := vNewId ;
        end;

        vQuery.SQL.Text := 'INSERT INTO CLTBATRANS (CBT_ID, CBT_BACID, CBT_ASPID, CBT_DATE, CBT_ACTION, CBT_RESULT) ' +
                           'VALUES (:ID, :BACID, :ASPID, :DATE, :ACTION, :RESULT)' ;
        vQuery.ParamByName('ID').AsLargeInt     := vNewId ;
        vQuery.ParamByName('BACID').AsLargeInt  := vBonAchat.FId ;
        vQuery.ParamByName('ASPID').AsLargeInt  := vSitePresta.FId ;
        vQuery.ParamByName('DATE').AsDateTime   := now ;
        vQuery.ParamByName('ACTION').AsString   := 'useBonAchatFid' ;
        vQuery.ParamByName('RESULT').AsString   := IntToStr( vResultUseBA.ReturnCode.FCode ) + ' ' + vResultUseBA.ReturnCode.FMsg ;
        vQuery.ExecSQL ;

        vTrans.Commit ;
      except
        vTrans.Rollback ;

        vResultUseBA.ReturnCode.FCode := 501 ;
        vResultUseBa.ReturnCode.FMsg  := 'Erreur interne' ;
      end;
    finally
      vBonAchat.DisposeOf ;
    end;
  finally
    vQuery.Free ;
    vTrans.Free ;
    if Assigned(vSitePresta)
      then vSitePresta.DisposeOf ;
    Result := TJSON.ObjectToJsonObject(vResultUseBA) ;
  end;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.cancelBonAchatFid(aSecureStr : String ; ABAId, ATransId: Int64): TJSONObject;
var
  vTrans     : TFDTransaction ;
  vQuery     : TFDQuery ;
  vSitePresta: TSitePresta ;
  vBonAchat  : TBonAchat ;
  vResultUseBA  : TResultUseBA ;
  vNewId     : Int64 ;
  vReturnCode : TReturnCode ;
begin
  vResultUseBA := TResultUseBA.Create ;
  vResultUseBA.FReturnCode.FCode := 500 ;
  vResultUseBA.FReturnCode.FMsg  := 'Erreur interne' ;
  vResultUseBA.FTransId          := 0 ;

  vTrans := DM_Main.getNewTransaction(FConnection) ;
  vQuery := DM_Main.getNewQuery(FConnection, vTrans) ;
  try
    vSitePresta := nil ;
    try
      vSitePresta := parseSecureKey(aSecureStr) ;
    except
      on E:Exception do
      begin
        vReturnCode := TReturnCode.Create(403, 'Authentification invalide : ' + E.Message );
        vResultUseBA.FReturnCode.FCode := vReturnCode.FCode ;
        vResultUseBA.FReturnCode.FMsg  := vReturnCode.FMsg ;
        vReturnCode.Free ;
        Exit ;
      end;
    end;

    if aBAId < 1 then
    begin
        vResultUseBA.ReturnCode.FCode := 404 ;
        vResultUseBA.ReturnCode.FMsg  := 'Bon d''Achat invalide' ;
        Exit ;
    end;

    vTrans.StartTransaction ;

    // Recuperation du bon d'achat
    vQuery.SQL.Text := 'SELECT BAC_ID, BAC_CLTID, BAC_MONTANT, BAC_TKEID, BAC_CBTID, BAC_USED FROM CLTBONACHAT  ' +
                       'JOIN K ON K_ID = BAC_ID AND K_ENABLED=1 ' +
                       'WHERE BAC_ID = :BACID' ;
    vQuery.ParamByName('BACID').AsLargeInt := aBAId ;
    vQuery.Open ;

    if not vQuery.IsEmpty then
    begin
      vBonAchat := TBonAchat.Create ;
      DM_Main.fillObjectWithQuery(vBonAchat, vQuery, 'BAC');
    end else begin
      vResultUseBA.ReturnCode.FCode := 401 ;
      vResultUseBA.ReturnCode.FMsg  := 'Bon d''Achat non trouvé' ;
      Exit ;
    end;
    vQuery.Close ;

    try
      vResultUseBA.ReturnCode.FCode := 200 ;
      vResultUseBa.ReturnCode.FMsg  := 'OK' ;

      if vBonAchat.FCbtId = 0 then
      begin
        vResultUseBA.ReturnCode.FCode := 303 ;
        vResultUseBa.ReturnCode.FMsg  := 'Bon d''achat non réservé' ;
        vResultUseBA.FTransId         := 0 ;
      end;

      if (vBonAchat.FTkeId <> 0) or vBonAchat.FUsed then
      begin
        vResultUseBA.ReturnCode.FCode := 301 ;
        vResultUseBa.ReturnCode.FMsg  := 'Bon d''achat déja utilisé' ;
        vResultUseBA.FTransId         := 0 ;
      end;

      if (vBonAchat.FCbtId <> aTransId) and (not vSitePresta.SuperUser) then
      begin
        vResultUseBA.ReturnCode.FCode := 304 ;
        vResultUseBa.ReturnCode.FMsg  := 'Transaction invalide' ;
        vResultUseBA.FTransId         := 0 ;
      end;


      // Creation de la transaction
      try
        vTrans.StartTransaction ;

        vNewId := DM_Main.getNewK('CLTBATRANS', FConnection, vTrans) ;
        if vResultUseBA.ReturnCode.FCode = 200 then
        begin

          vQuery.SQL.Text := 'UPDATE CLTBONACHAT SET BAC_CBTID=0 ' +
                             'WHERE BAC_ID=:BACID' ;
          vQuery.ParamByName('BACID').AsLargeInt := vBonAchat.FId ;
          vQuery.ExecSQL ;

          DM_Main.updateK(vBonAchat.FId, TGinKAction.gkaUpdate, FConnection, vTrans);
          vResultUseBA.FTransId         := vNewId ;
        end;

        vQuery.SQL.Text := 'INSERT INTO CLTBATRANS (CBT_ID, CBT_BACID, CBT_ASPID, CBT_DATE, CBT_ACTION, CBT_RESULT) ' +
                           'VALUES (:ID, :BACID, :ASPID, :DATE, :ACTION, :RESULT)' ;
        vQuery.ParamByName('ID').AsLargeInt     := vNewId ;
        vQuery.ParamByName('BACID').AsLargeInt  := vBonAchat.FId ;
        vQuery.ParamByName('ASPID').AsLargeInt  := vSitePresta.FId ;
        vQuery.ParamByName('DATE').AsDateTime   := now ;
        vQuery.ParamByName('ACTION').AsString   := 'cancelBonAchatFid' ;
        vQuery.ParamByName('RESULT').AsString   := IntToStr( vResultUseBA.ReturnCode.FCode ) + ' ' + vResultUseBA.ReturnCode.FMsg ;
        vQuery.ExecSQL ;

        vTrans.Commit ;
      except
        vTrans.Rollback ;

        vResultUseBA.ReturnCode.FCode := 501 ;
        vResultUseBa.ReturnCode.FMsg  := 'Erreur interne' ;
      end;
    finally
      vBonAchat.DisposeOf ;
    end;
  finally
    vQuery.Free ;
    vTrans.Free ;
    if Assigned(vSitePresta)
      then vSitePresta.DisposeOf ;
    Result := TJSON.ObjectToJsonObject(vResultUseBA) ;
  end;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.confirmUseBonAchatFid(aSecureStr : string ;
  ABAId: Int64): TJSONObject;
var
  vTrans     : TFDTransaction ;
  vQuery     : TFDQuery ;
  vSitePresta: TSitePresta ;
  vBonAchat  : TBonAchat ;
  vResultUseBA  : TResultUseBA ;
  vNewId     : Int64 ;
  vReturnCode : TReturnCode ;
begin
  vResultUseBA := TResultUseBA.Create ;
  vResultUseBA.FReturnCode.FCode := 500 ;
  vResultUseBA.FReturnCode.FMsg  := 'Erreur interne' ;
  vResultUseBA.FTransId          := 0 ;

  vTrans := DM_Main.getNewTransaction(FConnection) ;
  vQuery := DM_Main.getNewQuery(FConnection, vTrans) ;
  try
    vSitePresta := nil ;
    try
      vSitePresta := parseSecureKey(aSecureStr) ;
    except
      on E:Exception do
      begin
        vReturnCode := TReturnCode.Create(403, 'Authentification invalide : ' + E.Message );
        vResultUseBA.FReturnCode.FCode := vReturnCode.FCode ;
        vResultUseBA.FReturnCode.FMsg  := vReturnCode.FMsg ;
        vReturnCode.Free ;
        Exit ;
      end;
    end;

    if aBAId < 1 then
    begin
        vResultUseBA.ReturnCode.FCode := 404 ;
        vResultUseBA.ReturnCode.FMsg  := 'Bon d''Achat invalide' ;
        Exit ;
    end;

    vTrans.StartTransaction ;

    // Recuperation du bon d'achat
    vQuery.SQL.Text := 'SELECT BAC_ID, BAC_CLTID, BAC_MONTANT, BAC_TKEID, BAC_CBTID, BAC_USED FROM CLTBONACHAT  ' +
                       'JOIN K ON K_ID = BAC_ID AND K_ENABLED=1 ' +
                       'WHERE BAC_ID = :BACID' ;
    vQuery.ParamByName('BACID').AsLargeInt := aBAId ;
    vQuery.Open ;

    if not vQuery.IsEmpty then
    begin
      vBonAchat := TBonAchat.Create ;
      DM_Main.fillObjectWithQuery(vBonAchat, vQuery, 'BAC');
    end else begin
      vResultUseBA.ReturnCode.FCode := 401 ;
      vResultUseBA.ReturnCode.FMsg  := 'Bon d''Achat non trouvé' ;
      Exit ;
    end;
    vQuery.Close ;

    try
      vResultUseBA.ReturnCode.FCode := 200 ;
      vResultUseBa.ReturnCode.FMsg  := 'OK' ;

      if vBonAchat.FCbtId = 0 then
      begin
        vResultUseBA.ReturnCode.FCode := 303 ;
        vResultUseBa.ReturnCode.FMsg  := 'Bon d''achat non réservé' ;
        vResultUseBA.FTransId         := 0 ;
      end;

      if (vBonAchat.FTkeId <> 0) or vBonAchat.FUsed then
      begin
        vResultUseBA.ReturnCode.FCode := 301 ;
        vResultUseBa.ReturnCode.FMsg  := 'Bon d''achat déja utilisé' ;
        vResultUseBA.FTransId         := 0 ;
      end;

      // Creation de la transaction
      try
        vTrans.StartTransaction ;

        vNewId := DM_Main.getNewK('CLTBATRANS', FConnection, vTrans) ;
        if vResultUseBA.ReturnCode.FCode = 200 then
        begin

          vQuery.SQL.Text := 'UPDATE CLTBONACHAT SET BAC_USED=1 ' +
                             'WHERE BAC_ID=:BACID' ;
          vQuery.ParamByName('BACID').AsLargeInt := vBonAchat.FId ;
          vQuery.ExecSQL ;

          DM_Main.updateK(vBonAchat.FId, TGinKAction.gkaUpdate, FConnection, vTrans);
          vResultUseBA.FTransId         := vNewId ;
        end;

        vQuery.SQL.Text := 'INSERT INTO CLTBATRANS (CBT_ID, CBT_BACID, CBT_ASPID, CBT_DATE, CBT_ACTION, CBT_RESULT) ' +
                           'VALUES (:ID, :BACID, :ASPID, :DATE, :ACTION, :RESULT)' ;
        vQuery.ParamByName('ID').AsLargeInt     := vNewId ;
        vQuery.ParamByName('BACID').AsLargeInt  := vBonAchat.FId ;
        vQuery.ParamByName('ASPID').AsLargeInt  := vSitePresta.FId ;
        vQuery.ParamByName('DATE').AsDateTime   := now ;
        vQuery.ParamByName('ACTION').AsString   := 'confirmUseBonAchatFid' ;
        vQuery.ParamByName('RESULT').AsString   := IntToStr( vResultUseBA.ReturnCode.FCode ) + ' ' + vResultUseBA.ReturnCode.FMsg ;
        vQuery.ExecSQL ;

        vTrans.Commit ;
      except
        vTrans.Rollback ;

        vResultUseBA.ReturnCode.FCode := 501 ;
        vResultUseBa.ReturnCode.FMsg  := 'Erreur interne' ;
      end;
    finally
      vBonAchat.DisposeOf ;
    end;
  finally
    vQuery.Free ;
    vTrans.Free ;
    if Assigned(vSitePresta)
      then vSitePresta.DisposeOf ;
    Result := TJSON.ObjectToJsonObject(vResultUseBA) ;
  end;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.getDateHeureGMT: string;
begin
  Result := DateToISO8601(getDateTimeUTC, true) ;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.getDateTimeUTC: TDateTime;
var
  UTC : TSystemTime;
begin
  GetSystemTime(UTC) ;
  Result := SystemTimeToDateTime(UTC) ;
end;

//------------------------------------------------------------------------------
function TSM_Fidelite.interleaveStrings(str1, str2: string): string;
var
  ia : integer ;
begin
  Result := '' ;

  ia := 1 ;
  while ((ia <= Length(str1)) or (ia <= Length(str2))) do
  begin
    if ia <= Length(str1) then
      Result := Result + str1[ia] ;

    if ia <= Length(str2) then
      Result := Result + str2[ia] ;

    Inc(ia) ;
  end;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.parseSecureKey(aSecureStr: string): TSitePresta ;
var
  ia, ib : integer ;
  vCode  : string ;
  vDate  : string ;
  vHash  : string ;
  vHash2 : string ;
  vKey   : string ;
  vIStr  : string ;
  vId    : Int64 ;
  vNom   : string ;

  dDate  : TDateTime ;

  vTrans : TFDTransaction ;
  vQuery : TFDQuery ;
begin
  Result := nil ;

  ia  := Pos('_', aSecureStr) ;
  ib  := Pos('_', aSecureStr, ia+1) ;

  if (ia < 0) or (ib < 0)
    then raise Exception.Create('SecureStr: structure invalide') ;


  vCode := Copy(aSecureStr,1 , ia-1) ;
  vDate := Copy(aSecureStr, ia+1, ib-ia-1) ;
  vHash := Copy(aSecureStr, ib+1, Length(aSecureStr) - ib) ;

  if (Length(vCode) < 1) or (Length(vDate) <> 24) or (Length(vHash) <> 32)
    then raise Exception.Create('SecureStr: structure invalide') ;

  try
    dDate := ISO8601ToDate(vDate, true) ;
    vDate := DateToISO8601(dDate, true) ;
  except
    raise Exception.Create('SecureStr: date invalide') ;
  end;


  if abs(getDateTimeUTC - dDate) > (15 * OneMinute)  then
  begin
    raise Exception.Create('SecureStr: date perimée') ;
  end;

  vTrans := DM_Main.getNewTransaction(FConnection) ;
  vQuery := DM_Main.getNewQuery(FConnection, vTrans) ;
  try
    vQuery.SQL.Text := 'SELECT ASP_ID, ASP_NOM, ASP_CODE, ASP_KEY FROM ARTSITEPRESTA ' +
                       'JOIN K ON K_ID = ASP_ID AND K_ENABLED=1 ' +
                       'WHERE ASP_CODE = :CODE' ;
    vQuery.ParamByName('CODE').AsString := vCode ;
    vQuery.Open ;

    if not vQuery.IsEmpty then
    begin
      vId   := vQuery.FieldByName('ASP_ID').AsLargeInt ;
      vNom  := vQuery.FieldByName('ASP_NOM').AsString ;
      vCode := vQuery.FieldByName('ASP_CODE').AsString ;
      vKey  := vQuery.FieldByName('ASP_KEY').AsString ;
    end else begin
      raise Exception.Create('SecureStr: Code prestataire invalide') ;
    end;

  finally
    vQuery.DisposeOf ;
    vTrans.DisposeOf ;
  end;

  vIStr  := interleaveStrings(vDate, vKey) ;
  vHash2 := DM_Main.MD5(vIStr) ;

  if uppercase(vHash2) = uppercase(vHash) then
  begin
    Result := TSitePresta.Create ;
    Result.Id     := vId ;
    Result.Nom    := vNom ;
    Result.Code   := vCode ;
    Result.FKey   := vKey ;
    Result.SuperUser := (vCode = 'GINKOIA') ;
  end else begin
    raise Exception.Create('SecureStr: Hash invalide') ;
  end;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.Test: TJSONObject;
var
  vReturnCode : TReturnCode ;
begin
  Result := nil ;

  vReturnCode := TReturnCode.Create(200,'OK') ;

  try
    Result := TJson.ObjectToJsonObject(vReturnCode) ;
  finally
    vReturnCode.DisposeOf ;
  end;
end;
//------------------------------------------------------------------------------
function TSM_Fidelite.TestLogin(aSecureStr: string): TJSONObject;
var
  vSitePresta : TSitePresta ;
  vReturnCode : TReturnCode ;
begin
  vSitePresta := nil ;
  vReturnCode := TReturnCode.Create(200, 'OK') ;

  try
    try
      vSitePresta := parseSecureKey(aSecureStr) ;
      vReturnCode.FCode := 200 ;
      vReturnCode.FMsg  := 'OK. Hello ' + vSitePresta.FNom ;
    except
      on E:Exception do
      begin
        vReturnCode.FCode := 403 ;
        vReturnCode.FMsg  := 'Authentification invalide : ' + E.Message ;
      end;
    end;
  finally
    if Assigned(vSitePresta) then
      vSitePresta.DisposeOf ;
  end;

  Result := TJson.ObjectToJsonObject(vReturnCode) ;
end;
//==============================================================================

//==============================================================================
{ TResultFid }
//==============================================================================
procedure TResultFid.clearBonAchats;
var
  ia : integer ;
begin
  for ia:= 0 to Length(BonAchats) - 1 do
  begin
    BonAchats[ia].Free ;
  end;
  setLength(FBonsAchats,0) ;
end;

constructor TResultFid.Create;
begin
  inherited ;
  FReturnCode := TReturnCode.Create(200, 'OK') ;
  setLength(FBonsAchats,0) ;
end;
//------------------------------------------------------------------------------
destructor TResultFid.Destroy;
begin
  setLength(FBonsAchats,0) ;
  ReturnCode.DisposeOf ;

  inherited;
end;
//==============================================================================

{ TResultUseBA }

constructor TResultUseBA.Create;
begin
  inherited ;

  FReturnCode := TReturnCode.Create(200, 'OK') ;
end;

destructor TResultUseBA.Destroy;
begin
  FReturnCode.DisposeOf ;

  inherited;
end;

{ TReturnCode }

constructor TReturnCode.Create(aCode: integer; aMsg: string);
begin
  inherited Create ;

  FCode := aCode ;
  FMsg  := aMsg ;
end;

end.

