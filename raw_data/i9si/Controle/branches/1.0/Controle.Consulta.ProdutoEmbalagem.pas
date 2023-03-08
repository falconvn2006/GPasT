unit Controle.Consulta.ProdutoEmbalagem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniCheckBox, uniLabel,
  uniPanel, uniDBGrid, Vcl.Imaging.pngimage, uniImage, uniBitBtn, 
  uniButton, uniEdit, unimEdit;

type
  TControleConsultaProdutoEmbalagem = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaPRODUTO_ID: TFloatField;
    CdsConsultaDESCRICAO_PRODUTO: TWideStringField;
    CdsConsultaUNIDADE_MEDIDA_ID: TFloatField;
    CdsConsultaDESCRICAO_UNIDADE_MEDIDA: TWideStringField;
    CdsConsultaCODIGO_EAN: TWideStringField;
    CdsConsultaQUANTIDADE: TFloatField;
    CdsConsultaCONTROLA_ESTOQUE: TWideStringField;
    CdsConsultaACRESCIMO_DESCONTO: TFloatField;
    CdsConsultaATIVO: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
