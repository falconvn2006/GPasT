unit Unit1;

{$mode objfpc}{$H+}
{
       Criado por Amaury Carvalho (amauryspires@gmail.com), 2019
}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls,
  Graphics, Dialogs, ComCtrls, Menus, Grids, ExtCtrls, StdCtrls, MaskEdit,
  Process, MegaModel, Clipbrd, LCLIntf, Spin, Unit2, MegaIni,
  FileInfo, CSN, NN, TASeries, TATools, TASources,
  uab, ubyteprediction;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Button1: TButton;
    Button2: TButton;
    btRefreshGraf: TButton;
    btImportarInternet: TButton;
    btImportarArquivo: TButton;
    btCopiarSorteios: TButton;
    btCopiarApostas: TButton;
    Button3: TButton;
    Button4: TButton;
    Chart1: TChart;
    cgOpcoes: TCheckGroup;
    cbHistograma: TComboBox;
    Chart2: TChart;
    Chart2Data: TLineSeries;
    Chart2Forecast: TLineSeries;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListSource2: TListChartSource;
    ListSource: TListChartSource;
    MainMenu1: TMainMenu;
    MaskEdit1: TMaskEdit;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton7: TRadioButton;
    rgVerificar: TRadioGroup;
    rgModo: TRadioGroup;
    rgTipo: TRadioGroup;
    rgAmostra: TRadioGroup;
    rgTipoGraf: TRadioGroup;
    SpinEdit1: TSpinEdit;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    UpDown1: TUpDown;
    procedure btCopiarApostasClick(Sender: TObject);
    procedure btCopiarSorteiosClick(Sender: TObject);
    procedure btImportarArquivoClick(Sender: TObject);
    procedure btImportarInternetClick(Sender: TObject);
    procedure btRefreshGrafClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure cbHistogramaChange(Sender: TObject);
    procedure cbHistogramaClick(Sender: TObject);
    procedure cgOpcoesClick(Sender: TObject);
    procedure cgOpcoesItemClick(Sender: TObject; Index: integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton7Change(Sender: TObject);
    procedure rgAmostraClick(Sender: TObject);
    procedure rgModoClick(Sender: TObject);
    procedure rgTipoClick(Sender: TObject);
    procedure rgTipoGrafClick(Sender: TObject);
    procedure rgVerificarClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure StringGrid2PrepareCanvas(Sender: TObject; aCol, aRow: integer;
      aState: TGridDrawState);
  private
    oModel: TMegaModel;
    sBetsFileName: string;
    procedure EnableAppFunctions;
    procedure geraAleatorio(size, checks, max_search, skip_last: integer);
    procedure geraFrequenciaDezenas(checks: integer);
    procedure geraMaisAcertos(size, checks, max_search, skip_last: integer);
    procedure geraMenosAcertos(size, checks, max_search, skip_last: integer);
    procedure geraOndaVerde(size, checks, max_search, skip_last: integer);
    function geraRedeNeuralCombinatoria(size, checks, max_search,
      skip_last: integer): double;
    function geraRedeNeuralPerceptron(size, checks, max_search,
      skip_last: integer): double;
    function geraRedeNeuralMaisVotadas(size, checks, max_search,
      skip_last: integer): double;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  ShowMessage('Gerenciador de combinações da Mega-Sena' + sLineBreak +
    'Desenvolvido por Amaury Carvalho' + sLineBreak + 'Fev/2019-Mar/2023' +
    sLineBreak + 'amauryspires@gmail.com' + sLineBreak +
    'https://github.com/amaurycarvalho/GMegasena' + sLineBreak + sLineBreak +
    'Implementação de Redes Neurais adaptado de Joao Paulo Schwarz Schuler' +
    ' a partir do portal CAI (Conscious Artificial Intelligence).');

end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  OpenURL('https://www.amazon.com.br/Loterias-abordagem-computacional-Amaury-Carvalho-ebook/dp/B08N5L6PRZ');
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  sBetsFileName := '';
  Button1.Click;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
var
  sFile: string;
  oOpen: TOpenDialog;
  oMegaIni: TMegaIni;
  oGrid: TStringGrid;
  i, k, rows, cols: integer;
begin

  oOpen := TOpenDialog.Create(nil);
  oMegaIni := TMegaIni.Create;

  StatusBar1.SimpleText :=
    'Abrindo um arquivo de apostas...';
  Application.ProcessMessages;

  oOpen.Filter := 'Arquivo de apostas da Caixa|*.csv';
  oOpen.Title := 'Abrir arquivo de apostas da Caixa';
  oOpen.InitialDir := oMegaIni.DataPath;
  oOpen.FileName := sBetsFileName;
  oOpen.DefaultExt := 'csv';

  oMegaIni.Free;

  if not oOpen.Execute then
  begin
    StatusBar1.SimpleText :=
      'Operação cancelada';
    oOpen.Free;
    exit;
  end;

  sFile := oOpen.FileName;

  oOpen.Free;

  if not FileExists(sFile) then
  begin
    StatusBar1.SimpleText := 'Arquivo inexistente';
    exit;
  end;

  oGrid := TStringGrid.Create(nil);
  oGrid.LoadFromCSVFile(sFile);

  if oGrid.RowCount > 1 then
  begin

    rows := oGrid.RowCount - 1;
    cols := oGrid.ColCount - 1;
    oModel.DoBets(rows);

    for i := 0 to rows - 1 do
    begin
      try
        for k := 0 to 5 do
          if k <= cols then
            oModel.ballot_bets_data[k, i] := StrToInt(oGrid.Cells[k + 1, i + 1]);
      except
        on e: Exception do
        begin
          StatusBar1.SimpleText :=
            'Erro de formato carregando o arquivo.';
          oGrid.Free;
          exit;
        end;
      end;
    end;

    sBetsFileName := sFile;

    oModel.DoChecks(10);
    oModel.RefreshBets(StringGrid2);

    StatusBar1.SimpleText :=
      'Arquivo carregado com sucesso.';
  end
  else
    StatusBar1.SimpleText := 'Erro carregando o arquivo.';

  oGrid.Free;

end;

procedure TForm1.MenuItem9Click(Sender: TObject);
var
  sFile: string;
  oSave: TSaveDialog;
  oMegaIni: TMegaIni;
begin

  oSave := TSaveDialog.Create(nil);
  oMegaIni := TMegaIni.Create;

  StatusBar1.SimpleText :=
    'Salvando um arquivo de apostas...';
  Application.ProcessMessages;

  oSave.Filter := 'Arquivo de apostas da Caixa|*.csv';
  oSave.Title := 'Salvar arquivo de apostas da Caixa';
  oSave.InitialDir := oMegaIni.DataPath;
  oSave.DefaultExt := 'csv';
  oSave.FileName := sBetsFileName;

  oMegaIni.Free;

  if not oSave.Execute then
  begin
    StatusBar1.SimpleText :=
      'Operação cancelada';
    oSave.Free;
    exit;
  end;

  sFile := oSave.FileName;

  oSave.Free;

  if FileExists(sFile) then
  begin
    DeleteFile(sFile);
  end;

  StringGrid2.SaveToCSVFile(sFile);

  sBetsFileName := sFile;

  StatusBar1.SimpleText := 'Arquivo de apostas salvo com sucesso.';

end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  oModel.DoChecks(10);
  oModel.RefreshBets(StringGrid2);
  oModel.RefreshTotals(Memo1.Lines);
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
  oModel.DoChecks(100);
  oModel.RefreshBets(StringGrid2);
  oModel.RefreshTotals(Memo1.Lines);
end;

procedure TForm1.RadioButton3Change(Sender: TObject);
begin
  oModel.DoChecks(oModel.ballot_history_count);
  oModel.RefreshBets(StringGrid2);
  oModel.RefreshTotals(Memo1.Lines);
end;

procedure TForm1.RadioButton7Change(Sender: TObject);
begin
  oModel.DoChecks(1);
  oModel.RefreshBets(StringGrid2);
  oModel.RefreshTotals(Memo1.Lines);
end;

procedure TForm1.rgAmostraClick(Sender: TObject);
begin
  btRefreshGraf.Click;
end;

procedure TForm1.rgModoClick(Sender: TObject);
begin

  rgTipo.Items.Clear;

  case rgModo.ItemIndex of
    0:
    begin
      rgTipo.Items.Add('Cartela cheia');
      rgTipo.Items.Add('Freq.dezenas');
    end;

    1:
    begin
      rgTipo.Items.Add('Mais acertos');
      rgTipo.Items.Add('Menos acertos');
      rgTipo.Items.Add('Onda verde');
    end;

    2:
    begin
      rgTipo.Items.Add('Combinatório');
      rgTipo.Items.Add('Perceptron');
      rgTipo.Items.Add('Mais votadas');
    end;
  end;

  rgTipo.ItemIndex := 0;

end;

procedure TForm1.rgTipoClick(Sender: TObject);
begin

end;

procedure TForm1.rgTipoGrafClick(Sender: TObject);
begin
  btRefreshGraf.Click;
end;

procedure TForm1.rgVerificarClick(Sender: TObject);
begin
  btRefreshGraf.Click;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  btRefreshGraf.Click;
end;

procedure TForm1.StringGrid2PrepareCanvas(Sender: TObject; aCol, aRow: integer;
  aState: TGridDrawState);
var
  i, k: integer;
begin
  // apenas quando comparando com o último sorteio
  if RadioButton7.Checked then
  begin
    if (aRow > 0) and (aCol > 0) then
    begin
      i := aRow - 1;
      k := aCol - 1;
      if (i < oModel.ballot_bets_count) and (k < 6) then
        if oModel.ballot_bets_wins[k, i] then
          (Sender as TStringGrid).Canvas.Font.Color := clRed
        else
          (Sender as TStringGrid).Canvas.Font.Color := clBlack;
    end;

  end;

end;


procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
  Button4.Click;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
  OpenURL('https://launchpad.net/gmegasena');
end;

procedure TForm1.MenuItem18Click(Sender: TObject);
begin
  OpenURL('https://sourceforge.net/projects/cai/files/');
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
var
  i: integer;
begin

  StatusBar1.SimpleText :=
    'Conectando ao portal da Caixa Economica Federal...';
  Application.ProcessMessages;

  Button3.Visible := true;
  MenuItem1.Enabled := false;
  MenuItem2.Enabled := false;
  MenuItem3.Enabled := false;
  btImportarInternet.Enabled := false;
  btImportarArquivo.Enabled := false;
  btCopiarSorteios.Enabled := false;

  i := StringGrid1.RowCount;

  if oModel.ImportFromInternet(StatusBar1) then
  begin

    MenuItem25.Click;     // refresh dos sorteios
    Button1.Click;        // refresh das apostas (geração automática)
    btRefreshGraf.Click;  // refresh dos gráficos

    if StringGrid1.RowCount > i then
      i := StringGrid1.RowCount - i
    else
      i := 0;

    EnableAppFunctions;

    StatusBar1.SimpleText :=
      'Importação realizada com sucesso. ' + IntToStr(i) + ' sorteio(s) importado(s).';

  end
  else
  begin
    ShowMessage(oModel.errorMessage);
    StatusBar1.SimpleText :=
      'Tente importar novamente daqui a alguns minutos';
  end;

  MenuItem1.Enabled := true;
  MenuItem2.Enabled := true;
  MenuItem3.Enabled := true;
  btImportarInternet.Enabled := true;
  btImportarArquivo.Enabled := true;
  btCopiarSorteios.Enabled := true;
  Button3.Visible := false;

end;

procedure TForm1.MenuItem20Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
begin
  StringGrid1.CopyToClipboard();
  ShowMessage('Sorteios copiados para o Clipboard');
end;

procedure TForm1.MenuItem23Click(Sender: TObject);
begin
  StringGrid2.CopyToClipboard();
  ShowMessage('Apostas copiadas para o Clipboard');
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
var
  sFile: string;
  oOpen: TOpenDialog;
  i: integer;
begin

  oOpen := TOpenDialog.Create(nil);

  StatusBar1.SimpleText :=
    'Importando de um arquivo já baixado do portal da Caixa...';
  Application.ProcessMessages;

  oOpen.Filter := 'Arquivo de sorteios da Caixa|*.zip';
  oOpen.Title := 'Abrir arquivo de sorteios da Caixa';

  if not oOpen.Execute then
  begin
    StatusBar1.SimpleText :=
      'Importação cancelada';
    oOpen.Free;
    exit;
  end;

  i := StringGrid1.RowCount;
  sFile := oOpen.FileName;

  if oModel.ImportFromLocalFile(sFile) then
  begin
    MenuItem25.Click;         // refresh dos sorteios
    Button1.Click;            // refresh das apostas (geração automática)
    btRefreshGraf.Click;      // refresh dos gráficos

    if StringGrid1.RowCount > i then
      i := StringGrid1.RowCount - i
    else
      i := 0;

    EnableAppFunctions;

    StatusBar1.SimpleText :=
      'Importação realizada com sucesso. ' + IntToStr(i) + ' sorteio(s) importado(s).';
  end
  else
  begin
    ShowMessage(oModel.errorMessage);
    StatusBar1.SimpleText :=
      'Tente fazer novo download do portal';
  end;

  oOpen.Free;

end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin

  if not oModel.RefreshGrid(StringGrid1) then
  begin
    //ShowMessage(oModel.errorMessage);
    StatusBar1.SimpleText :=
      'Faça a importação dos sorteios via o menu ferramentas';
  end;

end;

procedure TForm1.MenuItem27Click(Sender: TObject);
var
  sAposta: string;
  sMsg, sCSN: string;
  dCSN: double;
  oCSN: TCSN;
begin

  oCSN := TCSN.Create(60, 6);

  sAposta := '1, 2, 3, 4, 5, 6';

  if not InputQuery('Combinação para Combinatorial', 'Entre a combinação:',
    sAposta) then
    exit;

  oCSN.SetCombination(sAposta);

  dCSN := oCSN.GetCSN();
  sCSN := FloatToStrF(dCSN, ffFixed, 15, 0);

  sMsg := 'Copiado para Clipboard:' + sLineBreak + sLineBreak +
    'Número combinatorial = ' + sCSN;

  Clipboard.Clear;
  Clipboard.AsText := sCSN;

  ShowMessage(sMsg);

end;

procedure TForm1.MenuItem28Click(Sender: TObject);
var
  sAposta: string;
  sMsg, sCSN: string;
  dCSN: double;
  oCSN: TCSN;
begin

  oCSN := TCSN.Create(60, 6);

  sCSN := '1';

  if not InputQuery('Combinatorial para Combinação',
    'Entre o número combinatorial:', sCSN) then
    exit;

  try
    dCSN := StrToFloat(sCSN);
  except
    on e: Exception do
      dCSN := 1;
  end;

  oCSN.SetCSN(dCSN);

  sAposta := oCSN.GetCombination();

  sMsg := 'Copiado para Clipboard:' + sLineBreak + sLineBreak +
    'Combinação = ' + sAposta;

  Clipboard.Clear;
  Clipboard.AsText := sAposta;

  ShowMessage(sMsg);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FileVerInfo: TFileVersionInfo;
  sProductName, sVersion: string;
begin

  FileVerInfo := TFileVersionInfo.Create(nil);
  try
    FileVerInfo.ReadFileInfo;
    //writeln('Company: ',FileVerInfo.VersionStrings.Values['CompanyName']);
    //writeln('File description: ',FileVerInfo.VersionStrings.Values['FileDescription']);
    //writeln('File version: ',FileVerInfo.VersionStrings.Values['FileVersion']);
    //writeln('Internal name: ',FileVerInfo.VersionStrings.Values['InternalName']);
    //writeln('Legal copyright: ',FileVerInfo.VersionStrings.Values['LegalCopyright']);
    //writeln('Original filename: ',FileVerInfo.VersionStrings.Values['OriginalFilename']);
    //writeln('Product name: ',FileVerInfo.VersionStrings.Values['ProductName']);
    //writeln('Product version: ',FileVerInfo.VersionStrings.Values['ProductVersion']);
    sProductName := FileVerInfo.VersionStrings.Values['ProductName'];
    sVersion := FileVerInfo.VersionStrings.Values['FileVersion'];
    Form1.Caption := sProductName + ' (' + sVersion + ')';
  finally
    FileVerInfo.Free;
  end;

  Randomize;

  oModel := TMegaModel.Create;

  MenuItem25.Click;  // refresh dos sorteios

  if oModel.has_data then
  begin
    Button1.Click;            // refresh das apostas (geração automática)
    btRefreshGraf.Click;      // refresh do gráfico
    EnableAppFunctions;
    StatusBar1.SimpleText := 'Escolha a ação desejada';
  end;

end;

procedure TForm1.EnableAppFunctions;
begin
  PageControl1.Visible := True;
  MenuItem7.Enabled := True;
  MenuItem8.Enabled := True;
  MenuItem9.Enabled := True;
  MenuItem21.Enabled := True;
  MenuItem26.Enabled := True;
  btCopiarSorteios.Enabled := True;
  btCopiarApostas.Enabled := True;
  Button3.Visible := False;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  size, modo, tipo, checks, max_search, skip_last: integer;
  oIni: TMegaIni;
  error_perc: double;
begin

  try
    size := StrToInt(Trim(MaskEdit1.Text));
  except
    on E: Exception do
    begin
      ShowMessage('Quantidade de apostas inválida.');
      exit;
    end;
  end;

  if RadioButton1.Checked then
    checks := 10
  else if RadioButton2.Checked then
    checks := 100
  else if RadioButton7.Checked then
    checks := 1
  else
    checks := oModel.ballot_history_count;

  modo := rgModo.ItemIndex;
  tipo := rgTipo.ItemIndex;

  if (checks = 1) and (modo > 0) then
  begin
    ShowMessage('Só é permitido gerar com verificação' + sLineBreak +
      'somente do último no modo aleatório');
    exit;
  end;

  oIni := TMegaIni.Create;
  max_search := oIni.BetsMaxSearch;
  skip_last := oIni.BetsIgnoreLastHistory;
  oIni.Free;

  if skip_last > 0 then
    oModel.ballot_bets_skip_last := True
  else
    oModel.ballot_bets_skip_last := False;

  Button1.Enabled := False;
  Button2.Enabled := False;
  MaskEdit1.Enabled := False;
  UpDown1.Enabled := False;
  rgVerificar.Enabled := False;
  rgModo.Enabled := False;
  rgTipo.Enabled := False;
  btCopiarApostas.Enabled := False;

  ProgressBar1.Min := 0;
  ProgressBar1.Position := 0;

  StatusBar1.SimpleText := 'Gerando combinações...';
  Application.ProcessMessages;

  case modo of

    //-----------------------------------------
    // aleatório
    //-----------------------------------------
    0:
    begin

      case tipo of
        0:
        begin
          geraAleatorio(size, checks, max_search, skip_last);
        end;

        1:
        begin
          geraFrequenciaDezenas(checks);
        end;
      end;

    end;

    //-----------------------------------------
    // monte carlo
    //-----------------------------------------
    1:
    begin

      case tipo of
        //-----------------------------------------
        // maior resultado do conjunto
        //-----------------------------------------
        0:
        begin
          geraMaisAcertos(size, checks, max_search, skip_last);
        end;

        //-----------------------------------------
        // menor resultado do conjunto
        //-----------------------------------------
        1:
        begin
          geraMenosAcertos(size, checks, max_search, skip_last);
        end;

        //-----------------------------------------
        // onda verde
        //-----------------------------------------
        2:
        begin
          geraOndaVerde(size, checks, max_search, skip_last);
        end;
      end;

    end;

    //-----------------------------------------
    // rede neural
    //-----------------------------------------
    2:
    begin

      case tipo of

        //-----------------------------------------
        // combinatória
        //-----------------------------------------
        0:
        begin
          error_perc := geraRedeNeuralCombinatoria(size, checks, max_search, skip_last);
        end;

        //-----------------------------------------
        // perceptron
        //-----------------------------------------
        1:
        begin
          error_perc := geraRedeNeuralPerceptron(size, checks, max_search, skip_last);
        end;

        //-----------------------------------------
        // mais votadas
        //-----------------------------------------
        2:
        begin
          error_perc := geraRedeNeuralMaisVotadas(size, checks, max_search, skip_last);
        end;

      end;

    end;
  end;

  oModel.RefreshTotals(Memo1.Lines);

  Button1.Enabled := True;
  Button2.Enabled := True;
  MaskEdit1.Enabled := True;
  UpDown1.Enabled := True;
  rgVerificar.Enabled := True;
  rgModo.Enabled := True;
  rgTipo.Enabled := True;
  btCopiarApostas.Enabled := True;

  if modo = 2 then
  begin
    StatusBar1.SimpleText := 'Fim do treinamento da rede neural.';
    Memo1.Lines.Add('Erros = ' + FloatToStrF(error_perc, ffFixed, 6, 2) + '%');
  end
  else
    StatusBar1.SimpleText := 'Fim da geração de combinações.';

end;

procedure TForm1.geraAleatorio(size, checks, max_search, skip_last: integer);
begin
  oModel.ballot_bets_skip_last := False;
  oModel.DoBets(size);
  oModel.DoChecks(checks);
  oModel.RefreshBets(StringGrid2);
end;

procedure TForm1.geraFrequenciaDezenas(checks: integer);
var
  x, y, i, k, size: integer;
  d1, c1: array of integer;
begin
  size := 10;
  oModel.ballot_bets_skip_last := False;
  MaskEdit1.Text := IntToStr(size);
  oModel.DoBets(size);

  oModel.chart_waterline := True;
  oModel.chart_outliers := True;
  oModel.chart_tendency := True;
  oModel.ChartHistogram(100);

  setlength(d1, 60);
  setlength(c1, 60);

  for y := 0 to oModel.chart_count - 1 do
  begin

    if oModel.chart_data[0, y] >= 0 then
    begin

      d1[y] := trunc(oModel.chart_data[0, y]);
      c1[y] := trunc(oModel.chart_data[1, y]) * 1000;
      if c1[y] < 0 then
        c1[y] := c1[y] - Random(10000)
      else
        c1[y] := c1[y] + Random(10000);

    end;

  end;

  oModel.QuickSort(c1, 60, d1);
  for x := 0 to 9 do
    oModel.QuickSort(d1[x * 6], 6);

  x := 0;
  for i := 0 to size - 1 do
    for k := 0 to 5 do
    begin
      oModel.ballot_bets_data[k, i] := d1[x];
      x += 1;
    end;

  oModel.DoChecks(checks);
  oModel.RefreshBets(StringGrid2);
end;

procedure TForm1.geraMaisAcertos(size, checks, max_search, skip_last: integer);
var
  i: integer;
  bigtotal, bigtotal_a: longint;
begin
  bigtotal_a := -1;
  ProgressBar1.Max := max_search;
  ProgressBar1.Visible := True;
  Application.ProcessMessages;
  for i := 0 to max_search do
  begin
    oModel.DoBets(size);
    oModel.DoChecks(checks);

    bigtotal := oModel.ballot_bets_total[0] + oModel.ballot_bets_total[1] *
      100 + oModel.ballot_bets_total[2] * 1000 + oModel.ballot_bets_total[3];

    if bigtotal > bigtotal_a then
    begin
      bigtotal_a := bigtotal;
      oModel.MemorizeBets;
      oModel.RefreshBets(StringGrid2);
    end;

    ProgressBar1.Position := i;
    Application.ProcessMessages;
  end;

  oModel.RememberBets;
  if oModel.ballot_bets_skip_last then
  begin
    oModel.ballot_bets_skip_last := False;
    oModel.DoChecks(checks);
    oModel.RefreshBets(StringGrid2);
  end;

  ProgressBar1.Visible := False;
end;

procedure TForm1.geraMenosAcertos(size, checks, max_search, skip_last: integer);
var
  i: integer;
  bigtotal, bigtotal_a: longint;
begin
  bigtotal_a := maxLongint;
  ProgressBar1.Max := max_search;
  ProgressBar1.Visible := True;
  Application.ProcessMessages;
  for i := 0 to max_search do
  begin
    oModel.DoBets(size);
    oModel.DoChecks(checks);

    bigtotal := oModel.ballot_bets_total[0] + oModel.ballot_bets_total[1] *
      100 + oModel.ballot_bets_total[2] * 1000 + oModel.ballot_bets_total[3];

    if bigtotal < bigtotal_a then
    begin
      bigtotal_a := bigtotal;
      oModel.MemorizeBets;
      oModel.RefreshBets(StringGrid2);
    end;

    ProgressBar1.Position := i;
    Application.ProcessMessages;
  end;

  oModel.RememberBets;
  if oModel.ballot_bets_skip_last then
  begin
    oModel.ballot_bets_skip_last := False;
    oModel.DoChecks(checks);
    oModel.RefreshBets(StringGrid2);
  end;

  ProgressBar1.Visible := False;
end;

procedure TForm1.geraOndaVerde(size, checks, max_search, skip_last: integer);
var
  i: integer;
  bigtotal, bigtotal_a: longint;
begin
  bigtotal_a := -1;
  ProgressBar1.Max := max_search;
  ProgressBar1.Visible := True;
  Application.ProcessMessages;
  for i := 0 to max_search do
  begin

    oModel.DoBetsAndChecks(checks);

    bigtotal := oModel.ballot_bets_total[0] + oModel.ballot_bets_total[1] *
      100 + oModel.ballot_bets_total[2] * 1000 + oModel.ballot_bets_total[3];

    if bigtotal > bigtotal_a then
    begin
      bigtotal_a := bigtotal;
      oModel.DoBets(size);
      oModel.MemorizeBets;
      oModel.RefreshBets(StringGrid2);
    end;

    ProgressBar1.Position := i;
    Application.ProcessMessages;
  end;

  oModel.RememberBets;
  if oModel.ballot_bets_skip_last then
  begin
    oModel.ballot_bets_skip_last := False;
    oModel.DoChecks(checks);
    oModel.RefreshBets(StringGrid2);
  end;

  ProgressBar1.Visible := False;
end;

function TForm1.geraRedeNeuralCombinatoria(size, checks, max_search,
  skip_last: integer): double;
var
  i, k, x, w, f, aposta: integer;
  asort: array [0..5] of integer;
  seq: byte;

  FNeural: TEasyLearnAndPredictClass;
  aInternalState, aCurrentState, aPredictedState: array of byte;
  internalStateSize, stateSize: integer;
  secondNeuralNetworkLayerSize: integer;
  error_cnt, success_cnt: integer;
  error_perc: double;
begin
  // cria uma rede neural combinatória

  secondNeuralNetworkLayerSize := 2000; // neurons on second layer.

  internalStateSize := 1; //  the internal state is composed by x byte.
  stateSize := 7; //  the current and next states are composed by x byte.

  SetLength(aInternalState, internalStateSize);
  SetLength(aCurrentState, stateSize);
  SetLength(aPredictedState, stateSize);

  if checks > 100 then
    max_search := 50
  else if checks > 10 then
    max_search := 200
  else
    max_search := 1000;

  // prepara as apostas no grid

  oModel.DoBets(size);

  for i := 0 to size - 1 do
    for k := 0 to 5 do
      oModel.ballot_bets_data[k, i] := 0;

  oModel.RefreshBets(StringGrid2);

  ProgressBar1.Max := max_search;
  ProgressBar1.Visible := True;

  // inicia o cálculo das apostas

  error_cnt := 0;
  success_cnt := 0;

  for aposta := 0 to size - 1 do
  begin

    FNeural.Initiate(internalStateSize, stateSize, False,
      secondNeuralNetworkLayerSize, {search size} 40, {use cache} False);

    StatusBar1.SimpleText :=
      'Treinando a rede neural combinatória... aposta ' + IntToStr(aposta + 1);
    Application.ProcessMessages;

    // treina a rede

    for i := 1 to max_search do
    begin

      // updates the internal and current states.
      ABClear(aInternalState);
      ABClear(aCurrentState);
      ABClear(aPredictedState);
      seq := 0;
      w := oModel.ballot_history_count - checks;
      for x := 0 to 5 do
        aCurrentState[x] := oModel.ballot_history_data[x, w];
      aCurrentState[6] := seq;
      w += 1;

      f := oModel.ballot_history_count - 1 - skip_last;

      for k := w to f do
      begin

        // predicts the next state from aInternalState, aCurrentState into aPredictedState
        FNeural.Predict(aInternalState, aCurrentState, aPredictedState);

        // updates the current state.
        if seq < 255 then
          seq += 1
        else
          seq := 0;
        for x := 0 to 5 do
          aCurrentState[x] := oModel.ballot_history_data[x, k];
        aCurrentState[6] := seq;

        // compares aPredictedState
        // with new current state.
        // if predicted and current states don't match,
        // The smaller the number of errors, the faster the NN was able to learn.
        if (not ABCmp(aCurrentState, aPredictedState)) then
          error_cnt += 1
        else
          success_cnt += 1;

        // This method is responsible for training.
        // You can use the same code for
        // training and actually predicting.
        FNeural.newStateFound(aCurrentState);

      end;

      ProgressBar1.Position := i;
      Application.ProcessMessages;

    end;

    // infere próximo elemento

    FNeural.Predict(aInternalState, aCurrentState, aPredictedState);

    for x := 0 to 5 do
      asort[x] := aPredictedState[x];
    oModel.QuickSort(asort, length(asort));

    // preenche a aposta no grid

    for x := 0 to 5 do
      oModel.ballot_bets_data[x, aposta] := asort[x];

    oModel.RefreshBets(StringGrid2);
    Application.ProcessMessages;

  end;

  if (error_cnt > 0) or (success_cnt > 0) then
    error_perc := (error_cnt * 100) / (error_cnt + success_cnt)
  else
    error_perc := 0;

  oModel.ballot_bets_skip_last := False;
  oModel.DoChecks(checks);
  oModel.RefreshBets(StringGrid2);
  ProgressBar1.Visible := False;

  Result := error_perc;
end;

function TForm1.geraRedeNeuralPerceptron(size, checks, max_search,
  skip_last: integer): double;
var
  i, k, aposta: integer;
  error_perc: double;

  inputNeurons, maxInputs, j, inicio, final: integer;
  x, y: double;
  epocas: integer;
  nn: TNNMLP;
  csn: TCSN;
begin
  // cria uma rede neural multi layer perceptron
  // com:
  //      n neuronios na camada de input
  //      8 na camada escondida
  //      1 na camada de saída
  if checks = 10 then
    inputNeurons := 2
  else
    inputNeurons := 10;
  nn := TNNMLP.Create(inputNeurons + 1, 8, 1);
  nn.ActivationFunction := Hybrid;
  nn.LearningRate := 0.6;
  nn.LearningMinErr := 0.000000001;
  nn.LearningEpoques := 100;

  csn := TCSN.Create(60, 6);

  max_search := 30000 div checks;

  // prepara as apostas no grid

  oModel.DoBets(size);

  for i := 0 to size - 1 do
    for k := 0 to 5 do
      oModel.ballot_bets_data[k, i] := 0;

  oModel.RefreshBets(StringGrid2);

  ProgressBar1.Max := max_search;
  ProgressBar1.Visible := True;

  // tamanho da amostra

  maxInputs := checks - inputNeurons;
  inicio := oModel.ballot_history_count - maxInputs - skip_last;
  final := oModel.ballot_history_count - 1 - skip_last;

  nn.SetLearningDataSize(maxInputs);

  // gráfico de acompanhamento

  Chart2.LeftAxis.Range.Max := oModel.ballot_max_csn;
  Chart2Data.Clear;
  Chart2Forecast.Clear;
  ListSource2.Clear;

  for i := inicio to final do
  begin
    { sequencia do sorteio atual }
    x := i + 1;
    ListSource2.Add(x, 0, IntToStr(i + 1));
    { resultado do sorteio seguinte }
    y := oModel.ballot_history_csn[i];
    Chart2Data.AddXY(x, y);
  end;

  Chart2.Visible := True;

  // inicia o cálculo das apostas

  for aposta := 0 to size - 1 do
  begin

    StatusBar1.SimpleText :=
      'Treinando a rede neural perceptron... aposta ' + IntToStr(aposta + 1);
    Application.ProcessMessages;

    // dados de treino

    nn.Reset;

    for i := inicio to final do
    begin
      { resultados anteriores ao sorteio atual }
      for j := 0 to inputNeurons - 1 do
        nn.LearningInputData[i - inicio, j] :=
          oModel.ballot_history_csn[i - inputNeurons + j];
      { sequencia do sorteio atual }
      nn.LearningInputData[i - inicio, inputNeurons] := i;
      { resultado do sorteio seguinte }
      nn.LearningOutputData[i - inicio, 0] := oModel.ballot_history_csn[i];
    end;

    // treina a rede

    epocas := 0;
    y := 0;

    repeat
      epocas := epocas + 1;

      nn.Learn;

      Chart2Forecast.Clear;
      for i := 0 to maxInputs - 1 do
      begin
        nn.LoadLearningInputData(i);
        nn.Think;

        x := inicio + i + 1;
        y := trunc(nn.OutputLayerData[0]);
        Chart2Forecast.AddXY(x, y);

      end;

      ProgressBar1.Position := epocas;
      Application.ProcessMessages;

    until nn.Learned or (epocas > max_search);

    // infere próximo elemento

    { carrega último lote de treino }
    nn.LoadLearningInputData(maxInputs - 1);

    { avança 1 sorteio no último lote de treino }
    for j := 0 to inputNeurons - 1 do
      nn.InputLayerData[j] := nn.InputLayerData[j + 1];

    { resultado do último sorteio }
    nn.InputLayerData[inputNeurons - 1] :=
      oModel.ballot_history_csn[oModel.ballot_history_count - 1 - skip_last];

    { sequencia do último sorteio }
    nn.InputLayerData[inputNeurons] := oModel.ballot_history_count;

    nn.Think;

    { resultado previsto para o próximo sorteio }
    y := trunc(nn.OutputLayerData[0]);

    // preenche a aposta no grid

    csn.SetCSN(y);

    for i := 0 to 5 do
      oModel.ballot_bets_data[i, aposta] := csn.combineData[i + 1];

    oModel.RefreshBets(StringGrid2);
    Application.ProcessMessages;

  end;

  error_perc := nn.OutputLayerErrorData[0] * 1000000;

  nn.Free;
  csn.Free;

  oModel.ballot_bets_skip_last := False;
  oModel.DoChecks(checks);
  oModel.RefreshBets(StringGrid2);

  ProgressBar1.Visible := False;
  Chart2.Visible := False;

  Result := error_perc;
end;

function TForm1.geraRedeNeuralMaisVotadas(size, checks, max_search,
  skip_last: integer): double;
var
  i, k, x, rodada, rodadas: integer;
  error_perc: double;
  d1, c1, d2, c2: array of integer;

  inputNeurons, maxInputs, j, inicio, final: integer;
  y: double;
  epocas: integer;
  nn: TNNMLP;
  csn: TCSN;
begin
  // cria uma rede neural multi layer perceptron
  // com:
  //      n neuronios na camada de input
  //      8 na camada escondida
  //      1 na camada de saída
  inputNeurons := 10;
  nn := TNNMLP.Create(inputNeurons + 1, 8, 1);
  nn.ActivationFunction := Hybrid;
  nn.LearningRate := 0.6;
  nn.LearningMinErr := 0.000000001;
  nn.LearningEpoques := 100;

  csn := TCSN.Create(60, 6);

  // prepara as apostas no grid

  max_search := 300;
  rodadas := checks;
  checks := 50;
  size := 10;

  MaskEdit1.Text := IntToStr(size);
  oModel.DoBets(size);

  setlength(d1, 60);
  setlength(d2, 60);
  setlength(c1, 60);
  setlength(c2, 60);

  x := 0;
  for i := 0 to size - 1 do
    for k := 0 to 5 do
    begin
      oModel.ballot_bets_data[k, i] := x + 1;
      d1[x] := x + 1;
      c1[x] := 0;
      x += 1;
    end;

  oModel.RefreshBets(StringGrid2);

  ProgressBar1.Max := rodadas;
  ProgressBar1.Position := 0;
  ProgressBar1.Visible := True;

  // tamanho da amostra

  maxInputs := checks - inputNeurons;
  inicio := oModel.ballot_history_count - maxInputs - skip_last;
  final := oModel.ballot_history_count - 1 - skip_last;

  nn.SetLearningDataSize(maxInputs);

  // inicia o cálculo das apostas

  for rodada := 1 to rodadas do
  begin

    StatusBar1.SimpleText :=
      'Treinando a rede neural perceptron... mais votadas na rodada ' + IntToStr(rodada);
    Application.ProcessMessages;

    // dados de treino

    nn.Reset;

    for i := inicio to final do
    begin
      { resultados anteriores ao sorteio atual }
      for j := 0 to inputNeurons - 1 do
        nn.LearningInputData[i - inicio, j] :=
          oModel.ballot_history_csn[i - inputNeurons + j];
      { sequencia do sorteio atual }
      nn.LearningInputData[i - inicio, inputNeurons] := i;
      { resultado do sorteio seguinte }
      nn.LearningOutputData[i - inicio, 0] := oModel.ballot_history_csn[i];
    end;

    // treina a rede

    epocas := 0;
    y := 0;

    repeat
      epocas := epocas + 1;

      nn.Learn;

      //ProgressBar1.Position := epocas;
      Application.ProcessMessages;

    until nn.Learned or (epocas > max_search);

    // infere próximo elemento

    { carrega último lote de treino }
    nn.LoadLearningInputData(maxInputs - 1);

    { avança 1 sorteio no último lote de treino }
    for j := 0 to inputNeurons - 1 do
      nn.InputLayerData[j] := nn.InputLayerData[j + 1];

    { resultado do último sorteio }
    nn.InputLayerData[inputNeurons - 1] :=
      oModel.ballot_history_csn[oModel.ballot_history_count - 1 - skip_last];

    { sequencia do último sorteio }
    nn.InputLayerData[inputNeurons] := oModel.ballot_history_count;

    nn.Think;

    { resultado previsto para o próximo sorteio }
    y := trunc(nn.OutputLayerData[0]);

    // calcula os mais votados

    csn.SetCSN(y);

    for x := 0 to 5 do
    begin
      i := csn.combineData[x + 1];
      if (i >= 1) and (i <= 60) then
      begin
        c1[i - 1] += 1;
      end;
    end;

    // preenche o grid
    d2 := Copy(d1, 0, MaxInt);
    c2 := Copy(c1, 0, MaxInt);

    oModel.QuickSort(c2, 60, d2);
    for x := 0 to 9 do
      oModel.QuickSort(d2[x * 6], 6);

    x := 0;
    for i := 0 to size - 1 do
      for k := 0 to 5 do
      begin
        oModel.ballot_bets_data[k, i] := d2[x];
        x += 1;
      end;

    oModel.RefreshBets(StringGrid2);
    ProgressBar1.Position := rodada;
    Application.ProcessMessages;

  end;

  error_perc := nn.OutputLayerErrorData[0] * 1000000;

  nn.Free;
  csn.Free;

  oModel.ballot_bets_skip_last := False;
  oModel.DoChecks(checks);
  oModel.RefreshBets(StringGrid2);
  ProgressBar1.Visible := False;

  Result := error_perc;
end;

procedure TForm1.btRefreshGrafClick(Sender: TObject);
var
  iAmostra, y, x: integer;
  dModulo: double;
  lineSeries1, lineSeries2, lineSeries3, lineSeries4: TLineSeries;
  barSeries1: TBarSeries;
begin

  case rgAmostra.ItemIndex of
    0: iAmostra := 10;
    1: iAmostra := 100;
    else
      iAmostra := oModel.ballot_history_count;
  end;

  oModel.chart_waterline := cgOpcoes.Checked[0];
  oModel.chart_outliers := cgOpcoes.Checked[1];
  oModel.chart_tendency := cgOpcoes.Checked[2];

  Chart1.Title.Text.Clear;
  Chart1.Title.Text.Add('Sorteios da Mega-Sena');

  case rgTipoGraf.ItemIndex of
    0:  // histograma
    begin
      cgOpcoes.CheckEnabled[0] := True;
      cgOpcoes.CheckEnabled[1] := True;
      SpinEdit1.Visible := False;
      cbHistograma.Visible := True;

      Chart1.Title.Text.Add('Histograma (' + IntToStr(iAmostra) + ' amostras)');
      Chart1.LeftAxis.Title.Caption := 'Sorteios';
      Chart1.BottomAxis.Title.Caption := cbHistograma.Items[cbHistograma.ItemIndex];

      ListSource.Clear;

      if cbHistograma.ItemIndex = 0 then
      begin
        oModel.ChartHistogram(iAmostra);
        //oModel.ChartTheoreticalDistMinMax(iAmostra);

        for x := 1 to 60 do
          ListSource.Add(x, 0, IntToStr(x));
      end
      else
      begin
        case cbHistograma.ItemIndex of
          1:
          begin
            dModulo := 250000;
          end;
          2:
          begin
            dModulo := 500000;
          end;
          3:
          begin
            dModulo := 1000000;
          end;
          else
          begin
            dModulo := 10000000;
          end;
        end;
        oModel.ChartHistogram(iAmostra, dModulo);
      end;

      barSeries1 := TBarSeries.Create(Self);
      barSeries1.Clear;

      if oModel.chart_tendency then
      begin
        lineSeries1 := TLineSeries.Create(Self);
        lineSeries1.Clear;
        lineSeries1.LinePen.Width := 6;
        lineSeries1.LinePen.Color := clBlack;
      end;

      if (oModel.chart_outliers) and (cbHistograma.ItemIndex = 0) then
      begin
        lineSeries3 := TLineSeries.Create(Self);
        lineSeries3.Clear;
        lineSeries3.LinePen.Width := 6;
        lineSeries3.LinePen.Color := clGreen;
        lineSeries4 := TLineSeries.Create(Self);
        lineSeries4.Clear;
        lineSeries4.LinePen.Width := 6;
        lineSeries4.LinePen.Color := clBlue;
      end;

      for y := 0 to oModel.chart_count - 1 do
      begin
        if oModel.chart_data[0, y] >= 0 then
        begin

          barSeries1.AddXY(oModel.chart_data[0, y], oModel.chart_data[1, y]);

          if oModel.chart_tendency then
            lineSeries1.AddXY(oModel.chart_data[0, y],
              oModel.chart_theoretical_data[y]);

          if cbHistograma.ItemIndex > 0 then
            ListSource.Add(oModel.chart_data[0, y], 0,
              FloatToStrF(oModel.chart_data[0, y], ffFixed, 15, 0));

          if (oModel.chart_outliers) and (cbHistograma.ItemIndex = 0) then
          begin
            lineSeries3.AddXY(oModel.chart_data[0, y], oModel.chart_theoretical_min);
            lineSeries4.AddXY(oModel.chart_data[0, y], oModel.chart_theoretical_max);
          end;

        end;
      end;

      //barSeries1.Source := ListSource;

      Chart1.ClearSeries;
      Chart1.AddSeries(barSeries1);

      if oModel.chart_tendency then
      begin
        //lineSeries1.Source := ListSource;
        Chart1.AddSeries(lineSeries1);
      end;

      if (oModel.chart_outliers) and (cbHistograma.ItemIndex = 0) then
      begin
        Chart1.AddSeries(lineSeries3);
        Chart1.AddSeries(lineSeries4);
      end;

    end;

    1:  // periodograma
    begin
      cgOpcoes.CheckEnabled[0] := False;
      cgOpcoes.CheckEnabled[1] := False;
      SpinEdit1.Visible := False;
      cbHistograma.Visible := False;

      Chart1.Title.Text.Add('Períodograma (' + IntToStr(iAmostra) + ' amostras)');
      Chart1.BottomAxis.Title.Caption := 'Sorteio';
      Chart1.LeftAxis.Title.Caption := 'Número Combinatorial';

      oModel.ChartTimeSeries(iAmostra);

      lineSeries1 := TLineSeries.Create(Self);
      lineSeries1.Clear;
      lineSeries1.LinePen.Color := clRed;

      if oModel.chart_tendency then
      begin
        lineSeries2 := TLineSeries.Create(Self);
        lineSeries2.Clear;
        lineSeries2.LinePen.Width := 6;
        lineSeries2.LinePen.Color := clBlack;
      end;

      ListSource.Clear;

      for y := 0 to oModel.chart_count - 1 do
      begin
        if oModel.chart_data[0, y] > 0 then
        begin
          lineSeries1.AddXY(oModel.chart_data[0, y], oModel.chart_data[1, y]);
          if oModel.chart_tendency then
            lineSeries2.AddXY(oModel.chart_data[0, y], oModel.chart_theoretical_data[y]);
          ListSource.Add(oModel.chart_data[0, y], 0,
            FloatToStrF(oModel.chart_data[0, y], ffFixed, 15, 0));
        end;
      end;

      //lineSeries1.Source := ListSource;

      Chart1.ClearSeries;
      Chart1.AddSeries(lineSeries1);
      if oModel.chart_tendency then
      begin
        //lineSeries2.Source := ListSource;
        Chart1.AddSeries(lineSeries2);
      end;

    end;

    2:  // posicional
    begin
      cgOpcoes.CheckEnabled[0] := True;
      cgOpcoes.CheckEnabled[1] := True;
      SpinEdit1.Visible := True;
      cbHistograma.Visible := False;

      Chart1.Title.Text.Add('Posicional ' + IntToStr(SpinEdit1.Value) +
        ' (' + IntToStr(iAmostra) + ' amostras)');
      Chart1.BottomAxis.Title.Caption :=
        'Dezena na posição ' + IntToStr(SpinEdit1.Value);
      Chart1.LeftAxis.Title.Caption := 'Sorteios';

      oModel.ChartPositional(iAmostra, SpinEdit1.Value);

      barSeries1 := TBarSeries.Create(Self);
      barSeries1.Clear;

      if oModel.chart_tendency then
      begin
        lineSeries1 := TLineSeries.Create(Self);
        lineSeries1.Clear;
        lineSeries1.LinePen.Width := 6;
        lineSeries1.LinePen.Color := clBlack;
      end;

      for y := 0 to oModel.chart_count - 1 do
      begin
        if oModel.chart_data[0, y] > 0 then
        begin
          barSeries1.AddXY(oModel.chart_data[0, y], oModel.chart_data[1, y]);
          if oModel.chart_tendency then
            lineSeries1.AddXY(oModel.chart_data[0, y],
              oModel.chart_theoretical_data[y]);
        end;
      end;

      //barSeries1.Source := ListSource;

      Chart1.ClearSeries;
      Chart1.AddSeries(barSeries1);
      if oModel.chart_tendency then
      begin
        //lineSeries1.Source := ListSource;
        Chart1.AddSeries(lineSeries1);
      end;

      ListSource.Clear;
      for x := 1 to 60 do
        ListSource.Add(x, 0, IntToStr(x));

    end;

  end;

end;

procedure TForm1.btImportarInternetClick(Sender: TObject);
begin
  MenuItem19.Click;
end;

procedure TForm1.btImportarArquivoClick(Sender: TObject);
begin
  MenuItem24.Click;
end;

procedure TForm1.btCopiarSorteiosClick(Sender: TObject);
begin
  MenuItem22.Click;
end;

procedure TForm1.btCopiarApostasClick(Sender: TObject);
begin
  MenuItem23.Click;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  sAposta: string;
  checks: integer;
begin

  sAposta := '1, 2, 3, 4, 5, 6';

  if not InputQuery('Entrada de apostas', 'Entre a sua aposta:', sAposta) then
    exit;

  if not oModel.AddBet(sAposta) then
    ShowMessage('Aposta no formato inválido')
  else
  begin
    if RadioButton1.Checked then
      checks := 10
    else if RadioButton2.Checked then
      checks := 100
    else if RadioButton7.Checked then
      checks := 1
    else
      checks := oModel.ballot_history_count;

    oModel.DoChecks(checks);
    oModel.RefreshBets(StringGrid2);
  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  oModel.stop := true;
  Button3.Visible := false;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin

  Chart1.CopyToClipboardBitmap;

  ShowMessage('Gráfico copiado para o clipboard');

end;

procedure TForm1.cbHistogramaChange(Sender: TObject);
begin
  btRefreshGraf.Click;
end;

procedure TForm1.cbHistogramaClick(Sender: TObject);
begin
end;

procedure TForm1.cgOpcoesClick(Sender: TObject);
begin
  btRefreshGraf.Click;
end;

procedure TForm1.cgOpcoesItemClick(Sender: TObject; Index: integer);
begin
  btRefreshGraf.Click;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

  oModel.Free;

end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  OpenURL('http://loterias.caixa.gov.br');
end;


{
 function DownloadHTTP(URL, TargetFile: string): Boolean;
 // Download file; retry if necessary.
 // Could use Synapse HttpGetBinary, but that doesn't deal
 // with result codes (i.e. it happily downloads a 404 error document)
 const
   MaxRetries = 3;
 var
   HTTPGetResult: Boolean;
   HTTPSender: THTTPSend;
   RetryAttempt: Integer;
 begin
   Result := False;
   RetryAttempt := 1;
   HTTPSender := THTTPSend.Create;
   try
     try
       // Try to get the file
       HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
       while (HTTPGetResult = False) and (RetryAttempt < MaxRetries) do
       begin
         Sleep(500 * RetryAttempt);
         HTTPSender.Clear;
         HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
         RetryAttempt := RetryAttempt + 1;
       end;
       // If we have an answer from the server, check if the file
       // was sent to us.
       case HTTPSender.Resultcode of
         100..299:
           begin
             HTTPSender.Document.SaveToFile(TargetFile);
             Result := True;
           end; //informational, success
         300..399: Result := False; // redirection. Not implemented, but could be.
         400..499: Result := False; // client error; 404 not found etc
         500..599: Result := False; // internal server error
         else Result := False; // unknown code
       end;
     except
       // We don't care for the reason for this error; the download failed.
       Result := False;
     end;
   finally
     HTTPSender.Free;
   end;
 end;
}

end.
