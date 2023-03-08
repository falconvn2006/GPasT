unit dmdGINKOIA_XE7;

interface

uses
  SysUtils, Windows, Classes, FMTBcd, WideStrings, SqlExpr, DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.IBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait;

const
  cRC = #13#10;
  cSql_S_GENPARAM = 'SELECT' + cRC +
                      'PRM_ID,' + cRC +
                      'PRM_INTEGER,' + cRC +
                      'PRM_FLOAT,' + cRC +
                      'PRM_STRING' + cRC +
                    'FROM GENPARAM' + cRC +
                      'JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)' + cRC +
                    'WHERE PRM_TYPE = :PPRMTYPE' + cRC +
                      'AND PRM_POS = :PPRMPOS' + cRC +
                      'AND PRM_CODE = :PPRMCODE';

  cSql_S_GENPARAM_BY_MAG = 'SELECT' + cRC +
                             'PRM_ID,' + cRC +
                             'PRM_INTEGER,' + cRC +
                             'PRM_FLOAT,' + cRC +
                             'PRM_STRING' + cRC +
                           'FROM GENPARAM' + cRC +
                             'JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)' + cRC +
                           'WHERE PRM_TYPE = :PPRMTYPE' + cRC +
                             'AND PRM_MAGID = :PPRMMAGID' + cRC +
                             'AND PRM_CODE = :PPRMCODE';
  cSql_S_GENPARAM_SS_KENABLED = 'SELECT' + cRC +
                                  'PRM_ID,' + cRC +
                                  'PRM_INTEGER,' + cRC +
                                  'PRM_FLOAT,' + cRC +
                                  'PRM_STRING,' + cRC +
                                  'K_ENABLED' + cRC +
                                'FROM GENPARAM' + cRC +
                                  'JOIN K ON (K_ID = PRM_ID)' + cRC +
                                'WHERE PRM_TYPE = :PPRMTYPE' + cRC +
                                  'AND PRM_POS = :PPRMPOS' + cRC +
                                  'AND PRM_CODE = :PPRMCODE';

  cSql_S_GENPARAM_BY_MAG_SS_KENABLED = 'SELECT' + cRC +
                                         'PRM_ID,' + cRC +
                                         'PRM_INTEGER,' + cRC +
                                         'PRM_FLOAT,' + cRC +
                                         'PRM_STRING,' + cRC +
                                         'K_ENABLED' + cRC +
                                       'FROM GENPARAM' + cRC +
                                         'JOIN K ON (K_ID = PRM_ID)' + cRC +
                                       'WHERE PRM_TYPE = :PPRMTYPE' + cRC +
                                         'AND PRM_MAGID = :PPRMMAGID' + cRC +
                                         'AND PRM_CODE = :PPRMCODE';

type
  TdmGINKOIA = class(TDataModule)
    STP_UPDATEK: TFDStoredProc;
    CNX_GINKOIA: TFDConnection;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    STP_NEWK: TFDStoredProc;
    STP_INITIALISEMAG: TFDStoredProc;
    Transaction: TFDTransaction;
    STP_GRPASSOCIEMAG: TFDStoredProc;
    QUE_KENABLED: TFDQuery;
  private
    sDatabase : string ;
    sUsername : string ;
    sPassword : string ;

    lockDatabase : TRTLCriticalSection ;

    procedure connectToDatabase overload ;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy ; override ;

    procedure connectToDatabase(aDatabase, aUsername, aPassword : string) ; overload ;
    function checkDatabaseConnexion : boolean ;

    function GetNewID(Const ATableName: String): integer;
    function GetNewQry(Const AOwner: TComponent = nil): TFDQuery;
    function PR_GRPASSOCIEMAG(Const AMAGA_ID: integer; Const AUGG_NOM: String;
                              Const AUGM_DATE: TDateTime): integer;

    procedure UpdateK(Const K_ID, Suppression: integer);

    function GetParam(var IOInteger: Integer; var IOFloat: Double; var IOString: string; var IOId: Integer; AType, ACode, ABasID: Integer): Boolean;
    function GetParamID(AType, ACode, ABasID: integer): Integer;
    function GetParamString(AType, ACode, ABasID: integer): string;
    function GetParamFloat(AType, ACode, ABasID: integer): Double;
    function GetParamInteger(AType, ACode, ABasID: integer): Integer;

    function GetParamByMag(var IOInteger: Integer; var IOFloat: Double; var IOString: string; var IOId: Integer; AType, ACode, AMagID: Integer): Boolean;
    function GetParamIDByMag(AType, ACode, AMagID: integer): Integer;
    function GetParamStringByMag(AType, ACode, AMagID: Integer): string;
    function GetParamFloatByMag(AType, ACode, AMagID: Integer): Double;
    function GetParamIntegerByMag(AType, ACode, AMagID: Integer): Integer;

    function GetParam_SS_KENABLED(var IOInteger: Integer; var IOFloat: Double; var IOString: string; var IOId: Integer; var IOKEnabled: Integer; AType, ACode, APos: Integer): Boolean;
    function GetParamID_SS_KENABLED(AType, ACode, ABasID: integer): Integer;
    function GetParamString_SS_KENABLED(AType, ACode, ABasID: integer): string;
    function GetParamFloat_SS_KENABLED(AType, ACode, ABasID: integer): Double;
    function GetParamInteger_SS_KENABLED(AType, ACode, ABasID: integer): Integer;
    function GetParamKEnabled_SS_KENABLED(AType, ACode, ABasID: integer): Integer;

    function GetParamByMag_SS_KENABLED(var IOInteger: Integer; var IOFloat: Double; var IOString: string; var IOId: Integer; var IOKEnabled: Integer; AType, ACode, AMagID: Integer): Boolean;
    function GetParamIDByMag_SS_KENABLED(AType, ACode, AMagID: integer): Integer;
    function GetParamStringByMag_SS_KENABLED(AType, ACode, AMagID: Integer): string;
    function GetParamFloatByMag_SS_KENABLED(AType, ACode, AMagID: Integer): Double;
    function GetParamIntegerByMag_SS_KENABLED(AType, ACode, AMagID: Integer): Integer;
    function GetParamKEnabledByMag_SS_KENABLED(AType, ACode, AMagID: Integer): Integer;

    function SetParam(AInteger: integer; AFloat: double; AString: string; AId: integer):Boolean;
    function SetParamString(AId: integer; AValue:string):Boolean;
    function SetParamFloat(AId: integer; AValue:double):Boolean;
    function SetParamInteger(AId, AValue: integer):Boolean;

    function CreateParam(AType, ACode, AMagID, APos, AInteger: integer; AFloat: double; AString, AInfo: string):Boolean;
  end;

var
  dmGINKOIA: TdmGINKOIA;

function ConnectToGINKOIA(Const ADataBase: String): TdmGINKOIA;

implementation

uses uConst;

function ConnectToGINKOIA(const ADataBase: String): TdmGINKOIA;
begin
  Result:= TdmGINKOIA.Create(nil);
  try
    Result.connectToDatabase(ADataBase, 'sysdba', 'masterkey') ;
  except
    on E: Exception do
      raise Exception.Create('Erreur lors de la connexion à la base [' + Result.CNX_GINKOIA.Params.Database + '] avec le message : ' + E.Message) ;
  end;
end;

{$R *.dfm}

{ TdmGINKOIA }

constructor TdmGINKOIA.Create(AOwner: TComponent);
begin
  inherited ;

  InitializeCriticalSection(lockDatabase) ;
end;

function TdmGINKOIA.CreateParam(AType, ACode, AMagID, APos, AInteger: integer;
  AFloat: double; AString, AInfo: string): Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;

      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := 'INSERT INTO GENPARAM (' + cRC +
                                'PRM_ID,' + cRC +
                                'PRM_CODE,' + cRC +
                                'PRM_INTEGER,' + cRC +
                                'PRM_FLOAT,' + cRC +
                                'PRM_STRING,' + cRC +
                                'PRM_TYPE,' + cRC +
                                'PRM_MAGID,' + cRC +
                                'PRM_INFO,' + cRC +
                                'PRM_POS' + cRC +
                              ') Values (' + cRC +
                                ':PPRMID,' + cRC +
                                ':PPRMCODE,' + cRC +
                                ':PPRMINTEGER,' + cRC +
                                ':PPRMFLOAT,' + cRC +
                                ':PPRMSTRING,' + cRC +
                                ':PPRMTYPE,' + cRC +
                                ':PPRMMAGID,' + cRC +
                                ':PPRMINFO,' + cRC +
                                ':PPRMPOS' + cRC +
                              ')';

      vQryGinkoia.ParamByName('PPRMID').AsInteger       := GetNewID('GENPARAM');;
      vQryGinkoia.ParamByName('PPRMCODE').AsInteger     := ACode;
      vQryGinkoia.ParamByName('PPRMINTEGER').AsInteger  := AInteger;
      vQryGinkoia.ParamByName('PPRMFLOAT').AsFloat      := AFloat;
      vQryGinkoia.ParamByName('PPRMSTRING').AsString    := AString;
      vQryGinkoia.ParamByName('PPRMTYPE').AsInteger     := AType;
      vQryGinkoia.ParamByName('PPRMMAGID').AsInteger    := AMagID;
      vQryGinkoia.ParamByName('PPRMINFO').AsString      := AInfo;
      vQryGinkoia.ParamByName('PPRMPOS').AsInteger      := APos;

      vQryGinkoia.ExecSQL;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;
end;

destructor TdmGINKOIA.Destroy;
begin
  DeleteCriticalSection(lockDatabase) ;

  inherited ;
end;

//------------------------------------------------------------------------------
// Gestion de la connexion à la base de données
//------------------------------------------------------------------------------

procedure TdmGINKOIA.connectToDatabase(aDatabase, aUsername, aPassword : string) ;
begin
    EnterCriticalSection(lockDatabase) ;
    try
      sDatabase := aDatabase ;
      sUsername := aUsername ;
      sPassword := aPassword ;

      connectToDatabase ;
    finally
      LeaveCriticalSection(lockDatabase) ;
    end;
end;

procedure TdmGINKOIA.connectToDatabase ;
begin
    if (sDatabase = '') then raise Exception.Create('Missing Database Name parameter') ;
    if (sUsername = '') then raise Exception.Create('Missing Database Username parameter') ;

    EnterCriticalSection(lockDatabase) ;
    try
      CNX_GINKOIA.Close ;

      CNX_GINKOIA.Params.Clear;
      CNX_GINKOIA.Params.Add('Database=' + sDatabase);
      CNX_GINKOIA.Params.Add('User_Name=' + sUsername);
      CNX_GINKOIA.Params.Add('Password=' + sPassword);
      CNX_GINKOIA.Params.Add('Protocol=TCPIP');
      CNX_GINKOIA.Params.Add('Server=localhost');
      CNX_GINKOIA.Params.Add('Port=3050');
      CNX_GINKOIA.Params.Add('DriverID=IB');

      CNX_GINKOIA.Transaction := Transaction ;
      CNX_GINKOIA.Open;
    finally
      LeaveCriticalSection(lockDatabase) ;
    end;
end;

function TdmGINKOIA.checkDatabaseConnexion: boolean ;
begin
  Result := true ;
  try
    EnterCriticalSection(lockDatabase) ;
    try
      if CNX_GINKOIA.Connected = false then
      begin
          connectToDatabase ;
      end;
    finally
      LeaveCriticalSection(lockDatabase) ;
    end;
  except
    Result := false ;
  end;
end;

//------------------------------------------------------------------------------
//  Appel des procedures stoquées
//------------------------------------------------------------------------------

function TdmGINKOIA.GetNewID(const ATableName: String): integer;
begin
  STP_NEWK.Close;
  STP_NEWK.ParamByName('TABLENAME').AsString:= UpperCase(ATableName);
  STP_NEWK.ExecProc;
  Result:= STP_NEWK.ParamByName('ID').AsInteger;
end;

function TdmGINKOIA.GetNewQry(const AOwner: TComponent): TFDQuery;
begin
  Result:= TFDQuery.Create(AOwner);
  Result.Connection := CNX_GINKOIA;
end;

function TdmGINKOIA.PR_GRPASSOCIEMAG(const AMAGA_ID: integer;
  const AUGG_NOM: String; const AUGM_DATE: TDateTime): integer;
begin
  STP_GRPASSOCIEMAG.Close;
  STP_GRPASSOCIEMAG.ParamByName('MAGA_ID').AsInteger:= AMAGA_ID;
  STP_GRPASSOCIEMAG.ParamByName('UGG_NOM').AsString:= AUGG_NOM;
  STP_GRPASSOCIEMAG.ParamByName('UGM_DATE').AsDateTime:= AUGM_DATE;
  STP_GRPASSOCIEMAG.ExecProc;
  Result:= STP_GRPASSOCIEMAG.ParamByName('UGMID').AsInteger;
end;

function TdmGINKOIA.SetParam(AInteger: integer; AFloat: double; AString: string;
  AId: integer):Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;

      UpdateK(AId, 0);

      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := 'UPDATE GENPARAM SET' + cRC +
                                'PRM_INTEGER=:PPRMINTEGER,' + cRC +
                                'PRM_FLOAT=:PPRMFLOAT,' + cRC +
                                'PRM_STRING=:PPRMSTRING' + cRC +
                              'WHERE PRM_ID = :PPRMID';

      vQryGinkoia.ParamByName('PPRMINTEGER').AsInteger  := AInteger;
      vQryGinkoia.ParamByName('PPRMFLOAT').AsFloat      := AFloat;
      vQryGinkoia.ParamByName('PPRMSTRING').AsString    := AString;
      vQryGinkoia.ParamByName('PPRMID').AsInteger       := AId;
      vQryGinkoia.ExecSQL;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;
end;

function TdmGINKOIA.SetParamFloat(AId: integer; AValue: double):Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;

      UpdateK(AId, 0);

      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := 'UPDATE GENPARAM SET' + cRC +
                                'PRM_FLOAT=:PPRMFLOAT' + cRC +
                              'WHERE PRM_ID = :PPRMID';

      vQryGinkoia.ParamByName('PPRMFLOAT').AsFloat      := AValue;
      vQryGinkoia.ParamByName('PPRMID').AsInteger       := AId;
      vQryGinkoia.ExecSQL;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;
end;

function TdmGINKOIA.SetParamInteger(AId, AValue: integer):Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;

      UpdateK(AId, cPrUpdateK_Mvt);

      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := 'UPDATE GENPARAM SET' + cRC +
                                'PRM_INTEGER=:PPRMINTEGER' + cRC +
                              'WHERE PRM_ID = :PPRMID';

      vQryGinkoia.ParamByName('PPRMINTEGER').AsInteger  := AValue;
      vQryGinkoia.ParamByName('PPRMID').AsInteger       := AId;
      vQryGinkoia.ExecSQL;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;
end;

function TdmGINKOIA.SetParamString(AId: integer; AValue: string):Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;

      UpdateK(AId, 0);

      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := 'UPDATE GENPARAM SET' + cRC +
                                'PRM_STRING=:PPRMSTRING' + cRC +
                              'WHERE PRM_ID = :PPRMID';

      vQryGinkoia.ParamByName('PPRMSTRING').AsString    := AValue;
      vQryGinkoia.ParamByName('PPRMID').AsInteger       := AId;
      vQryGinkoia.ExecSQL;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;
end;

procedure TdmGINKOIA.UpdateK(const K_ID, Suppression: integer);
var
  iKENABLED : Integer;
begin
  try
    iKENABLED := Suppression;
    //SR - 06/02/2017 - Contrôle Réactiver un K ou juste mouvementer.
    if iKENABLED = 0 then
    begin
      QUE_KENABLED.Close;
      QUE_KENABLED.ParamByName('PKID').AsInteger := K_ID;
      QUE_KENABLED.Open;
      if QUE_KENABLED.FieldByName('K_ENABLED').AsInteger = 0 then
        iKENABLED := 2;
    end;
    STP_UPDATEK.ParamByName('K_ID').AsInteger:= K_ID;
    STP_UPDATEK.ParamByName('Supression').AsInteger:= iKENABLED;
    STP_UPDATEK.ExecProc;
  except
    Raise;
  end;
end;

function TdmGINKOIA.GetParam(var IOInteger: integer; var IOFloat: double;
  var IOString: string; var IOId: Integer; AType, ACode, ABasID: integer): Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;
      // Récupération d'un paramètre
      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := cSql_S_GENPARAM;

      vQryGinkoia.ParamByName('PPRMTYPE').AsInteger  := AType;
      vQryGinkoia.ParamByName('PPRMCODE').AsInteger  := ACode;
      vQryGinkoia.ParamByName('PPRMPOS').AsInteger := ABasID;
      vQryGinkoia.Open;

      IOId      := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
      IOInteger := vQryGinkoia.FieldByName('PRM_INTEGER').AsInteger;
      IOFloat   := vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat;
      IOString  := vQryGinkoia.FieldByName('PRM_STRING').AsString;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;
end;

function TdmGINKOIA.GetParamByMag(var IOInteger: integer; var IOFloat: double;
  var IOString: string; var IOId: Integer; AType, ACode, AMagID: integer): Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;
      // Récupération d'un paramètre
      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := cSql_S_GENPARAM_BY_MAG;

      vQryGinkoia.ParamByName('PPRMTYPE').AsInteger  := AType;
      vQryGinkoia.ParamByName('PPRMCODE').AsInteger  := ACode;
      vQryGinkoia.ParamByName('PPRMMAGID').AsInteger := AMagID;
      vQryGinkoia.Open;

      IOId      := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
      IOInteger := vQryGinkoia.FieldByName('PRM_INTEGER').AsInteger;
      IOFloat   := vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat;
      IOString  := vQryGinkoia.FieldByName('PRM_STRING').AsString;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;
end;

function TdmGINKOIA.GetParamByMag_SS_KENABLED(var IOInteger: Integer;
  var IOFloat: Double; var IOString: string;  var IOId: Integer;
  var IOKEnabled: Integer; AType, ACode, AMagID: Integer): Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;
      // Récupération d'un paramètre
      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := cSql_S_GENPARAM_BY_MAG_SS_KENABLED;

      vQryGinkoia.ParamByName('PPRMTYPE').AsInteger  := AType;
      vQryGinkoia.ParamByName('PPRMCODE').AsInteger  := ACode;
      vQryGinkoia.ParamByName('PPRMMAGID').AsInteger := AMagID;
      vQryGinkoia.Open;
      vQryGinkoia.First;

      IOId        := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
      IOInteger   := vQryGinkoia.FieldByName('PRM_INTEGER').AsInteger;
      IOFloat     := vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat;
      IOString    := vQryGinkoia.FieldByName('PRM_STRING').AsString;
      IOKEnabled  := vQryGinkoia.FieldByName('K_ENABLED').AsInteger;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;

end;

function TdmGINKOIA.GetParamString(AType, ACode, ABasID: integer): string;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
begin
  Result := '';
  IF GetParam(AInt, AFloat, AStr, AId, AType, ACode, ABasID) then
  begin
    Result := AStr;
  end;
end;

function TdmGINKOIA.GetParamStringByMag(AType, ACode, AMagID: integer): string;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
begin
  Result := '';
  IF GetParamByMag(AInt, AFloat, AStr, AId, AType, ACode, AMagID) then
  begin
    Result := AStr;
  end;
end;

function TdmGINKOIA.GetParamStringByMag_SS_KENABLED(AType, ACode,
  AMagID: Integer): string;
var
  AStr      : string;
  AInt      : integer;
  AFloat    : double;
  AId       : Integer;
  AKEnabled : Integer;
begin
  Result := '';
  IF GetParamByMag_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, AMagID) then
  begin
    Result := AStr;
  end;
end;

function TdmGINKOIA.GetParamString_SS_KENABLED(AType, ACode,
  ABasID: integer): string;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := '';
  IF GetParam_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, ABasID) then
  begin
    Result := AStr;
  end;
end;

function TdmGINKOIA.GetParam_SS_KENABLED(var IOInteger: Integer;
  var IOFloat: Double; var IOString: string; var IOId, IOKEnabled: Integer;
  AType, ACode, APos: Integer): Boolean;
var
  vQryGinkoia : TFDQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;
      // Récupération d'un paramètre
      vQryGinkoia.Close;
      vQryGinkoia.SQL.Text := cSql_S_GENPARAM_SS_KENABLED;

      vQryGinkoia.ParamByName('PPRMTYPE').AsInteger  := AType;
      vQryGinkoia.ParamByName('PPRMCODE').AsInteger  := ACode;
      vQryGinkoia.ParamByName('PPRMPOS').AsInteger := APos;
      vQryGinkoia.Open;
      vQryGinkoia.First;
      IOId        := vQryGinkoia.FieldByName('PRM_ID').AsInteger;
      IOInteger   := vQryGinkoia.FieldByName('PRM_INTEGER').AsInteger;
      IOFloat     := vQryGinkoia.FieldByName('PRM_FLOAT').AsFloat;
      IOString    := vQryGinkoia.FieldByName('PRM_STRING').AsString;
      IOKEnabled  := vQryGinkoia.FieldByName('K_ENABLED').AsInteger;
    Except
      Result    := False;
    END;
  finally
    vQryGinkoia.Close;
    FreeAndNil(vQryGinkoia);
  end;
end;

function TdmGINKOIA.GetParamFloat(AType, ACode, ABasID: integer): double;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
begin
  Result := 0;
  IF GetParam(AInt, AFloat, AStr, AId, AType, ACode, ABasID) then
  begin
    Result := AFloat;
  end;
end;

function TdmGINKOIA.GetParamFloatByMag(AType, ACode, AMagID: integer): double;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
begin
  Result := 0;
  IF GetParamByMag(AInt, AFloat, AStr, Aid, AType, ACode, AMagID) then
  begin
    Result := AFloat;
  end;
end;

function TdmGINKOIA.GetParamFloatByMag_SS_KENABLED(AType, ACode,
  AMagID: Integer): Double;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := 0;
  IF GetParamByMag_SS_KENABLED(AInt, AFloat, AStr, Aid, AKEnabled, AType, ACode, AMagID) then
  begin
    Result := AFloat;
  end;
end;

function TdmGINKOIA.GetParamFloat_SS_KENABLED(AType, ACode,
  ABasID: integer): Double;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := 0;
  IF GetParam_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, ABasID) then
  begin
    Result := AFloat;
  end;

end;

function TdmGINKOIA.GetParamID(AType, ACode, ABasID: integer): Integer;
var
  AStr  : string;
  AInt  : Integer;
  AFloat: Double;
  AId   : Integer;
begin
  Result := 0;
  IF GetParam(AInt, AFloat, AStr, AId, AType, ACode, ABasID) then
  begin
    Result := AId;
  end;
end;

function TdmGINKOIA.GetParamIDByMag(AType, ACode, AMagID: integer): Integer;
var
  AStr  : string;
  AInt  : Integer;
  AFloat: Double;
  AId   : Integer;
begin
  Result := 0;
  IF GetParamByMag(AInt, AFloat, AStr, AId, AType, ACode, AMagID) then
  begin
    Result := AId;
  end;
end;

function TdmGINKOIA.GetParamIDByMag_SS_KENABLED(AType, ACode,
  AMagID: integer): Integer;
var
  AStr  : string;
  AInt  : Integer;
  AFloat: Double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := 0;
  IF GetParamByMag_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, AMagID) then
  begin
    Result := AId;
  end;
end;

function TdmGINKOIA.GetParamID_SS_KENABLED(AType, ACode,
  ABasID: integer): Integer;
var
  AStr  : string;
  AInt  : Integer;
  AFloat: Double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := 0;
  IF GetParam_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, ABasID) then
  begin
    Result := AId;
  end;
end;

function TdmGINKOIA.GetParamInteger(AType, ACode, ABasID: integer): integer;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
begin
  Result := 0;
  IF GetParam(AInt, AFloat, AStr, AId, AType, ACode, ABasID) then
  begin
    Result := AInt;
  end;
end;

function TdmGINKOIA.GetParamIntegerByMag(AType, ACode, AMagID: integer): integer;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
begin
  Result := 0;
  IF GetParamByMag(AInt, AFloat, AStr, AId, AType, ACode, AMagID) then
  begin
    Result := AInt;
  end;
end;
function TdmGINKOIA.GetParamIntegerByMag_SS_KENABLED(AType, ACode,
  AMagID: Integer): Integer;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := 0;
  IF GetParamByMag_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, AMagID) then
  begin
    Result := AInt;
  end;
end;

function TdmGINKOIA.GetParamInteger_SS_KENABLED(AType, ACode,
  ABasID: integer): Integer;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := 0;
  IF GetParam_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, ABasID) then
  begin
    Result := AInt;
  end;
end;

function TdmGINKOIA.GetParamKEnabledByMag_SS_KENABLED(AType, ACode,
  AMagID: Integer): Integer;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := 0;
  IF GetParamByMag_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, AMagID) then
  begin
    Result := AKEnabled;
  end;
end;

function TdmGINKOIA.GetParamKEnabled_SS_KENABLED(AType, ACode,
  ABasID: integer): Integer;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
  AId   : Integer;
  AKEnabled : Integer;
begin
  Result := 0;
  IF GetParam_SS_KENABLED(AInt, AFloat, AStr, AId, AKEnabled, AType, ACode, ABasID) then
  begin
    Result := AKEnabled;
  end;
end;

//------------------------------------------------------------------------------
end.


