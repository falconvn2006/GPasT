unit ClientVcl.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.DBCGrids, Data.DB,
  Datasnap.DBClient, Vcl.DBCtrls, System.Actions, Vcl.ActnList, Generics.Collections,
  Vcl.Buttons, Winapi.ShellApi, System.IOUtils,

  Aurelius.Bind.BaseDataset, Aurelius.Bind.Dataset,

  Bcl.Json,
  Bcl.Logging,
  Bcl.TMSLogging,
  TMSLoggingCore,
  VCL.TMSLoggingMemoOutputHandler,

  Sparkle.Http.Client,
  XData.Client,

  Config.Service.Interfaces,
  Config.DTO,
  NFCe.Service.Interfaces,
  NFCe.DTO,

  ClientVcl.LogForm;

const
  cUriServidor = 'http://localhost:2001/tms/nuvemfiscal/nfce';
  cJwtAuthToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1NzA3NTM0MjAsImV4cCI6MjU1MTczOTAyMH0.HC-1z6F5PmoODxf2JGwQDqXSN51_25zdvYo8Cpd5K00';

type
  TItem = class;

  TClientVclMainForm = class(TForm)
    pnlCentral: TPanel;
    pnlCabecalho: TPanel;
    Panel4: TPanel;
    Image1: TImage;
    btAbrirVenda: TButton;
    lbMensagem: TLabel;
    btConsultar: TButton;
    Panel3: TPanel;
    Panel8: TPanel;
    DBGridItens: TDBCtrlGrid;
    dsItens: TDataSource;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    DBText6: TDBText;
    Label6: TLabel;
    Panel9: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel7: TPanel;
    Label5: TLabel;
    pnlProduto: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    lbTotal: TLabel;
    Label20: TLabel;
    edProduto: TEdit;
    ActionList: TActionList;
    actAbrirVenda: TAction;
    Label1: TLabel;
    adsEmitente: TAureliusDataset;
    adsEmitenteCNPJ: TStringField;
    adsEmitenteInscricaoEstadual: TStringField;
    adsEmitenteRazaoSocial: TStringField;
    adsEmitenteLogradouro: TStringField;
    adsEmitenteNumero: TStringField;
    adsEmitenteBairro: TStringField;
    adsEmitenteCidade: TStringField;
    adsEmitenteUF: TStringField;
    dsEmitente: TDataSource;
    DBText7: TDBText;
    adsEmitenteLinha1: TStringField;
    adsEmitenteLinha2: TStringField;
    adsEmitenteLinha3: TStringField;
    DBText8: TDBText;
    DBText9: TDBText;
    DBText10: TDBText;
    dsStatus: TDataSource;
    adsStatus: TAureliusDataset;
    adsStatusLinha1: TStringField;
    DBText11: TDBText;
    actCancelarVenda: TAction;
    actFinalizarVenda: TAction;
    Button1: TButton;
    actConsultarNota: TAction;
    actCancelarNota: TAction;
    actDownloadXml: TAction;
    actDownloadPdf: TAction;
    actInutilizarNumeracao: TAction;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    DBText12: TDBText;
    DBText13: TDBText;
    DBText14: TDBText;
    adsItens: TAureliusDataset;
    adsItensItem: TIntegerField;
    adsItensCodigo: TStringField;
    adsItensDescricao: TStringField;
    adsItensQuantidade: TFloatField;
    adsItensValorUnitario: TFloatField;
    adsItensValorTotal: TFloatField;
    SpeedButton1: TSpeedButton;
    Button7: TButton;
    SaveDialog: TSaveDialog;
    adsStatuscStat: TIntegerField;
    adsStatusxMotivo: TStringField;
    adsStatusversao: TStringField;
    adsStatusverAplic: TStringField;
    adsStatuscUF: TIntegerField;
    adsStatusLinha2: TStringField;
    DBText15: TDBText;
    adsStatustpAmb: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actAbrirVendaExecute(Sender: TObject);
    procedure edProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure adsEmitenteCalcFields(DataSet: TDataSet);
    procedure actCancelarVendaUpdate(Sender: TObject);
    procedure actFinalizarVendaUpdate(Sender: TObject);
    procedure actConsultarNotaUpdate(Sender: TObject);
    procedure actCancelarNotaUpdate(Sender: TObject);
    procedure actDownloadXmlUpdate(Sender: TObject);
    procedure actDownloadPdfUpdate(Sender: TObject);
    procedure actInutilizarNumeracaoUpdate(Sender: TObject);
    procedure actCancelarVendaExecute(Sender: TObject);
    procedure actFinalizarVendaExecute(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ActionListExecute(Action: TBasicAction; var Handled: Boolean);
    procedure adsItensObjectInsert(Dataset: TDataSet; AObject: TObject);
    procedure actExcluirItemUpdate(Sender: TObject);
    procedure actConsultarNotaExecute(Sender: TObject);
    procedure actDownloadPdfExecute(Sender: TObject);
    procedure actDownloadXmlExecute(Sender: TObject);
    procedure actCancelarNotaExecute(Sender: TObject);
    procedure actInutilizarNumeracaoExecute(Sender: TObject);
    procedure adsStatusCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FClient: TXDataClient;
    FNumeroNota: integer;
    FItens: TList<TItem>;
    FQuantidade: double;
    FTotal: double;
    FLogger: ILogger;
    FLogForm: TClientVclLogForm;
    function CreateXDataClient: TXDataClient;

    //
    procedure Conectar;
    procedure CarregarStatus;
    procedure CarregarConfigEmitente;
    procedure AdicionarItemNaVenda(Codigo, Descricao: string;
      Quantidade: double; ValorUnitario: Currency);

    // NFCe
    function EmitirNFCe(Serie, nNF: integer; Itens: TList<TItem>): string;
    procedure DownloadPdf(Chave: string; AbrirAutomaticamente: Boolean = False);
    procedure DownloadXml(Chave: string);
    //

    function ToJson(Obj: TObject): string;
  public
    { Public declarations }
  end;

  TItem = class
  public
    Item: integer;
    Codigo: string;
    Descricao: string;
    Quantidade: double;
    ValorUnitario: double;
    ValorTotal: double;
  end;

var
  ClientVclMainForm: TClientVclMainForm;

implementation

{$R *.dfm}

procedure TClientVclMainForm.actAbrirVendaExecute(Sender: TObject);
begin
  FQuantidade := 1;
  FTotal := 0;

  FItens.Clear;
  adsItens.Close;
  adsItens.SetSourceList(FItens);
  adsItens.Open;

  actAbrirVenda.Enabled := False;

  lbMensagem.Caption := '';
  lbTotal.Caption := FormatFloat('#,0.00', 0);

  pnlProduto.Visible := True;
  edProduto.SetFocus;
end;

procedure TClientVclMainForm.actCancelarNotaExecute(Sender: TObject);
var
  Chave, Protocolo, Justificativa: string;
  Retorno: TRetornoEnvioEventoNFeDTO;
begin
  if InputQuery('Cancelamento', 'Digite a chave da nota:', Chave) and
     InputQuery('Cancelamento', 'Digite o protocolo de autorização:', Protocolo) and
     InputQuery('Cancelamento', 'Digite o motivo do cancelamento:', Justificativa)
  then
  try
    FLogger.Trace('Cancelando nota: ' + Chave);

    Retorno := FClient.Service<INFCeService>.Cancelar(Chave, 1, Protocolo,
      Justificativa);

    Application.MessageBox(
      pChar('Status: ' + Retorno.retEvento.xMotivo + #13#10 +
      'Protocolo: ' + Retorno.retEvento.nProt),
      pChar(Retorno.cStat.ToString + ' - ' + Retorno.xMotivo),
      MB_ICONINFORMATION + MB_OK);

    FLogger.Trace('Retorno do cancelamento da nota: ' + ToJson(Retorno));
  except
    on E: EXDataClientRequestException do
    begin
      FLogger.Error('Erro ao cancelar nota: ' + E.ErrorMessage);
      Application.MessageBox(pChar(E.ErrorMessage), 'Erro ao cancelar nota', MB_ICONERROR + MB_OK);
    end
    else
      raise;
  end;
end;

procedure TClientVclMainForm.actCancelarNotaUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := actAbrirVenda.Enabled;
end;

procedure TClientVclMainForm.actCancelarVendaExecute(Sender: TObject);
begin
  adsItens.Close;
  lbTotal.Caption := FormatFloat('#,0.00', 0);
  actAbrirVenda.Enabled := True;
end;

procedure TClientVclMainForm.actCancelarVendaUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not actAbrirVenda.Enabled;
end;

procedure TClientVclMainForm.actConsultarNotaExecute(Sender: TObject);
var
  Chave: string;
  Retorno: TRetornoConsultaNFCeDTO;
begin
  if not InputQuery('Consulta', 'Digite a chave da nota:', Chave) then
    Exit;
  try
    FLogger.Trace('Consultando nota: ' + Chave);

    Retorno := FClient.Service<INFCeService>.Consultar(Chave);

    Application.MessageBox(
      pChar('Chave: ' + Retorno.protNFe.chNFe + #13#10 +
      'Protocolo: ' + Retorno.protNFe.nProt),
      pChar(Retorno.protNFe.cStat.ToString + ' - ' + Retorno.protNFe.xMotivo),
      MB_ICONINFORMATION + MB_OK);

    FLogger.Trace('Retorno da consulta de nota: ' + ToJson(Retorno));
  except
    on E: EXDataClientRequestException do
    begin
      FLogger.Error('Erro ao consultar nota: ' + E.ErrorMessage);
      Application.MessageBox(pChar(E.ErrorMessage), 'Erro ao consultar nota', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TClientVclMainForm.actConsultarNotaUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := actAbrirVenda.Enabled;
end;

procedure TClientVclMainForm.actDownloadPdfExecute(Sender: TObject);
var
  Chave: string;
begin
  if InputQuery('Download de PDF', 'Digite a chave da nota:', Chave) then
    DownloadPdf(Chave);
end;

procedure TClientVclMainForm.actDownloadPdfUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := actAbrirVenda.Enabled;
end;

procedure TClientVclMainForm.actDownloadXmlExecute(Sender: TObject);
var
  Chave: string;
begin
  if InputQuery('Download de XML', 'Digite a chave da nota:', Chave) then
    DownloadXml(Chave);
end;

procedure TClientVclMainForm.actDownloadXmlUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := actAbrirVenda.Enabled;
end;

procedure TClientVclMainForm.actExcluirItemUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not actAbrirVenda.Enabled and
                             (adsItens.RecordCount > 0);
end;

procedure TClientVclMainForm.actFinalizarVendaExecute(Sender: TObject);
var
  Chave: string;
begin
  // Emitir a NFCe
  if not TryStrToInt(InputBox('Confirmação', 'Digite o número da nota',
    (FNumeroNota + 1).ToString), FNumeroNota) then
  begin
    ShowMessage('Número da nota inválido!');
    Exit;
  end;

  try
    Chave := EmitirNFCe(1, FNumeroNota, FItens);

    if Application.MessageBox('Deseja imprimir o DANFCe?', 'Confirmação',
      MB_ICONQUESTION + MB_YESNO) = ID_YES then
    begin
      DownloadPdf(Chave, True);
    end;

    // Fechando a venda
    adsItens.Close;
    actAbrirVenda.Enabled := True;
    lbMensagem.Caption := 'CAIXA LIVRE';
    lbTotal.Caption := FormatFloat('#,0.00', 0);
  except
    on E: EXDataClientRequestException do
    begin
      FLogger.Error('Erro ao emitir nota: ' + E.ErrorMessage);
      Application.MessageBox(pChar(E.ErrorMessage), 'Erro ao emitir nota', MB_ICONERROR + MB_OK);
    end
    else
      raise;
  end;
end;

procedure TClientVclMainForm.actFinalizarVendaUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not actAbrirVenda.Enabled;
end;

procedure TClientVclMainForm.actInutilizarNumeracaoExecute(Sender: TObject);
var
  Ano, NumeroInicial, NumeroFinal: string;
  Justificativa: string;
  I: integer;
  Retorno: TRetornoInutilizacaoNFCeDTO;
begin
  if not (InputQuery('Inutilização', 'Digite o ano:', Ano) and
     InputQuery('Inutilização', 'Digite a numeração inicial:', NumeroInicial) and
     InputQuery('Inutilização', 'Digite a numeração final:', NumeroFinal) and
     InputQuery('Cancelamento', 'Digite o motivo da inutilização', Justificativa))
  then
    Exit;

  if not TryStrToInt(Ano, I) then
  begin
    ShowMessage('Ano inválido!');
    Exit;
  end;

  if not TryStrToInt(NumeroInicial, I) then
  begin
    ShowMessage('Numeração inicial inválida!');
    Exit;
  end;

  if not TryStrToInt(NumeroFinal, I) then
  begin
    ShowMessage('Numeração final inválida!');
    Exit;
  end;

  try
    FLogger.Trace('Inutilização numeração: ' + Format('[%s - %s]',
      [NumeroInicial, NumeroFinal]));

    Retorno := FClient.Service<INFCeService>.InutilizarNumeracao(StrToInt(Ano), 1,
      StrToInt(NumeroInicial), StrToInt(NumeroFinal), Justificativa);

    Application.MessageBox(
      pChar('Status: ' + Retorno.xMotivo + #13#10 +
      'Protocolo: ' + Retorno.nProt),
      pChar(Retorno.cStat.ToString + ' - ' + Retorno.xMotivo),
      MB_ICONINFORMATION + MB_OK);

    FLogger.Trace('Retorno da inutilização da numeração: ' + ToJson(Retorno));
  except
    on E: EXDataClientRequestException do
    begin
      FLogger.Error('Erro ao inutilizar numeração: ' + E.ErrorMessage);
      Application.MessageBox(pChar(E.ErrorMessage), 'Erro ao inutilizar numeração', MB_ICONERROR + MB_OK);
    end
    else
      raise;
  end;
end;

procedure TClientVclMainForm.actInutilizarNumeracaoUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := actAbrirVenda.Enabled;
end;

procedure TClientVclMainForm.ActionListExecute(Action: TBasicAction;
  var Handled: Boolean);
begin
  if Action is TAction then
    FLogger.Info('Ação Executada: ' + TAction(Action).Caption);
end;

procedure TClientVclMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  pnlProduto.Visible := not actAbrirVenda.Enabled;
end;

procedure TClientVclMainForm.AdicionarItemNaVenda(Codigo: string; Descricao: string;
  Quantidade: double; ValorUnitario: Currency);
begin
  adsItens.Append;

  if FItens.Count = 0 then
    adsItensItem.Value := 1
  else
    adsItensItem.Value := FItens.Last.Item + 1;

  adsItensCodigo.AsString := Codigo;
  adsItensDescricao.AsString := Descricao;
  adsItensQuantidade.AsFloat := Quantidade;
  adsItensValorUnitario.AsCurrency := ValorUnitario;
  adsItensValorTotal.AsFloat := Quantidade * ValorUnitario;
  adsItens.Post;
end;

procedure TClientVclMainForm.adsEmitenteCalcFields(DataSet: TDataSet);
begin
  adsEmitenteLinha1.AsString := Format('CNPJ: %s - I.E.: %s',
    [adsEmitenteCNPJ.AsString, adsEmitenteInscricaoEstadual.AsString]);

  adsEmitenteLinha2.AsString := Format('%s, %s - %s',
    [adsEmitenteLogradouro.AsString, adsEmitenteNumero.AsString, adsEmitenteBairro.AsString]);

  adsEmitenteLinha3.AsString := Format('%s - %s',
    [adsEmitenteCidade.AsString, adsEmitenteUF.AsString]);
end;

procedure TClientVclMainForm.adsItensObjectInsert(Dataset: TDataSet; AObject: TObject);
var
  Item: TItem;
begin
  if AObject is TItem then
  begin
    Item := AObject as TItem;
    FLogger.Trace(Format('Item adicionado (%d | %s | %f | %f | %f)',
      [Item.Item, Item.Descricao, Item.Quantidade, Item.ValorUnitario,
      Item.ValorTotal]));
  end;
end;

procedure TClientVclMainForm.adsStatusCalcFields(DataSet: TDataSet);
begin
  adsStatusLinha1.AsString := Format('%d - %s', [adsStatuscStat.AsInteger, adsStatusxMotivo.AsString]);
  adsStatusLinha2.AsString := adsStatustpAmb.AsString;
end;

procedure TClientVclMainForm.CarregarStatus;
var
  Status: TRetornoStatusServicoDTO;
begin
  Status := FClient.Service<INFCeService>.StatusServico;
  if Status = nil then
    raise Exception.Create('Não foi possível obter o status do serviço.');

  adsStatus.Close;
  adsStatus.SetSourceObject(Status);
  adsStatus.Open;

  FLogger.Trace('Retorno do status do serviço: ' + ToJson(Status));
end;

procedure TClientVclMainForm.CarregarConfigEmitente;
var
  Emitente: TConfigEmitenteDTO;
begin
  Emitente := FClient.Service<IConfigService>.Emitente;
  if Emitente = nil then
    raise Exception.Create('Não foi possível obter o emitente do servidor.');

  adsEmitente.Close;
  adsEmitente.SetSourceObject(Emitente);
  adsEmitente.Open;
end;

procedure TClientVclMainForm.Conectar;
begin
  CarregarConfigEmitente;
  CarregarStatus;
end;

function TClientVclMainForm.CreateXDataClient: TXDataClient;
var
  Token: string;
begin
  Token := cJwtAuthToken;
  Result := TXDataClient.Create;
  try
    Result.Uri := cURIServidor;
    Result.HttpClient.OnSendingRequest := procedure(Req: THttpRequest)
    begin
      Req.Headers.SetValue('Authorization', 'Bearer ' + Token);
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TClientVclMainForm.DownloadPdf(Chave: string; AbrirAutomaticamente: Boolean);
var
  Retorno: TStream;
  FS: TFileStream;
  FileName: string;
begin
  try
    FLogger.Trace('Baixando PDF da nota: ' + Chave);
    Retorno := FClient.Service<INFCeService>.DownloadPdf(Chave);
    try
      FLogger.Trace('Download do PDF da nota finalizado: ' + Chave);

      if AbrirAutomaticamente then
        FileName := TPath.Combine(TPath.GetTempPath, Chave + '.pdf')
      else
      begin
        SaveDialog.FileName := Chave + '.pdf';
        SaveDialog.Filter := 'Arquivo PDF|*.pdf';
        if SaveDialog.Execute then
          FileName := SaveDialog.FileName
        else
          FileName := '';
      end;

      if FileName <> '' then
      begin
        FS := TFileStream.Create(FileName, fmCreate);
        try
          Retorno.Position := 0;
          FS.CopyFrom(Retorno, 0);
          FLogger.Trace('PDF salvo em: ' + FileName);
        finally
          FS.Free;
        end;

        if AbrirAutomaticamente or (Application.MessageBox(
          pChar(
            'PDF da nota salvo com sucesso em ' + FileName + '.'#13#10#13#10 +
            'Deseja abri-lo?'
          ),
          'Confirmação',
          MB_ICONQUESTION + MB_YESNO) = ID_YES)
        then
        begin
          ShellExecute(Handle, nil, PChar(FileName), nil,  nil, SW_SHOWNORMAL);
        end;
      end
      else
        FLogger.Warning('PDF da nota não foi salvo: ' + Chave);
    finally
      Retorno.Free;
    end;
  except
    on E: EXDataClientRequestException do
    begin
      FLogger.Error('Erro ao baixar o PDF da nota: ' + E.ErrorMessage);
      Application.MessageBox(pChar(E.ErrorMessage), 'Erro ao baixar o PDF da nota', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TClientVclMainForm.DownloadXml(Chave: string);
var
  Retorno: TStream;
  FS: TFileStream;
begin
  try
    FLogger.Trace('Baixando XML da nota: ' + Chave);
    Retorno := FClient.Service<INFCeService>.DownloadXml(Chave);
    try
      FLogger.Trace('Download do XML da nota finalizado: ' + Chave);
      SaveDialog.FileName := Chave + '.xml';
      SaveDialog.Filter := 'Arquivo XML|*.xml';
      if SaveDialog.Execute then
      begin
        FS := TFileStream.Create(SaveDialog.FileName, fmCreate);
        try
          Retorno.Position := 0;
          FS.CopyFrom(Retorno, 0);
          FLogger.Trace('XML salvo em: ' + SaveDialog.FileName);
        finally
          FS.Free;
        end;

        if Application.MessageBox(
          pChar(
            'XML da nota salvo com sucesso em ' + SaveDialog.FileName + '.'#13#10#13#10 +
            'Deseja abri-lo?'
          ),
          'Confirmação',
          MB_ICONQUESTION + MB_YESNO) = ID_YES
        then
        begin
          ShellExecute(Handle, nil, PChar(SaveDialog.FileName), nil,  nil, SW_SHOWNORMAL);
        end;
      end
      else
        FLogger.Warning('XML da nota não foi salvo: ' + Chave);
    finally
      Retorno.Free;
    end;
  except
    on E: EXDataClientRequestException do
    begin
      FLogger.Error('Erro ao baixar o XML da nota: ' + E.ErrorMessage);
      Application.MessageBox(pChar(E.ErrorMessage), 'Erro ao baixar o XML da nota', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TClientVclMainForm.edProdutoKeyPress(Sender: TObject; var Key: Char);
var
  Codigo: integer;
  ValorUnitario: double;
begin
  if Key = '*' then
  begin
    if TryStrToFloat(edProduto.Text, FQuantidade) then
    begin
      Key := #0;
      edProduto.Clear;
    end;
  end
  else
  begin
    if Key = #13 then
    begin
      if edProduto.Text <> '' then
      begin
        ValorUnitario := 1 + Random(100);
        Codigo := 1 + Random(100000);

        AdicionarItemNaVenda(FormatFloat('000000', Codigo), edProduto.Text,
          FQuantidade, ValorUnitario);

        FTotal := FTotal + (FQuantidade * ValorUnitario);

        lbMensagem.Caption := adsItens.Current<TItem>.Descricao;
        lbTotal.Caption := FormatFloat('#,0.00', FTotal);

        edProduto.Clear;
        FQuantidade := 1;
        Key := #0;
      end;
    end;
  end;
end;

function TClientVclMainForm.EmitirNFCe(Serie, nNF: integer; Itens: TList<TItem>): string;
var
  Nota: TNFCeDTO;
  Prod: TDadosDetalheDTO;
  Pag: TDetalhamentoPagamentoDTO;
  RetornoEnvio: TRetornoEnvioNFCeDTO;
  Item: TItem;
begin
  Nota := TNFCeDTO.Create;
  try
    Nota.natOp := 'VENDA AO CONSUMIDOR';
    Nota.serie := Serie;
    Nota.nNF := nNF;
    Nota.dhEmi := Now;
    Nota.idDest := 1;
    Nota.indPres := 1;

//    if CpfNaNota then
//      Nota.dest := '';

    for Item in Itens do
    begin
      Prod := TDadosDetalheDTO.Create;
      Nota.det.Add(Prod);

      Prod.nItem := Item.Item;
      //Prod.cProd := '251887';
      Prod.cProd := Item.Codigo;
      Prod.cEAN := '7896523206646';
      Prod.xProd := Item.Descricao;
      Prod.NCM := '62044200';
      Prod.CFOP := '5102';
      Prod.uCom := 'UN';

      Prod.qCom := Item.Quantidade;
      Prod.vUnCom := Item.ValorUnitario;
      Prod.vProd := Item.ValorTotal;

      Prod.cEANTrib := '7896523206646';

      Prod.uTrib := 'UN';

      Prod.qTrib := Item.Quantidade;
      Prod.vUnTrib := Item.ValorUnitario;
      Prod.vDesc := 0.00;
      Prod.vOutro := 0.00;
      Prod.vTotTrib := 18.00;
    end;

    Nota.pag := TDadosPagamentoDTO.Create;

    Pag := TDetalhamentoPagamentoDTO.Create;
    Nota.pag.detPag.Add(Pag);

    Pag.tPag := 1; // dinheiro
    Pag.vPag := FTotal;

    Nota.pag.vTroco := 0.00;

    FLogger.Trace('Emitindo nota: ' + ToJson(Nota));

    RetornoEnvio := FClient.Service<INFCeService>
                    .Enviar(Nota);

    Result := RetornoEnvio.protNFe.chNFe;

    Application.MessageBox(
      pChar('Chave: ' + RetornoEnvio.protNFe.chNFe + #13#10 +
      'Protocolo: ' + RetornoEnvio.protNFe.nProt),
      pChar(RetornoEnvio.protNFe.cStat.ToString + ' - ' + RetornoEnvio.protNFe.xMotivo),
      MB_ICONINFORMATION + MB_OK);

    FLogger.Trace('Retorno de emissão de nota: ' + ToJson(RetornoEnvio));
  finally
    Nota.Release;
  end;
end;

procedure TClientVclMainForm.FormCreate(Sender: TObject);
begin
  Randomize;
  Self.Constraints.MinHeight := Self.Height;
  Self.Constraints.MinWidth := Self.Width;

  FLogForm := TClientVclLogForm.Create(Self);

  RegisterTMSLogger;
  TMSDefaultLogger.RegisterOutputHandlerClass(
    TTMSLoggerMemoOutputHandler, [FLogForm.mmLog]);
  FLogger := LogManager.GetLogger;

  FClient := CreateXDataClient;
  FNumeroNota := 0;
  FItens := TObjectList<TItem>.Create(True);
end;

procedure TClientVclMainForm.FormDestroy(Sender: TObject);
begin
  adsEmitente.Close;
  adsStatus.Close;
  adsItens.Close;
  FClient.Free;
  FItens.Free;
  FLogForm.Release;
end;

procedure TClientVclMainForm.FormShow(Sender: TObject);
var
  TryAgain: Boolean;
begin
  TryAgain := True;
  while TryAgain do
  try
    Conectar;
    TryAgain := False;
  except
    on E: Exception do
    begin
      if Application.MessageBox(
        pChar('Ocorreu um erro ao estabelecer conexão com o servidor.'#13#10 +
        E.Message), 'Erro de conexão', MB_ICONWARNING + MB_RETRYCANCEL) = ID_CANCEL
      then
      begin
        TryAgain := False;
        Close;
      end;
    end;
  end;
end;

procedure TClientVclMainForm.SpeedButton1Click(Sender: TObject);
begin
  FLogForm.Show;
end;

function TClientVclMainForm.ToJson(Obj: TObject): string;
begin
  Result := TJson.Serialize(Obj);
end;

end.
