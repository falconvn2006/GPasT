unit Controle.Consulta.Integracao.ContasRecebidas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, uniLabel, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Moni.Base, FireDAC.Moni.FlatFile,
  FireDAC.Phys.IBBase, uniGUIBaseClasses, uniImageList, uniGridExporters,
  uniBasicGrid, uniEdit, uniPanel, uniDBGrid;


type
  TControleConsultaIntegracaoContasRecebidas = class(TUniFrame)
    UniPanel2: TUniPanel;
    GrdResultado: TUniDBGrid;
    UniPanelLeft: TUniPanel;
    UniHiddenPanel1: TUniHiddenPanel;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    UniEdit6: TUniEdit;
    UniEdit7: TUniEdit;
    UniEdit8: TUniEdit;
    UniPanelRight: TUniPanel;
    UniGridHTMLExporter1: TUniGridHTMLExporter;
    UniGridExcelExporter2: TUniGridExcelExporter;
    UniGridExcelExporter1: TUniGridExcelExporter;
    UniImageListExportar: TUniImageList;
    UniImageList1: TUniImageList;
    DataSource1: TDataSource;
    FDQuery1: TFDQuery;
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
    FDQuery1NUMPEDIDO: TStringField;
    FDQuery1VALOR: TFloatField;
    FDQuery1VENCIM: TDateField;
    FDQuery1CODIGO: TIntegerField;
    FDQuery1NOME: TStringField;
    FDQuery1RAZAOSOCIAL: TStringField;
    FDQuery1ENDERECO: TStringField;
    FDQuery1BAIRRO: TStringField;
    FDQuery1CNPJCPF: TStringField;
    FDQuery1INSCRG: TStringField;
    FDQuery1ESTADO: TStringField;
    FDQuery1CEP: TStringField;
    FDQuery1FONES: TStringField;
    FDQuery1FAX: TStringField;
    FDQuery1CELULAR: TStringField;
    FDQuery1EMAIL: TStringField;
    FDQuery1DTNASC: TDateField;
    FDQuery1DTCAD: TDateField;
    FDQuery1OBS: TMemoField;
    FDQuery1SEXO: TStringField;
    FDQuery1ESTCIV: TStringField;
    FDQuery1DIAS_ATRASO: TIntegerField;
    UniPanel6: TUniPanel;
    UniLabelValorTitulos: TUniFormattedNumberEdit;
    FDQuery1SomaValor: TAggregateField;
    procedure UniFrameCreate(Sender: TObject);
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
    procedure FDQuery1AfterRefresh(DataSet: TDataSet);
    procedure FDQuery1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Controle.Main, Controle.Main.Module;

{$R *.dfm}

procedure TControleConsultaIntegracaoContasRecebidas.FDQuery1AfterOpen(
  DataSet: TDataSet);
begin
  UniLabelValorTitulos.Text := FDQuery1SomaValor.AsString;
end;

procedure TControleConsultaIntegracaoContasRecebidas.FDQuery1AfterRefresh(
  DataSet: TDataSet);
begin
  UniLabelValorTitulos.Text := FDQuery1SomaValor.AsString;
end;

procedure TControleConsultaIntegracaoContasRecebidas.GrdResultadoColumnFilter(
  Sender: TUniDBGrid; const Column: TUniDBGridColumn; const Value: Variant);
var
  V : Variant;
  I : Integer;
begin
  for I := 0 to Sender.Columns.Count - 1  do
  if Sender.Columns[I].Filtering.Enabled then
  begin
    V := StringReplace(Sender.Columns[I].Filtering.VarValue, ',', '.', [rfReplaceAll]);
    V := StringReplace(V,'/','-',[rfReplaceAll]);
    FDQuery1.ParamByName(Sender.Columns[I].FieldName).Value := '%'+V+'%';
  end;
  FDQuery1.Refresh;
end;

procedure TControleConsultaIntegracaoContasRecebidas.UniFrameCreate(
  Sender: TObject);
begin
  with ControleMainModule do
  begin
   if ConectaBancoIntegracao then
    FDQuery1.open
   else
    MensageiroSweetAlerta('Atenção!' , 'Não foi possível contectar ao banco de dados de integração configurado no config.ini');
  end;
end;

end.
