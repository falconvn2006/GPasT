unit Controle.Operacoes.MensagensCobranca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Operacoes, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniGUIClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton,
  uniPanel, uniEdit, uniDBEdit, uniMemo, uniDBMemo, uniPageControl,
  Vcl.Imaging.GIFImg, uniImage, uniFileUpload, Funcoes.client, uniBasicGrid,
  uniDBGrid;


type
  TControleOperacoesMensagensCobranca = class(TControleOperacoes)
    UniDBEdtURL: TUniDBEdit;
    UniDBEdtToken: TUniDBEdit;
    QryCadastroID: TFloatField;
    QryCadastroURL_API: TWideStringField;
    QryCadastroTOKEN_API: TWideStringField;
    QryCadastroDIAS_DEPOIS_VENCIMENTO: TFloatField;
    QryCadastroDIAS_INTERVALO_ENTRE_COBRANCA: TFloatField;
    CdsCadastroID: TFloatField;
    CdsCadastroURL_API: TWideStringField;
    CdsCadastroDIAS_ANTES_VENCIMENTO: TFloatField;
    CdsCadastroDIAS_DEPOIS_VENCIMENTO: TFloatField;
    CdsCadastroDIAS_INTERVALO_ENTRE_COBRANCA: TFloatField;
    UniPageControlCentral: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniDBMemoMensagemDepois: TUniDBMemo;
    QryCadastroFOTO_CAMINHO: TWideStringField;
    CdsCadastroFOTO_CAMINHO: TWideStringField;
    ButtonImportaImagem: TUniButton;
    BotaoApagarImagem: TUniButton;
    UniLabel18: TUniLabel;
    UniPanel5: TUniPanel;
    ImageFoto: TUniImage;
    UniDBFormattedNumberEdit1: TUniDBFormattedNumberEdit;
    UniDBFormattedNumberEdit2: TUniDBFormattedNumberEdit;
    QryCadastroQUANT_DIAS_DE_COBRANCA: TFloatField;
    CdsCadastroQUANT_DIAS_DE_COBRANCA: TFloatField;
    UniFileUpload1: TUniFileUpload;
    UniTabSheet3: TUniTabSheet;
    DscCloneTotais: TDataSource;
    DscCloneItens: TDataSource;
    DscCloneItens2: TDataSource;
    UniDBMemoMensagemAntes: TUniDBMemo;
    QryCadastroTEXTO_ANTES_VENCIMENTO: TWideStringField;
    QryCadastroTEXTO_DEPOIS_VENCIMENTO: TWideStringField;
    QryCadastroDIAS_ANTES_VENCIMENTO: TFloatField;
    CdsCadastroTOKEN_API: TWideStringField;
    CdsCadastroTEXTO_ANTES_VENCIMENTO: TWideStringField;
    CdsCadastroTEXTO_DEPOIS_VENCIMENTO: TWideStringField;
    QryCadastroTEXTO_BOAS_VINDAS: TWideStringField;
    CdsCadastroTEXTO_BOAS_VINDAS: TWideStringField;
    UniDBMemo1: TUniDBMemo;
    UniDBEdit1: TUniDBEdit;
    QryCadastroURL_RETORNO: TWideStringField;
    CdsCadastroURL_RETORNO: TWideStringField;
    procedure UniFormShow(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure ButtonImportaImagemClick(Sender: TObject);
    procedure BotaoApagarImagemClick(Sender: TObject);
    procedure UniFileUpload1Completed(Sender: TObject; AStream: TFileStream);
  private
    URL_LOGO : String;
    function Salvar: Boolean;
    procedure VerificaSeCaminhoImagemExiste;
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleOperacoesMensagensCobranca: TControleOperacoesMensagensCobranca;


var
  CadastroId : integer;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, Controle.Server.Module, uniGUIApplication,
  Controle.Funcoes, System.NetEncoding, Envia.Recebe.Dados.Json, REST.Types,
  System.Math;

function ControleOperacoesMensagensCobranca: TControleOperacoesMensagensCobranca;
begin
  Result := TControleOperacoesMensagensCobranca(ControleMainModule.GetFormInstance(TControleOperacoesMensagensCobranca));
end;

procedure TControleOperacoesMensagensCobranca.UniFileUpload1Completed(
  Sender: TObject; AStream: TFileStream);
var
  DestName : string;
  DestFolder : string;
begin
  Try
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\');

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\');

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cobranca\' ) then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cobranca\' );

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cobranca\'+ CdsCadastroID.AsString) then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cobranca\'+ CdsCadastroID.AsString);

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cobranca\'+ CdsCadastroID.AsString +'\Foto\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cobranca\'+ CdsCadastroID.AsString +'\Foto\');

    DestFolder  := ControleServerModule.StartPath + 'UploadFolder\' + ControleMainModule.FSchema + '\' + 'Cobranca\' + CdsCadastroID.AsString +'\Foto\';
    DestName    := DestFolder + ExtractFileName(UniFileUpload1.FileName);
    CopyFile(PChar(AStream.FileName), PChar(DestName), False);
    ControleFuncoes.CarregaImagemGeral(DestName, ImageFoto);
    URL_LOGO := DestName;
  Except
    on e:exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
    end;
  End;

  Salvar;
end;

procedure TControleOperacoesMensagensCobranca.BotaoApagarImagemClick(
  Sender: TObject);
var
  Erro: string;
begin
  inherited;

  // Update
  with ControleMainModule do
  begin
    ADOConnection.BeginTrans;

    // Inserindo o login do usuario em tabela temporaria,
    // Utilzado para auditoria
    Insere_Tabela_Temp_Login;

    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Add('UPDATE cliente');
    QryAx1.SQL.Add('   SET foto_caminho  = null');
    QryAx1.SQL.Add(' WHERE id            = :id');
    QryAx1.Parameters.ParamByName('id').Value    := CdsCadastroID.AsInteger;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
      ADOConnection.CommitTrans;

      DeleteFile(URL_LOGO);
      ControleFuncoes.CarregaImagemGeral('', ImageFoto);
    except
      on E: Exception do
      begin
        ADOConnection.RollbackTrans;
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;
  end;
end;

procedure TControleOperacoesMensagensCobranca.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  Salvar;
end;

procedure TControleOperacoesMensagensCobranca.UniFormShow(Sender: TObject);
begin
  inherited;
  CdsCadastro.Open;

  CadastroId := CdsCadastro.RecordCount;
  URL_LOGO   := CdsCadastroFOTO_CAMINHO.AsString;

  if CadastroId = 0 then
    CdsCadastro.Insert
  else
    CdsCadastro.Edit;

  UniPageControlCentral.ActivePageIndex := 0;

  VerificaSeCaminhoImagemExiste;

  // carregando a imagem
  ControleFuncoes.CarregaImagemGeral(CdsCadastroFOTO_CAMINHO.AsString,
                                     ImageFoto);

  if ImageFoto.Picture = nil then
    BotaoApagarImagem.Visible := False;
end;

procedure TControleOperacoesMensagensCobranca.ButtonImportaImagemClick(
  Sender: TObject);
begin
  inherited;
  Try
    with UniFileUpload1 do
    begin
      MaxAllowedSize := 5000000;
      Execute;
    end;
    BotaoApagarImagem.Visible := True;
  Except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  End;
end;

function TControleOperacoesMensagensCobranca.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      if Trim(UniDBEdtURL.Text) = '' then
      begin
        MessageDlg('É necessário informar a URL da API.'^M''+ 'Dados incompletos', mtWarning, [mbOK]);
        UniDBEdtURL.SetFocus;
        Exit;
      end;

      if Trim(UniDBEdtToken.Text) = '' then
      begin
        MessageDlg('É necessário informar o Token da API.'^M''+ 'Dados incompletos', mtWarning, [mbOK]);
        UniDBEdtToken.SetFocus;
        Exit;
      end;

      // Confirma os dados
      CdsCadastro.Post;
    end;
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
      // Gera um novo id para a tabela envia_mensagem
      CadastroId := GeraId('envia_mensagem');
      // Insert
      QryAx1.SQL.Text :=     'INSERT INTO envia_mensagem ('
                           + ' id,'
                           + ' url_api,'
                           + ' url_retorno,'
                           + ' token_api,'
                           + ' texto_antes_vencimento,'
                           + ' texto_depois_vencimento,'
                           + ' texto_boas_vindas,'
                           + ' dias_antes_vencimento,'
                           + ' dias_depois_vencimento,'
                           + ' dias_intervalo_entre_cobranca,'
                           + ' quant_dias_de_cobranca,'
                           + ' foto_caminho)'
                           + 'VALUES ('
                           + ' :id,'
                           + ' :url_api,'
                           + ' :url_retorno,'
                           + ' :token_api,'
                           + ' :texto_antes_vencimento,'
                           + ' :texto_depois_vencimento,'
                           + ' :texto_boas_vindas,'
                           + ' :dias_antes_vencimento,'
                           + ' :dias_depois_vencimento,'
                           + ' :dias_intervalo_entre_cobranca,'
                           + ' :quant_dias_de_cobranca,'
                           + ' :foto_caminho)';
    end
    else
    begin
      // Update
      QryAx1.SQL.Text :=
                            ' UPDATE envia_mensagem SET'
                          + '        url_api                           = :url_api,'
                          + '        url_retorno                       = :url_retorno,'
                          + '        token_api                         = :token_api,'
                          + '        texto_antes_vencimento            = :texto_antes_vencimento,'
                          + '        texto_depois_vencimento           = :texto_depois_vencimento,'
                          + '        texto_boas_vindas                 = :texto_boas_vindas,'
                          + '        dias_antes_vencimento             = :dias_antes_vencimento,'
                          + '        dias_depois_vencimento            = :dias_depois_vencimento,'
                          + '        dias_intervalo_entre_cobranca     = :dias_intervalo_entre_cobranca,'
                          + '        quant_dias_de_cobranca            = :quant_dias_de_cobranca,'
                          + '        foto_caminho                      = :foto_caminho'
                          + '  WHERE id                                = :id';
     end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('url_api').Value       := CdsCadastro.FieldByName('url_api').AsString;
    QryAx1.Parameters.ParamByName('url_retorno').Value       := CdsCadastro.FieldByName('url_retorno').AsString;
    QryAx1.Parameters.ParamByName('token_api').Value       := CdsCadastro.FieldByName('token_api').AsString;
    QryAx1.Parameters.ParamByName('texto_antes_vencimento').Value       := CdsCadastro.FieldByName('texto_antes_vencimento').AsString;
    QryAx1.Parameters.ParamByName('texto_depois_vencimento').Value       := CdsCadastro.FieldByName('texto_depois_vencimento').AsString;
    QryAx1.Parameters.ParamByName('texto_boas_vindas').Value       := CdsCadastro.FieldByName('texto_boas_vindas').AsString;
    QryAx1.Parameters.ParamByName('dias_antes_vencimento').Value       := CdsCadastro.FieldByName('dias_antes_vencimento').AsString;
    QryAx1.Parameters.ParamByName('dias_depois_vencimento').Value       := CdsCadastro.FieldByName('dias_depois_vencimento').AsString;
    QryAx1.Parameters.ParamByName('dias_intervalo_entre_cobranca').Value       := CdsCadastro.FieldByName('dias_intervalo_entre_cobranca').AsString;
    QryAx1.Parameters.ParamByName('quant_dias_de_cobranca').Value       := CdsCadastro.FieldByName('quant_dias_de_cobranca').AsString;
    QryAx1.Parameters.ParamByName('foto_caminho').Value       := URL_LOGO;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        MessageDlg('Não foi possível salvar os dados alterados.'^M''+ 'Erro de gravação '+ E.Message, mtWarning, [mbOK]);
        CdsCadastro.Edit;

        Exit;
      end;
    end;

    // Confirma a transação
    ADOConnection.CommitTrans;

    Result := True;
  end;
end;

procedure  TControleOperacoesMensagensCobranca.VerificaSeCaminhoImagemExiste;
begin
  // Criando a pasta no servidor, caso nao exista
  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Cobranca\') then
  begin
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
             'Cobranca\');
  end;

  // Criando a pasta no servidor, caso nao exista
  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Cobranca\' + CdsCadastroID.AsString) then
  begin
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
             'Cobranca\' + CdsCadastroID.AsString);
  end;

  // Criando a pasta no servidor, caso nao exista
  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Cobranca\' + CdsCadastroID.AsString + '\Foto\') then
  begin
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
             'Cobranca\' + CdsCadastroID.AsString + '\Foto\');
  end;
end;

end.
