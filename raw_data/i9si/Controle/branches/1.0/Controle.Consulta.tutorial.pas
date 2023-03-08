unit Controle.Consulta.tutorial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  Data.DB,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit,
  uniGridExporters, uniCheckBox, uniLabel, frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF,  uniBitBtn, UniFSButton;

type
  TControleConsultaTutorial = class(TControleConsulta)
    UniEdit1: TUniEdit;
    QryConsultaID: TFloatField;
    QryConsultaTITULO: TWideStringField;
    QryConsultaDESCRICAO: TWideStringField;
    QryConsultaLINK_URL: TWideStringField;
    QryConsultaORDEM: TFloatField;
    CdsConsultaID: TFloatField;
    CdsConsultaTITULO: TWideStringField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaLINK_URL: TWideStringField;
    CdsConsultaORDEM: TFloatField;
    procedure BotaoAbrirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



procedure TControleConsultaTutorial.BotaoAbrirClick(Sender: TObject);
var
  LINK_URL: string;
begin
//  inherited;
  if CdsConsulta.RecordCount <> 0 then
  begin
    LINK_URL := CdsConsultaLINK_URL.AsString;
    UniSession.AddJS('window.open('+'"'+ LINK_URL + '"'+')');
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Selecione um registro para abrir o tutorial');
  end;
end;

end.
