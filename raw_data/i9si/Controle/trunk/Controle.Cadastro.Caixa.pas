unit Controle.Cadastro.Caixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, ACBrBase, ACBrSocket, ACBrCEP,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniDBText, uniMultiItem, uniComboBox, uniDBComboBox,
  uniDBLookupComboBox, uniEdit, uniDBEdit, uniMemo, uniBasicGrid, uniDBGrid,
  uniPageControl, Vcl.Menus, uniMainMenu, Vcl.Imaging.pngimage, uniImage,
   uniMenuButton, uniGUIApplication, uniSweetAlert, frxClass, frxDBSet,
  Vcl.StdCtrls;

type
  TControleCadastroCaixa = class(TControleCadastro)
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniDBText1: TUniDBText;
    UniDBText2: TUniDBText;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniDBGrid1: TUniDBGrid;
    UniPanel7: TUniPanel;
    ButtonSuprimento: TUniButton;
    BotaoSangria: TUniButton;
    BotaoEstorno: TUniButton;
    BotaoFechamento: TUniButton;
    QryCadastroID: TFloatField;
    QryCadastroFILIAL_ID: TFloatField;
    QryCadastroUSUARIO_ID: TFloatField;
    QryCadastroPDV_ID: TFloatField;
    QryCadastroOPERADOR: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroFILIAL_ID: TFloatField;
    CdsCadastroUSUARIO_ID: TFloatField;
    CdsCadastroPDV_ID: TFloatField;
    CdsCadastroOPERADOR: TWideStringField;
    UniLabel4: TUniLabel;
    UniDBText3: TUniDBText;
    QryCadastroDATA_ABERTURA: TWideStringField;
    CdsCadastroDATA_ABERTURA: TWideStringField;
    QryCadastroDATA_FECHAMENTO: TWideStringField;
    CdsCadastroDATA_FECHAMENTO: TWideStringField;
    DscConsulta: TDataSource;
    CdsConsulta: TClientDataSet;
    DspConsulta: TDataSetProvider;
    QryConsulta: TADOQuery;
    QryConsultaID: TFloatField;
    QryConsultaCAIXA_ID: TFloatField;
    QryConsultaVALOR: TFloatField;
    QryConsultaOBSERVACAO: TWideStringField;
    QryConsultaFORMA_PAGAMENTO_ID: TFloatField;
    QryConsultaFORMA_PAGAMENTO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaCAIXA_ID: TFloatField;
    CdsConsultaVALOR: TFloatField;
    CdsConsultaOBSERVACAO: TWideStringField;
    CdsConsultaFORMA_PAGAMENTO_ID: TFloatField;
    CdsConsultaFORMA_PAGAMENTO: TWideStringField;
    QryConsultaOPERACAO: TWideStringField;
    QryConsultaNATUREZA: TWideStringField;
    QryConsultaDOCUMENTO: TWideStringField;
    QryConsultaDESCRICAO: TWideStringField;
    CdsConsultaOPERACAO: TWideStringField;
    CdsConsultaNATUREZA: TWideStringField;
    CdsConsultaDOCUMENTO: TWideStringField;
    CdsConsultaDESCRICAO: TWideStringField;
    UniPanel14: TUniPanel;
    UniPopupMenu1: TUniPopupMenu;
    Aberto1: TUniMenuItem;
    Liquidado1: TUniMenuItem;
    UniImageList4: TUniImageList;
    QryConsultaDATA_MOVIMENTO: TWideStringField;
    CdsConsultaDATA_MOVIMENTO: TWideStringField;
    UniPanel5: TUniPanel;
    UniPanel8: TUniPanel;
    UniPanel9: TUniPanel;
    UniLabel5: TUniLabel;
    UniLabel6: TUniLabel;
    UniLabel7: TUniLabel;
    UniImage1: TUniImage;
    UniImage3: TUniImage;
    UniImage4: TUniImage;
    UniLabelSangria: TUniLabel;
    UniLabelSuprimento: TUniLabel;
    UniLabelEstorno: TUniLabel;
    UniPanel10: TUniPanel;
    UniLabel8: TUniLabel;
    UniImage5: TUniImage;
    UniLabelPagamento: TUniLabel;
    UniPanel11: TUniPanel;
    UniLabel10: TUniLabel;
    UniLabelRecebimento: TUniLabel;
    UniImage6: TUniImage;
    UniMenuButton1: TUniMenuButton;
    UniPanel12: TUniPanel;
    QryConsultaUSUARIO_ID: TFloatField;
    CdsConsultaUSUARIO_ID: TFloatField;
    UniSweetAlertReabrirCaixa: TUniSweetAlert;
    UniSweetAlertEstornoBaixa: TUniSweetAlert;
    UniSweetAlertFecharCaixa: TUniSweetAlert;
    Conexao_Caixa: TfrxDBDataset;
    Conexao_caixa_cadastro: TfrxDBDataset;
    BotaoImprimir: TUniButton;
    Relatorio_caixa: TfrxReport;
    QryTotal: TADOQuery;
    CdsTotal: TClientDataSet;
    DspTotal: TDataSetProvider;
    QryTotalFORMA_PAGAMENTO: TWideStringField;
    QryTotalNATUREZA: TWideStringField;
    QryTotalTOTAL: TFloatField;
    CdsTotalFORMA_PAGAMENTO: TWideStringField;
    CdsTotalNATUREZA: TWideStringField;
    CdsTotalTOTAL: TFloatField;
    Conexao_caixa_total: TfrxDBDataset;
    QryConsultaSITUACAO: TWideStringField;
    CdsConsultaSITUACAO: TWideStringField;
    DspSaldo: TDataSetProvider;
    QrySaldo: TADOQuery;
    WideStringField1: TWideStringField;
    WideStringField2: TWideStringField;
    FloatField1: TFloatField;
    CdsSaldo: TClientDataSet;
    QryTotalTOTAL_SUPRIMENTO: TFloatField;
    QryTotalTOTAL_SANGRIA: TFloatField;
    QryTotalTOTAL_ESTORNO: TFloatField;
    CdsTotalTOTAL_SUPRIMENTO: TFloatField;
    CdsTotalTOTAL_SANGRIA: TFloatField;
    CdsTotalTOTAL_ESTORNO: TFloatField;
    CdsTotalSOMA_NATUREZA: TAggregateField;
    QryTotalTOTAL_RECEBIMENTO: TFloatField;
    CdsTotalTOTAL_RECEBIMENTO: TFloatField;
    QryTotalTOTAL_PAGAMENTO: TFloatField;
    CdsTotalTOTAL_PAGAMENTO: TFloatField;
    QryConsultaTITULO_PAGAMENTO_ID: TFloatField;
    CdsConsultaTITULO_PAGAMENTO_ID: TFloatField;
    QryConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    UniSweetAlertReabrirCaixaDiaAnterior: TUniSweetAlert;
    UniSweetAlert1: TUniSweetAlert;
    procedure UniFormShow(Sender: TObject);
    procedure ButtonSuprimentoClick(Sender: TObject);
    procedure CdsConsultaOPERACAOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);

    procedure BotaoSangriaClick(Sender: TObject);
    procedure BotaoEstornoClick(Sender: TObject);
    procedure BotaoFechamentoClick(Sender: TObject);
    procedure BotaoEditarClick(Sender: TObject);
    procedure UniSweetAlertReabrirCaixaConfirm(Sender: TObject);
    procedure UniSweetAlertEstornoBaixaConfirm(Sender: TObject);
    procedure UniSweetAlertFecharCaixaConfirm(Sender: TObject);
    procedure BotaoImprimirClick(Sender: TObject);
    procedure UniSweetAlertReabrirCaixaDiaAnteriorConfirm(Sender: TObject);
  private
    procedure EstornoCaixa(Sender: TComponent; AResult: Integer;
      AText: string);
    Function SomaValorPorNatureza(Caixa_id: integer;
                                                     Natureza: String;
                                                     Operacao: String): Double;
    function VerificaCaixaFechado(UsuarioId: Integer): Boolean;
    procedure SomaValores;
    function EstornaPagamentoTitulo(caixa_id: Integer;
                                                      caixa_motivo: string;
                                                      titulo_pagamento_id: Integer): Boolean;
    procedure EstornoCaixaTitulo(Sender: TComponent; AResult: Integer;
      AText: string);
    function TemPermissaoSuperior: String;
    { Private declarations }
  public
    { Public declarations }
    GestorCaixaGeral : Boolean;
    function AbrirCaixa(Id: Integer; BtEdit: Boolean = True): Boolean;
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroCaixa: TControleCadastroCaixa;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, Controle.Cadastro.Caixa.Operacao, Controle.Main,
  Controle.Funcoes, System.Math, IdHashMessageDigest, System.AnsiStrings;

function ControleCadastroCaixa: TControleCadastroCaixa;
begin
  Result := TControleCadastroCaixa(ControleMainModule.GetFormInstance(TControleCadastroCaixa));
end;

function TControleCadastroCaixa.Abrir(Id: Integer): Boolean;
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

function TControleCadastroCaixa.AbrirCaixa(Id: Integer; BtEdit: Boolean = True): Boolean;
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

  if BtEdit = False then
    BotaoEditar.Enabled := False;

  Result := True;
end;

function TControleCadastroCaixa.Editar(Id: Integer): Boolean;
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

function TControleCadastroCaixa.Novo(): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;
    CdsCadastro['filial_id']  := ControleMainModule.FFilial;
    CdsCadastro['usuario_id'] := ControleMainModule.FUsuarioId;

    Result := True;
  end;
end;

procedure TControleCadastroCaixa.BotaoEditarClick(Sender: TObject);
begin
//    // Verifica se o caixa é de hoje
//  if StrToDate(FormatDateTime('dd/mm/yyyy', CdsCadastroDATA_ABERTURA.AsDateTime)) = Date() then
//  begin
//    // Verifica se o caixa está fechado
//    if VerificaCaixaFechado(CdsCadastroID.AsInteger) = True then
//      UniSweetAlertReabrirCaixa.show
//    else
//      inherited;
//  end
//  else
//  begin
//     // Verificando se o caixa está aberto
//    if ControleMainModule.VerificaCaixaAberto(CdsCadastroID.AsInteger) = true then
//    begin
//      inherited;
//    end
//    else
//    begin
//      UniSweetAlertReabrirCaixaDiaAnterior.show;
//    end;
//  end;

  // Verifica se o caixa está fechado
  if VerificaCaixaFechado(CdsCadastroID.AsInteger) = True then
  begin
    UniSweetAlertReabrirCaixa.show(
      'Deseja reabrir o caixa do operador: '
      + CdsCadastroOPERADOR.AsString
      + ' com data de abertura: '
      + CdsCadastroDATA_ABERTURA.AsString +' ?'
    )
  end
  else
    inherited;
end;

procedure TControleCadastroCaixa.BotaoEstornoClick(Sender: TObject);
begin
  inherited;
  if CdsConsultaOPERACAO.AsString = 'E' then //E Estorno
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Esta movimentação já está estornada.');
  end
  else
  begin
    if (CdsConsultaNATUREZA.AsString = 'PAGAMENTO') or (CdsConsultaNATUREZA.AsString = 'RECEBIMENTO') then //RC Recebimento título PG Pagamento título
    begin
      UniSweetAlertEstornoBaixa.show;
    end
    else //Se o estorno não é de um título faça normal pois é Sangria e Suprimento
    begin
      With ControleMainModule do
      begin
        Prompt('Qual o motivo do estorno',
               '',
               mtConfirmation,
               mbOKCancel,
               EstornoCaixa);
      end;
    end;
  end;
end;


function TControleCadastroCaixa.EstornaPagamentoTitulo(caixa_id: Integer;
                                                      caixa_motivo: string;
                                                      titulo_pagamento_id: Integer): Boolean;
var
  titulo_id: Integer;
  error,
  situacao_titulo : string;
  ValorACancelar,
  ValorTotalDosPagamento,
  ValorTotalTitulo,
  ValorSaldo : Double;
begin
  error := '';
  Result := False;

  With ControleMainModule do
  begin
    CdsAx1.Close;
    QryAx1.SQL.Clear;
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Text :=
              '	SELECT tpa.valor_pago AS valor_do_estorno,'
              +'	       tit.id AS tituloid,'
              +'	       tit.valor AS valor_total_titulo,'
              +'	       (SELECT SUM (valor_pago) '
              +'	          FROM titulo_pagamentos '
              +'	         WHERE titulo_id = TPA.TITULO_ID) '
              +'	          AS total_pago '
              +'	  FROM titulo_pagamentos tpa INNER JOIN titulo tit ON tit.id = TPa.TITULO_ID '
              +'	 WHERE tpa.id =:id';
    QryAx1.Parameters.ParamByName('id').Value := titulo_pagamento_id;
    CdsAx1.Open;

    if CdsAx1.RecordCount > 0 then
    begin
      titulo_id               := CdsAx1.FieldByName('tituloid').AsInteger;
      ValorACancelar          := RoundTo(CdsAx1.FieldByName('valor_do_estorno').AsFloat,-2);
      ValorTotalDosPagamento  := RoundTo(CdsAx1.FieldByName('total_pago').AsFloat,-2);
      ValorTotalTitulo        := RoundTo(CdsAx1.FieldByName('valor_total_titulo').AsFloat,-2);
    end;

    if ValorTotalTitulo = ValorACancelar then
    begin
      situacao_titulo :='A';
      ValorSaldo := 0;
    end
    else
    begin
     if ValorTotalTitulo = ValorTotalDosPagamento then
     begin
       if ValorTotalDosPagamento = ValorACancelar then
       begin
         situacao_titulo :='A';
         ValorSaldo := 0;
       end
       else
       begin
         situacao_titulo :='P';
         ValorSaldo := (ValorTotalDosPagamento - ValorACancelar);
       end;
     end
     else
     begin
      ValorSaldo := (ValorTotalDosPagamento - ValorACancelar);

      if ValorSaldo = 0 then
        situacao_titulo :='A'
      else
        situacao_titulo :='P';
     end;
    end;

    //Abre a transação
    ADOConnection.BeginTrans;

    QryAx2.Parameters.Clear;
    QryAx2.SQL.Clear;

    // Estorna o movimento
    CdsAx2.Close;
    QryAx2.Parameters.Clear;
    QryAx2.SQL.Clear;
    QryAx2.SQL.Text :=
        'BEGIN'
      + '  pkg_caixa.estorna_movimento('
      + '    :caixa_movimento_id,'
      + '    :observacao);'
      + 'END;';
    QryAx2.Parameters.ParamByName('caixa_movimento_id').Value := caixa_id;
    QryAx2.Parameters.ParamByName('observacao').Value         := CdsConsultaOBSERVACAO.AsString +' '+ caixa_motivo;

    try
      // Tenta executar a operação
      QryAx2.ExecSQL;
    except
      on E: Exception do
      begin
       error := E.Message;
      end;
    end;

    if error = '' then
    begin
       //1º Deleta registro do titulo_pagamentos
      CdsAx3.Close;
      QryAx3.SQL.Clear;
      QryAx3.Parameters.Clear;

      QryAx3.SQL.Text := 'delete from titulo_pagamentos where id =:id';
      QryAx3.Parameters.ParamByName('id').Value := titulo_pagamento_id;

      try
        // Tenta salvar os dados
        QryAx3.ExecSQL;
      except
        on E: Exception do
        begin
          // Descarta a transação
          ADOConnection.RollbackTrans;
          error := E.Message;
          Exit;
        end;
      end;
    end;

    if error = '' then
    begin
      //1º Deleta registro do titulo_pagamentos
      CdsAx4.Close;
      QryAx4.SQL.Clear;
      QryAx4.Parameters.Clear;
      QryAx4.SQL.Text :=
                       'UPDATE titulo SET'
                      +'       situacao         = :situacao,'
                      +'       valor_pago       = :valor_pago,'
                      +'       valor_liquidado  = :valor_liquidado'
                      +' WHERE id               = :id';

      QryAx4.Parameters.ParamByName('situacao').Value         := situacao_titulo;
      QryAx4.Parameters.ParamByName('valor_pago').Value       := ValorSaldo;
      QryAx4.Parameters.ParamByName('valor_liquidado').Value  := ValorSaldo;
      QryAx4.Parameters.ParamByName('id').Value               := titulo_id;

      try
        // Tenta salvar os dados
        QryAx4.ExecSQL;
      except
        on E: Exception do
        begin
          // Descarta a transação
          ADOConnection.RollbackTrans;
          error := E.Message;
          Exit;
        end;
      end;
    end;

    if error = '' then
    begin
      try
       // Confirma a transação
       ADOConnection.CommitTrans;
      except
        on E: Exception do
        begin
          // Descarta a transação
          ADOConnection.RollbackTrans;
          error := E.Message;
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TControleCadastroCaixa.BotaoFechamentoClick(Sender: TObject);
begin
  UniSweetAlertFecharCaixa.show;
end;

procedure TControleCadastroCaixa.BotaoImprimirClick(Sender: TObject);
begin
  inherited;
  CdsTotal.Close;
  QryTotal.Parameters.ParamByName('id').Value := CdsCadastroID.AsInteger;
  CdsTotal.Open;

  Relatorio_caixa.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  ControleMainModule.ExportarPDF('Relatorio',Relatorio_caixa);
end;

procedure TControleCadastroCaixa.EstornoCaixa(Sender: TComponent; AResult:Integer; AText: string);
begin
  if AResult = mrOK then
  begin
    ControleMainModule.EstornaMovimentoCaixa(CdsConsultaID.AsInteger,
                                        AText);
    SomaValores;
    CdsConsulta.Refresh;
   end;
end;

procedure TControleCadastroCaixa.EstornoCaixaTitulo(Sender: TComponent; AResult:Integer; AText: string);
begin
  if AResult = mrOK then
  begin
    EstornaPagamentoTitulo(CdsConsultaID.AsInteger,
                            AText,
                            CdsConsultaTITULO_PAGAMENTO_ID.AsInteger);
    SomaValores;
    CdsConsulta.Refresh;
   end;
end;

procedure TControleCadastroCaixa.BotaoSangriaClick(Sender: TObject);
begin
  inherited;
  ControleCadastroCaixaOperacao.TipoOperacao := 'SANGRIA';
  ControleCadastroCaixaOperacao.CaixaId := CdsCadastroID.AsInteger;
  if ControleCadastroCaixaOperacao.Novo() then
  begin
    ControleCadastroCaixaOperacao.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
{      if Result = 1 then
      begin}
        SomaValores;
        CdsConsulta.Refresh;
//      end;
    end);
  end;
end;

procedure TControleCadastroCaixa.ButtonSuprimentoClick(Sender: TObject);
begin
  inherited;
  ControleCadastroCaixaOperacao.TipoOperacao := 'SUPRIMENTO';
  ControleCadastroCaixaOperacao.CaixaId := CdsCadastroID.AsInteger;
  if ControleCadastroCaixaOperacao.Novo() then
  begin
    ControleCadastroCaixaOperacao.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
{      if Result = 1 then
      begin}
        SomaValores;
        CdsConsulta.Refresh;
//      end;
    end);
  end;
end;

procedure TControleCadastroCaixa.CdsConsultaOPERACAOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  inherited;
  if Sender.AsString = 'D' then
    Text := '<img src=./files/icones/minus-circle.png height=20 align="center" />'
  else if Sender.AsString = 'C' then
    Text := '<img src=./files/icones/plus-circle.png height=20 align="center" />'
  else if Sender.AsString = 'E' then
    Text := '<img src=./files/icones/close-circle.png height=20 align="center" />';
end;

function TControleCadastroCaixa.Descartar: Boolean;
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

function TControleCadastroCaixa.Salvar: Boolean;
begin
  inherited;

  Result := False;

  // Validando os campos
  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Confirma os dados
    CdsCadastro.Post;
  end;

  // Pega o id do registro
  CadastroId := CdsCadastro.FieldByName('id').AsInteger;

  // ABERTURA//////////////////////////////////////////////////////////
  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a tabela caixa
      CadastroId := GeraId('caixa');
      // Insert
      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;
      QryAx1.SQL.Text :=
          'INSERT INTO caixa ('
        + '       id,'
        + '       filial_id,'
        + '       usuario_id,'
        + '       data_abertura)'
        + 'VALUES ('
        + '       :id,'
        + '       :filial_id,'
        + '       :usuario_id,'
        + '       SYSDATE)';
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE caixa SET');
      QryAx1.SQL.Add('       filial_id       = :filial_id,');
      QryAx1.SQL.Add('       usuario_id      = :usuario_id');
      QryAx1.SQL.Add(' WHERE id              = :id');
     end;

    QryAx1.Parameters.ParamByName('id').Value              := CadastroId;
    QryAx1.Parameters.ParamByName('filial_id').Value       := FFilial;
    QryAx1.Parameters.ParamByName('usuario_id').Value      := FUsuarioId;
   // QryAx1.Parameters.ParamByName('pdv_id').Value          := 0;// Falta aplicar

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
      // Confirma a transação
      ADOConnection.CommitTrans;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));

        Exit;
      end;
    end;
  end;

{{

SUPRIMENTO (ENTRADA)
FECHAMENTO}

 { if UniComboBoxOpcao.ItemIndex = 0 then
  begin

  end
  else if UniComboBoxOpcao.ItemIndex = 1 then
  begin

  end;

  // Pega o id do registro
  CadastroId := CdsCadastro.FieldByName('id').AsInteger;   }


  // Recarrega o registro
  Abrir(CadastroId);
  Result := True;
end;

procedure TControleCadastroCaixa.UniFormShow(Sender: TObject);
begin
  inherited;
  // Abre o registro
  CdsConsulta.Close;
  QryConsulta.Parameters.ParamByName('id').Value := CdsCadastroID.AsInteger;
  CdsConsulta.Open;

  SomaValores;
end;

procedure TControleCadastroCaixa.UniSweetAlertEstornoBaixaConfirm(
  Sender: TObject);
begin
  inherited;
  With ControleMainModule do
  begin
    Prompt('Qual o motivo do estorno',
           '',
           mtConfirmation,
           mbOKCancel,
           EstornoCaixaTitulo);
  end;
end;

procedure TControleCadastroCaixa.UniSweetAlertFecharCaixaConfirm(
  Sender: TObject);
begin
  inherited;
  ControleMainModule.FechaCaixa(CdsCadastroID.AsInteger);
  SomaValores;
  CdsCadastro.Refresh;
  BotaoImprimir.Click; //chama para imprimir caixa
end;

procedure TControleCadastroCaixa.UniSweetAlertReabrirCaixaConfirm(
  Sender: TObject);
begin
  inherited;
  //ControleMainModule.ReabreCaixa(CdsCadastroID.AsInteger);
  with ControleMainModule do
  begin
    // Inicia a transação
    if ControleMainModule.ADOConnection.InTransaction = False then
      ControleMainModule.ADOConnection.BeginTrans;

    // Reabre o caixa
    CdsAx1.Close;
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Text :=
        'UPDATE caixa'
      + '   SET data_fechamento = NULL'
      + ' WHERE id = :id';
    QryAx1.Parameters.ParamByName('id').Value := CdsCadastroID.AsInteger;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL();
      // Confirma a transação
      ADOConnection.CommitTrans;

      BotaoEditar.Click;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção',ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
    end;
  end;
end;

procedure TControleCadastroCaixa.UniSweetAlertReabrirCaixaDiaAnteriorConfirm(
  Sender: TObject);
begin
  inherited;
  case AnsiIndexStr(TemPermissaoSuperior,['P','B','N']) of
    0:begin
        ControleMainModule.ReabreCaixa(CdsCadastroID.AsInteger);
        BotaoEditar.Click;
      end;

    1:begin
         ControleMainModule.MensageiroSweetAlerta('Atenção', 'Usuário sem permissão de realizar a reabertura',atInfo);
      end;

    2:begin
         ControleMainModule.MensageiroSweetAlerta('Atenção', 'Usuário não encontrado.');
      end;
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'O retorno de suas permissões não foi bem sucedido.',atError);
  end;

end;

function TControleCadastroCaixa.VerificaCaixaFechado(UsuarioId: Integer): Boolean;// retorna o id do caixa conectado, se for 0 é caixa novo
begin
  Result := False;
  With ControleMainModule do
  begin
    CdsAx2.Close;
    QryAx2.SQL.Clear;
    QryAx2.Parameters.Clear;
    QryAx2.SQL.Add('SELECT id,');
    QryAx2.SQL.Add('       data_fechamento');
    QryAx2.SQL.Add('  FROM caixa');
    QryAx2.SQL.Add(' WHERE id = '+ IntToStr(UsuarioId) +'');
    QryAx2.SQL.Add('   AND data_fechamento IS NOT NULL');
    CdsAx2.Open;

    if CdsAx2.RecordCount > 0 then
      Result := True;
  end;
end;

Function TControleCadastroCaixa.SomaValorPorNatureza(Caixa_id: integer;
                                                     Natureza: String;
                                                     Operacao: String): Double;
begin
  Result := 0;
  With ControleMainModule do
  begin
    CdsAx2.Close;
    QryAx2.SQL.Clear;
    QryAx2.Parameters.Clear;
    QryAx2.SQL.Add('SELECT SUM(cmo.valor) valor');
    QryAx2.SQL.Add('      FROM caixa_movimento cmo');
    QryAx2.SQL.Add('     INNER JOIN caixa cai');
    QryAx2.SQL.Add('        ON cai.id = cmo.caixa_id');
    QryAx2.SQL.Add('     INNER JOIN condicoes_pagamento cp');
    QryAx2.SQL.Add('        ON cp.id = cmo.forma_pagamento_id');
    QryAx2.SQL.Add('     WHERE cai.id = '+ IntToStr(Caixa_id) +'');
    if Natureza <> '' then
      QryAx2.SQL.Add('     AND cmo.natureza = '''+ Natureza +'''');
    if Operacao <> '' then
      QryAx2.SQL.Add('     AND cmo.operacao = '''+ Operacao +'''');
    CdsAx2.Open;

    Result := CdsAx2.FieldByName('valor').AsFloat;
  end;
end;


procedure TControleCadastroCaixa.SomaValores;
begin
  UniLabelSangria.Caption     :=  FormatFloat('#,##0.00;(#,##0.00)', (SomaValorPorNatureza(CdsCadastroID.AsInteger,
                                                                     'SA',
                                                                     'D')));

  UniLabelSuprimento.Caption  :=  FormatFloat('#,##0.00;(#,##0.00)', (SomaValorPorNatureza(CdsCadastroID.AsInteger,
                                                                     'SU',
                                                                     'C')));

  UniLabelEstorno.Caption     :=  FormatFloat('#,##0.00;(#,##0.00)', (SomaValorPorNatureza(CdsCadastroID.AsInteger,
                                                                     '',
                                                                     'E')));

  UniLabelPagamento.Caption   :=  FormatFloat('#,##0.00;(#,##0.00)', (SomaValorPorNatureza(CdsCadastroID.AsInteger,
                                                                     'PG',
                                                                     'D')));

  UniLabelRecebimento.Caption :=  FormatFloat('#,##0.00;(#,##0.00)', (SomaValorPorNatureza(CdsCadastroID.AsInteger,
                                                                     'RC',
                                                                     'C')));

end;



function TControleCadastroCaixa.TemPermissaoSuperior :String;
var
    SenhaDigitada : string;
    MD5: TIdHashMessageDigest5;
    UsuarioTemPermissao : string;
begin
  inherited;
  result := '';

  // Encripta a senha em Hash MD5
  MD5 := TIdHashMessageDigest5.Create;
  try
    SenhaDigitada := MD5.HashStringAsHex(UniSweetAlertReabrirCaixaDiaAnterior.InputResult);

  finally
    MD5.Free;
  end;

  //Procura senha no banco
  UsuarioTemPermissao := ControleMainModule.ProcuraUsuarioPermissaoDelTitulo(SenhaDigitada);

  //verifica qual foi o retorno e executa
  case AnsiIndexStr(UsuarioTemPermissao,['P','B']) of
    0:begin
         result := 'P'
      end;

    1:begin
         result := 'B'
      end;
  else
    result := 'N'
  end;
end;

end.
