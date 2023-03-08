unit Controle.Consulta.Modal.TituloCategoria.Pagar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Consulta.Modal, Data.DB,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses,
  uniGUIClasses, uniImageList, uniPanel, uniBasicGrid, uniDBGrid, uniButton,
  uniEdit, uniLabel;

type
  TControleConsultaModalTituloCategoriaPagar = class(TControleConsultaModal)
    QryConsultaID: TFloatField;
    QryConsultaDESCRICAO: TWideStringField;
    QryConsultaTIPO_TITULO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaTIPO_TITULO: TWideStringField;
    UniEdit1: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaModalTituloCategoriaPagar: TControleConsultaModalTituloCategoriaPagar;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaModalTituloCategoriaPagar: TControleConsultaModalTituloCategoriaPagar;
begin
  Result := TControleConsultaModalTituloCategoriaPagar(ControleMainModule.GetFormInstance(TControleConsultaModalTituloCategoriaPagar));
end;

end.
