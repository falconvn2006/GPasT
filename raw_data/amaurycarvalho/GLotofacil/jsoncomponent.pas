unit JsonComponent;

{$mode objfpc}{$H+}
{
       Adaptado por Amaury Carvalho (amauryspires@gmail.com), 2023
       Original: https://forum.lazarus.freepascal.org/index.php?topic=31147.0
}

interface

uses Classes, typinfo, SysUtils, jsonscanner, fpjson, fpjsonrtti;

type
  TJsonComponent = class(TComponent)
  protected
    procedure propertyError(Sender: TObject; AObject: TObject;
      Info: PPropInfo; AValue: TJSONData; Error: Exception;
      var doContinue: boolean); virtual;
    procedure restoreProperty(Sender: TObject; AObject: TObject;
      Info: PPropInfo; AValue: TJSONData; var Handled: boolean); virtual;
  public
    procedure LoadFromFile(const aFilename: string); virtual;
    procedure SaveToFile(const aFilename: string); virtual;
    procedure LoadFromStream(aStream: TStream);
    procedure SaveToStream(aStream: TStream);
  end;

implementation

procedure TJsonComponent.restoreProperty(Sender: TObject; AObject: TObject;
  Info: PPropInfo; AValue: TJSONData; var Handled: boolean);
begin
end;

procedure TJsonComponent.propertyError(Sender: TObject; AObject: TObject;
  Info: PPropInfo; AValue: TJSONData; Error: Exception; var doContinue: boolean);
begin
end;

procedure TJsonComponent.LoadFromStream(aStream: TStream);
var
  json_str: TJSONDeStreamer;
  json_dat: TJSONStringType;
begin
  json_str := TJSONDeStreamer.Create(nil);
  try
    aStream.Position := 0;
    json_str.OnPropertyError := @propertyError;
    json_str.OnRestoreProperty := @restoreProperty;
    setLength(json_dat, aStream.Size);
    aStream.Read(json_dat[1], length(json_dat));
    json_str.JSONToObject(json_dat, self);
  finally
    json_str.Free;
  end;
end;

procedure TJsonComponent.SaveToStream(aStream: TStream);
var
  json_str: TJSONStreamer;
  json_dat: TJSONStringType;
begin
  json_str := TJSONStreamer.Create(nil);
  try
    json_dat := json_str.ObjectToJSONString(self);
    aStream.Write(json_dat[1], length(json_dat));
  finally
    json_str.Free;
  end;
end;

procedure TJsonComponent.LoadFromFile(const aFilename: string);
var
  str: TMemoryStream;
begin
  str := TMemoryStream.Create;
  try
    str.LoadFromFile(aFilename);
    LoadFromStream(str);
  finally
    str.Free;
  end;
end;

procedure TJsonComponent.SaveToFile(const aFilename: string);
var
  str: TMemoryStream;
begin
  str := TMemoryStream.Create;
  try
    SaveToStream(str);
    str.SaveToFile(aFilename);
  finally
    str.Free;
  end;
end;


end.
