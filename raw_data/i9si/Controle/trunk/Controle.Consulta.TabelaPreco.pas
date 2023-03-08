unit Controle.Consulta.TabelaPreco;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniCheckBox, uniLabel,
  uniPanel, uniDBGrid, Vcl.Imaging.pngimage, uniImage, uniBitBtn, 
  uniButton;

type
  TControleConsultaTabelaPreco = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaFATOR: TWideStringField;
    CdsConsultaVALOR: TFloatField;
    procedure BotaoApagarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Abrir(Id: Integer); override;
    procedure Novo; override;
  end;

implementation

{$R *.dfm}

uses Controle.Cadastro.TabelaPreco, Controle.Main.Module;

{ TControleConsultaTipoTitulo }

procedure TControleConsultaTabelaPreco.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroTabelaPreco.Abrir(Id) then
  begin
    ControleCadastroTabelaPreco.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
        CdsConsulta.Refresh;
    end);
  end;
end;


procedure TControleConsultaTabelaPreco.BotaoApagarClick(Sender: TObject);
begin
//  inherited;
  ControleMainModule.MensageiroSweetAlerta('Atenção','Não é possível apagar.');
end;

procedure TControleConsultaTabelaPreco.Novo;
begin
  inherited;
  if ControleCadastroTabelaPreco.Novo() then
  begin
    ControleCadastroTabelaPreco.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
        CdsConsulta.Refresh;
    end);
  end;
end;

end.
