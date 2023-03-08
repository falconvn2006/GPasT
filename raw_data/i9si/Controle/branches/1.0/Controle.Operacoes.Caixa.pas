unit Controle.Operacoes.Caixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes,  Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton, uniPanel;

type
  TControleOperacoesCaixa = class(TControleOperacoes)
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    UniButton3: TUniButton;
    UniImageList3: TUniImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleOperacoesCaixa: TControleOperacoesCaixa;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleOperacoesCaixa: TControleOperacoesCaixa;
begin
  Result := TControleOperacoesCaixa(ControleMainModule.GetFormInstance(TControleOperacoesCaixa));
end;

end.
