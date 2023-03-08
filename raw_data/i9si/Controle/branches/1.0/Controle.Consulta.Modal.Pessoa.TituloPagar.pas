unit Controle.Consulta.Modal.Pessoa.TituloPagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal.Pessoa, Data.DB,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniEdit, uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniLabel;

type
  TControleConsultaModalPessoaTituloPagar = class(TControleConsultaModalPessoa)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalPessoaTituloPagar: TControleConsultaModalPessoaTituloPagar;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalPessoaTituloPagar: TControleConsultaModalPessoaTituloPagar;
begin
  Result := TControleConsultaModalPessoaTituloPagar(ControleMainModule.GetFormInstance(TControleConsultaModalPessoaTituloPagar));
end;

end.
