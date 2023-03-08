unit uLiaisonCollectionModele;

interface

uses
  uSynchroObjBDD, umodele,ucollection,uGestionBDD,StrUtils;

type
  {$M+}
  TLiaisonCollectionModele = class(TMyObject)
  private
    //Fid: integer;
    FARTID: integer;
    FCOLID: integer;
    //Fmodele : TModele;
    //Fcollection : TCollection;
  protected
    const
    TABLE_NAME='ARTCOLART';
    TABLE_TRIGRAM='CAR';
    TABLE_PK='CAR_ID';
  public
    constructor create(); overload;
    constructor create (modele : TModele; collection : TCollection); overload;
    procedure doLoadByArtidColid(aQuery : TMyQuery);
  published
    //property id: integer     read Fid     write Fid;
    property ARTID         : integer    read FARTID       write FARTID      ;
    property COLID   : integer   read FCOLID write FCOLID;
  end;
  {$M-}

implementation

{ TLiaisonCollectionArticle }
constructor TLiaisonCollectionModele.create;
begin
   inherited  Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

constructor TLiaisonCollectionModele.create (modele : TModele; collection : TCollection);
begin
   Create();
   ARTID := modele.Id;
   COLID := collection.id;
end;

procedure TLiaisonCollectionModele.doLoadByArtidColid(aQuery : TMyQuery);
var
  request : string;
  position : integer;
begin
  aQuery.Close;
  request := dogetQry(tqSelect);
  position := Pos('where',request);
  request := AnsiLeftStr(request, position-1);
  request := request+ ' where CAR_ARTID=:artid and CAR_COLID=:colid and car_id<>0';
  aQuery.SQL.Text := request;
  aQuery.ParamByName('ARTID').AsInteger := ARTID;
  aQuery.ParamByName('COLID').AsInteger := COLID;
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

end.
