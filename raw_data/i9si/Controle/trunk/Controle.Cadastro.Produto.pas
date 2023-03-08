unit Controle.Cadastro.Produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro,  ACBrBase,
  ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel, uniEdit, uniDBEdit, uniRadioGroup,
  uniDBRadioGroup, uniGroupBox, uniPageControl, uniBasicGrid, uniDBGrid,
  uniMultiItem, uniComboBox, uniDBComboBox, uniMemo, Clipbrd, uniSweetAlert;

type
  TControleCadastroProduto = class(TControleCadastro)
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    QryCadastroNCM: TWideStringField;
    QryCadastroCEST: TWideStringField;
    QryCadastroPRODUTO_FILIAL_ID: TFloatField;
    QryCadastroPRECO_VENDA: TFloatField;
    QryCadastroSALDO_OPERACIONAL: TFloatField;
    QryCadastroICMS_CST: TWideStringField;
    QryCadastroICMS_ALIQUOTA: TFloatField;
    QryCadastroATIVO: TWideStringField;
    QryCadastroPRECO_COMPRA: TFloatField;
    QryCadastroPRECO_CUSTO: TFloatField;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO: TWideStringField;
    CdsCadastroNCM: TWideStringField;
    CdsCadastroCEST: TWideStringField;
    CdsCadastroPRODUTO_FILIAL_ID: TFloatField;
    CdsCadastroPRECO_VENDA: TFloatField;
    CdsCadastroSALDO_OPERACIONAL: TFloatField;
    CdsCadastroICMS_ALIQUOTA: TFloatField;
    CdsCadastroATIVO: TWideStringField;
    CdsCadastroPRECO_COMPRA: TFloatField;
    CdsCadastroPRECO_CUSTO: TFloatField;
    UniPageControlPrincipal: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet6: TUniTabSheet;
    UniPanel10: TUniPanel;
    UniLabel1: TUniLabel;
    DBEdtNome: TUniDBEdit;
    UniLabel3: TUniLabel;
    DBCategoria: TUniDBEdit;
    BotaoPesquisaPessoa: TUniSpeedButton;
    UniLabel5: TUniLabel;
    UniPanel11: TUniPanel;
    UniLabel11: TUniLabel;
    UniDBEdit4: TUniDBEdit;
    UniDBEdit3: TUniDBEdit;
    UniDBEdit2: TUniDBEdit;
    UniLabel6: TUniLabel;
    UniLabel7: TUniLabel;
    UniLabel8: TUniLabel;
    UniPanel12: TUniPanel;
    UniLabel9: TUniLabel;
    UniDBEdit5: TUniDBEdit;
    UniDBEdit6: TUniDBEdit;
    UniLabel10: TUniLabel;
    UniLabel12: TUniLabel;
    QryCadastroCATEGORIA_ID: TFloatField;
    QryCadastroCATEGORIA: TWideStringField;
    CdsCadastroCATEGORIA_ID: TFloatField;
    CdsCadastroCATEGORIA: TWideStringField;
    UniTabSheet7: TUniTabSheet;
    UniPageControlComplemento: TUniPageControl;
    UniTabSheet2: TUniTabSheet;
    UniPanel5: TUniPanel;
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    UniButton3: TUniButton;
    GrdResultado: TUniDBGrid;
    UniLabel2: TUniLabel;
    UniDBEdit1: TUniDBEdit;
    UniLabel4: TUniLabel;
    UniDBEdtOrigem: TUniDBComboBox;
    UniLabel13: TUniLabel;
    DBEdtNCM: TUniDBEdit;
    UniLabel14: TUniLabel;
    DBEdtCest: TUniDBEdit;
    QryCadastroORIGEM: TWideStringField;
    CdsCadastroICMS_CST: TWideStringField;
    CdsCadastroORIGEM: TWideStringField;
    BotaoPesquisaNCM: TUniSpeedButton;
    UniLabel15: TUniLabel;
    UniDBEdit9: TUniDBEdit;
    UniLabel16: TUniLabel;
    UniDBEdtPesoBruto: TUniDBEdit;
    BotaoPesquisaCest: TUniSpeedButton;
    QryCadastroPESO_LIQUIDO: TFloatField;
    QryCadastroPESO_BRUTO: TFloatField;
    CdsCadastroPESO_LIQUIDO: TFloatField;
    CdsCadastroPESO_BRUTO: TFloatField;
    UniLabel17: TUniLabel;
    QryCadastroUTILIZACAO: TWideStringField;
    CdsCadastroUTILIZACAO: TWideStringField;
    procedure UniEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure BotaoPesquisaPessoaClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure BotaoPesquisaCestClick(Sender: TObject);
    procedure BotaoPesquisaNCMClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
{    function Novo(): Boolean; override;  }
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
//    function Descartar: Boolean; override;}
  end;


function ControleCadastroProduto: TControleCadastroProduto;

implementation

{$R *.dfm}



uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes,
  Controle.Consulta.Modal.TreeView.ProdutoCategoria, Winapi.ShellAPI,
   Controle.Main;

function ControleCadastroProduto: TControleCadastroProduto;
begin
  Result := TControleCadastroProduto(ControleMainModule.GetFormInstance(TControleCadastroProduto));
end;

function TControleCadastroProduto.Abrir(Id: Integer): Boolean;
begin
  inherited;

  Result := False;

  // Abre o registro solicitado
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('filial_id').Value := ControleMainModule.FFilial;
  QryCadastro.Parameters.ParamByName('id').Value        := Id;
  CdsCadastro.Open;

{    CdsEmbalagem.Close;
    QryEmbalagem.Parameters.ParamByName('filial_id').Value  := BaseDados.Filial.Id;
    QryEmbalagem.Parameters.ParamByName('produto_id').Value := Id;
    CdsEmbalagem.Open;

    CdsPreco.Close;
    QryPreco.Parameters.ParamByName('filial_id').Value  := BaseDados.Filial.Id;
    QryPreco.Parameters.ParamByName('produto_id').Value := Id;
    CdsPreco.Open;

    CdsMovimento.Close;
    QryMovimento.Parameters.ParamByName('filial_id').Value  := BaseDados.Filial.Id;
    QryMovimento.Parameters.ParamByName('produto_id').Value := Id;
    CdsMovimento.Open;

    CdsFornecedor.Close;
    QryFornecedor.Parameters.ParamByName('filial_id').Value  := BaseDados.Filial.Id;
    QryFornecedor.Parameters.ParamByName('produto_id').Value := Id;
    CdsFornecedor.Open;}

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  Result := True;
end;

procedure TControleCadastroProduto.BotaoPesquisaCestClick(Sender: TObject);
begin
  inherited;
  ShellExecute(Handle,'open','https://www.codigocest.com.br/',nil,nil,SW_ShowNormal);
end;

procedure TControleCadastroProduto.BotaoPesquisaNCMClick(Sender: TObject);
begin
  inherited;
  ShellExecute(Handle,'open','https://portalunico.siscomex.gov.br/classif/#/sumario?perfil=publico',nil,nil,SW_ShowNormal);
end;

procedure TControleCadastroProduto.BotaoPesquisaPessoaClick(Sender: TObject);
begin
  inherited;
  // Abre o formulário em modal e aguarda
  ControleConsultaModalTreeViewProdutoCategorias.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      // Pega o id da pessoa selecionada
      CdsCadastroCategoria_id.AsInteger := ControleConsultaModalTreeViewProdutoCategorias.CdsConsulta.FieldByName('id').AsInteger;
      CdsCadastroCategoria.AsString     := ControleConsultaModalTreeViewProdutoCategorias.CdsConsulta.FieldByName('descricao_categoria_rec').AsString;
    end;
  end);
end;

function TControleCadastroProduto.Editar(Id: Integer): Boolean;
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

    Result := True;
  end;
end;

function TControleCadastroProduto.Salvar: Boolean;
var
  Erro: String;
  ProdutoFilialId: Integer;
begin
  inherited;

  Result := False;

 { with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Verifica a VARIAVEL01
      if Trim(DBEdtNome.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário infomar a descrição produto');
        Exit;
      end;

      // Verificando o tamanho do ncm
      if DBEdtNCM.Text <> '' then
      begin
        if Length(ControleFuncoes.RemoveMascara(Trim(DBEdtNCM.Text))) <> 8 then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar um ncm com 8 caracteres!');
          Exit;
        end;
      end
      else
      begin
        with AlertaCadastro do
        begin
          QuestionBasic('Atenção',
                        procedure(const ButtonClicked: TAButton)
                        begin
                          if ButtonClicked = abConfirm then
                          begin
                            Close;
                          end
                          else if ButtonClicked = abCancel then
                          begin
                            ScreenMask.Hide;
                            uniPageControlPrincipal.ActivePageIndex := 1;
                            DBEdtNCM.SetFocus;
                          end;
                        end,
                        'O produto está sem o NCM, não será possível emitir a NFe/NFCe do mesmo. <br> <br> Deseja cadastrar mesmo assim?'
                        );
        end;
        Exit;
      end;

      // Verificando o tamanho do ncm
      if DBEdtNCM.Text <> '' then
      begin
        // Validando o código NCM
        if Controlefuncoes.ConsultaNCM(ControleFuncoes.RemoveMascara(Trim(DBEdtNCM.Text))) = False then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção','NCM inválido!');
          Exit;
        end;
      end;

      if DBEdtCest.Text <> '' then
      begin
        // Verificando o tamanho do cest
        if Length(ControleFuncoes.RemoveMascara(Trim(DBEdtCest.Text))) <> 7 then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar um cest com 7 caracteres!');
          Exit;
        end;
      end;

      if DBEdtCest.Text <> '' then
      begin
        // Validando o código Cest
        if Controlefuncoes.ConsultaNCM(ControleFuncoes.RemoveMascara(Trim(DBEdtCest.Text))) = False then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção','Cest inválido!');
          Exit;
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

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a tabela produto
      CadastroId := GeraId('produto');
      // Insert
      QryAx1.SQL.Add('INSERT INTO produto (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao,');
      QryAx1.SQL.Add('       ippt,');
      QryAx1.SQL.Add('       categoria_id,');
      QryAx1.SQL.Add('       origem,');
      QryAx1.SQL.Add('       cest,');
      QryAx1.SQL.Add('       ncm,');
      QryAx1.SQL.Add('       peso_liquido,');
      QryAx1.SQL.Add('       peso_bruto)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao,');
      QryAx1.SQL.Add('       :ippt,');
      QryAx1.SQL.Add('       :categoria_id,');
      QryAx1.SQL.Add('       :origem,');
      QryAx1.SQL.Add('       :cest,');
      QryAx1.SQL.Add('       :ncm,');
      QryAx1.SQL.Add('       :peso_liquido,');
      QryAx1.SQL.Add('       :peso_bruto)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE produto SET');
      QryAx1.SQL.Add('       descricao    = :descricao,');
      QryAx1.SQL.Add('       ippt         = :ippt,');
      QryAx1.SQL.Add('       categoria_id = :categoria_id,');
      QryAx1.SQL.Add('       origem       = :origem,');
      QryAx1.SQL.Add('       cest         = :cest,');
      QryAx1.SQL.Add('       ncm          = :ncm,');
      QryAx1.SQL.Add('       peso_liquido = :peso_liquido,');
      QryAx1.SQL.Add('       peso_bruto   = :peso_bruto)');
      QryAx1.SQL.Add(' WHERE id          = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value       := CdsCadastro.FieldByName('descricao').AsString;
    if TogFabricacao.Toggled = false then
      QryAx1.Parameters.ParamByName('ippt').Value       := 'T'
    else
      QryAx1.Parameters.ParamByName('ippt').Value       := 'P';
    QryAx1.Parameters.ParamByName('categoria_id').Value       := CdsCadastro.FieldByName('categoria_id').AsString;
    QryAx1.Parameters.ParamByName('origem').Value       := CdsCadastro.FieldByName('origem').AsString;
    QryAx1.Parameters.ParamByName('cest').Value       := ControleFuncoes.RemoveMascara(Trim(CdsCadastro.FieldByName('cest').AsString));
    QryAx1.Parameters.ParamByName('ncm').Value       := ControleFuncoes.RemoveMascara(Trim(CdsCadastro.FieldByName('ncm').AsString));
    QryAx1.Parameters.ParamByName('peso_bruto').Value       := CdsCadastro.FieldByName('peso_bruto').AsString;
    QryAx1.Parameters.ParamByName('peso_liquido').Value       := CdsCadastro.FieldByName('peso_liquido').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := e.Message;
      end;
    end;

    if Erro = '' then
    begin
      // Gera um novo id para o registro
      ProdutoFilialId := GeraId('produto_filial');

      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;
      QryAx1.SQL.Add('INSERT INTO produto_filial (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       filial_id,');
      QryAx1.SQL.Add('       produto_id,');
      QryAx1.SQL.Add('       preco_compra,');
      QryAx1.SQL.Add('       preco_custo,');
      QryAx1.SQL.Add('       preco_venda,');
      QryAx1.SQL.Add('       saldo_estoque,');
      QryAx1.SQL.Add('       saldo_operacional,');
      QryAx1.SQL.Add('       icms_cst,');
      QryAx1.SQL.Add('       icms_aliquota,');
      QryAx1.SQL.Add('       icms_reducao_bc,');
      QryAx1.SQL.Add('       base_reducao_cheia,');
      QryAx1.SQL.Add('       ativo)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :filial_id,');
      QryAx1.SQL.Add('       :produto_id,');
      QryAx1.SQL.Add('       :preco_compra,');
      QryAx1.SQL.Add('       :preco_custo,');
      QryAx1.SQL.Add('       :preco_venda,');
      QryAx1.SQL.Add('       :saldo_estoque,');
      QryAx1.SQL.Add('       :saldo_operacional,');
      QryAx1.SQL.Add('       :icms_cst,');
      QryAx1.SQL.Add('       :icms_aliquota,');
      QryAx1.SQL.Add('       :icms_reducao_bc,');
      QryAx1.SQL.Add('       :base_reducao_cheia,');
      QryAx1.SQL.Add('       :ativo)');


      QryAx1.Parameters.ParamByName('id').Value             := ProdutoFilialId;
      QryAx1.Parameters.ParamByName('filial_id').Value      := CdsAx1.FieldByName('id').AsInteger;
      QryAx1.Parameters.ParamByName('produto_id').Value     := CadastroId;
      QryAx1.Parameters.ParamByName('preco_compra').Value   := StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('preco_compra').AsString,0);
      QryAx1.Parameters.ParamByName('preco_custo').Value    := StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('preco_custo').AsString,0);
      QryAx1.Parameters.ParamByName('preco_venda').Value    := StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('preco_venda').AsString,0);
      QryAx1.Parameters.ParamByName('saldo_estoque').Value  := StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('saldo_operacional').AsString,0);
      QryAx1.Parameters.ParamByName('saldo_operacional').Value := StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('saldo_operacional').AsString,0);
      QryAx1.Parameters.ParamByName('icms_cst').Value       := StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('icms_cst').AsString,0);
      QryAx1.Parameters.ParamByName('icms_aliquota').Value  := StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('icms_aliquota').AsString,0);
      QryAx1.Parameters.ParamByName('base_reducao_cheia').Value  := PDVeProdutoDados.CdsCadastro.FieldByName('base_reducao_cheia').AsString;
      if StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('icms_cst').AsString,0) = 20 then
      begin
        QryAx1.Parameters.ParamByName('icms_reducao_bc').Value  := StrToFloatDef(PDVeProdutoDados.CdsCadastro.FieldByName('icms_reducao_bc').AsString,0);
      end
      else
      begin
        QryAx1.Parameters.ParamByName('icms_reducao_bc').Value  := 0;
      end;
      QryAx1.Parameters.ParamByName('ativo').Value          := Copy(PDVeProdutoDados.CdsCadastro.FieldByName('ativo').AsString, 1, 1);


        if TogAtivo.Toggled = false then
      QryAx1.Parameters.ParamByName('ativo').Value      := 'N'
    else
      QryAx1.Parameters.ParamByName('ippt').Value       := 'S';

      try
        // Tenta salvar os dados
        QryAx1.ExecSQL;
      except
        on E: Exception do
        begin
          // Descarta a transação
          ADOConnection.RollbackTrans;
          ControleMainModule.MensageiroSweetAlerta('Atençao','Não foi possível salvar os dados alterados');
          CdsCadastro.Edit;

          Exit;
        end;
      end;
    end;

    // Confirma a transação
    ADOConnection.CommitTrans;

    // Recarrega o registro
    Abrir(CadastroId);
    Result := True;
  end;     }
end;

procedure TControleCadastroProduto.UniEdit1KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
//  if NOT (Key in ['0'..'9', 8, 9]) then
//      key := 0;
end;

procedure TControleCadastroProduto.UniFormShow(Sender: TObject);
begin
  inherited;
  UniPageControlPrincipal.ActivePageIndex := 0;
  UniPageControlComplemento.ActivePageIndex := 0;
  Self.Width  := 825;
  Self.Height := 335;

  {if CdsCadastroUTILIZACAO.AsString = 'P' then
    TogFabricacao.Toggled := True
  else if CdsCadastroUTILIZACAO.AsString = 'T' then
    TogFabricacao.Toggled := True;

  if CdsCadastroATIVO.AsString = 'S' then
    TogFabricacao.Toggled := True
  else if CdsCadastroATIVO.AsString = 'N' then
    TogFabricacao.Toggled := True;  }
end;

end.
