unit uClotureGrandsTotaux;

interface

uses
  SysUtils, Windows, IBDatabase, DB, IBQuery, uLog, Dialogs, uGestionBDD, DateUtils, ShellAPI;

const
  exeName : string = 'ClotureGrandTotaux.exe';

Type
  TclotGdTot = class
    
  private
    FBasId: integer;
    FDatabasePath: string;
    FExePath: string;

    function getTodayParamFromDatabase: boolean;
    function exeExist: Boolean;
    procedure updateGenParam(var query: TMyQuery; var transaction: TMyTransaction; prm_id: integer);
  public
    constructor Create(aBaseId:integer; aDatabase: string);

    procedure DoGrandTotauxClose;
  end;


implementation

{ clotGdTot }

constructor TclotGdTot.Create(aBaseId:integer; aDatabase: string);
begin
  FBasId := aBaseId;
  FDatabasePath := aDatabase;
end;

procedure TclotGdTot.DoGrandTotauxClose;
begin
  // on vérifie si le paramètre et l'exe existent et si oui on lance l'exe de cloture
  if (getTodayParamFromDatabase) and (exeExist) then
  begin
    ShellExecute(0, 'Open', PChar(FExePath), '', Nil, SW_HIDE);
  end;
end;

function TclotGdTot.exeExist: Boolean;
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
  connexion : TMyConnection;
  transaction: TMyTransaction;
  query : TMyQuery;
  dateLastExec : integer;
  prm_id : integer;
begin
    Result := false;
    prm_id := 0;

    // connexion à la base
    connexion := GetNewConnexion(FDatabasePath, 'ginkoia', 'ginkoia');
    try
      try
        transaction := GetNewTransaction(connexion);
        try
          query := GetNewQuery(transaction,'', True);
          query.SQL.Text :=                  'SELECT * FROM GENPARAM ';
          query.SQL.Text := query.SQL.Text + 'JOIN K ON K_ID = PRM_ID ';
          query.SQL.Text := query.SQL.Text + 'WHERE PRM_TYPE = 81 AND PRM_CODE = 1 AND PRM_POS = :bas_id AND K_ENABLED = 1 AND PRM_INTEGER = 1';

          query.ParamByName('bas_id').AsLargeInt := FBasId;
          query.Open;

          if not (query.Eof) then
          begin
             dateLastExec := query.FieldByName('PRM_FLOAT').AsInteger;
             prm_id := query.FieldByName('PRM_ID').AsInteger;

             // on compare la date actuelle à la date de dernière execution, si on est un jour différent on return true et on met à jour le genparam
             if (dateLastExec < Trunc(Now)) then
             begin
                updateGenParam(query, transaction, prm_id);

                Result := true;
             end;
          end
          else
            raise Exception.Create('le GENPARAM de date de cloture n''existe pas.');

        finally
          query.Free;
        end;
      finally
        transaction.free;
      end;
    finally
      connexion.Free;
    end;
end;

procedure TclotGdTot.updateGenParam(var query: TMyQuery; var transaction: TMyTransaction; prm_id: integer);
begin
   // on met à jour le genparam avec la date du jour
   query.Close;
   query.Open;
   query.SQL.Clear;

   query.SQL.Text := 'UPDATE GENPARAM SET PRM_FLOAT = :dateNow WHERE PRM_ID = :PRM_ID';
   query.ParamByName('dateNow').AsFloat := Trunc(Now);
   query.ParamByName('PRM_ID').AsInteger := prm_id;
   query.ExecSQL;

   query.Close;

   transaction.Commit;
end;

end.
