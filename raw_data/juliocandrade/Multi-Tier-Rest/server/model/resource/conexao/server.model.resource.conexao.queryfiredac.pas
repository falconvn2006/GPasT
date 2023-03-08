unit server.model.resource.conexao.queryfiredac;

interface
uses
  server.model.resource.interfaces,
  FireDAC.Comp.Client,
  System.Classes,
  Data.DB,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet;
type
  TQueryFiredac = class(TInterfacedObject, iQuery)
  private
    FQuery : TFDQuery;
    FParams : TParams;
    procedure PrepareArrayParams(aParams : TArray<TParams>);
  public
    constructor Create(aConexao : iConexao);
    destructor Destroy; override;
    class function New(aConexao : iConexao) : iQuery;
    function SQL : TStrings;
    function Params : TParams;
    function ExecSQL : iQuery;
    function ExecSQLArray(aParams : TArray<TParams>) : iQuery;
    function DataSet : TDataSet;
    function Open(aSQL : String) : iQuery; overload;
    function Open : iQuery; overload;
  end;
implementation

uses
  System.SysUtils,
  server.utils;

{ TQueryFiredac }

constructor TQueryFiredac.Create(aConexao: iConexao);
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TFDConnection(aConexao.Connect);
end;

function TQueryFiredac.DataSet: TDataSet;
begin
  Result := TDataSet(FQuery);
end;

destructor TQueryFiredac.Destroy;
begin
  FreeAndNil(FQuery);
  if Assigned(FParams) then
    FreeAndNil(FParams);
  inherited;
end;

function TQueryFiredac.ExecSQL: iQuery;
begin
  Result := Self;

  TServerUtils.SetEmptyParamsToNull(FParams);
  if Assigned(FParams) then
    FQuery.Params.assign(FParams);

  FQuery.Prepare;
  FQuery.ExecSQL;

  if Assigned(FParams) then
    FreeAndNil(FParams);
end;

function TQueryFiredac.ExecSQLArray(aParams: TArray<TParams>): iQuery;
begin
  Result := Self;
  PrepareArrayParams(aParams);
  FQuery.OptionsIntf.FormatOptions.StrsEmpty2Null := true;
  FQuery.Prepare;
  FQuery.Execute(Length(aParams), 0);
  if Assigned(FParams) then
    FreeAndNil(FParams);
end;

class function TQueryFiredac.New(aConexao: iConexao): iQuery;
begin
  Result := Self.Create(aConexao);
end;

function TQueryFiredac.Open(aSQL: String): iQuery;
begin
  Result := Self;
  TServerUtils.SetEmptyParamsToNull(FParams);
  FQuery.Close;
  FQuery.Open(aSQL);
end;

function TQueryFiredac.Open: iQuery;
begin
  Result := Self;
  TServerUtils.SetEmptyParamsToNull(FParams);
  FQuery.Close;
  if Assigned(FParams) then
    FQuery.Params.Assign(FParams);
  FQuery.Prepare;
  FQuery.Open;
  if Assigned(FParams) then
    FreeAndNil(FParams);
end;

function TQueryFiredac.Params: TParams;
begin
  if not Assigned(FParams) then
  begin
    FParams := TParams.Create(nil);
    FParams.Assign(FQuery.Params);
  end;
  Result := FParams;
end;

procedure TQueryFiredac.PrepareArrayParams(aParams: TArray<TParams>);
var
  CountParams : Integer;
  CountField : Integer;
begin
  FQuery.params.Assign(aParams[0]);
  FQuery.Params.ArraySize := Length(aParams);
  for CountParams := 0 to Pred(Length(aParams)) do
  begin
    for CountField := 0 to Pred(aParams[CountParams].Count) do
    begin
      case aParams[CountParams].Items[CountField].DataType of
        ftString,
        ftWideString :
          FQuery.ParamByName(aParams[CountParams].Items[CountField].Name).AsStrings[CountParams] := aParams[CountParams].Items[CountField].AsString;
        ftInteger :
          FQuery.ParamByName(aParams[CountParams].Items[CountField].Name).AsIntegers[CountParams] := aParams[CountParams].Items[CountField].AsInteger;
        ftLargeint :
          FQuery.ParamByName(aParams[CountParams].Items[CountField].Name).AsLargeInts[CountParams] := aParams[CountParams].Items[CountField].AsLargeInt;
        ftDate :
          FQuery.ParamByName(aParams[CountParams].Items[CountField].Name).AsDates[CountParams] := aParams[CountParams].Items[CountField].AsDate;
      end;
    end;
  end;
end;

function TQueryFiredac.SQL: TStrings;
begin
  Result := FQuery.SQL;
end;

end.
