unit uApi;

interface

uses Classes, idHTTP, SysUtils, uJson, uCommunicationApi;

type
  TBasePatch = class(TPersistent)
  private
    FSeq: Integer;
    FName: String;
    FHash: String;
    FId: Integer;
    FType: Integer;
    FContent: String;
    FErrNo: Integer;
    FError: String;
  public
    function GetContent(sUrl, sParam: String): boolean;
  published
    property Id: Integer read FId write FId;
    property &Type: Integer read FType write FType;
    property Seq: Integer read FSeq write FSeq;
    property Name: String read FName write FName;
    property Hash: String read FHash write FHash;
    property Content: String read FContent write FContent;
    property ErrNo: Integer read FErrNo write FErrNo;
    property Error: String read FError write FError;
  end;

  TSite = class(TBasePatch);
  TBundle = class(TBasePatch);

  TArrSite = array of TSite;
  TArrBundle = array of TBundle;

  TSendBundle = class(TPersistent)
  private
    FResult: TArrBundle;
    FRollBack: boolean;
  public
  published
    property Result: TArrBundle read FResult write FResult;
    property RollBack: boolean read FRollBack write FRollBack;
  end;

  TSendSite = class(TPersistent)
  private
    FResult: TArrSite;
    FRollBack: boolean;
  public
  published
    property Result: TArrSite read FResult write FResult;
    property RollBack: boolean read FRollBack write FRollBack;
  end;

  TPatch = class(TPersistent)
  private
    FSite: TArrSite;
    FBundle: TArrBundle;
    FRollBack: boolean;
  public
  published
    property Site: TArrSite read FSite write FSite;
    property Bundle: TArrBundle read FBundle write FBundle;
    property RollBack: boolean read FRollBack write FRollBack;
  end;

  TNewMaj = class(TPersistent)
    private
      FRPatch: TApiResult<TPatch>;
      FGUID: String;
      FUrl: String;
      FVersion : String;
    public
      procedure getPatch;
      procedure doPatch;
      procedure SendResult;
      procedure SendVersion;
    published
      property RPatch : TApiResult<TPatch> read FRPatch write FRPatch;
      property URL : String read FUrl write FUrl;
      property GUID : String read FGUID write FGUID;
      property Version : String read FVersion write FVersion;
  end;

  TMagasin = class(TPersistent)
  private
    FSitId: Integer;
    FCode: String;
    FNom: String;
    FId: Integer;
    FEnseigne: String;
    FCodeAdh: String;
  public
  published
    property Id : Integer  read FId   write FId;
    property Code : String   read FCode   write FCode;
    property SitId : Integer  read FSitId   write FSitId;
    property Nom : String   read FNom   write FNom;
    property Enseigne : String   read FEnseigne   write FEnseigne;
    property CodeAdh : String   read FCodeAdh   write FCodeAdh;
  end;

  TArrMagasin = array of TMagasin;

  TApiResult = class(TPersistent)
  private
    FErrNo : Integer;
    FError : String;
    FResult : TArrMagasin;
  public
    constructor Create;
    destructor Destroy ; override ;
    procedure Get(sURL, sParam : String);
  published
    property ErrNo : Integer  read FErrNo   write FErrNo;
    property Error : String   read FError   write FError;
    property Result : TArrMagasin  read FResult  write FResult;
  end;

  TStorDossier = class(TPersistent)
  private
    FId: integer;
    FDomId: integer;
    FCenId: integer;
    FNom: String;
    FSrvId: integer;
    FTypeReplic: integer;
    FDatabase: String;
    FTiers: String;
  public
  published
    property Id : integer read FId write FId;
    property DomId : integer read FDomId write FDomId;
    property SrvId : integer read FSrvId write FSrvId;
    property CenId : integer read FCenId write FCenId;
    property Nom : String read FNom write FNom;
    property Tiers : String read FTiers write FTiers;
    property Database : String read FDatabase write FDatabase;
    property TypeReplic : integer read FTypeReplic write FTypeReplic;
  end;

  TStorage = class(TPersistent)
  private
    FPassWord: String;
    FHostName: String;
    FUserName: String;
  public
  published
    property HostName : String read FHostName write FHostName;
    property UserName : String read FUserName write FUserName;
    property PassWord : String read FPassWord write FPassWord;
  end;

  TDossierStorage = class(TPersistent)
  private
    FDossier: TStorDossier;
    FStorage: TStorage;
  public
  published
    property Dossier : TStorDossier read FDossier write FDossier;
    property Storage : TStorage read FStorage write FStorage;
  end;

implementation

uses uguid;

{ TNewMaj }

procedure TNewMaj.doPatch;
var
  i : integer;
begin
  if assigned(RPatch) then
  begin
    if assigned(RPatch.Result) then
    begin
      for I := 0 to length(RPatch.getResult.Bundle)-1 do
        uguid.Form1.Patch(RPatch.getResult.Bundle[i].Id, RPatch.getResult.Bundle[i].Content);

      for I := 0 to length(RPatch.getResult.Site)-1 do
        uguid.Form1.Patch(RPatch.getResult.Site[i].Id, RPatch.getResult.Site[i].Content);
    end;
  end;
end;

procedure TNewMaj.getPatch;
var
  i : integer;
begin
  RPatch := TApiResult<TPatch>.Create;
  RPatch.Get(FURL + 'getMajListPatchsBySite.php', '?guid=' + FGUID);
  if assigned(RPatch) then
  begin
    if assigned(RPatch.Result) then
    begin
      for I := 0 to length(RPatch.getResult.Bundle)-1 do
        RPatch.getResult.Bundle[i].GetContent(FUrl + 'getPatchBundle.php', '?guid=' + FGuid);

      for I := 0 to length(RPatch.getResult.Site)-1 do
        RPatch.getResult.Site[i].GetContent(FUrl + 'getPatchSite.php', '?guid=' + FGuid);
    end;
  end;
end;

procedure TNewMaj.SendResult;
var
  Bundle: TSendBundle;
  Site : TSendSite;
  SendB: TSendObjToApi<TSendBundle>;
  SendS: TSendObjToApi<TSendSite>;
  i: Integer;
begin
  Bundle := TSendBundle.Create;
  Bundle.FResult := FRPatch.getResult.FBundle;
  Bundle.FRollBack := false;
  SendB := TSendObjToApi<TSendBundle>.Create;
  Site := TSendSite.Create;
  Site.FResult := FRPatch.getResult.FSite;
  Site.FRollBack := false;
  SendS := TSendObjToApi<TSendSite>.Create;
  try
    SendB.Send(Bundle, FURL + 'setPatchBundleStatus.php', '?guid=' + FGuid);
    SendS.Send(Site, FURL + 'setPatchSiteStatus.php', '?guid=' + FGuid);
  finally
    SendB.Free;
    SendS.Free;
    Bundle.Free;
    Site.Free;
  end;
end;

procedure TNewMaj.SendVersion;
var
  Http : TIdHTTP;
  vResponse : TStringStream;
begin
  try
    try
      Http := TIdHTTP.Create(nil);
      Http.ConnectTimeout := 2000;
      Http.Request.ContentType := 'application/json';
      vResponse := TStringStream.Create('');
      Http.Get(FUrl + 'setMajStatus.php?guid='+FGUID+'&verversion='+FVersion, vResponse);
      if Http.ResponseCode = 200 then
          TJSON.JSONToObject(vResponse.DataString, self)
      else
      begin
        raise Exception.Create('Result http error : ' + Http.ResponseText);
      end;
    except on E:Exception do
      begin
      end;
    end;
  finally
    Http.Free;
    vResponse.Free;
  end;
end;

{ TBasePatch }

function TBasePatch.GetContent(sUrl, sParam: String): boolean;
var
  obj: TApiResult<TBasePatch>;
//  sl : TStringList;
begin
  Result := False;
  obj := TApiResult<TBasePatch>.Create;
  try
    obj.Get(sUrl, sParam + '&id=' + inttostr(FId));
    if Assigned(obj.Result) then
    begin
      FContent := obj.getResult.Content;
//      try
//        sl := TStringList.Create;
//        sl.Add(FContent);
//        sl.SaveToFile('C:\Ginkoia\TMP\Seq' + IntToStr(FSeq) + '_id' + IntToStr(FId) + '.sql');
//      finally
//        sl.Free;
//      end;
      Result := FContent <> '';
    end;
  finally
    obj.Free;
  end;
end;

{ TApiResult }

constructor TApiResult.Create;
begin

end;

destructor TApiResult.Destroy;
begin

  inherited;
end;

procedure TApiResult.Get(sURL, sParam: String);
var
  Http : TIdHTTP;
  vResponse : TStringStream;
begin
  try
    try
      Http := TIdHTTP.Create(nil);
      Http.ConnectTimeout := 2000;
      Http.Request.ContentType := 'application/json';
      vResponse := TStringStream.Create('');
      Http.Get(sURL + sParam, vResponse);
      if Http.ResponseCode = 200 then
          TJSON.JSONToObject(vResponse.DataString, self);
    except
      on E:Exception do
      begin

      end;
    end;
  finally
    Http.Free;
    vResponse.Free;
  end;
end;

end.
