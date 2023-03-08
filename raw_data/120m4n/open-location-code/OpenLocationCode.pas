unit OpenLocationCode;

interface

uses
  Math, System.Classes, SysUtils, CodeArea;

  const
  CODE_PRECISION_NORMAL = 10;
  CODE_PRECISION_EXTRA = 11;
  MAX_DIGIT_COUNT_ = 15;
  // A separator used to break the code into two parts to aid memorability.
  SEPARATOR_ = '+';
  // The number of characters to place before the separator.
  SEPARATOR_POSITION_ = 8;
  // The character used to pad codes.
  PADDING_CHARACTER_ = '0';
  // The character set used to encode the values.
  CODE_ALPHABET_ = '23456789CFGHJMPQRVWX';

  // The base to use to convert numbers to/from.
  ENCODING_BASE_ = 20;

  // The maximum value for latitude in degrees.
  LATITUDE_MAX_ = 90;

  // The maximum value for longitude in degrees.
  LONGITUDE_MAX_ = 180;

  // Maximum code length using lat/lng pair encoding. The area of such a
  // code is approximately 13x13 meters (at the equator), and should be suitable
  // for identifying buildings. This excludes prefix and separator characters.
  PAIR_CODE_LENGTH_ = 10;

  // The resolution values in degrees for each position in the lat/lng pair
  // encoding. These give the place value of each position, and therefore the
  // dimensions of the resulting area.
  PAIR_RESOLUTIONS_: array[0..4] of Double = (20.0, 1.0, 0.05, 0.0025, 0.000125);


  function getPairFirstPlaceValue():Double;
  function getPairPrecision():Double;
  function getGridLatFirstPlaceValue():Double;
  function getGridLngFirstPlaceValue():Double;
  function getFinalLatPrecision():Double;
  function getFinalLngPrecision():Double;

  const
  // First place value of the pairs (if the last pair value is 1).
  //PAIR_FIRST_PLACE_VALUE_ = Math.power(OpenLocationCode.ENCODING_BASE_, (OpenLocationCode.PAIR_CODE_LENGTH_ / 2 - 1));
  PAIR_FIRST_PLACE_VALUE_: function():Double = getPairFirstPlaceValue;

  // Inverse of the precision of the pair section of the code.
  //PAIR_PRECISION_ = Math.power(OpenLocationCode.ENCODING_BASE_, 3);
  PAIR_PRECISION_: function():Double = getPairPrecision;


  // Number of digits in the grid precision part of the code.
  GRID_CODE_LENGTH_ = OpenLocationCode.MAX_DIGIT_COUNT_ - OpenLocationCode.PAIR_CODE_LENGTH_;

  // Number of columns in the grid refinement method.
  GRID_COLUMNS_ = 4;

  // Number of rows in the grid refinement method.
  GRID_ROWS_ = 5;

  // Size of the initial grid in degrees.
  GRID_SIZE_DEGREES_ = 0.000125;

  // First place value of the latitude grid (if the last place is 1).
  //GRID_LAT_FIRST_PLACE_VALUE_ = Math.power(OpenLocationCode.GRID_ROWS_, (OpenLocationCode.GRID_CODE_LENGTH_ - 1));
  GRID_LAT_FIRST_PLACE_VALUE_: function():Double = getGridLatFirstPlaceValue;

  // First place value of the longitude grid (if the last place is 1).
  //GRID_LNG_FIRST_PLACE_VALUE_ = Math.power(OpenLocationCode.GRID_COLUMNS_, (OpenLocationCode.GRID_CODE_LENGTH_ - 1));
  GRID_LNG_FIRST_PLACE_VALUE_: function():Double = getGridLngFirstPlaceValue;

  // Multiply latitude by this much to make it a multiple of the finest
  // precision.
  //FINAL_LAT_PRECISION_ = OpenLocationCode.PAIR_PRECISION_ *
  //    Math.power(OpenLocationCode.GRID_ROWS_, (OpenLocationCode.MAX_DIGIT_COUNT_ - OpenLocationCode.PAIR_CODE_LENGTH_));
  FINAL_LAT_PRECISION_: function():Double = getFinalLatPrecision;


  // Multiply longitude by this much to make it a multiple of the finest
  // precision.
  //FINAL_LNG_PRECISION_ = OpenLocationCode.PAIR_PRECISION_ *
  //    Math.power(OpenLocationCode.GRID_COLUMNS_, (OpenLocationCode.MAX_DIGIT_COUNT_ - OpenLocationCode.PAIR_CODE_LENGTH_));
  FINAL_LNG_PRECISION_: function():Double = getFinalLngPrecision;

  // Minimum length of a code that can be shortened.
  MIN_TRIMMABLE_CODE_LEN_ = 6;

type
  TPairSequence = record
    first : Double;
    second: Double;
  end;

type
  TOpenLocationCode = class
    private
      Fcode : String;
      function clipLatitude(latitude: Double): Double;
      function computeLatitudePrecision(codeLength: Double): Double;
      function normalizeLongitude(longitude: Double): Double;
    public
      constructor Create; overload;
      constructor Create( code : string); overload;

      function getCode():string;
      function encodeGrid(latitude, longitude : Double; codeLength: Integer):string;
      function encodePairs(latitude, longitude : Double; codeLength: Integer = OpenLocationCode.CODE_PRECISION_NORMAL): string;
      function encode(latitude, longitude : Double; codeLength: Integer = OpenLocationCode.CODE_PRECISION_NORMAL): string;
      function decode(code: string): TCodeArea;
      function decodeGrid(code: string): TCodeArea;
      function decodePairs(code: string): TCodeArea;
      function decodePairsSequence(code : string; offset : integer):TPairSequence;
      function isFull(code: string): boolean;
      function isShort(code: string): boolean;
      function isValid(code: string): boolean;
      function isPadded(code: string): boolean;
  end;

implementation

{ TOpenLocationCode }


function CharAt(s: string; i: integer): string;
begin
  if (i < 0) or (i > Length(s)) then // Si la posici�n est� fuera de los l�mites del string, devolvemos un string vac�o
    CharAt := ''
  else // Si la posici�n es v�lida, devolvemos el car�cter en la posici�n indicada
    CharAt := Copy(s, i+1, 1);
end;



function LastChar(s: string): string;
begin
  if Length(s) = 0 then // Si el string est� vac�o, devolvemos un string vac�o
    LastChar := ''
  else // Si el string tiene al menos un car�cter, devolvemos el �ltimo car�cter
    LastChar := Copy(s, Length(s), 1);
end;


function indexOf(a, b: string): integer;
var
  iPos: integer;
begin
  iPos := Pos(a, b); // Buscamos la posici�n de la subcadena a en la cadena b
  if iPos = 0 then // Si no se encuentra, devolvemos -1
    indexOf := -1
  else
    indexOf := iPos - 1; // Si se encuentra, devolvemos la posici�n encontrada
end;

function lastIndexOf(a, b: string): integer;
var
  ipos, lastPos: integer;
begin
  lastPos := 0; // Inicializamos la �ltima posici�n en 0
  repeat
    ipos := Pos(a, b); // Buscamos la posici�n de la subcadena a en la cadena b
    if ipos > 0 then // Si se encuentra, actualizamos la �ltima posici�n
    begin
      lastPos := ipos - 1;
      b := Copy(b, ipos + 1, Length(b) - ipos); // Avanzamos la cadena b para buscar la pr�xima ocurrencia
    end;
  until ipos = 0; // Salimos del bucle cuando no se encuentran m�s ocurrencias
  if lastPos = 0 then // Si no se encontr� ninguna ocurrencia, devolvemos -1
    lastIndexOf := -1
  else
    lastIndexOf := lastPos; // Si se encontr� al menos una ocurrencia, devolvemos la �ltima posici�n encontrada
end;



function getFinalLatPrecision():Double;
begin
  Result := OpenLocationCode.PAIR_PRECISION_ * Math.power(OpenLocationCode.GRID_ROWS_, (OpenLocationCode.MAX_DIGIT_COUNT_ - OpenLocationCode.PAIR_CODE_LENGTH_));
end;

function getFinalLngPrecision():Double;
begin
  Result :=  OpenLocationCode.PAIR_PRECISION_ * Math.power(OpenLocationCode.GRID_COLUMNS_, (OpenLocationCode.MAX_DIGIT_COUNT_ - OpenLocationCode.PAIR_CODE_LENGTH_));
end;

function getGridLngFirstPlaceValue():Double;
begin
  Result := Math.power(OpenLocationCode.GRID_COLUMNS_, (OpenLocationCode.GRID_CODE_LENGTH_ - 1));
end;

function getGridLatFirstPlaceValue():Double;
begin
   Result := Math.power(OpenLocationCode.GRID_ROWS_, (OpenLocationCode.GRID_CODE_LENGTH_ - 1));
end;

function getPairFirstPlaceValue():Double;
begin
  Result := Math.power(OpenLocationCode.ENCODING_BASE_, (OpenLocationCode.PAIR_CODE_LENGTH_ / 2 - 1));
end;

function getPairPrecision():Double;
begin
  Result := Math.power(OpenLocationCode.ENCODING_BASE_, 3);
end;

constructor TOpenLocationCode.Create;
begin
    // Execute the parent (TObject) constructor first
  inherited;  // Call the parent Create method
  Fcode := '';
end;

function TOpenLocationCode.clipLatitude(latitude: Double): Double;
begin
    Result := Math.min(90, Math.max(-90, latitude));
end;

function TOpenLocationCode.computeLatitudePrecision(codeLength: Double): Double;
begin
    if (codeLength <= 10) then begin
      Result :=  Math.power(20, Math.floor(codeLength / -2 + 2));
      exit;
    end;
    Result :=  Math.power(20, -3) / Math.power(OpenLocationCode.GRID_ROWS_, codeLength - 10);
end;

constructor TOpenLocationCode.Create(code: string);
begin
   Fcode := code;
end;



function TOpenLocationCode.decode(code: string): TCodeArea;
var
  editedCode : string;
  pv: Double;
  j : Integer;
  normalLat: Double;
  normalLng: Double;
  gridLat: Integer;
  gridLng: Integer;
  digits: Integer;
  codeArea, gridArea : TCodeArea;
begin
    // This calculates the values for the pair and grid section separately, using
    // integer arithmetic. Only at the final step are they converted to floating
    // point and combined.
    if (not isFull(code)) then begin
      raise Exception.Create('IllegalArgumentException: Passed Open Location Code is not a valid full code: ' + code);
    end;


    // Strip the '+' and '0' characters from the code and convert to upper case.
    editedCode := stringreplace(code, OpenLocationCode.SEPARATOR_, '', [rfReplaceAll, rfIgnoreCase]);
    editedCode := stringreplace(editedCode, OpenLocationCode.PADDING_CHARACTER_ + OpenLocationCode.SEPARATOR_, '', [rfReplaceAll, rfIgnoreCase]);
    editedCode := UpperCase(editedCode);

    // Decode the lat/lng pair component.
    codeArea := decodePairs(editedCode.substring(0, PAIR_CODE_LENGTH_));
    // If there is a grid refinement component, decode that.
    if (editedCode.length <= PAIR_CODE_LENGTH_) then begin
      Result := codeArea;
    end;

    gridArea := decodeGrid(editedCode.substring(PAIR_CODE_LENGTH_));

    Result := TCodeArea.Create(
      codeArea.latitudeLo + gridArea.latitudeLo,
      codeArea.longitudeLo + gridArea.longitudeLo,
      codeArea.latitudeLo + gridArea.latitudeHi,
      codeArea.longitudeLo + gridArea.longitudeHi,
      codeArea.codeLength + gridArea.codeLength);
    {
    // Initialise the values for each section. We work them out as integers and
    // convert them to floats at the end.
    normalLat := -OpenLocationCode.LATITUDE_MAX_ * OpenLocationCode.PAIR_PRECISION_;
    normalLng := -OpenLocationCode.LONGITUDE_MAX_ * OpenLocationCode.PAIR_PRECISION_;
    gridLat := 0;
    gridLng := 0;
    // How many digits do we have to process?
    digits := Math.min(editedCode.length, OpenLocationCode.PAIR_CODE_LENGTH_);
    // Define the place value for the most significant pair.
    pv := OpenLocationCode.PAIR_FIRST_PLACE_VALUE_;

    j:= 0;
    while j < digits do
    begin

      normalLat := normalLat + indexOf(charAt(editedCode, j), OpenLocationCode.CODE_ALPHABET_) * pv;
      normalLng := normalLng + indexOf(charAt(editedCode, j + 1), OpenLocationCode.CODE_ALPHABET_) * pv;
      if (j < digits - 2) then begin
        pv := pv / OpenLocationCode.ENCODING_BASE_;
      end;

      inc(j,2);
    end;   }


end;

function TOpenLocationCode.decodeGrid(code: string): TCodeArea;
var
  i, codeIndex, row, col : integer;
  latitudeLo, longitudeLo : Double;
  latPlaceValue, lngPlaceValue : Double;
begin
    latitudeLo := 0.0;
    longitudeLo := 0.0;
    latPlaceValue := GRID_SIZE_DEGREES_;
    lngPlaceValue := GRID_SIZE_DEGREES_;
    i := 0;
    while (i < code.length) do begin
      codeIndex :=  indexOf(charAt(code, i), CODE_ALPHABET_);
      row := Math.floor(codeIndex / GRID_COLUMNS_);
      col := codeIndex Mod GRID_COLUMNS_;

      latPlaceValue := latPlaceValue / GRID_ROWS_;
      lngPlaceValue := lngPlaceValue / GRID_COLUMNS_;

      latitudeLo  := latitudeLo + row * latPlaceValue;
      longitudeLo := longitudeLo + col * lngPlaceValue;
      i := i + 1;
    end;
    Result := TCodeArea.Create(
        latitudeLo, longitudeLo, latitudeLo + latPlaceValue,
        longitudeLo + lngPlaceValue, code.length);
end;

function TOpenLocationCode.decodePairs(code: string): TCodeArea;
var
  latitude, longitude : TPairSequence;
begin
    // Get the latitude and longitude values. These will need correcting from
    // positive ranges.
    latitude  := decodePairsSequence(code, 0);
    longitude := decodePairsSequence(code, 1);

        // Correct the values and set them into the CodeArea object.
    Result := TCodeArea.Create(
        latitude.first - LATITUDE_MAX_,
        longitude.first - LONGITUDE_MAX_,
        latitude.second - LATITUDE_MAX_,
        longitude.second - LONGITUDE_MAX_,
        code.Length);
end;

function TOpenLocationCode.decodePairsSequence(code: string; offset: integer): TPairSequence;
var
  i : Integer;
  value : Double;
begin
  i := 0;
  value := 0;
  while (i * 2 + offset < code.length) do begin
      value := value +  indexOf(charAt(code ,i * 2 + offset), CODE_ALPHABET_) *
          PAIR_RESOLUTIONS_[i];
      i := i + 1;
  end;
  Result.first  := value;
  Result.second := value + PAIR_RESOLUTIONS_[i - 1];
end;

function TOpenLocationCode.encode(latitude, longitude : Double; codeLength: Integer = OpenLocationCode.CODE_PRECISION_NORMAL): string;
var
  _temp : boolean;
  editedCodeLength : integer;
  editedLatitude, editedLongitude : Double;
  code : string;
   latDigit, lngDigit, ndx : integer;
  I: Integer;
  latVal, lngVal: Int64;
begin
  _temp := (codeLength < OpenLocationCode.PAIR_CODE_LENGTH_) and (codeLength mod 2 = 1);
   if (codeLength < 2) or (_temp)  then begin
      raise Exception.Create('IllegalArgumentException: Invalid Open Location Code length');
   end;



    // Ensure that latitude and longitude are valid.
    editedLatitude := clipLatitude(latitude);
    editedLongitude := normalizeLongitude(longitude);
    // Latitude 90 needs to be adjusted to be just less, so the returned code
    // can also be decoded.
    if (editedLatitude = 90) then begin
      editedLatitude := editedLatitude - computeLatitudePrecision(editedCodeLength);
    end;
    code := encodePairs(editedLatitude, editedLongitude,
            Math.min(codeLength, PAIR_CODE_LENGTH_));

     // If the requested length indicates we want grid refined codes.
    if (codeLength > PAIR_CODE_LENGTH_) then begin
      code := code + encodeGrid(
          latitude, longitude, codeLength - PAIR_CODE_LENGTH_);
    end;

  {      // Compute the code.
    // This approach converts each value to an integer after multiplying it by
    // the final precision. This allows us to use only integer operations, so
    // avoiding any accumulation of floating point representation errors.

    // Multiply values by their precision and convert to positive.
    // Force to integers so the division operations will have integer results.
    // Note: JavaScript requires rounding before truncating to ensure precision!
    latVal :=
        Math.floor(Round((editedLatitude + OpenLocationCode.LATITUDE_MAX_) * OpenLocationCode.FINAL_LAT_PRECISION_ * 1e6) / 1e6);
    lngVal :=
        Math.floor(Round((editedLongitude + OpenLocationCode.LONGITUDE_MAX_) * OpenLocationCode.FINAL_LNG_PRECISION_ * 1e6) / 1e6);

    // Compute the grid part of the code if necessary.
    if (editedCodeLength > OpenLocationCode.PAIR_CODE_LENGTH_) then begin
       for I := 0 to OpenLocationCode.MAX_DIGIT_COUNT_ - OpenLocationCode.PAIR_CODE_LENGTH_ do
        begin
           latDigit := latVal Mod OpenLocationCode.GRID_ROWS_;
           lngDigit := lngVal Mod OpenLocationCode.GRID_COLUMNS_;
           ndx  := latDigit * OpenLocationCode.GRID_COLUMNS_ + lngDigit;
           code := charAt(OpenLocationCode.CODE_ALPHABET_, ndx) + code;
        end;
    end
    else begin
      latVal := Math.floor(latVal / Math.power(OpenLocationCode.GRID_ROWS_, OpenLocationCode.GRID_CODE_LENGTH_));
      lngVal := Math.floor(lngVal / Math.power(OpenLocationCode.GRID_COLUMNS_, OpenLocationCode.GRID_CODE_LENGTH_));
    end;

    for I := 0 to Round(OpenLocationCode.PAIR_CODE_LENGTH_ / 2) do
    begin
      code := charAt(OpenLocationCode.CODE_ALPHABET_ , lngVal mod OpenLocationCode.ENCODING_BASE_) + code;
      code := charAt(OpenLocationCode.CODE_ALPHABET_ , latVal mod OpenLocationCode.ENCODING_BASE_) + code;
      latVal := Math.floor(latVal / OpenLocationCode.ENCODING_BASE_);
      lngVal := Math.floor(lngVal / OpenLocationCode.ENCODING_BASE_);
    end;

    code := Copy(code,0, OpenLocationCode.SEPARATOR_POSITION_) +
            OpenLocationCode.SEPARATOR_ +
            Copy(code, OpenLocationCode.SEPARATOR_POSITION_, length(code));

     // If we don't need to pad the code, return the requested section.
    if (editedCodeLength >= OpenLocationCode.SEPARATOR_POSITION_) then begin
      result := copy(code, 0, editedCodeLength + 1);
    end; }

  Result := code;


end;

function TOpenLocationCode.encodeGrid(latitude, longitude: Double; codeLength: Integer): string;
var
  code : string;
  latPlaceValue, lngPlaceValue  :Double;
  adjustedLatitude, adjustedLongitude  :Double;
  I, row, col: integer;
begin
    code := '';
    latPlaceValue := GRID_SIZE_DEGREES_;
    lngPlaceValue := GRID_SIZE_DEGREES_;
    // Adjust latitude and longitude so they fall into positive ranges and
    // get the offset for the required places.
    adjustedLatitude  := FMod((latitude + LATITUDE_MAX_), latPlaceValue);
    adjustedLongitude := FMod((longitude + LONGITUDE_MAX_), lngPlaceValue);
    for I := 0 to codeLength - 1 do begin
      // Work out the row and column.
      row := Math.floor(adjustedLatitude / (latPlaceValue / GRID_ROWS_));
      col := Math.floor(adjustedLongitude / (lngPlaceValue / GRID_COLUMNS_));
      latPlaceValue := latPlaceValue / GRID_ROWS_;
      lngPlaceValue := lngPlaceValue / GRID_COLUMNS_;
      adjustedLatitude := adjustedLatitude - row * latPlaceValue;
      adjustedLongitude := adjustedLongitude - col * lngPlaceValue;
      code := code + charAt(CODE_ALPHABET_, row * GRID_COLUMNS_ + col);
    end;

    Result := code;
end;

function TOpenLocationCode.encodePairs(latitude, longitude: Double; codeLength: Integer): string;
var
  code : string;
  adjustedLatitude, adjustedLongitude:Double;
  digitCount, digitValue : integer;
  placeValue : Double;
begin
  code := '';
  // Adjust latitude and longitude so they fall into positive ranges.
  adjustedLatitude  := latitude + LATITUDE_MAX_;
  adjustedLongitude := longitude + LONGITUDE_MAX_;
  // Count digits - can't use string length because it may include a separator
  // character.
  digitCount := 0;
  while (digitCount < codeLength) do begin
      // Provides the value of digits in this place in decimal degrees.
      placeValue := PAIR_RESOLUTIONS_[Math.floor(digitCount / 2)];
      // Do the latitude - gets the digit for this place and subtracts that for
      // the next digit.
      digitValue := Math.floor(adjustedLatitude / placeValue);
      adjustedLatitude := adjustedLatitude - digitValue * placeValue;
      code := code + charAt(CODE_ALPHABET_, digitValue);
      digitCount := digitCount + 1;
      // And do the longitude - gets the digit for this place and subtracts that
      // for the next digit.
      digitValue := Math.floor(adjustedLongitude / placeValue);
      adjustedLongitude := adjustedLongitude - digitValue * placeValue;
      code := code + charAt(CODE_ALPHABET_, digitValue);
      digitCount := digitCount + 1;
      // Should we add a separator here?
      if (digitCount = SEPARATOR_POSITION_) and (digitCount < codeLength) then begin
        code := code + SEPARATOR_;
      end;
  end;

//  if (code.length < SEPARATOR_POSITION_) then begin
//    code = code + Array(SEPARATOR_POSITION_ - code.length + 1).join(PADDING_CHARACTER_);
//  end;

  if (code.length = SEPARATOR_POSITION_) then begin
    code := code + SEPARATOR_;
  end;
  Result := code;

end;

function TOpenLocationCode.getCode: string;
begin
  Result := Fcode;
end;

function TOpenLocationCode.isFull(code: string): boolean;
var
  firstLatValue, firstLngValue : Double;
begin
    Result := True;
  if not isValid(code) then Result := False;
  if isShort(code) then Result := False;

  // Work out what the first latitude character indicates for latitude.
    firstLatValue := indexOf(UpperCase(charAt(code,0)), OpenLocationCode.CODE_ALPHABET_) * OpenLocationCode.ENCODING_BASE_;
    if (firstLatValue >= OpenLocationCode.LATITUDE_MAX_ * 2) then Result := False; // The code would decode to a latitude of >= 90 degrees.

    if (code.length > 1) then begin
      // Work out what the first longitude character indicates for longitude.
      firstLngValue := indexOf(UpperCase(charAt(code,1)),OpenLocationCode.CODE_ALPHABET_ ) * OpenLocationCode.ENCODING_BASE_;
      if (firstLngValue >= OpenLocationCode.LONGITUDE_MAX_ * 2) then begin
        Result := False; // The code would decode to a longitude of >= 180 degrees.
      end
    end
end;

function TOpenLocationCode.isPadded(code: string): boolean;
begin
  // not implemented
end;

function TOpenLocationCode.isShort(code: string): boolean;
begin
  Result := True;
  if not isValid(code) then Result := False;

      // If there are less characters than expected before the SEPARATOR.
   Result := (indexOf(OpenLocationCode.SEPARATOR_, code) >= 0) and (indexOf(OpenLocationCode.SEPARATOR_, code) < OpenLocationCode.SEPARATOR_POSITION_);

end;

function TOpenLocationCode.isValid(code: String): boolean;
var
  I: Integer;
  character: string;
begin

  Result := True;

  if (code ='') then Result := False;
  // The separator is required.
  if indexOf(OpenLocationCode.SEPARATOR_, code) = -1 then Result := False;

  if IndexOf(OpenLocationCode.SEPARATOR_, code) <> lastIndexOf(OpenLocationCode.SEPARATOR_, code) then Result := False;

  // Is it the only character?
  if Length(code) = 1 then Result := False;

  // Is it in an illegal position?
  if (indexOf(OpenLocationCode.SEPARATOR_, code) > (OpenLocationCode.SEPARATOR_POSITION_ + 1)) or
      (indexOf(OpenLocationCode.SEPARATOR_, code) Mod 2 = 1) then Result := False;


      // We can have an even number of padding characters before the separator,
    // but then it must be the final character.
    if (indexOf(OpenLocationCode.PADDING_CHARACTER_, code) > -1) then
    begin
      // Short codes cannot have padding
      if (indexOf(OpenLocationCode.SEPARATOR_, code) < OpenLocationCode.SEPARATOR_POSITION_) then Result := false;

      // Not allowed to start with them!
      if (indexOf(OpenLocationCode.PADDING_CHARACTER_, code) = 0) then Result := False;

      // There can only be one group and it must have even length.
      //const padMatch = code.match(new RegExp("(" + OpenLocationCode.PADDING_CHARACTER_ + "+)", "g"));
      //if (padMatch.length > 1 || padMatch[0].length % 2 === 1 ||
      //  padMatch[0].length > OpenLocationCode.SEPARATOR_POSITION_ - 2) {
      //  return false;
      //}
      // If the code is long enough to end with a separator, make sure it does.
      if (LastChar(code) <> OpenLocationCode.SEPARATOR_) then Result := false;
    end;

    // If there are characters after the separator, make sure there isn't just
    // one of them (not legal).
    if (length(code) - indexOf(OpenLocationCode.SEPARATOR_, code) = 1) then Result := False;

    for I := 0 to Length(code)-1 do
    begin
      character :=  AnsiUpperCase(CharAt(code, i));
      if (character <> OpenLocationCode.SEPARATOR_ ) and (indexOf(character, OpenLocationCode.CODE_ALPHABET_) = -1) then Result := False;

    end;

end;

function TOpenLocationCode.normalizeLongitude(longitude: Double): Double;
var
  longitudeOutput : Double;
begin
    longitudeOutput := longitude;
    while (longitudeOutput < -180) do begin
      longitudeOutput := longitudeOutput + 360;
    end;
    while (longitudeOutput >= 180) do begin
      longitudeOutput := longitudeOutput - 360;
    end;
    Result := longitudeOutput;
end;

end.
