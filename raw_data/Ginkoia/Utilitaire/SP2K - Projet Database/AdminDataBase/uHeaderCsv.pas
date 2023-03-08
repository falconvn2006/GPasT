unit uHeaderCsv;

interface

uses Windows, Messages, SysUtils,Classes, StrUtils, Contnrs, DB, dxDBGridHP,
  variants;


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
    Caption : String;
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
    procedure Add(sText : String;iSize : Integer = 0;eaAlign : TExportAlign = alLeft;efTypeFormat : TExportFormat = fmNone;sFormat : String = '';cDecimalSeparator : Char = '.';sCaption : String = '');

    // Récupère le header formaté pour le CSV avec séparateur ; par défaut     -
    function GetCsvHeader(Separator : String = ';') : String;
    function ConvertToCsv(sDBG: TdxDBGridHP;sFileName : String) : Integer;

    constructor Create;
end;


implementation

{ TExportHeaderOL }

procedure TExportHeaderOL.Add(sText: String; iSize: Integer; eaAlign: TExportAlign;
  efTypeFormat: TExportFormat; sFormat : String;cDecimalSeparator : char; sCaption : String);
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
    if sCaption = '' then
      Caption := Text
    else
      Caption := sCaption;
  end;

  Inherited Add(Header);
end;

function TExportHeaderOL.ConvertToCsv(sDBG: TdxDBGridHP; sFileName: String) : Integer;
var
  i,j,tmp : integer;
  sField : String;
  FormatSet : TFormatSettings;
  sLigne : AnsiString;
  lstFile : TSTringList;
  FFile : TFileStream;

  Buffer : TBytes;
  Encoding : TEncoding;
begin
  Result := -1; //C'est pas ok

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

    try
      sDBG.SelectALL;

      for j := 0 to sDBG.SelectedCount - 1 do
      begin
        tmp := 0;
        while ((tmp < sDBG.SelectedCount) AND (sDBG.SelectedNodes[tmp].Index <> j)) do
          inc(tmp);

        if ((tmp < sDBG.SelectedCount) AND (sDBG.SelectedNodes[tmp].Level = 0)) then
        begin
        sLigne := '';
        for i := 0 to Count - 1 do
        begin
          if not VarIsNull(sDBG.GetValueByFieldName(sDBG.SelectedNodes[tmp],Items[i].Text)) then
          begin
            case Items[i].TypeFormat of
              fmNone : begin
                if Items[i].Size <> 0 then
                  sField := Copy(sDBG.GetValueByFieldName(sDBG.SelectedNodes[tmp],Items[i].Text),1,Items[i].Size)
                else
                  sField := sDBG.GetValueByFieldName(sDBG.SelectedNodes[tmp],Items[i].Text);
              end;
              fmInteger : begin
                sField := IntToStr(sDBG.GetValueByFieldName(sDBG.SelectedNodes[tmp],Items[i].Text));
              end;
              fmFloat : begin
                FormatSet.DecimalSeparator := Items[i].cDecSep;
                sField := FormatFloat(Items[i].FloatFormat,sDBG.GetValueByFieldName(sDBG.SelectedNodes[tmp],Items[i].Text),FormatSet);
              end;
              fmDate : begin
                if VarIsStr(sDBG.GetValueByFieldName(sDBG.SelectedNodes[tmp],Items[i].Text)) then
                  sField := sDBG.GetValueByFieldName(sDBG.SelectedNodes[tmp],Items[i].Text)
                else
                  sField := FormatDateTime(Items[i].FloatFormat,sDBG.GetValueByFieldName(sDBG.SelectedNodes[tmp],Items[i].Text));
              end;
              fmEmpty : begin
                sField := '';
              end;
            end; // case
          end
          else
          begin
            sField := '';
          end;  //if

            if bAlign and (Items[i].Size <> 0) then
            begin
              case Items[i].Align of
                alLeft: begin
                  sField := sField + StringOfChar(' ',Items[i].Size - Length(sField));
                  sField := Copy(sField,1,Items[i].Size);
                end;
                alRight: begin
                  sField := StringOfChar(' ',Items[i].Size - Length(sField)) + sField;
                  sField := Copy(sField,Length(sField) - Items[i].Size,Items[i].Size);
                end;
              end;  //case
            end;  //if

            sLigne := sLigne + sField;

            if Separator <> '' then
              sLigne := sLigne +  Separator;

        end;  //for
        // on supprime le dernier Separator
        if Separator <> '' then
          sLigne := Copy(sLigne,1,Length(sLigne) -1);

        // Ajout du séparateur de lignes
        sLigne := sLigne + #13#10;

        Encoding := TEncoding.Default;
        Buffer := Encoding.GetBytes(sLigne);
        FFile.Write(Buffer[0],Length(Buffer));
        end;
      end;  //for
      sDBG.ClearSelection;
      Result := 1;  //C'est ok
    Except on E:Exception do
      raise Exception.create('ConvertToCSV Error : ' + E.Message);
    end;  //try ... Except
  finally
    FFile.Free;
  end;  //try ... finally
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
      Result := Result + Items[i].Caption;
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
