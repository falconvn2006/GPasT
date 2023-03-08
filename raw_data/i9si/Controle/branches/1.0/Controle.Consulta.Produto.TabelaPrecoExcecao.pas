unit Controle.Consulta.Produto.TabelaPrecoExcecao;

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
  TControleConsultaProdutoTabelaPrecoExcecao = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaPRODUTO_ID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaFATOR: TWideStringField;
    CdsConsultaVALOR: TFloatField;
  private
    procedure Abrir(Id: Integer); override;
    procedure Novo; override;
    procedure BotaoApagarClick(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Cadastro.ProdutoTabelaPrecoExcecao;
{ TControleConsultaTipoTitulo }

procedure TControleConsultaProdutoTabelaPrecoExcecao.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroProdutoTabelaPrecoExececao.Abrir(Id) then
  begin
    ControleCadastroProdutoTabelaPrecoExececao.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
        CdsConsulta.Refresh;
    end);
  end;
end;


procedure TControleConsultaProdutoTabelaPrecoExcecao.BotaoApagarClick(Sender: TObject);
begin
//  inherited;
  ControleMainModule.MensageiroSweetAlerta('Atenção','Não é possível apagar.');
end;


procedure TControleConsultaProdutoTabelaPrecoExcecao.Novo;
begin
  inherited;
  if ControleCadastroProdutoTabelaPrecoExececao.Novo() then
  begin
    ControleCadastroProdutoTabelaPrecoExececao.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
        CdsConsulta.Refresh;
    end);
  end;
end;


end.
