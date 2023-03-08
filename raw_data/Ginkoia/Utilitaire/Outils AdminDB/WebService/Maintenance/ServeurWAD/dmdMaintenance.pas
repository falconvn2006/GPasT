unit dmdMaintenance;

interface

uses
  SysUtils, Classes, FMTBcd, WideStrings, DB, SqlExpr, Variants,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  //Uses Perso
  uSql,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TdmMaintenance = class(TDataModule)
    STP_NOUVELID: TFDStoredProc;
    CNX_MAINTENANCE: TFDConnection;
    Transaction: TFDTransaction;

  private
  public
    function GetNewQry(Const AOwner: TComponent = nil): TFDQuery;
    function GetNewStoredProc(Const AStoredProcName: String; Const AListParamValue: String = '';
                              Const AOwner: TComponent = nil): TFDStoredProc;
    procedure LoadParamsToQuery(Const AQuery: TFDQuery; Const ASQl: String;
                                Const AListParamValue: String = '');
    function GetNewID(Const ATableName: String): integer;

    { Paramètre Maintenance }
    function GetMaintenanceParamInteger(ACode, AType: Integer):Integer;
    function SetMaintenanceParamInteger(ACode, AType, AInteger: Integer):Boolean;
    function GetMaintenanceParamFloat(ACode, AType: Integer):Double;
    function SetMaintenanceParamFloat(ACode, AType: Integer; AFloat: Double):Boolean;
    function GetMaintenanceParamString(ACode, AType: Integer):string;
    function SetMaintenanceParamString(ACode, AType: Integer; AString: string):Boolean;
    function VersionStringToInt(aVersionString: string): integer;
  end;

var
  dmMaintenance: TdmMaintenance;

implementation

{$R *.dfm}

{ TdmMaintenance }

function TdmMaintenance.GetMaintenanceParamInteger(ACode,
  AType: Integer): Integer;
var
  vQry: TFDQuery;
begin
  Result := -1;
  try
    vQry:= dmMaintenance.GetNewQry;
    vQry.SQL.Text:= 'SELECT PMAI_INTEGER FROM MAINTENANCE_PARAM WHERE PMAI_CODE = :PPMAICODE AND PMAI_TYPE = :PPMAITYPE';
    vQry.ParamByName('PPMAICODE').AsInteger:= ACode;
    vQry.ParamByName('PPMAITYPE').AsInteger:= AType;
    vQry.Open;

    if not vQry.Eof then
      Result := vQry.FieldByName('PMAI_INTEGER').AsInteger;

  finally
    FreeAndNil(vQry);
  end;
end;

function TdmMaintenance.VersionStringToInt(aVersionString: string): integer;
begin
  try
    if aVersionString <> '' then
    begin
      aVersionString := aVersionString.Substring(0, AnsiPos('.', aVersionString) - 1);

      if not(TryStrToInt(aVersionString, Result)) then
        Result := 0;
    end
    else
      Result := 0;
  except
    Result := 0;
  end;
end;

function TdmMaintenance.GetMaintenanceParamString(ACode,
  AType: Integer): string;
var
  vQry: TFDQuery;
begin
  Result := '';
  try
    vQry:= dmMaintenance.GetNewQry;
    vQry.SQL.Text:= cSql_S_Maintenance_Param;
    vQry.ParamByName('PPMAICODE').AsInteger:= ACode;
    vQry.ParamByName('PPMAITYPE').AsInteger:= AType;
    vQry.Open;

    if not vQry.Eof then
      Result := vQry.FieldByName('PMAI_STRING').AsString;

  finally
    FreeAndNil(vQry);
  end;
end;

function TdmMaintenance.SetMaintenanceParamFloat(ACode, AType: Integer;
  AFloat: Double): Boolean;
var
  vQry: TFDQuery;
begin
  Result := False;
  vQry:= dmMaintenance.GetNewQry;
  try
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;

      vQry.SQL.Text:= cSql_U_Maintenance_Param_Float;
      vQry.ParamByName('PPMAICODE').AsInteger:= ACode;
      vQry.ParamByName('PPMAITYPE').AsInteger:= AType;
      vQry.ParamByName('PPMAIFLOAT').AsFloat:= AFloat;
      vQry.ExecSQL;

      dmMaintenance.Transaction.Commit;
      Result := True;
    except
      on E: Exception do
        begin
          dmMaintenance.Transaction.Rollback;
          Raise Exception.Create(ClassName + '.SetMaintenanceParamFloat : ' + E.Message);
        end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TdmMaintenance.SetMaintenanceParamInteger(ACode, AType,
  AInteger: Integer): Boolean;
var
  vQry: TFDQuery;
begin
  Result := False;
  vQry:= dmMaintenance.GetNewQry;
  try
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;

      vQry.SQL.Text:= cSql_U_Maintenance_Param_Integer;
      vQry.ParamByName('PPMAICODE').AsInteger:= ACode;
      vQry.ParamByName('PPMAITYPE').AsInteger:= AType;
      vQry.ParamByName('PPMAIINTEGER').AsInteger:= AInteger;
      vQry.ExecSQL;

      dmMaintenance.Transaction.Commit;
      Result := True;
    except
      on E: Exception do
        begin
          dmMaintenance.Transaction.Rollback;
          Raise Exception.Create(ClassName + '.SetMaintenanceParamInteger : ' + E.Message);
        end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TdmMaintenance.SetMaintenanceParamString(ACode, AType: Integer;
  AString: string): Boolean;
var
  vQry: TFDQuery;
begin
  Result := False;

  if Length(AString) > 255 then   //Si la taille de la chaine dépasse on sort
    Exit;

  vQry:= dmMaintenance.GetNewQry;
  try
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;

      vQry.SQL.Text:= cSql_U_Maintenance_Param_String;
      vQry.ParamByName('PPMAICODE').AsInteger:= ACode;
      vQry.ParamByName('PPMAITYPE').AsInteger:= AType;
      vQry.ParamByName('PPMAISTRING').AsString:= AString;
      vQry.ExecSQL;

      dmMaintenance.Transaction.Commit;
      Result := True;
    except
      on E: Exception do
        begin
          dmMaintenance.Transaction.Rollback;
          Raise Exception.Create(ClassName + '.SetMaintenanceParamString : ' + E.Message);
        end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

function TdmMaintenance.GetMaintenanceParamFloat(ACode,
  AType: Integer): Double;
var
  vQry: TFDQuery;
begin
  Result := -1;
  try
    vQry:= dmMaintenance.GetNewQry;
    vQry.SQL.Text:= cSql_S_Maintenance_Param;
    vQry.ParamByName('PPMAICODE').AsInteger:= ACode;
    vQry.ParamByName('PPMAITYPE').AsInteger:= AType;
    vQry.Open;

    if not vQry.Eof then
      Result := vQry.FieldByName('PMAI_FLOAT').AsFloat;

  finally
    FreeAndNil(vQry);
  end;
end;

function TdmMaintenance.GetNewID(const ATableName: String): integer;
begin
  STP_NOUVELID.Close;
  STP_NOUVELID.ParamByName('NOM_GENERATEUR').AsString:= UpperCase(ATableName);
  STP_NOUVELID.ExecProc;
  Result:= STP_NOUVELID.ParamByName('ID').AsInteger;
end;

function TdmMaintenance.GetNewQry(Const AOwner: TComponent): TFDQuery;
begin
  if not dmMaintenance.Transaction.Active then
    dmMaintenance.Transaction.StartTransaction;
  Result:= TFDQuery.Create(AOwner);
  Result.Connection:= CNX_MAINTENANCE;
end;

function TdmMaintenance.GetNewStoredProc(const AStoredProcName: String;
  Const AListParamValue: String; const AOwner: TComponent): TFDStoredProc;
var
  i: integer;
  vSL: TStringList;
begin
  Result:= TFDStoredProc.Create(AOwner);
  Result.Connection:= CNX_MAINTENANCE;
  Result.StoredProcName:= AStoredProcName;
  Result.Active:= True;
  if AListParamValue <> '' then
    begin
      vSL:= TStringList.Create;
      try
        vSL.Text:= AListParamValue;
        for i:= 0 to vSL.Count - 1 do
          Result.Params.Items[i].Value:= vSL.Strings[i];
      finally
        FreeAndNil(vSL);
      end;
    end;
end;

procedure TdmMaintenance.LoadParamsToQuery(const AQuery: TFDQuery; const ASQl,
  AListParamValue: String);
var
  i: integer;
  vSL: TStringList;
begin
  AQuery.SQL.Text:= ASQl;
  if AListParamValue <> '' then
    begin
      vSL:= TStringList.Create;
      try
        vSL.Text:= AListParamValue;
        for i:= 0 to vSL.Count - 1 do
          AQuery.Params.Items[i].Value:= vSL.Strings[i];
      finally
        FreeAndNil(vSL);
      end;
    end;
end;

end.
