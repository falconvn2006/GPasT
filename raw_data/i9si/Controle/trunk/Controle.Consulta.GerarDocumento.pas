unit Controle.Consulta.GerarDocumento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniButton, uniGUIBaseClasses, uniRadioGroup;

type
  TControleConsultaGerarDocumento = class(TUniForm)
    UniRadioGroupExporta1: TUniRadioGroup;
    UniButtonConfirmaExportacao: TUniButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaGerarDocumento: TControleConsultaGerarDocumento;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaGerarDocumento: TControleConsultaGerarDocumento;
begin
  Result := TControleConsultaGerarDocumento(ControleMainModule.GetFormInstance(TControleConsultaGerarDocumento));
end;

end.
