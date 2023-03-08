unit Controle.Consulta.Modal.TipoTitulo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, uniLabel, uniBitBtn,
  uniSpeedButton;

type
  TControleConsultaModalTipoTitulo = class(TControleConsultaModal)
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaPREFIXO: TWideStringField;
    CdsConsultaGERA_BOLETO: TWideStringField;
    CdsConsultaATIVO: TWideStringField;
    UniEdit1: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalTipoTitulo: TControleConsultaModalTipoTitulo;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalTipoTitulo: TControleConsultaModalTipoTitulo;
begin
  Result := TControleConsultaModalTipoTitulo(ControleMainModule.GetFormInstance(TControleConsultaModalTipoTitulo));
end;

end.
