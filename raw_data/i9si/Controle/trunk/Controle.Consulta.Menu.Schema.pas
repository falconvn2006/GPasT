unit Controle.Consulta.Menu.Schema;

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
  TControleConsultaMenuSchema = class(TControleConsulta)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaMENU_DESCRICAO: TWideStringField;
    CdsConsultaSCHEMA_DESCRICAO: TWideStringField;
    QryConsultaID: TFloatField;
    QryConsultaMENU_DESCRICAO: TWideStringField;
    QryConsultaSCHEMA_DESCRICAO: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ApagarMenu(Id: Integer);
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

implementation

{$R *.dfm}

uses
   Controle.Main.Module, Controle.Server.Module, Controle.Cadastro.Menu.Schema, Controle.Main,
  Controle.Funcoes;

{ TControleConsultaMenuSchema }

procedure TControleConsultaMenuSchema.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroMenuSchema.Abrir(Id) then
  begin
    ControleCadastroMenuSchema.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaMenuSchema.Novo;
begin
  inherited;
  if ControleCadastroMenuSchema.Novo() then
  begin
    ControleCadastroMenuSchema.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaMenuSchema.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'menu_schema';
end;

procedure TControleConsultaMenuSchema.ApagarMenu(Id: Integer);
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
        'DELETE FROM menu_schema'
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
