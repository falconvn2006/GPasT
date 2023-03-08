unit uJSON;

interface

uses Classes, SysUtils, Windows, DateUtils, TypInfo, Math ;

type
  PDoubleArray = ^DoubleArray ;
  DoubleArray = array[0..$effffff] of Double;


  TJSON = class
  private

  public
    class function JSONToObject(aJSONStr : string ; aObject : TPersistent) : boolean ; overload ;
    class function JSONToObject(aJSONStr : string ; aObject : TPersistent ; var jsonPos : Integer) : boolean ; overload ;
    class function JSONToString(aJSONStr : string ; var jsonPos : Integer) : string ;
    class function JSONToOrd(aJSONStr : string ; var jsonPos : Integer) : Integer ;
    class function JSONToInt64(aJSONStr : string ; var jsonPos : Integer) : Int64 ;
    class function JSONToFloat(aJSONStr: string; var jsonPos: Integer): Double ;
    class function JSONToBool(aJSONStr : string ; var jsonPos : Integer) : Boolean ;
    class function JSONToDynArray(aJSONStr: string; var jsonPos: Integer; var aArray : Pointer ; aTypeInfo: PTypeInfo) : boolean ;

    class function ObjectToJSON(aObject : TPersistent) : string ;
    class function DynArrayToJson(aArray : Pointer ; aTypeInfo:PTypeInfo) : string ;
    class function RecordToJson(aRecord : Pointer ; aTypeInfo:PTypeInfo) : string ;
    class function escapeJsonString(aStr : string) : string ;

    class function ISO8601ToDateTime(aStr : string) : TDateTime ; 
  end;

implementation
//==============================================================================
{ TJSON }
//==============================================================================
class function TJSON.DynArrayToJson(aArray: Pointer;
  aTypeInfo:PTypeInfo): string;
var
  arrayLen : Integer ;
  TypeData : PTypeData ;
  Bounds   : TBoundArray ;
  bFirst   : boolean ;
  bMulti   : boolean ;
  Size     : integer ;
  ia       : integer ;

  function DynArraySize(aArray : Pointer) : Integer ;
  asm
    TEST  EAX, EAX
    JZ    @@exit
    MOV   EAX, [EAX-4]
    @@exit:
  end;

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
      Result := Result + DynArrayToJson(PPointerArray(aArray)[ia], TypeData^.elType^ ) ;
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
        tkString, tkLString :
          Result := Result + '"'+ escapeJsonString(String(PPointerArray(aArray)[ia])) +'"' ;

        tkWString :
          Result := Result + '"'+ escapeJsonString(WideString(PPointerArray(aArray)[ia])) +'"' ;

        tkClass :
          Result := Result + ObjectToJSON(PPointerArray(aArray)[ia]) ;
      end;
    end;

    bFirst := false ;
  end;

  Result := Result + ']' ;

end;
//------------------------------------------------------------------------------
class function TJSON.RecordToJson(aRecord: Pointer;
  aTypeInfo: PTypeInfo): string;
begin
  //TODO: Cette fonction n'est pas terminée. 
  Result := '{' ;

  Result := Result + aTypeInfo^.Name ;

  Result := Result + '}' ;
end;
//------------------------------------------------------------------------------
class function TJSON.escapeJsonString(aStr: string): string;
var
  ia : integer ;
begin
  Result := '' ;

  for ia := 1 to Length(aStr) do
  begin
    case aStr[ia] of
    '/', '\', '"' :       Result := Result + '\' + aStr[ia] ;
    #8            :       Result := Result + '\b' ;
    #9            :       Result := Result + '\t' ;
    #10           :       Result := Result + '\n' ;
    #12           :       Result := Result + '\f' ;
    #13           :       Result := Result + '\r' ;
    else
      if ((ord(aStr[ia]) < 32) or (ord(aStr[ia]) > 127))
        then Result := Result + '\u' + intToHex(ord(aStr[ia]), 4)
        else Result := Result + aStr[ia] ;
    end;
  end;
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
class function TJSON.JSONToObject(aJSONStr: string ; aObject : TPersistent ; var jsonPos : integer): boolean ;
var
  jsonLen       : integer ;
  jsonPos2      : integer ;
  jsonChar      : char ;
  bInObject     : boolean ;
  bInValue      : boolean ;
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
  oObj          : TPersistent ;
  pDynArray     : Pointer ;
  vDate         : TDateTime ;

  function findPropInfo(aPropName : string) : PPropInfo ;
  var
    ia : integer ;
  begin
    Result := nil ;
    for ia:= 0 to PropCount - 1 do
    begin
      if uppercase(PropList^[ia]^.Name) = uppercase(aPropName) then
      begin
        Result := PropList^[ia] ;
        break ;
      end;
    end;
  end;

begin
  jsonLen := Length(aJSONStr) ;
  bInObject := false ;  bInValue := false ; 

  while jsonPos <= jsonLen do
  begin
    jsonChar := aJSONStr[jsonPos] ;

    if not bInObject then
    begin

      case jsonChar of
        '{' : begin
                bInObject := true ;
                TypeInfo  := aObject.ClassInfo ;
                getMem(PropList, sizeOf(TPropList)) ;
                PropCount := GetPropList(TypeInfo, tkAny, PropList) ;
              end;
        ' ' : begin
              end ;
        else raise Exception.Create('Object structure error');
      end;

    end else begin
      if bInValue then
      begin
        case jsonChar of
          '"' : begin
                  sStr := JSONToString(aJSONStr, jsonPos) ;

                  if Assigned(currentProp) then
                  begin
                    case currentProp^.PropType^.Kind of
                      tkString, tkLString :
                        SetStrProp(aObject, currentProp, sStr);
                      tkFloat :
                        begin
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
                        end;
                    end;
                  end;

                  bInValue := false ;
                end ;
          '0'..'9','.','-','f','t' :
                begin
                  if Assigned(currentProp) then
                  begin
                    case currentProp^.PropType^.Kind of
                      tkInteger : begin
                                    iA := JSONToOrd(aJSONStr, jsonPos) ;
                                    SetOrdProp(aObject, currentProp, iA);
                                    bInValue := false ;
                                  end ;
                      tkInt64 :   begin
                                    iB := JSONToInt64(aJSONStr, jsonPos) ;
                                    SetInt64Prop(aObject, currentProp, iB);
                                    bInValue := false ;
                                  end ;
                      tkFloat :   begin
                                    fA := JSONToFloat(aJSONStr, jsonPos) ;
                                    SetFloatProp(aObject, currentProp, fA);
                                    bInValue := false ;
                                  end ;
                      tkEnumeration :
                                  begin
                                    if ((aJSONStr[jsonPos] = 'f') or (aJSONStr[jsonPos] = 't')) then
                                    begin
                                      bA := JSONToBool(aJSONStr, jsonPos) ;
                                      if bA
                                        then SetEnumProp(aObject, currentProp, 'true')
                                        else SetEnumProp(aObject, currentProp, 'false') ;
                                    end else begin
                                      iA := JSONToOrd(aJSONStr, jsonPos) ;
                                      SetOrdProp(aObject, currentProp, iA);
                                    end ;
                                    bInValue := false ;
                                  end ;
                    end ;
                  end else begin
                    if ((aJSONStr[jsonPos] = 'f') or (aJSONStr[jsonPos] = 't'))
                      then bA := JSONToBool(aJSONStr, jsonPos)
                      else iA := JSONToOrd(aJSONStr, jsonPos) ;
                    bInValue := False ;
                  end;
                end ;

          '{':  begin

                  if Assigned(currentProp) then
                  begin
                    case currentProp^.PropType^.Kind of
                      tkClass : begin
                                  cClass := GetTypeData(currentProp^.PropType^).ClassType ;
                                  oObj := TPersistent(cClass.NewInstance) ;
                                  JSONToObject(aJSONStr, oObj, jsonPos) ;
                                  SetObjectProp(aObject, currentProp, oObj);
                                end ;
                      tkString, tkLString :
                                begin
                                  oObj := TPersistent(TPersistent.NewInstance) ;
                                  jsonPos2 := jsonPos ;
                                  JSONToObject(aJSONStr, oObj, jsonPos) ;
                                  sStr := Copy(aJSONStr, jsonPos, jsonPos - jsonPos2 + 1) ;
                                  SetStrProp(aObject, currentProp, sStr);
                                  oObj.Free ;
                                end;
                    end ;

                  end else begin
                      // consume json
                      oObj := TPersistent(TPersistent.NewInstance) ;
                      JSONToObject(aJSONStr, oObj, jsonPos) ;
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
                      tkString, tkLString :
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
      end else begin // bInValue
        case jsonChar of
          '"' : begin
                  sStr := JSONToString(aJSONStr, jsonPos) ;
                  currentProp := findPropInfo(sStr) ;
                end ;
          ':' : begin
                  bInValue    := true ;
                end ;
          ',' : begin
                  bInValue    := false ;
                  currentProp := nil ;
                end ;
          '}' : begin
                  Exit ;
                end ;
        end; // Case
      end ;

    end;

    Inc(jsonPos) ;
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.JSONToOrd(aJSONStr: string; var jsonPos: Integer): Integer;
var
  jsonLen   : integer ;
  jsonChar  : char ;
  iA : integer ;
  sStr      : string ;
begin
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
  jsonLen   : integer ;
  jsonChar  : char ;
  iA : integer ;
  sStr      : string ;
begin
  jsonLen   := Length(aJsonStr) ;
  sStr := '' ;

  Result := false ;

  if (copy(aJSONStr, jsonPos, 4) = 'true') then
  begin
    Result := true ;
    Inc(jsonPos,4) ;
  end;

  if (copy(aJSONStr, jsonPos, 5) = 'false') then
  begin
    Result := false ;
    Inc(jsonPos,5) ;
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
  oObj      : TPersistent ;
  ia, ib    : integer ;
  Len       : LongInt ;
  vDateTime : TDateTime ;
  pStr      : PString ;
  cClass    : TClass ;
begin
  TypeData := nil ; 
  if Assigned(aTypeInfo)
    then TypeData := GetTypeData(aTypeInfo) ;

  bInArray := false ;

  ia := 0 ;
  jsonLen := Length(aJSONStr) ;

  while jsonPos <= jsonLen do
  begin
    jsonChar := aJsonStr[jsonPos] ;

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
                      tkString , tkLString :
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
                          if TypeData^.elType2^^.Name = 'TDateTime' then
                          begin
                            vDateTime := ISO8601ToDateTime(sStr) ;
                            PDoubleArray(aArray)^[ia] := Double(vDateTime) ;
                          end;
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
                          oObj := TPersistent(cClass.NewInstance) ;
                          JSONToObject(aJSONStr, oObj, jsonPos) ;

                          Len := ia+1 ;
                          DynArraySetLength(aArray, aTypeInfo, 1, @Len);
                          PPointerArray(aArray)^[ia] := Pointer(oObj) ;
                          Inc(ia) ;
                        end;
                      tkString , tkLString :
                        begin
                          cClass := TPersistent ;
                          oObj := TPersistent(cClass.NewInstance) ;
                          ib := jsonPos ;
                          JSONToObject(aJSONStr, oObj, jsonPos) ;
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
                  oObj := TPersistent.Create ;
                  JSONToObject(aJSONStr, oObj, jsonPos) ;
                  oObj.Free ;
                end;
              end ;
      end; // case

    end;

    Inc(jsonPos);
  end ;
end;

class function TJSON.JSONToInt64(aJSONStr: string; var jsonPos: Integer): Int64;
var
  jsonLen   : integer ;
  jsonChar  : char ;
  iA : integer ;
  sStr      : string ;
begin
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
  iA : integer ;
  sStr      : string ;
  vFormatSettings : TFormatSettings ;
begin
  jsonLen   := Length(aJsonStr) ;
  sStr := '' ;

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, vFormatSettings);
  vFormatSettings.DecimalSeparator := '.' ;
  vFormatSettings.ThousandSeparator := #0 ;

  while jsonPos <= jsonLen do
  begin
    jsonChar := aJsonStr[jsonPos] ;

    case jsonChar of
      '0'..'9','.','-' : begin
                      sStr := sStr + jsonChar ;
                     end ;

      else begin
        Dec(jsonPos) ;
        Result := StrToFloatDef(sStr, 0, vFormatSettings) ;
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

  Result := '' ; sStr := '' ;

  while jsonPos <= jsonLen do
  begin
    jsonChar := aJsonStr[jsonPos] ;

    if not bInString then
    begin
      case jsonChar of
        '"' : bInString := true ;
        ' ' :
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
class function TJSON.JSONToObject(aJSONStr: string ; aObject : TPersistent): boolean ;
var
  ia : integer ;
begin
  Result := false ;
  try
    if not Assigned(aObject)  then Exit ;

    ia := 1 ;
    Result := JSONToObject(aJSONStr, aObject, ia) ;
  except
  end;
end;
//------------------------------------------------------------------------------
class function TJSON.ObjectToJSON(aObject: TPersistent): string;
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

      for ia := 0 to PropNum - 1 do
      begin
        PropInfo := GetPropInfo(aObject, PropList^[ia]^.Name, tkAny) ;

        if not bFirst
          then Result := Result + ',' ;

        Result := Result + '"' + PropInfo.Name + '":' ;
        bFirst := false ;

        case PropInfo^.PropType^.Kind of
          tkInteger, tkChar, tkEnumeration, tkSet :
            Result := Result + IntToStr(GetOrdProp(aObject, PropInfo)) ;
          tkInt64 :
            Result := Result + IntToStr(GetInt64Prop(aObject, PropInfo)) ;
          tkFloat :
            if PropInfo^.PropType^.Name = 'TDateTime' then
              Result := Result + '"' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', GetFloatProp(aObject, PropInfo)) + '"'
            else if PropInfo^.PropType^.Name = 'TDate' then
              Result := Result + '"' + FormatDateTime('yyyy-mm-dd', GetFloatProp(aObject, PropInfo)) + '"'
            else if PropInfo^.PropType^.Name = 'TTime' then
              Result := Result + '"' + FormatDateTime('hh:nn:ss.zzz', GetFloatProp(aObject, PropInfo)) + '"'
            else
              Result := Result + FloatToStr(GetFloatProp(aObject, PropInfo)) ;
          tkString  : Result := Result + '"' + escapeJSONString(GetStrProp(aObject, PropInfo)) + '"' ;
          tkLString : Result := Result + '"' + escapeJSONString(GetStrProp(aObject, PropInfo)) + '"' ;
          tkWString : Result := Result + '"' + escapeJSONString(GetWideStrProp(aObject, PropInfo)) + '"' ;
          tkDynArray : Result := Result + DynArrayToJSON(getDynArrayProp(aObject, PropInfo), PropInfo^.PropType^) ;
          tkClass   : Result := Result + ObjectToJSON(TPersistent(GetObjectProp(aObject, PropInfo, TPersistent))) ;
        end;
      end;
    end;
    FreeMem(PropList) ;
  end ;
  Result := Result + '}' ;
end;
//==============================================================================
end.
