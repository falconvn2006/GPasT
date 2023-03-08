unit uClotureGrandsTotaux;

interface

uses
  SysUtils, Windows, FireDAC.Comp.Client, DB, uLog, Dialogs, DateUtils, ShellAPI;

const
  exeName: string = 'ClotureGrandTotaux.exe';

Type
  TclotGdTot = class

  private
    FBasId: integer;
    FDatabasePath: string;
    FExePath: string;
    FError: string;

    function getTodayParamFromDatabase: boolean;
    function exeExist: boolean;
    procedure updateGenParam(prm_id: integer);
  public
    property Error: string read FError write FError;

    constructor Create(aBaseId: integer; aDatabase: string);
    destructor Destroy; override;

    procedure DoGrandTotauxClose;
  end;

implementation

uses
  uMainForm;

var
  vConn: TFDConnection;
  vTrans: TFDTransaction;
  prm_id: integer;

  { clotGdTot }

constructor TclotGdTot.Create(aBaseId: integer; aDatabase: string);
begin
  vConn := TFDConnection.Create(nil);
  vTrans := TFDTransaction.Create(nil);
  vConn.transaction := vTrans;

  FBasId := aBaseId;
  FDatabasePath := aDatabase;
  prm_id := 0;
end;

destructor TclotGdTot.Destroy();
begin
  vConn.Connected := false;
  vConn.DisposeOf;
  vTrans.DisposeOf;
end;

procedure TclotGdTot.DoGrandTotauxClose;
begin
  // on vérifie si le paramètre et l'exe existent et si oui on lance l'exe de cloture
  if (getTodayParamFromDatabase) and (exeExist) then
  begin
    ShellExecute(0, 'Open', PChar(FExePath), '', Nil, SW_HIDE);
    // on ne met à jour le genparam de la date que si on fait l'exécution
    updateGenParam(prm_id);
    Frm_Launcher.SaveIniDateTime('CGT', Now());
  end;
end;

function TclotGdTot.exeExist: boolean;
begin
  Result := false;

  if (FileExists(ExtractFilePath(ParamStr(0)) + exeName)) then
  begin
    FExePath := ExtractFilePath(ParamStr(0)) + exeName;
    Result := true;
  end
  else
    raise Exception.Create('l''EXE de cloture n''a pas été trouvé.');
end;

function TclotGdTot.getTodayParamFromDatabase: boolean;
var
  query: TFDQuery;
  dateLastExec: integer;
begin
  Result := false;

  // connexion à la base
  vConn.Connected := false;

  vConn.Params.DriverID := 'IB';
  vConn.Params.Add('Server=Localhost');
  vConn.Params.Database := FDatabasePath;
  vConn.Params.UserName := 'ginkoia';
  vConn.Params.Password := 'ginkoia';
  vConn.LoginPrompt := false;

  try
    vConn.Connected := true;
  except
    on E: Exception do
    begin
      raise Exception.Create('Connexion à la base impossible : ' + E.Message);
    end;
  end;

  try
    query := TFDQuery.Create(nil);
    query.Connection := vConn;

    query.SQL.Text := 'SELECT * FROM GENPARAM ';
    query.SQL.Text := query.SQL.Text + 'JOIN K ON K_ID = PRM_ID ';
    query.SQL.Text := query.SQL.Text + 'WHERE PRM_TYPE = 81 AND PRM_CODE = 1 AND PRM_POS = :bas_id AND K_ENABLED = 1 AND PRM_INTEGER = 1';

    query.ParamByName('bas_id').AsLargeInt := FBasId;
    query.Open;

    if not(query.Eof) then
    begin
      dateLastExec := query.FieldByName('PRM_FLOAT').AsInteger;
      prm_id := query.FieldByName('PRM_ID').AsInteger;

      // on compare la date actuelle à la date de dernière execution, si on est un jour différent on return true et on met à jour le genparam
      if (dateLastExec < Trunc(Now)) then
      begin
        Result := true;
      end;
    end
    else
      raise Exception.Create('le GENPARAM de date de cloture n''existe pas.');
  finally
    query.Free;
  end;

end;

procedure TclotGdTot.updateGenParam(prm_id: integer);
var
  vQuery: TFDQuery;
begin
  // on met à jour le genparam avec la date du jour
  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := vConn;

    vQuery.SQL.Text := 'UPDATE GENPARAM SET PRM_FLOAT = :dateNow WHERE PRM_ID = :PRM_ID';
    vQuery.ParamByName('dateNow').AsFloat := Trunc(Now);
    vQuery.ParamByName('PRM_ID').AsInteger := prm_id;
    vQuery.ExecSQL;

    vQuery.Close;

    vConn.Commit;
  finally
    vQuery.Free;
  end;
end;

end.
