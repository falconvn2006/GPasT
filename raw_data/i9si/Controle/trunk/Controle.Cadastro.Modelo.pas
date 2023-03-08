unit Controle.Cadastro.Modelo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Cadastro, Data.DB,
  Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses,
  uniGUIClasses, uniImageList, uniButton, uniPanel, uniBitBtn, uniSpeedButton,
  uniEdit, uniDBEdit, uniLabel, uniFileUpload, uniMemo, uniDBMemo, ACBrBase,
  ACBrSocket, ACBrCEP,  uniPageControl, uniBasicGrid, uniDBGrid, uniSweetAlert;

type
  TControleCadastroModelo = class(TControleCadastro)
    CdsCadastroID: TFloatField;
    QryCadastroID: TFloatField;
    UniLabel1: TUniLabel;
    DBEditDescricao: TUniDBEdit;
    BotaoUploadArquivo: TUniSpeedButton;
    UniFileUpload1: TUniFileUpload;
    QryCadastroDESCRICAO: TWideStringField;
    CdsCadastroDESCRICAO: TWideStringField;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    GrdResultado: TUniDBGrid;
    UniPanel5: TUniPanel;
    UniPanel7: TUniPanel;
    ButtonImportaImagem: TUniButton;
    BotaoApagarImagem: TUniButton;
    UniPanel9: TUniPanel;
    UniPanel10: TUniPanel;
    UniPanel11: TUniPanel;
    UniFileUploadDocumento: TUniFileUpload;
    UniSweetExclusaoDocumento: TUniSweetAlert;
    procedure UniFileUpload1Completed(Sender: TObject; AStream: TFileStream);
    procedure BotaoUploadArquivoClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure ButtonImportaImagemClick(Sender: TObject);
    procedure UniFileUploadDocumentoCompleted(Sender: TObject;
      AStream: TFileStream);
    procedure BotaoApagarImagemClick(Sender: TObject);
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
    procedure UniFormShow(Sender: TObject);
    procedure UniSweetExclusaoDocumentoConfirm(Sender: TObject);
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

 function ControleCadastroModelo: TControleCadastroModelo;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Server.Module, Controle.Funcoes,
   Controle.Impressao.Documento;

function ControleCadastroModelo: TControleCadastroModelo;
begin
  Result := TControleCadastroModelo(ControleMainModule.GetFormInstance(TControleCadastroModelo));
end;

{ TControleCadastroCliente }

function TControleCadastroModelo.Abrir(Id: Integer): Boolean;
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

function TControleCadastroModelo.Editar(Id: Integer): Boolean;
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

  // Atualiza os botões de comando
  //  AtualizaComandos(DscCadastro);

  // Bloqueia a mudança do tipo de pessoa e cpf/cnpj na edição.
  // NOTA: Se for necessário alterar o cpf/cnpj, deve ser feito pelo cadastro
  //       de pessoa. O tipo de pessoa nunca pode ser alterado depois de
  //       cadastrado.
{  DBEdtCpfCnpj.Color           := clBtnFace;
  DBEdtCpfCnpj.Enabled         := True;
  DBComboTipo.Enabled          := False;}
//  BotaoPesquisaPessoa.Visible := False;

  Result := True;
end;

procedure TControleCadastroModelo.GrdResultadoCellClick(
  Column: TUniDBGridColumn);
var
  docOrigem, DocTemp, ArquivoPDF, textoPlanos: string;
begin
  inherited;
  if Column.FieldName = 'CAMINHO' then
  begin
    // Se for RTF ele converte para pdf e depois abre
    if ControleFuncoes.CopyReverse(ControleMainModule.CdsListaArquivosCAMINHO.AsString,1,3) = 'rtf' then
    begin
      UniSession.SendFile(ControleMainModule.CdsListaArquivosCAMINHO.AsString)
    {  Try
        UniSession.SendFile('htdocs\'+ ControleMainModule.CdsListaArquivosCAMINHO.AsString);
      Except
        UniSession.SendFile('htdocs\'+ ControleMainModule.FSchema + '\' + ControleMainModule.CdsListaArquivosCAMINHO.AsString);
      End;}
    end
    else
    begin
      ControleImpressaoDocumento.UniURLFrame1.URL := ControleMainModule.CdsListaArquivosCAMINHO.AsString;
      ControleImpressaoDocumento.ShowModal;
    end;
  end;
end;

function TControleCadastroModelo.Novo(): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;

    DBEditDescricao.SetFocus;
//
    // Libera a mudança do tipo de pessoa e cpf/cnpj na inserção
{    DBEdtCpfCnpj.Color           := clWindow;
    DBEdtCpfCnpj.ReadOnly        := False;
    DBComboTipo.Enabled          := True;
    BotaoPesquisaPessoa.Visible := True;}

    Result := True;
  end;
end;

function TControleCadastroModelo.Salvar: Boolean;
Var
  Erro, Tipo: String;
begin
  inherited;

  Erro   := '';
  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Verifica o nome do arquivo
    if DBEditDescricao.Text = '' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário escolher o arquivo.');
      DBEditDescricao.SetFocus;
      Exit;
    end;

    // Confirma os dados
    CdsCadastro.Post;
  end;

  // Pega os ids do registro
  CadastroId   := CdsCadastro.FieldByName('id').AsInteger;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo 1 - Salva os dados da pessoa
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a pessoa
      CadastroId := GeraId('modelo');

      // Insert
      QryAx1.SQL.Add('INSERT INTO modelo (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE modelo SET');
      QryAx1.SQL.Add('       descricao          = :descricao');
      QryAx1.SQL.Add(' WHERE id = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value              := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value       := CdsCadastro.FieldByName('descricao').AsString;
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
    ControleMainModule.ADOConnection.RollbackTrans;
    ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
    CdsCadastro.Edit;
  end
  else
  begin
    // Confirma a transação
    ControleMainModule.ADOConnection.CommitTrans;

    // Recarrega o registro
    Abrir(CadastroId);
    ControleMainModule.modelo_id_m := CdsCadastroID.AsInteger;
    ControleMainModule.CarregaListaDeArquivos(ControleMainModule.modelo_id_m,
                                              'MODELO');

    Result := True;
  end;
end;

procedure TControleCadastroModelo.UniFileUpload1Completed(Sender: TObject;
  AStream: TFileStream);
var
  DestName : string;
  DestFolder : string;
begin
  DestFolder:= ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\Modelos\Documentos\';
  DestName:=DestFolder+ExtractFileName(UniFileUpload1.FileName);
  CopyFile(PChar(AStream.FileName), PChar(DestName), False);

  // Capturando o nome do arquivo
 // CdsCadastro.Edit;
{  CdsCadastroNOME_ARQUIVO.AsString := UniFileUpload1.FileName;
  if CdsCadastroDESCRICAO.AsString = '' then
    CdsCadastroDESCRICAO.AsString := UniFileUpload1.FileName;}

  BotaoSalvar.Click;
end;

procedure TControleCadastroModelo.UniFileUploadDocumentoCompleted(
  Sender: TObject; AStream: TFileStream);
var
  DestName: string;
  DestFolder: string;
begin
  Try
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Documento') then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Documento');
    end;

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Documento\' + IntToStr(ControleMainModule.modelo_id_m)) then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Documento\' + IntToStr(ControleMainModule.modelo_id_m));
    end;

    // Criando a pasta no servidor, caso nao exista
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                         'Documento\' + IntToStr(ControleMainModule.modelo_id_m)) then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
               'Documento\' + IntToStr(ControleMainModule.modelo_id_m));
    end;

    // Criando a pasta no servidor, caso nao exista
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                         'Documento\' + IntToStr(ControleMainModule.modelo_id_m) + '\Modelo\') then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
               'Documento\' + IntToStr(ControleMainModule.modelo_id_m) + '\Modelo');
    end;

    // Caso não consiga fazer o upload, alterar para esse abaixo e comentar o outro
    DestFolder      := ControleServerModule.StartPath + 'UploadFolder\' + ControleMainModule.FSchema + '\' + 'Documento\' +
                       InttoStr(ControleMainModule.modelo_id_m) +'\Modelo\';
    DestName        := DestFolder + ExtractFileName(TimeToStr(Time()) +'_'+ UniFileUploadDocumento.FileName);
    CopyFile(PChar(AStream.FileName), PChar(DestName), False);
    ControleMainModule.URL_LOGO_MAIN_MODULE        := DestName;

    Prompt('Digite a descrição',
           UniFileUploadDocumento.FileName,
           mtConfirmation,
           mbOKCancel,
           ControleMainModule.ConfirmaSalvarDocumentoModelo);
  Except
    on e:exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
    end;
  End;

end;

procedure TControleCadastroModelo.UniFormCreate(Sender: TObject);
begin
  inherited;
  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\') then
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\');

  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' + 'Modelos') then
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' + 'Modelos');

  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' + 'Modelos' + '\' + 'Documentos') then
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' + 'Modelos' + '\' + 'Documentos');
end;

procedure TControleCadastroModelo.UniFormShow(Sender: TObject);
begin
  inherited;
  ControleMainModule.modelo_id_m := CdsCadastroID.AsInteger;

  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Documento\') then
  begin
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Documento\');
  end;

  //controleOperacoesmodelosCarne.showModal;
  ControleMainModule.CarregaListaDeArquivos(ControleMainModule.modelo_id_m,
                                            'MODELO');
end;

procedure TControleCadastroModelo.UniSweetExclusaoDocumentoConfirm(
  Sender: TObject);
var
    modelo_id : integer;
begin
  inherited;
  modelo_id := ControleMainModule.CdsListaArquivos.FieldByName('tabela_id').AsInteger;
  ControleMainModule.ApagarDocumento('documentos',
                                      ControleMainModule.CdsListaArquivos.FieldByName('id').AsInteger);
  ControleMainModule.CdsListaArquivos.Refresh;

  if ControleMainModule.CdsListaArquivos.RecordCount = 0 then
    ControleMainModule.ModeloPossuiAnexo(modelo_id,
                                        'N');
end;

procedure TControleCadastroModelo.BotaoApagarImagemClick(Sender: TObject);

begin
  inherited;
  if ControleMainModule.CdsListaArquivos.RecordCount > 0 then
    UniSweetExclusaoDocumento.show
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não há registro para serem excluidos!');
end;

procedure TControleCadastroModelo.BotaoUploadArquivoClick(Sender: TObject);
begin
  inherited;
  UniFileUpload1.Execute;
end;

procedure TControleCadastroModelo.ButtonImportaImagemClick(Sender: TObject);
begin
  inherited;
  BotaoSalvar.Click;
  BotaoEditar.Click;

  Try
    with UniFileUploadDocumento do
    begin
      MaxAllowedSize := 5000000;
      Execute;
     // UniMainModule.CarregaListaDeArquivos(modelo_id);
    end;
  Except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
    end;
  End;
end;

function TControleCadastroModelo.Descartar: Boolean;
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

end.
