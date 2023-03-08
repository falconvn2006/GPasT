unit dmdGinkoia;

interface

uses
  SysUtils, Classes, DB, ADODB;

Const
  // Pour débug
//  cConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=True;User ID=%s;password=%s;Initial Catalog=%s;Data Source=%s;';
  // Pour prod
  cConnectionString = 'Provider=SQLNCLI10.1;Persist Security Info=True;User ID=%s;password=%s;Initial Catalog=%s;Data Source=%s;';


type
  TdmGinkoia = class(TDataModule)
    ADOConnection: TADOConnection;
  private
  public
    function GetNewQry(Const AOwner: TComponent = nil): TADOQuery;
    function GetNewID(Const ATableName: String): integer; //--> Provisoire
  end;

var
  dmGinkoia: TdmGinkoia;

implementation

{$R *.dfm}

{ TdmGinkoia }


{ *** Provisoire *** }
function TdmGinkoia.GetNewID(const ATableName: String): integer;
var
  vQry: TADOQuery;
begin
  vQry:= GetNewQry;
  try
    vQry.SQL.Text:= 'SELECT IDENT_CURRENT (' + QuotedStr(ATableName) + ') AS CURRENT_IDENTITY';
    vQry.Open;

    Result:= vQry.Fields[0].AsInteger;

  finally
    FreeAndNil(vQry);
  end;
end;

function TdmGinkoia.GetNewQry(const AOwner: TComponent): TADOQuery;
begin
  Result:= TADOQuery.Create(AOwner);
  Result.Connection:= ADOConnection;
end;

end.
