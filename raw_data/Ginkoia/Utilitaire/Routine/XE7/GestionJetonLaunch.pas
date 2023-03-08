unit GestionJetonLaunch;

interface

uses
  System.Classes,
  Soap.InvokeRegistry,
  Soap.SOAPHTTPClient,
  uLogFile;

const
  TOKEN_OK            = 1 ;
  TOKEN_OQP           = 0 ;
  TOKEN_ERR_CNX       = -1 ;
  TOKEN_ERR_PRM       = -2 ;
  TOKEN_ERR_HTTP      = -3 ;
  TOKEN_ERR_INTERNAL  = -4 ;
  TOKEN_ABORTED       = -5 ;
  TOKEN_NEVER         = -6 ;

type
  IJetonLaunch = interface(IInvokable)
    ['{8D27A12B-07E4-295A-9244-E65584F5574F}']
    function GetToken(const ANomClient: string; const ASender: string): string; stdcall;
    procedure FreeToken(const ANomClient: string; const ASender: string); stdcall;
    function GetVersionBDD(const ANomClient: string): string; stdcall;
  end;

type
  TTokenParams = record
    bLectureOK: boolean; // Indique si la lecture a été correctement effectuée
    sMessage: string;    // En cas d'erreur, contient le message d'erreur
    sURLDelos: string;   // URL vers le DelosQPMAgent
    sAdresseWS: string;  // Adresse du webservice (ex : /JetonLaunch.dll/soap/IJetonLaunch)
    sDatabaseWS: string; // DB pour le webservice
    sSenderWS: string;   // gSender pour le WebService
  END;

type
  TTokenManager = class(TThread)
  private
    fHTTPRio : THttpRio ;
    fUrl    : string ;
    fBase   : string ;
    fSender : string ;
    fRetry    : integer ;
    fTimeout  : integer ;
    fKeepInterval : integer ;
    fAcquired : boolean ;
    fAbort    : boolean ;
    fReason   : integer ;
  protected
    procedure Execute ; override ;
    function doGetToken : integer ;
    function doFreeToken : integer ;
    function getInterface(aUrl : string) : IJetonLaunch ;
    procedure Log(aMessage : string ; aLevel : TLogLevel) ;
  public
    constructor Create ; reintroduce ;
    destructor Destroy ; override ;
    function tryGetToken(aUrl, aBase, aSender : string ; aRetry, aDelai : integer) : boolean ;
    procedure abortGetToken ; overload ;
    procedure abortGetToken(Sender : TObject) ; overload ;
    function getToken(aUrl, aBase, aSender : string) : boolean ;
    function releaseToken : boolean ;
    function GetReasonString : string;
  published
    property Url : string     read fUrl     write furl ;
    property Base : string    read fBase    write fBase ;
    property Sender : string  read fSender  write fSender ;
    property Retry : integer   read fRetry   write fRetry ;
    property Timeout : integer read fTimeout write fTimeout ;
    property KeepInterval : integer read fkeepInterval write fKeepInterval ;
    property Acquired : boolean   read fAcquired ;
    property Reason   : integer   read fReason ;
  end;

function GetParamsToken(Serveur, DataBase, UserName, Password : string; BaseId: integer = 0): TTokenParams;

implementation

uses
  Vcl.Forms,
  Winapi.ActiveX,
  Winapi.Windows,
  System.SysUtils,
  FireDAC.Comp.Client,
  uGestionBDD;

var
  TokenLog : TLogFile ;

function GetPrm(Query: TFDQuery; PrmType, PrmCode, BasID: integer): string;
begin
  try
    Query.SQL.Clear();
    Query.SQL.Add('SELECT PRM_STRING FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
    Query.SQL.Add('WHERE PRM_TYPE = :TYPE AND PRM_POS = :BASID AND PRM_CODE = :CODE');
    Query.ParamByName('TYPE').AsInteger  := PrmType;
    Query.ParamByName('CODE').AsInteger  := PrmCode;
    Query.ParamByName('BASID').AsInteger := BasID;
    try
      Query.Open();
      Result := Query.Fields[0].AsString;
    finally
      Query.Close();
    end;
  except
    on E: Exception do
      Result := '';
  end;
end;

function GetParamsToken(Serveur, DataBase, UserName, Password : string; BaseId: integer = 0): TTokenParams;
var
  Connexion : TFDConnection;
  Query : TFDQuery;
  AIdBase : integer;
begin
  Result.bLectureOK := False;
  Result.sMessage := 'Erreur à la création des composants DB';

  try
    Connexion := GetNewConnexion(Serveur, DataBase, UserName, Password);
    Query := GetNewQuery(Connexion);

    if Connexion.Connected then
    begin
      if BaseId = 0 then
      begin
        try
          Query.SQL.Clear();
          Query.SQL.Add('SELECT BAS_ID, BAS_NOM');
          Query.SQL.Add('  FROM GENBASES');
          Query.SQL.Add('       JOIN K ON (K_ID=BAS_ID AND K_ENABLED=1)');
          Query.SQL.Add('       JOIN GENPARAMBASE ON (BAS_IDENT = PAR_STRING)');
          Query.SQL.Add(' WHERE PAR_NOM = ' + QuotedStr('IDGENERATEUR'));
          try
            Query.Open();
            AIdBase := Query.Fields[0].AsInteger;
          finally
            Query.Close();
          end;
        except
          Result.sMessage := 'Erreur à la récupération du base ID : Exception sur la requête';
        end;
      end
      else
      begin
        AIdBase := BaseId;
      end;

      if AIdBase <> 0 then
      begin
        try
          Query.SQL.Clear();
          Query.SQL.Add('SELECT REP_URLDISTANT');
          Query.SQL.Add('  FROM GENREPLICATION');
          Query.SQL.Add('  JOIN K ON (K_ID = REP_ID AND K_ENABLED = 1)');
          Query.SQL.Add('  JOIN GENLAUNCH ON (LAU_ID = REP_LAUID)');
          Query.SQL.Add(' WHERE REP_ORDRE > 0');
          Query.SQL.Add('   AND REP_URLDISTANT <> '''' ');
          Query.SQL.Add('   AND LAU_BASID = ' + IntToStr(AIdBase));
          Query.SQL.Add(' ORDER BY REP_ORDRE');
          try
            Query.Open();
            Result.sURLDelos := Query.Fields[0].AsString;
          finally
            Query.Close();
          end;
        except
          Result.sMessage := 'Erreur à la récupération du base ID : Exception sur la requête';
        end;

        Result.sAdresseWS  := GetPrm(Query, 11, 34, AIdBase); // Adresse du webservice     code = 34
        Result.sSenderWS   := GetPrm(Query, 11, 35, AIdBase); // Sender pour le WebService code = 35
        Result.sDatabaseWS := GetPrm(Query, 11, 36, AIdBase); // DB pour le webservice     code = 36

        if (Result.sAdresseWS <> '') AND (Result.sSenderWS <> '') AND (Result.sDatabaseWS <> '') then
        begin
          Result.sMessage   := '';
          Result.bLectureOK := True;
        end
        else
        begin
          Result.sMessage := 'Erreur de paramétrage ou paramétrage incomplet';
        end;
      end
      else
      begin
        Result.sMessage := 'Erreur à la récupération du base ID : ' + IntToStr(BaseId);
      end;
    end
    else
    begin
      Result.sMessage := 'Connexion à la base impossible';
    end;

  finally
    FreeAndNil(Query);
    FreeAndNil(Connexion);
  end;
end;

//==============================================================================
//==============================================================================
//==============================================================================
constructor TTokenManager.Create ;
begin
    inherited Create(true) ;
    fAcquired     := false ;
    fKeepInterval := 30000 ;
    fRetry        := 5 ;
    fTimeout      := 5000 ;
    fReason       := -6 ;
end;
//------------------------------------------------------------------------------
destructor TTokenManager.Destroy ;
begin
    fAbort := true ;
    Terminate ; Resume ; WaitFor ;
    inherited ;
end;
//------------------------------------------------------------------------------
procedure TTokenManager.Execute;
var
  iInterval : Cardinal ;
  vRetry    : integer ;
begin
    inherited ;
    CoInitializeEx(nil, COINIT_MULTITHREADED) ;
    while not Terminated do
    begin
        iInterval := getTickCount ;
        while (getTickCount < (iInterval + fKeepInterval)) do
        begin
            if Terminated then break ;
            sleep(100) ;
        end;
        if not Terminated then doGetToken ;
    end;
    if fAcquired then
    begin
        vRetry := 0 ;
        while (vRetry < fRetry) do
        begin
            Inc(vRetry) ;
            Log('Trying to connect ('+IntToStr(vRetry)+'/'+IntToStr(fRetry)+') ...', logInfo) ;
            if (doFreeToken = TOKEN_OK) then break ;
        end;
    end ;
    CoUninitialize ;
end;
//------------------------------------------------------------------------------
function TTokenManager.tryGetToken(aUrl: string; aBase: string; aSender: string; aRetry: Integer; aDelai: Integer) : boolean ;
var
    vRetry : integer ;
    vTime  : cardinal ;
begin
    fAbort := false ;
    Result := false ;
    vRetry := 0 ;
    while ((vRetry < aRetry) and (not fAbort)) do
    begin
        if getToken(aUrl, aBase, aSender) then
        begin
            Result := true ;
            break ;
        end;
        vTime := getTickCount ;
        Log('Token not acquired. Waiting '+IntToStr(aDelai)+'ms...', logWarning) ;
        while ((getTickCount < vTime + aDelai) and (not fAbort)) do
        begin
            if GetCurrentThreadId = MainThreadID then
            begin
                sleep(1) ;
                Application.ProcessMessages ;
            end else begin
                sleep(100) ;
            end;
        end;
        if fAbort then
        begin
            fReason  := TOKEN_ABORTED ;
            Log('Aborted', logNotice) ;
        end;
        Inc(vRetry) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TTokenManager.abortGetToken(Sender : TObject) ;
begin
    abortGetToken ;
end;
//------------------------------------------------------------------------------
procedure TTokenManager.abortGetToken;
begin
     Log('Aborting...', logNotice) ;
     fAbort := true ;
end;
//------------------------------------------------------------------------------
function TTokenManager.getToken(aUrl, aBase, aSender : string) : boolean ;
var
  vRetry  : integer ;
  vError  : integer ;
begin
    Result := false ;
    vRetry := 0 ; vError := TOKEN_NEVER ;
    Log('Trying to get a Token for Base ['+aBase+'] Sender ['+aSender+']', logNotice);
    if ((aUrl = '') or (aBase = '') or (aSender = '')) then
    begin
        Log('Invalid parameters. Aborting.', logError) ;
        Exit ;
    end;
    if (fAcquired) then
    begin
        Log('Token already acquired. Aborting.', logWarning) ;
        Result := true ;
        Exit ;
    end ;
    fUrl := aUrl ;
    fBase := aBase ;
    fSender := aSender ;
    while (vRetry < fRetry) do
    begin
        Inc(vRetry) ;
        Log('Trying to connect ('+IntToStr(vRetry)+'/'+IntToStr(fRetry)+') ... ', logInfo);
        vError := doGetToken ;
        if (vError >= 0) then
        begin
            fAcquired := false ;
            Result := false ;
            if (vError = TOKEN_OK) then
            begin
                fReason := TOKEN_OK ;
                fAcquired := true ;
                Result := true ;
                resume ;
            end ;
            break ;
        end;
    end ;
    fReason := vError ;
end;
//------------------------------------------------------------------------------
function TTokenManager.releaseToken : boolean ;
begin
    Result := false ;
    if fAcquired then begin
      Terminate ;
      Result := true ;
    end;
end;
//------------------------------------------------------------------------------
function TTokenManager.getInterface(aUrl : string) : IJetonLaunch ;
begin
    Result := nil ;
    if (aUrl = '') then Exit ;
    try
        fHttpRio := THTTPRio.Create(nil) ;
        fHttpRio.URL := aUrl ;
        fHttpRio.HTTPWebNode.ConnectTimeout := fTimeout ;
        fHttpRio.HTTPWebNode.ReceiveTimeout := fTimeout ;
        fHttpRio.HTTPWebNode.SendTimeout    := fTimeout ;
        Result := fHttpRio as IJetonLaunch ;
    except
    end;
end;
function TTokenManager.GetReasonString: string;
begin
  case fReason of
    TOKEN_OK            : Result := 'Jeton prit avec succes.';
    TOKEN_OQP           : Result := 'Jeton occupé.';
    TOKEN_ERR_CNX       : Result := 'Erreur Jeton lors de la connexion à la base de données.';
    TOKEN_ERR_PRM       : Result := 'Erreur Jeton paramètres invalide.';
    TOKEN_ERR_HTTP      : Result := 'Erreur Jeton impossible de se connecter au WebService.';
    TOKEN_ERR_INTERNAL  : Result := 'Erreur Jeton avec une erreur interne.';
    else Result := 'Erreur Jeton avec une erreur par défaut.';
  end;
end;
//------------------------------------------------------------------------------
function TTokenManager.doGetToken : integer ;
var
    vInterface : IJetonLaunch ;
    sResult    : string ;
begin
    Result := TOKEN_NEVER ;
    Log('Connecting to '+fUrl+' ...', logInfo) ;
    vInterface := getInterface(fUrl) ;
    try
        if Assigned(vInterface) then
        begin
            try
                sResult := vInterface.GetToken(fBase, fSender) ;
                if (sResult = 'OK')      then Result := TOKEN_OK  ;
                if (sResult = 'ERR-OQP') then Result := TOKEN_OQP ;
                if (sResult = 'ERR-CNX') then Result := TOKEN_ERR_CNX ;
                if (sResult = 'ERR-PRM') then Result := TOKEN_ERR_PRM ;
            except
                Result := TOKEN_ERR_HTTP ;
            end;
        end else begin
            Result := TOKEN_ERR_INTERNAL ;
        end;
        case Result of
            TOKEN_OK            : Log('Token acquired successfully.', logNotice) ;
            TOKEN_OQP           : Log('Error while trying to acquire token : Token is owned elsewhere.', logError) ;
            TOKEN_ERR_CNX       : Log('Error while trying to acquire token : Connection to Database error.', logError) ;
            TOKEN_ERR_PRM       : Log('Error while trying to acquire token : Parameters are invalid.', logError) ;
            TOKEN_ERR_HTTP      : Log('Error while trying to acquire token : Unable to connect to remote webservice.', logError) ;
            TOKEN_ERR_INTERNAL  : Log('Error while trying to acquire token : Internal Error.', logError) ;
        else
            Log('Error while trying to acquire token.', logError) ;
        end;
    finally
        vInterface := nil ;
    end;
end;
//------------------------------------------------------------------------------
function TTokenManager.doFreeToken : integer ;
var
    vInterface : IJetonLaunch ;
    sResult    : string ;
begin
    Log('Connecting to '+fUrl+' ...', logInfo) ;
    vInterface := getInterface(fUrl) ;
    try
        if Assigned(vInterface) then
        begin
            try
                vInterface.FreeToken(fBase, fSender) ;
                Result := TOKEN_OK ;
            except
                Result := TOKEN_ERR_HTTP ;
            end;
            fAcquired := false ;
        end else begin
            Result := TOKEN_ERR_INTERNAL ;
        end;
        case Result of
            TOKEN_OK            : Log('Token released successfully.', logNotice) ;
            TOKEN_ERR_HTTP      : Log('Error while trying to release token : Unable to connect to remote webservice.', logError) ;
            TOKEN_ERR_INTERNAL  : Log('Error while trying to release token : Internal Error.', logError) ;
        else
            Log('Error while trying to release token.', logError) ;
        end;
    finally
        vInterface := nil ;
    end;
end;
//------------------------------------------------------------------------------
procedure TTokenManager.Log(aMessage: string; aLevel: TLogLevel);
begin
    if Assigned(TokenLog) then
    begin
        TokenLog.Log(aMessage, aLevel) ;
    end;
end;

initialization
  { IJetonLaunch }
  InvRegistry.RegisterInterface(TypeInfo(IJetonLaunch), 'urn:JetonLaunchIntf-IJetonLaunch', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IJetonLaunch), 'urn:JetonLaunchIntf-IJetonLaunch#%operationName%');
  TokenLog := TLogFile.Create('.\Logs\Token_{%DATE}.log') ;

finalization
  TokenLog.Free ;

end.
