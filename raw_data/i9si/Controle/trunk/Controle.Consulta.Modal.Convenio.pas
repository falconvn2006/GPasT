unit Controle.Consulta.Modal.Convenio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit;

type
  TControleConsultaModalConvenio = class(TControleConsultaModal)
    UniEdit2: TUniEdit;
    QryConsultaID: TFloatField;
    QryConsultaDESCRICAO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalConvenio: TControleConsultaModalConvenio;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function ControleConsultaModalConvenio: TControleConsultaModalConvenio;
begin
  Result := TControleConsultaModalConvenio(UniMainModule.GetFormInstance(TControleConsultaModalConvenio));
end;

end.
