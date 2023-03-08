unit Controle.Livre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, UniSFSweetAlert;

type
  TControleLivre = class(TUniFrame)
    AlertaLivre: TUniSFSweetAlert;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleLivre: TControleLivre;

implementation

{$R *.dfm}

uses
  uniGUIApplication, Controle.Main.Module, Controle.Funcoes, System.TypInfo;

function ControleLivre: TControleLivre;
begin
  Result := TControleLivre(ControleMainModule.GetFormInstance(TControleLivre));
end;



end.
