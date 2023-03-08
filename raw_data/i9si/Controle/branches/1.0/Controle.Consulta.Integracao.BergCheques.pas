unit Controle.Consulta.Integracao.BergCheques;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, Datasnap.DBClient, Vcl.Menus,
  uniMainMenu, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Moni.Base,
  FireDAC.Moni.FlatFile, FireDAC.Phys.IBBase, uniGUIBaseClasses, uniImageList,
  uniGridExporters, uniBasicGrid, uniButton, uniEdit, uniPanel, uniDBGrid,
  uniLabel;

type
  TControleConsultaIntegracaoBergCheques = class(TUniFrame)
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
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
    UniPanel1: TUniPanel;
    PanelTopBarraDireita: TUniPanel;
    botaoExportar: TUniButton;
    UniPanel21: TUniPanel;
    UniPanel3: TUniPanel;
    BotaoCalcular: TUniButton;
    LabelQtdTituloGerar: TUniLabel;
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
    UniPopupMenuExportar: TUniPopupMenu;
    Exportardadosexcel1: TUniMenuItem;
    Exportardadoshtml1: TUniMenuItem;
    CdsTitulosGerar: TClientDataSet;
    CdsTitulosGerarDIAS_ATRASO: TIntegerField;
    CdsTitulosGerarVALOR_CORRIGIDO: TFloatField;
    CdsTitulosGerarNUMERO_REFERENCIA: TIntegerField;
    CdsTitulosGerarSomaValorTotal: TAggregateField;
    CdsTitulosGerarMediaDiasAtraso: TAggregateField;
    FDQuery2: TFDQuery;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    FloatField1: TFloatField;
    DateField1: TDateField;
    IntegerField2: TIntegerField;
    StringField2: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
