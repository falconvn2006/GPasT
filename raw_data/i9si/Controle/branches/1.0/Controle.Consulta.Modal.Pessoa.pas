unit Controle.Consulta.Modal.Pessoa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, uniLabel, uniBitBtn,
  uniSpeedButton;

type
  TControleConsultaModalPessoa = class(TControleConsultaModal)
    UniEdit1: TUniEdit;
    UniEditRazao: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaTIPO: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
    CdsConsultaDATA_NASCIMENTO: TDateTimeField;
    CdsConsultaRG_INSC_ESTADUAL: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalPessoa: TControleConsultaModalPessoa;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalPessoa: TControleConsultaModalPessoa;
begin
  Result := TControleConsultaModalPessoa(ControleMainModule.GetFormInstance(TControleConsultaModalPessoa));
end;

//dando erro na hora de pesquisar pela razao social

end.


