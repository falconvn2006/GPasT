unit Controle.Consulta.Usuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, uniGUIBaseClasses,
  uniImageList, uniPanel, uniButton, uniBasicGrid, uniDBGrid, uniScreenMask,
  uniCheckBox, uniEdit, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient,  uniGridExporters, uniLabel, 
  frxClass, frxDBSet, frxExportBaseDialog, frxExportPDF, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage, Vcl.Menus, uniMainMenu, uniSweetAlert;

type
  TControleConsultaUsuario = class(TControleConsulta)
    UniScreenMask1: TUniScreenMask;
    UniEdit1: TUniEdit;
    UniEdit3: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaLOGIN: TWideStringField;
    CdsConsultaSENHA: TWideStringField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaSCHEMA: TWideStringField;
    QryPermissao: TADOQuery;
    QryPermissaoID: TFloatField;
    QryPermissaoUSUARIO_ID: TFloatField;
    QryPermissaoMENU_CLIENTE_BOTAO: TWideStringField;
    QryPermissaoMENU_EMPRESA_BOTAO: TWideStringField;
    QryPermissaoMENU_CIDADES_BOTAO: TWideStringField;
    QryPermissaoMENU_DASHBOARD_BOTAO: TWideStringField;
    QryPermissaoMENU_AUDITORIA_BOTAO: TWideStringField;
    QryPermissaoMENU_USUARIOS_BOTAO: TWideStringField;
    QryPermissaoMENU_CADASTRO_BOTAO: TWideStringField;
    QryPermissaoMENU_SCHEMA_BOTAO: TWideStringField;
    QryPermissaoMENU_SCHEMA_CADASTRO_BOTAO: TWideStringField;
    QryPermissaoMENU_FORNECEDOR_BOTAO: TWideStringField;
    QryPermissaoMENU_BANCO_BOTAO: TWideStringField;
    QryPermissaoMENU_CONTABANCARIA_BOTAO: TWideStringField;
    QryPermissaoMENU_TITULOSPAGAR_BOTAO: TWideStringField;
    QryPermissaoMENU_TITULOSRECEBER_BOTAO: TWideStringField;
    QryPermissaoMENU_TIPOTITULO_BOTAO: TWideStringField;
    QryPermissaoMENU_DADOS_REPRES_BOTAO: TWideStringField;
    QryPermissaoMENU_CLIENTE_REPRES_BOTAO: TWideStringField;
    QryPermissaoMENU_RECEBIVEIS_REPRES_BOTAO: TWideStringField;
    QryPermissaoMENU_CAIXA_BOTAO: TWideStringField;
    QryPermissaoMENU_DOCUMENT_ELETRONICO_BOTAO: TWideStringField;
    QryPermissaoMENU_SIGNATARIO_BOTAO: TWideStringField;
    QryPermissaoMENU_CHEQUESRECEBIDOS_BOTAO: TWideStringField;
    QryPermissaoMENU_DESTINOCHEQUE_BOTAO: TWideStringField;
    QryPermissaoMENU_CATEGORIATITULO_BOTAO: TWideStringField;
    QryPermissaoMENU_CHEQUESDEPOSITADOS_BOTAO: TWideStringField;
    QryPermissaoMENU_CATEGORIAPRODUTO_BOTAO: TWideStringField;
    QryPermissaoMENU_TABELAPRECO_BOTAO: TWideStringField;
    QryPermissaoMENU_GRUPOTRIBUTOS_BOTAO: TWideStringField;
    QryPermissaoMENU_PROD_TABPRECO_EXCEC_BOTAO: TWideStringField;
    QryPermissaoMENU_PRODUTO_EMBALAGEM_BOTAO: TWideStringField;
    QryPermissaoMENU_INTCONTASRECEBER_BOTAO: TWideStringField;
    QryPermissaoMENU_INTCONTASPAGAR_BOTAO: TWideStringField;
    QryPermissaoMENU_RELATORIO_BOTAO: TWideStringField;
    QryPermissaoMENU_RELAT_CONTASPAGAR_BOTAO: TWideStringField;
    QryPermissaoMENU_RELAT_CONTASRECEBER_BOTAO: TWideStringField;
    QryPermissaoMENU_RELAT_CPAGAR_OBS_BOTAO: TWideStringField;
    QryPermissaoMENU_RELAT_CHEQUES_BOTAO: TWideStringField;
    QryPermissaoMENU_DESCONTO_VALE_BOTAO: TWideStringField;
    QryPermissaoMENU_CONFIG_MSG_COBRANCA_BOTAO: TWideStringField;
    QryPermissaoMENU_ENVIA_MSG_COBRANCA_BOTAO: TWideStringField;
    QryPermissaoMENU_ALT_PERMISS_USUARIO_BOTAO: TWideStringField;
    DscPermissao: TDataSource;
    CdsPermissao: TClientDataSet;
    CdsPermissaoID: TFloatField;
    CdsPermissaoUSUARIO_ID: TFloatField;
    CdsPermissaoMENU_CLIENTE_BOTAO: TWideStringField;
    CdsPermissaoMENU_EMPRESA_BOTAO: TWideStringField;
    CdsPermissaoMENU_CIDADES_BOTAO: TWideStringField;
    CdsPermissaoMENU_DASHBOARD_BOTAO: TWideStringField;
    CdsPermissaoMENU_AUDITORIA_BOTAO: TWideStringField;
    CdsPermissaoMENU_USUARIOS_BOTAO: TWideStringField;
    CdsPermissaoMENU_CADASTRO_BOTAO: TWideStringField;
    CdsPermissaoMENU_SCHEMA_BOTAO: TWideStringField;
    CdsPermissaoMENU_SCHEMA_CADASTRO_BOTAO: TWideStringField;
    CdsPermissaoMENU_FORNECEDOR_BOTAO: TWideStringField;
    CdsPermissaoMENU_BANCO_BOTAO: TWideStringField;
    CdsPermissaoMENU_CONTABANCARIA_BOTAO: TWideStringField;
    CdsPermissaoMENU_TITULOSPAGAR_BOTAO: TWideStringField;
    CdsPermissaoMENU_TITULOSRECEBER_BOTAO: TWideStringField;
    CdsPermissaoMENU_TIPOTITULO_BOTAO: TWideStringField;
    CdsPermissaoMENU_DADOS_REPRES_BOTAO: TWideStringField;
    CdsPermissaoMENU_CLIENTE_REPRES_BOTAO: TWideStringField;
    CdsPermissaoMENU_RECEBIVEIS_REPRES_BOTAO: TWideStringField;
    CdsPermissaoMENU_CAIXA_BOTAO: TWideStringField;
    CdsPermissaoMENU_DOCUMENT_ELETRONICO_BOTAO: TWideStringField;
    CdsPermissaoMENU_SIGNATARIO_BOTAO: TWideStringField;
    CdsPermissaoMENU_CHEQUESRECEBIDOS_BOTAO: TWideStringField;
    CdsPermissaoMENU_DESTINOCHEQUE_BOTAO: TWideStringField;
    CdsPermissaoMENU_CATEGORIATITULO_BOTAO: TWideStringField;
    CdsPermissaoMENU_CHEQUESDEPOSITADOS_BOTAO: TWideStringField;
    CdsPermissaoMENU_CATEGORIAPRODUTO_BOTAO: TWideStringField;
    CdsPermissaoMENU_TABELAPRECO_BOTAO: TWideStringField;
    CdsPermissaoMENU_GRUPOTRIBUTOS_BOTAO: TWideStringField;
    CdsPermissaoMENU_PROD_TABPRECO_EXCEC_BOTAO: TWideStringField;
    CdsPermissaoMENU_PRODUTO_EMBALAGEM_BOTAO: TWideStringField;
    CdsPermissaoMENU_INTCONTASRECEBER_BOTAO: TWideStringField;
    CdsPermissaoMENU_INTCONTASPAGAR_BOTAO: TWideStringField;
    CdsPermissaoMENU_RELATORIO_BOTAO: TWideStringField;
    CdsPermissaoMENU_RELAT_CONTASPAGAR_BOTAO: TWideStringField;
    CdsPermissaoMENU_RELAT_CONTASRECEBER_BOTAO: TWideStringField;
    CdsPermissaoMENU_RELAT_CPAGAR_OBS_BOTAO: TWideStringField;
    CdsPermissaoMENU_RELAT_CHEQUES_BOTAO: TWideStringField;
    CdsPermissaoMENU_DESCONTO_VALE_BOTAO: TWideStringField;
    CdsPermissaoMENU_CONFIG_MSG_COBRANCA_BOTAO: TWideStringField;
    CdsPermissaoMENU_ENVIA_MSG_COBRANCA_BOTAO: TWideStringField;
    CdsPermissaoMENU_ALT_PERMISS_USUARIO_BOTAO: TWideStringField;
    DspPermissao: TDataSetProvider;
    procedure UniFrameCreate(Sender: TObject);
  private
    procedure ApagarUsuario(Id: Integer);
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

var
  AlteraPermissao : Boolean;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Cadastro.Usuario, Controle.Funcoes;

// -------------------------------------------------------------------------- //
procedure TControleConsultaUsuario.Novo;
begin
  if ControleCadastroUsuario.Novo() then
  begin
    ControleCadastroUsuario.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaUsuario.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroUsuario.Abrir(Id) then
  begin
    //informa se o usuário logado pode alterar permissões e adicionar novos usuários

    ControleCadastroUsuario.Alterapermissao := CdsPermissaoMENU_ALT_PERMISS_USUARIO_BOTAO.AsString;
    ControleCadastroUsuario.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaUsuario.UniFrameCreate(Sender: TObject);
begin
  //inherited;

  Try

    CdsPermissao.Close;
    CdsPermissao.Params.ParamByName('usuario_id').Value := ControleMainModule.FUsuarioId;
    CdsPermissao.Open;

    if CdsPermissaoMENU_ALT_PERMISS_USUARIO_BOTAO.AsString <> 'P' then
    begin
      //LIMITA O USUÁRIO AO ACESSO SOMENTE DELE
      QryConsulta.Close;
      QryConsulta.SQL.Clear;
      QryConsulta.Parameters.Clear;
      QryConsulta.SQL.Text :=  '  SELECT usr.id,'
                              +'         Upper(usr.login) login,'
                              +'         Upper(usr.senha) senha,'
                              +'         DECODE(usr.ativo, ''S'', ''SIM'', ''N'', ''NÃO'') ativo,'
                              +'         usr.schema'
                              +'  FROM usuario usr'
                              +'  WHERE Upper(usr.schema) like :schema'
                              +'  AND usr.id = '+ IntToStr(ControleMainModule.FUsuarioId)
                              +'  AND nvl(usr.login,'' '') like :login'
                              +'  AND nvl(usr.ativo,'' '') like :ativo';

      BotaoNovo.Visible := False;
    end;

    CdsConsulta.Close;
    QryConsulta.Close;
    QryConsulta.Parameters.ParamByName('schema').Value := ControleMainModule.FSchema;
    QryConsulta.Parameters.ParamByName('login').Value        := '%%';
    QryConsulta.Parameters.ParamByName('ativo').Value        := '%%';
    CdsConsulta.Params.ParamByName('schema').Value       := ControleMainModule.FSchema;
    CdsConsulta.Params.ParamByName('login').Value        := '%%';
    CdsConsulta.Params.ParamByName('ativo').Value        := '%%';
    CdsConsulta.Open;

  except
    on e:exception do
     ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
  End;
end;

procedure TControleConsultaUsuario.ApagarUsuario(Id: Integer);
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
        'DELETE FROM usuario'
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
      BotaoAtualizar.Refresh;
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
