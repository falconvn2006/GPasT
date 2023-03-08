unit uWMSTransporteurFile;

interface

uses
  uFTPFiles, Classes, uLog;

type
  TWMSTransporteurFile = class(TCustomFTPGetFile)
  private
    function CodeExist(ACode: integer): boolean;
  protected
    function DoRead: TLogLevel; override;
    procedure DoUpdateBDD; override;

    function GetQueryText: string; override;
    function CheckFileEntete: boolean; override;
  public
  end;

implementation

uses
  SysUtils, uGenerique, uCustomFTPManager, uGestionBDD, uFTPUtils, uMonitoring;

{ TWMSTransporteurFile }

function TWMSTransporteurFile.CheckFileEntete: boolean;
//var
//  values: TStringList;
begin
  // On ne controle pas les entête du fichier SUIVI
  Result := True;

//  values := getFileLineValues(FStringList[0]);
//  Result := (values.Count = 2) and (values[0] = 'TRA_CODE') and (values[1] = 'TRA_NOM');
//
//  FreeAndNil(values);
end;

function TWMSTransporteurFile.CodeExist(ACode: integer): boolean;
var
  query: TMyQuery;
begin
  query := GetNewQuery;
  query.SQL.Text := 'SELECT TRA_ID FROM NEGTRANSPORT WHERE TRA_CODE = :TRACODE';
  query.Params.ParamByName('TRACODE').AsInteger := ACode;
  query.Open;

  Result := Not query.IsEmpty;

  query.Close;
  query.Free;
end;

function TWMSTransporteurFile.DoRead: TLogLevel;
var
  i: integer;
  values: TStringList;
begin
  Result := logNone;
  try
    for i := 0  to FStringList.Count - 1 do
    begin
      values := getFileLineValues(FStringList[i]);
      if CodeExist(StrToInt(values[0])) then
      begin
        AddLog(Format('le TRA_CODE "%s" (%s) existe déjà dans la table NEGTRANSPORT ',
          [values[0], values[1]]), ftpllError);
        Result := logWarning;
      end;
    end;
  finally
  end;
end;

procedure TWMSTransporteurFile.DoUpdateBDD;
var
  i: integer;
  values: TStringList;
begin
  LoadQuery;

  try
    for i := 0 to FStringList.Count - 1 do
    begin
      GetQuery.Close;

      values := getFileLineValues(FStringList[i]);
      if not CodeExist(StrToInt(values[0])) then
      begin
        GetQuery.Params.ParamByName('TRAID').AsInteger := NewK('NEGTRANSPORT');

        GetQuery.Params.ParamByName('TRACODE').AsInteger := StrToInt(values[0]);
        GetQuery.Params.ParamByName('TRANOM').AsString := values[1];

        GetQuery.ExecSQL;
      end;
    end;
  finally
    GetQuery.Close;
  end;
end;

function TWMSTransporteurFile.GetQueryText: string;
begin
  Result := 'INSERT INTO NEGTRANSPORT (TRA_ID, TRA_NOM, TRA_CODE) VALUES (:TRAID, :TRANOM, :TRACODE)';
end;

initialization

  TCustomFTPManager.RegisterKnownFile('WMS_TRANSPORTEUR', ftGet, '', '', TWMSTransporteurFile);

end.
