unit Client.Aguarde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniProgressBar, uniGUIBaseClasses, uniLabel;

type
  TClientAguarde = class(TUniForm)
    UniLabel1: TUniLabel;
    UniProgressBar1: TUniProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ClientAguarde: TClientAguarde;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ClientAguarde: TClientAguarde;
begin
  Result := TClientAguarde(ControleMainModule.GetFormInstance(TClientAguarde));
end;

end.
