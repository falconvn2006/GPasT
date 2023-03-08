unit Uweb;

interface

Uses  VCL.Dialogs, Winapi.Windows, Winapi.Messages, System.SysUtils,
      System.Variants, System.Classes, Vcl.Graphics,
      IdBaseComponent,  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
      System.Generics.Collections;
Const
  ClMonitor_Blue      = $009C5838;
  ClMonitor_DarkBlue  = $007C3818;
  ClMonitor_Red       = $001B1BB8;
  ClMonitor_DarkRed   = $00080898;
  ClMonitor_green     = $004AA617;
  ClMonitor_DarkGreen = $003D7A0C;

Type
   TTuile = class
  private
    FName : String;
    FId   : integer;
    Fcur  : integer;
  public
    Titre : string;
    Color : TColor;
    Nom   : string;
    host  : string;
    app   : string;
    inst  : string;
    mdl   : string;
    ref   : string;
    key   : string;
    Tag   : string;
    Value : string;
    Freq  : integer;
    Cur   : integer;
    Need_Refresh : boolean;
    constructor Create(const AName: String);
    destructor Destroy(); override;
    property Id: integer read Fid Write Fid;
  end;

function GetURLAsString(const aURL: string;Const aJson:string): string;
function HexToTColor(sColor : string) : TColor;

implementation

constructor TTuile.Create(const AName: String);
begin
  FName := AName;
  Need_Refresh:=true;
end;

destructor TTuile.Destroy;
begin
  { Show a message whenever an object is destroyed. }
  // MessageDlg('Object "' + FName + '" was destroyed!', mtInformation, [mbOK], 0);
  inherited;
end;

function GetURLAsString(const aURL: string;Const aJson:string): string;
var lHTTP: TIdHTTP;
    code: Integer;
    sResponse: string;
    lParamList: TStringList;
begin
  lParamList := TStringList.Create;
  lParamList.Add('json='+aJson);
  lHTTP := TIdHTTP.Create(nil);
  sResponse:='';
  try
    // lHTTP.Request.ContentType := 'application/json';
    // lHTTP.Request.ContentEncoding := 'utf-8';
    try
      sResponse := lHTTP.Post(aURL, lParamList);
    except
      on E: Exception do
        ShowMessage('Error on request: '#13#10 + e.Message);
    end;
  finally
    result:=sResponse;
    lParamList.Free();
    lHTTP.Free;
  end;
end;

function HexToTColor(sColor : string) : TColor;
begin
   Result :=
     RGB(
       StrToInt('$'+Copy(sColor, 1, 2)),
       StrToInt('$'+Copy(sColor, 3, 2)),
       StrToInt('$'+Copy(sColor, 5, 2))
     ) ;
end;


end.
