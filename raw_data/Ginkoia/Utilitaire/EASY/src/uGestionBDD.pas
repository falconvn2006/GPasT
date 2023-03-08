unit uGestionBDD;

interface

uses
  System.SysUtils,
  Classes,
  FireDAC.Comp.Client,
  FireDAC.Comp.Script,
  FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Stan.Error,
  FireDAC.Stan.Param,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait;

const
  CST_BASE_SERVEUR = 'localhost';
  CST_BASE_PORT = 3050;
  CST_BASE_LOGIN = 'sysdba';
  CST_BASE_PASSWORD = 'masterkey';
  CST_BASE_LOCAL_IP = '127.0.0.1';
  CST_GINKOIA_LOGIN = 'ginkoia';
  CST_GINKOIA_PASSWORD = 'ginkoia';

type
  TMyConnection = TFDConnection;

  TMyTransaction = class(TFDTransaction)
  private
    FTransactionCount: Integer;

    function GetMyConnection: TMyConnection;
    procedure SetMyConnection(const Value: TMyConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property MyConnection: TMyConnection read GetMyConnection write SetMyConnection;

    procedure MyStartTransaction;
    procedure MyCommitTransaction;
    procedure MyRollBackTransaction;
  end;

  TMyQuery = TFDQuery;
  TMyScript = TFDScript;

function GetNewConnexion(FileName, UserName, Password : string; Opened : Boolean = true) : TMyConnection; overload;
function GetNewConnexion(FileName, UserName, Password : string; Port : integer; Opened : Boolean = true) : TMyConnection; overload;
function GetNewConnexion(Server, FileName, UserName, Password : string; Opened : Boolean = true) : TMyConnection; overload
function GetNewConnexion(Server, FileName, UserName, Password : string; Port : integer; Opened : Boolean = true) : TMyConnection; overload
function GetNewTransaction(Connexion : TMyConnection; Opened : Boolean = true) : TMyTransaction;
function GetNewQuery(Transaction : TMyTransaction; SQL : string = ''; Opened : boolean = false) : TMyQuery; overload;
function GetNewQuery(Connexion : TMyConnection; SQL : string = ''; Opened : boolean = false) : TMyQuery; overload;
function GetNewQuery(Connexion : TMyConnection; Transaction : TMyTransaction; SQL : string = ''; Opened : boolean = false) : TMyQuery; overload;
function GetNewScript(Connexion : TMyConnection) : TMyScript; overload;
function GetNewScript(Transaction : TMyTransaction) : TMyScript; overload;
function GetNewScript(Connexion : TMyConnection; Transaction : TMyTransaction) : TMyScript; overload;
function GetNewScript(Connexion : TMyConnection; Transaction : TMyTransaction; OnError : TFDErrorEvent) : TMyScript; overload;

implementation

// Connexion

function GetNewConnexion(FileName, UserName, Password : string; Opened : Boolean) : TMyConnection;
begin
  Result := GetNewConnexion(CST_BASE_SERVEUR, FileName, UserName, Password, CST_BASE_PORT, Opened);
end;

function GetNewConnexion(FileName, UserName, Password : string; Port : integer; Opened : Boolean) : TMyConnection;
begin
  Result := GetNewConnexion(CST_BASE_SERVEUR, FileName, UserName, Password, Port, Opened);
end;

function GetNewConnexion(Server, FileName, UserName, Password : string; Opened : Boolean) : TMyConnection;
begin
  Result := GetNewConnexion(Server, FileName, UserName, Password, CST_BASE_PORT, Opened);
end;

function GetNewConnexion(Server, FileName, UserName, Password : string; Port : integer; Opened : Boolean) : TMyConnection;
begin
  Result := TMyConnection.Create(nil);
  Result.DriverName := 'IB';
  Result.Params.Clear();
  Result.Params.Add('Server=' + Server);
  Result.Params.Add('Database=' + FileName);
  Result.Params.Add('User_Name=' + UserName);
  Result.Params.Add('Password=' + Password);
  // Ici nous ne changeons le port que s'il n'est le port par defaut.
  // car sinon ca pose problème avec IB7 !
  if Port <> CST_BASE_PORT then
    Result.Params.Add('Port=' + IntToStr(Port));
  Result.Params.Add('Protocol=TCPIP');
  Result.Params.Add('DriverID=IB');
  if Opened then
    Result.Open();
end;

// Transaction

function GetNewTransaction(Connexion : TMyConnection; Opened : Boolean) : TMyTransaction;
begin
  Result := TMyTransaction.Create(nil);
  Result.Connection := Connexion;
  if not Assigned(Connexion.Transaction) then
    Connexion.Transaction := Result;
  if Opened then
  begin
    if not Connexion.Connected then
      Connexion.Open();
    Result.StartTransaction();
  end;
end;

// Query

function GetNewQuery(Transaction : TMyTransaction; SQL : string; Opened : boolean) : TMyQuery;
begin
  Result := GetNewQuery(TMyConnection(Transaction.Connection), Transaction, SQL, Opened);
end;

function GetNewQuery(Connexion : TMyConnection; SQL : string = ''; Opened : boolean = false) : TMyQuery; overload;
begin
  Result := GetNewQuery(Connexion, nil, SQL, Opened);
end;

function GetNewQuery(Connexion : TMyConnection; Transaction : TMyTransaction; SQL : string; Opened : boolean) : TMyQuery;
begin
  Result := TMyQuery.Create(nil);
  Result.Connection := Connexion;
  Result.Transaction := Transaction;
  Result.SQL.Text := SQL;
  if not (Trim(SQL) = '') and Opened then
  begin
    if not Connexion.Connected then
      Connexion.Open();
    if Assigned(Transaction) and not Transaction.Active then
      Transaction.StartTransaction();
    Result.Open();
  end;
end;

// Script

function GetNewScript(Connexion : TMyConnection) : TMyScript; overload;
begin
  Result := GetNewScript(Connexion, nil);
end;

function GetNewScript(Transaction : TMyTransaction) : TMyScript; overload;
begin
  Result := GetNewScript(TMyConnection(Transaction.Connection), Transaction);
end;

function GetNewScript(Connexion : TMyConnection; Transaction : TMyTransaction) : TMyScript;
begin
  Result := TMyScript.Create(nil);
  Result.Connection := Connexion;
  Result.Transaction := Transaction;
  Result.ScriptOptions.IgnoreError := false;
  Result.ScriptOptions.BreakOnError := true;
  Result.ScriptOptions.MacroExpand := false;
end;

function GetNewScript(Connexion : TMyConnection; Transaction : TMyTransaction; OnError : TFDErrorEvent) : TMyScript;
begin
  Result := GetNewScript(Connexion, Transaction);
  Result.OnError := OnError;
end;

{ TMyTransaction }

constructor TMyTransaction.Create(AOwner: TComponent);
begin
  inherited;

  FTransactionCount := 0;
end;

destructor TMyTransaction.Destroy;
begin
  FTransactionCount := 0;

  inherited;
end;

function TMyTransaction.GetMyConnection: TMyConnection;
begin
  Result := TFDConnection(Connection);
end;


procedure TMyTransaction.MyCommitTransaction;
begin
  Dec(FTransactionCount);

  if FTransactionCount = 0 then
  begin
    Commit;
  end;
end;

procedure TMyTransaction.MyRollBackTransaction;
begin
  Dec(FTransactionCount);

  if FTransactionCount = 0 then
  begin
    Rollback;
  end;
end;

procedure TMyTransaction.MyStartTransaction;
begin
  inc(FTransactionCount);

  if FTransactionCount = 1 then
  begin
    StartTransaction;
  end;
end;

procedure TMyTransaction.SetMyConnection(const Value: TMyConnection);
begin
  Connection := Value;
end;

end.
