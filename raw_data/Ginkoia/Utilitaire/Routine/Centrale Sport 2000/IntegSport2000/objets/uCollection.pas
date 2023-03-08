unit uCollection;

interface

uses
  uSynchroObjBDD,uGestionBDD,StrUtils,SysUtils;

type
  {$M+}
  TCollection = class(TMyObject)
  private
    FCODE: string;
    FCENTRALE: integer;
    FDTDEB: TDateTime;
    FNOM: string;
    FNOVISIBLE: integer;
    FDTFIN: TDateTime;
    FACTIVE: integer;
    FEXEID: integer;
    FREFDYNA: integer;
  protected
    const
    TABLE_NAME='ARTCOLLECTION';
    TABLE_TRIGRAM='COL';
    TABLE_PK='COL_ID';
  public
    constructor create(); overload;
    procedure doLoadFromNom(aQuery : TMyQuery);
  published
    property NOM         : string    read FNOM       write FNOM      ;
    property NOVISIBLE   : integer   read FNOVISIBLE write FNOVISIBLE; 	
    property REFDYNA     : integer   read FREFDYNA   write FREFDYNA  ; 	
    property CODE        : string    read FCODE      write FCODE     ; 	
    property CENTRALE    : integer   read FCENTRALE  write FCENTRALE ;	
    property ACTIVE      : integer   read FACTIVE    write FACTIVE   ; 	
    property DTDEB       : TDateTime read FDTDEB     write FDTDEB    ; 	
    property DTFIN       : TDateTime read FDTFIN     write FDTFIN    ;	
    property EXEID       : integer   read FEXEID     write FEXEID    ;
  end;
  {$M-}

implementation

{ TCollection }
constructor TCollection.create;
begin
   inherited  Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

procedure TCollection.doLoadFromNom(aQuery : TMyQuery);
var
  request : string;
  position : integer;
begin
  aQuery.Close;
  request := dogetQry(tqSelect);
  position := Pos('where',request);
  request := AnsiLeftStr(request,position-1);
  request := request + ' where UPPER(COL_NOM)=:nom';
  aQuery.SQL.Text := request;
  aQuery.ParamByName('nom').AsString := uppercase(NOM);
  aQuery.open;
  if (aQuery.RecordCount > 0) then
  begin
     fillObjectWithQuery(self, aQuery, FTrigram);
     FExist := true;
  end else begin
     FExist := false;
  end;
  // pas de gestion en cas de doublons
  aQuery.Close;
end;

end.
