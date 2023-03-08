unit uKRange;

interface

uses Classes, Windows, SysUtils, StrUtils, Dialogs, IBDatabase, IBQuery, uLog;

type
  TKRange = class
  private
    FDatabase : String ;

    DataBase    : TIBDatabase ;
    Transaction : TIBTransaction ;
    Query       : TIBQuery ;
    lckQuery    : TRTLCriticalSection ;

    FOpened    : boolean ;

    FMin      : Int64 ;
    FMax      : Int64 ;
    FCurrent  : Int64 ;
    FBaseId   : Integer;

    function getRemain: Int64;
    function getRange : Int64;
    function getUsed: Single;

    procedure doGetBaseId ;
    procedure doGetCurrentK ;
    procedure doGetRange ;
    function getOk: boolean;

    function decodeRange(aRange : string ; var aMin, aMax : Int64) : boolean ;
  public
    constructor Create ;
    destructor Destroy ; override ;
    procedure Open(aBase : String) ;
    procedure Close ;
    function checkRange : boolean ;
  published
    property Min : Int64      read FMin ;
    property Max : Int64      read FMax ;
    property BaseId : Integer read FBaseId ;
    property Current : Int64  read FCurrent ;
    property Remain  : Int64  read getRemain ;
    property Used   : Single  read getUsed ;
    property Ok : boolean     read getOk ;
  end;

implementation

{ TKRange }
//==============================================================================
constructor TKRange.Create ;
begin
  inherited ;

  InitializeCriticalSection(lckQuery) ;

  FDatabase := '' ;
  Database    := TIBDatabase.Create(nil);
  Database.DatabaseName := FDatabase ;

  Transaction := TIBTransaction.Create(nil) ;
  Transaction.AddDatabase(Database) ;

  Query       := TIBQuery.Create(nil);
  Query.Database    := Database ;
  Query.Transaction := Transaction ;

  FOpened := false ;
  FMin       := 0 ;
  FMax       := 0 ;
  FCurrent   := 0 ;
  FBaseId    := -1 ;
end;
//------------------------------------------------------------------------------
function TKRange.decodeRange(aRange : string ; var aMin, aMax : Int64): boolean;
var
  iA, iB : integer ;
  sA, sB : string ;
  vMin, vMax  : Int64 ;
begin
    Result := false ;

    aRange := Trim(aRange) ;
    if aRange = ''        then Exit ;
    if Length(aRange) < 7 then Exit ;
    if aRange[1] <> '['   then Exit ;

    iA := Pos('_', aRange) ;
    if iA < 1
      then Exit ;

    sA := copy(aRange, 2, iA-2) ;
    sA := StringReplace(sA, 'K', '000', []) ;
    sA := StringReplace(sA, 'M', '000000', []) ;

    iB := PosEx(']', aRange, ia) ;
    if ib < 1
      then Exit ;

    sB := Copy(aRange, ia+1, ib - (ia+1)) ;
    sB := StringReplace(sB, 'K', '000', []) ;
    sB := StringReplace(sB, 'M', '000000', []) ;

    vMin := StrToIntDef(sA, -1) ;
    vMax := StrToIntDef(sB, -1) ;

    if (vMin >= 0) and (vMax >= 0) and (vMin < vMax) then
    begin
      aMin := vMin ;
      aMax := vMax ;
      Result := true ;
    end;
end;
//------------------------------------------------------------------------------
destructor TKRange.Destroy;
begin
  Query.Free ;
  Transaction.Free ;

  DeleteCriticalSection(lckQuery) ;

  inherited;
end;
//------------------------------------------------------------------------------
procedure TKRange.doGetBaseId;
begin
  EnterCriticalSection(lckQuery) ;
  try
    try
      Log.Log('uKRange', 'doGetBaseId', 'Log', 'select GENPARAMBASE (avant).', logDebug, True, 0, ltLocal);

      Query.Close ;
      Query.SQL.Text := 'SELECT PAR_STRING FROM GENPARAMBASE WHERE PAR_NOM=''IDGENERATEUR'' ' ;
      Query.Transaction.StartTransaction ;
      Query.Open;

      Log.Log('uKRange', 'doGetBaseId', 'Log', 'select GENPARAMBASE (après).', logDebug, True, 0, ltLocal);

      FBaseId := StrToIntDef(Query.FieldByName('PAR_STRING').AsString, -1) ;

      Query.Close ;
      Query.Transaction.Commit ;
    except
      On E:Exception do
      begin
        FBaseId := -1 ;
        //showMessage(E.Message) ;
      end;
    end;
  finally
    LeaveCriticalSection(lckQuery) ;
  end;
end;
//------------------------------------------------------------------------------
procedure TKRange.doGetCurrentK;
var
  aCurrentK : Int64 ;
begin
  EnterCriticalSection(lckQuery) ;
  try
    try
      Query.Close ;

      Query.Transaction.StartTransaction ;

      Log.Log('uKRange', 'doGetCurrentK', 'Log', 'select RDB$DATABASE (avant).', logDebug, True, 0, ltLocal);
      Query.SQL.Text := 'SELECT GEN_ID( general_id, 0 ) FROM RDB$DATABASE ;' ;
      Query.Open ;
      Log.Log('uKRange', 'doGetCurrentK', 'Log', 'select RDB$DATABASE (après).', logDebug, True, 0, ltLocal);

      if not Query.IsEmpty
        then aCurrentK := Query.FieldByName('GEN_ID').AsLargeInt ;

      Query.Close ;
      Query.Transaction.Commit ;

      FCurrent := aCurrentK ;
    except
    end;
  finally
    LeaveCriticalSection(lckQuery) ;
  end;
end;
//------------------------------------------------------------------------------
procedure TKRange.doGetRange;
var
  vRange : string ;
  vMin, vMax : Int64 ;
begin
  vMin := 0 ;
  vMax := 0 ;
  vRange := '' ;

  if FBaseId < 0
    then Exit ;

  EnterCriticalSection(lckQuery) ;
  try
    try
      Query.Close ;

      Query.Transaction.StartTransaction ;

      Log.Log('uKRange', 'doGetRange', 'Log', 'select GENBASES (avant).', logDebug, True, 0, ltLocal);

      Query.SQL.Clear ;
      Query.SQL.Add(  'SELECT BAS_PLAGE FROM GENBASES '
                    + 'JOIN K ON K_ID = BAS_ID AND K_ENABLED=1 '
                    + 'WHERE BAS_IDENT = :BASIDENT' ) ;
      Query.ParamByName('BASIDENT').AsInteger := FBaseId ;
      Query.Open;

      Log.Log('uKRange', 'doGetRange', 'Log', 'select GENBASES (après).', logDebug, True, 0, ltLocal);

      if not Query.IsEmpty then
        vRange := Query.FieldByName('BAS_PLAGE').AsString ;

      if decodeRange(vRange, vMin ,vMax) then
      begin
        FMin := vMin ;
        FMax := vMax ;
      end;

      Query.Close ;
      Query.Transaction.Commit ;
    except
    end;
  finally
    LeaveCriticalSection(lckQuery) ;
  end;
end;
//------------------------------------------------------------------------------
function TKRange.checkRange : boolean ;
begin

  doGetBaseId ;
  doGetRange ;
  doGetCurrentK ;

  Result := getOk ;
end;
//------------------------------------------------------------------------------
function TKRange.getOk: boolean;
begin
  Result := ((getUsed >=0) and (getUsed < 99)) ;
end;
//------------------------------------------------------------------------------
function TKRange.getRange: Int64;
begin
  Result := ((FMax-1) - FMin) ;
end;
//------------------------------------------------------------------------------
function TKRange.getRemain: Int64;
begin
  if (FMax < 1) then
  begin
    Result := 0 ;
    Exit ;
  end;

  Result := (FMax - FCurrent) ;
end;
//------------------------------------------------------------------------------
function TKRange.getUsed: Single;
var
  vRange  : Int64 ;
begin
  if vRange < 1 then
  begin
      Result := 100 ;
      Exit ;
  end;

  vRange  := getRange ;
  Result := (FCurrent - FMin)  / vRange * 100 ;
end;
//------------------------------------------------------------------------------
procedure TKRange.Open(aBase : String) ;
begin
  try
    DataBase.DatabaseName := aBase ;
    DataBase.Params.Clear ;
    DataBase.Params.Add('user_name=ginkoia') ;
    DataBase.Params.Add('password=ginkoia') ;
    DataBase.LoginPrompt := false ;
    DataBase.Open ;
  except
    Exit ;
  end;

  checkRange ;

  if FMin > 0 then
  begin
      FOpened := true ;
  end;
end;
//------------------------------------------------------------------------------
procedure TKRange.Close;
begin
    try
       DataBase.Close ;
    finally
       FOpened := false ;
    end;
end;
//==============================================================================
end.

