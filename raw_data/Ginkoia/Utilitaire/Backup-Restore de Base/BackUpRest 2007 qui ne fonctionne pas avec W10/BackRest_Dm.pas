unit BackRest_Dm;

interface

uses
  SysUtils, DB, IBCustomDataSet, IBQuery, IBDatabase, Classes;

type
  TDm_BackRest = class(TDataModule)
    Database: TIBDatabase;
    tran: TIBTransaction;
    Qry: TIBQuery;
    Que_ParamSynchro: TIBQuery;
    Que_ParamSynchroPRM_STRING: TIBStringField;
    Que_ParamSynchroPRM_INTEGER: TIntegerField;
    Que_ParamSynchroPRM_ID: TIntegerField;
    Que_ParamSynchroPRM_FLOAT: TFloatField;
    Ib_LesBases: TIBQuery;
    Ib_LesBasesREP_PLACEEAI: TIBStringField;
    Ib_LesBasesREP_PLACEBASE: TIBStringField;
    qry_tables: TIBQuery;
    Que_ListeIndex: TIBQuery;
    Que_Tmp: TIBQuery;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    BuffersVal, PageSizeVal, SweepVal, BAS_ID, iNbRepSave: Integer;
    procedure set_GENERATOR_NUM_TMPTB();
    function GetGenParamInt(AType , ACode, APosId : Integer) : Integer;
    function GetBasID : Integer;
    function GetVersion : string ;
    function getGenParamBase(aNom: string; out aString: string;
      aFloat: Double): boolean;
    procedure setGenParamBase(aNom: string; const aString: string;
      aFloat: Double);
    procedure setHistoEvent(aType: Integer; aOK: boolean; aModule: string; aTime : TDateTime);
  end;

const
  CREPLICATIONOK = 2998;
  CLASTREPLIC    = 2999;

  CSYNCHROOK     = 3000;
  CLASTSYNC      = 3001;

  CWEBOK         = 3002;
	CLASTWEB       = 3003;

  CPFOK          = 3004;
  CLASTPF        = 3005;

  CBACKRESTOK    = 3006 ;
  CLASTBACKREST  = 3007 ;

  CBIOK          = 3008 ;
  CBASTBI        = 3009 ;


var
  Dm_BackRest: TDm_BackRest;

implementation

{$R *.dfm}

{ TDm_BackRest }

{ TDm_BackRest }

function TDm_BackRest.GetBasID: Integer;
begin
  Result := 0 ;
  try
    With Qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT BAS_ID FROM GENBASES');
      SQL.Add('  join K on K_ID = BAS_ID and K_Enabled = 1');
      SQL.Add('  Join GENPARAMBASE on BAS_IDENT = PAR_STRING');
      SQL.Add('WHERE PAR_NOM = ''IDGENERATEUR''');
      Open;

      Result := FieldByName('BAS_ID').AsInteger;
    end;
  except
  end;
end;

function TDm_BackRest.GetGenParamInt(AType, ACode, APosId: Integer): Integer;
begin
  Result := -1 ;

  With Qry do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT PRM_INTEGER FROM GENPARAM');
    SQL.Add('  Join K on K_ID = PRM_ID and K_enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_POS = :PPRMPOS');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := AType;
    ParamByName('PPRMCODE').AsInteger := ACode;
    ParamByName('PPRMPOS').AsInteger := APosId;
    Open;

    if not isEmpty
      then Result := FieldByName('PRM_INTEGER').AsInteger
      else Result := -1 ;

    Close;
  end;
end;

function TDm_BackRest.GetVersion: string;
begin
  Result := '' ;

  try
    With Qry do
    begin
      Close;
      SQL.Text := 'SELECT VER_VERSION FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1' ;
      Open;

      if not IsEmpty
        then Result := FieldByName('VER_VERSION').AsString;

      Close;
    end;
  except
  end;
end;

function TDm_BackRest.getGenParamBase(aNom : string ; out aString : string ; aFloat : Double) : boolean  ;
begin
  Result := false ;

  try
    Qry.Close ;
    Qry.SQL.Text := 'SELECT PAR_STRING, PAR_FLOAT FROM GENPARAMBASE ' +
                    'WHERE PAR_NOM = :NOM ' ;
    Qry.ParamCheck := True ;
    Qry.ParamByName('NOM').AsString := aNom ;

    Qry.Open ;

    if not Qry.IsEmpty then
    begin
      aString := Qry.FieldByName('PAR_STRING').AsString ;

      aFloat  := 0 ;
      if not Qry.FieldByName('PAR_FLOAT').IsNull
        then aFloat := Qry.FieldByName('PAR_FLOAT').AsFloat ;

      Result := True ;
    end;

  except
  end;
  Qry.Close ;
end;

procedure TDm_BackRest.setGenParamBase(aNom : string ; const aString : string ; aFloat : Double) ;
begin
  try
    Qry.Close ;
    Qry.SQL.Text := 'UPDATE GEENPARAMBASE ' +
                    'SET PAR_STRING = :STRING , PAR_FLOAT = :FLOAT ' +
                    'WHERE PAR_NOM = :NOM ' ;
    Qry.ParamCheck := True ;
    Qry.ParamByName('NOM').AsString := aNom ;
    Qry.ParamByName('STRING').AsString := aString ;
    Qry.ParamByName('FLOAT').AsFloat   := aFloat ;

    Qry.ExecSQL ;

    if Qry.RowsAffected = 0 then
    begin
      Qry.SQL.Text := 'INSERT INTO GENPARAMBASE (PAR_NOM, PAR_STRING, PAR_FLOAT) ' +
                      'VALUES (:NOM, :STRING, :FLOAT)' ;
      Qry.ParamCheck := True ;
      Qry.ParamByName('NOM').AsString := aNom ;
      Qry.ParamByName('STRING').AsString := aString ;
      Qry.ParamByName('FLOAT').AsFloat   := aFloat ;

      Qry.ExecSQL ;
    end;
  except
  end;
end;

procedure TDm_BackRest.set_GENERATOR_NUM_TMPTB();
var bIsPresent : boolean;
begin
  bIsPresent := false;
  Que_Tmp.Close ;
  Que_Tmp.SQL.Text := 'SELECT RDB$GENERATOR_NAME FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME=:NAME';
  Que_Tmp.ParamByName('NAME').Asstring := 'NUM_TMPTB';
  Que_Tmp.Open ;
  if not Que_Tmp.IsEmpty then
    begin
      bISPresent := true;
    end;
  Que_Tmp.Transaction.Commit ;
  //----------------------------------------------------------------------------
  if bISPresent then
    begin
      Que_Tmp.Close ;
      Que_Tmp.SQL.Text := 'SET GENERATOR NUM_TMPTB TO 1000;';
      Que_Tmp.ExecSQL;
    end;
end;

procedure TDm_BackRest.setHistoEvent(aType : Integer ; aOK : boolean ; aModule : string ; aTime : TDateTime) ;
var
  vHevId : Int64 ;
begin
  if BAS_ID = 0 then Exit ;

  Que_Tmp.Close ;

  Que_Tmp.SQL.Text := 'SELECT HEV_ID FROM GENHISTOEVT ' +
                      'JOIN K ON K_ID = HEV_ID AND K_ENABLED=1 ' +
                      'WHERE HEV_TYPE = :TYPE AND HEV_BASID = :BASID' ;
  Que_Tmp.ParamByName('TYPE').AsInteger := aType ;
  Que_Tmp.ParamByName('BASID').AsLargeInt := BAS_ID ;
  Que_Tmp.Open ;

  if not Que_Tmp.IsEmpty then
  begin
    vHevId := Que_Tmp.FieldByName('HEV_ID').AsLargeInt ;
    Que_Tmp.Close ;

    //Que_Tmp.Transaction.StartTransaction ;
    try
      Que_Tmp.SQL.Text := 'UPDATE GENHISTOEVT ' +
                          'SET HEV_DATE = CURRENT_TIMESTAMP, HEV_BASE = :BASE, HEV_MODULE = :MODULE, HEV_RESULT = :RESULT, HEV_TEMPS = :TIME ' +
                          'WHERE HEV_ID = :ID' ;
      Que_Tmp.ParamByName('ID').AsLargeInt := vHevId ;
      Que_Tmp.ParamByName('BASE').AsString   := Database.DatabaseName ;
      Que_Tmp.ParamByName('MODULE').AsString := aModule ;

      if aOk
        then Que_Tmp.ParamByName('RESULT').AsInteger := 1
        else Que_Tmp.ParamByName('RESULT').AsInteger := 0 ;

      Que_Tmp.ParamByName('TIME').AsDateTime := aTime ;

      Que_Tmp.ExecSQL ;

      Que_Tmp.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:ID, 0)' ;
      Que_Tmp.ParamByName('ID').AsLargeInt := vHevId ;

      Que_Tmp.ExecSQL ;

      Que_Tmp.Transaction.Commit ;
    except
      Que_Tmp.Transaction.Rollback ;
    end;
  end else begin
    Que_Tmp.Close ;

    //Que_Tmp.Transaction.StartTransaction ;
    try
      Que_Tmp.SQL.Text := 'INSERT INTO GENHISTOEVT ' +
                          '(HEV_ID, HEV_DATE, HEV_TYPE, HEV_MODULE, HEV_BASE, HEV_RESULT, HEV_TEMPS, HEV_BASID) ' +
                          'VALUES ((SELECT ID FROM PR_NEWK(''GENHISTOEVT'')), CURRENT_TIMESTAMP, :TYPE, :MODULE, :BASE, :RESULT, :TIME, :BASID)' ;
      Que_Tmp.ParamByName('BASE').AsString := Database.DatabaseName ;
      Que_Tmp.ParamByName('MODULE').AsString := aModule ;

      if aOk
        then Que_Tmp.ParamByName('RESULT').AsInteger := 1
        else Que_Tmp.ParamByName('RESULT').AsInteger := 0 ;

      Que_Tmp.ParamByName('TIME').AsDateTime := aTime ;
      Que_Tmp.ParamByName('BASID').AsLargeInt := BAS_ID ;
      Que_Tmp.ExecSQL ;

      Que_Tmp.Transaction.Commit ;
    except
      Que_Tmp.Transaction.Rollback ;
    end;
  end;

  Que_Tmp.Close ;
end;

end.
