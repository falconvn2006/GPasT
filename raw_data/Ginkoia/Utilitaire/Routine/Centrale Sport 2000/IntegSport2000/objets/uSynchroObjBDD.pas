unit uSynchroObjBDD;

interface

uses
  uGestionBDD, TypInfo, DB, SysUtils, Types, Classes;
  
type
  TTypeQry = (tqNone, tqSelect, tqUpdate, tqInsert);

  TMyObject = class(TPersistent)
  private 
    function getChamps(aPrefix : string; aTQ: TTypeQry = tqNone) : String;

   protected
    FId: integer;
    FTableName : string;
    FTrigram : string;
    FPrimaryKey : String;
    FExist : boolean;

   public
    constructor Create(aTableName, aTrigram, aPrimaryKey: String);   overload;
    procedure Assign(Source: TPersistent);   override;
    function doGetQry(aTQ : TTypeQry) : String ;
    procedure doLoad(aQuery : TMyQuery; aDefault: Boolean = true);   virtual;
    procedure doSave(aQuery : TMyQuery);
    function isExist : boolean;
    function getNewKId(aQuery: TMyQuery): integer;
    procedure updateK(aQuery: TMyQuery);

  published
     property Id: integer       read FId       write FId;
  end;

  procedure fillObjectWithQuery(aObject : TObject ; aQuery : TMyQuery ; aTrigram : string = '') ;
  procedure fillQueryWithObject(aObject : TObject ; aQuery : TMyQuery ; aPrefix : string = '') ;

  function strLastchar(aStr : string) : Char ;

implementation

uses
  uPrixVente;

const
  CST_QuerySelect = 'select %s from %s where %s=:id';
  CST_QueryInsert = 'INSERT INTO %s (%s) VALUES (%s)';
  CST_QueryUpdate = 'update %s set %s where %s=:id';

function strLastchar(aStr : string) : Char ;
begin
  if aStr = ''
    then Result := #0
    else Result := aStr[Length(aStr)] ;
end;

procedure fillObjectWithQuery(aObject: TObject; aQuery: TMyQuery; aTrigram: string);
var
  RTTI : Pointer ;
  PropList  : PPropList ;
  PropInfo  : PPropInfo ;
  nbProp    : integer ;
  ia        : integer ;
  sFieldName : string ;
  vField    : TField ;
const
  tkVars = [tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet, tkWChar, tkLString, tkWString, tkInt64] ;
begin
  if not Assigned(aObject)
    then Exit ;

  RTTI := aObject.ClassInfo ;
  try
    nbProp := GetPropList(RTTI, tkAny, nil);
    GetMem(PropList, nbProp * SizeOf(PPropInfo));
    GetPropList(RTTI, tkVars, PropList);
    for ia := 0 to nbProp - 1 do
    begin
      PropInfo := PropList^[ia] ;

      sFieldName := UpperCase(PropInfo^.Name) ;
      if strLastchar(sFieldName) = '_' then
        sFieldName := copy(sFieldName, 1 , Length(sFieldName) - 1 ) ;

      if aTrigram <> '' then
        sFieldName := aTrigram + '_' + sFieldName ;

      vField := aQuery.FindField(sFieldName) ;

      if Assigned(vField) then
      begin
        try
          if vField.IsNull then
          begin
            case PropInfo^.PropType^.Kind of
              tkInteger, tkChar, tkEnumeration, tkFloat : SetPropValue(aObject, PropInfo^.Name, 0) ;
              tkString, tkLString, tkWString : SetPropValue(aObject, PropInfo^.Name, '') ;
            end ;
          end else begin
            SetPropValue(aObject, PropInfo^.Name, vField.AsVariant) ;
          end;
        except
        end;
      end;
    end;
  finally
    FreeMem(PropList) ;
  end;
end;

procedure fillQueryWithObject(aObject: TObject; aQuery: TMyQuery; aPrefix: string);
var
  RTTI : Pointer ;
  PropList  : PPropList ;
  PropInfo  : PPropInfo ;
  nbProp    : integer ;
  ia        : integer ;
  sParamName : string ;
  vParam    : TParam ;
const
  tkVars = [tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet, tkWChar, tkLString, tkWString, tkInt64] ;
begin
  if not Assigned(aObject)
    then Exit ;

  RTTI := aObject.ClassInfo ;
  try
    GetMem(PropList, GetTypeData(RTTI)^.PropCount * SizeOf(Pointer)) ;
    nbProp := GetProplist(RTTI, tkVars, PropList) ;
    for ia := 0 to nbProp - 1 do
    begin
      PropInfo := PropList^[ia] ;

      sParamName := UpperCase(PropInfo^.Name) ;

      if strLastchar(sParamName) = '_' then
        sParamName := copy(sParamName, 1 , Length(sParamName) - 1 ) ;

      if aPrefix <> '' then
        sParamName := aPrefix + sParamName ;

      //vParam := aQuery.FindParam(sParamName) ;
      try
        vParam := aQuery.ParamByName(sParamName) ;
      except
        vParam := nil;
        //todo: log
      end;
      if Assigned(vParam) then
      begin
        vParam.Value := GetPropValue(aObject, PropInfo^.Name) ;
      end;
    end;
  finally
    FreeMem(PropList) ;
  end;
end;

{ TMyObject }

constructor TMyObject.Create(aTableName, aTrigram, aPrimaryKey: String);
begin
  inherited Create();

  FId := 0;
  FTableName := aTableName;
  FTrigram := aTrigram;
  FPrimaryKey := aPrimaryKey;
  FExist := false;
end;

procedure TMyObject.Assign(Source: TPersistent);
begin
  if Assigned(Source) and Source.InheritsFrom(TMyObject) then
  begin
    FId := TMyObject(Source).FId;
    FTableName := TMyObject(Source).FTableName;
    FTrigram := TMyObject(Source).FTrigram;
    FPrimaryKey := TMyObject(Source).FPrimaryKey;
    FExist := TMyObject(Source).FExist;
  end
  else
    inherited;
end;

procedure TMyObject.doLoad(aQuery: TMyQuery; aDefault: Boolean);
begin
  aQuery.Close;
  if aDefault then
  begin
    aQuery.SQL.Text := dogetQry(tqSelect);
    aQuery.ParamByName('id').AsInteger := FId;
  end;
  aQuery.open;
  fillObjectWithQuery(self, aQuery, FTrigram);
  FExist := (aQuery.RecordCount > 0);
end;

procedure TMyObject.doSave(aQuery: TMyQuery);
begin
  aQuery.Close;
  //sauvegarde
  if isExist then
  begin
    aQuery.SQL.Text := dogetQry(tqUpdate);
    aQuery.ParamByName('id').asinteger := FId; 
  end
  else
  begin
    //gestion du K
    FId := getNewKId(aQuery);
    aQuery.SQL.Text := dogetQry(tqInsert);
  end;
  //aQuery.ParamCheck:=true;
  fillQueryWithObject(self, aQuery, '');
  aQuery.ExecSQL;
  if not isExist then
  begin
    FExist := true;
  end
  else
  begin
    updateK(aQuery);
  end;
end;

function TMyObject.getChamps(aPrefix: string; aTQ: TTypeQry = tqNone): String;
var
  RTTI : Pointer ;
  PropList  : PPropList ;
  PropInfo  : PPropInfo ;
  nbProp    : integer ;
  ia        : integer ;
  sParamName : string ;
const
  tkVars = [tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet, tkWChar, tkLString, tkWString, tkInt64] ;
begin
  result := '';
  RTTI := Self.ClassInfo ;
  try
    GetMem(PropList, GetTypeData(RTTI)^.PropCount * SizeOf(Pointer)) ;
    nbProp := GetProplist(RTTI, tkVars, PropList) ;
    for ia := 0 to nbProp - 1 do
    begin
      PropInfo := PropList^[ia] ;

      sParamName := UpperCase(PropInfo^.Name) ;
      
      if strLastchar(sParamName) = '_' then
        sParamName := copy(sParamName, 1 , Length(sParamName) - 1 ) ;

      sParamName := aPrefix + sParamName ;

      if aTQ = tqUpdate then
        sParamName := sParamName + '=:' + UpperCase(PropInfo^.Name);

      if result <> '' then
        result := result + ', ';
      result := result + sParamName;

    end;

    if aTQ = tqinsert then
      result := FPrimaryKey + '=:id, ' + result;

  finally
    FreeMem(PropList) ;
  end;
end;

function TMyObject.isExist: boolean;
begin
  result := FExist;
end;

function TMyObject.doGetQry(aTQ: TTypeQry): String;
var
  sTrigramme : String;
begin
  // construction des query
  sTrigramme := FTrigram + '_';
  case aTQ of
    tqNone: result := '';
    tqUpdate : result := Format(CST_QueryUpdate, [FTableName, getChamps(sTrigramme, tqUpdate), FPrimaryKey]);
    tqInsert : result := Format(CST_QueryInsert, [FTableName, getChamps(sTrigramme), getChamps(':')]);
    tqSelect : result := Format(CST_QuerySelect, [getChamps(sTrigramme), FTableName, FPrimaryKey]);
  end;
end;


function TMyObject.getNewKId(aQuery: TMyQuery): integer;
begin
  aQuery.Close;
  aQuery.SQL.Text := 'select id from pr_newk(:tablename)';
  aQuery.ParamByName('tablename').AsString := self.FTableName;
  aQuery.open;
  Result := aQuery.FieldByName('ID').AsInteger;
end;

procedure TMyObject.updateK(aQuery: TMyQuery);
begin
  aQuery.Close;
  aQuery.SQL.Text := 'execute procedure pr_updatek(:id,0)';
  aQuery.ParamByName('id').AsInteger := self.FId;
  aQuery.ExecSQL;
end;

end.

