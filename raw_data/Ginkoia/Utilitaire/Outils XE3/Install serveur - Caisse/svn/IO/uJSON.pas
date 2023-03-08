unit uJSON;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
interface

uses Classes, SysUtils, StrUtils, DateUtils, TypInfo, RTTI, Math ;

{$IFDEF NEXTGEN}
{$ELSE NEXTGEN}
{$ENDIF NEXTGEN}

//==============================================================================
// TJSONOption
//==============================================================================
// - joExportClassName  : Export "className" attribute in JSON output stream.
//                        Needed to handle object polymorphism
//
// TODO :
// - joStrictTypes      : Throw an exception when Object property and JSON
//                        attributes types does not match (Ex.: string / Integer)
// - joDateLocal        : Local dates are used
// - joDateTimeZone     : Dates are sent with timezone ([DATE]T[TIME]+/-[TIMEZONE])
//                        else dates are sent from UTC ([DATE]T[TIME]Z)
//==============================================================================


type
  PDoubleArray = ^DoubleArray ;
  DoubleArray = array[0..$effffff] of Double;

  TJSONOption = (joExportClassName, joStrictTypes, joDateLocal, joDateTimeZone) ;
  TJSONOptions = set of TJSONOption ;

type
  TJSON = class
  protected
    class var FJsonFormatSettings : TFormatSettings ;
  public
    //class var FShowClassName : boolean;				FL : @LM : Attention, avec cette modification, l'unité n'est plus thread safe ! Utiliser plutot TJSONOptions.

    class function createInstance(aClass: TClass): TObject; static;
    class function getClassByName(aClassName : string):TClass ;

    class function JSONToObject(aJSONStr : string ; var aObject ; aDefaultClass : TClass = nil) : boolean ; overload ;
    class function JSONToObject(aJSONStr : string ; var aObject : TObject ; aDefaultClass: TClass; var jsonPos : Integer) : boolean ; overload ;
    class function JSONToString(aJSONStr : string ; var jsonPos : Integer) : string ;
    class function JSONToOrd(aJSONStr : string ; var jsonPos : Integer) : Integer ;
    class function JSONToInt64(aJSONStr : string ; var jsonPos : Integer) : Int64 ;
    class function JSONToFloat(aJSONStr: string; var jsonPos: Integer): Double ;
    class function JSONToBool(aJSONStr : string ; var jsonPos : Integer) : Boolean ;
    class function JSONToNull(aJSONStr : string ; var jsonPos : Integer) : Boolean ;
    class function JSONToDynArray(aJSONStr: string; var jsonPos: Integer; var aArray : Pointer ; aTypeInfo: PTypeInfo) : boolean ;

    class function ObjectToJSON(aObject : TObject ; aDefaultClass : TClass = nil ; aJSONOptions : TJSONOptions = [joExportClassName]) : string ;
    class function DynArrayToJson(aArray : Pointer ; aTypeInfo:PTypeInfo ; aJSONOptions : TJSONOptions = [joExportClassName]) : string ;
    class function RecordToJson(aRecord : Pointer ; aTypeInfo:PTypeInfo ; aJSONOptions : TJSONOptions = [joExportClassName]) : string ;
    class function StringToJSON(aString : string) : string ;
    class function OrdToJSON(aInt : integer) : string ;
    class function Int64ToJSON(aInt64 : Int64) : string ;
    class function FloatToJSON(aFloat : Extended) : string ;
    class function CurrToJSON(aCurr : Currency) : string ;
    class function BoolToJSON(aBool : Boolean) : string ;
    class function escapeJsonString(aStr : string) : string ;

    class function ISO8601ToDateTime(aStr : string) : TDateTime ;

    class function getObjectJsonNodes(aJSONStr: string): TStringList; overload ;
    class function getObjectJsonNodes(aJSONStr: string; var aJsonPos:integer): TStringList; overload ;
    class function walkJSONObject(aJSONStr : string ; var aJsonPos:integer) : string ;
    class function walkJSONArray(aJSONStr : string ; var aJsonPos:integer) : string ;

    class function charAtPos(aString : string ; aPos : Integer) : Char ; inline ;
  end;

implementation
//==============================================================================
{ TJSON }
//==============================================================================
class function TJSON.DynArrayToJson(aArray: Pointer;
  aTypeInfo:PTypeInfo ; aJSONOptions : TJSONOptions = [joExportClassName]): string;
var
  arrayLen : Integer ;
  TypeData : PTypeData ;
  Bounds   : TBoundArray ;
  bFirst   : boolean ;
  bMulti   : boolean ;
  Size     : integer ;
  ia       : integer ;

{$IFDEF NEXTGEN}
{$ELSE NEXTGEN}
function DynArraySize(aArray : Pointer) : Integer ;
asm
   TEST  EAX, EAX
   JZ    @@exit
   MOV   EAX, [EAX-4]
   @@exit:
end;
{$ENDIF NEXTGEN}

begin
  bFirst := true ;
  Result := '[' ;

  TypeData := GetTypeData(aTypeInfo) ;
  bMulti   := ((TypeData^.elType <> nil) and (TypeData^.elType^^.Kind = tkDynArray)) ;
  size     := DynArraySize(aArray) ;

  for ia := 0 to size - 1 do
  begin
    if not bFirst
      then Result := Result + ',' ;

    if bMulti then
    begin
      Result := Result + DynArrayToJson(PPointerArray(aArray)[ia], TypeData^.elType^, aJSONOptions) ;
    end else begin
      case TypeData^.elType2^.Kind of
        tkInteger, tkChar, tkEnumeration, tkSet :
          begin
            if TypeData^.OrdType = otSByte then  Result := Result + IntToStr( PByteArray(aArray)[ia] ) ;
            if TypeData^.OrdType = otUByte then  Result := Result + IntToStr( PByteArray(aArray)[ia] ) ;
            if TypeData^.OrdType = otSWord then  Result := Result + IntToStr( PWordArray(aArray)[ia] ) ;
            if TypeData^.OrdType = otUWord then  Result := Result + IntToStr( PWordArray(aArray)[ia] ) ;
            if TypeData^.OrdType = otSLong then  Result := Result + IntToStr( PIntegerArray(aArray)[ia] ) ;
            if TypeData^.OrdType = otULong then  Result := Result + IntToStr( PIntegerArray(aArray)[ia] ) ;
          end;
        tkString, tkLString, tkUString :
          Result := Result + '"'+ escapeJsonString(String(PPointerArray(aArray)[ia])) +'"' ;

        tkWString :
{$IFDEF NEXTGEN}
          Result := Result + '"'+ escapeJsonString(String(PPointerArray(aArray)[ia])) +'"' ;
{$ELSE NEXTGEN}
          Result := Result + '"'+ escapeJsonString(WideString(PPointerArray(aArray)[ia])) +'"' ;
{$ENDIF NEXTGEN}
        tkClass :
          Result := Result + ObjectToJSON(PPointerArray(aArray)[ia], nil, aJSONOptions) ;
      end;
    end;

    bFirst := false ;
  end;

  Result := Result + ']' ;

end;
//------------------------------------------------------------------------------
class function TJSON.RecordToJson(aRecord: Pointer;
  aTypeInfo: PTypeInfo ; aJSONOptions : TJSONOptions = [joExportClassName]): string;
begin
  //TODO: Cette fonction n'est pas terminée.
  Result := '{' ;
{$IFDEF NEXTGEN}
    Result := Result + aTypeInfo^.NameFld.ToString ;
{$ELSE NEXTGEN}
    Result := Result + aTypeInfo^.Name ;
{$ENDIF NEXTGEN}

  Result := Result + '}' ;
end;
//------------------------------------------------------------------------------
class function TJSON.StringToJSON(aString: string): string;
begin
  Result := '"'+escapeJsonString(aString)+'"' ;
end;
//------------------------------------------------------------------------------
class function TJSON.getObjectJsonNodes(aJSONStr: string; var aJsonPos:integer) : TStringList ;
var
  vJsonLen : Integer ;
  vChar : char ;
  vInObject : boolean ;
  vInValue  : boolean ;
  vInitialPos : Integer ;
  vParam : string ;
  vValue : string ;
  ia : integer;
begin
  vInObject := false ;
  vInValue  := false ;
  vInitialPos := aJsonPos ;
  vJsonLen := Length(aJSONStr) ;

  Result := TStringList.Create ;

  while aJsonPos <= vJsonLen do
  begin
    vChar := charAtPos(aJsonStr, aJsonPos) ;

    if vInObject then
    begin
      if (vInValue) then
      begin
        case vChar of
          '"' : begin
                  vValue := JSONToString(aJSONStr, aJsonPos) ;
                  vInValue := false ;
                end;
          '{' : begin
                  vValue := walkJSONObject(aJsonStr, aJsonPos) ;
                  vInValue := false ;
                end;
          '[' : begin
                  vValue := walkJSONArray(aJsonStr, aJsonPos) ;
                  vInValue := false ;
                end;
          ',' : begin
                  vInValue := false ;
                end;
          '}' : begin
                  vInValue := false ;
                  Dec(aJsonPos) ;
                end;
          else vValue := vValue + vChar ;
        end;

        if (not vInValue) then
        begin
          ia := Result.Add(vParam + '=' + vValue) ;
        end;

      end else begin
        case vChar of
          '"' : begin
                  vParam := JSONToString(aJSONStr, aJsonPos) ;
                  vValue := '' ;
                end;
          ':' : begin
                  vInValue := true ;
                end;
          ',' : begin
                  vInValue := false ;
                end;
          '}' : begin
                  Exit;
                end;
        end;
      end;
    end else begin
      if (vChar = '{')
        then vInObject := true
        else raise Exception.Create('Object structure error');
    end;

    Inc(aJsonPos) ;
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.walkJSONArray(aJSONStr: string; var aJsonPos:integer): string;
var
  vJsonLen : Integer ;
  vChar : char ;
  vInArray : boolean ;
  vInitialPos : Integer ;
begin
  Result := '' ;
  vInArray := false ;
  vInitialPos := aJsonPos ;
  vJsonLen := Length(aJSONStr) ;

  while aJsonPos <= vJsonLen do
  begin
    vChar := charAtPos(aJsonStr, aJsonPos) ;

    if vInArray then
    begin
      begin
        case vChar of
          '"' : begin
                  JSONToString(aJSONStr, aJsonPos) ;
                end;
          '{' : begin
                  walkJSONObject(aJsonStr, aJsonPos) ;
                end;
          '[' : begin
                  walkJSONArray(aJsonStr, aJsonPos) ;
                end;
          ']' : begin
                  Result := copy(aJSONStr, vInitialPos, aJsonPos - vInitialPos + 1) ;
                  Exit;
                end;
        end;
      end;
    end else begin
      if (vChar = '[')
        then vInArray := true
        else raise Exception.Create('Array structure error');
    end;

    Inc(aJsonPos) ;
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.walkJSONObject(aJSONStr: string; var aJsonPos:integer): string;
var
  vJsonLen : Integer ;
  vChar : char ;
  vInObject : boolean ;
  vInValue  : boolean ;
  vInitialPos : Integer ;
begin
  Result := '' ;
  vInObject := false ;
  vInValue  := false ;
  vInitialPos := aJsonPos ;
  vJsonLen := Length(aJSONStr) ;

  while aJsonPos <= vJsonLen do
  begin
    vChar := charAtPos(aJsonStr, aJsonPos);

    if vInObject then
    begin
      if (vInValue) then
      begin
        case vChar of
          '"' : begin
                  JSONToString(aJSONStr, aJsonPos) ;
                  vInValue := false ;
                end;
          '{' : begin
                  walkJSONObject(aJsonStr, aJsonPos) ;
                  vInValue := false ;
                end;
          '[' : begin
                  walkJSONArray(aJsonStr, aJsonPos) ;
                  vInValue := false ;
                end;
          ',' : begin
                  vInValue := false ;
                end;
          '}' : begin
                  vInValue := false ;
                  Dec(aJsonPos) ;
                end;
        end;
      end else begin
        case vChar of
          '"' : begin
                  JSONToString(aJSONStr, aJsonPos) ;
                end;
          ':' : begin
                  vInValue := true ;
                end;
          ',' : begin
                  vInValue := false ;
                end;
          '}' : begin
                  Result := copy(aJSONStr, vInitialPos, aJsonPos - vInitialPos + 1) ;
                  Exit;
                end;
        end;
      end;
    end else begin
      if (vChar = '{')
        then vInObject := true
        else raise Exception.Create('Object structure error');
    end;

    Inc(aJsonPos) ;
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.escapeJsonString(aStr: string): string;
var
  ia : integer ;
  vChar : Char ;
begin
  Result := '' ;

  for ia := 1 to Length(aStr) do
  begin
    vChar := charAtPos(aStr,ia) ;
    case vChar of
    '/', '\', '"' :       Result := Result + '\' + vChar ;
    #8            :       Result := Result + '\b' ;
    #9            :       Result := Result + '\t' ;
    #10           :       Result := Result + '\n' ;
    #12           :       Result := Result + '\f' ;
    #13           :       Result := Result + '\r' ;
    else
      if ((ord(vChar) < 32) or (ord(vChar) > 127))
        then Result := Result + '\u' + intToHex(ord(vChar), 4)
        else Result := Result + vChar ;
    end;
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.charAtPos(aString: string; aPos: Integer): Char;
var
  vChar : Char ;
begin
{$IFDEF NEXTGEN}
    vChar := aString[aPos-1];
{$ELSE NEXTGEN}
    vChar := aString[aPos];
{$ENDIF NEXTGEN}

    result := vChar ;
end;
//------------------------------------------------------------------------------
class function TJSON.createInstance(aClass : TClass) : TObject ;
var
  vContext  : TRttiContext ;
  vType     : TRttiType;
  vMethod   : TRttiMethod ;
  vValue    : TValue ;
begin
  Result := nil ;
  vContext := TRttiContext.Create ;
  try
    vType := vContext.GetType(aClass) ;
    if not Assigned(vType)
      then Exit ;

    vMethod := vType.GetMethod('Create') ;
    if not Assigned(vMethod)
      then Exit ;

    if Length(vMethod.GetParameters) > 0
      then vValue  := vMethod.Invoke(vType.AsInstance.MetaclassType, [nil])
      else vValue  := vMethod.Invoke(vType.AsInstance.MetaclassType, []) ;
    Result  := TObject(vValue.AsObject) ;
  finally
    vContext.Free ;
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.getClassByName(aClassName: string): TClass;
var
  vContext  : TRttiContext ;
  vType     : TRttiType;
begin
  Result := nil ;

  vContext := TRttiContext.Create ;
  try
    vType := vContext.FindType(aClassName) ;
    if Assigned(vType) then
      Result := vType.AsInstance.MetaclassType ;
  finally
    vContext.Free ;
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.getObjectJsonNodes(aJSONStr: string): TStringList;
var
  vPos : Integer ;
begin
  vPos := 1 ;
  Result := getObjectJsonNodes(aJSONStr, vPos) ;
end;
//------------------------------------------------------------------------------
class function TJSON.Int64ToJSON(aInt64: Int64): string;
begin
  Result := IntToStr(aInt64) ;
end;
//------------------------------------------------------------------------------
class function TJSON.FloatToJSON(aFloat: Extended): string;
begin
  Result := FloatToStr(aFloat, FJsonFormatSettings) ;
end;
//------------------------------------------------------------------------------
class function TJSON.OrdToJSON(aInt: integer): string;
begin
  Result := IntToStr(aInt) ;
end;
//------------------------------------------------------------------------------
class function TJSON.CurrToJSON(aCurr: Currency): string;
begin
  Result := CurrToStr(aCurr, FJsonFormatSettings) ;
end;
//------------------------------------------------------------------------------
class function TJSON.BoolToJSON(aBool: Boolean): string;
begin
  if aBool
    then Result := 'true'
    else Result := 'false' ;

end;
//------------------------------------------------------------------------------
class function TJSON.ISO8601ToDateTime(aStr: string): TDateTime;
var
  ia, ib : integer ;
  sDate  : string  ;
  sTime  : string  ;
  fDate  : Double  ;
  fTime  : Double  ;

  y,m,d : integer ;
  h,n,s,z : integer ;

begin
  Result := 0 ;

  ia := pos('T', aStr) ;
   if ia = 0 then
    ia := pos(' ', aStr);
  ib := pos('Z', aStr) ;

  if ia > 0 then
  begin
    sDate := copy(aStr, 1, ia-1) ;
    if ib > 0
      then sTime := copy(aStr, ia+1, ib-ia-1)
      else sTime := copy(aStr, ia+1, Length(aStr)-ia) ;
  end else begin
    sDate := copy(aStr, 1, 10) ;
    sTime := '' ;
  end;

  y := StrToInt(Copy(sDate,1,4)) ;
  m := StrToInt(Copy(sDate,6,2)) ;
  d := StrToInt(Copy(sDate,9,2)) ;

  h := StrToIntDef(Copy(sTime,1,2),0) ;
  n := StrToIntDef(Copy(sTime,4,2),0) ;
  s := StrToIntDef(Copy(sTime,7,2),0) ;
  z := StrToIntDef(Copy(sTime,10,3),0) ;

  fDate := DateUtils.EncodeDateTime(y,m,d,h,n,s,z) ;

  Result := fDate ;
end;
//------------------------------------------------------------------------------
class function TJSON.JSONToObject(aJSONStr: string ; var aObject : TObject ; aDefaultClass:TClass ; var jsonPos : integer): boolean ;
var
  jsonLen       : integer ;
  jsonPos2      : integer ;
  jsonChar      : char ;
  bInObject     : boolean ;
  bInValue      : boolean ;
  bInClassName  : boolean ;
  currentProp   : PPropInfo ;
  PropList      : PPropList ;
  PropCount     : integer ;
  TypeInfo      : PTypeInfo ;
  sStr          : string ;

  fA            : Extended ;
  iA            : Integer ;
  iB            : Int64 ;
  bA            : boolean ;
  cClass        : TClass ;
  oObj          : TObject ;
  pDynArray     : Pointer ;
  vDate         : TDateTime ;

  function findPropInfo(aPropName : string) : PPropInfo ;
  var
    ia : integer ;
  begin
    Result := nil ;
    for ia:= 0 to PropCount - 1 do
    begin
{$IFDEF NEXTGEN}
      if uppercase(PropList^[ia]^.NameFld.ToString) = uppercase(aPropName) then
      begin
        Result := PropList^[ia] ;
        break ;
      end;
{$ELSE NEXTGEN}
      if uppercase(PropList^[ia]^.Name) = uppercase(aPropName) then
      begin
        Result := PropList^[ia] ;
        break ;
      end;
{$ENDIF NEXTGEN}
    end;
  end;

begin
  Result := False;
  jsonLen := Length(aJSONStr) ;
  bInObject := false ;  bInValue := false ; bInClassName := false ;
  TypeInfo := nil ; PropCount := 0 ; currentProp := nil;

  getMem(PropList, sizeOf(TPropList)) ;
  try
    while jsonPos <= jsonLen do
    begin
      jsonChar := charAtPos(aJsonStr, jsonPos) ;

      if not bInObject then
      begin

        case jsonChar of
          '{' : begin
                  bInObject := true ;
                  if Assigned(aObject) then
                  begin
                    TypeInfo  := aObject.ClassInfo ;
                    PropCount := GetPropList(TypeInfo, tkAny, PropList) ;
                  end else begin
                    if Assigned(aDefaultClass) then
                    begin
                      TypeInfo  := aDefaultClass.ClassInfo;
                      PropCount := GetPropList(TypeInfo, tkAny, PropList) ;
                    end ;
                  end ;
                end;
          ' ' : begin
                end ;
          else raise Exception.Create('Object structure error');
        end;

      end else begin
        if bInValue then
        begin
          if ((not Assigned(aObject)) and (bInClassName)) then
          begin
            sStr := JSONToString(aJSONStr, jsonPos) ;
            cClass := getClassByName(sStr) ;
            if Assigned(cClass) then
            begin
              if (not Assigned(aDefaultClass)) or (cClass.InheritsFrom(aDefaultClass)) then
              begin
                aObject := TObject(cClass.NewInstance) ;
                TypeInfo  := aObject.ClassInfo ;
                PropCount := GetPropList(TypeInfo, tkAny, PropList) ;
              end ;
            end ;

            bInClassName := false ;
            bInValue := false ;
          end else begin

            if (not Assigned(aObject)) then
            begin
              cClass := aDefaultClass ;
              if Assigned(cClass) then
              begin
                aObject := TObject(cClass.NewInstance) ;
                TypeInfo  := aObject.ClassInfo ;
                PropCount := GetPropList(TypeInfo, tkAny, PropList) ;
              end ;
            end ;


            case jsonChar of
              '"' : begin
                      sStr := JSONToString(aJSONStr, jsonPos) ;

                      if Assigned(currentProp) then
                      begin
                        case currentProp^.PropType^.Kind of
                          tkString, tkLString, tkUString :
                            SetStrProp(aObject, currentProp, sStr);
                          tkFloat :
                            begin
{$IFDEF NEXTGEN}
                              if currentProp^.PropType^^.NameFld.ToString = 'TDateTime' then
                              begin
                                vDate := ISO8601ToDateTime(sStr) ;
                                SetFloatProp(aObject, currentProp, Double(vDate)) ;
                              end;
                              if currentProp^.PropType^^.NameFld.ToString = 'TDate' then
                              begin
                                vDate := ISO8601ToDateTime(sStr) ;
                                SetFloatProp(aObject, currentProp, Double(vDate)) ;
                              end;
                              if currentProp^.PropType^^.NameFld.ToString = 'TTime' then
                              begin
                                vDate := ISO8601ToDateTime(sStr) ;
                                SetFloatProp(aObject, currentProp, Double(vDate)) ;
                              end;
{$ELSE NEXTGEN}
                              if currentProp^.PropType^^.Name = 'TDateTime' then
                              begin
                                vDate := ISO8601ToDateTime(sStr) ;
                                SetFloatProp(aObject, currentProp, Double(vDate)) ;
                              end;
                              if currentProp^.PropType^^.Name = 'TDate' then
                              begin
                                vDate := ISO8601ToDateTime(sStr) ;
                                SetFloatProp(aObject, currentProp, Double(vDate)) ;
                              end;
                              if currentProp^.PropType^^.Name = 'TTime' then
                              begin
                                vDate := ISO8601ToDateTime(sStr) ;
                                SetFloatProp(aObject, currentProp, Double(vDate)) ;
                              end;
{$ENDIF NEXTGEN}
                            end;
                        end;
                      end;

                      bInValue := false ;
                    end ;
              '0'..'9','.','-','f','t','n' :
                    begin
                      if Assigned(currentProp) then
                      begin
                        case currentProp^.PropType^.Kind of
                          tkInteger : begin
                                        if (aJSONStr[jsonPos] = 'n') then // null
                                          begin
                                            JSONToNull(aJSONStr, jsonPos);
                                            SetOrdProp(aObject, currentProp, 0);
                                            bInValue := false ;
                                          end
                                        else
                                          begin
                                           iA := JSONToOrd(aJSONStr, jsonPos) ;
                                           SetOrdProp(aObject, currentProp, iA);
                                           bInValue := false ;
                                          end ;
                                      end;
                          tkInt64 :   begin
                                        if (aJSONStr[jsonPos] = 'n') then // null
                                          begin
                                            JSONToNull(aJSONStr, jsonPos);
                                            SetInt64Prop(aObject, currentProp, 0);
                                            bInValue := false ;
                                          end
                                        else
                                          begin
                                              iB := JSONToInt64(aJSONStr, jsonPos) ;
                                              SetInt64Prop(aObject, currentProp, iB);
                                              bInValue := false ;
                                          end ;
                                      end;
                          tkFloat :   begin
                                        if (aJSONStr[jsonPos] = 'n') then // null
                                          begin
                                            JSONToNull(aJSONStr, jsonPos);
                                            SetFloatProp(aObject, currentProp, 0);
                                            bInValue := false ;
                                          end
                                        else
                                          begin
                                            fA := JSONToFloat(aJSONStr, jsonPos) ;
                                            SetFloatProp(aObject, currentProp, fA);
                                            bInValue := false ;
                                          end;
                                      end ;
                          tkEnumeration :
                                      begin
                                        if ((aJSONStr[jsonPos] = 'f') or (aJSONStr[jsonPos] = 't')) then
                                        begin
                                          bA := JSONToBool(aJSONStr, jsonPos) ;
                                          if bA
                                            then SetEnumProp(aObject, currentProp, 'true')
                                            else SetEnumProp(aObject, currentProp, 'false') ;
                                        end else if (aJSONStr[jsonPos] = 'n') then
                                        begin
                                          JSONToNull(aJSONStr, jsonPos) ;
                                          SetEnumProp(aObject, currentProp, 'false') ;
                                        end else begin
                                          iA := JSONToOrd(aJSONStr, jsonPos) ;
                                          SetOrdProp(aObject, currentProp, iA);
                                        end ;
                                        bInValue := false ;
                                      end ;
                          tkClass :
                            begin
                              if (aJSONStr[jsonPos] = 'n') then // null
                              begin
                                JSONToNull(aJSONStr, jsonPos);
                                SetObjectProp(aObject, currentProp, nil);
                                bInValue := false ;
                              end;
                            end;
                          tkString, tkLString, tkUString :
                            begin
                              if (aJSONStr[jsonPos] = 'n') then // null
                              begin
                                JSONToNull(aJSONStr, jsonPos);
                                SetStrProp(aObject, currentProp, '');
                                bInValue := false ;
                              end;
                            end;
                        end ;
                      end else begin
                        if ((aJSONStr[jsonPos] = 'f') or (aJSONStr[jsonPos] = 't')) then
                        begin
                          bA := JSONToBool(aJSONStr, jsonPos)
                        end else if (aJSONStr[jsonPos] = 'n') then
                        begin
                          bA := JSONToNull(aJSONStr, jsonPos)
                        end else begin
                          iA := JSONToOrd(aJSONStr, jsonPos);
                        end ;

                        bInValue := False ;
                      end;
                    end ;

              '{':  begin

                      if Assigned(currentProp) then
                      begin
                        case currentProp^.PropType^.Kind of
                          tkClass : begin
                                      cClass := GetTypeData(currentProp^.PropType^).ClassType ;

                                      oObj := nil ;
                                      oObj := TObject(GetObjectProp(aObject, currentProp, TObject)) ;
                                      JSONToObject(aJSONStr, oObj, cClass, jsonPos) ;
                                      SetObjectProp(aObject, currentProp, oObj);
                                    end ;
                          tkString, tkLString, tkUString :
                                    begin
//                                      jsonPos2 := jsonPos ;
//                                      oObj := TObject(TObject.NewInstance) ;
//                                      JSONToObject(aJSONStr, oObj, nil, jsonPos) ;
//                                      sStr := Copy(aJSONStr, jsonPos2, jsonPos - jsonPos2 + 1) ;
//                                      SetStrProp(aObject, currentProp, sStr);
//                                      oObj.Free ;

                                      sStr := walkJSONObject(aJSONStr, jsonPos) ;
                                      SetStrProp(aObject, currentProp, sStr);
                                    end;
                        end ;

                      end else begin
                          // consume json
                          oObj := TObject(TObject.NewInstance) ;
                          JSONToObject(aJSONStr, oObj, nil, jsonPos) ;
                          oObj.Free ;
                      end;
                      bInValue := False ;
                    end ;
              '[':  begin
                      if Assigned(currentProp) then
                      begin
                        case currentProp^.PropType^.Kind of
                          tkDynArray :  begin
                                        pDynArray := GetDynArrayProp(aObject, currentProp) ;
                                        JSONToDynArray(aJSONStr, jsonPos, pDynArray, currentProp^.PropType^) ;
                                        SetDynArrayProp(aObject, currentProp, pDynArray);
                                        end ;
                          tkString, tkLString, tkUString :
                                    begin
                                      pDynArray := nil ;
                                      jsonPos2 := jsonPos ;
                                      JSONToDynArray(aJSONStr, jsonPos, pDynArray, currentProp^.PropType^) ;
                                      sStr := Copy(aJSONStr, jsonPos, jsonPos - jsonPos2 + 1) ;
                                      SetStrProp(aObject, currentProp, sStr);
                                    end;
                        end;

                      end else begin
                          pDynArray := nil ;
                          JSONToDynArray(aJSONStr, jsonPos, pDynArray, nil) ;
                      end;
                      bInValue := False ;
                    end ;

            end; // case
          end ;
        end else begin // bInValue
          case jsonChar of
            '"' : begin
                    sStr := JSONToString(aJSONStr, jsonPos) ;
                    if (sStr = 'className') then
                    begin
                      bInClassName := true ;
                      currentProp := nil ;
                    end else begin
                      currentProp := findPropInfo(sStr) ;
                    end ;
                  end ;
            ':' : begin
                    bInValue    := true ;
                  end ;
            ',' : begin
                    bInValue    := false ;
                    currentProp := nil ;
                  end ;
            '}' : begin
                  Result := true ;
                    Exit ;
                  end ;
          end; // Case
        end ;

      end;

      Inc(jsonPos) ;
    end;

  finally
    freeMem(PropList) ;
  end ;
end;
//------------------------------------------------------------------------------
class function TJSON.JSONToOrd(aJSONStr: string; var jsonPos: Integer): Integer;
var
  jsonLen   : integer ;
  jsonChar  : char ;
  sStr      : string ;
begin
  Result := 0;
  jsonLen   := Length(aJsonStr) ;
  sStr := '' ;

  while jsonPos <= jsonLen do
  begin
    jsonChar := aJsonStr[jsonPos] ;

    case jsonChar of
      '0'..'9','.','-' : begin
                      sStr := sStr + jsonChar ;
                     end ;

      else begin
        Dec(jsonPos) ;
        Result := StrToIntDef(sStr, 0) ;
        Break ;
      end;
    end;

    Inc(jsonPos) ;
  end ;
end;
//------------------------------------------------------------------------------
class function TJSON.JSONToBool(aJSONStr: string;
  var jsonPos: Integer): Boolean;
var
  sStr      : string ;
begin
  sStr := '' ;

  Result := false ;

  if (copy(aJSONStr, jsonPos, 4) = 'true') then
  begin
    Result := true ;
    Inc(jsonPos,3) ;
  end;

  if (copy(aJSONStr, jsonPos, 5) = 'false') then
  begin
    Result := false ;
    Inc(jsonPos,4) ;
  end;

end;
//------------------------------------------------------------------------------
class function TJSON.JSONToNull(aJSONStr: string;
  var jsonPos: Integer): Boolean;
var
  sStr      : string ;
begin
  sStr := '' ;

  Result := false ;

  if (copy(aJSONStr, jsonPos, 4) = 'null') then
  begin
    Result := true ;
    Inc(jsonPos,3) ;
  end;

end;
//------------------------------------------------------------------------------
class function TJSON.JSONToDynArray(aJSONStr: string; var jsonPos: Integer;
  var aArray : Pointer ; aTypeInfo: PTypeInfo) : boolean ;
var
  jsonLen   : integer ;
  jsonChar  : char ;
  TypeData  : PTypeData ;
  sStr      : string ;
  bInArray  : boolean ;
  oObj      : TObject ;
  ia, ib    : integer ;
  Len       : LongInt ;
  vDateTime : TDateTime ;
  pStr      : PString ;
  cClass    : TClass ;
begin
  Result := False;
  TypeData := nil ;
  if Assigned(aTypeInfo)
    then TypeData := GetTypeData(aTypeInfo) ;

  bInArray := false ;

  ia := 0 ;
  jsonLen := Length(aJSONStr) ;

  while jsonPos <= jsonLen do
  begin
    jsonChar := charAtPos(aJsonStr, jsonPos) ;

    if not bInArray then
    begin
      case jsonChar of
        '[' : bInArray := true ;
        else raise Exception.Create('Array structure error');
      end;
    end else begin

      case jsonChar of
        ']' : Exit ;
        '"' : begin
                sStr := JSONToString(aJSONStr, jsonPos) ;
                if Assigned(TypeData) then
                begin
                  case TypeData^.elType2^^.Kind of
                      tkString , tkLString, tkUString :
                        begin
                          Len := ia+1 ;
                          DynArraySetLength(aArray, aTypeInfo, 1, @Len);
                          New(pStr) ;
                          pStr^ := sStr ;
                          PPointerArray(aArray)^[ia] := Pointer(pStr^) ;
                          Inc(ia) ;
                        end;
                      tkFloat :
                        begin
{$IFDEF NEXTGEN}
                          if TypeData^.elType2^^.NameFld.ToString = 'TDateTime' then
                          begin
                            vDateTime := ISO8601ToDateTime(sStr) ;
                            PDoubleArray(aArray)^[ia] := Double(vDateTime) ;
                          end;
{$ELSE NEXTGEN}
                          if TypeData^.elType2^^.Name = 'TDateTime' then
                          begin
                            vDateTime := ISO8601ToDateTime(sStr) ;
                            PDoubleArray(aArray)^[ia] := Double(vDateTime) ;
                          end;
{$ENDIF NEXTGEN}
                        end;
                  end;
                end;
              end;
        '{' : begin
                if Assigned(TypeData) then
                begin
                  case TypeData^.elType2^^.Kind of
                      tkClass :
                        begin
                          cClass := GetTypeData(TypeData^.elType2^).ClassType ;
                          //oObj := TObject(cClass.NewInstance) ;
                          oObj := nil ;
                          JSONToObject(aJSONStr, oObj, cClass, jsonPos) ;

                          Len := ia+1 ;
                          DynArraySetLength(aArray, aTypeInfo, 1, @Len);
                          PPointerArray(aArray)^[ia] := Pointer(oObj) ;
                          Inc(ia) ;
                        end;
                      tkString , tkLString, tkUString :
                        begin
                          cClass := TObject ;
                          oObj := TObject(cClass.NewInstance) ;
                          ib := jsonPos ;
                          JSONToObject(aJSONStr, oObj, nil, jsonPos) ;
                          sStr := copy(aJSONStr, ib, jsonPos - ib + 1) ;
                          oObj.Free ;

                          Len := ia+1 ;
                          DynArraySetLength(aArray, aTypeInfo, 1, @Len);
                          New(pStr) ;
                          pStr^ := sStr ;
                          PPointerArray(aArray)^[ia] := Pointer(pStr^) ;
                          Inc(ia) ;
                        end;
                  end;
                end else begin
                  // consume Json
                  oObj := TObject.Create ;
                  JSONToObject(aJSONStr, oObj, nil, jsonPos) ;
                  oObj.Free ;
                end;
              end ;
      end; // case

    end;

    Inc(jsonPos);
  end ;
end;
//------------------------------------------------------------------------------
class function TJSON.JSONToInt64(aJSONStr: string; var jsonPos: Integer): Int64;
var
  jsonLen   : integer ;
  jsonChar  : char ;
  sStr      : string ;
begin
  Result := 0;
  jsonLen   := Length(aJsonStr) ;
  sStr := '' ;

  while jsonPos <= jsonLen do
  begin
    jsonChar := charAtPos(aJsonStr, jsonPos) ;

    case jsonChar of
      '0'..'9','.','-' : begin
                      sStr := sStr + jsonChar ;
                     end ;

      else begin
        Dec(jsonPos) ;
        Result := StrToIntDef(sStr, 0) ;
        Exit ;
      end;
    end;

    Inc(jsonPos) ;
  end ;
end;
//------------------------------------------------------------------------------
class function TJSON.JSONToFloat(aJSONStr: string; var jsonPos: Integer): Double ;
var
  jsonLen   : integer ;
  jsonChar  : char ;
  sStr      : string ;
begin
  Result := 0;
  jsonLen   := Length(aJsonStr) ;
  sStr := '' ;

  while jsonPos <= jsonLen do
  begin
    jsonChar := charAtPos(aJsonStr, jsonPos) ;

    case jsonChar of
      '0'..'9','.','-' : begin
                      sStr := sStr + jsonChar ;
                     end ;

      else begin
        Dec(jsonPos) ;
        Result := StrToFloatDef(sStr, 0, FJsonFormatSettings) ;
        Exit ;
      end;
    end;

    Inc(jsonPos) ;
  end ;
 end;
//------------------------------------------------------------------------------
class function TJSON.JSONToString(aJSONStr: string; var jsonPos: Integer): string;
var
  jsonLen   : integer ;
  jsonChar  : char ;
  bInString : boolean ;
  bEscaped  : boolean ;
  bEscapeHex: boolean ;
  sHexStr   : string ;
  sStr      : string ;

begin
  jsonLen   := Length(aJsonStr) ;
  bInString := false ;
  bEscaped  := false ;
  bEscapeHex := false ;

  Result := '' ; sStr := '' ;

  while jsonPos <= jsonLen do
  begin
    jsonChar := charAtPos(aJsonStr, jsonPos) ;

    if not bInString then
    begin
      case jsonChar of
        '"' : bInString := true ;
        ' ' : ;
        else raise Exception.Create('String structure error');
      end;
    end else begin
      if bEscaped then
      begin
        if bEscapeHex  then
        begin
          if (Length(sHexStr) < 4) and (upCase(jsonChar) in ['0'..'9','A'..'F']) then
          begin
            sHexStr := sHexStr + jsonChar ;
            if Length(sHexStr) >= 4 then
            begin
              bEscapeHex := false ;
              bEscaped   := false ;

              sStr := sStr + WideChar(StrToInt('$' + sHexStr)) ;
            end ;
          end else begin
            bEscapeHex := false ;
            bEscaped   := false ;
            Dec(jsonPos) ;
          end ;
        end else begin // not bExcapeHex
          case jsonChar of
            '\' : begin
                    bEscaped := false ;
                    sStr := sStr + '\' ;
                  end ;
            '/' : begin
                    bEscaped := false ;
                    sStr := sStr + '/' ;
                  end ;
            '"' : begin
                    bEscaped := false ;
                    sStr := sStr + '"' ;
                  end ;
            'b' : begin
                    bEscaped := false ;
                    sStr := sStr + #8 ;
                  end ;
            't' : begin
                    bEscaped := false ;
                    sStr := sStr + #9 ;
                  end ;
            'n' : begin
                    bEscaped := false ;
                    sStr := sStr + #10 ;
                  end ;
            'f' : begin
                    bEscaped := false ;
                    sStr := sStr + #12 ;
                  end ;
            'r' : begin
                    bEscaped := false ;
                    sStr := sStr + #13 ;
                  end ;
            'u' : begin
                    bEscapeHex := true ;
                    sHexStr := '' ;
                  end ;
          end;
        end ; // bEscapeHex

      end else begin // not bEscaped

        case jsonChar of
          '"' : begin
                  break ;
                end ;
          '\' : begin
                  bEscaped := true ;
                end ;
          else sStr := sStr + jsonChar ;
        end;

      end ; // bEscape
    end;

    Inc(jsonPos) ;
  end ;

  Result := sStr ;
end;
//------------------------------------------------------------------------------
class function TJSON.JSONToObject(aJSONStr: string ; var aObject ; aDefaultClass : TClass = nil): boolean ;
var
  ia : integer ;
begin
  Result := false ;
  try
    ia := 1 ;
    Result := JSONToObject(aJSONStr, TObject(aObject), aDefaultClass, ia) ;
  except
    raise;
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.ObjectToJSON(aObject: TObject ; aDefaultClass : TClass = nil ; aJSONOptions : TJSONOptions = [joExportClassName]): string;
var
  TypeInfo : PTypeInfo ;
  PropList : PPropList ;
  PropNum  : integer ;
  PropInfo : PPropInfo ;
  Types    : TTypeKinds ;
  ia       : integer ;
  bFirst   : boolean ;
begin
  Result := '{' ;

  if Assigned(aObject) then
  begin
    TypeInfo := aObject.ClassInfo ;
    getMem(PropList, sizeOf(TPropList)) ;
    PropNum := GetPropList(TypeInfo, tkAny, PropList, false) ;

    if TypeInfo^.Kind = tkClass then
    begin
      bFirst := true ;
      if (joExportClassName in aJSONOptions) then
        if ((not Assigned(aDefaultClass)) or (aObject.ClassName <> aDefaultClass.ClassName)) then
        begin
          Result := Result + '"className":"'+aObject.QualifiedClassName+'"' ;
          bFirst := false ;
        end;

      for ia := 0 to PropNum - 1 do
      begin
{$IFDEF NEXTGEN}
        PropInfo := GetPropInfo(aObject, PropList^[ia]^.NameFld.ToString, tkAny) ;
{$ELSE NEXTGEN}
        PropInfo := GetPropInfo(aObject, PropList^[ia]^.Name, tkAny) ;
{$ENDIF NEXTGEN}

        if not bFirst
          then Result := Result + ',' ;

{$IFDEF NEXTGEN}
        Result := Result + '"' + PropInfo.NameFld.ToString + '":' ;
{$ELSE NEXTGEN}
        Result := Result + '"' + PropInfo.Name + '":' ;
{$ENDIF NEXTGEN}
        bFirst := false ;

        case PropInfo^.PropType^.Kind of
          tkInteger, tkChar, tkEnumeration, tkSet :
{$IFDEF NEXTGEN}
            if (PropInfo^.PropType^.NameFld.ToString = 'Boolean') then
            begin
              Result := Result + BoolToJSON(GetOrdProp(aObject, PropInfo) = 1) ;
            end else begin
              Result := Result + IntToStr(GetOrdProp(aObject, PropInfo)) ;
            end;
{$ELSE NEXTGEN}
            if (PropInfo^.PropType^.NameFld.ToString = 'Boolean') then
            begin
              Result := Result + BoolToJSON(GetOrdProp(aObject, PropInfo) = 1) ;
            end else begin
              Result := Result + IntToStr(GetOrdProp(aObject, PropInfo)) ;
            end;
{$ENDIF NEXTGEN}
          tkInt64 :
            Result := Result + IntToStr(GetInt64Prop(aObject, PropInfo)) ;
          tkFloat :
{$IFDEF NEXTGEN}
            if PropInfo^.PropType^.NameFld.ToString = 'TDateTime' then
              Result := Result + '"' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', GetFloatProp(aObject, PropInfo)) + '"'
            else if PropInfo^.PropType^.NameFld.ToString = 'TDate' then
              Result := Result + '"' + FormatDateTime('yyyy-mm-dd', GetFloatProp(aObject, PropInfo)) + '"'
            else if PropInfo^.PropType^.NameFld.ToString = 'TTime' then
              Result := Result + '"' + FormatDateTime('hh:nn:ss.zzz', GetFloatProp(aObject, PropInfo)) + '"'
            else
              Result := Result + FloatToStr(GetFloatProp(aObject, PropInfo)) ;
{$ELSE NEXTGEN}
            if PropInfo^.PropType^.Name = 'TDateTime' then
              Result := Result + '"' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', GetFloatProp(aObject, PropInfo)) + '"'
            else if PropInfo^.PropType^.Name = 'TDate' then
              Result := Result + '"' + FormatDateTime('yyyy-mm-dd', GetFloatProp(aObject, PropInfo)) + '"'
            else if PropInfo^.PropType^.Name = 'TTime' then
              Result := Result + '"' + FormatDateTime('hh:nn:ss.zzz', GetFloatProp(aObject, PropInfo)) + '"'
            else if PropInfo^.PropType^.Name = 'Currency' then
              Result := Result + CurrToJSON(GetFloatProp(aObject, PropInfo))
            else
              Result := Result + FloatToJson(GetFloatProp(aObject, PropInfo)) ;
{$ENDIF NEXTGEN}
          tkString  : Result := Result + '"' + escapeJSONString(GetStrProp(aObject, PropInfo)) + '"' ;
          tkLString : Result := Result + '"' + escapeJSONString(GetStrProp(aObject, PropInfo)) + '"' ;
          tkUString : Result := Result + '"' + escapeJSONString(GetStrProp(aObject, PropInfo)) + '"' ;
{$IFDEF NEXTGEN}
          tkWString : Result := Result + '"' + escapeJSONString(GetStrProp(aObject, PropInfo)) + '"' ;
{$ELSE NEXTGEN}
          tkWString : Result := Result + '"' + escapeJSONString(GetWideStrProp(aObject, PropInfo)) + '"' ;
{$ENDIF NEXTGEN}
          tkDynArray : Result := Result + DynArrayToJSON(getDynArrayProp(aObject, PropInfo), PropInfo^.PropType^) ;
          tkClass   : Result := Result + ObjectToJSON(TObject(GetObjectProp(aObject, PropInfo, TObject)), nil, aJSONOptions) ;
          else Result := Result + 'null' ;
        end;
      end;
    end;
    FreeMem(PropList) ;
  end ;
  Result := Result + '}' ;
end;
//==============================================================================
initialization
  TJSON.FJsonFormatSettings := TFormatSettings.Invariant ;
  TJSON.FJsonFormatSettings.ThousandSeparator := #0 ;

end.
