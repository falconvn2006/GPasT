unit Controle.Gera.Primeiro.Titulo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Vcl.Imaging.pngimage, uniGUIBaseClasses, uniImage,
  uniLabel, uniEdit, uniDBEdit, uniPanel, uniPageControl, uniButton, uniBitBtn,
  uniSpeedButton, uniGroupBox;

type
  TControleGeraPrimeiroTitulo = class(TUniForm)
    UniLabel1: TUniLabel;
    UniImageFase1: TUniImage;
    UniImageFase2: TUniImage;
    UniPageControlCentral: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniDBEdit2: TUniDBEdit;
    UniDBEdit1: TUniDBEdit;
    UniGroupBox1: TUniGroupBox;
    UniLabel7: TUniLabel;
    DBEditCepGeral: TUniDBEdit;
    BotaoCEP: TUniSpeedButton;
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
    BtGratis: TUniButton;
    procedure UniPageControlCentralChange(Sender: TObject);
  private
    Procedure AtualizaFase(PageControl: TUniPageControl);
    function Salvar: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleGeraPrimeiroTitulo: TControleGeraPrimeiroTitulo;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleGeraPrimeiroTitulo: TControleGeraPrimeiroTitulo;
begin
  Result := TControleGeraPrimeiroTitulo(ControleMainModule.GetFormInstance(TControleGeraPrimeiroTitulo));
end;

Procedure TControleGeraPrimeiroTitulo.AtualizaFase(PageControl: TUniPageControl);
begin
  if PageControl.ActivePageIndex = 0 then
  begin
    UniImageFase1.Visible := True;
    UniImageFase2.Visible := False;
  end
  else if PageControl.ActivePageIndex = 1 then
  begin
    UniImageFase1.Visible := False;
    UniImageFase2.Visible := True;
  end;
end;

procedure TControleGeraPrimeiroTitulo.UniPageControlCentralChange(
  Sender: TObject);
begin
  AtualizaFase(uniPageControlCentral);
end;

function TControleGeraPrimeiroTitulo.Salvar: Boolean;
Var
  PessoaId, EnderecoId, Endereco: Integer;
  Erro: String;
begin
  inherited;

  Erro   := '';
  Result := False;

  {if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    if Length(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = 14 then
    begin
      tipo_pessoa := 'J';

      // Verifica o CNPJ
      if Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = '' then
      begin
        if ControleFuncoes.ValidaCNPJ(Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text))) = False then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção','CPF inválido!');
          Exit;
        end;


        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar o CNPJ.');

        if not DBEdtCpfCnpj.ReadOnly then
          DBEdtCpfCnpj.SetFocus;
        Exit;
      end;
    end
    else if Length(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = 11 then
    begin
      tipo_pessoa := 'F';

      // Valida CNPJ/CPF
      if ControleFuncoes.ValidaCPF(Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text))) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','CPF inválido!');
        Exit;
      end;
    end
    else
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção','Preencha um CPF ou CNPJ válido!');
      Exit;
    end;

    // Verifica o nome da pessoa
    if DBEdtNome.Text = '' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar a razão social.');

      DBEdtNome.SetFocus;
      Exit;
    end;

    // Valida email
    // Verifica o nome da pessoa
    if DBEditEmailGeral.Text <> '' then
    begin
      if ControleFuncoes.validarDocumentoACBr(DBEditEmailGeral.Text,
                                            docEmail)  = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar um email correto.');

        DBEditEmailGeral.SetFocus;
      Exit;

      end;
    end;
  end;

  // Pega os ids do registro
  CadastroId   := CdsCadastro.FieldByName('id').AsInteger;
  PessoaId     := CdsCadastro.FieldByName('pessoa_id').AsInteger;
  EnderecoId   := CdsCadastro.FieldByName('geral_endereco_id').AsInteger;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

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
      QryAx1.SQL.Add('       insc_substituicao,');
      QryAx1.SQL.Add('       insc_municipal,');
      QryAx1.SQL.Add('       codigo_regime_tributario)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :tipo,');
      QryAx1.SQL.Add('       :razao_social,');
      QryAx1.SQL.Add('       :nome_fantasia,');
      QryAx1.SQL.Add('       :cpf_cnpj,');
      QryAx1.SQL.Add('       :rg_insc_estadual,');
      QryAx1.SQL.Add('       :insc_substituicao,');
      QryAx1.SQL.Add('       :insc_municipal,');
      QryAx1.SQL.Add('       codigo_regime_tributario)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE pessoa');
      QryAx1.SQL.Add('   SET tipo              = :tipo,');
      QryAx1.SQL.Add('       razao_social      = :razao_social,');
      QryAx1.SQL.Add('       nome_fantasia     = :nome_fantasia,');
      QryAx1.SQL.Add('       cpf_cnpj          = :cpf_cnpj,');
      QryAx1.SQL.Add('       rg_insc_estadual  = :rg_insc_estadual,');
      QryAx1.SQL.Add('       insc_substituicao = :insc_substituicao,');
      QryAx1.SQL.Add('       insc_municipal    = :insc_municipal,');
      QryAx1.SQL.Add('       codigo_regime_tributario  = :codigo_regime_tributario');
      QryAx1.SQL.Add(' WHERE id                = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value                      := PessoaId;
    QryAx1.Parameters.ParamByName('tipo').Value                    := tipo_pessoa;
    QryAx1.Parameters.ParamByName('razao_social').Value            := CdsCadastro.FieldByName('razao_social').AsString;
    QryAx1.Parameters.ParamByName('nome_fantasia').Value           := CdsCadastro.FieldByName('nome_fantasia').AsString;
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value                := Trim(ControleFuncoes.RemoveMascara(CdsCadastro.FieldByName('cpf_cnpj').AsString));
    QryAx1.Parameters.ParamByName('rg_insc_estadual').Value        := CdsCadastro.FieldByName('rg_insc_estadual').AsString;
    QryAx1.Parameters.ParamByName('insc_substituicao').Value       := CdsCadastro.FieldByName('insc_substituicao').AsString;
    QryAx1.Parameters.ParamByName('insc_municipal').Value          := CdsCadastro.FieldByName('insc_municipal').AsString;
    QryAx1.Parameters.ParamByName('codigo_regime_tributario').Value:= Copy(CdsCadastro.FieldByName('codigo_regime_tributario').AsString, 1, 1);

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

      if EnderecoId = 0 then
      begin
        // Gera um novo id para o endereço
        EnderecoId := GeraId('pessoa_endereco');

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

      QryAx1.Parameters.ParamByName('id').Value               := EnderecoId;
      QryAx1.Parameters.ParamByName('tipo').Value             := 'GE';
      QryAx1.Parameters.ParamByName('logradouro').Value       := CdsCadastro.FieldByName('geral_logradouro').AsString;
      QryAx1.Parameters.ParamByName('numero').Value           := CdsCadastro.FieldByName('geral_numero').AsString;
      QryAx1.Parameters.ParamByName('complemento').Value      := CdsCadastro.FieldByName('geral_complemento').AsString;
      QryAx1.Parameters.ParamByName('ponto_referencia').Value := CdsCadastro.FieldByName('geral_ponto_referencia').AsString;
      QryAx1.Parameters.ParamByName('cep').Value              := CdsCadastro.FieldByName('geral_cep').AsString;
      QryAx1.Parameters.ParamByName('bairro').Value           := CdsCadastro.FieldByName('geral_bairro').AsString;
      QryAx1.Parameters.ParamByName('nome_contato').Value     := CdsCadastro.FieldByName('geral_nome_contato').AsString;
      QryAx1.Parameters.ParamByName('telefone_1').Value       := CdsCadastro.FieldByName('geral_telefone_1').AsString;
      QryAx1.Parameters.ParamByName('telefone_2').Value       := CdsCadastro.FieldByName('geral_telefone_2').AsString;
      QryAx1.Parameters.ParamByName('celular').Value          := CdsCadastro.FieldByName('geral_celular').AsString;
      QryAx1.Parameters.ParamByName('email').Value            := CdsCadastro.FieldByName('geral_email').AsString;

      if CdsCadastro.FieldByName('geral_cidade_id').AsString <> '' then
        QryAx1.Parameters.ParamByName('cidade_id').Value := CdsCadastro.FieldByName('geral_cidade_id').AsInteger
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

  // Passo 3 - Salva os dados do filial
  if Erro = '' then
  with ControleMainModule do
  begin
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // O id do filial será igual ao id da pessoa (ver modelo E/R)
      CadastroId := PessoaId;
      // Insert
      QryAx1.SQL.Add('INSERT INTO filial (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       ativo,');
      QryAx1.SQL.Add('       logomarca_caminho)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :ativo,');
      QryAx1.SQL.Add('       :logomarca_caminho)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE filial');
      QryAx1.SQL.Add('   SET ativo      = :ativo,');
      QryAx1.SQL.Add('       logomarca_caminho = :logomarca_caminho');
      QryAx1.SQL.Add(' WHERE id         = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value         := CadastroId;
    QryAx1.Parameters.ParamByName('ativo').Value      := Copy(CdsCadastro.FieldByName('ativo').AsString, 1, 1);
    QryAx1.Parameters.ParamByName('logomarca_caminho').Value := URL_LOGO_FILIAL;

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
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Falha ao salvar os dados.');
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
  //  Abrir(CadastroId);

    //é melhor colocar a imagem na tabela cliente, assim nao precisa recarregar a tabela filial

    // UniMainModule.SelecionaFilial(UniMainModule.CdsFilial.FieldByName('id').AsInteger);
   // Result := True;
//  end;
end;

end.
