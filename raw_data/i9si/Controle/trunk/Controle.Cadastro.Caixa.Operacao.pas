unit Controle.Cadastro.Caixa.Operacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, ACBrBase, ACBrSocket, ACBrCEP,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniMultiItem, uniComboBox, uniDBComboBox,
  uniDBLookupComboBox, uniEdit, uniMemo, uniDBEdit, uniDBMemo, uniSweetAlert;

type
  TControleCadastroCaixaOperacao = class(TControleCadastro)
    UniLabel7: TUniLabel;
    UniLabel5: TUniLabel;
    UniDBLookupComboBoxForma: TUniDBLookupComboBox;
    UniLabel3: TUniLabel;
    DscFormaPagto: TDataSource;
    CdsFormaPagto: TClientDataSet;
    CdsFormaPagtoID: TFloatField;
    CdsFormaPagtoDESCRICAO: TWideStringField;
    DspFormaPagto: TDataSetProvider;
    QryFormaPagto: TADOQuery;
    UniLabel1: TUniLabel;
    UniLabelTipoOperacao: TUniLabel;
    QryCadastroID: TFloatField;
    QryCadastroCAIXA_ID: TFloatField;
    QryCadastroDATA_MOVIMENTO: TDateTimeField;
    QryCadastroVALOR: TFloatField;
    QryCadastroOBSERVACAO: TWideStringField;
    QryCadastroFORMA_PAGAMENTO_ID: TFloatField;
    QryCadastroFORMA_PAGAMENTO: TWideStringField;
    QryCadastroDATA_ABERTURA: TWideStringField;
    QryCadastroUSUARIO_ID: TFloatField;
    QryCadastroUSUARIO: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroCAIXA_ID: TFloatField;
    CdsCadastroDATA_MOVIMENTO: TDateTimeField;
    CdsCadastroVALOR: TFloatField;
    CdsCadastroOBSERVACAO: TWideStringField;
    CdsCadastroFORMA_PAGAMENTO_ID: TFloatField;
    CdsCadastroFORMA_PAGAMENTO: TWideStringField;
    CdsCadastroDATA_ABERTURA: TWideStringField;
    CdsCadastroUSUARIO_ID: TFloatField;
    CdsCadastroUSUARIO: TWideStringField;
    UniDBFormattedNumberEditValor: TUniDBFormattedNumberEdit;
    UniDBMemo1: TUniDBMemo;
    procedure UniFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TipoOperacao: String;
    CaixaId: Integer;
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroCaixaOperacao: TControleCadastroCaixaOperacao;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleCadastroCaixaOperacao: TControleCadastroCaixaOperacao;
begin
  Result := TControleCadastroCaixaOperacao(ControleMainModule.GetFormInstance(TControleCadastroCaixaOperacao));
end;

function TControleCadastroCaixaOperacao.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  UniLabelTipoOperacao.Caption := TipoOperacao;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  Result := True;
end;

function TControleCadastroCaixaOperacao.Editar(Id: Integer): Boolean;
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

function TControleCadastroCaixaOperacao.Novo(): Boolean;
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

function TControleCadastroCaixaOperacao.Descartar: Boolean;
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

function TControleCadastroCaixaOperacao.Salvar: Boolean;
begin
  inherited;

  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Verifica o nome da cidade
    if Trim(UniDBLookupComboBoxForma.Text) = '' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a forma de pagamento.');
      UniDBLookupComboBoxForma.SetFocus;
      Exit;
    end;

    if (UniDBFormattedNumberEditValor.Text = '')  then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar um valor válido.');
      UniDBFormattedNumberEditValor.SetFocus;
      Exit;
    end;

    if (UniDBFormattedNumberEditValor.Value <= 0)  then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar um valor válido.');
      UniDBFormattedNumberEditValor.SetFocus;
      Exit;
    end;

    // Confirma os dados
    CdsCadastro.Post;
  end;

  // Pega o id do registro
  CadastroId := CaixaId;

  with ControleMainModule do
  begin
    if TipoOperacao = 'SUPRIMENTO' then
    begin
      ADOConnection.BeginTrans;
      registra_movimento(cadastroid,
                         'C',
                         'SU',
                         CdsCadastroVALOR.AsFloat,
                         CdsCadastroFORMA_PAGAMENTO_ID.AsInteger,
                         0,
                         CdsCadastroOBSERVACAO.AsString);
      ADOConnection.CommitTrans;
    end
    else if TipoOperacao = 'SANGRIA' then
    begin
      ADOConnection.BeginTrans;
      registra_movimento(cadastroid,
                         'D',
                         'SA',
                         CdsCadastroVALOR.AsFloat,
                         CdsCadastroFORMA_PAGAMENTO_ID.AsInteger,
                         0,
                         CdsCadastroOBSERVACAO.AsString);
      ADOConnection.CommitTrans;
    end;

    // Recarrega o registro
    Abrir(CadastroId);
    Result := True;
    Close;
  end;
end;

procedure TControleCadastroCaixaOperacao.UniFormShow(Sender: TObject);
begin
  inherited;
  CdsFormaPagto.Open;

end;

end.
