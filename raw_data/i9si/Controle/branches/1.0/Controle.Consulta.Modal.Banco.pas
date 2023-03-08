unit Controle.Consulta.Modal.Banco;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, uniLabel, uniBitBtn,
  uniSpeedButton;

type
  TControleConsultaModalBanco = class(TControleConsultaModal)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaCODIGO: TWideStringField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalBanco: TControleConsultaModalBanco;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalBanco: TControleConsultaModalBanco;
begin
  Result := TControleConsultaModalBanco(ControleMainModule.GetFormInstance(TControleConsultaModalBanco));
end;

end.
