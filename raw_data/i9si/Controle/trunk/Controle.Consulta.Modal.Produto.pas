unit Controle.Consulta.Modal.Produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniLabel, uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit;

type
  TControleConsultaModalProduto = class(TControleConsultaModal)
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaPALAVRA_CHAVE: TWideStringField;
    CdsConsultaFABRICACAO: TWideStringField;
    CdsConsultaUTILIZACAO: TWideStringField;
    CdsConsultaPESO_BRUTO: TFloatField;
    CdsConsultaPESO_LIQUIDO: TFloatField;
    CdsConsultaNCM: TWideStringField;
    CdsConsultaCEST: TWideStringField;
    CdsConsultaORIGEM: TWideStringField;
    CdsConsultaCATEGORIA_ID: TFloatField;
    CdsConsultaPRECO_COMPRA: TFloatField;
    CdsConsultaPRECO_CUSTO: TFloatField;
    CdsConsultaPRECO_VENDA: TFloatField;
    CdsConsultaESTOQUE_SALDO: TFloatField;
    CdsConsultaESTOQUE_RESERVADO: TFloatField;
    CdsConsultaESTOQUE_MINIMO: TFloatField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaGRUPO_TRIBUTO_ID: TFloatField;
    CdsConsultaCATEGORIA: TWideStringField;
    UniEdit1: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalProduto: TControleConsultaModalProduto;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalProduto: TControleConsultaModalProduto;
begin
  Result := TControleConsultaModalProduto(ControleMainModule.GetFormInstance(TControleConsultaModalProduto));
end;

end.
