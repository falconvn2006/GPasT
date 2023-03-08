unit uWsQtePull;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls,System.IniFiles, Winapi.WinSvc, System.RegularExpressionsCore, uLog, Math,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.JSON ;

Type
  TThreadWsQtePull = class(TThread)
  private
    { Déclarations privées }
    FGUID    : string;
    FDATACOUNT   : integer;
    FOLDESTBATCH : string;
    FVitesse     : Double;
    FLevel       : TLogLevel;
    FFIN         : TDateTime;
    function GetURLContent(const aURL: string): string;
    procedure ParseJson(json:string);
  public
    procedure Execute; override;
    constructor Create(CreateSuspended:boolean;aGUID:string;const AEvent:TNotifyEvent=nil); reintroduce;
    destructor Destroy; override;
  property Level       : TLogLevel  read FLEVEL;
  property datacount   : integer    read FDATACOUNT;
  property oldestbatch : string     read FOLDESTBATCH;
  property Vitesse     : double     read FVitesse;
  property Fin         : TDateTime  read FFIN;
    { Déclarations publiques }
  end;

implementation


destructor TThreadWsQtePull.Destroy();
begin
    inherited;
end;

constructor TThreadWsQtePull.Create(CreateSuspended:boolean;aGUID:string;Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    FreeOnTerminate  := true;
    FLevel           := logInfo;
    FGUID            := aGUID;
    FDATACOUNT       := 0;
    FOLDESTBATCH     := '';
    FVITESSE         := 0;
    FFIN             := 0;
    OnTerminate      := AEvent;
end;


procedure TThreadWsQtePull.Execute;
var vContent:string;
    vUrl : string;
begin
    try
      vUrl := Format('http://logs.ginkoia.eu/ws/ws_easy_missing_datas.php?guid=%s',[FGUID]);
      vContent := GetURLContent(vUrl);
      ParseJson(vContent);
    finally
      //
    end;
end;


function TThreadWsQtePull.GetURLContent(const aURL: string): string;
var lHTTP: TIdHTTP;
    sResponse: string;
begin
  lHTTP := TIdHTTP.Create(nil);
  sResponse:='';
  try
    try
      sResponse := lHTTP.Get(aURL);
      // FStatus := 'Recup ' + aURL;
      // Synchronize(UpdateVCL);
    except
      on E: Exception do
       //
    end;
  finally
    result:=sResponse;
    lHTTP.Free;
  end
end;


procedure TThreadWsQtePull.ParseJson(json:string);
var  LJSONObj: TJSONObject;
     vLast : TDateTime;
begin
    LJsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json),0) as TJSONObject;
    try
       if LJsonObj<>nil then
          begin
             FDATACOUNT    := StrToIntDef(LJsonObj.GetValue<string>('datacount'),0);
             FOLDESTBATCH  := LJsonObj.GetValue<string>('oldestbatch');
             vLast := StrToDateTimeDef(LJsonObj.GetValue<string>('oldestbatch'),0);

             if (vLast+900/SecsPerDay < Now())
                then FLevel := logNotice;

             if (vLast+3600/SecsPerDay< Now())
                then FLevel := logWarning;

             if (vLast+1< Now())
                then FLevel := logError;

             FVITESSE := StrToFloatDef(LJsonObj.GetValue<string>('vitesse_seconde'),0);
             FFIN     := StrToDateTimeDef(LJsonObj.GetValue<string>('fin'),0);

          end;
    Except On e : Exception do
        begin
          //
        end;
    end;
end;

end.


