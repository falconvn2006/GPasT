unit UFDThread;

interface

USes Forms, windows, Variants, Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,DBClient,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys.IBBase, FireDAC.Phys.IB, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,SysUtils,
  Dialogs, Controls,ComCtrls, StdCtrls, ExtCtrls;

type
  TFDThread = class(TThread)
  private
    { Déclarations privées }
    FLogFile : String;
    // initialisation
    FServer : string;
    FCheminBase : string;
    FConnexion : TFDConnection;
    FReadOnly  : Boolean;
    FTransaction : TFDTransaction;
    FProgressBar: TProgressBar;
     FCounter: Integer;
     FCountTo: Integer;
    // Suivit interface
    FEtape : string;
     procedure DoProgress;
     procedure SetCountTo(const Value: Integer) ;
     procedure SetProgressBar(const Value: TProgressBar) ;
  protected
    { Déclarations protégées }
    procedure Execute(); override;
  public
    { Déclarations publiques }
    constructor Create(Server, CheminBase : string; Readonly, CreateSuspended : boolean); reintroduce;
    destructor Destroy(); override;

    // Suivit interface
    procedure DoEtape();

    // gestion de la base de données
    function InitDB() : Boolean;
    function GetNewQuery() : TFDQuery;
    procedure CommitTrans();
    procedure RollBackTrans();
    procedure FinaliseDB();

    // Gestion du log
    procedure InitLog(Prefix : string = '');
    procedure DoLog(txt : string);

    // recup du GUID de la base 0


    //Execution d'un script
    function ExecuteScriptSQL(ASQL:TStringList) : Boolean;
    function GetFieldInt(ASQL:TStringList):int64;
    procedure GetResultQuery(ASQL:TStringList;Var Acds:TClientDataSet);
    //Etapes du programme
  //  function DoScript() : Boolean;
     property CountTo: Integer read FCountTo write SetCountTo;
     property ProgressBar: TProgressBar read FProgressBar write SetProgressBar;

  end;

implementation

{ TMonThread }

 procedure TFDThread.DoProgress;
 var
   PctDone: Extended;
 begin
   PctDone := (FCounter / FCountTo) ;
   FProgressBar.Position := Round(FProgressBar.Step * PctDone) ;
 end;

procedure TFDThread.Execute();
const Interval = 1000000;
 begin
   FreeOnTerminate := False;
   FProgressBar.Max := FCountTo div Interval;
   FProgressBar.Step := FProgressBar.Max;

   while FCounter < FCountTo do
   begin
     if FCounter mod Interval = 0 then Synchronize(DoProgress) ;

     Inc(FCounter) ;
   end;

   // FOwnerButton.Caption := 'Start';
   // FOwnerButton.OwnedThread := nil;
   FProgressBar.Position := FProgressBar.Max;

end;

procedure TFDThread.SetCountTo(const Value: Integer) ;
begin
   FCountTo := Value;
end;

procedure TFDThread.SetProgressBar(const Value: TProgressBar) ;
begin
   FProgressBar := Value;
end;

// creation / destruction

constructor TFDThread.Create(Server, CheminBase : string; Readonly, CreateSuspended : boolean);
begin
  inherited Create(CreateSuspended);
  FServer := Server;
  FCheminBase := CheminBase;
  FReadOnly := ReadOnly;
  FreeOnTerminate := False;
end;

destructor TFDThread.Destroy();
begin
  inherited Destroy();
end;

// Synchropnization

procedure TFDThread.DoEtape();
begin
     Application.ProcessMessages();
end;

// gestion de la Base

function TFDThread.InitDB() : Boolean;
begin
 // DoLog('Début InitDB');
  result := False;
  try
    FConnexion := TFDConnection.Create(nil);
    FConnexion.Params.Clear;
    FConnexion.Params.Add('DriverID=IB');
    FConnexion.Params.Add('Server='+FServer);
    FConnexion.Params.Add('Database='+FCheminBase);
    FConnexion.Params.Add('User_Name=SYSDBA');
    FConnexion.Params.Add('Password=masterkey');
    FConnexion.Params.Add('Protocol=TCPIP');
    FTransaction := TFDTransaction.Create(nil);
    FTransaction.Options.ReadOnly:=FReadOnly;
    FTransaction.Connection := FConnexion;
    // FTransaction.StartTransaction();
    FConnexion.Connected := True;
    Result := FConnexion.Connected;
  except
    on e : Exception do
    Showmessage(FConnexion.Params.Text);
     // DoLog('Exception dans "InitDB" : ' + e.Message);
  end;
 // DoLog('Fin InitDB (Result = ' + BoolToStr(Result, true) + ')');
end;

function TFDThread.GetNewQuery() : TFDQuery;
begin
  Result := nil;
 // if not FConnexion.Connected then
    if not InitDB() then
      Exit;

  Result := TFDQuery.Create(nil);
  Result.Connection := FConnexion;
  Result.Transaction := FTransaction;
  // Result.ParamCheck := False;
end;

procedure TFDthread.CommitTrans();
begin
 // DoLog('Début du commit de transaction');
  try
    if FTransaction.Active then
      FTransaction.Commit();
  except
    on e : exception do
    begin
      // DoLog('Exception dans "CommitTrans" : ' + e.Message);
      Raise;
    end;
  end;
//  DoLog('Fin du commit de transaction');
end;

procedure TFDThread.RollBackTrans();
begin
 // DoLog('Début du rollback de transaction');
  try
    if FTransaction.Active then
      FTransaction.Rollback;
  except
    on e : exception do
    begin
  //    DoLog('Exception dans "RollBackTrans" : ' + e.Message);
      Raise;
    end;
  end;
 // DoLog('Fin du rollback de transaction');
end;

procedure TFDThread.FinaliseDB();
begin
//  DoLog('Début FinaliseDB');
  try
    if FTransaction.Active then
      FTransaction.Rollback();
    FreeAndNil(FTransaction);
    FreeAndNil(FConnexion);

  except
    on e : Exception do
  //    DoLog('Exception dans "FinaliseDB" : ' + e.Message);
  end;
//  DoLog('Fin FinaliseDB');
end;

// gestion de log

procedure TFDThread.InitLog(Prefix : string);
var
  Fichier : TextFile;
begin
  FLogFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Log') + Prefix + FormatDateTime('yyyymmdd-hhnnss-zzz', Now()) + '.log';
  ForceDirectories(ExtractFilePath(FLogFile));
  try
    try
      AssignFile(Fichier, FLogFile);
      Rewrite(Fichier);
      Writeln(Fichier, 'Initialisation du log');
    finally
      CloseFile(Fichier);
    end;
  except
    // que faire...
  end;
end;

procedure TFDThread.DoLog(txt : string);
var
  Fichier : TextFile;
begin
  try
    try
      AssignFile(Fichier, FLogFile);
      Append(Fichier);
      Writeln(Fichier, FormatDateTime('hh:nn:ss.zzz', Now) + ' - ' + txt);
    finally
      CloseFile(Fichier);
    end;
  except
    // que faire...
  end;
end;


function TFDThread.GetFieldInt(ASQL:TStringList):int64;
var
  Query : TFDQuery;
begin
  result:=0;
  try
    try
      Synchronize(DoEtape);
      Query := GetNewQuery();
      Query.SQL.Clear();
      Query.SQL.Text:=ASQL.Text;
      Query.Open;
      // ShowMessage(Query.SQL.Text);
      result:=Query.Fields[0].asLargeInt;
      Synchronize(DOEtape);
    finally
      Query.close;
      FreeAndNil(Query);
    end;
      except
    on e : Exception do
    begin
  //    DoLog(e.Message);
    end;
  end;

end;
procedure TFDThread.GetResultQuery(ASQL:TStringList;var Acds:TClientDataSet);
var
  Query : TFDQuery;
  i:integer;
begin
//  DoLog('GetResultQuery');
  try
    try
      Synchronize(DoEtape);
      Query := GetNewQuery();
      Query.SQL.Clear();
      Query.SQL.Text:=ASQL.Text;
      Query.Open;
      // Acds.close;
      // Acds.CreateDataSet;
      // Acds.Open;
      // Acds.Active:=true;
      While not(Query.eof) do
        begin
             Acds.Append;
             for i := 0 to Query.FieldCount-1 do
               begin
                   Acds.Fields[i].Value:=Query.Fields[i].Value;
               end;
            Acds.Post;
            Query.Next;
        end;
      Query.Close;
    finally
      FreeAndNil(Query);
    end;
  except
    on e : Exception do
    begin
  //    DoLog(e.Message);
    end;
  end;
end;

function TFDThread.ExecuteScriptSQL(ASQL:TStringList) : Boolean;
var
  Query : TFDQuery;
begin
  Result := False;
  DoLog('  Début ExecuteScriptSQL');

  try
    try
      Query := GetNewQuery();
      DoLog('    Chargement de la procedure');
      Query.SQL.Clear();
      Query.SQL.Text:=ASQL.Text;
      DoLog('    Execution de la procedure');
      Query.ExecSQL();
      Result := True;
    finally
      FreeAndNil(Query);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
    end;
  end;
  DoLog('  Fin ExecuteScriptSQL (Result = ' + BoolToStr(Result, true) + ')');
end;


end.
