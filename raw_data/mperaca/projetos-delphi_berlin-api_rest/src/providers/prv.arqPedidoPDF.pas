unit prv.arqPedidoPDF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxClass, frxDBSet, frxPreview,
  frxExportPDF, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, IniFiles;

type
  TProviderArquivoPedidoPDF = class(TForm)
    frxReport1: TfrxReport;
    frxPDFExport1: TfrxPDFExport;
    frxPreview1: TfrxPreview;
    frxDBDataset1: TfrxDBDataset;
    FDQueryPedido: TFDQuery;
    DataSource1: TDataSource;
    FDQueryPedidoCodigoInternoOrcamento: TIntegerField;
    FDQueryPedidoCodigoEmpresaOrcamento: TIntegerField;
    FDQueryPedidoNumeroOrcamento: TIntegerField;
    FDQueryPedidoDataEmissaoOrcamento: TDateField;
    FDQueryPedidoDataValidadeOrcamento: TDateField;
    FDQueryPedidoPedidoClienteOrcamento: TStringField;
    FDQueryPedidoCodigoCondicaoOrcamento: TIntegerField;
    FDQueryPedidoCodigoNaturezaOrcamento: TIntegerField;
    FDQueryPedidoCodigoClienteOrcamento: TIntegerField;
    FDQueryPedidoCodigoRepresentanteOrcamento: TIntegerField;
    FDQueryPedidoCodigoTransporteOrcamento: TIntegerField;
    FDQueryPedidoNotaGeradaOrcamento: TIntegerField;
    FDQueryPedidoDocumentoCobrancaOrcamento: TIntegerField;
    FDQueryPedidoObservacaoOrcamento: TMemoField;
    FDQueryPedidoTotalOrcamento: TBCDField;
    FDQueryPedidoBaseICMSOrcamento: TBCDField;
    FDQueryPedidoTotalICMSOrcamento: TBCDField;
    FDQueryPedidoPercentualDescontoOrcamento: TBCDField;
    FDQueryPedidoTotalDescontoOrcamento: TBCDField;
    FDQueryPedidoTotalLiquidoOrcamento: TBCDField;
    FDQueryPedidoTotalIPIOrcamento: TBCDField;
    FDQueryPedidoDescricaoServico: TMemoField;
    FDQueryPedidoValorServico: TBCDField;
    FDQueryPedidoBaseCalculoISSQN: TBCDField;
    FDQueryPedidoPercentualCalculoISSQN: TBCDField;
    FDQueryPedidoValorISSQN: TBCDField;
    FDQueryPedidoCodigoEmitenteOrcamento: TIntegerField;
    FDQueryPedidoNomeACOrcamento: TStringField;
    FDQueryPedidoCodigoAlvoOrcamento: TIntegerField;
    FDQueryPedidoBloqueadoOrcamento: TBooleanField;
    FDQueryPedidoTotalDespesaOrcamento: TBCDField;
    FDQueryPedidoTotalCreditoOrcamento: TBCDField;
    FDQueryPedidoCodigoDadosComplOrcamento: TIntegerField;
    FDQueryPedidoPrecoUtilizadoOrcamento: TStringField;
    FDQueryPedidoNumeroParcelasOrcamento: TIntegerField;
    FDQueryPedidoValorEntradaOrcamento: TBCDField;
    FDQueryPedidoEhDevolucaoOrcamento: TBooleanField;
    FDQueryPedidoTotalAcrescimoOrcamento: TBCDField;
    FDQueryPedidoHoraOrcamento: TStringField;
    FDQueryPedidoOrigemPedidoOrcamento: TStringField;
    FDQueryPedidoResponsavelOrcamento: TStringField;
    FDQueryPedidoDataEntregaCargaOrcamento: TDateField;
    FDQueryPedidoNumeroOrdemCargaOrcamento: TIntegerField;
    FDQueryPedidoIntervaloPrazoOrcamento: TIntegerField;
    FDQueryPedidoPesoTotalOrcamento: TBCDField;
    FDQueryPedidoMaquinaAcessoOrcamento: TStringField;
    FDQueryPedidoBaseICMSSubstituicaoOrcamento: TBCDField;
    FDQueryPedidoTotalICMSSubstituicaoOrcamento: TBCDField;
    FDQueryPedidoDataUltimaAlteracao: TDateField;
    FDQueryPedidoUsuarioUltimaAlteracao: TIntegerField;
    FDQueryPedidoTaxaPorParcelaOrcamento: TBCDField;
    FDQueryPedidoOrigemUltimaAlteracao: TStringField;
    FDQueryPedidoTaxaCondicaoOrcamento: TBCDField;
    FDQueryPedidoPercentualDescontoTotalOrcamento: TBCDField;
    FDQueryPedidoValorDescontoTotalOrcamento: TBCDField;
    FDQueryPedidoTotalCreditoDevolucaoOrcamento: TFMTBCDField;
    FDQueryPedidoTotalCreditoFidelidadeOrcamento: TFMTBCDField;
    FDQueryPedidoCodigoFiscalServicoOrcamento: TIntegerField;
    FDQueryPedidoModuloOrigemOrcamento: TStringField;
    FDQueryPedidoStatusConfiguracao: TStringField;
    FDQueryPedidoTotalPISOrcamento: TBCDField;
    FDQueryPedidoTotalCOFINSOrcamento: TBCDField;
    FDQueryPedidoCodigoPessoaIndicadaNota: TIntegerField;
    FDQueryPedidoCodigoAtendimentoOrcamento: TIntegerField;
    FDQueryPedidoStatusTransferenciaOrcamento: TStringField;
    FDQueryPedidoStatusAtendimentoOrcamento: TStringField;
    FDQueryPedidoUtilizarSaldoFidelidadeOrcamento: TBooleanField;
    FDQueryPedidoUtilizarSaldoDevolucaoOrcamento: TBooleanField;
    FDQueryPedidoDataOriginalOrcamento: TDateField;
    FDQueryPedidoObservacaoAdicionalOrcamento: TMemoField;
    FDQueryPedidoQtdeVolumeOrcamento: TBCDField;
    FDQueryPedidoValorFreteOrcamento: TFMTBCDField;
    FDQueryPedidoSituacaoFreteOrcamento: TStringField;
    FDQueryPedidoTotalDescontoProdutoOrcamento: TFMTBCDField;
    FDQueryPedidoPercentualAcrescimoTratadoOrcamento: TFMTBCDField;
    FDQueryPedidoEhSeparacaoOrcamento: TBooleanField;
    FDQueryPedidoStatusSeparacaoOrcamento: TIntegerField;
    FDQueryPedidoCodigoInternoSeparadorOrcamento: TIntegerField;
    FDQueryPedidoHoraInicioSeparacaoOrcamento: TSQLTimeStampField;
    FDQueryPedidoHoraFinalSeparacaoOrcamento: TSQLTimeStampField;
    FDQueryPedidoOrdemCompraClienteOrcamento: TIntegerField;
    FDQueryPedidoFinalizadoOrcamento: TBooleanField;
    FDQueryPedidoMaquinaOrigemOrcamento: TStringField;
    FDQueryPedidoCodigoCompradorOrcamento: TIntegerField;
    FDQueryPedidoxcliente: TStringField;
    FDQueryPedidoxcondicao: TStringField;
    DataSource2: TDataSource;
    FDQueryPedidoxcodproduto: TStringField;
    FDQueryPedidoxdescproduto: TStringField;
    FDQueryPedidoQuantidadeProdutoItem: TBCDField;
    FDQueryPedidoValorUnitarioItem: TBCDField;
    FDQueryPedidoValorTotalItem: TBCDField;
    FDQueryPedidoxnomeempresa: TStringField;
    FDQueryPedidoxempresacnpj: TStringField;
    FDQueryPedidoxempresaie: TStringField;
    FDQueryPedidoxempresaendereco: TStringField;
    FDQueryPedidoxempresabairro: TStringField;
    FDQueryPedidoxempresacep: TStringField;
    FDQueryPedidoxempresaemail: TStringField;
    FDQueryPedidoxempresatelefone: TStringField;
    FDQueryPedidoxvendedor: TStringField;
    FDQueryPedidoxempresacidade: TStringField;
    frxReport2: TfrxReport;
    FDQueryPedidoxtamanho: TStringField;
    FDQueryPedidoxcor: TStringField;
    procedure frxReport1BeforePrint(Sender: TfrxReportComponent);
    procedure frxReport2BeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
  public
    procedure GeraArquivo;
    function RetornaPedidoPDF(XIdPedido: integer): TFileStream;
    { Public declarations }
  end;

var
  ProviderArquivoPedidoPDF: TProviderArquivoPedidoPDF;

implementation

{$R *.dfm}

uses prv.dataModuleConexao;

{ TForm1 }

function TProviderArquivoPedidoPDF.RetornaPedidoPDF(XIdPedido: integer): TFileStream;
var warqxml,warqpdf,wcaminho,wdatabase: string;
    warqstream: TFileStream;
    wconexao: TProviderDataModuleConexao;
    warqini: TIniFile;

begin
  try
    warqini := TIniFile.Create(GetCurrentDir+'\conexao.ini');
    wdatabase := warqini.ReadString('Conexão','DataBase','');

    wconexao := TProviderDataModuleConexao.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       with FDQueryPedido do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         ParamByName('xid').AsInteger := XIdPedido;
         Open;
         EnableControls;
 //        showmessage(inttostr(RecordCount));
       end;

    frxPDFExport1.FileName   := GetCurrentDir+'\arquivos\pedido.pdf';
    frxPDFExport1.ShowDialog := false;

    if pos('Dutil',wdatabase)>0 then // Database Dutil
       begin
         frxReport2.PrepareReport();
         frxReport2.PrintOptions.ShowDialog := false;
         frxReport2.Export(frxPDFExport1);
       end
    else
       begin
         frxReport1.PrepareReport();
         frxReport1.PrintOptions.ShowDialog := false;
         frxReport1.Export(frxPDFExport1);
       end;
    // Carrega o arquivo xml da nfe
    if FileExists(frxPDFExport1.FileName) then
       warqstream  := TFileStream.Create(frxPDFExport1.FileName,fmOpenRead);
  except
  end;
  Result := warqstream;
end;

procedure TProviderArquivoPedidoPDF.frxReport1BeforePrint(
  Sender: TfrxReportComponent);
  var wmemo: TfrxMemoView;
      ix: integer;
begin
  for ix:=0 to frxReport1.ComponentCount-1 do
  begin
    if frxReport1.Components[ix].ClassName = 'TfrxMemoView' then
       begin
         wmemo := frxReport1.Components[ix] as TfrxMemoView;
         if wmemo.Name='Memo28' then
            begin
              wmemo.Memo.Clear;
              wmemo.Memo.Add('CNPJ: '+FDQueryPedidoxempresacnpj.AsString+' - IE: '+FDQueryPedidoxempresaie.AsString);
            end
         else if wmemo.Name='Memo29' then
            begin
              wmemo.Memo.Clear;
              wmemo.Memo.Add('Endereço: '+FDQueryPedidoxempresaendereco.AsString+' - CEP: '+FDQueryPedidoxempresacep.AsString);
            end
         else if wmemo.Name='Memo30' then
            begin
              wmemo.Memo.Clear;
              wmemo.Memo.Add('Bairro: '+FDQueryPedidoxempresabairro.AsString+' - '+FDQueryPedidoxempresacidade.AsString);
            end
         else if wmemo.Name='Memo31' then
            begin
              wmemo.Memo.Clear;
              wmemo.Memo.Add('Email: '+FDQueryPedidoxempresaemail.AsString+' - Fone: '+FDQueryPedidoxempresatelefone.AsString);
            end;
//         showmessage(wmemo.Name);
       end;
  end;
end;

procedure TProviderArquivoPedidoPDF.frxReport2BeforePrint(
  Sender: TfrxReportComponent);
  var wmemo: TfrxMemoView;
      ix: integer;
begin
  for ix:=0 to frxReport2.ComponentCount-1 do
  begin
    if frxReport2.Components[ix].ClassName = 'TfrxMemoView' then
       begin
         wmemo := frxReport2.Components[ix] as TfrxMemoView;
         if wmemo.Name='Memo28' then
            begin
              wmemo.Memo.Clear;
              wmemo.Memo.Add('CNPJ: '+FDQueryPedidoxempresacnpj.AsString+' - IE: '+FDQueryPedidoxempresaie.AsString);
            end
         else if wmemo.Name='Memo29' then
            begin
              wmemo.Memo.Clear;
              wmemo.Memo.Add('Endereço: '+FDQueryPedidoxempresaendereco.AsString+' - CEP: '+FDQueryPedidoxempresacep.AsString);
            end
         else if wmemo.Name='Memo30' then
            begin
              wmemo.Memo.Clear;
              wmemo.Memo.Add('Bairro: '+FDQueryPedidoxempresabairro.AsString+' - '+FDQueryPedidoxempresacidade.AsString);
            end
         else if wmemo.Name='Memo31' then
            begin
              wmemo.Memo.Clear;
              wmemo.Memo.Add('Email: '+FDQueryPedidoxempresaemail.AsString+' - Fone: '+FDQueryPedidoxempresatelefone.AsString);
            end;
//         showmessage(wmemo.Name);
       end;
  end;
end;

procedure TProviderArquivoPedidoPDF.GeraArquivo;
var wconexao: TProviderDataModuleConexao;
begin
  try
  wconexao := TProviderDataModuleConexao.Create(nil);
  with FDQueryPedido do
  begin
    Connection := wconexao.FDConnectionApi;
    DisableControls;
    Close;
    Open;
    EnableControls;
  end;

//  frxPDFExport1.DefaultPath := G
  frxPDFExport1.FileName   := GetCurrentDir+'\teste.pdf';
  frxPDFExport1.ShowDialog := false;
  frxReport1.PrepareReport();
  frxReport1.PrintOptions.ShowDialog := false;
  frxReport1.Export(frxPDFExport1);

//  frxReport1.SaveToFile(GetCurrentDir+'\teste.pdf');
  except
    On E: Exception do
    begin
      showmessage('Erro: '+E.Message);
    end;

  end;
end;

end.
