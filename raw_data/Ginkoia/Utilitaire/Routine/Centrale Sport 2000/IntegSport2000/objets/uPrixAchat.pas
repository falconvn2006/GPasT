unit uPrixAchat;

interface

uses
  uSynchroObjBDD, uFournisseur, uGestionBDD, StrUtils, uModele;

type
  {$M+}
  TPrixAchat = class(TMyObject)
  private
    FArtid: integer;
    FFouid: integer;
    FTgfid: integer;
    FPx: extended;
    FPxnego: extended;
    FPxvi: extended;
    FRa1: extended;
    FRa2: extended;
    FRa3: extended;
    FTaxe: extended;
    FPrincipaL: integer;
    FCouid: integer;
    FCentrale: integer;
  protected
    const
    TABLE_NAME='TARCLGFOURN';
    TABLE_TRIGRAM='CLG';
    TABLE_PK='CLG_ID';
  public
    constructor create(); overload;
    procedure doLoadFromModeleFournisseur(modele : TModele; fournisseur : TFournisseur; aQuery : TMyQuery);
    procedure doLoadFromArtIdFouId(aQuery : TMyQuery);
  published
    property Artid: integer     read FArtid     write FArtid;
    property Fouid: integer     read FFouid     write FFouid;
    property Tgfid: integer     read FTgfid     write FTgfid;
    property Px: extended       read FPx        write FPx;
    property Pxnego: extended   read FPxnego    write FPxnego;
    property Pxvi: extended     read FPxvi      write FPxvi;
    property Ra1: extended      read FRa1       write FRa1;
    property Ra2: extended      read FRa2       write FRa2;
    property Ra3: extended      read FRa3       write FRa3;
    property Taxe: extended     read FTaxe      write FTaxe;
    property PrincipaL: integer read FPrincipaL write FPrincipaL;
    property Couid: integer     read FCouid     write FCouid;
    property Centrale: integer  read FCentrale  write FCentrale;


  end;
  {$M-}

implementation

{ TPrixAchat }
constructor TPrixAchat.create;
begin
   inherited  Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

procedure TPrixAchat.doLoadFromModeleFournisseur(modele : TModele; fournisseur : TFournisseur; aQuery : TMyQuery);
var
  request : string;
  position : integer;
begin
  if (modele<>nil) and (fournisseur<>nil) and (modele.isExist) and (fournisseur.isExist) then
  begin
    aQuery.Close;
    request := dogetQry(tqSelect);
    position := Pos('where',request);
    request := AnsiLeftStr(request, position-1);
    request := request + ' where CLG_ARTID=:artid and CLG_fouid=:fouid and CLG_TGFID=0';
    aQuery.SQL.Text := request;
    aQuery.ParamByName('artid').AsInteger := modele.id;
    aQuery.ParamByName('fouid').AsInteger := fournisseur.id;
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

procedure TPrixAchat.doLoadFromArtIdFouId(aQuery : TMyQuery);
var
  request : string;
  position : integer;
begin
  if (Artid > 0) and (Fouid > 0) then
  begin
    aQuery.Close;
    request := dogetQry(tqSelect);
    position := Pos('where',request);
    request := AnsiLeftStr(request, position);
    request := request + ' where CLG_ARTID=:artid and CLG_fouid=:fouid and CLG_TGFID=0';
    aQuery.SQL.Text := request;
    aQuery.ParamByName('artid').AsInteger := Artid;
    aQuery.ParamByName('fouid').AsInteger := Fouid;
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

