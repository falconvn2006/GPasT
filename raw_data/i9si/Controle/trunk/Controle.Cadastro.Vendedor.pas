unit Controle.Cadastro.Vendedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniButton,
  uniPanel, uniMultiItem, uniComboBox, uniDBComboBox, uniMemo, uniDBMemo,
  uniBitBtn, uniSpeedButton, uniEdit, uniDBEdit, uniLabel, uniGroupBox,
  uniPageControl, ACBrBase, ACBrSocket, ACBrCEP, ACBrValidador, 
  Controle.Funcoes, uniSweetAlert;

type
  TControleCadastroVendedor = class(TControleCadastro)
    QryCadastroID: TFloatField;
    QryCadastroATIVO: TWideStringField;
    QryCadastroOBSERVACAO: TWideStringField;
    QryCadastroPESSOA_ID: TFloatField;
    QryCadastroTIPO: TWideStringField;
    QryCadastroRAZAO_SOCIAL: TWideStringField;
    QryCadastroNOME_FANTASIA: TWideStringField;
    QryCadastroCPF_CNPJ: TWideStringField;
    QryCadastroRG_INSC_ESTADUAL: TWideStringField;
    QryCadastroDATA_EXPEDICAO_RG: TDateTimeField;
    QryCadastroORGAO_EXPEDIDOR_RG: TWideStringField;
    QryCadastroDATA_NASCIMENTO: TDateTimeField;
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
    QryCadastroCOMERCIAL_ENDERECO_ID: TFloatField;
    QryCadastroCOMERCIAL_LOGRADOURO: TWideStringField;
    QryCadastroCOMERCIAL_NUMERO: TWideStringField;
    QryCadastroCOMERCIAL_COMPLEMENTO: TWideStringField;
    QryCadastroCOMERCIAL_PONTO_REFERENCIA: TWideStringField;
    QryCadastroCOMERCIAL_CEP: TWideStringField;
    QryCadastroCOMERCIAL_BAIRRO: TWideStringField;
    QryCadastroCOMERCIAL_NOME_CONTATO: TWideStringField;
    QryCadastroCOMERCIAL_TELEFONE_1: TWideStringField;
    QryCadastroCOMERCIAL_TELEFONE_2: TWideStringField;
    QryCadastroCOMERCIAL_CELULAR: TWideStringField;
    QryCadastroCOMERCIAL_EMAIL: TWideStringField;
    QryCadastroCOMERCIAL_CIDADE_ID: TFloatField;
    QryCadastroCOMERCIAL_CIDADE: TWideStringField;
    QryCadastroCOBRANCA_ENDERECO_ID: TFloatField;
    QryCadastroCOBRANCA_LOGRADOURO: TWideStringField;
    QryCadastroCOBRANCA_NUMERO: TWideStringField;
    QryCadastroCOBRANCA_COMPLEMENTO: TWideStringField;
    QryCadastroCOBRANCA_PONTO_REFERENCIA: TWideStringField;
    QryCadastroCOBRANCA_CEP: TWideStringField;
    QryCadastroCOBRANCA_BAIRRO: TWideStringField;
    QryCadastroCOBRANCA_NOME_CONTATO: TWideStringField;
    QryCadastroCOBRANCA_TELEFONE_1: TWideStringField;
    QryCadastroCOBRANCA_TELEFONE_2: TWideStringField;
    QryCadastroCOBRANCA_CELULAR: TWideStringField;
    QryCadastroCOBRANCA_EMAIL: TWideStringField;
    QryCadastroCOBRANCA_CIDADE_ID: TFloatField;
    QryCadastroCOBRANCA_CIDADE: TWideStringField;
    QryCadastroCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroATIVO: TWideStringField;
    CdsCadastroOBSERVACAO: TWideStringField;
    CdsCadastroPESSOA_ID: TFloatField;
    CdsCadastroTIPO: TWideStringField;
    CdsCadastroRAZAO_SOCIAL: TWideStringField;
    CdsCadastroNOME_FANTASIA: TWideStringField;
    CdsCadastroCPF_CNPJ: TWideStringField;
    CdsCadastroRG_INSC_ESTADUAL: TWideStringField;
    CdsCadastroDATA_EXPEDICAO_RG: TDateTimeField;
    CdsCadastroORGAO_EXPEDIDOR_RG: TWideStringField;
    CdsCadastroDATA_NASCIMENTO: TDateTimeField;
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
    CdsCadastroCOMERCIAL_ENDERECO_ID: TFloatField;
    CdsCadastroCOMERCIAL_LOGRADOURO: TWideStringField;
    CdsCadastroCOMERCIAL_NUMERO: TWideStringField;
    CdsCadastroCOMERCIAL_COMPLEMENTO: TWideStringField;
    CdsCadastroCOMERCIAL_PONTO_REFERENCIA: TWideStringField;
    CdsCadastroCOMERCIAL_CEP: TWideStringField;
    CdsCadastroCOMERCIAL_BAIRRO: TWideStringField;
    CdsCadastroCOMERCIAL_NOME_CONTATO: TWideStringField;
    CdsCadastroCOMERCIAL_TELEFONE_1: TWideStringField;
    CdsCadastroCOMERCIAL_TELEFONE_2: TWideStringField;
    CdsCadastroCOMERCIAL_CELULAR: TWideStringField;
    CdsCadastroCOMERCIAL_EMAIL: TWideStringField;
    CdsCadastroCOMERCIAL_CIDADE_ID: TFloatField;
    CdsCadastroCOMERCIAL_CIDADE: TWideStringField;
    CdsCadastroCOBRANCA_ENDERECO_ID: TFloatField;
    CdsCadastroCOBRANCA_LOGRADOURO: TWideStringField;
    CdsCadastroCOBRANCA_NUMERO: TWideStringField;
    CdsCadastroCOBRANCA_COMPLEMENTO: TWideStringField;
    CdsCadastroCOBRANCA_PONTO_REFERENCIA: TWideStringField;
    CdsCadastroCOBRANCA_CEP: TWideStringField;
    CdsCadastroCOBRANCA_BAIRRO: TWideStringField;
    CdsCadastroCOBRANCA_NOME_CONTATO: TWideStringField;
    CdsCadastroCOBRANCA_TELEFONE_1: TWideStringField;
    CdsCadastroCOBRANCA_TELEFONE_2: TWideStringField;
    CdsCadastroCOBRANCA_CELULAR: TWideStringField;
    CdsCadastroCOBRANCA_EMAIL: TWideStringField;
    CdsCadastroCOBRANCA_CIDADE_ID: TFloatField;
    CdsCadastroCOBRANCA_CIDADE: TWideStringField;
    CdsCadastroCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    UniPagePrincipal: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniGroupBox1: TUniGroupBox;
    UniLabel7: TUniLabel;
    DBEditCepGeral: TUniDBEdit;
    BotaoCEPGeral: TUniSpeedButton;
    UniLabel8: TUniLabel;
    UniDBEdit3: TUniDBEdit;
    UniLabel9: TUniLabel;
    DBEditNum: TUniDBEdit;
    UniLabel10: TUniLabel;
    UniDBEdit5: TUniDBEdit;
    UniLabel11: TUniLabel;
    UniDBEdit6: TUniDBEdit;
    UniLabel12: TUniLabel;
    UniDBEdit7: TUniDBEdit;
    UniLabel13: TUniLabel;
    UniDBEdit8: TUniDBEdit;
    ButtonPesquisaCidadeGeral: TUniSpeedButton;
    UniGroupBox2: TUniGroupBox;
    UniLabel14: TUniLabel;
    UniLabel15: TUniLabel;
    DBEditEmailGeral: TUniDBEdit;
    UniDBEdit10: TUniDBEdit;
    UniLabel16: TUniLabel;
    UniDBEdit11: TUniDBEdit;
    UniLabel17: TUniLabel;
    UniDBEdit12: TUniDBEdit;
    UniDBEdit13: TUniDBEdit;
    UniLabel19: TUniLabel;
    UniTabSheet3: TUniTabSheet;
    UniGroupBox3: TUniGroupBox;
    UniLabel3: TUniLabel;
    DBEditCepComercial: TUniDBEdit;
    BotaoCEPComercial: TUniSpeedButton;
    UniLabel4: TUniLabel;
    UniDBEdit15: TUniDBEdit;
    UniLabel5: TUniLabel;
    UniDBEdit16: TUniDBEdit;
    UniLabel6: TUniLabel;
    UniDBEdit17: TUniDBEdit;
    UniLabel20: TUniLabel;
    UniDBEdit18: TUniDBEdit;
    UniLabel21: TUniLabel;
    UniDBEdit19: TUniDBEdit;
    UniLabel22: TUniLabel;
    UniDBEdit20: TUniDBEdit;
    ButtonPesquisaCidadeComercial: TUniSpeedButton;
    UniGroupBox4: TUniGroupBox;
    UniLabel24: TUniLabel;
    UniLabel25: TUniLabel;
    UniDBEdit22: TUniDBEdit;
    UniDBEdit23: TUniDBEdit;
    UniLabel26: TUniLabel;
    UniDBEdit24: TUniDBEdit;
    UniLabel27: TUniLabel;
    UniDBEdit25: TUniDBEdit;
    UniDBEdit26: TUniDBEdit;
    UniLabel28: TUniLabel;
    UniTabSheet4: TUniTabSheet;
    UniGroupBox5: TUniGroupBox;
    UniLabel29: TUniLabel;
    DBEditCepCobranca: TUniDBEdit;
    BotaoCEPCobranca: TUniSpeedButton;
    UniLabel30: TUniLabel;
    UniDBEdit28: TUniDBEdit;
    UniLabel31: TUniLabel;
    UniDBEdit29: TUniDBEdit;
    UniLabel32: TUniLabel;
    UniDBEdit30: TUniDBEdit;
    UniLabel33: TUniLabel;
    UniDBEdit31: TUniDBEdit;
    UniLabel34: TUniLabel;
    UniDBEdit32: TUniDBEdit;
    UniLabel35: TUniLabel;
    UniDBEdit33: TUniDBEdit;
    ButtonPesquisaCidadeCobranca: TUniSpeedButton;
    UniGroupBox6: TUniGroupBox;
    UniLabel37: TUniLabel;
    UniLabel38: TUniLabel;
    UniDBEdit35: TUniDBEdit;
    UniDBEdit36: TUniDBEdit;
    UniLabel39: TUniLabel;
    UniDBEdit37: TUniDBEdit;
    UniLabel40: TUniLabel;
    UniDBEdit38: TUniDBEdit;
    UniDBEdit39: TUniDBEdit;
    UniLabel41: TUniLabel;
    UniTabSheet2: TUniTabSheet;
    UniDBMemo1: TUniDBMemo;
    UniLabel1: TUniLabel;
    DbComboTipo: TUniDBComboBox;
    LabelCpfCnpj: TUniLabel;
    DBEdtCpfCnpj: TUniDBEdit;
    LabelPopularFantasia: TUniLabel;
    DbEditFantasia: TUniDBEdit;
    LabelRgIe: TUniLabel;
    DBEdtRg: TUniDBEdit;
    LabelDataExped: TUniLabel;
    DBEdtDataExped: TUniDBEdit;
    LabelOrgaoExped: TUniLabel;
    DBEdtOrgaoExped: TUniDBEdit;
    DBEdtNascimento: TUniDBEdit;
    LabelNascimento: TUniLabel;
    LabelSexo: TUniLabel;
    DBComboSexo: TUniDBComboBox;
    DBEdtNome: TUniDBEdit;
    LabelNomeRazao: TUniLabel;
    UniLabel2: TUniLabel;
    UniDBComboBox1: TUniDBComboBox;
    UniLabel42: TUniLabel;
    DbComboCRT: TUniDBComboBox;
    ACBrCEP1: TACBrCEP;
    procedure BotaoCEPCobrancaClick(Sender: TObject);
    procedure BotaoCEPComercialClick(Sender: TObject);
    procedure BotaoCEPGeralClick(Sender: TObject);
    procedure ButtonPesquisaCidadeGeralClick(Sender: TObject);
    procedure DbComboTipoChange(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure DBEdtCpfCnpjExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    // Funções
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
    procedure ConfiguraTipoPessoa;
  end;

function ControleCadastroVendedor: TControleCadastroVendedor;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Consulta.Modal.Pessoa,
  Controle.Consulta.Modal.Cidade;

function ControleCadastroVendedor: TControleCadastroVendedor;
begin
  Result := TControleCadastroVendedor(ControleMainModule.GetFormInstance(TControleCadastroVendedor));
end;

{ TControleCadastrovendedor }

function TControleCadastroVendedor.Abrir(Id: Integer): Boolean;
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

  // Configura os componentes de acordo com o tipo de pessoa
  ConfiguraTipoPessoa;

  Result := True;
end;

procedure TControleCadastroVendedor.BotaoCEPCobrancaClick(Sender: TObject);
begin
  inherited;
  try
     ACBrCEP1.BuscarPorCEP(DBEditCepGeral.Text);

     if ACBrCEP1.Enderecos.Count < 1 then
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção','Nenhum Endereço encontrado');
     end
     else
     begin
       with ACBrCEP1.Enderecos[0] do
       begin
         CdsCadastroCOBRANCA_LOGRADOURO.AsString  := Tipo_Logradouro + ' ' + Logradouro;
         CdsCadastroCOBRANCA_COMPLEMENTO.AsString := Complemento;
         CdsCadastroCOBRANCA_BAIRRO.AsString      := Bairro;
         CdsCadastroCOBRANCA_CIDADE_ID.AsString   := IBGE_Municipio;
         CdsCadastroCOBRANCA_CIDADE.AsString      := Municipio;
       end;
     end ;
  except
     On E : Exception do
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
     end ;
  end ;
end;

procedure TControleCadastroVendedor.BotaoCEPComercialClick(Sender: TObject);
begin
  inherited;
  try
     ACBrCEP1.BuscarPorCEP(DBEditCepGeral.Text);

     if ACBrCEP1.Enderecos.Count < 1 then
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção','Nenhum Endereço encontrado');
     end
     else
     begin
       with ACBrCEP1.Enderecos[0] do
       begin
         CdsCadastroCOMERCIAL_LOGRADOURO.AsString  := Tipo_Logradouro + ' ' + Logradouro;
         CdsCadastroCOMERCIAL_COMPLEMENTO.AsString := Complemento;
         CdsCadastroCOMERCIAL_BAIRRO.AsString      := Bairro;
         CdsCadastroCOMERCIAL_CIDADE_ID.AsString   := IBGE_Municipio;
         CdsCadastroCOMERCIAL_CIDADE.AsString      := Municipio;
       end;
     end ;
  except
     On E : Exception do
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
     end ;
  end ;
end;

procedure TControleCadastroVendedor.BotaoCEPGeralClick(Sender: TObject);
var
  CidadeId: Integer;
  Tipo, CodigoIbge, Cidade, Uf_: String;
  Erro, Cep, Retorno: String;
begin
  inherited;

  // Não executa se o botão estiver desabilitado
  if not TUniSpeedButton(Sender).Enabled then
    Exit;

  // Identifica o tipo de endereço que está sendo editado
  if Pos('COMERCIAL', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
  begin
    Tipo := 'comercial';
    Cep  := ControleFuncoes.RemoveMascara(Trim(DBEditCepComercial.Text));
  end
  else if Pos('COBRANCA', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
  begin
    Tipo := 'cobranca';
    Cep  := ControleFuncoes.RemoveMascara(Trim(DBEditCepCobranca.Text));
  end
  else
  begin
    Tipo := 'geral';
    Cep  := ControleFuncoes.RemoveMascara(Trim(DBEditCepGeral.Text));
  end;

  // Verifica se o cep foi informado
  if Cep = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Informe o CEP que deseja consultar.');
    Exit;
  end;

  // Verifica se o cep é válido
  if Length(Cep) <> 8 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção.', 'Informe o CEP com 8 digitos.');
    Exit;
  end;

  try
     ACBrCEP1.BuscarPorCEP(DBEditCepGeral.Text);

     if ACBrCEP1.Enderecos.Count < 1 then
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
     end
     else
     begin
       with ACBrCEP1.Enderecos[0] do
       begin
         // Coloca o dataset em modo de edição se ainda não estiver
         CdsCadastro.Edit;

         // Redefine o logradouro
         if Logradouro <> '' then
           CdsCadastro[Tipo + '_logradouro'] := Trim(Logradouro)
         else
           CdsCadastro[Tipo + '_logradouro'] := '';

         // Redefine o complemento
         if Complemento <> '' then
           CdsCadastro[Tipo + '_complemento'] := Trim(Complemento)
         else
           CdsCadastro[Tipo + '_complemento'] := '';

         // Redefine o bairro
         if Bairro <> '' then
           CdsCadastro[Tipo + '_bairro'] := Trim(Bairro)
         else
           CdsCadastro[Tipo + '_bairro'] := '';

         // Pega o código ibge
         if IBGE_Municipio <> '' then
           CodigoIbge := Trim(IBGE_Municipio);

         // Pega a cidade
         if Municipio <> '' then
           Cidade := Trim(Municipio);

         // Pega a uf
         if UF <> '' then
           Uf_ := Trim(UF);

         with ControleMainModule do
         begin
            CidadeId := 0;

            // Tenta localizar a cidade pelo código ibge
            CdsAx1.Close;
            QryAx1.Parameters.Clear;
            QryAx1.SQL.Clear;
            QryAx1.SQL.Text :=
                'SELECT cid.id,'
              + '       cid.nome,'
              + '       est.uf'
              + '  FROM fonte.cidade cid'
              + '  LEFT OUTER JOIN fonte.estado est'
              + '    ON est.id = cid.estado_id'
              + ' WHERE cid.codigo_ibge = :codigo_ibge';
            QryAx1.Parameters.ParamByName('codigo_ibge').Value := CodigoIbge;
            CdsAx1.Open;

            if (CodigoIbge <> '') and (CdsAx1.FieldByName('id').AsInteger <> 0) then
            begin
              CidadeId := CdsAx1.FieldByName('id').AsInteger;
              Cidade   := CdsAx1.FieldByName('nome').AsString;
              Uf       := CdsAx1.FieldByName('uf').AsString;
            end
            else
            begin
              // Tenta localizar a cidade pelo nome e uf
              CdsAx1.Close;
              QryAx1.Parameters.Clear;
              QryAx1.SQL.Clear;
              QryAx1.SQL.Text :=
                  'SELECT cid.id,'
                + '       cid.nome,'
                + '       est.uf'
                + '  FROM cidade cid'
                + ' INNER JOIN estado est'
                + '    ON est.id = cid.estado_id'
                + ' WHERE UPPER(TRIM(cid.nome)) = UPPER(:nome)'
                + '   AND UPPER(TRIM(est.uf))   = UPPER(:uf)';
              QryAx1.Parameters.ParamByName('nome').Value := Cidade;
              QryAx1.Parameters.ParamByName('uf').Value   := Uf;
              CdsAx1.Open;

              if (Cidade <> '') and (CdsAx1.FieldByName('id').AsInteger <> 0) then
              begin
                CidadeId := CdsAx1.FieldByName('id').AsInteger;
                Cidade   := CdsAx1.FieldByName('nome').AsString;
                Uf       := CdsAx1.FieldByName('uf').AsString;
              end;
            end;

            // Cadastra a cidade retornada pelo VIACEP se ainda não estiver cadastrada.
            if (CidadeId = 0) and (Cidade <> '') and (Uf <> '') then
            begin
              // Inicia a transação
              ADOConnection.BeginTrans;

              // Inserindo o login do usuario em tabela temporaria,
              // Utilzado para auditoria
              Insere_Tabela_Temp_Login;

              CidadeId := GeraId('cidade');

              // Insere a nova cidade
              CdsAx1.Close;
              QryAx1.Parameters.Clear;
              QryAx1.SQL.Clear;
              QryAx1.SQL.Text :=
                  'INSERT INTO fonte.cidade ('
                + '       id,'
                + '       nome,'
                + '       estado_id,'
                + '       codigo_ibge)'
                + 'VALUES ('
                + '       :id,'
                + '       :nome,'
                + '       (SELECT id'
                + '          FROM fonte.estado'
                + '         WHERE UPPER(uf) = UPPER(:uf)'
                + '           AND ROWNUM = 1),'
                + '       :codigo_ibge)';
              QryAx1.Parameters.ParamByName('id').Value          := CidadeId;
              QryAx1.Parameters.ParamByName('nome').Value        := Cidade;
              QryAx1.Parameters.ParamByName('uf').Value          := Uf;
              QryAx1.Parameters.ParamByName('codigo_ibge').Value := CodigoIbge;

              try
                // Tenta salvar os dados
                QryAx1.ExecSQL;
                // Confirma a transação
                ADOConnection.CommitTrans;
              except
                on E: Exception do
                begin
                  Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
                  ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
                  // Descarta a transação
                  ADOConnection.RollbackTrans;
                  CdsCadastro.Edit;
                end;
              end;
            end;

            if (Erro = '') and (CidadeId > 0) then
            begin
              // Redefine a cidade
              CdsCadastro[Tipo + '_cidade_id'] := CidadeId;
              CdsCadastro[Tipo + '_cidade']    := Cidade + ' / ' + Uf;
            end;

            DBEditNum.SetFocus;
         end;
       end;
     end ;
  except
     On E : Exception do
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
     end ;
  end ;
end;

procedure TControleCadastroVendedor.ButtonPesquisaCidadeGeralClick(
  Sender: TObject);
var
  Tipo: String;
begin
  inherited;

   // Abre o formulário em modal e aguarda
  ControleConsultaModalCidade.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
{    if Result = 1 then
    begin}
      // Identifica o tipo de endereço que está sendo editado
      if Pos('COMERCIAL', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
        Tipo := 'comercial'
      else if Pos('COBRANCA', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
        Tipo := 'cobranca'
      else
        Tipo := 'geral';

      CdsCadastro.Edit;
      CdsCadastro[Tipo + '_cidade_id'] := ControleConsultaModalCidade.CdsConsulta.FieldByName('id').AsInteger;
      CdsCadastro[Tipo + '_cidade']    := ControleConsultaModalCidade.CdsConsulta.FieldByName('nome').AsString +
        ' / ' + ControleConsultaModalCidade.CdsConsulta.FieldByName('uf').AsString;
//    end;
  end);
end;

procedure TControleCadastroVendedor.DbComboTipoChange(Sender: TObject);
begin
  inherited;
  // Configura os componentes de acordo com o tipo de pessoa
  ConfiguraTipoPessoa;
  DBEdtCpfCnpj.Clear;
end;

procedure TControleCadastroVendedor.DBEdtCpfCnpjExit(Sender: TObject);
begin
  inherited;
  with ControleMainModule do
  begin
    // Pesquisa o cpf/cnpj
    CdsAx1.Close;
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Add('SELECT id');
    QryAx1.SQL.Add('  FROM pessoa');
    QryAx1.SQL.Add(' WHERE cpf_cnpj = :cpf_cnpj');
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value := ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text);
    CdsAx1.Open;

    // Recarrega o cliente com os dados da nova pessoa selecionada
    if CdsAx1.RecordCount > 0 then
    begin
      // Recarrega os dados
      CdsCadastro.Close;
      QryCadastro.Parameters.ParamByName('id').Value := CdsAx1.FieldByName('id').AsInteger;
      CdsCadastro.Open;

      CdsCadastro.Edit;
      CdsCadastro['ativo'] := 'SIM';
    end;
  end;
end;

function TControleCadastroVendedor.Editar(Id: Integer): Boolean;
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
  DBEdtCpfCnpj.Color           := clBtnFace;
  DBEdtCpfCnpj.Enabled         := True;
  DBComboTipo.Enabled          := False;
//  BotaoPesquisaPessoa.Visible := False;

  Result := True;
end;

function TControleCadastroVendedor.Novo(): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;
    CdsCadastro['tipo']  := 'FÍSICA';
    CdsCadastro['ativo'] := 'SIM';

    // Configura os componentes de acordo com o tipo de pessoa
    ConfiguraTipoPessoa;

    // Atualiza os botões de comando
  //    AtualizaComandos(DscCadastro);

    // Libera a mudança do tipo de pessoa e cpf/cnpj na inserção
    DBEdtCpfCnpj.Color           := clWindow;
    DBEdtCpfCnpj.ReadOnly        := False;
    DBComboTipo.Enabled          := True;

    Result := True;
  end;
end;

function TControleCadastroVendedor.Salvar: Boolean;
Var
  PessoaId, EnderecoGEId, EnderecoCOId, EnderecoCBId, Endereco: Integer;
  Erro, Tipo: String;
begin
  inherited;

  Erro   := '';
  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Verifica o CNPJ
    if Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = '' then
    begin
      if Copy(DBComboTipo.Text, 1, 1) = 'F' then
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o CPF.')
      else
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o CNPJ.');

      if not DBEdtCpfCnpj.ReadOnly then
        DBEdtCpfCnpj.SetFocus;
      Exit;
    end;

    // Valida CNPJ/CPF
    if Copy(DBComboTipo.Text, 1, 1) = 'F' then
    begin
      if ControleFuncoes.ValidaCPF(Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text))) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'CPF inválido');
        Exit;
      end;
    end
    else if Copy(DBComboTipo.Text, 1, 1) = 'J' then
    begin
      if ControleFuncoes.ValidaCNPJ(Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text))) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'CPF inválido');
        Exit;
      end;
    end;


    // Verifica o nome da pessoa
    if DBEdtNome.Text = '' then
    begin
      if Copy(DBComboTipo.Text, 1, 1) = 'F' then
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o nome.')
      else
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a razão social.');

      DBEdtNome.SetFocus;
      Exit;
    end;

    // Valida email
    // Verifica o nome da pessoa
    if DBEditEmailGeral.Text <> '' then
    begin
      if ControleFuncoes.validarDocumentoACBr(DBEditEmailGeral.Text,
                                            docEmail) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar um email correto.');

        DBEditEmailGeral.SetFocus;
      Exit;

      end;
    end;

    // Confirma os dados
    CdsCadastro.Post;
  end;

  // Pega os ids do registro
  CadastroId   := CdsCadastro.FieldByName('id').AsInteger;
  PessoaId     := CdsCadastro.FieldByName('pessoa_id').AsInteger;
  EnderecoGEId := CdsCadastro.FieldByName('geral_endereco_id').AsInteger;
  EnderecoCOId := CdsCadastro.FieldByName('comercial_endereco_id').AsInteger;
  EnderecoCBId := CdsCadastro.FieldByName('cobranca_endereco_id').AsInteger;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Inserindo o login do usuario em tabela temporaria,
    // Utilzado para auditoria
    Insere_Tabela_Temp_Login;

    // Passo 1 - Salva os dados da pessoa
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if PessoaId = 0 then
    begin
      // Gera um novo id para a pessoa
      PessoaId := GeraId('pessoa');

      // Insert
      QryAx1.SQL.Add('INSERT INTO pessoa (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       tipo,');
      QryAx1.SQL.Add('       razao_social,');
      QryAx1.SQL.Add('       nome_fantasia,');
      QryAx1.SQL.Add('       cpf_cnpj,');
      QryAx1.SQL.Add('       rg_insc_estadual,');
      QryAx1.SQL.Add('       data_expedicao_rg,');
      QryAx1.SQL.Add('       orgao_expedidor_rg,');
      QryAx1.SQL.Add('       data_nascimento,');
      QryAx1.SQL.Add('       sexo,');
      QryAx1.SQL.Add('       codigo_regime_tributario)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :tipo,');
      QryAx1.SQL.Add('       :razao_social,');
      QryAx1.SQL.Add('       :nome_fantasia,');
      QryAx1.SQL.Add('       :cpf_cnpj,');
      QryAx1.SQL.Add('       :rg_insc_estadual,');
      QryAx1.SQL.Add('       :data_expedicao_rg,');
      QryAx1.SQL.Add('       :orgao_expedidor_rg,');
      QryAx1.SQL.Add('       :data_nascimento,');
      QryAx1.SQL.Add('       :sexo,');
      QryAx1.SQL.Add('       :codigo_regime_tributario)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE pessoa');
      QryAx1.SQL.Add('   SET tipo               = :tipo,');
      QryAx1.SQL.Add('       razao_social       = :razao_social,');
      QryAx1.SQL.Add('       nome_fantasia      = :nome_fantasia,');
      QryAx1.SQL.Add('       cpf_cnpj           = :cpf_cnpj,');
      QryAx1.SQL.Add('       rg_insc_estadual   = :rg_insc_estadual,');
      QryAx1.SQL.Add('       data_expedicao_rg  = :data_expedicao_rg,');
      QryAx1.SQL.Add('       orgao_expedidor_rg = :orgao_expedidor_rg,');
      QryAx1.SQL.Add('       data_nascimento    = :data_nascimento,');
      QryAx1.SQL.Add('       sexo               = :sexo,');
      QryAx1.SQL.Add('       codigo_regime_tributario  = :codigo_regime_tributario');
      QryAx1.SQL.Add(' WHERE id = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value                 := PessoaId;
    QryAx1.Parameters.ParamByName('tipo').Value               := Copy(CdsCadastro.FieldByName('tipo').AsString, 1, 1);
    QryAx1.Parameters.ParamByName('razao_social').Value       := CdsCadastro.FieldByName('razao_social').AsString;
    QryAx1.Parameters.ParamByName('nome_fantasia').Value      := CdsCadastro.FieldByName('nome_fantasia').AsString;
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value           := Trim(ControleFuncoes.RemoveMascara(CdsCadastro.FieldByName('cpf_cnpj').AsString));
    QryAx1.Parameters.ParamByName('rg_insc_estadual').Value   := CdsCadastro.FieldByName('rg_insc_estadual').AsString;
    QryAx1.Parameters.ParamByName('orgao_expedidor_rg').Value := CdsCadastro.FieldByName('orgao_expedidor_rg').AsString;
    QryAx1.Parameters.ParamByName('sexo').Value               := Copy(CdsCadastro.FieldByName('sexo').AsString, 1, 1);

    if CdsCadastro.FieldByName('data_expedicao_rg').AsString <> '' then
      QryAx1.Parameters.ParamByName('data_expedicao_rg').Value := CdsCadastro.FieldByName('data_expedicao_rg').AsDateTime
    else
      QryAx1.Parameters.ParamByName('data_expedicao_rg').Value := '';

    if CdsCadastro.FieldByName('data_nascimento').AsString <> '' then
      QryAx1.Parameters.ParamByName('data_nascimento').Value := CdsCadastro.FieldByName('data_nascimento').AsDateTime
    else
      QryAx1.Parameters.ParamByName('data_nascimento').Value := '';

    QryAx1.Parameters.ParamByName('codigo_regime_tributario').Value := Copy(CdsCadastro.FieldByName('codigo_regime_tributario').AsString, 1, 1);

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

  // Passo 2 - Salva os enderecos da pessoa
  if Erro = '' then
  with ControleMainModule do
  begin
    for Endereco := 1 to 1 do
    begin
      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;

      if ((Endereco = 1) and (EnderecoGEId = 0)) or
         ((Endereco = 2) and (EnderecoCOId = 0)) or
         ((Endereco = 3) and (EnderecoCBId = 0)) then
      begin
        // Gera um novo id para o endereço
        if Endereco = 1 then
          // Endereço geral
          EnderecoGEId := GeraId('pessoa_endereco')
        else if Endereco = 2 then
          // Endereço comercial
          EnderecoCOId := GeraId('pessoa_endereco')
        else
          // Endereço de cobranca
          EnderecoCBId := GeraId('pessoa_endereco');

        // Insert
        QryAx1.SQL.Add('INSERT INTO pessoa_endereco (');
        QryAx1.SQL.Add('       id,');
        QryAx1.SQL.Add('       pessoa_id,');
        QryAx1.SQL.Add('       tipo,');
        QryAx1.SQL.Add('       logradouro,');
        QryAx1.SQL.Add('       numero,');
        QryAx1.SQL.Add('       complemento,');
        QryAx1.SQL.Add('       ponto_referencia,');
        QryAx1.SQL.Add('       cep,');
        QryAx1.SQL.Add('       bairro,');
        QryAx1.SQL.Add('       cidade_id,');
        QryAx1.SQL.Add('       nome_contato,');
        QryAx1.SQL.Add('       telefone_1,');
        QryAx1.SQL.Add('       telefone_2,');
        QryAx1.SQL.Add('       celular,');
        QryAx1.SQL.Add('       email)');
        QryAx1.SQL.Add('VALUES (');
        QryAx1.SQL.Add('       :id,');
        QryAx1.SQL.Add('       :pessoa_id,');
        QryAx1.SQL.Add('       :tipo,');
        QryAx1.SQL.Add('       :logradouro,');
        QryAx1.SQL.Add('       :numero,');
        QryAx1.SQL.Add('       :complemento,');
        QryAx1.SQL.Add('       :ponto_referencia,');
        QryAx1.SQL.Add('       :cep,');
        QryAx1.SQL.Add('       :bairro,');
        QryAx1.SQL.Add('       :cidade_id,');
        QryAx1.SQL.Add('       :nome_contato,');
        QryAx1.SQL.Add('       :telefone_1,');
        QryAx1.SQL.Add('       :telefone_2,');
        QryAx1.SQL.Add('       :celular,');
        QryAx1.SQL.Add('       :email)');
        QryAx1.Parameters.ParamByName('pessoa_id').Value := PessoaId;
      end
      else
      begin
        // Update
        QryAx1.SQL.Add('UPDATE pessoa_endereco');
        QryAx1.SQL.Add('   SET tipo             = :tipo,');
        QryAx1.SQL.Add('       logradouro       = :logradouro,');
        QryAx1.SQL.Add('       numero           = :numero,');
        QryAx1.SQL.Add('       complemento      = :complemento,');
        QryAx1.SQL.Add('       ponto_referencia = :ponto_referencia,');
        QryAx1.SQL.Add('       cep              = :cep,');
        QryAx1.SQL.Add('       bairro           = :bairro,');
        QryAx1.SQL.Add('       cidade_id        = :cidade_id,');
        QryAx1.SQL.Add('       nome_contato     = :nome_contato,');
        QryAx1.SQL.Add('       telefone_1       = :telefone_1,');
        QryAx1.SQL.Add('       telefone_2       = :telefone_2,');
        QryAx1.SQL.Add('       celular          = :celular,');
        QryAx1.SQL.Add('       email            = :email');
        QryAx1.SQL.Add(' WHERE id               = :id');
      end;

      if Endereco = 1 then
      begin
        // Endereço geral
        Tipo                                        := 'geral';
        QryAx1.Parameters.ParamByName('id').Value   := EnderecoGEId;
        QryAx1.Parameters.ParamByName('tipo').Value := 'GE';
      end
      else if Endereco = 2 then
      begin
        // Endereço comercial
        Tipo                                        := 'comercial';
        QryAx1.Parameters.ParamByName('id').Value   := EnderecoCOId;
        QryAx1.Parameters.ParamByName('tipo').Value := 'CO';
      end
      else
      begin
        // Endereço de cobrança
        Tipo                                        := 'cobranca';
        QryAx1.Parameters.ParamByName('id').Value   := EnderecoCBId;
        QryAx1.Parameters.ParamByName('tipo').Value := 'CB';
      end;

      QryAx1.Parameters.ParamByName('logradouro').Value       := CdsCadastro.FieldByName(Tipo + '_logradouro').AsString;
      QryAx1.Parameters.ParamByName('numero').Value           := CdsCadastro.FieldByName(Tipo + '_numero').AsString;
      QryAx1.Parameters.ParamByName('complemento').Value      := CdsCadastro.FieldByName(Tipo + '_complemento').AsString;
      QryAx1.Parameters.ParamByName('ponto_referencia').Value := CdsCadastro.FieldByName(Tipo + '_ponto_referencia').AsString;
      QryAx1.Parameters.ParamByName('cep').Value              := CdsCadastro.FieldByName(Tipo + '_cep').AsString;
      QryAx1.Parameters.ParamByName('bairro').Value           := CdsCadastro.FieldByName(Tipo + '_bairro').AsString;
      QryAx1.Parameters.ParamByName('nome_contato').Value     := CdsCadastro.FieldByName(Tipo + '_nome_contato').AsString;
      QryAx1.Parameters.ParamByName('telefone_1').Value       := CdsCadastro.FieldByName(Tipo + '_telefone_1').AsString;
      QryAx1.Parameters.ParamByName('telefone_2').Value       := CdsCadastro.FieldByName(Tipo + '_telefone_2').AsString;
      QryAx1.Parameters.ParamByName('celular').Value          := CdsCadastro.FieldByName(Tipo + '_celular').AsString;
      QryAx1.Parameters.ParamByName('email').Value            := CdsCadastro.FieldByName(Tipo + '_email').AsString;


      if CdsCadastro.FieldByName(Tipo + '_cidade_id').AsString <> '' then
        QryAx1.Parameters.ParamByName('cidade_id').Value := CdsCadastro.FieldByName(Tipo + '_cidade_id').AsInteger
      else
        QryAx1.Parameters.ParamByName('cidade_id').Value := '';

      try
        // Tenta salvar os dados
        QryAx1.ExecSQL;
      except
        on E: Exception do
        begin
          Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
          ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
          Break;
        end;
      end;
    end;
  end;

  // Passo 3 - Salva os dados do vendedor
  if Erro = '' then
  with ControleMainModule do
  begin
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // O id do vendedor será igual ao id da pessoa (ver modelo E/R)
      CadastroId := PessoaId;
      // Insert
      QryAx1.SQL.Add('INSERT INTO vendedor (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       ativo,');
      QryAx1.SQL.Add('       observacao)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :ativo,');
      QryAx1.SQL.Add('       :observacao)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE vendedor');
      QryAx1.SQL.Add('   SET ativo      = :ativo,');
      QryAx1.SQL.Add('       observacao = :observacao');
      QryAx1.SQL.Add(' WHERE id         = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value         := CadastroId;
    QryAx1.Parameters.ParamByName('ativo').Value      := Copy(CdsCadastro.FieldByName('ativo').AsString, 1, 1);
    QryAx1.Parameters.ParamByName('observacao').Value := CdsCadastro.FieldByName('observacao').AsString;

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
    ControleMainModule.MensageiroSweetAlerta('Atenção','Falha ao salvar os dados.');
  end
  else
  begin
    // Confirma a transação
    ControleMainModule.ADOConnection.CommitTrans;

    // Verifica se o dono é um formulário de consulta, e se o botão Confirmar do
    // formulário de consulta está visível.
   { if (Owner <> nil) and (Owner is TControleConsulta) and
      (TControleConsulta(Owner).BotaoConfirmar.Visible) then
    begin
      // Fecha e confirma que o registro atual foi salvo.
      // Isso é necessário para que o formulário de consulta carregue o registro
      // que foi salvo e execute o botão Confirmar automáticamente.
      ModalResult := mrOk;
    end;}

    // Recarrega o registro
    Abrir(CadastroId);
    Result := True;
  end;
end;

procedure TControleCadastroVendedor.UniFormShow(Sender: TObject);
begin
  inherited;
  UniPagePrincipal.Pages[1].Visible := False;
  UniPagePrincipal.Pages[2].Visible := False;
  UniPagePrincipal.ActivePageIndex := 0;
end;

function TControleCadastroVendedor.Descartar: Boolean;
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

procedure TControleCadastroVendedor.ConfiguraTipoPessoa;
begin
  if Copy(DBComboTipo.Text, 1, 1) = 'F' then
  begin
    // Pessoa Física
    LabelNomeRazao.Caption       := 'Nome';
    LabelCpfCnpj.Caption         := 'CPF';
    LabelPopularFantasia.Caption := 'Nome papular';
    LabelRgIe.Caption            := 'RG';

    LabelNascimento.Font.Color   := clBlack;
    LabelSexo.Font.Color         := clBlack;
    DbComboCRT.Font.Color        := clSilver;
    LabelDataExped.Font.Color    := clBlack;
    LabelOrgaoExped.Font.Color   := clBlack;

    DBEdtNascimento.Enabled      := True;
    DBComboSexo.Enabled          := True;
    DbComboCRT.Enabled           := False;
    DBEdtDataExped.Enabled       := True;
    DBEdtOrgaoExped.Enabled      := True;

    if CdsCadastro.State in [dsInsert, dsEdit] then
      CdsCadastro['tipo'] := 'FÍSICA';

   // UniSession.JSCode('$("#' + DBEdtCpfCnpj.JSName + '_id-inputEl").inputmask("999.999.999-99");');
  end
  else
  begin
    // Pessoa Jurídica
    LabelNomeRazao.Caption       := 'Razão social';
    LabelCpfCnpj.Caption         := 'CNPJ';
    LabelPopularFantasia.Caption := 'Nome fantasia';
    LabelRgIe.Caption            := 'Inscrição estadual';

    LabelNascimento.Font.Color   := clSilver;
    LabelSexo.Font.Color         := clSilver;
    DbComboCRT.Font.Color        := clBlack;
    LabelDataExped.Font.Color    := clSilver;
    LabelOrgaoExped.Font.Color   := clSilver;

    DBEdtNascimento.Enabled      := False;
    DBComboSexo.Enabled          := False;
    DbComboCRT.Enabled           := True;
    DBEdtDataExped.Enabled       := False;
    DBEdtOrgaoExped.Enabled      := False;


    if CdsCadastro.State in [dsInsert, dsEdit] then
      CdsCadastro['tipo'] := 'JURÍDICA';

   // UniSession.JSCode('$("#' + DBEdtCpfCnpj.JSName + '_id-inputEl").inputmask("99.999.999/9999-99");');
  end;
end;


end.
