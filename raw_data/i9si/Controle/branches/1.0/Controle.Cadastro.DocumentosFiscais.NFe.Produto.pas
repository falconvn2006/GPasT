unit Controle.Cadastro.DocumentosFiscais.NFe.Produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, uniSweetAlert, ACBrBase,
  ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel, uniGroupBox, uniEdit, uniPageControl;

type
  TControleCadastroDocumentosFiscaisNFeProduto = class(TControleCadastro)
    CdsCadastroID: TFloatField;
    CdsCadastroPRODUTO_ID: TWideStringField;
    CdsCadastroDESCRICAO: TWideStringField;
    CdsCadastroUNIDADE: TWideStringField;
    CdsCadastroQUANTIDADE: TFloatField;
    CdsCadastroVALOR_UNITARIO: TFloatField;
    CdsCadastroVALOR_TOTAL: TFloatField;
    CdsCadastroCFOP: TWideStringField;
    CdsCadastroNCM: TWideStringField;
    CdsCadastroOUTRAS_DESPESAS: TFloatField;
    CdsCadastroFRETE: TFloatField;
    CdsCadastroSEGURO: TFloatField;
    CdsCadastroDESCONTO: TFloatField;
    CdsCadastroCOD_BARRAS: TWideStringField;
    CdsCadastroICMS_ORIGEM: TWideStringField;
    CdsCadastroICMS_MODALIDADE_DETERMINACAO: TWideStringField;
    CdsCadastroICMS_PERCENTUAL_REDUCAO_BC: TFloatField;
    CdsCadastroICMS_BASE_CALCULO: TFloatField;
    CdsCadastroICMS_ALIQUOTA: TFloatField;
    CdsCadastroICMS_VALOR: TFloatField;
    CdsCadastroICMS_ST_MODALIDADE_DETERMINACA: TWideStringField;
    CdsCadastroICMS_ST_PERCENTUAL_REDUCAO_BC: TFloatField;
    CdsCadastroICMS_ST_BASE_CALCULO: TFloatField;
    CdsCadastroICMS_ST_ALIQUOTA_PERCENTUAL: TFloatField;
    CdsCadastroICMS_ST_VALOR: TFloatField;
    CdsCadastroICMS_CRED_PERCENTUAL: TFloatField;
    CdsCadastroICMS_CRED_VALOR: TFloatField;
    CdsCadastroDOCUMENTO_FISCAL_NFE_ID: TFloatField;
    CdsCadastroICMS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroICMS_SITUACAO_TRIBUTARIA_ST: TWideStringField;
    CdsCadastroIPI_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroIPI_CLASSE_ENQUADRAMENTO: TWideStringField;
    CdsCadastroIPI_CODIGO_ENQUADRAMENTO: TWideStringField;
    CdsCadastroIPI_CNPJPRODUTOR: TWideStringField;
    CdsCadastroIPI_CODIGO_SELO_CONTROLE: TWideStringField;
    CdsCadastroIPI_TIPO_CALCULO: TWideStringField;
    CdsCadastroIPI_VALOR_BASE_CALCULO: TFloatField;
    CdsCadastroIPI_QUANT_UNIDADE_PADRAO: TFloatField;
    CdsCadastroIPI_ALIQUOTA_PERCENTUAL: TFloatField;
    CdsCadastroIPI_VALOR_UNIDADE: TFloatField;
    CdsCadastroIPI_VALOR_IPI: TFloatField;
    CdsCadastroIPI_QUANT_SELO_CONTROLE: TFloatField;
    CdsCadastroPIS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroPIS_TIPO_CALCULO: TWideStringField;
    CdsCadastroPIS_VALOR_BASE_CALCULO: TFloatField;
    CdsCadastroPIS_VALOR_ALIQUOTA: TFloatField;
    CdsCadastroPIS_QUANT_VENDIDA: TFloatField;
    CdsCadastroPIS_VALOR: TFloatField;
    CdsCadastroCOFINS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroCOFINS_TIPO_CALCULO: TWideStringField;
    CdsCadastroCOFINS_VALOR_BASE_CALCULO: TFloatField;
    CdsCadastroCOFINS_VALOR_ALIQUOTA: TFloatField;
    CdsCadastroCOFINS_QUANT_VENDIDA: TFloatField;
    CdsCadastroCOFINS_VALOR: TFloatField;
    CdsCadastroPIS_ST_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroPIS_ST_TIPO_CALCULO: TWideStringField;
    CdsCadastroPIS_ST_VALOR_BASE_CALCULO: TFloatField;
    CdsCadastroPIS_ST_VALOR_ALIQUOTA: TFloatField;
    CdsCadastroPIS_ST_QUANT_VENDIDA: TFloatField;
    CdsCadastroPIS_ST_VALOR: TFloatField;
    CdsCadastroCOFINS_ST_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroCOFINS_ST_TIPO_CALCULO: TWideStringField;
    CdsCadastroCOFINS_ST_VALOR_BASE_CALCULO: TFloatField;
    CdsCadastroCOFINS_ST_VALOR_ALIQUOTA: TFloatField;
    CdsCadastroCOFINS_ST_QUANT_VENDIDA: TFloatField;
    CdsCadastroCOFINS_ST_VALOR: TFloatField;
    UniGroupBox1: TUniGroupBox;
    UniGroupBox2: TUniGroupBox;
    UniGroupBox3: TUniGroupBox;
    UniEdit1: TUniEdit;
    UniLabel1: TUniLabel;
    UniEdit2: TUniEdit;
    UniEdit7: TUniEdit;
    UniLabel7: TUniLabel;
    UniEdit8: TUniEdit;
    UniLabel8: TUniLabel;
    UniEdit9: TUniEdit;
    UniLabel9: TUniLabel;
    UniEdit10: TUniEdit;
    UniLabel10: TUniLabel;
    UniEdit11: TUniEdit;
    UniLabel11: TUniLabel;
    UniEdit12: TUniEdit;
    UniLabel5: TUniLabel;
    UniEdit5: TUniEdit;
    UniLabel3: TUniLabel;
    UniEdit3: TUniEdit;
    UniLabel4: TUniLabel;
    UniEdit4: TUniEdit;
    UniLabel12: TUniLabel;
    UniEdit6: TUniEdit;
    UniEdit13: TUniEdit;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniTabSheet3: TUniTabSheet;
    UniTabSheet4: TUniTabSheet;
    UniTabSheet5: TUniTabSheet;
    UniTabSheet6: TUniTabSheet;
    UniLabel2: TUniLabel;
    UniEdit14: TUniEdit;
    UniEdit15: TUniEdit;
    UniLabel6: TUniLabel;
    UniEdit16: TUniEdit;
    UniEdit17: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
  end;

function ControleCadastroDocumentosFiscaisNFeProduto: TControleCadastroDocumentosFiscaisNFeProduto;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleCadastroDocumentosFiscaisNFeProduto: TControleCadastroDocumentosFiscaisNFeProduto;
begin
  Result := TControleCadastroDocumentosFiscaisNFeProduto(ControleMainModule.GetFormInstance(TControleCadastroDocumentosFiscaisNFeProduto));
end;

function TControleCadastroDocumentosFiscaisNFeProduto.Novo(): Boolean;
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


function TControleCadastroDocumentosFiscaisNFeProduto.Abrir(Id: Integer): Boolean;
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

end.
