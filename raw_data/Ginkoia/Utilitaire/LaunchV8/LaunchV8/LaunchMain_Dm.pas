unit LaunchMain_Dm;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBCustomDataSet, IBQuery, Forms, uLogFile, uLog;

type
  TDm_LaunchMain = class(TDataModule)
    Dtb_Ginkoia: TIBDatabase;
    Tra_Ginkoia: TIBTransaction;
    IBQue_Modifk: TIBQuery;
    Que_EtatLauncher: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }

    function MainNewK(Table: string): integer;
    procedure MainDeleteK(Clef: Integer);
    procedure MainModifK(Clef: Integer);
    procedure MainReactiveK(Clef: Integer);
    procedure setFermerEtatLauncher();
    procedure setOuvrirEtatLauncher();
  end;

var
  Dm_LaunchMain: TDm_LaunchMain;
  LaBase0      : string;
  IdBase0      : Integer;
  NomBase0     : String;
  RepliEnCours : Boolean;

  ModeDebug    : Boolean;

  LogFile       : TLogFile ;

implementation

{$R *.dfm}

{ TDm_LaunchMain }

//---------------------------------------------------------------
// Récupération d'un nouvel ID
//---------------------------------------------------------------
FUNCTION TDm_LaunchMain.MainNewK(Table: String) : integer;
BEGIN
  Log.Log('LaunchMain_Dm', 'MainNewK', 'Log', 'select PR_NEWK (avant).', logDebug, True, 0, ltLocal);

  IBQue_Modifk.Close;
  IBQue_ModifK.Sql.Clear;
  IBQue_ModifK.Sql.Text := 'SELECT ID FROM PR_NEWK(''' + Table +''')';
  try
    IBQue_ModifK.Open;
    Result := IBQue_ModifK.Fields[0].AsInteger;
  except
    Result := 0;
  end;

  Log.Log('LaunchMain_Dm', 'MainNewK', 'Log', 'select PR_NEWK (après).', logDebug, True, 0, ltLocal);

  IBQue_ModifK.Close;
  IBQue_ModifK.Sql.Clear;
END;

//---------------------------------------------------------------
// Modification du K -> réactivation d'un k_enabled = 0
//---------------------------------------------------------------
procedure TDm_LaunchMain.MainReactiveK(Clef: Integer);
begin
  Log.Log('LaunchMain_Dm', 'MainReactiveK', 'Log', 'execute procedure PR_UPDATEK (avant).', logDebug, True, 0, ltLocal);

  IBQue_ModifK.Close;
  IBQue_ModifK.Sql.Clear;
  IBQue_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 2)';
  IBQue_ModifK.ExecSQL;

  Log.Log('LaunchMain_Dm', 'MainReactiveK', 'Log', 'execute procedure PR_UPDATEK (après).', logDebug, True, 0, ltLocal);
  IBQue_ModifK.Sql.Clear;
end;

//---------------------------------------------------------------
// Modification du K
//---------------------------------------------------------------
PROCEDURE TDm_LaunchMain.MainModifK(Clef: Integer);
BEGIN
  Log.Log('LaunchMain_Dm', 'MainModifK', 'Log', 'execute procedure PR_UPDATEK (avant).', logDebug, True, 0, ltLocal);

  IBQue_ModifK.Close;
  IBQue_ModifK.Sql.Clear;
  IBQue_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 0)';
  IBQue_ModifK.ExecSQL;

  Log.Log('LaunchMain_Dm', 'MainModifK', 'Log', 'execute procedure PR_UPDATEK (après).', logDebug, True, 0, ltLocal);
  IBQue_ModifK.Sql.Clear;
END;

//---------------------------------------------------------------
// suppression du K
//---------------------------------------------------------------

procedure TDm_LaunchMain.DataModuleCreate(Sender: TObject);
begin
  // Init des logs
//  initLogFileName(0, Application.ExeName, 'yyyy_mm_dd');
  // Purge des vieux logs
//  PurgeOldLogs(Application.ExeName, 30);
end;

PROCEDURE TDm_LaunchMain.MainDeleteK(Clef: Integer);
BEGIN
  Log.Log('LaunchMain_Dm', 'MainDeleteK', 'Log', 'execute procedure PR_UPDATEK (avant).', logDebug, True, 0, ltLocal);

  IBQue_ModifK.Close;
  IBQue_ModifK.Sql.Clear;
  IBQue_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 1)';
  IBQue_ModifK.ExecSql;

  Log.Log('LaunchMain_Dm', 'MainDeleteK', 'Log', 'execute procedure PR_UPDATEK (après).', logDebug, True, 0, ltLocal);
  IBQue_ModifK.Sql.Clear;
END;

procedure TDm_LaunchMain.setFermerEtatLauncher();
begin
  try
    if Que_EtatLauncher.active then
      Que_EtatLauncher.Close();

    Que_EtatLauncher.SQL.Clear;
    Que_EtatLauncher.SQL.Text :=  'UPDATE GENPARAMBASE ' +
                                  'SET PAR_FLOAT = :ETAT, ' +
                                  '    PAR_STRING = :DATE ' +
                                  'WHERE PAR_NOM = ''LAUNCHER_LANCE'' ';

    Que_EtatLauncher.ParamByName('ETAT').AsFloat := 0;
    Que_EtatLauncher.ParamByName('DATE').AsString := DateTimeToStr(now);

    Que_EtatLauncher.ExecSQL();
    Que_EtatLauncher.Close();
  except
    on E : Exception do
      Log.Log('LaunchMain_Dm', 'EtatLauncher', 'Log', e.Message, logError, True, 0, ltLocal);
  end;
end;

procedure TDm_LaunchMain.setOuvrirEtatLauncher();
begin
  try
    if Que_EtatLauncher.active then
       Que_EtatLauncher.Close();

    Que_EtatLauncher.SQL.Clear;
    Que_EtatLauncher.SQL.Text :=  'UPDATE GENPARAMBASE ' +
                                  'SET PAR_FLOAT = :ETAT, ' +
                                  '    PAR_STRING = :DATE ' +
                                  'WHERE PAR_NOM = ''LAUNCHER_LANCE'' ';
    Que_EtatLauncher.ParamByName('ETAT').AsFloat := 1;
    Que_EtatLauncher.ParamByName('DATE').AsString := DateTimeToStr(now);

    Que_EtatLauncher.ExecSQL();
    Que_EtatLauncher.Close();
  except
    Log.Log('LaunchMain_Dm', 'EtatLauncher', 'Log', 'e.Message', logError, True, 0, ltLocal);
  end;
end;

initialization
  LogFile := TLogFile.Create;
finalization
  LogFile.Free;
end.

