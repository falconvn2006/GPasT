//
// Créé par le générateur de proxy DataSnap.
// 30/04/2014 14:54:05
// 

unit uServeurTools;

interface

uses DBXCommon, DBXClient, DBXJSON, DSProxy, Classes, SysUtils, DB, SqlExpr, DBXDBReaders, uConst, DBClient, DBXJSONReflect;

type
  TGinkoiaToolsClient = class(TDSAdminClient)
  private
    FDeleteDossierCommand: TDBXCommand;
    FGetDossierCommand: TDBXCommand;
    FSetDossierCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function DeleteDossier(aDOSS_ID: Integer): TErreurGinkoiaTools;
    function GetDossier(aDOSS_ID: Integer; aCDS: TClientDataSet): TErreurGinkoiaTools;
    function SetDossier(aDos: TClientDataSet): TErreurGinkoiaTools;
  end;

implementation{>>GpProfile U} uses GpProf; {GpProfile U>>}

function TGinkoiaToolsClient.DeleteDossier(aDOSS_ID: Integer): TErreurGinkoiaTools;
begin{>>GpProfile} ProfilerEnterProc(391); try {GpProfile>>}
  if FDeleteDossierCommand = nil then
  begin
    FDeleteDossierCommand := FDBXConnection.CreateCommand;
    FDeleteDossierCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FDeleteDossierCommand.Text := 'TGinkoiaTools.DeleteDossier';
    FDeleteDossierCommand.Prepare;
  end;
  FDeleteDossierCommand.Parameters[0].Value.SetInt32(aDOSS_ID);
  FDeleteDossierCommand.ExecuteUpdate;
  if not FDeleteDossierCommand.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDBXClientCommand(FDeleteDossierCommand.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TErreurGinkoiaTools(FUnMarshal.UnMarshal(FDeleteDossierCommand.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FDeleteDossierCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
{>>GpProfile} finally ProfilerExitProc(391); end; {GpProfile>>}end;

function TGinkoiaToolsClient.GetDossier(aDOSS_ID: Integer; aCDS: TClientDataSet): TErreurGinkoiaTools;
var
  tmp : TJSONValue;
begin{>>GpProfile} ProfilerEnterProc(392); try {GpProfile>>}
  if FGetDossierCommand = nil then
  begin
    FGetDossierCommand := FDBXConnection.CreateCommand;
    FGetDossierCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetDossierCommand.Text := 'TGinkoiaTools.GetDossier';
    FGetDossierCommand.Prepare;
  end;
  FGetDossierCommand.Parameters[0].Value.SetInt32(aDOSS_ID);
  if not Assigned(aCDS) then
    FGetDossierCommand.Parameters[1].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FGetDossierCommand.Parameters[1].ConnectionHandler).GetJSONMarshaler;
    try
      tmp := FMarshal.Marshal(aCDS);
      FGetDossierCommand.Parameters[1].Value.SetJSONValue(tmp, True);
      if FInstanceOwner then
        aCDS.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FGetDossierCommand.ExecuteUpdate;
  if not FGetDossierCommand.Parameters[2].Value.IsNull then
  begin
    FUnMarshal := TDBXClientCommand(FGetDossierCommand.Parameters[2].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TErreurGinkoiaTools(FUnMarshal.UnMarshal(FGetDossierCommand.Parameters[2].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FGetDossierCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
{>>GpProfile} finally ProfilerExitProc(392); end; {GpProfile>>}end;

function TGinkoiaToolsClient.SetDossier(aDos: TClientDataSet): TErreurGinkoiaTools;
begin{>>GpProfile} ProfilerEnterProc(393); try {GpProfile>>}
  if FSetDossierCommand = nil then
  begin
    FSetDossierCommand := FDBXConnection.CreateCommand;
    FSetDossierCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FSetDossierCommand.Text := 'TGinkoiaTools.SetDossier';
    FSetDossierCommand.Prepare;
  end;
  if not Assigned(aDos) then
    FSetDossierCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FSetDossierCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FSetDossierCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(aDos), True);
      if FInstanceOwner then
        aDos.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FSetDossierCommand.ExecuteUpdate;
  if not FSetDossierCommand.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDBXClientCommand(FSetDossierCommand.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TErreurGinkoiaTools(FUnMarshal.UnMarshal(FSetDossierCommand.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FSetDossierCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
{>>GpProfile} finally ProfilerExitProc(393); end; {GpProfile>>}end;


constructor TGinkoiaToolsClient.Create(ADBXConnection: TDBXConnection);
begin{>>GpProfile} ProfilerEnterProc(394); try {GpProfile>>}
  inherited Create(ADBXConnection);
{>>GpProfile} finally ProfilerExitProc(394); end; {GpProfile>>}end;


constructor TGinkoiaToolsClient.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin{>>GpProfile} ProfilerEnterProc(395); try {GpProfile>>}
  inherited Create(ADBXConnection, AInstanceOwner);
{>>GpProfile} finally ProfilerExitProc(395); end; {GpProfile>>}end;


destructor TGinkoiaToolsClient.Destroy;
begin{>>GpProfile} ProfilerEnterProc(396); try {GpProfile>>}
  FreeAndNil(FDeleteDossierCommand);
  FreeAndNil(FGetDossierCommand);
  FreeAndNil(FSetDossierCommand);
  inherited;
{>>GpProfile} finally ProfilerExitProc(396); end; {GpProfile>>}end;

end.
