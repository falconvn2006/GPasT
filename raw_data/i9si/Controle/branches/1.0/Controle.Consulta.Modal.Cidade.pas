unit Controle.Consulta.Modal.Cidade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, uniLabel, uniBitBtn,
  uniSpeedButton;

type
  TControleConsultaModalCidade = class(TControleConsultaModal)
    CdsConsultaID: TFloatField;
    CdsConsultaNOME: TWideStringField;
    CdsConsultaCODIGO_IBGE: TWideStringField;
    CdsConsultaUF: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalCidade: TControleConsultaModalCidade;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalCidade: TControleConsultaModalCidade;
begin
  Result := TControleConsultaModalCidade(ControleMainModule.GetFormInstance(TControleConsultaModalCidade));
end;

{ TControleConsultaModalCidade }

end.
