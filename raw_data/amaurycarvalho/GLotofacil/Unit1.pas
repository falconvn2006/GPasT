unit Unit1;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, CSN, Grids, Menus, clipbrd,
  FileInfo, LotoModel;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    btnCobertura: TButton;
    btnGerar: TButton;
    btnResumo: TButton;
    btnScore: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Memo1: TMemo;
    opOtimizaProp: TCheckBox;
    PageControl1: TPageControl;
    Panel2: TPanel;
    pb1: TProgressBar;
    pb2: TProgressBar;
    sg1: TStringGrid;
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    N1: TMenuItem;
    Adicionar1: TMenuItem;
    Remover1: TMenuItem;
    N2: TMenuItem;
    OrdenarpeloScore1: TMenuItem;
    ContarScores1: TMenuItem;
    Colar1: TMenuItem;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Novo1: TMenuItem;
    Abrir1: TMenuItem;
    Salvar1: TMenuItem;
    N3: TMenuItem;
    Sair1: TMenuItem;
    Ajuda1: TMenuItem;
    Sobre1: TMenuItem;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure opBrute1Click(Sender: TObject);
    procedure opBrute2Click(Sender: TObject);
    procedure opFastSearchClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Adicionar1Click(Sender: TObject);
    procedure Remover1Click(Sender: TObject);
    procedure btnScoreClick(Sender: TObject);
    procedure btnCoberturaClick(Sender: TObject);
    procedure OrdenarpeloScore1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Colar1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure Salvar1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Novo1Click(Sender: TObject);
    procedure btnResumoClick(Sender: TObject);
    procedure ContarScores1Click(Sender: TObject);
  private
    { Private declarations }
    csn: TCSN;
    stop: boolean;
    resumo: string;
    oModel: TLotoModel;
    sBetsFileName: string;
    procedure Controles(Enabled: boolean);
  public
    { Public declarations }
  end;

const
  BELOW_NORMAL_PRIORITY_CLASS = 16384;
  ABOVE_NORMAL_PRIORITY_CLASS = 32768;
  LOTTERY_ELEMENTS = 25;
  LOTTERY_COMBINE = 15;
  MIN_SCORE = 11;
  ITERATE_COUNT = 3000;

var
  Form1: TForm1;

implementation

{$R *.lfm}

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

  oModel := TLotoModel.Create;

  csn := TCSN.Create(LOTTERY_ELEMENTS, LOTTERY_COMBINE);

  pb1.Position := 1;
  pb1.Min := 1;
  pb1.Max := csn.icombineTotal;

  pb2.Position := 1;
  pb2.Min := 1;
  pb2.Max := csn.icombineTotal;

  sg1.ColCount := 6;
  sg1.RowCount := 2;

  sg1.ColWidths[0] := 50;
  sg1.ColWidths[1] := 100;

  sg1.Cells[0, 0] := '#';
  sg1.Cells[1, 0] := 'Combinação';
  sg1.Cells[2, 0] := 'CSN';
  sg1.Cells[3, 0] := 'Colisão';
  sg1.Cells[4, 0] := 'Score';
  sg1.Cells[5, 0] := 'Cobertura';

  RadioButton1Click(Sender);

  Button6.Click;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: integer;
begin

  Button2.Enabled := False;
  Button4.Enabled := False;
  Button5.Enabled := False;
  Button6.Enabled := False;
  Button7.Visible := True;
  Arquivo1.Enabled := False;
  Ajuda1.Enabled := False;
  TabSheet2.Enabled := False;

  i := StringGrid1.RowCount;

  if oModel.ImportFromInternet(StatusBar1) then
  begin

    Button6.Click;

    if StringGrid1.RowCount > i then
      i := StringGrid1.RowCount - i
    else
      i := 0;

    StatusBar1.SimpleText :=
      'Importação realizada com sucesso: ' + IntToStr(i) +
      ' sorteio(s) importado(s).';

  end
  else
  begin
    ShowMessage(oModel.errorMessage);
    Button6.Click;
    StatusBar1.SimpleText :=
      'Tente importar novamente depois de algum tempo';
  end;

  Button2.Enabled := True;
  Button4.Enabled := True;
  Button5.Enabled := True;
  Button6.Enabled := True;
  Button7.Visible := False;
  Arquivo1.Enabled := True;
  Ajuda1.Enabled := True;
  TabSheet2.Enabled := True;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin

  if not oModel.RefreshGrid(StringGrid1) then
  begin
    //ShowMessage(oModel.errorMessage);
    StatusBar1.SimpleText :=
      'Carregue os sorteios via o botão de importação';
  end
  else
    Edit1.Text := StringGrid1.Cells[17, StringGrid1.RowCount - 1];

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  oModel.stop := true;
  Button7.Visible := false;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

  csn.Free;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  s: string;
  icsn: integer;
begin

  try
    icsn := StrToInt(Edit1.Text);
  except
    icsn := 1;
  end;

  csn.SetCSN(icsn);
  s := csn.GetCombination;

  if InputQuery('Sorteio da Caixa', 'Digite a combinação:', s) then
  begin
    csn.SetCombination(s);
    Edit1.Text := FloatToStr(csn.GetCSN);
    btnScore.Click;
  end;

end;

procedure TForm1.btnGerarClick(Sender: TObject);
var
  i, k, score, samples, sample, rowcount: integer;
  tcsn: integer;
  vcsn: array of integer;
  max_score, max_sum_score, sum_score: integer;
begin

  stop := False;
  statusbar1.SimpleText := 'Aguarde, por favor ....';

  Controles(False);

  tcsn := csn.icombineTotal;

  // preparacao

  sg1.RowCount := 2;
  sg1.Rows[1].DelimitedText := '';
  rowcount := 0;

  // numero de combinacoes

  try
    samples := StrToInt(Edit2.Text);
  except
    samples := 10;
  end;
  if samples <= 0 then
    samples := 1;
  Edit2.Text := IntToStr(samples);

  SetLength(vcsn, samples + 1);

  // gera as combinaçoes

  pb1.Position := 1;
  pb1.Max := samples;
  pb2.position := 1;
  pb2.Max := tcsn;

  max_score := 0;
  max_sum_score := 0;
  sum_score := 0;

  sample := 1;
  while (sample <= samples) and (not stop) do
  begin
    pb1.Position := sample;

    // escolhe a combinaçao atual

    statusbar1.SimpleText := 'Aguarde, por favor .... escolhendo combinação.';

    //if opParetto.Checked then
    //    csn.chooseParetto
    //else
    csn.chooseRandom;

    // testa a melhor combinação
    if (opOtimizaProp.Checked) then
    begin

      if (sample > 1) then
      begin
        statusbar1.SimpleText :=
          'Aguarde, por favor .... escolhendo melhor combinação.';

        while (max_score <= csn.combineCount) do
        begin
          for i := 1 to ITERATE_COUNT do
          begin

            score := max_score + 1;
            sum_score := 0;

            for k := 1 to sample - 1 do
            begin
              score := csn.GetScore(vcsn[k]);
              sum_score := sum_score + score;
              if score > max_score then
                break;
            end;

            if score <= max_score then
              break;

            csn.chooseRandom;

            Application.ProcessMessages;
          end;
          if score <= max_score then
            break;

          max_score := max_score + 1;

        end;

      end;

    end
    else
    begin
      max_score := 0;
      if sample > 1 then
      begin
        for k := 1 to sample - 1 do
        begin
          score := csn.GetScore(vcsn[k]);
          if score > max_score then
            max_score := score;
        end;
      end;
    end;

    // adiciona a combinação na lista

    rowcount := rowcount + 1;
    sg1.RowCount := rowcount + 1;
    sg1.Cells[0, rowcount] := IntToStr(rowcount);
    sg1.Cells[1, rowcount] := csn.GetCombination;
    sg1.Cells[2, rowcount] := FloatToStrF(csn.GetCSN, ffFixed, 10, 0);
    //sg1.Cells[3, rowcount] := FloatToStrF((propag*100.0)/tcsn, ffFixed, 10, 2) + '%'
    sg1.Cells[3, rowcount] := IntToStr(max_score);
    sg1.Cells[4, rowcount] := '-';
    sg1.Cells[5, rowcount] := '-';

    vcsn[sample] := csn.GetIntCSN;

    sample := sample + 1;
    Application.ProcessMessages;

  end;

  if stop then
    statusbar1.SimpleText := 'Geração cancelada'
  else
    statusbar1.SimpleText := 'Geração finalizada';

  btnScore.Click;

  Controles(True);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin

  stop := True;

end;

procedure TForm1.Panel2Click(Sender: TObject);
begin

end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin

  //SetPriorityClass(GetCurrentProcess, BELOW_NORMAL_PRIORITY_CLASS);

end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin

  //SetPriorityClass(GetCurrentProcess, ABOVE_NORMAL_PRIORITY_CLASS);

end;

procedure TForm1.opBrute1Click(Sender: TObject);
begin

  Edit2.Enabled := False;

end;

procedure TForm1.opBrute2Click(Sender: TObject);
begin

  Edit2.Enabled := False;

end;

procedure TForm1.opFastSearchClick(Sender: TObject);
begin

  Edit2.Enabled := True;

end;

procedure TForm1.Copy1Click(Sender: TObject);
var
  i: integer;
  sl: TStringList;
begin

  sl := TStringList.Create;

  for i := 0 to sg1.RowCount - 1 do
    sl.Add(sg1.Rows[i].DelimitedText);

  clipboard.Clear;
  clipboard.AsText := sl.Text;

  sl.Free;

  ShowMessage('Copiado para a área de transferência');

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  sFile: string;
  oOpen: TOpenDialog;
  i: integer;

{var i1, i2, i3, i4, i5, i6, i7, i8, i9 : integer;
    i10, i11, i12, i13, i14, i15 : integer;
    ncsn : integer;}
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
    Button6.Click;            // refresh dos sorteios

    if StringGrid1.RowCount > i then
      i := StringGrid1.RowCount - i
    else
      i := 0;

    StatusBar1.SimpleText :=
      'Importação realizada com sucesso. ' + IntToStr(i) +
      ' sorteio(s) importado(s).';
  end
  else
  begin
    ShowMessage(oModel.errorMessage);
    StatusBar1.SimpleText :=
      'Tente fazer novo download do portal';
  end;

  oOpen.Free;

    {
    button3.Enabled := true;
    stop := false;

    ncsn := 0;
    pb1.max := csn.icombineTotal;

    for i1 := 1 to 11 do
    for i2 := i1+1 to 12 do
    for i3 := i2+1 to 13 do
    for i4 := i3+1 to 14 do
    for i5 := i4+1 to 15 do
    for i6 := i5+1 to 16 do
    for i7 := i6+1 to 17 do
    for i8 := i7+1 to 18 do
    for i9 := i8+1 to 19 do
    for i10 := i9+1 to 20 do
    for i11 := i10+1 to 21 do
    for i12 := i11+1 to 22 do
    for i13 := i12+1 to 23 do
    for i14 := i13+1 to 24 do
    for i15 := i14+1 to 25 do
    begin
        ncsn := ncsn + 1;
        pb1.Position := ncsn;
        if stop then
            exit;
        application.ProcessMessages;
    end;

    ShowMessage('Total = ' + IntToStr(ncsn));
                         }

end;

procedure TForm1.Button5Click(Sender: TObject);
//var sl : TStringList;
//    i : integer;
begin

  StringGrid1.CopyToClipboard();
  ShowMessage('Sorteios copiados para o Clipboard');

{
    if opendialog1.FileName <> '' then
        SaveDialog1.FileName := opendialog1.FileName
    else
        SaveDialog1.FileName := 'Novo grupo';

    if SaveDialog1.Execute then
    begin
        sl := TStringList.Create;
        for i := 0 to sg1.RowCount-1 do
            sl.Add(sg1.Rows[i].DelimitedText);
        sl.SaveToFile(SaveDialog1.FileName);
        sl.Free;
    end;
}

end;

procedure TForm1.Adicionar1Click(Sender: TObject);
var
  s: string;
  i: integer;
begin
  //if opParetto.Checked then
  //    csn.chooseParetto
  //else
  csn.chooseRandom;

  s := csn.GetCombination;

  if InputQuery('Adicionar', 'Digite a combinação:', s) then
  begin
    csn.SetCombination(s);

    if sg1.Cells[1, 1] <> '' then
    begin
      i := sg1.RowCount;
      sg1.RowCount := sg1.RowCount + 1;
    end
    else
      i := 1;

    sg1.Cells[0, i] := IntToStr(i);
    sg1.Cells[1, i] := csn.GetCombination;
    sg1.Cells[2, i] := FloatToStrF(csn.GetCSN, ffFixed, 10, 0);
    sg1.Cells[3, i] := '-';
    sg1.Cells[4, i] := '-';
    sg1.Cells[5, i] := '-';
  end;

end;

procedure TForm1.Remover1Click(Sender: TObject);
var
  i, r: integer;
begin

  r := sg1.row;
  if (r > 0) then
  begin
    if sg1.RowCount = 2 then
    begin
      sg1.Rows[1].DelimitedText := '';
    end
    else
    begin
      for i := r to sg1.RowCount - 2 do
      begin
        sg1.Rows[i].DelimitedText := sg1.Rows[i + 1].DelimitedText;
        sg1.Cells[0, i] := IntToStr(i);
      end;
      sg1.RowCount := sg1.RowCount - 1;
    end;
  end;

end;

procedure TForm1.btnScoreClick(Sender: TObject);
var
  i, score, samples: integer;
  icsn: integer;
  vresumo: array of integer;
  s: string;
  maior_score, qt_ms: integer;
begin

  // prepara contagem

  try
    icsn := StrToInt(Edit1.Text);
  except
    icsn := 1;
  end;
  Edit1.Text := IntToStr(icsn);

  maior_score := 0;
  qt_ms := 0;

  SetLength(vresumo, csn.combineCount + 1);
  for i := 1 to csn.combineCount do
    vresumo[i] := 0;

  samples := sg1.RowCount - 1;

  csn.SetCSN(icsn);

  // inicia contagem dos scores

  for i := 1 to samples do
  begin
    if sg1.cells[2, i] <> '' then
    begin

      icsn := StrToInt(sg1.Cells[2, i]);

      score := csn.GetScore(icsn);

      if score > maior_score then
      begin
        maior_score := score;
        qt_ms := 1;
      end
      else if score = maior_score then
      begin
        qt_ms := qt_ms + 1;
      end;

      vresumo[score] := vresumo[score] + 1;

      sg1.Cells[4, i] := IntToStr(score);
      if score >= MIN_SCORE then
        sg1.Cells[0, i] := '***' + IntToStr(i) + '***'
      else
        sg1.Cells[0, i] := IntToStr(i);

    end;
  end;

  // monta mini resumo e resumo geral

  s := '';
  resumo := 'RESUMO GERAL DE SCORES' + chr(13) + chr(10);
  resumo := resumo + '======================' + chr(13) + chr(10) + chr(13) + chr(10);
  resumo := resumo + 'SCORE; COMBINAÇÕES; PERC%' + chr(13) + chr(10);

  for i := 0 to csn.combineCount do
  begin

    resumo := resumo + IntToStr(i) + '; ' +
      IntToStr(vresumo[i]) + '; ' +
      FloatToStrF((vresumo[i] * 100.0) / samples, ffFixed, 10, 2) +
      '%' + chr(13) + chr(10);

    if i >= MIN_SCORE then
    begin
      if vresumo[i] > 0 then
      begin
        if s <> '' then
          s := s + ', ';
        s := s + IntToStr(i) + ' pts = ' + IntToStr(vresumo[i]);
      end;
    end;

  end;

  if s = '' then
    s := 'nenhum';

  // exibe mini resumo

  statusbar1.SimpleText := 'Maior score: ' + IntToStr(maior_score) +
    ' (' + IntToStr(qt_ms) + '), jogos premiados: ' + s;

end;

procedure TForm1.btnCoberturaClick(Sender: TObject);
var
  i, score: integer;
  icsn, tcsn: integer;
  propag: integer;
  vscore1: array of boolean;
begin

  stop := False;
  statusbar1.SimpleText := 'Aguarde, por favor ....';

  Controles(False);

  if sg1.cells[1, 1] <> '' then
  begin

    tcsn := csn.icombineTotal;
    propag := 0;

    SetLength(vscore1, tcsn + 1);
    for icsn := 1 to tcsn do
    begin
      vscore1[icsn] := False;
    end;

    for i := 1 to sg1.RowCount - 1 do
    begin

      if sg1.cells[2, i] <> '' then
        icsn := StrToInt(sg1.Cells[2, i])
      else
        icsn := 1;

      csn.SetCSN(icsn);

      icsn := 1;
      while (icsn <= tcsn) and (not stop) do
      begin
        if not vscore1[icsn] then
        begin
          score := csn.GetScore(icsn);

          if score >= MIN_SCORE then
          begin
            vscore1[icsn] := True;
            // marca as combinações onde ele se propagada
            propag := propag + 1;
          end;
        end;

        if (icsn mod 50000) = 0 then
        begin
          pb2.position := icsn;
          Application.ProcessMessages;
        end;

        icsn := icsn + 1;
      end;
      pb2.position := pb2.Max;

      sg1.Cells[5, i] := FloatToStrF((propag * 100.0) / tcsn, ffFixed, 10, 2) + '%';

      Application.ProcessMessages;
    end;
  end;

  if stop then
    statusbar1.SimpleText := 'Recálculo cancelado'
  else
    statusbar1.SimpleText := 'Recálculo finalizado';

  Controles(True);

end;

procedure TForm1.Controles(Enabled: boolean);
begin
  novo1.Enabled := Enabled;
  abrir1.Enabled := Enabled;
  salvar1.Enabled := Enabled;

  button1.Enabled := Enabled;
  btnGerar.Enabled := Enabled;
  button3.Enabled := not Enabled;
  btnScore.Enabled := Enabled;
  btnCobertura.Enabled := Enabled;
  btnResumo.Enabled := Enabled;

  copy1.Enabled := Enabled;
  colar1.Enabled := Enabled;
  adicionar1.Enabled := Enabled;
  remover1.Enabled := Enabled;
  ordenarpeloscore1.Enabled := Enabled;
  contarscores1.Enabled := Enabled;

  edit1.Enabled := Enabled;
  edit2.Enabled := Enabled;
  opOtimizaProp.Enabled := Enabled;
  //opParetto.enabled := enabled;
end;


procedure TForm1.OrdenarpeloScore1Click(Sender: TObject);
var
  i, j, score1, score2: integer;
  s: string;
begin

  for i := 1 to sg1.RowCount - 2 do
  begin
    for j := i + 1 to sg1.rowcount - 1 do
    begin
      try
        if (sg1.Cells[4, i] <> '') and (sg1.Cells[4, i] <> '-') then
          score1 := StrToInt(sg1.Cells[4, i])
        else
          score1 := 0;
      except
        score1 := 0;
      end;
      try
        if (sg1.Cells[4, j] <> '') and (sg1.Cells[4, j] <> '-') then
          score2 := StrToInt(sg1.Cells[4, j])
        else
          score2 := 0;
      except
        score2 := 0;
      end;
      if score1 < score2 then
      begin
        s := sg1.Rows[i].DelimitedText;
        sg1.Rows[i].DelimitedText := sg1.Rows[j].DelimitedText;
        sg1.Rows[j].DelimitedText := s;
      end;
    end;
  end;

end;

procedure TForm1.Label1Click(Sender: TObject);
begin

  //if opParetto.Checked then
  //    csn.chooseParetto
  //else
  csn.chooseRandom;

  Edit1.Text := FloatToStr(csn.GetCSN);
  btnScore.Click;

end;

procedure TForm1.Colar1Click(Sender: TObject);
var
  s, a: string;
  i, t, n: integer;
  sl: TStringList;
begin

  s := clipboard.AsText;

  if s[1] = '#' then
  begin

    sl := TStringList.Create;
    sl.Text := s;
    sg1.RowCount := sl.Count;
    for i := 0 to sl.Count - 1 do
      sg1.Rows[i].DelimitedText := sl[i];
    sl.Free;

  end
  else
  begin

    t := length(s);
    a := '';

    for i := 1 to t do
    begin
      case s[i] of
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
          a := a + s[i];
        chr(9), ',', ';', '-':
          a := a + ',';
        chr(13):
        begin
          if a <> '' then
          begin
            csn.SetCombination(a);
            n := sg1.rowCount;
            if sg1.cells[1, 1] = '' then
              n := 1
            else
              sg1.RowCount := sg1.RowCount + 1;
            sg1.Cells[0, n] := IntToStr(n);
            sg1.Cells[1, n] := csn.GetCombination;
            sg1.Cells[2, n] := IntToStr(trunc(csn.GetCSN));
            sg1.Cells[3, n] := '-';
            sg1.Cells[4, n] := '-';
            sg1.Cells[5, n] := '-';
            a := '';
          end;
        end;
      end;
    end;

  end;

  btnScore.Click;

end;

procedure TForm1.Sair1Click(Sender: TObject);
begin

  Application.Terminate;

end;

procedure TForm1.Abrir1Click(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin

  if OpenDialog1.Execute then
  begin
    sl := TStringList.Create;
    sl.LoadFromFile(opendialog1.FileName);
    sg1.RowCount := sl.Count;
    for i := 0 to sl.Count - 1 do
      sg1.Rows[i].DelimitedText := sl[i];
    sl.Free;
    btnScore.Click;
  end;

end;

procedure TForm1.Salvar1Click(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin

  if opendialog1.FileName <> '' then
    SaveDialog1.FileName := opendialog1.FileName
  else
    SaveDialog1.FileName := 'Novo grupo';

  if SaveDialog1.Execute then
  begin
    sl := TStringList.Create;
    for i := 0 to sg1.RowCount - 1 do
      sl.Add(sg1.Rows[i].DelimitedText);
    sl.SaveToFile(SaveDialog1.FileName);
    sl.Free;
  end;

end;

procedure TForm1.Sobre1Click(Sender: TObject);
begin

  ShowMessage('Gerador de combinações da Lotofácil' + sLineBreak +
    'Desenvolvido por Amaury Carvalho' + sLineBreak +
    'Setembro/2020 - Março/2023' + sLineBreak + 'amauryspires@gmail.com' +
    sLineBreak + 'https://github.com/amaurycarvalho/glotofacil');

end;

procedure TForm1.Novo1Click(Sender: TObject);
begin

  sg1.RowCount := 2;
  sg1.Rows[1].DelimitedText := '';

  opendialog1.FileName := '';

end;

procedure TForm1.btnResumoClick(Sender: TObject);
begin

  clipboard.Clear;
  clipboard.AsText := resumo;

  ShowMessage(resumo + chr(13) + chr(10) + 'Resumo copiado para o clipboard.');

end;

procedure TForm1.ContarScores1Click(Sender: TObject);
begin

  btnScore.Click;

end;

end.
