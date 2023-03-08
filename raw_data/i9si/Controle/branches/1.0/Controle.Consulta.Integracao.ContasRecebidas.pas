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
    FDConnection1: TFDConnection;
    UniGridHTMLExporter1: TUniGridHTMLExporter;
    UniGridExcelExporter2: TUniGridExcelExporter;
    UniGridExcelExporter1: TUniGridExcelExporter;
    UniImageListExportar: TUniImageList;
    UniImageList1: TUniImageList;
    DataSource1: TDataSource;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDMoniFlatFileClientLink1: TFDMoniFlatFileClientLink;
    FDQuery1: TFDQuery;
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
    FDQuery1NUMPEDIDO: TStringField;
    FDQuery1NOME: TStringField;
    FDQuery1VALOR: TFloatField;
    FDQuery1VENCIM: TDateField;
    FDQuery1DIAS_ATRASO: TIntegerField;
    procedure UniFrameCreate(Sender: TObject);
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Controle.Main;

{$R *.dfm}

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
var
  vDllFirebird,
  vName : String;
  Integracao : TIntegracao;
begin
  Integracao := ControleMain.LerIniIntegracao;

  FDPhysFBDriverLink1.VendorLib := Integracao.VendorLib;

  FDConnection1.Connected := False;

  with FDConnection1 do
  begin
    Params.Values['Database']  := Integracao.Database;
    Params.Values['User_name'] := Integracao.UserName;
    Params.Values['Password']  := Integracao.Password;
    Params.Values['Protocol']  := Integracao.Protocol;
    Params.Values['Server']    := Integracao.Server;
  end;
  FDQuery1.Open();
end;

end.
