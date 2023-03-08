unit Controle.Cadastro.Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniButton,
  uniPanel, uniCheckBox, uniDBCheckBox, uniEdit, uniDBEdit, uniLabel,
  uniPageControl, uniToolBar, uniBasicGrid, uniDBGrid, ACBrBase, ACBrSocket,
  ACBrCEP, uniBitBtn, uniSpeedButton, uniSweetAlert;

type
  TControleCadastroMenu = class(TControleCadastro)
    UniLabel1: TUniLabel;
    DBEdtDescricao_Interna: TUniDBEdit;
    QryCadastroID: TFloatField;
    CdsCadastroID: TFloatField;
    UniLabel2: TUniLabel;
    DBEdtDescricao_externa: TUniDBEdit;
    QryCadastroNOME_INTERNO: TWideStringField;
    QryCadastroNOME_EXTERNO: TWideStringField;
    CdsCadastroNOME_INTERNO: TWideStringField;
    CdsCadastroNOME_EXTERNO: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;

  end;

function ControleCadastroMenu: TControleCadastroMenu;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, Controle.Main;

function ControleCadastroMenu: TControleCadastroMenu;
begin
  Result := TControleCadastroMenu(ControleMainModule.GetFormInstance(TControleCadastroMenu));
end;

{ TControleCadastroMenu }

function TControleCadastroMenu.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  Result := True;
end;

function TControleCadastroMenu.Descartar: Boolean;
var
  Fechar: Boolean;
begin
  inherited;

  Fechar := False;

  // Se o formulário foi aberto para inclusão, deve ser fechado ao
  // clicar em Descartar.
  if CdsCadastro.IsEmpty or (CdsCadastro.FieldByName('id').AsInteger = 0) then
    Fechar := True;

  // Descartar a alterações
  CdsCadastro.Cancel;

  if Fechar then
    // Fecha o cadastro
    Close;

  Result := True;
end;

function TControleCadastroMenu.Editar(Id: Integer): Boolean;
begin
  Result := False;

  // Pega o id do registro aberto se não tiver sido passado
  // como parâmtro
  if Id = 0 then
    Id := CdsCadastro.FieldByName('id').AsInteger;

  // Tenta abrir o registro
  if Abrir(Id) then
  // Libera o registro para edição
    CdsCadastro.Edit;

  Result := True;
end;

function TControleCadastroMenu.Novo(): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;

    Result := True;
  end;
end;

function TControleCadastroMenu.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      if Trim(DBEdtDescricao_Interna.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a descrição do menu.');
        DBEdtDescricao_Interna.SetFocus;
        Exit;
      end;

      if Trim(DBEdtDescricao_Externa.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a descrição do menu.');
        DBEdtDescricao_Externa.SetFocus;
        Exit;
      end;

      // Confirma os dados
      CdsCadastro.Post;
    end;

    // Pega o id do registro
    CadastroId := CdsCadastro.FieldByName('id').AsInteger;
  end;

  with ControleMainModule do
  begin
    QryAx1.Connection := ADOConnectionLogin;

    // Inicia a transação
    ADOConnectionLogin.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a cidade
      CadastroId := GeraUsuarioId('menu');
      // Insert
      QryAx1.SQL.Add('INSERT INTO menu (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       nome_interno,');
      QryAx1.SQL.Add('       nome_externo)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :nome_interno,');
      QryAx1.SQL.Add('       :nome_externo)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE menu');
      QryAx1.SQL.Add('   SET nome_interno   = :nome_interno,');
      QryAx1.SQL.Add('       nome_externo   = :nome_externo');
      QryAx1.SQL.Add(' WHERE id          = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value            := CadastroId;
    QryAx1.Parameters.ParamByName('nome_interno').Value  := CdsCadastro.FieldByName('nome_interno').AsString;
    QryAx1.Parameters.ParamByName('nome_externo').Value  := CdsCadastro.FieldByName('nome_externo').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnectionLogin.RollbackTrans;
        ControleMainModule.QryAx1.Connection := ControleMainModule.ADOConnection;
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não foi possível salvar os dados alterados' + E.Message);

        CdsCadastro.Edit;

        Exit;
      end;
    end;

    // Confirma a transação
    ADOConnectionLogin.CommitTrans;
    ControleMainModule.QryAx1.Connection := ControleMainModule.ADOConnection;
  end;

  // Recarrega o registro
  Abrir(CadastroId);
  Result := True;
end;

end.
