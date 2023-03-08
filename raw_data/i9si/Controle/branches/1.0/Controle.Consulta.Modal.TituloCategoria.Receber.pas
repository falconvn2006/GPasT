unit Controle.Consulta.Modal.TituloCategoria.Receber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, uniLabel;

type
  TControleConsultaModalTituloCategoriaReceber = class(TControleConsultaModal)
    QryConsultaID: TFloatField;
    QryConsultaDESCRICAO: TWideStringField;
    QryConsultaTIPO_TITULO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaTIPO_TITULO: TWideStringField;
    UniEdit1: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalTituloCategoriaReceber: TControleConsultaModalTituloCategoriaReceber;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalTituloCategoriaReceber: TControleConsultaModalTituloCategoriaReceber;
begin
  Result := TControleConsultaModalTituloCategoriaReceber(ControleMainModule.GetFormInstance(TControleConsultaModalTituloCategoriaReceber));
end;

end.
