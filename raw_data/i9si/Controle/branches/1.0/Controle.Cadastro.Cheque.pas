unit Controle.Cadastro.Cheque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro,  ACBrBase,
  ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel, uniEdit, uniDBEdit, uniGroupBox, uniMultiItem,
  uniComboBox, uniDBComboBox, uniDBLookupComboBox, uniDateTimePicker,
  uniDBDateTimePicker, uniMemo, uniDBMemo, uniRadioGroup, uniDBRadioGroup,
  ACBrCMC7, ACBrLCB, uniSweetAlert, uniDBText;

type
  TControleCadastroCheque = class(TControleCadastro)
    UniGroupCliente: TUniGroupBox;
    LabelCpfCnpj: TUniLabel;
    DBEdtCpfCnpj: TUniDBEdit;
    LabelNomeRazao: TUniLabel;
    DBEdtNome: TUniDBEdit;
    UniLabel8: TUniLabel;
    UniDBEdit3: TUniDBEdit;
    DBEditNum: TUniDBEdit;
    UniLabel13: TUniLabel;
    UniDBEdit8: TUniDBEdit;
    UniLabel11: TUniLabel;
    UniDBEdit6: TUniDBEdit;
    UniLabel17: TUniLabel;
    UniDBEdit12: TUniDBEdit;
    UniLabel19: TUniLabel;
    UniDBEdit13: TUniDBEdit;
    UniLabel16: TUniLabel;
    DBEditCelular: TUniDBEdit;
    UniLabel9: TUniLabel;
    UniGroupBottom: TUniGroupBox;
    UniLabel1: TUniLabel;
    UniDBCHEQUE_CODIGO_CMC7: TUniDBEdit;
    UniLabel4: TUniLabel;
    UniDBCHEQUE_NUMERO: TUniDBEdit;
    UniLabel5: TUniLabel;
    UniDBCHEQUE_DIGITO: TUniDBEdit;
    UniLabel6: TUniLabel;
    UniDBCHEQUE_CONTA_CORRENTE: TUniDBEdit;
    UniLabel7: TUniLabel;
    UniDBCHEQUE_BANCO_ID: TUniDBLookupComboBox;
    UniLabel10: TUniLabel;
    UniDBCHEQUE_DATA_VENCIMENTO: TUniDBDateTimePicker;
    UniDBCHEQUE_DESTINO_ID: TUniDBLookupComboBox;
    UniLabel12: TUniLabel;
    UniLabel15: TUniLabel;
    UniDBCHEQUE_OBSERVACAO: TUniDBMemo;
    DscBancosFonte: TDataSource;
    CdsBancosFonte: TClientDataSet;
    DspBancosFonte: TDataSetProvider;
    QryBancosFonte: TADOQuery;
    UniPanelCentral: TUniPanel;
    UniDBRadioProprio: TUniDBRadioGroup;
    UniGroupCentral: TUniGroupBox;
    UniLabel2: TUniLabel;
    UniDBCPF_CNPJ_EMITENTE_CHEQUE: TUniDBEdit;
    UniLabel3: TUniLabel;
    UniDBCHEQUE_CLIENTE_EMITENTE: TUniDBEdit;
    BotaoGeraCPF: TUniSpeedButton;
    UniDBCHEQUE_DATA_CADASTRO: TUniDBDateTimePicker;
    UniLabel18: TUniLabel;
    UniLabel21: TUniLabel;
    UniDBCHEQUE_AGENCIA: TUniDBEdit;
    UniLabel22: TUniLabel;
    UniDBCHEQUE_CIDADE: TUniDBEdit;
    ButtonPesquisaCidadeGeral: TUniSpeedButton;
    UniLabel23: TUniLabel;
    UniDBCHEQUE_DATA_DEVOLUCAO: TUniDBDateTimePicker;
    CdsCadastroID: TFloatField;
    UniDBCHEQUE_DATA_DEPOSITO: TUniDBDateTimePicker;
    UniLabel24: TUniLabel;
    UniDBCHEQUE_MOTIVO_DEVOLUCAO: TUniDBComboBox;
    UniLabel14: TUniLabel;
    ACBrCMC7: TACBrCMC7;
    ACBrLCB: TACBrLCB;
    CdsBancosFonteID: TFloatField;
    CdsBancosFonteCODIGO: TWideStringField;
    CdsBancosFonteNOME: TWideStringField;
    UniDBEdit1: TUniDBEdit;
    DscChequeDestino: TDataSource;
    CdsChequeDestino: TClientDataSet;
    DspChequeDestino: TDataSetProvider;
    QryChequeDestino: TADOQuery;
    UniLabel20: TUniLabel;
    UniLabel25: TUniLabel;
    CdsChequeDestinoID: TFloatField;
    CdsChequeDestinoDESCRICAO: TWideStringField;
    QryCadastroID: TFloatField;
    QryCadastroCLIENTE_ID: TFloatField;
    QryCadastroCIDADE_ID: TFloatField;
    QryCadastroVENDEDOR_ID: TFloatField;
    QryCadastroDESTINO_ID: TFloatField;
    QryCadastroCLIENTE_EMITENTE_ID: TFloatField;
    QryCadastroLOTE_NUMERO: TWideStringField;
    QryCadastroDATA_CADASTRO: TDateTimeField;
    QryCadastroPROPRIO_CLIENTE: TWideStringField;
    QryCadastroNUMERO: TWideStringField;
    QryCadastroDIGITO: TWideStringField;
    QryCadastroCONTA_CORRENTE: TWideStringField;
    QryCadastroBANCO_ID: TFloatField;
    QryCadastroAGENCIA: TWideStringField;
    QryCadastroDATA_DEPOSITO: TDateTimeField;
    QryCadastroOBSERVACAO: TWideStringField;
    QryCadastroCODIGO_CMC7: TWideStringField;
    QryCadastroDATA_DEVOLUCAO: TDateTimeField;
    QryCadastroDATA_VENCIMENTO: TDateTimeField;
    QryCadastroMOTIVO_DEVOLUCAO: TWideStringField;
    QryCadastroATIVO: TWideStringField;
    QryCadastroOBSERVACAO_1: TWideStringField;
    QryCadastroPESSOA_ID: TFloatField;
    QryCadastroTIPO: TWideStringField;
    QryCadastroCLIENTE: TWideStringField;
    QryCadastroCPF_CNPJ: TWideStringField;
    QryCadastroSEXO: TWideStringField;
    QryCadastroGERAL_ENDERECO_ID: TFloatField;
    QryCadastroGERAL_LOGRADOURO: TWideStringField;
    QryCadastroGERAL_NUMERO: TWideStringField;
    QryCadastroGERAL_COMPLEMENTO: TWideStringField;
    QryCadastroGERAL_PONTO_REFERENCIA: TWideStringField;
    QryCadastroGERAL_CEP: TWideStringField;
    QryCadastroGERAL_BAIRRO: TWideStringField;
    QryCadastroGERAL_NOME_CONTATO: TWideStringField;
    QryCadastroGERAL_TELEFONE_1: TWideStringField;
    QryCadastroGERAL_TELEFONE_2: TWideStringField;
    QryCadastroGERAL_CELULAR: TWideStringField;
    QryCadastroGERAL_EMAIL: TWideStringField;
    QryCadastroGERAL_CIDADE_ID: TFloatField;
    QryCadastroGERAL_CIDADE: TWideStringField;
    QryCadastroCIDADE: TWideStringField;
    QryCadastroCLIENTE_EMITENTE: TWideStringField;
    QryCadastroCPF_CNPJ_EMITENTE_CHEQUE: TWideStringField;
    CdsCadastroCLIENTE_ID: TFloatField;
    CdsCadastroCIDADE_ID: TFloatField;
    CdsCadastroVENDEDOR_ID: TFloatField;
    CdsCadastroDESTINO_ID: TFloatField;
    CdsCadastroCLIENTE_EMITENTE_ID: TFloatField;
    CdsCadastroLOTE_NUMERO: TWideStringField;
    CdsCadastroDATA_CADASTRO: TDateTimeField;
    CdsCadastroPROPRIO_CLIENTE: TWideStringField;
    CdsCadastroNUMERO: TWideStringField;
    CdsCadastroDIGITO: TWideStringField;
    CdsCadastroCONTA_CORRENTE: TWideStringField;
    CdsCadastroBANCO_ID: TFloatField;
    CdsCadastroAGENCIA: TWideStringField;
    CdsCadastroDATA_DEPOSITO: TDateTimeField;
    CdsCadastroOBSERVACAO: TWideStringField;
    CdsCadastroCODIGO_CMC7: TWideStringField;
    CdsCadastroDATA_DEVOLUCAO: TDateTimeField;
    CdsCadastroDATA_VENCIMENTO: TDateTimeField;
    CdsCadastroMOTIVO_DEVOLUCAO: TWideStringField;
    CdsCadastroATIVO: TWideStringField;
    CdsCadastroOBSERVACAO_1: TWideStringField;
    CdsCadastroPESSOA_ID: TFloatField;
    CdsCadastroTIPO: TWideStringField;
    CdsCadastroCLIENTE: TWideStringField;
    CdsCadastroCPF_CNPJ: TWideStringField;
    CdsCadastroSEXO: TWideStringField;
    CdsCadastroGERAL_ENDERECO_ID: TFloatField;
    CdsCadastroGERAL_LOGRADOURO: TWideStringField;
    CdsCadastroGERAL_NUMERO: TWideStringField;
    CdsCadastroGERAL_COMPLEMENTO: TWideStringField;
    CdsCadastroGERAL_PONTO_REFERENCIA: TWideStringField;
    CdsCadastroGERAL_CEP: TWideStringField;
    CdsCadastroGERAL_BAIRRO: TWideStringField;
    CdsCadastroGERAL_NOME_CONTATO: TWideStringField;
    CdsCadastroGERAL_TELEFONE_1: TWideStringField;
    CdsCadastroGERAL_TELEFONE_2: TWideStringField;
    CdsCadastroGERAL_CELULAR: TWideStringField;
    CdsCadastroGERAL_EMAIL: TWideStringField;
    CdsCadastroGERAL_CIDADE_ID: TFloatField;
    CdsCadastroGERAL_CIDADE: TWideStringField;
    CdsCadastroCIDADE: TWideStringField;
    CdsCadastroCLIENTE_EMITENTE: TWideStringField;
    CdsCadastroCPF_CNPJ_EMITENTE_CHEQUE: TWideStringField;
    QryCadastroVALOR_CHEQUE: TFloatField;
    CdsCadastroVALOR_CHEQUE: TFloatField;
    UniSpeedButton1: TUniSpeedButton;
    UniDBNumberEdit1: TUniDBNumberEdit;
    QryCadastroSITUACAO: TWideStringField;
    CdsCadastroSITUACAO: TWideStringField;
    UniDBText1: TUniDBText;
    procedure UniLabel1Click(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniDBRadioProprioClick(Sender: TObject);
    procedure UniDBCHEQUE_CODIGO_CMC7Exit(Sender: TObject);
    procedure ButtonPesquisaCidadeGeralClick(Sender: TObject);
    procedure BotaoGeraCPFClick(Sender: TObject);
    procedure UniSpeedButton1Click(Sender: TObject);
  private
    procedure AlteraEstadoUniGroupCentral(Estado: Boolean);
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Novo(): Boolean; override;
  end;

function ControleCadastroCheque: TControleCadastroCheque;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Livre.Cheque.Imagem,
   Controle.Consulta.Modal.Cidade, Controle.Consulta.Modal.Pessoa.TituloReceber,
  Controle.Funcoes;

function ControleCadastroCheque: TControleCadastroCheque;
begin
  Result := TControleCadastroCheque(ControleMainModule.GetFormInstance(TControleCadastroCheque));
end;

procedure TControleCadastroCheque.UniDBCHEQUE_CODIGO_CMC7Exit(Sender: TObject);
begin
  inherited;
  if UniDBCHEQUE_CODIGO_CMC7.Text <> '' then
  begin
    // Validando o CMC7
    ACBrCMC7.CMC7 := UniDBCHEQUE_CODIGO_CMC7.Text;
     
    CdsCadastro.Edit;
    CdsCadastroBANCO_ID.AsString       := ACBrCMC7.Banco;
    CdsCadastroCONTA_CORRENTE.AsString := ACBrCMC7.Conta;
    CdsCadastroAGENCIA.AsString        := ACBrCMC7.Agencia;
    CdsCadastroNUMERO.AsString         := ACBrCMC7.Numero;
    CdsCadastroDIGITO.AsInteger        := ACBrCMC7.C2;
    CdsCadastro.Post;    
    CdsCadastro.Edit;    
  end;
end;

procedure TControleCadastroCheque.UniDBRadioProprioClick(Sender: TObject);
begin
  inherited;
  if UniDBRadioProprio.ItemIndex = 0 then
  begin
    AlteraEstadoUniGroupCentral(False);
    UniDbCPF_CNPJ_EMITENTE_CHEQUE.Datafield := 'CPF_CNPJ';
    UniDbCHEQUE_CLIENTE_EMITENTE.Datafield  := 'CLIENTE'
  end
  else if UniDBRadioProprio.ItemIndex = 1 then
  begin
    AlteraEstadoUniGroupCentral(True);
    UniDbCPF_CNPJ_EMITENTE_CHEQUE.Datafield := 'CPF_CNPJ_EMITENTE_CHEQUE';
    UniDbCHEQUE_CLIENTE_EMITENTE.Datafield  := 'CLIENTE_EMITENTE'
  end;
end;

procedure TControleCadastroCheque.UniFormShow(Sender: TObject);
begin
  inherited;
  CdsChequeDestino.Open;
  CdsBancosFonte.Open;

  if CdsCadastroPROPRIO_CLIENTE.AsString = 'S' then
  begin
    AlteraEstadoUniGroupCentral(False);
    UniDbCPF_CNPJ_EMITENTE_CHEQUE.Datafield := 'CPF_CNPJ';
    UniDbCHEQUE_CLIENTE_EMITENTE.Datafield  := 'CLIENTE'
  end
  else if CdsCadastroPROPRIO_CLIENTE.AsString = 'N' then
  begin
    AlteraEstadoUniGroupCentral(True);
    UniDbCPF_CNPJ_EMITENTE_CHEQUE.Datafield := 'CPF_CNPJ_EMITENTE_CHEQUE';
    UniDbCHEQUE_CLIENTE_EMITENTE.Datafield  := 'CLIENTE_EMITENTE'
  end;



  // Tentando ativar a leitora de cheques
{  Try
    ACBrLCB.Ativar;
  except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção',e.Message);
    end;
  End;}
end;

procedure TControleCadastroCheque.UniLabel1Click(Sender: TObject);
begin
  inherited;
  ControleLivreChequeImagem.Showmodal;
end;

procedure TControleCadastroCheque.UniSpeedButton1Click(Sender: TObject);
Var
  PessoaId: Integer;
begin
  inherited;
  PessoaId := 0;

  // Define o filtro fixo para a pesquisa (Tipo de Pessoa = F, J ou FJ)
  ControleConsultaModalPessoaTituloReceber.QryConsulta.Parameters.ParamByName('tipo').Value := 'FJ';
//  ControleConsultaModalPessoa.UniEditRazao.Text := UniEditResponsavelTitulo.Text;

  // Abre o formulário em modal e aguarda
  ControleConsultaModalPessoaTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      // Pega o id da pessoa selecionada
      CdsCadastroCLIENTE_ID.AsString        := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('id').AsString;
      CdsCadastroCPF_CNPJ.AsString          := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('cpf_cnpj').AsString;
      CdsCadastroCLIENTE.AsString           := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('razao_social').AsString;
      CdsCadastroGERAL_LOGRADOURO.AsString  := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('geral_logradouro').AsString;
      CdsCadastroGERAL_NUMERO.AsString      := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('geral_numero').AsString;
      CdsCadastroGERAL_CIDADE.AsString      := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('geral_cidade').AsString;
      CdsCadastroGERAL_TELEFONE_1.AsString  := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('geral_telefone_1').AsString;
      CdsCadastroGERAL_TELEFONE_2.AsString  := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('geral_telefone_2').AsString;
      CdsCadastroGERAL_CELULAR.AsString     := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('geral_celular').AsString;
    end;
  end);
end;

function TControleCadastroCheque.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  CdsCadastro.Params.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  Result := True;
end;

function TControleCadastroCheque.Novo(): Boolean;
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

function TControleCadastroCheque.Editar(Id: Integer): Boolean;
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

function TControleCadastroCheque.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      if Trim(UniDBcheque_data_vencimento.Text) = '30/12/1899' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a data de vencimento do cheque');
        UniDBcheque_data_vencimento.SetFocus;
        Exit;
      end;

{      if Trim(UniDBcheque_data_deposito.Text) = '30/12/1899' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a data de depósito do cheque');
        UniDBcheque_data_deposito.SetFocus;
        Exit;
      end;}

      if Trim(UniDBcheque_numero.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o número do cheque');
        UniDBcheque_numero.SetFocus;
        Exit;
      end;

      if Trim(UniDBcheque_digito.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o dígito');
        UniDBcheque_digito.SetFocus;
        Exit;
      end;

      if Trim(UniDBcheque_conta_corrente.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o número da conta corrente');
        UniDBcheque_conta_corrente.SetFocus;
        Exit;
      end;

      if Trim(UniDBcheque_banco_id.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o banco');
        UniDBcheque_banco_id.SetFocus;
        Exit;
      end;

      if Trim(UniDBcheque_agencia.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a agência');
        UniDBcheque_agencia.SetFocus;
        Exit;
      end;

      if Trim(UniDBcheque_cidade.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a cidade da agência');
        UniDBcheque_cidade.SetFocus;
        Exit;
      end;

{      if Trim(UniDBcheque_destino_id.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o destino do cheque');
        UniDBcheque_destino_id.SetFocus;
        Exit;
      end;}

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

    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      CadastroId := GeraId('cheque');
      // Insert
      QryAx1.SQL.Add('INSERT INTO cheque (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       situacao,');
      QryAx1.SQL.Add('       titulo_pagamento_id,');
      QryAx1.SQL.Add('       valor_cheque,');
      QryAx1.SQL.Add('       cliente_id,');
      QryAx1.SQL.Add('       lote_numero,');
      QryAx1.SQL.Add('       cliente_emitente_id,');
      QryAx1.SQL.Add('       data_vencimento,');
      QryAx1.SQL.Add('       proprio_cliente,');
      QryAx1.SQL.Add('       numero,');
      QryAx1.SQL.Add('       digito,');
      QryAx1.SQL.Add('       conta_corrente,');
      QryAx1.SQL.Add('       banco_id,');
      QryAx1.SQL.Add('       agencia,');
      QryAx1.SQL.Add('       cidade_id,');
      QryAx1.SQL.Add('       vendedor_id,');
      QryAx1.SQL.Add('       destino_id,');
      QryAx1.SQL.Add('       observacao,');
      QryAx1.SQL.Add('       codigo_cmc7,');
      QryAx1.SQL.Add('       motivo_devolucao)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       ''DEPOSITAR'',');
      QryAx1.SQL.Add('       ''0'',');
      QryAx1.SQL.Add('       :valor_cheque,');
      QryAx1.SQL.Add('       :cliente_id,');
      QryAx1.SQL.Add('       :lote_numero,');
      QryAx1.SQL.Add('       :cliente_emitente_id,');
      QryAx1.SQL.Add('       TO_DATE(''' + Trim(CdsCadastro.FieldByName('data_vencimento').AsString) + ''', ''dd/mm/yyyy''),');
      QryAx1.SQL.Add('       :proprio_cliente,');
      QryAx1.SQL.Add('       :numero,');
      QryAx1.SQL.Add('       :digito,');
      QryAx1.SQL.Add('       :conta_corrente,');
      QryAx1.SQL.Add('       :banco_id,');
      QryAx1.SQL.Add('       :agencia,');
      QryAx1.SQL.Add('       :cidade_id,');
      QryAx1.SQL.Add('       :vendedor_id,');
      QryAx1.SQL.Add('       :destino_id,');
      QryAx1.SQL.Add('       :observacao,');
      QryAx1.SQL.Add('       :codigo_cmc7,');
      QryAx1.SQL.Add('       :motivo_devolucao)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE cheque SET');
      QryAx1.SQL.Add('       cliente_id             = :cliente_id,');
      QryAx1.SQL.Add('       valor_cheque           = :valor_cheque,');
      QryAx1.SQL.Add('       lote_numero            = :lote_numero,');
      QryAx1.SQL.Add('       cliente_emitente_id    = :cliente_emitente_id,');
      QryAx1.SQL.Add('       data_vencimento        = TO_DATE(''' + Trim(CdsCadastro.FieldByName('data_vencimento').AsString) + ''', ''dd/mm/yyyy''),');
      QryAx1.SQL.Add('       proprio_cliente        = :proprio_cliente,');
      QryAx1.SQL.Add('       numero                 = :numero,');
      QryAx1.SQL.Add('       digito                 = :digito,');
      QryAx1.SQL.Add('       conta_corrente         = :conta_corrente,');
      QryAx1.SQL.Add('       banco_id               = :banco_id,');
      QryAx1.SQL.Add('       agencia                = :agencia,');
      QryAx1.SQL.Add('       cidade_id              = :cidade_id,');
      QryAx1.SQL.Add('       vendedor_id            = :vendedor_id,');
      QryAx1.SQL.Add('       data_deposito          = TO_DATE(''' + Trim(CdsCadastro.FieldByName('data_deposito').AsString) + ''', ''dd/mm/yyyy''),');
      QryAx1.SQL.Add('       destino_id             = :destino_id,');
      QryAx1.SQL.Add('       observacao             = :observacao,');
      QryAx1.SQL.Add('       codigo_cmc7            = :codigo_cmc7,');
      QryAx1.SQL.Add('       motivo_devolucao       = :motivo_devolucao,');
      QryAx1.SQL.Add('       data_devolucao         = TO_DATE(''' + Trim(CdsCadastro.FieldByName('data_devolucao').AsString) + ''', ''dd/mm/yyyy'')');
      QryAx1.SQL.Add(' WHERE id                     = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value                   := CadastroId;
    QryAx1.Parameters.ParamByName('cliente_id').Value           := CdsCadastro.FieldByName('cliente_id').AsString;
    QryAx1.Parameters.ParamByName('lote_numero').Value          := CdsCadastro.FieldByName('lote_numero').AsString;
    QryAx1.Parameters.ParamByName('cliente_emitente_id').Value  := CdsCadastro.FieldByName('cliente_emitente_id').AsString;
    QryAx1.Parameters.ParamByName('proprio_cliente').Value      := CdsCadastro.FieldByName('proprio_cliente').AsString;
    QryAx1.Parameters.ParamByName('numero').Value               := CdsCadastro.FieldByName('numero').AsString;
    QryAx1.Parameters.ParamByName('digito').Value               := CdsCadastro.FieldByName('digito').AsString;
    QryAx1.Parameters.ParamByName('conta_corrente').Value       := CdsCadastro.FieldByName('conta_corrente').AsString;
    QryAx1.Parameters.ParamByName('banco_id').Value             := CdsCadastro.FieldByName('banco_id').AsString;
    QryAx1.Parameters.ParamByName('agencia').Value              := CdsCadastro.FieldByName('agencia').AsString;
    QryAx1.Parameters.ParamByName('cidade_id').Value            := CdsCadastro.FieldByName('cidade_id').AsString;
    QryAx1.Parameters.ParamByName('vendedor_id').Value          := CdsCadastro.FieldByName('vendedor_id').AsString;
    QryAx1.Parameters.ParamByName('destino_id').Value           := CdsCadastro.FieldByName('destino_id').AsString;
    QryAx1.Parameters.ParamByName('observacao').Value           := CdsCadastro.FieldByName('observacao').AsString;
    QryAx1.Parameters.ParamByName('motivo_devolucao').Value     := CdsCadastro.FieldByName('motivo_devolucao').AsString;
    QryAx1.Parameters.ParamByName('codigo_cmc7').Value          := CdsCadastro.FieldByName('codigo_cmc7').AsString;
    QryAx1.Parameters.ParamByName('valor_cheque').Value         := CdsCadastro.FieldByName('valor_cheque').AsString;


    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção','Não foi possível salvar os dados alterados. ' + e.Message);
        CdsCadastro.Edit;
        Exit;
      end;
    end;

    // Confirma a transação
    ADOConnection.CommitTrans;
  end;
end;

procedure TControleCadastroCheque.AlteraEstadoUniGroupCentral(Estado: Boolean);
begin
  UniGroupCentral.Enabled := Estado;
end;

procedure TControleCadastroCheque.BotaoGeraCPFClick(Sender: TObject);
Var
  PessoaId: Integer;
begin
  inherited;
  PessoaId := 0;

  // Define o filtro fixo para a pesquisa (Tipo de Pessoa = F, J ou FJ)
  ControleConsultaModalPessoaTituloReceber.QryConsulta.Parameters.ParamByName('tipo').Value := 'FJ';
//  ControleConsultaModalPessoa.UniEditRazao.Text := UniEditResponsavelTitulo.Text;

  //leva a inormação para ignorar os campos obrigatório no formulário do cadastro de uma pessoa.
  ControleConsultaModalPessoaTituloReceber.IgnoraCamposDoCliente := 'S';

  // Abre o formulário em modal e aguarda
  ControleConsultaModalPessoaTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
{    if Result = 1 then
    begin}
      // Pega o id da pessoa selecionada
      CdsCadastrocliente_emitente_id.AsString       := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('id').AsString;
      CdsCadastroCPF_CNPJ_Emitente_Cheque.AsString  := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('cpf_cnpj').AsString;
      CdsCadastrocliente_emitente.AsString          := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('nome_fantasia').AsString;
//    end;
  end);
end;

procedure TControleCadastroCheque.ButtonPesquisaCidadeGeralClick(
  Sender: TObject);
begin
  inherited;

  // Abre o formulário em modal e aguarda
  ControleConsultaModalCidade.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      CdsCadastro.Edit;
      CdsCadastro['cidade_id'] := ControleConsultaModalCidade.CdsConsulta.FieldByName('id').AsInteger;
      UniDBCHEQUE_CIDADE.Text  := ControleConsultaModalCidade.CdsConsulta.FieldByName('nome').AsString +
        ' / ' + ControleConsultaModalCidade.CdsConsulta.FieldByName('uf').AsString;

      UniDBCHEQUE_OBSERVACAO.SetFocus;
    end
    else
    begin
      CdsCadastro['cidade_id'] := '';
      UniDBCHEQUE_CIDADE.Text  := '';
    end;
  end);
end;

end.
