unit UBdd;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Comp.Script,
  vcl.forms, System.Classes, System.Generics.Collections,System.SysUtils,
  Datasnap.DBClient, System.StrUtils, System.IOUtils;

type
  TBdd = class(TObject)
    private
    protected
      FConnection   : TFDConnection;
      FBase         : string;
      FTable        : string;
      FQuery        : TFDQuery;
      FTrigramme    : string;
      FIndexList    : TStringList;
      FFieldList    : TStringList;
      procedure SetBase(pCheminBase: string);
      function FormatData(pData: string; pType: integer): string;
      procedure SetTable(pTable: string);
      procedure GetIndexList;
      function GetFieldList: string;
    public
      constructor Create(pCheminBase: string); reintroduce;
      destructor Destroy; reintroduce;
      procedure Connect;
      procedure Disconnect;
      property IndexList: TStringList read FIndexList;
      property FieldList: TStringList read FFieldList;
      property Base: string read FBase write SetBase;
      property Table: string read FTable write SetTable;
      property Trigramme: string read FTrigramme;
  end;

implementation

{ TBdd }

procedure TBdd.Connect;
begin
  FConnection.Open;
end;

constructor TBdd.Create(pCheminBase: string);
begin
  FConnection := TFDConnection.Create(nil);
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
  SetBase(pCheminBase);
  FFieldList := TStringList.Create;
  FIndexList := TStringList.Create;
end;

destructor TBdd.Destroy;
begin
  FQuery.Free;
  Disconnect;
  FConnection.Free;
  FIndexList.Free;
  FFieldList.Free;
  inherited Destroy;
end;

procedure TBdd.Disconnect;
begin
  FConnection.Close;
end;

function TBdd.FormatData(pData: string; pType: integer): string;
begin
  case pType of
    8:  // INTEGER
      Result := pData;
    10, 16: // FLOAT / NUMERIC (INT64)
      Result := ReplaceStr(pData,',','.');
    37: // VARCHAR
      Result := pdata.DeQuotedString.QuotedString;
    35: // TIMESTAMP
      Result := QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',StrToDateTime(pData)));
  end;
end;

function TBdd.GetFieldList: string;
var
  lQuery    : TFDQuery;
  lBclQuery : integer;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FConnection;
    lQuery.SQL.Add('SELECT R.RDB$FIELD_NAME, F.RDB$FIELD_TYPE');
    lQuery.SQL.Add('FROM RDB$RELATION_FIELDS R LEFT JOIN RDB$FIELDS F ON R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME');
    lQuery.SQL.Add('WHERE RDB$RELATION_NAME = '+QuotedStr(FTable));
    lQuery.SQL.Add('ORDER BY r.RDB$FIELD_POSITION');
    lQuery.Open;
    lQuery.FetchAll;
    //on retourne le trigramme
    Result := LeftStr(lQuery.FieldByName('RDB$FIELD_NAME').AsString,4);
    FFieldList.Clear;
    for lBclQuery := 0 to lQuery.RecordCount -1 do
    begin
      FFieldList.Add(lQuery.FieldByName('RDB$FIELD_NAME').AsString+'='+lQuery.FieldByName('RDB$FIELD_TYPE').AsString);
      lQuery.Next;
    end;
  finally
  lQuery.Free;
  end;

end;

procedure TBdd.GetIndexList;
var
  lQuery    : TFDQuery;
  lBclQuery : integer;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FConnection;
    lQuery.SQL.Add('SELECT ISE.RDB$FIELD_NAME FIELD_NAME, (RF.RDB$FIELD_POSITION ) FIELD_POSITION');
    lQuery.SQL.Add('FROM RDB$INDEX_SEGMENTS ISE');
    lQuery.SQL.Add('LEFT JOIN RDB$INDICES I ON I.RDB$INDEX_NAME = ISE.RDB$INDEX_NAME');
    lQuery.SQL.Add('LEFT JOIN RDB$RELATION_FIELDS RF ON RF.RDB$FIELD_NAME = ISE.RDB$FIELD_NAME');
    lQuery.SQL.Add('WHERE I.RDB$RELATION_NAME='+QuotedStr(FTable));
    lQuery.Open;
    lQuery.FetchAll;
    FIndexList.Clear;
    for lBclQuery := 0 to lQuery.RecordCount -1 do
    begin
      FIndexList.Add(lQuery.FieldByName('FIELD_NAME').AsString+'='+IntToStr(lQuery.FieldByName('FIELD_POSITION').AsInteger));
      lQuery.Next;
    end;
  finally
    lQuery.Free;
  end;
end;

procedure TBdd.SetBase(pCheminBase: string);
begin
  FConnection.Close;;
  FBase := pCheminBase;
  FConnection.ConnectionString := 'DriverID=IB;Database='+FBase+';User_Name=SYSDBA;Password=masterkey;'
                                    +'InstanceName=gds_db';
end;

procedure TBdd.SetTable(pTable: string);
begin
  FTable := pTable;
  if FTable = '' then
  begin
    FIndexList.Clear;
    FFieldList.Clear;
    FTrigramme := '';
  end
  else
  begin
    FTrigramme := GetFieldList;
    GetIndexList;
  end;
end;

end.
