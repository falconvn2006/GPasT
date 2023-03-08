unit Controle.Livre.Cheque.Imagem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Vcl.Imaging.jpeg, uniGUIBaseClasses, uniImage;

type
  TControleLivreChequeImagem = class(TUniForm)
    UniImage1: TUniImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleLivreChequeImagem: TControleLivreChequeImagem;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleLivreChequeImagem: TControleLivreChequeImagem;
begin
  Result := TControleLivreChequeImagem(ControleMainModule.GetFormInstance(TControleLivreChequeImagem));
end;

end.
