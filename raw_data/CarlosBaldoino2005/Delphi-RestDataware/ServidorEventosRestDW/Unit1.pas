unit Unit1;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, uDWAbout, uRESTDWServerEvents,
  uDWJSONObject, System.Json;

type
  TDataModule1 = class(TServerMethodDataModule)
    DWServerEvents1: TDWServerEvents;
    procedure DWServerEvents1EventstesteReplyEvent(var Params: TDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.DWServerEvents1EventstesteReplyEvent(
  var Params: TDWParams; var Result: string);
var
  Json : TJsonObject;
begin
  Json := TJSONObject.Create;
  try
    Json.AddPair('Nome', 'Thulio Bittencourt');
    Result := Json.ToJSON;
  finally
    FreeAndNil(Json);
  end;
end;

end.
