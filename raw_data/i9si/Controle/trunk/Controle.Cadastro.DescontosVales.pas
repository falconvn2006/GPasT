unit Controle.Cadastro.DescontosVales;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, uniSweetAlert, ACBrBase,
  ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel, uniMemo, uniDateTimePicker, uniEdit, uniDBEdit,
  uniDBDateTimePicker, uniDBMemo, frxClass, frxDBSet, uniPageControl;

type
  TControleCadastroDescontosVales = class(TControleCadastro)
    CdsCadastroSITUACAO: TWideStringField;
    CdsCadastroCLIENTE_ID: TFloatField;
    CdsCadastroRAZAO_SOCIAL: TWideStringField;
    CdsCadastroVALOR: TFloatField;
    CdsCadastroCUPOM_ORIGINAL: TFloatField;
    CdsCadastroDATA_EMISSAO: TDateTimeField;
    CdsCadastroMOTIVO: TWideStringField;
    CdsCadastroID: TFloatField;
    QryCadastroSITUACAO: TWideStringField;
    QryCadastroID: TFloatField;
    QryCadastroCLIENTE_ID: TFloatField;
    QryCadastroRAZAO_SOCIAL: TWideStringField;
    QryCadastroVALOR: TFloatField;
    QryCadastroCUPOM_ORIGINAL: TFloatField;
    QryCadastroDATA_EMISSAO: TDateTimeField;
    QryCadastroMOTIVO: TWideStringField;
    QryCadastroOBSERVACAO_MOVIMENTO: TWideStringField;
    CdsCadastroOBSERVACAO_MOVIMENTO: TWideStringField;
    UniPagePrincipal: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniLabel1: TUniLabel;
    UniDBEditNome: TUniDBEdit;
    ButtonPesquisaPessoa: TUniSpeedButton;
    UniLabel3: TUniLabel;
    UniDBEditValor: TUniDBEdit;
    UniDBEditCupomOriginal: TUniDBEdit;
    UniLabel2: TUniLabel;
    UniLabel7: TUniLabel;
    UniDBDateTimePickerEmissao: TUniDBDateTimePicker;
    UniLabel8: TUniLabel;
    UniDBEditSituacao: TUniDBEdit;
    UniDBMemoMotivo: TUniDBMemo;
    UniLabel5: TUniLabel;
    UniDBMemo1: TUniDBMemo;
    procedure ButtonPesquisaPessoaClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
  private
    IdCliente : Integer;
    function CupomJaUtilizado(NumCupom: String): Boolean;
   { Private declarations }
    function Novo: Boolean; override;
    function Salvar: Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Abrir(Id: Integer): Boolean; override;
    { Public declarations }
  end;

function ControleCadastroDescontosVales: TControleCadastroDescontosVales;

implementation

{$R *.dfm}

uses
  Controle.Main.Module,
  uniGUIApplication,
  Controle.Consulta.Modal.Pessoa,
  Controle.Funcoes,
  Controle.Consulta.DescontosVales;

function ControleCadastroDescontosVales: TControleCadastroDescontosVales;
begin
  Result := TControleCadastroDescontosVales(ControleMainModule.GetFormInstance(TControleCadastroDescontosVales));
end;

function TControleCadastroDescontosVales.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  CadastroId := Id;
  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;


  if CdsCadastroSITUACAO.AsString <> 'ATIVO' then
    BotaoEditar.Enabled :=False;

  Result := True;
end;

procedure TControleCadastroDescontosVales.ButtonPesquisaPessoaClick(
  Sender: TObject);
begin
  inherited;
  if (CdsCadastroSITUACAO.AsString = 'ATIVO')then
    begin
      // Abre o formulário em modal e aguarda
      ControleConsultaModalPessoa.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        if Result = 1 then
        begin
          // Pega o id da pessoa selecionada
          CdsCadastroCLIENTE_ID.AsInteger := ControleConsultaModalPessoa.CdsConsulta.FieldByName('id').AsInteger;
          UniDBEditNome.Text := ControleConsultaModalPessoa.CdsConsulta.FieldByName('razao_social').AsString;
        end;
      end);
    end
    else
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é permitido alterar um desconto/vale ATIVO.');
end;

function TControleCadastroDescontosVales.Editar(Id: Integer): Boolean;
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
  end;

  Result := True;
end;

function TControleCadastroDescontosVales.Novo(): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;
    CdsCadastroSITUACAO.AsString := 'ATIVO';
    CdsCadastroDATA_EMISSAO.Value := Date;
    Result := True;
  end;
end;


function TControleCadastroDescontosVales.Salvar: Boolean;
begin
  with ControleMainModule do
  begin
    if UniDBEditNome.Text = '' then
    begin
      MensageiroSweetAlerta('Atenção', 'Informe um cliente.');
      UniDBEditNome.SetFocus;
      Exit;
    end;

    if UniDBEditValor.Text = '' then
    begin
      MensageiroSweetAlerta('Atenção', 'Informe o valor do desconto.');
      UniDBEditValor.SetFocus;
      Exit;
    end;

    if UniDBEditCupomOriginal.Text = '' then
    begin
      MensageiroSweetAlerta('Atenção', 'Informe o numero do cupom que está gerando o desconto.');
      UniDBEditCupomOriginal.SetFocus;
      Exit;
    end;

    if UniDBMemoMotivo.Text = '' then
    begin
      MensageiroSweetAlerta('Atenção', 'É obrigatório informar um motivo');
      UniDBMemoMotivo.SetFocus;
      Exit;
    end;


    if CupomJaUtilizado(UniDBEditCupomOriginal.Text) then
    begin
     MensageiroSweetAlerta('Atenção', 'Este cupom já tem um desconto realizdo, não é possivel gerar um novo desconto.',atWarning);
     UniDBEditCupomOriginal.SetFocus;
     Exit;
    end
    else
    begin
      // Inicia a transação
      ADOConnection.BeginTrans;

      // Passo Unico - Salva os dados da cidade
      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;

      if CadastroId = 0 then
      begin
        // Gera um novo id para a tabela conta_bancaria
        CadastroId := GeraId('desconto_vale');
        // Insert
        QryAx1.SQL.Text :=
                         '	INSERT                    '
                        +'		INTO                    '
                        +'		CLIENTE_DESCONTO_VALE'
                        +'	(ID,                      '
                        +'		CLIENTE_ID,             '
                        +'		VALOR,                  '
                        +'		CUPOM_ORIGINAL,         '
                        +'		DATA_EMISSAO,           '
                        +'		MOTIVO,                 '
                        +'		SITUACAO)               '
                        +'	VALUES(                   '
                        +'    :ID,                    '
                        +'		:CLIENTE_ID,            '
                        +'		:VALOR,                 '
                        +'		:CUPOM_ORIGINAL,        '
                        +'		:DATA_EMISSAO,          '
                        +'		:MOTIVO,                '
                        +'		:SITUACAO)				      ';
      end
      else
      begin
        // Update
        QryAx1.SQL.Text :=
                           ' UPDATE CLIENTE_DESCONTO_VALE SET '
                          +'	      CLIENTE_ID    	=	:CLIENTE_ID,'
                          +'	      VALOR         	=	:VALOR,'
                          +'       	CUPOM_ORIGINAL	=	:CUPOM_ORIGINAL,'
                          +'       	DATA_EMISSAO  	=	:DATA_EMISSAO,'
                          +'       	MOTIVO        	=	:MOTIVO,'
                          +'       	SITUACAO	 	    =	:SITUACAO'
                          +' WHERE id               = :ID ';
      end;

      QryAx1.Parameters.ParamByName('CLIENTE_ID').Value       := CdsCadastroCLIENTE_ID.AsInteger;
      QryAx1.Parameters.ParamByName('VALOR').Value            := Trim(UniDBEditValor.Text);
      QryAx1.Parameters.ParamByName('CUPOM_ORIGINAL').Value   := Trim(UniDBEditCupomOriginal.Text);
      QryAx1.Parameters.ParamByName('DATA_EMISSAO').Value     := UniDBDateTimePickerEmissao.DateTime;
      QryAx1.Parameters.ParamByName('MOTIVO').Value           := Trim(UniDBMemoMotivo.Text);
      QryAx1.Parameters.ParamByName('SITUACAO').Value         := copy(Trim(UniDBEditSituacao.Text),1,1);
      QryAx1.Parameters.ParamByName('ID').Value               := CadastroId;

      try
        // Tenta salvar os dados
        QryAx1.ExecSQL;
      except
        on E: Exception do
        begin
          // Descarta a transação
          ADOConnection.RollbackTrans;
          MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
          Exit;
        end;
      end;

      // Confirma a transação
      ADOConnection.CommitTrans;
      BotaoSalvar.ModalResult := mrOk;
      Result := True;
    end
  end;
end;

procedure TControleCadastroDescontosVales.UniFormShow(Sender: TObject);
begin
  inherited;
  UniPagePrincipal.ActivePageIndex := 0;
end;

function TControleCadastroDescontosVales.CupomJaUtilizado(NumCupom : String):Boolean;
begin
  Result := False;
  if NumCupom = '0' then  //zero numero permitido duplicar caso o que não tenha informado um numero.
  else
  begin
    with ControleMainModule do
    begin
      // Carregando as permissões do usuário
      CdsAx3.Close;
      QryAx3.SQL.Clear;
      QryAx3.SQL.Text := 'SELECT CUPOM_ORIGINAL '
               +'           FROM CLIENTE_DESCONTO_VALE'
               +'          WHERE CUPOM_ORIGINAL  = :cupom_original';
      QryAx3.Parameters.ParamByName('cupom_original').Value := NumCupom;
      CdsAx3.Open;

      if CdsAx3.RecordCount >1 then
      begin
        Result := True;
      end;
    end;
  end;
end;

end.

