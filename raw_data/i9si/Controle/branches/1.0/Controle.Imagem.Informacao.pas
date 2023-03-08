unit Controle.Imagem.Informacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniLabel, uniButton, uniGUIBaseClasses, uniMemo;

type
  TControleImagemInformacao = class(TUniForm)
    UniMemo1: TUniMemo;
    UniButton1: TUniButton;
    UniLabel1: TUniLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  uniGUIApplication;

{$R *.dfm}


end.
