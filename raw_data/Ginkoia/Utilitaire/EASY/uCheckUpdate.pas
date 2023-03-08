unit uCheckUpdate;

interface

uses
   Classes, ShellApi, ExtCtrls, Menus, jpeg,   SysUtils, IniFiles, Vcl.StdCtrls,
   IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Vcl.ExtActns, UCommun,System.JSON, Forms;

Type
   TCheckUpdateThread = class(TThread)
   private
     procedure DoAfterCheck;
   protected
     FLabel          : TLabel;
     FLocalVersion   : string;
     FRemoteVersion  : string;
     FStatus         : string;
     FRemoteFile     : string; // Pour donner l'url à l'autre thread
     FOnAfterCheck   : TNotifyEvent;
     procedure UpdateVCL;
     procedure Execute; override;
//     procedure DoCheck; virtual;
     function GetURLAsString(const aURL: string;Const aJson:string): string;
     procedure DoCheckNewVersion();
     procedure ExeParseJson(json:string);
     function FileUrlExists(const aUrl:string):boolean;
   public
     constructor Create(aExeName:string; aLabel:TLabel; ANotifyEvent: TNotifyEvent); reintroduce;
     destructor Destroy; override;
   published
     property RemoteFile    : string       read FRemoteFile;
     property LocalVersion  : string       read FLocalVersion;
     property RemoteVersion : string       read FRemoteVersion;
     property OnAfterCheck  : TNotifyEvent read FOnAfterCheck  write FOnAfterCheck;
   end;

   TExeUpdateThread = class(TThread)
   private
     procedure DoAfterDone;
   protected
     FLabel          : TLabel;
     FLocalFile      : string;
     FLocalVersion   : string;
     FRemoteFile     : string;

     // FRemoteVersion  : string;
     FStatus         : string;
     FOnAfterDone    : TNotifyEvent;
     FShellUpdate    : Boolean;
     procedure UpdateVCL;
     procedure Execute; override;
     // procedure DoCheck; virtual;
     function GetURLAsString(const aURL: string;Const aJson:string): string;
     // procedure ExeParseJson(json:string);
     function ExeDoDownloadNewVersion():boolean;
     function FileUrlExists(const aUrl:string):boolean;
   public
     constructor Create(aExeName:string; aURL:string;aLabel:TLabel; ANotifyEvent: TNotifyEvent); reintroduce;
     destructor Destroy; override;
   published
     // property LocalVersion  : string       read FLocalVersion;
     // property RemoteVersion : string       read FRemoteVersion;
     property OnAfteDone   : TNotifyEvent read FOnAfterDone   write FOnAfterDone;
     property ShellUpdate  : boolean      read FShellUpdate   write FShellUpdate;
   end;



{
   TUpdateThread = class(TThread)
   private
     procedure DoAfterCheck;
   protected
     FLabel          : TLabel;
     FLocalVersion   : string;
     FlocalFile      : string;
     FRemoteVersion  : string;
     FRemoteFile     : string;
     FVersionDispo   : boolean;
     FStatus         : string;
     FOnAfterCheck   : TNotifyEvent;
     procedure UpdateVCL;
     procedure Execute; override;
     procedure DoCheck; virtual;
     function GetURLAsString(const aURL: string;Const aJson:string): string;
     function DoDownloadNewNersion(aUrl:string;aLocalFile:string):boolean;
     function FileUrlExists(const aUrl:string):boolean;
     procedure ParseJson(json:string);
   public
     constructor Create(LocalVersion:string; aLabel:TLabel; ANotifyEvent: TNotifyEvent); reintroduce;
     destructor Destroy; override;
//     procedure Check;
   published
     property OnAfterCheck   : TNotifyEvent read FOnAfterCheck  write FOnAfterCheck;
     property RemoteVersion  : string       read FRemoteVersion write FRemoteVersion;
     property RemoteFile     : string       read FRemoteFile    write FRemoteFile;
     property VersionDispo   : boolean      read FVersionDispo  write FVersionDispo;
     property LocalFile      : string       read FLocalFile     Write FlocalFile;
   end;
}
   { Thread qui replace l'exe WDPOST.exe}
{
   TWPost = class(TThread)
   protected
     Furl    : string;
     Fjson   : string;
     Fpsk    : string;
     FOnAfterPost : TNotifyEvent;
     procedure Execute; override;
     procedure DoPost;
     procedure DoAfterPost;
   public
     constructor Create(Aurl:string;Ajson:string;Apsk:string; ANotifyEvent: TNotifyEvent); reintroduce;
     destructor Destroy; override;
   end;
}


implementation


{TCheckUpdateThread}

procedure TCheckUpdateThread.UpdateVCL;
begin
    FLabel.Caption := FStatus;
end;


constructor TCheckUpdateThread.Create(aExeName:string; aLabel:TLabel;ANotifyEvent: TNotifyEvent);
begin
   inherited Create(false);
   FLocalVersion := GetInfo('Version');

   FLabel           := aLabel;
   FStatus          := 'Create';
   FOnAfterCheck    := ANotifyEvent;
   FreeOnTerminate  := True;
end;


procedure TCheckUpdateThread.DoAfterCheck;
begin
   if Assigned(FOnAfterCheck) then
     FOnAfterCheck(self);
end;


function TCheckUpdateThread.GetURLAsString(const aURL: string;Const aJson:string): string;
var lHTTP: TIdHTTP;
    sResponse: string;
begin
  lHTTP := TIdHTTP.Create(nil);
  sResponse:='';
  try
    // lHTTP.Request.ContentType := 'application/json';
    // lHTTP.Request.ContentEncoding := 'utf-8';
    try
      sResponse := lHTTP.Get(aURL);
      FStatus := 'Recup ' + aURL;
      Synchronize(UpdateVCL);
    except
      on E: Exception do
       //
    end;
  finally
    result:=sResponse;
    //
    lHTTP.Free;
  end
end;


function TCheckUpdateThread.FileUrlExists(const aUrl:string):boolean;
var FUpdateInfo:TidHttp;
begin
     result:=true;
     FUpdateInfo := TidHttp.Create(nil);
     try
        FUpdateInfo.ConnectTimeout := 2000;
        try
            FUpdateInfo.Get(aUrl);
            If FUpdateInfo.ResponseCode<>200 then result:=false;
            except
                on e:exception do
                    begin
                       result:=false;
                    end;
        end;
        finally
              FUpdateInfo.Free;
       end;
end;




destructor TCheckUpdateThread.Destroy;
begin
   inherited;
end;

procedure TCheckUpdateThread.Execute;
begin
   try
      DoCheckNewVersion();
      Synchronize(DoAfterCheck);
   Except
    //
   end;
end;


procedure TCheckUpdateThread.DoCheckNewVersion();
var json:string;
begin
     FLocalVersion := GetInfo('Version');
     FRemoteVersion := '';
     FRemoteFile    := '';
     try
       json:=GetURLAsString(MAJ_UrlPath + MAJ_InformationsFile ,'');
       // ---------------- il faut parser le json ------------------------------
       ExeParseJson(json);
       FStatus := 'Check Version';
       Synchronize(UpdateVCL);
       {
       If (CompareVersion(FLocalVersion,FRemoteVersion)<0)
          then
           begin
              // VersionDispo:=true;
              // DoDownload(Url,LocalFile);
              ExeDoDownloadNewVersion();
           end
         else
            begin
                FStatus := 'version = Check Version : OK';
                Synchronize(UpdateVCL);
            end;
       }
       Except
          // à la moindre exception on pose tout à <vide>
          On e : Exception do
            begin
              FRemoteVersion := '';
              // RemoteFile    := '';
            end;
     end;
end;

procedure TCheckUpdateThread.ExeParseJson(json:string);
var  LJSONObj: TJSONObject;
     a,b,c:string;
     item  : TJSonValue;
     items : TJSONArray;
     i:integer;
     vName,vVersion,vUrl : string;
begin
    LJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(json),0) as TJSONObject;
    try
       if LJsonObj<>nil then
          begin
             // Pour Test
             // FRemoteVersion := '6.0.0.0';
             // il faut parcourir "programmes" pour trouver le nom de mon exe en cours...
             items := ((LJsonObj.Get('programmes').JsonValue)) as TJSONArray;
             for item  in items  do
              begin
                 vName    := UpperCase(item.GetValue<string>('name'));
                 vVersion := UpperCase(item.GetValue<string>('version'));
                 vURL     := item.Getvalue<string>('url');
                 if vName=UpperCase(ExtractFileName(Application.ExeName))
                    then
                      begin
                         FRemoteVersion := vVersion;
                         FRemoteFile    := vUrl;
                      end;
              end;
             Synchronize(UpdateVCL);
          end;
    Except On e : Exception do
        begin
          FRemoteVersion := '';
          FRemoteFile    := '';
          FStatus := 'Parse Error ' + E.Message;
          Synchronize(UpdateVCL);
        end;
    end;
end;



{TExeUpdateThread}

procedure TExeUpdateThread.UpdateVCL;
begin
    FLabel.Caption := FStatus;
end;

constructor TExeUpdateThread.Create(aExeName:string;aURL:string; aLabel:TLabel;ANotifyEvent: TNotifyEvent);
begin
   inherited Create(false);
   FShellUpdate     := false;
   FlocalFile       := aExeName;
   FLocalVersion    := GetInfo('Version');
   FRemoteFile      := aURL;
   FLabel           := aLabel;
   FStatus          := 'Create';
   FOnAfterDone     := ANotifyEvent;
   FreeOnTerminate  := True;
end;

destructor TExeUpdateThread.Destroy;
begin
   inherited;
end;


procedure TExeUpdateThread.DoAfterDone;
begin
   if Assigned(FOnAfterDone) then
     FOnAfterDone(self);
end;

procedure TExeUpdateThread.Execute;
begin
   try
      ExeDoDownloadNewVersion();
      Synchronize(DoAfterDone);
   Except
    //
   end;
end;


function TExeUpdateThread.GetURLAsString(const aURL: string;Const aJson:string): string;
var lHTTP: TIdHTTP;
    sResponse: string;
begin
  lHTTP := TIdHTTP.Create(nil);
  sResponse:='';
  try
    // lHTTP.Request.ContentType := 'application/json';
    // lHTTP.Request.ContentEncoding := 'utf-8';
    try
      sResponse := lHTTP.Get(aURL);
      FStatus := 'Recup ' + aURL;
      Synchronize(UpdateVCL);
    except
      on E: Exception do
       //
    end;
  finally
    result:=sResponse;
    //
    lHTTP.Free;
  end
end;

function TExeUpdateThread.ExeDoDownloadNewVersion():boolean;
var savName:string;
begin
     result:=true;
     with TDownloadURL.Create(nil) do
         try
            Url      := FRemoteFile;
            FileName := FLocalFile + '.new';
            DeleteFile(FileName);
            try
               If FileExists(URL) or FileUrlExists(URL)
                  then
                    begin
                        FStatus := 'Téléchargement nouvelle version : '+ Url;
                        Synchronize(UpdateVCL);
                        ExecuteTarget(nil);
                        // on renomme l'exe en cours en .version.old
                        FStatus := 'Renommage 1/2';
                        Synchronize(UpdateVCL);
                        DeleteFile(FLocalFile+Format('.v%s.old',[FLocalVersion]));
                        RenameFile(FLocalFile,FLocalFile+Format('.v%s.old',[FLocalVersion]));
                        FStatus := 'Renommage 2/2';
                        // on renomme le nouveau en exe en cours
                        RenameFile(FileName,FLocalFile);
                        FShellUpdate  := true;
                    end;
             Except
                 On e : Exception do
                    begin
                         result:=false;
                    end;
                end;
         Finally
              Free;
         end;
end;


function TExeUpdateThread.FileUrlExists(const aUrl:string):boolean;
var FUpdateInfo:TidHttp;
begin
     result:=true;
     FUpdateInfo := TidHttp.Create(nil);
     try
        FUpdateInfo.ConnectTimeout := 2000;
        try
            FUpdateInfo.Get(aUrl);
            If FUpdateInfo.ResponseCode<>200 then result:=false;
            except
                on e:exception do
                    begin
                       result:=false;
                    end;
        end;
        finally
              FUpdateInfo.Free;
       end;
end;





{
     FLocalVersion := GetInfo('Version');
     FRemoteVersion := '';
     FRemoteFile    := '';
     try
       json:=GetURLAsString(MAJ_UrlPath + MAJ_InformationsFile ,'');
       // ---------------- il faut parser le json ------------------------------
       ExeParseJson(json);
       FStatus := 'Check Version';
       Synchronize(UpdateVCL);
       If (CompareVersion(FLocalVersion,FRemoteVersion)<0)
          then
           begin
              // VersionDispo:=true;
              // DoDownload(Url,LocalFile);
              ExeDoDownloadNewVersion();
           end
         else
            begin
                FStatus := 'version = Check Version : OK';
                Synchronize(UpdateVCL);
            end;
       Except
          // à la moindre exception on pose tout à <vide>
          On e : Exception do
            begin
              FRemoteVersion := '';
              // RemoteFile    := '';
            end;
     end;
end;
}



{
procedure TWPost.DoAfterPost;
begin
   if Assigned(FOnAfterPost) then
     FOnAfterPost(self);
end;

procedure TWPost.Execute;
begin
   try
      DoPost;
      Synchronize(DoAfterPost);
   Except
      on E: Exception do
      // --------------
   end;
end;

procedure TWPost.DoPost;
var lHTTP: TIdHTTP;
    sResponse: string;
    Params: TStringList;
    v : string;
begin
  lHTTP := TIdHTTP.Create(nil);
  lHTTP.ReadTimeout:=3000;
  sResponse:='';
  Params := TStringList.Create;
  Params.Add('json='+Fjson);
  Params.Add('psk='+Fpsk);
  try
    try
      sResponse := lHTTP.Post(Furl,Params);
    except
      on E: Exception do
        begin
         v:= E.Message;

        // --------------
        // rien...
        // --------------
        end;
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


constructor TUpdateThread.Create(LocalVersion:string;aLabel:TLabel;ANotifyEvent: TNotifyEvent);
begin
   inherited Create(false);
   FLabel           := aLabel;
   FVersionDispo    := false;
   FRemoteVersion   := '';
   FRemoteFile      := '';
   FStatus          := 'Create';
   FLocalVersion    := LocalVersion;
   FOnAfterCheck    := ANotifyEvent;
   FreeOnTerminate  := True;
   Synchronize(UpdateVCL);
end;


destructor TUpdateThread.Destroy;
begin
   inherited;
end;

procedure TUpdateThread.UpdateVCL;
begin
    FLabel.Caption := FStatus;
end;

function TUpdateThread.GetURLAsString(const aURL: string;Const aJson:string): string;
var lHTTP: TIdHTTP;
    sResponse: string;
begin
  lHTTP := TIdHTTP.Create(nil);
  sResponse:='';
  try
    // lHTTP.Request.ContentType := 'application/json';
    // lHTTP.Request.ContentEncoding := 'utf-8';
    try
      sResponse := lHTTP.Get(aURL);
      FStatus := 'Recup ' + aURL;
      Synchronize(UpdateVCL);
    except
      on E: Exception do
       //
    end;
  finally
    result:=sResponse;
    //
    lHTTP.Free;
  end
end;

procedure TUpdateThread.ParseJson(json:string);
var  LJSONObj: TJSONObject;
begin
    LJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(json),0) as TJSONObject;
    try
       if LJsonObj<>nil then
          begin
               RemoteVersion := (LJsonObj.Get('dbversion').JsonValue).Value;
               RemoteFile    := (LJsonObj.Get('url').JsonValue).Value;
               FStatus := 'Parse ' + RemoteVersion + '/' +  RemoteFile ;
               Synchronize(UpdateVCL);
          end;
    Except On e : Exception do
        begin
          RemoteVersion := '';
          RemoteFile    := '';
          FStatus := 'Parse Error ' + E.Message;
          Synchronize(UpdateVCL);
        end;
    end;
end;

function TUpdateThread.FileUrlExists(const aUrl:string):boolean;
var FUpdateInfo:TidHttp;
begin
     result:=true;
     FUpdateInfo := TidHttp.Create(nil);
     try
        FUpdateInfo.ConnectTimeout := 2000;
        try
            FUpdateInfo.Get(aUrl);
            If FUpdateInfo.ResponseCode<>200 then result:=false;
            except
                on e:exception do
                    begin
                       result:=false;
                    end;
        end;
        finally
              FUpdateInfo.Free;
       end;
end;

function TUpdateThread.DoDownloadNewNersion(aUrl:string;aLocalFile:string):boolean;
var savName:string;
begin
     result:=true;
     with TDownloadURL.Create(nil) do
         try
            Url                := aUrl;
            // Renommage du fichier aLocalFile en aLocalFile_yyyymmdd_hhnnss.zzzz
            // DeleteFile(aLocalFile);
            savName := aLocalFile + '_'  +  FormatDateTime('yyyymmdd_hhnnsszzz',now());
            if RenameFile(aLocalFile, savName) then
              begin
                FileName  := aLocalFile;
                FStatus   := 'Renommage du Local : OK';
                Synchronize(UpdateVCL);
                try
                   If FileExists(aURL) or FileUrlExists(aURL)
                      then
                          begin
                             FStatus := 'Téléchargement nouvelle version : '+ aUrl;
                             Synchronize(UpdateVCL);
                             ExecuteTarget(nil);
                          end;
                Except
                 On e : Exception do
                    begin
                         result:=false;
                    end;
                end;
              end;
         Finally
              Free;
         end;
end;

procedure TUpdateThread.DoCheck;
var json:string;
begin
     RemoteVersion := '';
     RemoteFile    := '';
     try
       json:=GetURLAsString(MAJ_UrlPath + MAJ_InformationsFile ,'');
       // ---------------- il faut parser le json ------------------------------
       ParseJson(json);
       FStatus := 'Check Version';
       Synchronize(UpdateVCL);
       If (CompareVersion(FLocalVersion,RemoteVersion)<0)
          then
           begin
              VersionDispo:=true;
              // DoDownload(Url,LocalFile);
              DoDownloadNewNersion(RemoteFile,LocalFile);
           end
         else
            begin
                FStatus := 'Check Version : OK';
                Synchronize(UpdateVCL);
            end;
       Except
          // à la moindre exception on pose tout à <vide>
          On e : Exception do
            begin
              RemoteVersion := '';
              RemoteFile    := '';
            end;
     end;
end;

procedure TUpdateThread.DoAfterCheck;
begin
   if Assigned(FOnAfterCheck) then
     FOnAfterCheck(self);
end;

procedure TUpdateThread.Execute;
begin
   try
      DoCheck;
      Synchronize(DoAfterCheck);
   Except
    //
   end;
end;

}


end.
