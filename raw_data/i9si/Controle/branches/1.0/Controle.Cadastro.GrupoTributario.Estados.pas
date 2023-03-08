unit Controle.Cadastro.GrupoTributario.Estados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, uniSweetAlert, ACBrBase,
  ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel, uniDBEdit, uniDBComboBox, uniEdit,
  uniMultiItem, uniComboBox, uniDBLookupComboBox;

type
  TControleCadastroGrupoTributarioEstados = class(TControleCadastro)
    QryCadastroID: TFloatField;
    QryCadastroESTADO_ID: TFloatField;
    QryCadastroCFOP: TWideStringField;
    QryCadastroICMS_SITUACAO_TRIBUTARIA: TWideStringField;
    QryCadastroICMS_ALIQUOTA_INTERESTADUAL: TFloatField;
    QryCadastroICMS_ALIQUOTA_MVA_ST: TFloatField;
    QryCadastroICMS_ALIQUOTA_ST: TFloatField;
    QryCadastroGRUPO_TRIBUTOS_ID: TFloatField;
    CdsCadastroID: TFloatField;
    CdsCadastroESTADO_ID: TFloatField;
    CdsCadastroCFOP: TWideStringField;
    CdsCadastroICMS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroICMS_ALIQUOTA_INTERESTADUAL: TFloatField;
    CdsCadastroICMS_ALIQUOTA_MVA_ST: TFloatField;
    CdsCadastroICMS_ALIQUOTA_ST: TFloatField;
    CdsCadastroGRUPO_TRIBUTOS_ID: TFloatField;
    UniDBEdit1: TUniDBEdit;
    UniDBComboICMSCst_tp01: TUniDBComboBox;
    UniDBFormatted_tp05: TUniDBFormattedNumberEdit;
    UniDBFormattedNumberEdit1: TUniDBFormattedNumberEdit;
    UniDBFormattedNumberEdit2: TUniDBFormattedNumberEdit;
    UniDBLookupComboBox1: TUniDBLookupComboBox;
    DspEstados: TDataSetProvider;
    CdsEstados: TClientDataSet;
    QryEstados: TADOQuery;
    DscEstados: TDataSource;
    CdsEstadosID: TFMTBCDField;
    CdsEstadosUF: TWideStringField;
    procedure UniFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    grupo_tributos_id : integer;
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroGrupoTributarioEstados: TControleCadastroGrupoTributarioEstados;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleCadastroGrupoTributarioEstados: TControleCadastroGrupoTributarioEstados;
begin
  Result := TControleCadastroGrupoTributarioEstados(ControleMainModule.GetFormInstance(TControleCadastroGrupoTributarioEstados));
end;

{ TControleCadastroGrupoTributarioEstados }

function TControleCadastroGrupoTributarioEstados.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  CdsEstados.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  Result := True;
end;

function TControleCadastroGrupoTributarioEstados.Descartar: Boolean;
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

function TControleCadastroGrupoTributarioEstados.Editar(Id: Integer): Boolean;
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

function TControleCadastroGrupoTributarioEstados.Novo: Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;

    CdsCadastroICMS_ALIQUOTA_ST.AsFloat := 0;
    CdsCadastroICMS_ALIQUOTA_MVA_ST.AsFloat := 0;
    CdsCadastroICMS_ALIQUOTA_INTERESTADUAL.AsFloat := 0;

    Result := True;
  end;
end;

function TControleCadastroGrupoTributarioEstados.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Verifica a VARIAVEL01
    {  if Trim(DBEdtNome.Text) = '' then
      begin
        MessageDlg('É necessário informar VARIAVEL01.'^M''+ 'Dados incompletos', mtWarning, [mbOK]);
        DBEdtNome.SetFocus;
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

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a tabela grupo_tributos_variacao_uf
      CadastroId := GeraId('grupo_tributos_variacao_uf');
      // Insert
      QryAx1.SQL.Text :=
                           'INSERT INTO grupo_tributos_variacao_uf ('
                         + ' id,'
                         + ' estado_id,'
                         + ' cfop,'
                         + ' icms_situacao_tributaria,'
                         + ' icms_aliquota_interestadual,'
                         + ' icms_aliquota_mva_st,'
                         + ' icms_aliquota_st,'
                         + ' grupo_tributos_id)'
                         + 'VALUES ('
                         + ' :id,'
                         + ' :estado_id,'
                         + ' :cfop,'
                         + ' :icms_situacao_tributaria,'
                         + ' :icms_aliquota_interestadual,'
                         + ' :icms_aliquota_mva_st,'
                         + ' :icms_aliquota_st,'
                         + ' :grupo_tributos_id)';
    end
    else
    begin
      // Update
      QryAx1.SQL.Text :=
                            ' UPDATE grupo_tributos_variacao_uf SET'
                          + '        estado_id      = :estado_id,'
                          + '        cfop      = :cfop,'
                          + '        icms_situacao_tributaria      = :icms_situacao_tributaria,'
                          + '        icms_aliquota_interestadual      = :icms_aliquota_interestadual,'
                          + '        icms_aliquota_mva_st      = :icms_aliquota_mva_st,'
                          + '        icms_aliquota_st      = :icms_aliquota_st,'
                          + '        grupo_tributos_id      = :grupo_tributos_id'
                          + '  WHERE id          = :id';
    end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('estado_id').Value       := CdsCadastro.FieldByName('estado_id').AsString;
    QryAx1.Parameters.ParamByName('cfop').Value       := 'x' + Copy(CdsCadastro.FieldByName('cfop').AsString,2,3);
    QryAx1.Parameters.ParamByName('icms_situacao_tributaria').Value       := CdsCadastro.FieldByName('icms_situacao_tributaria').AsString;
    if CdsCadastro.FieldByName('icms_aliquota_interestadual').AsString = '' then
      QryAx1.Parameters.ParamByName('icms_aliquota_interestadual').Value       := '0'
    else
      QryAx1.Parameters.ParamByName('icms_aliquota_interestadual').Value       := CdsCadastro.FieldByName('icms_aliquota_interestadual').AsString;
    if CdsCadastro.FieldByName('icms_aliquota_mva_st').AsString  = '' then
      QryAx1.Parameters.ParamByName('icms_aliquota_mva_st').Value       := '0'
    else
      QryAx1.Parameters.ParamByName('icms_aliquota_mva_st').Value       := CdsCadastro.FieldByName('icms_aliquota_mva_st').AsString;
    if CdsCadastro.FieldByName('icms_aliquota_st').AsString = '' then
      QryAx1.Parameters.ParamByName('icms_aliquota_st').Value       := '0'
    else
      QryAx1.Parameters.ParamByName('icms_aliquota_st').Value       := CdsCadastro.FieldByName('icms_aliquota_st').AsString;
    QryAx1.Parameters.ParamByName('grupo_tributos_id').Value       := grupo_tributos_id;

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

    // Recarrega o registro
    Abrir(CadastroId);
    Result := True;
  end;
end;



procedure TControleCadastroGrupoTributarioEstados.UniFormShow(Sender: TObject);
begin
  inherited;
  // Se for simples - crt = 1
  if ControleMainModule.FCodigoRegimeTributario = '1' then
  begin
    UniDBComboICMSCst_tp01.Clear;
    // Simples Nacional
    with UniDBComboICMSCst_tp01 do
    begin
      Items.Add('');
      Items.Add('101 : Tributada pelo Simples Nacional com permissão de crédito');
      Items.Add('102 : Tributada pelo Simples Nacional sem permissão de crédito');
      Items.Add('103 : Isenção do ICMS no Simples Nacional para faixa de receita bruta');
      Items.Add('201 : Tributada pelo Simples Nacional com permissão de créd e com cobrança do ICMS por subst tribut');
      Items.Add('202 : Tributada pelo Simples Nacional sem permissão de créd e com cobrança do ICMS por subst tribut');
      Items.Add('203 : Isenção do ICMS no Simples Nacional com cobrança do ICMS por subst tribut');
      Items.Add('300 : Imune');
      Items.Add('400 : Não tributada pelo Simples Nacional');
      Items.Add('500 : ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação');
      Items.Add('900 :- Outro');
    end;
  end
  else if ControleMainModule.FCodigoRegimeTributario = '3' then
  begin
    // Regime normal
    UniDBComboICMSCst_tp01.Clear;
    with UniDBComboICMSCst_tp01 do
    begin
      Items.Add('');
      Items.Add('00 : Tributada integralmente');
      Items.Add('10 : Tributada e com cobrança do ICMS por substituição tributária');
      Items.Add('20 : Com redução da BC');
      Items.Add('30 : Isenta / não tributada e com cobrança do ICMS por substituição tributária');
      Items.Add('40 : Isenta');
      Items.Add('41 : Não tributada');
      Items.Add('50 : Com suspensão');
      Items.Add('51 : Com diferimento');
      Items.Add('60 : ICMS cobrado anteriormente por substituição tributária');
      Items.Add('70 : Com redução da BC e cobrança do ICMS por substituição tributária');
      Items.Add('90 : Outras');
    end;
  end;
end;

end.
