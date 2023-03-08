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
  TEmitente = record
  id : Integer;
  CpfCnpj : string;
  nome : string;
end;


type
  TPessoa = record
    id               :Integer;
    cpf_cnpj         :String;
    razao_social     :String;
    geral_logradouro :String;
    geral_numero     :String;
    geral_cidade     :String;
    geral_telefone_1 :String;
    geral_telefone_2 :String;
    geral_celular	   :String;
end;

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
    UniDBCHEQUE_DESTINO_ID: TUniDBLookupComboBox;
    UniLabel12: TUniLabel;
    UniLabel15: TUniLabel;
    UniDBCHEQUE_OBSERVACAO: TUniDBMemo;
    DscBancosFonte: TDataSource;
    CdsBancosFonte: TClientDataSet;
    DspBancosFonte: TDataSetProvider;
    QryBancosFonte: TADOQuery;
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
    UniDBEditCodigoBanco: TUniDBEdit;
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
    QryCadastroSITUACAO: TWideStringField;
    CdsCadastroSITUACAO: TWideStringField;
    UniDBText1: TUniDBText;
    UniGroupCentral: TUniGroupBox;
    UniLabel2: TUniLabel;
    UniDBCPF_CNPJ_EMITENTE_CHEQUE: TUniDBEdit;
    UniLabel3: TUniLabel;
    UniDBCHEQUE_CLIENTE_EMITENTE: TUniDBEdit;
    UniDBRadioProprio: TUniDBRadioGroup;
    UniDBNumberEdit1: TUniDBFormattedNumberEdit;
    UniDBcheque_data_vencimento: TUniDBEdit;
    procedure UniLabel1Click(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniDBRadioProprioClick(Sender: TObject);
    procedure UniDBCHEQUE_CODIGO_CMC7Exit(Sender: TObject);
    procedure ButtonPesquisaCidadeGeralClick(Sender: TObject);
    procedure BotaoGeraCPFClick(Sender: TObject);
    procedure UniSpeedButton1Click(Sender: TObject);
    procedure UniDBCPF_CNPJ_EMITENTE_CHEQUEChange(Sender: TObject);
    procedure DBEdtCpfCnpjChange(Sender: TObject);
    procedure UniDBCHEQUE_CODIGO_CMC7Change(Sender: TObject);
  private
    Emitente : TEmitente;
    PessoaCliente : TPessoa;
    procedure AlteraEstadoUniGroupCentral(Estado: Boolean);
    function ProcuraEmitente(Cpf: string; nome: string;ID: string = ''): TEmitente;
    function ProcuraCliente(CpfCnpj: string): TPessoa;
    function ProcuraConta(Banco: string; Agencia: string; Conta: string; Digito: string): String;
    function TiraZerosEsq(conteudo: string): string;
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Novo(): Boolean; override;
    function Descartar: Boolean; override;
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

procedure TControleCadastroCheque.UniDBCHEQUE_CODIGO_CMC7Change(
  Sender: TObject);
begin
  inherited;
  if UniDBRadioProprio.ItemIndex <> 0 then
  begin
    CdsCadastrocliente_emitente_id.AsInteger      := 0;
    CdsCadastroCPF_CNPJ_Emitente_Cheque.AsString  := '';
    CdsCadastrocliente_emitente.AsString          := '';
  end;
end;

procedure TControleCadastroCheque.UniDBCHEQUE_CODIGO_CMC7Exit(Sender: TObject);
var
  CodigoDigitado : string;
begin
  inherited;
  CodigoDigitado := UniDBCHEQUE_CODIGO_CMC7.Text;

  if CodigoDigitado <> '' then
  begin
    if Copy(CodigoDigitado,1,1) <> '<' then
    begin
     CodigoDigitado := '<'+ Copy(CodigoDigitado,1,8) + '<' + Copy(CodigoDigitado,9,10)+'>'+Copy(CodigoDigitado,19,12)+':';
    end;

    // Validando o CMC7
    ACBrCMC7.CMC7 := CodigoDigitado;
     
    CdsCadastro.Edit;
    CdsCadastroBANCO_ID.AsString       := ACBrCMC7.Banco;
    CdsCadastroCONTA_CORRENTE.AsString := ACBrCMC7.Conta;
    CdsCadastroAGENCIA.AsString        := ACBrCMC7.Agencia;
    CdsCadastroNUMERO.AsString         := ACBrCMC7.Numero;
    CdsCadastroDIGITO.AsInteger        := ACBrCMC7.C2;
    CdsCadastro.Post;    
    CdsCadastro.Edit;    
  end;

  if CdsCadastroPROPRIO_CLIENTE.AsString = 'N' then
  begin
   //procura o emitente
   Emitente := ProcuraEmitente('','',(ProcuraConta(CdsCadastroBANCO_ID.AsString, //procura o id do emitente pelos dados bancarios
                                                  CdsCadastroAGENCIA.AsString,
                                                  CdsCadastroCONTA_CORRENTE.AsString,
                                                  CdsCadastroDIGITO.AsString)
                                      )
                              );

    if Emitente.id <> 0 then
    begin
      if Emitente.id = CdsCadastroCLIENTE_ID.AsInteger then
      begin
        CdsCadastroPROPRIO_CLIENTE.AsString := 'S';
        CdsCadastro.Post;
        CdsCadastro.Edit;
      end;

      CdsCadastrocliente_emitente_id.AsInteger      := Emitente.id;
      CdsCadastroCPF_CNPJ_Emitente_Cheque.AsString  := Emitente.CpfCnpj;
      CdsCadastrocliente_emitente.AsString          := Emitente.nome
    end;
  end;
end;

function TControleCadastroCheque.TiraZerosEsq(conteudo: string): string;
var
  i: integer;
begin
  for i := 0 to length(conteudo) do
    if (conteudo[i] <> '0') and (conteudo[i] <> #0) then
      break;
  result := copy(conteudo, i, length(conteudo));
end;


procedure TControleCadastroCheque.UniDBCPF_CNPJ_EMITENTE_CHEQUEChange(
  Sender: TObject);
var
  CpfCnpjDigitado : string;
begin
  CdsCadastroCLIENTE_EMITENTE_ID.AsInteger := 0;
  CdsCadastroCLIENTE_EMITENTE.AsString := '';

  CpfCnpjDigitado := ControleFuncoes.RemoveMascara(Trim(UniDBCPF_CNPJ_EMITENTE_CHEQUE .Text));

  if Length(CpfCnpjDigitado)=11 then
  begin
    Emitente:= ProcuraEmitente(CpfCnpjDigitado,UniDBCHEQUE_CLIENTE_EMITENTE.Text);

   if Emitente.id <> 0 then
   begin
    CdsCadastrocliente_emitente_id.AsInteger      := Emitente.id;
    CdsCadastroCPF_CNPJ_Emitente_Cheque.AsString  := Emitente.CpfCnpj;
    CdsCadastrocliente_emitente.AsString          := Emitente.nome
   end;
  end
  else if Length(CpfCnpjDigitado)=14 then
  begin
    Emitente:= ProcuraEmitente(CpfCnpjDigitado,UniDBCHEQUE_CLIENTE_EMITENTE.Text);

   if Emitente.id <> 0 then
   begin
    CdsCadastrocliente_emitente_id.AsInteger      := Emitente.id;
    CdsCadastroCPF_CNPJ_Emitente_Cheque.AsString  := Emitente.CpfCnpj;
    CdsCadastrocliente_emitente.AsString          := Emitente.nome
   end;
  end;
end;

procedure TControleCadastroCheque.UniDBRadioProprioClick(Sender: TObject);
begin
  inherited;
  if UniDBRadioProprio.ItemIndex = 0 then
  begin
    Emitente.id := CdsCadastroCLIENTE_ID.AsInteger;
    CdsCadastroCLIENTE_EMITENTE_ID.AsInteger := CdsCadastroCLIENTE_ID.AsInteger;
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
begin
  inherited;
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

    // Inicia emissão como
    CdsCadastroPROPRIO_CLIENTE.AsString := 'N';

    UniDBCHEQUE_DATA_DEPOSITO.Enabled :=False;
    UniDBCHEQUE_DATA_DEVOLUCAO.Enabled := False;
    UniDBCHEQUE_DESTINO_ID.Enabled := False;
    UniDBCHEQUE_DATA_CADASTRO.Enabled := False;
    UniDBCHEQUE_MOTIVO_DEVOLUCAO.Enabled := False;


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
var
  CpfCnpjEmitente,
  TipoOperacao : string;

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

      //O emitente não é um cliente, fica gravado somente na pessoa
      if CdsCadastroCLIENTE_EMITENTE_ID.AsInteger = 0 then
      begin
        with ControleMainModule do
        begin
          Emitente.id := GeraId('pessoa');
          CdsCadastroCLIENTE_EMITENTE_ID.AsInteger := Emitente.id;

          // Passo 1 - Salva os dados da pessoa
          QryAx2.Parameters.Clear;
          QryAx2.SQL.Clear;

          // Insert
          QryAx2.SQL.Add('INSERT INTO pessoa (');
          QryAx2.SQL.Add('       id,');
          QryAx2.SQL.Add('       tipo,');
          QryAx2.SQL.Add('       razao_social,');
          QryAx2.SQL.Add('       nome_fantasia,');
          QryAx2.SQL.Add('       cpf_cnpj)');
          QryAx2.SQL.Add('VALUES (');
          QryAx2.SQL.Add('       :id,');
          QryAx2.SQL.Add('       :tipo,');
          QryAx2.SQL.Add('       :razao_social,');
          QryAx2.SQL.Add('       :nome_fantasia,');
          QryAx2.SQL.Add('       :cpf_cnpj)');

          QryAx2.Parameters.ParamByName('id').Value := CdsCadastroCLIENTE_EMITENTE_ID.AsString;

          CpfCnpjEmitente := Trim(ControleFuncoes.RemoveMascara(UniDBCPF_CNPJ_EMITENTE_CHEQUE.Text));

          if Length(CpfCnpjEmitente) = 11 then
            QryAx2.Parameters.ParamByName('tipo').Value             := 'F'
          else
            QryAx2.Parameters.ParamByName('tipo').Value             := 'J';

          QryAx2.Parameters.ParamByName('razao_social').Value       := UniDBCHEQUE_CLIENTE_EMITENTE.Text;
          QryAx2.Parameters.ParamByName('nome_fantasia').Value      := UniDBCHEQUE_CLIENTE_EMITENTE.Text;
          QryAx2.Parameters.ParamByName('cpf_cnpj').Value           := CpfCnpjEmitente;

          try
            // Tenta salvar os dados
            QryAx2.ExecSQL;
          except
            on E: Exception do
            begin
              ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
            end;
          end;
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

      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;

      if CadastroId = 0 then
      begin
        TipoOperacao := 'Insert';
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
      QryAx1.Parameters.ParamByName('valor_cheque').Value         := StringReplace(CdsCadastro.FieldByName('valor_cheque').AsString,',','.',[]);;

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


    end;

    try
      // Confirma a transação
      ADOConnection.CommitTrans;

      if TipoOperacao = 'Insert' then
        ControleMainModule.MensageiroSweetAlerta('Incluído!','Cheque incluído com sucesso. Nº '+ IntToStr(CadastroId),atSuccess )
      else
        ControleMainModule.MensageiroSweetAlerta('Atualizado!','Cheque atualizado com sucesso. Nº '+ IntToStr(CadastroId),atSuccess );

      Close;
    except
      on E: Exception do
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
    end;
  end;
end;

procedure TControleCadastroCheque.AlteraEstadoUniGroupCentral(Estado: Boolean);
begin
  UniGroupCentral.Enabled := Estado;
end;

procedure TControleCadastroCheque.BotaoGeraCPFClick(Sender: TObject);
begin
  inherited;
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


procedure TControleCadastroCheque.DBEdtCpfCnpjChange(Sender: TObject);
var
  CpfCnpjDigitado : string;
begin
  //LIMPA OS CAMPOS
  CdsCadastroCLIENTE_ID.AsInteger       := 0;
  CdsCadastroCLIENTE.AsString           := '';
  CdsCadastroGERAL_LOGRADOURO.AsString  := '';
  CdsCadastroGERAL_NUMERO.AsString      := '';
  CdsCadastroGERAL_CIDADE.AsString      := '';
  CdsCadastroGERAL_TELEFONE_1.AsString  := '';
  CdsCadastroGERAL_TELEFONE_2.AsString  := '';
  CdsCadastroGERAL_CELULAR.AsString     := '';

  CpfCnpjDigitado := ControleFuncoes.RemoveMascara(Trim(DBEdtCpfCnpj.Text));

  if Length(CpfCnpjDigitado)=11 then
  begin
    ProcuraCliente(CpfCnpjDigitado);

    if PessoaCliente.id <> 0 then
    begin
      CdsCadastroCLIENTE_ID.AsInteger       := PessoaCliente.id;
      CdsCadastroCPF_CNPJ.AsString          := PessoaCliente.cpf_cnpj;
      CdsCadastroCLIENTE.AsString           := PessoaCliente.razao_social;
      CdsCadastroGERAL_LOGRADOURO.AsString  := PessoaCliente.geral_logradouro;
      CdsCadastroGERAL_NUMERO.AsString      := PessoaCliente.geral_numero;
      CdsCadastroGERAL_CIDADE.AsString      := PessoaCliente.geral_cidade;
      CdsCadastroGERAL_TELEFONE_1.AsString  := PessoaCliente.geral_telefone_1;
      CdsCadastroGERAL_TELEFONE_2.AsString  := PessoaCliente.geral_telefone_2;
      CdsCadastroGERAL_CELULAR.AsString     := PessoaCliente.geral_celular;
    end;
  end
  else if Length(CpfCnpjDigitado)=14 then
  begin
    ProcuraCliente(CpfCnpjDigitado);

    if PessoaCliente.id <> 0 then
    begin
      CdsCadastroCLIENTE_ID.AsInteger       := PessoaCliente.id;
      CdsCadastroCPF_CNPJ.AsString          := PessoaCliente.cpf_cnpj;
      CdsCadastroCLIENTE.AsString           := PessoaCliente.razao_social;
      CdsCadastroGERAL_LOGRADOURO.AsString  := PessoaCliente.geral_logradouro;
      CdsCadastroGERAL_NUMERO.AsString      := PessoaCliente.geral_numero;
      CdsCadastroGERAL_CIDADE.AsString      := PessoaCliente.geral_cidade;
      CdsCadastroGERAL_TELEFONE_1.AsString  := PessoaCliente.geral_telefone_1;
      CdsCadastroGERAL_TELEFONE_2.AsString  := PessoaCliente.geral_telefone_2;
      CdsCadastroGERAL_CELULAR.AsString     := PessoaCliente.geral_celular;
    end;
  end;
end;

function TControleCadastroCheque.ProcuraEmitente(Cpf: string; nome: string;ID: string = ''): TEmitente;
begin
  // Carregando as permissões do usuário
  with ControleMainModule do
  begin
    CdsAx4.Close;
    QryAx4.SQL.Clear;
    QryAx4.Parameters.Clear;
    QryAx4.SQL.Text :=
                     '  SELECT            			 		'
                    +'    ID,                       '
                    +'    TIPO,                     '
                    +'    RAZAO_SOCIAL,             '
                    +'    NOME_FANTASIA,            '
                    +'    (SELECT formata_cpf_cnpj(CPF_CNPJ) FROM dual) CPF_CNPJ,                    '
                    +'    RG_INSC_ESTADUAL,         '
                    +'    INSC_SUBSTITUICAO,        '
                    +'    INSC_MUNICIPAL,           '
                    +'    DATA_EXPEDICAO_RG,        '
                    +'    ORGAO_EXPEDIDOR_RG,       '
                    +'    DATA_NASCIMENTO,          '
                    +'    SEXO,                     '
                    +'    NOME_MAE,                 '
                    +'    NOME_PAI,                 '
                    +'    DATA_ABERTURA_EMPRESA,    '
                    +'    TIPO_EMPRESA,             '
                    +'    CODIGO_REGIME_TRIBUTARIO  '
                    +'  FROM                        '
                    +'    PESSOA                    '
                    +'    WHERE                     '
                    +'    CPF_CNPJ = :CPF_CNPJ'
                    +'    OR RAZAO_SOCIAL = :RAZAO_SOCIAL'
                    +'    OR ID = :ID';

    QryAx4.Parameters.ParamByName('CPF_CNPJ').Value       := Cpf;
    QryAx4.Parameters.ParamByName('RAZAO_SOCIAL').Value   := nome;
    QryAx4.Parameters.ParamByName('ID').Value             := ID;
    CdsAx4.Open;

    if CdsAx4.RecordCount >0 then
    begin
      Emitente.id       := CdsAx4.FieldByName('id').AsInteger;
      Emitente.CpfCnpj  := CdsAx4.FieldByName('CPF_CNPJ').AsString;
      Emitente.nome     := CdsAx4.FieldByName('RAZAO_SOCIAL').AsString;
    end
    else
    begin
      Emitente.id :=0;
      Emitente.CpfCnpj :='';
      Emitente.nome :='';
    end;

    Result := Emitente;
  end;
end;

function TControleCadastroCheque.ProcuraCliente(CpfCnpj: string): TPessoa;
begin
  // Carregando as permissões do usuário
  with ControleMainModule do
  begin
    CdsAx4.Close;
    QryAx4.SQL.Clear;
    QryAx4.Parameters.Clear;
    QryAx4.SQL.Text :=
                     '	 SELECT cli.id,																		                                  '
                    +'       DECODE(cli.ativo, ''S'', ''SIM'', ''NÃO'') ativo,                              '
                    +'       cli.observacao,                                                                '
                    +'       pes.id pessoa_id,                                                              '
                    +'       DECODE(pes.tipo, ''F'', ''FÍSICA'', ''J'', ''JURÍDICA'') tipo,                 '
                    +'       pes.razao_social,                                                              '
                    +'       pes.nome_fantasia,                                                             '
                    +'       (SELECT formata_cpf_cnpj(pes.cpf_cnpj) FROM dual) cpf_cnpj,                    '
                    +'       pes.rg_insc_estadual,                                                          '
                    +'       pes.data_expedicao_rg,                                                         '
                    +'       pes.orgao_expedidor_rg,                                                        '
                    +'       pes.data_nascimento,                                                           '
                    +'       DECODE(pes.sexo, ''M'', ''MASCULINO'', ''F'', ''FEMININO'') sexo,              '
                    +'       penge.id geral_endereco_id,                                                    '
                    +'       penge.logradouro geral_logradouro,                                             '
                    +'       penge.numero geral_numero,                                                     '
                    +'       penge.complemento geral_complemento,                                           '
                    +'       penge.ponto_referencia geral_ponto_referencia,                                 '
                    +'       penge.cep geral_cep,                                                           '
                    +'       penge.bairro geral_bairro,                                                     '
                    +'       penge.nome_contato geral_nome_contato,                                         '
                    +'       penge.telefone_1 geral_telefone_1,                                             '
                    +'       penge.telefone_2 geral_telefone_2,                                             '
                    +'       penge.celular geral_celular,                                                   '
                    +'       penge.email geral_email,                                                       '
                    +'       cidge.id geral_cidade_id,                                                      '
                    +'       cidge.nome || NVL2(estge.uf, '' / '' || estge.uf, '''') geral_cidade,          '
                    +'       penco.id comercial_endereco_id,                                                '
                    +'       penco.logradouro comercial_logradouro,                                         '
                    +'       penco.numero comercial_numero,                                                 '
                    +'       penco.complemento comercial_complemento,                                       '
                    +'       penco.ponto_referencia comercial_ponto_referencia,                             '
                    +'       penco.cep comercial_cep,                                                       '
                    +'       penco.bairro comercial_bairro,                                                 '
                    +'       penco.nome_contato comercial_nome_contato,                                     '
                    +'       penco.telefone_1 comercial_telefone_1,                                         '
                    +'       penco.telefone_2 comercial_telefone_2,                                         '
                    +'       penco.celular comercial_celular,                                               '
                    +'       penco.email comercial_email,                                                   '
                    +'       cidco.id comercial_cidade_id,                                                  '
                    +'       cidco.nome || NVL2(estco.uf, '' / '' || estco.uf, '''') comercial_cidade,      '
                    +'       pencb.id cobranca_endereco_id,                                                 '
                    +'       pencb.logradouro cobranca_logradouro,                                          '
                    +'       pencb.numero cobranca_numero,                                                  '
                    +'       pencb.complemento cobranca_complemento,                                        '
                    +'       pencb.ponto_referencia cobranca_ponto_referencia,                              '
                    +'       pencb.cep cobranca_cep,                                                        '
                    +'       pencb.bairro cobranca_bairro,                                                  '
                    +'       pencb.nome_contato cobranca_nome_contato,                                      '
                    +'       pencb.telefone_1 cobranca_telefone_1,                                          '
                    +'       pencb.telefone_2 cobranca_telefone_2,                                          '
                    +'       pencb.celular cobranca_celular,                                                '
                    +'       pencb.email cobranca_email,                                                    '
                    +'       cidcb.id cobranca_cidade_id,                                                   '
                    +'       cidcb.nome || NVL2(estcb.uf, '' / '' || estcb.uf, '''') cobranca_cidade,       '
                    +'       DECODE(pes.codigo_regime_tributario,                                           '
                    +'       ''0'', ''0 - NÃO SELECIONADO'',                                                '
                    +'       ''1'', ''1 – SIMPLES NACIONAL'',                                               '
                    +'       ''3'', ''3 – REGIME NORMAL'') codigo_regime_tributario,                        '
                    +'       cli.foto_caminho,                                                              '
                    +'       cli.assinatura_caminho,                                                        '
                    +'       cli.limite_credito,                                                            '
                    +'       cda.ID dados_adicionais_id,                                                    '
                    +'       cda.NOME_MAE,                                                                  '
                    +'       cda.NOME_PAI,                                                                  '
                    +'       cda.NOME_OUTRAS_PESSOAS,                                                       '
                    +'       cda.CELULAR_MAE,                                                               '
                    +'       cda.CELULAR_PAI,                                                               '
                    +'       cda.CELULAR_OUTRAS_PESSOAS                                                     '
                    +'  FROM pessoa pes                                                                     '
                    +'  INNER JOIN cliente cli                                                              '
                    +'    ON cli.id = pes.id                                                                '
                    +'  LEFT OUTER JOIN CLIENTE_DADOS_ADICIONAIS cda                                        '
                    +'    ON cda.CLIENTE_ID = cli.id                                                        '
                    +' LEFT OUTER JOIN pessoa_endereco penge                                                '
                    +'    ON penge.pessoa_id = pes.id                                                       '
                    +'   AND penge.tipo = ''GE''                                                            '
                    +'  LEFT OUTER JOIN fonte.cidade cidge                                                  '
                    +'    ON cidge.id = penge.cidade_id                                                     '
                    +'  LEFT OUTER JOIN fonte.estado estge                                                  '
                    +'    ON estge.id = cidge.estado_id                                                     '
                    +'  LEFT OUTER JOIN pessoa_endereco penco                                               '
                    +'    ON penco.pessoa_id = pes.id                                                       '
                    +'   AND penco.tipo = ''CO''                                                            '
                    +'  LEFT OUTER JOIN fonte.cidade cidco                                                  '
                    +'    ON cidco.id = penco.cidade_id                                                     '
                    +'  LEFT OUTER JOIN fonte.estado estco                                                  '
                    +'    ON estco.id = cidco.estado_id                                                     '
                    +'  LEFT OUTER JOIN pessoa_endereco pencb                                               '
                    +'    ON pencb.pessoa_id = pes.id                                                       '
                    +'   AND pencb.tipo = ''CB''                                                            '
                    +'  LEFT OUTER JOIN fonte.cidade cidcb                                                  '
                    +'    ON cidcb.id = pencb.cidade_id                                                     '
                    +'  LEFT OUTER JOIN fonte.estado estcb                                                  '
                    +'    ON estcb.id = cidcb.estado_id                                                     '
                    +'    WHERE                     '
                    +'    pes.CPF_CNPJ = :CPF_CNPJ';

    QryAx4.Parameters.ParamByName('CPF_CNPJ').Value := CpfCnpj;
    CdsAx4.Open;

    if CdsAx4.RecordCount >0 then
    begin
  	 PessoaCliente.id                 := CdsAx4.FieldByName('id').AsInteger;
     PessoaCliente.cpf_cnpj           := CdsAx4.FieldByName('cpf_cnpj').AsString;
     PessoaCliente.razao_social       := CdsAx4.FieldByName('razao_social').AsString;
     PessoaCliente.geral_logradouro   := CdsAx4.FieldByName('geral_logradouro').AsString;
     PessoaCliente.geral_numero       := CdsAx4.FieldByName('geral_numero').AsString;
     PessoaCliente.geral_cidade       := CdsAx4.FieldByName('geral_cidade').AsString;
     PessoaCliente.geral_telefone_1   := CdsAx4.FieldByName('geral_telefone_1').AsString;
     PessoaCliente.geral_telefone_2   := CdsAx4.FieldByName('geral_telefone_2').AsString;
     PessoaCliente.geral_celular      := CdsAx4.FieldByName('geral_celular').AsString;

     Result := PessoaCliente;
    end
    else
    begin
      PessoaCliente.id  :=0;
      Result            := PessoaCliente;
    end;
  end;
end;

function TControleCadastroCheque.ProcuraConta(Banco: string;
                                              Agencia :string;
                                              Conta: string;
                                              Digito: string):String;
begin
  Result := '0';

  with ControleMainModule do
  begin
    CdsAx2.Close;
    QryAx2.Parameters.Clear;
    QryAx2.SQL.Clear;
    QryAx2.SQL.Add('SELECT c.cliente_emitente_id');
    QryAx2.SQL.Add('  FROM');
    QryAx2.SQL.Add('  cheque c');
    QryAx2.SQL.Add('  INNER JOIN fonte.bancos b ON c.banco_id = b.codigo');
    QryAx2.SQL.Add(' WHERE b.codigo = :banco');
    QryAx2.SQL.Add(' AND c.agencia = :agencia');
    QryAx2.SQL.Add(' AND c.conta_corrente = :conta_corrente');
    QryAx2.SQL.Add(' AND c.digito = :digito');
    QryAx2.SQL.Add(' AND ROWNUM = 1');

    QryAx2.Parameters.ParamByName('banco').Value          := Banco;
    QryAx2.Parameters.ParamByName('agencia').Value        := Agencia;
    QryAx2.Parameters.ParamByName('conta_corrente').Value := Conta;
    QryAx2.Parameters.ParamByName('digito').Value         := Digito;
    CdsAx2.Open;

    if CdsAx2.RecordCount >0 then
    begin
      Result := CdsAx2.FieldByName('cliente_emitente_id').AsString;
    end;
  end;
end;

function TControleCadastroCheque.Descartar: Boolean;
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
