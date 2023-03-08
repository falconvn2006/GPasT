unit uUpdateDB;

interface

uses
  SysUtils, Windows, FireDAC.Comp.Client, uLauncherCommun;

Type
  TupdateDB = class
  private
    FBasId: integer;
    FDatabasePath: string;
    FError: string;

    procedure GetBasId();
    procedure ConnectToDatabase();
  public
    property BASID: integer read FBasId write FBasId;
    property DatabasePath: string read FDatabasePath write FDatabasePath;
    property Error: string read FError write FError;

    constructor Create(aDatabase: string; aBASID: integer = 0);
    destructor Destroy(); override;
    procedure UpdateGenParam(aType, aCode: integer; aValue: Variant; aTypeValue: TypeValue);
    procedure ExecQuery(aQuery: string);
    function IsPiccobatchAuto(aBasMagID: integer): Boolean;
    function SelectQuery(aQuery: string): Variant;
  end;

implementation

var
  vConn: TFDConnection;
  vTrans: TFDTransaction;

constructor TupdateDB.Create(aDatabase: string; aBASID: integer = 0);
begin
  vConn := TFDConnection.Create(nil);
  vTrans := TFDTransaction.Create(nil);
  vConn.Transaction := vTrans;

  DatabasePath := aDatabase;
  BASID := aBASID;
  Error := '';

  // on se connecte à la base et  récupère le basid si pas renseigné
  if DatabasePath <> '' then
  begin
    ConnectToDatabase();

    if BASID = 0 then
      GetBasId();
  end;
end;

destructor TupdateDB.Destroy();
begin
  vConn.Connected := false;
  vConn.DisposeOf;
  vTrans.DisposeOf;
end;

procedure TupdateDB.ConnectToDatabase();
begin
  vConn.Connected := false;

  vConn.Params.DriverID := 'IB';
  vConn.Params.Add('Server=Localhost');
  vConn.Params.Database := DatabasePath;
  vConn.Params.UserName := 'ginkoia';
  vConn.Params.Password := 'ginkoia';
  vConn.LoginPrompt := false;

  try
    vConn.Connected := true;
  except
    on E: Exception do
    begin
      Error := 'Connexion à la base impossible : ' + E.Message;
    end;
  end;
end;

procedure TupdateDB.GetBasId();
var
  vQuery: TFDQuery;
begin

  try
    vQuery := TFDQuery.Create(nil);
    try
      vQuery.Connection := vConn;

      // Recup du BAS_ID
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT BAS_ID FROM GENPARAMBASE        ');
      vQuery.SQL.Add(' JOIN GENBASES ON BAS_IDENT=PAR_STRING ');
      vQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
      vQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR''         ');
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        BASID := vQuery.FieldByName('BAS_ID').Asinteger;
      end;
      vQuery.Close;
    finally
      vQuery.Free;
    end;

  except
    on E: Exception do
      Error := 'Impossible de récupérer le BAS_ID dans la BDD : ' + E.Message;
  end;
end;

procedure TupdateDB.UpdateGenParam(aType, aCode: integer; aValue: Variant; aTypeValue: TypeValue);
var
  prm_id: integer;
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    TRY
      vQuery.Connection := vConn;
      prm_id := 0;

      // on récupère l'id du genparam pour le mettre à jour ainsi que son K
      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT PRM_ID FROM GENPARAM ');
      vQuery.SQL.Add('WHERE prm_type = :prm_type AND prm_code = :prm_code AND prm_pos = :BASID');
      vQuery.ParamByName('prm_type').Asinteger := aType;
      vQuery.ParamByName('prm_code').Asinteger := aCode;
      vQuery.ParamByName('BASID').AsLargeInt := BASID;
      vQuery.Open;
      if not(vQuery.IsEmpty) then
        prm_id := vQuery.FieldByName('PRM_ID').Asinteger;

      if (prm_id > 0) then
      begin
        vQuery.Close;
        vQuery.SQL.Clear;

        vQuery.SQL.Add('UPDATE GENPARAM SET ');
        case aTypeValue of
          TypeString:
            begin
              vQuery.SQL.Add('PRM_STRING = :param_value');
              vQuery.ParamByName('param_value').AsString := aValue;
            end;

          TypeInteger:
            begin
              vQuery.SQL.Add('PRM_INTEGER = :param_value');
              vQuery.ParamByName('param_value').Asinteger := aValue;
            end;

          TypeFloat:
            begin
              vQuery.SQL.Add('PRM_FLOAT = :param_value');
              vQuery.ParamByName('param_value').AsFloat := aValue;
            end;
        end;
        vQuery.SQL.Add('WHERE prm_id = :prm_id ');

        vQuery.ParamByName('prm_id').Asinteger := prm_id;
        vQuery.ExecSQL;

        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:k_id,0)';
        vQuery.ParamByName('k_id').AsLargeInt := prm_id;
        vQuery.ExecSQL;

        vQuery.Connection.Commit;
      end;
    EXCEPT
      on E: Exception do
      begin
        Error := 'Impossible mettre à jour le GENPARAM TYPE ' + IntToStr(aType) + ' CODE ' + IntToStr(aCode) + ' : ' + E.Message;
      end;
    end;
  finally
    vQuery.Free;
  end;
end;

function TupdateDB.IsPiccobatchAuto(aBasMagID: integer): Boolean;
var
  vQuery: TFDQuery;
begin
  Result := false;
  try
    vQuery := TFDQuery.Create(nil);
    try
      vQuery.Connection := vConn;

      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT lmp_id, LMP_PICCOECH, LMP_PICCORET ');
      vQuery.SQL.Add('FROM LOCMAGPARAM ');
      vQuery.SQL.Add('JOIN cshmodeenc ON men_id = lmp_menid ');
      vQuery.SQL.Add('WHERE lmp_magid = :BAS_MAGID AND lmp_id <> 0 AND lmp_piccoech = 1 AND lmp_piccoret = 1 ');
      vQuery.ParamByName('BAS_MAGID').AsLargeInt := aBasMagID;
      vQuery.Open;
      If (vQuery.RecordCount = 1) then
      begin
        Result := true;
      end;
      vQuery.Close;
    finally
      vQuery.Free;
    end;

  except
    on E: Exception do
      Error := 'Impossible de récupérer le paramétrage du lancement automatique de Piccobatch dans la BDD : ' + E.Message;
  end;
end;

procedure TupdateDB.ExecQuery(aQuery: string);
var
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    try
      vQuery.Connection := vConn;

      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add(aQuery);

      vQuery.ExecSQL;

      vQuery.Connection.Commit;

    EXCEPT
      on E: Exception do
      begin
        Error := 'Impossible d''exécuter la requête : ' + aQuery + ' : ' + E.Message;
      end;
    end;
  finally
    vQuery.Free;
  end;
end;

function TupdateDB.SelectQuery(aQuery: string): Variant;
var
  vQuery: TFDQuery;
begin
  Result := '';

  vQuery := TFDQuery.Create(nil);
  try
    try
      vQuery.Connection := vConn;

      vQuery.SQL.Clear();
      vQuery.SQL.Add(aQuery);
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        Result := vQuery.Fields[0].AsVariant;
      end;
      vQuery.Close;

    EXCEPT
      on E: Exception do
      begin
        Error := 'Impossible d''exécuter la requête de sélection : ' + aQuery + ' : ' + E.Message;
        Result := 'Impossible de se connecter à la base de données';
      end;
    end;
  finally
    vQuery.Free;
  end;
end;

end.
