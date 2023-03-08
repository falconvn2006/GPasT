unit LotoModel;

{$mode objfpc}{$H+}
{
       Criado por Amaury Carvalho (amauryspires@gmail.com), 2019
}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, ComCtrls, Menus, Grids, ExtCtrls, StdCtrls, MaskEdit,
  Process, LotoIni, CSN, Clipbrd, LCLIntf, fphttpclient, Zipper,
  sax_html, dom_html, dom, fpjson, jsonparser, opensslsockets;

type
  TJsonLF = class(TObject)
  public
    tipoJogo: string;
    numero: string;
    numeroConcursoAnterior: string;
    numeroConcursoProximo: string;
    dataApuracao: string;
    listaDezenas: string;
    dezenasSorteadasOrdemSorteio: string;
    ultimoConcurso: string;
    constructor Create(json: string);
  end;

type
  TLotoModel = class(TObject)
  private
    oCSN: TCSN;
    random_balls: array[0..1, 0..24] of integer;

    array_check: array [1..25] of boolean;
    last_checks: integer;

    ballot_bets_data2: array of array of integer;
    ballot_bets_csn2: array of double;
    ballot_bets_check2: array of array of integer;
    ballot_bets_wins2: array of array of boolean;
    ballot_bets_total2: array [0..4] of integer;

    procedure GetRandomBalls;
    procedure QSort(var numbers: array of integer; left: integer;
      right: integer; var secondary: array of integer);

  public
    errorMessage: string;

    ballot_max_csn: double;
    ballot_history_data: array of array of integer;
    ballot_history_csn: array of double;
    ballot_history_count: integer;

    ballot_bets_data: array of array of integer;
    ballot_bets_csn: array of double;
    ballot_bets_count: integer;
    ballot_bets_check: array of array of integer;
    ballot_bets_wins: array of array of boolean;
    ballot_bets_total: array [0..4] of integer;
    ballot_bets_skip_last: boolean;
    has_data: boolean;
    stop: boolean;

    chart_data: array of array of double;
    chart_count: integer;
    chart_waterline, chart_outliers, chart_tendency: boolean;
    chart_probability: double;
    chart_theoretical_data: array of double;
    chart_theoretical_count: integer;
    chart_theoretical_min, chart_theoretical_max: integer;

    constructor Create;

    function ImportFromInternet(sb: TStatusBar): boolean;
    function ImportFromInternetFile(): boolean;
    function ImportFromLocalFile(sFile: string): boolean;
    function RefreshGrid(sgGrid: TStringGrid): boolean;
    procedure RefreshTotals(sLines: TStrings);

    function DoBets(size: integer): boolean;
    function DoCheck(bet_index, history_index: integer): integer;
    function DoChecks(checks: integer): boolean;
    function DoBetsAndChecks(checks: integer): boolean;
    procedure MemorizeBets;
    procedure RememberBets;
    procedure RefreshBets(sgGrid: TStringGrid);

    function AddBet(sBet: string): boolean;
    procedure RemoveBet(iRow: integer);
    procedure ClearBets();

    procedure ChartHistogram(size: integer);
    procedure ChartHistogram(size: integer; module: double);
    procedure ChartTimeSeries(size: integer);
    procedure ChartPositional(size, position: integer);
    procedure ChartTheoreticalDistMinMax(size: integer);

    procedure QuickSort(var numbers: array of integer; size: integer);
    procedure QuickSort(var numbers: array of integer; size: integer;
      var secondary: array of integer);

  end;

implementation

constructor TLotoModel.Create;
var
  i: integer;
begin
  inherited Create;
  oCSN := TCSN.Create(25, 15);
  ballot_max_csn := oCSN.Combine(25, 15);
  has_data := False;
  last_checks := 0;
  ballot_history_count := 0;
  ballot_bets_count := 0;
  chart_count := 0;
  chart_waterline := False;
  chart_outliers := False;
  chart_tendency := False;
  for i := 1 to 25 do
    array_check[i] := False;
end;

procedure TLotoModel.GetRandomBalls;
var
  i: integer;
begin

  for i := 0 to 14 do
  begin
    random_balls[0, i] := i + 1;
    random_balls[1, i] := Random(100000);
  end;

  QuickSort(random_balls[1], 15, random_balls[0]);

end;

function TLotoModel.ImportFromInternet(sb: TStatusBar): boolean;
var
  sUrl, sResult, sCurrNumber, sRemoteNumber, sNewLine: string;
  oHttp: TFPHttpClient;
  oIni: TLotoIni;
  oJson: TJsonLF;
  sFileData: string;
  sCSV, sLine: TStringList;
  lastLocalNumber, currNumber, lastRemoteNumber: integer;
  downloadCount: integer;
begin

  stop := False;
  downloadCount := 0;

  sb.SimpleText := 'Conectando ao portal da Caixa Economica Federal...';
  Application.ProcessMessages;

  oIni := TLotoIni.Create;

  sUrl := oIni.ImportJson;
  sFileData := IncludeTrailingPathDelimiter(oIni.DataPath) + oIni.DataFileName;

  oHttp := TFPHttpClient.Create(nil);

  try

    try

      oHttp.AllowRedirect := True;
      oHttp.MaxRedirects := 15;
      sResult := oHttp.SimpleGet(sUrl);

      try
        oJson := TJsonLF.Create(sResult);

        if not oJson.tipoJogo.Equals('LOTOFACIL') then
        begin
          errorMessage := 'Erro na leitura dos concursos (retorno inválido)';
          Result := False;
          exit;
        end;

        sb.SimpleText := 'Conexão com sucesso';
        Application.ProcessMessages;

        sRemoteNumber := oJson.numero;
        lastRemoteNumber := StrToInt(oJson.numero);

      finally
        oJson.Free;
      end;

      try
        try
          sCSV := TStringList.Create;
          sCSV.Delimiter := ';';

          lastLocalNumber := 0;

          if FileExists(sFileData) then
          begin
            sCSV.LoadFromFile(sFileData);
            try
              sLine := TStringList.Create;
              sLine.Delimiter := ';';
              sLine.DelimitedText := sCSV.Strings[sCSV.Count - 1];
              lastLocalNumber := StrToInt(sLine.Strings[0]);
            finally
              sLine.Free;
            end;
          end;

          if lastLocalNumber >= lastRemoteNumber then
          begin
            errorMessage := 'Não há sorteios novos a importar';
            Result := False;
            exit;
          end;

          for currNumber := lastLocalNumber + 1 to lastRemoteNumber do
          begin
            sCurrNumber := IntToStr(currNumber);
            sb.SimpleText := 'Baixando sorteio: ' + sCurrNumber + '/' + sRemoteNumber;
            Application.ProcessMessages;

            sResult := oHttp.SimpleGet(sUrl + '/' + sCurrNumber);

            try
              oJson := TJsonLF.Create(sResult);
              if not oJson.tipoJogo.Equals('LOTOFACIL') then
              begin
                errorMessage := 'Erro na leitura do sorteio número: ' + sCurrNumber;
                Result := False;
                exit;
              end;
              sNewLine := sCurrNumber + ';' + oJson.dataApuracao + ';' +
                oJson.dezenasSorteadasOrdemSorteio;
              sCSV.Add(sNewLine);
              downloadCount += 1;
            finally
              oJson.Free;
            end;

            Application.ProcessMessages;
            if stop then
              break;
          end;

          if FileExists(sFileData) then
            DeleteFile(sFileData);

          sCSV.SaveToFile(sFileData);

          Result := True;

        except
          on E: Exception do
          begin
            if (downloadCount > 0) then
            begin
              if FileExists(sFileData) then
                DeleteFile(sFileData);

              sCSV.SaveToFile(sFileData);
            end;
            errorMessage := 'Erro na tentativa de download direto: ' +
              sLineBreak + E.Message;
            Result := False;
          end;
        end;

      finally
        sCSV.Free;
      end;

    except
      on E: Exception do
      begin
        errorMessage := 'Erro na tentativa de download direto: ' +
          sLineBreak + E.Message;
        Result := False;
      end;
    end;

  finally
    oIni.Free;
    oHttp.Free;
  end;

end;

function TLotoModel.ImportFromInternetFile(): boolean;
var
  sUrl, sFile, sResult: string;
  oHttp: TFPHttpClient;
  oIni: TLotoIni;
begin
  oIni := TLotoIni.Create;

  sUrl := oIni.ImportURL;
  sFile := IncludeTrailingPathDelimiter(oIni.TempPath) + 'loto.zip';

  if FileExists(sFile) then
    DeleteFile(sFile);

  if oIni.ImportMode = '1' then
  begin
    // download via wget
    if RunCommand(oIni.WGetPath, ['-O', sFile, sUrl], sResult) then
      Result := True
    else
    begin
      errorMessage := 'Erro no download via Sistema Operacional (wget)' +
        sLineBreak + sLineBreak + sResult;
      Result := False;
    end;
  end
  else
  begin
    oHttp := TFPHttpClient.Create(nil);

    try
      try
        oHttp.AllowRedirect := True;
        oHttp.MaxRedirects := 15;
        oHttp.Cookies.Add('security=true');
        oHttp.Cookies.Add('path=/');
        //oHttp.IOTimeout := 60000;
        //oHttp.KeepConnection:= true;
        oHttp.AddHeader('User-Agent', 'Mozilla/5.0 (compatible; fpweb)');
        oHttp.AddHeader('Referer', sUrl);
        oHttp.AddHeader('Set-Cookie', 'security=true; path=/');
        oHttp.AddHeader('Content-Type', 'application/x-zip-compressed');
        oHttp.Get(sUrl, sFile);
        Result := ImportFromLocalFile(sFile);
      finally
        oHttp.Free;
      end;
    except
      on E: Exception do
      begin
        errorMessage := 'Erro na tentativa de download direto: ' +
          sLineBreak + E.Message;
        Result := False;
      end;
    end;

  end;

  oIni.Free;

end;

function TLotoModel.ImportFromLocalFile(sFile: string): boolean;
var
  sFileUnzipped, sFileData, sTmpPath, sImportFileName: string;
  oUnZipper: TUnZipper;
  oIni: TLotoIni;
  docTag: thtmldocument;
  elsTag: tdomnodelist;
  sList, sCSV: TStringList;
  sStream: TStringStream;
  sHtml, sTag, sLine: string;
  iIndex, iMax, iDezena, iSorteio: integer;
begin
  if not FileExists(sFile) then
  begin
    errorMessage := 'Erro durante a importação dos sorteios';
    Result := False;
    exit;
  end;

  // descompacta o arquivo dos sorteios

  oIni := TLotoIni.Create;

  sTmpPath := IncludeTrailingPathDelimiter(oIni.TempPath);
  sImportFileName := oIni.ImportFileName;

  sFileData := IncludeTrailingPathDelimiter(oIni.DataPath) + oIni.DataFileName;

  {$if defined(windows)}
  sFileUnzipped := sTmpPath + sImportFileName;
  if FileExists(sFileUnzipped) then
    DeleteFile(sFileUnzipped);
  {$else}
  sFileUnzipped := sTmpPath + Uppercase(sImportFileName);
  if FileExists(sFileUnzipped) then
    DeleteFile(sFileUnzipped);

  sFileUnzipped := sTmpPath + Lowercase(sImportFileName);
  if FileExists(sFileUnzipped) then
    DeleteFile(sFileUnzipped);

  sFileUnzipped := sTmpPath + sImportFileName;
  if FileExists(sFileUnzipped) then
    DeleteFile(sFileUnzipped);
  {$ifend}

  oUnZipper := TUnZipper.Create;

  try
    oUnZipper.FileName := sFile;
    oUnZipper.OutputPath := oIni.TempPath;

    try
      oUnZipper.Examine;
      oUnZipper.UnZipAllFiles;
    except
      on E: Exception do
      begin
        errorMessage := 'Erro na tentativa de descompactar sorteios: ' +
          sLineBreak + E.Message;
        oIni.Free;
        Result := False;
        exit;
      end;
    end;

  finally
    oUnZipper.Free;
  end;

  oIni.Free;

  {$if defined(windows)}
  if not FileExists(sFileUnzipped) then
  begin
    errorMessage := 'Erro durante a descompactação dos sorteios';
    Result := False;
    exit;
  end;
  {$else}
  if not FileExists(sFileUnzipped) then
  begin
    sFileUnzipped := sTmpPath + Uppercase(sImportFileName);
    if not FileExists(sFileUnzipped) then
    begin
      sFileUnzipped := sTmpPath + Lowercase(sImportFileName);
      if not FileExists(sFileUnzipped) then
      begin
        errorMessage := 'Erro durante a descompactação dos sorteios';
        Result := False;
        exit;
      end;
    end;
  end;
  {$ifend}

  // converte o arquivo descompactado de HTML para CSV

  sCSV := TStringList.Create;

  sList := TStringList.Create;
  sList.LoadFromFile(sFileUnzipped);
  sHtml := sList.Text;
  sList.Free;

  sStream := TStringStream.Create(sHtml);
  readhtmlfile(docTag, sStream);
  sStream.Free;

  elsTag := docTag.GetElementsByTagName('td');
  iMax := elsTag.Count - 1;

  iDezena := 16;
  iSorteio := 0;

  for iIndex := 0 to iMax do
  begin
    sTag := elsTag[iIndex].TextContent;

    if iDezena < 16 then
    begin
      sLine := sLine + ';' + sTag;

      if iDezena = 15 then
        sCSV.Add(sLine);

      iDezena := iDezena + 1;
    end;

    if pos('/', sTag) > 0 then
    begin
      iDezena := 1;
      iSorteio := iSorteio + 1;
      sLine := IntToStr(iSorteio) + ';' + sTag;
    end;

  end;

  // só prossegue se a quantidade de sorteios baixado for maior que
  // a quantidade atual em memória

  iSorteio := sCSV.Count;
  if iSorteio < ballot_history_count then
  begin
    errorMessage := 'Importação incompleta dos sorteios';
    Result := False;
    exit;
  end
  else if iSorteio = ballot_history_count then
  begin
    errorMessage := 'Não há sorteios novos a importar';
    Result := False;
    exit;
  end;

  // salva o arquivo CSV com os dados do sorteio

  if FileExists(sFileData) then
    DeleteFile(sFileData);

  sCSV.SaveToFile(sFileData);
  sCSV.Free;

  Result := True;

end;


function TLotoModel.RefreshGrid(sgGrid: TStringGrid): boolean;
var
  oIni: TLotoIni;
  sFile: string;
  i, k: integer;
begin
  oIni := TLotoIni.Create;
  sFile := IncludeTrailingPathDelimiter(oIni.DataPath) + oIni.DataFileName;
  oIni.Free;

  if FileExists(sFile) then
  begin
    sgGrid.LoadFromCSVFile(sFile, ';', False);
    sgGrid.ColCount := 18;
    sgGrid.Cells[1, 0] := 'Data';
    for i := 1 to 15 do
      sgGrid.Cells[1 + i, 0] := 'D' + IntToStr(i);
    sgGrid.Cells[17, 0] := '#Combinatorial';
    // sgGrid.Columns.Items[17].Width:=120;
    ballot_history_count := sgGrid.RowCount - 1;
    setlength(ballot_history_data, 15, ballot_history_count);
    setlength(ballot_history_csn, ballot_history_count);
    for i := 0 to ballot_history_count - 1 do
    begin
      for k := 0 to 14 do
      begin
        try
          ballot_history_data[k, i] := StrToInt(Trim(sgGrid.Cells[k + 2, i + 1]));
          oCSN.combineData[k + 1] := ballot_history_data[k, i];
        except
          on E: Exception do
          begin
            errorMessage := 'Dados dos sorteios estão inválidos. Baixe novamente.';
            Result := False;
            exit;
          end;
        end;
      end;
      ballot_history_csn[i] := oCSN.GetCSN();
      sgGrid.Cells[17, i + 1] := FloatToStrF(ballot_history_csn[i], ffFixed, 15, 0);
    end;
    sgGrid.AutoSizeColumns;
    has_data := True;
    Result := True;
  end
  else
  begin
    errorMessage :=
      'Faça a importação dos sorteios via o menu ferramentas';
    Result := False;
  end;

end;

procedure TLotoModel.QSort(var numbers: array of integer; left: integer;
  right: integer; var secondary: array of integer);
var
  pivot, pivot2, l_ptr, r_ptr: integer;

begin
  l_ptr := left;
  r_ptr := right;
  pivot := numbers[left];
  if Length(secondary) > 0 then
    pivot2 := secondary[left];

  while (left < right) do
  begin
    while ((numbers[right] >= pivot) and (left < right)) do
      right := right - 1;

    if (left <> right) then
    begin
      numbers[left] := numbers[right];
      if Length(secondary) > 0 then
        secondary[left] := secondary[right];
      left := left + 1;
    end;

    while ((numbers[left] <= pivot) and (left < right)) do
      left := left + 1;

    if (left <> right) then
    begin
      numbers[right] := numbers[left];
      if Length(secondary) > 0 then
        secondary[right] := secondary[left];
      right := right - 1;
    end;
  end;

  numbers[left] := pivot;
  if Length(secondary) > 0 then
    secondary[left] := pivot2;

  pivot := left;
  left := l_ptr;
  right := r_ptr;

  if (left < pivot) then
    QSort(numbers, left, pivot - 1, secondary);

  if (right > pivot) then
    QSort(numbers, pivot + 1, right, secondary);
end;

procedure TLotoModel.QuickSort(var numbers: array of integer; size: integer);
var
  secondary: array of integer;
begin
  QSort(numbers, 0, size - 1, secondary);
end;

procedure TLotoModel.QuickSort(var numbers: array of integer;
  size: integer; var secondary: array of integer);
begin
  QSort(numbers, 0, size - 1, secondary);
end;

function TLotoModel.AddBet(sBet: string): boolean;
var
  oList: TStringList;
  i, k: integer;
begin
  oList := TStringList.Create;
  oList.Delimiter := ',';
  oList.DelimitedText := sBet;

  if oList.Count < 15 then
  begin
    Result := False;
    oList.Free;
    exit;
  end;

  i := ballot_bets_count;
  ballot_bets_count += 1;
  SetLength(ballot_bets_data, 15, ballot_bets_count);
  SetLength(ballot_bets_wins, 15, ballot_bets_count);
  SetLength(ballot_bets_check, 13, ballot_bets_count);
  SetLength(ballot_bets_csn, ballot_bets_count);
  SetLength(ballot_bets_data2, 15, ballot_bets_count);
  SetLength(ballot_bets_wins2, 15, ballot_bets_count);
  SetLength(ballot_bets_check2, 13, ballot_bets_count);
  SetLength(ballot_bets_csn2, ballot_bets_count);

  try
    for k := 0 to 14 do
    begin
      ballot_bets_data[k, i] := StrToInt(oList[k]);
      if ballot_bets_data[k, i] < 1 then
        ballot_bets_data[k, i] := 1
      else if ballot_bets_data[k, i] > 25 then
        ballot_bets_data[k, i] := 25;
    end;
  except
    on e: Exception do
    begin
      Result := False;
      exit;
    end;
  end;

  oList.Free;

  Result := True;
end;

procedure TLotoModel.RemoveBet(iRow: integer);
var
  i, k: integer;
begin
  MemorizeBets();
  ballot_bets_count -= 1;

  SetLength(ballot_bets_data, 15, ballot_bets_count);
  SetLength(ballot_bets_wins, 15, ballot_bets_count);
  SetLength(ballot_bets_check, 13, ballot_bets_count);
  SetLength(ballot_bets_csn, ballot_bets_count);

  for i := iRow + 1 to ballot_bets_count do
    for k := 0 to 5 do
      ballot_bets_data[k, i - 1] := ballot_bets_data[k, i];

  setlength(ballot_bets_data2, 15, ballot_bets_count);
  setlength(ballot_bets_wins2, 15, ballot_bets_count);
  setlength(ballot_bets_check2, 13, ballot_bets_count);
  setlength(ballot_bets_csn, ballot_bets_count);

end;

function TLotoModel.DoBets(size: integer): boolean;
var
  i, k, z: integer;
  a: array [0..14] of integer;
begin
  if size < 1 then
  begin
    ballot_bets_count := 0;
    Result := True;
    exit;
  end;

  ballot_bets_count := size;
  setlength(ballot_bets_data, 15, size);
  setlength(ballot_bets_wins, 15, size);
  setlength(ballot_bets_check, 13, size);
  setlength(ballot_bets_csn, size);
  setlength(ballot_bets_data2, 15, size);
  setlength(ballot_bets_wins2, 15, size);
  setlength(ballot_bets_check2, 13, size);
  setlength(ballot_bets_csn, size);

  k := 25;

  for i := 0 to size - 1 do
  begin

    if k >= 25 then
    begin
      getRandomBalls;
      k := 0;
    end;

    a[0] := random_balls[0, k];
    k := k + 1;
    a[1] := random_balls[0, k];
    k := k + 1;
    a[2] := random_balls[0, k];
    k := k + 1;
    a[3] := random_balls[0, k];
    k := k + 1;
    a[4] := random_balls[0, k];
    k := k + 1;
    a[5] := random_balls[0, k];
    k := k + 1;

    QuickSort(a, 15);

    for z := 0 to 14 do
    begin
      ballot_bets_data[z, i] := a[z];
      if z < 13 then
        ballot_bets_check[z, i] := 0;
    end;

  end;

  Result := True;

end;

function TLotoModel.DoCheck(bet_index, history_index: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to 14 do
    if (ballot_bets_data[i, bet_index] >= 1) and
      (ballot_bets_data[i, bet_index] <= 25) then
      array_check[ballot_bets_data[i, bet_index]] := True;
  for i := 0 to 14 do
    if (ballot_history_data[i, history_index] >= 1) and
      (ballot_history_data[i, history_index] <= 25) then
      if array_check[ballot_history_data[i, history_index]] then
        Result += 1;
  for i := 0 to 14 do
    if (ballot_bets_data[i, bet_index] >= 1) and
      (ballot_bets_data[i, bet_index] <= 25) then
      array_check[ballot_bets_data[i, bet_index]] := False;

end;

function TLotoModel.DoBetsAndChecks(checks: integer): boolean;
var
  i, k, f, t: integer;
begin
  for k := 0 to 4 do
    ballot_bets_total[k] := 0;

  last_checks := checks;

  f := ballot_history_count;
  if ballot_bets_skip_last then
    f -= 1;

  for k := f - checks to f - 1 do
  begin

    DoBets(ballot_bets_count);

    for i := 0 to ballot_bets_count - 1 do
    begin
      t := DoCheck(i, k);
      case t of
        11: ballot_bets_check[0, i] := 1;
        12: ballot_bets_check[1, i] := 1;
        13: ballot_bets_check[2, i] := 1;
        14: ballot_bets_check[3, i] := 1;
        15: ballot_bets_check[4, i] := 1;
      end;

      ballot_bets_total[0] += ballot_bets_check[0, i];
      ballot_bets_total[1] += ballot_bets_check[1, i];
      ballot_bets_total[2] += ballot_bets_check[2, i];
      ballot_bets_total[3] += ballot_bets_check[3, i];
      ballot_bets_total[4] += ballot_bets_check[4, i];
    end;

  end;

  Result := True;
end;

function TLotoModel.DoChecks(checks: integer): boolean;
var
  i, k, f, t: integer;
begin
  ballot_bets_total[0] := 0;
  ballot_bets_total[1] := 0;
  ballot_bets_total[2] := 0;
  ballot_bets_total[3] := 0;
  ballot_bets_total[4] := 0;

  last_checks := checks;

  f := ballot_history_count;
  if ballot_bets_skip_last then
    f -= 1;

  for i := 0 to ballot_bets_count - 1 do
  begin

    ballot_bets_check[0, i] := 0;
    ballot_bets_check[1, i] := 0;
    ballot_bets_check[2, i] := 0;
    ballot_bets_check[3, i] := 0;
    ballot_bets_check[4, i] := 0;

    for k := f - checks to f - 1 do
    begin
      t := DoCheck(i, k);
      case t of
        11: ballot_bets_check[0, i] += 1;
        12: ballot_bets_check[1, i] += 1;
        13: ballot_bets_check[2, i] += 1;
        14: ballot_bets_check[3, i] += 1;
        15: ballot_bets_check[4, i] += 1;
      end;
    end;

    ballot_bets_total[0] += ballot_bets_check[0, i];
    ballot_bets_total[1] += ballot_bets_check[1, i];
    ballot_bets_total[2] += ballot_bets_check[2, i];
    ballot_bets_total[3] += ballot_bets_check[3, i];
    ballot_bets_total[4] += ballot_bets_check[4, i];

  end;

  Result := True;
end;

procedure TLotoModel.RefreshBets(sgGrid: TStringGrid);
var
  i, k: integer;
begin

  if last_checks = 1 then
  begin
    i := ballot_history_count - 1;

    for k := 1 to 25 do
      array_check[k] := False;

    for k := 0 to 14 do
    begin
      if (ballot_history_data[k, i] >= 1) and (ballot_history_data[k, i] <= 25) then
        array_check[ballot_history_data[k, i]] := True;
    end;
  end;

  sgGrid.RowCount := ballot_bets_count + 1;

  for i := 0 to ballot_bets_count - 1 do
  begin

    sgGrid.Cells[0, i + 1] := IntToStr(i + 1);
    for k := 1 to 15 do
    begin
      oCSN.combineData[k] := ballot_bets_data[k - 1, i];
      sgGrid.Cells[k, i + 1] := IntToStr(ballot_bets_data[k - 1, i]);

      if last_checks = 1 then
        if (ballot_bets_data[k - 1, i] >= 1) and (ballot_bets_data[k - 1, i] <= 25) then
          if array_check[ballot_bets_data[k - 1, i]] then
            ballot_bets_wins[k - 1, i] := True
          else
            ballot_bets_wins[k - 1, i] := False;
    end;

    if ballot_bets_check[0, i] > 0 then
      sgGrid.Cells[16, i + 1] := IntToStr(ballot_bets_check[0, i])
    else
      sgGrid.Cells[16, i + 1] := '';

    if ballot_bets_check[1, i] > 0 then
      sgGrid.Cells[17, i + 1] := IntToStr(ballot_bets_check[1, i])
    else
      sgGrid.Cells[17, i + 1] := '';

    if ballot_bets_check[2, i] > 0 then
      sgGrid.Cells[18, i + 1] := IntToStr(ballot_bets_check[2, i])
    else
      sgGrid.Cells[18, i + 1] := '';

    if ballot_bets_check[3, i] > 0 then
      sgGrid.Cells[19, i + 1] := IntToStr(ballot_bets_check[3, i])
    else
      sgGrid.Cells[19, i + 1] := '';

    if ballot_bets_data[0, i] = 0 then
      ballot_bets_csn[i] := 0
    else
      ballot_bets_csn[i] := oCSN.GetCSN();
    sgGrid.Cells[20, i + 1] := FloatToStrF(ballot_bets_csn[i], ffFixed, 15, 0);

  end;

  sgGrid.AutoSizeColumns;

  if last_checks = 1 then
    for k := 1 to 25 do
      array_check[k] := False;

end;

procedure TLotoModel.MemorizeBets;
begin
  ballot_bets_data2 := Copy(ballot_bets_data, 0, MaxInt);
  ballot_bets_check2 := Copy(ballot_bets_check, 0, MaxInt);
  ballot_bets_wins2 := Copy(ballot_bets_wins, 0, MaxInt);
  ballot_bets_csn2 := Copy(ballot_bets_csn, 0, MaxInt);
  ballot_bets_total2[0] := ballot_bets_total[0];
  ballot_bets_total2[1] := ballot_bets_total[1];
  ballot_bets_total2[2] := ballot_bets_total[2];
  ballot_bets_total2[3] := ballot_bets_total[3];
  ballot_bets_total2[4] := ballot_bets_total[4];
  //CopyMemory(@ballot_bets_data2, @ballot_bets_data[0], Length(ballot_bets_data) * SizeOf(ballot_bets_data[0]));
  //CopyMemory(@ballot_bets_check2, @ballot_bets_check[0], Length(ballot_bets_check) * SizeOf(ballot_bets_check[0]));
  //CopyMemory(@ballot_bets_total2, @ballot_bets_total[0], Length(ballot_bets_total) * SizeOf(ballot_bets_total[0]));
end;

procedure TLotoModel.RememberBets;
begin
  ballot_bets_data := Copy(ballot_bets_data2, 0, MaxInt);
  ballot_bets_check := Copy(ballot_bets_check2, 0, MaxInt);
  ballot_bets_wins := Copy(ballot_bets_wins2, 0, MaxInt);
  ballot_bets_csn := Copy(ballot_bets_csn2, 0, MaxInt);
  ballot_bets_total[0] := ballot_bets_total2[0];
  ballot_bets_total[1] := ballot_bets_total2[1];
  ballot_bets_total[2] := ballot_bets_total2[2];
  ballot_bets_total[3] := ballot_bets_total2[3];
  ballot_bets_total[4] := ballot_bets_total2[4];
end;

procedure TLotoModel.ClearBets;
begin
  ballot_bets_count := 0;
  ballot_bets_total[0] := 0;
  ballot_bets_total[1] := 0;
  ballot_bets_total[2] := 0;
  ballot_bets_total[3] := 0;
  ballot_bets_total[4] := 0;
end;

procedure TLotoModel.RefreshTotals(sLines: TStrings);
begin
  sLines.Clear;
  sLines.Add('11pts = ' + IntToStr(ballot_bets_total[0]));
  sLines.Add('12pts = ' + IntToStr(ballot_bets_total[1]));
  sLines.Add('13pts = ' + IntToStr(ballot_bets_total[2]));
  sLines.Add('14pts = ' + IntToStr(ballot_bets_total[3]));
  sLines.Add('15pts = ' + IntToStr(ballot_bets_total[4]));
end;

procedure TLotoModel.ChartHistogram(size: integer);
var
  i, k, y, s, f: integer;
  avg, min, max, std: double;
begin
  chart_count := 25;
  setlength(chart_data, 2, chart_count);
  setlength(chart_theoretical_data, chart_count);

  //chart_probability := oCSN.GetTheoreticalProbability();

  for y := 0 to chart_count - 1 do
  begin
    chart_data[0, y] := y + 1;
    chart_data[1, y] := 0;
    chart_theoretical_data[y] := trunc(size * chart_probability);
  end;

  s := ballot_history_count - size;
  f := ballot_history_count - 1;

  for i := s to f do
  begin

    for k := 0 to 5 do
    begin
      y := ballot_history_data[k, i] - 1;
      if (y >= 0) and (y < 25) then
        chart_data[1, y] += 1;
    end;

  end;

  if chart_tendency then
  begin
    if chart_waterline then
      chart_theoretical_count := 0
    else
      chart_theoretical_count := trunc(size * chart_probability);
  end;

  if chart_outliers then
  begin
    max := 0;
    min := MaxInt;
    for y := 0 to chart_count - 1 do
    begin
      avg := chart_data[1, y] - chart_theoretical_data[y];
      if avg > max then
        max := avg;
      if avg < min then
        min := avg;
    end;
    std := (max - min) / 4;  // desvio padrão aproximado

    if chart_count > 0 then
    begin
      chart_theoretical_min := trunc(chart_theoretical_data[0] - std);
      chart_theoretical_max := trunc(chart_theoretical_data[0] + std);
    end;

    {
    for y := 0 to chart_count - 1 do
    begin
      avg := chart_data[1, y] - chart_theoretical_data[y];
      if (avg >= -std) and (avg <= std) then
        chart_data[0, y] := -1;
    end;
    }

  end;

  if chart_waterline then
  begin

    if chart_count > 0 then
    begin
      chart_theoretical_min -= trunc(chart_theoretical_data[0]);
      chart_theoretical_max -= trunc(chart_theoretical_data[0]);
    end;

    for y := 0 to chart_count - 1 do
    begin
      if chart_data[0, y] >= 0 then
      begin
        chart_data[1, y] -= chart_theoretical_data[y];
        chart_theoretical_data[y] := 0;
      end;
    end;

  end;

end;

procedure TLotoModel.ChartHistogram(size: integer; module: double);
var
  i, k, y, s, f: integer;
  avg, min, max, std: double;
begin
  max := oCSN.Combine(25, 15);
  chart_count := trunc(max / module) + 1;
  setlength(chart_data, 2, chart_count);
  setlength(chart_theoretical_data, chart_count);

  f := chart_count - 1;
  for y := 0 to f do
  begin
    chart_data[0, y] := y;
    chart_data[1, y] := 0;
    if y = f then
      chart_probability := (max - (module * y)) / max
    else
      chart_probability := module / max;
    chart_theoretical_data[y] := trunc(size * chart_probability);
  end;

  s := ballot_history_count - size;
  f := ballot_history_count - 1;

  for i := s to f do
  begin

    y := trunc(ballot_history_csn[i] / module);
    if (y >= 0) and (y < chart_count) then
      chart_data[1, y] += 1;

  end;

  if chart_tendency then
  begin
    if chart_waterline then
      chart_theoretical_count := 0
    else
      chart_theoretical_count := size;  //trunc(size * chart_probability);
  end;

  if chart_outliers then
  begin
    max := 0;
    min := MaxInt;
    for y := 0 to chart_count - 1 do
    begin
      avg := chart_data[1, y] - chart_theoretical_data[y];
      if avg > max then
        max := avg;
      if avg < min then
        min := avg;
    end;
    std := (max - min) / 4;  // desvio padrão aproximado

    for y := 0 to chart_count - 1 do
    begin
      avg := chart_data[1, y] - chart_theoretical_data[y];
      if (avg >= -std) and (avg <= std) then
        chart_data[0, y] := -1;
    end;
  end;

  if chart_waterline then
  begin
    for y := 0 to chart_count - 1 do
    begin
      if chart_data[0, y] >= 0 then
      begin
        chart_data[1, y] -= chart_theoretical_data[y];
        chart_theoretical_data[y] := 0;
      end;
    end;
  end;

end;

procedure TLotoModel.ChartTimeSeries(size: integer);
var
  i, y, s, f, w: integer;
  avg, sum: double;
begin
  chart_count := size;
  setlength(chart_data, 2, chart_count);
  setlength(chart_theoretical_data, chart_count);

  s := ballot_history_count - size;
  f := ballot_history_count - 1;
  y := 0;

  for i := s to f do
  begin

    chart_data[0, y] := i + 1;
    chart_data[1, y] := ballot_history_csn[i];
    y += 1;

  end;

  if chart_tendency then
  begin
    chart_probability := 1;
    w := 10;  // tamanho da média móvel
    sum := 0;
    for y := 0 to chart_count - 1 do
    begin
      sum += chart_data[1, y];
      if y >= w then
      begin
        sum -= chart_data[1, y - w];
        avg := sum / w;
      end
      else
        avg := sum / (y + 1);
      chart_theoretical_data[y] := trunc(avg);
    end;
  end;

end;

procedure TLotoModel.ChartPositional(size, position: integer);
var
  i, k, y, s, f, p: integer;
  min, max, avg, std: double;
  a: array [0..14] of integer;
begin
  chart_count := 25;
  setlength(chart_data, 2, chart_count);
  setlength(chart_theoretical_data, chart_count);

  for y := 0 to chart_count - 1 do
  begin
    chart_data[0, y] := y + 1;
    chart_data[1, y] := 0;
    chart_probability := oCSN.GetTheoreticalProbability(y + 1, position);
    chart_theoretical_data[y] := trunc(size * chart_probability);
  end;

  s := ballot_history_count - size;
  f := ballot_history_count - 1;
  p := position - 1;

  for i := s to f do
  begin

    for k := 0 to 14 do
    begin
      a[k] := ballot_history_data[k, i] - 1;
    end;
    QuickSort(a, 15);

    for k := 0 to 14 do
    begin
      if k = p then
      begin
        y := a[k];
        if (y >= 0) and (y < 25) then
        begin
          chart_data[1, y] += 1;
        end;
      end;
    end;

  end;

  if chart_outliers then
  begin
    max := 0;
    min := MaxInt;
    for y := 0 to chart_count - 1 do
    begin
      avg := chart_data[1, y] - chart_theoretical_data[y];
      if avg > max then
        max := avg;
      if avg < min then
        min := avg;
    end;
    std := (max - min) / 4;  // desvio padrão aproximado

    for y := 0 to chart_count - 1 do
    begin
      avg := chart_data[1, y] - chart_theoretical_data[y];
      if (avg >= -std) and (avg <= std) then
        chart_data[0, y] := 0;
    end;
  end;

  if chart_waterline then
  begin
    for y := 0 to chart_count - 1 do
    begin
      if chart_data[0, y] > 0 then
      begin
        chart_data[1, y] -= chart_theoretical_data[y];
        chart_theoretical_data[y] := 0;
      end;
    end;
  end;

end;

procedure TLotoModel.ChartTheoreticalDistMinMax(size: integer);
var
  i: integer;
  p, np, p_sum, p_win: double;
begin

  p_win := 15 / 25;
  np := p_win * size;

  if np <= 10 then
  begin

    chart_theoretical_min := 0;
    chart_theoretical_max := 0;
    p_sum := 0;

    for i := 0 to size do
    begin
      //p := oCSN.GetTheoreticalProbabilityDistribution(p_win, size, i);
      p_sum += p;
      if p_sum <= 0.90 then
        chart_theoretical_max := i;
      if p_sum <= 0.10 then
        chart_theoretical_min := i;
    end;

  end;

end;

constructor TJsonLF.Create(json: string);
var
  jData: TJSONData;
  jObject: TJSONObject;
  jArray: TJSONArray;
  sLine: TStringList;
  i: integer;
begin
  jData := GetJSON(json);
  jObject := jData as TJSONObject;
  tipoJogo := jObject.Get('tipoJogo');
  numero := jObject.Get('numero');
  numeroConcursoAnterior := jObject.Get('numeroConcursoAnterior');
  numeroConcursoProximo := jObject.Get('numeroConcursoProximo');
  dataApuracao := jObject.Get('dataApuracao');
  ultimoConcurso := jObject.Get('ultimoConcurso');

  jArray := jObject.Get('listaDezenas', TJSONArray.Create);
  sLine := TStringList.Create;
  sLine.Delimiter := ';';
  for i := 0 to jArray.Count - 1 do
  begin
    sLine.Add(jArray.Strings[i]);
  end;
  listaDezenas := sLine.DelimitedText;

  jArray := jObject.Get('dezenasSorteadasOrdemSorteio', TJSONArray.Create);
  sLine.Clear;
  for i := 0 to jArray.Count - 1 do
  begin
    sLine.Add(jArray.Strings[i]);
  end;
  dezenasSorteadasOrdemSorteio := sLine.DelimitedText;
  sLine.Free;

end;

end.
