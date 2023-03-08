unit UDatabaseUtils;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait;

function GetConnexion(Server, FileName, UserName, Password : string; Opened : boolean = false) : TFDConnection;
function GetTransaction(Connexion : TFDConnection; Opened : boolean = false) : TFDTransaction;
function GetQuery(Connexion : TFDConnection; Transaction : TFDTransaction; SQL : string = ''; Opened : boolean = false) : TFDQuery;

implementation

function GetConnexionBaseConfig(Server, FileName, UserName, Password : string; Opened : boolean) : TFDConnection;
begin
  result := TFDConnection.Create(nil);
  result.DriverName := 'IB';
  result.Params.Clear();
  result.Params.Add('Server=' + Server);
  result.Params.Add('Database=' + FileName);
  result.Params.Add('User_Name=' + UserName);
  result.Params.Add('Password=' + Password);
  result.Params.Add('Protocol=TCPIP');
  result.Params.Add('DriverID=IB');
  if Opened then
    result.Open();
end;

function GetTransaction(Connexion : TFDConnection; Opened : boolean) : TFDTransaction;
begin
  result := TFDTransaction.Create(nil);
  result.Connection := Connexion;
  if Opened then
  begin
    if not Connexion.Connected then
      Connexion.Open();
    result.StartTransaction();
  end;
end;

function GetQuery(Connexion : TFDConnection; Transaction : TFDTransaction; SQL : string; Opened : boolean) : TFDQuery;
begin
  result := TFDQuery.Create(nil);
  result.Connection := Connexion;
  result.Transaction := Transaction;
  if not (Trim(SQL) = '') and Opened then
  begin
    if not Connexion.Connected then
      Connexion.Open();
    if Assigned(Transaction) and not Transaction.Active then
      Transaction.StartTransaction();
    Result.Open();
  end;
end;

end.
