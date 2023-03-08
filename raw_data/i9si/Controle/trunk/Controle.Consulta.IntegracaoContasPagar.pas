unit Controle.Consulta.IntegracaoContasPagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  uniCheckBox, uniLabel, uniPanel, uniBasicGrid, uniDBGrid, uniButton,
  uniGUIBaseClasses, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, uniImageList, uniGridExporters, FireDAC.Comp.DataSet,
  FireDAC.Phys.IBBase, FireDAC.Comp.UI, FireDAC.Moni.Base, FireDAC.Moni.FlatFile,
  uniEdit, Data.Win.ADODB;

type
  TControleConsultaIntegracaoContasPagar = class(TUniFrame)
    UniPanel2: TUniPanel;
    GrdResultado: TUniDBGrid;
    UniPanelLeft: TUniPanel;
    UniHiddenPanel1: TUniHiddenPanel;
    UniPanelRight: TUniPanel;
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
    UniGridHTMLExporter1: TUniGridHTMLExporter;
    UniGridExcelExporter2: TUniGridExcelExporter;
    UniGridExcelExporter1: TUniGridExcelExporter;
    UniImageListExportar: TUniImageList;
    UniImageList1: TUniImageList;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    UniEdit6: TUniEdit;
    UniEdit7: TUniEdit;
    FDQuery1: TFDQuery;
    FDQuery1NUMPEDIDO: TStringField;
    FDQuery1NOME: TStringField;
    FDQuery1VALOR: TFloatField;
    FDQuery1VENCIM: TDateField;
    FDQuery1DIAS_ATRASO: TIntegerField;
    DataSource1: TDataSource;
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Controle.Main, Controle.Main.Module;

{$R *.dfm}



procedure TControleConsultaIntegracaoContasPagar.GrdResultadoColumnFilter(
  Sender: TUniDBGrid; const Column: TUniDBGridColumn; const Value: Variant);
var
  V : Variant;
  I : Integer;
begin
  if FDQuery1.Active then
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
end;

procedure TControleConsultaIntegracaoContasPagar.UniFrameCreate(
  Sender: TObject);
begin
  with ControleMainModule do
  begin
    if ConectaBancoIntegracao then
      FDQuery1.Open
    else
      MensageiroSweetAlerta('Atenção!', 'Não foi possível contectar ao banco de dados de integração configurado no config.ini')
  end;
end;

end.
