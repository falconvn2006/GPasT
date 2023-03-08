unit uFournisseur;

interface

uses
  uSynchroObjBDD, uGestionBDD,StrUtils;

type
  {$M+}
  TFournisseur = class(TMyObject)
  private
    FIDREF : integer;
    FNOM : String;
    FADRID : integer;
    FTel : string;
    FFAX : string;
    FEmail : string;
    FRemise : extended;
    FGros: integer;
    FCDTCDE: string;
    FCODE: string;
    FTEXTCDE  : string;
    FMAGIDPF: integer;
    FINTRA: integer;
    FERPNO: string;
    FACTIVE: integer;
    FILN: string;
    FCENTRALE: integer;
    FTYPE: integer;
    FRAPPAUTO: integer;
    FNUMTVAINTRA: string;


    const
    TABLE_NAME='ARTFOURN';
    TABLE_TRIGRAM='FOU';
    TABLE_PK='FOU_ID';
  public
    constructor create(); overload;
    procedure doLoadFromNom(aQuery : TMyQuery);
    function doLoadFromGenimport(idfournisseur : integer; aQuery : TMyQuery) : boolean;
  published
    property IDREF : integer read FIDREF     write FIDREF;
    property NOM : String read FNOM     write FNOM;
    property ADRID : integer read FADRID     write FADRID;
    property Tel : string read FTel     write FTel;
    property FAX : string read FFAX     write FFAX;
    property Email : string read FEmail     write FEmail;
    property Remise : extended read FRemise     write FRemise;
    property Gros: integer read FGros     write FGros;
    property CDTCDE: string read FCDTCDE     write FCDTCDE;
    property CODE: string read FCODE     write FCODE;
    property TEXTCDE  : string read FTEXTCDE     write FTEXTCDE;
    property MAGIDPF: integer read FMAGIDPF     write FMAGIDPF;
    property INTRA: integer read FINTRA     write FINTRA;
    property ERPNO: string read FERPNO     write FERPNO;
    property ACTIVE: integer read FACTIVE     write FACTIVE;
    property ILN: string read FILN     write FILN;
    property CENTRALE: integer read FCENTRALE     write FCENTRALE;
    property TYPE_ : integer read FTYPE write FTYPE;     // 0 par defaut
    property RAPPAUTO: integer read FRAPPAUTO     write FRAPPAUTO;
    property NUMTVAINTRA: string read FNUMTVAINTRA     write FNUMTVAINTRA;

  end;
  {$M-}

implementation

{ TPrixAchat }
constructor TFournisseur.create;
begin
   inherited  Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

function TFournisseur.doLoadFromGenimport(idfournisseur : integer; aQuery : TMyQuery) : boolean;
var
  request : string;
  fou_id : integer;
begin
  result := false;
//  fou_id := 0;
  aQuery.Close;
  request := 'select imp_ginkoia ';
  request := request + 'from genimport ';
  request := request + 'where IMP_NUM=4 and IMP_KTBID=-11111385 and IMP_REF=:impref';
  aQuery.SQL.Text := request;
  aQuery.ParamByName('impref').AsInteger := idfournisseur;
  aQuery.open;
  if (aQuery.RecordCount > 0) then
  begin
     fou_id := aQuery.fieldbyname('imp_ginkoia').AsInteger;
     if (fou_id<>0) then
     begin
        Fid := fou_id;
        doLoad(aQuery);
        result := true;
     end;
  end else begin
     FExist := false;
  end;
  aQuery.Close;
end;

procedure TFournisseur.doLoadFromNom(aQuery : TMyQuery);
var
  request : string;
  position : integer;
begin
  aQuery.Close;
  request := dogetQry(tqSelect);
  position := Pos('where',request);
  request := AnsiLeftStr(request,position-1);
  request := request + ' where FOU_NOM=:founom';
  aQuery.SQL.Text := request;
  aQuery.ParamByName('founom').AsString := NOM;
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
