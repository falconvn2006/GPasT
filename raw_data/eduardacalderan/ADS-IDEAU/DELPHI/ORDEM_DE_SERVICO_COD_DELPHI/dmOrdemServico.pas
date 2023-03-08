unit dmOrdemServico;

interface

uses
  System.SysUtils, System.Classes, dmCadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Dialogs;

type
  TdtmOrdemServico = class(TdtmCadastro)
    dsCadastro: TDataSource;
    fdqCliente: TFDQuery;
    fdqStatus: TFDQuery;
    cdsDetalhe: TClientDataSet;
    fdqDetalhe: TFDQuery;
    fdqProduto: TFDQuery;
    fdqCadastroidOS: TFDAutoIncField;
    fdqCadastrodia: TDateField;
    fdqCadastroidCliente: TIntegerField;
    fdqCadastroIdStatus: TIntegerField;
    fdqProdutoidProduto: TFDAutoIncField;
    fdqProdutonome: TStringField;
    fdqProdutovalor: TBCDField;
    fdqProdutotipo: TStringField;
    fdqDetalhevalorTotal: TBCDField;
    fdqDetalhequantidade: TIntegerField;
    fdqDetalhevalorUnitario: TBCDField;
    fdqDetalheidOS: TIntegerField;
    fdqDetalheidProduto: TIntegerField;
    cdsDetalheidOS: TIntegerField;
    cdsDetalheidProduto: TIntegerField;
    cdsDetalhequantidade: TIntegerField;
    cdsDetalhevalorUnitario: TBCDField;
    cdsDetalhevalorTotal: TBCDField;
    cdsCadastroidOS: TAutoIncField;
    cdsCadastrodia: TDateField;
    cdsCadastroidCliente: TIntegerField;
    cdsCadastroIdStatus: TIntegerField;
    cdsCadastrofdqDetalhe: TDataSetField;
    fdqCadastrovalorTotal: TBCDField;
    cdsCadastrovalorTotal: TBCDField;
    cdsCadastrodescStatus: TStringField;
    cdsCadastronomeCliente: TStringField;
    cdsDetalhedescProduto: TStringField;
    fdqConsultaidOS: TFDAutoIncField;
    fdqConsultadia: TDateField;
    fdqConsultaidCliente: TIntegerField;
    fdqConsultaIdStatus: TIntegerField;
    fdqConsultavalorTotal: TBCDField;
    fdqConsultaidOS_1: TIntegerField;
    fdqConsultaidProduto: TIntegerField;
    fdqConsultaquantidade: TIntegerField;
    fdqConsultavalorTotal_1: TBCDField;
    fdqConsultavalorUnitario: TBCDField;
    fdqConsultanome: TStringField;
    fdqConsultaprodutos: TLargeintField;
    fdqConsultanomeProduto: TStringField;
    fdqConsultadescStatus: TStringField;
    procedure cdsCadastroNewRecord(DataSet: TDataSet);
    procedure cdsDetalheNewRecord(DataSet: TDataSet);
    procedure cdsDetalheAfterPost(DataSet: TDataSet);
    procedure cdsCadastroBeforeDelete(DataSet: TDataSet);
    procedure cdsCadastroBeforeEdit(DataSet: TDataSet);
    procedure cdsDetalheidProdutoChange(Sender: TField);
    procedure cdsDetalhevalorUnitarioChange(Sender: TField);


  private
    { Private declarations }
      valorAnterior: double;
  public
    { Public declarations }
  end;

var
  dtmOrdemServico: TdtmOrdemServico;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dmConexao;

{$R *.dfm}


procedure TdtmOrdemServico.cdsCadastroNewRecord(DataSet: TDataSet);
begin
  inherited;
  cdsCadastroidOS.AsInteger := dtmConexao.getProxId('ordemservico', 'idOS');
  cdsCadastrodia.AsDateTime := Date;
end;


procedure TdtmOrdemServico.cdsDetalheAfterPost(DataSet: TDataSet);
begin
  inherited;
if not (cdsCadastro.State in dsEditModes) then
  begin
    cdsCadastro.Edit;
  end;
     cdsCadastrovalorTotal.AsFloat := cdsCadastrovalortotal.AsFloat - valorAnterior +
    cdsDetalhevalorTotal.AsFloat;
end;


procedure TdtmOrdemServico.cdsDetalheidProdutoChange(Sender: TField);
begin
  inherited;
 if cdsDetalhe.State in dsEditModes then
  begin
    cdsDetalhevalorUnitario.Value := dtmOrdemServico.fdqProdutovalor.AsFloat;
  end;
end;

procedure TdtmOrdemServico.cdsCadastroBeforeDelete(DataSet: TDataSet);
begin
  inherited;
    if not (cdsCadastro.State in dsEditModes) then
  begin
    cdsCadastro.Edit;
  end;
  cdsCadastrovalortotal.AsFloat := cdsCadastrovalortotal.AsFloat - cdsDetalhevalortotal.AsFloat;
end;

procedure TdtmOrdemServico.cdsCadastroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  valorAnterior := cdsDetalhevalortotal.AsFloat;
end;

procedure TdtmOrdemServico.cdsDetalheNewRecord(DataSet: TDataSet);
begin
  inherited;
  cdsDetalheidOS.AsInteger := cdsCadastroidOS.AsInteger;
   valorAnterior := 0;
end;



procedure TdtmOrdemServico.cdsDetalhevalorUnitarioChange(Sender: TField);
begin
  inherited;
     cdsDetalhevalortotal.AsFloat := cdsDetalhevalorUnitario.AsFloat * cdsDetalhequantidade.AsFloat;

end;

end.
