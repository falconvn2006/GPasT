unit uGestionBDD;

interface

uses
  SysUtils,
  IB_Components,
  IBODataset;

const
  CST_BASE_SERVEUR = 'localhost';
  CST_BASE_PORT = 3050;
  CST_BASE_LOGIN = 'sysdba';
  CST_BASE_PASSWORD = 'masterkey';

type
  TMySession = TIB_Session;
  TMyConnection = TIB_Connection;
  TMyTransaction = TIB_Transaction;
  TMyQuery = TIBOQuery;

function GetNewSession() : TMySession;
function GetNewConnexion(FileName, UserName, Password : string; Opened : Boolean = true) : TMyConnection; overload;
function GetNewConnexion(Session : TMySession; FileName, UserName, Password : string; Opened : Boolean = true) : TMyConnection; overload;
function GetNewConnexion(FileName, UserName, Password : string; Port : integer; Opened : Boolean = true) : TMyConnection; overload;
function GetNewConnexion(Session : TMySession; FileName, UserName, Password : string; Port : integer; Opened : Boolean = true) : TMyConnection; overload;
function GetNewConnexion(Server, FileName, UserName, Password : string; Opened : Boolean = true) : TMyConnection; overload
function GetNewConnexion(Session : TMySession; Server, FileName, UserName, Password : string; Opened : Boolean = true) : TMyConnection; overload
function GetNewConnexion(Server, FileName, UserName, Password : string; Port : integer; Opened : Boolean = true) : TMyConnection; overload
function GetNewConnexion(Session : TMySession; Server, FileName, UserName, Password : string; Port : integer; Opened : Boolean = true) : TMyConnection; overload
function GetNewTransaction(Connexion : TMyConnection; Opened : Boolean = true) : TMyTransaction;
function GetNewQuery(Transaction : TMyTransaction; SQL : string = ''; Opened : boolean = false) : TMyQuery; overload;
function GetNewQuery(Connexion : TMyConnection; SQL : string = ''; Opened : boolean = false) : TMyQuery; overload;
function GetNewQuery(Connexion : TMyConnection; Transaction : TMyTransaction; SQL : string = ''; Opened : boolean = false) : TMyQuery; overload;

implementation

// Seesion

function GetNewSession() : TIB_Session;
begin
  Result := TMySession.Create(nil);
end;

// Connexion

function GetNewConnexion(FileName, UserName, Password : string; Opened : Boolean) : TMyConnection;
begin
  if Pos(':', Copy(FileName, Pos(':', FileName) +1, Length(FileName))) > 0 then
    Result := GetNewConnexion(Copy(FileName, 1,  Pos(':', FileName) -1), Copy(FileName, Pos(':', FileName) +1, Length(FileName)), UserName, Password, CST_BASE_PORT, Opened)
  else
    Result := GetNewConnexion(CST_BASE_SERVEUR, FileName, UserName, Password, CST_BASE_PORT, Opened);
end;

function GetNewConnexion(Session : TMySession; FileName, UserName, Password : string; Opened : Boolean) : TMyConnection;
begin
  if Pos(':', Copy(FileName, Pos(':', FileName) +1, Length(FileName))) > 0 then
    Result := GetNewConnexion(Session, Copy(FileName, 1,  Pos(':', FileName) -1), Copy(FileName, Pos(':', FileName) +1, Length(FileName)), UserName, Password, CST_BASE_PORT, Opened)
  else
    Result := GetNewConnexion(Session, CST_BASE_SERVEUR, FileName, UserName, Password, CST_BASE_PORT, Opened);
end;

function GetNewConnexion(FileName, UserName, Password : string; Port : integer; Opened : Boolean) : TMyConnection;
begin
  Result := GetNewConnexion(CST_BASE_SERVEUR, FileName, UserName, Password, Port, Opened);
end;

function GetNewConnexion(Session : TMySession; FileName, UserName, Password : string; Port : integer; Opened : Boolean) : TMyConnection;
begin
  Result := GetNewConnexion(Session, CST_BASE_SERVEUR, FileName, UserName, Password, Port, Opened);
end;

function GetNewConnexion(Server, FileName, UserName, Password : string; Opened : Boolean) : TMyConnection;
begin
  Result := GetNewConnexion(Server, FileName, UserName, Password, CST_BASE_PORT, Opened);
end;

function GetNewConnexion(Session : TMySession; Server, FileName, UserName, Password : string; Opened : Boolean) : TMyConnection;
begin
  Result := GetNewConnexion(Session, Server, FileName, UserName, Password, CST_BASE_PORT, Opened);
end;

function GetNewConnexion(Server, FileName, UserName, Password : string; Port : integer; Opened : Boolean) : TMyConnection;
begin
  Result := GetNewConnexion(nil, Server, FileName, UserName, Password, Port, Opened);
end;

function GetNewConnexion(Session : TMySession; Server, FileName, UserName, Password : string; Port : integer; Opened : Boolean) : TMyConnection;
begin
  Result := TMyConnection.Create(Session);
  Result.IB_Session := Session;
  Result.DatabaseName := AnsiString(Server + '/' + IntToStr(Port) + ':' + FileName);
  Result.Username := AnsiString(UserName);
  Result.Password := AnsiString(Password);
  Result.DefaultTransaction := nil;
  if Opened then
    Result.Connect();
end;

// Transaction

function GetNewTransaction(Connexion : TMyConnection; Opened : Boolean) : TMyTransaction;
begin
  Result := TMyTransaction.Create(Connexion.IB_Session);
  Result.IB_Connection := Connexion;
  if Opened then
    Result.StartTransaction();
end;

// Query

function GetNewQuery(Transaction : TMyTransaction; SQL : string; Opened : boolean) : TMyQuery;
begin
  Result := GetNewQuery(TMyConnection(Transaction.IB_Connection), Transaction, SQL, Opened);
end;

function GetNewQuery(Connexion : TMyConnection; SQL : string = ''; Opened : boolean = false) : TMyQuery; overload;
begin
  Result := GetNewQuery(Connexion, nil, SQL, Opened);
end;

function GetNewQuery(Connexion : TMyConnection; Transaction : TMyTransaction; SQL : string; Opened : boolean) : TMyQuery;
begin
  Result:= TMyQuery.Create(Connexion.IB_Session);
  Result.IB_Connection := Connexion;
  Result.IB_Transaction := Transaction;
  Result.RequestLive := True;
  Result.SQL.Text := SQL;
  if not (Trim(SQL) = '') and Opened then
  begin
    if not Connexion.Connected then
      Connexion.Open();
    if Assigned(Transaction) and not Transaction.InTransaction then
      Transaction.StartTransaction();
    Result.Open();
  end;
end;

end.
