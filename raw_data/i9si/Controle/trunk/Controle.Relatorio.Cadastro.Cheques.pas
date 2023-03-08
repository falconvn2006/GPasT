unit Controle.Relatorio.Cadastro.Cheques;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Relatorio.Cadastro, uniGUIBaseClasses,
  uniImageList, Data.DB, Datasnap.Provider, Data.Win.ADODB, Datasnap.DBClient,
  uniButton, uniLabel, uniPanel, uniScrollBox, uniGroupBox, uniBitBtn, uniEdit,
  uniCheckBox, uniRadioGroup, uniMultiItem, uniComboBox, frxClass, frxDBSet;

type
  TControleRelatorioCadastroCheques = class(TControleRelatorioCadastro)
    uniRadioGroup: TUniRadioGroup;
    UniPanelPessoa: TUniPanel;
    UniLabel2: TUniLabel;
    EditCliente: TUniEdit;
    BtPesquisaCliente: TUniBitBtn;
    CboxData: TUniComboBox;
    CboxSituacao: TUniComboBox;
    UniEditDataFim: TUniEdit;
    LabelDataFinal: TUniLabel;
    LabelDataInicial: TUniLabel;
    UniEditDataInicio: TUniEdit;
    UniLabel3: TUniLabel;
    UniEditNumeroCheque: TUniEdit;
    Conexao: TfrxDBDataset;
    Relatorio: TfrxReport;
    CdsConsultaID: TFloatField;
    CdsConsultaCLIENTE_ID: TFloatField;
    CdsConsultaCLIENTE: TWideStringField;
    CdsConsultaLOTE_NUMERO: TWideStringField;
    CdsConsultaCLIENTE_EMITENTE_ID: TFloatField;
    CdsConsultaEMITENTE: TWideStringField;
    CdsConsultaDATA_CADASTRO: TDateTimeField;
    CdsConsultaPROPRIO_CLIENTE: TWideStringField;
    CdsConsultaNUMERO: TWideStringField;
    CdsConsultaDIGITO: TWideStringField;
    CdsConsultaCONTA_CORRENTE: TWideStringField;
    CdsConsultaBANCO_ID: TFloatField;
    CdsConsultaAGENCIA: TWideStringField;
    CdsConsultaCIDADE_ID: TFloatField;
    CdsConsultaVENDEDOR_ID: TFloatField;
    CdsConsultaDATA_DEPOSITO: TDateTimeField;
    CdsConsultaDESTINO_ID: TFloatField;
    CdsConsultaDESCRICAO_DESTINO: TWideStringField;
    CdsConsultaOBSERVACAO: TWideStringField;
    CdsConsultaCODIGO_CMC7: TWideStringField;
    CdsConsultaDATA_DEVOLUCAO: TDateTimeField;
    CdsConsultaDATA_VENCIMENTO: TDateTimeField;
    CdsConsultaMOTIVO_DEVOLUCAO: TWideStringField;
    CdsConsultaSITUACAO: TWideStringField;
    CdsConsultaTITULO_PAGAMENTO_ID: TFloatField;
    CdsConsultaVALOR_CHEQUE: TFloatField;
    CdsConsultaMARCADO_PARA_DEPOSITAR: TWideStringField;
    CdsConsultaDADOS_BANCARIOS: TWideStringField;
    CdsConsultaCPF_CNPJ_EMITENTE: TWideStringField;
    procedure uniRadioGroupClick(Sender: TObject);
    procedure CboxDataChange(Sender: TObject);
    procedure UniFrameCreate(Sender: TObject);
    procedure BtPesquisaClienteClick(Sender: TObject);
    procedure BtImprimirClick(Sender: TObject);
    procedure uniRadioGroupChangeValue(Sender: TObject);
  private
    TipoPessoa : string;
    TipoData : string;
    IdCliente,
    IdEmitente : string;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  System.DateUtils, Controle.Main.Module,Controle.Consulta.Modal.Pessoa.TituloReceber,Controle.Consulta.Modal.Pessoa;

{$R *.dfm}



procedure TControleRelatorioCadastroCheques.BtImprimirClick(Sender: TObject);
var
  Sql :string;
begin
  inherited;
  CdsConsulta.Close;
  QryConsulta.SQL.Clear;
  Sql :=
       '	SELECT										              '
      +'		ch.ID,                                '
      +'		ch.CLIENTE_ID,                        '
      +'		p.RAZAO_SOCIAL CLIENTE,               '
      +'		ch.LOTE_NUMERO,                       '
      +'		ch.CLIENTE_EMITENTE_ID,               '
      +'		pe.RAZAO_SOCIAL EMITENTE,             '
      +'    (SELECT formata_cpf_cnpj( pe.CPF_CNPJ) FROM dual)as CPF_CNPJ_EMITENTE,'
      +'		ch.DATA_CADASTRO,                     '
      +'		ch.PROPRIO_CLIENTE,                   '
      +'		ch.NUMERO,                            '
      +'    ''Banco ''||ch.BANCO_ID||'' AG ''||ch.AGENCIA ||'' CC '' ||ch.CONTA_CORRENTE ||''-'' ||ch.DIGITO DADOS_BANCARIOS,'
      +'		ch.DIGITO,                            '
      +'		ch.CONTA_CORRENTE,                    '
      +'		ch.BANCO_ID,                          '
      +'		ch.AGENCIA,                           '
      +'		ch.CIDADE_ID,                         '
      +'		ch.VENDEDOR_ID,                       '
      +'		ch.DATA_DEPOSITO,                     '
      +'		ch.DESTINO_ID,                        '
      +'		cd.DESCRICAO DESCRICAO_DESTINO,       '
      +'		ch.OBSERVACAO,                        '
      +'		ch.CODIGO_CMC7,                       '
      +'		ch.DATA_DEVOLUCAO,                    '
      +'		ch.DATA_VENCIMENTO,                   '
      +'		ch.MOTIVO_DEVOLUCAO,                  '
      +'		ch.SITUACAO,                          '
      +'		ch.TITULO_PAGAMENTO_ID,               '
      +'		ch.VALOR_CHEQUE                      '
      +'	FROM                                    '
      +'		CHEQUE ch                             '
      +'	LEFT JOIN CHEQUE_DESTINO cd ON          '
      +'		cd.ID = ch.destino_id                 '
      +'	INNER JOIN PESSOA p ON                  '
      +'		p.ID = ch.CLIENTE_ID                  '
      +'	INNER JOIN PESSOA pe ON                 '
      +'		pe.ID = ch.CLIENTE_EMITENTE_ID        '
      +'	WHERE                                   ';

  if CboxSituacao.Text = 'A depositar' then
  begin
    Sql := Sql  + '            SITUACAO = ''DEPOSITAR'''
  end;

  if CboxSituacao.Text = 'Depositados' then
  begin
    Sql := Sql  + '            SITUACAO = ''DEPOSITADO'''
  end;

  if CboxSituacao.Text = 'Todos' then
  begin
    Sql := Sql  + '            SITUACAO like ''%%''' //foi necessário adicionar por conta do primeiro end
  end;

  if TipoData = 'Data de vencimento' then
  begin
   Sql := Sql  + '            and trunc(ch.DATA_VENCIMENTO)'
               + '        between to_date(''' + Trim(UniEditDataInicio.Text) + ''', ''dd/mm/yyyy'')'
               + '            and to_date(''' + Trim(UniEditDataFim.Text) + ''', ''dd/mm/yyyy'')'
  end;

  if TipoData = 'Data de devolução' then
  begin
   Sql := Sql  + '            and trunc(ch.DATA_DEVOLUCAO)'
               + '        between to_date(''' + Trim(UniEditDataInicio.Text) + ''', ''dd/mm/yyyy'')'
               + '            and to_date(''' + Trim(UniEditDataFim.Text) + ''', ''dd/mm/yyyy'')'
  end;

  if TipoData = 'Data de deposito' then
  begin
   Sql := Sql  + '            and trunc(ch.DATA_DEPOSITO)'
               + '        between to_date(''' + Trim(UniEditDataInicio.Text) + ''', ''dd/mm/yyyy'')'
               + '            and to_date(''' + Trim(UniEditDataFim.Text) + ''', ''dd/mm/yyyy'')'
  end;

  if TipoData = 'Data de cadastro' then
  begin
   Sql := Sql  + '            and trunc(ch.DATA_CADASTRO)'
               + '        between to_date(''' + Trim(UniEditDataInicio.Text) + ''', ''dd/mm/yyyy'')'
               + '            and to_date(''' + Trim(UniEditDataFim.Text) + ''', ''dd/mm/yyyy'')'
  end;

  if StrToIntDef(UniEditNumeroCheque.Text,0) <> 0 then
  begin
    Sql := Sql  + '		         and NUMERO ='+ UniEditNumeroCheque.Text ;
  end;

  if TipoPessoa = 'cliente' then
  begin
    Sql := Sql  + '		         and cliente_id ='+ IdCliente;
  end;

  if TipoPessoa = 'emitente' then
  begin
    Sql := Sql  + '		         and cliente_emitente_id ='+ IdEmitente;
  end;

  QryConsulta.SQL.Text := Sql;
  CdsConsulta.Open;

  if CdsConsulta.RecordCount <=0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Nenhuma informação encontrada com os parametros informado!');
    Exit;
  end
  else
  begin
    Relatorio.Variables.Variables['Filtro']       := UpperCase(QuotedStr(CboxSituacao.Text));
    Relatorio.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
    Relatorio.Variables.Variables['DataInicial']  := QuotedStr(UniEditDataInicio.Text);
    Relatorio.Variables.Variables['DataFinal']    := QuotedStr(UniEditDataFim.Text);
    ControleMainModule.ExportarPDF('Relatorio',relatorio);
  end;
end;

procedure TControleRelatorioCadastroCheques.BtPesquisaClienteClick(
  Sender: TObject);
begin
  inherited;
  if tipopessoa = 'cliente' then
  begin
    ControleConsultaModalPessoaTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      if Result = 1 then
      begin
        IdCliente   := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('id').AsString;
        EditCliente.Text := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('RAZAO_SOCIAL').AsString;
      end;
    end);
  end
  else if tipopessoa = 'emitente' then
  begin
    ControleConsultaModalPessoa.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      if Result = 1 then
      begin
        IdEmitente := ControleConsultaModalPessoa.CdsConsulta.FieldByName('id').AsString;
        EditCliente.Text := ControleConsultaModalPessoa.CdsConsulta.FieldByName('RAZAO_SOCIAL').AsString;
      end;
    end);
  end;
end;

procedure TControleRelatorioCadastroCheques.CboxDataChange(Sender: TObject);
begin
  inherited;
  TipoData := CboxData.Text;
  LabelDataInicial.Caption := CboxData.Text + ' inicial';
  LabelDataFinal.Caption := CboxData.Text + ' final';
end;

procedure TControleRelatorioCadastroCheques.UniFrameCreate(Sender: TObject);
begin
  inherited;
    UniEditDataInicio.Text  := DateToStr(StartOfTheMonth(Date));
    UniEditDataFim.Text     := DateToStr(EndOfTheMonth(Date));
    TipoData := 'Data de vencimento';
    CboxSituacao.ItemIndex := 0;
    CboxData.ItemIndex := 0;
end;

procedure TControleRelatorioCadastroCheques.uniRadioGroupChangeValue(
  Sender: TObject);
begin
  inherited;
  EditCliente.Text :='';
  IdEmitente :='';
  IdCliente:='';
end;

procedure TControleRelatorioCadastroCheques.uniRadioGroupClick(Sender: TObject);
begin
  inherited;
  if (uniRadioGroup.ItemIndex = 0) then
  begin
    tipopessoa := 'cliente';
    UniPanelPessoa.Enabled := True;
    EditCliente.EmptyText := 'Razão social do cliente'
  end
  else if (uniRadioGroup.ItemIndex = 1) then
  begin
    tipopessoa := 'emitente';
    UniPanelPessoa.Enabled := True;
    EditCliente.EmptyText := 'Razão social do emitente'
  end
  else
  begin
    tipopessoa := 'todos';
    UniPanelPessoa.Enabled := False;
    EditCliente.EmptyText := 'Pesquisa por todos os clientes e emitentes'
  end;
end;

end.
