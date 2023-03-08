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
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDQuery1NUMPEDIDO: TStringField;
    FDQuery1NOME: TStringField;
    FDQuery1VALOR: TFloatField;
    FDQuery1VENCIM: TDateField;
    FDQuery1DIAS_ATRASO: TIntegerField;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDMoniFlatFileClientLink1: TFDMoniFlatFileClientLink;
    DataSource1: TDataSource;
    procedure UniFrameCreate(Sender: TObject);
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Controle.Main;

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
