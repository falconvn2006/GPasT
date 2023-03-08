unit Controle.Operacoes.logout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniButton, uniImageList,
  uniImage, uniLabel;

type
  TControleOperacoesLogout = class(TUniForm)
    UniImage1: TUniImage;
    UniLabel1: TUniLabel;
    UniButton1: TUniButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  uniGUIApplication, Vcl.Imaging.pngimage;

{$R *.dfm}


end.
