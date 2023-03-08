unit uDB;

interface
Uses Data.DB, Data.Win.ADODB;
//SELECT @@IDENTITY AS Ident

function GetLastID(qConnection:TADOConnection):integer;

implementation


function GetLastID(qConnection:TADOConnection):integer;
var
 q:TADOQuery;
begin
  q:=nil;
  result:=0;
  if qConnection=nil then exit;
  try
    q:= TADOQuery.Create(nil);
    q.Connection:= qConnection;
    q.SQL.Text := 'SELECT @@IDENTITY AS Ident';
    q.Open;
    result:= q.FieldByName('Ident').AsInteger;
  finally
    if q.Active then q.Close;
    q.Free;
  end;
end;

end.
