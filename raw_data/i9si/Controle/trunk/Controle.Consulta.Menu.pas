unit Controle.Consulta.Menu;

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
  TControleConsultaMenu = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    CdsConsultaNOME_INTERNO: TWideStringField;
    CdsConsultaNOME_EXTERNO: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
  private
    procedure ApagarMenu(Id: Integer);
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Cadastro.Menu, Controle.Main,
  Controle.Funcoes;


procedure TControleConsultaMenu.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroMenu.Abrir(Id) then
  begin
    ControleCadastroMenu.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaMenu.Novo;
begin
  inherited;
  if ControleCadastroMenu.Novo() then
  begin
    ControleCadastroMenu.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaMenu.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'menu';
end;

procedure TControleConsultaMenu.ApagarMenu(Id: Integer);
var
  Erro: String;
begin
  Erro := '';
  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnectionLogin.BeginTrans;
    QryAx1.Connection := ADOConnectionLogin;

    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Text :=
        'DELETE FROM menu'
      + ' WHERE id = :id';
    QryAx1.Parameters.ParamByName('id').Value := Id;

    try
      // Tenta apagar o registro
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;

    if Erro = '' then
    begin
      // Confirma a transação
      ADOConnectionLogin.CommitTrans;
      QryAx1.Connection := ADOConnection;

      // Atualiza a lista
      CdsConsulta.Refresh;
    end
    else
    begin
      // Descarta a transação
      ADOConnectionLogin.RollbackTrans;
      QryAx1.Connection := ADOConnection;
    end;
  end;
end;

end.
