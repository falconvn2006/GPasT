unit Controle.Envia.Mensagem.Aguarde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniLabel, uniProgressBar,
  Vcl.Imaging.pngimage, uniImage;

type
  TControleEnviaMensagemAguarde = class(TUniForm)
    UniLabel3: TUniLabel;
    UniProgressBar1: TUniProgressBar;
    UniImage1: TUniImage;
    UniLabel2: TUniLabel;
    UniLabel4: TUniLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleEnviaMensagemAguarde: TControleEnviaMensagemAguarde;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleEnviaMensagemAguarde: TControleEnviaMensagemAguarde;
begin
  Result := TControleEnviaMensagemAguarde(ControleMainModule.GetFormInstance(TControleEnviaMensagemAguarde));
end;

end.
