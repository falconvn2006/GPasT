unit uPrixVente;

interface

uses
  uSynchroObjBDD,uGestionBDD, StrUtils, umodele;

type
  {$M+}
  TPrixVente = class(TMyObject)
  private
    FTvtid: integer;
    FArtid: integer;
    FTgfid: integer;
    FPx: Extended;
    FCouid: integer;
    FCentrale: integer;
  protected
    const
    TABLE_NAME='TARPRIXVENTE';
    TABLE_TRIGRAM='PVT';
    TABLE_PK='PVT_ID';
  public
    constructor create(); overload;
    procedure doLoadFromModele(modele : TModele; aQuery : TMyQuery);
    procedure doLoadFromArtId(aQuery : TMyQuery);
  published
    property Tvtid: integer    read FTvtid    write FTvtid;
    property Artid: integer    read FArtid    write FArtid;
    property Tgfid: integer    read FTgfid    write FTgfid;
    property Px: Extended      read FPx       write FPx;
    property Couid: integer    read FCouid    write FCouid;
    property Centrale: integer read FCentrale write FCentrale;
  end;
  {$M-}

implementation

{ TPrixVente }
constructor TPrixVente.create;
begin
   inherited  Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;


procedure TPrixVente.doLoadFromModele(modele : TModele; aQuery : TMyQuery);
var
  request : string;
  position : integer;
begin
  if (modele<>nil) and (modele.isExist) then
  begin
    aQuery.Close;
    request := dogetQry(tqSelect);
    position := Pos('where',request);
    request := AnsiLeftStr(request, position-1);
    request := request + ' where PVT_ARTID=:artid and PVT_TGFID=0 and PVT_TVTID=0';
    aQuery.SQL.Text := request;
    aQuery.ParamByName('artid').AsInteger := modele.id;
    aQuery.open;
    if (aQuery.RecordCount > 0) then
    begin
       fillObjectWithQuery(self, aQuery, FTrigram);
       FExist := true;
    end else begin
       FExist := false;
    end;
    aQuery.Close;
  end;
end;

procedure TPrixVente.doLoadFromArtId(aQuery : TMyQuery);
var
  request : string;
  position : integer;
begin
  if (Artid > 0) then
  begin
    aQuery.Close;
    request := dogetQry(tqSelect);
    position := Pos('where',request);
    request := AnsiLeftStr(request, position - 1);
    request := request + ' where PVT_ARTID=:artid and PVT_TGFID=0 and PVT_TVTID=0';
    aQuery.SQL.Text := request;
    aQuery.ParamByName('artid').AsInteger := Artid;
    aQuery.open;
    if (aQuery.RecordCount > 0) then
    begin
       fillObjectWithQuery(self, aQuery, FTrigram);
       FExist := true;
    end else begin
       FExist := false;
    end;
    aQuery.Close;
  end;
end;

end.
