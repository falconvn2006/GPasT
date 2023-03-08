unit Controle.Impressao.Documento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Impressao, uniScreenMask,
  uniGUIBaseClasses, uniImageList, uniURLFrame, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel,  uniTimer;

type
  TControleImpressaoDocumento = class(TControleImpressao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleImpressaoDocumento: TControleImpressaoDocumento;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleImpressaoDocumento: TControleImpressaoDocumento;
begin
  Result := TControleImpressaoDocumento(ControleMainModule.GetFormInstance(TControleImpressaoDocumento));
end;

end.
