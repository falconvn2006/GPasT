unit uWebVenteFid;

interface

uses Classes, Windows, SysUtils, Contnrs, uJSON, idHTTP, idURI, IdHashMessageDigest ;

type
//==============================================================================
  TWebVenteFid_Params = record
    Enabled : boolean ;
    Url     : string ;
    Code    : string ;
    Key     : string ;
  end ;
//------------------------------------------------------------------------------
  TWebVenteFidAction = (wfaNone, wfaUse, wfaCancel, wfaConfirm) ;
//------------------------------------------------------------------------------
  TStringArray = Array of String ;
//------------------------------------------------------------------------------
  TJSONResult = class(TPersistent)
  private
    fResult : TStringArray ;
    fError  : TStringArray ;
    function getIsError: boolean;
  public
    constructor Create ;
    property isError : boolean  read getIsError ;
  published
    property result : TStringArray    read FResult    write FResult ;
    property error  : TStringArray    read FError     write FError ;
  end;
//------------------------------------------------------------------------------
  TJSONReturnCode = class(TPersistent)
  private
    fCode : Integer ;
    fMsg  : String ;
  published
    property code : INteger    read FCode    write FCode ;
    property msg  : String     read FMsg     write FMsg ;
  end;
//------------------------------------------------------------------------------
  TJSONReturnTransaction = class(TPersistent)
  private
    FReturnCode : TJSONReturnCode ;
    FTransId    : Int64 ;
  public
    destructor Destroy ; override ;
  published
    property returnCode : TJSONReturnCode read FReturnCode    write FReturnCode ;
    property transId    : Int64           read FTransId       write FTransId ;
  end;
//------------------------------------------------------------------------------
  TBonAchat = class(TPersistent)
  private
    FId       : Int64;
    FMontant  : Currency;
    FCltId    : Int64;
    FTkeId    : Int64;
    FCbtId    : Int64;
    FUsed     : boolean ;
    FDateVal  : TDateTime ;
  published
    property id : Int64           read FId        write FId ;
    property cltId : Int64        read FCltId     write FCltId ;
    property montant : Currency   read FMontant   write FMontant ;
    property tkeId : Int64        read FTkeId     write FTkeId ;
    property cbtId : Int64        read FCbtId     write FCbtId ;
    property used : boolean       read FUsed      write FUsed ;
    property dateVal : TDateTime  read FDateVal  write FDateVal ;
  end;
//------------------------------------------------------------------------------
  TBonAchats = Array of TBonAchat ;
//------------------------------------------------------------------------------
  TJSONReturnFidClient = class(TPersistent)
  private
    FReturnCode : TJSONReturnCode ;
    FBonsAchats : TBonAchats ;
    FTypeFid    : integer ;
    FNbPts      : integer ;
    FNbPass     : integer ;
  public
    destructor Destroy ; override ;

    function getBonAchatById(aBacId : Int64) : TBonAchat ;
  published
    property returnCode : TJSONReturnCode   read FReturnCode  write FReturnCode ;
    property bonsAchats  : TBonAchats        read FBonsAchats   write FBonsAchats ;
    property typeFid    : integer           read FTypeFid     write FTypeFid ;
    property nbPts      : integer           read FNbPts       write FNbPts ;
    property nbPass     : integer           read FNbPass      write FNbPass ;
  end;
//------------------------------------------------------------------------------
  TWebVenteFidItem = class ;
  TWebVenteFidResultEvent = procedure(aSender : TObject ; aWebVenteFidItem : TWebVenteFidItem) of object ;
//------------------------------------------------------------------------------
  TWebVenteFidItem = class
  private
    FOnResult  : TWebVenteFidResultEvent ;
  public
    Action : TWebVenteFidAction ;
    BacId  : Int64 ;
    CbtId  : Int64 ;
    retry  : Integer ;
    returnCode : Integer ;
    returnStr  : String ;

    constructor Create ;
  published
    property OnResult : TWebVenteFidResultEvent   read FOnResult  write FOnResult ;
  end;
//------------------------------------------------------------------------------
  TWebVenteFid = class(TThread)
  private
    FItems : TObjectList ;
    HTTPClient : TidHTTP ;
    lckQuery   : TRTLCriticalSection ;

    FUrl      : string ;
    FCode     : string ;
    fKey      : string ;

    FRetry    : Integer ;
    FModified : boolean ;

    FTimeOffset : Double ;
    currItem    : TWebVenteFidItem ;

    function getSecureStr : string ;
    procedure updateTimeOffset ;

    function interleaveStrings(str1, str2 : string) : string ;
    function MD5(aString : string ) : string ;

    procedure sendItem(aItem : TWebVenteFidItem) ;
    function doRESTGet(aUrl, aFunction : string ; aParams : TStringList) : string ;
    function doGetDateTimeUTC : TDateTime ;
    function doSendTestLogin : TJSONReturnCode ;
    procedure doSendUse(aItem : TWebVenteFidItem) ;
    procedure doSendCancel(aItem : TWebVenteFidItem) ;
    procedure doSendConfirm(aItem : TWebVenteFidItem) ;

    procedure doOnResult ;
    function getServerTime: TDateTime;
  public
    constructor Create ;
    destructor Destroy ; override ;
    procedure Execute ; override ;

    procedure Open ;
    procedure Abort ;

    function TestLogin : boolean ;
    function getFidClientByIdAndMagId(aCltId : Int64 ; aMagId : Int64) : TJSONReturnFidClient ;
    function getFidClientById(aCltId : Int64 ; aSiteCode : Integer) : TJSONReturnFidClient ;
    function getFidClientByChrono(aCltChrono : string ; aSiteCode : Integer) : TJSONReturnFidClient ;
    procedure Use(aBacId : Int64 ; aOnResult : TWebVenteFidResultEvent = nil) ;
    procedure Cancel(aBacId, aTransId : Int64 ; aOnResult : TWebVenteFidResultEvent = nil) ;
    procedure Confirm(aBacId : Int64 ; aOnResult : TWebVenteFidResultEvent = nil) ;
  published
    property Url  : string        read FUrl         write FUrl ;
    property Code : string        read FCode        write FCode ;
    property Key  : string        read FKey         write FKey ;
    property Retry : Integer      read FRetry       write FRetry ;
    property serverTime : TDateTime  read getServerTime ;
  end;
//==============================================================================

implementation
//==============================================================================

//==============================================================================
{ TWebVenteFid }
//==============================================================================
constructor TWebVenteFid.Create;
begin
  inherited Create(True) ;

  HTTPClient := TIdHTTP.Create ;
  InitializeCriticalSection(lckQuery) ;

  FItems := TObjectList.Create ;

  FRetry := 5 ;
end;
//------------------------------------------------------------------------------
destructor TWebVenteFid.Destroy;
begin
  Terminate ; Resume ; WaitFor ;

  FItems.Free ;

  DeleteCriticalSection(lckQuery) ;
  inherited;
end;
//------------------------------------------------------------------------------
function TWebVenteFid.doRESTGet(aUrl, aFunction : string; aParams: TStringList): string;
var
  vParams : string ;
  vQuery  : string ;
  ia      : integer ;
  vStream : TStringStream ;
begin
  EnterCriticalSection(lckQuery) ;
  try
    vStream := TStringStream.Create('') ;
    try
      Result := '' ;
      vParams := '' ;

      if aFunction = '' then Exit ;

      if Assigned(aParams) then
      begin
        for ia:= 0 to aParams.Count - 1 do
        begin
          vParams := vParams + '/' + TidURI.ParamsEncode(aParams[ia]) ;
        end;
      end;

      vQuery := aUrl + '/datasnap/rest/TSM_Fidelite/' + aFunction + vParams ;

      HTTPClient := TIdHTTP.Create(nil);

      try
        HTTPClient.Get(vQuery, vStream);
      except
        on E:Exception do
          raise exception.Create('REST Error : ' + E.Message) ;
      end;

      if HTTPClient.ResponseCode = 200 then
      begin
        Result := vStream.DataString ;
      end else begin
        raise exception.Create('REST Error : ' + HTTPClient.ResponseText) ;
      end;
    finally
      HTTPClient.Response.Clear ;
      HTTPClient.Free ;
      vStream.Free ;
    end ;
  finally
    LeaveCriticalSection(lckQuery) ;
  end;
end;
//------------------------------------------------------------------------------
function TWebVenteFid.doGetDateTimeUTC: TDateTime;
var
  sJson : string ;
  vResult : TJSONResult ;
  vDate   : TDateTime ;
  vDateStr : String ;
begin
  try
    vDate := 0 ;
    sJson := doRESTGet(FUrl, 'getDateHeureGMT', nil) ;
    vResult := TJSONResult.Create ;
    TJSON.JSONToObject(sJson, vResult) ;

    if (not vResult.isError) and (Length(vResult.result) > 0) then
    begin
      vDateStr := vResult.result[0] ;
      vDate := TJSON.ISO8601ToDateTime(vDateStr) ;
    end;

    vResult.Free ;

    Result := vDate ;
  except
    Result := 0 ;
  end;
end;
procedure TWebVenteFid.doOnResult;
begin

  if Assigned(currItem) and Assigned(currItem.FOnResult) then
  begin
    try
      currItem.FOnResult(Self, currItem) ;
    except
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TWebVenteFid.doSendCancel(aItem: TWebVenteFidItem);
var
  vParams : TStringList ;
  vJson   : string ;
  vResult : TJSONResult ;
  vReturnTrans : TJSONReturnTransaction ;
begin
  vParams := TStringList.Create ;
  try
    vParams.Add(getSecureStr) ;
    vParams.Add(IntToStr(aItem.BacId)) ;
    vParams.Add(IntToStr(aItem.CbtId)) ;

    try
      vJson := doRESTGet(FUrl, 'cancelBonAchatFid', vParams) ;
    except
      on E:Exception do
      begin
        aItem.returnCode := 500 ;
        aItem.returnStr  := E.Message ;
        Inc(aItem.retry) ;
      end;
    end;

    vResult := TJSONResult.Create ;
    TJSON.JSONToObject(vJson, vResult) ;

    if not vResult.isError then
    begin
      vReturnTrans := TJSONReturnTransaction.Create ;
      TJSON.JSONToObject(vResult.result[0], vReturnTrans) ;

      aItem.returnCode :=  vReturnTrans.returnCode.code ;
      aItem.returnStr  :=  vReturnTrans.returnCode.msg ;

      aItem.CbtId      :=  vReturnTrans.FTransId ;

    end else begin
      aItem.returnCode := 500 ;
      aItem.returnStr  := vResult.error[0] ;
      Inc(aItem.retry) ;
    end ;

  finally
    vParams.Free ;
  end;
end;
//------------------------------------------------------------------------------
procedure TWebVenteFid.doSendConfirm(aItem: TWebVenteFidItem);
var
  vParams : TStringList ;
  vJson   : string ;
  vResult : TJSONResult ;
  vReturnTrans : TJSONReturnTransaction ;
begin
  vParams := TStringList.Create ;
  try
    vParams.Add(getSecureStr) ;
    vParams.Add(IntToStr(aItem.BacId)) ;

    try
      vJson := doRESTGet(FUrl, 'confirmUseBonAchatFid', vParams) ;
    except
      on E:Exception do
      begin
        aItem.returnCode := 500 ;
        aItem.returnStr  := E.Message ;
        Inc(aItem.retry) ;
      end;
    end;

    vResult := TJSONResult.Create ;
    TJSON.JSONToObject(vJson, vResult) ;

    if not vResult.isError then
    begin
      vReturnTrans := TJSONReturnTransaction.Create ;
      TJSON.JSONToObject(vResult.result[0], vReturnTrans) ;

      aItem.returnCode :=  vReturnTrans.returnCode.code ;
      aItem.returnStr  :=  vReturnTrans.returnCode.msg ;

      aItem.CbtId      :=  vReturnTrans.FTransId ;

    end else begin
      aItem.returnCode := 500 ;
      aItem.returnStr  := vResult.error[0] ;
      Inc(aItem.retry) ;
    end ;

  finally
    vParams.Free ;
  end;
end;
//------------------------------------------------------------------------------
function TWebVenteFid.doSendTestLogin: TJSONReturnCode;
var
  sJson : string ;
  vResult : TJSONResult ;
  vReturnCode : TJSONReturnCode ;
  vParams : TStringList ;
begin
  vParams := TStringList.Create ;
  try
    vParams.Add(getSecureStr) ;

    sJson := doRESTGet(FUrl, 'TestLogin', vParams) ;
    vResult := TJSONResult.Create ; 
    TJSON.JSONToObject(sJson, vResult) ;

    if (not vResult.isError) and (length(vResult.result) > 0) then
    begin
      sJson := vResult.result[0] ;
    end;
    vResult.Free ;

    vReturnCode := TJSONReturnCode.Create ;
    TJSON.JSONToObject(sJson, vReturnCode) ;

    Result := vReturnCode ;
  finally
    vParams.Free ;
  end;

end;
//------------------------------------------------------------------------------
procedure TWebVenteFid.doSendUse(aItem: TWebVenteFidItem);
var
  vParams : TStringList ;
  vJson   : string ;
  vResult : TJSONResult ;
  vReturnTrans : TJSONReturnTransaction ;
begin
  vParams := TStringList.Create ;
  try
    vParams.Add(getSecureStr) ;
    vParams.Add(IntToStr(aItem.BacId)) ;

    try
      vJson := doRESTGet(FUrl, 'useBonAchatFid', vParams) ;
    except
      on E:Exception do
      begin
        aItem.returnCode := 500 ;
        aItem.returnStr  := E.Message ;
        Inc(aItem.retry) ;
      end;
    end;

    vResult := TJSONResult.Create ;
    TJSON.JSONToObject(vJson, vResult) ;

    if not vResult.isError then
    begin
      vReturnTrans := TJSONReturnTransaction.Create ;
      TJSON.JSONToObject(vResult.result[0], vReturnTrans) ;

      aItem.returnCode :=  vReturnTrans.returnCode.code ;
      aItem.returnStr  :=  vReturnTrans.returnCode.msg ;

      aItem.CbtId      :=  vReturnTrans.FTransId ; 

    end else begin
      aItem.returnCode := 500 ;
      aItem.returnStr  := vResult.error[0] ;
      Inc(aItem.retry) ;
    end ;

  finally
    vParams.Free ;
  end;
end;
//------------------------------------------------------------------------------
procedure TWebVenteFid.Execute;
var
  vItem : TWebVenteFidItem ;
  ia    : integer ;
begin
  inherited;

  while not Terminated do
  begin
    if FModified then
    begin
      FModified := false ;

      ia := 0 ;
      while ia < FItems.Count do
      begin
        vItem := FItems[ia] as TWebVenteFidItem ;

        if ((vItem.returnCode <= 0) or (vItem.returnCode >= 500)) and (vItem.retry < 5) then
        begin
          fModified := true ;
          sendItem(vItem) ;

          if (vItem.returnCode < 500) or (vItem.retry >= 5) then
          begin
            currItem := vItem ;

            if Assigned(vItem.FOnResult)
              then Synchronize(doOnResult) ;
          end;
        end;

        Inc(ia) ;
      end;

      for ia := 1 to 10 do
        if fModified then sleep(10) ;

    end else begin
      if FreeOnTerminate then Terminate ;
      sleep(100) ;
    end;
  end ;
end;
//------------------------------------------------------------------------------
function TWebVenteFid.getFidClientByChrono(
  aCltChrono: string ;  aSiteCode : integer): TJSONReturnFidClient;
begin

end;
//------------------------------------------------------------------------------
function TWebVenteFid.getFidClientById(aCltId: Int64 ; aSiteCode : integer): TJSONReturnFidClient;
var
  vParams : TStringList ;
  vJson   : string ;
  vResult : TJSONResult ;
begin
  vParams := TStringList.Create ;
  try
    vParams.Add(getSecureStr) ;
    vParams.Add(IntToStr(aSiteCode)) ;
    vParams.Add(IntToStr(aCltId)) ;

    try
      vJson := doRESTGet(FUrl, 'getFidClientById', vParams) ;
    except
      on E:Exception do
      begin
        Result.FReturnCode.fCode := 500 ;
        Result.FReturnCode.fMsg  := E.Message ;
      end;
    end;

    vResult := TJSONResult.Create ;
    TJSON.JSONToObject(vJson, vResult) ;

    if not vResult.isError then
    begin
      Result := TJSONReturnFidClient.Create ;
      TJSON.JSONToObject(vResult.result[0], Result) ;
    end else begin
      Result.FReturnCode.fCode := 500 ;
      Result.FReturnCode.fMsg  := vResult.error[0] ;
    end ;

  finally
    vParams.Free ;
  end;
end;
//------------------------------------------------------------------------------
function TWebVenteFid.getFidClientByIdAndMagId(aCltId: Int64 ; aMagId : Int64): TJSONReturnFidClient;
var
  vParams : TStringList ;
  vJson   : string ;
  vResult : TJSONResult ;
begin
  vParams := TStringList.Create ;
  try
    vParams.Add(getSecureStr) ;
    vParams.Add(IntToStr(aMagId)) ;
    vParams.Add(IntToStr(aCltId)) ;

    try
      vJson := doRESTGet(FUrl, 'getFidClientByIdAndMagId', vParams) ;
    except
      on E:Exception do
      begin
        Result.FReturnCode.fCode := 500 ;
        Result.FReturnCode.fMsg  := E.Message ;
      end;
    end;

    vResult := TJSONResult.Create ;
    TJSON.JSONToObject(vJson, vResult) ;

    if not vResult.isError then
    begin
      Result := TJSONReturnFidClient.Create ;
      TJSON.JSONToObject(vResult.result[0], Result) ;
    end else begin
      Result.FReturnCode.fCode := 500 ;
      Result.FReturnCode.fMsg  := vResult.error[0] ;
    end ;

  finally
    vParams.Free ;
  end;
end;
//------------------------------------------------------------------------------
function TWebVenteFid.getSecureStr: string;
var
  vHash : string ;
  vSeed : string ;
  vDate    : TDateTime ;
  vDateStr : string ;
begin
  Result := '' ;

  try
    vDate := now + FTimeOffset ;
    vDateStr := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', vDate) ;
    vSeed := interleaveStrings(vDateStr, FKey) ;
    vHash := MD5(vSeed) ;

    Result := FCode + '_' + vDateStr + '_' + vHash ; 
  except
  end;
end;

function TWebVenteFid.getServerTime: TDateTime;
begin
  Result := now + FTimeOffset ; 
end;

function TWebVenteFid.interleaveStrings(str1, str2: string): string;
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

function TWebVenteFid.MD5(aString: string): string;
var
  IdMD5 : TIdHashMessageDigest5;
begin
  IdMD5 := TIdHashMessageDigest5.Create ;
  Result := IdMD5.HashStringAsHex(aString) ;
end;

procedure TWebVenteFid.Open;
begin
  if fUrl = ''  then raise Exception.Create('URL invalide');
  if fCode = '' then raise Exception.Create('Code invalide');
  if fKey = ''  then raise Exception.Create('Key invalide');

  updateTimeOffset ;

  resume ;
end;

//------------------------------------------------------------------------------
procedure TWebVenteFid.sendItem(aItem: TWebVenteFidItem);
begin
  try
    if (aItem.returnCode = 0) or (aItem.returnCode >= 500) then
    begin
      case aItem.Action of
        wfaNone: ;
        wfaUse:     doSendUse(aItem) ;
        wfaCancel:  doSendCancel(aItem) ;
        wfaConfirm: doSendConfirm(aItem);
      end;
    end;
  except
  end;
end;
//------------------------------------------------------------------------------
function TWebVenteFid.TestLogin : boolean ;
var
  vReturn : TJSONReturnCode ;
begin
  vReturn := doSendTestLogin ;

  Result := vReturn.Code = 200 ;  
end;

//------------------------------------------------------------------------------
procedure TWebVenteFid.updateTimeOffset;
var
  vRemoteDateTime : TDateTime ;
begin
  vRemoteDateTime := doGetDateTimeUTC ;
  FTimeOffset := vRemoteDateTime - now ;
end;
//------------------------------------------------------------------------------
procedure TWebVenteFid.Abort;
begin
  EnterCriticalSection(lckQuery) ;
  try
    FItems.Clear ;
  finally
    LeaveCriticalSection(lckQuery) ;
  end;

  Resume ;
end;
//------------------------------------------------------------------------------
procedure TWebVenteFid.Cancel(aBacId, aTransId: Int64 ; aOnResult : TWebVenteFidResultEvent);
var
  aItem : TWebVenteFidItem ;
begin
  aItem := TWebVenteFidItem.Create ;
  aItem.BacId  := aBacId ;
  aItem.CbtId  := aTransId ;
  aItem.Action := wfaCancel ;
  aItem.OnResult := aOnResult ; 

  FItems.Add(aItem) ;
  FModified := true ;
end;
//------------------------------------------------------------------------------
procedure TWebVenteFid.Confirm(aBacId: Int64 ; aOnResult : TWebVenteFidResultEvent);
var
  aItem : TWebVenteFidItem ;
begin
  aItem := TWebVenteFidItem.Create ;
  aItem.BacId  := aBacId ;
  aItem.CbtId  := 0 ;
  aItem.Action := wfaConfirm ;
  aItem.OnResult := aOnResult ;

  FItems.Add(aItem) ;
  FModified := true ;
end;
//------------------------------------------------------------------------------
procedure TWebVenteFid.Use(aBacId: Int64 ; aOnResult : TWebVenteFidResultEvent) ;
var
  aItem : TWebVenteFidItem ;
begin
  aItem := TWebVenteFidItem.Create ;
  aItem.BacId  := aBacId ;
  aItem.CbtId  := 0 ;
  aItem.Action := wfaUse ;
  aItem.OnResult := aOnResult ; 

  FItems.Add(aItem) ;
  FModified := true ;
end;
//==============================================================================

//==============================================================================
{ TWebVenteFidItems }
//==============================================================================
constructor TWebVenteFidItem.Create;
begin
  BacId  := 0 ;
  CbtId  := 0 ;
  Action := wfaNone ;
  retry  := 0 ;
  returnCode := 0 ;
  returnStr  := '' ;
end;
//==============================================================================
{ TJSONResult }
//==============================================================================
constructor TJSONResult.Create;
begin
end;

function TJSONResult.getIsError: boolean;
begin
  Result := Length(fError) > 0 ;
end;
//==============================================================================
{ TJSONReturnTransaction }

destructor TJSONReturnTransaction.Destroy;
begin
  if Assigned(FReturnCode) then
    FReturnCode.Free ;

  inherited;
end;

{ TJSONReturnFidClient }

destructor TJSONReturnFidClient.Destroy;
var
  ia : integer ;
begin
  if Assigned(FReturnCode) then
    FReturnCode.Free ;

  for ia := 0 to Length(FBonsAchats) - 1 do
    FBonsAchats[ia].Free ;

  setLength(FBonsAchats,0) ;

  inherited;
end;

function TJSONReturnFidClient.getBonAchatById(aBacId : Int64): TBonAchat;
var
  vBonAchat : TBonAchat ;
  ia        : integer ;
begin
  Result := nil ;

  for ia := 0 to length(FBonsAchats) - 1 do
  begin
    vBonAchat := FBonsAchats[ia] ;
    if vBonAchat.FId = aBacId then
    begin
      Result := vBonAchat ;
      Exit ;
    end ;
  end;
end;

end.
