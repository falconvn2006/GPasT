unit UWSClient;

{*** Pour le moment une unité en projet ... passer par le webservice pour mettre à jour la base Maintenance ***}


interface

uses Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, ImgList, Controls, DB, DBClient, Forms, Dialogs, cxGrid, cxPC, midaslib,
  ActnList, ComCtrls, u_Parser, ExtCtrls, Graphics,  SysUtils;

function GetNewIdHTTP(const AOwner: TComponent): TIdHTTP;
procedure WPost(const AURL: String;Const AXMLString:TStrings);

implementation

function GetNewIdHTTP(const AOwner: TComponent): TIdHTTP;
begin
  Result:= TIdHTTP.Create(AOwner);
  Result.Request.Accept:= 'text/xml, */*';
  Result.Request.ContentEncoding:= 'UTF-8';
  Result.Request.ContentType:= 'text/xml, */*';
  Result.Request.UserAgent:= 'Client Ginkoia 1.0';
  Result.Response.KeepAlive:= False;
end;

procedure WPOST(const AURL: String;Const AXMLString:TStrings);
var vIdHTTP : TIdHTTP;
    vParser : TParser;
begin
  Screen.Cursor:= crHourGlass;
  vParser := TParser.Create(nil);
  try
    try
      { -- Recuperation de la ressource -- }
      vIdHTTP:= GetNewIdHTTP(nil);
      vParser.ARequest:= vIdHTTP.Post(AUrl, AXMLString);
      vParser.Execute;
    except
      Raise;
    end;
  finally
    vIdHTTP.Free;
    Screen.Cursor:= crDefault;
  end;
end;


end.
