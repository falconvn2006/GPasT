unit dmdGINKOIA;

interface

uses
  SysUtils, Windows, Classes, FMTBcd, WideStrings, SqlExpr, DB, IB_Components,
  IBODataset;

const
  cRC = #13#10;
  cSql_S_GENPARAM = 'SELECT' + cRC +
                      'PRM_INTEGER,' + cRC +
                      'PRM_FLOAT,' + cRC +
                      'PRM_STRING' + cRC +
                    'FROM GENPARAM' + cRC +
                      'JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)' + cRC +
                    'WHERE PRM_TYPE = :PPRMTYPE' + cRC +
                      'AND PRM_POS = :PPRMPOS' + cRC +
                      'AND PRM_CODE = :PPRMCODE';

  cSql_S_GENPARAM_BY_MAG = 'SELECT' + cRC +
                      'PRM_INTEGER,' + cRC +
                      'PRM_FLOAT,' + cRC +
                      'PRM_STRING' + cRC +
                    'FROM GENPARAM' + cRC +
                      'JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)' + cRC +
                    'WHERE PRM_TYPE = :PPRMTYPE' + cRC +
                      'AND PRM_MAGID = :PPRMMAGID' + cRC +
                      'AND PRM_CODE = :PPRMCODE';

type
  TdmGINKOIA = class(TDataModule)
    STP_UPDATEK: TIBOStoredProc;
    STP_NEWK: TIBOStoredProc;
    STP_INITIALISEMAG: TIBOStoredProc;
    CNX_GINKOIA: TIB_Connection;
    Transaction: TIB_Transaction;
    STP_GRPASSOCIEMAG: TIBOStoredProc;
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
    function GetNewQry(Const AOwner: TComponent = nil): TIBOQuery;
    function PR_GRPASSOCIEMAG(Const AMAGA_ID: integer; Const AUGG_NOM: String;
                              Const AUGM_DATE: TDateTime): integer;

    procedure UpdateK(Const K_ID, Suppression: integer);

    function GetParam(var IOInteger: integer; var IOFloat: double; var IOString: string; AType, ACode, ABasID: integer): Boolean;
    function GetParamString(AType, ACode, ABasID: integer): string;
    function GetParamFloat(AType, ACode, ABasID: integer): double;
    function GetParamInteger(AType, ACode, ABasID: integer): integer;

    function GetParamByMag(var IOInteger: integer; var IOFloat: double; var IOString: string; AType, ACode, AMagID: integer): Boolean;
    function GetParamStringByMag(AType, ACode, AMagID: integer): string;
    function GetParamFloatByMag(AType, ACode, AMagID: integer): double;
    function GetParamIntegerByMag(AType, ACode, AMagID: integer): integer;

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
      raise Exception.Create('Erreur lors de la connexion à la base [' + Result.CNX_GINKOIA.DatabaseName + '] avec le message : ' + E.Message) ;
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
  vQryGinkoia : TIBOQuery;
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
                                'PPRMID,' + cRC +
                                'PPRMCODE,' + cRC +
                                'PPRMINTEGER,' + cRC +
                                'PPRMFLOAT,' + cRC +
                                'PPRMSTRING,' + cRC +
                                'PPRMTYPE,' + cRC +
                                'PPRMMAGID,' + cRC +
                                'PPRMINFO,' + cRC +
                                'PPRMPOS' + cRC +
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
      CNX_GINKOIA.Disconnect ;

      CNX_GINKOIA.DatabaseName  := AnsiString(sDatabase);
      CNX_GINKOIA.Username      := AnsiString(sUsername);
      CNX_GINKOIA.Password      := AnsiString(sPassword);

      CNX_GINKOIA.DefaultTransaction := Transaction ;
      CNX_GINKOIA.Connect ;
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
      if CNX_GINKOIA.VerifyConnection = false then
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

function TdmGINKOIA.GetNewQry(const AOwner: TComponent): TIBOQuery;
begin
  Result:= TIBOQuery.Create(AOwner);
  Result.IB_Connection:= CNX_GINKOIA;
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
  vQryGinkoia : TIBOQuery;
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
  vQryGinkoia : TIBOQuery;
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
  vQryGinkoia : TIBOQuery;
begin
  Result := True;
  try
    try
      vQryGinkoia := GetNewQry;

      UpdateK(AId, 0);

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
  vQryGinkoia : TIBOQuery;
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
begin
  try
    STP_UPDATEK.ParamByName('K_ID').AsInteger:= K_ID;
    STP_UPDATEK.ParamByName('Supression').AsInteger:= Suppression;
    STP_UPDATEK.ExecProc;
  except
    Raise;
  end;
end;

function TdmGINKOIA.GetParam(var IOInteger: integer; var IOFloat: double; var IOString: string; AType, ACode, ABasID: integer): Boolean;
var
  vQryGinkoia : TIBOQuery;
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
  var IOString: string; AType, ACode, AMagID: integer): Boolean;
var
  vQryGinkoia : TIBOQuery;
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

function TdmGINKOIA.GetParamString(AType, ACode, ABasID: integer): string;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
begin
  Result := '';
  IF GetParam(AInt, AFloat, AStr, AType, ACode, ABasID) then
  begin
    Result := AStr;
  end;
end;

function TdmGINKOIA.GetParamStringByMag(AType, ACode, AMagID: integer): string;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
begin
  Result := '';
  IF GetParam(AInt, AFloat, AStr, AType, ACode, AMagID) then
  begin
    Result := AStr;
  end;
end;

function TdmGINKOIA.GetParamFloat(AType, ACode, ABasID: integer): double;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
begin
  Result := 0;
  IF GetParam(AInt, AFloat, AStr, AType, ACode, ABasID) then
  begin
    Result := AFloat;
  end;
end;

function TdmGINKOIA.GetParamFloatByMag(AType, ACode, AMagID: integer): double;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
begin
  Result := 0;
  IF GetParam(AInt, AFloat, AStr, AType, ACode, AMagID) then
  begin
    Result := AFloat;
  end;
end;

function TdmGINKOIA.GetParamInteger(AType, ACode, ABasID: integer): integer;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
begin
  Result := 0;
  IF GetParam(AInt, AFloat, AStr, AType, ACode, ABasID) then
  begin
    Result := AInt;
  end;
end;

function TdmGINKOIA.GetParamIntegerByMag(AType, ACode, AMagID: integer): integer;
var
  AStr  : string;
  AInt  : integer;
  AFloat: double;
begin
  Result := 0;
  IF GetParam(AInt, AFloat, AStr, AType, ACode, AMagID) then
  begin
    Result := AInt;
  end;
end;
//------------------------------------------------------------------------------
end.
