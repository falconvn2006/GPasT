unit uCreateCsv;

interface

uses Windows, Messages, SysUtils,Classes, StrUtils, Contnrs, DB;


type
  TExportAlign  = (alLeft,alRight);
  TExportFormat = (fmNone,fmInteger,fmFloat,fmDate,fmEmpty);

  THeaderO = class(TObject)
    Text  : String;
    Size  : Integer;
    Align : TExportAlign;
    TypeFormat : TExportFormat;
    FloatFormat : String;
    cDecSep : char;
  end;

type TExportHeaderOL = class(TObjectList)
  private
    function GetItems(Index : Integer) : THeaderO;
    procedure SetItems(Index : Integer; Value : THeaderO);
  public
    bWriteHeader : Boolean;
    bAlign: Boolean;
    Separator: String;
    OldStr,NewStr: String;
    property Items [Index : Integer] : THeaderO read GetItems Write SetItems; default;
    procedure Add(sText : String;iSize : Integer = 0;eaAlign : TExportAlign = alLeft;efTypeFormat : TExportFormat = fmNone;sFormat : String = '';cDecimalSeparator : Char = '.');

    // R�cup�re le header format� pour le CSV avec s�parateur ; par d�faut     -
    function GetCsvHeader(Separator : String = ';') : String;
    function ConvertToCsv(DsDataSet: TDataSet;sFileName : String) : Boolean;

    constructor Create;
end;


implementation

{ TExportHeaderOL }

procedure TExportHeaderOL.Add(sText: String; iSize: Integer; eaAlign: TExportAlign;
  efTypeFormat: TExportFormat; sFormat : String;cDecimalSeparator : char);
var
  Header : THeaderO;
begin
  Header := THeaderO.Create;
  With Header do
  begin
    Text := sText;
    Size := iSize;
    Align := eaAlign;
    TypeFormat := efTypeFormat;
    FloatFormat := sFormat;
    cDecSep := cDecimalSeparator;
  end;

  Inherited Add(Header);
end;

function TExportHeaderOL.ConvertToCsv(DsDataSet: TDataSet; sFileName: String) : Boolean;
var
  i,j : integer;
  sField : String;
  FormatSet : TFormatSettings;
  sLigne : String;
  lstFile : TSTringList;
  FFile : TFileStream;

  Buffer : TBytes;
  Encoding : TEncoding;

begin
  if DsDataSet.RecordCount > 0 then
  begin
    try
      if not FileExists(sFileName) then
      begin
        FFile := TFileStream.Create(sFileName,fmCreate);
        // gestion de l'ent�te (ne peut pas fonctionner avec le mode alignement)
        if bWriteHeader and not bAlign then
        begin
          sLigne := GetCsvHeader(Separator);
          sLigne := sLigne + #13#10;
          Encoding := TEncoding.Default;
          Buffer := Encoding.GetBytes(sLigne);
          FFile.Write(Buffer[0],Length(Buffer));

  //        FFile.Write(sLigne[1],Length(sLigne));
        end;
      end
      else begin
        FFile := TFileStream.Create(sFileName,fmOpenReadWrite);
        FFile.Seek(0,soFromEnd);
        Encoding := TEncoding.Default;
      end;

      With DsDataSet do
      Try
        First;
        while not EOF do
        begin
          sLigne := '';
          for i := 0 to Count - 1 do
          begin
            With Items[i] do
            begin
              // selon le type on formatte les donn�es du field
              case TypeFormat of
                fmNone    : begin
                  sField := Trim(StringReplace(FieldByName(Text).AsString,OldStr,NewStr,[rfReplaceAll]));
                  for j := 1 to Length(sField)-1 do
                    if sField[j]in [#1..#31] then sField[j]:=#32;
                end;
                fmInteger : sField := IntToStr(FieldByName(Text).AsInteger);
                fmFloat   : begin
                    FormatSet.DecimalSeparator := cDecSep;
                    sField := FormatFloat(FloatFormat,FieldByName(Text).AsFloat,FormatSet);
                end;
                fmDate    : sField := FormatDateTime(FloatFormat,FieldByName(Text).AsDateTime);
                fmEmpty   : sField := '';
              end; // case

              if bAlign and (Size <> 0) then
              begin
                case Align of
                  alLeft: begin
                    sField := sField + StringOfChar(' ',Size - Length(sField));
                    sField := Copy(sField,1,Size);
                  end;
                  alRight: begin
                    sField := StringOfChar(' ',Size - Length(sField)) + sField;
                    sField := Copy(sField,Length(sField) - Size,Size);
                  end;
                end; // case
              end; // if balign
            end; // with
            sLigne := sLigne + sField;

            if Separator <> '' then
              sLigne := sLigne +  Separator;
          end;
          // on supprime le dernier Separator
          if Separator <> '' then
            sLigne := Copy(sLigne,1,Length(sLigne) -1);

          // Ajout du s�parateur de lignes
          sLigne := sLigne + #13#10;
          Buffer := Encoding.GetBytes(sLigne);
          FFile.Write(Buffer[0],Length(Buffer));

//          FFile.Write(sLigne[1],Length(sLigne));
          Next;
        end;
      Except on E:Exception do
        raise Exception.create('ConvertToCSV Error : ' + E.Message);
      end;
    finally
      FFile.Free;
    end; // try
  end; // if
end;

constructor TExportHeaderOL.Create;
begin
  Inherited Create;
  bWriteHeader := False;
  bAlign := True;
  Separator := '';
end;

function TExportHeaderOL.GetCsvHeader(Separator: String): String;
var
  i : integer;
begin
  Result := '';
  if Count > 0 then
  begin
    for i := 0 to Count - 1 do
    begin
      Result := Result + Items[i].Text;
      if Separator <> '' then
        Result := Result + Separator;
    end;
    if Separator <> '' then
      Result := Copy(Result,1,Length(Result) -1);
  end;
end;

function TExportHeaderOL.GetItems(Index: Integer): THeaderO;
begin
  Result := THeaderO(Inherited GetItem(Index));
end;

procedure TExportHeaderOL.SetItems(Index: Integer; Value: THeaderO);
begin
 Inherited SetItem(Index,Value);
end;

end.