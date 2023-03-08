unit Controle.Cadastro.Usuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniButton,
  uniPanel, uniLabel, uniEdit, uniDBEdit, uniBitBtn, uniSpeedButton,
  uniCheckBox, uniDBCheckBox, uniMultiItem, uniComboBox, uniDBComboBox,
  uniGroupBox, uniBasicGrid, uniDBGrid, ACBrBase, ACBrSocket, ACBrCEP,
  uniPageControl, uniDBVerticalGrid, uniDBVerticalTreeGrid, uniSweetAlert;

type
  TControleCadastroUsuario = class(TControleCadastro)
    UniPanel5: TUniPanel;
    UniLabel1: TUniLabel;
    DBEdtLogin: TUniDBEdit;
    UniLabel2: TUniLabel;
    DBEdtSenha: TUniDBEdit;
    UniPanel7: TUniPanel;
    QryPermissao: TADOQuery;
    DspPermissao: TDataSetProvider;
    CdsPermissao: TClientDataSet;
    DscPermissao: TDataSource;
    CdsCadastroID: TFloatField;
    CdsCadastroLOGIN: TWideStringField;
    CdsCadastroSENHA: TWideStringField;
    CdsCadastroATIVO: TWideStringField;
    QryCadastroID: TFloatField;
    QryCadastroLOGIN: TWideStringField;
    QryCadastroSENHA: TWideStringField;
    QryCadastroATIVO: TWideStringField;
    UniImageList3: TUniImageList;
    UniDBCheckBox1: TUniDBCheckBox;
    QryPermissaoID: TFloatField;
    QryPermissaoUSUARIO_ID: TFloatField;
    QryPermissaoMENU_CLIENTE_BOTAO: TWideStringField;
    QryPermissaoMENU_EMPRESA_BOTAO: TWideStringField;
    QryPermissaoMENU_CIDADES_BOTAO: TWideStringField;
    QryPermissaoMENU_USUARIOS_BOTAO: TWideStringField;
    QryPermissaoMENU_CADASTRO_BOTAO: TWideStringField;
    QryPermissaoMENU_FORNECEDOR_BOTAO: TWideStringField;
    QryPermissaoMENU_BANCO_BOTAO: TWideStringField;
    QryPermissaoMENU_CONTABANCARIA_BOTAO: TWideStringField;
    QryPermissaoMENU_TITULOSPAGAR_BOTAO: TWideStringField;
    QryPermissaoMENU_TITULOSRECEBER_BOTAO: TWideStringField;
    QryPermissaoMENU_TIPOTITULO_BOTAO: TWideStringField;
    QryPermissaoMENU_DADOS_REPRES_BOTAO: TWideStringField;
    QryPermissaoMENU_CLIENTE_REPRES_BOTAO: TWideStringField;
    QryPermissaoMENU_RECEBIVEIS_REPRES_BOTAO: TWideStringField;
    CdsPermissaoID: TFloatField;
    CdsPermissaoUSUARIO_ID: TFloatField;
    CdsPermissaoMENU_CLIENTE_BOTAO: TWideStringField;
    CdsPermissaoMENU_EMPRESA_BOTAO: TWideStringField;
    CdsPermissaoMENU_CIDADES_BOTAO: TWideStringField;
    CdsPermissaoMENU_USUARIOS_BOTAO: TWideStringField;
    CdsPermissaoMENU_CADASTRO_BOTAO: TWideStringField;
    CdsPermissaoMENU_FORNECEDOR_BOTAO: TWideStringField;
    CdsPermissaoMENU_BANCO_BOTAO: TWideStringField;
    CdsPermissaoMENU_CONTABANCARIA_BOTAO: TWideStringField;
    CdsPermissaoMENU_TITULOSPAGAR_BOTAO: TWideStringField;
    CdsPermissaoMENU_TITULOSRECEBER_BOTAO: TWideStringField;
    CdsPermissaoMENU_TIPOTITULO_BOTAO: TWideStringField;
    CdsPermissaoMENU_DADOS_REPRES_BOTAO: TWideStringField;
    CdsPermissaoMENU_CLIENTE_REPRES_BOTAO: TWideStringField;
    CdsPermissaoMENU_RECEBIVEIS_REPRES_BOTAO: TWideStringField;
    UniDBVerticalTreeGrid1: TUniDBVerticalTreeGrid;
    UniPanel8: TUniPanel;
    QryPermissaoMENU_CAIXA_BOTAO: TWideStringField;
    CdsPermissaoMENU_CAIXA_BOTAO: TWideStringField;
    QryPermissaoMENU_CHEQUESRECEBIDOS_BOTAO: TWideStringField;
    CdsPermissaoMENU_CHEQUESRECEBIDOS_BOTAO: TWideStringField;
    QryPermissaoMENU_DESTINOCHEQUE_BOTAO: TWideStringField;
    CdsPermissaoMENU_DESTINOCHEQUE_BOTAO: TWideStringField;
    QryPermissaoMENU_CATEGORIATITULO_BOTAO: TWideStringField;
    CdsPermissaoMENU_CATEGORIATITULO_BOTAO: TWideStringField;
    QryPermissaoMENU_CHEQUESDEPOSITADOS_BOTAO: TWideStringField;
    CdsPermissaoMENU_CHEQUESDEPOSITADOS_BOTAO: TWideStringField;
    QryPermissaoMENU_CATEGORIAPRODUTO_BOTAO: TWideStringField;
    CdsPermissaoMENU_CATEGORIAPRODUTO_BOTAO: TWideStringField;
    QryPermissaoMENU_TABELAPRECO_BOTAO: TWideStringField;
    CdsPermissaoMENU_TABELAPRECO_BOTAO: TWideStringField;
    QryPermissaoMENU_GRUPOTRIBUTOS_BOTAO: TWideStringField;
    CdsPermissaoMENU_GRUPOTRIBUTOS_BOTAO: TWideStringField;
    QryPermissaoMENU_DESCONTO_VALE_BOTAO: TWideStringField;
    CdsPermissaoMENU_DESCONTO_VALE_BOTAO: TWideStringField;
    QryPermissaoMENU_DASHBOARD_BOTAO: TWideStringField;
    QryPermissaoMENU_AUDITORIA_BOTAO: TWideStringField;
    QryPermissaoMENU_SCHEMA_BOTAO: TWideStringField;
    QryPermissaoMENU_SCHEMA_CADASTRO_BOTAO: TWideStringField;
    QryPermissaoMENU_DOCUMENT_ELETRONICO_BOTAO: TWideStringField;
    QryPermissaoMENU_SIGNATARIO_BOTAO: TWideStringField;
    QryPermissaoMENU_PROD_TABPRECO_EXCEC_BOTAO: TWideStringField;
    QryPermissaoMENU_PRODUTO_EMBALAGEM_BOTAO: TWideStringField;
    QryPermissaoMENU_RELATORIO_BOTAO: TWideStringField;
    QryPermissaoMENU_INTCONTASRECEBER_BOTAO: TWideStringField;
    QryPermissaoMENU_INTCONTASPAGAR_BOTAO: TWideStringField;
    CdsPermissaoMENU_DASHBOARD_BOTAO: TWideStringField;
    CdsPermissaoMENU_AUDITORIA_BOTAO: TWideStringField;
    CdsPermissaoMENU_SCHEMA_BOTAO: TWideStringField;
    CdsPermissaoMENU_SCHEMA_CADASTRO_BOTAO: TWideStringField;
    CdsPermissaoMENU_DOCUMENT_ELETRONICO_BOTAO: TWideStringField;
    CdsPermissaoMENU_SIGNATARIO_BOTAO: TWideStringField;
    CdsPermissaoMENU_PROD_TABPRECO_EXCEC_BOTAO: TWideStringField;
    CdsPermissaoMENU_PRODUTO_EMBALAGEM_BOTAO: TWideStringField;
    CdsPermissaoMENU_RELATORIO_BOTAO: TWideStringField;
    CdsPermissaoMENU_INTCONTASRECEBER_BOTAO: TWideStringField;
    CdsPermissaoMENU_INTCONTASPAGAR_BOTAO: TWideStringField;
    procedure UniFormShow(Sender: TObject);

  private
    { Private declarations }
    FSenhaOld: String;
    function md5(S: String): String;
    function UsuarioSenhaExiste(Elogin, Esenha: string): boolean;
    function UsuarioSchema(Elogin, Eschema: string): boolean;

  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroUsuario: TControleCadastroUsuario;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, IdHashMessageDigest;

function ControleCadastroUsuario: TControleCadastroUsuario;
begin
  Result := TControleCadastroUsuario(ControleMainModule.GetFormInstance(TControleCadastroUsuario));
end;

{ TControleCadastro1 }

function TControleCadastroUsuario.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  CdsPermissao.Close;
  QryPermissao.Parameters.ParamByName('usuario_id').Value := Id;
  CdsPermissao.Open;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  Result := True;
end;


function TControleCadastroUsuario.Descartar: Boolean;
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

function TControleCadastroUsuario.Editar(Id: Integer): Boolean;
begin
  Result := False;

  // Pega o id do registro aberto se não tiver sido passado
  // como parâmtro
  if Id = 0 then
    Id := CdsCadastro.FieldByName('id').AsInteger;

  // Tenta abrir o registro
  if Abrir(Id) then
  begin
    // Libera o registro para edição
    CdsCadastro.Edit;

    Result := True;
  end;
end;

function TControleCadastroUsuario.Novo(): Boolean;
begin
  Result := False;


  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;
    CdsCadastro['ativo']  := 'S';

    Result := True;
  end;
end;

// -------------------------------------------------------------------------- //
function SenhaSegura(const cSenha:String):Boolean;
function SoLetras(s:string):boolean;
const
  c :Array [1..10]  of char  = ('0','1','2','3','4','5','6','7','8','9');
var
  idx:integer;
begin    //tem letras
  result:=true;
  for idx:=1 to length(c) do
    if pos(c[idx],s)>0 then
    begin
      result:=false;
      Break;
    end;
end;
Const
  cCharMin=3;
var
  n:Int64;
begin
  result:=(length(cSenha) > cCharMin)and(not TryStrToInt64(cSenha,n))and(not SoLetras(cSenha));
end;

function TControleCadastroUsuario.Salvar: Boolean;
var
  Permissoes: TClientDataSet;
  UsuarioPermissaoId: Integer;
  Erro: String;
  i: Integer;
begin
  inherited;

  Erro   := '';
  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Verifica o login
    if (Erro = '') and (DBEdtLogin.Text = '') then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o usuario.');
      DBEdtLogin.SetFocus;
      Exit;
    end;

    // Verifica a senha
    if (Erro = '') and (DBEdtSenha.Text = '') or (Length(DBEdtSenha.Text) < 4) then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a senha igual ou maior que 4 digitos.');
      DBEdtSenha.SetFocus;
      Exit;
    end;

    // Verifica se a senha contem algum caracterer especial
    if (Erro = '')then
    begin
      if SenhaSegura(DBEdtSenha.Text) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'A senha deve conter letras e números, que não sejam sequenciais.');
        DBEdtSenha.SetFocus;
        Exit;
      end;
    end;

    // Verifica se o usuario no schema informado
    if (Erro = '')then
    begin
      if UsuarioSenhaExiste(DBEdtLogin.Text,
                            md5(DBEdtSenha.Text))= true then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Senha não atende aos requisitos de segurança!');
        DBEdtSenha.SelectAll;
        DBEdtSenha.SetFocus;
        Exit;
      end
      else if UsuarioSchema(DBEdtLogin.Text,
                            ControleMainModule.FSchema)= true then
      begin
        if CdsCadastro.State = dsEdit then
        begin
       //   exit;
        end
        else
        begin
         ControleMainModule.MensageiroSweetAlerta('Atenção', 'Este usuário já está cadastrado!');
         DBEdtLogin.SelectAll;
         DBEdtLogin.SetFocus;
         Exit;
        end;
      end;
    end;


   // Confirma os dados
    CdsCadastro.Post;
   // CdsPermissao.Post;

    // Pega os ids do registro
    CadastroId := CdsCadastro.FieldByName('id').AsInteger;
    UsuarioPermissaoId  := CdsPermissao.FieldByName('id').AsInteger;
  end;

  // Passo 1 - Salva os dados do usuario
  with ControleMainModule do
  begin
    QryAx1.Connection := ADOConnectionLogin;
    QryAx2.Connection := ADOConnectionLogin;

    // Inicia a transação
    ADOConnectionLogin.BeginTrans;

    // Pesquisa a senha
    CdsAx2.Close;
    QryAx2.Parameters.Clear;
    QryAx2.SQL.Clear;
    QryAx2.SQL.Text :=
        'SELECT senha'
      + '  FROM usuario'
      + ' WHERE id = :id';
    QryAx2.Parameters.ParamByName('id').Value := CadastroId;
    CdsAx2.Open;

    FSenhaOld := CdsAx2.FieldByName('senha').AsString;

    if CadastroId = 0 then
    begin
      // Gera um novo id para o endereço
      CadastroId := GeraUsuarioId('usuario');

      // Insert
      QryAx1.SQL.Clear;
      QryAx1.SQL.Text :=
          'INSERT INTO usuario ('
        + '       id,'
        + '       login,'
        + '       senha,'
        + '       ativo, '
        + '       schema) '
        + 'VALUES ('
        + '       :id,'
        + '       :login,'
        + '       :senha,'
        + '       :ativo,'
        + '       :schema)';
      QryAx1.Parameters.ParamByName('schema').Value := ControleMainModule.FSchema;
    end
    else
    begin
      // Update
      QryAx1.SQL.Clear;
      QryAx1.SQL.Text :=
          'UPDATE usuario'
        + '   SET login = :login,'
        + '       senha = :senha,'
        + '       ativo = :ativo'
        + ' WHERE id    = :id';
    end;

    QryAx1.Parameters.ParamByName('id').Value    := CadastroId;
    QryAx1.Parameters.ParamByName('login').Value := Trim(CdsCadastro.FieldByName('login').AsVariant);
    QryAx1.Parameters.ParamByName('ativo').Value := CdsCadastro.FieldByName('ativo').AsString[1];
    if FSenhaOld = CdsCadastro.FieldByName('senha').AsString then
      QryAx1.Parameters.ParamByName('senha').Value := CdsCadastro.FieldByName('senha').AsString
    else
      QryAx1.Parameters.ParamByName('senha').Value := md5(Trim(CdsCadastro.FieldByName('senha').AsString));

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;
  end;

  // Passo 2 - Salva os dados das permissoes do usuarios
  if Erro = '' then
  with ControleMainModule do
  begin
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    UsuarioPermissaoId := CdsPermissao.FieldByName('id').AsInteger;
    if UsuarioPermissaoId = 0 then
    begin
      // Gera um novo id para o endereço
      UsuarioPermissaoId := GeraUsuarioId('usuario_permissao_controle');

      QryAx1.SQL.Add('INSERT INTO usuario_permissao_controle (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       usuario_id,');
      QryAx1.SQL.Add('       menu_cliente_botao,');
      QryAx1.SQL.Add('       menu_empresa_botao,');
      QryAx1.SQL.Add('       menu_cidades_botao,');
      QryAx1.SQL.Add('       menu_usuarios_botao,');
      QryAx1.SQL.Add('       menu_cadastro_botao,');
      QryAx1.SQL.Add('       menu_fornecedor_botao,');
      QryAx1.SQL.Add('       menu_banco_botao,');
      QryAx1.SQL.Add('       menu_contabancaria_botao,');
      QryAx1.SQL.Add('       menu_titulospagar_botao,');
      QryAx1.SQL.Add('       menu_titulosreceber_botao,');
      QryAx1.SQL.Add('       menu_tipotitulo_botao,');
      QryAx1.SQL.Add('       menu_categoriatitulo_botao,');
      QryAx1.SQL.Add('       menu_categoriaproduto_botao,');
      QryAx1.SQL.Add('       menu_destinocheque_botao,');
      QryAx1.SQL.Add('       menu_dados_repres_botao,');
      QryAx1.SQL.Add('       menu_cliente_repres_botao,');
      QryAx1.SQL.Add('       menu_recebiveis_repres_botao,');
      QryAx1.SQL.Add('       menu_caixa_botao,');
      QryAx1.SQL.Add('       menu_chequesrecebidos_botao,');
      QryAx1.SQL.Add('       menu_chequesdepositados_botao)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :usuario_id,');
      QryAx1.SQL.Add('       :menu_cliente_botao,');
      QryAx1.SQL.Add('       :menu_empresa_botao,');
      QryAx1.SQL.Add('       :menu_cidades_botao,');
      QryAx1.SQL.Add('       :menu_usuarios_botao,');
      QryAx1.SQL.Add('       :menu_cadastro_botao,');
      QryAx1.SQL.Add('       :menu_fornecedor_botao,');
      QryAx1.SQL.Add('       :menu_banco_botao,');
      QryAx1.SQL.Add('       :menu_contabancaria_botao,');
      QryAx1.SQL.Add('       :menu_titulospagar_botao,');
      QryAx1.SQL.Add('       :menu_titulosreceber_botao,');
      QryAx1.SQL.Add('       :menu_tipotitulo_botao,');
      QryAx1.SQL.Add('       :menu_categoriatitulo_botao,');
      QryAx1.SQL.Add('       :menu_categoriaproduto_botao,');
      QryAx1.SQL.Add('       :menu_destinocheque_botao,');
      QryAx1.SQL.Add('       :menu_dados_repres_botao,');
      QryAx1.SQL.Add('       :menu_cliente_repres_botao,');
      QryAx1.SQL.Add('       :menu_recebiveis_repres_botao,');
      QryAx1.SQL.Add('       :menu_caixa_botao,');
      QryAx1.SQL.Add('       :menu_chequesrecebidos_botao,');
      QryAx1.SQL.Add('       :menu_chequesdepositados_botao)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE usuario_permissao_controle SET');
      QryAx1.SQL.Add('       usuario_id      = :usuario_id,');
      QryAx1.SQL.Add('       menu_cliente_botao      = :menu_cliente_botao,');
      QryAx1.SQL.Add('       menu_empresa_botao      = :menu_empresa_botao,');
      QryAx1.SQL.Add('       menu_cidades_botao      = :menu_cidades_botao,');
      QryAx1.SQL.Add('       menu_usuarios_botao      = :menu_usuarios_botao,');
      QryAx1.SQL.Add('       menu_cadastro_botao      = :menu_cadastro_botao,');
      QryAx1.SQL.Add('       menu_fornecedor_botao      = :menu_fornecedor_botao,');
      QryAx1.SQL.Add('       menu_banco_botao      = :menu_banco_botao,');
      QryAx1.SQL.Add('       menu_contabancaria_botao      = :menu_contabancaria_botao,');
      QryAx1.SQL.Add('       menu_titulospagar_botao      = :menu_titulospagar_botao,');
      QryAx1.SQL.Add('       menu_titulosreceber_botao      = :menu_titulosreceber_botao,');
      QryAx1.SQL.Add('       menu_tipotitulo_botao      = :menu_tipotitulo_botao,');
      QryAx1.SQL.Add('       menu_categoriatitulo_botao      = :menu_categoriatitulo_botao,');
      QryAx1.SQL.Add('       menu_categoriaproduto_botao      = :menu_categoriaproduto_botao,');
      QryAx1.SQL.Add('       menu_destinocheque_botao      = :menu_destinocheque_botao,');
      QryAx1.SQL.Add('       menu_dados_repres_botao      = :menu_dados_repres_botao,');
      QryAx1.SQL.Add('       menu_cliente_repres_botao      = :menu_cliente_repres_botao,');
      QryAx1.SQL.Add('       menu_recebiveis_repres_botao      = :menu_recebiveis_repres_botao,');
      QryAx1.SQL.Add('       menu_caixa_botao      = :menu_caixa_botao,');
      QryAx1.SQL.Add('       menu_chequesrecebidos_botao      = :menu_chequesrecebidos_botao,');
      QryAx1.SQL.Add('       menu_chequesdepositados_botao      = :menu_chequesdepositados_botao');
      QryAx1.SQL.Add(' WHERE id          = :id');
     end;

    QryAx1.Parameters.ParamByName('id').Value          := UsuarioPermissaoId;
    QryAx1.Parameters.ParamByName('usuario_id').Value       := Cadastroid;
    QryAx1.Parameters.ParamByName('menu_cliente_botao').Value       := CdsPermissao.FieldByName('menu_cliente_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_empresa_botao').Value       := CdsPermissao.FieldByName('menu_empresa_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_cidades_botao').Value       := CdsPermissao.FieldByName('menu_cidades_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_usuarios_botao').Value       := CdsPermissao.FieldByName('menu_usuarios_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_cadastro_botao').Value       := CdsPermissao.FieldByName('menu_cadastro_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_fornecedor_botao').Value       := CdsPermissao.FieldByName('menu_fornecedor_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_banco_botao').Value       := CdsPermissao.FieldByName('menu_banco_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_contabancaria_botao').Value       := CdsPermissao.FieldByName('menu_contabancaria_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_titulospagar_botao').Value       := CdsPermissao.FieldByName('menu_titulospagar_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_titulosreceber_botao').Value       := CdsPermissao.FieldByName('menu_titulosreceber_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_tipotitulo_botao').Value       := CdsPermissao.FieldByName('menu_tipotitulo_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_categoriatitulo_botao').Value       := CdsPermissao.FieldByName('menu_categoriatitulo_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_categoriaproduto_botao').Value       := CdsPermissao.FieldByName('menu_categoriaproduto_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_destinocheque_botao').Value       := CdsPermissao.FieldByName('menu_destinocheque_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_dados_repres_botao').Value       := CdsPermissao.FieldByName('menu_dados_repres_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_cliente_repres_botao').Value       := CdsPermissao.FieldByName('menu_cliente_repres_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_recebiveis_repres_botao').Value       := CdsPermissao.FieldByName('menu_recebiveis_repres_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_caixa_botao').Value       := CdsPermissao.FieldByName('menu_caixa_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_chequesrecebidos_botao').Value       := CdsPermissao.FieldByName('menu_chequesrecebidos_botao').AsString;
    QryAx1.Parameters.ParamByName('menu_chequesdepositados_botao').Value       := CdsPermissao.FieldByName('menu_chequesdepositados_botao').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;
  end;

  if Erro <> '' then
  begin
    // Descarta a transação
    ControleMainModule.ADOConnectionLogin.RollbackTrans;
    ControleMainModule.QryAx1.Connection := ControleMainModule.ADOConnection;
    ControleMainModule.QryAx2.Connection := ControleMainModule.ADOConnection;
    ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
    CdsCadastro.Edit;
  end
  else
  begin
    // Confirma a transação
    ControleMainModule.ADOConnectionLogin.CommitTrans;
    ControleMainModule.QryAx1.Connection := ControleMainModule.ADOConnection;
    ControleMainModule.QryAx2.Connection := ControleMainModule.ADOConnection;
    // Recarrega o registro
    Abrir(CadastroId);
    Result := True;
  end;
end;

procedure TControleCadastroUsuario.UniFormShow(Sender: TObject);
begin
  inherited;
  ControleCadastroUsuario.Width :=  650;
end;

function TcontroleCadastroUsuario.UsuarioSchema(Elogin,
                                                Eschema : string) : boolean;
begin
  Result := false;
   with ControleMainModule do
   begin
    QryAx5.Connection := ADOConnectionLogin;
    // Pesquisa a senha
    CdsAx5.Close;
    QryAx5.Parameters.Clear;
    QryAx5.SQL.Clear;
    QryAx5.SQL.Text :=
        'SELECT login,'
      + '       schema'
      + '  FROM usuario'
      + ' WHERE login = :login'
      + '   AND schema = :schema';
    QryAx5.Parameters.ParamByName('login').Value := Elogin;
    QryAx5.Parameters.ParamByName('schema').Value := Eschema;
    CdsAx5.Open;

    if CdsAx5.RecordCount >0 then
    result :=true;
  end

end;

function TcontroleCadastroUsuario.UsuarioSenhaExiste(Elogin,
                                              Esenha : string) : boolean;
begin
  Result := false;
   with ControleMainModule do
   begin
    QryAx5.Connection := ADOConnectionLogin;
    // Pesquisa a senha
    CdsAx5.Close;
    QryAx5.Parameters.Clear;
    QryAx5.SQL.Clear;
    QryAx5.SQL.Text :=
        'SELECT login,'
      + '       senha'
      + '  FROM usuario'
      + ' WHERE login = :login'
      + '   AND senha = :senha';
    QryAx5.Parameters.ParamByName('login').Value := Elogin;
    QryAx5.Parameters.ParamByName('senha').Value := Esenha;
    CdsAx5.Open;

    if CdsAx5.RecordCount >0 then
    result :=true;
  end

end;

// -------------------------------------------------------------------------- //
function TControleCadastroUsuario.md5(S: String): String;
var
  md5: TIdHashMessageDigest5;
begin
  md5    := TIdHashMessageDigest5.Create;
  result := md5.HashStringAsHex(S);
  md5.Free;
end;

end.
