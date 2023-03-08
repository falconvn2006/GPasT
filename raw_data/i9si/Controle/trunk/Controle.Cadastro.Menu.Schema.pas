unit Controle.Cadastro.Menu.Schema;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniButton,
  uniPanel, uniMultiItem, uniComboBox, uniDBComboBox, uniDBLookupComboBox,
  uniLabel, ACBrBase, ACBrSocket, ACBrCEP, uniBitBtn, uniSpeedButton,
  uniSweetAlert;

type
  TControleCadastroMenuSchema = class(TControleCadastro)
    UniLabel1: TUniLabel;
    DbLookMenu: TUniDBLookupComboBox;
    UniLabel3: TUniLabel;
    DbLookSchema: TUniDBLookupComboBox;
    DscMenu: TDataSource;
    CdsMenu: TClientDataSet;
    DspMenu: TDataSetProvider;
    QryMenu: TADOQuery;
    QryCadastroID: TFloatField;
    CdsCadastroID: TFloatField;
    QryCadastroMENU_ID: TFloatField;
    QryCadastroSCHEMA_ID: TFloatField;
    CdsCadastroMENU_ID: TFloatField;
    CdsCadastroSCHEMA_ID: TFloatField;
    QryMenuID: TFloatField;
    QryMenuNOME_INTERNO: TWideStringField;
    QryMenuNOME_EXTERNO: TWideStringField;
    CdsMenuID: TFloatField;
    CdsMenuNOME_INTERNO: TWideStringField;
    CdsMenuNOME_EXTERNO: TWideStringField;
    QrySchema: TADOQuery;
    FloatField1: TFloatField;
    DspSchema: TDataSetProvider;
    CdsSchema: TClientDataSet;
    FloatField2: TFloatField;
    DscSchema: TDataSource;
    QrySchemaDESCRICAO: TWideStringField;
    QrySchemaATIVO: TWideStringField;
    CdsSchemaDESCRICAO: TWideStringField;
    CdsSchemaATIVO: TWideStringField;
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

function ControleCadastroMenuSchema: TControleCadastroMenuSchema;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Main, Controle.Funcoes;

function ControleCadastroMenuSchema: TControleCadastroMenuSchema;
begin
  Result := TControleCadastroMenuSchema(ControleMainModule.GetFormInstance(TControleCadastroMenuSchema));
end;

{ TControleCadastroMenuSchema }

function TControleCadastroMenuSchema.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  CdsMenu.Open;
  CdsSchema.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  Result := True;
end;

function TControleCadastroMenuSchema.Descartar: Boolean;
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

function TControleCadastroMenuSchema.Editar(Id: Integer): Boolean;
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

function TControleCadastroMenuSchema.Novo(): Boolean;
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

function TControleCadastroMenuSchema.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      if Trim(DbLookMenu.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a descrição do menu.');

        DbLookMenu.SetFocus;
        Exit;
      end;

      if Trim(DbLookSchema.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a descrição do schema');
        DbLookSchema.SetFocus;
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
      CadastroId := GeraUsuarioId('menu_schema');
      // Insert
      QryAx1.SQL.Add('INSERT INTO menu_schema (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       menu_id,');
      QryAx1.SQL.Add('       schema_id)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :menu_id,');
      QryAx1.SQL.Add('       :schema_id)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE menu_schema');
      QryAx1.SQL.Add('   SET menu_id    = :menu_id,');
      QryAx1.SQL.Add('       schema_id  = :schema_id');
      QryAx1.SQL.Add(' WHERE id          = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value         := CadastroId;
    QryAx1.Parameters.ParamByName('menu_id').Value    := CdsCadastro.FieldByName('menu_id').AsString;
    QryAx1.Parameters.ParamByName('schema_id').Value  := CdsCadastro.FieldByName('schema_id').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnectionLogin.RollbackTrans;
        ControleMainModule.QryAx1.Connection := ControleMainModule.ADOConnection;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
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
