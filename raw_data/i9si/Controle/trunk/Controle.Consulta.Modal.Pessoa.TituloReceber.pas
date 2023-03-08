unit Controle.Consulta.Modal.Pessoa.TituloReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal.Pessoa, Data.DB,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniEdit, uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniLabel,
  uniBitBtn, uniSpeedButton, uniMultiItem, uniComboBox;

type
  TControleConsultaModalPessoaTituloReceber = class(TControleConsultaModalPessoa)
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaOBSERVACAO: TWideStringField;
    CdsConsultaPESSOA_ID: TFloatField;
    CdsConsultaDATA_EXPEDICAO_RG: TDateTimeField;
    CdsConsultaORGAO_EXPEDIDOR_RG: TWideStringField;
    CdsConsultaSEXO: TWideStringField;
    CdsConsultaGERAL_ENDERECO_ID: TFloatField;
    CdsConsultaGERAL_LOGRADOURO: TWideStringField;
    CdsConsultaGERAL_NUMERO: TWideStringField;
    CdsConsultaGERAL_COMPLEMENTO: TWideStringField;
    CdsConsultaGERAL_PONTO_REFERENCIA: TWideStringField;
    CdsConsultaGERAL_CEP: TWideStringField;
    CdsConsultaGERAL_BAIRRO: TWideStringField;
    CdsConsultaGERAL_NOME_CONTATO: TWideStringField;
    CdsConsultaGERAL_TELEFONE_1: TWideStringField;
    CdsConsultaGERAL_TELEFONE_2: TWideStringField;
    CdsConsultaGERAL_CELULAR: TWideStringField;
    CdsConsultaGERAL_EMAIL: TWideStringField;
    CdsConsultaGERAL_CIDADE_ID: TFloatField;
    CdsConsultaGERAL_CIDADE: TWideStringField;
    CdsConsultaCOMERCIAL_ENDERECO_ID: TFloatField;
    CdsConsultaCOMERCIAL_LOGRADOURO: TWideStringField;
    CdsConsultaCOMERCIAL_NUMERO: TWideStringField;
    CdsConsultaCOMERCIAL_COMPLEMENTO: TWideStringField;
    CdsConsultaCOMERCIAL_PONTO_REFERENCIA: TWideStringField;
    CdsConsultaCOMERCIAL_CEP: TWideStringField;
    CdsConsultaCOMERCIAL_BAIRRO: TWideStringField;
    CdsConsultaCOMERCIAL_NOME_CONTATO: TWideStringField;
    CdsConsultaCOMERCIAL_TELEFONE_1: TWideStringField;
    CdsConsultaCOMERCIAL_TELEFONE_2: TWideStringField;
    CdsConsultaCOMERCIAL_CELULAR: TWideStringField;
    CdsConsultaCOMERCIAL_EMAIL: TWideStringField;
    CdsConsultaCOMERCIAL_CIDADE_ID: TFloatField;
    CdsConsultaCOMERCIAL_CIDADE: TWideStringField;
    CdsConsultaCOBRANCA_ENDERECO_ID: TFloatField;
    CdsConsultaCOBRANCA_LOGRADOURO: TWideStringField;
    CdsConsultaCOBRANCA_NUMERO: TWideStringField;
    CdsConsultaCOBRANCA_COMPLEMENTO: TWideStringField;
    CdsConsultaCOBRANCA_PONTO_REFERENCIA: TWideStringField;
    CdsConsultaCOBRANCA_CEP: TWideStringField;
    CdsConsultaCOBRANCA_BAIRRO: TWideStringField;
    CdsConsultaCOBRANCA_NOME_CONTATO: TWideStringField;
    CdsConsultaCOBRANCA_TELEFONE_1: TWideStringField;
    CdsConsultaCOBRANCA_TELEFONE_2: TWideStringField;
    CdsConsultaCOBRANCA_CELULAR: TWideStringField;
    CdsConsultaCOBRANCA_EMAIL: TWideStringField;
    CdsConsultaCOBRANCA_CIDADE_ID: TFloatField;
    CdsConsultaCOBRANCA_CIDADE: TWideStringField;
    CdsConsultaCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    CdsConsultaFOTO_CAMINHO: TWideStringField;
    CdsConsultaASSINATURA_CAMINHO: TWideStringField;
    CdsConsultaLIMITE_CREDITO: TFloatField;
    CdsConsultaDADOS_ADICIONAIS_ID: TFloatField;
    CdsConsultaNOME_MAE: TWideStringField;
    CdsConsultaNOME_PAI: TWideStringField;
    CdsConsultaNOME_OUTRAS_PESSOAS: TWideStringField;
    CdsConsultaCELULAR_MAE: TWideStringField;
    CdsConsultaCELULAR_PAI: TWideStringField;
    CdsConsultaCELULAR_OUTRAS_PESSOAS: TWideStringField;
    UniComboBox1: TUniComboBox;
    procedure BotaoNovoClick(Sender: TObject);
  private
    { Private declarations }
  public
    IgnoraCamposDoCliente :string;
    { Public declarations }
  end;

function ControleConsultaModalPessoaTituloReceber: TControleConsultaModalPessoaTituloReceber;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Cadastro.Cliente;

function ControleConsultaModalPessoaTituloReceber: TControleConsultaModalPessoaTituloReceber;
begin
  Result := TControleConsultaModalPessoaTituloReceber(ControleMainModule.GetFormInstance(TControleConsultaModalPessoaTituloReceber));
end;

procedure TControleConsultaModalPessoaTituloReceber.BotaoNovoClick(
  Sender: TObject);
begin
  inherited;

  if IgnoraCamposDoCliente = 'S' then
    ControleCadastroCliente.IgnoraCampos := 'S';


  if ControleCadastroCliente.Novo() then
  begin
    ControleCadastroCliente.DbComboTipo.ItemIndex := 0;
    ControleCadastroCliente.ConfiguraTipoPessoa;
    ControleCadastroCliente.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      CdsConsulta.Refresh;
    end);
  end;
end;

end.
