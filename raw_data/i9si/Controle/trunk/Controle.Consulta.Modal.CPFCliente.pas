unit Controle.Consulta.Modal.CPFCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniEdit;

type
  TControleConsultaModalCPFCliente = class(TControleConsultaModal)
    UniEditCPF: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalCPFCliente: TControleConsultaModalCPFCliente;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalCPFCliente: TControleConsultaModalCPFCliente;
begin
  Result := TControleConsultaModalCPFCliente(ControleMainModule.GetFormInstance(TControleConsultaModalCPFCliente));
end;

end.
