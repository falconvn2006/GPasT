unit Controle.Consulta.Modal.ContaBancaria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, uniBitBtn,
  uniSpeedButton, uniLabel;

type
  TControleConsultaModalContaBancaria = class(TControleConsultaModal)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
    CdsConsultaGERENCIANET_CLIENT_ID: TWideStringField;
    CdsConsultaGERENCIANET_CLIENT_SECRET: TWideStringField;
    CdsConsultaTIPOAMBIENTE: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalContaBancaria: TControleConsultaModalContaBancaria;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalContaBancaria: TControleConsultaModalContaBancaria;
begin
  Result := TControleConsultaModalContaBancaria(ControleMainModule.GetFormInstance(TControleConsultaModalContaBancaria));
end;

end.
