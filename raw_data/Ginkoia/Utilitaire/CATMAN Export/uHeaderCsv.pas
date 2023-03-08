unit uHeaderCsv;

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
    property Items [Index : Integer] : THeaderO read GetItems Write SetItems; default;
    procedure Add(sText : String;iSize : Integer = 0;eaAlign : TExportAlign = alLeft;efTypeFormat : TExportFormat = fmNone;sFormat : String = '';cDecimalSeparator : Char = '.');

    // Récupère le header formaté pour le CSV avec séparateur ; par défaut     -
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
  i : integer;
  sField : String;
  FormatSet : TFormatSettings;
  sLigne : String;
  lstFile : TSTringList;
  FFile : TFileStream;
begin
  if DsDataSet.RecordCount > 0 then
  begin
    if FileExists(sFileName) then
    begin
      FFile := TFileStream.Create(sFileName,fmOpenReadWrite);
      FFile.Seek(0,soFromEnd); // Positionne à la fin du fichier
    end
    else
      FFile := TFileStream.Create(sFileName,fmCreate);
    try
      // gestion de l'entête (ne peut pas fonctionner avec le mode alignement)
      if bWriteHeader and not bAlign then
      begin
        sLigne := GetCsvHeader(Separator);
        sLigne := sLigne + #13#10;
        FFile.Write(sLigne[1],Length(sLigne));
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
              // selon le type on formatte les données du field
              case TypeFormat of
                fmNone    : begin
                  if Size <> 0 then
                    sField := Copy(FieldByName(Text).AsString,1,Size)
                  else
                    sField := FieldByName(Text).AsString;
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

          // Ajout du séparateur de lignes
          sLigne := sLigne + #13#10;
          FFile.Write(sLigne[1],Length(sLigne));
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
