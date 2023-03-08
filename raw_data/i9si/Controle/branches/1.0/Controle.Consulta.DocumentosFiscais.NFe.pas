unit Controle.Consulta.DocumentosFiscais.NFe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Consulta, Vcl.Menus,
  uniMainMenu, uniSweetAlert, frxClass, frxDBSet, frxExportBaseDialog,
  frxExportPDF, uniGridExporters, uniBasicGrid, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniGUIClasses,
  uniImageList, uniCheckBox, uniLabel, uniPanel, uniDBGrid, uniButton, uniEdit;

type
  TControleConsultaDocumentosFiscaisNFe = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaNFE_NUMERO: TFloatField;
    CdsConsultaNFE_SERIE: TWideStringField;
    CdsConsultaNFE_DATA_EMISSAO: TDateTimeField;
    CdsConsultaNFE_DATA_SAIDA: TDateTimeField;
    CdsConsultaNFE_NATUREZA_OPERACAO: TWideStringField;
    CdsConsultaNFE_FORMA_EMISSAO: TWideStringField;
    CdsConsultaNFE_FORMA_PAGAMENTO: TWideStringField;
    CdsConsultaNFE_TIPO_DOCUMENTO: TWideStringField;
    CdsConsultaNFE_FINALIDADE_EMISSAO: TWideStringField;
    CdsConsultaNFE_CHAVE: TWideStringField;
    CdsConsultaNFE_SITUACAO: TWideStringField;
    CdsConsultaNFE_NUMERO_REFERENCIA: TWideStringField;
    CdsConsultaNFE_CHAVE_CARTA_CORRECAO: TWideStringField;
    CdsConsultaDESTINATARIO_TIPO: TWideStringField;
    CdsConsultaDESTINATARIO_CNPJ_CPF: TWideStringField;
    CdsConsultaDESTINATARIO_INSCRICAO: TWideStringField;
    CdsConsultaDESTINATARIO_INSCRICAO_SUFRAMA: TWideStringField;
    CdsConsultaDESTINATARIO_RAZAO_SOCIAL: TWideStringField;
    CdsConsultaDESTINATARIO_NOME_FANTASIA: TWideStringField;
    CdsConsultaDESTINATARIO_EMAIL: TWideStringField;
    CdsConsultaDESTINATARIO_END_LOGRADOURO: TWideStringField;
    CdsConsultaDESTINATARIO_END_NUMERO: TWideStringField;
    CdsConsultaDESTINATARIO_COMPLEMENTO: TWideStringField;
    CdsConsultaDESTINATARIO_BAIRRO: TWideStringField;
    CdsConsultaDESTINATARIO_CIDADE: TWideStringField;
    CdsConsultaDESTINATARIO_CEP: TWideStringField;
    CdsConsultaDESTINATARIO_UF: TWideStringField;
    CdsConsultaDESTINATARIO_IBGE_MUN: TWideStringField;
    CdsConsultaDESTINATARIO_IIBGE_UF: TWideStringField;
    CdsConsultaEMITENTE_TIPO: TWideStringField;
    CdsConsultaEMITENTE_CNPJ_CPF: TWideStringField;
    CdsConsultaEMITENTE_INSCRICAO: TWideStringField;
    CdsConsultaEMITENTE_INSCRICAO_SUFRAMA: TWideStringField;
    CdsConsultaEMITENTE_RAZAO_SOCIAL: TWideStringField;
    CdsConsultaEMITENTE_NOME_FANTASIA: TWideStringField;
    CdsConsultaEMITENTE_EMAIL: TWideStringField;
    CdsConsultaEMITENTE_END_LOGRADOURO: TWideStringField;
    CdsConsultaEMITENTE_END_NUMERO: TWideStringField;
    CdsConsultaEMITENTE_COMPLEMENTO: TWideStringField;
    CdsConsultaEMITENTE_BAIRRO: TWideStringField;
    CdsConsultaEMITENTE_CIDADE: TWideStringField;
    CdsConsultaEMITENTE_CEP: TWideStringField;
    CdsConsultaEMITENTE_UF: TWideStringField;
    CdsConsultaEMITENTE_IBGE_MUN: TWideStringField;
    CdsConsultaEMITENTE_IIBGE_UF: TWideStringField;
    CdsConsultaTRANSPORTE_MODALIDADE: TWideStringField;
    CdsConsultaTRANSPORTE_RAZAO_SOCIAL: TWideStringField;
    CdsConsultaTRANSPORTE_NOME_FANTASIA: TWideStringField;
    CdsConsultaTRANSPORTE_CNPJ_CPF: TWideStringField;
    CdsConsultaTRANSPORTE_LOGRADOURO: TWideStringField;
    CdsConsultaTRANSPORTE_NUMERO: TWideStringField;
    CdsConsultaTRANSPORTE_COMPLEMENTO: TWideStringField;
    CdsConsultaTRANSPORTE_BAIRRO: TWideStringField;
    CdsConsultaTRANSPORTE_CIDADE: TWideStringField;
    CdsConsultaTRANSPORTE_CEP: TWideStringField;
    CdsConsultaTRANSPORTE_UF: TWideStringField;
    CdsConsultaTRANSPORTE_FONE: TWideStringField;
    CdsConsultaOBSERVACAO_COMPLEMENTAR: TWideStringField;
    CdsConsultaOBSERVACAO_FISCO: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    UniEdit6: TUniEdit;
    UniEdit7: TUniEdit;
  private
    procedure UniFrameCreate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

var
  ControleConsultaDocumentosFiscaisNFe: TControleConsultaDocumentosFiscaisNFe;

implementation

{$R *.dfm}

uses Controle.Cadastro.DocumentosFiscais.NFe;

procedure TControleConsultaDocumentosFiscaisNFe.Novo;
begin
  if ControleCadastroDocumentosFiscaisNFe.Novo() then
  begin
    ControleCadastroDocumentosFiscaisNFe.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaDocumentosFiscaisNFe.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'banco';
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaDocumentosFiscaisNFe.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  if ControleCadastroDocumentosFiscaisNFe.Abrir(Id) then
  begin
    ControleCadastroDocumentosFiscaisNFe.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
      CdsConsulta.Refresh;
    end);
  end;
end;

end.
