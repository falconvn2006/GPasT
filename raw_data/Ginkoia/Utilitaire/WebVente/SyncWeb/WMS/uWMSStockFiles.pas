unit uWMSStockFiles;

interface

uses
  SysUtils, uFTPFiles, uGestionBDD, DB;

type
  TStockSensType = (sstIn, sstOut, sstUndefined);

  TAdrLignes = array[1..3] of String;

  TWMSInitStockFile = class(TCustomFTPSendFile)
  private
    FCurrentPath: string;

    FEnteteLine1: string;
    FEnteteLine2: string;
    FEnteteLine3: string;

    const FCSVSeparator: string = '|';

    procedure UpdateEnteteValues;
  protected
    procedure RefreshFileName; override;

    procedure LoadQueryParams(AQuery: TMyQuery); override;

    function getQuery: string; override;
    function getInitQuery: string; override;

    function ExportWebCommands: boolean;

    function DoWrite(APath: string): boolean; override;

    procedure DoWriteStocks(APath: string);

    procedure WriteBLLine(ADataSet: TDataSet; AStringBuilder: TStringBuilder);
    procedure WriteDTLine(ADataSet: TDataSet; AStringBuilder: TStringBuilder);

    function LignesAdresse(aAdrLignes: String): TAdrLignes;
    function FormatStringValues(AValue: String): string;
  public

  end;

implementation

uses
  uCustomFTPManager, Classes, RegExpr;

{ TWMSInitStockFile }

function TWMSInitStockFile.DoWrite(APath: string): boolean;
begin
  if FInitMode then
  begin
    Inherited DoWrite(APath);
  end
  else
  begin
    DoWriteStocks(APath);
  end;
end;

procedure TWMSInitStockFile.DoWriteStocks(APath: string);
var
  FileName: TFileName;

  lastid: integer;

  sBuilder: TStringBuilder;

  bytes: TBytes;
  FileStream: TFileStream;

  sDate: string;
  CurrentStockSens, LastStockSens: TStockSensType;

  exportWeb: boolean;

  function getStockSens(AQte: integer): TStockSensType;
  begin
    if AQte > 0 then
    begin
      Result := sstIn;
    end
    else if AQte <= 0 then
    begin
      Result := sstOut;
    end;
  end;

begin
  getDataSet.Open;

  if not getDataSet.IsEmpty then
  begin
    lastid := 0;

    UpdateEnteteValues;

    LastStockSens := sstUndefined;

    exportWeb := ExportWebCommands;

    sBuilder := TStringBuilder.Create;
    while not getDataSet.Eof do
    begin
      if exportWeb or ( not exportWeb and (getDataSet.FieldByName('WEB').AsInteger = 0) ) then
      begin
        CurrentStockSens := getStockSens(getDataSet.FieldByName('QTE').AsInteger);
        if (lastid <> getDataSet.FieldByName('ID').AsInteger)
          or ((lastid = getDataSet.FieldByName('ID').AsInteger)
             and (CurrentStockSens <> LastStockSens)) then
        begin
          if Lastid <> 0 then
          begin
            FileStream := TFileStream.Create( FileName, fmCreate, fmShareExclusive );
            bytes := TEncoding.Default.GetBytes( sBuilder.ToString );
            FileStream.Write( bytes[0], Length( bytes ) );
            FileStream.Free;

            sBuilder.Clear;
          end;

          WriteBLLine(getDataSet, sBuilder);

          DateTimeToString(sDate, 'YYYYMMDD', Now());
          if getDataSet.FieldByName('QTE').AsInteger < 0 then
            FileName := APath + Format('%s_%s_%s.TXT', [DefaultFileName + 'OUT',
              getDataSet.FieldByName('NUMERO').AsString, sDate])
          else
            FileName := APath + Format('%s_%s_%s.TXT', [DefaultFileName + 'IN',
              getDataSet.FieldByName('NUMERO').AsString, sDate]);
        end;
        WriteDTLine(getDataSet, sBuilder);

        lastid := getDataSet.FieldByName('ID').AsInteger;
        LastStockSens := getStockSens(getDataSet.FieldByName('QTE').AsInteger);
      end;
      getDataSet.Next;
    end;

    FileStream := TFileStream.Create( FileName, fmCreate, fmShareExclusive );
    bytes := TEncoding.Default.GetBytes( sBuilder.ToString );
    FileStream.Write( bytes[0], Length( bytes ));
    FileStream.Free;
  end;
end;

function TWMSInitStockFile.ExportWebCommands: boolean;
var
  query: TMyQuery;
begin
  query := self.GetNewQuery;
  query.SQL.Text :=
    'SELECT PRM_INTEGER FROM GENPARAM WHERE PRM_TYPE = 18 AND PRM_CODE = 15 AND PRM_MAGID = :MAGID';
  query.Params.ParamByName('MAGID').AsInteger := FMagId;
  query.Open;
  if not query.IsEmpty then
    Result := query.FieldByName('PRM_INTEGER').AsInteger = 1
  else
    Result := True;

  query.Close;
  query.Free;
end;

function TWMSInitStockFile.FormatStringValues(AValue: String): string;
begin
  Result := StringReplace(AValue, '|', ',', [rfReplaceAll]);
end;

function TWMSInitStockFile.getInitQuery: string;
begin
  Result :=
    'SELECT ' +
    '  CBI_CB, STC_QTE, STC_MAGID ' +
    'FROM ' +
    '  AGRSTOCKCOUR JOIN K KART ON KART.K_ID = STC_ARTID AND KART.K_ENABLED = 1 ' +
    '  JOIN ARTREFERENCE JOIN K KARF ON KARF.K_ID = ARF_ID AND KARF.K_ENABLED = 1 ' +
    '    ON ARF_ARTID = STC_ARTID AND ARF_VIRTUEL = 0 ' +
    '  JOIN ARTCODEBARRE JOIN K KCBI ON KCBI.K_ID = CBI_ID AND KCBI.K_ENABLED = 1 ' +
    '    ON ARF_ID = CBI_ARFID AND CBI_TYPE = 1 AND CBI_TGFID = STC_TGFID ' +
    '    AND CBI_COUID = STC_COUID ' +
    'WHERE STC_MAGID = :MAGID ' +
    'ORDER BY CBI_CB ';
end;

function TWMSInitStockFile.getQuery: string;
begin
  Result :=
    'SELECT ' +
    '  * ' +
    'FROM ' +
    '  WMS_EXPORT_STOCKS(:MAGID, :LAST_VERSION, :CURRENT_VERSION, ' +
    '    :LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, ' +
    '    :FIN_PLAGE_BASE) ';
end;

function TWMSInitStockFile.LignesAdresse(aAdrLignes: String): TAdrLignes;
var
  regAdresse : TRegExpr;
  i, j: Integer;
begin
  // Met les champs à vide par défaut
  for i := 1 to 3 do
    Result[i] := '';

  // Créer l'expression régulière
  regAdresse := TRegExpr.Create();
  try
    // Spécifie l'expression régulière à utiliser
    regAdresse.Expression := '(.[^\n]+\n)?(.[^\n]+\n)?(.+)?';

    // Exécute l'expression sur la chaîne passée en paramètre
    if regAdresse.Exec(aAdrLignes) then
    begin
      j := 1;

      // Parcours la liste des sous-chaînes trouvées
      for i := 1 to 3 do
      begin
        // Si il y a une sous-chaîne de trouvée pour chaque bloc
        if regAdresse.Match[i] <> '' then
        begin
          Result[j] := TrimRight(RegAdresse.Match[i]);
          Inc(j);
        end;
      end;
    end;
  finally
    regAdresse.Free();
  end;
end;

procedure TWMSInitStockFile.LoadQueryParams(AQuery: TMyQuery);
begin
  inherited LoadQueryParams(AQuery);

  AQuery.Params.ParamByName('MAGID').AsInteger := FMAgId;
end;

procedure TWMSInitStockFile.RefreshFileName;
var
  sDate: string;
begin
  if FInitMode then
    FCurrentFileName := Format('INIT_%s_%s.TXT', [DefaultFileName, IntToStr(FMagId)]);
end;

procedure TWMSInitStockFile.UpdateEnteteValues;
var
  query: TMyQuery;
begin
  query := GetNewQuery;

  query.SQL.Text :=
    'SELECT * FROM GENPARAM ' +
    'WHERE PRM_TYPE = 18 AND PRM_CODE IN (2, 3, 4) AND PRM_MAGID = :MAGID';
  query.Params.ParamByName('MAGID').AsInteger := FMagId;
  query.Open;

  while not query.Eof do
  begin
    case query.FieldByName('PRM_CODE').AsInteger of
      2: FEnteteLine1 := query.FieldByName('PRM_STRING').AsString;
      3: FEnteteLine2:= query.FieldByName('PRM_STRING').AsString;
      4: FEnteteLine3:= query.FieldByName('PRM_STRING').AsString;
    end;
    query.Next;
  end;

  query.Close;
  query.Free;
end;

procedure TWMSInitStockFile.WriteBLLine(ADataSet: TDataSet;
  AStringBuilder: TStringBuilder);
var
  i: integer;
  asAdrLignes: TAdrLignes;
begin
  AStringBuilder.Append( FEnteteLine1 ).AppendLine;
  if ADataSet.FieldByName('QTE').AsInteger < 0 then
    AStringBuilder.Append( FEnteteLine2 ).AppendLine;
  AStringBuilder.Append( FEnteteLine3 ).AppendLine;
  AStringBuilder.Append( 'BL' ).Append( FCSVSeparator ); // 1
  AStringBuilder.Append( ADataSet.FieldByName( 'TYPEENREGISTREMENT' ).AsString + ADataSet.FieldByName( 'NUMERO' ).AsString ).Append( FCSVSeparator ); // 2

  if ADataSet.FieldByName('QTE').AsInteger < 0 then // 3
    AStringBuilder.Append( '99' ).Append( FCSVSeparator )
  else
    AStringBuilder.Append( '03' ).Append( FCSVSeparator );

  AStringBuilder.Append( FormatDateTime( 'yyyymmdd', ADataSet.FieldByName( 'DATEMOUV' ).AsDateTime )).Append( FCSVSeparator ); // 4
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('TRANSPORTEUR_NAME').AsString)).Append(FCSVSeparator); // 5
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('TRANSPORTEUR_CODE').AsString)).Append(FCSVSeparator); // 6
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('POINTRELAICODE').AsString)).Append(FCSVSeparator); // 7
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('PRODUITTRANSPORTCODE').AsString)).Append(FCSVSeparator); // 8
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('MAGASINRETRAIT').AsString)).Append(FCSVSeparator); // 9

  for i := 10 to 11 do AStringBuilder.Append( FCSVSeparator ); // 10 à 11

  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('CLIENT_NAME').AsString)).Append(FCSVSeparator); // 12

  asAdrLignes := LignesAdresse(ADataSet.FieldByName('CLIENT_ADRLIGNE').AsString);
  AStringBuilder.Append( FormatStringValues(asAdrLignes[1]) ).Append(FCSVSeparator); // 13
  AStringBuilder.Append( FormatStringValues(asAdrLignes[2]) ).Append(FCSVSeparator); // 14
  AStringBuilder.Append( FormatStringValues(asAdrLignes[3]) ).Append(FCSVSeparator); // 15

  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('CLIENT_CP').AsString) ).Append(FCSVSeparator); // 16
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('CLIENT_VILLE').AsString) ).Append(FCSVSeparator); // 17
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('CLIENT_PAYS').AsString) ).Append(FCSVSeparator); // 18

  AStringBuilder.Append(FCSVSeparator); // 19
  AStringBuilder.Append( FCSVSeparator ); // 20
  AStringBuilder.Append( FCSVSeparator ); // 21

  AStringBuilder.Append( IntToStr(FMagId) ).Append( FCSVSeparator ); // 22
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('CLIENT_TEL').AsString) ).Append(FCSVSeparator); // 23
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('CLIENT_EMAIL').AsString) ).Append(FCSVSeparator); // 24
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('WEB').AsString) ).Append(FCSVSeparator); // 25

  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('FCEIDWEB').AsString) ).Append(FCSVSeparator); // 26
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName('BLENUMERO').AsString) ).Append(FCSVSeparator); // 27
  AStringBuilder.AppendLine;
end;

procedure TWMSInitStockFile.WriteDTLine(ADataSet: TDataSet;
  AStringBuilder: TStringBuilder);
var
  i: integer;
begin
  AStringBuilder.Append( 'DT' ).Append( FCSVSeparator ); // 1
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName( 'NBLIGNE' ).AsString) ).Append( FCSVSeparator ); // 2
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName( 'TYPEENREGISTREMENT' ).AsString + ADataSet.FieldByName( 'NUMERO' ).AsString) ).Append( FCSVSeparator ); // 3
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName( 'ARTREFMRK' ).AsString) ).Append( FCSVSeparator ); // 4
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName( 'CBICB' ).AsString) ).Append( FCSVSeparator ); // 5
  for i := 6 to 6 do AStringBuilder.Append( FCSVSeparator ); // 5 à 6
  AStringBuilder.Append( FormatStringValues(ADataSet.FieldByName( 'IDLIGNE' ).AsString) ).Append( FCSVSeparator ); // 7
  for i := 8 to 23 do AStringBuilder.Append( FCSVSeparator ); // 8 à 23
  AStringBuilder.Append( IntToStr( Abs(ADataSet.FieldByName( 'QTE' ).AsInteger) )).Append( FCSVSeparator ); // 24
  AStringBuilder.Append( 'PIECES' ).Append( FCSVSeparator ); // 25
  for i := 26 to 39 do AStringBuilder.Append( FCSVSeparator ); // 26 à 39
  AStringBuilder.AppendLine;
end;

initialization

  TCustomFTPManager.RegisterKnownFile('WMS_STOCK', ftSend, '', '', TWMSInitStockFile);

end.
