unit Controle.Consulta.CondicoesPagamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, 
  uniGridExporters, uniCheckBox, uniLabel,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage, Vcl.Menus, uniMainMenu, uniSweetAlert;

type
  TControleConsultaCondicoesPagamento = class(TControleConsulta)
    UniEdit1: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaTIPO: TWideStringField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaORDEM_EXIBICAO: TFloatField;
    CdsConsultaMOVIMENTA_CAIXA: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
    procedure BotaoApagarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

implementation

{$R *.dfm}
uses Controle.Cadastro.CondicoesPagamento, Controle.Main.Module;

{ TControleConsultaTipoTitulo }

procedure TControleConsultaCondicoesPagamento.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroCondicoesPagamento.Abrir(Id) then
  begin
    ControleCadastroCondicoesPagamento.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaCondicoesPagamento.BotaoApagarClick(Sender: TObject);
begin
 // inherited;
  ControleMainModule.MensageiroSweetAlerta('Atenção','Não é possível apagar o tipo do título.');
end;

procedure TControleConsultaCondicoesPagamento.Novo;
begin
  inherited;
  if ControleCadastroCondicoesPagamento.Novo() then
  begin
    ControleCadastroCondicoesPagamento.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaCondicoesPagamento.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'condicoes_pagamento';
end;

end.
