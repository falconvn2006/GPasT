unit Controle.Consulta.Caixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, 
  uniGridExporters, uniCheckBox, uniLabel, frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF,  uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage, Vcl.Menus, uniMainMenu, uniSweetAlert;

type
  TControleConsultaCaixa = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaFILIAL_ID: TFloatField;
    CdsConsultaUSUARIO_ID: TFloatField;
    CdsConsultaPDV_ID: TFloatField;
    CdsConsultaOPERADOR: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    CdsConsultaDATA_ABERTURA: TWideStringField;
    CdsConsultaDATA_FECHAMENTO: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

implementation

{$R *.dfm}

uses Controle.Cadastro.Caixa, Controle.Main.Module, Controle.Main;

procedure TControleConsultaCaixa.Novo;
begin
  inherited;
  With ControleCadastroCaixa do
  begin
    if ControleMainModule.FNumeroCaixaLogado = 0 then
    begin
      if ControleCadastroCaixa.Novo() then
      begin
        ControleCadastroCaixa.Salvar;
        ControleCadastroCaixa.ShowModal;
//        CdsConsulta.Refresh; // Não funcionou aqui
      end;
    end
    else
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Já existe um caixa aberto para o seu usuário!');

      // Abre o formulário de cadastro para visualização e edição
      if ControleCadastroCaixa.Abrir(ControleMainModule.FNumeroCaixaLogado) then
      begin
        ControleCadastroCaixa.ShowModal;
//        CdsConsulta.Refresh; // Não funcionou aqui
      end;
    end;
  end;
  CdsConsulta.Refresh;
end;

procedure TControleConsultaCaixa.UniFrameCreate(Sender: TObject);
begin
//  inherited;
  CdsConsulta.Close;
  CdsConsulta.Filtered := False;
  CdsConsulta.Filter := 'usuario_id = ' + QuotedStr(IntTostr(ControleMainModule.FUsuarioId));
  CdsConsulta.Filtered := True;
  CdsConsulta.Open;

  FNomeTabela := 'caixa';
end;

procedure TControleConsultaCaixa.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroCaixa.Abrir(id) then
  begin
    ControleCadastroCaixa.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

end.
