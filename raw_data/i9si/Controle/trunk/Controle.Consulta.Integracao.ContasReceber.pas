unit Controle.Consulta.Integracao.ContasReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Moni.Base, FireDAC.Moni.FlatFile,
  FireDAC.Phys.IBBase, uniGUIBaseClasses, uniImageList, uniGridExporters,
  uniBasicGrid, uniLabel, uniEdit, uniPanel, uniDBGrid, uniButton, uniTimer,
  Vcl.Menus, uniMainMenu, uniCheckBox, Datasnap.DBClient,
  System.Generics.Collections, uniMemo;

type
  TControleConsultaIntegracaoContasReceber = class(TUniFrame)
    UniPanel2: TUniPanel;
    GrdResultado: TUniDBGrid;
    UniPanelLeft: TUniPanel;
    UniHiddenPanel1: TUniHiddenPanel;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    UniEdit6: TUniEdit;
    UniEdit7: TUniEdit;
    UniPanelRight: TUniPanel;
    UniGridHTMLExporter1: TUniGridHTMLExporter;
    UniGridExcelExporter2: TUniGridExcelExporter;
    UniGridExcelExporter1: TUniGridExcelExporter;
    UniImageListExportar: TUniImageList;
    UniImageList1: TUniImageList;
    DataSource1: TDataSource;
    FDQuery1: TFDQuery;
    UniEdit8: TUniEdit;
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
    UniPanel1: TUniPanel;
    PanelTopBarraDireita: TUniPanel;
    botaoExportar: TUniButton;
    UniPanel21: TUniPanel;
    UniPopupMenuExportar: TUniPopupMenu;
    Exportardadosexcel1: TUniMenuItem;
    Exportardadoshtml1: TUniMenuItem;
    UniPanel3: TUniPanel;
    LabelQtdTituloGerar: TUniLabel;
    BotaoCalcular: TUniButton;
    CdsTitulosGerar: TClientDataSet;
    CdsTitulosGerarDIAS_ATRASO: TIntegerField;
    CdsTitulosGerarVALOR_CORRIGIDO: TFloatField;
    CdsTitulosGerarNUMERO_REFERENCIA: TIntegerField;
    CdsTitulosGerarSomaValorTotal: TAggregateField;
    CdsTitulosGerarMediaDiasAtraso: TAggregateField;
    FDQuery2: TFDQuery;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    FloatField1: TFloatField;
    DateField1: TDateField;
    IntegerField2: TIntegerField;
    StringField2: TStringField;
    FDQuery1NUMPEDIDO: TIntegerField;
    FDQuery1VALOR: TFloatField;
    FDQuery1VENCIM: TDateField;
    FDQuery1DIAS_ATRASO: TIntegerField;
    FDQuery1TRANSFERIDO: TStringField;
    FDQuery1CODIGO: TIntegerField;
    FDQuery1NOME: TStringField;
    FDQuery1RAZAOSOCIAL: TStringField;
    FDQuery1ENDERECO: TStringField;
    FDQuery1BAIRRO: TStringField;
    FDQuery1CNPJCPF: TStringField;
    FDQuery1INSCRG: TStringField;
    FDQuery1ESTADO: TStringField;
    FDQuery1CEP: TStringField;
    FDQuery1FONES: TStringField;
    FDQuery1FAX: TStringField;
    FDQuery1CELULAR: TStringField;
    FDQuery1EMAIL: TStringField;
    FDQuery1DTNASC: TDateField;
    FDQuery1DTCAD: TDateField;
    FDQuery1OBS: TMemoField;
    FDQuery1SEXO: TStringField;
    FDQuery1ESTCIV: TStringField;
    FDQuery1MAE: TStringField;
    FDQuery1PAI: TStringField;
    UniPanel6: TUniPanel;
    UniLabelValorTitulos: TUniFormattedNumberEdit;
    FDQuery1SomaValor: TAggregateField;
    procedure UniFrameCreate(Sender: TObject);
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
    procedure botaoExportarClick(Sender: TObject);
    procedure Exportardadosexcel1Click(Sender: TObject);
    procedure Exportardadoshtml1Click(Sender: TObject);
    procedure FDQuery1TRANSFERIDOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure GrdResultadoDrawColumnCell(Sender: TObject; ACol, ARow: Integer;
      Column: TUniDBGridColumn; Attribs: TUniCellAttribs);
    procedure BotaoCalcularClick(Sender: TObject);
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
    procedure FDQuery1AfterOpen(DataSet: TDataSet);
    procedure FDQuery1AfterRefresh(DataSet: TDataSet);
  private
    cnpj_cpf_utilizado: string;
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
  uniGUIApplication, Controle.Consulta.Geracao.Documento, Controle.Main,
  Controle.Operacoes.Integracao.CalculoJuros, Controle.Main.Module,
  Controle.Operacoes.Integracao.NegociarTituloReceber, Controle.Funcoes,
  Controle.Consulta.Modal.Pessoa.TituloReceber;

{$R *.dfm}

// colocar dias em atraso e taxa de juros

procedure TControleConsultaIntegracaoContasReceber.BotaoCalcularClick(
  Sender: TObject);
var
  qtdlabel : Integer;
  CdsCliente: TClientDataSet;
begin
  // Verificando se o cpf/cnpj está cadastrado no banco do controle
  CdsCliente := TClientDataSet.Create(UniApplication);
  CdsCliente := ControleMainModule.SelecionaCliente(ControleFuncoes.RemoveMascara(Trim(FDQuery1.FieldByName('cnpjcpf').AsString)));

  if CdsCliente.RecordCount = 0 {Encontrou o cliente} then
  begin
    // se o cliente existir no gestor então importa o mesmo
    if ControleMainModule.CadastraClienteDoFirebird(FDQuery1) then
    begin
      CdsCliente := ControleMainModule.SelecionaCliente(ControleFuncoes.RemoveMascara(Trim(FDQuery1.FieldByName('cnpjcpf').AsString)));
    end;
  end;

  ControleMainModule.cnpj_cpf_cliente_integracao := ControleFuncoes.RemoveMascara(Trim(FDQuery1.FieldByName('cnpjcpf').AsString));

  if CdsTitulosGerar.RecordCount = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Selecione pelo menos um título para calcular os juros!');
    Exit;
  end;

  ControleOperacoesIntegracaoCalculoJuros.UniEdtValorOriginal.Text := CdsTitulosGerarSomaValorTotal.AsString;
  ControleOperacoesIntegracaoCalculoJuros.UniEdtDiasAtraso.Text    := CdsTitulosGerarMediaDiasAtraso.AsString;
  ControleOperacoesIntegracaoCalculoJuros.UniEdtMultaAtraso.Text   := FloatToStr(ControleMainModule.percentual_multa);
  ControleOperacoesIntegracaoCalculoJuros.UniEdtJurosMes.Text      := FloatToStr(ControleMainModule.percentual_juros);

  ControleOperacoesIntegracaoCalculoJuros.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      ControleOperacoesIntegracaoNegociarTituloReceber.OperacaoTitulos        := 'Ped. Integração nº ';
      ControleOperacoesIntegracaoNegociarTituloReceber.UniDataVencimento.Text := ControleOperacoesIntegracaoCalculoJuros.UniDateTitulo.Text;
      ControleOperacoesIntegracaoNegociarTituloReceber.UniEdtValor.Text       := ControleOperacoesIntegracaoCalculoJuros.UniEdtValorAtualizado.Text;

      ControleOperacoesIntegracaoNegociarTituloReceber.CdsTitulosGerado := CdsTitulosGerar;

      ControleOperacoesIntegracaoNegociarTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        if Result = 1 then
        begin
          CdsTitulosGerar.First;
          while not CdsTitulosGerar.Eof do
          begin
            if Fdquery1.Locate('NUMPEDIDO', CdsTitulosGerar.FieldByName('NUMERO_REFERENCIA').AsString, []) then
            begin
              FDQuery1.Edit;
              FDQuery1TRANSFERIDO.AsString := 'S';
              FDQuery1.Post;
            end;
            CdsTitulosGerar.Next;
          end;

          CdsTitulosGerar.First;
          while not CdsTitulosGerar.Eof do
          begin
            CdsTitulosGerar.Delete;
          end;

          cnpj_cpf_utilizado := '';

          qtdlabel := 0;
          LabelQtdTituloGerar.Caption := IntToStr(qtdlabel);
        end;
      end);
    end;
  end
  );

  //ControleOperacoesIntegracaoCalculoJuros.UniEdtValorAtualizado.Text    := FDQuery1VALOR.AsString;
end;

procedure TControleConsultaIntegracaoContasReceber.botaoExportarClick(
  Sender: TObject);
begin
  UniPopupMenuExportar.Popup(ControleMain.PosicaoMouseX +10,ControleMain.PosicaoMouseY +10) ;
end;

procedure TControleConsultaIntegracaoContasReceber.Exportardadosexcel1Click(
  Sender: TObject);
begin
  // Abre o formulário em modal e aguarda
  self.ShowMask('Carregando');
  UniSession.Synchronize();
  GrdResultado.Exporter.Exporter := UniGridExcelExporter2;
  GrdResultado.Exporter.ExportGrid;
  self.HideMask;
end;

procedure TControleConsultaIntegracaoContasReceber.Exportardadoshtml1Click(
  Sender: TObject);
begin
  // Abre o formulário em modal e aguarda
  self.ShowMask('Carregando');
  UniSession.Synchronize();
  GrdResultado.Exporter.Exporter := UniGridhtmlExporter1;
  GrdResultado.Exporter.ExportGrid;
  self.HideMask;
end;

procedure TControleConsultaIntegracaoContasReceber.FDQuery1AfterOpen(
  DataSet: TDataSet);
begin
  UniLabelValorTitulos.Text := FDQuery1SomaValor.AsString;
end;

procedure TControleConsultaIntegracaoContasReceber.FDQuery1AfterRefresh(
  DataSet: TDataSet);
begin
  UniLabelValorTitulos.Text := FDQuery1SomaValor.AsString;
end;

procedure TControleConsultaIntegracaoContasReceber.FDQuery1TRANSFERIDOGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if Sender.AsString = 'S' then
    Text := '<img src=./files/icones/check-outline.png height=20 align="center" />'
  else if Sender.AsString = 'N' then
    Text := '<img src=./files/icones/transfer.png height=20 align="center" />'
  else if Sender.AsString = 'T' then
    Text := '<img src=./files/icones/transfer_yellow.png height=20 align="center" />'
  else
    Text := '<img src=./files/icones/transfer.png height=20 align="center" />';
end;

procedure TControleConsultaIntegracaoContasReceber.GrdResultadoCellClick(
  Column: TUniDBGridColumn);
var
  qtdlabel, I : integer;
  FoundIndex: Integer;
begin
  if CdsTitulosGerar.RecordCount = 0 then
  begin
    cnpj_cpf_utilizado := FDQuery1.FieldByName('cnpjcpf').AsString;
  end;

  if cnpj_cpf_utilizado <> FDQuery1.FieldByName('cnpjcpf').AsString then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não é possível calcular/gerar título de clientes diferentes!');
    FDQuery1.Edit;
    FDQuery1.FieldByName('cnpjcpf').AsString := cnpj_cpf_utilizado;
    FDQuery1.Post;
    Abort;
  end;

  if Column.FieldName = 'TRANSFERIDO' then
  begin
    if (FDQuery1TRANSFERIDO.AsString = 'N') or (FDQuery1TRANSFERIDO.AsString = '') then
    begin
      // Verificando se já foi inserido no cds temporario
      FDQuery1.Edit;
      FDQuery1TRANSFERIDO.AsString := 'T';
      FDQuery1.Post;

      // Alimentando o cds temporario para fazer a nagociação
      CdsTitulosGerar.Insert;
      CdsTitulosGerarNUMERO_REFERENCIA.AsString := FDQuery1.FieldByName('NUMPEDIDO').AsString;
      CdsTitulosGerarDIAS_ATRASO.AsInteger      := FDQuery1.FieldByName('DIAS_ATRASO').AsInteger;
      CdsTitulosGerarVALOR_CORRIGIDO.AsFloat    := FDQuery1.FieldByName('VALOR').AsFloat;
      CdsTitulosGerar.Post;

      // Alterando o label
      qtdlabel := StrToInt(LabelQtdTituloGerar.Caption);
      qtdlabel := qtdlabel + 1;
      LabelQtdTituloGerar.Caption := IntToStr(qtdlabel);

      if FDQuery1.FieldByName('cnpjcpf').AsString = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'O cliente não possui cpf cadastrado, não é possível fazer a importação do mesmo!');
      end;
    end
    else if FDQuery1TRANSFERIDO.AsString = 'S' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'O título já foi transportado para o sistema!');
    end
    else if FDQuery1TRANSFERIDO.AsString = 'T' then
    begin
      // Verificando se já foi inserido no cds temporario
      FDQuery1.Edit;
      FDQuery1TRANSFERIDO.AsString := 'N';
      FDQuery1.Post;

      // Alimentando o cds temporario
      if CdsTitulosGerar.Locate('NUMERO_REFERENCIA', FDQuery1.FieldByName('NUMPEDIDO').AsString, []) then
        CdsTitulosGerar.Delete;

      qtdlabel := StrToInt(LabelQtdTituloGerar.Caption);
      qtdlabel := qtdlabel - 1;
      LabelQtdTituloGerar.Caption := IntToStr(qtdlabel);
    end;
  end;
end;

procedure TControleConsultaIntegracaoContasReceber.GrdResultadoColumnFilter(
  Sender: TUniDBGrid; const Column: TUniDBGridColumn; const Value: Variant);
var
  V : Variant;
  I : Integer;
begin
  if FDQuery1.Active then
  begin
    for I := 0 to Sender.Columns.Count - 1  do
    if Sender.Columns[I].Filtering.Enabled then
    begin
      V := StringReplace(Sender.Columns[I].Filtering.VarValue, ',', '.', [rfReplaceAll]);
      V := StringReplace(V,'/','-',[rfReplaceAll]);
      FDQuery1.ParamByName(Sender.Columns[I].FieldName).Value := '%'+V+'%';
    end;
    FDQuery1.Refresh;
  end;
end;

procedure TControleConsultaIntegracaoContasReceber.GrdResultadoDrawColumnCell(
  Sender: TObject; ACol, ARow: Integer; Column: TUniDBGridColumn;
  Attribs: TUniCellAttribs);
begin
  if Column.FieldName = 'DIAS_ATRASO' then
  begin
    if StrToFloatDef(FDQuery1.FieldByName('DIAS_ATRASO').AsString,0) > 0 then
    begin
      Attribs.Font.Color := clRed;
      Attribs.Font.Style := [fsBold];
    end
    else
    begin
      Attribs.Font.Color := clBlue;
      Attribs.Font.Style := [];
    end;
  end;
end;

procedure TControleConsultaIntegracaoContasReceber.UniFrameCreate(
  Sender: TObject);
begin
  with ControleMainModule do
  begin
    if ConectaBancoIntegracao then
    begin
      With FDQuery2 do
      begin
        SQL.Clear;
        SQL.Add('UPDATE receber');
        SQL.Add('   SET transferido = ''N''');
        SQL.Add(' WHERE transferido = ''T''');
        ExecSQL;
      end;
      FDQuery1.Open();
    end
    else
    begin
      MensageiroSweetAlerta('Atenção!' , 'Não foi possível contectar ao banco de dados de integração configurado no config.ini')
    end;
  end;
end;

end.
