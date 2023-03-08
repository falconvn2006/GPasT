unit UWPOST;

interface

uses
   Classes, ShellApi, ExtCtrls, Menus, jpeg,   SysUtils, IniFiles,
   IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Vcl.ExtActns, UCommun,System.JSON;

Type
   { Thread qui replace l'exe WDPOST.exe}
   TWPost = class(TThread)
   protected
     Furl     : string;
     Fjson    : string;
     Fpsk     : string;
     FReponse : string;
     FOnAfterPost : TNotifyEvent;
     procedure Execute; override;
     procedure DoPost;
     procedure DoAfterPost;
   public
     constructor Create(Aurl:string;Ajson:string;Apsk:string; ANotifyEvent: TNotifyEvent); reintroduce;
     destructor Destroy; override;
     property Reponse : string Read FReponse Write FReponse;
   end;

implementation

{TWPost}

procedure TWPost.DoAfterPost;
begin
   try
    if Assigned(FOnAfterPost) then
     FOnAfterPost(self);
   Except
     on E: Exception do
     // rien
   end;
end;

procedure TWPost.Execute;
begin
   try
      DoPost;
      Synchronize(DoAfterPost);
   Except
      on E: Exception do
      // rien
   end;
end;

procedure TWPost.DoPost;
var lHTTP: TIdHTTP;
    sResponse: string;
    Params: TStringList;
begin
  lHTTP := TIdHTTP.Create(nil);
  sResponse:='';
  Params := TStringList.Create;
  Params.Add('json='+Fjson);
  Params.Add('psk='+Fpsk);
  try
    try
      sResponse := lHTTP.Post(Furl,Params);
    except
      on E: Exception do
       // rien
    end;
  finally
    Params.Free;
    lHTTP.Free;
  end
end;

constructor TWPost.Create(AUrl:string;Ajson:string;Apsk:string;ANotifyEvent: TNotifyEvent);
begin
   inherited Create(True);
   FOnAfterPost := ANotifyEvent;
   FUrl   := AUrl;
   FJSON  := Ajson;
   FPSK   := APsk;
   FreeOnTerminate := True;
end;

destructor TWPost.Destroy;
begin
   inherited;
end;

end.
