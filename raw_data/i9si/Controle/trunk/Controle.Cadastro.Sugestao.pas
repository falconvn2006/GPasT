unit Controle.Cadastro.Sugestao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro,  ACBrBase,
  ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel, uniMemo, uniHTMLMemo, uniPageControl, uniEdit,
  uniDBEdit, uniDBMemo, uniSweetAlert;

type
  TControleCadastroSugestao = class(TControleCadastro)
    UniPanel5: TUniPanel;
    UniLabel1: TUniLabel;
    DBEdtDescricao: TUniDBEdit;
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    QryCadastroUSUARIO_ID: TFloatField;
    QryCadastroDATA: TDateTimeField;
    QryCadastroSUGESTAO_ID: TFloatField;
    QryCadastroTITULO: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO: TWideStringField;
    CdsCadastroUSUARIO_ID: TFloatField;
    CdsCadastroDATA: TDateTimeField;
    CdsCadastroSUGESTAO_ID: TFloatField;
    CdsCadastroTITULO: TWideStringField;
    UniPanel7: TUniPanel;
    UniLabel2: TUniLabel;
    UniDBMemo1: TUniDBMemo;
    UniPanel8: TUniPanel;
    UniDBMemo2: TUniDBMemo;
    UniLabel3: TUniLabel;
    QryCadastroRESPOSTA: TWideStringField;
    QryCadastroSTATUS: TWideStringField;
    CdsCadastroRESPOSTA: TWideStringField;
    CdsCadastroSTATUS: TWideStringField;
    UniPanel9: TUniPanel;
    UniPanel10: TUniPanel;
    UniPanel11: TUniPanel;
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

function ControleCadastroSugestao: TControleCadastroSugestao;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes;

function ControleCadastroSugestao: TControleCadastroSugestao;
begin
  Result := TControleCadastroSugestao(ControleMainModule.GetFormInstance(TControleCadastroSugestao));
end;

{ TControleCadastroSugestao }

function TControleCadastroSugestao.Abrir(Id: Integer): Boolean;
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

function TControleCadastroSugestao.Descartar: Boolean;
var
  Fechar: Boolean;
begin
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

function TControleCadastroSugestao.Editar(Id: Integer): Boolean;
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

function TControleCadastroSugestao.Novo(): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;
    CdsCadastro['status'] := 'AGUARDANDO';

    Result := True;
  end;
end;

function TControleCadastroSugestao.Salvar: Boolean;
begin
  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Verifica descrição da sugestão
      if Trim(DBEdtDescricao.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a descrição da escolaridade');
        DBEdtDescricao.SetFocus;
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
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a cidade
      CadastroId := GeraIdSchemaFonte('sugestao');

      // Insert
      QryAx1.SQL.Add('INSERT INTO FONTE.sugestao (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao,');
      QryAx1.SQL.Add('       usuario_id,');
      QryAx1.SQL.Add('       data,');
      QryAx1.SQL.Add('       sugestao_id,');
      QryAx1.SQL.Add('       status,');
      QryAx1.SQL.Add('       titulo)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao,');
      QryAx1.SQL.Add('       :usuario_id,');
      QryAx1.SQL.Add('       sysdate,');
      QryAx1.SQL.Add('       :sugestao_id,');
      QryAx1.SQL.Add('       ''A'',');
      QryAx1.SQL.Add('       :titulo)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE FONTE.sugestao SET');
      QryAx1.SQL.Add('       descricao       = :descricao,');
      QryAx1.SQL.Add('       usuario_id      = :usuario_id,');
      QryAx1.SQL.Add('       sugestao_id     = :sugestao_id,');
      QryAx1.SQL.Add('       titulo          = :titulo');
      QryAx1.SQL.Add(' WHERE id          = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value   := CdsCadastro.FieldByName('descricao').AsString;
    QryAx1.Parameters.ParamByName('usuario_id').Value  := ControleMainModule.FUsuarioId;
    QryAx1.Parameters.ParamByName('sugestao_id').Value := CdsCadastro.FieldByName('sugestao_id').AsString;
    QryAx1.Parameters.ParamByName('titulo').Value      := CdsCadastro.FieldByName('titulo').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
        CdsCadastro.Edit;

        Exit;
      end;
    end;

    // Confirma a transação
    ADOConnection.CommitTrans;

    // Recarrega o registro
    Abrir(CadastroId);
    Result := True;
  end;
end;

end.
