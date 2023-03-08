unit u_REST_API_Generic;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections,
  REST.Types, REST.Response.Adapter, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.Dialogs,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors,  Data.Bind.Grid, Data.Bind.DBScope,
  FireDAC.Comp.BatchMove, FireDAC.Comp.BatchMove.Text, FireDAC.Comp.BatchMove.DataSet, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.FMXUI.Wait, FireDAC.Comp.UI,
  System.DateUtils,
  System.JSON,
  Rest.Json,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin
  ;

type
  // mode d'authentification OAuth, APIKey (public/secret) , None
  TCAllKind = (cKStd, cKOAuth, cKAPI);
  TAuthenticationMode = (AMOAuth, AMAPIKEY, AMNone);


  TAPIDetail = class
    Service : string;    // Service of the API (company)
    Group : string;      // Group of the API
    Name : string;       // Name of the API  (to search it)
    HeaderMode : TAuthenticationMode;  // AMOAuth, AMAPIKEY, AMNone
    OAuthURL : string;   // URL de l'authentification
    Request : string;    // GET / POST / PUT / DELETE
    RequestMethod : TRESTRequestMethod;
    URL       : string;    // Complete base URL [with parameters]
    URLDebug  : string;    // URL Debug
    Route     : string;    // Route [with parameters]
    CallURL   : string;    // Constructed URL : URL + Route
    Key : string;        // Key values : ie
    Header : string;     // ex=   accept: application/json
    PostData : string;   // Post Data : to be add by AddParameters;
    Body : string;       // body of request
    Response : string;          // JSON
    FieldData : string;         // Response Field that contain Data
    FieldSuccess : string;      // Response Field that contain Success of Request
    SuccessValue : string;      // Response value that contain a Success response
    FieldErrorMessage : string; // Response Field that contain Error Message
    DataConversion : string;    // Conversion Field : Field1=>Name1(val1=valeur1,val2=valeur2);Field2=>Name2;Field3=>Name3
    CallError : string;         // Call Error
  public
    Constructor Create(aRow : TFDMemTable);
  end;



  TKeysList = Class(TFDMemTable)  //(TFDCustomMemTable)
  private

  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy;
    procedure LoadFrom(aSource : string);
    procedure SaveTo(aSource: string);
  published

  End;

  TAPIDetails = Class(TFDMemTable)  //(TFDCustomMemTable)
  private

  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy;
    procedure LoadFrom(aSource : string);
    procedure SaveTo(aSource: string);
  published
//    property Active;
//    property AutoCalcFields;
//    property BeforeOpen;
//    property AfterOpen;
//    property BeforeClose;
//    property AfterClose;
//    property BeforeInsert;
//    property AfterInsert;
//    property BeforeEdit;
//    property AfterEdit;
//    property BeforePost;
//    property AfterPost;
//    property BeforeCancel;
//    property AfterCancel;
//    property BeforeDelete;
//    property AfterDelete;
//    property BeforeScroll;
    property AfterScroll;
//    property BeforeRefresh;
//    property AfterRefresh;
//    property OnCalcFields;
//    property OnDeleteError;
//    property OnEditError;
//    property OnNewRecord;
//    property OnPostError;
//    property FieldOptions;
//    property Filtered;
//    property FilterOptions;
//    property Filter;
//    property OnFilterRecord;
//    property ObjectView default True;
//    property Constraints;
//    property DataSetField;
//    property FieldDefs stored FStoreDefs;
//    { TFDDataSet }
//    property CachedUpdates;
//    property FilterChanges;
//    property IndexDefs stored FStoreDefs;
//    property Indexes;
//    property IndexesActive;
//    property IndexName;
//    property IndexFieldNames;
//    property Aggregates;
//    property AggregatesActive;
//    property ConstraintsEnabled;
//    property MasterSource;
//    property MasterFields;
//    property DetailFields;
//    property OnUpdateRecord;
//    property OnUpdateError;
//    property OnReconcileError;
//    property BeforeApplyUpdates;
//    property AfterApplyUpdates;
//    property BeforeGetRecords;
//    property AfterGetRecords;
//    property AfterGetRecord;
//    property BeforeRowRequest;
//    property AfterRowRequest;
//    property BeforeExecute;
//    property AfterExecute;
//    property FetchOptions;
//    property FormatOptions;
//    property ResourceOptions;
//    property UpdateOptions;
//    { TFDAdaptedDataSet }
//    property LocalSQL;
//    property ChangeAlerter;
//    property ChangeAlertName;
//    { TFDCustomMemTable }
//    property Adapter;
//    property StoreDefs;

  End;

//  TAPIList = Class(TList<TAPIDetail>)
//  private
//    class procedure Init; static;
//    constructor Create;overloa;
//    Destructor Destroy; override;
//  public
//  End;

  TRESTAPI = class(TFDMemTable) // TObject)
  private
    FAPIKey : string;
    FAPIKeySecret : string;
//    FEndPointURL : string;

    FKeys : TSTringList;

    FRClient : TRESTClient;
    FRRequest : TRESTRequest;
    FRResponse : TRESTResponse;
    FParams : TstringList;
    FAPIKEYName: string;
    FAPIKeySecretName: string;
    FAPITimeStampName: string;
    FOAuth_Authorization: string;
    FOAuth_AccessToken: string;
    FOAuth_ContentType: string;
    FOAuth_URL: string;
    FOAuth_TokenType: string;
    FOAuth_ExpiresAt: TTime;
    FProxyPort: integer;
    FProxyPassword: string;
    FProxyUsername: string;
    FProxyServer: string;



    FOAuthExpired : TNotifyEvent;
    FOAuth_URL_Token: string;
    FSuccess: boolean;
    FErrorMessage: string;

    function GetAPI(aService : string ; aGroup : string ; aName : string) : TAPIDetail;
    function ReplaceParams(aSource: string ; aParams : TStringList = nil ; aStartDelimiter : string = '#' ; aEndDelimiter : string = '#'): string;
    procedure SetAPIKEYName(const Value: string);
    procedure SetAPIKeySecretName(const Value: string);
    procedure SetAPITimeStampName(const Value: string);
    procedure SetOAuth_AccessToken(const Value: string);
    procedure SetOAuth_Authorization(const Value: string);
    procedure SetOAuth_ContentType(const Value: string);
    procedure SetOAuth_URL(const Value: string);
    procedure SetOAuth_ExpiresAt(const Value: TTime);
    procedure SetOAuth_TokenType(const Value: string);
    procedure SetProxyPassword(const Value: string);
    procedure SetProxyPort(const Value: integer);
    procedure SetProxyServer(const Value: string);
    procedure SetProxyUsername(const Value: string);
    procedure Expires_in(const aSeconds: integer);
//    procedure OAuthExpired(const Value: TNotifyEvent);
    procedure SetOAuth_URL_Token(const Value: string);
    //function OAuth2(aURL, aClientID, aClientSecret, aRedirect_URL, aCodeAuth, aContentType: string): boolean;
    function OAuth2(aURL : string ; aClientID : string ; aClientSecret : string ; aRedirect_URL : string ; aCodeAuth : string ; aContentType : string = 'application/x-www-form-urlencoded') : boolean;
    function Expires_at(const aSeconds: integer): TTime;
    procedure OAuthExpired(const Value: TNotifyEvent);
    procedure SetErrorMessage(const Value: string);
    procedure SetSuccess(const Value: boolean);
  public
//    constructor Create(aAPIK, aAPIKS, aEndPointURL : string) ; overload;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class procedure Init; static;

    function  OAuth(aURL, aAuthorization : string ; aContentType: string  = 'application/x-www-form-urlencoded') : boolean;

    procedure AddParam(aName, aValue: string);
    Function CallAPI(aService : string = '' ; aAPIGroup : string = '' ; aAPIName : string = '' ; aParams : TStringList = nil) : string;

    function formatData(aStr : string ; kind : integer = 0) : string;
    procedure ExtractParamList(aStr: string);

  published

    property Params : TStringList read FParams write FParams;
    Property APIKEYName : string read FAPIKEYName write SetAPIKEYName;
    Property APIKeySecretName : string read FAPIKeySecretName write SetAPIKeySecretName;
    Property APITimeStampName : string read FAPITimeStampName write SetAPITimeStampName;

    property OAuth_URL : string read FOAuth_URL write SetOAuth_URL;
    property OAuth_URL_Token : string read FOAuth_URL_Token write SetOAuth_URL_Token;
    property OAuth_Authorization : string read FOAuth_Authorization write SetOAuth_Authorization;
    property OAuth_ContentType : string read FOAuth_ContentType write SetOAuth_ContentType;

    property OAuth_AccessToken : string read FOAuth_AccessToken write SetOAuth_AccessToken;
    property OAuth_TokenType : string read FOAuth_TokenType write SetOAuth_TokenType;
    property OAuth_ExpiresAt : TTime read FOAuth_Expiresat write SetOAuth_Expiresat;


    property ProxyServer   : string read FProxyServer write SetProxyServer;
    property ProxyPort     : integer read FProxyPort write SetProxyPort;
    property ProxyUsername : string read FProxyUsername write SetProxyUsername;
    property ProxyPassword : string read FProxyPassword write SetProxyPassword;

    property Success : boolean read FSuccess write SetSuccess;
    property ErrorMessage : string read FErrorMessage write SetErrorMessage;
//    property OAuthExpired : TNotifyEvent read FOAuthExpired write FOAuthExpired;
  end;

  procedure Split(aDelimiter: Char; aStr: string; aListOfStrings: TStrings) ;

var
  //FAPI : TList<TAPIDetail>;

  APIList : TAPIDetails;
  APIKeys : TKeysList;
  CallError : TList<TAPIDetail>;

implementation

{$IFDEF MSWINDOWS}
uses vcl.Dialogs;
{$ENDIF}

{ Generic Function }
{$region 'TRESTAPI ***************************************'}
procedure Split(aDelimiter: Char; aStr: string; aListOfStrings: TStrings) ;
begin
  aListOfStrings.Clear;
  aListOfStrings.Delimiter       := aDelimiter;
  aListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
  aListOfStrings.DelimitedText   := aStr;
  var i : integer := 0;
  while i < aListOfStrings.Count do
  begin
    aListOfStrings[i] := trim(aListOfStrings[i]);
    inc(i);
  end;
end;

{$endRegion}  // Generic function


{ TRESTAPI }

{$region 'TRESTAPI ***************************************'}
function TRESTAPI.ReplaceParams(aSource: string ; aParams : TStringList = nil ; aStartDelimiter : string = '#' ; aEndDelimiter : string = '#'): string;
var
  i : integer;
  vPosStart : integer;
  vPosEnd : integer;
  s : string;
  vField : string;
begin
  // Replace each parameters from #Value# to Value

  i := 0;
  while i < FParams.count do
  begin
    aSource := stringreplace(aSource, aStartDelimiter + FParams.KeyNames[i] + aEndDelimiter, FParams.Values[FParams.KeyNames[i]], [rfIgnoreCase, rfReplaceAll]);
    inc(i);
  end;

  if assigned(aParams) then
  begin
    i := 0;
    while i < aParams.count do
    begin
      aSource := stringreplace(aSource, aStartDelimiter + aParams.KeyNames[i] + aEndDelimiter, aParams.Values[aParams.KeyNames[i]], [rfIgnoreCase, rfReplaceAll]);
      inc(i);
    end;
  end;

  // Detect Left paraméters
  vPosStart := pos(aStartDelimiter, aSource);
  if vPosStart > 0 then
  begin
    vPosEnd := vPosStart + pos(aEndDelimiter, copy(aSource, 1 + vPosStart, length(aSource)));
    s := '';
    while vPosStart < vPosEnd do
    begin
      vField := copy(aSource, length(aStartDelimiter) + vPosStart, vPosEnd - vPosStart - length(aStartDelimiter));
      {$IFDEF MSWINDOWS}
      if DebugHook > 0 then
      begin
        // In debug Mode : ask for values
        s := vcl.Dialogs.InputBox('Enter value', vField + ' = ', '');
      end;
      {$ENDIF}

      // Replace left values
      aSource := stringreplace(aSource, aStartDelimiter + vField  + aEndDelimiter, s, [rfIgnoreCase, rfReplaceAll]);

      vPosStart := pos(aStartDelimiter, aSource);
      vPosEnd := vPosStart + pos(aEndDelimiter, copy(aSource, 1 + vPosStart, length(aSource)));
    end;

  end;
  result := aSource;

end;

Procedure TRESTAPI.ExtractParamList(aStr : string);
begin
  // var List : TStringList := TStringList.Create;

  if Assigned(FParams) then
  begin
    Split('|', aStr, FParams) ;
  end;

end;

function TRESTAPI.formatData(aStr: string; kind: integer): string;
begin
  if kind = 0 then // texte
    result := trim(aStr)
  else if kind = 1 then  // numérique
  begin
    aStr := trim(stringReplace(aStr, ',', '.', [rfReplaceAll]));
    result := copy(aStr,0, pos('.', aStr) + 6);
  end;
end;


//constructor TRESTAPI.Create(aAPIK, aAPIKS, aEndPointURL : string);
constructor TRESTAPI.Create(AOwner: TComponent);
var
  s : string;
  ts : double;
begin
  //
  Inherited Create(AOwner);

  FAPIKEY := {$IFDEF DEBUG}'eCaX-So_EwlhDmi_X7'{$ELSE}aAPIK{$ENDIF};
  FAPIKeySecret := {$IFDEF DEBUG}'PCb3D7OmbBFdl0J6X1bmU-S'{$ELSE}aAPIKS{$ENDIF};
//  if aEndPointURL = '' then
//    aEndPOintURL := '';
//  FEndPointURL := aEndPointURL;

  // Init
  FParams := TstringList.Create;

  // Creation des accès Web
  FRClient := TRESTClient.Create('');
  FRRequest := TRESTRequest.Create(nil);
  FRResponse := TRESTResponse.Create(nil);
  FRRequest.Client := FRClient;
  FRRequest.Response := FRResponse;

  OAuth_ExpiresAt := -1;


//  FRRequest.Resource := 'o/oauth2/token';
//  FRRequest.AddParameter('code', 'AUTHCODE_FROM_STEP#1', TRESTRequestParameterKind.pkGETorPOST);
//  FRRequest.AddParameter('client_id', 'AUTHCODE_FROM_STEP#1', TRESTRequestParameterKind.pkGETorPOST);
//  FRRequest.AddParameter('client_secret', 'AUTHCODE_FROM_STEP#1', TRESTRequestParameterKind.pkGETorPOST);
//  FRRequest.AddParameter('redirect_uri', 'AUTHCODE_FROM_STEP#1', TRESTRequestParameterKind.pkGETorPOST);
//  FRRequest.AddParameter('grant_type', 'AUTHCODE_FROM_STEP#1', TRESTRequestParameterKind.pkGETorPOST);

  // Appel
//  FRRequest.Method := TRESTRequestMethod.rmPOST;
//  ts := time * 1000;
//  FRRequest.AddParameter(APIKEYName, FAPIKEY, TRESTRequestParameterKind.pkHTTPHEADER);
//  FRRequest.AddParameter(APIKeySecretName, FAPIKeySecret, TRESTRequestParameterKind.pkHTTPHEADER);
//  FRRequest.AddParameter(APITimeStampName, floattostr(ts), TRESTRequestParameterKind.pkHTTPHEADER);
//
//  FRRequest.Execute;
//
// // s := FRResponse.JSONValue.TryGetValue<string>('access_token');
//  if not(FRResponse.JSONValue.GetValue<boolean>('success', false)) then
//  begin
//    Showmessage('Authentication Error');
//  end;

  // Authentification

end;

destructor TRESTAPI.Destroy;
begin
  // Réinit informations
  FAPIKEY := '';
  FAPIKeySecret := '';

  FRClient.Free;
  FRRequest.Free;
  FRResponse.Free;
  // Destruction des Accés Web

  FParams.free;

  inherited;
end;


function TRESTAPI.OAuth2(aURL : string ; aClientID : string ; aClientSecret : string ; aRedirect_URL : string ; aCodeAuth : string ; aContentType : string = 'application/x-www-form-urlencoded') : boolean;
var
  vClient: TRestClient;
  vRequest: TRestRequest;
  vResponse: TRestResponse;
  vJSON: TJSONObject;
  vAccess_Token: string;
begin
  // Création de l'objet REST client
  vClient := TRestClient.Create(OAuth_URL_Token);
  try
    // Création de l'objet REST request
    vRequest := TRestRequest.Create(vClient);
    try
      // Préparation des données à envoyer dans la requête
      vJSON := TJSONObject.Create;
      try
        vJSON.AddPair('grant_type', 'authorization_code');
        vJSON.AddPair('client_id', aClientID);
        vJSON.AddPair('client_secret', aClientSecret);
        vJSON.AddPair('redirect_uri', aRedirect_URL);
        vJSON.AddPair('code', aCodeAuth);
      finally
        // Ajout des données à la requête
        vRequest.Body.Add(vJSON.ToString, TRESTContentType.ctAPPLICATION_JSON);
      end;

      // Envoi de la requête HTTP POST
      vRequest.Client := vClient;
      vRequest.Response := vResponse;

      vRequest.Execute;


      // Traitement de la réponse
      if vResponse.StatusCode = 200 then
      begin
        // Récupération du jeton d'accès à partir de la réponse
        vJSON := TJSONObject.ParseJSONValue(vResponse.Content) as TJSONObject;
        try
          vAccess_Token := vJSON.GetValue('access_token').Value;
          // Utilisation du jeton d'accès pour accéder aux ressources protégées
          // (par exemple, en incluant le jeton dans l'en-tête "Authorization"
          //  de chaque requête HTTP envoyée au serveur)
          // ...
        finally
          vJSON.Free;
        end;
      end
      else
      begin
        // Gestion des erreurs
        // ...
      end;
    finally
      vRequest.Free;
    end;
  finally
    vClient.Free;
  end;

end;


function TRESTAPI.OAuth(aURL : string ; aAuthorization : string ; aContentType : string = 'application/x-www-form-urlencoded') : boolean;
var
  vClient   : TRestClient;
  vRequest  : TRestRequest;
  vResponse : TRestResponse;
  vJSON : TJSONObject;
  vAccess_token : string;
begin

  result := false;
  FRClient.UserAgent := 'API serveur';
  vClient := TRestClient.Create(aURL);

  if FProxyServer <> '' then
  begin

    FRClient.ProxyServer   := FProxyServer;
    FRClient.ProxyPort     := FProxyPort;
    if FProxyUsername <> '' then
    begin
      FRClient.ProxyUsername := FProxyUsername;
      FRClient.ProxyPassword := FProxyPassword;
    end;
  end;

  FRClient.BaseURL := aURL;
  FRRequest.Resource := '';
  FRRequest.Method := TRESTRequestMethod.rmPOST;
  FRRequest.AddParameter('Authorization', aAuthorization, TRESTRequestParameterKind.pkHTTPHEADER);
  FRRequest.AddParameter('Content-Type', aContentType, TRESTRequestParameterKind.pkHTTPHEADER);
  try
    FRRequest.Execute;
  except
    // exit;
    raise Exception.Create('OAuth Error, verify your credentials and restart');
    exit;
  end;

  try
    FOAuth_AccessToken := FRResponse.JSONValue.GetValue<string>('access_token');
    FOAuth_TokenType   := FRResponse.JSONValue.GetValue<string>('token_type');
    FOAuth_Expiresat   := Expires_at(FRResponse.JSONValue.GetValue<integer>('expires_in'));
    result := true;
  except
    result := false;
    raise Exception.Create('OAuth Server Error, contact your administrator');
    exit;
  end;


//  if (FRResponse.JSONValue.GetValue<string>('access_token', '')) then
//  begin
//
//    VRRDSA.RootElement := 'result';
//    VRRDSA.Active := true;
//  end
//  else
//  begin
//    ShowMessage(FRResponse.JSONValue.GetValue<string>('error', 'error') + ' ' + s);
//  end;

end;

procedure TRESTAPI.OAuthExpired(const Value: TNotifyEvent);
begin
  FOAuthExpired := Value;
end;

function TRESTAPI.GetAPI(aService : string ; aGroup : string; aName: string): TAPIDetail;
var
  i : integer;
begin
  i := 0;
//  aName := Uppercase(AName);

  if APIList.Locate('Service;Group;Name;', VarArrayOf([aService, aGroup, aName]), [TLocateOption.loCaseInsensitive])  then  // TLocateOption.loCaseInsensitive
  begin
    result := TAPIDetail.Create(APIList);
  end
  else
  begin
    result := nil;
    raise Exception.Create('Service ' + aService + '/' + 'API ' + aGroup + '/' + aName + ' not found');
  end;

//  while i  < FAPI.Count do
//  begin
//    if FAPI[i].Name = aName then
//    begin
//      result := FAPI[i];
//      exit;
//    end;
//
//    inc(i);
//  end;
//  if i >= FAPI.Count then
//    raise Exception.Create('API ' + aGroup + '/' + aName + ' not found');

end;


function TRESTAPI.CallAPI(aService : string = '' ; aAPIGroup : string = '' ; aAPIName : string = '' ; aParams : TStringList = nil) : string;
var
  vRRDSA : TRestResponseDataSetAdapter;
  vMT : TFDMemTable;
  i : integer;
  vQry : TFDQuery;
  vAPI : TAPIDetail;
  s : string;
  ts : double;
  vParams : TStringList;
  vBaseURL : string;
begin

  vAPI := GetAPI(aService, aAPIGroup, aAPIName);

  if Assigned(vAPI) then
  begin
    // Charger les valeurs
    vAPI.URL      := ReplaceParams(vAPI.URL, aParams);
    vAPI.URLDebug := ReplaceParams(vAPI.URL, aParams);
    if DebugHook <> 0 then
    begin
      {$IFDEF PRODUCTION}
        vBaseURL := vAPI.URL
      {$ELSE}
        vBaseURL := vAPI.URLDebug
      {$ENDIF}
    end
    else
      vBaseURL := vAPI.URL;

    vAPI.Route    := ReplaceParams(vAPI.Route, aParams);
    vAPI.CallURL  := vBaseURL + vAPI.Route;
    vAPI.Key      := ReplaceParams(vAPI.Key, aParams);
    vAPI.Header   := ReplaceParams(vAPI.Key, aParams);
    vAPI.PostData := ReplaceParams( StringReplace(vAPI.PostData, '|', chr(13), [rfReplaceAll]), aParams);
    vAPI.Body     := ReplaceParams(vAPI.Body, aParams);

    FRClient.BaseURL :=  vAPI.CallURL;  //vAPI.URL;
    FRClient.SynchronizedEvents := false;
    // FRRequest.Resource := vAPI.CallURL;

    FRRequest.Client := FRClient;
    // FRRequest.AssignedValues := [TAssignedValue.rvConnectTimeout, TAssignedValue.rvReadTimeout];     // (rvAccept, rvHandleRedirects, rvAcceptCharset, rvAcceptEncoding, rvAllowCookies, rvConnectTimeout, rvReadTimeout
    FRRequest.Method := vAPI.RequestMethod;
    FRRequest.Response := FRResponse;
    FRRequest.SynchronizedEvents := false;

    // Authentification
    if vAPI.HeaderMode = TAuthenticationMode.AMOAuth then
    begin
      // exemple :
      //    {
      //    "access_token":"kZBwyADEDgjYw4rADIWA0rPOtc9ULQ7FHdQZ
      //    2yWz9vxWseaihQU0IL",
      //    "token_type":"Bearer",
      //    "expires_in":7200,
      //    }
      if FOAuth_Expiresat - 5 < now then
      begin
         // rafraichir le token
  //      if not(API.OAuth('https://digital.iservices.rte-france.com/token/oauth/', 'Basic ' + E_Authorization.Text)) then
  //      begin
  //
  //        if assigned(OAuthExpired) then
  //           OAuthExpired(Self);
  //
  //        Exit;
  //
  //      end;
      end;

     FRRequest.AddParameter('token_type', FOAuth_Authorization, TRESTRequestParameterKind.pkHTTPHEADER);
     FRRequest.AddParameter('access_token', FOAuth_AccessToken, TRESTRequestParameterKind.pkHTTPHEADER);

  //  end
  //  else if vAPI.HeaderMode = TAuthentificationMode.AMAPIKEY then
  //  begin
  //    ts := time * 1000;
  //    FRRequest.AddParameter(APIKEYName, FAPIKEY, TRESTRequestParameterKind.pkHTTPHEADER);
  //    FRRequest.AddParameter(APIKeySecretName, FAPIKeySecret, TRESTRequestParameterKind.pkHTTPHEADER);
  //    FRRequest.AddParameter(APITimeStampName, floattostr(ts), TRESTRequestParameterKind.pkHTTPHEADER);
    end
    else if vAPI.HeaderMode = TAuthenticationMode.AMNone then
    begin

    end;

    vParams := TStringList.Create;
    try
      // Header
      if vAPI.Header <> '' then
      begin
        //FRRequest.Params.AddItem('Authorization', 'key=AAAd...', pkHTTPHEADER, [TRestRequestParameterOption.poDoNotEncode]);
        // poDoNotEncode, poTransient, poAutoCreated, poFlatArray, poPHPArray, poListArray

        vParams.Text := vAPI.Header;
        i := 0;
        while i < vParams.Count do
        begin
          FRRequest.Params.AddItem(vParams.KeyNames[i], vParams.ValueFromIndex[i], pkHTTPHEADER, [TRestRequestParameterOption.poDoNotEncode]);
          inc(i);
        end;

      end;

      // Post Data
      if vAPI.PostData <> '' then
      begin
        //FRRequest.Params.AddItem('Authorization', 'key=AAAd...', pkGETorPOST, [TRestRequestParameterOption.poDoNotEncode]);
        vParams.Text := vAPI.PostData;
        i := 0;
        while i < vParams.Count do
        begin
          FRRequest.Params.AddItem(vParams.KeyNames[i], vParams.ValueFromIndex[i], pkGETorPOST, [TRestRequestParameterOption.poDoNotEncode]);
          inc(i);
        end;

      end;

    finally
      vParams.Free;
    end;
    // Body
    if vAPI.Body <> '' then
    begin
      FRRequest.addBody(vAPI.Body);  // , tRestContentType.ctAPPLICATION_JSON par défaut ?
    end;


    Try
      vRRDSA := TRestResponseDataSetAdapter.Create(nil);
      //vMT := TFDMemTable.Create(nil);
      VRRDSA.Dataset := self;
      VRRDSA.ResponseJSON := FRResponse;

      try
        FRRequest.Execute;
      except
        // exit;
        vAPI.CallError := FRRequest.Response.ToString;
        CallError.Add(vAPI);

        if debugHook <> 0 then
        begin
          raise Exception.Create('Query Error' + FRRequest.Response.ToString);
        end
        else
          raise Exception.Create('Query Error ' + vAPI.Service + '/'+ vAPI.Group + '/' + vAPI.Name);
        exit;
      end;

      Success := false;
      if FRResponse.JSONValue.ParseJSONValue(FRResponse.Content, true, true) = nil then //= -1 then
      begin
        // Ce n'est pas un JSON ... on fait quoi ?
        raise Exception.Create('Error : unknow type of data : ' + #$A#$D + FRResponse.Content);

      end
      else
      begin
        // Gestion des réponses
        if (vAPI.FieldData = '') or ((vAPI.FieldSuccess <> '') and (FRResponse.JSONValue.FindValue(vAPI.FieldSuccess) <> nil)) then
        begin
          // Success
          if FRResponse.JSONValue.FindValue(vAPI.FieldSuccess).Value  =  vAPI.SuccessValue then
          begin
            Success := true;
            if (vAPI.FieldData = '') or (FRResponse.JSONValue.GetValue<boolean>(vAPI.FieldSuccess , false)) then
            begin
              VRRDSA.RootElement := vAPI.FieldData;
              VRRDSA.Active := true;
              //
              vAPI.Free;
            end;
            result := '';
          end
          else
          begin
            result := FRResponse.JSONValue.FindValue(vAPI.FieldSuccess).Value +  ' - ' + FRResponse.JSONValue.FindValue(vAPI.FieldErrorMessage).Value;
            // raise Exception.Create('Error : ' + FRResponse.JSONValue.GetValue<string>(vAPI.FieldSuccess , 'unknown') + ' - ' + FRResponse.JSONValue.GetValue<string>(vAPI.FieldErrorMessage , 'unknown error'));
          end;
        end
        else if (vAPI.FieldErrorMessage <> '') and  ((FRResponse.JSONValue.FindValue(vAPI.FieldErrorMessage)) <> nil) then
        begin
          // Erreur cononue : afficher le message
          raise Exception.Create('Error : ' + FRResponse.JSONValue.GetValue<string>(vAPI.FieldErrorMessage , 'unknown'));
        end
        else
        begin
          // Erreur inconnue
          raise Exception.Create('Error : unknow ' + FRResponse.Content);
        end;

      end;
    Finally
      vRRDSA.Free;
      // vMT.Free;  remplacé par self
    End;


  end
  else
  begin
    raise Exception.Create('API Not found');
  end;
end;



class procedure TRESTAPI.Init;
var
  vAPI : TAPIDetail;
begin

  // FAPI := TList<TAPIList>.create;
//  FAPI := TList<TAPIDetail>.Create;
//
//  // https://docs.ftx.com/#place-order
//  vAPI := TAPIDetail.Create;
//  vAPI.HeaderMode := TAuthentificationMode.AMOAuth;
//  vAPI.OAuthURL := 'https://digital.iservices.rte-france.com/token/oauth/';
//  vAPI.OAuthHeader1 := 'Authorization:Basic :pki64encoded';
//  vAPI.OAuthHeader2 := 'Content-Type:application/x-www-form-urlencoded';
//  vAPI.Key := 'ECOWATT';
//  vAPI.group := 'GetInfo';
//  vAPI.name := uppercase('GetInfo');
//  vAPI.Request := 'GET';
//  vAPI.URL := ''; ///open_api/ecowatt/v4/sandbox/signals';
//  vAPI.Header := '';
//  vAPI.APIRequest := '';
//  vAPI.Response := '';
//  FAPI.add( vAPI);


end;



procedure TRESTAPI.AddParam(aName, aValue: string);
begin
  FParams.Values[trim(aName)] := aValue;
end;

procedure TRESTAPI.SetAPIKEYName(const Value: string);
begin
  FAPIKEYName := Value;
end;

procedure TRESTAPI.SetAPIKeySecretName(const Value: string);
begin
  FAPIKeySecretName := Value;
end;

procedure TRESTAPI.SetAPITimeStampName(const Value: string);
begin
  FAPITimeStampName := Value;
end;

procedure TRESTAPI.SetErrorMessage(const Value: string);
begin
  FErrorMessage := Value;
end;

Function TRESTAPI.Expires_at(const aSeconds : integer) : TTime;
begin
  FOAuth_Expiresat := IncSecond(Now, aSeconds);
end;

procedure TRESTAPI.Expires_in(const aSeconds: integer);
begin

end;

procedure TRESTAPI.SetOAuth_AccessToken(const Value: string);
begin
  FOAuth_AccessToken := Value;
end;

procedure TRESTAPI.SetOAuth_Authorization(const Value: string);
begin
  FOAuth_Authorization := Value;
end;

procedure TRESTAPI.SetOAuth_ContentType(const Value: string);
begin
  FOAuth_ContentType := Value;
end;

procedure TRESTAPI.SetOAuth_Expiresat(const Value: TTime);
begin
  FOAuth_Expiresat := Value;
end;

procedure TRESTAPI.SetOAuth_TokenType(const Value: string);
begin
  FOAuth_TokenType := Value;
end;

procedure TRESTAPI.SetOAuth_URL(const Value: string);
begin
  FOAuth_URL := Value;
end;

procedure TRESTAPI.SetOAuth_URL_Token(const Value: string);
begin
  FOAuth_URL_Token := Value;
end;

procedure TRESTAPI.SetProxyPassword(const Value: string);
begin
  FProxyPassword := Value;
end;

procedure TRESTAPI.SetProxyPort(const Value: integer);
begin
  FProxyPort := Value;
end;

procedure TRESTAPI.SetProxyServer(const Value: string);
begin
  FProxyServer := Value;
end;

procedure TRESTAPI.SetProxyUsername(const Value: string);
begin
  FProxyUsername := Value;
end;


procedure TRESTAPI.SetSuccess(const Value: boolean);
begin
  FSuccess := Value;
end;

{$endRegion} // TRESTAPI



{ TAPIDetail }

{$region 'TAPIDetail *******************'}
constructor TAPIDetail.Create(aRow : TFDMemTable);
var
  s : string;
begin

  self.Service := aRow.FieldByName('Service').AsString;
  self.Group   := aRow.FieldByName('Group').AsString;
  self.Name    := aRow.FieldByName('Name').AsString;

  s := aRow.FieldByName('HeaderMode').AsString;
  if s = 'AMOAuth' then
    self.HeaderMode := AMOAuth
  else if s = 'AMAPIKEY' then
    self.HeaderMode := AMAPIKEY
  else
    self.HeaderMode := AMNone;

  self.OAuthURL := aRow.FieldByName('OAuthURL').AsString;
  self.Request  := Uppercase(aRow.FieldByName('Request').AsString);
  if self.Request = 'GET' then
    RequestMethod := TRESTRequestMethod.rmGET
  else if self.Request = 'POST' then
    RequestMethod := TRESTRequestMethod.rmPOST
  else if self.Request = 'PUT' then
    RequestMethod := TRESTRequestMethod.rmPUT
  else if self.Request = 'DELETE' then
    RequestMethod := TRESTRequestMethod.rmDELETE
  else if self.Request = 'PATCH' then
    RequestMethod := TRESTRequestMethod.rmPATCH;
  // See to get more Method...

  self.URL      := aRow.FieldByName('URL').AsString;
  self.URL      := aRow.FieldByName('URLDebug').AsString;
  self.Route    := aRow.FieldByName('Route').AsString;
  self.CallURL   := '';  // Initialise at the call : URL + Route
  self.Key      := aRow.FieldByName('Key').AsString;
  self.Header   := aRow.FieldByName('Header').AsString;
  self.PostData := aRow.FieldByName('PostData').AsString;
  self.Body     := aRow.FieldByName('Body').AsString;
  self.Response     := aRow.FieldByName('Response').AsString;
  self.FieldData    := aRow.FieldByName('FieldData').AsString;
  self.FieldSuccess := aRow.FieldByName('FieldSuccess').AsString;
  self.SuccessValue := aRow.FieldByName('SuccessValue').AsString;
  self.FieldErrorMessage := aRow.FieldByName('FieldErrorMessage').AsString;
  self.DataConversion    := aRow.FieldByName('DataConversion').AsString;

end;

{$endregion}


{ TAPIDetails }

{$region 'TAPIDetails *******************'}
constructor TAPIDetails.Create(AOwner: TComponent);
begin
  inherited;
  //

  self.ResourceOptions.ParamCreate := True;

  with self.FieldDefs do
  begin
     Add('Service', ftString, 120, False);      // Service of the API
     Add('Group', ftString, 60, False);         // Group of the API
     Add('Name',  ftString, 60, True);          // Name of the API  (to search it)
     Add('HeaderMode', ftString, 32, False);    // TAuthenticationMode
     Add('OAuthURL', ftString, 32, False);      // URL de l'authentification
     Add('Request',  ftString, 10, False);      // GEST / POST / PUT / DELETE
     Add('URL',      ftString, 500, False);     // Complete URL with parameters
     Add('URLDebug', ftString, 500, False);     // Complete URL in DEBUG Mode with parameters
     Add('Route',    ftString, 500, False);     // Route to Add to URL
     Add('Key',      ftString, 1024, False);    // Key pour API tierce
     Add('Header',   ftString, 2048, False);    // ex=   accept: application/json
     Add('PostData', ftString, 4096, False);    // Data field
     Add('Body',     ftString, 4096, False);    // JSON or plainText
     Add('Response', ftString, 8192, False);    // JSON
     Add('FieldData', ftString, 255, False);          // Response Field that contain Data
     Add('FieldSuccess', ftString, 256, False);      // Response Field that contain Success of Request
     Add('SuccessValue', ftString, 64, False);       // Response value that contain a Success response
     Add('FieldErrorMessage', ftString, 256, False); // Response Field that contain Error Message
     Add('DataConversion', ftString, 8192, False);  // Field1=>Name1(val1=valeur1,val2=valeur2);Field2=>Name2;Field3=>Name3

     CreateDataset;
     Open;
  end;

end;

destructor TAPIDetails.Destroy;
begin
  //

  inherited;
end;

procedure TAPIDetails.LoadFrom(aSource: string);
begin
  if pos('STREAM:', uppercase(aSource)) > 0 then
  begin
//    self.LoadFromStream(  aSource);

  end
  else if pos('RESSOURCE:', uppercase(aSource)) > 0 then
  begin

  end
  else if pos('URL:', uppercase(aSource)) > 0 then
  begin

  end
  else
  begin
    // File
    self.LoadFromFile(aSource, TFDStorageFormat.sfJSON);
    self.Active := true;
  end;
end;

procedure TAPIDetails.SaveTo(aSource: string);
begin
  if pos('STREAM:', uppercase(aSource)) > 0 then
  begin
//    self.SaveToStream(aSource);

  end
  else if pos('RESSOURCE:', uppercase(aSource)) > 0 then
  begin

  end
  else if pos('URL:', uppercase(aSource)) > 0 then
  begin

  end
  else
  begin
    // File
    self.SaveToFile(aSource, TFDStorageFormat.sfJSON);

  end;
end;

{$endregion}  // TAPIDetails


{ TKeysList }
{$region 'TKeyList ********************************'}
constructor TKeysList.Create(AOwner: TComponent);
begin
  inherited;

  self.ResourceOptions.ParamCreate := True;

  with self.FieldDefs do
  begin
    Add('Service', ftString, 120, False);       // Service of the API
    Add('Group', ftString, 60, False);          // Group of the API
    Add('Name',  ftString, 60, True);           // Name of the API  (to search it)
    Add('Kind',  ftString, 20, False);          // UserPwd-APIKey-OAuth-
    Add('Encryption', ftString, 30, False);     // None, Base64,
    Add('KeyName',    ftString, 1024, False);   // Keyname : APIKey-Public, APIKey-Private, APIKeyBase64,
    Add('KeyValue',   ftString, 2048, False);   // Value
    Add('TimeStamp',  ftDateTime);              // dernière date de mise à jour

    CreateDataset;
    Open;
  end;

end;

destructor TKeysList.Destroy;
begin

  inherited;
end;

procedure TKeysList.LoadFrom(aSource: string);
begin
  // File
  self.LoadFromFile(aSource, TFDStorageFormat.sfBinary);

end;

procedure TKeysList.SaveTo(aSource: string);
begin
  // File
  self.SaveToFile(aSource, TFDStorageFormat.sfBinary);

end;

{$endregion}   // TKeyList




initialization
  TRESTAPI.Init;

  APIList := TAPIDetails.Create(nil);
  if FileExists('list.API') then
    aPIList.LoadFrom('list.API'); //      'ressource:name');'stream:name');
//  FAPI : TList<TAPIDetail>;
//  FKeys := TstringList.Create;

  APIKeys := TKeysList.Create(nil);
  if FileExists('list.keys') then
    APIKeys.LoadFrom('list.keys'); //      'ressource:name');'stream:name');

  CallError := TList<TAPIDetail>.create;

finalization
  APIList.Free;
  APIKeys.Free;

  while CallError.Count > 0 do
  begin
    CallError.Delete(0);
  end;

  CallError.Free;

  //  FAPI.free;
//  FKeys.Free;


end.
